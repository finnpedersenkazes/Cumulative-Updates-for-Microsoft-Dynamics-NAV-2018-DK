OBJECT Page 847 Cash Flow Forecast Card
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Pengestr›msprognosekort;
               ENU=Cash Flow Forecast Card];
    SourceTable=Table840;
    PageType=Card;
    OnInit=BEGIN
             ConsiderPmtDiscTolDateEnable := TRUE;
           END;

    OnAfterGetRecord=BEGIN
                       UpdateEnabled;
                     END;

    OnNewRecord=BEGIN
                  UpdateEnabled;
                END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1032    ;1   ;ActionGroup;
                      CaptionML=[DAN=&Pengestr›msprognose;
                                 ENU=&Cash Flow Forecast];
                      Image=CashFlow }
      { 1034    ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=P&oster;
                                 ENU=E&ntries];
                      ToolTipML=[DAN=F† vist poster for pengestr›mskontoen.;
                                 ENU=View entries for the cash flow account.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 850;
                      RunPageLink=Cash Flow Forecast No.=FIELD(No.);
                      Image=Entries }
      { 1035    ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=&Statistik;
                                 ENU=&Statistics];
                      ToolTipML=[DAN=F† vist detaljerede historiske oplysninger for pengestr›msprognosen.;
                                 ENU=View detailed historical information for the cash flow forecast.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 868;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 1036    ;2   ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 848;
                      RunPageLink=Table Name=CONST(Cash Flow Forecast),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 1037    ;2   ;Separator ;
                      CaptionML=[DAN="";
                                 ENU=""] }
      { 1038    ;2   ;Action    ;
                      CaptionML=[DAN=Pengestr›m pr. periode;
                                 ENU=CF &Availability by Periods];
                      ToolTipML=[DAN=F† vist en oversigt, man kan rulle igennem og f† vist budgetterede m‘ngder efter kildetype og efter periode. R‘kkerne repr‘senterer de enkelte perioder, og kolonnerne repr‘senterer kildetyperne i pengestr›msprognosen.;
                                 ENU=View a scrollable summary of the forecasted amounts per source type, by period. The rows represent individual periods, and the columns represent the source types in the cash flow forecast.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 867;
                      RunPageLink=No.=FIELD(No.);
                      Image=ShowMatrix }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 2       ;1   ;Action    ;
                      Name=CashFlowWorksheet;
                      CaptionML=[DAN=Pengestr›mskladde;
                                 ENU=Cash Flow Worksheet];
                      ToolTipML=[DAN=F† et overblik over ind- og udg†ende pengestr›mme, og opret en kortfristet prognose, der forudsiger, hvordan og hvorn†r du kan forvente at modtage penge og betale penge i din virksomhed.;
                                 ENU=Get an overview of cash inflows and outflows and create a short-term forecast that predicts how and when you expect money to be received and paid out by your business.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 841;
                      Promoted=Yes;
                      Image=Worksheet2;
                      PromotedCategory=Process }
      { 1039    ;1   ;ActionGroup;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      Image=Print }
      { 1040    ;2   ;Action    ;
                      Name=CashFlowDateList;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Pengestr›ms&datoliste;
                                 ENU=Cash Flow &Date List];
                      ToolTipML=[DAN=F† vist prognoseposter for en periode, du angiver. De registrerede pengestr›msprognoseposter organiseres efter kildetyper, f.eks. tilgodehavender, salgsordrer, skyldige bel›b og k›bsordrer. Du angiver antal perioder og l‘ngden af dem.;
                                 ENU=View forecast entries for a period of time that you specify. The registered cash flow forecast entries are organized by source types, such as receivables, sales orders, payables, and purchase orders. You specify the number of periods and their length.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=VAR
                                 CashFlowForecast@1002 : Record 840;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(CashFlowForecast);
                                 CashFlowForecast.PrintRecords;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1000;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 1001;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No.";
                OnAssistEdit=BEGIN
                               IF AssistEdit(xRec) THEN
                                 CurrPage.UPDATE;
                             END;
                              }

    { 1003;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af pengestr›msprognosen.;
                           ENU=Specifies a description of the cash flow forecast.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description;
                Importance=Promoted }

    { 1005;2   ;Field     ;
                ToolTipML=[DAN=Angiver en yderligere beskrivelse af en prognose.;
                           ENU=Specifies an additional description of a forecast.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Description 2" }

    { 1007;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om du vil medtage kontantrabatter, der er tildelt i poster og bilag i pengestr›msprognosen.;
                           ENU=Specifies if you want to include the cash discounts that are assigned in entries and documents in cash flow forecast.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Consider Discount";
                OnValidate=BEGIN
                             UpdateEnabled;
                           END;
                            }

    { 1023;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om kontantrabattolerancedatoen skal kontrolleres, n†r pengestr›msdatoen beregnes. Hvis markeringen i afkrydsningsfeltet fjernes, bruges forfaldsdatoen eller kontantrabatdatoen fra debitoren og kreditorposter og salgsordre eller k›bsordre.;
                           ENU=Specifies if the payment discount tolerance date is considered when the cash flow date is calculated. If the check box is cleared, the due date or payment discount date from the customer and vendor ledger entries and the sales order or purchase order are used.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Consider Pmt. Disc. Tol. Date";
                Enabled=ConsiderPmtDiscTolDateEnable }

    { 1025;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om betalingstolerancebel›bene fra de beregnede debitor- og kreditorposter skal bruges i pengestr›msprognosen. Hvis markeringen i afkrydsningsfeltet fjernes, bruges bel›bet uden noget betalingstolerancebel›b fra debitor- og kreditorposterne.;
                           ENU=Specifies if the payment tolerance amounts from the posted customer and vendor ledger entries are used in the cash flow forecast. If the check box is cleared, the amount without any payment tolerance amount from the customer and vendor ledger entries are used.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Consider Pmt. Tol. Amount" }

    { 1021;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om du vil bruge pengestr›msbetalingsbetingelser til pengestr›msprognose. Pengestr›msbetalingsbetingelser tilsides‘tter de standardbetalingsbetingelser, du har defineret for debitorer, kreditorer og ordrer. De tilsides‘tter ogs† de betalingsbetingelser, du har indtastet manuelt i poster eller bilag.;
                           ENU=Specifies if you want to use cash flow payment terms for cash flow forecast. Cash flow payment terms overrule the standard payment terms that you have defined for customers, vendors, and orders. They also overrule the payment terms that you have manually entered on entries or documents.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Consider CF Payment Terms" }

    { 1   ;2   ;Field     ;
                Name=ShowInChart;
                CaptionML=[DAN=Vis i diagram i rollecenter;
                           ENU=Show in Chart on Role Center];
                ToolTipML=[DAN=Angiver pengestr›msprognosediagrammet p† siden Rollecenter.;
                           ENU=Specifies the cash flow forecast chart on the Role Center page.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ShowInChart;
                OnValidate=BEGIN
                             IF NOT ValidateShowInChart(ShowInChart) THEN;
                             CurrPage.UPDATE;
                           END;
                            }

    { 1009;2   ;Field     ;
                ToolTipML=[DAN=Angiver et alternativt navn, du kan bruge til at s›ge efter den ›nskede record, hvis du ikke kan huske v‘rdien i feltet Navn.;
                           ENU=Specifies an alternate name that you can use to search for the record in question when you cannot remember the value in the Name field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Search Name" }

    { 1011;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor prognosen blev oprettet.;
                           ENU=Specifies the date that the forecast was created.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Creation Date";
                Editable=FALSE }

    { 1013;2   ;Field     ;
                ToolTipML=[DAN=Angiver den bruger, der oprettede prognosen.;
                           ENU=Specifies the user who created the forecast.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Created By";
                Editable=FALSE }

    { 1017;2   ;Field     ;
                ToolTipML=[DAN=Angiver den startdato, hvorfra du vil bruge budgetv‘rdierne fra finans i pengestr›msprognosen.;
                           ENU=Specifies the starting date from which you want to use the budget values from the general ledger in the cash flow forecast.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="G/L Budget From" }

    { 1019;2   ;Field     ;
                ToolTipML=[DAN=Angiver den sidste dato, p† hvilken du vil bruge budgetv‘rdierne fra finans i pengestr›msprognosen.;
                           ENU=Specifies the last date to which you want to use the budget values from the general ledger in the cash flow forecast.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="G/L Budget To" }

    { 1029;2   ;Field     ;
                ToolTipML=[DAN=Angiver en startdato, fra hvilken manuelle betalinger skal medtages i pengestr›msprognosen.;
                           ENU=Specifies a starting date from which manual payments should be included in cash flow forecast.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Manual Payments From" }

    { 1027;2   ;Field     ;
                ToolTipML=[DAN=Angiver en startdato, hvortil manuelle betalinger skal medtages i pengestr›msprognosen.;
                           ENU=Specifies a starting date to which manual payments should be included in cash flow forecast.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Manual Payments To" }

    { 3   ;2   ;Field     ;
                CaptionML=[DAN=Flyt forfaldne pengestr›msdatoer til arbejdsdato;
                           ENU=Move Overdue Cash Flow Dates to Work Date];
                ToolTipML=[DAN=Angiver, om du vil ‘ndre overskredne datoer til den aktuelle arbejdsdato for pengestr›msprognosen. Mark‚r feltet, hvis denne prognose vises i prognosediagrammet.;
                           ENU=Specifies if you want to change overdue dates to the current work date for the cash flow forecast. Choose the field if this forecast is shown in the forecast chart.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Overdue CF Dates to Work Date" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det finansbudget, der skal bruges ved genberegning af pengestr›msprognosen.;
                           ENU=Specifies the general ledger budget to be used when recalculating the cash flow forecast.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Default G/L Budget Name" }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1905906307;1;Part   ;
                ApplicationArea=#Basic,#Suite;
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page840;
                Visible=TRUE;
                PartType=Page }

    { 1905767507;1;Part   ;
                ApplicationArea=#Basic,#Suite;
                Visible=TRUE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      ConsiderPmtDiscTolDateEnable@19003948 : Boolean INDATASET;
      ShowInChart@1000 : Boolean;

    LOCAL PROCEDURE UpdateEnabled@1000();
    BEGIN
      ConsiderPmtDiscTolDateEnable := "Consider Discount";
      ShowInChart := GetShowInChart;
    END;

    BEGIN
    END.
  }
}

