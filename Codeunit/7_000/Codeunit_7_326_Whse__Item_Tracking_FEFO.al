OBJECT Codeunit 7326 Whse. Item Tracking FEFO
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      TempGlobalEntrySummary@1012 : TEMPORARY Record 338;
      SourceReservationEntry@1010 : Record 337;
      ItemTrackingMgt@1009 : Codeunit 6500;
      LastSummaryEntryNo@1007 : Integer;
      StrictExpirationPosting@1003 : Boolean;
      HasExpiredItems@1002 : Boolean;
      SourceSet@1000 : Boolean;
      ExpiredItemsForPickMsg@1001 : TextConst 'DAN=\\Visse varer blev ikke medtaget i pluk grundet deres udl�bsdato.;ENU=\\Some items were not included in the pick due to their expiration date.';

    PROCEDURE CreateEntrySummaryFEFO@5(Location@1002 : Record 14;ItemNo@1001 : Code[20];VariantCode@1000 : Code[10];UseExpDates@1231 : Boolean);
    BEGIN
      InitEntrySummaryFEFO;
      LastSummaryEntryNo := 0;
      StrictExpirationPosting := ItemTrackingMgt.StrictExpirationPosting(ItemNo);

      SummarizeInventoryFEFO(Location,ItemNo,VariantCode,UseExpDates);
      IF UseExpDates THEN
        SummarizeAdjustmentBinFEFO(Location,ItemNo,VariantCode);
    END;

    LOCAL PROCEDURE SummarizeInventoryFEFO@17(Location@1002 : Record 14;ItemNo@1001 : Code[20];VariantCode@1000 : Code[10];HasExpirationDate@1210 : Boolean);
    VAR
      ItemLedgEntry@1003 : Record 32;
    BEGIN
      WITH ItemLedgEntry DO BEGIN
        RESET;
        SETCURRENTKEY("Item No.",Open,"Variant Code",Positive,"Lot No.","Serial No.");
        SETRANGE("Item No.",ItemNo);
        SETRANGE(Open,TRUE);
        SETRANGE("Variant Code",VariantCode);
        SETRANGE(Positive,TRUE);
        IF HasExpirationDate THEN
          SETFILTER("Expiration Date",'<>%1',0D)
        ELSE
          SETRANGE("Expiration Date",0D);
        SETRANGE("Location Code",Location.Code);
        IF ISEMPTY THEN
          EXIT;

        FINDSET;
        REPEAT
          IF NOT IsItemTrackingBlocked("Item No.","Variant Code","Lot No.","Serial No.") THEN BEGIN
            CALCFIELDS("Reserved Quantity");
            IF "Remaining Quantity" - ("Reserved Quantity" - CalcReservedToSource("Entry No.")) > 0 THEN
              IF NOT EntrySummaryFEFOExists("Lot No.","Serial No.") THEN
                InsertEntrySummaryFEFO("Lot No.","Serial No.","Expiration Date");
          END;
        UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE SummarizeAdjustmentBinFEFO@66(Location@1002 : Record 14;ItemNo@1001 : Code[20];VariantCode@1000 : Code[10]);
    VAR
      WhseEntry@1003 : Record 7312;
      ItemTrackingMgt@1009 : Codeunit 6500;
      ExpirationDate@1008 : Date;
      EntriesExist@1007 : Boolean;
    BEGIN
      IF Location."Adjustment Bin Code" = '' THEN
        EXIT;

      WITH WhseEntry DO BEGIN
        RESET;
        SETCURRENTKEY("Item No.","Bin Code","Location Code","Variant Code","Unit of Measure Code","Lot No.","Serial No.");
        SETRANGE("Item No.",ItemNo);
        SETRANGE("Bin Code",Location."Adjustment Bin Code");
        SETRANGE("Location Code",Location.Code);
        SETRANGE("Variant Code",VariantCode);
        IF ISEMPTY THEN
          EXIT;

        IF FINDSET THEN
          REPEAT
            IF NOT EntrySummaryFEFOExists("Lot No.","Serial No.") THEN
              IF CalcAvailQtyOnWarehouse(WhseEntry) <> 0 THEN
                IF NOT IsItemTrackingBlocked("Item No.","Variant Code","Lot No.","Serial No.") THEN BEGIN
                  ExpirationDate :=
                    ItemTrackingMgt.WhseExistingExpirationDate(
                      "Item No.","Variant Code",Location,"Lot No.","Serial No.",EntriesExist);

                  IF NOT EntriesExist THEN
                    ExpirationDate := 0D;

                  InsertEntrySummaryFEFO("Lot No.","Serial No.",ExpirationDate);
                END;
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE InitEntrySummaryFEFO@10();
    BEGIN
      WITH TempGlobalEntrySummary DO BEGIN
        DELETEALL;
        RESET;
        SETCURRENTKEY("Lot No.","Serial No.");
      END;
    END;

    LOCAL PROCEDURE InsertEntrySummaryFEFO@6(LotNo@1000 : Code[20];SerialNo@1001 : Code[20];ExpirationDate@1003 : Date);
    BEGIN
      WITH TempGlobalEntrySummary DO BEGIN
        IF (NOT StrictExpirationPosting) OR (ExpirationDate >= WORKDATE) THEN BEGIN
          INIT;
          "Entry No." := LastSummaryEntryNo + 1;
          "Serial No." := SerialNo;
          "Lot No." := LotNo;
          "Expiration Date" := ExpirationDate;
          INSERT;
          LastSummaryEntryNo := "Entry No.";
        END ELSE
          HasExpiredItems := TRUE;
      END;
    END;

    LOCAL PROCEDURE EntrySummaryFEFOExists@4(LotNo@1000 : Code[20];SerialNo@1001 : Code[20]) : Boolean;
    BEGIN
      WITH TempGlobalEntrySummary DO BEGIN
        SetTrackingFilter(SerialNo,LotNo);
        EXIT(FINDSET);
      END;
    END;

    PROCEDURE FindFirstEntrySummaryFEFO@61(VAR EntrySummary@1000 : Record 338) : Boolean;
    BEGIN
      WITH TempGlobalEntrySummary DO BEGIN
        RESET;
        SETCURRENTKEY("Expiration Date");

        IF NOT FIND('-') THEN
          EXIT(FALSE);

        EntrySummary := TempGlobalEntrySummary;
        EXIT(TRUE);
      END;
    END;

    [External]
    PROCEDURE FindNextEntrySummaryFEFO@30(VAR EntrySummary@1000 : Record 338) : Boolean;
    BEGIN
      WITH TempGlobalEntrySummary DO BEGIN
        IF NEXT = 0 THEN
          EXIT(FALSE);

        EntrySummary := TempGlobalEntrySummary;
        EXIT(TRUE);
      END;
    END;

    [External]
    PROCEDURE GetHasExpiredItems@12() : Boolean;
    BEGIN
      EXIT(HasExpiredItems);
    END;

    [External]
    PROCEDURE GetResultMessageForExpiredItem@13() : Text[100];
    BEGIN
      IF HasExpiredItems THEN
        EXIT(ExpiredItemsForPickMsg);

      EXIT('');
    END;

    [External]
    PROCEDURE SetSource@15(SourceType2@1004 : Integer;SourceSubType2@1003 : Integer;SourceNo2@1002 : Code[20];SourceLineNo2@1001 : Integer;SourceSubLineNo2@1000 : Integer);
    VAR
      CreatePick@1005 : Codeunit 7312;
    BEGIN
      SourceReservationEntry.RESET;
      CreatePick.SetFiltersOnReservEntry(
        SourceReservationEntry,SourceType2,SourceSubType2,SourceNo2,SourceLineNo2,SourceSubLineNo2);
      SourceSet := TRUE;
    END;

    LOCAL PROCEDURE CalcReservedToSource@18(ILENo@1000 : Integer) Result : Decimal;
    BEGIN
      Result := 0;
      IF NOT SourceSet THEN
        EXIT(Result);

      WITH SourceReservationEntry DO BEGIN
        IF FINDSET THEN
          REPEAT
            IF ReservedFromILE(SourceReservationEntry,ILENo) THEN
              Result -= "Quantity (Base)"; // "Quantity (Base)" is negative
          UNTIL NEXT = 0;
      END;

      EXIT(Result);
    END;

    LOCAL PROCEDURE ReservedFromILE@49(ReservationEntry@1000 : Record 337;ILENo@1001 : Integer) : Boolean;
    BEGIN
      WITH ReservationEntry DO BEGIN
        Positive := NOT Positive;
        FIND;
        EXIT(
          ("Source ID" = '') AND ("Source Ref. No." = ILENo) AND
          ("Source Type" = DATABASE::"Item Ledger Entry") AND ("Source Subtype" = 0) AND
          ("Source Batch Name" = '') AND ("Source Prod. Order Line" = 0) AND
          ("Reservation Status" = "Reservation Status"::Reservation));
      END;
    END;

    LOCAL PROCEDURE CalcAvailQtyOnWarehouse@36(VAR WhseEntry@1000 : Record 7312) : Decimal;
    VAR
      WarehouseEntry@1001 : Record 7312;
    BEGIN
      WITH WarehouseEntry DO BEGIN
        COPYFILTERS(WhseEntry);
        SETRANGE("Lot No.",WhseEntry."Lot No.");
        SETRANGE("Serial No.",WhseEntry."Serial No.");
        CALCSUMS(Quantity);
        EXIT(Quantity);
      END;
    END;

    LOCAL PROCEDURE IsItemTrackingBlocked@23(ItemNo@1002 : Code[20];VariantCode@1003 : Code[10];LotNo@1004 : Code[20];SerialNo@1005 : Code[20]) : Boolean;
    VAR
      LotNoInformation@1000 : Record 6505;
      SerialNoInformation@1001 : Record 6504;
    BEGIN
      IF LotNoInformation.GET(ItemNo,VariantCode,LotNo) THEN
        IF LotNoInformation.Blocked THEN
          EXIT(TRUE);
      IF SerialNoInformation.GET(ItemNo,VariantCode,SerialNo) THEN
        IF SerialNoInformation.Blocked THEN
          EXIT(TRUE);

      EXIT(FALSE);
    END;

    BEGIN
    END.
  }
}

