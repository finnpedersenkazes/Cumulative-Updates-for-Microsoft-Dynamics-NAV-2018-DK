OBJECT Page 7114 Analysis Columns
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846,NAVDK11.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Analysekolonner;
               ENU=Analysis Columns];
    SourceTable=Table7118;
    DelayedInsert=Yes;
    DataCaptionFields=Analysis Area;
    PageType=Worksheet;
    AutoSplitKey=Yes;
    OnOpenPage=BEGIN
                 AnalysisRepMgmt.OpenColumns2(CurrentColumnName,Rec);
               END;

    OnAfterGetRecord=BEGIN
                       ItemLedgerEntryTypeFilterOnFor(FORMAT("Item Ledger Entry Type Filter"));
                       ValueEntryTypeFilterOnFormat(FORMAT("Value Entry Type Filter"));
                     END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 32  ;1   ;Field     ;
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver navnet p† recorden.;
                           ENU=Specifies the name of the record.];
                ApplicationArea=#Suite;
                SourceExpr=CurrentColumnName;
                OnValidate=BEGIN
                             AnalysisRepMgmt.GetColumnTemplate(GETRANGEMAX("Analysis Area"),CurrentColumnName);
                             CurrentColumnNameOnAfterValida;
                           END;

                OnLookup=BEGIN
                           CurrPage.SAVERECORD;
                           IF AnalysisRepMgmt.LookupColumnName(
                                GETRANGEMAX("Analysis Area"),CurrentColumnName)
                           THEN BEGIN
                             Text := CurrentColumnName;
                             EXIT(TRUE);
                           END;
                         END;
                          }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et nummer til kolonnen i analysevisningen.;
                           ENU=Specifies a number for the column in the analysis view.];
                ApplicationArea=#Suite;
                SourceExpr="Column No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et kolonnehoved, som du ›nsker det vist i rapportudskrifter.;
                           ENU=Specifies a header for the column as you want it to appear on printed reports.];
                ApplicationArea=#Suite;
                SourceExpr="Column Header" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det filter, der bruges p† den vareposttype, som kolonnen skal beregnes over.;
                           ENU=Specifies the filter that applies to the item ledger entry type that you want this column to be calculated from.];
                ApplicationArea=#SalesAnalysis,#PurchaseAnalysis;
                SourceExpr="Item Ledger Entry Type Filter";
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det filter, der bruges p† den v‘rdiposttype, som kolonnen skal beregnes over.;
                           ENU=Specifies the filter that applies to the item value entry type that you want this column to be calculated from.];
                ApplicationArea=#SalesAnalysis,#PurchaseAnalysis;
                SourceExpr="Value Entry Type Filter";
                Visible=FALSE }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om du vil have analyserapporten til at v‘re baseret p† fakturerede bel›b. Hvis feltet ikke udfyldes, bliver rapporten baseret p† forventede bel›b.;
                           ENU=Specifies if you want the analysis report to be based on invoiced amounts. If left field blank, the report will be based on expected amounts.];
                ApplicationArea=#Suite;
                SourceExpr=Invoiced }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver analysekolonnetypen, som bestemmer, hvordan bel›bene i kolonnen beregnes.;
                           ENU=Specifies the analysis column type, which determines how the amounts in the column are calculated.];
                ApplicationArea=#Suite;
                SourceExpr="Column Type" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilke posttyper der skal medtages i bel›bene i analysekolonnen.;
                           ENU=Specifies the type of ledger entries that will be included in the amounts in the analysis column.];
                ApplicationArea=#Suite;
                SourceExpr="Ledger Entry Type" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en formel for, hvordan data vises i kolonnen, n†r analyserapporten udskrives.;
                           ENU=Specifies a formula for how data is shown in the column when the analysis report is printed.];
                ApplicationArea=#Suite;
                SourceExpr=Formula }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om du vil have vist k›b og opreguleringer som negative bel›b og salg og nedreguleringer som positive bel›b.;
                           ENU=Specifies if you want purchases and positive adjustments to be shown as negative amounts and sales and negative adjustments to be shown as positive amounts.];
                ApplicationArea=#Suite;
                SourceExpr="Show Opposite Sign" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en datoformel, der angiver de datoer, som skal bruges til at beregne bel›bet i kolonnen.;
                           ENU=Specifies a date formula that specifies which dates should be used to calculate the amount in this column.];
                ApplicationArea=#Suite;
                SourceExpr="Comparison Date Formula" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den analysetype, der skal g‘lde for kolonnen.;
                           ENU=Specifies the analysis type to apply to the column.];
                ApplicationArea=#Suite;
                SourceExpr="Analysis Type Code" }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver de kildedata, som kildedatatypen i feltet Analysetypekode i vinduet Analysekolonner er baseret p†.;
                           ENU=Specifies the source data that the source data type in the Analysis Type Code field, in the Analysis Columns window, is based on.];
                ApplicationArea=#Suite;
                SourceExpr="Value Type" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn†r bel›bene i kolonnen skal vises i rapporter.;
                           ENU=Specifies when you want the amounts in the column to be shown in reports.];
                ApplicationArea=#Suite;
                SourceExpr=Show }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en afrundingsfaktor for bel›bene i kolonnen.;
                           ENU=Specifies a rounding factor for the amounts in the column.];
                ApplicationArea=#Suite;
                SourceExpr="Rounding Factor" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en periodeformel for de regnskabsperioder, der skal bruges til at beregne bel›bet i kolonnen.;
                           ENU=Specifies a period formula that specifies the accounting periods you want to use to calculate the amount in this column.];
                ApplicationArea=#Suite;
                SourceExpr="Comparison Period Formula" }

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
      AnalysisRepMgmt@1002 : Codeunit 7110;
      CurrentColumnName@1000 : Code[10];

    [External]
    PROCEDURE SetCurrentColumnName@2(ColumnlName@1000 : Code[10]);
    BEGIN
      CurrentColumnName := ColumnlName;
    END;

    LOCAL PROCEDURE CurrentColumnNameOnAfterValida@19064415();
    BEGIN
      CurrPage.SAVERECORD;
      AnalysisRepMgmt.SetColumnName(GETRANGEMAX("Analysis Area"),CurrentColumnName,Rec);
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE ItemLedgerEntryTypeFilterOnFor@19057852(Text@19023721 : Text[1024]);
    BEGIN
      Text := "Item Ledger Entry Type Filter";
      AnalysisRepMgmt.ValidateFilter(Text,DATABASE::"Analysis Column",FIELDNO("Item Ledger Entry Type Filter"),FALSE);
    END;

    LOCAL PROCEDURE ValueEntryTypeFilterOnFormat@19005352(Text@19013503 : Text[1024]);
    BEGIN
      Text := "Value Entry Type Filter";
      AnalysisRepMgmt.ValidateFilter(Text,DATABASE::"Analysis Column",FIELDNO("Value Entry Type Filter"),FALSE);
    END;

    BEGIN
    END.
  }
}

