OBJECT Page 7360 Whse. Internal Pick Lines
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
    CaptionML=[DAN=Interne pluklinjer (logistik);
               ENU=Whse. Internal Pick Lines];
    SourceTable=Table7334;
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
                      CaptionML=[DAN=Vis lagerdokument;
                                 ENU=Show Whse. Document];
                      ToolTipML=[DAN=Vis det relaterede igangv‘rende lagerbilag.;
                                 ENU=View the related ongoing warehouse document.];
                      ApplicationArea=#Warehouse;
                      Image=ViewOrder;
                      OnAction=VAR
                                 WhseInternalPickHeader@1000 : Record 7333;
                               BEGIN
                                 WhseInternalPickHeader.GET("No.");
                                 PAGE.RUN(PAGE::"Whse. Internal Pick",WhseInternalPickHeader);
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

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver lokationskoden for den interne pluklinje.;
                           ENU=Specifies the code of the location of the internal pick line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Location Code";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den zone, hvor varerne skal l‘gges, n†r de er blevet plukket.;
                           ENU=Specifies the To Zone Code of the zone where items should be placed once they are picked.];
                ApplicationArea=#Warehouse;
                SourceExpr="To Zone Code";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den placering, hvor varerne skal l‘gges, n†r de er blevet plukket.;
                           ENU=Specifies the code of the bin into which the items should be placed when they are picked.];
                ApplicationArea=#Warehouse;
                SourceExpr="To Bin Code";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver hyldenummeret for varen til brugerens orientering.;
                           ENU=Specifies the shelf number of the item for informational use.];
                ApplicationArea=#Warehouse;
                SourceExpr="Shelf No.";
                Visible=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den vare, der skal plukkes.;
                           ENU=Specifies the number of the item that should be picked.];
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
                ToolTipML=[DAN=Angiver en anden beskrivelse af varen p† linjen.;
                           ENU=Specifies a second description of the item on the line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Description 2";
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der skal plukkes.;
                           ENU=Specifies the quantity that should be picked.];
                ApplicationArea=#Warehouse;
                SourceExpr=Quantity }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der skal plukkes, anf›rt i basisenheder.;
                           ENU=Specifies the quantity that should be picked, in the base unit of measure.];
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
                           ENU=Specifies the quantity that still needs to be handled, in the base unit of measure.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. Outstanding (Base)";
                Visible=FALSE }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal p† linjen, der er registreret som plukket.;
                           ENU=Specifies the quantity of the line that is registered as picked.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. Picked" }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal p† linjen, der er registreret som plukket, anf›rt i basisenheder.;
                           ENU=Specifies the quantity of the line that is registered as picked, in the base unit of measure.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. Picked (Base)";
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

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvis status er Tom, Delvist plukket eller Fuldt plukket.;
                           ENU=Specifies if the status is Blank, Partially Picked, or Completely Picked.];
                ApplicationArea=#Warehouse;
                SourceExpr=Status }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor lageraktiviteten skal v‘re afsluttet.;
                           ENU=Specifies the date when the warehouse activity must be completed.];
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

