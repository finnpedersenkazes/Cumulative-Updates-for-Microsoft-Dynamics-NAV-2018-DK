OBJECT Page 7362 Posted Whse. Shipment Lines
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
    CaptionML=[DAN=Bogf. lagerleverancelinjer;
               ENU=Posted Whse. Shipment Lines];
    SourceTable=Table7323;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 6       ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 7       ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Vis bogf›rt lagerdokument;
                                 ENU=Show Posted Whse. Document];
                      ToolTipML=[DAN=F† vist den relaterede fuldf›rte lagerleverance.;
                                 ENU=View the related completed warehouse shipment.];
                      ApplicationArea=#Warehouse;
                      Image=ViewPostedOrder;
                      OnAction=VAR
                                 PostedWhseShptHeader@1000 : Record 7322;
                               BEGIN
                                 PostedWhseShptHeader.GET("No.");
                                 PAGE.RUN(PAGE::"Posted Whse. Shipment",PostedWhseShptHeader);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den bilagstype, som linjen vedr›rer.;
                           ENU=Specifies the type of document that the line relates to.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source Document";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det kildebilag, som posten stammer fra.;
                           ENU=Specifies the number of the source document that the entry originates from.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source No." }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjenummeret p† det kildebilag, som posten stammer fra.;
                           ENU=Specifies the line number of the source document that the entry originates from.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source Line No." }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den destinationstype, der er tilknyttet den bogf›rte lagerleverancelinje.;
                           ENU=Specifies the type of destination associated with the posted warehouse shipment line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Destination Type";
                Visible=FALSE }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den debitor, kreditor eller lokation, som varerne er leveret til.;
                           ENU=Specifies the number of the customer, vendor, or location to which the items have been shipped.];
                ApplicationArea=#Warehouse;
                SourceExpr="Destination No.";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, som varerne p† linjen blev leveret fra.;
                           ENU=Specifies the code of the location from which the items on the line were shipped.];
                ApplicationArea=#Warehouse;
                SourceExpr="Location Code";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den zone, hvor placeringen p† den bogf›rte leverancelinje findes.;
                           ENU=Specifies the code of the zone where the bin on this posted shipment line is located.];
                ApplicationArea=#Warehouse;
                SourceExpr="Zone Code";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, hvor varerne plukkes eller l‘gges p† lager.;
                           ENU=Specifies the bin where the items are picked or put away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver hyldenummeret for varen til brugerens orientering.;
                           ENU=Specifies the shelf number of the item for informational use.];
                ApplicationArea=#Warehouse;
                SourceExpr="Shelf No.";
                Visible=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den vare, som er blevet afsendt.;
                           ENU=Specifies the number of the item that has been shipped.];
                ApplicationArea=#Warehouse;
                SourceExpr="Item No." }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code" }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af varen p† linjen.;
                           ENU=Specifies the description of the item on the line.];
                ApplicationArea=#Warehouse;
                SourceExpr=Description }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en anden beskrivelse af varen p† linjen, hvis det er relevant.;
                           ENU=Specifies the a second description of the item on the line, if any.];
                ApplicationArea=#Warehouse;
                SourceExpr="Description 2";
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der er leveret.;
                           ENU=Specifies the quantity that was shipped.];
                ApplicationArea=#Warehouse;
                SourceExpr=Quantity }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der er leveret, anf›rt i basisenheder.;
                           ENU=Specifies the quantity that was shipped, in the base unit of measure.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. (Base)";
                Visible=FALSE }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Warehouse;
                SourceExpr="Unit of Measure Code" }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange basisenheder der g†r p† den enhed, der er angivet for varen p† linjen.;
                           ENU=Specifies the number of base units of measure, that are in the unit of measure, specified for the item on the line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. per Unit of Measure" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen for det kildedokument, der er knyttet til linjen.;
                           ENU=Specifies the type of source document associated with the line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Posted Source Document" }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bilagsnummeret p† det bogf›rte kildedokument.;
                           ENU=Specifies the document number of the posted source document.];
                ApplicationArea=#Warehouse;
                SourceExpr="Posted Source No." }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver forfaldsdatoen for linjen.;
                           ENU=Specifies the due date of the line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Due Date" }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Warehouse;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† linjen.;
                           ENU=Specifies the number of the line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Line No." }

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

