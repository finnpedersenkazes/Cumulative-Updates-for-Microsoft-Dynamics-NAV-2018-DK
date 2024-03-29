OBJECT Codeunit 5750 Whse.-Create Source Document
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {

    [External]
    PROCEDURE FromSalesLine2ShptLine@9(WhseShptHeader@1000 : Record 7320;SalesLine@1001 : Record 37) : Boolean;
    VAR
      AsmHeader@1004 : Record 900;
      TotalOutstandingWhseShptQty@1005 : Decimal;
      TotalOutstandingWhseShptQtyBase@1003 : Decimal;
      ATOWhseShptLineQty@1006 : Decimal;
      ATOWhseShptLineQtyBase@1002 : Decimal;
    BEGIN
      SalesLine.CALCFIELDS("Whse. Outstanding Qty.","ATO Whse. Outstanding Qty.",
        "Whse. Outstanding Qty. (Base)","ATO Whse. Outstd. Qty. (Base)");
      TotalOutstandingWhseShptQty := ABS(SalesLine."Outstanding Quantity") - SalesLine."Whse. Outstanding Qty.";
      TotalOutstandingWhseShptQtyBase := ABS(SalesLine."Outstanding Qty. (Base)") - SalesLine."Whse. Outstanding Qty. (Base)";
      IF SalesLine.AsmToOrderExists(AsmHeader) THEN BEGIN
        ATOWhseShptLineQty := AsmHeader."Remaining Quantity" - SalesLine."ATO Whse. Outstanding Qty.";
        ATOWhseShptLineQtyBase := AsmHeader."Remaining Quantity (Base)" - SalesLine."ATO Whse. Outstd. Qty. (Base)";
        IF ATOWhseShptLineQtyBase > 0 THEN BEGIN
          IF NOT CreateShptLineFromSalesLine(WhseShptHeader,SalesLine,ATOWhseShptLineQty,ATOWhseShptLineQtyBase,TRUE) THEN
            EXIT(FALSE);
          TotalOutstandingWhseShptQty -= ATOWhseShptLineQty;
          TotalOutstandingWhseShptQtyBase -= ATOWhseShptLineQtyBase;
        END;
      END;
      IF TotalOutstandingWhseShptQtyBase > 0 THEN
        EXIT(CreateShptLineFromSalesLine(WhseShptHeader,SalesLine,TotalOutstandingWhseShptQty,TotalOutstandingWhseShptQtyBase,FALSE));
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE CreateShptLineFromSalesLine@11(WhseShptHeader@1000 : Record 7320;SalesLine@1001 : Record 37;WhseShptLineQty@1004 : Decimal;WhseShptLineQtyBase@1006 : Decimal;AssembleToOrder@1005 : Boolean) : Boolean;
    VAR
      WhseShptLine@1002 : Record 7321;
      SalesHeader@1003 : Record 36;
    BEGIN
      SalesHeader.GET(SalesLine."Document Type",SalesLine."Document No.");

      WITH WhseShptLine DO BEGIN
        InitNewLine(WhseShptHeader."No.");
        SetSource(DATABASE::"Sales Line",SalesLine."Document Type",SalesLine."Document No.",SalesLine."Line No.");
        SalesLine.TESTFIELD("Unit of Measure Code");
        SetItemData(
          SalesLine."No.",SalesLine.Description,SalesLine."Description 2",SalesLine."Location Code",
          SalesLine."Variant Code",SalesLine."Unit of Measure Code",SalesLine."Qty. per Unit of Measure");
        SetQtysOnShptLine(WhseShptLine,WhseShptLineQty,WhseShptLineQtyBase);
        "Assemble to Order" := AssembleToOrder;
        IF SalesLine."Document Type" = SalesLine."Document Type"::Order THEN
          "Due Date" := SalesLine."Planned Shipment Date";
        IF SalesLine."Document Type" = SalesLine."Document Type"::"Return Order" THEN
          "Due Date" := WORKDATE;
        IF WhseShptHeader."Shipment Date" = 0D THEN
          "Shipment Date" := SalesLine."Shipment Date"
        ELSE
          "Shipment Date" := WhseShptHeader."Shipment Date";
        "Destination Type" := "Destination Type"::Customer;
        "Destination No." := SalesLine."Sell-to Customer No.";
        "Shipping Advice" := SalesHeader."Shipping Advice";
        IF "Location Code" = WhseShptHeader."Location Code" THEN
          "Bin Code" := WhseShptHeader."Bin Code";
        IF "Bin Code" = '' THEN
          "Bin Code" := SalesLine."Bin Code";
        UpdateShptLine(WhseShptLine,WhseShptHeader);
        CreateShptLine(WhseShptLine);
        OnAfterCreateShptLineFromSalesLine(WhseShptLine,WhseShptHeader,SalesLine);
        EXIT(NOT HasErrorOccured);
      END;
    END;

    [External]
    PROCEDURE SalesLine2ReceiptLine@2(WhseReceiptHeader@1000 : Record 7316;SalesLine@1001 : Record 37) : Boolean;
    VAR
      WhseReceiptLine@1002 : Record 7317;
    BEGIN
      WITH WhseReceiptLine DO BEGIN
        InitNewLine(WhseReceiptHeader."No.");
        SetSource(DATABASE::"Sales Line",SalesLine."Document Type",SalesLine."Document No.",SalesLine."Line No.");
        SalesLine.TESTFIELD("Unit of Measure Code");
        SetItemData(
          SalesLine."No.",SalesLine.Description,SalesLine."Description 2",SalesLine."Location Code",
          SalesLine."Variant Code",SalesLine."Unit of Measure Code",SalesLine."Qty. per Unit of Measure");
        CASE SalesLine."Document Type" OF
          SalesLine."Document Type"::Order:
            BEGIN
              VALIDATE("Qty. Received",ABS(SalesLine."Quantity Shipped"));
              "Due Date" := SalesLine."Planned Shipment Date";
            END;
          SalesLine."Document Type"::"Return Order":
            BEGIN
              VALIDATE("Qty. Received",ABS(SalesLine."Return Qty. Received"));
              "Due Date" := WORKDATE;
            END;
        END;
        SetQtysOnRcptLine(WhseReceiptLine,ABS(SalesLine.Quantity),ABS(SalesLine."Quantity (Base)"));
        "Starting Date" := SalesLine."Shipment Date";
        IF "Location Code" = WhseReceiptHeader."Location Code" THEN
          "Bin Code" := WhseReceiptHeader."Bin Code";
        IF "Bin Code" = '' THEN
          "Bin Code" := SalesLine."Bin Code";
        UpdateReceiptLine(WhseReceiptLine,WhseReceiptHeader);
        CreateReceiptLine(WhseReceiptLine);
        OnAfterCreateRcptLineFromSalesLine(WhseReceiptLine,WhseReceiptHeader,SalesLine);
        EXIT(NOT HasErrorOccured);
      END;
    END;

    [External]
    PROCEDURE FromServiceLine2ShptLine@6(WhseShptHeader@1000 : Record 7320;ServiceLine@1001 : Record 5902) : Boolean;
    VAR
      WhseShptLine@1002 : Record 7321;
      ServiceHeader@1003 : Record 5900;
    BEGIN
      ServiceHeader.GET(ServiceLine."Document Type",ServiceLine."Document No.");

      WITH WhseShptLine DO BEGIN
        InitNewLine(WhseShptHeader."No.");
        SetSource(DATABASE::"Service Line",ServiceLine."Document Type",ServiceLine."Document No.",ServiceLine."Line No.");
        ServiceLine.TESTFIELD("Unit of Measure Code");
        SetItemData(
          ServiceLine."No.",ServiceLine.Description,ServiceLine."Description 2",ServiceLine."Location Code",
          ServiceLine."Variant Code",ServiceLine."Unit of Measure Code",ServiceLine."Qty. per Unit of Measure");
        SetQtysOnShptLine(WhseShptLine,ABS(ServiceLine."Outstanding Quantity"),ABS(ServiceLine."Outstanding Qty. (Base)"));
        IF ServiceLine."Document Type" = ServiceLine."Document Type"::Order THEN
          "Due Date" := ServiceLine.GetDueDate;
        IF WhseShptHeader."Shipment Date" = 0D THEN
          "Shipment Date" := ServiceLine.GetShipmentDate
        ELSE
          "Shipment Date" := WhseShptHeader."Shipment Date";
        "Destination Type" := "Destination Type"::Customer;
        "Destination No." := ServiceLine."Bill-to Customer No.";
        "Shipping Advice" := ServiceHeader."Shipping Advice";
        IF "Location Code" = WhseShptHeader."Location Code" THEN
          "Bin Code" := WhseShptHeader."Bin Code";
        IF "Bin Code" = '' THEN
          "Bin Code" := ServiceLine."Bin Code";
        UpdateShptLine(WhseShptLine,WhseShptHeader);
        CreateShptLine(WhseShptLine);
        OnAfterCreateShptLineFromServiceLine(WhseShptLine,WhseShptHeader,ServiceLine);
        EXIT(NOT HasErrorOccured);
      END;
    END;

    [External]
    PROCEDURE FromPurchLine2ShptLine@12(WhseShptHeader@1000 : Record 7320;PurchLine@1001 : Record 39) : Boolean;
    VAR
      WhseShptLine@1002 : Record 7321;
    BEGIN
      WITH WhseShptLine DO BEGIN
        InitNewLine(WhseShptHeader."No.");
        SetSource(DATABASE::"Purchase Line",PurchLine."Document Type",PurchLine."Document No.",PurchLine."Line No.");
        PurchLine.TESTFIELD("Unit of Measure Code");
        SetItemData(
          PurchLine."No.",PurchLine.Description,PurchLine."Description 2",PurchLine."Location Code",
          PurchLine."Variant Code",PurchLine."Unit of Measure Code",PurchLine."Qty. per Unit of Measure");
        SetQtysOnShptLine(WhseShptLine,ABS(PurchLine."Outstanding Quantity"),ABS(PurchLine."Outstanding Qty. (Base)"));
        IF PurchLine."Document Type" = PurchLine."Document Type"::Order THEN
          "Due Date" := PurchLine."Expected Receipt Date";
        IF PurchLine."Document Type" = PurchLine."Document Type"::"Return Order" THEN
          "Due Date" := WORKDATE;
        IF WhseShptHeader."Shipment Date" = 0D THEN
          "Shipment Date" := PurchLine."Planned Receipt Date"
        ELSE
          "Shipment Date" := WhseShptHeader."Shipment Date";
        "Destination Type" := "Destination Type"::Vendor;
        "Destination No." := PurchLine."Buy-from Vendor No.";
        IF "Location Code" = WhseShptHeader."Location Code" THEN
          "Bin Code" := WhseShptHeader."Bin Code";
        IF "Bin Code" = '' THEN
          "Bin Code" := PurchLine."Bin Code";
        UpdateShptLine(WhseShptLine,WhseShptHeader);
        CreateShptLine(WhseShptLine);
        OnAfterCreateShptLineFromPurchLine(WhseShptLine,WhseShptHeader,PurchLine);
        EXIT(NOT HasErrorOccured);
      END;
    END;

    [External]
    PROCEDURE PurchLine2ReceiptLine@4(WhseReceiptHeader@1000 : Record 7316;PurchLine@1001 : Record 39) : Boolean;
    VAR
      WhseReceiptLine@1002 : Record 7317;
    BEGIN
      WITH WhseReceiptLine DO BEGIN
        InitNewLine(WhseReceiptHeader."No.");
        SetSource(DATABASE::"Purchase Line",PurchLine."Document Type",PurchLine."Document No.",PurchLine."Line No.");
        PurchLine.TESTFIELD("Unit of Measure Code");
        SetItemData(
          PurchLine."No.",PurchLine.Description,PurchLine."Description 2",PurchLine."Location Code",
          PurchLine."Variant Code",PurchLine."Unit of Measure Code",PurchLine."Qty. per Unit of Measure");
        CASE PurchLine."Document Type" OF
          PurchLine."Document Type"::Order:
            BEGIN
              VALIDATE("Qty. Received",ABS(PurchLine."Quantity Received"));
              "Due Date" := PurchLine."Expected Receipt Date";
            END;
          PurchLine."Document Type"::"Return Order":
            BEGIN
              VALIDATE("Qty. Received",ABS(PurchLine."Return Qty. Shipped"));
              "Due Date" := WORKDATE;
            END;
        END;
        SetQtysOnRcptLine(WhseReceiptLine,ABS(PurchLine.Quantity),ABS(PurchLine."Quantity (Base)"));
        "Starting Date" := PurchLine."Planned Receipt Date";
        IF "Location Code" = WhseReceiptHeader."Location Code" THEN
          "Bin Code" := WhseReceiptHeader."Bin Code";
        IF "Bin Code" = '' THEN
          "Bin Code" := PurchLine."Bin Code";
        UpdateReceiptLine(WhseReceiptLine,WhseReceiptHeader);
        CreateReceiptLine(WhseReceiptLine);
        OnAfterCreateRcptLineFromPurchLine(WhseReceiptLine,WhseReceiptHeader,PurchLine);
        EXIT(NOT HasErrorOccured);
      END;
    END;

    [External]
    PROCEDURE FromTransLine2ShptLine@13(WhseShptHeader@1000 : Record 7320;TransLine@1001 : Record 5741) : Boolean;
    VAR
      WhseShptLine@1003 : Record 7321;
      TransHeader@1004 : Record 5740;
    BEGIN
      WITH WhseShptLine DO BEGIN
        InitNewLine(WhseShptHeader."No.");
        SetSource(DATABASE::"Transfer Line",0,TransLine."Document No.",TransLine."Line No.");
        TransLine.TESTFIELD("Unit of Measure Code");
        SetItemData(
          TransLine."Item No.",TransLine.Description,TransLine."Description 2",TransLine."Transfer-from Code",
          TransLine."Variant Code",TransLine."Unit of Measure Code",TransLine."Qty. per Unit of Measure");
        SetQtysOnShptLine(WhseShptLine,TransLine."Outstanding Quantity",TransLine."Outstanding Qty. (Base)");
        "Due Date" := TransLine."Shipment Date";
        IF WhseShptHeader."Shipment Date" = 0D THEN
          "Shipment Date" := WORKDATE
        ELSE
          "Shipment Date" := WhseShptHeader."Shipment Date";
        "Destination Type" := "Destination Type"::Location;
        "Destination No." := TransLine."Transfer-to Code";
        IF TransHeader.GET(TransLine."Document No.") THEN
          "Shipping Advice" := TransHeader."Shipping Advice";
        IF "Location Code" = WhseShptHeader."Location Code" THEN
          "Bin Code" := WhseShptHeader."Bin Code";
        IF "Bin Code" = '' THEN
          "Bin Code" := TransLine."Transfer-from Bin Code";
        UpdateShptLine(WhseShptLine,WhseShptHeader);
        CreateShptLine(WhseShptLine);
        OnAfterCreateShptLineFromTransLine(WhseShptLine,WhseShptHeader,TransLine);
        EXIT(NOT HasErrorOccured);
      END;
    END;

    [External]
    PROCEDURE TransLine2ReceiptLine@5(WhseReceiptHeader@1000 : Record 7316;TransLine@1001 : Record 5741) : Boolean;
    VAR
      WhseReceiptLine@1003 : Record 7317;
      UnitOfMeasureMgt@1002 : Codeunit 5402;
      WhseInbndOtsdgQty@1004 : Decimal;
    BEGIN
      WITH WhseReceiptLine DO BEGIN
        InitNewLine(WhseReceiptHeader."No.");
        SetSource(DATABASE::"Transfer Line",1,TransLine."Document No.",TransLine."Line No.");
        TransLine.TESTFIELD("Unit of Measure Code");
        SetItemData(
          TransLine."Item No.",TransLine.Description,TransLine."Description 2",TransLine."Transfer-to Code",
          TransLine."Variant Code",TransLine."Unit of Measure Code",TransLine."Qty. per Unit of Measure");
        VALIDATE("Qty. Received",TransLine."Quantity Received");
        TransLine.CALCFIELDS("Whse. Inbnd. Otsdg. Qty (Base)");
        WhseInbndOtsdgQty :=
          UnitOfMeasureMgt.CalcQtyFromBase(TransLine."Whse. Inbnd. Otsdg. Qty (Base)",TransLine."Qty. per Unit of Measure");
        SetQtysOnRcptLine(
          WhseReceiptLine,
          TransLine."Quantity Received" + TransLine."Qty. in Transit" - WhseInbndOtsdgQty,
          TransLine."Qty. Received (Base)" + TransLine."Qty. in Transit (Base)" - TransLine."Whse. Inbnd. Otsdg. Qty (Base)");
        "Due Date" := TransLine."Receipt Date";
        "Starting Date" := WORKDATE;
        IF "Location Code" = WhseReceiptHeader."Location Code" THEN
          "Bin Code" := WhseReceiptHeader."Bin Code";
        IF "Bin Code" = '' THEN
          "Bin Code" := TransLine."Transfer-To Bin Code";
        UpdateReceiptLine(WhseReceiptLine,WhseReceiptHeader);
        CreateReceiptLine(WhseReceiptLine);
        OnAfterCreateRcptLineFromTransLine(WhseReceiptLine,WhseReceiptHeader,TransLine);
        EXIT(NOT HasErrorOccured);
      END;
    END;

    LOCAL PROCEDURE CreateShptLine@3(VAR WhseShptLine@1001 : Record 7321);
    VAR
      Item@1002 : Record 27;
    BEGIN
      WITH WhseShptLine DO BEGIN
        Item."No." := "Item No.";
        Item.ItemSKUGet(Item,"Location Code","Variant Code");
        "Shelf No." := Item."Shelf No.";
        INSERT;
        OnAfterWhseShptLineInsert(WhseShptLine);
        CreateWhseItemTrackingLines;
      END;
    END;

    LOCAL PROCEDURE SetQtysOnShptLine@10(VAR WarehouseShipmentLine@1002 : Record 7321;Qty@1000 : Decimal;QtyBase@1001 : Decimal);
    VAR
      Location@1003 : Record 14;
    BEGIN
      WITH WarehouseShipmentLine DO BEGIN
        Quantity := Qty;
        "Qty. (Base)" := QtyBase;
        InitOutstandingQtys;
        CheckSourceDocLineQty;
        IF Location.GET("Location Code") THEN
          IF Location."Directed Put-away and Pick" THEN
            CheckBin(0,0);
      END;
    END;

    LOCAL PROCEDURE CreateReceiptLine@7(VAR WhseReceiptLine@1001 : Record 7317);
    VAR
      Item@1002 : Record 27;
    BEGIN
      WITH WhseReceiptLine DO BEGIN
        Item."No." := "Item No.";
        Item.ItemSKUGet(Item,"Location Code","Variant Code");
        "Shelf No." := Item."Shelf No.";
        Status := GetLineStatus;
        INSERT;
        OnAfterWhseReceiptLineInsert(WhseReceiptLine);
      END;
    END;

    LOCAL PROCEDURE SetQtysOnRcptLine@21(VAR WarehouseReceiptLine@1002 : Record 7317;Qty@1001 : Decimal;QtyBase@1000 : Decimal);
    BEGIN
      WITH WarehouseReceiptLine DO BEGIN
        Quantity := Qty;
        "Qty. (Base)" := QtyBase;
        InitOutstandingQtys;
      END;
    END;

    LOCAL PROCEDURE UpdateShptLine@1(VAR WhseShptLine@1001 : Record 7321;WhseShptHeader@1000 : Record 7320);
    BEGIN
      WITH WhseShptLine DO BEGIN
        IF WhseShptHeader."Zone Code" <> '' THEN
          VALIDATE("Zone Code",WhseShptHeader."Zone Code");
        IF WhseShptHeader."Bin Code" <> '' THEN
          VALIDATE("Bin Code",WhseShptHeader."Bin Code");
      END;
    END;

    LOCAL PROCEDURE UpdateReceiptLine@8(VAR WhseReceiptLine@1001 : Record 7317;WhseReceiptHeader@1000 : Record 7316);
    BEGIN
      WITH WhseReceiptLine DO BEGIN
        IF WhseReceiptHeader."Zone Code" <> '' THEN
          VALIDATE("Zone Code",WhseReceiptHeader."Zone Code");
        IF WhseReceiptHeader."Bin Code" <> '' THEN
          VALIDATE("Bin Code",WhseReceiptHeader."Bin Code");
        IF WhseReceiptHeader."Cross-Dock Zone Code" <> '' THEN
          VALIDATE("Cross-Dock Zone Code",WhseReceiptHeader."Cross-Dock Zone Code");
        IF WhseReceiptHeader."Cross-Dock Bin Code" <> '' THEN
          VALIDATE("Cross-Dock Bin Code",WhseReceiptHeader."Cross-Dock Bin Code");
      END;
    END;

    [External]
    PROCEDURE CheckIfFromSalesLine2ShptLine@19(SalesLine@1001 : Record 37) : Boolean;
    BEGIN
      IF SalesLine.IsServiceItem THEN
        EXIT(FALSE);
      SalesLine.CALCFIELDS("Whse. Outstanding Qty. (Base)");
      EXIT(ABS(SalesLine."Outstanding Qty. (Base)") > ABS(SalesLine."Whse. Outstanding Qty. (Base)"));
    END;

    [External]
    PROCEDURE CheckIfFromServiceLine2ShptLin@20(ServiceLine@1000 : Record 5902) : Boolean;
    BEGIN
      ServiceLine.CALCFIELDS("Whse. Outstanding Qty. (Base)");
      EXIT(
        (ABS(ServiceLine."Outstanding Qty. (Base)") > ABS(ServiceLine."Whse. Outstanding Qty. (Base)")) AND
        (ServiceLine."Qty. to Consume (Base)" = 0));
    END;

    [External]
    PROCEDURE CheckIfSalesLine2ReceiptLine@18(SalesLine@1001 : Record 37) : Boolean;
    VAR
      WhseReceiptLine@1002 : Record 7317;
    BEGIN
      IF SalesLine.IsServiceItem THEN
        EXIT(FALSE);
      WITH WhseReceiptLine DO BEGIN
        SetSourceFilter(DATABASE::"Sales Line",SalesLine."Document Type",SalesLine."Document No.",SalesLine."Line No.",FALSE);
        CALCSUMS("Qty. Outstanding (Base)");
        EXIT(ABS(SalesLine."Outstanding Qty. (Base)") > ABS("Qty. Outstanding (Base)"));
      END;
    END;

    [External]
    PROCEDURE CheckIfFromPurchLine2ShptLine@17(PurchLine@1001 : Record 39) : Boolean;
    VAR
      WhseShptLine@1000 : Record 7321;
    BEGIN
      IF PurchLine.IsServiceItem THEN
        EXIT(FALSE);
      WITH WhseShptLine DO BEGIN
        SetSourceFilter(DATABASE::"Purchase Line",PurchLine."Document Type",PurchLine."Document No.",PurchLine."Line No.",FALSE);
        CALCSUMS("Qty. Outstanding (Base)");
        EXIT(ABS(PurchLine."Outstanding Qty. (Base)") > "Qty. Outstanding (Base)");
      END;
    END;

    [External]
    PROCEDURE CheckIfPurchLine2ReceiptLine@16(PurchLine@1001 : Record 39) : Boolean;
    BEGIN
      IF PurchLine.IsServiceItem THEN
        EXIT(FALSE);
      PurchLine.CALCFIELDS("Whse. Outstanding Qty. (Base)");
      EXIT(ABS(PurchLine."Outstanding Qty. (Base)") > ABS(PurchLine."Whse. Outstanding Qty. (Base)"));
    END;

    [External]
    PROCEDURE CheckIfFromTransLine2ShptLine@15(TransLine@1001 : Record 5741) : Boolean;
    VAR
      Location@1005 : Record 14;
    BEGIN
      TransLine.CALCFIELDS("Whse Outbnd. Otsdg. Qty (Base)");
      IF Location.GetLocationSetup(TransLine."Transfer-from Code",Location) THEN
        IF Location."Use As In-Transit" THEN
          EXIT(FALSE);
      EXIT(TransLine."Outstanding Qty. (Base)" > TransLine."Whse Outbnd. Otsdg. Qty (Base)");
    END;

    [External]
    PROCEDURE CheckIfTransLine2ReceiptLine@14(TransLine@1001 : Record 5741) : Boolean;
    VAR
      Location@1005 : Record 14;
    BEGIN
      TransLine.CALCFIELDS("Whse. Inbnd. Otsdg. Qty (Base)");
      IF Location.GetLocationSetup(TransLine."Transfer-to Code",Location) THEN
        IF Location."Use As In-Transit" THEN
          EXIT(FALSE);
      EXIT(TransLine."Qty. in Transit (Base)" > TransLine."Whse. Inbnd. Otsdg. Qty (Base)");
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCreateShptLineFromSalesLine@22(VAR WarehouseShipmentLine@1001 : Record 7321;WarehouseShipmentHeader@1000 : Record 7320;SalesLine@1002 : Record 37);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCreateRcptLineFromSalesLine@24(VAR WarehouseReceiptLine@1000 : Record 7317;WarehouseReceiptHeader@1001 : Record 7316;SalesLine@1002 : Record 37);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCreateShptLineFromServiceLine@25(VAR WarehouseShipmentLine@1001 : Record 7321;WarehouseShipmentHeader@1000 : Record 7320;ServiceLine@1002 : Record 5902);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCreateShptLineFromPurchLine@28(VAR WarehouseShipmentLine@1001 : Record 7321;WarehouseShipmentHeader@1000 : Record 7320;PurchaseLine@1002 : Record 39);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCreateRcptLineFromPurchLine@27(VAR WarehouseReceiptLine@1000 : Record 7317;WarehouseReceiptHeader@1001 : Record 7316;PurchaseLine@1002 : Record 39);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCreateShptLineFromTransLine@23(VAR WarehouseShipmentLine@1001 : Record 7321;WarehouseShipmentHeader@1000 : Record 7320;TransferLine@1002 : Record 5741);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCreateRcptLineFromTransLine@26(VAR WarehouseReceiptLine@1000 : Record 7317;WarehouseReceiptHeader@1001 : Record 7316;TransferLine@1002 : Record 5741);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterWhseReceiptLineInsert@1002(WarehouseReceiptLine@1000 : Record 7317);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterWhseShptLineInsert@1003(VAR WarehouseShipmentLine@1000 : Record 7321);
    BEGIN
    END;

    BEGIN
    END.
  }
}

