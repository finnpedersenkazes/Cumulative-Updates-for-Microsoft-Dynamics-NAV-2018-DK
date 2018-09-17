OBJECT Page 851 Chart of Cash Flow Accounts
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Pengestr›mskontoplan;
               ENU=Chart of Cash Flow Accounts];
    SourceTable=Table841;
    PageType=List;
    CardPageID=Cash Flow Account Card;
    RefreshOnActivate=Yes;
    OnAfterGetRecord=BEGIN
                       NameIndent := 0;
                       NoOnFormat;
                       NameOnFormat;
                     END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1020    ;1   ;ActionGroup;
                      CaptionML=[DAN=K&onto;
                                 ENU=A&ccount];
                      Image=ChartOfAccounts }
      { 1022    ;2   ;Action    ;
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
      { 1023    ;2   ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 848;
                      RunPageLink=Table Name=CONST(Cash Flow Account),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1018    ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 1019    ;2   ;Action    ;
                      CaptionML=[DAN=Indryk diagram over pengestr›mskonti;
                                 ENU=Indent Chart of Cash Flow Accounts];
                      ToolTipML=[DAN=Indryk r‘kker efter hierarki, og valid‚r diagrammet for pengestr›mskonti.;
                                 ENU=Indent rows per the hierarchy and validate the chart of cash flow accounts.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 849;
                      Promoted=Yes;
                      Image=IndentChartOfAccounts;
                      PromotedCategory=Process }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1000;1   ;Group     ;
                IndentationColumnName=NameIndent;
                IndentationControls=Name;
                GroupType=Repeater }

    { 1001;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No.";
                Style=Strong;
                StyleExpr=NoEmphasize }

    { 1003;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† pengestr›mskontoen.;
                           ENU=Specifies the name of the cash flow account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Name;
                Style=Strong;
                StyleExpr=NameEmphasize }

    { 1005;2   ;Field     ;
                ToolTipML=[DAN=Angiver form†let med pengestr›mskontoen. Nyoprettede pengestr›mskonti f†r automatisk tildelt kontotypen Post, men dette kan ‘ndres.;
                           ENU=Specifies the purpose of the cash flow account. Newly created cash flow accounts are automatically assigned the Entry account type, but you can change this.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Account Type" }

    { 1007;2   ;Field     ;
                ToolTipML=[DAN=Angiver et kontointerval eller en oversigt over kontonumre. Posterne for kontoen samment‘lles for at give en balancesum. Hvordan poster samment‘lles afh‘nger af v‘rdien i feltet Kontotype.;
                           ENU=Specifies an account interval or a list of account numbers. The entries of the account will be totaled to give a total balance. How entries are totaled depends on the value in the Account Type field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Totaling;
                OnLookup=VAR
                           CFAccList@1000 : Page 855;
                         BEGIN
                           CFAccList.LOOKUPMODE(TRUE);
                           IF NOT (CFAccList.RUNMODAL = ACTION::LookupOK) THEN
                             EXIT(FALSE);

                           Text := CFAccList.GetSelectionFilter;
                           EXIT(TRUE);
                         END;
                          }

    { 1009;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kildetype, der g‘lder for det kildenummer, der vises i feltet Kildenr.;
                           ENU=Specifies the source type that applies to the source number that is shown in the Source No. field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Source Type";
                Visible=FALSE }

    { 1011;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om pengestr›mskontoen er integreret med finans. N†r en pengestr›mskonto er integreret med finans, bruges enten saldiene for finanskontiene eller deres budgetterede v‘rdier i pengestr›msprognosen.;
                           ENU=Specifies if the cash flow account has integration with the general ledger. When a cash flow account has integration with the general ledger, either the balances of the general ledger accounts or their budgeted values are used in the cash flow forecast.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="G/L Integration";
                Visible=FALSE }

    { 1013;2   ;Field     ;
                ToolTipML=[DAN=Angiver pengestr›msbel›bet.;
                           ENU=Specifies the cash flow amount.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Amount;
                Editable=FALSE }

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
    VAR
      NoEmphasize@1000 : Boolean INDATASET;
      NameEmphasize@1001 : Boolean INDATASET;
      NameIndent@1002 : Integer INDATASET;

    LOCAL PROCEDURE NoOnFormat@1000();
    BEGIN
      NoEmphasize := "Account Type" <> "Account Type"::Entry;
    END;

    LOCAL PROCEDURE NameOnFormat@1001();
    BEGIN
      NameIndent := Indentation;
      NameEmphasize := "Account Type" <> "Account Type"::Entry;
    END;

    BEGIN
    END.
  }
}

