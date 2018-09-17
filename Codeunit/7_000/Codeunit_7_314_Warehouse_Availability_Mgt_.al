OBJECT Codeunit 7314 Warehouse Availability Mgt.
{
  OBJECT-PROPERTIES
  {
    Date=28-06-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23019;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {

    [External]
    PROCEDURE CalcLineReservedQtyOnInvt@2(SourceType@1005 : Integer;SourceSubType@1004 : Option;SourceNo@1003 : Code[20];SourceLineNo@1002 : Integer;SourceSubLineNo@1001 : Integer;HandleResPickAndShipQty@1000 : Boolean;SerialNo@1010 : Code[20];LotNo@1009 : Code[20];VAR WarehouseActivityLine@1011 : Record 5767) : Decimal;
    VAR
      ReservEntry@1008 : Record 337;
      ReservEntry2@1007 : Record 337;
      ReservQtyonInvt@1006 : Decimal;
      PickQty@1012 : Decimal;
    BEGIN
      // Returns the reserved quantity against ILE for the demand line
      IF SourceType = DATABASE::"Prod. Order Component" THEN BEGIN
        ReservEntry.SetSourceFilter(SourceType,SourceSubType,SourceNo,SourceSubLineNo,TRUE);
        ReservEntry.SetSourceFilter2('',SourceLineNo);
      END ELSE
        ReservEntry.SetSourceFilter(SourceType,SourceSubType,SourceNo,SourceLineNo,TRUE);
      ReservEntry.SETRANGE("Reservation Status",ReservEntry."Reservation Status"::Reservation);
      IF ReservEntry."Serial No." <> '' THEN
        ReservEntry.SETRANGE("Serial No.",SerialNo);
      IF ReservEntry."Lot No." <> '' THEN
        ReservEntry.SETRANGE("Lot No.",LotNo);
      IF ReservEntry.FIND('-') THEN
        REPEAT
          ReservEntry2.SETRANGE("Entry No.",ReservEntry."Entry No.");
          ReservEntry2.SETRANGE(Positive,TRUE);
          ReservEntry2.SETRANGE("Source Type",DATABASE::"Item Ledger Entry");
          ReservEntry2.SETRANGE("Reservation Status",ReservEntry2."Reservation Status"::Reservation);
          IF SerialNo <> '' THEN
            ReservEntry2.SETRANGE("Serial No.",SerialNo);
          IF LotNo <> '' THEN
            ReservEntry2.SETRANGE("Lot No.",LotNo);
          IF ReservEntry2.FIND('-') THEN
            REPEAT
              ReservQtyonInvt += ReservEntry2."Quantity (Base)";
            UNTIL ReservEntry2.NEXT = 0;
        UNTIL ReservEntry.NEXT = 0;

      IF HandleResPickAndShipQty THEN BEGIN
        PickQty := CalcRegisteredAndOutstandingPickQty(ReservEntry,WarehouseActivityLine);
        IF ReservQtyonInvt > PickQty THEN
          ReservQtyonInvt -= PickQty
        ELSE
          ReservQtyonInvt := 0;
      END;

      EXIT(ReservQtyonInvt);
    END;

    [External]
    PROCEDURE CalcReservQtyOnPicksShips@53(LocationCode@1004 : Code[10];ItemNo@1003 : Code[20];VariantCode@1002 : Code[10];VAR WarehouseActivityLine@1005 : Record 5767) : Decimal;
    VAR
      ReservEntry@1000 : Record 337;
      TempReservEntryBuffer@1001 : TEMPORARY Record 7360;
      ResPickShipQty@1007 : Decimal;
      QtyPicked@1008 : Decimal;
      QtyToPick@1006 : Decimal;
    BEGIN
      // Returns the reserved part of the sum of outstanding quantity on pick lines and
      // quantity on shipment lines picked but not yet shipped for a given item
      ReservEntry.SETCURRENTKEY(
        "Item No.","Variant Code","Location Code","Reservation Status");
      ReservEntry.SETRANGE("Item No.",ItemNo);
      ReservEntry.SETRANGE("Variant Code",VariantCode);
      ReservEntry.SETRANGE("Location Code",LocationCode);
      ReservEntry.SETRANGE("Reservation Status",ReservEntry."Reservation Status"::Reservation);
      ReservEntry.SETRANGE(Positive,FALSE);
      IF NOT ReservEntry.FINDSET THEN
        EXIT(0);

      WITH TempReservEntryBuffer DO BEGIN
        REPEAT
          TRANSFERFIELDS(ReservEntry);
          IF FIND THEN BEGIN
            "Quantity (Base)" += ReservEntry."Quantity (Base)";
            MODIFY;
          END ELSE
            INSERT;
        UNTIL ReservEntry.NEXT = 0;

        IF FINDSET THEN
          REPEAT
            QtyPicked :=
              CalcQtyRegisteredPick(
                LocationCode,"Source Type","Source Subtype","Source ID","Source Ref. No.","Source Prod. Order Line");
            QtyToPick :=
              CalcQtyOutstandingPick(
                "Source Type","Source Subtype","Source ID","Source Ref. No.","Source Prod. Order Line",WarehouseActivityLine);
            IF -"Quantity (Base)" > QtyPicked + QtyToPick THEN
              ResPickShipQty += (QtyPicked + QtyToPick)
            ELSE
              ResPickShipQty += -"Quantity (Base)";
          UNTIL NEXT = 0;

        EXIT(ResPickShipQty);
      END;
    END;

    [External]
    PROCEDURE CalcInvtAvailQty@45(Item@1000 : Record 27;Location@1001 : Record 14;VariantCode@1002 : Code[10];VAR WarehouseActivityLine@1009 : Record 5767) : Decimal;
    VAR
      QtyReceivedNotAvail@1004 : Decimal;
      QtyAssgndtoPick@1003 : Decimal;
      QtyShipped@1005 : Decimal;
      QtyReservedOnPickShip@1006 : Decimal;
      QtyOnDedicatedBins@1008 : Decimal;
      SubTotal@1007 : Decimal;
    BEGIN
      // Returns the available quantity to pick for pick/ship/receipt/put-away
      // locations without directed put-away and pick
      WITH Item DO BEGIN
        SETRANGE("Location Filter",Location.Code);
        SETRANGE("Variant Filter",VariantCode);
        IF Location."Require Shipment" THEN
          CALCFIELDS(Inventory,"Reserved Qty. on Inventory","Qty. Picked")
        ELSE
          CALCFIELDS(Inventory,"Reserved Qty. on Inventory");

        IF Location."Require Receive" AND Location."Require Put-away" THEN
          QtyReceivedNotAvail := CalcQtyRcvdNotAvailable(Location.Code,"No.",VariantCode);

        QtyAssgndtoPick := CalcQtyAssgndtoPick(Location,"No.",VariantCode,'');

        IF Location.RequireShipment(Location.Code) THEN
          QtyShipped := CalcQtyShipped(Location,"No.",VariantCode);
        QtyReservedOnPickShip := CalcReservQtyOnPicksShips(Location.Code,"No.",VariantCode,WarehouseActivityLine);
        QtyOnDedicatedBins := CalcQtyOnDedicatedBins(Location.Code,"No.",VariantCode,'','');

        // The reserved qty might exceed the qty available in warehouse and thereby
        // having reserved from the qty not yet put-away
        IF (Inventory - QtyReceivedNotAvail - QtyAssgndtoPick - "Qty. Picked" + QtyShipped - QtyOnDedicatedBins) <
           (ABS("Reserved Qty. on Inventory") - QtyReservedOnPickShip)
        THEN
          EXIT(0);

        SubTotal :=
          Inventory - QtyReceivedNotAvail - QtyAssgndtoPick -
          ABS("Reserved Qty. on Inventory") - "Qty. Picked" + QtyShipped - QtyOnDedicatedBins;

        EXIT(SubTotal);
      END;
    END;

    LOCAL PROCEDURE CalcQtyRcvdNotAvailable@3(LocationCode@1002 : Code[10];ItemNo@1001 : Code[20];VariantCode@1003 : Code[10]) : Decimal;
    VAR
      PostedWhseRcptLine@1000 : Record 7319;
    BEGIN
      // Returns the quantity received but not yet put-away for a given item
      // for pick/ship/receipt/put-away locations without directed put-away and pick
      WITH PostedWhseRcptLine DO BEGIN
        SETCURRENTKEY("Item No.","Location Code","Variant Code");
        SETRANGE("Item No.",ItemNo);
        SETRANGE("Location Code",LocationCode);
        SETRANGE("Variant Code",VariantCode);
        CALCSUMS("Qty. (Base)","Qty. Put Away (Base)");
        EXIT("Qty. (Base)" - "Qty. Put Away (Base)");
      END;
    END;

    [External]
    PROCEDURE CalcQtyAssgndtoPick@48(Location@1002 : Record 14;ItemNo@1009 : Code[20];VariantCode@1008 : Code[10];BinTypeFilter@1001 : Text[250]) : Decimal;
    VAR
      WhseActivLine@1000 : Record 5767;
    BEGIN
      // Returns the outstanding quantity on pick lines for a given item
      // for a pick location without directed put-away and pick
      WITH WhseActivLine DO BEGIN
        SETCURRENTKEY(
          "Item No.","Location Code","Activity Type","Bin Type Code",
          "Unit of Measure Code","Variant Code","Breakbulk No.");
        SETRANGE("Item No.",ItemNo);
        SETRANGE("Location Code",Location.Code);
        SETRANGE("Variant Code",VariantCode);
        SETRANGE("Bin Type Code",BinTypeFilter);
        IF Location."Bin Mandatory" THEN
          SETRANGE("Action Type","Action Type"::Take)
        ELSE BEGIN
          SETRANGE("Action Type","Action Type"::" ");
          SETRANGE("Breakbulk No.",0);
        END;
        IF Location."Require Shipment" THEN
          SETRANGE("Activity Type","Activity Type"::Pick)
        ELSE BEGIN
          SETRANGE("Activity Type","Activity Type"::"Invt. Pick");
          SETRANGE("Assemble to Order",FALSE);
        END;
        CALCSUMS("Qty. Outstanding (Base)");
        EXIT("Qty. Outstanding (Base)");
      END;
    END;

    [External]
    PROCEDURE CalcQtyAssgndOnWksh@43(DefWhseWkshLine@1000 : Record 7326;RespectUOMCode@1001 : Boolean;ExcludeLine@1002 : Boolean) : Decimal;
    VAR
      WhseWkshLine@1004 : Record 7326;
    BEGIN
      WITH WhseWkshLine DO BEGIN
        SETCURRENTKEY(
          "Item No.","Location Code","Worksheet Template Name","Variant Code","Unit of Measure Code");
        SETRANGE("Item No.",DefWhseWkshLine."Item No.");
        SETRANGE("Location Code",DefWhseWkshLine."Location Code");
        SETRANGE("Worksheet Template Name",DefWhseWkshLine."Worksheet Template Name");
        SETRANGE("Variant Code",DefWhseWkshLine."Variant Code");
        IF RespectUOMCode THEN
          SETRANGE("Unit of Measure Code",DefWhseWkshLine."Unit of Measure Code");
        CALCSUMS("Qty. to Handle (Base)");
        IF ExcludeLine AND DefWhseWkshLine.FIND THEN
          "Qty. to Handle (Base)" := "Qty. to Handle (Base)" - DefWhseWkshLine."Qty. to Handle (Base)";
        EXIT("Qty. to Handle (Base)");
      END;
    END;

    LOCAL PROCEDURE CalcQtyShipped@51(Location@1002 : Record 14;ItemNo@1009 : Code[20];VariantCode@1008 : Code[10]) : Decimal;
    VAR
      WhseShptLine@1000 : Record 7321;
    BEGIN
      WITH WhseShptLine DO BEGIN
        SETCURRENTKEY("Item No.","Location Code","Variant Code","Due Date");
        SETRANGE("Item No.",ItemNo);
        SETRANGE("Location Code",Location.Code);
        SETRANGE("Variant Code",VariantCode);
        CALCSUMS("Qty. Shipped (Base)");
        EXIT("Qty. Shipped (Base)");
      END;
    END;

    [External]
    PROCEDURE CalcQtyOnDedicatedBins@1(LocationCode@1000 : Code[10];ItemNo@1001 : Code[20];VariantCode@1002 : Code[10];LotNo@1003 : Code[20];SerialNo@1004 : Code[20]) : Decimal;
    VAR
      WhseEntry@1005 : Record 7312;
    BEGIN
      WhseEntry.SETCURRENTKEY("Item No.","Bin Code","Location Code","Variant Code",
        "Unit of Measure Code","Lot No.","Serial No.","Entry Type");
      WhseEntry.SETRANGE("Item No.",ItemNo);
      WhseEntry.SETRANGE("Location Code",LocationCode);
      WhseEntry.SETRANGE("Variant Code",VariantCode);
      WhseEntry.SETRANGE(Dedicated,TRUE);
      IF LotNo <> '' THEN
        WhseEntry.SETRANGE("Lot No.",LotNo);
      IF SerialNo <> '' THEN
        WhseEntry.SETRANGE("Serial No.",SerialNo);
      WhseEntry.CALCSUMS(WhseEntry."Qty. (Base)");
      EXIT(WhseEntry."Qty. (Base)");
    END;

    PROCEDURE CalcQtyOnAssemblyBin@4(LocationCode@1000 : Code[10];ItemNo@1001 : Code[20];VariantCode@1002 : Code[10];LotNo@1003 : Code[20];SerialNo@1004 : Code[20]) : Decimal;
    VAR
      Location@1006 : Record 14;
      WhseEntry@1005 : Record 7312;
    BEGIN
      Location.GET(LocationCode);
      IF Location."To-Assembly Bin Code" = '' THEN
        EXIT(0);

      WITH WhseEntry DO BEGIN
        SETCURRENTKEY("Item No.","Bin Code","Location Code","Variant Code",
          "Unit of Measure Code","Lot No.","Serial No.","Entry Type");
        SETRANGE("Item No.",ItemNo);
        SETRANGE("Bin Code",Location."To-Assembly Bin Code");
        SETRANGE("Location Code",LocationCode);
        SETRANGE("Variant Code",VariantCode);
        IF LotNo <> '' THEN
          SETRANGE("Lot No.",LotNo);
        IF SerialNo <> '' THEN
          SETRANGE("Serial No.",SerialNo);
        CALCSUMS("Qty. (Base)");
        EXIT("Qty. (Base)");
      END;
    END;

    [External]
    PROCEDURE CalcQtyOnBlockedITOrOnBlockedOutbndBins@67(LocationCode@1000 : Code[10];ItemNo@1001 : Code[20];VariantCode@1002 : Code[10];LotNo@1003 : Code[20];SerialNo@1004 : Code[20];LNRequired@1006 : Boolean;SNRequired@1007 : Boolean) QtyBlocked : Decimal;
    VAR
      BinContent@1005 : Record 7302;
    BEGIN
      WITH BinContent DO BEGIN
        SETCURRENTKEY("Location Code","Item No.","Variant Code");
        SETRANGE("Location Code",LocationCode);
        SETRANGE("Item No.",ItemNo);
        SETRANGE("Variant Code",VariantCode);
        IF LotNo <> '' THEN
          IF LNRequired THEN
            SETRANGE("Lot No. Filter",LotNo);
        IF SerialNo <> '' THEN
          IF SNRequired THEN
            SETRANGE("Serial No. Filter",SerialNo);
        IF FINDSET THEN
          REPEAT
            IF "Block Movement" IN ["Block Movement"::All,"Block Movement"::Outbound] THEN BEGIN
              CALCFIELDS("Quantity (Base)");
              QtyBlocked += "Quantity (Base)";
            END ELSE
              QtyBlocked += CalcQtyWithBlockedItemTracking;
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE CalcQtyPickedOnProdOrderComponentLine@8(SourceSubtype@1004 : Option;SourceID@1001 : Code[20];SourceProdOrderLineNo@1002 : Integer;SourceRefNo@1003 : Integer) : Decimal;
    VAR
      ProdOrderComponent@1000 : Record 5407;
    BEGIN
      WITH ProdOrderComponent DO BEGIN
        SETRANGE(Status,SourceSubtype);
        SETRANGE("Prod. Order No.",SourceID);
        SETRANGE("Prod. Order Line No.",SourceProdOrderLineNo);
        SETRANGE("Line No.",SourceRefNo);
        IF FINDFIRST THEN
          EXIT("Qty. Picked (Base)");
      END;

      EXIT(0);
    END;

    LOCAL PROCEDURE CalcQtyPickedOnWhseShipmentLine@9(SourceType@1000 : Integer;SourceSubType@1001 : Option;SourceID@1002 : Code[20];SourceRefNo@1003 : Integer) : Decimal;
    VAR
      WhseShipmentLine@1004 : Record 7321;
    BEGIN
      WITH WhseShipmentLine DO BEGIN
        SetSourceFilter(SourceType,SourceSubType,SourceID,SourceRefNo,FALSE);
        CALCSUMS("Qty. Picked (Base)","Qty. Shipped (Base)");
        EXIT("Qty. Picked (Base)" - "Qty. Shipped (Base)");
      END;
    END;

    PROCEDURE CalcRegisteredAndOutstandingPickQty@12(ReservationEntry@1001 : Record 337;VAR WarehouseActivityLine@1000 : Record 5767) : Decimal;
    BEGIN
      WITH ReservationEntry DO
        EXIT(
          CalcQtyRegisteredPick(
            "Location Code","Source Type","Source Subtype","Source ID","Source Ref. No.","Source Prod. Order Line") +
          CalcQtyOutstandingPick(
            "Source Type","Source Subtype","Source ID","Source Ref. No.","Source Prod. Order Line",WarehouseActivityLine));
    END;

    LOCAL PROCEDURE CalcQtyRegisteredPick@11(LocationCode@1005 : Code[10];SourceType@1004 : Integer;SourceSubType@1003 : Option;SourceID@1002 : Code[20];SourceRefNo@1001 : Integer;SourceProdOrderLine@1000 : Integer) : Decimal;
    VAR
      Location@1006 : Record 14;
    BEGIN
      IF SourceType = DATABASE::"Prod. Order Component" THEN
        EXIT(CalcQtyPickedOnProdOrderComponentLine(SourceSubType,SourceID,SourceProdOrderLine,SourceRefNo));

      IF Location.RequireShipment(LocationCode) THEN
        EXIT(CalcQtyPickedOnWhseShipmentLine(SourceType,SourceSubType,SourceID,SourceRefNo));

      EXIT(0);
    END;

    LOCAL PROCEDURE CalcQtyOutstandingPick@10(SourceType@1005 : Integer;SourceSubType@1004 : Option;SourceID@1003 : Code[20];SourceRefNo@1002 : Integer;SourceProdOrderLine@1001 : Integer;VAR WarehouseActivityLine@1000 : Record 5767) : Decimal;
    VAR
      WhseActivityLine@1006 : Record 5767;
    BEGIN
      IF SourceType = DATABASE::"Prod. Order Component" THEN
        WhseActivityLine.SetSourceFilter(SourceType,SourceSubType,SourceID,SourceProdOrderLine,-1,TRUE)
      ELSE
        WhseActivityLine.SetSourceFilter(SourceType,SourceSubType,SourceID,SourceRefNo,-1,TRUE);
      WhseActivityLine.SETFILTER("Action Type",'%1|%2',WhseActivityLine."Action Type"::Take,WhseActivityLine."Action Type"::" ");
      WhseActivityLine.CALCSUMS("Qty. Outstanding (Base)");

      // For not yet committed warehouse activity lines
      WarehouseActivityLine.COPYFILTERS(WhseActivityLine);
      WarehouseActivityLine.CALCSUMS("Qty. Outstanding (Base)");

      EXIT(WhseActivityLine."Qty. Outstanding (Base)" + WarehouseActivityLine."Qty. Outstanding (Base)");
    END;

    BEGIN
    END.
  }
}

