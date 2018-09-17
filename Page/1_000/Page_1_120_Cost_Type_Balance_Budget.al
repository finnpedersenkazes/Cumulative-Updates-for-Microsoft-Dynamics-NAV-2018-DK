OBJECT Page 1120 Cost Type Balance/Budget
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Omkostningstypesaldo/budget;
               ENU=Cost Type Balance/Budget];
    SaveValues=Yes;
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table1103;
    PageType=Worksheet;
    RefreshOnActivate=Yes;
    OnOpenPage=BEGIN
                 BudgetFilter := GETFILTER("Budget Filter");
                 FindPeriod('');
               END;

    OnAfterGetRecord=BEGIN
                       NameIndent := 0;
                       CalcFormFields;
                       NameIndent := Indentation;
                       Emphasize := Type <> Type::"Cost Type";
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
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om omkostningstypen.;
                                 ENU=View or edit detailed information about cost type.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Page 1101;
                      RunPageLink=No.=FIELD(No.),
                                  Date Filter=FIELD(Date Filter),
                                  Cost Center Filter=FIELD(Cost Center Filter),
                                  Cost Object Filter=FIELD(Cost Object Filter),
                                  Budget Filter=FIELD(Budget Filter);
                      Image=EditLines }
      { 29      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=Omkost&ningsposter;
                                 ENU=Cost E&ntries];
                      ToolTipML=[DAN=Vis omkostningsposter, som kan komme fra kilder sÜsom automatisk overfõrsel af finansposter til omkostningsposter, manuel bogfõring for rene omkostningsposter, interne afgifter og manuelle allokeringer samt automatisk tildeling af bogfõringer for faktiske omkostninger.;
                                 ENU=View cost entries, which can come from sources such as automatic transfer of general ledger entries to cost entries, manual posting for pure cost entries, internal charges, and manual allocations, and automatic allocation postings for actual costs.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Page 1103;
                      RunPageView=SORTING(Cost Type No.,Posting Date);
                      RunPageLink=Cost Type No.=FIELD(No.),
                                  Posting Date=FIELD(Date Filter);
                      Promoted=No;
                      Image=CostEntries;
                      PromotedCategory=Process }
      { 1       ;0   ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 2       ;1   ;Action    ;
                      Name=PreviousPeriod;
                      CaptionML=[DAN=Forrige periode;
                                 ENU=Previous Period];
                      ToolTipML=[DAN=FÜ vist oplysningerne baseret pÜ den forrige periode. Hvis du indstiller feltet Vis efter til Dag, skifter datofilteret til dagen fõr.;
                                 ENU=Show the information based on the previous period. If you set the View by field to Day, the date filter changes to the day before.];
                      ApplicationArea=#CostAccounting;
                      Promoted=Yes;
                      Image=PreviousRecord;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 FindPeriod('<=');
                               END;
                                }
      { 3       ;1   ;Action    ;
                      Name=NextPeriod;
                      CaptionML=[DAN=Nëste periode;
                                 ENU=Next Period];
                      ToolTipML=[DAN=Vis oplysningerne baseret pÜ den nëste periode. Hvis du indstiller feltet Vis efter til Dag, skifter datofilteret til dagen efter.;
                                 ENU=Show the information based on the next period. If you set the View by field to Day, the date filter changes to the day before.];
                      ApplicationArea=#CostAccounting;
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
                      ApplicationArea=#CostAccounting;
                      RunObject=Report 96;
                      Image=CopyBudget }
    }
  }
  CONTROLS
  {
    { 4   ;0   ;Container ;
                ContainerType=ContentArea }

    { 5   ;1   ;Group     ;
                CaptionML=[DAN=Indstillinger;
                           ENU=Options] }

    { 7   ;2   ;Field     ;
                CaptionML=[DAN=Budgetfilter;
                           ENU=Budget Filter];
                ToolTipML=[DAN=Angiver det budget, som du vil have vist budgetbelõb for.;
                           ENU=Specifies the budget for which you want to view budget amounts.];
                ApplicationArea=#CostAccounting;
                SourceExpr=BudgetFilter;
                TableRelation="Cost Budget Name".Name;
                LookupPageID=Cost Budget Names;
                OnValidate=BEGIN
                             CurrPage.UPDATE(FALSE);
                           END;
                            }

    { 8   ;2   ;Field     ;
                CaptionML=[DAN=Omkostningsstedsfilter;
                           ENU=Cost Center Filter];
                ToolTipML=[DAN=Angiver det omkostningssted, som du vil have vist budgetbelõb for.;
                           ENU=Specifies the cost center for which you want to view budget amounts.];
                ApplicationArea=#CostAccounting;
                SourceExpr=CostCenterFilter;
                OnValidate=BEGIN
                             CurrPage.UPDATE(FALSE);
                           END;

                OnLookup=VAR
                           CostCenter@1000 : Record 1112;
                         BEGIN
                           EXIT(CostCenter.LookupCostCenterFilter(Text));
                         END;
                          }

    { 9   ;2   ;Field     ;
                CaptionML=[DAN=Omkostningsemnefilter;
                           ENU=Cost Object Filter];
                ToolTipML=[DAN=Angiver det omkostningsemne, som du vil have vist budgetbelõb for.;
                           ENU=Specifies the cost object for which you want to view budget amounts.];
                ApplicationArea=#CostAccounting;
                SourceExpr=CostObjectFilter;
                OnValidate=BEGIN
                             CurrPage.UPDATE(FALSE);
                           END;

                OnLookup=VAR
                           CostObject@1000 : Record 1113;
                         BEGIN
                           EXIT(CostObject.LookupCostObjectFilter(Text));
                         END;
                          }

    { 10  ;2   ;Field     ;
                CaptionML=[DAN=Vis efter;
                           ENU=View by];
                ToolTipML=[DAN=Angiver, hvilken periode belõbene vises for.;
                           ENU=Specifies by which period amounts are displayed.];
                OptionCaptionML=[DAN=Dag,Uge,MÜned,Kvartal,èr,Regnskabsperiode;
                                 ENU=Day,Week,Month,Quarter,Year,Accounting Period];
                ApplicationArea=#CostAccounting;
                SourceExpr=PeriodType;
                OnValidate=BEGIN
                             FindPeriod('');
                           END;
                            }

    { 11  ;2   ;Field     ;
                CaptionML=[DAN=Vis som;
                           ENU=View as];
                ToolTipML=[DAN=Angiver, hvordan belõbene vises. Bevëgelse: Bevëgelsen i saldoen for den valgte periode. Saldo til dato: Saldoen pÜ den sidste dag i den valgte periode.;
                           ENU=Specifies how amounts are displayed. Net Change: The net change in the balance for the selected period. Balance at Date: The balance as of the last day in the selected period.];
                OptionCaptionML=[DAN=Bevëgelse,Saldo til dato;
                                 ENU=Net Change,Balance at Date];
                ApplicationArea=#CostAccounting;
                SourceExpr=AmountType;
                OnValidate=BEGIN
                             IF (AmountType = AmountType::"Balance at Date") OR (AmountType = AmountType::"Net Change") THEN
                               FindPeriod('');
                           END;
                            }

    { 17  ;2   ;Field     ;
                Name=DateFilter;
                CaptionML=[DAN=Datofilter;
                           ENU=Date Filter];
                ToolTipML=[DAN=Angiver de datoer, der bruges til at filtrere belõbene i vinduet.;
                           ENU=Specifies the dates that will be used to filter the amounts in the window.];
                ApplicationArea=#CostAccounting;
                SourceExpr=DateFilter;
                Editable=FALSE }

    { 12  ;1   ;Group     ;
                IndentationColumnName=NameIndent;
                IndentationControls=Name;
                GroupType=Repeater }

    { 13  ;2   ;Field     ;
                Name=Number;
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#CostAccounting;
                SourceExpr="No.";
                Style=Strong;
                StyleExpr=Emphasize }

    { 14  ;2   ;Field     ;
                Name=Name;
                ToolTipML=[DAN=Angiver navnet pÜ omkostningstypen.;
                           ENU=Specifies the name of the cost type.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Name;
                Style=Strong;
                StyleExpr=Emphasize }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bevëgelsen pÜ kontosaldoen i den periode, der er indtastet i feltet Datofilter.;
                           ENU=Specifies the net change in the account balance during the time period in the Date Filter field.];
                ApplicationArea=#CostAccounting;
                BlankZero=Yes;
                SourceExpr="Net Change";
                Style=Strong;
                StyleExpr=Emphasize }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der reprësenterer debiteringer.;
                           ENU=Specifies the total of the ledger entries that represent debits.];
                ApplicationArea=#CostAccounting;
                BlankNumbers=BlankNegAndZero;
                SourceExpr="Debit Amount";
                Visible=FALSE;
                Style=Strong;
                StyleExpr=Emphasize }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der reprësenterer krediteringer.;
                           ENU=Specifies the total of the ledger entries that represent credits.];
                ApplicationArea=#CostAccounting;
                BlankNumbers=BlankNegAndZero;
                SourceExpr="Credit Amount";
                Visible=FALSE;
                Style=Strong;
                StyleExpr=Emphasize }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver enten omkostningstypens samlede budget, eller, hvis du har angivet et filter i feltet Budgetfilter, et filtreret budget. Indholdet af feltet beregnes ved at bruge posterne i feltet Belõb i tabellen Omkostningsbudgetpost.;
                           ENU=Specifies either the cost type's total budget or, if you have specified a filter in the Budget Filter field, a filtered budget. The contents of the field are calculated by using the entries in the Amount field in the Cost Budget Entry table.];
                ApplicationArea=#CostAccounting;
                BlankZero=Yes;
                SourceExpr="Budget Amount";
                Style=Strong;
                StyleExpr=Emphasize;
                OnValidate=BEGIN
                             CalcFormFields;
                           END;
                            }

    { 19  ;2   ;Field     ;
                CaptionML=[DAN=Saldo/budget (%);
                           ENU=Balance/Budget (%)];
                ToolTipML=[DAN=Angiver saldoen som en procentdel af det budgetterede belõb.;
                           ENU=Specifies the balance as a percentage of the budgeted amount.];
                ApplicationArea=#CostAccounting;
                DecimalPlaces=1:1;
                BlankZero=Yes;
                SourceExpr=BudgetPct;
                Editable=FALSE }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1900383207;1;Part   ;
                ApplicationArea=#CostAccounting;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                ApplicationArea=#CostAccounting;
                Visible=FALSE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      PeriodType@1000 : 'Day,Week,Month,Quarter,Year,Accounting Period';
      AmountType@1001 : 'Net Change,Balance at Date';
      BudgetPct@1003 : Decimal;
      Emphasize@1004 : Boolean INDATASET;
      NameIndent@1006 : Integer INDATASET;
      BudgetFilter@1002 : Code[10];
      CostCenterFilter@1008 : Text[1024];
      CostObjectFilter@1007 : Text[1024];
      DateFilter@1005 : Text;

    LOCAL PROCEDURE FindPeriod@1(SearchText@1000 : Code[3]);
    VAR
      Calendar@1001 : Record 2000000007;
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
      DateFilter := GETFILTER("Date Filter");
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE CalcFormFields@2();
    BEGIN
      SETFILTER("Budget Filter",BudgetFilter);
      SETFILTER("Cost Center Filter",CostCenterFilter);
      SETFILTER("Cost Object Filter",CostObjectFilter);

      CALCFIELDS("Net Change","Budget Amount");
      IF "Budget Amount" = 0 THEN
        BudgetPct := 0
      ELSE
        BudgetPct := ROUND("Net Change" / "Budget Amount" * 100);
    END;

    BEGIN
    END.
  }
}

