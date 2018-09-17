OBJECT Page 555 Analysis View Card
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Analysevisningskort;
               ENU=Analysis View Card];
    SourceTable=Table363;
    PageType=Card;
    OnOpenPage=BEGIN
                 GLAccountSource := TRUE;
               END;

    OnAfterGetRecord=BEGIN
                       SetGLAccountSource;
                     END;

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
                      ApplicationArea=#Suite;
                      RunObject=Page 557;
                      RunPageLink=Analysis View Code=FIELD(Code);
                      Image=Filter }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 7       ;1   ;Action    ;
                      CaptionML=[DAN=&Opdater;
                                 ENU=&Update];
                      ToolTipML=[DAN=Hent de seneste poster i analysevisningen.;
                                 ENU=Get the latest entries into the analysis view.];
                      ApplicationArea=#Suite;
                      RunObject=Codeunit 410;
                      Promoted=Yes;
                      Image=Refresh;
                      PromotedCategory=Process;
                      PromotedOnly=Yes }
      { 3       ;1   ;Action    ;
                      CaptionML=[DAN=Aktiv‚r opdatering ved bogf›ring;
                                 ENU=Enable Update on Posting];
                      ToolTipML=[DAN=S›rg for, at analysevisningen opdateres, n†r nye poster bogf›res.;
                                 ENU=Ensure that the analysis view is updated when new ledger entries are posted.];
                      ApplicationArea=#Advanced;
                      Image=Apply;
                      OnAction=BEGIN
                                 SetUpdateOnPosting(TRUE);
                               END;
                                }
      { 5       ;1   ;Action    ;
                      CaptionML=[DAN=Deaktiver opdatering ved bogf›ring;
                                 ENU=Disable Update on Posting];
                      ToolTipML=[DAN=S›rg for, at analysevisningen ikke opdateres, n†r nye poster bogf›res.;
                                 ENU=Ensure that the analysis view is not updated when new ledger entries are posted.];
                      ApplicationArea=#Advanced;
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
                ToolTipML=[DAN=Angiver koden for dette kort.;
                           ENU=Specifies the code for this card.];
                ApplicationArea=#Suite;
                SourceExpr=Code }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet.;
                           ENU=Specifies the name.];
                ApplicationArea=#Suite;
                SourceExpr=Name }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN="Angiver en konto, du kan bruge som et filter til at definere, hvad der vises i vinduet Dimensionsanalyse. ";
                           ENU="Specifies an account that you can use as a filter to define what is displayed in the Analysis by Dimensions window. "];
                ApplicationArea=#Suite;
                SourceExpr="Account Source";
                OnValidate=BEGIN
                             SetGLAccountSource;
                           END;
                            }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilke konti der vises i analysevisningen.;
                           ENU=Specifies which accounts are shown in the analysis view.];
                ApplicationArea=#Suite;
                SourceExpr="Account Filter";
                OnLookup=VAR
                           GLAccList@1002 : Page 18;
                           CFAccList@1000 : Page 855;
                         BEGIN
                           IF "Account Source" = "Account Source"::"G/L Account" THEN BEGIN
                             GLAccList.LOOKUPMODE(TRUE);
                             IF NOT (GLAccList.RUNMODAL = ACTION::LookupOK) THEN
                               EXIT(FALSE);

                             Text := GLAccList.GetSelectionFilter;
                           END ELSE BEGIN
                             CFAccList.LOOKUPMODE(TRUE);
                             IF NOT (CFAccList.RUNMODAL = ACTION::LookupOK) THEN
                               EXIT(FALSE);

                             Text := CFAccList.GetSelectionFilter;
                           END;

                           EXIT(TRUE);
                         END;
                          }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den periode, hvorfra der kombineres poster for at oprette en samlet post for den p†g‘ldende periode.;
                           ENU=Specifies the period that the program will combine entries for, in order to create a single entry for that time period.];
                ApplicationArea=#Suite;
                SourceExpr="Date Compression" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startdatoen for kampagneanalysen.;
                           ENU=Specifies the starting date of the campaign analysis.];
                ApplicationArea=#Suite;
                SourceExpr="Starting Date" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor analysevisningen sidst er opdateret.;
                           ENU=Specifies the date on which the analysis view was last updated.];
                ApplicationArea=#Suite;
                SourceExpr="Last Date Updated";
                Editable=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den sidste varepost, du bogf›rte inden opdateringen af analysevisningen.;
                           ENU=Specifies the number of the last item ledger entry you posted, prior to updating the analysis view.];
                ApplicationArea=#Suite;
                SourceExpr="Last Entry No.";
                Editable=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den sidste varebudgetpost, du indtastede inden opdateringen af analysevisningen.;
                           ENU=Specifies the number of the last item budget entry you entered prior to updating the analysis view.];
                ApplicationArea=#Suite;
                SourceExpr="Last Budget Entry No.";
                Editable=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om analysevisningen opdateres, hver gang du bogf›rer en varepost.;
                           ENU=Specifies if the analysis view is updated every time that you post an item ledger entry.];
                ApplicationArea=#Suite;
                SourceExpr="Update on Posting" }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om en opdatering af analysevisningsbudgetposter medtages, n†r du opdaterer en analysevisning.;
                           ENU=Specifies whether to include an update of analysis view budget entries, when updating an analysis view.];
                ApplicationArea=#Suite;
                SourceExpr="Include Budgets";
                Editable=GLAccountSource }

    { 41  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den relaterede record er forhindret i kunne bogf›res under transaktioner - eksempelvis en debitor, som er erkl‘ret insolvent, eller en vare, som er sat i karant‘ne.;
                           ENU=Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.];
                ApplicationArea=#Suite;
                SourceExpr=Blocked }

    { 1900309501;1;Group  ;
                CaptionML=[DAN=Dimensioner;
                           ENU=Dimensions] }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en af de fire dimensioner, som du kan inkludere i en analysevisning.;
                           ENU=Specifies one of the four dimensions that you can include in an analysis view.];
                ApplicationArea=#Suite;
                SourceExpr="Dimension 1 Code" }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en af de fire dimensioner, som du kan inkludere i en analysevisning.;
                           ENU=Specifies one of the four dimensions that you can include in an analysis view.];
                ApplicationArea=#Suite;
                SourceExpr="Dimension 2 Code" }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en af de fire dimensioner, som du kan inkludere i en analysevisning.;
                           ENU=Specifies one of the four dimensions that you can include in an analysis view.];
                ApplicationArea=#Suite;
                SourceExpr="Dimension 3 Code" }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en af de fire dimensioner, som du kan inkludere i en analysevisning.;
                           ENU=Specifies one of the four dimensions that you can include in an analysis view.];
                ApplicationArea=#Suite;
                SourceExpr="Dimension 4 Code" }

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
      GLAccountSource@1000 : Boolean;

    LOCAL PROCEDURE SetGLAccountSource@1();
    BEGIN
      GLAccountSource := "Account Source" = "Account Source"::"G/L Account";
    END;

    BEGIN
    END.
  }
}

