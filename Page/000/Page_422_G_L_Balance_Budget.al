OBJECT Page 422 G/L Balance/Budget
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Finans - saldi/budget;
               ENU=G/L Balance/Budget];
    SaveValues=Yes;
    SourceTable=Table15;
    PageType=Worksheet;
    OnOpenPage=BEGIN
                 GLSetup.GET;
                 InitDefaultFilters;
                 CODEUNIT.RUN(CODEUNIT::"GLBudget-Open",Rec);
                 FindPeriod('');
               END;

    OnAfterGetRecord=BEGIN
                       NameIndent := 0;
                       CalcFormFields;
                       FormatLine;
                     END;

    OnNewRecord=BEGIN
                  SetupNewGLAcc(xRec,BelowxRec);
                END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 23      ;1   ;ActionGroup;
                      CaptionML=[DAN=K&onto;
                                 ENU=A&ccount];
                      Image=ChartOfAccounts }
      { 28      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=èbn finanskontokortet for den valgte record.;
                                 ENU=Open the G/L account card for the selected record.];
                      ApplicationArea=#Suite;
                      RunObject=Page 17;
                      RunPageLink=No.=FIELD(No.),
                                  Date Filter=FIELD(Date Filter),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
                                  Budget Filter=FIELD(Budget Filter),
                                  Business Unit Filter=FIELD(Business Unit Filter);
                      Image=EditLines }
      { 29      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=&Poster;
                                 ENU=Ledger E&ntries];
                      ToolTipML=[DAN=Se historikken over transaktioner, der er bogfõrt for den valgte record.;
                                 ENU=View the history of transactions that have been posted for the selected record.];
                      ApplicationArea=#Suite;
                      RunObject=Page 20;
                      RunPageView=SORTING(G/L Account No.);
                      RunPageLink=G/L Account No.=FIELD(No.);
                      Promoted=No;
                      Image=GLRegisters;
                      PromotedCategory=Process }
      { 42      ;2   ;Action    ;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 124;
                      RunPageLink=Table Name=CONST(G/L Account),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 184     ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omrÜde, projekt eller afdeling, som du kan tildele til salgs- og kõbsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      RunObject=Page 540;
                      RunPageLink=Table ID=CONST(15),
                                  No.=FIELD(No.);
                      Image=Dimensions }
      { 43      ;2   ;Action    ;
                      CaptionML=[DAN=&Udvidede tekster;
                                 ENU=E&xtended Texts];
                      ToolTipML=[DAN=Vis yderligere oplysninger, der er blevet fõjet til beskrivelsen for den aktuelle konto.;
                                 ENU=View additional information that has been added to the description for the current account.];
                      ApplicationArea=#Suite;
                      RunObject=Page 391;
                      RunPageView=SORTING(Table Name,No.,Language Code,All Language Codes,Starting Date,Ending Date);
                      RunPageLink=Table Name=CONST(G/L Account),
                                  No.=FIELD(No.);
                      Image=Text }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 20      ;1   ;Action    ;
                      CaptionML=[DAN=Forrige periode;
                                 ENU=Previous Period];
                      ToolTipML=[DAN=Vis oplysningerne baseret pÜ den forrige periode. Hvis du indstiller feltet Vis efter til Dag, skifter datofilteret til dagen fõr.;
                                 ENU=Show the information based on the previous period. If you set the View by field to Day, the date filter changes to the day before.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Image=PreviousRecord;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 FindPeriod('<=');
                               END;
                                }
      { 21      ;1   ;Action    ;
                      CaptionML=[DAN=Nëste periode;
                                 ENU=Next Period];
                      ToolTipML=[DAN=Vis oplysningerne baseret pÜ den nëste periode. Hvis du indstiller feltet Vis efter til Dag, skifter datofilteret til dagen efter.;
                                 ENU=Show the information based on the next period. If you set the View by field to Day, the date filter changes to the day before.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Image=NextRecord;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 FindPeriod('>=');
                               END;
                                }
      { 24      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 47      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kopier budget;
                                 ENU=Copy Budget];
                      ToolTipML=[DAN=Opret en kopi af det aktuelle budget.;
                                 ENU=Create a copy of the current budget.];
                      ApplicationArea=#Suite;
                      RunObject=Report 96;
                      Image=CopyBudget }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 50  ;1   ;Group     ;
                CaptionML=[DAN=Indstillinger;
                           ENU=Options] }

    { 40  ;2   ;Field     ;
                CaptionML=[DAN=Ultimoposter;
                           ENU=Closing Entries];
                ToolTipML=[DAN=Angiver, om den viste saldo skal indeholde ultimoposter. Hvis du vil se belõbene pÜ resultatopgõrelseskontiene i afsluttede Ür, skal du udelukke ultimoposter.;
                           ENU=Specifies whether the balance shown will include closing entries. If you want to see the amounts on income statement accounts in closed years, you must exclude closing entries.];
                OptionCaptionML=[DAN=Medtag,Udelad;
                                 ENU=Include,Exclude];
                ApplicationArea=#Suite;
                SourceExpr=ClosingEntryFilter;
                OnValidate=BEGIN
                             FindPeriod('');
                             ClosingEntryFilterOnAfterValid;
                           END;
                            }

    { 14  ;2   ;Field     ;
                CaptionML=[DAN=Vis efter;
                           ENU=View by];
                ToolTipML=[DAN=Angiver, hvilken periode belõbene vises for.;
                           ENU=Specifies by which period amounts are displayed.];
                OptionCaptionML=[DAN=Dag,Uge,MÜned,Kvartal,èr,Regnskabsperiode;
                                 ENU=Day,Week,Month,Quarter,Year,Accounting Period];
                ApplicationArea=#Suite;
                SourceExpr=PeriodType;
                OnValidate=BEGIN
                             IF PeriodType = PeriodType::"Accounting Period" THEN
                               AccountingPerioPeriodTypeOnVal;
                             IF PeriodType = PeriodType::Year THEN
                               YearPeriodTypeOnValidate;
                             IF PeriodType = PeriodType::Quarter THEN
                               QuarterPeriodTypeOnValidate;
                             IF PeriodType = PeriodType::Month THEN
                               MonthPeriodTypeOnValidate;
                             IF PeriodType = PeriodType::Week THEN
                               WeekPeriodTypeOnValidate;
                             IF PeriodType = PeriodType::Day THEN
                               DayPeriodTypeOnValidate;
                           END;
                            }

    { 22  ;2   ;Field     ;
                CaptionML=[DAN=Vis som;
                           ENU=View as];
                ToolTipML=[DAN=Angiver, hvordan belõbene vises. Bevëgelse: Bevëgelsen i saldoen for den valgte periode. Saldo til dato: Saldoen pÜ den sidste dag i den valgte periode.;
                           ENU=Specifies how amounts are displayed. Net Change: The net change in the balance for the selected period. Balance at Date: The balance as of the last day in the selected period.];
                OptionCaptionML=[DAN=Bevëgelse,Saldo til dato;
                                 ENU=Net Change,Balance at Date];
                ApplicationArea=#Suite;
                SourceExpr=AmountType;
                OnValidate=BEGIN
                             IF AmountType = AmountType::"Balance at Date" THEN
                               BalanceatDateAmountTypeOnValid;
                             IF AmountType = AmountType::"Net Change" THEN
                               NetChangeAmountTypeOnValidate;
                           END;
                            }

    { 9   ;2   ;Field     ;
                CaptionML=[DAN=Datofilter;
                           ENU=Date Filter];
                ToolTipML=[DAN=Angiver de datoer, der bruges til at filtrere belõbene i vinduet.;
                           ENU=Specifies the dates that will be used to filter the amounts in the window.];
                ApplicationArea=#Suite;
                SourceExpr=DateFilter;
                OnValidate=BEGIN
                             IF DateFilter = '' THEN
                               SETRANGE("Date Filter")
                             ELSE
                               SETFILTER("Date Filter",DateFilter);
                             CurrPage.UPDATE;
                           END;
                            }

    { 11  ;2   ;Field     ;
                Name=GLAccFilter;
                CaptionML=[DAN=Finanskontofilter;
                           ENU=G/L Account Filter];
                ToolTipML=[DAN=Angiver de finanskonti, du vil have vist oplysninger om i vinduet.;
                           ENU=Specifies the G/L accounts for which you will see information in the window.];
                ApplicationArea=#Suite;
                SourceExpr=GLAccFilter;
                OnValidate=BEGIN
                             IF GLAccFilter = '' THEN
                               SETRANGE("No.")
                             ELSE
                               SETFILTER("No.",GLAccFilter);
                             CurrPage.UPDATE;
                           END;

                OnLookup=VAR
                           GLAccList@1002 : Page 18;
                         BEGIN
                           GLAccList.LOOKUPMODE(TRUE);
                           IF NOT (GLAccList.RUNMODAL = ACTION::LookupOK) THEN
                             EXIT(FALSE);

                           Text := GLAccList.GetSelectionFilter;
                           EXIT(TRUE);
                         END;
                          }

    { 7   ;2   ;Field     ;
                Name=GLAccCategory;
                CaptionML=[DAN=Filter for finanskontokategori;
                           ENU=G/L Account Category Filter];
                ToolTipML=[DAN=Angiver kategorien for den finanskonto, du vil have vist oplysninger om i vinduet.;
                           ENU=Specifies the category of the G/L account for which you will see information in the window.];
                OptionCaptionML=[DAN=" ,Aktiver,Gëld,Egenkapital,Indtëgter,Vareforbrug,Udgifter";
                                 ENU=" ,Assets,Liabilities,Equity,Income,Cost of Goods Sold,Expense"];
                ApplicationArea=#Suite;
                SourceExpr=GLAccCategoryFilter;
                OnValidate=BEGIN
                             IF GLAccCategoryFilter = GLAccCategoryFilter::" " THEN
                               SETRANGE("Account Category")
                             ELSE
                               SETRANGE("Account Category",GLAccCategoryFilter);
                             CurrPage.UPDATE;
                           END;
                            }

    { 4   ;2   ;Field     ;
                Name=IncomeBalGLAccFilter;
                CaptionML=[DAN=Filter for indtëgter/finanskontosaldo;
                           ENU=Income/Balance G/L Account Filter];
                ToolTipML=[DAN=Angiver typen af finanskonto, du vil have vist oplysninger om i vinduet.;
                           ENU=Specifies the type of the G/L account for which you will see information in the window.];
                OptionCaptionML=[DAN=" ,Resultatopgõrelse,Balance";
                                 ENU=" ,Income Statement,Balance Sheet"];
                ApplicationArea=#Suite;
                SourceExpr=IncomeBalanceGLAccFilter;
                OnValidate=BEGIN
                             CASE IncomeBalanceGLAccFilter OF
                               IncomeBalanceGLAccFilter::" ":
                                 SETRANGE("Income/Balance");
                               IncomeBalanceGLAccFilter::"Balance Sheet":
                                 SETRANGE("Income/Balance","Income/Balance"::"Balance Sheet");
                               IncomeBalanceGLAccFilter::"Income Statement":
                                 SETRANGE("Income/Balance","Income/Balance"::"Income Statement");
                             END;
                             IncomeBalanceVisible := GETFILTER("Income/Balance") = '';
                             CurrPage.UPDATE;
                           END;
                            }

    { 2   ;2   ;Field     ;
                Name=GlobalDim1Filter;
                CaptionML=[DAN=Global dimension 1-filter;
                           ENU=Global Dimension 1 Filter];
                ToolTipML=[DAN=Angiver den globale dimension, som dataene vises efter. Globale dimensioner de dimensioner, som du analyserer oftest. To globale dimensioner, der typisk er for virksomhedens vigtigste aktiviteter, er tilgëngelige pÜ alle kort, bilag, rapporter og lister.;
                           ENU=Specifies by which global dimension data is shown. Global dimensions are the dimensions that you analyze most frequently. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Suite;
                SourceExpr=GlobalDim1Filter;
                CaptionClass='1,3,1';
                Enabled=GlobalDim1FilterEnable;
                OnValidate=BEGIN
                             IF GlobalDim1Filter = '' THEN
                               SETRANGE("Global Dimension 1 Filter")
                             ELSE
                               SETFILTER("Global Dimension 1 Filter",GlobalDim1Filter);
                             CurrPage.UPDATE;
                           END;

                OnLookup=VAR
                           DimensionValue@1001 : Record 349;
                         BEGIN
                           EXIT(DimensionValue.LookUpDimFilter(GLSetup."Global Dimension 1 Code",Text));
                         END;
                          }

    { 3   ;2   ;Field     ;
                Name=GlobalDim2Filter;
                CaptionML=[DAN=Global dimension 2-filter;
                           ENU=Global Dimension 2 Filter];
                ToolTipML=[DAN=Angiver den globale dimension, som dataene vises efter. Globale dimensioner de dimensioner, som du analyserer oftest. To globale dimensioner, der typisk er for virksomhedens vigtigste aktiviteter, er tilgëngelige pÜ alle kort, bilag, rapporter og lister.;
                           ENU=Specifies by which global dimension data is shown. Global dimensions are the dimensions that you analyze most frequently. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Suite;
                SourceExpr=GlobalDim2Filter;
                CaptionClass='1,3,2';
                Enabled=GlobalDim2FilterEnable;
                OnValidate=BEGIN
                             IF GlobalDim2Filter = '' THEN
                               SETRANGE("Global Dimension 2 Filter")
                             ELSE
                               SETFILTER("Global Dimension 2 Filter",GlobalDim2Filter);
                             CurrPage.UPDATE;
                           END;

                OnLookup=VAR
                           DimensionValue@1001 : Record 349;
                         BEGIN
                           EXIT(DimensionValue.LookUpDimFilter(GLSetup."Global Dimension 2 Code",Text));
                         END;
                          }

    { 5   ;1   ;Group     ;
                IndentationColumnName=NameIndent;
                IndentationControls=Name;
                GroupType=Repeater }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Suite;
                SourceExpr="No.";
                Style=Strong;
                StyleExpr=Emphasize }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ finanskontoen.;
                           ENU=Specifies the name of the general ledger account.];
                ApplicationArea=#Suite;
                SourceExpr=Name;
                Style=Strong;
                StyleExpr=Emphasize }

    { 1   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om en finanskonto er en resultatopgõrelseskonto eller en balancekonto.;
                           ENU=Specifies whether a general ledger account is an income statement account or a balance sheet account.];
                ApplicationArea=#Suite;
                SourceExpr="Income/Balance";
                Visible=IncomeBalanceVisible;
                Style=Strong;
                StyleExpr=Emphasize }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der reprësenterer debiteringer.;
                           ENU=Specifies the total of the ledger entries that represent debits.];
                ApplicationArea=#Suite;
                BlankNumbers=BlankNegAndZero;
                SourceExpr="Debit Amount";
                Style=Strong;
                StyleExpr=Emphasize }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der reprësenterer krediteringer.;
                           ENU=Specifies the total of the ledger entries that represent credits.];
                ApplicationArea=#Suite;
                BlankNumbers=BlankNegAndZero;
                SourceExpr="Credit Amount";
                Style=Strong;
                StyleExpr=Emphasize }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bevëgelsen pÜ kontosaldoen i den periode, der er indtastet i feltet Datofilter.;
                           ENU=Specifies the net change in the account balance during the time period in the Date Filter field.];
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr="Net Change";
                Visible=FALSE;
                Style=Strong;
                StyleExpr=Emphasize }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det budgetterede debetbelõb for kontoen.;
                           ENU=Specifies the Budgeted Debit Amount for the account.];
                ApplicationArea=#Suite;
                SourceExpr="Budgeted Debit Amount";
                Style=Strong;
                StyleExpr=Emphasize;
                OnValidate=BEGIN
                             CalcFormFields;
                             BudgetedDebitAmountOnAfterVali;
                           END;
                            }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det budgetterede kreditbelõb for kontoen.;
                           ENU=Specifies the Budgeted Credit Amount for the account.];
                ApplicationArea=#Suite;
                SourceExpr="Budgeted Credit Amount";
                Style=Strong;
                StyleExpr=Emphasize;
                OnValidate=BEGIN
                             CalcFormFields;
                             BudgetedCreditAmountOnAfterVal;
                           END;
                            }

    { 37  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver enten finanskontoens samlede budget, eller et bestemt budget, hvis du har angivet et navn i feltet Budgetnavn.;
                           ENU=Specifies either the G/L account's total budget or, if you have specified a name in the Budget Name field, a specific budget.];
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr="Budgeted Amount";
                Visible=FALSE;
                Style=Strong;
                StyleExpr=Emphasize;
                OnValidate=BEGIN
                             CalcFormFields;
                             BudgetedAmountOnAfterValidate;
                           END;
                            }

    { 26  ;2   ;Field     ;
                CaptionML=[DAN=Saldo/budget (%);
                           ENU=Balance/Budget (%)];
                ToolTipML=[DAN=Angiver en oversigt over debet- og kreditsaldi og budgetterede belõb for forskellige tidsintervaller for den konto, du har valgt i kontoplanen.;
                           ENU=Specifies a summary of the debit and credit balances and the budgeted amounts for different time periods for the account that you select in the chart of accounts.];
                ApplicationArea=#Suite;
                DecimalPlaces=1:1;
                BlankZero=Yes;
                SourceExpr=BudgetPct;
                Editable=FALSE;
                Style=Strong;
                StyleExpr=Emphasize }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      GLSetup@1010 : Record 98;
      PeriodType@1000 : 'Day,Week,Month,Quarter,Year,Accounting Period';
      AmountType@1001 : 'Net Change,Balance at Date';
      ClosingEntryFilter@1002 : 'Include,Exclude';
      GLAccCategoryFilter@1013 : ' ,Assets,Liabilities,Equity,Income,Cost of Goods Sold,Expense';
      IncomeBalanceGLAccFilter@1012 : ' ,Income Statement,Balance Sheet';
      BudgetPct@1003 : Decimal;
      Emphasize@19018670 : Boolean INDATASET;
      IncomeBalanceVisible@1004 : Boolean;
      GlobalDim1FilterEnable@1009 : Boolean;
      GlobalDim2FilterEnable@1008 : Boolean;
      NameIndent@19079073 : Integer INDATASET;
      DateFilter@1007 : Text;
      GlobalDim1Filter@1006 : Text;
      GlobalDim2Filter@1005 : Text;
      GLAccFilter@1011 : Text;

    LOCAL PROCEDURE FindPeriod@1(SearchText@1000 : Code[10]);
    VAR
      Calendar@1001 : Record 2000000007;
      AccountingPeriod@1002 : Record 50;
      PeriodFormMgt@1003 : Codeunit 359;
    BEGIN
      IF GETFILTER("Date Filter") <> '' THEN BEGIN
        Calendar.SETFILTER("Period Start",GETFILTER("Date Filter"));
        IF NOT PeriodFormMgt.FindDate('+',Calendar,PeriodType) THEN
          PeriodFormMgt.FindDate('+',Calendar,PeriodType::Day);
        Calendar.SETRANGE("Period Start");
      END;
      PeriodFormMgt.FindDate(SearchText,Calendar,PeriodType);
      IF AmountType = AmountType::"Net Change" THEN
        IF Calendar."Period Start" = Calendar."Period End" THEN
          SETRANGE("Date Filter",Calendar."Period Start")
        ELSE
          SETRANGE("Date Filter",Calendar."Period Start",Calendar."Period End")
      ELSE
        SETRANGE("Date Filter",0D,Calendar."Period End");
      IF ClosingEntryFilter = ClosingEntryFilter::Exclude THEN BEGIN
        AccountingPeriod.SETCURRENTKEY("New Fiscal Year");
        AccountingPeriod.SETRANGE("New Fiscal Year",TRUE);
        IF GETRANGEMIN("Date Filter") = 0D THEN
          AccountingPeriod.SETRANGE("Starting Date",0D,GETRANGEMAX("Date Filter"))
        ELSE
          AccountingPeriod.SETRANGE(
            "Starting Date",
            GETRANGEMIN("Date Filter") + 1,
            GETRANGEMAX("Date Filter"));
        IF AccountingPeriod.FIND('-') THEN
          REPEAT
            SETFILTER(
              "Date Filter",GETFILTER("Date Filter") + '&<>%1',
              CLOSINGDATE(AccountingPeriod."Starting Date" - 1));
          UNTIL AccountingPeriod.NEXT = 0;
      END ELSE
        SETRANGE(
          "Date Filter",
          GETRANGEMIN("Date Filter"),
          CLOSINGDATE(GETRANGEMAX("Date Filter")));
      DateFilter := GETFILTER("Date Filter");
    END;

    LOCAL PROCEDURE CalcFormFields@2();
    BEGIN
      CALCFIELDS("Net Change","Budgeted Amount");
      IF "Net Change" >= 0 THEN BEGIN
        "Debit Amount" := "Net Change";
        "Credit Amount" := 0;
      END ELSE BEGIN
        "Debit Amount" := 0;
        "Credit Amount" := -"Net Change";
      END;
      IF "Budgeted Amount" >= 0 THEN BEGIN
        "Budgeted Debit Amount" := "Budgeted Amount";
        "Budgeted Credit Amount" := 0;
      END ELSE BEGIN
        "Budgeted Debit Amount" := 0;
        "Budgeted Credit Amount" := -"Budgeted Amount";
      END;
      IF "Budgeted Amount" = 0 THEN
        BudgetPct := 0
      ELSE
        BudgetPct := "Net Change" / "Budgeted Amount" * 100;
    END;

    LOCAL PROCEDURE BudgetedDebitAmountOnAfterVali@19067544();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE BudgetedCreditAmountOnAfterVal@19013792();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE BudgetedAmountOnAfterValidate@19015508();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE DayPeriodTypeOnAfterValidate@19007055();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE WeekPeriodTypeOnAfterValidate@19029206();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE MonthPeriodTypeOnAfterValidate@19032849();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE QuarterPeriodTypeOnAfterValida@19067088();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE YearPeriodTypeOnAfterValidate@19061107();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE AccountingPerioPeriodTypeOnAft@19065662();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE ClosingEntryFilterOnAfterValid@19030533();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE NetChangeAmountTypeOnAfterVali@19014941();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE BalanceatDateAmountTypeOnAfter@19031410();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE DayPeriodTypeOnPush@19008851();
    BEGIN
      FindPeriod('');
    END;

    LOCAL PROCEDURE WeekPeriodTypeOnPush@19046063();
    BEGIN
      FindPeriod('');
    END;

    LOCAL PROCEDURE MonthPeriodTypeOnPush@19047374();
    BEGIN
      FindPeriod('');
    END;

    LOCAL PROCEDURE QuarterPeriodTypeOnPush@19018850();
    BEGIN
      FindPeriod('');
    END;

    LOCAL PROCEDURE YearPeriodTypeOnPush@19051042();
    BEGIN
      FindPeriod('');
    END;

    LOCAL PROCEDURE AccountingPerioPeriodTypOnPush@19038761();
    BEGIN
      FindPeriod('');
    END;

    LOCAL PROCEDURE NetChangeAmountTypeOnPush@19074855();
    BEGIN
      FindPeriod('');
    END;

    LOCAL PROCEDURE BalanceatDateAmountTypeOnPush@19049003();
    BEGIN
      FindPeriod('');
    END;

    LOCAL PROCEDURE FormatLine@19039177();
    BEGIN
      NameIndent := Indentation;
      Emphasize := "Account Type" <> "Account Type"::Posting;
    END;

    LOCAL PROCEDURE DayPeriodTypeOnValidate@19012979();
    BEGIN
      DayPeriodTypeOnPush;
      DayPeriodTypeOnAfterValidate;
    END;

    LOCAL PROCEDURE WeekPeriodTypeOnValidate@19058475();
    BEGIN
      WeekPeriodTypeOnPush;
      WeekPeriodTypeOnAfterValidate;
    END;

    LOCAL PROCEDURE MonthPeriodTypeOnValidate@19021027();
    BEGIN
      MonthPeriodTypeOnPush;
      MonthPeriodTypeOnAfterValidate;
    END;

    LOCAL PROCEDURE QuarterPeriodTypeOnValidate@19015346();
    BEGIN
      QuarterPeriodTypeOnPush;
      QuarterPeriodTypeOnAfterValida;
    END;

    LOCAL PROCEDURE YearPeriodTypeOnValidate@19064743();
    BEGIN
      YearPeriodTypeOnPush;
      YearPeriodTypeOnAfterValidate;
    END;

    LOCAL PROCEDURE AccountingPerioPeriodTypeOnVal@19058901();
    BEGIN
      AccountingPerioPeriodTypOnPush;
      AccountingPerioPeriodTypeOnAft;
    END;

    LOCAL PROCEDURE NetChangeAmountTypeOnValidate@19062218();
    BEGIN
      NetChangeAmountTypeOnPush;
      NetChangeAmountTypeOnAfterVali;
    END;

    LOCAL PROCEDURE BalanceatDateAmountTypeOnValid@19007073();
    BEGIN
      BalanceatDateAmountTypeOnPush;
      BalanceatDateAmountTypeOnAfter;
    END;

    LOCAL PROCEDURE InitDefaultFilters@3();
    VAR
      GLBudgetOpen@1000 : Codeunit 7;
    BEGIN
      GLBudgetOpen.SetupFiltersOnGLAccBudgetPage(
        GlobalDim1Filter,GlobalDim2Filter,GlobalDim1FilterEnable,GlobalDim2FilterEnable,
        PeriodType,DateFilter,Rec);
      IncomeBalanceVisible := GETFILTER("Income/Balance") = '';
      GLAccFilter := GETFILTER("No.");
      EVALUATE(GLAccCategoryFilter,GETFILTER("Account Category"));
      EVALUATE(IncomeBalanceGLAccFilter,GETFILTER("Income/Balance"));
    END;

    BEGIN
    END.
  }
}

