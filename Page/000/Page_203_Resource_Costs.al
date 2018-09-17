OBJECT Page 203 Resource Costs
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Ressourcekostpriser;
               ENU=Resource Costs];
    SourceTable=Table202;
    DataCaptionFields=Code;
    PageType=List;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen.;
                           ENU=Specifies the type.];
                ApplicationArea=#Jobs;
                SourceExpr=Type }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden.;
                           ENU=Specifies the code.];
                ApplicationArea=#Jobs;
                SourceExpr=Code }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for arbejdstypen. Du kan ogs† tildele en enhedspris til en arbejdstype.;
                           ENU=Specifies the code for the type of work. You can also assign a unit price to a work type.];
                ApplicationArea=#Jobs;
                SourceExpr="Work Type Code" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningstype.;
                           ENU=Specifies the type of cost.];
                ApplicationArea=#Jobs;
                SourceExpr="Cost Type" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kostprisen pr. enhed af den valgte vare eller ressource.;
                           ENU=Specifies the cost of one unit of the selected item or resource.];
                ApplicationArea=#Jobs;
                SourceExpr="Direct Unit Cost" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, p† ‚n enhed af varen eller ressourcen p† linjen.;
                           ENU=Specifies the cost of one unit of the item or resource on the line.];
                ApplicationArea=#Jobs;
                SourceExpr="Unit Cost" }

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

