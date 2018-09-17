OBJECT Page 5980 Service Item Card
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Serviceartikelkort;
               ENU=Service Item Card];
    SourceTable=Table5940;
    PageType=Card;
    OnAfterGetRecord=BEGIN
                       UpdateShipToCode;
                     END;

    OnInsertRecord=BEGIN
                     IF "Item No." = '' THEN
                       IF GETFILTER("Item No.") <> '' THEN
                         IF GETRANGEMIN("Item No.") = GETRANGEMAX("Item No.") THEN
                           "Item No." := GETRANGEMIN("Item No.");

                     IF "Customer No." = '' THEN
                       IF GETFILTER("Customer No.") <> '' THEN
                         IF GETRANGEMIN("Customer No.") = GETRANGEMAX("Customer No.") THEN
                           "Customer No." := GETRANGEMIN("Customer No.");
                   END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 105     ;1   ;ActionGroup;
                      CaptionML=[DAN=&Serviceartikel;
                                 ENU=&Service Item];
                      Image=ServiceItem }
      { 34      ;2   ;Action    ;
                      CaptionML=[DAN=&Komponenter;
                                 ENU=&Components];
                      ToolTipML=[DAN=Vis komponenter, der bruges i serviceartiklen.;
                                 ENU=View components that are used in the service item.];
                      ApplicationArea=#Service;
                      RunObject=Page 5986;
                      RunPageView=SORTING(Active,Parent Service Item No.,Line No.);
                      RunPageLink=Active=CONST(Yes),
                                  Parent Service Item No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Components;
                      PromotedCategory=Process }
      { 129     ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=&Dimensioner;
                                 ENU=&Dimensions];
                      ToolTipML=[DAN=FÜ vist eller rediger dimensioner som f.eks. omrÜde, projekt eller afdeling, som du kan tildele til kladdelinjer for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to journal lines to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      RunObject=Page 540;
                      RunPageLink=Table ID=CONST(5940),
                                  No.=FIELD(No.);
                      Image=Dimensions }
      { 90      ;2   ;ActionGroup;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      Image=Statistics }
      { 39      ;3   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=FÜ vist statistiske oplysninger om recorden, f.eks. vërdien af bogfõrte poster.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Service;
                      RunObject=Page 5982;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 52      ;3   ;Action    ;
                      CaptionML=[DAN=Tr&endscape;
                                 ENU=Tr&endscape];
                      ToolTipML=[DAN=Vis en detaljeret oversigt over serviceartikeltransaktioner sortert efter tidsintervaller.;
                                 ENU=View a detailed account of service item transactions by time intervals.];
                      ApplicationArea=#Service;
                      RunObject=Page 5983;
                      RunPageLink=No.=FIELD(No.);
                      Image=Trendscape }
      { 7       ;2   ;ActionGroup;
                      CaptionML=[DAN=Fejlfinding;
                                 ENU=Troubleshooting];
                      Image=Troubleshoot }
      { 42      ;3   ;Action    ;
                      CaptionML=[DAN=Opsëtning af fejlfinding;
                                 ENU=Troubleshooting Setup];
                      ToolTipML=[DAN=Vis eller rediger indstillingerne for fejlfinding til serviceartikler.;
                                 ENU=View or edit your settings for troubleshooting service items.];
                      ApplicationArea=#Service;
                      RunObject=Page 5993;
                      RunPageLink=Type=CONST(Service Item),
                                  No.=FIELD(No.);
                      Image=Troubleshoot }
      { 3       ;3   ;Action    ;
                      Name=<Page Troubleshooting>;
                      CaptionML=[DAN=Fejlfinding;
                                 ENU=Troubleshooting];
                      ToolTipML=[DAN=Vis eller rediger oplysninger om tekniske problemer med en serviceartikel.;
                                 ENU=View or edit information about technical problems with a service item.];
                      ApplicationArea=#Service;
                      Image=Troubleshoot;
                      OnAction=VAR
                                 TroubleshootingHeader@1000 : Record 5943;
                               BEGIN
                                 TroubleshootingHeader.ShowForServItem(Rec);
                               END;
                                }
      { 120     ;2   ;Action    ;
                      CaptionML=[DAN=Ressourcekvalifikationer;
                                 ENU=Resource Skills];
                      ToolTipML=[DAN=Vis tildelingen af kvalifikationer til ressourcer, varer, serviceartikelgrupper og serviceartikler. Du kan bruge kvalifikationskoderne til at allokere kvalificerede ressourcer til serviceartikler eller varer, hvor der ved reparation krëves specialviden.;
                                 ENU=View the assignment of skills to resources, items, service item groups, and service items. You can use skill codes to allocate skilled resources to service items or items that need special skills for servicing.];
                      ApplicationArea=#Service;
                      RunObject=Page 6019;
                      RunPageLink=Type=CONST(Service Item),
                                  No.=FIELD(No.);
                      Image=ResourceSkills }
      { 121     ;2   ;Action    ;
                      CaptionML=[DAN=Kva&l. ressourcer;
                                 ENU=S&killed Resources];
                      ToolTipML=[DAN=Vis listen over ressourcer, der har de nõdvendige kvalifikationer til at hÜndtere serviceartikler.;
                                 ENU=View the list of resources that have the skills required to handle service items.];
                      ApplicationArea=#Service;
                      Image=ResourceSkills;
                      OnAction=BEGIN
                                 CLEAR(SkilledResourceList);
                                 SkilledResourceList.Initialize(ResourceSkill.Type::"Service Item","No.",Description);
                                 SkilledResourceList.RUNMODAL;
                               END;
                                }
      { 18      ;2   ;Action    ;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Service;
                      RunObject=Page 5911;
                      RunPageLink=Table Name=CONST(Service Item),
                                  Table Subtype=CONST(0),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 11      ;1   ;ActionGroup;
                      CaptionML=[DAN=Dokumenter;
                                 ENU=Documents];
                      Image=Documents }
      { 122     ;2   ;ActionGroup;
                      CaptionML=[DAN=S&erviceordrer;
                                 ENU=S&ervice Orders];
                      Image=Order }
      { 125     ;3   ;Action    ;
                      CaptionML=[DAN=Ser&v.art.linjer;
                                 ENU=&Item Lines];
                      ToolTipML=[DAN="Vis igangvërende serviceartikellinjer for varen. ";
                                 ENU="View ongoing service item lines for the item. "];
                      ApplicationArea=#Service;
                      RunObject=Page 5903;
                      RunPageView=SORTING(Service Item No.);
                      RunPageLink=Service Item No.=FIELD(No.);
                      Image=ItemLines }
      { 134     ;3   ;Action    ;
                      CaptionML=[DAN=&Servicelinjer;
                                 ENU=&Service Lines];
                      ToolTipML=[DAN=Vis igangvërende servicelinjer for varen.;
                                 ENU=View ongoing service lines for the item.];
                      ApplicationArea=#Service;
                      RunObject=Page 5904;
                      RunPageView=SORTING(Service Item No.);
                      RunPageLink=Service Item No.=FIELD(No.);
                      Image=ServiceLines }
      { 89      ;2   ;ActionGroup;
                      CaptionML=[DAN=Ser&viceleverancer;
                                 ENU=Service Shi&pments];
                      Image=Shipment }
      { 117     ;3   ;Action    ;
                      CaptionML=[DAN=Ser&v.art.linjer;
                                 ENU=&Item Lines];
                      ToolTipML=[DAN="Vis igangvërende serviceartikellinjer for varen. ";
                                 ENU="View ongoing service item lines for the item. "];
                      ApplicationArea=#Service;
                      RunObject=Page 5950;
                      RunPageView=SORTING(Service Item No.);
                      RunPageLink=Service Item No.=FIELD(No.);
                      Image=ItemLines }
      { 113     ;3   ;Action    ;
                      CaptionML=[DAN=&Servicelinjer;
                                 ENU=&Service Lines];
                      ToolTipML=[DAN=Vis igangvërende servicelinjer for varen.;
                                 ENU=View ongoing service lines for the item.];
                      ApplicationArea=#Service;
                      RunObject=Page 5949;
                      RunPageView=SORTING(Service Item No.);
                      RunPageLink=Service Item No.=FIELD(No.);
                      Image=ServiceLines }
      { 36      ;2   ;Action    ;
                      CaptionML=[DAN=Ser&vicekontrakter;
                                 ENU=Ser&vice Contracts];
                      ToolTipML=[DAN=èbn oversigten over igangvërende servicekontrakter.;
                                 ENU=Open the list of ongoing service contracts.];
                      ApplicationArea=#Service;
                      RunObject=Page 6075;
                      RunPageView=SORTING(Service Item No.,Contract Status);
                      RunPageLink=Service Item No.=FIELD(No.);
                      Promoted=Yes;
                      Image=ServiceAgreement;
                      PromotedCategory=Process }
      { 13      ;1   ;ActionGroup;
                      CaptionML=[DAN=Oversigt;
                                 ENU=History];
                      Image=History }
      { 38      ;2   ;Action    ;
                      CaptionML=[DAN=Service&artikellog;
                                 ENU=Service Item Lo&g];
                      ToolTipML=[DAN=FÜ vist en liste over de ëndringer i servicedokumentet, der er registreret. I programmet oprettes der poster i vinduet, f.eks. nÜr svartiden eller serviceordrens status er ëndret, en ressource er allokeret, en serviceordre er leveret eller faktureret osv. Hver linje i vinduet identificerer den hëndelse, der er forekommet i servicedokumentet. Linjen indeholder oplysninger om det felt, der er ëndret, dets gamle og nye vërdi, datoen og tidspunktet for, hvornÜr ëndringen fandt sted, og id'et for den bruger, som foretog ëndringerne.;
                                 ENU=View a list of the service document changes that have been logged. The program creates entries in the window when, for example, the response time or service order status changed, a resource was allocated, a service order was shipped or invoiced, and so on. Each line in this window identifies the event that occurred to the service document. The line contains the information about the field that was changed, its old and new value, the date and time when the change took place, and the ID of the user who actually made the changes.];
                      ApplicationArea=#Service;
                      RunObject=Page 5989;
                      RunPageLink=Service Item No.=FIELD(No.);
                      Image=Log }
      { 40      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=Service&poster;
                                 ENU=Service Ledger E&ntries];
                      ToolTipML=[DAN=Vis alle poster for den serviceartikel eller serviceordre, der stammer fra bogfõringstransaktioner i servicedokumenter.;
                                 ENU=View all the ledger entries for the service item or service order that result from posting transactions in service documents.];
                      ApplicationArea=#Service;
                      RunObject=Page 5912;
                      RunPageView=SORTING(Service Item No. (Serviced),Entry Type,Moved from Prepaid Acc.,Type,Posting Date);
                      RunPageLink=Service Item No. (Serviced)=FIELD(No.),
                                  Service Order No.=FIELD(Service Order Filter),
                                  Service Contract No.=FIELD(Contract Filter),
                                  Posting Date=FIELD(Date Filter);
                      Image=ServiceLedger }
      { 8       ;2   ;Action    ;
                      CaptionML=[DAN=&Garantiposter;
                                 ENU=&Warranty Ledger Entries];
                      ToolTipML=[DAN=Vis alle poster for den serviceartikel eller serviceordre, der stammer fra bogfõringstransaktioner i servicedokumenter, der indeholder garantiaftaler.;
                                 ENU=View all the ledger entries for the service item or service order that result from posting transactions in service documents that contain warranty agreements.];
                      ApplicationArea=#Service;
                      RunObject=Page 5913;
                      RunPageView=SORTING(Service Item No. (Serviced),Posting Date,Document No.);
                      RunPageLink=Service Item No. (Serviced)=FIELD(No.);
                      Image=WarrantyLedger }
      { 1900000005;  ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 5       ;1   ;ActionGroup;
                      CaptionML=[DAN=Ny;
                                 ENU=New];
                      Image=NewItem }
      { 1900294905;2 ;Action    ;
                      CaptionML=[DAN=Ny vare;
                                 ENU=New Item];
                      ToolTipML=[DAN=Opret et varekort, der er baseret pÜ lagervaren.;
                                 ENU=Create an item card based on the stockkeeping unit.];
                      ApplicationArea=#Service;
                      RunObject=Page 30;
                      Promoted=Yes;
                      Image=NewItem;
                      PromotedCategory=New;
                      RunPageMode=Create }
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 1901712706;1 ;Action    ;
                      CaptionML=[DAN=Serviceart.linje - etiket;
                                 ENU=Service Line Item Label];
                      ToolTipML=[DAN=Vis oversigten over serviceartikler i serviceordrer. Rapporten viser ordrenummer, serviceartikelnummer, serienummer og navnet pÜ varen.;
                                 ENU=View the list of service items on service orders. The report shows the order number, service item number, serial number, and the name of the item.];
                      ApplicationArea=#Service;
                      RunObject=Report 5901;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General];
                GroupType=Group }

    { 43  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Service;
                SourceExpr="No.";
                Importance=Promoted;
                OnAssistEdit=BEGIN
                               IF AssistEdit(xRec) THEN
                                 CurrPage.UPDATE;
                             END;
                              }

    { 98  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af varen.;
                           ENU=Specifies a description of this item.];
                ApplicationArea=#Service;
                SourceExpr=Description;
                Importance=Promoted }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det varenummer, som er knyttet til serviceartiklen.;
                           ENU=Specifies the item number linked to the service item.];
                ApplicationArea=#Service;
                SourceExpr="Item No.";
                Importance=Promoted;
                OnValidate=BEGIN
                             CALCFIELDS("Item Description");
                           END;
                            }

    { 12  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver beskrivelsen af den vare, som serviceartiklen er tilknyttet.;
                           ENU=Specifies the description of the item that the service item is linked to.];
                ApplicationArea=#Service;
                SourceExpr="Item Description" }

    { 41  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den serviceartikelgruppe, som er knyttet til varen.;
                           ENU=Specifies the code of the service item group associated with this item.];
                ApplicationArea=#Service;
                SourceExpr="Service Item Group Code" }

    { 37  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den serviceprisgruppe, som er knyttet til denne vare.;
                           ENU=Specifies the code of the Service Price Group associated with this item.];
                ApplicationArea=#Service;
                SourceExpr="Service Price Group Code" }

    { 91  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant pÜ linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code" }

    { 2   ;2   ;Field     ;
                AssistEdit=Yes;
                ToolTipML=[DAN=Angiver serienummeret pÜ varen.;
                           ENU=Specifies the serial number of this item.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Serial No.";
                OnAssistEdit=VAR
                               ItemLedgerEntry@1000 : Record 32;
                             BEGIN
                               CLEAR(ItemLedgerEntry);
                               ItemLedgerEntry.FILTERGROUP(2);
                               ItemLedgerEntry.SETRANGE("Item No.","Item No.");
                               IF "Variant Code" <> '' THEN
                                 ItemLedgerEntry.SETRANGE("Variant Code","Variant Code");
                               ItemLedgerEntry.SETFILTER("Serial No.",'<>%1','');
                               ItemLedgerEntry.FILTERGROUP(0);

                               IF PAGE.RUNMODAL(0,ItemLedgerEntry) = ACTION::LookupOK THEN
                                 VALIDATE("Serial No.",ItemLedgerEntry."Serial No.");
                             END;
                              }

    { 114 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver statussen for serviceartiklen.;
                           ENU=Specifies the status of the service item.];
                ApplicationArea=#Service;
                SourceExpr=Status;
                Importance=Promoted }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at der er en komponent til serviceartiklen.;
                           ENU=Specifies that there is a component for this service item.];
                ApplicationArea=#Service;
                SourceExpr="Service Item Components" }

    { 65  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en alternativ beskrivelse til sõgning efter serviceartiklen.;
                           ENU=Specifies an alternate description to search for the service item.];
                ApplicationArea=#Service;
                SourceExpr="Search Description" }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det anslÜede antal timer, der er nõdvendigt, fõr servicen kan pÜbegyndes.;
                           ENU=Specifies the estimated number of hours this item requires before service on it should be started.];
                ApplicationArea=#Service;
                SourceExpr="Response Time (Hours)" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver serviceprioriteten for varen.;
                           ENU=Specifies the service priority for this item.];
                ApplicationArea=#Service;
                SourceExpr=Priority }

    { 53  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver datoen for den sidste service pÜ varen.;
                           ENU=Specifies the date of the last service on this item.];
                ApplicationArea=#Service;
                SourceExpr="Last Service Date";
                Editable=FALSE }

    { 63  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startdatoen for reservedelsgarantien for varen.;
                           ENU=Specifies the starting date of the spare parts warranty for this item.];
                ApplicationArea=#Service;
                SourceExpr="Warranty Starting Date (Parts)" }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver slutdatoen for reservedelsgarantien for varen.;
                           ENU=Specifies the ending date of the spare parts warranty for this item.];
                ApplicationArea=#Service;
                SourceExpr="Warranty Ending Date (Parts)" }

    { 67  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den procentdel af reservedelsomkostningerne, der dëkkes af garantien for varen.;
                           ENU=Specifies the percentage of spare parts costs covered by the warranty for the item.];
                ApplicationArea=#Service;
                SourceExpr="Warranty % (Parts)" }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startdatoen for arbejdsgarantien for varen.;
                           ENU=Specifies the starting date of the labor warranty for this item.];
                ApplicationArea=#Service;
                SourceExpr="Warranty Starting Date (Labor)" }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver slutdatoen for arbejdsgarantien for varen.;
                           ENU=Specifies the ending date of the labor warranty for this item.];
                ApplicationArea=#Service;
                SourceExpr="Warranty Ending Date (Labor)" }

    { 75  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den procentdel af arbejdsomkostningerne, der dëkkes af garantien for varen.;
                           ENU=Specifies the percentage of labor costs covered by the warranty for this item.];
                ApplicationArea=#Service;
                SourceExpr="Warranty % (Labor)" }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den ressource, som debitoren foretrëkker ved reparation af varen.;
                           ENU=Specifies the number of the resource that the customer prefers for servicing of the item.];
                ApplicationArea=#Service;
                SourceExpr="Preferred Resource" }

    { 1903289601;1;Group  ;
                CaptionML=[DAN=Debitor;
                           ENU=Customer] }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den debitor, som ejer varen.;
                           ENU=Specifies the number of the customer who owns this item.];
                ApplicationArea=#Service;
                SourceExpr="Customer No.";
                Importance=Promoted;
                OnValidate=BEGIN
                             CALCFIELDS(Name,"Name 2",Address,"Address 2","Post Code",
                               City,Contact,"Phone No.",County,"Country/Region Code");
                             CustomerNoOnAfterValidate;
                           END;
                            }

    { 6   ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver navnet pÜ den debitor, som ejer varen.;
                           ENU=Specifies the name of the customer who owns this item.];
                ApplicationArea=#Service;
                SourceExpr=Name;
                Importance=Promoted }

    { 72  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver adressen pÜ den debitor, som ejer varen.;
                           ENU=Specifies the address of the customer who owns this item.];
                ApplicationArea=#Service;
                SourceExpr=Address }

    { 84  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Service;
                SourceExpr="Address 2" }

    { 86  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver postnummeret.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Service;
                SourceExpr="Post Code" }

    { 88  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver byen i debitorens adresse.;
                           ENU=Specifies the city of the customer address.];
                ApplicationArea=#Service;
                SourceExpr=City }

    { 109 ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver navnet pÜ den faste kontaktperson, du benytter, nÜr du handler med debitoren, som ejer varen.;
                           ENU=Specifies the name of the person you regularly contact when you do business with the customer who owns this item.];
                ApplicationArea=#Service;
                SourceExpr=Contact;
                Importance=Promoted }

    { 92  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver debitorens telefonnummer.;
                           ENU=Specifies the customer phone number.];
                ApplicationArea=#Service;
                SourceExpr="Phone No." }

    { 78  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver lokationskoden for varen.;
                           ENU=Specifies the code of the location of this item.];
                ApplicationArea=#Location;
                SourceExpr="Location of Service Item";
                Importance=Promoted }

    { 1906801201;1;Group  ;
                CaptionML=[DAN=Levering;
                           ENU=Shipping] }

    { 102 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for en alternativ leveringsadresse, hvis du vil sende til en anden adresse end den, der er indsat automatisk. Dette felt bruges ogsÜ i tilfëlde af direkte levering.;
                           ENU=Specifies a code for an alternate shipment address if you want to ship to another address than the one that has been entered automatically. This field is also used in case of drop shipment.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Code";
                Importance=Promoted;
                OnValidate=BEGIN
                             UpdateShipToCode;
                           END;
                            }

    { 94  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver navnet pÜ debitoren pÜ den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the customer at the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Name" }

    { 96  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver den adresse, som varerne leveres til.;
                           ENU=Specifies the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Address" }

    { 100 ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver en supplerende del af leveringsadressen, hvis det er en lang adresse.;
                           ENU=Specifies an additional part of the ship-to address, in case it is a long address.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Address 2" }

    { 151 ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver postnummeret pÜ den adresse, som varerne leveres til.;
                           ENU=Specifies the postal code of the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Post Code";
                Importance=Promoted }

    { 159 ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver byen i den adresse, som varerne leveres til.;
                           ENU=Specifies the city of the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to City" }

    { 106 ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver navnet pÜ kontaktpersonen pÜ den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the contact person at the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Contact";
                Importance=Promoted }

    { 111 ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver telefonnummeret pÜ den adresse, som varerne leveres til.;
                           ENU=Specifies the phone number at address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Phone No." }

    { 1900776401;1;Group  ;
                CaptionML=[DAN=Kontrakt;
                           ENU=Contract] }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver standardkontraktkostprisen pÜ en serviceartikel, der pÜ et senere tidspunkt tages med i en servicekontrakt eller et kontrakttilbud.;
                           ENU=Specifies the default contract cost of a service item that later will be included in a service contract or contract quote.];
                ApplicationArea=#Service;
                SourceExpr="Default Contract Cost" }

    { 47  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver standardkontraktvërdien pÜ en vare, der pÜ et senere tidspunkt tages med i en servicekontrakt eller et kontrakttilbud.;
                           ENU=Specifies the default contract value of an item that later will be included in a service contract or contract quote.];
                ApplicationArea=#Service;
                SourceExpr="Default Contract Value" }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en standardkontraktrabatprocent for en vare, hvis den er en del af servicekontrakten.;
                           ENU=Specifies a default contract discount percentage for an item, if this item will be part of a service contract.];
                ApplicationArea=#Service;
                SourceExpr="Default Contract Discount %" }

    { 80  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at serviceartiklen er tilknyttet en eller flere servicekontrakter eller -tilbud.;
                           ENU=Specifies that this service item is associated with one or more service contracts/quotes.];
                ApplicationArea=#Service;
                SourceExpr="Service Contracts" }

    { 1901061301;1;Group  ;
                CaptionML=[DAN=Kreditor;
                           ENU=Vendor] }

    { 68  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ kreditoren for varen.;
                           ENU=Specifies the number of the vendor for this item.];
                ApplicationArea=#Service;
                SourceExpr="Vendor No.";
                OnValidate=BEGIN
                             CALCFIELDS("Vendor Name");
                           END;
                            }

    { 70  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver kreditornavnet for varen.;
                           ENU=Specifies the vendor name for this item.];
                ApplicationArea=#Service;
                SourceExpr="Vendor Name" }

    { 82  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det nummer, som kreditoren bruger til denne vare.;
                           ENU=Specifies the number that the vendor uses for this item.];
                ApplicationArea=#Service;
                SourceExpr="Vendor Item No." }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det navn, som varen er blevet tildelt af kreditoren.;
                           ENU=Specifies the name assigned to this item by the vendor.];
                ApplicationArea=#Service;
                SourceExpr="Vendor Item Name" }

    { 1906484701;1;Group  ;
                CaptionML=[DAN=Detaljer;
                           ENU=Detail] }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kostprisen for varen, da den blev solgt.;
                           ENU=Specifies the unit cost of this item when it was sold.];
                ApplicationArea=#Service;
                SourceExpr="Sales Unit Cost" }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver enhedsprisen for varen, da den blev solgt.;
                           ENU=Specifies the unit price of this item when it was sold.];
                ApplicationArea=#Service;
                SourceExpr="Sales Unit Price" }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor varen blev solgt.;
                           ENU=Specifies the date when this item was sold.];
                ApplicationArea=#Service;
                SourceExpr="Sales Date" }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen mÜles, f.eks. i enheder eller timer. Som standard indsëttes vërdien i feltet Basisenhed pÜ kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Service;
                SourceExpr="Unit of Measure Code" }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor varen blev installeret pÜ debitorens adresse.;
                           ENU=Specifies the date when this item was installed at the customer's site.];
                ApplicationArea=#Service;
                SourceExpr="Installation Date" }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1900316107;1;Part   ;
                ApplicationArea=#Service;
                SubPageLink=No.=FIELD(Customer No.),
                            Date Filter=FIELD(Date Filter);
                PagePartID=Page9084;
                Visible=TRUE;
                PartType=Page }

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
      ResourceSkill@1003 : Record 5956;
      SkilledResourceList@1006 : Page 6023;

    LOCAL PROCEDURE UpdateShipToCode@1();
    BEGIN
      IF "Ship-to Code" = '' THEN BEGIN
        "Ship-to Name" := Name;
        "Ship-to Address" := Address;
        "Ship-to Address 2" := "Address 2";
        "Ship-to Post Code" := "Post Code";
        "Ship-to City" := City;
        "Ship-to Phone No." := "Phone No.";
        "Ship-to Contact" := Contact;
      END ELSE
        CALCFIELDS(
          "Ship-to Name","Ship-to Name 2","Ship-to Address","Ship-to Address 2","Ship-to Post Code","Ship-to City",
          "Ship-to County","Ship-to Country/Region Code","Ship-to Contact","Ship-to Phone No.");
    END;

    LOCAL PROCEDURE CustomerNoOnAfterValidate@19016267();
    BEGIN
      IF "Customer No." <> xRec."Customer No." THEN
        UpdateShipToCode;
    END;

    BEGIN
    END.
  }
}

