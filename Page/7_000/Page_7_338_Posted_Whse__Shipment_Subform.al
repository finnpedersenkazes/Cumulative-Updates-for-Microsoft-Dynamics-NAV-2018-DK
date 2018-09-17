OBJECT Page 7338 Posted Whse. Shipment Subform
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
    CaptionML=[DAN=Linjer;
               ENU=Lines];
    MultipleNewLines=Yes;
    LinksAllowed=No;
    SourceTable=Table7323;
    DelayedInsert=Yes;
    PageType=ListPart;
    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1907935204;1 ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 1903098904;2 ;Action    ;
                      CaptionML=[DAN=Bogfõrt kildedokument;
                                 ENU=Posted Source Document];
                      ToolTipML=[DAN=èbn listen over bogfõrte kildebilag.;
                                 ENU=Open the list of posted source documents.];
                      ApplicationArea=#Warehouse;
                      Image=PostedOrder;
                      OnAction=BEGIN
                                 ShowPostedSourceDoc;
                               END;
                                }
      { 1900545304;2 ;Action    ;
                      CaptionML=[DAN=Lagerdokumentlinje;
                                 ENU=Whse. Document Line];
                      ToolTipML=[DAN=FÜ vist linjen pÜ et andet lagerdokument, som lageraktiviteten vedrõrer.;
                                 ENU=View the line on another warehouse document that the warehouse activity is for.];
                      ApplicationArea=#Warehouse;
                      Image=Line;
                      OnAction=BEGIN
                                 ShowWhseLine;
                               END;
                                }
      { 1901991704;2 ;Action    ;
                      CaptionML=[DAN=Placeringsindh.ov.sigt;
                                 ENU=Bin Contents List];
                      ToolTipML=[DAN=FÜ vist indholdet af den valgte placering og de parametre, der definerer, hvordan varer sendes gennem placeringen.;
                                 ENU=View the contents of the selected bin and the parameters that define how items are routed through the bin.];
                      ApplicationArea=#Warehouse;
                      Image=BinContent;
                      OnAction=BEGIN
                                 ShowBinContents;
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
                ToolTipML=[DAN=Angiver den bilagstype, som linjen vedrõrer.;
                           ENU=Specifies the type of document that the line relates to.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source Document";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ det kildebilag, som posten stammer fra.;
                           ENU=Specifies the number of the source document that the entry originates from.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source No.";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjenummeret pÜ det kildebilag, som posten stammer fra.;
                           ENU=Specifies the line number of the source document that the entry originates from.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source Line No.";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den destinationstype, der er tilknyttet den bogfõrte lagerleverancelinje.;
                           ENU=Specifies the type of destination associated with the posted warehouse shipment line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Destination Type";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den debitor, kreditor eller lokation, som varerne er leveret til.;
                           ENU=Specifies the number of the customer, vendor, or location to which the items have been shipped.];
                ApplicationArea=#Warehouse;
                SourceExpr="Destination No.";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den vare, som er blevet afsendt.;
                           ENU=Specifies the number of the item that has been shipped.];
                ApplicationArea=#Warehouse;
                SourceExpr="Item No." }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant pÜ linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af varen pÜ linjen.;
                           ENU=Specifies the description of the item on the line.];
                ApplicationArea=#Warehouse;
                SourceExpr=Description }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en anden beskrivelse af varen pÜ linjen, hvis det er relevant.;
                           ENU=Specifies the a second description of the item on the line, if any.];
                ApplicationArea=#Warehouse;
                SourceExpr="Description 2";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den zone, hvor placeringen pÜ den bogfõrte leverancelinje findes.;
                           ENU=Specifies the code of the zone where the bin on this posted shipment line is located.];
                ApplicationArea=#Warehouse;
                SourceExpr="Zone Code";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, hvor varerne plukkes eller lëgges pÜ lager.;
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

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der er leveret.;
                           ENU=Specifies the quantity that was shipped.];
                ApplicationArea=#Warehouse;
                SourceExpr=Quantity }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen mÜles, f.eks. i enheder eller timer. Som standard indsëttes vërdien i feltet Basisenhed pÜ kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Warehouse;
                SourceExpr="Unit of Measure Code" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver afsendelsesadviset til den bogfõrte lagerleverancelinje.;
                           ENU=Specifies the shipping advice for the posted warehouse shipment line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Shipping Advice";
                Visible=FALSE }

  }
  CODE
  {
    VAR
      WMSMgt@1000 : Codeunit 7302;

    LOCAL PROCEDURE ShowPostedSourceDoc@1();
    BEGIN
      WMSMgt.ShowPostedSourceDoc("Posted Source Document","Posted Source No.");
    END;

    LOCAL PROCEDURE ShowBinContents@7301();
    VAR
      BinContent@1000 : Record 7302;
    BEGIN
      BinContent.ShowBinContents("Location Code","Item No.","Variant Code","Bin Code");
    END;

    LOCAL PROCEDURE ShowWhseLine@3();
    BEGIN
      WMSMgt.ShowWhseDocLine(2,"Whse. Shipment No.","Whse Shipment Line No.");
    END;

    BEGIN
    END.
  }
}

