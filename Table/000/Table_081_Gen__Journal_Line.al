OBJECT Table 81 Gen. Journal Line
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    Permissions=TableData 112=r,
                TableData 1221=rimd;
    OnInsert=BEGIN
               GenJnlAlloc.LOCKTABLE;
               LOCKTABLE;

               SetLastModifiedDateTime;

               GenJnlTemplate.GET("Journal Template Name");
               GenJnlBatch.GET("Journal Template Name","Journal Batch Name");
               "Copy VAT Setup to Jnl. Lines" := GenJnlBatch."Copy VAT Setup to Jnl. Lines";
               "Posting No. Series" := GenJnlBatch."Posting No. Series";
               "Check Printed" := FALSE;

               ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
               ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
             END;

    OnModify=BEGIN
               SetLastModifiedDateTime;

               TESTFIELD("Check Printed",FALSE);
               IF ("Applies-to ID" = '') AND (xRec."Applies-to ID" <> '') THEN
                 ClearCustVendApplnEntry;
             END;

    OnDelete=BEGIN
               ApprovalsMgmt.OnCancelGeneralJournalLineApprovalRequest(Rec);

               TESTFIELD("Check Printed",FALSE);

               ClearCustVendApplnEntry;
               ClearAppliedGenJnlLine;
               DeletePaymentFileErrors;
               ClearDataExchangeEntries(FALSE);

               GenJnlAlloc.SETRANGE("Journal Template Name","Journal Template Name");
               GenJnlAlloc.SETRANGE("Journal Batch Name","Journal Batch Name");
               GenJnlAlloc.SETRANGE("Journal Line No.","Line No.");
               GenJnlAlloc.DELETEALL;

               DeferralUtilities.DeferralCodeOnDelete(
                 DeferralDocType::"G/L",
                 "Journal Template Name",
                 "Journal Batch Name",0,'',"Line No.");

               VALIDATE("Incoming Document Entry No.",0);
             END;

    OnRename=BEGIN
               ApprovalsMgmt.OnRenameRecordInApprovalRequest(xRec.RECORDID,RECORDID);

               TESTFIELD("Check Printed",FALSE);
             END;

    CaptionML=[DAN=Finanskladdelinje;
               ENU=Gen. Journal Line];
  }
  FIELDS
  {
    { 1   ;   ;Journal Template Name;Code10       ;TableRelation="Gen. Journal Template";
                                                   CaptionML=[DAN=Kladdetypenavn;
                                                              ENU=Journal Template Name] }
    { 2   ;   ;Line No.            ;Integer       ;CaptionML=[DAN=Linjenr.;
                                                              ENU=Line No.] }
    { 3   ;   ;Account Type        ;Option        ;OnValidate=BEGIN
                                                                IF ("Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor,"Account Type"::"Fixed Asset",
                                                                                       "Account Type"::"IC Partner","Account Type"::Employee]) AND
                                                                   ("Bal. Account Type" IN ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor,"Bal. Account Type"::"Fixed Asset",
                                                                                            "Bal. Account Type"::"IC Partner","Bal. Account Type"::Employee])
                                                                THEN
                                                                  ERROR(
                                                                    Text000,
                                                                    FIELDCAPTION("Account Type"),FIELDCAPTION("Bal. Account Type"));

                                                                IF ("Account Type" = "Account Type"::Employee) AND ("Currency Code" <> '') THEN
                                                                  ERROR(OnlyLocalCurrencyForEmployeeErr);

                                                                VALIDATE("Account No.",'');
                                                                VALIDATE(Description,'');
                                                                VALIDATE("IC Partner G/L Acc. No.",'');
                                                                IF "Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor,"Account Type"::"Bank Account","Account Type"::Employee] THEN BEGIN
                                                                  VALIDATE("Gen. Posting Type","Gen. Posting Type"::" ");
                                                                  VALIDATE("Gen. Bus. Posting Group",'');
                                                                  VALIDATE("Gen. Prod. Posting Group",'');
                                                                END ELSE
                                                                  IF "Bal. Account Type" IN [
                                                                                             "Bal. Account Type"::"G/L Account","Account Type"::"Bank Account","Bal. Account Type"::"Fixed Asset"]
                                                                  THEN
                                                                    VALIDATE("Payment Terms Code",'');
                                                                UpdateSource;

                                                                IF ("Account Type" <> "Account Type"::"Fixed Asset") AND
                                                                   ("Bal. Account Type" <> "Bal. Account Type"::"Fixed Asset")
                                                                THEN BEGIN
                                                                  "Depreciation Book Code" := '';
                                                                  VALIDATE("FA Posting Type","FA Posting Type"::" ");
                                                                END;
                                                                IF xRec."Account Type" IN
                                                                   [xRec."Account Type"::Customer,xRec."Account Type"::Vendor]
                                                                THEN BEGIN
                                                                  "Bill-to/Pay-to No." := '';
                                                                  "Ship-to/Order Address Code" := '';
                                                                  "Sell-to/Buy-from No." := '';
                                                                  "VAT Registration No." := '';
                                                                END;

                                                                IF "Journal Template Name" <> '' THEN
                                                                  IF "Account Type" = "Account Type"::"IC Partner" THEN BEGIN
                                                                    GetTemplate;
                                                                    IF GenJnlTemplate.Type <> GenJnlTemplate.Type::Intercompany THEN
                                                                      FIELDERROR("Account Type");
                                                                  END;
                                                                IF "Account Type" <> "Account Type"::Customer THEN
                                                                  VALIDATE("Credit Card No.",'');

                                                                VALIDATE("Deferral Code",'');
                                                              END;

                                                   CaptionML=[DAN=Kontotype;
                                                              ENU=Account Type];
                                                   OptionCaptionML=[DAN=Finanskonto,Debitor,Kreditor,Bankkonto,Anl�g,IC-partner,Medarbejder;
                                                                    ENU=G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee];
                                                   OptionString=G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee }
    { 4   ;   ;Account No.         ;Code20        ;TableRelation=IF (Account Type=CONST(G/L Account)) "G/L Account" WHERE (Account Type=CONST(Posting),
                                                                                                                           Blocked=CONST(No))
                                                                                                                           ELSE IF (Account Type=CONST(Customer)) Customer
                                                                                                                           ELSE IF (Account Type=CONST(Vendor)) Vendor
                                                                                                                           ELSE IF (Account Type=CONST(Bank Account)) "Bank Account"
                                                                                                                           ELSE IF (Account Type=CONST(Fixed Asset)) "Fixed Asset"
                                                                                                                           ELSE IF (Account Type=CONST(IC Partner)) "IC Partner"
                                                                                                                           ELSE IF (Account Type=CONST(Employee)) Employee;
                                                   OnValidate=BEGIN
                                                                IF "Account No." <> xRec."Account No." THEN BEGIN
                                                                  ClearAppliedAutomatically;
                                                                  VALIDATE("Job No.",'');
                                                                END;

                                                                IF xRec."Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor,"Account Type"::"IC Partner"] THEN
                                                                  "IC Partner Code" := '';

                                                                IF "Account No." = '' THEN BEGIN
                                                                  CleanLine;
                                                                  EXIT;
                                                                END;

                                                                CASE "Account Type" OF
                                                                  "Account Type"::"G/L Account":
                                                                    GetGLAccount;
                                                                  "Account Type"::Customer:
                                                                    GetCustomerAccount;
                                                                  "Account Type"::Vendor:
                                                                    GetVendorAccount;
                                                                  "Account Type"::Employee:
                                                                    GetEmployeeAccount;
                                                                  "Account Type"::"Bank Account":
                                                                    GetBankAccount;
                                                                  "Account Type"::"Fixed Asset":
                                                                    GetFAAccount;
                                                                  "Account Type"::"IC Partner":
                                                                    GetICPartnerAccount;
                                                                END;

                                                                VALIDATE("Currency Code");
                                                                VALIDATE("VAT Prod. Posting Group");
                                                                UpdateLineBalance;
                                                                UpdateSource;
                                                                CreateDim(
                                                                  DimMgt.TypeToTableID1("Account Type"),"Account No.",
                                                                  DimMgt.TypeToTableID1("Bal. Account Type"),"Bal. Account No.",
                                                                  DATABASE::Job,"Job No.",
                                                                  DATABASE::"Salesperson/Purchaser","Salespers./Purch. Code",
                                                                  DATABASE::Campaign,"Campaign No.");

                                                                VALIDATE("IC Partner G/L Acc. No.",GetDefaultICPartnerGLAccNo);
                                                                ValidateApplyRequirements(Rec);

                                                                CASE "Account Type" OF
                                                                  "Account Type"::"G/L Account":
                                                                    UpdateAccountID;
                                                                  "Account Type"::Customer:
                                                                    UpdateCustomerID;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Kontonr.;
                                                              ENU=Account No.] }
    { 5   ;   ;Posting Date        ;Date          ;OnValidate=BEGIN
                                                                VALIDATE("Document Date","Posting Date");
                                                                VALIDATE("Currency Code");

                                                                IF ("Posting Date" <> xRec."Posting Date") AND (Amount <> 0) THEN
                                                                  PaymentToleranceMgt.PmtTolGenJnl(Rec);

                                                                ValidateApplyRequirements(Rec);

                                                                IF JobTaskIsSet THEN BEGIN
                                                                  CreateTempJobJnlLine;
                                                                  UpdatePricesFromJobJnlLine;
                                                                END;

                                                                IF "Deferral Code" <> '' THEN
                                                                  VALIDATE("Deferral Code");
                                                              END;

                                                   CaptionML=[DAN=Bogf�ringsdato;
                                                              ENU=Posting Date];
                                                   ClosingDates=Yes }
    { 6   ;   ;Document Type       ;Option        ;OnValidate=VAR
                                                                Cust@1000 : Record 18;
                                                                Vend@1001 : Record 23;
                                                              BEGIN
                                                                VALIDATE("Payment Terms Code");
                                                                IF "Account No." <> '' THEN
                                                                  CASE "Account Type" OF
                                                                    "Account Type"::Customer:
                                                                      BEGIN
                                                                        Cust.GET("Account No.");
                                                                        Cust.CheckBlockedCustOnJnls(Cust,"Document Type",FALSE);
                                                                      END;
                                                                    "Account Type"::Vendor:
                                                                      BEGIN
                                                                        Vend.GET("Account No.");
                                                                        Vend.CheckBlockedVendOnJnls(Vend,"Document Type",FALSE);
                                                                      END;
                                                                  END;
                                                                IF "Bal. Account No." <> '' THEN
                                                                  CASE "Bal. Account Type" OF
                                                                    "Account Type"::Customer:
                                                                      BEGIN
                                                                        Cust.GET("Bal. Account No.");
                                                                        Cust.CheckBlockedCustOnJnls(Cust,"Document Type",FALSE);
                                                                      END;
                                                                    "Account Type"::Vendor:
                                                                      BEGIN
                                                                        Vend.GET("Bal. Account No.");
                                                                        Vend.CheckBlockedVendOnJnls(Vend,"Document Type",FALSE);
                                                                      END;
                                                                  END;
                                                                UpdateSalesPurchLCY;
                                                                ValidateApplyRequirements(Rec);
                                                                IF NOT ("Document Type" IN ["Document Type"::Payment,"Document Type"::Refund]) THEN
                                                                  VALIDATE("Credit Card No.",'');
                                                              END;

                                                   CaptionML=[DAN=Bilagstype;
                                                              ENU=Document Type];
                                                   OptionCaptionML=[DAN=" ,Betaling,Faktura,Kreditnota,Rentenota,Rykker,Refusion";
                                                                    ENU=" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund"];
                                                   OptionString=[ ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund] }
    { 7   ;   ;Document No.        ;Code20        ;CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.] }
    { 8   ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 10  ;   ;VAT %               ;Decimal       ;OnValidate=BEGIN
                                                                GetCurrency;
                                                                CASE "VAT Calculation Type" OF
                                                                  "VAT Calculation Type"::"Normal VAT",
                                                                  "VAT Calculation Type"::"Reverse Charge VAT":
                                                                    BEGIN
                                                                      "VAT Amount" :=
                                                                        ROUND(Amount * "VAT %" / (100 + "VAT %"),Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
                                                                      "VAT Base Amount" :=
                                                                        ROUND(Amount - "VAT Amount",Currency."Amount Rounding Precision");
                                                                    END;
                                                                  "VAT Calculation Type"::"Full VAT":
                                                                    "VAT Amount" := Amount;
                                                                  "VAT Calculation Type"::"Sales Tax":
                                                                    IF ("Gen. Posting Type" = "Gen. Posting Type"::Purchase) AND
                                                                       "Use Tax"
                                                                    THEN BEGIN
                                                                      "VAT Amount" := 0;
                                                                      "VAT %" := 0;
                                                                    END ELSE BEGIN
                                                                      "VAT Amount" :=
                                                                        Amount -
                                                                        SalesTaxCalculate.ReverseCalculateTax(
                                                                          "Tax Area Code","Tax Group Code","Tax Liable",
                                                                          "Posting Date",Amount,Quantity,"Currency Factor");
                                                                      IF Amount - "VAT Amount" <> 0 THEN
                                                                        "VAT %" := ROUND(100 * "VAT Amount" / (Amount - "VAT Amount"),0.00001)
                                                                      ELSE
                                                                        "VAT %" := 0;
                                                                      "VAT Amount" :=
                                                                        ROUND("VAT Amount",Currency."Amount Rounding Precision");
                                                                    END;
                                                                END;
                                                                "VAT Base Amount" := Amount - "VAT Amount";
                                                                "VAT Difference" := 0;

                                                                IF "Currency Code" = '' THEN
                                                                  "VAT Amount (LCY)" := "VAT Amount"
                                                                ELSE
                                                                  "VAT Amount (LCY)" :=
                                                                    ROUND(
                                                                      CurrExchRate.ExchangeAmtFCYToLCY(
                                                                        "Posting Date","Currency Code",
                                                                        "VAT Amount","Currency Factor"));
                                                                "VAT Base Amount (LCY)" := "Amount (LCY)" - "VAT Amount (LCY)";

                                                                UpdateSalesPurchLCY;

                                                                IF "Deferral Code" <> '' THEN
                                                                  VALIDATE("Deferral Code");
                                                              END;

                                                   CaptionML=[DAN=Momspct.;
                                                              ENU=VAT %];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   MaxValue=100;
                                                   Editable=No }
    { 11  ;   ;Bal. Account No.    ;Code20        ;TableRelation=IF (Bal. Account Type=CONST(G/L Account)) "G/L Account" WHERE (Account Type=CONST(Posting),
                                                                                                                                Blocked=CONST(No))
                                                                                                                                ELSE IF (Bal. Account Type=CONST(Customer)) Customer
                                                                                                                                ELSE IF (Bal. Account Type=CONST(Vendor)) Vendor
                                                                                                                                ELSE IF (Bal. Account Type=CONST(Bank Account)) "Bank Account"
                                                                                                                                ELSE IF (Bal. Account Type=CONST(Fixed Asset)) "Fixed Asset"
                                                                                                                                ELSE IF (Bal. Account Type=CONST(IC Partner)) "IC Partner"
                                                                                                                                ELSE IF (Bal. Account Type=CONST(Employee)) Employee;
                                                   OnValidate=BEGIN
                                                                VALIDATE("Job No.",'');

                                                                IF xRec."Bal. Account Type" IN ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor,
                                                                                                "Bal. Account Type"::"IC Partner"]
                                                                THEN
                                                                  "IC Partner Code" := '';

                                                                IF "Bal. Account No." = '' THEN BEGIN
                                                                  UpdateLineBalance;
                                                                  UpdateSource;
                                                                  CreateDim(
                                                                    DimMgt.TypeToTableID1("Bal. Account Type"),"Bal. Account No.",
                                                                    DimMgt.TypeToTableID1("Account Type"),"Account No.",
                                                                    DATABASE::Job,"Job No.",
                                                                    DATABASE::"Salesperson/Purchaser","Salespers./Purch. Code",
                                                                    DATABASE::Campaign,"Campaign No.");
                                                                  IF NOT ("Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor]) THEN
                                                                    "Recipient Bank Account" := '';
                                                                  IF xRec."Bal. Account No." <> '' THEN BEGIN
                                                                    ClearBalancePostingGroups;
                                                                    "Bal. Tax Area Code" := '';
                                                                    "Bal. Tax Liable" := FALSE;
                                                                    "Bal. Tax Group Code" := '';
                                                                  END;
                                                                  EXIT;
                                                                END;

                                                                CASE "Bal. Account Type" OF
                                                                  "Bal. Account Type"::"G/L Account":
                                                                    GetGLBalAccount;
                                                                  "Bal. Account Type"::Customer:
                                                                    GetCustomerBalAccount;
                                                                  "Bal. Account Type"::Vendor:
                                                                    GetVendorBalAccount;
                                                                  "Bal. Account Type"::Employee:
                                                                    GetEmployeeBalAccount;
                                                                  "Bal. Account Type"::"Bank Account":
                                                                    GetBankBalAccount;
                                                                  "Bal. Account Type"::"Fixed Asset":
                                                                    GetFABalAccount;
                                                                  "Bal. Account Type"::"IC Partner":
                                                                    GetICPartnerBalAccount;
                                                                END;

                                                                VALIDATE("Currency Code");
                                                                VALIDATE("Bal. VAT Prod. Posting Group");
                                                                UpdateLineBalance;
                                                                UpdateSource;
                                                                CreateDim(
                                                                  DimMgt.TypeToTableID1("Bal. Account Type"),"Bal. Account No.",
                                                                  DimMgt.TypeToTableID1("Account Type"),"Account No.",
                                                                  DATABASE::Job,"Job No.",
                                                                  DATABASE::"Salesperson/Purchaser","Salespers./Purch. Code",
                                                                  DATABASE::Campaign,"Campaign No.");

                                                                VALIDATE("IC Partner G/L Acc. No.",GetDefaultICPartnerGLAccNo);
                                                                ValidateApplyRequirements(Rec);
                                                              END;

                                                   CaptionML=[DAN=Modkonto;
                                                              ENU=Bal. Account No.] }
    { 12  ;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   OnValidate=VAR
                                                                BankAcc@1000 : Record 270;
                                                              BEGIN
                                                                IF "Bal. Account Type" = "Bal. Account Type"::"Bank Account" THEN BEGIN
                                                                  IF BankAcc.GET("Bal. Account No.") AND (BankAcc."Currency Code" <> '')THEN
                                                                    BankAcc.TESTFIELD("Currency Code","Currency Code");
                                                                END;
                                                                IF "Account Type" = "Account Type"::"Bank Account" THEN BEGIN
                                                                  IF BankAcc.GET("Account No.") AND (BankAcc."Currency Code" <> '') THEN
                                                                    BankAcc.TESTFIELD("Currency Code","Currency Code");
                                                                END;
                                                                IF ("Recurring Method" IN
                                                                    ["Recurring Method"::"B  Balance","Recurring Method"::"RB Reversing Balance"]) AND
                                                                   ("Currency Code" <> '')
                                                                THEN
                                                                  ERROR(
                                                                    Text001,
                                                                    FIELDCAPTION("Currency Code"),FIELDCAPTION("Recurring Method"),"Recurring Method");

                                                                IF "Currency Code" <> '' THEN BEGIN
                                                                  IF ("Bal. Account Type" = "Bal. Account Type"::Employee) OR ("Account Type" = "Account Type"::Employee) THEN
                                                                    ERROR(OnlyLocalCurrencyForEmployeeErr);
                                                                  GetCurrency;
                                                                  IF ("Currency Code" <> xRec."Currency Code") OR
                                                                     ("Posting Date" <> xRec."Posting Date") OR
                                                                     (CurrFieldNo = FIELDNO("Currency Code")) OR
                                                                     ("Currency Factor" = 0)
                                                                  THEN
                                                                    "Currency Factor" :=
                                                                      CurrExchRate.ExchangeRate("Posting Date","Currency Code");
                                                                END ELSE
                                                                  "Currency Factor" := 0;
                                                                VALIDATE("Currency Factor");

                                                                IF NOT CustVendAccountNosModified THEN
                                                                  IF ("Currency Code" <> xRec."Currency Code") AND (Amount <> 0) THEN
                                                                    PaymentToleranceMgt.PmtTolGenJnl(Rec);
                                                              END;

                                                   CaptionML=[DAN=Valutakode;
                                                              ENU=Currency Code] }
    { 13  ;   ;Amount              ;Decimal       ;OnValidate=BEGIN
                                                                GetCurrency;
                                                                IF "Currency Code" = '' THEN
                                                                  "Amount (LCY)" := Amount
                                                                ELSE
                                                                  "Amount (LCY)" := ROUND(
                                                                      CurrExchRate.ExchangeAmtFCYToLCY(
                                                                        "Posting Date","Currency Code",
                                                                        Amount,"Currency Factor"));

                                                                Amount := ROUND(Amount,Currency."Amount Rounding Precision");
                                                                IF (CurrFieldNo <> 0) AND
                                                                   (CurrFieldNo <> FIELDNO("Applies-to Doc. No.")) AND
                                                                   ((("Account Type" = "Account Type"::Customer) AND
                                                                     ("Account No." <> '') AND (Amount > 0) AND
                                                                     (CurrFieldNo <> FIELDNO("Bal. Account No."))) OR
                                                                    (("Bal. Account Type" = "Bal. Account Type"::Customer) AND
                                                                     ("Bal. Account No." <> '') AND (Amount < 0) AND
                                                                     (CurrFieldNo <> FIELDNO("Account No."))))
                                                                THEN
                                                                  CustCheckCreditLimit.GenJnlLineCheck(Rec);

                                                                VALIDATE("VAT %");
                                                                VALIDATE("Bal. VAT %");
                                                                UpdateLineBalance;
                                                                IF "Deferral Code" <> '' THEN
                                                                  VALIDATE("Deferral Code");

                                                                IF Amount <> xRec.Amount THEN BEGIN
                                                                  IF ("Applies-to Doc. No." <> '') OR ("Applies-to ID" <> '') THEN
                                                                    SetApplyToAmount;
                                                                  PaymentToleranceMgt.PmtTolGenJnl(Rec);
                                                                END;

                                                                IF JobTaskIsSet THEN BEGIN
                                                                  CreateTempJobJnlLine;
                                                                  UpdatePricesFromJobJnlLine;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Bel�b;
                                                              ENU=Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 14  ;   ;Debit Amount        ;Decimal       ;OnValidate=BEGIN
                                                                GetCurrency;
                                                                "Debit Amount" := ROUND("Debit Amount",Currency."Amount Rounding Precision");
                                                                Correction := "Debit Amount" < 0;
                                                                IF ("Credit Amount" = 0) OR ("Debit Amount" <> 0) THEN BEGIN
                                                                  Amount := "Debit Amount";
                                                                  VALIDATE(Amount);
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Debetbel�b;
                                                              ENU=Debit Amount];
                                                   BlankZero=Yes;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 15  ;   ;Credit Amount       ;Decimal       ;OnValidate=BEGIN
                                                                GetCurrency;
                                                                "Credit Amount" := ROUND("Credit Amount",Currency."Amount Rounding Precision");
                                                                Correction := "Credit Amount" < 0;
                                                                IF ("Debit Amount" = 0) OR ("Credit Amount" <> 0) THEN BEGIN
                                                                  Amount := -"Credit Amount";
                                                                  VALIDATE(Amount);
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Kreditbel�b;
                                                              ENU=Credit Amount];
                                                   BlankZero=Yes;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 16  ;   ;Amount (LCY)        ;Decimal       ;OnValidate=BEGIN
                                                                IF "Currency Code" = '' THEN BEGIN
                                                                  Amount := "Amount (LCY)";
                                                                  VALIDATE(Amount);
                                                                END ELSE BEGIN
                                                                  IF CheckFixedCurrency THEN BEGIN
                                                                    GetCurrency;
                                                                    Amount := ROUND(
                                                                        CurrExchRate.ExchangeAmtLCYToFCY(
                                                                          "Posting Date","Currency Code",
                                                                          "Amount (LCY)","Currency Factor"),
                                                                        Currency."Amount Rounding Precision")
                                                                  END ELSE BEGIN
                                                                    TESTFIELD("Amount (LCY)");
                                                                    TESTFIELD(Amount);
                                                                    "Currency Factor" := Amount / "Amount (LCY)";
                                                                  END;

                                                                  VALIDATE("VAT %");
                                                                  VALIDATE("Bal. VAT %");
                                                                  UpdateLineBalance;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Bel�b (RV);
                                                              ENU=Amount (LCY)];
                                                   AutoFormatType=1 }
    { 17  ;   ;Balance (LCY)       ;Decimal       ;CaptionML=[DAN=Saldo (RV);
                                                              ENU=Balance (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 18  ;   ;Currency Factor     ;Decimal       ;OnValidate=BEGIN
                                                                IF ("Currency Code" = '') AND ("Currency Factor" <> 0) THEN
                                                                  FIELDERROR("Currency Factor",STRSUBSTNO(Text002,FIELDCAPTION("Currency Code")));
                                                                VALIDATE(Amount);
                                                              END;

                                                   CaptionML=[DAN=Valutafaktor;
                                                              ENU=Currency Factor];
                                                   DecimalPlaces=0:15;
                                                   MinValue=0;
                                                   Editable=No }
    { 19  ;   ;Sales/Purch. (LCY)  ;Decimal       ;CaptionML=[DAN=Salg/k�b (RV);
                                                              ENU=Sales/Purch. (LCY)];
                                                   AutoFormatType=1 }
    { 20  ;   ;Profit (LCY)        ;Decimal       ;CaptionML=[DAN=Avancebel�b (RV);
                                                              ENU=Profit (LCY)];
                                                   AutoFormatType=1 }
    { 21  ;   ;Inv. Discount (LCY) ;Decimal       ;CaptionML=[DAN=Fakt.rabatbel�b (RV);
                                                              ENU=Inv. Discount (LCY)];
                                                   AutoFormatType=1 }
    { 22  ;   ;Bill-to/Pay-to No.  ;Code20        ;TableRelation=IF (Account Type=CONST(Customer)) Customer
                                                                 ELSE IF (Bal. Account Type=CONST(Customer)) Customer
                                                                 ELSE IF (Account Type=CONST(Vendor)) Vendor
                                                                 ELSE IF (Bal. Account Type=CONST(Vendor)) Vendor;
                                                   OnValidate=BEGIN
                                                                IF "Bill-to/Pay-to No." <> xRec."Bill-to/Pay-to No." THEN
                                                                  "Ship-to/Order Address Code" := '';
                                                                ReadGLSetup;
                                                                IF GLSetup."Bill-to/Sell-to VAT Calc." = GLSetup."Bill-to/Sell-to VAT Calc."::"Bill-to/Pay-to No." THEN
                                                                  UpdateCountryCodeAndVATRegNo("Bill-to/Pay-to No.");
                                                              END;

                                                   CaptionML=[DAN=Faktureres til/leverand�rnr.;
                                                              ENU=Bill-to/Pay-to No.];
                                                   Editable=No }
    { 23  ;   ;Posting Group       ;Code20        ;TableRelation=IF (Account Type=CONST(Customer)) "Customer Posting Group"
                                                                 ELSE IF (Account Type=CONST(Vendor)) "Vendor Posting Group"
                                                                 ELSE IF (Account Type=CONST(Fixed Asset)) "FA Posting Group";
                                                   CaptionML=[DAN=Bogf�ringsgruppe;
                                                              ENU=Posting Group];
                                                   Editable=No }
    { 24  ;   ;Shortcut Dimension 1 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1),
                                                                                               Blocked=CONST(No));
                                                   OnValidate=BEGIN
                                                                ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
                                                              END;

                                                   CaptionML=[DAN=Genvejsdimension 1-kode;
                                                              ENU=Shortcut Dimension 1 Code];
                                                   CaptionClass='1,2,1' }
    { 25  ;   ;Shortcut Dimension 2 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2),
                                                                                               Blocked=CONST(No));
                                                   OnValidate=BEGIN
                                                                ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
                                                              END;

                                                   CaptionML=[DAN=Genvejsdimension 2-kode;
                                                              ENU=Shortcut Dimension 2 Code];
                                                   CaptionClass='1,2,2' }
    { 26  ;   ;Salespers./Purch. Code;Code20      ;TableRelation=Salesperson/Purchaser;
                                                   OnValidate=BEGIN
                                                                CreateDim(
                                                                  DATABASE::"Salesperson/Purchaser","Salespers./Purch. Code",
                                                                  DimMgt.TypeToTableID1("Account Type"),"Account No.",
                                                                  DimMgt.TypeToTableID1("Bal. Account Type"),"Bal. Account No.",
                                                                  DATABASE::Job,"Job No.",
                                                                  DATABASE::Campaign,"Campaign No.");
                                                              END;

                                                   CaptionML=[DAN=S�lger/indk�berkode;
                                                              ENU=Salespers./Purch. Code] }
    { 29  ;   ;Source Code         ;Code10        ;TableRelation="Source Code";
                                                   CaptionML=[DAN=Kildespor;
                                                              ENU=Source Code];
                                                   Editable=No }
    { 30  ;   ;System-Created Entry;Boolean       ;CaptionML=[DAN=Automatisk oprettet;
                                                              ENU=System-Created Entry];
                                                   Editable=No }
    { 34  ;   ;On Hold             ;Code3         ;CaptionML=[DAN=Afvent;
                                                              ENU=On Hold] }
    { 35  ;   ;Applies-to Doc. Type;Option        ;OnValidate=BEGIN
                                                                IF "Applies-to Doc. Type" <> xRec."Applies-to Doc. Type" THEN
                                                                  VALIDATE("Applies-to Doc. No.",'');
                                                              END;

                                                   CaptionML=[DAN=Udligningsbilagstype;
                                                              ENU=Applies-to Doc. Type];
                                                   OptionCaptionML=[DAN=" ,Betaling,Faktura,Kreditnota,Rentenota,Rykker,Refusion";
                                                                    ENU=" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund"];
                                                   OptionString=[ ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund] }
    { 36  ;   ;Applies-to Doc. No. ;Code20        ;OnValidate=VAR
                                                                CustLedgEntry@1000 : Record 21;
                                                                VendLedgEntry@1003 : Record 25;
                                                                TempGenJnlLine@1001 : TEMPORARY Record 81;
                                                              BEGIN
                                                                IF "Applies-to Doc. No." <> xRec."Applies-to Doc. No." THEN
                                                                  ClearCustVendApplnEntry;

                                                                IF ("Applies-to Doc. No." = '') AND (xRec."Applies-to Doc. No." <> '') THEN BEGIN
                                                                  PaymentToleranceMgt.DelPmtTolApllnDocNo(Rec,xRec."Applies-to Doc. No.");

                                                                  TempGenJnlLine := Rec;
                                                                  IF (TempGenJnlLine."Bal. Account Type" = TempGenJnlLine."Bal. Account Type"::Customer) OR
                                                                     (TempGenJnlLine."Bal. Account Type" = TempGenJnlLine."Bal. Account Type"::Vendor) OR
                                                                     (TempGenJnlLine."Bal. Account Type" = TempGenJnlLine."Bal. Account Type"::Employee)
                                                                  THEN
                                                                    CODEUNIT.RUN(CODEUNIT::"Exchange Acc. G/L Journal Line",TempGenJnlLine);

                                                                  CASE TempGenJnlLine."Account Type" OF
                                                                    TempGenJnlLine."Account Type"::Customer:
                                                                      BEGIN
                                                                        CustLedgEntry.SETCURRENTKEY("Document No.");
                                                                        CustLedgEntry.SETRANGE("Document No.",xRec."Applies-to Doc. No.");
                                                                        IF NOT (xRec."Applies-to Doc. Type" = "Document Type"::" ") THEN
                                                                          CustLedgEntry.SETRANGE("Document Type",xRec."Applies-to Doc. Type");
                                                                        CustLedgEntry.SETRANGE("Customer No.",TempGenJnlLine."Account No.");
                                                                        CustLedgEntry.SETRANGE(Open,TRUE);
                                                                        IF CustLedgEntry.FINDFIRST THEN BEGIN
                                                                          IF CustLedgEntry."Amount to Apply" <> 0 THEN  BEGIN
                                                                            CustLedgEntry."Amount to Apply" := 0;
                                                                            CODEUNIT.RUN(CODEUNIT::"Cust. Entry-Edit",CustLedgEntry);
                                                                          END;
                                                                          "Exported to Payment File" := CustLedgEntry."Exported to Payment File";
                                                                          "Applies-to Ext. Doc. No." := '';
                                                                        END;
                                                                      END;
                                                                    TempGenJnlLine."Account Type"::Vendor:
                                                                      BEGIN
                                                                        VendLedgEntry.SETCURRENTKEY("Document No.");
                                                                        VendLedgEntry.SETRANGE("Document No.",xRec."Applies-to Doc. No.");
                                                                        IF NOT (xRec."Applies-to Doc. Type" = "Document Type"::" ") THEN
                                                                          VendLedgEntry.SETRANGE("Document Type",xRec."Applies-to Doc. Type");
                                                                        VendLedgEntry.SETRANGE("Vendor No.",TempGenJnlLine."Account No.");
                                                                        VendLedgEntry.SETRANGE(Open,TRUE);
                                                                        IF VendLedgEntry.FINDFIRST THEN BEGIN
                                                                          IF VendLedgEntry."Amount to Apply" <> 0 THEN  BEGIN
                                                                            VendLedgEntry."Amount to Apply" := 0;
                                                                            CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit",VendLedgEntry);
                                                                          END;
                                                                          "Exported to Payment File" := VendLedgEntry."Exported to Payment File";
                                                                        END;
                                                                        "Applies-to Ext. Doc. No." := '';
                                                                      END;
                                                                    TempGenJnlLine."Account Type"::Employee:
                                                                      BEGIN
                                                                        EmplLedgEntry.SETCURRENTKEY("Document No.");
                                                                        EmplLedgEntry.SETRANGE("Document No.",xRec."Applies-to Doc. No.");
                                                                        IF NOT (xRec."Applies-to Doc. Type" = "Document Type"::" ") THEN
                                                                          EmplLedgEntry.SETRANGE("Document Type",xRec."Applies-to Doc. Type");
                                                                        EmplLedgEntry.SETRANGE("Employee No.",TempGenJnlLine."Account No.");
                                                                        EmplLedgEntry.SETRANGE(Open,TRUE);
                                                                        IF EmplLedgEntry.FINDFIRST THEN BEGIN
                                                                          IF EmplLedgEntry."Amount to Apply" <> 0 THEN BEGIN
                                                                            EmplLedgEntry."Amount to Apply" := 0;
                                                                            CODEUNIT.RUN(CODEUNIT::"Empl. Entry-Edit",EmplLedgEntry);
                                                                          END;
                                                                          "Exported to Payment File" := EmplLedgEntry."Exported to Payment File";
                                                                        END;
                                                                      END;
                                                                  END;
                                                                END;

                                                                IF ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") AND (Amount <> 0) THEN BEGIN
                                                                  IF xRec."Applies-to Doc. No." <> '' THEN
                                                                    PaymentToleranceMgt.DelPmtTolApllnDocNo(Rec,xRec."Applies-to Doc. No.");
                                                                  SetApplyToAmount;
                                                                  PaymentToleranceMgt.PmtTolGenJnl(Rec);
                                                                  xRec.ClearAppliedGenJnlLine;
                                                                END;

                                                                CASE "Account Type" OF
                                                                  "Account Type"::Customer:
                                                                    GetCustLedgerEntry;
                                                                  "Account Type"::Vendor:
                                                                    GetVendLedgerEntry;
                                                                  "Account Type"::Employee:
                                                                    GetEmplLedgerEntry;
                                                                END;

                                                                ValidateApplyRequirements(Rec);
                                                                SetJournalLineFieldsFromApplication;

                                                                IF "Applies-to Doc. Type" = "Applies-to Doc. Type"::Invoice THEN
                                                                  UpdateAppliesToInvoiceID;
                                                              END;

                                                   OnLookup=VAR
                                                              PaymentToleranceMgt@1001 : Codeunit 426;
                                                              AccType@1002 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee';
                                                              AccNo@1003 : Code[20];
                                                            BEGIN
                                                              xRec.Amount := Amount;
                                                              xRec."Currency Code" := "Currency Code";
                                                              xRec."Posting Date" := "Posting Date";

                                                              GetAccTypeAndNo(Rec,AccType,AccNo);
                                                              CLEAR(CustLedgEntry);
                                                              CLEAR(VendLedgEntry);

                                                              CASE AccType OF
                                                                AccType::Customer:
                                                                  LookUpAppliesToDocCust(AccNo);
                                                                AccType::Vendor:
                                                                  LookUpAppliesToDocVend(AccNo);
                                                                AccType::Employee:
                                                                  LookUpAppliesToDocEmpl(AccNo);
                                                              END;
                                                              SetJournalLineFieldsFromApplication;

                                                              IF xRec.Amount <> 0 THEN
                                                                IF NOT PaymentToleranceMgt.PmtTolGenJnl(Rec) THEN
                                                                  EXIT;

                                                              IF "Applies-to Doc. Type" = "Applies-to Doc. Type"::Invoice THEN
                                                                UpdateAppliesToInvoiceID;
                                                            END;

                                                   CaptionML=[DAN=Udligningsbilagsnr.;
                                                              ENU=Applies-to Doc. No.] }
    { 38  ;   ;Due Date            ;Date          ;CaptionML=[DAN=Forfaldsdato;
                                                              ENU=Due Date] }
    { 39  ;   ;Pmt. Discount Date  ;Date          ;CaptionML=[DAN=Kont.rabatdato;
                                                              ENU=Pmt. Discount Date] }
    { 40  ;   ;Payment Discount %  ;Decimal       ;CaptionML=[DAN=Kontantrabatpct.;
                                                              ENU=Payment Discount %];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   MaxValue=100 }
    { 42  ;   ;Job No.             ;Code20        ;TableRelation=Job;
                                                   OnValidate=BEGIN
                                                                IF "Job No." = xRec."Job No." THEN
                                                                  EXIT;

                                                                SourceCodeSetup.GET;
                                                                IF "Source Code" <> SourceCodeSetup."Job G/L WIP" THEN
                                                                  VALIDATE("Job Task No.",'');
                                                                IF "Job No." = '' THEN BEGIN
                                                                  CreateDim(
                                                                    DATABASE::Job,"Job No.",
                                                                    DimMgt.TypeToTableID1("Account Type"),"Account No.",
                                                                    DimMgt.TypeToTableID1("Bal. Account Type"),"Bal. Account No.",
                                                                    DATABASE::"Salesperson/Purchaser","Salespers./Purch. Code",
                                                                    DATABASE::Campaign,"Campaign No.");
                                                                  EXIT;
                                                                END;

                                                                TESTFIELD("Account Type","Account Type"::"G/L Account");

                                                                IF "Bal. Account No." <> '' THEN
                                                                  IF NOT ("Bal. Account Type" IN ["Bal. Account Type"::"G/L Account","Bal. Account Type"::"Bank Account"]) THEN
                                                                    ERROR(Text016,FIELDCAPTION("Bal. Account Type"));

                                                                Job.GET("Job No.");
                                                                Job.TestBlocked;
                                                                "Job Currency Code" := Job."Currency Code";

                                                                CreateDim(
                                                                  DATABASE::Job,"Job No.",
                                                                  DimMgt.TypeToTableID1("Account Type"),"Account No.",
                                                                  DimMgt.TypeToTableID1("Bal. Account Type"),"Bal. Account No.",
                                                                  DATABASE::"Salesperson/Purchaser","Salespers./Purch. Code",
                                                                  DATABASE::Campaign,"Campaign No.");
                                                              END;

                                                   CaptionML=[DAN=Sagsnr.;
                                                              ENU=Job No.] }
    { 43  ;   ;Quantity            ;Decimal       ;OnValidate=BEGIN
                                                                VALIDATE(Amount);
                                                              END;

                                                   CaptionML=[DAN=Antal;
                                                              ENU=Quantity];
                                                   DecimalPlaces=0:5 }
    { 44  ;   ;VAT Amount          ;Decimal       ;OnValidate=BEGIN
                                                                GenJnlBatch.GET("Journal Template Name","Journal Batch Name");
                                                                GenJnlBatch.TESTFIELD("Allow VAT Difference",TRUE);
                                                                IF NOT ("VAT Calculation Type" IN
                                                                        ["VAT Calculation Type"::"Normal VAT","VAT Calculation Type"::"Reverse Charge VAT"])
                                                                THEN
                                                                  ERROR(
                                                                    Text010,FIELDCAPTION("VAT Calculation Type"),
                                                                    "VAT Calculation Type"::"Normal VAT","VAT Calculation Type"::"Reverse Charge VAT");
                                                                IF "VAT Amount" <> 0 THEN BEGIN
                                                                  TESTFIELD("VAT %");
                                                                  TESTFIELD(Amount);
                                                                END;

                                                                GetCurrency;
                                                                "VAT Amount" := ROUND("VAT Amount",Currency."Amount Rounding Precision",Currency.VATRoundingDirection);

                                                                IF "VAT Amount" * Amount < 0 THEN
                                                                  IF "VAT Amount" > 0 THEN
                                                                    ERROR(Text011,FIELDCAPTION("VAT Amount"))
                                                                  ELSE
                                                                    ERROR(Text012,FIELDCAPTION("VAT Amount"));

                                                                "VAT Base Amount" := Amount - "VAT Amount";

                                                                "VAT Difference" :=
                                                                  "VAT Amount" -
                                                                  ROUND(
                                                                    Amount * "VAT %" / (100 + "VAT %"),
                                                                    Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
                                                                IF ABS("VAT Difference") > Currency."Max. VAT Difference Allowed" THEN
                                                                  ERROR(Text013,FIELDCAPTION("VAT Difference"),Currency."Max. VAT Difference Allowed");

                                                                IF "Currency Code" = '' THEN
                                                                  "VAT Amount (LCY)" := "VAT Amount"
                                                                ELSE
                                                                  "VAT Amount (LCY)" :=
                                                                    ROUND(
                                                                      CurrExchRate.ExchangeAmtFCYToLCY(
                                                                        "Posting Date","Currency Code",
                                                                        "VAT Amount","Currency Factor"));
                                                                "VAT Base Amount (LCY)" := "Amount (LCY)" - "VAT Amount (LCY)";

                                                                UpdateSalesPurchLCY;

                                                                IF JobTaskIsSet THEN BEGIN
                                                                  CreateTempJobJnlLine;
                                                                  UpdatePricesFromJobJnlLine;
                                                                END;

                                                                IF "Deferral Code" <> '' THEN
                                                                  VALIDATE("Deferral Code");
                                                              END;

                                                   CaptionML=[DAN=Momsbel�b;
                                                              ENU=VAT Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 45  ;   ;VAT Posting         ;Option        ;CaptionML=[DAN=Momsbogf�ring;
                                                              ENU=VAT Posting];
                                                   OptionCaptionML=[DAN=Automatisk momspost,Manuel momspost;
                                                                    ENU=Automatic VAT Entry,Manual VAT Entry];
                                                   OptionString=Automatic VAT Entry,Manual VAT Entry;
                                                   Editable=No }
    { 47  ;   ;Payment Terms Code  ;Code10        ;TableRelation="Payment Terms";
                                                   OnValidate=BEGIN
                                                                "Due Date" := 0D;
                                                                "Pmt. Discount Date" := 0D;
                                                                "Payment Discount %" := 0;
                                                                IF ("Account Type" <> "Account Type"::"G/L Account") OR
                                                                   ("Bal. Account Type" <> "Bal. Account Type"::"G/L Account")
                                                                THEN
                                                                  CASE "Document Type" OF
                                                                    "Document Type"::Invoice:
                                                                      IF ("Payment Terms Code" <> '') AND ("Document Date" <> 0D) THEN BEGIN
                                                                        PaymentTerms.GET("Payment Terms Code");
                                                                        "Due Date" := CALCDATE(PaymentTerms."Due Date Calculation","Document Date");
                                                                        "Pmt. Discount Date" := CALCDATE(PaymentTerms."Discount Date Calculation","Document Date");
                                                                        "Payment Discount %" := PaymentTerms."Discount %";
                                                                      END;
                                                                    "Document Type"::"Credit Memo":
                                                                      IF ("Payment Terms Code" <> '') AND ("Document Date" <> 0D) THEN BEGIN
                                                                        PaymentTerms.GET("Payment Terms Code");
                                                                        IF PaymentTerms."Calc. Pmt. Disc. on Cr. Memos" THEN BEGIN
                                                                          "Due Date" := CALCDATE(PaymentTerms."Due Date Calculation","Document Date");
                                                                          "Pmt. Discount Date" :=
                                                                            CALCDATE(PaymentTerms."Discount Date Calculation","Document Date");
                                                                          "Payment Discount %" := PaymentTerms."Discount %";
                                                                        END ELSE
                                                                          "Due Date" := "Document Date";
                                                                      END;
                                                                    ELSE
                                                                      "Due Date" := "Document Date";
                                                                  END;
                                                              END;

                                                   CaptionML=[DAN=Betalingsbeting.kode;
                                                              ENU=Payment Terms Code] }
    { 48  ;   ;Applies-to ID       ;Code50        ;OnValidate=BEGIN
                                                                IF ("Applies-to ID" <> xRec."Applies-to ID") AND (xRec."Applies-to ID" <> '') THEN
                                                                  ClearCustVendApplnEntry;
                                                                SetJournalLineFieldsFromApplication;
                                                              END;

                                                   CaptionML=[DAN=Udlignings-id;
                                                              ENU=Applies-to ID] }
    { 50  ;   ;Business Unit Code  ;Code20        ;TableRelation="Business Unit";
                                                   CaptionML=[DAN=Konc.virksomhedskode;
                                                              ENU=Business Unit Code] }
    { 51  ;   ;Journal Batch Name  ;Code10        ;TableRelation="Gen. Journal Batch".Name WHERE (Journal Template Name=FIELD(Journal Template Name));
                                                   OnValidate=BEGIN
                                                                UpdateJournalBatchID;
                                                              END;

                                                   CaptionML=[DAN=Kladdenavn;
                                                              ENU=Journal Batch Name] }
    { 52  ;   ;Reason Code         ;Code10        ;TableRelation="Reason Code";
                                                   CaptionML=[DAN=�rsagskode;
                                                              ENU=Reason Code] }
    { 53  ;   ;Recurring Method    ;Option        ;OnValidate=BEGIN
                                                                IF "Recurring Method" IN
                                                                   ["Recurring Method"::"B  Balance","Recurring Method"::"RB Reversing Balance"]
                                                                THEN
                                                                  TESTFIELD("Currency Code",'');
                                                              END;

                                                   CaptionML=[DAN=Gentagelsesprincip;
                                                              ENU=Recurring Method];
                                                   OptionCaptionML=[DAN=" ,F  Fast,V  Variabel,S  Saldo,FT Fast med tilbagef�ring,VT Variabel med tilbagef�ring,ST Saldo med tilbagef�ring";
                                                                    ENU=" ,F  Fixed,V  Variable,B  Balance,RF Reversing Fixed,RV Reversing Variable,RB Reversing Balance"];
                                                   OptionString=[ ,F  Fixed,V  Variable,B  Balance,RF Reversing Fixed,RV Reversing Variable,RB Reversing Balance];
                                                   BlankZero=Yes }
    { 54  ;   ;Expiration Date     ;Date          ;CaptionML=[DAN=Udl�bsdato;
                                                              ENU=Expiration Date] }
    { 55  ;   ;Recurring Frequency ;DateFormula   ;CaptionML=[DAN=Gentagelsesinterval;
                                                              ENU=Recurring Frequency] }
    { 56  ;   ;Allocated Amt. (LCY);Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Gen. Jnl. Allocation".Amount WHERE (Journal Template Name=FIELD(Journal Template Name),
                                                                                                        Journal Batch Name=FIELD(Journal Batch Name),
                                                                                                        Journal Line No.=FIELD(Line No.)));
                                                   CaptionML=[DAN=Fordelt bel�b (RV);
                                                              ENU=Allocated Amt. (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 57  ;   ;Gen. Posting Type   ;Option        ;OnValidate=BEGIN
                                                                IF "Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor,"Account Type"::"Bank Account"] THEN
                                                                  TESTFIELD("Gen. Posting Type","Gen. Posting Type"::" ");
                                                                IF ("Gen. Posting Type" = "Gen. Posting Type"::Settlement) AND (CurrFieldNo <> 0) THEN
                                                                  ERROR(Text006,"Gen. Posting Type");
                                                                CheckVATInAlloc;
                                                                IF "Gen. Posting Type" > 0 THEN
                                                                  VALIDATE("VAT Prod. Posting Group");
                                                                IF "Gen. Posting Type" <> "Gen. Posting Type"::Purchase THEN
                                                                  VALIDATE("Use Tax",FALSE)
                                                              END;

                                                   CaptionML=[DAN=Bogf�ringstype;
                                                              ENU=Gen. Posting Type];
                                                   OptionCaptionML=[DAN=" ,K�b,Salg,Afregning";
                                                                    ENU=" ,Purchase,Sale,Settlement"];
                                                   OptionString=[ ,Purchase,Sale,Settlement] }
    { 58  ;   ;Gen. Bus. Posting Group;Code20     ;TableRelation="Gen. Business Posting Group";
                                                   OnValidate=BEGIN
                                                                IF "Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor,"Account Type"::"Bank Account"] THEN
                                                                  TESTFIELD("Gen. Bus. Posting Group",'');
                                                                IF xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group" THEN
                                                                  IF GenBusPostingGrp.ValidateVatBusPostingGroup(GenBusPostingGrp,"Gen. Bus. Posting Group") THEN
                                                                    VALIDATE("VAT Bus. Posting Group",GenBusPostingGrp."Def. VAT Bus. Posting Group");
                                                              END;

                                                   CaptionML=[DAN=Virksomhedsbogf�ringsgruppe;
                                                              ENU=Gen. Bus. Posting Group] }
    { 59  ;   ;Gen. Prod. Posting Group;Code20    ;TableRelation="Gen. Product Posting Group";
                                                   OnValidate=BEGIN
                                                                IF "Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor,"Account Type"::"Bank Account"] THEN
                                                                  TESTFIELD("Gen. Prod. Posting Group",'');
                                                                IF xRec."Gen. Prod. Posting Group" <> "Gen. Prod. Posting Group" THEN
                                                                  IF GenProdPostingGrp.ValidateVatProdPostingGroup(GenProdPostingGrp,"Gen. Prod. Posting Group") THEN
                                                                    VALIDATE("VAT Prod. Posting Group",GenProdPostingGrp."Def. VAT Prod. Posting Group");
                                                              END;

                                                   CaptionML=[DAN=Produktbogf�ringsgruppe;
                                                              ENU=Gen. Prod. Posting Group] }
    { 60  ;   ;VAT Calculation Type;Option        ;CaptionML=[DAN=Momsberegningstype;
                                                              ENU=VAT Calculation Type];
                                                   OptionCaptionML=[DAN=Normal moms,Modtagermoms,Momskorrektion,Sales tax;
                                                                    ENU=Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax];
                                                   OptionString=Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax;
                                                   Editable=No }
    { 61  ;   ;EU 3-Party Trade    ;Boolean       ;CaptionML=[DAN=Trekantshandel;
                                                              ENU=EU 3-Party Trade];
                                                   Editable=No }
    { 62  ;   ;Allow Application   ;Boolean       ;InitValue=Yes;
                                                   CaptionML=[DAN=Tillad udligning;
                                                              ENU=Allow Application] }
    { 63  ;   ;Bal. Account Type   ;Option        ;OnValidate=BEGIN
                                                                IF ("Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor,"Account Type"::"Fixed Asset",
                                                                                       "Account Type"::"IC Partner","Account Type"::Employee]) AND
                                                                   ("Bal. Account Type" IN ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor,"Bal. Account Type"::"Fixed Asset",
                                                                                            "Bal. Account Type"::"IC Partner","Bal. Account Type"::Employee])
                                                                THEN
                                                                  ERROR(
                                                                    Text000,
                                                                    FIELDCAPTION("Account Type"),FIELDCAPTION("Bal. Account Type"));

                                                                IF ("Bal. Account Type" = "Bal. Account Type"::Employee) AND ("Currency Code" <> '') THEN
                                                                  ERROR(OnlyLocalCurrencyForEmployeeErr);

                                                                VALIDATE("Bal. Account No.",'');
                                                                VALIDATE("IC Partner G/L Acc. No.",'');
                                                                IF "Bal. Account Type" IN
                                                                   ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor,"Bal. Account Type"::"Bank Account","Bal. Account Type"::Employee]
                                                                THEN BEGIN
                                                                  VALIDATE("Bal. Gen. Posting Type","Bal. Gen. Posting Type"::" ");
                                                                  VALIDATE("Bal. Gen. Bus. Posting Group",'');
                                                                  VALIDATE("Bal. Gen. Prod. Posting Group",'');
                                                                END ELSE
                                                                  IF "Account Type" IN [
                                                                                        "Bal. Account Type"::"G/L Account","Account Type"::"Bank Account","Account Type"::"Fixed Asset"]
                                                                  THEN
                                                                    VALIDATE("Payment Terms Code",'');

                                                                UpdateSource;
                                                                IF ("Account Type" <> "Account Type"::"Fixed Asset") AND
                                                                   ("Bal. Account Type" <> "Bal. Account Type"::"Fixed Asset")
                                                                THEN BEGIN
                                                                  "Depreciation Book Code" := '';
                                                                  VALIDATE("FA Posting Type","FA Posting Type"::" ");
                                                                END;
                                                                IF xRec."Bal. Account Type" IN
                                                                   [xRec."Bal. Account Type"::Customer,xRec."Bal. Account Type"::Vendor]
                                                                THEN BEGIN
                                                                  "Bill-to/Pay-to No." := '';
                                                                  "Ship-to/Order Address Code" := '';
                                                                  "Sell-to/Buy-from No." := '';
                                                                  "VAT Registration No." := '';
                                                                END;
                                                                IF ("Account Type" IN [
                                                                                       "Account Type"::"G/L Account","Account Type"::"Bank Account","Account Type"::"Fixed Asset"]) AND
                                                                   ("Bal. Account Type" IN [
                                                                                            "Bal. Account Type"::"G/L Account","Bal. Account Type"::"Bank Account","Bal. Account Type"::"Fixed Asset"])
                                                                THEN
                                                                  VALIDATE("Payment Terms Code",'');

                                                                IF "Bal. Account Type" = "Bal. Account Type"::"IC Partner" THEN BEGIN
                                                                  GetTemplate;
                                                                  IF GenJnlTemplate.Type <> GenJnlTemplate.Type::Intercompany THEN
                                                                    FIELDERROR("Bal. Account Type");
                                                                END;
                                                                IF "Bal. Account Type" <> "Bal. Account Type"::"Bank Account" THEN
                                                                  VALIDATE("Credit Card No.",'');
                                                              END;

                                                   CaptionML=[DAN=Modkontotype;
                                                              ENU=Bal. Account Type];
                                                   OptionCaptionML=[DAN=Finanskonto,Debitor,Kreditor,Bankkonto,Anl�g,IC-partner,Medarbejder;
                                                                    ENU=G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee];
                                                   OptionString=G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee }
    { 64  ;   ;Bal. Gen. Posting Type;Option      ;OnValidate=BEGIN
                                                                IF "Bal. Account Type" IN ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor,"Bal. Account Type"::"Bank Account"] THEN
                                                                  TESTFIELD("Bal. Gen. Posting Type","Bal. Gen. Posting Type"::" ");
                                                                IF ("Bal. Gen. Posting Type" = "Gen. Posting Type"::Settlement) AND (CurrFieldNo <> 0) THEN
                                                                  ERROR(Text006,"Bal. Gen. Posting Type");
                                                                IF "Bal. Gen. Posting Type" > 0 THEN
                                                                  VALIDATE("Bal. VAT Prod. Posting Group");

                                                                IF ("Account Type" <> "Account Type"::"Fixed Asset") AND
                                                                   ("Bal. Account Type" <> "Bal. Account Type"::"Fixed Asset")
                                                                THEN BEGIN
                                                                  "Depreciation Book Code" := '';
                                                                  VALIDATE("FA Posting Type","FA Posting Type"::" ");
                                                                END;
                                                                IF "Bal. Gen. Posting Type" <> "Bal. Gen. Posting Type"::Purchase THEN
                                                                  VALIDATE("Bal. Use Tax",FALSE);
                                                              END;

                                                   CaptionML=[DAN=Modkontos bogf�ringstype;
                                                              ENU=Bal. Gen. Posting Type];
                                                   OptionCaptionML=[DAN=" ,K�b,Salg,Afregning";
                                                                    ENU=" ,Purchase,Sale,Settlement"];
                                                   OptionString=[ ,Purchase,Sale,Settlement] }
    { 65  ;   ;Bal. Gen. Bus. Posting Group;Code20;TableRelation="Gen. Business Posting Group";
                                                   OnValidate=BEGIN
                                                                IF "Bal. Account Type" IN ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor,"Bal. Account Type"::"Bank Account"] THEN
                                                                  TESTFIELD("Bal. Gen. Bus. Posting Group",'');
                                                                IF xRec."Bal. Gen. Bus. Posting Group" <> "Bal. Gen. Bus. Posting Group" THEN
                                                                  IF GenBusPostingGrp.ValidateVatBusPostingGroup(GenBusPostingGrp,"Bal. Gen. Bus. Posting Group") THEN
                                                                    VALIDATE("Bal. VAT Bus. Posting Group",GenBusPostingGrp."Def. VAT Bus. Posting Group");
                                                              END;

                                                   CaptionML=[DAN=Modkontos virksomhedsbogf.grp.;
                                                              ENU=Bal. Gen. Bus. Posting Group] }
    { 66  ;   ;Bal. Gen. Prod. Posting Group;Code20;
                                                   TableRelation="Gen. Product Posting Group";
                                                   OnValidate=BEGIN
                                                                IF "Bal. Account Type" IN ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor,"Bal. Account Type"::"Bank Account"] THEN
                                                                  TESTFIELD("Bal. Gen. Prod. Posting Group",'');
                                                                IF xRec."Bal. Gen. Prod. Posting Group" <> "Bal. Gen. Prod. Posting Group" THEN
                                                                  IF GenProdPostingGrp.ValidateVatProdPostingGroup(GenProdPostingGrp,"Bal. Gen. Prod. Posting Group") THEN
                                                                    VALIDATE("Bal. VAT Prod. Posting Group",GenProdPostingGrp."Def. VAT Prod. Posting Group");
                                                              END;

                                                   CaptionML=[DAN=Modkontos produktbogf.grp.;
                                                              ENU=Bal. Gen. Prod. Posting Group] }
    { 67  ;   ;Bal. VAT Calculation Type;Option   ;CaptionML=[DAN=Modkontos momsberegningstype;
                                                              ENU=Bal. VAT Calculation Type];
                                                   OptionCaptionML=[DAN=Normal moms,Modtagermoms,Momskorrektion,Sales tax;
                                                                    ENU=Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax];
                                                   OptionString=Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax;
                                                   Editable=No }
    { 68  ;   ;Bal. VAT %          ;Decimal       ;OnValidate=BEGIN
                                                                GetCurrency;
                                                                CASE "Bal. VAT Calculation Type" OF
                                                                  "Bal. VAT Calculation Type"::"Normal VAT",
                                                                  "Bal. VAT Calculation Type"::"Reverse Charge VAT":
                                                                    BEGIN
                                                                      "Bal. VAT Amount" :=
                                                                        ROUND(-Amount * "Bal. VAT %" / (100 + "Bal. VAT %"),Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
                                                                      "Bal. VAT Base Amount" :=
                                                                        ROUND(-Amount - "Bal. VAT Amount",Currency."Amount Rounding Precision");
                                                                    END;
                                                                  "Bal. VAT Calculation Type"::"Full VAT":
                                                                    "Bal. VAT Amount" := -Amount;
                                                                  "Bal. VAT Calculation Type"::"Sales Tax":
                                                                    IF ("Bal. Gen. Posting Type" = "Bal. Gen. Posting Type"::Purchase) AND
                                                                       "Bal. Use Tax"
                                                                    THEN BEGIN
                                                                      "Bal. VAT Amount" := 0;
                                                                      "Bal. VAT %" := 0;
                                                                    END ELSE BEGIN
                                                                      "Bal. VAT Amount" :=
                                                                        -(Amount -
                                                                          SalesTaxCalculate.ReverseCalculateTax(
                                                                            "Bal. Tax Area Code","Bal. Tax Group Code","Bal. Tax Liable",
                                                                            "Posting Date",Amount,Quantity,"Currency Factor"));
                                                                      IF Amount + "Bal. VAT Amount" <> 0 THEN
                                                                        "Bal. VAT %" := ROUND(100 * -"Bal. VAT Amount" / (Amount + "Bal. VAT Amount"),0.00001)
                                                                      ELSE
                                                                        "Bal. VAT %" := 0;
                                                                      "Bal. VAT Amount" :=
                                                                        ROUND("Bal. VAT Amount",Currency."Amount Rounding Precision");
                                                                    END;
                                                                END;
                                                                "Bal. VAT Base Amount" := -(Amount + "Bal. VAT Amount");
                                                                "Bal. VAT Difference" := 0;

                                                                IF "Currency Code" = '' THEN
                                                                  "Bal. VAT Amount (LCY)" := "Bal. VAT Amount"
                                                                ELSE
                                                                  "Bal. VAT Amount (LCY)" :=
                                                                    ROUND(
                                                                      CurrExchRate.ExchangeAmtFCYToLCY(
                                                                        "Posting Date","Currency Code",
                                                                        "Bal. VAT Amount","Currency Factor"));
                                                                "Bal. VAT Base Amount (LCY)" := -("Amount (LCY)" + "Bal. VAT Amount (LCY)");

                                                                UpdateSalesPurchLCY;
                                                              END;

                                                   CaptionML=[DAN=Modkontos momspct.;
                                                              ENU=Bal. VAT %];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   MaxValue=100;
                                                   Editable=No }
    { 69  ;   ;Bal. VAT Amount     ;Decimal       ;OnValidate=BEGIN
                                                                GenJnlBatch.GET("Journal Template Name","Journal Batch Name");
                                                                GenJnlBatch.TESTFIELD("Allow VAT Difference",TRUE);
                                                                IF NOT ("Bal. VAT Calculation Type" IN
                                                                        ["Bal. VAT Calculation Type"::"Normal VAT","Bal. VAT Calculation Type"::"Reverse Charge VAT"])
                                                                THEN
                                                                  ERROR(
                                                                    Text010,FIELDCAPTION("Bal. VAT Calculation Type"),
                                                                    "Bal. VAT Calculation Type"::"Normal VAT","Bal. VAT Calculation Type"::"Reverse Charge VAT");
                                                                IF "Bal. VAT Amount" <> 0 THEN BEGIN
                                                                  TESTFIELD("Bal. VAT %");
                                                                  TESTFIELD(Amount);
                                                                END;

                                                                GetCurrency;
                                                                "Bal. VAT Amount" :=
                                                                  ROUND("Bal. VAT Amount",Currency."Amount Rounding Precision",Currency.VATRoundingDirection);

                                                                IF "Bal. VAT Amount" * Amount > 0 THEN
                                                                  IF "Bal. VAT Amount" > 0 THEN
                                                                    ERROR(Text011,FIELDCAPTION("Bal. VAT Amount"))
                                                                  ELSE
                                                                    ERROR(Text012,FIELDCAPTION("Bal. VAT Amount"));

                                                                "Bal. VAT Base Amount" := -(Amount + "Bal. VAT Amount");

                                                                "Bal. VAT Difference" :=
                                                                  "Bal. VAT Amount" -
                                                                  ROUND(
                                                                    -Amount * "Bal. VAT %" / (100 + "Bal. VAT %"),
                                                                    Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
                                                                IF ABS("Bal. VAT Difference") > Currency."Max. VAT Difference Allowed" THEN
                                                                  ERROR(
                                                                    Text013,FIELDCAPTION("Bal. VAT Difference"),Currency."Max. VAT Difference Allowed");

                                                                IF "Currency Code" = '' THEN
                                                                  "Bal. VAT Amount (LCY)" := "Bal. VAT Amount"
                                                                ELSE
                                                                  "Bal. VAT Amount (LCY)" :=
                                                                    ROUND(
                                                                      CurrExchRate.ExchangeAmtFCYToLCY(
                                                                        "Posting Date","Currency Code",
                                                                        "Bal. VAT Amount","Currency Factor"));
                                                                "Bal. VAT Base Amount (LCY)" := -("Amount (LCY)" + "Bal. VAT Amount (LCY)");

                                                                UpdateSalesPurchLCY;
                                                              END;

                                                   CaptionML=[DAN=Modkontos momsbel�b;
                                                              ENU=Bal. VAT Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 70  ;   ;Bank Payment Type   ;Option        ;OnValidate=BEGIN
                                                                IF ("Bank Payment Type" <> "Bank Payment Type"::" ") AND
                                                                   ("Account Type" <> "Account Type"::"Bank Account") AND
                                                                   ("Bal. Account Type" <> "Bal. Account Type"::"Bank Account")
                                                                THEN
                                                                  ERROR(
                                                                    Text007,
                                                                    FIELDCAPTION("Account Type"),FIELDCAPTION("Bal. Account Type"));
                                                                IF ("Account Type" = "Account Type"::"Fixed Asset") AND
                                                                   ("Bank Payment Type" <> "Bank Payment Type"::" ")
                                                                THEN
                                                                  FIELDERROR("Account Type");
                                                              END;

                                                   AccessByPermission=TableData 270=R;
                                                   CaptionML=[DAN=Bankbetalingstype;
                                                              ENU=Bank Payment Type];
                                                   OptionCaptionML=[DAN=" ,Computercheck,Manuel check,Elektronisk betaling,Elektronisk betaling-IAT";
                                                                    ENU=" ,Computer Check,Manual Check,Electronic Payment,Electronic Payment-IAT"];
                                                   OptionString=[ ,Computer Check,Manual Check,Electronic Payment,Electronic Payment-IAT] }
    { 71  ;   ;VAT Base Amount     ;Decimal       ;OnValidate=BEGIN
                                                                GetCurrency;
                                                                "VAT Base Amount" := ROUND("VAT Base Amount",Currency."Amount Rounding Precision");
                                                                CASE "VAT Calculation Type" OF
                                                                  "VAT Calculation Type"::"Normal VAT",
                                                                  "VAT Calculation Type"::"Reverse Charge VAT":
                                                                    Amount :=
                                                                      ROUND(
                                                                        "VAT Base Amount" * (1 + "VAT %" / 100),
                                                                        Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
                                                                  "VAT Calculation Type"::"Full VAT":
                                                                    IF "VAT Base Amount" <> 0 THEN
                                                                      FIELDERROR(
                                                                        "VAT Base Amount",
                                                                        STRSUBSTNO(
                                                                          Text008,FIELDCAPTION("VAT Calculation Type"),
                                                                          "VAT Calculation Type"));
                                                                  "VAT Calculation Type"::"Sales Tax":
                                                                    IF ("Gen. Posting Type" = "Gen. Posting Type"::Purchase) AND
                                                                       "Use Tax"
                                                                    THEN BEGIN
                                                                      "VAT Amount" := 0;
                                                                      "VAT %" := 0;
                                                                      Amount := "VAT Base Amount" + "VAT Amount";
                                                                    END ELSE BEGIN
                                                                      "VAT Amount" :=
                                                                        SalesTaxCalculate.CalculateTax(
                                                                          "Tax Area Code","Tax Group Code","Tax Liable","Posting Date",
                                                                          "VAT Base Amount",Quantity,"Currency Factor");
                                                                      IF "VAT Base Amount" <> 0 THEN
                                                                        "VAT %" := ROUND(100 * "VAT Amount" / "VAT Base Amount",0.00001)
                                                                      ELSE
                                                                        "VAT %" := 0;
                                                                      "VAT Amount" :=
                                                                        ROUND("VAT Amount",Currency."Amount Rounding Precision");
                                                                      Amount := "VAT Base Amount" + "VAT Amount";
                                                                    END;
                                                                END;
                                                                VALIDATE(Amount);
                                                              END;

                                                   CaptionML=[DAN=Momsgrundlag (bel�b);
                                                              ENU=VAT Base Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 72  ;   ;Bal. VAT Base Amount;Decimal       ;OnValidate=BEGIN
                                                                GetCurrency;
                                                                "Bal. VAT Base Amount" := ROUND("Bal. VAT Base Amount",Currency."Amount Rounding Precision");
                                                                CASE "Bal. VAT Calculation Type" OF
                                                                  "Bal. VAT Calculation Type"::"Normal VAT",
                                                                  "Bal. VAT Calculation Type"::"Reverse Charge VAT":
                                                                    Amount :=
                                                                      ROUND(
                                                                        -"Bal. VAT Base Amount" * (1 + "Bal. VAT %" / 100),
                                                                        Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
                                                                  "Bal. VAT Calculation Type"::"Full VAT":
                                                                    IF "Bal. VAT Base Amount" <> 0 THEN
                                                                      FIELDERROR(
                                                                        "Bal. VAT Base Amount",
                                                                        STRSUBSTNO(
                                                                          Text008,FIELDCAPTION("Bal. VAT Calculation Type"),
                                                                          "Bal. VAT Calculation Type"));
                                                                  "Bal. VAT Calculation Type"::"Sales Tax":
                                                                    IF ("Bal. Gen. Posting Type" = "Bal. Gen. Posting Type"::Purchase) AND
                                                                       "Bal. Use Tax"
                                                                    THEN BEGIN
                                                                      "Bal. VAT Amount" := 0;
                                                                      "Bal. VAT %" := 0;
                                                                      Amount := -"Bal. VAT Base Amount" - "Bal. VAT Amount";
                                                                    END ELSE BEGIN
                                                                      "Bal. VAT Amount" :=
                                                                        SalesTaxCalculate.CalculateTax(
                                                                          "Bal. Tax Area Code","Bal. Tax Group Code","Bal. Tax Liable",
                                                                          "Posting Date","Bal. VAT Base Amount",Quantity,"Currency Factor");
                                                                      IF "Bal. VAT Base Amount" <> 0 THEN
                                                                        "Bal. VAT %" := ROUND(100 * "Bal. VAT Amount" / "Bal. VAT Base Amount",0.00001)
                                                                      ELSE
                                                                        "Bal. VAT %" := 0;
                                                                      "Bal. VAT Amount" :=
                                                                        ROUND("Bal. VAT Amount",Currency."Amount Rounding Precision");
                                                                      Amount := -"Bal. VAT Base Amount" - "Bal. VAT Amount";
                                                                    END;
                                                                END;
                                                                VALIDATE(Amount);
                                                              END;

                                                   CaptionML=[DAN=Modkontos momsgrundlag (bel�b);
                                                              ENU=Bal. VAT Base Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 73  ;   ;Correction          ;Boolean       ;OnValidate=BEGIN
                                                                VALIDATE(Amount);
                                                              END;

                                                   CaptionML=[DAN=Rettelse;
                                                              ENU=Correction] }
    { 75  ;   ;Check Printed       ;Boolean       ;AccessByPermission=TableData 272=R;
                                                   CaptionML=[DAN=Check udskrevet;
                                                              ENU=Check Printed];
                                                   Editable=No }
    { 76  ;   ;Document Date       ;Date          ;OnValidate=BEGIN
                                                                VALIDATE("Payment Terms Code");
                                                              END;

                                                   CaptionML=[DAN=Bilagsdato;
                                                              ENU=Document Date];
                                                   ClosingDates=Yes }
    { 77  ;   ;External Document No.;Code35       ;CaptionML=[DAN=Eksternt bilagsnr.;
                                                              ENU=External Document No.] }
    { 78  ;   ;Source Type         ;Option        ;OnValidate=BEGIN
                                                                IF ("Account Type" <> "Account Type"::"G/L Account") AND ("Account No." <> '') OR
                                                                   ("Bal. Account Type" <> "Bal. Account Type"::"G/L Account") AND ("Bal. Account No." <> '')
                                                                THEN
                                                                  UpdateSource
                                                                ELSE
                                                                  "Source No." := '';
                                                              END;

                                                   CaptionML=[DAN=Kildetype;
                                                              ENU=Source Type];
                                                   OptionCaptionML=[DAN=" ,Debitor,Kreditor,Bankkonto,Anl�g,IC-partner,Medarbejder";
                                                                    ENU=" ,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee"];
                                                   OptionString=[ ,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee] }
    { 79  ;   ;Source No.          ;Code20        ;TableRelation=IF (Source Type=CONST(Customer)) Customer
                                                                 ELSE IF (Source Type=CONST(Vendor)) Vendor
                                                                 ELSE IF (Source Type=CONST(Bank Account)) "Bank Account"
                                                                 ELSE IF (Source Type=CONST(Fixed Asset)) "Fixed Asset"
                                                                 ELSE IF (Source Type=CONST(Employee)) Employee;
                                                   OnValidate=BEGIN
                                                                IF ("Account Type" <> "Account Type"::"G/L Account") AND ("Account No." <> '') OR
                                                                   ("Bal. Account Type" <> "Bal. Account Type"::"G/L Account") AND ("Bal. Account No." <> '')
                                                                THEN
                                                                  UpdateSource;
                                                              END;

                                                   CaptionML=[DAN=Kildenr.;
                                                              ENU=Source No.] }
    { 80  ;   ;Posting No. Series  ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Bogf�ringsnummerserie;
                                                              ENU=Posting No. Series] }
    { 82  ;   ;Tax Area Code       ;Code20        ;TableRelation="Tax Area";
                                                   OnValidate=BEGIN
                                                                VALIDATE("VAT %");
                                                              END;

                                                   CaptionML=[DAN=Skatteomr�dekode;
                                                              ENU=Tax Area Code] }
    { 83  ;   ;Tax Liable          ;Boolean       ;OnValidate=BEGIN
                                                                VALIDATE("VAT %");
                                                              END;

                                                   CaptionML=[DAN=Skattepligtig;
                                                              ENU=Tax Liable] }
    { 84  ;   ;Tax Group Code      ;Code20        ;TableRelation="Tax Group";
                                                   OnValidate=BEGIN
                                                                VALIDATE("VAT %");
                                                              END;

                                                   CaptionML=[DAN=Skattegruppekode;
                                                              ENU=Tax Group Code] }
    { 85  ;   ;Use Tax             ;Boolean       ;OnValidate=BEGIN
                                                                IF NOT "Use Tax" THEN
                                                                  EXIT;
                                                                TESTFIELD("Gen. Posting Type","Gen. Posting Type"::Purchase);
                                                                VALIDATE("VAT %");
                                                              END;

                                                   CaptionML=[DAN=Use Tax;
                                                              ENU=Use Tax] }
    { 86  ;   ;Bal. Tax Area Code  ;Code20        ;TableRelation="Tax Area";
                                                   OnValidate=BEGIN
                                                                VALIDATE("Bal. VAT %");
                                                              END;

                                                   CaptionML=[DAN=Modkontos skatteomr�dekode;
                                                              ENU=Bal. Tax Area Code] }
    { 87  ;   ;Bal. Tax Liable     ;Boolean       ;OnValidate=BEGIN
                                                                VALIDATE("Bal. VAT %");
                                                              END;

                                                   CaptionML=[DAN=Modkto. skattepligtig (bel�b);
                                                              ENU=Bal. Tax Liable] }
    { 88  ;   ;Bal. Tax Group Code ;Code20        ;TableRelation="Tax Group";
                                                   OnValidate=BEGIN
                                                                VALIDATE("Bal. VAT %");
                                                              END;

                                                   CaptionML=[DAN=Modkontos skattegruppekode;
                                                              ENU=Bal. Tax Group Code] }
    { 89  ;   ;Bal. Use Tax        ;Boolean       ;OnValidate=BEGIN
                                                                IF NOT "Bal. Use Tax" THEN
                                                                  EXIT;
                                                                TESTFIELD("Bal. Gen. Posting Type","Bal. Gen. Posting Type"::Purchase);
                                                                VALIDATE("Bal. VAT %");
                                                              END;

                                                   CaptionML=[DAN=Modkontos use tax;
                                                              ENU=Bal. Use Tax] }
    { 90  ;   ;VAT Bus. Posting Group;Code20      ;TableRelation="VAT Business Posting Group";
                                                   OnValidate=BEGIN
                                                                IF "Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor,"Account Type"::"Bank Account"] THEN
                                                                  TESTFIELD("VAT Bus. Posting Group",'');

                                                                VALIDATE("VAT Prod. Posting Group");

                                                                IF JobTaskIsSet THEN BEGIN
                                                                  CreateTempJobJnlLine;
                                                                  UpdatePricesFromJobJnlLine;
                                                                END
                                                              END;

                                                   CaptionML=[DAN=Momsvirksomhedsbogf.gruppe;
                                                              ENU=VAT Bus. Posting Group] }
    { 91  ;   ;VAT Prod. Posting Group;Code20     ;TableRelation="VAT Product Posting Group";
                                                   OnValidate=BEGIN
                                                                IF "Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor,"Account Type"::"Bank Account"] THEN
                                                                  TESTFIELD("VAT Prod. Posting Group",'');

                                                                CheckVATInAlloc;

                                                                "VAT %" := 0;
                                                                "VAT Calculation Type" := "VAT Calculation Type"::"Normal VAT";
                                                                IF "Gen. Posting Type" <> 0 THEN BEGIN
                                                                  IF NOT VATPostingSetup.GET("VAT Bus. Posting Group","VAT Prod. Posting Group") THEN
                                                                    VATPostingSetup.INIT;
                                                                  "VAT Calculation Type" := VATPostingSetup."VAT Calculation Type";
                                                                  CASE "VAT Calculation Type" OF
                                                                    "VAT Calculation Type"::"Normal VAT":
                                                                      "VAT %" := VATPostingSetup."VAT %";
                                                                    "VAT Calculation Type"::"Full VAT":
                                                                      CASE "Gen. Posting Type" OF
                                                                        "Gen. Posting Type"::Sale:
                                                                          TESTFIELD("Account No.",VATPostingSetup.GetSalesAccount(FALSE));
                                                                        "Gen. Posting Type"::Purchase:
                                                                          TESTFIELD("Account No.",VATPostingSetup.GetPurchAccount(FALSE));
                                                                      END;
                                                                  END;
                                                                END;
                                                                VALIDATE("VAT %");

                                                                IF JobTaskIsSet THEN BEGIN
                                                                  CreateTempJobJnlLine;
                                                                  UpdatePricesFromJobJnlLine;
                                                                END
                                                              END;

                                                   CaptionML=[DAN=Momsproduktbogf.gruppe;
                                                              ENU=VAT Prod. Posting Group] }
    { 92  ;   ;Bal. VAT Bus. Posting Group;Code20 ;TableRelation="VAT Business Posting Group";
                                                   OnValidate=BEGIN
                                                                IF "Bal. Account Type" IN
                                                                   ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor,"Bal. Account Type"::"Bank Account"]
                                                                THEN
                                                                  TESTFIELD("Bal. VAT Bus. Posting Group",'');

                                                                VALIDATE("Bal. VAT Prod. Posting Group");
                                                              END;

                                                   CaptionML=[DAN=Modkontos momsvirks.bogf.gr.;
                                                              ENU=Bal. VAT Bus. Posting Group] }
    { 93  ;   ;Bal. VAT Prod. Posting Group;Code20;TableRelation="VAT Product Posting Group";
                                                   OnValidate=BEGIN
                                                                IF "Bal. Account Type" IN
                                                                   ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor,"Bal. Account Type"::"Bank Account"]
                                                                THEN
                                                                  TESTFIELD("Bal. VAT Prod. Posting Group",'');

                                                                "Bal. VAT %" := 0;
                                                                "Bal. VAT Calculation Type" := "Bal. VAT Calculation Type"::"Normal VAT";
                                                                IF "Bal. Gen. Posting Type" <> 0 THEN BEGIN
                                                                  IF NOT VATPostingSetup.GET("Bal. VAT Bus. Posting Group","Bal. VAT Prod. Posting Group") THEN
                                                                    VATPostingSetup.INIT;
                                                                  "Bal. VAT Calculation Type" := VATPostingSetup."VAT Calculation Type";
                                                                  CASE "Bal. VAT Calculation Type" OF
                                                                    "Bal. VAT Calculation Type"::"Normal VAT":
                                                                      "Bal. VAT %" := VATPostingSetup."VAT %";
                                                                    "Bal. VAT Calculation Type"::"Full VAT":
                                                                      CASE "Bal. Gen. Posting Type" OF
                                                                        "Bal. Gen. Posting Type"::Sale:
                                                                          TESTFIELD("Bal. Account No.",VATPostingSetup.GetSalesAccount(FALSE));
                                                                        "Bal. Gen. Posting Type"::Purchase:
                                                                          TESTFIELD("Bal. Account No.",VATPostingSetup.GetPurchAccount(FALSE));
                                                                      END;
                                                                  END;
                                                                END;
                                                                VALIDATE("Bal. VAT %");
                                                              END;

                                                   CaptionML=[DAN=Modkontos momsprod.bogf.gr.;
                                                              ENU=Bal. VAT Prod. Posting Group] }
    { 95  ;   ;Additional-Currency Posting;Option ;CaptionML=[DAN=Ekstra valuta (postering);
                                                              ENU=Additional-Currency Posting];
                                                   OptionCaptionML=[DAN=Ingen,Kun bel�b,Kun ekstra valutabel�b;
                                                                    ENU=None,Amount Only,Additional-Currency Amount Only];
                                                   OptionString=None,Amount Only,Additional-Currency Amount Only;
                                                   Editable=No }
    { 98  ;   ;FA Add.-Currency Factor;Decimal    ;CaptionML=[DAN=Anl. ekstra valutafaktor;
                                                              ENU=FA Add.-Currency Factor];
                                                   DecimalPlaces=0:15;
                                                   MinValue=0 }
    { 99  ;   ;Source Currency Code;Code10        ;TableRelation=Currency;
                                                   CaptionML=[DAN=Kildevalutakode;
                                                              ENU=Source Currency Code];
                                                   Editable=No }
    { 100 ;   ;Source Currency Amount;Decimal     ;AccessByPermission=TableData 4=R;
                                                   CaptionML=[DAN=Kildevalutabel�b;
                                                              ENU=Source Currency Amount];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 101 ;   ;Source Curr. VAT Base Amount;Decimal;
                                                   AccessByPermission=TableData 4=R;
                                                   CaptionML=[DAN=Kildevaluta (momsgrundl.bel�b);
                                                              ENU=Source Curr. VAT Base Amount];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 102 ;   ;Source Curr. VAT Amount;Decimal    ;AccessByPermission=TableData 4=R;
                                                   CaptionML=[DAN=Kildevaluta (momsbel�b);
                                                              ENU=Source Curr. VAT Amount];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 103 ;   ;VAT Base Discount % ;Decimal       ;CaptionML=[DAN=Momsgrundlagsrabat %;
                                                              ENU=VAT Base Discount %];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   MaxValue=100;
                                                   Editable=No }
    { 104 ;   ;VAT Amount (LCY)    ;Decimal       ;CaptionML=[DAN=Momsbel�b (RV);
                                                              ENU=VAT Amount (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 105 ;   ;VAT Base Amount (LCY);Decimal      ;CaptionML=[DAN=Momsgrundlagsbel�b (RV);
                                                              ENU=VAT Base Amount (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 106 ;   ;Bal. VAT Amount (LCY);Decimal      ;CaptionML=[DAN=Modkontos momsbel�b (RV);
                                                              ENU=Bal. VAT Amount (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 107 ;   ;Bal. VAT Base Amount (LCY);Decimal ;CaptionML=[DAN=Modkontos momsgrdl.bel�b (RV);
                                                              ENU=Bal. VAT Base Amount (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 108 ;   ;Reversing Entry     ;Boolean       ;CaptionML=[DAN=Automatisk oprettet type;
                                                              ENU=Reversing Entry];
                                                   Editable=No }
    { 109 ;   ;Allow Zero-Amount Posting;Boolean  ;CaptionML=[DAN=Tillad bogf�ring af nul-bel�b;
                                                              ENU=Allow Zero-Amount Posting];
                                                   Editable=No }
    { 110 ;   ;Ship-to/Order Address Code;Code10  ;TableRelation=IF (Account Type=CONST(Customer)) "Ship-to Address".Code WHERE (Customer No.=FIELD(Bill-to/Pay-to No.))
                                                                 ELSE IF (Account Type=CONST(Vendor)) "Order Address".Code WHERE (Vendor No.=FIELD(Bill-to/Pay-to No.))
                                                                 ELSE IF (Bal. Account Type=CONST(Customer)) "Ship-to Address".Code WHERE (Customer No.=FIELD(Bill-to/Pay-to No.))
                                                                 ELSE IF (Bal. Account Type=CONST(Vendor)) "Order Address".Code WHERE (Vendor No.=FIELD(Bill-to/Pay-to No.));
                                                   CaptionML=[DAN=Leverings-/Bestillingsadressekode;
                                                              ENU=Ship-to/Order Address Code] }
    { 111 ;   ;VAT Difference      ;Decimal       ;CaptionML=[DAN=Momsdifference;
                                                              ENU=VAT Difference];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 112 ;   ;Bal. VAT Difference ;Decimal       ;CaptionML=[DAN=Modkontos momsdifference;
                                                              ENU=Bal. VAT Difference];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 113 ;   ;IC Partner Code     ;Code20        ;TableRelation="IC Partner";
                                                   CaptionML=[DAN=IC-partner kode;
                                                              ENU=IC Partner Code];
                                                   Editable=No }
    { 114 ;   ;IC Direction        ;Option        ;CaptionML=[DAN=IC-retning;
                                                              ENU=IC Direction];
                                                   OptionCaptionML=[DAN=Udg�ende,Indg�ende;
                                                                    ENU=Outgoing,Incoming];
                                                   OptionString=Outgoing,Incoming }
    { 116 ;   ;IC Partner G/L Acc. No.;Code20     ;TableRelation="IC G/L Account";
                                                   OnValidate=VAR
                                                                ICGLAccount@1000 : Record 410;
                                                              BEGIN
                                                                IF "Journal Template Name" <> '' THEN
                                                                  IF "IC Partner G/L Acc. No." <> '' THEN BEGIN
                                                                    GetTemplate;
                                                                    GenJnlTemplate.TESTFIELD(Type,GenJnlTemplate.Type::Intercompany);
                                                                    IF ICGLAccount.GET("IC Partner G/L Acc. No.") THEN
                                                                      ICGLAccount.TESTFIELD(Blocked,FALSE);
                                                                  END
                                                              END;

                                                   CaptionML=[DAN=IC-partner finanskontonr.;
                                                              ENU=IC Partner G/L Acc. No.] }
    { 117 ;   ;IC Partner Transaction No.;Integer ;CaptionML=[DAN=Transaktionsnr. for IC-partner;
                                                              ENU=IC Partner Transaction No.];
                                                   Editable=No }
    { 118 ;   ;Sell-to/Buy-from No.;Code20        ;TableRelation=IF (Account Type=CONST(Customer)) Customer
                                                                 ELSE IF (Bal. Account Type=CONST(Customer)) Customer
                                                                 ELSE IF (Account Type=CONST(Vendor)) Vendor
                                                                 ELSE IF (Bal. Account Type=CONST(Vendor)) Vendor;
                                                   OnValidate=BEGIN
                                                                ReadGLSetup;
                                                                IF GLSetup."Bill-to/Sell-to VAT Calc." = GLSetup."Bill-to/Sell-to VAT Calc."::"Sell-to/Buy-from No." THEN
                                                                  UpdateCountryCodeAndVATRegNo("Sell-to/Buy-from No.");
                                                              END;

                                                   CaptionML=[DAN=Kundenr./leverand�rnr.;
                                                              ENU=Sell-to/Buy-from No.] }
    { 119 ;   ;VAT Registration No.;Text20        ;OnValidate=VAR
                                                                VATRegNoFormat@1000 : Record 381;
                                                              BEGIN
                                                                VATRegNoFormat.Test("VAT Registration No.","Country/Region Code",'',0);
                                                              END;

                                                   CaptionML=[DAN=SE/CVR-nr.;
                                                              ENU=VAT Registration No.] }
    { 120 ;   ;Country/Region Code ;Code10        ;TableRelation=Country/Region;
                                                   OnValidate=BEGIN
                                                                VALIDATE("VAT Registration No.");
                                                              END;

                                                   CaptionML=[DAN=Lande-/omr�dekode;
                                                              ENU=Country/Region Code] }
    { 121 ;   ;Prepayment          ;Boolean       ;CaptionML=[DAN=Forudbetaling;
                                                              ENU=Prepayment] }
    { 122 ;   ;Financial Void      ;Boolean       ;CaptionML=[DAN=Finansiel annullering;
                                                              ENU=Financial Void];
                                                   Editable=No }
    { 123 ;   ;Copy VAT Setup to Jnl. Lines;Boolean;
                                                   InitValue=Yes;
                                                   CaptionML=[DAN=Kopier momsops�t. t. kld.linjer;
                                                              ENU=Copy VAT Setup to Jnl. Lines];
                                                   Editable=No }
    { 165 ;   ;Incoming Document Entry No.;Integer;TableRelation="Incoming Document";
                                                   OnValidate=VAR
                                                                IncomingDocument@1000 : Record 130;
                                                              BEGIN
                                                                IF Description = '' THEN
                                                                  Description := COPYSTR(IncomingDocument.Description,1,MAXSTRLEN(Description));
                                                                IF "Incoming Document Entry No." = xRec."Incoming Document Entry No." THEN
                                                                  EXIT;

                                                                IF "Incoming Document Entry No." = 0 THEN
                                                                  IncomingDocument.RemoveReferenceToWorkingDocument(xRec."Incoming Document Entry No.")
                                                                ELSE
                                                                  IncomingDocument.SetGenJournalLine(Rec);
                                                              END;

                                                   CaptionML=[DAN=L�benr. for indg�ende bilag;
                                                              ENU=Incoming Document Entry No.] }
    { 170 ;   ;Creditor No.        ;Code20        ;CaptionML=[DAN=Fordringshavernr.;
                                                              ENU=Creditor No.];
                                                   Numeric=Yes }
    { 171 ;   ;Payment Reference   ;Code50        ;CaptionML=[DAN=Betalingsreference;
                                                              ENU=Payment Reference];
                                                   Numeric=Yes }
    { 172 ;   ;Payment Method Code ;Code10        ;TableRelation="Payment Method";
                                                   OnValidate=BEGIN
                                                                UpdatePaymentMethodId;
                                                              END;

                                                   CaptionML=[DAN=Betalingsformskode;
                                                              ENU=Payment Method Code] }
    { 173 ;   ;Applies-to Ext. Doc. No.;Code35    ;CaptionML=[DAN=Eksternt udlign.bilagsnr.;
                                                              ENU=Applies-to Ext. Doc. No.] }
    { 288 ;   ;Recipient Bank Account;Code20      ;TableRelation=IF (Account Type=CONST(Customer)) "Customer Bank Account".Code WHERE (Customer No.=FIELD(Account No.))
                                                                 ELSE IF (Account Type=CONST(Vendor)) "Vendor Bank Account".Code WHERE (Vendor No.=FIELD(Account No.))
                                                                 ELSE IF (Account Type=CONST(Employee)) Employee.No. WHERE (Employee No. Filter=FIELD(Account No.))
                                                                 ELSE IF (Bal. Account Type=CONST(Customer)) "Customer Bank Account".Code WHERE (Customer No.=FIELD(Bal. Account No.))
                                                                 ELSE IF (Bal. Account Type=CONST(Vendor)) "Vendor Bank Account".Code WHERE (Vendor No.=FIELD(Bal. Account No.))
                                                                 ELSE IF (Bal. Account Type=CONST(Employee)) Employee.No. WHERE (Employee No. Filter=FIELD(Bal. Account No.));
                                                   OnValidate=BEGIN
                                                                IF "Recipient Bank Account" = '' THEN
                                                                  EXIT;
                                                                IF ("Document Type" = "Document Type"::Invoice) AND
                                                                   (("Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor]) OR
                                                                    ("Bal. Account Type" IN ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor]))
                                                                THEN
                                                                  "Recipient Bank Account" := '';
                                                              END;

                                                   CaptionML=[DAN=Modtagers bankkonto;
                                                              ENU=Recipient Bank Account] }
    { 289 ;   ;Message to Recipient;Text140       ;CaptionML=[DAN=Meddelelse til modtager;
                                                              ENU=Message to Recipient] }
    { 290 ;   ;Exported to Payment File;Boolean   ;CaptionML=[DAN=Eksporteret til betalingsfil;
                                                              ENU=Exported to Payment File];
                                                   Editable=No }
    { 291 ;   ;Has Payment Export Error;Boolean   ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Payment Jnl. Export Error Text" WHERE (Journal Template Name=FIELD(Journal Template Name),
                                                                                                             Journal Batch Name=FIELD(Journal Batch Name),
                                                                                                             Journal Line No.=FIELD(Line No.)));
                                                   CaptionML=[DAN=Har fejl i betalingseksport;
                                                              ENU=Has Payment Export Error];
                                                   Editable=No }
    { 480 ;   ;Dimension Set ID    ;Integer       ;TableRelation="Dimension Set Entry";
                                                   OnValidate=BEGIN
                                                                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
                                                              END;

                                                   OnLookup=BEGIN
                                                              ShowDimensions;
                                                            END;

                                                   CaptionML=[DAN=Dimensionsgruppe-id;
                                                              ENU=Dimension Set ID];
                                                   Editable=No }
    { 827 ;   ;Credit Card No.     ;Code20        ;CaptionML=[DAN=Kreditkortnr.;
                                                              ENU=Credit Card No.] }
    { 1001;   ;Job Task No.        ;Code20        ;TableRelation="Job Task"."Job Task No." WHERE (Job No.=FIELD(Job No.));
                                                   OnValidate=BEGIN
                                                                IF "Job Task No." <> xRec."Job Task No." THEN
                                                                  VALIDATE("Job Planning Line No.",0);
                                                                IF "Job Task No." = '' THEN BEGIN
                                                                  "Job Quantity" := 0;
                                                                  "Job Currency Factor" := 0;
                                                                  "Job Currency Code" := '';
                                                                  "Job Unit Price" := 0;
                                                                  "Job Total Price" := 0;
                                                                  "Job Line Amount" := 0;
                                                                  "Job Line Discount Amount" := 0;
                                                                  "Job Unit Cost" := 0;
                                                                  "Job Total Cost" := 0;
                                                                  "Job Line Discount %" := 0;

                                                                  "Job Unit Price (LCY)" := 0;
                                                                  "Job Total Price (LCY)" := 0;
                                                                  "Job Line Amount (LCY)" := 0;
                                                                  "Job Line Disc. Amount (LCY)" := 0;
                                                                  "Job Unit Cost (LCY)" := 0;
                                                                  "Job Total Cost (LCY)" := 0;
                                                                  EXIT;
                                                                END;

                                                                IF JobTaskIsSet THEN BEGIN
                                                                  CreateTempJobJnlLine;
                                                                  CopyDimensionsFromJobTaskLine;
                                                                  UpdatePricesFromJobJnlLine;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Sagsopgavenr.;
                                                              ENU=Job Task No.] }
    { 1002;   ;Job Unit Price (LCY);Decimal       ;AccessByPermission=TableData 167=R;
                                                   CaptionML=[DAN=Enhedspris for sag (RV);
                                                              ENU=Job Unit Price (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=2 }
    { 1003;   ;Job Total Price (LCY);Decimal      ;AccessByPermission=TableData 167=R;
                                                   CaptionML=[DAN=Salgsbel�b for sag (RV);
                                                              ENU=Job Total Price (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 1004;   ;Job Quantity        ;Decimal       ;OnValidate=BEGIN
                                                                IF JobTaskIsSet THEN BEGIN
                                                                  IF "Job Planning Line No." <> 0 THEN
                                                                    VALIDATE("Job Planning Line No.");
                                                                  CreateTempJobJnlLine;
                                                                  UpdatePricesFromJobJnlLine;
                                                                END;
                                                              END;

                                                   AccessByPermission=TableData 167=R;
                                                   CaptionML=[DAN=Antal sager;
                                                              ENU=Job Quantity];
                                                   DecimalPlaces=0:5 }
    { 1005;   ;Job Unit Cost (LCY) ;Decimal       ;AccessByPermission=TableData 167=R;
                                                   CaptionML=[DAN=Kostpris for sag (RV);
                                                              ENU=Job Unit Cost (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=2 }
    { 1006;   ;Job Line Discount % ;Decimal       ;OnValidate=BEGIN
                                                                IF JobTaskIsSet THEN BEGIN
                                                                  CreateTempJobJnlLine;
                                                                  TempJobJnlLine.VALIDATE("Line Discount %","Job Line Discount %");
                                                                  UpdatePricesFromJobJnlLine;
                                                                END;
                                                              END;

                                                   AccessByPermission=TableData 167=R;
                                                   CaptionML=[DAN=Linjerabat for sag i %;
                                                              ENU=Job Line Discount %];
                                                   AutoFormatType=1 }
    { 1007;   ;Job Line Disc. Amount (LCY);Decimal;OnValidate=BEGIN
                                                                IF JobTaskIsSet THEN BEGIN
                                                                  CreateTempJobJnlLine;
                                                                  TempJobJnlLine.VALIDATE("Line Discount Amount (LCY)","Job Line Disc. Amount (LCY)");
                                                                  UpdatePricesFromJobJnlLine;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Linjerabatbel�b for sag (RV);
                                                              ENU=Job Line Disc. Amount (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 1008;   ;Job Unit Of Measure Code;Code10    ;TableRelation="Unit of Measure";
                                                   CaptionML=[DAN=Sagsenhedskode;
                                                              ENU=Job Unit Of Measure Code] }
    { 1009;   ;Job Line Type       ;Option        ;OnValidate=BEGIN
                                                                IF "Job Planning Line No." <> 0 THEN
                                                                  ERROR(Text019,FIELDCAPTION("Job Line Type"),FIELDCAPTION("Job Planning Line No."));
                                                              END;

                                                   AccessByPermission=TableData 167=R;
                                                   CaptionML=[DAN=Linjetype for sag;
                                                              ENU=Job Line Type];
                                                   OptionCaptionML=[DAN=" ,Budget,Fakturerbar,B�de budget og fakturerbar";
                                                                    ENU=" ,Budget,Billable,Both Budget and Billable"];
                                                   OptionString=[ ,Budget,Billable,Both Budget and Billable] }
    { 1010;   ;Job Unit Price      ;Decimal       ;OnValidate=BEGIN
                                                                IF JobTaskIsSet THEN BEGIN
                                                                  CreateTempJobJnlLine;
                                                                  TempJobJnlLine.VALIDATE("Unit Price","Job Unit Price");
                                                                  UpdatePricesFromJobJnlLine;
                                                                END;
                                                              END;

                                                   AccessByPermission=TableData 167=R;
                                                   CaptionML=[DAN=Enhedspris for sag;
                                                              ENU=Job Unit Price];
                                                   AutoFormatType=2;
                                                   AutoFormatExpr="Job Currency Code" }
    { 1011;   ;Job Total Price     ;Decimal       ;AccessByPermission=TableData 167=R;
                                                   CaptionML=[DAN=Salgsbel�b for sag;
                                                              ENU=Job Total Price];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Job Currency Code" }
    { 1012;   ;Job Unit Cost       ;Decimal       ;AccessByPermission=TableData 167=R;
                                                   CaptionML=[DAN=Kostpris for sag;
                                                              ENU=Job Unit Cost];
                                                   Editable=No;
                                                   AutoFormatType=2;
                                                   AutoFormatExpr="Job Currency Code" }
    { 1013;   ;Job Total Cost      ;Decimal       ;AccessByPermission=TableData 167=R;
                                                   CaptionML=[DAN=Kostbel�b for sag;
                                                              ENU=Job Total Cost];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Job Currency Code" }
    { 1014;   ;Job Line Discount Amount;Decimal   ;OnValidate=BEGIN
                                                                IF JobTaskIsSet THEN BEGIN
                                                                  CreateTempJobJnlLine;
                                                                  TempJobJnlLine.VALIDATE("Line Discount Amount","Job Line Discount Amount");
                                                                  UpdatePricesFromJobJnlLine;
                                                                END;
                                                              END;

                                                   AccessByPermission=TableData 167=R;
                                                   CaptionML=[DAN=Linjerabatbel�b for sag;
                                                              ENU=Job Line Discount Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Job Currency Code" }
    { 1015;   ;Job Line Amount     ;Decimal       ;OnValidate=BEGIN
                                                                IF JobTaskIsSet THEN BEGIN
                                                                  CreateTempJobJnlLine;
                                                                  TempJobJnlLine.VALIDATE("Line Amount","Job Line Amount");
                                                                  UpdatePricesFromJobJnlLine;
                                                                END;
                                                              END;

                                                   AccessByPermission=TableData 167=R;
                                                   CaptionML=[DAN=Linjebel�b for sag;
                                                              ENU=Job Line Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Job Currency Code" }
    { 1016;   ;Job Total Cost (LCY);Decimal       ;AccessByPermission=TableData 167=R;
                                                   CaptionML=[DAN=Kostbel�b for sag (RV);
                                                              ENU=Job Total Cost (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 1017;   ;Job Line Amount (LCY);Decimal      ;OnValidate=BEGIN
                                                                IF JobTaskIsSet THEN BEGIN
                                                                  CreateTempJobJnlLine;
                                                                  TempJobJnlLine.VALIDATE("Line Amount (LCY)","Job Line Amount (LCY)");
                                                                  UpdatePricesFromJobJnlLine;
                                                                END;
                                                              END;

                                                   AccessByPermission=TableData 167=R;
                                                   CaptionML=[DAN=Linjebel�b for sag (RV);
                                                              ENU=Job Line Amount (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 1018;   ;Job Currency Factor ;Decimal       ;CaptionML=[DAN=Valutafaktor for sag;
                                                              ENU=Job Currency Factor] }
    { 1019;   ;Job Currency Code   ;Code10        ;OnValidate=BEGIN
                                                                IF ("Job Currency Code" <> xRec."Job Currency Code") OR ("Job Currency Code" <> '') THEN
                                                                  IF JobTaskIsSet THEN BEGIN
                                                                    CreateTempJobJnlLine;
                                                                    UpdatePricesFromJobJnlLine;
                                                                  END;
                                                              END;

                                                   CaptionML=[DAN=Valutakode for sag;
                                                              ENU=Job Currency Code] }
    { 1020;   ;Job Planning Line No.;Integer      ;OnValidate=VAR
                                                                JobPlanningLine@1000 : Record 1003;
                                                              BEGIN
                                                                IF "Job Planning Line No." <> 0 THEN BEGIN
                                                                  JobPlanningLine.GET("Job No.","Job Task No.","Job Planning Line No.");
                                                                  JobPlanningLine.TESTFIELD("Job No.","Job No.");
                                                                  JobPlanningLine.TESTFIELD("Job Task No.","Job Task No.");
                                                                  JobPlanningLine.TESTFIELD(Type,JobPlanningLine.Type::"G/L Account");
                                                                  JobPlanningLine.TESTFIELD("No.","Account No.");
                                                                  JobPlanningLine.TESTFIELD("Usage Link",TRUE);
                                                                  JobPlanningLine.TESTFIELD("System-Created Entry",FALSE);
                                                                  "Job Line Type" := JobPlanningLine."Line Type" + 1;
                                                                  VALIDATE("Job Remaining Qty.",JobPlanningLine."Remaining Qty." - "Job Quantity");
                                                                END ELSE
                                                                  VALIDATE("Job Remaining Qty.",0);
                                                              END;

                                                   OnLookup=VAR
                                                              JobPlanningLine@1000 : Record 1003;
                                                            BEGIN
                                                              JobPlanningLine.SETRANGE("Job No.","Job No.");
                                                              JobPlanningLine.SETRANGE("Job Task No.","Job Task No.");
                                                              JobPlanningLine.SETRANGE(Type,JobPlanningLine.Type::"G/L Account");
                                                              JobPlanningLine.SETRANGE("No.","Account No.");
                                                              JobPlanningLine.SETRANGE("Usage Link",TRUE);
                                                              JobPlanningLine.SETRANGE("System-Created Entry",FALSE);

                                                              IF PAGE.RUNMODAL(0,JobPlanningLine) = ACTION::LookupOK THEN
                                                                VALIDATE("Job Planning Line No.",JobPlanningLine."Line No.");
                                                            END;

                                                   AccessByPermission=TableData 167=R;
                                                   CaptionML=[DAN=Sagsplanl�gningslinjenr.;
                                                              ENU=Job Planning Line No.];
                                                   BlankZero=Yes }
    { 1030;   ;Job Remaining Qty.  ;Decimal       ;OnValidate=VAR
                                                                JobPlanningLine@1000 : Record 1003;
                                                              BEGIN
                                                                IF ("Job Remaining Qty." <> 0) AND ("Job Planning Line No." = 0) THEN
                                                                  ERROR(Text018,FIELDCAPTION("Job Remaining Qty."),FIELDCAPTION("Job Planning Line No."));

                                                                IF "Job Planning Line No." <> 0 THEN BEGIN
                                                                  JobPlanningLine.GET("Job No.","Job Task No.","Job Planning Line No.");
                                                                  IF JobPlanningLine.Quantity >= 0 THEN BEGIN
                                                                    IF "Job Remaining Qty." < 0 THEN
                                                                      "Job Remaining Qty." := 0;
                                                                  END ELSE BEGIN
                                                                    IF "Job Remaining Qty." > 0 THEN
                                                                      "Job Remaining Qty." := 0;
                                                                  END;
                                                                END;
                                                              END;

                                                   AccessByPermission=TableData 167=R;
                                                   CaptionML=[DAN=Rest. jobantal;
                                                              ENU=Job Remaining Qty.];
                                                   DecimalPlaces=0:5 }
    { 1200;   ;Direct Debit Mandate ID;Code35     ;TableRelation=IF (Account Type=CONST(Customer)) "SEPA Direct Debit Mandate" WHERE (Customer No.=FIELD(Account No.));
                                                   OnValidate=VAR
                                                                SEPADirectDebitMandate@1000 : Record 1230;
                                                              BEGIN
                                                                IF "Direct Debit Mandate ID" = '' THEN
                                                                  EXIT;
                                                                TESTFIELD("Account Type","Account Type"::Customer);
                                                                SEPADirectDebitMandate.GET("Direct Debit Mandate ID");
                                                                SEPADirectDebitMandate.TESTFIELD("Customer No.","Account No.");
                                                                "Recipient Bank Account" := SEPADirectDebitMandate."Customer Bank Account Code";
                                                              END;

                                                   CaptionML=[DAN=Id for Direct Debit-betalingsaftale;
                                                              ENU=Direct Debit Mandate ID] }
    { 1220;   ;Data Exch. Entry No.;Integer       ;TableRelation="Data Exch.";
                                                   CaptionML=[DAN=Dataudvekslingspostnr.;
                                                              ENU=Data Exch. Entry No.];
                                                   Editable=No }
    { 1221;   ;Payer Information   ;Text50        ;CaptionML=[DAN=Oplysninger om indbetaler;
                                                              ENU=Payer Information] }
    { 1222;   ;Transaction Information;Text100    ;CaptionML=[DAN=Oplysninger om transaktion;
                                                              ENU=Transaction Information] }
    { 1223;   ;Data Exch. Line No. ;Integer       ;CaptionML=[DAN=Dataudvekslingslinjenr.;
                                                              ENU=Data Exch. Line No.];
                                                   Editable=No }
    { 1224;   ;Applied Automatically;Boolean      ;CaptionML=[DAN=Anvendes automatisk;
                                                              ENU=Applied Automatically] }
    { 1700;   ;Deferral Code       ;Code10        ;TableRelation="Deferral Template"."Deferral Code";
                                                   OnValidate=VAR
                                                                DeferralUtilities@1002 : Codeunit 1720;
                                                              BEGIN
                                                                IF "Deferral Code" <> '' THEN
                                                                  TESTFIELD("Account Type","Account Type"::"G/L Account");

                                                                DeferralUtilities.DeferralCodeOnValidate("Deferral Code",DeferralDocType::"G/L","Journal Template Name","Journal Batch Name",
                                                                  0,'',"Line No.",GetDeferralAmount,"Posting Date",Description,"Currency Code");
                                                              END;

                                                   CaptionML=[DAN=Periodiseringskode;
                                                              ENU=Deferral Code] }
    { 1701;   ;Deferral Line No.   ;Integer       ;CaptionML=[DAN=Periodiseringslinjenr.;
                                                              ENU=Deferral Line No.] }
    { 5050;   ;Campaign No.        ;Code20        ;TableRelation=Campaign;
                                                   OnValidate=BEGIN
                                                                CreateDim(
                                                                  DATABASE::Campaign,"Campaign No.",
                                                                  DimMgt.TypeToTableID1("Account Type"),"Account No.",
                                                                  DimMgt.TypeToTableID1("Bal. Account Type"),"Bal. Account No.",
                                                                  DATABASE::Job,"Job No.",
                                                                  DATABASE::"Salesperson/Purchaser","Salespers./Purch. Code");
                                                              END;

                                                   CaptionML=[DAN=Kampagnenr.;
                                                              ENU=Campaign No.] }
    { 5400;   ;Prod. Order No.     ;Code20        ;CaptionML=[DAN=Prod.ordrenr.;
                                                              ENU=Prod. Order No.];
                                                   Editable=No }
    { 5600;   ;FA Posting Date     ;Date          ;AccessByPermission=TableData 5600=R;
                                                   CaptionML=[DAN=Bogf�ringsdato for anl�g;
                                                              ENU=FA Posting Date] }
    { 5601;   ;FA Posting Type     ;Option        ;OnValidate=BEGIN
                                                                IF  NOT (("Account Type" = "Account Type"::"Fixed Asset") OR
                                                                         ("Bal. Account Type" = "Bal. Account Type"::"Fixed Asset")) AND
                                                                   ("FA Posting Type" = "FA Posting Type"::" ")
                                                                THEN BEGIN
                                                                  "FA Posting Date" := 0D;
                                                                  "Salvage Value" := 0;
                                                                  "No. of Depreciation Days" := 0;
                                                                  "Depr. until FA Posting Date" := FALSE;
                                                                  "Depr. Acquisition Cost" := FALSE;
                                                                  "Maintenance Code" := '';
                                                                  "Insurance No." := '';
                                                                  "Budgeted FA No." := '';
                                                                  "Duplicate in Depreciation Book" := '';
                                                                  "Use Duplication List" := FALSE;
                                                                  "FA Reclassification Entry" := FALSE;
                                                                  "FA Error Entry No." := 0;
                                                                END;

                                                                IF "FA Posting Type" <> "FA Posting Type"::"Acquisition Cost" THEN
                                                                  TESTFIELD("Insurance No.",'');
                                                                IF "FA Posting Type" <> "FA Posting Type"::Maintenance THEN
                                                                  TESTFIELD("Maintenance Code",'');
                                                                GetFAVATSetup;
                                                                GetFAAddCurrExchRate;
                                                              END;

                                                   AccessByPermission=TableData 5600=R;
                                                   CaptionML=[DAN=Anl�gsbogf�ringstype;
                                                              ENU=FA Posting Type];
                                                   OptionCaptionML=[DAN=" ,Anskaffelse,Afskrivning,Nedskrivning,Opskrivning,Bruger 1,Bruger 2,Salg,Reparation";
                                                                    ENU=" ,Acquisition Cost,Depreciation,Write-Down,Appreciation,Custom 1,Custom 2,Disposal,Maintenance"];
                                                   OptionString=[ ,Acquisition Cost,Depreciation,Write-Down,Appreciation,Custom 1,Custom 2,Disposal,Maintenance] }
    { 5602;   ;Depreciation Book Code;Code10      ;TableRelation="Depreciation Book";
                                                   OnValidate=VAR
                                                                FADeprBook@1000 : Record 5612;
                                                              BEGIN
                                                                IF "Depreciation Book Code" = '' THEN
                                                                  EXIT;

                                                                IF ("Account No." <> '') AND
                                                                   ("Account Type" = "Account Type"::"Fixed Asset")
                                                                THEN BEGIN
                                                                  FADeprBook.GET("Account No.","Depreciation Book Code");
                                                                  "Posting Group" := FADeprBook."FA Posting Group";
                                                                END;

                                                                IF ("Bal. Account No." <> '') AND
                                                                   ("Bal. Account Type" = "Bal. Account Type"::"Fixed Asset")
                                                                THEN BEGIN
                                                                  FADeprBook.GET("Bal. Account No.","Depreciation Book Code");
                                                                  "Posting Group" := FADeprBook."FA Posting Group";
                                                                END;
                                                                GetFAVATSetup;
                                                                GetFAAddCurrExchRate;
                                                              END;

                                                   CaptionML=[DAN=Afskrivningsprofilkode;
                                                              ENU=Depreciation Book Code] }
    { 5603;   ;Salvage Value       ;Decimal       ;AccessByPermission=TableData 5600=R;
                                                   CaptionML=[DAN=Skrapv�rdi;
                                                              ENU=Salvage Value];
                                                   AutoFormatType=1 }
    { 5604;   ;No. of Depreciation Days;Integer   ;AccessByPermission=TableData 5600=R;
                                                   CaptionML=[DAN=Antal afskrivningsdage;
                                                              ENU=No. of Depreciation Days];
                                                   BlankZero=Yes }
    { 5605;   ;Depr. until FA Posting Date;Boolean;AccessByPermission=TableData 5600=R;
                                                   CaptionML=[DAN=Afskriv til bogf�ringsdato for anl�g;
                                                              ENU=Depr. until FA Posting Date] }
    { 5606;   ;Depr. Acquisition Cost;Boolean     ;AccessByPermission=TableData 5600=R;
                                                   CaptionML=[DAN=Afskriv anskaffelse;
                                                              ENU=Depr. Acquisition Cost] }
    { 5609;   ;Maintenance Code    ;Code10        ;TableRelation=Maintenance;
                                                   OnValidate=BEGIN
                                                                IF "Maintenance Code" <> '' THEN
                                                                  TESTFIELD("FA Posting Type","FA Posting Type"::Maintenance);
                                                              END;

                                                   CaptionML=[DAN=Reparationskode;
                                                              ENU=Maintenance Code] }
    { 5610;   ;Insurance No.       ;Code20        ;TableRelation=Insurance;
                                                   OnValidate=BEGIN
                                                                IF "Insurance No." <> '' THEN
                                                                  TESTFIELD("FA Posting Type","FA Posting Type"::"Acquisition Cost");
                                                              END;

                                                   CaptionML=[DAN=Forsikringsnr.;
                                                              ENU=Insurance No.] }
    { 5611;   ;Budgeted FA No.     ;Code20        ;TableRelation="Fixed Asset";
                                                   OnValidate=VAR
                                                                FA@1000 : Record 5600;
                                                              BEGIN
                                                                IF "Budgeted FA No." <> '' THEN BEGIN
                                                                  FA.GET("Budgeted FA No.");
                                                                  FA.TESTFIELD("Budgeted Asset",TRUE);
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Budgetanl�gsnr.;
                                                              ENU=Budgeted FA No.] }
    { 5612;   ;Duplicate in Depreciation Book;Code10;
                                                   TableRelation="Depreciation Book";
                                                   OnValidate=BEGIN
                                                                "Use Duplication List" := FALSE;
                                                              END;

                                                   CaptionML=[DAN=Kopier til afskr.profil;
                                                              ENU=Duplicate in Depreciation Book] }
    { 5613;   ;Use Duplication List;Boolean       ;OnValidate=BEGIN
                                                                "Duplicate in Depreciation Book" := '';
                                                              END;

                                                   AccessByPermission=TableData 5600=R;
                                                   CaptionML=[DAN=Brug kopiliste;
                                                              ENU=Use Duplication List] }
    { 5614;   ;FA Reclassification Entry;Boolean  ;AccessByPermission=TableData 5600=R;
                                                   CaptionML=[DAN=Anl-omposteringspost;
                                                              ENU=FA Reclassification Entry] }
    { 5615;   ;FA Error Entry No.  ;Integer       ;TableRelation="FA Ledger Entry";
                                                   CaptionML=[DAN=Anl�gsfejll�benr.;
                                                              ENU=FA Error Entry No.];
                                                   BlankZero=Yes }
    { 5616;   ;Index Entry         ;Boolean       ;CaptionML=[DAN=Indekspost;
                                                              ENU=Index Entry] }
    { 5617;   ;Source Line No.     ;Integer       ;CaptionML=[DAN=Kildelinjenr.;
                                                              ENU=Source Line No.] }
    { 5618;   ;Comment             ;Text250       ;CaptionML=[DAN=Bem�rkning;
                                                              ENU=Comment] }
    { 5701;   ;Check Exported      ;Boolean       ;CaptionML=[DAN=Check eksporteret;
                                                              ENU=Check Exported] }
    { 5702;   ;Check Transmitted   ;Boolean       ;CaptionML=[DAN=Check overf�rt;
                                                              ENU=Check Transmitted] }
    { 8000;   ;Id                  ;GUID          ;CaptionML=[DAN=Id;
                                                              ENU=Id] }
    { 8001;   ;Account Id          ;GUID          ;TableRelation="G/L Account".Id;
                                                   OnValidate=BEGIN
                                                                UpdateAccountNo;
                                                              END;

                                                   CaptionML=[DAN=Konto-id;
                                                              ENU=Account Id] }
    { 8002;   ;Customer Id         ;GUID          ;TableRelation=Customer.Id;
                                                   OnValidate=BEGIN
                                                                UpdateCustomerNo;
                                                              END;

                                                   CaptionML=[DAN=Debitor-id;
                                                              ENU=Customer Id] }
    { 8003;   ;Applies-to Invoice Id;GUID         ;TableRelation="Sales Invoice Header".Id;
                                                   OnValidate=BEGIN
                                                                UpdateAppliesToInvoiceNo;
                                                              END;

                                                   CaptionML=[DAN=Udligner faktura-id;
                                                              ENU=Applies-to Invoice Id] }
    { 8004;   ;Contact Graph Id    ;Text250       ;CaptionML=[DAN=Graph-id for kontakt;
                                                              ENU=Contact Graph Id] }
    { 8005;   ;Last Modified DateTime;DateTime    ;CaptionML=[DAN=Dato/klokkesl�t for seneste �ndring;
                                                              ENU=Last Modified DateTime] }
    { 8006;   ;Journal Batch Id    ;GUID          ;TableRelation="Gen. Journal Batch".Id;
                                                   OnValidate=BEGIN
                                                                UpdateJournalBatchName;
                                                              END;

                                                   CaptionML=[DAN=Id for kladdek�rsel;
                                                              ENU=Journal Batch Id] }
    { 8007;   ;Payment Method Id   ;GUID          ;TableRelation="Payment Method".Id;
                                                   OnValidate=BEGIN
                                                                UpdatePaymentMethodCode;
                                                              END;

                                                   CaptionML=[DAN=Id for betalingsform;
                                                              ENU=Payment Method Id] }
  }
  KEYS
  {
    {    ;Journal Template Name,Journal Batch Name,Line No.;
                                                   SumIndexFields=Balance (LCY);
                                                   MaintainSIFTIndex=No;
                                                   Clustered=Yes }
    {    ;Journal Template Name,Journal Batch Name,Posting Date,Document No.;
                                                   MaintainSQLIndex=No }
    {    ;Account Type,Account No.,Applies-to Doc. Type,Applies-to Doc. No. }
    {    ;Document No.                            ;MaintainSQLIndex=No }
    {    ;Incoming Document Entry No.              }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst '@@@="%1=Account Type,%2=Balance Account Type";DAN=%1 eller %2 skal v�re en finanskonto eller bankkonto.;ENU=%1 or %2 must be a G/L Account or Bank Account.';
      Text001@1001 : TextConst 'DAN=Du m� ikke indtaste %1, n�r %2 er %3.;ENU=You must not specify %1 when %2 is %3.';
      Text002@1002 : TextConst 'DAN=m� ikke indtastes uden %1;ENU=cannot be specified without %1';
      ChangeCurrencyQst@1003 : TextConst '@@@="%1=FromCurrencyCode, %2=ToCurrencyCode";DAN=Valutakoden i Finanskladdelinje �ndres fra %1 til %2.\\Vil du forts�tte?;ENU=The Currency Code in the Gen. Journal Line will be changed from %1 to %2.\\Do you want to continue?';
      UpdateInterruptedErr@1005 : TextConst 'DAN=Opdateringen er afbrudt p� grund af advarslen.;ENU=The update has been interrupted to respect the warning.';
      Text006@1006 : TextConst 'DAN=Valgmuligheden %1 kan kun bruges internt i systemet.;ENU=The %1 option can only be used internally in the system.';
      Text007@1007 : TextConst '@@@="%1=Account Type,%2=Balance Account Type";DAN=%1 eller %2 skal v�re en bankkonto.;ENU=%1 or %2 must be a bank account.';
      Text008@1008 : TextConst 'DAN=" skal v�re 0, n�r %1 er %2.";ENU=" must be 0 when %1 is %2."';
      Text009@1009 : TextConst 'DAN=RV;ENU=LCY';
      Text010@1010 : TextConst 'DAN=%1 skal v�re %2 eller %3.;ENU=%1 must be %2 or %3.';
      Text011@1011 : TextConst 'DAN=%1 skal v�re negativ.;ENU=%1 must be negative.';
      Text012@1012 : TextConst 'DAN=%1 skal v�re positiv.;ENU=%1 must be positive.';
      Text013@1013 : TextConst 'DAN=%1 m� ikke v�re mere end %2.;ENU=The %1 must not be more than %2.';
      GenJnlTemplate@1014 : Record 80;
      GenJnlBatch@1015 : Record 232;
      GenJnlLine@1016 : Record 81;
      Currency@1022 : Record 4;
      CurrExchRate@1023 : Record 330;
      PaymentTerms@1024 : Record 3;
      CustLedgEntry@1025 : Record 21;
      VendLedgEntry@1026 : Record 25;
      EmplLedgEntry@1020 : Record 5222;
      GenJnlAlloc@1027 : Record 221;
      VATPostingSetup@1028 : Record 325;
      GenBusPostingGrp@1035 : Record 250;
      GenProdPostingGrp@1036 : Record 251;
      GLSetup@1037 : Record 98;
      Job@1060 : Record 167;
      SourceCodeSetup@1017 : Record 242;
      TempJobJnlLine@1059 : TEMPORARY Record 210;
      NoSeriesMgt@1040 : Codeunit 396;
      CustCheckCreditLimit@1041 : Codeunit 312;
      SalesTaxCalculate@1042 : Codeunit 398;
      GenJnlApply@1043 : Codeunit 225;
      GenJnlShowCTEntries@1039 : Codeunit 16;
      CustEntrySetApplID@1044 : Codeunit 101;
      VendEntrySetApplID@1045 : Codeunit 111;
      EmplEntrySetApplID@1029 : Codeunit 112;
      DimMgt@1046 : Codeunit 408;
      PaymentToleranceMgt@1053 : Codeunit 426;
      DeferralUtilities@1051 : Codeunit 1720;
      ApprovalsMgmt@1069 : Codeunit 1535;
      Window@1004 : Dialog;
      DeferralDocType@1050 : 'Purchase,Sales,G/L';
      CurrencyCode@1052 : Code[10];
      Text014@1054 : TextConst '@@@="%1=Caption of Table Customer, %2=Customer No, %3=Caption of field Bill-to Customer No, %4=Value of Bill-to customer no.";DAN=%1 %2 har %3 %4.\\Vil du stadig bruge %1 %2 i denne kladdelinje?;ENU=The %1 %2 has a %3 %4.\\Do you still want to use %1 %2 in this journal line?';
      TemplateFound@1056 : Boolean;
      Text015@1058 : TextConst 'DAN=Du m� ikke udligne og bogf�re en post til en post med en tidligere bogf�ringsdato.\\Du skal i stedet bogf�re %1 %2 og derefter udligne den p� %3 %4.;ENU=You are not allowed to apply and post an entry to an entry with an earlier posting date.\\Instead, post %1 %2 and then apply it to %3 %4.';
      CurrencyDate@1061 : Date;
      Text016@1062 : TextConst 'DAN=%1 skal v�re Finanskonto eller Bankkonto.;ENU=%1 must be G/L Account or Bank Account.';
      HideValidationDialog@1064 : Boolean;
      Text018@1066 : TextConst 'DAN=%1 kan kun angives, n�r %2 er angivet.;ENU=%1 can only be set when %2 is set.';
      Text019@1067 : TextConst 'DAN=%1 kan ikke �ndres, n�r %2 er angivet.;ENU=%1 cannot be changed when %2 is set.';
      GLSetupRead@1019 : Boolean;
      ExportAgainQst@1038 : TextConst 'DAN=En eller flere af de valgte linjer er allerede eksporteret. Vil du eksportere dem igen?;ENU=One or more of the selected lines have already been exported. Do you want to export them again?';
      NothingToExportErr@1021 : TextConst 'DAN=Der er ikke noget at eksportere.;ENU=There is nothing to export.';
      NotExistErr@1068 : TextConst '@@@="%1=Document number";DAN=Dokumentnummer %1 eksisterer ikke eller er allerede lukket.;ENU=Document number %1 does not exist or is already closed.';
      DocNoFilterErr@1047 : TextConst 'DAN=Dokumentnumrene kan ikke renummereres, men der er et aktivt filter i feltet Bilagsnr.;ENU=The document numbers cannot be renumbered while there is an active filter on the Document No. field.';
      DueDateMsg@1150 : TextConst 'DAN=Denne bogf�ringsdato vil medf�re for sen betaling.;ENU=This posting date will cause an overdue payment.';
      CalcPostDateMsg@1169 : TextConst 'DAN=Behandler betalingskladdelinjer #1##########;ENU=Processing payment journal lines #1##########';
      NoEntriesToVoidErr@1018 : TextConst 'DAN=Der er ingen poster at annullere.;ENU=There are no entries to void.';
      OnlyLocalCurrencyForEmployeeErr@1030 : TextConst 'DAN=Der skal ikke angives en v�rdi i feltet Valutakode. Finanskladdelinjer i fremmedvaluta underst�ttes ikke for medarbejderkontotypen.;ENU=The value of the Currency Code field must be empty. General journal lines in foreign currency are not supported for employee account type.';

    [External]
    PROCEDURE EmptyLine@5() : Boolean;
    BEGIN
      EXIT(
        ("Account No." = '') AND (Amount = 0) AND
        (("Bal. Account No." = '') OR NOT "System-Created Entry"));
    END;

    [External]
    PROCEDURE UpdateLineBalance@2();
    BEGIN
      IF ((Amount > 0) AND (NOT Correction)) OR
         ((Amount < 0) AND Correction)
      THEN BEGIN
        "Debit Amount" := Amount;
        "Credit Amount" := 0
      END ELSE
        IF Amount <> 0 THEN BEGIN
          "Debit Amount" := 0;
          "Credit Amount" := -Amount;
        END;
      IF "Currency Code" = '' THEN
        "Amount (LCY)" := Amount;
      CASE TRUE OF
        ("Account No." <> '') AND ("Bal. Account No." <> ''):
          "Balance (LCY)" := 0;
        "Bal. Account No." <> '':
          "Balance (LCY)" := -"Amount (LCY)";
        ELSE
          "Balance (LCY)" := "Amount (LCY)";
      END;

      CLEAR(GenJnlAlloc);
      GenJnlAlloc.UpdateAllocations(Rec);

      UpdateSalesPurchLCY;

      IF ("Deferral Code" <> '') AND (Amount <> xRec.Amount) AND ((Amount <> 0) AND (xRec.Amount <> 0)) THEN
        VALIDATE("Deferral Code");
    END;

    [External]
    PROCEDURE SetUpNewLine@9(LastGenJnlLine@1000 : Record 81;Balance@1001 : Decimal;BottomLine@1002 : Boolean);
    BEGIN
      GenJnlTemplate.GET("Journal Template Name");
      GenJnlBatch.GET("Journal Template Name","Journal Batch Name");
      GenJnlLine.SETRANGE("Journal Template Name","Journal Template Name");
      GenJnlLine.SETRANGE("Journal Batch Name","Journal Batch Name");
      IF GenJnlLine.FINDFIRST THEN BEGIN
        "Posting Date" := LastGenJnlLine."Posting Date";
        "Document Date" := LastGenJnlLine."Posting Date";
        "Document No." := LastGenJnlLine."Document No.";
        IF BottomLine AND
           (Balance - LastGenJnlLine."Balance (LCY)" = 0) AND
           NOT LastGenJnlLine.EmptyLine
        THEN
          IncrementDocumentNo;
      END ELSE BEGIN
        "Posting Date" := WORKDATE;
        "Document Date" := WORKDATE;
        IF GenJnlBatch."No. Series" <> '' THEN BEGIN
          CLEAR(NoSeriesMgt);
          "Document No." := NoSeriesMgt.TryGetNextNo(GenJnlBatch."No. Series","Posting Date");
        END;
      END;
      IF GenJnlTemplate.Recurring THEN
        "Recurring Method" := LastGenJnlLine."Recurring Method";
      CASE GenJnlTemplate.Type OF
        GenJnlTemplate.Type::Payments:
          BEGIN
            "Account Type" := "Account Type"::Vendor;
            "Document Type" := "Document Type"::Payment;
          END;
        ELSE BEGIN
          "Account Type" := LastGenJnlLine."Account Type";
          "Document Type" := LastGenJnlLine."Document Type";
        END;
      END;
      "Source Code" := GenJnlTemplate."Source Code";
      "Reason Code" := GenJnlBatch."Reason Code";
      "Posting No. Series" := GenJnlBatch."Posting No. Series";
      "Bal. Account Type" := GenJnlBatch."Bal. Account Type";
      IF ("Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor,"Account Type"::"Fixed Asset"]) AND
         ("Bal. Account Type" IN ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor,"Bal. Account Type"::"Fixed Asset"])
      THEN
        "Account Type" := "Account Type"::"G/L Account";
      VALIDATE("Bal. Account No.",GenJnlBatch."Bal. Account No.");
      Description := '';
      IF GenJnlBatch."Suggest Balancing Amount" THEN
        SuggestBalancingAmount(LastGenJnlLine,BottomLine);

      UpdateJournalBatchID;

      OnAfterSetupNewLine(Rec,GenJnlTemplate,GenJnlBatch,LastGenJnlLine,Balance,BottomLine);
    END;

    [External]
    PROCEDURE InitNewLine@94(PostingDate@1000 : Date;DocumentDate@1001 : Date;PostingDescription@1002 : Text[50];ShortcutDim1Code@1003 : Code[20];ShortcutDim2Code@1004 : Code[20];DimSetID@1005 : Integer;ReasonCode@1006 : Code[10]);
    BEGIN
      INIT;
      "Posting Date" := PostingDate;
      "Document Date" := DocumentDate;
      Description := PostingDescription;
      "Shortcut Dimension 1 Code" := ShortcutDim1Code;
      "Shortcut Dimension 2 Code" := ShortcutDim2Code;
      "Dimension Set ID" := DimSetID;
      "Reason Code" := ReasonCode;
    END;

    [External]
    PROCEDURE CheckDocNoOnLines@78();
    VAR
      GenJnlBatch@1002 : Record 232;
      GenJnlLine@1001 : Record 81;
      LastDocNo@1003 : Code[20];
    BEGIN
      GenJnlLine.COPYFILTERS(Rec);

      IF NOT GenJnlLine.FINDSET THEN
        EXIT;
      GenJnlBatch.GET(GenJnlLine."Journal Template Name",GenJnlLine."Journal Batch Name");
      IF GenJnlBatch."No. Series" = '' THEN
        EXIT;

      CLEAR(NoSeriesMgt);
      REPEAT
        GenJnlLine.CheckDocNoBasedOnNoSeries(LastDocNo,GenJnlBatch."No. Series",NoSeriesMgt);
        LastDocNo := GenJnlLine."Document No.";
      UNTIL GenJnlLine.NEXT = 0;
    END;

    [External]
    PROCEDURE CheckDocNoBasedOnNoSeries@74(LastDocNo@1002 : Code[20];NoSeriesCode@1000 : Code[20];VAR NoSeriesMgtInstance@1001 : Codeunit 396);
    BEGIN
      IF NoSeriesCode = '' THEN
        EXIT;

      IF (LastDocNo = '') OR ("Document No." <> LastDocNo) THEN
        TESTFIELD("Document No.",NoSeriesMgtInstance.GetNextNo(NoSeriesCode,"Posting Date",FALSE));
    END;

    [External]
    PROCEDURE RenumberDocumentNo@68();
    VAR
      GenJnlLine2@1006 : Record 81;
      DocNo@1003 : Code[20];
      FirstDocNo@1008 : Code[20];
      FirstTempDocNo@1009 : Code[20];
      LastTempDocNo@1010 : Code[20];
    BEGIN
      TESTFIELD("Check Printed",FALSE);

      GenJnlBatch.GET("Journal Template Name","Journal Batch Name");
      IF GenJnlBatch."No. Series" = '' THEN
        EXIT;
      IF GETFILTER("Document No.") <> '' THEN
        ERROR(DocNoFilterErr);
      CLEAR(NoSeriesMgt);
      FirstDocNo := NoSeriesMgt.TryGetNextNo(GenJnlBatch."No. Series","Posting Date");
      FirstTempDocNo := 'RENUMBERED-000000001';
      // step1 - renumber to non-existing document number
      DocNo := FirstTempDocNo;
      GenJnlLine2 := Rec;
      GenJnlLine2.RESET;
      RenumberDocNoOnLines(DocNo,GenJnlLine2);
      LastTempDocNo := DocNo;

      // step2 - renumber to real document number (within Filter)
      DocNo := FirstDocNo;
      GenJnlLine2.COPYFILTERS(Rec);
      GenJnlLine2 := Rec;
      RenumberDocNoOnLines(DocNo,GenJnlLine2);

      // step3 - renumber to real document number (outside filter)
      DocNo := INCSTR(DocNo);
      GenJnlLine2.RESET;
      GenJnlLine2.SETRANGE("Document No.",FirstTempDocNo,LastTempDocNo);
      RenumberDocNoOnLines(DocNo,GenJnlLine2);

      GET("Journal Template Name","Journal Batch Name","Line No.");
    END;

    LOCAL PROCEDURE RenumberDocNoOnLines@69(VAR DocNo@1000 : Code[20];VAR GenJnlLine2@1001 : Record 81);
    VAR
      LastGenJnlLine@1002 : Record 81;
      GenJnlLine3@1005 : Record 81;
      PrevDocNo@1004 : Code[20];
      FirstDocNo@1006 : Code[20];
      First@1003 : Boolean;
    BEGIN
      FirstDocNo := DocNo;
      WITH GenJnlLine2 DO BEGIN
        SETCURRENTKEY("Journal Template Name","Journal Batch Name","Document No.");
        SETRANGE("Journal Template Name","Journal Template Name");
        SETRANGE("Journal Batch Name","Journal Batch Name");
        LastGenJnlLine.INIT;
        First := TRUE;
        IF FINDSET THEN BEGIN
          REPEAT
            IF "Document No." = FirstDocNo THEN
              EXIT;
            IF NOT First AND (("Document No." <> PrevDocNo) OR ("Bal. Account No." <> '')) AND NOT LastGenJnlLine.EmptyLine THEN
              DocNo := INCSTR(DocNo);
            PrevDocNo := "Document No.";
            IF "Document No." <> '' THEN BEGIN
              IF "Applies-to ID" = "Document No." THEN
                RenumberAppliesToID(GenJnlLine2,"Document No.",DocNo);
              RenumberAppliesToDocNo(GenJnlLine2,"Document No.",DocNo);
            END;
            GenJnlLine3.GET("Journal Template Name","Journal Batch Name","Line No.");
            GenJnlLine3."Document No." := DocNo;
            GenJnlLine3.MODIFY;
            First := FALSE;
            LastGenJnlLine := GenJnlLine2
          UNTIL NEXT = 0
        END
      END
    END;

    LOCAL PROCEDURE RenumberAppliesToID@70(GenJnlLine2@1002 : Record 81;OriginalAppliesToID@1000 : Code[50];NewAppliesToID@1001 : Code[50]);
    VAR
      CustLedgEntry@1003 : Record 21;
      CustLedgEntry2@1009 : Record 21;
      VendLedgEntry@1004 : Record 25;
      VendLedgEntry2@1010 : Record 25;
      AccType@1005 : Option;
      AccNo@1006 : Code[20];
    BEGIN
      GetAccTypeAndNo(GenJnlLine2,AccType,AccNo);
      CASE AccType OF
        "Account Type"::Customer:
          BEGIN
            CustLedgEntry.SETRANGE("Customer No.",AccNo);
            CustLedgEntry.SETRANGE("Applies-to ID",OriginalAppliesToID);
            IF CustLedgEntry.FINDSET THEN
              REPEAT
                CustLedgEntry2.GET(CustLedgEntry."Entry No.");
                CustLedgEntry2."Applies-to ID" := NewAppliesToID;
                CODEUNIT.RUN(CODEUNIT::"Cust. Entry-Edit",CustLedgEntry2);
              UNTIL CustLedgEntry.NEXT = 0;
          END;
        "Account Type"::Vendor:
          BEGIN
            VendLedgEntry.SETRANGE("Vendor No.",AccNo);
            VendLedgEntry.SETRANGE("Applies-to ID",OriginalAppliesToID);
            IF VendLedgEntry.FINDSET THEN
              REPEAT
                VendLedgEntry2.GET(VendLedgEntry."Entry No.");
                VendLedgEntry2."Applies-to ID" := NewAppliesToID;
                CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit",VendLedgEntry2);
              UNTIL VendLedgEntry.NEXT = 0;
          END;
        ELSE
          EXIT
      END;
      GenJnlLine2."Applies-to ID" := NewAppliesToID;
      GenJnlLine2.MODIFY;
    END;

    LOCAL PROCEDURE RenumberAppliesToDocNo@71(GenJnlLine2@1002 : Record 81;OriginalAppliesToDocNo@1001 : Code[20];NewAppliesToDocNo@1000 : Code[20]);
    BEGIN
      GenJnlLine2.RESET;
      GenJnlLine2.SETRANGE("Journal Template Name",GenJnlLine2."Journal Template Name");
      GenJnlLine2.SETRANGE("Journal Batch Name",GenJnlLine2."Journal Batch Name");
      GenJnlLine2.SETRANGE("Applies-to Doc. Type",GenJnlLine2."Document Type");
      GenJnlLine2.SETRANGE("Applies-to Doc. No.",OriginalAppliesToDocNo);
      GenJnlLine2.MODIFYALL("Applies-to Doc. No.",NewAppliesToDocNo);
    END;

    LOCAL PROCEDURE CheckVATInAlloc@1();
    BEGIN
      IF "Gen. Posting Type" <> 0 THEN BEGIN
        GenJnlAlloc.RESET;
        GenJnlAlloc.SETRANGE("Journal Template Name","Journal Template Name");
        GenJnlAlloc.SETRANGE("Journal Batch Name","Journal Batch Name");
        GenJnlAlloc.SETRANGE("Journal Line No.","Line No.");
        IF GenJnlAlloc.FIND('-') THEN
          REPEAT
            GenJnlAlloc.CheckVAT(Rec);
          UNTIL GenJnlAlloc.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE SetCurrencyCode@4(AccType2@1000 : 'G/L Account,Customer,Vendor,Bank Account';AccNo2@1001 : Code[20]) : Boolean;
    VAR
      BankAcc@1002 : Record 270;
    BEGIN
      "Currency Code" := '';
      IF AccNo2 <> '' THEN
        IF AccType2 = AccType2::"Bank Account" THEN
          IF BankAcc.GET(AccNo2) THEN
            "Currency Code" := BankAcc."Currency Code";
      EXIT("Currency Code" <> '');
    END;

    [External]
    PROCEDURE SetCurrencyFactor@130(CurrencyCode@1000 : Code[10];CurrencyFactor@1001 : Decimal);
    BEGIN
      "Currency Code" := CurrencyCode;
      IF "Currency Code" = '' THEN
        "Currency Factor" := 1
      ELSE
        "Currency Factor" := CurrencyFactor;
    END;

    LOCAL PROCEDURE GetCurrency@3();
    BEGIN
      IF "Additional-Currency Posting" =
         "Additional-Currency Posting"::"Additional-Currency Amount Only"
      THEN BEGIN
        IF GLSetup."Additional Reporting Currency" = '' THEN
          ReadGLSetup;
        CurrencyCode := GLSetup."Additional Reporting Currency";
      END ELSE
        CurrencyCode := "Currency Code";

      IF CurrencyCode = '' THEN BEGIN
        CLEAR(Currency);
        Currency.InitRoundingPrecision
      END ELSE
        IF CurrencyCode <> Currency.Code THEN BEGIN
          Currency.GET(CurrencyCode);
          Currency.TESTFIELD("Amount Rounding Precision");
        END;
    END;

    [External]
    PROCEDURE UpdateSource@6();
    VAR
      SourceExists1@1000 : Boolean;
      SourceExists2@1001 : Boolean;
    BEGIN
      SourceExists1 := ("Account Type" <> "Account Type"::"G/L Account") AND ("Account No." <> '');
      SourceExists2 := ("Bal. Account Type" <> "Bal. Account Type"::"G/L Account") AND ("Bal. Account No." <> '');
      CASE TRUE OF
        SourceExists1 AND NOT SourceExists2:
          BEGIN
            "Source Type" := "Account Type";
            "Source No." := "Account No.";
          END;
        SourceExists2 AND NOT SourceExists1:
          BEGIN
            "Source Type" := "Bal. Account Type";
            "Source No." := "Bal. Account No.";
          END;
        ELSE BEGIN
          "Source Type" := "Source Type"::" ";
          "Source No." := '';
        END;
      END;
    END;

    LOCAL PROCEDURE CheckGLAcc@7(GLAcc@1000 : Record 15);
    BEGIN
      GLAcc.CheckGLAcc;
      IF GLAcc."Direct Posting" OR ("Journal Template Name" = '') OR "System-Created Entry" THEN
        EXIT;
      IF "Posting Date" <> 0D THEN
        IF "Posting Date" = CLOSINGDATE("Posting Date") THEN
          EXIT;
      GLAcc.TESTFIELD("Direct Posting",TRUE);
    END;

    LOCAL PROCEDURE CheckICPartner@128(ICPartnerCode@1000 : Code[20];AccountType@1001 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';AccountNo@1002 : Code[20]);
    VAR
      ICPartner@1003 : Record 413;
    BEGIN
      IF ICPartnerCode <> '' THEN BEGIN
        IF GenJnlTemplate.GET("Journal Template Name") THEN;
        IF (ICPartnerCode <> '') AND ICPartner.GET(ICPartnerCode) THEN BEGIN
          ICPartner.CheckICPartnerIndirect(FORMAT(AccountType),AccountNo);
          "IC Partner Code" := ICPartnerCode;
        END;
      END;
    END;

    [External]
    PROCEDURE GetFAAddCurrExchRate@8();
    VAR
      DeprBook@1000 : Record 5611;
      FADeprBook@1003 : Record 5612;
      FANo@1001 : Code[20];
      UseFAAddCurrExchRate@1002 : Boolean;
    BEGIN
      "FA Add.-Currency Factor" := 0;
      IF ("FA Posting Type" <> "FA Posting Type"::" ") AND
         ("Depreciation Book Code" <> '')
      THEN BEGIN
        IF "Account Type" = "Account Type"::"Fixed Asset" THEN
          FANo := "Account No.";
        IF "Bal. Account Type" = "Bal. Account Type"::"Fixed Asset" THEN
          FANo := "Bal. Account No.";
        IF FANo <> '' THEN BEGIN
          DeprBook.GET("Depreciation Book Code");
          CASE "FA Posting Type" OF
            "FA Posting Type"::"Acquisition Cost":
              UseFAAddCurrExchRate := DeprBook."Add-Curr Exch Rate - Acq. Cost";
            "FA Posting Type"::Depreciation:
              UseFAAddCurrExchRate := DeprBook."Add.-Curr. Exch. Rate - Depr.";
            "FA Posting Type"::"Write-Down":
              UseFAAddCurrExchRate := DeprBook."Add-Curr Exch Rate -Write-Down";
            "FA Posting Type"::Appreciation:
              UseFAAddCurrExchRate := DeprBook."Add-Curr. Exch. Rate - Apprec.";
            "FA Posting Type"::"Custom 1":
              UseFAAddCurrExchRate := DeprBook."Add-Curr. Exch Rate - Custom 1";
            "FA Posting Type"::"Custom 2":
              UseFAAddCurrExchRate := DeprBook."Add-Curr. Exch Rate - Custom 2";
            "FA Posting Type"::Disposal:
              UseFAAddCurrExchRate := DeprBook."Add.-Curr. Exch. Rate - Disp.";
            "FA Posting Type"::Maintenance:
              UseFAAddCurrExchRate := DeprBook."Add.-Curr. Exch. Rate - Maint.";
          END;
          IF UseFAAddCurrExchRate THEN BEGIN
            FADeprBook.GET(FANo,"Depreciation Book Code");
            FADeprBook.TESTFIELD("FA Add.-Currency Factor");
            "FA Add.-Currency Factor" := FADeprBook."FA Add.-Currency Factor";
          END;
        END;
      END;
    END;

    [External]
    PROCEDURE GetShowCurrencyCode@10(CurrencyCode@1000 : Code[10]) : Code[10];
    BEGIN
      IF CurrencyCode <> '' THEN
        EXIT(CurrencyCode);

      EXIT(Text009);
    END;

    [External]
    PROCEDURE ClearCustVendApplnEntry@11();
    VAR
      TempCustLedgEntry@1000 : TEMPORARY Record 21;
      TempVendLedgEntry@1001 : TEMPORARY Record 25;
      TempEmplLedgEntry@1002 : TEMPORARY Record 5222;
      AccType@1004 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee';
      AccNo@1005 : Code[20];
    BEGIN
      GetAccTypeAndNo(Rec,AccType,AccNo);
      CASE AccType OF
        AccType::Customer:
          IF xRec."Applies-to ID" <> '' THEN BEGIN
            IF FindFirstCustLedgEntryWithAppliesToID(AccNo,xRec."Applies-to ID") THEN BEGIN
              ClearCustApplnEntryFields;
              TempCustLedgEntry.DELETEALL;
              CustEntrySetApplID.SetApplId(CustLedgEntry,TempCustLedgEntry,'');
            END
          END ELSE
            IF xRec."Applies-to Doc. No." <> '' THEN
              IF FindFirstCustLedgEntryWithAppliesToDocNo(AccNo,xRec."Applies-to Doc. No.") THEN BEGIN
                ClearCustApplnEntryFields;
                CODEUNIT.RUN(CODEUNIT::"Cust. Entry-Edit",CustLedgEntry);
              END;
        AccType::Vendor:
          IF xRec."Applies-to ID" <> '' THEN BEGIN
            IF FindFirstVendLedgEntryWithAppliesToID(AccNo,xRec."Applies-to ID") THEN BEGIN
              ClearVendApplnEntryFields;
              TempVendLedgEntry.DELETEALL;
              VendEntrySetApplID.SetApplId(VendLedgEntry,TempVendLedgEntry,'');
            END
          END ELSE
            IF xRec."Applies-to Doc. No." <> '' THEN
              IF FindFirstVendLedgEntryWithAppliesToDocNo(AccNo,xRec."Applies-to Doc. No.") THEN BEGIN
                ClearVendApplnEntryFields;
                CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit",VendLedgEntry);
              END;
        AccType::Employee:
          IF xRec."Applies-to ID" <> '' THEN BEGIN
            IF FindFirstEmplLedgEntryWithAppliesToID(AccNo,xRec."Applies-to ID") THEN BEGIN
              ClearEmplApplnEntryFields;
              TempEmplLedgEntry.DELETEALL;
              EmplEntrySetApplID.SetApplId(EmplLedgEntry,TempEmplLedgEntry,'');
            END
          END ELSE
            IF xRec."Applies-to Doc. No." <> '' THEN
              IF FindFirstEmplLedgEntryWithAppliesToDocNo(AccNo,xRec."Applies-to Doc. No.") THEN BEGIN
                ClearEmplApplnEntryFields;
                CODEUNIT.RUN(CODEUNIT::"Empl. Entry-Edit",EmplLedgEntry);
              END;
      END;
    END;

    LOCAL PROCEDURE ClearCustApplnEntryFields@56();
    BEGIN
      CustLedgEntry."Accepted Pmt. Disc. Tolerance" := FALSE;
      CustLedgEntry."Accepted Payment Tolerance" := 0;
      CustLedgEntry."Amount to Apply" := 0;
    END;

    LOCAL PROCEDURE ClearVendApplnEntryFields@57();
    BEGIN
      VendLedgEntry."Accepted Pmt. Disc. Tolerance" := FALSE;
      VendLedgEntry."Accepted Payment Tolerance" := 0;
      VendLedgEntry."Amount to Apply" := 0;
    END;

    LOCAL PROCEDURE ClearEmplApplnEntryFields@193();
    BEGIN
      EmplLedgEntry."Amount to Apply" := 0;
    END;

    [External]
    PROCEDURE CheckFixedCurrency@12() : Boolean;
    VAR
      CurrExchRate@1000 : Record 330;
    BEGIN
      CurrExchRate.SETRANGE("Currency Code","Currency Code");
      CurrExchRate.SETRANGE("Starting Date",0D,"Posting Date");

      IF NOT CurrExchRate.FINDLAST THEN
        EXIT(FALSE);

      IF CurrExchRate."Relational Currency Code" = '' THEN
        EXIT(
          CurrExchRate."Fix Exchange Rate Amount" =
          CurrExchRate."Fix Exchange Rate Amount"::Both);

      IF CurrExchRate."Fix Exchange Rate Amount" <>
         CurrExchRate."Fix Exchange Rate Amount"::Both
      THEN
        EXIT(FALSE);

      CurrExchRate.SETRANGE("Currency Code",CurrExchRate."Relational Currency Code");
      IF CurrExchRate.FINDLAST THEN
        EXIT(
          CurrExchRate."Fix Exchange Rate Amount" =
          CurrExchRate."Fix Exchange Rate Amount"::Both);

      EXIT(FALSE);
    END;

    [External]
    PROCEDURE CreateDim@13(Type1@1000 : Integer;No1@1001 : Code[20];Type2@1002 : Integer;No2@1003 : Code[20];Type3@1004 : Integer;No3@1005 : Code[20];Type4@1006 : Integer;No4@1007 : Code[20];Type5@1008 : Integer;No5@1009 : Code[20]);
    VAR
      TableID@1010 : ARRAY [10] OF Integer;
      No@1011 : ARRAY [10] OF Code[20];
    BEGIN
      TableID[1] := Type1;
      No[1] := No1;
      TableID[2] := Type2;
      No[2] := No2;
      TableID[3] := Type3;
      No[3] := No3;
      TableID[4] := Type4;
      No[4] := No4;
      TableID[5] := Type5;
      No[5] := No5;
      OnAfterCreateDimTableIDs(Rec,CurrFieldNo,TableID,No);

      "Shortcut Dimension 1 Code" := '';
      "Shortcut Dimension 2 Code" := '';
      "Dimension Set ID" :=
        DimMgt.GetRecDefaultDimID(
          Rec,CurrFieldNo,TableID,No,"Source Code","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",0,0);
    END;

    [External]
    PROCEDURE ValidateShortcutDimCode@14(FieldNumber@1000 : Integer;VAR ShortcutDimCode@1001 : Code[20]);
    BEGIN
      TESTFIELD("Check Printed",FALSE);
      DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
    END;

    [External]
    PROCEDURE LookupShortcutDimCode@18(FieldNumber@1000 : Integer;VAR ShortcutDimCode@1001 : Code[20]);
    BEGIN
      TESTFIELD("Check Printed",FALSE);
      DimMgt.LookupDimValueCode(FieldNumber,ShortcutDimCode);
      DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
    END;

    [External]
    PROCEDURE ShowShortcutDimCode@15(VAR ShortcutDimCode@1000 : ARRAY [8] OF Code[20]);
    BEGIN
      DimMgt.GetShortcutDimensions("Dimension Set ID",ShortcutDimCode);
    END;

    [External]
    PROCEDURE ShowDimensions@26();
    BEGIN
      "Dimension Set ID" :=
        DimMgt.EditDimensionSet2(
          "Dimension Set ID",STRSUBSTNO('%1 %2 %3',"Journal Template Name","Journal Batch Name","Line No."),
          "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
    END;

    [External]
    PROCEDURE GetFAVATSetup@17();
    VAR
      LocalGLAcc@1000 : Record 15;
      FAPostingGr@1001 : Record 5606;
      FABalAcc@1002 : Boolean;
    BEGIN
      IF CurrFieldNo = 0 THEN
        EXIT;
      IF ("Account Type" <> "Account Type"::"Fixed Asset") AND
         ("Bal. Account Type" <> "Bal. Account Type"::"Fixed Asset")
      THEN
        EXIT;
      FABalAcc := ("Bal. Account Type" = "Bal. Account Type"::"Fixed Asset");
      IF NOT FABalAcc THEN BEGIN
        ClearPostingGroups;
        "Tax Group Code" := '';
        VALIDATE("VAT Prod. Posting Group");
      END;
      IF FABalAcc THEN BEGIN
        ClearBalancePostingGroups;
        "Bal. Tax Group Code" := '';
        VALIDATE("Bal. VAT Prod. Posting Group");
      END;
      IF "Copy VAT Setup to Jnl. Lines" THEN
        IF (("FA Posting Type" = "FA Posting Type"::"Acquisition Cost") OR
            ("FA Posting Type" = "FA Posting Type"::Disposal) OR
            ("FA Posting Type" = "FA Posting Type"::Maintenance)) AND
           ("Posting Group" <> '')
        THEN
          IF FAPostingGr.GET("Posting Group") THEN BEGIN
            CASE "FA Posting Type" OF
              "FA Posting Type"::"Acquisition Cost":
                LocalGLAcc.GET(FAPostingGr.GetAcquisitionCostAccount);
              "FA Posting Type"::Disposal:
                LocalGLAcc.GET(FAPostingGr.GetAcquisitionCostAccountOnDisposal);
              "FA Posting Type"::Maintenance:
                LocalGLAcc.GET(FAPostingGr.GetMaintenanceExpenseAccount);
            END;
            LocalGLAcc.CheckGLAcc;
            IF NOT FABalAcc THEN BEGIN
              "Gen. Posting Type" := LocalGLAcc."Gen. Posting Type";
              "Gen. Bus. Posting Group" := LocalGLAcc."Gen. Bus. Posting Group";
              "Gen. Prod. Posting Group" := LocalGLAcc."Gen. Prod. Posting Group";
              "VAT Bus. Posting Group" := LocalGLAcc."VAT Bus. Posting Group";
              "VAT Prod. Posting Group" := LocalGLAcc."VAT Prod. Posting Group";
              "Tax Group Code" := LocalGLAcc."Tax Group Code";
              VALIDATE("VAT Prod. Posting Group");
            END ELSE BEGIN;
              "Bal. Gen. Posting Type" := LocalGLAcc."Gen. Posting Type";
              "Bal. Gen. Bus. Posting Group" := LocalGLAcc."Gen. Bus. Posting Group";
              "Bal. Gen. Prod. Posting Group" := LocalGLAcc."Gen. Prod. Posting Group";
              "Bal. VAT Bus. Posting Group" := LocalGLAcc."VAT Bus. Posting Group";
              "Bal. VAT Prod. Posting Group" := LocalGLAcc."VAT Prod. Posting Group";
              "Bal. Tax Group Code" := LocalGLAcc."Tax Group Code";
              VALIDATE("Bal. VAT Prod. Posting Group");
            END;
          END;
    END;

    LOCAL PROCEDURE GetFADeprBook@114(FANo@1003 : Code[20]);
    VAR
      FASetup@1000 : Record 5603;
      FADeprBook@1001 : Record 5612;
      DefaultFADeprBook@1002 : Record 5612;
    BEGIN
      IF "Depreciation Book Code" = '' THEN BEGIN
        FASetup.GET;

        DefaultFADeprBook.SETRANGE("FA No.",FANo);
        DefaultFADeprBook.SETRANGE("Default FA Depreciation Book",TRUE);

        CASE TRUE OF
          DefaultFADeprBook.FINDFIRST:
            "Depreciation Book Code" := DefaultFADeprBook."Depreciation Book Code";
          FADeprBook.GET(FANo,FASetup."Default Depr. Book"):
            "Depreciation Book Code" := FASetup."Default Depr. Book";
          ELSE
            "Depreciation Book Code" := '';
        END;
      END;

      IF "Depreciation Book Code" <> '' THEN BEGIN
        FADeprBook.GET(FANo,"Depreciation Book Code");
        "Posting Group" := FADeprBook."FA Posting Group";
      END;
    END;

    [External]
    PROCEDURE GetTemplate@16();
    BEGIN
      IF NOT TemplateFound THEN
        GenJnlTemplate.GET("Journal Template Name");
      TemplateFound := TRUE;
    END;

    LOCAL PROCEDURE UpdateSalesPurchLCY@19();
    BEGIN
      "Sales/Purch. (LCY)" := 0;
      IF (NOT "System-Created Entry") AND ("Document Type" IN ["Document Type"::Invoice,"Document Type"::"Credit Memo"]) THEN BEGIN
        IF ("Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor]) AND ("Bal. Account No." <> '') THEN
          "Sales/Purch. (LCY)" := "Amount (LCY)" + "Bal. VAT Amount (LCY)";
        IF ("Bal. Account Type" IN ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor]) AND ("Account No." <> '') THEN
          "Sales/Purch. (LCY)" := -("Amount (LCY)" - "VAT Amount (LCY)");
      END;
    END;

    [Internal]
    PROCEDURE LookUpAppliesToDocCust@35(AccNo@1000 : Code[20]);
    VAR
      ApplyCustEntries@1002 : Page 232;
    BEGIN
      CLEAR(CustLedgEntry);
      CustLedgEntry.SETCURRENTKEY("Customer No.",Open,Positive,"Due Date");
      IF AccNo <> '' THEN
        CustLedgEntry.SETRANGE("Customer No.",AccNo);
      CustLedgEntry.SETRANGE(Open,TRUE);
      IF "Applies-to Doc. No." <> '' THEN BEGIN
        CustLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
        CustLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
        IF CustLedgEntry.ISEMPTY THEN BEGIN
          CustLedgEntry.SETRANGE("Document Type");
          CustLedgEntry.SETRANGE("Document No.");
        END;
      END;
      IF "Applies-to ID" <> '' THEN BEGIN
        CustLedgEntry.SETRANGE("Applies-to ID","Applies-to ID");
        IF CustLedgEntry.ISEMPTY THEN
          CustLedgEntry.SETRANGE("Applies-to ID");
      END;
      IF "Applies-to Doc. Type" <> "Applies-to Doc. Type"::" " THEN BEGIN
        CustLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
        IF CustLedgEntry.ISEMPTY THEN
          CustLedgEntry.SETRANGE("Document Type");
      END;
      IF Amount <> 0 THEN BEGIN
        CustLedgEntry.SETRANGE(Positive,Amount < 0);
        IF CustLedgEntry.ISEMPTY THEN
          CustLedgEntry.SETRANGE(Positive);
      END;
      ApplyCustEntries.SetGenJnlLine(Rec,GenJnlLine.FIELDNO("Applies-to Doc. No."));
      ApplyCustEntries.SETTABLEVIEW(CustLedgEntry);
      ApplyCustEntries.SETRECORD(CustLedgEntry);
      ApplyCustEntries.LOOKUPMODE(TRUE);
      IF ApplyCustEntries.RUNMODAL = ACTION::LookupOK THEN BEGIN
        ApplyCustEntries.GETRECORD(CustLedgEntry);
        IF AccNo = '' THEN BEGIN
          AccNo := CustLedgEntry."Customer No.";
          IF "Bal. Account Type" = "Bal. Account Type"::Customer THEN
            VALIDATE("Bal. Account No.",AccNo)
          ELSE
            VALIDATE("Account No.",AccNo);
        END;
        SetAmountWithCustLedgEntry;
        "Applies-to Doc. Type" := CustLedgEntry."Document Type";
        "Applies-to Doc. No." := CustLedgEntry."Document No.";
        "Applies-to ID" := '';
      END;
    END;

    [Internal]
    PROCEDURE LookUpAppliesToDocVend@36(AccNo@1000 : Code[20]);
    VAR
      ApplyVendEntries@1001 : Page 233;
    BEGIN
      CLEAR(VendLedgEntry);
      VendLedgEntry.SETCURRENTKEY("Vendor No.",Open,Positive,"Due Date");
      IF AccNo <> '' THEN
        VendLedgEntry.SETRANGE("Vendor No.",AccNo);
      VendLedgEntry.SETRANGE(Open,TRUE);
      IF "Applies-to Doc. No." <> '' THEN BEGIN
        VendLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
        VendLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
        IF VendLedgEntry.ISEMPTY THEN BEGIN
          VendLedgEntry.SETRANGE("Document Type");
          VendLedgEntry.SETRANGE("Document No.");
        END;
      END;
      IF "Applies-to ID" <> '' THEN BEGIN
        VendLedgEntry.SETRANGE("Applies-to ID","Applies-to ID");
        IF VendLedgEntry.ISEMPTY THEN
          VendLedgEntry.SETRANGE("Applies-to ID");
      END;
      IF "Applies-to Doc. Type" <> "Applies-to Doc. Type"::" " THEN BEGIN
        VendLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
        IF VendLedgEntry.ISEMPTY THEN
          VendLedgEntry.SETRANGE("Document Type");
      END;
      IF  "Applies-to Doc. No." <> ''THEN BEGIN
        VendLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
        IF VendLedgEntry.ISEMPTY THEN
          VendLedgEntry.SETRANGE("Document No.");
      END;
      IF Amount <> 0 THEN BEGIN
        VendLedgEntry.SETRANGE(Positive,Amount < 0);
        IF VendLedgEntry.ISEMPTY THEN;
        VendLedgEntry.SETRANGE(Positive);
      END;
      ApplyVendEntries.SetGenJnlLine(Rec,GenJnlLine.FIELDNO("Applies-to Doc. No."));
      ApplyVendEntries.SETTABLEVIEW(VendLedgEntry);
      ApplyVendEntries.SETRECORD(VendLedgEntry);
      ApplyVendEntries.LOOKUPMODE(TRUE);
      IF ApplyVendEntries.RUNMODAL = ACTION::LookupOK THEN BEGIN
        ApplyVendEntries.GETRECORD(VendLedgEntry);
        IF AccNo = '' THEN BEGIN
          AccNo := VendLedgEntry."Vendor No.";
          IF "Bal. Account Type" = "Bal. Account Type"::Vendor THEN
            VALIDATE("Bal. Account No.",AccNo)
          ELSE
            VALIDATE("Account No.",AccNo);
        END;
        SetAmountWithVendLedgEntry;
        "Applies-to Doc. Type" := VendLedgEntry."Document Type";
        "Applies-to Doc. No." := VendLedgEntry."Document No.";
        "Applies-to ID" := '';
      END;
    END;

    [Internal]
    PROCEDURE LookUpAppliesToDocEmpl@171(AccNo@1000 : Code[20]);
    VAR
      ApplyEmplEntries@1001 : Page 234;
    BEGIN
      CLEAR(EmplLedgEntry);
      EmplLedgEntry.SETCURRENTKEY("Employee No.",Open,Positive);
      IF AccNo <> '' THEN
        EmplLedgEntry.SETRANGE("Employee No.",AccNo);
      EmplLedgEntry.SETRANGE(Open,TRUE);
      IF "Applies-to Doc. No." <> '' THEN BEGIN
        EmplLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
        EmplLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
        IF EmplLedgEntry.ISEMPTY THEN BEGIN
          EmplLedgEntry.SETRANGE("Document Type");
          EmplLedgEntry.SETRANGE("Document No.");
        END;
      END;
      IF "Applies-to ID" <> '' THEN BEGIN
        EmplLedgEntry.SETRANGE("Applies-to ID","Applies-to ID");
        IF EmplLedgEntry.ISEMPTY THEN
          EmplLedgEntry.SETRANGE("Applies-to ID");
      END;
      IF "Applies-to Doc. Type" <> "Applies-to Doc. Type"::" " THEN BEGIN
        EmplLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
        IF EmplLedgEntry.ISEMPTY THEN
          EmplLedgEntry.SETRANGE("Document Type");
      END;
      IF  "Applies-to Doc. No." <> '' THEN BEGIN
        EmplLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
        IF EmplLedgEntry.ISEMPTY THEN
          EmplLedgEntry.SETRANGE("Document No.");
      END;
      IF Amount <> 0 THEN BEGIN
        EmplLedgEntry.SETRANGE(Positive,Amount < 0);
        IF EmplLedgEntry.ISEMPTY THEN;
        EmplLedgEntry.SETRANGE(Positive);
      END;
      ApplyEmplEntries.SetGenJnlLine(Rec,GenJnlLine.FIELDNO("Applies-to Doc. No."));
      ApplyEmplEntries.SETTABLEVIEW(EmplLedgEntry);
      ApplyEmplEntries.SETRECORD(EmplLedgEntry);
      ApplyEmplEntries.LOOKUPMODE(TRUE);
      IF ApplyEmplEntries.RUNMODAL = ACTION::LookupOK THEN BEGIN
        ApplyEmplEntries.GETRECORD(EmplLedgEntry);
        IF AccNo = '' THEN BEGIN
          AccNo := EmplLedgEntry."Employee No.";
          IF "Bal. Account Type" = "Bal. Account Type"::Employee THEN
            VALIDATE("Bal. Account No.",AccNo)
          ELSE
            VALIDATE("Account No.",AccNo);
        END;
        SetAmountWithEmplLedgEntry;
        "Applies-to Doc. Type" := EmplLedgEntry."Document Type";
        "Applies-to Doc. No." := EmplLedgEntry."Document No.";
        "Applies-to ID" := '';
      END;
    END;

    [External]
    PROCEDURE SetApplyToAmount@20();
    BEGIN
      CASE "Account Type" OF
        "Account Type"::Customer:
          BEGIN
            CustLedgEntry.SETCURRENTKEY("Document No.");
            CustLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
            CustLedgEntry.SETRANGE("Customer No.","Account No.");
            CustLedgEntry.SETRANGE(Open,TRUE);
            IF CustLedgEntry.FIND('-') THEN
              IF CustLedgEntry."Amount to Apply" = 0 THEN BEGIN
                CustLedgEntry.CALCFIELDS("Remaining Amount");
                CustLedgEntry."Amount to Apply" := CustLedgEntry."Remaining Amount";
                CODEUNIT.RUN(CODEUNIT::"Cust. Entry-Edit",CustLedgEntry);
              END;
          END;
        "Account Type"::Vendor:
          BEGIN
            VendLedgEntry.SETCURRENTKEY("Document No.");
            VendLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
            VendLedgEntry.SETRANGE("Vendor No.","Account No.");
            VendLedgEntry.SETRANGE(Open,TRUE);
            IF VendLedgEntry.FIND('-') THEN
              IF VendLedgEntry."Amount to Apply" = 0 THEN  BEGIN
                VendLedgEntry.CALCFIELDS("Remaining Amount");
                VendLedgEntry."Amount to Apply" := VendLedgEntry."Remaining Amount";
                CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit",VendLedgEntry);
              END;
          END;
        "Account Type"::Employee:
          BEGIN
            EmplLedgEntry.SETCURRENTKEY("Document No.");
            EmplLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
            EmplLedgEntry.SETRANGE("Employee No.","Account No.");
            EmplLedgEntry.SETRANGE(Open,TRUE);
            IF EmplLedgEntry.FIND('-') THEN
              IF EmplLedgEntry."Amount to Apply" = 0 THEN BEGIN
                EmplLedgEntry.CALCFIELDS("Remaining Amount");
                EmplLedgEntry."Amount to Apply" := EmplLedgEntry."Remaining Amount";
                CODEUNIT.RUN(CODEUNIT::"Empl. Entry-Edit",EmplLedgEntry);
              END;
          END;
      END;
    END;

    [External]
    PROCEDURE ValidateApplyRequirements@21(TempGenJnlLine@1000 : TEMPORARY Record 81);
    BEGIN
      IF (TempGenJnlLine."Bal. Account Type" = TempGenJnlLine."Bal. Account Type"::Customer) OR
         (TempGenJnlLine."Bal. Account Type" = TempGenJnlLine."Bal. Account Type"::Vendor) OR
         (TempGenJnlLine."Bal. Account Type" = TempGenJnlLine."Bal. Account Type"::Vendor)
      THEN
        CODEUNIT.RUN(CODEUNIT::"Exchange Acc. G/L Journal Line",TempGenJnlLine);

      CASE TempGenJnlLine."Account Type" OF
        TempGenJnlLine."Account Type"::Customer:
          IF TempGenJnlLine."Applies-to ID" <> '' THEN BEGIN
            CustLedgEntry.SETCURRENTKEY("Customer No.","Applies-to ID",Open);
            CustLedgEntry.SETRANGE("Customer No.",TempGenJnlLine."Account No.");
            CustLedgEntry.SETRANGE("Applies-to ID",TempGenJnlLine."Applies-to ID");
            CustLedgEntry.SETRANGE(Open,TRUE);
            IF CustLedgEntry.FIND('-') THEN
              REPEAT
                IF TempGenJnlLine."Posting Date" < CustLedgEntry."Posting Date" THEN
                  ERROR(
                    Text015,TempGenJnlLine."Document Type",TempGenJnlLine."Document No.",
                    CustLedgEntry."Document Type",CustLedgEntry."Document No.");
              UNTIL CustLedgEntry.NEXT = 0;
          END ELSE
            IF TempGenJnlLine."Applies-to Doc. No." <> '' THEN BEGIN
              CustLedgEntry.SETCURRENTKEY("Document No.");
              CustLedgEntry.SETRANGE("Document No.",TempGenJnlLine."Applies-to Doc. No.");
              IF TempGenJnlLine."Applies-to Doc. Type" <> TempGenJnlLine."Applies-to Doc. Type"::" " THEN
                CustLedgEntry.SETRANGE("Document Type",TempGenJnlLine."Applies-to Doc. Type");
              CustLedgEntry.SETRANGE("Customer No.",TempGenJnlLine."Account No.");
              CustLedgEntry.SETRANGE(Open,TRUE);
              IF CustLedgEntry.FIND('-') THEN
                IF TempGenJnlLine."Posting Date" < CustLedgEntry."Posting Date" THEN
                  ERROR(
                    Text015,TempGenJnlLine."Document Type",TempGenJnlLine."Document No.",
                    CustLedgEntry."Document Type",CustLedgEntry."Document No.");
            END;
        TempGenJnlLine."Account Type"::Vendor:
          IF TempGenJnlLine."Applies-to ID" <> '' THEN BEGIN
            VendLedgEntry.SETCURRENTKEY("Vendor No.","Applies-to ID",Open);
            VendLedgEntry.SETRANGE("Vendor No.",TempGenJnlLine."Account No.");
            VendLedgEntry.SETRANGE("Applies-to ID",TempGenJnlLine."Applies-to ID");
            VendLedgEntry.SETRANGE(Open,TRUE);
            REPEAT
              IF TempGenJnlLine."Posting Date" < VendLedgEntry."Posting Date" THEN
                ERROR(
                  Text015,TempGenJnlLine."Document Type",TempGenJnlLine."Document No.",
                  VendLedgEntry."Document Type",VendLedgEntry."Document No.");
            UNTIL VendLedgEntry.NEXT = 0;
            IF VendLedgEntry.FIND('-') THEN
              ;
          END ELSE
            IF TempGenJnlLine."Applies-to Doc. No." <> '' THEN BEGIN
              VendLedgEntry.SETCURRENTKEY("Document No.");
              VendLedgEntry.SETRANGE("Document No.",TempGenJnlLine."Applies-to Doc. No.");
              IF TempGenJnlLine."Applies-to Doc. Type" <> TempGenJnlLine."Applies-to Doc. Type"::" " THEN
                VendLedgEntry.SETRANGE("Document Type",TempGenJnlLine."Applies-to Doc. Type");
              VendLedgEntry.SETRANGE("Vendor No.",TempGenJnlLine."Account No.");
              VendLedgEntry.SETRANGE(Open,TRUE);
              IF VendLedgEntry.FIND('-') THEN
                IF TempGenJnlLine."Posting Date" < VendLedgEntry."Posting Date" THEN
                  ERROR(
                    Text015,TempGenJnlLine."Document Type",TempGenJnlLine."Document No.",
                    VendLedgEntry."Document Type",VendLedgEntry."Document No.");
            END;
        TempGenJnlLine."Account Type"::Employee:
          IF TempGenJnlLine."Applies-to ID" <> '' THEN BEGIN
            EmplLedgEntry.SETCURRENTKEY("Employee No.","Applies-to ID",Open);
            EmplLedgEntry.SETRANGE("Employee No.",TempGenJnlLine."Account No.");
            EmplLedgEntry.SETRANGE("Applies-to ID",TempGenJnlLine."Applies-to ID");
            EmplLedgEntry.SETRANGE(Open,TRUE);
            REPEAT
              IF TempGenJnlLine."Posting Date" < EmplLedgEntry."Posting Date" THEN
                ERROR(
                  Text015,TempGenJnlLine."Document Type",TempGenJnlLine."Document No.",
                  EmplLedgEntry."Document Type",EmplLedgEntry."Document No.");
            UNTIL EmplLedgEntry.NEXT = 0;
            IF EmplLedgEntry.FIND('-') THEN
              ;
          END ELSE
            IF TempGenJnlLine."Applies-to Doc. No." <> '' THEN BEGIN
              EmplLedgEntry.SETCURRENTKEY("Document No.");
              EmplLedgEntry.SETRANGE("Document No.",TempGenJnlLine."Applies-to Doc. No.");
              IF TempGenJnlLine."Applies-to Doc. Type" <> EmplLedgEntry."Applies-to Doc. Type"::" " THEN
                EmplLedgEntry.SETRANGE("Document Type",TempGenJnlLine."Applies-to Doc. Type");
              EmplLedgEntry.SETRANGE("Employee No.",TempGenJnlLine."Account No.");
              EmplLedgEntry.SETRANGE(Open,TRUE);
              IF EmplLedgEntry.FIND('-') THEN
                IF TempGenJnlLine."Posting Date" < EmplLedgEntry."Posting Date" THEN
                  ERROR(
                    Text015,TempGenJnlLine."Document Type",TempGenJnlLine."Document No.",
                    EmplLedgEntry."Document Type",EmplLedgEntry."Document No.");
            END;
      END;
    END;

    LOCAL PROCEDURE UpdateCountryCodeAndVATRegNo@25(No@1000 : Code[20]);
    VAR
      Cust@1001 : Record 18;
      Vend@1002 : Record 23;
    BEGIN
      IF No = '' THEN BEGIN
        "Country/Region Code" := '';
        "VAT Registration No." := '';
        EXIT;
      END;

      ReadGLSetup;
      CASE TRUE OF
        ("Account Type" = "Account Type"::Customer) OR ("Bal. Account Type" = "Bal. Account Type"::Customer):
          BEGIN
            Cust.GET(No);
            "Country/Region Code" := Cust."Country/Region Code";
            "VAT Registration No." := Cust."VAT Registration No.";
          END;
        ("Account Type" = "Account Type"::Vendor) OR ("Bal. Account Type" = "Bal. Account Type"::Vendor):
          BEGIN
            Vend.GET(No);
            "Country/Region Code" := Vend."Country/Region Code";
            "VAT Registration No." := Vend."VAT Registration No.";
          END;
      END;
    END;

    [External]
    PROCEDURE JobTaskIsSet@28() : Boolean;
    BEGIN
      EXIT(("Job No." <> '') AND ("Job Task No." <> '') AND ("Account Type" = "Account Type"::"G/L Account"));
    END;

    [Internal]
    PROCEDURE CreateTempJobJnlLine@27();
    VAR
      TmpJobJnlOverallCurrencyFactor@1001 : Decimal;
    BEGIN
      OnBeforeCreateTempJobJnlLine(TempJobJnlLine,Rec,xRec,CurrFieldNo);

      TESTFIELD("Posting Date");
      CLEAR(TempJobJnlLine);
      TempJobJnlLine.DontCheckStdCost;
      TempJobJnlLine.VALIDATE("Job No.","Job No.");
      TempJobJnlLine.VALIDATE("Job Task No.","Job Task No.");
      IF CurrFieldNo <> FIELDNO("Posting Date") THEN
        TempJobJnlLine.VALIDATE("Posting Date","Posting Date")
      ELSE
        TempJobJnlLine.VALIDATE("Posting Date",xRec."Posting Date");
      TempJobJnlLine.VALIDATE(Type,TempJobJnlLine.Type::"G/L Account");
      IF "Job Currency Code" <> '' THEN BEGIN
        IF "Posting Date" = 0D THEN
          CurrencyDate := WORKDATE
        ELSE
          CurrencyDate := "Posting Date";

        IF "Currency Code" = "Job Currency Code" THEN
          "Job Currency Factor" := "Currency Factor"
        ELSE
          "Job Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate,"Job Currency Code");
        TempJobJnlLine.SetCurrencyFactor("Job Currency Factor");
      END;
      TempJobJnlLine.VALIDATE("No.","Account No.");
      TempJobJnlLine.VALIDATE(Quantity,"Job Quantity");

      IF "Currency Factor" = 0 THEN BEGIN
        IF "Job Currency Factor" = 0 THEN
          TmpJobJnlOverallCurrencyFactor := 1
        ELSE
          TmpJobJnlOverallCurrencyFactor := "Job Currency Factor";
      END ELSE BEGIN
        IF "Job Currency Factor" = 0 THEN
          TmpJobJnlOverallCurrencyFactor := 1 / "Currency Factor"
        ELSE
          TmpJobJnlOverallCurrencyFactor := "Job Currency Factor" / "Currency Factor"
      END;

      IF "Job Quantity" <> 0 THEN
        TempJobJnlLine.VALIDATE("Unit Cost",((Amount - "VAT Amount") * TmpJobJnlOverallCurrencyFactor) / "Job Quantity");

      IF (xRec."Account No." = "Account No.") AND (xRec."Job Task No." = "Job Task No.") AND ("Job Unit Price" <> 0) THEN BEGIN
        IF TempJobJnlLine."Cost Factor" = 0 THEN
          TempJobJnlLine."Unit Price" := xRec."Job Unit Price";
        TempJobJnlLine."Line Amount" := xRec."Job Line Amount";
        TempJobJnlLine."Line Discount %" := xRec."Job Line Discount %";
        TempJobJnlLine."Line Discount Amount" := xRec."Job Line Discount Amount";
        TempJobJnlLine.VALIDATE("Unit Price");
      END;

      OnAfterCreateTempJobJnlLine(TempJobJnlLine,Rec,xRec,CurrFieldNo);
    END;

    [External]
    PROCEDURE UpdatePricesFromJobJnlLine@22();
    BEGIN
      "Job Unit Price" := TempJobJnlLine."Unit Price";
      "Job Total Price" := TempJobJnlLine."Total Price";
      "Job Line Amount" := TempJobJnlLine."Line Amount";
      "Job Line Discount Amount" := TempJobJnlLine."Line Discount Amount";
      "Job Unit Cost" := TempJobJnlLine."Unit Cost";
      "Job Total Cost" := TempJobJnlLine."Total Cost";
      "Job Line Discount %" := TempJobJnlLine."Line Discount %";

      "Job Unit Price (LCY)" := TempJobJnlLine."Unit Price (LCY)";
      "Job Total Price (LCY)" := TempJobJnlLine."Total Price (LCY)";
      "Job Line Amount (LCY)" := TempJobJnlLine."Line Amount (LCY)";
      "Job Line Disc. Amount (LCY)" := TempJobJnlLine."Line Discount Amount (LCY)";
      "Job Unit Cost (LCY)" := TempJobJnlLine."Unit Cost (LCY)";
      "Job Total Cost (LCY)" := TempJobJnlLine."Total Cost (LCY)";

      OnAfterUpdatePricesFromJobJnlLine(Rec,TempJobJnlLine);
    END;

    [External]
    PROCEDURE SetHideValidation@23(NewHideValidationDialog@1000 : Boolean);
    BEGIN
      HideValidationDialog := NewHideValidationDialog;
    END;

    LOCAL PROCEDURE GetDefaultICPartnerGLAccNo@1058() : Code[20];
    VAR
      GLAcc@1001 : Record 15;
      GLAccNo@1002 : Code[20];
    BEGIN
      IF "IC Partner Code" <> '' THEN BEGIN
        IF "Account Type" = "Account Type"::"G/L Account" THEN
          GLAccNo := "Account No."
        ELSE
          GLAccNo := "Bal. Account No.";
        IF GLAcc.GET(GLAccNo) THEN
          EXIT(GLAcc."Default IC Partner G/L Acc. No")
      END;
    END;

    [External]
    PROCEDURE IsApplied@30() : Boolean;
    BEGIN
      IF "Applies-to Doc. No." <> '' THEN
        EXIT(TRUE);
      IF "Applies-to ID" <> '' THEN
        EXIT(TRUE);
      EXIT(FALSE);
    END;

    [External]
    PROCEDURE DataCaption@29() : Text[250];
    VAR
      GenJnlBatch@1000 : Record 232;
    BEGIN
      IF GenJnlBatch.GET("Journal Template Name","Journal Batch Name") THEN
        EXIT(GenJnlBatch.Name + '-' + GenJnlBatch.Description);
    END;

    LOCAL PROCEDURE ReadGLSetup@31();
    BEGIN
      IF NOT GLSetupRead THEN BEGIN
        GLSetup.GET;
        GLSetupRead := TRUE;
      END;
    END;

    [External]
    PROCEDURE GetCustLedgerEntry@33();
    BEGIN
      IF ("Account Type" = "Account Type"::Customer) AND ("Account No." = '') AND
         ("Applies-to Doc. No." <> '') AND (Amount = 0)
      THEN BEGIN
        CustLedgEntry.RESET;
        CustLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
        CustLedgEntry.SETRANGE(Open,TRUE);
        IF NOT CustLedgEntry.FINDFIRST THEN
          ERROR(NotExistErr,"Applies-to Doc. No.");

        VALIDATE("Account No.",CustLedgEntry."Customer No.");
        CustLedgEntry.CALCFIELDS("Remaining Amount");

        IF "Posting Date" <= CustLedgEntry."Pmt. Discount Date" THEN
          Amount := -(CustLedgEntry."Remaining Amount" - CustLedgEntry."Remaining Pmt. Disc. Possible")
        ELSE
          Amount := -CustLedgEntry."Remaining Amount";

        IF "Currency Code" <> CustLedgEntry."Currency Code" THEN
          UpdateCurrencyCode(CustLedgEntry."Currency Code");

        SetAppliesToFields(
          CustLedgEntry."Document Type",CustLedgEntry."Document No.",CustLedgEntry."External Document No.");

        GenJnlBatch.GET("Journal Template Name","Journal Batch Name");
        IF GenJnlBatch."Bal. Account No." <> '' THEN BEGIN
          "Bal. Account Type" := GenJnlBatch."Bal. Account Type";
          VALIDATE("Bal. Account No.",GenJnlBatch."Bal. Account No.");
        END ELSE
          VALIDATE(Amount);
      END;
    END;

    [External]
    PROCEDURE GetVendLedgerEntry@37();
    BEGIN
      IF ("Account Type" = "Account Type"::Vendor) AND ("Account No." = '') AND
         ("Applies-to Doc. No." <> '') AND (Amount = 0)
      THEN BEGIN
        VendLedgEntry.RESET;
        VendLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
        VendLedgEntry.SETRANGE(Open,TRUE);
        IF NOT VendLedgEntry.FINDFIRST THEN
          ERROR(NotExistErr,"Applies-to Doc. No.");

        VALIDATE("Account No.",VendLedgEntry."Vendor No.");
        VendLedgEntry.CALCFIELDS("Remaining Amount");

        IF "Posting Date" <= VendLedgEntry."Pmt. Discount Date" THEN
          Amount := -(VendLedgEntry."Remaining Amount" - VendLedgEntry."Remaining Pmt. Disc. Possible")
        ELSE
          Amount := -VendLedgEntry."Remaining Amount";

        IF "Currency Code" <> VendLedgEntry."Currency Code" THEN
          UpdateCurrencyCode(VendLedgEntry."Currency Code");

        SetAppliesToFields(
          VendLedgEntry."Document Type",VendLedgEntry."Document No.",VendLedgEntry."External Document No.");

        GenJnlBatch.GET("Journal Template Name","Journal Batch Name");
        IF GenJnlBatch."Bal. Account No." <> '' THEN BEGIN
          "Bal. Account Type" := GenJnlBatch."Bal. Account Type";
          VALIDATE("Bal. Account No.",GenJnlBatch."Bal. Account No.");
        END ELSE
          VALIDATE(Amount);
      END;
    END;

    [External]
    PROCEDURE GetEmplLedgerEntry@183();
    BEGIN
      IF ("Account Type" = "Account Type"::Employee) AND ("Account No." = '') AND
         ("Applies-to Doc. No." <> '') AND (Amount = 0)
      THEN BEGIN
        EmplLedgEntry.RESET;
        EmplLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
        EmplLedgEntry.SETRANGE(Open,TRUE);
        IF NOT EmplLedgEntry.FINDFIRST THEN
          ERROR(NotExistErr,"Applies-to Doc. No.");

        VALIDATE("Account No.",EmplLedgEntry."Employee No.");
        EmplLedgEntry.CALCFIELDS("Remaining Amount");

        Amount := -EmplLedgEntry."Remaining Amount";

        SetAppliesToFields(EmplLedgEntry."Document Type",EmplLedgEntry."Document No.",'');

        GenJnlBatch.GET("Journal Template Name","Journal Batch Name");
        IF GenJnlBatch."Bal. Account No." <> '' THEN BEGIN
          "Bal. Account Type" := GenJnlBatch."Bal. Account Type";
          VALIDATE("Bal. Account No.",GenJnlBatch."Bal. Account No.");
        END ELSE
          VALIDATE(Amount);
      END;
    END;

    LOCAL PROCEDURE UpdateCurrencyCode@143(NewCurrencyCode@1000 : Code[10]);
    VAR
      FromCurrencyCode@1002 : Code[10];
      ToCurrencyCode@1001 : Code[10];
    BEGIN
      FromCurrencyCode := GetShowCurrencyCode("Currency Code");
      ToCurrencyCode := GetShowCurrencyCode(NewCurrencyCode);
      IF NOT CONFIRM(STRSUBSTNO(ChangeCurrencyQst,FromCurrencyCode,ToCurrencyCode),TRUE) THEN
        ERROR(UpdateInterruptedErr);
      VALIDATE("Currency Code",CurrencyCode);
    END;

    LOCAL PROCEDURE SetAppliesToFields@140(DocType@1000 : Option;DocNo@1001 : Code[20];ExtDocNo@1002 : Code[35]);
    BEGIN
      "Document Type" := "Document Type"::Payment;
      "Applies-to Doc. Type" := DocType;
      "Applies-to Doc. No." := DocNo;
      "Applies-to ID" := '';
      IF ("Applies-to Doc. Type" = "Applies-to Doc. Type"::Invoice) AND
         ("Document Type" = "Document Type"::Payment)
      THEN
        "External Document No." := ExtDocNo;
      "Bal. Account Type" := "Bal. Account Type"::"G/L Account";
    END;

    LOCAL PROCEDURE CustVendAccountNosModified@32() : Boolean;
    BEGIN
      EXIT(
        (("Bal. Account No." <> xRec."Bal. Account No.") AND
         ("Bal. Account Type" IN ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor])) OR
        (("Account No." <> xRec."Account No.") AND
         ("Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor])))
    END;

    LOCAL PROCEDURE CheckPaymentTolerance@34();
    BEGIN
      IF Amount <> 0 THEN
        IF ("Bal. Account No." <> xRec."Bal. Account No.") OR ("Account No." <> xRec."Account No.") THEN
          PaymentToleranceMgt.PmtTolGenJnl(Rec);
    END;

    [External]
    PROCEDURE IncludeVATAmount@38() : Boolean;
    BEGIN
      EXIT(
        ("VAT Posting" = "VAT Posting"::"Manual VAT Entry") AND
        ("VAT Calculation Type" <> "VAT Calculation Type"::"Reverse Charge VAT"));
    END;

    [Internal]
    PROCEDURE ConvertAmtFCYToLCYForSourceCurrency@39(Amount@1000 : Decimal) : Decimal;
    VAR
      Currency@1001 : Record 4;
      CurrExchRate@1003 : Record 330;
      CurrencyFactor@1002 : Decimal;
    BEGIN
      IF (Amount = 0) OR ("Source Currency Code" = '') THEN
        EXIT(Amount);

      Currency.GET("Source Currency Code");
      CurrencyFactor := CurrExchRate.ExchangeRate("Posting Date","Source Currency Code");
      EXIT(
        ROUND(
          CurrExchRate.ExchangeAmtFCYToLCY(
            "Posting Date","Source Currency Code",Amount,CurrencyFactor),
          Currency."Amount Rounding Precision"));
    END;

    [External]
    PROCEDURE MatchSingleLedgerEntry@40();
    BEGIN
      CODEUNIT.RUN(CODEUNIT::"Match General Journal Lines",Rec);
    END;

    [External]
    PROCEDURE GetStyle@41() : Text;
    BEGIN
      IF "Applied Automatically" THEN
        EXIT('Favorable')
    END;

    [External]
    PROCEDURE GetOverdueDateInteractions@75(VAR OverdueWarningText@1001 : Text) : Text;
    VAR
      DueDate@1000 : Date;
    BEGIN
      DueDate := GetAppliesToDocDueDate;
      OverdueWarningText := '';
      IF (DueDate <> 0D) AND (DueDate < "Posting Date") THEN BEGIN
        OverdueWarningText := DueDateMsg;
        EXIT('Unfavorable');
      END;
      EXIT('');
    END;

    [External]
    PROCEDURE ClearDataExchangeEntries@42(DeleteHeaderEntries@1002 : Boolean);
    VAR
      DataExchField@1001 : Record 1221;
      GenJournalLine@1000 : Record 81;
    BEGIN
      DataExchField.DeleteRelatedRecords("Data Exch. Entry No.","Data Exch. Line No.");

      GenJournalLine.SETRANGE("Journal Template Name","Journal Template Name");
      GenJournalLine.SETRANGE("Journal Batch Name","Journal Batch Name");
      GenJournalLine.SETRANGE("Data Exch. Entry No.","Data Exch. Entry No.");
      GenJournalLine.SETFILTER("Line No.",'<>%1',"Line No.");
      IF GenJournalLine.ISEMPTY OR DeleteHeaderEntries THEN
        DataExchField.DeleteRelatedRecords("Data Exch. Entry No.",0);
    END;

    [External]
    PROCEDURE ClearAppliedGenJnlLine@49();
    VAR
      GenJournalLine@1000 : Record 81;
    BEGIN
      IF "Applies-to Doc. No." = '' THEN
        EXIT;
      GenJournalLine.SETRANGE("Journal Template Name","Journal Template Name");
      GenJournalLine.SETRANGE("Journal Batch Name","Journal Batch Name");
      GenJournalLine.SETFILTER("Line No.",'<>%1',"Line No.");
      GenJournalLine.SETRANGE("Document Type","Applies-to Doc. Type");
      GenJournalLine.SETRANGE("Document No.","Applies-to Doc. No.");
      GenJournalLine.MODIFYALL("Applied Automatically",FALSE);
      GenJournalLine.MODIFYALL("Account Type",GenJournalLine."Account Type"::"G/L Account");
      GenJournalLine.MODIFYALL("Account No.",'');
    END;

    [Internal]
    PROCEDURE GetIncomingDocumentURL@50() : Text[1000];
    VAR
      IncomingDocument@1000 : Record 130;
    BEGIN
      IF "Incoming Document Entry No." = 0 THEN
        EXIT('');

      IncomingDocument.GET("Incoming Document Entry No.");
      EXIT(IncomingDocument.GetURL);
    END;

    [External]
    PROCEDURE InsertPaymentFileError@64(Text@1001 : Text);
    VAR
      PaymentJnlExportErrorText@1000 : Record 1228;
    BEGIN
      PaymentJnlExportErrorText.CreateNew(Rec,Text,'','');
    END;

    [External]
    PROCEDURE InsertPaymentFileErrorWithDetails@83(ErrorText@1001 : Text;AddnlInfo@1002 : Text;ExtSupportInfo@1003 : Text);
    VAR
      PaymentJnlExportErrorText@1000 : Record 1228;
    BEGIN
      PaymentJnlExportErrorText.CreateNew(Rec,ErrorText,AddnlInfo,ExtSupportInfo);
    END;

    [External]
    PROCEDURE DeletePaymentFileBatchErrors@67();
    VAR
      PaymentJnlExportErrorText@1000 : Record 1228;
    BEGIN
      PaymentJnlExportErrorText.DeleteJnlBatchErrors(Rec);
    END;

    [External]
    PROCEDURE DeletePaymentFileErrors@61();
    VAR
      PaymentJnlExportErrorText@1000 : Record 1228;
    BEGIN
      PaymentJnlExportErrorText.DeleteJnlLineErrors(Rec);
    END;

    [External]
    PROCEDURE HasPaymentFileErrors@24() : Boolean;
    VAR
      PaymentJnlExportErrorText@1000 : Record 1228;
    BEGIN
      EXIT(PaymentJnlExportErrorText.JnlLineHasErrors(Rec));
    END;

    [External]
    PROCEDURE HasPaymentFileErrorsInBatch@65() : Boolean;
    VAR
      PaymentJnlExportErrorText@1000 : Record 1228;
    BEGIN
      EXIT(PaymentJnlExportErrorText.JnlBatchHasErrors(Rec));
    END;

    LOCAL PROCEDURE UpdateDescription@43(Name@1000 : Text[50]);
    BEGIN
      IF NOT IsAdHocDescription THEN
        Description := Name;
    END;

    LOCAL PROCEDURE IsAdHocDescription@44() : Boolean;
    VAR
      GLAccount@1000 : Record 15;
      Customer@1001 : Record 18;
      Vendor@1002 : Record 23;
      BankAccount@1003 : Record 270;
      FixedAsset@1004 : Record 5600;
      ICPartner@1005 : Record 413;
      Employee@1006 : Record 5200;
    BEGIN
      IF Description = '' THEN
        EXIT(FALSE);
      IF xRec."Account No." = '' THEN
        EXIT(TRUE);

      CASE xRec."Account Type" OF
        xRec."Account Type"::"G/L Account":
          EXIT(GLAccount.GET(xRec."Account No.") AND (GLAccount.Name <> Description));
        xRec."Account Type"::Customer:
          EXIT(Customer.GET(xRec."Account No.") AND (Customer.Name <> Description));
        xRec."Account Type"::Vendor:
          EXIT(Vendor.GET(xRec."Account No.") AND (Vendor.Name <> Description));
        xRec."Account Type"::"Bank Account":
          EXIT(BankAccount.GET(xRec."Account No.") AND (BankAccount.Name <> Description));
        xRec."Account Type"::"Fixed Asset":
          EXIT(FixedAsset.GET(xRec."Account No.") AND (FixedAsset.Description <> Description));
        xRec."Account Type"::"IC Partner":
          EXIT(ICPartner.GET(xRec."Account No.") AND (ICPartner.Name <> Description));
        xRec."Account Type"::Employee:
          EXIT(Employee.GET(xRec."Account No.") AND (Employee.FullName <> Description));
      END;
      EXIT(FALSE);
    END;

    [External]
    PROCEDURE GetAppliesToDocEntryNo@63() : Integer;
    VAR
      CustLedgEntry@1000 : Record 21;
      VendLedgEntry@1001 : Record 25;
      AccType@1003 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee';
      AccNo@1002 : Code[20];
    BEGIN
      GetAccTypeAndNo(Rec,AccType,AccNo);
      CASE AccType OF
        AccType::Customer:
          BEGIN
            GetAppliesToDocCustLedgEntry(CustLedgEntry,AccNo);
            EXIT(CustLedgEntry."Entry No.");
          END;
        AccType::Vendor:
          BEGIN
            GetAppliesToDocVendLedgEntry(VendLedgEntry,AccNo);
            EXIT(VendLedgEntry."Entry No.");
          END;
        AccType::Employee:
          BEGIN
            GetAppliesToDocEmplLedgEntry(EmplLedgEntry,AccNo);
            EXIT(EmplLedgEntry."Entry No.");
          END;
      END;
    END;

    [External]
    PROCEDURE GetAppliesToDocDueDate@62() : Date;
    VAR
      CustLedgEntry@1000 : Record 21;
      VendLedgEntry@1001 : Record 25;
      AccType@1003 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset';
      AccNo@1002 : Code[20];
    BEGIN
      GetAccTypeAndNo(Rec,AccType,AccNo);
      CASE AccType OF
        AccType::Customer:
          BEGIN
            GetAppliesToDocCustLedgEntry(CustLedgEntry,AccNo);
            EXIT(CustLedgEntry."Due Date");
          END;
        AccType::Vendor:
          BEGIN
            GetAppliesToDocVendLedgEntry(VendLedgEntry,AccNo);
            EXIT(VendLedgEntry."Due Date");
          END;
      END;
    END;

    LOCAL PROCEDURE GetAppliesToDocCustLedgEntry@60(VAR CustLedgEntry@1000 : Record 21;AccNo@1001 : Code[20]);
    BEGIN
      CustLedgEntry.SETRANGE("Customer No.",AccNo);
      CustLedgEntry.SETRANGE(Open,TRUE);
      IF "Applies-to Doc. No." <> '' THEN BEGIN
        CustLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
        CustLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
        IF CustLedgEntry.FINDFIRST THEN;
      END ELSE
        IF "Applies-to ID" <> '' THEN BEGIN
          CustLedgEntry.SETRANGE("Applies-to ID","Applies-to ID");
          IF CustLedgEntry.FINDFIRST THEN;
        END;
    END;

    LOCAL PROCEDURE GetAppliesToDocVendLedgEntry@53(VAR VendLedgEntry@1000 : Record 25;AccNo@1001 : Code[20]);
    BEGIN
      VendLedgEntry.SETRANGE("Vendor No.",AccNo);
      VendLedgEntry.SETRANGE(Open,TRUE);
      IF "Applies-to Doc. No." <> '' THEN BEGIN
        VendLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
        VendLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
        IF VendLedgEntry.FINDFIRST THEN;
      END ELSE
        IF "Applies-to ID" <> '' THEN BEGIN
          VendLedgEntry.SETRANGE("Applies-to ID","Applies-to ID");
          IF VendLedgEntry.FINDFIRST THEN;
        END;
    END;

    LOCAL PROCEDURE GetAppliesToDocEmplLedgEntry@180(VAR EmplLedgEntry@1000 : Record 5222;AccNo@1001 : Code[20]);
    BEGIN
      EmplLedgEntry.SETRANGE("Employee No.",AccNo);
      EmplLedgEntry.SETRANGE(Open,TRUE);
      IF "Applies-to Doc. No." <> '' THEN BEGIN
        EmplLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
        EmplLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
        IF EmplLedgEntry.FINDFIRST THEN;
      END ELSE
        IF "Applies-to ID" <> '' THEN BEGIN
          EmplLedgEntry.SETRANGE("Applies-to ID","Applies-to ID");
          IF EmplLedgEntry.FINDFIRST THEN;
        END;
    END;

    LOCAL PROCEDURE SetJournalLineFieldsFromApplication@51();
    VAR
      AccType@1005 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee';
      AccNo@1004 : Code[20];
    BEGIN
      "Exported to Payment File" := FALSE;
      GetAccTypeAndNo(Rec,AccType,AccNo);
      CASE AccType OF
        AccType::Customer:
          IF "Applies-to ID" <> '' THEN BEGIN
            IF FindFirstCustLedgEntryWithAppliesToID(AccNo,"Applies-to ID") THEN BEGIN
              CustLedgEntry.SETRANGE("Exported to Payment File",TRUE);
              "Exported to Payment File" := CustLedgEntry.FINDFIRST;
            END
          END ELSE
            IF "Applies-to Doc. No." <> '' THEN
              IF FindFirstCustLedgEntryWithAppliesToDocNo(AccNo,"Applies-to Doc. No.") THEN BEGIN
                "Exported to Payment File" := CustLedgEntry."Exported to Payment File";
                "Applies-to Ext. Doc. No." := CustLedgEntry."External Document No.";
              END;
        AccType::Vendor:
          IF "Applies-to ID" <> '' THEN BEGIN
            IF FindFirstVendLedgEntryWithAppliesToID(AccNo,"Applies-to ID") THEN BEGIN
              VendLedgEntry.SETRANGE("Exported to Payment File",TRUE);
              "Exported to Payment File" := VendLedgEntry.FINDFIRST;
            END
          END ELSE
            IF "Applies-to Doc. No." <> '' THEN
              IF FindFirstVendLedgEntryWithAppliesToDocNo(AccNo,"Applies-to Doc. No.") THEN BEGIN
                "Exported to Payment File" := VendLedgEntry."Exported to Payment File";
                "Applies-to Ext. Doc. No." := VendLedgEntry."External Document No.";
              END;
        AccType::Employee:
          IF "Applies-to ID" <> '' THEN BEGIN
            IF FindFirstEmplLedgEntryWithAppliesToID(AccNo,"Applies-to ID") THEN BEGIN
              EmplLedgEntry.SETRANGE("Exported to Payment File",TRUE);
              "Exported to Payment File" := EmplLedgEntry.FINDFIRST;
            END
          END ELSE
            IF "Applies-to Doc. No." <> '' THEN
              IF FindFirstEmplLedgEntryWithAppliesToDocNo(AccNo,"Applies-to Doc. No.") THEN
                "Exported to Payment File" := EmplLedgEntry."Exported to Payment File";
      END;
    END;

    LOCAL PROCEDURE GetAccTypeAndNo@52(GenJnlLine2@1002 : Record 81;VAR AccType@1000 : Option;VAR AccNo@1001 : Code[20]);
    BEGIN
      IF GenJnlLine2."Bal. Account Type" IN
         [GenJnlLine2."Bal. Account Type"::Customer,GenJnlLine2."Bal. Account Type"::Vendor,GenJnlLine2."Bal. Account Type"::Employee]
      THEN BEGIN
        AccType := GenJnlLine2."Bal. Account Type";
        AccNo := GenJnlLine2."Bal. Account No.";
      END ELSE BEGIN
        AccType := GenJnlLine2."Account Type";
        AccNo := GenJnlLine2."Account No.";
      END;
    END;

    LOCAL PROCEDURE FindFirstCustLedgEntryWithAppliesToID@54(AccNo@1000 : Code[20];AppliesToID@1001 : Code[50]) : Boolean;
    BEGIN
      CustLedgEntry.RESET;
      CustLedgEntry.SETCURRENTKEY("Customer No.","Applies-to ID",Open);
      CustLedgEntry.SETRANGE("Customer No.",AccNo);
      CustLedgEntry.SETRANGE("Applies-to ID",AppliesToID);
      CustLedgEntry.SETRANGE(Open,TRUE);
      EXIT(CustLedgEntry.FINDFIRST)
    END;

    LOCAL PROCEDURE FindFirstCustLedgEntryWithAppliesToDocNo@55(AccNo@1000 : Code[20];AppliestoDocNo@1001 : Code[20]) : Boolean;
    BEGIN
      CustLedgEntry.RESET;
      CustLedgEntry.SETCURRENTKEY("Document No.");
      CustLedgEntry.SETRANGE("Document No.",AppliestoDocNo);
      CustLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
      CustLedgEntry.SETRANGE("Customer No.",AccNo);
      CustLedgEntry.SETRANGE(Open,TRUE);
      EXIT(CustLedgEntry.FINDFIRST)
    END;

    LOCAL PROCEDURE FindFirstVendLedgEntryWithAppliesToID@58(AccNo@1000 : Code[20];AppliesToID@1001 : Code[50]) : Boolean;
    BEGIN
      VendLedgEntry.RESET;
      VendLedgEntry.SETCURRENTKEY("Vendor No.","Applies-to ID",Open);
      VendLedgEntry.SETRANGE("Vendor No.",AccNo);
      VendLedgEntry.SETRANGE("Applies-to ID",AppliesToID);
      VendLedgEntry.SETRANGE(Open,TRUE);
      EXIT(VendLedgEntry.FINDFIRST)
    END;

    LOCAL PROCEDURE FindFirstVendLedgEntryWithAppliesToDocNo@59(AccNo@1000 : Code[20];AppliestoDocNo@1001 : Code[20]) : Boolean;
    BEGIN
      VendLedgEntry.RESET;
      VendLedgEntry.SETCURRENTKEY("Document No.");
      VendLedgEntry.SETRANGE("Document No.",AppliestoDocNo);
      VendLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
      VendLedgEntry.SETRANGE("Vendor No.",AccNo);
      VendLedgEntry.SETRANGE(Open,TRUE);
      EXIT(VendLedgEntry.FINDFIRST)
    END;

    LOCAL PROCEDURE FindFirstEmplLedgEntryWithAppliesToID@191(AccNo@1000 : Code[20];AppliesToID@1001 : Code[50]) : Boolean;
    BEGIN
      EmplLedgEntry.RESET;
      EmplLedgEntry.SETCURRENTKEY("Employee No.","Applies-to ID",Open);
      EmplLedgEntry.SETRANGE("Employee No.",AccNo);
      EmplLedgEntry.SETRANGE("Applies-to ID",AppliesToID);
      EmplLedgEntry.SETRANGE(Open,TRUE);
      EXIT(EmplLedgEntry.FINDFIRST)
    END;

    LOCAL PROCEDURE FindFirstEmplLedgEntryWithAppliesToDocNo@190(AccNo@1000 : Code[20];AppliestoDocNo@1001 : Code[20]) : Boolean;
    BEGIN
      EmplLedgEntry.RESET;
      EmplLedgEntry.SETCURRENTKEY("Document No.");
      EmplLedgEntry.SETRANGE("Document No.",AppliestoDocNo);
      EmplLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
      EmplLedgEntry.SETRANGE("Employee No.",AccNo);
      EmplLedgEntry.SETRANGE(Open,TRUE);
      EXIT(EmplLedgEntry.FINDFIRST)
    END;

    LOCAL PROCEDURE ClearPostingGroups@45();
    BEGIN
      "Gen. Posting Type" := "Gen. Posting Type"::" ";
      "Gen. Bus. Posting Group" := '';
      "Gen. Prod. Posting Group" := '';
      "VAT Bus. Posting Group" := '';
      "VAT Prod. Posting Group" := '';

      OnAfterClearPostingGroups(Rec);
    END;

    LOCAL PROCEDURE ClearBalancePostingGroups@48();
    BEGIN
      "Bal. Gen. Posting Type" := "Bal. Gen. Posting Type"::" ";
      "Bal. Gen. Bus. Posting Group" := '';
      "Bal. Gen. Prod. Posting Group" := '';
      "Bal. VAT Bus. Posting Group" := '';
      "Bal. VAT Prod. Posting Group" := '';

      OnAfterClearBalPostingGroups(Rec);
    END;

    LOCAL PROCEDURE CleanLine@66();
    BEGIN
      UpdateLineBalance;
      UpdateSource;
      CreateDim(
        DimMgt.TypeToTableID1("Account Type"),"Account No.",
        DimMgt.TypeToTableID1("Bal. Account Type"),"Bal. Account No.",
        DATABASE::Job,"Job No.",
        DATABASE::"Salesperson/Purchaser","Salespers./Purch. Code",
        DATABASE::Campaign,"Campaign No.");
      IF NOT ("Bal. Account Type" IN ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor]) THEN
        "Recipient Bank Account" := '';
      IF xRec."Account No." <> '' THEN BEGIN
        ClearPostingGroups;
        "Tax Area Code" := '';
        "Tax Liable" := FALSE;
        "Tax Group Code" := '';
        "Bill-to/Pay-to No." := '';
        "Ship-to/Order Address Code" := '';
        "Sell-to/Buy-from No." := '';
        UpdateCountryCodeAndVATRegNo('');
      END;

      CASE "Account Type" OF
        "Account Type"::"G/L Account":
          UpdateAccountID;
        "Account Type"::Customer:
          UpdateCustomerID;
      END;
    END;

    LOCAL PROCEDURE ReplaceDescription@84() : Boolean;
    BEGIN
      IF "Bal. Account No." = '' THEN
        EXIT(TRUE);
      GenJnlBatch.GET("Journal Template Name","Journal Batch Name");
      EXIT(GenJnlBatch."Bal. Account No." <> '');
    END;

    [External]
    PROCEDURE IsExportedToPaymentFile@1020() : Boolean;
    BEGIN
      EXIT(IsPaymentJournallLineExported OR IsAppliedToVendorLedgerEntryExported);
    END;

    [External]
    PROCEDURE IsPaymentJournallLineExported@80() : Boolean;
    VAR
      GenJnlLine@1001 : Record 81;
      OldFilterGroup@1000 : Integer;
      HasExportedLines@1002 : Boolean;
    BEGIN
      WITH GenJnlLine DO BEGIN
        COPYFILTERS(Rec);
        OldFilterGroup := FILTERGROUP;
        FILTERGROUP := 10;
        SETRANGE("Exported to Payment File",TRUE);
        HasExportedLines := NOT ISEMPTY;
        SETRANGE("Exported to Payment File");
        FILTERGROUP := OldFilterGroup;
      END;
      EXIT(HasExportedLines);
    END;

    [External]
    PROCEDURE IsAppliedToVendorLedgerEntryExported@79() : Boolean;
    VAR
      GenJnlLine@1001 : Record 81;
      VendLedgerEntry@1002 : Record 25;
    BEGIN
      GenJnlLine.COPYFILTERS(Rec);

      IF GenJnlLine.FINDSET THEN
        REPEAT
          IF GenJnlLine.IsApplied THEN BEGIN
            VendLedgerEntry.SETRANGE("Vendor No.",GenJnlLine."Account No.");
            IF GenJnlLine."Applies-to Doc. No." <> '' THEN BEGIN
              VendLedgerEntry.SETRANGE("Document Type",GenJnlLine."Applies-to Doc. Type");
              VendLedgerEntry.SETRANGE("Document No.",GenJnlLine."Applies-to Doc. No.");
            END;
            IF GenJnlLine."Applies-to ID" <> '' THEN
              VendLedgerEntry.SETRANGE("Applies-to ID",GenJnlLine."Applies-to ID");
            VendLedgerEntry.SETRANGE("Exported to Payment File",TRUE);
            IF NOT VendLedgerEntry.ISEMPTY THEN
              EXIT(TRUE);
          END;

          VendLedgerEntry.RESET;
          VendLedgerEntry.SETRANGE("Vendor No.",GenJnlLine."Account No.");
          VendLedgerEntry.SETRANGE("Applies-to Doc. Type",GenJnlLine."Document Type");
          VendLedgerEntry.SETRANGE("Applies-to Doc. No.",GenJnlLine."Document No.");
          VendLedgerEntry.SETRANGE("Exported to Payment File",TRUE);
          IF NOT VendLedgerEntry.ISEMPTY THEN
            EXIT(TRUE);
        UNTIL GenJnlLine.NEXT = 0;

      EXIT(FALSE);
    END;

    LOCAL PROCEDURE ClearAppliedAutomatically@72();
    BEGIN
      IF CurrFieldNo <> 0 THEN
        "Applied Automatically" := FALSE;
    END;

    [External]
    PROCEDURE SetPostingDateAsDueDate@77(DueDate@1002 : Date;DateOffset@1000 : DateFormula) : Boolean;
    VAR
      NewPostingDate@1001 : Date;
    BEGIN
      IF DueDate = 0D THEN
        EXIT(FALSE);

      NewPostingDate := CALCDATE(DateOffset,DueDate);
      IF NewPostingDate < WORKDATE THEN BEGIN
        VALIDATE("Posting Date",WORKDATE);
        EXIT(TRUE);
      END;

      VALIDATE("Posting Date",NewPostingDate);
      EXIT(FALSE);
    END;

    [External]
    PROCEDURE CalculatePostingDate@76();
    VAR
      GenJnlLine@1000 : Record 81;
      EmptyDateFormula@1001 : DateFormula;
    BEGIN
      GenJnlLine.COPY(Rec);
      GenJnlLine.SETRANGE("Journal Template Name","Journal Template Name");
      GenJnlLine.SETRANGE("Journal Batch Name","Journal Batch Name");

      IF GenJnlLine.FINDSET THEN BEGIN
        Window.OPEN(CalcPostDateMsg);
        REPEAT
          EVALUATE(EmptyDateFormula,'<0D>');
          GenJnlLine.SetPostingDateAsDueDate(GenJnlLine.GetAppliesToDocDueDate,EmptyDateFormula);
          GenJnlLine.MODIFY(TRUE);
          Window.UPDATE(1,GenJnlLine."Document No.");
        UNTIL GenJnlLine.NEXT = 0;
        Window.CLOSE;
      END;
    END;

    [Internal]
    PROCEDURE ImportBankStatement@73();
    VAR
      ProcessGenJnlLines@1000 : Codeunit 1247;
    BEGIN
      ProcessGenJnlLines.ImportBankStatement(Rec);
    END;

    [External]
    PROCEDURE ExportPaymentFile@81();
    VAR
      BankAcc@1000 : Record 270;
    BEGIN
      IF NOT FINDSET THEN
        ERROR(NothingToExportErr);
      SETRANGE("Journal Template Name","Journal Template Name");
      SETRANGE("Journal Batch Name","Journal Batch Name");
      TESTFIELD("Check Printed",FALSE);

      GenJnlBatch.GET("Journal Template Name","Journal Batch Name");
      GenJnlBatch.TESTFIELD("Bal. Account Type",GenJnlBatch."Bal. Account Type"::"Bank Account");
      GenJnlBatch.TESTFIELD("Bal. Account No.");

      CheckDocNoOnLines;
      IF IsExportedToPaymentFile THEN
        IF NOT CONFIRM(ExportAgainQst) THEN
          EXIT;
      BankAcc.GET(GenJnlBatch."Bal. Account No.");
      IF BankAcc.GetPaymentExportCodeunitID > 0 THEN
        CODEUNIT.RUN(BankAcc.GetPaymentExportCodeunitID,Rec)
      ELSE
        CODEUNIT.RUN(CODEUNIT::"Exp. Launcher Gen. Jnl.",Rec);
    END;

    [External]
    PROCEDURE TotalExportedAmount@85() : Decimal;
    VAR
      CreditTransferEntry@1000 : Record 1206;
    BEGIN
      IF NOT ("Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor,"Account Type"::Employee]) THEN
        EXIT(0);
      GenJnlShowCTEntries.SetFiltersOnCreditTransferEntry(Rec,CreditTransferEntry);
      CreditTransferEntry.CALCSUMS("Transfer Amount");
      EXIT(CreditTransferEntry."Transfer Amount");
    END;

    [External]
    PROCEDURE DrillDownExportedAmount@95();
    VAR
      CreditTransferEntry@1000 : Record 1206;
    BEGIN
      IF NOT ("Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor,"Account Type"::Employee]) THEN
        EXIT;
      GenJnlShowCTEntries.SetFiltersOnCreditTransferEntry(Rec,CreditTransferEntry);
      PAGE.RUN(PAGE::"Credit Transfer Reg. Entries",CreditTransferEntry);
    END;

    LOCAL PROCEDURE CopyDimensionsFromJobTaskLine@82();
    BEGIN
      "Dimension Set ID" := TempJobJnlLine."Dimension Set ID";
      "Shortcut Dimension 1 Code" := TempJobJnlLine."Shortcut Dimension 1 Code";
      "Shortcut Dimension 2 Code" := TempJobJnlLine."Shortcut Dimension 2 Code";
    END;

    [External]
    PROCEDURE CopyDocumentFields@129(DocType@1004 : Option;DocNo@1003 : Code[20];ExtDocNo@1002 : Text[35];SourceCode@1001 : Code[10];NoSeriesCode@1000 : Code[20]);
    BEGIN
      "Document Type" := DocType;
      "Document No." := DocNo;
      "External Document No." := ExtDocNo;
      "Source Code" := SourceCode;
      IF NoSeriesCode <> '' THEN
        "Posting No. Series" := NoSeriesCode;
    END;

    [External]
    PROCEDURE CopyCustLedgEntry@134(CustLedgerEntry@1000 : Record 21);
    BEGIN
      "Document Type" := CustLedgerEntry."Document Type";
      Description := CustLedgerEntry.Description;
      "Shortcut Dimension 1 Code" := CustLedgerEntry."Global Dimension 1 Code";
      "Shortcut Dimension 2 Code" := CustLedgerEntry."Global Dimension 2 Code";
      "Dimension Set ID" := CustLedgerEntry."Dimension Set ID";
      "Posting Group" := CustLedgerEntry."Customer Posting Group";
      "Source Type" := "Source Type"::Customer;
      "Source No." := CustLedgerEntry."Customer No.";

      OnAfterCopyGenJnlLineFromCustLedgEntry(CustLedgEntry,Rec);
    END;

    [External]
    PROCEDURE CopyFromGenJnlAllocation@113(GenJnlAlloc@1000 : Record 221);
    BEGIN
      "Account No." := GenJnlAlloc."Account No.";
      "Shortcut Dimension 1 Code" := GenJnlAlloc."Shortcut Dimension 1 Code";
      "Shortcut Dimension 2 Code" := GenJnlAlloc."Shortcut Dimension 2 Code";
      "Dimension Set ID" := GenJnlAlloc."Dimension Set ID";
      "Gen. Posting Type" := GenJnlAlloc."Gen. Posting Type";
      "Gen. Bus. Posting Group" := GenJnlAlloc."Gen. Bus. Posting Group";
      "Gen. Prod. Posting Group" := GenJnlAlloc."Gen. Prod. Posting Group";
      "VAT Bus. Posting Group" := GenJnlAlloc."VAT Bus. Posting Group";
      "VAT Prod. Posting Group" := GenJnlAlloc."VAT Prod. Posting Group";
      "Tax Area Code" := GenJnlAlloc."Tax Area Code";
      "Tax Liable" := GenJnlAlloc."Tax Liable";
      "Tax Group Code" := GenJnlAlloc."Tax Group Code";
      "Use Tax" := GenJnlAlloc."Use Tax";
      "VAT Calculation Type" := GenJnlAlloc."VAT Calculation Type";
      "VAT Amount" := GenJnlAlloc."VAT Amount";
      "VAT Base Amount" := GenJnlAlloc.Amount - GenJnlAlloc."VAT Amount";
      "VAT %" := GenJnlAlloc."VAT %";
      "Source Currency Amount" := GenJnlAlloc."Additional-Currency Amount";
      Amount := GenJnlAlloc.Amount;
      "Amount (LCY)" := GenJnlAlloc.Amount;

      OnAfterCopyGenJnlLineFromGenJnlAllocation(GenJnlAlloc,Rec);
    END;

    [External]
    PROCEDURE CopyFromInvoicePostBuffer@112(InvoicePostBuffer@1001 : Record 49);
    BEGIN
      "Account No." := InvoicePostBuffer."G/L Account";
      "System-Created Entry" := InvoicePostBuffer."System-Created Entry";
      "Gen. Bus. Posting Group" := InvoicePostBuffer."Gen. Bus. Posting Group";
      "Gen. Prod. Posting Group" := InvoicePostBuffer."Gen. Prod. Posting Group";
      "VAT Bus. Posting Group" := InvoicePostBuffer."VAT Bus. Posting Group";
      "VAT Prod. Posting Group" := InvoicePostBuffer."VAT Prod. Posting Group";
      "Tax Area Code" := InvoicePostBuffer."Tax Area Code";
      "Tax Liable" := InvoicePostBuffer."Tax Liable";
      "Tax Group Code" := InvoicePostBuffer."Tax Group Code";
      "Use Tax" := InvoicePostBuffer."Use Tax";
      Quantity := InvoicePostBuffer.Quantity;
      "VAT %" := InvoicePostBuffer."VAT %";
      "VAT Calculation Type" := InvoicePostBuffer."VAT Calculation Type";
      "VAT Posting" := "VAT Posting"::"Manual VAT Entry";
      "Job No." := InvoicePostBuffer."Job No.";
      "Deferral Code" := InvoicePostBuffer."Deferral Code";
      "Deferral Line No." := InvoicePostBuffer."Deferral Line No.";
      Amount := InvoicePostBuffer.Amount;
      "Source Currency Amount" := InvoicePostBuffer."Amount (ACY)";
      "VAT Base Amount" := InvoicePostBuffer."VAT Base Amount";
      "Source Curr. VAT Base Amount" := InvoicePostBuffer."VAT Base Amount (ACY)";
      "VAT Amount" := InvoicePostBuffer."VAT Amount";
      "Source Curr. VAT Amount" := InvoicePostBuffer."VAT Amount (ACY)";
      "VAT Difference" := InvoicePostBuffer."VAT Difference";

      OnAfterCopyGenJnlLineFromInvPostBuffer(InvoicePostBuffer,Rec);
    END;

    [External]
    PROCEDURE CopyFromInvoicePostBufferFA@111(InvoicePostBuffer@1001 : Record 49);
    BEGIN
      "Account Type" := "Account Type"::"Fixed Asset";
      "FA Posting Date" := InvoicePostBuffer."FA Posting Date";
      "Depreciation Book Code" := InvoicePostBuffer."Depreciation Book Code";
      "Salvage Value" := InvoicePostBuffer."Salvage Value";
      "Depr. until FA Posting Date" := InvoicePostBuffer."Depr. until FA Posting Date";
      "Depr. Acquisition Cost" := InvoicePostBuffer."Depr. Acquisition Cost";
      "Maintenance Code" := InvoicePostBuffer."Maintenance Code";
      "Insurance No." := InvoicePostBuffer."Insurance No.";
      "Budgeted FA No." := InvoicePostBuffer."Budgeted FA No.";
      "Duplicate in Depreciation Book" := InvoicePostBuffer."Duplicate in Depreciation Book";
      "Use Duplication List" := InvoicePostBuffer."Use Duplication List";

      OnAfterCopyGenJnlLineFromInvPostBufferFA(InvoicePostBuffer,Rec);
    END;

    [External]
    PROCEDURE CopyFromPrepmtInvoiceBuffer@110(PrepmtInvLineBuffer@1001 : Record 461);
    BEGIN
      "Account No." := PrepmtInvLineBuffer."G/L Account No.";
      "Gen. Bus. Posting Group" := PrepmtInvLineBuffer."Gen. Bus. Posting Group";
      "Gen. Prod. Posting Group" := PrepmtInvLineBuffer."Gen. Prod. Posting Group";
      "VAT Bus. Posting Group" := PrepmtInvLineBuffer."VAT Bus. Posting Group";
      "VAT Prod. Posting Group" := PrepmtInvLineBuffer."VAT Prod. Posting Group";
      "Tax Area Code" := PrepmtInvLineBuffer."Tax Area Code";
      "Tax Liable" := PrepmtInvLineBuffer."Tax Liable";
      "Tax Group Code" := PrepmtInvLineBuffer."Tax Group Code";
      "Use Tax" := FALSE;
      "VAT Calculation Type" := PrepmtInvLineBuffer."VAT Calculation Type";
      "Job No." := PrepmtInvLineBuffer."Job No.";
      Amount := PrepmtInvLineBuffer.Amount;
      "Source Currency Amount" := PrepmtInvLineBuffer."Amount (ACY)";
      "VAT Base Amount" := PrepmtInvLineBuffer."VAT Base Amount";
      "Source Curr. VAT Base Amount" := PrepmtInvLineBuffer."VAT Base Amount (ACY)";
      "VAT Amount" := PrepmtInvLineBuffer."VAT Amount";
      "Source Curr. VAT Amount" := PrepmtInvLineBuffer."VAT Amount (ACY)";
      "VAT Difference" := PrepmtInvLineBuffer."VAT Difference";

      OnAfterCopyGenJnlLineFromPrepmtInvBuffer(PrepmtInvLineBuffer,Rec);
    END;

    [External]
    PROCEDURE CopyFromPurchHeader@109(PurchHeader@1001 : Record 38);
    BEGIN
      "Source Currency Code" := PurchHeader."Currency Code";
      "Currency Factor" := PurchHeader."Currency Factor";
      Correction := PurchHeader.Correction;
      "VAT Base Discount %" := PurchHeader."VAT Base Discount %";
      "Sell-to/Buy-from No." := PurchHeader."Buy-from Vendor No.";
      "Bill-to/Pay-to No." := PurchHeader."Pay-to Vendor No.";
      "Country/Region Code" := PurchHeader."VAT Country/Region Code";
      "VAT Registration No." := PurchHeader."VAT Registration No.";
      "Source Type" := "Source Type"::Vendor;
      "Source No." := PurchHeader."Pay-to Vendor No.";
      "Posting No. Series" := PurchHeader."Posting No. Series";
      "IC Partner Code" := PurchHeader."Pay-to IC Partner Code";
      "Ship-to/Order Address Code" := PurchHeader."Order Address Code";
      "Salespers./Purch. Code" := PurchHeader."Purchaser Code";
      "On Hold" := PurchHeader."On Hold";
      IF "Account Type" = "Account Type"::Vendor THEN
        "Posting Group" := PurchHeader."Vendor Posting Group";

      OnAfterCopyGenJnlLineFromPurchHeader(PurchHeader,Rec);
    END;

    [External]
    PROCEDURE CopyFromPurchHeaderPrepmt@127(PurchHeader@1000 : Record 38);
    BEGIN
      "Source Currency Code" := PurchHeader."Currency Code";
      "VAT Base Discount %" := PurchHeader."VAT Base Discount %";
      "Bill-to/Pay-to No." := PurchHeader."Pay-to Vendor No.";
      "Country/Region Code" := PurchHeader."VAT Country/Region Code";
      "VAT Registration No." := PurchHeader."VAT Registration No.";
      "Source Type" := "Source Type"::Vendor;
      "Source No." := PurchHeader."Pay-to Vendor No.";
      "IC Partner Code" := PurchHeader."Buy-from IC Partner Code";
      "VAT Posting" := "VAT Posting"::"Manual VAT Entry";
      "System-Created Entry" := TRUE;
      Prepayment := TRUE;

      OnAfterCopyGenJnlLineFromPurchHeaderPrepmt(PurchHeader,Rec);
    END;

    [External]
    PROCEDURE CopyFromPurchHeaderPrepmtPost@137(PurchHeader@1000 : Record 38;UsePmtDisc@1001 : Boolean);
    BEGIN
      "Account Type" := "Account Type"::Vendor;
      "Account No." := PurchHeader."Pay-to Vendor No.";
      SetCurrencyFactor(PurchHeader."Currency Code",PurchHeader."Currency Factor");
      "Source Currency Code" := PurchHeader."Currency Code";
      "Bill-to/Pay-to No." := PurchHeader."Pay-to Vendor No.";
      "Sell-to/Buy-from No." := PurchHeader."Buy-from Vendor No.";
      "Salespers./Purch. Code" := PurchHeader."Purchaser Code";
      "Source Type" := "Source Type"::Customer;
      "Source No." := PurchHeader."Pay-to Vendor No.";
      "IC Partner Code" := PurchHeader."Buy-from IC Partner Code";
      "System-Created Entry" := TRUE;
      Prepayment := TRUE;
      "Due Date" := PurchHeader."Prepayment Due Date";
      "Payment Terms Code" := PurchHeader."Payment Terms Code";
      IF UsePmtDisc THEN BEGIN
        "Pmt. Discount Date" := PurchHeader."Prepmt. Pmt. Discount Date";
        "Payment Discount %" := PurchHeader."Prepmt. Payment Discount %";
      END;

      OnAfterCopyGenJnlLineFromPurchHeaderPrepmtPost(PurchHeader,Rec,UsePmtDisc);
    END;

    [External]
    PROCEDURE CopyFromPurchHeaderApplyTo@107(PurchHeader@1001 : Record 38);
    BEGIN
      "Applies-to Doc. Type" := PurchHeader."Applies-to Doc. Type";
      "Applies-to Doc. No." := PurchHeader."Applies-to Doc. No.";
      "Applies-to ID" := PurchHeader."Applies-to ID";
      "Allow Application" := PurchHeader."Bal. Account No." = '';

      OnAfterCopyGenJnlLineFromPurchHeaderApplyTo(PurchHeader,Rec);
    END;

    [External]
    PROCEDURE CopyFromPurchHeaderPayment@104(PurchHeader@1001 : Record 38);
    BEGIN
      "Due Date" := PurchHeader."Due Date";
      "Payment Terms Code" := PurchHeader."Payment Terms Code";
      "Pmt. Discount Date" := PurchHeader."Pmt. Discount Date";
      "Payment Discount %" := PurchHeader."Payment Discount %";
      "Creditor No." := PurchHeader."Creditor No.";
      "Payment Reference" := PurchHeader."Payment Reference";
      "Payment Method Code" := PurchHeader."Payment Method Code";

      OnAfterCopyGenJnlLineFromPurchHeaderPayment(PurchHeader,Rec);
    END;

    [External]
    PROCEDURE CopyFromSalesHeader@103(SalesHeader@1001 : Record 36);
    BEGIN
      "Source Currency Code" := SalesHeader."Currency Code";
      "Currency Factor" := SalesHeader."Currency Factor";
      "VAT Base Discount %" := SalesHeader."VAT Base Discount %";
      Correction := SalesHeader.Correction;
      "EU 3-Party Trade" := SalesHeader."EU 3-Party Trade";
      "Sell-to/Buy-from No." := SalesHeader."Sell-to Customer No.";
      "Bill-to/Pay-to No." := SalesHeader."Bill-to Customer No.";
      "Country/Region Code" := SalesHeader."VAT Country/Region Code";
      "VAT Registration No." := SalesHeader."VAT Registration No.";
      "Source Type" := "Source Type"::Customer;
      "Source No." := SalesHeader."Bill-to Customer No.";
      "Posting No. Series" := SalesHeader."Posting No. Series";
      "Ship-to/Order Address Code" := SalesHeader."Ship-to Code";
      "IC Partner Code" := SalesHeader."Sell-to IC Partner Code";
      "Salespers./Purch. Code" := SalesHeader."Salesperson Code";
      "On Hold" := SalesHeader."On Hold";
      IF "Account Type" = "Account Type"::Customer THEN
        "Posting Group" := SalesHeader."Customer Posting Group";

      OnAfterCopyGenJnlLineFromSalesHeader(SalesHeader,Rec);
    END;

    [External]
    PROCEDURE CopyFromSalesHeaderPrepmt@119(SalesHeader@1000 : Record 36);
    BEGIN
      "Source Currency Code" := SalesHeader."Currency Code";
      "VAT Base Discount %" := SalesHeader."VAT Base Discount %";
      "EU 3-Party Trade" := SalesHeader."EU 3-Party Trade";
      "Bill-to/Pay-to No." := SalesHeader."Bill-to Customer No.";
      "Country/Region Code" := SalesHeader."VAT Country/Region Code";
      "VAT Registration No." := SalesHeader."VAT Registration No.";
      "Source Type" := "Source Type"::Customer;
      "Source No." := SalesHeader."Bill-to Customer No.";
      "IC Partner Code" := SalesHeader."Sell-to IC Partner Code";
      "VAT Posting" := "VAT Posting"::"Manual VAT Entry";
      "System-Created Entry" := TRUE;
      Prepayment := TRUE;

      OnAfterCopyGenJnlLineFromSalesHeaderPrepmt(SalesHeader,Rec);
    END;

    [External]
    PROCEDURE CopyFromSalesHeaderPrepmtPost@138(SalesHeader@1000 : Record 36;UsePmtDisc@1001 : Boolean);
    BEGIN
      "Account Type" := "Account Type"::Customer;
      "Account No." := SalesHeader."Bill-to Customer No.";
      SetCurrencyFactor(SalesHeader."Currency Code",SalesHeader."Currency Factor");
      "Source Currency Code" := SalesHeader."Currency Code";
      "Sell-to/Buy-from No." := SalesHeader."Sell-to Customer No.";
      "Bill-to/Pay-to No." := SalesHeader."Bill-to Customer No.";
      "Salespers./Purch. Code" := SalesHeader."Salesperson Code";
      "Source Type" := "Source Type"::Customer;
      "Source No." := SalesHeader."Bill-to Customer No.";
      "IC Partner Code" := SalesHeader."Sell-to IC Partner Code";
      "System-Created Entry" := TRUE;
      Prepayment := TRUE;
      "Due Date" := SalesHeader."Prepayment Due Date";
      "Payment Terms Code" := SalesHeader."Prepmt. Payment Terms Code";
      IF UsePmtDisc THEN BEGIN
        "Pmt. Discount Date" := SalesHeader."Prepmt. Pmt. Discount Date";
        "Payment Discount %" := SalesHeader."Prepmt. Payment Discount %";
      END;

      OnAfterCopyGenJnlLineFromSalesHeaderPrepmtPost(SalesHeader,Rec,UsePmtDisc);
    END;

    [External]
    PROCEDURE CopyFromSalesHeaderApplyTo@100(SalesHeader@1001 : Record 36);
    BEGIN
      "Applies-to Doc. Type" := SalesHeader."Applies-to Doc. Type";
      "Applies-to Doc. No." := SalesHeader."Applies-to Doc. No.";
      "Applies-to ID" := SalesHeader."Applies-to ID";
      "Allow Application" := SalesHeader."Bal. Account No." = '';

      OnAfterCopyGenJnlLineFromSalesHeaderApplyTo(SalesHeader,Rec);
    END;

    [External]
    PROCEDURE CopyFromSalesHeaderPayment@99(SalesHeader@1001 : Record 36);
    BEGIN
      "Due Date" := SalesHeader."Due Date";
      "Payment Terms Code" := SalesHeader."Payment Terms Code";
      "Payment Method Code" := SalesHeader."Payment Method Code";
      "Pmt. Discount Date" := SalesHeader."Pmt. Discount Date";
      "Payment Discount %" := SalesHeader."Payment Discount %";
      "Direct Debit Mandate ID" := SalesHeader."Direct Debit Mandate ID";

      OnAfterCopyGenJnlLineFromSalesHeaderPayment(SalesHeader,Rec);
    END;

    [External]
    PROCEDURE CopyFromServiceHeader@98(ServiceHeader@1001 : Record 5900);
    BEGIN
      "Source Currency Code" := ServiceHeader."Currency Code";
      Correction := ServiceHeader.Correction;
      "VAT Base Discount %" := ServiceHeader."VAT Base Discount %";
      "Sell-to/Buy-from No." := ServiceHeader."Customer No.";
      "Bill-to/Pay-to No." := ServiceHeader."Bill-to Customer No.";
      "Country/Region Code" := ServiceHeader."VAT Country/Region Code";
      "VAT Registration No." := ServiceHeader."VAT Registration No.";
      "Source Type" := "Source Type"::Customer;
      "Source No." := ServiceHeader."Bill-to Customer No.";
      "Posting No. Series" := ServiceHeader."Posting No. Series";
      "Ship-to/Order Address Code" := ServiceHeader."Ship-to Code";
      "EU 3-Party Trade" := ServiceHeader."EU 3-Party Trade";
      "Salespers./Purch. Code" := ServiceHeader."Salesperson Code";

      OnAfterCopyGenJnlLineFromServHeader(ServiceHeader,Rec);
    END;

    [External]
    PROCEDURE CopyFromServiceHeaderApplyTo@97(ServiceHeader@1001 : Record 5900);
    BEGIN
      "Applies-to Doc. Type" := ServiceHeader."Applies-to Doc. Type";
      "Applies-to Doc. No." := ServiceHeader."Applies-to Doc. No.";
      "Applies-to ID" := ServiceHeader."Applies-to ID";
      "Allow Application" := ServiceHeader."Bal. Account No." = '';

      OnAfterCopyGenJnlLineFromServHeaderApplyTo(ServiceHeader,Rec);
    END;

    [External]
    PROCEDURE CopyFromServiceHeaderPayment@96(ServiceHeader@1001 : Record 5900);
    BEGIN
      "Due Date" := ServiceHeader."Due Date";
      "Payment Terms Code" := ServiceHeader."Payment Terms Code";
      "Payment Method Code" := ServiceHeader."Payment Method Code";
      "Pmt. Discount Date" := ServiceHeader."Pmt. Discount Date";
      "Payment Discount %" := ServiceHeader."Payment Discount %";

      OnAfterCopyGenJnlLineFromServHeaderPayment(ServiceHeader,Rec);
    END;

    [External]
    PROCEDURE CopyFromPaymentCustLedgEntry@205(CustLedgEntry@1000 : Record 21);
    BEGIN
      "Document No." := CustLedgEntry."Document No.";
      "Account Type" := "Account Type"::Customer;
      "Account No." := CustLedgEntry."Customer No.";
      "Shortcut Dimension 1 Code" := CustLedgEntry."Global Dimension 1 Code";
      "Shortcut Dimension 2 Code" := CustLedgEntry."Global Dimension 2 Code";
      "Dimension Set ID" := CustLedgEntry."Dimension Set ID";
      "Posting Group" := CustLedgEntry."Customer Posting Group";
      "Source Type" := "Source Type"::Customer;
      "Source No." := CustLedgEntry."Customer No.";
      "Source Currency Code" := CustLedgEntry."Currency Code";
      "System-Created Entry" := TRUE;
      "Financial Void" := TRUE;
      Correction := TRUE;
    END;

    [External]
    PROCEDURE CopyFromPaymentVendLedgEntry@202(VendLedgEntry@1000 : Record 25);
    BEGIN
      "Document No." := VendLedgEntry."Document No.";
      "Account Type" := "Account Type"::Vendor;
      "Account No." := VendLedgEntry."Vendor No.";
      "Shortcut Dimension 1 Code" := VendLedgEntry."Global Dimension 1 Code";
      "Shortcut Dimension 2 Code" := VendLedgEntry."Global Dimension 2 Code";
      "Dimension Set ID" := VendLedgEntry."Dimension Set ID";
      "Posting Group" := VendLedgEntry."Vendor Posting Group";
      "Source Type" := "Source Type"::Vendor;
      "Source No." := VendLedgEntry."Vendor No.";
      "Source Currency Code" := VendLedgEntry."Currency Code";
      "System-Created Entry" := TRUE;
      "Financial Void" := TRUE;
      Correction := TRUE;
    END;

    LOCAL PROCEDURE SetAmountWithCustLedgEntry@102();
    BEGIN
      IF "Currency Code" <> CustLedgEntry."Currency Code" THEN
        CheckModifyCurrencyCode(GenJnlLine."Account Type"::Customer,CustLedgEntry."Currency Code");
      IF Amount = 0 THEN BEGIN
        CustLedgEntry.CALCFIELDS("Remaining Amount");
        SetAmountWithRemaining(
          PaymentToleranceMgt.CheckCalcPmtDiscGenJnlCust(Rec,CustLedgEntry,0,FALSE),
          CustLedgEntry."Amount to Apply",CustLedgEntry."Remaining Amount",CustLedgEntry."Remaining Pmt. Disc. Possible");
      END;
    END;

    LOCAL PROCEDURE SetAmountWithVendLedgEntry@91();
    BEGIN
      IF "Currency Code" <> VendLedgEntry."Currency Code" THEN
        CheckModifyCurrencyCode("Account Type"::Vendor,VendLedgEntry."Currency Code");
      IF Amount = 0 THEN BEGIN
        VendLedgEntry.CALCFIELDS("Remaining Amount");
        SetAmountWithRemaining(
          PaymentToleranceMgt.CheckCalcPmtDiscGenJnlVend(Rec,VendLedgEntry,0,FALSE),
          VendLedgEntry."Amount to Apply",VendLedgEntry."Remaining Amount",VendLedgEntry."Remaining Pmt. Disc. Possible");
      END;
    END;

    LOCAL PROCEDURE SetAmountWithEmplLedgEntry@176();
    BEGIN
      IF Amount = 0 THEN BEGIN
        EmplLedgEntry.CALCFIELDS("Remaining Amount");
        SetAmountWithRemaining(FALSE,EmplLedgEntry."Amount to Apply",EmplLedgEntry."Remaining Amount",0.0);
      END;
    END;

    [External]
    PROCEDURE CheckModifyCurrencyCode@105(AccountType@1000 : Option;CustVendLedgEntryCurrencyCode@1001 : Code[10]);
    BEGIN
      IF Amount = 0 THEN
        UpdateCurrencyCode(CustVendLedgEntryCurrencyCode)
      ELSE
        GenJnlApply.CheckAgainstApplnCurrency(
          "Currency Code",CustVendLedgEntryCurrencyCode,AccountType,TRUE);
    END;

    LOCAL PROCEDURE SetAmountWithRemaining@101(CalcPmtDisc@1000 : Boolean;AmountToApply@1001 : Decimal;RemainingAmount@1002 : Decimal;RemainingPmtDiscPossible@1003 : Decimal);
    BEGIN
      IF AmountToApply <> 0 THEN
        IF CalcPmtDisc AND (ABS(AmountToApply) >= ABS(RemainingAmount - RemainingPmtDiscPossible)) THEN
          Amount := -(RemainingAmount - RemainingPmtDiscPossible)
        ELSE
          Amount := -AmountToApply
      ELSE
        IF CalcPmtDisc THEN
          Amount := -(RemainingAmount - RemainingPmtDiscPossible)
        ELSE
          Amount := -RemainingAmount;
      IF "Bal. Account Type" IN ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor] THEN
        Amount := -Amount;
      VALIDATE(Amount);
    END;

    [External]
    PROCEDURE IsOpenedFromBatch@87() : Boolean;
    VAR
      GenJournalBatch@1002 : Record 232;
      TemplateFilter@1001 : Text;
      BatchFilter@1000 : Text;
    BEGIN
      BatchFilter := GETFILTER("Journal Batch Name");
      IF BatchFilter <> '' THEN BEGIN
        TemplateFilter := GETFILTER("Journal Template Name");
        IF TemplateFilter <> '' THEN
          GenJournalBatch.SETFILTER("Journal Template Name",TemplateFilter);
        GenJournalBatch.SETFILTER(Name,BatchFilter);
        GenJournalBatch.FINDFIRST;
      END;

      EXIT((("Journal Batch Name" <> '') AND ("Journal Template Name" = '')) OR (BatchFilter <> ''));
    END;

    [External]
    PROCEDURE GetDeferralAmount@88() DeferralAmount : Decimal;
    BEGIN
      IF "VAT Base Amount" <> 0 THEN
        DeferralAmount := "VAT Base Amount"
      ELSE
        DeferralAmount := Amount;
    END;

    [Internal]
    PROCEDURE ShowDeferrals@108(PostingDate@1000 : Date;CurrencyCode@1001 : Code[10]) : Boolean;
    VAR
      DeferralUtilities@1002 : Codeunit 1720;
    BEGIN
      EXIT(
        DeferralUtilities.OpenLineScheduleEdit(
          "Deferral Code",GetDeferralDocType,"Journal Template Name","Journal Batch Name",0,'',"Line No.",
          GetDeferralAmount,PostingDate,Description,CurrencyCode));
    END;

    [External]
    PROCEDURE GetDeferralDocType@106() : Integer;
    BEGIN
      EXIT(DeferralDocType::"G/L");
    END;

    [External]
    PROCEDURE IsForPurchase@86() : Boolean;
    BEGIN
      IF ("Account Type" = "Account Type"::Vendor) OR ("Bal. Account Type" = "Bal. Account Type"::Vendor) THEN
        EXIT(TRUE);

      EXIT(FALSE);
    END;

    [External]
    PROCEDURE IsForSales@89() : Boolean;
    BEGIN
      IF ("Account Type" = "Account Type"::Customer) OR ("Bal. Account Type" = "Bal. Account Type"::Customer) THEN
        EXIT(TRUE);

      EXIT(FALSE);
    END;

    [Integration(TRUE)]
    [External]
    PROCEDURE OnCheckGenJournalLinePostRestrictions@90();
    BEGIN
    END;

    [Integration(TRUE)]
    [External]
    PROCEDURE OnCheckGenJournalLinePrintCheckRestrictions@92();
    BEGIN
    END;

    [Integration(TRUE)]
    [External]
    PROCEDURE OnMoveGenJournalLine@93(ToRecordID@1000 : RecordID);
    BEGIN
    END;

    LOCAL PROCEDURE IncrementDocumentNo@120();
    VAR
      NoSeriesLine@1001 : Record 309;
    BEGIN
      IF GenJnlBatch."No. Series" <> '' THEN BEGIN
        NoSeriesMgt.SetNoSeriesLineFilter(NoSeriesLine,GenJnlBatch."No. Series","Posting Date");
        IF NoSeriesLine."Increment-by No." > 1 THEN
          NoSeriesMgt.IncrementNoText("Document No.",NoSeriesLine."Increment-by No.")
        ELSE
          "Document No." := INCSTR("Document No.");
      END ELSE
        "Document No." := INCSTR("Document No.");
    END;

    [External]
    PROCEDURE NeedCheckZeroAmount@196() : Boolean;
    BEGIN
      EXIT(
        ("Account No." <> '') AND
        NOT "System-Created Entry" AND
        NOT "Allow Zero-Amount Posting" AND
        ("Account Type" <> "Account Type"::"Fixed Asset"));
    END;

    [External]
    PROCEDURE IsRecurring@199() : Boolean;
    VAR
      GenJournalTemplate@1000 : Record 80;
    BEGIN
      IF "Journal Template Name" <> '' THEN
        IF GenJournalTemplate.GET("Journal Template Name") THEN
          EXIT(GenJournalTemplate.Recurring);

      EXIT(FALSE);
    END;

    LOCAL PROCEDURE SuggestBalancingAmount@46(LastGenJnlLine@1001 : Record 81;BottomLine@1003 : Boolean);
    VAR
      GenJournalLine@1000 : Record 81;
    BEGIN
      IF "Document No." = '' THEN
        EXIT;
      IF GETFILTERS <> '' THEN
        EXIT;

      GenJournalLine.SETRANGE("Journal Template Name",LastGenJnlLine."Journal Template Name");
      GenJournalLine.SETRANGE("Journal Batch Name",LastGenJnlLine."Journal Batch Name");
      IF BottomLine THEN
        GenJournalLine.SETFILTER("Line No.",'<=%1',LastGenJnlLine."Line No.")
      ELSE
        GenJournalLine.SETFILTER("Line No.",'<%1',LastGenJnlLine."Line No.");

      IF GenJournalLine.FINDLAST THEN BEGIN
        IF BottomLine THEN BEGIN
          GenJournalLine.SETRANGE("Document No.",LastGenJnlLine."Document No.");
          GenJournalLine.SETRANGE("Posting Date",LastGenJnlLine."Posting Date");
        END ELSE BEGIN
          GenJournalLine.SETRANGE("Document No.",GenJournalLine."Document No.");
          GenJournalLine.SETRANGE("Posting Date",GenJournalLine."Posting Date");
        END;
        GenJournalLine.SETRANGE("Bal. Account No.",'');
        IF GenJournalLine.FINDFIRST THEN BEGIN
          GenJournalLine.CALCSUMS(Amount);
          "Document No." := GenJournalLine."Document No.";
          "Posting Date" := GenJournalLine."Posting Date";
          VALIDATE(Amount,-GenJournalLine.Amount);
        END;
      END;
    END;

    LOCAL PROCEDURE GetGLAccount@146();
    VAR
      GLAcc@1000 : Record 15;
    BEGIN
      GLAcc.GET("Account No.");
      CheckGLAcc(GLAcc);
      IF ReplaceDescription AND (NOT GLAcc."Omit Default Descr. in Jnl.") THEN
        UpdateDescription(GLAcc.Name)
      ELSE
        IF GLAcc."Omit Default Descr. in Jnl." THEN
          Description := '';
      IF ("Bal. Account No." = '') OR
         ("Bal. Account Type" IN
          ["Bal. Account Type"::"G/L Account","Bal. Account Type"::"Bank Account"])
      THEN BEGIN
        "Posting Group" := '';
        "Salespers./Purch. Code" := '';
        "Payment Terms Code" := '';
      END;
      IF "Bal. Account No." = '' THEN
        "Currency Code" := '';
      IF "Copy VAT Setup to Jnl. Lines" THEN BEGIN
        "Gen. Posting Type" := GLAcc."Gen. Posting Type";
        "Gen. Bus. Posting Group" := GLAcc."Gen. Bus. Posting Group";
        "Gen. Prod. Posting Group" := GLAcc."Gen. Prod. Posting Group";
        "VAT Bus. Posting Group" := GLAcc."VAT Bus. Posting Group";
        "VAT Prod. Posting Group" := GLAcc."VAT Prod. Posting Group";
      END;
      "Tax Area Code" := GLAcc."Tax Area Code";
      "Tax Liable" := GLAcc."Tax Liable";
      "Tax Group Code" := GLAcc."Tax Group Code";
      IF "Posting Date" <> 0D THEN
        IF "Posting Date" = CLOSINGDATE("Posting Date") THEN
          ClearPostingGroups;
      VALIDATE("Deferral Code",GLAcc."Default Deferral Template Code");

      OnAfterAccountNoOnValidateGetGLAccount(Rec,GLAcc);
    END;

    LOCAL PROCEDURE GetGLBalAccount@121();
    VAR
      GLAcc@1000 : Record 15;
    BEGIN
      GLAcc.GET("Bal. Account No.");
      CheckGLAcc(GLAcc);
      IF "Account No." = '' THEN BEGIN
        Description := GLAcc.Name;
        "Currency Code" := '';
      END;
      IF ("Account No." = '') OR
         ("Account Type" IN
          ["Account Type"::"G/L Account","Account Type"::"Bank Account"])
      THEN BEGIN
        "Posting Group" := '';
        "Salespers./Purch. Code" := '';
        "Payment Terms Code" := '';
      END;
      IF "Copy VAT Setup to Jnl. Lines" THEN BEGIN
        "Bal. Gen. Posting Type" := GLAcc."Gen. Posting Type";
        "Bal. Gen. Bus. Posting Group" := GLAcc."Gen. Bus. Posting Group";
        "Bal. Gen. Prod. Posting Group" := GLAcc."Gen. Prod. Posting Group";
        "Bal. VAT Bus. Posting Group" := GLAcc."VAT Bus. Posting Group";
        "Bal. VAT Prod. Posting Group" := GLAcc."VAT Prod. Posting Group";
      END;
      "Bal. Tax Area Code" := GLAcc."Tax Area Code";
      "Bal. Tax Liable" := GLAcc."Tax Liable";
      "Bal. Tax Group Code" := GLAcc."Tax Group Code";
      IF "Posting Date" <> 0D THEN
        IF "Posting Date" = CLOSINGDATE("Posting Date") THEN
          ClearBalancePostingGroups;

      OnAfterAccountNoOnValidateGetGLBalAccount(Rec,GLAcc);
    END;

    LOCAL PROCEDURE GetCustomerAccount@47();
    VAR
      Cust@1000 : Record 18;
    BEGIN
      Cust.GET("Account No.");
      Cust.CheckBlockedCustOnJnls(Cust,"Document Type",FALSE);
      CheckICPartner(Cust."IC Partner Code","Account Type","Account No.");
      UpdateDescription(Cust.Name);
      "Payment Method Code" := Cust."Payment Method Code";
      VALIDATE("Recipient Bank Account",Cust."Preferred Bank Account Code");
      "Posting Group" := Cust."Customer Posting Group";
      "Salespers./Purch. Code" := Cust."Salesperson Code";
      "Payment Terms Code" := Cust."Payment Terms Code";
      VALIDATE("Bill-to/Pay-to No.","Account No.");
      VALIDATE("Sell-to/Buy-from No.","Account No.");
      IF NOT SetCurrencyCode("Bal. Account Type","Bal. Account No.") THEN
        "Currency Code" := Cust."Currency Code";
      ClearPostingGroups;
      IF (Cust."Bill-to Customer No." <> '') AND (Cust."Bill-to Customer No." <> "Account No.") AND
         NOT HideValidationDialog
      THEN
        IF NOT CONFIRM(Text014,FALSE,Cust.TABLECAPTION,Cust."No.",Cust.FIELDCAPTION("Bill-to Customer No."),
             Cust."Bill-to Customer No.")
        THEN
          ERROR('');
      VALIDATE("Payment Terms Code");
      CheckPaymentTolerance;

      OnAfterAccountNoOnValidateGetCustomerAccount(Rec,Cust);
    END;

    LOCAL PROCEDURE GetCustomerBalAccount@122();
    VAR
      Cust@1000 : Record 18;
    BEGIN
      Cust.GET("Bal. Account No.");
      Cust.CheckBlockedCustOnJnls(Cust,"Document Type",FALSE);
      CheckICPartner(Cust."IC Partner Code","Bal. Account Type","Bal. Account No.");
      IF "Account No." = '' THEN
        Description := Cust.Name;
      "Payment Method Code" := Cust."Payment Method Code";
      VALIDATE("Recipient Bank Account",Cust."Preferred Bank Account Code");
      "Posting Group" := Cust."Customer Posting Group";
      "Salespers./Purch. Code" := Cust."Salesperson Code";
      "Payment Terms Code" := Cust."Payment Terms Code";
      VALIDATE("Bill-to/Pay-to No.","Bal. Account No.");
      VALIDATE("Sell-to/Buy-from No.","Bal. Account No.");
      IF ("Account No." = '') OR ("Account Type" = "Account Type"::"G/L Account") THEN
        "Currency Code" := Cust."Currency Code";
      IF ("Account Type" = "Account Type"::"Bank Account") AND ("Currency Code" = '') THEN
        "Currency Code" := Cust."Currency Code";
      ClearBalancePostingGroups;
      IF (Cust."Bill-to Customer No." <> '') AND (Cust."Bill-to Customer No." <> "Bal. Account No.") THEN
        IF NOT CONFIRM(Text014,FALSE,Cust.TABLECAPTION,Cust."No.",Cust.FIELDCAPTION("Bill-to Customer No."),
             Cust."Bill-to Customer No.")
        THEN
          ERROR('');
      VALIDATE("Payment Terms Code");
      CheckPaymentTolerance;

      OnAfterAccountNoOnValidateGetCustomerBalAccount(Rec,Cust);
    END;

    LOCAL PROCEDURE GetVendorAccount@115();
    VAR
      Vend@1000 : Record 23;
    BEGIN
      Vend.GET("Account No.");
      Vend.CheckBlockedVendOnJnls(Vend,"Document Type",FALSE);
      CheckICPartner(Vend."IC Partner Code","Account Type","Account No.");
      UpdateDescription(Vend.Name);
      "Payment Method Code" := Vend."Payment Method Code";
      "Creditor No." := Vend."Creditor No.";

      OnGenJnlLineGetVendorAccount(Vend);

      VALIDATE("Recipient Bank Account",Vend."Preferred Bank Account Code");
      "Posting Group" := Vend."Vendor Posting Group";
      "Salespers./Purch. Code" := Vend."Purchaser Code";
      "Payment Terms Code" := Vend."Payment Terms Code";
      VALIDATE("Bill-to/Pay-to No.","Account No.");
      VALIDATE("Sell-to/Buy-from No.","Account No.");
      IF NOT SetCurrencyCode("Bal. Account Type","Bal. Account No.") THEN
        "Currency Code" := Vend."Currency Code";
      ClearPostingGroups;
      IF (Vend."Pay-to Vendor No." <> '') AND (Vend."Pay-to Vendor No." <> "Account No.") AND
         NOT HideValidationDialog
      THEN
        IF NOT CONFIRM(Text014,FALSE,Vend.TABLECAPTION,Vend."No.",Vend.FIELDCAPTION("Pay-to Vendor No."),
             Vend."Pay-to Vendor No.")
        THEN
          ERROR('');
      VALIDATE("Payment Terms Code");
      CheckPaymentTolerance;

      OnAfterAccountNoOnValidateGetVendorAccount(Rec,Vend);
    END;

    LOCAL PROCEDURE GetEmployeeAccount@188();
    VAR
      Employee@1000 : Record 5200;
    BEGIN
      Employee.GET("Account No.");
      UpdateDescriptionWithEmployeeName(Employee);
      "Posting Group" := Employee."Employee Posting Group";
      "Salespers./Purch. Code" := Employee."Salespers./Purch. Code";
      "Currency Code" := '';
      ClearPostingGroups;

      OnAfterAccountNoOnValidateGetEmployeeAccount(Rec,Employee);
    END;

    LOCAL PROCEDURE GetVendorBalAccount@123();
    VAR
      Vend@1000 : Record 23;
    BEGIN
      Vend.GET("Bal. Account No.");
      Vend.CheckBlockedVendOnJnls(Vend,"Document Type",FALSE);
      CheckICPartner(Vend."IC Partner Code","Bal. Account Type","Bal. Account No.");
      IF "Account No." = '' THEN
        Description := Vend.Name;
      "Payment Method Code" := Vend."Payment Method Code";
      VALIDATE("Recipient Bank Account",Vend."Preferred Bank Account Code");
      "Posting Group" := Vend."Vendor Posting Group";
      "Salespers./Purch. Code" := Vend."Purchaser Code";
      "Payment Terms Code" := Vend."Payment Terms Code";
      VALIDATE("Bill-to/Pay-to No.","Bal. Account No.");
      VALIDATE("Sell-to/Buy-from No.","Bal. Account No.");
      IF ("Account No." = '') OR ("Account Type" = "Account Type"::"G/L Account") THEN
        "Currency Code" := Vend."Currency Code";
      IF ("Account Type" = "Account Type"::"Bank Account") AND ("Currency Code" = '') THEN
        "Currency Code" := Vend."Currency Code";
      ClearBalancePostingGroups;
      IF (Vend."Pay-to Vendor No." <> '') AND (Vend."Pay-to Vendor No." <> "Bal. Account No.") AND
         NOT HideValidationDialog
      THEN
        IF NOT CONFIRM(Text014,FALSE,Vend.TABLECAPTION,Vend."No.",Vend.FIELDCAPTION("Pay-to Vendor No."),
             Vend."Pay-to Vendor No.")
        THEN
          ERROR('');
      VALIDATE("Payment Terms Code");
      CheckPaymentTolerance;

      OnAfterAccountNoOnValidateGetVendorBalAccount(Rec,Vend);
    END;

    LOCAL PROCEDURE GetEmployeeBalAccount@177();
    VAR
      Employee@1000 : Record 5200;
    BEGIN
      Employee.GET("Bal. Account No.");
      IF "Account No." = '' THEN
        UpdateDescriptionWithEmployeeName(Employee);
      "Posting Group" := Employee."Employee Posting Group";
      "Salespers./Purch. Code" := Employee."Salespers./Purch. Code";
      "Currency Code" := '';
      ClearBalancePostingGroups;

      OnAfterAccountNoOnValidateGetEmployeeBalAccount(Rec,Employee);
    END;

    LOCAL PROCEDURE GetBankAccount@116();
    VAR
      BankAcc@1000 : Record 270;
    BEGIN
      BankAcc.GET("Account No.");
      BankAcc.TESTFIELD(Blocked,FALSE);
      IF ReplaceDescription THEN
        UpdateDescription(BankAcc.Name);
      IF ("Bal. Account No." = '') OR
         ("Bal. Account Type" IN
          ["Bal. Account Type"::"G/L Account","Bal. Account Type"::"Bank Account"])
      THEN BEGIN
        "Posting Group" := '';
        "Salespers./Purch. Code" := '';
        "Payment Terms Code" := '';
      END;
      IF BankAcc."Currency Code" = '' THEN BEGIN
        IF "Bal. Account No." = '' THEN
          "Currency Code" := '';
      END ELSE
        IF SetCurrencyCode("Bal. Account Type","Bal. Account No.") THEN
          BankAcc.TESTFIELD("Currency Code","Currency Code")
        ELSE
          "Currency Code" := BankAcc."Currency Code";
      ClearPostingGroups;

      OnAfterAccountNoOnValidateGetBankAccount(Rec,BankAcc);
    END;

    LOCAL PROCEDURE GetBankBalAccount@124();
    VAR
      BankAcc@1000 : Record 270;
    BEGIN
      BankAcc.GET("Bal. Account No.");
      BankAcc.TESTFIELD(Blocked,FALSE);
      IF "Account No." = '' THEN
        Description := BankAcc.Name;

      IF ("Account No." = '') OR
         ("Account Type" IN
          ["Account Type"::"G/L Account","Account Type"::"Bank Account"])
      THEN BEGIN
        "Posting Group" := '';
        "Salespers./Purch. Code" := '';
        "Payment Terms Code" := '';
      END;
      IF BankAcc."Currency Code" = '' THEN BEGIN
        IF "Account No." = '' THEN
          "Currency Code" := '';
      END ELSE
        IF SetCurrencyCode("Bal. Account Type","Bal. Account No.") THEN
          BankAcc.TESTFIELD("Currency Code","Currency Code")
        ELSE
          "Currency Code" := BankAcc."Currency Code";
      ClearBalancePostingGroups;

      OnAfterAccountNoOnValidateGetBankBalAccount(Rec,BankAcc);
    END;

    LOCAL PROCEDURE GetFAAccount@117();
    VAR
      FA@1000 : Record 5600;
    BEGIN
      FA.GET("Account No.");
      FA.TESTFIELD(Blocked,FALSE);
      FA.TESTFIELD(Inactive,FALSE);
      FA.TESTFIELD("Budgeted Asset",FALSE);
      UpdateDescription(FA.Description);
      GetFADeprBook("Account No.");
      GetFAVATSetup;
      GetFAAddCurrExchRate;

      OnAfterAccountNoOnValidateGetFAAccount(Rec,FA);
    END;

    LOCAL PROCEDURE GetFABalAccount@125();
    VAR
      FA@1000 : Record 5600;
    BEGIN
      FA.GET("Bal. Account No.");
      FA.TESTFIELD(Blocked,FALSE);
      FA.TESTFIELD(Inactive,FALSE);
      FA.TESTFIELD("Budgeted Asset",FALSE);
      IF "Account No." = '' THEN
        Description := FA.Description;
      GetFADeprBook("Bal. Account No.");
      GetFAVATSetup;
      GetFAAddCurrExchRate;

      OnAfterAccountNoOnValidateGetFABalAccount(Rec,FA);
    END;

    LOCAL PROCEDURE GetICPartnerAccount@118();
    VAR
      ICPartner@1000 : Record 413;
    BEGIN
      ICPartner.GET("Account No.");
      ICPartner.CheckICPartner;
      UpdateDescription(ICPartner.Name);
      IF ("Bal. Account No." = '') OR ("Bal. Account Type" = "Bal. Account Type"::"G/L Account") THEN
        "Currency Code" := ICPartner."Currency Code";
      IF ("Bal. Account Type" = "Bal. Account Type"::"Bank Account") AND ("Currency Code" = '') THEN
        "Currency Code" := ICPartner."Currency Code";
      ClearPostingGroups;
      "IC Partner Code" := "Account No.";

      OnAfterAccountNoOnValidateGetICPartnerAccount(Rec,ICPartner);
    END;

    LOCAL PROCEDURE GetICPartnerBalAccount@126();
    VAR
      ICPartner@1000 : Record 413;
    BEGIN
      ICPartner.GET("Bal. Account No.");
      IF "Account No." = '' THEN
        Description := ICPartner.Name;

      IF ("Account No." = '') OR ("Account Type" = "Account Type"::"G/L Account") THEN
        "Currency Code" := ICPartner."Currency Code";
      IF ("Account Type" = "Account Type"::"Bank Account") AND ("Currency Code" = '') THEN
        "Currency Code" := ICPartner."Currency Code";
      ClearBalancePostingGroups;
      "IC Partner Code" := "Bal. Account No.";

      OnAfterAccountNoOnValidateGetICPartnerBalAccount(Rec,ICPartner);
    END;

    [External]
    PROCEDURE CreateFAAcquisitionLines@131(VAR FAGenJournalLine@1008 : Record 81);
    VAR
      BalancingGenJnlLine@1006 : Record 81;
      LocalGLAcc@1001 : Record 15;
      FAPostingGr@1000 : Record 5606;
    BEGIN
      TESTFIELD("Journal Template Name");
      TESTFIELD("Journal Batch Name");
      TESTFIELD("Posting Date");
      TESTFIELD("Account Type");
      TESTFIELD("Account No.");
      TESTFIELD("Posting Date");

      // Creating Fixed Asset Line
      FAGenJournalLine.INIT;
      FAGenJournalLine.VALIDATE("Journal Template Name","Journal Template Name");
      FAGenJournalLine.VALIDATE("Journal Batch Name","Journal Batch Name");
      FAGenJournalLine.VALIDATE("Line No.",GetNewLineNo("Journal Template Name","Journal Batch Name"));
      FAGenJournalLine.VALIDATE("Document Type","Document Type");
      FAGenJournalLine.VALIDATE("Document No.",GenerateLineDocNo("Journal Batch Name","Posting Date","Journal Template Name"));
      FAGenJournalLine.VALIDATE("Account Type","Account Type");
      FAGenJournalLine.VALIDATE("Account No.","Account No.");
      FAGenJournalLine.VALIDATE(Amount,Amount);
      FAGenJournalLine.VALIDATE("Posting Date","Posting Date");
      FAGenJournalLine.VALIDATE("FA Posting Type","FA Posting Type"::"Acquisition Cost");
      FAGenJournalLine.VALIDATE("External Document No.","External Document No.");
      FAGenJournalLine.INSERT(TRUE);

      // Creating Balancing Line
      BalancingGenJnlLine.COPY(FAGenJournalLine);
      BalancingGenJnlLine.VALIDATE("Account Type","Bal. Account Type");
      BalancingGenJnlLine.VALIDATE("Account No.","Bal. Account No.");
      BalancingGenJnlLine.VALIDATE(Amount,-Amount);
      BalancingGenJnlLine.VALIDATE("Line No.",GetNewLineNo("Journal Template Name","Journal Batch Name"));
      BalancingGenJnlLine.INSERT(TRUE);

      FAGenJournalLine.TESTFIELD("Posting Group");

      // Inserting additional fields in Fixed Asset line required for acquisition
      IF FAPostingGr.GET(FAGenJournalLine."Posting Group") THEN BEGIN
        LocalGLAcc.GET(FAPostingGr."Acquisition Cost Account");
        LocalGLAcc.CheckGLAcc;
        FAGenJournalLine.VALIDATE("Gen. Posting Type",LocalGLAcc."Gen. Posting Type");
        FAGenJournalLine.VALIDATE("Gen. Bus. Posting Group",LocalGLAcc."Gen. Bus. Posting Group");
        FAGenJournalLine.VALIDATE("Gen. Prod. Posting Group",LocalGLAcc."Gen. Prod. Posting Group");
        FAGenJournalLine.VALIDATE("VAT Bus. Posting Group",LocalGLAcc."VAT Bus. Posting Group");
        FAGenJournalLine.VALIDATE("VAT Prod. Posting Group",LocalGLAcc."VAT Prod. Posting Group");
        FAGenJournalLine.VALIDATE("Tax Group Code",LocalGLAcc."Tax Group Code");
        FAGenJournalLine.VALIDATE("VAT Prod. Posting Group");
        FAGenJournalLine.MODIFY(TRUE)
      END;

      // Inserting Source Code
      IF "Source Code" = '' THEN BEGIN
        GenJnlTemplate.GET("Journal Template Name");
        FAGenJournalLine.VALIDATE("Source Code",GenJnlTemplate."Source Code");
        FAGenJournalLine.MODIFY(TRUE);
        BalancingGenJnlLine.VALIDATE("Source Code",GenJnlTemplate."Source Code");
        BalancingGenJnlLine.MODIFY(TRUE);
      END;
    END;

    LOCAL PROCEDURE GenerateLineDocNo@132(BatchName@1004 : Code[10];PostingDate@1002 : Date;TemplateName@1005 : Code[20]) DocumentNo : Code[20];
    VAR
      GenJournalBatch@1000 : Record 232;
      NoSeriesManagement@1003 : Codeunit 396;
    BEGIN
      GenJournalBatch.GET(TemplateName,BatchName);
      IF GenJournalBatch."No. Series" <> '' THEN
        DocumentNo := NoSeriesManagement.TryGetNextNo(GenJournalBatch."No. Series",PostingDate);
    END;

    LOCAL PROCEDURE GetFilterAccountNo@133() : Code[20];
    BEGIN
      IF GETFILTER("Account No.") <> '' THEN
        IF GETRANGEMIN("Account No.") = GETRANGEMAX("Account No.") THEN
          EXIT(GETRANGEMAX("Account No."));
    END;

    [External]
    PROCEDURE SetAccountNoFromFilter@135();
    VAR
      AccountNo@1000 : Code[20];
    BEGIN
      AccountNo := GetFilterAccountNo;
      IF AccountNo = '' THEN BEGIN
        FILTERGROUP(2);
        AccountNo := GetFilterAccountNo;
        FILTERGROUP(0);
      END;
      IF AccountNo <> '' THEN
        "Account No." := AccountNo;
    END;

    [External]
    PROCEDURE GetNewLineNo@136(TemplateName@1000 : Code[10];BatchName@1001 : Code[10]) : Integer;
    VAR
      GenJournalLine@1002 : Record 81;
    BEGIN
      GenJournalLine.VALIDATE("Journal Template Name",TemplateName);
      GenJournalLine.VALIDATE("Journal Batch Name",BatchName);
      GenJournalLine.SETRANGE("Journal Template Name",TemplateName);
      GenJournalLine.SETRANGE("Journal Batch Name",BatchName);
      IF GenJournalLine.FINDLAST THEN
        EXIT(GenJournalLine."Line No." + 10000);
      EXIT(10000);
    END;

    PROCEDURE VoidPaymentFile@139();
    VAR
      TempGenJnlLine@1000 : TEMPORARY Record 81;
      GenJournalLine2@1002 : Record 81;
      VoidTransmitElecPmnts@1001 : Report 9200;
    BEGIN
      TempGenJnlLine.RESET;
      TempGenJnlLine := Rec;
      TempGenJnlLine.SETRANGE("Journal Template Name","Journal Template Name");
      TempGenJnlLine.SETRANGE("Journal Batch Name","Journal Batch Name");
      GenJournalLine2.COPYFILTERS(TempGenJnlLine);
      GenJournalLine2.SETFILTER("Document Type",'Payment|Refund');
      GenJournalLine2.SETFILTER("Bank Payment Type",'Electronic Payment|Electronic Payment-IAT');
      GenJournalLine2.SETRANGE("Exported to Payment File",TRUE);
      GenJournalLine2.SETRANGE("Check Transmitted",FALSE);
      IF NOT GenJournalLine2.FINDFIRST THEN
        ERROR(NoEntriesToVoidErr);

      CLEAR(VoidTransmitElecPmnts);
      VoidTransmitElecPmnts.SetUsageType(1);   // Void
      VoidTransmitElecPmnts.SETTABLEVIEW(TempGenJnlLine);
      IF "Account Type" = "Account Type"::"Bank Account" THEN
        VoidTransmitElecPmnts.SetBankAccountNo("Account No.")
      ELSE
        IF "Bal. Account Type" = "Bal. Account Type"::"Bank Account" THEN
          VoidTransmitElecPmnts.SetBankAccountNo("Bal. Account No.");
      VoidTransmitElecPmnts.RUNMODAL;
    END;

    PROCEDURE TransmitPaymentFile@142();
    VAR
      TempGenJnlLine@1000 : TEMPORARY Record 81;
      VoidTransmitElecPmnts@1001 : Report 9200;
    BEGIN
      TempGenJnlLine.RESET;
      TempGenJnlLine := Rec;
      TempGenJnlLine.SETRANGE("Journal Template Name","Journal Template Name");
      TempGenJnlLine.SETRANGE("Journal Batch Name","Journal Batch Name");
      CLEAR(VoidTransmitElecPmnts);
      VoidTransmitElecPmnts.SetUsageType(2);   // Transmit
      VoidTransmitElecPmnts.SETTABLEVIEW(TempGenJnlLine);
      IF "Account Type" = "Account Type"::"Bank Account" THEN
        VoidTransmitElecPmnts.SetBankAccountNo("Account No.")
      ELSE
        IF "Bal. Account Type" = "Bal. Account Type"::"Bank Account" THEN
          VoidTransmitElecPmnts.SetBankAccountNo("Bal. Account No.");
      VoidTransmitElecPmnts.RUNMODAL;
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterSetupNewLine@161(VAR GenJournalLine@1000 : Record 81;GenJournalTemplate@1001 : Record 80;GenJournalBatch@1002 : Record 232;LastGenJournalLine@1003 : Record 81;Balance@1004 : Decimal;BottomLine@1005 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCopyGenJnlLineFromCustLedgEntry@181(CustLedgerEntry@1000 : Record 21;VAR GenJournalLine@1001 : Record 81);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCopyGenJnlLineFromGenJnlAllocation@182(GenJnlAllocation@1000 : Record 221;VAR GenJournalLine@1001 : Record 81);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCopyGenJnlLineFromSalesHeader@160(SalesHeader@1001 : Record 36;VAR GenJournalLine@1000 : Record 81);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCopyGenJnlLineFromSalesHeaderPrepmt@195(SalesHeader@1000 : Record 36;VAR GenJournalLine@1001 : Record 81);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCopyGenJnlLineFromSalesHeaderPrepmtPost@197(SalesHeader@1000 : Record 36;VAR GenJournalLine@1001 : Record 81;UsePmtDisc@1002 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCopyGenJnlLineFromSalesHeaderApplyTo@200(SalesHeader@1000 : Record 36;VAR GenJournalLine@1001 : Record 81);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCopyGenJnlLineFromSalesHeaderPayment@201(SalesHeader@1000 : Record 36;VAR GenJournalLine@1001 : Record 81);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCopyGenJnlLineFromPurchHeader@141(PurchaseHeader@1001 : Record 38;VAR GenJournalLine@1000 : Record 81);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCopyGenJnlLineFromPurchHeaderPrepmt@186(PurchaseHeader@1001 : Record 38;VAR GenJournalLine@1000 : Record 81);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCopyGenJnlLineFromPurchHeaderPrepmtPost@187(PurchaseHeader@1000 : Record 38;VAR GenJournalLine@1001 : Record 81;UsePmtDisc@1002 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCopyGenJnlLineFromPurchHeaderApplyTo@192(PurchaseHeader@1000 : Record 38;VAR GenJournalLine@1001 : Record 81);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCopyGenJnlLineFromPurchHeaderPayment@194(PurchaseHeader@1000 : Record 38;VAR GenJournalLine@1001 : Record 81);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCopyGenJnlLineFromServHeader@163(ServiceHeader@1001 : Record 5900;VAR GenJournalLine@1000 : Record 81);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCopyGenJnlLineFromServHeaderApplyTo@203(ServiceHeader@1001 : Record 5900;VAR GenJournalLine@1000 : Record 81);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCopyGenJnlLineFromServHeaderPayment@204(ServiceHeader@1001 : Record 5900;VAR GenJournalLine@1000 : Record 81);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCopyGenJnlLineFromInvPostBuffer@144(InvoicePostBuffer@1001 : Record 49;VAR GenJournalLine@1000 : Record 81);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCopyGenJnlLineFromInvPostBufferFA@184(InvoicePostBuffer@1000 : Record 49;VAR GenJournalLine@1001 : Record 81);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCopyGenJnlLineFromPrepmtInvBuffer@148(PrepmtInvLineBuffer@1001 : Record 461;VAR GenJournalLine@1000 : Record 81);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterAccountNoOnValidateGetGLAccount@145(VAR GenJournalLine@1000 : Record 81;VAR GLAccount@1001 : Record 15);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterAccountNoOnValidateGetGLBalAccount@147(VAR GenJournalLine@1000 : Record 81;VAR GLAccount@1001 : Record 15);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterAccountNoOnValidateGetCustomerAccount@149(VAR GenJournalLine@1000 : Record 81;VAR Customer@1001 : Record 18);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterAccountNoOnValidateGetCustomerBalAccount@152(VAR GenJournalLine@1000 : Record 81;VAR Customer@1001 : Record 18);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterAccountNoOnValidateGetVendorAccount@150(VAR GenJournalLine@1000 : Record 81;VAR Vendor@1001 : Record 23);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterAccountNoOnValidateGetVendorBalAccount@153(VAR GenJournalLine@1000 : Record 81;VAR Vendor@1001 : Record 23);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterAccountNoOnValidateGetEmployeeAccount@189(VAR GenJournalLine@1000 : Record 81;VAR Employee@1001 : Record 5200);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterAccountNoOnValidateGetEmployeeBalAccount@179(VAR GenJournalLine@1000 : Record 81;VAR Employee@1001 : Record 5200);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterAccountNoOnValidateGetBankAccount@155(VAR GenJournalLine@1000 : Record 81;VAR BankAccount@1001 : Record 270);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterAccountNoOnValidateGetBankBalAccount@154(VAR GenJournalLine@1000 : Record 81;VAR BankAccount@1001 : Record 270);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterAccountNoOnValidateGetFAAccount@157(VAR GenJournalLine@1000 : Record 81;VAR FixedAsset@1001 : Record 5600);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterAccountNoOnValidateGetFABalAccount@156(VAR GenJournalLine@1000 : Record 81;VAR FixedAsset@1001 : Record 5600);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterAccountNoOnValidateGetICPartnerAccount@159(VAR GenJournalLine@1000 : Record 81;VAR ICPartner@1001 : Record 413);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterAccountNoOnValidateGetICPartnerBalAccount@158(VAR GenJournalLine@1000 : Record 81;VAR ICPartner@1001 : Record 413);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCreateTempJobJnlLine@151(VAR JobJournalLine@1003 : Record 210;GenJournalLine@1002 : Record 81;xGenJournalLine@1001 : Record 81;CurrFieldNo@1000 : Integer);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeCreateTempJobJnlLine@162(VAR JobJournalLine@1003 : Record 210;GenJournalLine@1000 : Record 81;xGenJournalLine@1002 : Record 81;CurrFieldNo@1001 : Integer);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterUpdatePricesFromJobJnlLine@166(VAR GenJournalLine@1000 : Record 81;JobJournalLine@1001 : Record 210);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCreateDimTableIDs@164(VAR GenJournalLine@1000 : Record 81;FieldNo@1001 : Integer;TableID@1003 : ARRAY [10] OF Integer;No@1002 : ARRAY [10] OF Code[20]);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterClearPostingGroups@168(VAR GenJournalLine@1000 : Record 81);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterClearBalPostingGroups@169(VAR GenJournalLine@1000 : Record 81);
    BEGIN
    END;

    LOCAL PROCEDURE SetLastModifiedDateTime@1165();
    VAR
      DateFilterCalc@1000 : Codeunit 358;
    BEGIN
      "Last Modified DateTime" := DateFilterCalc.ConvertToUtcDateTime(CURRENTDATETIME);
    END;

    PROCEDURE UpdateAccountID@1166();
    VAR
      GLAccount@1000 : Record 15;
    BEGIN
      IF "Account Type" <> "Account Type"::"G/L Account" THEN
        EXIT;

      IF "Account No." = '' THEN BEGIN
        CLEAR("Account Id");
        EXIT;
      END;

      IF NOT GLAccount.GET("Account No.") THEN
        EXIT;

      "Account Id" := GLAccount.Id;
    END;

    LOCAL PROCEDURE UpdateAccountNo@1164();
    VAR
      GLAccount@1001 : Record 15;
    BEGIN
      IF ISNULLGUID("Account Id") THEN
        EXIT;

      GLAccount.SETRANGE(Id,"Account Id");
      IF NOT GLAccount.FINDFIRST THEN
        EXIT;

      "Account No." := GLAccount."No.";
    END;

    PROCEDURE UpdateCustomerID@175();
    VAR
      Customer@1000 : Record 18;
    BEGIN
      IF "Account Type" <> "Account Type"::Customer THEN
        EXIT;

      IF "Account No." = '' THEN BEGIN
        CLEAR("Customer Id");
        EXIT;
      END;

      IF NOT Customer.GET("Account No.") THEN
        EXIT;

      "Customer Id" := Customer.Id;
    END;

    LOCAL PROCEDURE UpdateCustomerNo@174();
    VAR
      Customer@1001 : Record 18;
    BEGIN
      IF ISNULLGUID("Customer Id") THEN
        EXIT;

      Customer.SETRANGE(Id,"Customer Id");
      IF NOT Customer.FINDFIRST THEN
        EXIT;

      "Account No." := Customer."No.";
    END;

    PROCEDURE UpdateAppliesToInvoiceID@167();
    VAR
      SalesInvoiceHeader@1000 : Record 112;
    BEGIN
      IF "Applies-to Doc. Type" <> "Applies-to Doc. Type"::Invoice THEN
        EXIT;

      IF "Applies-to Doc. No." = '' THEN BEGIN
        CLEAR("Applies-to Invoice Id");
        EXIT;
      END;

      IF NOT SalesInvoiceHeader.GET("Applies-to Doc. No.") THEN
        EXIT;

      "Applies-to Invoice Id" := SalesInvoiceHeader.Id;
    END;

    LOCAL PROCEDURE UpdateAppliesToInvoiceNo@165();
    VAR
      SalesInvoiceHeader@1001 : Record 112;
    BEGIN
      IF ISNULLGUID("Applies-to Invoice Id") THEN
        EXIT;

      SalesInvoiceHeader.SETRANGE(Id,"Applies-to Invoice Id");
      IF NOT SalesInvoiceHeader.FINDFIRST THEN
        EXIT;

      "Applies-to Doc. No." := SalesInvoiceHeader."No.";
    END;

    PROCEDURE UpdateGraphContactId@170();
    VAR
      Customer@1003 : Record 18;
      Contact@1002 : Record 5050;
      GraphIntContact@1001 : Codeunit 5461;
      GraphID@1000 : Text[250];
    BEGIN
      IF ISNULLGUID("Customer Id") THEN
        CLEAR("Contact Graph Id");

      Customer.SETRANGE(Id,"Customer Id");
      IF NOT Customer.FINDFIRST THEN
        CLEAR("Contact Graph Id");

      IF NOT GraphIntContact.FindGraphContactIdFromCustomer(GraphID,Customer,Contact) THEN
        CLEAR("Contact Graph Id");

      "Contact Graph Id" := GraphID;
    END;

    PROCEDURE UpdateJournalBatchID@173();
    VAR
      GenJournalBatch@1000 : Record 232;
    BEGIN
      IF NOT GenJournalBatch.GET("Journal Template Name","Journal Batch Name") THEN
        EXIT;

      "Journal Batch Id" := GenJournalBatch.Id;
    END;

    LOCAL PROCEDURE UpdateJournalBatchName@172();
    VAR
      GenJournalBatch@1001 : Record 232;
    BEGIN
      GenJournalBatch.SETRANGE(Id,"Journal Batch Id");
      IF NOT GenJournalBatch.FINDFIRST THEN
        EXIT;

      "Journal Batch Name" := GenJournalBatch.Name;
    END;

    PROCEDURE UpdatePaymentMethodId@198();
    VAR
      PaymentMethod@1000 : Record 289;
    BEGIN
      IF "Payment Method Code" = '' THEN BEGIN
        CLEAR("Payment Method Id");
        EXIT;
      END;

      IF NOT PaymentMethod.GET("Payment Method Code") THEN
        EXIT;

      "Payment Method Id" := PaymentMethod.Id;
    END;

    LOCAL PROCEDURE UpdatePaymentMethodCode@185();
    VAR
      PaymentMethod@1001 : Record 289;
    BEGIN
      IF ISNULLGUID("Payment Method Id") THEN
        EXIT;

      PaymentMethod.SETRANGE(Id,"Payment Method Id");
      IF NOT PaymentMethod.FINDFIRST THEN
        EXIT;

      "Payment Method Code" := PaymentMethod.Code;
    END;

    LOCAL PROCEDURE UpdateDescriptionWithEmployeeName@178(Employee@1000 : Record 5200);
    BEGIN
      IF STRLEN(Employee.FullName) <= MAXSTRLEN(Description) THEN
        UpdateDescription(COPYSTR(Employee.FullName,1,MAXSTRLEN(Description)))
      ELSE
        UpdateDescription(Employee.Initials);
    END;

    [Integration(TRUE)]
    PROCEDURE OnGenJnlLineGetVendorAccount@1217(Vendor@1213 : Record 23);
    BEGIN
    END;

    BEGIN
    END.
  }
}

