OBJECT Codeunit 12 Gen. Jnl.-Post Line
{
  OBJECT-PROPERTIES
  {
    Date=26-01-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20348,NAVDK11.00.00.20348;
  }
  PROPERTIES
  {
    TableNo=81;
    Permissions=TableData 17=imd,
                TableData 21=imd,
                TableData 25=imd,
                TableData 45=imd,
                TableData 253=rimd,
                TableData 254=imd,
                TableData 271=imd,
                TableData 272=imd,
                TableData 379=imd,
                TableData 380=imd,
                TableData 1053=rim,
                TableData 5222=imd,
                TableData 5223=imd,
                TableData 5601=rimd,
                TableData 5617=imd,
                TableData 5625=rimd;
    OnRun=BEGIN
            GetGLSetup;
            RunWithCheck(Rec);
          END;

  }
  CODE
  {
    VAR
      NeedsRoundingErr@1000 : TextConst 'DAN=%1 skal afrundes;ENU=%1 needs to be rounded';
      PurchaseAlreadyExistsErr@1003 : TextConst '@@@="%1 = Document Type; %2 = Document No.";DAN=K�b %1 %2 findes allerede for denne kreditor.;ENU=Purchase %1 %2 already exists for this vendor.';
      BankPaymentTypeMustNotBeFilledErr@1004 : TextConst 'DAN=Bankbetalingstype m� ikke udfyldes, hvis valutakoden er forskellig i Finanskladdelinje og Bankkonto.;ENU=Bank Payment Type must not be filled if Currency Code is different in Gen. Journal Line and Bank Account.';
      DocNoMustBeEnteredErr@1005 : TextConst 'DAN=Dokumentnr. skal angives, n�r Bankbetalingstype er %1.;ENU=Document No. must be entered when Bank Payment Type is %1.';
      CheckAlreadyExistsErr@1006 : TextConst 'DAN=Check %1 findes allerede til denne bankkonto.;ENU=Check %1 already exists for this Bank Account.';
      GLSetup@1009 : Record 98;
      GlobalGLEntry@1014 : Record 17;
      TempGLEntryBuf@1010 : TEMPORARY Record 17;
      TempGLEntryVAT@1016 : TEMPORARY Record 17;
      GLReg@1029 : Record 45;
      AddCurrency@1033 : Record 4;
      CurrExchRate@1035 : Record 330;
      VATEntry@1038 : Record 254;
      TaxDetail@1046 : Record 322;
      UnrealizedCustLedgEntry@1084 : Record 21;
      UnrealizedVendLedgEntry@1085 : Record 25;
      GLEntryVATEntryLink@1087 : Record 253;
      TempVATEntry@1088 : TEMPORARY Record 254;
      GenJnlCheckLine@1001 : Codeunit 11;
      PaymentToleranceMgt@1002 : Codeunit 426;
      DeferralUtilities@1031 : Codeunit 1720;
      DeferralDocType@1039 : 'Purchase,Sales,G/L';
      LastDocType@1025 : ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder';
      AddCurrencyCode@1117 : Code[10];
      GLSourceCode@1040 : Code[10];
      LastDocNo@1023 : Code[20];
      FiscalYearStartDate@1011 : Date;
      CurrencyDate@1020 : Date;
      LastDate@1021 : Date;
      BalanceCheckAmount@1056 : Decimal;
      BalanceCheckAmount2@1057 : Decimal;
      BalanceCheckAddCurrAmount@1058 : Decimal;
      BalanceCheckAddCurrAmount2@1059 : Decimal;
      CurrentBalance@1060 : Decimal;
      TotalAddCurrAmount@1062 : Decimal;
      TotalAmount@1063 : Decimal;
      UnrealizedRemainingAmountCust@1086 : Decimal;
      UnrealizedRemainingAmountVend@1074 : Decimal;
      AmountRoundingPrecision@1012 : Decimal;
      AddCurrGLEntryVATAmt@1017 : Decimal;
      CurrencyFactor@1019 : Decimal;
      FirstEntryNo@1042 : Integer;
      NextEntryNo@1022 : Integer;
      NextVATEntryNo@1064 : Integer;
      FirstNewVATEntryNo@1065 : Integer;
      FirstTransactionNo@1024 : Integer;
      NextTransactionNo@1066 : Integer;
      NextConnectionNo@1067 : Integer;
      NextCheckEntryNo@1028 : Integer;
      InsertedTempGLEntryVAT@1027 : Integer;
      GLEntryNo@1026 : Integer;
      UseCurrFactorOnly@1078 : Boolean;
      NonAddCurrCodeOccured@1079 : Boolean;
      FADimAlreadyChecked@1080 : Boolean;
      ResidualRoundingErr@1008 : TextConst 'DAN=Afrunding fra %1;ENU=Residual caused by rounding of %1';
      DimensionUsedErr@1007 : TextConst '@@@=Comment;DAN=En dimension, der bliver brugt i %1 %2, %3, %4, har for�rsaget en fejl. %5.;ENU=A dimension used in %1 %2, %3, %4 has caused an error. %5.';
      OverrideDimErr@1018 : Boolean;
      JobLine@1036 : Boolean;
      CheckUnrealizedCust@1082 : Boolean;
      CheckUnrealizedVend@1083 : Boolean;
      GLSetupRead@1015 : Boolean;
      InvalidPostingDateErr@1034 : TextConst '@@@="%1=The date passed in for the posting date.";DAN=%1 er ikke inden for intervallet af bogf�ringsdatoer for regnskabet.;ENU=%1 is not within the range of posting dates for your company.';
      DescriptionMustNotBeBlankErr@1030 : TextConst '@@@=%1: Field Omit Default Descr. in Jnl., %2 G/L Account No, %3 Description;DAN=N�r %1 er markeret for %2, skal %3 have en v�rdi.;ENU=When %1 is selected for %2, %3 must have a value.';
      NoDeferralScheduleErr@1037 : TextConst '@@@="%1=The line number of the general ledger transaction, %2=The Deferral Template Code";DAN=Du skal oprette en periodiseringsplan, hvis der er valgt en periodiseringsskabelon. Linje: %1, Periodiseringsskabelon: %2.;ENU=You must create a deferral schedule if a deferral template is selected. Line: %1, Deferral Template: %2.';
      ZeroDeferralAmtErr@1041 : TextConst '@@@="%1=The line number of the general ledger transaction, %2=The Deferral Template Code";DAN=Periodiseringsbel�b m� ikke v�re 0. Linje: %1, periodiseringsskabelon: %2.;ENU=Deferral amounts cannot be 0. Line: %1, Deferral Template: %2.';
      IsGLRegInserted@1013 : Boolean;

    [External]
    PROCEDURE GetGLReg@10(VAR NewGLReg@1000 : Record 45);
    BEGIN
      NewGLReg := GLReg;
    END;

    [External]
    PROCEDURE RunWithCheck@45(VAR GenJnlLine2@1000 : Record 81) : Integer;
    VAR
      GenJnlLine@1001 : Record 81;
    BEGIN
      GenJnlLine.COPY(GenJnlLine2);
      Code(GenJnlLine,TRUE);
      OnAfterRunWithCheck(GenJnlLine);
      GenJnlLine2 := GenJnlLine;
      EXIT(GLEntryNo);
    END;

    [Internal]
    PROCEDURE RunWithoutCheck@21(VAR GenJnlLine2@1000 : Record 81) : Integer;
    VAR
      GenJnlLine@1001 : Record 81;
    BEGIN
      GenJnlLine.COPY(GenJnlLine2);
      Code(GenJnlLine,FALSE);
      OnAfterRunWithoutCheck(GenJnlLine);
      GenJnlLine2 := GenJnlLine;
      EXIT(GLEntryNo);
    END;

    LOCAL PROCEDURE Code@9(VAR GenJnlLine@1003 : Record 81;CheckLine@1000 : Boolean);
    VAR
      Balancing@1002 : Boolean;
      IsTransactionConsistent@1001 : Boolean;
    BEGIN
      OnBeforeCode(GenJnlLine,CheckLine);

      GetGLSourceCode;

      WITH GenJnlLine DO BEGIN
        IF EmptyLine THEN BEGIN
          InitLastDocDate(GenJnlLine);
          EXIT;
        END;

        IF CheckLine THEN BEGIN
          IF OverrideDimErr THEN
            GenJnlCheckLine.SetOverDimErr;
          GenJnlCheckLine.RunCheck(GenJnlLine);
        END;

        AmountRoundingPrecision := InitAmounts(GenJnlLine);

        IF "Bill-to/Pay-to No." = '' THEN
          CASE TRUE OF
            "Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor]:
              "Bill-to/Pay-to No." := "Account No.";
            "Bal. Account Type" IN ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor]:
              "Bill-to/Pay-to No." := "Bal. Account No.";
          END;
        IF "Document Date" = 0D THEN
          "Document Date" := "Posting Date";
        IF "Due Date" = 0D THEN
          "Due Date" := "Posting Date";

        JobLine := ("Job No." <> '');

        IF NextEntryNo = 0 THEN
          StartPosting(GenJnlLine)
        ELSE
          ContinuePosting(GenJnlLine);

        IF "Account No." <> '' THEN BEGIN
          IF ("Bal. Account No." <> '') AND
             (NOT "System-Created Entry") AND
             ("Account Type" IN
              ["Account Type"::Customer,
               "Account Type"::Vendor,
               "Account Type"::"Fixed Asset"])
          THEN BEGIN
            CODEUNIT.RUN(CODEUNIT::"Exchange Acc. G/L Journal Line",GenJnlLine);
            Balancing := TRUE;
          END;

          PostGenJnlLine(GenJnlLine,Balancing);
        END;

        IF "Bal. Account No." <> '' THEN BEGIN
          CODEUNIT.RUN(CODEUNIT::"Exchange Acc. G/L Journal Line",GenJnlLine);
          PostGenJnlLine(GenJnlLine,NOT Balancing);
        END;

        CheckPostUnrealizedVAT(GenJnlLine,TRUE);

        CreateDeferralScheduleFromGL(GenJnlLine,Balancing);

        IsTransactionConsistent := FinishPosting;
      END;

      OnAfterGLFinishPosting(GlobalGLEntry,GenJnlLine,IsTransactionConsistent,FirstTransactionNo);
    END;

    LOCAL PROCEDURE PostGenJnlLine@47(VAR GenJnlLine@1000 : Record 81;Balancing@1001 : Boolean);
    BEGIN
      OnBeforePostGenJnlLine(GenJnlLine);

      WITH GenJnlLine DO
        CASE "Account Type" OF
          "Account Type"::"G/L Account":
            PostGLAcc(GenJnlLine,Balancing);
          "Account Type"::Customer:
            PostCust(GenJnlLine,Balancing);
          "Account Type"::Vendor:
            PostVend(GenJnlLine,Balancing);
          "Account Type"::Employee:
            PostEmployee(GenJnlLine);
          "Account Type"::"Bank Account":
            PostBankAcc(GenJnlLine,Balancing);
          "Account Type"::"Fixed Asset":
            PostFixedAsset(GenJnlLine);
          "Account Type"::"IC Partner":
            PostICPartner(GenJnlLine);
        END;
    END;

    LOCAL PROCEDURE InitAmounts@186(VAR GenJnlLine@1000 : Record 81) : Decimal;
    VAR
      Currency@1001 : Record 4;
    BEGIN
      WITH GenJnlLine DO BEGIN
        IF "Currency Code" = '' THEN BEGIN
          Currency.InitRoundingPrecision;
          "Amount (LCY)" := Amount;
          "VAT Amount (LCY)" := "VAT Amount";
          "VAT Base Amount (LCY)" := "VAT Base Amount";
        END ELSE BEGIN
          Currency.GET("Currency Code");
          Currency.TESTFIELD("Amount Rounding Precision");
          IF NOT "System-Created Entry" THEN BEGIN
            "Source Currency Code" := "Currency Code";
            "Source Currency Amount" := Amount;
            "Source Curr. VAT Base Amount" := "VAT Base Amount";
            "Source Curr. VAT Amount" := "VAT Amount";
          END;
        END;
        IF "Additional-Currency Posting" = "Additional-Currency Posting"::None THEN BEGIN
          IF Amount <> ROUND(Amount,Currency."Amount Rounding Precision") THEN
            FIELDERROR(
              Amount,
              STRSUBSTNO(NeedsRoundingErr,Amount));
          IF "Amount (LCY)" <> ROUND("Amount (LCY)") THEN
            FIELDERROR(
              "Amount (LCY)",
              STRSUBSTNO(NeedsRoundingErr,"Amount (LCY)"));
        END;
        EXIT(Currency."Amount Rounding Precision");
      END;
    END;

    LOCAL PROCEDURE InitLastDocDate@23(GenJnlLine@1000 : Record 81);
    BEGIN
      WITH GenJnlLine DO BEGIN
        LastDocType := "Document Type";
        LastDocNo := "Document No.";
        LastDate := "Posting Date";
      END;
    END;

    LOCAL PROCEDURE InitVAT@33(VAR GenJnlLine@1001 : Record 81;VAR GLEntry@1002 : Record 17;VAR VATPostingSetup@1003 : Record 325);
    VAR
      LCYCurrency@1000 : Record 4;
      SalesTaxCalculate@1004 : Codeunit 398;
    BEGIN
      LCYCurrency.InitRoundingPrecision;
      WITH GenJnlLine DO
        IF "Gen. Posting Type" <> 0 THEN BEGIN // None
          VATPostingSetup.GET("VAT Bus. Posting Group","VAT Prod. Posting Group");
          TESTFIELD("VAT Calculation Type",VATPostingSetup."VAT Calculation Type");
          CASE "VAT Posting" OF
            "VAT Posting"::"Automatic VAT Entry":
              BEGIN
                GLEntry.CopyPostingGroupsFromGenJnlLine(GenJnlLine);
                CASE "VAT Calculation Type" OF
                  "VAT Calculation Type"::"Normal VAT":
                    IF "VAT Difference" <> 0 THEN BEGIN
                      GLEntry.Amount := "VAT Base Amount (LCY)";
                      GLEntry."VAT Amount" := "Amount (LCY)" - GLEntry.Amount;
                      GLEntry."Additional-Currency Amount" := "Source Curr. VAT Base Amount";
                      IF "Source Currency Code" = AddCurrencyCode THEN
                        AddCurrGLEntryVATAmt := "Source Curr. VAT Amount"
                      ELSE
                        AddCurrGLEntryVATAmt := CalcLCYToAddCurr(GLEntry."VAT Amount");
                    END ELSE BEGIN
                      GLEntry."VAT Amount" :=
                        ROUND(
                          "Amount (LCY)" * VATPostingSetup."VAT %" / (100 + VATPostingSetup."VAT %"),
                          LCYCurrency."Amount Rounding Precision",LCYCurrency.VATRoundingDirection);
                      GLEntry.Amount := "Amount (LCY)" - GLEntry."VAT Amount";
                      IF "Source Currency Code" = AddCurrencyCode THEN
                        AddCurrGLEntryVATAmt :=
                          ROUND(
                            "Source Currency Amount" * VATPostingSetup."VAT %" / (100 + VATPostingSetup."VAT %"),
                            AddCurrency."Amount Rounding Precision",AddCurrency.VATRoundingDirection)
                      ELSE
                        AddCurrGLEntryVATAmt := CalcLCYToAddCurr(GLEntry."VAT Amount");
                      GLEntry."Additional-Currency Amount" := "Source Currency Amount" - AddCurrGLEntryVATAmt;
                    END;
                  "VAT Calculation Type"::"Reverse Charge VAT":
                    CASE "Gen. Posting Type" OF
                      "Gen. Posting Type"::Purchase:
                        IF "VAT Difference" <> 0 THEN BEGIN
                          GLEntry."VAT Amount" := "VAT Amount (LCY)";
                          IF "Source Currency Code" = AddCurrencyCode THEN
                            AddCurrGLEntryVATAmt := "Source Curr. VAT Amount"
                          ELSE
                            AddCurrGLEntryVATAmt := CalcLCYToAddCurr(GLEntry."VAT Amount");
                        END ELSE BEGIN
                          GLEntry."VAT Amount" :=
                            ROUND(
                              GLEntry.Amount * VATPostingSetup."VAT %" / 100,
                              LCYCurrency."Amount Rounding Precision",LCYCurrency.VATRoundingDirection);
                          IF "Source Currency Code" = AddCurrencyCode THEN
                            AddCurrGLEntryVATAmt :=
                              ROUND(
                                GLEntry."Additional-Currency Amount" * VATPostingSetup."VAT %" / 100,
                                AddCurrency."Amount Rounding Precision",AddCurrency.VATRoundingDirection)
                          ELSE
                            AddCurrGLEntryVATAmt := CalcLCYToAddCurr(GLEntry."VAT Amount");
                        END;
                      "Gen. Posting Type"::Sale:
                        BEGIN
                          GLEntry."VAT Amount" := 0;
                          AddCurrGLEntryVATAmt := 0;
                        END;
                    END;
                  "VAT Calculation Type"::"Full VAT":
                    BEGIN
                      CASE "Gen. Posting Type" OF
                        "Gen. Posting Type"::Sale:
                          TESTFIELD("Account No.",VATPostingSetup.GetSalesAccount(FALSE));
                        "Gen. Posting Type"::Purchase:
                          TESTFIELD("Account No.",VATPostingSetup.GetPurchAccount(FALSE));
                      END;
                      GLEntry.Amount := 0;
                      GLEntry."Additional-Currency Amount" := 0;
                      GLEntry."VAT Amount" := "Amount (LCY)";
                      IF "Source Currency Code" = AddCurrencyCode THEN
                        AddCurrGLEntryVATAmt := "Source Currency Amount"
                      ELSE
                        AddCurrGLEntryVATAmt := CalcLCYToAddCurr("Amount (LCY)");
                    END;
                  "VAT Calculation Type"::"Sales Tax":
                    BEGIN
                      IF ("Gen. Posting Type" = "Gen. Posting Type"::Purchase) AND
                         "Use Tax"
                      THEN BEGIN
                        GLEntry."VAT Amount" :=
                          ROUND(
                            SalesTaxCalculate.CalculateTax(
                              "Tax Area Code","Tax Group Code","Tax Liable",
                              "Posting Date","Amount (LCY)",Quantity,0));
                        GLEntry.Amount := "Amount (LCY)";
                      END ELSE BEGIN
                        GLEntry.Amount :=
                          ROUND(
                            SalesTaxCalculate.ReverseCalculateTax(
                              "Tax Area Code","Tax Group Code","Tax Liable",
                              "Posting Date","Amount (LCY)",Quantity,0));
                        GLEntry."VAT Amount" := "Amount (LCY)" - GLEntry.Amount;
                      END;
                      GLEntry."Additional-Currency Amount" := "Source Currency Amount";
                      IF "Source Currency Code" = AddCurrencyCode THEN
                        AddCurrGLEntryVATAmt := "Source Curr. VAT Amount"
                      ELSE
                        AddCurrGLEntryVATAmt := CalcLCYToAddCurr(GLEntry."VAT Amount");
                    END;
                END;
              END;
            "VAT Posting"::"Manual VAT Entry":
              IF "Gen. Posting Type" <> "Gen. Posting Type"::Settlement THEN BEGIN
                GLEntry.CopyPostingGroupsFromGenJnlLine(GenJnlLine);
                GLEntry."VAT Amount" := "VAT Amount (LCY)";
                IF "Source Currency Code" = AddCurrencyCode THEN
                  AddCurrGLEntryVATAmt := "Source Curr. VAT Amount"
                ELSE
                  AddCurrGLEntryVATAmt := CalcLCYToAddCurr("VAT Amount (LCY)");
              END;
          END;
        END;
      GLEntry."Additional-Currency Amount" :=
        GLCalcAddCurrency(GLEntry.Amount,GLEntry."Additional-Currency Amount",GLEntry."Additional-Currency Amount",TRUE,GenJnlLine);
    END;

    LOCAL PROCEDURE PostVAT@34(GenJnlLine@1010 : Record 81;VAR GLEntry@1015 : Record 17;VATPostingSetup@1012 : Record 325);
    VAR
      TaxDetail2@1008 : Record 322;
      SalesTaxCalculate@1013 : Codeunit 398;
      VATAmount@1000 : Decimal;
      VATAmount2@1003 : Decimal;
      VATBase@1001 : Decimal;
      VATBase2@1004 : Decimal;
      SrcCurrVATAmount@1002 : Decimal;
      SrcCurrVATBase@1009 : Decimal;
      SrcCurrSalesTaxBaseAmount@1005 : Decimal;
      RemSrcCurrVATAmount@1007 : Decimal;
      SalesTaxBaseAmount@1014 : Decimal;
      TaxDetailFound@1006 : Boolean;
    BEGIN
      WITH GenJnlLine DO
        // Post VAT
        // VAT for VAT entry
        CASE "VAT Calculation Type" OF
          "VAT Calculation Type"::"Normal VAT",
          "VAT Calculation Type"::"Reverse Charge VAT",
          "VAT Calculation Type"::"Full VAT":
            BEGIN
              IF "VAT Posting" = "VAT Posting"::"Automatic VAT Entry" THEN
                "VAT Base Amount (LCY)" := GLEntry.Amount;
              IF "Gen. Posting Type" = "Gen. Posting Type"::Settlement THEN
                AddCurrGLEntryVATAmt := "Source Curr. VAT Amount";
              InsertVAT(
                GenJnlLine,VATPostingSetup,
                GLEntry.Amount,GLEntry."VAT Amount","VAT Base Amount (LCY)","Source Currency Code",
                GLEntry."Additional-Currency Amount",AddCurrGLEntryVATAmt,"Source Curr. VAT Base Amount");
              NextConnectionNo := NextConnectionNo + 1;
            END;
          "VAT Calculation Type"::"Sales Tax":
            BEGIN
              CASE "VAT Posting" OF
                "VAT Posting"::"Automatic VAT Entry":
                  SalesTaxBaseAmount := GLEntry.Amount;
                "VAT Posting"::"Manual VAT Entry":
                  SalesTaxBaseAmount := "VAT Base Amount (LCY)";
              END;
              IF ("VAT Posting" = "VAT Posting"::"Manual VAT Entry") AND
                 ("Gen. Posting Type" = "Gen. Posting Type"::Settlement)
              THEN
                InsertVAT(
                  GenJnlLine,VATPostingSetup,
                  GLEntry.Amount,GLEntry."VAT Amount","VAT Base Amount (LCY)","Source Currency Code",
                  "Source Curr. VAT Base Amount","Source Curr. VAT Amount","Source Curr. VAT Base Amount")
              ELSE BEGIN
                CLEAR(SalesTaxCalculate);
                SalesTaxCalculate.InitSalesTaxLines(
                  "Tax Area Code","Tax Group Code","Tax Liable",
                  SalesTaxBaseAmount,Quantity,"Posting Date",GLEntry."VAT Amount");
                SrcCurrVATAmount := 0;
                SrcCurrSalesTaxBaseAmount := CalcLCYToAddCurr(SalesTaxBaseAmount);
                RemSrcCurrVATAmount := AddCurrGLEntryVATAmt;
                TaxDetailFound := FALSE;
                WHILE SalesTaxCalculate.GetSalesTaxLine(TaxDetail2,VATAmount,VATBase) DO BEGIN
                  RemSrcCurrVATAmount := RemSrcCurrVATAmount - SrcCurrVATAmount;
                  IF TaxDetailFound THEN
                    InsertVAT(
                      GenJnlLine,VATPostingSetup,
                      SalesTaxBaseAmount,VATAmount2,VATBase2,"Source Currency Code",
                      SrcCurrSalesTaxBaseAmount,SrcCurrVATAmount,SrcCurrVATBase);
                  TaxDetailFound := TRUE;
                  TaxDetail := TaxDetail2;
                  VATAmount2 := VATAmount;
                  VATBase2 := VATBase;
                  SrcCurrVATAmount := CalcLCYToAddCurr(VATAmount);
                  SrcCurrVATBase := CalcLCYToAddCurr(VATBase);
                END;
                IF TaxDetailFound THEN
                  InsertVAT(
                    GenJnlLine,VATPostingSetup,
                    SalesTaxBaseAmount,VATAmount2,VATBase2,"Source Currency Code",
                    SrcCurrSalesTaxBaseAmount,RemSrcCurrVATAmount,SrcCurrVATBase);
                InsertSummarizedVAT(GenJnlLine);
              END;
            END;
        END;
    END;

    LOCAL PROCEDURE InsertVAT@30(GenJnlLine@1015 : Record 81;VATPostingSetup@1018 : Record 325;GLEntryAmount@1000 : Decimal;GLEntryVATAmount@1001 : Decimal;GLEntryBaseAmount@1002 : Decimal;SrcCurrCode@1004 : Code[10];SrcCurrGLEntryAmt@1005 : Decimal;SrcCurrGLEntryVATAmt@1006 : Decimal;SrcCurrGLEntryBaseAmt@1007 : Decimal);
    VAR
      TaxJurisdiction@1003 : Record 320;
      VATAmount@1008 : Decimal;
      VATBase@1009 : Decimal;
      SrcCurrVATAmount@1011 : Decimal;
      SrcCurrVATBase@1012 : Decimal;
      VATDifferenceLCY@1013 : Decimal;
      SrcCurrVATDifference@1014 : Decimal;
      UnrealizedVAT@1019 : Boolean;
    BEGIN
      WITH GenJnlLine DO BEGIN
        // Post VAT
        // VAT for VAT entry
        VATEntry.INIT;
        VATEntry.CopyFromGenJnlLine(GenJnlLine);
        VATEntry."Entry No." := NextVATEntryNo;
        VATEntry."EU Service" := VATPostingSetup."EU Service";
        VATEntry."Transaction No." := NextTransactionNo;
        VATEntry."Sales Tax Connection No." := NextConnectionNo;

        IF "VAT Difference" = 0 THEN
          VATDifferenceLCY := 0
        ELSE
          IF "Currency Code" = '' THEN
            VATDifferenceLCY := "VAT Difference"
          ELSE
            VATDifferenceLCY :=
              ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  "Posting Date","Currency Code","VAT Difference",
                  CurrExchRate.ExchangeRate("Posting Date","Currency Code")));

        IF "VAT Calculation Type" = "VAT Calculation Type"::"Sales Tax" THEN BEGIN
          IF TaxDetail."Tax Jurisdiction Code" <> '' THEN
            TaxJurisdiction.GET(TaxDetail."Tax Jurisdiction Code");
          IF "Gen. Posting Type" <> "Gen. Posting Type"::Settlement THEN BEGIN
            VATEntry."Tax Group Used" := TaxDetail."Tax Group Code";
            VATEntry."Tax Type" := TaxDetail."Tax Type";
            VATEntry."Tax on Tax" := TaxDetail."Calculate Tax on Tax";
          END;
          VATEntry."Tax Jurisdiction Code" := TaxDetail."Tax Jurisdiction Code";
        END;

        IF AddCurrencyCode <> '' THEN
          IF AddCurrencyCode <> SrcCurrCode THEN BEGIN
            SrcCurrGLEntryAmt := ExchangeAmtLCYToFCY2(GLEntryAmount);
            SrcCurrGLEntryVATAmt := ExchangeAmtLCYToFCY2(GLEntryVATAmount);
            SrcCurrGLEntryBaseAmt := ExchangeAmtLCYToFCY2(GLEntryBaseAmount);
            SrcCurrVATDifference := ExchangeAmtLCYToFCY2(VATDifferenceLCY);
          END ELSE
            SrcCurrVATDifference := "VAT Difference";

        UnrealizedVAT :=
          (((VATPostingSetup."Unrealized VAT Type" > 0) AND
            (VATPostingSetup."VAT Calculation Type" IN
             [VATPostingSetup."VAT Calculation Type"::"Normal VAT",
              VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT",
              VATPostingSetup."VAT Calculation Type"::"Full VAT"])) OR
           ((TaxJurisdiction."Unrealized VAT Type" > 0) AND
            (VATPostingSetup."VAT Calculation Type" IN
             [VATPostingSetup."VAT Calculation Type"::"Sales Tax"]))) AND
          IsNotPayment("Document Type");
        IF GLSetup."Prepayment Unrealized VAT" AND NOT GLSetup."Unrealized VAT" AND
           (VATPostingSetup."Unrealized VAT Type" > 0)
        THEN
          UnrealizedVAT := Prepayment;

        // VAT for VAT entry
        IF "Gen. Posting Type" <> 0 THEN BEGIN
          CASE "VAT Posting" OF
            "VAT Posting"::"Automatic VAT Entry":
              BEGIN
                VATAmount := GLEntryVATAmount;
                VATBase := GLEntryBaseAmount;
                SrcCurrVATAmount := SrcCurrGLEntryVATAmt;
                SrcCurrVATBase := SrcCurrGLEntryBaseAmt;
              END;
            "VAT Posting"::"Manual VAT Entry":
              BEGIN
                IF "Gen. Posting Type" = "Gen. Posting Type"::Settlement THEN BEGIN
                  VATAmount := GLEntryAmount;
                  SrcCurrVATAmount := SrcCurrGLEntryVATAmt;
                  VATEntry.Closed := TRUE;
                END ELSE BEGIN
                  VATAmount := GLEntryVATAmount;
                  SrcCurrVATAmount := SrcCurrGLEntryVATAmt;
                END;
                VATBase := GLEntryBaseAmount;
                SrcCurrVATBase := SrcCurrGLEntryBaseAmt;
              END;
          END;

          IF UnrealizedVAT THEN BEGIN
            VATEntry.Amount := 0;
            VATEntry.Base := 0;
            VATEntry."Unrealized Amount" := VATAmount;
            VATEntry."Unrealized Base" := VATBase;
            VATEntry."Remaining Unrealized Amount" := VATEntry."Unrealized Amount";
            VATEntry."Remaining Unrealized Base" := VATEntry."Unrealized Base";
          END ELSE BEGIN
            VATEntry.Amount := VATAmount;
            VATEntry.Base := VATBase;
            VATEntry."Unrealized Amount" := 0;
            VATEntry."Unrealized Base" := 0;
            VATEntry."Remaining Unrealized Amount" := 0;
            VATEntry."Remaining Unrealized Base" := 0;
          END;

          IF AddCurrencyCode = '' THEN BEGIN
            VATEntry."Additional-Currency Base" := 0;
            VATEntry."Additional-Currency Amount" := 0;
            VATEntry."Add.-Currency Unrealized Amt." := 0;
            VATEntry."Add.-Currency Unrealized Base" := 0;
          END ELSE
            IF UnrealizedVAT THEN BEGIN
              VATEntry."Additional-Currency Base" := 0;
              VATEntry."Additional-Currency Amount" := 0;
              VATEntry."Add.-Currency Unrealized Base" := SrcCurrVATBase;
              VATEntry."Add.-Currency Unrealized Amt." := SrcCurrVATAmount;
            END ELSE BEGIN
              VATEntry."Additional-Currency Base" := SrcCurrVATBase;
              VATEntry."Additional-Currency Amount" := SrcCurrVATAmount;
              VATEntry."Add.-Currency Unrealized Base" := 0;
              VATEntry."Add.-Currency Unrealized Amt." := 0;
            END;
          VATEntry."Add.-Curr. Rem. Unreal. Amount" := VATEntry."Add.-Currency Unrealized Amt.";
          VATEntry."Add.-Curr. Rem. Unreal. Base" := VATEntry."Add.-Currency Unrealized Base";
          VATEntry."VAT Difference" := VATDifferenceLCY;
          VATEntry."Add.-Curr. VAT Difference" := SrcCurrVATDifference;

          VATEntry.INSERT(TRUE);
          GLEntryVATEntryLink.InsertLink(TempGLEntryBuf."Entry No.",VATEntry."Entry No.");
          NextVATEntryNo := NextVATEntryNo + 1;
        END;

        // VAT for G/L entry/entries
        IF (GLEntryVATAmount <> 0) OR
           ((SrcCurrGLEntryVATAmt <> 0) AND (SrcCurrCode = AddCurrencyCode))
        THEN
          CASE "Gen. Posting Type" OF
            "Gen. Posting Type"::Purchase:
              CASE VATPostingSetup."VAT Calculation Type" OF
                VATPostingSetup."VAT Calculation Type"::"Normal VAT",
                VATPostingSetup."VAT Calculation Type"::"Full VAT":
                  CreateGLEntry(GenJnlLine,VATPostingSetup.GetPurchAccount(UnrealizedVAT),
                    GLEntryVATAmount,SrcCurrGLEntryVATAmt,TRUE);
                VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT":
                  BEGIN
                    CreateGLEntry(GenJnlLine,VATPostingSetup.GetPurchAccount(UnrealizedVAT),
                      GLEntryVATAmount,SrcCurrGLEntryVATAmt,TRUE);
                    CreateGLEntry(GenJnlLine,VATPostingSetup.GetRevChargeAccount(UnrealizedVAT),
                      -GLEntryVATAmount,-SrcCurrGLEntryVATAmt,TRUE);
                  END;
                VATPostingSetup."VAT Calculation Type"::"Sales Tax":
                  IF "Use Tax" THEN BEGIN
                    InitGLEntryVAT(GenJnlLine,TaxJurisdiction.GetPurchAccount(UnrealizedVAT),'',
                      GLEntryVATAmount,SrcCurrGLEntryVATAmt,TRUE);
                    InitGLEntryVAT(GenJnlLine,TaxJurisdiction.GetRevChargeAccount(UnrealizedVAT),'',
                      -GLEntryVATAmount,-SrcCurrGLEntryVATAmt,TRUE);
                  END ELSE
                    InitGLEntryVAT(GenJnlLine,TaxJurisdiction.GetPurchAccount(UnrealizedVAT),'',
                      GLEntryVATAmount,SrcCurrGLEntryVATAmt,TRUE);
              END;
            "Gen. Posting Type"::Sale:
              CASE VATPostingSetup."VAT Calculation Type" OF
                VATPostingSetup."VAT Calculation Type"::"Normal VAT",
                VATPostingSetup."VAT Calculation Type"::"Full VAT":
                  CreateGLEntry(GenJnlLine,VATPostingSetup.GetSalesAccount(UnrealizedVAT),
                    GLEntryVATAmount,SrcCurrGLEntryVATAmt,TRUE);
                VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT":
                  ;
                VATPostingSetup."VAT Calculation Type"::"Sales Tax":
                  InitGLEntryVAT(GenJnlLine,TaxJurisdiction.GetSalesAccount(UnrealizedVAT),'',
                    GLEntryVATAmount,SrcCurrGLEntryVATAmt,TRUE);
              END;
          END;
      END;
    END;

    LOCAL PROCEDURE SummarizeVAT@31(SummarizeGLEntries@1000 : Boolean;GLEntry@1001 : Record 17);
    VAR
      InsertedTempVAT@1004 : Boolean;
    BEGIN
      InsertedTempVAT := FALSE;
      IF SummarizeGLEntries THEN
        IF TempGLEntryVAT.FINDSET THEN
          REPEAT
            IF (TempGLEntryVAT."G/L Account No." = GLEntry."G/L Account No.") AND
               (TempGLEntryVAT."Bal. Account No." = GLEntry."Bal. Account No.")
            THEN BEGIN
              TempGLEntryVAT.Amount := TempGLEntryVAT.Amount + GLEntry.Amount;
              TempGLEntryVAT."Additional-Currency Amount" :=
                TempGLEntryVAT."Additional-Currency Amount" + GLEntry."Additional-Currency Amount";
              TempGLEntryVAT.MODIFY;
              InsertedTempVAT := TRUE;
            END;
          UNTIL (TempGLEntryVAT.NEXT = 0) OR InsertedTempVAT;
      IF NOT InsertedTempVAT OR NOT SummarizeGLEntries THEN BEGIN
        TempGLEntryVAT := GLEntry;
        TempGLEntryVAT."Entry No." :=
          TempGLEntryVAT."Entry No." + InsertedTempGLEntryVAT;
        TempGLEntryVAT.INSERT;
        InsertedTempGLEntryVAT := InsertedTempGLEntryVAT + 1;
      END;
    END;

    LOCAL PROCEDURE InsertSummarizedVAT@37(GenJnlLine@1000 : Record 81);
    BEGIN
      IF TempGLEntryVAT.FINDSET THEN BEGIN
        REPEAT
          InsertGLEntry(GenJnlLine,TempGLEntryVAT,TRUE);
        UNTIL TempGLEntryVAT.NEXT = 0;
        TempGLEntryVAT.DELETEALL;
        InsertedTempGLEntryVAT := 0;
      END;
      NextConnectionNo := NextConnectionNo + 1;
    END;

    LOCAL PROCEDURE PostGLAcc@11(GenJnlLine@1001 : Record 81;Balancing@1004 : Boolean);
    VAR
      GLAcc@1000 : Record 15;
      GLEntry@1002 : Record 17;
      VATPostingSetup@1003 : Record 325;
    BEGIN
      WITH GenJnlLine DO BEGIN
        GLAcc.GET("Account No.");
        // G/L entry
        InitGLEntry(GenJnlLine,GLEntry,
          "Account No.","Amount (LCY)",
          "Source Currency Amount",TRUE,"System-Created Entry");
        IF NOT "System-Created Entry" THEN
          IF "Posting Date" = NORMALDATE("Posting Date") THEN
            GLAcc.TESTFIELD("Direct Posting",TRUE);
        IF GLAcc."Omit Default Descr. in Jnl." THEN
          IF DELCHR(Description,'=',' ') = '' THEN
            ERROR(
              DescriptionMustNotBeBlankErr,
              GLAcc.FIELDCAPTION("Omit Default Descr. in Jnl."),
              GLAcc."No.",
              FIELDCAPTION(Description));
        GLEntry."Gen. Posting Type" := "Gen. Posting Type";
        GLEntry."Bal. Account Type" := "Bal. Account Type";
        GLEntry."Bal. Account No." := "Bal. Account No.";
        GLEntry."No. Series" := "Posting No. Series";
        IF "Additional-Currency Posting" =
           "Additional-Currency Posting"::"Additional-Currency Amount Only"
        THEN BEGIN
          GLEntry."Additional-Currency Amount" := Amount;
          GLEntry.Amount := 0;
        END;
        // Store Entry No. to global variable for return:
        GLEntryNo := GLEntry."Entry No.";
        InitVAT(GenJnlLine,GLEntry,VATPostingSetup);
        InsertGLEntry(GenJnlLine,GLEntry,TRUE);
        PostJob(GenJnlLine,GLEntry);
        PostVAT(GenJnlLine,GLEntry,VATPostingSetup);
        DeferralPosting("Deferral Code","Source Code","Account No.",GenJnlLine,Balancing);
        OnMoveGenJournalLine(GLEntry.RECORDID);
      END;

      OnAfterPostGLAcc(GenJnlLine);
    END;

    LOCAL PROCEDURE PostCust@12(VAR GenJnlLine@1007 : Record 81;Balancing@1010 : Boolean);
    VAR
      LineFeeNoteOnReportHist@1008 : Record 1053;
      Cust@1005 : Record 18;
      CustPostingGr@1006 : Record 92;
      CustLedgEntry@1000 : Record 21;
      CVLedgEntryBuf@1002 : Record 382;
      TempDtldCVLedgEntryBuf@1003 : TEMPORARY Record 383;
      DtldCustLedgEntry@1004 : Record 379;
      ReceivablesAccount@1009 : Code[20];
      DtldLedgEntryInserted@1001 : Boolean;
    BEGIN
      WITH GenJnlLine DO BEGIN
        Cust.GET("Account No.");
        Cust.CheckBlockedCustOnJnls(Cust,"Document Type",TRUE);

        IF "Posting Group" = '' THEN BEGIN
          Cust.TESTFIELD("Customer Posting Group");
          "Posting Group" := Cust."Customer Posting Group";
        END;
        CustPostingGr.GET("Posting Group");
        ReceivablesAccount := CustPostingGr.GetReceivablesAccount;

        DtldCustLedgEntry.LOCKTABLE;
        CustLedgEntry.LOCKTABLE;

        InitCustLedgEntry(GenJnlLine,CustLedgEntry);

        IF NOT Cust."Block Payment Tolerance" THEN
          CalcPmtTolerancePossible(
            GenJnlLine,CustLedgEntry."Pmt. Discount Date",CustLedgEntry."Pmt. Disc. Tolerance Date",
            CustLedgEntry."Max. Payment Tolerance");

        TempDtldCVLedgEntryBuf.DELETEALL;
        TempDtldCVLedgEntryBuf.INIT;
        TempDtldCVLedgEntryBuf.CopyFromGenJnlLine(GenJnlLine);
        TempDtldCVLedgEntryBuf."CV Ledger Entry No." := CustLedgEntry."Entry No.";
        CVLedgEntryBuf.CopyFromCustLedgEntry(CustLedgEntry);
        TempDtldCVLedgEntryBuf.InsertDtldCVLedgEntry(TempDtldCVLedgEntryBuf,CVLedgEntryBuf,TRUE);
        CVLedgEntryBuf.Open := CVLedgEntryBuf."Remaining Amount" <> 0;
        CVLedgEntryBuf.Positive := CVLedgEntryBuf."Remaining Amount" > 0;

        CalcPmtDiscPossible(GenJnlLine,CVLedgEntryBuf);

        IF "Currency Code" <> '' THEN BEGIN
          TESTFIELD("Currency Factor");
          CVLedgEntryBuf."Original Currency Factor" := "Currency Factor"
        END ELSE
          CVLedgEntryBuf."Original Currency Factor" := 1;
        CVLedgEntryBuf."Adjusted Currency Factor" := CVLedgEntryBuf."Original Currency Factor";

        // Check the document no.
        IF "Recurring Method" = 0 THEN
          IF IsNotPayment("Document Type") THEN BEGIN
            GenJnlCheckLine.CheckSalesDocNoIsNotUsed("Document Type","Document No.");
            CheckSalesExtDocNo(GenJnlLine);
          END;

        // Post application
        ApplyCustLedgEntry(CVLedgEntryBuf,TempDtldCVLedgEntryBuf,GenJnlLine,Cust);

        // Post customer entry
        CustLedgEntry.CopyFromCVLedgEntryBuffer(CVLedgEntryBuf);
        CustLedgEntry."Amount to Apply" := 0;
        CustLedgEntry."Applies-to Doc. No." := '';
        CustLedgEntry.INSERT(TRUE);

        // Post detailed customer entries
        DtldLedgEntryInserted := PostDtldCustLedgEntries(GenJnlLine,TempDtldCVLedgEntryBuf,CustPostingGr,TRUE);

        // Post Reminder Terms - Note About Line Fee on Report
        LineFeeNoteOnReportHist.Save(CustLedgEntry);

        IF DtldLedgEntryInserted THEN
          IF IsTempGLEntryBufEmpty THEN
            DtldCustLedgEntry.SetZeroTransNo(NextTransactionNo);

        DeferralPosting("Deferral Code","Source Code",ReceivablesAccount,GenJnlLine,Balancing);
        OnMoveGenJournalLine(CustLedgEntry.RECORDID);
      END;
    END;

    LOCAL PROCEDURE PostVend@13(GenJnlLine@1007 : Record 81;Balancing@1009 : Boolean);
    VAR
      Vend@1005 : Record 23;
      VendPostingGr@1006 : Record 93;
      VendLedgEntry@1000 : Record 25;
      CVLedgEntryBuf@1002 : Record 382;
      TempDtldCVLedgEntryBuf@1003 : TEMPORARY Record 383;
      DtldVendLedgEntry@1004 : Record 380;
      PayablesAccount@1008 : Code[20];
      DtldLedgEntryInserted@1001 : Boolean;
      CheckExtDocNoHandled@1010 : Boolean;
    BEGIN
      WITH GenJnlLine DO BEGIN
        Vend.GET("Account No.");
        Vend.CheckBlockedVendOnJnls(Vend,"Document Type",TRUE);

        IF "Posting Group" = '' THEN BEGIN
          Vend.TESTFIELD("Vendor Posting Group");
          "Posting Group" := Vend."Vendor Posting Group";
        END;
        VendPostingGr.GET("Posting Group");
        PayablesAccount := VendPostingGr.GetPayablesAccount;

        DtldVendLedgEntry.LOCKTABLE;
        VendLedgEntry.LOCKTABLE;

        InitVendLedgEntry(GenJnlLine,VendLedgEntry);

        IF NOT Vend."Block Payment Tolerance" THEN
          CalcPmtTolerancePossible(
            GenJnlLine,VendLedgEntry."Pmt. Discount Date",VendLedgEntry."Pmt. Disc. Tolerance Date",
            VendLedgEntry."Max. Payment Tolerance");

        TempDtldCVLedgEntryBuf.DELETEALL;
        TempDtldCVLedgEntryBuf.INIT;
        TempDtldCVLedgEntryBuf.CopyFromGenJnlLine(GenJnlLine);
        TempDtldCVLedgEntryBuf."CV Ledger Entry No." := VendLedgEntry."Entry No.";
        CVLedgEntryBuf.CopyFromVendLedgEntry(VendLedgEntry);
        TempDtldCVLedgEntryBuf.InsertDtldCVLedgEntry(TempDtldCVLedgEntryBuf,CVLedgEntryBuf,TRUE);
        CVLedgEntryBuf.Open := CVLedgEntryBuf."Remaining Amount" <> 0;
        CVLedgEntryBuf.Positive := CVLedgEntryBuf."Remaining Amount" > 0;

        CalcPmtDiscPossible(GenJnlLine,CVLedgEntryBuf);

        IF "Currency Code" <> '' THEN BEGIN
          TESTFIELD("Currency Factor");
          CVLedgEntryBuf."Adjusted Currency Factor" := "Currency Factor"
        END ELSE
          CVLedgEntryBuf."Adjusted Currency Factor" := 1;
        CVLedgEntryBuf."Original Currency Factor" := CVLedgEntryBuf."Adjusted Currency Factor";

        // Check the document no.
        IF "Recurring Method" = 0 THEN
          IF IsNotPayment("Document Type") THEN BEGIN
            GenJnlCheckLine.CheckPurchDocNoIsNotUsed("Document Type","Document No.");
            OnBeforeCheckPurchExtDocNo(GenJnlLine,VendLedgEntry,CVLedgEntryBuf,CheckExtDocNoHandled);
            IF NOT CheckExtDocNoHandled THEN
              CheckPurchExtDocNo(GenJnlLine);
          END;

        // Post application
        ApplyVendLedgEntry(CVLedgEntryBuf,TempDtldCVLedgEntryBuf,GenJnlLine,Vend);

        // Post vendor entry
        VendLedgEntry.CopyFromCVLedgEntryBuffer(CVLedgEntryBuf);
        VendLedgEntry."Amount to Apply" := 0;
        VendLedgEntry."Applies-to Doc. No." := '';
        VendLedgEntry.INSERT(TRUE);

        // Post detailed vendor entries
        DtldLedgEntryInserted := PostDtldVendLedgEntries(GenJnlLine,TempDtldCVLedgEntryBuf,VendPostingGr,TRUE);

        IF DtldLedgEntryInserted THEN
          IF IsTempGLEntryBufEmpty THEN
            DtldVendLedgEntry.SetZeroTransNo(NextTransactionNo);
        DeferralPosting("Deferral Code","Source Code",PayablesAccount,GenJnlLine,Balancing);
        OnMoveGenJournalLine(VendLedgEntry.RECORDID);
      END;
    END;

    LOCAL PROCEDURE PostEmployee@86(GenJnlLine@1007 : Record 81);
    VAR
      Employee@1005 : Record 5200;
      EmployeePostingGr@1006 : Record 5221;
      EmployeeLedgerEntry@1000 : Record 5222;
      CVLedgEntryBuf@1008 : Record 382;
      TempDtldCVLedgEntryBuf@1004 : TEMPORARY Record 383;
      DtldEmplLedgEntry@1001 : Record 5223;
      DtldLedgEntryInserted@1010 : Boolean;
    BEGIN
      WITH GenJnlLine DO BEGIN
        Employee.GET("Account No.");

        IF "Posting Group" = '' THEN BEGIN
          Employee.TESTFIELD("Employee Posting Group");
          "Posting Group" := Employee."Employee Posting Group";
        END;
        EmployeePostingGr.GET("Posting Group");

        DtldEmplLedgEntry.LOCKTABLE;
        EmployeeLedgerEntry.LOCKTABLE;

        InitEmployeeLedgerEntry(GenJnlLine,EmployeeLedgerEntry);

        TempDtldCVLedgEntryBuf.DELETEALL;
        TempDtldCVLedgEntryBuf.INIT;
        TempDtldCVLedgEntryBuf.CopyFromGenJnlLine(GenJnlLine);
        TempDtldCVLedgEntryBuf."CV Ledger Entry No." := EmployeeLedgerEntry."Entry No.";
        CVLedgEntryBuf.CopyFromEmplLedgEntry(EmployeeLedgerEntry);
        TempDtldCVLedgEntryBuf.InsertDtldCVLedgEntry(TempDtldCVLedgEntryBuf,CVLedgEntryBuf,TRUE);
        CVLedgEntryBuf.Open := CVLedgEntryBuf."Remaining Amount" <> 0;
        CVLedgEntryBuf.Positive := CVLedgEntryBuf."Remaining Amount" > 0;

        // Post application
        ApplyEmplLedgEntry(CVLedgEntryBuf,TempDtldCVLedgEntryBuf,GenJnlLine,Employee);

        // Post vendor entry
        EmployeeLedgerEntry.CopyFromCVLedgEntryBuffer(CVLedgEntryBuf);
        EmployeeLedgerEntry."Amount to Apply" := 0;
        EmployeeLedgerEntry."Applies-to Doc. No." := '';
        EmployeeLedgerEntry.INSERT(TRUE);

        // Post detailed employee entries
        DtldLedgEntryInserted := PostDtldEmplLedgEntries(GenJnlLine,TempDtldCVLedgEntryBuf,EmployeePostingGr,TRUE);

        // Posting GL Entry
        IF DtldLedgEntryInserted THEN
          IF IsTempGLEntryBufEmpty THEN
            DtldEmplLedgEntry.SetZeroTransNo(NextTransactionNo);

        OnMoveGenJournalLine(EmployeeLedgerEntry.RECORDID);
      END;
    END;

    LOCAL PROCEDURE PostBankAcc@14(GenJnlLine@1005 : Record 81;Balancing@1006 : Boolean);
    VAR
      BankAcc@1000 : Record 270;
      BankAccLedgEntry@1004 : Record 271;
      CheckLedgEntry@1003 : Record 272;
      CheckLedgEntry2@1002 : Record 272;
      BankAccPostingGr@1001 : Record 277;
    BEGIN
      WITH GenJnlLine DO BEGIN
        BankAcc.GET("Account No.");
        BankAcc.TESTFIELD(Blocked,FALSE);
        IF "Currency Code" = '' THEN
          BankAcc.TESTFIELD("Currency Code",'')
        ELSE
          IF BankAcc."Currency Code" <> '' THEN
            TESTFIELD("Currency Code",BankAcc."Currency Code");

        BankAcc.TESTFIELD("Bank Acc. Posting Group");
        BankAccPostingGr.GET(BankAcc."Bank Acc. Posting Group");

        BankAccLedgEntry.LOCKTABLE;

        InitBankAccLedgEntry(GenJnlLine,BankAccLedgEntry);

        BankAccLedgEntry."Bank Acc. Posting Group" := BankAcc."Bank Acc. Posting Group";
        BankAccLedgEntry."Currency Code" := BankAcc."Currency Code";
        IF BankAcc."Currency Code" <> '' THEN
          BankAccLedgEntry.Amount := Amount
        ELSE
          BankAccLedgEntry.Amount := "Amount (LCY)";
        BankAccLedgEntry."Amount (LCY)" := "Amount (LCY)";
        BankAccLedgEntry.Open := Amount <> 0;
        BankAccLedgEntry."Remaining Amount" := BankAccLedgEntry.Amount;
        BankAccLedgEntry.Positive := Amount > 0;
        BankAccLedgEntry.UpdateDebitCredit(Correction);
        BankAccLedgEntry.INSERT(TRUE);

        IF ((Amount <= 0) AND ("Bank Payment Type" = "Bank Payment Type"::"Computer Check") AND "Check Printed") OR
           ((Amount < 0) AND ("Bank Payment Type" = "Bank Payment Type"::"Manual Check"))
        THEN BEGIN
          IF BankAcc."Currency Code" <> "Currency Code" THEN
            ERROR(BankPaymentTypeMustNotBeFilledErr);
          CASE "Bank Payment Type" OF
            "Bank Payment Type"::"Computer Check":
              BEGIN
                TESTFIELD("Check Printed",TRUE);
                CheckLedgEntry.LOCKTABLE;
                CheckLedgEntry.RESET;
                CheckLedgEntry.SETCURRENTKEY("Bank Account No.","Entry Status","Check No.");
                CheckLedgEntry.SETRANGE("Bank Account No.","Account No.");
                CheckLedgEntry.SETRANGE("Entry Status",CheckLedgEntry."Entry Status"::Printed);
                CheckLedgEntry.SETRANGE("Check No.","Document No.");
                IF CheckLedgEntry.FINDSET THEN
                  REPEAT
                    CheckLedgEntry2 := CheckLedgEntry;
                    CheckLedgEntry2."Entry Status" := CheckLedgEntry2."Entry Status"::Posted;
                    CheckLedgEntry2."Bank Account Ledger Entry No." := BankAccLedgEntry."Entry No.";
                    CheckLedgEntry2.MODIFY;
                  UNTIL CheckLedgEntry.NEXT = 0;
              END;
            "Bank Payment Type"::"Manual Check":
              BEGIN
                IF "Document No." = '' THEN
                  ERROR(DocNoMustBeEnteredErr,"Bank Payment Type");
                CheckLedgEntry.RESET;
                IF NextCheckEntryNo = 0 THEN BEGIN
                  CheckLedgEntry.LOCKTABLE;
                  IF CheckLedgEntry.FINDLAST THEN
                    NextCheckEntryNo := CheckLedgEntry."Entry No." + 1
                  ELSE
                    NextCheckEntryNo := 1;
                END;

                CheckLedgEntry.SETRANGE("Bank Account No.","Account No.");
                CheckLedgEntry.SETFILTER(
                  "Entry Status",'%1|%2|%3',
                  CheckLedgEntry."Entry Status"::Printed,
                  CheckLedgEntry."Entry Status"::Posted,
                  CheckLedgEntry."Entry Status"::"Financially Voided");
                CheckLedgEntry.SETRANGE("Check No.","Document No.");
                IF NOT CheckLedgEntry.ISEMPTY THEN
                  ERROR(CheckAlreadyExistsErr,"Document No.");

                InitCheckLedgEntry(BankAccLedgEntry,CheckLedgEntry);
                CheckLedgEntry."Bank Payment Type" := CheckLedgEntry."Bank Payment Type"::"Manual Check";
                IF BankAcc."Currency Code" <> '' THEN
                  CheckLedgEntry.Amount := -Amount
                ELSE
                  CheckLedgEntry.Amount := -"Amount (LCY)";
                CheckLedgEntry.INSERT(TRUE);
                NextCheckEntryNo := NextCheckEntryNo + 1;
              END;
          END;
        END;

        BankAccPostingGr.TESTFIELD("G/L Bank Account No.");
        CreateGLEntryBalAcc(
          GenJnlLine,BankAccPostingGr."G/L Bank Account No.","Amount (LCY)","Source Currency Amount",
          "Bal. Account Type","Bal. Account No.");
        DeferralPosting("Deferral Code","Source Code",BankAccPostingGr."G/L Bank Account No.",GenJnlLine,Balancing);
        OnMoveGenJournalLine(BankAccLedgEntry.RECORDID);
      END;
    END;

    LOCAL PROCEDURE PostFixedAsset@29(GenJnlLine@1009 : Record 81);
    VAR
      GLEntry@1010 : Record 17;
      GLEntry2@1000 : Record 17;
      TempFAGLPostBuf@1001 : TEMPORARY Record 5637;
      FAGLPostBuf@1011 : Record 5637;
      VATPostingSetup@1012 : Record 325;
      FAJnlPostLine@1013 : Codeunit 5632;
      FAAutomaticEntry@1003 : Codeunit 5607;
      ShortcutDim1Code@1004 : Code[20];
      ShortcutDim2Code@1005 : Code[20];
      Correction2@1006 : Boolean;
      NetDisposalNo@1007 : Integer;
      DimensionSetID@1008 : Integer;
      VATEntryGLEntryNo@1002 : Integer;
    BEGIN
      WITH GenJnlLine DO BEGIN
        InitGLEntry(GenJnlLine,GLEntry,'',"Amount (LCY)","Source Currency Amount",TRUE,"System-Created Entry");
        GLEntry."Gen. Posting Type" := "Gen. Posting Type";
        GLEntry."Bal. Account Type" := "Bal. Account Type";
        GLEntry."Bal. Account No." := "Bal. Account No.";
        InitVAT(GenJnlLine,GLEntry,VATPostingSetup);
        GLEntry2 := GLEntry;
        FAJnlPostLine.GenJnlPostLine(
          GenJnlLine,GLEntry2.Amount,GLEntry2."VAT Amount",NextTransactionNo,NextEntryNo,GLReg."No.");
        ShortcutDim1Code := "Shortcut Dimension 1 Code";
        ShortcutDim2Code := "Shortcut Dimension 2 Code";
        DimensionSetID := "Dimension Set ID";
        Correction2 := Correction;
      END;
      WITH TempFAGLPostBuf DO
        IF FAJnlPostLine.FindFirstGLAcc(TempFAGLPostBuf) THEN
          REPEAT
            GenJnlLine."Shortcut Dimension 1 Code" := "Global Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code" := "Global Dimension 2 Code";
            GenJnlLine."Dimension Set ID" := "Dimension Set ID";
            GenJnlLine.Correction := Correction;
            FADimAlreadyChecked := "FA Posting Group" <> '';
            CheckDimValueForDisposal(GenJnlLine,"Account No.");
            IF "Original General Journal Line" THEN
              InitGLEntry(GenJnlLine,GLEntry,"Account No.",Amount,GLEntry2."Additional-Currency Amount",TRUE,TRUE)
            ELSE BEGIN
              CheckNonAddCurrCodeOccurred('');
              InitGLEntry(GenJnlLine,GLEntry,"Account No.",Amount,0,FALSE,TRUE);
            END;
            FADimAlreadyChecked := FALSE;
            GLEntry.CopyPostingGroupsFromGLEntry(GLEntry2);
            GLEntry."VAT Amount" := GLEntry2."VAT Amount";
            GLEntry."Bal. Account Type" := GLEntry2."Bal. Account Type";
            GLEntry."Bal. Account No." := GLEntry2."Bal. Account No.";
            GLEntry."FA Entry Type" := "FA Entry Type";
            GLEntry."FA Entry No." := "FA Entry No.";
            IF "Net Disposal" THEN
              NetDisposalNo := NetDisposalNo + 1
            ELSE
              NetDisposalNo := 0;
            IF "Automatic Entry" AND NOT "Net Disposal" THEN
              FAAutomaticEntry.AdjustGLEntry(GLEntry);
            IF NetDisposalNo > 1 THEN
              GLEntry."VAT Amount" := 0;
            IF "FA Posting Group" <> '' THEN BEGIN
              FAGLPostBuf := TempFAGLPostBuf;
              FAGLPostBuf."Entry No." := NextEntryNo;
              FAGLPostBuf.INSERT;
            END;
            InsertGLEntry(GenJnlLine,GLEntry,TRUE);
            IF (VATEntryGLEntryNo = 0) AND (GLEntry."Gen. Posting Type" <> GLEntry."Gen. Posting Type"::" ") THEN
              VATEntryGLEntryNo := GLEntry."Entry No.";
          UNTIL FAJnlPostLine.GetNextGLAcc(TempFAGLPostBuf) = 0;
      GenJnlLine."Shortcut Dimension 1 Code" := ShortcutDim1Code;
      GenJnlLine."Shortcut Dimension 2 Code" := ShortcutDim2Code;
      GenJnlLine."Dimension Set ID" := DimensionSetID;
      GenJnlLine.Correction := Correction2;
      GLEntry := GLEntry2;
      IF VATEntryGLEntryNo = 0 THEN
        VATEntryGLEntryNo := GLEntry."Entry No.";
      TempGLEntryBuf."Entry No." := VATEntryGLEntryNo; // Used later in InsertVAT(): GLEntryVATEntryLink.InsertLink(TempGLEntryBuf."Entry No.",VATEntry."Entry No.")
      PostVAT(GenJnlLine,GLEntry,VATPostingSetup);

      FAJnlPostLine.UpdateRegNo(GLReg."No.");
      GenJnlLine.OnMoveGenJournalLine(GLEntry.RECORDID);
    END;

    LOCAL PROCEDURE PostICPartner@63(GenJnlLine@1002 : Record 81);
    VAR
      ICPartner@1001 : Record 413;
      AccountNo@1000 : Code[20];
    BEGIN
      WITH GenJnlLine DO BEGIN
        IF "Account No." <> ICPartner.Code THEN
          ICPartner.GET("Account No.");
        IF ("Document Type" = "Document Type"::"Credit Memo") XOR (Amount > 0) THEN BEGIN
          ICPartner.TESTFIELD("Receivables Account");
          AccountNo := ICPartner."Receivables Account";
        END ELSE BEGIN
          ICPartner.TESTFIELD("Payables Account");
          AccountNo := ICPartner."Payables Account";
        END;

        CreateGLEntryBalAcc(
          GenJnlLine,AccountNo,"Amount (LCY)","Source Currency Amount",
          "Bal. Account Type","Bal. Account No.");
      END;
    END;

    LOCAL PROCEDURE PostJob@78(GenJnlLine@1000 : Record 81;GLEntry@1002 : Record 17);
    VAR
      JobPostLine@1001 : Codeunit 1001;
    BEGIN
      IF JobLine THEN BEGIN
        JobLine := FALSE;
        JobPostLine.PostGenJnlLine(GenJnlLine,GLEntry);
      END;
    END;

    [Internal]
    PROCEDURE StartPosting@24(GenJnlLine@1001 : Record 81);
    VAR
      GenJnlTemplate@1000 : Record 80;
      AccountingPeriod@1002 : Record 50;
      LogInManagement@1003 : Codeunit 40;
    BEGIN
      OnBeforeStartPosting(GenJnlLine);

      WITH GenJnlLine DO BEGIN
        GlobalGLEntry.LOCKTABLE;
        IF GlobalGLEntry.FINDLAST THEN BEGIN
          NextEntryNo := GlobalGLEntry."Entry No." + 1;
          NextTransactionNo := GlobalGLEntry."Transaction No." + 1;
          LogInManagement.CheckLicense("Posting Date");
        END ELSE BEGIN
          NextEntryNo := 1;
          NextTransactionNo := 1;
        END;
        FirstTransactionNo := NextTransactionNo;

        InitLastDocDate(GenJnlLine);
        CurrentBalance := 0;

        AccountingPeriod.RESET;
        AccountingPeriod.SETCURRENTKEY(Closed);
        AccountingPeriod.SETRANGE(Closed,FALSE);
        AccountingPeriod.FINDFIRST;
        FiscalYearStartDate := AccountingPeriod."Starting Date";

        GetGLSetup;

        IF NOT GenJnlTemplate.GET("Journal Template Name") THEN
          GenJnlTemplate.INIT;

        VATEntry.LOCKTABLE;
        IF VATEntry.FINDLAST THEN
          NextVATEntryNo := VATEntry."Entry No." + 1
        ELSE
          NextVATEntryNo := 1;
        NextConnectionNo := 1;
        FirstNewVATEntryNo := NextVATEntryNo;

        GLReg.LOCKTABLE;
        IF GLReg.FINDLAST THEN
          GLReg."No." := GLReg."No." + 1
        ELSE
          GLReg."No." := 1;
        GLReg.INIT;
        GLReg."From Entry No." := NextEntryNo;
        GLReg."From VAT Entry No." := NextVATEntryNo;
        GLReg."Creation Date" := TODAY;
        GLReg."Source Code" := "Source Code";
        GLReg."Journal Batch Name" := "Journal Batch Name";
        GLReg."User ID" := USERID;
        IsGLRegInserted := FALSE;

        OnAfterInitGLRegister(GLReg,GenJnlLine);

        GetCurrencyExchRate(GenJnlLine);
        TempGLEntryBuf.DELETEALL;
        CalculateCurrentBalance(
          "Account No.","Bal. Account No.",IncludeVATAmount,"Amount (LCY)","VAT Amount");
      END;
    END;

    [Internal]
    PROCEDURE ContinuePosting@155(GenJnlLine@1000 : Record 81);
    BEGIN
      OnBeforeContinuePosting(GenJnlLine);

      IF NextTransactionNoNeeded(GenJnlLine) THEN BEGIN
        CheckPostUnrealizedVAT(GenJnlLine,FALSE);
        NextTransactionNo := NextTransactionNo + 1;
        InitLastDocDate(GenJnlLine);
        FirstNewVATEntryNo := NextVATEntryNo;
      END;

      GetCurrencyExchRate(GenJnlLine);
      TempGLEntryBuf.DELETEALL;
      CalculateCurrentBalance(
        GenJnlLine."Account No.",GenJnlLine."Bal. Account No.",GenJnlLine.IncludeVATAmount,
        GenJnlLine."Amount (LCY)",GenJnlLine."VAT Amount");
    END;

    LOCAL PROCEDURE NextTransactionNoNeeded@152(GenJnlLine@1000 : Record 81) : Boolean;
    VAR
      NewTransaction@1001 : Boolean;
    BEGIN
      WITH GenJnlLine DO BEGIN
        NewTransaction :=
          (LastDocType <> "Document Type") OR (LastDocNo <> "Document No.") OR
          (LastDate <> "Posting Date") OR ((CurrentBalance = 0) AND (TotalAddCurrAmount = 0)) AND NOT "System-Created Entry";
        IF NOT NewTransaction THEN
          OnNextTransactionNoNeeded(GenJnlLine,LastDocType,LastDocNo,LastDate,CurrentBalance,TotalAddCurrAmount,NewTransaction);
        EXIT(NewTransaction);
      END;
    END;

    [Internal]
    PROCEDURE FinishPosting@25() IsTransactionConsistent : Boolean;
    VAR
      CostAccSetup@1003 : Record 1108;
      TransferGlEntriesToCA@1004 : Codeunit 1105;
    BEGIN
      IsTransactionConsistent :=
        (BalanceCheckAmount = 0) AND (BalanceCheckAmount2 = 0) AND
        (BalanceCheckAddCurrAmount = 0) AND (BalanceCheckAddCurrAmount2 = 0);

      IF TempGLEntryBuf.FINDSET THEN BEGIN
        REPEAT
          GlobalGLEntry := TempGLEntryBuf;
          IF AddCurrencyCode = '' THEN BEGIN
            GlobalGLEntry."Additional-Currency Amount" := 0;
            GlobalGLEntry."Add.-Currency Debit Amount" := 0;
            GlobalGLEntry."Add.-Currency Credit Amount" := 0;
          END;
          GlobalGLEntry."Prior-Year Entry" := GlobalGLEntry."Posting Date" < FiscalYearStartDate;
          GlobalGLEntry.INSERT(TRUE);
          OnAfterInsertGlobalGLEntry(GlobalGLEntry);
        UNTIL TempGLEntryBuf.NEXT = 0;

        GLReg."To VAT Entry No." := NextVATEntryNo - 1;
        GLReg."To Entry No." := GlobalGLEntry."Entry No.";
        IF IsTransactionConsistent THEN
          IF IsGLRegInserted THEN
            GLReg.MODIFY
          ELSE BEGIN
            GLReg.INSERT;
            IsGLRegInserted := TRUE;
          END;
      END;
      GlobalGLEntry.CONSISTENT(IsTransactionConsistent);

      IF CostAccSetup.GET THEN
        IF CostAccSetup."Auto Transfer from G/L" THEN
          TransferGlEntriesToCA.GetGLEntries;

      FirstEntryNo := 0;
    END;

    LOCAL PROCEDURE PostUnrealizedVAT@64(GenJnlLine@1000 : Record 81);
    BEGIN
      IF CheckUnrealizedCust THEN BEGIN
        CustUnrealizedVAT(GenJnlLine,UnrealizedCustLedgEntry,UnrealizedRemainingAmountCust);
        CheckUnrealizedCust := FALSE;
      END;
      IF CheckUnrealizedVend THEN BEGIN
        VendUnrealizedVAT(GenJnlLine,UnrealizedVendLedgEntry,UnrealizedRemainingAmountVend);
        CheckUnrealizedVend := FALSE;
      END;
    END;

    LOCAL PROCEDURE CheckPostUnrealizedVAT@41(GenJnlLine@1000 : Record 81;CheckCurrentBalance@1001 : Boolean);
    BEGIN
      IF CheckCurrentBalance AND (CurrentBalance = 0) OR NOT CheckCurrentBalance THEN
        PostUnrealizedVAT(GenJnlLine)
    END;

    LOCAL PROCEDURE InitGLEntry@3(GenJnlLine@1008 : Record 81;VAR GLEntry@1009 : Record 17;GLAccNo@1000 : Code[20];Amount@1001 : Decimal;AmountAddCurr@1002 : Decimal;UseAmountAddCurr@1003 : Boolean;SystemCreatedEntry@1004 : Boolean);
    VAR
      GLAcc@1007 : Record 15;
    BEGIN
      IF GLAccNo <> '' THEN BEGIN
        GLAcc.GET(GLAccNo);
        GLAcc.TESTFIELD(Blocked,FALSE);
        GLAcc.TESTFIELD("Account Type",GLAcc."Account Type"::Posting);

        // Check the Value Posting field on the G/L Account if it is not checked already in Codeunit 11
        IF (NOT
            ((GLAccNo = GenJnlLine."Account No.") AND
             (GenJnlLine."Account Type" = GenJnlLine."Account Type"::"G/L Account")) OR
            ((GLAccNo = GenJnlLine."Bal. Account No.") AND
             (GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::"G/L Account"))) AND
           NOT FADimAlreadyChecked
        THEN
          CheckGLAccDimError(GenJnlLine,GLAccNo);
      END;

      GLEntry.INIT;
      GLEntry.CopyFromGenJnlLine(GenJnlLine);
      GLEntry."Entry No." := NextEntryNo;
      GLEntry."Transaction No." := NextTransactionNo;
      GLEntry."G/L Account No." := GLAccNo;
      GLEntry."System-Created Entry" := SystemCreatedEntry;
      GLEntry.Amount := Amount;
      GLEntry."Additional-Currency Amount" :=
        GLCalcAddCurrency(Amount,AmountAddCurr,GLEntry."Additional-Currency Amount",UseAmountAddCurr,GenJnlLine);
    END;

    LOCAL PROCEDURE InitGLEntryVAT@113(GenJnlLine@1004 : Record 81;AccNo@1003 : Code[20];BalAccNo@1008 : Code[20];Amount@1002 : Decimal;AmountAddCurr@1001 : Decimal;UseAmtAddCurr@1007 : Boolean);
    VAR
      GLEntry@1005 : Record 17;
    BEGIN
      IF UseAmtAddCurr THEN
        InitGLEntry(GenJnlLine,GLEntry,AccNo,Amount,AmountAddCurr,TRUE,TRUE)
      ELSE BEGIN
        InitGLEntry(GenJnlLine,GLEntry,AccNo,Amount,0,FALSE,TRUE);
        GLEntry."Additional-Currency Amount" := AmountAddCurr;
        GLEntry."Bal. Account No." := BalAccNo;
      END;
      SummarizeVAT(GLSetup."Summarize G/L Entries",GLEntry);
    END;

    LOCAL PROCEDURE InitGLEntryVATCopy@116(GenJnlLine@1001 : Record 81;AccNo@1003 : Code[20];BalAccNo@1007 : Code[20];Amount@1004 : Decimal;AmountAddCurr@1005 : Decimal;VATEntry@1008 : Record 254) : Integer;
    VAR
      GLEntry@1000 : Record 17;
    BEGIN
      InitGLEntry(GenJnlLine,GLEntry,AccNo,Amount,0,FALSE,TRUE);
      GLEntry."Additional-Currency Amount" := AmountAddCurr;
      GLEntry."Bal. Account No." := BalAccNo;
      GLEntry.CopyPostingGroupsFromVATEntry(VATEntry);
      SummarizeVAT(GLSetup."Summarize G/L Entries",GLEntry);

      EXIT(GLEntry."Entry No.");
    END;

    [External]
    PROCEDURE InsertGLEntry@2(GenJnlLine@1001 : Record 81;GLEntry@1002 : Record 17;CalcAddCurrResiduals@1000 : Boolean);
    BEGIN
      WITH GLEntry DO BEGIN
        TESTFIELD("G/L Account No.");

        IF Amount <> ROUND(Amount) THEN
          FIELDERROR(
            Amount,
            STRSUBSTNO(NeedsRoundingErr,Amount));

        UpdateCheckAmounts(
          "Posting Date",Amount,"Additional-Currency Amount",
          BalanceCheckAmount,BalanceCheckAmount2,BalanceCheckAddCurrAmount,BalanceCheckAddCurrAmount2);

        UpdateDebitCredit(GenJnlLine.Correction);
      END;

      TempGLEntryBuf := GLEntry;

      OnBeforeInsertGLEntryBuffer(TempGLEntryBuf,GenJnlLine);

      TempGLEntryBuf.INSERT;

      IF FirstEntryNo = 0 THEN
        FirstEntryNo := TempGLEntryBuf."Entry No.";
      NextEntryNo := NextEntryNo + 1;

      IF CalcAddCurrResiduals THEN
        HandleAddCurrResidualGLEntry(GenJnlLine,GLEntry.Amount,GLEntry."Additional-Currency Amount");
    END;

    LOCAL PROCEDURE CreateGLEntry@112(GenJnlLine@1005 : Record 81;AccNo@1004 : Code[20];Amount@1003 : Decimal;AmountAddCurr@1002 : Decimal;UseAmountAddCurr@1006 : Boolean);
    VAR
      GLEntry@1000 : Record 17;
    BEGIN
      IF UseAmountAddCurr THEN
        InitGLEntry(GenJnlLine,GLEntry,AccNo,Amount,AmountAddCurr,TRUE,TRUE)
      ELSE BEGIN
        InitGLEntry(GenJnlLine,GLEntry,AccNo,Amount,0,FALSE,TRUE);
        GLEntry."Additional-Currency Amount" := AmountAddCurr;
      END;
      InsertGLEntry(GenJnlLine,GLEntry,TRUE);
    END;

    LOCAL PROCEDURE CreateGLEntryBalAcc@126(GenJnlLine@1005 : Record 81;AccNo@1004 : Code[20];Amount@1003 : Decimal;AmountAddCurr@1002 : Decimal;BalAccType@1008 : Option;BalAccNo@1007 : Code[20]);
    VAR
      GLEntry@1000 : Record 17;
    BEGIN
      InitGLEntry(GenJnlLine,GLEntry,AccNo,Amount,AmountAddCurr,TRUE,TRUE);
      GLEntry."Bal. Account Type" := BalAccType;
      GLEntry."Bal. Account No." := BalAccNo;
      InsertGLEntry(GenJnlLine,GLEntry,TRUE);
      GenJnlLine.OnMoveGenJournalLine(GLEntry.RECORDID);
    END;

    LOCAL PROCEDURE CreateGLEntryGainLoss@26(GenJnlLine@1005 : Record 81;AccNo@1004 : Code[20];Amount@1003 : Decimal;UseAmountAddCurr@1006 : Boolean);
    VAR
      GLEntry@1000 : Record 17;
    BEGIN
      InitGLEntry(GenJnlLine,GLEntry,AccNo,Amount,0,UseAmountAddCurr,TRUE);
      InsertGLEntry(GenJnlLine,GLEntry,TRUE);
    END;

    LOCAL PROCEDURE CreateGLEntryVAT@117(GenJnlLine@1004 : Record 81;AccNo@1003 : Code[20];Amount@1002 : Decimal;AmountAddCurr@1001 : Decimal;VATAmount@1005 : Decimal;DtldCVLedgEntryBuf@1006 : Record 383);
    VAR
      GLEntry@1000 : Record 17;
    BEGIN
      InitGLEntry(GenJnlLine,GLEntry,AccNo,Amount,0,FALSE,TRUE);
      GLEntry."Additional-Currency Amount" := AmountAddCurr;
      GLEntry."VAT Amount" := VATAmount;
      GLEntry.CopyPostingGroupsFromDtldCVBuf(DtldCVLedgEntryBuf,DtldCVLedgEntryBuf."Gen. Posting Type");
      InsertGLEntry(GenJnlLine,GLEntry,TRUE);
      InsertVATEntriesFromTemp(DtldCVLedgEntryBuf,GLEntry);
    END;

    LOCAL PROCEDURE CreateGLEntryVATCollectAdj@110(GenJnlLine@1004 : Record 81;AccNo@1003 : Code[20];Amount@1002 : Decimal;AmountAddCurr@1001 : Decimal;VATAmount@1005 : Decimal;DtldCVLedgEntryBuf@1006 : Record 383;VAR AdjAmount@1007 : ARRAY [4] OF Decimal);
    VAR
      GLEntry@1000 : Record 17;
    BEGIN
      InitGLEntry(GenJnlLine,GLEntry,AccNo,Amount,0,FALSE,TRUE);
      GLEntry."Additional-Currency Amount" := AmountAddCurr;
      GLEntry."VAT Amount" := VATAmount;
      GLEntry.CopyPostingGroupsFromDtldCVBuf(DtldCVLedgEntryBuf,DtldCVLedgEntryBuf."Gen. Posting Type");
      InsertGLEntry(GenJnlLine,GLEntry,TRUE);
      CollectAdjustment(AdjAmount,GLEntry.Amount,GLEntry."Additional-Currency Amount");
      InsertVATEntriesFromTemp(DtldCVLedgEntryBuf,GLEntry);
    END;

    LOCAL PROCEDURE CreateGLEntryFromVATEntry@22(GenJnlLine@1000 : Record 81;VATAccNo@1002 : Code[20];Amount@1003 : Decimal;AmountAddCurr@1004 : Decimal;VATEntry@1005 : Record 254);
    VAR
      GLEntry@1001 : Record 17;
    BEGIN
      InitGLEntry(GenJnlLine,GLEntry,VATAccNo,Amount,0,FALSE,TRUE);
      GLEntry."Additional-Currency Amount" := AmountAddCurr;
      GLEntry.CopyPostingGroupsFromVATEntry(VATEntry);
      InsertGLEntry(GenJnlLine,GLEntry,TRUE);
    END;

    LOCAL PROCEDURE CreateDeferralScheduleFromGL@386(VAR GenJournalLine@1000 : Record 81;IsBalancing@1001 : Boolean);
    BEGIN
      WITH GenJournalLine DO
        IF ("Account No." <> '') AND ("Deferral Code" <> '') THEN
          IF (("Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor]) AND ("Source Code" = GLSourceCode)) OR
             ("Account Type" IN ["Account Type"::"G/L Account","Account Type"::"Bank Account"])
          THEN BEGIN
            IF NOT IsBalancing THEN
              CODEUNIT.RUN(CODEUNIT::"Exchange Acc. G/L Journal Line",GenJournalLine);
            DeferralUtilities.CreateScheduleFromGL(GenJournalLine,FirstEntryNo);
          END;
    END;

    LOCAL PROCEDURE UpdateCheckAmounts@98(PostingDate@1000 : Date;Amount@1005 : Decimal;AddCurrAmount@1006 : Decimal;VAR BalanceCheckAmount@1001 : Decimal;VAR BalanceCheckAmount2@1002 : Decimal;VAR BalanceCheckAddCurrAmount@1003 : Decimal;VAR BalanceCheckAddCurrAmount2@1004 : Decimal);
    BEGIN
      IF PostingDate = NORMALDATE(PostingDate) THEN BEGIN
        BalanceCheckAmount :=
          BalanceCheckAmount + Amount * ((PostingDate - 01010000D) MOD 99 + 1);
        BalanceCheckAmount2 :=
          BalanceCheckAmount2 + Amount * ((PostingDate - 01010000D) MOD 98 + 1);
      END ELSE BEGIN
        BalanceCheckAmount :=
          BalanceCheckAmount + Amount * ((NORMALDATE(PostingDate) - 01010000D + 50) MOD 99 + 1);
        BalanceCheckAmount2 :=
          BalanceCheckAmount2 + Amount * ((NORMALDATE(PostingDate) - 01010000D + 50) MOD 98 + 1);
      END;

      IF AddCurrencyCode <> '' THEN
        IF PostingDate = NORMALDATE(PostingDate) THEN BEGIN
          BalanceCheckAddCurrAmount :=
            BalanceCheckAddCurrAmount + AddCurrAmount * ((PostingDate - 01010000D) MOD 99 + 1);
          BalanceCheckAddCurrAmount2 :=
            BalanceCheckAddCurrAmount2 + AddCurrAmount * ((PostingDate - 01010000D) MOD 98 + 1);
        END ELSE BEGIN
          BalanceCheckAddCurrAmount :=
            BalanceCheckAddCurrAmount +
            AddCurrAmount * ((NORMALDATE(PostingDate) - 01010000D + 50) MOD 99 + 1);
          BalanceCheckAddCurrAmount2 :=
            BalanceCheckAddCurrAmount2 +
            AddCurrAmount * ((NORMALDATE(PostingDate) - 01010000D + 50) MOD 98 + 1);
        END
      ELSE BEGIN
        BalanceCheckAddCurrAmount := 0;
        BalanceCheckAddCurrAmount2 := 0;
      END;
    END;

    LOCAL PROCEDURE CalcPmtDiscPossible@71(GenJnlLine@1000 : Record 81;VAR CVLedgEntryBuf@1001 : Record 382);
    BEGIN
      WITH GenJnlLine DO
        IF "Amount (LCY)" <> 0 THEN BEGIN
          IF (CVLedgEntryBuf."Pmt. Discount Date" >= CVLedgEntryBuf."Posting Date") OR
             (CVLedgEntryBuf."Pmt. Discount Date" = 0D)
          THEN BEGIN
            IF GLSetup."Pmt. Disc. Excl. VAT" THEN BEGIN
              IF "Sales/Purch. (LCY)" = 0 THEN
                CVLedgEntryBuf."Original Pmt. Disc. Possible" :=
                  ("Amount (LCY)" + TotalVATAmountOnJnlLines(GenJnlLine)) * Amount / "Amount (LCY)"
              ELSE
                CVLedgEntryBuf."Original Pmt. Disc. Possible" := "Sales/Purch. (LCY)" * Amount / "Amount (LCY)"
            END ELSE
              CVLedgEntryBuf."Original Pmt. Disc. Possible" := Amount;
            CVLedgEntryBuf."Original Pmt. Disc. Possible" :=
              ROUND(
                CVLedgEntryBuf."Original Pmt. Disc. Possible" * "Payment Discount %" / 100,AmountRoundingPrecision);
          END;
          CVLedgEntryBuf."Remaining Pmt. Disc. Possible" := CVLedgEntryBuf."Original Pmt. Disc. Possible";
        END;
    END;

    LOCAL PROCEDURE CalcPmtTolerancePossible@72(GenJnlLine@1003 : Record 81;PmtDiscountDate@1001 : Date;VAR PmtDiscToleranceDate@1002 : Date;VAR MaxPaymentTolerance@1000 : Decimal);
    BEGIN
      WITH GenJnlLine DO
        IF "Document Type" IN ["Document Type"::Invoice,"Document Type"::"Credit Memo"] THEN BEGIN
          IF PmtDiscountDate <> 0D THEN
            PmtDiscToleranceDate :=
              CALCDATE(GLSetup."Payment Discount Grace Period",PmtDiscountDate)
          ELSE
            PmtDiscToleranceDate := PmtDiscountDate;

          CASE "Account Type" OF
            "Account Type"::Customer:
              PaymentToleranceMgt.CalcMaxPmtTolerance(
                "Document Type","Currency Code",Amount,"Amount (LCY)",1,MaxPaymentTolerance);
            "Account Type"::Vendor:
              PaymentToleranceMgt.CalcMaxPmtTolerance(
                "Document Type","Currency Code",Amount,"Amount (LCY)",-1,MaxPaymentTolerance);
          END;
        END;
    END;

    LOCAL PROCEDURE CalcPmtTolerance@61(VAR NewCVLedgEntryBuf@1008 : Record 382;VAR OldCVLedgEntryBuf@1007 : Record 382;VAR OldCVLedgEntryBuf2@1006 : Record 382;VAR DtldCVLedgEntryBuf@1005 : Record 383;GenJnlLine@1004 : Record 81;VAR PmtTolAmtToBeApplied@1012 : Decimal;NextTransactionNo@1001 : Integer;FirstNewVATEntryNo@1000 : Integer);
    VAR
      PmtTol@1011 : Decimal;
      PmtTolLCY@1010 : Decimal;
      PmtTolAddCurr@1009 : Decimal;
    BEGIN
      IF OldCVLedgEntryBuf2."Accepted Payment Tolerance" = 0 THEN
        EXIT;

      PmtTol := -OldCVLedgEntryBuf2."Accepted Payment Tolerance";
      PmtTolAmtToBeApplied := PmtTolAmtToBeApplied + PmtTol;
      PmtTolLCY :=
        ROUND(
          (NewCVLedgEntryBuf."Original Amount" + PmtTol) / NewCVLedgEntryBuf."Original Currency Factor") -
        NewCVLedgEntryBuf."Original Amt. (LCY)";

      OldCVLedgEntryBuf."Accepted Payment Tolerance" := 0;
      OldCVLedgEntryBuf."Pmt. Tolerance (LCY)" := -PmtTolLCY;

      IF NewCVLedgEntryBuf."Currency Code" = AddCurrencyCode THEN
        PmtTolAddCurr := PmtTol
      ELSE
        PmtTolAddCurr := CalcLCYToAddCurr(PmtTolLCY);

      IF NOT GLSetup."Pmt. Disc. Excl. VAT" AND GLSetup."Adjust for Payment Disc." AND (PmtTolLCY <> 0) THEN
        CalcPmtDiscIfAdjVAT(
          NewCVLedgEntryBuf,OldCVLedgEntryBuf2,DtldCVLedgEntryBuf,GenJnlLine,PmtTolLCY,PmtTolAddCurr,
          NextTransactionNo,FirstNewVATEntryNo,DtldCVLedgEntryBuf."Entry Type"::"Payment Tolerance (VAT Excl.)");

      DtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(
        GenJnlLine,NewCVLedgEntryBuf,DtldCVLedgEntryBuf,
        DtldCVLedgEntryBuf."Entry Type"::"Payment Tolerance",PmtTol,PmtTolLCY,PmtTolAddCurr,0,0,0);
    END;

    LOCAL PROCEDURE CalcPmtDisc@50(VAR NewCVLedgEntryBuf@1000 : Record 382;VAR OldCVLedgEntryBuf@1001 : Record 382;VAR OldCVLedgEntryBuf2@1002 : Record 382;VAR DtldCVLedgEntryBuf@1003 : Record 383;GenJnlLine@1004 : Record 81;PmtTolAmtToBeApplied@1012 : Decimal;ApplnRoundingPrecision@1006 : Decimal;NextTransactionNo@1007 : Integer;FirstNewVATEntryNo@1008 : Integer);
    VAR
      PmtDisc@1009 : Decimal;
      PmtDiscLCY@1010 : Decimal;
      PmtDiscAddCurr@1011 : Decimal;
      MinimalPossibleLiability@1014 : Decimal;
      PaymentExceedsLiability@1005 : Boolean;
      ToleratedPaymentExceedsLiability@1013 : Boolean;
    BEGIN
      MinimalPossibleLiability := ABS(OldCVLedgEntryBuf2."Remaining Amount" - OldCVLedgEntryBuf2."Remaining Pmt. Disc. Possible");
      PaymentExceedsLiability := ABS(OldCVLedgEntryBuf2."Amount to Apply") >= MinimalPossibleLiability;
      ToleratedPaymentExceedsLiability := ABS(NewCVLedgEntryBuf."Remaining Amount" + PmtTolAmtToBeApplied) >= MinimalPossibleLiability;

      IF (PaymentToleranceMgt.CheckCalcPmtDisc(NewCVLedgEntryBuf,OldCVLedgEntryBuf2,ApplnRoundingPrecision,TRUE,TRUE) AND
          ((OldCVLedgEntryBuf2."Amount to Apply" = 0) OR PaymentExceedsLiability) OR
          (PaymentToleranceMgt.CheckCalcPmtDisc(NewCVLedgEntryBuf,OldCVLedgEntryBuf2,ApplnRoundingPrecision,FALSE,FALSE) AND
           (OldCVLedgEntryBuf2."Amount to Apply" <> 0) AND PaymentExceedsLiability AND ToleratedPaymentExceedsLiability))
      THEN BEGIN
        PmtDisc := -OldCVLedgEntryBuf2."Remaining Pmt. Disc. Possible";
        PmtDiscLCY :=
          ROUND(
            (NewCVLedgEntryBuf."Original Amount" + PmtDisc) / NewCVLedgEntryBuf."Original Currency Factor") -
          NewCVLedgEntryBuf."Original Amt. (LCY)";

        OldCVLedgEntryBuf."Pmt. Disc. Given (LCY)" := -PmtDiscLCY;

        IF (NewCVLedgEntryBuf."Currency Code" = AddCurrencyCode) AND (AddCurrencyCode <> '') THEN
          PmtDiscAddCurr := PmtDisc
        ELSE
          PmtDiscAddCurr := CalcLCYToAddCurr(PmtDiscLCY);

        IF NOT GLSetup."Pmt. Disc. Excl. VAT" AND GLSetup."Adjust for Payment Disc." AND
           (PmtDiscLCY <> 0)
        THEN
          CalcPmtDiscIfAdjVAT(
            NewCVLedgEntryBuf,OldCVLedgEntryBuf2,DtldCVLedgEntryBuf,GenJnlLine,PmtDiscLCY,PmtDiscAddCurr,
            NextTransactionNo,FirstNewVATEntryNo,DtldCVLedgEntryBuf."Entry Type"::"Payment Discount (VAT Excl.)");

        DtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(
          GenJnlLine,NewCVLedgEntryBuf,DtldCVLedgEntryBuf,
          DtldCVLedgEntryBuf."Entry Type"::"Payment Discount",PmtDisc,PmtDiscLCY,PmtDiscAddCurr,0,0,0);
      END;
    END;

    LOCAL PROCEDURE CalcPmtDiscIfAdjVAT@49(VAR NewCVLedgEntryBuf@1000 : Record 382;VAR OldCVLedgEntryBuf@1001 : Record 382;VAR DtldCVLedgEntryBuf@1002 : Record 383;GenJnlLine@1003 : Record 81;VAR PmtDiscLCY2@1005 : Decimal;VAR PmtDiscAddCurr2@1006 : Decimal;NextTransactionNo@1007 : Integer;FirstNewVATEntryNo@1008 : Integer;EntryType@1009 : Integer);
    VAR
      VATEntry2@1011 : Record 254;
      VATPostingSetup@1012 : Record 325;
      TaxJurisdiction@1013 : Record 320;
      DtldCVLedgEntryBuf2@1015 : Record 383;
      OriginalAmountAddCurr@1016 : Decimal;
      PmtDiscRounding@1017 : Decimal;
      PmtDiscRoundingAddCurr@1018 : Decimal;
      PmtDiscFactorLCY@1019 : Decimal;
      PmtDiscFactorAddCurr@1020 : Decimal;
      VATBase@1021 : Decimal;
      VATBaseAddCurr@1022 : Decimal;
      VATAmount@1023 : Decimal;
      VATAmountAddCurr@1024 : Decimal;
      TotalVATAmount@1025 : Decimal;
      LastConnectionNo@1026 : Integer;
      VATEntryModifier@1027 : Integer;
    BEGIN
      IF OldCVLedgEntryBuf."Original Amt. (LCY)" = 0 THEN
        EXIT;

      IF (AddCurrencyCode = '') OR (AddCurrencyCode = OldCVLedgEntryBuf."Currency Code") THEN
        OriginalAmountAddCurr := OldCVLedgEntryBuf.Amount
      ELSE
        OriginalAmountAddCurr := CalcLCYToAddCurr(OldCVLedgEntryBuf."Original Amt. (LCY)");

      PmtDiscRounding := PmtDiscLCY2;
      PmtDiscFactorLCY := PmtDiscLCY2 / OldCVLedgEntryBuf."Original Amt. (LCY)";
      IF OriginalAmountAddCurr <> 0 THEN
        PmtDiscFactorAddCurr := PmtDiscAddCurr2 / OriginalAmountAddCurr
      ELSE
        PmtDiscFactorAddCurr := 0;
      VATEntry2.RESET;
      VATEntry2.SETCURRENTKEY("Transaction No.");
      VATEntry2.SETRANGE("Transaction No.",OldCVLedgEntryBuf."Transaction No.");
      IF OldCVLedgEntryBuf."Transaction No." = NextTransactionNo THEN
        VATEntry2.SETRANGE("Entry No.",0,FirstNewVATEntryNo - 1);
      IF VATEntry2.FINDSET THEN BEGIN
        TotalVATAmount := 0;
        LastConnectionNo := 0;
        REPEAT
          VATPostingSetup.GET(VATEntry2."VAT Bus. Posting Group",VATEntry2."VAT Prod. Posting Group");
          IF VATEntry2."VAT Calculation Type" =
             VATEntry2."VAT Calculation Type"::"Sales Tax"
          THEN BEGIN
            TaxJurisdiction.GET(VATEntry2."Tax Jurisdiction Code");
            VATPostingSetup."Adjust for Payment Discount" :=
              TaxJurisdiction."Adjust for Payment Discount";
          END;
          IF VATPostingSetup."Adjust for Payment Discount" THEN BEGIN
            IF LastConnectionNo <> VATEntry2."Sales Tax Connection No." THEN BEGIN
              IF LastConnectionNo <> 0 THEN BEGIN
                DtldCVLedgEntryBuf := DtldCVLedgEntryBuf2;
                DtldCVLedgEntryBuf."VAT Amount (LCY)" := -TotalVATAmount;
                DtldCVLedgEntryBuf.InsertDtldCVLedgEntry(DtldCVLedgEntryBuf,NewCVLedgEntryBuf,FALSE);
                InsertSummarizedVAT(GenJnlLine);
              END;

              CalcPmtDiscVATBases(VATEntry2,VATBase,VATBaseAddCurr);

              PmtDiscRounding := PmtDiscRounding + VATBase * PmtDiscFactorLCY;
              VATBase := ROUND(PmtDiscRounding - PmtDiscLCY2);
              PmtDiscLCY2 := PmtDiscLCY2 + VATBase;

              PmtDiscRoundingAddCurr := PmtDiscRoundingAddCurr + VATBaseAddCurr * PmtDiscFactorAddCurr;
              VATBaseAddCurr := ROUND(CalcLCYToAddCurr(VATBase),AddCurrency."Amount Rounding Precision");
              PmtDiscAddCurr2 := PmtDiscAddCurr2 + VATBaseAddCurr;

              DtldCVLedgEntryBuf2.INIT;
              DtldCVLedgEntryBuf2."Posting Date" := GenJnlLine."Posting Date";
              DtldCVLedgEntryBuf2."Document Type" := GenJnlLine."Document Type";
              DtldCVLedgEntryBuf2."Document No." := GenJnlLine."Document No.";
              DtldCVLedgEntryBuf2.Amount := 0;
              DtldCVLedgEntryBuf2."Amount (LCY)" := -VATBase;
              DtldCVLedgEntryBuf2."Entry Type" := EntryType;
              CASE EntryType OF
                DtldCVLedgEntryBuf."Entry Type"::"Payment Discount Tolerance (VAT Excl.)":
                  VATEntryModifier := 1000000;
                DtldCVLedgEntryBuf."Entry Type"::"Payment Tolerance (VAT Excl.)":
                  VATEntryModifier := 2000000;
                DtldCVLedgEntryBuf."Entry Type"::"Payment Discount (VAT Excl.)":
                  VATEntryModifier := 3000000;
              END;
              DtldCVLedgEntryBuf2.CopyFromCVLedgEntryBuf(NewCVLedgEntryBuf);
              // The total payment discount in currency is posted on the entry made in
              // the function CalcPmtDisc.
              DtldCVLedgEntryBuf2."User ID" := USERID;
              DtldCVLedgEntryBuf2."Additional-Currency Amount" := -VATBaseAddCurr;
              DtldCVLedgEntryBuf2.CopyPostingGroupsFromVATEntry(VATEntry2);
              TotalVATAmount := 0;
              LastConnectionNo := VATEntry2."Sales Tax Connection No.";
            END;

            CalcPmtDiscVATAmounts(
              VATEntry2,VATBase,VATBaseAddCurr,VATAmount,VATAmountAddCurr,
              PmtDiscRounding,PmtDiscFactorLCY,PmtDiscLCY2,PmtDiscAddCurr2);

            TotalVATAmount := TotalVATAmount + VATAmount;

            IF (PmtDiscAddCurr2 <> 0) AND (PmtDiscLCY2 = 0) THEN BEGIN
              VATAmountAddCurr := VATAmountAddCurr - PmtDiscAddCurr2;
              PmtDiscAddCurr2 := 0;
            END;

            // Post VAT
            // VAT for VAT entry
            IF VATEntry2.Type <> 0 THEN
              InsertPmtDiscVATForVATEntry(
                GenJnlLine,TempVATEntry,VATEntry2,VATEntryModifier,
                VATAmount,VATAmountAddCurr,VATBase,VATBaseAddCurr,
                PmtDiscFactorLCY,PmtDiscFactorAddCurr);

            // VAT for G/L entry/entries
            InsertPmtDiscVATForGLEntry(
              GenJnlLine,DtldCVLedgEntryBuf,NewCVLedgEntryBuf,VATEntry2,
              VATPostingSetup,TaxJurisdiction,EntryType,VATAmount,VATAmountAddCurr);
          END;
        UNTIL VATEntry2.NEXT = 0;

        IF LastConnectionNo <> 0 THEN BEGIN
          DtldCVLedgEntryBuf := DtldCVLedgEntryBuf2;
          DtldCVLedgEntryBuf."VAT Amount (LCY)" := -TotalVATAmount;
          DtldCVLedgEntryBuf.InsertDtldCVLedgEntry(DtldCVLedgEntryBuf,NewCVLedgEntryBuf,TRUE);
          InsertSummarizedVAT(GenJnlLine);
        END;
      END;
    END;

    LOCAL PROCEDURE CalcPmtDiscTolerance@60(VAR NewCVLedgEntryBuf@1008 : Record 382;VAR OldCVLedgEntryBuf@1007 : Record 382;VAR OldCVLedgEntryBuf2@1006 : Record 382;VAR DtldCVLedgEntryBuf@1005 : Record 383;GenJnlLine@1004 : Record 81;NextTransactionNo@1001 : Integer;FirstNewVATEntryNo@1000 : Integer);
    VAR
      PmtDiscTol@1011 : Decimal;
      PmtDiscTolLCY@1010 : Decimal;
      PmtDiscTolAddCurr@1009 : Decimal;
    BEGIN
      IF NOT OldCVLedgEntryBuf2."Accepted Pmt. Disc. Tolerance" THEN
        EXIT;

      PmtDiscTol := -OldCVLedgEntryBuf2."Remaining Pmt. Disc. Possible";
      PmtDiscTolLCY :=
        ROUND(
          (NewCVLedgEntryBuf."Original Amount" + PmtDiscTol) / NewCVLedgEntryBuf."Original Currency Factor") -
        NewCVLedgEntryBuf."Original Amt. (LCY)";

      OldCVLedgEntryBuf."Pmt. Disc. Given (LCY)" := -PmtDiscTolLCY;

      IF NewCVLedgEntryBuf."Currency Code" = AddCurrencyCode THEN
        PmtDiscTolAddCurr := PmtDiscTol
      ELSE
        PmtDiscTolAddCurr := CalcLCYToAddCurr(PmtDiscTolLCY);

      IF NOT GLSetup."Pmt. Disc. Excl. VAT" AND GLSetup."Adjust for Payment Disc." AND (PmtDiscTolLCY <> 0) THEN
        CalcPmtDiscIfAdjVAT(
          NewCVLedgEntryBuf,OldCVLedgEntryBuf2,DtldCVLedgEntryBuf,GenJnlLine,PmtDiscTolLCY,PmtDiscTolAddCurr,
          NextTransactionNo,FirstNewVATEntryNo,DtldCVLedgEntryBuf."Entry Type"::"Payment Discount Tolerance (VAT Excl.)");

      DtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(
        GenJnlLine,NewCVLedgEntryBuf,DtldCVLedgEntryBuf,
        DtldCVLedgEntryBuf."Entry Type"::"Payment Discount Tolerance",PmtDiscTol,PmtDiscTolLCY,PmtDiscTolAddCurr,0,0,0);
    END;

    LOCAL PROCEDURE CalcPmtDiscVATBases@118(VATEntry2@1001 : Record 254;VAR VATBase@1002 : Decimal;VAR VATBaseAddCurr@1003 : Decimal);
    VAR
      VATEntry@1000 : Record 254;
    BEGIN
      CASE VATEntry2."VAT Calculation Type" OF
        VATEntry2."VAT Calculation Type"::"Normal VAT",
        VATEntry2."VAT Calculation Type"::"Reverse Charge VAT",
        VATEntry2."VAT Calculation Type"::"Full VAT":
          BEGIN
            VATBase :=
              VATEntry2.Base + VATEntry2."Unrealized Base";
            VATBaseAddCurr :=
              VATEntry2."Additional-Currency Base" +
              VATEntry2."Add.-Currency Unrealized Base";
          END;
        VATEntry2."VAT Calculation Type"::"Sales Tax":
          BEGIN
            VATEntry.RESET;
            VATEntry.SETCURRENTKEY("Transaction No.");
            VATEntry.SETRANGE("Transaction No.",VATEntry2."Transaction No.");
            VATEntry.SETRANGE("Sales Tax Connection No.",VATEntry2."Sales Tax Connection No.");
            VATEntry := VATEntry2;
            REPEAT
              IF VATEntry.Base < 0 THEN
                VATEntry.SETFILTER(Base,'>%1',VATEntry.Base)
              ELSE
                VATEntry.SETFILTER(Base,'<%1',VATEntry.Base);
            UNTIL NOT VATEntry.FINDLAST;
            VATEntry.RESET;
            VATBase :=
              VATEntry.Base + VATEntry."Unrealized Base";
            VATBaseAddCurr :=
              VATEntry."Additional-Currency Base" +
              VATEntry."Add.-Currency Unrealized Base";
          END;
      END;
    END;

    LOCAL PROCEDURE CalcPmtDiscVATAmounts@129(VATEntry2@1000 : Record 254;VATBase@1001 : Decimal;VATBaseAddCurr@1007 : Decimal;VAR VATAmount@1002 : Decimal;VAR VATAmountAddCurr@1003 : Decimal;VAR PmtDiscRounding@1004 : Decimal;PmtDiscFactorLCY@1005 : Decimal;VAR PmtDiscLCY2@1006 : Decimal;VAR PmtDiscAddCurr2@1008 : Decimal);
    BEGIN
      CASE VATEntry2."VAT Calculation Type" OF
        VATEntry2."VAT Calculation Type"::"Normal VAT",
        VATEntry2."VAT Calculation Type"::"Full VAT":
          IF (VATEntry2.Amount + VATEntry2."Unrealized Amount" <> 0) OR
             (VATEntry2."Additional-Currency Amount" + VATEntry2."Add.-Currency Unrealized Amt." <> 0)
          THEN BEGIN
            IF (VATBase = 0) AND
               (VATEntry2."VAT Calculation Type" <> VATEntry2."VAT Calculation Type"::"Full VAT")
            THEN
              VATAmount := 0
            ELSE BEGIN
              PmtDiscRounding :=
                PmtDiscRounding +
                (VATEntry2.Amount + VATEntry2."Unrealized Amount") * PmtDiscFactorLCY;
              VATAmount := ROUND(PmtDiscRounding - PmtDiscLCY2);
              PmtDiscLCY2 := PmtDiscLCY2 + VATAmount;
            END;
            IF (VATBaseAddCurr = 0) AND
               (VATEntry2."VAT Calculation Type" <> VATEntry2."VAT Calculation Type"::"Full VAT")
            THEN
              VATAmountAddCurr := 0
            ELSE BEGIN
              VATAmountAddCurr := ROUND(CalcLCYToAddCurr(VATAmount),AddCurrency."Amount Rounding Precision");
              PmtDiscAddCurr2 := PmtDiscAddCurr2 + VATAmountAddCurr;
            END;
          END ELSE BEGIN
            VATAmount := 0;
            VATAmountAddCurr := 0;
          END;
        VATEntry2."VAT Calculation Type"::"Reverse Charge VAT":
          BEGIN
            VATAmount :=
              ROUND((VATEntry2.Amount + VATEntry2."Unrealized Amount") * PmtDiscFactorLCY);
            VATAmountAddCurr := ROUND(CalcLCYToAddCurr(VATAmount),AddCurrency."Amount Rounding Precision");
          END;
        VATEntry2."VAT Calculation Type"::"Sales Tax":
          IF (VATEntry2.Type = VATEntry2.Type::Purchase) AND VATEntry2."Use Tax" THEN BEGIN
            VATAmount :=
              ROUND((VATEntry2.Amount + VATEntry2."Unrealized Amount") * PmtDiscFactorLCY);
            VATAmountAddCurr := ROUND(CalcLCYToAddCurr(VATAmount),AddCurrency."Amount Rounding Precision");
          END ELSE
            IF (VATEntry2.Amount + VATEntry2."Unrealized Amount" <> 0) OR
               (VATEntry2."Additional-Currency Amount" + VATEntry2."Add.-Currency Unrealized Amt." <> 0)
            THEN BEGIN
              IF VATBase = 0 THEN
                VATAmount := 0
              ELSE BEGIN
                PmtDiscRounding :=
                  PmtDiscRounding +
                  (VATEntry2.Amount + VATEntry2."Unrealized Amount") * PmtDiscFactorLCY;
                VATAmount := ROUND(PmtDiscRounding - PmtDiscLCY2);
                PmtDiscLCY2 := PmtDiscLCY2 + VATAmount;
              END;

              IF VATBaseAddCurr = 0 THEN
                VATAmountAddCurr := 0
              ELSE BEGIN
                VATAmountAddCurr := ROUND(CalcLCYToAddCurr(VATAmount),AddCurrency."Amount Rounding Precision");
                PmtDiscAddCurr2 := PmtDiscAddCurr2 + VATAmountAddCurr;
              END;
            END ELSE BEGIN
              VATAmount := 0;
              VATAmountAddCurr := 0;
            END;
      END;
    END;

    LOCAL PROCEDURE InsertPmtDiscVATForVATEntry@43(GenJnlLine@1000 : Record 81;VAR TempVATEntry@1001 : TEMPORARY Record 254;VATEntry2@1004 : Record 254;VATEntryModifier@1002 : Integer;VATAmount@1005 : Decimal;VATAmountAddCurr@1006 : Decimal;VATBase@1007 : Decimal;VATBaseAddCurr@1008 : Decimal;PmtDiscFactorLCY@1009 : Decimal;PmtDiscFactorAddCurr@1010 : Decimal);
    VAR
      TempVATEntryNo@1003 : Integer;
    BEGIN
      TempVATEntry.RESET;
      TempVATEntry.SETRANGE("Entry No.",VATEntryModifier,VATEntryModifier + 999999);
      IF TempVATEntry.FINDLAST THEN
        TempVATEntryNo := TempVATEntry."Entry No." + 1
      ELSE
        TempVATEntryNo := VATEntryModifier + 1;
      TempVATEntry := VATEntry2;
      TempVATEntry."Entry No." := TempVATEntryNo;
      TempVATEntry."Posting Date" := GenJnlLine."Posting Date";
      TempVATEntry."Document No." := GenJnlLine."Document No.";
      TempVATEntry."External Document No." := GenJnlLine."External Document No.";
      TempVATEntry."Document Type" := GenJnlLine."Document Type";
      TempVATEntry."Source Code" := GenJnlLine."Source Code";
      TempVATEntry."Reason Code" := GenJnlLine."Reason Code";
      TempVATEntry."Transaction No." := NextTransactionNo;
      TempVATEntry."Sales Tax Connection No." := NextConnectionNo;
      TempVATEntry."Unrealized Amount" := 0;
      TempVATEntry."Unrealized Base" := 0;
      TempVATEntry."Remaining Unrealized Amount" := 0;
      TempVATEntry."Remaining Unrealized Base" := 0;
      TempVATEntry."User ID" := USERID;
      TempVATEntry."Closed by Entry No." := 0;
      TempVATEntry.Closed := FALSE;
      TempVATEntry."Internal Ref. No." := '';
      TempVATEntry.Amount := VATAmount;
      TempVATEntry."Additional-Currency Amount" := VATAmountAddCurr;
      TempVATEntry."VAT Difference" := 0;
      TempVATEntry."Add.-Curr. VAT Difference" := 0;
      TempVATEntry."Add.-Currency Unrealized Amt." := 0;
      TempVATEntry."Add.-Currency Unrealized Base" := 0;
      IF VATEntry2."Tax on Tax" THEN BEGIN
        TempVATEntry.Base :=
          ROUND((VATEntry2.Base + VATEntry2."Unrealized Base") * PmtDiscFactorLCY);
        TempVATEntry."Additional-Currency Base" :=
          ROUND(
            (VATEntry2."Additional-Currency Base" +
             VATEntry2."Add.-Currency Unrealized Base") * PmtDiscFactorAddCurr,
            AddCurrency."Amount Rounding Precision");
      END ELSE BEGIN
        TempVATEntry.Base := VATBase;
        TempVATEntry."Additional-Currency Base" := VATBaseAddCurr;
      END;

      IF AddCurrencyCode = '' THEN BEGIN
        TempVATEntry."Additional-Currency Base" := 0;
        TempVATEntry."Additional-Currency Amount" := 0;
        TempVATEntry."Add.-Currency Unrealized Amt." := 0;
        TempVATEntry."Add.-Currency Unrealized Base" := 0;
      END;
      TempVATEntry.INSERT;
    END;

    LOCAL PROCEDURE InsertPmtDiscVATForGLEntry@94(GenJnlLine@1000 : Record 81;VAR DtldCVLedgEntryBuf@1001 : Record 383;VAR NewCVLedgEntryBuf@1003 : Record 382;VATEntry2@1004 : Record 254;VAR VATPostingSetup@1005 : Record 325;VAR TaxJurisdiction@1008 : Record 320;EntryType@1002 : Integer;VATAmount@1006 : Decimal;VATAmountAddCurr@1007 : Decimal);
    BEGIN
      DtldCVLedgEntryBuf.INIT;
      DtldCVLedgEntryBuf.CopyFromCVLedgEntryBuf(NewCVLedgEntryBuf);
      CASE EntryType OF
        DtldCVLedgEntryBuf."Entry Type"::"Payment Discount (VAT Excl.)":
          DtldCVLedgEntryBuf."Entry Type" :=
            DtldCVLedgEntryBuf."Entry Type"::"Payment Discount (VAT Adjustment)";
        DtldCVLedgEntryBuf."Entry Type"::"Payment Discount Tolerance (VAT Excl.)":
          DtldCVLedgEntryBuf."Entry Type" :=
            DtldCVLedgEntryBuf."Entry Type"::"Payment Discount Tolerance (VAT Adjustment)";
        DtldCVLedgEntryBuf."Entry Type"::"Payment Tolerance (VAT Excl.)":
          DtldCVLedgEntryBuf."Entry Type" :=
            DtldCVLedgEntryBuf."Entry Type"::"Payment Tolerance (VAT Adjustment)";
      END;
      DtldCVLedgEntryBuf."Posting Date" := GenJnlLine."Posting Date";
      DtldCVLedgEntryBuf."Document Type" := GenJnlLine."Document Type";
      DtldCVLedgEntryBuf."Document No." := GenJnlLine."Document No.";
      DtldCVLedgEntryBuf.Amount := 0;
      DtldCVLedgEntryBuf."VAT Bus. Posting Group" := VATEntry2."VAT Bus. Posting Group";
      DtldCVLedgEntryBuf."VAT Prod. Posting Group" := VATEntry2."VAT Prod. Posting Group";
      DtldCVLedgEntryBuf."Tax Jurisdiction Code" := VATEntry2."Tax Jurisdiction Code";
      // The total payment discount in currency is posted on the entry made in
      // the function CalcPmtDisc.
      DtldCVLedgEntryBuf."User ID" := USERID;
      DtldCVLedgEntryBuf."Use Additional-Currency Amount" := TRUE;

      CASE VATEntry2.Type OF
        VATEntry2.Type::Purchase:
          CASE VATEntry2."VAT Calculation Type" OF
            VATEntry2."VAT Calculation Type"::"Normal VAT",
            VATEntry2."VAT Calculation Type"::"Full VAT":
              BEGIN
                InitGLEntryVAT(GenJnlLine,VATPostingSetup.GetPurchAccount(FALSE),'',
                  VATAmount,VATAmountAddCurr,FALSE);
                DtldCVLedgEntryBuf."Amount (LCY)" := -VATAmount;
                DtldCVLedgEntryBuf."Additional-Currency Amount" := -VATAmountAddCurr;
                DtldCVLedgEntryBuf.InsertDtldCVLedgEntry(DtldCVLedgEntryBuf,NewCVLedgEntryBuf,TRUE);
              END;
            VATEntry2."VAT Calculation Type"::"Reverse Charge VAT":
              BEGIN
                InitGLEntryVAT(GenJnlLine,VATPostingSetup.GetPurchAccount(FALSE),'',
                  VATAmount,VATAmountAddCurr,FALSE);
                InitGLEntryVAT(GenJnlLine,VATPostingSetup.GetRevChargeAccount(FALSE),'',
                  -VATAmount,-VATAmountAddCurr,FALSE);
              END;
            VATEntry2."VAT Calculation Type"::"Sales Tax":
              IF VATEntry2."Use Tax" THEN BEGIN
                InitGLEntryVAT(GenJnlLine,TaxJurisdiction.GetPurchAccount(FALSE),'',
                  VATAmount,VATAmountAddCurr,FALSE);
                InitGLEntryVAT(GenJnlLine,TaxJurisdiction.GetRevChargeAccount(FALSE),'',
                  -VATAmount,-VATAmountAddCurr,FALSE);
              END ELSE BEGIN
                InitGLEntryVAT(GenJnlLine,TaxJurisdiction.GetPurchAccount(FALSE),'',
                  VATAmount,VATAmountAddCurr,FALSE);
                DtldCVLedgEntryBuf."Amount (LCY)" := -VATAmount;
                DtldCVLedgEntryBuf."Additional-Currency Amount" := -VATAmountAddCurr;
                DtldCVLedgEntryBuf.InsertDtldCVLedgEntry(DtldCVLedgEntryBuf,NewCVLedgEntryBuf,TRUE);
              END;
          END;
        VATEntry2.Type::Sale:
          CASE VATEntry2."VAT Calculation Type" OF
            VATEntry2."VAT Calculation Type"::"Normal VAT",
            VATEntry2."VAT Calculation Type"::"Full VAT":
              BEGIN
                InitGLEntryVAT(
                  GenJnlLine,VATPostingSetup.GetSalesAccount(FALSE),'',
                  VATAmount,VATAmountAddCurr,FALSE);
                DtldCVLedgEntryBuf."Amount (LCY)" := -VATAmount;
                DtldCVLedgEntryBuf."Additional-Currency Amount" := -VATAmountAddCurr;
                DtldCVLedgEntryBuf.InsertDtldCVLedgEntry(DtldCVLedgEntryBuf,NewCVLedgEntryBuf,TRUE);
              END;
            VATEntry2."VAT Calculation Type"::"Reverse Charge VAT":
              ;
            VATEntry2."VAT Calculation Type"::"Sales Tax":
              BEGIN
                InitGLEntryVAT(
                  GenJnlLine,TaxJurisdiction.GetSalesAccount(FALSE),'',
                  VATAmount,VATAmountAddCurr,FALSE);
                DtldCVLedgEntryBuf."Amount (LCY)" := -VATAmount;
                DtldCVLedgEntryBuf."Additional-Currency Amount" := -VATAmountAddCurr;
                DtldCVLedgEntryBuf.InsertDtldCVLedgEntry(DtldCVLedgEntryBuf,NewCVLedgEntryBuf,TRUE);
              END;
          END;
      END;
    END;

    LOCAL PROCEDURE CalcCurrencyApplnRounding@51(VAR NewCVLedgEntryBuf@1000 : Record 382;VAR OldCVLedgEntryBuf@1001 : Record 382;VAR DtldCVLedgEntryBuf@1002 : Record 383;GenJnlLine@1003 : Record 81;ApplnRoundingPrecision@1005 : Decimal);
    VAR
      ApplnRounding@1006 : Decimal;
      ApplnRoundingLCY@1007 : Decimal;
    BEGIN
      IF ((NewCVLedgEntryBuf."Document Type" <> NewCVLedgEntryBuf."Document Type"::Payment) AND
          (NewCVLedgEntryBuf."Document Type" <> NewCVLedgEntryBuf."Document Type"::Refund)) OR
         (NewCVLedgEntryBuf."Currency Code" = OldCVLedgEntryBuf."Currency Code")
      THEN
        EXIT;

      ApplnRounding := -(NewCVLedgEntryBuf."Remaining Amount" + OldCVLedgEntryBuf."Remaining Amount");
      ApplnRoundingLCY := ROUND(ApplnRounding / NewCVLedgEntryBuf."Adjusted Currency Factor");

      IF (ApplnRounding = 0) OR (ABS(ApplnRounding) > ApplnRoundingPrecision) THEN
        EXIT;

      DtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(
        GenJnlLine,NewCVLedgEntryBuf,DtldCVLedgEntryBuf,
        DtldCVLedgEntryBuf."Entry Type"::"Appln. Rounding",ApplnRounding,ApplnRoundingLCY,ApplnRounding,0,0,0);
    END;

    LOCAL PROCEDURE FindAmtForAppln@6(VAR NewCVLedgEntryBuf@1000 : Record 382;VAR OldCVLedgEntryBuf@1001 : Record 382;VAR OldCVLedgEntryBuf2@1002 : Record 382;VAR AppliedAmount@1003 : Decimal;VAR AppliedAmountLCY@1004 : Decimal;VAR OldAppliedAmount@1005 : Decimal;ApplnRoundingPrecision@1007 : Decimal);
    BEGIN
      IF OldCVLedgEntryBuf2.GETFILTER(Positive) <> '' THEN BEGIN
        IF OldCVLedgEntryBuf2."Amount to Apply" <> 0 THEN BEGIN
          IF (PaymentToleranceMgt.CheckCalcPmtDisc(NewCVLedgEntryBuf,OldCVLedgEntryBuf2,ApplnRoundingPrecision,FALSE,FALSE) AND
              (ABS(OldCVLedgEntryBuf2."Amount to Apply") >=
               ABS(OldCVLedgEntryBuf2."Remaining Amount" - OldCVLedgEntryBuf2."Remaining Pmt. Disc. Possible")))
          THEN
            AppliedAmount := -OldCVLedgEntryBuf2."Remaining Amount"
          ELSE
            AppliedAmount := -OldCVLedgEntryBuf2."Amount to Apply"
        END ELSE
          AppliedAmount := -OldCVLedgEntryBuf2."Remaining Amount";
      END ELSE BEGIN
        IF OldCVLedgEntryBuf2."Amount to Apply" <> 0 THEN
          IF (PaymentToleranceMgt.CheckCalcPmtDisc(NewCVLedgEntryBuf,OldCVLedgEntryBuf2,ApplnRoundingPrecision,FALSE,FALSE) AND
              (ABS(OldCVLedgEntryBuf2."Amount to Apply") >=
               ABS(OldCVLedgEntryBuf2."Remaining Amount" - OldCVLedgEntryBuf2."Remaining Pmt. Disc. Possible")) AND
              (ABS(NewCVLedgEntryBuf."Remaining Amount") >=
               ABS(
                 ABSMin(
                   OldCVLedgEntryBuf2."Remaining Amount" - OldCVLedgEntryBuf2."Remaining Pmt. Disc. Possible",
                   OldCVLedgEntryBuf2."Amount to Apply")))) OR
             OldCVLedgEntryBuf."Accepted Pmt. Disc. Tolerance"
          THEN BEGIN
            AppliedAmount := -OldCVLedgEntryBuf2."Remaining Amount";
            OldCVLedgEntryBuf."Accepted Pmt. Disc. Tolerance" := FALSE;
          END ELSE
            AppliedAmount := ABSMin(NewCVLedgEntryBuf."Remaining Amount",-OldCVLedgEntryBuf2."Amount to Apply")
        ELSE
          AppliedAmount := ABSMin(NewCVLedgEntryBuf."Remaining Amount",-OldCVLedgEntryBuf2."Remaining Amount");
      END;

      IF (ABS(OldCVLedgEntryBuf2."Remaining Amount" - OldCVLedgEntryBuf2."Amount to Apply") < ApplnRoundingPrecision) AND
         (ApplnRoundingPrecision <> 0) AND
         (OldCVLedgEntryBuf2."Amount to Apply" <> 0)
      THEN
        AppliedAmount := AppliedAmount - (OldCVLedgEntryBuf2."Remaining Amount" - OldCVLedgEntryBuf2."Amount to Apply");

      IF NewCVLedgEntryBuf."Currency Code" = OldCVLedgEntryBuf2."Currency Code" THEN BEGIN
        AppliedAmountLCY := ROUND(AppliedAmount / OldCVLedgEntryBuf."Original Currency Factor");
        OldAppliedAmount := AppliedAmount;
      END ELSE BEGIN
        // Management of posting in multiple currencies
        IF AppliedAmount = -OldCVLedgEntryBuf2."Remaining Amount" THEN
          OldAppliedAmount := -OldCVLedgEntryBuf."Remaining Amount"
        ELSE
          OldAppliedAmount :=
            CurrExchRate.ExchangeAmount(
              AppliedAmount,NewCVLedgEntryBuf."Currency Code",
              OldCVLedgEntryBuf2."Currency Code",NewCVLedgEntryBuf."Posting Date");

        IF NewCVLedgEntryBuf."Currency Code" <> '' THEN
          // Post the realized gain or loss on the NewCVLedgEntryBuf
          AppliedAmountLCY := ROUND(OldAppliedAmount / OldCVLedgEntryBuf."Original Currency Factor")
        ELSE
          // Post the realized gain or loss on the OldCVLedgEntryBuf
          AppliedAmountLCY := ROUND(AppliedAmount / NewCVLedgEntryBuf."Original Currency Factor");
      END;
    END;

    LOCAL PROCEDURE CalcCurrencyUnrealizedGainLoss@48(VAR CVLedgEntryBuf@1000 : Record 382;VAR TempDtldCVLedgEntryBuf@1002 : TEMPORARY Record 383;GenJnlLine@1003 : Record 81;AppliedAmount@1004 : Decimal;RemainingAmountBeforeAppln@1007 : Decimal);
    VAR
      DtldCustLedgEntry@1008 : Record 379;
      DtldVendLedgEntry@1009 : Record 380;
      UnRealizedGainLossLCY@1001 : Decimal;
    BEGIN
      IF (CVLedgEntryBuf."Currency Code" = '') OR (RemainingAmountBeforeAppln = 0) THEN
        EXIT;

      // Calculate Unrealized GainLoss
      IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer THEN
        UnRealizedGainLossLCY :=
          ROUND(
            DtldCustLedgEntry.GetUnrealizedGainLossAmount(CVLedgEntryBuf."Entry No.") *
            ABS(AppliedAmount / RemainingAmountBeforeAppln))
      ELSE
        UnRealizedGainLossLCY :=
          ROUND(
            DtldVendLedgEntry.GetUnrealizedGainLossAmount(CVLedgEntryBuf."Entry No.") *
            ABS(AppliedAmount / RemainingAmountBeforeAppln));

      IF UnRealizedGainLossLCY <> 0 THEN
        IF UnRealizedGainLossLCY < 0 THEN
          TempDtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(
            GenJnlLine,CVLedgEntryBuf,TempDtldCVLedgEntryBuf,
            TempDtldCVLedgEntryBuf."Entry Type"::"Unrealized Loss",0,-UnRealizedGainLossLCY,0,0,0,0)
        ELSE
          TempDtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(
            GenJnlLine,CVLedgEntryBuf,TempDtldCVLedgEntryBuf,
            TempDtldCVLedgEntryBuf."Entry Type"::"Unrealized Gain",0,-UnRealizedGainLossLCY,0,0,0,0);
    END;

    LOCAL PROCEDURE CalcCurrencyRealizedGainLoss@62(VAR CVLedgEntryBuf@1005 : Record 382;VAR TempDtldCVLedgEntryBuf@1003 : TEMPORARY Record 383;GenJnlLine@1002 : Record 81;AppliedAmount@1001 : Decimal;AppliedAmountLCY@1000 : Decimal);
    VAR
      RealizedGainLossLCY@1006 : Decimal;
    BEGIN
      IF CVLedgEntryBuf."Currency Code" = '' THEN
        EXIT;

      // Calculate Realized GainLoss
      RealizedGainLossLCY :=
        AppliedAmountLCY - ROUND(AppliedAmount / CVLedgEntryBuf."Original Currency Factor");
      IF RealizedGainLossLCY <> 0 THEN
        IF RealizedGainLossLCY < 0 THEN
          TempDtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(
            GenJnlLine,CVLedgEntryBuf,TempDtldCVLedgEntryBuf,
            TempDtldCVLedgEntryBuf."Entry Type"::"Realized Loss",0,RealizedGainLossLCY,0,0,0,0)
        ELSE
          TempDtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(
            GenJnlLine,CVLedgEntryBuf,TempDtldCVLedgEntryBuf,
            TempDtldCVLedgEntryBuf."Entry Type"::"Realized Gain",0,RealizedGainLossLCY,0,0,0,0);
    END;

    LOCAL PROCEDURE CalcApplication@55(VAR NewCVLedgEntryBuf@1000 : Record 382;VAR OldCVLedgEntryBuf@1001 : Record 382;VAR DtldCVLedgEntryBuf@1002 : Record 383;GenJnlLine@1003 : Record 81;AppliedAmount@1004 : Decimal;AppliedAmountLCY@1005 : Decimal;OldAppliedAmount@1006 : Decimal;PrevNewCVLedgEntryBuf@1008 : Record 382;PrevOldCVLedgEntryBuf@1007 : Record 382;VAR AllApplied@1009 : Boolean);
    BEGIN
      IF AppliedAmount = 0 THEN
        EXIT;

      DtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(
        GenJnlLine,OldCVLedgEntryBuf,DtldCVLedgEntryBuf,
        DtldCVLedgEntryBuf."Entry Type"::Application,OldAppliedAmount,AppliedAmountLCY,0,
        NewCVLedgEntryBuf."Entry No.",PrevOldCVLedgEntryBuf."Remaining Pmt. Disc. Possible",
        PrevOldCVLedgEntryBuf."Max. Payment Tolerance");

      OldCVLedgEntryBuf.Open := OldCVLedgEntryBuf."Remaining Amount" <> 0;
      IF NOT OldCVLedgEntryBuf.Open THEN
        OldCVLedgEntryBuf.SetClosedFields(
          NewCVLedgEntryBuf."Entry No.",GenJnlLine."Posting Date",
          -OldAppliedAmount,-AppliedAmountLCY,NewCVLedgEntryBuf."Currency Code",-AppliedAmount)
      ELSE
        AllApplied := FALSE;

      DtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(
        GenJnlLine,NewCVLedgEntryBuf,DtldCVLedgEntryBuf,
        DtldCVLedgEntryBuf."Entry Type"::Application,-AppliedAmount,-AppliedAmountLCY,0,
        NewCVLedgEntryBuf."Entry No.",PrevNewCVLedgEntryBuf."Remaining Pmt. Disc. Possible",
        PrevNewCVLedgEntryBuf."Max. Payment Tolerance");

      NewCVLedgEntryBuf.Open := NewCVLedgEntryBuf."Remaining Amount" <> 0;
      IF NOT NewCVLedgEntryBuf.Open AND NOT AllApplied THEN
        NewCVLedgEntryBuf.SetClosedFields(
          OldCVLedgEntryBuf."Entry No.",GenJnlLine."Posting Date",
          AppliedAmount,AppliedAmountLCY,OldCVLedgEntryBuf."Currency Code",OldAppliedAmount);
    END;

    LOCAL PROCEDURE CalcAmtLCYAdjustment@52(VAR CVLedgEntryBuf@1000 : Record 382;VAR DtldCVLedgEntryBuf@1002 : Record 383;GenJnlLine@1003 : Record 81);
    VAR
      AdjustedAmountLCY@1005 : Decimal;
    BEGIN
      IF CVLedgEntryBuf."Currency Code" = '' THEN
        EXIT;

      AdjustedAmountLCY :=
        ROUND(CVLedgEntryBuf."Remaining Amount" / CVLedgEntryBuf."Adjusted Currency Factor");

      IF AdjustedAmountLCY <> CVLedgEntryBuf."Remaining Amt. (LCY)" THEN BEGIN
        DtldCVLedgEntryBuf.InitFromGenJnlLine(GenJnlLine);
        DtldCVLedgEntryBuf.CopyFromCVLedgEntryBuf(CVLedgEntryBuf);
        DtldCVLedgEntryBuf."Entry Type" :=
          DtldCVLedgEntryBuf."Entry Type"::"Correction of Remaining Amount";
        DtldCVLedgEntryBuf."Amount (LCY)" := AdjustedAmountLCY - CVLedgEntryBuf."Remaining Amt. (LCY)";
        DtldCVLedgEntryBuf.InsertDtldCVLedgEntry(DtldCVLedgEntryBuf,CVLedgEntryBuf,FALSE);
      END;
    END;

    LOCAL PROCEDURE InitBankAccLedgEntry@59(GenJnlLine@1000 : Record 81;VAR BankAccLedgEntry@1001 : Record 271);
    BEGIN
      BankAccLedgEntry.INIT;
      BankAccLedgEntry.CopyFromGenJnlLine(GenJnlLine);
      BankAccLedgEntry."Entry No." := NextEntryNo;
      BankAccLedgEntry."Transaction No." := NextTransactionNo;
    END;

    LOCAL PROCEDURE InitCheckLedgEntry@65(BankAccLedgEntry@1000 : Record 271;VAR CheckLedgEntry@1001 : Record 272);
    BEGIN
      CheckLedgEntry.INIT;
      CheckLedgEntry.CopyFromBankAccLedgEntry(BankAccLedgEntry);
      CheckLedgEntry."Entry No." := NextCheckEntryNo;
    END;

    LOCAL PROCEDURE InitCustLedgEntry@57(GenJnlLine@1000 : Record 81;VAR CustLedgEntry@1001 : Record 21);
    BEGIN
      CustLedgEntry.INIT;
      CustLedgEntry.CopyFromGenJnlLine(GenJnlLine);
      CustLedgEntry."Entry No." := NextEntryNo;
      CustLedgEntry."Transaction No." := NextTransactionNo;
    END;

    LOCAL PROCEDURE InitVendLedgEntry@58(GenJnlLine@1001 : Record 81;VAR VendLedgEntry@1000 : Record 25);
    BEGIN
      VendLedgEntry.INIT;
      VendLedgEntry.CopyFromGenJnlLine(GenJnlLine);
      VendLedgEntry."Entry No." := NextEntryNo;
      VendLedgEntry."Transaction No." := NextTransactionNo;
    END;

    LOCAL PROCEDURE InitEmployeeLedgerEntry@134(GenJnlLine@1001 : Record 81;VAR EmployeeLedgerEntry@1000 : Record 5222);
    BEGIN
      EmployeeLedgerEntry.INIT;
      EmployeeLedgerEntry.CopyFromGenJnlLine(GenJnlLine);
      EmployeeLedgerEntry."Entry No." := NextEntryNo;
      EmployeeLedgerEntry."Transaction No." := NextTransactionNo;
    END;

    LOCAL PROCEDURE InsertDtldCustLedgEntry@102(GenJnlLine@1003 : Record 81;DtldCVLedgEntryBuf@1002 : Record 383;VAR DtldCustLedgEntry@1001 : Record 379;Offset@1000 : Integer);
    BEGIN
      WITH DtldCustLedgEntry DO BEGIN
        INIT;
        TRANSFERFIELDS(DtldCVLedgEntryBuf);
        "Entry No." := Offset + DtldCVLedgEntryBuf."Entry No.";
        "Journal Batch Name" := GenJnlLine."Journal Batch Name";
        "Reason Code" := GenJnlLine."Reason Code";
        "Source Code" := GenJnlLine."Source Code";
        "Transaction No." := NextTransactionNo;
        UpdateDebitCredit(GenJnlLine.Correction);
        INSERT(TRUE);
      END;
    END;

    LOCAL PROCEDURE InsertDtldVendLedgEntry@103(GenJnlLine@1000 : Record 81;DtldCVLedgEntryBuf@1001 : Record 383;VAR DtldVendLedgEntry@1004 : Record 380;Offset@1002 : Integer);
    BEGIN
      WITH DtldVendLedgEntry DO BEGIN
        INIT;
        TRANSFERFIELDS(DtldCVLedgEntryBuf);
        "Entry No." := Offset + DtldCVLedgEntryBuf."Entry No.";
        "Journal Batch Name" := GenJnlLine."Journal Batch Name";
        "Reason Code" := GenJnlLine."Reason Code";
        "Source Code" := GenJnlLine."Source Code";
        "Transaction No." := NextTransactionNo;
        UpdateDebitCredit(GenJnlLine.Correction);
        INSERT(TRUE);
      END;
    END;

    LOCAL PROCEDURE InsertDtldEmplLedgEntry@143(GenJnlLine@1000 : Record 81;DtldCVLedgEntryBuf@1001 : Record 383;VAR DtldEmplLedgEntry@1004 : Record 5223;Offset@1002 : Integer);
    BEGIN
      WITH DtldEmplLedgEntry DO BEGIN
        INIT;
        TRANSFERFIELDS(DtldCVLedgEntryBuf);
        "Entry No." := Offset + DtldCVLedgEntryBuf."Entry No.";
        "Journal Batch Name" := GenJnlLine."Journal Batch Name";
        "Reason Code" := GenJnlLine."Reason Code";
        "Source Code" := GenJnlLine."Source Code";
        "Transaction No." := NextTransactionNo;
        UpdateDebitCredit(GenJnlLine.Correction);
        INSERT(TRUE);
      END;
    END;

    LOCAL PROCEDURE ApplyCustLedgEntry@1(VAR NewCVLedgEntryBuf@1000 : Record 382;VAR DtldCVLedgEntryBuf@1001 : Record 383;GenJnlLine@1002 : Record 81;Cust@1003 : Record 18);
    VAR
      OldCustLedgEntry@1005 : Record 21;
      OldCVLedgEntryBuf@1006 : Record 382;
      NewCustLedgEntry@1008 : Record 21;
      NewCVLedgEntryBuf2@1019 : Record 382;
      TempOldCustLedgEntry@1021 : TEMPORARY Record 21;
      Completed@1009 : Boolean;
      AppliedAmount@1010 : Decimal;
      NewRemainingAmtBeforeAppln@1014 : Decimal;
      ApplyingDate@1017 : Date;
      PmtTolAmtToBeApplied@1020 : Decimal;
      AllApplied@1024 : Boolean;
    BEGIN
      IF NewCVLedgEntryBuf."Amount to Apply" = 0 THEN
        EXIT;

      AllApplied := TRUE;
      IF (GenJnlLine."Applies-to Doc. No." = '') AND (GenJnlLine."Applies-to ID" = '') AND
         NOT
         ((Cust."Application Method" = Cust."Application Method"::"Apply to Oldest") AND
          GenJnlLine."Allow Application")
      THEN
        EXIT;

      PmtTolAmtToBeApplied := 0;
      NewRemainingAmtBeforeAppln := NewCVLedgEntryBuf."Remaining Amount";
      NewCVLedgEntryBuf2 := NewCVLedgEntryBuf;

      ApplyingDate := GenJnlLine."Posting Date";

      IF NOT PrepareTempCustLedgEntry(GenJnlLine,NewCVLedgEntryBuf,TempOldCustLedgEntry,Cust,ApplyingDate) THEN
        EXIT;

      GenJnlLine."Posting Date" := ApplyingDate;
      // Apply the new entry (Payment) to the old entries (Invoices) one at a time
      REPEAT
        TempOldCustLedgEntry.CALCFIELDS(
          Amount,"Amount (LCY)","Remaining Amount","Remaining Amt. (LCY)",
          "Original Amount","Original Amt. (LCY)");
        TempOldCustLedgEntry.COPYFILTER(Positive,OldCVLedgEntryBuf.Positive);
        OldCVLedgEntryBuf.CopyFromCustLedgEntry(TempOldCustLedgEntry);

        PostApply(
          GenJnlLine,DtldCVLedgEntryBuf,OldCVLedgEntryBuf,NewCVLedgEntryBuf,NewCVLedgEntryBuf2,
          Cust."Block Payment Tolerance",AllApplied,AppliedAmount,PmtTolAmtToBeApplied);

        IF NOT OldCVLedgEntryBuf.Open THEN BEGIN
          UpdateCalcInterest(OldCVLedgEntryBuf);
          UpdateCalcInterest2(OldCVLedgEntryBuf,NewCVLedgEntryBuf);
        END;

        TempOldCustLedgEntry.CopyFromCVLedgEntryBuffer(OldCVLedgEntryBuf);
        OldCustLedgEntry := TempOldCustLedgEntry;
        OldCustLedgEntry."Applies-to ID" := '';
        OldCustLedgEntry."Amount to Apply" := 0;
        OldCustLedgEntry.MODIFY;

        IF GLSetup."Unrealized VAT" OR
           (GLSetup."Prepayment Unrealized VAT" AND TempOldCustLedgEntry.Prepayment)
        THEN
          IF IsNotPayment(TempOldCustLedgEntry."Document Type") THEN BEGIN
            TempOldCustLedgEntry.RecalculateAmounts(
              NewCVLedgEntryBuf."Currency Code",TempOldCustLedgEntry."Currency Code",NewCVLedgEntryBuf."Posting Date");
            CustUnrealizedVAT(
              GenJnlLine,
              TempOldCustLedgEntry,
              CurrExchRate.ExchangeAmount(
                AppliedAmount,NewCVLedgEntryBuf."Currency Code",
                TempOldCustLedgEntry."Currency Code",NewCVLedgEntryBuf."Posting Date"));
          END;

        TempOldCustLedgEntry.DELETE;

        // Find the next old entry for application of the new entry
        IF GenJnlLine."Applies-to Doc. No." <> '' THEN
          Completed := TRUE
        ELSE
          IF TempOldCustLedgEntry.GETFILTER(Positive) <> '' THEN
            IF TempOldCustLedgEntry.NEXT = 1 THEN
              Completed := FALSE
            ELSE BEGIN
              TempOldCustLedgEntry.SETRANGE(Positive);
              TempOldCustLedgEntry.FIND('-');
              TempOldCustLedgEntry.CALCFIELDS("Remaining Amount");
              Completed := TempOldCustLedgEntry."Remaining Amount" * NewCVLedgEntryBuf."Remaining Amount" >= 0;
            END
          ELSE
            IF NewCVLedgEntryBuf.Open THEN
              Completed := TempOldCustLedgEntry.NEXT = 0
            ELSE
              Completed := TRUE;
      UNTIL Completed;

      DtldCVLedgEntryBuf.SETCURRENTKEY("CV Ledger Entry No.","Entry Type");
      DtldCVLedgEntryBuf.SETRANGE("CV Ledger Entry No.",NewCVLedgEntryBuf."Entry No.");
      DtldCVLedgEntryBuf.SETRANGE(
        "Entry Type",
        DtldCVLedgEntryBuf."Entry Type"::Application);
      DtldCVLedgEntryBuf.CALCSUMS("Amount (LCY)",Amount);

      CalcCurrencyUnrealizedGainLoss(
        NewCVLedgEntryBuf,DtldCVLedgEntryBuf,GenJnlLine,DtldCVLedgEntryBuf.Amount,NewRemainingAmtBeforeAppln);

      CalcAmtLCYAdjustment(NewCVLedgEntryBuf,DtldCVLedgEntryBuf,GenJnlLine);

      NewCVLedgEntryBuf."Applies-to ID" := '';
      NewCVLedgEntryBuf."Amount to Apply" := 0;

      IF NOT NewCVLedgEntryBuf.Open THEN
        UpdateCalcInterest(NewCVLedgEntryBuf);

      IF GLSetup."Unrealized VAT" OR
         (GLSetup."Prepayment Unrealized VAT" AND NewCVLedgEntryBuf.Prepayment)
      THEN
        IF IsNotPayment(NewCVLedgEntryBuf."Document Type") AND
           (NewRemainingAmtBeforeAppln - NewCVLedgEntryBuf."Remaining Amount" <> 0)
        THEN BEGIN
          NewCustLedgEntry.CopyFromCVLedgEntryBuffer(NewCVLedgEntryBuf);
          CheckUnrealizedCust := TRUE;
          UnrealizedCustLedgEntry := NewCustLedgEntry;
          UnrealizedCustLedgEntry.CALCFIELDS("Amount (LCY)","Original Amt. (LCY)");
          UnrealizedRemainingAmountCust := NewCustLedgEntry."Remaining Amount" - NewRemainingAmtBeforeAppln;
        END;
    END;

    [External]
    PROCEDURE CustPostApplyCustLedgEntry@74(VAR GenJnlLinePostApply@1000 : Record 81;VAR CustLedgEntryPostApply@1001 : Record 21);
    VAR
      Cust@1002 : Record 18;
      CustPostingGr@1007 : Record 92;
      CustLedgEntry@1006 : Record 21;
      DtldCustLedgEntry@1003 : Record 379;
      TempDtldCVLedgEntryBuf@1004 : TEMPORARY Record 383;
      CVLedgEntryBuf@1005 : Record 382;
      GenJnlLine@1008 : Record 81;
      DtldLedgEntryInserted@1009 : Boolean;
    BEGIN
      GenJnlLine := GenJnlLinePostApply;
      CustLedgEntry.TRANSFERFIELDS(CustLedgEntryPostApply);
      WITH GenJnlLine DO BEGIN
        "Source Currency Code" := CustLedgEntryPostApply."Currency Code";
        "Applies-to ID" := CustLedgEntryPostApply."Applies-to ID";

        GenJnlCheckLine.RunCheck(GenJnlLine);

        IF NextEntryNo = 0 THEN
          StartPosting(GenJnlLine)
        ELSE
          ContinuePosting(GenJnlLine);

        Cust.GET(CustLedgEntry."Customer No.");
        Cust.CheckBlockedCustOnJnls(Cust,"Document Type",TRUE);

        IF "Posting Group" = '' THEN BEGIN
          Cust.TESTFIELD("Customer Posting Group");
          "Posting Group" := Cust."Customer Posting Group";
        END;
        CustPostingGr.GET("Posting Group");
        CustPostingGr.GetReceivablesAccount;

        DtldCustLedgEntry.LOCKTABLE;
        CustLedgEntry.LOCKTABLE;

        // Post the application
        CustLedgEntry.CALCFIELDS(
          Amount,"Amount (LCY)","Remaining Amount","Remaining Amt. (LCY)",
          "Original Amount","Original Amt. (LCY)");
        CVLedgEntryBuf.CopyFromCustLedgEntry(CustLedgEntry);
        ApplyCustLedgEntry(CVLedgEntryBuf,TempDtldCVLedgEntryBuf,GenJnlLine,Cust);
        CustLedgEntry.CopyFromCVLedgEntryBuffer(CVLedgEntryBuf);
        CustLedgEntry.MODIFY;

        // Post the Dtld customer entry
        DtldLedgEntryInserted := PostDtldCustLedgEntries(GenJnlLine,TempDtldCVLedgEntryBuf,CustPostingGr,FALSE);

        CheckPostUnrealizedVAT(GenJnlLine,TRUE);

        IF DtldLedgEntryInserted THEN
          IF IsTempGLEntryBufEmpty THEN
            DtldCustLedgEntry.SetZeroTransNo(NextTransactionNo);
        FinishPosting;
      END;
    END;

    LOCAL PROCEDURE PrepareTempCustLedgEntry@111(GenJnlLine@1000 : Record 81;VAR NewCVLedgEntryBuf@1015 : Record 382;VAR TempOldCustLedgEntry@1010 : TEMPORARY Record 21;Cust@1016 : Record 18;VAR ApplyingDate@1001 : Date) : Boolean;
    VAR
      OldCustLedgEntry@1014 : Record 21;
      SalesSetup@1009 : Record 311;
      GenJnlApply@1008 : Codeunit 225;
      RemainingAmount@1002 : Decimal;
    BEGIN
      IF GenJnlLine."Applies-to Doc. No." <> '' THEN BEGIN
        // Find the entry to be applied to
        OldCustLedgEntry.RESET;
        OldCustLedgEntry.SETCURRENTKEY("Document No.");
        OldCustLedgEntry.SETRANGE("Document No.",GenJnlLine."Applies-to Doc. No.");
        OldCustLedgEntry.SETRANGE("Document Type",GenJnlLine."Applies-to Doc. Type");
        OldCustLedgEntry.SETRANGE("Customer No.",NewCVLedgEntryBuf."CV No.");
        OldCustLedgEntry.SETRANGE(Open,TRUE);

        OldCustLedgEntry.FINDFIRST;
        OldCustLedgEntry.TESTFIELD(Positive,NOT NewCVLedgEntryBuf.Positive);
        IF OldCustLedgEntry."Posting Date" > ApplyingDate THEN
          ApplyingDate := OldCustLedgEntry."Posting Date";
        GenJnlApply.CheckAgainstApplnCurrency(
          NewCVLedgEntryBuf."Currency Code",OldCustLedgEntry."Currency Code",GenJnlLine."Account Type"::Customer,TRUE);
        TempOldCustLedgEntry := OldCustLedgEntry;
        TempOldCustLedgEntry.INSERT;
      END ELSE BEGIN
        // Find the first old entry (Invoice) which the new entry (Payment) should apply to
        OldCustLedgEntry.RESET;
        OldCustLedgEntry.SETCURRENTKEY("Customer No.","Applies-to ID",Open,Positive,"Due Date");
        TempOldCustLedgEntry.SETCURRENTKEY("Customer No.","Applies-to ID",Open,Positive,"Due Date");
        OldCustLedgEntry.SETRANGE("Customer No.",NewCVLedgEntryBuf."CV No.");
        OldCustLedgEntry.SETRANGE("Applies-to ID",GenJnlLine."Applies-to ID");
        OldCustLedgEntry.SETRANGE(Open,TRUE);
        OldCustLedgEntry.SETFILTER("Entry No.",'<>%1',NewCVLedgEntryBuf."Entry No.");
        IF NOT (Cust."Application Method" = Cust."Application Method"::"Apply to Oldest") THEN
          OldCustLedgEntry.SETFILTER("Amount to Apply",'<>%1',0);

        IF Cust."Application Method" = Cust."Application Method"::"Apply to Oldest" THEN
          OldCustLedgEntry.SETFILTER("Posting Date",'..%1',GenJnlLine."Posting Date");

        // Check Cust Ledger Entry and add to Temp.
        SalesSetup.GET;
        IF SalesSetup."Appln. between Currencies" = SalesSetup."Appln. between Currencies"::None THEN
          OldCustLedgEntry.SETRANGE("Currency Code",NewCVLedgEntryBuf."Currency Code");
        IF OldCustLedgEntry.FINDSET(FALSE,FALSE) THEN
          REPEAT
            IF GenJnlApply.CheckAgainstApplnCurrency(
                 NewCVLedgEntryBuf."Currency Code",OldCustLedgEntry."Currency Code",GenJnlLine."Account Type"::Customer,FALSE)
            THEN BEGIN
              IF (OldCustLedgEntry."Posting Date" > ApplyingDate) AND (OldCustLedgEntry."Applies-to ID" <> '') THEN
                ApplyingDate := OldCustLedgEntry."Posting Date";
              TempOldCustLedgEntry := OldCustLedgEntry;
              TempOldCustLedgEntry.INSERT;
            END;
          UNTIL OldCustLedgEntry.NEXT = 0;

        TempOldCustLedgEntry.SETRANGE(Positive,NewCVLedgEntryBuf."Remaining Amount" > 0);

        IF TempOldCustLedgEntry.FIND('-') THEN BEGIN
          RemainingAmount := NewCVLedgEntryBuf."Remaining Amount";
          TempOldCustLedgEntry.SETRANGE(Positive);
          TempOldCustLedgEntry.FIND('-');
          REPEAT
            TempOldCustLedgEntry.CALCFIELDS("Remaining Amount");
            TempOldCustLedgEntry.RecalculateAmounts(
              TempOldCustLedgEntry."Currency Code",NewCVLedgEntryBuf."Currency Code",NewCVLedgEntryBuf."Posting Date");
            IF PaymentToleranceMgt.CheckCalcPmtDiscCVCust(NewCVLedgEntryBuf,TempOldCustLedgEntry,0,FALSE,FALSE) THEN
              TempOldCustLedgEntry."Remaining Amount" -= TempOldCustLedgEntry."Remaining Pmt. Disc. Possible";
            RemainingAmount += TempOldCustLedgEntry."Remaining Amount";
          UNTIL TempOldCustLedgEntry.NEXT = 0;
          TempOldCustLedgEntry.SETRANGE(Positive,RemainingAmount < 0);
        END ELSE
          TempOldCustLedgEntry.SETRANGE(Positive);

        EXIT(TempOldCustLedgEntry.FIND('-'));
      END;
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE PostDtldCustLedgEntries@46(GenJnlLine@1000 : Record 81;VAR DtldCVLedgEntryBuf@1001 : Record 383;CustPostingGr@1002 : Record 92;LedgEntryInserted@1012 : Boolean) DtldLedgEntryInserted : Boolean;
    VAR
      TempInvPostBuf@1011 : TEMPORARY Record 49;
      DtldCustLedgEntry@1005 : Record 379;
      AdjAmount@1003 : ARRAY [4] OF Decimal;
      DtldCustLedgEntryNoOffset@1006 : Integer;
      SaveEntryNo@1014 : Integer;
    BEGIN
      IF GenJnlLine."Account Type" <> GenJnlLine."Account Type"::Customer THEN
        EXIT;

      IF DtldCustLedgEntry.FINDLAST THEN
        DtldCustLedgEntryNoOffset := DtldCustLedgEntry."Entry No."
      ELSE
        DtldCustLedgEntryNoOffset := 0;

      DtldCVLedgEntryBuf.RESET;
      IF DtldCVLedgEntryBuf.FINDSET THEN BEGIN
        IF LedgEntryInserted THEN BEGIN
          SaveEntryNo := NextEntryNo;
          NextEntryNo := NextEntryNo + 1;
        END;
        REPEAT
          InsertDtldCustLedgEntry(GenJnlLine,DtldCVLedgEntryBuf,DtldCustLedgEntry,DtldCustLedgEntryNoOffset);

          UpdateTotalAmounts(
            TempInvPostBuf,GenJnlLine."Dimension Set ID",
            DtldCVLedgEntryBuf."Amount (LCY)",DtldCVLedgEntryBuf."Additional-Currency Amount");

          // Post automatic entries.
          IF ((DtldCVLedgEntryBuf."Amount (LCY)" <> 0) OR
              (DtldCVLedgEntryBuf."VAT Amount (LCY)" <> 0)) OR
             ((AddCurrencyCode <> '') AND (DtldCVLedgEntryBuf."Additional-Currency Amount" <> 0))
          THEN
            PostDtldCustLedgEntry(GenJnlLine,DtldCVLedgEntryBuf,CustPostingGr,AdjAmount);
        UNTIL DtldCVLedgEntryBuf.NEXT = 0;
      END;

      CreateGLEntriesForTotalAmounts(
        GenJnlLine,TempInvPostBuf,AdjAmount,SaveEntryNo,CustPostingGr.GetReceivablesAccount,LedgEntryInserted);

      DtldLedgEntryInserted := NOT DtldCVLedgEntryBuf.ISEMPTY;
      DtldCVLedgEntryBuf.DELETEALL;
    END;

    LOCAL PROCEDURE PostDtldCustLedgEntry@82(GenJnlLine@1005 : Record 81;DtldCVLedgEntryBuf@1003 : Record 383;CustPostingGr@1002 : Record 92;VAR AdjAmount@1001 : ARRAY [4] OF Decimal);
    VAR
      AccNo@1006 : Code[20];
    BEGIN
      AccNo := GetDtldCustLedgEntryAccNo(GenJnlLine,DtldCVLedgEntryBuf,CustPostingGr,0,FALSE);
      PostDtldCVLedgEntry(GenJnlLine,DtldCVLedgEntryBuf,AccNo,AdjAmount,FALSE);
    END;

    LOCAL PROCEDURE PostDtldCustLedgEntryUnapply@114(GenJnlLine@1007 : Record 81;DtldCVLedgEntryBuf@1001 : Record 383;CustPostingGr@1000 : Record 92;OriginalTransactionNo@1006 : Integer);
    VAR
      AdjAmount@1004 : ARRAY [4] OF Decimal;
      AccNo@1002 : Code[20];
    BEGIN
      IF (DtldCVLedgEntryBuf."Amount (LCY)" = 0) AND
         (DtldCVLedgEntryBuf."VAT Amount (LCY)" = 0) AND
         ((AddCurrencyCode = '') OR (DtldCVLedgEntryBuf."Additional-Currency Amount" = 0))
      THEN
        EXIT;

      AccNo := GetDtldCustLedgEntryAccNo(GenJnlLine,DtldCVLedgEntryBuf,CustPostingGr,OriginalTransactionNo,TRUE);
      DtldCVLedgEntryBuf."Gen. Posting Type" := DtldCVLedgEntryBuf."Gen. Posting Type"::Sale;
      PostDtldCVLedgEntry(GenJnlLine,DtldCVLedgEntryBuf,AccNo,AdjAmount,TRUE);
    END;

    LOCAL PROCEDURE GetDtldCustLedgEntryAccNo@147(GenJnlLine@1007 : Record 81;DtldCVLedgEntryBuf@1001 : Record 383;CustPostingGr@1000 : Record 92;OriginalTransactionNo@1006 : Integer;Unapply@1012 : Boolean) : Code[20];
    VAR
      GenPostingSetup@1005 : Record 252;
      Currency@1009 : Record 4;
      AmountCondition@1002 : Boolean;
    BEGIN
      WITH DtldCVLedgEntryBuf DO BEGIN
        AmountCondition := IsDebitAmount(DtldCVLedgEntryBuf,Unapply);
        CASE "Entry Type" OF
          "Entry Type"::"Initial Entry":
            ;
          "Entry Type"::Application:
            ;
          "Entry Type"::"Unrealized Loss",
          "Entry Type"::"Unrealized Gain",
          "Entry Type"::"Realized Loss",
          "Entry Type"::"Realized Gain":
            BEGIN
              GetCurrency(Currency,"Currency Code");
              CheckNonAddCurrCodeOccurred(Currency.Code);
              EXIT(Currency.GetGainLossAccount(DtldCVLedgEntryBuf));
            END;
          "Entry Type"::"Payment Discount":
            EXIT(CustPostingGr.GetPmtDiscountAccount(AmountCondition));
          "Entry Type"::"Payment Discount (VAT Excl.)":
            BEGIN
              TESTFIELD("Gen. Prod. Posting Group");
              GenPostingSetup.GET("Gen. Bus. Posting Group","Gen. Prod. Posting Group");
              EXIT(GenPostingSetup.GetSalesPmtDiscountAccount(AmountCondition));
            END;
          "Entry Type"::"Appln. Rounding":
            EXIT(CustPostingGr.GetApplRoundingAccount(AmountCondition));
          "Entry Type"::"Correction of Remaining Amount":
            EXIT(CustPostingGr.GetRoundingAccount(AmountCondition));
          "Entry Type"::"Payment Discount Tolerance":
            CASE GLSetup."Pmt. Disc. Tolerance Posting" OF
              GLSetup."Pmt. Disc. Tolerance Posting"::"Payment Tolerance Accounts":
                EXIT(CustPostingGr.GetPmtToleranceAccount(AmountCondition));
              GLSetup."Pmt. Disc. Tolerance Posting"::"Payment Discount Accounts":
                EXIT(CustPostingGr.GetPmtDiscountAccount(AmountCondition));
            END;
          "Entry Type"::"Payment Tolerance":
            CASE GLSetup."Payment Tolerance Posting" OF
              GLSetup."Payment Tolerance Posting"::"Payment Tolerance Accounts":
                EXIT(CustPostingGr.GetPmtToleranceAccount(AmountCondition));
              GLSetup."Payment Tolerance Posting"::"Payment Discount Accounts":
                EXIT(CustPostingGr.GetPmtDiscountAccount(AmountCondition));
            END;
          "Entry Type"::"Payment Tolerance (VAT Excl.)":
            BEGIN
              TESTFIELD("Gen. Prod. Posting Group");
              GenPostingSetup.GET("Gen. Bus. Posting Group","Gen. Prod. Posting Group");
              CASE GLSetup."Payment Tolerance Posting" OF
                GLSetup."Payment Tolerance Posting"::"Payment Tolerance Accounts":
                  EXIT(GenPostingSetup.GetSalesPmtToleranceAccount(AmountCondition));
                GLSetup."Payment Tolerance Posting"::"Payment Discount Accounts":
                  EXIT(GenPostingSetup.GetSalesPmtDiscountAccount(AmountCondition));
              END;
            END;
          "Entry Type"::"Payment Discount Tolerance (VAT Excl.)":
            BEGIN
              GenPostingSetup.GET("Gen. Bus. Posting Group","Gen. Prod. Posting Group");
              CASE GLSetup."Pmt. Disc. Tolerance Posting" OF
                GLSetup."Pmt. Disc. Tolerance Posting"::"Payment Tolerance Accounts":
                  EXIT(GenPostingSetup.GetSalesPmtToleranceAccount(AmountCondition));
                GLSetup."Pmt. Disc. Tolerance Posting"::"Payment Discount Accounts":
                  EXIT(GenPostingSetup.GetSalesPmtDiscountAccount(AmountCondition));
              END;
            END;
          "Entry Type"::"Payment Discount (VAT Adjustment)",
          "Entry Type"::"Payment Tolerance (VAT Adjustment)",
          "Entry Type"::"Payment Discount Tolerance (VAT Adjustment)":
            IF Unapply THEN
              PostDtldCustVATAdjustment(GenJnlLine,DtldCVLedgEntryBuf,OriginalTransactionNo);
          ELSE
            FIELDERROR("Entry Type");
        END;
      END;
    END;

    LOCAL PROCEDURE CustUnrealizedVAT@16(GenJnlLine@1015 : Record 81;VAR CustLedgEntry2@1000 : Record 21;SettledAmount@1001 : Decimal);
    VAR
      VATEntry2@1002 : Record 254;
      TaxJurisdiction@1014 : Record 320;
      VATPostingSetup@1017 : Record 325;
      VATPart@1003 : Decimal;
      VATAmount@1004 : Decimal;
      VATBase@1005 : Decimal;
      VATAmountAddCurr@1006 : Decimal;
      VATBaseAddCurr@1007 : Decimal;
      PaidAmount@1008 : Decimal;
      TotalUnrealVATAmountLast@1012 : Decimal;
      TotalUnrealVATAmountFirst@1013 : Decimal;
      SalesVATAccount@1009 : Code[20];
      SalesVATUnrealAccount@1010 : Code[20];
      LastConnectionNo@1011 : Integer;
      GLEntryNo@1016 : Integer;
    BEGIN
      PaidAmount := CustLedgEntry2."Amount (LCY)" - CustLedgEntry2."Remaining Amt. (LCY)";
      VATEntry2.RESET;
      VATEntry2.SETCURRENTKEY("Transaction No.");
      VATEntry2.SETRANGE("Transaction No.",CustLedgEntry2."Transaction No.");
      IF VATEntry2.FINDSET THEN
        REPEAT
          VATPostingSetup.GET(VATEntry2."VAT Bus. Posting Group",VATEntry2."VAT Prod. Posting Group");
          IF VATPostingSetup."Unrealized VAT Type" IN
             [VATPostingSetup."Unrealized VAT Type"::Last,VATPostingSetup."Unrealized VAT Type"::"Last (Fully Paid)"]
          THEN
            TotalUnrealVATAmountLast := TotalUnrealVATAmountLast - VATEntry2."Remaining Unrealized Amount";
          IF VATPostingSetup."Unrealized VAT Type" IN
             [VATPostingSetup."Unrealized VAT Type"::First,VATPostingSetup."Unrealized VAT Type"::"First (Fully Paid)"]
          THEN
            TotalUnrealVATAmountFirst := TotalUnrealVATAmountFirst - VATEntry2."Remaining Unrealized Amount";
        UNTIL VATEntry2.NEXT = 0;
      IF VATEntry2.FINDSET THEN BEGIN
        LastConnectionNo := 0;
        REPEAT
          VATPostingSetup.GET(VATEntry2."VAT Bus. Posting Group",VATEntry2."VAT Prod. Posting Group");
          IF LastConnectionNo <> VATEntry2."Sales Tax Connection No." THEN BEGIN
            InsertSummarizedVAT(GenJnlLine);
            LastConnectionNo := VATEntry2."Sales Tax Connection No.";
          END;

          VATPart :=
            VATEntry2.GetUnrealizedVATPart(
              ROUND(SettledAmount / CustLedgEntry2.GetOriginalCurrencyFactor),
              PaidAmount,
              CustLedgEntry2."Original Amt. (LCY)",
              TotalUnrealVATAmountFirst,
              TotalUnrealVATAmountLast);

          IF VATPart > 0 THEN BEGIN
            CASE VATEntry2."VAT Calculation Type" OF
              VATEntry2."VAT Calculation Type"::"Normal VAT",
              VATEntry2."VAT Calculation Type"::"Reverse Charge VAT",
              VATEntry2."VAT Calculation Type"::"Full VAT":
                BEGIN
                  SalesVATAccount := VATPostingSetup.GetSalesAccount(FALSE);
                  SalesVATUnrealAccount := VATPostingSetup.GetSalesAccount(TRUE);
                END;
              VATEntry2."VAT Calculation Type"::"Sales Tax":
                BEGIN
                  TaxJurisdiction.GET(VATEntry2."Tax Jurisdiction Code");
                  SalesVATAccount := TaxJurisdiction.GetSalesAccount(FALSE);
                  SalesVATUnrealAccount := TaxJurisdiction.GetSalesAccount(TRUE);
                END;
            END;

            IF VATPart = 1 THEN BEGIN
              VATAmount := VATEntry2."Remaining Unrealized Amount";
              VATBase := VATEntry2."Remaining Unrealized Base";
              VATAmountAddCurr := VATEntry2."Add.-Curr. Rem. Unreal. Amount";
              VATBaseAddCurr := VATEntry2."Add.-Curr. Rem. Unreal. Base";
            END ELSE BEGIN
              VATAmount := ROUND(VATEntry2."Remaining Unrealized Amount" * VATPart,GLSetup."Amount Rounding Precision");
              VATBase := ROUND(VATEntry2."Remaining Unrealized Base" * VATPart,GLSetup."Amount Rounding Precision");
              VATAmountAddCurr :=
                ROUND(
                  VATEntry2."Add.-Curr. Rem. Unreal. Amount" * VATPart,
                  AddCurrency."Amount Rounding Precision");
              VATBaseAddCurr :=
                ROUND(
                  VATEntry2."Add.-Curr. Rem. Unreal. Base" * VATPart,
                  AddCurrency."Amount Rounding Precision");
            END;

            InitGLEntryVAT(
              GenJnlLine,SalesVATUnrealAccount,SalesVATAccount,-VATAmount,-VATAmountAddCurr,FALSE);
            GLEntryNo :=
              InitGLEntryVATCopy(GenJnlLine,SalesVATAccount,SalesVATUnrealAccount,VATAmount,VATAmountAddCurr,VATEntry2);

            PostUnrealVATEntry(GenJnlLine,VATEntry2,VATAmount,VATBase,VATAmountAddCurr,VATBaseAddCurr,GLEntryNo);
          END;
        UNTIL VATEntry2.NEXT = 0;

        InsertSummarizedVAT(GenJnlLine);
      END;
    END;

    LOCAL PROCEDURE ApplyVendLedgEntry@4(VAR NewCVLedgEntryBuf@1000 : Record 382;VAR DtldCVLedgEntryBuf@1001 : Record 383;GenJnlLine@1002 : Record 81;Vend@1015 : Record 23);
    VAR
      OldVendLedgEntry@1005 : Record 25;
      OldCVLedgEntryBuf@1006 : Record 382;
      NewVendLedgEntry@1008 : Record 25;
      NewCVLedgEntryBuf2@1019 : Record 382;
      TempOldVendLedgEntry@1003 : TEMPORARY Record 25;
      Completed@1009 : Boolean;
      AppliedAmount@1010 : Decimal;
      NewRemainingAmtBeforeAppln@1014 : Decimal;
      ApplyingDate@1017 : Date;
      PmtTolAmtToBeApplied@1020 : Decimal;
      AllApplied@1024 : Boolean;
    BEGIN
      IF NewCVLedgEntryBuf."Amount to Apply" = 0 THEN
        EXIT;

      AllApplied := TRUE;
      IF (GenJnlLine."Applies-to Doc. No." = '') AND (GenJnlLine."Applies-to ID" = '') AND
         NOT
         ((Vend."Application Method" = Vend."Application Method"::"Apply to Oldest") AND
          GenJnlLine."Allow Application")
      THEN
        EXIT;

      PmtTolAmtToBeApplied := 0;
      NewRemainingAmtBeforeAppln := NewCVLedgEntryBuf."Remaining Amount";
      NewCVLedgEntryBuf2 := NewCVLedgEntryBuf;

      ApplyingDate := GenJnlLine."Posting Date";

      IF NOT PrepareTempVendLedgEntry(GenJnlLine,NewCVLedgEntryBuf,TempOldVendLedgEntry,Vend,ApplyingDate) THEN
        EXIT;

      GenJnlLine."Posting Date" := ApplyingDate;
      // Apply the new entry (Payment) to the old entries (Invoices) one at a time
      REPEAT
        TempOldVendLedgEntry.CALCFIELDS(
          Amount,"Amount (LCY)","Remaining Amount","Remaining Amt. (LCY)",
          "Original Amount","Original Amt. (LCY)");
        OldCVLedgEntryBuf.CopyFromVendLedgEntry(TempOldVendLedgEntry);
        TempOldVendLedgEntry.COPYFILTER(Positive,OldCVLedgEntryBuf.Positive);

        PostApply(
          GenJnlLine,DtldCVLedgEntryBuf,OldCVLedgEntryBuf,NewCVLedgEntryBuf,NewCVLedgEntryBuf2,
          Vend."Block Payment Tolerance",AllApplied,AppliedAmount,PmtTolAmtToBeApplied);

        // Update the Old Entry
        TempOldVendLedgEntry.CopyFromCVLedgEntryBuffer(OldCVLedgEntryBuf);
        OldVendLedgEntry := TempOldVendLedgEntry;
        OldVendLedgEntry."Applies-to ID" := '';
        OldVendLedgEntry."Amount to Apply" := 0;
        OldVendLedgEntry.MODIFY;

        IF GLSetup."Unrealized VAT" OR
           (GLSetup."Prepayment Unrealized VAT" AND TempOldVendLedgEntry.Prepayment)
        THEN
          IF IsNotPayment(TempOldVendLedgEntry."Document Type") THEN BEGIN
            TempOldVendLedgEntry.RecalculateAmounts(
              NewCVLedgEntryBuf."Currency Code",TempOldVendLedgEntry."Currency Code",NewCVLedgEntryBuf."Posting Date");
            VendUnrealizedVAT(
              GenJnlLine,
              TempOldVendLedgEntry,
              CurrExchRate.ExchangeAmount(
                AppliedAmount,NewCVLedgEntryBuf."Currency Code",
                TempOldVendLedgEntry."Currency Code",NewCVLedgEntryBuf."Posting Date"));
          END;

        TempOldVendLedgEntry.DELETE;

        // Find the next old entry to apply to the new entry
        IF GenJnlLine."Applies-to Doc. No." <> '' THEN
          Completed := TRUE
        ELSE
          IF TempOldVendLedgEntry.GETFILTER(Positive) <> '' THEN
            IF TempOldVendLedgEntry.NEXT = 1 THEN
              Completed := FALSE
            ELSE BEGIN
              TempOldVendLedgEntry.SETRANGE(Positive);
              TempOldVendLedgEntry.FIND('-');
              TempOldVendLedgEntry.CALCFIELDS("Remaining Amount");
              Completed := TempOldVendLedgEntry."Remaining Amount" * NewCVLedgEntryBuf."Remaining Amount" >= 0;
            END
          ELSE
            IF NewCVLedgEntryBuf.Open THEN
              Completed := TempOldVendLedgEntry.NEXT = 0
            ELSE
              Completed := TRUE;
      UNTIL Completed;

      DtldCVLedgEntryBuf.SETCURRENTKEY("CV Ledger Entry No.","Entry Type");
      DtldCVLedgEntryBuf.SETRANGE("CV Ledger Entry No.",NewCVLedgEntryBuf."Entry No.");
      DtldCVLedgEntryBuf.SETRANGE(
        "Entry Type",
        DtldCVLedgEntryBuf."Entry Type"::Application);
      DtldCVLedgEntryBuf.CALCSUMS("Amount (LCY)",Amount);

      CalcCurrencyUnrealizedGainLoss(
        NewCVLedgEntryBuf,DtldCVLedgEntryBuf,GenJnlLine,DtldCVLedgEntryBuf.Amount,NewRemainingAmtBeforeAppln);

      CalcAmtLCYAdjustment(NewCVLedgEntryBuf,DtldCVLedgEntryBuf,GenJnlLine);

      NewCVLedgEntryBuf."Applies-to ID" := '';
      NewCVLedgEntryBuf."Amount to Apply" := 0;

      IF GLSetup."Unrealized VAT" OR
         (GLSetup."Prepayment Unrealized VAT" AND NewCVLedgEntryBuf.Prepayment)
      THEN
        IF IsNotPayment(NewCVLedgEntryBuf."Document Type") AND
           (NewRemainingAmtBeforeAppln - NewCVLedgEntryBuf."Remaining Amount" <> 0)
        THEN BEGIN
          NewVendLedgEntry.CopyFromCVLedgEntryBuffer(NewCVLedgEntryBuf);
          CheckUnrealizedVend := TRUE;
          UnrealizedVendLedgEntry := NewVendLedgEntry;
          UnrealizedVendLedgEntry.CALCFIELDS("Amount (LCY)","Original Amt. (LCY)");
          UnrealizedRemainingAmountVend := -(NewRemainingAmtBeforeAppln - NewVendLedgEntry."Remaining Amount");
        END;
    END;

    LOCAL PROCEDURE ApplyEmplLedgEntry@141(VAR NewCVLedgEntryBuf@1000 : Record 382;VAR DtldCVLedgEntryBuf@1001 : Record 383;GenJnlLine@1002 : Record 81;Employee@1015 : Record 5200);
    VAR
      OldEmplLedgEntry@1005 : Record 5222;
      OldCVLedgEntryBuf@1006 : Record 382;
      NewCVLedgEntryBuf2@1019 : Record 382;
      TempOldEmplLedgEntry@1003 : TEMPORARY Record 5222;
      Completed@1009 : Boolean;
      AppliedAmount@1010 : Decimal;
      ApplyingDate@1017 : Date;
      PmtTolAmtToBeApplied@1004 : Decimal;
      AllApplied@1024 : Boolean;
    BEGIN
      IF NewCVLedgEntryBuf."Amount to Apply" = 0 THEN
        EXIT;

      AllApplied := TRUE;
      IF (GenJnlLine."Applies-to Doc. No." = '') AND (GenJnlLine."Applies-to ID" = '') AND
         NOT
         ((Employee."Application Method" = Employee."Application Method"::"Apply to Oldest") AND
          GenJnlLine."Allow Application")
      THEN
        EXIT;

      PmtTolAmtToBeApplied := 0;
      NewCVLedgEntryBuf2 := NewCVLedgEntryBuf;

      ApplyingDate := GenJnlLine."Posting Date";

      IF NOT PrepareTempEmplLedgEntry(GenJnlLine,NewCVLedgEntryBuf,TempOldEmplLedgEntry,Employee,ApplyingDate) THEN
        EXIT;

      GenJnlLine."Posting Date" := ApplyingDate;

      // Apply the new entry (Payment) to the old entries one at a time
      REPEAT
        TempOldEmplLedgEntry.CALCFIELDS(
          Amount,"Amount (LCY)","Remaining Amount","Remaining Amt. (LCY)",
          "Original Amount","Original Amt. (LCY)");
        OldCVLedgEntryBuf.CopyFromEmplLedgEntry(TempOldEmplLedgEntry);
        TempOldEmplLedgEntry.COPYFILTER(Positive,OldCVLedgEntryBuf.Positive);

        PostApply(
          GenJnlLine,DtldCVLedgEntryBuf,OldCVLedgEntryBuf,NewCVLedgEntryBuf,NewCVLedgEntryBuf2,
          TRUE,AllApplied,AppliedAmount,PmtTolAmtToBeApplied);

        // Update the Old Entry
        TempOldEmplLedgEntry.CopyFromCVLedgEntryBuffer(OldCVLedgEntryBuf);
        OldEmplLedgEntry := TempOldEmplLedgEntry;
        OldEmplLedgEntry."Applies-to ID" := '';
        OldEmplLedgEntry."Amount to Apply" := 0;
        OldEmplLedgEntry.MODIFY;

        TempOldEmplLedgEntry.DELETE;

        // Find the next old entry to apply to the new entry
        IF GenJnlLine."Applies-to Doc. No." <> '' THEN
          Completed := TRUE
        ELSE
          IF TempOldEmplLedgEntry.GETFILTER(Positive) <> '' THEN
            IF TempOldEmplLedgEntry.NEXT = 1 THEN
              Completed := FALSE
            ELSE BEGIN
              TempOldEmplLedgEntry.SETRANGE(Positive);
              TempOldEmplLedgEntry.FIND('-');
              TempOldEmplLedgEntry.CALCFIELDS("Remaining Amount");
              Completed := TempOldEmplLedgEntry."Remaining Amount" * NewCVLedgEntryBuf."Remaining Amount" >= 0;
            END
          ELSE
            IF NewCVLedgEntryBuf.Open THEN
              Completed := TempOldEmplLedgEntry.NEXT = 0
            ELSE
              Completed := TRUE;
      UNTIL Completed;

      DtldCVLedgEntryBuf.SETCURRENTKEY("CV Ledger Entry No.","Entry Type");
      DtldCVLedgEntryBuf.SETRANGE("CV Ledger Entry No.",NewCVLedgEntryBuf."Entry No.");
      DtldCVLedgEntryBuf.SETRANGE(
        "Entry Type",
        DtldCVLedgEntryBuf."Entry Type"::Application);
      DtldCVLedgEntryBuf.CALCSUMS("Amount (LCY)",Amount);

      NewCVLedgEntryBuf."Applies-to ID" := '';
      NewCVLedgEntryBuf."Amount to Apply" := 0;
    END;

    [Internal]
    PROCEDURE VendPostApplyVendLedgEntry@66(VAR GenJnlLinePostApply@1000 : Record 81;VAR VendLedgEntryPostApply@1001 : Record 25);
    VAR
      Vend@1002 : Record 23;
      VendPostingGr@1007 : Record 93;
      VendLedgEntry@1006 : Record 25;
      DtldVendLedgEntry@1003 : Record 380;
      TempDtldCVLedgEntryBuf@1004 : TEMPORARY Record 383;
      CVLedgEntryBuf@1005 : Record 382;
      GenJnlLine@1008 : Record 81;
      DtldLedgEntryInserted@1009 : Boolean;
    BEGIN
      GenJnlLine := GenJnlLinePostApply;
      VendLedgEntry.TRANSFERFIELDS(VendLedgEntryPostApply);
      WITH GenJnlLine DO BEGIN
        "Source Currency Code" := VendLedgEntryPostApply."Currency Code";
        "Applies-to ID" := VendLedgEntryPostApply."Applies-to ID";

        GenJnlCheckLine.RunCheck(GenJnlLine);

        IF NextEntryNo = 0 THEN
          StartPosting(GenJnlLine)
        ELSE
          ContinuePosting(GenJnlLine);

        Vend.GET(VendLedgEntry."Vendor No.");
        Vend.CheckBlockedVendOnJnls(Vend,"Document Type",TRUE);

        IF "Posting Group" = '' THEN BEGIN
          Vend.TESTFIELD("Vendor Posting Group");
          "Posting Group" := Vend."Vendor Posting Group";
        END;
        VendPostingGr.GET("Posting Group");
        VendPostingGr.GetPayablesAccount;

        DtldVendLedgEntry.LOCKTABLE;
        VendLedgEntry.LOCKTABLE;

        // Post the application
        VendLedgEntry.CALCFIELDS(
          Amount,"Amount (LCY)","Remaining Amount","Remaining Amt. (LCY)",
          "Original Amount","Original Amt. (LCY)");
        CVLedgEntryBuf.CopyFromVendLedgEntry(VendLedgEntry);
        ApplyVendLedgEntry(
          CVLedgEntryBuf,TempDtldCVLedgEntryBuf,GenJnlLine,Vend);
        VendLedgEntry.CopyFromCVLedgEntryBuffer(CVLedgEntryBuf);
        VendLedgEntry.MODIFY(TRUE);

        // Post Dtld vendor entry
        DtldLedgEntryInserted := PostDtldVendLedgEntries(GenJnlLine,TempDtldCVLedgEntryBuf,VendPostingGr,FALSE);

        CheckPostUnrealizedVAT(GenJnlLine,TRUE);

        IF DtldLedgEntryInserted THEN
          IF IsTempGLEntryBufEmpty THEN
            DtldVendLedgEntry.SetZeroTransNo(NextTransactionNo);

        FinishPosting;
      END;
    END;

    [Internal]
    PROCEDURE EmplPostApplyEmplLedgEntry@138(VAR GenJnlLinePostApply@1000 : Record 81;VAR EmplLedgEntryPostApply@1001 : Record 5222);
    VAR
      Empl@1002 : Record 5200;
      EmplPostingGr@1007 : Record 5221;
      EmplLedgEntry@1006 : Record 5222;
      DtldEmplLedgEntry@1003 : Record 5223;
      TempDtldCVLedgEntryBuf@1004 : TEMPORARY Record 383;
      CVLedgEntryBuf@1005 : Record 382;
      GenJnlLine@1008 : Record 81;
      DtldLedgEntryInserted@1009 : Boolean;
    BEGIN
      GenJnlLine := GenJnlLinePostApply;
      EmplLedgEntry.TRANSFERFIELDS(EmplLedgEntryPostApply);
      WITH GenJnlLine DO BEGIN
        "Source Currency Code" := EmplLedgEntryPostApply."Currency Code";
        "Applies-to ID" := EmplLedgEntryPostApply."Applies-to ID";

        GenJnlCheckLine.RunCheck(GenJnlLine);

        IF NextEntryNo = 0 THEN
          StartPosting(GenJnlLine)
        ELSE
          ContinuePosting(GenJnlLine);

        Empl.GET(EmplLedgEntry."Employee No.");

        IF "Posting Group" = '' THEN BEGIN
          Empl.TESTFIELD("Employee Posting Group");
          "Posting Group" := Empl."Employee Posting Group";
        END;
        EmplPostingGr.GET("Posting Group");
        EmplPostingGr.GetPayablesAccount;

        DtldEmplLedgEntry.LOCKTABLE;
        EmplLedgEntry.LOCKTABLE;

        // Post the application
        EmplLedgEntry.CALCFIELDS(
          Amount,"Amount (LCY)","Remaining Amount","Remaining Amt. (LCY)",
          "Original Amount","Original Amt. (LCY)");
        CVLedgEntryBuf.CopyFromEmplLedgEntry(EmplLedgEntry);
        ApplyEmplLedgEntry(
          CVLedgEntryBuf,TempDtldCVLedgEntryBuf,GenJnlLine,Empl);
        EmplLedgEntry.CopyFromCVLedgEntryBuffer(CVLedgEntryBuf);
        EmplLedgEntry.MODIFY(TRUE);

        // Post Dtld vendor entry
        DtldLedgEntryInserted := PostDtldEmplLedgEntries(GenJnlLine,TempDtldCVLedgEntryBuf,EmplPostingGr,FALSE);

        CheckPostUnrealizedVAT(GenJnlLine,TRUE);

        IF DtldLedgEntryInserted THEN
          IF IsTempGLEntryBufEmpty THEN
            DtldEmplLedgEntry.SetZeroTransNo(NextTransactionNo);

        FinishPosting;
      END;
    END;

    LOCAL PROCEDURE PrepareTempVendLedgEntry@119(GenJnlLine@1004 : Record 81;VAR NewCVLedgEntryBuf@1003 : Record 382;VAR TempOldVendLedgEntry@1002 : TEMPORARY Record 25;Vend@1001 : Record 23;VAR ApplyingDate@1000 : Date) : Boolean;
    VAR
      OldVendLedgEntry@1018 : Record 25;
      PurchSetup@1013 : Record 312;
      GenJnlApply@1012 : Codeunit 225;
      RemainingAmount@1009 : Decimal;
    BEGIN
      IF GenJnlLine."Applies-to Doc. No." <> '' THEN BEGIN
        // Find the entry to be applied to
        OldVendLedgEntry.RESET;
        OldVendLedgEntry.SETCURRENTKEY("Document No.");
        OldVendLedgEntry.SETRANGE("Document No.",GenJnlLine."Applies-to Doc. No.");
        OldVendLedgEntry.SETRANGE("Document Type",GenJnlLine."Applies-to Doc. Type");
        OldVendLedgEntry.SETRANGE("Vendor No.",NewCVLedgEntryBuf."CV No.");
        OldVendLedgEntry.SETRANGE(Open,TRUE);
        OldVendLedgEntry.FINDFIRST;
        OldVendLedgEntry.TESTFIELD(Positive,NOT NewCVLedgEntryBuf.Positive);
        IF OldVendLedgEntry."Posting Date" > ApplyingDate THEN
          ApplyingDate := OldVendLedgEntry."Posting Date";
        GenJnlApply.CheckAgainstApplnCurrency(
          NewCVLedgEntryBuf."Currency Code",OldVendLedgEntry."Currency Code",GenJnlLine."Account Type"::Vendor,TRUE);
        TempOldVendLedgEntry := OldVendLedgEntry;
        TempOldVendLedgEntry.INSERT;
      END ELSE BEGIN
        // Find the first old entry (Invoice) which the new entry (Payment) should apply to
        OldVendLedgEntry.RESET;
        OldVendLedgEntry.SETCURRENTKEY("Vendor No.","Applies-to ID",Open,Positive,"Due Date");
        TempOldVendLedgEntry.SETCURRENTKEY("Vendor No.","Applies-to ID",Open,Positive,"Due Date");
        OldVendLedgEntry.SETRANGE("Vendor No.",NewCVLedgEntryBuf."CV No.");
        OldVendLedgEntry.SETRANGE("Applies-to ID",GenJnlLine."Applies-to ID");
        OldVendLedgEntry.SETRANGE(Open,TRUE);
        OldVendLedgEntry.SETFILTER("Entry No.",'<>%1',NewCVLedgEntryBuf."Entry No.");
        IF NOT (Vend."Application Method" = Vend."Application Method"::"Apply to Oldest") THEN
          OldVendLedgEntry.SETFILTER("Amount to Apply",'<>%1',0);

        IF Vend."Application Method" = Vend."Application Method"::"Apply to Oldest" THEN
          OldVendLedgEntry.SETFILTER("Posting Date",'..%1',GenJnlLine."Posting Date");

        // Check and Move Ledger Entries to Temp
        PurchSetup.GET;
        IF PurchSetup."Appln. between Currencies" = PurchSetup."Appln. between Currencies"::None THEN
          OldVendLedgEntry.SETRANGE("Currency Code",NewCVLedgEntryBuf."Currency Code");
        IF OldVendLedgEntry.FINDSET(FALSE,FALSE) THEN
          REPEAT
            IF GenJnlApply.CheckAgainstApplnCurrency(
                 NewCVLedgEntryBuf."Currency Code",OldVendLedgEntry."Currency Code",GenJnlLine."Account Type"::Vendor,FALSE)
            THEN BEGIN
              IF (OldVendLedgEntry."Posting Date" > ApplyingDate) AND (OldVendLedgEntry."Applies-to ID" <> '') THEN
                ApplyingDate := OldVendLedgEntry."Posting Date";
              TempOldVendLedgEntry := OldVendLedgEntry;
              TempOldVendLedgEntry.INSERT;
            END;
          UNTIL OldVendLedgEntry.NEXT = 0;

        TempOldVendLedgEntry.SETRANGE(Positive,NewCVLedgEntryBuf."Remaining Amount" > 0);

        IF TempOldVendLedgEntry.FIND('-') THEN BEGIN
          RemainingAmount := NewCVLedgEntryBuf."Remaining Amount";
          TempOldVendLedgEntry.SETRANGE(Positive);
          TempOldVendLedgEntry.FIND('-');
          REPEAT
            TempOldVendLedgEntry.CALCFIELDS("Remaining Amount");
            TempOldVendLedgEntry.RecalculateAmounts(
              TempOldVendLedgEntry."Currency Code",NewCVLedgEntryBuf."Currency Code",NewCVLedgEntryBuf."Posting Date");
            IF PaymentToleranceMgt.CheckCalcPmtDiscCVVend(NewCVLedgEntryBuf,TempOldVendLedgEntry,0,FALSE,FALSE) THEN
              TempOldVendLedgEntry."Remaining Amount" -= TempOldVendLedgEntry."Remaining Pmt. Disc. Possible";
            RemainingAmount += TempOldVendLedgEntry."Remaining Amount";
          UNTIL TempOldVendLedgEntry.NEXT = 0;
          TempOldVendLedgEntry.SETRANGE(Positive,RemainingAmount < 0);
        END ELSE
          TempOldVendLedgEntry.SETRANGE(Positive);
        EXIT(TempOldVendLedgEntry.FIND('-'));
      END;
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE PrepareTempEmplLedgEntry@145(GenJnlLine@1004 : Record 81;VAR NewCVLedgEntryBuf@1003 : Record 382;VAR TempOldEmplLedgEntry@1002 : TEMPORARY Record 5222;Employee@1001 : Record 5200;VAR ApplyingDate@1000 : Date) : Boolean;
    VAR
      OldEmplLedgEntry@1018 : Record 5222;
      RemainingAmount@1009 : Decimal;
    BEGIN
      IF GenJnlLine."Applies-to Doc. No." <> '' THEN BEGIN
        // Find the entry to be applied to
        OldEmplLedgEntry.RESET;
        OldEmplLedgEntry.SETCURRENTKEY("Document No.");
        OldEmplLedgEntry.SETRANGE("Document Type",GenJnlLine."Applies-to Doc. Type");
        OldEmplLedgEntry.SETRANGE("Document No.",GenJnlLine."Applies-to Doc. No.");
        OldEmplLedgEntry.SETRANGE("Employee No.",NewCVLedgEntryBuf."CV No.");
        OldEmplLedgEntry.SETRANGE(Open,TRUE);
        OldEmplLedgEntry.FINDFIRST;
        OldEmplLedgEntry.TESTFIELD(Positive,NOT NewCVLedgEntryBuf.Positive);
        IF OldEmplLedgEntry."Posting Date" > ApplyingDate THEN
          ApplyingDate := OldEmplLedgEntry."Posting Date";
        TempOldEmplLedgEntry := OldEmplLedgEntry;
        TempOldEmplLedgEntry.INSERT;
      END ELSE BEGIN
        // Find the first old entry which the new entry (Payment) should apply to
        OldEmplLedgEntry.RESET;
        OldEmplLedgEntry.SETCURRENTKEY("Employee No.","Applies-to ID",Open,Positive);
        TempOldEmplLedgEntry.SETCURRENTKEY("Employee No.","Applies-to ID",Open,Positive);
        OldEmplLedgEntry.SETRANGE("Employee No.",NewCVLedgEntryBuf."CV No.");
        OldEmplLedgEntry.SETRANGE("Applies-to ID",GenJnlLine."Applies-to ID");
        OldEmplLedgEntry.SETRANGE(Open,TRUE);
        OldEmplLedgEntry.SETFILTER("Entry No.",'<>%1',NewCVLedgEntryBuf."Entry No.");
        IF NOT (Employee."Application Method" = Employee."Application Method"::"Apply to Oldest") THEN
          OldEmplLedgEntry.SETFILTER("Amount to Apply",'<>%1',0);

        IF Employee."Application Method" = Employee."Application Method"::"Apply to Oldest" THEN
          OldEmplLedgEntry.SETFILTER("Posting Date",'..%1',GenJnlLine."Posting Date");

        OldEmplLedgEntry.SETRANGE("Currency Code",NewCVLedgEntryBuf."Currency Code");
        IF OldEmplLedgEntry.FINDSET(FALSE,FALSE) THEN
          REPEAT
            IF (OldEmplLedgEntry."Posting Date" > ApplyingDate) AND (OldEmplLedgEntry."Applies-to ID" <> '') THEN
              ApplyingDate := OldEmplLedgEntry."Posting Date";
            TempOldEmplLedgEntry := OldEmplLedgEntry;
            TempOldEmplLedgEntry.INSERT;
          UNTIL OldEmplLedgEntry.NEXT = 0;

        TempOldEmplLedgEntry.SETRANGE(Positive,NewCVLedgEntryBuf."Remaining Amount" > 0);

        IF TempOldEmplLedgEntry.FIND('-') THEN BEGIN
          RemainingAmount := NewCVLedgEntryBuf."Remaining Amount";
          TempOldEmplLedgEntry.SETRANGE(Positive);
          TempOldEmplLedgEntry.FIND('-');
          REPEAT
            TempOldEmplLedgEntry.CALCFIELDS("Remaining Amount");
            RemainingAmount += TempOldEmplLedgEntry."Remaining Amount";
          UNTIL TempOldEmplLedgEntry.NEXT = 0;
          TempOldEmplLedgEntry.SETRANGE(Positive,RemainingAmount < 0);
        END ELSE
          TempOldEmplLedgEntry.SETRANGE(Positive);
        EXIT(TempOldEmplLedgEntry.FIND('-'));
      END;
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE PostDtldVendLedgEntries@32(GenJnlLine@1000 : Record 81;VAR DtldCVLedgEntryBuf@1001 : Record 383;VendPostingGr@1002 : Record 93;LedgEntryInserted@1011 : Boolean) DtldLedgEntryInserted : Boolean;
    VAR
      TempInvPostBuf@1007 : TEMPORARY Record 49;
      DtldVendLedgEntry@1004 : Record 380;
      AdjAmount@1012 : ARRAY [4] OF Decimal;
      DtldVendLedgEntryNoOffset@1005 : Integer;
      SaveEntryNo@1013 : Integer;
    BEGIN
      IF GenJnlLine."Account Type" <> GenJnlLine."Account Type"::Vendor THEN
        EXIT;

      IF DtldVendLedgEntry.FINDLAST THEN
        DtldVendLedgEntryNoOffset := DtldVendLedgEntry."Entry No."
      ELSE
        DtldVendLedgEntryNoOffset := 0;

      DtldCVLedgEntryBuf.RESET;
      IF DtldCVLedgEntryBuf.FINDSET THEN BEGIN
        IF LedgEntryInserted THEN BEGIN
          SaveEntryNo := NextEntryNo;
          NextEntryNo := NextEntryNo + 1;
        END;
        REPEAT
          InsertDtldVendLedgEntry(GenJnlLine,DtldCVLedgEntryBuf,DtldVendLedgEntry,DtldVendLedgEntryNoOffset);

          UpdateTotalAmounts(
            TempInvPostBuf,GenJnlLine."Dimension Set ID",
            DtldCVLedgEntryBuf."Amount (LCY)",DtldCVLedgEntryBuf."Additional-Currency Amount");

          // Post automatic entries.
          IF ((DtldCVLedgEntryBuf."Amount (LCY)" <> 0) OR
              (DtldCVLedgEntryBuf."VAT Amount (LCY)" <> 0)) OR
             ((AddCurrencyCode <> '') AND (DtldCVLedgEntryBuf."Additional-Currency Amount" <> 0))
          THEN
            PostDtldVendLedgEntry(GenJnlLine,DtldCVLedgEntryBuf,VendPostingGr,AdjAmount);
        UNTIL DtldCVLedgEntryBuf.NEXT = 0;
      END;

      CreateGLEntriesForTotalAmounts(
        GenJnlLine,TempInvPostBuf,AdjAmount,SaveEntryNo,VendPostingGr.GetPayablesAccount,LedgEntryInserted);

      DtldLedgEntryInserted := NOT DtldCVLedgEntryBuf.ISEMPTY;
      DtldCVLedgEntryBuf.DELETEALL;
    END;

    LOCAL PROCEDURE PostDtldVendLedgEntry@81(GenJnlLine@1000 : Record 81;DtldCVLedgEntryBuf@1002 : Record 383;VendPostingGr@1006 : Record 93;VAR AdjAmount@1003 : ARRAY [4] OF Decimal);
    VAR
      AccNo@1005 : Code[20];
    BEGIN
      AccNo := GetDtldVendLedgEntryAccNo(GenJnlLine,DtldCVLedgEntryBuf,VendPostingGr,0,FALSE);
      PostDtldCVLedgEntry(GenJnlLine,DtldCVLedgEntryBuf,AccNo,AdjAmount,FALSE);
    END;

    LOCAL PROCEDURE PostDtldVendLedgEntryUnapply@69(GenJnlLine@1007 : Record 81;DtldCVLedgEntryBuf@1001 : Record 383;VendPostingGr@1000 : Record 93;OriginalTransactionNo@1006 : Integer);
    VAR
      AccNo@1002 : Code[20];
      AdjAmount@1003 : ARRAY [4] OF Decimal;
    BEGIN
      IF (DtldCVLedgEntryBuf."Amount (LCY)" = 0) AND
         (DtldCVLedgEntryBuf."VAT Amount (LCY)" = 0) AND
         ((AddCurrencyCode = '') OR (DtldCVLedgEntryBuf."Additional-Currency Amount" = 0))
      THEN
        EXIT;

      AccNo := GetDtldVendLedgEntryAccNo(GenJnlLine,DtldCVLedgEntryBuf,VendPostingGr,OriginalTransactionNo,TRUE);
      DtldCVLedgEntryBuf."Gen. Posting Type" := DtldCVLedgEntryBuf."Gen. Posting Type"::Purchase;
      PostDtldCVLedgEntry(GenJnlLine,DtldCVLedgEntryBuf,AccNo,AdjAmount,TRUE);
    END;

    LOCAL PROCEDURE GetDtldVendLedgEntryAccNo@56(GenJnlLine@1000 : Record 81;DtldCVLedgEntryBuf@1002 : Record 383;VendPostingGr@1006 : Record 93;OriginalTransactionNo@1003 : Integer;Unapply@1001 : Boolean) : Code[20];
    VAR
      Currency@1008 : Record 4;
      GenPostingSetup@1007 : Record 252;
      AmountCondition@1004 : Boolean;
    BEGIN
      WITH DtldCVLedgEntryBuf DO BEGIN
        AmountCondition := IsDebitAmount(DtldCVLedgEntryBuf,Unapply);
        CASE "Entry Type" OF
          "Entry Type"::"Initial Entry":
            ;
          "Entry Type"::Application:
            ;
          "Entry Type"::"Unrealized Loss",
          "Entry Type"::"Unrealized Gain",
          "Entry Type"::"Realized Loss",
          "Entry Type"::"Realized Gain":
            BEGIN
              GetCurrency(Currency,"Currency Code");
              CheckNonAddCurrCodeOccurred(Currency.Code);
              EXIT(Currency.GetGainLossAccount(DtldCVLedgEntryBuf));
            END;
          "Entry Type"::"Payment Discount":
            EXIT(VendPostingGr.GetPmtDiscountAccount(AmountCondition));
          "Entry Type"::"Payment Discount (VAT Excl.)":
            BEGIN
              GenPostingSetup.GET("Gen. Bus. Posting Group","Gen. Prod. Posting Group");
              EXIT(GenPostingSetup.GetPurchPmtDiscountAccount(AmountCondition));
            END;
          "Entry Type"::"Appln. Rounding":
            EXIT(VendPostingGr.GetApplRoundingAccount(AmountCondition));
          "Entry Type"::"Correction of Remaining Amount":
            EXIT(VendPostingGr.GetRoundingAccount(AmountCondition));
          "Entry Type"::"Payment Discount Tolerance":
            CASE GLSetup."Pmt. Disc. Tolerance Posting" OF
              GLSetup."Pmt. Disc. Tolerance Posting"::"Payment Tolerance Accounts":
                EXIT(VendPostingGr.GetPmtToleranceAccount(AmountCondition));
              GLSetup."Pmt. Disc. Tolerance Posting"::"Payment Discount Accounts":
                EXIT(VendPostingGr.GetPmtDiscountAccount(AmountCondition));
            END;
          "Entry Type"::"Payment Tolerance":
            CASE GLSetup."Payment Tolerance Posting" OF
              GLSetup."Payment Tolerance Posting"::"Payment Tolerance Accounts":
                EXIT(VendPostingGr.GetPmtToleranceAccount(AmountCondition));
              GLSetup."Payment Tolerance Posting"::"Payment Discount Accounts":
                EXIT(VendPostingGr.GetPmtDiscountAccount(AmountCondition));
            END;
          "Entry Type"::"Payment Tolerance (VAT Excl.)":
            BEGIN
              GenPostingSetup.GET("Gen. Bus. Posting Group","Gen. Prod. Posting Group");
              CASE GLSetup."Payment Tolerance Posting" OF
                GLSetup."Payment Tolerance Posting"::"Payment Tolerance Accounts":
                  EXIT(GenPostingSetup.GetPurchPmtToleranceAccount(AmountCondition));
                GLSetup."Payment Tolerance Posting"::"Payment Discount Accounts":
                  EXIT(GenPostingSetup.GetPurchPmtDiscountAccount(AmountCondition));
              END;
            END;
          "Entry Type"::"Payment Discount Tolerance (VAT Excl.)":
            BEGIN
              GenPostingSetup.GET("Gen. Bus. Posting Group","Gen. Prod. Posting Group");
              CASE GLSetup."Pmt. Disc. Tolerance Posting" OF
                GLSetup."Pmt. Disc. Tolerance Posting"::"Payment Tolerance Accounts":
                  EXIT(GenPostingSetup.GetPurchPmtToleranceAccount(AmountCondition));
                GLSetup."Pmt. Disc. Tolerance Posting"::"Payment Discount Accounts":
                  EXIT(GenPostingSetup.GetPurchPmtDiscountAccount(AmountCondition));
              END;
            END;
          "Entry Type"::"Payment Discount (VAT Adjustment)",
          "Entry Type"::"Payment Tolerance (VAT Adjustment)",
          "Entry Type"::"Payment Discount Tolerance (VAT Adjustment)":
            IF Unapply THEN
              PostDtldVendVATAdjustment(GenJnlLine,DtldCVLedgEntryBuf,OriginalTransactionNo);
          ELSE
            FIELDERROR("Entry Type");
        END;
      END;
    END;

    LOCAL PROCEDURE PostDtldEmplLedgEntries@148(GenJnlLine@1000 : Record 81;VAR DtldCVLedgEntryBuf@1001 : Record 383;EmplPostingGr@1002 : Record 5221;LedgEntryInserted@1011 : Boolean) DtldLedgEntryInserted : Boolean;
    VAR
      TempInvPostBuf@1007 : TEMPORARY Record 49;
      DtldEmplLedgEntry@1004 : Record 5223;
      DummyAdjAmount@1012 : ARRAY [4] OF Decimal;
      DtldEmplLedgEntryNoOffset@1005 : Integer;
      SaveEntryNo@1013 : Integer;
    BEGIN
      IF GenJnlLine."Account Type" <> GenJnlLine."Account Type"::Employee THEN
        EXIT;

      IF DtldEmplLedgEntry.FINDLAST THEN
        DtldEmplLedgEntryNoOffset := DtldEmplLedgEntry."Entry No."
      ELSE
        DtldEmplLedgEntryNoOffset := 0;

      DtldCVLedgEntryBuf.RESET;
      IF DtldCVLedgEntryBuf.FINDSET THEN BEGIN
        IF LedgEntryInserted THEN BEGIN
          SaveEntryNo := NextEntryNo;
          NextEntryNo := NextEntryNo + 1;
        END;
        REPEAT
          InsertDtldEmplLedgEntry(GenJnlLine,DtldCVLedgEntryBuf,DtldEmplLedgEntry,DtldEmplLedgEntryNoOffset);

          UpdateTotalAmounts(
            TempInvPostBuf,GenJnlLine."Dimension Set ID",
            DtldCVLedgEntryBuf."Amount (LCY)",DtldCVLedgEntryBuf."Additional-Currency Amount");
        UNTIL DtldCVLedgEntryBuf.NEXT = 0;
      END;

      CreateGLEntriesForTotalAmounts(
        GenJnlLine,TempInvPostBuf,DummyAdjAmount,SaveEntryNo,EmplPostingGr.GetPayablesAccount,LedgEntryInserted);

      DtldLedgEntryInserted := NOT DtldCVLedgEntryBuf.ISEMPTY;
      DtldCVLedgEntryBuf.DELETEALL;
    END;

    LOCAL PROCEDURE PostDtldCVLedgEntry@15(GenJnlLine@1000 : Record 81;DtldCVLedgEntryBuf@1001 : Record 383;AccNo@1002 : Code[20];VAR AdjAmount@1004 : ARRAY [4] OF Decimal;Unapply@1005 : Boolean);
    BEGIN
      WITH DtldCVLedgEntryBuf DO
        CASE "Entry Type" OF
          "Entry Type"::"Initial Entry":
            ;
          "Entry Type"::Application:
            ;
          "Entry Type"::"Unrealized Loss",
          "Entry Type"::"Unrealized Gain",
          "Entry Type"::"Realized Loss",
          "Entry Type"::"Realized Gain":
            BEGIN
              CreateGLEntryGainLoss(GenJnlLine,AccNo,-"Amount (LCY)","Currency Code" = AddCurrencyCode);
              IF NOT Unapply THEN
                CollectAdjustment(AdjAmount,-"Amount (LCY)",0);
            END;
          "Entry Type"::"Payment Discount",
          "Entry Type"::"Payment Tolerance",
          "Entry Type"::"Payment Discount Tolerance":
            BEGIN
              CreateGLEntry(GenJnlLine,AccNo,-"Amount (LCY)",-"Additional-Currency Amount",FALSE);
              IF NOT Unapply THEN
                CollectAdjustment(AdjAmount,-"Amount (LCY)",-"Additional-Currency Amount");
            END;
          "Entry Type"::"Payment Discount (VAT Excl.)",
          "Entry Type"::"Payment Tolerance (VAT Excl.)",
          "Entry Type"::"Payment Discount Tolerance (VAT Excl.)":
            BEGIN
              IF NOT Unapply THEN
                CreateGLEntryVATCollectAdj(
                  GenJnlLine,AccNo,-"Amount (LCY)",-"Additional-Currency Amount",-"VAT Amount (LCY)",DtldCVLedgEntryBuf,
                  AdjAmount)
              ELSE
                CreateGLEntryVAT(
                  GenJnlLine,AccNo,-"Amount (LCY)",-"Additional-Currency Amount",-"VAT Amount (LCY)",DtldCVLedgEntryBuf);
            END;
          "Entry Type"::"Appln. Rounding":
            IF "Amount (LCY)" <> 0 THEN BEGIN
              CreateGLEntry(GenJnlLine,AccNo,-"Amount (LCY)",-"Additional-Currency Amount",TRUE);
              IF NOT Unapply THEN
                CollectAdjustment(AdjAmount,-"Amount (LCY)",-"Additional-Currency Amount");
            END;
          "Entry Type"::"Correction of Remaining Amount":
            IF "Amount (LCY)" <> 0 THEN BEGIN
              CreateGLEntry(GenJnlLine,AccNo,-"Amount (LCY)",0,FALSE);
              IF NOT Unapply THEN
                CollectAdjustment(AdjAmount,-"Amount (LCY)",0);
            END;
          "Entry Type"::"Payment Discount (VAT Adjustment)",
          "Entry Type"::"Payment Tolerance (VAT Adjustment)",
          "Entry Type"::"Payment Discount Tolerance (VAT Adjustment)":
            ;
          ELSE
            FIELDERROR("Entry Type");
        END;
    END;

    LOCAL PROCEDURE PostDtldCustVATAdjustment@75(GenJnlLine@1003 : Record 81;DtldCVLedgEntryBuf@1002 : Record 383;OriginalTransactionNo@1000 : Integer);
    VAR
      VATPostingSetup@1005 : Record 325;
      TaxJurisdiction@1004 : Record 320;
    BEGIN
      WITH DtldCVLedgEntryBuf DO BEGIN
        FindVATEntry(VATEntry,OriginalTransactionNo);

        CASE VATPostingSetup."VAT Calculation Type" OF
          VATPostingSetup."VAT Calculation Type"::"Normal VAT",
          VATPostingSetup."VAT Calculation Type"::"Full VAT":
            BEGIN
              VATPostingSetup.GET("VAT Bus. Posting Group","VAT Prod. Posting Group");
              VATPostingSetup.TESTFIELD("VAT Calculation Type",VATEntry."VAT Calculation Type");
              CreateGLEntry(
                GenJnlLine,VATPostingSetup.GetSalesAccount(FALSE),-"Amount (LCY)",-"Additional-Currency Amount",FALSE);
            END;
          VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT":
            ;
          VATPostingSetup."VAT Calculation Type"::"Sales Tax":
            BEGIN
              TESTFIELD("Tax Jurisdiction Code");
              TaxJurisdiction.GET("Tax Jurisdiction Code");
              CreateGLEntry(
                GenJnlLine,TaxJurisdiction.GetPurchAccount(FALSE),-"Amount (LCY)",-"Additional-Currency Amount",FALSE);
            END;
        END;
      END;
    END;

    LOCAL PROCEDURE PostDtldVendVATAdjustment@73(GenJnlLine@1004 : Record 81;DtldCVLedgEntryBuf@1002 : Record 383;OriginalTransactionNo@1000 : Integer);
    VAR
      VATPostingSetup@1003 : Record 325;
      TaxJurisdiction@1005 : Record 320;
    BEGIN
      WITH DtldCVLedgEntryBuf DO BEGIN
        FindVATEntry(VATEntry,OriginalTransactionNo);

        CASE VATPostingSetup."VAT Calculation Type" OF
          VATPostingSetup."VAT Calculation Type"::"Normal VAT",
          VATPostingSetup."VAT Calculation Type"::"Full VAT":
            BEGIN
              VATPostingSetup.GET("VAT Bus. Posting Group","VAT Prod. Posting Group");
              VATPostingSetup.TESTFIELD("VAT Calculation Type",VATEntry."VAT Calculation Type");
              CreateGLEntry(
                GenJnlLine,VATPostingSetup.GetPurchAccount(FALSE),-"Amount (LCY)",-"Additional-Currency Amount",FALSE);
            END;
          VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT":
            BEGIN
              VATPostingSetup.GET("VAT Bus. Posting Group","VAT Prod. Posting Group");
              VATPostingSetup.TESTFIELD("VAT Calculation Type",VATEntry."VAT Calculation Type");
              CreateGLEntry(
                GenJnlLine,VATPostingSetup.GetPurchAccount(FALSE),-"Amount (LCY)",-"Additional-Currency Amount",FALSE);
              CreateGLEntry(
                GenJnlLine,VATPostingSetup.GetRevChargeAccount(FALSE),"Amount (LCY)","Additional-Currency Amount",FALSE);
            END;
          VATPostingSetup."VAT Calculation Type"::"Sales Tax":
            BEGIN
              TaxJurisdiction.GET("Tax Jurisdiction Code");
              IF "Use Tax" THEN BEGIN
                CreateGLEntry(
                  GenJnlLine,TaxJurisdiction.GetPurchAccount(FALSE),-"Amount (LCY)",-"Additional-Currency Amount",FALSE);
                CreateGLEntry(
                  GenJnlLine,TaxJurisdiction.GetRevChargeAccount(FALSE),"Amount (LCY)","Additional-Currency Amount",FALSE);
              END ELSE
                CreateGLEntry(
                  GenJnlLine,TaxJurisdiction.GetPurchAccount(FALSE),-"Amount (LCY)",-"Additional-Currency Amount",FALSE);
            END;
        END;
      END;
    END;

    LOCAL PROCEDURE VendUnrealizedVAT@18(GenJnlLine@1017 : Record 81;VAR VendLedgEntry2@1000 : Record 25;SettledAmount@1001 : Decimal);
    VAR
      VATEntry2@1002 : Record 254;
      TaxJurisdiction@1016 : Record 320;
      VATPostingSetup@1019 : Record 325;
      VATPart@1003 : Decimal;
      VATAmount@1004 : Decimal;
      VATBase@1005 : Decimal;
      VATAmountAddCurr@1006 : Decimal;
      VATBaseAddCurr@1007 : Decimal;
      PaidAmount@1008 : Decimal;
      TotalUnrealVATAmountFirst@1014 : Decimal;
      TotalUnrealVATAmountLast@1015 : Decimal;
      PurchVATAccount@1009 : Code[20];
      PurchVATUnrealAccount@1010 : Code[20];
      PurchReverseAccount@1011 : Code[20];
      PurchReverseUnrealAccount@1012 : Code[20];
      LastConnectionNo@1013 : Integer;
      GLEntryNo@1018 : Integer;
    BEGIN
      VATEntry2.RESET;
      VATEntry2.SETCURRENTKEY("Transaction No.");
      VATEntry2.SETRANGE("Transaction No.",VendLedgEntry2."Transaction No.");
      PaidAmount := -VendLedgEntry2."Amount (LCY)" + VendLedgEntry2."Remaining Amt. (LCY)";
      IF VATEntry2.FINDSET THEN
        REPEAT
          VATPostingSetup.GET(VATEntry2."VAT Bus. Posting Group",VATEntry2."VAT Prod. Posting Group");
          IF VATPostingSetup."Unrealized VAT Type" IN
             [VATPostingSetup."Unrealized VAT Type"::Last,VATPostingSetup."Unrealized VAT Type"::"Last (Fully Paid)"]
          THEN
            TotalUnrealVATAmountLast := TotalUnrealVATAmountLast - VATEntry2."Remaining Unrealized Amount";
          IF VATPostingSetup."Unrealized VAT Type" IN
             [VATPostingSetup."Unrealized VAT Type"::First,VATPostingSetup."Unrealized VAT Type"::"First (Fully Paid)"]
          THEN
            TotalUnrealVATAmountFirst := TotalUnrealVATAmountFirst - VATEntry2."Remaining Unrealized Amount";
        UNTIL VATEntry2.NEXT = 0;
      IF VATEntry2.FINDSET THEN BEGIN
        LastConnectionNo := 0;
        REPEAT
          VATPostingSetup.GET(VATEntry2."VAT Bus. Posting Group",VATEntry2."VAT Prod. Posting Group");
          IF LastConnectionNo <> VATEntry2."Sales Tax Connection No." THEN BEGIN
            InsertSummarizedVAT(GenJnlLine);
            LastConnectionNo := VATEntry2."Sales Tax Connection No.";
          END;

          VATPart :=
            VATEntry2.GetUnrealizedVATPart(
              ROUND(SettledAmount / VendLedgEntry2.GetOriginalCurrencyFactor),
              PaidAmount,
              VendLedgEntry2."Original Amt. (LCY)",
              TotalUnrealVATAmountFirst,
              TotalUnrealVATAmountLast);

          IF VATPart > 0 THEN BEGIN
            CASE VATEntry2."VAT Calculation Type" OF
              VATEntry2."VAT Calculation Type"::"Normal VAT",
              VATEntry2."VAT Calculation Type"::"Full VAT":
                BEGIN
                  PurchVATAccount := VATPostingSetup.GetPurchAccount(FALSE);
                  PurchVATUnrealAccount := VATPostingSetup.GetPurchAccount(TRUE);
                END;
              VATEntry2."VAT Calculation Type"::"Reverse Charge VAT":
                BEGIN
                  PurchVATAccount := VATPostingSetup.GetPurchAccount(FALSE);
                  PurchVATUnrealAccount := VATPostingSetup.GetPurchAccount(TRUE);
                  PurchReverseAccount := VATPostingSetup.GetRevChargeAccount(FALSE);
                  PurchReverseUnrealAccount := VATPostingSetup.GetRevChargeAccount(TRUE);
                END;
              VATEntry2."VAT Calculation Type"::"Sales Tax":
                IF (VATEntry2.Type = VATEntry2.Type::Purchase) AND VATEntry2."Use Tax" THEN BEGIN
                  TaxJurisdiction.GET(VATEntry2."Tax Jurisdiction Code");
                  PurchVATAccount := TaxJurisdiction.GetPurchAccount(FALSE);
                  PurchVATUnrealAccount := TaxJurisdiction.GetPurchAccount(TRUE);
                  PurchReverseAccount := TaxJurisdiction.GetRevChargeAccount(FALSE);
                  PurchReverseUnrealAccount := TaxJurisdiction.GetRevChargeAccount(TRUE);
                END ELSE BEGIN
                  TaxJurisdiction.GET(VATEntry2."Tax Jurisdiction Code");
                  PurchVATAccount := TaxJurisdiction.GetPurchAccount(FALSE);
                  PurchVATUnrealAccount := TaxJurisdiction.GetPurchAccount(TRUE);
                END;
            END;

            IF VATPart = 1 THEN BEGIN
              VATAmount := VATEntry2."Remaining Unrealized Amount";
              VATBase := VATEntry2."Remaining Unrealized Base";
              VATAmountAddCurr := VATEntry2."Add.-Curr. Rem. Unreal. Amount";
              VATBaseAddCurr := VATEntry2."Add.-Curr. Rem. Unreal. Base";
            END ELSE BEGIN
              VATAmount := ROUND(VATEntry2."Remaining Unrealized Amount" * VATPart,GLSetup."Amount Rounding Precision");
              VATBase := ROUND(VATEntry2."Remaining Unrealized Base" * VATPart,GLSetup."Amount Rounding Precision");
              VATAmountAddCurr :=
                ROUND(
                  VATEntry2."Add.-Curr. Rem. Unreal. Amount" * VATPart,
                  AddCurrency."Amount Rounding Precision");
              VATBaseAddCurr :=
                ROUND(
                  VATEntry2."Add.-Curr. Rem. Unreal. Base" * VATPart,
                  AddCurrency."Amount Rounding Precision");
            END;

            InitGLEntryVAT(
              GenJnlLine,PurchVATUnrealAccount,PurchVATAccount,-VATAmount,-VATAmountAddCurr,FALSE);
            GLEntryNo :=
              InitGLEntryVATCopy(GenJnlLine,PurchVATAccount,PurchVATUnrealAccount,VATAmount,VATAmountAddCurr,VATEntry2);

            IF (VATEntry2."VAT Calculation Type" =
                VATEntry2."VAT Calculation Type"::"Reverse Charge VAT") OR
               ((VATEntry2."VAT Calculation Type" =
                 VATEntry2."VAT Calculation Type"::"Sales Tax") AND
                (VATEntry2.Type = VATEntry2.Type::Purchase) AND VATEntry2."Use Tax")
            THEN BEGIN
              InitGLEntryVAT(
                GenJnlLine,PurchReverseUnrealAccount,PurchReverseAccount,VATAmount,VATAmountAddCurr,FALSE);
              GLEntryNo :=
                InitGLEntryVATCopy(GenJnlLine,PurchReverseAccount,PurchReverseUnrealAccount,-VATAmount,-VATAmountAddCurr,VATEntry2);
            END;

            PostUnrealVATEntry(GenJnlLine,VATEntry2,VATAmount,VATBase,VATAmountAddCurr,VATBaseAddCurr,GLEntryNo);
          END;
        UNTIL VATEntry2.NEXT = 0;

        InsertSummarizedVAT(GenJnlLine);
      END;
    END;

    LOCAL PROCEDURE PostUnrealVATEntry@5(GenJnlLine@1002 : Record 81;VAR VATEntry2@1000 : Record 254;VATAmount@1003 : Decimal;VATBase@1004 : Decimal;VATAmountAddCurr@1006 : Decimal;VATBaseAddCurr@1005 : Decimal;GLEntryNo@1001 : Integer);
    BEGIN
      VATEntry.LOCKTABLE;
      VATEntry := VATEntry2;
      VATEntry."Entry No." := NextVATEntryNo;
      VATEntry."Posting Date" := GenJnlLine."Posting Date";
      VATEntry."Document No." := GenJnlLine."Document No.";
      VATEntry."External Document No." := GenJnlLine."External Document No.";
      VATEntry."Document Type" := GenJnlLine."Document Type";
      VATEntry.Amount := VATAmount;
      VATEntry.Base := VATBase;
      VATEntry."Additional-Currency Amount" := VATAmountAddCurr;
      VATEntry."Additional-Currency Base" := VATBaseAddCurr;
      VATEntry.SetUnrealAmountsToZero;
      VATEntry."User ID" := USERID;
      VATEntry."Source Code" := GenJnlLine."Source Code";
      VATEntry."Reason Code" := GenJnlLine."Reason Code";
      VATEntry."Closed by Entry No." := 0;
      VATEntry.Closed := FALSE;
      VATEntry."Transaction No." := NextTransactionNo;
      VATEntry."Sales Tax Connection No." := NextConnectionNo;
      VATEntry."Unrealized VAT Entry No." := VATEntry2."Entry No.";
      VATEntry.INSERT(TRUE);
      GLEntryVATEntryLink.InsertLink(GLEntryNo + 1,NextVATEntryNo);
      NextVATEntryNo := NextVATEntryNo + 1;

      VATEntry2."Remaining Unrealized Amount" :=
        VATEntry2."Remaining Unrealized Amount" - VATEntry.Amount;
      VATEntry2."Remaining Unrealized Base" :=
        VATEntry2."Remaining Unrealized Base" - VATEntry.Base;
      VATEntry2."Add.-Curr. Rem. Unreal. Amount" :=
        VATEntry2."Add.-Curr. Rem. Unreal. Amount" - VATEntry."Additional-Currency Amount";
      VATEntry2."Add.-Curr. Rem. Unreal. Base" :=
        VATEntry2."Add.-Curr. Rem. Unreal. Base" - VATEntry."Additional-Currency Base";
      VATEntry2.MODIFY;
    END;

    LOCAL PROCEDURE PostApply@105(GenJnlLine@1007 : Record 81;VAR DtldCVLedgEntryBuf@1008 : Record 383;VAR OldCVLedgEntryBuf@1000 : Record 382;VAR NewCVLedgEntryBuf@1005 : Record 382;VAR NewCVLedgEntryBuf2@1013 : Record 382;BlockPaymentTolerance@1006 : Boolean;AllApplied@1009 : Boolean;VAR AppliedAmount@1016 : Decimal;VAR PmtTolAmtToBeApplied@1010 : Decimal);
    VAR
      OldCVLedgEntryBuf2@1003 : Record 382;
      OldCVLedgEntryBuf3@1002 : Record 382;
      OldRemainingAmtBeforeAppln@1001 : Decimal;
      ApplnRoundingPrecision@1004 : Decimal;
      AppliedAmountLCY@1012 : Decimal;
      OldAppliedAmount@1011 : Decimal;
    BEGIN
      OldRemainingAmtBeforeAppln := OldCVLedgEntryBuf."Remaining Amount";
      OldCVLedgEntryBuf3 := OldCVLedgEntryBuf;

      // Management of posting in multiple currencies
      OldCVLedgEntryBuf2 := OldCVLedgEntryBuf;
      OldCVLedgEntryBuf.COPYFILTER(Positive,OldCVLedgEntryBuf2.Positive);
      ApplnRoundingPrecision := GetApplnRoundPrecision(NewCVLedgEntryBuf,OldCVLedgEntryBuf);

      OldCVLedgEntryBuf2.RecalculateAmounts(
        OldCVLedgEntryBuf2."Currency Code",NewCVLedgEntryBuf."Currency Code",NewCVLedgEntryBuf."Posting Date");

      IF NOT BlockPaymentTolerance THEN
        CalcPmtTolerance(
          NewCVLedgEntryBuf,OldCVLedgEntryBuf,OldCVLedgEntryBuf2,DtldCVLedgEntryBuf,GenJnlLine,
          PmtTolAmtToBeApplied,NextTransactionNo,FirstNewVATEntryNo);

      CalcPmtDisc(
        NewCVLedgEntryBuf,OldCVLedgEntryBuf,OldCVLedgEntryBuf2,DtldCVLedgEntryBuf,GenJnlLine,
        PmtTolAmtToBeApplied,ApplnRoundingPrecision,NextTransactionNo,FirstNewVATEntryNo);

      IF NOT BlockPaymentTolerance THEN
        CalcPmtDiscTolerance(
          NewCVLedgEntryBuf,OldCVLedgEntryBuf,OldCVLedgEntryBuf2,DtldCVLedgEntryBuf,GenJnlLine,
          NextTransactionNo,FirstNewVATEntryNo);

      CalcCurrencyApplnRounding(
        NewCVLedgEntryBuf,OldCVLedgEntryBuf2,DtldCVLedgEntryBuf,
        GenJnlLine,ApplnRoundingPrecision);

      FindAmtForAppln(
        NewCVLedgEntryBuf,OldCVLedgEntryBuf,OldCVLedgEntryBuf2,
        AppliedAmount,AppliedAmountLCY,OldAppliedAmount,ApplnRoundingPrecision);

      CalcCurrencyUnrealizedGainLoss(
        OldCVLedgEntryBuf,DtldCVLedgEntryBuf,GenJnlLine,-OldAppliedAmount,OldRemainingAmtBeforeAppln);

      CalcCurrencyRealizedGainLoss(
        NewCVLedgEntryBuf,DtldCVLedgEntryBuf,GenJnlLine,AppliedAmount,AppliedAmountLCY);

      CalcCurrencyRealizedGainLoss(
        OldCVLedgEntryBuf,DtldCVLedgEntryBuf,GenJnlLine,-OldAppliedAmount,-AppliedAmountLCY);

      CalcApplication(
        NewCVLedgEntryBuf,OldCVLedgEntryBuf,DtldCVLedgEntryBuf,
        GenJnlLine,AppliedAmount,AppliedAmountLCY,OldAppliedAmount,
        NewCVLedgEntryBuf2,OldCVLedgEntryBuf3,AllApplied);

      PaymentToleranceMgt.CalcRemainingPmtDisc(NewCVLedgEntryBuf,OldCVLedgEntryBuf,OldCVLedgEntryBuf2,GLSetup);

      CalcAmtLCYAdjustment(OldCVLedgEntryBuf,DtldCVLedgEntryBuf,GenJnlLine);
    END;

    [External]
    PROCEDURE UnapplyCustLedgEntry@109(GenJnlLine2@1004 : Record 81;DtldCustLedgEntry@1003 : Record 379);
    VAR
      Cust@1006 : Record 18;
      CustPostingGr@1019 : Record 92;
      GenJnlLine@1021 : Record 81;
      DtldCustLedgEntry2@1013 : Record 379;
      NewDtldCustLedgEntry@1012 : Record 379;
      CustLedgEntry@1011 : Record 21;
      DtldCVLedgEntryBuf@1010 : Record 383;
      VATEntry@1009 : Record 254;
      TempVATEntry2@1023 : TEMPORARY Record 254;
      CurrencyLCY@1024 : Record 4;
      TempInvPostBuf@1002 : TEMPORARY Record 49;
      AdjAmount@1031 : ARRAY [4] OF Decimal;
      NextDtldLedgEntryNo@1001 : Integer;
      UnapplyVATEntries@1000 : Boolean;
    BEGIN
      GenJnlLine.TRANSFERFIELDS(GenJnlLine2);
      IF GenJnlLine."Document Date" = 0D THEN
        GenJnlLine."Document Date" := GenJnlLine."Posting Date";

      IF NextEntryNo = 0 THEN
        StartPosting(GenJnlLine)
      ELSE
        ContinuePosting(GenJnlLine);

      ReadGLSetup(GLSetup);

      Cust.GET(DtldCustLedgEntry."Customer No.");
      Cust.CheckBlockedCustOnJnls(Cust,GenJnlLine2."Document Type"::Payment,TRUE);
      CustPostingGr.GET(GenJnlLine."Posting Group");
      CustPostingGr.GetReceivablesAccount;

      VATEntry.LOCKTABLE;
      DtldCustLedgEntry.LOCKTABLE;
      CustLedgEntry.LOCKTABLE;

      DtldCustLedgEntry.TESTFIELD("Entry Type",DtldCustLedgEntry."Entry Type"::Application);

      DtldCustLedgEntry2.RESET;
      DtldCustLedgEntry2.FINDLAST;
      NextDtldLedgEntryNo := DtldCustLedgEntry2."Entry No." + 1;
      IF DtldCustLedgEntry."Transaction No." = 0 THEN BEGIN
        DtldCustLedgEntry2.SETCURRENTKEY("Application No.","Customer No.","Entry Type");
        DtldCustLedgEntry2.SETRANGE("Application No.",DtldCustLedgEntry."Application No.");
      END ELSE BEGIN
        DtldCustLedgEntry2.SETCURRENTKEY("Transaction No.","Customer No.","Entry Type");
        DtldCustLedgEntry2.SETRANGE("Transaction No.",DtldCustLedgEntry."Transaction No.");
      END;
      DtldCustLedgEntry2.SETRANGE("Customer No.",DtldCustLedgEntry."Customer No.");
      DtldCustLedgEntry2.SETFILTER("Entry Type",'>%1',DtldCustLedgEntry."Entry Type"::"Initial Entry");
      IF DtldCustLedgEntry."Transaction No." <> 0 THEN BEGIN
        UnapplyVATEntries := FALSE;
        DtldCustLedgEntry2.FINDSET;
        REPEAT
          DtldCustLedgEntry2.TESTFIELD(Unapplied,FALSE);
          IF IsVATAdjustment(DtldCustLedgEntry2."Entry Type") THEN
            UnapplyVATEntries := TRUE
        UNTIL DtldCustLedgEntry2.NEXT = 0;

        PostUnapply(
          GenJnlLine,VATEntry,VATEntry.Type::Sale,
          DtldCustLedgEntry."Customer No.",DtldCustLedgEntry."Transaction No.",UnapplyVATEntries,TempVATEntry);

        DtldCustLedgEntry2.FINDSET;
        REPEAT
          DtldCVLedgEntryBuf.INIT;
          DtldCVLedgEntryBuf.TRANSFERFIELDS(DtldCustLedgEntry2);
          ProcessTempVATEntry(DtldCVLedgEntryBuf,TempVATEntry);
        UNTIL DtldCustLedgEntry2.NEXT = 0;
      END;

      // Look one more time
      DtldCustLedgEntry2.FINDSET;
      TempInvPostBuf.DELETEALL;
      REPEAT
        DtldCustLedgEntry2.TESTFIELD(Unapplied,FALSE);
        InsertDtldCustLedgEntryUnapply(GenJnlLine,NewDtldCustLedgEntry,DtldCustLedgEntry2,NextDtldLedgEntryNo);

        DtldCVLedgEntryBuf.INIT;
        DtldCVLedgEntryBuf.TRANSFERFIELDS(NewDtldCustLedgEntry);
        SetAddCurrForUnapplication(DtldCVLedgEntryBuf);
        CurrencyLCY.InitRoundingPrecision;

        IF (DtldCustLedgEntry2."Transaction No." <> 0) AND IsVATExcluded(DtldCustLedgEntry2."Entry Type") THEN BEGIN
          UnapplyExcludedVAT(
            TempVATEntry2,DtldCustLedgEntry2."Transaction No.",DtldCustLedgEntry2."VAT Bus. Posting Group",
            DtldCustLedgEntry2."VAT Prod. Posting Group",DtldCustLedgEntry2."Gen. Prod. Posting Group");
          DtldCVLedgEntryBuf."VAT Amount (LCY)" :=
            CalcVATAmountFromVATEntry(DtldCVLedgEntryBuf."Amount (LCY)",TempVATEntry2,CurrencyLCY);
        END;
        UpdateTotalAmounts(
          TempInvPostBuf,GenJnlLine."Dimension Set ID",DtldCVLedgEntryBuf."Amount (LCY)",
          DtldCVLedgEntryBuf."Additional-Currency Amount");

        IF NOT (DtldCVLedgEntryBuf."Entry Type" IN [
                                                    DtldCVLedgEntryBuf."Entry Type"::"Initial Entry",
                                                    DtldCVLedgEntryBuf."Entry Type"::Application])
        THEN
          CollectAdjustment(AdjAmount,
            -DtldCVLedgEntryBuf."Amount (LCY)",-DtldCVLedgEntryBuf."Additional-Currency Amount");

        PostDtldCustLedgEntryUnapply(
          GenJnlLine,DtldCVLedgEntryBuf,CustPostingGr,DtldCustLedgEntry2."Transaction No.");

        DtldCustLedgEntry2.Unapplied := TRUE;
        DtldCustLedgEntry2."Unapplied by Entry No." := NewDtldCustLedgEntry."Entry No.";
        DtldCustLedgEntry2.MODIFY;

        UpdateCustLedgEntry(DtldCustLedgEntry2);
      UNTIL DtldCustLedgEntry2.NEXT = 0;

      CreateGLEntriesForTotalAmountsUnapply(GenJnlLine,TempInvPostBuf,CustPostingGr.GetReceivablesAccount);

      IF IsTempGLEntryBufEmpty THEN
        DtldCustLedgEntry.SetZeroTransNo(NextTransactionNo);
      CheckPostUnrealizedVAT(GenJnlLine,TRUE);
      FinishPosting;
    END;

    [External]
    PROCEDURE UnapplyVendLedgEntry@108(GenJnlLine2@1003 : Record 81;DtldVendLedgEntry@1002 : Record 380);
    VAR
      Vend@1005 : Record 23;
      VendPostingGr@1019 : Record 93;
      GenJnlLine@1021 : Record 81;
      DtldVendLedgEntry2@1012 : Record 380;
      NewDtldVendLedgEntry@1011 : Record 380;
      VendLedgEntry@1010 : Record 25;
      DtldCVLedgEntryBuf@1009 : Record 383;
      VATEntry@1008 : Record 254;
      TempVATEntry2@1023 : TEMPORARY Record 254;
      CurrencyLCY@1024 : Record 4;
      TempInvPostBuf@1001 : TEMPORARY Record 49;
      AdjAmount@1031 : ARRAY [4] OF Decimal;
      NextDtldLedgEntryNo@1000 : Integer;
      UnapplyVATEntries@1013 : Boolean;
    BEGIN
      GenJnlLine.TRANSFERFIELDS(GenJnlLine2);
      IF GenJnlLine."Document Date" = 0D THEN
        GenJnlLine."Document Date" := GenJnlLine."Posting Date";

      IF NextEntryNo = 0 THEN
        StartPosting(GenJnlLine)
      ELSE
        ContinuePosting(GenJnlLine);

      ReadGLSetup(GLSetup);

      Vend.GET(DtldVendLedgEntry."Vendor No.");
      Vend.CheckBlockedVendOnJnls(Vend,GenJnlLine2."Document Type"::Payment,TRUE);
      VendPostingGr.GET(GenJnlLine."Posting Group");
      VendPostingGr.GetPayablesAccount;

      VATEntry.LOCKTABLE;
      DtldVendLedgEntry.LOCKTABLE;
      VendLedgEntry.LOCKTABLE;

      DtldVendLedgEntry.TESTFIELD("Entry Type",DtldVendLedgEntry."Entry Type"::Application);

      DtldVendLedgEntry2.RESET;
      DtldVendLedgEntry2.FINDLAST;
      NextDtldLedgEntryNo := DtldVendLedgEntry2."Entry No." + 1;
      IF DtldVendLedgEntry."Transaction No." = 0 THEN BEGIN
        DtldVendLedgEntry2.SETCURRENTKEY("Application No.","Vendor No.","Entry Type");
        DtldVendLedgEntry2.SETRANGE("Application No.",DtldVendLedgEntry."Application No.");
      END ELSE BEGIN
        DtldVendLedgEntry2.SETCURRENTKEY("Transaction No.","Vendor No.","Entry Type");
        DtldVendLedgEntry2.SETRANGE("Transaction No.",DtldVendLedgEntry."Transaction No.");
      END;
      DtldVendLedgEntry2.SETRANGE("Vendor No.",DtldVendLedgEntry."Vendor No.");
      DtldVendLedgEntry2.SETFILTER("Entry Type",'>%1',DtldVendLedgEntry."Entry Type"::"Initial Entry");
      IF DtldVendLedgEntry."Transaction No." <> 0 THEN BEGIN
        UnapplyVATEntries := FALSE;
        DtldVendLedgEntry2.FINDSET;
        REPEAT
          DtldVendLedgEntry2.TESTFIELD(Unapplied,FALSE);
          IF IsVATAdjustment(DtldVendLedgEntry2."Entry Type") THEN
            UnapplyVATEntries := TRUE
        UNTIL DtldVendLedgEntry2.NEXT = 0;

        PostUnapply(
          GenJnlLine,VATEntry,VATEntry.Type::Purchase,
          DtldVendLedgEntry."Vendor No.",DtldVendLedgEntry."Transaction No.",UnapplyVATEntries,TempVATEntry);

        DtldVendLedgEntry2.FINDSET;
        REPEAT
          DtldCVLedgEntryBuf.INIT;
          DtldCVLedgEntryBuf.TRANSFERFIELDS(DtldVendLedgEntry2);
          ProcessTempVATEntry(DtldCVLedgEntryBuf,TempVATEntry);
        UNTIL DtldVendLedgEntry2.NEXT = 0;
      END;

      // Look one more time
      DtldVendLedgEntry2.FINDSET;
      TempInvPostBuf.DELETEALL;
      REPEAT
        DtldVendLedgEntry2.TESTFIELD(Unapplied,FALSE);
        InsertDtldVendLedgEntryUnapply(GenJnlLine,NewDtldVendLedgEntry,DtldVendLedgEntry2,NextDtldLedgEntryNo);

        DtldCVLedgEntryBuf.INIT;
        DtldCVLedgEntryBuf.TRANSFERFIELDS(NewDtldVendLedgEntry);
        SetAddCurrForUnapplication(DtldCVLedgEntryBuf);
        CurrencyLCY.InitRoundingPrecision;

        IF (DtldVendLedgEntry2."Transaction No." <> 0) AND IsVATExcluded(DtldVendLedgEntry2."Entry Type") THEN BEGIN
          UnapplyExcludedVAT(
            TempVATEntry2,DtldVendLedgEntry2."Transaction No.",DtldVendLedgEntry2."VAT Bus. Posting Group",
            DtldVendLedgEntry2."VAT Prod. Posting Group",DtldVendLedgEntry2."Gen. Prod. Posting Group");
          DtldCVLedgEntryBuf."VAT Amount (LCY)" :=
            CalcVATAmountFromVATEntry(DtldCVLedgEntryBuf."Amount (LCY)",TempVATEntry2,CurrencyLCY);
        END;
        UpdateTotalAmounts(
          TempInvPostBuf,GenJnlLine."Dimension Set ID",DtldCVLedgEntryBuf."Amount (LCY)",
          DtldCVLedgEntryBuf."Additional-Currency Amount");

        IF NOT (DtldCVLedgEntryBuf."Entry Type" IN [
                                                    DtldCVLedgEntryBuf."Entry Type"::"Initial Entry",
                                                    DtldCVLedgEntryBuf."Entry Type"::Application])
        THEN
          CollectAdjustment(AdjAmount,
            -DtldCVLedgEntryBuf."Amount (LCY)",-DtldCVLedgEntryBuf."Additional-Currency Amount");

        PostDtldVendLedgEntryUnapply(
          GenJnlLine,DtldCVLedgEntryBuf,VendPostingGr,DtldVendLedgEntry2."Transaction No.");

        DtldVendLedgEntry2.Unapplied := TRUE;
        DtldVendLedgEntry2."Unapplied by Entry No." := NewDtldVendLedgEntry."Entry No.";
        DtldVendLedgEntry2.MODIFY;

        UpdateVendLedgEntry(DtldVendLedgEntry2);
      UNTIL DtldVendLedgEntry2.NEXT = 0;

      CreateGLEntriesForTotalAmountsUnapply(GenJnlLine,TempInvPostBuf,VendPostingGr.GetPayablesAccount);

      IF IsTempGLEntryBufEmpty THEN
        DtldVendLedgEntry.SetZeroTransNo(NextTransactionNo);
      CheckPostUnrealizedVAT(GenJnlLine,TRUE);
      FinishPosting;
    END;

    [Internal]
    PROCEDURE UnapplyEmplLedgEntry@89(GenJnlLine2@1003 : Record 81;DtldEmplLedgEntry@1002 : Record 5223);
    VAR
      Employee@1005 : Record 5200;
      EmployeePostingGroup@1019 : Record 5221;
      GenJnlLine@1021 : Record 81;
      DtldEmplLedgEntry2@1012 : Record 5223;
      NewDtldEmplLedgEntry@1011 : Record 5223;
      EmplLedgEntry@1010 : Record 5222;
      DtldCVLedgEntryBuf@1009 : Record 383;
      CurrencyLCY@1024 : Record 4;
      TempInvPostBuf@1001 : TEMPORARY Record 49;
      NextDtldLedgEntryNo@1000 : Integer;
    BEGIN
      GenJnlLine.TRANSFERFIELDS(GenJnlLine2);
      IF GenJnlLine."Document Date" = 0D THEN
        GenJnlLine."Document Date" := GenJnlLine."Posting Date";

      IF NextEntryNo = 0 THEN
        StartPosting(GenJnlLine)
      ELSE
        ContinuePosting(GenJnlLine);

      ReadGLSetup(GLSetup);

      Employee.GET(DtldEmplLedgEntry."Employee No.");
      EmployeePostingGroup.GET(GenJnlLine."Posting Group");
      EmployeePostingGroup.GetPayablesAccount;

      DtldEmplLedgEntry.LOCKTABLE;
      EmplLedgEntry.LOCKTABLE;

      DtldEmplLedgEntry.TESTFIELD("Entry Type",DtldEmplLedgEntry."Entry Type"::Application);

      DtldEmplLedgEntry2.RESET;
      DtldEmplLedgEntry2.FINDLAST;
      NextDtldLedgEntryNo := DtldEmplLedgEntry2."Entry No." + 1;
      IF DtldEmplLedgEntry."Transaction No." = 0 THEN BEGIN
        DtldEmplLedgEntry2.SETCURRENTKEY("Application No.","Employee No.","Entry Type");
        DtldEmplLedgEntry2.SETRANGE("Application No.",DtldEmplLedgEntry."Application No.");
      END ELSE BEGIN
        DtldEmplLedgEntry2.SETCURRENTKEY("Transaction No.","Employee No.","Entry Type");
        DtldEmplLedgEntry2.SETRANGE("Transaction No.",DtldEmplLedgEntry."Transaction No.");
      END;
      DtldEmplLedgEntry2.SETRANGE("Employee No.",DtldEmplLedgEntry."Employee No.");
      DtldEmplLedgEntry2.SETFILTER("Entry Type",'>%1',DtldEmplLedgEntry."Entry Type"::"Initial Entry");

      // Look one more time
      DtldEmplLedgEntry2.FINDSET;
      TempInvPostBuf.DELETEALL;
      REPEAT
        DtldEmplLedgEntry2.TESTFIELD(Unapplied,FALSE);
        InsertDtldEmplLedgEntryUnapply(GenJnlLine,NewDtldEmplLedgEntry,DtldEmplLedgEntry2,NextDtldLedgEntryNo);

        DtldCVLedgEntryBuf.INIT;
        DtldCVLedgEntryBuf.TRANSFERFIELDS(NewDtldEmplLedgEntry);
        SetAddCurrForUnapplication(DtldCVLedgEntryBuf);
        CurrencyLCY.InitRoundingPrecision;

        UpdateTotalAmounts(
          TempInvPostBuf,GenJnlLine."Dimension Set ID",DtldCVLedgEntryBuf."Amount (LCY)",
          DtldCVLedgEntryBuf."Additional-Currency Amount");

        DtldEmplLedgEntry2.Unapplied := TRUE;
        DtldEmplLedgEntry2."Unapplied by Entry No." := NewDtldEmplLedgEntry."Entry No.";
        DtldEmplLedgEntry2.MODIFY;

        UpdateEmplLedgEntry(DtldEmplLedgEntry2);
      UNTIL DtldEmplLedgEntry2.NEXT = 0;

      CreateGLEntriesForTotalAmountsUnapply(GenJnlLine,TempInvPostBuf,EmployeePostingGroup.GetPayablesAccount);

      IF IsTempGLEntryBufEmpty THEN
        DtldEmplLedgEntry.SetZeroTransNo(NextTransactionNo);
      FinishPosting;
    END;

    LOCAL PROCEDURE UnapplyExcludedVAT@85(VAR TempVATEntry@1000 : TEMPORARY Record 254;TransactionNo@1004 : Integer;VATBusPostingGroup@1001 : Code[20];VATProdPostingGroup@1002 : Code[20];GenProdPostingGroup@1003 : Code[20]);
    BEGIN
      TempVATEntry.SETRANGE("VAT Bus. Posting Group",VATBusPostingGroup);
      TempVATEntry.SETRANGE("VAT Prod. Posting Group",VATProdPostingGroup);
      TempVATEntry.SETRANGE("Gen. Prod. Posting Group",GenProdPostingGroup);
      IF NOT TempVATEntry.FINDFIRST THEN BEGIN
        TempVATEntry.RESET;
        IF TempVATEntry.FINDLAST THEN
          TempVATEntry."Entry No." := TempVATEntry."Entry No." + 1
        ELSE
          TempVATEntry."Entry No." := 1;
        TempVATEntry.INIT;
        TempVATEntry."VAT Bus. Posting Group" := VATBusPostingGroup;
        TempVATEntry."VAT Prod. Posting Group" := VATProdPostingGroup;
        TempVATEntry."Gen. Prod. Posting Group" := GenProdPostingGroup;
        VATEntry.SETCURRENTKEY("Transaction No.");
        VATEntry.SETRANGE("Transaction No.",TransactionNo);
        VATEntry.SETRANGE("VAT Bus. Posting Group",VATBusPostingGroup);
        VATEntry.SETRANGE("VAT Prod. Posting Group",VATProdPostingGroup);
        VATEntry.SETRANGE("Gen. Prod. Posting Group",GenProdPostingGroup);
        IF VATEntry.FINDSET THEN
          REPEAT
            IF VATEntry."Unrealized VAT Entry No." = 0 THEN BEGIN
              TempVATEntry.Base := TempVATEntry.Base + VATEntry.Base;
              TempVATEntry.Amount := TempVATEntry.Amount + VATEntry.Amount;
            END;
          UNTIL VATEntry.NEXT = 0;
        CLEAR(VATEntry);
        TempVATEntry.INSERT;
      END;
    END;

    LOCAL PROCEDURE PostUnrealVATByUnapply@106(GenJnlLine@1002 : Record 81;VATPostingSetup@1008 : Record 325;VATEntry@1005 : Record 254;NewVATEntry@1004 : Record 254);
    VAR
      VATEntry2@1003 : Record 254;
      AmountAddCurr@1007 : Decimal;
    BEGIN
      AmountAddCurr := CalcAddCurrForUnapplication(VATEntry."Posting Date",VATEntry.Amount);
      CreateGLEntry(
        GenJnlLine,GetPostingAccountNo(VATPostingSetup,VATEntry,TRUE),VATEntry.Amount,AmountAddCurr,FALSE);
      CreateGLEntryFromVATEntry(
        GenJnlLine,GetPostingAccountNo(VATPostingSetup,VATEntry,FALSE),-VATEntry.Amount,-AmountAddCurr,VATEntry);

      WITH VATEntry2 DO BEGIN
        GET(VATEntry."Unrealized VAT Entry No.");
        "Remaining Unrealized Amount" := "Remaining Unrealized Amount" - NewVATEntry.Amount;
        "Remaining Unrealized Base" := "Remaining Unrealized Base" - NewVATEntry.Base;
        "Add.-Curr. Rem. Unreal. Amount" :=
          "Add.-Curr. Rem. Unreal. Amount" - NewVATEntry."Additional-Currency Amount";
        "Add.-Curr. Rem. Unreal. Base" :=
          "Add.-Curr. Rem. Unreal. Base" - NewVATEntry."Additional-Currency Base";
        MODIFY;
      END;
    END;

    LOCAL PROCEDURE PostPmtDiscountVATByUnapply@104(GenJnlLine@1003 : Record 81;ReverseChargeVATAccNo@1002 : Code[20];VATAccNo@1001 : Code[20];VATEntry@1000 : Record 254);
    VAR
      AmountAddCurr@1005 : Decimal;
    BEGIN
      AmountAddCurr := CalcAddCurrForUnapplication(VATEntry."Posting Date",VATEntry.Amount);
      CreateGLEntry(GenJnlLine,ReverseChargeVATAccNo,VATEntry.Amount,AmountAddCurr,FALSE);
      CreateGLEntry(GenJnlLine,VATAccNo,-VATEntry.Amount,-AmountAddCurr,FALSE);
    END;

    LOCAL PROCEDURE PostUnapply@101(GenJnlLine@1007 : Record 81;VAR VATEntry@1002 : Record 254;VATEntryType@1004 : Option;BilltoPaytoNo@1001 : Code[20];TransactionNo@1003 : Integer;UnapplyVATEntries@1006 : Boolean;VAR TempVATEntry@1013 : TEMPORARY Record 254);
    VAR
      VATPostingSetup@1000 : Record 325;
      VATEntry2@1009 : Record 254;
      GLEntryVATEntryLink@1011 : Record 253;
      AccNo@1010 : Code[20];
      TempVATEntryNo@1005 : Integer;
    BEGIN
      TempVATEntryNo := 1;
      VATEntry.SETCURRENTKEY(Type,"Bill-to/Pay-to No.","Transaction No.");
      VATEntry.SETRANGE(Type,VATEntryType);
      VATEntry.SETRANGE("Bill-to/Pay-to No.",BilltoPaytoNo);
      VATEntry.SETRANGE("Transaction No.",TransactionNo);
      IF VATEntry.FINDSET THEN
        REPEAT
          VATPostingSetup.GET(VATEntry."VAT Bus. Posting Group",VATEntry."VAT Prod. Posting Group");
          IF UnapplyVATEntries OR (VATEntry."Unrealized VAT Entry No." <> 0) THEN BEGIN
            InsertTempVATEntry(GenJnlLine,VATEntry,TempVATEntryNo,TempVATEntry);
            IF VATEntry."Unrealized VAT Entry No." <> 0 THEN BEGIN
              VATPostingSetup.GET(VATEntry."VAT Bus. Posting Group",VATEntry."VAT Prod. Posting Group");
              IF VATPostingSetup."VAT Calculation Type" IN
                 [VATPostingSetup."VAT Calculation Type"::"Normal VAT",
                  VATPostingSetup."VAT Calculation Type"::"Full VAT"]
              THEN
                PostUnrealVATByUnapply(GenJnlLine,VATPostingSetup,VATEntry,TempVATEntry)
              ELSE
                IF VATPostingSetup."VAT Calculation Type" = VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT" THEN BEGIN
                  PostUnrealVATByUnapply(GenJnlLine,VATPostingSetup,VATEntry,TempVATEntry);
                  CreateGLEntry(
                    GenJnlLine,VATPostingSetup.GetRevChargeAccount(TRUE),
                    -VATEntry.Amount,CalcAddCurrForUnapplication(VATEntry."Posting Date",-VATEntry.Amount),FALSE);
                  CreateGLEntry(
                    GenJnlLine,VATPostingSetup.GetRevChargeAccount(FALSE),
                    VATEntry.Amount,CalcAddCurrForUnapplication(VATEntry."Posting Date",VATEntry.Amount),FALSE);
                END ELSE
                  PostUnrealVATByUnapply(GenJnlLine,VATPostingSetup,VATEntry,TempVATEntry);
              VATEntry2 := TempVATEntry;
              VATEntry2."Entry No." := NextVATEntryNo;
              VATEntry2.INSERT;
              IF VATEntry2."Unrealized VAT Entry No." = 0 THEN
                GLEntryVATEntryLink.InsertLink(NextEntryNo,VATEntry2."Entry No.");
              TempVATEntry.DELETE;
              IncrNextVATEntryNo;
            END;

            IF VATPostingSetup."Adjust for Payment Discount" AND NOT IsNotPayment(VATEntry."Document Type") AND
               (VATPostingSetup."VAT Calculation Type" =
                VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT") AND
               (VATEntry."Unrealized VAT Entry No." = 0) AND UnapplyVATEntries
            THEN BEGIN
              CASE VATEntryType OF
                VATEntry.Type::Sale:
                  AccNo := VATPostingSetup.GetSalesAccount(FALSE);
                VATEntry.Type::Purchase:
                  AccNo := VATPostingSetup.GetPurchAccount(FALSE);
              END;
              PostPmtDiscountVATByUnapply(GenJnlLine,VATPostingSetup.GetRevChargeAccount(FALSE),AccNo,VATEntry);
            END;
          END;
        UNTIL VATEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE CalcAddCurrForUnapplication@100(Date@1001 : Date;Amt@1002 : Decimal) : Decimal;
    VAR
      AddCurrency@1000 : Record 4;
      CurrExchRate@1003 : Record 330;
    BEGIN
      IF AddCurrencyCode = '' THEN
        EXIT;

      AddCurrency.GET(AddCurrencyCode);
      AddCurrency.TESTFIELD("Amount Rounding Precision");

      EXIT(
        ROUND(
          CurrExchRate.ExchangeAmtLCYToFCY(
            Date,AddCurrencyCode,Amt,CurrExchRate.ExchangeRate(Date,AddCurrencyCode)),
          AddCurrency."Amount Rounding Precision"));
    END;

    LOCAL PROCEDURE CalcVATAmountFromVATEntry@99(AmountLCY@1000 : Decimal;VAR VATEntry@1001 : Record 254;CurrencyLCY@1003 : Record 4) VATAmountLCY : Decimal;
    BEGIN
      WITH VATEntry DO
        IF (AmountLCY = Base) OR (Base = 0) THEN BEGIN
          VATAmountLCY := Amount;
          DELETE;
        END ELSE BEGIN
          VATAmountLCY :=
            ROUND(
              Amount * AmountLCY / Base,
              CurrencyLCY."Amount Rounding Precision",
              CurrencyLCY.VATRoundingDirection);
          Base := Base - AmountLCY;
          Amount := Amount - VATAmountLCY;
          MODIFY;
        END;
    END;

    LOCAL PROCEDURE InsertDtldCustLedgEntryUnapply@91(GenJnlLine@1002 : Record 81;VAR NewDtldCustLedgEntry@1000 : Record 379;OldDtldCustLedgEntry@1001 : Record 379;VAR NextDtldLedgEntryNo@1003 : Integer);
    BEGIN
      NewDtldCustLedgEntry := OldDtldCustLedgEntry;
      WITH NewDtldCustLedgEntry DO BEGIN
        "Entry No." := NextDtldLedgEntryNo;
        "Posting Date" := GenJnlLine."Posting Date";
        "Transaction No." := NextTransactionNo;
        "Application No." := 0;
        Amount := -OldDtldCustLedgEntry.Amount;
        "Amount (LCY)" := -OldDtldCustLedgEntry."Amount (LCY)";
        "Debit Amount" := -OldDtldCustLedgEntry."Debit Amount";
        "Credit Amount" := -OldDtldCustLedgEntry."Credit Amount";
        "Debit Amount (LCY)" := -OldDtldCustLedgEntry."Debit Amount (LCY)";
        "Credit Amount (LCY)" := -OldDtldCustLedgEntry."Credit Amount (LCY)";
        Unapplied := TRUE;
        "Unapplied by Entry No." := OldDtldCustLedgEntry."Entry No.";
        "Document No." := GenJnlLine."Document No.";
        "Source Code" := GenJnlLine."Source Code";
        "User ID" := USERID;
        INSERT(TRUE);
      END;
      NextDtldLedgEntryNo := NextDtldLedgEntryNo + 1;
    END;

    LOCAL PROCEDURE InsertDtldVendLedgEntryUnapply@90(GenJnlLine@1003 : Record 81;VAR NewDtldVendLedgEntry@1002 : Record 380;OldDtldVendLedgEntry@1001 : Record 380;VAR NextDtldLedgEntryNo@1000 : Integer);
    BEGIN
      NewDtldVendLedgEntry := OldDtldVendLedgEntry;
      WITH NewDtldVendLedgEntry DO BEGIN
        "Entry No." := NextDtldLedgEntryNo;
        "Posting Date" := GenJnlLine."Posting Date";
        "Transaction No." := NextTransactionNo;
        "Application No." := 0;
        Amount := -OldDtldVendLedgEntry.Amount;
        "Amount (LCY)" := -OldDtldVendLedgEntry."Amount (LCY)";
        "Debit Amount" := -OldDtldVendLedgEntry."Debit Amount";
        "Credit Amount" := -OldDtldVendLedgEntry."Credit Amount";
        "Debit Amount (LCY)" := -OldDtldVendLedgEntry."Debit Amount (LCY)";
        "Credit Amount (LCY)" := -OldDtldVendLedgEntry."Credit Amount (LCY)";
        Unapplied := TRUE;
        "Unapplied by Entry No." := OldDtldVendLedgEntry."Entry No.";
        "Document No." := GenJnlLine."Document No.";
        "Source Code" := GenJnlLine."Source Code";
        "User ID" := USERID;
        INSERT(TRUE);
      END;
      NextDtldLedgEntryNo := NextDtldLedgEntryNo + 1;
    END;

    LOCAL PROCEDURE InsertDtldEmplLedgEntryUnapply@140(GenJnlLine@1003 : Record 81;VAR NewDtldEmplLedgEntry@1002 : Record 5223;OldDtldEmplLedgEntry@1001 : Record 5223;VAR NextDtldLedgEntryNo@1000 : Integer);
    BEGIN
      NewDtldEmplLedgEntry := OldDtldEmplLedgEntry;
      WITH NewDtldEmplLedgEntry DO BEGIN
        "Entry No." := NextDtldLedgEntryNo;
        "Posting Date" := GenJnlLine."Posting Date";
        "Transaction No." := NextTransactionNo;
        "Application No." := 0;
        Amount := -OldDtldEmplLedgEntry.Amount;
        "Amount (LCY)" := -OldDtldEmplLedgEntry."Amount (LCY)";
        "Debit Amount" := -OldDtldEmplLedgEntry."Debit Amount";
        "Credit Amount" := -OldDtldEmplLedgEntry."Credit Amount";
        "Debit Amount (LCY)" := -OldDtldEmplLedgEntry."Debit Amount (LCY)";
        "Credit Amount (LCY)" := -OldDtldEmplLedgEntry."Credit Amount (LCY)";
        Unapplied := TRUE;
        "Unapplied by Entry No." := OldDtldEmplLedgEntry."Entry No.";
        "Document No." := GenJnlLine."Document No.";
        "Source Code" := GenJnlLine."Source Code";
        "User ID" := USERID;
        INSERT(TRUE);
      END;
      NextDtldLedgEntryNo := NextDtldLedgEntryNo + 1;
    END;

    LOCAL PROCEDURE InsertTempVATEntry@88(GenJnlLine@1002 : Record 81;VATEntry@1000 : Record 254;VAR TempVATEntryNo@1001 : Integer;VAR TempVATEntry@1003 : TEMPORARY Record 254);
    BEGIN
      TempVATEntry := VATEntry;
      WITH TempVATEntry DO BEGIN
        "Entry No." := TempVATEntryNo;
        TempVATEntryNo := TempVATEntryNo + 1;
        "Closed by Entry No." := 0;
        Closed := FALSE;
        CopyAmountsFromVATEntry(VATEntry,TRUE);
        "Posting Date" := GenJnlLine."Posting Date";
        "Document No." := GenJnlLine."Document No.";
        "User ID" := USERID;
        "Transaction No." := NextTransactionNo;
        INSERT;
      END;
    END;

    LOCAL PROCEDURE ProcessTempVATEntry@87(DtldCVLedgEntryBuf@1000 : Record 383;VAR TempVATEntry@1004 : TEMPORARY Record 254);
    VAR
      VATEntrySaved@1005 : Record 254;
      VATBaseSum@1003 : ARRAY [3] OF Decimal;
      DeductedVATBase@1006 : Decimal;
      EntryNoBegin@1002 : ARRAY [3] OF Integer;
      i@1001 : Integer;
    BEGIN
      IF NOT (DtldCVLedgEntryBuf."Entry Type" IN
              [DtldCVLedgEntryBuf."Entry Type"::"Payment Discount (VAT Excl.)",
               DtldCVLedgEntryBuf."Entry Type"::"Payment Tolerance (VAT Excl.)",
               DtldCVLedgEntryBuf."Entry Type"::"Payment Discount Tolerance (VAT Excl.)"])
      THEN
        EXIT;

      DeductedVATBase := 0;
      TempVATEntry.RESET;
      TempVATEntry.SETRANGE("Entry No.",0,999999);
      TempVATEntry.SETRANGE("Gen. Bus. Posting Group",DtldCVLedgEntryBuf."Gen. Bus. Posting Group");
      TempVATEntry.SETRANGE("Gen. Prod. Posting Group",DtldCVLedgEntryBuf."Gen. Prod. Posting Group");
      TempVATEntry.SETRANGE("VAT Bus. Posting Group",DtldCVLedgEntryBuf."VAT Bus. Posting Group");
      TempVATEntry.SETRANGE("VAT Prod. Posting Group",DtldCVLedgEntryBuf."VAT Prod. Posting Group");
      IF TempVATEntry.FINDSET THEN
        REPEAT
          CASE TRUE OF
            VATBaseSum[3] + TempVATEntry.Base = DtldCVLedgEntryBuf."Amount (LCY)" - DeductedVATBase:
              i := 4;
            VATBaseSum[2] + TempVATEntry.Base = DtldCVLedgEntryBuf."Amount (LCY)" - DeductedVATBase:
              i := 3;
            VATBaseSum[1] + TempVATEntry.Base = DtldCVLedgEntryBuf."Amount (LCY)" - DeductedVATBase:
              i := 2;
            TempVATEntry.Base = DtldCVLedgEntryBuf."Amount (LCY)" - DeductedVATBase:
              i := 1;
            ELSE
              i := 0;
          END;
          IF i > 0 THEN BEGIN
            TempVATEntry.RESET;
            IF i > 1 THEN BEGIN
              IF EntryNoBegin[i - 1] < TempVATEntry."Entry No." THEN
                TempVATEntry.SETRANGE("Entry No.",EntryNoBegin[i - 1],TempVATEntry."Entry No.")
              ELSE
                TempVATEntry.SETRANGE("Entry No.",TempVATEntry."Entry No.",EntryNoBegin[i - 1]);
            END ELSE
              TempVATEntry.SETRANGE("Entry No.",TempVATEntry."Entry No.");
            TempVATEntry.FINDSET;
            REPEAT
              VATEntrySaved := TempVATEntry;
              CASE DtldCVLedgEntryBuf."Entry Type" OF
                DtldCVLedgEntryBuf."Entry Type"::"Payment Discount (VAT Excl.)":
                  TempVATEntry.RENAME(TempVATEntry."Entry No." + 3000000);
                DtldCVLedgEntryBuf."Entry Type"::"Payment Tolerance (VAT Excl.)":
                  TempVATEntry.RENAME(TempVATEntry."Entry No." + 2000000);
                DtldCVLedgEntryBuf."Entry Type"::"Payment Discount Tolerance (VAT Excl.)":
                  TempVATEntry.RENAME(TempVATEntry."Entry No." + 1000000);
              END;
              TempVATEntry := VATEntrySaved;
              DeductedVATBase += TempVATEntry.Base;
            UNTIL TempVATEntry.NEXT = 0;
            FOR i := 1 TO 3 DO BEGIN
              VATBaseSum[i] := 0;
              EntryNoBegin[i] := 0;
            END;
            TempVATEntry.SETRANGE("Entry No.",0,999999);
          END ELSE BEGIN
            VATBaseSum[3] += TempVATEntry.Base;
            VATBaseSum[2] := VATBaseSum[1] + TempVATEntry.Base;
            VATBaseSum[1] := TempVATEntry.Base;
            IF EntryNoBegin[3] > 0 THEN
              EntryNoBegin[3] := TempVATEntry."Entry No.";
            EntryNoBegin[2] := EntryNoBegin[1];
            EntryNoBegin[1] := TempVATEntry."Entry No.";
          END;
        UNTIL TempVATEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE UpdateCustLedgEntry@80(DtldCustLedgEntry@1000 : Record 379);
    VAR
      CustLedgEntry@1001 : Record 21;
    BEGIN
      IF DtldCustLedgEntry."Entry Type" <> DtldCustLedgEntry."Entry Type"::Application THEN
        EXIT;

      CustLedgEntry.GET(DtldCustLedgEntry."Cust. Ledger Entry No.");
      CustLedgEntry."Remaining Pmt. Disc. Possible" := DtldCustLedgEntry."Remaining Pmt. Disc. Possible";
      CustLedgEntry."Max. Payment Tolerance" := DtldCustLedgEntry."Max. Payment Tolerance";
      CustLedgEntry."Accepted Payment Tolerance" := 0;
      IF NOT CustLedgEntry.Open THEN BEGIN
        CustLedgEntry.Open := TRUE;
        CustLedgEntry."Closed by Entry No." := 0;
        CustLedgEntry."Closed at Date" := 0D;
        CustLedgEntry."Closed by Amount" := 0;
        CustLedgEntry."Closed by Amount (LCY)" := 0;
        CustLedgEntry."Closed by Currency Code" := '';
        CustLedgEntry."Closed by Currency Amount" := 0;
        CustLedgEntry."Pmt. Disc. Given (LCY)" := 0;
        CustLedgEntry."Pmt. Tolerance (LCY)" := 0;
        CustLedgEntry."Calculate Interest" := FALSE;
      END;
      CustLedgEntry.MODIFY;
    END;

    LOCAL PROCEDURE UpdateVendLedgEntry@76(DtldVendLedgEntry@1000 : Record 380);
    VAR
      VendLedgEntry@1001 : Record 25;
    BEGIN
      IF DtldVendLedgEntry."Entry Type" <> DtldVendLedgEntry."Entry Type"::Application THEN
        EXIT;

      VendLedgEntry.GET(DtldVendLedgEntry."Vendor Ledger Entry No.");
      VendLedgEntry."Remaining Pmt. Disc. Possible" := DtldVendLedgEntry."Remaining Pmt. Disc. Possible";
      VendLedgEntry."Max. Payment Tolerance" := DtldVendLedgEntry."Max. Payment Tolerance";
      VendLedgEntry."Accepted Payment Tolerance" := 0;
      IF NOT VendLedgEntry.Open THEN BEGIN
        VendLedgEntry.Open := TRUE;
        VendLedgEntry."Closed by Entry No." := 0;
        VendLedgEntry."Closed at Date" := 0D;
        VendLedgEntry."Closed by Amount" := 0;
        VendLedgEntry."Closed by Amount (LCY)" := 0;
        VendLedgEntry."Closed by Currency Code" := '';
        VendLedgEntry."Closed by Currency Amount" := 0;
        VendLedgEntry."Pmt. Disc. Rcd.(LCY)" := 0;
        VendLedgEntry."Pmt. Tolerance (LCY)" := 0;
      END;
      VendLedgEntry.MODIFY;
    END;

    LOCAL PROCEDURE UpdateEmplLedgEntry@151(DtldEmplLedgEntry@1000 : Record 5223);
    VAR
      EmplLedgEntry@1001 : Record 5222;
    BEGIN
      IF DtldEmplLedgEntry."Entry Type" <> DtldEmplLedgEntry."Entry Type"::Application THEN
        EXIT;

      EmplLedgEntry.GET(DtldEmplLedgEntry."Employee Ledger Entry No.");
      IF NOT EmplLedgEntry.Open THEN BEGIN
        EmplLedgEntry.Open := TRUE;
        EmplLedgEntry."Closed by Entry No." := 0;
        EmplLedgEntry."Closed at Date" := 0D;
        EmplLedgEntry."Closed by Amount" := 0;
        EmplLedgEntry."Closed by Amount (LCY)" := 0;
      END;
      EmplLedgEntry.MODIFY;
    END;

    LOCAL PROCEDURE UpdateCalcInterest@28(VAR CVLedgEntryBuf@1000 : Record 382);
    VAR
      CustLedgEntry@1001 : Record 21;
      CVLedgEntryBuf2@1002 : Record 382;
    BEGIN
      WITH CVLedgEntryBuf DO BEGIN
        IF CustLedgEntry.GET("Closed by Entry No.") THEN BEGIN
          CVLedgEntryBuf2.TRANSFERFIELDS(CustLedgEntry);
          UpdateCalcInterest2(CVLedgEntryBuf,CVLedgEntryBuf2);
        END;
        CustLedgEntry.SETCURRENTKEY("Closed by Entry No.");
        CustLedgEntry.SETRANGE("Closed by Entry No.","Entry No.");
        IF CustLedgEntry.FINDSET THEN
          REPEAT
            CVLedgEntryBuf2.TRANSFERFIELDS(CustLedgEntry);
            UpdateCalcInterest2(CVLedgEntryBuf,CVLedgEntryBuf2);
          UNTIL CustLedgEntry.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE UpdateCalcInterest2@27(VAR CVLedgEntryBuf@1000 : Record 382;VAR CVLedgEntryBuf2@1001 : Record 382);
    BEGIN
      WITH CVLedgEntryBuf DO
        IF "Due Date" < CVLedgEntryBuf2."Document Date" THEN
          "Calculate Interest" := TRUE;
    END;

    LOCAL PROCEDURE GLCalcAddCurrency@35(Amount@1003 : Decimal;AddCurrAmount@1000 : Decimal;OldAddCurrAmount@1004 : Decimal;UseAddCurrAmount@1001 : Boolean;GenJnlLine@1002 : Record 81) : Decimal;
    BEGIN
      IF (AddCurrencyCode <> '') AND
         (GenJnlLine."Additional-Currency Posting" = GenJnlLine."Additional-Currency Posting"::None)
      THEN BEGIN
        IF (GenJnlLine."Source Currency Code" = AddCurrencyCode) AND UseAddCurrAmount THEN
          EXIT(AddCurrAmount);

        EXIT(ExchangeAmtLCYToFCY2(Amount));
      END;
      EXIT(OldAddCurrAmount);
    END;

    LOCAL PROCEDURE HandleAddCurrResidualGLEntry@38(GenJnlLine@1003 : Record 81;Amount@1000 : Decimal;AmountAddCurr@1001 : Decimal);
    VAR
      GLAcc@1002 : Record 15;
      GLEntry@1004 : Record 17;
    BEGIN
      IF AddCurrencyCode = '' THEN
        EXIT;

      TotalAddCurrAmount := TotalAddCurrAmount + AmountAddCurr;
      TotalAmount := TotalAmount + Amount;

      IF (GenJnlLine."Additional-Currency Posting" = GenJnlLine."Additional-Currency Posting"::None) AND
         (TotalAmount = 0) AND (TotalAddCurrAmount <> 0) AND
         CheckNonAddCurrCodeOccurred(GenJnlLine."Source Currency Code")
      THEN BEGIN
        GLEntry.INIT;
        GLEntry.CopyFromGenJnlLine(GenJnlLine);
        GLEntry."External Document No." := '';
        GLEntry.Description :=
          COPYSTR(
            STRSUBSTNO(
              ResidualRoundingErr,
              GLEntry.FIELDCAPTION("Additional-Currency Amount")),
            1,MAXSTRLEN(GLEntry.Description));
        GLEntry."Source Type" := 0;
        GLEntry."Source No." := '';
        GLEntry."Job No." := '';
        GLEntry.Quantity := 0;
        GLEntry."Entry No." := NextEntryNo;
        GLEntry."Transaction No." := NextTransactionNo;
        IF TotalAddCurrAmount < 0 THEN
          GLEntry."G/L Account No." := AddCurrency."Residual Losses Account"
        ELSE
          GLEntry."G/L Account No." := AddCurrency."Residual Gains Account";
        GLEntry.Amount := 0;
        GLEntry."System-Created Entry" := TRUE;
        GLEntry."Additional-Currency Amount" := -TotalAddCurrAmount;
        GLAcc.GET(GLEntry."G/L Account No.");
        GLAcc.TESTFIELD(Blocked,FALSE);
        GLAcc.TESTFIELD("Account Type",GLAcc."Account Type"::Posting);
        InsertGLEntry(GenJnlLine,GLEntry,FALSE);

        CheckGLAccDimError(GenJnlLine,GLEntry."G/L Account No.");

        TotalAddCurrAmount := 0;
      END;
    END;

    LOCAL PROCEDURE CalcLCYToAddCurr@42(AmountLCY@1000 : Decimal) : Decimal;
    BEGIN
      IF AddCurrencyCode = '' THEN
        EXIT;

      EXIT(ExchangeAmtLCYToFCY2(AmountLCY));
    END;

    LOCAL PROCEDURE GetCurrencyExchRate@39(GenJnlLine@1001 : Record 81);
    VAR
      NewCurrencyDate@1000 : Date;
    BEGIN
      IF AddCurrencyCode = '' THEN
        EXIT;

      AddCurrency.GET(AddCurrencyCode);
      AddCurrency.TESTFIELD("Amount Rounding Precision");
      AddCurrency.TESTFIELD("Residual Gains Account");
      AddCurrency.TESTFIELD("Residual Losses Account");

      NewCurrencyDate := GenJnlLine."Posting Date";
      IF GenJnlLine."Reversing Entry" THEN
        NewCurrencyDate := NewCurrencyDate - 1;
      IF (NewCurrencyDate <> CurrencyDate) OR
         UseCurrFactorOnly
      THEN BEGIN
        UseCurrFactorOnly := FALSE;
        CurrencyDate := NewCurrencyDate;
        CurrencyFactor :=
          CurrExchRate.ExchangeRate(CurrencyDate,AddCurrencyCode);
      END;
      IF (GenJnlLine."FA Add.-Currency Factor" <> 0) AND
         (GenJnlLine."FA Add.-Currency Factor" <> CurrencyFactor)
      THEN BEGIN
        UseCurrFactorOnly := TRUE;
        CurrencyDate := 0D;
        CurrencyFactor := GenJnlLine."FA Add.-Currency Factor";
      END;
    END;

    LOCAL PROCEDURE ExchangeAmtLCYToFCY2@40(Amount@1000 : Decimal) : Decimal;
    BEGIN
      IF UseCurrFactorOnly THEN
        EXIT(
          ROUND(
            CurrExchRate.ExchangeAmtLCYToFCYOnlyFactor(Amount,CurrencyFactor),
            AddCurrency."Amount Rounding Precision"));
      EXIT(
        ROUND(
          CurrExchRate.ExchangeAmtLCYToFCY(
            CurrencyDate,AddCurrencyCode,Amount,CurrencyFactor),
          AddCurrency."Amount Rounding Precision"));
    END;

    LOCAL PROCEDURE CheckNonAddCurrCodeOccurred@54(CurrencyCode@1000 : Code[10]) : Boolean;
    BEGIN
      NonAddCurrCodeOccured :=
        NonAddCurrCodeOccured OR (AddCurrencyCode <> CurrencyCode);
      EXIT(NonAddCurrCodeOccured);
    END;

    LOCAL PROCEDURE TotalVATAmountOnJnlLines@1130(GenJnlLine@1000 : Record 81) TotalVATAmount : Decimal;
    VAR
      GenJnlLine2@1001 : Record 81;
    BEGIN
      WITH GenJnlLine2 DO BEGIN
        SETRANGE("Source Code",GenJnlLine."Source Code");
        SETRANGE("Document No.",GenJnlLine."Document No.");
        SETRANGE("Posting Date",GenJnlLine."Posting Date");
        IF FINDSET THEN
          REPEAT
            TotalVATAmount += "VAT Amount (LCY)" - "Bal. VAT Amount (LCY)";
          UNTIL NEXT = 0;
      END;
      EXIT(TotalVATAmount);
    END;

    [External]
    PROCEDURE SetGLRegReverse@8(VAR ReverseGLReg@1000 : Record 45);
    BEGIN
      GLReg.Reversed := TRUE;
      ReverseGLReg := GLReg;
    END;

    LOCAL PROCEDURE InsertVATEntriesFromTemp@83(VAR DtldCVLedgEntryBuf@1000 : Record 383;GLEntry@1003 : Record 17);
    VAR
      Complete@1001 : Boolean;
      LinkedAmount@1002 : Decimal;
      FirstEntryNo@1006 : Integer;
      LastEntryNo@1004 : Integer;
    BEGIN
      TempVATEntry.RESET;
      TempVATEntry.SETRANGE("Gen. Bus. Posting Group",GLEntry."Gen. Bus. Posting Group");
      TempVATEntry.SETRANGE("Gen. Prod. Posting Group",GLEntry."Gen. Prod. Posting Group");
      TempVATEntry.SETRANGE("VAT Bus. Posting Group",GLEntry."VAT Bus. Posting Group");
      TempVATEntry.SETRANGE("VAT Prod. Posting Group",GLEntry."VAT Prod. Posting Group");
      CASE DtldCVLedgEntryBuf."Entry Type" OF
        DtldCVLedgEntryBuf."Entry Type"::"Payment Discount Tolerance (VAT Excl.)":
          BEGIN
            FirstEntryNo := 1000000;
            LastEntryNo := 1999999;
          END;
        DtldCVLedgEntryBuf."Entry Type"::"Payment Tolerance (VAT Excl.)":
          BEGIN
            FirstEntryNo := 2000000;
            LastEntryNo := 2999999;
          END;
        DtldCVLedgEntryBuf."Entry Type"::"Payment Discount (VAT Excl.)":
          BEGIN
            FirstEntryNo := 3000000;
            LastEntryNo := 3999999;
          END;
      END;
      TempVATEntry.SETRANGE("Entry No.",FirstEntryNo,LastEntryNo);
      IF TempVATEntry.FINDSET THEN
        REPEAT
          VATEntry := TempVATEntry;
          VATEntry."Entry No." := NextVATEntryNo;
          VATEntry.INSERT(TRUE);
          NextVATEntryNo := NextVATEntryNo + 1;
          IF VATEntry."Unrealized VAT Entry No." = 0 THEN
            GLEntryVATEntryLink.InsertLink(GLEntry."Entry No.",VATEntry."Entry No.");
          LinkedAmount += VATEntry.Amount + VATEntry.Base;
          Complete := LinkedAmount = -(DtldCVLedgEntryBuf."Amount (LCY)" + DtldCVLedgEntryBuf."VAT Amount (LCY)");
          LastEntryNo := TempVATEntry."Entry No.";
        UNTIL Complete OR (TempVATEntry.NEXT = 0);

      TempVATEntry.SETRANGE("Entry No.",FirstEntryNo,LastEntryNo);
      TempVATEntry.DELETEALL;
    END;

    LOCAL PROCEDURE ABSMin@84(Decimal1@1000 : Decimal;Decimal2@1001 : Decimal) : Decimal;
    BEGIN
      IF ABS(Decimal1) < ABS(Decimal2) THEN
        EXIT(Decimal1);
      EXIT(Decimal2);
    END;

    LOCAL PROCEDURE GetApplnRoundPrecision@92(NewCVLedgEntryBuf@1002 : Record 382;OldCVLedgEntryBuf@1003 : Record 382) : Decimal;
    VAR
      ApplnCurrency@1000 : Record 4;
      CurrencyCode@1005 : Code[10];
    BEGIN
      IF NewCVLedgEntryBuf."Currency Code" <> '' THEN
        CurrencyCode := NewCVLedgEntryBuf."Currency Code"
      ELSE
        CurrencyCode := OldCVLedgEntryBuf."Currency Code";
      IF CurrencyCode = '' THEN
        EXIT(0);
      ApplnCurrency.GET(CurrencyCode);
      IF ApplnCurrency."Appln. Rounding Precision" <> 0 THEN
        EXIT(ApplnCurrency."Appln. Rounding Precision");
      EXIT(GLSetup."Appln. Rounding Precision");
    END;

    LOCAL PROCEDURE GetGLSetup@19();
    BEGIN
      IF GLSetupRead THEN
        EXIT;

      GLSetup.GET;
      GLSetupRead := TRUE;

      AddCurrencyCode := GLSetup."Additional Reporting Currency";
    END;

    LOCAL PROCEDURE ReadGLSetup@17(VAR NewGLSetup@1000 : Record 98);
    BEGIN
      NewGLSetup := GLSetup;
    END;

    LOCAL PROCEDURE CheckSalesExtDocNo@115(GenJnlLine@1001 : Record 81);
    VAR
      SalesSetup@1000 : Record 311;
    BEGIN
      SalesSetup.GET;
      IF NOT SalesSetup."Ext. Doc. No. Mandatory" THEN
        EXIT;

      IF GenJnlLine."Document Type" IN
         [GenJnlLine."Document Type"::Invoice,
          GenJnlLine."Document Type"::"Credit Memo",
          GenJnlLine."Document Type"::Payment,
          GenJnlLine."Document Type"::Refund,
          GenJnlLine."Document Type"::" "]
      THEN
        GenJnlLine.TESTFIELD("External Document No.");
    END;

    LOCAL PROCEDURE CheckPurchExtDocNo@107(GenJnlLine@1003 : Record 81);
    VAR
      PurchSetup@1002 : Record 312;
      OldVendLedgEntry@1001 : Record 25;
    BEGIN
      PurchSetup.GET;
      IF NOT (PurchSetup."Ext. Doc. No. Mandatory" OR (GenJnlLine."External Document No." <> '')) THEN
        EXIT;

      GenJnlLine.TESTFIELD("External Document No.");
      OldVendLedgEntry.RESET;
      OldVendLedgEntry.SETRANGE("External Document No.",GenJnlLine."External Document No.");
      OldVendLedgEntry.SETRANGE("Document Type",GenJnlLine."Document Type");
      OldVendLedgEntry.SETRANGE("Vendor No.",GenJnlLine."Account No.");
      OldVendLedgEntry.SETRANGE(Reversed,FALSE);
      IF NOT OldVendLedgEntry.ISEMPTY THEN
        ERROR(
          PurchaseAlreadyExistsErr,
          GenJnlLine."Document Type",GenJnlLine."External Document No.");
    END;

    LOCAL PROCEDURE CheckDimValueForDisposal@93(GenJnlLine@1001 : Record 81;AccountNo@1002 : Code[20]);
    VAR
      DimMgt@1000 : Codeunit 408;
      TableID@1025 : ARRAY [10] OF Integer;
      AccNo@1026 : ARRAY [10] OF Code[20];
    BEGIN
      IF ((GenJnlLine.Amount = 0) OR (GenJnlLine."Amount (LCY)" = 0)) AND
         (GenJnlLine."FA Posting Type" = GenJnlLine."FA Posting Type"::Disposal)
      THEN BEGIN
        TableID[1] := DimMgt.TypeToTableID1(GenJnlLine."Account Type"::"G/L Account");
        AccNo[1] := AccountNo;
        IF NOT DimMgt.CheckDimValuePosting(TableID,AccNo,GenJnlLine."Dimension Set ID") THEN
          ERROR(DimMgt.GetDimValuePostingErr);
      END;
    END;

    [External]
    PROCEDURE SetOverDimErr@79();
    BEGIN
      OverrideDimErr := TRUE;
    END;

    LOCAL PROCEDURE CheckGLAccDimError@97(GenJnlLine@1005 : Record 81;GLAccNo@1004 : Code[20]);
    VAR
      DimMgt@1002 : Codeunit 408;
      TableID@1001 : ARRAY [10] OF Integer;
      AccNo@1000 : ARRAY [10] OF Code[20];
    BEGIN
      IF (GenJnlLine.Amount = 0) AND (GenJnlLine."Amount (LCY)" = 0) THEN
        EXIT;

      TableID[1] := DATABASE::"G/L Account";
      AccNo[1] := GLAccNo;
      IF DimMgt.CheckDimValuePosting(TableID,AccNo,GenJnlLine."Dimension Set ID") THEN
        EXIT;

      IF GenJnlLine."Line No." <> 0 THEN
        ERROR(
          DimensionUsedErr,
          GenJnlLine.TABLECAPTION,GenJnlLine."Journal Template Name",
          GenJnlLine."Journal Batch Name",GenJnlLine."Line No.",
          DimMgt.GetDimValuePostingErr);

      ERROR(DimMgt.GetDimValuePostingErr);
    END;

    LOCAL PROCEDURE CalculateCurrentBalance@95(AccountNo@1000 : Code[20];BalAccountNo@1001 : Code[20];InclVATAmount@1002 : Boolean;AmountLCY@1004 : Decimal;VATAmount@1005 : Decimal);
    BEGIN
      IF (AccountNo <> '') AND (BalAccountNo <> '') THEN
        EXIT;

      IF AccountNo = BalAccountNo THEN
        EXIT;

      IF NOT InclVATAmount THEN
        VATAmount := 0;

      IF BalAccountNo <> '' THEN
        CurrentBalance -= AmountLCY + VATAmount
      ELSE
        CurrentBalance += AmountLCY + VATAmount;
    END;

    LOCAL PROCEDURE GetCurrency@191(VAR Currency@1000 : Record 4;CurrencyCode@1001 : Code[10]);
    BEGIN
      IF Currency.Code <> CurrencyCode THEN BEGIN
        IF CurrencyCode = '' THEN
          CLEAR(Currency)
        ELSE
          Currency.GET(CurrencyCode);
      END;
    END;

    LOCAL PROCEDURE CollectAdjustment@181(VAR AdjAmount@1003 : ARRAY [4] OF Decimal;Amount@1004 : Decimal;AmountAddCurr@1005 : Decimal);
    VAR
      Offset@1001 : Integer;
    BEGIN
      Offset := GetAdjAmountOffset(Amount,AmountAddCurr);
      AdjAmount[Offset] += Amount;
      AdjAmount[Offset + 1] += AmountAddCurr;
    END;

    LOCAL PROCEDURE HandleDtldAdjustment@182(GenJnlLine@1008 : Record 81;VAR GLEntry@1002 : Record 17;AdjAmount@1010 : ARRAY [4] OF Decimal;TotalAmountLCY@1004 : Decimal;TotalAmountAddCurr@1005 : Decimal;GLAccNo@1007 : Code[20]);
    BEGIN
      IF NOT PostDtldAdjustment(
           GenJnlLine,GLEntry,AdjAmount,
           TotalAmountLCY,TotalAmountAddCurr,GLAccNo,
           GetAdjAmountOffset(TotalAmountLCY,TotalAmountAddCurr))
      THEN
        InitGLEntry(GenJnlLine,GLEntry,GLAccNo,TotalAmountLCY,TotalAmountAddCurr,TRUE,TRUE);
    END;

    LOCAL PROCEDURE PostDtldAdjustment@96(GenJnlLine@1006 : Record 81;VAR GLEntry@1005 : Record 17;AdjAmount@1004 : ARRAY [4] OF Decimal;TotalAmountLCY@1002 : Decimal;TotalAmountAddCurr@1001 : Decimal;GLAcc@1000 : Code[20];ArrayIndex@1007 : Integer) : Boolean;
    BEGIN
      IF (GenJnlLine."Bal. Account No." <> '') AND
         ((AdjAmount[ArrayIndex] <> 0) OR (AdjAmount[ArrayIndex + 1] <> 0)) AND
         ((TotalAmountLCY + AdjAmount[ArrayIndex] <> 0) OR (TotalAmountAddCurr + AdjAmount[ArrayIndex + 1] <> 0))
      THEN BEGIN
        CreateGLEntryBalAcc(
          GenJnlLine,GLAcc,-AdjAmount[ArrayIndex],-AdjAmount[ArrayIndex + 1],
          GenJnlLine."Bal. Account Type",GenJnlLine."Bal. Account No.");
        InitGLEntry(GenJnlLine,GLEntry,
          GLAcc,TotalAmountLCY + AdjAmount[ArrayIndex],
          TotalAmountAddCurr + AdjAmount[ArrayIndex + 1],TRUE,TRUE);
        AdjAmount[ArrayIndex] := 0;
        AdjAmount[ArrayIndex + 1] := 0;
        EXIT(TRUE);
      END;

      EXIT(FALSE);
    END;

    LOCAL PROCEDURE GetAdjAmountOffset@121(Amount@1000 : Decimal;AmountACY@1001 : Decimal) : Integer;
    BEGIN
      IF (Amount > 0) OR (Amount = 0) AND (AmountACY > 0) THEN
        EXIT(1);
      EXIT(3);
    END;

    [External]
    PROCEDURE GetNextEntryNo@53() : Integer;
    BEGIN
      EXIT(NextEntryNo);
    END;

    [External]
    PROCEDURE GetNextTransactionNo@67() : Integer;
    BEGIN
      EXIT(NextTransactionNo);
    END;

    [External]
    PROCEDURE GetNextVATEntryNo@68() : Integer;
    BEGIN
      EXIT(NextVATEntryNo);
    END;

    [External]
    PROCEDURE IncrNextVATEntryNo@70();
    BEGIN
      NextVATEntryNo := NextVATEntryNo + 1;
    END;

    LOCAL PROCEDURE IsNotPayment@77(DocumentType@1000 : ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund') : Boolean;
    BEGIN
      EXIT(DocumentType IN [DocumentType::Invoice,
                            DocumentType::"Credit Memo",
                            DocumentType::"Finance Charge Memo",
                            DocumentType::Reminder]);
    END;

    LOCAL PROCEDURE IsTempGLEntryBufEmpty@44() : Boolean;
    BEGIN
      EXIT(TempGLEntryBuf.ISEMPTY);
    END;

    LOCAL PROCEDURE IsVATAdjustment@20(EntryType@1000 : Option) : Boolean;
    VAR
      DtldCVLedgEntryBuf@1001 : Record 383;
    BEGIN
      EXIT(EntryType IN [DtldCVLedgEntryBuf."Entry Type"::"Payment Discount (VAT Adjustment)",
                         DtldCVLedgEntryBuf."Entry Type"::"Payment Tolerance (VAT Adjustment)",
                         DtldCVLedgEntryBuf."Entry Type"::"Payment Discount Tolerance (VAT Adjustment)"]);
    END;

    LOCAL PROCEDURE IsVATExcluded@7(EntryType@1000 : Option) : Boolean;
    VAR
      DtldCVLedgEntryBuf@1001 : Record 383;
    BEGIN
      EXIT(EntryType IN [DtldCVLedgEntryBuf."Entry Type"::"Payment Discount (VAT Excl.)",
                         DtldCVLedgEntryBuf."Entry Type"::"Payment Tolerance (VAT Excl.)",
                         DtldCVLedgEntryBuf."Entry Type"::"Payment Discount Tolerance (VAT Excl.)"]);
    END;

    LOCAL PROCEDURE UpdateGLEntryNo@120(VAR GLEntryNo@1002 : Integer;VAR SavedEntryNo@1000 : Integer);
    BEGIN
      IF SavedEntryNo <> 0 THEN BEGIN
        GLEntryNo := SavedEntryNo;
        NextEntryNo := NextEntryNo - 1;
        SavedEntryNo := 0;
      END;
    END;

    LOCAL PROCEDURE UpdateTotalAmounts@132(VAR TempInvPostBuf@1003 : TEMPORARY Record 49;DimSetID@1000 : Integer;AmountToCollect@1001 : Decimal;AmountACYToCollect@1002 : Decimal);
    BEGIN
      WITH TempInvPostBuf DO BEGIN
        SETRANGE("Dimension Set ID",DimSetID);
        IF FINDFIRST THEN BEGIN
          Amount += AmountToCollect;
          "Amount (ACY)" += AmountACYToCollect;
          MODIFY;
        END ELSE BEGIN
          INIT;
          "Dimension Set ID" := DimSetID;
          Amount := AmountToCollect;
          "Amount (ACY)" := AmountACYToCollect;
          INSERT;
        END;
      END;
    END;

    LOCAL PROCEDURE CreateGLEntriesForTotalAmountsUnapply@135(GenJnlLine@1000 : Record 81;VAR TempInvPostBuf@1002 : TEMPORARY Record 49;Account@1001 : Code[20]);
    VAR
      DimMgt@1003 : Codeunit 408;
    BEGIN
      WITH TempInvPostBuf DO BEGIN
        SETRANGE("Dimension Set ID");
        IF FINDSET THEN
          REPEAT
            IF (Amount <> 0) OR
               ("Amount (ACY)" <> 0) AND (GLSetup."Additional Reporting Currency" <> '')
            THEN BEGIN
              DimMgt.UpdateGenJnlLineDim(GenJnlLine,"Dimension Set ID");
              CreateGLEntry(GenJnlLine,Account,Amount,"Amount (ACY)",TRUE);
            END;
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE CreateGLEntriesForTotalAmounts@36(GenJnlLine@1004 : Record 81;VAR InvPostBuf@1001 : Record 49;AdjAmountBuf@1006 : ARRAY [4] OF Decimal;SavedEntryNo@1009 : Integer;GLAccNo@1007 : Code[20];LedgEntryInserted@1003 : Boolean);
    VAR
      DimMgt@1002 : Codeunit 408;
      GLEntryInserted@1000 : Boolean;
    BEGIN
      GLEntryInserted := FALSE;

      WITH InvPostBuf DO BEGIN
        RESET;
        IF FINDSET THEN
          REPEAT
            IF (Amount <> 0) OR ("Amount (ACY)" <> 0) AND (AddCurrencyCode <> '') THEN BEGIN
              DimMgt.UpdateGenJnlLineDim(GenJnlLine,"Dimension Set ID");
              CreateGLEntryForTotalAmounts(GenJnlLine,Amount,"Amount (ACY)",AdjAmountBuf,SavedEntryNo,GLAccNo);
              GLEntryInserted := TRUE;
            END;
          UNTIL NEXT = 0;
      END;

      IF NOT GLEntryInserted AND LedgEntryInserted THEN
        CreateGLEntryForTotalAmounts(GenJnlLine,0,0,AdjAmountBuf,SavedEntryNo,GLAccNo);
    END;

    LOCAL PROCEDURE CreateGLEntryForTotalAmounts@122(GenJnlLine@1004 : Record 81;Amount@1000 : Decimal;AmountACY@1001 : Decimal;AdjAmountBuf@1006 : ARRAY [4] OF Decimal;VAR SavedEntryNo@1009 : Integer;GLAccNo@1007 : Code[20]);
    VAR
      GLEntry@1005 : Record 17;
    BEGIN
      HandleDtldAdjustment(GenJnlLine,GLEntry,AdjAmountBuf,Amount,AmountACY,GLAccNo);
      GLEntry."Bal. Account Type" := GenJnlLine."Bal. Account Type";
      GLEntry."Bal. Account No." := GenJnlLine."Bal. Account No.";
      UpdateGLEntryNo(GLEntry."Entry No.",SavedEntryNo);
      InsertGLEntry(GenJnlLine,GLEntry,TRUE);
    END;

    LOCAL PROCEDURE SetAddCurrForUnapplication@136(VAR DtldCVLedgEntryBuf@1000 : Record 383);
    BEGIN
      WITH DtldCVLedgEntryBuf DO
        IF NOT ("Entry Type" IN ["Entry Type"::Application,"Entry Type"::"Unrealized Loss",
                                 "Entry Type"::"Unrealized Gain","Entry Type"::"Realized Loss",
                                 "Entry Type"::"Realized Gain","Entry Type"::"Correction of Remaining Amount"])
        THEN
          IF ("Entry Type" = "Entry Type"::"Appln. Rounding") OR
             ((AddCurrencyCode <> '') AND (AddCurrencyCode = "Currency Code"))
          THEN
            "Additional-Currency Amount" := Amount
          ELSE
            "Additional-Currency Amount" := CalcAddCurrForUnapplication("Posting Date","Amount (LCY)");
    END;

    LOCAL PROCEDURE PostDeferral@125(VAR GenJournalLine@1000 : Record 81;AccountNumber@1006 : Code[20]);
    VAR
      DeferralTemplate@1001 : Record 1700;
      DeferralHeader@1002 : Record 1701;
      DeferralLine@1003 : Record 1702;
      GLEntry@1004 : Record 17;
      CurrExchRate@1012 : Record 330;
      DeferralUtilities@1005 : Codeunit 1720;
      PerPostDate@1007 : Date;
      PeriodicCount@1008 : Integer;
      AmtToDefer@1010 : Decimal;
      AmtToDeferACY@1009 : Decimal;
      EmptyDeferralLine@1011 : Boolean;
    BEGIN
      WITH GenJournalLine DO BEGIN
        IF "Source Type" IN ["Source Type"::Vendor,"Source Type"::Customer] THEN
          // Purchasing and Sales, respectively
          // We can create these types directly from the GL window, need to make sure we don't already have a deferral schedule
          // created for this GL Trx before handing it off to sales/purchasing subsystem
          IF "Source Code" <> GLSourceCode THEN BEGIN
            PostDeferralPostBuffer(GenJournalLine);
            EXIT;
          END;

        IF DeferralHeader.GET(DeferralDocType::"G/L","Journal Template Name","Journal Batch Name",0,'',"Line No.") THEN BEGIN
          EmptyDeferralLine := FALSE;
          // Get the range of detail records for this schedule
          DeferralLine.SETRANGE("Deferral Doc. Type",DeferralDocType::"G/L");
          DeferralLine.SETRANGE("Gen. Jnl. Template Name","Journal Template Name");
          DeferralLine.SETRANGE("Gen. Jnl. Batch Name","Journal Batch Name");
          DeferralLine.SETRANGE("Document Type",0);
          DeferralLine.SETRANGE("Document No.",'');
          DeferralLine.SETRANGE("Line No.","Line No.");
          IF DeferralLine.FINDSET THEN
            REPEAT
              IF DeferralLine.Amount = 0.0 THEN
                EmptyDeferralLine := TRUE;
            UNTIL (DeferralLine.NEXT = 0) OR EmptyDeferralLine;
          IF EmptyDeferralLine THEN
            ERROR(ZeroDeferralAmtErr,"Line No.","Deferral Code");
          DeferralHeader."Amount to Defer (LCY)" :=
            ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Posting Date","Currency Code",
                DeferralHeader."Amount to Defer","Currency Factor"));
          DeferralHeader.MODIFY;
        END;

        DeferralUtilities.RoundDeferralAmount(
          DeferralHeader,
          "Currency Code","Currency Factor","Posting Date",AmtToDefer,AmtToDeferACY);

        DeferralTemplate.GET("Deferral Code");
        DeferralTemplate.TESTFIELD("Deferral Account");
        DeferralTemplate.TESTFIELD("Deferral %");

        // Get the Deferral Header table so we know the amount to defer...
        // Assume straight GL posting
        IF DeferralHeader.GET(DeferralDocType::"G/L","Journal Template Name","Journal Batch Name",0,'',"Line No.") THEN BEGIN
          // Get the range of detail records for this schedule
          DeferralLine.SETRANGE("Deferral Doc. Type",DeferralDocType::"G/L");
          DeferralLine.SETRANGE("Gen. Jnl. Template Name","Journal Template Name");
          DeferralLine.SETRANGE("Gen. Jnl. Batch Name","Journal Batch Name");
          DeferralLine.SETRANGE("Document Type",0);
          DeferralLine.SETRANGE("Document No.",'');
          DeferralLine.SETRANGE("Line No.","Line No.");
        END ELSE
          ERROR(NoDeferralScheduleErr,"Line No.","Deferral Code");

        InitGLEntry(GenJournalLine,GLEntry,
          AccountNumber,
          -DeferralHeader."Amount to Defer (LCY)",
          -DeferralHeader."Amount to Defer",TRUE,TRUE);
        GLEntry.Description := Description;
        InsertGLEntry(GenJournalLine,GLEntry,TRUE);

        InitGLEntry(GenJournalLine,GLEntry,
          DeferralTemplate."Deferral Account",
          DeferralHeader."Amount to Defer (LCY)",
          DeferralHeader."Amount to Defer",TRUE,TRUE);
        GLEntry.Description := Description;
        InsertGLEntry(GenJournalLine,GLEntry,TRUE);

        // Here we want to get the Deferral Details table range and loop through them...
        IF DeferralLine.FINDSET THEN BEGIN
          PeriodicCount := 1;
          REPEAT
            PerPostDate := DeferralLine."Posting Date";
            IF GenJnlCheckLine.DateNotAllowed(PerPostDate) THEN
              ERROR(InvalidPostingDateErr,PerPostDate);

            InitGLEntry(GenJournalLine,GLEntry,AccountNumber,DeferralLine."Amount (LCY)",
              DeferralLine.Amount,
              TRUE,TRUE);
            GLEntry."Posting Date" := PerPostDate;
            GLEntry.Description := DeferralLine.Description;
            InsertGLEntry(GenJournalLine,GLEntry,TRUE);

            InitGLEntry(GenJournalLine,GLEntry,
              DeferralTemplate."Deferral Account",-DeferralLine."Amount (LCY)",
              -DeferralLine.Amount,
              TRUE,TRUE);
            GLEntry."Posting Date" := PerPostDate;
            GLEntry.Description := DeferralLine.Description;
            InsertGLEntry(GenJournalLine,GLEntry,TRUE);
            PeriodicCount := PeriodicCount + 1;
          UNTIL DeferralLine.NEXT = 0;
        END ELSE
          ERROR(NoDeferralScheduleErr,"Line No.","Deferral Code");
      END;
    END;

    LOCAL PROCEDURE PostDeferralPostBuffer@127(GenJournalLine@1005 : Record 81);
    VAR
      DeferralPostBuffer@1004 : Record 1703;
      GLEntry@1003 : Record 17;
      PostDate@1000 : Date;
    BEGIN
      WITH GenJournalLine DO BEGIN
        IF "Source Type" = "Source Type"::Customer THEN
          DeferralDocType := DeferralDocType::Sales
        ELSE
          DeferralDocType := DeferralDocType::Purchase;

        DeferralPostBuffer.SETRANGE("Deferral Doc. Type",DeferralDocType);
        DeferralPostBuffer.SETRANGE("Document No.","Document No.");
        DeferralPostBuffer.SETRANGE("Deferral Line No.","Deferral Line No.");

        IF DeferralPostBuffer.FINDSET THEN BEGIN
          REPEAT
            PostDate := DeferralPostBuffer."Posting Date";
            IF GenJnlCheckLine.DateNotAllowed(PostDate) THEN
              ERROR(InvalidPostingDateErr,PostDate);

            // When no sales/purch amount is entered, the offset was already posted
            IF (DeferralPostBuffer."Sales/Purch Amount" <> 0) OR (DeferralPostBuffer."Sales/Purch Amount (LCY)" <> 0) THEN BEGIN
              InitGLEntry(GenJournalLine,GLEntry,DeferralPostBuffer."G/L Account",
                DeferralPostBuffer."Sales/Purch Amount (LCY)",
                DeferralPostBuffer."Sales/Purch Amount",
                TRUE,TRUE);
              GLEntry."Posting Date" := PostDate;
              GLEntry.Description := DeferralPostBuffer.Description;
              GLEntry.CopyFromDeferralPostBuffer(DeferralPostBuffer);
              InsertGLEntry(GenJournalLine,GLEntry,TRUE);
            END;

            InitGLEntry(GenJournalLine,GLEntry,
              DeferralPostBuffer."Deferral Account",
              -DeferralPostBuffer."Amount (LCY)",
              -DeferralPostBuffer.Amount,
              TRUE,TRUE);
            GLEntry."Posting Date" := PostDate;
            GLEntry.Description := DeferralPostBuffer.Description;
            InsertGLEntry(GenJournalLine,GLEntry,TRUE);
          UNTIL DeferralPostBuffer.NEXT = 0;
          DeferralPostBuffer.DELETEALL;
        END;
      END;
    END;

    [External]
    PROCEDURE RemoveDeferralSchedule@128(GenJournalLine@1002 : Record 81);
    VAR
      DeferralUtilities@1000 : Codeunit 1720;
      DeferralDocType@1001 : 'Purchase,Sales,G/L';
    BEGIN
      // Removing deferral schedule after all deferrals for this line have been posted successfully
      WITH GenJournalLine DO
        DeferralUtilities.DeferralCodeOnDelete(
          DeferralDocType::"G/L",
          "Journal Template Name",
          "Journal Batch Name",0,'',"Line No.");
    END;

    LOCAL PROCEDURE GetGLSourceCode@130();
    VAR
      SourceCodeSetup@1000 : Record 242;
    BEGIN
      SourceCodeSetup.GET;
      GLSourceCode := SourceCodeSetup."General Journal";
    END;

    LOCAL PROCEDURE DeferralPosting@131(DeferralCode@1000 : Code[10];SourceCode@1001 : Code[10];AccountNo@1002 : Code[20];VAR GenJournalLine@1005 : Record 81;Balancing@1006 : Boolean);
    BEGIN
      IF DeferralCode <> '' THEN
        // Sales and purchasing could have negative amounts, so check for them first...
        IF (SourceCode <> GLSourceCode) AND
           (GenJournalLine."Account Type" IN [GenJournalLine."Account Type"::Customer,GenJournalLine."Account Type"::Vendor])
        THEN
          PostDeferralPostBuffer(GenJournalLine)
        ELSE
          // Pure GL trx, only post deferrals if it is not a balancing entry
          IF NOT Balancing THEN
            PostDeferral(GenJournalLine,AccountNo);
    END;

    LOCAL PROCEDURE GetPostingAccountNo@225(VATPostingSetup@1002 : Record 325;VATEntry@1001 : Record 254;UnrealizedVAT@1000 : Boolean) : Code[20];
    VAR
      TaxJurisdiction@1003 : Record 320;
    BEGIN
      IF VATPostingSetup."VAT Calculation Type" = VATPostingSetup."VAT Calculation Type"::"Sales Tax" THEN BEGIN
        VATEntry.TESTFIELD("Tax Jurisdiction Code");
        TaxJurisdiction.GET(VATEntry."Tax Jurisdiction Code");
        CASE VATEntry.Type OF
          VATEntry.Type::Sale:
            EXIT(TaxJurisdiction.GetSalesAccount(UnrealizedVAT));
          VATEntry.Type::Purchase:
            EXIT(TaxJurisdiction.GetPurchAccount(UnrealizedVAT));
        END;
      END;

      CASE VATEntry.Type OF
        VATEntry.Type::Sale:
          EXIT(VATPostingSetup.GetSalesAccount(UnrealizedVAT));
        VATEntry.Type::Purchase:
          EXIT(VATPostingSetup.GetPurchAccount(UnrealizedVAT));
      END;
    END;

    LOCAL PROCEDURE IsDebitAmount@137(DtldCVLedgEntryBuf@1000 : Record 383;Unapply@1001 : Boolean) : Boolean;
    VAR
      VATPostingSetup@1002 : Record 325;
      VATAmountCondition@1003 : Boolean;
      EntryAmount@1004 : Decimal;
    BEGIN
      WITH DtldCVLedgEntryBuf DO BEGIN
        VATAmountCondition :=
          "Entry Type" IN ["Entry Type"::"Payment Discount (VAT Excl.)","Entry Type"::"Payment Tolerance (VAT Excl.)",
                           "Entry Type"::"Payment Discount Tolerance (VAT Excl.)"];
        IF VATAmountCondition THEN BEGIN
          VATPostingSetup.GET("VAT Bus. Posting Group","VAT Prod. Posting Group");
          VATAmountCondition := VATPostingSetup."VAT Calculation Type" = VATPostingSetup."VAT Calculation Type"::"Full VAT";
        END;
        IF VATAmountCondition THEN
          EntryAmount := "VAT Amount (LCY)"
        ELSE
          EntryAmount := "Amount (LCY)";
        IF Unapply THEN
          EXIT(EntryAmount > 0);
        EXIT(EntryAmount <= 0);
      END;
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeCode@159(VAR GenJnlLine@1000 : Record 81;CheckLine@1001 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeCheckPurchExtDocNo@153(GenJournalLine@1000 : Record 81;VendorLedgerEntry@1001 : Record 25;CVLedgerEntryBuffer@1003 : Record 382;VAR Handled@1002 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeStartPosting@149(VAR GenJournalLine@1000 : Record 81);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeContinuePosting@150(VAR GenJournalLine@1000 : Record 81);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnBeforePostGenJnlLine@133(VAR GenJournalLine@1000 : Record 81);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterInitGLRegister@139(VAR GLRegister@1000 : Record 45;VAR GenJournalLine@1001 : Record 81);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterInsertGlobalGLEntry@142(VAR GLEntry@1000 : Record 17);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterRunWithCheck@160(VAR GenJnlLine@1000 : Record 81);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterRunWithoutCheck@158(VAR GenJnlLine@1000 : Record 81);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnBeforeInsertGLEntryBuffer@146(VAR TempGLEntryBuf@1000 : TEMPORARY Record 17;VAR GenJournalLine@1001 : Record 81);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterGLFinishPosting@144(GLEntry@1000 : Record 17;VAR GenJnlLine@1003 : Record 81;IsTransactionConsistent@1001 : Boolean;FirstTransactionNo@1002 : Integer);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnNextTransactionNoNeeded@154(GenJnlLine@1000 : Record 81;LastDocType@1003 : ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder';LastDocNo@1002 : Code[20];LastDate@1001 : Date;CurrentBalance@1004 : Decimal;CurrentBalanceACY@1005 : Decimal;VAR NewTransaction@1006 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterPostGLAcc@161(GenJnlLine@1000 : Record 81);
    BEGIN
    END;

    BEGIN
    END.
  }
}

