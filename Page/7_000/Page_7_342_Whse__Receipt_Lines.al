OBJECT Page 7342 Whse. Receipt Lines
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
    CaptionML=[DAN=Lagermodtagelseslinjer;
               ENU=Whse. Receipt Lines];
    SourceTable=Table7317;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 30      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 31      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=&Vis lagerdokument;
                                 ENU=Show &Whse. Document];
                      ToolTipML=[DAN=Vis det relaterede lagerbilag.;
                                 ENU=View the related warehouse document.];
                      ApplicationArea=#Warehouse;
                      Image=ViewOrder;
                      OnAction=VAR
                                 WhseRcptHeader@1000 : Record 7316;
                               BEGIN
                                 WhseRcptHeader.GET("No.");
                                 PAGE.RUN(PAGE::"Warehouse Receipt",WhseRcptHeader);
                               END;
                                }
      { 55      ;2   ;Action    ;
                      CaptionML=[DAN=Vis &kildedokumentlinje;
                                 ENU=&Show Source Document Line];
                      ToolTipML=[DAN="Vis den linje i kildebilaget, som modtagelsen vedr›rer. ";
                                 ENU="View the source document line that the receipts is related to. "];
                      ApplicationArea=#Warehouse;
                      Image=ViewDocumentLine;
                      OnAction=VAR
                                 WMSMgt@1000 : Codeunit 7302;
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

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den bilagstype, som linjen vedr›rer.;
                           ENU=Specifies the type of document that the line relates to.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source Document";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det kildebilag, som posten stammer fra.;
                           ENU=Specifies the number of the source document that the entry originates from.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source No." }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjenummeret p† det kildebilag, som posten stammer fra.;
                           ENU=Specifies the line number of the source document that the entry originates from.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source Line No." }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, hvor varerne skal modtages.;
                           ENU=Specifies the code of the location where the items should be received.];
                ApplicationArea=#Warehouse;
                SourceExpr="Location Code";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den zone, hvor varerne modtages.;
                           ENU=Specifies the zone in which the items are being received.];
                ApplicationArea=#Warehouse;
                SourceExpr="Zone Code";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, hvor varerne plukkes eller l‘gges p† lager.;
                           ENU=Specifies the bin where the items are picked or put away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver hyldenummeret for varen til brugerens orientering.;
                           ENU=Specifies the shelf number of the item for information use.];
                ApplicationArea=#Warehouse;
                SourceExpr="Shelf No.";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den vare, der forventes at blive modtaget.;
                           ENU=Specifies the number of the item that is expected to be received.];
                ApplicationArea=#Warehouse;
                SourceExpr="Item No." }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code" }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af varen p† linjen.;
                           ENU=Specifies the description of the item in the line.];
                ApplicationArea=#Warehouse;
                SourceExpr=Description }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en anden beskrivelse af varen p† linjen.;
                           ENU=Specifies a second description of the item on the line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Description 2" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der skal modtages.;
                           ENU=Specifies the quantity that should be received.];
                ApplicationArea=#Warehouse;
                SourceExpr=Quantity }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der skal modtages, anf›rt i basisenheder.;
                           ENU=Specifies the quantity to be received, in the base unit of measure.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. (Base)";
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der stadig mangler at blive h†ndteret.;
                           ENU=Specifies the quantity that still needs to be handled.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. Outstanding" }

    { 49  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der mangler at blive h†ndteret, anf›rt i basisenheder.;
                           ENU=Specifies the quantity that still needs to be handled, in the base unit of measure.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. Outstanding (Base)";
                Visible=FALSE }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der er bogf›rt som modtaget for linjen.;
                           ENU=Specifies the quantity for this line that has been posted as received.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. Received" }

    { 51  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der er modtaget, anf›rt i basisenheder.;
                           ENU=Specifies the quantity received, in the base unit of measure.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. Received (Base)";
                Visible=FALSE }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Warehouse;
                SourceExpr="Unit of Measure Code" }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange basisenheder der g†r p† den enhed, der er angivet for varen p† linjen.;
                           ENU=Specifies the number of base units of measure, that are in the unit of measure specified for the item on the line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. per Unit of Measure" }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for lagermodtagelsen.;
                           ENU=Specifies the status of the warehouse receipt.];
                ApplicationArea=#Warehouse;
                SourceExpr=Status }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Warehouse;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjenummeret.;
                           ENU=Specifies the line number.];
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

