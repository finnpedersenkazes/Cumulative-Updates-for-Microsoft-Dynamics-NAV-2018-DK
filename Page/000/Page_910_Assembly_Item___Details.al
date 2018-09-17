OBJECT Page 910 Assembly Item - Details
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Montageelement - detaljer;
               ENU=Assembly Item - Details];
    SourceTable=Table27;
    PageType=CardPart;
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Field     ;
                CaptionML=[DAN=Varenr.;
                           ENU=Item No.];
                ToolTipML=[DAN=Angiver nummeret p† varen.;
                           ENU=Specifies the number of the item.];
                ApplicationArea=#Assembly;
                SourceExpr="No." }

    { 3   ;1   ;Field     ;
                ToolTipML=[DAN=Angiver den kostpris, der anvendes som et overslag, hvor afvigelser kan justeres p† et senere tidspunkt. Dette anvendes typisk ved montage og produktion, hvor omkostningerne varierer.;
                           ENU=Specifies the unit cost that is used as an estimation to be adjusted with variances later. It is typically used in assembly and production where costs can vary.];
                ApplicationArea=#Assembly;
                SourceExpr="Standard Cost" }

    { 4   ;1   ;Field     ;
                ToolTipML=[DAN=Angiver prisen for ‚n enhed af varen eller ressourcen. Du kan angive en pris manuelt eller f† den angivet i henhold til feltet Avancepct.beregning p† det dertilh›rende kort.;
                           ENU=Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.];
                ApplicationArea=#Assembly;
                SourceExpr="Unit Price" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

