OBJECT Table 93 Vendor Posting Group
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
               CheckGroupUsage;
             END;

    CaptionML=[DAN=Kreditorbogf�ringsgruppe;
               ENU=Vendor Posting Group];
    LookupPageID=Page111;
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code20        ;CaptionML=[DAN=Kode;
                                                              ENU=Code];
                                                   NotBlank=Yes }
    { 2   ;   ;Payables Account    ;Code20        ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                GLAccountCategoryMgt.CheckGLAccount(
                                                                  "Payables Account",FALSE,FALSE,GLAccountCategory."Account Category"::Liabilities,GLAccountCategoryMgt.GetCurrentLiabilities);
                                                              END;

                                                   OnLookup=BEGIN
                                                              GLAccountCategoryMgt.LookupGLAccount(
                                                                "Payables Account",GLAccountCategory."Account Category"::Liabilities,GLAccountCategoryMgt.GetCurrentLiabilities);
                                                            END;

                                                   CaptionML=[DAN=Samlekonto;
                                                              ENU=Payables Account] }
    { 7   ;   ;Service Charge Acc. ;Code20        ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                GLAccountCategoryMgt.CheckGLAccount(
                                                                  "Service Charge Acc.",TRUE,TRUE,GLAccountCategory."Account Category"::Liabilities,GLAccountCategoryMgt.GetFeesExpense);
                                                              END;

                                                   OnLookup=BEGIN
                                                              GLAccountCategoryMgt.LookupGLAccount(
                                                                "Service Charge Acc.",GLAccountCategory."Account Category"::Liabilities,GLAccountCategoryMgt.GetFeesExpense);
                                                            END;

                                                   CaptionML=[DAN=Gebyrkonto;
                                                              ENU=Service Charge Acc.] }
    { 8   ;   ;Payment Disc. Debit Acc.;Code20    ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                GLAccountCategoryMgt.CheckGLAccount("Payment Disc. Debit Acc.",FALSE,FALSE,GLAccountCategory."Account Category"::Income,'');
                                                              END;

                                                   OnLookup=BEGIN
                                                              GLAccountCategoryMgt.LookupGLAccount("Payment Disc. Debit Acc.",GLAccountCategory."Account Category"::Income,'');
                                                            END;

                                                   CaptionML=[DAN=Kont.rabatdebetkonto;
                                                              ENU=Payment Disc. Debit Acc.] }
    { 9   ;   ;Invoice Rounding Account;Code20    ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                GLAccountCategoryMgt.CheckGLAccount("Invoice Rounding Account",TRUE,FALSE,GLAccountCategory."Account Category"::Expense,'');
                                                              END;

                                                   OnLookup=BEGIN
                                                              GLAccountCategoryMgt.LookupGLAccount("Invoice Rounding Account",GLAccountCategory."Account Category"::Expense,'');
                                                            END;

                                                   CaptionML=[DAN=Fakturaafrundingskonto;
                                                              ENU=Invoice Rounding Account] }
    { 10  ;   ;Debit Curr. Appln. Rndg. Acc.;Code20;
                                                   TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                GLAccountCategoryMgt.CheckGLAccount("Debit Curr. Appln. Rndg. Acc.",FALSE,FALSE,GLAccountCategory."Account Category"::Income,'');
                                                              END;

                                                   OnLookup=BEGIN
                                                              GLAccountCategoryMgt.LookupGLAccount("Debit Curr. Appln. Rndg. Acc.",GLAccountCategory."Account Category"::Income,'');
                                                            END;

                                                   CaptionML=[DAN=Valutaudlign.afrnd.kto (deb.);
                                                              ENU=Debit Curr. Appln. Rndg. Acc.] }
    { 11  ;   ;Credit Curr. Appln. Rndg. Acc.;Code20;
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
    { 12  ;   ;Debit Rounding Account;Code20      ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                GLAccountCategoryMgt.CheckGLAccount("Debit Rounding Account",FALSE,FALSE,GLAccountCategory."Account Category"::Expense,'');
                                                              END;

                                                   OnLookup=BEGIN
                                                              GLAccountCategoryMgt.LookupGLAccount("Debit Rounding Account",GLAccountCategory."Account Category"::Expense,'');
                                                            END;

                                                   CaptionML=[DAN=Debetafrundingskonto;
                                                              ENU=Debit Rounding Account] }
    { 13  ;   ;Credit Rounding Account;Code20     ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                GLAccountCategoryMgt.CheckGLAccount("Credit Rounding Account",FALSE,FALSE,GLAccountCategory."Account Category"::Expense,'');
                                                              END;

                                                   OnLookup=BEGIN
                                                              GLAccountCategoryMgt.LookupGLAccount("Credit Rounding Account",GLAccountCategory."Account Category"::Expense,'');
                                                            END;

                                                   CaptionML=[DAN=Kreditafrundingskonto;
                                                              ENU=Credit Rounding Account] }
    { 16  ;   ;Payment Disc. Credit Acc.;Code20   ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                GLAccountCategoryMgt.CheckGLAccount("Payment Disc. Credit Acc.",FALSE,FALSE,GLAccountCategory."Account Category"::Income,'');
                                                              END;

                                                   OnLookup=BEGIN
                                                              GLAccountCategoryMgt.LookupGLAccount("Payment Disc. Credit Acc.",GLAccountCategory."Account Category"::Income,'');
                                                            END;

                                                   CaptionML=[DAN=Kont.rabatkreditkonto;
                                                              ENU=Payment Disc. Credit Acc.] }
    { 17  ;   ;Payment Tolerance Debit Acc.;Code20;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                GLAccountCategoryMgt.CheckGLAccount(
                                                                  "Payment Tolerance Debit Acc.",FALSE,FALSE,
                                                                  GLAccountCategory."Account Category"::Income,GLAccountCategoryMgt.GetIncomeInterest);
                                                              END;

                                                   OnLookup=BEGIN
                                                              GLAccountCategoryMgt.LookupGLAccount(
                                                                "Payment Tolerance Debit Acc.",GLAccountCategory."Account Category"::Income,GLAccountCategoryMgt.GetIncomeInterest);
                                                            END;

                                                   CaptionML=[DAN=Bet.tolerance - debetkonto;
                                                              ENU=Payment Tolerance Debit Acc.] }
    { 18  ;   ;Payment Tolerance Credit Acc.;Code20;
                                                   TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                GLAccountCategoryMgt.CheckGLAccount(
                                                                  "Payment Tolerance Debit Acc.",FALSE,FALSE,
                                                                  GLAccountCategory."Account Category"::Income,GLAccountCategoryMgt.GetIncomeInterest);
                                                              END;

                                                   OnLookup=BEGIN
                                                              GLAccountCategoryMgt.LookupGLAccount(
                                                                "Payment Tolerance Credit Acc.",GLAccountCategory."Account Category"::Income,GLAccountCategoryMgt.GetIncomeInterest);
                                                            END;

                                                   CaptionML=[DAN=Bet.tolerance - kreditkonto;
                                                              ENU=Payment Tolerance Credit Acc.] }
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
      GLAccountCategory@1001 : Record 570;
      GLAccountCategoryMgt@1002 : Codeunit 570;
      PostingSetupMgt@1004 : Codeunit 48;
      YouCannotDeleteErr@1003 : TextConst '@@@="%1 = Code";DAN=Du kan ikke slette %1.;ENU=You cannot delete %1.';

    LOCAL PROCEDURE CheckGroupUsage@8();
    VAR
      Vendor@1000 : Record 23;
      VendorLedgerEntry@1001 : Record 25;
    BEGIN
      Vendor.SETRANGE("Vendor Posting Group",Code);
      IF NOT Vendor.ISEMPTY THEN
        ERROR(YouCannotDeleteErr,Code);

      VendorLedgerEntry.SETRANGE("Vendor Posting Group",Code);
      IF NOT VendorLedgerEntry.ISEMPTY THEN
        ERROR(YouCannotDeleteErr,Code);
    END;

    [External]
    PROCEDURE GetPayablesAccount@6() : Code[20];
    BEGIN
      IF "Payables Account" = '' THEN
        PostingSetupMgt.SendVendPostingGroupNotification(Rec,FIELDCAPTION("Payables Account"));
      TESTFIELD("Payables Account");
      EXIT("Payables Account");
    END;

    [External]
    PROCEDURE GetPmtDiscountAccount@1(Debit@1000 : Boolean) : Code[20];
    BEGIN
      IF Debit THEN BEGIN
        IF "Payment Disc. Debit Acc." = '' THEN
          PostingSetupMgt.SendVendPostingGroupNotification(Rec,FIELDCAPTION("Payment Disc. Debit Acc."));
        TESTFIELD("Payment Disc. Debit Acc.");
        EXIT("Payment Disc. Debit Acc.");
      END;
      IF "Payment Disc. Credit Acc." = '' THEN
        PostingSetupMgt.SendVendPostingGroupNotification(Rec,FIELDCAPTION("Payment Disc. Credit Acc."));
      TESTFIELD("Payment Disc. Credit Acc.");
      EXIT("Payment Disc. Credit Acc.");
    END;

    [External]
    PROCEDURE GetPmtToleranceAccount@3(Debit@1000 : Boolean) : Code[20];
    BEGIN
      IF Debit THEN BEGIN
        IF "Payment Tolerance Debit Acc." = '' THEN
          PostingSetupMgt.SendVendPostingGroupNotification(Rec,FIELDCAPTION("Payment Tolerance Debit Acc."));
        TESTFIELD("Payment Tolerance Debit Acc.");
        EXIT("Payment Tolerance Debit Acc.");
      END;
      IF "Payment Tolerance Credit Acc." = '' THEN
        PostingSetupMgt.SendVendPostingGroupNotification(Rec,FIELDCAPTION("Payment Tolerance Credit Acc."));
      TESTFIELD("Payment Tolerance Credit Acc.");
      EXIT("Payment Tolerance Credit Acc.");
    END;

    [External]
    PROCEDURE GetRoundingAccount@4(Debit@1000 : Boolean) : Code[20];
    BEGIN
      IF Debit THEN BEGIN
        IF "Debit Rounding Account" = '' THEN
          PostingSetupMgt.SendVendPostingGroupNotification(Rec,FIELDCAPTION("Debit Rounding Account"));
        TESTFIELD("Debit Rounding Account");
        EXIT("Debit Rounding Account");
      END;
      IF "Credit Rounding Account" = '' THEN
        PostingSetupMgt.SendVendPostingGroupNotification(Rec,FIELDCAPTION("Credit Rounding Account"));
      TESTFIELD("Credit Rounding Account");
      EXIT("Credit Rounding Account");
    END;

    [External]
    PROCEDURE GetApplRoundingAccount@5(Debit@1000 : Boolean) : Code[20];
    BEGIN
      IF Debit THEN BEGIN
        IF "Debit Curr. Appln. Rndg. Acc." = '' THEN
          PostingSetupMgt.SendVendPostingGroupNotification(Rec,FIELDCAPTION("Debit Curr. Appln. Rndg. Acc."));
        TESTFIELD("Debit Curr. Appln. Rndg. Acc.");
        EXIT("Debit Curr. Appln. Rndg. Acc.");
      END;
      IF "Credit Curr. Appln. Rndg. Acc." = '' THEN
        PostingSetupMgt.SendVendPostingGroupNotification(Rec,FIELDCAPTION("Credit Curr. Appln. Rndg. Acc."));
      TESTFIELD("Credit Curr. Appln. Rndg. Acc.");
      EXIT("Credit Curr. Appln. Rndg. Acc.");
    END;

    [External]
    PROCEDURE GetInvRoundingAccount@9() : Code[20];
    BEGIN
      IF "Invoice Rounding Account" = '' THEN
        PostingSetupMgt.SendVendPostingGroupNotification(Rec,FIELDCAPTION("Invoice Rounding Account"));
      TESTFIELD("Invoice Rounding Account");
      EXIT("Invoice Rounding Account");
    END;

    [External]
    PROCEDURE GetServiceChargeAccount@7() : Code[20];
    BEGIN
      IF "Service Charge Acc." = '' THEN
        PostingSetupMgt.SendVendPostingGroupNotification(Rec,FIELDCAPTION("Service Charge Acc."));
      TESTFIELD("Service Charge Acc.");
      EXIT("Service Charge Acc.");
    END;

    PROCEDURE SetAccountVisibility@10(VAR PmtToleranceVisible@1000 : Boolean;VAR PmtDiscountVisible@1002 : Boolean;VAR InvRoundingVisible@1001 : Boolean;VAR ApplnRoundingVisible@1005 : Boolean);
    VAR
      PurchSetup@1003 : Record 312;
      PaymentTerms@1004 : Record 3;
    BEGIN
      GLSetup.GET;
      PmtToleranceVisible := GLSetup."Payment Tolerance %" > 0;
      PmtDiscountVisible := PaymentTerms.UsePaymentDiscount;

      PurchSetup.GET;
      InvRoundingVisible := PurchSetup."Invoice Rounding";
      ApplnRoundingVisible := PurchSetup."Appln. between Currencies" <> PurchSetup."Appln. between Currencies"::None;
    END;

    BEGIN
    END.
  }
}

