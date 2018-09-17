OBJECT Page 489 Column Layout
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Kolonneformat;
               ENU=Column Layout];
    SourceTable=Table334;
    DataCaptionFields=Column Layout Name;
    PageType=Worksheet;
    AutoSplitKey=Yes;
    OnOpenPage=BEGIN
                 AccSchedManagement.OpenColumns(CurrentColumnName,Rec);
               END;

    OnAfterGetRecord=BEGIN
                       IF NOT DimCaptionsInitialized THEN
                         DimCaptionsInitialized := TRUE;
                     END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 18  ;1   ;Field     ;
                Lookup=Yes;
                AssistEdit=No;
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver navnet p† recorden.;
                           ENU=Specifies the name of the record.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=CurrentColumnName;
                TableRelation="Column Layout Name".Name;
                OnValidate=BEGIN
                             AccSchedManagement.CheckColumnName(CurrentColumnName);
                             CurrentColumnNameOnAfterValida;
                           END;

                OnLookup=BEGIN
                           EXIT(AccSchedManagement.LookupColumnName(CurrentColumnName,Text));
                         END;
                          }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjenummeret for kontoskemakolonnen.;
                           ENU=Specifies the line number for the account schedule column.];
                ApplicationArea=#Advanced;
                SourceExpr="Line No.";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et nummer til kolonnen i analysevisningen.;
                           ENU=Specifies a number for the column in the analysis view.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Column No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et hoved for kolonnen.;
                           ENU=Specifies a header for the column.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Column Header" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver analysekolonnetypen, som bestemmer, hvordan bel›bene i kolonnen beregnes.;
                           ENU=Specifies the analysis column type, which determines how the amounts in the column are calculated.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Column Type" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilke posttyper der skal medtages i bel›bene i kontoskemakolonnen.;
                           ENU=Specifies the type of ledger entries that will be included in the amounts in the account schedule column.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ledger Entry Type" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilke posttyper der skal medtages i bel›bene i kontoskemakolonnen.;
                           ENU=Specifies the type of entries that will be included in the amounts in the account schedule column.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Amount Type" }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en formel. Resultatet af formlen bliver vist i kolonnen, n†r kontoskemaet udskrives.;
                           ENU=Specifies a formula. The result of the formula will appear in the column when the account schedule is printed.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Formula }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om debiteringer skal vises som negative bel›b (alts† med et minustegn) og krediteringer som positive bel›b i rapporter.;
                           ENU=Specifies whether to show debits in reports as negative amounts (that is, with a minus sign) and credits as positive amounts.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Show Opposite Sign" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en datoformel, der angiver de datoer, som skal bruges til at beregne bel›bet i kolonnen.;
                           ENU=Specifies a date formula that specifies which dates should be used to calculate the amount in this column.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Comparison Date Formula" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en periodeformel for de regnskabsperioder, der skal bruges til at beregne bel›bet i kolonnen.;
                           ENU=Specifies a period formula that specifies the accounting periods you want to use to calculate the amount in this column.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Comparison Period Formula";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn†r bel›bene i kolonnen skal vises i rapporter.;
                           ENU=Specifies when you want the amounts in the column to be shown in reports.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Show }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at indrykkede linjer vises.;
                           ENU=Specifies that indented lines are shown.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Show Indented Lines";
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en afrundingsfaktor for bel›bene i kolonnen.;
                           ENU=Specifies a rounding factor for amounts in the column.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Rounding Factor" }

    { 37  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilke koncernvirksomhedsbel›b der vil blive sammentalt i kolonnen.;
                           ENU=Specifies which business unit amounts will be totaled in this column.];
                ApplicationArea=#Advanced;
                SourceExpr="Business Unit Totaling";
                Visible=FALSE }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilke dimensionsv‘rdibel›b der bliver lagt sammen i kolonnen. Hvis kolonnetypen er Formel, m† du ikke angive noget i dette felt. Hvis bel›bene p† linjen ikke skal v‘re filtreret efter dimension, b›r du lade feltet v‘re tomt.;
                           ENU=Specifies which dimension value amounts will be totaled in this column. If the column type of the column is Formula, you must not enter anything in this field. Also, if you do not wish the amounts on the line to be filtered by dimension, you should leave this field blank.];
                ApplicationArea=#Suite;
                SourceExpr="Dimension 1 Totaling";
                Visible=FALSE;
                OnLookup=BEGIN
                           EXIT(LookUpDimFilter(1,Text));
                         END;
                          }

    { 41  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilke dimensionsv‘rdibel›b der bliver lagt sammen i kolonnen. Hvis kolonnetypen er Formel, m† du ikke angive noget i dette felt. Hvis bel›bene p† linjen ikke skal v‘re filtreret efter dimension, b›r du lade feltet v‘re tomt.;
                           ENU=Specifies which dimension value amounts will be totaled in this column. If the column type of the column is Formula, you must not enter anything in this field. Also, if you do not wish the amounts on the line to be filtered by dimension, you should leave this field blank.];
                ApplicationArea=#Suite;
                SourceExpr="Dimension 2 Totaling";
                Visible=FALSE;
                OnLookup=BEGIN
                           EXIT(LookUpDimFilter(2,Text));
                         END;
                          }

    { 43  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilke dimensionsv‘rdibel›b der bliver lagt sammen i kolonnen. Hvis kolonnetypen er Formel, m† du ikke angive noget i dette felt. Hvis bel›bene p† linjen ikke skal v‘re filtreret efter dimension, b›r du lade feltet v‘re tomt.;
                           ENU=Specifies which dimension value amounts will be totaled in this column. If the column type is Formula, you must not enter anything in this field. Also, if you do not wish the amounts on the line to be filtered by dimension, you should leave this field blank.];
                ApplicationArea=#Suite;
                SourceExpr="Dimension 3 Totaling";
                Visible=FALSE;
                OnLookup=BEGIN
                           EXIT(LookUpDimFilter(3,Text));
                         END;
                          }

    { 45  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilke dimensionsv‘rdibel›b der bliver lagt sammen i kolonnen. Hvis kolonnetypen er Formel, m† du ikke angive noget i dette felt. Hvis bel›bene p† linjen ikke skal v‘re filtreret efter dimension, b›r du lade feltet v‘re tomt.;
                           ENU=Specifies which dimension value amounts will be totaled in this column. If the column type is Formula, you must not enter anything in this field. Also, if you do not wish the amounts on the line to be filtered by dimension, you should leave this field blank.];
                ApplicationArea=#Suite;
                SourceExpr="Dimension 4 Totaling";
                Visible=FALSE;
                OnLookup=BEGIN
                           EXIT(LookUpDimFilter(4,Text));
                         END;
                          }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilke omkostningsstedsbel›b der vil blive sammentalt i kolonnen.;
                           ENU=Specifies which cost center amounts will be totaled in this column.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Cost Center Totaling";
                Visible=FALSE;
                OnLookup=VAR
                           CostCenter@1001 : Record 1112;
                         BEGIN
                           EXIT(CostCenter.LookupCostCenterFilter(Text));
                         END;
                          }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilke omkostningsemnebel›b der vil blive sammentalt i kolonnen.;
                           ENU=Specifies which cost object amounts will be totaled in this column.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Cost Object Totaling";
                Visible=FALSE;
                OnLookup=VAR
                           CostObject@1001 : Record 1113;
                         BEGIN
                           EXIT(CostObject.LookupCostObjectFilter(Text));
                         END;
                          }

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
      AccSchedManagement@1000 : Codeunit 8;
      CurrentColumnName@1001 : Code[10];
      DimCaptionsInitialized@1005 : Boolean;

    LOCAL PROCEDURE CurrentColumnNameOnAfterValida@19064415();
    BEGIN
      CurrPage.SAVERECORD;
      AccSchedManagement.SetColumnName(CurrentColumnName,Rec);
      CurrPage.UPDATE(FALSE);
    END;

    [External]
    PROCEDURE SetColumnLayoutName@1(NewColumnName@1000 : Code[10]);
    BEGIN
      CurrentColumnName := NewColumnName;
    END;

    BEGIN
    END.
  }
}

