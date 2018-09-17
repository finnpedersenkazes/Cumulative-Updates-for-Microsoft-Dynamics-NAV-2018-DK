OBJECT Page 7396 Posted Invt. Put-away Lines
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
    CaptionML=[DAN=Bogf. lëg-pÜ-lager-linjer (lager);
               ENU=Posted Invt. Put-away Lines];
    LinksAllowed=No;
    SourceTable=Table7341;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 49      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 50      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Vis bilag;
                                 ENU=Show Document];
                      ToolTipML=[DAN=èbn det bilag, hvor den valgte linje findes.;
                                 ENU=Open the document that the selected line exists on.];
                      ApplicationArea=#Warehouse;
                      Image=View;
                      OnAction=BEGIN
                                 PostedInvtPutAway.GET("No.");
                                 PAGE.RUN(PAGE::"Posted Invt. Put-away",PostedInvtPutAway);
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

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Warehouse;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den bogfõrte lëg-pÜ-lager-linje.;
                           ENU=Specifies the number of the posted inventory put-away line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Line No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver handlingstypen for lëg-pÜ-lager-linjen.;
                           ENU=Specifies the action type for the inventory put-away line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Action Type";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den bilagstype, som linjen vedrõrer.;
                           ENU=Specifies the type of document that the line relates to.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source Document" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ det kildebilag, som posten stammer fra.;
                           ENU=Specifies the number of the source document that the entry originates from.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source No." }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den vare, der er lagt pÜ lager.;
                           ENU=Specifies the number of the item that was put away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Item No." }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant pÜ linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af den vare, der er lagt pÜ lager.;
                           ENU=Specifies a description of the item that was put away.];
                ApplicationArea=#Warehouse;
                SourceExpr=Description }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver serienummeret pÜ den vare, der er lagt pÜ lager.;
                           ENU=Specifies the serial number for the item that was put away.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Serial No.";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver lotnummeret pÜ den vare, der er lagt pÜ lager.;
                           ENU=Specifies the lot number for the item that was put away.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Lot No.";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver udlõbsdatoen for den vare, der er lagt pÜ lager.;
                           ENU=Specifies the expiration date for the item that was put away.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Expiration Date";
                Visible=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, hvor varerne er lagt pÜ lager.;
                           ENU=Specifies the code for the location where the items were put away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Location Code";
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, hvor varerne plukkes eller lëgges pÜ lager.;
                           ENU=Specifies the bin where the items are picked or put away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code" }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver hyldenummeret for varen til brugerens orientering.;
                           ENU=Specifies the shelf number of the item for informational use.];
                ApplicationArea=#Warehouse;
                SourceExpr="Shelf No.";
                Visible=FALSE }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af den vare, som er lagt pÜ lager.;
                           ENU=Specifies the quantity of the item that was put away.];
                ApplicationArea=#Warehouse;
                SourceExpr=Quantity }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet i basisenheder af den vare, der er lagt pÜ lager.;
                           ENU=Specifies the quantity, in the base unit of measure, of the item that was put away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. (Base)";
                Visible=FALSE }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor lageraktiviteten skal vëre afsluttet.;
                           ENU=Specifies the date when the warehouse activity must be completed.];
                ApplicationArea=#Warehouse;
                SourceExpr="Due Date" }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen mÜles, f.eks. i enheder eller timer. Som standard indsëttes vërdien i feltet Basisenhed pÜ kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Warehouse;
                SourceExpr="Unit of Measure Code" }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet i enheder af den vare, der er lagt pÜ lager.;
                           ENU=Specifies the quantity per unit of measure of the item that was put away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. per Unit of Measure";
                Visible=FALSE }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den destinationstype, der er tilknyttet den bogfõrte lëg-pÜ-lager-linje.;
                           ENU=Specifies the type of destination associated with the posted inventory put-away line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Destination Type";
                Visible=FALSE }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det nummer eller den kode for debitoren eller kreditoren, som linjen er tilknyttet.;
                           ENU=Specifies the number or code of the customer or vendor that the line is linked to.];
                ApplicationArea=#Warehouse;
                SourceExpr="Destination No.";
                Visible=FALSE }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver specialudstyrskoden for den vare, der er lagt pÜ lager.;
                           ENU=Specifies the special equipment code for the item that was put away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Special Equipment Code";
                Visible=FALSE }

  }
  CODE
  {
    VAR
      PostedInvtPutAway@1000 : Record 7340;

    BEGIN
    END.
  }
}

