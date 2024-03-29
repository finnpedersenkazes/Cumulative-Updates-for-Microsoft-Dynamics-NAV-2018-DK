OBJECT Codeunit 6500 Item Tracking Management
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    Permissions=TableData 6507=rd,
                TableData 6508=rd,
                TableData 6550=rimd;
    OnRun=VAR
            ItemTrackingLines@1000 : Page 6510;
          BEGIN
            SourceSpecification.TESTFIELD("Source Type");
            ItemTrackingLines.RegisterItemTrackingLines(
              SourceSpecification,DueDate,TempTrackingSpecification)
          END;

  }
  CODE
  {
    VAR
      Text001@1000 : TextConst 'DAN=Den antal, du vil udf�re handlingen %1 p�, stemmer ikke overens med det antal, der er angivet i varesporing.;ENU=The quantity to %1 does not match the quantity defined in item tracking.';
      Text003@1002 : TextConst 'DAN=Der findes ikke oplysninger til %1 %2.;ENU=No information exists for %1 %2.';
      Text005@1004 : TextConst 'DAN=Lagersporing er ikke aktiveret for %1 %2.;ENU=Warehouse item tracking is not enabled for %1 %2.';
      SourceSpecification@1005 : TEMPORARY Record 336;
      TempTrackingSpecification@1006 : TEMPORARY Record 336;
      TempGlobalWhseItemTrkgLine@1014 : TEMPORARY Record 6550;
      DueDate@1007 : Date;
      Text006@1008 : TextConst 'DAN=Synkroniseringen blev annulleret.;ENU=Synchronization cancelled.';
      Registering@1009 : Boolean;
      Text007@1001 : TextConst 'DAN=Der er registreret flere udl�bsdatoer for lot %1.;ENU=There are multiple expiration dates registered for lot %1.';
      text008@1010 : TextConst 'DAN=%1 findes allerede for %2 %3. Vil du overskrive de eksisterende oplysninger?;ENU=%1 already exists for %2 %3. Do you want to overwrite the existing information?';
      IsConsume@1012 : Boolean;
      Text010@1013 : TextConst 'DAN=faktura;ENU=invoice';
      Text011@1018 : TextConst 'DAN=%1 m� ikke v�re %2.;ENU=%1 must not be %2.';
      Text012@1016 : TextConst 'DAN=Kun �n udl�bsdato er tilladt pr. lotnumber.\%1 har i �jeblikket to forskellige udl�bsdatoer: %2 og %3.;ENU=Only one expiration date is allowed per lot number.\%1 currently has two different expiration dates: %2 and %3.';
      IsPick@1017 : Boolean;
      DeleteReservationEntries@1021 : Boolean;
      CannotMatchItemTrackingErr@1003 : TextConst 'DAN=Varesporing stemmer ikke overens.;ENU=Cannot match item tracking.';

    [External]
    PROCEDURE SetPointerFilter@21(VAR TrackingSpecification@1000 : Record 336);
    BEGIN
      WITH TrackingSpecification DO BEGIN
        SetSourceFilter("Source Type","Source Subtype","Source ID","Source Ref. No.",TRUE);
        SetSourceFilter2("Source Batch Name","Source Prod. Order Line");
      END;
    END;

    [External]
    PROCEDURE LookupLotSerialNoInfo@23(ItemNo@1002 : Code[20];Variant@1003 : Code[20];LookupType@1004 : 'Serial No.,Lot No.';LookupNo@1005 : Code[20]);
    VAR
      LotNoInfo@1000 : Record 6505;
      SerialNoInfo@1001 : Record 6504;
    BEGIN
      CASE LookupType OF
        LookupType::"Serial No.":
          BEGIN
            IF NOT SerialNoInfo.GET(ItemNo,Variant,LookupNo) THEN
              ERROR(Text003,SerialNoInfo.FIELDCAPTION("Serial No."),LookupNo);
            PAGE.RUNMODAL(0,SerialNoInfo);
          END;
        LookupType::"Lot No.":
          BEGIN
            IF NOT LotNoInfo.GET(ItemNo,Variant,LookupNo) THEN
              ERROR(Text003,LotNoInfo.FIELDCAPTION("Lot No."),LookupNo);
            PAGE.RUNMODAL(0,LotNoInfo);
          END;
      END;
    END;

    [External]
    PROCEDURE CreateTrackingSpecification@5(VAR FromReservEntry@1000 : Record 337;VAR ToTrackingSpecification@1001 : Record 336);
    BEGIN
      ToTrackingSpecification.INIT;
      ToTrackingSpecification.TRANSFERFIELDS(FromReservEntry);
      ToTrackingSpecification."Qty. to Handle (Base)" := 0;
      ToTrackingSpecification."Qty. to Invoice (Base)" := 0;
      ToTrackingSpecification."Quantity Handled (Base)" := FromReservEntry."Qty. to Handle (Base)";
      ToTrackingSpecification."Quantity Invoiced (Base)" := FromReservEntry."Qty. to Invoice (Base)";
    END;

    [External]
    PROCEDURE GetItemTrackingSettings@4(VAR ItemTrackingCode@1000 : Record 6502;EntryType@1001 : 'Purchase,Sale,Positive Adjmt.,Negative Adjmt.,Transfer,Consumption,Output, ,Assembly Consumption,Assembly Output';Inbound@1002 : Boolean;VAR SNRequired@1003 : Boolean;VAR LotRequired@1004 : Boolean;VAR SNInfoRequired@1006 : Boolean;VAR LotInfoRequired@1005 : Boolean);
    BEGIN
      SNRequired := FALSE;
      LotRequired := FALSE;
      SNInfoRequired := FALSE;
      LotInfoRequired := FALSE;

      IF ItemTrackingCode.Code = '' THEN BEGIN
        CLEAR(ItemTrackingCode);
        EXIT;
      END;
      ItemTrackingCode.GET(ItemTrackingCode.Code);

      IF EntryType = EntryType::Transfer THEN BEGIN
        LotInfoRequired := ItemTrackingCode."Lot Info. Outbound Must Exist" OR ItemTrackingCode."Lot Info. Inbound Must Exist";
        SNInfoRequired := ItemTrackingCode."SN Info. Outbound Must Exist" OR ItemTrackingCode."SN Info. Inbound Must Exist";
      END ELSE BEGIN
        SNInfoRequired := (Inbound AND ItemTrackingCode."SN Info. Inbound Must Exist") OR
          (NOT Inbound AND ItemTrackingCode."SN Info. Outbound Must Exist");

        LotInfoRequired := (Inbound AND ItemTrackingCode."Lot Info. Inbound Must Exist") OR
          (NOT Inbound AND ItemTrackingCode."Lot Info. Outbound Must Exist");
      END;

      IF ItemTrackingCode."SN Specific Tracking" THEN BEGIN
        SNRequired := TRUE;
      END ELSE
        CASE EntryType OF
          EntryType::Purchase:
            IF Inbound THEN
              SNRequired := ItemTrackingCode."SN Purchase Inbound Tracking"
            ELSE
              SNRequired := ItemTrackingCode."SN Purchase Outbound Tracking";
          EntryType::Sale:
            IF Inbound THEN
              SNRequired := ItemTrackingCode."SN Sales Inbound Tracking"
            ELSE
              SNRequired := ItemTrackingCode."SN Sales Outbound Tracking";
          EntryType::"Positive Adjmt.":
            IF Inbound THEN
              SNRequired := ItemTrackingCode."SN Pos. Adjmt. Inb. Tracking"
            ELSE
              SNRequired := ItemTrackingCode."SN Pos. Adjmt. Outb. Tracking";
          EntryType::"Negative Adjmt.":
            IF Inbound THEN
              SNRequired := ItemTrackingCode."SN Neg. Adjmt. Inb. Tracking"
            ELSE
              SNRequired := ItemTrackingCode."SN Neg. Adjmt. Outb. Tracking";
          EntryType::Transfer:
            SNRequired := ItemTrackingCode."SN Transfer Tracking";
          EntryType::Consumption,EntryType::Output:
            IF Inbound THEN
              SNRequired := ItemTrackingCode."SN Manuf. Inbound Tracking"
            ELSE
              SNRequired := ItemTrackingCode."SN Manuf. Outbound Tracking";
          EntryType::"Assembly Consumption",EntryType::"Assembly Output":
            IF Inbound THEN
              SNRequired := ItemTrackingCode."SN Assembly Inbound Tracking"
            ELSE
              SNRequired := ItemTrackingCode."SN Assembly Outbound Tracking";
        END;

      IF ItemTrackingCode."Lot Specific Tracking" THEN BEGIN
        LotRequired := TRUE;
      END ELSE
        CASE EntryType OF
          EntryType::Purchase:
            IF Inbound THEN
              LotRequired := ItemTrackingCode."Lot Purchase Inbound Tracking"
            ELSE
              LotRequired := ItemTrackingCode."Lot Purchase Outbound Tracking";
          EntryType::Sale:
            IF Inbound THEN
              LotRequired := ItemTrackingCode."Lot Sales Inbound Tracking"
            ELSE
              LotRequired := ItemTrackingCode."Lot Sales Outbound Tracking";
          EntryType::"Positive Adjmt.":
            IF Inbound THEN
              LotRequired := ItemTrackingCode."Lot Pos. Adjmt. Inb. Tracking"
            ELSE
              LotRequired := ItemTrackingCode."Lot Pos. Adjmt. Outb. Tracking";
          EntryType::"Negative Adjmt.":
            IF Inbound THEN
              LotRequired := ItemTrackingCode."Lot Neg. Adjmt. Inb. Tracking"
            ELSE
              LotRequired := ItemTrackingCode."Lot Neg. Adjmt. Outb. Tracking";
          EntryType::Transfer:
            LotRequired := ItemTrackingCode."Lot Transfer Tracking";
          EntryType::Consumption,EntryType::Output:
            IF Inbound THEN
              LotRequired := ItemTrackingCode."Lot Manuf. Inbound Tracking"
            ELSE
              LotRequired := ItemTrackingCode."Lot Manuf. Outbound Tracking";
          EntryType::"Assembly Consumption",EntryType::"Assembly Output":
            IF Inbound THEN
              LotRequired := ItemTrackingCode."Lot Assembly Inbound Tracking"
            ELSE
              LotRequired := ItemTrackingCode."Lot Assembly Outbound Tracking";
        END;
    END;

    [External]
    PROCEDURE RetrieveInvoiceSpecification@35(SourceSpecification@1002 : Record 336;VAR TempInvoicingSpecification@1008 : TEMPORARY Record 336) OK@1003 : Boolean;
    VAR
      TrackingSpecification@1000 : Record 336;
      TotalQtyToInvoiceBase@1005 : Decimal;
    BEGIN
      OK := FALSE;
      TempInvoicingSpecification.RESET;
      TempInvoicingSpecification.DELETEALL;

      // TrackingSpecification contains information about lines that should be invoiced:

      TrackingSpecification.SetSourceFilter(
        SourceSpecification."Source Type",SourceSpecification."Source Subtype",SourceSpecification."Source ID",
        SourceSpecification."Source Ref. No.",TRUE);
      TrackingSpecification.SetSourceFilter2(
        SourceSpecification."Source Batch Name",SourceSpecification."Source Prod. Order Line");
      IF TrackingSpecification.FINDSET THEN
        REPEAT
          TrackingSpecification.TESTFIELD("Qty. to Handle (Base)",0);
          TrackingSpecification.TESTFIELD("Qty. to Handle",0);
          IF NOT TrackingSpecification.Correction THEN BEGIN
            TempInvoicingSpecification := TrackingSpecification;
            TempInvoicingSpecification."Qty. to Invoice" :=
              ROUND(TempInvoicingSpecification."Qty. to Invoice (Base)" /
                SourceSpecification."Qty. per Unit of Measure",0.00001);

            IF ABS(TotalQtyToInvoiceBase + TempInvoicingSpecification."Qty. to Invoice (Base)") >
               ABS(SourceSpecification."Qty. to Invoice (Base)")
            THEN BEGIN
              TempInvoicingSpecification."Qty. to Invoice (Base)" :=
                SourceSpecification."Qty. to Invoice (Base)" - TotalQtyToInvoiceBase;
              TotalQtyToInvoiceBase := SourceSpecification."Qty. to Invoice (Base)";
            END ELSE
              TotalQtyToInvoiceBase += TempInvoicingSpecification."Qty. to Invoice (Base)";
            TempInvoicingSpecification.INSERT;
          END;
        UNTIL TrackingSpecification.NEXT = 0;

      IF SourceSpecification."Qty. to Invoice (Base)" <> 0 THEN
        IF TempInvoicingSpecification.FINDFIRST THEN BEGIN
          IF (ABS(TotalQtyToInvoiceBase) <
              ABS(SourceSpecification."Qty. to Invoice (Base)") - ABS(SourceSpecification."Qty. to Handle (Base)")) AND
             (TotalQtyToInvoiceBase <> 0) AND
             NOT IsConsume
          THEN
            ERROR(Text001,Text010);
          OK := TRUE;
        END;
      TempInvoicingSpecification.SETFILTER("Qty. to Invoice (Base)",'<>0');
      IF NOT TempInvoicingSpecification.FINDFIRST THEN
        TempInvoicingSpecification.INIT;
    END;

    [External]
    PROCEDURE RetrieveInvoiceSpecWithService@75(SourceSpecification@1002 : Record 336;VAR TempInvoicingSpecification@1008 : TEMPORARY Record 336;Consume@1001 : Boolean) OK@1003 : Boolean;
    BEGIN
      IsConsume := Consume;
      OK := RetrieveInvoiceSpecification(SourceSpecification,TempInvoicingSpecification);
    END;

    [External]
    PROCEDURE RetrieveItemTracking@9(ItemJnlLine@1002 : Record 83;VAR TempHandlingSpecification@1007 : TEMPORARY Record 336) : Boolean;
    VAR
      ReservEntry@1001 : Record 337;
    BEGIN
      EXIT(RetrieveItemTrackingFromReservEntry(ItemJnlLine,ReservEntry,TempHandlingSpecification));
    END;

    [External]
    PROCEDURE RetrieveItemTrackingFromReservEntry@11(ItemJnlLine@1001 : Record 83;VAR ReservEntry@1002 : Record 337;VAR TempTrackingSpec@1000 : TEMPORARY Record 336) : Boolean;
    BEGIN
      IF ItemJnlLine.Subcontracting THEN
        EXIT(RetrieveSubcontrItemTracking(ItemJnlLine,TempTrackingSpec));

      ReservEntry.SetSourceFilter(
        DATABASE::"Item Journal Line",ItemJnlLine."Entry Type",ItemJnlLine."Journal Template Name",ItemJnlLine."Line No.",TRUE);
      ReservEntry.SetSourceFilter2(ItemJnlLine."Journal Batch Name",0);
      OnAfterReserveEntryFilter(ItemJnlLine,ReservEntry);
      ReservEntry.SETFILTER("Qty. to Handle (Base)",'<>0');

      IF SumUpItemTracking(ReservEntry,TempTrackingSpec,FALSE,TRUE) THEN BEGIN
        ReservEntry.SETRANGE("Reservation Status",ReservEntry."Reservation Status"::Prospect);
        IF NOT ReservEntry.ISEMPTY THEN
          ReservEntry.DELETEALL;
        EXIT(TRUE);
      END;
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE RetrieveSubcontrItemTracking@46(ItemJnlLine@1002 : Record 83;VAR TempHandlingSpecification@1007 : TEMPORARY Record 336) : Boolean;
    VAR
      ReservEntry@1001 : Record 337;
      ProdOrderRtngLine@1000 : Record 5409;
    BEGIN
      IF NOT ItemJnlLine.Subcontracting THEN
        EXIT(FALSE);

      IF ItemJnlLine."Operation No." = '' THEN
        EXIT(FALSE);

      ItemJnlLine.TESTFIELD("Routing No.");
      ItemJnlLine.TESTFIELD("Order Type",ItemJnlLine."Order Type"::Production);
      IF NOT ProdOrderRtngLine.GET(
           ProdOrderRtngLine.Status::Released,ItemJnlLine."Order No.",
           ItemJnlLine."Routing Reference No.",ItemJnlLine."Routing No.",ItemJnlLine."Operation No.")
      THEN
        EXIT(FALSE);
      IF NOT (ProdOrderRtngLine."Next Operation No." = '') THEN
        EXIT(FALSE);

      ReservEntry.SetSourceFilter(DATABASE::"Prod. Order Line",3,ItemJnlLine."Order No.",0,TRUE);
      ReservEntry.SetSourceFilter2('',ItemJnlLine."Order Line No.");
      ReservEntry.SETFILTER("Qty. to Handle (Base)",'<>0');
      IF SumUpItemTracking(ReservEntry,TempHandlingSpecification,FALSE,TRUE) THEN BEGIN
        ReservEntry.SETRANGE("Reservation Status",ReservEntry."Reservation Status"::Prospect);
        IF NOT ReservEntry.ISEMPTY THEN
          ReservEntry.DELETEALL;
        EXIT(TRUE);
      END;
      EXIT(FALSE);
    END;

    [External]
    PROCEDURE RetrieveConsumpItemTracking@13(ItemJnlLine@1002 : Record 83;VAR TempHandlingSpecification@1007 : TEMPORARY Record 336) : Boolean;
    VAR
      ReservEntry@1001 : Record 337;
    BEGIN
      ItemJnlLine.TESTFIELD("Order Type",ItemJnlLine."Order Type"::Production);
      ReservEntry.SetSourceFilter(
        DATABASE::"Prod. Order Component",3,ItemJnlLine."Order No.",ItemJnlLine."Prod. Order Comp. Line No.",TRUE);
      ReservEntry.SetSourceFilter2('',ItemJnlLine."Order Line No.");
      ReservEntry.SETFILTER("Qty. to Handle (Base)",'<>0');
      ReservEntry.SetTrackingFilterFromItemJnlLine(ItemJnlLine);

      // Sum up in a temporary table per component line:
      EXIT(SumUpItemTracking(ReservEntry,TempHandlingSpecification,TRUE,TRUE));
    END;

    [External]
    PROCEDURE SumUpItemTracking@15(VAR ReservEntry@1000 : Record 337;VAR TempHandlingSpecification@1007 : TEMPORARY Record 336;SumPerLine@1006 : Boolean;SumPerLotSN@1008 : Boolean) : Boolean;
    VAR
      NextEntryNo@1004 : Integer;
      ExpDate@1210 : Date;
      EntriesExist@1211 : Boolean;
    BEGIN
      // Sum up Item Tracking in a temporary table (to defragment the ReservEntry records)
      TempHandlingSpecification.RESET;
      TempHandlingSpecification.DELETEALL;
      IF SumPerLotSN THEN
        TempHandlingSpecification.SETCURRENTKEY("Lot No.","Serial No.");

      IF ReservEntry.FINDSET THEN
        REPEAT
          IF ReservEntry.TrackingExists THEN BEGIN
            IF SumPerLine THEN
              TempHandlingSpecification.SETRANGE("Source Ref. No.",ReservEntry."Source Ref. No."); // Sum up line per line
            IF SumPerLotSN THEN BEGIN
              TempHandlingSpecification.SetTrackingFilterFromReservEntry(ReservEntry);
              IF ReservEntry."New Serial No." <> '' THEN
                TempHandlingSpecification.SETRANGE("New Serial No.",ReservEntry."New Serial No." );
              IF ReservEntry."New Lot No." <> '' THEN
                TempHandlingSpecification.SETRANGE("New Lot No.",ReservEntry."New Lot No.");
            END;
            IF TempHandlingSpecification.FINDFIRST THEN BEGIN
              TempHandlingSpecification."Quantity (Base)" += ReservEntry."Quantity (Base)";
              TempHandlingSpecification."Qty. to Handle (Base)" += ReservEntry."Qty. to Handle (Base)";
              TempHandlingSpecification."Qty. to Invoice (Base)" += ReservEntry."Qty. to Invoice (Base)";
              TempHandlingSpecification."Quantity Invoiced (Base)" += ReservEntry."Quantity Invoiced (Base)";
              TempHandlingSpecification."Qty. to Handle" :=
                TempHandlingSpecification."Qty. to Handle (Base)" /
                ReservEntry."Qty. per Unit of Measure";
              TempHandlingSpecification."Qty. to Invoice" :=
                TempHandlingSpecification."Qty. to Invoice (Base)" /
                ReservEntry."Qty. per Unit of Measure";
              IF ReservEntry."Reservation Status" > ReservEntry."Reservation Status"::Tracking THEN
                TempHandlingSpecification."Buffer Value1" += // Late Binding
                  TempHandlingSpecification."Qty. to Handle (Base)";
              TempHandlingSpecification.MODIFY;
            END ELSE BEGIN
              TempHandlingSpecification.INIT;
              TempHandlingSpecification.TRANSFERFIELDS(ReservEntry);
              NextEntryNo += 1;
              TempHandlingSpecification."Entry No." := NextEntryNo;
              TempHandlingSpecification."Qty. to Handle" :=
                TempHandlingSpecification."Qty. to Handle (Base)" /
                ReservEntry."Qty. per Unit of Measure";
              TempHandlingSpecification."Qty. to Invoice" :=
                TempHandlingSpecification."Qty. to Invoice (Base)" /
                ReservEntry."Qty. per Unit of Measure";
              IF ReservEntry."Reservation Status" > ReservEntry."Reservation Status"::Tracking THEN
                TempHandlingSpecification."Buffer Value1" += // Late Binding
                  TempHandlingSpecification."Qty. to Handle (Base)";
              ExpDate :=
                ExistingExpirationDate(
                  ReservEntry."Item No.",ReservEntry."Variant Code",ReservEntry."Lot No.",ReservEntry."Serial No.",FALSE,EntriesExist);
              IF EntriesExist THEN
                TempHandlingSpecification."Expiration Date" := ExpDate;
              TempHandlingSpecification.INSERT;
            END;
          END;
        UNTIL ReservEntry.NEXT = 0;

      TempHandlingSpecification.RESET;
      EXIT(TempHandlingSpecification.FINDFIRST);
    END;

    [External]
    PROCEDURE SumUpItemTrackingOnlyInventoryOrATO@112(VAR ReservationEntry@1004 : Record 337;VAR TrackingSpecification@1003 : Record 336;SumPerLine@1002 : Boolean;SumPerLotSN@1001 : Boolean) : Boolean;
    VAR
      TempReservationEntry@1000 : TEMPORARY Record 337;
    BEGIN
      IF ReservationEntry.FINDSET THEN
        REPEAT
          IF (ReservationEntry."Reservation Status" <> ReservationEntry."Reservation Status"::Reservation) OR
             IsResEntryReservedAgainstInventory(ReservationEntry)
          THEN BEGIN
            TempReservationEntry := ReservationEntry;
            TempReservationEntry.INSERT;
          END;
        UNTIL ReservationEntry.NEXT = 0;

      EXIT(SumUpItemTracking(TempReservationEntry,TrackingSpecification,SumPerLine,SumPerLotSN));
    END;

    LOCAL PROCEDURE IsResEntryReservedAgainstInventory@106(ReservationEntry@1000 : Record 337) : Boolean;
    VAR
      ReservationEntry2@1001 : Record 337;
    BEGIN
      IF (ReservationEntry."Reservation Status" <> ReservationEntry."Reservation Status"::Reservation) OR
         ReservationEntry.Positive
      THEN
        EXIT(FALSE);

      ReservationEntry2.GET(ReservationEntry."Entry No.",NOT ReservationEntry.Positive);
      IF ReservationEntry2."Source Type" = DATABASE::"Item Ledger Entry" THEN
        EXIT(TRUE);

      EXIT(IsResEntryReservedAgainstATO(ReservationEntry));
    END;

    LOCAL PROCEDURE IsResEntryReservedAgainstATO@108(ReservationEntry@1000 : Record 337) : Boolean;
    VAR
      ReservationEntry2@1001 : Record 337;
      SalesLine@1003 : Record 37;
      AssembleToOrderLink@1002 : Record 904;
    BEGIN
      IF (ReservationEntry."Source Type" <> DATABASE::"Sales Line") OR
         (ReservationEntry."Source Subtype" <> SalesLine."Document Type"::Order) OR
         (NOT SalesLine.GET(ReservationEntry."Source Subtype",ReservationEntry."Source ID",ReservationEntry."Source Ref. No.")) OR
         (NOT AssembleToOrderLink.AsmExistsForSalesLine(SalesLine))
      THEN
        EXIT(FALSE);

      ReservationEntry2.GET(ReservationEntry."Entry No.",NOT ReservationEntry.Positive);
      IF (ReservationEntry2."Source Type" <> DATABASE::"Assembly Header") OR
         (ReservationEntry2."Source Subtype" <> AssembleToOrderLink."Assembly Document Type") OR
         (ReservationEntry2."Source ID" <> AssembleToOrderLink."Assembly Document No.")
      THEN
        EXIT(FALSE);

      EXIT(TRUE);
    END;

    [External]
    PROCEDURE DecomposeRowID@8(IDtext@1000 : Text[250];VAR StrArray@1009 : ARRAY [6] OF Text[100]);
    VAR
      Len@1005 : Integer;
      Pos@1002 : Integer;
      ArrayIndex@1007 : Integer;
      Count@1004 : Integer;
      Char@1003 : Text[1];
      NoWriteSinceLastNext@1010 : Boolean;
      Write@1006 : Boolean;
      Next@1001 : Boolean;
    BEGIN
      FOR ArrayIndex := 1 TO 6 DO
        StrArray[ArrayIndex] := '';
      Len := STRLEN(IDtext);
      Pos := 1;
      ArrayIndex := 1;

      WHILE NOT (Pos > Len) DO BEGIN
        Char := COPYSTR(IDtext,Pos,1);
        IF Char = '"' THEN BEGIN
          Write := FALSE;
          Count += 1;
        END ELSE BEGIN
          IF Count = 0 THEN
            Write := TRUE
          ELSE BEGIN
            IF Count MOD 2 = 1 THEN BEGIN
              Next := (Char = ';');
              Count -= 1;
            END ELSE
              IF NoWriteSinceLastNext AND (Char = ';') THEN BEGIN
                Count -= 2;
                Next := TRUE;
              END;
            Count /= 2;
            WHILE Count > 0 DO BEGIN
              StrArray[ArrayIndex] += '"';
              Count -= 1;
            END;
            Write := NOT Next;
          END;
          NoWriteSinceLastNext := Next;
        END;

        IF Next THEN BEGIN
          ArrayIndex += 1;
          Next := FALSE
        END;

        IF Write THEN
          StrArray[ArrayIndex] += Char;
        Pos += 1;
      END;
    END;

    [External]
    PROCEDURE ComposeRowID@2(Type@1005 : Integer;Subtype@1004 : Integer;ID@1003 : Code[20];BatchName@1002 : Code[10];ProdOrderLine@1001 : Integer;RefNo@1000 : Integer) : Text[250];
    VAR
      StrArray@1006 : ARRAY [2] OF Text[100];
      Pos@1010 : Integer;
      Len@1011 : Integer;
      T@1009 : Integer;
    BEGIN
      StrArray[1] := ID;
      StrArray[2] := BatchName;
      FOR T := 1 TO 2 DO
        IF STRPOS(StrArray[T],'"') > 0 THEN BEGIN
          Len := STRLEN(StrArray[T]);
          Pos := 1;
          REPEAT
            IF COPYSTR(StrArray[T],Pos,1) = '"' THEN BEGIN
              StrArray[T] := INSSTR(StrArray[T],'"',Pos + 1);
              Len += 1;
              Pos += 1;
            END;
            Pos += 1;
          UNTIL Pos > Len;
        END;
      EXIT(STRSUBSTNO('"%1";"%2";"%3";"%4";"%5";"%6"',Type,Subtype,StrArray[1],StrArray[2],ProdOrderLine,RefNo));
    END;

    [External]
    PROCEDURE CopyItemTracking@14(FromRowID@1000 : Text[250];ToRowID@1001 : Text[250];SwapSign@1006 : Boolean);
    BEGIN
      CopyItemTracking2(FromRowID,ToRowID,SwapSign,FALSE);
    END;

    [External]
    PROCEDURE CopyItemTracking2@55(FromRowID@1000 : Text[250];ToRowID@1001 : Text[250];SwapSign@1006 : Boolean;SkipReservation@1007 : Boolean);
    VAR
      ReservEntry@1002 : Record 337;
    BEGIN
      ReservEntry.SetPointer(FromRowID);
      ReservEntry.SetPointerFilter;
      CopyItemTracking3(ReservEntry,ToRowID,SwapSign,SkipReservation);
    END;

    LOCAL PROCEDURE CopyItemTracking3@76(VAR ReservEntry@1008 : Record 337;ToRowID@1001 : Text[250];SwapSign@1006 : Boolean;SkipReservation@1007 : Boolean);
    VAR
      ReservEntry1@1000 : Record 337;
      TempReservEntry@1003 : TEMPORARY Record 337;
    BEGIN
      IF SkipReservation THEN
        ReservEntry.SETFILTER("Reservation Status",'<>%1',ReservEntry."Reservation Status"::Reservation);
      IF ReservEntry.FINDSET THEN BEGIN
        REPEAT
          IF ReservEntry.TrackingExists THEN BEGIN
            TempReservEntry := ReservEntry;
            TempReservEntry."Reservation Status" := TempReservEntry."Reservation Status"::Prospect;
            TempReservEntry.SetPointer(ToRowID);
            IF SwapSign THEN BEGIN
              TempReservEntry."Quantity (Base)" := -TempReservEntry."Quantity (Base)";
              TempReservEntry.Quantity := -TempReservEntry.Quantity;
              TempReservEntry."Qty. to Handle (Base)" := -TempReservEntry."Qty. to Handle (Base)";
              TempReservEntry."Qty. to Invoice (Base)" := -TempReservEntry."Qty. to Invoice (Base)";
              TempReservEntry."Quantity Invoiced (Base)" := -TempReservEntry."Quantity Invoiced (Base)";
              TempReservEntry.Positive := TempReservEntry."Quantity (Base)" > 0;
              TempReservEntry.ClearApplFromToItemEntry;
            END;
            TempReservEntry.INSERT;
          END;
        UNTIL ReservEntry.NEXT = 0;

        ModifyTemp337SetIfTransfer(TempReservEntry);

        IF TempReservEntry.FINDSET THEN BEGIN
          ReservEntry1.RESET;
          REPEAT
            ReservEntry1 := TempReservEntry;
            ReservEntry1."Entry No." := 0;
            ReservEntry1.INSERT;
          UNTIL TempReservEntry.NEXT = 0;
        END;
      END;
    END;

    [External]
    PROCEDURE CopyHandledItemTrkgToInvLine@1(FromSalesLine@1000 : Record 37;ToSalesInvLine@1001 : Record 37);
    VAR
      ItemEntryRelation@1003 : Record 6507;
    BEGIN
      // Used for combined shipment/returns:
      IF FromSalesLine.Type <> FromSalesLine.Type::Item THEN
        EXIT;

      CASE ToSalesInvLine."Document Type" OF
        ToSalesInvLine."Document Type"::Invoice:
          BEGIN
            ItemEntryRelation.SetSourceFilter(
              DATABASE::"Sales Shipment Line",0,ToSalesInvLine."Shipment No.",ToSalesInvLine."Shipment Line No.",TRUE);
            ItemEntryRelation.SetSourceFilter2('',0);
          END;
        ToSalesInvLine."Document Type"::"Credit Memo":
          BEGIN
            ItemEntryRelation.SetSourceFilter(
              DATABASE::"Return Receipt Line",0,ToSalesInvLine."Return Receipt No.",ToSalesInvLine."Return Receipt Line No.",TRUE);
            ItemEntryRelation.SetSourceFilter2('',0);
          END;
        ELSE
          ToSalesInvLine.FIELDERROR("Document Type",FORMAT(ToSalesInvLine."Document Type"));
      END;

      InsertProspectReservEntryFromItemEntryRelationAndSourceData(
        ItemEntryRelation,ToSalesInvLine."Document Type",ToSalesInvLine."Document No.",ToSalesInvLine."Line No.");
    END;

    [External]
    PROCEDURE CopyHandledItemTrkgToInvLine2@43(FromPurchLine@1000 : Record 39;ToPurchLine@1001 : Record 39);
    BEGIN
      CopyHandledItemTrkgToPurchLine(FromPurchLine,ToPurchLine,FALSE);
    END;

    [External]
    PROCEDURE CopyHandledItemTrkgToPurchLineWithLineQty@25(FromPurchLine@1000 : Record 39;ToPurchLine@1002 : Record 39);
    BEGIN
      CopyHandledItemTrkgToPurchLine(FromPurchLine,ToPurchLine,TRUE);
    END;

    LOCAL PROCEDURE CopyHandledItemTrkgToPurchLine@16(FromPurchLine@1000 : Record 39;ToPurchLine@1001 : Record 39;CheckLineQty@1004 : Boolean);
    VAR
      ItemEntryRelation@1003 : Record 6507;
      TrackingSpecification@1002 : Record 336;
      QtyBase@1005 : Decimal;
    BEGIN
      // Used for combined receipts/returns:
      IF FromPurchLine.Type <> FromPurchLine.Type::Item THEN
        EXIT;

      CASE ToPurchLine."Document Type" OF
        ToPurchLine."Document Type"::Invoice:
          BEGIN
            ItemEntryRelation.SetSourceFilter(
              DATABASE::"Purch. Rcpt. Line",0,ToPurchLine."Receipt No.",ToPurchLine."Receipt Line No.",TRUE);
            ItemEntryRelation.SetSourceFilter2('',0);
          END;
        ToPurchLine."Document Type"::"Credit Memo":
          BEGIN
            ItemEntryRelation.SetSourceFilter(
              DATABASE::"Return Shipment Line",0,ToPurchLine."Return Shipment No.",ToPurchLine."Return Shipment Line No.",TRUE);
            ItemEntryRelation.SetSourceFilter2('',0);
          END;
        ELSE
          ToPurchLine.FIELDERROR("Document Type",FORMAT(ToPurchLine."Document Type"));
      END;

      IF NOT ItemEntryRelation.FINDSET THEN
        EXIT;

      REPEAT
        TrackingSpecification.GET(ItemEntryRelation."Item Entry No.");
        QtyBase := TrackingSpecification."Quantity (Base)" - TrackingSpecification."Quantity Invoiced (Base)";
        IF CheckLineQty AND (QtyBase > ToPurchLine.Quantity) THEN
          QtyBase := ToPurchLine.Quantity;
        InsertReservEntryFromTrackingSpec(
          TrackingSpecification,ToPurchLine."Document Type",ToPurchLine."Document No.",ToPurchLine."Line No.",QtyBase);
      UNTIL ItemEntryRelation.NEXT = 0;
    END;

    [External]
    PROCEDURE CopyHandledItemTrkgToServLine@93(FromServLine@1000 : Record 5902;ToServLine@1001 : Record 5902);
    VAR
      ItemEntryRelation@1003 : Record 6507;
    BEGIN
      // Used for combined shipment/returns:
      IF FromServLine.Type <> FromServLine.Type::Item THEN
        EXIT;

      CASE ToServLine."Document Type" OF
        ToServLine."Document Type"::Invoice:
          BEGIN
            ItemEntryRelation.SetSourceFilter(
              DATABASE::"Service Shipment Line",0,ToServLine."Shipment No.",ToServLine."Shipment Line No.",TRUE);
            ItemEntryRelation.SetSourceFilter2('',0);
          END;
        ELSE
          ToServLine.FIELDERROR("Document Type",FORMAT(ToServLine."Document Type"));
      END;

      InsertProspectReservEntryFromItemEntryRelationAndSourceData(
        ItemEntryRelation,ToServLine."Document Type",ToServLine."Document No.",ToServLine."Line No.");
    END;

    [External]
    PROCEDURE CollectItemEntryRelation@37(VAR TempItemLedgEntry@1000 : TEMPORARY Record 32;SourceType@1002 : Integer;SourceSubtype@1003 : Integer;SourceID@1004 : Code[20];SourceBatchName@1005 : Code[10];SourceProdOrderLine@1007 : Integer;SourceRefNo@1006 : Integer;TotalQty@1010 : Decimal) : Boolean;
    VAR
      ItemLedgEntry@1001 : Record 32;
      ItemEntryRelation@1008 : Record 6507;
      Quantity@1011 : Decimal;
    BEGIN
      Quantity := 0;
      TempItemLedgEntry.RESET;
      TempItemLedgEntry.DELETEALL;
      ItemEntryRelation.SetSourceFilter(SourceType,SourceSubtype,SourceID,SourceRefNo,TRUE);
      ItemEntryRelation.SetSourceFilter2(SourceBatchName,SourceProdOrderLine);
      IF ItemEntryRelation.FINDSET THEN
        REPEAT
          ItemLedgEntry.GET(ItemEntryRelation."Item Entry No.");
          TempItemLedgEntry := ItemLedgEntry;
          TempItemLedgEntry.INSERT;
          Quantity := Quantity + ItemLedgEntry.Quantity;
        UNTIL ItemEntryRelation.NEXT = 0;
      EXIT(Quantity = TotalQty);
    END;

    [External]
    PROCEDURE IsOrderNetworkEntity@19(Type@1002 : Integer;Subtype@1000 : Integer) : Boolean;
    BEGIN
      CASE Type OF
        DATABASE::"Sales Line":
          EXIT(Subtype IN [1,5]);
        DATABASE::"Purchase Line":
          EXIT(Subtype IN [1,5]);
        DATABASE::"Prod. Order Line":
          EXIT(Subtype IN [2,3]);
        DATABASE::"Prod. Order Component":
          EXIT(Subtype IN [2,3]);
        DATABASE::"Assembly Header":
          EXIT(Subtype IN [1]);
        DATABASE::"Assembly Line":
          EXIT(Subtype IN [1]);
        DATABASE::"Transfer Line":
          EXIT(TRUE);
        DATABASE::"Service Line":
          EXIT(Subtype IN [1]);
        ELSE
          EXIT(FALSE);
      END;
    END;

    [External]
    PROCEDURE DeleteItemEntryRelation@3(SourceType@1006 : Integer;SourceSubtype@1005 : Integer;SourceID@1004 : Code[20];SourceBatchName@1003 : Code[10];SourceProdOrderLine@1002 : Integer;SourceRefNo@1001 : Integer;DeleteAllDocLines@1007 : Boolean);
    VAR
      ItemEntryRelation@1000 : Record 6507;
    BEGIN
      ItemEntryRelation.SetSourceFilter(SourceType,SourceSubtype,SourceID,-1,TRUE);
      IF DeleteAllDocLines THEN
        ItemEntryRelation.SetSourceFilter(SourceType,SourceSubtype,SourceID,-1,TRUE)
      ELSE
        ItemEntryRelation.SetSourceFilter(SourceType,SourceSubtype,SourceID,SourceRefNo,TRUE);
      ItemEntryRelation.SetSourceFilter2(SourceBatchName,SourceProdOrderLine);
      IF NOT ItemEntryRelation.ISEMPTY THEN
        ItemEntryRelation.DELETEALL;
    END;

    [External]
    PROCEDURE DeleteValueEntryRelation@22(RowID@1001 : Text[100]);
    VAR
      ValueEntryRelation@1000 : Record 6508;
    BEGIN
      ValueEntryRelation.SETCURRENTKEY("Source RowId");
      ValueEntryRelation.SETRANGE("Source RowId",RowID);
      IF NOT ValueEntryRelation.ISEMPTY THEN
        ValueEntryRelation.DELETEALL;
    END;

    [External]
    PROCEDURE FindInInventory@24(ItemNo@1000 : Code[20];VariantCode@1001 : Code[20];SerialNo@1002 : Code[20]) : Boolean;
    VAR
      ItemLedgerEntry@1004 : Record 32;
    BEGIN
      ItemLedgerEntry.RESET;
      ItemLedgerEntry.SETCURRENTKEY("Item No.",Open,"Variant Code",Positive);
      ItemLedgerEntry.SETRANGE("Item No.",ItemNo);
      ItemLedgerEntry.SETRANGE(Open,TRUE);
      ItemLedgerEntry.SETRANGE("Variant Code",VariantCode);
      ItemLedgerEntry.SETRANGE(Positive,TRUE);
      IF SerialNo <> '' THEN
        ItemLedgerEntry.SETRANGE("Serial No.",SerialNo);
      EXIT(ItemLedgerEntry.FINDFIRST);
    END;

    [External]
    PROCEDURE SplitWhseJnlLine@29(TempWhseJnlLine@1000 : TEMPORARY Record 7311;VAR TempWhseJnlLine2@1004 : TEMPORARY Record 7311;VAR TempWhseSplitSpecification@1001 : TEMPORARY Record 336;ToTransfer@1010 : Boolean);
    VAR
      NonDistrQtyBase@1006 : Decimal;
      NonDistrCubage@1007 : Decimal;
      NonDistrWeight@1008 : Decimal;
      SplitFactor@1009 : Decimal;
      LineNo@1002 : Integer;
      WhseSNRequired@1003 : Boolean;
      WhseLNRequired@1005 : Boolean;
    BEGIN
      TempWhseJnlLine2.DELETEALL;

      CheckWhseItemTrkgSetup(TempWhseJnlLine."Item No.",WhseSNRequired,WhseLNRequired,FALSE);
      IF NOT (WhseSNRequired OR WhseLNRequired) THEN BEGIN
        TempWhseJnlLine2 := TempWhseJnlLine;
        TempWhseJnlLine2.INSERT;
        EXIT;
      END;

      LineNo := TempWhseJnlLine."Line No.";
      WITH TempWhseSplitSpecification DO BEGIN
        RESET;
        CASE TempWhseJnlLine."Source Type" OF
          DATABASE::"Item Journal Line",
          DATABASE::"Job Journal Line":
            SetSourceFilter(
              TempWhseJnlLine."Source Type",-1,TempWhseJnlLine."Journal Template Name",TempWhseJnlLine."Source Line No.",TRUE);
          0: // Whse. journal line
            SetSourceFilter(
              DATABASE::"Warehouse Journal Line",-1,TempWhseJnlLine."Journal Batch Name",TempWhseJnlLine."Line No.",TRUE);
          ELSE
            SetSourceFilter(
              TempWhseJnlLine."Source Type",-1,TempWhseJnlLine."Source No.",TempWhseJnlLine."Source Line No.",TRUE);
        END;
        SETFILTER("Quantity actual Handled (Base)",'<>%1',0);
        NonDistrQtyBase := TempWhseJnlLine."Qty. (Absolute, Base)";
        NonDistrCubage := TempWhseJnlLine.Cubage;
        NonDistrWeight := TempWhseJnlLine.Weight;
        IF FINDSET THEN
          REPEAT
            LineNo += 10000;
            TempWhseJnlLine2 := TempWhseJnlLine;
            TempWhseJnlLine2."Line No." := LineNo;

            IF "Serial No." <> '' THEN
              IF ABS("Quantity (Base)") <> 1 THEN
                FIELDERROR("Quantity (Base)");

            IF ToTransfer THEN BEGIN
              SetWhseSerialLotNo(TempWhseJnlLine2."Serial No.","New Serial No.",WhseSNRequired);
              SetWhseSerialLotNo(TempWhseJnlLine2."Lot No.","New Lot No.",WhseLNRequired);
              IF "New Expiration Date" <> 0D THEN
                TempWhseJnlLine2."Expiration Date" := "New Expiration Date"
            END ELSE BEGIN
              SetWhseSerialLotNo(TempWhseJnlLine2."Serial No.","Serial No.",WhseSNRequired);
              SetWhseSerialLotNo(TempWhseJnlLine2."Lot No.","Lot No.",WhseLNRequired);
              TempWhseJnlLine2."Expiration Date" := "Expiration Date";
            END;
            SetWhseSerialLotNo(TempWhseJnlLine2."New Serial No.","New Serial No.",WhseSNRequired);
            SetWhseSerialLotNo(TempWhseJnlLine2."New Lot No.","New Lot No.",WhseLNRequired);
            TempWhseJnlLine2."New Expiration Date" := "New Expiration Date";
            TempWhseJnlLine2."Warranty Date" := "Warranty Date";
            TempWhseJnlLine2."Qty. (Absolute, Base)" := ABS("Quantity (Base)");
            TempWhseJnlLine2."Qty. (Absolute)" :=
              ROUND(TempWhseJnlLine2."Qty. (Absolute, Base)" / TempWhseJnlLine."Qty. per Unit of Measure",0.00001);
            IF TempWhseJnlLine.Quantity > 0 THEN BEGIN
              TempWhseJnlLine2."Qty. (Base)" := TempWhseJnlLine2."Qty. (Absolute, Base)";
              TempWhseJnlLine2.Quantity := TempWhseJnlLine2."Qty. (Absolute)";
            END ELSE BEGIN
              TempWhseJnlLine2."Qty. (Base)" := -TempWhseJnlLine2."Qty. (Absolute, Base)";
              TempWhseJnlLine2.Quantity := -TempWhseJnlLine2."Qty. (Absolute)";
            END;
            SplitFactor := "Quantity (Base)" / NonDistrQtyBase;
            IF SplitFactor < 1 THEN BEGIN
              TempWhseJnlLine2.Cubage := ROUND(NonDistrCubage * SplitFactor,0.00001);
              TempWhseJnlLine2.Weight := ROUND(NonDistrWeight * SplitFactor,0.00001);
              NonDistrQtyBase -= "Quantity (Base)";
              NonDistrCubage -= TempWhseJnlLine2.Cubage;
              NonDistrWeight -= TempWhseJnlLine2.Weight;
            END ELSE BEGIN // the last record
              TempWhseJnlLine2.Cubage := NonDistrCubage;
              TempWhseJnlLine2.Weight := NonDistrWeight;
            END;
            TempWhseJnlLine2.INSERT;
          UNTIL NEXT = 0
        ELSE BEGIN
          TempWhseJnlLine2 := TempWhseJnlLine;
          TempWhseJnlLine2.INSERT;
        END;
      END;
    END;

    [External]
    PROCEDURE SplitPostedWhseRcptLine@26(PostedWhseRcptLine@1005 : Record 7319;VAR TempPostedWhseRcptLine@1000 : TEMPORARY Record 7319);
    VAR
      WhseItemEntryRelation@1001 : Record 6509;
      ItemLedgEntry@1004 : Record 32;
      LineNo@1003 : Integer;
      WhseSNRequired@1006 : Boolean;
      WhseLNRequired@1002 : Boolean;
      CrossDockQty@1007 : Decimal;
      CrossDockQtyBase@1008 : Decimal;
    BEGIN
      TempPostedWhseRcptLine.RESET;
      TempPostedWhseRcptLine.DELETEALL;

      CheckWhseItemTrkgSetup(PostedWhseRcptLine."Item No.",WhseSNRequired,WhseLNRequired,FALSE);
      IF NOT (WhseSNRequired OR WhseLNRequired) THEN BEGIN
        TempPostedWhseRcptLine := PostedWhseRcptLine;
        TempPostedWhseRcptLine.INSERT;
        EXIT;
      END;

      WhseItemEntryRelation.RESET;
      WhseItemEntryRelation.SetSourceFilter(
        DATABASE::"Posted Whse. Receipt Line",0,PostedWhseRcptLine."No.",PostedWhseRcptLine."Line No.",TRUE);
      IF WhseItemEntryRelation.FINDSET THEN BEGIN
        REPEAT
          ItemLedgEntry.GET(WhseItemEntryRelation."Item Entry No.");
          TempPostedWhseRcptLine.SETRANGE("Serial No.",ItemLedgEntry."Serial No.");
          TempPostedWhseRcptLine.SETRANGE("Lot No.",ItemLedgEntry."Lot No.");
          TempPostedWhseRcptLine.SETRANGE("Warranty Date",ItemLedgEntry."Warranty Date");
          TempPostedWhseRcptLine.SETRANGE("Expiration Date",ItemLedgEntry."Expiration Date");
          IF TempPostedWhseRcptLine.FINDFIRST THEN BEGIN
            TempPostedWhseRcptLine."Qty. (Base)" += ItemLedgEntry.Quantity;
            TempPostedWhseRcptLine.Quantity :=
              ROUND(TempPostedWhseRcptLine."Qty. (Base)" / TempPostedWhseRcptLine."Qty. per Unit of Measure",0.00001);
            TempPostedWhseRcptLine.MODIFY;

            CrossDockQty := CrossDockQty - TempPostedWhseRcptLine."Qty. Cross-Docked";
            CrossDockQtyBase := CrossDockQtyBase - TempPostedWhseRcptLine."Qty. Cross-Docked (Base)";
          END ELSE BEGIN
            LineNo += 10000;
            TempPostedWhseRcptLine.RESET;
            TempPostedWhseRcptLine := PostedWhseRcptLine;
            TempPostedWhseRcptLine."Line No." := LineNo;
            TempPostedWhseRcptLine.SetTracking(
              WhseItemEntryRelation."Serial No.",WhseItemEntryRelation."Lot No.",
              ItemLedgEntry."Warranty Date",ItemLedgEntry."Expiration Date");
            TempPostedWhseRcptLine."Qty. (Base)" := ItemLedgEntry.Quantity;
            TempPostedWhseRcptLine.Quantity :=
              ROUND(TempPostedWhseRcptLine."Qty. (Base)" / TempPostedWhseRcptLine."Qty. per Unit of Measure",0.00001);
            TempPostedWhseRcptLine.INSERT;
          END;

          IF WhseSNRequired THEN BEGIN
            IF CrossDockQty < PostedWhseRcptLine."Qty. Cross-Docked" THEN BEGIN
              TempPostedWhseRcptLine."Qty. Cross-Docked" := TempPostedWhseRcptLine.Quantity;
              TempPostedWhseRcptLine."Qty. Cross-Docked (Base)" := TempPostedWhseRcptLine."Qty. (Base)";
            END ELSE BEGIN
              TempPostedWhseRcptLine."Qty. Cross-Docked" := 0;
              TempPostedWhseRcptLine."Qty. Cross-Docked (Base)" := 0;
            END;
            CrossDockQty := CrossDockQty + TempPostedWhseRcptLine.Quantity;
          END ELSE
            IF PostedWhseRcptLine."Qty. Cross-Docked" > 0 THEN BEGIN
              IF TempPostedWhseRcptLine.Quantity <=
                 PostedWhseRcptLine."Qty. Cross-Docked" - CrossDockQty
              THEN BEGIN
                TempPostedWhseRcptLine."Qty. Cross-Docked" := TempPostedWhseRcptLine.Quantity;
                TempPostedWhseRcptLine."Qty. Cross-Docked (Base)" := TempPostedWhseRcptLine."Qty. (Base)";
              END ELSE BEGIN
                TempPostedWhseRcptLine."Qty. Cross-Docked" := PostedWhseRcptLine."Qty. Cross-Docked" - CrossDockQty;
                TempPostedWhseRcptLine."Qty. Cross-Docked (Base)" :=
                  PostedWhseRcptLine."Qty. Cross-Docked (Base)" - CrossDockQtyBase;
              END;
              CrossDockQty := CrossDockQty + TempPostedWhseRcptLine."Qty. Cross-Docked";
              CrossDockQtyBase := CrossDockQtyBase + TempPostedWhseRcptLine."Qty. Cross-Docked (Base)";
              IF CrossDockQty >= PostedWhseRcptLine."Qty. Cross-Docked" THEN BEGIN
                PostedWhseRcptLine."Qty. Cross-Docked" := 0;
                PostedWhseRcptLine."Qty. Cross-Docked (Base)" := 0;
              END;
            END;
          TempPostedWhseRcptLine.MODIFY;
        UNTIL WhseItemEntryRelation.NEXT = 0;
      END ELSE BEGIN
        TempPostedWhseRcptLine := PostedWhseRcptLine;
        TempPostedWhseRcptLine.INSERT;
      END
    END;

    [External]
    PROCEDURE SplitInternalPutAwayLine@27(PostedWhseRcptLine@1005 : Record 7319;VAR TempPostedWhseRcptLine@1000 : TEMPORARY Record 7319);
    VAR
      WhseItemTrackingLine@1001 : Record 6550;
      LineNo@1003 : Integer;
      WhseSNRequired@1004 : Boolean;
      WhseLNRequired@1002 : Boolean;
    BEGIN
      TempPostedWhseRcptLine.DELETEALL;

      CheckWhseItemTrkgSetup(PostedWhseRcptLine."Item No.",WhseSNRequired,WhseLNRequired,FALSE);
      IF NOT (WhseSNRequired OR WhseLNRequired) THEN BEGIN
        TempPostedWhseRcptLine := PostedWhseRcptLine;
        TempPostedWhseRcptLine.INSERT;
        EXIT;
      END;

      WhseItemTrackingLine.RESET;
      WhseItemTrackingLine.SetSourceFilter(
        DATABASE::"Whse. Internal Put-away Line",0,PostedWhseRcptLine."No.",PostedWhseRcptLine."Line No.",TRUE);
      WhseItemTrackingLine.SetSourceFilter2('',0);
      WhseItemTrackingLine.SETFILTER("Qty. to Handle (Base)",'<>0');
      IF WhseItemTrackingLine.FINDSET THEN
        REPEAT
          LineNo += 10000;
          TempPostedWhseRcptLine := PostedWhseRcptLine;
          TempPostedWhseRcptLine."Line No." := LineNo;
          TempPostedWhseRcptLine.SetTracking(
            WhseItemTrackingLine."Serial No.",WhseItemTrackingLine."Lot No.",
            WhseItemTrackingLine."Warranty Date",WhseItemTrackingLine."Expiration Date");
          TempPostedWhseRcptLine."Qty. (Base)" := WhseItemTrackingLine."Qty. to Handle (Base)";
          TempPostedWhseRcptLine.Quantity :=
            ROUND(TempPostedWhseRcptLine."Qty. (Base)" / TempPostedWhseRcptLine."Qty. per Unit of Measure",0.00001);
          TempPostedWhseRcptLine.INSERT;
        UNTIL WhseItemTrackingLine.NEXT = 0
      ELSE BEGIN
        TempPostedWhseRcptLine := PostedWhseRcptLine;
        TempPostedWhseRcptLine.INSERT;
      END
    END;

    [External]
    PROCEDURE DeleteWhseItemTrkgLines@28(SourceType@1000 : Integer;SourceSubtype@1002 : Integer;SourceID@1001 : Code[20];SourceBatchName@1007 : Code[10];SourceProdOrderLine@1003 : Integer;SourceRefNo@1005 : Integer;LocationCode@1006 : Code[10];RelatedToLine@1008 : Boolean);
    VAR
      WhseItemTrkgLine@1004 : Record 6550;
    BEGIN
      WITH WhseItemTrkgLine DO BEGIN
        RESET;
        SetSourceFilter(SourceType,SourceSubtype,SourceID,-1,TRUE);
        IF RelatedToLine THEN BEGIN
          SetSourceFilter2(SourceBatchName,SourceProdOrderLine);
          SETRANGE("Source Ref. No.",SourceRefNo);
          SETRANGE("Location Code",LocationCode);
        END;

        IF FINDSET THEN
          REPEAT
            // If the item tracking information was added through a pick registration, the reservation entry needs to
            // be modified/deleted as well in order to remove this item tracking information again.
            IF DeleteReservationEntries AND
               "Created by Whse. Activity Line" AND
               ("Source Type" = DATABASE::"Warehouse Shipment Line")
            THEN
              RemoveItemTrkgFromReservEntry(WhseItemTrkgLine);
            DELETE;
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE RemoveItemTrkgFromReservEntry@104(WhseItemTrackingLine@1002 : Record 6550);
    VAR
      ReservEntry@1001 : Record 337;
      WarehouseShipmentLine@1003 : Record 7321;
    BEGIN
      WarehouseShipmentLine.SETRANGE("No.",WhseItemTrackingLine."Source ID");
      WarehouseShipmentLine.SETRANGE("Line No.",WhseItemTrackingLine."Source Ref. No.");
      IF NOT WarehouseShipmentLine.FINDFIRST THEN
        EXIT;

      ReservEntry.SetSourceFilter(
        WarehouseShipmentLine."Source Type",WarehouseShipmentLine."Source Subtype",
        WarehouseShipmentLine."Source No.",WarehouseShipmentLine."Source Line No.",TRUE);
      ReservEntry.SetTrackingFilterFromWhseSpec(WhseItemTrackingLine);
      IF ReservEntry.FINDSET THEN
        REPEAT
          CASE ReservEntry."Reservation Status" OF
            ReservEntry."Reservation Status"::Surplus:
              ReservEntry.DELETE(TRUE);
            ELSE BEGIN
              ReservEntry.ClearItemTrackingFields;
              ReservEntry.MODIFY(TRUE);
            END;
          END;
        UNTIL ReservEntry.NEXT = 0;
    END;

    [External]
    PROCEDURE SetDeleteReservationEntries@105(DeleteEntries@1000 : Boolean);
    BEGIN
      DeleteReservationEntries := DeleteEntries;
    END;

    [External]
    PROCEDURE InitTrackingSpecification@34(WhseWkshLine@1000 : Record 7326);
    VAR
      WhseItemTrkgLine@1002 : Record 6550;
      PostedWhseReceiptLine@1003 : Record 7319;
      TempWhseItemTrkgLine@1004 : TEMPORARY Record 6550;
      WhseManagement@1005 : Codeunit 5775;
      SourceType@1001 : Integer;
    BEGIN
      SourceType := WhseManagement.GetSourceType(WhseWkshLine);
      WITH WhseWkshLine DO BEGIN
        IF "Whse. Document Type" = "Whse. Document Type"::Receipt THEN BEGIN
          PostedWhseReceiptLine.SETRANGE("No.","Whse. Document No.");
          PostedWhseReceiptLine.SETRANGE("Line No.","Whse. Document Line No.");
          IF PostedWhseReceiptLine.FINDFIRST THEN
            InsertWhseItemTrkgLines(PostedWhseReceiptLine,SourceType);
        END;

        IF SourceType = DATABASE::"Prod. Order Component" THEN BEGIN
          WhseItemTrkgLine.SetSourceFilter(SourceType,"Source Subtype","Source No.","Source Subline No.",TRUE);
          WhseItemTrkgLine.SETRANGE("Source Prod. Order Line","Source Line No.");
        END ELSE
          WhseItemTrkgLine.SetSourceFilter(SourceType,-1,"Whse. Document No.","Whse. Document Line No.",TRUE);

        WhseItemTrkgLine.LOCKTABLE;
        IF WhseItemTrkgLine.FINDSET THEN BEGIN
          REPEAT
            CalcWhseItemTrkgLine(WhseItemTrkgLine);
            WhseItemTrkgLine.MODIFY;
            IF SourceType IN [DATABASE::"Prod. Order Component",DATABASE::"Assembly Line"] THEN BEGIN
              TempWhseItemTrkgLine := WhseItemTrkgLine;
              TempWhseItemTrkgLine.INSERT;
            END;
          UNTIL WhseItemTrkgLine.NEXT = 0;
          IF NOT TempWhseItemTrkgLine.ISEMPTY THEN
            CheckWhseItemTrkg(TempWhseItemTrkgLine,WhseWkshLine);
        END ELSE
          CASE SourceType OF
            DATABASE::"Posted Whse. Receipt Line":
              CreateWhseItemTrkgForReceipt(WhseWkshLine);
            DATABASE::"Warehouse Shipment Line":
              CreateWhseItemTrkgBatch(WhseWkshLine);
            DATABASE::"Prod. Order Component":
              CreateWhseItemTrkgBatch(WhseWkshLine);
            DATABASE::"Assembly Line":
              CreateWhseItemTrkgBatch(WhseWkshLine);
          END;
      END;
    END;

    LOCAL PROCEDURE CreateWhseItemTrkgForReceipt@33(WhseWkshLine@1002 : Record 7326);
    VAR
      ItemLedgEntry@1001 : Record 32;
      WhseItemEntryRelation@1000 : Record 6509;
      WhseItemTrackingLine@1003 : Record 6550;
      EntryNo@1004 : Integer;
    BEGIN
      WITH WhseWkshLine DO BEGIN
        WhseItemTrackingLine.RESET;
        IF WhseItemTrackingLine.FINDLAST THEN
          EntryNo := WhseItemTrackingLine."Entry No.";

        WhseItemEntryRelation.SetSourceFilter(
          DATABASE::"Posted Whse. Receipt Line",0,"Whse. Document No.","Whse. Document Line No.",TRUE);
        IF WhseItemEntryRelation.FINDSET THEN
          REPEAT
            WhseItemTrackingLine.INIT;
            EntryNo += 1;
            WhseItemTrackingLine."Entry No." := EntryNo;
            WhseItemTrackingLine."Item No." := "Item No.";
            WhseItemTrackingLine."Variant Code" := "Variant Code";
            WhseItemTrackingLine."Location Code" := "Location Code";
            WhseItemTrackingLine.Description := Description;
            WhseItemTrackingLine."Qty. per Unit of Measure" := "Qty. per From Unit of Measure";
            WhseItemTrackingLine.SetSource(
              DATABASE::"Posted Whse. Receipt Line",0,"Whse. Document No.","Whse. Document Line No.",'',0);
            ItemLedgEntry.GET(WhseItemEntryRelation."Item Entry No.");
            WhseItemTrackingLine.CopyTrackingFromItemLedgEntry(ItemLedgEntry);
            WhseItemTrackingLine."Quantity (Base)" := ItemLedgEntry.Quantity;
            IF "Qty. (Base)" = "Qty. to Handle (Base)" THEN
              WhseItemTrackingLine."Qty. to Handle (Base)" := WhseItemTrackingLine."Quantity (Base)";
            WhseItemTrackingLine."Qty. to Handle" :=
              ROUND(WhseItemTrackingLine."Qty. to Handle (Base)" / WhseItemTrackingLine."Qty. per Unit of Measure",0.00001);
            WhseItemTrackingLine.INSERT;
          UNTIL WhseItemEntryRelation.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE CreateWhseItemTrkgBatch@31(WhseWkshLine@1001 : Record 7326);
    VAR
      SourceItemTrackingLine@1000 : Record 337;
      WhseManagement@1004 : Codeunit 5775;
      SourceType@1005 : Integer;
    BEGIN
      SourceType := WhseManagement.GetSourceType(WhseWkshLine);

      WITH WhseWkshLine DO BEGIN
        CASE SourceType OF
          DATABASE::"Prod. Order Component":
            BEGIN
              SourceItemTrackingLine.SetSourceFilter("Source Type","Source Subtype","Source No.","Source Subline No.",TRUE);
              SourceItemTrackingLine.SetSourceFilter2('',"Source Line No.");
            END;
          ELSE BEGIN
            SourceItemTrackingLine.SetSourceFilter("Source Type","Source Subtype","Source No.","Source Line No.",TRUE);
            SourceItemTrackingLine.SetSourceFilter2('',0);
          END;
        END;
        IF SourceItemTrackingLine.FINDSET THEN
          REPEAT
            CreateWhseItemTrkgForResEntry(SourceItemTrackingLine,WhseWkshLine);
          UNTIL SourceItemTrackingLine.NEXT = 0;
      END;
    END;

    [External]
    PROCEDURE CreateWhseItemTrkgForResEntry@92(SourceReservEntry@1000 : Record 337;WhseWkshLine@1004 : Record 7326);
    VAR
      WhseItemTrackingLine@1003 : Record 6550;
      WhseManagement@1001 : Codeunit 5775;
      EntryNo@1002 : Integer;
      SourceType@1005 : Integer;
    BEGIN
      IF NOT ((SourceReservEntry."Reservation Status" <> SourceReservEntry."Reservation Status"::Reservation) OR
              IsResEntryReservedAgainstInventory(SourceReservEntry))
      THEN
        EXIT;

      IF NOT SourceReservEntry.TrackingExists THEN
        EXIT;

      SourceType := WhseManagement.GetSourceType(WhseWkshLine);

      IF WhseItemTrackingLine.FINDLAST THEN
        EntryNo := WhseItemTrackingLine."Entry No.";

      WhseItemTrackingLine.INIT;

      WITH WhseWkshLine DO
        CASE SourceType OF
          DATABASE::"Posted Whse. Receipt Line":
            WhseItemTrackingLine.SetSource(
              DATABASE::"Posted Whse. Receipt Line",0,"Whse. Document No.","Whse. Document Line No.",'',0);
          DATABASE::"Warehouse Shipment Line":
            WhseItemTrackingLine.SetSource(
              DATABASE::"Warehouse Shipment Line",0,"Whse. Document No.","Whse. Document Line No.",'',0);
          DATABASE::"Assembly Line":
            WhseItemTrackingLine.SetSource(
              DATABASE::"Assembly Line","Source Subtype","Whse. Document No.","Whse. Document Line No.",'',0);
          DATABASE::"Prod. Order Component":
            WhseItemTrackingLine.SetSource(
              "Source Type","Source Subtype","Source No.","Source Subline No.",'',"Source Line No.");
        END;

      WhseItemTrackingLine."Entry No." := EntryNo + 1;
      WhseItemTrackingLine."Item No." := SourceReservEntry."Item No.";
      WhseItemTrackingLine."Variant Code" := SourceReservEntry."Variant Code";
      WhseItemTrackingLine."Location Code" := SourceReservEntry."Location Code";
      WhseItemTrackingLine.Description := SourceReservEntry.Description;
      WhseItemTrackingLine."Qty. per Unit of Measure" := SourceReservEntry."Qty. per Unit of Measure";
      WhseItemTrackingLine.CopyTrackingFromReservEntry(SourceReservEntry);
      WhseItemTrackingLine."Quantity (Base)" := -SourceReservEntry."Quantity (Base)";

      IF WhseWkshLine."Qty. Handled (Base)" <> 0 THEN BEGIN
        WhseItemTrackingLine."Quantity Handled (Base)" := WhseWkshLine."Qty. Handled (Base)";
        WhseItemTrackingLine."Qty. Registered (Base)" := WhseWkshLine."Qty. Handled (Base)";
      END ELSE
        IF WhseWkshLine."Qty. (Base)" = WhseWkshLine."Qty. to Handle (Base)" THEN BEGIN
          WhseItemTrackingLine."Qty. to Handle (Base)" := WhseItemTrackingLine."Quantity (Base)";
          WhseItemTrackingLine."Qty. to Handle" := -SourceReservEntry.Quantity;
        END;
      WhseItemTrackingLine.INSERT;
    END;

    [External]
    PROCEDURE CalcWhseItemTrkgLine@30(VAR WhseItemTrkgLine@1000 : Record 6550);
    VAR
      WhseActivQtyBase@1001 : Decimal;
    BEGIN
      CASE WhseItemTrkgLine."Source Type" OF
        DATABASE::"Posted Whse. Receipt Line":
          WhseItemTrkgLine."Source Type Filter" := WhseItemTrkgLine."Source Type Filter"::Receipt;
        DATABASE::"Whse. Internal Put-away Line":
          WhseItemTrkgLine."Source Type Filter" := WhseItemTrkgLine."Source Type Filter"::"Internal Put-away";
        DATABASE::"Warehouse Shipment Line":
          WhseItemTrkgLine."Source Type Filter" := WhseItemTrkgLine."Source Type Filter"::Shipment;
        DATABASE::"Whse. Internal Pick Line":
          WhseItemTrkgLine."Source Type Filter" := WhseItemTrkgLine."Source Type Filter"::"Internal Pick";
        DATABASE::"Prod. Order Component":
          WhseItemTrkgLine."Source Type Filter" := WhseItemTrkgLine."Source Type Filter"::Production;
        DATABASE::"Assembly Line":
          WhseItemTrkgLine."Source Type Filter" := WhseItemTrkgLine."Source Type Filter"::Assembly;
        DATABASE::"Whse. Worksheet Line":
          WhseItemTrkgLine."Source Type Filter" := WhseItemTrkgLine."Source Type Filter"::"Movement Worksheet";
      END;
      WhseItemTrkgLine.CALCFIELDS("Put-away Qty. (Base)","Pick Qty. (Base)");

      IF WhseItemTrkgLine."Put-away Qty. (Base)" > 0 THEN
        WhseActivQtyBase := WhseItemTrkgLine."Put-away Qty. (Base)";
      IF WhseItemTrkgLine."Pick Qty. (Base)" > 0 THEN
        WhseActivQtyBase := WhseItemTrkgLine."Pick Qty. (Base)";

      IF NOT Registering THEN
        WhseItemTrkgLine.VALIDATE("Quantity Handled (Base)",
          WhseActivQtyBase + WhseItemTrkgLine."Qty. Registered (Base)")
      ELSE
        WhseItemTrkgLine.VALIDATE("Quantity Handled (Base)",
          WhseItemTrkgLine."Qty. Registered (Base)");

      IF WhseItemTrkgLine."Quantity (Base)" >= WhseItemTrkgLine."Quantity Handled (Base)" THEN
        WhseItemTrkgLine.VALIDATE("Qty. to Handle (Base)",
          WhseItemTrkgLine."Quantity (Base)" - WhseItemTrkgLine."Quantity Handled (Base)");
    END;

    [External]
    PROCEDURE InitItemTrkgForTempWkshLine@36(WhseDocType@1000 : Option;WhseDocNo@1001 : Code[20];WhseDocLineNo@1002 : Integer;SourceType@1003 : Integer;SourceSubtype@1004 : Integer;SourceNo@1005 : Code[20];SourceLineNo@1006 : Integer;SourceSublineNo@1007 : Integer);
    VAR
      TempWhseWkshLine@1008 : Record 7326;
    BEGIN
      InitWhseWkshLine(TempWhseWkshLine,WhseDocType,WhseDocNo,WhseDocLineNo,SourceType,SourceSubtype,SourceNo,
        SourceLineNo,SourceSublineNo);
      InitTrackingSpecification(TempWhseWkshLine);
    END;

    [External]
    PROCEDURE InitWhseWkshLine@99(VAR WhseWkshLine@1009 : Record 7326;WhseDocType@1007 : Option;WhseDocNo@1006 : Code[20];WhseDocLineNo@1005 : Integer;SourceType@1004 : Integer;SourceSubtype@1003 : Integer;SourceNo@1002 : Code[20];SourceLineNo@1001 : Integer;SourceSublineNo@1000 : Integer);
    VAR
      ProdOrderComponent@1011 : Record 5407;
    BEGIN
      WhseWkshLine.INIT;
      WhseWkshLine."Whse. Document Type" := WhseDocType;
      WhseWkshLine."Whse. Document No." := WhseDocNo;
      WhseWkshLine."Whse. Document Line No." := WhseDocLineNo;
      WhseWkshLine."Source Type" := SourceType;
      WhseWkshLine."Source Subtype" := SourceSubtype;
      WhseWkshLine."Source No." := SourceNo;
      WhseWkshLine."Source Line No." := SourceLineNo;
      WhseWkshLine."Source Subline No." := SourceSublineNo;

      IF WhseDocType = WhseWkshLine."Whse. Document Type"::Production THEN BEGIN
        ProdOrderComponent.GET(SourceSubtype,SourceNo,SourceLineNo,SourceSublineNo);
        WhseWkshLine."Qty. Handled (Base)" := ProdOrderComponent."Qty. Picked (Base)";
      END;
    END;

    [External]
    PROCEDURE UpdateWhseItemTrkgLines@38(VAR TempWhseItemTrkgLine@1000 : TEMPORARY Record 6550);
    VAR
      WhseItemTrkgLine@1001 : Record 6550;
    BEGIN
      IF TempWhseItemTrkgLine.FINDSET THEN
        REPEAT
          WhseItemTrkgLine.SETCURRENTKEY("Serial No.","Lot No.");
          WhseItemTrkgLine.SetTrackingFilter(TempWhseItemTrkgLine."Serial No.",TempWhseItemTrkgLine."Lot No.");
          WhseItemTrkgLine.SetSourceFilter(
            TempWhseItemTrkgLine."Source Type",TempWhseItemTrkgLine."Source Subtype",TempWhseItemTrkgLine."Source ID",
            TempWhseItemTrkgLine."Source Ref. No.",FALSE);
          WhseItemTrkgLine.SetSourceFilter2(
            TempWhseItemTrkgLine."Source Batch Name",TempWhseItemTrkgLine."Source Prod. Order Line");
          WhseItemTrkgLine.LOCKTABLE;
          IF WhseItemTrkgLine.FINDFIRST THEN BEGIN
            CalcWhseItemTrkgLine(WhseItemTrkgLine);
            WhseItemTrkgLine.MODIFY;
          END;
        UNTIL TempWhseItemTrkgLine.NEXT = 0
    END;

    LOCAL PROCEDURE InsertWhseItemTrkgLines@48(PostedWhseReceiptLine@1000 : Record 7319;SourceType@1001 : Integer);
    VAR
      WhseItemTrkgLine@1003 : Record 6550;
      WhseItemEntryRelation@1002 : Record 6509;
      ItemLedgEntry@1005 : Record 32;
      EntryNo@1004 : Integer;
      QtyHandledBase@1007 : Decimal;
      RemQtyHandledBase@1006 : Decimal;
    BEGIN
      IF WhseItemTrkgLine.FINDLAST THEN
        EntryNo := WhseItemTrkgLine."Entry No." + 1
      ELSE
        EntryNo := 1;

      WITH PostedWhseReceiptLine DO BEGIN
        WhseItemEntryRelation.RESET;
        WhseItemEntryRelation.SetSourceFilter(SourceType,0,"No.","Line No.",TRUE);
        IF WhseItemEntryRelation.FINDSET THEN BEGIN
          WhseItemTrkgLine.SetSourceFilter(SourceType,0,"No.","Line No.",FALSE);
          WhseItemTrkgLine.DELETEALL;
          WhseItemTrkgLine.INIT;
          WhseItemTrkgLine.SETCURRENTKEY("Serial No.","Lot No.");
          REPEAT
            WhseItemTrkgLine.SetTrackingFilterFromRelation(WhseItemEntryRelation);
            ItemLedgEntry.GET(WhseItemEntryRelation."Item Entry No.");
            IF (WhseItemEntryRelation."Lot No." <> WhseItemTrkgLine."Lot No.") OR
               (WhseItemEntryRelation."Serial No." <> WhseItemTrkgLine."Serial No.")
            THEN
              RemQtyHandledBase := RegisteredPutAwayQtyBase(PostedWhseReceiptLine,WhseItemEntryRelation)
            ELSE
              RemQtyHandledBase -= QtyHandledBase;
            QtyHandledBase := RemQtyHandledBase;
            IF QtyHandledBase > ItemLedgEntry.Quantity THEN
              QtyHandledBase := ItemLedgEntry.Quantity;

            IF NOT WhseItemTrkgLine.FINDFIRST THEN BEGIN
              WhseItemTrkgLine.INIT;
              WhseItemTrkgLine."Entry No." := EntryNo;
              EntryNo := EntryNo + 1;

              WhseItemTrkgLine."Item No." := ItemLedgEntry."Item No.";
              WhseItemTrkgLine."Location Code" := ItemLedgEntry."Location Code";
              WhseItemTrkgLine.Description := ItemLedgEntry.Description;
              WhseItemTrkgLine.SetSource(
                WhseItemEntryRelation."Source Type",WhseItemEntryRelation."Source Subtype",WhseItemEntryRelation."Source ID",
                WhseItemEntryRelation."Source Ref. No.",WhseItemEntryRelation."Source Batch Name",
                WhseItemEntryRelation."Source Prod. Order Line");
              WhseItemTrkgLine.SetTracking(
                WhseItemEntryRelation."Serial No.",WhseItemEntryRelation."Lot No.",
                ItemLedgEntry."Warranty Date",ItemLedgEntry."Expiration Date");
              WhseItemTrkgLine."Qty. per Unit of Measure" := ItemLedgEntry."Qty. per Unit of Measure";
              WhseItemTrkgLine."Quantity Handled (Base)" := QtyHandledBase;
              WhseItemTrkgLine."Qty. Registered (Base)" := QtyHandledBase;
              WhseItemTrkgLine.VALIDATE("Quantity (Base)",ItemLedgEntry.Quantity);
              WhseItemTrkgLine.INSERT;
            END ELSE BEGIN
              WhseItemTrkgLine."Quantity Handled (Base)" += QtyHandledBase;
              WhseItemTrkgLine."Qty. Registered (Base)" += QtyHandledBase;
              WhseItemTrkgLine.VALIDATE("Quantity (Base)",WhseItemTrkgLine."Quantity (Base)" + ItemLedgEntry.Quantity);
              WhseItemTrkgLine.MODIFY;
            END;
          UNTIL WhseItemEntryRelation.NEXT = 0;
        END;
      END;
    END;

    LOCAL PROCEDURE RegisteredPutAwayQtyBase@91(PostedWhseReceiptLine@1000 : Record 7319;WhseItemEntryRelation@1001 : Record 6509) : Decimal;
    VAR
      RegisteredWhseActivityLine@1003 : Record 5773;
    BEGIN
      WITH PostedWhseReceiptLine DO BEGIN
        RegisteredWhseActivityLine.RESET;
        RegisteredWhseActivityLine.SetSourceFilter("Source Type","Source Subtype","Source No.","Source Line No.",-1,TRUE);
        RegisteredWhseActivityLine.SetTrackingFilterFromRelation(WhseItemEntryRelation);
        RegisteredWhseActivityLine.SETRANGE("Whse. Document No.","No.");
        RegisteredWhseActivityLine.SETRANGE("Action Type",RegisteredWhseActivityLine."Action Type"::Take);
        RegisteredWhseActivityLine.CALCSUMS("Qty. (Base)");
      END;

      EXIT(RegisteredWhseActivityLine."Qty. (Base)");
    END;

    [External]
    PROCEDURE ItemTrkgIsManagedByWhse@41(Type@1005 : Integer;Subtype@1004 : Integer;ID@1003 : Code[20];ProdOrderLine@1001 : Integer;RefNo@1000 : Integer;LocationCode@1008 : Code[10];ItemNo@1010 : Code[20]) : Boolean;
    VAR
      WhseShipmentLine@1002 : Record 7321;
      WhseWkshLine@1006 : Record 7326;
      WhseActivLine@1007 : Record 5767;
      WhseWkshTemplate@1013 : Record 7328;
      Location@1009 : Record 14;
      SNRequired@1011 : Boolean;
      LNRequired@1012 : Boolean;
    BEGIN
      IF NOT (Type IN [DATABASE::"Sales Line",
                       DATABASE::"Purchase Line",
                       DATABASE::"Transfer Line",
                       DATABASE::"Assembly Header",
                       DATABASE::"Assembly Line",
                       DATABASE::"Prod. Order Line",
                       DATABASE::"Service Line",
                       DATABASE::"Prod. Order Component"])
      THEN
        EXIT(FALSE);

      IF NOT (Location.RequirePicking(LocationCode) OR Location.RequirePutaway(LocationCode)) THEN
        EXIT(FALSE);

      CheckWhseItemTrkgSetup(ItemNo,SNRequired,LNRequired,FALSE);
      IF NOT (SNRequired OR LNRequired) THEN
        EXIT(FALSE);

      WhseShipmentLine.SetSourceFilter(Type,Subtype,ID,RefNo,TRUE);
      IF NOT WhseShipmentLine.ISEMPTY THEN
        EXIT(TRUE);

      IF Type IN [DATABASE::"Prod. Order Component",DATABASE::"Prod. Order Line"] THEN BEGIN
        WhseWkshLine.SetSourceFilter(Type,Subtype,ID,ProdOrderLine,TRUE);
        WhseWkshLine.SETRANGE("Source Subline No.",RefNo);
      END ELSE
        WhseWkshLine.SetSourceFilter(Type,Subtype,ID,RefNo,TRUE);
      IF WhseWkshLine.FINDFIRST THEN
        IF WhseWkshTemplate.GET(WhseWkshLine."Worksheet Template Name") THEN
          IF WhseWkshTemplate.Type = WhseWkshTemplate.Type::Pick THEN
            EXIT(TRUE);

      IF Type IN [DATABASE::"Prod. Order Component",DATABASE::"Prod. Order Line"] THEN
        WhseActivLine.SetSourceFilter(Type,Subtype,ID,ProdOrderLine,RefNo,TRUE)
      ELSE
        WhseActivLine.SetSourceFilter(Type,Subtype,ID,RefNo,0,TRUE);
      IF WhseActivLine.FINDFIRST THEN
        IF WhseActivLine."Activity Type" IN [WhseActivLine."Activity Type"::Pick,
                                             WhseActivLine."Activity Type"::"Invt. Put-away",
                                             WhseActivLine."Activity Type"::"Invt. Pick"]
        THEN
          EXIT(TRUE);

      EXIT(FALSE);
    END;

    [External]
    PROCEDURE CheckWhseItemTrkgSetup@42(ItemNo@1000 : Code[20];VAR SNRequired@1002 : Boolean;VAR LNRequired@1003 : Boolean;ShowError@1005 : Boolean);
    VAR
      ItemTrackingCode@1001 : Record 6502;
      Item@1004 : Record 27;
    BEGIN
      SNRequired := FALSE;
      LNRequired := FALSE;
      IF Item."No." <> ItemNo THEN
        Item.GET(ItemNo);
      IF Item."Item Tracking Code" <> '' THEN BEGIN
        IF ItemTrackingCode.Code <> Item."Item Tracking Code" THEN
          ItemTrackingCode.GET(Item."Item Tracking Code");
        SNRequired := ItemTrackingCode."SN Warehouse Tracking";
        LNRequired := ItemTrackingCode."Lot Warehouse Tracking";
      END;
      IF NOT (SNRequired OR LNRequired) AND ShowError THEN
        ERROR(Text005,Item.FIELDCAPTION("No."),ItemNo);
    END;

    [External]
    PROCEDURE SetGlobalParameters@44(SourceSpecification2@1000 : TEMPORARY Record 336;VAR TempTrackingSpecification2@1001 : TEMPORARY Record 336;DueDate2@1002 : Date);
    BEGIN
      SourceSpecification := SourceSpecification2;
      DueDate := DueDate2;
      IF TempTrackingSpecification2.FINDSET THEN
        REPEAT
          TempTrackingSpecification := TempTrackingSpecification2;
          TempTrackingSpecification.INSERT;
        UNTIL TempTrackingSpecification2.NEXT = 0;
    END;

    [External]
    PROCEDURE AdjustQuantityRounding@45(NonDistrQuantity@1004 : Decimal;VAR QtyToBeHandled@1002 : Decimal;NonDistrQuantityBase@1001 : Decimal;QtyToBeHandledBase@1000 : Decimal);
    VAR
      FloatingFactor@1003 : Decimal;
    BEGIN
      // Used by CU80/90 for handling rounding differences during invoicing

      FloatingFactor := QtyToBeHandledBase / NonDistrQuantityBase;

      IF FloatingFactor < 1 THEN
        QtyToBeHandled := ROUND(FloatingFactor * NonDistrQuantity,0.00001)
      ELSE
        QtyToBeHandled := NonDistrQuantity;
    END;

    [External]
    PROCEDURE SynchronizeItemTrackingByPtrs@7(FromReservEntry@1002 : Record 337;ToReservEntry@1003 : Record 337);
    VAR
      FromRowID@1001 : Text[250];
      ToRowID@1000 : Text[250];
    BEGIN
      FromRowID := ComposeRowID(
          FromReservEntry."Source Type",FromReservEntry."Source Subtype",FromReservEntry."Source ID",
          FromReservEntry."Source Batch Name",FromReservEntry."Source Prod. Order Line",FromReservEntry."Source Ref. No.");
      ToRowID := ComposeRowID(
          ToReservEntry."Source Type",ToReservEntry."Source Subtype",ToReservEntry."Source ID",
          ToReservEntry."Source Batch Name",ToReservEntry."Source Prod. Order Line",ToReservEntry."Source Ref. No.");
      SynchronizeItemTracking(FromRowID,ToRowID,'');
    END;

    [External]
    PROCEDURE SynchronizeItemTracking@47(FromRowID@1000 : Text[250];ToRowID@1001 : Text[250];DialogText@1006 : Text[250]);
    VAR
      ReservEntry1@1002 : Record 337;
    BEGIN
      // Used for syncronizing between orders linked via Drop Shipment
      ReservEntry1.SetPointer(FromRowID);
      ReservEntry1.SetPointerFilter;
      SynchronizeItemTracking2(ReservEntry1,ToRowID,DialogText);
    END;

    LOCAL PROCEDURE SynchronizeItemTracking2@79(VAR FromReservEntry@1000 : Record 337;ToRowID@1001 : Text[250];DialogText@1006 : Text[250]);
    VAR
      ReservEntry2@1003 : Record 337;
      TempTrkgSpec1@1007 : TEMPORARY Record 336;
      TempTrkgSpec2@1008 : TEMPORARY Record 336;
      TempTrkgSpec3@1011 : TEMPORARY Record 336;
      TempSourceSpec@1010 : TEMPORARY Record 336;
      ItemTrackingMgt@1017 : Codeunit 6500;
      ReservMgt@1004 : Codeunit 99000845;
      CreateReservEntry@1009 : Codeunit 99000830;
      ItemTrackingLines@1014 : Page 6510;
      AvailabilityDate@1016 : Date;
      LastEntryNo@1005 : Integer;
      SignFactor1@1015 : Integer;
      SignFactor2@1012 : Integer;
      SecondSourceRowID@1013 : Text[250];
    BEGIN
      // Used for synchronizing between orders linked via Drop Shipment and for
      // synchronizing between invt. pick/put-away and parent line.
      ReservEntry2.SetPointer(ToRowID);
      SignFactor1 := CreateReservEntry.SignFactor(FromReservEntry);
      SignFactor2 := CreateReservEntry.SignFactor(ReservEntry2);
      ReservEntry2.SetPointerFilter;

      IF ReservEntry2.ISEMPTY THEN BEGIN
        IF FromReservEntry.ISEMPTY THEN
          EXIT;
        IF DialogText <> '' THEN
          IF NOT CONFIRM(DialogText) THEN BEGIN
            MESSAGE(Text006);
            EXIT;
          END;
        CopyItemTracking3(FromReservEntry,ToRowID,SignFactor1 <> SignFactor2,FALSE);

        // Copy to inbound part of transfer.
        IF IsReservedFromTransferShipment(FromReservEntry) THEN BEGIN
          SecondSourceRowID :=
            ItemTrackingMgt.ComposeRowID(FromReservEntry."Source Type",
              1,FromReservEntry."Source ID",
              FromReservEntry."Source Batch Name",FromReservEntry."Source Prod. Order Line",
              FromReservEntry."Source Ref. No.");
          IF ToRowID <> SecondSourceRowID THEN // Avoid copying to the line itself
            CopyItemTracking(ToRowID,SecondSourceRowID,TRUE);
        END;
      END ELSE BEGIN
        IF IsReservedFromTransferShipment(FromReservEntry) THEN
          SynchronizeItemTrkgTransfer(ReservEntry2);    // synchronize transfer

        IF SumUpItemTracking(ReservEntry2,TempTrkgSpec2,FALSE,TRUE) THEN
          TempSourceSpec := TempTrkgSpec2 // TempSourceSpec is used for conveying source information to Form6510.
        ELSE
          TempSourceSpec.TRANSFERFIELDS(ReservEntry2);

        IF ReservEntry2."Quantity (Base)" > 0 THEN
          AvailabilityDate := ReservEntry2."Expected Receipt Date"
        ELSE
          AvailabilityDate := ReservEntry2."Shipment Date";

        SumUpItemTracking(FromReservEntry,TempTrkgSpec1,FALSE,TRUE);

        TempTrkgSpec1.RESET;
        TempTrkgSpec2.RESET;
        TempTrkgSpec1.SETCURRENTKEY("Lot No.","Serial No.");
        TempTrkgSpec2.SETCURRENTKEY("Lot No.","Serial No.");
        IF TempTrkgSpec1.FINDSET THEN
          REPEAT
            TempTrkgSpec2.SetTrackingFilterFromSpec(TempTrkgSpec1);
            IF TempTrkgSpec2.FINDFIRST THEN BEGIN
              IF TempTrkgSpec2."Quantity (Base)" * SignFactor2 <> TempTrkgSpec1."Quantity (Base)" * SignFactor1 THEN BEGIN
                TempTrkgSpec3 := TempTrkgSpec2;
                TempTrkgSpec3.VALIDATE("Quantity (Base)",
                  (TempTrkgSpec1."Quantity (Base)" * SignFactor1 - TempTrkgSpec2."Quantity (Base)" * SignFactor2));
                TempTrkgSpec3."Entry No." := LastEntryNo + 1;
                TempTrkgSpec3.INSERT;
              END;
              TempTrkgSpec2.DELETE;
            END ELSE BEGIN
              TempTrkgSpec3 := TempTrkgSpec1;
              TempTrkgSpec3.VALIDATE("Quantity (Base)",TempTrkgSpec1."Quantity (Base)" * SignFactor1);
              TempTrkgSpec3."Entry No." := LastEntryNo + 1;
              TempTrkgSpec3.INSERT;
            END;
            LastEntryNo := TempTrkgSpec3."Entry No.";
            TempTrkgSpec1.DELETE;
          UNTIL TempTrkgSpec1.NEXT = 0;

        TempTrkgSpec2.RESET;

        IF TempTrkgSpec2.FINDFIRST THEN
          REPEAT
            TempTrkgSpec3 := TempTrkgSpec2;
            TempTrkgSpec3.VALIDATE("Quantity (Base)",-TempTrkgSpec2."Quantity (Base)" * SignFactor2);
            TempTrkgSpec3."Entry No." := LastEntryNo + 1;
            TempTrkgSpec3.INSERT;
            LastEntryNo := TempTrkgSpec3."Entry No.";
          UNTIL TempTrkgSpec2.NEXT = 0;

        TempTrkgSpec3.RESET;

        IF NOT TempTrkgSpec3.ISEMPTY THEN BEGIN
          IF DialogText <> '' THEN
            IF NOT CONFIRM(DialogText) THEN BEGIN
              MESSAGE(Text006);
              EXIT;
            END;
          TempSourceSpec."Quantity (Base)" := ReservMgt.GetSourceRecordValue(ReservEntry2,FALSE,1);
          IF TempTrkgSpec3."Source Type" = DATABASE::"Transfer Line" THEN BEGIN
            TempTrkgSpec3.MODIFYALL("Location Code",ReservEntry2."Location Code");
            ItemTrackingLines.SetFormRunMode(4);
          END ELSE
            IF FromReservEntry."Source Type" <> ReservEntry2."Source Type" THEN // If different it is drop shipment
              ItemTrackingLines.SetFormRunMode(3);
          ItemTrackingLines.RegisterItemTrackingLines(TempSourceSpec,AvailabilityDate,TempTrkgSpec3);
        END;
      END;
    END;

    [External]
    PROCEDURE SetRegistering@49(Registering2@1000 : Boolean);
    BEGIN
      Registering := Registering2;
    END;

    LOCAL PROCEDURE ModifyTemp337SetIfTransfer@50(VAR TempReservEntry@1001 : TEMPORARY Record 337);
    VAR
      TransLine@1000 : Record 5741;
    BEGIN
      IF TempReservEntry."Source Type" = DATABASE::"Transfer Line" THEN BEGIN
        TransLine.GET(TempReservEntry."Source ID",TempReservEntry."Source Ref. No.");
        TempReservEntry.MODIFYALL("Reservation Status",TempReservEntry."Reservation Status"::Surplus);
        IF TempReservEntry."Source Subtype" = 0 THEN BEGIN
          TempReservEntry.MODIFYALL("Location Code",TransLine."Transfer-from Code");
          TempReservEntry.MODIFYALL("Expected Receipt Date",0D);
          TempReservEntry.MODIFYALL("Shipment Date",TransLine."Shipment Date");
        END ELSE BEGIN
          TempReservEntry.MODIFYALL("Location Code",TransLine."Transfer-to Code");
          TempReservEntry.MODIFYALL("Expected Receipt Date",TransLine."Receipt Date");
          TempReservEntry.MODIFYALL("Shipment Date",0D);
        END;
      END;
    END;

    [External]
    PROCEDURE SynchronizeWhseItemTracking@51(VAR TempTrackingSpecification@1002 : TEMPORARY Record 336;RegPickNo@1007 : Code[20];Deletion@1006 : Boolean);
    VAR
      ReservEntry@1003 : Record 337;
      RegisteredWhseActLine@1004 : Record 5773;
      Qty@1102601000 : Decimal;
      ZeroQtyToHandle@1005 : Boolean;
    BEGIN
      IF TempTrackingSpecification.FINDSET THEN
        REPEAT
          IF TempTrackingSpecification.Correction THEN BEGIN
            IF IsPick THEN BEGIN
              ZeroQtyToHandle := FALSE;
              Qty := -TempTrackingSpecification."Qty. to Handle (Base)";
              IF RegPickNo <> '' THEN BEGIN
                RegisteredWhseActLine.SETRANGE("Activity Type",RegisteredWhseActLine."Activity Type"::Pick);
                RegisteredWhseActLine.SetSourceFilter(
                  TempTrackingSpecification."Source Type",TempTrackingSpecification."Source Subtype",
                  TempTrackingSpecification."Source ID",TempTrackingSpecification."Source Ref. No.",-1,TRUE);
                RegisteredWhseActLine.SetTrackingFilterFromSpec(TempTrackingSpecification);
                RegisteredWhseActLine.SETFILTER("No.",'<> %1',RegPickNo);
                IF NOT RegisteredWhseActLine.FINDFIRST THEN
                  ZeroQtyToHandle := TRUE
                ELSE
                  IF RegisteredWhseActLine."Whse. Document Type" = RegisteredWhseActLine."Whse. Document Type"::Shipment THEN BEGIN
                    ZeroQtyToHandle := TRUE;
                    Qty := -(TempTrackingSpecification."Qty. to Handle (Base)" + CalcQtyBaseRegistered(RegisteredWhseActLine));
                  END;
              END;

              ReservEntry.SetSourceFilter(
                TempTrackingSpecification."Source Type",TempTrackingSpecification."Source Subtype",
                TempTrackingSpecification."Source ID",TempTrackingSpecification."Source Ref. No.",TRUE);
              ReservEntry.SetSourceFilter2('',TempTrackingSpecification."Source Prod. Order Line");
              ReservEntry.SetTrackingFilterFromSpec(TempTrackingSpecification);
              IF ReservEntry.FINDSET(TRUE) THEN
                REPEAT
                  IF ZeroQtyToHandle THEN BEGIN
                    ReservEntry."Qty. to Handle (Base)" := 0;
                    ReservEntry."Qty. to Invoice (Base)" := 0;
                    ReservEntry.MODIFY;
                  END;
                UNTIL ReservEntry.NEXT = 0;

              IF ReservEntry.FINDSET(TRUE) THEN
                REPEAT
                  IF RegPickNo <> '' THEN BEGIN
                    ReservEntry."Qty. to Handle (Base)" += Qty;
                    ReservEntry."Qty. to Invoice (Base)" += Qty;
                  END ELSE
                    IF NOT Deletion THEN BEGIN
                      ReservEntry."Qty. to Handle (Base)" := Qty;
                      ReservEntry."Qty. to Invoice (Base)" := Qty;
                    END;
                  IF ABS(ReservEntry."Qty. to Handle (Base)") > ABS(ReservEntry."Quantity (Base)") THEN BEGIN
                    Qty := ReservEntry."Qty. to Handle (Base)" - ReservEntry."Quantity (Base)";
                    ReservEntry."Qty. to Handle (Base)" := ReservEntry."Quantity (Base)";
                    ReservEntry."Qty. to Invoice (Base)" := ReservEntry."Quantity (Base)";
                  END ELSE
                    Qty := 0;
                  ReservEntry.MODIFY;

                  IF IsReservedFromTransferShipment(ReservEntry) THEN
                    UpdateItemTrackingInTransferReceipt(ReservEntry);
                UNTIL (ReservEntry.NEXT = 0) OR (Qty = 0);
            END;
            TempTrackingSpecification.DELETE;
          END;
        UNTIL TempTrackingSpecification.NEXT = 0;

      RegisterNewItemTrackingLines(TempTrackingSpecification);
    END;

    LOCAL PROCEDURE CheckWhseItemTrkg@40(VAR TempWhseItemTrkgLine@1000 : Record 6550;WhseWkshLine@1002 : Record 7326);
    VAR
      SourceReservEntry@1001 : Record 337;
      WhseItemTrackingLine@1003 : Record 6550;
      EntryNo@1004 : Integer;
    BEGIN
      WITH WhseWkshLine DO BEGIN
        IF WhseItemTrackingLine.FINDLAST THEN
          EntryNo := WhseItemTrackingLine."Entry No.";

        IF "Source Type" = DATABASE::"Prod. Order Component" THEN BEGIN
          SourceReservEntry.SetSourceFilter("Source Type","Source Subtype","Source No.","Source Subline No.",TRUE);
          SourceReservEntry.SetSourceFilter2('',"Source Line No.");
        END ELSE BEGIN
          SourceReservEntry.SetSourceFilter("Source Type","Source Subtype","Source No.","Source Line No.",TRUE);
          SourceReservEntry.SetSourceFilter2('',0);
        END;
        IF SourceReservEntry.FINDSET THEN
          REPEAT
            IF SourceReservEntry.TrackingExists THEN BEGIN
              IF "Source Type" = DATABASE::"Prod. Order Component" THEN BEGIN
                TempWhseItemTrkgLine.SetSourceFilter("Source Type","Source Subtype","Source No.","Source Subline No.",TRUE);
                TempWhseItemTrkgLine.SETRANGE("Source Prod. Order Line","Source Line No.");
              END ELSE BEGIN
                TempWhseItemTrkgLine.SetSourceFilter("Source Type","Source Subtype","Source No.","Source Line No.",TRUE);
                TempWhseItemTrkgLine.SETRANGE("Source Prod. Order Line",0);
              END;
              TempWhseItemTrkgLine.SetTrackingFilterFromReservEntry(SourceReservEntry);

              IF TempWhseItemTrkgLine.FINDFIRST THEN
                TempWhseItemTrkgLine.DELETE
              ELSE BEGIN
                WhseItemTrackingLine.INIT;
                EntryNo += 1;
                WhseItemTrackingLine."Entry No." := EntryNo;
                WhseItemTrackingLine."Item No." := SourceReservEntry."Item No.";
                WhseItemTrackingLine."Variant Code" := SourceReservEntry."Variant Code";
                WhseItemTrackingLine."Location Code" := SourceReservEntry."Location Code";
                WhseItemTrackingLine.Description := SourceReservEntry.Description;
                WhseItemTrackingLine."Qty. per Unit of Measure" := SourceReservEntry."Qty. per Unit of Measure";
                IF "Source Type" = DATABASE::"Prod. Order Component" THEN
                  WhseItemTrackingLine.SetSource("Source Type","Source Subtype","Source No.","Source Subline No.",'',"Source Line No.")
                ELSE
                  WhseItemTrackingLine.SetSource("Source Type","Source Subtype","Source No.","Source Line No.",'',0);
                WhseItemTrackingLine.CopyTrackingFromReservEntry(SourceReservEntry);
                WhseItemTrackingLine."Quantity (Base)" := -SourceReservEntry."Quantity (Base)";
                IF "Qty. (Base)" = "Qty. to Handle (Base)" THEN
                  WhseItemTrackingLine."Qty. to Handle (Base)" := WhseItemTrackingLine."Quantity (Base)";
                WhseItemTrackingLine."Qty. to Handle" :=
                  ROUND(WhseItemTrackingLine."Qty. to Handle (Base)" / WhseItemTrackingLine."Qty. per Unit of Measure",0.00001);
                WhseItemTrackingLine.INSERT;
              END;
            END;
          UNTIL SourceReservEntry.NEXT = 0;

        TempWhseItemTrkgLine.RESET;
        IF TempWhseItemTrkgLine.FINDSET THEN
          REPEAT
            IF TempWhseItemTrkgLine.TrackingExists AND (TempWhseItemTrkgLine."Quantity Handled (Base)" = 0) THEN BEGIN
              WhseItemTrackingLine.GET(TempWhseItemTrkgLine."Entry No.");
              WhseItemTrackingLine.DELETE;
            END;
          UNTIL TempWhseItemTrkgLine.NEXT = 0;
      END;
    END;

    [External]
    PROCEDURE CopyLotNoInformation@80(LotNoInfo@1000 : Record 6505;NewLotNo@1002 : Code[20]);
    VAR
      NewLotNoInfo@1001 : Record 6505;
      CommentType@1004 : ' ,Serial No.,Lot No.';
    BEGIN
      IF NewLotNoInfo.GET(LotNoInfo."Item No.",LotNoInfo."Variant Code",NewLotNo) THEN BEGIN
        IF NOT CONFIRM(text008,FALSE,LotNoInfo.TABLECAPTION,LotNoInfo.FIELDCAPTION("Lot No."),NewLotNo) THEN
          ERROR('');
        NewLotNoInfo.TRANSFERFIELDS(LotNoInfo,FALSE);
        NewLotNoInfo.MODIFY;
      END ELSE BEGIN
        NewLotNoInfo := LotNoInfo;
        NewLotNoInfo."Lot No." := NewLotNo;
        NewLotNoInfo.INSERT;
      END;

      CopyInfoComment(
        CommentType::"Lot No.",
        LotNoInfo."Item No.",
        LotNoInfo."Variant Code",
        LotNoInfo."Lot No.",
        NewLotNo);
    END;

    [External]
    PROCEDURE CopySerialNoInformation@52(SerialNoInfo@1000 : Record 6504;NewSerialNo@1002 : Code[20]);
    VAR
      NewSerialNoInfo@1001 : Record 6504;
      CommentType@1004 : ' ,Serial No.,Lot No.';
    BEGIN
      IF NewSerialNoInfo.GET(SerialNoInfo."Item No.",SerialNoInfo."Variant Code",NewSerialNo) THEN BEGIN
        IF NOT CONFIRM(text008,FALSE,SerialNoInfo.TABLECAPTION,SerialNoInfo.FIELDCAPTION("Serial No."),NewSerialNo) THEN
          ERROR('');
        NewSerialNoInfo.TRANSFERFIELDS(SerialNoInfo,FALSE);
        NewSerialNoInfo.MODIFY;
      END ELSE BEGIN
        NewSerialNoInfo := SerialNoInfo;
        NewSerialNoInfo."Serial No." := NewSerialNo;
        NewSerialNoInfo.INSERT;
      END;

      CopyInfoComment(
        CommentType::"Serial No.",
        SerialNoInfo."Item No.",
        SerialNoInfo."Variant Code",
        SerialNoInfo."Serial No.",
        NewSerialNo);
    END;

    LOCAL PROCEDURE CopyInfoComment@57(InfoType@1000 : ' ,Serial No.,Lot No.';ItemNo@1001 : Code[20];VariantCode@1002 : Code[10];SerialLotNo@1003 : Code[20];NewSerialLotNo@1004 : Code[20]);
    VAR
      ItemTrackingComment@1005 : Record 6506;
      ItemTrackingComment1@1006 : Record 6506;
    BEGIN
      IF SerialLotNo = NewSerialLotNo THEN
        EXIT;

      ItemTrackingComment1.SETRANGE(Type,InfoType);
      ItemTrackingComment1.SETRANGE("Item No.",ItemNo);
      ItemTrackingComment1.SETRANGE("Variant Code",VariantCode);
      ItemTrackingComment1.SETRANGE("Serial/Lot No.",NewSerialLotNo);

      IF NOT ItemTrackingComment1.ISEMPTY THEN
        ItemTrackingComment1.DELETEALL;

      ItemTrackingComment.SETRANGE(Type,InfoType);
      ItemTrackingComment.SETRANGE("Item No.",ItemNo);
      ItemTrackingComment.SETRANGE("Variant Code",VariantCode);
      ItemTrackingComment.SETRANGE("Serial/Lot No.",SerialLotNo);

      IF ItemTrackingComment.ISEMPTY THEN
        EXIT;

      IF ItemTrackingComment.FINDSET THEN BEGIN
        REPEAT
          ItemTrackingComment1 := ItemTrackingComment;
          ItemTrackingComment1."Serial/Lot No." := NewSerialLotNo;
          ItemTrackingComment1.INSERT;
        UNTIL ItemTrackingComment.NEXT = 0
      END;
    END;

    LOCAL PROCEDURE GetLotSNDataSet@60(ItemNo@1000 : Code[20];Variant@1001 : Code[20];LotNo@1002 : Code[20];SerialNo@1006 : Code[20];VAR ItemLedgEntry@1003 : Record 32) : Boolean;
    BEGIN
      ItemLedgEntry.RESET;
      ItemLedgEntry.SETCURRENTKEY("Item No.",Open,"Variant Code",Positive,"Lot No.","Serial No.");

      ItemLedgEntry.SETRANGE("Item No.",ItemNo);
      ItemLedgEntry.SETRANGE(Open,TRUE);
      ItemLedgEntry.SETRANGE("Variant Code",Variant);
      IF LotNo <> '' THEN
        ItemLedgEntry.SETRANGE("Lot No.",LotNo)
      ELSE
        IF SerialNo <> '' THEN
          ItemLedgEntry.SETRANGE("Serial No.",SerialNo);
      ItemLedgEntry.SETRANGE(Positive,TRUE);

      IF ItemLedgEntry.FINDLAST THEN
        EXIT(TRUE);

      ItemLedgEntry.SETRANGE(Open);
      EXIT(ItemLedgEntry.FINDLAST);
    END;

    [External]
    PROCEDURE ExistingExpirationDate@58(ItemNo@1002 : Code[20];Variant@1001 : Code[20];LotNo@1000 : Code[20];SerialNo@1005 : Code[20];TestMultiple@1004 : Boolean;VAR EntriesExist@1007 : Boolean) ExpDate : Date;
    VAR
      ItemLedgEntry@1003 : Record 32;
      ItemTracingMgt@1008 : Codeunit 6520;
    BEGIN
      IF NOT GetLotSNDataSet(ItemNo,Variant,LotNo,SerialNo,ItemLedgEntry) THEN BEGIN
        EntriesExist := FALSE;
        EXIT;
      END;

      EntriesExist := TRUE;
      ExpDate := ItemLedgEntry."Expiration Date";

      IF TestMultiple AND ItemTracingMgt.SpecificTracking(ItemNo,SerialNo,LotNo) THEN BEGIN
        ItemLedgEntry.SETFILTER("Expiration Date",'<>%1',ItemLedgEntry."Expiration Date");
        ItemLedgEntry.SETRANGE(Open,TRUE);
        IF NOT ItemLedgEntry.ISEMPTY THEN
          ERROR(Text007,LotNo);
      END;
    END;

    [External]
    PROCEDURE ExistingExpirationDateAndQty@20(ItemNo@1002 : Code[20];Variant@1001 : Code[20];LotNo@1000 : Code[20];SerialNo@1005 : Code[20];VAR SumOfEntries@1007 : Decimal) ExpDate : Date;
    VAR
      ItemLedgEntry@1003 : Record 32;
    BEGIN
      SumOfEntries := 0;
      IF NOT GetLotSNDataSet(ItemNo,Variant,LotNo,SerialNo,ItemLedgEntry) THEN
        EXIT;

      ExpDate := ItemLedgEntry."Expiration Date";
      IF ItemLedgEntry.FINDSET THEN
        REPEAT
          SumOfEntries += ItemLedgEntry."Remaining Quantity";
        UNTIL ItemLedgEntry.NEXT = 0;
    END;

    [External]
    PROCEDURE ExistingWarrantyDate@1002(ItemNo@1002 : Code[20];Variant@1001 : Code[20];LotNo@1000 : Code[20];SerialNo@1005 : Code[20];VAR EntriesExist@1007 : Boolean) WarDate : Date;
    VAR
      ItemLedgEntry@1003 : Record 32;
    BEGIN
      IF NOT GetLotSNDataSet(ItemNo,Variant,LotNo,SerialNo,ItemLedgEntry) THEN
        EXIT;

      EntriesExist := TRUE;
      WarDate := ItemLedgEntry."Warranty Date";
    END;

    [External]
    PROCEDURE WhseExistingExpirationDate@56(ItemNo@1002 : Code[20];VariantCode@1001 : Code[20];Location@1006 : Record 14;LotNo@1000 : Code[20];SerialNo@1005 : Code[20];VAR EntriesExist@1007 : Boolean) ExpDate : Date;
    VAR
      WhseEntry@1003 : Record 7312;
      SumOfEntries@1009 : Decimal;
    BEGIN
      ExpDate := 0D;
      SumOfEntries := 0;

      IF Location."Adjustment Bin Code" = '' THEN
        EXIT;

      WITH WhseEntry DO BEGIN
        RESET;
        SETCURRENTKEY("Item No.","Bin Code","Location Code","Variant Code","Unit of Measure Code","Lot No.","Serial No.");
        SETRANGE("Item No.",ItemNo);
        SETRANGE("Bin Code",Location."Adjustment Bin Code");
        SETRANGE("Location Code",Location.Code);
        SETRANGE("Variant Code",VariantCode);
        IF LotNo <> '' THEN
          SETRANGE("Lot No.",LotNo)
        ELSE
          IF SerialNo <> '' THEN
            SETRANGE("Serial No.",SerialNo);
        IF ISEMPTY THEN
          EXIT;

        IF FINDSET THEN
          REPEAT
            SumOfEntries += "Qty. (Base)";
            IF ("Expiration Date" <> 0D) AND (("Expiration Date" < ExpDate) OR (ExpDate = 0D)) THEN
              ExpDate := "Expiration Date";
          UNTIL NEXT = 0;
      END;

      EntriesExist := SumOfEntries < 0;
    END;

    LOCAL PROCEDURE WhseExistingWarrantyDate@94(ItemNo@1000 : Code[20];VariantCode@1001 : Code[20];Location@1002 : Record 14;LotNo@1003 : Code[20];SerialNo@1004 : Code[20];VAR EntriesExist@1005 : Boolean) WarDate : Date;
    VAR
      WhseEntry@1006 : Record 7312;
      SumOfEntries@1007 : Decimal;
    BEGIN
      WarDate := 0D;
      SumOfEntries := 0;

      IF Location."Adjustment Bin Code" = '' THEN
        EXIT;

      WITH WhseEntry DO BEGIN
        RESET;
        SETCURRENTKEY("Item No.","Bin Code","Location Code","Variant Code","Unit of Measure Code","Lot No.","Serial No.");
        SETRANGE("Item No.",ItemNo);
        SETRANGE("Bin Code",Location."Adjustment Bin Code");
        SETRANGE("Location Code",Location.Code);
        SETRANGE("Variant Code",VariantCode);
        IF LotNo <> '' THEN
          SETRANGE("Lot No.",LotNo)
        ELSE
          IF SerialNo <> '' THEN
            SETRANGE("Serial No.",SerialNo);
        IF ISEMPTY THEN
          EXIT;

        IF FINDSET THEN
          REPEAT
            SumOfEntries += "Qty. (Base)";
            IF ("Warranty Date" <> 0D) AND (("Warranty Date" < WarDate) OR (WarDate = 0D)) THEN
              WarDate := "Warranty Date";
          UNTIL NEXT = 0;
      END;

      EntriesExist := SumOfEntries < 0;
    END;

    [External]
    PROCEDURE GetWhseExpirationDate@73(ItemNo@1002 : Code[20];VariantCode@1001 : Code[20];Location@1006 : Record 14;LotNo@1000 : Code[20];SerialNo@1005 : Code[20];VAR ExpDate@1003 : Date) : Boolean;
    VAR
      EntriesExist@1004 : Boolean;
    BEGIN
      ExpDate := ExistingExpirationDate(ItemNo,VariantCode,LotNo,SerialNo,FALSE,EntriesExist);
      IF EntriesExist THEN
        EXIT(TRUE);

      ExpDate := WhseExistingExpirationDate(ItemNo,VariantCode,Location,LotNo,SerialNo,EntriesExist);
      IF EntriesExist THEN
        EXIT(TRUE);

      ExpDate := 0D;
      EXIT(FALSE);
    END;

    [External]
    PROCEDURE GetWhseWarrantyDate@97(ItemNo@1000 : Code[20];VariantCode@1001 : Code[20];Location@1002 : Record 14;LotNo@1003 : Code[20];SerialNo@1004 : Code[20];VAR Wardate@1005 : Date) : Boolean;
    VAR
      EntriesExist@1006 : Boolean;
    BEGIN
      Wardate := ExistingWarrantyDate(ItemNo,VariantCode,LotNo,SerialNo,EntriesExist);
      IF EntriesExist THEN
        EXIT(TRUE);

      Wardate := WhseExistingWarrantyDate(ItemNo,VariantCode,Location,LotNo,SerialNo,EntriesExist);
      IF EntriesExist THEN
        EXIT(TRUE);

      Wardate := 0D;
      EXIT(FALSE);
    END;

    [External]
    PROCEDURE SumNewLotOnTrackingSpec@81(VAR TempTrackingSpecification@1000 : TEMPORARY Record 336) : Decimal;
    VAR
      TempTrackingSpecification2@1001 : Record 336;
      SumLot@1002 : Decimal;
    BEGIN
      SumLot := 0;
      TempTrackingSpecification2 := TempTrackingSpecification;
      TempTrackingSpecification.SETRANGE("New Lot No.",TempTrackingSpecification."New Lot No.");
      IF TempTrackingSpecification.FINDSET THEN
        REPEAT
          SumLot += TempTrackingSpecification."Quantity (Base)";
        UNTIL TempTrackingSpecification.NEXT = 0;
      TempTrackingSpecification := TempTrackingSpecification2;
      EXIT(SumLot);
    END;

    [External]
    PROCEDURE TestExpDateOnTrackingSpec@53(VAR TempTrackingSpecification@1000 : TEMPORARY Record 336);
    BEGIN
      IF (TempTrackingSpecification."Lot No." = '') OR (TempTrackingSpecification."Serial No." = '') THEN
        EXIT;
      TempTrackingSpecification.SETRANGE("Lot No.",TempTrackingSpecification."Lot No.");
      TempTrackingSpecification.SETFILTER("Expiration Date",'<>%1',TempTrackingSpecification."Expiration Date");
      IF NOT TempTrackingSpecification.ISEMPTY THEN
        ERROR(Text007,TempTrackingSpecification."Lot No.");
      TempTrackingSpecification.SETRANGE("Lot No.");
      TempTrackingSpecification.SETRANGE("Expiration Date");
    END;

    [External]
    PROCEDURE TestExpDateOnTrackingSpecNew@54(VAR TempTrackingSpecification@1000 : TEMPORARY Record 336);
    BEGIN
      IF TempTrackingSpecification."New Lot No." = '' THEN
        EXIT;
      TempTrackingSpecification.SETRANGE("New Lot No.",TempTrackingSpecification."New Lot No.");
      TempTrackingSpecification.SETFILTER("New Expiration Date",'<>%1',TempTrackingSpecification."New Expiration Date");
      IF NOT TempTrackingSpecification.ISEMPTY THEN
        ERROR(Text007,TempTrackingSpecification."New Lot No.");
      TempTrackingSpecification.SETRANGE("New Lot No.");
      TempTrackingSpecification.SETRANGE("New Expiration Date");
    END;

    [External]
    PROCEDURE ItemTrackingOption@66(LotNo@1000 : Code[20];SerialNo@1001 : Code[20]) OptionValue : Integer;
    BEGIN
      IF LotNo <> '' THEN
        OptionValue := 1;

      IF SerialNo <> '' THEN BEGIN
        IF LotNo <> '' THEN
          OptionValue := 2
        ELSE
          OptionValue := 3;
      END;
    END;

    PROCEDURE CalcQtyBaseRegistered@110(VAR RegisteredWhseActivityLine@1001 : Record 5773) : Decimal;
    VAR
      RegisteredWhseActivityLineForCalcBaseQty@1002 : Record 5773;
    BEGIN
      RegisteredWhseActivityLineForCalcBaseQty.COPYFILTERS(RegisteredWhseActivityLine);
      WITH RegisteredWhseActivityLineForCalcBaseQty DO BEGIN
        SETRANGE("Action Type","Action Type"::Place);
        CALCSUMS("Qty. (Base)");
        EXIT("Qty. (Base)");
      END;
    END;

    [External]
    PROCEDURE CopyItemLedgEntryTrkgToSalesLn@70(VAR TempItemLedgEntryBuf@1000 : TEMPORARY Record 32;ToSalesLine@1001 : Record 37;FillExactCostRevLink@1015 : Boolean;VAR MissingExCostRevLink@1010 : Boolean;FromPricesInclVAT@1017 : Boolean;ToPricesInclVAT@1009 : Boolean;FromShptOrRcpt@1020 : Boolean);
    VAR
      TempReservEntry@1003 : TEMPORARY Record 337;
      ReservEntry@1004 : Record 337;
      CopyDocMgt@1019 : Codeunit 6620;
      ReservMgt@1007 : Codeunit 99000845;
      ReservEngineMgt@1008 : Codeunit 99000831;
      TotalCostLCY@1006 : Decimal;
      ItemLedgEntryQty@1011 : Decimal;
      QtyBase@1005 : Decimal;
      SignFactor@1014 : Integer;
      LinkThisEntry@1002 : Boolean;
      EntriesExist@1012 : Boolean;
    BEGIN
      IF (ToSalesLine.Type <> ToSalesLine.Type::Item) OR (ToSalesLine.Quantity = 0) THEN
        EXIT;

      IF FillExactCostRevLink THEN
        FillExactCostRevLink := NOT ToSalesLine.IsShipment;

      WITH TempItemLedgEntryBuf DO
        IF FINDSET THEN BEGIN
          IF Quantity / ToSalesLine.Quantity < 0 THEN
            SignFactor := 1
          ELSE
            SignFactor := -1;
          IF ToSalesLine.IsCreditDocType THEN
            SignFactor := -SignFactor;

          ReservMgt.SetSalesLine(ToSalesLine);
          ReservMgt.DeleteReservEntries(TRUE,0);

          REPEAT
            LinkThisEntry := "Entry No." > 0;

            IF FillExactCostRevLink THEN
              QtyBase := "Shipped Qty. Not Returned" * SignFactor
            ELSE
              QtyBase := Quantity * SignFactor;

            IF FillExactCostRevLink THEN
              IF NOT LinkThisEntry THEN
                MissingExCostRevLink := TRUE
              ELSE
                IF NOT MissingExCostRevLink THEN BEGIN
                  CALCFIELDS("Cost Amount (Actual)","Cost Amount (Expected)");
                  TotalCostLCY := TotalCostLCY + "Cost Amount (Expected)" + "Cost Amount (Actual)";
                  ItemLedgEntryQty := ItemLedgEntryQty - Quantity;
                END;

            InsertReservEntryForSalesLine(
              ReservEntry,TempItemLedgEntryBuf,ToSalesLine,QtyBase,FillExactCostRevLink AND LinkThisEntry,EntriesExist);

            TempReservEntry := ReservEntry;
            TempReservEntry.INSERT;
          UNTIL NEXT = 0;
          ReservEngineMgt.UpdateOrderTracking(TempReservEntry);

          IF FillExactCostRevLink AND NOT MissingExCostRevLink THEN BEGIN
            ToSalesLine.VALIDATE(
              "Unit Cost (LCY)",ABS(TotalCostLCY / ItemLedgEntryQty) * ToSalesLine."Qty. per Unit of Measure");
            IF NOT FromShptOrRcpt THEN
              CopyDocMgt.CalculateRevSalesLineAmount(ToSalesLine,ItemLedgEntryQty,FromPricesInclVAT,ToPricesInclVAT);
            ToSalesLine.MODIFY;
          END;
        END;
    END;

    [External]
    PROCEDURE CopyItemLedgEntryTrkgToPurchLn@71(VAR ItemLedgEntryBuf@1000 : Record 32;ToPurchLine@1001 : Record 39;FillExactCostRevLink@1015 : Boolean;VAR MissingExCostRevLink@1010 : Boolean;FromPricesInclVAT@1017 : Boolean;ToPricesInclVAT@1013 : Boolean;FromShptOrRcpt@1018 : Boolean);
    VAR
      ItemLedgEntry@1012 : Record 32;
      CopyDocMgt@1011 : Codeunit 6620;
      ReservMgt@1007 : Codeunit 99000845;
      TotalCostLCY@1006 : Decimal;
      ItemLedgEntryQty@1002 : Decimal;
      QtyBase@1005 : Decimal;
      SignFactor@1003 : Integer;
      LinkThisEntry@1009 : Boolean;
      EntriesExist@1008 : Boolean;
    BEGIN
      IF (ToPurchLine.Type <> ToPurchLine.Type::Item) OR (ToPurchLine.Quantity = 0) THEN
        EXIT;

      IF FillExactCostRevLink THEN
        FillExactCostRevLink := ToPurchLine.Signed(ToPurchLine."Quantity (Base)") < 0;

      IF FillExactCostRevLink THEN
        IF (ToPurchLine."Document Type" IN [ToPurchLine."Document Type"::Invoice,ToPurchLine."Document Type"::"Credit Memo"]) AND
           (ToPurchLine."Job No." <> '')
        THEN
          FillExactCostRevLink := FALSE;

      WITH ItemLedgEntryBuf DO
        IF FINDSET THEN BEGIN
          IF Quantity / ToPurchLine.Quantity > 0 THEN
            SignFactor := 1
          ELSE
            SignFactor := -1;
          IF ToPurchLine."Document Type" IN
             [ToPurchLine."Document Type"::"Return Order",ToPurchLine."Document Type"::"Credit Memo"]
          THEN
            SignFactor := -SignFactor;

          IF ToPurchLine."Expected Receipt Date" = 0D THEN
            ToPurchLine."Expected Receipt Date" := WORKDATE;
          ToPurchLine."Outstanding Qty. (Base)" := ToPurchLine."Quantity (Base)";
          ReservMgt.SetPurchLine(ToPurchLine);
          ReservMgt.DeleteReservEntries(TRUE,0);

          REPEAT
            LinkThisEntry := "Entry No." > 0;

            IF FillExactCostRevLink THEN
              IF NOT LinkThisEntry THEN
                MissingExCostRevLink := TRUE
              ELSE
                IF NOT MissingExCostRevLink THEN BEGIN
                  CALCFIELDS("Cost Amount (Actual)","Cost Amount (Expected)");
                  TotalCostLCY := TotalCostLCY + "Cost Amount (Expected)" + "Cost Amount (Actual)";
                  ItemLedgEntryQty := ItemLedgEntryQty - Quantity;
                END;

            IF LinkThisEntry AND ("Lot No." = '') THEN
              // The check for Lot No = '' is to avoid changing the remaining quantity for partly sold Lots
              // because this will cause undefined quantities in the item tracking
              "Remaining Quantity" := Quantity;
            IF ToPurchLine."Job No." = '' THEN
              QtyBase := "Remaining Quantity" * SignFactor
            ELSE BEGIN
              ItemLedgEntry.GET("Entry No.");
              QtyBase := ABS(ItemLedgEntry.Quantity) * SignFactor;
            END;

            InsertReservEntryForPurchLine(
              ItemLedgEntryBuf,ToPurchLine,QtyBase,FillExactCostRevLink AND LinkThisEntry,EntriesExist);
          UNTIL NEXT = 0;

          IF FillExactCostRevLink AND NOT MissingExCostRevLink THEN BEGIN
            ToPurchLine.VALIDATE(
              "Unit Cost (LCY)",
              ABS(TotalCostLCY / ItemLedgEntryQty) * ToPurchLine."Qty. per Unit of Measure");
            IF NOT FromShptOrRcpt THEN
              CopyDocMgt.CalculateRevPurchLineAmount(
                ToPurchLine,ItemLedgEntryQty,FromPricesInclVAT,ToPricesInclVAT);

            ToPurchLine.MODIFY;
          END;
        END;
    END;

    [External]
    PROCEDURE SynchronizeWhseActivItemTrkg@74(WhseActivLine@1000 : Record 5767);
    VAR
      TempTrackingSpec@1002 : TEMPORARY Record 336;
      TempReservEntry@1005 : TEMPORARY Record 337;
      ReservEntry@1008 : Record 337;
      ReservEntryBindingCheck@1013 : Record 337;
      ATOSalesLine@1004 : Record 37;
      AsmHeader@1010 : Record 900;
      ItemTrackingMgt@1007 : Codeunit 6500;
      SignFactor@1001 : Integer;
      ToRowID@1006 : Text[250];
      IsTransferReceipt@1012 : Boolean;
      IsATOPosting@1003 : Boolean;
      IsBindingOrderToOrder@1011 : Boolean;
    BEGIN
      // Used for carrying the item tracking from the invt. pick/put-away to the parent line.
      WITH WhseActivLine DO BEGIN
        RESET;
        SetSourceFilter("Source Type","Source Subtype","Source No.","Source Line No.","Source Subline No.",TRUE);
        SETRANGE("Assemble to Order","Assemble to Order");
        IF FINDSET THEN BEGIN
          // Transfer receipt needs special treatment:
          IsTransferReceipt := ("Source Type" = DATABASE::"Transfer Line") AND ("Source Subtype" = 1);
          IsATOPosting := ("Source Type" = DATABASE::"Sales Line") AND "Assemble to Order";
          IF ("Source Type" IN [DATABASE::"Prod. Order Line",DATABASE::"Prod. Order Component"]) OR IsTransferReceipt THEN
            ToRowID :=
              ItemTrackingMgt.ComposeRowID(
                "Source Type","Source Subtype","Source No.",'',"Source Line No.","Source Subline No.")
          ELSE BEGIN
            IF IsATOPosting THEN BEGIN
              ATOSalesLine.GET("Source Subtype","Source No.","Source Line No.");
              ATOSalesLine.AsmToOrderExists(AsmHeader);
              ToRowID :=
                ItemTrackingMgt.ComposeRowID(
                  DATABASE::"Assembly Header",AsmHeader."Document Type",AsmHeader."No.",'',0,0);
            END ELSE
              ToRowID :=
                ItemTrackingMgt.ComposeRowID(
                  "Source Type","Source Subtype","Source No.",'',"Source Subline No.","Source Line No.");
          END;
          TempReservEntry.SetPointer(ToRowID);
          SignFactor := WhseActivitySignFactor(WhseActivLine);
          ReservEntryBindingCheck.SetPointer(ToRowID);
          ReservEntryBindingCheck.SetPointerFilter;
          REPEAT
            IF TrackingExists THEN BEGIN
              TempReservEntry."Entry No." += 1;
              TempReservEntry.Positive := SignFactor > 0;
              TempReservEntry."Item No." := "Item No.";
              TempReservEntry."Location Code" := "Location Code";
              TempReservEntry.Description := Description;
              TempReservEntry."Variant Code" := "Variant Code";
              TempReservEntry."Quantity (Base)" := "Qty. Outstanding (Base)" * SignFactor;
              TempReservEntry.Quantity := "Qty. Outstanding" * SignFactor;
              TempReservEntry."Qty. to Handle (Base)" := "Qty. to Handle (Base)" * SignFactor;
              TempReservEntry."Qty. to Invoice (Base)" := "Qty. to Handle (Base)" * SignFactor;
              TempReservEntry."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
              TempReservEntry.CopyTrackingFromWhseActivLine(WhseActivLine);
              TempReservEntry.INSERT;

              IF NOT IsBindingOrderToOrder THEN BEGIN
                ReservEntryBindingCheck.SetTrackingFilter("Serial No.","Lot No.");
                ReservEntryBindingCheck.SETRANGE(Binding,ReservEntryBindingCheck.Binding::"Order-to-Order");
                IsBindingOrderToOrder := NOT ReservEntryBindingCheck.ISEMPTY;
              END;
            END;
          UNTIL NEXT = 0;

          IF TempReservEntry.ISEMPTY THEN
            EXIT;
        END;
      END;

      SumUpItemTracking(TempReservEntry,TempTrackingSpec,FALSE,TRUE);

      IF TempTrackingSpec.FINDSET THEN
        REPEAT
          ReservEntry.SetSourceFilter(
            TempTrackingSpec."Source Type",TempTrackingSpec."Source Subtype",
            TempTrackingSpec."Source ID",TempTrackingSpec."Source Ref. No.",TRUE);
          ReservEntry.SetSourceFilter2('',TempTrackingSpec."Source Prod. Order Line");
          ReservEntry.SetTrackingFilterFromSpec(TempTrackingSpec);
          IF IsTransferReceipt THEN
            ReservEntry.SETRANGE("Source Ref. No.");
          IF ReservEntry.FINDSET THEN BEGIN
            REPEAT
              IF ABS(TempTrackingSpec."Qty. to Handle (Base)") > ABS(ReservEntry."Quantity (Base)") THEN
                ReservEntry.VALIDATE("Qty. to Handle (Base)",ReservEntry."Quantity (Base)")
              ELSE
                ReservEntry.VALIDATE("Qty. to Handle (Base)",TempTrackingSpec."Qty. to Handle (Base)");

              IF ABS(TempTrackingSpec."Qty. to Invoice (Base)") > ABS(ReservEntry."Quantity (Base)") THEN
                ReservEntry.VALIDATE("Qty. to Invoice (Base)",ReservEntry."Quantity (Base)")
              ELSE
                ReservEntry.VALIDATE("Qty. to Invoice (Base)",TempTrackingSpec."Qty. to Invoice (Base)");

              TempTrackingSpec."Qty. to Handle (Base)" -= ReservEntry."Qty. to Handle (Base)";
              TempTrackingSpec."Qty. to Invoice (Base)" -= ReservEntry."Qty. to Invoice (Base)";
              TempTrackingSpec.MODIFY;

              WITH WhseActivLine DO BEGIN
                RESET;
                SetSourceFilter("Source Type","Source Subtype","Source No.","Source Line No.","Source Subline No.",TRUE);
                SetTrackingFilter(ReservEntry."Serial No.",ReservEntry."Lot No.");
                IF FINDFIRST THEN
                  ReservEntry."Expiration Date" := "Expiration Date";
              END;

              ReservEntry.MODIFY;

              IF IsReservedFromTransferShipment(ReservEntry) THEN
                UpdateItemTrackingInTransferReceipt(ReservEntry);
            UNTIL ReservEntry.NEXT = 0;

            IF (TempTrackingSpec."Qty. to Handle (Base)" = 0) AND (TempTrackingSpec."Qty. to Invoice (Base)" = 0) THEN
              TempTrackingSpec.DELETE
            ELSE
              ERROR(CannotMatchItemTrackingErr);
          END;
        UNTIL TempTrackingSpec.NEXT = 0;

      IF TempTrackingSpec.FINDSET THEN
        REPEAT
          TempTrackingSpec."Quantity (Base)" := ABS(TempTrackingSpec."Qty. to Handle (Base)");
          TempTrackingSpec."Qty. to Handle (Base)" := ABS(TempTrackingSpec."Qty. to Handle (Base)");
          TempTrackingSpec."Qty. to Invoice (Base)" := ABS(TempTrackingSpec."Qty. to Invoice (Base)");
          TempTrackingSpec.MODIFY;
        UNTIL TempTrackingSpec.NEXT = 0;

      RegisterNewItemTrackingLines(TempTrackingSpec);
    END;

    LOCAL PROCEDURE RegisterNewItemTrackingLines@83(VAR TempTrackingSpec@1000 : TEMPORARY Record 336);
    VAR
      TrackingSpec@1001 : Record 336;
      ItemTrackingLines@1002 : Page 6510;
    BEGIN
      IF TempTrackingSpec.FINDSET THEN
        REPEAT
          TempTrackingSpec.SetSourceFilter(
            TempTrackingSpec."Source Type",TempTrackingSpec."Source Subtype",
            TempTrackingSpec."Source ID",TempTrackingSpec."Source Ref. No.",FALSE);
          TempTrackingSpec.SETRANGE("Source Prod. Order Line",TempTrackingSpec."Source Prod. Order Line");

          TrackingSpec := TempTrackingSpec;
          TempTrackingSpec.CALCSUMS("Qty. to Handle (Base)");

          TrackingSpec."Quantity (Base)" :=
            TempTrackingSpec."Qty. to Handle (Base)" + ABS(ItemTrkgQtyPostedOnSource(TrackingSpec));

          CLEAR(ItemTrackingLines);
          ItemTrackingLines.SetCalledFromSynchWhseItemTrkg(TRUE);
          ItemTrackingLines.RegisterItemTrackingLines(TrackingSpec,TrackingSpec."Creation Date",TempTrackingSpec);
          TempTrackingSpec.ClearSourceFilter;
        UNTIL TempTrackingSpec.NEXT = 0;
    END;

    LOCAL PROCEDURE WhseActivitySignFactor@111(WhseActivityLine@1102601000 : Record 5767) : Integer;
    BEGIN
      IF WhseActivityLine."Activity Type" = WhseActivityLine."Activity Type"::"Invt. Pick" THEN BEGIN
        IF WhseActivityLine."Assemble to Order" THEN
          EXIT(1);
        EXIT(-1);
      END;
      IF WhseActivityLine."Activity Type" = WhseActivityLine."Activity Type"::"Invt. Put-away" THEN
        EXIT(1);

      ERROR(Text011,WhseActivityLine.FIELDCAPTION("Activity Type"),WhseActivityLine."Activity Type");
    END;

    [External]
    PROCEDURE RetrieveAppliedExpirationDate@77(VAR TempItemLedgEntry@1000 : TEMPORARY Record 32);
    VAR
      ItemLedgEntry@1002 : Record 32;
      ItemApplnEntry@1001 : Record 339;
    BEGIN
      WITH TempItemLedgEntry DO BEGIN
        IF Positive THEN
          EXIT;

        ItemApplnEntry.RESET;
        ItemApplnEntry.SETCURRENTKEY("Outbound Item Entry No.","Item Ledger Entry No.","Cost Application");
        ItemApplnEntry.SETRANGE("Outbound Item Entry No.","Entry No.");
        ItemApplnEntry.SETRANGE("Item Ledger Entry No.","Entry No.");
        IF ItemApplnEntry.FINDFIRST THEN BEGIN
          ItemLedgEntry.GET(ItemApplnEntry."Inbound Item Entry No.");
          "Expiration Date" := ItemLedgEntry."Expiration Date";
        END;
      END;
    END;

    LOCAL PROCEDURE ItemTrkgQtyPostedOnSource@78(SourceTrackingSpec@1001 : Record 336) Qty : Decimal;
    VAR
      TrackingSpecification@1000 : Record 336;
      ReservEntry@1002 : Record 337;
      TransferLine@1003 : Record 5741;
    BEGIN
      WITH SourceTrackingSpec DO BEGIN
        TrackingSpecification.SetSourceFilter("Source Type","Source Subtype","Source ID","Source Ref. No.",TRUE);
        TrackingSpecification.SetSourceFilter2("Source Batch Name","Source Prod. Order Line");
        IF NOT TrackingSpecification.ISEMPTY THEN BEGIN
          TrackingSpecification.FINDSET;
          REPEAT
            Qty += TrackingSpecification."Quantity (Base)";
          UNTIL TrackingSpecification.NEXT = 0;
        END;

        ReservEntry.SetSourceFilter("Source Type","Source Subtype","Source ID","Source Ref. No.",FALSE);
        ReservEntry.SetSourceFilter2('',"Source Prod. Order Line");
        IF NOT ReservEntry.ISEMPTY THEN BEGIN
          ReservEntry.FINDSET;
          REPEAT
            Qty += ReservEntry."Qty. to Handle (Base)";
          UNTIL ReservEntry.NEXT = 0;
        END;
        IF "Source Type" = DATABASE::"Transfer Line" THEN BEGIN
          TransferLine.GET("Source ID","Source Ref. No.");
          Qty -= TransferLine."Qty. Shipped (Base)";
        END;
      END;
    END;

    LOCAL PROCEDURE UpdateItemTrackingInTransferReceipt@59(FromReservEntry@1001 : Record 337);
    VAR
      ToReservEntry@1000 : Record 337;
      ToRowID@1002 : Text[250];
    BEGIN
      ToRowID := ComposeRowID(
          DATABASE::"Transfer Line",1,FromReservEntry."Source ID",
          FromReservEntry."Source Batch Name",FromReservEntry."Source Prod. Order Line",FromReservEntry."Source Ref. No.");
      ToReservEntry.SetPointer(ToRowID);
      ToReservEntry.SetPointerFilter;
      SynchronizeItemTrkgTransfer(ToReservEntry);
    END;

    LOCAL PROCEDURE SynchronizeItemTrkgTransfer@88(VAR ToReservEntry@1000 : Record 337);
    VAR
      FromReservEntry@1001 : Record 337;
      TempReservEntry@1004 : TEMPORARY Record 337;
      QtyToHandleBase@1002 : Decimal;
      QtyToInvoiceBase@1003 : Decimal;
      QtyBase@1005 : Decimal;
    BEGIN
      FromReservEntry.COPY(ToReservEntry);
      FromReservEntry.SETRANGE("Source Subtype",0);
      IF ToReservEntry.FINDSET THEN
        REPEAT
          TempReservEntry := ToReservEntry;
          TempReservEntry.INSERT;
        UNTIL ToReservEntry.NEXT = 0;

      TempReservEntry.SETCURRENTKEY(
        "Item No.","Variant Code","Location Code","Item Tracking","Reservation Status","Lot No.","Serial No.");
      IF TempReservEntry.FIND('-') THEN
        REPEAT
          FromReservEntry.SetTrackingFilterFromReservEntry(TempReservEntry);

          QtyToHandleBase := 0;
          QtyToInvoiceBase := 0;
          QtyBase := 0;
          IF FromReservEntry.FIND('-') THEN
            // due to Order Tracking there can be more than 1 record
            REPEAT
              QtyToHandleBase += FromReservEntry."Qty. to Handle (Base)";
              QtyToInvoiceBase += FromReservEntry."Qty. to Invoice (Base)";
              QtyBase += FromReservEntry."Quantity (Base)";
            UNTIL FromReservEntry.NEXT = 0;

          TempReservEntry.SetTrackingFilterFromReservEntry(TempReservEntry);
          REPEAT
            // remove already synchronized qty (can be also more than 1 record)
            QtyToHandleBase += TempReservEntry."Qty. to Handle (Base)";
            QtyToInvoiceBase += TempReservEntry."Qty. to Invoice (Base)";
            QtyBase += TempReservEntry."Quantity (Base)";
            TempReservEntry.DELETE;
          UNTIL TempReservEntry.NEXT = 0;
          TempReservEntry.ClearTrackingFilter;

          IF QtyToHandleBase <> 0 THEN BEGIN
            // remaining qty will be added to the last record
            ToReservEntry := TempReservEntry;
            IF QtyBase <> 0 THEN BEGIN
              ToReservEntry."Qty. to Handle (Base)" := -QtyToHandleBase;
              ToReservEntry."Qty. to Invoice (Base)" := -QtyToInvoiceBase;
            END ELSE BEGIN
              ToReservEntry."Qty. to Handle (Base)" -= QtyToHandleBase;
              ToReservEntry."Qty. to Invoice (Base)" -= QtyToInvoiceBase;
            END;
            ToReservEntry.MODIFY;
          END;
        UNTIL TempReservEntry.NEXT = 0;
    END;

    [External]
    PROCEDURE InitCollectItemTrkgInformation@87();
    BEGIN
      TempGlobalWhseItemTrkgLine.DELETEALL;
    END;

    [External]
    PROCEDURE CollectItemTrkgInfWhseJnlLine@86(WhseJnlLine@1000 : Record 7311);
    VAR
      WhseItemTrackingLine@1001 : Record 6550;
    BEGIN
      WITH WhseItemTrackingLine DO BEGIN
        SetSourceFilter(
          DATABASE::"Warehouse Journal Line",-1,WhseJnlLine."Journal Batch Name",WhseJnlLine."Line No.",TRUE);
        SetSourceFilter2(WhseJnlLine."Journal Template Name",-1);
        SETRANGE("Location Code",WhseJnlLine."Location Code");
        SETRANGE("Item No.",WhseJnlLine."Item No.");
        SETRANGE("Variant Code",WhseJnlLine."Variant Code");
        SETRANGE("Qty. per Unit of Measure",WhseJnlLine."Qty. per Unit of Measure");
        IF FINDSET THEN
          REPEAT
            CLEAR(TempGlobalWhseItemTrkgLine);
            TempGlobalWhseItemTrkgLine := WhseItemTrackingLine;
            IF TempGlobalWhseItemTrkgLine.INSERT THEN;
          UNTIL NEXT = 0;
      END;
    END;

    [External]
    PROCEDURE CheckItemTrkgInfBeforePost@89();
    VAR
      TempItemLotInfo@1000 : TEMPORARY Record 6505;
      CheckExpDate@1001 : Date;
      ErrorFound@1002 : Boolean;
      EndLoop@1003 : Boolean;
      ErrMsgTxt@1004 : Text[160];
    BEGIN
      // Check for different expiration dates within one Lot no.
      IF TempGlobalWhseItemTrkgLine.FIND('-') THEN BEGIN
        TempItemLotInfo.DELETEALL;
        REPEAT
          IF TempGlobalWhseItemTrkgLine."New Lot No." <> '' THEN BEGIN
            CLEAR(TempItemLotInfo);
            TempItemLotInfo."Item No." := TempGlobalWhseItemTrkgLine."Item No.";
            TempItemLotInfo."Variant Code" := TempGlobalWhseItemTrkgLine."Variant Code";
            TempItemLotInfo."Lot No." := TempGlobalWhseItemTrkgLine."New Lot No.";
            IF TempItemLotInfo.INSERT THEN;
          END;
        UNTIL TempGlobalWhseItemTrkgLine.NEXT = 0;

        IF TempItemLotInfo.FIND('-') THEN
          REPEAT
            ErrorFound := FALSE;
            EndLoop := FALSE;
            IF TempGlobalWhseItemTrkgLine.FIND('-') THEN BEGIN
              CheckExpDate := 0D;
              REPEAT
                IF (TempGlobalWhseItemTrkgLine."Item No." = TempItemLotInfo."Item No.") AND
                   (TempGlobalWhseItemTrkgLine."Variant Code" = TempItemLotInfo."Variant Code") AND
                   (TempGlobalWhseItemTrkgLine."New Lot No." = TempItemLotInfo."Lot No.")
                THEN
                  IF CheckExpDate = 0D THEN
                    CheckExpDate := TempGlobalWhseItemTrkgLine."New Expiration Date"
                  ELSE
                    IF TempGlobalWhseItemTrkgLine."New Expiration Date" <> CheckExpDate THEN BEGIN
                      ErrorFound := TRUE;
                      ErrMsgTxt :=
                        STRSUBSTNO(Text012,
                          TempGlobalWhseItemTrkgLine."Lot No.",
                          TempGlobalWhseItemTrkgLine."New Expiration Date",
                          CheckExpDate);
                    END;
                IF NOT ErrorFound THEN
                  IF TempGlobalWhseItemTrkgLine.NEXT = 0 THEN
                    EndLoop := TRUE;
              UNTIL EndLoop OR ErrorFound;
            END;
          UNTIL (TempItemLotInfo.NEXT = 0) OR ErrorFound;
        IF ErrorFound THEN
          ERROR(ErrMsgTxt);
      END;
    END;

    [External]
    PROCEDURE SetPick@90(IsPick2@1000 : Boolean);
    BEGIN
      IsPick := IsPick2;
    END;

    [External]
    PROCEDURE StrictExpirationPosting@32(ItemNo@1000 : Code[20]) : Boolean;
    VAR
      Item@1001 : Record 27;
      ItemTrackingCode@1002 : Record 6502;
    BEGIN
      Item.GET(ItemNo);
      IF Item."Item Tracking Code" = '' THEN
        EXIT(FALSE);
      ItemTrackingCode.GET(Item."Item Tracking Code");
      EXIT(ItemTrackingCode."Strict Expiration Posting");
    END;

    [External]
    PROCEDURE WhseItemTrkgLineExists@109(SourceId@1000 : Code[20];SourceType@1001 : Integer;SourceSubtype@1002 : Integer;SourceBatchName@1003 : Code[10];SourceProdOrderLine@1004 : Integer;SourceRefNo@1005 : Integer;LocationCode@1006 : Code[10];SerialNo@1007 : Code[20];LotNo@1008 : Code[20]) : Boolean;
    VAR
      WhseItemTrkgLine@1009 : Record 6550;
    BEGIN
      WITH WhseItemTrkgLine DO BEGIN
        SetSourceFilter(SourceType,SourceSubtype,SourceId,SourceRefNo,TRUE);
        SetSourceFilter2(SourceBatchName,SourceProdOrderLine);
        SETRANGE("Location Code",LocationCode);
        IF SerialNo <> '' THEN
          SETRANGE("Serial No.",SerialNo);
        IF LotNo <> '' THEN
          SETRANGE("Lot No.",LotNo);
        EXIT(NOT ISEMPTY);
      END;
    END;

    LOCAL PROCEDURE SetWhseSerialLotNo@113(VAR DestNo@1000 : Code[20];SourceNo@1001 : Code[20];NoRequired@1002 : Boolean);
    BEGIN
      IF NoRequired THEN
        DestNo := SourceNo;
    END;

    LOCAL PROCEDURE InsertProspectReservEntryFromItemEntryRelationAndSourceData@10(VAR ItemEntryRelation@1001 : Record 6507;SourceSubtype@1002 : Option;SourceID@1003 : Code[20];SourceRefNo@1004 : Integer);
    VAR
      TrackingSpecification@1000 : Record 336;
      QtyBase@1005 : Decimal;
    BEGIN
      IF NOT ItemEntryRelation.FINDSET THEN
        EXIT;

      REPEAT
        TrackingSpecification.GET(ItemEntryRelation."Item Entry No.");
        QtyBase := TrackingSpecification."Quantity (Base)" - TrackingSpecification."Quantity Invoiced (Base)";
        InsertReservEntryFromTrackingSpec(
          TrackingSpecification,SourceSubtype,SourceID,SourceRefNo,QtyBase);
      UNTIL ItemEntryRelation.NEXT = 0;
    END;

    [External]
    PROCEDURE UpdateQuantities@116(WhseWorksheetLine@1006 : Record 7326;VAR TotalWhseItemTrackingLine@1008 : Record 6550;VAR SourceQuantityArray@1001 : ARRAY [2] OF Decimal;VAR UndefinedQtyArray@1007 : ARRAY [2] OF Decimal;SourceType@1002 : Integer) : Boolean;
    BEGIN
      SourceQuantityArray[1] := ABS(WhseWorksheetLine."Qty. (Base)");
      SourceQuantityArray[2] := ABS(WhseWorksheetLine."Qty. to Handle (Base)");
      EXIT(CalculateSums(WhseWorksheetLine,TotalWhseItemTrackingLine,SourceQuantityArray,UndefinedQtyArray,SourceType));
    END;

    [External]
    PROCEDURE CalculateSums@115(WhseWorksheetLine@1005 : Record 7326;VAR TotalWhseItemTrackingLine@1003 : Record 6550;SourceQuantityArray@1001 : ARRAY [2] OF Decimal;VAR UndefinedQtyArray@1002 : ARRAY [2] OF Decimal;SourceType@1004 : Integer) : Boolean;
    BEGIN
      WITH TotalWhseItemTrackingLine DO BEGIN
        SETRANGE("Location Code",WhseWorksheetLine."Location Code");
        CASE SourceType OF
          DATABASE::"Posted Whse. Receipt Line",
          DATABASE::"Warehouse Shipment Line",
          DATABASE::"Whse. Internal Put-away Line",
          DATABASE::"Whse. Internal Pick Line",
          DATABASE::"Assembly Line",
          DATABASE::"Internal Movement Line":
            SetSourceFilter(
              SourceType,-1,WhseWorksheetLine."Whse. Document No.",WhseWorksheetLine."Whse. Document Line No.",TRUE);
          DATABASE::"Prod. Order Component":
            BEGIN
              SetSourceFilter(
                SourceType,WhseWorksheetLine."Source Subtype",WhseWorksheetLine."Source No.",WhseWorksheetLine."Source Subline No.",
                TRUE);
              SETRANGE("Source Prod. Order Line",WhseWorksheetLine."Source Line No.");
            END;
          DATABASE::"Whse. Worksheet Line",
          DATABASE::"Warehouse Journal Line":
            BEGIN
              SetSourceFilter(SourceType,-1,WhseWorksheetLine.Name,WhseWorksheetLine."Line No.",TRUE);
              SETRANGE("Source Batch Name",WhseWorksheetLine."Worksheet Template Name");
            END;
        END;
        CALCSUMS("Quantity (Base)","Qty. to Handle (Base)");
      END;
      EXIT(UpdateUndefinedQty(TotalWhseItemTrackingLine,SourceQuantityArray,UndefinedQtyArray));
    END;

    [External]
    PROCEDURE UpdateUndefinedQty@114(TotalWhseItemTrackingLine@1004 : Record 6550;SourceQuantityArray@1002 : ARRAY [2] OF Decimal;VAR UndefinedQtyArray@1003 : ARRAY [2] OF Decimal) : Boolean;
    BEGIN
      UndefinedQtyArray[1] := SourceQuantityArray[1] - TotalWhseItemTrackingLine."Quantity (Base)";
      UndefinedQtyArray[2] := SourceQuantityArray[2] - TotalWhseItemTrackingLine."Qty. to Handle (Base)";
      EXIT(NOT (ABS(SourceQuantityArray[1]) < ABS(TotalWhseItemTrackingLine."Quantity (Base)")));
    END;

    LOCAL PROCEDURE InsertReservEntryForSalesLine@12(VAR ReservEntry@1006 : Record 337;ItemLedgEntryBuf@1004 : Record 32;SalesLine@1003 : Record 37;QtyBase@1002 : Decimal;AppliedFromItemEntry@1001 : Boolean;VAR EntriesExist@1000 : Boolean);
    BEGIN
      IF QtyBase = 0 THEN
        EXIT;

      WITH ReservEntry DO BEGIN
        InitReservEntry(ReservEntry,ItemLedgEntryBuf,QtyBase,SalesLine."Shipment Date",EntriesExist);
        SetSource(
          DATABASE::"Sales Line",SalesLine."Document Type",SalesLine."Document No.",SalesLine."Line No.",'',0);
        IF SalesLine."Document Type" IN [SalesLine."Document Type"::Order,SalesLine."Document Type"::"Return Order"] THEN
          "Reservation Status" := "Reservation Status"::Surplus
        ELSE
          "Reservation Status" := "Reservation Status"::Prospect;
        IF AppliedFromItemEntry THEN
          "Appl.-from Item Entry" := ItemLedgEntryBuf."Entry No.";
        Description := SalesLine.Description;
        OnCopyItemLedgEntryTrkgToDocLine(ItemLedgEntryBuf,ReservEntry);
        UpdateItemTracking;
        INSERT;
      END;
    END;

    LOCAL PROCEDURE InsertReservEntryForPurchLine@117(ItemLedgEntryBuf@1001 : Record 32;PurchaseLine@1000 : Record 39;QtyBase@1003 : Decimal;AppliedToItemEntry@1004 : Boolean;VAR EntriesExist@1005 : Boolean);
    VAR
      ReservEntry@1002 : Record 337;
    BEGIN
      IF QtyBase = 0 THEN
        EXIT;

      WITH ReservEntry DO BEGIN
        InitReservEntry(ReservEntry,ItemLedgEntryBuf,QtyBase,PurchaseLine."Expected Receipt Date",EntriesExist);
        SetSource(DATABASE::"Purchase Line",PurchaseLine."Document Type",PurchaseLine."Document No.",PurchaseLine."Line No.",'',0);
        IF PurchaseLine."Document Type" IN [PurchaseLine."Document Type"::Order,PurchaseLine."Document Type"::"Return Order"] THEN
          "Reservation Status" := "Reservation Status"::Surplus
        ELSE
          "Reservation Status" := "Reservation Status"::Prospect;
        IF AppliedToItemEntry THEN
          "Appl.-to Item Entry" := ItemLedgEntryBuf."Entry No.";
        Description := PurchaseLine.Description;
        UpdateItemTracking;
        INSERT;
      END;
    END;

    LOCAL PROCEDURE InsertReservEntryFromTrackingSpec@39(TrackingSpecification@1000 : Record 336;SourceSubtype@1005 : Option;SourceID@1004 : Code[20];SourceRefNo@1003 : Integer;QtyBase@1001 : Decimal);
    VAR
      ReservEntry@1002 : Record 337;
    BEGIN
      IF QtyBase = 0 THEN
        EXIT;

      WITH ReservEntry DO BEGIN
        INIT;
        TRANSFERFIELDS(TrackingSpecification);
        "Source Subtype" := SourceSubtype;
        "Source ID" := SourceID;
        "Source Ref. No." := SourceRefNo;
        "Reservation Status" := "Reservation Status"::Prospect;
        "Quantity Invoiced (Base)" := 0;
        VALIDATE("Quantity (Base)",QtyBase);
        Positive := ("Quantity (Base)" > 0);
        "Entry No." := 0;
        "Item Tracking" := ItemTrackingOption("Lot No.","Serial No.");
        INSERT;
      END;
    END;

    LOCAL PROCEDURE InitReservEntry@18(VAR ReservEntry@1000 : Record 337;ItemLedgEntryBuf@1002 : Record 32;QtyBase@1003 : Decimal;Date@1001 : Date;VAR EntriesExist@1004 : Boolean);
    BEGIN
      WITH ReservEntry DO BEGIN
        INIT;
        "Item No." := ItemLedgEntryBuf."Item No.";
        "Location Code" := ItemLedgEntryBuf."Location Code";
        "Variant Code" := ItemLedgEntryBuf."Variant Code";
        "Qty. per Unit of Measure" := ItemLedgEntryBuf."Qty. per Unit of Measure";
        CopyTrackingFromItemLedgEntry(ItemLedgEntryBuf);
        "Quantity Invoiced (Base)" := 0;
        VALIDATE("Quantity (Base)",QtyBase);
        Positive := ("Quantity (Base)" > 0);
        "Entry No." := 0;
        IF Positive THEN BEGIN
          "Warranty Date" := ItemLedgEntryBuf."Warranty Date";
          "Expiration Date" :=
            ExistingExpirationDate("Item No.","Variant Code","Lot No.","Serial No.",FALSE,EntriesExist);
          "Expected Receipt Date" := Date;
        END ELSE
          "Shipment Date" := Date;
        "Creation Date" := WORKDATE;
        "Created By" := USERID;
      END;
    END;

    [External]
    PROCEDURE DeleteInvoiceSpecFromHeader@17(SourceType@1001 : Integer;SourceSubtype@1002 : Option;SourceID@1003 : Code[20]);
    VAR
      TrackingSpecification@1000 : Record 336;
    BEGIN
      TrackingSpecification.SetSourceFilter(SourceType,SourceSubtype,SourceID,-1,FALSE);
      TrackingSpecification.SetSourceFilter2('',0);
      TrackingSpecification.DELETEALL;
    END;

    [External]
    PROCEDURE DeleteInvoiceSpecFromLine@6(SourceType@1003 : Integer;SourceSubtype@1002 : Option;SourceID@1001 : Code[20];SourceRefNo@1004 : Integer);
    VAR
      TrackingSpecification@1000 : Record 336;
    BEGIN
      TrackingSpecification.SetSourceFilter(SourceType,SourceSubtype,SourceID,SourceRefNo,FALSE);
      TrackingSpecification.SetSourceFilter2('',0);
      TrackingSpecification.DELETEALL;
    END;

    LOCAL PROCEDURE IsReservedFromTransferShipment@61(ReservEntry@1000 : Record 337) : Boolean;
    BEGIN
      EXIT((ReservEntry."Source Type" = DATABASE::"Transfer Line") AND (ReservEntry."Source Subtype" = 0));
    END;

    [Integration]
    LOCAL PROCEDURE OnCopyItemLedgEntryTrkgToDocLine@62(VAR ItemLedgerEntry@1000 : Record 32;VAR ReservationEntry@1001 : Record 337);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterReserveEntryFilter@63(ItemJournalLine@1000 : Record 83;VAR ReservationEntry@1001 : Record 337);
    BEGIN
    END;

    BEGIN
    END.
  }
}

