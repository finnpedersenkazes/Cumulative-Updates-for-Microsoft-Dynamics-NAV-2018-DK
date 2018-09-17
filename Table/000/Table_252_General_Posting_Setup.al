OBJECT Table 252 General Posting Setup
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    OnDelete=BEGIN
               CheckSetupUsage;
             END;

    CaptionML=[DAN=Bogf�ringsops�tning;
               ENU=General Posting Setup];
    LookupPageID=Page314;
    DrillDownPageID=Page314;
  }
  FIELDS
  {
    { 1   ;   ;Gen. Bus. Posting Group;Code20     ;TableRelation="Gen. Business Posting Group";
                                                   CaptionML=[DAN=Virksomhedsbogf�ringsgruppe;
                                                              ENU=Gen. Bus. Posting Group] }
    { 2   ;   ;Gen. Prod. Posting Group;Code20    ;TableRelation="Gen. Product Posting Group";
                                                   CaptionML=[DAN=Produktbogf�ringsgruppe;
                                                              ENU=Gen. Prod. Posting Group];
                                                   NotBlank=Yes }
    { 10  ;   ;Sales Account       ;Code20        ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Sales Account");
                                                              END;

                                                   OnLookup=BEGIN
                                                              GLAccountCategoryMgt.LookupGLAccount(
                                                                "Sales Account",GLAccountCategory."Account Category"::Income,
                                                                STRSUBSTNO('%1|%2',GLAccountCategoryMgt.GetIncomeProdSales,GLAccountCategoryMgt.GetIncomeService));
                                                            END;

                                                   CaptionML=[DAN=Salgskonto;
                                                              ENU=Sales Account] }
    { 11  ;   ;Sales Line Disc. Account;Code20    ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Sales Line Disc. Account");
                                                              END;

                                                   OnLookup=BEGIN
                                                              GLAccountCategoryMgt.LookupGLAccount(
                                                                "Sales Line Disc. Account",GLAccountCategory."Account Category"::Income,
                                                                GLAccountCategoryMgt.GetIncomeSalesDiscounts);
                                                            END;

                                                   CaptionML=[DAN=Salgslinjerabatkonto;
                                                              ENU=Sales Line Disc. Account] }
    { 12  ;   ;Sales Inv. Disc. Account;Code20    ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Sales Inv. Disc. Account");
                                                              END;

                                                   OnLookup=BEGIN
                                                              GLAccountCategoryMgt.LookupGLAccount(
                                                                "Sales Inv. Disc. Account",GLAccountCategory."Account Category"::Income,
                                                                GLAccountCategoryMgt.GetIncomeSalesDiscounts);
                                                            END;

                                                   CaptionML=[DAN=Salgsfakturarabatkonto;
                                                              ENU=Sales Inv. Disc. Account] }
    { 13  ;   ;Sales Pmt. Disc. Debit Acc.;Code20 ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Sales Pmt. Disc. Debit Acc.");
                                                                IF "Sales Pmt. Disc. Debit Acc." <> '' THEN BEGIN
                                                                  GLSetup.GET;
                                                                  GLSetup.TESTFIELD("Adjust for Payment Disc.",TRUE);
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Salgskont.rabatdebetkonto;
                                                              ENU=Sales Pmt. Disc. Debit Acc.] }
    { 14  ;   ;Purch. Account      ;Code20        ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Purch. Account");
                                                              END;

                                                   OnLookup=BEGIN
                                                              GLAccountCategoryMgt.LookupGLAccount(
                                                                "Purch. Account",GLAccountCategory."Account Category"::"Cost of Goods Sold",
                                                                STRSUBSTNO('%1|%2',GLAccountCategoryMgt.GetCOGSMaterials,GLAccountCategoryMgt.GetCOGSLabor));
                                                            END;

                                                   CaptionML=[DAN=K�bskonto;
                                                              ENU=Purch. Account] }
    { 15  ;   ;Purch. Line Disc. Account;Code20   ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Purch. Line Disc. Account");
                                                              END;

                                                   OnLookup=BEGIN
                                                              GLAccountCategoryMgt.LookupGLAccount(
                                                                "Purch. Line Disc. Account",GLAccountCategory."Account Category"::"Cost of Goods Sold",
                                                                GLAccountCategoryMgt.GetCOGSDiscountsGranted);
                                                            END;

                                                   CaptionML=[DAN=K�bslinjerabatkonto;
                                                              ENU=Purch. Line Disc. Account] }
    { 16  ;   ;Purch. Inv. Disc. Account;Code20   ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Purch. Inv. Disc. Account");
                                                              END;

                                                   OnLookup=BEGIN
                                                              GLAccountCategoryMgt.LookupGLAccount(
                                                                "Purch. Inv. Disc. Account",GLAccountCategory."Account Category"::Income,
                                                                GLAccountCategoryMgt.GetCOGSDiscountsGranted);
                                                            END;

                                                   CaptionML=[DAN=K�bsfakturarabatkonto;
                                                              ENU=Purch. Inv. Disc. Account] }
    { 17  ;   ;Purch. Pmt. Disc. Credit Acc.;Code20;
                                                   TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Purch. Pmt. Disc. Credit Acc.");
                                                                IF "Purch. Pmt. Disc. Credit Acc." <> '' THEN BEGIN
                                                                  GLSetup.GET;
                                                                  GLSetup.TESTFIELD("Adjust for Payment Disc.",TRUE);
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=K�bskont.rabatkreditkonto;
                                                              ENU=Purch. Pmt. Disc. Credit Acc.] }
    { 18  ;   ;COGS Account        ;Code20        ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("COGS Account");
                                                              END;

                                                   OnLookup=BEGIN
                                                              GLAccountCategoryMgt.LookupGLAccount(
                                                                "COGS Account",GLAccountCategory."Account Category"::"Cost of Goods Sold",
                                                                STRSUBSTNO('%1|%2',GLAccountCategoryMgt.GetCOGSMaterials,GLAccountCategoryMgt.GetCOGSLabor));
                                                            END;

                                                   CaptionML=[DAN=Vareforbrugskonto;
                                                              ENU=COGS Account] }
    { 19  ;   ;Inventory Adjmt. Account;Code20    ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Inventory Adjmt. Account");
                                                              END;

                                                   CaptionML=[DAN=Lagerreguleringskonto;
                                                              ENU=Inventory Adjmt. Account] }
    { 27  ;   ;Sales Credit Memo Account;Code20   ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Sales Credit Memo Account");
                                                              END;

                                                   CaptionML=[DAN=Salgskreditnotakonto;
                                                              ENU=Sales Credit Memo Account] }
    { 28  ;   ;Purch. Credit Memo Account;Code20  ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Purch. Credit Memo Account");
                                                              END;

                                                   CaptionML=[DAN=K�bskreditnotakonto;
                                                              ENU=Purch. Credit Memo Account] }
    { 30  ;   ;Sales Pmt. Disc. Credit Acc.;Code20;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Sales Pmt. Disc. Credit Acc.");
                                                                IF "Sales Pmt. Disc. Credit Acc." <> '' THEN BEGIN
                                                                  GLSetup.GET;
                                                                  GLSetup.TESTFIELD("Adjust for Payment Disc.",TRUE);
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Salgskont.rabatkreditkonto;
                                                              ENU=Sales Pmt. Disc. Credit Acc.] }
    { 31  ;   ;Purch. Pmt. Disc. Debit Acc.;Code20;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Purch. Pmt. Disc. Debit Acc.");
                                                                IF "Purch. Pmt. Disc. Debit Acc." <> '' THEN BEGIN
                                                                  GLSetup.GET;
                                                                  GLSetup.TESTFIELD("Adjust for Payment Disc.",TRUE);
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=K�bskont.rabatdebetkonto;
                                                              ENU=Purch. Pmt. Disc. Debit Acc.] }
    { 32  ;   ;Sales Pmt. Tol. Debit Acc.;Code20  ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Sales Pmt. Tol. Debit Acc.");
                                                                IF "Purch. Pmt. Disc. Debit Acc." <> '' THEN BEGIN
                                                                  GLSetup.GET;
                                                                  GLSetup.TESTFIELD("Adjust for Payment Disc.",TRUE);
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Salgstolerance - debetkonto;
                                                              ENU=Sales Pmt. Tol. Debit Acc.] }
    { 33  ;   ;Sales Pmt. Tol. Credit Acc.;Code20 ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Sales Pmt. Tol. Credit Acc.");
                                                                IF "Purch. Pmt. Disc. Debit Acc." <> '' THEN BEGIN
                                                                  GLSetup.GET;
                                                                  GLSetup.TESTFIELD("Adjust for Payment Disc.",TRUE);
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Salgstolerance - kreditkonto;
                                                              ENU=Sales Pmt. Tol. Credit Acc.] }
    { 34  ;   ;Purch. Pmt. Tol. Debit Acc.;Code20 ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Purch. Pmt. Tol. Debit Acc.");
                                                                IF "Purch. Pmt. Disc. Debit Acc." <> '' THEN BEGIN
                                                                  GLSetup.GET;
                                                                  GLSetup.TESTFIELD("Adjust for Payment Disc.",TRUE);
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=K�bstolerance - debetkonto;
                                                              ENU=Purch. Pmt. Tol. Debit Acc.] }
    { 35  ;   ;Purch. Pmt. Tol. Credit Acc.;Code20;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Purch. Pmt. Tol. Credit Acc.");
                                                                IF "Purch. Pmt. Disc. Debit Acc." <> '' THEN BEGIN
                                                                  GLSetup.GET;
                                                                  GLSetup.TESTFIELD("Adjust for Payment Disc.",TRUE);
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=K�bstolerance - kreditkonto;
                                                              ENU=Purch. Pmt. Tol. Credit Acc.] }
    { 36  ;   ;Sales Prepayments Account;Code20   ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Sales Prepayments Account");
                                                              END;

                                                   CaptionML=[DAN=Forudbetalingskonto for salg;
                                                              ENU=Sales Prepayments Account] }
    { 37  ;   ;Purch. Prepayments Account;Code20  ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Purch. Prepayments Account");
                                                              END;

                                                   CaptionML=[DAN=Forudbetalingskonto for k�b;
                                                              ENU=Purch. Prepayments Account] }
    { 40  ;   ;Used in Ledger Entries;Integer     ;FieldClass=FlowField;
                                                   CalcFormula=Count("G/L Entry" WHERE (Gen. Bus. Posting Group=FIELD(Gen. Bus. Posting Group),
                                                                                        Gen. Prod. Posting Group=FIELD(Gen. Prod. Posting Group)));
                                                   CaptionML=[DAN=Bruges i Finansposter;
                                                              ENU=Used in Ledger Entries];
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 50  ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 5600;   ;Purch. FA Disc. Account;Code20     ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Purch. FA Disc. Account");
                                                              END;

                                                   CaptionML=[DAN=K�bsanl�gsrabatkonto;
                                                              ENU=Purch. FA Disc. Account] }
    { 5801;   ;Invt. Accrual Acc. (Interim);Code20;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Invt. Accrual Acc. (Interim)");
                                                              END;

                                                   CaptionML=[DAN=Lagerperiod.konto (mellemkto.);
                                                              ENU=Invt. Accrual Acc. (Interim)] }
    { 5803;   ;COGS Account (Interim);Code20      ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("COGS Account (Interim)");
                                                              END;

                                                   CaptionML=[DAN=Vareforbrugskonto (mellemkto.);
                                                              ENU=COGS Account (Interim)] }
    { 99000752;;Direct Cost Applied Account;Code20;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Direct Cost Applied Account");
                                                              END;

                                                   CaptionML=[DAN=Tillagte dir. omkost.konto;
                                                              ENU=Direct Cost Applied Account] }
    { 99000753;;Overhead Applied Account;Code20   ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Overhead Applied Account");
                                                              END;

                                                   CaptionML=[DAN=Tillagte indir. prod.omkost.konto;
                                                              ENU=Overhead Applied Account] }
    { 99000754;;Purchase Variance Account;Code20  ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Purchase Variance Account");
                                                              END;

                                                   CaptionML=[DAN=K�bsafvigelseskonto;
                                                              ENU=Purchase Variance Account] }
  }
  KEYS
  {
    {    ;Gen. Bus. Posting Group,Gen. Prod. Posting Group;
                                                   Clustered=Yes }
    {    ;Gen. Prod. Posting Group,Gen. Bus. Posting Group }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      GLSetup@1000 : Record 98;
      GLAccountCategory@1001 : Record 570;
      GLAccountCategoryMgt@1002 : Codeunit 570;
      YouCannotDeleteErr@1003 : TextConst '@@@="%1 = Location Code; %2 = Posting Group";DAN=Du kan ikke slette %1 %2.;ENU=You cannot delete %1 %2.';
      PostingSetupMgt@1004 : Codeunit 48;

    LOCAL PROCEDURE CheckGLAcc@2(AccNo@1000 : Code[20]);
    VAR
      GLAcc@1001 : Record 15;
    BEGIN
      IF AccNo <> '' THEN BEGIN
        GLAcc.GET(AccNo);
        GLAcc.CheckGLAcc;
      END;
    END;

    LOCAL PROCEDURE CheckSetupUsage@24();
    BEGIN
      CALCFIELDS("Used in Ledger Entries");
      IF "Used in Ledger Entries" > 0 THEN
        ERROR(YouCannotDeleteErr,"Gen. Bus. Posting Group","Gen. Prod. Posting Group");
    END;

    [External]
    PROCEDURE GetCOGSAccount@11() : Code[20];
    BEGIN
      IF "COGS Account" = '' THEN
        PostingSetupMgt.SendGenPostingSetupNotification(Rec,FIELDCAPTION("COGS Account"));
      TESTFIELD("COGS Account");
      EXIT("COGS Account");
    END;

    [External]
    PROCEDURE GetCOGSInterimAccount@13() : Code[20];
    BEGIN
      IF "COGS Account (Interim)" = '' THEN
        PostingSetupMgt.SendGenPostingSetupNotification(Rec,FIELDCAPTION("COGS Account (Interim)"));
      TESTFIELD("COGS Account (Interim)");
      EXIT("COGS Account (Interim)");
    END;

    [External]
    PROCEDURE GetInventoryAdjmtAccount@17() : Code[20];
    BEGIN
      IF "Inventory Adjmt. Account" = '' THEN
        PostingSetupMgt.SendGenPostingSetupNotification(Rec,FIELDCAPTION("Inventory Adjmt. Account"));
      TESTFIELD("Inventory Adjmt. Account");
      EXIT("Inventory Adjmt. Account");
    END;

    [External]
    PROCEDURE GetInventoryAccrualAccount@12() : Code[20];
    BEGIN
      IF "Invt. Accrual Acc. (Interim)" = '' THEN
        PostingSetupMgt.SendGenPostingSetupNotification(Rec,FIELDCAPTION("Invt. Accrual Acc. (Interim)"));
      TESTFIELD("Invt. Accrual Acc. (Interim)");
      EXIT("Invt. Accrual Acc. (Interim)");
    END;

    [External]
    PROCEDURE GetSalesAccount@7() : Code[20];
    BEGIN
      IF "Sales Account" = '' THEN
        PostingSetupMgt.SendGenPostingSetupNotification(Rec,FIELDCAPTION("Sales Account"));
      TESTFIELD("Sales Account");
      EXIT("Sales Account");
    END;

    [External]
    PROCEDURE GetSalesCrMemoAccount@9() : Code[20];
    BEGIN
      IF "Sales Credit Memo Account" = '' THEN
        PostingSetupMgt.SendGenPostingSetupNotification(Rec,FIELDCAPTION("Sales Credit Memo Account"));
      TESTFIELD("Sales Credit Memo Account");
      EXIT("Sales Credit Memo Account");
    END;

    [External]
    PROCEDURE GetSalesInvDiscAccount@14() : Code[20];
    BEGIN
      IF "Sales Inv. Disc. Account" = '' THEN
        PostingSetupMgt.SendGenPostingSetupNotification(Rec,FIELDCAPTION("Sales Inv. Disc. Account"));
      TESTFIELD("Sales Inv. Disc. Account");
      EXIT("Sales Inv. Disc. Account");
    END;

    [External]
    PROCEDURE GetSalesLineDiscAccount@6() : Code[20];
    BEGIN
      IF "Sales Line Disc. Account" = '' THEN
        PostingSetupMgt.SendGenPostingSetupNotification(Rec,FIELDCAPTION("Sales Line Disc. Account"));
      TESTFIELD("Sales Line Disc. Account");
      EXIT("Sales Line Disc. Account");
    END;

    [External]
    PROCEDURE GetSalesPmtDiscountAccount@1(Debit@1000 : Boolean) : Code[20];
    BEGIN
      IF Debit THEN BEGIN
        IF "Sales Pmt. Disc. Debit Acc." = '' THEN
          PostingSetupMgt.SendGenPostingSetupNotification(Rec,FIELDCAPTION("Sales Pmt. Disc. Debit Acc."));
        TESTFIELD("Sales Pmt. Disc. Debit Acc.");
        EXIT("Sales Pmt. Disc. Debit Acc.");
      END;
      IF "Sales Pmt. Disc. Credit Acc." = '' THEN
        PostingSetupMgt.SendGenPostingSetupNotification(Rec,FIELDCAPTION("Sales Pmt. Disc. Credit Acc."));
      TESTFIELD("Sales Pmt. Disc. Credit Acc.");
      EXIT("Sales Pmt. Disc. Credit Acc.");
    END;

    [External]
    PROCEDURE GetSalesPmtToleranceAccount@3(Debit@1000 : Boolean) : Code[20];
    BEGIN
      IF Debit THEN BEGIN
        IF "Sales Pmt. Tol. Debit Acc." = '' THEN
          PostingSetupMgt.SendGenPostingSetupNotification(Rec,FIELDCAPTION("Sales Pmt. Tol. Debit Acc."));
        TESTFIELD("Sales Pmt. Tol. Debit Acc.");
        EXIT("Sales Pmt. Tol. Debit Acc.");
      END;
      IF "Sales Pmt. Tol. Credit Acc." = '' THEN
        PostingSetupMgt.SendGenPostingSetupNotification(Rec,FIELDCAPTION("Sales Pmt. Tol. Credit Acc."));
      TESTFIELD("Sales Pmt. Tol. Credit Acc.");
      EXIT("Sales Pmt. Tol. Credit Acc.");
    END;

    [External]
    PROCEDURE GetSalesPrepmtAccount@15() : Code[20];
    BEGIN
      IF "Sales Prepayments Account" = '' THEN
        PostingSetupMgt.SendGenPostingSetupNotification(Rec,FIELDCAPTION("Sales Prepayments Account"));
      TESTFIELD("Sales Prepayments Account");
      EXIT("Sales Prepayments Account");
    END;

    [External]
    PROCEDURE GetPurchAccount@8() : Code[20];
    BEGIN
      IF "Purch. Account" = '' THEN
        PostingSetupMgt.SendGenPostingSetupNotification(Rec,FIELDCAPTION("Purch. Account"));
      TESTFIELD("Purch. Account");
      EXIT("Purch. Account");
    END;

    [External]
    PROCEDURE GetPurchCrMemoAccount@10() : Code[20];
    BEGIN
      IF "Purch. Credit Memo Account" = '' THEN
        PostingSetupMgt.SendGenPostingSetupNotification(Rec,FIELDCAPTION("Purch. Credit Memo Account"));
      TESTFIELD("Purch. Credit Memo Account");
      EXIT("Purch. Credit Memo Account");
    END;

    [External]
    PROCEDURE GetPurchInvDiscAccount@23() : Code[20];
    BEGIN
      IF "Purch. Inv. Disc. Account" = '' THEN
        PostingSetupMgt.SendGenPostingSetupNotification(Rec,FIELDCAPTION("Purch. Inv. Disc. Account"));
      TESTFIELD("Purch. Inv. Disc. Account");
      EXIT("Purch. Inv. Disc. Account");
    END;

    [External]
    PROCEDURE GetPurchLineDiscAccount@22() : Code[20];
    BEGIN
      IF "Purch. Line Disc. Account" = '' THEN
        PostingSetupMgt.SendGenPostingSetupNotification(Rec,FIELDCAPTION("Purch. Line Disc. Account"));
      TESTFIELD("Purch. Line Disc. Account");
      EXIT("Purch. Line Disc. Account");
    END;

    [External]
    PROCEDURE GetPurchPmtDiscountAccount@5(Debit@1000 : Boolean) : Code[20];
    BEGIN
      IF Debit THEN BEGIN
        IF "Purch. Pmt. Disc. Debit Acc." = '' THEN
          PostingSetupMgt.SendGenPostingSetupNotification(Rec,FIELDCAPTION("Purch. Pmt. Disc. Debit Acc."));
        TESTFIELD("Purch. Pmt. Disc. Debit Acc.");
        EXIT("Purch. Pmt. Disc. Debit Acc.");
      END;
      IF "Purch. Pmt. Disc. Credit Acc." = '' THEN
        PostingSetupMgt.SendGenPostingSetupNotification(Rec,FIELDCAPTION("Purch. Pmt. Disc. Credit Acc."));
      TESTFIELD("Purch. Pmt. Disc. Credit Acc.");
      EXIT("Purch. Pmt. Disc. Credit Acc.");
    END;

    [External]
    PROCEDURE GetPurchPmtToleranceAccount@4(Debit@1000 : Boolean) : Code[20];
    BEGIN
      IF Debit THEN BEGIN
        IF "Purch. Pmt. Tol. Debit Acc." = '' THEN
          PostingSetupMgt.SendGenPostingSetupNotification(Rec,FIELDCAPTION("Purch. Pmt. Tol. Debit Acc."));
        TESTFIELD("Purch. Pmt. Tol. Debit Acc.");
        EXIT("Purch. Pmt. Tol. Debit Acc.");
      END;
      IF "Purch. Pmt. Tol. Credit Acc." = '' THEN
        PostingSetupMgt.SendGenPostingSetupNotification(Rec,FIELDCAPTION("Purch. Pmt. Tol. Credit Acc."));
      TESTFIELD("Purch. Pmt. Tol. Credit Acc.");
      EXIT("Purch. Pmt. Tol. Credit Acc.");
    END;

    [External]
    PROCEDURE GetPurchPrepmtAccount@16() : Code[20];
    BEGIN
      IF "Purch. Prepayments Account" = '' THEN
        PostingSetupMgt.SendGenPostingSetupNotification(Rec,FIELDCAPTION("Purch. Prepayments Account"));
      TESTFIELD("Purch. Prepayments Account");
      EXIT("Purch. Prepayments Account");
    END;

    [External]
    PROCEDURE GetPurchFADiscAccount@18() : Code[20];
    BEGIN
      IF "Purch. FA Disc. Account" = '' THEN
        PostingSetupMgt.SendGenPostingSetupNotification(Rec,FIELDCAPTION("Purch. FA Disc. Account"));
      TESTFIELD("Purch. FA Disc. Account");
      EXIT("Purch. FA Disc. Account");
    END;

    [External]
    PROCEDURE GetDirectCostAppliedAccount@19() : Code[20];
    BEGIN
      IF "Direct Cost Applied Account" = '' THEN
        PostingSetupMgt.SendGenPostingSetupNotification(Rec,FIELDCAPTION("Direct Cost Applied Account"));
      TESTFIELD("Direct Cost Applied Account");
      EXIT("Direct Cost Applied Account");
    END;

    [External]
    PROCEDURE GetOverheadAppliedAccount@20() : Code[20];
    BEGIN
      IF "Overhead Applied Account" = '' THEN
        PostingSetupMgt.SendGenPostingSetupNotification(Rec,FIELDCAPTION("Overhead Applied Account"));
      TESTFIELD("Overhead Applied Account");
      EXIT("Overhead Applied Account");
    END;

    [External]
    PROCEDURE GetPurchaseVarianceAccount@21() : Code[20];
    BEGIN
      IF "Purchase Variance Account" = '' THEN
        PostingSetupMgt.SendGenPostingSetupNotification(Rec,FIELDCAPTION("Purchase Variance Account"));
      TESTFIELD("Purchase Variance Account");
      EXIT("Purchase Variance Account");
    END;

    PROCEDURE SetAccountsVisibility@25(VAR PmtToleranceVisible@1000 : Boolean;VAR PmtDiscountVisible@1007 : Boolean;VAR SalesInvDiscVisible@1001 : Boolean;VAR SalesLineDiscVisible@1002 : Boolean;VAR PurchInvDiscVisible@1003 : Boolean;VAR PurchLineDiscVisible@1004 : Boolean);
    VAR
      SalesSetup@1005 : Record 311;
      PurchSetup@1006 : Record 312;
      PaymentTerms@1008 : Record 3;
    BEGIN
      GLSetup.GET;
      PmtToleranceVisible := (GLSetup."Payment Tolerance %" > 0) OR (GLSetup."Max. Payment Tolerance Amount" <> 0);

      PmtDiscountVisible := PaymentTerms.UsePaymentDiscount;

      SalesSetup.GET;
      SalesLineDiscVisible :=
        SalesSetup."Discount Posting" IN [SalesSetup."Discount Posting"::"All Discounts",
                                          SalesSetup."Discount Posting"::"Line Discounts"];
      SalesInvDiscVisible :=
        SalesSetup."Discount Posting" IN [SalesSetup."Discount Posting"::"All Discounts",
                                          SalesSetup."Discount Posting"::"Invoice Discounts"];

      PurchSetup.GET;
      PurchLineDiscVisible :=
        PurchSetup."Discount Posting" IN [PurchSetup."Discount Posting"::"All Discounts",
                                          PurchSetup."Discount Posting"::"Line Discounts"];
      PurchInvDiscVisible :=
        PurchSetup."Discount Posting" IN [PurchSetup."Discount Posting"::"All Discounts",
                                          PurchSetup."Discount Posting"::"Invoice Discounts"];
    END;

    PROCEDURE SuggestSetupAccounts@26();
    VAR
      RecRef@1000 : RecordRef;
    BEGIN
      RecRef.GETTABLE(Rec);
      SuggestSalesAccounts(RecRef);
      SuggestPurchAccounts(RecRef);
      SuggestInvtAccounts(RecRef);
      RecRef.MODIFY;
    END;

    LOCAL PROCEDURE SuggestSalesAccounts@30(VAR RecRef@1000 : RecordRef);
    BEGIN
      IF "Sales Account" = '' THEN
        SuggestAccount(RecRef,FIELDNO("Sales Account"));
      IF "Sales Credit Memo Account" = '' THEN
        SuggestAccount(RecRef,FIELDNO("Sales Credit Memo Account"));
      IF "Sales Inv. Disc. Account" = '' THEN
        SuggestAccount(RecRef,FIELDNO("Sales Inv. Disc. Account"));
      IF "Sales Line Disc. Account" = '' THEN
        SuggestAccount(RecRef,FIELDNO("Sales Line Disc. Account"));
      IF "Sales Pmt. Disc. Credit Acc." = '' THEN
        SuggestAccount(RecRef,FIELDNO("Sales Pmt. Disc. Credit Acc."));
      IF "Sales Pmt. Disc. Debit Acc." = '' THEN
        SuggestAccount(RecRef,FIELDNO("Sales Pmt. Disc. Debit Acc."));
      IF "Sales Pmt. Tol. Credit Acc." = '' THEN
        SuggestAccount(RecRef,FIELDNO("Sales Pmt. Tol. Credit Acc."));
      IF "Sales Pmt. Tol. Debit Acc." = '' THEN
        SuggestAccount(RecRef,FIELDNO("Sales Pmt. Tol. Debit Acc."));
      IF "Sales Prepayments Account" = '' THEN
        SuggestAccount(RecRef,FIELDNO("Sales Prepayments Account"));
    END;

    LOCAL PROCEDURE SuggestPurchAccounts@31(VAR RecRef@1000 : RecordRef);
    BEGIN
      IF "Purch. Account" = '' THEN
        SuggestAccount(RecRef,FIELDNO("Purch. Account"));
      IF "Purch. Credit Memo Account" = '' THEN
        SuggestAccount(RecRef,FIELDNO("Purch. Credit Memo Account"));
      IF "Purch. Inv. Disc. Account" = '' THEN
        SuggestAccount(RecRef,FIELDNO("Purch. Inv. Disc. Account"));
      IF "Purch. Line Disc. Account" = '' THEN
        SuggestAccount(RecRef,FIELDNO("Purch. Line Disc. Account"));
      IF "Purch. Pmt. Disc. Credit Acc." = '' THEN
        SuggestAccount(RecRef,FIELDNO("Purch. Pmt. Disc. Credit Acc."));
      IF "Purch. Pmt. Disc. Debit Acc." = '' THEN
        SuggestAccount(RecRef,FIELDNO("Purch. Pmt. Disc. Debit Acc."));
      IF "Purch. Pmt. Tol. Credit Acc." = '' THEN
        SuggestAccount(RecRef,FIELDNO("Purch. Pmt. Tol. Credit Acc."));
      IF "Purch. Pmt. Tol. Debit Acc." = '' THEN
        SuggestAccount(RecRef,FIELDNO("Purch. Pmt. Tol. Debit Acc."));
      IF "Purch. Prepayments Account" = '' THEN
        SuggestAccount(RecRef,FIELDNO("Purch. Prepayments Account"));
    END;

    LOCAL PROCEDURE SuggestInvtAccounts@32(VAR RecRef@1000 : RecordRef);
    BEGIN
      IF "COGS Account" = '' THEN
        SuggestAccount(RecRef,FIELDNO("COGS Account"));
      IF "COGS Account (Interim)" = '' THEN
        SuggestAccount(RecRef,FIELDNO("COGS Account (Interim)"));
      IF "Inventory Adjmt. Account" = '' THEN
        SuggestAccount(RecRef,FIELDNO("Inventory Adjmt. Account"));
      IF "Invt. Accrual Acc. (Interim)" = '' THEN
        SuggestAccount(RecRef,FIELDNO("Invt. Accrual Acc. (Interim)"));
      IF "Direct Cost Applied Account" = '' THEN
        SuggestAccount(RecRef,FIELDNO("Direct Cost Applied Account"));
      IF "Overhead Applied Account" = '' THEN
        SuggestAccount(RecRef,FIELDNO("Overhead Applied Account"));
      IF "Purchase Variance Account" = '' THEN
        SuggestAccount(RecRef,FIELDNO("Purchase Variance Account"));
    END;

    LOCAL PROCEDURE SuggestAccount@34(VAR RecRef@1000 : RecordRef;AccountFieldNo@1001 : Integer);
    VAR
      TempAccountUseBuffer@1002 : TEMPORARY Record 63;
      RecFieldRef@1003 : FieldRef;
      GenPostingSetupRecRef@1005 : RecordRef;
      GenPostingSetupFieldRef@1006 : FieldRef;
    BEGIN
      GenPostingSetupRecRef.OPEN(DATABASE::"General Posting Setup");

      GenPostingSetupRecRef.RESET;
      GenPostingSetupFieldRef := GenPostingSetupRecRef.FIELD(FIELDNO("Gen. Bus. Posting Group"));
      GenPostingSetupFieldRef.SETRANGE("Gen. Bus. Posting Group");
      GenPostingSetupFieldRef := GenPostingSetupRecRef.FIELD(FIELDNO("Gen. Prod. Posting Group"));
      GenPostingSetupFieldRef.SETFILTER('<>%1',"Gen. Prod. Posting Group");
      TempAccountUseBuffer.UpdateBuffer(GenPostingSetupRecRef,AccountFieldNo);

      GenPostingSetupRecRef.RESET;
      GenPostingSetupFieldRef := GenPostingSetupRecRef.FIELD(FIELDNO("Gen. Bus. Posting Group"));
      GenPostingSetupFieldRef.SETFILTER('<>%1',"Gen. Bus. Posting Group");
      GenPostingSetupFieldRef := GenPostingSetupRecRef.FIELD(FIELDNO("Gen. Prod. Posting Group"));
      GenPostingSetupFieldRef.SETRANGE("Gen. Prod. Posting Group");
      TempAccountUseBuffer.UpdateBuffer(GenPostingSetupRecRef,AccountFieldNo);

      GenPostingSetupRecRef.CLOSE;

      TempAccountUseBuffer.RESET;
      TempAccountUseBuffer.SETCURRENTKEY("No. of Use");
      IF TempAccountUseBuffer.FINDLAST THEN BEGIN
        RecFieldRef := RecRef.FIELD(AccountFieldNo);
        RecFieldRef.VALUE(TempAccountUseBuffer."Account No.");
      END;
    END;

    BEGIN
    END.
  }
}

