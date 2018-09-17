OBJECT Page 112 Inventory Posting Groups
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Varebogf›ringsgrupper;
               ENU=Inventory Posting Groups];
    SourceTable=Table94;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 9       ;1   ;Action    ;
                      CaptionML=[DAN=&Ops‘tning;
                                 ENU=&Setup];
                      ToolTipML=[DAN=Angiv lokationer for den lagerbogf›ringsgruppe, du kan knytte til finanskonti. Bogf›ringsgrupper skaber links mellem funktionalitetsomr†der og Finansmodulet.;
                                 ENU=Specify the locations for the inventory posting group that you can link to general ledger accounts. Posting groups create links between application areas and the General Ledger application area.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 5826;
                      RunPageLink=Invt. Posting Group Code=FIELD(Code);
                      Promoted=Yes;
                      Image=Setup;
                      PromotedCategory=Process }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for lagerbogf›ringsgruppen.;
                           ENU=Specifies the identifier for the inventory posting group.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Code }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af lagerbogf›ringsgruppen.;
                           ENU=Specifies a description of the inventory posting group.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description }

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

    [Internal]
    PROCEDURE GetSelectionFilter@3() : Text;
    VAR
      InvtPostingGr@1004 : Record 94;
      SelectionFilterManagement@1001 : Codeunit 46;
    BEGIN
      CurrPage.SETSELECTIONFILTER(InvtPostingGr);
      EXIT(SelectionFilterManagement.GetSelectionFilterForInventoryPostingGroup(InvtPostingGr));
    END;

    BEGIN
    END.
  }
}

