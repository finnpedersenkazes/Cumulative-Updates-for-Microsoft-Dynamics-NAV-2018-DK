OBJECT Codeunit 841 Cash Flow Management
{
  OBJECT-PROPERTIES
  {
    Date=25-05-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.22292;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      SourceDataDoesNotExistErr@1000 : TextConst '@@@=Source data doesn''t exist for G/L Account: 8210.;DAN=Der findes ikke kildedata for %1: %2.;ENU=Source data does not exist for %1: %2.';
      SourceDataDoesNotExistInfoErr@1001 : TextConst '@@@=Source data doesn''t exist in Vendor Ledger Entry for Document No.: PO000123.;DAN=Der findes ikke kildedata i %1 for %2: %3.;ENU=Source data does not exist in %1 for %2: %3.';
      SourceTypeNotSupportedErr@1002 : TextConst 'DAN=Kildetypen underst�ttes ikke.;ENU=Source type is not supported.';
      DefaultTxt@1003 : TextConst 'DAN=Standard;ENU=Default';
      DummyDate@1004 : Date;
      CashFlowTxt@1005 : TextConst 'DAN=Likviditet;ENU=CashFlow';
      CashFlowForecastTxt@1007 : TextConst 'DAN=Pengestr�msprognose;ENU=Cash Flow Forecast';
      CashFlowAbbreviationTxt@1006 : TextConst '@@@=Abbreviation of Cash Flow;DAN=PS;ENU=CF';
      UpdatingMsg@1008 : TextConst 'DAN=Opdaterer pengestr�msprognose...;ENU=Updating Cash Flow Forecast...';

    [Internal]
    PROCEDURE ShowSourceDocument@31(CFVariant@1001 : Variant);
    VAR
      CFRecordRef@1004 : RecordRef;
    BEGIN
      CFRecordRef.GETTABLE(CFVariant);
      CASE CFRecordRef.NUMBER OF
        DATABASE::"Cash Flow Worksheet Line":
          ShowSourceLocalCFWorkSheetLine(TRUE,CFVariant);
        DATABASE::"Cash Flow Forecast Entry":
          ShowSourceLocalCFEntry(TRUE,CFVariant);
      END;
    END;

    [Internal]
    PROCEDURE ShowSource@32(CFVariant@1000 : Variant);
    VAR
      CFRecordRef@1001 : RecordRef;
    BEGIN
      CFRecordRef.GETTABLE(CFVariant);
      CASE CFRecordRef.NUMBER OF
        DATABASE::"Cash Flow Worksheet Line":
          ShowSourceLocalCFWorkSheetLine(FALSE,CFVariant);
        DATABASE::"Cash Flow Forecast Entry":
          ShowSourceLocalCFEntry(FALSE,CFVariant);
      END;
    END;

    LOCAL PROCEDURE ShowSourceLocalCFWorkSheetLine@36(ShowDocument@1001 : Boolean;CFVariant@1002 : Variant);
    VAR
      CashFlowWorksheetLine@1000 : Record 846;
    BEGIN
      CashFlowWorksheetLine := CFVariant;
      CashFlowWorksheetLine.TESTFIELD("Source Type");
      IF CashFlowWorksheetLine."Source Type" <> CashFlowWorksheetLine."Source Type"::Tax THEN
        CashFlowWorksheetLine.TESTFIELD("Source No.");
      IF CashFlowWorksheetLine."Source Type" = CashFlowWorksheetLine."Source Type"::"G/L Budget" THEN
        CashFlowWorksheetLine.TESTFIELD("G/L Budget Name");

      ShowSourceLocal(ShowDocument,
        CashFlowWorksheetLine."Source Type",
        CashFlowWorksheetLine."Source No.",
        CashFlowWorksheetLine."G/L Budget Name",
        CashFlowWorksheetLine."Document Date",
        CashFlowWorksheetLine."Document No.");
    END;

    LOCAL PROCEDURE ShowSourceLocalCFEntry@37(ShowDocument@1001 : Boolean;CFVariant@1002 : Variant);
    VAR
      CashFlowForecastEntry@1000 : Record 847;
    BEGIN
      CashFlowForecastEntry := CFVariant;
      CashFlowForecastEntry.TESTFIELD("Source Type");
      IF CashFlowForecastEntry."Source Type" <> CashFlowForecastEntry."Source Type"::Tax THEN
        CashFlowForecastEntry.TESTFIELD("Source No.");
      IF CashFlowForecastEntry."Source Type" = CashFlowForecastEntry."Source Type"::"G/L Budget" THEN
        CashFlowForecastEntry.TESTFIELD("G/L Budget Name");

      ShowSourceLocal(ShowDocument,
        CashFlowForecastEntry."Source Type",
        CashFlowForecastEntry."Source No.",
        CashFlowForecastEntry."G/L Budget Name",
        CashFlowForecastEntry."Document Date",
        CashFlowForecastEntry."Document No.");
    END;

    LOCAL PROCEDURE ShowSourceLocal@1(ShowDocument@1005 : Boolean;SourceType@1002 : Integer;SourceNo@1001 : Code[20];BudgetName@1000 : Code[10];DocumentDate@1003 : Date;DocumentNo@1004 : Code[20]);
    VAR
      CFWorksheetLine@1008 : Record 846;
    BEGIN
      CASE SourceType OF
        CFWorksheetLine."Source Type"::"Liquid Funds":
          ShowLiquidFunds(SourceNo,ShowDocument);
        CFWorksheetLine."Source Type"::Receivables:
          ShowCustomer(SourceNo,ShowDocument);
        CFWorksheetLine."Source Type"::Payables:
          ShowVendor(SourceNo,ShowDocument);
        CFWorksheetLine."Source Type"::"Sales Orders":
          ShowSO(SourceNo);
        CFWorksheetLine."Source Type"::"Purchase Orders":
          ShowPO(SourceNo);
        CFWorksheetLine."Source Type"::"Service Orders":
          ShowServO(SourceNo);
        CFWorksheetLine."Source Type"::"Cash Flow Manual Revenue":
          ShowManualRevenue(SourceNo);
        CFWorksheetLine."Source Type"::"Cash Flow Manual Expense":
          ShowManualExpense(SourceNo);
        CFWorksheetLine."Source Type"::"Fixed Assets Budget",
        CFWorksheetLine."Source Type"::"Fixed Assets Disposal":
          ShowFA(SourceNo);
        CFWorksheetLine."Source Type"::"G/L Budget":
          ShowGLBudget(BudgetName,SourceNo);
        CFWorksheetLine."Source Type"::Job:
          ShowJob(SourceNo,DocumentDate,DocumentNo);
        CFWorksheetLine."Source Type"::Tax:
          ShowTax(SourceNo,DocumentDate);
        CFWorksheetLine."Source Type"::"Cortana Intelligence":
          ShowCortanaIntelligenceForecast;
        ELSE
          ERROR(SourceTypeNotSupportedErr);
      END;
    END;

    LOCAL PROCEDURE ShowLiquidFunds@4(SourceNo@1000 : Code[20];ShowDocument@1001 : Boolean);
    VAR
      GLAccount@1007 : Record 15;
    BEGIN
      GLAccount.SETRANGE("No.",SourceNo);
      IF NOT GLAccount.FINDFIRST THEN
        ERROR(SourceDataDoesNotExistErr,GLAccount.TABLECAPTION,SourceNo);
      IF ShowDocument THEN
        PAGE.RUN(PAGE::"G/L Account Card",GLAccount)
      ELSE
        PAGE.RUN(PAGE::"Chart of Accounts",GLAccount);
    END;

    LOCAL PROCEDURE ShowCustomer@5(SourceNo@1000 : Code[20];ShowDocument@1001 : Boolean);
    VAR
      CustLedgEntry@1012 : Record 21;
    BEGIN
      CustLedgEntry.SETRANGE("Document No.",SourceNo);
      IF NOT CustLedgEntry.FINDFIRST THEN
        ERROR(SourceDataDoesNotExistInfoErr,CustLedgEntry.TABLECAPTION,CustLedgEntry.FIELDCAPTION("Document No."),SourceNo);
      IF ShowDocument THEN
        CustLedgEntry.ShowDoc
      ELSE
        PAGE.RUN(0,CustLedgEntry);
    END;

    LOCAL PROCEDURE ShowVendor@6(SourceNo@1000 : Code[20];ShowDocument@1001 : Boolean);
    VAR
      VendLedgEntry@1011 : Record 25;
    BEGIN
      VendLedgEntry.SETRANGE("Document No.",SourceNo);
      IF NOT VendLedgEntry.FINDFIRST THEN
        ERROR(SourceDataDoesNotExistInfoErr,VendLedgEntry.TABLECAPTION,VendLedgEntry.FIELDCAPTION("Document No."),SourceNo);
      IF ShowDocument THEN
        VendLedgEntry.ShowDoc
      ELSE
        PAGE.RUN(0,VendLedgEntry);
    END;

    LOCAL PROCEDURE ShowSO@7(SourceNo@1000 : Code[20]);
    VAR
      SalesHeader@1010 : Record 36;
      SalesOrder@1005 : Page 42;
    BEGIN
      SalesHeader.SETRANGE("Document Type",SalesHeader."Document Type"::Order);
      SalesHeader.SETRANGE("No.",SourceNo);
      IF NOT SalesHeader.FINDFIRST THEN
        ERROR(SourceDataDoesNotExistErr,SalesOrder.CAPTION,SourceNo);
      SalesOrder.SETTABLEVIEW(SalesHeader);
      SalesOrder.RUN;
    END;

    LOCAL PROCEDURE ShowPO@8(SourceNo@1000 : Code[20]);
    VAR
      PurchaseHeader@1009 : Record 38;
      PurchaseOrder@1004 : Page 50;
    BEGIN
      PurchaseHeader.SETRANGE("Document Type",PurchaseHeader."Document Type"::Order);
      PurchaseHeader.SETRANGE("No.",SourceNo);
      IF NOT PurchaseHeader.FINDFIRST THEN
        ERROR(SourceDataDoesNotExistErr,PurchaseOrder.CAPTION,SourceNo);
      PurchaseOrder.SETTABLEVIEW(PurchaseHeader);
      PurchaseOrder.RUN;
    END;

    LOCAL PROCEDURE ShowServO@9(SourceNo@1000 : Code[20]);
    VAR
      ServiceHeader@1008 : Record 5900;
      ServiceOrder@1003 : Page 5900;
    BEGIN
      ServiceHeader.SETRANGE("Document Type",ServiceHeader."Document Type"::Order);
      ServiceHeader.SETRANGE("No.",SourceNo);
      IF NOT ServiceHeader.FINDFIRST THEN
        ERROR(SourceDataDoesNotExistErr,ServiceOrder.CAPTION,SourceNo);
      ServiceOrder.SETTABLEVIEW(ServiceHeader);
      ServiceOrder.RUN;
    END;

    LOCAL PROCEDURE ShowManualRevenue@10(SourceNo@1000 : Code[20]);
    VAR
      CFManualRevenue@1006 : Record 849;
      CFManualRevenues@1001 : Page 857;
    BEGIN
      CFManualRevenue.SETRANGE(Code,SourceNo);
      IF NOT CFManualRevenue.FINDFIRST THEN
        ERROR(SourceDataDoesNotExistErr,CFManualRevenues.CAPTION,SourceNo);
      CFManualRevenues.SETTABLEVIEW(CFManualRevenue);
      CFManualRevenues.RUN;
    END;

    LOCAL PROCEDURE ShowManualExpense@11(SourceNo@1000 : Code[20]);
    VAR
      CFManualExpense@1006 : Record 850;
      CFManualExpenses@1001 : Page 859;
    BEGIN
      CFManualExpense.SETRANGE(Code,SourceNo);
      IF NOT CFManualExpense.FINDFIRST THEN
        ERROR(SourceDataDoesNotExistErr,CFManualExpenses.CAPTION,SourceNo);
      CFManualExpenses.SETTABLEVIEW(CFManualExpense);
      CFManualExpenses.RUN;
    END;

    LOCAL PROCEDURE ShowFA@2(SourceNo@1000 : Code[20]);
    VAR
      FixedAsset@1006 : Record 5600;
    BEGIN
      FixedAsset.SETRANGE("No.",SourceNo);
      IF NOT FixedAsset.FINDFIRST THEN
        ERROR(SourceDataDoesNotExistInfoErr,FixedAsset.TABLECAPTION,FixedAsset.FIELDCAPTION("No."),SourceNo);
      PAGE.RUN(PAGE::"Fixed Asset Card",FixedAsset);
    END;

    LOCAL PROCEDURE ShowGLBudget@3(BudgetName@1000 : Code[10];SourceNo@1001 : Code[20]);
    VAR
      GLBudgetName@1003 : Record 95;
      GLAccount@1004 : Record 15;
      Budget@1002 : Page 113;
    BEGIN
      IF NOT GLAccount.GET(SourceNo) THEN
        ERROR(SourceDataDoesNotExistErr,GLAccount.TABLECAPTION,SourceNo);
      IF NOT GLBudgetName.GET(BudgetName) THEN
        ERROR(SourceDataDoesNotExistErr,GLBudgetName.TABLECAPTION,BudgetName);
      Budget.SetBudgetName(BudgetName);
      Budget.SetGLAccountFilter(SourceNo);
      Budget.RUN;
    END;

    LOCAL PROCEDURE ShowCortanaIntelligenceForecast@41();
    BEGIN
    END;

    [External]
    PROCEDURE CashFlowName@12(CashFlowNo@1001 : Code[20]) : Text[50];
    VAR
      CashFlowForecast@1000 : Record 840;
    BEGIN
      IF CashFlowForecast.GET(CashFlowNo) THEN
        EXIT(CashFlowForecast.Description);
      EXIT('')
    END;

    [External]
    PROCEDURE CashFlowAccountName@13(CashFlowAccountNo@1000 : Code[20]) : Text[50];
    VAR
      CashFlowAccount@1001 : Record 841;
    BEGIN
      IF CashFlowAccount.GET(CashFlowAccountNo) THEN
        EXIT(CashFlowAccount.Name);
      EXIT('')
    END;

    LOCAL PROCEDURE ShowJob@20(SourceNo@1000 : Code[20];DocumentDate@1001 : Date;DocumentNo@1002 : Code[20]);
    VAR
      JobPlanningLine@1010 : Record 1003;
      JobPlanningLines@1005 : Page 1007;
    BEGIN
      JobPlanningLine.SETRANGE("Job No.",SourceNo);
      JobPlanningLine.SETRANGE("Document Date",DocumentDate);
      JobPlanningLine.SETRANGE("Document No.",DocumentNo);
      JobPlanningLine.SETFILTER("Line Type",
        STRSUBSTNO('%1|%2',
          JobPlanningLine."Line Type"::Billable,
          JobPlanningLine."Line Type"::"Both Budget and Billable"));
      IF NOT JobPlanningLine.FINDFIRST THEN
        ERROR(SourceDataDoesNotExistErr,JobPlanningLines.CAPTION,SourceNo);
      JobPlanningLines.SETTABLEVIEW(JobPlanningLine);
      JobPlanningLines.RUN;
    END;

    LOCAL PROCEDURE ShowTax@27(SourceNo@1007 : Code[20];TaxPayableDate@1000 : Date);
    VAR
      PurchaseHeader@1002 : Record 38;
      SalesHeader@1003 : Record 36;
      VATEntry@1004 : Record 254;
      SalesOrderList@1001 : Page 9305;
      PurchaseOrderList@1005 : Page 9307;
      SourceNum@1008 : Integer;
    BEGIN
      EVALUATE(SourceNum,SourceNo);
      CASE SourceNum OF
        DATABASE::"Purchase Header":
          BEGIN
            SetViewOnPurchaseHeaderForTaxCalc(PurchaseHeader,TaxPayableDate);
            PurchaseOrderList.SkipShowingLinesWithoutVAT;
            PurchaseOrderList.SETTABLEVIEW(PurchaseHeader);
            PurchaseOrderList.RUN;
          END;
        DATABASE::"Sales Header":
          BEGIN
            SetViewOnSalesHeaderForTaxCalc(SalesHeader,TaxPayableDate);
            SalesOrderList.SkipShowingLinesWithoutVAT;
            SalesOrderList.SETTABLEVIEW(SalesHeader);
            SalesOrderList.RUN;
          END;
        DATABASE::"VAT Entry":
          BEGIN
            SetViewOnVATEntryForTaxCalc(VATEntry,TaxPayableDate);
            PAGE.RUN(PAGE::"VAT Entries",VATEntry);
          END;
      END;
    END;

    [External]
    PROCEDURE RecurrenceToRecurringFrequency@21(Recurrence@1000 : ' ,Daily,Weekly,Monthly,Quarterly,Yearly') RecurringFrequency : Text;
    BEGIN
      CASE Recurrence OF
        Recurrence::Daily:
          RecurringFrequency := '<1D>';
        Recurrence::Weekly:
          RecurringFrequency := '<1W>';
        Recurrence::Monthly:
          RecurringFrequency := '<1M>';
        Recurrence::Quarterly:
          RecurringFrequency := '<1Q>';
        Recurrence::Yearly:
          RecurringFrequency := '<1Y>';
        ELSE
          RecurringFrequency := '';
      END;
    END;

    [External]
    PROCEDURE RecurringFrequencyToRecurrence@23(RecurringFrequency@1000 : DateFormula;VAR RecurrenceOut@1001 : ' ,Daily,Weekly,Monthly,Quarterly,Yearly');
    VAR
      Daily@1002 : DateFormula;
      Weekly@1003 : DateFormula;
      Monthly@1004 : DateFormula;
      Quarterly@1006 : DateFormula;
      Yearly@1005 : DateFormula;
    BEGIN
      EVALUATE(Daily,'<1D>');
      EVALUATE(Weekly,'<1W>');
      EVALUATE(Monthly,'<1M>');
      EVALUATE(Quarterly,'<1Q>');
      EVALUATE(Yearly,'<1Y>');

      CASE RecurringFrequency OF
        Daily:
          RecurrenceOut := RecurrenceOut::Daily;
        Weekly:
          RecurrenceOut := RecurrenceOut::Weekly;
        Monthly:
          RecurrenceOut := RecurrenceOut::Monthly;
        Quarterly:
          RecurrenceOut := RecurrenceOut::Quarterly;
        Yearly:
          RecurrenceOut := RecurrenceOut::Yearly;
        ELSE
          RecurrenceOut := RecurrenceOut::" ";
      END;
    END;

    [External]
    PROCEDURE CreateAndStartJobQueueEntry@35(UpdateFrequency@1002 : 'Never,Daily,Weekly');
    VAR
      JobQueueEntry@1000 : Record 472;
      JobQueueManagement@1003 : Codeunit 456;
    BEGIN
      // Create a new job queue entry for Cash Flow Forecast
      JobQueueEntry."No. of Minutes between Runs" := UpdateFrequencyToNoOfMinutes(UpdateFrequency);
      JobQueueEntry."Object Type to Run" := JobQueueEntry."Object Type to Run"::Codeunit;
      JobQueueEntry."Object ID to Run" := CODEUNIT::"Cash Flow Forecast Update";
      JobQueueManagement.CreateJobQueueEntry(JobQueueEntry);

      // Start it
      CODEUNIT.RUN(CODEUNIT::"Job Queue - Enqueue",JobQueueEntry);
    END;

    [External]
    PROCEDURE DeleteJobQueueEntries@22();
    VAR
      JobQueueEntry@1011 : Record 472;
      JobQueueManagement@1010 : Codeunit 456;
    BEGIN
      JobQueueManagement.DeleteJobQueueEntries(JobQueueEntry."Object Type to Run"::Codeunit,CODEUNIT::"Cash Flow Forecast Update");
    END;

    [Internal]
    PROCEDURE GetCashAccountFilter@19() CashAccountFilter : Text;
    VAR
      GLAccountCategory@1000 : Record 570;
    BEGIN
      GLAccountCategory.SETRANGE("Additional Report Definition",GLAccountCategory."Additional Report Definition"::"Cash Accounts");
      IF NOT GLAccountCategory.FINDSET THEN
        EXIT;

      CashAccountFilter := GLAccountCategory.GetTotaling;

      WHILE GLAccountCategory.NEXT <> 0 DO
        CashAccountFilter += '|' + GLAccountCategory.GetTotaling;
    END;

    [External]
    PROCEDURE SetupCashFlow@14(LiquidFundsGLAccountFilter@1000 : Code[250]);
    VAR
      CashFlowNoSeriesCode@1001 : Code[20];
    BEGIN
      DeleteExistingSetup;
      CreateCashFlowAccounts(LiquidFundsGLAccountFilter);
      CashFlowNoSeriesCode := CreateCashFlowNoSeries;
      CreateCashFlowSetup(CashFlowNoSeriesCode);
      CreateCashFlowForecast;
      CreateCashFlowChartSetup;
      CreateCashFlowReportSelection;
    END;

    LOCAL PROCEDURE DeleteExistingSetup@18();
    VAR
      CashFlowForecast@1000 : Record 840;
      CashFlowAccount@1001 : Record 841;
      CashFlowAccountComment@1004 : Record 842;
      CashFlowSetup@1002 : Record 843;
      CashFlowWorksheetLine@1003 : Record 846;
      CashFlowForecastEntry@1005 : Record 847;
      CashFlowManualRevenue@1006 : Record 849;
      CashFlowManualExpense@1007 : Record 850;
      CashFlowReportSelection@1008 : Record 856;
      CashFlowChartSetup@1009 : Record 869;
      JobQueueEntry@1011 : Record 472;
      JobQueueManagement@1010 : Codeunit 456;
    BEGIN
      CashFlowForecast.DELETEALL;
      CashFlowAccount.DELETEALL;
      CashFlowAccountComment.DELETEALL;
      CashFlowSetup.DELETEALL;
      CashFlowWorksheetLine.DELETEALL;
      CashFlowForecastEntry.DELETEALL;
      CashFlowManualRevenue.DELETEALL;
      CashFlowManualExpense.DELETEALL;
      CashFlowReportSelection.DELETEALL;
      CashFlowChartSetup.DELETEALL;
      JobQueueManagement.DeleteJobQueueEntries(JobQueueEntry."Object Type to Run"::Codeunit,CODEUNIT::"Cash Flow Forecast Update");
    END;

    LOCAL PROCEDURE CreateCashFlowAccounts@15(LiquidFundsGLAccountFilter@1001 : Code[250]);
    VAR
      CashFlowAccount@1000 : Record 841;
    BEGIN
      CreateCashFlowAccount(CashFlowAccount."Source Type"::Receivables,'');
      CreateCashFlowAccount(CashFlowAccount."Source Type"::Payables,'');
      CreateCashFlowAccount(CashFlowAccount."Source Type"::"Sales Orders",'');
      CreateCashFlowAccount(CashFlowAccount."Source Type"::"Service Orders",'');
      CreateCashFlowAccount(CashFlowAccount."Source Type"::"Purchase Orders",'');
      CreateCashFlowAccount(CashFlowAccount."Source Type"::"Fixed Assets Budget",'');
      CreateCashFlowAccount(CashFlowAccount."Source Type"::"Fixed Assets Disposal",'');
      CreateCashFlowAccount(CashFlowAccount."Source Type"::"Liquid Funds",LiquidFundsGLAccountFilter);
      CreateCashFlowAccount(CashFlowAccount."Source Type"::Job,'');
      CreateCashFlowAccount(CashFlowAccount."Source Type"::"Cash Flow Manual Expense",'');
      CreateCashFlowAccount(CashFlowAccount."Source Type"::"Cash Flow Manual Revenue",'');
      CreateCashFlowAccount(CashFlowAccount."Source Type"::Tax,'');
    END;

    LOCAL PROCEDURE CreateCashFlowAccount@28(SourceType@1000 : Option;LiquidFundsGLAccountFilter@1003 : Code[250]);
    VAR
      CashFlowAccount@1001 : Record 841;
      DummyCashFlowAccount@1002 : Record 841;
    BEGIN
      DummyCashFlowAccount."Source Type" := SourceType;

      CashFlowAccount.INIT;
      CashFlowAccount.VALIDATE("No.",FORMAT(DummyCashFlowAccount."Source Type",20));
      CashFlowAccount.VALIDATE(Name,FORMAT(DummyCashFlowAccount."Source Type"));
      CashFlowAccount.VALIDATE("Source Type",DummyCashFlowAccount."Source Type");
      IF SourceType = DummyCashFlowAccount."Source Type"::"Liquid Funds" THEN BEGIN
        CashFlowAccount."G/L Integration" := CashFlowAccount."G/L Integration"::Balance;
        CashFlowAccount."G/L Account Filter" := LiquidFundsGLAccountFilter;
      END;
      CashFlowAccount.INSERT;
    END;

    LOCAL PROCEDURE CreateCashFlowForecast@16();
    VAR
      CashFlowForecast@1000 : Record 840;
    BEGIN
      CashFlowForecast.INIT;
      CashFlowForecast.VALIDATE("No.",DefaultTxt);
      CashFlowForecast.VALIDATE(Description,DefaultTxt);
      CashFlowForecast.ValidateShowInChart(TRUE);
      CashFlowForecast."Overdue CF Dates to Work Date" := TRUE;
      CashFlowForecast.INSERT;
    END;

    LOCAL PROCEDURE CreateCashFlowNoSeries@40() : Code[20];
    VAR
      NoSeries@1009 : Record 308;
      NoSeriesLine@1010 : Record 309;
    BEGIN
      IF NoSeries.GET(CashFlowTxt) THEN
        EXIT(NoSeries.Code);

      NoSeries.INIT;
      NoSeries.Code := CashFlowTxt;
      NoSeries.Description := CashFlowForecastTxt;
      NoSeries."Default Nos." := TRUE;
      NoSeries."Manual Nos." := TRUE;
      NoSeries.INSERT;

      NoSeriesLine.INIT;
      NoSeriesLine."Series Code" := NoSeries.Code;
      NoSeriesLine."Line No." := 10000;
      NoSeriesLine.VALIDATE("Starting No.",CashFlowAbbreviationTxt + '000001');
      NoSeriesLine.INSERT(TRUE);

      EXIT(NoSeries.Code);
    END;

    LOCAL PROCEDURE CreateCashFlowSetup@17(CashFlowNoSeriesCode@1002 : Code[20]);
    VAR
      CashFlowSetup@1000 : Record 843;
      CashFlowAccount@1005 : Record 841;
    BEGIN
      CashFlowSetup.INIT;
      CashFlowSetup.VALIDATE("Cash Flow Forecast No. Series",CashFlowNoSeriesCode);
      CashFlowSetup.VALIDATE("Receivables CF Account No.",FORMAT(CashFlowAccount."Source Type"::Receivables,20));
      CashFlowSetup.VALIDATE("Payables CF Account No.",FORMAT(CashFlowAccount."Source Type"::Payables,20));
      CashFlowSetup.VALIDATE("Sales Order CF Account No.",FORMAT(CashFlowAccount."Source Type"::"Sales Orders",20));
      CashFlowSetup.VALIDATE("Service CF Account No.",FORMAT(CashFlowAccount."Source Type"::"Service Orders",20));
      CashFlowSetup.VALIDATE("Purch. Order CF Account No.",FORMAT(CashFlowAccount."Source Type"::"Purchase Orders",20));
      CashFlowSetup.VALIDATE("FA Budget CF Account No.",FORMAT(CashFlowAccount."Source Type"::"Fixed Assets Budget",20));
      CashFlowSetup.VALIDATE("FA Disposal CF Account No.",FORMAT(CashFlowAccount."Source Type"::"Fixed Assets Disposal",20));
      CashFlowSetup.VALIDATE("Job CF Account No.",FORMAT(CashFlowAccount."Source Type"::Job,20));
      CashFlowSetup.VALIDATE("Tax CF Account No.",FORMAT(CashFlowAccount."Source Type"::Tax,20));
      CashFlowSetup.INSERT;
    END;

    LOCAL PROCEDURE CreateCashFlowChartSetup@24();
    VAR
      User@1001 : Record 2000000120;
    BEGIN
      IF NOT User.FINDSET THEN
        CreateCashFlowChartSetupForUser(USERID)
      ELSE
        REPEAT
          CreateCashFlowChartSetupForUser(User."User Name");
        UNTIL User.NEXT = 0;
    END;

    LOCAL PROCEDURE CreateCashFlowChartSetupForUser@33(UserName@1000 : Code[50]);
    VAR
      CashFlowChartSetup@1001 : Record 869;
    BEGIN
      CashFlowChartSetup.INIT;
      CashFlowChartSetup."User ID" := UserName;
      CashFlowChartSetup.Show := CashFlowChartSetup.Show::Combined;
      CashFlowChartSetup."Start Date" := CashFlowChartSetup."Start Date"::"Working Date";
      CashFlowChartSetup."Period Length" := CashFlowChartSetup."Period Length"::Month;
      CashFlowChartSetup."Group By" := CashFlowChartSetup."Group By"::"Source Type";
      CashFlowChartSetup.INSERT;
    END;

    LOCAL PROCEDURE CreateCashFlowReportSelection@51();
    VAR
      CashFlowReportSelection@1000 : Record 856;
    BEGIN
      CashFlowReportSelection.NewRecord;
      CashFlowReportSelection.VALIDATE("Report ID",846);
      CashFlowReportSelection.INSERT;
    END;

    [External]
    PROCEDURE UpdateCashFlowForecast@50(CortanaIntelligenceEnabled@1006 : Boolean);
    VAR
      CashFlowForecast@1003 : Record 840;
      CashFlowSetup@1004 : Record 843;
      SuggestWorksheetLines@1000 : Report 840;
      Window@1005 : Dialog;
      Sources@1001 : ARRAY [16] OF Boolean;
      Index@1002 : Integer;
      SourceType@1007 : ',Receivables,Payables,Liquid Funds,Cash Flow Manual Expense,Cash Flow Manual Revenue,Sales Order,Purchase Order,Budgeted Fixed Asset,Sale of Fixed Asset,Service Orders,G/L Budget,,,Job,Tax,Cortana Intelligence';
    BEGIN
      Window.OPEN(UpdatingMsg);

      IF NOT CashFlowSetup.GET THEN
        EXIT;

      IF NOT CashFlowForecast.GET(CashFlowSetup."CF No. on Chart in Role Center") THEN
        EXIT;

      UpdateCashFlowForecastManualPaymentHorizon(CashFlowForecast);

      FOR Index := 1 TO ARRAYLEN(Sources) DO
        Sources[Index] := TRUE;

      Sources[SourceType::"Cortana Intelligence"] := CortanaIntelligenceEnabled;
      SuggestWorksheetLines.InitializeRequest(
        Sources,CashFlowSetup."CF No. on Chart in Role Center",CashFlowForecast."Default G/L Budget Name",TRUE);
      SuggestWorksheetLines.USEREQUESTPAGE := FALSE;
      SuggestWorksheetLines.RUN;
      CODEUNIT.RUN(CODEUNIT::"Cash Flow Wksh.-Register Batch");

      Window.CLOSE;
    END;

    LOCAL PROCEDURE UpdateCashFlowForecastManualPaymentHorizon@25(VAR CashFlowForecast@1001 : Record 840);
    BEGIN
      CashFlowForecast.VALIDATE("Manual Payments From",WORKDATE);
      CashFlowForecast.VALIDATE("Manual Payments To",CALCDATE('<+1Y>',WORKDATE));
      CashFlowForecast.MODIFY;
    END;

    LOCAL PROCEDURE UpdateFrequencyToNoOfMinutes@46(UpdateFrequency@1000 : 'Never,Daily,Weekly') : Integer;
    BEGIN
      CASE UpdateFrequency OF
        UpdateFrequency::Never:
          EXIT(0);
        UpdateFrequency::Daily:
          EXIT(60 * 24);
        UpdateFrequency::Weekly:
          EXIT(60 * 24 * 7);
      END;
    END;

    [External]
    PROCEDURE SetViewOnPurchaseHeaderForTaxCalc@34(VAR PurchaseHeader@1000 : Record 38;TaxPaymentDueDate@1001 : Date);
    VAR
      CashFlowSetup@1002 : Record 843;
      StartDate@1004 : Date;
      EndDate@1003 : Date;
    BEGIN
      PurchaseHeader.SETRANGE("Document Type",PurchaseHeader."Document Type"::Order);
      PurchaseHeader.SETFILTER("Document Date",'<>%1',DummyDate);
      IF TaxPaymentDueDate <> DummyDate THEN BEGIN
        CashFlowSetup.GetTaxPeriodStartEndDates(TaxPaymentDueDate,StartDate,EndDate);
        PurchaseHeader.SETFILTER("Document Date",STRSUBSTNO('%1..%2',StartDate,EndDate));
      END;
      PurchaseHeader.SETCURRENTKEY("Document Date");
      PurchaseHeader.SETASCENDING("Document Date",TRUE);
    END;

    [External]
    PROCEDURE SetViewOnSalesHeaderForTaxCalc@38(VAR SalesHeader@1000 : Record 36;TaxPaymentDueDate@1001 : Date);
    VAR
      CashFlowSetup@1002 : Record 843;
      StartDate@1004 : Date;
      EndDate@1003 : Date;
    BEGIN
      SalesHeader.SETRANGE("Document Type",SalesHeader."Document Type"::Order);
      SalesHeader.SETFILTER("Document Date",'<>%1',DummyDate);
      IF TaxPaymentDueDate <> DummyDate THEN BEGIN
        CashFlowSetup.GetTaxPeriodStartEndDates(TaxPaymentDueDate,StartDate,EndDate);
        SalesHeader.SETFILTER("Document Date",STRSUBSTNO('%1..%2',StartDate,EndDate));
      END;
      SalesHeader.SETCURRENTKEY("Document Date");
      SalesHeader.SETASCENDING("Document Date",TRUE);
    END;

    [External]
    PROCEDURE SetViewOnVATEntryForTaxCalc@39(VAR VATEntry@1000 : Record 254;TaxPaymentDueDate@1001 : Date);
    VAR
      CashFlowSetup@1003 : Record 843;
      StartDate@1002 : Date;
      EndDate@1004 : Date;
    BEGIN
      VATEntry.SETFILTER(Type,STRSUBSTNO('%1|%2',VATEntry.Type::Purchase,VATEntry.Type::Sale));
      VATEntry.SETFILTER("VAT Calculation Type",STRSUBSTNO('<>%1',VATEntry."VAT Calculation Type"::"Reverse Charge VAT"));
      VATEntry.SETRANGE(Closed,FALSE);
      VATEntry.SETFILTER(Amount,'<>%1',0);
      VATEntry.SETFILTER("Document Date",'<>%1',DummyDate);
      IF TaxPaymentDueDate <> DummyDate THEN BEGIN
        CashFlowSetup.GetTaxPeriodStartEndDates(TaxPaymentDueDate,StartDate,EndDate);
        VATEntry.SETFILTER("Document Date",STRSUBSTNO('%1..%2',StartDate,EndDate));
      END;
      VATEntry.SETCURRENTKEY("Document Date");
      VATEntry.SETASCENDING("Document Date",TRUE);
    END;

    [Internal]
    PROCEDURE GetTaxAmountFromSalesOrder@29(SalesHeader@1000 : Record 36) : Decimal;
    VAR
      NewSalesLine@1009 : Record 37;
      NewSalesLineLCY@1008 : Record 37;
      SalesPost@1001 : Codeunit 80;
      QtyType@1007 : 'General,Invoicing,Shipping';
      VATAmount@1006 : Decimal;
      VATAmountText@1005 : Text[30];
      ProfitLCY@1004 : Decimal;
      ProfitPct@1003 : Decimal;
      TotalAdjCostLCY@1002 : Decimal;
    BEGIN
      SalesPost.SumSalesLines(SalesHeader,QtyType::Invoicing,NewSalesLine,NewSalesLineLCY,
        VATAmount,VATAmountText,ProfitLCY,ProfitPct,TotalAdjCostLCY);
      EXIT(-1 * VATAmount);
    END;

    [Internal]
    PROCEDURE GetTaxAmountFromPurchaseOrder@30(PurchaseHeader@1000 : Record 38) : Decimal;
    VAR
      NewPurchLine@1006 : Record 39;
      NewPurchLineLCY@1005 : Record 39;
      PurchPost@1004 : Codeunit 90;
      QtyType@1003 : 'General,Invoicing,Shipping';
      VATAmount@1002 : Decimal;
      VATAmountText@1001 : Text[30];
    BEGIN
      PurchPost.SumPurchLines(PurchaseHeader,QtyType::Invoicing,NewPurchLine,NewPurchLineLCY,
        VATAmount,VATAmountText);
      EXIT(VATAmount);
    END;

    [External]
    PROCEDURE GetTotalAmountFromSalesOrder@43(SalesHeader@1000 : Record 36) : Decimal;
    BEGIN
      SalesHeader.CALCFIELDS("Amount Including VAT");
      EXIT(SalesHeader."Amount Including VAT");
    END;

    [External]
    PROCEDURE GetTotalAmountFromPurchaseOrder@42(PurchaseHeader@1000 : Record 38) : Decimal;
    BEGIN
      PurchaseHeader.CALCFIELDS("Amount Including VAT");
      EXIT(PurchaseHeader."Amount Including VAT");
    END;

    BEGIN
    END.
  }
}

