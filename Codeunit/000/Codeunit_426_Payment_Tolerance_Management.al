OBJECT Codeunit 426 Payment Tolerance Management
{
  OBJECT-PROPERTIES
  {
    Date=28-06-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23019;
  }
  PROPERTIES
  {
    Permissions=TableData 4=r,
                TableData 21=rim,
                TableData 25=rim,
                TableData 81=rim,
                TableData 98=r;
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      CurrExchRate@1000 : Record 330;
      AccTypeOrBalAccTypeIsIncorrectErr@1002 : TextConst '@@@="%1 = Customer or Vendor";DAN=V�rdien i feltet Kontotype eller feltet Modkontotype er forkert.\\ V�rdien skal v�re %1.;ENU=The value in either the Account Type field or the Bal. Account Type field is wrong.\\ The value must be %1.';

    [External]
    PROCEDURE PmtTolCust@10(VAR CustLedgEntry@1000 : Record 21) : Boolean;
    VAR
      GLSetup@1005 : Record 98;
      Customer@1002 : Record 18;
      AppliedAmount@1003 : Decimal;
      OriginalAppliedAmount@1001 : Decimal;
      ApplyingAmount@1004 : Decimal;
      AmounttoApply@1011 : Decimal;
      PmtDiscAmount@1012 : Decimal;
      MaxPmtTolAmount@1006 : Decimal;
      CustEntryApplId@1008 : Code[50];
      ApplnRoundingPrecision@1010 : Decimal;
    BEGIN
      MaxPmtTolAmount := 0;
      PmtDiscAmount := 0;
      ApplyingAmount := 0;
      AmounttoApply := 0;
      AppliedAmount := 0;

      IF Customer.GET(CustLedgEntry."Customer No.") THEN BEGIN
        IF Customer."Block Payment Tolerance" THEN
          EXIT(TRUE);
      END ELSE
        EXIT(FALSE);

      GLSetup.GET;

      CustEntryApplId := USERID;
      IF CustEntryApplId = '' THEN
        CustEntryApplId := '***';

      DelCustPmtTolAcc(CustLedgEntry,CustEntryApplId);
      CustLedgEntry.CALCFIELDS("Remaining Amount");
      CalcCustApplnAmount(
        CustLedgEntry,GLSetup,AppliedAmount,ApplyingAmount,AmounttoApply,PmtDiscAmount,
        MaxPmtTolAmount,CustEntryApplId,ApplnRoundingPrecision);

      OriginalAppliedAmount := AppliedAmount;

      IF GLSetup."Pmt. Disc. Tolerance Warning" THEN
        IF NOT ManagePaymentDiscToleranceWarningCustomer(CustLedgEntry,CustEntryApplId,AppliedAmount,AmounttoApply,'') THEN
          EXIT(FALSE);

      IF ABS(AmounttoApply) >= ABS(AppliedAmount - PmtDiscAmount - MaxPmtTolAmount) THEN BEGIN
        AppliedAmount := AppliedAmount - PmtDiscAmount;
        IF (ABS(AppliedAmount) > ABS(AmounttoApply)) AND (AppliedAmount * PmtDiscAmount >= 0) THEN
          AppliedAmount := AmounttoApply;

        IF ((ABS(AppliedAmount + ApplyingAmount) - ApplnRoundingPrecision) <= ABS(MaxPmtTolAmount)) AND
           (MaxPmtTolAmount <> 0) AND ((ABS(AppliedAmount + ApplyingAmount) - ApplnRoundingPrecision) <> 0)
           AND (ABS(AppliedAmount + ApplyingAmount) > ApplnRoundingPrecision)
        THEN BEGIN
          IF GLSetup."Payment Tolerance Warning" THEN BEGIN
            IF CallPmtTolWarning(
                 CustLedgEntry."Posting Date",CustLedgEntry."Customer No.",CustLedgEntry."Document No.",
                 CustLedgEntry."Currency Code",ApplyingAmount,OriginalAppliedAmount)
            THEN BEGIN
              IF ApplyingAmount <> 0 THEN
                PutCustPmtTolAmount(CustLedgEntry,ApplyingAmount,AppliedAmount,CustEntryApplId)
              ELSE
                DelCustPmtTolAcc2(CustLedgEntry,CustEntryApplId);
            END ELSE
              EXIT(FALSE);
          END ELSE
            PutCustPmtTolAmount(CustLedgEntry,ApplyingAmount,AppliedAmount,CustEntryApplId);
        END;
      END;
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE PmtTolVend@11(VAR VendLedgEntry@1000 : Record 25) : Boolean;
    VAR
      GLSetup@1006 : Record 98;
      Vendor@1001 : Record 23;
      AppliedAmount@1005 : Decimal;
      OriginalAppliedAmount@1002 : Decimal;
      ApplyingAmount@1004 : Decimal;
      AmounttoApply@1011 : Decimal;
      PmtDiscAmount@1012 : Decimal;
      MaxPmtTolAmount@1003 : Decimal;
      VendEntryApplID@1007 : Code[50];
      ApplnRoundingPrecision@1010 : Decimal;
    BEGIN
      MaxPmtTolAmount := 0;
      PmtDiscAmount := 0;
      ApplyingAmount := 0;
      AmounttoApply := 0;
      AppliedAmount := 0;
      IF Vendor.GET(VendLedgEntry."Vendor No.") THEN BEGIN
        IF Vendor."Block Payment Tolerance" THEN
          EXIT(TRUE);
      END ELSE
        EXIT(FALSE);

      GLSetup.GET;
      VendEntryApplID := USERID;
      IF VendEntryApplID = '' THEN
        VendEntryApplID := '***';

      DelVendPmtTolAcc(VendLedgEntry,VendEntryApplID);
      VendLedgEntry.CALCFIELDS("Remaining Amount");
      CalcVendApplnAmount(
        VendLedgEntry,GLSetup,AppliedAmount,ApplyingAmount,AmounttoApply,PmtDiscAmount,
        MaxPmtTolAmount,VendEntryApplID,ApplnRoundingPrecision);

      OriginalAppliedAmount := AppliedAmount;

      IF GLSetup."Pmt. Disc. Tolerance Warning" THEN
        IF NOT ManagePaymentDiscToleranceWarningVendor(VendLedgEntry,VendEntryApplID,AppliedAmount,AmounttoApply,'') THEN
          EXIT(FALSE);

      IF ABS(AmounttoApply) >= ABS(AppliedAmount - PmtDiscAmount - MaxPmtTolAmount) THEN BEGIN
        AppliedAmount := AppliedAmount - PmtDiscAmount;
        IF (ABS(AppliedAmount) > ABS(AmounttoApply)) AND (AppliedAmount * PmtDiscAmount >= 0) THEN
          AppliedAmount := AmounttoApply;

        IF ((ABS(AppliedAmount + ApplyingAmount) - ApplnRoundingPrecision) <= ABS(MaxPmtTolAmount)) AND
           (MaxPmtTolAmount <> 0) AND ((ABS(AppliedAmount + ApplyingAmount) - ApplnRoundingPrecision) <> 0) AND
           (ABS(AppliedAmount + ApplyingAmount) > ApplnRoundingPrecision)
        THEN BEGIN
          IF GLSetup."Payment Tolerance Warning" THEN BEGIN
            IF CallPmtTolWarning(
                 VendLedgEntry."Posting Date",VendLedgEntry."Vendor No.",VendLedgEntry."Document No.",
                 VendLedgEntry."Currency Code",ApplyingAmount,OriginalAppliedAmount)
            THEN BEGIN
              IF ApplyingAmount <> 0 THEN
                PutVendPmtTolAmount(VendLedgEntry,ApplyingAmount,AppliedAmount,VendEntryApplID)
              ELSE
                DelVendPmtTolAcc2(VendLedgEntry,VendEntryApplID);
            END ELSE
              EXIT(FALSE);
          END ELSE
            PutVendPmtTolAmount(VendLedgEntry,ApplyingAmount,AppliedAmount,VendEntryApplID);
        END;
      END;
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE PmtTolGenJnl@16(VAR NewGenJnlLine@1000 : Record 81) : Boolean;
    VAR
      GenJnlLine@1016 : TEMPORARY Record 81;
    BEGIN
      GenJnlLine := NewGenJnlLine;

      IF GenJnlLine."Check Printed" THEN
        EXIT(TRUE);

      IF GenJnlLine."Financial Void" THEN
        EXIT(TRUE);

      IF (GenJnlLine."Applies-to Doc. No." = '') AND (GenJnlLine."Applies-to ID" = '') THEN
        EXIT(TRUE);

      CASE TRUE OF
        (GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer) OR
        (GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Customer):
          EXIT(SalesPmtTolGenJnl(GenJnlLine));
        (GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor) OR
        (GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Vendor):
          EXIT(PurchPmtTolGenJnl(GenJnlLine));
      END;
    END;

    LOCAL PROCEDURE SalesPmtTolGenJnl@45(VAR GenJnlLine@1000 : Record 81) : Boolean;
    VAR
      NewCustLedgEntry@1007 : Record 21;
      GenJnlPostPreview@1005 : Codeunit 19;
      GenJnlLineApplID@1010 : Code[50];
    BEGIN
      IF IsCustBlockPmtToleranceInGenJnlLine(GenJnlLine) THEN
        EXIT(FALSE);

      GenJnlLineApplID := GetAppliesToID(GenJnlLine);

      NewCustLedgEntry."Posting Date" := GenJnlLine."Posting Date";
      NewCustLedgEntry."Document No." := GenJnlLine."Document No.";
      NewCustLedgEntry."Customer No." := GenJnlLine."Account No.";
      NewCustLedgEntry."Currency Code" := GenJnlLine."Currency Code";
      IF GenJnlLine."Applies-to Doc. No." <> '' THEN
        NewCustLedgEntry."Applies-to Doc. No." := GenJnlLine."Applies-to Doc. No.";
      IF NOT GenJnlPostPreview.IsActive THEN
        DelCustPmtTolAcc(NewCustLedgEntry,GenJnlLineApplID);
      NewCustLedgEntry.Amount := GenJnlLine.Amount;
      NewCustLedgEntry."Remaining Amount" := GenJnlLine.Amount;
      NewCustLedgEntry."Document Type" := GenJnlLine."Document Type";
      EXIT(
        PmtTolCustLedgEntry(NewCustLedgEntry,GenJnlLine."Account No.",GenJnlLine."Posting Date",
          GenJnlLine."Document No.",GenJnlLineApplID,GenJnlLine."Applies-to Doc. No.",
          GenJnlLine."Currency Code"));
    END;

    LOCAL PROCEDURE PurchPmtTolGenJnl@51(VAR GenJnlLine@1000 : Record 81) : Boolean;
    VAR
      NewVendLedgEntry@1008 : Record 25;
      GenJnlLineApplID@1010 : Code[50];
    BEGIN
      IF IsVendBlockPmtToleranceInGenJnlLine(GenJnlLine) THEN
        EXIT(FALSE);

      GenJnlLineApplID := GetAppliesToID(GenJnlLine);

      NewVendLedgEntry."Posting Date" := GenJnlLine."Posting Date";
      NewVendLedgEntry."Document No." := GenJnlLine."Document No.";
      NewVendLedgEntry."Vendor No." := GenJnlLine."Account No.";
      NewVendLedgEntry."Currency Code" := GenJnlLine."Currency Code";
      IF GenJnlLine."Applies-to Doc. No." <> '' THEN
        NewVendLedgEntry."Applies-to Doc. No." := GenJnlLine."Applies-to Doc. No.";
      DelVendPmtTolAcc(NewVendLedgEntry,GenJnlLineApplID);
      NewVendLedgEntry.Amount := GenJnlLine.Amount;
      NewVendLedgEntry."Remaining Amount" := GenJnlLine.Amount;
      NewVendLedgEntry."Document Type" := GenJnlLine."Document Type";
      EXIT(
        PmtTolVendLedgEntry(
          NewVendLedgEntry,GenJnlLine."Account No.",GenJnlLine."Posting Date",
          GenJnlLine."Document No.",GenJnlLineApplID,GenJnlLine."Applies-to Doc. No.",
          GenJnlLine."Currency Code"));
    END;

    [External]
    PROCEDURE PmtTolPmtReconJnl@44(VAR NewBankAccReconciliationLine@1000 : Record 274) : Boolean;
    VAR
      BankAccReconciliationLine@1010 : Record 274;
    BEGIN
      BankAccReconciliationLine := NewBankAccReconciliationLine;

      CASE BankAccReconciliationLine."Account Type" OF
        BankAccReconciliationLine."Account Type"::Customer:
          EXIT(SalesPmtTolPmtReconJnl(BankAccReconciliationLine));
        BankAccReconciliationLine."Account Type"::Vendor:
          EXIT(PurchPmtTolPmtReconJnl(BankAccReconciliationLine));
      END;
    END;

    LOCAL PROCEDURE SalesPmtTolPmtReconJnl@55(VAR BankAccReconciliationLine@1000 : Record 274) : Boolean;
    VAR
      NewCustLedgEntry@1004 : Record 21;
    BEGIN
      BankAccReconciliationLine.TESTFIELD("Account Type",BankAccReconciliationLine."Account Type"::Customer);

      IF IsCustBlockPmtTolerance(BankAccReconciliationLine."Account No.") THEN
        EXIT(FALSE);

      NewCustLedgEntry."Posting Date" := BankAccReconciliationLine."Transaction Date";
      NewCustLedgEntry."Document No." := BankAccReconciliationLine."Document No.";
      NewCustLedgEntry."Customer No." := BankAccReconciliationLine."Account No.";
      DelCustPmtTolAcc(NewCustLedgEntry,BankAccReconciliationLine.GetAppliesToID);
      NewCustLedgEntry.Amount := -BankAccReconciliationLine."Statement Amount";
      NewCustLedgEntry."Remaining Amount" := -BankAccReconciliationLine."Statement Amount";
      NewCustLedgEntry."Document Type" := NewCustLedgEntry."Document Type"::Payment;

      EXIT(
        PmtTolCustLedgEntry(
          NewCustLedgEntry,BankAccReconciliationLine."Account No.",BankAccReconciliationLine."Transaction Date",
          BankAccReconciliationLine."Statement No.",BankAccReconciliationLine.GetAppliesToID,'',
          ''));
    END;

    LOCAL PROCEDURE PurchPmtTolPmtReconJnl@60(VAR BankAccReconciliationLine@1000 : Record 274) : Boolean;
    VAR
      NewVendLedgEntry@1003 : Record 25;
    BEGIN
      BankAccReconciliationLine.TESTFIELD("Account Type",BankAccReconciliationLine."Account Type"::Vendor);

      IF IsVendBlockPmtTolerance(BankAccReconciliationLine."Account No.") THEN
        EXIT(FALSE);

      NewVendLedgEntry."Posting Date" := BankAccReconciliationLine."Transaction Date";
      NewVendLedgEntry."Document No." := BankAccReconciliationLine."Document No.";
      NewVendLedgEntry."Vendor No." := BankAccReconciliationLine."Account No.";
      DelVendPmtTolAcc(NewVendLedgEntry,BankAccReconciliationLine.GetAppliesToID);
      NewVendLedgEntry.Amount := -BankAccReconciliationLine."Statement Amount";
      NewVendLedgEntry."Remaining Amount" := -BankAccReconciliationLine."Statement Amount";
      NewVendLedgEntry."Document Type" := NewVendLedgEntry."Document Type"::Payment;

      EXIT(
        PmtTolVendLedgEntry(
          NewVendLedgEntry,BankAccReconciliationLine."Account No.",BankAccReconciliationLine."Transaction Date",
          BankAccReconciliationLine."Statement No.",BankAccReconciliationLine.GetAppliesToID,'',
          ''));
    END;

    LOCAL PROCEDURE PmtTolCustLedgEntry@46(VAR NewCustLedgEntry@1008 : Record 21;AccountNo@1005 : Code[20];PostingDate@1004 : Date;DocNo@1003 : Code[20];AppliesToID@1002 : Code[50];AppliesToDocNo@1001 : Code[20];CurrencyCode@1000 : Code[10]) : Boolean;
    VAR
      GLSetup@1016 : Record 98;
      AppliedAmount@1014 : Decimal;
      OriginalAppliedAmount@1006 : Decimal;
      ApplyingAmount@1013 : Decimal;
      AmounttoApply@1012 : Decimal;
      PmtDiscAmount@1011 : Decimal;
      MaxPmtTolAmount@1010 : Decimal;
      ApplnRoundingPrecision@1009 : Decimal;
    BEGIN
      GLSetup.GET;
      CalcCustApplnAmount(
        NewCustLedgEntry,GLSetup,AppliedAmount,ApplyingAmount,AmounttoApply,PmtDiscAmount,
        MaxPmtTolAmount,AppliesToID,ApplnRoundingPrecision);

      OriginalAppliedAmount := AppliedAmount;

      IF GLSetup."Pmt. Disc. Tolerance Warning" THEN
        IF NOT ManagePaymentDiscToleranceWarningCustomer(NewCustLedgEntry,AppliesToID,AppliedAmount,AmounttoApply,AppliesToDocNo) THEN
          EXIT(FALSE);

      IF ABS(AmounttoApply) >= ABS(AppliedAmount - PmtDiscAmount - MaxPmtTolAmount) THEN BEGIN
        AppliedAmount := AppliedAmount - PmtDiscAmount;
        IF (ABS(AppliedAmount) > ABS(AmounttoApply)) AND (AppliedAmount * PmtDiscAmount >= 0) THEN
          AppliedAmount := AmounttoApply;

        IF ((ABS(AppliedAmount + ApplyingAmount) - ApplnRoundingPrecision) <= ABS(MaxPmtTolAmount)) AND
           (MaxPmtTolAmount <> 0) AND ((ABS(AppliedAmount + ApplyingAmount) - ApplnRoundingPrecision) <> 0) AND
           (ABS(AppliedAmount + ApplyingAmount) > ApplnRoundingPrecision)
        THEN
          IF GLSetup."Payment Tolerance Warning" THEN
            IF CallPmtTolWarning(
                 PostingDate,AccountNo,DocNo,
                 CurrencyCode,ApplyingAmount,OriginalAppliedAmount)
            THEN BEGIN
              IF ApplyingAmount <> 0 THEN
                PutCustPmtTolAmount(NewCustLedgEntry,ApplyingAmount,AppliedAmount,AppliesToID)
              ELSE
                DelCustPmtTolAcc(NewCustLedgEntry,AppliesToID);
            END ELSE BEGIN
              DelCustPmtTolAcc(NewCustLedgEntry,AppliesToID);
              EXIT(FALSE);
            END
          ELSE
            PutCustPmtTolAmount(NewCustLedgEntry,ApplyingAmount,AppliedAmount,AppliesToID);
      END;
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE PmtTolVendLedgEntry@49(VAR NewVendLedgEntry@1007 : Record 25;AccountNo@1005 : Code[20];PostingDate@1004 : Date;DocNo@1003 : Code[20];AppliesToID@1002 : Code[50];AppliesToDocNo@1001 : Code[20];CurrencyCode@1000 : Code[10]) : Boolean;
    VAR
      GLSetup@1016 : Record 98;
      AppliedAmount@1014 : Decimal;
      OriginalAppliedAmount@1006 : Decimal;
      ApplyingAmount@1013 : Decimal;
      AmounttoApply@1012 : Decimal;
      PmtDiscAmount@1011 : Decimal;
      MaxPmtTolAmount@1010 : Decimal;
      ApplnRoundingPrecision@1009 : Decimal;
    BEGIN
      GLSetup.GET;
      CalcVendApplnAmount(
        NewVendLedgEntry,GLSetup,AppliedAmount,ApplyingAmount,AmounttoApply,PmtDiscAmount,
        MaxPmtTolAmount,AppliesToID,ApplnRoundingPrecision);

      OriginalAppliedAmount := AppliedAmount;

      IF GLSetup."Pmt. Disc. Tolerance Warning" THEN
        IF NOT ManagePaymentDiscToleranceWarningVendor(NewVendLedgEntry,AppliesToID,AppliedAmount,AmounttoApply,AppliesToDocNo) THEN
          EXIT(FALSE);

      IF ABS(AmounttoApply) >= ABS(AppliedAmount - PmtDiscAmount - MaxPmtTolAmount) THEN BEGIN
        AppliedAmount := AppliedAmount - PmtDiscAmount;
        IF (ABS(AppliedAmount) > ABS(AmounttoApply)) AND (AppliedAmount * PmtDiscAmount >= 0) THEN
          AppliedAmount := AmounttoApply;

        IF ((ABS(AppliedAmount + ApplyingAmount) - ApplnRoundingPrecision) <= ABS(MaxPmtTolAmount)) AND
           (MaxPmtTolAmount <> 0) AND ((ABS(AppliedAmount + ApplyingAmount) - ApplnRoundingPrecision) <> 0) AND
           (ABS(AppliedAmount + ApplyingAmount) > ApplnRoundingPrecision)
        THEN
          IF GLSetup."Payment Tolerance Warning" THEN
            IF CallPmtTolWarning(
                 PostingDate,AccountNo,DocNo,CurrencyCode,ApplyingAmount,OriginalAppliedAmount)
            THEN BEGIN
              IF ApplyingAmount <> 0 THEN
                PutVendPmtTolAmount(NewVendLedgEntry,ApplyingAmount,AppliedAmount,AppliesToID)
              ELSE
                DelVendPmtTolAcc(NewVendLedgEntry,AppliesToID);
            END ELSE BEGIN
              DelVendPmtTolAcc(NewVendLedgEntry,AppliesToID);
              EXIT(FALSE);
            END
          ELSE
            PutVendPmtTolAmount(NewVendLedgEntry,ApplyingAmount,AppliedAmount,AppliesToID);
      END;
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE CalcCustApplnAmount@14(CustledgEntry@1000 : Record 21;GLSetup@1003 : Record 98;VAR AppliedAmount@1001 : Decimal;VAR ApplyingAmount@1002 : Decimal;VAR AmounttoApply@1019 : Decimal;VAR PmtDiscAmount@1022 : Decimal;VAR MaxPmtTolAmount@1005 : Decimal;CustEntryApplID@1021 : Code[50];VAR ApplnRoundingPrecision@1017 : Decimal);
    VAR
      CurrExchRate@1020 : Record 330;
      AppliedCustLedgEntry@1006 : Record 21;
      AppliedCustLedgEntryTemp@1011 : TEMPORARY Record 21;
      CustLedgEntry2@1013 : Record 21;
      ApplnCurrencyCode@1007 : Code[10];
      ApplnDate@1008 : Date;
      AmountRoundingPrecision@1012 : Decimal;
      TempAmount@1016 : Decimal;
      i@1014 : Integer;
      PositiveFilter@1015 : Boolean;
      SetPositiveFilter@1018 : Boolean;
      ApplnInMultiCurrency@1009 : Boolean;
      UseDisc@1023 : Boolean;
      RemainingPmtDiscPossible@1024 : Decimal;
      AvailableAmount@1025 : Decimal;
    BEGIN
      ApplnCurrencyCode := CustledgEntry."Currency Code";
      ApplnDate := CustledgEntry."Posting Date";
      ApplnRoundingPrecision := GLSetup."Appln. Rounding Precision";
      AmountRoundingPrecision := GLSetup."Amount Rounding Precision";

      IF CustEntryApplID <> '' THEN BEGIN
        AppliedCustLedgEntry.SETCURRENTKEY("Customer No.","Applies-to ID",Open,Positive);
        AppliedCustLedgEntry.SETRANGE("Customer No.",CustledgEntry."Customer No.");
        AppliedCustLedgEntry.SETRANGE("Applies-to ID",CustEntryApplID);
        AppliedCustLedgEntry.SETRANGE(Open,TRUE);
        CustLedgEntry2 := CustledgEntry;
        PositiveFilter := CustledgEntry."Remaining Amount" < 0;
        AppliedCustLedgEntry.SETRANGE(Positive,PositiveFilter);
        IF CustledgEntry."Entry No." <> 0 THEN
          AppliedCustLedgEntry.SETFILTER("Entry No.",'<>%1',CustledgEntry."Entry No.");

        // Find Application Rounding Precision
        GetCustApplicationRoundingPrecisionForAppliesToID(
          AppliedCustLedgEntry,ApplnRoundingPrecision,AmountRoundingPrecision,ApplnInMultiCurrency,ApplnCurrencyCode);

        IF AppliedCustLedgEntry.FIND('-') THEN BEGIN
          ApplyingAmount := CustledgEntry."Remaining Amount";
          TempAmount := CustledgEntry."Remaining Amount";
          AppliedCustLedgEntry.SETRANGE(Positive);
          AppliedCustLedgEntry.FIND('-');
          REPEAT
            UpdateCustAmountsForApplication(AppliedCustLedgEntry,CustledgEntry,AppliedCustLedgEntryTemp);
            CheckCustPaymentAmountsForAppliesToID(
              CustledgEntry,AppliedCustLedgEntry,AppliedCustLedgEntryTemp,MaxPmtTolAmount,AvailableAmount,TempAmount,
              ApplnRoundingPrecision);
          UNTIL AppliedCustLedgEntry.NEXT = 0;

          TempAmount := TempAmount + MaxPmtTolAmount;

          PositiveFilter := GetCustPositiveFilter(CustledgEntry."Document Type",TempAmount);
          SetPositiveFilter := TRUE;
          AppliedCustLedgEntry.SETRANGE(Positive,PositiveFilter);
        END ELSE
          AppliedCustLedgEntry.SETRANGE(Positive);

        IF CustledgEntry."Entry No." <> 0 THEN
          AppliedCustLedgEntry.SETRANGE("Entry No.");

        FOR i := 1 TO 2 DO BEGIN
          IF SetPositiveFilter THEN BEGIN
            IF i = 2 THEN
              AppliedCustLedgEntry.SETRANGE(Positive,NOT PositiveFilter);
          END ELSE
            i := 2;

          WITH AppliedCustLedgEntry DO BEGIN
            IF FIND('-') THEN
              REPEAT
                CALCFIELDS("Remaining Amount");
                AppliedCustLedgEntryTemp := AppliedCustLedgEntry;
                IF "Currency Code" <> ApplnCurrencyCode THEN BEGIN
                  "Remaining Amount" :=
                    CurrExchRate.ExchangeAmtFCYToFCY(
                      ApplnDate,"Currency Code",ApplnCurrencyCode,"Remaining Amount");
                  "Remaining Pmt. Disc. Possible" :=
                    CurrExchRate.ExchangeAmtFCYToFCY(
                      ApplnDate,"Currency Code",ApplnCurrencyCode,"Remaining Pmt. Disc. Possible");
                  "Max. Payment Tolerance" :=
                    CurrExchRate.ExchangeAmtFCYToFCY(
                      ApplnDate,"Currency Code",ApplnCurrencyCode,"Max. Payment Tolerance");
                  "Amount to Apply" :=
                    CurrExchRate.ExchangeAmtFCYToFCY(
                      ApplnDate,"Currency Code",ApplnCurrencyCode,"Amount to Apply");
                END;
                // Check Payment Discount
                UseDisc := FALSE;
                IF CheckCalcPmtDiscCust(
                     CustLedgEntry2,AppliedCustLedgEntry,ApplnRoundingPrecision,FALSE,FALSE) AND
                   (((CustledgEntry.Amount > 0) AND (i = 1)) OR
                    (("Remaining Amount" < 0) AND (i = 1)) OR
                    (ABS(ABS(CustLedgEntry2."Remaining Amount") + ApplnRoundingPrecision -
                       ABS("Remaining Amount")) >= ABS("Remaining Pmt. Disc. Possible" + "Max. Payment Tolerance")) OR
                    (ABS(ABS(CustLedgEntry2."Remaining Amount") + ApplnRoundingPrecision -
                       ABS("Remaining Amount")) <= ABS("Remaining Pmt. Disc. Possible" + MaxPmtTolAmount)))
                THEN BEGIN
                  PmtDiscAmount := PmtDiscAmount + "Remaining Pmt. Disc. Possible";
                  UseDisc := TRUE;
                END;

                // Check Payment Discount Tolerance
                IF "Amount to Apply" = "Remaining Amount" THEN
                  AvailableAmount := CustLedgEntry2."Remaining Amount"
                ELSE
                  AvailableAmount := -"Amount to Apply";
                IF CheckPmtDiscTolCust(CustLedgEntry2."Posting Date",
                     CustledgEntry."Document Type",AvailableAmount,
                     AppliedCustLedgEntry,ApplnRoundingPrecision,MaxPmtTolAmount) AND
                   (((CustledgEntry.Amount > 0) AND (i = 1)) OR
                    (("Remaining Amount" < 0) AND (i = 1)) OR
                    (ABS(ABS(CustLedgEntry2."Remaining Amount") + ApplnRoundingPrecision -
                       ABS("Remaining Amount")) >= ABS("Remaining Pmt. Disc. Possible" + "Max. Payment Tolerance")) OR
                    (ABS(ABS(CustLedgEntry2."Remaining Amount") + ApplnRoundingPrecision -
                       ABS("Remaining Amount")) <= ABS("Remaining Pmt. Disc. Possible" + MaxPmtTolAmount)))
                THEN BEGIN
                  PmtDiscAmount := PmtDiscAmount + "Remaining Pmt. Disc. Possible";
                  UseDisc := TRUE;
                  "Accepted Pmt. Disc. Tolerance" := TRUE;
                  IF CustledgEntry."Currency Code" <> "Currency Code" THEN BEGIN
                    RemainingPmtDiscPossible := "Remaining Pmt. Disc. Possible";
                    "Remaining Pmt. Disc. Possible" := AppliedCustLedgEntryTemp."Remaining Pmt. Disc. Possible";
                    "Max. Payment Tolerance" := AppliedCustLedgEntryTemp."Max. Payment Tolerance";
                  END;
                  MODIFY;
                  IF CustledgEntry."Currency Code" <> "Currency Code" THEN
                    "Remaining Pmt. Disc. Possible" := RemainingPmtDiscPossible;
                END;

                IF CustledgEntry."Entry No." <> "Entry No." THEN BEGIN
                  MaxPmtTolAmount := ROUND(MaxPmtTolAmount,AmountRoundingPrecision);
                  PmtDiscAmount := ROUND(PmtDiscAmount,AmountRoundingPrecision);
                  AppliedAmount := AppliedAmount + ROUND("Remaining Amount",AmountRoundingPrecision);
                  IF UseDisc THEN BEGIN
                    AmounttoApply :=
                      AmounttoApply +
                      ROUND(
                        ABSMinTol(
                          "Remaining Amount" -
                          "Remaining Pmt. Disc. Possible",
                          "Amount to Apply",
                          MaxPmtTolAmount),
                        AmountRoundingPrecision);
                    CustLedgEntry2."Remaining Amount" :=
                      CustLedgEntry2."Remaining Amount" +
                      ROUND("Remaining Amount" - "Remaining Pmt. Disc. Possible",AmountRoundingPrecision)
                  END ELSE BEGIN
                    AmounttoApply := AmounttoApply + ROUND("Amount to Apply",AmountRoundingPrecision);
                    CustLedgEntry2."Remaining Amount" :=
                      CustLedgEntry2."Remaining Amount" + ROUND("Remaining Amount",AmountRoundingPrecision);
                  END;
                  IF CustledgEntry."Remaining Amount" > 0 THEN BEGIN
                    CustledgEntry."Remaining Amount" := CustledgEntry."Remaining Amount" + "Remaining Amount";
                    IF CustledgEntry."Remaining Amount" < 0 THEN
                      CustledgEntry."Remaining Amount" := 0;
                  END;
                  IF CustledgEntry."Remaining Amount" < 0 THEN BEGIN
                    CustledgEntry."Remaining Amount" := CustledgEntry."Remaining Amount" + "Remaining Amount";
                    IF CustledgEntry."Remaining Amount" > 0 THEN
                      CustledgEntry."Remaining Amount" := 0;
                  END;
                END ELSE
                  ApplyingAmount := "Remaining Amount";
              UNTIL NEXT = 0;

            COMMIT;
          END;
        END;
      END ELSE
        IF CustledgEntry."Applies-to Doc. No." <> '' THEN BEGIN
          AppliedCustLedgEntry.SETCURRENTKEY("Customer No.",Open);
          AppliedCustLedgEntry.SETRANGE("Customer No.",CustledgEntry."Customer No.");
          AppliedCustLedgEntry.SETRANGE(Open,TRUE);
          AppliedCustLedgEntry.SETRANGE("Document No.",CustledgEntry."Applies-to Doc. No.");
          IF AppliedCustLedgEntry.FIND('-') THEN BEGIN
            GetApplicationRoundingPrecisionForAppliesToDoc(
              AppliedCustLedgEntry."Currency Code",ApplnRoundingPrecision,AmountRoundingPrecision,ApplnCurrencyCode);
            UpdateCustAmountsForApplication(AppliedCustLedgEntry,CustledgEntry,AppliedCustLedgEntryTemp);
            CheckCustPaymentAmountsForAppliesToDoc(
              CustledgEntry,AppliedCustLedgEntry,AppliedCustLedgEntryTemp,MaxPmtTolAmount,ApplnRoundingPrecision,PmtDiscAmount,
              ApplnCurrencyCode);
            MaxPmtTolAmount := ROUND(MaxPmtTolAmount,AmountRoundingPrecision);
            PmtDiscAmount := ROUND(PmtDiscAmount,AmountRoundingPrecision);
            AppliedAmount := ROUND(AppliedCustLedgEntry."Remaining Amount",AmountRoundingPrecision);
            AmounttoApply := ROUND(AppliedCustLedgEntry."Amount to Apply",AmountRoundingPrecision);
          END;
          ApplyingAmount := CustledgEntry.Amount;
        END;
    END;

    LOCAL PROCEDURE CalcVendApplnAmount@27(VendledgEntry@1000 : Record 25;GLSetup@1003 : Record 98;VAR AppliedAmount@1001 : Decimal;VAR ApplyingAmount@1002 : Decimal;VAR AmounttoApply@1017 : Decimal;VAR PmtDiscAmount@1022 : Decimal;VAR MaxPmtTolAmount@1005 : Decimal;VendEntryApplID@1021 : Code[50];VAR ApplnRoundingPrecision@1011 : Decimal);
    VAR
      CurrExchRate@1019 : Record 330;
      AppliedVendLedgEntry@1018 : Record 25;
      AppliedVendLedgEntryTemp@1010 : TEMPORARY Record 25;
      VendLedgEntry2@1004 : Record 25;
      ApplnCurrencyCode@1015 : Code[10];
      ApplnDate@1014 : Date;
      AmountRoundingPrecision@1012 : Decimal;
      TempAmount@1009 : Decimal;
      i@1008 : Integer;
      PositiveFilter@1007 : Boolean;
      SetPositiveFilter@1006 : Boolean;
      ApplnInMultiCurrency@1013 : Boolean;
      RemainingPmtDiscPossible@1023 : Decimal;
      UseDisc@1024 : Boolean;
      AvailableAmount@1026 : Decimal;
    BEGIN
      ApplnCurrencyCode := VendledgEntry."Currency Code";
      ApplnDate := VendledgEntry."Posting Date";
      ApplnRoundingPrecision := GLSetup."Appln. Rounding Precision";
      AmountRoundingPrecision := GLSetup."Amount Rounding Precision";

      IF VendEntryApplID <> '' THEN BEGIN
        AppliedVendLedgEntry.SETCURRENTKEY("Vendor No.","Applies-to ID",Open,Positive);
        AppliedVendLedgEntry.SETRANGE("Vendor No.",VendledgEntry."Vendor No.");
        AppliedVendLedgEntry.SETRANGE("Applies-to ID",VendEntryApplID);
        AppliedVendLedgEntry.SETRANGE(Open,TRUE);
        VendLedgEntry2 := VendledgEntry;
        PositiveFilter := VendledgEntry."Remaining Amount" > 0;
        AppliedVendLedgEntry.SETRANGE(Positive,NOT PositiveFilter);

        IF VendledgEntry."Entry No." <> 0 THEN
          AppliedVendLedgEntry.SETFILTER("Entry No.",'<>%1',VendledgEntry."Entry No.");
        GetVendApplicationRoundingPrecisionForAppliesToID(AppliedVendLedgEntry,
          ApplnRoundingPrecision,AmountRoundingPrecision,ApplnInMultiCurrency,ApplnCurrencyCode);
        IF AppliedVendLedgEntry.FIND('-') THEN BEGIN
          ApplyingAmount := VendledgEntry."Remaining Amount";
          TempAmount := VendledgEntry."Remaining Amount";
          AppliedVendLedgEntry.SETRANGE(Positive);
          AppliedVendLedgEntry.FIND('-');
          REPEAT
            UpdateVendAmountsForApplication(AppliedVendLedgEntry,VendledgEntry,AppliedVendLedgEntryTemp);
            CheckVendPaymentAmountsForAppliesToID(
              VendledgEntry,AppliedVendLedgEntry,AppliedVendLedgEntryTemp,MaxPmtTolAmount,AvailableAmount,TempAmount,
              ApplnRoundingPrecision);
          UNTIL AppliedVendLedgEntry.NEXT = 0;

          TempAmount := TempAmount + MaxPmtTolAmount;
          PositiveFilter := GetVendPositiveFilter(VendledgEntry."Document Type",TempAmount);
          SetPositiveFilter := TRUE;
          AppliedVendLedgEntry.SETRANGE(Positive,NOT PositiveFilter);
        END ELSE
          AppliedVendLedgEntry.SETRANGE(Positive);

        IF VendledgEntry."Entry No." <> 0 THEN
          AppliedVendLedgEntry.SETRANGE("Entry No.");

        FOR i := 1 TO 2 DO BEGIN
          IF SetPositiveFilter THEN BEGIN
            IF i = 2 THEN
              AppliedVendLedgEntry.SETRANGE(Positive,PositiveFilter);
          END ELSE
            i := 2;

          WITH AppliedVendLedgEntry DO BEGIN
            IF FIND('-') THEN
              REPEAT
                CALCFIELDS("Remaining Amount");
                AppliedVendLedgEntryTemp := AppliedVendLedgEntry;
                IF "Currency Code" <> ApplnCurrencyCode THEN BEGIN
                  "Remaining Amount" :=
                    CurrExchRate.ExchangeAmtFCYToFCY(
                      ApplnDate,"Currency Code",ApplnCurrencyCode,"Remaining Amount");
                  "Remaining Pmt. Disc. Possible" :=
                    CurrExchRate.ExchangeAmtFCYToFCY(
                      ApplnDate,"Currency Code",ApplnCurrencyCode,"Remaining Pmt. Disc. Possible");
                  "Max. Payment Tolerance" :=
                    CurrExchRate.ExchangeAmtFCYToFCY(
                      ApplnDate,"Currency Code",ApplnCurrencyCode,"Max. Payment Tolerance");
                  "Amount to Apply" :=
                    CurrExchRate.ExchangeAmtFCYToFCY(
                      ApplnDate,"Currency Code",ApplnCurrencyCode,"Amount to Apply");
                END;
                // Check Payment Discount
                UseDisc := FALSE;
                IF CheckCalcPmtDiscVend(
                     VendLedgEntry2,AppliedVendLedgEntry,ApplnRoundingPrecision,FALSE,FALSE) AND
                   (((VendledgEntry.Amount < 0) AND (i = 1)) OR
                    (("Remaining Amount" > 0) AND (i = 1)) OR
                    (ABS(ABS(VendLedgEntry2."Remaining Amount") + ApplnRoundingPrecision -
                       ABS("Remaining Amount")) >= ABS("Remaining Pmt. Disc. Possible" + "Max. Payment Tolerance")) OR
                    (ABS(ABS(VendLedgEntry2."Remaining Amount") + ApplnRoundingPrecision -
                       ABS("Remaining Amount")) <= ABS("Remaining Pmt. Disc. Possible" + MaxPmtTolAmount)))
                THEN BEGIN
                  PmtDiscAmount := PmtDiscAmount + "Remaining Pmt. Disc. Possible";
                  UseDisc := TRUE;
                END;

                // Check Payment Discount Tolerance
                IF "Amount to Apply" = "Remaining Amount" THEN
                  AvailableAmount := VendLedgEntry2."Remaining Amount"
                ELSE
                  AvailableAmount := -"Amount to Apply";

                IF CheckPmtDiscTolVend(
                     VendLedgEntry2."Posting Date",VendledgEntry."Document Type",AvailableAmount,
                     AppliedVendLedgEntry,ApplnRoundingPrecision,MaxPmtTolAmount) AND
                   (((VendledgEntry.Amount < 0) AND (i = 1)) OR
                    (("Remaining Amount" > 0) AND (i = 1)) OR
                    (ABS(ABS(VendLedgEntry2."Remaining Amount") + ApplnRoundingPrecision -
                       ABS("Remaining Amount")) >= ABS("Remaining Pmt. Disc. Possible" + "Max. Payment Tolerance")) OR
                    (ABS(ABS(VendLedgEntry2."Remaining Amount") + ApplnRoundingPrecision -
                       ABS("Remaining Amount")) <= ABS("Remaining Pmt. Disc. Possible" + MaxPmtTolAmount)))
                THEN BEGIN
                  PmtDiscAmount := PmtDiscAmount + "Remaining Pmt. Disc. Possible";
                  UseDisc := TRUE;
                  "Accepted Pmt. Disc. Tolerance" := TRUE;
                  IF VendledgEntry."Currency Code" <> "Currency Code" THEN BEGIN
                    RemainingPmtDiscPossible := "Remaining Pmt. Disc. Possible";
                    "Remaining Pmt. Disc. Possible" := AppliedVendLedgEntryTemp."Remaining Pmt. Disc. Possible";
                    "Max. Payment Tolerance" := AppliedVendLedgEntryTemp."Max. Payment Tolerance";
                  END;
                  MODIFY;
                  IF VendledgEntry."Currency Code" <> "Currency Code" THEN
                    "Remaining Pmt. Disc. Possible" := RemainingPmtDiscPossible;
                END;

                IF VendledgEntry."Entry No." <> "Entry No." THEN BEGIN
                  PmtDiscAmount := ROUND(PmtDiscAmount,AmountRoundingPrecision);
                  MaxPmtTolAmount := ROUND(MaxPmtTolAmount,AmountRoundingPrecision);
                  AppliedAmount := AppliedAmount + ROUND("Remaining Amount",AmountRoundingPrecision);
                  IF UseDisc THEN BEGIN
                    AmounttoApply :=
                      AmounttoApply +
                      ROUND(
                        ABSMinTol(
                          "Remaining Amount" -
                          "Remaining Pmt. Disc. Possible",
                          "Amount to Apply",
                          MaxPmtTolAmount),
                        AmountRoundingPrecision);
                    VendLedgEntry2."Remaining Amount" :=
                      VendLedgEntry2."Remaining Amount" +
                      ROUND("Remaining Amount" - "Remaining Pmt. Disc. Possible",AmountRoundingPrecision)
                  END ELSE BEGIN
                    AmounttoApply := AmounttoApply + ROUND("Amount to Apply",AmountRoundingPrecision);
                    VendLedgEntry2."Remaining Amount" :=
                      VendLedgEntry2."Remaining Amount" + ROUND("Remaining Amount",AmountRoundingPrecision);
                  END;
                  IF VendledgEntry."Remaining Amount" > 0 THEN BEGIN
                    VendledgEntry."Remaining Amount" := VendledgEntry."Remaining Amount" + "Remaining Amount";
                    IF VendledgEntry."Remaining Amount" < 0 THEN
                      VendledgEntry."Remaining Amount" := 0;
                  END;
                  IF VendledgEntry."Remaining Amount" < 0 THEN BEGIN
                    VendledgEntry."Remaining Amount" := VendledgEntry."Remaining Amount" + "Remaining Amount";
                    IF VendledgEntry."Remaining Amount" > 0 THEN
                      VendledgEntry."Remaining Amount" := 0;
                  END;
                END ELSE
                  ApplyingAmount := "Remaining Amount";
              UNTIL NEXT = 0;

            COMMIT;
          END;
        END;
      END ELSE
        IF VendledgEntry."Applies-to Doc. No." <> '' THEN BEGIN
          AppliedVendLedgEntry.SETCURRENTKEY("Vendor No.",Open);
          AppliedVendLedgEntry.SETRANGE("Vendor No.",VendledgEntry."Vendor No.");
          AppliedVendLedgEntry.SETRANGE(Open,TRUE);
          AppliedVendLedgEntry.SETRANGE("Document No.",VendledgEntry."Applies-to Doc. No.");
          IF AppliedVendLedgEntry.FIND('-') THEN BEGIN
            GetApplicationRoundingPrecisionForAppliesToDoc(
              AppliedVendLedgEntry."Currency Code",ApplnRoundingPrecision,AmountRoundingPrecision,ApplnCurrencyCode);
            UpdateVendAmountsForApplication(AppliedVendLedgEntry,VendledgEntry,AppliedVendLedgEntryTemp);
            CheckVendPaymentAmountsForAppliesToDoc(VendledgEntry,AppliedVendLedgEntry,AppliedVendLedgEntryTemp,MaxPmtTolAmount,
              ApplnRoundingPrecision,PmtDiscAmount);
            PmtDiscAmount := ROUND(PmtDiscAmount,AmountRoundingPrecision);
            MaxPmtTolAmount := ROUND(MaxPmtTolAmount,AmountRoundingPrecision);
            AppliedAmount := ROUND(AppliedVendLedgEntry."Remaining Amount",AmountRoundingPrecision);
            AmounttoApply := ROUND(AppliedVendLedgEntry."Amount to Apply",AmountRoundingPrecision);
          END;
          ApplyingAmount := VendledgEntry.Amount;
        END;
    END;

    LOCAL PROCEDURE CheckPmtDiscTolCust@13(NewPostingdate@1003 : Date;NewDocType@1002 : ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';NewAmount@1001 : Decimal;OldCustLedgEntry@1000 : Record 21;ApplnRoundingPrecision@1004 : Decimal;MaxPmtTolAmount@1006 : Decimal) : Boolean;
    VAR
      ToleranceAmount@1005 : Decimal;
    BEGIN
      IF ((NewDocType = NewDocType::Payment) AND
          ((OldCustLedgEntry."Document Type" IN [OldCustLedgEntry."Document Type"::Invoice,
                                                 OldCustLedgEntry."Document Type"::"Credit Memo"]) AND
           (NewPostingdate > OldCustLedgEntry."Pmt. Discount Date") AND
           (NewPostingdate <= OldCustLedgEntry."Pmt. Disc. Tolerance Date"))) OR
         ((NewDocType = NewDocType::Refund) AND
          ((OldCustLedgEntry."Document Type" = OldCustLedgEntry."Document Type"::"Credit Memo") AND
           (NewPostingdate > OldCustLedgEntry."Pmt. Discount Date") AND
           (NewPostingdate <= OldCustLedgEntry."Pmt. Disc. Tolerance Date")))
      THEN BEGIN
        ToleranceAmount := (ABS(NewAmount) + ApplnRoundingPrecision) -
          ABS(OldCustLedgEntry."Remaining Amount" - OldCustLedgEntry."Remaining Pmt. Disc. Possible");
        EXIT((ToleranceAmount >= 0) OR (ABS(MaxPmtTolAmount) >= ABS(ToleranceAmount)));
      END;
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE CheckPmtTolCust@12(NewDocType@1002 : ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';OldCustLedgEntry@1000 : Record 21) : Boolean;
    BEGIN
      IF ((NewDocType = NewDocType::Payment) AND
          (OldCustLedgEntry."Document Type" = OldCustLedgEntry."Document Type"::Invoice)) OR
         ((NewDocType = NewDocType::Refund) AND
          (OldCustLedgEntry."Document Type" = OldCustLedgEntry."Document Type"::"Credit Memo"))
      THEN
        EXIT(TRUE);

      EXIT(FALSE);
    END;

    LOCAL PROCEDURE CheckPmtDiscTolVend@8(NewPostingdate@1003 : Date;NewDocType@1002 : ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';NewAmount@1001 : Decimal;OldVendLedgEntry@1000 : Record 25;ApplnRoundingPrecision@1004 : Decimal;MaxPmtTolAmount@1005 : Decimal) : Boolean;
    VAR
      ToleranceAmount@1006 : Decimal;
    BEGIN
      IF ((NewDocType = NewDocType::Payment) AND
          ((OldVendLedgEntry."Document Type" IN [OldVendLedgEntry."Document Type"::Invoice,
                                                 OldVendLedgEntry."Document Type"::"Credit Memo"]) AND
           (NewPostingdate > OldVendLedgEntry."Pmt. Discount Date") AND
           (NewPostingdate <= OldVendLedgEntry."Pmt. Disc. Tolerance Date"))) OR
         ((NewDocType = NewDocType::Refund) AND
          ((OldVendLedgEntry."Document Type" = OldVendLedgEntry."Document Type"::"Credit Memo") AND
           (NewPostingdate > OldVendLedgEntry."Pmt. Discount Date") AND
           (NewPostingdate <= OldVendLedgEntry."Pmt. Disc. Tolerance Date")))
      THEN BEGIN
        ToleranceAmount := (ABS(NewAmount) + ApplnRoundingPrecision) -
          ABS(OldVendLedgEntry."Remaining Amount" - OldVendLedgEntry."Remaining Pmt. Disc. Possible");
        EXIT((ToleranceAmount >= 0) OR (ABS(MaxPmtTolAmount) >= ABS(ToleranceAmount)));
      END;
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE CheckPmtTolVend@6(NewDocType@1002 : ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';OldVendLedgEntry@1000 : Record 25) : Boolean;
    BEGIN
      IF ((NewDocType = NewDocType::Payment) AND
          (OldVendLedgEntry."Document Type" = OldVendLedgEntry."Document Type"::Invoice)) OR
         ((NewDocType = NewDocType::Refund) AND
          (OldVendLedgEntry."Document Type" = OldVendLedgEntry."Document Type"::"Credit Memo"))
      THEN
        EXIT(TRUE);

      EXIT(FALSE);
    END;

    LOCAL PROCEDURE CallPmtDiscTolWarning@17(PostingDate@1007 : Date;No@1006 : Code[20];DocNo@1005 : Code[20];CurrencyCode@1004 : Code[10];Amount@1003 : Decimal;AppliedAmount@1002 : Decimal;PmtDiscAmount@1001 : Decimal;VAR RemainingAmountTest@1009 : Boolean) : Boolean;
    VAR
      PmtDiscTolWarning@1000 : Page 599;
      ActionType@1008 : Integer;
    BEGIN
      IF PmtDiscAmount = 0 THEN BEGIN
        RemainingAmountTest := FALSE;
        EXIT(TRUE);
      END;
      PmtDiscTolWarning.SetValues(PostingDate,No,DocNo,CurrencyCode,Amount,AppliedAmount,PmtDiscAmount);
      PmtDiscTolWarning.LOOKUPMODE(TRUE);
      IF ACTION::Yes = PmtDiscTolWarning.RUNMODAL THEN BEGIN
        PmtDiscTolWarning.GetValues(ActionType);
        IF ActionType = 2 THEN
          RemainingAmountTest := TRUE
        ELSE
          RemainingAmountTest := FALSE;
      END ELSE
        EXIT(FALSE);
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE CallPmtTolWarning@18(PostingDate@1006 : Date;No@1005 : Code[20];DocNo@1004 : Code[20];CurrencyCode@1003 : Code[10];VAR Amount@1002 : Decimal;AppliedAmount@1001 : Decimal) : Boolean;
    VAR
      PmtTolWarning@1008 : Page 591;
      ActionType@1007 : Integer;
    BEGIN
      PmtTolWarning.SetValues(PostingDate,No,DocNo,CurrencyCode,Amount,AppliedAmount,0);
      PmtTolWarning.LOOKUPMODE(TRUE);
      IF ACTION::Yes = PmtTolWarning.RUNMODAL THEN BEGIN
        PmtTolWarning.GetValues(ActionType);
        IF ActionType = 2 THEN
          Amount := 0;
      END ELSE
        EXIT(FALSE);
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE PutCustPmtTolAmount@15(CustledgEntry@1000 : Record 21;Amount@1001 : Decimal;AppliedAmount@1007 : Decimal;CustEntryApplID@1009 : Code[50]);
    VAR
      AppliedCustLedgEntry@1002 : Record 21;
      AppliedCustLedgEntryTemp@1013 : Record 21;
      Currency@1012 : Record 4;
      Number@1004 : Integer;
      AcceptedTolAmount@1005 : Decimal;
      AcceptedEntryTolAmount@1011 : Decimal;
      TotalAmount@1006 : Decimal;
    BEGIN
      AppliedCustLedgEntry.SETCURRENTKEY("Customer No.",Open,Positive);
      AppliedCustLedgEntry.SETRANGE("Customer No.",CustledgEntry."Customer No.");
      AppliedCustLedgEntry.SETRANGE(Open,TRUE);

      IF CustledgEntry."Applies-to Doc. No." <> '' THEN
        AppliedCustLedgEntry.SETRANGE("Document No.",CustledgEntry."Applies-to Doc. No.")
      ELSE
        AppliedCustLedgEntry.SETRANGE("Applies-to ID",CustEntryApplID);

      IF CustledgEntry."Document Type" = CustledgEntry."Document Type"::Payment THEN
        AppliedCustLedgEntry.SETRANGE(Positive,TRUE)
      ELSE
        AppliedCustLedgEntry.SETRANGE(Positive,FALSE);
      IF AppliedCustLedgEntry.FINDSET(FALSE,FALSE) THEN
        REPEAT
          IF AppliedCustLedgEntry."Max. Payment Tolerance" <> 0 THEN BEGIN
            AppliedCustLedgEntry.CALCFIELDS(Amount);
            IF CustledgEntry."Currency Code" <> AppliedCustLedgEntry."Currency Code" THEN
              AppliedCustLedgEntry.Amount :=
                CurrExchRate.ExchangeAmount(
                  AppliedCustLedgEntry.Amount,
                  AppliedCustLedgEntry."Currency Code",
                  CustledgEntry."Currency Code",CustledgEntry."Posting Date");
            TotalAmount := TotalAmount + AppliedCustLedgEntry.Amount;
          END;
        UNTIL AppliedCustLedgEntry.NEXT = 0;

      AppliedCustLedgEntry.LOCKTABLE;

      AcceptedTolAmount := Amount + AppliedAmount;
      Number := AppliedCustLedgEntry.COUNT;

      IF AppliedCustLedgEntry.FIND('-') THEN
        REPEAT
          AppliedCustLedgEntry.CALCFIELDS("Remaining Amount");
          AppliedCustLedgEntryTemp := AppliedCustLedgEntry;
          IF AppliedCustLedgEntry."Currency Code" = '' THEN BEGIN
            Currency.INIT;
            Currency.Code := '';
            Currency.InitRoundingPrecision;
          END ELSE
            IF AppliedCustLedgEntry."Currency Code" <> Currency.Code THEN
              Currency.GET(AppliedCustLedgEntry."Currency Code");
          IF Number <> 1 THEN BEGIN
            AppliedCustLedgEntry.CALCFIELDS(Amount);
            IF CustledgEntry."Currency Code" <> AppliedCustLedgEntry."Currency Code" THEN
              AppliedCustLedgEntry.Amount :=
                CurrExchRate.ExchangeAmount(
                  AppliedCustLedgEntry.Amount,
                  AppliedCustLedgEntry."Currency Code",
                  CustledgEntry."Currency Code",CustledgEntry."Posting Date");
            AcceptedEntryTolAmount := ROUND((AppliedCustLedgEntry.Amount / TotalAmount) * AcceptedTolAmount);
            TotalAmount := TotalAmount - AppliedCustLedgEntry.Amount;
            AcceptedTolAmount := AcceptedTolAmount - AcceptedEntryTolAmount;
            AppliedCustLedgEntry."Accepted Payment Tolerance" := AcceptedEntryTolAmount;
          END ELSE BEGIN
            AcceptedEntryTolAmount := AcceptedTolAmount;
            AppliedCustLedgEntry."Accepted Payment Tolerance" := AcceptedEntryTolAmount;
          END;
          AppliedCustLedgEntry."Max. Payment Tolerance" := AppliedCustLedgEntryTemp."Max. Payment Tolerance";
          AppliedCustLedgEntry."Amount to Apply" := AppliedCustLedgEntryTemp."Remaining Amount";
          AppliedCustLedgEntry.MODIFY;
          Number := Number - 1;
        UNTIL AppliedCustLedgEntry.NEXT = 0;

      COMMIT;
    END;

    LOCAL PROCEDURE PutVendPmtTolAmount@7(VendLedgEntry@1000 : Record 25;Amount@1009 : Decimal;AppliedAmount@1008 : Decimal;VendEntryApplID@1001 : Code[50]);
    VAR
      AppliedVendLedgEntry@1012 : Record 25;
      AppliedVendLedgEntryTemp@1013 : Record 25;
      Currency@1011 : Record 4;
      Number@1006 : Integer;
      AcceptedTolAmount@1005 : Decimal;
      AcceptedEntryTolAmount@1003 : Decimal;
      TotalAmount@1004 : Decimal;
    BEGIN
      AppliedVendLedgEntry.SETCURRENTKEY("Vendor No.",Open,Positive);
      AppliedVendLedgEntry.SETRANGE("Vendor No.",VendLedgEntry."Vendor No.");
      AppliedVendLedgEntry.SETRANGE(Open,TRUE);

      IF VendLedgEntry."Applies-to Doc. No." <> '' THEN
        AppliedVendLedgEntry.SETRANGE("Document No.",VendLedgEntry."Applies-to Doc. No.")
      ELSE
        AppliedVendLedgEntry.SETRANGE("Applies-to ID",VendEntryApplID);

      IF VendLedgEntry."Document Type" = VendLedgEntry."Document Type"::Payment THEN
        AppliedVendLedgEntry.SETRANGE(Positive,FALSE)
      ELSE
        AppliedVendLedgEntry.SETRANGE(Positive,TRUE);
      IF AppliedVendLedgEntry.FINDSET(FALSE,FALSE) THEN
        REPEAT
          IF AppliedVendLedgEntry."Max. Payment Tolerance" <> 0 THEN BEGIN
            AppliedVendLedgEntry.CALCFIELDS(Amount);
            IF VendLedgEntry."Currency Code" <> AppliedVendLedgEntry."Currency Code" THEN
              AppliedVendLedgEntry.Amount :=
                CurrExchRate.ExchangeAmount(
                  AppliedVendLedgEntry.Amount,
                  AppliedVendLedgEntry."Currency Code",
                  VendLedgEntry."Currency Code",VendLedgEntry."Posting Date");
            TotalAmount := TotalAmount + AppliedVendLedgEntry.Amount;
          END;
        UNTIL AppliedVendLedgEntry.NEXT = 0;

      AppliedVendLedgEntry.LOCKTABLE;

      AcceptedTolAmount := Amount + AppliedAmount;
      Number := AppliedVendLedgEntry.COUNT;

      IF AppliedVendLedgEntry.FIND('-') THEN
        REPEAT
          AppliedVendLedgEntry.CALCFIELDS("Remaining Amount");
          AppliedVendLedgEntryTemp := AppliedVendLedgEntry;
          IF AppliedVendLedgEntry."Currency Code" = '' THEN BEGIN
            Currency.INIT;
            Currency.Code := '';
            Currency.InitRoundingPrecision;
          END ELSE
            IF AppliedVendLedgEntry."Currency Code" <> Currency.Code THEN
              Currency.GET(AppliedVendLedgEntry."Currency Code");
          IF VendLedgEntry."Currency Code" <> AppliedVendLedgEntry."Currency Code" THEN
            AppliedVendLedgEntry."Max. Payment Tolerance" :=
              CurrExchRate.ExchangeAmount(
                AppliedVendLedgEntry."Max. Payment Tolerance",
                AppliedVendLedgEntry."Currency Code",
                VendLedgEntry."Currency Code",VendLedgEntry."Posting Date");
          IF Number <> 1 THEN BEGIN
            AppliedVendLedgEntry.CALCFIELDS(Amount);
            IF VendLedgEntry."Currency Code" <> AppliedVendLedgEntry."Currency Code" THEN
              AppliedVendLedgEntry.Amount :=
                CurrExchRate.ExchangeAmount(
                  AppliedVendLedgEntry.Amount,
                  AppliedVendLedgEntry."Currency Code",
                  VendLedgEntry."Currency Code",VendLedgEntry."Posting Date");
            AcceptedEntryTolAmount := ROUND((AppliedVendLedgEntry.Amount / TotalAmount) * AcceptedTolAmount);
            TotalAmount := TotalAmount - AppliedVendLedgEntry.Amount;
            AcceptedTolAmount := AcceptedTolAmount - AcceptedEntryTolAmount;
            AppliedVendLedgEntry."Accepted Payment Tolerance" := AcceptedEntryTolAmount;
          END ELSE BEGIN
            AcceptedEntryTolAmount := AcceptedTolAmount;
            AppliedVendLedgEntry."Accepted Payment Tolerance" := AcceptedEntryTolAmount;
          END;
          AppliedVendLedgEntry."Max. Payment Tolerance" := AppliedVendLedgEntryTemp."Max. Payment Tolerance";
          AppliedVendLedgEntry."Amount to Apply" := AppliedVendLedgEntryTemp."Remaining Amount";
          AppliedVendLedgEntry.MODIFY;
          Number := Number - 1;
        UNTIL AppliedVendLedgEntry.NEXT = 0;

      COMMIT;
    END;

    LOCAL PROCEDURE DelCustPmtTolAcc@1(CustledgEntry@1004 : Record 21;CustEntryApplID@1000 : Code[50]);
    VAR
      AppliedCustLedgEntry@1001 : Record 21;
    BEGIN
      IF CustledgEntry."Applies-to Doc. No." <> '' THEN BEGIN
        AppliedCustLedgEntry.SETCURRENTKEY("Customer No.",Open,Positive);
        AppliedCustLedgEntry.SETRANGE("Customer No.",CustledgEntry."Customer No.");
        AppliedCustLedgEntry.SETRANGE(Open,TRUE);
        AppliedCustLedgEntry.SETRANGE("Document No.",CustledgEntry."Applies-to Doc. No.");
        AppliedCustLedgEntry.LOCKTABLE;
        IF AppliedCustLedgEntry.FIND('-') THEN BEGIN
          AppliedCustLedgEntry."Accepted Payment Tolerance" := 0;
          AppliedCustLedgEntry."Accepted Pmt. Disc. Tolerance" := FALSE;
          AppliedCustLedgEntry.MODIFY;
          COMMIT;
        END;
      END;

      IF CustEntryApplID <> '' THEN BEGIN
        AppliedCustLedgEntry.SETCURRENTKEY("Customer No.",Open,Positive);
        AppliedCustLedgEntry.SETRANGE("Customer No.",CustledgEntry."Customer No.");
        AppliedCustLedgEntry.SETRANGE(Open,TRUE);
        AppliedCustLedgEntry.SETRANGE("Applies-to ID",CustEntryApplID);
        AppliedCustLedgEntry.LOCKTABLE;
        IF AppliedCustLedgEntry.FIND('-') THEN BEGIN
          REPEAT
            AppliedCustLedgEntry."Accepted Payment Tolerance" := 0;
            AppliedCustLedgEntry."Accepted Pmt. Disc. Tolerance" := FALSE;
            AppliedCustLedgEntry.MODIFY;
          UNTIL AppliedCustLedgEntry.NEXT = 0;
          COMMIT;
        END;
      END;
    END;

    LOCAL PROCEDURE DelVendPmtTolAcc@19(VendLedgEntry@1001 : Record 25;VendEntryApplID@1000 : Code[50]);
    VAR
      AppliedVendLedgEntry@1002 : Record 25;
    BEGIN
      IF VendLedgEntry."Applies-to Doc. No." <> '' THEN BEGIN
        AppliedVendLedgEntry.SETCURRENTKEY("Vendor No.",Open,Positive);
        AppliedVendLedgEntry.SETRANGE("Vendor No.",VendLedgEntry."Vendor No.");
        AppliedVendLedgEntry.SETRANGE(Open,TRUE);
        AppliedVendLedgEntry.SETRANGE("Document No.",VendLedgEntry."Applies-to Doc. No.");
        AppliedVendLedgEntry.LOCKTABLE;
        IF AppliedVendLedgEntry.FIND('-') THEN BEGIN
          AppliedVendLedgEntry."Accepted Payment Tolerance" := 0;
          AppliedVendLedgEntry."Accepted Pmt. Disc. Tolerance" := FALSE;
          AppliedVendLedgEntry.MODIFY;
          COMMIT;
        END;
      END;

      IF VendEntryApplID <> '' THEN BEGIN
        AppliedVendLedgEntry.SETCURRENTKEY("Vendor No.",Open,Positive);
        AppliedVendLedgEntry.SETRANGE("Vendor No.",VendLedgEntry."Vendor No.");
        AppliedVendLedgEntry.SETRANGE(Open,TRUE);
        AppliedVendLedgEntry.SETRANGE("Applies-to ID",VendEntryApplID);
        AppliedVendLedgEntry.LOCKTABLE;
        IF AppliedVendLedgEntry.FIND('-') THEN BEGIN
          REPEAT
            AppliedVendLedgEntry."Accepted Payment Tolerance" := 0;
            AppliedVendLedgEntry."Accepted Pmt. Disc. Tolerance" := FALSE;
            AppliedVendLedgEntry.MODIFY;
          UNTIL AppliedVendLedgEntry.NEXT = 0;
          COMMIT;
        END;
      END;
    END;

    [External]
    PROCEDURE CalcGracePeriodCVLedgEntry@9(PmtTolGracePeriode@1004 : DateFormula);
    VAR
      Customer@1000 : Record 18;
      CustLedgEntry@1001 : Record 21;
      Vendor@1002 : Record 23;
      VendLedgEntry@1003 : Record 25;
    BEGIN
      Customer.SETCURRENTKEY("No.");
      CustLedgEntry.LOCKTABLE;
      Customer.LOCKTABLE;
      IF Customer.FIND('-') THEN
        REPEAT
          IF NOT Customer."Block Payment Tolerance" THEN BEGIN
            CustLedgEntry.SETCURRENTKEY("Customer No.",Open);
            CustLedgEntry.SETRANGE("Customer No.",Customer."No.");
            CustLedgEntry.SETRANGE(Open,TRUE);
            CustLedgEntry.SETFILTER("Document Type",'%1|%2',
              CustLedgEntry."Document Type"::Invoice,
              CustLedgEntry."Document Type"::"Credit Memo");

            IF CustLedgEntry.FIND('-') THEN
              REPEAT
                IF CustLedgEntry."Pmt. Discount Date" <> 0D THEN BEGIN
                  IF CustLedgEntry."Pmt. Discount Date" <> CustLedgEntry."Document Date" THEN
                    CustLedgEntry."Pmt. Disc. Tolerance Date" :=
                      CALCDATE(PmtTolGracePeriode,CustLedgEntry."Pmt. Discount Date")
                  ELSE
                    CustLedgEntry."Pmt. Disc. Tolerance Date" :=
                      CustLedgEntry."Pmt. Discount Date";
                END ELSE
                  CustLedgEntry."Pmt. Disc. Tolerance Date" := 0D;
                CustLedgEntry.MODIFY;
              UNTIL CustLedgEntry.NEXT = 0;
          END;
        UNTIL Customer.NEXT = 0;

      Vendor.SETCURRENTKEY("No.");
      VendLedgEntry.LOCKTABLE;
      Vendor.LOCKTABLE;
      IF Vendor.FIND('-')THEN
        REPEAT
          IF NOT Vendor."Block Payment Tolerance" THEN BEGIN
            VendLedgEntry.SETCURRENTKEY("Vendor No.",Open);
            VendLedgEntry.SETRANGE("Vendor No.",Vendor."No.");
            VendLedgEntry.SETRANGE(Open,TRUE);
            VendLedgEntry.SETFILTER("Document Type",'%1|%2',
              VendLedgEntry."Document Type"::Invoice,
              VendLedgEntry."Document Type"::"Credit Memo");

            IF VendLedgEntry.FIND('-') THEN
              REPEAT
                IF VendLedgEntry."Pmt. Discount Date" <> 0D THEN BEGIN
                  IF VendLedgEntry."Pmt. Disc. Tolerance Date" <>
                     VendLedgEntry."Document Date"
                  THEN
                    VendLedgEntry."Pmt. Disc. Tolerance Date" :=
                      CALCDATE(PmtTolGracePeriode,VendLedgEntry."Pmt. Discount Date")
                  ELSE
                    VendLedgEntry."Pmt. Disc. Tolerance Date" :=
                      VendLedgEntry."Pmt. Discount Date";
                END ELSE
                  VendLedgEntry."Pmt. Disc. Tolerance Date" := 0D;
                VendLedgEntry.MODIFY;
              UNTIL VendLedgEntry.NEXT = 0;
          END;
        UNTIL Vendor.NEXT = 0;
    END;

    [External]
    PROCEDURE CalcTolCustLedgEntry@2(Customer@1000 : Record 18);
    VAR
      GLSetup@1001 : Record 98;
      Currency@1003 : Record 4;
      CustLedgEntry@1002 : Record 21;
    BEGIN
      GLSetup.GET;
      CustLedgEntry.SETCURRENTKEY("Customer No.",Open);
      CustLedgEntry.SETRANGE("Customer No.",Customer."No.");
      CustLedgEntry.SETRANGE(Open,TRUE);
      CustLedgEntry.LOCKTABLE;
      IF NOT CustLedgEntry.FIND('-') THEN
        EXIT;
      REPEAT
        IF (CustLedgEntry."Document Type" = CustLedgEntry."Document Type"::Invoice) OR
           (CustLedgEntry."Document Type" = CustLedgEntry."Document Type"::"Credit Memo")
        THEN BEGIN
          CustLedgEntry.CALCFIELDS(Amount,"Amount (LCY)");
          IF CustLedgEntry."Pmt. Discount Date" >= CustLedgEntry."Posting Date" THEN
            CustLedgEntry."Pmt. Disc. Tolerance Date" :=
              CALCDATE(GLSetup."Payment Discount Grace Period",CustLedgEntry."Pmt. Discount Date");
          IF CustLedgEntry."Currency Code" = '' THEN BEGIN
            IF (GLSetup."Max. Payment Tolerance Amount" <
                ABS(GLSetup."Payment Tolerance %" / 100 * CustLedgEntry."Amount (LCY)")) OR (GLSetup."Payment Tolerance %" = 0)
            THEN BEGIN
              IF (GLSetup."Max. Payment Tolerance Amount" = 0) AND (GLSetup."Payment Tolerance %" > 0) THEN
                CustLedgEntry."Max. Payment Tolerance" :=
                  GLSetup."Payment Tolerance %" * CustLedgEntry."Amount (LCY)" / 100
              ELSE
                IF CustLedgEntry."Document Type" = CustLedgEntry."Document Type"::"Credit Memo" THEN
                  CustLedgEntry."Max. Payment Tolerance" := -GLSetup."Max. Payment Tolerance Amount"
                ELSE
                  CustLedgEntry."Max. Payment Tolerance" := GLSetup."Max. Payment Tolerance Amount"
            END ELSE
              CustLedgEntry."Max. Payment Tolerance" :=
                GLSetup."Payment Tolerance %" * CustLedgEntry."Amount (LCY)" / 100
          END ELSE BEGIN
            Currency.GET(CustLedgEntry."Currency Code");
            IF (Currency."Max. Payment Tolerance Amount" <
                ABS(Currency."Payment Tolerance %" / 100 * CustLedgEntry.Amount)) OR (Currency."Payment Tolerance %" = 0)
            THEN BEGIN
              IF (Currency."Max. Payment Tolerance Amount" = 0) AND (Currency."Payment Tolerance %" > 0) THEN
                CustLedgEntry."Max. Payment Tolerance" :=
                  ROUND(Currency."Payment Tolerance %" * CustLedgEntry.Amount / 100,Currency."Amount Rounding Precision")
              ELSE
                IF CustLedgEntry."Document Type" = CustLedgEntry."Document Type"::"Credit Memo" THEN
                  CustLedgEntry."Max. Payment Tolerance" := -Currency."Max. Payment Tolerance Amount"
                ELSE
                  CustLedgEntry."Max. Payment Tolerance" := Currency."Max. Payment Tolerance Amount"
            END ELSE
              CustLedgEntry."Max. Payment Tolerance" :=
                ROUND(Currency."Payment Tolerance %" * CustLedgEntry.Amount / 100,Currency."Amount Rounding Precision");
          END;
        END;
        IF ABS(CustLedgEntry.Amount) < ABS(CustLedgEntry."Max. Payment Tolerance") THEN
          CustLedgEntry."Max. Payment Tolerance" := CustLedgEntry.Amount;
        CustLedgEntry.MODIFY;
      UNTIL CustLedgEntry.NEXT = 0;
    END;

    [External]
    PROCEDURE DelTolCustLedgEntry@3(Customer@1000 : Record 18);
    VAR
      GLSetup@1001 : Record 98;
      CustLedgEntry@1002 : Record 21;
    BEGIN
      GLSetup.GET;
      CustLedgEntry.SETCURRENTKEY("Customer No.",Open);
      CustLedgEntry.SETRANGE("Customer No.",Customer."No.");
      CustLedgEntry.SETRANGE(Open,TRUE);
      CustLedgEntry.LOCKTABLE;
      IF NOT CustLedgEntry.FIND('-') THEN
        EXIT;
      REPEAT
        CustLedgEntry."Pmt. Disc. Tolerance Date" := 0D;
        CustLedgEntry."Max. Payment Tolerance" := 0;
        CustLedgEntry.MODIFY;
      UNTIL CustLedgEntry.NEXT = 0;
    END;

    [External]
    PROCEDURE CalcTolVendLedgEntry@5(Vendor@1000 : Record 23);
    VAR
      GLSetup@1001 : Record 98;
      Currency@1003 : Record 4;
      VendLedgEntry@1002 : Record 25;
    BEGIN
      GLSetup.GET;
      VendLedgEntry.SETCURRENTKEY("Vendor No.",Open);
      VendLedgEntry.SETRANGE("Vendor No.",Vendor."No.");
      VendLedgEntry.SETRANGE(Open,TRUE);
      VendLedgEntry.LOCKTABLE;
      IF NOT VendLedgEntry.FIND('-') THEN
        EXIT;
      REPEAT
        IF (VendLedgEntry."Document Type" = VendLedgEntry."Document Type"::Invoice) OR
           (VendLedgEntry."Document Type" = VendLedgEntry."Document Type"::"Credit Memo")
        THEN BEGIN
          VendLedgEntry.CALCFIELDS(Amount,"Amount (LCY)");
          IF VendLedgEntry."Pmt. Discount Date" >= VendLedgEntry."Posting Date" THEN
            VendLedgEntry."Pmt. Disc. Tolerance Date" :=
              CALCDATE(GLSetup."Payment Discount Grace Period",VendLedgEntry."Pmt. Discount Date");
          IF VendLedgEntry."Currency Code" = '' THEN BEGIN
            IF (GLSetup."Max. Payment Tolerance Amount" <
                ABS(GLSetup."Payment Tolerance %" / 100 * VendLedgEntry."Amount (LCY)")) OR (GLSetup."Payment Tolerance %" = 0)
            THEN BEGIN
              IF (GLSetup."Max. Payment Tolerance Amount" = 0) AND (GLSetup."Payment Tolerance %" > 0) THEN
                VendLedgEntry."Max. Payment Tolerance" :=
                  GLSetup."Payment Tolerance %" * VendLedgEntry."Amount (LCY)" / 100
              ELSE
                IF VendLedgEntry."Document Type" = VendLedgEntry."Document Type"::"Credit Memo" THEN
                  VendLedgEntry."Max. Payment Tolerance" := GLSetup."Max. Payment Tolerance Amount"
                ELSE
                  VendLedgEntry."Max. Payment Tolerance" := -GLSetup."Max. Payment Tolerance Amount"
            END ELSE
              VendLedgEntry."Max. Payment Tolerance" :=
                GLSetup."Payment Tolerance %" * VendLedgEntry."Amount (LCY)" / 100
          END ELSE BEGIN
            Currency.GET(VendLedgEntry."Currency Code");
            IF (Currency."Max. Payment Tolerance Amount" <
                ABS(Currency."Payment Tolerance %" / 100 * VendLedgEntry.Amount)) OR (Currency."Payment Tolerance %" = 0)
            THEN BEGIN
              IF (Currency."Max. Payment Tolerance Amount" = 0) AND (Currency."Payment Tolerance %" > 0) THEN
                VendLedgEntry."Max. Payment Tolerance" :=
                  ROUND(Currency."Payment Tolerance %" * VendLedgEntry.Amount / 100,Currency."Amount Rounding Precision")
              ELSE
                IF VendLedgEntry."Document Type" = VendLedgEntry."Document Type"::"Credit Memo" THEN
                  VendLedgEntry."Max. Payment Tolerance" := Currency."Max. Payment Tolerance Amount"
                ELSE
                  VendLedgEntry."Max. Payment Tolerance" := -Currency."Max. Payment Tolerance Amount"
            END ELSE
              VendLedgEntry."Max. Payment Tolerance" :=
                ROUND(Currency."Payment Tolerance %" * VendLedgEntry.Amount / 100,Currency."Amount Rounding Precision");
          END;
        END;
        IF ABS(VendLedgEntry.Amount) < ABS(VendLedgEntry."Max. Payment Tolerance") THEN
          VendLedgEntry."Max. Payment Tolerance" := VendLedgEntry.Amount;
        VendLedgEntry.MODIFY;
      UNTIL VendLedgEntry.NEXT = 0;
    END;

    [External]
    PROCEDURE DelTolVendLedgEntry@4(Vendor@1000 : Record 23);
    VAR
      GLSetup@1001 : Record 98;
      VendLedgEntry@1002 : Record 25;
    BEGIN
      GLSetup.GET;
      VendLedgEntry.SETCURRENTKEY("Vendor No.",Open);
      VendLedgEntry.SETRANGE("Vendor No.",Vendor."No.");
      VendLedgEntry.SETRANGE(Open,TRUE);
      VendLedgEntry.LOCKTABLE;
      IF NOT VendLedgEntry.FIND('-') THEN
        EXIT;
      REPEAT
        VendLedgEntry."Pmt. Disc. Tolerance Date" := 0D;
        VendLedgEntry."Max. Payment Tolerance" := 0;
        VendLedgEntry.MODIFY;
      UNTIL VendLedgEntry.NEXT = 0;
    END;

    [External]
    PROCEDURE DelPmtTolApllnDocNo@20(GenJnlLine@1000 : Record 81;DocumentNo@1004 : Code[20]);
    VAR
      AppliedCustLedgEntry@1001 : Record 21;
      AppliedVendLedgEntry@1002 : Record 25;
    BEGIN
      IF (GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Customer) OR
         (GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Vendor)
      THEN
        CODEUNIT.RUN(CODEUNIT::"Exchange Acc. G/L Journal Line",GenJnlLine);

      IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer THEN BEGIN
        AppliedCustLedgEntry.SETCURRENTKEY("Customer No.",Open,Positive);
        AppliedCustLedgEntry.SETRANGE("Customer No.",GenJnlLine."Account No.");
        AppliedCustLedgEntry.SETRANGE(Open,TRUE);
        AppliedCustLedgEntry.SETRANGE("Document No.",DocumentNo);
        AppliedCustLedgEntry.LOCKTABLE;
        IF AppliedCustLedgEntry.FINDSET THEN BEGIN
          REPEAT
            AppliedCustLedgEntry."Accepted Payment Tolerance" := 0;
            AppliedCustLedgEntry."Accepted Pmt. Disc. Tolerance" := FALSE;
            AppliedCustLedgEntry.MODIFY;
          UNTIL AppliedCustLedgEntry.NEXT = 0;
          COMMIT;
        END;
      END ELSE
        IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor THEN BEGIN
          AppliedVendLedgEntry.SETCURRENTKEY("Vendor No.",Open,Positive);
          AppliedVendLedgEntry.SETRANGE("Vendor No.",GenJnlLine."Account No.");
          AppliedVendLedgEntry.SETRANGE(Open,TRUE);
          AppliedVendLedgEntry.SETRANGE("Document No.",DocumentNo);
          AppliedVendLedgEntry.LOCKTABLE;
          IF AppliedVendLedgEntry.FINDSET THEN BEGIN
            REPEAT
              AppliedVendLedgEntry."Accepted Payment Tolerance" := 0;
              AppliedVendLedgEntry."Accepted Pmt. Disc. Tolerance" := FALSE;
              AppliedVendLedgEntry.MODIFY;
            UNTIL AppliedVendLedgEntry.NEXT = 0;
            COMMIT;
          END;
        END;
    END;

    LOCAL PROCEDURE ABSMinTol@21(Decimal1@1000 : Decimal;Decimal2@1001 : Decimal;Decimal1Tolerance@1002 : Decimal) : Decimal;
    BEGIN
      IF ABS(Decimal1) - ABS(Decimal1Tolerance) < ABS(Decimal2) THEN
        EXIT(Decimal1);
      EXIT(Decimal2);
    END;

    LOCAL PROCEDURE DelCustPmtTolAcc2@22(CustledgEntry@1001 : Record 21;CustEntryApplID@1000 : Code[50]);
    VAR
      AppliedCustLedgEntry@1002 : Record 21;
    BEGIN
      IF CustEntryApplID <> '' THEN BEGIN
        AppliedCustLedgEntry.SETCURRENTKEY("Customer No.",Open,Positive);
        AppliedCustLedgEntry.SETRANGE("Customer No.",CustledgEntry."Customer No.");
        AppliedCustLedgEntry.SETRANGE(Open,TRUE);
        AppliedCustLedgEntry.SETRANGE("Applies-to ID",CustEntryApplID);
        IF CustledgEntry."Document Type" = CustledgEntry."Document Type"::Payment THEN
          AppliedCustLedgEntry.SETRANGE("Document Type",AppliedCustLedgEntry."Document Type"::Invoice);
        IF CustledgEntry."Document Type" = CustledgEntry."Document Type"::Refund THEN
          AppliedCustLedgEntry.SETRANGE("Document Type",AppliedCustLedgEntry."Document Type"::"Credit Memo");

        AppliedCustLedgEntry.LOCKTABLE;

        IF AppliedCustLedgEntry.FINDLAST THEN BEGIN
          AppliedCustLedgEntry."Accepted Payment Tolerance" := 0;
          AppliedCustLedgEntry."Accepted Pmt. Disc. Tolerance" := FALSE;
          AppliedCustLedgEntry.MODIFY;
          COMMIT;
        END;
      END;
    END;

    LOCAL PROCEDURE DelVendPmtTolAcc2@23(VendLedgEntry@1001 : Record 25;VendEntryApplID@1000 : Code[50]);
    VAR
      AppliedVendLedgEntry@1002 : Record 25;
    BEGIN
      IF VendEntryApplID <> '' THEN BEGIN
        AppliedVendLedgEntry.SETCURRENTKEY("Vendor No.",Open,Positive);
        AppliedVendLedgEntry.SETRANGE("Vendor No.",VendLedgEntry."Vendor No.");
        AppliedVendLedgEntry.SETRANGE(Open,TRUE);
        AppliedVendLedgEntry.SETRANGE("Applies-to ID",VendEntryApplID);
        IF VendLedgEntry."Document Type" = VendLedgEntry."Document Type"::Payment THEN
          AppliedVendLedgEntry.SETRANGE("Document Type",AppliedVendLedgEntry."Document Type"::Invoice);
        IF VendLedgEntry."Document Type" = VendLedgEntry."Document Type"::Refund THEN
          AppliedVendLedgEntry.SETRANGE("Document Type",AppliedVendLedgEntry."Document Type"::"Credit Memo");

        AppliedVendLedgEntry.LOCKTABLE;

        IF AppliedVendLedgEntry.FINDLAST THEN BEGIN
          AppliedVendLedgEntry."Accepted Payment Tolerance" := 0;
          AppliedVendLedgEntry."Accepted Pmt. Disc. Tolerance" := FALSE;
          AppliedVendLedgEntry.MODIFY;
          COMMIT;
        END;
      END;
    END;

    LOCAL PROCEDURE GetCustApplicationRoundingPrecisionForAppliesToID@24(VAR AppliedCustLedgEntry@1001 : Record 21;VAR ApplnRoundingPrecision@1004 : Decimal;VAR AmountRoundingPrecision@1003 : Decimal;VAR ApplnInMultiCurrency@1002 : Boolean;ApplnCurrencyCode@1000 : Code[20]);
    BEGIN
      AppliedCustLedgEntry.SETFILTER("Currency Code",'<>%1',ApplnCurrencyCode);
      ApplnInMultiCurrency := NOT AppliedCustLedgEntry.ISEMPTY;
      AppliedCustLedgEntry.SETRANGE("Currency Code");

      GetAmountRoundingPrecision(ApplnRoundingPrecision,AmountRoundingPrecision,ApplnInMultiCurrency,ApplnCurrencyCode);
    END;

    LOCAL PROCEDURE GetVendApplicationRoundingPrecisionForAppliesToID@28(VAR AppliedVendLedgEntry@1001 : Record 25;VAR ApplnRoundingPrecision@1004 : Decimal;VAR AmountRoundingPrecision@1003 : Decimal;VAR ApplnInMultiCurrency@1002 : Boolean;ApplnCurrencyCode@1000 : Code[20]);
    BEGIN
      AppliedVendLedgEntry.SETFILTER("Currency Code",'<>%1',ApplnCurrencyCode);
      ApplnInMultiCurrency := NOT AppliedVendLedgEntry.ISEMPTY;
      AppliedVendLedgEntry.SETRANGE("Currency Code");

      GetAmountRoundingPrecision(ApplnRoundingPrecision,AmountRoundingPrecision,ApplnInMultiCurrency,ApplnCurrencyCode);
    END;

    LOCAL PROCEDURE GetApplicationRoundingPrecisionForAppliesToDoc@31(AppliedEntryCurrencyCode@1001 : Code[10];VAR ApplnRoundingPrecision@1004 : Decimal;VAR AmountRoundingPrecision@1003 : Decimal;ApplnCurrencyCode@1000 : Code[20]);
    VAR
      Currency@1002 : Record 4;
    BEGIN
      IF ApplnCurrencyCode = '' THEN BEGIN
        Currency.INIT;
        Currency.Code := '';
        Currency.InitRoundingPrecision;
        IF AppliedEntryCurrencyCode = '' THEN
          ApplnRoundingPrecision := 0;
      END ELSE BEGIN
        IF ApplnCurrencyCode <> AppliedEntryCurrencyCode THEN BEGIN
          Currency.GET(ApplnCurrencyCode);
          ApplnRoundingPrecision := Currency."Appln. Rounding Precision";
        END ELSE
          ApplnRoundingPrecision := 0;
      END;
      AmountRoundingPrecision := Currency."Amount Rounding Precision";
    END;

    LOCAL PROCEDURE UpdateCustAmountsForApplication@25(VAR AppliedCustLedgEntry@1008 : Record 21;VAR CustLedgEntry@1009 : Record 21;VAR TempAppliedCustLedgEntry@1000 : TEMPORARY Record 21);
    BEGIN
      AppliedCustLedgEntry.CALCFIELDS("Remaining Amount");
      TempAppliedCustLedgEntry := AppliedCustLedgEntry;
      IF CustLedgEntry."Currency Code" <> AppliedCustLedgEntry."Currency Code" THEN BEGIN
        AppliedCustLedgEntry."Remaining Amount" :=
          CurrExchRate.ExchangeAmount(
            AppliedCustLedgEntry."Remaining Amount",AppliedCustLedgEntry."Currency Code",
            CustLedgEntry."Currency Code",CustLedgEntry."Posting Date");
        AppliedCustLedgEntry."Remaining Pmt. Disc. Possible" :=
          CurrExchRate.ExchangeAmount(
            AppliedCustLedgEntry."Remaining Pmt. Disc. Possible",
            AppliedCustLedgEntry."Currency Code",
            CustLedgEntry."Currency Code",CustLedgEntry."Posting Date");
        AppliedCustLedgEntry."Max. Payment Tolerance" :=
          CurrExchRate.ExchangeAmount(
            AppliedCustLedgEntry."Max. Payment Tolerance",
            AppliedCustLedgEntry."Currency Code",
            CustLedgEntry."Currency Code",CustLedgEntry."Posting Date");
        AppliedCustLedgEntry."Amount to Apply" :=
          CurrExchRate.ExchangeAmount(
            AppliedCustLedgEntry."Amount to Apply",
            AppliedCustLedgEntry."Currency Code",
            CustLedgEntry."Currency Code",CustLedgEntry."Posting Date");
      END;
    END;

    LOCAL PROCEDURE UpdateVendAmountsForApplication@32(VAR AppliedVendLedgEntry@1008 : Record 25;VAR VendLedgEntry@1009 : Record 25;VAR TempAppliedVendLedgEntry@1000 : TEMPORARY Record 25);
    BEGIN
      AppliedVendLedgEntry.CALCFIELDS("Remaining Amount");
      TempAppliedVendLedgEntry := AppliedVendLedgEntry;
      IF VendLedgEntry."Currency Code" <> AppliedVendLedgEntry."Currency Code" THEN BEGIN
        AppliedVendLedgEntry."Remaining Amount" :=
          CurrExchRate.ExchangeAmount(
            AppliedVendLedgEntry."Remaining Amount",AppliedVendLedgEntry."Currency Code",
            VendLedgEntry."Currency Code",VendLedgEntry."Posting Date");
        AppliedVendLedgEntry."Remaining Pmt. Disc. Possible" :=
          CurrExchRate.ExchangeAmount(
            AppliedVendLedgEntry."Remaining Pmt. Disc. Possible",
            AppliedVendLedgEntry."Currency Code",
            VendLedgEntry."Currency Code",VendLedgEntry."Posting Date");
        AppliedVendLedgEntry."Max. Payment Tolerance" :=
          CurrExchRate.ExchangeAmount(
            AppliedVendLedgEntry."Max. Payment Tolerance",
            AppliedVendLedgEntry."Currency Code",
            VendLedgEntry."Currency Code",VendLedgEntry."Posting Date");
        AppliedVendLedgEntry."Amount to Apply" :=
          CurrExchRate.ExchangeAmount(
            AppliedVendLedgEntry."Amount to Apply",
            AppliedVendLedgEntry."Currency Code",
            VendLedgEntry."Currency Code",VendLedgEntry."Posting Date");
      END;
    END;

    LOCAL PROCEDURE GetCustPositiveFilter@29(DocumentType@1002 : ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';TempAmount@1000 : Decimal) PositiveFilter : Boolean;
    BEGIN
      PositiveFilter := TempAmount <= 0;
      IF ((TempAmount > 0) AND (DocumentType = DocumentType::Refund) OR (DocumentType = DocumentType::Invoice) OR
          (DocumentType = DocumentType::"Credit Memo"))
      THEN
        PositiveFilter := TRUE;
      EXIT(PositiveFilter);
    END;

    LOCAL PROCEDURE GetVendPositiveFilter@43(DocumentType@1002 : ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';TempAmount@1000 : Decimal) PositiveFilter : Boolean;
    BEGIN
      PositiveFilter := TempAmount >= 0;
      IF ((TempAmount < 0) AND (DocumentType = DocumentType::Refund) OR (DocumentType = DocumentType::Invoice) OR
          (DocumentType = DocumentType::"Credit Memo"))
      THEN
        PositiveFilter := TRUE;
      EXIT(PositiveFilter);
    END;

    LOCAL PROCEDURE CheckCustPaymentAmountsForAppliesToID@26(CustLedgEntry@1000 : Record 21;VAR AppliedCustLedgEntry@1001 : Record 21;VAR TempAppliedCustLedgEntry@1007 : TEMPORARY Record 21;VAR MaxPmtTolAmount@1002 : Decimal;VAR AvailableAmount@1003 : Decimal;VAR TempAmount@1004 : Decimal;ApplnRoundingPrecision@1005 : Decimal);
    BEGIN
      // Check Payment Tolerance
      IF CheckPmtTolCust(CustLedgEntry."Document Type",AppliedCustLedgEntry) THEN
        MaxPmtTolAmount := MaxPmtTolAmount + AppliedCustLedgEntry."Max. Payment Tolerance";

      // Check Payment Discount
      IF CheckCalcPmtDiscCust(CustLedgEntry,AppliedCustLedgEntry,0,FALSE,FALSE) THEN
        AppliedCustLedgEntry."Remaining Amount" :=
          AppliedCustLedgEntry."Remaining Amount" - AppliedCustLedgEntry."Remaining Pmt. Disc. Possible";

      // Check Payment Discount Tolerance
      IF AppliedCustLedgEntry."Amount to Apply" = AppliedCustLedgEntry."Remaining Amount" THEN
        AvailableAmount := TempAmount
      ELSE
        AvailableAmount := -AppliedCustLedgEntry."Amount to Apply";
      IF CheckPmtDiscTolCust(
           CustLedgEntry."Posting Date",CustLedgEntry."Document Type",AvailableAmount,AppliedCustLedgEntry,ApplnRoundingPrecision,
           MaxPmtTolAmount)
      THEN BEGIN
        AppliedCustLedgEntry."Remaining Amount" :=
          AppliedCustLedgEntry."Remaining Amount" - AppliedCustLedgEntry."Remaining Pmt. Disc. Possible";
        AppliedCustLedgEntry."Accepted Pmt. Disc. Tolerance" := TRUE;
        IF CustLedgEntry."Currency Code" <> AppliedCustLedgEntry."Currency Code" THEN BEGIN
          AppliedCustLedgEntry."Remaining Pmt. Disc. Possible" :=
            TempAppliedCustLedgEntry."Remaining Pmt. Disc. Possible";
          AppliedCustLedgEntry."Max. Payment Tolerance" :=
            TempAppliedCustLedgEntry."Max. Payment Tolerance";
        END;
        AppliedCustLedgEntry.MODIFY;
      END;
      TempAmount :=
        TempAmount +
        ABSMinTol(
          AppliedCustLedgEntry."Remaining Amount",
          AppliedCustLedgEntry."Amount to Apply",
          MaxPmtTolAmount);
    END;

    LOCAL PROCEDURE CheckVendPaymentAmountsForAppliesToID@30(VendLedgEntry@1000 : Record 25;VAR AppliedVendLedgEntry@1001 : Record 25;VAR TempAppliedVendLedgEntry@1007 : TEMPORARY Record 25;VAR MaxPmtTolAmount@1002 : Decimal;VAR AvailableAmount@1003 : Decimal;VAR TempAmount@1004 : Decimal;ApplnRoundingPrecision@1005 : Decimal);
    BEGIN
      // Check Payment Tolerance
      IF CheckPmtTolVend(VendLedgEntry."Document Type",AppliedVendLedgEntry) THEN
        MaxPmtTolAmount := MaxPmtTolAmount + AppliedVendLedgEntry."Max. Payment Tolerance";

      // Check Payment Discount
      IF CheckCalcPmtDiscVend(VendLedgEntry,AppliedVendLedgEntry,0,FALSE,FALSE) THEN
        AppliedVendLedgEntry."Remaining Amount" :=
          AppliedVendLedgEntry."Remaining Amount" - AppliedVendLedgEntry."Remaining Pmt. Disc. Possible";

      // Check Payment Discount Tolerance
      IF AppliedVendLedgEntry."Amount to Apply" = AppliedVendLedgEntry."Remaining Amount" THEN
        AvailableAmount := TempAmount
      ELSE
        AvailableAmount := -AppliedVendLedgEntry."Amount to Apply";
      IF CheckPmtDiscTolVend(VendLedgEntry."Posting Date",VendLedgEntry."Document Type",AvailableAmount,
           AppliedVendLedgEntry,ApplnRoundingPrecision,MaxPmtTolAmount)
      THEN BEGIN
        AppliedVendLedgEntry."Remaining Amount" :=
          AppliedVendLedgEntry."Remaining Amount" - AppliedVendLedgEntry."Remaining Pmt. Disc. Possible";
        AppliedVendLedgEntry."Accepted Pmt. Disc. Tolerance" := TRUE;
        IF VendLedgEntry."Currency Code" <> AppliedVendLedgEntry."Currency Code" THEN BEGIN
          AppliedVendLedgEntry."Remaining Pmt. Disc. Possible" :=
            TempAppliedVendLedgEntry."Remaining Pmt. Disc. Possible";
          AppliedVendLedgEntry."Max. Payment Tolerance" :=
            TempAppliedVendLedgEntry."Max. Payment Tolerance";
        END;
        AppliedVendLedgEntry.MODIFY;
      END;
      TempAmount :=
        TempAmount +
        ABSMinTol(
          AppliedVendLedgEntry."Remaining Amount",
          AppliedVendLedgEntry."Amount to Apply",
          MaxPmtTolAmount);
    END;

    LOCAL PROCEDURE CheckCustPaymentAmountsForAppliesToDoc@38(CustLedgEntry@1000 : Record 21;VAR AppliedCustLedgEntry@1001 : Record 21;VAR TempAppliedCustLedgEntry@1003 : TEMPORARY Record 21;VAR MaxPmtTolAmount@1002 : Decimal;ApplnRoundingPrecision@1005 : Decimal;VAR PmtDiscAmount@1008 : Decimal;ApplnCurrencyCode@1009 : Code[20]);
    BEGIN
      // Check Payment Tolerance
      IF CheckPmtTolCust(CustLedgEntry."Document Type",AppliedCustLedgEntry) AND
         CheckCustLedgAmt(CustLedgEntry,AppliedCustLedgEntry,AppliedCustLedgEntry."Max. Payment Tolerance",ApplnRoundingPrecision)
      THEN
        MaxPmtTolAmount := MaxPmtTolAmount + AppliedCustLedgEntry."Max. Payment Tolerance";

      // Check Payment Discount
      IF CheckCalcPmtDiscCust(CustLedgEntry,AppliedCustLedgEntry,0,FALSE,FALSE) AND
         CheckCustLedgAmt(CustLedgEntry,AppliedCustLedgEntry,MaxPmtTolAmount,ApplnRoundingPrecision)
      THEN
        PmtDiscAmount := PmtDiscAmount + AppliedCustLedgEntry."Remaining Pmt. Disc. Possible";

      // Check Payment Discount Tolerance
      IF CheckPmtDiscTolCust(
           CustLedgEntry."Posting Date",CustLedgEntry."Document Type",CustLedgEntry.Amount,AppliedCustLedgEntry,
           ApplnRoundingPrecision,MaxPmtTolAmount) AND CheckCustLedgAmt(
           CustLedgEntry,AppliedCustLedgEntry,MaxPmtTolAmount,ApplnRoundingPrecision)
      THEN BEGIN
        PmtDiscAmount := PmtDiscAmount + AppliedCustLedgEntry."Remaining Pmt. Disc. Possible";
        AppliedCustLedgEntry."Accepted Pmt. Disc. Tolerance" := TRUE;
        IF AppliedCustLedgEntry."Currency Code" <> ApplnCurrencyCode THEN BEGIN
          AppliedCustLedgEntry."Max. Payment Tolerance" :=
            TempAppliedCustLedgEntry."Max. Payment Tolerance";
          AppliedCustLedgEntry."Remaining Pmt. Disc. Possible" :=
            TempAppliedCustLedgEntry."Remaining Pmt. Disc. Possible";
        END;
        AppliedCustLedgEntry.MODIFY;
        COMMIT;
      END;
    END;

    LOCAL PROCEDURE CheckVendPaymentAmountsForAppliesToDoc@35(VendLedgEntry@1000 : Record 25;VAR AppliedVendLedgEntry@1001 : Record 25;VAR TempAppliedVendLedgEntry@1003 : TEMPORARY Record 25;VAR MaxPmtTolAmount@1002 : Decimal;ApplnRoundingPrecision@1005 : Decimal;VAR PmtDiscAmount@1008 : Decimal);
    BEGIN
      // Check Payment Tolerance
      IF CheckPmtTolVend(VendLedgEntry."Document Type",AppliedVendLedgEntry) AND
         CheckVendLedgAmt(VendLedgEntry,AppliedVendLedgEntry,AppliedVendLedgEntry."Max. Payment Tolerance",ApplnRoundingPrecision)
      THEN
        MaxPmtTolAmount := MaxPmtTolAmount + AppliedVendLedgEntry."Max. Payment Tolerance";

      // Check Payment Discount
      IF CheckCalcPmtDiscVend(
           VendLedgEntry,AppliedVendLedgEntry,0,FALSE,FALSE) AND
         CheckVendLedgAmt(VendLedgEntry,AppliedVendLedgEntry,MaxPmtTolAmount,ApplnRoundingPrecision)
      THEN
        PmtDiscAmount := PmtDiscAmount + AppliedVendLedgEntry."Remaining Pmt. Disc. Possible";

      // Check Payment Discount Tolerance
      IF CheckPmtDiscTolVend(
           VendLedgEntry."Posting Date",VendLedgEntry."Document Type",VendLedgEntry.Amount,
           AppliedVendLedgEntry,ApplnRoundingPrecision,MaxPmtTolAmount) AND
         CheckVendLedgAmt(VendLedgEntry,AppliedVendLedgEntry,MaxPmtTolAmount,ApplnRoundingPrecision)
      THEN BEGIN
        PmtDiscAmount := PmtDiscAmount + AppliedVendLedgEntry."Remaining Pmt. Disc. Possible";
        AppliedVendLedgEntry."Accepted Pmt. Disc. Tolerance" := TRUE;
        IF VendLedgEntry."Currency Code" <> AppliedVendLedgEntry."Currency Code" THEN BEGIN
          AppliedVendLedgEntry."Remaining Pmt. Disc. Possible" := TempAppliedVendLedgEntry."Remaining Pmt. Disc. Possible";
          AppliedVendLedgEntry."Max. Payment Tolerance" := TempAppliedVendLedgEntry."Max. Payment Tolerance";
        END;
        AppliedVendLedgEntry.MODIFY;
        COMMIT;
      END;
    END;

    LOCAL PROCEDURE CheckCustLedgAmt@41(CustLedgEntry@1001 : Record 21;AppliedCustLedgEntry@1002 : Record 21;MaxPmtTolAmount@1000 : Decimal;ApplnRoundingPrecision@1003 : Decimal) : Boolean;
    BEGIN
      EXIT((ABS(CustLedgEntry.Amount) + ApplnRoundingPrecision >= ABS(AppliedCustLedgEntry."Remaining Amount" -
              AppliedCustLedgEntry."Remaining Pmt. Disc. Possible" - MaxPmtTolAmount)));
    END;

    LOCAL PROCEDURE CheckVendLedgAmt@42(VendLedgEntry@1004 : Record 25;AppliedVendLedgEntry@1003 : Record 25;MaxPmtTolAmount@1002 : Decimal;ApplnRoundingPrecision@1001 : Decimal) : Boolean;
    BEGIN
      EXIT((ABS(VendLedgEntry.Amount) + ApplnRoundingPrecision >= ABS(AppliedVendLedgEntry."Remaining Amount" -
              AppliedVendLedgEntry."Remaining Pmt. Disc. Possible" - MaxPmtTolAmount)));
    END;

    LOCAL PROCEDURE GetAmountRoundingPrecision@39(VAR ApplnRoundingPrecision@1003 : Decimal;VAR AmountRoundingPrecision@1002 : Decimal;ApplnInMultiCurrency@1001 : Boolean;ApplnCurrencyCode@1004 : Code[20]);
    VAR
      Currency@1000 : Record 4;
    BEGIN
      IF ApplnCurrencyCode = '' THEN BEGIN
        Currency.INIT;
        Currency.Code := '';
        Currency.InitRoundingPrecision;
      END ELSE BEGIN
        IF ApplnInMultiCurrency THEN
          Currency.GET(ApplnCurrencyCode)
        ELSE
          Currency.INIT;
      END;
      ApplnRoundingPrecision := Currency."Appln. Rounding Precision";
      AmountRoundingPrecision := Currency."Amount Rounding Precision";
    END;

    [External]
    PROCEDURE CalcRemainingPmtDisc@59(VAR NewCVLedgEntryBuf@1000 : Record 382;VAR OldCVLedgEntryBuf@1001 : Record 382;VAR OldCVLedgEntryBuf2@1002 : Record 382;GLSetup@1003 : Record 98);
    VAR
      Handled@1004 : Boolean;
    BEGIN
      OnBeforeCalcRemainingPmtDisc(NewCVLedgEntryBuf,OldCVLedgEntryBuf,OldCVLedgEntryBuf2,GLSetup,Handled);
      IF Handled THEN
        EXIT;

      IF ABS(NewCVLedgEntryBuf."Max. Payment Tolerance") > ABS(NewCVLedgEntryBuf."Remaining Amount") THEN
        NewCVLedgEntryBuf."Max. Payment Tolerance" := NewCVLedgEntryBuf."Remaining Amount";
      IF (((NewCVLedgEntryBuf."Document Type" IN [NewCVLedgEntryBuf."Document Type"::"Credit Memo",
                                                  NewCVLedgEntryBuf."Document Type"::Invoice]) AND
           (OldCVLedgEntryBuf."Document Type" IN [OldCVLedgEntryBuf."Document Type"::Invoice,
                                                  OldCVLedgEntryBuf."Document Type"::"Credit Memo"])) AND
          ((OldCVLedgEntryBuf."Remaining Pmt. Disc. Possible" <> 0) AND
           (NewCVLedgEntryBuf."Remaining Pmt. Disc. Possible" <> 0)) OR
          ((OldCVLedgEntryBuf."Document Type" = OldCVLedgEntryBuf."Document Type"::"Credit Memo") AND
           (OldCVLedgEntryBuf."Remaining Pmt. Disc. Possible" <> 0) AND
           (NewCVLedgEntryBuf."Document Type" <> NewCVLedgEntryBuf."Document Type"::Refund)))
      THEN BEGIN
        IF OldCVLedgEntryBuf."Remaining Amount" <> 0 THEN
          OldCVLedgEntryBuf2."Remaining Pmt. Disc. Possible" :=
            ROUND(OldCVLedgEntryBuf."Remaining Pmt. Disc. Possible" -
              (OldCVLedgEntryBuf."Remaining Pmt. Disc. Possible" *
               (OldCVLedgEntryBuf2."Remaining Amount" - OldCVLedgEntryBuf."Remaining Amount") /
               OldCVLedgEntryBuf2."Remaining Amount"),GLSetup."Amount Rounding Precision");
        NewCVLedgEntryBuf."Remaining Pmt. Disc. Possible" :=
          ROUND(NewCVLedgEntryBuf."Remaining Pmt. Disc. Possible" +
            (NewCVLedgEntryBuf."Remaining Pmt. Disc. Possible" *
             (OldCVLedgEntryBuf2."Remaining Amount" - OldCVLedgEntryBuf."Remaining Amount") /
             (NewCVLedgEntryBuf."Remaining Amount" -
              OldCVLedgEntryBuf2."Remaining Amount" + OldCVLedgEntryBuf."Remaining Amount")),
            GLSetup."Amount Rounding Precision");

        IF NewCVLedgEntryBuf."Currency Code" = OldCVLedgEntryBuf2."Currency Code" THEN
          OldCVLedgEntryBuf."Remaining Pmt. Disc. Possible" := OldCVLedgEntryBuf2."Remaining Pmt. Disc. Possible"
        ELSE
          OldCVLedgEntryBuf."Remaining Pmt. Disc. Possible" := OldCVLedgEntryBuf2."Remaining Pmt. Disc. Possible";
      END;

      IF OldCVLedgEntryBuf."Document Type" IN [OldCVLedgEntryBuf."Document Type"::Invoice,
                                               OldCVLedgEntryBuf."Document Type"::"Credit Memo"]
      THEN
        IF ABS(OldCVLedgEntryBuf."Remaining Amount") < ABS(OldCVLedgEntryBuf."Max. Payment Tolerance") THEN
          OldCVLedgEntryBuf."Max. Payment Tolerance" := OldCVLedgEntryBuf."Remaining Amount";

      IF NOT NewCVLedgEntryBuf.Open THEN BEGIN
        NewCVLedgEntryBuf."Remaining Pmt. Disc. Possible" := 0;
        NewCVLedgEntryBuf."Max. Payment Tolerance" := 0;
      END;

      IF NOT OldCVLedgEntryBuf.Open THEN BEGIN
        OldCVLedgEntryBuf."Remaining Pmt. Disc. Possible" := 0;
        OldCVLedgEntryBuf."Max. Payment Tolerance" := 0;
      END;
    END;

    [External]
    PROCEDURE CalcMaxPmtTolerance@40(DocumentType@1004 : ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';CurrencyCode@1000 : Code[10];Amount@1001 : Decimal;AmountLCY@1002 : Decimal;Sign@1005 : Decimal;VAR MaxPaymentTolerance@1003 : Decimal);
    VAR
      Currency@1010 : Record 4;
      GLSetup@1011 : Record 98;
      MaxPaymentToleranceAmount@1006 : Decimal;
      PaymentTolerancePct@1007 : Decimal;
      PaymentAmount@1009 : Decimal;
      AmountRoundingPrecision@1008 : Decimal;
    BEGIN
      IF CurrencyCode = '' THEN BEGIN
        GLSetup.GET;
        MaxPaymentToleranceAmount := GLSetup."Max. Payment Tolerance Amount";
        PaymentTolerancePct := GLSetup."Payment Tolerance %";
        AmountRoundingPrecision := GLSetup."Amount Rounding Precision";
        PaymentAmount := AmountLCY;
      END ELSE BEGIN
        Currency.GET(CurrencyCode);
        MaxPaymentToleranceAmount := Currency."Max. Payment Tolerance Amount";
        PaymentTolerancePct := Currency."Payment Tolerance %";
        AmountRoundingPrecision := Currency."Amount Rounding Precision";
        PaymentAmount := Amount;
      END;

      IF (MaxPaymentToleranceAmount <
          ABS(PaymentTolerancePct / 100 * PaymentAmount)) OR (PaymentTolerancePct = 0)
      THEN BEGIN
        IF (MaxPaymentToleranceAmount = 0) AND (PaymentTolerancePct > 0) THEN
          MaxPaymentTolerance :=
            ROUND(PaymentTolerancePct * PaymentAmount / 100,AmountRoundingPrecision)
        ELSE
          IF DocumentType = DocumentType::"Credit Memo" THEN
            MaxPaymentTolerance := -MaxPaymentToleranceAmount * Sign
          ELSE
            MaxPaymentTolerance := MaxPaymentToleranceAmount * Sign
      END ELSE
        MaxPaymentTolerance :=
          ROUND(PaymentTolerancePct * PaymentAmount / 100,AmountRoundingPrecision);

      IF ABS(MaxPaymentTolerance) > ABS(Amount) THEN
        MaxPaymentTolerance := Amount;
    END;

    [External]
    PROCEDURE CheckCalcPmtDisc@37(VAR NewCVLedgEntryBuf@1000 : Record 382;VAR OldCVLedgEntryBuf2@1002 : Record 382;ApplnRoundingPrecision@1003 : Decimal;CheckFilter@1001 : Boolean;CheckAmount@1004 : Boolean) : Boolean;
    VAR
      Handled@1005 : Boolean;
      Result@1006 : Boolean;
    BEGIN
      OnBeforeCheckCalcPmtDisc(NewCVLedgEntryBuf,OldCVLedgEntryBuf2,ApplnRoundingPrecision,CheckFilter,CheckAmount,Handled,Result);
      IF Handled THEN
        EXIT(Result);

      IF ((NewCVLedgEntryBuf."Document Type" IN [NewCVLedgEntryBuf."Document Type"::Refund,
                                                 NewCVLedgEntryBuf."Document Type"::Payment]) AND
          (((OldCVLedgEntryBuf2."Document Type" = OldCVLedgEntryBuf2."Document Type"::"Credit Memo") AND
            (OldCVLedgEntryBuf2."Remaining Pmt. Disc. Possible" <> 0) AND
            (NewCVLedgEntryBuf."Posting Date" <= OldCVLedgEntryBuf2."Pmt. Discount Date")) OR
           ((OldCVLedgEntryBuf2."Document Type" = OldCVLedgEntryBuf2."Document Type"::Invoice) AND
            (OldCVLedgEntryBuf2."Remaining Pmt. Disc. Possible" <> 0) AND
            (NewCVLedgEntryBuf."Posting Date" <= OldCVLedgEntryBuf2."Pmt. Discount Date"))))
      THEN BEGIN
        IF CheckFilter THEN BEGIN
          IF CheckAmount THEN BEGIN
            IF (OldCVLedgEntryBuf2.GETFILTER(Positive) <> '') OR
               (ABS(NewCVLedgEntryBuf."Remaining Amount") + ApplnRoundingPrecision >=
                ABS(OldCVLedgEntryBuf2."Remaining Amount" - OldCVLedgEntryBuf2."Remaining Pmt. Disc. Possible"))
            THEN
              EXIT(TRUE);

            EXIT(FALSE);
          END;

          EXIT(OldCVLedgEntryBuf2.GETFILTER(Positive) <> '');
        END;
        IF CheckAmount THEN
          EXIT((ABS(NewCVLedgEntryBuf."Remaining Amount") + ApplnRoundingPrecision >=
                ABS(OldCVLedgEntryBuf2."Remaining Amount" - OldCVLedgEntryBuf2."Remaining Pmt. Disc. Possible")));

        EXIT(TRUE);
      END;
      EXIT(FALSE);
    END;

    [External]
    PROCEDURE CheckCalcPmtDiscCVCust@34(VAR NewCVLedgEntryBuf@1000 : Record 382;VAR OldCustLedgEntry2@1002 : Record 21;ApplnRoundingPrecision@1003 : Decimal;CheckFilter@1005 : Boolean;CheckAmount@1001 : Boolean) : Boolean;
    VAR
      OldCVLedgEntryBuf2@1004 : Record 382;
    BEGIN
      OldCustLedgEntry2.COPYFILTER(Positive,OldCVLedgEntryBuf2.Positive);
      OldCVLedgEntryBuf2.CopyFromCustLedgEntry(OldCustLedgEntry2);
      EXIT(
        CheckCalcPmtDisc(
          NewCVLedgEntryBuf,OldCVLedgEntryBuf2,ApplnRoundingPrecision,CheckFilter,CheckAmount));
    END;

    [External]
    PROCEDURE CheckCalcPmtDiscCust@33(VAR NewCustLedgEntry@1000 : Record 21;VAR OldCustLedgEntry2@1002 : Record 21;ApplnRoundingPrecision@1003 : Decimal;CheckFilter@1005 : Boolean;CheckAmount@1006 : Boolean) : Boolean;
    VAR
      NewCVLedgEntryBuf@1001 : Record 382;
      OldCVLedgEntryBuf2@1004 : Record 382;
    BEGIN
      NewCVLedgEntryBuf.CopyFromCustLedgEntry(NewCustLedgEntry);
      OldCustLedgEntry2.COPYFILTER(Positive,OldCVLedgEntryBuf2.Positive);
      OldCVLedgEntryBuf2.CopyFromCustLedgEntry(OldCustLedgEntry2);
      EXIT(
        CheckCalcPmtDisc(
          NewCVLedgEntryBuf,OldCVLedgEntryBuf2,ApplnRoundingPrecision,CheckFilter,CheckAmount));
    END;

    [External]
    PROCEDURE CheckCalcPmtDiscGenJnlCust@36(GenJnlLine@1000 : Record 81;OldCustLedgEntry2@1002 : Record 21;ApplnRoundingPrecision@1004 : Decimal;CheckAmount@1005 : Boolean) : Boolean;
    VAR
      NewCVLedgEntryBuf@1001 : Record 382;
      OldCVLedgEntryBuf2@1003 : Record 382;
    BEGIN
      NewCVLedgEntryBuf."Document Type" := GenJnlLine."Document Type";
      NewCVLedgEntryBuf."Posting Date" := GenJnlLine."Posting Date";
      NewCVLedgEntryBuf."Remaining Amount" := GenJnlLine.Amount;
      OldCVLedgEntryBuf2.CopyFromCustLedgEntry(OldCustLedgEntry2);
      EXIT(
        CheckCalcPmtDisc(
          NewCVLedgEntryBuf,OldCVLedgEntryBuf2,ApplnRoundingPrecision,FALSE,CheckAmount));
    END;

    [External]
    PROCEDURE CheckCalcPmtDiscCVVend@57(VAR NewCVLedgEntryBuf@1000 : Record 382;VAR OldVendLedgEntry2@1002 : Record 25;ApplnRoundingPrecision@1003 : Decimal;CheckFilter@1005 : Boolean;CheckAmount@1001 : Boolean) : Boolean;
    VAR
      OldCVLedgEntryBuf2@1004 : Record 382;
    BEGIN
      OldVendLedgEntry2.COPYFILTER(Positive,OldCVLedgEntryBuf2.Positive);
      OldCVLedgEntryBuf2.CopyFromVendLedgEntry(OldVendLedgEntry2);
      EXIT(
        CheckCalcPmtDisc(
          NewCVLedgEntryBuf,OldCVLedgEntryBuf2,ApplnRoundingPrecision,CheckFilter,CheckAmount));
    END;

    [External]
    PROCEDURE CheckCalcPmtDiscVend@56(VAR NewVendLedgEntry@1000 : Record 25;VAR OldVendLedgEntry2@1002 : Record 25;ApplnRoundingPrecision@1003 : Decimal;CheckFilter@1006 : Boolean;CheckAmount@1005 : Boolean) : Boolean;
    VAR
      NewCVLedgEntryBuf@1001 : Record 382;
      OldCVLedgEntryBuf2@1004 : Record 382;
    BEGIN
      NewCVLedgEntryBuf.CopyFromVendLedgEntry(NewVendLedgEntry);
      OldVendLedgEntry2.COPYFILTER(Positive,OldCVLedgEntryBuf2.Positive);
      OldCVLedgEntryBuf2.CopyFromVendLedgEntry(OldVendLedgEntry2);
      EXIT(
        CheckCalcPmtDisc(
          NewCVLedgEntryBuf,OldCVLedgEntryBuf2,ApplnRoundingPrecision,CheckFilter,CheckAmount));
    END;

    [External]
    PROCEDURE CheckCalcPmtDiscGenJnlVend@58(GenJnlLine@1000 : Record 81;OldVendLedgEntry2@1002 : Record 25;ApplnRoundingPrecision@1005 : Decimal;CheckAmount@1004 : Boolean) : Boolean;
    VAR
      NewCVLedgEntryBuf@1001 : Record 382;
      OldCVLedgEntryBuf2@1003 : Record 382;
    BEGIN
      NewCVLedgEntryBuf."Document Type" := GenJnlLine."Document Type";
      NewCVLedgEntryBuf."Posting Date" := GenJnlLine."Posting Date";
      NewCVLedgEntryBuf."Remaining Amount" := GenJnlLine.Amount;
      OldCVLedgEntryBuf2.CopyFromVendLedgEntry(OldVendLedgEntry2);
      EXIT(
        CheckCalcPmtDisc(
          NewCVLedgEntryBuf,OldCVLedgEntryBuf2,ApplnRoundingPrecision,FALSE,CheckAmount));
    END;

    LOCAL PROCEDURE ManagePaymentDiscToleranceWarningCustomer@48(VAR NewCustLedgEntry@1011 : Record 21;GenJnlLineApplID@1009 : Code[50];VAR AppliedAmount@1008 : Decimal;VAR AmountToApply@1007 : Decimal;AppliesToDocNo@1005 : Code[20]) : Boolean;
    VAR
      AppliedCustLedgEntry@1001 : Record 21;
      RemainingAmountTest@1000 : Boolean;
    BEGIN
      WITH AppliedCustLedgEntry DO BEGIN
        SETCURRENTKEY("Customer No.","Applies-to ID",Open,Positive);
        SETRANGE("Customer No.",NewCustLedgEntry."Customer No.");
        IF AppliesToDocNo <> '' THEN
          SETRANGE("Document No.",AppliesToDocNo)
        ELSE
          SETRANGE("Applies-to ID",GenJnlLineApplID);
        SETRANGE(Open,TRUE);
        SETRANGE("Accepted Pmt. Disc. Tolerance",TRUE);
        IF FINDSET THEN
          REPEAT
            CALCFIELDS("Remaining Amount");
            IF CallPmtDiscTolWarning(
                 "Posting Date","Customer No.",
                 "Document No.","Currency Code",
                 "Remaining Amount",0,
                 "Remaining Pmt. Disc. Possible",RemainingAmountTest)
            THEN BEGIN
              IF RemainingAmountTest THEN BEGIN
                "Accepted Pmt. Disc. Tolerance" := FALSE;
                "Amount to Apply" := "Remaining Amount";
                MODIFY;
                COMMIT;
                IF NewCustLedgEntry."Currency Code" <> "Currency Code" THEN
                  "Remaining Pmt. Disc. Possible" :=
                    CurrExchRate.ExchangeAmount(
                      "Remaining Pmt. Disc. Possible",
                      "Currency Code",
                      NewCustLedgEntry."Currency Code",
                      NewCustLedgEntry."Posting Date");
                AppliedAmount := AppliedAmount + "Remaining Pmt. Disc. Possible";
                AmountToApply := AmountToApply + "Remaining Pmt. Disc. Possible";
              END
            END ELSE BEGIN
              DelCustPmtTolAcc(NewCustLedgEntry,GenJnlLineApplID);
              EXIT(FALSE);
            END;
          UNTIL NEXT = 0;
      END;

      EXIT(TRUE);
    END;

    LOCAL PROCEDURE ManagePaymentDiscToleranceWarningVendor@50(VAR NewVendLedgEntry@1010 : Record 25;GenJnlLineApplID@1009 : Code[50];VAR AppliedAmount@1008 : Decimal;VAR AmountToApply@1007 : Decimal;AppliesToDocNo@1005 : Code[20]) : Boolean;
    VAR
      AppliedVendLedgEntry@1001 : Record 25;
      RemainingAmountTest@1000 : Boolean;
    BEGIN
      WITH AppliedVendLedgEntry DO BEGIN
        SETCURRENTKEY("Vendor No.","Applies-to ID",Open,Positive);
        SETRANGE("Vendor No.",NewVendLedgEntry."Vendor No.");
        IF AppliesToDocNo <> '' THEN
          SETRANGE("Document No.",AppliesToDocNo)
        ELSE
          SETRANGE("Applies-to ID",GenJnlLineApplID);
        SETRANGE(Open,TRUE);
        SETRANGE("Accepted Pmt. Disc. Tolerance",TRUE);
        IF FINDSET THEN
          REPEAT
            CALCFIELDS("Remaining Amount");
            IF CallPmtDiscTolWarning(
                 "Posting Date","Vendor No.",
                 "Document No.","Currency Code",
                 "Remaining Amount",0,
                 "Remaining Pmt. Disc. Possible",RemainingAmountTest)
            THEN BEGIN
              IF RemainingAmountTest THEN BEGIN
                "Accepted Pmt. Disc. Tolerance" := FALSE;
                "Amount to Apply" := "Remaining Amount";
                MODIFY;
                COMMIT;
                IF NewVendLedgEntry."Currency Code" <> "Currency Code" THEN
                  "Remaining Pmt. Disc. Possible" :=
                    CurrExchRate.ExchangeAmount(
                      "Remaining Pmt. Disc. Possible",
                      "Currency Code",
                      NewVendLedgEntry."Currency Code",NewVendLedgEntry."Posting Date");
                AppliedAmount := AppliedAmount + "Remaining Pmt. Disc. Possible";
                AmountToApply := AmountToApply + "Remaining Pmt. Disc. Possible";
              END
            END ELSE BEGIN
              DelVendPmtTolAcc(NewVendLedgEntry,GenJnlLineApplID);
              EXIT(FALSE);
            END;
          UNTIL NEXT = 0;
      END;

      EXIT(TRUE);
    END;

    LOCAL PROCEDURE IsCustBlockPmtToleranceInGenJnlLine@52(VAR GenJnlLine@1000 : Record 81) : Boolean;
    BEGIN
      CheckAccountType(GenJnlLine,GenJnlLine."Account Type"::Customer);

      IF GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Customer THEN
        CODEUNIT.RUN(CODEUNIT::"Exchange Acc. G/L Journal Line",GenJnlLine);

      EXIT(IsCustBlockPmtTolerance(GenJnlLine."Account No."));
    END;

    LOCAL PROCEDURE IsVendBlockPmtToleranceInGenJnlLine@54(VAR GenJnlLine@1000 : Record 81) : Boolean;
    BEGIN
      CheckAccountType(GenJnlLine,GenJnlLine."Account Type"::Vendor);

      IF GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Vendor THEN
        CODEUNIT.RUN(CODEUNIT::"Exchange Acc. G/L Journal Line",GenJnlLine);

      EXIT(IsVendBlockPmtTolerance(GenJnlLine."Account No."));
    END;

    LOCAL PROCEDURE IsCustBlockPmtTolerance@61(AccountNo@1001 : Code[20]) : Boolean;
    VAR
      Customer@1000 : Record 18;
    BEGIN
      IF NOT Customer.GET(AccountNo) THEN
        EXIT(FALSE);
      IF Customer."Block Payment Tolerance" THEN
        EXIT(FALSE);
    END;

    LOCAL PROCEDURE IsVendBlockPmtTolerance@62(AccountNo@1001 : Code[20]) : Boolean;
    VAR
      Vendor@1000 : Record 23;
    BEGIN
      IF NOT Vendor.GET(AccountNo) THEN
        EXIT(FALSE);
      IF Vendor."Block Payment Tolerance" THEN
        EXIT(FALSE);
    END;

    LOCAL PROCEDURE CheckAccountType@68(GenJnlLine@1000 : Record 81;AccountType@1001 : Option);
    VAR
      DummyGenJnlLine@1002 : Record 81;
    BEGIN
      DummyGenJnlLine."Account Type" := AccountType;
      IF NOT (AccountType IN [GenJnlLine."Account Type",GenJnlLine."Bal. Account Type"]) THEN
        ERROR(AccTypeOrBalAccTypeIsIncorrectErr,DummyGenJnlLine."Account Type");
    END;

    LOCAL PROCEDURE GetAppliesToID@64(GenJnlLine@1000 : Record 81) : Code[50];
    BEGIN
      IF GenJnlLine."Applies-to Doc. No." = '' THEN
        IF GenJnlLine."Applies-to ID" <> '' THEN
          EXIT(GenJnlLine."Applies-to ID");
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeCalcRemainingPmtDisc@53(VAR NewCVLedgEntryBuf@1003 : Record 382;VAR OldCVLedgEntryBuf@1002 : Record 382;VAR OldCVLedgEntryBuf2@1001 : Record 382;GLSetup@1000 : Record 98;VAR Handled@1004 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeCheckCalcPmtDisc@63(NewCVLedgEntryBuf@1004 : Record 382;OldCVLedgEntryBuf2@1003 : Record 382;ApplnRoundingPrecision@1001 : Decimal;CheckFilter@1002 : Boolean;CheckAmount@1005 : Boolean;VAR Handled@1000 : Boolean;VAR Result@1006 : Boolean);
    BEGIN
    END;

    BEGIN
    END.
  }
}

