OBJECT Codeunit 370 Bank Acc. Reconciliation Post
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    TableNo=273;
    Permissions=TableData 271=rm,
                TableData 272=rm,
                TableData 275=ri,
                TableData 276=ri,
                TableData 1295=ri;
    OnRun=BEGIN
            Window.OPEN(
              '#1#################################\\' +
              Text000);
            Window.UPDATE(1,STRSUBSTNO('%1 %2',"Bank Account No.","Statement No."));

            InitPost(Rec);
            Post(Rec);
            FinalizePost(Rec);

            Window.CLOSE;

            COMMIT;
          END;

  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Linjer bogf�res            #2######;ENU=Posting lines              #2######';
      Text001@1001 : TextConst 'DAN=%1 svarer ikke til Total balance.;ENU=%1 is not equal to Total Balance.';
      Text002@1002 : TextConst 'DAN=Der er intet at bogf�re.;ENU=There is nothing to post.';
      Text003@1003 : TextConst 'DAN=Udligningen er forkert. Det samlede udlignede bel�b er %1, og skulle v�re %2.;ENU="The application is not correct. The total amount applied is %1; it should be %2."';
      Text004@1004 : TextConst 'DAN=Differencen er %1. Den skal v�re %2.;ENU=The total difference is %1. It must be %2.';
      BankAcc@1007 : Record 270;
      BankAccLedgEntry@1008 : Record 271;
      CheckLedgEntry@1009 : Record 272;
      GenJnlLine@1005 : Record 81;
      SourceCodeSetup@1011 : Record 242;
      GenJnlPostLine@1010 : Codeunit 12;
      Window@1018 : Dialog;
      SourceCode@1012 : Code[10];
      TotalAmount@1014 : Decimal;
      TotalAppliedAmount@1015 : Decimal;
      TotalDiff@1016 : Decimal;
      Lines@1017 : Integer;
      Difference@1006 : Decimal;
      ExcessiveAmtErr@1013 : TextConst '@@@=%1 a decimal number, %2 currency code;DAN=Du skal anvende det overskydende bel�b p� %1 %2 manuelt.;ENU=You must apply the excessive amount of %1 %2 manually.';
      PostPaymentsOnly@1019 : Boolean;
      NotFullyAppliedErr@1020 : TextConst '@@@=%1 - total applied amount, %2 - total transaction amount;DAN=�n eller flere betalinger er ikke anvendt helt.\\Summen af anvendte bel�b er %1. Den skal v�re %2.;ENU=One or more payments are not fully applied.\\The sum of applied amounts is %1. It must be %2.';
      LineNoTAppliedErr@1021 : TextConst '@@@=%1 - transaction date, %2 - arbitrary text;DAN=Linjen med transaktionsdatoen %1 og transaktionsteksten ''%2'' er ikke anvendt. Du skal anvende alle linjer.;ENU=The line with transaction date %1 and transaction text ''%2'' is not applied. You must apply all lines.';
      TransactionAlreadyReconciledErr@1022 : TextConst '@@@=%1 - transaction date, %2 - arbitrary text;DAN=Linjen med transaktionsdatoen %1 og transaktionsteksten ''%2'' er allerede udlignet.\\Du skal fjerne den fra betalingsudligningskladden, inden du bogf�rer den.;ENU=The line with transaction date %1 and transaction text ''%2'' is already reconciled.\\You must remove it from the payment reconciliation journal before posting.';

    LOCAL PROCEDURE InitPost@2(BankAccRecon@1000 : Record 273);
    BEGIN
      WITH BankAccRecon DO
        CASE "Statement Type" OF
          "Statement Type"::"Bank Reconciliation":
            BEGIN
              TESTFIELD("Statement Date");
              CheckLinesMatchEndingBalance(BankAccRecon,Difference);
            END;
          "Statement Type"::"Payment Application":
            BEGIN
              SourceCodeSetup.GET;
              SourceCode := SourceCodeSetup."Payment Reconciliation Journal";
              PostPaymentsOnly := "Post Payments Only";
            END;
        END;
    END;

    LOCAL PROCEDURE Post@3(BankAccRecon@1000 : Record 273);
    VAR
      BankAccReconLine@1001 : Record 274;
      AppliedAmount@1002 : Decimal;
      TotalTransAmtNotAppliedErr@1003 : Text;
    BEGIN
      WITH BankAccRecon DO BEGIN
        // Run through lines
        BankAccReconLine.FilterBankRecLines(BankAccRecon);
        TotalAmount := 0;
        TotalAppliedAmount := 0;
        TotalDiff := 0;
        Lines := 0;
        IF BankAccReconLine.ISEMPTY THEN
          ERROR(Text002);
        BankAccLedgEntry.LOCKTABLE;
        CheckLedgEntry.LOCKTABLE;

        IF BankAccReconLine.FINDSET THEN
          REPEAT
            Lines := Lines + 1;
            Window.UPDATE(2,Lines);
            AppliedAmount := 0;
            // Adjust entries
            // Test amount and settled amount
            CASE "Statement Type" OF
              "Statement Type"::"Bank Reconciliation":
                CASE BankAccReconLine.Type OF
                  BankAccReconLine.Type::"Bank Account Ledger Entry":
                    CloseBankAccLedgEntry(BankAccReconLine,AppliedAmount);
                  BankAccReconLine.Type::"Check Ledger Entry":
                    CloseCheckLedgEntry(BankAccReconLine,AppliedAmount);
                  BankAccReconLine.Type::Difference:
                    TotalDiff += BankAccReconLine."Statement Amount";
                END;
              "Statement Type"::"Payment Application":
                PostPaymentApplications(BankAccReconLine,AppliedAmount);
            END;
            BankAccReconLine.TESTFIELD("Applied Amount",AppliedAmount);
            TotalAmount += BankAccReconLine."Statement Amount";
            TotalAppliedAmount += AppliedAmount;
          UNTIL BankAccReconLine.NEXT = 0;

        // Test amount
        IF "Statement Type" = "Statement Type"::"Payment Application" THEN
          TotalTransAmtNotAppliedErr := NotFullyAppliedErr
        ELSE
          TotalTransAmtNotAppliedErr := Text003;
        IF TotalAmount <> TotalAppliedAmount + TotalDiff THEN
          ERROR(
            TotalTransAmtNotAppliedErr,
            TotalAppliedAmount + TotalDiff,TotalAmount);
        IF Difference <> TotalDiff THEN
          ERROR(Text004,Difference,TotalDiff);

        // Get bank
        IF NOT PostPaymentsOnly THEN
          UpdateBank(BankAccRecon,TotalAmount);

        CASE "Statement Type" OF
          "Statement Type"::"Bank Reconciliation":
            TransferToBankStmt(BankAccRecon);
          "Statement Type"::"Payment Application":
            BEGIN
              TransferToPostPmtAppln(BankAccRecon);
              IF NOT "Post Payments Only" THEN
                TransferToBankStmt(BankAccRecon);
            END;
        END;
      END;
    END;

    LOCAL PROCEDURE FinalizePost@4(BankAccRecon@1000 : Record 273);
    VAR
      BankAccReconLine@1001 : Record 274;
      AppliedPmtEntry@1002 : Record 1294;
    BEGIN
      WITH BankAccRecon DO BEGIN
        // Delete statement
        IF BankAccReconLine.LinesExist(BankAccRecon) THEN
          REPEAT
            AppliedPmtEntry.FilterAppliedPmtEntry(BankAccReconLine);
            AppliedPmtEntry.DELETEALL;

            BankAccReconLine.DELETE;
            BankAccReconLine.ClearDataExchEntries;
          UNTIL BankAccReconLine.NEXT = 0;

        FIND;
        DELETE;
      END;
    END;

    LOCAL PROCEDURE CheckLinesMatchEndingBalance@1(BankAccRecon@1000 : Record 273;VAR Difference@1002 : Decimal);
    VAR
      BankAccReconLine@1001 : Record 274;
    BEGIN
      WITH BankAccReconLine DO BEGIN
        LinesExist(BankAccRecon);
        CALCSUMS("Statement Amount",Difference);

        IF "Statement Amount" <>
           BankAccRecon."Statement Ending Balance" - BankAccRecon."Balance Last Statement"
        THEN
          ERROR(Text001,BankAccRecon.FIELDCAPTION("Statement Ending Balance"));
      END;
      Difference := BankAccReconLine.Difference;
    END;

    LOCAL PROCEDURE CloseBankAccLedgEntry@7(BankAccReconLine@1000 : Record 274;VAR AppliedAmount@1001 : Decimal);
    BEGIN
      BankAccLedgEntry.RESET;
      BankAccLedgEntry.SETCURRENTKEY("Bank Account No.",Open);
      BankAccLedgEntry.SETRANGE("Bank Account No.",BankAccReconLine."Bank Account No.");
      BankAccLedgEntry.SETRANGE(Open,TRUE);
      BankAccLedgEntry.SETRANGE(
        "Statement Status",BankAccLedgEntry."Statement Status"::"Bank Acc. Entry Applied");
      BankAccLedgEntry.SETRANGE("Statement No.",BankAccReconLine."Statement No.");
      BankAccLedgEntry.SETRANGE("Statement Line No.",BankAccReconLine."Statement Line No.");
      IF BankAccLedgEntry.FIND('-') THEN
        REPEAT
          AppliedAmount += BankAccLedgEntry."Remaining Amount";
          BankAccLedgEntry."Remaining Amount" := 0;
          BankAccLedgEntry.Open := FALSE;
          BankAccLedgEntry."Statement Status" := BankAccLedgEntry."Statement Status"::Closed;
          BankAccLedgEntry.MODIFY;

          CheckLedgEntry.RESET;
          CheckLedgEntry.SETCURRENTKEY("Bank Account Ledger Entry No.");
          CheckLedgEntry.SETRANGE(
            "Bank Account Ledger Entry No.",BankAccLedgEntry."Entry No.");
          CheckLedgEntry.SETRANGE(Open,TRUE);
          IF CheckLedgEntry.FIND('-') THEN
            REPEAT
              CheckLedgEntry.TESTFIELD(Open,TRUE);
              CheckLedgEntry.TESTFIELD(
                "Statement Status",
                CheckLedgEntry."Statement Status"::"Bank Acc. Entry Applied");
              CheckLedgEntry.TESTFIELD("Statement No.",'');
              CheckLedgEntry.TESTFIELD("Statement Line No.",0);
              CheckLedgEntry.Open := FALSE;
              CheckLedgEntry."Statement Status" := CheckLedgEntry."Statement Status"::Closed;
              CheckLedgEntry.MODIFY;
            UNTIL CheckLedgEntry.NEXT = 0;
        UNTIL BankAccLedgEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE CloseCheckLedgEntry@9(BankAccReconLine@1000 : Record 274;VAR AppliedAmount@1001 : Decimal);
    VAR
      CheckLedgEntry2@1002 : Record 272;
    BEGIN
      CheckLedgEntry.RESET;
      CheckLedgEntry.SETCURRENTKEY("Bank Account No.",Open);
      CheckLedgEntry.SETRANGE("Bank Account No.",BankAccReconLine."Bank Account No.");
      CheckLedgEntry.SETRANGE(Open,TRUE);
      CheckLedgEntry.SETRANGE(
        "Statement Status",CheckLedgEntry."Statement Status"::"Check Entry Applied");
      CheckLedgEntry.SETRANGE("Statement No.",BankAccReconLine."Statement No.");
      CheckLedgEntry.SETRANGE("Statement Line No.",BankAccReconLine."Statement Line No.");
      IF CheckLedgEntry.FIND('-') THEN
        REPEAT
          AppliedAmount -= CheckLedgEntry.Amount;
          CheckLedgEntry.Open := FALSE;
          CheckLedgEntry."Statement Status" := CheckLedgEntry."Statement Status"::Closed;
          CheckLedgEntry.MODIFY;

          BankAccLedgEntry.GET(CheckLedgEntry."Bank Account Ledger Entry No.");
          BankAccLedgEntry.TESTFIELD(Open,TRUE);
          BankAccLedgEntry.TESTFIELD(
            "Statement Status",BankAccLedgEntry."Statement Status"::"Check Entry Applied");
          BankAccLedgEntry.TESTFIELD("Statement No.",'');
          BankAccLedgEntry.TESTFIELD("Statement Line No.",0);
          BankAccLedgEntry."Remaining Amount" :=
            BankAccLedgEntry."Remaining Amount" + CheckLedgEntry.Amount;
          IF BankAccLedgEntry."Remaining Amount" = 0 THEN BEGIN
            BankAccLedgEntry.Open := FALSE;
            BankAccLedgEntry."Statement Status" := BankAccLedgEntry."Statement Status"::Closed;
            BankAccLedgEntry."Statement No." := BankAccReconLine."Statement No.";
            BankAccLedgEntry."Statement Line No." := CheckLedgEntry."Statement Line No.";
          END ELSE BEGIN
            CheckLedgEntry2.RESET;
            CheckLedgEntry2.SETCURRENTKEY("Bank Account Ledger Entry No.");
            CheckLedgEntry2.SETRANGE("Bank Account Ledger Entry No.",BankAccLedgEntry."Entry No.");
            CheckLedgEntry2.SETRANGE(Open,TRUE);
            CheckLedgEntry2.SETRANGE("Check Type",CheckLedgEntry2."Check Type"::"Partial Check");
            CheckLedgEntry2.SETRANGE(
              "Statement Status",CheckLedgEntry2."Statement Status"::"Check Entry Applied");
            IF NOT CheckLedgEntry2.FINDFIRST THEN
              BankAccLedgEntry."Statement Status" := BankAccLedgEntry."Statement Status"::Open;
          END;
          BankAccLedgEntry.MODIFY;
        UNTIL CheckLedgEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE PostPaymentApplications@21(BankAccReconLine@1001 : Record 274;VAR AppliedAmount@1000 : Decimal);
    VAR
      BankAccReconciliation@1011 : Record 273;
      CurrExchRate@1009 : Record 330;
      AppliedPmtEntry@1002 : Record 1294;
      BankAccountLedgerEntry@1005 : Record 271;
      GLSetup@1007 : Record 98;
      DimensionManagement@1006 : Codeunit 408;
      PaymentLineAmount@1003 : Decimal;
      RemainingAmount@1004 : Decimal;
      IsApplied@1008 : Boolean;
    BEGIN
      IF BankAccReconLine.IsTransactionPostedAndReconciled THEN
        ERROR(TransactionAlreadyReconciledErr,BankAccReconLine."Transaction Date",BankAccReconLine."Transaction Text");

      WITH GenJnlLine DO BEGIN
        IF BankAccReconLine."Account No." = '' THEN
          ERROR(LineNoTAppliedErr,BankAccReconLine."Transaction Date",BankAccReconLine."Transaction Text");
        BankAcc.GET(BankAccReconLine."Bank Account No.");
        INIT;
        "Document Type" := "Document Type"::Payment;

        IF IsRefund(BankAccReconLine) THEN
          "Document Type" := "Document Type"::Refund;

        "Account Type" := BankAccReconLine.GetAppliedToAccountType;
        BankAccReconciliation.GET(
          BankAccReconLine."Statement Type",BankAccReconLine."Bank Account No.",BankAccReconLine."Statement No.");
        "Copy VAT Setup to Jnl. Lines" := BankAccReconciliation."Copy VAT Setup to Jnl. Line";
        VALIDATE("Account No.",BankAccReconLine.GetAppliedToAccountNo);
        "Dimension Set ID" := BankAccReconLine."Dimension Set ID";
        DimensionManagement.UpdateGlobalDimFromDimSetID(
          BankAccReconLine."Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");

        "Posting Date" := BankAccReconLine."Transaction Date";
        Description := BankAccReconLine.GetDescription;

        "Document No." := BankAccReconLine."Statement No.";
        "Bal. Account Type" := "Bal. Account Type"::"Bank Account";
        "Bal. Account No." := BankAcc."No.";

        "Source Code" := SourceCode;
        "Allow Zero-Amount Posting" := TRUE;

        "Applies-to ID" := BankAccReconLine.GetAppliesToID;
      END;

      IsApplied := FALSE;
      WITH AppliedPmtEntry DO
        IF AppliedPmtEntryLinesExist(BankAccReconLine) THEN
          REPEAT
            AppliedAmount += "Applied Amount" - "Applied Pmt. Discount";
            PaymentLineAmount += "Applied Amount" - "Applied Pmt. Discount";
            TESTFIELD("Account Type",BankAccReconLine."Account Type");
            TESTFIELD("Account No.",BankAccReconLine."Account No.");
            IF "Applies-to Entry No." <> 0 THEN BEGIN
              CASE "Account Type" OF
                "Account Type"::Customer:
                  ApplyCustLedgEntry(
                    AppliedPmtEntry,GenJnlLine."Applies-to ID",GenJnlLine."Posting Date",0D,0D,"Applied Pmt. Discount");
                "Account Type"::Vendor:
                  ApplyVendLedgEntry(
                    AppliedPmtEntry,GenJnlLine."Applies-to ID",GenJnlLine."Posting Date",0D,0D,"Applied Pmt. Discount");
                "Account Type"::"Bank Account":
                  BEGIN
                    BankAccountLedgerEntry.GET("Applies-to Entry No.");
                    RemainingAmount := BankAccountLedgerEntry."Remaining Amount";
                    CASE TRUE OF
                      RemainingAmount = "Applied Amount":
                        BEGIN
                          IF NOT PostPaymentsOnly THEN
                            CloseBankAccountLedgerEntry("Applies-to Entry No.","Applied Amount");
                          PaymentLineAmount -= "Applied Amount";
                        END;
                      ABS(RemainingAmount) > ABS("Applied Amount"):
                        BEGIN
                          IF NOT PostPaymentsOnly THEN BEGIN
                            BankAccountLedgerEntry."Remaining Amount" -= "Applied Amount";
                            BankAccountLedgerEntry.MODIFY;
                          END;
                          PaymentLineAmount -= "Applied Amount";
                        END;
                      ABS(RemainingAmount) < ABS("Applied Amount"):
                        BEGIN
                          IF NOT PostPaymentsOnly THEN
                            CloseBankAccountLedgerEntry("Applies-to Entry No.",RemainingAmount);
                          PaymentLineAmount -= RemainingAmount;
                        END;
                    END;
                  END;
              END;
              IsApplied := TRUE;
            END;
          UNTIL NEXT = 0;

      IF PaymentLineAmount <> 0 THEN BEGIN
        IF NOT IsApplied THEN
          GenJnlLine."Applies-to ID" := '';
        IF (GenJnlLine."Account Type" <> GenJnlLine."Account Type"::"Bank Account") OR
           (GenJnlLine."Currency Code" = BankAcc."Currency Code")
        THEN BEGIN
          GenJnlLine.VALIDATE("Currency Code",BankAcc."Currency Code");
          GenJnlLine.Amount := -PaymentLineAmount;
          IF GenJnlLine."Currency Code" <> '' THEN
            GenJnlLine."Amount (LCY)" := ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  GenJnlLine."Posting Date",GenJnlLine."Currency Code",
                  GenJnlLine.Amount,GenJnlLine."Currency Factor"));
          GenJnlLine.VALIDATE("VAT %");
          GenJnlLine.VALIDATE("Bal. VAT %")
        END ELSE BEGIN
          GLSetup.GET;
          ERROR(ExcessiveAmtErr,PaymentLineAmount,GLSetup.GetCurrencyCode(BankAcc."Currency Code"));
        END;
        GenJnlLine.ValidateApplyRequirements(GenJnlLine);
        GenJnlPostLine.RunWithCheck(GenJnlLine);
        IF NOT PostPaymentsOnly THEN BEGIN
          BankAccountLedgerEntry.SETRANGE(Open,TRUE);
          BankAccountLedgerEntry.SETRANGE("Bank Account No.",BankAcc."No.");
          BankAccountLedgerEntry.SETRANGE("Document Type",GenJnlLine."Document Type"::Payment);
          BankAccountLedgerEntry.SETRANGE("Document No.",BankAccReconLine."Statement No.");
          BankAccountLedgerEntry.SETRANGE("Posting Date",GenJnlLine."Posting Date");
          IF BankAccountLedgerEntry.FINDLAST THEN
            CloseBankAccountLedgerEntry(BankAccountLedgerEntry."Entry No.",BankAccountLedgerEntry.Amount);
        END;
      END;
    END;

    LOCAL PROCEDURE UpdateBank@17(BankAccRecon@1000 : Record 273;Amt@1001 : Decimal);
    BEGIN
      WITH BankAcc DO BEGIN
        LOCKTABLE;
        GET(BankAccRecon."Bank Account No.");
        TESTFIELD(Blocked,FALSE);
        "Last Statement No." := BankAccRecon."Statement No.";
        "Balance Last Statement" := BankAccRecon."Balance Last Statement" + Amt;
        MODIFY;
      END;
    END;

    LOCAL PROCEDURE TransferToBankStmt@25(BankAccRecon@1002 : Record 273);
    VAR
      BankAccStmt@1001 : Record 275;
      BankAccStmtLine@1000 : Record 276;
      BankAccReconLine@1003 : Record 274;
    BEGIN
      IF BankAccReconLine.LinesExist(BankAccRecon) THEN
        REPEAT
          BankAccStmtLine.TRANSFERFIELDS(BankAccReconLine);
          BankAccStmtLine.INSERT;
          BankAccReconLine.ClearDataExchEntries;
        UNTIL BankAccReconLine.NEXT = 0;

      BankAccStmt.TRANSFERFIELDS(BankAccRecon);
      BankAccStmt.INSERT;
    END;

    LOCAL PROCEDURE TransferToPostPmtAppln@5(BankAccRecon@1002 : Record 273);
    VAR
      PostedPmtReconHdr@1000 : Record 1295;
      PostedPmtReconLine@1003 : Record 1296;
      BankAccReconLine@1004 : Record 274;
      TypeHelper@1005 : Codeunit 10;
      FieldLength@1001 : Integer;
    BEGIN
      IF BankAccReconLine.LinesExist(BankAccRecon) THEN
        REPEAT
          PostedPmtReconLine.TRANSFERFIELDS(BankAccReconLine);

          FieldLength := TypeHelper.GetFieldLength(DATABASE::"Posted Payment Recon. Line",
              PostedPmtReconLine.FIELDNO("Applied Document No."));
          PostedPmtReconLine."Applied Document No." := COPYSTR(BankAccReconLine.GetAppliedToDocumentNo,1,FieldLength);

          FieldLength := TypeHelper.GetFieldLength(DATABASE::"Posted Payment Recon. Line",
              PostedPmtReconLine.FIELDNO("Applied Entry No."));
          PostedPmtReconLine."Applied Entry No." := COPYSTR(BankAccReconLine.GetAppliedToEntryNo,1,FieldLength);

          PostedPmtReconLine.Reconciled := NOT PostPaymentsOnly;

          PostedPmtReconLine.INSERT;
          BankAccReconLine.ClearDataExchEntries;
        UNTIL BankAccReconLine.NEXT = 0;

      PostedPmtReconHdr.TRANSFERFIELDS(BankAccRecon);
      PostedPmtReconHdr.INSERT;
    END;

    [Internal]
    PROCEDURE ApplyCustLedgEntry@12(AppliedPmtEntry@1000 : Record 1294;AppliesToID@1001 : Code[50];PostingDate@1004 : Date;PmtDiscDueDate@1007 : Date;PmtDiscToleranceDate@1006 : Date;RemPmtDiscPossible@1003 : Decimal);
    VAR
      CustLedgEntry@1002 : Record 21;
      CurrExchRate@1005 : Record 330;
    BEGIN
      WITH CustLedgEntry DO BEGIN
        GET(AppliedPmtEntry."Applies-to Entry No.");
        TESTFIELD(Open);
        BankAcc.GET(AppliedPmtEntry."Bank Account No.");
        IF AppliesToID = '' THEN BEGIN
          "Pmt. Discount Date" := PmtDiscDueDate;
          "Pmt. Disc. Tolerance Date" := PmtDiscToleranceDate;

          "Remaining Pmt. Disc. Possible" := RemPmtDiscPossible;
          IF BankAcc.IsInLocalCurrency THEN
            "Remaining Pmt. Disc. Possible" :=
              CurrExchRate.ExchangeAmount("Remaining Pmt. Disc. Possible",'',"Currency Code",PostingDate);
        END ELSE BEGIN
          "Applies-to ID" := AppliesToID;
          "Amount to Apply" := AppliedPmtEntry.CalcAmountToApply(PostingDate);
        END;

        CODEUNIT.RUN(CODEUNIT::"Cust. Entry-Edit",CustLedgEntry);
      END;
    END;

    [Internal]
    PROCEDURE ApplyVendLedgEntry@14(AppliedPmtEntry@1000 : Record 1294;AppliesToID@1001 : Code[50];PostingDate@1003 : Date;PmtDiscDueDate@1007 : Date;PmtDiscToleranceDate@1006 : Date;RemPmtDiscPossible@1004 : Decimal);
    VAR
      VendLedgEntry@1002 : Record 25;
      CurrExchRate@1005 : Record 330;
    BEGIN
      WITH VendLedgEntry DO BEGIN
        GET(AppliedPmtEntry."Applies-to Entry No.");
        TESTFIELD(Open);
        BankAcc.GET(AppliedPmtEntry."Bank Account No.");
        IF AppliesToID = '' THEN BEGIN
          "Pmt. Discount Date" := PmtDiscDueDate;
          "Pmt. Disc. Tolerance Date" := PmtDiscToleranceDate;

          "Remaining Pmt. Disc. Possible" := RemPmtDiscPossible;
          IF BankAcc.IsInLocalCurrency THEN
            "Remaining Pmt. Disc. Possible" :=
              CurrExchRate.ExchangeAmount("Remaining Pmt. Disc. Possible",'',"Currency Code",PostingDate);
        END ELSE BEGIN
          "Applies-to ID" := AppliesToID;
          "Amount to Apply" := AppliedPmtEntry.CalcAmountToApply(PostingDate);
        END;

        CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit",VendLedgEntry);
      END;
    END;

    LOCAL PROCEDURE CloseBankAccountLedgerEntry@8(EntryNo@1000 : Integer;AppliedAmount@1003 : Decimal);
    VAR
      BankAccountLedgerEntry@1002 : Record 271;
      CheckLedgerEntry@1001 : Record 272;
    BEGIN
      WITH BankAccountLedgerEntry DO BEGIN
        GET(EntryNo);
        TESTFIELD(Open);
        TESTFIELD("Remaining Amount",AppliedAmount);
        "Remaining Amount" := 0;
        Open := FALSE;
        "Statement Status" := "Statement Status"::Closed;
        MODIFY;

        CheckLedgerEntry.RESET;
        CheckLedgerEntry.SETCURRENTKEY("Bank Account Ledger Entry No.");
        CheckLedgerEntry.SETRANGE(
          "Bank Account Ledger Entry No.","Entry No.");
        CheckLedgerEntry.SETRANGE(Open,TRUE);
        IF CheckLedgerEntry.FINDSET THEN
          REPEAT
            CheckLedgerEntry.Open := FALSE;
            CheckLedgerEntry."Statement Status" := CheckLedgerEntry."Statement Status"::Closed;
            CheckLedgerEntry.MODIFY;
          UNTIL CheckLedgerEntry.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE IsRefund@6(BankAccReconLine@1000 : Record 274) : Boolean;
    BEGIN
      WITH BankAccReconLine DO
        IF ("Account Type" = "Account Type"::Customer) AND ("Statement Amount" < 0) OR
           ("Account Type" = "Account Type"::Vendor) AND ("Statement Amount" > 0)
        THEN
          EXIT(TRUE);
      EXIT(FALSE);
    END;

    BEGIN
    END.
  }
}

