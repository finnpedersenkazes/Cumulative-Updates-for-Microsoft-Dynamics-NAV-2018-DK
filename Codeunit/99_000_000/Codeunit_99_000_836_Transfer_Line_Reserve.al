OBJECT Codeunit 99000836 Transfer Line-Reserve
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    Permissions=TableData 337=rimd,
                TableData 99000850=rimd;
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Codeunit er ikke initialiseret korrekt.;ENU=Codeunit is not initialized correctly.';
      Text001@1001 : TextConst 'DAN=Reserveret antal m� ikke v�re st�rre end %1.;ENU=Reserved quantity cannot be greater than %1';
      Text002@1002 : TextConst 'DAN=skal udfyldes, n�r et antal er reserveret;ENU=must be filled in when a quantity is reserved';
      Text003@1003 : TextConst 'DAN=m� ikke �ndres, n�r et antal er reserveret;ENU=must not be changed when a quantity is reserved';
      ReservMgt@1005 : Codeunit 99000845;
      CreateReservEntry@1006 : Codeunit 99000830;
      ReservEngineMgt@1007 : Codeunit 99000831;
      Blocked@1008 : Boolean;
      SetFromType@1009 : ' ,Sales,Requisition Line,Purchase,Item Journal,BOM Journal,Item Ledger Entry,Service,Job';
      SetFromSubtype@1010 : Integer;
      SetFromID@1011 : Code[20];
      SetFromBatchName@1012 : Code[10];
      SetFromProdOrderLine@1013 : Integer;
      SetFromRefNo@1014 : Integer;
      SetFromVariantCode@1015 : Code[10];
      SetFromLocationCode@1016 : Code[10];
      SetFromSerialNo@1018 : Code[20];
      SetFromLotNo@1019 : Code[20];
      SetFromQtyPerUOM@1020 : Decimal;
      DeleteItemTracking@1004 : Boolean;

    [External]
    PROCEDURE CreateReservation@4(VAR TransLine@1000 : Record 5741;Description@1001 : Text[50];ExpectedReceiptDate@1002 : Date;Quantity@1006 : Decimal;QuantityBase@1003 : Decimal;ForSerialNo@1005 : Code[20];ForLotNo@1004 : Code[20];Direction@1007 : 'Outbound,Inbound');
    VAR
      ShipmentDate@1008 : Date;
    BEGIN
      IF SetFromType = 0 THEN
        ERROR(Text000);

      TransLine.TESTFIELD("Item No.");
      TransLine.TESTFIELD("Variant Code",SetFromVariantCode);

      CASE Direction OF
        Direction::Outbound:
          BEGIN
            TransLine.TESTFIELD("Shipment Date");
            TransLine.TESTFIELD("Transfer-from Code",SetFromLocationCode);
            TransLine.CALCFIELDS("Reserved Qty. Outbnd. (Base)");
            IF ABS(TransLine."Outstanding Qty. (Base)") <
               ABS(TransLine."Reserved Qty. Outbnd. (Base)") + QuantityBase
            THEN
              ERROR(
                Text001,
                ABS(TransLine."Outstanding Qty. (Base)") - ABS(TransLine."Reserved Qty. Outbnd. (Base)"));
            ShipmentDate := TransLine."Shipment Date";
          END;
        Direction::Inbound:
          BEGIN
            TransLine.TESTFIELD("Receipt Date");
            TransLine.TESTFIELD("Transfer-to Code",SetFromLocationCode);
            TransLine.CALCFIELDS("Reserved Qty. Inbnd. (Base)");
            IF ABS(TransLine."Outstanding Qty. (Base)") <
               ABS(TransLine."Reserved Qty. Inbnd. (Base)") + QuantityBase
            THEN
              ERROR(
                Text001,
                ABS(TransLine."Outstanding Qty. (Base)") - ABS(TransLine."Reserved Qty. Inbnd. (Base)"));
            ExpectedReceiptDate := TransLine."Receipt Date";
            ShipmentDate := GetInboundReservEntryShipmentDate;
          END;
      END;
      CreateReservEntry.CreateReservEntryFor(
        DATABASE::"Transfer Line",
        Direction,TransLine."Document No.",'',
        TransLine."Derived From Line No.",TransLine."Line No.",TransLine."Qty. per Unit of Measure",
        Quantity,QuantityBase,ForSerialNo,ForLotNo);
      CreateReservEntry.CreateReservEntryFrom(
        SetFromType,SetFromSubtype,SetFromID,SetFromBatchName,SetFromProdOrderLine,SetFromRefNo,
        SetFromQtyPerUOM,SetFromSerialNo,SetFromLotNo);
      CreateReservEntry.CreateReservEntry(
        TransLine."Item No.",TransLine."Variant Code",SetFromLocationCode,
        Description,ExpectedReceiptDate,ShipmentDate);

      SetFromType := 0;
    END;

    [External]
    PROCEDURE CreateReservationSetFrom@7(TrackingSpecificationFrom@1000 : Record 336);
    BEGIN
      WITH TrackingSpecificationFrom DO BEGIN
        SetFromType := "Source Type";
        SetFromSubtype := "Source Subtype";
        SetFromID := "Source ID";
        SetFromBatchName := "Source Batch Name";
        SetFromProdOrderLine := "Source Prod. Order Line";
        SetFromRefNo := "Source Ref. No.";
        SetFromVariantCode := "Variant Code";
        SetFromLocationCode := "Location Code";
        SetFromSerialNo := "Serial No.";
        SetFromLotNo := "Lot No.";
        SetFromQtyPerUOM := "Qty. per Unit of Measure";
      END;
    END;

    [External]
    PROCEDURE FilterReservFor@9(VAR FilterReservEntry@1000 : Record 337;TransLine@1001 : Record 5741;Direction@1002 : 'Outbound,Inbound');
    BEGIN
      FilterReservEntry.SetSourceFilter(DATABASE::"Transfer Line",Direction,TransLine."Document No.",TransLine."Line No.",FALSE);
      FilterReservEntry.SetSourceFilter2('',TransLine."Derived From Line No.");
    END;

    [External]
    PROCEDURE Caption@27(TransLine@1001 : Record 5741) CaptionText@1000 : Text[80];
    BEGIN
      CaptionText :=
        STRSUBSTNO(
          '%1 %2 %3',TransLine."Document No.",TransLine."Line No.",
          TransLine."Item No.");
    END;

    [External]
    PROCEDURE FindReservEntry@1(TransLine@1000 : Record 5741;VAR ReservEntry@1001 : Record 337;Direction@1002 : 'Outbound,Inbound') : Boolean;
    BEGIN
      ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry,FALSE);
      FilterReservFor(ReservEntry,TransLine,Direction);
      EXIT(ReservEntry.FINDLAST);
    END;

    LOCAL PROCEDURE ReservEntryExist@13(TransLine@1000 : Record 5741) : Boolean;
    VAR
      ReservEntry@1001 : Record 337;
    BEGIN
      ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry,FALSE);
      FilterReservFor(ReservEntry,TransLine,0);
      ReservEntry.SETRANGE("Source Subtype"); // Ignore direction
      EXIT(NOT ReservEntry.ISEMPTY);
    END;

    [External]
    PROCEDURE VerifyChange@62(VAR NewTransLine@1000 : Record 5741;VAR OldTransLine@1001 : Record 5741);
    VAR
      TransLine@1007 : Record 5741;
      TempReservEntry@1002 : Record 337;
      ShowErrorInbnd@1003 : Boolean;
      ShowErrorOutbnd@1004 : Boolean;
      HasErrorInbnd@1005 : Boolean;
      HasErrorOutbnd@1006 : Boolean;
    BEGIN
      IF Blocked THEN
        EXIT;
      IF NewTransLine."Line No." = 0 THEN
        IF NOT TransLine.GET(NewTransLine."Document No.",NewTransLine."Line No.") THEN
          EXIT;

      NewTransLine.CALCFIELDS("Reserved Qty. Inbnd. (Base)");
      NewTransLine.CALCFIELDS("Reserved Qty. Outbnd. (Base)");

      ShowErrorInbnd := (NewTransLine."Reserved Qty. Inbnd. (Base)" <> 0);
      ShowErrorOutbnd := (NewTransLine."Reserved Qty. Outbnd. (Base)" <> 0);

      IF NewTransLine."Shipment Date" = 0D THEN
        IF ShowErrorOutbnd THEN
          NewTransLine.FIELDERROR("Shipment Date",Text002)
        ELSE
          HasErrorOutbnd := TRUE;

      IF NewTransLine."Receipt Date" = 0D THEN
        IF ShowErrorInbnd THEN
          NewTransLine.FIELDERROR("Receipt Date",Text002)
        ELSE
          HasErrorInbnd := TRUE;

      IF NewTransLine."Item No." <> OldTransLine."Item No." THEN
        IF ShowErrorInbnd OR ShowErrorOutbnd THEN
          NewTransLine.FIELDERROR("Item No.",Text003)
        ELSE BEGIN
          HasErrorInbnd := TRUE;
          HasErrorOutbnd := TRUE;
        END;

      IF NewTransLine."Transfer-from Code" <> OldTransLine."Transfer-from Code" THEN
        IF ShowErrorOutbnd THEN
          NewTransLine.FIELDERROR("Transfer-from Code",Text003)
        ELSE
          HasErrorOutbnd := TRUE;

      IF NewTransLine."Transfer-to Code" <> OldTransLine."Transfer-to Code" THEN
        IF ShowErrorInbnd THEN
          NewTransLine.FIELDERROR("Transfer-to Code",Text003)
        ELSE
          HasErrorInbnd := TRUE;

      IF (NewTransLine."Transfer-from Bin Code" <> OldTransLine."Transfer-from Bin Code") AND
         (NOT ReservMgt.CalcIsAvailTrackedQtyInBin(
            NewTransLine."Item No.",NewTransLine."Transfer-from Bin Code",
            NewTransLine."Transfer-from Code",NewTransLine."Variant Code",
            DATABASE::"Transfer Line",0,
            NewTransLine."Document No.",'',NewTransLine."Derived From Line No.",
            NewTransLine."Line No."))
      THEN BEGIN
        IF ShowErrorOutbnd THEN
          NewTransLine.FIELDERROR("Transfer-from Bin Code",Text003);
        HasErrorOutbnd := TRUE;
      END;

      IF (NewTransLine."Transfer-To Bin Code" <> OldTransLine."Transfer-To Bin Code") AND
         (NOT ReservMgt.CalcIsAvailTrackedQtyInBin(
            NewTransLine."Item No.",NewTransLine."Transfer-To Bin Code",
            NewTransLine."Transfer-to Code",NewTransLine."Variant Code",
            DATABASE::"Transfer Line",1,
            NewTransLine."Document No.",'',NewTransLine."Derived From Line No.",
            NewTransLine."Line No."))
      THEN BEGIN
        IF ShowErrorInbnd THEN
          NewTransLine.FIELDERROR("Transfer-To Bin Code",Text003);
        HasErrorInbnd := TRUE;
      END;

      IF NewTransLine."Variant Code" <> OldTransLine."Variant Code" THEN
        IF ShowErrorInbnd OR ShowErrorOutbnd THEN
          NewTransLine.FIELDERROR("Variant Code",Text003)
        ELSE BEGIN
          HasErrorInbnd := TRUE;
          HasErrorOutbnd := TRUE;
        END;

      IF NewTransLine."Line No." <> OldTransLine."Line No." THEN BEGIN
        HasErrorInbnd := TRUE;
        HasErrorOutbnd := TRUE;
      END;

      IF HasErrorOutbnd THEN BEGIN
        AutoTracking(OldTransLine,NewTransLine,TempReservEntry,0);
        AssignForPlanning(NewTransLine,0);
        IF (NewTransLine."Item No." <> OldTransLine."Item No.") OR
           (NewTransLine."Variant Code" <> OldTransLine."Variant Code") OR
           (NewTransLine."Transfer-to Code" <> OldTransLine."Transfer-to Code")
        THEN
          AssignForPlanning(OldTransLine,0);
      END;

      IF HasErrorInbnd THEN BEGIN
        AutoTracking(OldTransLine,NewTransLine,TempReservEntry,1);
        AssignForPlanning(NewTransLine,1);
        IF (NewTransLine."Item No." <> OldTransLine."Item No.") OR
           (NewTransLine."Variant Code" <> OldTransLine."Variant Code") OR
           (NewTransLine."Transfer-from Code" <> OldTransLine."Transfer-from Code")
        THEN
          AssignForPlanning(OldTransLine,1);
      END;
    END;

    [External]
    PROCEDURE VerifyQuantity@3(VAR NewTransLine@1000 : Record 5741;VAR OldTransLine@1001 : Record 5741);
    VAR
      TransLine@1003 : Record 5741;
      Direction@1002 : 'Outbound,Inbound';
    BEGIN
      IF Blocked THEN
        EXIT;

      WITH NewTransLine DO BEGIN
        IF "Line No." = OldTransLine."Line No." THEN
          IF "Quantity (Base)" = OldTransLine."Quantity (Base)" THEN
            EXIT;
        IF "Line No." = 0 THEN
          IF NOT TransLine.GET("Document No.","Line No.") THEN
            EXIT;
        FOR Direction := Direction::Outbound TO Direction::Inbound DO BEGIN
          ReservMgt.SetTransferLine(NewTransLine,Direction);
          IF "Qty. per Unit of Measure" <> OldTransLine."Qty. per Unit of Measure" THEN
            ReservMgt.ModifyUnitOfMeasure;
          ReservMgt.DeleteReservEntries(FALSE,"Outstanding Qty. (Base)");
          ReservMgt.ClearSurplus;
          ReservMgt.AutoTrack("Outstanding Qty. (Base)");
          AssignForPlanning(NewTransLine,Direction);
        END;
      END;
    END;

    [External]
    PROCEDURE UpdatePlanningFlexibility@23(VAR TransLine@1000 : Record 5741);
    VAR
      ReservEntry@1001 : Record 337;
    BEGIN
      IF FindReservEntry(TransLine,ReservEntry,0) THEN
        ReservEntry.MODIFYALL("Planning Flexibility",TransLine."Planning Flexibility");
      IF FindReservEntry(TransLine,ReservEntry,1) THEN
        ReservEntry.MODIFYALL("Planning Flexibility",TransLine."Planning Flexibility");
    END;

    [External]
    PROCEDURE TransferTransferToItemJnlLine@35(VAR TransLine@1000 : Record 5741;VAR ItemJnlLine@1001 : Record 83;TransferQty@1002 : Decimal;Direction@1003 : 'Outbound,Inbound');
    VAR
      OldReservEntry@1004 : Record 337;
      TransferLocation@1006 : Code[10];
    BEGIN
      IF NOT FindReservEntry(TransLine,OldReservEntry,Direction) THEN
        EXIT;

      OldReservEntry.Lock;

      CASE Direction OF
        Direction::Outbound:
          BEGIN
            TransferLocation := TransLine."Transfer-from Code";
            ItemJnlLine.TESTFIELD("Location Code",TransferLocation);
          END;
        Direction::Inbound:
          BEGIN
            TransferLocation := TransLine."Transfer-to Code";
            ItemJnlLine.TESTFIELD("New Location Code",TransferLocation);
          END;
      END;

      ItemJnlLine.TESTFIELD("Item No.",TransLine."Item No.");
      ItemJnlLine.TESTFIELD("Variant Code",TransLine."Variant Code");

      IF TransferQty = 0 THEN
        EXIT;
      IF ReservEngineMgt.InitRecordSet(OldReservEntry) THEN
        REPEAT
          OldReservEntry.TestItemFields(TransLine."Item No.",TransLine."Variant Code",TransferLocation);
          OldReservEntry."New Serial No." := OldReservEntry."Serial No.";
          OldReservEntry."New Lot No." := OldReservEntry."Lot No.";

          TransferQty :=
            CreateReservEntry.TransferReservEntry(DATABASE::"Item Journal Line",
              ItemJnlLine."Entry Type",ItemJnlLine."Journal Template Name",
              ItemJnlLine."Journal Batch Name",0,ItemJnlLine."Line No.",
              ItemJnlLine."Qty. per Unit of Measure",OldReservEntry,TransferQty);

        UNTIL (ReservEngineMgt.NEXTRecord(OldReservEntry) = 0) OR (TransferQty = 0);
    END;

    PROCEDURE TransferWhseShipmentToItemJnlLine@8(VAR TransLine@1000 : Record 5741;VAR ItemJnlLine@1001 : Record 83;VAR WhseShptHeader@1010 : Record 7320;TransferQty@1002 : Decimal);
    VAR
      OldReservEntry@1004 : Record 337;
      WhseShptLine@1009 : Record 7321;
      WarehouseEntry@1003 : Record 7312;
      ItemTrackingMgt@1005 : Codeunit 6500;
      WhseSNRequired@1006 : Boolean;
      WhseLNRequired@1007 : Boolean;
      QtyToHandleBase@1011 : Decimal;
    BEGIN
      IF TransferQty = 0 THEN
        EXIT;
      IF NOT FindReservEntry(TransLine,OldReservEntry,0) THEN
        EXIT;

      ItemJnlLine.TESTFIELD("Location Code",TransLine."Transfer-from Code");
      ItemJnlLine.TESTFIELD("Item No.",TransLine."Item No.");
      ItemJnlLine.TESTFIELD("Variant Code",TransLine."Variant Code");

      WhseShptLine.GetWhseShptLine(
        WhseShptHeader."No.",DATABASE::"Transfer Line",0,TransLine."Document No.",TransLine."Line No.");

      OldReservEntry.Lock;
      IF ReservEngineMgt.InitRecordSet(OldReservEntry) THEN
        REPEAT
          OldReservEntry.TestItemFields(TransLine."Item No.",TransLine."Variant Code",TransLine."Transfer-from Code");
          ItemTrackingMgt.CheckWhseItemTrkgSetup(TransLine."Item No.",WhseSNRequired,WhseLNRequired,FALSE);

          WarehouseEntry.SetSourceFilter(
            OldReservEntry."Source Type",OldReservEntry."Source Subtype",
            OldReservEntry."Source ID",OldReservEntry."Source Ref. No.",FALSE);
          WarehouseEntry.SETRANGE("Whse. Document Type",WarehouseEntry."Whse. Document Type"::Shipment);
          WarehouseEntry.SETRANGE("Whse. Document No.",WhseShptLine."No.");
          WarehouseEntry.SETRANGE("Whse. Document Line No.",WhseShptLine."Line No.");
          WarehouseEntry.SETRANGE("Bin Code",WhseShptHeader."Bin Code");
          IF WhseSNRequired THEN
            WarehouseEntry.SETRANGE("Serial No.",OldReservEntry."Serial No.");
          IF WhseLNRequired THEN
            WarehouseEntry.SETRANGE("Lot No.",OldReservEntry."Lot No.");
          WarehouseEntry.CALCSUMS("Qty. (Base)");
          QtyToHandleBase := -WarehouseEntry."Qty. (Base)";
          IF ABS(QtyToHandleBase) > ABS(OldReservEntry."Qty. to Handle (Base)") THEN
            QtyToHandleBase := OldReservEntry."Qty. to Handle (Base)";

          IF QtyToHandleBase < 0 THEN BEGIN
            OldReservEntry."New Serial No." := OldReservEntry."Serial No.";
            OldReservEntry."New Lot No." := OldReservEntry."Lot No.";
            OldReservEntry."Qty. to Handle (Base)" := QtyToHandleBase;
            OldReservEntry."Qty. to Invoice (Base)" := QtyToHandleBase;

            TransferQty :=
              CreateReservEntry.TransferReservEntry(
                DATABASE::"Item Journal Line",
                ItemJnlLine."Entry Type",ItemJnlLine."Journal Template Name",
                ItemJnlLine."Journal Batch Name",0,ItemJnlLine."Line No.",
                ItemJnlLine."Qty. per Unit of Measure",OldReservEntry,TransferQty);
          END;
        UNTIL (ReservEngineMgt.NEXTRecord(OldReservEntry) = 0) OR (TransferQty = 0);
    END;

    [External]
    PROCEDURE TransferTransferToTransfer@31(VAR OldTransLine@1000 : Record 5741;VAR NewTransLine@1001 : Record 5741;TransferQty@1002 : Decimal;Direction@1003 : 'Outbound,Inbound';VAR TrackingSpecification@1007 : Record 336);
    VAR
      OldReservEntry@1004 : Record 337;
      Status@1005 : 'Reservation,Tracking,Surplus,Prospect';
      TransferLocation@1006 : Code[10];
    BEGIN
      // Used when derived Transfer Lines are created during posting of shipment.
      IF NOT FindReservEntry(OldTransLine,OldReservEntry,Direction) THEN
        EXIT;

      OldReservEntry.SetTrackingFilterFromSpec(TrackingSpecification);
      IF OldReservEntry.ISEMPTY THEN
        EXIT;

      OldReservEntry.Lock;

      CASE Direction OF
        Direction::Outbound:
          BEGIN
            TransferLocation := OldTransLine."Transfer-from Code";
            NewTransLine.TESTFIELD("Transfer-from Code",TransferLocation);
          END;
        Direction::Inbound:
          BEGIN
            TransferLocation := OldTransLine."Transfer-to Code";
            NewTransLine.TESTFIELD("Transfer-to Code",TransferLocation);
          END;
      END;

      NewTransLine.TESTFIELD("Item No.",OldTransLine."Item No.");
      NewTransLine.TESTFIELD("Variant Code",OldTransLine."Variant Code");

      FOR Status := Status::Reservation TO Status::Prospect DO BEGIN
        IF TransferQty = 0 THEN
          EXIT;
        OldReservEntry.SETRANGE("Reservation Status",Status);
        IF OldReservEntry.FINDSET THEN
          REPEAT
            OldReservEntry.TestItemFields(OldTransLine."Item No.",OldTransLine."Variant Code",TransferLocation);

            TransferQty :=
              CreateReservEntry.TransferReservEntry(DATABASE::"Transfer Line",
                Direction,NewTransLine."Document No.",'',NewTransLine."Derived From Line No.",
                NewTransLine."Line No.",NewTransLine."Qty. per Unit of Measure",OldReservEntry,TransferQty);

          UNTIL (OldReservEntry.NEXT = 0) OR (TransferQty = 0);
      END;
    END;

    [External]
    PROCEDURE DeleteLineConfirm@20(VAR TransLine@1000 : Record 5741) : Boolean;
    BEGIN
      WITH TransLine DO BEGIN
        IF NOT ReservEntryExist(TransLine) THEN
          EXIT(TRUE);

        ReservMgt.SetTransferLine(TransLine,0);
        IF ReservMgt.DeleteItemTrackingConfirm THEN
          DeleteItemTracking := TRUE;
      END;

      EXIT(DeleteItemTracking);
    END;

    [External]
    PROCEDURE DeleteLine@2(VAR TransLine@1000 : Record 5741);
    BEGIN
      IF Blocked THEN
        EXIT;

      WITH TransLine DO BEGIN
        ReservMgt.SetTransferLine(TransLine,0);
        IF DeleteItemTracking THEN
          ReservMgt.SetItemTrackingHandling(1); // Allow Deletion
        ReservMgt.DeleteReservEntries(TRUE,0);
        CALCFIELDS("Reserved Qty. Outbnd. (Base)");

        ReservMgt.SetTransferLine(TransLine,1);
        IF DeleteItemTracking THEN
          ReservMgt.SetItemTrackingHandling(1); // Allow Deletion
        ReservMgt.DeleteReservEntries(TRUE,0);
        CALCFIELDS("Reserved Qty. Inbnd. (Base)");
      END;
    END;

    LOCAL PROCEDURE AssignForPlanning@5(VAR TransLine@1000 : Record 5741;Direction@1001 : 'Outbound,Inbound');
    VAR
      PlanningAssignment@1002 : Record 99000850;
    BEGIN
      IF TransLine."Item No." <> '' THEN
        WITH TransLine DO
          CASE Direction OF
            Direction::Outbound:
              PlanningAssignment.ChkAssignOne("Item No.","Variant Code","Transfer-to Code","Shipment Date");
            Direction::Inbound:
              PlanningAssignment.ChkAssignOne("Item No.","Variant Code","Transfer-from Code","Receipt Date");
          END;
    END;

    [External]
    PROCEDURE Block@14(SetBlocked@1000 : Boolean);
    BEGIN
      Blocked := SetBlocked;
    END;

    [External]
    PROCEDURE CallItemTracking@6(VAR TransLine@1000 : Record 5741;Direction@1003 : 'Outbound,Inbound');
    VAR
      TrackingSpecification@1001 : Record 336;
      ItemTrackingLines@1002 : Page 6510;
      AvalabilityDate@1005 : Date;
    BEGIN
      TrackingSpecification.InitFromTransLine(TransLine,AvalabilityDate,Direction);
      ItemTrackingLines.SetSourceSpec(TrackingSpecification,AvalabilityDate);
      ItemTrackingLines.SetInbound(TransLine.IsInbound);
      ItemTrackingLines.RUNMODAL;
      OnAfterCallItemTracking(TransLine);
    END;

    [External]
    PROCEDURE CallItemTracking2@15(VAR TransLine@1000 : Record 5741;Direction@1004 : 'Outbound,Inbound';SecondSourceQuantityArray@1001 : ARRAY [3] OF Decimal);
    VAR
      TrackingSpecification@1002 : Record 336;
      ItemTrackingLines@1003 : Page 6510;
      AvailabilityDate@1005 : Date;
    BEGIN
      TrackingSpecification.InitFromTransLine(TransLine,AvailabilityDate,Direction);
      ItemTrackingLines.SetSourceSpec(TrackingSpecification,AvailabilityDate);
      ItemTrackingLines.SetSecondSourceQuantity(SecondSourceQuantityArray);
      ItemTrackingLines.RUNMODAL;
      OnAfterCallItemTracking(TransLine);
    END;

    [External]
    PROCEDURE UpdateItemTrackingAfterPosting@11(TransHeader@1001 : Record 5740;Direction@1000 : 'Outbound,Inbound');
    VAR
      ReservEntry@1003 : Record 337;
      ReservEntry2@1002 : Record 337;
      CreateReservEntry@1004 : Codeunit 99000830;
    BEGIN
      // Used for updating Quantity to Handle after posting;
      ReservEntry.SetSourceFilter(DATABASE::"Transfer Line",Direction,TransHeader."No.",-1,TRUE);
      ReservEntry.SETRANGE("Source Batch Name",'');
      IF Direction = Direction::Outbound THEN
        ReservEntry.SETRANGE("Source Prod. Order Line",0)
      ELSE
        ReservEntry.SETFILTER("Source Prod. Order Line",'<>%1',0);
      CreateReservEntry.UpdateItemTrackingAfterPosting(ReservEntry);
      IF Direction = Direction::Outbound THEN BEGIN
        ReservEntry2.COPY(ReservEntry);
        ReservEntry2.SETRANGE("Source Subtype",Direction::Inbound);
        ReservEntry2.SetTrackingFilterFromReservEntry(ReservEntry);
        CreateReservEntry.UpdateItemTrackingAfterPosting(ReservEntry2);
      END;
    END;

    [External]
    PROCEDURE RegisterBinContentItemTracking@1203(VAR TransferLine@1003 : Record 5741;VAR TempTrackingSpecification@1200 : TEMPORARY Record 336);
    VAR
      SourceTrackingSpecification@1202 : Record 336;
      ItemTrackingLines@1004 : Page 6510;
      FormRunMode@1201 : ',Reclass,Combined Ship/Rcpt,Drop Shipment,Transfer';
      Direction@1203 : 'Outbound,Inbound';
    BEGIN
      IF NOT TempTrackingSpecification.FINDSET THEN
        EXIT;
      SourceTrackingSpecification.InitFromTransLine(TransferLine,TransferLine."Shipment Date",Direction::Outbound);

      CLEAR(ItemTrackingLines);
      ItemTrackingLines.SetFormRunMode(FormRunMode::Transfer);
      ItemTrackingLines.SetSourceSpec(SourceTrackingSpecification,TransferLine."Shipment Date");
      ItemTrackingLines.RegisterItemTrackingLines(
        SourceTrackingSpecification,TransferLine."Shipment Date",TempTrackingSpecification);
    END;

    LOCAL PROCEDURE GetInboundReservEntryShipmentDate@123() InboundReservEntryShipmentDate : Date;
    BEGIN
      CASE SetFromType OF
        DATABASE::"Sales Line":
          InboundReservEntryShipmentDate := GetInboundReservEntryShipmentDateBySalesLine;
        DATABASE::"Purchase Line":
          InboundReservEntryShipmentDate := GetInboundReservEntryShipmentDateByPurchaseLine;
        DATABASE::"Transfer Line":
          InboundReservEntryShipmentDate := GetInboundReservEntryShipmentDateByTransferLine;
        DATABASE::"Service Line":
          InboundReservEntryShipmentDate := GetInboundReservEntryShipmentDateByServiceLine;
        DATABASE::"Job Planning Line":
          InboundReservEntryShipmentDate := GetInboundReservEntryShipmentDateByJobPlanningLine;
      END;
    END;

    LOCAL PROCEDURE GetInboundReservEntryShipmentDateBySalesLine@130() : Date;
    VAR
      SalesLine@1000 : Record 37;
    BEGIN
      SalesLine.GET(SetFromSubtype,SetFromID,SetFromRefNo);
      EXIT(SalesLine."Shipment Date");
    END;

    LOCAL PROCEDURE GetInboundReservEntryShipmentDateByPurchaseLine@134() : Date;
    VAR
      PurchaseLine@1000 : Record 39;
    BEGIN
      PurchaseLine.GET(SetFromSubtype,SetFromID,SetFromRefNo);
      EXIT(PurchaseLine."Expected Receipt Date");
    END;

    LOCAL PROCEDURE GetInboundReservEntryShipmentDateByTransferLine@141() : Date;
    VAR
      TransferLine@1000 : Record 5741;
    BEGIN
      TransferLine.GET(SetFromID,SetFromRefNo);
      EXIT(TransferLine."Shipment Date");
    END;

    LOCAL PROCEDURE GetInboundReservEntryShipmentDateByServiceLine@140() : Date;
    VAR
      ServiceLine@1000 : Record 5902;
    BEGIN
      ServiceLine.GET(SetFromSubtype,SetFromID,SetFromRefNo);
      EXIT(ServiceLine."Needed by Date");
    END;

    LOCAL PROCEDURE GetInboundReservEntryShipmentDateByJobPlanningLine@171() : Date;
    VAR
      JobPlanningLine@1000 : Record 1003;
    BEGIN
      JobPlanningLine.SETRANGE(Status,SetFromSubtype);
      JobPlanningLine.SETRANGE("Job No.",SetFromID);
      JobPlanningLine.SETRANGE("Job Contract Entry No.",SetFromRefNo);
      JobPlanningLine.FINDFIRST;
      EXIT(JobPlanningLine."Planning Date");
    END;

    LOCAL PROCEDURE AutoTracking@10(OldTransLine@1000 : Record 5741;NewTransLine@1001 : Record 5741;VAR TempReservEntry@1003 : TEMPORARY Record 337;Direction@1002 : Option);
    BEGIN
      IF (NewTransLine."Item No." <> OldTransLine."Item No.") OR FindReservEntry(NewTransLine,TempReservEntry,0) THEN BEGIN
        IF NewTransLine."Item No." <> OldTransLine."Item No." THEN BEGIN
          ReservMgt.SetTransferLine(OldTransLine,Direction);
          ReservMgt.DeleteReservEntries(TRUE,0);
          ReservMgt.SetTransferLine(NewTransLine,Direction);
        END ELSE BEGIN
          ReservMgt.SetTransferLine(NewTransLine,Direction);
          ReservMgt.DeleteReservEntries(TRUE,0);
        END;
        ReservMgt.AutoTrack(NewTransLine."Outstanding Qty. (Base)");
      END;
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCallItemTracking@172(VAR TransferLine@1000 : Record 5741);
    BEGIN
    END;

    BEGIN
    END.
  }
}

