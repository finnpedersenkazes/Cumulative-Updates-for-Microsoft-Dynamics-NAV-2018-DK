OBJECT Page 5799 Registered Pick Subform
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
    SourceTable=Table5773;
    DelayedInsert=Yes;
    PageType=ListPart;
    AutoSplitKey=Yes;
    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1907935204;1 ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 1901991904;2 ;Action    ;
                      CaptionML=[DAN=&Kildedokumentlinje;
                                 ENU=Source &Document Line];
                      ToolTipML=[DAN=F† vist linjen p† et frigivet kildedokument, som lageraktiviteten vedr›rer.;
                                 ENU="View the line on a released source document that the warehouse activity is for. "];
                      ApplicationArea=#Warehouse;
                      Image=SourceDocLine;
                      OnAction=BEGIN
                                 ShowSourceLine;
                               END;
                                }
      { 1901313504;2 ;Action    ;
                      CaptionML=[DAN=Lagerdokumentlinje;
                                 ENU=Whse. Document Line];
                      ToolTipML=[DAN=F† vist linjen p† et andet lagerdokument, som lageraktiviteten vedr›rer.;
                                 ENU=View the line on another warehouse document that the warehouse activity is for.];
                      ApplicationArea=#Warehouse;
                      Image=Line;
                      OnAction=BEGIN
                                 ShowWhseLine;
                               END;
                                }
      { 1900295904;2 ;Action    ;
                      CaptionML=[DAN=Bogf›rt lagerlev.linje;
                                 ENU=Posted Whse. Shipment Line];
                      ToolTipML=[DAN=F† vist den relaterede linje p† den bogf›rte lagerleverance.;
                                 ENU=View the related line on the posted warehouse shipment.];
                      ApplicationArea=#Warehouse;
                      Image=PostedShipment;
                      OnAction=BEGIN
                                 ShowPostedWhseShptLine;
                               END;
                                }
      { 1900545504;2 ;Action    ;
                      CaptionML=[DAN=Placeringsindh.ov.sigt;
                                 ENU=Bin Contents List];
                      ToolTipML=[DAN=F† vist indholdet af den valgte placering og de parametre, der definerer, hvordan varer sendes gennem placeringen.;
                                 ENU=View the contents of the selected bin and the parameters that define how items are routed through the bin.];
                      ApplicationArea=#Warehouse;
                      Image=BinContent;
                      OnAction=BEGIN
                                 ShowBinContents;
                               END;
                                }
      { 1907927604;1 ;ActionGroup;
                      CaptionML=[DAN=&Pluk;
                                 ENU=P&ick];
                      Image=CreateInventoryPickup }
      { 1903867004;2 ;Action    ;
                      CaptionML=[DAN=&Lagerposter;
                                 ENU=&Warehouse Entries];
                      ToolTipML=[DAN="F† vist historikken over antal, der er registreret for varen under lageraktiviteter. ";
                                 ENU="View the history of quantities that are registered for the item in warehouse activities. "];
                      ApplicationArea=#Warehouse;
                      Image=BinLedger;
                      OnAction=VAR
                                 RegisteredWhseActivityHdr@1001 : Record 5772;
                               BEGIN
                                 RegisteredWhseActivityHdr.GET("Activity Type","No.");
                                 ShowWhseEntries(RegisteredWhseActivityHdr."Registering Date");
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
                ToolTipML=[DAN=Angiver, hvilken handling du skal udf›re i forbindelse med varerne p† linjen.;
                           ENU=Specifies the action you must perform for the items on the line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Action Type";
                Visible=FALSE }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den bilagstype, som linjen vedr›rer.;
                           ENU=Specifies the type of document that the line relates to.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source Document" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det kildebilag, som posten stammer fra.;
                           ENU=Specifies the number of the source document that the entry originates from.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source No." }

    { 62  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor lageraktiviteten skal v‘re afsluttet.;
                           ENU=Specifies the date when the warehouse activity must be completed.];
                ApplicationArea=#Warehouse;
                SourceExpr="Due Date" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det serienummer, der blev behandlet.;
                           ENU=Specifies the serial number that was handled.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Serial No.";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det lotnummer, der blev behandlet.;
                           ENU=Specifies the lot number that was handled.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Lot No.";
                Visible=FALSE }

    { 1106000000;2;Field  ;
                ToolTipML=[DAN=Angiver udl›bsdatoen for det serienummer, der blev behandlet.;
                           ENU=Specifies the expiration date of the serial number that was handled.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Expiration Date";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver hyldenummeret for varen p† linjen til brugerens orientering.;
                           ENU=Specifies the shelf number of the item on the line for information use.];
                ApplicationArea=#Warehouse;
                SourceExpr="Shelf No.";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den zone, hvor placeringen p† linjen findes.;
                           ENU=Specifies the code of the zone in which the bin on this line is located.];
                ApplicationArea=#Warehouse;
                SourceExpr="Zone Code";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, hvor varerne plukkes eller l‘gges p† lager.;
                           ENU=Specifies the bin where the items are picked or put away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varenummeret p† den vare, som skal h†ndteres, f.eks. plukkes eller l‘gges p† lager.;
                           ENU=Specifies the item number of the item to be handled, such as picked or put away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Item No." }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af varen p† linjen.;
                           ENU=Specifies a description of the item on the line.];
                ApplicationArea=#Warehouse;
                SourceExpr=Description }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af varen p† linjen.;
                           ENU=Specifies a description of the item on the line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Description 2";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal varer, som blev lagt p† lager, plukket eller overflyttet.;
                           ENU=Specifies the quantity of the item that was put-away, picked or moved.];
                ApplicationArea=#Warehouse;
                SourceExpr=Quantity }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Advanced;
                SourceExpr="Unit of Measure Code" }

  }
  CODE
  {
    VAR
      WMSMgt@1000 : Codeunit 7302;

    LOCAL PROCEDURE ShowSourceLine@1();
    BEGIN
      WMSMgt.ShowSourceDocLine(
        "Source Type","Source Subtype","Source No.","Source Line No.","Source Subline No.");
    END;

    LOCAL PROCEDURE ShowBinContents@7301();
    VAR
      BinContent@1000 : Record 7302;
    BEGIN
      BinContent.ShowBinContents("Location Code","Item No.","Variant Code","Bin Code");
    END;

    LOCAL PROCEDURE ShowWhseLine@3();
    BEGIN
      WMSMgt.ShowWhseDocLine(
        "Whse. Document Type","Whse. Document No.","Whse. Document Line No.");
    END;

    LOCAL PROCEDURE ShowPostedWhseShptLine@2();
    BEGIN
      WMSMgt.ShowPostedWhseShptLine("Whse. Document No.","Whse. Document Line No.");
    END;

    BEGIN
    END.
  }
}

