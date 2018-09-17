OBJECT Page 291 Req. Worksheet
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Indk›bskladde;
               ENU=Req. Worksheet];
    SaveValues=Yes;
    LinksAllowed=No;
    SourceTable=Table246;
    DelayedInsert=Yes;
    DataCaptionFields=Journal Batch Name;
    PageType=Worksheet;
    AutoSplitKey=Yes;
    OnOpenPage=VAR
                 JnlSelected@1000 : Boolean;
               BEGIN
                 OpenedFromBatch := ("Journal Batch Name" <> '') AND ("Worksheet Template Name" = '');
                 IF OpenedFromBatch THEN BEGIN
                   CurrentJnlBatchName := "Journal Batch Name";
                   ReqJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
                   EXIT;
                 END;
                 ReqJnlManagement.TemplateSelection(PAGE::"Req. Worksheet",FALSE,0,Rec,JnlSelected);
                 IF NOT JnlSelected THEN
                   ERROR('');
                 ReqJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
               END;

    OnAfterGetRecord=BEGIN
                       ShowShortcutDimCode(ShortcutDimCode);
                     END;

    OnNewRecord=BEGIN
                  ReqJnlManagement.SetUpNewLine(Rec,xRec);
                  CLEAR(ShortcutDimCode);
                END;

    OnDeleteRecord=BEGIN
                     "Accept Action Message" := FALSE;
                   END;

    OnAfterGetCurrRecord=BEGIN
                           ReqJnlManagement.GetDescriptionAndRcptName(Rec,Description2,BuyFromVendorName);
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 29      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 30      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Se eller rediger detaljerede oplysninger om varen eller ressourcen.;
                                 ENU=View or change detailed information about the item or resource.];
                      ApplicationArea=#Planning;
                      RunObject=Codeunit 335;
                      Promoted=No;
                      PromotedIsBig=No;
                      Image=EditLines }
      { 76      ;2   ;ActionGroup;
                      CaptionML=[DAN=Varedisponering pr.;
                                 ENU=Item Availability by];
                      Image=ItemAvailability }
      { 3       ;3   ;Action    ;
                      CaptionML=[DAN=Begivenhed;
                                 ENU=Event];
                      ToolTipML=[DAN=Se, hvordan den faktiske og forventede tilg‘ngelige saldo for en vare udvikles over tid i henhold til udbud og eftersp›rgsel.;
                                 ENU=View how the actual and the projected available balance of an item will develop over time according to supply and demand events.];
                      ApplicationArea=#Planning;
                      Image=Event;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromReqLine(Rec,ItemAvailFormsMgt.ByEvent)
                               END;
                                }
      { 77      ;3   ;Action    ;
                      CaptionML=[DAN=Periode;
                                 ENU=Period];
                      ToolTipML=[DAN=Viser det forventede antal af en vare over tid i henhold til tidsperioder, f.eks. dag, uge eller m†ned.;
                                 ENU=Show the projected quantity of the item over time according to time periods, such as day, week, or month.];
                      ApplicationArea=#Planning;
                      Image=Period;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromReqLine(Rec,ItemAvailFormsMgt.ByPeriod)
                               END;
                                }
      { 78      ;3   ;Action    ;
                      CaptionML=[DAN=Variant;
                                 ENU=Variant];
                      ToolTipML=[DAN=Vis eller rediger varens varianter. I stedet for at oprette hver varefarve som en separat vare kan du n›jes med ‚n vare i forskellige farvevarianter.;
                                 ENU=View or edit the item's variants. Instead of setting up each color of an item as a separate item, you can set up the various colors as variants of the item.];
                      ApplicationArea=#Advanced;
                      Image=ItemVariant;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromReqLine(Rec,ItemAvailFormsMgt.ByVariant)
                               END;
                                }
      { 61      ;3   ;Action    ;
                      AccessByPermission=TableData 14=R;
                      CaptionML=[DAN=Lokation;
                                 ENU=Location];
                      ToolTipML=[DAN=Vis det faktiske og det forventede antal af en vare efter lokation.;
                                 ENU=View the actual and projected quantity of the item per location.];
                      ApplicationArea=#Location;
                      Image=Warehouse;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromReqLine(Rec,ItemAvailFormsMgt.ByLocation)
                               END;
                                }
      { 7       ;3   ;Action    ;
                      CaptionML=[DAN=Styklisteniveau;
                                 ENU=BOM Level];
                      ToolTipML=[DAN=F† vist tilg‘ngelighedstallene for styklistevarer, der viser, hvor mange enheder af en overordnet vare, du kan fremstille, baseret p† tilg‘ngeligheden af underordnede varer.;
                                 ENU=View availability figures for items on bills of materials that show how many units of a parent item you can make based on the availability of child items.];
                      ApplicationArea=#Assembly;
                      Image=BOMLevel;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromReqLine(Rec,ItemAvailFormsMgt.ByBOM)
                               END;
                                }
      { 5       ;3   ;Action    ;
                      CaptionML=[DAN=Tidslinje;
                                 ENU=Timeline];
                      ToolTipML=[DAN=F† en grafisk visning af en vares planlagte lager baseret p† fremtidige udbuds- og eftersp›rgselsh‘ndelser med eller uden planl‘gningsforslag. Resultatet er en grafisk gengivelse af lagerprofilen.;
                                 ENU=Get a graphical view of an item's projected inventory based on future supply and demand events, with or without planning suggestions. The result is a graphical representation of the inventory profile.];
                      ApplicationArea=#Planning;
                      Image=Timeline;
                      OnAction=BEGIN
                                 ShowTimeline(Rec);
                               END;
                                }
      { 83      ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Dimensions;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 ShowDimensions;
                                 CurrPage.SAVERECORD;
                               END;
                                }
      { 6500    ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+I;
                      CaptionML=[DAN=Vare&sporingslinjer;
                                 ENU=Item &Tracking Lines];
                      ToolTipML=[DAN=Vis eller rediger serienummer og lotnumre, der er tildelt varen p† bilags- eller kladdelinjen.;
                                 ENU=View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.];
                      ApplicationArea=#ItemTracking;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ItemTrackingLines;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 OpenItemTrackingLines;
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 31      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 32      ;2   ;Action    ;
                      Name=CalculatePlan;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Beregn plan;
                                 ENU=Calculate Plan];
                      ToolTipML=[DAN=Brug en k›rsel som hj‘lp til at beregne en forsyningsplan for varer og lagervarer, for hvilke feltet Genbestillingssystem er indstillet til K›b eller Overf›rsel.;
                                 ENU=Use a batch job to help you calculate a supply plan for items and stockkeeping units that have the Replenishment System field set to Purchase or Transfer.];
                      ApplicationArea=#Planning;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=CalculatePlan;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CalculatePlan.SetTemplAndWorksheet("Worksheet Template Name","Journal Batch Name");
                                 CalculatePlan.RUNMODAL;
                                 CLEAR(CalculatePlan);
                               END;
                                }
      { 33      ;2   ;ActionGroup;
                      CaptionML=[DAN=Direkte levering;
                                 ENU=Drop Shipment];
                      Image=Delivery }
      { 34      ;3   ;Action    ;
                      AccessByPermission=TableData 223=R;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Hent salgsordrer;
                                 ENU=Get &Sales Orders];
                      ToolTipML=[DAN=Kopi‚r salgslinjer til indk›bskladden. Du kan bruge k›rslen til at oprette forslagslinjer til indk›bskladder ud fra salgslinjer til direkte leveringer eller specialordrer.;
                                 ENU=Copy sales lines to the requisition worksheet. You can use the batch job to create requisition worksheet proposal lines from sales lines for drop shipments or special orders.];
                      ApplicationArea=#Planning;
                      Image=Order;
                      OnAction=BEGIN
                                 GetSalesOrder.SetReqWkshLine(Rec,0);
                                 GetSalesOrder.RUNMODAL;
                                 CLEAR(GetSalesOrder);
                               END;
                                }
      { 35      ;3   ;Action    ;
                      AccessByPermission=TableData 110=R;
                      CaptionML=[DAN=&Salgsordre;
                                 ENU=Sales &Order];
                      ToolTipML=[DAN=Opret en ny salgsordre for en vare, der leveres direkte fra kreditoren til debitoren. Afkrydsningsfeltet Direkte levering skal v‘re markeret p† salgsordrelinjen, og feltet Kreditornr. skal v‘re udfyldt p† varekortet.;
                                 ENU=Create a new sales order for an item that is shipped directly from the vendor to the customer. The Drop Shipment check box must be selected on the sales order line, and the Vendor No. field must be filled on the item card.];
                      ApplicationArea=#Planning;
                      Image=Document;
                      OnAction=BEGIN
                                 SalesHeader.SETRANGE("No.","Sales Order No.");
                                 SalesOrder.SETTABLEVIEW(SalesHeader);
                                 SalesOrder.EDITABLE := FALSE;
                                 SalesOrder.RUN;
                               END;
                                }
      { 52      ;2   ;ActionGroup;
                      CaptionML=[DAN=Specialordre;
                                 ENU=Special Order];
                      Image=SpecialOrder }
      { 53      ;3   ;Action    ;
                      AccessByPermission=TableData 223=R;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Hent salgsordrer;
                                 ENU=Get &Sales Orders];
                      ToolTipML=[DAN=Kopi‚r salgslinjer til indk›bskladden. Du kan bruge k›rslen til at oprette forslagslinjer til indk›bskladder ud fra salgslinjer til direkte leveringer eller specialordrer.;
                                 ENU=Copy sales lines to the requisition worksheet. You can use the batch job to create requisition worksheet proposal lines from sales lines for drop shipments or special orders.];
                      ApplicationArea=#Planning;
                      Image=Order;
                      OnAction=BEGIN
                                 GetSalesOrder.SetReqWkshLine(Rec,1);
                                 GetSalesOrder.RUNMODAL;
                                 CLEAR(GetSalesOrder);
                               END;
                                }
      { 75      ;3   ;Action    ;
                      AccessByPermission=TableData 110=R;
                      CaptionML=[DAN=&Salgsordre;
                                 ENU=Sales &Order];
                      ToolTipML=[DAN=Opret en ny salgsordre for en vare, der leveres direkte fra kreditoren til debitoren. Afkrydsningsfeltet Direkte levering skal v‘re markeret p† salgsordrelinjen, og feltet Kreditornr. skal v‘re udfyldt p† varekortet.;
                                 ENU=Create a new sales order for an item that is shipped directly from the vendor to the customer. The Drop Shipment check box must be selected on the sales order line, and the Vendor No. field must be filled on the item card.];
                      ApplicationArea=#Planning;
                      Image=Document;
                      OnAction=BEGIN
                                 SalesHeader.SETRANGE("No.","Sales Order No.");
                                 SalesOrder.SETTABLEVIEW(SalesHeader);
                                 SalesOrder.EDITABLE := FALSE;
                                 SalesOrder.RUN;
                               END;
                                }
      { 81      ;2   ;Separator  }
      { 90      ;2   ;Action    ;
                      Name=Reserve;
                      CaptionML=[DAN=&Reserver;
                                 ENU=&Reserve];
                      ToolTipML=[DAN=Reserv‚r en eller flere enheder af varen p† sagsplanl‘gningslinjen, enten fra lageret eller den indg†ende forsyning.;
                                 ENU=Reserve one or more units of the item on the job planning line, either from inventory or from incoming supply.];
                      ApplicationArea=#Planning;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Reserve;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CurrPage.SAVERECORD;
                                 ShowReservation;
                               END;
                                }
      { 37      ;2   ;Action    ;
                      Name=CarryOutActionMessage;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Udf›r aktionsmeddelelse;
                                 ENU=Carry &Out Action Message];
                      ToolTipML=[DAN=Brug en k›rsel som hj‘lp til at oprette faktiske forsyningsordrer ud fra ordreforslagene.;
                                 ENU=Use a batch job to help you create actual supply orders from the order proposals.];
                      ApplicationArea=#Planning;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=CarryOutActionMessage;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 PerformAction@1001 : Report 493;
                               BEGIN
                                 PerformAction.SetReqWkshLine(Rec);
                                 PerformAction.RUNMODAL;
                                 PerformAction.GetReqWkshLine(Rec);
                                 CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 9       ;1   ;ActionGroup;
                      CaptionML=[DAN=Ordresporing;
                                 ENU=Order Tracking];
                      Image=OrderTracking }
      { 80      ;2   ;Action    ;
                      CaptionML=[DAN=&Ordresporing;
                                 ENU=Order &Tracking];
                      ToolTipML=[DAN=Sporer forbindelsen mellem udbud og den tilsvarende eftersp›rgsel. P† denne m†de kan du finde den oprindelige eftersp›rgsel, der oprettede en specifik produktionsordre eller k›bsordre.;
                                 ENU=Tracks the connection of a supply to its corresponding demand. This can help you find the original demand that created a specific production order or purchase order.];
                      ApplicationArea=#Planning;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=OrderTracking;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 TrackingForm@1001 : Page 99000822;
                               BEGIN
                                 TrackingForm.SetReqLine(Rec);
                                 TrackingForm.RUNMODAL;
                               END;
                                }
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 1901091106;1 ;Action    ;
                      CaptionML=[DAN=Varedisponering;
                                 ENU=Inventory Availability];
                      ToolTipML=[DAN=Vis, udskriv eller gem en historikoversigt over lagertransaktioner pr. valgte varer, f.eks. for at beslutte, hvorn†r varerne skal indk›bes. Rapporten specificerer antallet af salgsordrer, k›bsordrer, restordrer fra kreditorer, minimumslageret og eventuelle genbestillinger.;
                                 ENU=View, print, or save a summary of historical inventory transactions with selected items, for example, to decide when to purchase the items. The report specifies quantity on sales order, quantity on purchase order, back orders from vendors, minimum inventory, and whether there are reorders.];
                      ApplicationArea=#Planning;
                      RunObject=Report 705;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1901254106;1 ;Action    ;
                      CaptionML=[DAN=Status;
                                 ENU=Status];
                      ToolTipML=[DAN=Vis status for kladden.;
                                 ENU=View the status of the worksheet.];
                      ApplicationArea=#Planning;
                      RunObject=Report 706;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1906212206;1 ;Action    ;
                      CaptionML=[DAN=Vare - disponeringsoversigt;
                                 ENU=Inventory - Availability Plan];
                      ToolTipML=[DAN=Vis en liste over antallet af de enkelte varer fordelt p† henholdsvis debitor-, k›bs- og overflytningsordrer, samt det antal der er disponibelt p† lageret. Oversigten er inddelt i kolonner, der d‘kker seks perioder med angivne start- og slutdatoer, samt perioderne f›r og efter de p†g‘ldende seks perioder. Listen er praktisk ved planl‘gning af vareindk›b.;
                                 ENU=View a list of the quantity of each item in customer, purchase, and transfer orders and the quantity available in inventory. The list is divided into columns that cover six periods with starting and ending dates as well as the periods before and after those periods. The list is useful when you are planning your inventory purchases.];
                      ApplicationArea=#Planning;
                      RunObject=Report 707;
                      Promoted=Yes;
                      Image=ItemAvailability;
                      PromotedCategory=Report }
      { 1903262806;1 ;Action    ;
                      CaptionML=[DAN=Varer i salgsordrer;
                                 ENU=Inventory Order Details];
                      ToolTipML=[DAN=Vis en liste over, hvilke ordrer der endnu ikke er leveret eller modtaget, og hvilke varer der indg†r i ordren. Den viser ordrenummer, debitors navn, afsendelsesdato, ordrest›rrelse, antal i restordre, udest†ende antal, enhedspris, rabatprocent og bel›b. Restordreantal, udest†ende antal og bel›b l‘gges sammen for hver vare. Listen kan bruges til at vise, om der er aktuelle eller kommende leveringsproblemer.;
                                 ENU=View a list of the orders that have not yet been shipped or received and the items in the orders. It shows the order number, customer's name, shipment date, order quantity, quantity on back order, outstanding quantity and unit price, as well as possible discount percentage and amount. The quantity on back order and outstanding quantity and amount are totaled for each item. The list can be used to find out whether there are currently shipment problems or any can be expected.];
                      ApplicationArea=#Planning;
                      RunObject=Report 708;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report }
      { 1904739806;1 ;Action    ;
                      CaptionML=[DAN=Varer i k›bsordrer;
                                 ENU=Inventory Purchase Orders];
                      ToolTipML=[DAN=Vis en oversigt over varer, der er bestilt hos kreditorer. Den indeholder ogs† oplysninger om forventet modtagelsesdato og restordrer i antal og bel›b. Rapporten kan f.eks. bruges til at give et overblik over det forventede leveringstidspunkt for varerne, og om der skal rykkes for restordrer.;
                                 ENU=View a list of items on order from vendors. It also shows the expected receipt date and the quantity and amount on back orders. The report can be used, for example, to see when items should be received and whether a reminder of a back order should be issued.];
                      ApplicationArea=#Planning;
                      RunObject=Report 709;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 25  ;1   ;Field     ;
                Lookup=Yes;
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver navnet p† recorden.;
                           ENU=Specifies the name of the record.];
                ApplicationArea=#Planning;
                SourceExpr=CurrentJnlBatchName;
                OnValidate=BEGIN
                             ReqJnlManagement.CheckName(CurrentJnlBatchName,Rec);
                             CurrentJnlBatchNameOnAfterVali;
                           END;

                OnLookup=BEGIN
                           CurrPage.SAVERECORD;
                           ReqJnlManagement.LookupName(CurrentJnlBatchName,Rec);
                           CurrPage.UPDATE(FALSE);
                         END;
                          }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den type indk›bskladdelinje, du vil oprette.;
                           ENU=Specifies the type of requisition worksheet line you are creating.];
                ApplicationArea=#Planning;
                SourceExpr=Type;
                OnValidate=BEGIN
                             ReqJnlManagement.GetDescriptionAndRcptName(Rec,Description2,BuyFromVendorName);
                           END;
                            }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Planning;
                SourceExpr="No.";
                OnValidate=BEGIN
                             ReqJnlManagement.GetDescriptionAndRcptName(Rec,Description2,BuyFromVendorName);
                             ShowShortcutDimCode(ShortcutDimCode);
                           END;
                            }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en handling for at genoprette balancen i forholdet mellem udbud og eftersp›rgsel.;
                           ENU=Specifies an action to take to rebalance the demand-supply situation.];
                ApplicationArea=#Planning;
                SourceExpr="Action Message" }

    { 65  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om den aktionsmeddelelse, som foresl†s for linjen, skal godkendes.;
                           ENU=Specifies whether to accept the action message proposed for the line.];
                ApplicationArea=#Planning;
                SourceExpr="Accept Action Message" }

    { 62  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver tekst, der beskriver posten.;
                           ENU=Specifies text that describes the entry.];
                ApplicationArea=#Planning;
                SourceExpr=Description }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver ekstra tekst til beskrivelse af posten eller en bem‘rkning om indk›bskladdelinjen.;
                           ENU=Specifies additional text describing the entry, or a remark about the requisition worksheet line.];
                ApplicationArea=#Planning;
                SourceExpr="Description 2";
                Visible=FALSE }

    { 92  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, som varerne overflyttes fra.;
                           ENU=Specifies the code of the location that items are transferred from.];
                ApplicationArea=#Location;
                SourceExpr="Transfer-from Code";
                Visible=FALSE }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for den lagerlokation, hvor de bestilte varer skal registreres p†.;
                           ENU=Specifies a code for an inventory location where the items that are being ordered will be registered.];
                ApplicationArea=#Location;
                SourceExpr="Location Code" }

    { 69  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der er anf›rt p† produktions- eller k›bsordren, n†r en aktionsmeddelelse foresl†r ‘ndring af antallet i en ordre.;
                           ENU=Specifies the quantity stated on the production or purchase order, when an action message proposes to change the quantity on an order.];
                ApplicationArea=#Planning;
                SourceExpr="Original Quantity" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen eller ressourcen der skal angives p† linjen.;
                           ENU=Specifies the number of units of the item or resource specified on the line.];
                ApplicationArea=#Planning;
                SourceExpr=Quantity }

    { 66  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Planning;
                SourceExpr="Unit of Measure Code" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kostprisen pr. enhed af den valgte vare eller ressource.;
                           ENU=Specifies the cost of one unit of the selected item or resource.];
                ApplicationArea=#Planning;
                SourceExpr="Direct Unit Cost" }

    { 27  ;2   ;Field     ;
                AssistEdit=Yes;
                ToolTipML=[DAN=Angiver valutakoden for rekvisitionslinjerne.;
                           ENU=Specifies the currency code for the requisition lines.];
                ApplicationArea=#Planning;
                SourceExpr="Currency Code";
                Visible=FALSE;
                OnAssistEdit=BEGIN
                               ChangeExchangeRate.SetParameter("Currency Code","Currency Factor",WORKDATE);
                               IF ChangeExchangeRate.RUNMODAL = ACTION::OK THEN
                                 VALIDATE("Currency Factor",ChangeExchangeRate.GetParameter);

                               CLEAR(ChangeExchangeRate);
                             END;
                              }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den rabatprocent, der tildeles varen p† linjen.;
                           ENU=Specifies the discount percentage that is granted for the item on the line.];
                ApplicationArea=#Planning;
                SourceExpr="Line Discount %";
                Visible=FALSE }

    { 73  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den forfaldsdato, der er anf›rt p† produktions- eller k›bsordren, n†r en aktionsmeddelelse foresl†r omplanl‘gning af en ordre.;
                           ENU=Specifies the due date stated on the production or purchase order, when an action message proposes to reschedule an order.];
                ApplicationArea=#Planning;
                SourceExpr="Original Due Date" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor du kan forvente at modtage varerne.;
                           ENU=Specifies the date when you can expect to receive the items.];
                ApplicationArea=#Planning;
                SourceExpr="Due Date" }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor den relaterede ordre blev oprettet.;
                           ENU=Specifies the date when the related order was created.];
                ApplicationArea=#Planning;
                SourceExpr="Order Date";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den kreditor, der skal levere varerne i k›bsordren.;
                           ENU=Specifies the number of the vendor who will ship the items in the purchase order.];
                ApplicationArea=#Planning;
                SourceExpr="Vendor No.";
                OnValidate=BEGIN
                             ReqJnlManagement.GetDescriptionAndRcptName(Rec,Description2,BuyFromVendorName);
                             ShowShortcutDimCode(ShortcutDimCode);
                           END;
                            }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det nummer, som kreditoren bruger til denne vare.;
                           ENU=Specifies the number that the vendor uses for this item.];
                ApplicationArea=#Planning;
                SourceExpr="Vendor Item No." }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bestillingsadressen for den relaterede kreditor.;
                           ENU=Specifies the order address of the related vendor.];
                ApplicationArea=#Planning;
                SourceExpr="Order Address Code";
                Visible=FALSE }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† debitoren.;
                           ENU=Specifies the number of the customer.];
                ApplicationArea=#Planning;
                SourceExpr="Sell-to Customer No.";
                Visible=FALSE }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for en alternativ leveringsadresse, hvis du vil sende til en anden adresse end den, der er indsat automatisk. Dette felt bruges ogs† i tilf‘lde af direkte levering.;
                           ENU=Specifies a code for an alternate shipment address if you want to ship to another address than the one that has been entered automatically. This field is also used in case of drop shipment.];
                ApplicationArea=#Planning;
                SourceExpr="Ship-to Code";
                Visible=FALSE }

    { 70  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den relaterede produktionsordre.;
                           ENU=Specifies the number of the related production order.];
                ApplicationArea=#Planning;
                SourceExpr="Prod. Order No.";
                Visible=FALSE }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et p† den bruger, der bestiller varerne p† linjen.;
                           ENU=Specifies the ID of the user who is ordering the items on the line.];
                ApplicationArea=#Planning;
                SourceExpr="Requester ID";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om varerne p† linjen er blevet godkendt til k›b.;
                           ENU=Specifies whether the items on the line have been approved for purchase.];
                ApplicationArea=#Planning;
                SourceExpr=Confirmed;
                Visible=FALSE }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
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

    { 79  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den relevante produktions- eller indk›bsordre.;
                           ENU=Specifies the number of the relevant production or purchase order.];
                ApplicationArea=#Planning;
                SourceExpr="Ref. Order No.";
                Visible=FALSE }

    { 85  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om ordren er en k›bsordre, en produktionsordre eller en overflytningsordre.;
                           ENU=Specifies whether the order is a purchase order, a production order, or a transfer order.];
                ApplicationArea=#Planning;
                SourceExpr="Ref. Order Type";
                Visible=FALSE }

    { 89  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken slags ordre der bruges til at oprette genbestillingsordrer og forslag.;
                           ENU=Specifies which kind of order to use to create replenishment orders and order proposals.];
                ApplicationArea=#Planning;
                SourceExpr="Replenishment System" }

    { 87  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† k›bs- eller produktionsordrelinjen.;
                           ENU=Specifies the number of the purchase or production order line.];
                ApplicationArea=#Planning;
                SourceExpr="Ref. Line No.";
                Visible=FALSE }

    { 94  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om der tages h›jde for den forsyning, der repr‘senteres af linjen i planl‘gningssystemet, n†r der beregnes aktionsmeddelelser.;
                           ENU=Specifies whether the supply represented by this line is considered by the planning system when calculating action messages.];
                ApplicationArea=#Planning;
                SourceExpr="Planning Flexibility";
                Visible=FALSE }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om der findes en rammek›bsordre for varen p† rekvisitionslinjen.;
                           ENU=Specifies if a blanket purchase order exists for the item on the requisition line.];
                ApplicationArea=#Planning;
                BlankZero=Yes;
                SourceExpr="Blanket Purch. Order Exists";
                Visible=False }

    { 20  ;1   ;Group      }

    { 1901776201;2;Group  ;
                GroupType=FixedLayout }

    { 1902759801;3;Group  ;
                CaptionML=[DAN=Beskrivelse;
                           ENU=Description] }

    { 21  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver en supplerende del af kladdebeskrivelsen.;
                           ENU=Specifies an additional part of the worksheet description.];
                ApplicationArea=#Planning;
                SourceExpr=Description2;
                Editable=FALSE;
                ShowCaption=No }

    { 1901652601;3;Group  ;
                CaptionML=[DAN=Leverand›rnavn;
                           ENU=Buy-from Vendor Name] }

    { 23  ;4   ;Field     ;
                CaptionML=[DAN=Leverand›rnavn;
                           ENU=Buy-from Vendor Name];
                ToolTipML=[DAN=Angiver kreditoren i henhold til v‘rdierne i felterne Bilagsnr. og Dokumenttype.;
                           ENU=Specifies the vendor according to the values in the Document No. and Document Type fields.];
                ApplicationArea=#Planning;
                SourceExpr=BuyFromVendorName;
                Editable=FALSE }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1903326807;1;Part   ;
                ApplicationArea=#Planning;
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page9090;
                Visible=TRUE;
                PartType=Page }

  }
  CODE
  {
    VAR
      SalesHeader@1000 : Record 36;
      GetSalesOrder@1004 : Report 698;
      CalculatePlan@1003 : Report 699;
      ReqJnlManagement@1005 : Codeunit 330;
      ItemAvailFormsMgt@1011 : Codeunit 353;
      ChangeExchangeRate@1002 : Page 511;
      SalesOrder@1001 : Page 42;
      CurrentJnlBatchName@1006 : Code[10];
      Description2@1007 : Text[50];
      BuyFromVendorName@1008 : Text[50];
      ShortcutDimCode@1009 : ARRAY [8] OF Code[20];
      OpenedFromBatch@1010 : Boolean;

    LOCAL PROCEDURE CurrentJnlBatchNameOnAfterVali@19002411();
    BEGIN
      CurrPage.SAVERECORD;
      ReqJnlManagement.SetName(CurrentJnlBatchName,Rec);
      CurrPage.UPDATE(FALSE);
    END;

    BEGIN
    END.
  }
}

