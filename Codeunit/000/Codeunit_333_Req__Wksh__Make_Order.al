OBJECT Codeunit 333 Req. Wksh.-Make Order
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    TableNo=246;
    Permissions=TableData 37=m;
    OnRun=BEGIN
            IF PlanningResiliency THEN
              LOCKTABLE;

            CarryOutReqLineAction(Rec);
          END;

  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Kladdenavn                         #1##########\\;ENU=Worksheet Name                     #1##########\\';
      Text001@1001 : TextConst 'DAN=Indk�bskladdelinjerne kontrolleres #2######\;ENU=Checking worksheet lines           #2######\';
      Text002@1002 : TextConst 'DAN=K�bsordrerne oprettes              #3######\;ENU=Creating purchase orders           #3######\';
      Text003@1003 : TextConst 'DAN=K�bsordrelinjerne oprettes         #4######\;ENU=Creating purchase lines            #4######\';
      Text004@1004 : TextConst 'DAN=Indk�bskladdelinjerne opdateres    #5######;ENU=Updating worksheet lines           #5######';
      Text005@1005 : TextConst 'DAN=Indk�bskladdelinjerne slettes      #5######;ENU=Deleting worksheet lines           #5######';
      Text006@1006 : TextConst 'DAN=%1 i salgsordre %2 er allerede knyttet til k�bsordre %3.;ENU=%1 on sales order %2 is already associated with purchase order %3.';
      Text007@1007 : TextConst 'DAN=<Month Text>;ENU=<Month Text>';
      Text008@1008 : TextConst 'DAN=Kombinationen af dimensioner, der bliver brugt i %1 %2, %3, %4 er sp�rret. %5;ENU=The combination of dimensions used in %1 %2, %3, %4 is blocked. %5';
      Text009@1009 : TextConst 'DAN=En dimension, der bliver brugt i %1 %2, %3, %4, har for�rsaget en fejl. %5;ENU=A dimension used in %1 %2, %3, %4 has caused an error. %5';
      ReservEntry@1050 : Record 337;
      PurchSetup@1010 : Record 312;
      ReqTemplate@1011 : Record 244;
      ReqWkshName@1012 : Record 245;
      PurchOrderHeader@1016 : Record 38;
      PurchOrderLine@1018 : Record 39;
      SalesOrderHeader@1019 : Record 36;
      SalesOrderLine@1020 : Record 37;
      TransHeader@1028 : Record 5740;
      AccountingPeriod@1022 : Record 50;
      TempFailedReqLine@1054 : TEMPORARY Record 246;
      PurchasingCode@1046 : Record 5721;
      TempDocumentEntry@1015 : TEMPORARY Record 265;
      ReqWkshMakeOrders@1053 : Codeunit 333;
      TransferExtendedText@1027 : Codeunit 378;
      ReserveReqLine@1025 : Codeunit 99000833;
      DimMgt@1026 : Codeunit 408;
      Window@1029 : Dialog;
      OrderDateReq@1030 : Date;
      PostingDateReq@1031 : Date;
      ReceiveDateReq@1032 : Date;
      EndOrderDate@1035 : Date;
      PlanningResiliency@1055 : Boolean;
      PrintPurchOrders@1034 : Boolean;
      ReferenceReq@1033 : Text[35];
      MonthText@1044 : Text[30];
      OrderCounter@1036 : Integer;
      LineCount@1037 : Integer;
      OrderLineCounter@1038 : Integer;
      StartLineNo@1039 : Integer;
      NextLineNo@1040 : Integer;
      Day@1041 : Integer;
      Week@1042 : Integer;
      Month@1043 : Integer;
      CounterFailed@1052 : Integer;
      PrevPurchCode@1047 : Code[10];
      PrevShipToCode@1017 : Code[10];
      Text010@1049 : TextConst 'DAN=skal stemme overens med %1 p� salgsordre %2, linje %3;ENU=must match %1 on Sales Order %2, Line %3';
      PrevChangedDocOrderType@1013 : Option;
      PrevChangedDocOrderNo@1014 : Code[20];
      PrevLocationCode@1021 : Code[10];
      NameAddressDetails@1024 : Text;

    PROCEDURE CarryOutBatchAction@18(VAR ReqLine2@1000 : Record 246);
    VAR
      ReqLine@1001 : Record 246;
    BEGIN
      ReqLine.COPY(ReqLine2);
      ReqLine.SETRANGE("Accept Action Message",TRUE);
      Code(ReqLine);
      ReqLine2 := ReqLine;
    END;

    [External]
    PROCEDURE Set@1(NewPurchOrderHeader@1000 : Record 38;NewEndingOrderDate@1001 : Date;NewPrintPurchOrder@1002 : Boolean);
    BEGIN
      PurchOrderHeader := NewPurchOrderHeader;
      EndOrderDate := NewEndingOrderDate;
      PrintPurchOrders := NewPrintPurchOrder;
      OrderDateReq := PurchOrderHeader."Order Date";
      PostingDateReq := PurchOrderHeader."Posting Date";
      ReceiveDateReq := PurchOrderHeader."Expected Receipt Date";
      ReferenceReq := PurchOrderHeader."Your Reference";
      OnAfterSet(NewPurchOrderHeader);
    END;

    LOCAL PROCEDURE Code@8(VAR ReqLine@1001 : Record 246);
    VAR
      ReqLine2@1002 : Record 246;
      ReqLine3@1003 : Record 246;
    BEGIN
      InitShipReceiveDetails;
      WITH ReqLine DO BEGIN
        CLEAR(PurchOrderHeader);

        SETRANGE("Worksheet Template Name","Worksheet Template Name");
        SETRANGE("Journal Batch Name","Journal Batch Name");
        IF NOT PlanningResiliency THEN
          LOCKTABLE;

        IF "Planning Line Origin" <> "Planning Line Origin"::"Order Planning" THEN
          ReqTemplate.GET("Worksheet Template Name");

        IF ReqTemplate.Recurring THEN BEGIN
          SETRANGE("Order Date",0D,EndOrderDate);
          SETFILTER("Expiration Date",'%1 | %2..',0D,WORKDATE);
        END;

        IF NOT FIND('=><') THEN BEGIN
          "Line No." := 0;
          COMMIT;
          EXIT;
        END;

        IF ReqTemplate.Recurring THEN
          Window.OPEN(
            Text000 +
            Text001 +
            Text002 +
            Text003 +
            Text004)
        ELSE
          Window.OPEN(
            Text000 +
            Text001 +
            Text002 +
            Text003 +
            Text005);

        Window.UPDATE(1,"Journal Batch Name");

        // Check lines
        LineCount := 0;
        StartLineNo := "Line No.";
        REPEAT
          LineCount := LineCount + 1;
          Window.UPDATE(2,LineCount);
          CheckRecurringLine(ReqLine);
          CheckReqWkshLine(ReqLine);
          IF NEXT = 0 THEN
            FIND('-');
        UNTIL "Line No." = StartLineNo;

        // Create lines
        LineCount := 0;
        OrderCounter := 0;
        OrderLineCounter := 0;
        CLEAR(PurchOrderHeader);
        SetPurchOrderHeader;
        SETCURRENTKEY(
          "Worksheet Template Name","Journal Batch Name","Vendor No.",
          "Sell-to Customer No.","Ship-to Code","Order Address Code","Currency Code",
          "Ref. Order Type","Ref. Order Status","Ref. Order No.",
          "Location Code","Transfer-from Code","Purchasing Code");

        IF FIND('-') THEN
          REPEAT
            IF PlanningResiliency THEN BEGIN
              IF NOT TryCarryOutReqLineAction(ReqLine) THEN BEGIN
                SetFailedReqLine(ReqLine);
                CounterFailed := CounterFailed + 1;
              END;
            END ELSE
              CarryOutReqLineAction(ReqLine);
          UNTIL NEXT = 0;

        IF PrintPurchOrders THEN
          PrintTransOrder(TransHeader);

        IF PurchOrderHeader."Buy-from Vendor No." <> '' THEN
          FinalizeOrderHeader(PurchOrderHeader,ReqLine);

        IF PrevChangedDocOrderNo <> '' THEN
          PrintChangedDocument(PrevChangedDocOrderType,PrevChangedDocOrderNo);

        // Copy number of created orders and current journal batch name to requisition worksheet
        INIT;
        "Line No." := OrderCounter;

        IF OrderCounter <> 0 THEN
          IF NOT ReqTemplate.Recurring THEN BEGIN
            // Not a recurring journal
            ReqLine2.COPY(ReqLine);
            ReqLine2.SETFILTER("Vendor No.",'<>%1','');
            IF ReqLine2.FINDFIRST THEN; // Remember the last line
            IF FIND('-') THEN
              REPEAT
                TempFailedReqLine := ReqLine;
                IF NOT TempFailedReqLine.FIND THEN
                  DELETE(TRUE);
              UNTIL NEXT = 0;

            ReqLine3.SETRANGE("Worksheet Template Name","Worksheet Template Name");
            ReqLine3.SETRANGE("Journal Batch Name","Journal Batch Name");
            IF NOT ReqLine3.FINDLAST THEN
              IF INCSTR("Journal Batch Name") <> '' THEN BEGIN
                ReqWkshName.GET("Worksheet Template Name","Journal Batch Name");
                ReqWkshName.DELETE;
                ReqWkshName.Name := INCSTR("Journal Batch Name");
                IF ReqWkshName.INSERT THEN;
                "Journal Batch Name" := ReqWkshName.Name;
              END;
          END;
      END;
    END;

    PROCEDURE SetCreatedDocumentBuffer@24(VAR TempDocumentEntryNew@1000 : TEMPORARY Record 265);
    BEGIN
      TempDocumentEntry.COPY(TempDocumentEntryNew,TRUE);
    END;

    LOCAL PROCEDURE CheckReqWkshLine@2(VAR ReqLine2@1000 : Record 246);
    VAR
      SalesLine@1004 : Record 37;
      Purchasing@1005 : Record 5721;
      TableID@1002 : ARRAY [10] OF Integer;
      No@1003 : ARRAY [10] OF Code[20];
    BEGIN
      WITH ReqLine2 DO BEGIN
        IF ("No." <> '') OR ("Vendor No." <> '') OR (Quantity <> 0) THEN BEGIN
          TESTFIELD("No.");
          IF "Action Message" <> "Action Message"::Cancel THEN
            TESTFIELD(Quantity);
          IF ("Action Message" = "Action Message"::" ") OR
             ("Action Message" = "Action Message"::New)
          THEN
            IF "Replenishment System" = "Replenishment System"::Purchase THEN BEGIN
              IF "Planning Line Origin" = "Planning Line Origin"::"Order Planning" THEN
                TESTFIELD("Supply From");
              TESTFIELD("Vendor No.")
            END ELSE
              IF "Replenishment System" = "Replenishment System"::Transfer THEN BEGIN
                TESTFIELD("Location Code");
                IF "Planning Line Origin" = "Planning Line Origin"::"Order Planning" THEN
                  TESTFIELD("Supply From");
                TESTFIELD("Transfer-from Code");
              END;
        END;

        IF NOT DimMgt.CheckDimIDComb("Dimension Set ID") THEN
          ERROR(
            Text008,
            TABLECAPTION,"Worksheet Template Name","Journal Batch Name","Line No.",
            DimMgt.GetDimCombErr);

        TableID[1] := DimMgt.TypeToTableID3(Type);
        No[1] := "No.";
        IF NOT DimMgt.CheckDimValuePosting(TableID,No,"Dimension Set ID") THEN
          IF "Line No." <> 0 THEN
            ERROR(
              Text009,
              TABLECAPTION,"Worksheet Template Name","Journal Batch Name","Line No.",
              DimMgt.GetDimValuePostingErr)
          ELSE
            ERROR(DimMgt.GetDimValuePostingErr);

        IF SalesLine.GET(SalesLine."Document Type"::Order,"Sales Order No.","Sales Order Line No.") AND
           (SalesLine."Unit of Measure Code" <> "Unit of Measure Code")
        THEN
          IF SalesLine."Drop Shipment" OR
             (PurchasingCode.GET("Purchasing Code") AND PurchasingCode."Drop Shipment")
          THEN
            FIELDERROR(
              "Unit of Measure Code",
              STRSUBSTNO(
                Text010,
                SalesLine.FIELDCAPTION("Unit of Measure Code"),
                SalesLine."Document No.",
                SalesLine."Line No."));

        IF Purchasing.GET("Purchasing Code") THEN
          IF Purchasing."Drop Shipment" OR Purchasing."Special Order" THEN BEGIN
            SalesLine.GET(SalesLine."Document Type"::Order,"Sales Order No.","Sales Order Line No.");
            CheckLocation(ReqLine2);
            IF (Purchasing."Drop Shipment" <> SalesLine."Drop Shipment") OR
               (Purchasing."Special Order" <> SalesLine."Special Order")
            THEN
              FIELDERROR(
                "Purchasing Code",
                STRSUBSTNO(
                  Text010,
                  SalesLine.FIELDCAPTION("Purchasing Code"),
                  SalesLine."Document No.",
                  SalesLine."Line No."));
          END;
      END;

      OnAfterCheckReqWkshLine(ReqLine2);
    END;

    LOCAL PROCEDURE CarryOutReqLineAction@14(VAR ReqLine@1001 : Record 246);
    VAR
      CarryOutAction@1000 : Codeunit 99000813;
    BEGIN
      WITH ReqLine DO
        CASE "Replenishment System" OF
          "Replenishment System"::Transfer:
            CASE "Action Message" OF
              "Action Message"::Cancel:
                BEGIN
                  CarryOutAction.DeleteOrderLines(ReqLine);
                  OrderCounter := OrderCounter + 1;
                END;
              "Action Message"::"Change Qty.","Action Message"::Reschedule,"Action Message"::"Resched. & Chg. Qty.":
                BEGIN
                  IF (PrevChangedDocOrderNo <> '') AND
                     (("Ref. Order Type" <> PrevChangedDocOrderType) OR ("Ref. Order No." <> PrevChangedDocOrderNo))
                  THEN
                    PrintChangedDocument(PrevChangedDocOrderType,PrevChangedDocOrderNo);
                  CarryOutAction.SetPrintOrder(FALSE);
                  CarryOutAction.TransOrderChgAndReshedule(ReqLine);
                  PrevChangedDocOrderType := "Ref. Order Type";
                  PrevChangedDocOrderNo := "Ref. Order No.";
                  OrderCounter := OrderCounter + 1;
                END;
              "Action Message"::New,"Action Message"::" ":
                BEGIN
                  CarryOutAction.SetPrintOrder(PrintPurchOrders);
                  CarryOutAction.InsertTransLine(ReqLine,TransHeader);
                  OrderCounter := OrderCounter + 1;
                END;
            END;
          "Replenishment System"::Purchase,"Replenishment System"::"Prod. Order":
            CASE "Action Message" OF
              "Action Message"::Cancel:
                BEGIN
                  CarryOutAction.DeleteOrderLines(ReqLine);
                  OrderCounter := OrderCounter + 1;
                END;
              "Action Message"::"Change Qty.","Action Message"::Reschedule, "Action Message"::"Resched. & Chg. Qty.":
                BEGIN
                  IF (PrevChangedDocOrderNo <> '') AND
                     (("Ref. Order Type" <> PrevChangedDocOrderType) OR ("Ref. Order No." <> PrevChangedDocOrderNo))
                  THEN
                    PrintChangedDocument(PrevChangedDocOrderType,PrevChangedDocOrderNo);
                  CarryOutAction.SetPrintOrder(FALSE);
                  CarryOutAction.PurchOrderChgAndReshedule(ReqLine);
                  PrevChangedDocOrderType := "Ref. Order Type";
                  PrevChangedDocOrderNo := "Ref. Order No.";
                  OrderCounter := OrderCounter + 1;
                END;
              "Action Message"::New,"Action Message"::" ":
                BEGIN
                  IF (PurchOrderHeader."Buy-from Vendor No." <> '') AND
                     CheckInsertFinalizePurchaseOrderHeader(ReqLine,PurchOrderHeader,FALSE)
                  THEN BEGIN
                    FinalizeOrderHeader(PurchOrderHeader,ReqLine);
                    PurchOrderLine.RESET;
                    PurchOrderLine.SETRANGE("Document Type",PurchOrderHeader."Document Type");
                    PurchOrderLine.SETRANGE("Document No.",PurchOrderHeader."No.");
                    PurchOrderLine.SETFILTER("Special Order Sales Line No.",'<> 0');
                    IF PurchOrderLine.FIND('-') THEN
                      REPEAT
                        SalesOrderLine.GET(SalesOrderLine."Document Type"::Order,PurchOrderLine."Special Order Sales No.",
                          PurchOrderLine."Special Order Sales Line No.");
                      UNTIL PurchOrderLine.NEXT = 0;
                  END;
                  MakeRecurringTexts(ReqLine);
                  InsertPurchOrderLine(ReqLine,PurchOrderHeader);
                END;
            END;
        END;

      OnAfterCarryOutReqLineAction(ReqLine,PurchOrderHeader);
    END;

    LOCAL PROCEDURE TryCarryOutReqLineAction@12(VAR ReqLine@1001 : Record 246) : Boolean;
    BEGIN
      WITH ReqLine DO BEGIN
        ReqWkshMakeOrders.Set(PurchOrderHeader,EndOrderDate,PrintPurchOrders);
        ReqWkshMakeOrders.SetTryParam(
          ReqTemplate,
          LineCount,
          NextLineNo,
          PrevPurchCode,
          PrevShipToCode,
          PrevLocationCode,
          OrderCounter,
          OrderLineCounter,
          TempFailedReqLine,
          TempDocumentEntry);
        IF ReqWkshMakeOrders.RUN(ReqLine) THEN BEGIN
          ReqWkshMakeOrders.GetTryParam(
            PurchOrderHeader,
            LineCount,
            NextLineNo,
            PrevPurchCode,
            PrevShipToCode,
            PrevLocationCode,
            OrderCounter,
            OrderLineCounter);

          Window.UPDATE(3,OrderCounter);
          Window.UPDATE(4,LineCount);
          Window.UPDATE(5,OrderLineCounter);
          EXIT(TRUE);
        END;
        EXIT(FALSE)
      END;
    END;

    LOCAL PROCEDURE InsertPurchOrderLine@3(VAR ReqLine2@1000 : Record 246;VAR PurchOrderHeader@1001 : Record 38);
    VAR
      PurchOrderLine2@1003 : Record 39;
      AddOnIntegrMgt@1002 : Codeunit 5403;
      DimensionSetIDArr@1004 : ARRAY [10] OF Integer;
    BEGIN
      WITH ReqLine2 DO BEGIN
        IF ("No." = '') OR ("Vendor No." = '') OR (Quantity = 0) THEN
          EXIT;

        IF CheckInsertFinalizePurchaseOrderHeader(ReqLine2,PurchOrderHeader,TRUE) THEN BEGIN
          InsertHeader(ReqLine2);
          LineCount := 0;
          NextLineNo := 0;
          PrevPurchCode := "Purchasing Code";
          PrevShipToCode := "Ship-to Code";
          PrevLocationCode := "Location Code";
        END;

        LineCount := LineCount + 1;
        IF NOT PlanningResiliency THEN
          Window.UPDATE(4,LineCount);

        TESTFIELD("Currency Code",PurchOrderHeader."Currency Code");

        PurchOrderLine.INIT;
        PurchOrderLine.BlockDynamicTracking(TRUE);
        PurchOrderLine."Document Type" := PurchOrderLine."Document Type"::Order;
        PurchOrderLine."Buy-from Vendor No." := "Vendor No.";
        PurchOrderLine."Document No." := PurchOrderHeader."No.";
        NextLineNo := NextLineNo + 10000;
        PurchOrderLine."Line No." := NextLineNo;
        PurchOrderLine.VALIDATE(Type,Type);
        PurchOrderLine.VALIDATE("No.","No.");
        PurchOrderLine."Variant Code" := "Variant Code";
        PurchOrderLine.VALIDATE("Location Code","Location Code");
        PurchOrderLine.VALIDATE("Unit of Measure Code","Unit of Measure Code");
        PurchOrderLine."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
        PurchOrderLine."Prod. Order No." := "Prod. Order No.";
        PurchOrderLine."Prod. Order Line No." := "Prod. Order Line No.";
        PurchOrderLine.VALIDATE(Quantity,Quantity);
        IF PurchOrderHeader."Prices Including VAT" THEN
          PurchOrderLine.VALIDATE("Direct Unit Cost","Direct Unit Cost" * (1 + PurchOrderLine."VAT %" / 100))
        ELSE
          PurchOrderLine.VALIDATE("Direct Unit Cost","Direct Unit Cost");

        PurchOrderLine.VALIDATE("Line Discount %","Line Discount %");
        PurchOrderLine."Vendor Item No." := "Vendor Item No.";

        PurchOrderLine.Description := Description;
        PurchOrderLine."Description 2" := "Description 2";
        PurchOrderLine."Sales Order No." := "Sales Order No.";
        PurchOrderLine."Sales Order Line No." := "Sales Order Line No.";
        PurchOrderLine."Prod. Order No." := "Prod. Order No.";
        PurchOrderLine."Bin Code" := "Bin Code";
        PurchOrderLine."Item Category Code" := "Item Category Code";
        PurchOrderLine.Nonstock := Nonstock;
        PurchOrderLine.VALIDATE("Planning Flexibility","Planning Flexibility");
        PurchOrderLine.VALIDATE("Purchasing Code","Purchasing Code");
        PurchOrderLine."Product Group Code" := "Product Group Code";
        IF "Due Date" <> 0D THEN BEGIN
          PurchOrderLine.VALIDATE("Expected Receipt Date","Due Date");
          PurchOrderLine."Requested Receipt Date" := PurchOrderLine."Planned Receipt Date";
        END;

        AddOnIntegrMgt.TransferFromReqLineToPurchLine(PurchOrderLine,ReqLine2);

        PurchOrderLine."Drop Shipment" := "Sales Order Line No." <> 0;

        IF PurchasingCode.GET("Purchasing Code") THEN
          IF PurchasingCode."Special Order" THEN BEGIN
            PurchOrderLine."Special Order Sales No." := "Sales Order No.";
            PurchOrderLine."Special Order Sales Line No." := "Sales Order Line No.";
            PurchOrderLine."Special Order" := TRUE;
            PurchOrderLine."Drop Shipment" := FALSE;
            PurchOrderLine."Sales Order No." := '';
            PurchOrderLine."Sales Order Line No." := 0;
            PurchOrderLine."Special Order" := TRUE;
            PurchOrderLine.UpdateUnitCost;
          END;

        ReserveReqLine.TransferReqLineToPurchLine(ReqLine2,PurchOrderLine,"Quantity (Base)",FALSE);
        DimensionSetIDArr[1] := PurchOrderLine."Dimension Set ID";
        DimensionSetIDArr[2] := "Dimension Set ID";
        PurchOrderLine."Dimension Set ID" :=
          DimMgt.GetCombinedDimensionSetID(
            DimensionSetIDArr,PurchOrderLine."Shortcut Dimension 1 Code",PurchOrderLine."Shortcut Dimension 2 Code");

        OnBeforePurchOrderLineInsert(PurchOrderLine,ReqLine2);

        PurchOrderLine.INSERT;

        IF Reserve THEN
          ReserveBindingOrderToPurch(PurchOrderLine,ReqLine2);

        IF PurchOrderLine."Drop Shipment" OR PurchOrderLine."Special Order" THEN BEGIN
          SalesOrderLine.LOCKTABLE;
          SalesOrderHeader.LOCKTABLE;
          SalesOrderHeader.GET(SalesOrderHeader."Document Type"::Order,"Sales Order No.");
          IF NOT PurchOrderLine."Special Order" THEN
            TESTFIELD("Ship-to Code",SalesOrderHeader."Ship-to Code");
          SalesOrderLine.GET(SalesOrderLine."Document Type"::Order,"Sales Order No.","Sales Order Line No.");
          SalesOrderLine.TESTFIELD(Type,SalesOrderLine.Type::Item);
          IF SalesOrderLine."Purch. Order Line No." <> 0 THEN
            ERROR(Text006,SalesOrderLine."No.",SalesOrderLine."Document No.",SalesOrderLine."Purchase Order No.");
          IF SalesOrderLine."Special Order Purchase No." <> '' THEN
            ERROR(Text006,SalesOrderLine."No.",SalesOrderLine."Document No.",SalesOrderLine."Special Order Purchase No.");
          IF NOT PurchOrderLine."Special Order" THEN
            TESTFIELD("Sell-to Customer No.",SalesOrderLine."Sell-to Customer No.");
          TESTFIELD(Type,SalesOrderLine.Type);
          TESTFIELD(
            Quantity,
            ROUND(
              SalesOrderLine."Outstanding Quantity" *
              SalesOrderLine."Qty. per Unit of Measure" /
              "Qty. per Unit of Measure",
              0.00001));
          TESTFIELD("No.",SalesOrderLine."No.");
          TESTFIELD("Location Code",SalesOrderLine."Location Code");
          TESTFIELD("Variant Code",SalesOrderLine."Variant Code");
          TESTFIELD("Bin Code",SalesOrderLine."Bin Code");
          TESTFIELD("Prod. Order No.",'');
          TESTFIELD("Qty. per Unit of Measure","Qty. per Unit of Measure");
          SalesOrderLine.VALIDATE("Unit Cost (LCY)");

          IF SalesOrderLine."Special Order" THEN BEGIN
            SalesOrderLine."Special Order Purchase No." := PurchOrderLine."Document No.";
            SalesOrderLine."Special Order Purch. Line No." := PurchOrderLine."Line No.";
          END ELSE BEGIN
            SalesOrderLine."Purchase Order No." := PurchOrderLine."Document No.";
            SalesOrderLine."Purch. Order Line No." := PurchOrderLine."Line No.";
          END;
          SalesOrderLine.MODIFY;
        END;

        IF TransferExtendedText.PurchCheckIfAnyExtText(PurchOrderLine,FALSE) THEN BEGIN
          TransferExtendedText.InsertPurchExtText(PurchOrderLine);
          PurchOrderLine2.SETRANGE("Document Type",PurchOrderHeader."Document Type");
          PurchOrderLine2.SETRANGE("Document No.",PurchOrderHeader."No.");
          IF PurchOrderLine2.FINDLAST THEN
            NextLineNo := PurchOrderLine2."Line No.";
        END;
      END;
    END;

    LOCAL PROCEDURE InsertHeader@4(VAR ReqLine2@1000 : Record 246);
    VAR
      SalesHeader@1002 : Record 36;
      Vendor@1003 : Record 23;
      SpecialOrder@1001 : Boolean;
    BEGIN
      WITH ReqLine2 DO BEGIN
        OrderCounter := OrderCounter + 1;
        IF NOT PlanningResiliency THEN
          Window.UPDATE(3,OrderCounter);

        PurchSetup.GET;
        PurchSetup.TESTFIELD("Order Nos.");
        CLEAR(PurchOrderHeader);
        PurchOrderHeader.INIT;
        PurchOrderHeader."Document Type" := PurchOrderHeader."Document Type"::Order;
        PurchOrderHeader."No." := '';
        PurchOrderHeader."Posting Date" := PostingDateReq;
        PurchOrderHeader.INSERT(TRUE);
        PurchOrderHeader."Your Reference" := ReferenceReq;
        PurchOrderHeader."Order Date" := OrderDateReq;
        PurchOrderHeader."Expected Receipt Date" := ReceiveDateReq;
        PurchOrderHeader.VALIDATE("Buy-from Vendor No.","Vendor No.");
        IF "Order Address Code" <> '' THEN
          PurchOrderHeader.VALIDATE("Order Address Code","Order Address Code");

        IF "Sell-to Customer No." <> '' THEN
          PurchOrderHeader.VALIDATE("Sell-to Customer No.","Sell-to Customer No.");

        PurchOrderHeader.VALIDATE("Currency Code","Currency Code");

        IF PurchasingCode.GET("Purchasing Code") THEN
          IF PurchasingCode."Special Order" THEN
            SpecialOrder := TRUE;

        IF NOT SpecialOrder THEN BEGIN
          IF "Ship-to Code" <> '' THEN
            PurchOrderHeader.VALIDATE("Ship-to Code","Ship-to Code")
          ELSE
            PurchOrderHeader.VALIDATE("Location Code","Location Code");
        END ELSE BEGIN
          PurchOrderHeader.VALIDATE("Location Code","Location Code");
          PurchOrderHeader.SetShipToForSpecOrder;
          IF Vendor.GET(PurchOrderHeader."Buy-from Vendor No.") THEN
            PurchOrderHeader.VALIDATE("Shipment Method Code",Vendor."Shipment Method Code");
        END;
        IF NOT SpecialOrder THEN
          IF SalesHeader.GET(SalesHeader."Document Type"::Order,"Sales Order No.") THEN BEGIN
            PurchOrderHeader."Ship-to Name" := SalesHeader."Ship-to Name";
            PurchOrderHeader."Ship-to Name 2" := SalesHeader."Ship-to Name 2";
            PurchOrderHeader."Ship-to Address" := SalesHeader."Ship-to Address";
            PurchOrderHeader."Ship-to Address 2" := SalesHeader."Ship-to Address 2";
            PurchOrderHeader."Ship-to Post Code" := SalesHeader."Ship-to Post Code";
            PurchOrderHeader."Ship-to City" := SalesHeader."Ship-to City";
            PurchOrderHeader."Ship-to Contact" := SalesHeader."Ship-to Contact";
            PurchOrderHeader."Ship-to County" := SalesHeader."Ship-to County";
            PurchOrderHeader."Ship-to Country/Region Code" := SalesHeader."Ship-to Country/Region Code";
          END;
        IF SpecialOrder THEN
          IF Vendor.GET(PurchOrderHeader."Buy-from Vendor No.") THEN
            PurchOrderHeader."Shipment Method Code" := Vendor."Shipment Method Code";
        OnAfterInsertPurchOrderHeader(ReqLine2,PurchOrderHeader);
        PurchOrderHeader.MODIFY;
        PurchOrderHeader.MARK(TRUE);
        TempDocumentEntry.INIT;
        TempDocumentEntry."Table ID" := DATABASE::"Purchase Header";
        TempDocumentEntry."Document Type" := PurchOrderHeader."Document Type"::Order;
        TempDocumentEntry."Document No." := PurchOrderHeader."No.";
        TempDocumentEntry."Entry No." := TempDocumentEntry.COUNT + 1;
        TempDocumentEntry.INSERT;
      END;
    END;

    LOCAL PROCEDURE FinalizeOrderHeader@5(PurchOrderHeader@1000 : Record 38;VAR ReqLine@1002 : Record 246);
    VAR
      ReqLine2@1003 : Record 246;
      CarryOutAction@1001 : Codeunit 99000813;
    BEGIN
      IF ReqTemplate.Recurring THEN BEGIN
        // Recurring journal
        ReqLine2.COPY(ReqLine);
        ReqLine2.SETRANGE("Vendor No.",PurchOrderHeader."Buy-from Vendor No.");
        ReqLine2.SETRANGE("Sell-to Customer No.",PurchOrderHeader."Sell-to Customer No.");
        ReqLine2.SETRANGE("Ship-to Code",PurchOrderHeader."Ship-to Code");
        ReqLine2.SETRANGE("Order Address Code",PurchOrderHeader."Order Address Code");
        ReqLine2.SETRANGE("Currency Code",PurchOrderHeader."Currency Code");
        ReqLine2.FIND('-');
        REPEAT
          OrderLineCounter := OrderLineCounter + 1;
          IF NOT PlanningResiliency THEN
            Window.UPDATE(5,OrderLineCounter);
          IF ReqLine2."Order Date" <> 0D THEN BEGIN
            ReqLine2.VALIDATE(
              "Order Date",
              CALCDATE(ReqLine2."Recurring Frequency",ReqLine2."Order Date"));
            ReqLine2.VALIDATE("Currency Code",PurchOrderHeader."Currency Code");
          END;
          IF (ReqLine2."Recurring Method" = ReqLine2."Recurring Method"::Variable) AND
             (ReqLine2."No." <> '')
          THEN BEGIN
            ReqLine2.Quantity := 0;
            ReqLine2."Line Discount %" := 0;
          END;
          ReqLine2.MODIFY;
        UNTIL ReqLine2.NEXT = 0;
      END ELSE BEGIN
        // Not a recurring journal
        OrderLineCounter := OrderLineCounter + LineCount;
        IF NOT PlanningResiliency THEN
          Window.UPDATE(5,OrderLineCounter);
        ReqLine2.COPY(ReqLine);
        ReqLine2.SETRANGE("Vendor No.",PurchOrderHeader."Buy-from Vendor No.");
        ReqLine2.SETRANGE("Sell-to Customer No.",PurchOrderHeader."Sell-to Customer No.");
        ReqLine2.SETRANGE("Ship-to Code",PurchOrderHeader."Ship-to Code");
        ReqLine2.SETRANGE("Order Address Code",PurchOrderHeader."Order Address Code");
        ReqLine2.SETRANGE("Currency Code",PurchOrderHeader."Currency Code");
        ReqLine2.SETRANGE("Location Code",PrevLocationCode);
        ReqLine2.SETRANGE("Purchasing Code",PrevPurchCode);
        ReqLine2.SETFILTER("Line No.",'..%1',ReqLine."Line No.");
        IF ReqLine2.FIND('-') THEN BEGIN
          ReqLine2.BlockDynamicTracking(TRUE);
          ReservEntry.SETCURRENTKEY(
            "Source ID","Source Ref. No.","Source Type","Source Subtype",
            "Source Batch Name","Source Prod. Order Line");
          REPEAT
            TempFailedReqLine := ReqLine2;
            IF NOT TempFailedReqLine.FIND THEN BEGIN
              ReserveReqLine.FilterReservFor(ReservEntry,ReqLine2);
              ReservEntry.DELETEALL(TRUE);
              ReqLine2.DELETE(TRUE);
            END;
          UNTIL ReqLine2.NEXT = 0;
        END;
      END;
      COMMIT;

      CarryOutAction.SetPrintOrder(PrintPurchOrders);
      CarryOutAction.PrintPurchaseOrder(PurchOrderHeader);
    END;

    LOCAL PROCEDURE CheckRecurringLine@10(VAR ReqLine2@1000 : Record 246);
    VAR
      DummyDateFormula@1001 : DateFormula;
    BEGIN
      WITH ReqLine2 DO
        IF "No." <> '' THEN
          IF ReqTemplate.Recurring THEN BEGIN
            TESTFIELD("Recurring Method");
            TESTFIELD("Recurring Frequency");
            IF "Recurring Method" = "Recurring Method"::Variable THEN
              TESTFIELD(Quantity);
          END ELSE BEGIN
            TESTFIELD("Recurring Method",0);
            TESTFIELD("Recurring Frequency",DummyDateFormula);
          END;
    END;

    LOCAL PROCEDURE MakeRecurringTexts@6(VAR ReqLine2@1000 : Record 246);
    BEGIN
      WITH ReqLine2 DO
        IF ("No." <> '') AND ("Recurring Method" <> 0) AND ("Order Date" <> 0D) THEN BEGIN
          Day := DATE2DMY("Order Date",1);
          Week := DATE2DWY("Order Date",2);
          Month := DATE2DMY("Order Date",2);
          MonthText := FORMAT("Order Date",0,Text007);
          AccountingPeriod.SETRANGE("Starting Date",0D,"Order Date");
          IF NOT AccountingPeriod.FINDLAST THEN
            AccountingPeriod.Name := '';
          Description :=
            DELCHR(
              PADSTR(
                STRSUBSTNO(Description,Day,Week,Month,MonthText,AccountingPeriod.Name),
                MAXSTRLEN(Description)),
              '>');
          MODIFY;
        END;
    END;

    LOCAL PROCEDURE ReserveBindingOrderToPurch@7(VAR PurchLine@1005 : Record 39;VAR ReqLine@1000 : Record 246);
    VAR
      ProdOrderComp@1004 : Record 5407;
      SalesLine@1007 : Record 37;
      ServLine@1009 : Record 5902;
      JobPlanningLine@1010 : Record 1003;
      AsmLine@1013 : Record 901;
      ProdOrderCompReserve@1002 : Codeunit 99000838;
      SalesLineReserve@1008 : Codeunit 99000832;
      ServLineReserve@1011 : Codeunit 99000842;
      JobPlanningLineReserve@1012 : Codeunit 1032;
      AsmLineReserve@1014 : Codeunit 926;
      ReservQty@1015 : Decimal;
      ReservQtyBase@1001 : Decimal;
    BEGIN
      PurchLine.CALCFIELDS("Reserved Quantity","Reserved Qty. (Base)");
      IF (PurchLine."Quantity (Base)" - PurchLine."Reserved Qty. (Base)") > ReqLine."Demand Quantity (Base)" THEN BEGIN
        ReservQty := ReqLine."Demand Quantity";
        ReservQtyBase := ReqLine."Demand Quantity (Base)";
      END ELSE BEGIN
        ReservQty := PurchLine.Quantity - PurchLine."Reserved Quantity";
        ReservQtyBase := PurchLine."Quantity (Base)" - PurchLine."Reserved Qty. (Base)";
      END;

      CASE ReqLine."Demand Type" OF
        DATABASE::"Prod. Order Component":
          BEGIN
            ProdOrderComp.GET(
              ReqLine."Demand Subtype",ReqLine."Demand Order No.",ReqLine."Demand Line No.",ReqLine."Demand Ref. No.");
            ProdOrderCompReserve.BindToPurchase(ProdOrderComp,PurchLine,ReservQty,ReservQtyBase);
          END;
        DATABASE::"Sales Line":
          BEGIN
            SalesLine.GET(ReqLine."Demand Subtype",ReqLine."Demand Order No.",ReqLine."Demand Line No.");
            SalesLineReserve.BindToPurchase(SalesLine,PurchLine,ReservQty,ReservQtyBase);
            IF SalesLine.Reserve = SalesLine.Reserve::Never THEN BEGIN
              SalesLine.Reserve := SalesLine.Reserve::Optional;
              SalesLine.MODIFY;
            END;
          END;
        DATABASE::"Service Line":
          BEGIN
            ServLine.GET(ReqLine."Demand Subtype",ReqLine."Demand Order No.",ReqLine."Demand Line No.");
            ServLineReserve.BindToPurchase(ServLine,PurchLine,ReservQty,ReservQtyBase);
            IF ServLine.Reserve = ServLine.Reserve::Never THEN BEGIN
              ServLine.Reserve := ServLine.Reserve::Optional;
              ServLine.MODIFY;
            END;
          END;
        DATABASE::"Job Planning Line":
          BEGIN
            JobPlanningLine.SETRANGE("Job Contract Entry No.",ReqLine."Demand Line No.");
            JobPlanningLine.FINDFIRST;
            JobPlanningLineReserve.BindToPurchase(JobPlanningLine,PurchLine,ReservQty,ReservQtyBase);
            IF JobPlanningLine.Reserve = JobPlanningLine.Reserve::Never THEN BEGIN
              JobPlanningLine.Reserve := JobPlanningLine.Reserve::Optional;
              JobPlanningLine.MODIFY;
            END;
          END;
        DATABASE::"Assembly Line":
          BEGIN
            AsmLine.GET(ReqLine."Demand Subtype",ReqLine."Demand Order No.",ReqLine."Demand Line No.");
            AsmLineReserve.BindToPurchase(AsmLine,PurchLine,ReservQty,ReservQtyBase);
            IF AsmLine.Reserve = AsmLine.Reserve::Never THEN BEGIN
              AsmLine.Reserve := AsmLine.Reserve::Optional;
              AsmLine.MODIFY;
            END;
          END;
      END;
      PurchLine.MODIFY;

      OnAfterReserveBindingOrderToPurch(PurchLine,ReqLine,ReservQty,ReservQtyBase);
    END;

    [External]
    PROCEDURE SetTryParam@11(TryReqTemplate@1006 : Record 244;TryLineCount@1005 : Integer;TryNextLineNo@1004 : Integer;TryPrevPurchCode@1003 : Code[10];TryPrevShipToCode@1000 : Code[10];TryPrevLocationCode@1009 : Code[10];TryOrderCounter@1007 : Integer;TryOrderLineCounter@1008 : Integer;VAR TryFailedReqLine@1001 : Record 246;VAR TempDocumentEntryNew@1002 : TEMPORARY Record 265);
    BEGIN
      SetPlanningResiliency;
      ReqTemplate := TryReqTemplate;
      LineCount := TryLineCount;
      NextLineNo := TryNextLineNo;
      PrevPurchCode := TryPrevPurchCode;
      PrevShipToCode := TryPrevShipToCode;
      PrevLocationCode := TryPrevLocationCode;
      OrderCounter := TryOrderCounter;
      OrderLineCounter := TryOrderLineCounter;
      TempDocumentEntry.COPY(TempDocumentEntryNew,TRUE);
      IF TryFailedReqLine.FIND('-') THEN
        REPEAT
          TempFailedReqLine := TryFailedReqLine;
          IF TempFailedReqLine.INSERT THEN;
        UNTIL TryFailedReqLine.NEXT = 0;
    END;

    [External]
    PROCEDURE GetTryParam@9(VAR TryPurchOrderHeader@1001 : Record 38;VAR TryLineCount@1005 : Integer;VAR TryNextLineNo@1004 : Integer;VAR TryPrevPurchCode@1003 : Code[10];VAR TryPrevShipToCode@1000 : Code[10];VAR TryPrevLocationCode@1002 : Code[10];VAR TryOrderCounter@1007 : Integer;VAR TryOrderLineCounter@1008 : Integer);
    BEGIN
      TryPurchOrderHeader.COPY(PurchOrderHeader);
      TryLineCount := LineCount;
      TryNextLineNo := NextLineNo;
      TryPrevPurchCode := PrevPurchCode;
      TryPrevShipToCode := PrevShipToCode;
      TryPrevLocationCode := PrevLocationCode;
      TryOrderCounter := OrderCounter;
      TryOrderLineCounter := OrderLineCounter;
    END;

    [External]
    PROCEDURE SetFailedReqLine@13(VAR TryFailedReqLine@1000 : Record 246);
    BEGIN
      TempFailedReqLine := TryFailedReqLine;
      TempFailedReqLine.INSERT;
    END;

    [External]
    PROCEDURE SetPlanningResiliency@17();
    BEGIN
      PlanningResiliency := TRUE;
    END;

    [External]
    PROCEDURE GetFailedCounter@19() : Integer;
    BEGIN
      EXIT(CounterFailed);
    END;

    LOCAL PROCEDURE PrintTransOrder@15(TransferHeader@1001 : Record 5740);
    VAR
      CarryOutAction@1000 : Codeunit 99000813;
    BEGIN
      IF TransferHeader."No." <> '' THEN BEGIN
        CarryOutAction.SetPrintOrder(PrintPurchOrders);
        CarryOutAction.PrintTransferOrder(TransferHeader);
      END;
    END;

    LOCAL PROCEDURE PrintChangedDocument@25(OrderType@1000 : Option;VAR OrderNo@1001 : Code[20]);
    VAR
      DummyReqLine@1003 : Record 246;
      TransferHeader@1004 : Record 5740;
      PurchaseHeader@1005 : Record 38;
      CarryOutAction@1002 : Codeunit 99000813;
    BEGIN
      CarryOutAction.SetPrintOrder(PrintPurchOrders);
      CASE OrderType OF
        DummyReqLine."Ref. Order Type"::Transfer:
          BEGIN
            TransferHeader.GET(OrderNo);
            PrintTransOrder(TransferHeader);
          END;
        DummyReqLine."Ref. Order Type"::Purchase:
          BEGIN
            PurchaseHeader.GET(PurchaseHeader."Document Type"::Order,OrderNo);
            PrintPurchOrder(PurchaseHeader);
          END;
      END;
      OrderNo := '';
    END;

    LOCAL PROCEDURE PrintPurchOrder@22(PurchHeader@1001 : Record 38);
    VAR
      CarryOutAction@1000 : Codeunit 99000813;
    BEGIN
      IF PurchHeader."No." <> '' THEN BEGIN
        CarryOutAction.SetPrintOrder(PrintPurchOrders);
        CarryOutAction.PrintPurchaseOrder(PurchHeader);
      END;
    END;

    LOCAL PROCEDURE SetPurchOrderHeader@16();
    BEGIN
      PurchOrderHeader."Order Date" := OrderDateReq;
      PurchOrderHeader."Posting Date" := PostingDateReq;
      PurchOrderHeader."Expected Receipt Date" := ReceiveDateReq;
      PurchOrderHeader."Your Reference" := ReferenceReq;
    END;

    LOCAL PROCEDURE CheckAddressDetails@100(SalesOrderNo@1002 : Code[20];SalesLineNo@1003 : Integer;UpdateAddressDetails@1001 : Boolean) Result : Boolean;
    VAR
      SalesLine@1000 : Record 37;
      Purchasing@1004 : Record 5721;
    BEGIN
      IF SalesLine.GET(SalesLine."Document Type"::Order,SalesOrderNo,SalesLineNo) THEN
        IF Purchasing.GET(SalesLine."Purchasing Code") THEN
          CASE TRUE OF
            Purchasing."Drop Shipment":
              Result :=
                NOT CheckDropShptAddressDetails(SalesOrderNo,UpdateAddressDetails);
            Purchasing."Special Order":
              Result :=
                NOT CheckSpecOrderAddressDetails(SalesLine."Location Code");
          END;
    END;

    LOCAL PROCEDURE CheckLocation@20(RequisitionLine@1000 : Record 246);
    VAR
      InventorySetup@1001 : Record 313;
    BEGIN
      InventorySetup.GET;
      IF InventorySetup."Location Mandatory" THEN
        RequisitionLine.TESTFIELD("Location Code");
    END;

    LOCAL PROCEDURE CheckInsertFinalizePurchaseOrderHeader@21(RequisitionLine@1000 : Record 246;VAR PurchOrderHeader@1002 : Record 38;UpdateAddressDetails@1001 : Boolean) Result : Boolean;
    BEGIN
      WITH RequisitionLine DO
        Result :=
          (PurchOrderHeader."Buy-from Vendor No." <> "Vendor No.") OR
          (PurchOrderHeader."Sell-to Customer No." <> "Sell-to Customer No.") OR
          (PrevShipToCode <> "Ship-to Code") OR
          (PurchOrderHeader."Order Address Code" <> "Order Address Code") OR
          (PurchOrderHeader."Currency Code" <> "Currency Code") OR
          (PrevPurchCode <> "Purchasing Code") OR
          (PrevLocationCode <> "Location Code") OR
          CheckAddressDetails("Sales Order No.","Sales Order Line No.",UpdateAddressDetails);
    END;

    LOCAL PROCEDURE CheckDropShptAddressDetails@79(SalesNo@1002 : Code[20];UpdateAddressDetails@1003 : Boolean) : Boolean;
    VAR
      SalesHeader@1000 : Record 36;
      DropShptNameAddressDetails@1001 : Text;
    BEGIN
      SalesHeader.GET(SalesHeader."Document Type"::Order,SalesNo);
      DropShptNameAddressDetails :=
        SalesHeader."Ship-to Name" + SalesHeader."Ship-to Name 2" +
        SalesHeader."Ship-to Address" + SalesHeader."Ship-to Address 2" +
        SalesHeader."Ship-to Post Code" + SalesHeader."Ship-to City" +
        SalesHeader."Ship-to Contact";
      IF NameAddressDetails = '' THEN
        NameAddressDetails := DropShptNameAddressDetails;
      IF NameAddressDetails = DropShptNameAddressDetails THEN
        EXIT(TRUE);

      IF UpdateAddressDetails THEN
        NameAddressDetails := DropShptNameAddressDetails;
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE CheckSpecOrderAddressDetails@82(LocationCode@1000 : Code[10]) : Boolean;
    VAR
      Location@1001 : Record 14;
      CompanyInfo@1002 : Record 79;
      SpecOrderNameAddressDetails@1003 : Text;
    BEGIN
      IF Location.GET(LocationCode) THEN
        SpecOrderNameAddressDetails :=
          Location.Name + Location."Name 2" +
          Location.Address + Location."Address 2" +
          Location."Post Code" + Location.City +
          Location.Contact
      ELSE BEGIN
        CompanyInfo.GET;
        SpecOrderNameAddressDetails :=
          CompanyInfo."Ship-to Name" + CompanyInfo."Ship-to Name 2" +
          CompanyInfo."Ship-to Address" + CompanyInfo."Ship-to Address 2" +
          CompanyInfo."Ship-to Post Code" + CompanyInfo."Ship-to City" +
          CompanyInfo."Ship-to Contact";
      END;
      IF NameAddressDetails = '' THEN
        NameAddressDetails := SpecOrderNameAddressDetails;
      EXIT(NameAddressDetails = SpecOrderNameAddressDetails);
    END;

    LOCAL PROCEDURE InitShipReceiveDetails@23();
    BEGIN
      PrevShipToCode := '';
      PrevPurchCode := '';
      PrevLocationCode := '';
      NameAddressDetails := '';
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforePurchOrderLineInsert@26(VAR PurchOrderLine@1000 : Record 39;VAR ReqLine@1001 : Record 246);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCarryOutReqLineAction@27(VAR RequisitionLine@1000 : Record 246;VAR PurchaseHeader@1001 : Record 38);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterReserveBindingOrderToPurch@28(VAR PurchaseLine@1000 : Record 39;VAR ReqLine@1001 : Record 246;ReservQty@1002 : Decimal;ReservQtyBase@1003 : Decimal);
    BEGIN
    END;

    [Integration(DEFAULT,TRUE)]
    LOCAL PROCEDURE OnAfterSet@29(NewPurchOrderHeader@1000 : Record 38);
    BEGIN
    END;

    [Integration(DEFAULT,TRUE)]
    LOCAL PROCEDURE OnAfterCheckReqWkshLine@30(VAR RequisitionLine@1000 : Record 246);
    BEGIN
    END;

    [Integration(DEFAULT,TRUE)]
    LOCAL PROCEDURE OnAfterInsertPurchOrderHeader@31(VAR RequisitionLine@1000 : Record 246;VAR PurchaseOrderHeader@1001 : Record 38);
    BEGIN
    END;

    BEGIN
    END.
  }
}

