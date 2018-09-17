OBJECT Page 7383 Invt. Movement Subform
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Linjer;
               ENU=Lines];
    MultipleNewLines=Yes;
    InsertAllowed=No;
    LinksAllowed=No;
    SourceTable=Table5767;
    DelayedInsert=Yes;
    SourceTableView=WHERE(Activity Type=CONST(Invt. Movement));
    PageType=ListPart;
    OnNewRecord=BEGIN
                  "Activity Type" := xRec."Activity Type";
                END;

    OnDeleteRecord=BEGIN
                     CurrPage.UPDATE(FALSE);
                   END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1906587504;1 ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 1900206104;2 ;Action    ;
                      Name=SplitWhseActivityLine;
                      ShortCutKey=Ctrl+F11;
                      CaptionML=[DAN=&Opdel linje;
                                 ENU=&Split Line];
                      ToolTipML=[DAN=Aktiv‚r, at varerne kan tages fra eller placeres p† mere end ‚n placering, f.eks., fordi antallet p† den foresl†ede placering er utilstr‘kkeligt til at blive plukket eller flyttet, eller der ikke er plads til at l‘gge det n›dvendige antal p† lager.;
                                 ENU=Enable that the items can be taken or placed in more than one bin, for example, because the quantity in the suggested bin is insufficient to pick or move or there is not enough room to put away the required quantity.];
                      ApplicationArea=#Warehouse;
                      Image=Split;
                      OnAction=BEGIN
                                 SplitLines;
                               END;
                                }
      { 1907935204;1 ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 1900724104;2 ;Action    ;
                      CaptionML=[DAN=&Kildedokumentlinje;
                                 ENU=Source &Document Line];
                      ToolTipML=[DAN=F† vist linjen p† et frigivet kildedokument, som lageraktiviteten vedr›rer.;
                                 ENU="View the line on a released source document that the warehouse activity is for. "];
                      ApplicationArea=#Advanced;
                      Image=SourceDocLine;
                      OnAction=BEGIN
                                 ShowSourceLine;
                               END;
                                }
      { 1901652704;2 ;Action    ;
                      CaptionML=[DAN=Placeringsindh.oversigt;
                                 ENU=Bin Contents List];
                      ToolTipML=[DAN=F† vist indholdet af den valgte placering og de parametre, der definerer, hvordan varer sendes gennem placeringen.;
                                 ENU=View the contents of the selected bin and the parameters that define how items are routed through the bin.];
                      ApplicationArea=#Warehouse;
                      Image=BinContent;
                      OnAction=BEGIN
                                 ShowBinContents;
                               END;
                                }
      { 1901652504;2 ;ActionGroup;
                      CaptionML=[DAN=Varedisponering pr.;
                                 ENU=Item Availability by];
                      Image=ItemAvailability }
      { 3       ;3   ;Action    ;
                      CaptionML=[DAN=Begivenhed;
                                 ENU=Event];
                      ToolTipML=[DAN=Se, hvordan den faktiske og forventede tilg‘ngelige saldo for en vare udvikler sig over tid i henhold til udbud og eftersp›rgsel.;
                                 ENU=View how the actual and the projected available balance of an item will develop over time according to supply and demand events.];
                      ApplicationArea=#Advanced;
                      Image=Event;
                      OnAction=BEGIN
                                 ItemAvailability(ItemAvailFormsMgt.ByEvent);
                               END;
                                }
      { 1903098904;3 ;Action    ;
                      CaptionML=[DAN=Periode;
                                 ENU=Period];
                      ToolTipML=[DAN=Vis det forventede antal af en vare over tid i henhold til tidsperioder som f.eks. dag, uge eller m†ned.;
                                 ENU=View the projected quantity of the item over time according to time periods, such as day, week, or month.];
                      ApplicationArea=#Advanced;
                      Image=Period;
                      OnAction=BEGIN
                                 ItemAvailability(ItemAvailFormsMgt.ByPeriod);
                               END;
                                }
      { 1900545304;3 ;Action    ;
                      CaptionML=[DAN=Variant;
                                 ENU=Variant];
                      ToolTipML=[DAN=Vis eller rediger varens varianter. I stedet for at konfigurere hver varefarve som en separat vare kan du konfigurere de forskellige farver som varianter af varen.;
                                 ENU=View or edit the item's variants. Instead of setting up each color of an item as a separate item, you can set up the various colors as variants of the item.];
                      ApplicationArea=#Advanced;
                      Image=ItemVariant;
                      OnAction=BEGIN
                                 ItemAvailability(ItemAvailFormsMgt.ByVariant);
                               END;
                                }
      { 1901991704;3 ;Action    ;
                      AccessByPermission=TableData 14=R;
                      CaptionML=[DAN=Lokation;
                                 ENU=Location];
                      ToolTipML=[DAN=Vis det faktiske og det forventede antal af en vare efter lokation.;
                                 ENU=View the actual and projected quantity of the item per location.];
                      ApplicationArea=#Advanced;
                      Image=Warehouse;
                      OnAction=BEGIN
                                 ItemAvailability(ItemAvailFormsMgt.ByLocation);
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

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver handlingstypen for lageraktivitetslinjen.;
                           ENU=Specifies the action type for the warehouse activity line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Action Type" }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den bilagstype, som linjen vedr›rer.;
                           ENU=Specifies the type of document that the line relates to.];
                OptionCaptionML=[DAN=" ,,,,,,,,,,,Prod. Forbrug,,,,,,,,,Montageforbrug";
                                 ENU=" ,,,,,,,,,,,Prod. Consumption,,,,,,,,,Assembly Consumption"];
                ApplicationArea=#Warehouse;
                BlankZero=Yes;
                SourceExpr="Source Document";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det kildebilag, som posten stammer fra.;
                           ENU=Specifies the number of the source document that the entry originates from.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source No.";
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

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det serienummer, der skal h†ndteres, i bilaget.;
                           ENU=Specifies the serial number to handle in the document.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Serial No.";
                Visible=FALSE;
                OnValidate=BEGIN
                             SerialNoOnAfterValidate;
                           END;
                            }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at serienummeret er blokeret p† dets oplysningskort.;
                           ENU=Specifies the serial number is blocked, on its information card.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Serial No. Blocked";
                Visible=FALSE }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det lotnummer, der skal h†ndteres, i bilaget.;
                           ENU=Specifies the lot number to handle in the document.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Lot No.";
                Visible=FALSE;
                OnValidate=BEGIN
                             LotNoOnAfterValidate;
                           END;
                            }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at lotnummeret er blokeret p† dets oplysningskort.;
                           ENU=Specifies the lot number is blocked, on its information card.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Lot No. Blocked";
                Visible=FALSE }

    { 62  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver udl›bsdatoen for serie/lotnumrene, hvis du l‘gger varer p† lager.;
                           ENU=Specifies the expiration date of the serial/lot numbers if you are putting items away.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Expiration Date";
                Visible=FALSE;
                Editable=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, hvor aktiviteten forekommer.;
                           ENU=Specifies the code for the location where the activity occurs.];
                ApplicationArea=#Warehouse;
                SourceExpr="Location Code";
                Visible=FALSE }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, hvor varerne plukkes eller l‘gges p† lager.;
                           ENU=Specifies the bin where the items are picked or put away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code";
                OnValidate=BEGIN
                             BinCodeOnAfterValidate;
                           END;
                            }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver hyldenummeret for varen til brugerens orientering.;
                           ENU=Specifies the shelf number of the item for informational use.];
                ApplicationArea=#Warehouse;
                SourceExpr="Shelf No.";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af den vare, som skal h†ndteres, f.eks. modtages, l‘gges p† lager eller tildeles.;
                           ENU=Specifies the quantity of the item to be handled, such as received, put-away, or assigned.];
                ApplicationArea=#Warehouse;
                SourceExpr=Quantity }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af den vare, der skal h†ndteres, anf›rt i basisenheder.;
                           ENU=Specifies the quantity of the item to be handled, in the base unit of measure.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. (Base)";
                Visible=FALSE }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder der skal h†ndteres i denne lageraktivitet.;
                           ENU=Specifies how many units to handle in this warehouse activity.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. to Handle";
                OnValidate=BEGIN
                             QtytoHandleOnAfterValidate;
                           END;
                            }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet varer p† linjen, som endnu ikke er blevet h†ndteret i forbindelse med lageraktiviteten.;
                           ENU=Specifies the number of items on the line that have been handled in this warehouse activity.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. Handled";
                Visible=TRUE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af varer, som skal h†ndteres i forbindelse med lageraktiviteten.;
                           ENU=Specifies the quantity of items to be handled in this warehouse activity.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. to Handle (Base)";
                Visible=FALSE }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet varer p† linjen, som endnu ikke er blevet h†ndteret i forbindelse med lageraktiviteten.;
                           ENU=Specifies the number of items on the line that have been handled in this warehouse activity.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. Handled (Base)";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet varer, som endnu ikke er blevet h†ndteret for lageraktivitetslinjen.;
                           ENU=Specifies the number of items that have not yet been handled for this warehouse activity line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. Outstanding";
                Visible=TRUE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af varer, anf›rt i basisenheder, som endnu ikke er blevet h†ndteret for lageraktivitetslinjen.;
                           ENU=Specifies the number of items, expressed in the base unit of measure, that have not yet been handled for this warehouse activity line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. Outstanding (Base)";
                Visible=FALSE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor lageraktiviteten skal v‘re afsluttet.;
                           ENU=Specifies the date when the warehouse activity must be completed.];
                ApplicationArea=#Warehouse;
                SourceExpr="Due Date";
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Warehouse;
                SourceExpr="Unit of Measure Code" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet pr. enhed for varen p† linjen.;
                           ENU=Specifies the quantity per unit of measure of the item on the line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. per Unit of Measure";
                Visible=FALSE }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det afsendelsesadvis, som oplyser, hvorvidt delleverancer er acceptable. og som er kopieret fra kildedokumenthovedet.;
                           ENU=Specifies the shipping advice, informing whether partial deliveries are acceptable, copied from the source document header.];
                ApplicationArea=#Warehouse;
                SourceExpr="Shipping Advice";
                Visible=FALSE }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver oplysninger om den destinationstype, f.eks. debitor eller kreditor, som er knyttet til lageraktivitetslinjen.;
                           ENU=Specifies information about the type of destination, such as customer or vendor, associated with the warehouse activity line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Destination Type";
                Visible=FALSE }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret eller koden for den debitor, kreditor eller lokation, som er knyttet til aktivitetslinjen.;
                           ENU=Specifies the number or code of the customer, vendor or location related to the activity line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Destination No.";
                Visible=FALSE }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den spedit›r, som transporterer varerne.;
                           ENU=Specifies the code for the shipping agent who is transporting the items.];
                ApplicationArea=#Warehouse;
                SourceExpr="Shipping Agent Code";
                Visible=FALSE }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for servicen, f.eks. levering samme dag, som tilbydes af spedit›ren.;
                           ENU=Specifies the code for the service, such as a one-day delivery, that is offered by the shipping agent.];
                ApplicationArea=#Warehouse;
                SourceExpr="Shipping Agent Service Code";
                Visible=FALSE }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver betingelserne for levering af den relaterede leverance, som f.eks. frit ombord (FOB).;
                           ENU=Specifies the delivery conditions of the related shipment, such as free on board (FOB).];
                ApplicationArea=#Warehouse;
                SourceExpr="Shipment Method Code";
                Visible=FALSE }

    { 68  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for det udstyr, der kr‘ves, n†r du udf›rer handlingen p† linjen.;
                           ENU=Specifies the code of the equipment required when you perform the action on the line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Special Equipment Code";
                Visible=FALSE }

  }
  CODE
  {
    VAR
      ItemAvailFormsMgt@1001 : Codeunit 353;
      WMSMgt@1000 : Codeunit 7302;

    LOCAL PROCEDURE ShowSourceLine@1();
    BEGIN
      WMSMgt.ShowSourceDocLine(
        "Source Type","Source Subtype","Source No.","Source Line No.","Source Subline No.");
    END;

    LOCAL PROCEDURE ShowBinContents@2();
    VAR
      BinContent@1000 : Record 7302;
    BEGIN
      BinContent.ShowBinContents("Location Code","Item No.","Variant Code",'')
    END;

    LOCAL PROCEDURE ItemAvailability@3(AvailabilityType@1000 : 'Date,Variant,Location,Bin,Event,BOM');
    BEGIN
      ItemAvailFormsMgt.ShowItemAvailFromWhseActivLine(Rec,AvailabilityType);
    END;

    [External]
    PROCEDURE AutofillQtyToHandle@4();
    VAR
      WhseActivLine@1000 : Record 5767;
    BEGIN
      WhseActivLine.COPY(Rec);
      AutofillQtyToHandle(WhseActivLine);
    END;

    [External]
    PROCEDURE DeleteQtyToHandle@5();
    VAR
      WhseActivLine@1000 : Record 5767;
    BEGIN
      WhseActivLine.COPY(Rec);
      DeleteQtyToHandle(WhseActivLine);
    END;

    LOCAL PROCEDURE SplitLines@6();
    VAR
      WhseActivLine@1000 : Record 5767;
    BEGIN
      WhseActivLine.COPY(Rec);
      SplitLine(WhseActivLine);
      COPY(WhseActivLine);
      CurrPage.UPDATE(FALSE);
    END;

    [External]
    PROCEDURE UpdateForm@7();
    BEGIN
      CurrPage.UPDATE;
    END;

    [External]
    PROCEDURE RegisterActivityYesNo@8();
    VAR
      WhseActivLine@1001 : Record 5767;
    BEGIN
      WhseActivLine.COPY(Rec);
      WhseActivLine.FILTERGROUP(3);
      WhseActivLine.SETRANGE(Breakbulk);
      WhseActivLine.FILTERGROUP(0);
      CODEUNIT.RUN(CODEUNIT::"Whse.-Act.-Register (Yes/No)",WhseActivLine);
      RESET;
      SETCURRENTKEY("Activity Type","No.","Sorting Sequence No.");
      FILTERGROUP(4);
      SETRANGE("Activity Type","Activity Type");
      SETRANGE("No.","No.");
      FILTERGROUP(3);
      SETRANGE(Breakbulk,FALSE);
      FILTERGROUP(0);
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE SerialNoOnAfterValidate@19074494();
    VAR
      ItemTrackingMgt@1002 : Codeunit 6500;
      ExpDate@1001 : Date;
      EntriesExist@1003 : Boolean;
    BEGIN
      IF "Serial No." <> '' THEN
        ExpDate :=
          ItemTrackingMgt.ExistingExpirationDate("Item No.","Variant Code","Lot No.","Serial No.",FALSE,EntriesExist);

      IF ExpDate <> 0D THEN
        "Expiration Date" := ExpDate;
    END;

    LOCAL PROCEDURE LotNoOnAfterValidate@19045288();
    VAR
      ItemTrackingMgt@1004 : Codeunit 6500;
      ExpDate@1001 : Date;
      EntriesExist@1003 : Boolean;
    BEGIN
      IF "Lot No." <> '' THEN
        ExpDate :=
          ItemTrackingMgt.ExistingExpirationDate("Item No.","Variant Code","Lot No.","Serial No.",FALSE,EntriesExist);

      IF ExpDate <> 0D THEN
        "Expiration Date" := ExpDate;
    END;

    LOCAL PROCEDURE BinCodeOnAfterValidate@19073508();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE QtytoHandleOnAfterValidate@19067087();
    BEGIN
      CurrPage.SAVERECORD;
    END;

    BEGIN
    END.
  }
}

