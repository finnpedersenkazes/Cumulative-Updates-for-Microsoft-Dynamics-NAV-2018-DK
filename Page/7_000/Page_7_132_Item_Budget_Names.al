OBJECT Page 7132 Item Budget Names
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Varebudgetnavne;
               ENU=Item Budget Names];
    SourceTable=Table7132;
    PageType=List;
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
                ApplicationArea=#ItemBudget;
                SourceExpr=Name }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af varebudgettet.;
                           ENU=Specifies a description of the item budget.];
                ApplicationArea=#ItemBudget;
                SourceExpr=Description }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den relaterede record er forhindret i kunne bogf›res under transaktioner - eksempelvis en debitor, som er erkl‘ret insolvent, eller en vare, som er sat i karant‘ne.;
                           ENU=Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.];
                ApplicationArea=#ItemBudget;
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

