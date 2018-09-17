OBJECT Codeunit 432 Consolidate
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    TableNo=220;
    Permissions=TableData 17=rimd;
    OnRun=VAR
            PreviousDate@1000 : Date;
            i@1001 : Integer;
          BEGIN
            BusUnit := Rec;
            IF NORMALDATE(EndingDate) - NORMALDATE(StartingDate) + 1 > ARRAYLEN(RoundingResiduals) THEN
              ReportError(STRSUBSTNO(Text008,ARRAYLEN(RoundingResiduals)));

            IF ("Starting Date" <> 0D) OR ("Ending Date" <> 0D) THEN BEGIN
              IF "Starting Date" = 0D THEN
                ReportError(STRSUBSTNO(
                    Text033,FIELDCAPTION("Starting Date"),
                    FIELDCAPTION("Ending Date"),"Company Name"));
              IF "Ending Date" = 0D THEN
                ReportError(STRSUBSTNO(
                    Text033,FIELDCAPTION("Ending Date"),
                    FIELDCAPTION("Starting Date"),"Company Name"));
              IF "Starting Date" > "Ending Date" THEN
                ReportError(STRSUBSTNO(
                    Text032,FIELDCAPTION("Starting Date"),
                    FIELDCAPTION("Ending Date"),"Company Name"));
            END;

            ConsolidatingClosingDate :=
              (StartingDate = EndingDate) AND
              (StartingDate <> NORMALDATE(StartingDate));
            IF (StartingDate <> NORMALDATE(StartingDate)) AND
               (StartingDate <> EndingDate)
            THEN
              ReportError(Text030);

            ReadSourceCodeSetup;
            ClearInternals;
            Window.OPEN(Text001 + Text002 + Text003 + Text004);
            Window.UPDATE(1,BusUnit.Code);

            IF NOT TestMode THEN BEGIN
              UpdatePhase(Text018);
              ClearPreviousConsolidation;
            END;

            IF ("Last Balance Currency Factor" <> 0) AND
               ("Balance Currency Factor" <> "Last Balance Currency Factor")
            THEN BEGIN
              UpdatePhase(Text019);
              UpdatePriorPeriodBalances;
            END;

            // Consolidate Current Entries
            UpdatePhase(Text020);
            CLEAR(GenJnlLine);
            GenJnlLine."Business Unit Code" := BusUnit.Code;
            GenJnlLine."Document No." := GLDocNo;
            GenJnlLine."Source Code" := ConsolidSourceCode;
            TempSubsidGLEntry.RESET;
            TempSubsidGLEntry.SETCURRENTKEY("G/L Account No.","Posting Date");
            TempSubsidGLEntry.SETRANGE("Posting Date",StartingDate,EndingDate);
            TempSubsidGLAcc.RESET;
            IF TempSubsidGLAcc.FINDSET THEN
              REPEAT
                Window.UPDATE(3,TempSubsidGLAcc."No.");
                DimBufMgt.DeleteAllDimensions;
                InitializeGLAccount;
                PreviousDate := 0D;
                IF TempSubsidGLEntry.FINDSET THEN
                  REPEAT
                    IF (TempSubsidGLEntry."Posting Date" <> NORMALDATE(TempSubsidGLEntry."Posting Date")) AND
                       NOT ConsolidatingClosingDate
                    THEN
                      ReportError(
                        STRSUBSTNO(Text031,
                          TempSubsidGLEntry.TABLECAPTION,
                          TempSubsidGLEntry.FIELDCAPTION("Posting Date"),
                          TempSubsidGLEntry."Posting Date"));
                    IF (TempSubsidGLAcc."Consol. Translation Method" = TempSubsidGLAcc."Consol. Translation Method"::"Historical Rate") AND
                       (TempSubsidGLEntry."Posting Date" <> PreviousDate)
                    THEN BEGIN
                      IF PreviousDate <> 0D THEN BEGIN
                        TempDimBufOut.RESET;
                        TempDimBufOut.DELETEALL;
                        IF TempGLEntry.FINDSET THEN
                          REPEAT
                            IF NOT SkipAllDimensions THEN BEGIN
                              DimBufMgt.GetDimensions(TempGLEntry."Entry No.",TempDimBufOut);
                              TempDimBufOut.SETRANGE("Entry No.",TempGLEntry."Entry No.");
                            END;
                            CreateAndPostGenJnlLine(GenJnlLine,TempGLEntry,TempDimBufOut);
                          UNTIL TempGLEntry.NEXT = 0;
                      END;
                      TempGLEntry.RESET;
                      TempGLEntry.DELETEALL;
                      DimBufMgt.DeleteAllDimensions;
                      PreviousDate := TempSubsidGLEntry."Posting Date";
                    END;
                    TempDimBufIn.RESET;
                    TempDimBufIn.DELETEALL;
                    IF NOT SkipAllDimensions THEN BEGIN
                      TempSubsidDimBuf.SETRANGE("Entry No.",TempSubsidGLEntry."Entry No.");
                      IF TempSubsidDimBuf.FINDSET THEN
                        REPEAT
                          IF TempSelectedDim.GET('',0,0,'',TempSubsidDimBuf."Dimension Code") THEN BEGIN
                            TempDimBufIn.INIT;
                            TempDimBufIn."Table ID" := DATABASE::"G/L Entry";
                            TempDimBufIn."Entry No." := TempSubsidGLEntry."Entry No.";
                            TempDimBufIn."Dimension Code" := TempSubsidDimBuf."Dimension Code";
                            TempDimBufIn."Dimension Value Code" := TempSubsidDimBuf."Dimension Value Code";
                            TempDimBufIn.INSERT;
                          END;
                        UNTIL TempSubsidDimBuf.NEXT = 0;
                    END;
                    UpdateTempGLEntry(TempSubsidGLEntry);
                  UNTIL TempSubsidGLEntry.NEXT = 0;

                TempDimBufOut.RESET;
                TempDimBufOut.DELETEALL;
                IF TempGLEntry.FINDSET THEN
                  REPEAT
                    IF NOT SkipAllDimensions THEN BEGIN
                      DimBufMgt.GetDimensions(TempGLEntry."Entry No.",TempDimBufOut);
                      TempDimBufOut.SETRANGE("Entry No.",TempGLEntry."Entry No.");
                    END;
                    CreateAndPostGenJnlLine(GenJnlLine,TempGLEntry,TempDimBufOut);
                  UNTIL TempGLEntry.NEXT = 0;
              UNTIL TempSubsidGLAcc.NEXT = 0;

            // Post balancing entries and adjustments
            UpdatePhase(Text025);

            FOR i := 1 TO NORMALDATE(EndingDate) - NORMALDATE(StartingDate) + 1 DO BEGIN
              IF ExchRateAdjAmounts[i] <> 0 THEN BEGIN
                GenJnlLine.Amount := ExchRateAdjAmounts[i];
                IF (BusUnit."Consolidation %" < 100) AND
                   (BusUnit."Consolidation %" > 0)
                THEN BEGIN
                  GenJnlLine.Amount := GenJnlLine.Amount * 100 / BusUnit."Consolidation %";
                  MinorExchRateAdjAmts[i] :=
                    MinorExchRateAdjAmts[i] - GenJnlLine.Amount + ExchRateAdjAmounts[i];
                END;
                IF GenJnlLine.Amount < 0 THEN BEGIN
                  BusUnit.TESTFIELD("Exch. Rate Gains Acc.");
                  GenJnlLine."Account No." := BusUnit."Exch. Rate Gains Acc.";
                END ELSE BEGIN
                  BusUnit.TESTFIELD("Exch. Rate Losses Acc.");
                  GenJnlLine."Account No." := BusUnit."Exch. Rate Losses Acc.";
                END;
                Window.UPDATE(3,GenJnlLine."Account No.");
                IF NOT ConsolidatingClosingDate THEN
                  GenJnlLine."Posting Date" := StartingDate + i - 1
                ELSE
                  GenJnlLine."Posting Date" := StartingDate;
                GenJnlLine.Description := STRSUBSTNO(Text015,WORKDATE);
                GenJnlPostLineTmp(GenJnlLine);
                RoundingResiduals[i] := RoundingResiduals[i] + GenJnlLine.Amount;
              END;
              IF CompExchRateAdjAmts[i] <> 0 THEN BEGIN
                GenJnlLine.Amount := CompExchRateAdjAmts[i];
                IF (BusUnit."Consolidation %" < 100) AND
                   (BusUnit."Consolidation %" > 0)
                THEN BEGIN
                  GenJnlLine.Amount := GenJnlLine.Amount * 100 / BusUnit."Consolidation %";
                  MinorExchRateAdjAmts[i] :=
                    MinorExchRateAdjAmts[i] - GenJnlLine.Amount + CompExchRateAdjAmts[i];
                END;
                IF GenJnlLine.Amount < 0 THEN BEGIN
                  BusUnit.TESTFIELD("Comp. Exch. Rate Gains Acc.");
                  GenJnlLine."Account No." := BusUnit."Comp. Exch. Rate Gains Acc.";
                END ELSE BEGIN
                  BusUnit.TESTFIELD("Comp. Exch. Rate Losses Acc.");
                  GenJnlLine."Account No." := BusUnit."Comp. Exch. Rate Losses Acc.";
                END;
                Window.UPDATE(3,GenJnlLine."Account No.");
                IF NOT ConsolidatingClosingDate THEN
                  GenJnlLine."Posting Date" := StartingDate + i - 1
                ELSE
                  GenJnlLine."Posting Date" := StartingDate;
                GenJnlLine.Description := STRSUBSTNO(Text027 + Text015,WORKDATE);
                GenJnlPostLineTmp(GenJnlLine);
                RoundingResiduals[i] := RoundingResiduals[i] + GenJnlLine.Amount;
              END;
              IF EqExchRateAdjAmts[i] <> 0 THEN BEGIN
                GenJnlLine.Amount := EqExchRateAdjAmts[i];
                IF (BusUnit."Consolidation %" < 100) AND
                   (BusUnit."Consolidation %" > 0)
                THEN BEGIN
                  GenJnlLine.Amount := GenJnlLine.Amount * 100 / BusUnit."Consolidation %";
                  MinorExchRateAdjAmts[i] :=
                    MinorExchRateAdjAmts[i] - GenJnlLine.Amount + EqExchRateAdjAmts[i];
                END;
                IF GenJnlLine.Amount < 0 THEN BEGIN
                  BusUnit.TESTFIELD("Equity Exch. Rate Gains Acc.");
                  GenJnlLine."Account No." := BusUnit."Equity Exch. Rate Gains Acc.";
                END ELSE BEGIN
                  BusUnit.TESTFIELD("Equity Exch. Rate Losses Acc.");
                  GenJnlLine."Account No." := BusUnit."Equity Exch. Rate Losses Acc.";
                END;
                Window.UPDATE(3,GenJnlLine."Account No.");
                IF NOT ConsolidatingClosingDate THEN
                  GenJnlLine."Posting Date" := StartingDate + i - 1
                ELSE
                  GenJnlLine."Posting Date" := StartingDate;
                GenJnlLine.Description := STRSUBSTNO(Text028 + Text015,WORKDATE);
                GenJnlPostLineTmp(GenJnlLine);
                RoundingResiduals[i] := RoundingResiduals[i] + GenJnlLine.Amount;
              END;
              IF MinorExchRateAdjAmts[i] <> 0 THEN BEGIN
                GenJnlLine.Amount := MinorExchRateAdjAmts[i];
                IF GenJnlLine.Amount < 0 THEN BEGIN
                  BusUnit.TESTFIELD("Minority Exch. Rate Gains Acc.");
                  GenJnlLine."Account No." := BusUnit."Minority Exch. Rate Gains Acc.";
                END ELSE BEGIN
                  BusUnit.TESTFIELD("Minority Exch. Rate Losses Acc");
                  GenJnlLine."Account No." := BusUnit."Minority Exch. Rate Losses Acc";
                END;
                Window.UPDATE(3,GenJnlLine."Account No.");
                GenJnlLine."Posting Date" := StartingDate + i - 1;
                GenJnlLine.Description := STRSUBSTNO(Text029 + Text015,WORKDATE);
                GenJnlPostLineTmp(GenJnlLine);
                RoundingResiduals[i] := RoundingResiduals[i] + GenJnlLine.Amount;
              END;
              IF RoundingResiduals[i] <> 0 THEN BEGIN
                GenJnlLine.Amount := -RoundingResiduals[i];
                BusUnit.TESTFIELD("Residual Account");
                GenJnlLine."Account No." := BusUnit."Residual Account";
                Window.UPDATE(3,GenJnlLine."Account No.");
                IF NOT ConsolidatingClosingDate THEN
                  GenJnlLine."Posting Date" := StartingDate + i - 1
                ELSE
                  GenJnlLine."Posting Date" := StartingDate;
                GenJnlLine.Description :=
                  COPYSTR(
                    STRSUBSTNO(Text016,WORKDATE,GenJnlLine.Amount),
                    1,MAXSTRLEN(GenJnlLine.Description));
                GenJnlPostLineTmp(GenJnlLine);
              END;
            END;

            IF NOT TestMode THEN BEGIN
              UpdatePhase(Text026);
              GenJnlPostLineFinally;
            END;
            Window.CLOSE;

            IF NOT TestMode THEN BEGIN
              BusUnit."Last Balance Currency Factor" := BusUnit."Balance Currency Factor";
              BusUnit."Last Run" := WORKDATE;
              BusUnit.MODIFY;
            END;

            IF AnalysisViewEntriesDeleted THEN
              MESSAGE(Text005);
          END;

  }
  CODE
  {
    VAR
      BusUnit@1026 : Record 220;
      ConsolidGLAcc@1017 : Record 15;
      ConsolidGLEntry@1018 : Record 17;
      ConsolidDimSetEntry@1019 : Record 480;
      ConsolidCurrExchRate@1067 : Record 330;
      TempSubsidGLAcc@1000 : TEMPORARY Record 15;
      TempSubsidGLEntry@1001 : TEMPORARY Record 17;
      TempSubsidDimBuf@1002 : TEMPORARY Record 360;
      TempSubsidCurrExchRate@1003 : TEMPORARY Record 330;
      TempSelectedDim@1048 : TEMPORARY Record 369;
      GenJnlLine@1050 : Record 81;
      TempGenJnlLine@1054 : TEMPORARY Record 81;
      TempDimBufIn@1058 : TEMPORARY Record 360;
      TempDimBufOut@1057 : TEMPORARY Record 360;
      TempGLEntry@1020 : TEMPORARY Record 17;
      DimBufMgt@1059 : Codeunit 411;
      DimMgt@1055 : Codeunit 408;
      Window@1046 : Dialog;
      GLDocNo@1028 : Code[20];
      ProductVersion@1005 : Code[10];
      FormatVersion@1006 : Code[10];
      SubCompanyName@1007 : Text[30];
      CurrencyLCY@1008 : Code[10];
      CurrencyACY@1009 : Code[10];
      CurrencyPCY@1010 : Code[10];
      StoredCheckSum@1011 : Decimal;
      StartingDate@1013 : Date;
      EndingDate@1014 : Date;
      ConsolidSourceCode@1051 : Code[10];
      RoundingResiduals@1066 : ARRAY [500] OF Decimal;
      ExchRateAdjAmounts@1068 : ARRAY [500] OF Decimal;
      CompExchRateAdjAmts@1034 : ARRAY [500] OF Decimal;
      EqExchRateAdjAmts@1035 : ARRAY [500] OF Decimal;
      MinorExchRateAdjAmts@1037 : ARRAY [500] OF Decimal;
      DeletedAmounts@1022 : ARRAY [500] OF Decimal;
      DeletedDates@1023 : ARRAY [500] OF Date;
      DeletedIndex@1024 : Integer;
      MaxDeletedIndex@1025 : Integer;
      AnalysisViewEntriesDeleted@1027 : Boolean;
      Text000@1029 : TextConst 'DAN=Indtast et bilagsnummer.;ENU=Enter a document number.';
      Text001@1030 : TextConst 'DAN=Regnskaberne konsolideres...\\;ENU=Consolidating companies...\\';
      Text002@1031 : TextConst 'DAN=Konc.virksomhedskode #1###################\;ENU=Business Unit Code   #1###################\';
      Text003@1032 : TextConst 'DAN=Hovedaktivitet       #2############################\;ENU=Phase                #2############################\';
      Text004@1033 : TextConst 'DAN=Finanskontonr.       #3##################;ENU=G/L Account No.      #3##################';
      Text005@1071 : TextConst 'DAN=Der blev slettet analysevisningsposter under konsolideringen. En opdatering er n�dvendig.;ENU=Analysis View Entries were deleted during the consolidation. An update is necessary.';
      Text006@1016 : TextConst 'DAN=Der er mere end %1 fejl.;ENU=There are more than %1 errors.';
      Text008@1036 : TextConst 'DAN=Konsolideringen kan indeholde et maksimum p� %1 dage.;ENU=The consolidation can include a maximum of %1 days.';
      Text010@1038 : TextConst 'DAN="Tidligere konsoliderede poster kan ikke slettes, fordi det vil betyde, at finansbalancen ikke stemmer med et bel�b p� %1. ";ENU="Previously consolidated entries cannot be erased because this would cause the general ledger to be out of balance by an amount of %1. "';
      Text011@1040 : TextConst 'DAN=" S�g efter manuelt bogf�rte finansposter p� %2 for poster bogf�rt imellem koncernvirksomheder.";ENU=" Check for manually posted G/L entries on %2 for posting across business units."';
      Text013@1041 : TextConst 'DAN=%1 reguleret fra %2 til %3, d. %4;ENU=%1 adjusted from %2 to %3 on %4';
      Text014@1042 : TextConst 'DAN=Regulering af primosaldo d. %1;ENU=Adjustment of opening entries on %1';
      Text015@1043 : TextConst 'DAN=Valutakursregulering d. %1;ENU=Exchange rate adjustment on %1';
      Text016@1044 : TextConst 'DAN=Til rest pr. %1, d. %2;ENU=Posted %2 to residual account as of %1';
      Text017@1045 : TextConst 'DAN=%1 til kurs %2 d. %3;ENU=%1 at exchange rate %2 on %3';
      Text018@1047 : TextConst 'DAN=Slet tidligere konsolidering;ENU=Clear Previous Consolidation';
      SkipAllDimensions@1049 : Boolean;
      Text019@1052 : TextConst 'DAN=Opdater tidligere periodesaldi;ENU=Update Prior Period Balances';
      ConsolidatingClosingDate@1074 : Boolean;
      ExchRateAdjAmount@1053 : Decimal;
      HistoricalCurrencyFactor@1079 : Decimal;
      NextLineNo@1056 : Integer;
      Text020@1061 : TextConst 'DAN=Konsolider de aktuelle data;ENU=Consolidate Current Data';
      Text021@1062 : TextConst 'DAN=I datterselskabet (%5) er der to finanskonti: %1 og %4. De henviser til samme %2, men med forskellig %3.;ENU="Within the Subsidiary (%5), there are two G/L Accounts: %1 and %4; which refer to the same %2, but with a different %3."';
      Text022@1063 : TextConst 'DAN=%1 %2, der er henvist af %5 %3 %4, findes ikke i den konsoliderede %3-tabel.;ENU=%1 %2, referenced by %5 %3 %4, does not exist in the consolidated %3 table.';
      Text023@1064 : TextConst 'DAN=%7 %1 %2 skal have samme %3 som konsolideret %1 %4. (Henholdsvis %5 og %6);ENU=%7 %1 %2 must have the same %3 as consolidated %1 %4. (%5 and %6, respectively)';
      Text024@1065 : TextConst 'DAN=%1 ved %2 %3;ENU=%1 at %2 %3';
      Text025@1069 : TextConst 'DAN=Beregn afrundingsposter;ENU=Calculate Residual Entries';
      Text026@1070 : TextConst 'DAN=Bogf�r til finanspost;ENU=Post to General Ledger';
      Text027@1039 : TextConst 'DAN="Sammensat ";ENU="Composite "';
      Text028@1072 : TextConst 'DAN="Egenkapital ";ENU="Equity "';
      Text029@1073 : TextConst 'DAN="Minoritet ";ENU="Minority "';
      TestMode@1004 : Boolean;
      CurErrorIdx@1012 : Integer;
      ErrorText@1015 : ARRAY [500] OF Text[250];
      Text030@1076 : TextConst 'DAN=N�r du bruger ultimodatoer, skal start- og slutdatoen v�re den samme.;ENU=When using closing dates, the starting and ending dates must be the same.';
      Text031@1075 : TextConst 'DAN=%1 med %2 p� en ultimodato (%3) blev fundet under konsolidering af ikke-ultimoposter.;ENU=A %1 with %2 on a closing date (%3) was found while consolidating non-closing entries.';
      Text032@1077 : TextConst 'DAN=%1 er senere end %2 i regnskabet %3.;ENU=The %1 is later than the %2 in company %3.';
      Text033@1078 : TextConst 'DAN=%1 m� ikke v�re tom, n�r %2 ikke er tom, i regnskabet %3.;ENU=%1 must not be empty when %2 is not empty, in company %3.';
      Text034@1080 : TextConst 'DAN=Det er ikke muligt at konsolidere postdimensioner for finanspostnr. %1, da der er modstridende dimensionsv�rdier %2 og %3 for konsolideringsdimensionen %4.;ENU=It is not possible to consolidate ledger entry dimensions for G/L Entry No. %1, because there are conflicting dimension values %2 and %3 for consolidation dimension %4.';

    [External]
    PROCEDURE SetDocNo@15(NewDocNo@1000 : Code[20]);
    BEGIN
      GLDocNo := NewDocNo;
      IF GLDocNo = '' THEN
        ERROR(Text000);
    END;

    [External]
    PROCEDURE SetSelectedDim@20(VAR SelectedDim@1000 : Record 369);
    BEGIN
      TempSelectedDim.RESET;
      TempSelectedDim.DELETEALL;
      SkipAllDimensions := SelectedDim.ISEMPTY;
      IF SkipAllDimensions THEN
        EXIT;

      IF SelectedDim.FINDSET THEN
        REPEAT
          TempSelectedDim := SelectedDim;
          TempSelectedDim."User ID" := '';
          TempSelectedDim."Object Type" := 0;
          TempSelectedDim."Object ID" := 0;
          TempSelectedDim.INSERT;
        UNTIL SelectedDim.NEXT = 0;
    END;

    [External]
    PROCEDURE SetGlobals@1(NewProductVersion@1000 : Code[10];NewFormatVersion@1001 : Code[10];NewCompanyName@1002 : Text[30];NewCurrencyLCY@1003 : Code[10];NewCurrencyACY@1004 : Code[10];NewCurrencyPCY@1005 : Code[10];NewCheckSum@1006 : Decimal;NewStartingDate@1007 : Date;NewEndingDate@1008 : Date);
    BEGIN
      ProductVersion := NewProductVersion;
      FormatVersion := NewFormatVersion;
      SubCompanyName := NewCompanyName;
      CurrencyLCY := NewCurrencyLCY;
      CurrencyACY := NewCurrencyACY;
      CurrencyPCY := NewCurrencyPCY;
      StoredCheckSum := NewCheckSum;
      StartingDate := NewStartingDate;
      EndingDate := NewEndingDate;
    END;

    [External]
    PROCEDURE InsertGLAccount@2(NewGLAccount@1000 : Record 15);
    BEGIN
      TempSubsidGLAcc.INIT;
      TempSubsidGLAcc."No." := NewGLAccount."No.";
      TempSubsidGLAcc."Consol. Translation Method" := NewGLAccount."Consol. Translation Method";
      TempSubsidGLAcc."Consol. Debit Acc." := NewGLAccount."Consol. Debit Acc.";
      TempSubsidGLAcc."Consol. Credit Acc." := NewGLAccount."Consol. Credit Acc.";
      TempSubsidGLAcc.INSERT;
    END;

    [External]
    PROCEDURE InsertGLEntry@3(NewGLEntry@1000 : Record 17) : Integer;
    VAR
      NextEntryNo@1001 : Integer;
    BEGIN
      IF TempSubsidGLEntry.FINDLAST THEN
        NextEntryNo := TempSubsidGLEntry."Entry No." + 1
      ELSE
        NextEntryNo := 1;
      TempSubsidGLEntry.INIT;
      TempSubsidGLEntry."Entry No." := NextEntryNo;
      TempSubsidGLEntry."G/L Account No." := NewGLEntry."G/L Account No.";
      TempSubsidGLEntry."Posting Date" := NewGLEntry."Posting Date";
      TempSubsidGLEntry."Debit Amount" := NewGLEntry."Debit Amount";
      TempSubsidGLEntry."Credit Amount" := NewGLEntry."Credit Amount";
      TempSubsidGLEntry."Add.-Currency Debit Amount" := NewGLEntry."Add.-Currency Debit Amount";
      TempSubsidGLEntry."Add.-Currency Credit Amount" := NewGLEntry."Add.-Currency Credit Amount";
      TempSubsidGLEntry.INSERT;
      EXIT(NextEntryNo);
    END;

    [External]
    PROCEDURE InsertEntryDim@4(NewDimBuf@1000 : Record 360;GLEntryNo@1001 : Integer);
    BEGIN
      IF TempSubsidDimBuf.GET(NewDimBuf."Table ID",GLEntryNo,NewDimBuf."Dimension Code") THEN BEGIN
        IF NewDimBuf."Dimension Value Code" <> TempSubsidDimBuf."Dimension Value Code" THEN
          ERROR(
            Text034,GLEntryNo,NewDimBuf."Dimension Value Code",TempSubsidDimBuf."Dimension Value Code",
            NewDimBuf."Dimension Code");
      END ELSE BEGIN
        TempSubsidDimBuf.INIT;
        TempSubsidDimBuf := NewDimBuf;
        TempSubsidDimBuf."Entry No." := GLEntryNo;
        TempSubsidDimBuf.INSERT;
      END;
    END;

    [External]
    PROCEDURE InsertExchRate@5(NewCurrExchRate@1000 : Record 330);
    BEGIN
      TempSubsidCurrExchRate.INIT;
      TempSubsidCurrExchRate."Currency Code" := NewCurrExchRate."Currency Code";
      TempSubsidCurrExchRate."Starting Date" := NewCurrExchRate."Starting Date";
      TempSubsidCurrExchRate."Relational Currency Code" := NewCurrExchRate."Relational Currency Code";
      TempSubsidCurrExchRate."Exchange Rate Amount" := NewCurrExchRate."Exchange Rate Amount";
      TempSubsidCurrExchRate."Relational Exch. Rate Amount" := NewCurrExchRate."Relational Exch. Rate Amount";
      TempSubsidCurrExchRate.INSERT;
    END;

    [External]
    PROCEDURE UpdateGLEntryDimSetID@42();
    BEGIN
      IF SkipAllDimensions THEN
        EXIT;

      TempSubsidGLEntry.RESET;
      TempSubsidDimBuf.RESET;
      TempSubsidDimBuf.SETRANGE("Table ID",DATABASE::"G/L Entry");
      WITH TempSubsidGLEntry DO BEGIN
        RESET;
        IF FINDSET(TRUE,FALSE) THEN
          REPEAT
            TempSubsidDimBuf.SETRANGE("Entry No.","Entry No.");
            IF NOT TempSubsidDimBuf.ISEMPTY THEN BEGIN
              "Dimension Set ID" := DimMgt.CreateDimSetIDFromDimBuf(TempSubsidDimBuf);
              MODIFY;
            END;
          UNTIL NEXT = 0;
      END;
    END;

    [External]
    PROCEDURE CalcCheckSum@6() CheckSum : Decimal;
    BEGIN
      CheckSum :=
        DateToDecimal(StartingDate) + DateToDecimal(EndingDate) +
        TextToDecimal(FormatVersion) + TextToDecimal(ProductVersion);
      TempSubsidGLAcc.RESET;
      IF TempSubsidGLAcc.FINDSET THEN
        REPEAT
          CheckSum :=
            CheckSum +
            TextToDecimal(COPYSTR(TempSubsidGLAcc."No.",1,10)) + TextToDecimal(COPYSTR(TempSubsidGLAcc."No.",11,10)) +
            TextToDecimal(COPYSTR(TempSubsidGLAcc."Consol. Debit Acc.",1,10)) +
            TextToDecimal(COPYSTR(TempSubsidGLAcc."Consol. Debit Acc.",11,10)) +
            TextToDecimal(COPYSTR(TempSubsidGLAcc."Consol. Credit Acc.",1,10)) +
            TextToDecimal(COPYSTR(TempSubsidGLAcc."Consol. Credit Acc.",11,10)) ;
        UNTIL TempSubsidGLAcc.NEXT = 0;
      TempSubsidGLEntry.RESET;
      IF TempSubsidGLEntry.FINDSET THEN
        REPEAT
          CheckSum := CheckSum +
            TempSubsidGLEntry."Debit Amount" + TempSubsidGLEntry."Credit Amount" +
            TempSubsidGLEntry."Add.-Currency Debit Amount" + TempSubsidGLEntry."Add.-Currency Credit Amount" +
            DateToDecimal(TempSubsidGLEntry."Posting Date");
        UNTIL TempSubsidGLEntry.NEXT = 0;
    END;

    [Internal]
    PROCEDURE ImportFromXML@7(FileName@1000 : Text);
    VAR
      Consolidation@1003 : XMLport 1;
      InputFile@1001 : File;
      InputStream@1002 : InStream;
    BEGIN
      InputFile.TEXTMODE(TRUE);
      InputFile.WRITEMODE(FALSE);
      InputFile.OPEN(FileName);

      InputFile.CREATEINSTREAM(InputStream);

      Consolidation.SETSOURCE(InputStream);
      Consolidation.IMPORT;
      InputFile.CLOSE;

      Consolidation.GetGLAccount(TempSubsidGLAcc);
      Consolidation.GetGLEntry(TempSubsidGLEntry);
      Consolidation.GetEntryDim(TempSubsidDimBuf);
      Consolidation.GetExchRate(TempSubsidCurrExchRate);
      Consolidation.GetGlobals(
        ProductVersion,FormatVersion,SubCompanyName,CurrencyLCY,CurrencyACY,CurrencyPCY,
        StoredCheckSum,StartingDate,EndingDate);

      SelectAllImportedDimensions;
    END;

    [Internal]
    PROCEDURE ExportToXML@8(FileName@1000 : Text);
    VAR
      Consolidation@1003 : XMLport 1;
      OutputFile@1001 : File;
      OutputStream@1002 : OutStream;
    BEGIN
      OutputFile.TEXTMODE(TRUE);
      OutputFile.WRITEMODE(TRUE);
      OutputFile.CREATE(FileName);

      OutputFile.CREATEOUTSTREAM(OutputStream);

      Consolidation.SetGlobals(SubCompanyName,CurrencyLCY,CurrencyACY,CurrencyPCY,StoredCheckSum,StartingDate,EndingDate);
      Consolidation.SetGLAccount(TempSubsidGLAcc);
      Consolidation.SetGLEntry(TempSubsidGLEntry);
      Consolidation.SetEntryDim(TempSubsidDimBuf);
      Consolidation.SetExchRate(TempSubsidCurrExchRate);

      Consolidation.SETDESTINATION(OutputStream);
      Consolidation.EXPORT;
      OutputFile.CLOSE;
    END;

    [External]
    PROCEDURE GetGlobals@9(VAR ImpProductVersion@1008 : Code[10];VAR ImpFormatVersion@1007 : Code[10];VAR ImpCompanyName@1006 : Text[30];VAR ImpCurrencyLCY@1005 : Code[10];VAR ImpCurrencyACY@1004 : Code[10];VAR ImpCurrencyPCY@1003 : Code[10];VAR ImpCheckSum@1002 : Decimal;VAR ImpStartingDate@1001 : Date;VAR ImpEndingDate@1000 : Date);
    BEGIN
      ImpProductVersion := ProductVersion;
      ImpFormatVersion := FormatVersion;
      ImpCompanyName := SubCompanyName;
      ImpCurrencyLCY := CurrencyLCY;
      ImpCurrencyACY := CurrencyACY;
      ImpCurrencyPCY := CurrencyPCY;
      ImpCheckSum := StoredCheckSum;
      ImpStartingDate := StartingDate;
      ImpEndingDate := EndingDate;
    END;

    [External]
    PROCEDURE SetTestMode@27(NewTestMode@1000 : Boolean);
    BEGIN
      TestMode := NewTestMode;
      CurErrorIdx := 0;
    END;

    [External]
    PROCEDURE GetAccumulatedErrors@28(VAR NumErrors@1000 : Integer;VAR Errors@1001 : ARRAY [100] OF Text[250]);
    VAR
      Idx@1002 : Integer;
    BEGIN
      NumErrors := 0;
      CLEAR(Errors);
      FOR Idx := 1 TO CurErrorIdx DO BEGIN
        NumErrors := NumErrors + 1;
        Errors[NumErrors] := ErrorText[Idx];
        IF (Idx = ARRAYLEN(Errors)) AND (CurErrorIdx > Idx) THEN BEGIN
          COPYARRAY(ErrorText,ErrorText,ARRAYLEN(Errors) + 1);
          CurErrorIdx := CurErrorIdx - ARRAYLEN(Errors);
          EXIT;
        END;
      END;
      CurErrorIdx := 0;
      CLEAR(ErrorText);
    END;

    [External]
    PROCEDURE SelectAllImportedDimensions@41();
    BEGIN
      // assume all dimensions that were imported were also selected.
      TempSelectedDim.RESET;
      TempSelectedDim.DELETEALL;
      IF TempSubsidDimBuf.FINDSET THEN
        REPEAT
          TempSelectedDim.INIT;
          TempSelectedDim."User ID" := '';
          TempSelectedDim."Object Type" := 0;
          TempSelectedDim."Object ID" := 0;
          TempSelectedDim."Dimension Code" := TempSubsidDimBuf."Dimension Code";
          IF TempSelectedDim.INSERT THEN ;
        UNTIL TempSubsidDimBuf.NEXT = 0;
      SkipAllDimensions := TempSelectedDim.ISEMPTY;
    END;

    LOCAL PROCEDURE ReadSourceCodeSetup@10();
    VAR
      SourceCodeSetup@1001 : Record 242;
    BEGIN
      SourceCodeSetup.GET;
      ConsolidSourceCode := SourceCodeSetup.Consolidation;
    END;

    LOCAL PROCEDURE ClearInternals@23();
    BEGIN
      NextLineNo := 0;
      AnalysisViewEntriesDeleted := FALSE;
      TempGenJnlLine.RESET;
      TempGenJnlLine.DELETEALL;
      TempDimBufOut.RESET;
      TempDimBufOut.DELETEALL;
      TempDimBufIn.RESET;
      TempDimBufIn.DELETEALL;
      CLEAR(RoundingResiduals);
      CLEAR(ExchRateAdjAmounts);
      CLEAR(CompExchRateAdjAmts);
      CLEAR(EqExchRateAdjAmts);
      CLEAR(MinorExchRateAdjAmts);
    END;

    LOCAL PROCEDURE UpdatePhase@16(PhaseText@1000 : Text[50]);
    BEGIN
      Window.UPDATE(2,PhaseText);
      Window.UPDATE(3,'');
    END;

    LOCAL PROCEDURE ClearPreviousConsolidation@14();
    VAR
      TempGLAccount@1000 : TEMPORARY Record 15;
      AnalysisView@1001 : Record 363;
      TempAnalysisView@1004 : TEMPORARY Record 363;
      AnalysisViewEntry@1002 : Record 365;
      AnalysisViewFound@1003 : Boolean;
    BEGIN
      ClearAmountArray;
      WITH ConsolidGLEntry DO BEGIN
        IF NOT
           SETCURRENTKEY("G/L Account No.","Business Unit Code","Global Dimension 1 Code","Global Dimension 2 Code","Posting Date")
        THEN
          SETCURRENTKEY("G/L Account No.","Business Unit Code","Posting Date");
        SETRANGE("Business Unit Code",BusUnit.Code);
        SETRANGE("Posting Date",StartingDate,EndingDate);
        IF FINDSET(TRUE,FALSE) THEN
          REPEAT
            UpdateAmountArray("Posting Date",Amount);
            Description := '';
            Amount := 0;
            "Debit Amount" := 0;
            "Credit Amount" := 0;
            "Additional-Currency Amount" := 0;
            "Add.-Currency Debit Amount" := 0;
            "Add.-Currency Credit Amount" := 0;
            MODIFY;
            IF "G/L Account No." <> TempGLAccount."No." THEN BEGIN
              Window.UPDATE(3,"G/L Account No.");
              TempGLAccount."No." := "G/L Account No.";
              TempGLAccount.INSERT;
            END;
          UNTIL NEXT = 0;
      END;
      CheckAmountArray;

      IF AnalysisView.FINDSET THEN
        REPEAT
          AnalysisViewFound := FALSE;
          IF TempGLAccount.FINDSET THEN
            REPEAT
              AnalysisViewEntry.SETRANGE("Analysis View Code",AnalysisView.Code);
              AnalysisViewEntry.SETRANGE("Account No.",TempGLAccount."No.");
              AnalysisViewEntry.SETRANGE("Account Source",AnalysisViewEntry."Account Source"::"G/L Account");
              IF AnalysisViewEntry.FINDFIRST THEN BEGIN
                TempAnalysisView.Code := AnalysisViewEntry."Analysis View Code";
                TempAnalysisView."Account Source" := AnalysisViewEntry."Account Source";
                TempAnalysisView.INSERT;
                AnalysisViewFound := TRUE;
              END;
            UNTIL (TempGLAccount.NEXT = 0) OR AnalysisViewFound;
        UNTIL AnalysisView.NEXT = 0;

      AnalysisViewEntry.RESET;
      IF TempAnalysisView.FINDSET THEN
        REPEAT
          AnalysisView.GET(TempAnalysisView.Code);
          IF AnalysisView.Blocked THEN BEGIN
            AnalysisView."Refresh When Unblocked" := TRUE;
            AnalysisView.MODIFY;
          END ELSE BEGIN
            AnalysisViewEntry.SETRANGE("Analysis View Code",TempAnalysisView.Code);
            AnalysisViewEntry.DELETEALL;
            AnalysisView."Last Entry No." := 0;
            AnalysisView."Last Date Updated" := 0D;
            AnalysisView.MODIFY;
            AnalysisViewEntriesDeleted := TRUE;
          END;
        UNTIL TempAnalysisView.NEXT = 0;
    END;

    LOCAL PROCEDURE ClearAmountArray@11();
    BEGIN
      CLEAR(DeletedAmounts);
      CLEAR(DeletedDates);
      DeletedIndex := 0;
      MaxDeletedIndex := 0;
    END;

    LOCAL PROCEDURE UpdateAmountArray@12(PostingDate@1000 : Date;Amount@1001 : Decimal);
    VAR
      Top@1002 : Integer;
      Bottom@1003 : Integer;
      Middle@1004 : Integer;
      Found@1005 : Boolean;
      NotFound@1006 : Boolean;
      idx@1007 : Integer;
    BEGIN
      IF DeletedIndex = 0 THEN BEGIN
        DeletedIndex := 1;
        MaxDeletedIndex := 1;
        DeletedDates[DeletedIndex] := PostingDate;
        DeletedAmounts[DeletedIndex] := Amount;
      END ELSE
        IF PostingDate = DeletedDates[DeletedIndex] THEN
          DeletedAmounts[DeletedIndex] := DeletedAmounts[DeletedIndex] + Amount
        ELSE BEGIN
          Top := 0;
          Bottom := MaxDeletedIndex + 1;
          Found := FALSE;
          NotFound := FALSE;
          REPEAT
            Middle := (Top + Bottom) DIV 2;
            IF Bottom - Top <= 1 THEN
              NotFound := TRUE
            ELSE
              IF DeletedDates[Middle] > PostingDate THEN
                Bottom := Middle
              ELSE
                IF DeletedDates[Middle] < PostingDate THEN
                  Top := Middle
                ELSE
                  Found := TRUE;
          UNTIL Found OR NotFound;
          IF Found THEN BEGIN
            DeletedIndex := Middle;
            DeletedAmounts[DeletedIndex] := DeletedAmounts[DeletedIndex] + Amount;
          END ELSE BEGIN
            IF MaxDeletedIndex >= ARRAYLEN(DeletedDates) THEN
              ReportError(STRSUBSTNO(Text008,ARRAYLEN(DeletedDates)))
            ELSE
              MaxDeletedIndex := MaxDeletedIndex + 1;
            FOR idx := MaxDeletedIndex DOWNTO Bottom + 1 DO BEGIN
              DeletedAmounts[idx] := DeletedAmounts[idx - 1];
              DeletedDates[idx] := DeletedDates[idx - 1];
            END;
            DeletedIndex := Bottom;
            DeletedDates[DeletedIndex] := PostingDate;
            DeletedAmounts[DeletedIndex] := Amount;
          END;
        END;
    END;

    LOCAL PROCEDURE CheckAmountArray@13();
    VAR
      idx@1000 : Integer;
    BEGIN
      FOR idx := 1 TO MaxDeletedIndex DO
        IF DeletedAmounts[idx] <> 0 THEN
          ReportError(STRSUBSTNO(Text010 + Text011,DeletedAmounts[idx],DeletedDates[idx]));
    END;

    LOCAL PROCEDURE TestGLAccounts@18();
    VAR
      AccountToTest@1001 : Record 15;
    BEGIN
      // First test within the Subsidiary Chart of Accounts
      AccountToTest := TempSubsidGLAcc;
      IF AccountToTest.TranslationMethodConflict(TempSubsidGLAcc) THEN BEGIN
        IF TempSubsidGLAcc.GETFILTER("Consol. Debit Acc.") <> '' THEN
          ReportError(
            STRSUBSTNO(
              Text021,
              TempSubsidGLAcc."No.",
              TempSubsidGLAcc.FIELDCAPTION("Consol. Debit Acc."),
              TempSubsidGLAcc.FIELDCAPTION("Consol. Translation Method"),
              AccountToTest."No.",BusUnit.TABLECAPTION))
        ELSE
          ReportError(
            STRSUBSTNO(Text021,
              TempSubsidGLAcc."No.",
              TempSubsidGLAcc.FIELDCAPTION("Consol. Credit Acc."),
              TempSubsidGLAcc.FIELDCAPTION("Consol. Translation Method"),
              AccountToTest."No.",BusUnit.TABLECAPTION));
      END ELSE BEGIN
        TempSubsidGLAcc.RESET;
        TempSubsidGLAcc := AccountToTest;
        TempSubsidGLAcc.FIND('=');
      END;
      // Then, test for conflicts between subsidiary and parent (consolidated)
      IF TempSubsidGLAcc."Consol. Debit Acc." <> '' THEN BEGIN
        IF NOT ConsolidGLAcc.GET(TempSubsidGLAcc."Consol. Debit Acc.") THEN
          ReportError(
            STRSUBSTNO(Text022,
              TempSubsidGLAcc.FIELDCAPTION("Consol. Debit Acc."),TempSubsidGLAcc."Consol. Debit Acc.",
              TempSubsidGLAcc.TABLECAPTION,TempSubsidGLAcc."No.",BusUnit.TABLECAPTION));
        IF (TempSubsidGLAcc."Consol. Translation Method" <> ConsolidGLAcc."Consol. Translation Method") AND
           (BusUnit."File Format" <> BusUnit."File Format"::"Version 3.70 or Earlier (.txt)")
        THEN
          ReportError(
            STRSUBSTNO(Text023,
              TempSubsidGLAcc.TABLECAPTION,TempSubsidGLAcc."No.",
              TempSubsidGLAcc.FIELDCAPTION("Consol. Translation Method"),ConsolidGLAcc."No.",
              TempSubsidGLAcc."Consol. Translation Method",ConsolidGLAcc."Consol. Translation Method",
              BusUnit.TABLECAPTION));
      END;
      IF TempSubsidGLAcc."Consol. Debit Acc." = TempSubsidGLAcc."Consol. Credit Acc." THEN
        EXIT;
      IF TempSubsidGLAcc."Consol. Credit Acc." <> '' THEN BEGIN
        IF NOT ConsolidGLAcc.GET(TempSubsidGLAcc."Consol. Credit Acc.") THEN
          ReportError(
            STRSUBSTNO(Text022,
              TempSubsidGLAcc.FIELDCAPTION("Consol. Credit Acc."),TempSubsidGLAcc."Consol. Credit Acc.",
              TempSubsidGLAcc.TABLECAPTION,TempSubsidGLAcc."No.",BusUnit.TABLECAPTION));
        IF (TempSubsidGLAcc."Consol. Translation Method" <> ConsolidGLAcc."Consol. Translation Method") AND
           (BusUnit."File Format" <> BusUnit."File Format"::"Version 3.70 or Earlier (.txt)")
        THEN
          ReportError(
            STRSUBSTNO(Text023,
              TempSubsidGLAcc.TABLECAPTION,TempSubsidGLAcc."No.",
              TempSubsidGLAcc.FIELDCAPTION("Consol. Translation Method"),ConsolidGLAcc."No.",
              TempSubsidGLAcc."Consol. Translation Method",ConsolidGLAcc."Consol. Translation Method",
              BusUnit.TABLECAPTION));
      END;
    END;

    LOCAL PROCEDURE UpdatePriorPeriodBalances@21();
    VAR
      idx@1002 : Integer;
      AdjustmentAmount@1000 : Decimal;
    BEGIN
      CLEAR(GenJnlLine);
      GenJnlLine."Business Unit Code" := BusUnit.Code;
      GenJnlLine."Document No." := GLDocNo;
      GenJnlLine."Source Code" := ConsolidSourceCode;

      BusUnit.TESTFIELD("Balance Currency Factor");
      BusUnit.TESTFIELD("Last Balance Currency Factor");
      ExchRateAdjAmount := 0;
      idx := NORMALDATE(EndingDate) - NORMALDATE(StartingDate) + 1;

      WITH ConsolidGLAcc DO BEGIN
        RESET;
        SETRANGE("Account Type","Account Type"::Posting);
        SETRANGE("Business Unit Filter",BusUnit.Code);
        SETRANGE("Date Filter",0D,EndingDate);
        SETRANGE("Income/Balance","Income/Balance"::"Balance Sheet");
        SETFILTER(
          "No.",'<>%1&<>%2&<>%3&<>%4&<>%5&<>%6&<>%7&<>%8&<>%9',
          BusUnit."Exch. Rate Losses Acc.",BusUnit."Exch. Rate Gains Acc.",
          BusUnit."Comp. Exch. Rate Gains Acc.",BusUnit."Comp. Exch. Rate Losses Acc.",
          BusUnit."Equity Exch. Rate Gains Acc.",BusUnit."Equity Exch. Rate Losses Acc.",
          BusUnit."Minority Exch. Rate Gains Acc.",BusUnit."Minority Exch. Rate Losses Acc",
          BusUnit."Residual Account");
        IF FINDSET THEN
          REPEAT
            Window.UPDATE(3,"No.");
            CASE "Consol. Translation Method" OF
              "Consol. Translation Method"::"Average Rate (Manual)",
              "Consol. Translation Method"::"Closing Rate":
                // Post adjustment to existing balance to convert that balance to new Closing Rate
                IF SkipAllDimensions THEN BEGIN
                  CALCFIELDS("Debit Amount","Credit Amount");
                  IF "Debit Amount" <> 0 THEN
                    PostBalanceAdjustment("No.","Debit Amount");
                  IF "Credit Amount" <> 0 THEN
                    PostBalanceAdjustment("No.",-"Credit Amount");
                END ELSE BEGIN
                  TempGLEntry.RESET;
                  TempGLEntry.DELETEALL;
                  DimBufMgt.DeleteAllDimensions;
                  ConsolidGLEntry.RESET;
                  ConsolidGLEntry.SETCURRENTKEY("G/L Account No.","Posting Date");
                  ConsolidGLEntry.SETRANGE("G/L Account No.","No.");
                  ConsolidGLEntry.SETRANGE("Posting Date",0D,EndingDate);
                  ConsolidGLEntry.SETRANGE("Business Unit Code",BusUnit.Code);
                  IF ConsolidGLEntry.FINDSET THEN
                    REPEAT
                      TempDimBufIn.RESET;
                      TempDimBufIn.DELETEALL;
                      ConsolidDimSetEntry.SETRANGE("Dimension Set ID",ConsolidGLEntry."Dimension Set ID");
                      IF ConsolidDimSetEntry.FINDSET THEN
                        REPEAT
                          IF TempSelectedDim.GET('',0,0,'',ConsolidDimSetEntry."Dimension Code") THEN BEGIN
                            TempDimBufIn.INIT;
                            TempDimBufIn."Table ID" := DATABASE::"G/L Entry";
                            TempDimBufIn."Entry No." := ConsolidGLEntry."Entry No.";
                            TempDimBufIn."Dimension Code" := ConsolidDimSetEntry."Dimension Code";
                            TempDimBufIn."Dimension Value Code" := ConsolidDimSetEntry."Dimension Value Code";
                            TempDimBufIn.INSERT;
                          END;
                        UNTIL ConsolidDimSetEntry.NEXT = 0;
                      UpdateTempGLEntry(ConsolidGLEntry);
                    UNTIL ConsolidGLEntry.NEXT = 0;
                  TempDimBufOut.RESET;
                  TempDimBufOut.DELETEALL;
                  IF TempGLEntry.FINDSET THEN
                    REPEAT
                      DimBufMgt.GetDimensions(TempGLEntry."Entry No.",TempDimBufOut);
                      TempDimBufOut.SETRANGE("Entry No.",TempGLEntry."Entry No.");
                      IF TempGLEntry."Debit Amount" <> 0 THEN
                        PostBalanceAdjustment("No.",TempGLEntry."Debit Amount");
                      IF TempGLEntry."Credit Amount" <> 0 THEN
                        PostBalanceAdjustment("No.",-TempGLEntry."Credit Amount");
                    UNTIL TempGLEntry.NEXT = 0;
                END;
              "Consol. Translation Method"::"Historical Rate":
                // accumulate adjustment for historical accounts
                BEGIN
                  CALCFIELDS("Balance at Date");
                  AdjustmentAmount := 0;
                  ExchRateAdjAmounts[idx] := ExchRateAdjAmounts[idx] + AdjustmentAmount;
                END;
              "Consol. Translation Method"::"Composite Rate":
                // accumulate adjustment for composite accounts
                BEGIN
                  CALCFIELDS("Balance at Date");
                  AdjustmentAmount := 0;
                  CompExchRateAdjAmts[idx] := CompExchRateAdjAmts[idx] + AdjustmentAmount;
                END;
              "Consol. Translation Method"::"Equity Rate":
                // accumulate adjustment for equity accounts
                BEGIN
                  CALCFIELDS("Balance at Date");
                  AdjustmentAmount := 0;
                  EqExchRateAdjAmts[idx] := EqExchRateAdjAmts[idx] + AdjustmentAmount;
                END;
            END;
          UNTIL NEXT = 0;
      END;

      TempDimBufOut.RESET;
      TempDimBufOut.DELETEALL;

      IF ExchRateAdjAmount <> 0 THEN BEGIN
        CLEAR(GenJnlLine);
        GenJnlLine."Business Unit Code" := BusUnit.Code;
        GenJnlLine."Document No." := GLDocNo;
        GenJnlLine."Source Code" := ConsolidSourceCode;
        GenJnlLine.Amount := -ExchRateAdjAmount;
        IF GenJnlLine.Amount < 0 THEN BEGIN
          BusUnit.TESTFIELD("Exch. Rate Gains Acc.");
          GenJnlLine."Account No." := BusUnit."Exch. Rate Gains Acc.";
        END ELSE BEGIN
          BusUnit.TESTFIELD("Exch. Rate Losses Acc.");
          GenJnlLine."Account No." := BusUnit."Exch. Rate Losses Acc.";
        END;
        Window.UPDATE(3,GenJnlLine."Account No.");
        GenJnlLine."Posting Date" := EndingDate;
        GenJnlLine.Description := STRSUBSTNO(Text014,WORKDATE);
        GenJnlPostLineTmp(GenJnlLine);
      END;
    END;

    LOCAL PROCEDURE PostBalanceAdjustment@17(GLAccNo@1000 : Code[20];AmountToPost@1001 : Decimal);
    VAR
      TempDimSetEntry2@1002 : TEMPORARY Record 480;
      DimValue@1003 : Record 349;
    BEGIN
      GenJnlLine.Amount :=
        ROUND(
          (AmountToPost * BusUnit."Last Balance Currency Factor" / BusUnit."Balance Currency Factor") - AmountToPost);
      IF GenJnlLine.Amount <> 0 THEN BEGIN
        GenJnlLine."Account No." := GLAccNo;
        GenJnlLine."Posting Date" := EndingDate;
        GenJnlLine.Description :=
          COPYSTR(
            STRSUBSTNO(
              Text013,
              AmountToPost,
              ROUND(BusUnit."Last Balance Currency Factor",0.00001),
              ROUND(BusUnit."Balance Currency Factor",0.00001),
              WORKDATE),
            1,MAXSTRLEN(GenJnlLine.Description));
        IF TempDimBufOut.FINDSET THEN BEGIN
          REPEAT
            TempDimSetEntry2.INIT;
            TempDimSetEntry2."Dimension Code" := TempDimBufOut."Dimension Code";
            TempDimSetEntry2."Dimension Value Code" := TempDimBufOut."Dimension Value Code";
            DimValue.GET(TempDimSetEntry2."Dimension Code",TempDimSetEntry2."Dimension Value Code");
            TempDimSetEntry2."Dimension Value ID" := DimValue."Dimension Value ID";
            TempDimSetEntry2.INSERT;
          UNTIL TempDimBufOut.NEXT = 0;
          GenJnlLine."Dimension Set ID" := DimMgt.GetDimensionSetID(TempDimSetEntry2);
        END ELSE BEGIN
          GenJnlLine."Shortcut Dimension 1 Code" := '';
          GenJnlLine."Shortcut Dimension 2 Code" := '';
          GenJnlLine."Dimension Set ID" := 0;
        END;
        GenJnlPostLineTmp(GenJnlLine);
        ExchRateAdjAmount := ExchRateAdjAmount + GenJnlLine.Amount;
      END;
    END;

    LOCAL PROCEDURE UpdateTempGLEntry@30(VAR GLEntry@1000 : Record 17);
    VAR
      DimEntryNo@1001 : Integer;
      Found@1002 : Boolean;
    BEGIN
      DimEntryNo := DimBufMgt.FindDimensions(TempDimBufIn);
      Found := TempDimBufIn.FINDFIRST;
      IF Found AND (DimEntryNo = 0) THEN BEGIN
        TempGLEntry := GLEntry;
        TempGLEntry."Entry No." := DimBufMgt.InsertDimensions(TempDimBufIn);
        TempGLEntry.INSERT;
      END ELSE BEGIN
        IF TempGLEntry.GET(DimEntryNo) THEN BEGIN
          TempGLEntry.Amount := TempGLEntry.Amount + GLEntry.Amount;
          TempGLEntry."Debit Amount" := TempGLEntry."Debit Amount" + GLEntry."Debit Amount";
          TempGLEntry."Credit Amount" := TempGLEntry."Credit Amount" + GLEntry."Credit Amount";
          TempGLEntry."Additional-Currency Amount" := TempGLEntry."Additional-Currency Amount" + GLEntry."Additional-Currency Amount";
          TempGLEntry."Add.-Currency Debit Amount" := TempGLEntry."Add.-Currency Debit Amount" + GLEntry."Add.-Currency Debit Amount";
          TempGLEntry."Add.-Currency Credit Amount" :=
            TempGLEntry."Add.-Currency Credit Amount" + GLEntry."Add.-Currency Credit Amount";
          TempGLEntry.MODIFY;
        END ELSE BEGIN
          TempGLEntry := GLEntry;
          TempGLEntry."Entry No." := DimEntryNo;
          TempGLEntry.INSERT;
        END;
      END;
    END;

    LOCAL PROCEDURE CreateAndPostGenJnlLine@24(GenJnlLine@1000 : Record 81;VAR GLEntry@1001 : Record 17;VAR DimBuf@1002 : Record 360);
    VAR
      TempDimSetEntry2@1007 : TEMPORARY Record 480;
      DimValue@1012 : Record 349;
      ConsolidAmount@1003 : Decimal;
      AmountToPost@1005 : Decimal;
      AdjustAmount@1009 : Decimal;
      ClosingAmount@1010 : Decimal;
      TranslationNeeded@1006 : Boolean;
      idx@1008 : Integer;
      OriginalTranslationMethod@1011 : Integer;
    BEGIN
      WITH GenJnlLine DO BEGIN
        IF BusUnit."Data Source" = BusUnit."Data Source"::"Local Curr. (LCY)" THEN
          AmountToPost := GLEntry."Debit Amount" - GLEntry."Credit Amount"
        ELSE
          AmountToPost := GLEntry."Add.-Currency Debit Amount" - GLEntry."Add.-Currency Credit Amount";

        IF AmountToPost > 0 THEN
          "Account No." := TempSubsidGLAcc."Consol. Debit Acc."
        ELSE
          "Account No." := TempSubsidGLAcc."Consol. Credit Acc.";

        IF "Account No." = '' THEN
          "Account No." := TempSubsidGLAcc."No.";
        IF AmountToPost = 0 THEN
          EXIT;
        ConsolidGLAcc.GET("Account No.");

        OriginalTranslationMethod := TempSubsidGLAcc."Consol. Translation Method";
        IF TempSubsidGLAcc."Consol. Translation Method" = TempSubsidGLAcc."Consol. Translation Method"::"Average Rate (Manual)" THEN
          IF ConsolidGLAcc."Income/Balance" = ConsolidGLAcc."Income/Balance"::"Balance Sheet" THEN
            TempSubsidGLAcc."Consol. Translation Method" := TempSubsidGLAcc."Consol. Translation Method"::"Closing Rate";

        ConsolidAmount := AmountToPost * BusUnit."Consolidation %" / 100;

        TranslationNeeded := (BusUnit."Currency Code" <> '');
        IF TranslationNeeded THEN
          IF BusUnit."Data Source" = BusUnit."Data Source"::"Add. Rep. Curr. (ACY)" THEN
            TranslationNeeded := (BusUnit."Currency Code" <> CurrencyACY);

        IF TranslationNeeded THEN BEGIN
          ClosingAmount :=
            ROUND(
              ConsolidCurrExchRate.ExchangeAmtFCYToLCY(
                EndingDate,BusUnit."Currency Code",
                ConsolidAmount,BusUnit."Balance Currency Factor"));
          CASE TempSubsidGLAcc."Consol. Translation Method" OF
            TempSubsidGLAcc."Consol. Translation Method"::"Closing Rate":
              BEGIN
                Amount := ClosingAmount;
                Description :=
                  COPYSTR(
                    STRSUBSTNO(
                      Text017,
                      ConsolidAmount,ROUND(BusUnit."Balance Currency Factor",0.00001),EndingDate),
                    1,MAXSTRLEN(Description));
              END;
            TempSubsidGLAcc."Consol. Translation Method"::"Composite Rate",
            TempSubsidGLAcc."Consol. Translation Method"::"Equity Rate",
            TempSubsidGLAcc."Consol. Translation Method"::"Average Rate (Manual)":
              BEGIN
                Amount :=
                  ROUND(
                    ConsolidCurrExchRate.ExchangeAmtFCYToLCY(
                      EndingDate,BusUnit."Currency Code",
                      ConsolidAmount,BusUnit."Income Currency Factor"));
                Description :=
                  COPYSTR(
                    STRSUBSTNO(
                      Text017,
                      ConsolidAmount,ROUND(BusUnit."Income Currency Factor",0.00001),EndingDate),
                    1,MAXSTRLEN(Description));
              END;
            TempSubsidGLAcc."Consol. Translation Method"::"Historical Rate":
              BEGIN
                Amount := TranslateUsingHistoricalRate(ConsolidAmount,GLEntry."Posting Date");
                Description :=
                  COPYSTR(
                    STRSUBSTNO(
                      Text017,
                      ConsolidAmount,ROUND(HistoricalCurrencyFactor,0.00001),GLEntry."Posting Date"),
                    1,MAXSTRLEN(Description));
              END;
          END;
        END ELSE BEGIN
          Amount := ROUND(ConsolidAmount);
          ClosingAmount := Amount;
          Description :=
            STRSUBSTNO(Text024,AmountToPost,BusUnit."Consolidation %",BusUnit.FIELDCAPTION("Consolidation %"));
        END;

        IF TempSubsidGLAcc."Consol. Translation Method" = TempSubsidGLAcc."Consol. Translation Method"::"Historical Rate" THEN
          "Posting Date" := GLEntry."Posting Date"
        ELSE
          "Posting Date" := EndingDate;
        idx := NORMALDATE("Posting Date") - NORMALDATE(StartingDate) + 1;

        IF DimBuf.FINDSET THEN BEGIN
          REPEAT
            TempDimSetEntry2.INIT;
            TempDimSetEntry2."Dimension Code" := DimBuf."Dimension Code";
            TempDimSetEntry2."Dimension Value Code" := DimBuf."Dimension Value Code";
            DimValue.GET(TempDimSetEntry2."Dimension Code",TempDimSetEntry2."Dimension Value Code");
            TempDimSetEntry2."Dimension Value ID" := DimValue."Dimension Value ID";
            TempDimSetEntry2.INSERT;
          UNTIL DimBuf.NEXT = 0;
          "Dimension Set ID" := DimMgt.GetDimensionSetID(TempDimSetEntry2);
          DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID",
            "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
        END;

        IF Amount <> 0 THEN
          GenJnlPostLineTmp(GenJnlLine);
        TempDimSetEntry2.RESET;
        TempDimSetEntry2.DELETEALL;

        RoundingResiduals[idx] := RoundingResiduals[idx] + Amount;
        AdjustAmount := ClosingAmount - Amount;
        CASE TempSubsidGLAcc."Consol. Translation Method" OF
          TempSubsidGLAcc."Consol. Translation Method"::"Composite Rate":
            CompExchRateAdjAmts[idx] := CompExchRateAdjAmts[idx] + AdjustAmount;
          TempSubsidGLAcc."Consol. Translation Method"::"Equity Rate":
            EqExchRateAdjAmts[idx] := EqExchRateAdjAmts[idx] + AdjustAmount;
          ELSE
            ExchRateAdjAmounts[idx] := ExchRateAdjAmounts[idx] + AdjustAmount;
        END;
        TempSubsidGLAcc."Consol. Translation Method" := OriginalTranslationMethod;
      END;
    END;

    LOCAL PROCEDURE TranslateUsingHistoricalRate@26(AmountToTranslate@1000 : Decimal;DateToTranslate@1001 : Date) TranslatedAmount : Decimal;
    BEGIN
      IF BusUnit."Currency Exchange Rate Table" = BusUnit."Currency Exchange Rate Table"::"Local"
      THEN BEGIN
        ConsolidCurrExchRate.RESET;
        ConsolidCurrExchRate.SETRANGE("Currency Code",BusUnit."Currency Code");
        ConsolidCurrExchRate.SETRANGE("Starting Date",0D,DateToTranslate);
        ConsolidCurrExchRate.FINDLAST;
        ConsolidCurrExchRate.TESTFIELD("Exchange Rate Amount");
        ConsolidCurrExchRate.TESTFIELD("Relational Exch. Rate Amount");
        ConsolidCurrExchRate.TESTFIELD("Relational Currency Code",'');
        HistoricalCurrencyFactor :=
          ConsolidCurrExchRate."Exchange Rate Amount" / ConsolidCurrExchRate."Relational Exch. Rate Amount";
      END ELSE BEGIN
        TempSubsidCurrExchRate.RESET;
        TempSubsidCurrExchRate.SETRANGE("Starting Date",0D,DateToTranslate);
        TempSubsidCurrExchRate.SETRANGE("Currency Code",CurrencyPCY);
        TempSubsidCurrExchRate.FINDLAST;
        TempSubsidCurrExchRate.TESTFIELD("Exchange Rate Amount");
        TempSubsidCurrExchRate.TESTFIELD("Relational Exch. Rate Amount");
        TempSubsidCurrExchRate.TESTFIELD("Relational Currency Code",'');
        HistoricalCurrencyFactor := TempSubsidCurrExchRate."Relational Exch. Rate Amount" /
          TempSubsidCurrExchRate."Exchange Rate Amount";
        IF BusUnit."Data Source" = BusUnit."Data Source"::"Add. Rep. Curr. (ACY)" THEN BEGIN
          TempSubsidCurrExchRate.SETRANGE("Currency Code",CurrencyACY);
          TempSubsidCurrExchRate.FINDLAST;
          TempSubsidCurrExchRate.TESTFIELD("Exchange Rate Amount");
          TempSubsidCurrExchRate.TESTFIELD("Relational Exch. Rate Amount");
          TempSubsidCurrExchRate.TESTFIELD("Relational Currency Code",'');
          HistoricalCurrencyFactor := HistoricalCurrencyFactor *
            TempSubsidCurrExchRate."Exchange Rate Amount" / TempSubsidCurrExchRate."Relational Exch. Rate Amount";
        END;
      END;
      TranslatedAmount := ROUND(AmountToTranslate / HistoricalCurrencyFactor);
    END;

    LOCAL PROCEDURE GenJnlPostLineTmp@22(VAR GenJnlLine@1000 : Record 81);
    BEGIN
      NextLineNo := NextLineNo + 1;
      TempGenJnlLine := GenJnlLine;
      TempGenJnlLine.Amount := ROUND(TempGenJnlLine.Amount);
      TempGenJnlLine."Line No." := NextLineNo;
      TempGenJnlLine."System-Created Entry" := TRUE;
      DimMgt.UpdateGlobalDimFromDimSetID(TempGenJnlLine."Dimension Set ID",
        TempGenJnlLine."Shortcut Dimension 1 Code",TempGenJnlLine."Shortcut Dimension 2 Code");
      TempGenJnlLine.INSERT;
    END;

    LOCAL PROCEDURE GenJnlPostLineFinally@29();
    VAR
      GenJnlPostLine@1000 : Codeunit 12;
    BEGIN
      TempGenJnlLine.SETCURRENTKEY("Journal Template Name","Journal Batch Name","Posting Date");
      IF TempGenJnlLine.FINDSET THEN
        REPEAT
          Window.UPDATE(3,TempGenJnlLine."Account No.");
          OnBeforeGenJnlPostLine(TempGenJnlLine);
          GenJnlPostLine.RunWithCheck(TempGenJnlLine);
        UNTIL TempGenJnlLine.NEXT = 0;
    END;

    LOCAL PROCEDURE TextToDecimal@19(Txt@1000 : Text[50]) Result : Decimal;
    VAR
      DecOnlyTxt@1001 : Text[50];
      Idx@1003 : Integer;
    BEGIN
      FOR Idx := 1 TO STRLEN(Txt) DO
        IF Txt[Idx] IN ['0','1','2','3','4','5','6','7','8','9'] THEN
          DecOnlyTxt := DecOnlyTxt + COPYSTR(Txt,Idx,1);
      IF DecOnlyTxt = '' THEN
        Result := 0
      ELSE
        EVALUATE(Result,DecOnlyTxt);
    END;

    LOCAL PROCEDURE DateToDecimal@25(Dt@1000 : Date) Result : Decimal;
    VAR
      Mon@1001 : Decimal;
      Day@1002 : Decimal;
      Yr@1003 : Decimal;
    BEGIN
      Day := DATE2DMY(Dt,1);
      Mon := DATE2DMY(Dt,2);
      Yr := DATE2DMY(Dt,3);
      Result := Yr * 100 + Mon + Day / 100;
    END;

    LOCAL PROCEDURE ReportError@31(ErrorMsg@1000 : Text[250]);
    BEGIN
      IF TestMode THEN BEGIN
        IF CurErrorIdx = ARRAYLEN(ErrorText) THEN
          ErrorText[CurErrorIdx] := STRSUBSTNO(Text006,ARRAYLEN(ErrorText))
        ELSE BEGIN
          CurErrorIdx := CurErrorIdx + 1;
          ErrorText[CurErrorIdx] := ErrorMsg;
        END;
      END ELSE
        ERROR(ErrorMsg);
    END;

    [External]
    PROCEDURE GetNumSubsidGLAcc@32() : Integer;
    BEGIN
      TempSubsidGLAcc.RESET;
      EXIT(TempSubsidGLAcc.COUNT);
    END;

    [External]
    PROCEDURE Get1stSubsidGLAcc@33(VAR GlAccount@1000 : Record 15) : Boolean;
    BEGIN
      TempSubsidGLAcc.RESET;
      IF TempSubsidGLAcc.FINDFIRST THEN BEGIN
        GlAccount := TempSubsidGLAcc;
        IF TestMode THEN
          TestGLAccounts;
        EXIT(TRUE);
      END;
      EXIT(FALSE);
    END;

    [External]
    PROCEDURE GetNxtSubsidGLAcc@34(VAR GLAccount@1000 : Record 15) : Boolean;
    BEGIN
      IF TempSubsidGLAcc.NEXT <> 0 THEN BEGIN
        GLAccount := TempSubsidGLAcc;
        IF TestMode THEN
          TestGLAccounts;
        EXIT(TRUE);
      END;
      EXIT(FALSE);
    END;

    [External]
    PROCEDURE GetNumSubsidGLEntry@35() : Integer;
    BEGIN
      WITH TempSubsidGLEntry DO BEGIN
        RESET;
        SETCURRENTKEY("G/L Account No.","Posting Date");
        SETRANGE("G/L Account No.",TempSubsidGLAcc."No.");
        EXIT(COUNT);
      END;
    END;

    [External]
    PROCEDURE Get1stSubsidGLEntry@36(VAR GLEntry@1000 : Record 17) : Boolean;
    BEGIN
      ConsolidatingClosingDate :=
        (StartingDate = EndingDate) AND
        (StartingDate <> NORMALDATE(StartingDate));
      IF (StartingDate <> NORMALDATE(StartingDate)) AND
         (StartingDate <> EndingDate)
      THEN
        ReportError(Text030);
      WITH TempSubsidGLEntry DO BEGIN
        RESET;
        SETCURRENTKEY("G/L Account No.","Posting Date");
        SETRANGE("G/L Account No.",TempSubsidGLAcc."No.");
        IF FINDFIRST THEN BEGIN
          GLEntry := TempSubsidGLEntry;
          IF TestMode THEN BEGIN
            IF ("Posting Date" <> NORMALDATE("Posting Date")) AND
               NOT ConsolidatingClosingDate
            THEN
              ReportError(STRSUBSTNO(
                  Text031,
                  TABLECAPTION,
                  FIELDCAPTION("Posting Date"),
                  "Posting Date"));
          END;
          EXIT(TRUE);
        END;
        EXIT(FALSE);
      END;
    END;

    [External]
    PROCEDURE GetNxtSubsidGLEntry@37(VAR GLEntry@1000 : Record 17) : Boolean;
    BEGIN
      WITH TempSubsidGLEntry DO BEGIN
        IF NEXT <> 0 THEN BEGIN
          GLEntry := TempSubsidGLEntry;
          IF TestMode THEN BEGIN
            IF ("Posting Date" <> NORMALDATE("Posting Date")) AND
               NOT ConsolidatingClosingDate
            THEN
              ReportError(STRSUBSTNO(
                  Text031,
                  TABLECAPTION,
                  FIELDCAPTION("Posting Date"),
                  "Posting Date"));
          END;
          EXIT(TRUE);
        END;
        EXIT(FALSE);
      END;
    END;

    LOCAL PROCEDURE InitializeGLAccount@43();
    BEGIN
      TestGLAccounts;
      TempGLEntry.RESET;
      TempGLEntry.DELETEALL;
      TempSubsidGLEntry.SETRANGE("G/L Account No.",TempSubsidGLAcc."No.");
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeGenJnlPostLine@38(VAR GenJnlLine@1000 : Record 81);
    BEGIN
    END;

    BEGIN
    END.
  }
}

