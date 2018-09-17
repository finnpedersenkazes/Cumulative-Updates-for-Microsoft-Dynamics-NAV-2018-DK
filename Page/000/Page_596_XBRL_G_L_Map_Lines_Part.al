OBJECT Page 596 XBRL G/L Map Lines Part
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846,NAVDK11.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=XBRL-finanskoblinglinjedel;
               ENU=XBRL G/L Map Lines Part];
    SourceTable=Table397;
    PageType=ListPart;
  }
  CONTROLS
  {
    { 3   ;0   ;Container ;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver de finanskonti, der skal bruges til at oprette de udl‘ste data, der findes i forekomstdokumentet. Det er kun bogf›ringskonti, der vil blive brugt.;
                           ENU=Specifies the general ledger accounts that will be used to generate the exported data contained in the instance document. Only posting accounts will be used.];
                ApplicationArea=#Suite;
                SourceExpr="G/L Account Filter" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver de koncernvirksomheder, der skal bruges til oprette de udl‘ste data, der findes i forekomstdokumentet.;
                           ENU=Specifies the business units that will be used to generate the exported data that is contained in the instance document.];
                ApplicationArea=#Suite;
                SourceExpr="Business Unit Filter";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p† analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg‘ngelige p† alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Dimensions;
                SourceExpr="Global Dimension 1 Filter";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver de dimensioner, som dataene vises efter. Globale dimensioner er knyttet til records eller poster med henblik p† analyse. To globale dimensioner, der typisk er for virksomhedens vigtigste aktiviteter, er tilg‘ngelige p† alle kort, dokumenter, rapporter og lister.;
                           ENU=Specifies the dimensions by which data is shown. Global dimensions are linked to records or entries for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Dimensions;
                SourceExpr="Global Dimension 2 Filter";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, sammen med startdatoen, periodel‘ngden og antallet af perioder, hvilket datointerval der vil blive knyttet til de finansoplysninger, der udl‘ses for denne linje.;
                           ENU=Specifies, along with the starting date, period length, and number of periods, what date range will be applied to the general ledger data exported for this line.];
                ApplicationArea=#XBRL;
                SourceExpr="Timeframe Type";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilke finansposter der medtages i det samlede bel›b, der beregnes i forbindelse med udl‘sning til forekomstdokumentet.;
                           ENU=Specifies which general ledger entries will be included in the total calculated for export to the instance document.];
                ApplicationArea=#XBRL;
                SourceExpr="Amount Type";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver enten debet eller kredit. Dette bestemmer, hvordan saldoen behandles under beregningen, og g›r det muligt, at saldi, der stemmer overens med typen Normal saldo, kan udl‘ses som positive v‘rdier. Hvis forekomstdokumentet f.eks. skal indeholde positive tal, skal alle finanskonti indeholde Kredit i dette felt.;
                           ENU=Specifies either debit or credit. This determines how the balance will be handled during calculation, allowing balances consistent with the Normal Balance type to be exported as positive values. For example, if you want the instance document to contain positive numbers, all G/L Accounts with a normal credit balance will need to have Credit selected for this field.];
                ApplicationArea=#XBRL;
                SourceExpr="Normal Balance";
                Visible=FALSE }

  }
  CODE
  {

    BEGIN
    END.
  }
}

