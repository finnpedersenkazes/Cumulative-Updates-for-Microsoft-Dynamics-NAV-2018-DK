OBJECT Page 5700 Stockkeeping Unit Card
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Lagervarekort;
               ENU=Stockkeeping Unit Card];
    SourceTable=Table5700;
    PageType=Card;
    OnInit=BEGIN
             UnitCostEnable := TRUE;
             StandardCostEnable := TRUE;
             OverflowLevelEnable := TRUE;
             DampenerQtyEnable := TRUE;
             DampenerPeriodEnable := TRUE;
             LotAccumulationPeriodEnable := TRUE;
             ReschedulingPeriodEnable := TRUE;
             IncludeInventoryEnable := TRUE;
             OrderMultipleEnable := TRUE;
             MaximumOrderQtyEnable := TRUE;
             MinimumOrderQtyEnable := TRUE;
             MaximumInventoryEnable := TRUE;
             ReorderQtyEnable := TRUE;
             ReorderPointEnable := TRUE;
             SafetyStockQtyEnable := TRUE;
             SafetyLeadTimeEnable := TRUE;
             TimeBucketEnable := TRUE;
           END;

    OnAfterGetRecord=BEGIN
                       InvtSetup.GET;
                       Item.RESET;
                       IF Item.GET("Item No.") THEN BEGIN
                         IF InvtSetup."Average Cost Calc. Type" = InvtSetup."Average Cost Calc. Type"::"Item & Location & Variant" THEN BEGIN
                           Item.SETRANGE("Location Filter","Location Code");
                           Item.SETRANGE("Variant Filter","Variant Code");
                         END;
                         Item.SETFILTER("Date Filter",GETFILTER("Date Filter"));
                       END;
                       EnablePlanningControls;
                       EnableCostingControls;
                     END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 81      ;1   ;ActionGroup;
                      CaptionML=[DAN=V&are;
                                 ENU=&Item];
                      Image=Item }
      { 82      ;2   ;Action    ;
                      Name=Card;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om den p†g‘ldende record p† bilaget eller kladdelinjen.;
                                 ENU=View or change detailed information about the record on the document or journal line.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 30;
                      RunPageLink=No.=FIELD(Item No.);
                      Image=EditLines }
      { 88      ;2   ;ActionGroup;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      Image=Statistics }
      { 89      ;3   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=F† vist statistiske oplysninger om recorden, f.eks. v‘rdien af bogf›rte poster.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 ItemStatistics@1001 : Page 5827;
                               BEGIN
                                 ItemStatistics.SetItem(Item);
                                 ItemStatistics.RUNMODAL;
                               END;
                                }
      { 100     ;2   ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 124;
                      RunPageLink=Table Name=CONST(Item),
                                  No.=FIELD(Item No.);
                      Image=ViewComments }
      { 101     ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      RunObject=Page 540;
                      RunPageLink=Table ID=CONST(27),
                                  No.=FIELD(Item No.);
                      Image=Dimensions }
      { 102     ;2   ;Action    ;
                      CaptionML=[DAN=&Billede;
                                 ENU=&Picture];
                      ToolTipML=[DAN=F† vist eller tilf›j et billede af varen eller f.eks. virksomhedens logo.;
                                 ENU=View or add a picture of the item or, for example, the company's logo.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 346;
                      RunPageLink=No.=FIELD(Item No.),
                                  Date Filter=FIELD(Date Filter),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
                                  Location Filter=FIELD(Location Code),
                                  Drop Shipment Filter=FIELD(Drop Shipment Filter),
                                  Variant Filter=FIELD(Variant Code);
                      Image=Picture }
      { 103     ;2   ;Separator  }
      { 104     ;2   ;Action    ;
                      CaptionML=[DAN=&Enheder;
                                 ENU=&Units of Measure];
                      ToolTipML=[DAN=Angiv de forskellige enheder, som en vare kan handles i, f.eks. styk, boks eller time.;
                                 ENU=Set up the different units that the item can be traded in, such as piece, box, or hour.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5404;
                      RunPageLink=Item No.=FIELD(Item No.);
                      Image=UnitOfMeasure }
      { 105     ;2   ;Action    ;
                      CaptionML=[DAN=V&arianter;
                                 ENU=Va&riants];
                      ToolTipML=[DAN=Se, hvordan lagerniveauet for en vare udvikles over tid i henhold til den valgte variant.;
                                 ENU=View how the inventory level of an item will develop over time according to the variant that you select.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5401;
                      RunPageLink=Item No.=FIELD(Item No.);
                      Image=ItemVariant }
      { 106     ;2   ;Separator  }
      { 107     ;2   ;Action    ;
                      CaptionML=[DAN=Varetekster;
                                 ENU=Translations];
                      ToolTipML=[DAN=Vis eller rediger oversatte varebeskrivelser. Oversatte varebeskrivelser inds‘ttes automatisk i bilag i overensstemmelse med sprogkoden.;
                                 ENU=View or edit translated item descriptions. Translated item descriptions are automatically inserted on documents according to the language code.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 35;
                      RunPageLink=Item No.=FIELD(Item No.),
                                  Variant Code=FIELD(FILTER(Variant Code));
                      Image=Translations }
      { 108     ;2   ;Action    ;
                      CaptionML=[DAN=&Udvidede tekster;
                                 ENU=E&xtended Texts];
                      ToolTipML=[DAN=V‘lg eller konfigurer supplerende tekst til beskrivelsen af varen. Den udvidede tekst kan inds‘ttes under feltet Beskrivelse i dokumentlinjerne for varen.;
                                 ENU=Select or set up additional text for the description of the item. Extended text can be inserted under the Description field on document lines for the item.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 391;
                      RunPageView=SORTING(Table Name,No.,Language Code,All Language Codes,Starting Date,Ending Date);
                      RunPageLink=Table Name=CONST(Item),
                                  No.=FIELD(Item No.);
                      Image=Text }
      { 14      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Lagervare;
                                 ENU=&SKU];
                      Image=SKU }
      { 92      ;2   ;ActionGroup;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      Image=Statistics }
      { 99      ;3   ;Action    ;
                      CaptionML=[DAN=Poststatistik;
                                 ENU=Entry Statistics];
                      ToolTipML=[DAN=Vis poststatistik for den p†g‘ldende record.;
                                 ENU=View entry statistics for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 304;
                      RunPageLink=No.=FIELD(Item No.),
                                  Date Filter=FIELD(Date Filter),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
                                  Location Filter=FIELD(Location Code),
                                  Drop Shipment Filter=FIELD(Drop Shipment Filter),
                                  Variant Filter=FIELD(Variant Code);
                      Image=EntryStatistics }
      { 118     ;3   ;Action    ;
                      CaptionML=[DAN=&Terminsoversigt;
                                 ENU=T&urnover];
                      ToolTipML=[DAN=Se en detaljeret oversigt over vareoms‘tningen fordelt p† perioder, n†r du har angivet de relevante filtre for lokation og variant.;
                                 ENU=View a detailed account of item turnover by periods after you have set the relevant filters for location and variant.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 158;
                      RunPageLink=No.=FIELD(Item No.),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
                                  Location Filter=FIELD(Location Code),
                                  Drop Shipment Filter=FIELD(Drop Shipment Filter),
                                  Variant Filter=FIELD(Variant Code);
                      Image=Turnover }
      { 120     ;2   ;ActionGroup;
                      CaptionML=[DAN=&Varedisponering pr.;
                                 ENU=&Item Availability by];
                      Image=ItemAvailability }
      { 3       ;3   ;Action    ;
                      CaptionML=[DAN=Begivenhed;
                                 ENU=Event];
                      ToolTipML=[DAN=Se, hvordan den faktiske og forventede tilg‘ngelige saldo for en vare udvikler sig over tid i henhold til udbud og eftersp›rgsel.;
                                 ENU=View how the actual and the projected available balance of an item will develop over time according to supply and demand events.];
                      ApplicationArea=#Advanced;
                      Image=Event;
                      OnAction=VAR
                                 Item@1001 : Record 27;
                               BEGIN
                                 Item.GET("Item No.");
                                 Item.SETRANGE("Location Filter","Location Code");
                                 Item.SETRANGE("Variant Filter","Variant Code");
                                 COPYFILTER("Date Filter",Item."Date Filter");
                                 COPYFILTER("Global Dimension 1 Filter",Item."Global Dimension 1 Filter");
                                 COPYFILTER("Global Dimension 2 Filter",Item."Global Dimension 2 Filter");
                                 COPYFILTER("Drop Shipment Filter",Item."Drop Shipment Filter");
                                 ItemAvailFormsMgt.ShowItemAvailFromItem(Item,ItemAvailFormsMgt.ByEvent);
                               END;
                                }
      { 121     ;3   ;Action    ;
                      CaptionML=[DAN=Periode;
                                 ENU=Period];
                      ToolTipML=[DAN=Vis det forventede antal af en vare over tid i henhold til tidsperioder som f.eks. dag, uge eller m†ned.;
                                 ENU=View the projected quantity of the item over time according to time periods, such as day, week, or month.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 157;
                      RunPageLink=No.=FIELD(Item No.),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
                                  Location Filter=FIELD(Location Code),
                                  Drop Shipment Filter=FIELD(Drop Shipment Filter),
                                  Variant Filter=FIELD(Variant Code);
                      Image=Period }
      { 47      ;3   ;Action    ;
                      CaptionML=[DAN=Styklisteniveau;
                                 ENU=BOM Level];
                      ToolTipML=[DAN=F† vist tilg‘ngelighedstallene for styklistevarer, der viser, hvor mange enheder af en overordnet vare, du kan fremstille, baseret p† tilg‘ngeligheden af underordnede varer.;
                                 ENU=View availability figures for items on bills of materials that show how many units of a parent item you can make based on the availability of child items.];
                      ApplicationArea=#Assembly;
                      Image=BOMLevel;
                      OnAction=VAR
                                 Item@1001 : Record 27;
                               BEGIN
                                 Item.GET("Item No.");
                                 Item.SETRANGE("Location Filter","Location Code");
                                 Item.SETRANGE("Variant Filter","Variant Code");
                                 ItemAvailFormsMgt.ShowItemAvailFromItem(Item,ItemAvailFormsMgt.ByBOM);
                               END;
                                }
      { 48      ;3   ;Action    ;
                      CaptionML=[DAN=Tidslinje;
                                 ENU=Timeline];
                      ToolTipML=[DAN=F† en grafisk visning af en vares planlagte lager baseret p† fremtidige udbuds- og eftersp›rgselsh‘ndelser med eller uden planl‘gningsforslag. Resultatet er en grafisk gengivelse af lagerprofilen.;
                                 ENU=Get a graphical view of an item's projected inventory based on future supply and demand events, with or without planning suggestions. The result is a graphical representation of the inventory profile.];
                      ApplicationArea=#Advanced;
                      Image=Timeline;
                      OnAction=BEGIN
                                 ShowTimeline(Rec);
                               END;
                                }
      { 124     ;2   ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5704;
                      RunPageLink=Item No.=FIELD(Item No.),
                                  Variant Code=FIELD(Variant Code),
                                  Location Code=FIELD(Location Code);
                      Image=ViewComments }
      { 49      ;1   ;ActionGroup;
                      CaptionML=[DAN=Oversigt;
                                 ENU=History];
                      Image=History }
      { 28      ;2   ;ActionGroup;
                      CaptionML=[DAN=&Poster;
                                 ENU=E&ntries];
                      Image=Entries }
      { 29      ;3   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=&Poster;
                                 ENU=Ledger E&ntries];
                      ToolTipML=[DAN=Vis historikken over transaktioner, der er bogf›rt for den valgte record.;
                                 ENU=View the history of transactions that have been posted for the selected record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 38;
                      RunPageView=SORTING(Item No.,Open,Variant Code);
                      RunPageLink=Item No.=FIELD(Item No.),
                                  Location Code=FIELD(Location Code),
                                  Variant Code=FIELD(Variant Code);
                      Promoted=No;
                      Image=ItemLedger;
                      PromotedCategory=Process }
      { 60      ;3   ;Action    ;
                      CaptionML=[DAN=&Reservationsposter;
                                 ENU=&Reservation Entries];
                      ToolTipML=[DAN=F† vist alle reservationer, der er foretaget for varen, enten manuelt eller automatisk.;
                                 ENU=View all reservations that are made for the item, either manually or automatically.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 497;
                      RunPageView=SORTING(Item No.,Variant Code,Location Code,Reservation Status);
                      RunPageLink=Item No.=FIELD(Item No.),
                                  Location Code=FIELD(Location Code),
                                  Variant Code=FIELD(Variant Code),
                                  Reservation Status=CONST(Reservation);
                      Image=ReservationLedger }
      { 61      ;3   ;Action    ;
                      CaptionML=[DAN=&Lageropg›relsesposter;
                                 ENU=&Phys. Inventory Ledger Entries];
                      ToolTipML=[DAN=F† vist antallet af vareenheder p† lager ved seneste manuelle opt‘lling.;
                                 ENU=View how many units of the item you had in stock at the last physical count.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 390;
                      RunPageView=SORTING(Item No.,Variant Code);
                      RunPageLink=Item No.=FIELD(Item No.),
                                  Location Code=FIELD(Location Code),
                                  Variant Code=FIELD(Variant Code);
                      Image=PhysicalInventoryLedger }
      { 79      ;3   ;Action    ;
                      CaptionML=[DAN=&V‘rdiposter;
                                 ENU=&Value Entries];
                      ToolTipML=[DAN=F† vist historikken over bogf›rte bel›b, der p†virker v‘rdien af varen. V‘rdiposter oprettes for hver transaktion med varen.;
                                 ENU=View the history of posted amounts that affect the value of the item. Value entries are created for every transaction with the item.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5802;
                      RunPageView=SORTING(Item No.,Valuation Date,Location Code,Variant Code);
                      RunPageLink=Item No.=FIELD(Item No.),
                                  Location Code=FIELD(Location Code),
                                  Variant Code=FIELD(Variant Code);
                      Image=ValueLedger }
      { 85      ;3   ;Action    ;
                      CaptionML=[DAN=Vare&sporingsposter;
                                 ENU=Item &Tracking Entries];
                      ToolTipML=[DAN=Vis serie- eller lotnumre, der er tildelt til varer.;
                                 ENU=View serial or lot numbers that are assigned to items.];
                      ApplicationArea=#ItemTracking;
                      Image=ItemTrackingLedger;
                      OnAction=VAR
                                 ItemTrackingDocMgt@1001 : Codeunit 6503;
                               BEGIN
                                 ItemTrackingDocMgt.ShowItemTrackingForMasterData(0,'',"Item No.","Variant Code",'','',"Location Code");
                               END;
                                }
      { 50      ;1   ;ActionGroup;
                      CaptionML=[DAN=Lagersted;
                                 ENU=Warehouse];
                      Image=Warehouse }
      { 111     ;2   ;Action    ;
                      CaptionML=[DAN=Placerings&indhold;
                                 ENU=&Bin Contents];
                      ToolTipML=[DAN=F† vist varens antal p† alle relevante placeringer. Du kan se alle vigtige parametre i relation til placeringsindholdet, og du kan redigere bestemte parametre for placeringsindholdet i dette vindue.;
                                 ENU=View the quantities of the item in each bin where it exists. You can see all the important parameters relating to bin content, and you can modify certain bin content parameters in this window.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7305;
                      RunPageView=SORTING(Location Code,Item No.,Variant Code);
                      RunPageLink=Location Code=FIELD(Location Code),
                                  Item No.=FIELD(Item No.),
                                  Variant Code=FIELD(Variant Code);
                      Image=BinContent }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 51      ;1   ;ActionGroup;
                      CaptionML=[DAN=Ny;
                                 ENU=New];
                      Image=NewItem }
      { 1900294905;2 ;Action    ;
                      Name=NewItem;
                      CaptionML=[DAN=Ny vare;
                                 ENU=New Item];
                      ToolTipML=[DAN=Opret et varekort, der er baseret p† lagervaren.;
                                 ENU=Create an item card based on the stockkeeping unit.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 30;
                      Promoted=Yes;
                      Image=NewItem;
                      PromotedCategory=New;
                      RunPageMode=Create }
      { 90      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 7380    ;2   ;Action    ;
                      AccessByPermission=TableData 7380=R;
                      CaptionML=[DAN=&Beregn opt‘llingsperiode;
                                 ENU=C&alculate Counting Period];
                      ToolTipML=[DAN=Forbered et fysisk lager ved at beregne, hvilke varer eller lagervarer der skal t‘lles med i den aktuelle periode.;
                                 ENU=Prepare for a physical inventory by calculating which items or SKUs need to be counted in the current period.];
                      ApplicationArea=#Warehouse;
                      Image=CalculateCalendar;
                      OnAction=VAR
                                 PhysInvtCountMgt@1000 : Codeunit 7380;
                               BEGIN
                                 PhysInvtCountMgt.UpdateSKUPhysInvtCount(Rec);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det varenummer, som lagervaren er tilknyttet.;
                           ENU=Specifies the item number to which the SKU applies.];
                ApplicationArea=#Advanced;
                SourceExpr="Item No.";
                Importance=Promoted }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen fra varekortet.;
                           ENU=Specifies the description from the Item Card.];
                ApplicationArea=#Advanced;
                SourceExpr=Description }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, f.eks. lagerstedet eller distributionscenteret, som lagervaren er tilknyttet.;
                           ENU=Specifies the location code (for example, the warehouse or distribution center) to which the SKU applies.];
                ApplicationArea=#Advanced;
                SourceExpr="Location Code";
                Importance=Promoted }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Importance=Promoted }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om varen er en montagestykliste.;
                           ENU=Specifies if the item is an assembly BOM.];
                ApplicationArea=#Assembly;
                SourceExpr="Assembly BOM" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor lagervaren er placeret p† lagerstedet.;
                           ENU=Specifies where to find the SKU in the warehouse.];
                ApplicationArea=#Advanced;
                SourceExpr="Shelf No." }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn†r lagerkortet sidst blev ‘ndret.;
                           ENU=Specifies when the SKU card was last modified.];
                ApplicationArea=#Advanced;
                SourceExpr="Last Date Modified" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver for lagervaren det samme, som feltet g›r p† varekortet.;
                           ENU=Specifies for the SKU, the same as the field does on the item card.];
                ApplicationArea=#Advanced;
                SourceExpr="Qty. on Purch. Order" }

    { 74  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange vareenheder der er planlagt til produktion, dvs. hvor mange enheder der er anf›rt p† udest†ende produktionsordrelinjer.;
                           ENU=Specifies how many item units have been planned for production, which is how many units are on outstanding production order lines.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Qty. on Prod. Order" }

    { 64  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilket antal lagervarer der er i transit. Disse varer er afsendt, men endnu ikke modtaget.;
                           ENU=Specifies the quantity of the SKUs in transit. These items have been shipped, but not yet received.];
                ApplicationArea=#Advanced;
                SourceExpr="Qty. in Transit" }

    { 84  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange vareenheder der kr‘ves til produktionen, dvs. hvor mange enheder der er tilbage p† listerne over udest†ende produktionsordrekomponenter.;
                           ENU=Specifies how many item units are needed for production, which is how many units remain on outstanding production order component lists.];
                ApplicationArea=#Advanced;
                SourceExpr="Qty. on Component Lines" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver for lagervaren det samme, som feltet g›r p† varekortet.;
                           ENU=Specifies for the SKU, the same as the field does on the item card.];
                ApplicationArea=#Advanced;
                SourceExpr="Qty. on Sales Order" }

    { 87  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange vareenheder der er reserveret til serviceordrer, dvs. hvor mange enheder der er anf›rt p† udest†ende serviceordrelinjer.;
                           ENU=Specifies how many item units are reserved for service orders, which is how many units are listed on outstanding service order lines.];
                ApplicationArea=#Service;
                SourceExpr="Qty. on Service Order" }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver for lagervaren det samme, som feltet g›r p† varekortet.;
                           ENU=Specifies for the SKU, the same as the field does on the item card.];
                ApplicationArea=#Advanced;
                SourceExpr=Inventory;
                Importance=Promoted }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen der er allokeret til sager, dvs. er anf›rt p† udest†ende sagsplanl‘gningslinjer.;
                           ENU=Specifies how many units of the item are allocated to jobs, meaning listed on outstanding job planning lines.];
                ApplicationArea=#Advanced;
                SourceExpr="Qty. on Job Order" }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af lagervaren der er allokeret til montageordrer, dvs. hvor mange der er anf›rt p† udest†ende montageordrehoveder.;
                           ENU=Specifies how many units of the SKU are allocated to assembly orders, which is how many are listed on outstanding assembly order headers.];
                ApplicationArea=#Assembly;
                SourceExpr="Qty. on Assembly Order" }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange vareenheder der er allokeret som montagekomponenter, dvs. hvor mange enheder der er anf›rt p† udest†ende montageordrelinjer.;
                           ENU=Specifies how many item units are allocated as assembly components, which is how many units are on outstanding assembly order lines.];
                ApplicationArea=#Assembly;
                SourceExpr="Qty. on Asm. Component" }

    { 1905885101;1;Group  ;
                CaptionML=[DAN=Fakturering;
                           ENU=Invoicing] }

    { 67  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kostpris, der anvendes som et overslag, hvor afvigelser kan justeres p† et senere tidspunkt. Dette anvendes typisk ved montage og produktion, hvor omkostningerne varierer.;
                           ENU=Specifies the unit cost that is used as an estimation to be adjusted with variances later. It is typically used in assembly and production where costs can vary.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Standard Cost";
                Enabled=StandardCostEnable;
                OnDrillDown=VAR
                              ShowAvgCalcItem@1000 : Codeunit 5803;
                            BEGIN
                              ShowAvgCalcItem.DrillDownAvgCostAdjmtPoint(Item);
                            END;
                             }

    { 70  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, p† ‚n enhed af varen eller ressourcen p† linjen.;
                           ENU=Specifies the cost of one unit of the item or resource on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Unit Cost";
                Importance=Promoted;
                Enabled=UnitCostEnable;
                OnDrillDown=VAR
                              ShowAvgCalcItem@1000 : Codeunit 5803;
                            BEGIN
                              ShowAvgCalcItem.DrillDownAvgCostAdjmtPoint(Item);
                            END;
                             }

    { 72  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den seneste den k›bspris, der er betalt for lagervaren.;
                           ENU=Specifies the most recent direct unit cost that was paid for the SKU.];
                ApplicationArea=#Advanced;
                SourceExpr="Last Direct Cost" }

    { 1904731401;1;Group  ;
                CaptionML=[DAN=Genbestilling;
                           ENU=Replenishment] }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken type forsyningsordre der oprettes af planl‘gningssystemet, n†r lagervaren skal genbestilles.;
                           ENU=Specifies the type of supply order that is created by the planning system when the SKU needs to be replenished.];
                ApplicationArea=#Advanced;
                SourceExpr="Replenishment System";
                Importance=Promoted }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en datoformel for det tidsrum, det tager at genbestille varen.;
                           ENU=Specifies a date formula for the amount of time it takes to replenish the item.];
                ApplicationArea=#Advanced;
                SourceExpr="Lead Time Calculation" }

    { 127 ;2   ;Group     ;
                CaptionML=[DAN=K›b;
                           ENU=Purchase] }

    { 32  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver for lagervaren det samme, som feltet g›r p† varekortet.;
                           ENU=Specifies for the SKU, the same as the field does on the item card.];
                ApplicationArea=#Advanced;
                SourceExpr="Vendor No." }

    { 34  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver det nummer, som kreditoren bruger til denne vare.;
                           ENU=Specifies the number that the vendor uses for this item.];
                ApplicationArea=#Advanced;
                SourceExpr="Vendor Item No." }

    { 129 ;2   ;Group     ;
                CaptionML=[DAN=Overf›rsel;
                           ENU=Transfer] }

    { 30  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, som varerne overflyttes fra.;
                           ENU=Specifies the code of the location that items are transferred from.];
                ApplicationArea=#Advanced;
                SourceExpr="Transfer-from Code" }

    { 128 ;2   ;Group     ;
                CaptionML=[DAN=Produktion;
                           ENU=Production] }

    { 125 ;3   ;Field     ;
                ToolTipML=[DAN=Angiver, om der skal foretages beregninger af yderligere ordrer for tilknyttede komponenter.;
                           ENU=Specifies if additional orders for any related components are calculated.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Manufacturing Policy" }

    { 62  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan forbruget af varen (komponenten) beregnes og h†ndteres i produktionsprocesserne. Manuelt: Angiv og bogf›r forbrug i forbrugskladden manuelt. Fremad: Bogf›rer automatisk forbrug if›lge produktionsordrekomponentlinjerne, n†r den f›rste handling starter. Bagl‘ns: Beregner og bogf›rer automatisk forbrug if›lge produktionsordrekomponentlinjerne, n†r produktionsordren er f‘rdig. Pluk + Fremad / Pluk + Bagl‘ns: Variationer med lagersted.;
                           ENU=Specifies how consumption of the item (component) is calculated and handled in production processes. Manual: Enter and post consumption in the consumption journal manually. Forward: Automatically posts consumption according to the production order component lines when the first operation starts. Backward: Automatically calculates and posts consumption according to the production order component lines when the production order is finished. Pick + Forward / Pick + Backward: Variations with warehousing.];
                ApplicationArea=#Advanced;
                SourceExpr="Flushing Method" }

    { 77  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver den lagerlokation, som produktionsordrekomponenterne skal tages fra, n†r lagervaren skal produceres.;
                           ENU=Specifies the inventory location from where the production order components are to be taken when producing this SKU.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Components at Location" }

    { 16  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver for lagervaren det samme, som feltet g›r p† varekortet.;
                           ENU=Specifies for the SKU, the same as the field does on the item card.];
                ApplicationArea=#Advanced;
                SourceExpr="Lot Size" }

    { 13  ;2   ;Group     ;
                CaptionML=[DAN=Montage;
                           ENU=Assembly];
                GroupType=Group }

    { 15  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken standardordrestr›m, der bruges til at levere lagervaren via montage.;
                           ENU=Specifies which default order flow is used to supply this SKU by assembly.];
                ApplicationArea=#Assembly;
                SourceExpr="Assembly Policy" }

    { 1901343701;1;Group  ;
                CaptionML=[DAN=Planl‘gning;
                           ENU=Planning] }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver for lagervaren det samme, som feltet g›r p† varekortet.;
                           ENU=Specifies for the SKU, the same as the field does on the item card.];
                ApplicationArea=#Advanced;
                SourceExpr="Reordering Policy";
                Importance=Promoted;
                OnValidate=BEGIN
                             EnablePlanningControls;
                           END;
                            }

    { 133 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en tidsperiode, hvor planl‘gningsprogrammet ikke skal foresl† at omplanl‘gge eksisterende forsyningsordrer fremad.;
                           ENU=Specifies a period of time during which you do not want the planning system to propose to reschedule existing supply orders forward.];
                ApplicationArea=#Advanced;
                SourceExpr="Dampener Period";
                Enabled=DampenerPeriodEnable }

    { 132 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en bufferm‘ngde til sp‘rring af ubetydelige ‘ndringsforslag, hvis det antal, som forsyningen vil blive ‘ndret med, er lavere end bufferm‘ngden.;
                           ENU=Specifies a dampener quantity to block insignificant change suggestions, if the quantity by which the supply would change is lower than the dampener quantity.];
                ApplicationArea=#Advanced;
                SourceExpr="Dampener Quantity";
                Enabled=DampenerQtyEnable }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver for lagervaren det samme, som feltet g›r p† varekortet.;
                           ENU=Specifies for the SKU, the same as the field does on the item card.];
                ApplicationArea=#Advanced;
                SourceExpr="Safety Lead Time";
                Enabled=SafetyLeadTimeEnable }

    { 75  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver for lagervaren det samme, som feltet g›r p† varekortet.;
                           ENU=Specifies for the SKU, the same as the field does on the item card.];
                ApplicationArea=#Advanced;
                SourceExpr="Safety Stock Quantity";
                Enabled=SafetyStockQtyEnable }

    { 46  ;2   ;Group     ;
                CaptionML=[DAN=Lot-for-lot-parametre;
                           ENU=Lot-for-Lot Parameters];
                GroupType=Group }

    { 45  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver for lagervaren det samme, som feltet g›r p† varekortet.;
                           ENU=Specifies for the SKU, the same as the field does on the item card.];
                ApplicationArea=#Advanced;
                SourceExpr="Include Inventory";
                Enabled=IncludeInventoryEnable;
                OnValidate=BEGIN
                             EnablePlanningControls;
                           END;
                            }

    { 44  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver en periode, hvor flere krav er akkumuleret i ‚n forsyningsordre, n†r du bruger Lot-for-Lot-genbestilllingsmetoden.;
                           ENU=Specifies a period in which multiple demands are accumulated into one supply order when you use the Lot-for-Lot reordering policy.];
                ApplicationArea=#Advanced;
                SourceExpr="Lot Accumulation Period";
                Enabled=LotAccumulationPeriodEnable }

    { 43  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver en periode, inden for hvilken alle forslag om at ‘ndre en forsyningsdato altid best†r af handlingen Omplanl‘g og aldrig af handlingen Annuller + Ny.;
                           ENU=Specifies a period within which any suggestion to change a supply date always consists of a Reschedule action and never a Cancel + New action.];
                ApplicationArea=#Advanced;
                SourceExpr="Rescheduling Period";
                Enabled=ReschedulingPeriodEnable }

    { 37  ;2   ;Group     ;
                CaptionML=[DAN=Parametre for genbestillingspunkt;
                           ENU=Reorder-Point Parameters];
                GroupType=Group }

    { 39  ;3   ;Group     ;
                GroupType=GridLayout;
                Layout=Rows }

    { 41  ;4   ;Group     ;
                GroupType=Group }

    { 35  ;5   ;Field     ;
                ToolTipML=[DAN=Angiver for lagervaren det samme, som feltet g›r p† varekortet.;
                           ENU=Specifies for the SKU, the same as the field does on the item card.];
                ApplicationArea=#Advanced;
                SourceExpr="Reorder Point";
                Enabled=ReorderPointEnable }

    { 33  ;5   ;Field     ;
                ToolTipML=[DAN=Angiver for lagervaren det samme, som feltet g›r p† varekortet.;
                           ENU=Specifies for the SKU, the same as the field does on the item card.];
                ApplicationArea=#Advanced;
                SourceExpr="Reorder Quantity";
                Enabled=ReorderQtyEnable }

    { 27  ;5   ;Field     ;
                ToolTipML=[DAN=Angiver for lagervaren det samme, som feltet g›r p† varekortet.;
                           ENU=Specifies for the SKU, the same as the field does on the item card.];
                ApplicationArea=#Advanced;
                SourceExpr="Maximum Inventory";
                Enabled=MaximumInventoryEnable }

    { 18  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, som du tillader en planlagt beholdning at overstige genbestillingspunktet med, f›r programmet foresl†r at mindske de eksisterende forsyningsordrer.;
                           ENU=Specifies a quantity you allow projected inventory to exceed the reorder point before the system suggests to decrease existing supply orders.];
                ApplicationArea=#Advanced;
                SourceExpr="Overflow Level";
                Importance=Additional;
                Enabled=OverflowLevelEnable }

    { 17  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver en periode for lagervarens gentagelsesplanl‘gningshorisont, n†r du bruger genbestillingsmetoderne Fast genbestil.antal eller Maks. antal.;
                           ENU=Specifies a time period for the recurring planning horizon of the SKU when you use Fixed Reorder Qty. or Maximum Qty. reordering policies.];
                ApplicationArea=#Advanced;
                SourceExpr="Time Bucket";
                Importance=Additional;
                Enabled=TimeBucketEnable }

    { 19  ;2   ;Group     ;
                CaptionML=[DAN=Ordremodifikatorer;
                           ENU=Order Modifiers];
                Enabled=MinimumOrderQtyEnable;
                GroupType=Group }

    { 21  ;3   ;Group     ;
                GroupType=GridLayout;
                Layout=Rows }

    { 23  ;4   ;Group     ;
                GroupType=Group }

    { 31  ;5   ;Field     ;
                ToolTipML=[DAN=Angiver for lagervaren det samme, som feltet g›r p† varekortet.;
                           ENU=Specifies for the SKU, the same as the field does on the item card.];
                ApplicationArea=#Advanced;
                SourceExpr="Minimum Order Quantity";
                Enabled=MinimumOrderQtyEnable }

    { 25  ;5   ;Field     ;
                ToolTipML=[DAN=Angiver for lagervaren det samme, som feltet g›r p† varekortet.;
                           ENU=Specifies for the SKU, the same as the field does on the item card.];
                ApplicationArea=#Advanced;
                SourceExpr="Maximum Order Quantity";
                Enabled=MaximumOrderQtyEnable }

    { 24  ;5   ;Field     ;
                ToolTipML=[DAN=Angiver for lagervaren det samme, som feltet g›r p† varekortet.;
                           ENU=Specifies for the SKU, the same as the field does on the item card.];
                ApplicationArea=#Advanced;
                SourceExpr="Order Multiple";
                Enabled=OrderMultipleEnable }

    { 1907509201;1;Group  ;
                CaptionML=[DAN=Lagersted;
                           ENU=Warehouse] }

    { 93  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for det udstyr, som du skal anvende, n†r du arbejder med lagervaren.;
                           ENU=Specifies the code of the equipment that you need to use when working with the SKU.];
                ApplicationArea=#Advanced;
                SourceExpr="Special Equipment Code" }

    { 95  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den l‘g-p†-lager-skabelon, som programmet bruger, n†r der oprettes en l‘g-p†-lager for lagervaren.;
                           ENU=Specifies the put-away template that the program uses when it performs a put-away for the SKU.];
                ApplicationArea=#Warehouse;
                SourceExpr="Put-away Template Code" }

    { 115 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den enhed, som programmet bruger, n†r der oprettes en l‘g-p†-lager for lagervaren.;
                           ENU=Specifies the code of the unit of measure that the program uses when it performs a put-away for the SKU.];
                ApplicationArea=#Warehouse;
                SourceExpr="Put-away Unit of Measure Code";
                Importance=Promoted }

    { 97  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den opt‘llingsperiode, der angiver, hvor ofte lagervaren skal opt‘lles ved lageropg›relse.;
                           ENU=Specifies the code of the counting period that indicates how often you want to count the SKU in a physical inventory.];
                ApplicationArea=#Warehouse;
                SourceExpr="Phys Invt Counting Period Code";
                Importance=Promoted }

    { 91  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor du sidst har bogf›rt resultaterne af en lageropg›relse af lagervaren p† varekladden.;
                           ENU=Specifies the date on which you last posted the results of a physical inventory for the SKU to the item ledger.];
                ApplicationArea=#Advanced;
                SourceExpr="Last Phys. Invt. Date" }

    { 109 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor opt‘llingsperioden sidst blev beregnet.;
                           ENU=Specifies the last date on which you calculated the counting period.];
                ApplicationArea=#Advanced;
                SourceExpr="Last Counting Period Update" }

    { 113 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startdatoen for den n‘ste opt‘llingsperiode.;
                           ENU=Specifies the starting date of the next counting period.];
                ApplicationArea=#Warehouse;
                SourceExpr="Next Counting Start Date" }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver sludatoen for den n‘ste opt‘llingsperiode.;
                           ENU=Specifies the ending date of the next counting period.];
                ApplicationArea=#Warehouse;
                SourceExpr="Next Counting End Date" }

    { 117 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om lagervaren kan sendes direkte.;
                           ENU=Specifies if the SKU can be cross-docked.];
                ApplicationArea=#Warehouse;
                SourceExpr="Use Cross-Docking" }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                Visible=TRUE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      InvtSetup@1000 : Record 313;
      Item@1001 : Record 27;
      ItemAvailFormsMgt@1002 : Codeunit 353;
      TimeBucketEnable@19054765 : Boolean INDATASET;
      SafetyLeadTimeEnable@19079647 : Boolean INDATASET;
      SafetyStockQtyEnable@19036196 : Boolean INDATASET;
      ReorderPointEnable@19067744 : Boolean INDATASET;
      ReorderQtyEnable@19013534 : Boolean INDATASET;
      MaximumInventoryEnable@19059424 : Boolean INDATASET;
      MinimumOrderQtyEnable@19021857 : Boolean INDATASET;
      MaximumOrderQtyEnable@19007977 : Boolean INDATASET;
      OrderMultipleEnable@19004365 : Boolean INDATASET;
      IncludeInventoryEnable@19061544 : Boolean INDATASET;
      ReschedulingPeriodEnable@19049766 : Boolean INDATASET;
      LotAccumulationPeriodEnable@19019376 : Boolean INDATASET;
      DampenerPeriodEnable@19045210 : Boolean INDATASET;
      DampenerQtyEnable@19051814 : Boolean INDATASET;
      OverflowLevelEnable@19033283 : Boolean INDATASET;
      StandardCostEnable@19016419 : Boolean INDATASET;
      UnitCostEnable@19054429 : Boolean INDATASET;

    LOCAL PROCEDURE EnablePlanningControls@1();
    VAR
      PlanningGetParam@1000 : Codeunit 99000855;
      TimeBucketEnabled@1010 : Boolean;
      SafetyLeadTimeEnabled@1009 : Boolean;
      SafetyStockQtyEnabled@1008 : Boolean;
      ReorderPointEnabled@1007 : Boolean;
      ReorderQtyEnabled@1006 : Boolean;
      MaximumInventoryEnabled@1005 : Boolean;
      MinimumOrderQtyEnabled@1004 : Boolean;
      MaximumOrderQtyEnabled@1003 : Boolean;
      OrderMultipleEnabled@1002 : Boolean;
      IncludeInventoryEnabled@1001 : Boolean;
      ReschedulingPeriodEnabled@1015 : Boolean;
      LotAccumulationPeriodEnabled@1014 : Boolean;
      DampenerPeriodEnabled@1013 : Boolean;
      DampenerQtyEnabled@1012 : Boolean;
      OverflowLevelEnabled@1011 : Boolean;
    BEGIN
      PlanningGetParam.SetUpPlanningControls("Reordering Policy","Include Inventory",
        TimeBucketEnabled,SafetyLeadTimeEnabled,SafetyStockQtyEnabled,
        ReorderPointEnabled,ReorderQtyEnabled,MaximumInventoryEnabled,
        MinimumOrderQtyEnabled,MaximumOrderQtyEnabled,OrderMultipleEnabled,IncludeInventoryEnabled,
        ReschedulingPeriodEnabled,LotAccumulationPeriodEnabled,
        DampenerPeriodEnabled,DampenerQtyEnabled,OverflowLevelEnabled);

      TimeBucketEnable := TimeBucketEnabled;
      SafetyLeadTimeEnable := SafetyLeadTimeEnabled;
      SafetyStockQtyEnable := SafetyStockQtyEnabled;
      ReorderPointEnable := ReorderPointEnabled;
      ReorderQtyEnable := ReorderQtyEnabled;
      MaximumInventoryEnable := MaximumInventoryEnabled;
      MinimumOrderQtyEnable := MinimumOrderQtyEnabled;
      MaximumOrderQtyEnable := MaximumOrderQtyEnabled;
      OrderMultipleEnable := OrderMultipleEnabled;
      IncludeInventoryEnable := IncludeInventoryEnabled;
      ReschedulingPeriodEnable := ReschedulingPeriodEnabled;
      LotAccumulationPeriodEnable := LotAccumulationPeriodEnabled;
      DampenerPeriodEnable := DampenerPeriodEnabled;
      DampenerQtyEnable := DampenerQtyEnabled;
      OverflowLevelEnable := OverflowLevelEnabled;
    END;

    LOCAL PROCEDURE EnableCostingControls@3();
    BEGIN
      StandardCostEnable := Item."Costing Method" = Item."Costing Method"::Standard;
      UnitCostEnable := Item."Costing Method" <> Item."Costing Method"::Standard;
    END;

    BEGIN
    END.
  }
}

