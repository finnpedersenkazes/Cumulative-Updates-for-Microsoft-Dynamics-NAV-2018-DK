OBJECT Page 866 Cash Flow Availability Lines
{
  OBJECT-PROPERTIES
  {
    Date=28-06-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23019;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Linjer;
               ENU=Lines];
    SourceTable=Table2000000007;
    PageType=ListPart;
    OnOpenPage=BEGIN
                 RESET;
               END;

    OnFindRecord=BEGIN
                   EXIT(PeriodFormManagement.FindDate(Which,Rec,PeriodType));
                 END;

    OnNextRecord=BEGIN
                   EXIT(PeriodFormManagement.NextDate(Steps,Rec,PeriodType));
                 END;

    OnAfterGetRecord=VAR
                       SourceType@1002 : Option;
                     BEGIN
                       CASE AmountType OF
                         AmountType::"Net Change":
                           CashFlowForecast.CalculateAllAmounts("Period Start","Period End",Amounts,CashFlowSum);
                         AmountType::"Balance at Date":
                           CashFlowForecast.CalculateAllAmounts(0D,"Period End",Amounts,CashFlowSum)
                       END;

                       FOR SourceType := 1 TO ARRAYLEN(Amounts) DO
                         Amounts[SourceType] := MatrixMgt.RoundValue(Amounts[SourceType],RoundingFactor);

                       CashFlowSum := MatrixMgt.RoundValue(CashFlowSum,RoundingFactor);
                     END;

    OnAfterGetCurrRecord=BEGIN
                           CashFlowForecast.SetCashFlowDateFilter("Period Start","Period End");
                         END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1000;1   ;Group     ;
                Editable=FALSE;
                GroupType=Repeater }

    { 1001;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor perioden starter, f.eks. den f›rste dag i marts, hvis perioden er M†ned.;
                           ENU=Specifies on which date the period starts, such as the first day of March, if the period is Month.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Period Start" }

    { 1003;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† regnskabsperioden. Det er en god ide at bruge beskrivende navne, f.eks. M†ned01, 1. m†ned, 1. m†ned/2000, M†ned01-2000, M1-2001/2002 osv.;
                           ENU=Specifies the name of the accounting period. it is a good idea to use descriptive names, such as Month01, 1st Month, 1st Month/2000, Month01-2000, M1-2001/2002, etc.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Period Name" }

    { 1005;2   ;Field     ;
                Name=Receivables;
                CaptionML=[DAN=Tilgodehavender;
                           ENU=Receivables];
                ToolTipML=[DAN=Angiver bel›b vedr›rende tilgodehavender.;
                           ENU=Specifies amounts related to receivables.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Amounts[CFForecastEntry."Source Type"::Receivables];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                OnDrillDown=BEGIN
                              CashFlowForecast.DrillDownEntriesFromSource(CashFlowForecast."Source Type Filter"::Receivables);
                            END;
                             }

    { 1007;2   ;Field     ;
                Name=SalesOrders;
                CaptionML=[DAN=Salgsordrer;
                           ENU=Sales Orders];
                ToolTipML=[DAN=Angiver bel›b vedr›rende salgsordrer.;
                           ENU=Specifies amounts related to sales orders.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Amounts[CFForecastEntry."Source Type"::"Sales Order"];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                OnDrillDown=BEGIN
                              CashFlowForecast.DrillDownEntriesFromSource(CashFlowForecast."Source Type Filter"::"Sales Order");
                            END;
                             }

    { 1   ;2   ;Field     ;
                Name=ServiceOrders;
                CaptionML=[DAN=Serviceordrer;
                           ENU=Service Orders];
                ToolTipML=[DAN=Angiver bel›b vedr›rende serviceordrer.;
                           ENU=Specifies amounts related to service orders.];
                ApplicationArea=#Service;
                SourceExpr=Amounts[CFForecastEntry."Source Type"::"Service Orders"];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                OnDrillDown=BEGIN
                              CashFlowForecast.DrillDownEntriesFromSource(CashFlowForecast."Source Type Filter"::"Service Orders");
                            END;
                             }

    { 1009;2   ;Field     ;
                Name=SalesofFixedAssets;
                CaptionML=[DAN=Afh‘ndelse af faste anl‘gsaktiver;
                           ENU=Fixed Assets Disposal];
                ToolTipML=[DAN=Angiver bel›b vedr›rende afh‘ndelse af faste anl‘gsaktiver.;
                           ENU=Specifies amounts related to fixed assets disposal.];
                ApplicationArea=#Advanced;
                SourceExpr=Amounts[CFForecastEntry."Source Type"::"Fixed Assets Disposal"];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                OnDrillDown=BEGIN
                              CashFlowForecast.DrillDownEntriesFromSource(CashFlowForecast."Source Type Filter"::"Fixed Assets Disposal");
                            END;
                             }

    { 1011;2   ;Field     ;
                Name=ManualRevenues;
                CaptionML=[DAN=Cash Flow Manual Revenues;
                           ENU=Cash Flow Manual Revenues];
                ToolTipML=[DAN=Specifies amounts related to manual revenues.;
                           ENU=Specifies amounts related to manual revenues.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Amounts[CFForecastEntry."Source Type"::"Cash Flow Manual Revenue"];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                OnDrillDown=BEGIN
                              CashFlowForecast.DrillDownEntriesFromSource(CashFlowForecast."Source Type Filter"::"Cash Flow Manual Revenue");
                            END;
                             }

    { 1013;2   ;Field     ;
                Name=Payables;
                CaptionML=[DAN=G‘ld;
                           ENU=Payables];
                ToolTipML=[DAN=Angiver bel›b vedr›rende skyldige bel›b.;
                           ENU=Specifies amounts related to payables.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Amounts[CFForecastEntry."Source Type"::Payables];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                OnDrillDown=BEGIN
                              CashFlowForecast.DrillDownEntriesFromSource(CashFlowForecast."Source Type Filter"::Payables);
                            END;
                             }

    { 1015;2   ;Field     ;
                Name=PurchaseOrders;
                CaptionML=[DAN=K›bsordrer;
                           ENU=Purchase Orders];
                ToolTipML=[DAN=Angiver bel›b vedr›rende k›bsordrer.;
                           ENU=Specifies amounts related to purchase orders.];
                ApplicationArea=#Advanced;
                SourceExpr=Amounts[CFForecastEntry."Source Type"::"Purchase Order"];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                OnDrillDown=BEGIN
                              CashFlowForecast.DrillDownEntriesFromSource(CashFlowForecast."Source Type Filter"::"Purchase Order");
                            END;
                             }

    { 1017;2   ;Field     ;
                Name=BudgetedFixedAssets;
                CaptionML=[DAN=Anl‘gsbudget;
                           ENU=Fixed Assets Budget];
                ToolTipML=[DAN=Angiver bel›b vedr›rende anl‘g.;
                           ENU=Specifies amounts related to fixed assets.];
                ApplicationArea=#Advanced;
                SourceExpr=Amounts[CFForecastEntry."Source Type"::"Fixed Assets Budget"];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                OnDrillDown=BEGIN
                              CashFlowForecast.DrillDownEntriesFromSource(CashFlowForecast."Source Type Filter"::"Fixed Assets Budget");
                            END;
                             }

    { 1019;2   ;Field     ;
                Name=ManualExpenses;
                CaptionML=[DAN=Manuelle pengestr›msudgifter;
                           ENU=Cash Flow Manual Expenses];
                ToolTipML=[DAN=Angiver bel›b vedr›rende manuelle udgifter.;
                           ENU=Specifies amounts related to manual expenses.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Amounts[CFForecastEntry."Source Type"::"Cash Flow Manual Expense"];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                OnDrillDown=BEGIN
                              CashFlowForecast.DrillDownEntriesFromSource(CashFlowForecast."Source Type Filter"::"Cash Flow Manual Expense");
                            END;
                             }

    { 3   ;2   ;Field     ;
                Name=Budget;
                CaptionML=[DAN=Fin.budget;
                           ENU=G/L Budget];
                ToolTipML=[DAN=Angiver bel›b vedr›rende finansbudgettet.;
                           ENU=Specifies amounts related to the general ledger budget.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Amounts[CFForecastEntry."Source Type"::"G/L Budget"];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                OnDrillDown=BEGIN
                              CashFlowForecast.DrillDownEntriesFromSource(CashFlowForecast."Source Type Filter"::"G/L Budget");
                            END;
                             }

    { 2   ;2   ;Field     ;
                Name=Job;
                CaptionML=[DAN=Sag;
                           ENU=Job];
                ToolTipML=[DAN=Angiver bel›b vedr›rende sager.;
                           ENU=Specifies amounts related to jobs.];
                ApplicationArea=#Jobs;
                SourceExpr=Amounts[CFForecastEntry."Source Type"::Job];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                OnDrillDown=BEGIN
                              CashFlowForecast.DrillDownEntriesFromSource(CashFlowForecast."Source Type Filter"::Job);
                            END;
                             }

    { 4   ;2   ;Field     ;
                Name=Tax;
                CaptionML=[DAN=Skat;
                           ENU=Tax];
                ToolTipML=[DAN=Angiver bel›b vedr›rende skatter.;
                           ENU=Specifies amounts related to taxes.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Amounts[CFForecastEntry."Source Type"::Tax];
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                OnDrillDown=BEGIN
                              CashFlowForecast.DrillDownEntriesFromSource(CashFlowForecast."Source Type Filter"::Tax);
                            END;
                             }

    { 1021;2   ;Field     ;
                Name=Total;
                CaptionML=[DAN=I alt;
                           ENU=Total];
                ToolTipML=[DAN=Angiver bel›b i alt.;
                           ENU=Specifies total amounts.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=CashFlowSum;
                AutoFormatType=10;
                AutoFormatExpr=FormatStr;
                Style=Strong;
                StyleExpr=TRUE;
                OnDrillDown=BEGIN
                              CashFlowForecast.DrillDownEntriesFromSource(CashFlowForecast."Source Type Filter"::" ");
                            END;
                             }

  }
  CODE
  {
    VAR
      CashFlowForecast@1001 : Record 840;
      CashFlowForecast2@1002 : Record 840;
      CFForecastEntry@1000 : Record 847;
      PeriodFormManagement@1008 : Codeunit 359;
      MatrixMgt@1003 : Codeunit 9200;
      RoundingFactorFormatString@1005 : Text;
      PeriodType@1010 : 'Day,Week,Month,Quarter,Year,Accounting Period';
      AmountType@1011 : 'Net Change,Balance at Date';
      RoundingFactor@1012 : 'None,1,1000,1000000';
      CashFlowSum@1022 : Decimal;
      Amounts@1004 : ARRAY [15] OF Decimal;

    [External]
    PROCEDURE Set@1000(VAR NewCashFlowForecast@1000 : Record 840;NewPeriodType@1001 : Integer;NewAmountType@1002 : 'Net Change,Balance at Date';RoundingFactor2@1003 : 'None,1,1000,1000000');
    BEGIN
      CashFlowForecast.COPY(NewCashFlowForecast);
      CashFlowForecast2.COPY(NewCashFlowForecast);
      PeriodType := NewPeriodType;
      AmountType := NewAmountType;
      CurrPage.UPDATE(FALSE);
      RoundingFactor := RoundingFactor2;
      RoundingFactorFormatString := MatrixMgt.GetFormatString(RoundingFactor,FALSE);
    END;

    LOCAL PROCEDURE FormatStr@8() : Text;
    BEGIN
      EXIT(RoundingFactorFormatString);
    END;

    BEGIN
    END.
  }
}

