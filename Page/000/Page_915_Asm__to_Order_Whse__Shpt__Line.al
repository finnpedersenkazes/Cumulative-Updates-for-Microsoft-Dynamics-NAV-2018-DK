OBJECT Page 915 Asm.-to-Order Whse. Shpt. Line
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Ordremont.lagerleverancelinje;
               ENU=Asm.-to-Order Whse. Shpt. Line];
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table7321;
    PageType=List;
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                CaptionML=[DAN=Linjer;
                           ENU=Lines];
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Assembly;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† lagerstedets leverancelinje.;
                           ENU=Specifies the number of the warehouse shipment line.];
                ApplicationArea=#Assembly;
                SourceExpr="Line No." }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tabel, som er kilde til modtagelseslinjen.;
                           ENU=Specifies the number of the table that is the source of the receipt line.];
                ApplicationArea=#Assembly;
                SourceExpr="Source Type";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kildeundertypen for det bilag, som linjen vedr›rer.;
                           ENU=Specifies the source subtype of the document to which the line relates.];
                ApplicationArea=#Assembly;
                SourceExpr="Source Subtype";
                Visible=FALSE }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det kildebilag, som posten stammer fra.;
                           ENU=Specifies the number of the source document that the entry originates from.];
                ApplicationArea=#Assembly;
                SourceExpr="Source No.";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjenummeret p† det kildebilag, som posten stammer fra.;
                           ENU=Specifies the line number of the source document that the entry originates from.];
                ApplicationArea=#Assembly;
                SourceExpr="Source Line No.";
                Visible=FALSE }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code" }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, som varerne p† linjen leveres fra.;
                           ENU=Specifies the code of the location from which the items on the line are being shipped.];
                ApplicationArea=#Location;
                SourceExpr="Location Code" }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den zone, hvor placeringen p† leverancelinjen findes.;
                           ENU=Specifies the code of the zone where the bin on this shipment line is located.];
                ApplicationArea=#Assembly;
                SourceExpr="Zone Code";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den placering, hvor varerne skal placeres inden levering.;
                           ENU=Specifies the code of the bin in which the items will be placed before shipment.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der skal leveres.;
                           ENU=Specifies the quantity that should be shipped.];
                ApplicationArea=#Assembly;
                SourceExpr=Quantity }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der stadig mangler at blive h†ndteret.;
                           ENU=Specifies the quantity that still needs to be handled.];
                ApplicationArea=#Assembly;
                SourceExpr="Qty. Outstanding";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal varer, der mangler at blive afsendt.;
                           ENU=Specifies the quantity of items that remain to be shipped.];
                ApplicationArea=#Assembly;
                SourceExpr="Qty. to Ship" }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver i basisenheder det antal, som leveres, n†r lagerleverancen er bogf›rt.;
                           ENU=Specifies the quantity, in base units of measure, that will be shipped when the warehouse shipment is posted.];
                ApplicationArea=#Assembly;
                SourceExpr="Qty. to Ship (Base)";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Assembly;
                SourceExpr="Unit of Measure Code" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor den relaterede lageraktivitet, som f.eks. pluk, skal v‘re afsluttet for at sikre, at varerne kan leveres p† afsendelsesdatoen.;
                           ENU=Specifies the date when the related warehouse activity, such as a pick, must be completed to ensure items can be shipped by the shipment date.];
                ApplicationArea=#Assembly;
                SourceExpr="Due Date";
                Visible=FALSE }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn†r varerne p† bilaget er sendt eller leveret. En afsendelsesdato beregnes normalt ud fra en ›nsket leveringsdato plus leveringstiden.;
                           ENU=Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.];
                ApplicationArea=#Assembly;
                SourceExpr="Shipment Date" }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den destinationstype, der er tilknyttet lagerleverancelinjen.;
                           ENU=Specifies the type of destination associated with the warehouse shipment line.];
                ApplicationArea=#Assembly;
                SourceExpr="Destination Type";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den debitor, kreditor eller lokation, som varerne skal leveres til.;
                           ENU=Specifies the number of the customer, vendor, or location to which the items should be shipped.];
                ApplicationArea=#Assembly;
                SourceExpr="Destination No.";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om lagerleverancelinjen g‘lder elementer, der monteres under en salgsordre, f›r den leveres.;
                           ENU=Specifies if the warehouse shipment line is for items that are assembled to a sales order before it is shipped.];
                ApplicationArea=#Assembly;
                SourceExpr="Assemble to Order";
                Visible=FALSE }

  }
  CODE
  {

    BEGIN
    END.
  }
}

