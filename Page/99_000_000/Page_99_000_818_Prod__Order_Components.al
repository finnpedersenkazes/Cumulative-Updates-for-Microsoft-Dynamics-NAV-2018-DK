OBJECT Page 99000818 Prod. Order Components
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Prod.ordrekomponenter;
               ENU=Prod. Order Components];
    MultipleNewLines=Yes;
    SourceTable=Table5407;
    DataCaptionExpr=Caption;
    DelayedInsert=Yes;
    PageType=List;
    AutoSplitKey=Yes;
    OnAfterGetRecord=BEGIN
                       ShowShortcutDimCode(ShortcutDimCode);
                     END;

    OnNewRecord=BEGIN
                  CLEAR(ShortcutDimCode);
                END;

    OnDeleteRecord=VAR
                     ReserveProdOrderComp@1000 : Codeunit 99000838;
                   BEGIN
                     COMMIT;
                     IF NOT ReserveProdOrderComp.DeleteLineConfirm(Rec) THEN
                       EXIT(FALSE);
                     ReserveProdOrderComp.DeleteLine(Rec);
                   END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 58      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 69      ;2   ;ActionGroup;
                      CaptionML=[DAN=Varedisponering pr.;
                                 ENU=Item Availability by];
                      Image=ItemAvailability }
      { 3       ;3   ;Action    ;
                      CaptionML=[DAN=Begivenhed;
                                 ENU=Event];
                      ToolTipML=[DAN=Se, hvordan den faktiske og forventede tilg�ngelige saldo for en vare udvikler sig over tid i henhold til udbud og eftersp�rgsel.;
                                 ENU=View how the actual and the projected available balance of an item will develop over time according to supply and demand events.];
                      ApplicationArea=#Manufacturing;
                      Image=Event;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromProdOrderComp(Rec,ItemAvailFormsMgt.ByEvent);
                               END;
                                }
      { 70      ;3   ;Action    ;
                      CaptionML=[DAN=Periode;
                                 ENU=Period];
                      ToolTipML=[DAN=Vis det forventede antal af en vare over tid i henhold til tidsperioder som f.eks. dag, uge eller m�ned.;
                                 ENU=View the projected quantity of the item over time according to time periods, such as day, week, or month.];
                      ApplicationArea=#Manufacturing;
                      Image=Period;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromProdOrderComp(Rec,ItemAvailFormsMgt.ByPeriod);
                               END;
                                }
      { 71      ;3   ;Action    ;
                      CaptionML=[DAN=Variant;
                                 ENU=Variant];
                      ToolTipML=[DAN=Vis eller rediger varens varianter. I stedet for at konfigurere hver varefarve som en separat vare kan du konfigurere de forskellige farver som varianter af varen.;
                                 ENU=View or edit the item's variants. Instead of setting up each color of an item as a separate item, you can set up the various colors as variants of the item.];
                      ApplicationArea=#Advanced;
                      Image=ItemVariant;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromProdOrderComp(Rec,ItemAvailFormsMgt.ByVariant);
                               END;
                                }
      { 72      ;3   ;Action    ;
                      AccessByPermission=TableData 14=R;
                      CaptionML=[DAN=Lokation;
                                 ENU=Location];
                      ToolTipML=[DAN=Vis det faktiske og det forventede antal af en vare efter lokation.;
                                 ENU=View the actual and projected quantity of the item per location.];
                      ApplicationArea=#Location;
                      Image=Warehouse;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromProdOrderComp(Rec,ItemAvailFormsMgt.ByLocation);
                               END;
                                }
      { 7       ;3   ;Action    ;
                      CaptionML=[DAN=Styklisteniveau;
                                 ENU=BOM Level];
                      ToolTipML=[DAN=F� vist tilg�ngelighedstallene for styklistevarer, der viser, hvor mange enheder af en overordnet vare, du kan fremstille, baseret p� tilg�ngeligheden af underordnede varer.;
                                 ENU=View availability figures for items on bills of materials that show how many units of a parent item you can make based on the availability of child items.];
                      ApplicationArea=#Manufacturing;
                      Image=BOMLevel;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromProdOrderComp(Rec,ItemAvailFormsMgt.ByBOM);
                               END;
                                }
      { 59      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m�rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf�j bem�rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000842;
                      RunPageLink=Status=FIELD(Status),
                                  Prod. Order No.=FIELD(Prod. Order No.),
                                  Prod. Order Line No.=FIELD(Prod. Order Line No.),
                                  Prod. Order BOM Line No.=FIELD(Line No.);
                      Image=ViewComments }
      { 30      ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr�de, projekt eller afdeling, som du kan tildele til salgs- og k�bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                                 CurrPage.SAVERECORD;
                               END;
                                }
      { 6500    ;2   ;Action    ;
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
      { 75      ;2   ;Action    ;
                      CaptionML=[DAN=Placeringsindh.;
                                 ENU=Bin Contents];
                      ToolTipML=[DAN=Vis varer i placeringen, hvis den valgte linje indeholder en placeringskode.;
                                 ENU=View items in the bin if the selected line contains a bin code.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7305;
                      RunPageView=SORTING(Location Code,Bin Code,Item No.,Variant Code);
                      RunPageLink=Location Code=FIELD(Location Code),
                                  Item No.=FIELD(Item No.),
                                  Variant Code=FIELD(Variant Code);
                      Image=BinContent }
      { 80      ;2   ;Action    ;
                      Name=SelectItemSubstitution;
                      AccessByPermission=TableData 5715=R;
                      CaptionML=[DAN=V�lg &erstatningsvare;
                                 ENU=&Select Item Substitution];
                      ToolTipML=[DAN=V�lg en anden vare, der er konfigureret til at blive handlet i stedet for den originale vare, hvis den ikke er tilg�ngelig.;
                                 ENU=Select another item that has been set up to be traded instead of the original item if it is unavailable.];
                      ApplicationArea=#Manufacturing;
                      Image=SelectItemSubstitution;
                      OnAction=BEGIN
                                 CurrPage.SAVERECORD;

                                 ShowItemSub;

                                 CurrPage.UPDATE(TRUE);

                                 AutoReserve;
                               END;
                                }
      { 77      ;2   ;Action    ;
                      CaptionML=[DAN=L�g-p�-lager/pluklinjer/bev�gelseslinjer;
                                 ENU=Put-away/Pick Lines/Movement Lines];
                      ToolTipML=[DAN=Vis oversigten over igangv�rende l�g-p�-lager-aktiviteter, pluk eller bev�gelser for ordren.;
                                 ENU=View the list of ongoing inventory put-aways, picks, or movements for the order.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 5785;
                      RunPageView=SORTING(Source Type,Source Subtype,Source No.,Source Line No.,Source Subline No.,Unit of Measure Code,Action Type,Breakbulk No.,Original Breakbulk);
                      RunPageLink=Source Type=CONST(5407),
                                  Source Subtype=CONST(3),
                                  Source No.=FIELD(Prod. Order No.),
                                  Source Line No.=FIELD(Prod. Order Line No.),
                                  Source Subline No.=FIELD(Line No.);
                      Image=PutawayLines }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 23      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 67      ;2   ;Action    ;
                      Name=Reserve;
                      CaptionML=[DAN=&Reserver;
                                 ENU=&Reserve];
                      ToolTipML=[DAN=Reserver den n�dvendige m�ngde p� den bilagslinje, som vinduet blev �bnet for.;
                                 ENU=Reserve the quantity that is required on the document line that you opened this window for.];
                      ApplicationArea=#Manufacturing;
                      Image=Reserve;
                      OnAction=BEGIN
                                 IF Status IN [Status::Simulated,Status::Planned] THEN
                                   ERROR(Text000,Status);

                                 CurrPage.SAVERECORD;
                                 ShowReservation;
                               END;
                                }
      { 60      ;2   ;Action    ;
                      Name=OrderTracking;
                      CaptionML=[DAN=Ordre&sporing;
                                 ENU=Order &Tracking];
                      ToolTipML=[DAN=Sporer forbindelsen mellem udbud og den dertil h�rende eftersp�rgsel. P� denne m�de kan du finde den oprindelige eftersp�rgsel, der medf�rte en specifik produktionsordre eller k�bsordre.;
                                 ENU=Tracks the connection of a supply to its corresponding demand. This can help you find the original demand that created a specific production order or purchase order.];
                      ApplicationArea=#Manufacturing;
                      Image=OrderTracking;
                      OnAction=VAR
                                 TrackingForm@1001 : Page 99000822;
                               BEGIN
                                 TrackingForm.SetProdOrderComponent(Rec);
                                 TrackingForm.RUNMODAL;
                               END;
                                }
      { 76      ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=G�r dig klar til at udskrive bilaget. Der �bnes et rapportanmodningsvindue for bilaget, hvor du kan angive, hvad der skal medtages p� udskriften.;
                                 ENU=Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.];
                      ApplicationArea=#Manufacturing;
                      Promoted=Yes;
                      Image=Print;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 ProdOrderComp@1001 : Record 5407;
                               BEGIN
                                 ProdOrderComp.COPY(Rec);
                                 REPORT.RUNMODAL(REPORT::"Prod. Order - Picking List",TRUE,TRUE,ProdOrderComp);
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
                ToolTipML=[DAN=Angiver nummeret p� den vare, der indg�r som komponent p� produktionsordrekomponentlisten.;
                           ENU=Specifies the number of the item that is a component in the production order component list.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Item No.";
                OnValidate=BEGIN
                             ItemNoOnAfterValidate;
                           END;
                            }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p� linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 65  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver forfaldsdatoen og -klokkesl�ttet i et kombineret format, der kaldes Forfaldsdato/tidspunkt.;
                           ENU=Specifies the due date and the due time, which are combined in a format called "due date-time".];
                ApplicationArea=#Manufacturing;
                SourceExpr="Due Date-Time";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver datoen, hvor den producerede vare skal v�re tilg�ngelig. Datoen kopieres fra hovedet p� produktionsordren.;
                           ENU=Specifies the date when the produced item must be available. The date is copied from the header of the production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Due Date" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af varen p� linjen.;
                           ENU=Specifies a description of the item on the line.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Description }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den procentdel af varen, du forventer g�r til spilde i produktionsprocessen.;
                           ENU=Specifies the percentage of the item that you expect to be scrapped in the production process.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Scrap %";
                Visible=FALSE;
                OnValidate=BEGIN
                             Scrap37OnAfterValidate;
                           END;
                            }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan feltet Antal bliver beregnet.;
                           ENU=Specifies how to calculate the Quantity field.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Calculation Formula";
                Visible=FALSE;
                OnValidate=BEGIN
                             CalculationFormulaOnAfterValid;
                           END;
                            }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver l�ngden af en vareenhed, n�r den m�les i den angivne enhed.;
                           ENU=Specifies the length of one item unit when measured in the specified unit of measure.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Length;
                Visible=FALSE;
                OnValidate=BEGIN
                             LengthOnAfterValidate;
                           END;
                            }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bredden af en vareenhed, n�r den m�les i den angivne enhed.;
                           ENU=Specifies the width of one item unit when measured in the specified unit of measure.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Width;
                Visible=FALSE;
                OnValidate=BEGIN
                             WidthOnAfterValidate;
                           END;
                            }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver v�gten af en vareenhed, n�r den m�les i den angivne enhed.;
                           ENU=Specifies the weight of one item unit when measured in the specified unit of measure.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Weight;
                Visible=FALSE;
                OnValidate=BEGIN
                             WeightOnAfterValidate;
                           END;
                            }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver dybden af en vareenhed, n�r den m�les i den angivne enhed.;
                           ENU=Specifies the depth of one item unit when measured in the specified unit of measure.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Depth;
                Visible=FALSE;
                OnValidate=BEGIN
                             DepthOnAfterValidate;
                           END;
                            }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af komponenten der kr�ves for at producere den overordnede vare.;
                           ENU=Specifies how many units of the component are required to produce the parent item.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Quantity per";
                OnValidate=BEGIN
                             QuantityperOnAfterValidate;
                           END;
                            }

    { 61  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen, der er blevet reserveret.;
                           ENU=Specifies how many units of this item have been reserved.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Reserved Quantity";
                Visible=FALSE;
                OnDrillDown=BEGIN
                              ShowReservationEntries(TRUE);
                              CurrPage.UPDATE(FALSE);
                            END;
                             }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m�les, f.eks. i enheder eller timer. Som standard inds�ttes v�rdien i feltet Basisenhed p� kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Unit of Measure Code";
                OnValidate=BEGIN
                             UnitofMeasureCodeOnAfterValida;
                           END;
                            }

    { 62  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan forbruget af varen (komponenten) beregnes og h�ndteres i produktionsprocesserne. Manuelt: Angiv og bogf�r forbrug i forbrugskladden manuelt. Fremad: Bogf�rer automatisk forbrug if�lge produktionsordrekomponentlinjerne, n�r den f�rste handling starter. Bagl�ns: Beregner og bogf�rer automatisk forbrug if�lge produktionsordrekomponentlinjerne, n�r produktionsordren er f�rdig. Pluk + Fremad / Pluk + Bagl�ns: Variationer med lagersted.;
                           ENU=Specifies how consumption of the item (component) is calculated and handled in production processes. Manual: Enter and post consumption in the consumption journal manually. Forward: Automatically posts consumption according to the production order component lines when the first operation starts. Backward: Automatically calculates and posts consumption according to the production order component lines when the production order is finished. Pick + Forward / Pick + Backward: Variations with warehousing.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Flushing Method" }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af komponenter, som forventes at blive forbrugt i produktionen af antallet p� linjen.;
                           ENU=Specifies the quantity of the component expected to be consumed during the production of the quantity on this line.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Expected Quantity" }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver forskellen mellem det f�rdige og det planlagte antal, eller angiver 0, hvis det f�rdige antal overstiger restantallet.;
                           ENU=Specifies the difference between the finished and planned quantities, or zero if the finished quantity is greater than the remaining quantity.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Remaining Quantity" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops�tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops�tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 300 ;2   ;Field     ;
                ApplicationArea=#Dimensions;
                SourceExpr=ShortcutDimCode[3];
                CaptionClass='1,2,3';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(3),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE;
                OnValidate=BEGIN
                             ValidateShortcutDimCode(3,ShortcutDimCode[3]);
                           END;
                            }

    { 302 ;2   ;Field     ;
                ApplicationArea=#Dimensions;
                SourceExpr=ShortcutDimCode[4];
                CaptionClass='1,2,4';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(4),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE;
                OnValidate=BEGIN
                             ValidateShortcutDimCode(4,ShortcutDimCode[4]);
                           END;
                            }

    { 304 ;2   ;Field     ;
                ApplicationArea=#Dimensions;
                SourceExpr=ShortcutDimCode[5];
                CaptionClass='1,2,5';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(5),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE;
                OnValidate=BEGIN
                             ValidateShortcutDimCode(5,ShortcutDimCode[5]);
                           END;
                            }

    { 306 ;2   ;Field     ;
                ApplicationArea=#Dimensions;
                SourceExpr=ShortcutDimCode[6];
                CaptionClass='1,2,6';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(6),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE;
                OnValidate=BEGIN
                             ValidateShortcutDimCode(6,ShortcutDimCode[6]);
                           END;
                            }

    { 308 ;2   ;Field     ;
                ApplicationArea=#Dimensions;
                SourceExpr=ShortcutDimCode[7];
                CaptionClass='1,2,7';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(7),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE;
                OnValidate=BEGIN
                             ValidateShortcutDimCode(7,ShortcutDimCode[7]);
                           END;
                            }

    { 310 ;2   ;Field     ;
                ApplicationArea=#Dimensions;
                SourceExpr=ShortcutDimCode[8];
                CaptionClass='1,2,8';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(8),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE;
                OnValidate=BEGIN
                             ValidateShortcutDimCode(8,ShortcutDimCode[8]);
                           END;
                            }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver rutebindingskoden, n�r du beregner produktionsordren.;
                           ENU=Specifies the routing link code when you calculate the production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Routing Link Code";
                Visible=FALSE }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver lokationen, hvor komponenten gemmes. Kopierer lokationskoden fra det tilsvarende felt i produktionsordrelinjen.;
                           ENU=Specifies the location where the component is stored. Copies the location code from the corresponding field on the production order line.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Visible=FALSE;
                OnValidate=BEGIN
                             LocationCodeOnAfterValidate;
                           END;
                            }

    { 73  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, hvor komponenten skal placeres, f�r den forbruges.;
                           ENU=Specifies the bin in which the component is to be placed before it is consumed.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code";
                Visible=FALSE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, p� �n enhed af varen eller ressourcen p� linjen.;
                           ENU=Specifies the cost of one unit of the item or resource on the line.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Unit Cost";
                Visible=FALSE }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den totale pris p� linjen ved at multiplicere kostprisen med antallet.;
                           ENU=Specifies the total cost on the line by multiplying the unit cost by the quantity.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Cost Amount";
                Visible=FALSE }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver komponentens position p� styklisten.;
                           ENU=Specifies the position of the component on the bill of material.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Position;
                Visible=FALSE }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver komponentens position i styklisten. Den kopieres fra produktionsstyklisten, n�r du beregner produktionsordren.;
                           ENU=Specifies the components position in the BOM. It is copied from the production BOM when you calculate the production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Position 2";
                Visible=FALSE }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det tredje referencenummer for komponentens position p� en stykliste, f.eks. det alternative positionsnummer for en komponent p� en printplade.;
                           ENU=Specifies the third reference number for the component position on a bill of material, such as the alternate position number of a component on a print card.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Position 3";
                Visible=FALSE }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver genneml�bstiden for komponentlinjen. Den kopieres fra det tilsvarende felt i produktionsstyklisten, n�r du beregner produktionsordren.;
                           ENU=Specifies the lead-time offset for the component line. It is copied from the corresponding field in the production BOM when you calculate the production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Lead-Time Offset";
                Visible=FALSE }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal af varen, der er plukket til komponentlinjen.;
                           ENU=Specifies the quantity of the item you have picked for the component line.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Qty. Picked";
                Visible=FALSE }

    { 57  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal af varen, der er plukket til komponentlinjen.;
                           ENU=Specifies the quantity of the item you have picked for the component line.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Qty. Picked (Base)";
                Visible=FALSE }

    { 78  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om der findes en erstatningsvare til produktionsordrekomponenten.;
                           ENU=Specifies if an item substitute is available for the production order component.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Substitution Available" }

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
    VAR
      Text000@1000 : TextConst 'DAN=Du kan ikke reservere komponenter med status  %1.;ENU=You cannot reserve components with status %1.';
      ItemAvailFormsMgt@1001 : Codeunit 353;
      ShortcutDimCode@1002 : ARRAY [8] OF Code[20];

    LOCAL PROCEDURE ReserveComp@1();
    VAR
      Item@1000 : Record 27;
    BEGIN
      IF (xRec."Remaining Qty. (Base)" <> "Remaining Qty. (Base)") OR
         (xRec."Item No." <> "Item No.") OR
         (xRec."Location Code" <> "Location Code")
      THEN
        IF Item.GET("Item No.") THEN
          IF Item.Reserve = Item.Reserve::Always THEN BEGIN
            CurrPage.SAVERECORD;
            AutoReserve;
            CurrPage.UPDATE(FALSE);
          END;
    END;

    LOCAL PROCEDURE ItemNoOnAfterValidate@19061248();
    BEGIN
      ReserveComp;
    END;

    LOCAL PROCEDURE Scrap37OnAfterValidate@19025934();
    BEGIN
      ReserveComp;
    END;

    LOCAL PROCEDURE CalculationFormulaOnAfterValid@19008162();
    BEGIN
      ReserveComp;
    END;

    LOCAL PROCEDURE LengthOnAfterValidate@19043825();
    BEGIN
      ReserveComp;
    END;

    LOCAL PROCEDURE WidthOnAfterValidate@19005050();
    BEGIN
      ReserveComp;
    END;

    LOCAL PROCEDURE WeightOnAfterValidate@19006099();
    BEGIN
      ReserveComp;
    END;

    LOCAL PROCEDURE DepthOnAfterValidate@19062485();
    BEGIN
      ReserveComp;
    END;

    LOCAL PROCEDURE QuantityperOnAfterValidate@19039016();
    BEGIN
      ReserveComp;
    END;

    LOCAL PROCEDURE UnitofMeasureCodeOnAfterValida@19057939();
    BEGIN
      ReserveComp;
    END;

    LOCAL PROCEDURE LocationCodeOnAfterValidate@19034787();
    BEGIN
      ReserveComp;
    END;

    BEGIN
    END.
  }
}

