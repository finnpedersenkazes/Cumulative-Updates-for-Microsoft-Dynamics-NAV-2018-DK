OBJECT Page 7341 Whse. Shipment Lines
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
    CaptionML=[DAN=Lagerleverancelinjer;
               ENU=Whse. Shipment Lines];
    SourceTable=Table7321;
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
                      CaptionML=[DAN=&Vis lagerdokument;
                                 ENU=Show &Whse. Document];
                      ToolTipML=[DAN=Vis det relaterede lagerbilag.;
                                 ENU=View the related warehouse document.];
                      ApplicationArea=#Warehouse;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ViewOrder;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 WhseShptHeader@1000 : Record 7320;
                               BEGIN
                                 WhseShptHeader.GET("No.");
                                 PAGE.RUN(PAGE::"Warehouse Shipment",WhseShptHeader);
                               END;
                                }
      { 8       ;2   ;Action    ;
                      Name=ShowSourceDocumentLine;
                      CaptionML=[DAN=Vis &kildedokumentlinje;
                                 ENU=&Show Source Document Line];
                      ToolTipML=[DAN="Vis den linje i kildebilaget, som leverancen vedr›rer. ";
                                 ENU="View the source document line that the shipment is related to. "];
                      ApplicationArea=#Warehouse;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ViewDocumentLine;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 WMSMgt@1001 : Codeunit 7302;
                               BEGIN
                                 WMSMgt.ShowSourceDocLine(
                                   "Source Type","Source Subtype","Source No.","Source Line No.",0)
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

    { 37  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den destinationstype, der er tilknyttet lagerleverancelinjen.;
                           ENU=Specifies the type of destination associated with the warehouse shipment line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Destination Type";
                Visible=FALSE }

    { 66  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den debitor, kreditor eller lokation, som varerne skal leveres til.;
                           ENU=Specifies the number of the customer, vendor, or location to which the items should be shipped.];
                ApplicationArea=#Warehouse;
                SourceExpr="Destination No.";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, som varerne p† linjen leveres fra.;
                           ENU=Specifies the code of the location from which the items on the line are being shipped.];
                ApplicationArea=#Warehouse;
                SourceExpr="Location Code";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den zone, hvor placeringen p† leverancelinjen findes.;
                           ENU=Specifies the code of the zone where the bin on this shipment line is located.];
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
                ToolTipML=[DAN=Angiver nummeret p† den vare, der skal leveres.;
                           ENU=Specifies the number of the item that should be shipped.];
                ApplicationArea=#Warehouse;
                SourceExpr="Item No." }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code" }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af varen p† linjen.;
                           ENU=Specifies the description of the item in the line.];
                ApplicationArea=#Warehouse;
                SourceExpr=Description }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en anden beskrivelse af varen p† linjen, hvis det er relevant.;
                           ENU=Specifies a second description of the item in the line, if any.];
                ApplicationArea=#Warehouse;
                SourceExpr="Description 2";
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der skal leveres.;
                           ENU=Specifies the quantity that should be shipped.];
                ApplicationArea=#Warehouse;
                SourceExpr=Quantity }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der skal leveres, anf›rt i basisenheder.;
                           ENU=Specifies the quantity that should be shipped, in the base unit of measure.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. (Base)";
                Visible=FALSE }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der stadig mangler at blive h†ndteret.;
                           ENU=Specifies the quantity that still needs to be handled.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. Outstanding" }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der mangler at blive h†ndteret, anf›rt i basisenheder.;
                           ENU=Specifies the quantity that still needs to be handled, expressed in the base unit of measure.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. Outstanding (Base)";
                Visible=FALSE }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der if›lge plukinstruktionerne skal plukkes til lagerleverancelinjen.;
                           ENU=Specifies the quantity in pick instructions assigned to be picked for the warehouse shipment line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Pick Qty.";
                Visible=FALSE }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, anf›rt i basisenheder, der if›lge plukinstruktionerne skal plukkes til lagerleverancelinjen.;
                           ENU=Specifies the quantity, in the base unit of measure, in pick instructions, that is assigned to be picked for the warehouse shipment line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Pick Qty. (Base)";
                Visible=FALSE }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor stor en del af det samlede leveranceantal der er registreret som plukket.;
                           ENU=Specifies how many of the total shipment quantity have been registered as picked.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. Picked" }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor stor en del af det samlede leveranceantal der er registreret som plukket, anf›rt i basisenheder.;
                           ENU=Specifies how many of the total shipment quantity in the base unit of measure have been registered as picked.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. Picked (Base)";
                Visible=FALSE }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal af varen p† linjen, der er bogf›rt som leveret.;
                           ENU=Specifies the quantity of the item on the line that is posted as shipped.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. Shipped";
                Visible=FALSE }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der er bogf›rt som leveret, anf›rt i basisenheder.;
                           ENU=Specifies the quantity that is posted as shipped expressed in the base unit of measure.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. Shipped (Base)";
                Visible=FALSE }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Warehouse;
                SourceExpr="Unit of Measure Code" }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange basisenheder der g†r p† den enhed, der er angivet for varen p† linjen.;
                           ENU=Specifies the number of base units of measure that are in the unit of measure specified for the item on the line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. per Unit of Measure" }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for leverancelinjen.;
                           ENU=Specifies the status of the shipment line.];
                ApplicationArea=#Warehouse;
                SourceExpr=Status }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor den relaterede lageraktivitet, som f.eks. pluk, skal v‘re afsluttet for at sikre, at varerne kan leveres p† afsendelsesdatoen.;
                           ENU=Specifies the date when the related warehouse activity, such as a pick, must be completed to ensure items can be shipped by the shipment date.];
                ApplicationArea=#Warehouse;
                SourceExpr="Due Date" }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn†r varerne p† bilaget er sendt eller leveret. En afsendelsesdato beregnes normalt ud fra en ›nsket leveringsdato plus leveringstiden.;
                           ENU=Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.];
                ApplicationArea=#Warehouse;
                SourceExpr="Shipment Date" }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Warehouse;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† lagerstedets leverancelinje.;
                           ENU=Specifies the number of the warehouse shipment line.];
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

