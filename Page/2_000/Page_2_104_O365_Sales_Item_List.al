OBJECT Page 2104 O365 Sales Item List
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    Editable=Yes;
    CaptionML=[DAN=Prisliste;
               ENU=Price List];
    DeleteAllowed=No;
    ModifyAllowed=Yes;
    SourceTable=Table27;
    SourceTableView=SORTING(Description);
    PageType=ListPart;
    CardPageID=O365 Item Card;
    RefreshOnActivate=Yes;
    ActionList=ACTIONS
    {
      { 12      ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 10      ;1   ;Action    ;
                      Name=DeleteLine;
                      CaptionML=[DAN=Slet pris;
                                 ENU=Delete Price];
                      ToolTipML=[DAN=Slet den valgte pris.;
                                 ENU=Delete the selected price.];
                      ApplicationArea=#Basic,#Suite,#Invoicing;
                      Promoted=Yes;
                      Image=Delete;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 IF NOT CONFIRM(DeleteQst) THEN
                                   EXIT;
                                 DELETE(TRUE);
                                 CurrPage.UPDATE;
                               END;

                      Gesture=RightSwipe }
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
    VAR
      DeleteQst@1000 : TextConst 'DAN=Er du sikker?;ENU=Are you sure?';

    BEGIN
    END.
  }
}

