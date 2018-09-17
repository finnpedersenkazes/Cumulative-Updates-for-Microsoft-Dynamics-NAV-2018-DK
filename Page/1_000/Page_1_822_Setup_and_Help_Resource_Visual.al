OBJECT Page 1822 Setup and Help Resource Visual
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Konfigurations- og hj‘lperessourcer;
               ENU=Setup and Help Resources];
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table1803;
    SourceTableView=SORTING(Order,Visible)
                    WHERE(Visible=CONST(Yes));
    PageType=List;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Detaljer;
                                ENU=New,Process,Report,Details];
    OnOpenPage=BEGIN
                 SETRANGE(Parent,0);
               END;

    ActionList=ACTIONS
    {
      { 8       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 7       ;1   ;ActionGroup;
                      Name=Manage;
                      CaptionML=[DAN=Administrer;
                                 ENU=Manage] }
      { 6       ;2   ;Action    ;
                      Name=View;
                      ShortCutKey=Return;
                      CaptionML=[DAN=Vis;
                                 ENU=View];
                      ToolTipML=[DAN=Vis udvidelsesdetaljer.;
                                 ENU=View extension details.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=View;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 Navigate;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen p† ressourcen.;
                           ENU=Specifies the type of resource.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Item Type" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet.;
                           ENU=Specifies the name.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Name;
                OnDrillDown=BEGIN
                              Navigate;
                            END;
                             }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver ikonet for den knap, der †bner ressourcen.;
                           ENU=Specifies the icon for the button that opens the resource.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Icon }

  }
  CODE
  {

    BEGIN
    END.
  }
}

