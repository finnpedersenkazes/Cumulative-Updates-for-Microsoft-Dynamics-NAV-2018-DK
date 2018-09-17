OBJECT Page 911 Component - Item Details
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Komponent - varedetaljer;
               ENU=Component - Item Details];
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
                ToolTipML=[DAN=Angiver den basisenhed, der bruges til at m†le varen, som f.eks. stk., kasse eller palle. Basism†leenheden fungerer ogs† som konverteringsbasis for alternative m†leenheder.;
                           ENU=Specifies the base unit used to measure the item, such as piece, box, or pallet. The base unit of measure also serves as the conversion basis for alternate units of measure.];
                ApplicationArea=#Assembly;
                SourceExpr="Base Unit of Measure" }

    { 4   ;1   ;Field     ;
                ToolTipML=[DAN=Angiver prisen for ‚n enhed af varen eller ressourcen. Du kan angive en pris manuelt eller f† den angivet i henhold til feltet Avancepct.beregning p† det dertilh›rende kort.;
                           ENU=Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.];
                ApplicationArea=#Assembly;
                SourceExpr="Unit Price" }

    { 5   ;1   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, p† ‚n enhed af varen eller ressourcen p† linjen.;
                           ENU=Specifies the cost of one unit of the item or resource on the line.];
                ApplicationArea=#Assembly;
                SourceExpr="Unit Cost" }

    { 6   ;1   ;Field     ;
                ToolTipML=[DAN=Angiver den kostpris, der anvendes som et overslag, hvor afvigelser kan justeres p† et senere tidspunkt. Dette anvendes typisk ved montage og produktion, hvor omkostningerne varierer.;
                           ENU=Specifies the unit cost that is used as an estimation to be adjusted with variances later. It is typically used in assembly and production where costs can vary.];
                ApplicationArea=#Assembly;
                SourceExpr="Standard Cost" }

    { 7   ;1   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange erstatninger der er registreret for varen.;
                           ENU=Specifies the number of substitutions that have been registered for the item.];
                ApplicationArea=#Assembly;
                SourceExpr="No. of Substitutes" }

    { 8   ;1   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken type forsyningsordre der oprettes af planl‘gningssystemet, n†r varen skal genbestilles.;
                           ENU=Specifies the type of supply order created by the planning system when the item needs to be replenished.];
                ApplicationArea=#Assembly;
                SourceExpr="Replenishment System" }

    { 9   ;1   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den kreditor, der leverer denne vare som standard.;
                           ENU=Specifies the vendor code of who supplies this item by default.];
                ApplicationArea=#Assembly;
                SourceExpr="Vendor No." }

  }
  CODE
  {

    BEGIN
    END.
  }
}

