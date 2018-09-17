OBJECT Page 2112 O365 Sales Item Lookup
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
    CaptionML=[DAN=Prisliste;
               ENU=Price List];
    SourceTable=Table27;
    SourceTableView=SORTING(Description);
    PageType=List;
    CardPageID=O365 Item Card;
    RefreshOnActivate=Yes;
    ActionList=ACTIONS
    {
      { 10      ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
    }
  }
  CONTROLS
  {
    { 1   ;    ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                CaptionML=[DAN=Pris;
                           ENU=Price];
                GroupType=Repeater }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det, du s‘lger. Du kan angive op til 30 tegn, b†de tal og bogstaver.;
                           ENU=Specifies what you are selling. You can enter a maximum of 30 characters, both numbers and letters.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr=Description }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prisen for ‚n enhed af varen eller ressourcen. Du kan angive en pris manuelt eller f† den angivet i henhold til feltet Avancepct.beregning p† det dertilh›rende kort.;
                           ENU=Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Unit Price";
                AutoFormatType=10;
                AutoFormatExpr='2' }

  }
  CODE
  {

    BEGIN
    END.
  }
}

