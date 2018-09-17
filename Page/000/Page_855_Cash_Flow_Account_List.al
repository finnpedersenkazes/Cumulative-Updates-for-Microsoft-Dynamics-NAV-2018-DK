OBJECT Page 855 Cash Flow Account List
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Pengestr›mskontooversigt;
               ENU=Cash Flow Account List];
    SourceTable=Table841;
    PageType=List;
    CardPageID=Cash Flow Account Card;
    OnAfterGetRecord=BEGIN
                       NameIndent := 0;
                       NameOnFormat;
                     END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1016    ;1   ;ActionGroup;
                      CaptionML=[DAN=K&onto;
                                 ENU=A&ccount];
                      Image=ChartOfAccounts }
      { 1018    ;2   ;Action    ;
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
      { 1019    ;2   ;Action    ;
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
                IndentationColumnName=NameIndent;
                IndentationControls=Name;
                GroupType=Repeater }

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
                ToolTipML=[DAN=Angiver bem‘rkningen for recorden.;
                           ENU=Specifies the comment for the record.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Comment }

    { 1009;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den relaterede record er forhindret i kunne bogf›res under transaktioner - eksempelvis en debitor, som er erkl‘ret insolvent, eller en vare, som er sat i karant‘ne.;
                           ENU=Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Blocked }

    { 1011;2   ;Field     ;
                ToolTipML=[DAN=Angiver pengestr›msbel›bet.;
                           ENU=Specifies the cash flow amount.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Amount }

    { 1   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kildetype, der g‘lder for det kildenummer, der vises i feltet Kildenr.;
                           ENU=Specifies the source type that applies to the source number that is shown in the Source No. field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Source Type";
                Visible=FALSE }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om pengestr›mskontoen er integreret med finans. N†r en pengestr›mskonto er integreret med finans, bruges enten saldiene for finanskontiene eller deres budgetterede v‘rdier i pengestr›msprognosen.;
                           ENU=Specifies if the cash flow account has integration with the general ledger. When a cash flow account has integration with the general ledger, either the balances of the general ledger accounts or their budgeted values are used in the cash flow forecast.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="G/L Integration";
                Visible=FALSE }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at kun pengestr›msposter, der er registrerede i de filtrerede finanskonti, er inkluderet i pengestr›msprognosen.;
                           ENU=Specifies that only the cash flow entries that are registered to the filtered general ledger accounts are included in the cash flow forecast.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="G/L Account Filter";
                Visible=FALSE }

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
      NameIndent@1002 : Integer INDATASET;

    [External]
    PROCEDURE SetSelection@1000(VAR CFAccount@1000 : Record 841);
    BEGIN
      CurrPage.SETSELECTIONFILTER(CFAccount);
    END;

    [External]
    PROCEDURE GetSelectionFilter@4() : Text;
    VAR
      CFAccount@1001 : Record 841;
      SelectionFilterManagement@1002 : Codeunit 46;
    BEGIN
      CurrPage.SETSELECTIONFILTER(CFAccount);
      EXIT(SelectionFilterManagement.GetSelectionFilterForCashFlowAccount(CFAccount));
    END;

    LOCAL PROCEDURE NameOnFormat@1003();
    BEGIN
      NameIndent := Indentation;
    END;

    BEGIN
    END.
  }
}

