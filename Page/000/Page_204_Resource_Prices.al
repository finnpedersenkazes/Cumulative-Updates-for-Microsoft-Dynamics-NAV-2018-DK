OBJECT Page 204 Resource Prices
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Ressourcesalgspriser;
               ENU=Resource Prices];
    SourceTable=Table201;
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

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken arbejdstype ressourcen udlignes med. Priserne opdateres ud fra denne post.;
                           ENU=Specifies which work type the resource applies to. Prices are updated based on this entry.];
                ApplicationArea=#Jobs;
                SourceExpr="Work Type Code" }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver valutakoden for den alternative salgspris p† linjen.;
                           ENU=Specifies the currency code of the alternate sales price on this line.];
                ApplicationArea=#Jobs;
                SourceExpr="Currency Code" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prisen for ‚n enhed af varen eller ressourcen. Du kan angive en pris manuelt eller f† den angivet i henhold til feltet Avancepct.beregning p† det dertilh›rende kort.;
                           ENU=Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.];
                ApplicationArea=#Jobs;
                SourceExpr="Unit Price" }

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

