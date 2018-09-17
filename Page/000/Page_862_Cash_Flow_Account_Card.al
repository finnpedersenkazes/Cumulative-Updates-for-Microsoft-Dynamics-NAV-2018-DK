OBJECT Page 862 Cash Flow Account Card
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Pengestr›mskontokort;
               ENU=Cash Flow Account Card];
    SourceTable=Table841;
    PageType=Card;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1024    ;1   ;ActionGroup;
                      CaptionML=[DAN=K&onto;
                                 ENU=A&ccount];
                      Image=ChartOfAccounts }
      { 1026    ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=Poster;
                                 ENU=Entries];
                      ToolTipML=[DAN="F† vist eksisterende poster for pengestr›mskontoen. ";
                                 ENU="View the entries that exist for the cash flow account. "];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 850;
                      RunPageView=SORTING(Cash Flow Account No.);
                      RunPageLink=Cash Flow Account No.=FIELD(No.);
                      Image=Entries }
      { 1027    ;2   ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 848;
                      RunPageLink=Table Name=CONST(Cash Flow Account),
                                  No.=FIELD(No.);
                      Image=ViewComments }
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
                SourceExpr="No." }

    { 1003;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† pengestr›mskontoen.;
                           ENU=Specifies the name of the cash flow account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Name }

    { 1005;2   ;Field     ;
                ToolTipML=[DAN=Angiver form†let med pengestr›mskontoen. Nyoprettede pengestr›mskonti f†r automatisk tildelt kontotypen Post, men dette kan ‘ndres.;
                           ENU=Specifies the purpose of the cash flow account. Newly created cash flow accounts are automatically assigned the Entry account type, but you can change this.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Account Type" }

    { 1007;2   ;Field     ;
                ToolTipML=[DAN=Angiver et kontointerval eller en oversigt over kontonumre. Posterne for kontoen samment‘lles for at give en balancesum. Hvordan poster samment‘lles afh‘nger af v‘rdien i feltet Kontotype.;
                           ENU=Specifies an account interval or a list of account numbers. The entries of the account will be totaled to give a total balance. How entries are totaled depends on the value in the Account Type field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Totaling }

    { 1009;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal tomme linjer, der skal inds‘ttes i diagrammet over pengestr›mskonti, f›r denne pengestr›mskonto.;
                           ENU=Specifies the number of blank lines that you want to be inserted before this cash flow account in the chart of cash flow accounts.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No. of Blank Lines" }

    { 1011;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om du vil starte en ny side direkte efter denne pengestr›mskonto, n†r du udskriver diagrammet over pengestr›mskonti.;
                           ENU=Specifies if you want a new page to start immediately after this cash flow account when you print the chart of cash flow accounts.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="New Page" }

    { 1013;2   ;Field     ;
                ToolTipML=[DAN=Angiver et alternativt navn, du kan bruge til at s›ge efter den ›nskede record, hvis du ikke kan huske v‘rdien i feltet Navn.;
                           ENU=Specifies an alternate name that you can use to search for the record in question when you cannot remember the value in the Name field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Search Name" }

    { 1015;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den relaterede record er forhindret i kunne bogf›res under transaktioner - eksempelvis en debitor, som er erkl‘ret insolvent, eller en vare, som er sat i karant‘ne.;
                           ENU=Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Blocked }

    { 1017;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kildetype, der g‘lder for det kildenummer, der vises i feltet Kildenr.;
                           ENU=Specifies the source type that applies to the source number that is shown in the Source No. field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Source Type";
                Importance=Promoted }

    { 1019;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om pengestr›mskontoen er integreret med finans. N†r en pengestr›mskonto er integreret med finans, bruges enten saldiene for finanskontiene eller deres budgetterede v‘rdier i pengestr›msprognosen.;
                           ENU=Specifies if the cash flow account has integration with the general ledger. When a cash flow account has integration with the general ledger, either the balances of the general ledger accounts or their budgeted values are used in the cash flow forecast.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="G/L Integration";
                Importance=Promoted }

    { 1   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at kun pengestr›msposter, der er registrerede i de filtrerede finanskonti, er inkluderet i pengestr›msprognosen.;
                           ENU=Specifies that only the cash flow entries that are registered to the filtered general ledger accounts are included in the cash flow forecast.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="G/L Account Filter" }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1905767507;1;Part   ;
                ApplicationArea=#Basic,#Suite;
                Visible=TRUE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {

    BEGIN
    END.
  }
}

