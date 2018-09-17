OBJECT Page 5703 Location Card
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Lokationskort;
               ENU=Location Card];
    SourceTable=Table14;
    PageType=Card;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Lokation;
                                ENU=New,Process,Report,Location];
    OnInit=BEGIN
             UseCrossDockingEnable := TRUE;
             UsePutAwayWorksheetEnable := TRUE;
             BinMandatoryEnable := TRUE;
             RequireShipmentEnable := TRUE;
             RequireReceiveEnable := TRUE;
             RequirePutAwayEnable := TRUE;
             RequirePickEnable := TRUE;
             DefaultBinSelectionEnable := TRUE;
             UseADCSEnable := TRUE;
             DirectedPutawayandPickEnable := TRUE;
             CrossDockBinCodeEnable := TRUE;
             PickAccordingToFEFOEnable := TRUE;
             AdjustmentBinCodeEnable := TRUE;
             ShipmentBinCodeEnable := TRUE;
             ReceiptBinCodeEnable := TRUE;
             FromProductionBinCodeEnable := TRUE;
             ToProductionBinCodeEnable := TRUE;
             OpenShopFloorBinCodeEnable := TRUE;
             ToAssemblyBinCodeEnable := TRUE;
             FromAssemblyBinCodeEnable := TRUE;
             AssemblyShipmentBinCodeEnable := TRUE;
             CrossDockDueDateCalcEnable := TRUE;
             AlwaysCreatePutawayLineEnable := TRUE;
             AlwaysCreatePickLineEnable := TRUE;
             PutAwayTemplateCodeEnable := TRUE;
             AllowBreakbulkEnable := TRUE;
             SpecialEquipmentEnable := TRUE;
             BinCapacityPolicyEnable := TRUE;
             BaseCalendarCodeEnable := TRUE;
             InboundWhseHandlingTimeEnable := TRUE;
             OutboundWhseHandlingTimeEnable := TRUE;
             EditInTransit := TRUE;
           END;

    OnAfterGetRecord=BEGIN
                       UpdateEnabled;
                       TransitValidation;
                     END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 36      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Lokation;
                                 ENU=&Location];
                      Image=Warehouse }
      { 32      ;2   ;Action    ;
                      CaptionML=[DAN=&Ressourcelokationer;
                                 ENU=&Resource Locations];
                      ToolTipML=[DAN=Vis eller rediger oplysninger om, hvor ressourcerne er placeret. Du kan tildele ressourcer for lokationer i dette vindue.;
                                 ENU=View or edit information about where resources are located. In this window, you can assign resources to locations.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 6015;
                      RunPageLink=Location Code=FIELD(Code);
                      Image=Resource }
      { 11      ;2   ;Action    ;
                      CaptionML=[DAN=Ops‘tning af varebogf›ring;
                                 ENU=Inventory Posting Setup];
                      ToolTipML=[DAN=Ops‘t links mellem varebogf›ringsgrupper, lagerlokationer og finanskonti for at definere, hvor transaktioner for lagervarer registreres i finansbogholderiet.;
                                 ENU=Set up links between inventory posting groups, inventory locations, and general ledger accounts to define where transactions for inventory items are recorded in the general ledger.];
                      ApplicationArea=#Location;
                      RunObject=Page 5826;
                      RunPageLink=Location Code=FIELD(Code);
                      Promoted=Yes;
                      Image=PostedInventoryPick;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes }
      { 7300    ;2   ;Action    ;
                      CaptionML=[DAN=&Zoner;
                                 ENU=&Zones];
                      ToolTipML=[DAN=Vis eller rediger oplysninger om zoner, som du bruger p† lageret til at strukturere dine placeringer under zoner.;
                                 ENU=View or edit information about zones that you use in your warehouse to structure your bins under zones.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7300;
                      RunPageLink=Location Code=FIELD(Code);
                      Promoted=Yes;
                      Image=Zones;
                      PromotedCategory=Process }
      { 7302    ;2   ;Action    ;
                      CaptionML=[DAN=&Placeringer;
                                 ENU=&Bins];
                      ToolTipML=[DAN=Vis eller rediger oplysninger om zoner, som du bruger p† lageret til opbevaring af varer.;
                                 ENU=View or edit information about zones that you use in your warehouse to hold items.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7302;
                      RunPageLink=Location Code=FIELD(Code);
                      Promoted=Yes;
                      Image=Bins;
                      PromotedCategory=Process }
      { 101     ;2   ;Action    ;
                      CaptionML=[DAN=Online Map;
                                 ENU=Online Map];
                      ToolTipML=[DAN=Vis adressen p† et onlinekort.;
                                 ENU=View the address on an online map.];
                      ApplicationArea=#Location;
                      Promoted=Yes;
                      Image=Map;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 DisplayMap;
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
                ToolTipML=[DAN=Angiver en lokationskode for det lagersted eller distributionscenter, hvor varerne bliver h†ndteret og opbevaret, f›r de s‘lges.;
                           ENU=Specifies a location code for the warehouse or distribution center where your items are handled and stored before being sold.];
                ApplicationArea=#Location;
                SourceExpr=Code;
                Importance=Promoted }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet eller adressen p† lokationen.;
                           ENU=Specifies the name or address of the location.];
                ApplicationArea=#Location;
                SourceExpr=Name }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at denne lokation er en transitlokation.;
                           ENU=Specifies that this location is an in-transit location.];
                ApplicationArea=#Location;
                SourceExpr="Use As In-Transit";
                Editable=EditInTransit;
                OnValidate=BEGIN
                             UpdateEnabled;
                           END;
                            }

    { 1902768601;1;Group  ;
                CaptionML=[DAN=Adresse og kontakt;
                           ENU=Address & Contact];
                GroupType=Group }

    { 13  ;2   ;Group     ;
                Name=AddressDetails;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                GroupType=Group }

    { 6   ;3   ;Field     ;
                ToolTipML=[DAN=Angiver lokationsadressen.;
                           ENU=Specifies the location address.];
                ApplicationArea=#Location;
                SourceExpr=Address }

    { 8   ;3   ;Field     ;
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Location;
                SourceExpr="Address 2" }

    { 10  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Location;
                SourceExpr="Post Code" }

    { 35  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver byen for lokationen.;
                           ENU=Specifies the city of the location.];
                ApplicationArea=#Location;
                SourceExpr=City }

    { 14  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver adressens land/omr†de.;
                           ENU=Specifies the country/region of the address.];
                ApplicationArea=#Location;
                SourceExpr="Country/Region Code" }

    { 16  ;3   ;Field     ;
                Name=ShowMap;
                ToolTipML=[DAN=Angiver lokationens adresse p† dit foretrukne kortwebsted.;
                           ENU=Specifies the address of the location on your preferred map website.];
                ApplicationArea=#Location;
                SourceExpr=ShowMapLbl;
                Editable=FALSE;
                Style=StrongAccent;
                StyleExpr=TRUE;
                OnDrillDown=BEGIN
                              CurrPage.UPDATE;
                              DisplayMap;
                            END;

                ShowCaption=No }

    { 15  ;2   ;Group     ;
                Name=ContactDetails;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                GroupType=Group }

    { 12  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† kontaktpersonen p† lokationen.;
                           ENU=Specifies the name of the contact person at the location];
                ApplicationArea=#Location;
                SourceExpr=Contact }

    { 18  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver lokationens telefonnummer.;
                           ENU=Specifies the telephone number of the location.];
                ApplicationArea=#Location;
                SourceExpr="Phone No.";
                Importance=Promoted }

    { 28  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver lokationens faxnummer.;
                           ENU=Specifies the fax number of the location.];
                ApplicationArea=#Advanced;
                SourceExpr="Fax No." }

    { 30  ;3   ;Field     ;
                ExtendedDatatype=E-Mail;
                ToolTipML=[DAN=Angiver lokationens mailadresse.;
                           ENU=Specifies the email address of the location.];
                ApplicationArea=#Location;
                SourceExpr="E-Mail" }

    { 26  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver lokationens websted.;
                           ENU=Specifies the location's web site.];
                ApplicationArea=#Location;
                SourceExpr="Home Page" }

    { 1907509201;1;Group  ;
                CaptionML=[DAN=Lagersted;
                           ENU=Warehouse] }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om lokationen kr‘ver dedikeret lageraktivitet ved modtagelse af varer.;
                           ENU=Specifies if the location requires a dedicated warehouse activity when receiving items.];
                ApplicationArea=#Warehouse;
                SourceExpr="Require Receive";
                Enabled=RequireReceiveEnable;
                OnValidate=BEGIN
                             UpdateEnabled;
                           END;
                            }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om lokationen kr‘ver dedikeret lageraktivitet ved afsendelse af varer.;
                           ENU=Specifies if the location requires a dedicated warehouse activity when shipping items.];
                ApplicationArea=#Warehouse;
                SourceExpr="Require Shipment";
                Enabled=RequireShipmentEnable;
                OnValidate=BEGIN
                             UpdateEnabled;
                           END;
                            }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om lokationen kr‘ver dedikeret lageraktivitet ved lagerl‘gning af varer.;
                           ENU=Specifies if the location requires a dedicated warehouse activity when putting items away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Require Put-away";
                Importance=Promoted;
                Enabled=RequirePutAwayEnable;
                OnValidate=BEGIN
                             UpdateEnabled;
                           END;
                            }

    { 87  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om der skal oprettes l‘g-p†-lager-aktiviteter for bogf›rte lagermodtagelser i l‘g-p†-lager-kladden. Hvis afkrydsningsfeltet ikke er markeret, oprettes l‘g-p†-lager-aktiviteter direkte, n†r du bogf›rer en lagermodtagelse.;
                           ENU=Specifies if put-aways for posted warehouse receipts must be created with the put-away worksheet. If the check box is not selected, put-aways are created directly when you post a warehouse receipt.];
                ApplicationArea=#Warehouse;
                SourceExpr="Use Put-away Worksheet";
                Enabled=UsePutAwayWorksheetEnable }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om lokationen kr‘ver dedikeret lageraktivitet ved plukning af varer.;
                           ENU=Specifies if the location requires a dedicated warehouse activity when picking items.];
                ApplicationArea=#Warehouse;
                SourceExpr="Require Pick";
                Importance=Promoted;
                Enabled=RequirePickEnable;
                OnValidate=BEGIN
                             UpdateEnabled;
                           END;
                            }

    { 78  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om lokationen kr‘ver, at der specificeres en placeringskode for alle varetransaktioner.;
                           ENU=Specifies if the location requires that a bin code is specified on all item transactions.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Mandatory";
                Importance=Promoted;
                Enabled=BinMandatoryEnable;
                OnValidate=BEGIN
                             UpdateEnabled;
                           END;
                            }

    { 90  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om lokationen kr‘ver avanceret lagerfunktionalitet, f.eks. beregnet placeringsforslag.;
                           ENU=Specifies if the location requires advanced warehouse functionality, such as calculated bin suggestion.];
                ApplicationArea=#Warehouse;
                SourceExpr="Directed Put-away and Pick";
                Enabled=DirectedPutawayandPickEnable;
                OnValidate=BEGIN
                             UpdateEnabled;
                           END;
                            }

    { 45  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det ADSC-system (Automatic Data Capture System), som lagermedarbejderne skal bruge til at holde styr p† varer p† lagerstedet.;
                           ENU=Specifies the automatic data capture system that warehouse employees must use to keep track of items within the warehouse.];
                ApplicationArea=#Warehouse;
                SourceExpr="Use ADCS";
                Enabled=UseADCSEnable }

    { 82  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den metode, der er bruget til at v‘lge standardplacering.;
                           ENU=Specifies the method used to select the default bin.];
                ApplicationArea=#Warehouse;
                SourceExpr="Default Bin Selection";
                Enabled=DefaultBinSelectionEnable }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN="Angiver en datoformel for den tid, det tager at g›re varerne klar til forsendelse fra denne lokation. Tidselementet anvendes ved beregning af leveringsdatoen p† f›lgende m†de: Afsendelsesdato + Udg†ende lagerekspeditionstid = Planlagt afsendelsesdato + Transporttid = Planlagt leveringsdato.";
                           ENU="Specifies a date formula for the time it takes to get items ready to ship from this location. The time element is used in the calculation of the delivery date as follows: Shipment Date + Outbound Warehouse Handling Time = Planned Shipment Date + Shipping Time = Planned Delivery Date."];
                ApplicationArea=#Warehouse;
                SourceExpr="Outbound Whse. Handling Time";
                Enabled=OutboundWhseHandlingTimeEnable }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den tid, det tager at g›re varer tilg‘ngelige fra lageret, efter varerne er bogf›rt som modtaget.;
                           ENU=Specifies the time it takes to make items part of available inventory, after the items have been posted as received.];
                ApplicationArea=#Warehouse;
                SourceExpr="Inbound Whse. Handling Time";
                Enabled=InboundWhseHandlingTimeEnable }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en redigerbar planl‘gningskalender, der indeholder lokationens arbejdsdage og fridage.;
                           ENU=Specifies a customizable calendar for planning that holds the location's working days and holidays.];
                ApplicationArea=#Warehouse;
                SourceExpr="Base Calendar Code";
                Enabled=BaseCalendarCodeEnable }

    { 47  ;2   ;Field     ;
                Name=Customized Calendar;
                CaptionML=[DAN=Tilpasset kalender;
                           ENU=Customized Calendar];
                ToolTipML=[DAN=Angiver, om lokationen har en tilpasset kalender med arbejdsdage, der er forskellige fra dem i virksomhedens basiskalender.;
                           ENU=Specifies if the location has a customized calendar with working days that are different from those in the company's base calendar.];
                ApplicationArea=#Warehouse;
                SourceExpr=CalendarMgmt.CustomizedCalendarExistText(CustomizedCalendar."Source Type"::Location,Code,'',"Base Calendar Code");
                Editable=FALSE;
                OnDrillDown=BEGIN
                              CurrPage.SAVERECORD;
                              TESTFIELD("Base Calendar Code");
                              CalendarMgmt.ShowCustomizedCalendar(
                                CustomizedCalEntry."Source Type"::Location,Code,'',"Base Calendar Code");
                            END;
                             }

    { 49  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om lokationen underst›tter flytning af varer direkte fra modtagerdok til afsendelsesdok.;
                           ENU=Specifies if the location supports movement of items directly from the receiving dock to the shipping dock.];
                ApplicationArea=#Warehouse;
                SourceExpr="Use Cross-Docking";
                Enabled=UseCrossDockingEnable;
                OnValidate=BEGIN
                             UpdateEnabled;
                           END;
                            }

    { 55  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beregningen af forfaldsdatoen for direkte afsendelse.;
                           ENU=Specifies the cross-dock due date calculation.];
                ApplicationArea=#Warehouse;
                SourceExpr="Cross-Dock Due Date Calc.";
                Enabled=CrossDockDueDateCalcEnable }

    { 1907883401;1;Group  ;
                CaptionML=[DAN=Placeringer;
                           ENU=Bins] }

    { 100 ;2   ;Group     ;
                CaptionML=[DAN=Modtagelse;
                           ENU=Receipt] }

    { 98  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver standardkoden for modtagelsesplaceringen.;
                           ENU=Specifies the default receipt bin code.];
                ApplicationArea=#Warehouse;
                SourceExpr="Receipt Bin Code";
                Importance=Promoted;
                Enabled=ReceiptBinCodeEnable }

    { 105 ;2   ;Group     ;
                CaptionML=[DAN=Leverance;
                           ENU=Shipment] }

    { 103 ;3   ;Field     ;
                ToolTipML=[DAN=Angiver standardkoden for leveranceplaceringen.;
                           ENU=Specifies the default shipment bin code.];
                ApplicationArea=#Warehouse;
                SourceExpr="Shipment Bin Code";
                Importance=Promoted;
                Enabled=ShipmentBinCodeEnable }

    { 63  ;2   ;Group     ;
                CaptionML=[DAN=Produktion;
                           ENU=Production] }

    { 66  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, der fungerer som standard for †ben produktionsplacering.;
                           ENU=Specifies the bin that functions as the default open shop floor bin.];
                ApplicationArea=#Warehouse;
                SourceExpr="Open Shop Floor Bin Code";
                Enabled=OpenShopFloorBinCodeEnable }

    { 68  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver placeringen i produktionsomr†det, hvor de komponenter, der er plukket til produktion placeres som standard, f›r de kan forbruges.;
                           ENU=Specifies the bin in the production area where components picked for production are placed by default, before they can be consumed.];
                ApplicationArea=#Warehouse;
                SourceExpr="To-Production Bin Code";
                Enabled=ToProductionBinCodeEnable }

    { 72  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver placeringen i produktionsomr†det, hvor f‘rdigvarer tages som standard, n†r processen omfatter lageraktivitet.;
                           ENU=Specifies the bin in the production area, where finished end items are taken from by default, when the process involves warehouse activity.];
                ApplicationArea=#Warehouse;
                SourceExpr="From-Production Bin Code";
                Enabled=FromProductionBinCodeEnable }

    { 58  ;2   ;Group     ;
                CaptionML=[DAN=Regulering;
                           ENU=Adjustment] }

    { 61  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den placering, hvor du registrerer afvigelser i vareantal.;
                           ENU=Specifies the code of the bin in which you record observed differences in inventory quantities.];
                ApplicationArea=#Warehouse;
                SourceExpr="Adjustment Bin Code";
                Enabled=AdjustmentBinCodeEnable }

    { 71  ;2   ;Group     ;
                CaptionML=[DAN=Direkte afsendelse;
                           ENU=Cross-Dock] }

    { 65  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver den placeringskode, der som standard bruges i forbindelse med modtagelse af varer, der skal afsendes direkte.;
                           ENU=Specifies the bin code that is used by default for the receipt of items to be cross-docked.];
                ApplicationArea=#Warehouse;
                SourceExpr="Cross-Dock Bin Code";
                Enabled=CrossDockBinCodeEnable }

    { 3   ;2   ;Group     ;
                Name=Assembly;
                CaptionML=[DAN=Montage;
                           ENU=Assembly];
                GroupType=Group }

    { 7   ;3   ;Field     ;
                ToolTipML=[DAN=Angiver placeringen i montageomr†det, hvor komponenter placeres som standard, f›r de kan forbruges i montagen.;
                           ENU=Specifies the bin in the assembly area where components are placed by default before they can be consumed in assembly.];
                ApplicationArea=#Warehouse;
                SourceExpr="To-Assembly Bin Code";
                Enabled=ToAssemblyBinCodeEnable }

    { 5   ;3   ;Field     ;
                ToolTipML=[DAN=Angiver den placering i montageomr†det, som f‘rdige montageelementer bogf›res p†, n†r de monteres til lager.;
                           ENU=Specifies the bin in the assembly area where finished assembly items are posted to when they are assembled to stock.];
                ApplicationArea=#Warehouse;
                SourceExpr="From-Assembly Bin Code";
                Enabled=FromAssemblyBinCodeEnable }

    { 9   ;3   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, som f‘rdige montageelementer bogf›res p†, n†r de monteres til en tilknyttet salgsordre.;
                           ENU=Specifies the bin where finished assembly items are posted to when they are assembled to a linked sales order.];
                ApplicationArea=#Warehouse;
                SourceExpr="Asm.-to-Order Shpt. Bin Code";
                Enabled=AssemblyShipmentBinCodeEnable }

    { 1905577301;1;Group  ;
                CaptionML=[DAN=Placeringsmetode;
                           ENU=Bin Policies] }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor programmet f›rst skal se efter specialudstyr til lageraktiviteter.;
                           ENU=Specifies where the program will first looks for special equipment designated for warehouse activities.];
                ApplicationArea=#Warehouse;
                SourceExpr="Special Equipment";
                Enabled=SpecialEquipmentEnable }

    { 76  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan placeringer automatisk udfyldes i henhold til deres kapacitet.;
                           ENU=Specifies how bins are automatically filled, according to their capacity.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Capacity Policy";
                Importance=Promoted;
                Enabled=BinCapacityPolicyEnable }

    { 74  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at en ordre kan udf›res med varer lagret i alternative m†leenheder, hvis en vare ikke findes i den ›nskede m†leenhed.;
                           ENU=Specifies that an order can be fulfilled with items stored in alternate units of measure, if an item stored in the requested unit of measure is not found.];
                ApplicationArea=#Warehouse;
                SourceExpr="Allow Breakbulk";
                Enabled=AllowBreakbulkEnable }

    { 84  ;2   ;Group     ;
                CaptionML=[DAN=L‘g-p†-lager;
                           ENU=Put-away] }

    { 85  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver den l‘g-p†-lager-skabelon, der skal benyttes til denne lokation.;
                           ENU=Specifies the put-away template to be used at this location.];
                ApplicationArea=#Warehouse;
                SourceExpr="Put-away Template Code";
                Enabled=PutAwayTemplateCodeEnable }

    { 20  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver, at der oprettes en l‘g-p†-lager-linje, selvom der ikke kan findes en passende zone og placering, som varen kan placeres i.;
                           ENU=Specifies that a put-away line is created, even if an appropriate zone and bin in which to place the items cannot be found.];
                ApplicationArea=#Warehouse;
                SourceExpr="Always Create Put-away Line";
                Enabled=AlwaysCreatePutawayLineEnable }

    { 89  ;2   ;Group     ;
                CaptionML=[DAN=Pluk;
                           ENU=Pick] }

    { 92  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver, at der oprettes en pluklinje, selvom der ikke kan findes en passende zone og placering, som varen kan plukkes fra.;
                           ENU=Specifies that a pick line is created, even if an appropriate zone and bin from which to pick the item cannot be found.];
                ApplicationArea=#Warehouse;
                SourceExpr="Always Create Pick Line";
                Enabled=AlwaysCreatePickLineEnable }

    { 95  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver om FEFO-metoden (First-Expired-First-Out) skal bruges til at bestemme, hvilke varer der skal plukkes if›lge deres udl›bsdatoer.;
                           ENU=Specifies whether to use the First-Expired-First-Out (FEFO) method to determine which items to pick, according to expiration dates.];
                ApplicationArea=#Warehouse;
                SourceExpr="Pick According to FEFO";
                Importance=Promoted;
                Enabled=PickAccordingToFEFOEnable }

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
      CustomizedCalEntry@1002 : Record 7603;
      CustomizedCalendar@1004 : Record 7602;
      CalendarMgmt@1001 : Codeunit 7600;
      OutboundWhseHandlingTimeEnable@19013978 : Boolean INDATASET;
      InboundWhseHandlingTimeEnable@19043763 : Boolean INDATASET;
      BaseCalendarCodeEnable@19028310 : Boolean INDATASET;
      BinCapacityPolicyEnable@19043253 : Boolean INDATASET;
      SpecialEquipmentEnable@19068232 : Boolean INDATASET;
      AllowBreakbulkEnable@19072730 : Boolean INDATASET;
      PutAwayTemplateCodeEnable@19015566 : Boolean INDATASET;
      AlwaysCreatePickLineEnable@19008722 : Boolean INDATASET;
      AlwaysCreatePutawayLineEnable@19036225 : Boolean INDATASET;
      CrossDockDueDateCalcEnable@19016670 : Boolean INDATASET;
      OpenShopFloorBinCodeEnable@19054478 : Boolean INDATASET;
      ToProductionBinCodeEnable@19078604 : Boolean INDATASET;
      FromProductionBinCodeEnable@19048183 : Boolean INDATASET;
      ReceiptBinCodeEnable@19004447 : Boolean INDATASET;
      ShipmentBinCodeEnable@19025907 : Boolean INDATASET;
      AdjustmentBinCodeEnable@19064629 : Boolean INDATASET;
      ToAssemblyBinCodeEnable@1003 : Boolean INDATASET;
      FromAssemblyBinCodeEnable@1000 : Boolean INDATASET;
      AssemblyShipmentBinCodeEnable@1005 : Boolean;
      PickAccordingToFEFOEnable@19053256 : Boolean INDATASET;
      CrossDockBinCodeEnable@19033158 : Boolean INDATASET;
      DirectedPutawayandPickEnable@19066672 : Boolean INDATASET;
      UseADCSEnable@19044183 : Boolean INDATASET;
      DefaultBinSelectionEnable@19026851 : Boolean INDATASET;
      RequirePickEnable@19030451 : Boolean INDATASET;
      RequirePutAwayEnable@19005969 : Boolean INDATASET;
      RequireReceiveEnable@19046465 : Boolean INDATASET;
      RequireShipmentEnable@19000887 : Boolean INDATASET;
      BinMandatoryEnable@19041387 : Boolean INDATASET;
      UsePutAwayWorksheetEnable@19034135 : Boolean INDATASET;
      UseCrossDockingEnable@19061575 : Boolean INDATASET;
      EditInTransit@1101 : Boolean INDATASET;
      ShowMapLbl@1006 : TextConst 'DAN=Vis p† kort;ENU=Show on Map';

    LOCAL PROCEDURE UpdateEnabled@1();
    BEGIN
      RequirePickEnable := NOT "Use As In-Transit" AND NOT "Directed Put-away and Pick";
      RequirePutAwayEnable := NOT "Use As In-Transit" AND NOT "Directed Put-away and Pick";
      RequireReceiveEnable := NOT "Use As In-Transit" AND NOT "Directed Put-away and Pick";
      RequireShipmentEnable := NOT "Use As In-Transit" AND NOT "Directed Put-away and Pick";
      OutboundWhseHandlingTimeEnable := NOT "Use As In-Transit";
      InboundWhseHandlingTimeEnable := NOT "Use As In-Transit";
      BinMandatoryEnable := NOT "Use As In-Transit" AND NOT "Directed Put-away and Pick";
      DirectedPutawayandPickEnable := NOT "Use As In-Transit" AND "Bin Mandatory";
      BaseCalendarCodeEnable := NOT "Use As In-Transit";

      BinCapacityPolicyEnable := "Directed Put-away and Pick";
      SpecialEquipmentEnable := "Directed Put-away and Pick";
      AllowBreakbulkEnable := "Directed Put-away and Pick";
      PutAwayTemplateCodeEnable := "Directed Put-away and Pick";
      UsePutAwayWorksheetEnable :=
        "Directed Put-away and Pick" OR ("Require Put-away" AND "Require Receive" AND NOT "Use As In-Transit");
      AlwaysCreatePickLineEnable := "Directed Put-away and Pick";
      AlwaysCreatePutawayLineEnable := "Directed Put-away and Pick";

      UseCrossDockingEnable := NOT "Use As In-Transit" AND "Require Receive" AND "Require Shipment" AND "Require Put-away" AND
        "Require Pick";
      CrossDockDueDateCalcEnable := "Use Cross-Docking";

      OpenShopFloorBinCodeEnable := "Bin Mandatory";
      ToProductionBinCodeEnable := "Bin Mandatory";
      FromProductionBinCodeEnable := "Bin Mandatory";
      ReceiptBinCodeEnable := "Bin Mandatory" AND "Require Receive";
      ShipmentBinCodeEnable := "Bin Mandatory" AND "Require Shipment";
      AdjustmentBinCodeEnable := "Directed Put-away and Pick";
      CrossDockBinCodeEnable := "Bin Mandatory" AND "Use Cross-Docking";
      ToAssemblyBinCodeEnable := "Bin Mandatory";
      FromAssemblyBinCodeEnable := "Bin Mandatory";
      AssemblyShipmentBinCodeEnable := "Bin Mandatory" AND NOT ShipmentBinCodeEnable;
      DefaultBinSelectionEnable := "Bin Mandatory" AND NOT "Directed Put-away and Pick";
      UseADCSEnable := NOT "Use As In-Transit" AND "Directed Put-away and Pick";
      PickAccordingToFEFOEnable := "Require Pick" AND "Bin Mandatory";
    END;

    LOCAL PROCEDURE TransitValidation@1101();
    VAR
      TransferHeader@1000 : Record 5740;
    BEGIN
      TransferHeader.SETFILTER("In-Transit Code",Code);
      EditInTransit := TransferHeader.ISEMPTY;
    END;

    BEGIN
    END.
  }
}

