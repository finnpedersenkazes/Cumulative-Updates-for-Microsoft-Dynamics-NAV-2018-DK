OBJECT Page 7156 Purchase Analysis View Card
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=K›bsanalysevisningskort;
               ENU=Purch. Analysis View Card];
    SourceTable=Table7152;
    SourceTableView=WHERE(Analysis Area=CONST(Purchase));
    PageType=Card;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 6       ;1   ;ActionGroup;
                      CaptionML=[DAN=&Analyse;
                                 ENU=&Analysis];
                      Image=AnalysisView }
      { 38      ;2   ;Action    ;
                      CaptionML=[DAN=Filter;
                                 ENU=Filter];
                      ToolTipML=[DAN=Anvend filteret.;
                                 ENU=Apply the filter.];
                      ApplicationArea=#PurchaseAnalysis;
                      RunObject=Page 7152;
                      RunPageLink=Analysis Area=FIELD(Analysis Area),
                                  Analysis View Code=FIELD(Code);
                      Image=Filter }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 7       ;1   ;Action    ;
                      CaptionML=[DAN=&Opdater;
                                 ENU=&Update];
                      ToolTipML=[DAN=Hent de seneste poster i analysevisningen.;
                                 ENU=Get the latest entries into the analysis view.];
                      ApplicationArea=#PurchaseAnalysis;
                      RunObject=Codeunit 7150;
                      Promoted=Yes;
                      Image=Refresh;
                      PromotedCategory=Process }
      { 5       ;1   ;Action    ;
                      CaptionML=[DAN=Aktiv‚r opdatering ved bogf›ring;
                                 ENU=Enable Update on Posting];
                      ToolTipML=[DAN=S›rg for, at analysevisningen opdateres, n†r nye poster bogf›res.;
                                 ENU=Ensure that the analysis view is updated when new ledger entries are posted.];
                      ApplicationArea=#PurchaseAnalysis;
                      Image=Apply;
                      OnAction=BEGIN
                                 SetUpdateOnPosting(TRUE);
                               END;
                                }
      { 3       ;1   ;Action    ;
                      CaptionML=[DAN=Deaktiver opdatering ved bogf›ring;
                                 ENU=Disable Update on Posting];
                      ToolTipML=[DAN=S›rg for, at analysevisningen ikke opdateres, n†r nye poster bogf›res.;
                                 ENU=Ensure that the analysis view is not updated when new ledger entries are posted.];
                      ApplicationArea=#PurchaseAnalysis;
                      Image=UnApply;
                      OnAction=BEGIN
                                 SetUpdateOnPosting(FALSE);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for analysevisningen.;
                           ENU=Specifies a code for the analysis view.];
                ApplicationArea=#PurchaseAnalysis;
                SourceExpr=Code }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† analysevisningen.;
                           ENU=Specifies the name of the analysis view.];
                ApplicationArea=#PurchaseAnalysis;
                SourceExpr=Name }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et filter til at definere, hvilke varer der skal inkluderes i analysevisningen.;
                           ENU=Specifies a filter to specify the items that will be included in an analysis view.];
                ApplicationArea=#PurchaseAnalysis;
                SourceExpr="Item Filter";
                OnLookup=VAR
                           ItemList@1002 : Page 31;
                         BEGIN
                           ItemList.LOOKUPMODE(TRUE);
                           IF NOT (ItemList.RUNMODAL = ACTION::LookupOK) THEN BEGIN
                             Text := ItemList.GetSelectionFilter;
                             EXIT(TRUE);
                           END;
                         END;
                          }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et lokationsfilter for at angive, at det kun er poster bogf›rt for en bestemt lokation, som skal inkluderes i en analysevisning.;
                           ENU=Specifies a location filter to specify that only entries posted to a particular location are to be included in an analysis view.];
                ApplicationArea=#Location;
                SourceExpr="Location Filter";
                OnLookup=VAR
                           LocList@1000 : Page 15;
                         BEGIN
                           LocList.LOOKUPMODE(TRUE);
                           IF LocList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                             Text := LocList.GetSelectionFilter;
                             EXIT(TRUE);
                           END;
                         END;
                          }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den periode, hvorfra der kombineres poster for at oprette en samlet post for den p†g‘ldende periode.;
                           ENU=Specifies the period that the program will combine entries for, in order to create a single entry for that time period.];
                ApplicationArea=#PurchaseAnalysis;
                SourceExpr="Date Compression" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvorfra der skal inkluderes vareposter i en analysevisning.;
                           ENU=Specifies the date from which item ledger entries will be included in an analysis view.];
                ApplicationArea=#PurchaseAnalysis;
                SourceExpr="Starting Date" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor analysevisningen sidst er opdateret.;
                           ENU=Specifies the date on which the analysis view was last updated.];
                ApplicationArea=#PurchaseAnalysis;
                SourceExpr="Last Date Updated" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den sidste varepost, du bogf›rte inden opdateringen af analysevisningen.;
                           ENU=Specifies the number of the last item ledger entry you posted, prior to updating the analysis view.];
                ApplicationArea=#PurchaseAnalysis;
                SourceExpr="Last Entry No." }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den sidste varebudgetpost, du indtastede inden opdateringen af analysevisningen.;
                           ENU=Specifies the number of the last item budget entry you entered prior to updating the analysis view.];
                ApplicationArea=#PurchaseBudget;
                SourceExpr="Last Budget Entry No." }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om analysevisningen opdateres, hver gang du bogf›rer en varepost, f.eks. fra en salgsfaktura.;
                           ENU=Specifies if the analysis view is updated every time that you post an item ledger entry, for example from a sales invoice.];
                ApplicationArea=#PurchaseAnalysis;
                SourceExpr="Update on Posting" }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om en opdatering af analysevisningsbudgetposter medtages, n†r du opdaterer en analysevisning.;
                           ENU=Specifies whether to include an update of analysis view budget entries, when updating an analysis view.];
                ApplicationArea=#PurchaseBudget;
                SourceExpr="Include Budgets" }

    { 41  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den relaterede record er forhindret i kunne bogf›res under transaktioner - eksempelvis en debitor, som er erkl‘ret insolvent, eller en vare, som er sat i karant‘ne.;
                           ENU=Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.];
                ApplicationArea=#PurchaseAnalysis;
                SourceExpr=Blocked }

    { 1900309501;1;Group  ;
                CaptionML=[DAN=Dimensioner;
                           ENU=Dimensions] }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en af de fire dimensioner, som du kan inkludere i en analysevisning.;
                           ENU=Specifies one of the four dimensions that you can include in an analysis view.];
                ApplicationArea=#Dimensions;
                SourceExpr="Dimension 1 Code" }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en af de fire dimensioner, som du kan inkludere i en analysevisning.;
                           ENU=Specifies one of the four dimensions that you can include in an analysis view.];
                ApplicationArea=#Dimensions;
                SourceExpr="Dimension 2 Code" }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en af de fire dimensioner, som du kan inkludere i en analysevisning.;
                           ENU=Specifies one of the four dimensions that you can include in an analysis view.];
                ApplicationArea=#Dimensions;
                SourceExpr="Dimension 3 Code" }

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

    BEGIN
    END.
  }
}

