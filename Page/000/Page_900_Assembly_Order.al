OBJECT Page 900 Assembly Order
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Montageordre;
               ENU=Assembly Order];
    SourceTable=Table900;
    SourceTableView=SORTING(Document Type,No.)
                    ORDER(Ascending)
                    WHERE(Document Type=CONST(Order));
    PageType=Document;
    OnOpenPage=BEGIN
                 IsUnitCostEditable := TRUE;
                 IsAsmToOrderEditable := TRUE;

                 UpdateWarningOnLines;
               END;

    OnAfterGetRecord=BEGIN
                       IsUnitCostEditable := NOT IsStandardCostItem;
                       IsAsmToOrderEditable := NOT IsAsmToOrder;
                     END;

    OnDeleteRecord=VAR
                     AssemblyHeaderReserve@1000 : Codeunit 925;
                   BEGIN
                     TESTFIELD("Assemble to Order",FALSE);
                     IF (Quantity <> 0) AND ItemExists("Item No.") THEN BEGIN
                       COMMIT;
                       IF NOT AssemblyHeaderReserve.DeleteLineConfirm(Rec) THEN
                         EXIT(FALSE);
                       AssemblyHeaderReserve.DeleteLine(Rec);
                     END;
                   END;

    ActionList=ACTIONS
    {
      { 18      ;    ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 74      ;1   ;ActionGroup;
                      CaptionML=[DAN=Varedisponering pr.;
                                 ENU=Item Availability by];
                      ActionContainerType=NewDocumentItems;
                      Image=ItemAvailability }
      { 73      ;2   ;Action    ;
                      CaptionML=[DAN=Begivenhed;
                                 ENU=Event];
                      ToolTipML=[DAN=Se, hvordan den faktiske og forventede tilgëngelige saldo for en vare udvikler sig over tid i henhold til udbud og efterspõrgsel.;
                                 ENU=View how the actual and the projected available balance of an item will develop over time according to supply and demand events.];
                      ApplicationArea=#Assembly;
                      Image=Event;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromAsmHeader(Rec,ItemAvailFormsMgt.ByEvent);
                               END;
                                }
      { 72      ;2   ;Action    ;
                      CaptionML=[DAN=Periode;
                                 ENU=Period];
                      ToolTipML=[DAN=Vis det forventede antal af en vare over tid i henhold til tidsperioder som f.eks. dag, uge eller mÜned.;
                                 ENU=View the projected quantity of the item over time according to time periods, such as day, week, or month.];
                      ApplicationArea=#Assembly;
                      Image=Period;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromAsmHeader(Rec,ItemAvailFormsMgt.ByPeriod);
                               END;
                                }
      { 71      ;2   ;Action    ;
                      CaptionML=[DAN=Variant;
                                 ENU=Variant];
                      ToolTipML=[DAN=Vis eller rediger varens varianter. I stedet for at konfigurere hver varefarve som en separat vare kan du konfigurere de forskellige farver som varianter af varen.;
                                 ENU=View or edit the item's variants. Instead of setting up each color of an item as a separate item, you can set up the various colors as variants of the item.];
                      ApplicationArea=#Assembly;
                      Image=ItemVariant;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromAsmHeader(Rec,ItemAvailFormsMgt.ByVariant);
                               END;
                                }
      { 70      ;2   ;Action    ;
                      AccessByPermission=TableData 14=R;
                      CaptionML=[DAN=Lokation;
                                 ENU=Location];
                      ToolTipML=[DAN=Vis det faktiske og det forventede antal af en vare efter lokation.;
                                 ENU=View the actual and projected quantity of the item per location.];
                      ApplicationArea=#Location;
                      Image=Warehouse;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromAsmHeader(Rec,ItemAvailFormsMgt.ByLocation);
                               END;
                                }
      { 66      ;2   ;Action    ;
                      CaptionML=[DAN=Styklisteniveau;
                                 ENU=BOM Level];
                      ToolTipML=[DAN=FÜ vist tilgëngelighedstallene for styklistevarer, der viser, hvor mange enheder af en overordnet vare, du kan fremstille, baseret pÜ tilgëngeligheden af underordnede varer.;
                                 ENU=View availability figures for items on bills of materials that show how many units of a parent item you can make based on the availability of child items.];
                      ApplicationArea=#Assembly;
                      Image=BOMLevel;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromAsmHeader(Rec,ItemAvailFormsMgt.ByBOM);
                               END;
                                }
      { 81      ;1   ;ActionGroup;
                      CaptionML=[DAN=Generelt;
                                 ENU=General];
                      Image=AssemblyBOM }
      { 31      ;2   ;Action    ;
                      CaptionML=[DAN=Montagestykliste;
                                 ENU=Assembly BOM];
                      ToolTipML=[DAN=FÜ vist eller rediger den stykliste, der angiver, hvilke varer og ressourcer der krëves for at samle montageelementet.;
                                 ENU=View or edit the bill of material that specifies which items and resources are required to assemble the assembly item.];
                      ApplicationArea=#Assembly;
                      Promoted=Yes;
                      Image=AssemblyBOM;
                      OnAction=BEGIN
                                 ShowAssemblyList;
                               END;
                                }
      { 15      ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omrÜde, projekt eller afdeling, som du kan tildele til salgs- og kõbsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                               END;
                                }
      { 45      ;2   ;Action    ;
                      Name=Item Tracking Lines;
                      ShortCutKey=Shift+Ctrl+I;
                      CaptionML=[DAN=Vare&sporingslinjer;
                                 ENU=Item &Tracking Lines];
                      ToolTipML=[DAN=Vis eller rediger serienummer og lotnumre, der er tildelt varen pÜ bilags- eller kladdelinjen.;
                                 ENU=View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.];
                      ApplicationArea=#ItemTracking;
                      Image=ItemTrackingLines;
                      OnAction=BEGIN
                                 OpenItemTrackingLines;
                               END;
                                }
      { 32      ;2   ;Action    ;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 907;
                      RunPageLink=Document Type=FIELD(Document Type),
                                  Document No.=FIELD(No.),
                                  Document Line No.=CONST(0);
                      Image=ViewComments }
      { 83      ;1   ;ActionGroup;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      Image=Statistics }
      { 14      ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=FÜ vist statistiske oplysninger om recorden, f.eks. vërdien af bogfõrte poster.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Assembly;
                      RunPageOnRec=Yes;
                      Promoted=Yes;
                      Image=Statistics;
                      OnAction=BEGIN
                                 ShowStatistics;
                               END;
                                }
      { 84      ;1   ;ActionGroup;
                      CaptionML=[DAN=Lagersted;
                                 ENU=Warehouse];
                      Image=Warehouse }
      { 55      ;2   ;Action    ;
                      CaptionML=[DAN=Pluklinjer/bevëgelseslinjer;
                                 ENU=Pick Lines/Movement Lines];
                      ToolTipML=[DAN=Vis de relaterede pluk eller bevëgelser.;
                                 ENU=View the related picks or movements.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 5785;
                      RunPageView=SORTING(Source Type,Source Subtype,Source No.,Source Line No.,Source Subline No.,Unit of Measure Code,Action Type,Breakbulk No.,Original Breakbulk);
                      RunPageLink=Source Type=CONST(901),
                                  Source Subtype=CONST(1),
                                  Source No.=FIELD(No.);
                      Image=PickLines }
      { 56      ;2   ;Action    ;
                      CaptionML=[DAN=&Registrerede pluklinjer;
                                 ENU=Registered P&ick Lines];
                      ToolTipML=[DAN=Vis oversigten over lagerpluk, der er foretaget for ordren.;
                                 ENU=View the list of warehouse picks that have been made for the order.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7364;
                      RunPageView=SORTING(Source Type,Source Subtype,Source No.,Source Line No.,Source Subline No.);
                      RunPageLink=Source Type=CONST(901),
                                  Source Subtype=CONST(1),
                                  Source No.=FIELD(No.);
                      Image=RegisteredDocs }
      { 57      ;2   ;Action    ;
                      CaptionML=[DAN=Reg. linjer for flytning (lager);
                                 ENU=Registered Invt. Movement Lines];
                      ToolTipML=[DAN=Vis oversigten over flytning (lager), der er foretaget for ordren.;
                                 ENU=View the list of inventory movements that have been made for the order.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7387;
                      RunPageView=SORTING(Source Type,Source Subtype,Source No.,Source Line No.,Source Subline No.);
                      RunPageLink=Source Type=CONST(901),
                                  Source Subtype=CONST(1),
                                  Source No.=FIELD(No.);
                      Image=RegisteredDocs }
      { 75      ;2   ;Action    ;
                      CaptionML=[DAN=Ordremont.lagerleverancelinje;
                                 ENU=Asm.-to-Order Whse. Shpt. Line];
                      ToolTipML=[DAN="Vis oversigten over lagerleverancelinjer, der findes til salgsordrer, der er knyttet til denne montageordre som ordremontagelinks. ";
                                 ENU="View the list of warehouse shipment lines that exist for sales orders that are linked to this assembly order as assemble-to-order links. "];
                      ApplicationArea=#Warehouse;
                      Enabled=NOT IsAsmToOrderEditable;
                      Image=ShipmentLines;
                      OnAction=VAR
                                 ATOLink@1002 : Record 904;
                                 WhseShptLine@1003 : Record 7321;
                               BEGIN
                                 TESTFIELD("Assemble to Order",TRUE);
                                 ATOLink.GET("Document Type","No.");
                                 WhseShptLine.SETCURRENTKEY("Source Type","Source Subtype","Source No.","Source Line No.","Assemble to Order");
                                 WhseShptLine.SETRANGE("Source Type",DATABASE::"Sales Line");
                                 WhseShptLine.SETRANGE("Source Subtype",ATOLink."Document Type");
                                 WhseShptLine.SETRANGE("Source No.",ATOLink."Document No.");
                                 WhseShptLine.SETRANGE("Source Line No.",ATOLink."Document Line No.");
                                 WhseShptLine.SETRANGE("Assemble to Order",TRUE);
                                 PAGE.RUNMODAL(PAGE::"Asm.-to-Order Whse. Shpt. Line",WhseShptLine);
                               END;
                                }
      { 82      ;1   ;ActionGroup;
                      CaptionML=[DAN=Oversigt;
                                 ENU=History];
                      Image=History }
      { 40      ;2   ;ActionGroup;
                      CaptionML=[DAN=Poster;
                                 ENU=Entries];
                      ActionContainerType=NewDocumentItems;
                      Image=Entries }
      { 39      ;3   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=Vareposter;
                                 ENU=Item Ledger Entries];
                      ToolTipML=[DAN=Vis vareposterne for varen pÜ bilaget eller kladdelinjen.;
                                 ENU=View the item ledger entries of the item on the document or journal line.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 38;
                      RunPageView=SORTING(Order Type,Order No.);
                      RunPageLink=Order Type=CONST(Assembly),
                                  Order No.=FIELD(No.);
                      Image=ItemLedger }
      { 38      ;3   ;Action    ;
                      CaptionML=[DAN=Kapacitetsposter;
                                 ENU=Capacity Ledger Entries];
                      ToolTipML=[DAN=Vis kapacitetsposterne for den involverede produktionsordre. Kapaciteten registreres enten som tid (operationstid, stoptid eller opstillingstid) eller som antal (spildantal eller afgangsantal).;
                                 ENU=View the capacity ledger entries of the involved production order. Capacity is recorded either as time (run time, stop time, or setup time) or as quantity (scrap quantity or output quantity).];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 5832;
                      RunPageView=SORTING(Order Type,Order No.);
                      RunPageLink=Order Type=CONST(Assembly),
                                  Order No.=FIELD(No.);
                      Image=CapacityLedger }
      { 37      ;3   ;Action    ;
                      CaptionML=[DAN=Ressourceposter;
                                 ENU=Resource Ledger Entries];
                      ToolTipML=[DAN=Vis poster for ressourcen.;
                                 ENU=View the ledger entries for the resource.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 202;
                      RunPageView=SORTING(Order Type,Order No.);
                      RunPageLink=Order Type=CONST(Assembly),
                                  Order No.=FIELD(No.);
                      Image=ResourceLedger }
      { 12      ;3   ;Action    ;
                      CaptionML=[DAN=Vërdiposter;
                                 ENU=Value Entries];
                      ToolTipML=[DAN=Vis vërdiposterne for varen pÜ bilags- eller kladdelinjen.;
                                 ENU=View the value entries of the item on the document or journal line.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5802;
                      RunPageView=SORTING(Order Type,Order No.);
                      RunPageLink=Order Type=CONST(Assembly),
                                  Order No.=FIELD(No.);
                      Image=ValueLedger }
      { 54      ;3   ;Action    ;
                      CaptionML=[DAN=Lagerposter;
                                 ENU=Warehouse Entries];
                      ToolTipML=[DAN=Vis afsluttede lageraktiviteter, der er knyttet til bilaget.;
                                 ENU=View completed warehouse activities related to the document.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7318;
                      RunPageView=SORTING(Source Type,Source Subtype,Source No.);
                      RunPageLink=Source Type=FILTER(83|901),
                                  Source Subtype=FILTER(1|6),
                                  Source No.=FIELD(No.);
                      Image=BinLedger }
      { 62      ;3   ;Action    ;
                      AccessByPermission=TableData 27=R;
                      CaptionML=[DAN=Reservationsposter;
                                 ENU=Reservation Entries];
                      ToolTipML=[DAN=Vis posterne for hver reservation, der er foretaget, enten manuelt eller automatisk.;
                                 ENU=View the entries for every reservation that is made, either manually or automatically.];
                      ApplicationArea=#Advanced;
                      Image=ReservationLedger;
                      OnAction=BEGIN
                                 ShowReservationEntries(TRUE);
                               END;
                                }
      { 76      ;2   ;Action    ;
                      CaptionML=[DAN=Bogfõrte montageordrer;
                                 ENU=Posted Assembly Orders];
                      ToolTipML=[DAN=Vis fuldfõrte montageordrer.;
                                 ENU=View completed assembly orders.];
                      ApplicationArea=#Assembly;
                      RunObject=Page 922;
                      RunPageView=SORTING(Order No.);
                      RunPageLink=Order No.=FIELD(No.);
                      Image=PostedOrder }
      { 52      ;1   ;Separator  }
      { 42      ;0   ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 79      ;1   ;ActionGroup;
                      CaptionML=[DAN=Frigiv;
                                 ENU=Release];
                      Image=ReleaseDoc }
      { 49      ;2   ;Separator  }
      { 59      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F9;
                      CaptionML=[DAN=F&rigiv;
                                 ENU=Re&lease];
                      ToolTipML=[DAN=Frigiv bilaget til nëste behandlingstrin. NÜr et bilag frigives, bliver det inkluderet i alle disponeringsberegninger fra den dato, varerne forventes modtaget. Du skal genÜbne bilaget, fõr du kan foretage ëndringer i det.;
                                 ENU=Release the document to the next stage of processing. When a document is released, it will be included in all availability calculations from the expected receipt date of the items. You must reopen the document before you can make changes to it.];
                      ApplicationArea=#Assembly;
                      Promoted=Yes;
                      Image=ReleaseDoc;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Release Assembly Document",Rec);
                               END;
                                }
      { 60      ;2   ;Action    ;
                      CaptionML=[DAN=&èbn igen;
                                 ENU=Re&open];
                      ToolTipML=[DAN=èbn bilaget igen ved ekstra lageraktivitet.;
                                 ENU=Reopen the document for additional warehouse activity.];
                      ApplicationArea=#Assembly;
                      Promoted=Yes;
                      Image=ReOpen;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 ReleaseAssemblyDoc@1000 : Codeunit 903;
                               BEGIN
                                 ReleaseAssemblyDoc.Reopen(Rec);
                               END;
                                }
      { 17      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      ActionContainerType=ActionItems;
                      Image=Action }
      { 41      ;2   ;Action    ;
                      Name=ShowAvailability;
                      CaptionML=[DAN=Vis disponering;
                                 ENU=Show Availability];
                      ToolTipML=[DAN="Vis, hvor meget af montageordren, der kan monteres efter forfaldsdatoen baseret pÜ tilgëngeligheden af de krëvede komponenter. Dette vises i feltet Mulighed for montage. ";
                                 ENU="View how many of the assembly order quantity can be assembled by the due date based on availability of the required components. This is shown in the Able to Assemble field. "];
                      ApplicationArea=#Assembly;
                      Promoted=Yes;
                      Image=ItemAvailbyLoc;
                      OnAction=BEGIN
                                 ShowAvailability;
                               END;
                                }
      { 19      ;2   ;Action    ;
                      CaptionML=[DAN=Opdater kostpris;
                                 ENU=Update Unit Cost];
                      ToolTipML=[DAN=Opdater kostprisen for den overordnede vare i overensstemmelse med ëndringerne i montagestyklisten.;
                                 ENU=Update the cost of the parent item per changes to the assembly BOM.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=IsUnitCostEditable;
                      Image=UpdateUnitCost;
                      OnAction=BEGIN
                                 UpdateUnitCost;
                               END;
                                }
      { 13      ;2   ;Action    ;
                      CaptionML=[DAN=Opdater linjer;
                                 ENU=Refresh Lines];
                      ToolTipML=[DAN=Opdater oplysningerne pÜ linjerne i overensstemmelse med ëndringerne i hovedet.;
                                 ENU=Update information on the lines according to changes that you made on the header.];
                      ApplicationArea=#Assembly;
                      Image=RefreshLines;
                      OnAction=BEGIN
                                 RefreshBOM;
                                 CurrPage.UPDATE;
                               END;
                                }
      { 61      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Reserver;
                                 ENU=&Reserve];
                      ToolTipML=[DAN=Reserver den nõdvendige mëngde pÜ den bilagslinje, som vinduet blev Übnet for.;
                                 ENU=Reserve the quantity that is required on the document line that you opened this window for.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Reserve;
                      OnAction=BEGIN
                                 ShowReservation;
                               END;
                                }
      { 67      ;2   ;Action    ;
                      CaptionML=[DAN=KopiÇr dokument;
                                 ENU=Copy Document];
                      ToolTipML=[DAN=KopiÇr linjer og sidehovedoplysninger fra et andet salgsbilag til dette bilag. Du kan kopiere en bogfõrt salgsfaktura til en ny salgsfaktura, hvis du hurtigt vil oprette et lignende bilag.;
                                 ENU=Copy document lines and header information from another sales document to this document. You can copy a posted sales invoice into a new sales invoice to quickly create a similar document.];
                      ApplicationArea=#Assembly;
                      Image=CopyDocument;
                      OnAction=VAR
                                 CopyAssemblyDocument@1000 : Report 901;
                               BEGIN
                                 CopyAssemblyDocument.SetAssemblyHeader(Rec);
                                 CopyAssemblyDocument.RUNMODAL;
                                 IF GET("Document Type","No.") THEN;
                               END;
                                }
      { 53      ;2   ;Separator  }
      { 80      ;1   ;ActionGroup;
                      CaptionML=[DAN=Lagersted;
                                 ENU=Warehouse];
                      Image=Warehouse }
      { 51      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Opret flytning (l&ager);
                                 ENU=Create Inventor&y Movement];
                      ToolTipML=[DAN=Opret en flytning (lager) for at hÜndtere varerne i bilaget i henhold til en grundlëggende lageropsëtning.;
                                 ENU=Create an inventory movement to handle items on the document according to a basic warehouse configuration.];
                      ApplicationArea=#Warehouse;
                      Image=CreatePutAway;
                      OnAction=VAR
                                 ATOMovementsCreated@1001 : Integer;
                                 TotalATOMovementsToBeCreated@1002 : Integer;
                               BEGIN
                                 CreateInvtMovement(FALSE,FALSE,FALSE,ATOMovementsCreated,TotalATOMovementsToBeCreated);
                               END;
                                }
      { 50      ;2   ;Action    ;
                      AccessByPermission=TableData 7302=R;
                      CaptionML=[DAN=Opret pluk (logistik);
                                 ENU=Create Whse. Pick];
                      ToolTipML=[DAN=Gõr dig klar til at oprette lagerpluk for linjerne pÜ ordren. NÜr du har valgt indstillinger og kõrer funktionen, oprettes der et lagerplukdokument for montageordrekomponenterne.;
                                 ENU=Prepare to create warehouse picks for the lines on the order. When you have selected options and you run the function, a warehouse pick document are created for the assembly order components.];
                      ApplicationArea=#Warehouse;
                      Image=CreateWarehousePick;
                      OnAction=BEGIN
                                 CreatePick(TRUE,USERID,0,FALSE,FALSE,FALSE);
                               END;
                                }
      { 47      ;2   ;Action    ;
                      CaptionML=[DAN=Ordre&sporing;
                                 ENU=Order &Tracking];
                      ToolTipML=[DAN=Sporer forbindelsen mellem udbud og den dertil hõrende efterspõrgsel. PÜ denne mÜde kan du finde den oprindelige efterspõrgsel, der medfõrte en specifik produktionsordre eller kõbsordre.;
                                 ENU=Tracks the connection of a supply to its corresponding demand. This can help you find the original demand that created a specific production order or purchase order.];
                      ApplicationArea=#Planning;
                      Image=OrderTracking;
                      OnAction=BEGIN
                                 ShowTracking;
                               END;
                                }
      { 35      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Bogfõring;
                                 ENU=P&osting];
                      ActionContainerType=NewDocumentItems;
                      Image=Post }
      { 36      ;2   ;Action    ;
                      ShortCutKey=F9;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Bogfõring;
                                 ENU=P&ost];
                      ToolTipML=[DAN=Fërdiggõr bilaget eller kladden ved at bogfõre belõb og antal pÜ de relaterede konti i regnskaberne.;
                                 ENU=Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.];
                      ApplicationArea=#Assembly;
                      Promoted=Yes;
                      Enabled=IsAsmToOrderEditable;
                      PromotedIsBig=Yes;
                      Image=PostOrder;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Assembly-Post (Yes/No)",Rec);
                               END;
                                }
      { 10      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Massebogfõr;
                                 ENU=Post &Batch];
                      ToolTipML=[DAN=Bogfõr flere bilag pÜ Çn gang. Der Übnes et anmodningsvindue, hvor du kan angive, hvilke bilag der skal bogfõres.;
                                 ENU=Post several documents at once. A report request window opens where you can specify which documents to post.];
                      ApplicationArea=#Assembly;
                      Image=PostBatch;
                      OnAction=BEGIN
                                 REPORT.RUNMODAL(REPORT::"Batch Post Assembly Orders",TRUE,TRUE,Rec);
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 77      ;1   ;ActionGroup;
                      CaptionML=[DAN=Udskriv;
                                 ENU=Print];
                      Image=Print }
      { 78      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Ordre;
                                 ENU=Order];
                      ToolTipML=[DAN=Udskriv montageordren.;
                                 ENU=Print the assembly order.];
                      ApplicationArea=#Assembly;
                      Image=Print;
                      OnAction=VAR
                                 DocPrint@1000 : Codeunit 229;
                               BEGIN
                                 DocPrint.PrintAsmHeader(Rec);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General];
                GroupType=Group }

    { 3   ;2   ;Field     ;
                AssistEdit=Yes;
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Assembly;
                SourceExpr="No.";
                OnAssistEdit=BEGIN
                               IF AssistEdit(xRec) THEN
                                 CurrPage.UPDATE;
                             END;
                              }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den vare, der er ved at blive monteret med montageordren.;
                           ENU=Specifies the number of the item that is being assembled with the assembly order.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Item No.";
                TableRelation=Item.No. WHERE (Assembly BOM=CONST(Yes));
                Importance=Promoted;
                Editable=IsAsmToOrderEditable;
                OnValidate=BEGIN
                             CurrPage.UPDATE;
                           END;
                            }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af montageelementet.;
                           ENU=Specifies the description of the assembly item.];
                ApplicationArea=#Assembly;
                SourceExpr=Description }

    { 33  ;2   ;Group     ;
                GroupType=Group }

    { 6   ;3   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af montageelementet, du forventer at montere med montageordren.;
                           ENU=Specifies how many units of the assembly item that you expect to assemble with the assembly order.];
                ApplicationArea=#Assembly;
                SourceExpr=Quantity;
                Importance=Promoted;
                Editable=IsAsmToOrderEditable;
                OnValidate=BEGIN
                             CurrPage.SAVERECORD;
                           END;
                            }

    { 21  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange montageelementenheder, du vil angive for en delvis bogfõring. Hvis du vil bogfõre den fulde mëngde for montageordren, skal du lade feltet vëre uëndret.;
                           ENU=Specifies how many of the assembly item units you want to partially post. To post the full quantity on the assembly order, leave the field unchanged.];
                ApplicationArea=#Assembly;
                SourceExpr="Quantity to Assemble";
                Importance=Promoted;
                OnValidate=BEGIN
                             CurrPage.SAVERECORD;
                           END;
                            }

    { 30  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen mÜles, f.eks. i enheder eller timer. Som standard indsëttes vërdien i feltet Basisenhed pÜ kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Assembly;
                SourceExpr="Unit of Measure Code";
                Editable=IsAsmToOrderEditable;
                OnValidate=BEGIN
                             CurrPage.SAVERECORD;
                           END;
                            }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor montageordren blev bogfõrt.;
                           ENU=Specifies the date on which the assembly order is posted.];
                ApplicationArea=#Assembly;
                SourceExpr="Posting Date";
                Importance=Promoted }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor montageelementet skal vëre tilgëngeligt.;
                           ENU=Specifies the date when the assembled item is due to be available for use.];
                ApplicationArea=#Assembly;
                SourceExpr="Due Date";
                Importance=Promoted;
                Editable=IsAsmToOrderEditable;
                OnValidate=BEGIN
                             CurrPage.SAVERECORD;
                           END;
                            }

    { 64  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor montageordren forventes at starte.;
                           ENU=Specifies the date when the assembly order is expected to start.];
                ApplicationArea=#Assembly;
                SourceExpr="Starting Date" }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor montageordren forventes at slutte.;
                           ENU=Specifies the date when the assembly order is expected to finish.];
                ApplicationArea=#Assembly;
                SourceExpr="Ending Date" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af montageelementet, der mangler at blive bogfõrt som monteret afgang.;
                           ENU=Specifies how many units of the assembly item remain to be posted as assembled output.];
                ApplicationArea=#Assembly;
                SourceExpr="Remaining Quantity" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af montageelementet, der er bogfõrt som monteret afgang.;
                           ENU=Specifies how many units of the assembly item are posted as assembled output.];
                ApplicationArea=#Assembly;
                SourceExpr="Assembled Quantity" }

    { 63  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af montageelementet der er reserveret til dette montageordrehoved.;
                           ENU=Specifies how many units of the assembly item are reserved for this assembly order header.];
                ApplicationArea=#Assembly;
                SourceExpr="Reserved Quantity";
                Visible=FALSE;
                Editable=FALSE }

    { 65  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om montageordren er knyttet til en salgsordre, som angiver, at elementet er monteret under en ordre.;
                           ENU=Specifies if the assembly order is linked to a sales order, which indicates that the item is assembled to order.];
                ApplicationArea=#Assembly;
                SourceExpr="Assemble to Order";
                OnDrillDown=BEGIN
                              ShowAsmToOrder;
                            END;
                             }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om bilaget er Übent, afventer godkendelse, er faktureret til forudbetaling eller er frigivet til nëste fase i behandlingen.;
                           ENU=Specifies if the document is open, waiting to be approved, invoiced for prepayment, or released to the next stage of processing.];
                ApplicationArea=#Assembly;
                SourceExpr=Status }

    { 34  ;1   ;Part      ;
                Name=Lines;
                CaptionML=[DAN=Linjer;
                           ENU=Lines];
                ApplicationArea=#Assembly;
                SubPageLink=Document Type=FIELD(Document Type),
                            Document No.=FIELD(No.);
                PagePartID=Page901;
                PartType=Page }

    { 23  ;1   ;Group     ;
                CaptionML=[DAN=Bogfõring;
                           ENU=Posting];
                GroupType=Group }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant pÜ linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Importance=Promoted;
                Editable=IsAsmToOrderEditable;
                OnValidate=BEGIN
                             CurrPage.SAVERECORD;
                           END;
                            }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den lokation, som du vil bogfõre afgangen af montageelementet for.;
                           ENU=Specifies the location to which you want to post output of the assembly item.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Importance=Promoted;
                Editable=IsAsmToOrderEditable;
                OnValidate=BEGIN
                             CurrPage.SAVERECORD;
                           END;
                            }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, som montageelementet er bogfõrt for, som afgang, Her hentes det til lager eller afsendes, hvis det monteres under en salgsordre.;
                           ENU=Specifies the bin the assembly item is posted to as output and from where it is taken to storage or shipped if it is assembled to a sales order.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code";
                Editable=IsAsmToOrderEditable;
                OnValidate=BEGIN
                             CurrPage.SAVERECORD;
                           END;
                            }

    { 68  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver procentdelen af varens sidste kõbspris, der omfatter indirekte omkostninger, sÜsom fragt, der er knyttet til kõbet af varen.;
                           ENU=Specifies the percentage of the item's last purchase cost that includes indirect costs, such as freight that is associated with the purchase of the item.];
                ApplicationArea=#Assembly;
                SourceExpr="Indirect Cost %";
                Visible=FALSE }

    { 69  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den indirekte omkostning for montageelementet som et absolut belõb.;
                           ENU=Specifies the indirect cost of the assembly item as an absolute amount.];
                ApplicationArea=#Assembly;
                SourceExpr="Overhead Rate";
                Visible=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, pÜ Çn enhed af varen eller ressourcen pÜ linjen.;
                           ENU=Specifies the cost of one unit of the item or resource on the line.];
                ApplicationArea=#Assembly;
                SourceExpr="Unit Cost";
                Editable=IsUnitCostEditable }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den totale kostpris for montageordren.;
                           ENU=Specifies the total unit cost of the assembly order.];
                ApplicationArea=#Assembly;
                SourceExpr="Cost Amount" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der er ansvarlig for bilaget.;
                           ENU=Specifies the ID of the user who is responsible for the document.];
                ApplicationArea=#Assembly;
                SourceExpr="Assigned User ID";
                Visible=False }

    { 7   ;0   ;Container ;
                ContainerType=FactBoxArea }

    { 11  ;1   ;Part      ;
                ApplicationArea=#Assembly;
                SubPageLink=No.=FIELD(Item No.);
                PagePartID=Page910;
                PartType=Page }

    { 44  ;1   ;Part      ;
                ApplicationArea=#Assembly;
                SubPageLink=Document Type=FIELD(Document Type),
                            Document No.=FIELD(Document No.),
                            Line No.=FIELD(Line No.);
                PagePartID=Page917;
                ProviderID=34;
                PartType=Page }

    { 43  ;1   ;Part      ;
                ApplicationArea=#Assembly;
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page912;
                ProviderID=34;
                PartType=Page }

    { 8   ;1   ;Part      ;
                PartType=System;
                SystemPartID=RecordLinks }

    { 9   ;1   ;Part      ;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      ItemAvailFormsMgt@1002 : Codeunit 353;
      IsUnitCostEditable@1000 : Boolean INDATASET;
      IsAsmToOrderEditable@1001 : Boolean INDATASET;

    BEGIN
    END.
  }
}

