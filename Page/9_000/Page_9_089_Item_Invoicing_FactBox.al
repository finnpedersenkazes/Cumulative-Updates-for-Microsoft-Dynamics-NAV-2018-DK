OBJECT Page 9089 Item Invoicing FactBox
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Varedetaljer - fakturering;
               ENU=Item Details - Invoicing];
    SourceTable=Table27;
    PageType=CardPart;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 9   ;1   ;Field     ;
                CaptionML=[DAN=Varenr.;
                           ENU=Item No.];
                ToolTipML=[DAN=Angiver nummeret p† varen.;
                           ENU=Specifies the number of the item.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No.";
                OnDrillDown=BEGIN
                              ShowDetails;
                            END;
                             }

    { 1   ;1   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan varens kostprisforl›b registreres, og om en faktisk eller budgetteret v‘rdi f›res som aktiv og bruges i beregningen af kostprisen.;
                           ENU=Specifies how the item's cost flow is recorded and whether an actual or budgeted value is capitalized and used in the cost calculation.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Costing Method" }

    { 3   ;1   ;Field     ;
                ToolTipML=[DAN=Angiver, om varens pris er reguleret enten automatisk eller manuelt.;
                           ENU=Specifies whether the item's unit cost has been adjusted, either automatically or manually.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Cost is Adjusted" }

    { 5   ;1   ;Field     ;
                ToolTipML=[DAN=Angiver, at alle lagerreguleringer for denne vare er blevet bogf›rt i finansregnskabet.;
                           ENU=Specifies that all the inventory costs for this item have been posted to the general ledger.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Cost is Posted to G/L" }

    { 7   ;1   ;Field     ;
                ToolTipML=[DAN=Angiver den kostpris, der anvendes som et overslag, hvor afvigelser kan justeres p† et senere tidspunkt. Dette anvendes typisk ved montage og produktion, hvor omkostningerne varierer.;
                           ENU=Specifies the unit cost that is used as an estimation to be adjusted with variances later. It is typically used in assembly and production where costs can vary.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Standard Cost" }

    { 11  ;1   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, p† ‚n enhed af varen eller ressourcen p† linjen.;
                           ENU=Specifies the cost of one unit of the item or resource on the line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Unit Cost" }

    { 13  ;1   ;Field     ;
                ToolTipML=[DAN=Angiver varens indirekte omkostning som et absolut bel›b.;
                           ENU=Specifies the item's indirect cost as an absolute amount.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Overhead Rate" }

    { 15  ;1   ;Field     ;
                ToolTipML=[DAN=Angiver procentdelen af varens sidste k›bspris, der omfatter indirekte omkostninger, s†som fragt, der er knyttet til k›bet af varen.;
                           ENU=Specifies the percentage of the item's last purchase cost that includes indirect costs, such as freight that is associated with the purchase of the item.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Indirect Cost %" }

    { 17  ;1   ;Field     ;
                ToolTipML=[DAN=Angiver den seneste k›bspris for varen.;
                           ENU=Specifies the most recent direct unit cost of the item.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Last Direct Cost" }

    { 19  ;1   ;Field     ;
                ToolTipML=[DAN=Angiver den d‘kningsgrad, du vil s‘lge varen til. Du kan angive en avanceprocent manuelt eller f† den angivet i henhold til feltet Avancepct.beregning;
                           ENU=Specifies the profit margin that you want to sell the item at. You can enter a profit percentage manually or have it entered according to the Price/Profit Calculation field];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Profit %" }

    { 21  ;1   ;Field     ;
                ToolTipML=[DAN=Angiver prisen for ‚n enhed af varen eller ressourcen. Du kan angive en pris manuelt eller f† den angivet i henhold til feltet Avancepct.beregning p† det dertilh›rende kort.;
                           ENU=Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Unit Price" }

  }
  CODE
  {

    LOCAL PROCEDURE ShowDetails@1102601000();
    BEGIN
      PAGE.RUN(PAGE::"Item Card",Rec);
    END;

    BEGIN
    END.
  }
}

