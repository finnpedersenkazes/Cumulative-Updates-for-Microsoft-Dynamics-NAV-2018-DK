OBJECT Codeunit 99000834 Purch. Line-Reserve
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    Permissions=TableData 337=rimd;
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Reserveret antal m� ikke v�re st�rre end %1.;ENU=Reserved quantity cannot be greater than %1';
      Text001@1001 : TextConst 'DAN=skal udfyldes, n�r et antal er reserveret;ENU=must be filled in when a quantity is reserved';
      Text002@1002 : TextConst 'DAN=m� ikke udfyldes, n�r et antal er reserveret;ENU=must not be filled in when a quantity is reserved';
      Text003@1003 : TextConst 'DAN=m� ikke �ndres, n�r et antal er reserveret;ENU=must not be changed when a quantity is reserved';
      Text004@1004 : TextConst 'DAN=Codeunit er ikke initialiseret korrekt.;ENU=Codeunit is not initialized correctly.';
      CreateReservEntry@1006 : Codeunit 99000830;
      ReservEngineMgt@1007 : Codeunit 99000831;
      ReservMgt@1008 : Codeunit 99000845;
      ItemTrackingMgt@1022 : Codeunit 6500;
      Blocked@1009 : Boolean;
      SetFromType@1010 : ' ,Sales,Requisition Line,Purchase,Item Journal,BOM Journal,Item Ledger Entry,Service,Job';
      SetFromSubtype@1011 : Integer;
      SetFromID@1012 : Code[20];
      SetFromBatchName@1013 : Code[10];
      SetFromProdOrderLine@1014 : Integer;
      SetFromRefNo@1015 : Integer;
      SetFromVariantCode@1016 : Code[10];
      SetFromLocationCode@1017 : Code[10];
      SetFromSerialNo@1019 : Code[20];
      SetFromLotNo@1020 : Code[20];
      SetFromQtyPerUOM@1021 : Decimal;
      ApplySpecificItemTracking@1023 : Boolean;
      OverruleItemTracking@1024 : Boolean;
      DeleteItemTracking@1018 : Boolean;

    [External]
    PROCEDURE CreateReservation@3(VAR PurchLine@1000 : Record 39;Description@1001 : Text[50];ExpectedReceiptDate@1002 : Date;Quantity@1006 : Decimal;QuantityBase@1003 : Decimal;ForSerialNo@1005 : Code[20];ForLotNo@1004 : Code[20]);
    VAR
      ShipmentDate@1007 : Date;
      SignFactor@1008 : Integer;
    BEGIN
      IF SetFromType = 0 THEN
        ERROR(Text004);

      PurchLine.TESTFIELD(Type,PurchLine.Type::Item);
      PurchLine.TESTFIELD("No.");
      PurchLine.TESTFIELD("Expected Receipt Date");
      PurchLine.CALCFIELDS("Reserved Qty. (Base)");
      IF ABS(PurchLine."Outstanding Qty. (Base)") < ABS(PurchLine."Reserved Qty. (Base)") + QuantityBase THEN
        ERROR(
          Text000,
          ABS(PurchLine."Outstanding Qty. (Base)") - ABS(PurchLine."Reserved Qty. (Base)"));

      PurchLine.TESTFIELD("Variant Code",SetFromVariantCode);
      PurchLine.TESTFIELD("Location Code",SetFromLocationCode);

      IF PurchLine."Document Type" = PurchLine."Document Type"::"Return Order" THEN
        SignFactor := -1
      ELSE
        SignFactor := 1;

      IF QuantityBase * SignFactor < 0 THEN
        ShipmentDate := PurchLine."Expected Receipt Date"
      ELSE BEGIN
        ShipmentDate := ExpectedReceiptDate;
        ExpectedReceiptDate := PurchLine."Expected Receipt Date";
      END;

      IF PurchLine."Planning Flexibility" <> PurchLine."Planning Flexibility"::Unlimited THEN
        CreateReservEntry.SetPlanningFlexibility(PurchLine."Planning Flexibility");

      CreateReservEntry.CreateReservEntryFor(
        DATABASE::"Purchase Line",PurchLine."Document Type",
        PurchLine."Document No.",'',0,PurchLine."Line No.",PurchLine."Qty. per Unit of Measure",
        Quantity,QuantityBase,ForSerialNo,ForLotNo);
      CreateReservEntry.CreateReservEntryFrom(
        SetFromType,SetFromSubtype,SetFromID,SetFromBatchName,SetFromProdOrderLine,SetFromRefNo,
        SetFromQtyPerUOM,SetFromSerialNo,SetFromLotNo);
      CreateReservEntry.CreateReservEntry(
        PurchLine."No.",PurchLine."Variant Code",PurchLine."Location Code",
        Description,ExpectedReceiptDate,ShipmentDate);

      SetFromType := 0;
    END;

    [External]
    PROCEDURE CreateReservationSetFrom@8(TrackingSpecificationFrom@1000 : Record 336);
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
    PROCEDURE FilterReservFor@10(VAR FilterReservEntry@1000 : Record 337;PurchLine@1001 : Record 39);
    BEGIN
      FilterReservEntry.SetSourceFilter(
        DATABASE::"Purchase Line",PurchLine."Document Type",PurchLine."Document No.",PurchLine."Line No.",FALSE);
      FilterReservEntry.SetSourceFilter2('',0);
    END;

    [External]
    PROCEDURE ReservQuantity@24(PurchLine@1001 : Record 39) QtyToReserve@1000 : Decimal;
    BEGIN
      CASE PurchLine."Document Type" OF
        PurchLine."Document Type"::Quote,
        PurchLine."Document Type"::Order,
        PurchLine."Document Type"::Invoice,
        PurchLine."Document Type"::"Blanket Order":
          QtyToReserve := -PurchLine."Outstanding Qty. (Base)";
        PurchLine."Document Type"::"Return Order",
        PurchLine."Document Type"::"Credit Memo":
          QtyToReserve := PurchLine."Outstanding Qty. (Base)";
      END;
    END;

    [External]
    PROCEDURE Caption@28(PurchLine@1001 : Record 39) CaptionText@1000 : Text[80];
    BEGIN
      CaptionText :=
        STRSUBSTNO('%1 %2 %3',PurchLine."Document Type",PurchLine."Document No.",PurchLine."No.");
    END;

    [External]
    PROCEDURE FindReservEntry@4(PurchLine@1000 : Record 39;VAR ReservEntry@1001 : Record 337) : Boolean;
    BEGIN
      ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry,FALSE);
      FilterReservFor(ReservEntry,PurchLine);
      EXIT(ReservEntry.FINDLAST);
    END;

    PROCEDURE ReservEntryExist@21(PurchLine@1000 : Record 39) : Boolean;
    VAR
      ReservEntry@1001 : Record 337;
    BEGIN
      ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry,FALSE);
      FilterReservFor(ReservEntry,PurchLine);
      EXIT(NOT ReservEntry.ISEMPTY);
    END;

    [External]
    PROCEDURE VerifyChange@61(VAR NewPurchLine@1000 : Record 39;VAR OldPurchLine@1001 : Record 39);
    VAR
      PurchLine@1005 : Record 39;
      TempReservEntry@1002 : Record 337;
      ShowError@1003 : Boolean;
      HasError@1004 : Boolean;
    BEGIN
      IF (NewPurchLine.Type <> NewPurchLine.Type::Item) AND (OldPurchLine.Type <> OldPurchLine.Type::Item) THEN
        EXIT;
      IF Blocked THEN
        EXIT;
      IF NewPurchLine."Line No." = 0 THEN
        IF NOT PurchLine.GET(
             NewPurchLine."Document Type",
             NewPurchLine."Document No.",
             NewPurchLine."Line No.")
        THEN
          EXIT;

      NewPurchLine.CALCFIELDS("Reserved Qty. (Base)");
      ShowError := NewPurchLine."Reserved Qty. (Base)" <> 0;

      IF (NewPurchLine."Expected Receipt Date" = 0D) AND (OldPurchLine."Expected Receipt Date" <> 0D) THEN
        IF ShowError THEN
          NewPurchLine.FIELDERROR("Expected Receipt Date",Text001)
        ELSE
          HasError := TRUE;

      IF NewPurchLine."Sales Order No." <> '' THEN
        IF ShowError THEN
          NewPurchLine.FIELDERROR("Sales Order No.",Text002)
        ELSE
          HasError := NewPurchLine."Sales Order No." <> OldPurchLine."Sales Order No.";

      IF NewPurchLine."Sales Order Line No." <> 0 THEN
        IF ShowError THEN
          NewPurchLine.FIELDERROR(
            "Sales Order Line No.",Text002)
        ELSE
          HasError := NewPurchLine."Sales Order Line No." <> OldPurchLine."Sales Order Line No.";

      IF NewPurchLine."Drop Shipment" <> OldPurchLine."Drop Shipment" THEN
        IF ShowError AND NewPurchLine."Drop Shipment" THEN
          NewPurchLine.FIELDERROR("Drop Shipment",Text002)
        ELSE
          HasError := TRUE;

      IF NewPurchLine."No." <> OldPurchLine."No." THEN
        IF ShowError THEN
          NewPurchLine.FIELDERROR("No.",Text003)
        ELSE
          HasError := TRUE;
      IF NewPurchLine."Variant Code" <> OldPurchLine."Variant Code" THEN
        IF ShowError THEN
          NewPurchLine.FIELDERROR("Variant Code",Text003)
        ELSE
          HasError := TRUE;
      IF NewPurchLine."Location Code" <> OldPurchLine."Location Code" THEN
        IF ShowError THEN
          NewPurchLine.FIELDERROR("Location Code",Text003)
        ELSE
          HasError := TRUE;
      VerifyPurchLine(NewPurchLine,OldPurchLine,HasError);

      IF HasError THEN
        IF (NewPurchLine."No." <> OldPurchLine."No.") OR
           FindReservEntry(NewPurchLine,TempReservEntry)
        THEN BEGIN
          IF (NewPurchLine."No." <> OldPurchLine."No.") OR (NewPurchLine.Type <> OldPurchLine.Type) THEN BEGIN
            ReservMgt.SetPurchLine(OldPurchLine);
            ReservMgt.DeleteReservEntries(TRUE,0);
            ReservMgt.SetPurchLine(NewPurchLine);
          END ELSE BEGIN
            ReservMgt.SetPurchLine(NewPurchLine);
            ReservMgt.DeleteReservEntries(TRUE,0);
          END;
          ReservMgt.AutoTrack(NewPurchLine."Outstanding Qty. (Base)");
        END;

      IF HasError OR (NewPurchLine."Expected Receipt Date" <> OldPurchLine."Expected Receipt Date")
      THEN BEGIN
        AssignForPlanning(NewPurchLine);
        IF (NewPurchLine."No." <> OldPurchLine."No.") OR
           (NewPurchLine."Variant Code" <> OldPurchLine."Variant Code") OR
           (NewPurchLine."Location Code" <> OldPurchLine."Location Code")
        THEN
          AssignForPlanning(OldPurchLine);
      END;
    END;

    [External]
    PROCEDURE VerifyQuantity@1(VAR NewPurchLine@1000 : Record 39;VAR OldPurchLine@1001 : Record 39);
    VAR
      PurchLine@1002 : Record 39;
    BEGIN
      IF Blocked THEN
        EXIT;

      WITH NewPurchLine DO BEGIN
        IF Type <> Type::Item THEN
          EXIT;
        IF "Document Type" = OldPurchLine."Document Type" THEN
          IF "Line No." = OldPurchLine."Line No." THEN
            IF "Quantity (Base)" = OldPurchLine."Quantity (Base)" THEN
              EXIT;
        IF "Line No." = 0 THEN
          IF NOT PurchLine.GET("Document Type","Document No.","Line No.") THEN
            EXIT;
        ReservMgt.SetPurchLine(NewPurchLine);
        IF "Qty. per Unit of Measure" <> OldPurchLine."Qty. per Unit of Measure" THEN
          ReservMgt.ModifyUnitOfMeasure;
        IF "Outstanding Qty. (Base)" * OldPurchLine."Outstanding Qty. (Base)" < 0 THEN
          ReservMgt.DeleteReservEntries(TRUE,0)
        ELSE
          ReservMgt.DeleteReservEntries(FALSE,"Outstanding Qty. (Base)");
        ReservMgt.ClearSurplus;
        ReservMgt.AutoTrack("Outstanding Qty. (Base)");
        AssignForPlanning(NewPurchLine);
      END;
    END;

    [External]
    PROCEDURE UpdatePlanningFlexibility@7(VAR PurchLine@1000 : Record 39);
    VAR
      ReservEntry@1001 : Record 337;
    BEGIN
      IF FindReservEntry(PurchLine,ReservEntry) THEN
        ReservEntry.MODIFYALL("Planning Flexibility",PurchLine."Planning Flexibility");
    END;

    [External]
    PROCEDURE TransferPurchLineToItemJnlLine@32(VAR PurchLine@1000 : Record 39;VAR ItemJnlLine@1001 : Record 83;TransferQty@1002 : Decimal;VAR CheckApplToItemEntry@1004 : Boolean) : Decimal;
    VAR
      OldReservEntry@1003 : Record 337;
    BEGIN
      IF NOT FindReservEntry(PurchLine,OldReservEntry) THEN
        EXIT(TransferQty);

      OldReservEntry.Lock;
      // Handle Item Tracking on drop shipment:
      CLEAR(CreateReservEntry);
      IF ApplySpecificItemTracking AND (ItemJnlLine."Applies-to Entry" <> 0) THEN
        CreateReservEntry.SetItemLedgEntryNo(ItemJnlLine."Applies-to Entry");

      IF OverruleItemTracking THEN
        IF ItemJnlLine.TrackingExists THEN BEGIN
          CreateReservEntry.SetNewSerialLotNo(ItemJnlLine."Serial No.",ItemJnlLine."Lot No.");
          CreateReservEntry.SetOverruleItemTracking(TRUE);
          // Try to match against Item Tracking on the purchase order line:
          OldReservEntry.SetTrackingFilterFromItemJnlLine(ItemJnlLine);
          IF OldReservEntry.ISEMPTY THEN
            EXIT(TransferQty);
        END;

      ItemJnlLine.TestItemFields(PurchLine."No.",PurchLine."Variant Code",PurchLine."Location Code");

      IF TransferQty = 0 THEN
        EXIT;

      IF ItemJnlLine."Invoiced Quantity" <> 0 THEN
        CreateReservEntry.SetUseQtyToInvoice(TRUE);

      IF ReservEngineMgt.InitRecordSet(OldReservEntry) THEN BEGIN
        REPEAT
          OldReservEntry.TestItemFields(PurchLine."No.",PurchLine."Variant Code",PurchLine."Location Code");

          IF CheckApplToItemEntry AND (OldReservEntry."Item Tracking" <> OldReservEntry."Item Tracking"::None) THEN BEGIN
            OldReservEntry.TESTFIELD("Appl.-to Item Entry");
            CreateReservEntry.SetApplyToEntryNo(OldReservEntry."Appl.-to Item Entry");
          END;

          TransferQty := CreateReservEntry.TransferReservEntry(DATABASE::"Item Journal Line",
              ItemJnlLine."Entry Type",ItemJnlLine."Journal Template Name",
              ItemJnlLine."Journal Batch Name",0,ItemJnlLine."Line No.",
              ItemJnlLine."Qty. per Unit of Measure",OldReservEntry,TransferQty);

        UNTIL (ReservEngineMgt.NEXTRecord(OldReservEntry) = 0) OR (TransferQty = 0);
        CheckApplToItemEntry := FALSE;
      END;
      EXIT(TransferQty);
    END;

    [External]
    PROCEDURE TransferPurchLineToPurchLine@36(VAR OldPurchLine@1000 : Record 39;VAR NewPurchLine@1001 : Record 39;TransferQty@1002 : Decimal);
    VAR
      OldReservEntry@1003 : Record 337;
      Status@1004 : 'Reservation,Tracking,Surplus,Prospect';
    BEGIN
      IF NOT FindReservEntry(OldPurchLine,OldReservEntry) THEN
        EXIT;

      OldReservEntry.Lock;

      NewPurchLine.TestItemFields(OldPurchLine."No.",OldPurchLine."Variant Code",OldPurchLine."Location Code");

      FOR Status := Status::Reservation TO Status::Prospect DO BEGIN
        IF TransferQty = 0 THEN
          EXIT;
        OldReservEntry.SETRANGE("Reservation Status",Status);

        IF OldReservEntry.FINDSET THEN
          REPEAT
            OldReservEntry.TestItemFields(OldPurchLine."No.",OldPurchLine."Variant Code",OldPurchLine."Location Code");

            TransferQty := CreateReservEntry.TransferReservEntry(DATABASE::"Purchase Line",
                NewPurchLine."Document Type",NewPurchLine."Document No.",'',0,NewPurchLine."Line No.",
                NewPurchLine."Qty. per Unit of Measure",OldReservEntry,TransferQty);

          UNTIL (OldReservEntry.NEXT = 0) OR (TransferQty = 0);
      END; // DO
    END;

    [External]
    PROCEDURE DeleteLineConfirm@20(VAR PurchLine@1000 : Record 39) : Boolean;
    BEGIN
      WITH PurchLine DO BEGIN
        IF NOT ReservEntryExist(PurchLine) THEN
          EXIT(TRUE);

        ReservMgt.SetPurchLine(PurchLine);
        IF ReservMgt.DeleteItemTrackingConfirm THEN
          DeleteItemTracking := TRUE;
      END;

      EXIT(DeleteItemTracking);
    END;

    [External]
    PROCEDURE DeleteLine@2(VAR PurchLine@1000 : Record 39);
    BEGIN
      IF Blocked THEN
        EXIT;

      WITH PurchLine DO BEGIN
        ReservMgt.SetPurchLine(PurchLine);
        IF DeleteItemTracking THEN
          ReservMgt.SetItemTrackingHandling(1); // Allow Deletion
        ReservMgt.DeleteReservEntries(TRUE,0);
        DeleteInvoiceSpecFromLine(PurchLine);
        ReservMgt.ClearActionMessageReferences;
        CALCFIELDS("Reserved Qty. (Base)");
        AssignForPlanning(PurchLine);
      END;
    END;

    LOCAL PROCEDURE AssignForPlanning@5(VAR PurchLine@1000 : Record 39);
    VAR
      PlanningAssignment@1001 : Record 99000850;
    BEGIN
      WITH PurchLine DO BEGIN
        IF "Document Type" <> "Document Type"::Order THEN
          EXIT;
        IF Type <> Type::Item THEN
          EXIT;
        IF "No." <> '' THEN
          PlanningAssignment.ChkAssignOne("No.","Variant Code","Location Code",WORKDATE);
      END;
    END;

    [External]
    PROCEDURE Block@6(SetBlocked@1000 : Boolean);
    BEGIN
      Blocked := SetBlocked;
    END;

    [External]
    PROCEDURE CallItemTracking@12(VAR PurchLine@1003 : Record 39);
    VAR
      TrackingSpecification@1001 : Record 336;
      ItemTrackingForm@1002 : Page 6510;
    BEGIN
      TrackingSpecification.InitFromPurchLine(PurchLine);
      IF ((PurchLine."Document Type" = PurchLine."Document Type"::Invoice) AND
          (PurchLine."Receipt No." <> '')) OR
         ((PurchLine."Document Type" = PurchLine."Document Type"::"Credit Memo") AND
          (PurchLine."Return Shipment No." <> ''))
      THEN
        ItemTrackingForm.SetFormRunMode(2); // Combined shipment/receipt
      IF PurchLine."Drop Shipment" THEN BEGIN
        ItemTrackingForm.SetFormRunMode(3); // Drop Shipment
        IF PurchLine."Sales Order No." <> '' THEN
          ItemTrackingForm.SetSecondSourceRowID(ItemTrackingMgt.ComposeRowID(DATABASE::"Sales Line",
              1,PurchLine."Sales Order No.",'',0,PurchLine."Sales Order Line No."));
      END;
      ItemTrackingForm.SetSourceSpec(TrackingSpecification,PurchLine."Expected Receipt Date");
      ItemTrackingForm.SetInbound(PurchLine.IsInbound);
      ItemTrackingForm.RUNMODAL;
    END;

    [External]
    PROCEDURE CallItemTracking2@15(VAR PurchLine@1000 : Record 39;SecondSourceQuantityArray@1001 : ARRAY [3] OF Decimal);
    VAR
      TrackingSpecification@1002 : Record 336;
      ItemTrackingForm@1003 : Page 6510;
    BEGIN
      TrackingSpecification.InitFromPurchLine(PurchLine);
      ItemTrackingForm.SetSourceSpec(TrackingSpecification,PurchLine."Expected Receipt Date");
      ItemTrackingForm.SetSecondSourceQuantity(SecondSourceQuantityArray);
      ItemTrackingForm.RUNMODAL;
    END;

    [External]
    PROCEDURE RetrieveInvoiceSpecification@9(VAR PurchLine@1004 : Record 39;VAR TempInvoicingSpecification@1001 : TEMPORARY Record 336) OK@1003 : Boolean;
    VAR
      SourceSpecification@1000 : Record 336;
    BEGIN
      CLEAR(TempInvoicingSpecification);
      IF PurchLine.Type <> PurchLine.Type::Item THEN
        EXIT;
      IF ((PurchLine."Document Type" = PurchLine."Document Type"::Invoice) AND
          (PurchLine."Receipt No." <> '')) OR
         ((PurchLine."Document Type" = PurchLine."Document Type"::"Credit Memo") AND
          (PurchLine."Return Shipment No." <> ''))
      THEN
        OK := RetrieveInvoiceSpecification2(PurchLine,TempInvoicingSpecification)
      ELSE BEGIN
        SourceSpecification.InitFromPurchLine(PurchLine);
        OK := ItemTrackingMgt.RetrieveInvoiceSpecification(SourceSpecification,TempInvoicingSpecification);
      END;
    END;

    LOCAL PROCEDURE RetrieveInvoiceSpecification2@1013(VAR PurchLine@1002 : Record 39;VAR TempInvoicingSpecification@1001 : TEMPORARY Record 336) OK@1003 : Boolean;
    VAR
      TrackingSpecification@1000 : Record 336;
      ReservEntry@1004 : Record 337;
    BEGIN
      // Used for combined receipt/return:
      IF PurchLine.Type <> PurchLine.Type::Item THEN
        EXIT;
      IF NOT FindReservEntry(PurchLine,ReservEntry) THEN
        EXIT;
      ReservEntry.FINDSET;
      REPEAT
        ReservEntry.TESTFIELD("Reservation Status",ReservEntry."Reservation Status"::Prospect);
        ReservEntry.TESTFIELD("Item Ledger Entry No.");
        TrackingSpecification.GET(ReservEntry."Item Ledger Entry No.");
        TempInvoicingSpecification := TrackingSpecification;
        TempInvoicingSpecification."Qty. to Invoice (Base)" := ReservEntry."Qty. to Invoice (Base)";
        TempInvoicingSpecification."Qty. to Invoice" :=
          ROUND(ReservEntry."Qty. to Invoice (Base)" / ReservEntry."Qty. per Unit of Measure",0.00001);
        TempInvoicingSpecification."Buffer Status" := TempInvoicingSpecification."Buffer Status"::MODIFY;
        TempInvoicingSpecification.INSERT;
        ReservEntry.DELETE;
      UNTIL ReservEntry.NEXT = 0;

      OK := TempInvoicingSpecification.FINDFIRST;
    END;

    [External]
    PROCEDURE DeleteInvoiceSpecFromHeader@14(PurchHeader@1002 : Record 38);
    BEGIN
      ItemTrackingMgt.DeleteInvoiceSpecFromHeader(
        DATABASE::"Purchase Line",PurchHeader."Document Type",PurchHeader."No.");
    END;

    LOCAL PROCEDURE DeleteInvoiceSpecFromLine@19(PurchLine@1002 : Record 39);
    BEGIN
      ItemTrackingMgt.DeleteInvoiceSpecFromLine(
        DATABASE::"Purchase Line",PurchLine."Document Type",PurchLine."Document No.",PurchLine."Line No.");
    END;

    [External]
    PROCEDURE UpdateItemTrackingAfterPosting@13(PurchHeader@1000 : Record 38);
    VAR
      ReservEntry@1003 : Record 337;
      CreateReservEntry@1001 : Codeunit 99000830;
    BEGIN
      // Used for updating Quantity to Handle and Quantity to Invoice after posting
      ReservEntry.SetSourceFilter(DATABASE::"Purchase Line",PurchHeader."Document Type",PurchHeader."No.",-1,TRUE);
      ReservEntry.SetSourceFilter2('',0);
      CreateReservEntry.UpdateItemTrackingAfterPosting(ReservEntry);
    END;

    [External]
    PROCEDURE SetApplySpecificItemTracking@16(ApplySpecific@1000 : Boolean);
    BEGIN
      ApplySpecificItemTracking := ApplySpecific;
    END;

    [External]
    PROCEDURE SetOverruleItemTracking@18(Overrule@1000 : Boolean);
    BEGIN
      OverruleItemTracking := Overrule;
    END;

    LOCAL PROCEDURE VerifyPurchLine@22(VAR NewPurchLine@1001 : Record 39;VAR OldPurchLine@1000 : Record 39;VAR HasError@1002 : Boolean);
    BEGIN
      IF (NewPurchLine.Type = NewPurchLine.Type::Item) AND (OldPurchLine.Type = OldPurchLine.Type::Item) THEN
        IF (NewPurchLine."Bin Code" <> OldPurchLine."Bin Code") AND
           (NOT ReservMgt.CalcIsAvailTrackedQtyInBin(
              NewPurchLine."No.",NewPurchLine."Bin Code",
              NewPurchLine."Location Code",NewPurchLine."Variant Code",
              DATABASE::"Purchase Line",NewPurchLine."Document Type",
              NewPurchLine."Document No.",'',0,NewPurchLine."Line No."))
        THEN
          HasError := TRUE;
      IF NewPurchLine."Line No." <> OldPurchLine."Line No." THEN
        HasError := TRUE;

      IF NewPurchLine.Type <> OldPurchLine.Type THEN
        HasError := TRUE;
    END;

    BEGIN
    END.
  }
}

