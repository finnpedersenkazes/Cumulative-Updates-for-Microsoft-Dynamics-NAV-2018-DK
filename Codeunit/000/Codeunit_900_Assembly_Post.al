OBJECT Codeunit 900 Assembly-Post
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    TableNo=900;
    Permissions=TableData 910=im,
                TableData 911=im,
                TableData 6507=i;
    OnRun=VAR
            AssemblyHeader@1007 : Record 900;
          BEGIN
            OnBeforeOnRun(AssemblyHeader);

            // Replace posting date if called from batch posting
            ValidatePostingDate(Rec);

            CLEARALL;
            AssemblyHeader := Rec;

            IF IsAsmToOrder THEN
              TESTFIELD("Assemble to Order",FALSE);

            OpenWindow("Document Type");
            Window.UPDATE(1,STRSUBSTNO('%1 %2',"Document Type","No."));

            InitPost(AssemblyHeader);
            Post(AssemblyHeader,ItemJnlPostLine,ResJnlPostLine,WhseJnlRegisterLine);
            FinalizePost(AssemblyHeader);
            COMMIT;

            Window.CLOSE;
            Rec := AssemblyHeader;

            OnAfterOnRun(AssemblyHeader);
          END;

  }
  CODE
  {
    VAR
      GLEntry@1010 : Record 17;
      GLSetup@1012 : Record 98;
      AssembledItem@1007 : Record 27;
      TempItemLedgEntry@1027 : TEMPORARY Record 32;
      DimMgt@1008 : Codeunit 408;
      ItemJnlPostLine@1022 : Codeunit 22;
      ResJnlPostLine@1018 : Codeunit 212;
      WhseJnlRegisterLine@1017 : Codeunit 7301;
      UndoPostingMgt@1026 : Codeunit 5817;
      Window@1015 : Dialog;
      PostingDate@1016 : Date;
      SourceCode@1000 : Code[10];
      PostingDateExists@1019 : Boolean;
      ReplacePostingDate@1020 : Boolean;
      Text001@1001 : TextConst '@@@=starts with "Posting Date";DAN=er ikke inden for den tilladte bogf�ringsperiode.;ENU=is not within your range of allowed posting dates.';
      Text002@1003 : TextConst '@@@="%1 = Document Type, %2 = Document No.";DAN=Kombinationen af dimensioner, der bliver brugt i %1 %2, er sp�rret. %3.;ENU=The combination of dimensions used in %1 %2 is blocked. %3.';
      Text003@1002 : TextConst '@@@="%1 = Document Type, %2 = Document No.";DAN=Kombinationen af de dimensioner, der bliver brugt i %1 %2, linjenr. %3, er sp�rret. %4.;ENU=The combination of dimensions used in %1 %2, line no. %3 is blocked. %4.';
      Text004@1005 : TextConst '@@@="%1 = Document Type, %2 = Document No.";DAN=De dimensioner, der bruges i %1 %2, er ikke gyldige. %3.;ENU=The dimensions that are used in %1 %2 are not valid. %3.';
      Text005@1004 : TextConst '@@@="%1 = Document Type, %2 = Document No.";DAN=De dimensioner, der bruges i %1 %2, linjenr. %3, er ikke gyldige. %4.;ENU=The dimensions that are used in %1 %2, line no. %3, are not valid. %4.';
      Text006@1009 : TextConst 'DAN=Der er intet at bogf�re.;ENU=There is nothing to post.';
      Text007@1006 : TextConst 'DAN=Linjer bogf�res            #2######;ENU=Posting lines              #2######';
      GLSetupRead@1011 : Boolean;
      Text008@1014 : TextConst 'DAN=Bogf�ring %1;ENU=Posting %1';
      Text009@1013 : TextConst 'DAN=%1 skal v�re tomt til bem�rkningstekst: %2.;ENU=%1 should be blank for comment text: %2.';
      ShowProgress@1021 : Boolean;
      Text010@1024 : TextConst 'DAN=Annullerer %1;ENU=Undoing %1';
      Text011@1025 : TextConst '@@@="%1=Posted Assembly Order No. field value,%2=Assembly Header Document No field value";DAN=Den bogf�rte montageordre %1 kan ikke gendannes, da antallet af linjer i montageordre %2 er �ndret.;ENU=Posted assembly order %1 cannot be restored because the number of lines in assembly order %2 has changed.';

    LOCAL PROCEDURE InitPost@17(VAR AssemblyHeader@1000 : Record 900);
    VAR
      GenJnlCheckLine@1002 : Codeunit 11;
      NoSeriesMgt@1001 : Codeunit 396;
      GenJnlPostPreview@1003 : Codeunit 19;
    BEGIN
      OnBeforeInitPost(AssemblyHeader);

      WITH AssemblyHeader DO BEGIN
        TESTFIELD("Document Type");
        TESTFIELD("Posting Date");
        PostingDate := "Posting Date";
        IF GenJnlCheckLine.DateNotAllowed("Posting Date") THEN
          FIELDERROR("Posting Date",Text001);
        TESTFIELD("Item No.");
        CheckDim(AssemblyHeader);
        IF NOT IsOrderPostable(AssemblyHeader) THEN
          ERROR(Text006);

        IF "Posting No." = '' THEN
          IF "Document Type" = "Document Type"::Order THEN BEGIN
            TESTFIELD("Posting No. Series");
            "Posting No." := NoSeriesMgt.GetNextNo("Posting No. Series","Posting Date",TRUE);
            IF NOT GenJnlPostPreview.IsActive THEN BEGIN
              MODIFY;
              COMMIT;
            END;
          END;

        IF Status = Status::Open THEN BEGIN
          CODEUNIT.RUN(CODEUNIT::"Release Assembly Document",AssemblyHeader);
          TESTFIELD(Status,Status::Released);
          Status := Status::Open;
          IF NOT GenJnlPostPreview.IsActive THEN BEGIN
            MODIFY;
            COMMIT;
          END;
          Status := Status::Released;
        END;

        GetSourceCode(IsAsmToOrder);
      END;

      OnAfterInitPost(AssemblyHeader);
    END;

    LOCAL PROCEDURE Post@18(VAR AssemblyHeader@1000 : Record 900;VAR ItemJnlPostLine@1001 : Codeunit 22;VAR ResJnlPostLine@1002 : Codeunit 212;VAR WhseJnlRegisterLine@1003 : Codeunit 7301);
    VAR
      AssemblyLine@1011 : Record 901;
      PostedAssemblyHeader@1010 : Record 910;
      AssemblySetup@1009 : Record 905;
      AssemblyCommentLine@1008 : Record 906;
      RecordLinkManagement@1004 : Codeunit 447;
    BEGIN
      OnBeforePost(AssemblyHeader);

      WITH AssemblyHeader DO BEGIN
        SuspendStatusCheck(TRUE);
        LockTables(AssemblyLine,AssemblyHeader);

        // Insert posted assembly header
        IF "Document Type" = "Document Type"::Order THEN BEGIN
          PostedAssemblyHeader.INIT;
          PostedAssemblyHeader.TRANSFERFIELDS(AssemblyHeader);

          PostedAssemblyHeader."No." := "Posting No.";
          PostedAssemblyHeader."Order No. Series" := "No. Series";
          PostedAssemblyHeader."Order No." := "No.";
          PostedAssemblyHeader."Source Code" := SourceCode;
          PostedAssemblyHeader."User ID" := USERID;
          PostedAssemblyHeader.INSERT;

          AssemblySetup.GET;
          IF AssemblySetup."Copy Comments when Posting" THEN BEGIN
            CopyCommentLines(
              "Document Type",AssemblyCommentLine."Document Type"::"Posted Assembly",
              "No.",PostedAssemblyHeader."No.");
            RecordLinkManagement.CopyLinks(AssemblyHeader,PostedAssemblyHeader);
          END;
        END;

        AssembledItem.GET("Item No.");
        TESTFIELD("Document Type","Document Type"::Order);
        PostLines(AssemblyHeader,AssemblyLine,PostedAssemblyHeader,ItemJnlPostLine,ResJnlPostLine,WhseJnlRegisterLine);
        PostHeader(AssemblyHeader,PostedAssemblyHeader,ItemJnlPostLine,WhseJnlRegisterLine);
      END;

      OnAfterPost(AssemblyHeader);
    END;

    LOCAL PROCEDURE FinalizePost@19(AssemblyHeader@1000 : Record 900);
    VAR
      AssemblyLine@1009 : Record 901;
      AssemblyCommentLine@1006 : Record 906;
      AssemblyLineReserve@1001 : Codeunit 926;
    BEGIN
      OnBeforeFinalizePost(AssemblyHeader);

      MakeInvtAdjmt;

      WITH AssemblyHeader DO BEGIN
        // Delete header and lines
        AssemblyLine.RESET;
        AssemblyLine.SETRANGE("Document Type","Document Type");
        AssemblyLine.SETRANGE("Document No.","No.");
        IF "Remaining Quantity (Base)" = 0 THEN BEGIN
          IF HASLINKS THEN
            DELETELINKS;
          DeleteWhseRequest(AssemblyHeader);
          DELETE;
          IF AssemblyLine.FIND('-') THEN
            REPEAT
              IF AssemblyLine.HASLINKS THEN
                DELETELINKS;
              AssemblyLineReserve.SetDeleteItemTracking(TRUE);
              AssemblyLineReserve.DeleteLine(AssemblyLine);
            UNTIL AssemblyLine.NEXT = 0;
          AssemblyLine.DELETEALL;
          AssemblyCommentLine.SETCURRENTKEY("Document Type","Document No.");
          AssemblyCommentLine.SETRANGE("Document Type","Document Type");
          AssemblyCommentLine.SETRANGE("Document No.","No.");
          IF NOT AssemblyCommentLine.ISEMPTY THEN
            AssemblyCommentLine.DELETEALL;
        END;
      END;

      OnAfterFinalizePost(AssemblyHeader);
    END;

    LOCAL PROCEDURE OpenWindow@20(DocType@1000 : Option);
    VAR
      AsmHeader@1001 : Record 900;
    BEGIN
      AsmHeader."Document Type" := DocType;
      IF AsmHeader."Document Type" = AsmHeader."Document Type"::Order THEN
        Window.OPEN(
          '#1#################################\\' +
          Text007 + '\\' +
          STRSUBSTNO(Text008,AsmHeader."Document Type"));
      ShowProgress := TRUE;
    END;

    [External]
    PROCEDURE SetPostingDate@1(NewReplacePostingDate@1000 : Boolean;NewPostingDate@1002 : Date);
    BEGIN
      PostingDateExists := TRUE;
      ReplacePostingDate := NewReplacePostingDate;
      PostingDate := NewPostingDate;
    END;

    LOCAL PROCEDURE ValidatePostingDate@49(VAR AssemblyHeader@1001 : Record 900);
    VAR
      BatchProcessingMgt@1000 : Codeunit 1380;
      BatchPostParameterTypes@1002 : Codeunit 1370;
    BEGIN
      IF NOT PostingDateExists THEN
        PostingDateExists :=
          BatchProcessingMgt.GetParameterBoolean(
            AssemblyHeader.RECORDID,BatchPostParameterTypes.ReplacePostingDate,ReplacePostingDate) AND
          BatchProcessingMgt.GetParameterDate(AssemblyHeader.RECORDID,BatchPostParameterTypes.PostingDate,PostingDate);

      IF PostingDateExists AND (ReplacePostingDate OR (AssemblyHeader."Posting Date" = 0D)) THEN
        AssemblyHeader."Posting Date" := PostingDate;
    END;

    LOCAL PROCEDURE CheckDim@34(AssemblyHeader@1000 : Record 900);
    VAR
      AssemblyLine@1001 : Record 901;
    BEGIN
      AssemblyLine."Line No." := 0;
      CheckDimValuePosting(AssemblyHeader,AssemblyLine);
      CheckDimComb(AssemblyHeader,AssemblyLine);

      AssemblyLine.SETRANGE("Document Type",AssemblyHeader."Document Type");
      AssemblyLine.SETRANGE("Document No.",AssemblyHeader."No.");
      AssemblyLine.SETFILTER(Type,'<>%1',AssemblyLine.Type::" ");
      IF AssemblyLine.FIND('-') THEN
        REPEAT
          IF AssemblyHeader."Quantity to Assemble" <> 0 THEN BEGIN
            CheckDimComb(AssemblyHeader,AssemblyLine);
            CheckDimValuePosting(AssemblyHeader,AssemblyLine);
          END;
        UNTIL AssemblyLine.NEXT = 0;
    END;

    LOCAL PROCEDURE CheckDimComb@30(AssemblyHeader@1001 : Record 900;AssemblyLine@1000 : Record 901);
    BEGIN
      IF AssemblyLine."Line No." = 0 THEN
        IF NOT DimMgt.CheckDimIDComb(AssemblyHeader."Dimension Set ID") THEN
          ERROR(Text002,AssemblyHeader."Document Type",AssemblyHeader."No.",DimMgt.GetDimCombErr);

      IF AssemblyLine."Line No." <> 0 THEN
        IF NOT DimMgt.CheckDimIDComb(AssemblyLine."Dimension Set ID") THEN
          ERROR(Text003,AssemblyHeader."Document Type",AssemblyHeader."No.",AssemblyLine."Line No.",DimMgt.GetDimCombErr);
    END;

    LOCAL PROCEDURE CheckDimValuePosting@28(AssemblyHeader@1001 : Record 900;VAR AssemblyLine@1000 : Record 901);
    VAR
      TableIDArr@1002 : ARRAY [10] OF Integer;
      NumberArr@1003 : ARRAY [10] OF Code[20];
    BEGIN
      IF AssemblyLine."Line No." = 0 THEN BEGIN
        TableIDArr[1] := DATABASE::Item;
        NumberArr[1] := AssemblyHeader."Item No.";
        IF NOT DimMgt.CheckDimValuePosting(TableIDArr,NumberArr,AssemblyHeader."Dimension Set ID") THEN
          ERROR(
            Text004,
            AssemblyHeader."Document Type",AssemblyHeader."No.",DimMgt.GetDimValuePostingErr);
      END ELSE BEGIN
        TableIDArr[1] := DimMgt.TypeToTableID4(AssemblyLine.Type);
        NumberArr[1] := AssemblyLine."No.";
        IF NOT DimMgt.CheckDimValuePosting(TableIDArr,NumberArr,AssemblyLine."Dimension Set ID") THEN
          ERROR(
            Text005,
            AssemblyHeader."Document Type",AssemblyHeader."No.",AssemblyLine."Line No.",DimMgt.GetDimValuePostingErr);
      END;
    END;

    LOCAL PROCEDURE IsOrderPostable@23(AssemblyHeader@1000 : Record 900) : Boolean;
    VAR
      AssemblyLine@1001 : Record 901;
    BEGIN
      IF AssemblyHeader."Document Type" <> AssemblyHeader."Document Type"::Order THEN
        EXIT(FALSE);

      IF AssemblyHeader."Quantity to Assemble" = 0 THEN
        EXIT(FALSE);

      AssemblyLine.SETCURRENTKEY("Document Type","Document No.",Type);
      AssemblyLine.SETRANGE("Document Type",AssemblyHeader."Document Type");
      AssemblyLine.SETRANGE("Document No.",AssemblyHeader."No.");

      AssemblyLine.SETFILTER(Type,'<>%1',AssemblyLine.Type::" ");
      IF AssemblyLine.ISEMPTY THEN
        EXIT(FALSE);

      AssemblyLine.SETFILTER("Quantity to Consume",'<>0');
      EXIT(NOT AssemblyLine.ISEMPTY);
    END;

    LOCAL PROCEDURE GetGLSetup@60();
    BEGIN
      IF NOT GLSetupRead THEN
        GLSetup.GET;
      GLSetupRead := TRUE;
    END;

    LOCAL PROCEDURE LockTables@13(VAR AssemblyLine@1000 : Record 901;VAR AssemblyHeader@1002 : Record 900);
    VAR
      GLSetup@1001 : Record 98;
    BEGIN
      AssemblyLine.LOCKTABLE;
      AssemblyHeader.LOCKTABLE;
      GetGLSetup;
      IF NOT GLSetup.OptimGLEntLockForMultiuserEnv THEN BEGIN
        GLEntry.LOCKTABLE;
        IF GLEntry.FINDLAST THEN;
      END;
    END;

    LOCAL PROCEDURE CopyCommentLines@10(FromDocumentType@1003 : Integer;ToDocumentType@1002 : Integer;FromNumber@1001 : Code[20];ToNumber@1000 : Code[20]);
    VAR
      AssemblyCommentLine@1004 : Record 906;
      AssemblyCommentLine2@1005 : Record 906;
    BEGIN
      AssemblyCommentLine.SETRANGE("Document Type",FromDocumentType);
      AssemblyCommentLine.SETRANGE("Document No.",FromNumber);
      IF AssemblyCommentLine.FIND('-') THEN
        REPEAT
          AssemblyCommentLine2 := AssemblyCommentLine;
          AssemblyCommentLine2."Document Type" := ToDocumentType;
          AssemblyCommentLine2."Document No." := ToNumber;
          AssemblyCommentLine2.INSERT;
        UNTIL AssemblyCommentLine.NEXT = 0;
    END;

    LOCAL PROCEDURE SortLines@14(VAR AssemblyLine@1000 : Record 901);
    VAR
      GLSetup@1001 : Record 98;
    BEGIN
      GetGLSetup;
      IF GLSetup.OptimGLEntLockForMultiuserEnv THEN
        AssemblyLine.SETCURRENTKEY("Document Type",Type,"No.")
      ELSE
        AssemblyLine.SETCURRENTKEY("Document Type","Document No.","Line No.");
    END;

    LOCAL PROCEDURE SortPostedLines@33(VAR PostedAsmLine@1000 : Record 911);
    VAR
      GLSetup@1001 : Record 98;
    BEGIN
      GetGLSetup;
      IF GLSetup.OptimGLEntLockForMultiuserEnv THEN
        PostedAsmLine.SETCURRENTKEY(Type,"No.")
      ELSE
        PostedAsmLine.SETCURRENTKEY("Document No.","Line No.");
    END;

    LOCAL PROCEDURE GetLineQtys@3(VAR LineQty@1000 : Decimal;VAR LineQtyBase@1001 : Decimal;AssemblyLine@1003 : Record 901);
    BEGIN
      WITH AssemblyLine DO BEGIN
        LineQty := ROUND("Quantity to Consume",0.00001);
        LineQtyBase := ROUND("Quantity to Consume (Base)",0.00001);
      END;
    END;

    LOCAL PROCEDURE GetHeaderQtys@8(VAR HeaderQty@1000 : Decimal;VAR HeaderQtyBase@1001 : Decimal;AssemblyHeader@1002 : Record 900);
    BEGIN
      WITH AssemblyHeader DO BEGIN
        HeaderQty := ROUND("Quantity to Assemble",0.00001);
        HeaderQtyBase := ROUND("Quantity to Assemble (Base)",0.00001);
      END;
    END;

    LOCAL PROCEDURE PostLines@24(AssemblyHeader@1000 : Record 900;VAR AssemblyLine@1009 : Record 901;PostedAssemblyHeader@1001 : Record 910;VAR ItemJnlPostLine@1007 : Codeunit 22;VAR ResJnlPostLine@1006 : Codeunit 212;VAR WhseJnlRegisterLine@1008 : Codeunit 7301);
    VAR
      PostedAssemblyLine@1005 : Record 911;
      LineCounter@1004 : Integer;
      QtyToConsume@1003 : Decimal;
      QtyToConsumeBase@1002 : Decimal;
      ItemLedgEntryNo@1010 : Integer;
    BEGIN
      WITH AssemblyLine DO BEGIN
        RESET;
        SETRANGE("Document Type",AssemblyHeader."Document Type");
        SETRANGE("Document No.",AssemblyHeader."No.");
        SortLines(AssemblyLine);

        LineCounter := 0;
        IF FINDSET THEN
          REPEAT
            IF ("No." = '') AND
               (Description <> '') AND
               (Type <> Type::" ")
            THEN
              ERROR(Text009,FIELDCAPTION(Type),Description);

            LineCounter := LineCounter + 1;
            IF ShowProgress THEN
              Window.UPDATE(2,LineCounter);

            GetLineQtys(QtyToConsume,QtyToConsumeBase,AssemblyLine);

            ItemLedgEntryNo := 0;
            IF QtyToConsumeBase <> 0 THEN BEGIN
              CASE Type OF
                Type::Item:
                  ItemLedgEntryNo :=
                    PostItemConsumption(
                      AssemblyHeader,
                      AssemblyLine,
                      AssemblyHeader."Posting No. Series",
                      QtyToConsume,
                      QtyToConsumeBase,ItemJnlPostLine,WhseJnlRegisterLine,AssemblyHeader."Posting No.",FALSE,0);
                Type::Resource:
                  PostResourceConsumption(
                    AssemblyHeader,
                    AssemblyLine,
                    AssemblyHeader."Posting No. Series",
                    QtyToConsume,
                    QtyToConsumeBase,ResJnlPostLine,ItemJnlPostLine,AssemblyHeader."Posting No.",FALSE);
              END;

              // modify the lines
              "Consumed Quantity" := "Consumed Quantity" + QtyToConsume;
              "Consumed Quantity (Base)" := "Consumed Quantity (Base)" + QtyToConsumeBase;
              InitRemainingQty;
              InitQtyToConsume;
              MODIFY;
            END;

            // Insert posted assembly lines
            PostedAssemblyLine.INIT;
            PostedAssemblyLine.TRANSFERFIELDS(AssemblyLine);
            PostedAssemblyLine."Document No." := PostedAssemblyHeader."No.";
            PostedAssemblyLine.Quantity := QtyToConsume;
            PostedAssemblyLine."Quantity (Base)" := QtyToConsumeBase;
            PostedAssemblyLine."Cost Amount" := ROUND(PostedAssemblyLine.Quantity * "Unit Cost");
            PostedAssemblyLine."Order No." := "Document No.";
            PostedAssemblyLine."Order Line No." := "Line No.";
            InsertLineItemEntryRelation(PostedAssemblyLine,ItemJnlPostLine,ItemLedgEntryNo);
            PostedAssemblyLine.INSERT;
            OnAfterPostedAssemblyLineInsert(PostedAssemblyLine,AssemblyLine);
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE PostHeader@25(VAR AssemblyHeader@1000 : Record 900;VAR PostedAssemblyHeader@1001 : Record 910;VAR ItemJnlPostLine@1006 : Codeunit 22;VAR WhseJnlRegisterLine@1005 : Codeunit 7301);
    VAR
      WhseAssemblyRelease@1004 : Codeunit 904;
      ItemLedgEntryNo@1008 : Integer;
      QtyToOutput@1003 : Decimal;
      QtyToOutputBase@1002 : Decimal;
    BEGIN
      WITH AssemblyHeader DO BEGIN
        GetHeaderQtys(QtyToOutput,QtyToOutputBase,AssemblyHeader);
        ItemLedgEntryNo :=
          PostItemOutput(
            AssemblyHeader,"Posting No. Series",
            QtyToOutput,QtyToOutputBase,
            ItemJnlPostLine,WhseJnlRegisterLine,"Posting No.",FALSE,0);

        // modify the header
        "Assembled Quantity" := "Assembled Quantity" + QtyToOutput;
        "Assembled Quantity (Base)" := "Assembled Quantity (Base)" + QtyToOutputBase;
        InitRemainingQty;
        InitQtyToAssemble;
        VALIDATE("Quantity to Assemble");
        "Posting No." := '';
        MODIFY;

        WhseAssemblyRelease.Release(AssemblyHeader);

        // modify the posted assembly header
        PostedAssemblyHeader.Quantity := QtyToOutput;
        PostedAssemblyHeader."Quantity (Base)" := QtyToOutputBase;
        PostedAssemblyHeader."Cost Amount" := ROUND(PostedAssemblyHeader.Quantity * "Unit Cost");

        InsertHeaderItemEntryRelation(PostedAssemblyHeader,ItemJnlPostLine,ItemLedgEntryNo);
        PostedAssemblyHeader.MODIFY;
        OnAfterPostedAssemblyHeaderModify(PostedAssemblyHeader,AssemblyHeader);
      END;
    END;

    LOCAL PROCEDURE PostItemConsumption@2(AssemblyHeader@1003 : Record 900;VAR AssemblyLine@1001 : Record 901;PostingNoSeries@1007 : Code[20];QtyToConsume@1004 : Decimal;QtyToConsumeBase@1005 : Decimal;VAR ItemJnlPostLine@1002 : Codeunit 22;VAR WhseJnlRegisterLine@1006 : Codeunit 7301;DocumentNo@1010 : Code[20];IsCorrection@1011 : Boolean;ApplyToEntryNo@1009 : Integer) : Integer;
    VAR
      ItemJnlLine@1000 : Record 83;
      AssemblyLineReserve@1008 : Codeunit 926;
    BEGIN
      WITH AssemblyLine DO BEGIN
        TESTFIELD(Type,Type::Item);

        ItemJnlLine.INIT;
        ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Assembly Consumption";
        ItemJnlLine."Source Code" := SourceCode;
        ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::"Posted Assembly";
        ItemJnlLine."Document No." := DocumentNo;
        ItemJnlLine."Document Date" := PostingDate;
        ItemJnlLine."Document Line No." := "Line No.";
        ItemJnlLine."Order Type" := ItemJnlLine."Order Type"::Assembly;
        ItemJnlLine."Order No." := "Document No.";
        ItemJnlLine."Order Line No." := "Line No." ;
        ItemJnlLine."Dimension Set ID" := "Dimension Set ID" ;
        ItemJnlLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
        ItemJnlLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
        ItemJnlLine."Source Type" := ItemJnlLine."Source Type"::Item;
        ItemJnlLine."Source No." := AssembledItem."No.";

        ItemJnlLine."Posting Date" := PostingDate;
        ItemJnlLine."Posting No. Series" := PostingNoSeries;
        ItemJnlLine.Type := ItemJnlLine.Type::" ";
        ItemJnlLine."Item No." := "No.";
        ItemJnlLine."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";
        ItemJnlLine."Inventory Posting Group" := "Inventory Posting Group";

        ItemJnlLine."Unit of Measure Code" := "Unit of Measure Code";
        ItemJnlLine."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
        ItemJnlLine.Quantity := QtyToConsume;
        ItemJnlLine."Quantity (Base)" := QtyToConsumeBase;
        ItemJnlLine."Variant Code" := "Variant Code";
        ItemJnlLine.Description := Description;
        ItemJnlLine.VALIDATE("Location Code","Location Code");
        ItemJnlLine."Bin Code" := "Bin Code";
        ItemJnlLine."Unit Cost" := "Unit Cost";
        ItemJnlLine.Correction := IsCorrection;
        ItemJnlLine."Applies-to Entry" := "Appl.-to Item Entry";
        UpdateItemCategoryAndGroupCode(ItemJnlLine);
      END;

      IF IsCorrection THEN
        PostCorrectionItemJnLine(
          ItemJnlLine,AssemblyHeader,ItemJnlPostLine,WhseJnlRegisterLine,DATABASE::"Posted Assembly Line",ApplyToEntryNo)
      ELSE BEGIN
        AssemblyLineReserve.TransferAsmLineToItemJnlLine(AssemblyLine,ItemJnlLine,ItemJnlLine."Quantity (Base)",FALSE);
        PostItemJnlLine(ItemJnlLine,ItemJnlPostLine);
        AssemblyLineReserve.UpdateItemTrackingAfterPosting(AssemblyLine);
        PostWhseJnlLine(AssemblyHeader,ItemJnlLine,ItemJnlPostLine,WhseJnlRegisterLine);
      END;
      EXIT(ItemJnlLine."Item Shpt. Entry No.");
    END;

    LOCAL PROCEDURE PostItemOutput@4(VAR AssemblyHeader@1001 : Record 900;PostingNoSeries@1007 : Code[20];QtyToOutput@1004 : Decimal;QtyToOutputBase@1005 : Decimal;VAR ItemJnlPostLine@1002 : Codeunit 22;VAR WhseJnlRegisterLine@1003 : Codeunit 7301;DocumentNo@1010 : Code[20];IsCorrection@1011 : Boolean;ApplyToEntryNo@1008 : Integer) : Integer;
    VAR
      ItemJnlLine@1000 : Record 83;
      AssemblyHeaderReserve@1006 : Codeunit 925;
    BEGIN
      WITH AssemblyHeader DO BEGIN
        ItemJnlLine.INIT;
        ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Assembly Output";
        ItemJnlLine."Source Code" := SourceCode;
        ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::"Posted Assembly";
        ItemJnlLine."Document No." := DocumentNo;
        ItemJnlLine."Document Date" := PostingDate;
        ItemJnlLine."Document Line No." := 0;
        ItemJnlLine."Order No." := "No.";
        ItemJnlLine."Order Type" := ItemJnlLine."Order Type"::Assembly;
        ItemJnlLine."Dimension Set ID" := "Dimension Set ID" ;
        ItemJnlLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
        ItemJnlLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
        ItemJnlLine."Order Line No." := 0;
        ItemJnlLine."Source Type" := ItemJnlLine."Source Type"::Item;
        ItemJnlLine."Source No." := AssembledItem."No.";

        ItemJnlLine."Posting Date" := PostingDate;
        ItemJnlLine."Posting No. Series" := PostingNoSeries;
        ItemJnlLine.Type := ItemJnlLine.Type::" ";
        ItemJnlLine."Item No." := "Item No.";
        ItemJnlLine."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";
        ItemJnlLine."Inventory Posting Group" := "Inventory Posting Group";

        ItemJnlLine."Unit of Measure Code" := "Unit of Measure Code";
        ItemJnlLine."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
        ItemJnlLine.Quantity := QtyToOutput;
        ItemJnlLine."Invoiced Quantity" := QtyToOutput;
        ItemJnlLine."Quantity (Base)" := QtyToOutputBase;
        ItemJnlLine."Invoiced Qty. (Base)" := QtyToOutputBase;
        ItemJnlLine."Variant Code" := "Variant Code";
        ItemJnlLine.Description := Description;
        ItemJnlLine.VALIDATE("Location Code","Location Code");
        ItemJnlLine."Bin Code" := "Bin Code";
        ItemJnlLine."Indirect Cost %" := "Indirect Cost %";
        ItemJnlLine."Overhead Rate" := "Overhead Rate";
        ItemJnlLine."Unit Cost" := "Unit Cost";
        ItemJnlLine.VALIDATE("Unit Amount",
          ROUND(("Unit Cost" - "Overhead Rate") / (1 + "Indirect Cost %" / 100),
            GLSetup."Unit-Amount Rounding Precision"));
        ItemJnlLine.Correction := IsCorrection;
        UpdateItemCategoryAndGroupCode(ItemJnlLine);
      END;

      IF IsCorrection THEN
        PostCorrectionItemJnLine(
          ItemJnlLine,AssemblyHeader,ItemJnlPostLine,WhseJnlRegisterLine,DATABASE::"Posted Assembly Header",ApplyToEntryNo)
      ELSE BEGIN
        AssemblyHeaderReserve.TransferAsmHeaderToItemJnlLine(AssemblyHeader,ItemJnlLine,ItemJnlLine."Quantity (Base)",FALSE);
        PostItemJnlLine(ItemJnlLine,ItemJnlPostLine);
        AssemblyHeaderReserve.UpdateItemTrackingAfterPosting(AssemblyHeader);
        PostWhseJnlLine(AssemblyHeader,ItemJnlLine,ItemJnlPostLine,WhseJnlRegisterLine);
      END;
      EXIT(ItemJnlLine."Item Shpt. Entry No.");
    END;

    LOCAL PROCEDURE PostItemJnlLine@52(VAR ItemJnlLine@1002 : Record 83;VAR ItemJnlPostLine@1003 : Codeunit 22);
    VAR
      OrigItemJnlLine@1001 : Record 83;
      ItemShptEntry@1000 : Integer;
    BEGIN
      OrigItemJnlLine := ItemJnlLine;
      ItemJnlPostLine.RunWithCheck(ItemJnlLine);
      ItemShptEntry := ItemJnlLine."Item Shpt. Entry No.";
      ItemJnlLine := OrigItemJnlLine;
      ItemJnlLine."Item Shpt. Entry No." := ItemShptEntry;
    END;

    LOCAL PROCEDURE PostCorrectionItemJnLine@37(VAR ItemJnlLine@1001 : Record 83;AssemblyHeader@1007 : Record 900;VAR ItemJnlPostLine@1008 : Codeunit 22;VAR WhseJnlRegisterLine@1010 : Codeunit 7301;SourceType@1002 : Integer;ApplyToEntry@1005 : Integer);
    VAR
      TempItemLedgEntry2@1000 : TEMPORARY Record 32;
      ATOLink@1003 : Record 904;
      TempItemLedgEntryInChain@1006 : TEMPORARY Record 32;
      ItemApplnEntry@1004 : Record 339;
      ItemTrackingMgt@1009 : Codeunit 6500;
    BEGIN
      UndoPostingMgt.CollectItemLedgEntries(
        TempItemLedgEntry2,SourceType,ItemJnlLine."Document No.",ItemJnlLine."Document Line No.",
        ABS(ItemJnlLine."Quantity (Base)"),ApplyToEntry);

      IF TempItemLedgEntry2.FINDSET THEN
        REPEAT
          ItemTrackingMgt.RetrieveAppliedExpirationDate(TempItemLedgEntry2);
          TempItemLedgEntry := TempItemLedgEntry2;
          TempItemLedgEntry.INSERT;

          IF ItemJnlLine."Entry Type" = ItemJnlLine."Entry Type"::"Assembly Consumption" THEN BEGIN
            ItemJnlLine.Quantity := ROUND(TempItemLedgEntry.Quantity * TempItemLedgEntry."Qty. per Unit of Measure",0.00001);
            ItemJnlLine."Quantity (Base)" := TempItemLedgEntry.Quantity;

            ItemJnlLine."Applies-from Entry" := TempItemLedgEntry."Entry No.";
          END ELSE BEGIN
            ItemJnlLine.Quantity := -ROUND(TempItemLedgEntry.Quantity * TempItemLedgEntry."Qty. per Unit of Measure",0.00001);
            ItemJnlLine."Quantity (Base)" := -TempItemLedgEntry.Quantity;

            IF (ItemJnlLine."Order Type" = ItemJnlLine."Order Type"::Assembly) AND
               ATOLink.GET(ATOLink."Assembly Document Type"::Order,ItemJnlLine."Order No.")
            THEN BEGIN
              TempItemLedgEntryInChain.RESET;
              TempItemLedgEntryInChain.DELETEALL;
              ItemApplnEntry.GetVisitedEntries(TempItemLedgEntry,TempItemLedgEntryInChain,TRUE);

              ItemJnlLine."Applies-to Entry" := FindAppliesToATOUndoEntry(TempItemLedgEntryInChain);
            END ELSE
              ItemJnlLine."Applies-to Entry" := TempItemLedgEntry."Entry No.";
          END;
          ItemJnlLine."Invoiced Quantity" := ItemJnlLine.Quantity;
          ItemJnlLine."Invoiced Qty. (Base)" := ItemJnlLine."Quantity (Base)";

          ItemJnlLine."Serial No." := TempItemLedgEntry."Serial No.";
          ItemJnlLine."Lot No." := TempItemLedgEntry."Lot No.";
          ItemJnlLine."Warranty Date" := TempItemLedgEntry."Warranty Date";
          ItemJnlLine."Item Expiration Date" := TempItemLedgEntry."Expiration Date";
          ItemJnlLine."Item Shpt. Entry No." := 0;

          ItemJnlPostLine.RunWithCheck(ItemJnlLine);
          PostWhseJnlLine(AssemblyHeader,ItemJnlLine,ItemJnlPostLine,WhseJnlRegisterLine);
        UNTIL TempItemLedgEntry2.NEXT = 0;
    END;

    LOCAL PROCEDURE FindAppliesToATOUndoEntry@46(VAR ItemLedgEntryInChain@1000 : Record 32) : Integer;
    BEGIN
      WITH ItemLedgEntryInChain DO BEGIN
        RESET;
        SETCURRENTKEY("Item No.",Positive);
        SETRANGE(Positive,TRUE);
        SETRANGE(Open,TRUE);
        FINDFIRST;
        EXIT("Entry No.");
      END;
    END;

    LOCAL PROCEDURE GetLocation@7300(LocationCode@1000 : Code[10];VAR Location@1001 : Record 14);
    BEGIN
      IF LocationCode = '' THEN
        Location.GetLocationSetup(LocationCode,Location)
      ELSE
        IF Location.Code <> LocationCode THEN
          Location.GET(LocationCode);
    END;

    LOCAL PROCEDURE PostWhseJnlLine@9(AssemblyHeader@1011 : Record 900;ItemJnlLine@1000 : Record 83;VAR ItemJnlPostLine@1010 : Codeunit 22;VAR WhseJnlRegisterLine@1001 : Codeunit 7301);
    VAR
      Location@1002 : Record 14;
      TempWhseJnlLine@1004 : TEMPORARY Record 7311;
      TempWhseJnlLine2@1006 : TEMPORARY Record 7311;
      TempTrackingSpecification@1005 : TEMPORARY Record 336;
      ItemTrackingMgt@1007 : Codeunit 6500;
      WhseSNRequired@1008 : Boolean;
      WhseLNRequired@1009 : Boolean;
    BEGIN
      GetLocation(ItemJnlLine."Location Code",Location);
      IF NOT Location."Bin Mandatory" THEN
        EXIT;

      ItemTrackingMgt.CheckWhseItemTrkgSetup(ItemJnlLine."Item No.",WhseSNRequired,WhseLNRequired,FALSE);
      IF WhseSNRequired OR WhseLNRequired THEN
        IF ItemJnlPostLine.CollectTrackingSpecification(TempTrackingSpecification) THEN
          IF TempTrackingSpecification.FINDSET THEN
            REPEAT
              CASE ItemJnlLine."Entry Type" OF
                ItemJnlLine."Entry Type"::"Assembly Consumption":
                  TempTrackingSpecification."Source Type" := DATABASE::"Assembly Line";
                ItemJnlLine."Entry Type"::"Assembly Output":
                  TempTrackingSpecification."Source Type" := DATABASE::"Assembly Header";
              END;
              TempTrackingSpecification."Source Subtype" := AssemblyHeader."Document Type";
              TempTrackingSpecification."Source ID" := AssemblyHeader."No.";
              TempTrackingSpecification."Source Batch Name" := '';
              TempTrackingSpecification."Source Prod. Order Line" := 0;
              TempTrackingSpecification."Source Ref. No." := ItemJnlLine."Order Line No.";
              TempTrackingSpecification.MODIFY;
            UNTIL TempTrackingSpecification.NEXT = 0;

      CreateWhseJnlLine(Location,TempWhseJnlLine,AssemblyHeader,ItemJnlLine);
      ItemTrackingMgt.SplitWhseJnlLine(TempWhseJnlLine,TempWhseJnlLine2,TempTrackingSpecification,FALSE);
      IF TempWhseJnlLine2.FINDSET THEN
        REPEAT
          WhseJnlRegisterLine.RUN(TempWhseJnlLine2);
        UNTIL TempWhseJnlLine2.NEXT = 0;
    END;

    LOCAL PROCEDURE CreateWhseJnlLine@11(Location@1005 : Record 14;VAR WhseJnlLine@1000 : Record 7311;AssemblyHeader@1001 : Record 900;ItemJnlLine@1002 : Record 83);
    VAR
      WMSManagement@1003 : Codeunit 7302;
      WhseMgt@1004 : Codeunit 5775;
    BEGIN
      WITH ItemJnlLine DO BEGIN
        CASE "Entry Type" OF
          "Entry Type"::"Assembly Consumption":
            WMSManagement.CheckAdjmtBin(Location,Quantity,TRUE);
          "Entry Type"::"Assembly Output":
            WMSManagement.CheckAdjmtBin(Location,Quantity,FALSE);
        END;

        WMSManagement.CreateWhseJnlLine(ItemJnlLine,0,WhseJnlLine,FALSE);

        CASE "Entry Type" OF
          "Entry Type"::"Assembly Consumption":
            WhseJnlLine."Source Type" := DATABASE::"Assembly Line";
          "Entry Type"::"Assembly Output":
            WhseJnlLine."Source Type" := DATABASE::"Assembly Header";
        END;
        WhseJnlLine."Source Subtype" := AssemblyHeader."Document Type";
        WhseJnlLine."Source Code" := SourceCode;
        WhseJnlLine."Source Document" := WhseMgt.GetSourceDocument(WhseJnlLine."Source Type",WhseJnlLine."Source Subtype");
        TESTFIELD("Order Type","Order Type"::Assembly);
        WhseJnlLine."Source No." := "Order No.";
        WhseJnlLine."Source Line No." := "Order Line No.";
        WhseJnlLine."Reason Code" := "Reason Code";
        WhseJnlLine."Registering No. Series" := "Posting No. Series";
        WhseJnlLine."Whse. Document Type" := WhseJnlLine."Whse. Document Type"::Assembly;
        WhseJnlLine."Whse. Document No." := "Order No.";
        WhseJnlLine."Whse. Document Line No." := "Order Line No.";
        WhseJnlLine."Reference Document" := WhseJnlLine."Reference Document"::Assembly;
        WhseJnlLine."Reference No." := "Document No.";
        IF Location."Directed Put-away and Pick" THEN
          WMSManagement.CalcCubageAndWeight(
            "Item No.","Unit of Measure Code",WhseJnlLine."Qty. (Absolute)",
            WhseJnlLine.Cubage,WhseJnlLine.Weight);
      END;
      WMSManagement.CheckWhseJnlLine(WhseJnlLine,0,0,FALSE);
    END;

    LOCAL PROCEDURE PostResourceConsumption@6(AssemblyHeader@1006 : Record 900;VAR AssemblyLine@1002 : Record 901;PostingNoSeries@1005 : Code[20];QtyToConsume@1001 : Decimal;QtyToConsumeBase@1000 : Decimal;VAR ResJnlPostLine@1004 : Codeunit 212;VAR ItemJnlPostLine@1007 : Codeunit 22;DocumentNo@1010 : Code[20];IsCorrection@1011 : Boolean);
    VAR
      ItemJnlLine@1003 : Record 83;
      ResJnlLine@1008 : Record 207;
      TimeSheetMgt@1009 : Codeunit 950;
    BEGIN
      WITH AssemblyLine DO BEGIN
        TESTFIELD(Type,Type::Resource);
        ItemJnlLine.INIT;
        ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Assembly Output";
        ItemJnlLine."Source Code" := SourceCode;
        ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::"Posted Assembly";
        ItemJnlLine."Document No." := DocumentNo;
        ItemJnlLine."Document Date" := PostingDate;
        ItemJnlLine."Document Line No." := "Line No.";
        ItemJnlLine."Order Type" := ItemJnlLine."Order Type"::Assembly;
        ItemJnlLine."Order No." := "Document No.";
        ItemJnlLine."Order Line No." := "Line No.";
        ItemJnlLine."Dimension Set ID" := "Dimension Set ID" ;
        ItemJnlLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
        ItemJnlLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
        ItemJnlLine."Source Type" := ItemJnlLine."Source Type"::Item;
        ItemJnlLine."Source No." := AssemblyHeader."Item No.";

        ItemJnlLine."Posting Date" := PostingDate;
        ItemJnlLine."Posting No. Series" := PostingNoSeries;
        ItemJnlLine.Type := ItemJnlLine.Type::Resource;
        ItemJnlLine."No." := "No.";
        ItemJnlLine."Item No." := AssemblyHeader."Item No.";
        ItemJnlLine."Unit of Measure Code" := AssemblyHeader."Unit of Measure Code";
        ItemJnlLine."Qty. per Unit of Measure" := AssemblyHeader."Qty. per Unit of Measure";

        ItemJnlLine.VALIDATE("Location Code","Location Code");
        ItemJnlLine."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";
        ItemJnlLine."Inventory Posting Group" := "Inventory Posting Group";
        ItemJnlLine."Unit Cost" := "Unit Cost";
        ItemJnlLine."Qty. per Cap. Unit of Measure" := "Qty. per Unit of Measure";
        ItemJnlLine."Cap. Unit of Measure Code" := "Unit of Measure Code";
        ItemJnlLine.Description := Description;
        ItemJnlLine.Quantity := QtyToConsume;
        ItemJnlLine."Quantity (Base)" := QtyToConsumeBase;
        ItemJnlLine.Correction := IsCorrection;
      END;
      ItemJnlPostLine.RunWithCheck(ItemJnlLine);

      WITH ItemJnlLine DO BEGIN
        ResJnlLine.INIT;
        ResJnlLine."Posting Date" := "Posting Date";
        ResJnlLine."Document Date" := "Document Date";
        ResJnlLine."Reason Code" := "Reason Code";
        ResJnlLine."System-Created Entry" := TRUE;
        ResJnlLine.VALIDATE("Resource No.","No.");
        ResJnlLine.Description := Description;
        ResJnlLine."Unit of Measure Code" := AssemblyLine."Unit of Measure Code";
        ResJnlLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
        ResJnlLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
        ResJnlLine."Dimension Set ID" := "Dimension Set ID";
        ResJnlLine."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
        ResJnlLine."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";
        ResJnlLine."Entry Type" := ResJnlLine."Entry Type"::Usage;
        ResJnlLine."Document No." := "Document No.";
        ResJnlLine."Order Type" := ResJnlLine."Order Type"::Assembly;
        ResJnlLine."Order No." := "Order No.";
        ResJnlLine."Order Line No." := "Order Line No.";
        ResJnlLine."Line No." := "Document Line No.";
        ResJnlLine."External Document No." := "External Document No.";
        ResJnlLine.Quantity := QtyToConsume;
        ResJnlLine."Unit Cost" := AssemblyLine."Unit Cost";
        ResJnlLine."Total Cost" := AssemblyLine."Unit Cost" * ResJnlLine.Quantity;
        ResJnlLine."Source Code" := "Source Code";
        ResJnlLine."Posting No. Series" := "Posting No. Series";
        ResJnlLine."Qty. per Unit of Measure" := AssemblyLine."Qty. per Unit of Measure";
        ResJnlPostLine.RunWithCheck(ResJnlLine);
      END;

      TimeSheetMgt.CreateTSLineFromAssemblyLine(AssemblyHeader,AssemblyLine,QtyToConsumeBase);
    END;

    LOCAL PROCEDURE InsertLineItemEntryRelation@5(VAR PostedAssemblyLine@1000 : Record 911;VAR ItemJnlPostLine@1004 : Codeunit 22;ItemLedgEntryNo@1003 : Integer);
    VAR
      ItemEntryRelation@1002 : Record 6507;
      TempItemEntryRelation@1001 : TEMPORARY Record 6507;
    BEGIN
      IF ItemJnlPostLine.CollectItemEntryRelation(TempItemEntryRelation) THEN BEGIN
        IF TempItemEntryRelation.FIND('-') THEN
          REPEAT
            ItemEntryRelation := TempItemEntryRelation;
            ItemEntryRelation.TransferFieldsPostedAsmLine(PostedAssemblyLine);
            ItemEntryRelation.INSERT;
          UNTIL TempItemEntryRelation.NEXT = 0;
      END ELSE
        PostedAssemblyLine."Item Shpt. Entry No." := ItemLedgEntryNo;
    END;

    LOCAL PROCEDURE InsertHeaderItemEntryRelation@7(VAR PostedAssemblyHeader@1000 : Record 910;VAR ItemJnlPostLine@1004 : Codeunit 22;ItemLedgEntryNo@1003 : Integer);
    VAR
      ItemEntryRelation@1002 : Record 6507;
      TempItemEntryRelation@1001 : TEMPORARY Record 6507;
    BEGIN
      IF ItemJnlPostLine.CollectItemEntryRelation(TempItemEntryRelation) THEN BEGIN
        IF TempItemEntryRelation.FIND('-') THEN
          REPEAT
            ItemEntryRelation := TempItemEntryRelation;
            ItemEntryRelation.TransferFieldsPostedAsmHeader(PostedAssemblyHeader);
            ItemEntryRelation.INSERT;
          UNTIL TempItemEntryRelation.NEXT = 0;
      END ELSE
        PostedAssemblyHeader."Item Rcpt. Entry No." := ItemLedgEntryNo;
    END;

    [Internal]
    PROCEDURE Undo@21(VAR PostedAsmHeader@1000 : Record 910;RecreateAsmOrder@1001 : Boolean);
    BEGIN
      CLEARALL;

      Window.OPEN(
        '#1#################################\\' +
        Text007 + '\\' +
        STRSUBSTNO(Text010,PostedAsmHeader."No."));

      ShowProgress := TRUE;
      Window.UPDATE(1,STRSUBSTNO('%1 %2',PostedAsmHeader.TABLECAPTION,PostedAsmHeader."No."));

      PostedAsmHeader.CheckIsNotAsmToOrder;

      UndoInitPost(PostedAsmHeader);
      UndoPost(PostedAsmHeader,ItemJnlPostLine,ResJnlPostLine,WhseJnlRegisterLine);
      UndoFinalizePost(PostedAsmHeader,RecreateAsmOrder);

      COMMIT;

      Window.CLOSE;
    END;

    LOCAL PROCEDURE UndoInitPost@22(VAR PostedAsmHeader@1000 : Record 910);
    BEGIN
      WITH PostedAsmHeader DO BEGIN
        PostingDate := "Posting Date";

        CheckPossibleToUndo(PostedAsmHeader);

        GetSourceCode(IsAsmToOrder);

        TempItemLedgEntry.RESET;
        TempItemLedgEntry.DELETEALL;
      END;
    END;

    LOCAL PROCEDURE UndoFinalizePost@26(VAR PostedAsmHeader@1000 : Record 910;RecreateAsmOrder@1001 : Boolean);
    VAR
      AsmHeader@1004 : Record 900;
    BEGIN
      MakeInvtAdjmt;

      IF AsmHeader.GET(AsmHeader."Document Type"::Order,PostedAsmHeader."Order No.") THEN
        UpdateAsmOrderWithUndo(PostedAsmHeader)
      ELSE
        IF RecreateAsmOrder THEN
          RecreateAsmOrderWithUndo(PostedAsmHeader);
    END;

    LOCAL PROCEDURE UndoPost@27(VAR PostedAsmHeader@1000 : Record 910;VAR ItemJnlPostLine@1004 : Codeunit 22;VAR ResJnlPostLine@1003 : Codeunit 212;VAR WhseJnlRegisterLine@1002 : Codeunit 7301);
    BEGIN
      AssembledItem.GET(PostedAsmHeader."Item No.");
      UndoPostHeader(PostedAsmHeader,ItemJnlPostLine,WhseJnlRegisterLine);
      UndoPostLines(PostedAsmHeader,ItemJnlPostLine,ResJnlPostLine,WhseJnlRegisterLine);
    END;

    LOCAL PROCEDURE UndoPostLines@31(PostedAsmHeader@1001 : Record 910;VAR ItemJnlPostLine@1007 : Codeunit 22;VAR ResJnlPostLine@1006 : Codeunit 212;VAR WhseJnlRegisterLine@1003 : Codeunit 7301);
    VAR
      PostedAsmLine@1005 : Record 911;
      AsmHeader@1002 : Record 900;
      AsmLine@1000 : Record 901;
      LineCounter@1004 : Integer;
    BEGIN
      AsmHeader.TRANSFERFIELDS(PostedAsmHeader);
      AsmHeader."Document Type" := AsmHeader."Document Type"::Order;
      AsmHeader."No." := PostedAsmHeader."Order No.";

      WITH PostedAsmLine DO BEGIN
        RESET;
        SETRANGE("Document No.",PostedAsmHeader."No.");
        SortPostedLines(PostedAsmLine);

        LineCounter := 0;
        IF FINDSET THEN
          REPEAT
            AsmLine.TRANSFERFIELDS(PostedAsmLine);
            AsmLine."Document Type" := AsmHeader."Document Type"::Order;
            AsmLine."Document No." := PostedAsmHeader."Order No.";

            LineCounter := LineCounter + 1;
            IF ShowProgress THEN
              Window.UPDATE(2,LineCounter);

            IF "Quantity (Base)" <> 0 THEN BEGIN
              CASE Type OF
                Type::Item:
                  PostItemConsumption(
                    AsmHeader,
                    AsmLine,
                    PostedAsmHeader."No. Series",
                    -Quantity,
                    -"Quantity (Base)",ItemJnlPostLine,WhseJnlRegisterLine,"Document No.",TRUE,"Item Shpt. Entry No.");
                Type::Resource:
                  PostResourceConsumption(
                    AsmHeader,
                    AsmLine,
                    PostedAsmHeader."No. Series",
                    -Quantity,
                    -"Quantity (Base)",
                    ResJnlPostLine,ItemJnlPostLine,"Document No.",TRUE);
              END;
              InsertLineItemEntryRelation(PostedAsmLine,ItemJnlPostLine,0);

              MODIFY;
            END;
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE UndoPostHeader@36(VAR PostedAsmHeader@1001 : Record 910;VAR ItemJnlPostLine@1003 : Codeunit 22;VAR WhseJnlRegisterLine@1002 : Codeunit 7301);
    VAR
      AsmHeader@1000 : Record 900;
    BEGIN
      WITH PostedAsmHeader DO BEGIN
        AsmHeader.TRANSFERFIELDS(PostedAsmHeader);
        AsmHeader."Document Type" := AsmHeader."Document Type"::Order;
        AsmHeader."No." := "Order No.";

        PostItemOutput(
          AsmHeader,"No. Series",-Quantity,-"Quantity (Base)",ItemJnlPostLine,WhseJnlRegisterLine,"No.",TRUE,"Item Rcpt. Entry No.");
        InsertHeaderItemEntryRelation(PostedAsmHeader,ItemJnlPostLine,0);

        Reversed := TRUE;
        MODIFY;
      END;
    END;

    LOCAL PROCEDURE SumCapQtyPosted@39(OrderNo@1001 : Code[20];OrderLineNo@1002 : Integer) : Decimal;
    VAR
      CapLedgEntry@1000 : Record 5832;
    BEGIN
      WITH CapLedgEntry DO BEGIN
        SETCURRENTKEY("Order Type","Order No.","Order Line No.");
        SETRANGE("Order Type","Order Type"::Assembly);
        SETRANGE("Order No.",OrderNo);
        SETRANGE("Order Line No.",OrderLineNo);
        CALCSUMS(Quantity);
        EXIT(Quantity);
      END;
    END;

    LOCAL PROCEDURE SumItemQtyPosted@35(OrderNo@1001 : Code[20];OrderLineNo@1002 : Integer) : Decimal;
    VAR
      ItemLedgEntry@1000 : Record 32;
    BEGIN
      WITH ItemLedgEntry DO BEGIN
        SETCURRENTKEY("Order Type","Order No.","Order Line No.");
        SETRANGE("Order Type","Order Type"::Assembly);
        SETRANGE("Order No.",OrderNo);
        SETRANGE("Order Line No.",OrderLineNo);
        CALCSUMS(Quantity);
        EXIT(Quantity);
      END;
    END;

    LOCAL PROCEDURE UpdateAsmOrderWithUndo@44(VAR PostedAsmHeader@1000 : Record 910);
    VAR
      AsmHeader@1004 : Record 900;
      AsmLine@1003 : Record 901;
      PostedAsmLine@1002 : Record 911;
    BEGIN
      WITH AsmHeader DO BEGIN
        GET("Document Type"::Order,PostedAsmHeader."Order No.");
        "Assembled Quantity" -= PostedAsmHeader.Quantity;
        "Assembled Quantity (Base)" -= PostedAsmHeader."Quantity (Base)";
        InitRemainingQty;
        InitQtyToAssemble;
        MODIFY;

        RestoreItemTracking(TempItemLedgEntry,"No.",0,DATABASE::"Assembly Header","Document Type","Due Date",0D);
        VerifyAsmHeaderReservAfterUndo(AsmHeader);
      END;

      PostedAsmLine.SETRANGE("Document No.",PostedAsmHeader."No.");
      PostedAsmLine.SETFILTER("Quantity (Base)",'<>0');
      IF PostedAsmLine.FINDSET THEN
        REPEAT
          WITH AsmLine DO BEGIN
            GET(AsmHeader."Document Type",AsmHeader."No.",PostedAsmLine."Line No.");
            "Consumed Quantity" -= PostedAsmLine.Quantity;
            "Consumed Quantity (Base)" -= PostedAsmLine."Quantity (Base)";
            IF "Qty. Picked (Base)" <> 0 THEN BEGIN
              "Qty. Picked" -= PostedAsmLine.Quantity;
              "Qty. Picked (Base)" -= PostedAsmLine."Quantity (Base)";
            END;

            InitRemainingQty;
            InitQtyToConsume;
            MODIFY;

            RestoreItemTracking(TempItemLedgEntry,"Document No.","Line No.",DATABASE::"Assembly Line","Document Type",0D,"Due Date");
            VerifyAsmLineReservAfterUndo(AsmLine);
          END;
        UNTIL PostedAsmLine.NEXT = 0;
    END;

    LOCAL PROCEDURE RecreateAsmOrderWithUndo@45(VAR PostedAsmHeader@1000 : Record 910);
    VAR
      AsmHeader@1004 : Record 900;
      AsmLine@1003 : Record 901;
      PostedAsmLine@1002 : Record 911;
      AsmCommentLine@1008 : Record 906;
    BEGIN
      WITH AsmHeader DO BEGIN
        INIT;
        TRANSFERFIELDS(PostedAsmHeader);
        "Document Type" := "Document Type"::Order;
        "No." := PostedAsmHeader."Order No.";

        "Assembled Quantity (Base)" := SumItemQtyPosted("No.",0);
        "Assembled Quantity" := ROUND("Assembled Quantity (Base)" / "Qty. per Unit of Measure",0.00001);
        Quantity := PostedAsmHeader.Quantity + "Assembled Quantity";
        "Quantity (Base)" := PostedAsmHeader."Quantity (Base)" + "Assembled Quantity (Base)";
        InitRemainingQty;
        InitQtyToAssemble;
        INSERT;

        CopyCommentLines(
          AsmCommentLine."Document Type"::"Posted Assembly","Document Type",
          PostedAsmHeader."No.","No.");

        RestoreItemTracking(TempItemLedgEntry,"No.",0,DATABASE::"Assembly Header","Document Type","Due Date",0D);
        VerifyAsmHeaderReservAfterUndo(AsmHeader);
      END;

      PostedAsmLine.SETRANGE("Document No.",PostedAsmHeader."No.");
      IF PostedAsmLine.FINDSET THEN
        REPEAT
          WITH AsmLine DO BEGIN
            INIT;
            TRANSFERFIELDS(PostedAsmLine);
            "Document Type" := "Document Type"::Order;
            "Document No." := PostedAsmLine."Order No.";
            "Line No." := PostedAsmLine."Order Line No.";

            IF PostedAsmLine."Quantity (Base)" <> 0 THEN BEGIN
              IF Type = Type::Item THEN
                "Consumed Quantity (Base)" := -SumItemQtyPosted("Document No.","Line No.")
              ELSE
                "Consumed Quantity (Base)" := SumCapQtyPosted("Document No.","Line No.");

              "Consumed Quantity" := ROUND("Consumed Quantity (Base)" / "Qty. per Unit of Measure",0.00001);
              Quantity := PostedAsmLine.Quantity + "Consumed Quantity";
              "Quantity (Base)" := PostedAsmLine."Quantity (Base)" + "Consumed Quantity (Base)";
              "Cost Amount" := CalcCostAmount(Quantity,"Unit Cost");
              IF Type = Type::Item THEN BEGIN
                "Qty. Picked" := "Consumed Quantity";
                "Qty. Picked (Base)" := "Consumed Quantity (Base)";
              END;
              InitRemainingQty;
              InitQtyToConsume;
            END;
            INSERT;

            RestoreItemTracking(TempItemLedgEntry,"Document No.","Line No.",DATABASE::"Assembly Line","Document Type",0D,"Due Date");
            VerifyAsmLineReservAfterUndo(AsmLine);
          END;
        UNTIL PostedAsmLine.NEXT = 0;
    END;

    LOCAL PROCEDURE VerifyAsmHeaderReservAfterUndo@55(VAR AsmHeader@1004 : Record 900);
    VAR
      xAsmHeader@1001 : Record 900;
      AsmHeaderReserve@1002 : Codeunit 925;
    BEGIN
      xAsmHeader := AsmHeader;
      xAsmHeader."Quantity (Base)" := 0;
      AsmHeaderReserve.VerifyQuantity(AsmHeader,xAsmHeader);
    END;

    LOCAL PROCEDURE VerifyAsmLineReservAfterUndo@56(VAR AsmLine@1001 : Record 901);
    VAR
      xAsmLine@1000 : Record 901;
      AsmLineReserve@1002 : Codeunit 926;
    BEGIN
      xAsmLine := AsmLine;
      xAsmLine."Quantity (Base)" := 0;
      AsmLineReserve.VerifyQuantity(AsmLine,xAsmLine);
    END;

    LOCAL PROCEDURE GetSourceCode@29(IsATO@1001 : Boolean);
    VAR
      SourceCodeSetup@1000 : Record 242;
    BEGIN
      SourceCodeSetup.GET;
      IF IsATO THEN
        SourceCode := SourceCodeSetup.Sales
      ELSE
        SourceCode := SourceCodeSetup.Assembly;
    END;

    LOCAL PROCEDURE CheckPossibleToUndo@32(PostedAsmHeader@1000 : Record 910) : Boolean;
    VAR
      AsmHeader@1001 : Record 900;
      PostedAsmLine@1002 : Record 911;
      AsmLine@1003 : Record 901;
      TempItemLedgEntry@1005 : TEMPORARY Record 32;
    BEGIN
      WITH PostedAsmHeader DO BEGIN
        TESTFIELD(Reversed,FALSE);
        UndoPostingMgt.TestAsmHeader(PostedAsmHeader);
        UndoPostingMgt.CollectItemLedgEntries(
          TempItemLedgEntry,DATABASE::"Posted Assembly Header","No.",0,"Quantity (Base)","Item Rcpt. Entry No.");
        UndoPostingMgt.CheckItemLedgEntries(TempItemLedgEntry,0);
      END;

      WITH PostedAsmLine DO BEGIN
        SETRANGE("Document No.",PostedAsmHeader."No.");
        REPEAT
          IF (Type = Type::Item) AND ("Item Shpt. Entry No." <> 0) THEN BEGIN
            UndoPostingMgt.TestAsmLine(PostedAsmLine);
            UndoPostingMgt.CollectItemLedgEntries(
              TempItemLedgEntry,DATABASE::"Posted Assembly Line","Document No.","Line No.","Quantity (Base)","Item Shpt. Entry No.");
            UndoPostingMgt.CheckItemLedgEntries(TempItemLedgEntry,"Line No.");
          END;
        UNTIL NEXT = 0;
      END;

      IF NOT AsmHeader.GET(AsmHeader."Document Type"::Order,PostedAsmHeader."Order No.") THEN
        EXIT(TRUE);

      WITH AsmHeader DO BEGIN
        TESTFIELD("Variant Code",PostedAsmHeader."Variant Code");
        TESTFIELD("Location Code",PostedAsmHeader."Location Code");
        TESTFIELD("Bin Code",PostedAsmHeader."Bin Code");
      END;

      WITH AsmLine DO BEGIN
        SETRANGE("Document Type",AsmHeader."Document Type");
        SETRANGE("Document No.",AsmHeader."No.");

        IF PostedAsmLine.COUNT <> COUNT THEN
          ERROR(Text011,PostedAsmHeader."No.",AsmHeader."No.");

        FINDSET;
        PostedAsmLine.FINDSET;
        REPEAT
          TESTFIELD(Type,PostedAsmLine.Type);
          TESTFIELD("No.",PostedAsmLine."No.");
          TESTFIELD("Variant Code",PostedAsmLine."Variant Code");
          TESTFIELD("Location Code",PostedAsmLine."Location Code");
          TESTFIELD("Bin Code",PostedAsmLine."Bin Code");
        UNTIL (PostedAsmLine.NEXT = 0) AND (NEXT = 0);
      END;
    END;

    LOCAL PROCEDURE RestoreItemTracking@38(VAR ItemLedgEntry@1000 : Record 32;OrderNo@1007 : Code[20];OrderLineNo@1008 : Integer;SourceType@1005 : Integer;DocType@1006 : Option;RcptDate@1002 : Date;ShptDate@1003 : Date);
    VAR
      AsmHeader@1004 : Record 900;
      ReservEntry@1011 : Record 337;
      ATOLink@1012 : Record 904;
      SalesLine@1013 : Record 37;
      CreateReservEntry@1001 : Codeunit 99000830;
      IsATOHeader@1010 : Boolean;
      ReservStatus@1009 : 'Reservation,Tracking,Surplus,Prospect';
    BEGIN
      WITH ItemLedgEntry DO BEGIN
        AsmHeader.GET(AsmHeader."Document Type"::Order,OrderNo);
        IsATOHeader := (OrderLineNo = 0) AND AsmHeader.IsAsmToOrder;

        RESET;
        SETRANGE("Order Type","Order Type"::Assembly);
        SETRANGE("Order No.",OrderNo);
        SETRANGE("Order Line No.",OrderLineNo);
        IF FINDSET THEN
          REPEAT
            IF TrackingExists THEN BEGIN
              CreateReservEntry.SetDates("Warranty Date","Expiration Date");
              CreateReservEntry.SetQtyToHandleAndInvoice(Quantity,Quantity);
              CreateReservEntry.SetItemLedgEntryNo("Entry No.");
              CreateReservEntry.CreateReservEntryFor(
                SourceType,DocType,"Order No.",'',0,"Order Line No.",
                "Qty. per Unit of Measure",0,ABS(Quantity),
                "Serial No.","Lot No.");

              IF IsATOHeader THEN BEGIN
                ATOLink.GET(AsmHeader."Document Type",AsmHeader."No.");
                ATOLink.TESTFIELD(Type,ATOLink.Type::Sale);
                SalesLine.GET(ATOLink."Document Type",ATOLink."Document No.",ATOLink."Document Line No.");

                CreateReservEntry.SetDisallowCancellation(TRUE);
                CreateReservEntry.SetBinding(ReservEntry.Binding::"Order-to-Order");
                CreateReservEntry.CreateReservEntryFrom(
                  DATABASE::"Sales Line",SalesLine."Document Type",SalesLine."Document No.",'',0,SalesLine."Line No.",
                  "Qty. per Unit of Measure","Serial No.","Lot No.");
                ReservStatus := ReservStatus::Reservation;
              END ELSE
                ReservStatus := ReservStatus::Surplus;
              CreateReservEntry.CreateEntry(
                "Item No.","Variant Code","Location Code",'',RcptDate,ShptDate,0,ReservStatus);
            END;
          UNTIL NEXT = 0;
        DELETEALL;
      END;
    END;

    [External]
    PROCEDURE InitPostATO@12(VAR AssemblyHeader@1000 : Record 900);
    BEGIN
      IF AssemblyHeader.IsAsmToOrder THEN
        InitPost(AssemblyHeader);
    END;

    [External]
    PROCEDURE PostATO@15(VAR AssemblyHeader@1000 : Record 900;VAR ItemJnlPostLine@1001 : Codeunit 22;VAR ResJnlPostLine@1002 : Codeunit 212;VAR WhseJnlRegisterLine@1003 : Codeunit 7301);
    BEGIN
      IF AssemblyHeader.IsAsmToOrder THEN
        Post(AssemblyHeader,ItemJnlPostLine,ResJnlPostLine,WhseJnlRegisterLine);
    END;

    [External]
    PROCEDURE FinalizePostATO@16(VAR AssemblyHeader@1000 : Record 900);
    BEGIN
      IF AssemblyHeader.IsAsmToOrder THEN
        FinalizePost(AssemblyHeader);
    END;

    [External]
    PROCEDURE UndoInitPostATO@42(VAR PostedAsmHeader@1000 : Record 910);
    BEGIN
      IF PostedAsmHeader.IsAsmToOrder THEN
        UndoInitPost(PostedAsmHeader);
    END;

    [Internal]
    PROCEDURE UndoPostATO@41(VAR PostedAsmHeader@1000 : Record 910;VAR ItemJnlPostLine@1001 : Codeunit 22;VAR ResJnlPostLine@1002 : Codeunit 212;VAR WhseJnlRegisterLine@1003 : Codeunit 7301);
    BEGIN
      IF PostedAsmHeader.IsAsmToOrder THEN
        UndoPost(PostedAsmHeader,ItemJnlPostLine,ResJnlPostLine,WhseJnlRegisterLine);
    END;

    [Internal]
    PROCEDURE UndoFinalizePostATO@40(VAR PostedAsmHeader@1000 : Record 910);
    BEGIN
      IF PostedAsmHeader.IsAsmToOrder THEN
        UndoFinalizePost(PostedAsmHeader,FALSE);
    END;

    LOCAL PROCEDURE MakeInvtAdjmt@43();
    VAR
      InvtSetup@1001 : Record 313;
      InvtAdjmt@1000 : Codeunit 5895;
    BEGIN
      InvtSetup.GET;
      IF InvtSetup."Automatic Cost Adjustment" <>
         InvtSetup."Automatic Cost Adjustment"::Never
      THEN BEGIN
        InvtAdjmt.SetProperties(TRUE,InvtSetup."Automatic Cost Posting");
        InvtAdjmt.MakeMultiLevelAdjmt;
      END;
    END;

    LOCAL PROCEDURE DeleteWhseRequest@47(AssemblyHeader@1000 : Record 900);
    VAR
      WhseRqst@1001 : Record 5765;
    BEGIN
      WITH WhseRqst DO BEGIN
        SETCURRENTKEY("Source Type","Source Subtype","Source No.");
        SETRANGE("Source Type",DATABASE::"Assembly Line");
        SETRANGE("Source Subtype",AssemblyHeader."Document Type");
        SETRANGE("Source No.",AssemblyHeader."No.");
        IF NOT ISEMPTY THEN
          DELETEALL(TRUE);
      END;
    END;

    [External]
    PROCEDURE UpdateBlanketATO@101(xBlanketOrderSalesLine@1001 : Record 37;BlanketOrderSalesLine@1002 : Record 37);
    VAR
      AsmHeader@1003 : Record 900;
      QuantityDiff@1005 : Decimal;
      QuantityDiffBase@1006 : Decimal;
    BEGIN
      IF BlanketOrderSalesLine.AsmToOrderExists(AsmHeader) THEN BEGIN
        QuantityDiff := BlanketOrderSalesLine."Quantity Shipped" - xBlanketOrderSalesLine."Quantity Shipped";
        QuantityDiffBase := BlanketOrderSalesLine."Qty. Shipped (Base)" - xBlanketOrderSalesLine."Qty. Shipped (Base)";

        WITH AsmHeader DO BEGIN
          "Assembled Quantity" += QuantityDiff;
          "Assembled Quantity (Base)" += QuantityDiffBase;
          InitRemainingQty;
          InitQtyToAssemble;
          MODIFY(TRUE);
        END;
        UpdateBlanketATOLines(AsmHeader,QuantityDiff);
      END;
    END;

    LOCAL PROCEDURE UpdateBlanketATOLines@109(AsmHeader@1001 : Record 900;QuantityDiff@1000 : Decimal);
    VAR
      AsmLine@1002 : Record 901;
      UOMMgt@1003 : Codeunit 5402;
    BEGIN
      WITH AsmLine DO BEGIN
        SETRANGE("Document Type",AsmHeader."Document Type");
        SETRANGE("Document No.",AsmHeader."No.");
        IF FINDSET THEN
          REPEAT
            "Consumed Quantity" += UOMMgt.RoundQty(QuantityDiff * "Quantity per");
            "Consumed Quantity (Base)" += UOMMgt.CalcBaseQty(QuantityDiff * "Quantity per","Qty. per Unit of Measure");
            InitRemainingQty;
            InitQtyToConsume;
            MODIFY(TRUE);
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE UpdateItemCategoryAndGroupCode@48(VAR ItemJnlLine@1002 : Record 83);
    VAR
      Item@1001 : Record 27;
    BEGIN
      Item.GET(ItemJnlLine."Item No.");
      ItemJnlLine."Item Category Code" := Item."Item Category Code";
      ItemJnlLine."Product Group Code" := Item."Product Group Code";
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterFinalizePost@54(VAR AssemblyHeader@1000 : Record 900);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterInitPost@64(VAR AssemblyHeader@1000 : Record 900);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterOnRun@51(VAR AssemblyHeader@1000 : Record 900);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterPost@61(VAR AssemblyHeader@1000 : Record 900);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeFinalizePost@53(VAR AssemblyHeader@1000 : Record 900);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeInitPost@63(VAR AssemblyHeader@1000 : Record 900);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeOnRun@50(VAR AssemblyHeader@1000 : Record 900);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforePost@59(VAR AssemblyHeader@1000 : Record 900);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterPostedAssemblyLineInsert@68(VAR PostedAssemblyLine@1000 : Record 911;AssemblyLine@1001 : Record 901);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterPostedAssemblyHeaderModify@70(VAR PostedAssemblyHeader@1000 : Record 910;AssemblyHeader@1001 : Record 900);
    BEGIN
    END;

    BEGIN
    END.
  }
}

