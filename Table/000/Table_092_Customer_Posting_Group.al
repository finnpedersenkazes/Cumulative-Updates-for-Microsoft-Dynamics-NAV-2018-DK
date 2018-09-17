OBJECT Table 92 Customer Posting Group
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    OnDelete=BEGIN
               CheckCustEntries;
             END;

    CaptionML=[DAN=Debitorbogf�ringsgruppe;
               ENU=Customer Posting Group];
    LookupPageID=Page110;
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code20        ;CaptionML=[DAN=Kode;
                                                              ENU=Code];
                                                   NotBlank=Yes }
    { 2   ;   ;Receivables Account ;Code20        ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                GLAccountCategoryMgt.CheckGLAccount(
                                                                  "Receivables Account",FALSE,FALSE,GLAccountCategory."Account Category"::Assets,GLAccountCategoryMgt.GetAR);
                                                              END;

                                                   OnLookup=BEGIN
                                                              GLAccountCategoryMgt.LookupGLAccount(
                                                                "Receivables Account",GLAccountCategory."Account Category"::Assets,GLAccountCategoryMgt.GetAR);
                                                            END;

                                                   CaptionML=[DAN=Samlekonto;
                                                              ENU=Receivables Account] }
    { 7   ;   ;Service Charge Acc. ;Code20        ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                GLAccountCategoryMgt.CheckGLAccount(
                                                                  "Service Charge Acc.",TRUE,TRUE,GLAccountCategory."Account Category"::Income,GLAccountCategoryMgt.GetIncomeService);
                                                              END;

                                                   OnLookup=BEGIN
                                                              GLAccountCategoryMgt.LookupGLAccount(
                                                                "Service Charge Acc.",GLAccountCategory."Account Category"::Income,GLAccountCategoryMgt.GetIncomeService);
                                                            END;

                                                   CaptionML=[DAN=Gebyrkonto;
                                                              ENU=Service Charge Acc.] }
    { 8   ;   ;Payment Disc. Debit Acc.;Code20    ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                GLAccountCategoryMgt.CheckGLAccount("Payment Disc. Debit Acc.",FALSE,FALSE,GLAccountCategory."Account Category"::Expense,'');
                                                              END;

                                                   OnLookup=BEGIN
                                                              GLAccountCategoryMgt.LookupGLAccount("Payment Disc. Debit Acc.",GLAccountCategory."Account Category"::Expense,'');
                                                            END;

                                                   CaptionML=[DAN=Kont.rabatdebetkonto;
                                                              ENU=Payment Disc. Debit Acc.] }
    { 9   ;   ;Invoice Rounding Account;Code20    ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                GLAccountCategoryMgt.CheckGLAccount("Invoice Rounding Account",TRUE,FALSE,GLAccountCategory."Account Category"::Income,'');
                                                              END;

                                                   OnLookup=BEGIN
                                                              GLAccountCategoryMgt.LookupGLAccount("Invoice Rounding Account",GLAccountCategory."Account Category"::Income,'');
                                                            END;

                                                   CaptionML=[DAN=Fakturaafrundingskonto;
                                                              ENU=Invoice Rounding Account] }
    { 10  ;   ;Additional Fee Account;Code20      ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                GLAccountCategoryMgt.CheckGLAccount("Additional Fee Account",TRUE,TRUE,GLAccountCategory."Account Category"::Income,'');
                                                              END;

                                                   OnLookup=BEGIN
                                                              GLAccountCategoryMgt.LookupGLAccount("Additional Fee Account",GLAccountCategory."Account Category"::Income,'');
                                                            END;

                                                   CaptionML=[DAN=Opkr�vningsgebyrkonto;
                                                              ENU=Additional Fee Account] }
    { 11  ;   ;Interest Account    ;Code20        ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                GLAccountCategoryMgt.CheckGLAccount("Interest Account",TRUE,FALSE,GLAccountCategory."Account Category"::Income,'');
                                                              END;

                                                   OnLookup=BEGIN
                                                              GLAccountCategoryMgt.LookupGLAccount("Interest Account",GLAccountCategory."Account Category"::Income,'');
                                                            END;

                                                   CaptionML=[DAN=Rentekonto;
                                                              ENU=Interest Account] }
    { 12  ;   ;Debit Curr. Appln. Rndg. Acc.;Code20;
                                                   TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                GLAccountCategoryMgt.CheckGLAccount(
                                                                  "Debit Curr. Appln. Rndg. Acc.",FALSE,FALSE,GLAccountCategory."Account Category"::Income,'');
                                                              END;

                                                   OnLookup=BEGIN
                                                              GLAccountCategoryMgt.LookupGLAccount("Debit Curr. Appln. Rndg. Acc.",GLAccountCategory."Account Category"::Income,'');
                                                            END;

                                                   CaptionML=[DAN=Valutaudlign.afrnd.kto (deb.);
                                                              ENU=Debit Curr. Appln. Rndg. Acc.] }
    { 13  ;   ;Credit Curr. Appln. Rndg. Acc.;Code20;
                                                   TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                GLAccountCategoryMgt.CheckGLAccount(
                                                                  "Credit Curr. Appln. Rndg. Acc.",FALSE,FALSE,GLAccountCategory."Account Category"::Income,'');
                                                              END;

                                                   OnLookup=BEGIN
                                                              GLAccountCategoryMgt.LookupGLAccount("Credit Curr. Appln. Rndg. Acc.",GLAccountCategory."Account Category"::Income,'');
                                                            END;

                                                   CaptionML=[DAN=Valutaudlign.afrnd.kto (kre.);
                                                              ENU=Credit Curr. Appln. Rndg. Acc.] }
    { 14  ;   ;Debit Rounding Account;Code20      ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                GLAccountCategoryMgt.CheckGLAccount(
                                                                  "Debit Rounding Account",FALSE,FALSE,GLAccountCategory."Account Category"::Income,'');
                                                              END;

                                                   OnLookup=BEGIN
                                                              GLAccountCategoryMgt.LookupGLAccount("Debit Rounding Account",GLAccountCategory."Account Category"::Income,'');
                                                            END;

                                                   CaptionML=[DAN=Debetafrundingskonto;
                                                              ENU=Debit Rounding Account] }
    { 15  ;   ;Credit Rounding Account;Code20     ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                GLAccountCategoryMgt.CheckGLAccount(
                                                                  "Credit Rounding Account",FALSE,FALSE,GLAccountCategory."Account Category"::Income,'');
                                                              END;

                                                   OnLookup=BEGIN
                                                              GLAccountCategoryMgt.LookupGLAccount("Credit Rounding Account",GLAccountCategory."Account Category"::Income,'');
                                                            END;

                                                   CaptionML=[DAN=Kreditafrundingskonto;
                                                              ENU=Credit Rounding Account] }
    { 16  ;   ;Payment Disc. Credit Acc.;Code20   ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                GLAccountCategoryMgt.CheckGLAccount("Payment Disc. Credit Acc.",FALSE,FALSE,GLAccountCategory."Account Category"::Expense,'');
                                                              END;

                                                   OnLookup=BEGIN
                                                              GLAccountCategoryMgt.LookupGLAccount("Payment Disc. Credit Acc.",GLAccountCategory."Account Category"::Expense,'');
                                                            END;

                                                   CaptionML=[DAN=Kont.rabatkreditkonto;
                                                              ENU=Payment Disc. Credit Acc.] }
    { 17  ;   ;Payment Tolerance Debit Acc.;Code20;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                GLAccountCategoryMgt.CheckGLAccount(
                                                                  "Payment Tolerance Debit Acc.",FALSE,FALSE,GLAccountCategory."Account Category"::Expense,'');
                                                              END;

                                                   OnLookup=BEGIN
                                                              GLAccountCategoryMgt.LookupGLAccount("Payment Tolerance Debit Acc.",GLAccountCategory."Account Category"::Expense,'');
                                                            END;

                                                   CaptionML=[DAN=Bet.tolerance - debetkonto;
                                                              ENU=Payment Tolerance Debit Acc.] }
    { 18  ;   ;Payment Tolerance Credit Acc.;Code20;
                                                   TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                GLAccountCategoryMgt.CheckGLAccount(
                                                                  "Payment Tolerance Debit Acc.",FALSE,FALSE,
                                                                  GLAccountCategory."Account Category"::Expense,GLAccountCategoryMgt.GetInterestExpense);
                                                              END;

                                                   OnLookup=BEGIN
                                                              GLAccountCategoryMgt.LookupGLAccount(
                                                                "Payment Tolerance Debit Acc.",GLAccountCategory."Account Category"::Expense,GLAccountCategoryMgt.GetInterestExpense);
                                                            END;

                                                   CaptionML=[DAN=Bet.tolerance - kreditkonto;
                                                              ENU=Payment Tolerance Credit Acc.] }
    { 19  ;   ;Add. Fee per Line Account;Code20   ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                GLAccountCategoryMgt.CheckGLAccount("Add. Fee per Line Account",TRUE,FALSE,GLAccountCategory."Account Category"::Income,'');
                                                              END;

                                                   OnLookup=BEGIN
                                                              GLAccountCategoryMgt.LookupGLAccount("Add. Fee per Line Account",GLAccountCategory."Account Category"::Income,'');
                                                            END;

                                                   CaptionML=[DAN=Konto for opkr�vningsgebyr pr. linje;
                                                              ENU=Add. Fee per Line Account] }
    { 20  ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
  }
  KEYS
  {
    {    ;Code                                    ;Clustered=Yes }
  }
  FIELDGROUPS
  {
    { 1   ;Brick               ;Code                                     }
  }
  CODE
  {
    VAR
      GLSetup@1000 : Record 98;
      GLAccountCategory@1002 : Record 570;
      GLAccountCategoryMgt@1001 : Codeunit 570;
      PostingSetupMgt@1005 : Codeunit 48;
      YouCannotDeleteErr@1004 : TextConst '@@@="%1 = Code";DAN=Du kan ikke slette %1.;ENU=You cannot delete %1.';

    LOCAL PROCEDURE CheckCustEntries@13();
    VAR
      Customer@1000 : Record 18;
      CustLedgerEntry@1001 : Record 21;
    BEGIN
      Customer.SETRANGE("Customer Posting Group",Code);
      IF NOT Customer.ISEMPTY THEN
        ERROR(YouCannotDeleteErr,Code);

      CustLedgerEntry.SETRANGE("Customer Posting Group",Code);
      IF NOT CustLedgerEntry.ISEMPTY THEN
        ERROR(YouCannotDeleteErr,Code);
    END;

    [External]
    PROCEDURE GetReceivablesAccount@6() : Code[20];
    BEGIN
      IF "Receivables Account" = '' THEN
        PostingSetupMgt.SendCustPostingGroupNotification(Rec,FIELDCAPTION("Receivables Account"));
      TESTFIELD("Receivables Account");
      EXIT("Receivables Account");
    END;

    [External]
    PROCEDURE GetPmtDiscountAccount@1(Debit@1000 : Boolean) : Code[20];
    BEGIN
      IF Debit THEN BEGIN
        IF "Payment Disc. Debit Acc." = '' THEN
          PostingSetupMgt.SendCustPostingGroupNotification(Rec,FIELDCAPTION("Payment Disc. Debit Acc."));
        TESTFIELD("Payment Disc. Debit Acc.");
        EXIT("Payment Disc. Debit Acc.");
      END;
      IF "Payment Disc. Credit Acc." = '' THEN
        PostingSetupMgt.SendCustPostingGroupNotification(Rec,FIELDCAPTION("Payment Disc. Credit Acc."));
      TESTFIELD("Payment Disc. Credit Acc.");
      EXIT("Payment Disc. Credit Acc.");
    END;

    [External]
    PROCEDURE GetPmtToleranceAccount@3(Debit@1000 : Boolean) : Code[20];
    BEGIN
      IF Debit THEN BEGIN
        IF "Payment Tolerance Debit Acc." = '' THEN
          PostingSetupMgt.SendCustPostingGroupNotification(Rec,FIELDCAPTION("Payment Tolerance Debit Acc."));
        TESTFIELD("Payment Tolerance Debit Acc.");
        EXIT("Payment Tolerance Debit Acc.");
      END;
      IF "Payment Tolerance Credit Acc." = '' THEN
        PostingSetupMgt.SendCustPostingGroupNotification(Rec,FIELDCAPTION("Payment Tolerance Credit Acc."));
      TESTFIELD("Payment Tolerance Credit Acc.");
      EXIT("Payment Tolerance Credit Acc.");
    END;

    [External]
    PROCEDURE GetRoundingAccount@4(Debit@1000 : Boolean) : Code[20];
    BEGIN
      IF Debit THEN BEGIN
        IF "Debit Rounding Account" = '' THEN
          PostingSetupMgt.SendCustPostingGroupNotification(Rec,FIELDCAPTION("Debit Rounding Account"));
        TESTFIELD("Debit Rounding Account");
        EXIT("Debit Rounding Account");
      END;
      IF "Credit Rounding Account" = '' THEN
        PostingSetupMgt.SendCustPostingGroupNotification(Rec,FIELDCAPTION("Credit Rounding Account"));
      TESTFIELD("Credit Rounding Account");
      EXIT("Credit Rounding Account");
    END;

    [External]
    PROCEDURE GetApplRoundingAccount@5(Debit@1000 : Boolean) : Code[20];
    BEGIN
      IF Debit THEN BEGIN
        IF "Debit Curr. Appln. Rndg. Acc." = '' THEN
          PostingSetupMgt.SendCustPostingGroupNotification(Rec,FIELDCAPTION("Debit Curr. Appln. Rndg. Acc."));
        TESTFIELD("Debit Curr. Appln. Rndg. Acc.");
        EXIT("Debit Curr. Appln. Rndg. Acc.");
      END;
      IF "Credit Curr. Appln. Rndg. Acc." = '' THEN
        PostingSetupMgt.SendCustPostingGroupNotification(Rec,FIELDCAPTION("Credit Curr. Appln. Rndg. Acc."));
      TESTFIELD("Credit Curr. Appln. Rndg. Acc.");
      EXIT("Credit Curr. Appln. Rndg. Acc.");
    END;

    [External]
    PROCEDURE GetInvRoundingAccount@9() : Code[20];
    BEGIN
      IF "Invoice Rounding Account" = '' THEN
        PostingSetupMgt.SendCustPostingGroupNotification(Rec,FIELDCAPTION("Invoice Rounding Account"));
      TESTFIELD("Invoice Rounding Account");
      EXIT("Invoice Rounding Account");
    END;

    [External]
    PROCEDURE GetServiceChargeAccount@7() : Code[20];
    BEGIN
      IF "Service Charge Acc." = '' THEN
        PostingSetupMgt.SendCustPostingGroupNotification(Rec,FIELDCAPTION("Service Charge Acc."));
      TESTFIELD("Service Charge Acc.");
      EXIT("Service Charge Acc.");
    END;

    [External]
    PROCEDURE GetAdditionalFeeAccount@8() : Code[20];
    BEGIN
      IF "Additional Fee Account" = '' THEN
        PostingSetupMgt.SendCustPostingGroupNotification(Rec,FIELDCAPTION("Additional Fee Account"));
      TESTFIELD("Additional Fee Account");
      EXIT("Additional Fee Account");
    END;

    [External]
    PROCEDURE GetAddFeePerLineAccount@11() : Code[20];
    BEGIN
      IF "Add. Fee per Line Account" = '' THEN
        PostingSetupMgt.SendCustPostingGroupNotification(Rec,FIELDCAPTION("Add. Fee per Line Account"));
      TESTFIELD("Add. Fee per Line Account");
      EXIT("Add. Fee per Line Account");
    END;

    [External]
    PROCEDURE GetInterestAccount@10() : Code[20];
    BEGIN
      IF "Interest Account" = '' THEN
        PostingSetupMgt.SendCustPostingGroupNotification(Rec,FIELDCAPTION("Interest Account"));
      TESTFIELD("Interest Account");
      EXIT("Interest Account");
    END;

    PROCEDURE SetAccountVisibility@12(VAR PmtToleranceVisible@1000 : Boolean;VAR PmtDiscountVisible@1002 : Boolean;VAR InvRoundingVisible@1001 : Boolean;VAR ApplnRoundingVisible@1005 : Boolean);
    VAR
      SalesSetup@1003 : Record 311;
      PaymentTerms@1004 : Record 3;
    BEGIN
      GLSetup.GET;
      PmtToleranceVisible := GLSetup."Payment Tolerance %" > 0;
      PmtDiscountVisible := PaymentTerms.UsePaymentDiscount;

      SalesSetup.GET;
      InvRoundingVisible := SalesSetup."Invoice Rounding";
      ApplnRoundingVisible := SalesSetup."Appln. between Currencies" <> SalesSetup."Appln. between Currencies"::None;
    END;

    BEGIN
    END.
  }
}

