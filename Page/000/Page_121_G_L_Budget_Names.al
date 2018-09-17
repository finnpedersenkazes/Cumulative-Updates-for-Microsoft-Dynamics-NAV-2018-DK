OBJECT Page 121 G/L Budget Names
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Finansbudgetnavne;
               ENU=G/L Budget Names];
    SourceTable=Table95;
    PageType=List;
    OnOpenPage=BEGIN
                 GLSetup.GET;
               END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 19      ;1   ;Action    ;
                      Name=EditBudget;
                      ShortCutKey=Return;
                      CaptionML=[DAN=Rediger budget;
                                 ENU=Edit Budget];
                      ToolTipML=[DAN=Angiv budgetter, du kan oprette i finansmodulets funktionalitetsomr†de. Hvis du skal operere med mange budgetter, kan du oprette en r‘kke forskellige budgetnavne.;
                                 ENU=Specify budgets that you can create in the general ledger application area. If you need several different budgets, you can create several budget names.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=EditLines;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 Budget@1000 : Page 113;
                               BEGIN
                                 Budget.SetBudgetName(Name);
                                 Budget.RUN;
                               END;
                                }
      { 3       ;1   ;ActionGroup;
                      Name=ReportGroup;
                      CaptionML=[DAN=Rapport;
                                 ENU=Report];
                      Image=Report }
      { 5       ;2   ;Action    ;
                      Name=ReportTrialBalance;
                      CaptionML=[DAN=Pr›veversions saldo/budget;
                                 ENU=Trial Balance/Budget];
                      ToolTipML=[DAN=Vis budgetoplysninger for den angivne periode.;
                                 ENU=View budget details for the specified period.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Report;
                      PromotedCategory=Report;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 REPORT.RUN(REPORT::"Trial Balance/Budget");
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† finansbudgettet.;
                           ENU=Specifies the name of the general ledger budget.];
                ApplicationArea=#Suite;
                SourceExpr=Name }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af navnet p† finansbudgettet.;
                           ENU=Specifies a description of the general ledger budget name.];
                ApplicationArea=#Suite;
                SourceExpr=Description }

    { 6   ;2   ;Field     ;
                Name=Global Dimension 1 Code;
                CaptionML=[DAN=Global dimension 1-kode;
                           ENU=Global Dimension 1 Code];
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p† analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg‘ngelige p† alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Suite;
                SourceExpr=GLSetup."Global Dimension 1 Code";
                Editable=FALSE }

    { 7   ;2   ;Field     ;
                Name=Global Dimension 2 Code;
                CaptionML=[DAN=Global dimension 2-kode;
                           ENU=Global Dimension 2 Code];
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p† analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg‘ngelige p† alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Suite;
                SourceExpr=GLSetup."Global Dimension 2 Code";
                Editable=FALSE }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for en budgetdimension. Du kan angive fire yderligere dimensioner p† hvert budget, du opretter.;
                           ENU=Specifies a code for a budget dimension. You can specify four additional dimensions on each budget that you create.];
                ApplicationArea=#Suite;
                SourceExpr="Budget Dimension 1 Code" }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for en budgetdimension. Du kan angive fire yderligere dimensioner p† hvert budget, du opretter.;
                           ENU=Specifies a code for a budget dimension. You can specify four additional dimensions on each budget that you create.];
                ApplicationArea=#Suite;
                SourceExpr="Budget Dimension 2 Code" }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for en budgetdimension. Du kan angive fire yderligere dimensioner p† hvert budget, du opretter.;
                           ENU=Specifies a code for a budget dimension. You can specify four additional dimensions on each budget that you create.];
                ApplicationArea=#Suite;
                SourceExpr="Budget Dimension 3 Code" }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for en budgetdimension. Du kan angive fire yderligere dimensioner p† hvert budget, du opretter.;
                           ENU=Specifies a code for a budget dimension. You can specify four additional dimensions on each budget that you create.];
                ApplicationArea=#Suite;
                SourceExpr="Budget Dimension 4 Code" }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den relaterede record er forhindret i kunne bogf›res under transaktioner - eksempelvis en debitor, som er erkl‘ret insolvent, eller en vare, som er sat i karant‘ne.;
                           ENU=Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.];
                ApplicationArea=#Suite;
                SourceExpr=Blocked }

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
      GLSetup@1000 : Record 98;

    [Internal]
    PROCEDURE GetSelectionFilter@2() : Text;
    VAR
      GLBudgetName@1004 : Record 95;
      SelectionFilterManagement@1001 : Codeunit 46;
    BEGIN
      CurrPage.SETSELECTIONFILTER(GLBudgetName);
      EXIT(SelectionFilterManagement.GetSelectionFilterForGLBudgetName(GLBudgetName));
    END;

    BEGIN
    END.
  }
}

