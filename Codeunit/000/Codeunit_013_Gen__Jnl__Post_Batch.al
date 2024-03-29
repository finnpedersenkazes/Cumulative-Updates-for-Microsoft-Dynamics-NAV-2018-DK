OBJECT Codeunit 13 Gen. Jnl.-Post Batch
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    TableNo=81;
    Permissions=TableData 232=imd;
    OnRun=VAR
            GenJnlLine@1000 : Record 81;
          BEGIN
            GenJnlLine.COPY(Rec);
            Code(GenJnlLine);
            Rec := GenJnlLine;
          END;

  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=kan ikke overstige %1 tegn;ENU=cannot exceed %1 characters';
      PostingStateMsg@1001 : TextConst '@@@=This is a message for dialog window. Parameters do not require translation.;DAN=Kladdenavn    #1##########\\Bogf�rer @2@@@@@@@@@@@@@\#3#############;ENU=Journal Batch Name    #1##########\\Posting @2@@@@@@@@@@@@@\#3#############';
      CheckingLinesMsg@1003 : TextConst 'DAN=Kontrollerer linjer;ENU=Checking lines';
      CheckingBalanceMsg@1004 : TextConst 'DAN=Saldoen kontrolleres;ENU=Checking balance';
      UpdatingBalLinesMsg@1005 : TextConst 'DAN=Opdaterer saldolinjer;ENU=Updating bal. lines';
      PostingLinesMsg@1006 : TextConst 'DAN=Bogf�rer linjer;ENU=Posting lines';
      PostingReversLinesMsg@1007 : TextConst 'DAN=Bogf. tilb.f.linjer;ENU=Posting revers. lines';
      UpdatingLinesMsg@1036 : TextConst 'DAN=Opdaterer linjer;ENU=Updating lines';
      Text008@1008 : TextConst 'DAN=skal v�re ens p� alle linjer for samme bilag;ENU=must be the same on all lines for the same document';
      Text009@1009 : TextConst 'DAN="%1 %2 med bogf�ringsdato %3 indeholder mere end en debitor eller kreditor. ";ENU="%1 %2 posted on %3 includes more than one customer or vendor. "';
      Text010@1010 : TextConst 'DAN=Hvis programmet skal beregne moms, skal posterne v�re adskilt af et andet dokumentnr. eller en tom linje.;ENU=In order for the program to calculate VAT, the entries must be separated by another document number or by an empty line.';
      Text012@1012 : TextConst 'DAN="%5 %2 stemmer ikke med %1. ";ENU="%5 %2 is out of balance by %1. "';
      Text013@1013 : TextConst 'DAN=Kontroller, at %3, %4, %5 og %6 er korrekte for hver linje.;ENU=Please check that %3, %4, %5 and %6 are correct for each line.';
      Text014@1014 : TextConst 'DAN="Linjerne i %1 stemmer ikke med %2. ";ENU="The lines in %1 are out of balance by %2. "';
      Text015@1015 : TextConst 'DAN=Kontroller, at %3 og %4 er korrekte for hver linje.;ENU=Check that %3 and %4 are correct for each line.';
      Text016@1016 : TextConst 'DAN="Tilbagef�rselslinjerne i %4 %2 stemmer ikke med %1. ";ENU="Your reversing entries in %4 %2 are out of balance by %1. "';
      Text017@1017 : TextConst 'DAN=Kontroller, at %3 er korrekt for hver linje af denne %4.;ENU=Please check whether %3 is correct for each line for this %4.';
      Text018@1018 : TextConst 'DAN="Tilbagef�rselslinjerne i %1 stemmer ikke med %2. ";ENU="Your reversing entries for %1 are out of balance by %2. "';
      Text019@1019 : TextConst 'DAN="%3 %1 stemmer ikke pga. den ekstra rapporteringsvaluta. ";ENU="%3 %1 is out of balance due to the additional reporting currency. "';
      Text020@1020 : TextConst 'DAN=Kontroller, at %2 er korrekt for hver linje.;ENU=Please check that %2 is correct for each line.';
      Text021@1021 : TextConst 'DAN=m� ikke v�re udfyldt, n�r du bruger gentagelseskladder;ENU=cannot be specified when using recurring journals.';
      Text022@1022 : TextConst 'DAN=Balance og Omvendt Balance gentagelsesmetoder kan kun anvendes for finanskonti.;ENU=The Balance and Reversing Balance recurring methods can be used only for G/L accounts.';
      Text023@1023 : TextConst 'DAN=Fordelinger kan kun bruges i forbindelse med gentagelseskladder.;ENU=Allocations can only be used with recurring journals.';
      Text024@1024 : TextConst 'DAN=<Month Text>;ENU=<Month Text>';
      Text025@1025 : TextConst 'DAN=Der kan maksimalt kun anvendes %1 bogf�ringsnummerserier i hver kladde.;ENU=A maximum of %1 posting number series can be used in each journal.';
      Text026@1026 : TextConst 'DAN="%5 %2 stemmer ikke med %1 %7. ";ENU="%5 %2 is out of balance by %1 %7. "';
      Text027@1027 : TextConst 'DAN="Linjerne i %1 stemmer ikke med %2 %5. ";ENU="The lines in %1 are out of balance by %2 %5. "';
      Text028@1028 : TextConst 'DAN=Gentagelsesmetoderne Balance og Omvendt balance kan kun anvendes i forbindelse med fordelinger.;ENU=The Balance and Reversing Balance recurring methods can be used only with Allocations.';
      GenJnlTemplate@1029 : Record 80;
      GenJnlBatch@1030 : Record 232;
      GenJnlLine2@1032 : Record 81;
      GenJnlLine3@1033 : Record 81;
      TempGenJnlLine4@1034 : TEMPORARY Record 81;
      GenJnlLine5@1035 : Record 81;
      GLEntry@1037 : Record 17;
      GLReg@1038 : Record 45;
      GLAcc@1039 : Record 15;
      GenJnlAlloc@1042 : Record 221;
      AccountingPeriod@1043 : Record 50;
      NoSeries@1044 : TEMPORARY Record 308;
      GLSetup@1045 : Record 98;
      FAJnlSetup@1046 : Record 5605;
      GenJnlLineTemp@1102601000 : TEMPORARY Record 81;
      GenJnlCheckLine@1047 : Codeunit 11;
      GenJnlPostLine@1048 : Codeunit 12;
      GenJnlPostPreview@1080 : Codeunit 19;
      NoSeriesMgt@1049 : Codeunit 396;
      NoSeriesMgt2@1050 : ARRAY [10] OF Codeunit 396;
      ICOutboxMgt@1078 : Codeunit 427;
      PostingSetupMgt@1072 : Codeunit 48;
      Window@1052 : Dialog;
      GLRegNo@1053 : Integer;
      StartLineNo@1054 : Integer;
      StartLineNoReverse@1055 : Integer;
      LastDate@1056 : Date;
      LastDocType@1057 : Integer;
      LastDocNo@1058 : Code[20];
      LastPostedDocNo@1059 : Code[20];
      CurrentBalance@1060 : Decimal;
      CurrentBalanceReverse@1061 : Decimal;
      Day@1062 : Integer;
      Week@1063 : Integer;
      Month@1064 : Integer;
      MonthText@1065 : Text[30];
      NoOfRecords@1066 : Integer;
      NoOfReversingRecords@1067 : Integer;
      LineCount@1068 : Integer;
      NoOfPostingNoSeries@1069 : Integer;
      PostingNoSeriesNo@1070 : Integer;
      DocCorrection@1071 : Boolean;
      VATEntryCreated@1073 : Boolean;
      LastFAAddCurrExchRate@1074 : Decimal;
      LastCurrencyCode@1075 : Code[10];
      CurrencyBalance@1076 : Decimal;
      Text029@1041 : TextConst '@@@="%1 = Document Type;%2 = Document No.;%3=Posting Date";DAN=%1 %2 med bogf�ringsdato %3 indeholder mere end �n debitor, kreditor eller IC-partner.;ENU=%1 %2 posted on %3 includes more than one customer, vendor or IC Partner.';
      Text030@1011 : TextConst 'DAN=Du kan ikke angive finanskonto eller bankkonto i b�de %1 og %2.;ENU=You cannot enter G/L Account or Bank Account in both %1 and %2.';
      Text031@1040 : TextConst 'DAN=Linjenr. %1 indeholder ikke en finanskonto eller bankkonto. N�r feltet %2 indeholder et kontonummer, skal feltet %3 eller %4 indeholde en finanskonto eller bankkonto.;ENU=Line No. %1 does not contain a G/L Account or Bank Account. When the %2 field contains an account number, either the %3 field or the %4 field must contain a G/L Account or Bank Account.';
      RefPostingState@1002 : 'Checking lines,Checking balance,Updating bal. lines,Posting Lines,Posting revers. lines,Updating lines';
      PreviewMode@1051 : Boolean;
      SkippedLineMsg@1092 : TextConst 'DAN=En eller flere linjer er ikke blevet bogf�rt, fordi bel�bet er nul.;ENU=One or more lines has not been posted because the amount is zero.';
      ConfirmPostingAfterCurrentPeriodQst@1079 : TextConst 'DAN=Bogf�ringsdatoen for �n eller flere kladdelinjer ligger efter det indev�rende regnskabs�r. Vil du forts�tte?;ENU=The posting date of one or more journal lines is after the current fiscal year. Do you want to continue?';

    LOCAL PROCEDURE Code@7(VAR GenJnlLine@1000 : Record 81);
    VAR
      TempMarkedGenJnlLine@1001 : TEMPORARY Record 81;
    BEGIN
      WITH GenJnlLine DO BEGIN
        SETRANGE("Journal Template Name","Journal Template Name");
        SETRANGE("Journal Batch Name","Journal Batch Name");

        LOCKTABLE;
        GenJnlAlloc.LOCKTABLE;

        GenJnlTemplate.GET("Journal Template Name");
        GenJnlBatch.GET("Journal Template Name","Journal Batch Name");
        IF STRLEN(INCSTR(GenJnlBatch.Name)) > MAXSTRLEN(GenJnlBatch.Name) THEN
          GenJnlBatch.FIELDERROR(
            Name,
            STRSUBSTNO(Text000,MAXSTRLEN(GenJnlBatch.Name)));

        IF GenJnlTemplate.Recurring THEN BEGIN
          TempMarkedGenJnlLine.COPY(GenJnlLine);
          CheckGenJnlLineDates(TempMarkedGenJnlLine,GenJnlLine);
          TempMarkedGenJnlLine.SETRANGE("Posting Date",0D,WORKDATE);
          GLSetup.GET;
        END;

        IF GenJnlTemplate.Recurring THEN BEGIN
          ProcessLines(TempMarkedGenJnlLine);
          COPY(TempMarkedGenJnlLine);
        END ELSE
          ProcessLines(GenJnlLine);
      END;
    END;

    LOCAL PROCEDURE ProcessLines@43(VAR GenJnlLine@1000 : Record 81);
    VAR
      TempGenJnlLine@1015 : TEMPORARY Record 81;
      GenJnlLineVATInfoSource@1014 : Record 81;
      UpdateAnalysisView@1010 : Codeunit 410;
      ICLastDocNo@1009 : Code[20];
      CurrentICPartner@1005 : Code[20];
      LastLineNo@1008 : Integer;
      ICTransactionNo@1007 : Integer;
      ICLastDocType@1004 : Integer;
      ICLastDate@1006 : Date;
      VATInfoSourceLineIsInserted@1003 : Boolean;
      SkippedLine@1002 : Boolean;
      PostingAfterCurrentFiscalYearConfirmed@1001 : Boolean;
    BEGIN
      WITH GenJnlLine DO BEGIN
        IF NOT FIND('=><') THEN BEGIN
          "Line No." := 0;
          IF PreviewMode THEN
            GenJnlPostPreview.ThrowError;
          COMMIT;
          EXIT;
        END;

        Window.OPEN(PostingStateMsg);
        Window.UPDATE(1,"Journal Batch Name");

        // Check lines
        LineCount := 0;
        StartLineNo := "Line No.";
        NoOfRecords := COUNT;
        GenJnlCheckLine.SetBatchMode(TRUE);
        REPEAT
          LineCount := LineCount + 1;
          UpdateDialog(RefPostingState::"Checking lines",LineCount,NoOfRecords);
          CheckLine(GenJnlLine,PostingAfterCurrentFiscalYearConfirmed);
          TempGenJnlLine := GenJnlLine5;
          TempGenJnlLine.INSERT;
          IF NEXT = 0 THEN
            FINDFIRST;
        UNTIL "Line No." = StartLineNo;
        IF GenJnlTemplate.Type = GenJnlTemplate.Type::Intercompany THEN
          CheckICDocument(TempGenJnlLine);

        ProcessBalanceOfLines(GenJnlLine,GenJnlLineVATInfoSource,VATInfoSourceLineIsInserted,LastLineNo,CurrentICPartner);

        // Find next register no.
        GLEntry.LOCKTABLE;
        IF GLEntry.FINDLAST THEN;
        FindNextGLRegisterNo;

        // Post lines
        LineCount := 0;
        LastDocNo := '';
        LastPostedDocNo := '';
        TempGenJnlLine4.DELETEALL;
        NoOfReversingRecords := 0;
        FINDSET(TRUE,FALSE);
        REPEAT
          ProcessICLines(CurrentICPartner,ICTransactionNo,ICLastDocNo,ICLastDate,ICLastDocType,GenJnlLine,TempGenJnlLine);
          GenJnlLine3 := GenJnlLine;
          IF NOT PostGenJournalLine(GenJnlLine3,CurrentICPartner,ICTransactionNo) THEN
            SkippedLine := TRUE;
        UNTIL NEXT = 0;

        // Post reversing lines
        PostReversingLines(TempGenJnlLine4);

        IF PreviewMode THEN
          GenJnlPostPreview.ThrowError;

        // Copy register no. and current journal batch name to general journal
        IF NOT GLReg.FINDLAST OR (GLReg."No." <> GLRegNo) THEN
          GLRegNo := 0;

        INIT;
        "Line No." := GLRegNo;

        // Update/delete lines
        IF GLRegNo <> 0 THEN
          UpdateAndDeleteLines(GenJnlLine);

        IF GenJnlBatch."No. Series" <> '' THEN
          NoSeriesMgt.SaveNoSeries;
        IF NoSeries.FINDSET THEN
          REPEAT
            EVALUATE(PostingNoSeriesNo,NoSeries.Description);
            NoSeriesMgt2[PostingNoSeriesNo].SaveNoSeries;
          UNTIL NoSeries.NEXT = 0;

        COMMIT;
        CLEAR(GenJnlCheckLine);
        CLEAR(GenJnlPostLine);
        CLEARMARKS;
      END;
      UpdateAnalysisView.UpdateAll(0,TRUE);
      GenJnlBatch.OnMoveGenJournalBatch(GLReg.RECORDID);
      COMMIT;

      IF SkippedLine AND GUIALLOWED THEN
        MESSAGE(SkippedLineMsg);
    END;

    LOCAL PROCEDURE ProcessBalanceOfLines@42(VAR GenJnlLine@1000 : Record 81;VAR GenJnlLineVATInfoSource@1003 : Record 81;VAR VATInfoSourceLineIsInserted@1002 : Boolean;VAR LastLineNo@1004 : Integer;CurrentICPartner@1001 : Code[20]);
    VAR
      VATPostingSetup@1006 : Record 325;
      BalVATPostingSetup@1005 : Record 325;
      ErrorMessage@1007 : Text;
      ForceCheckBalance@1008 : Boolean;
    BEGIN
      WITH GenJnlLine DO BEGIN
        IF (GenJnlBatch."No. Series" = '') AND (GenJnlBatch."Posting No. Series" = '') AND GenJnlTemplate."Force Doc. Balance" THEN
          SETCURRENTKEY("Document No.");
        LineCount := 0;
        LastDate := 0D;
        LastDocType := 0;
        LastDocNo := '';
        LastFAAddCurrExchRate := 0;
        GenJnlLineTemp.RESET;
        GenJnlLineTemp.DELETEALL;
        VATEntryCreated := FALSE;
        CurrentBalance := 0;
        CurrentBalanceReverse := 0;
        CurrencyBalance := 0;

        FINDSET(TRUE,FALSE);
        LastCurrencyCode := "Currency Code";

        REPEAT
          LineCount := LineCount + 1;
          UpdateDialog(RefPostingState::"Checking balance",LineCount,NoOfRecords);

          IF NOT EmptyLine THEN BEGIN
            IF NOT PreviewMode THEN
              CheckDocNoBasedOnNoSeries(LastDocNo,GenJnlBatch."No. Series",NoSeriesMgt);
            IF "Posting No. Series" <> '' THEN
              TESTFIELD("Posting No. Series",GenJnlBatch."Posting No. Series");
            IF ("Posting Date" <> LastDate) OR
               ("Document Type" <> LastDocType) OR ("Document No." <> LastDocNo)
            THEN BEGIN
              IF Correction THEN
                GenJnlTemplate.TESTFIELD("Force Doc. Balance",TRUE);
              DocCorrection := Correction;
            END ELSE
              IF Correction <> DocCorrection THEN
                FIELDERROR(Correction,Text008);
          END;
          OnBeforeIfCheckBalance(GenJnlTemplate,GenJnlLine,LastDocType,LastDocNo,LastDate,ForceCheckBalance);
          IF ForceCheckBalance OR ("Posting Date" <> LastDate) OR GenJnlTemplate."Force Doc. Balance" AND
             (("Document Type" <> LastDocType) OR ("Document No." <> LastDocNo))
          THEN BEGIN
            CheckBalance(GenJnlLine);
            CurrencyBalance := 0;
            LastCurrencyCode := "Currency Code";
            GenJnlLineTemp.RESET;
            GenJnlLineTemp.DELETEALL;
          END;

          IF Amount <> 0 THEN BEGIN
            IF LastFAAddCurrExchRate <> "FA Add.-Currency Factor" THEN
              CheckAddExchRateBalance(GenJnlLine);
            IF (CurrentBalance = 0) AND (CurrentICPartner = '') THEN BEGIN
              GenJnlLineTemp.RESET;
              GenJnlLineTemp.DELETEALL;
              IF VATEntryCreated AND VATInfoSourceLineIsInserted THEN
                UpdateGenJnlLineWithVATInfo(GenJnlLine,GenJnlLineVATInfoSource,StartLineNo,LastLineNo);
              VATEntryCreated := FALSE;
              VATInfoSourceLineIsInserted := FALSE;
              StartLineNo := "Line No.";
            END;
            IF CurrentBalanceReverse = 0 THEN
              StartLineNoReverse := "Line No.";
            UpdateLineBalance;
            CurrentBalance := CurrentBalance + "Balance (LCY)";
            IF "Recurring Method" >= "Recurring Method"::"RF Reversing Fixed" THEN
              CurrentBalanceReverse := CurrentBalanceReverse + "Balance (LCY)";

            UpdateCurrencyBalanceForRecurringLine(GenJnlLine);
          END;

          LastDate := "Posting Date";
          LastDocType := "Document Type";
          IF NOT EmptyLine THEN
            LastDocNo := "Document No.";
          LastFAAddCurrExchRate := "FA Add.-Currency Factor";
          IF GenJnlTemplate."Force Doc. Balance" THEN BEGIN
            IF NOT VATPostingSetup.GET("VAT Bus. Posting Group","VAT Prod. Posting Group") THEN
              CLEAR(VATPostingSetup);
            IF NOT BalVATPostingSetup.GET("Bal. VAT Bus. Posting Group","Bal. VAT Prod. Posting Group") THEN
              CLEAR(BalVATPostingSetup);
            VATEntryCreated :=
              VATEntryCreated OR
              (("Account Type" = "Account Type"::"G/L Account") AND ("Account No." <> '') AND
               ("Gen. Posting Type" IN ["Gen. Posting Type"::Purchase,"Gen. Posting Type"::Sale]) AND
               (VATPostingSetup."VAT %" <> 0)) OR
              (("Bal. Account Type" = "Bal. Account Type"::"G/L Account") AND ("Bal. Account No." <> '') AND
               ("Bal. Gen. Posting Type" IN ["Bal. Gen. Posting Type"::Purchase,"Bal. Gen. Posting Type"::Sale]) AND
               (BalVATPostingSetup."VAT %" <> 0));
            IF GenJnlLineTemp.IsCustVendICAdded(GenJnlLine) THEN BEGIN
              GenJnlLineVATInfoSource := GenJnlLine;
              VATInfoSourceLineIsInserted := TRUE;
            END;
            IF (GenJnlLineTemp.COUNT > 1) AND VATEntryCreated THEN BEGIN
              ErrorMessage := Text009 + Text010;
              ERROR(ErrorMessage,"Document Type","Document No.","Posting Date");
            END;
            IF (GenJnlLineTemp.COUNT > 1) AND (CurrentICPartner <> '') AND
               (GenJnlTemplate.Type = GenJnlTemplate.Type::Intercompany)
            THEN
              ERROR(
                Text029,
                "Document Type","Document No.","Posting Date");
            LastLineNo := "Line No.";
          END;
        UNTIL NEXT = 0;
        CheckBalance(GenJnlLine);
        CopyFields(GenJnlLine);
        IF VATEntryCreated AND VATInfoSourceLineIsInserted THEN
          UpdateGenJnlLineWithVATInfo(GenJnlLine,GenJnlLineVATInfoSource,StartLineNo,LastLineNo);
      END;
    END;

    LOCAL PROCEDURE ProcessICLines@49(VAR CurrentICPartner@1001 : Code[20];VAR ICTransactionNo@1002 : Integer;VAR ICLastDocNo@1006 : Code[20];VAR ICLastDate@1005 : Date;VAR ICLastDocType@1003 : Integer;VAR GenJnlLine@1000 : Record 81;VAR TempGenJnlLine@1004 : TEMPORARY Record 81);
    VAR
      HandledICInboxTrans@1007 : Record 420;
    BEGIN
      WITH GenJnlLine DO
        IF (GenJnlTemplate.Type = GenJnlTemplate.Type::Intercompany) AND NOT EmptyLine AND
           (("Posting Date" <> ICLastDate) OR ("Document Type" <> ICLastDocType) OR ("Document No." <> ICLastDocNo))
        THEN BEGIN
          CurrentICPartner := '';
          ICLastDate := "Posting Date";
          ICLastDocType := "Document Type";
          ICLastDocNo := "Document No.";
          TempGenJnlLine.RESET;
          TempGenJnlLine.SETCURRENTKEY("Journal Template Name","Journal Batch Name","Posting Date","Document No.");
          TempGenJnlLine.SETRANGE("Journal Template Name","Journal Template Name");
          TempGenJnlLine.SETRANGE("Journal Batch Name","Journal Batch Name");
          TempGenJnlLine.SETRANGE("Posting Date","Posting Date");
          TempGenJnlLine.SETRANGE("Document No.","Document No.");
          TempGenJnlLine.SETFILTER("IC Partner Code",'<>%1','');
          IF TempGenJnlLine.FINDFIRST AND (TempGenJnlLine."IC Partner Code" <> '') THEN BEGIN
            CurrentICPartner := TempGenJnlLine."IC Partner Code";
            IF TempGenJnlLine."IC Direction" = TempGenJnlLine."IC Direction"::Outgoing THEN
              ICTransactionNo := ICOutboxMgt.CreateOutboxJnlTransaction(TempGenJnlLine,FALSE)
            ELSE
              IF HandledICInboxTrans.GET(
                   TempGenJnlLine."IC Partner Transaction No.",TempGenJnlLine."IC Partner Code",
                   HandledICInboxTrans."Transaction Source"::"Created by Partner",TempGenJnlLine."Document Type")
              THEN BEGIN
                HandledICInboxTrans.LOCKTABLE;
                HandledICInboxTrans.Status := HandledICInboxTrans.Status::Posted;
                HandledICInboxTrans.MODIFY;
              END
          END
        END;
    END;

    LOCAL PROCEDURE CheckBalance@8(VAR GenJnlLine@1000 : Record 81);
    BEGIN
      OnBeforeCheckBalance(
        GenJnlTemplate,GenJnlLine,CurrentBalance,CurrentBalanceReverse,CurrencyBalance,
        StartLineNo,StartLineNoReverse,LastDocType,LastDocNo,LastDate,LastCurrencyCode);

      WITH GenJnlLine DO BEGIN
        IF CurrentBalance <> 0 THEN BEGIN
          GET("Journal Template Name","Journal Batch Name",StartLineNo);
          IF GenJnlTemplate."Force Doc. Balance" THEN
            ERROR(
              Text012 +
              Text013,
              CurrentBalance,LastDocNo,FIELDCAPTION("Posting Date"),FIELDCAPTION("Document Type"),
              FIELDCAPTION("Document No."),FIELDCAPTION(Amount));
          ERROR(
            Text014 +
            Text015,
            LastDate,CurrentBalance,FIELDCAPTION("Posting Date"),FIELDCAPTION(Amount));
        END;
        IF CurrentBalanceReverse <> 0 THEN BEGIN
          GET("Journal Template Name","Journal Batch Name",StartLineNoReverse);
          IF GenJnlTemplate."Force Doc. Balance" THEN
            ERROR(
              Text016 +
              Text017,
              CurrentBalanceReverse,LastDocNo,FIELDCAPTION("Recurring Method"),FIELDCAPTION("Document No."));
          ERROR(
            Text018 +
            Text017,
            LastDate,CurrentBalanceReverse,FIELDCAPTION("Recurring Method"),FIELDCAPTION("Posting Date"));
        END;
        IF (LastCurrencyCode <> '') AND (CurrencyBalance <> 0) THEN BEGIN
          GET("Journal Template Name","Journal Batch Name",StartLineNo);
          IF GenJnlTemplate."Force Doc. Balance" THEN
            ERROR(
              Text026 +
              Text013,
              CurrencyBalance,LastDocNo,FIELDCAPTION("Posting Date"),FIELDCAPTION("Document Type"),
              FIELDCAPTION("Document No."),FIELDCAPTION(Amount),
              LastCurrencyCode);
          ERROR(
            Text027 +
            Text015,
            LastDate,CurrencyBalance,FIELDCAPTION("Posting Date"),FIELDCAPTION(Amount),LastCurrencyCode);
        END;
      END;
    END;

    LOCAL PROCEDURE CheckAddExchRateBalance@9(GenJnlLine@1000 : Record 81);
    BEGIN
      WITH GenJnlLine DO
        IF CurrentBalance <> 0 THEN
          ERROR(
            Text019 +
            Text020,
            LastDocNo,FIELDCAPTION("FA Add.-Currency Factor"),FIELDCAPTION("Document No."));
    END;

    LOCAL PROCEDURE CheckRecurringLine@1(VAR GenJnlLine2@1000 : Record 81);
    VAR
      DummyDateFormula@1001 : DateFormula;
    BEGIN
      WITH GenJnlLine2 DO BEGIN
        IF "Account No." <> '' THEN
          IF GenJnlTemplate.Recurring THEN BEGIN
            TESTFIELD("Recurring Method");
            TESTFIELD("Recurring Frequency");
            IF "Bal. Account No." <> '' THEN
              FIELDERROR("Bal. Account No.",Text021);
            CASE "Recurring Method" OF
              "Recurring Method"::"V  Variable","Recurring Method"::"RV Reversing Variable",
              "Recurring Method"::"F  Fixed","Recurring Method"::"RF Reversing Fixed":
                TESTFIELD(Amount);
              "Recurring Method"::"B  Balance","Recurring Method"::"RB Reversing Balance":
                TESTFIELD(Amount,0);
            END;
          END ELSE BEGIN
            TESTFIELD("Recurring Method",0);
            TESTFIELD("Recurring Frequency",DummyDateFormula);
          END;
      END;
    END;

    LOCAL PROCEDURE UpdateRecurringAmt@2(VAR GenJnlLine2@1000 : Record 81);
    BEGIN
      WITH GenJnlLine2 DO BEGIN
        IF ("Account No." <> '') AND
           ("Recurring Method" IN
            ["Recurring Method"::"B  Balance","Recurring Method"::"RB Reversing Balance"])
        THEN BEGIN
          GLEntry.LOCKTABLE;
          IF "Account Type" = "Account Type"::"G/L Account" THEN BEGIN
            GLAcc."No." := "Account No.";
            GLAcc.SETRANGE("Date Filter",0D,"Posting Date");
            IF GLSetup."Additional Reporting Currency" <> '' THEN BEGIN
              "Source Currency Code" := GLSetup."Additional Reporting Currency";
              GLAcc.CALCFIELDS("Additional-Currency Net Change");
              "Source Currency Amount" := -GLAcc."Additional-Currency Net Change";
              GenJnlAlloc.UpdateAllocationsAddCurr(GenJnlLine2,"Source Currency Amount");
            END;
            GLAcc.CALCFIELDS("Net Change");
            VALIDATE(Amount,-GLAcc."Net Change");
          END ELSE
            ERROR(
              Text022);
        END;
      END;
    END;

    LOCAL PROCEDURE CheckAllocations@3(VAR GenJnlLine2@1000 : Record 81);
    BEGIN
      WITH GenJnlLine2 DO BEGIN
        IF "Account No." <> '' THEN BEGIN
          IF "Recurring Method" IN
             ["Recurring Method"::"B  Balance",
              "Recurring Method"::"RB Reversing Balance"]
          THEN BEGIN
            GenJnlAlloc.RESET;
            GenJnlAlloc.SETRANGE("Journal Template Name","Journal Template Name");
            GenJnlAlloc.SETRANGE("Journal Batch Name","Journal Batch Name");
            GenJnlAlloc.SETRANGE("Journal Line No.","Line No.");
            IF GenJnlAlloc.ISEMPTY THEN
              ERROR(
                Text028);
          END;

          GenJnlAlloc.RESET;
          GenJnlAlloc.SETRANGE("Journal Template Name","Journal Template Name");
          GenJnlAlloc.SETRANGE("Journal Batch Name","Journal Batch Name");
          GenJnlAlloc.SETRANGE("Journal Line No.","Line No.");
          GenJnlAlloc.SETFILTER(Amount,'<>0');
          IF NOT GenJnlAlloc.ISEMPTY THEN BEGIN
            IF NOT GenJnlTemplate.Recurring THEN
              ERROR(Text023);
            GenJnlAlloc.SETRANGE("Account No.",'');
            IF GenJnlAlloc.FINDFIRST THEN
              GenJnlAlloc.TESTFIELD("Account No.");
          END;
        END;
      END;
    END;

    LOCAL PROCEDURE MakeRecurringTexts@4(VAR GenJnlLine2@1000 : Record 81);
    BEGIN
      WITH GenJnlLine2 DO BEGIN
        IF ("Account No." <> '') AND ("Recurring Method" <> 0) THEN BEGIN
          Day := DATE2DMY("Posting Date",1);
          Week := DATE2DWY("Posting Date",2);
          Month := DATE2DMY("Posting Date",2);
          MonthText := FORMAT("Posting Date",0,Text024);
          AccountingPeriod.SETRANGE("Starting Date",0D,"Posting Date");
          IF NOT AccountingPeriod.FINDLAST THEN
            AccountingPeriod.Name := '';
          "Document No." :=
            DELCHR(
              PADSTR(
                STRSUBSTNO("Document No.",Day,Week,Month,MonthText,AccountingPeriod.Name),
                MAXSTRLEN("Document No.")),
              '>');
          Description :=
            DELCHR(
              PADSTR(
                STRSUBSTNO(Description,Day,Week,Month,MonthText,AccountingPeriod.Name),
                MAXSTRLEN(Description)),
              '>');
        END;
      END;
    END;

    LOCAL PROCEDURE PostAllocations@5(VAR AllocateGenJnlLine@1000 : Record 81;Reversing@1001 : Boolean);
    BEGIN
      WITH AllocateGenJnlLine DO
        IF "Account No." <> '' THEN BEGIN
          GenJnlAlloc.RESET;
          GenJnlAlloc.SETRANGE("Journal Template Name","Journal Template Name");
          GenJnlAlloc.SETRANGE("Journal Batch Name","Journal Batch Name");
          GenJnlAlloc.SETRANGE("Journal Line No.","Line No.");
          GenJnlAlloc.SETFILTER("Account No.",'<>%1','');
          IF GenJnlAlloc.FINDSET(TRUE,FALSE) THEN BEGIN
            GenJnlLine2.INIT;
            GenJnlLine2."Account Type" := GenJnlLine2."Account Type"::"G/L Account";
            GenJnlLine2."Posting Date" := "Posting Date";
            GenJnlLine2."Document Type" := "Document Type";
            GenJnlLine2."Document No." := "Document No.";
            GenJnlLine2.Description := Description;
            GenJnlLine2."Source Code" := "Source Code";
            GenJnlLine2."Journal Batch Name" := "Journal Batch Name";
            GenJnlLine2."Line No." := "Line No.";
            GenJnlLine2."Reason Code" := "Reason Code";
            GenJnlLine2.Correction := Correction;
            GenJnlLine2."Recurring Method" := "Recurring Method";
            IF "Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor] THEN BEGIN
              GenJnlLine2."Bill-to/Pay-to No." := "Bill-to/Pay-to No.";
              GenJnlLine2."Ship-to/Order Address Code" := "Ship-to/Order Address Code";
            END;
            REPEAT
              GenJnlLine2.CopyFromGenJnlAllocation(GenJnlAlloc);
              GenJnlLine2."Shortcut Dimension 1 Code" := GenJnlAlloc."Shortcut Dimension 1 Code";
              GenJnlLine2."Shortcut Dimension 2 Code" := GenJnlAlloc."Shortcut Dimension 2 Code";
              GenJnlLine2."Dimension Set ID" := GenJnlAlloc."Dimension Set ID";
              GenJnlLine2."Allow Zero-Amount Posting" := TRUE;
              PrepareGenJnlLineAddCurr(GenJnlLine2);
              IF NOT Reversing THEN BEGIN
                GenJnlPostLine.RunWithCheck(GenJnlLine2);
                IF "Recurring Method" IN
                   ["Recurring Method"::"V  Variable","Recurring Method"::"B  Balance"]
                THEN BEGIN
                  GenJnlAlloc.Amount := 0;
                  GenJnlAlloc."Additional-Currency Amount" := 0;
                  GenJnlAlloc.MODIFY;
                END;
              END ELSE BEGIN
                MultiplyAmounts(GenJnlLine2,-1);
                GenJnlLine2."Reversing Entry" := TRUE;
                GenJnlPostLine.RunWithCheck(GenJnlLine2);
                IF "Recurring Method" IN
                   ["Recurring Method"::"RV Reversing Variable",
                    "Recurring Method"::"RB Reversing Balance"]
                THEN BEGIN
                  GenJnlAlloc.Amount := 0;
                  GenJnlAlloc."Additional-Currency Amount" := 0;
                  GenJnlAlloc.MODIFY;
                END;
              END;
            UNTIL GenJnlAlloc.NEXT = 0;
          END;
        END;

      OnAfterPostAllocations(AllocateGenJnlLine,Reversing);
    END;

    LOCAL PROCEDURE MultiplyAmounts@6(VAR GenJnlLine2@1000 : Record 81;Factor@1001 : Decimal);
    BEGIN
      WITH GenJnlLine2 DO
        IF "Account No." <> '' THEN BEGIN
          Amount := Amount * Factor;
          "Debit Amount" := "Debit Amount" * Factor;
          "Credit Amount" := "Credit Amount" * Factor;
          "Amount (LCY)" := "Amount (LCY)" * Factor;
          "Balance (LCY)" := "Balance (LCY)" * Factor;
          "Sales/Purch. (LCY)" := "Sales/Purch. (LCY)" * Factor;
          "Profit (LCY)" := "Profit (LCY)" * Factor;
          "Inv. Discount (LCY)" := "Inv. Discount (LCY)" * Factor;
          Quantity := Quantity * Factor;
          "VAT Amount" := "VAT Amount" * Factor;
          "VAT Base Amount" := "VAT Base Amount" * Factor;
          "VAT Amount (LCY)" := "VAT Amount (LCY)" * Factor;
          "VAT Base Amount (LCY)" := "VAT Base Amount (LCY)" * Factor;
          "Source Currency Amount" := "Source Currency Amount" * Factor;
          IF "Job No." <> '' THEN BEGIN
            "Job Quantity" := "Job Quantity" * Factor;
            "Job Total Cost (LCY)" := "Job Total Cost (LCY)" * Factor;
            "Job Total Price (LCY)" := "Job Total Price (LCY)" * Factor;
            "Job Line Amount (LCY)" := "Job Line Amount (LCY)" * Factor;
            "Job Total Cost" := "Job Total Cost" * Factor;
            "Job Total Price" := "Job Total Price" * Factor;
            "Job Line Amount" := "Job Line Amount" * Factor;
            "Job Line Discount Amount" := "Job Line Discount Amount" * Factor;
            "Job Line Disc. Amount (LCY)" := "Job Line Disc. Amount (LCY)" * Factor;
          END;
        END;

      OnAfterMultiplyAmounts(GenJnlLine2,Factor);
    END;

    LOCAL PROCEDURE CheckDocumentNo@11(VAR GenJnlLine2@1000 : Record 81);
    BEGIN
      WITH GenJnlLine2 DO BEGIN
        IF "Posting No. Series" = '' THEN
          "Posting No. Series" := GenJnlBatch."No. Series"
        ELSE
          IF NOT EmptyLine THEN
            IF "Document No." = LastDocNo THEN
              "Document No." := LastPostedDocNo
            ELSE BEGIN
              IF NOT NoSeries.GET("Posting No. Series") THEN BEGIN
                NoOfPostingNoSeries := NoOfPostingNoSeries + 1;
                IF NoOfPostingNoSeries > ARRAYLEN(NoSeriesMgt2) THEN
                  ERROR(
                    Text025,
                    ARRAYLEN(NoSeriesMgt2));
                NoSeries.Code := "Posting No. Series";
                NoSeries.Description := FORMAT(NoOfPostingNoSeries);
                NoSeries.INSERT;
              END;
              LastDocNo := "Document No.";
              EVALUATE(PostingNoSeriesNo,NoSeries.Description);
              "Document No." :=
                NoSeriesMgt2[PostingNoSeriesNo].GetNextNo("Posting No. Series","Posting Date",TRUE);
              LastPostedDocNo := "Document No.";
            END;
      END;
    END;

    LOCAL PROCEDURE PrepareGenJnlLineAddCurr@10(VAR GenJnlLine@1000 : Record 81);
    BEGIN
      IF (GLSetup."Additional Reporting Currency" <> '') AND
         (GenJnlLine."Recurring Method" IN
          [GenJnlLine."Recurring Method"::"B  Balance",
           GenJnlLine."Recurring Method"::"RB Reversing Balance"])
      THEN BEGIN
        GenJnlLine."Source Currency Code" := GLSetup."Additional Reporting Currency";
        IF (GenJnlLine.Amount = 0) AND
           (GenJnlLine."Source Currency Amount" <> 0)
        THEN BEGIN
          GenJnlLine."Additional-Currency Posting" :=
            GenJnlLine."Additional-Currency Posting"::"Additional-Currency Amount Only";
          GenJnlLine.Amount := GenJnlLine."Source Currency Amount";
          GenJnlLine."Source Currency Amount" := 0;
        END;
      END;
    END;

    LOCAL PROCEDURE CopyFields@12(VAR GenJnlLine@1004 : Record 81);
    VAR
      GenJnlLine4@1000 : Record 81;
      GenJnlLine6@1001 : Record 81;
      TempGenJnlLine@1007 : TEMPORARY Record 81;
      JnlLineTotalQty@1002 : Integer;
      RefPostingSubState@1003 : 'Check account,Check bal. account,Update lines';
    BEGIN
      GenJnlLine6.SETCURRENTKEY("Journal Template Name","Journal Batch Name","Posting Date","Document No.");
      GenJnlLine4.FILTERGROUP(2);
      GenJnlLine4.COPY(GenJnlLine);
      GenJnlLine4.FILTERGROUP(0);
      GenJnlLine6.FILTERGROUP(2);
      GenJnlLine6.COPY(GenJnlLine);
      GenJnlLine6.FILTERGROUP(0);
      GenJnlLine6.SETRANGE("Bill-to/Pay-to No.",'');
      GenJnlLine4.SETFILTER(
        "Account Type",'%1|%2',GenJnlLine4."Account Type"::Customer,GenJnlLine4."Account Type"::Vendor);
      GenJnlLine4.SETRANGE("Bal. Account No.",'');
      CheckAndCopyBalancingData(GenJnlLine4,GenJnlLine6,TempGenJnlLine,FALSE);

      GenJnlLine4.SETRANGE("Account Type");
      GenJnlLine4.SETRANGE("Bal. Account No.");
      GenJnlLine4.SETFILTER(
        "Bal. Account Type",'%1|%2',GenJnlLine4."Bal. Account Type"::Customer,GenJnlLine4."Bal. Account Type"::Vendor);
      GenJnlLine4.SETRANGE("Account No.",'');
      CheckAndCopyBalancingData(GenJnlLine4,GenJnlLine6,TempGenJnlLine,TRUE);

      JnlLineTotalQty := TempGenJnlLine.COUNT;
      LineCount := 0;
      IF TempGenJnlLine.FINDSET THEN
        REPEAT
          LineCount := LineCount + 1;
          UpdateDialogUpdateBalLines(RefPostingSubState::"Update lines",LineCount,JnlLineTotalQty);
          GenJnlLine4.GET(TempGenJnlLine."Journal Template Name",TempGenJnlLine."Journal Batch Name",TempGenJnlLine."Line No.");
          CopyGenJnlLineBalancingData(GenJnlLine4,TempGenJnlLine);
          GenJnlLine4.MODIFY;
        UNTIL TempGenJnlLine.NEXT = 0;
    END;

    LOCAL PROCEDURE CheckICDocument@13(VAR TempGenJnlLine1@1001 : TEMPORARY Record 81);
    VAR
      TempGenJnlLine2@1002 : TEMPORARY Record 81;
      CurrentICPartner@1000 : Code[20];
    BEGIN
      WITH TempGenJnlLine1 DO BEGIN
        SETCURRENTKEY("Journal Template Name","Journal Batch Name","Posting Date","Document No.");
        SETRANGE("Journal Template Name","Journal Template Name");
        SETRANGE("Journal Batch Name","Journal Batch Name");
        FIND('-');
        REPEAT
          IF ("Posting Date" <> LastDate) OR ("Document Type" <> LastDocType) OR ("Document No." <> LastDocNo) THEN BEGIN
            TempGenJnlLine2 := TempGenJnlLine1;
            SETRANGE("Posting Date","Posting Date");
            SETRANGE("Document No.","Document No.");
            SETFILTER("IC Partner Code",'<>%1','');
            IF FIND('-') THEN
              CurrentICPartner := "IC Partner Code"
            ELSE
              CurrentICPartner := '';
            SETRANGE("Posting Date");
            SETRANGE("Document No.");
            SETRANGE("IC Partner Code");
            LastDate := "Posting Date";
            LastDocType := "Document Type";
            LastDocNo := "Document No.";
            TempGenJnlLine1 := TempGenJnlLine2;
          END;
          IF (CurrentICPartner <> '') AND ("IC Direction" = "IC Direction"::Outgoing) THEN BEGIN
            IF ("Account Type" IN ["Account Type"::"G/L Account","Account Type"::"Bank Account"]) AND
               ("Bal. Account Type" IN ["Bal. Account Type"::"G/L Account","Account Type"::"Bank Account"]) AND
               ("Account No." <> '') AND
               ("Bal. Account No." <> '')
            THEN
              ERROR(Text030,FIELDCAPTION("Account No."),FIELDCAPTION("Bal. Account No."));
            IF (("Account Type" IN ["Account Type"::"G/L Account","Account Type"::"Bank Account"]) AND ("Account No." <> '')) XOR
               (("Bal. Account Type" IN ["Bal. Account Type"::"G/L Account","Account Type"::"Bank Account"]) AND
                ("Bal. Account No." <> ''))
            THEN
              TESTFIELD("IC Partner G/L Acc. No.")
            ELSE
              IF "IC Partner G/L Acc. No." <> '' THEN
                ERROR(Text031,
                  "Line No.",FIELDCAPTION("IC Partner G/L Acc. No."),FIELDCAPTION("Account No."),
                  FIELDCAPTION("Bal. Account No."));
          END ELSE
            TESTFIELD("IC Partner G/L Acc. No.",'');
        UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE UpdateIncomingDocument@15(VAR GenJnlLine@1000 : Record 81);
    VAR
      IncomingDocument@1001 : Record 130;
    BEGIN
      WITH GenJnlLine DO
        IncomingDocument.UpdateIncomingDocumentFromPosting("Incoming Document Entry No.","Posting Date","Document No.");
    END;

    LOCAL PROCEDURE CopyGenJnlLineBalancingData@18(VAR GenJnlLineTo@1000 : Record 81;VAR GenJnlLineFrom@1002 : Record 81);
    BEGIN
      GenJnlLineTo."Bill-to/Pay-to No." := GenJnlLineFrom."Bill-to/Pay-to No.";
      GenJnlLineTo."Ship-to/Order Address Code" := GenJnlLineFrom."Ship-to/Order Address Code";
      GenJnlLineTo."VAT Registration No." := GenJnlLineFrom."VAT Registration No.";
      GenJnlLineTo."Country/Region Code" := GenJnlLineFrom."Country/Region Code";
    END;

    LOCAL PROCEDURE CheckGenPostingType@19(GenJnlLine6@1000 : Record 81;AccountType@1001 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner');
    BEGIN
      IF (AccountType = AccountType::Customer) AND
         (GenJnlLine6."Gen. Posting Type" = GenJnlLine6."Gen. Posting Type"::Purchase) OR
         (AccountType = AccountType::Vendor) AND
         (GenJnlLine6."Gen. Posting Type" = GenJnlLine6."Gen. Posting Type"::Sale)
      THEN
        GenJnlLine6.FIELDERROR("Gen. Posting Type");
      IF (AccountType = AccountType::Customer) AND
         (GenJnlLine6."Bal. Gen. Posting Type" = GenJnlLine6."Bal. Gen. Posting Type"::Purchase) OR
         (AccountType = AccountType::Vendor) AND
         (GenJnlLine6."Bal. Gen. Posting Type" = GenJnlLine6."Bal. Gen. Posting Type"::Sale)
      THEN
        GenJnlLine6.FIELDERROR("Bal. Gen. Posting Type");
    END;

    LOCAL PROCEDURE CheckAndCopyBalancingData@16(VAR GenJnlLine4@1002 : Record 81;VAR GenJnlLine6@1001 : Record 81;VAR TempGenJnlLine@1004 : TEMPORARY Record 81;CheckBalAcount@1003 : Boolean);
    VAR
      TempGenJournalLineHistory@1006 : TEMPORARY Record 81;
      AccountType@1005 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
      CheckAmount@1000 : Decimal;
      JnlLineTotalQty@1007 : Integer;
      RefPostingSubState@1009 : 'Check account,Check bal. account,Update lines';
    BEGIN
      JnlLineTotalQty := GenJnlLine4.COUNT;
      LineCount := 0;
      IF CheckBalAcount THEN
        RefPostingSubState := RefPostingSubState::"Check bal. account"
      ELSE
        RefPostingSubState := RefPostingSubState::"Check account";
      IF GenJnlLine4.FINDSET THEN
        REPEAT
          TempGenJournalLineHistory := GenJnlLine4;
          IF NOT TempGenJournalLineHistory.FINDFIRST THEN BEGIN
            LineCount := LineCount + 1;
            UpdateDialogUpdateBalLines(RefPostingSubState,LineCount,JnlLineTotalQty);

            GenJnlLine6.SETRANGE("Posting Date",GenJnlLine4."Posting Date");
            GenJnlLine6.SETRANGE("Document No.",GenJnlLine4."Document No.");
            AccountType := GetPostingTypeFilter(GenJnlLine4,CheckBalAcount);
            CheckAmount := 0;
            IF GenJnlLine6.FINDSET THEN
              REPEAT
                IF (GenJnlLine6."Account No." = '') <> (GenJnlLine6."Bal. Account No." = '') THEN BEGIN
                  CheckGenPostingType(GenJnlLine6,AccountType);
                  TempGenJnlLine := GenJnlLine6;
                  CopyGenJnlLineBalancingData(TempGenJnlLine,GenJnlLine4);
                  IF TempGenJnlLine.INSERT THEN;
                  TempGenJournalLineHistory := GenJnlLine6;
                  TempGenJournalLineHistory.INSERT;
                  CheckAmount := CheckAmount + GenJnlLine6.Amount;
                END;
              UNTIL (GenJnlLine6.NEXT = 0) OR (-GenJnlLine4.Amount = CheckAmount);
          END;
        UNTIL GenJnlLine4.NEXT = 0;
    END;

    LOCAL PROCEDURE UpdateGenJnlLineWithVATInfo@26(VAR GenJournalLineFiltersSource@1005 : Record 81;GenJournalLineVATInfoSource@1000 : Record 81;StartLineNo@1003 : Integer;LastLineNo@1004 : Integer);
    VAR
      GenJournalLine@1001 : Record 81;
      Finish@1002 : Boolean;
    BEGIN
      WITH GenJournalLine DO BEGIN
        COPY(GenJournalLineFiltersSource);
        "Line No." := StartLineNo;
        Finish := FALSE;
        IF GET("Journal Template Name","Journal Batch Name","Line No.") THEN
          REPEAT
            IF "Line No." <> GenJournalLineVATInfoSource."Line No." THEN BEGIN
              "Bill-to/Pay-to No." := GenJournalLineVATInfoSource."Bill-to/Pay-to No.";
              "Country/Region Code" := GenJournalLineVATInfoSource."Country/Region Code";
              "VAT Registration No." := GenJournalLineVATInfoSource."VAT Registration No.";
              MODIFY;
            END;
            Finish := "Line No." = LastLineNo;
          UNTIL (NEXT = 0) OR Finish;
      END;
    END;

    LOCAL PROCEDURE GetPostingTypeFilter@17(VAR GenJnlLine4@1002 : Record 81;CheckBalAcount@1000 : Boolean) : Integer;
    BEGIN
      IF CheckBalAcount THEN
        EXIT(GenJnlLine4."Bal. Account Type");
      EXIT(GenJnlLine4."Account Type");
    END;

    LOCAL PROCEDURE UpdateDialog@23(PostingState@1000 : Integer;LineNo@1001 : Integer;TotalLinesQty@1002 : Integer);
    BEGIN
      UpdatePostingState(PostingState,LineNo);
      Window.UPDATE(2,GetProgressBarValue(PostingState,LineNo,TotalLinesQty));
    END;

    LOCAL PROCEDURE UpdateDialogUpdateBalLines@22(PostingSubState@1003 : Integer;LineNo@1001 : Integer;TotalLinesQty@1002 : Integer);
    BEGIN
      UpdatePostingState(RefPostingState::"Updating bal. lines",LineNo);
      Window.UPDATE(
        2,
        GetProgressBarUpdateBalLinesValue(
          CalcProgressPercent(PostingSubState,3,LineCount,TotalLinesQty)));
    END;

    LOCAL PROCEDURE UpdatePostingState@25(PostingState@1000 : Integer;LineNo@1002 : Integer);
    BEGIN
      Window.UPDATE(3,STRSUBSTNO('%1 (%2)',GetPostingStateMsg(PostingState),LineNo));
    END;

    LOCAL PROCEDURE UpdateCurrencyBalanceForRecurringLine@44(VAR GenJnlLine@1000 : Record 81);
    BEGIN
      WITH GenJnlLine DO BEGIN
        IF "Recurring Method" <> "Recurring Method"::" " THEN
          CALCFIELDS("Allocated Amt. (LCY)");
        IF ("Recurring Method" = "Recurring Method"::" ") OR ("Amount (LCY)" <> -"Allocated Amt. (LCY)") THEN
          IF "Currency Code" <> LastCurrencyCode THEN
            LastCurrencyCode := ''
          ELSE
            IF ("Currency Code" <> '') AND (("Account No." = '') XOR ("Bal. Account No." = '')) THEN
              IF "Account No." <> '' THEN
                CurrencyBalance := CurrencyBalance + Amount
              ELSE
                CurrencyBalance := CurrencyBalance - Amount;
      END;
    END;

    LOCAL PROCEDURE GetPostingStateMsg@29(PostingState@1000 : Integer) : Text;
    BEGIN
      CASE PostingState OF
        RefPostingState::"Checking lines":
          EXIT(CheckingLinesMsg);
        RefPostingState::"Checking balance":
          EXIT(CheckingBalanceMsg);
        RefPostingState::"Updating bal. lines":
          EXIT(UpdatingBalLinesMsg);
        RefPostingState::"Posting Lines":
          EXIT(PostingLinesMsg);
        RefPostingState::"Posting revers. lines":
          EXIT(PostingReversLinesMsg);
        RefPostingState::"Updating lines":
          EXIT(UpdatingLinesMsg);
      END;
    END;

    LOCAL PROCEDURE GetProgressBarValue@21(PostingState@1002 : Integer;LineNo@1001 : Integer;TotalLinesQty@1000 : Integer) : Integer;
    BEGIN
      EXIT(ROUND(100 * CalcProgressPercent(PostingState,GetNumberOfPostingStages,LineNo,TotalLinesQty),1));
    END;

    LOCAL PROCEDURE GetProgressBarUpdateBalLinesValue@34(PostingStatePercent@1000 : Decimal) : Integer;
    BEGIN
      EXIT(ROUND((RefPostingState::"Updating bal. lines" * 100 + PostingStatePercent) / GetNumberOfPostingStages * 100,1));
    END;

    LOCAL PROCEDURE CalcProgressPercent@20(PostingState@1001 : Integer;NumberOfPostingStates@1000 : Integer;LineNo@1002 : Integer;TotalLinesQty@1003 : Integer) : Decimal;
    BEGIN
      EXIT(100 / NumberOfPostingStates * (PostingState + LineNo / TotalLinesQty));
    END;

    LOCAL PROCEDURE GetNumberOfPostingStages@33() : Integer;
    BEGIN
      IF GenJnlTemplate.Recurring THEN
        EXIT(6);

      EXIT(4);
    END;

    LOCAL PROCEDURE FindNextGLRegisterNo@24();
    BEGIN
      GLReg.LOCKTABLE;
      IF GLReg.FINDLAST THEN
        GLRegNo := GLReg."No." + 1
      ELSE
        GLRegNo := 1;
    END;

    LOCAL PROCEDURE CheckGenJnlLineDates@36(VAR MarkedGenJnlLine@1001 : Record 81;VAR GenJournalLine@1000 : Record 81);
    BEGIN
      WITH GenJournalLine DO BEGIN
        IF NOT FIND THEN
          FINDSET;
        SETRANGE("Posting Date",0D,WORKDATE);
        IF FINDSET THEN BEGIN
          StartLineNo := "Line No.";
          REPEAT
            IF IsNotExpired(GenJournalLine) AND IsPostingDateAllowed(GenJournalLine) THEN BEGIN
              MarkedGenJnlLine := GenJournalLine;
              MarkedGenJnlLine.INSERT;
            END;
            IF NEXT = 0 THEN
              FINDFIRST;
          UNTIL "Line No." = StartLineNo
        END;
        MarkedGenJnlLine := GenJournalLine;
      END;
    END;

    LOCAL PROCEDURE IsNotExpired@50(GenJournalLine@1000 : Record 81) : Boolean;
    BEGIN
      EXIT((GenJournalLine."Expiration Date" = 0D) OR (GenJournalLine."Expiration Date" >= GenJournalLine."Posting Date"));
    END;

    LOCAL PROCEDURE IsPostingDateAllowed@48(GenJournalLine@1000 : Record 81) : Boolean;
    BEGIN
      EXIT(NOT GenJnlCheckLine.DateNotAllowed(GenJournalLine."Posting Date"));
    END;

    [External]
    PROCEDURE SetPreviewMode@27(NewPreviewMode@1000 : Boolean);
    BEGIN
      PreviewMode := NewPreviewMode;
    END;

    LOCAL PROCEDURE PostReversingLines@28(VAR TempGenJnlLine@1000 : TEMPORARY Record 81);
    VAR
      GenJournalLine1@1001 : Record 81;
      GenJournalLine2@1002 : Record 81;
    BEGIN
      LineCount := 0;
      LastDocNo := '';
      LastPostedDocNo := '';
      IF TempGenJnlLine.FIND('-') THEN
        REPEAT
          GenJournalLine1 := TempGenJnlLine;
          WITH GenJournalLine1 DO BEGIN
            LineCount := LineCount + 1;
            UpdateDialog(RefPostingState::"Posting revers. lines",LineCount,NoOfReversingRecords);
            CheckDocumentNo(GenJournalLine1);
            GenJournalLine2.COPY(GenJournalLine1);
            PrepareGenJnlLineAddCurr(GenJournalLine2);
            GenJnlPostLine.RunWithCheck(GenJournalLine2);
            PostAllocations(GenJournalLine1,TRUE);
          END;
        UNTIL TempGenJnlLine.NEXT = 0;
    END;

    LOCAL PROCEDURE UpdateAndDeleteLines@31(VAR GenJnlLine@1003 : Record 81);
    VAR
      TempGenJnlLine2@1002 : TEMPORARY Record 81;
      OldVATAmount@1000 : Decimal;
      OldVATPct@1001 : Decimal;
    BEGIN
      OnBeforeUpdateAndDeleteLines(GenJnlLine);

      ClearDataExchEntries(GenJnlLine);
      IF GenJnlTemplate.Recurring THEN BEGIN
        // Recurring journal
        LineCount := 0;
        GenJnlLine2.COPY(GenJnlLine);
        GenJnlLine2.SETCURRENTKEY("Journal Template Name","Journal Batch Name","Line No.");
        GenJnlLine2.FINDSET(TRUE,FALSE);
        REPEAT
          LineCount := LineCount + 1;
          UpdateDialog(RefPostingState::"Updating lines",LineCount,NoOfRecords);
          OldVATAmount := GenJnlLine2."VAT Amount";
          OldVATPct := GenJnlLine2."VAT %";
          IF GenJnlLine2."Posting Date" <> 0D THEN
            GenJnlLine2.VALIDATE(
              "Posting Date",CALCDATE(GenJnlLine2."Recurring Frequency",GenJnlLine2."Posting Date"));
          IF NOT
             (GenJnlLine2."Recurring Method" IN
              [GenJnlLine2."Recurring Method"::"F  Fixed",
               GenJnlLine2."Recurring Method"::"RF Reversing Fixed"])
          THEN
            MultiplyAmounts(GenJnlLine2,0)
          ELSE
            IF (GenJnlLine2."VAT %" = OldVATPct) AND (GenJnlLine2."VAT Amount" <> OldVATAmount) THEN
              GenJnlLine2.VALIDATE("VAT Amount",OldVATAmount);
          GenJnlLine2.MODIFY;
        UNTIL GenJnlLine2.NEXT = 0;
      END ELSE BEGIN
        // Not a recurring journal
        GenJnlLine2.COPY(GenJnlLine);
        GenJnlLine2.SETFILTER("Account No.",'<>%1','');
        IF GenJnlLine2.FINDLAST THEN; // Remember the last line
        GenJnlLine3.COPY(GenJnlLine);
        GenJnlLine3.SETCURRENTKEY("Journal Template Name","Journal Batch Name","Line No.");
        GenJnlLine3.DELETEALL;
        GenJnlLine3.RESET;
        GenJnlLine3.SETRANGE("Journal Template Name",GenJnlLine."Journal Template Name");
        GenJnlLine3.SETRANGE("Journal Batch Name",GenJnlLine."Journal Batch Name");
        IF NOT GenJnlLine3.FINDLAST THEN
          IF INCSTR(GenJnlLine."Journal Batch Name") <> '' THEN BEGIN
            GenJnlBatch.DELETE;
            IF GenJnlTemplate.Type = GenJnlTemplate.Type::Assets THEN
              FAJnlSetup.IncGenJnlBatchName(GenJnlBatch);
            GenJnlBatch.Name := INCSTR(GenJnlLine."Journal Batch Name");
            IF GenJnlBatch.INSERT THEN;
            GenJnlLine."Journal Batch Name" := GenJnlBatch.Name;
          END;

        GenJnlLine3.SETRANGE("Journal Batch Name",GenJnlLine."Journal Batch Name");
        IF (GenJnlBatch."No. Series" = '') AND NOT GenJnlLine3.FINDLAST THEN BEGIN
          GenJnlLine3.INIT;
          GenJnlLine3."Journal Template Name" := GenJnlLine."Journal Template Name";
          GenJnlLine3."Journal Batch Name" := GenJnlLine."Journal Batch Name";
          GenJnlLine3."Line No." := 10000;
          GenJnlLine3.INSERT;
          TempGenJnlLine2 := GenJnlLine2;
          TempGenJnlLine2."Balance (LCY)" := 0;
          GenJnlLine3.SetUpNewLine(TempGenJnlLine2,0,TRUE);
          GenJnlLine3.MODIFY;
        END;
      END;
    END;

    [Internal]
    PROCEDURE Preview@32(VAR GenJournalLine@1000 : Record 81);
    VAR
      GenJnlLine@1001 : Record 81;
    BEGIN
      PreviewMode := TRUE;
      GenJnlLine.COPY(GenJournalLine);
      Code(GenJnlLine);
    END;

    LOCAL PROCEDURE CheckRestrictions@35(VAR GenJournalLine@1000 : Record 81);
    BEGIN
      IF NOT PreviewMode THEN
        GenJournalLine.OnCheckGenJournalLinePostRestrictions;
    END;

    LOCAL PROCEDURE ClearDataExchEntries@37(VAR PassedGenJnlLine@1000 : Record 81);
    VAR
      GenJnlLine@1001 : Record 81;
    BEGIN
      GenJnlLine.COPY(PassedGenJnlLine);
      IF GenJnlLine.FINDSET THEN
        REPEAT
          GenJnlLine.ClearDataExchangeEntries(TRUE);
        UNTIL GenJnlLine.NEXT = 0;
    END;

    LOCAL PROCEDURE PostGenJournalLine@39(VAR GenJournalLine@1000 : Record 81;CurrentICPartner@1001 : Code[20];ICTransactionNo@1002 : Integer) : Boolean;
    BEGIN
      WITH GenJournalLine DO BEGIN
        IF NeedCheckZeroAmount AND (Amount = 0) AND IsRecurring THEN
          EXIT(FALSE);

        LineCount := LineCount + 1;
        IF CurrentICPartner <> '' THEN
          "IC Partner Code" := CurrentICPartner;
        UpdateDialog(RefPostingState::"Posting Lines",LineCount,NoOfRecords);
        MakeRecurringTexts(GenJournalLine);
        CheckDocumentNo(GenJournalLine);
        GenJnlLine5.COPY(GenJournalLine);
        PrepareGenJnlLineAddCurr(GenJnlLine5);
        UpdateIncomingDocument(GenJnlLine5);
        OnBeforePostGenJnlLine(GenJnlLine5);
        GenJnlPostLine.RunWithoutCheck(GenJnlLine5);
        OnAfterPostGenJnlLine(GenJnlLine5);
        IF (GenJnlTemplate.Type = GenJnlTemplate.Type::Intercompany) AND (CurrentICPartner <> '') AND
           ("IC Direction" = "IC Direction"::Outgoing) AND (ICTransactionNo > 0)
        THEN
          ICOutboxMgt.CreateOutboxJnlLine(ICTransactionNo,1,GenJnlLine5);
        IF ("Recurring Method" >= "Recurring Method"::"RF Reversing Fixed") AND ("Posting Date" <> 0D) THEN BEGIN
          "Posting Date" := "Posting Date" + 1;
          "Document Date" := "Posting Date";
          MultiplyAmounts(GenJournalLine,-1);
          TempGenJnlLine4 := GenJournalLine;
          TempGenJnlLine4."Reversing Entry" := TRUE;
          TempGenJnlLine4.INSERT;
          NoOfReversingRecords := NoOfReversingRecords + 1;
          "Posting Date" := "Posting Date" - 1;
          "Document Date" := "Posting Date";
        END;
        PostAllocations(GenJournalLine,FALSE);
      END;
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE CheckLine@38(VAR GenJnlLine@1000 : Record 81;VAR PostingAfterCurrentFiscalYearConfirmed@1002 : Boolean);
    BEGIN
      CheckRecurringLine(GenJnlLine);
      UpdateRecurringAmt(GenJnlLine);
      CheckAllocations(GenJnlLine);
      GenJnlLine5.COPY(GenJnlLine);
      IF NOT PostingAfterCurrentFiscalYearConfirmed THEN
        PostingAfterCurrentFiscalYearConfirmed :=
          PostingSetupMgt.ConfirmPostingAfterCurrentFiscalYear(
            ConfirmPostingAfterCurrentPeriodQst,GenJnlLine5."Posting Date");
      PrepareGenJnlLineAddCurr(GenJnlLine5);
      GenJnlCheckLine.RunCheck(GenJnlLine5);
      CheckRestrictions(GenJnlLine5);
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterPostGenJnlLine@41(VAR GenJournalLine@1000 : Record 81);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeCheckBalance@51(GenJnlTemplate@1000 : Record 80;GenJnlLine@1001 : Record 81;CurrentBalance@1002 : Decimal;CurrentBalanceReverse@1003 : Decimal;CurrencyBalance@1004 : Decimal;StartLineNo@1005 : Integer;StartLineNoReverse@1006 : Integer;LastDocType@1010 : Option;LastDocNo@1007 : Code[20];LastDate@1008 : Date;LastCurrencyCode@1009 : Code[10]);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeIfCheckBalance@54(GenJnlTemplate@1004 : Record 80;GenJnlLine@1003 : Record 81;LastDocType@1005 : Option;LastDocNo@1002 : Code[20];LastDate@1001 : Date;VAR CheckIfBalance@1000 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforePostGenJnlLine@40(VAR GenJournalLine@1000 : Record 81);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeUpdateAndDeleteLines@47(VAR GenJournalLine@1000 : Record 81);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterPostAllocations@46(GenJournalLine@1000 : Record 81;Reversing@1001 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterMultiplyAmounts@45(VAR GenJournalLine@1000 : Record 81;Factor@1001 : Decimal);
    BEGIN
    END;

    BEGIN
    END.
  }
}

