OBJECT Codeunit 99000838 Prod. Order Comp.-Reserve
{
  OBJECT-PROPERTIES
  {
    Date=26-01-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20348;
  }
  PROPERTIES
  {
    Permissions=TableData 337=rimd,
                TableData 99000849=rm;
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Reserveret antal m� ikke v�re st�rre end %1.;ENU=Reserved quantity cannot be greater than %1';
      Text002@1001 : TextConst 'DAN=skal udfyldes, n�r et antal er reserveret;ENU=must be filled in when a quantity is reserved';
      Text003@1002 : TextConst 'DAN=m� ikke �ndres, n�r et antal er reserveret;ENU=must not be changed when a quantity is reserved';
      Text004@1003 : TextConst 'DAN=Codeunit er ikke initialiseret korrekt.;ENU=Codeunit is not initialized correctly.';
      CreateReservEntry@1005 : Codeunit 99000830;
      ReservEngineMgt@1006 : Codeunit 99000831;
      ReservMgt@1007 : Codeunit 99000845;
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
      DeleteItemTracking@1017 : Boolean;

    [External]
    PROCEDURE CreateReservation@1(ProdOrderComp@1000 : Record 5407;Description@1001 : Text[50];ExpectedReceiptDate@1002 : Date;Quantity@1006 : Decimal;QuantityBase@1003 : Decimal;ForSerialNo@1005 : Code[20];ForLotNo@1004 : Code[20]);
    VAR
      ShipmentDate@1007 : Date;
    BEGIN
      IF SetFromType = 0 THEN
        ERROR(Text004);

      ProdOrderComp.TESTFIELD("Item No.");
      ProdOrderComp.TESTFIELD("Due Date");
      ProdOrderComp.CALCFIELDS("Reserved Qty. (Base)");
      IF ABS(ProdOrderComp."Remaining Qty. (Base)") < ABS(ProdOrderComp."Reserved Qty. (Base)") + QuantityBase THEN
        ERROR(
          Text000,
          ABS(ProdOrderComp."Remaining Qty. (Base)") - ABS(ProdOrderComp."Reserved Qty. (Base)"));

      ProdOrderComp.TESTFIELD("Location Code",SetFromLocationCode);
      ProdOrderComp.TESTFIELD("Variant Code",SetFromVariantCode);
      IF QuantityBase > 0 THEN
        ShipmentDate := ProdOrderComp."Due Date"
      ELSE BEGIN
        ShipmentDate := ExpectedReceiptDate;
        ExpectedReceiptDate := ProdOrderComp."Due Date";
      END;

      CreateReservEntry.CreateReservEntryFor(
        DATABASE::"Prod. Order Component",ProdOrderComp.Status,
        ProdOrderComp."Prod. Order No.",'',ProdOrderComp."Prod. Order Line No.",
        ProdOrderComp."Line No.",ProdOrderComp."Qty. per Unit of Measure",
        Quantity,QuantityBase,ForSerialNo,ForLotNo);
      CreateReservEntry.CreateReservEntryFrom(
        SetFromType,SetFromSubtype,SetFromID,SetFromBatchName,SetFromProdOrderLine,SetFromRefNo,
        SetFromQtyPerUOM,SetFromSerialNo,SetFromLotNo);
      CreateReservEntry.CreateReservEntry(
        ProdOrderComp."Item No.",ProdOrderComp."Variant Code",ProdOrderComp."Location Code",
        Description,ExpectedReceiptDate,ShipmentDate);

      SetFromType := 0;
    END;

    LOCAL PROCEDURE CreateBindingReservation@19(ProdOrderComp@1000 : Record 5407;Description@1001 : Text[50];ExpectedReceiptDate@1002 : Date;Quantity@1006 : Decimal;QuantityBase@1003 : Decimal);
    BEGIN
      CreateReservation(ProdOrderComp,Description,ExpectedReceiptDate,Quantity,QuantityBase,'','');
    END;

    [External]
    PROCEDURE CreateReservationSetFrom@2(TrackingSpecificationFrom@1000 : Record 336);
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
    PROCEDURE SetBinding@9(Binding@1000 : ' ,Order-to-Order');
    BEGIN
      CreateReservEntry.SetBinding(Binding);
    END;

    [External]
    PROCEDURE FilterReservFor@12(VAR FilterReservEntry@1000 : Record 337;ProdOrderComp@1001 : Record 5407);
    BEGIN
      FilterReservEntry.SetSourceFilter(
        DATABASE::"Prod. Order Component",ProdOrderComp.Status,ProdOrderComp."Prod. Order No.",ProdOrderComp."Line No.",FALSE);
      FilterReservEntry.SetSourceFilter2('',ProdOrderComp."Prod. Order Line No.");
    END;

    [External]
    PROCEDURE Caption@30(ProdOrderComp@1001 : Record 5407) CaptionText@1000 : Text[80];
    VAR
      ProdOrderLine@1002 : Record 5406;
    BEGIN
      ProdOrderLine.GET(
        ProdOrderComp.Status,
        ProdOrderComp."Prod. Order No.",ProdOrderComp."Prod. Order Line No.");
      CaptionText :=
        COPYSTR(
          STRSUBSTNO('%1 %2 %3 %4 %5',
            ProdOrderComp.Status,ProdOrderComp.TABLECAPTION,
            ProdOrderComp."Prod. Order No.",ProdOrderComp."Item No.",ProdOrderLine."Item No.")
          ,1,MAXSTRLEN(CaptionText));
    END;

    [External]
    PROCEDURE FindReservEntry@5(ProdOrderComp@1000 : Record 5407;VAR ReservEntry@1001 : Record 337) : Boolean;
    BEGIN
      ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry,FALSE);
      FilterReservFor(ReservEntry,ProdOrderComp);
      EXIT(ReservEntry.FINDLAST);
    END;

    LOCAL PROCEDURE ReservEntryExist@11(ProdOrderComp@1000 : Record 5407) : Boolean;
    VAR
      ReservEntry@1001 : Record 337;
    BEGIN
      ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry,FALSE);
      FilterReservFor(ReservEntry,ProdOrderComp);
      EXIT(NOT ReservEntry.ISEMPTY);
    END;

    [External]
    PROCEDURE VerifyChange@59(VAR NewProdOrderComp@1000 : Record 5407;VAR OldProdOrderComp@1001 : Record 5407);
    VAR
      ProdOrderComp@1005 : Record 5407;
      TempReservEntry@1002 : Record 337;
      ShowError@1003 : Boolean;
      HasError@1004 : Boolean;
    BEGIN
      IF NewProdOrderComp.Status = NewProdOrderComp.Status::Finished THEN
        EXIT;
      IF Blocked THEN
        EXIT;
      IF NewProdOrderComp."Line No." = 0 THEN
        IF NOT ProdOrderComp.GET(
             NewProdOrderComp.Status,
             NewProdOrderComp."Prod. Order No.",
             NewProdOrderComp."Prod. Order Line No.",
             NewProdOrderComp."Line No.")
        THEN
          EXIT;

      NewProdOrderComp.CALCFIELDS("Reserved Qty. (Base)");
      ShowError := NewProdOrderComp."Reserved Qty. (Base)" <> 0;

      IF NewProdOrderComp."Due Date" = 0D THEN
        IF ShowError THEN
          NewProdOrderComp.FIELDERROR("Due Date",Text002)
        ELSE
          HasError := TRUE;

      IF NewProdOrderComp."Item No." <> OldProdOrderComp."Item No." THEN
        IF ShowError THEN
          NewProdOrderComp.FIELDERROR("Item No.",Text003)
        ELSE
          HasError := TRUE;
      IF NewProdOrderComp."Location Code" <> OldProdOrderComp."Location Code" THEN
        IF ShowError THEN
          NewProdOrderComp.FIELDERROR("Location Code",Text003)
        ELSE
          HasError := TRUE;
      IF (NewProdOrderComp."Bin Code" <> OldProdOrderComp."Bin Code") AND
         (NOT ReservMgt.CalcIsAvailTrackedQtyInBin(
            NewProdOrderComp."Item No.",NewProdOrderComp."Bin Code",
            NewProdOrderComp."Location Code",NewProdOrderComp."Variant Code",
            DATABASE::"Prod. Order Component",NewProdOrderComp.Status,
            NewProdOrderComp."Prod. Order No.",'',NewProdOrderComp."Prod. Order Line No.",
            NewProdOrderComp."Line No."))
      THEN BEGIN
        IF ShowError THEN
          NewProdOrderComp.FIELDERROR("Bin Code",Text003);
        HasError := TRUE;
      END;
      IF NewProdOrderComp."Variant Code" <> OldProdOrderComp."Variant Code" THEN
        IF ShowError THEN
          NewProdOrderComp.FIELDERROR("Variant Code",Text003)
        ELSE
          HasError := TRUE;
      IF NewProdOrderComp."Line No." <> OldProdOrderComp."Line No." THEN
        HasError := TRUE;

      IF HasError THEN
        IF (NewProdOrderComp."Item No." <> OldProdOrderComp."Item No.") OR
           FindReservEntry(NewProdOrderComp,TempReservEntry)
        THEN BEGIN
          IF NewProdOrderComp."Item No." <> OldProdOrderComp."Item No." THEN BEGIN
            ReservMgt.SetProdOrderComponent(OldProdOrderComp);
            ReservMgt.DeleteReservEntries(TRUE,0);
            ReservMgt.SetProdOrderComponent(NewProdOrderComp);
          END ELSE BEGIN
            ReservMgt.SetProdOrderComponent(NewProdOrderComp);
            ReservMgt.DeleteReservEntries(TRUE,0);
          END;
          ReservMgt.AutoTrack(NewProdOrderComp."Remaining Qty. (Base)");
        END;

      IF HasError OR (NewProdOrderComp."Due Date" <> OldProdOrderComp."Due Date")
      THEN BEGIN
        AssignForPlanning(NewProdOrderComp);
        IF (NewProdOrderComp."Item No." <> OldProdOrderComp."Item No.") OR
           (NewProdOrderComp."Variant Code" <> OldProdOrderComp."Variant Code") OR
           (NewProdOrderComp."Location Code" <> OldProdOrderComp."Location Code")
        THEN
          AssignForPlanning(OldProdOrderComp);
      END;
    END;

    [External]
    PROCEDURE VerifyQuantity@4(VAR NewProdOrderComp@1000 : Record 5407;VAR OldProdOrderComp@1001 : Record 5407);
    VAR
      ProdOrderComp@1002 : Record 5407;
    BEGIN
      IF Blocked THEN
        EXIT;

      WITH NewProdOrderComp DO BEGIN
        IF Status = Status::Finished THEN
          EXIT;
        IF "Line No." = OldProdOrderComp."Line No." THEN
          IF "Remaining Qty. (Base)" = OldProdOrderComp."Remaining Qty. (Base)" THEN
            EXIT;
        IF "Line No." = 0 THEN
          IF NOT ProdOrderComp.GET(Status,"Prod. Order No.","Prod. Order Line No.","Line No.") THEN
            EXIT;
        ReservMgt.SetProdOrderComponent(NewProdOrderComp);
        IF "Qty. per Unit of Measure" <> OldProdOrderComp."Qty. per Unit of Measure" THEN
          ReservMgt.ModifyUnitOfMeasure;
        IF "Remaining Qty. (Base)" * OldProdOrderComp."Remaining Qty. (Base)" < 0 THEN
          ReservMgt.DeleteReservEntries(TRUE,0)
        ELSE
          ReservMgt.DeleteReservEntries(FALSE,"Remaining Qty. (Base)");
        ReservMgt.ClearSurplus;
        ReservMgt.AutoTrack("Remaining Qty. (Base)");
        AssignForPlanning(NewProdOrderComp);
      END;
    END;

    [External]
    PROCEDURE TransferPOCompToPOComp@31(VAR OldProdOrderComp@1000 : Record 5407;VAR NewProdOrderComp@1001 : Record 5407;TransferQty@1002 : Decimal;TransferAll@1003 : Boolean);
    VAR
      OldReservEntry@1004 : Record 337;
    BEGIN
      IF NOT FindReservEntry(OldProdOrderComp,OldReservEntry) THEN
        EXIT;

      OldReservEntry.Lock;

      NewProdOrderComp.TestItemFields(OldProdOrderComp."Item No.",OldProdOrderComp."Variant Code",OldProdOrderComp."Location Code");

      OldReservEntry.TransferReservations(
        OldReservEntry,OldProdOrderComp."Item No.",OldProdOrderComp."Variant Code",OldProdOrderComp."Location Code",
        TransferAll,TransferQty,NewProdOrderComp."Qty. per Unit of Measure",
        DATABASE::"Prod. Order Component",NewProdOrderComp.Status,NewProdOrderComp."Prod. Order No.",'',
        NewProdOrderComp."Prod. Order Line No.",NewProdOrderComp."Line No.");
    END;

    [External]
    PROCEDURE TransferPOCompToItemJnlLine@3(VAR OldProdOrderComp@1000 : Record 5407;VAR NewItemJnlLine@1001 : Record 83;TransferQty@1002 : Decimal);
    VAR
      OldReservEntry@1003 : Record 337;
      ItemTrackingFilterIsSet@1006 : Boolean;
      EndLoop@1005 : Boolean;
      TrackedQty@1004 : Decimal;
      UnTrackedQty@1008 : Decimal;
      xTransferQty@1007 : Decimal;
    BEGIN
      IF NOT FindReservEntry(OldProdOrderComp,OldReservEntry) THEN
        EXIT;

      // Store initial values
      OldReservEntry.CALCSUMS("Quantity (Base)");
      TrackedQty := -OldReservEntry."Quantity (Base)";
      xTransferQty := TransferQty;

      OldReservEntry.Lock;

      // Handle Item Tracking on consumption:
      CLEAR(CreateReservEntry);
      IF NewItemJnlLine."Entry Type" = NewItemJnlLine."Entry Type"::Consumption THEN
        IF NewItemJnlLine.TrackingExists THEN BEGIN
          CreateReservEntry.SetNewSerialLotNo(NewItemJnlLine."Serial No.",NewItemJnlLine."Lot No.");
          // Try to match against Item Tracking on the prod. order line:
          OldReservEntry.SetTrackingFilterFromItemJnlLine(NewItemJnlLine);
          IF OldReservEntry.ISEMPTY THEN
            OldReservEntry.ClearTrackingFilter
          ELSE
            ItemTrackingFilterIsSet := TRUE;
        END;

      NewItemJnlLine.TestItemFields(OldProdOrderComp."Item No.",OldProdOrderComp."Variant Code",OldProdOrderComp."Location Code");

      IF TransferQty = 0 THEN
        EXIT;

      IF ReservEngineMgt.InitRecordSet2(OldReservEntry,NewItemJnlLine."Serial No.",NewItemJnlLine."Lot No.") THEN
        REPEAT
          OldReservEntry.TestItemFields(OldProdOrderComp."Item No.",OldProdOrderComp."Variant Code",OldProdOrderComp."Location Code");

          TransferQty := CreateReservEntry.TransferReservEntry(DATABASE::"Item Journal Line",
              NewItemJnlLine."Entry Type",NewItemJnlLine."Journal Template Name",NewItemJnlLine."Journal Batch Name",0,
              NewItemJnlLine."Line No.",NewItemJnlLine."Qty. per Unit of Measure",OldReservEntry,TransferQty);

          EndLoop := TransferQty = 0;
          IF NOT EndLoop THEN
            IF ReservEngineMgt.NEXTRecord(OldReservEntry) = 0 THEN
              IF ItemTrackingFilterIsSet THEN BEGIN
                OldReservEntry.SETRANGE("Serial No.");
                OldReservEntry.SETRANGE("Lot No.");
                ItemTrackingFilterIsSet := FALSE;
                EndLoop := NOT ReservEngineMgt.InitRecordSet(OldReservEntry);
              END ELSE
                EndLoop := TRUE;
        UNTIL EndLoop;

      // Handle remaining transfer quantity
      IF TransferQty <> 0 THEN BEGIN
        TrackedQty -= (xTransferQty - TransferQty);
        UnTrackedQty := OldProdOrderComp."Remaining Qty. (Base)" - TrackedQty;
        IF TransferQty > UnTrackedQty THEN BEGIN
          ReservMgt.SetProdOrderComponent(OldProdOrderComp);
          ReservMgt.DeleteReservEntries(FALSE,OldProdOrderComp."Remaining Qty. (Base)");
        END;
      END;
    END;

    [External]
    PROCEDURE DeleteLineConfirm@20(VAR ProdOrderComp@1000 : Record 5407) : Boolean;
    BEGIN
      WITH ProdOrderComp DO BEGIN
        IF NOT ReservEntryExist(ProdOrderComp) THEN
          EXIT(TRUE);

        ReservMgt.SetProdOrderComponent(ProdOrderComp);
        IF ReservMgt.DeleteItemTrackingConfirm THEN
          DeleteItemTracking := TRUE;
      END;

      EXIT(DeleteItemTracking);
    END;

    [External]
    PROCEDURE DeleteLine@6(VAR ProdOrderComp@1000 : Record 5407);
    BEGIN
      IF Blocked THEN
        EXIT;

      WITH ProdOrderComp DO BEGIN
        CLEAR(ReservMgt);
        ReservMgt.SetProdOrderComponent(ProdOrderComp);
        IF DeleteItemTracking THEN
          ReservMgt.SetItemTrackingHandling(1); // Allow Deletion
        ReservMgt.DeleteReservEntries(TRUE,0);
        CALCFIELDS("Reserved Qty. (Base)");
        AssignForPlanning(ProdOrderComp);
      END;
    END;

    LOCAL PROCEDURE AssignForPlanning@7(VAR ProdOrderComp@1000 : Record 5407);
    VAR
      PlanningAssignment@1001 : Record 99000850;
    BEGIN
      WITH ProdOrderComp DO BEGIN
        IF Status = Status::Simulated THEN
          EXIT;
        IF "Item No." <> '' THEN
          PlanningAssignment.ChkAssignOne("Item No.","Variant Code","Location Code","Due Date");
      END;
    END;

    [External]
    PROCEDURE Block@8(SetBlocked@1000 : Boolean);
    BEGIN
      Blocked := SetBlocked;
    END;

    [External]
    PROCEDURE CallItemTracking@14(VAR ProdOrderComp@1000 : Record 5407);
    VAR
      TrackingSpecification@1001 : Record 336;
      ItemTrackingDocMgt@1003 : Codeunit 6503;
      ItemTrackingLines@1002 : Page 6510;
    BEGIN
      IF ProdOrderComp.Status = ProdOrderComp.Status::Finished THEN
        ItemTrackingDocMgt.ShowItemTrackingForProdOrderComp(DATABASE::"Prod. Order Component",
          ProdOrderComp."Prod. Order No.",ProdOrderComp."Prod. Order Line No.",ProdOrderComp."Line No.")
      ELSE BEGIN
        ProdOrderComp.TESTFIELD("Item No.");
        TrackingSpecification.InitFromProdOrderComp(ProdOrderComp);
        ItemTrackingLines.SetSourceSpec(TrackingSpecification,ProdOrderComp."Due Date");
        ItemTrackingLines.SetInbound(ProdOrderComp.IsInbound);
        ItemTrackingLines.RUNMODAL;
      END;
    END;

    [External]
    PROCEDURE UpdateItemTrackingAfterPosting@15(ProdOrderComponent@1000 : Record 5407);
    VAR
      ReservEntry@1001 : Record 337;
      CreateReservEntry@1002 : Codeunit 99000830;
    BEGIN
      // Used for updating Quantity to Handle after posting;
      ReservEntry.SetSourceFilter(
        DATABASE::"Prod. Order Component",ProdOrderComponent.Status,ProdOrderComponent."Prod. Order No.",
        ProdOrderComponent."Line No.",TRUE);
      ReservEntry.SetSourceFilter2('',ProdOrderComponent."Prod. Order Line No.");
      CreateReservEntry.UpdateItemTrackingAfterPosting(ReservEntry);
    END;

    [External]
    PROCEDURE BindToPurchase@10(ProdOrderComp@1000 : Record 5407;PurchLine@1001 : Record 39;ReservQty@1002 : Decimal;ReservQtyBase@1003 : Decimal);
    VAR
      TrackingSpecification@1004 : Record 336;
      ReservationEntry@1005 : Record 337;
    BEGIN
      SetBinding(ReservationEntry.Binding::"Order-to-Order");
      TrackingSpecification.InitTrackingSpecification2(
        DATABASE::"Purchase Line",PurchLine."Document Type",PurchLine."Document No.",'',0,PurchLine."Line No.",
        PurchLine."Variant Code",PurchLine."Location Code",PurchLine."Qty. per Unit of Measure");
      CreateReservationSetFrom(TrackingSpecification);
      CreateBindingReservation(ProdOrderComp,PurchLine.Description,PurchLine."Expected Receipt Date",ReservQty,ReservQtyBase);
    END;

    [External]
    PROCEDURE BindToProdOrder@13(ProdOrderComp@1003 : Record 5407;ProdOrderLine@1002 : Record 5406;ReservQty@1001 : Decimal;ReservQtyBase@1000 : Decimal);
    VAR
      TrackingSpecification@1005 : Record 336;
      ReservationEntry@1004 : Record 337;
    BEGIN
      SetBinding(ReservationEntry.Binding::"Order-to-Order");
      TrackingSpecification.InitTrackingSpecification2(
        DATABASE::"Prod. Order Line",ProdOrderLine.Status,ProdOrderLine."Prod. Order No.",'',ProdOrderLine."Line No.",0,
        ProdOrderLine."Variant Code",ProdOrderLine."Location Code",ProdOrderLine."Qty. per Unit of Measure");
      CreateReservationSetFrom(TrackingSpecification);
      CreateBindingReservation(ProdOrderComp,ProdOrderLine.Description,ProdOrderLine."Ending Date",ReservQty,ReservQtyBase);
    END;

    [External]
    PROCEDURE BindToRequisition@16(ProdOrderComp@1003 : Record 5407;ReqLine@1002 : Record 246;ReservQty@1001 : Decimal;ReservQtyBase@1000 : Decimal);
    VAR
      TrackingSpecification@1005 : Record 336;
      ReservationEntry@1004 : Record 337;
    BEGIN
      SetBinding(ReservationEntry.Binding::"Order-to-Order");
      TrackingSpecification.InitTrackingSpecification2(
        DATABASE::"Requisition Line",
        0,ReqLine."Worksheet Template Name",ReqLine."Journal Batch Name",0,ReqLine."Line No.",
        ReqLine."Variant Code",ReqLine."Location Code",ReqLine."Qty. per Unit of Measure");
      CreateReservationSetFrom(TrackingSpecification);
      CreateBindingReservation(ProdOrderComp,ReqLine.Description,ReqLine."Due Date",ReservQty,ReservQtyBase);
    END;

    [External]
    PROCEDURE BindToAssembly@17(ProdOrderComp@1003 : Record 5407;AsmHeader@1002 : Record 900;ReservQty@1001 : Decimal;ReservQtyBase@1000 : Decimal);
    VAR
      TrackingSpecification@1005 : Record 336;
      ReservationEntry@1004 : Record 337;
    BEGIN
      SetBinding(ReservationEntry.Binding::"Order-to-Order");
      TrackingSpecification.InitTrackingSpecification2(
        DATABASE::"Assembly Header",AsmHeader."Document Type",AsmHeader."No.",'',0,0,
        AsmHeader."Variant Code",AsmHeader."Location Code",AsmHeader."Qty. per Unit of Measure");
      CreateReservationSetFrom(TrackingSpecification);
      CreateBindingReservation(ProdOrderComp,AsmHeader.Description,AsmHeader."Due Date",ReservQty,ReservQtyBase);
    END;

    [External]
    PROCEDURE BindToTransfer@18(ProdOrderComp@1003 : Record 5407;TransLine@1002 : Record 5741;ReservQty@1001 : Decimal;ReservQtyBase@1000 : Decimal);
    VAR
      TrackingSpecification@1005 : Record 336;
      ReservationEntry@1004 : Record 337;
    BEGIN
      SetBinding(ReservationEntry.Binding::"Order-to-Order");
      TrackingSpecification.InitTrackingSpecification2(
        DATABASE::"Transfer Line",1,TransLine."Document No.",'',0,TransLine."Line No.",
        TransLine."Variant Code",TransLine."Transfer-to Code",TransLine."Qty. per Unit of Measure");
      CreateReservationSetFrom(TrackingSpecification);
      CreateBindingReservation(ProdOrderComp,TransLine.Description,TransLine."Receipt Date",ReservQty,ReservQtyBase);
    END;

    BEGIN
    END.
  }
}

