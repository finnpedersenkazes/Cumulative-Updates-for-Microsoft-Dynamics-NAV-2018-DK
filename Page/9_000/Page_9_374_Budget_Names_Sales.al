OBJECT Page 9374 Budget Names Sales
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Budgetnavne - salg;
               ENU=Budget Names Sales];
    SourceTable=Table7132;
    SourceTableView=WHERE(Analysis Area=CONST(Sales));
    PageType=List;
    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 17      ;1   ;Action    ;
                      Name=EditBudget;
                      ShortCutKey=Return;
                      CaptionML=[DAN=Rediger budget;
                                 ENU=Edit Budget];
                      ToolTipML=[DAN=Angiv budgetter, du kan oprette i finansmodulets funktionalitetsomr†de. Hvis du skal operere med mange budgetter, kan du oprette en r‘kke forskellige budgetnavne.;
                                 ENU=Specify budgets that you can create in the general ledger application area. If you need several different budgets, you can create several budget names.];
                      ApplicationArea=#SalesBudget;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=EditLines;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 SalesBudgetOverview@1000 : Page 7139;
                               BEGIN
                                 SalesBudgetOverview.SetNewBudgetName(Name);
                                 SalesBudgetOverview.RUN;
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
                ToolTipML=[DAN=Angiver navnet p† varebudgettet.;
                           ENU=Specifies the name of the item budget.];
                ApplicationArea=#SalesBudget;
                SourceExpr=Name }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af varebudgettet.;
                           ENU=Specifies a description of the item budget.];
                ApplicationArea=#SalesBudget;
                SourceExpr=Description }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den relaterede record er forhindret i kunne bogf›res under transaktioner - eksempelvis en debitor, som er erkl‘ret insolvent, eller en vare, som er sat i karant‘ne.;
                           ENU=Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.];
                ApplicationArea=#SalesBudget;
                SourceExpr=Blocked }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en dimensionskode for Varebudgetdimension 1.;
                           ENU=Specifies a dimension code for Item Budget Dimension 1.];
                ApplicationArea=#Dimensions;
                SourceExpr="Budget Dimension 1 Code" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en dimensionskode for Varebudgetdimension 2.;
                           ENU=Specifies a dimension code for Item Budget Dimension 2.];
                ApplicationArea=#Dimensions;
                SourceExpr="Budget Dimension 2 Code" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en dimensionskode for Varebudgetdimension 3.;
                           ENU=Specifies a dimension code for Item Budget Dimension 3.];
                ApplicationArea=#Dimensions;
                SourceExpr="Budget Dimension 3 Code" }

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

