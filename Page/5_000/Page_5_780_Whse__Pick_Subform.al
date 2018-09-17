OBJECT Page 5780 Whse. Pick Subform
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
    SourceTableView=WHERE(Activity Type=CONST(Pick));
    PageType=ListPart;
    AutoSplitKey=Yes;
    OnInit=BEGIN
             BinCodeEditable := TRUE;
             ZoneCodeEditable := TRUE;
           END;

    OnNewRecord=BEGIN
                  "Activity Type" := xRec."Activity Type";
                END;

    OnDeleteRecord=BEGIN
                     CurrPage.UPDATE(FALSE);
                   END;

    OnAfterGetCurrRecord=BEGIN
                           EnableZoneBin;
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
                      OnAction=VAR
                                 WhseActivLine@1001 : Record 5767;
                               BEGIN
                                 WhseActivLine.COPY(Rec);
                                 SplitLine(WhseActivLine);
                                 COPY(WhseActivLine);
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 1900724304;2 ;Action    ;
                      Name=ChangeUnitOfMeasure;
                      Ellipsis=Yes;
                      CaptionML=[DAN=S&kift enhed;
                                 ENU=&Change Unit Of Measure];
                      ToolTipML=[DAN=Angiv, hvilken enhed du vil ‘ndre under lageraktiviteten, f.eks. fordi du vil leverer en vare kassevis, selvom du opbevarer den pallevis.;
                                 ENU=Specify which unit of measure you want to change during the warehouse activity, for example, because you want to ship an item in boxes although you store it in pallets.];
                      ApplicationArea=#Advanced;
                      Image=UnitConversions;
                      OnAction=BEGIN
                                 ChangeUOM;
                               END;
                                }
      { 1907935204;1 ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 1900724404;2 ;Action    ;
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
      { 1901652504;2 ;Action    ;
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
      { 1900545304;2 ;Action    ;
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
      { 1903867104;2 ;ActionGroup;
                      CaptionML=[DAN=Varedisponering pr.;
                                 ENU=Item Availability by];
                      Image=ItemAvailability }
      { 5       ;3   ;Action    ;
                      CaptionML=[DAN=Begivenhed;
                                 ENU=Event];
                      ToolTipML=[DAN=Se, hvordan den faktiske og forventede tilg‘ngelige saldo for en vare udvikler sig over tid i henhold til udbud og eftersp›rgsel.;
                                 ENU=View how the actual and the projected available balance of an item will develop over time according to supply and demand events.];
                      ApplicationArea=#Warehouse;
                      Image=Event;
                      OnAction=BEGIN
                                 ItemAvailability(ItemAvailFormsMgt.ByEvent);
                               END;
                                }
      { 1901313504;3 ;Action    ;
                      CaptionML=[DAN=Periode;
                                 ENU=Period];
                      ToolTipML=[DAN=Vis det forventede antal af en vare over tid i henhold til tidsperioder som f.eks. dag, uge eller m†ned.;
                                 ENU=View the projected quantity of the item over time according to time periods, such as day, week, or month.];
                      ApplicationArea=#Warehouse;
                      Image=Period;
                      OnAction=BEGIN
                                 ItemAvailability(ItemAvailFormsMgt.ByPeriod);
                               END;
                                }
      { 1900295904;3 ;Action    ;
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
      { 1901742304;3 ;Action    ;
                      AccessByPermission=TableData 14=R;
                      CaptionML=[DAN=Lokation;
                                 ENU=Location];
                      ToolTipML=[DAN=Vis det faktiske og det forventede antal af en vare efter lokation.;
                                 ENU=View the actual and projected quantity of the item per location.];
                      ApplicationArea=#Warehouse;
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
                SourceExpr="Action Type";
                Visible=FALSE }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den bilagstype, som linjen vedr›rer.;
                           ENU=Specifies the type of document that the line relates to.];
                OptionCaptionML=[DAN=,Salgsordre,,,Salgsreturv.ordre,K›bsordre,,,K›bsreturv.ordre,,Udg. overf›rsel,Prod.forbrug,,,,,,,Serviceordre,,Montageforbrug;
                                 ENU=,Sales Order,,,Sales Return Order,Purchase Order,,,Purchase Return Order,,Outbound Transfer,Prod. Consumption,,,,,,,Service Order,,Assembly Consumption];
                ApplicationArea=#Warehouse;
                BlankZero=Yes;
                SourceExpr="Source Document" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det kildebilag, som posten stammer fra.;
                           ENU=Specifies the number of the source document that the entry originates from.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source No." }

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

    { 70  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at lotnummeret er blokeret p† dets oplysningskort.;
                           ENU=Specifies the lot number is blocked, on its information card.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Lot No. Blocked";
                Visible=FALSE }

    { 1106000000;2;Field  ;
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

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den zone, hvor placeringen p† linjen findes.;
                           ENU=Specifies the zone code where the bin on this line is located.];
                ApplicationArea=#Warehouse;
                SourceExpr="Zone Code";
                Visible=FALSE;
                Editable=ZoneCodeEditable }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, hvor varerne plukkes eller l‘gges p† lager.;
                           ENU=Specifies the bin where the items are picked or put away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code";
                Visible=FALSE;
                Editable=BinCodeEditable;
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
                SourceExpr="Due Date" }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Advanced;
                SourceExpr="Unit of Measure Code" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet pr. enhed for varen p† linjen.;
                           ENU=Specifies the quantity per unit of measure of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Qty. per Unit of Measure" }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver afsendelsesadviset, som indeholder oplysninger om, hvorvidt delleverancer er acceptable.;
                           ENU=Specifies the shipping advice, which informs whether partial deliveries are acceptable.];
                ApplicationArea=#Warehouse;
                SourceExpr="Shipping Advice";
                Visible=FALSE }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver oplysninger om den destinationstype, f.eks. debitor eller kreditor, som er knyttet til lageraktivitetslinjen.;
                           ENU=Specifies information about the type of destination, such as customer or vendor, associated with the warehouse activity line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Destination Type" }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret eller koden for den debitor, kreditor eller lokation, som er knyttet til aktivitetslinjen.;
                           ENU=Specifies the number or code of the customer, vendor or location related to the activity line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Destination No." }

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

    { 62  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den lagerdokumenttype, som linjen stammer fra.;
                           ENU=Specifies the type of warehouse document from which the line originated.];
                OptionCaptionML=[DAN=" ,,Leverance,,Internt pluk,Produktion,,,Montage";
                                 ENU=" ,,Shipment,,Internal Pick,Production,,,Assembly"];
                ApplicationArea=#Warehouse;
                SourceExpr="Whse. Document Type";
                Visible=FALSE }

    { 64  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det lagerdokument, som danner grundlag for handlingen p† linjen.;
                           ENU=Specifies the number of the warehouse document that is the basis for the action on the line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Whse. Document No.";
                Visible=FALSE }

    { 66  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den linje i lagerdokumentet, som danner grundlag for handlingen p† linjen.;
                           ENU=Specifies the number of the line in the warehouse document that is the basis for the action on the line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Whse. Document Line No.";
                Visible=FALSE }

    { 68  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for det udstyr, der kr‘ves, n†r du udf›rer handlingen p† linjen.;
                           ENU=Specifies the code of the equipment required when you perform the action on the line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Special Equipment Code";
                Visible=FALSE }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om lagerpluklinjen g‘lder for montageelementer, der monteres til en salgsordre, f›r den leveres.;
                           ENU=Specifies that the inventory pick line is for assembly items that are assembled to a sales order before being shipped.];
                ApplicationArea=#Assembly;
                SourceExpr="Assemble to Order";
                Visible=FALSE }

  }
  CODE
  {
    VAR
      ItemAvailFormsMgt@1001 : Codeunit 353;
      WMSMgt@1000 : Codeunit 7302;
      ZoneCodeEditable@19015203 : Boolean INDATASET;
      BinCodeEditable@19056442 : Boolean INDATASET;

    LOCAL PROCEDURE ShowSourceLine@1();
    BEGIN
      WMSMgt.ShowSourceDocLine(
        "Source Type","Source Subtype","Source No.","Source Line No.","Source Subline No.");
    END;

    LOCAL PROCEDURE ItemAvailability@7(AvailabilityType@1000 : 'Date,Variant,Location,Bin,Event,BOM');
    BEGIN
      ItemAvailFormsMgt.ShowItemAvailFromWhseActivLine(Rec,AvailabilityType);
    END;

    [External]
    PROCEDURE AutofillQtyToHandle@10();
    VAR
      WhseActivLine@1000 : Record 5767;
    BEGIN
      WhseActivLine.COPY(Rec);
      AutofillQtyToHandle(WhseActivLine);
    END;

    [External]
    PROCEDURE DeleteQtyToHandle@4();
    VAR
      WhseActivLine@1000 : Record 5767;
    BEGIN
      WhseActivLine.COPY(Rec);
      DeleteQtyToHandle(WhseActivLine);
    END;

    LOCAL PROCEDURE ChangeUOM@5();
    VAR
      WhseActLine@1001 : Record 5767;
      WhseChangeOUM@1000 : Report 7314;
    BEGIN
      TESTFIELD("Action Type");
      TESTFIELD("Breakbulk No.",0);
      TESTFIELD("Action Type",1);
      WhseChangeOUM.DefWhseActLine(Rec);
      WhseChangeOUM.RUNMODAL;
      IF WhseChangeOUM.ChangeUOMCode(WhseActLine) = TRUE THEN
        ChangeUOMCode(Rec,WhseActLine);
      CLEAR(WhseChangeOUM);
      CurrPage.UPDATE(FALSE);
    END;

    [External]
    PROCEDURE RegisterActivityYesNo@2();
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

    LOCAL PROCEDURE ShowBinContents@7301();
    VAR
      BinContent@1000 : Record 7302;
    BEGIN
      BinContent.ShowBinContents("Location Code","Item No.","Variant Code",'')
    END;

    LOCAL PROCEDURE ShowWhseLine@3();
    BEGIN
      WMSMgt.ShowWhseDocLine(
        "Whse. Document Type","Whse. Document No.","Whse. Document Line No.");
    END;

    LOCAL PROCEDURE EnableZoneBin@6();
    BEGIN
      ZoneCodeEditable :=
        ("Action Type" = "Action Type"::Take) OR ("Breakbulk No." <> 0);
      BinCodeEditable :=
        ("Action Type" = "Action Type"::Take) OR ("Breakbulk No." <> 0);
    END;

    LOCAL PROCEDURE SerialNoOnAfterValidate@19074494();
    VAR
      ItemTrackingMgt@1000 : Codeunit 6500;
      ExpDate@1106000002 : Date;
      EntriesExist@1106000000 : Boolean;
    BEGIN
      IF "Serial No." <> '' THEN
        ExpDate := ItemTrackingMgt.ExistingExpirationDate("Item No.","Variant Code",
            "Lot No.","Serial No.",FALSE,EntriesExist);

      IF ExpDate <> 0D THEN
        "Expiration Date" := ExpDate;
    END;

    LOCAL PROCEDURE LotNoOnAfterValidate@19045288();
    VAR
      ItemTrackingMgt@1000 : Codeunit 6500;
      ExpDate@1106000002 : Date;
      EntriesExist@1106000000 : Boolean;
    BEGIN
      IF "Lot No." <> '' THEN
        ExpDate := ItemTrackingMgt.ExistingExpirationDate("Item No.","Variant Code",
            "Lot No.","Serial No.",FALSE,EntriesExist);

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

