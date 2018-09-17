OBJECT Page 5741 Transfer Order Subform
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
    LinksAllowed=No;
    SourceTable=Table5741;
    DelayedInsert=Yes;
    PageType=ListPart;
    AutoSplitKey=Yes;
    OnAfterGetRecord=BEGIN
                       ShowShortcutDimCode(ShortcutDimCode);
                     END;

    OnNewRecord=BEGIN
                  CLEAR(ShortcutDimCode);
                END;

    OnDeleteRecord=VAR
                     ReserveTransferLine@1000 : Codeunit 99000836;
                   BEGIN
                     COMMIT;
                     IF NOT ReserveTransferLine.DeleteLineConfirm(Rec) THEN
                       EXIT(FALSE);
                     ReserveTransferLine.DeleteLine(Rec);
                   END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1906587504;1 ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 1900295304;2 ;Action    ;
                      Name=Reserve;
                      CaptionML=[DAN=&Reserver;
                                 ENU=&Reserve];
                      ToolTipML=[DAN=Reserver den n�dvendige m�ngde p� den bilagslinje, som vinduet blev �bnet for.;
                                 ENU=Reserve the quantity that is required on the document line that you opened this window for.];
                      ApplicationArea=#Advanced;
                      Image=Reserve;
                      OnAction=BEGIN
                                 FIND;
                                 ShowReservation;
                               END;
                                }
      { 1907935204;1 ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 1901742204;2 ;ActionGroup;
                      CaptionML=[DAN=Varedisponering pr.;
                                 ENU=Item Availability by];
                      Image=ItemAvailability }
      { 3       ;3   ;Action    ;
                      CaptionML=[DAN=Begivenhed;
                                 ENU=Event];
                      ToolTipML=[DAN=Se, hvordan den faktiske og forventede tilg�ngelige saldo for en vare udvikles over tid i henhold til udbud og eftersp�rgsel.;
                                 ENU=View how the actual and the projected available balance of an item will develop over time according to supply and demand events.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Event;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromTransLine(Rec,ItemAvailFormsMgt.ByEvent);
                               END;
                                }
      { 1903866904;3 ;Action    ;
                      CaptionML=[DAN=Periode;
                                 ENU=Period];
                      ToolTipML=[DAN=Viser det forventede antal af en vare over tid i henhold til tidsperioder, f.eks. dag, uge eller m�ned.;
                                 ENU=Show the projected quantity of the item over time according to time periods, such as day, week, or month.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Period;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromTransLine(Rec,ItemAvailFormsMgt.ByPeriod);
                               END;
                                }
      { 1901313304;3 ;Action    ;
                      CaptionML=[DAN=Variant;
                                 ENU=Variant];
                      ToolTipML=[DAN=Vis eller rediger varens varianter. I stedet for at konfigurere hver varefarve som en separat vare kan du konfigurere de forskellige farver som varianter af varen.;
                                 ENU=View or edit the item's variants. Instead of setting up each color of an item as a separate item, you can set up the various colors as variants of the item.];
                      ApplicationArea=#Advanced;
                      Image=ItemVariant;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromTransLine(Rec,ItemAvailFormsMgt.ByVariant);
                               END;
                                }
      { 1901991604;3 ;Action    ;
                      AccessByPermission=TableData 14=R;
                      CaptionML=[DAN=Lokation;
                                 ENU=Location];
                      ToolTipML=[DAN=Vis det faktiske og det forventede antal af en vare efter lokation.;
                                 ENU=View the actual and projected quantity of the item per location.];
                      ApplicationArea=#Location;
                      Image=Warehouse;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromTransLine(Rec,ItemAvailFormsMgt.ByLocation);
                               END;
                                }
      { 5       ;3   ;Action    ;
                      CaptionML=[DAN=Styklisteniveau;
                                 ENU=BOM Level];
                      ToolTipML=[DAN=F� vist tilg�ngelighedstallene for styklistevarer, der viser, hvor mange enheder af en overordnet vare, du kan fremstille, baseret p� tilg�ngeligheden af underordnede varer.;
                                 ENU=View availability figures for items on bills of materials that show how many units of a parent item you can make based on the availability of child items.];
                      ApplicationArea=#Advanced;
                      Image=BOMLevel;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromTransLine(Rec,ItemAvailFormsMgt.ByBOM);
                               END;
                                }
      { 1901652204;2 ;Action    ;
                      Name=Dimensions;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr�de, projekt eller afdeling, som du kan tildele til salgs- og k�bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                               END;
                                }
      { 1900295404;2 ;ActionGroup;
                      CaptionML=[DAN=Vare&sporingslinjer;
                                 ENU=Item &Tracking Lines];
                      Image=AllLines }
      { 1901992804;3 ;Action    ;
                      CaptionML=[DAN=Leverance;
                                 ENU=Shipment];
                      ToolTipML=[DAN=Vis eller rediger serienummer og lotnumre, der er tildelt varen p� bilags- eller kladdelinjen.;
                                 ENU=View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.];
                      ApplicationArea=#ItemTracking;
                      Image=Shipment;
                      OnAction=BEGIN
                                 OpenItemTrackingLines(0);
                               END;
                                }
      { 1900296804;3 ;Action    ;
                      CaptionML=[DAN=Modtagelse;
                                 ENU=Receipt];
                      ToolTipML=[DAN=Vis eller rediger serienummer og lotnumre, der er tildelt varen p� bilags- eller kladdelinjen.;
                                 ENU=View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.];
                      ApplicationArea=#ItemTracking;
                      Image=Receipt;
                      OnAction=BEGIN
                                 OpenItemTrackingLines(1);
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
                ToolTipML=[DAN=Angiver nummeret p� den vare, der skal overflyttes.;
                           ENU=Specifies the number of the item that will be transferred.];
                ApplicationArea=#Location;
                SourceExpr="Item No." }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p� linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om der tages h�jde for den forsyning, der repr�senteres af linjen i planl�gningssystemet, n�r der beregnes aktionsmeddelelser.;
                           ENU=Specifies whether the supply represented by this line is considered by the planning system when calculating action messages.];
                ApplicationArea=#Advanced;
                SourceExpr="Planning Flexibility";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af posten.;
                           ENU=Specifies a description of the entry.];
                ApplicationArea=#Location;
                SourceExpr=Description }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den placering, som varerne overflyttes fra.;
                           ENU=Specifies the code for the bin that the items are transferred from.];
                ApplicationArea=#Warehouse;
                SourceExpr="Transfer-from Bin Code";
                Visible=FALSE }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den placering, som varerne overflyttes til.;
                           ENU=Specifies the code for the bin that the items are transferred to.];
                ApplicationArea=#Warehouse;
                SourceExpr="Transfer-To Bin Code";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal af varen, der bliver ekspederet if�lge angivelserne p� bilaget.;
                           ENU=Specifies the quantity of the item that will be processed as the document stipulates.];
                ApplicationArea=#Location;
                BlankZero=Yes;
                SourceExpr=Quantity }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal af varen, der er reserveret p� den lokation, der overflyttes til.;
                           ENU=Specifies the quantity of the item reserved at the transfer-to location.];
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr="Reserved Quantity Inbnd." }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder i den leverede overflytningsordre, der er reserveret.;
                           ENU=Specifies how many units on the shipped transfer order are reserved.];
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr="Reserved Quantity Shipped" }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal af varen, der er reserveret p� den lokation, der overflyttes fra.;
                           ENU=Specifies the quantity of the item reserved at the transfer-from location.];
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr="Reserved Quantity Outbnd." }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m�les, f.eks. i enheder eller timer. Som standard inds�ttes v�rdien i feltet Basisenhed p� kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Location;
                SourceExpr="Unit of Measure Code" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� varens eller ressourcens enhed, f.eks. styk eller time.;
                           ENU=Specifies the name of the item or resource's unit of measure, such as piece or hour.];
                ApplicationArea=#Location;
                SourceExpr="Unit of Measure";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal varer, der mangler at blive afsendt.;
                           ENU=Specifies the quantity of items that remain to be shipped.];
                ApplicationArea=#Location;
                BlankZero=Yes;
                SourceExpr="Qty. to Ship" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af den p�g�ldende vare der allerede er blevet bogf�rt som leveret.;
                           ENU=Specifies how many units of the item on the line have been posted as shipped.];
                ApplicationArea=#Location;
                BlankZero=Yes;
                SourceExpr="Quantity Shipped";
                OnDrillDown=VAR
                              TransShptLine@1001 : Record 5745;
                            BEGIN
                              TESTFIELD("Document No.");
                              TESTFIELD("Item No.");
                              TransShptLine.SETCURRENTKEY("Transfer Order No.","Item No.","Shipment Date");
                              TransShptLine.SETRANGE("Transfer Order No.","Document No.");
                              TransShptLine.SETRANGE("Item No.","Item No.");
                              PAGE.RUNMODAL(0,TransShptLine);
                            END;
                             }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal varer, der endnu ikke er modtaget.;
                           ENU=Specifies the quantity of items that remains to be received.];
                ApplicationArea=#Location;
                BlankZero=Yes;
                SourceExpr="Qty. to Receive";
                Editable=NOT "Direct Transfer" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af den p�g�ldende vare der allerede er blevet bogf�rt som modtaget.;
                           ENU=Specifies how many units of the item on the line have been posted as received.];
                ApplicationArea=#Location;
                BlankZero=Yes;
                SourceExpr="Quantity Received";
                OnDrillDown=VAR
                              TransRcptLine@1001 : Record 5747;
                            BEGIN
                              TESTFIELD("Document No.");
                              TESTFIELD("Item No.");
                              TransRcptLine.SETCURRENTKEY("Transfer Order No.","Item No.","Receipt Date");
                              TransRcptLine.SETRANGE("Transfer Order No.","Document No.");
                              TransRcptLine.SETRANGE("Item No.","Item No.");
                              PAGE.RUNMODAL(0,TransRcptLine);
                            END;
                             }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn�r varerne p� bilaget er sendt eller leveret. En afsendelsesdato beregnes normalt ud fra en �nsket leveringsdato plus leveringstiden.;
                           ENU=Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.];
                ApplicationArea=#Location;
                SourceExpr="Shipment Date" }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den forventede dato for modtagelsen af leverancen til den lokation, der overflyttes til.;
                           ENU=Specifies the date that you expect the transfer-to location to receive the shipment.];
                ApplicationArea=#Location;
                SourceExpr="Receipt Date" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den spedit�r, som transporterer varerne.;
                           ENU=Specifies the code for the shipping agent who is transporting the items.];
                ApplicationArea=#Location;
                SourceExpr="Shipping Agent Code";
                Visible=FALSE }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for servicen, f.eks. levering samme dag, som tilbydes af spedit�ren.;
                           ENU=Specifies the code for the service, such as a one-day delivery, that is offered by the shipping agent.];
                ApplicationArea=#Location;
                SourceExpr="Shipping Agent Service Code";
                Visible=FALSE }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor lang tid der g�r, fra varerne er sendt fra lageret, til de er leveret.;
                           ENU=Specifies how long it takes from when the items are shipped from the warehouse to when they are delivered.];
                ApplicationArea=#Location;
                SourceExpr="Shipping Time";
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN="Angiver en datoformel for den tid, det tager at g�re varerne klar til forsendelse fra denne lokation. Tidselementet anvendes ved beregning af leveringsdatoen p� f�lgende m�de: Afsendelsesdato + Udg�ende lagerekspeditionstid = Planlagt afsendelsesdato + Transporttid = Planlagt leveringsdato.";
                           ENU="Specifies a date formula for the time it takes to get items ready to ship from this location. The time element is used in the calculation of the delivery date as follows: Shipment Date + Outbound Warehouse Handling Time = Planned Shipment Date + Shipping Time = Planned Delivery Date."];
                ApplicationArea=#Warehouse;
                SourceExpr="Outbound Whse. Handling Time";
                Visible=FALSE }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den tid, det tager at g�re varer tilg�ngelige fra lageret, efter varerne er bogf�rt som modtaget.;
                           ENU=Specifies the time it takes to make items part of available inventory, after the items have been posted as received.];
                ApplicationArea=#Warehouse;
                SourceExpr="Inbound Whse. Handling Time";
                Visible=FALSE }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den varepost, som dette dokument eller denne kladdelinje udlignes p�.;
                           ENU=Specifies the number of the item ledger entry that the document or journal line is applied to.];
                ApplicationArea=#Advanced;
                SourceExpr="Appl.-to Item Entry";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops�tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Location;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops�tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Location;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 300 ;2   ;Field     ;
                ApplicationArea=#Location;
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
                ApplicationArea=#Location;
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
                ApplicationArea=#Location;
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
                ApplicationArea=#Location;
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
                ApplicationArea=#Location;
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
                ApplicationArea=#Location;
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

  }
  CODE
  {
    VAR
      ItemAvailFormsMgt@1001 : Codeunit 353;
      ShortcutDimCode@1000 : ARRAY [8] OF Code[20];

    [External]
    PROCEDURE UpdateForm@2(SetSaveRecord@1000 : Boolean);
    BEGIN
      CurrPage.UPDATE(SetSaveRecord);
    END;

    BEGIN
    END.
  }
}

