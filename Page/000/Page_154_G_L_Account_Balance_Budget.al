OBJECT Page 154 G/L Account Balance/Budget
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Finanskonto - saldo/budget;
               ENU=G/L Account Balance/Budget];
    SaveValues=Yes;
    InsertAllowed=No;
    DeleteAllowed=No;
    LinksAllowed=No;
    SourceTable=Table15;
    PageType=ListPlus;
    OnOpenPage=VAR
                 GLBudgetOpen@1000 : Codeunit 7;
               BEGIN
                 GLSetup.GET;
                 GLBudgetOpen.RUN(Rec);
                 GLBudgetOpen.SetupFiltersOnGLAccBudgetPage(
                   GlobalDim1Filter,GlobalDim2Filter,GlobalDim1FilterEnable,GlobalDim2FilterEnable,
                   PeriodType,DateFilter,Rec);
               END;

    OnAfterGetRecord=BEGIN
                       UpdateSubForm;
                     END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 2       ;1   ;ActionGroup;
                      CaptionML=[DAN=K&onto;
                                 ENU=A&ccount];
                      Image=ChartOfAccounts }
      { 20      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=�bn finanskontokortet for den valgte record.;
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
      { 22      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=&Poster;
                                 ENU=Ledger E&ntries];
                      ToolTipML=[DAN=Se historikken over transaktioner, der er bogf�rt for den valgte record.;
                                 ENU=View the history of transactions that have been posted for the selected record.];
                      ApplicationArea=#Suite;
                      RunObject=Page 20;
                      RunPageView=SORTING(G/L Account No.);
                      RunPageLink=G/L Account No.=FIELD(No.);
                      Promoted=No;
                      Image=GLRegisters;
                      PromotedCategory=Process }
      { 23      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m�rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf�j bem�rkninger for recorden.;
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
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr�de, projekt eller afdeling, som du kan tildele til salgs- og k�bsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      RunObject=Page 540;
                      RunPageLink=Table ID=CONST(15),
                                  No.=FIELD(No.);
                      Image=Dimensions }
      { 24      ;2   ;Action    ;
                      CaptionML=[DAN=&Udvidede tekster;
                                 ENU=E&xtended Texts];
                      ToolTipML=[DAN=Vis yderligere oplysninger, der er blevet f�jet til beskrivelsen for den aktuelle konto.;
                                 ENU=View additional information that has been added to the description for the current account.];
                      ApplicationArea=#Suite;
                      RunObject=Page 391;
                      RunPageView=SORTING(Table Name,No.,Language Code,All Language Codes,Starting Date,Ending Date);
                      RunPageLink=Table Name=CONST(G/L Account),
                                  No.=FIELD(No.);
                      Image=Text }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 3       ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 28      ;2   ;Action    ;
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

    { 14  ;1   ;Group     ;
                CaptionML=[DAN=Indstillinger;
                           ENU=Options] }

    { 19  ;2   ;Field     ;
                CaptionML=[DAN=Ultimoposter;
                           ENU=Closing Entries];
                ToolTipML=[DAN=Angiver, om den viste saldo skal indeholde ultimoposter. Hvis du vil se bel�bene p� resultatopg�relseskontiene i afsluttede �r, skal du udelukke ultimoposter.;
                           ENU=Specifies whether the balance shown will include closing entries. If you want to see the amounts on income statement accounts in closed years, you must exclude closing entries.];
                OptionCaptionML=[DAN=Medtag,Udelad;
                                 ENU=Include,Exclude];
                ApplicationArea=#Suite;
                SourceExpr=ClosingEntryFilter;
                OnValidate=BEGIN
                             UpdateSubForm;
                           END;
                            }

    { 6   ;2   ;Field     ;
                CaptionML=[DAN=Vis efter;
                           ENU=View by];
                ToolTipML=[DAN=Angiver, hvilken periode bel�bene vises for.;
                           ENU=Specifies by which period amounts are displayed.];
                OptionCaptionML=[DAN=Dag,Uge,M�ned,Kvartal,�r,Regnskabsperiode;
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

    { 1   ;2   ;Field     ;
                CaptionML=[DAN=Vis som;
                           ENU=View as];
                ToolTipML=[DAN=Angiver, hvordan bel�bene vises. Bev�gelse: Bev�gelsen i saldoen for den valgte periode. Saldo til dato: Saldoen p� den sidste dag i den valgte periode.;
                           ENU=Specifies how amounts are displayed. Net Change: The net change in the balance for the selected period. Balance at Date: The balance as of the last day in the selected period.];
                OptionCaptionML=[DAN=Bev�gelse,Saldo til dato;
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

    { 5   ;1   ;Part      ;
                Name=GLBalanceLines;
                ApplicationArea=#Suite;
                PagePartID=Page350 }

    { 9   ;1   ;Group     ;
                CaptionML=[DAN=Filtre;
                           ENU=Filters] }

    { 8   ;2   ;Field     ;
                CaptionML=[DAN=Datofilter;
                           ENU=Date Filter];
                ToolTipML=[DAN=Angiver de datoer, der bruges til at filtrere bel�bene i vinduet.;
                           ENU=Specifies the dates that will be used to filter the amounts in the window.];
                ApplicationArea=#Suite;
                SourceExpr=DateFilter;
                OnValidate=BEGIN
                             IF DateFilter = '' THEN
                               SETRANGE("Date Filter")
                             ELSE
                               SETFILTER("Date Filter",DateFilter);
                             UpdateSubForm;
                           END;
                            }

    { 7   ;2   ;Field     ;
                Name=GlobalDim1Filter;
                CaptionML=[DAN=Global dimension 1-filter;
                           ENU=Global Dimension 1 Filter];
                ToolTipML=[DAN=Angiver den globale dimension, som dataene vises efter. Globale dimensioner de dimensioner, som du analyserer oftest. To globale dimensioner, der typisk er for virksomhedens vigtigste aktiviteter, er tilg�ngelige p� alle kort, bilag, rapporter og lister.;
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
                             UpdateSubForm;
                           END;

                OnLookup=VAR
                           DimensionValue@1002 : Record 349;
                         BEGIN
                           EXIT(DimensionValue.LookUpDimFilter(GLSetup."Global Dimension 1 Code",Text));
                         END;
                          }

    { 4   ;2   ;Field     ;
                Name=GlobalDim2Filter;
                CaptionML=[DAN=Global dimension 2-filter;
                           ENU=Global Dimension 2 Filter];
                ToolTipML=[DAN=Angiver den globale dimension, som dataene vises efter. Globale dimensioner de dimensioner, som du analyserer oftest. To globale dimensioner, der typisk er for virksomhedens vigtigste aktiviteter, er tilg�ngelige p� alle kort, bilag, rapporter og lister.;
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
                             UpdateSubForm;
                           END;

                OnLookup=VAR
                           DimensionValue@1001 : Record 349;
                         BEGIN
                           EXIT(DimensionValue.LookUpDimFilter(GLSetup."Global Dimension 2 Code",Text));
                         END;
                          }

  }
  CODE
  {
    VAR
      GLSetup@1008 : Record 98;
      PeriodType@1000 : 'Day,Week,Month,Quarter,Year,Accounting Period';
      AmountType@1001 : 'Net Change,Balance at Date';
      ClosingEntryFilter@1002 : 'Include,Exclude';
      GlobalDim1FilterEnable@1007 : Boolean;
      GlobalDim2FilterEnable@1006 : Boolean;
      DateFilter@1005 : Text;
      GlobalDim1Filter@1004 : Text;
      GlobalDim2Filter@1003 : Text;

    LOCAL PROCEDURE UpdateSubForm@1();
    BEGIN
      CurrPage.GLBalanceLines.PAGE.Set(Rec,PeriodType,AmountType,ClosingEntryFilter);
    END;

    LOCAL PROCEDURE DayPeriodTypeOnPush@19008851();
    BEGIN
      UpdateSubForm;
    END;

    LOCAL PROCEDURE WeekPeriodTypeOnPush@19046063();
    BEGIN
      UpdateSubForm;
    END;

    LOCAL PROCEDURE MonthPeriodTypeOnPush@19047374();
    BEGIN
      UpdateSubForm;
    END;

    LOCAL PROCEDURE QuarterPeriodTypeOnPush@19018850();
    BEGIN
      UpdateSubForm;
    END;

    LOCAL PROCEDURE YearPeriodTypeOnPush@19051042();
    BEGIN
      UpdateSubForm;
    END;

    LOCAL PROCEDURE AccountingPerioPeriodTypOnPush@19038761();
    BEGIN
      UpdateSubForm;
    END;

    LOCAL PROCEDURE NetChangeAmountTypeOnPush@19074855();
    BEGIN
      UpdateSubForm;
    END;

    LOCAL PROCEDURE BalanceatDateAmountTypeOnPush@19049003();
    BEGIN
      UpdateSubForm;
    END;

    LOCAL PROCEDURE DayPeriodTypeOnValidate@19012979();
    BEGIN
      DayPeriodTypeOnPush;
    END;

    LOCAL PROCEDURE WeekPeriodTypeOnValidate@19058475();
    BEGIN
      WeekPeriodTypeOnPush;
    END;

    LOCAL PROCEDURE MonthPeriodTypeOnValidate@19021027();
    BEGIN
      MonthPeriodTypeOnPush;
    END;

    LOCAL PROCEDURE QuarterPeriodTypeOnValidate@19015346();
    BEGIN
      QuarterPeriodTypeOnPush;
    END;

    LOCAL PROCEDURE YearPeriodTypeOnValidate@19064743();
    BEGIN
      YearPeriodTypeOnPush;
    END;

    LOCAL PROCEDURE AccountingPerioPeriodTypeOnVal@19058901();
    BEGIN
      AccountingPerioPeriodTypOnPush;
    END;

    LOCAL PROCEDURE NetChangeAmountTypeOnValidate@19062218();
    BEGIN
      NetChangeAmountTypeOnPush;
    END;

    LOCAL PROCEDURE BalanceatDateAmountTypeOnValid@19007073();
    BEGIN
      BalanceatDateAmountTypeOnPush;
    END;

    BEGIN
    END.
  }
}

