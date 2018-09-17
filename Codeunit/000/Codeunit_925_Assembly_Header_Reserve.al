OBJECT Codeunit 925 Assembly Header-Reserve
{
  OBJECT-PROPERTIES
  {
    Date=06-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21441;
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
      CreateReservEntry@1000 : Codeunit 99000830;
      ReservMgt@1016 : Codeunit 99000845;
      ReservEngineMgt@1014 : Codeunit 99000831;
      SetFromType@1011 : Integer;
      SetFromSubtype@1010 : Integer;
      SetFromID@1009 : Code[20];
      SetFromBatchName@1008 : Code[10];
      SetFromProdOrderLine@1007 : Integer;
      SetFromRefNo@1006 : Integer;
      SetFromVariantCode@1005 : Code[10];
      SetFromLocationCode@1004 : Code[10];
      SetFromSerialNo@1003 : Code[20];
      SetFromLotNo@1002 : Code[20];
      SetFromQtyPerUOM@1001 : Decimal;
      Text000@1013 : TextConst 'DAN=Reserveret antal m� ikke v�re st�rre end %1.;ENU=Reserved quantity cannot be greater than %1.';
      Text001@1012 : TextConst 'DAN=Codeunit er ikke initialiseret korrekt.;ENU=Codeunit is not initialized correctly.';
      DeleteItemTracking@1017 : Boolean;
      Text002@1019 : TextConst '@@@=starts with "Due Date";DAN=skal udfyldes, n�r et antal er reserveret;ENU=must be filled in when a quantity is reserved';
      Text003@1018 : TextConst '@@@=starts with some field name;DAN=m� ikke �ndres, n�r et antal er reserveret;ENU=must not be changed when a quantity is reserved';

    [External]
    PROCEDURE CreateReservation@1(VAR AssemblyHeader@1000 : Record 900;Description@1001 : Text[50];ExpectedReceiptDate@1002 : Date;Quantity@1006 : Decimal;QuantityBase@1003 : Decimal;ForSerialNo@1004 : Code[20];ForLotNo@1005 : Code[20]);
    VAR
      ShipmentDate@1007 : Date;
    BEGIN
      IF SetFromType = 0 THEN
        ERROR(Text001);

      AssemblyHeader.TESTFIELD("Item No.");
      AssemblyHeader.TESTFIELD("Due Date");

      AssemblyHeader.CALCFIELDS("Reserved Qty. (Base)");
      IF ABS(AssemblyHeader."Remaining Quantity (Base)") < ABS(AssemblyHeader."Reserved Qty. (Base)") + QuantityBase THEN
        ERROR(
          Text000,
          ABS(AssemblyHeader."Remaining Quantity (Base)") - ABS(AssemblyHeader."Reserved Qty. (Base)"));

      AssemblyHeader.TESTFIELD("Variant Code",SetFromVariantCode);
      AssemblyHeader.TESTFIELD("Location Code",SetFromLocationCode);

      IF QuantityBase * SignFactor(AssemblyHeader) < 0 THEN
        ShipmentDate := AssemblyHeader."Due Date"
      ELSE BEGIN
        ShipmentDate := ExpectedReceiptDate;
        ExpectedReceiptDate := AssemblyHeader."Due Date";
      END;

      IF AssemblyHeader."Planning Flexibility" <> AssemblyHeader."Planning Flexibility"::Unlimited THEN
        CreateReservEntry.SetPlanningFlexibility(AssemblyHeader."Planning Flexibility");

      CreateReservEntry.CreateReservEntryFor(
        DATABASE::"Assembly Header",AssemblyHeader."Document Type",
        AssemblyHeader."No.",'',0,0,AssemblyHeader."Qty. per Unit of Measure",
        Quantity,QuantityBase,ForSerialNo,ForLotNo);
      CreateReservEntry.CreateReservEntryFrom(
        SetFromType,SetFromSubtype,SetFromID,SetFromBatchName,SetFromProdOrderLine,SetFromRefNo,
        SetFromQtyPerUOM,SetFromSerialNo,SetFromLotNo);
      CreateReservEntry.CreateReservEntry(
        AssemblyHeader."Item No.",AssemblyHeader."Variant Code",AssemblyHeader."Location Code",
        Description,ExpectedReceiptDate,ShipmentDate);

      SetFromType := 0;
    END;

    [External]
    PROCEDURE CreateReservation2@6(VAR AssemblyHeader@1000 : Record 900;Description@1001 : Text[50];ExpectedReceiptDate@1002 : Date;Quantity@1006 : Decimal;QuantityBase@1003 : Decimal);
    BEGIN
      CreateReservation(AssemblyHeader,Description,ExpectedReceiptDate,Quantity,QuantityBase,'','');
    END;

    [External]
    PROCEDURE CreateReservationSetFrom@9(TrackingSpecificationFrom@1000 : Record 336);
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

    LOCAL PROCEDURE SignFactor@21(AssemblyHeader@1000 : Record 900) : Integer;
    BEGIN
      IF AssemblyHeader."Document Type" IN [2,3,5] THEN
        ERROR(Text001);

      EXIT(1);
    END;

    [External]
    PROCEDURE SetBinding@15(Binding@1000 : ' ,Order-to-Order');
    BEGIN
      CreateReservEntry.SetBinding(Binding);
    END;

    [External]
    PROCEDURE SetDisallowCancellation@24(DisallowCancellation@1000 : Boolean);
    BEGIN
      CreateReservEntry.SetDisallowCancellation(DisallowCancellation);
    END;

    [External]
    PROCEDURE FilterReservFor@12(VAR FilterReservEntry@1000 : Record 337;AssemblyHeader@1001 : Record 900);
    BEGIN
      FilterReservEntry.SetSourceFilter(DATABASE::"Assembly Header",AssemblyHeader."Document Type",AssemblyHeader."No.",0,FALSE);
      FilterReservEntry.SetSourceFilter2('',0);
    END;

    [External]
    PROCEDURE FindReservEntry@4(AssemblyHeader@1000 : Record 900;VAR ReservEntry@1001 : Record 337) : Boolean;
    BEGIN
      ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry,FALSE);
      FilterReservFor(ReservEntry,AssemblyHeader);
      EXIT(ReservEntry.FINDLAST);
    END;

    LOCAL PROCEDURE AssignForPlanning@7(VAR AssemblyHeader@1000 : Record 900);
    VAR
      PlanningAssignment@1001 : Record 99000850;
    BEGIN
      WITH AssemblyHeader DO BEGIN
        IF "Document Type" <> "Document Type"::Order THEN
          EXIT;

        IF "Item No." <> '' THEN
          PlanningAssignment.ChkAssignOne("Item No.","Variant Code","Location Code",WORKDATE);
      END;
    END;

    [External]
    PROCEDURE UpdatePlanningFlexibility@5(VAR AssemblyHeader@1000 : Record 900);
    VAR
      ReservEntry@1001 : Record 337;
    BEGIN
      IF FindReservEntry(AssemblyHeader,ReservEntry) THEN
        ReservEntry.MODIFYALL("Planning Flexibility",AssemblyHeader."Planning Flexibility");
    END;

    [External]
    PROCEDURE ReservEntryExist@16(AssemblyHeader@1000 : Record 900) : Boolean;
    VAR
      ReservEntry@1002 : Record 337;
      ReservEngineMgt@1001 : Codeunit 99000831;
    BEGIN
      ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry,FALSE);
      FilterReservFor(ReservEntry,AssemblyHeader);
      EXIT(NOT ReservEntry.ISEMPTY);
    END;

    [External]
    PROCEDURE DeleteLine@11(VAR AssemblyHeader@1000 : Record 900);
    BEGIN
      WITH AssemblyHeader DO BEGIN
        ReservMgt.SetAssemblyHeader(AssemblyHeader);
        IF DeleteItemTracking THEN
          ReservMgt.SetItemTrackingHandling(1); // Allow Deletion
        ReservMgt.DeleteReservEntries(TRUE,0);
        ReservMgt.ClearActionMessageReferences;
        CALCFIELDS("Reserved Qty. (Base)");
        AssignForPlanning(AssemblyHeader);
      END;
    END;

    [External]
    PROCEDURE VerifyChange@59(VAR NewAssemblyHeader@1000 : Record 900;VAR OldAssemblyHeader@1001 : Record 900);
    VAR
      ReservEntry@1002 : Record 337;
      ShowError@1003 : Boolean;
      HasError@1004 : Boolean;
    BEGIN
      NewAssemblyHeader.CALCFIELDS("Reserved Qty. (Base)");
      ShowError := NewAssemblyHeader."Reserved Qty. (Base)" <> 0;

      IF NewAssemblyHeader."Due Date" = 0D THEN BEGIN
        IF ShowError THEN
          NewAssemblyHeader.FIELDERROR("Due Date",Text002);
        HasError := TRUE;
      END;

      IF NewAssemblyHeader."Item No." <> OldAssemblyHeader."Item No." THEN BEGIN
        IF ShowError THEN
          NewAssemblyHeader.FIELDERROR("Item No.",Text003);
        HasError := TRUE;
      END;

      IF NewAssemblyHeader."Location Code" <> OldAssemblyHeader."Location Code" THEN BEGIN
        IF ShowError THEN
          NewAssemblyHeader.FIELDERROR("Location Code",Text003);
        HasError := TRUE;
      END;

      IF NewAssemblyHeader."Variant Code" <> OldAssemblyHeader."Variant Code" THEN BEGIN
        IF ShowError THEN
          NewAssemblyHeader.FIELDERROR("Variant Code",Text003);
        HasError := TRUE;
      END;

      IF HasError THEN
        IF (NewAssemblyHeader."Item No." <> OldAssemblyHeader."Item No.") OR
           FindReservEntry(NewAssemblyHeader,ReservEntry)
        THEN BEGIN
          IF NewAssemblyHeader."Item No." <> OldAssemblyHeader."Item No." THEN BEGIN
            ReservMgt.SetAssemblyHeader(OldAssemblyHeader);
            ReservMgt.DeleteReservEntries(TRUE,0);
            ReservMgt.SetAssemblyHeader(NewAssemblyHeader);
          END ELSE BEGIN
            ReservMgt.SetAssemblyHeader(NewAssemblyHeader);
            ReservMgt.DeleteReservEntries(TRUE,0);
          END;
          ReservMgt.AutoTrack(NewAssemblyHeader."Remaining Quantity (Base)");
        END;

      IF HasError OR (NewAssemblyHeader."Due Date" <> OldAssemblyHeader."Due Date") THEN BEGIN
        AssignForPlanning(NewAssemblyHeader);
        IF (NewAssemblyHeader."Item No." <> OldAssemblyHeader."Item No.") OR
           (NewAssemblyHeader."Variant Code" <> OldAssemblyHeader."Variant Code") OR
           (NewAssemblyHeader."Location Code" <> OldAssemblyHeader."Location Code")
        THEN
          AssignForPlanning(OldAssemblyHeader);
      END;
    END;

    [External]
    PROCEDURE VerifyQuantity@13(VAR NewAssemblyHeader@1000 : Record 900;VAR OldAssemblyHeader@1001 : Record 900);
    BEGIN
      WITH NewAssemblyHeader DO BEGIN
        IF "Quantity (Base)" = OldAssemblyHeader."Quantity (Base)" THEN
          EXIT;

        ReservMgt.SetAssemblyHeader(NewAssemblyHeader);
        IF "Qty. per Unit of Measure" <> OldAssemblyHeader."Qty. per Unit of Measure" THEN
          ReservMgt.ModifyUnitOfMeasure;
        ReservMgt.DeleteReservEntries(FALSE,"Remaining Quantity (Base)");
        ReservMgt.ClearSurplus;
        ReservMgt.AutoTrack("Remaining Quantity (Base)");
        AssignForPlanning(NewAssemblyHeader);
      END;
    END;

    [External]
    PROCEDURE Caption@30(AssemblyHeader@1001 : Record 900) CaptionText@1000 : Text[80];
    BEGIN
      CaptionText :=
        STRSUBSTNO('%1 %2',AssemblyHeader."Document Type",AssemblyHeader."No.");
    END;

    [External]
    PROCEDURE CallItemTracking@2(VAR AssemblyHeader@1000 : Record 900);
    VAR
      TrackingSpecification@1001 : Record 336;
      ItemTrackingLines@1002 : Page 6510;
    BEGIN
      TrackingSpecification.InitFromAsmHeader(AssemblyHeader);
      ItemTrackingLines.SetSourceSpec(TrackingSpecification,AssemblyHeader."Due Date");
      ItemTrackingLines.SetInbound(AssemblyHeader.IsInbound);
      ItemTrackingLines.RUNMODAL;
    END;

    [External]
    PROCEDURE DeleteLineConfirm@3(VAR AssemblyHeader@1000 : Record 900) : Boolean;
    BEGIN
      WITH AssemblyHeader DO BEGIN
        IF NOT ReservEntryExist(AssemblyHeader) THEN
          EXIT(TRUE);

        ReservMgt.SetAssemblyHeader(AssemblyHeader);
        IF ReservMgt.DeleteItemTrackingConfirm THEN
          DeleteItemTracking := TRUE;
      END;

      EXIT(DeleteItemTracking);
    END;

    [External]
    PROCEDURE UpdateItemTrackingAfterPosting@10(AssemblyHeader@1000 : Record 900);
    VAR
      ReservEntry@1003 : Record 337;
      CreateReservEntry@1001 : Codeunit 99000830;
    BEGIN
      // Used for updating Quantity to Handle and Quantity to Invoice after posting
      ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry,FALSE);
      ReservEntry.SetSourceFilter(
        DATABASE::"Assembly Header",AssemblyHeader."Document Type",AssemblyHeader."No.",-1,FALSE);
      ReservEntry.SetSourceFilter2('',0);
      CreateReservEntry.UpdateItemTrackingAfterPosting(ReservEntry);
    END;

    [External]
    PROCEDURE TransferAsmHeaderToItemJnlLine@32(VAR AssemblyHeader@1000 : Record 900;VAR ItemJnlLine@1001 : Record 83;TransferQty@1002 : Decimal;CheckApplToItemEntry@1004 : Boolean) : Decimal;
    VAR
      OldReservEntry@1003 : Record 337;
      OldReservEntry2@1005 : Record 337;
    BEGIN
      IF TransferQty = 0 THEN
        EXIT;
      IF NOT FindReservEntry(AssemblyHeader,OldReservEntry) THEN
        EXIT(TransferQty);
      AssemblyHeader.CALCFIELDS("Assemble to Order");

      ItemJnlLine.TestItemFields(AssemblyHeader."Item No.",AssemblyHeader."Variant Code",AssemblyHeader."Location Code");

      OldReservEntry.Lock;

      IF ReservEngineMgt.InitRecordSet(OldReservEntry) THEN BEGIN
        REPEAT
          OldReservEntry.TestItemFields(AssemblyHeader."Item No.",AssemblyHeader."Variant Code",AssemblyHeader."Location Code");
          IF CheckApplToItemEntry AND
             (OldReservEntry."Reservation Status" = OldReservEntry."Reservation Status"::Reservation)
          THEN BEGIN
            OldReservEntry2.GET(OldReservEntry."Entry No.",NOT OldReservEntry.Positive);
            OldReservEntry2.TESTFIELD("Source Type",DATABASE::"Item Ledger Entry");
          END;

          IF AssemblyHeader."Assemble to Order" AND
             (OldReservEntry.Binding = OldReservEntry.Binding::"Order-to-Order")
          THEN BEGIN
            OldReservEntry2.GET(OldReservEntry."Entry No.",NOT OldReservEntry.Positive);
            IF ABS(OldReservEntry2."Qty. to Handle (Base)") < ABS(OldReservEntry."Qty. to Handle (Base)") THEN BEGIN
              OldReservEntry."Qty. to Handle (Base)" := ABS(OldReservEntry2."Qty. to Handle (Base)");
              OldReservEntry."Qty. to Invoice (Base)" := ABS(OldReservEntry2."Qty. to Invoice (Base)");
            END;
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

    BEGIN
    END.
  }
}

