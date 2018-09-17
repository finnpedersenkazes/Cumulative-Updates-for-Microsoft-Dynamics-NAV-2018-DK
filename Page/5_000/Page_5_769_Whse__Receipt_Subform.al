OBJECT Page 5769 Whse. Receipt Subform
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
    SourceTable=Table7317;
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
      { 1900724404;2 ;Action    ;
                      CaptionML=[DAN=&Kildedokumentlinje;
                                 ENU=Source &Document Line];
                      ToolTipML=[DAN=F� vist linjen p� et frigivet kildedokument, som lageraktiviteten vedr�rer.;
                                 ENU="View the line on a released source document that the warehouse activity is for. "];
                      ApplicationArea=#Advanced;
                      Image=SourceDocLine;
                      OnAction=BEGIN
                                 ShowSourceLine;
                               END;
                                }
      { 1901313204;2 ;Action    ;
                      AccessByPermission=TableData 7302=R;
                      CaptionML=[DAN=&Placeringsindh.oversigt;
                                 ENU=&Bin Contents List];
                      ToolTipML=[DAN=F� vist indholdet af hver placering og de parametre, der definerer, hvordan varer sendes gennem placeringen.;
                                 ENU=View the contents of each bin and the parameters that define how items are routed through the bin.];
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
      { 3       ;3   ;Action    ;
                      CaptionML=[DAN=Begivenhed;
                                 ENU=Event];
                      ToolTipML=[DAN=Se, hvordan den faktiske og forventede tilg�ngelige saldo for en vare udvikler sig over tid i henhold til udbud og eftersp�rgsel.;
                                 ENU=View how the actual and the projected available balance of an item will develop over time according to supply and demand events.];
                      ApplicationArea=#Advanced;
                      Image=Event;
                      OnAction=BEGIN
                                 ItemAvailability(ItemAvailFormsMgt.ByEvent);
                               END;
                                }
      { 1901313504;3 ;Action    ;
                      CaptionML=[DAN=Periode;
                                 ENU=Period];
                      ToolTipML=[DAN=Vis det forventede antal af en vare over tid i henhold til tidsperioder som f.eks. dag, uge eller m�ned.;
                                 ENU=View the projected quantity of the item over time according to time periods, such as day, week, or month.];
                      ApplicationArea=#Advanced;
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
                      ApplicationArea=#Advanced;
                      Image=Warehouse;
                      OnAction=BEGIN
                                 ItemAvailability(ItemAvailFormsMgt.ByLocation);
                               END;
                                }
      { 1903100004;2 ;Action    ;
                      Name=ItemTrackingLines;
                      ShortCutKey=Shift+Ctrl+I;
                      CaptionML=[DAN=Vare&sporingslinjer;
                                 ENU=Item &Tracking Lines];
                      ToolTipML=[DAN=Vis eller rediger serienummer og lotnumre, der er tildelt varen p� bilags- eller kladdelinjen.;
                                 ENU=View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.];
                      ApplicationArea=#ItemTracking;
                      Image=ItemTrackingLines;
                      OnAction=BEGIN
                                 OpenItemTrackingLines;
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
                ToolTipML=[DAN=Angiver den bilagstype, som linjen vedr�rer.;
                           ENU=Specifies the type of document that the line relates to.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source Document" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� det kildebilag, som posten stammer fra.;
                           ENU=Specifies the number of the source document that the entry originates from.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source No." }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den vare, der forventes at blive modtaget.;
                           ENU=Specifies the number of the item that is expected to be received.];
                ApplicationArea=#Warehouse;
                SourceExpr="Item No." }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p� linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af varen p� linjen.;
                           ENU=Specifies the description of the item in the line.];
                ApplicationArea=#Warehouse;
                SourceExpr=Description }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, hvor varerne skal modtages.;
                           ENU=Specifies the code of the location where the items should be received.];
                ApplicationArea=#Warehouse;
                SourceExpr="Location Code";
                Visible=FALSE }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den zone, hvor varerne modtages.;
                           ENU=Specifies the zone in which the items are being received.];
                ApplicationArea=#Warehouse;
                SourceExpr="Zone Code";
                Visible=FALSE }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, hvor varerne plukkes eller l�gges p� lager.;
                           ENU=Specifies the bin where the items are picked or put away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code";
                Visible=FALSE;
                OnValidate=BEGIN
                             BinCodeOnAfterValidate;
                           END;
                            }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken zonekode der bruges for det antal varer, der skal sendes direkte.;
                           ENU=Specifies the zone code that will be used for the quantity of items to be cross-docked.];
                ApplicationArea=#Warehouse;
                SourceExpr="Cross-Dock Zone Code";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placeringskode, der bruges for det antal varer, der skal sendes direkte.;
                           ENU=Specifies the bin code that will be used for the quantity of items to be cross-docked.];
                ApplicationArea=#Warehouse;
                SourceExpr="Cross-Dock Bin Code";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver hyldenummeret for varen til brugerens orientering.;
                           ENU=Specifies the shelf number of the item for information use.];
                ApplicationArea=#Warehouse;
                SourceExpr="Shelf No.";
                Visible=FALSE }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der skal modtages.;
                           ENU=Specifies the quantity that should be received.];
                ApplicationArea=#Warehouse;
                SourceExpr=Quantity }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der skal modtages, anf�rt i basisenheder.;
                           ENU=Specifies the quantity to be received, in the base unit of measure.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. (Base)";
                Visible=FALSE }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal varer, der endnu ikke er modtaget.;
                           ENU=Specifies the quantity of items that remains to be received.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. to Receive";
                OnValidate=BEGIN
                             QtytoReceiveOnAfterValidate;
                           END;
                            }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det foresl�ede antal, der skal s�ttes p� placeringen til direkte afsendelse, p� l�g-p�-lager-bilaget, n�r modtagelsen bogf�res.;
                           ENU=Specifies the suggested quantity to put into the cross-dock bin on the put-away document when the receipt is posted.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. to Cross-Dock";
                Visible=FALSE;
                OnLookup=BEGIN
                           ShowCrossDockOpp(CrossDockOpp2);
                           CurrPage.UPDATE;
                         END;
                          }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der er bogf�rt som modtaget for linjen.;
                           ENU=Specifies the quantity for this line that has been posted as received.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. Received";
                Visible=TRUE }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver Modtag (antal), anf�rt i basisenheder.;
                           ENU=Specifies the Qty. to Receive in the base unit of measure.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. to Receive (Base)";
                Visible=FALSE }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det foresl�ede basisantal, der skal s�ttes p� placeringen til direkte afsendelse, p� l�g-p�-lager-bilaget, n�r modtagelsen bogf�res.;
                           ENU=Specifies the suggested base quantity to put into the cross-dock bin on the put-away document hen the receipt is posted.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. to Cross-Dock (Base)";
                Visible=FALSE;
                OnLookup=BEGIN
                           ShowCrossDockOpp(CrossDockOpp2);
                           CurrPage.UPDATE;
                         END;
                          }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der er modtaget, anf�rt i basisenheder.;
                           ENU=Specifies the quantity received, in the base unit of measure.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. Received (Base)";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der stadig mangler at blive h�ndteret.;
                           ENU=Specifies the quantity that still needs to be handled.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. Outstanding";
                Visible=TRUE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der mangler at blive h�ndteret, anf�rt i basisenheder.;
                           ENU=Specifies the quantity that still needs to be handled, in the base unit of measure.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. Outstanding (Base)";
                Visible=FALSE }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor varerne p� linjen forventes modtaget.;
                           ENU=Specifies the date on which you expect to receive the items on the line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Due Date" }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m�les, f.eks. i enheder eller timer. Som standard inds�ttes v�rdien i feltet Basisenhed p� kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Warehouse;
                SourceExpr="Unit of Measure Code" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange basisenheder der g�r p� den enhed, der er angivet for varen p� linjen.;
                           ENU=Specifies the number of base units of measure, that are in the unit of measure specified for the item on the line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. per Unit of Measure" }

  }
  CODE
  {
    VAR
      CrossDockOpp2@1000 : Record 5768;
      ItemAvailFormsMgt@1002 : Codeunit 353;
      Text001@1001 : TextConst 'DAN=Direkte afsendelse er deaktiveret for varen %1 eller lokationen %2.;ENU=Cross-docking has been disabled for item %1 or location %2.';

    LOCAL PROCEDURE ShowSourceLine@1();
    VAR
      WMSMgt@1000 : Codeunit 7302;
    BEGIN
      WMSMgt.ShowSourceDocLine(
        "Source Type","Source Subtype","Source No.","Source Line No.",0);
    END;

    LOCAL PROCEDURE ShowBinContents@6();
    VAR
      BinContent@1000 : Record 7302;
    BEGIN
      BinContent.ShowBinContents("Location Code","Item No.","Variant Code","Bin Code");
    END;

    LOCAL PROCEDURE ItemAvailability@7(AvailabilityType@1000 : 'Date,Variant,Location,Bin,Event,BOM');
    BEGIN
      ItemAvailFormsMgt.ShowItemAvailFromWhseRcptLine(Rec,AvailabilityType);
    END;

    [External]
    PROCEDURE WhsePostRcptYesNo@3();
    VAR
      WhseRcptLine@1001 : Record 7317;
    BEGIN
      WhseRcptLine.COPY(Rec);
      CODEUNIT.RUN(CODEUNIT::"Whse.-Post Receipt (Yes/No)",WhseRcptLine);
      RESET;
      SETCURRENTKEY("No.","Sorting Sequence No.");
      CurrPage.UPDATE(FALSE);
    END;

    [External]
    PROCEDURE WhsePostRcptPrint@4();
    VAR
      WhseRcptLine@1001 : Record 7317;
    BEGIN
      WhseRcptLine.COPY(Rec);
      CODEUNIT.RUN(CODEUNIT::"Whse.-Post Receipt + Print",WhseRcptLine);
      RESET;
      SETCURRENTKEY("No.","Sorting Sequence No.");
      CurrPage.UPDATE(FALSE);
    END;

    [External]
    PROCEDURE WhsePostRcptPrintPostedRcpt@5();
    VAR
      WhseRcptLine@1001 : Record 7317;
    BEGIN
      WhseRcptLine.COPY(Rec);
      CODEUNIT.RUN(CODEUNIT::"Whse.-Post Receipt + Pr. Pos.",WhseRcptLine);
      RESET;
      CurrPage.UPDATE(FALSE);
    END;

    [External]
    PROCEDURE AutofillQtyToReceive@10();
    VAR
      WhseRcptLine@1000 : Record 7317;
    BEGIN
      WhseRcptLine.COPY(Rec);
      AutofillQtyToReceive(WhseRcptLine);
    END;

    [External]
    PROCEDURE DeleteQtyToReceive@8();
    VAR
      WhseRcptLine@1000 : Record 7317;
    BEGIN
      WhseRcptLine.COPY(Rec);
      DeleteQtyToReceive(WhseRcptLine);
    END;

    LOCAL PROCEDURE OpenItemTrackingLines@6500();
    BEGIN
      OpenItemTrackingLines;
    END;

    LOCAL PROCEDURE ShowCrossDockOpp@2(VAR CrossDockOpp@1000 : TEMPORARY Record 5768);
    VAR
      CrossDockMgt@1001 : Codeunit 5780;
      UseCrossDock@1002 : Boolean;
    BEGIN
      CrossDockMgt.GetUseCrossDock(UseCrossDock,"Location Code","Item No.");
      IF NOT UseCrossDock THEN
        ERROR(Text001,"Item No.","Location Code");
      CrossDockMgt.ShowCrossDock(CrossDockOpp,'',"No.","Line No.","Location Code","Item No.","Variant Code");
    END;

    LOCAL PROCEDURE BinCodeOnAfterValidate@19073508();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE QtytoReceiveOnAfterValidate@19059245();
    BEGIN
      CurrPage.SAVERECORD;
    END;

    BEGIN
    END.
  }
}

