OBJECT Page 7363 Posted Whse. Receipt Lines
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
    CaptionML=[DAN=Bogf. lagermodtagelseslinjer;
               ENU=Posted Whse. Receipt Lines];
    SourceTable=Table7319;
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
                                 PostedWhseRcptHeader@1000 : Record 7318;
                               BEGIN
                                 PostedWhseRcptHeader.GET("No.");
                                 PAGE.RUN(PAGE::"Posted Whse. Receipt",PostedWhseRcptHeader);
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

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, hvor varerne blev registreret.;
                           ENU=Specifies the code of the location where the items were received.];
                ApplicationArea=#Warehouse;
                SourceExpr="Location Code";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for zonen p† den bogf›rte modtagelseslinje.;
                           ENU=Specifies the code of the zone on this posted receipt line.];
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
                ToolTipML=[DAN=Angiver nummeret p† den vare, der er modtaget og bogf›rt.;
                           ENU=Specifies the number of the item that was received and posted.];
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
                ToolTipML=[DAN=Angiver det antal, der er modtaget.;
                           ENU=Specifies the quantity that was received.];
                ApplicationArea=#Warehouse;
                SourceExpr=Quantity }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der er modtaget, anf›rt i basisenheder.;
                           ENU=Specifies the quantity that was received, in the base unit of measure.];
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
                           ENU=Specifies the number of base units of measure, in the unit of measure, specified for the item on the line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. per Unit of Measure" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den type bogf›rt kildedokument, som modtagelseslinjen henviser til.;
                           ENU=Specifies the type of posted source document referred to by the receipt line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Posted Source Document" }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bilagsnummeret p† det bogf›rte kildedokument.;
                           ENU=Specifies the document number of the posted source document.];
                ApplicationArea=#Warehouse;
                SourceExpr="Posted Source No." }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor modtagelseslinjen var forfalden til betaling.;
                           ENU=Specifies the date that the receipt line was due.];
                ApplicationArea=#Warehouse;
                SourceExpr="Due Date" }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Warehouse;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† linjen i den bogf›rte modtagelse.;
                           ENU=Specifies the number of the line in the posted receipt.];
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

