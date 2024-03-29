OBJECT Codeunit 5704 TransferOrder-Post Shipment
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
            NoSeriesMgt@1003 : Codeunit 396;
            UpdateAnalysisView@1004 : Codeunit 410;
            UpdateItemAnalysisView@1009 : Codeunit 7150;
            RecordLinkManagement@1011 : Codeunit 447;
            Window@1006 : Dialog;
            LineCount@1005 : Integer;
            NextLineNo@1008 : Integer;
          BEGIN
            ReleaseDocument(Rec);
            TransHeader := Rec;
            TransHeader.SetHideValidationDialog(HideValidationDialog);

            OnBeforeTransferOrderPostShipment(TransHeader);

            WITH TransHeader DO BEGIN
              CheckBeforePost;

              WhseReference := "Posting from Whse. Ref.";
              "Posting from Whse. Ref." := 0;

              IF "Shipping Advice" = "Shipping Advice"::Complete THEN
                IF NOT GetShippingAdvice THEN
                  ERROR(Text008);

              CheckDim;

              TransLine.RESET;
              TransLine.SETRANGE("Document No.","No.");
              TransLine.SETRANGE("Derived From Line No.",0);
              TransLine.SETFILTER(Quantity,'<>0');
              TransLine.SETFILTER("Qty. to Ship",'<>0');
              IF TransLine.ISEMPTY THEN
                ERROR(Text001);

              WhseShip := TempWhseShptHeader.FINDFIRST;
              InvtPickPutaway := WhseReference <> 0;
              CheckItemInInventoryAndWarehouse(TransLine,NOT (WhseShip OR InvtPickPutaway));

              GetLocation("Transfer-from Code");
              IF Location."Bin Mandatory" AND NOT (WhseShip OR InvtPickPutaway) THEN
                WhsePosting := TRUE;

              Window.OPEN(
                '#1#################################\\' +
                Text003);

              Window.UPDATE(1,STRSUBSTNO(Text004,"No."));

              SourceCodeSetup.GET;
              SourceCode := SourceCodeSetup.Transfer;
              InvtSetup.GET;
              InvtSetup.TESTFIELD("Posted Transfer Shpt. Nos.");

              CheckInvtPostingSetup;

              LockTables(InvtSetup."Automatic Cost Posting");

              // Insert shipment header
              PostedWhseShptHeader.LOCKTABLE;
              TransShptHeader.LOCKTABLE;
              TransShptHeader.INIT;
              TransShptHeader.CopyFromTransferHeader(TransHeader);
              TransShptHeader."No. Series" := InvtSetup."Posted Transfer Shpt. Nos.";
              TransShptHeader."No." :=
                NoSeriesMgt.GetNextNo(
                  InvtSetup."Posted Transfer Shpt. Nos.","Posting Date",TRUE);
              TransShptHeader.INSERT;

              IF InvtSetup."Copy Comments Order to Shpt." THEN BEGIN
                CopyCommentLines(1,2,"No.",TransShptHeader."No.");
                RecordLinkManagement.CopyLinks(Rec,TransShptHeader);
              END;

              IF WhseShip THEN BEGIN
                WhseShptHeader.GET(TempWhseShptHeader."No.");
                WhsePostShpt.CreatePostedShptHeader(PostedWhseShptHeader,WhseShptHeader,TransShptHeader."No.","Posting Date");
              END;

              // Insert shipment lines
              LineCount := 0;
              IF WhseShip THEN
                PostedWhseShptLine.LOCKTABLE;
              IF InvtPickPutaway THEN
                WhseRqst.LOCKTABLE;
              TransShptLine.LOCKTABLE;
              TransLine.SETRANGE(Quantity);
              TransLine.SETRANGE("Qty. to Ship");
              IF TransLine.FIND('-') THEN
                REPEAT
                  LineCount := LineCount + 1;
                  Window.UPDATE(2,LineCount);

                  IF TransLine."Item No." <> '' THEN BEGIN
                    Item.GET(TransLine."Item No.");
                    Item.TESTFIELD(Blocked,FALSE);
                  END;

                  TransShptLine.INIT;
                  TransShptLine."Document No." := TransShptHeader."No.";
                  TransShptLine.CopyFromTransferLine(TransLine);

                  IF TransLine."Qty. to Ship" > 0 THEN BEGIN
                    OriginalQuantity := TransLine."Qty. to Ship";
                    OriginalQuantityBase := TransLine."Qty. to Ship (Base)";
                    PostItem(TransLine,TransShptHeader,TransShptLine,WhseShip,WhseShptHeader);
                    TransShptLine."Item Shpt. Entry No." := InsertShptEntryRelation(TransShptLine);
                    IF WhseShip THEN BEGIN
                      WhseShptLine.SETCURRENTKEY(
                        "No.","Source Type","Source Subtype","Source No.","Source Line No.");
                      WhseShptLine.SETRANGE("No.",WhseShptHeader."No.");
                      WhseShptLine.SETRANGE("Source Type",DATABASE::"Transfer Line");
                      WhseShptLine.SETRANGE("Source No.",TransLine."Document No.");
                      WhseShptLine.SETRANGE("Source Line No.",TransLine."Line No.");
                      WhseShptLine.FINDFIRST;
                      WhseShptLine.TESTFIELD("Qty. to Ship",TransShptLine.Quantity);
                      WhsePostShpt.CreatePostedShptLine(
                        WhseShptLine,PostedWhseShptHeader,PostedWhseShptLine,TempWhseSplitSpecification);
                    END;
                    IF WhsePosting THEN
                      PostWhseJnlLine(ItemJnlLine,OriginalQuantity,OriginalQuantityBase);
                  END;
                  TransShptLine.INSERT;
                UNTIL TransLine.NEXT = 0;

              InvtSetup.GET;
              IF InvtSetup."Automatic Cost Adjustment" <> InvtSetup."Automatic Cost Adjustment"::Never THEN BEGIN
                InvtAdjmt.SetProperties(TRUE,InvtSetup."Automatic Cost Posting");
                InvtAdjmt.MakeMultiLevelAdjmt;
              END;

              IF WhseShip THEN
                WhseShptLine.LOCKTABLE;
              TransLine.LOCKTABLE;
              TransLine.SETFILTER(Quantity,'<>0');
              TransLine.SETFILTER("Qty. to Ship",'<>0');
              IF TransLine.FIND('-') THEN BEGIN
                NextLineNo := AssignLineNo(TransLine."Document No.");
                REPEAT
                  CopyTransLine(TransLine2,TransLine,NextLineNo,TransHeader);
                  TransferTracking(TransLine,TransLine2,TransLine."Qty. to Ship (Base)");

                  TransLine.VALIDATE("Quantity Shipped",TransLine."Quantity Shipped" + TransLine."Qty. to Ship");

                  TransLine.UpdateWithWarehouseShipReceive;

                  TransLine.MODIFY;
                UNTIL TransLine.NEXT = 0;
              END;

              IF WhseShip THEN
                WhseShptLine.LOCKTABLE;
              LOCKTABLE;
              IF WhseShip THEN BEGIN
                WhsePostShpt.PostUpdateWhseDocuments(WhseShptHeader);
                TempWhseShptHeader.DELETE;
              END;

              "Last Shipment No." := TransShptHeader."No.";
              MODIFY;

              TransLine.SETRANGE(Quantity);
              TransLine.SETRANGE("Qty. to Ship");
              IF ShouldDeleteOneTransferOrder(TransLine) THEN
                DeleteOneTransferOrder(TransHeader,TransLine)
              ELSE BEGIN
                WhseTransferRelease.Release(TransHeader);
                ReserveTransLine.UpdateItemTrackingAfterPosting(TransHeader,0);
              END;

              IF NOT (InvtPickPutaway OR "Direct Transfer") THEN
                COMMIT;
              CLEAR(WhsePostShpt);
              CLEAR(InvtAdjmt);
              Window.CLOSE;
            END;
            UpdateAnalysisView.UpdateAll(0,TRUE);
            UpdateItemAnalysisView.UpdateAll(0,TRUE);
            Rec := TransHeader;
            OnAfterTransferOrderPostShipment(Rec);
          END;

  }
  CODE
  {
    VAR
      Text001@1001 : TextConst 'DAN=Der er intet at bogf�re.;ENU=There is nothing to post.';
      Text002@1002 : TextConst 'DAN="Der kr�ves lagerekspedition for overflytningsordre = %1, %2 = %3.";ENU="Warehouse handling is required for Transfer order = %1, %2 = %3."';
      Text003@1003 : TextConst 'DAN=Overflyt.linjer bogf�res   #2######;ENU=Posting transfer lines     #2######';
      Text004@1004 : TextConst 'DAN=Overflytningsordre %1;ENU=Transfer Order %1';
      Text005@1005 : TextConst 'DAN=Kombinationen af dimensioner, der bliver brugt i overflytningsordren %1 er sp�rret. %2;ENU=The combination of dimensions used in transfer order %1 is blocked. %2';
      Text006@1006 : TextConst 'DAN=Kombinationen af dimensioner, der bliver brugt i overflytningsordren %1 linjenr. %2 er sp�rret. %3;ENU=The combination of dimensions used in transfer order %1, line no. %2 is blocked. %3';
      Text007@1007 : TextConst 'DAN=De dimensioner, der bruges i overflytningsordre %1, linjenr. %2, er ikke gyldige. %3.;ENU=The dimensions that are used in transfer order %1, line no. %2 are not valid. %3.';
      TransShptHeader@1008 : Record 5744;
      TransShptLine@1009 : Record 5745;
      TransHeader@1010 : Record 5740;
      TransLine@1011 : Record 5741;
      TransLine2@1012 : Record 5741;
      Location@1015 : Record 14;
      ItemJnlLine@1016 : Record 83;
      WhseRqst@1027 : Record 5765;
      WhseShptHeader@1022 : Record 7320;
      TempWhseShptHeader@1030 : TEMPORARY Record 7320;
      WhseShptLine@1028 : Record 7321;
      PostedWhseShptHeader@1034 : Record 7322;
      PostedWhseShptLine@1035 : Record 7323;
      TempWhseSplitSpecification@1037 : TEMPORARY Record 336;
      TempHandlingSpecification@1018 : TEMPORARY Record 336;
      ItemJnlPostLine@1021 : Codeunit 22;
      DimMgt@1017 : Codeunit 408;
      WhseTransferRelease@1019 : Codeunit 5773;
      ReserveTransLine@1020 : Codeunit 99000836;
      WhsePostShpt@1036 : Codeunit 5763;
      InvtAdjmt@1041 : Codeunit 5895;
      WhseJnlRegisterLine@1045 : Codeunit 7301;
      SourceCode@1023 : Code[10];
      HideValidationDialog@1024 : Boolean;
      WhseShip@1026 : Boolean;
      WhsePosting@1033 : Boolean;
      InvtPickPutaway@1039 : Boolean;
      WhseReference@1038 : Integer;
      OriginalQuantity@1031 : Decimal;
      OriginalQuantityBase@1032 : Decimal;
      Text008@11042 : TextConst 'DAN=Denne ordre skal v�re en fuld leverance.;ENU=This order must be a complete shipment.';
      Text009@1042 : TextConst 'DAN=Vare %1 er ikke p� lager.;ENU=Item %1 is not in inventory.';

    LOCAL PROCEDURE PostItem@24(VAR TransferLine@1002 : Record 5741;TransShptHeader2@1001 : Record 5744;TransShptLine2@1000 : Record 5745;WhseShip@1003 : Boolean;WhseShptHeader2@1004 : Record 7320);
    BEGIN
      CreateItemJnlLine(ItemJnlLine,TransferLine,TransShptHeader2,TransShptLine2);
      ReserveItemJnlLine(ItemJnlLine,TransferLine,WhseShip,WhseShptHeader2);
      OnBeforePostItemJournalLine(ItemJnlLine,TransferLine,TransShptHeader2,TransShptLine2);
      ItemJnlPostLine.RunWithCheck(ItemJnlLine);
    END;

    LOCAL PROCEDURE CreateItemJnlLine@20(VAR ItemJnlLine@1003 : Record 83;TransferLine@1002 : Record 5741;TransShptHeader2@1001 : Record 5744;TransShptLine2@1000 : Record 5745);
    BEGIN
      WITH ItemJnlLine DO BEGIN
        INIT;
        CopyDocumentFields(
          "Document Type"::"Transfer Shipment",TransShptHeader2."No.","External Document No.",SourceCode,'');
        "Posting Date" := TransShptHeader2."Posting Date";
        "Document Date" := TransShptHeader2."Posting Date";
        "Document Line No." := TransShptLine2."Line No.";
        "Order Type" := "Order Type"::Transfer;
        "Order No." := TransShptHeader2."Transfer Order No.";
        "Order Line No." := TransferLine."Line No.";
        "Entry Type" := "Entry Type"::Transfer;
        "Item No." := TransShptLine2."Item No.";
        "Variant Code" := TransShptLine2."Variant Code";
        Description := TransShptLine2.Description;
        "Location Code" := TransShptHeader2."Transfer-from Code";
        "New Location Code" := TransHeader."In-Transit Code";
        "Bin Code" := TransLine."Transfer-from Bin Code";
        "Shortcut Dimension 1 Code" := TransShptLine2."Shortcut Dimension 1 Code";
        "New Shortcut Dimension 1 Code" := TransShptLine2."Shortcut Dimension 1 Code";
        "Shortcut Dimension 2 Code" := TransShptLine2."Shortcut Dimension 2 Code";
        "New Shortcut Dimension 2 Code" := TransShptLine2."Shortcut Dimension 2 Code";
        "Dimension Set ID" := TransShptLine2."Dimension Set ID";
        "New Dimension Set ID" := TransShptLine2."Dimension Set ID";
        Quantity := TransShptLine2.Quantity;
        "Invoiced Quantity" := TransShptLine2.Quantity;
        "Quantity (Base)" := TransShptLine2."Quantity (Base)";
        "Invoiced Qty. (Base)" := TransShptLine2."Quantity (Base)";
        "Gen. Prod. Posting Group" := TransShptLine2."Gen. Prod. Posting Group";
        "Inventory Posting Group" := TransShptLine2."Inventory Posting Group";
        "Unit of Measure Code" := TransShptLine2."Unit of Measure Code";
        "Qty. per Unit of Measure" := TransShptLine2."Qty. per Unit of Measure";
        "Country/Region Code" := TransShptHeader2."Trsf.-from Country/Region Code";
        "Transaction Type" := TransShptHeader2."Transaction Type";
        "Transport Method" := TransShptHeader2."Transport Method";
        "Entry/Exit Point" := TransShptHeader2."Entry/Exit Point";
        Area := TransShptHeader2.Area;
        "Transaction Specification" := TransShptHeader2."Transaction Specification";
        "Product Group Code" := TransferLine."Product Group Code";
        "Item Category Code" := TransferLine."Item Category Code";
        "Applies-to Entry" := TransferLine."Appl.-to Item Entry";
        "Direct Transfer" := TransferLine."Direct Transfer";
      END;
    END;

    LOCAL PROCEDURE ReserveItemJnlLine@21(VAR ItemJnlLine@1001 : Record 83;VAR TransferLine@1000 : Record 5741;WhseShip@1003 : Boolean;WhseShptHeader2@1002 : Record 7320);
    BEGIN
      IF WhseShip AND (WhseShptHeader2."Document Status" = WhseShptHeader2."Document Status"::"Partially Picked") THEN
        ReserveTransLine.TransferWhseShipmentToItemJnlLine(
          TransferLine,ItemJnlLine,WhseShptHeader2,ItemJnlLine."Quantity (Base)")
      ELSE
        ReserveTransLine.TransferTransferToItemJnlLine(
          TransferLine,ItemJnlLine,ItemJnlLine."Quantity (Base)",0);
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

    LOCAL PROCEDURE CheckDimValuePosting@28(TransferHeader@1001 : Record 5740;TransferLine@1000 : Record 5741);
    VAR
      TableIDArr@1002 : ARRAY [10] OF Integer;
      NumberArr@1003 : ARRAY [10] OF Code[20];
    BEGIN
      TableIDArr[1] := DATABASE::Item;
      NumberArr[1] := TransferLine."Item No.";
      IF TransferLine."Line No." = 0 THEN
        IF NOT DimMgt.CheckDimValuePosting(TableIDArr,NumberArr,TransferHeader."Dimension Set ID") THEN
          ERROR(Text007,TransHeader."No.",TransferLine."Line No.",DimMgt.GetDimValuePostingErr);

      IF TransferLine."Line No." <> 0 THEN
        IF NOT DimMgt.CheckDimValuePosting(TableIDArr,NumberArr,TransferLine."Dimension Set ID") THEN
          ERROR(Text007,TransHeader."No.",TransferLine."Line No.",DimMgt.GetDimValuePostingErr);
    END;

    PROCEDURE SetHideValidationDialog@14(NewHideValidationDialog@1000 : Boolean);
    BEGIN
      HideValidationDialog := NewHideValidationDialog;
    END;

    LOCAL PROCEDURE AssignLineNo@1(FromDocNo@1000 : Code[20]) : Integer;
    VAR
      TransLine3@1002 : Record 5741;
    BEGIN
      TransLine3.SETRANGE("Document No.",FromDocNo);
      IF TransLine3.FINDLAST THEN
        EXIT(TransLine3."Line No." + 10000);
    END;

    LOCAL PROCEDURE InsertShptEntryRelation@38(VAR TransShptLine@1002 : Record 5745) : Integer;
    VAR
      TempHandlingSpecification2@1000 : TEMPORARY Record 336;
      ItemEntryRelation@1001 : Record 6507;
      ItemTrackingMgt@1005 : Codeunit 6500;
      WhseSNRequired@1003 : Boolean;
      WhseLNRequired@1004 : Boolean;
    BEGIN
      IF WhsePosting THEN BEGIN
        TempWhseSplitSpecification.RESET;
        TempWhseSplitSpecification.DELETEALL;
      END;

      TempHandlingSpecification2.RESET;
      IF ItemJnlPostLine.CollectTrackingSpecification(TempHandlingSpecification2) THEN BEGIN
        TempHandlingSpecification2.SETRANGE("Buffer Status",0);
        IF TempHandlingSpecification2.FIND('-') THEN BEGIN
          REPEAT
            IF WhsePosting OR WhseShip OR InvtPickPutaway THEN BEGIN
              ItemTrackingMgt.CheckWhseItemTrkgSetup(
                TransShptLine."Item No.",WhseSNRequired,WhseLNRequired,FALSE);
              IF WhseSNRequired OR WhseLNRequired THEN BEGIN
                TempWhseSplitSpecification := TempHandlingSpecification2;
                TempWhseSplitSpecification."Source Type" := DATABASE::"Transfer Line";
                TempWhseSplitSpecification."Source ID" := TransLine."Document No.";
                TempWhseSplitSpecification."Source Ref. No." := TransLine."Line No.";
                TempWhseSplitSpecification.INSERT;
              END;
            END;

            ItemEntryRelation.InitFromTrackingSpec(TempHandlingSpecification2);
            ItemEntryRelation.TransferFieldsTransShptLine(TransShptLine);
            ItemEntryRelation.INSERT;
            TempHandlingSpecification := TempHandlingSpecification2;
            TempHandlingSpecification."Source Prod. Order Line" := TransShptLine."Line No.";
            TempHandlingSpecification."Buffer Status" := TempHandlingSpecification."Buffer Status"::MODIFY;
            TempHandlingSpecification.INSERT;
          UNTIL TempHandlingSpecification2.NEXT = 0;
          OnAfterInsertShptEntryRelation(TransLine,WhseShip,0);
          EXIT(0);
        END;
      END ELSE BEGIN
        OnAfterInsertShptEntryRelation(TransLine,WhseShip,ItemJnlLine."Item Shpt. Entry No.");
        EXIT(ItemJnlLine."Item Shpt. Entry No.");
      END;
    END;

    LOCAL PROCEDURE TransferTracking@3(VAR FromTransLine@1003 : Record 5741;VAR ToTransLine@1004 : Record 5741;TransferQty@1001 : Decimal);
    VAR
      DummySpecification@1005 : Record 336;
    BEGIN
      TempHandlingSpecification.RESET;
      TempHandlingSpecification.SETRANGE("Source Prod. Order Line",ToTransLine."Derived From Line No.");
      IF TempHandlingSpecification.FIND('-') THEN BEGIN
        REPEAT
          ReserveTransLine.TransferTransferToTransfer(
            FromTransLine,ToTransLine,-TempHandlingSpecification."Quantity (Base)",1,TempHandlingSpecification);
          TransferQty += TempHandlingSpecification."Quantity (Base)";
        UNTIL TempHandlingSpecification.NEXT = 0;
        TempHandlingSpecification.DELETEALL;
      END;

      IF TransferQty > 0 THEN
        ReserveTransLine.TransferTransferToTransfer(
          FromTransLine,ToTransLine,TransferQty,1,DummySpecification);
    END;

    LOCAL PROCEDURE CheckWarehouse@7301(TransLine@1000 : Record 5741);
    VAR
      WhseValidateSourceLine@1003 : Codeunit 5777;
      ShowError@1002 : Boolean;
    BEGIN
      GetLocation(TransLine."Transfer-from Code");
      IF Location."Require Pick" OR Location."Require Shipment" THEN BEGIN
        IF Location."Bin Mandatory" THEN
          ShowError := TRUE
        ELSE
          IF WhseValidateSourceLine.WhseLinesExist(
               DATABASE::"Transfer Line",
               0,// Out
               TransLine."Document No.",
               TransLine."Line No.",
               0,
               TransLine.Quantity)
          THEN
            ShowError := TRUE;

        IF ShowError THEN
          ERROR(
            Text002,
            TransLine."Document No.",
            TransLine.FIELDCAPTION("Line No."),
            TransLine."Line No.");
      END;
    END;

    LOCAL PROCEDURE GetLocation@7300(LocationCode@1000 : Code[10]);
    BEGIN
      IF LocationCode = '' THEN
        Location.GetLocationSetup(LocationCode,Location)
      ELSE
        IF Location.Code <> LocationCode THEN
          Location.GET(LocationCode);
    END;

    LOCAL PROCEDURE PostWhseJnlLine@4(ItemJnlLine@1000 : Record 83;OriginalQuantity@1001 : Decimal;OriginalQuantityBase@1006 : Decimal);
    VAR
      WhseJnlLine@1002 : Record 7311;
      TempWhseJnlLine2@1005 : TEMPORARY Record 7311;
      ItemTrackingMgt@1004 : Codeunit 6500;
      WMSMgmt@1007 : Codeunit 7302;
    BEGIN
      WITH ItemJnlLine DO BEGIN
        Quantity := OriginalQuantity;
        "Quantity (Base)" := OriginalQuantityBase;
        GetLocation("Location Code");
        IF Location."Bin Mandatory" THEN
          IF WMSMgmt.CreateWhseJnlLine(ItemJnlLine,1,WhseJnlLine,FALSE) THEN BEGIN
            WMSMgmt.SetTransferLine(TransLine,WhseJnlLine,0,TransShptHeader."No.");
            ItemTrackingMgt.SplitWhseJnlLine(
              WhseJnlLine,TempWhseJnlLine2,TempWhseSplitSpecification,TRUE);
            IF TempWhseJnlLine2.FIND('-') THEN
              REPEAT
                WMSMgmt.CheckWhseJnlLine(TempWhseJnlLine2,1,0,TRUE);
                WhseJnlRegisterLine.RegisterWhseJnlLine(TempWhseJnlLine2);
              UNTIL TempWhseJnlLine2.NEXT = 0;
          END;
      END;
    END;

    [External]
    PROCEDURE SetWhseShptHeader@5(VAR WhseShptHeader2@1000 : Record 7320);
    BEGIN
      WhseShptHeader := WhseShptHeader2;
      TempWhseShptHeader := WhseShptHeader;
      TempWhseShptHeader.INSERT;
    END;

    LOCAL PROCEDURE GetShippingAdvice@6() : Boolean;
    VAR
      TransLine@1000 : Record 5741;
    BEGIN
      TransLine.SETRANGE("Document No.",TransHeader."No.");
      IF TransLine.FIND('-') THEN
        REPEAT
          IF TransLine."Quantity (Base)" <>
             TransLine."Qty. to Ship (Base)" + TransLine."Qty. Shipped (Base)"
          THEN
            EXIT(FALSE);
        UNTIL TransLine.NEXT = 0;
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE CheckItemInInventory@1043(TransLine@1000 : Record 5741);
    VAR
      Item@1001 : Record 27;
    BEGIN
      WITH Item DO BEGIN
        GET(TransLine."Item No.");
        SETFILTER("Variant Filter",TransLine."Variant Code");
        SETFILTER("Location Filter",TransLine."Transfer-from Code");
        CALCFIELDS(Inventory);
        IF Inventory <= 0 THEN
          ERROR(Text009,TransLine."Item No.");
      END;
    END;

    LOCAL PROCEDURE CheckItemInInventoryAndWarehouse@8(VAR TransLine@1000 : Record 5741;NeedCheckWarehouse@1001 : Boolean);
    VAR
      TransLine2@1002 : Record 5741;
    BEGIN
      TransLine2.COPYFILTERS(TransLine);
      TransLine2.FINDSET;
      REPEAT
        CheckItemInInventory(TransLine2);
        IF  NeedCheckWarehouse THEN
          CheckWarehouse(TransLine2);
      UNTIL TransLine2.NEXT = 0;
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforePostItemJournalLine@13(VAR ItemJournalLine@1003 : Record 83;TransferLine@1000 : Record 5741;TransferShipmentHeader@1001 : Record 5744;TransferShipmentLine@1002 : Record 5745);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeTransferOrderPostShipment@7(VAR TransferHeader@1000 : Record 5740);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterTransferOrderPostShipment@10(VAR TransferHeader@1000 : Record 5740);
    BEGIN
    END;

    LOCAL PROCEDURE LockTables@9(AutoCostPosting@1000 : Boolean);
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

    LOCAL PROCEDURE CopyTransLine@11(VAR NewTransferLine@1000 : Record 5741;TransferLine@1001 : Record 5741;VAR NextLineNo@1002 : Integer;TransferHeader@1003 : Record 5740);
    BEGIN
      NewTransferLine.INIT;
      NewTransferLine := TransferLine;
      IF TransferHeader."In-Transit Code" <> '' THEN
        NewTransferLine."Transfer-from Code" := TransferLine."In-Transit Code";
      NewTransferLine."In-Transit Code" := '';
      NewTransferLine."Derived From Line No." := TransferLine."Line No.";
      NewTransferLine."Line No." := NextLineNo;
      NextLineNo := NextLineNo + 10000;
      NewTransferLine.Quantity := TransferLine."Qty. to Ship";
      NewTransferLine."Quantity (Base)" := TransferLine."Qty. to Ship (Base)";
      NewTransferLine."Qty. to Ship" := NewTransferLine.Quantity;
      NewTransferLine."Qty. to Ship (Base)" := NewTransferLine."Quantity (Base)";
      NewTransferLine."Qty. to Receive" := NewTransferLine.Quantity;
      NewTransferLine."Qty. to Receive (Base)" := NewTransferLine."Quantity (Base)";
      NewTransferLine.ResetPostedQty;
      NewTransferLine."Outstanding Quantity" := NewTransferLine.Quantity;
      NewTransferLine."Outstanding Qty. (Base)" := NewTransferLine."Quantity (Base)";
      NewTransferLine.INSERT;
    END;

    LOCAL PROCEDURE ReleaseDocument@12(VAR TransferHeader@1000 : Record 5740);
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
    LOCAL PROCEDURE OnAfterInsertShptEntryRelation@16(VAR TransLine@1000 : Record 5741;WhseShip@1001 : Boolean;EntryNo@1002 : Integer);
    BEGIN
    END;

    BEGIN
    END.
  }
}

