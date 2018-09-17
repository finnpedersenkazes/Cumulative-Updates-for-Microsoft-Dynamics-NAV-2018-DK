OBJECT Codeunit 570 G/L Account Category Mgt.
{
  OBJECT-PROPERTIES
  {
    Date=28-06-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23019;
  }
  PROPERTIES
  {
    OnRun=BEGIN
            InitializeAccountCategories;
          END;

  }
  CODE
  {
    VAR
      BalanceColumnNameTxt@1008 : TextConst '@@@=Max 10 char;DAN=M-SALDO;ENU=M-BALANCE';
      BalanceColumnDescTxt@1041 : TextConst '@@@=Max 10 char;DAN=Saldo;ENU=Balance';
      NetChangeColumnNameTxt@1043 : TextConst '@@@=Max 10 char;DAN=M-BEV�G.;ENU=M-NETCHANG';
      NetChangeColumnDescTxt@1042 : TextConst '@@@=Max 10 char;DAN=Bev�gelse;ENU=Net Change';
      BalanceSheetCodeTxt@1000 : TextConst '@@@=Max 10 char;DAN=M-SALDO;ENU=M-BALANCE';
      BalanceSheetDescTxt@1001 : TextConst '@@@=Max 80 chars;DAN=Balance;ENU=Balance Sheet';
      IncomeStmdCodeTxt@1002 : TextConst '@@@=Max 10 chars;DAN=M-INDT�GT.;ENU=M-INCOME';
      IncomeStmdDescTxt@1003 : TextConst '@@@=Max 80 chars;DAN=Resultatopg�relse;ENU=Income Statement';
      CashFlowCodeTxt@1004 : TextConst '@@@=Max 10 chars;DAN=M-PENGEST.;ENU=M-CASHFLOW';
      CashFlowDescTxt@1005 : TextConst '@@@=Max 80 chars;DAN=Pengestr�msopg�relse;ENU=Cash Flow Statement';
      RetainedEarnCodeTxt@1006 : TextConst '@@@=Max 10 char.;DAN=M-OVERF�RT;ENU=M-RETAIND';
      RetainedEarnDescTxt@1007 : TextConst '@@@=Max 80 chars;DAN=Overf�rt resultat;ENU=Retained Earnings';
      MissingSetupErr@1010 : TextConst '@@@="%1 = field name, %2 = table name.";DAN=Du skal definere %1 i %2, f�r denne funktion udf�res.;ENU=You must define a %1 in %2 before performing this function.';
      CurrentAssetsTxt@1025 : TextConst 'DAN=Oms�tningsaktiver;ENU=Current Assets';
      ARTxt@1040 : TextConst 'DAN=Tilgodehavender;ENU=Accounts Receivable';
      CashTxt@1024 : TextConst 'DAN=Kassebeholdning;ENU=Cash';
      PrepaidExpensesTxt@1023 : TextConst 'DAN=Forudbetalte udgifter;ENU=Prepaid Expenses';
      InventoryTxt@1026 : TextConst 'DAN=Lager;ENU=Inventory';
      FixedAssetsTxt@1022 : TextConst 'DAN=Anl�g;ENU=Fixed Assets';
      EquipementTxt@1027 : TextConst 'DAN=Udstyr;ENU=Equipment';
      AccumDeprecTxt@1028 : TextConst 'DAN=Akkumuleret afskrivning;ENU=Accumulated Depreciation';
      CurrentLiabilitiesTxt@1021 : TextConst 'DAN=Aktuelle passiver;ENU=Current Liabilities';
      PayrollLiabilitiesTxt@1020 : TextConst 'DAN=Udest�ende l�nudgifter;ENU=Payroll Liabilities';
      LongTermLiabilitiesTxt@1019 : TextConst 'DAN=Langfristet g�ld;ENU=Long Term Liabilities';
      CommonStockTxt@1029 : TextConst 'DAN=Aktier;ENU=Common Stock';
      RetEarningsTxt@1030 : TextConst 'DAN=Overf�rt resultat;ENU=Retained Earnings';
      DistrToShareholdersTxt@1031 : TextConst 'DAN=Uddelinger til aktion�rer;ENU=Distributions to Shareholders';
      IncomeServiceTxt@1032 : TextConst 'DAN=Indt�gter, Service;ENU=Income, Services';
      IncomeProdSalesTxt@1033 : TextConst 'DAN=Indt�gter, Produktsalg;ENU=Income, Product Sales';
      IncomeSalesDiscountsTxt@1034 : TextConst 'DAN=Salgsrabatter;ENU=Sales Discounts';
      IncomeSalesReturnsTxt@1035 : TextConst 'DAN=Salgsreturneringer og -nedslag;ENU=Sales Returns & Allowances';
      IncomeInterestTxt@1049 : TextConst 'DAN=Indt�gter, Renter;ENU=Income, Interest';
      COGSLaborTxt@1036 : TextConst 'DAN=Arbejde;ENU=Labor';
      COGSMaterialsTxt@1018 : TextConst 'DAN=Materialer;ENU=Materials';
      COGSDiscountsGrantedTxt@1054 : TextConst 'DAN=Afgivne varerabatter;ENU=Discounts Granted';
      RentExpenseTxt@1037 : TextConst 'DAN=Lejeudgifter;ENU=Rent Expense';
      AdvertisingExpenseTxt@1017 : TextConst 'DAN=Reklameudgifter;ENU=Advertising Expense';
      InterestExpenseTxt@1038 : TextConst 'DAN=Renteudgifter;ENU=Interest Expense';
      FeesExpenseTxt@1016 : TextConst 'DAN=Gebyrudgifter;ENU=Fees Expense';
      InsuranceExpenseTxt@1015 : TextConst 'DAN=Forsikringsudgifter;ENU=Insurance Expense';
      PayrollExpenseTxt@1014 : TextConst 'DAN=L�nudgifter;ENU=Payroll Expense';
      BenefitsExpenseTxt@1013 : TextConst 'DAN=Personaleudgifter;ENU=Benefits Expense';
      RepairsTxt@1039 : TextConst 'DAN=Reparations- og vedligeholdelsesudgifter;ENU=Repairs and Maintenance Expense';
      UtilitiesExpenseTxt@1012 : TextConst 'DAN=Forsyningsudgifter;ENU=Utilities Expense';
      OtherIncomeExpenseTxt@1011 : TextConst 'DAN=Andre indt�gter og udgifter;ENU=Other Income & Expenses';
      TaxExpenseTxt@1009 : TextConst 'DAN=Skatteudgifter;ENU=Tax Expense';
      TravelExpenseTxt@1055 : TextConst 'DAN=Rejseomkostninger;ENU=Travel Expense';
      VehicleExpensesTxt@1056 : TextConst 'DAN=Bildrift;ENU=Vehicle Expenses';
      BadDebtExpenseTxt@1044 : TextConst 'DAN=Tab p� debitorer;ENU=Bad Debt Expense';
      SalariesExpenseTxt@1045 : TextConst 'DAN=L�nudgifter;ENU=Salaries Expense';
      JobsCostTxt@1046 : TextConst 'DAN=Sagsomkostning;ENU=Jobs Cost';
      IncomeJobsTxt@1047 : TextConst 'DAN=Indt�gter, sager;ENU=Income, Jobs';
      JobSalesContraTxt@1048 : TextConst 'DAN=Modkonto til salg af sager;ENU=Job Sales Contra';

    [External]
    PROCEDURE InitializeAccountCategories@7();
    VAR
      GLAccountCategory@1001 : Record 570;
      GLAccount@1005 : Record 15;
      CategoryID@1000 : ARRAY [3] OF Integer;
    BEGIN
      GLAccount.SETFILTER("Account Subcategory Entry No.",'<>0');
      IF NOT GLAccount.ISEMPTY THEN
        IF NOT GLAccountCategory.ISEMPTY THEN
          EXIT;

      GLAccount.MODIFYALL("Account Subcategory Entry No.",0);
      WITH GLAccountCategory DO BEGIN
        DELETEALL;
        CategoryID[1] := AddCategory(0,0,"Account Category"::Assets,'',TRUE,0);
        CategoryID[2] := AddCategory(0,CategoryID[1],"Account Category"::Assets,CurrentAssetsTxt,FALSE,0);
        CategoryID[3] :=
          AddCategory(0,CategoryID[2],"Account Category"::Assets,CashTxt,FALSE,"Additional Report Definition"::"Cash Accounts");
        CategoryID[3] :=
          AddCategory(
            0,CategoryID[2],"Account Category"::Assets,ARTxt,FALSE,
            "Additional Report Definition"::"Operating Activities");
        CategoryID[3] :=
          AddCategory(
            0,CategoryID[2],"Account Category"::Assets,PrepaidExpensesTxt,FALSE,
            "Additional Report Definition"::"Operating Activities");
        CategoryID[3] :=
          AddCategory(
            0,CategoryID[2],"Account Category"::Assets,InventoryTxt,FALSE,
            "Additional Report Definition"::"Operating Activities");
        CategoryID[2] := AddCategory(0,CategoryID[1],"Account Category"::Assets,FixedAssetsTxt,FALSE,0);
        CategoryID[3] :=
          AddCategory(
            0,CategoryID[2],"Account Category"::Assets,EquipementTxt,FALSE,
            "Additional Report Definition"::"Investing Activities");
        CategoryID[3] :=
          AddCategory(
            0,CategoryID[2],"Account Category"::Assets,AccumDeprecTxt,FALSE,
            "Additional Report Definition"::"Investing Activities");
        CategoryID[1] := AddCategory(0,0,"Account Category"::Liabilities,'',TRUE,0);
        CategoryID[2] :=
          AddCategory(
            0,CategoryID[1],"Account Category"::Liabilities,CurrentLiabilitiesTxt,FALSE,
            "Additional Report Definition"::"Operating Activities");
        CategoryID[2] :=
          AddCategory(
            0,CategoryID[1],"Account Category"::Liabilities,PayrollLiabilitiesTxt,FALSE,
            "Additional Report Definition"::"Operating Activities");
        CategoryID[2] :=
          AddCategory(
            0,CategoryID[1],"Account Category"::Liabilities,LongTermLiabilitiesTxt,FALSE,
            "Additional Report Definition"::"Financing Activities");
        CategoryID[1] := AddCategory(0,0,"Account Category"::Equity,'',TRUE,0);
        CategoryID[2] := AddCategory(0,CategoryID[1],"Account Category"::Equity,CommonStockTxt,FALSE,0);
        CategoryID[2] :=
          AddCategory(
            0,CategoryID[1],"Account Category"::Equity,RetEarningsTxt,FALSE,
            "Additional Report Definition"::"Retained Earnings");
        CategoryID[2] :=
          AddCategory(
            0,CategoryID[1],"Account Category"::Equity,DistrToShareholdersTxt,FALSE,
            "Additional Report Definition"::"Distribution to Shareholders");
        CategoryID[1] := AddCategory(0,0,"Account Category"::Income,'',TRUE,0);
        CategoryID[2] := AddCategory(0,CategoryID[1],"Account Category"::Income,IncomeServiceTxt,FALSE,0);
        CategoryID[2] := AddCategory(0,CategoryID[1],"Account Category"::Income,IncomeProdSalesTxt,FALSE,0);
        CategoryID[2] := AddCategory(0,CategoryID[1],"Account Category"::Income,IncomeJobsTxt,FALSE,0);
        CategoryID[2] := AddCategory(0,CategoryID[1],"Account Category"::Income,IncomeSalesDiscountsTxt,FALSE,0);
        CategoryID[2] := AddCategory(0,CategoryID[1],"Account Category"::Income,IncomeSalesReturnsTxt,FALSE,0);
        CategoryID[2] := AddCategory(0,CategoryID[1],"Account Category"::Income,IncomeInterestTxt,FALSE,0);
        CategoryID[2] := AddCategory(0,CategoryID[1],"Account Category"::Income,JobSalesContraTxt,FALSE,0);
        CategoryID[1] := AddCategory(0,0,"Account Category"::"Cost of Goods Sold",'',TRUE,0);
        CategoryID[2] := AddCategory(0,CategoryID[1],"Account Category"::"Cost of Goods Sold",COGSLaborTxt,FALSE,0);
        CategoryID[2] := AddCategory(0,CategoryID[1],"Account Category"::"Cost of Goods Sold",COGSMaterialsTxt,FALSE,0);
        CategoryID[2] := AddCategory(0,CategoryID[1],"Account Category"::"Cost of Goods Sold",COGSDiscountsGrantedTxt,FALSE,0);
        CategoryID[2] := AddCategory(0,CategoryID[1],"Account Category"::"Cost of Goods Sold",JobsCostTxt,FALSE,0);
        CategoryID[1] := AddCategory(0,0,"Account Category"::Expense,'',TRUE,0);
        CategoryID[2] := AddCategory(0,CategoryID[1],"Account Category"::Expense,RentExpenseTxt,FALSE,0);
        CategoryID[2] := AddCategory(0,CategoryID[1],"Account Category"::Expense,AdvertisingExpenseTxt,FALSE,0);
        CategoryID[2] := AddCategory(0,CategoryID[1],"Account Category"::Expense,InterestExpenseTxt,FALSE,0);
        CategoryID[2] := AddCategory(0,CategoryID[1],"Account Category"::Expense,FeesExpenseTxt,FALSE,0);
        CategoryID[2] := AddCategory(0,CategoryID[1],"Account Category"::Expense,InsuranceExpenseTxt,FALSE,0);
        CategoryID[2] := AddCategory(0,CategoryID[1],"Account Category"::Expense,PayrollExpenseTxt,FALSE,0);
        CategoryID[2] := AddCategory(0,CategoryID[1],"Account Category"::Expense,BenefitsExpenseTxt,FALSE,0);
        CategoryID[2] := AddCategory(0,CategoryID[1],"Account Category"::Expense,SalariesExpenseTxt,FALSE,0);
        CategoryID[2] := AddCategory(0,CategoryID[1],"Account Category"::Expense,RepairsTxt,FALSE,0);
        CategoryID[2] := AddCategory(0,CategoryID[1],"Account Category"::Expense,UtilitiesExpenseTxt,FALSE,0);
        CategoryID[2] := AddCategory(0,CategoryID[1],"Account Category"::Expense,OtherIncomeExpenseTxt,FALSE,0);
        CategoryID[2] := AddCategory(0,CategoryID[1],"Account Category"::Expense,TaxExpenseTxt,FALSE,0);
        CategoryID[2] := AddCategory(0,CategoryID[1],"Account Category"::Expense,TravelExpenseTxt,FALSE,0);
        CategoryID[2] := AddCategory(0,CategoryID[1],"Account Category"::Expense,VehicleExpensesTxt,FALSE,0);
        CategoryID[2] := AddCategory(0,CategoryID[1],"Account Category"::Expense,BadDebtExpenseTxt,FALSE,0);
      END;
    END;

    [External]
    PROCEDURE AddCategory@5(InsertAfterEntryNo@1004 : Integer;ParentEntryNo@1000 : Integer;AccountCategory@1001 : Option;NewDescription@1002 : Text[80];SystemGenerated@1007 : Boolean;CashFlowActivity@1008 : Option) : Integer;
    VAR
      GLAccountCategory@1003 : Record 570;
      InsertAfterSequenceNo@1005 : Integer;
      InsertBeforeSequenceNo@1006 : Integer;
    BEGIN
      IF InsertAfterEntryNo <> 0 THEN BEGIN
        GLAccountCategory.SETCURRENTKEY("Presentation Order","Sibling Sequence No.");
        IF GLAccountCategory.GET(InsertAfterEntryNo) THEN BEGIN
          InsertAfterSequenceNo := GLAccountCategory."Sibling Sequence No.";
          IF GLAccountCategory.NEXT <> 0 THEN
            InsertBeforeSequenceNo := GLAccountCategory."Sibling Sequence No.";
        END;
      END;
      GLAccountCategory.INIT;
      GLAccountCategory."Entry No." := 0;
      GLAccountCategory."System Generated" := SystemGenerated;
      GLAccountCategory."Parent Entry No." := ParentEntryNo;
      GLAccountCategory.VALIDATE("Account Category",AccountCategory);
      GLAccountCategory.VALIDATE("Additional Report Definition",CashFlowActivity);
      IF NewDescription <> '' THEN
        GLAccountCategory.Description := NewDescription;
      IF InsertAfterSequenceNo <> 0 THEN BEGIN
        IF InsertBeforeSequenceNo <> 0 THEN
          GLAccountCategory."Sibling Sequence No." := (InsertBeforeSequenceNo + InsertAfterSequenceNo) DIV 2
        ELSE
          GLAccountCategory."Sibling Sequence No." := InsertAfterSequenceNo + 10000;
      END;
      GLAccountCategory.INSERT(TRUE);
      GLAccountCategory.UpdatePresentationOrder;
      EXIT(GLAccountCategory."Entry No.");
    END;

    [External]
    PROCEDURE InitializeStandardAccountSchedules@1();
    VAR
      GeneralLedgerSetup@1000 : Record 98;
    BEGIN
      IF NOT GeneralLedgerSetup.GET THEN
        EXIT;

      AddColumnLayout(BalanceColumnNameTxt,BalanceColumnDescTxt,TRUE);
      AddColumnLayout(NetChangeColumnNameTxt,NetChangeColumnDescTxt,FALSE);

      IF GeneralLedgerSetup."Acc. Sched. for Balance Sheet" = '' THEN
        GeneralLedgerSetup."Acc. Sched. for Balance Sheet" := CreateUniqueAccSchedName(BalanceSheetCodeTxt);
      IF GeneralLedgerSetup."Acc. Sched. for Income Stmt." = '' THEN
        GeneralLedgerSetup."Acc. Sched. for Income Stmt." := CreateUniqueAccSchedName(IncomeStmdCodeTxt);
      IF GeneralLedgerSetup."Acc. Sched. for Cash Flow Stmt" = '' THEN
        GeneralLedgerSetup."Acc. Sched. for Cash Flow Stmt" := CreateUniqueAccSchedName(CashFlowCodeTxt);
      IF GeneralLedgerSetup."Acc. Sched. for Retained Earn." = '' THEN
        GeneralLedgerSetup."Acc. Sched. for Retained Earn." := CreateUniqueAccSchedName(RetainedEarnCodeTxt);
      GeneralLedgerSetup.MODIFY;

      AddAccountSchedule(GeneralLedgerSetup."Acc. Sched. for Balance Sheet",BalanceSheetDescTxt,BalanceColumnNameTxt);
      AddAccountSchedule(GeneralLedgerSetup."Acc. Sched. for Income Stmt.",IncomeStmdDescTxt,NetChangeColumnNameTxt);
      AddAccountSchedule(GeneralLedgerSetup."Acc. Sched. for Cash Flow Stmt",CashFlowDescTxt,NetChangeColumnNameTxt);
      AddAccountSchedule(GeneralLedgerSetup."Acc. Sched. for Retained Earn.",RetainedEarnDescTxt,NetChangeColumnNameTxt);
    END;

    LOCAL PROCEDURE AddAccountSchedule@3(NewName@1000 : Code[10];NewDescription@1002 : Text[80];DefaultColumnName@1003 : Code[10]);
    VAR
      AccScheduleName@1001 : Record 84;
    BEGIN
      IF AccScheduleName.GET(NewName) THEN
        EXIT;
      AccScheduleName.INIT;
      AccScheduleName.Name := NewName;
      AccScheduleName.Description := NewDescription;
      AccScheduleName."Default Column Layout" := DefaultColumnName;
      AccScheduleName.INSERT;
    END;

    LOCAL PROCEDURE AddColumnLayout@9(NewName@1000 : Code[10];NewDescription@1002 : Text[80];IsBalance@1003 : Boolean);
    VAR
      ColumnLayoutName@1001 : Record 333;
      ColumnLayout@1004 : Record 334;
    BEGIN
      IF ColumnLayoutName.GET(NewName) THEN
        EXIT;
      ColumnLayoutName.INIT;
      ColumnLayoutName.Name := NewName;
      ColumnLayoutName.Description := NewDescription;
      ColumnLayoutName.INSERT;

      ColumnLayout.INIT;
      ColumnLayout."Column Layout Name" := NewName;
      ColumnLayout."Line No." := 10000;
      ColumnLayout."Column Header" := COPYSTR(NewDescription,1,MAXSTRLEN(ColumnLayout."Column Header"));
      IF IsBalance THEN
        ColumnLayout."Column Type" := ColumnLayout."Column Type"::"Balance at Date"
      ELSE
        ColumnLayout."Column Type" := ColumnLayout."Column Type"::"Net Change";
      ColumnLayout.INSERT;
    END;

    [External]
    PROCEDURE GetGLSetup@2(VAR GeneralLedgerSetup@1000 : Record 98);
    BEGIN
      GeneralLedgerSetup.GET;
      IF AnyAccSchedSetupMissing(GeneralLedgerSetup) THEN BEGIN
        InitializeStandardAccountSchedules;
        GeneralLedgerSetup.GET;
        IF AnyAccSchedSetupMissing(GeneralLedgerSetup) THEN
          ERROR(MissingSetupErr,GeneralLedgerSetup.FIELDCAPTION("Acc. Sched. for Balance Sheet"),GeneralLedgerSetup.TABLECAPTION);
        COMMIT;
        CODEUNIT.RUN(CODEUNIT::"Categ. Generate Acc. Schedules");
        COMMIT;
      END;
    END;

    LOCAL PROCEDURE CreateUniqueAccSchedName@6(SuggestedName@1000 : Code[10]) : Code[10];
    VAR
      AccScheduleName@1001 : Record 84;
      i@1002 : Integer;
    BEGIN
      WHILE AccScheduleName.GET(SuggestedName) AND (i < 1000) DO
        SuggestedName := GenerateNextName(SuggestedName,i);
      EXIT(SuggestedName);
    END;

    LOCAL PROCEDURE GenerateNextName@8(SuggestedName@1000 : Code[10];VAR i@1001 : Integer) : Code[10];
    VAR
      NumPart@1002 : Code[3];
    BEGIN
      i += 1;
      NumPart := COPYSTR(FORMAT(i),1,MAXSTRLEN(NumPart));
      EXIT(COPYSTR(SuggestedName,1,MAXSTRLEN(SuggestedName) - STRLEN(NumPart)) + NumPart);
    END;

    [External]
    PROCEDURE RunAccountScheduleReport@11(AccSchedName@1000 : Code[10]);
    VAR
      AccountSchedule@1001 : Report 25;
    BEGIN
      AccountSchedule.InitAccSched;
      AccountSchedule.SetAccSchedNameNonEditable(AccSchedName);
      AccountSchedule.RUN;
    END;

    LOCAL PROCEDURE AnyAccSchedSetupMissing@13(VAR GeneralLedgerSetup@1000 : Record 98) : Boolean;
    VAR
      AccScheduleName@1001 : Record 84;
    BEGIN
      IF (GeneralLedgerSetup."Acc. Sched. for Balance Sheet" = '') OR
         (GeneralLedgerSetup."Acc. Sched. for Cash Flow Stmt" = '') OR
         (GeneralLedgerSetup."Acc. Sched. for Income Stmt." = '') OR
         (GeneralLedgerSetup."Acc. Sched. for Retained Earn." = '')
      THEN
        EXIT(TRUE);
      IF NOT AccScheduleName.GET(GeneralLedgerSetup."Acc. Sched. for Balance Sheet") THEN
        EXIT(TRUE);
      IF NOT AccScheduleName.GET(GeneralLedgerSetup."Acc. Sched. for Cash Flow Stmt") THEN
        EXIT(TRUE);
      IF NOT AccScheduleName.GET(GeneralLedgerSetup."Acc. Sched. for Income Stmt.") THEN
        EXIT(TRUE);
      IF NOT AccScheduleName.GET(GeneralLedgerSetup."Acc. Sched. for Retained Earn.") THEN
        EXIT(TRUE);
      EXIT(FALSE);
    END;

    [EventSubscriber(Codeunit,2,OnCompanyInitialize)]
    LOCAL PROCEDURE OnInitializeCompany@4();
    VAR
      GLAccount@1000 : Record 15;
      GLAccountCategory@1001 : Record 570;
    BEGIN
      GLAccount.SETFILTER("Account Subcategory Entry No.",'<>0');
      IF NOT GLAccount.ISEMPTY THEN
        IF NOT GLAccountCategory.ISEMPTY THEN
          EXIT;

      InitializeAccountCategories;
      CODEUNIT.RUN(CODEUNIT::"Categ. Generate Acc. Schedules");
    END;

    [External]
    PROCEDURE GetCurrentAssets@20() : Text;
    BEGIN
      EXIT(CurrentAssetsTxt);
    END;

    [External]
    PROCEDURE GetAR@21() : Text;
    BEGIN
      EXIT(ARTxt);
    END;

    [External]
    PROCEDURE GetCash@22() : Text;
    BEGIN
      EXIT(CashTxt);
    END;

    [External]
    PROCEDURE GetPrepaidExpenses@23() : Text;
    BEGIN
      EXIT(PrepaidExpensesTxt);
    END;

    [External]
    PROCEDURE GetInventory@24() : Text;
    BEGIN
      EXIT(InventoryTxt);
    END;

    [External]
    PROCEDURE GetFixedAssets@25() : Text;
    BEGIN
      EXIT(FixedAssetsTxt);
    END;

    [External]
    PROCEDURE GetEquipment@26() : Text;
    BEGIN
      EXIT(EquipementTxt);
    END;

    [External]
    PROCEDURE GetAccumDeprec@27() : Text;
    BEGIN
      EXIT(AccumDeprecTxt);
    END;

    [External]
    PROCEDURE GetCurrentLiabilities@28() : Text;
    BEGIN
      EXIT(CurrentLiabilitiesTxt);
    END;

    [External]
    PROCEDURE GetPayrollLiabilities@29() : Text;
    BEGIN
      EXIT(PayrollLiabilitiesTxt);
    END;

    [External]
    PROCEDURE GetLongTermLiabilities@30() : Text;
    BEGIN
      EXIT(LongTermLiabilitiesTxt);
    END;

    [External]
    PROCEDURE GetCommonStock@31() : Text;
    BEGIN
      EXIT(CommonStockTxt);
    END;

    [External]
    PROCEDURE GetRetEarnings@32() : Text;
    BEGIN
      EXIT(RetEarningsTxt);
    END;

    [External]
    PROCEDURE GetDistrToShareholders@33() : Text;
    BEGIN
      EXIT(DistrToShareholdersTxt);
    END;

    [External]
    PROCEDURE GetIncomeService@34() : Text;
    BEGIN
      EXIT(IncomeServiceTxt);
    END;

    [External]
    PROCEDURE GetIncomeProdSales@35() : Text;
    BEGIN
      EXIT(IncomeProdSalesTxt);
    END;

    [External]
    PROCEDURE GetIncomeSalesDiscounts@60() : Text;
    BEGIN
      EXIT(IncomeSalesDiscountsTxt);
    END;

    [External]
    PROCEDURE GetIncomeSalesReturns@37() : Text;
    BEGIN
      EXIT(IncomeSalesReturnsTxt);
    END;

    [External]
    PROCEDURE GetIncomeInterest@56() : Text;
    BEGIN
      EXIT(IncomeInterestTxt);
    END;

    [External]
    PROCEDURE GetCOGSLabor@38() : Text;
    BEGIN
      EXIT(COGSLaborTxt);
    END;

    [External]
    PROCEDURE GetCOGSMaterials@39() : Text;
    BEGIN
      EXIT(COGSMaterialsTxt);
    END;

    [External]
    PROCEDURE GetCOGSDiscountsGranted@51() : Text;
    BEGIN
      EXIT(COGSDiscountsGrantedTxt);
    END;

    [External]
    PROCEDURE GetRentExpense@40() : Text;
    BEGIN
      EXIT(RentExpenseTxt);
    END;

    [External]
    PROCEDURE GetAdvertisingExpense@41() : Text;
    BEGIN
      EXIT(AdvertisingExpenseTxt);
    END;

    [External]
    PROCEDURE GetInterestExpense@42() : Text;
    BEGIN
      EXIT(InterestExpenseTxt);
    END;

    [External]
    PROCEDURE GetFeesExpense@43() : Text;
    BEGIN
      EXIT(FeesExpenseTxt);
    END;

    [External]
    PROCEDURE GetInsuranceExpense@44() : Text;
    BEGIN
      EXIT(InsuranceExpenseTxt);
    END;

    [External]
    PROCEDURE GetPayrollExpense@45() : Text;
    BEGIN
      EXIT(PayrollExpenseTxt);
    END;

    [External]
    PROCEDURE GetBenefitsExpense@46() : Text;
    BEGIN
      EXIT(BenefitsExpenseTxt);
    END;

    [External]
    PROCEDURE GetRepairsExpense@47() : Text;
    BEGIN
      EXIT(RepairsTxt);
    END;

    [External]
    PROCEDURE GetUtilitiesExpense@48() : Text;
    BEGIN
      EXIT(UtilitiesExpenseTxt);
    END;

    [External]
    PROCEDURE GetOtherIncomeExpense@49() : Text;
    BEGIN
      EXIT(OtherIncomeExpenseTxt);
    END;

    [External]
    PROCEDURE GetTaxExpense@50() : Text;
    BEGIN
      EXIT(TaxExpenseTxt);
    END;

    [External]
    PROCEDURE GetTravelExpense@52() : Text;
    BEGIN
      EXIT(TravelExpenseTxt);
    END;

    [External]
    PROCEDURE GetVehicleExpenses@53() : Text;
    BEGIN
      EXIT(VehicleExpensesTxt);
    END;

    [External]
    PROCEDURE GetBadDebtExpense@15() : Text;
    BEGIN
      EXIT(BadDebtExpenseTxt);
    END;

    [External]
    PROCEDURE GetSalariesExpense@17() : Text;
    BEGIN
      EXIT(SalariesExpenseTxt);
    END;

    [External]
    PROCEDURE GetJobsCost@18() : Text;
    BEGIN
      EXIT(JobsCostTxt);
    END;

    [External]
    PROCEDURE GetIncomeJobs@19() : Text;
    BEGIN
      EXIT(IncomeJobsTxt);
    END;

    [External]
    PROCEDURE GetJobSalesContra@36() : Text;
    BEGIN
      EXIT(JobSalesContraTxt);
    END;

    [External]
    PROCEDURE GetAccountCategory@12(VAR GLAccountCategory@1000 : Record 570;Category@1002 : Option);
    BEGIN
      GLAccountCategory.SETRANGE("Account Category",Category);
      GLAccountCategory.SETRANGE("Parent Entry No.",0);
      IF GLAccountCategory.FINDFIRST THEN;
    END;

    [External]
    PROCEDURE GetAccountSubcategory@14(VAR GLAccountCategory@1000 : Record 570;Category@1002 : Option;Description@1001 : Text);
    BEGIN
      GLAccountCategory.SETRANGE("Account Category",Category);
      GLAccountCategory.SETFILTER("Parent Entry No.",'<>%1',0);
      GLAccountCategory.SETRANGE(Description,Description);
      IF GLAccountCategory.FINDFIRST THEN;
    END;

    [External]
    PROCEDURE GetSubcategoryEntryNo@55(Category@1000 : Option;SubcategoryDescription@1001 : Text) : Integer;
    VAR
      GLAccountCategory@1002 : Record 570;
    BEGIN
      GLAccountCategory.SETRANGE("Account Category",Category);
      GLAccountCategory.SETRANGE(Description,SubcategoryDescription);
      IF GLAccountCategory.FINDFIRST THEN
        EXIT(GLAccountCategory."Entry No.");
    END;

    [External]
    PROCEDURE CheckGLAccount@54(AccNo@1000 : Code[20];CheckProdPostingGroup@1001 : Boolean;CheckDirectPosting@1002 : Boolean;AccountCategory@1005 : Option;AccountSubcategory@1004 : Text);
    VAR
      GLAcc@1003 : Record 15;
    BEGIN
      IF AccNo = '' THEN
        EXIT;

      GLAcc.GET(AccNo);
      GLAcc.CheckGLAcc;
      IF CheckProdPostingGroup THEN
        GLAcc.TESTFIELD("Gen. Prod. Posting Group");
      IF CheckDirectPosting THEN
        GLAcc.TESTFIELD("Direct Posting",TRUE);
      IF GLAcc."Account Category" = 0 THEN BEGIN
        GLAcc.VALIDATE("Account Category",AccountCategory);
        IF AccountSubcategory <> '' THEN
          GLAcc.VALIDATE("Account Subcategory Entry No.",GetSubcategoryEntryNo(AccountCategory,AccountSubcategory));
        GLAcc.MODIFY;
      END;
    END;

    PROCEDURE LookupGLAccount@16(VAR AccountNo@1005 : Code[20];AccountCategory@1000 : Option;AccountSubcategoryFilter@1001 : Text);
    VAR
      GLAccount@1002 : Record 15;
      GLAccountCategory@1003 : Record 570;
      GLAccountList@1004 : Page 18;
      EntryNoFilter@1006 : Text;
    BEGIN
      GLAccount.RESET;
      GLAccount.SETRANGE("Account Type",GLAccount."Account Type"::Posting);
      GLAccountCategory.SETRANGE("Account Category",AccountCategory);
      GLAccountCategory.SETFILTER(Description,AccountSubcategoryFilter);
      IF NOT GLAccountCategory.ISEMPTY THEN BEGIN
        EntryNoFilter := '';
        GLAccountCategory.FINDSET;
        REPEAT
          EntryNoFilter := EntryNoFilter + FORMAT(GLAccountCategory."Entry No.") + '|';
        UNTIL GLAccountCategory.NEXT = 0;
        EntryNoFilter := COPYSTR(EntryNoFilter,1,STRLEN(EntryNoFilter) - 1);
        GLAccount.SETRANGE("Account Category",GLAccountCategory."Account Category");
        GLAccount.SETFILTER("Account Subcategory Entry No.",EntryNoFilter);
        IF NOT GLAccount.FINDFIRST THEN BEGIN
          GLAccount.SETRANGE("Account Category",0);
          GLAccount.SETRANGE("Account Subcategory Entry No.",0);
        END;
      END;
      GLAccountList.SETTABLEVIEW(GLAccount);
      GLAccountList.LOOKUPMODE(TRUE);
      IF GLAccountList.RUNMODAL = ACTION::LookupOK THEN BEGIN
        GLAccountList.GETRECORD(GLAccount);
        AccountNo := GLAccount."No.";
      END;
    END;

    BEGIN
    END.
  }
}

