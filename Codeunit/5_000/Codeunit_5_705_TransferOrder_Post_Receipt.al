OBJECT Codeunit 5705 TransferOrder-Post Receipt
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    TableNo=5740;
    Permissions=TableData 6507=i;
    OnRun=VAR
            Item@1000 : Record 27;
            SourceCodeSetup@1001 : Record 242;
            InvtSetup@1002 : Record 313;
            ValueEntry@1007 : Record 5802;
            ItemLedgEntry@1008 : Record 32;
            ItemApplnEntry@1009 : Record 339;
            ItemReg@1010 : Record 46;
            NoSeriesMgt@1003 : Codeunit 396;
            UpdateAnalysisView@1004 : Codeunit 410;
            UpdateItemAnalysisView@1012 : Codeunit 7150;
            ReservMgt@1013 : Codeunit 99000845;
            RecordLinkManagement@1014 : Codeunit 447;
            Window@1006 : Dialog;
            LineCount@1005 : Integer;
          BEGIN
            ReleaseDocument(Rec);
            TransHeader := Rec;
            TransHeader.SetHideValidationDialog(HideValidationDialog);

            OnBeforeTransferOderPostReceipt(TransHeader);
            OnBeforeTransferOrderPostReceipt(TransHeader);

            WITH TransHeader DO BEGIN
              CheckBeforePost;

              WhseReference := "Posting from Whse. Ref.";
              "Posting from Whse. Ref." := 0;

              CheckDim;

              TransLine.RESET;
              TransLine.SETRANGE("Document No.","No.");
              TransLine.SETRANGE("Derived From Line No.",0);
              TransLine.SETFILTER(Quantity,'<>0');
              TransLine.SETFILTER("Qty. to Receive",'<>0');
              IF NOT TransLine.FIND('-') THEN
                ERROR(Text001);

              WhseReceive := TempWhseRcptHeader.FINDFIRST;
              InvtPickPutaway := WhseReference <> 0;
              IF NOT (WhseReceive OR InvtPickPutaway) THEN
                CheckWarehouse(TransLine);

              WhsePosting := IsWarehousePosting("Transfer-to Code");

              Window.OPEN(
                '#1#################################\\' +
                Text003);

              Window.UPDATE(1,STRSUBSTNO(Text004,"No."));

              SourceCodeSetup.GET;
              SourceCode := SourceCodeSetup.Transfer;
              InvtSetup.GET;
              InvtSetup.TESTFIELD("Posted Transfer Rcpt. Nos.");

              CheckInvtPostingSetup;

              LockTables(InvtSetup."Automatic Cost Posting");

              // Insert receipt header
              IF WhseReceive THEN
                PostedWhseRcptHeader.LOCKTABLE;
              TransRcptHeader.LOCKTABLE;
              TransRcptHeader.INIT;
              TransRcptHeader.CopyFromTransferHeader(TransHeader);
              TransRcptHeader."No. Series" := InvtSetup."Posted Transfer Rcpt. Nos.";
              TransRcptHeader."No." :=
                NoSeriesMgt.GetNextNo(
                  InvtSetup."Posted Transfer Rcpt. Nos.","Posting Date",TRUE);
              TransRcptHeader.INSERT;

              IF InvtSetup."Copy Comments Order to Rcpt." THEN BEGIN
                CopyCommentLines(1,3,"No.",TransRcptHeader."No.");
                RecordLinkManagement.CopyLinks(Rec,TransRcptHeader);
              END;

              IF WhseReceive THEN BEGIN
                WhseRcptHeader.GET(TempWhseRcptHeader."No.");
                WhsePostRcpt.CreatePostedRcptHeader(PostedWhseRcptHeader,WhseRcptHeader,TransRcptHeader."No.","Posting Date");
              END;

              // Insert receipt lines
              LineCount := 0;
              IF WhseReceive THEN
                PostedWhseRcptLine.LOCKTABLE;
              IF InvtPickPutaway THEN
                WhseRqst.LOCKTABLE;
              TransRcptLine.LOCKTABLE;
              TransLine.SETRANGE(Quantity);
              TransLine.SETRANGE("Qty. to Receive");
              IF TransLine.FIND('-') THEN
                REPEAT
                  LineCount := LineCount + 1;
                  Window.UPDATE(2,LineCount);

                  IF TransLine."Item No." <> '' THEN BEGIN
                    Item.GET(TransLine."Item No.");
                    Item.TESTFIELD(Blocked,FALSE);
                  END;

                  TransRcptLine.INIT;
                  TransRcptLine."Document No." := TransRcptHeader."No.";
                  TransRcptLine.CopyFromTransferLine(TransLine);
                  TransRcptLine.INSERT;

                  IF TransLine."Qty. to Receive" > 0 THEN BEGIN
                    OriginalQuantity := TransLine."Qty. to Receive";
                    OriginalQuantityBase := TransLine."Qty. to Receive (Base)";
                    PostItemJnlLine(TransLine,TransRcptHeader,TransRcptLine);
                    TransRcptLine."Item Rcpt. Entry No." := InsertRcptEntryRelation(TransRcptLine);
                    TransRcptLine.MODIFY;
                    SaveTempWhseSplitSpec(TransLine);
                    IF WhseReceive THEN BEGIN
                      WhseRcptLine.SETCURRENTKEY(
                        "No.","Source Type","Source Subtype","Source No.","Source Line No.");
                      WhseRcptLine.SETRANGE("No.",WhseRcptHeader."No.");
                      WhseRcptLine.SETRANGE("Source Type",DATABASE::"Transfer Line");
                      WhseRcptLine.SETRANGE("Source No.",TransLine."Document No.");
                      WhseRcptLine.SETRANGE("Source Line No.",TransLine."Line No.");
                      WhseRcptLine.FINDFIRST;
                      WhseRcptLine.TESTFIELD("Qty. to Receive",TransRcptLine.Quantity);
                      WhsePostRcpt.SetItemEntryRelation(PostedWhseRcptHeader,PostedWhseRcptLine,TempItemEntryRelation2);
                      WhsePostRcpt.CreatePostedRcptLine(
                        WhseRcptLine,PostedWhseRcptHeader,PostedWhseRcptLine,TempWhseSplitSpecification);
                    END;
                    IF WhsePosting THEN
                      PostWhseJnlLine(ItemJnlLine,OriginalQuantity,OriginalQuantityBase,TempWhseSplitSpecification);
                  END;
                UNTIL TransLine.NEXT = 0;

              IF InvtSetup."Automatic Cost Adjustment" <> InvtSetup."Automatic Cost Adjustment"::Never THEN BEGIN
                InvtAdjmt.SetProperties(TRUE,InvtSetup."Automatic Cost Posting");
                InvtAdjmt.MakeMultiLevelAdjmt;
              END;

              ValueEntry.LOCKTABLE;
              ItemLedgEntry.LOCKTABLE;
              ItemApplnEntry.LOCKTABLE;
              ItemReg.LOCKTABLE;
              TransLine.LOCKTABLE;
              IF WhsePosting THEN
                WhseEntry.LOCKTABLE;

              TransLine.SETFILTER(Quantity,'<>0');
              TransLine.SETFILTER("Qty. to Receive",'<>0');
              IF TransLine.FIND('-') THEN
                REPEAT
                  TransLine.VALIDATE("Quantity Received",TransLine."Quantity Received" + TransLine."Qty. to Receive");
                  TransLine.UpdateWithWarehouseShipReceive;
                  ReservMgt.SetItemJnlLine(ItemJnlLine);
                  ReservMgt.SetItemTrackingHandling(1); // Allow deletion
                  ReservMgt.DeleteReservEntries(TRUE,0);
                  TransLine.MODIFY;
                  OnAfterTransLineUpdateQtyReceived(TransLine);
                UNTIL TransLine.NEXT = 0;

              IF WhseReceive THEN
                WhseRcptLine.LOCKTABLE;
              LOCKTABLE;
              IF WhseReceive THEN BEGIN
                WhsePostRcpt.PostUpdateWhseDocuments(WhseRcptHeader);
                TempWhseRcptHeader.DELETE;
              END;

              "Last Receipt No." := TransRcptHeader."No.";
              MODIFY;

              TransLine.SETRANGE(Quantity);
              TransLine.SETRANGE("Qty. to Receive");
              IF ShouldDeleteOneTransferOrder(TransLine) THEN
                DeleteOneTransferOrder(TransHeader,TransLine)
              ELSE BEGIN
                WhseTransferRelease.Release(TransHeader);
                ReserveTransLine.UpdateItemTrackingAfterPosting(TransHeader,1);
              END;

              IF NOT InvtPickPutaway THEN
                COMMIT;
              CLEAR(WhsePostRcpt);
              CLEAR(InvtAdjmt);
              Window.CLOSE;
            END;
            UpdateAnalysisView.UpdateAll(0,TRUE);
            UpdateItemAnalysisView.UpdateAll(0,TRUE);
            Rec := TransHeader;

            OnAfterTransferOrderPostReceipt(Rec);
            OnAfterTransferOderPostReceipt(Rec);
          END;

  }
  CODE
  {
    VAR
      Text001@1001 : TextConst 'DAN=Der er intet at bogf�re.;ENU=There is nothing to post.';
      Text002@1002 : TextConst '@@@="1%=TransLine2.""Document No.""; 2%=TransLine2.FIELDCAPTION(""Line No.""); 3%=TransLine2.""Line No."");";DAN="Der kr�ves lagerekspedition for overflytningsordre = %1, %2 = %3.";ENU="Warehouse handling is required for Transfer order = %1, %2 = %3."';
      Text003@1003 : TextConst 'DAN=Overflyt.linjer bogf�res   #2######;ENU=Posting transfer lines     #2######';
      Text004@1004 : TextConst 'DAN=Overflytningsordre %1;ENU=Transfer Order %1';
      Text005@1005 : TextConst 'DAN=Kombinationen af dimensioner, der bliver brugt i overflytningsordren %1 er sp�rret. %2.;ENU=The combination of dimensions used in transfer order %1 is blocked. %2.';
      Text006@1006 : TextConst 'DAN=Kombinationen af dimensioner, der bliver brugt i overflytningsordren %1 linjenr. %2 er sp�rret. %3.;ENU=The combination of dimensions used in transfer order %1, line no. %2 is blocked. %3.';
      Text007@1007 : TextConst 'DAN=De dimensioner, der bruges i overflytningsordre %1, linjenr. %2, er ikke gyldige. %3.;ENU=The dimensions that are used in transfer order %1, line no. %2 are not valid. %3.';
      Text008@1008 : TextConst 'DAN=Det basisantal, der skal modtages, skal v�re 0.;ENU=Base Qty. to Receive must be 0.';
      TransRcptHeader@1009 : Record 5746;
      TransRcptLine@1010 : Record 5747;
      TransHeader@1011 : Record 5740;
      TransLine@1012 : Record 5741;
      ItemJnlLine@1015 : Record 83;
      Location@1016 : Record 14;
      NewLocation@1040 : Record 14;
      WhseRqst@1039 : Record 5765;
      WhseRcptHeader@1027 : Record 7316;
      TempWhseRcptHeader@1033 : TEMPORARY Record 7316;
      WhseRcptLine@1022 : Record 7317;
      PostedWhseRcptHeader@1029 : Record 7318;
      PostedWhseRcptLine@1034 : Record 7319;
      TempWhseSplitSpecification@1018 : TEMPORARY Record 336;
      WhseEntry@1030 : Record 7312;
      TempItemEntryRelation2@1041 : TEMPORARY Record 6507;
      ItemJnlPostLine@1020 : Codeunit 22;
      DimMgt@1017 : Codeunit 408;
      WhseTransferRelease@1019 : Codeunit 5773;
      ReserveTransLine@1021 : Codeunit 99000836;
      WhsePostRcpt@1036 : Codeunit 5760;
      InvtAdjmt@1043 : Codeunit 5895;
      WhseJnlRegisterLine@1045 : Codeunit 7301;
      SourceCode@1023 : Code[10];
      HideValidationDialog@1024 : Boolean;
      WhsePosting@1028 : Boolean;
      WhseReference@1038 : Integer;
      OriginalQuantity@1031 : Decimal;
      OriginalQuantityBase@1032 : Decimal;
      WhseReceive@1026 : Boolean;
      InvtPickPutaway@1037 : Boolean;

    LOCAL PROCEDURE PostItemJnlLine@2(VAR TransLine3@1000 : Record 5741;TransRcptHeader2@1001 : Record 5746;TransRcptLine2@1002 : Record 5747);
    BEGIN
      ItemJnlLine.INIT;
      ItemJnlLine."Posting Date" := TransRcptHeader2."Posting Date";
      ItemJnlLine."Document Date" := TransRcptHeader2."Posting Date";
      ItemJnlLine."Document No." := TransRcptHeader2."No.";
      ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::"Transfer Receipt";
      ItemJnlLine."Document Line No." := TransRcptLine2."Line No.";
      ItemJnlLine."Order Type" := ItemJnlLine."Order Type"::Transfer;
      ItemJnlLine."Order No." := TransRcptHeader2."Transfer Order No.";
      ItemJnlLine."Order Line No." := TransLine3."Line No.";
      ItemJnlLine."External Document No." := TransRcptHeader2."External Document No.";
      ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::Transfer;
      ItemJnlLine."Item No." := TransRcptLine2."Item No.";
      ItemJnlLine.Description := TransRcptLine2.Description;
      ItemJnlLine."Shortcut Dimension 1 Code" := TransRcptLine2."Shortcut Dimension 1 Code";
      ItemJnlLine."New Shortcut Dimension 1 Code" := TransRcptLine2."Shortcut Dimension 1 Code";
      ItemJnlLine."Shortcut Dimension 2 Code" := TransRcptLine2."Shortcut Dimension 2 Code";
      ItemJnlLine."New Shortcut Dimension 2 Code" := TransRcptLine2."Shortcut Dimension 2 Code";
      ItemJnlLine."Dimension Set ID" := TransRcptLine2."Dimension Set ID";
      ItemJnlLine."New Dimension Set ID" := TransRcptLine2."Dimension Set ID";
      ItemJnlLine."Location Code" := TransHeader."In-Transit Code";
      ItemJnlLine."New Location Code" := TransRcptHeader2."Transfer-to Code";
      ItemJnlLine.Quantity := TransRcptLine2.Quantity;
      ItemJnlLine."Invoiced Quantity" := TransRcptLine2.Quantity;
      ItemJnlLine."Quantity (Base)" := TransRcptLine2."Quantity (Base)";
      ItemJnlLine."Invoiced Qty. (Base)" := TransRcptLine2."Quantity (Base)";
      ItemJnlLine."Source Code" := SourceCode;
      ItemJnlLine."Gen. Prod. Posting Group" := TransRcptLine2."Gen. Prod. Posting Group";
      ItemJnlLine."Inventory Posting Group" := TransRcptLine2."Inventory Posting Group";
      ItemJnlLine."Unit of Measure Code" := TransRcptLine2."Unit of Measure Code";
      ItemJnlLine."Qty. per Unit of Measure" := TransRcptLine2."Qty. per Unit of Measure";
      ItemJnlLine."Variant Code" := TransRcptLine2."Variant Code";
      ItemJnlLine."New Bin Code" := TransLine."Transfer-To Bin Code";
      ItemJnlLine."Product Group Code" := TransLine."Product Group Code";
      ItemJnlLine."Item Category Code" := TransLine."Item Category Code";
      IF TransHeader."In-Transit Code" <> '' THEN BEGIN
        IF NewLocation.Code <> TransHeader."In-Transit Code" THEN
          NewLocation.GET(TransHeader."In-Transit Code");
        ItemJnlLine."Country/Region Code" := NewLocation."Country/Region Code";
      END;
      ItemJnlLine."Transaction Type" := TransRcptHeader2."Transaction Type";
      ItemJnlLine."Transport Method" := TransRcptHeader2."Transport Method";
      ItemJnlLine."Entry/Exit Point" := TransRcptHeader2."Entry/Exit Point";
      ItemJnlLine.Area := TransRcptHeader2.Area;
      ItemJnlLine."Transaction Specification" := TransRcptHeader2."Transaction Specification";
      ItemJnlLine."Direct Transfer" := TransLine."Direct Transfer";
      WriteDownDerivedLines(TransLine3);
      ItemJnlPostLine.SetPostponeReservationHandling(TRUE);

      OnBeforePostItemJournalLine(ItemJnlLine,TransLine3,TransRcptHeader2,TransRcptLine2);
      ItemJnlPostLine.RunWithCheck(ItemJnlLine);
    END;

    LOCAL PROCEDURE CopyCommentLines@22(FromDocumentType@1000 : Integer;ToDocumentType@1001 : Integer;FromNumber@1002 : Code[20];ToNumber@1003 : Code[20]);
    VAR
      InvtCommentLine@1004 : Record 5748;
      InvtCommentLine2@1005 : Record 5748;
    BEGIN
      InvtCommentLine.SETRANGE("Document Type",FromDocumentType);
      InvtCommentLine.SETRANGE("No.",FromNumber);
      IF InvtCommentLine.FIND('-') THEN
        REPEAT
          InvtCommentLine2 := InvtCommentLine;
          InvtCommentLine2."Document Type" := ToDocumentType;
          InvtCommentLine2."No." := ToNumber;
          InvtCommentLine2.INSERT;
        UNTIL InvtCommentLine.NEXT = 0;
    END;

    LOCAL PROCEDURE CheckDim@34();
    BEGIN
      TransLine."Line No." := 0;
      CheckDimComb(TransHeader,TransLine);
      CheckDimValuePosting(TransHeader,TransLine);

      TransLine.SETRANGE("Document No.",TransHeader."No.");
      IF TransLine.FINDFIRST THEN BEGIN
        CheckDimComb(TransHeader,TransLine);
        CheckDimValuePosting(TransHeader,TransLine);
      END;
    END;

    LOCAL PROCEDURE CheckDimComb@30(TransferHeader@1001 : Record 5740;TransferLine@1000 : Record 5741);
    BEGIN
      IF TransferLine."Line No." = 0 THEN
        IF NOT DimMgt.CheckDimIDComb(TransferHeader."Dimension Set ID") THEN
          ERROR(
            Text005,
            TransHeader."No.",DimMgt.GetDimCombErr);
      IF TransferLine."Line No." <> 0 THEN
        IF NOT DimMgt.CheckDimIDComb(TransferLine."Dimension Set ID") THEN
          ERROR(
            Text006,
            TransHeader."No.",TransferLine."Line No.",DimMgt.GetDimCombErr);
    END;

    LOCAL PROCEDURE CheckDimValuePosting@28(TransferHeader@1000 : Record 5740;TransferLine@1004 : Record 5741);
    VAR
      TableIDArr@1002 : ARRAY [10] OF Integer;
      NumberArr@1003 : ARRAY [10] OF Code[20];
    BEGIN
      TableIDArr[1] := DATABASE::Item;
      NumberArr[1] := TransferLine."Item No.";
      IF TransferLine."Line No." = 0 THEN
        IF NOT DimMgt.CheckDimValuePosting(TableIDArr,NumberArr,TransferHeader."Dimension Set ID") THEN
          ERROR(
            Text007,
            TransHeader."No.",TransferLine."Line No.",DimMgt.GetDimValuePostingErr);

      IF TransferLine."Line No." <> 0 THEN
        IF NOT DimMgt.CheckDimValuePosting(TableIDArr,NumberArr,TransferLine."Dimension Set ID") THEN
          ERROR(
            Text007,
            TransHeader."No.",TransferLine."Line No.",DimMgt.GetDimValuePostingErr);
    END;

    PROCEDURE SetHideValidationDialog@14(NewHideValidationDialog@1000 : Boolean);
    BEGIN
      HideValidationDialog := NewHideValidationDialog;
    END;

    LOCAL PROCEDURE WriteDownDerivedLines@1(VAR TransLine3@1000 : Record 5741);
    VAR
      TransLine4@1001 : Record 5741;
      T337@1004 : Record 337;
      TempDerivedSpecification@1006 : TEMPORARY Record 336;
      ItemTrackingMgt@1005 : Codeunit 6500;
      QtyToReceive@1002 : Decimal;
      BaseQtyToReceive@1003 : Decimal;
      TrackingSpecificationExists@1007 : Boolean;
    BEGIN
      TransLine4.SETRANGE("Document No.",TransLine3."Document No.");
      TransLine4.SETRANGE("Derived From Line No.",TransLine3."Line No.");
      IF TransLine4.FIND('-') THEN BEGIN
        QtyToReceive := TransLine3."Qty. to Receive";
        BaseQtyToReceive := TransLine3."Qty. to Receive (Base)";

        T337.SETCURRENTKEY(
          "Source ID","Source Ref. No.","Source Type","Source Subtype",
          "Source Batch Name","Source Prod. Order Line");
        T337.SETRANGE("Source ID",TransLine3."Document No.");
        T337.SETRANGE("Source Ref. No.");
        T337.SETRANGE("Source Type",DATABASE::"Transfer Line");
        T337.SETRANGE("Source Subtype",1);
        T337.SETRANGE("Source Batch Name",'');
        T337.SETRANGE("Source Prod. Order Line",TransLine3."Line No.");
        T337.SETFILTER("Qty. to Handle (Base)",'<>0');

        TrackingSpecificationExists :=
          ItemTrackingMgt.SumUpItemTracking(T337,TempDerivedSpecification,TRUE,FALSE);

        REPEAT
          IF TrackingSpecificationExists THEN BEGIN
            TempDerivedSpecification.SETRANGE("Source Ref. No.",TransLine4."Line No.");
            IF TempDerivedSpecification.FINDFIRST THEN BEGIN
              TransLine4."Qty. to Receive (Base)" := TempDerivedSpecification."Qty. to Handle (Base)";
              TransLine4."Qty. to Receive" := TempDerivedSpecification."Qty. to Handle";
            END ELSE BEGIN
              TransLine4."Qty. to Receive (Base)" := 0;
              TransLine4."Qty. to Receive" := 0;
            END;
          END;
          IF TransLine4."Qty. to Receive (Base)" <= BaseQtyToReceive THEN BEGIN
            ReserveTransLine.TransferTransferToItemJnlLine(
              TransLine4,ItemJnlLine,TransLine4."Qty. to Receive (Base)",1);
            TransLine4."Quantity (Base)" :=
              TransLine4."Quantity (Base)" - TransLine4."Qty. to Receive (Base)";
            TransLine4.Quantity :=
              TransLine4.Quantity - TransLine4."Qty. to Receive";
            BaseQtyToReceive := BaseQtyToReceive - TransLine4."Qty. to Receive (Base)";
            QtyToReceive := QtyToReceive - TransLine4."Qty. to Receive";
          END ELSE BEGIN
            ReserveTransLine.TransferTransferToItemJnlLine(
              TransLine4,ItemJnlLine,BaseQtyToReceive,1);
            TransLine4.Quantity := TransLine4.Quantity - QtyToReceive;
            TransLine4."Quantity (Base)" := TransLine4."Quantity (Base)" - BaseQtyToReceive;
            BaseQtyToReceive := 0;
            QtyToReceive := 0;
          END;
          IF TransLine4."Quantity (Base)" = 0 THEN
            TransLine4.DELETE
          ELSE BEGIN
            TransLine4."Qty. to Ship" := TransLine4.Quantity;
            TransLine4."Qty. to Ship (Base)" := TransLine4."Quantity (Base)";
            TransLine4."Qty. to Receive" := TransLine4.Quantity;
            TransLine4."Qty. to Receive (Base)" := TransLine4."Quantity (Base)";
            TransLine4.ResetPostedQty;
            TransLine4."Outstanding Quantity" := TransLine4.Quantity;
            TransLine4."Outstanding Qty. (Base)" := TransLine4."Quantity (Base)";
            TransLine4.MODIFY;
          END;
        UNTIL (TransLine4.NEXT = 0) OR (BaseQtyToReceive = 0);
      END;

      IF BaseQtyToReceive <> 0 THEN
        ERROR(Text008);
    END;

    LOCAL PROCEDURE InsertRcptEntryRelation@38(VAR TransRcptLine@1002 : Record 5747) : Integer;
    VAR
      ItemEntryRelation@1001 : Record 6507;
      TempItemEntryRelation@1000 : TEMPORARY Record 6507;
    BEGIN
      TempItemEntryRelation2.RESET;
      TempItemEntryRelation2.DELETEALL;

      IF ItemJnlPostLine.CollectItemEntryRelation(TempItemEntryRelation) THEN BEGIN
        IF TempItemEntryRelation.FIND('-') THEN BEGIN
          REPEAT
            ItemEntryRelation := TempItemEntryRelation;
            ItemEntryRelation.TransferFieldsTransRcptLine(TransRcptLine);
            ItemEntryRelation.INSERT;
            TempItemEntryRelation2 := TempItemEntryRelation;
            TempItemEntryRelation2.INSERT;
          UNTIL TempItemEntryRelation.NEXT = 0;
          EXIT(0);
        END;
      END ELSE
        EXIT(ItemJnlLine."Item Shpt. Entry No.");
    END;

    LOCAL PROCEDURE CheckWarehouse@7301(VAR TransLine@1000 : Record 5741);
    VAR
      TransLine2@1001 : Record 5741;
      WhseValidateSourceLine@1003 : Codeunit 5777;
      ShowError@1002 : Boolean;
    BEGIN
      TransLine2.COPY(TransLine);
      IF TransLine2.FIND('-') THEN
        REPEAT
          GetLocation(TransLine2."Transfer-to Code");
          IF Location."Require Receive" OR Location."Require Put-away" THEN BEGIN
            IF Location."Bin Mandatory" THEN
              ShowError := TRUE
            ELSE
              IF WhseValidateSourceLine.WhseLinesExist(
                   DATABASE::"Transfer Line",
                   1,// In
                   TransLine2."Document No.",
                   TransLine2."Line No.",
                   0,
                   TransLine2.Quantity)
              THEN
                ShowError := TRUE;

            IF ShowError THEN
              ERROR(
                Text002,
                TransLine2."Document No.",
                TransLine2.FIELDCAPTION("Line No."),
                TransLine2."Line No.");
          END;
        UNTIL TransLine2.NEXT = 0;
    END;

    LOCAL PROCEDURE SaveTempWhseSplitSpec@5(TransLine@1001 : Record 5741);
    VAR
      TempHandlingSpecification@1000 : TEMPORARY Record 336;
    BEGIN
      TempWhseSplitSpecification.RESET;
      TempWhseSplitSpecification.DELETEALL;
      IF ItemJnlPostLine.CollectTrackingSpecification(TempHandlingSpecification) THEN
        IF TempHandlingSpecification.FIND('-') THEN
          REPEAT
            TempWhseSplitSpecification := TempHandlingSpecification;
            TempWhseSplitSpecification."Entry No." := TempHandlingSpecification."Transfer Item Entry No.";
            TempWhseSplitSpecification."Source Type" := DATABASE::"Transfer Line";
            TempWhseSplitSpecification."Source Subtype" := 1;
            TempWhseSplitSpecification."Source ID" := TransLine."Document No.";
            TempWhseSplitSpecification."Source Ref. No." := TransLine."Line No.";
            TempWhseSplitSpecification.INSERT;
          UNTIL TempHandlingSpecification.NEXT = 0;
    END;

    LOCAL PROCEDURE GetLocation@7300(LocationCode@1000 : Code[10]);
    BEGIN
      IF LocationCode = '' THEN
        Location.GetLocationSetup(LocationCode,Location)
      ELSE
        IF Location.Code <> LocationCode THEN
          Location.GET(LocationCode);
    END;

    LOCAL PROCEDURE IsWarehousePosting@12(LocationCode@1000 : Code[10]) : Boolean;
    BEGIN
      GetLocation(LocationCode);
      IF Location."Bin Mandatory" AND NOT (WhseReceive OR InvtPickPutaway) THEN
        EXIT(TRUE);
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE PostWhseJnlLine@4(ItemJnlLine@1000 : Record 83;OriginalQuantity@1001 : Decimal;OriginalQuantityBase@1006 : Decimal;VAR TempHandlingSpecification@1003 : TEMPORARY Record 336);
    VAR
      WhseJnlLine@1002 : Record 7311;
      TempWhseJnlLine2@1005 : TEMPORARY Record 7311;
      ItemTrackingMgt@1004 : Codeunit 6500;
      WMSMgmt@1007 : Codeunit 7302;
    BEGIN
      WITH ItemJnlLine DO BEGIN
        Quantity := OriginalQuantity;
        "Quantity (Base)" := OriginalQuantityBase;
        GetLocation("New Location Code");
        IF Location."Bin Mandatory" THEN
          IF WMSMgmt.CreateWhseJnlLine(ItemJnlLine,1,WhseJnlLine,TRUE) THEN BEGIN
            WMSMgmt.SetTransferLine(TransLine,WhseJnlLine,1,TransRcptHeader."No.");
            ItemTrackingMgt.SplitWhseJnlLine(WhseJnlLine,TempWhseJnlLine2,TempHandlingSpecification,TRUE);
            IF TempWhseJnlLine2.FIND('-') THEN
              REPEAT
                WMSMgmt.CheckWhseJnlLine(TempWhseJnlLine2,1,0,TRUE);
                WhseJnlRegisterLine.RegisterWhseJnlLine(TempWhseJnlLine2);
              UNTIL TempWhseJnlLine2.NEXT = 0;
          END;
      END;
    END;

    [External]
    PROCEDURE SetWhseRcptHeader@3(VAR WhseRcptHeader2@1000 : Record 7316);
    BEGIN
      WhseRcptHeader := WhseRcptHeader2;
      TempWhseRcptHeader := WhseRcptHeader;
      TempWhseRcptHeader.INSERT;
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforePostItemJournalLine@19(VAR ItemJournalLine@1000 : Record 83;TransferLine@1001 : Record 5741;TransferReceiptHeader@1002 : Record 5746;TransferReceiptLine@1003 : Record 5747);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeTransferOrderPostReceipt@9(VAR TransferHeader@1000 : Record 5740);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeTransferOderPostReceipt@7(VAR TransferHeader@1000 : Record 5740);
    BEGIN
      // will be deprecated
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterTransferOrderPostReceipt@11(VAR TransferHeader@1000 : Record 5740);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterTransferOderPostReceipt@10(VAR TransferHeader@1000 : Record 5740);
    BEGIN
      // will be deprecated
    END;

    LOCAL PROCEDURE LockTables@6(AutoCostPosting@1000 : Boolean);
    VAR
      GLEntry@1001 : Record 17;
      NoSeriesLine@1002 : Record 309;
    BEGIN
      NoSeriesLine.LOCKTABLE;
      IF NoSeriesLine.FINDLAST THEN;
      IF AutoCostPosting THEN BEGIN
        GLEntry.LOCKTABLE;
        IF GLEntry.FINDLAST THEN;
      END;
    END;

    LOCAL PROCEDURE ReleaseDocument@8(VAR TransferHeader@1000 : Record 5740);
    BEGIN
      IF TransferHeader.Status = TransferHeader.Status::Open THEN BEGIN
        CODEUNIT.RUN(CODEUNIT::"Release Transfer Document",TransferHeader);
        TransferHeader.Status := TransferHeader.Status::Open;
        TransferHeader.MODIFY;
        COMMIT;
        TransferHeader.Status := TransferHeader.Status::Released;
      END;
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterTransLineUpdateQtyReceived@13(VAR TransferLine@1000 : Record 5741);
    BEGIN
    END;

    BEGIN
    END.
  }
}

