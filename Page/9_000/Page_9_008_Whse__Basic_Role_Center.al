OBJECT Page 9008 Whse. Basic Role Center
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    CaptionML=[@@@="{Dependency=Match,""ProfileDescription_SHIPPINGANDRECEIVING""}";
               DAN=Forsendelse og modtagelse - ordre-til-ordre;
               ENU=Shipping and Receiving - Order-by-Order];
    PageType=RoleCenter;
    ActionList=ACTIONS
    {
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 14      ;1   ;Action    ;
                      CaptionML=[DAN=Lager&placeringsoversigt;
                                 ENU=Warehouse &Bin List];
                      ToolTipML=[DAN=F� et overblik over lagerplaceringerne, ops�tningen og antallet af varer p� placeringerne.;
                                 ENU=Get an overview of warehouse bins, their setup, and the quantity of items within the bins.];
                      ApplicationArea=#Warehouse;
                      RunObject=Report 7319;
                      Image=Report }
      { 15      ;1   ;Action    ;
                      CaptionML=[DAN=&Lageropg�relsesoversigt;
                                 ENU=Physical &Inventory List];
                      ToolTipML=[DAN=Vis en fysisk liste over de linjer, du har beregnet i vinduet Lageropg�relseskladde. Du kan bruge denne rapport under den fysiske lageropt�lling til at notere det faktiske antal p� lager og sammenligne antallet med det antal, der er registreret i programmet.;
                                 ENU=View a physical list of the lines that you have calculated in the Phys. Inventory Journal window. You can use this report during the physical inventory count to mark down actual quantities on hand in the warehouse and compare them to what is recorded in the program.];
                      ApplicationArea=#Warehouse;
                      RunObject=Report 722;
                      Image=Report }
      { 50      ;1   ;Action    ;
                      CaptionML=[DAN=Debitor - &etiketter;
                                 ENU=Customer &Labels];
                      ToolTipML=[DAN=Vis, gem eller udskriv etiketter med debitornavn og -adresse. Rapporten kan f.eks. bruges, n�r du udsender salgsbreve.;
                                 ENU=View, save, or print mailing labels with the customers' names and addresses. The report can be used to send sales letters, for example.];
                      ApplicationArea=#Warehouse;
                      RunObject=Report 110;
                      Image=Report }
      { 1900000011;0 ;ActionContainer;
                      ActionContainerType=HomeItems }
      { 47      ;1   ;Action    ;
                      Name=SalesOrders;
                      CaptionML=[DAN=Salgsordrer;
                                 ENU=Sales Orders];
                      ToolTipML=[DAN=Registrer dine aftaler med debitorer for at s�lge bestemte varer p� bestemte leverings- og betalingsbetingelser. Salgsordrer g�r det i mods�tning til salgsfakturaer muligt at levere delvist, levere direkte fra kreditoren til debitoren, starte lagerekspedition og udskrive forskellige dokumenter til kunderne. Salgsfakturering er integreret i salgsordreprocessen.;
                                 ENU=Record your agreements with customers to sell certain products on certain delivery and payment terms. Sales orders, unlike sales invoices, allow you to ship partially, deliver directly from your vendor to your customer, initiate warehouse handling, and print various customer-facing documents. Sales invoicing is integrated in the sales order process.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 9305;
                      Image=Order }
      { 79      ;1   ;Action    ;
                      Name=SalesOrdersReleased;
                      CaptionML=[DAN=Frigivet;
                                 ENU=Released];
                      ToolTipML=[DAN=Vis listen over frigivne kildebilag, som er klar til lageraktiviteter.;
                                 ENU=View the list of released source documents that are ready for warehouse activities.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 9305;
                      RunPageView=WHERE(Status=FILTER(Released)) }
      { 81      ;1   ;Action    ;
                      Name=SalesOrdersPartShipped;
                      CaptionML=[DAN=Delvist leveret;
                                 ENU=Partially Shipped];
                      ToolTipML=[DAN=Vis listen over igangv�rende lagerleverancer, der er delvist fuldf�rt.;
                                 ENU=View the list of ongoing warehouse shipments that are partially completed.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 9305;
                      RunPageView=WHERE(Status=FILTER(Released),
                                        Completely Shipped=FILTER(No)) }
      { 82      ;1   ;Action    ;
                      Name=PurchaseReturnOrders;
                      CaptionML=[DAN=K�bsreturvareordrer;
                                 ENU=Purchase Return Orders];
                      ToolTipML=[DAN=Opret k�bsreturvareordrer for at afspejle de salgsreturbilag, som leverand�rer sender til dig for forkerte eller beskadigede varer, som er blevet betalt og derefter returneret til kreditoren. K�bsreturvareordrer g�r det muligt at returnere varer fra flere k�bsbilag med samme k�bsreturnering og underst�tter lagerbilag for lagerekspeditionen. K�bsreturvareordrer kan oprettes automatisk ud fra PDF- eller billedfiler fra dine kreditorer ved hj�lp af funktionen Indg�ende bilag. Bem�rk: Hvis du endnu ikke har betalt for et fejlbeh�ftet k�b, kan du blot annullere den bogf�rte k�bsfaktura for automatisk at tilbagef�re den �konomiske transaktion.;
                                 ENU=Create purchase return orders to mirror sales return documents that vendors send to you for incorrect or damaged items that you have paid for and then returned to the vendor. Purchase return orders enable you to ship back items from multiple purchase documents with one purchase return and support warehouse documents for the item handling. Purchase return orders can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature. Note: If you have not yet paid for an erroneous purchase, you can simply cancel the posted purchase invoice to automatically revert the financial transaction.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 9311;
                      RunPageView=WHERE(Document Type=FILTER(Return Order)) }
      { 83      ;1   ;Action    ;
                      Name=TransferOrders;
                      CaptionML=[DAN=Overflytningsordrer;
                                 ENU=Transfer Orders];
                      ToolTipML=[DAN=Flyt lagervarer mellem lokationer for virksomheden. Med overflytningsordrer kan du sende udg�ende overflytninger fra �n lokation og modtage den indg�ende overf�rsel p� den anden lokation. Derved kan du administrere de involverede lageraktiviteter, og det �ger sikkerheden for, at vareantallet opdateres korrekt.;
                                 ENU=Move inventory items between company locations. With transfer orders, you ship the outbound transfer from one location and receive the inbound transfer at the other location. This allows you to manage the involved warehouse activities and provides more certainty that inventory quantities are updated correctly.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 5742;
                      Image=Document }
      { 31      ;1   ;Action    ;
                      Name=ReleasedProductionOrders;
                      CaptionML=[DAN=Frigivne produktionsordrer;
                                 ENU=Released Production Orders];
                      ToolTipML=[DAN=Vis listen over frigivne produktionsordrer, som er klar til lageraktiviteter.;
                                 ENU=View the list of released production order that are ready for warehouse activities.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 9326 }
      { 55      ;1   ;Action    ;
                      Name=PurchaseOrders;
                      CaptionML=[DAN=K�bsordrer;
                                 ENU=Purchase Orders];
                      ToolTipML=[DAN=Opret k�bsordrer for at afspejle de salgsbilag, som leverand�rer sender til dig. P� denne m�de kan du registrere k�bsomkostninger og spore kreditorer. Bogf�ringen af k�bsordrer opdaterer lagerniveauerne dynamisk, s� du kan minimere lageromkostningerne og levere bedre kundeservice. K�bsordrer tillader delleverancer, modsat k�bsfakturaer, og muligg�r direkte levering fra kreditoren til debitoren. K�bsordrer kan oprettes automatisk ud fra PDF- eller billedfiler fra dine kreditorer ved hj�lp af funktionen Indg�ende bilag.;
                                 ENU=Create purchase orders to mirror sales documents that vendors send to you. This enables you to record the cost of purchases and to track accounts payable. Posting purchase orders dynamically updates inventory levels so that you can minimize inventory costs and provide better customer service. Purchase orders allow partial receipts, unlike with purchase invoices, and enable drop shipment directly from your vendor to your customer. Purchase orders can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 9307 }
      { 33      ;1   ;Action    ;
                      Name=PurchaseOrdersReleased;
                      CaptionML=[DAN=Frigivet;
                                 ENU=Released];
                      ToolTipML=[DAN=Vis listen over frigivne kildebilag, som er klar til lageraktiviteter.;
                                 ENU=View the list of released source documents that are ready for warehouse activities.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 9307;
                      RunPageView=WHERE(Status=FILTER(Released)) }
      { 34      ;1   ;Action    ;
                      Name=PurchaseOrdersPartReceived;
                      CaptionML=[DAN=Delvist modtaget;
                                 ENU=Partially Received];
                      ToolTipML=[DAN=Vis listen over igangv�rende lagermodtagelser, der er delvist fuldf�rt.;
                                 ENU=View the list of ongoing warehouse receipts that are partially completed.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 9307;
                      RunPageView=WHERE(Status=FILTER(Released),
                                        Completely Received=FILTER(No)) }
      { 16      ;1   ;Action    ;
                      Name=AssemblyOrders;
                      CaptionML=[DAN=Montageordrer;
                                 ENU=Assembly Orders];
                      ToolTipML=[DAN=Vis igangv�rende montageordrer.;
                                 ENU=View ongoing assembly orders.];
                      ApplicationArea=#Assembly;
                      RunObject=Page 902 }
      { 35      ;1   ;Action    ;
                      Name=SalesReturnOrders;
                      CaptionML=[DAN=Salgsreturvareordrer;
                                 ENU=Sales Return Orders];
                      ToolTipML=[DAN=Kompenser dine kunder for forkerte eller beskadigede varer, som du har sendt til dem og modtaget betaling for. Salgsreturvareordrer g�r det muligt at modtage varer fra flere salgsbilag med samme salgsreturnering, automatisk oprette de relaterede salgskreditnotaer eller andre returneringsbilag, f.eks. en erstatningssalgsordre, og underst�tte bilag for lagerekspeditionen. Bem�rk: Hvis et fejlbeh�ftet salg endnu ikke er betalt, kan du blot annullere den bogf�rte salgsfaktura for automatisk at tilbagef�re den �konomiske transaktion.;
                                 ENU=Compensate your customers for incorrect or damaged items that you sent to them and received payment for. Sales return orders enable you to receive items from multiple sales documents with one sales return, automatically create related sales credit memos or other return-related documents, such as a replacement sales order, and support warehouse documents for the item handling. Note: If an erroneous sale has not been paid yet, you can simply cancel the posted sales invoice to automatically revert the financial transaction.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 9304;
                      Image=ReturnOrder }
      { 85      ;1   ;Action    ;
                      Name=InventoryPicks;
                      CaptionML=[DAN=Pluk (lager);
                                 ENU=Inventory Picks];
                      ToolTipML=[DAN="Vis igangv�rende varepluk fra placeringer i henhold til en grundl�ggende lagerkonfiguration. ";
                                 ENU="View ongoing picks of items from bins according to a basic warehouse configuration. "];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 9316 }
      { 88      ;1   ;Action    ;
                      Name=InventoryPutaways;
                      CaptionML=[DAN=L�g-p�-lager-akt. (lager);
                                 ENU=Inventory Put-aways];
                      ToolTipML=[DAN="Vis igangv�rende l�g-p�-lager-vareaktiviteter til placeringer i henhold til en grundl�ggende lagerkonfiguration. ";
                                 ENU="View ongoing put-aways of items to bins according to a basic warehouse configuration. "];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 9315 }
      { 1       ;1   ;Action    ;
                      Name=InventoryMovements;
                      CaptionML=[DAN=Flytninger (lager);
                                 ENU=Inventory Movements];
                      ToolTipML=[DAN="Vis oversigten over igangv�rende varebev�gelser mellem placeringer i henhold til en grundl�ggende lagerkonfiguration. ";
                                 ENU="View ongoing movements of items between bins according to a basic warehouse configuration. "];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 9330 }
      { 5       ;1   ;Action    ;
                      Name=Internal Movements;
                      CaptionML=[DAN=Interne flytninger;
                                 ENU=Internal Movements];
                      ToolTipML=[DAN=Vis oversigten over igangv�rende bev�gelser mellem placeringer.;
                                 ENU=View the list of ongoing movements between bins.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7400 }
      { 94      ;1   ;Action    ;
                      Name=BinContents;
                      CaptionML=[DAN=Placeringsindhold;
                                 ENU=Bin Contents];
                      ToolTipML=[DAN=Vis varer i placeringen, hvis den valgte linje indeholder en placeringskode.;
                                 ENU=View items in the bin if the selected line contains a bin code.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7305;
                      Image=BinContent }
      { 22      ;1   ;Action    ;
                      Name=Items;
                      CaptionML=[DAN=Varer;
                                 ENU=Items];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om de produkter, du handler med. Varekortet kan v�re af typen lager eller tjeneste for at angive, om varen er en fysisk enhed eller en best�r af arbejdstimer. Her angiver du ogs�, om varerne p� lager eller i indg�ende ordrer automatisk reserveres til udg�ende bilag, og om der er oprettet ordresporingsbindinger mellem behov og forsyning for at afspejle planl�gningshandlinger.;
                                 ENU=View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 31;
                      Image=Item }
      { 23      ;1   ;Action    ;
                      Name=Customers;
                      CaptionML=[DAN=Debitorer;
                                 ENU=Customers];
                      ToolTipML=[DAN=F� vist eller rediger detaljerede oplysninger om de debitorer, som du handler med. Fra det enkelte debitorkort kan du f� adgang til relaterede oplysninger som f.eks. salgsstatistik og igangv�rende ordrer, og du kan definere specialpriser og linjerabatter, som debitoren f�r, n�r bestemte betingelser er opfyldt.;
                                 ENU=View or edit detailed information for the customers that you trade with. From each customer card, you can open related information, such as sales statistics and ongoing orders, and you can define special prices and line discounts that you grant if certain conditions are met.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 22;
                      Image=Customer }
      { 24      ;1   ;Action    ;
                      Name=Vendors;
                      CaptionML=[DAN=Kreditorer;
                                 ENU=Vendors];
                      ToolTipML=[DAN=F� vist eller rediger detaljerede oplysninger om de kreditorer, som du handler med. Fra det enkelte kreditorkort kan du f� adgang til relaterede oplysninger som f.eks. k�bsstatistik og igangv�rende ordrer, og du kan definere specialpriser og linjerabatter, som kreditoren giver dig, n�r bestemte betingelser er opfyldt.;
                                 ENU=View or edit detailed information for the vendors that you trade with. From each vendor card, you can open related information, such as purchase statistics and ongoing orders, and you can define special prices and line discounts that the vendor grants you if certain conditions are met.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 27;
                      Image=Vendor }
      { 25      ;1   ;Action    ;
                      Name=ShippingAgents;
                      CaptionML=[DAN=Spedit�rer;
                                 ENU=Shipping Agents];
                      ToolTipML=[DAN=Vis listen over spedit�rer, som du bruger til at transportere varer.;
                                 ENU=View the list of shipping companies that you use to transport goods.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 428 }
      { 27      ;1   ;Action    ;
                      Name=ItemReclassificationJournals;
                      CaptionML=[DAN=Vareomposteringskladder;
                                 ENU=Item Reclassification Journals];
                      ToolTipML=[DAN=Rediger oplysninger, der er registreret i vareposter. Typiske lageroplysninger, der skal omposteres, omfatter dimensioner og salgskampagnekoder, men du kan ogs� udf�re grundl�ggende lageroverf�rsler ved at ompostere lokations- og placeringskoder. Serie- eller lotnumre og deres udl�bsdatoer skal omposteres vha. omposteringskladden til varesporing.;
                                 ENU=Change information recorded on item ledger entries. Typical inventory information to reclassify includes dimensions and sales campaign codes, but you can also perform basic inventory transfers by reclassifying location and bin codes. Serial or lot numbers and their expiration dates must be reclassified with the Item Tracking Reclassification journal.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 262;
                      RunPageView=WHERE(Template Type=CONST(Transfer),
                                        Recurring=CONST(No)) }
      { 28      ;1   ;Action    ;
                      Name=PhysInventoryJournals;
                      CaptionML=[DAN=Lageropg�relseskladder;
                                 ENU=Phys. Inventory Journals];
                      ToolTipML=[DAN=Forbered opt�lling af de faktiske varer p� lager for at kontrollere, om det antal, der er registreret i systemet, er det samme som den fysiske m�ngde. Hvis der er forskelle, skal du bogf�re dem i varekladden med lageropg�relseskladden, f�r du opg�r lagerv�rdien.;
                                 ENU=Prepare to count the actual items in inventory to check if the quantity registered in the system is the same as the physical quantity. If there are differences, post them to the item ledger with the physical inventory journal before you do the inventory valuation.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 262;
                      RunPageView=WHERE(Template Type=CONST(Phys. Inventory),
                                        Recurring=CONST(No)) }
      { 1900000012;0 ;ActionContainer;
                      ActionContainerType=ActivityButtons }
      { 39      ;1   ;ActionGroup;
                      CaptionML=[DAN=Bogf�rte dokumenter;
                                 ENU=Posted Documents];
                      Image=FiledPosted }
      { 29      ;2   ;Action    ;
                      CaptionML=[DAN=Bogf�rte pluk (lager);
                                 ENU=Posted Invt. Picks];
                      ToolTipML=[DAN="Vis listen over afsluttede lagerpluk. ";
                                 ENU="View the list of completed inventory picks. "];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7395 }
      { 136     ;2   ;Action    ;
                      CaptionML=[DAN=Bogf�rt salgsleverance;
                                 ENU=Posted Sales Shipment];
                      ToolTipML=[DAN=�bn listen over bogf�rte salgsleverancer.;
                                 ENU=Open the list of posted sales shipments.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 142 }
      { 137     ;2   ;Action    ;
                      CaptionML=[DAN=Bogf. overflytningsleverancer;
                                 ENU=Posted Transfer Shipments];
                      ToolTipML=[DAN=�bn listen over bogf�rte overflytningsleverancer.;
                                 ENU=Open the list of posted transfer shipments.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 5752 }
      { 138     ;2   ;Action    ;
                      CaptionML=[DAN=Bogf�rte returvareleverancer;
                                 ENU=Posted Return Shipments];
                      ToolTipML=[DAN=�bn listen over bogf�rte returvareleverancer.;
                                 ENU=Open the list of posted return shipments.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 6652 }
      { 10      ;2   ;Action    ;
                      CaptionML=[DAN=Bogf. l�g-p�-lager-akt. (lager);
                                 ENU=Posted Invt. Put-aways];
                      ToolTipML=[DAN="Vis listen over afsluttede l�g-p�-lager-aktiviteter. ";
                                 ENU="View the list of completed inventory put-aways. "];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7394 }
      { 6       ;2   ;Action    ;
                      CaptionML=[DAN=Registrerede flytninger (lager);
                                 ENU=Registered Invt. Movements];
                      ToolTipML=[DAN=Vis listen over afsluttede flytninger (lager).;
                                 ENU=View the list of completed inventory movements.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7386 }
      { 3       ;2   ;Action    ;
                      CaptionML=[DAN=Bogf. overflytn.kvitteringer;
                                 ENU=Posted Transfer Receipts];
                      ToolTipML=[DAN=�bn listen over bogf�rte overflytningsmodtagelser.;
                                 ENU=Open the list of posted transfer receipts.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 5753 }
      { 139     ;2   ;Action    ;
                      CaptionML=[DAN=Bogf. k�bsmodtagelser;
                                 ENU=Posted Purchase Receipts];
                      ToolTipML=[DAN=�bn listen over bogf�rte k�bsmodtagelser.;
                                 ENU=Open the list of posted purchase receipts.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 145 }
      { 141     ;2   ;Action    ;
                      CaptionML=[DAN=Bogf�rte returvaremodt.;
                                 ENU=Posted Return Receipts];
                      ToolTipML=[DAN=�bn listen over bogf�rte returvaremodtagelser.;
                                 ENU=Open the list of posted return receipts.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 6662;
                      Image=PostedReturnReceipt }
      { 17      ;2   ;Action    ;
                      CaptionML=[DAN=Bogf�rte montageordrer;
                                 ENU=Posted Assembly Orders];
                      ToolTipML=[DAN=Vis fuldf�rte montageordrer.;
                                 ENU=View completed assembly orders.];
                      ApplicationArea=#Assembly;
                      RunObject=Page 922 }
      { 7       ;0   ;ActionContainer;
                      ActionContainerType=NewDocumentItems }
      { 13      ;1   ;Action    ;
                      CaptionML=[DAN=&Overflytningsordre;
                                 ENU=T&ransfer Order];
                      ToolTipML=[DAN=Flyt varer fra �t lager til et andet.;
                                 ENU=Move items from one warehouse location to another.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 5740;
                      Promoted=No;
                      Image=Document;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 11      ;1   ;Action    ;
                      CaptionML=[DAN=&K�bsordre;
                                 ENU=&Purchase Order];
                      ToolTipML=[DAN=K�b varer eller servicer fra en kreditor.;
                                 ENU=Purchase goods or services from a vendor.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 50;
                      Promoted=No;
                      Image=Document;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 8       ;1   ;Action    ;
                      CaptionML=[DAN=&Pluk (lager);
                                 ENU=Inventory Pi&ck];
                      ToolTipML=[DAN="Opret et pluk i henhold til en grundl�ggende lagerkonfiguration, eksempelvis for at plukke komponenter til en salgsordre. ";
                                 ENU="Create a pick according to a basic warehouse configuration, for example to pick components for a sales order. "];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7377;
                      Promoted=No;
                      Image=CreateInventoryPickup;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 2       ;1   ;Action    ;
                      CaptionML=[DAN=&L�g-p�-lager (lager);
                                 ENU=Inventory P&ut-away];
                      ToolTipML=[DAN="Opret en l�g-p�-lager-aktivitet i henhold til en grundl�ggende lagerkonfiguration, eksempelvis for at l�gge en produceret vare p� lager. ";
                                 ENU="Create a put-away according to a basic warehouse configuration, for example to put a produced item away. "];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7375;
                      Promoted=No;
                      Image=CreatePutAway;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 12      ;1   ;Action    ;
                      CaptionML=[DAN=Rediger vareom&posteringskladde;
                                 ENU=Edit Item Reclassification &Journal];
                      ToolTipML=[DAN=Ret data for en vare, f.eks. dens lokation, dimension eller lotnummer.;
                                 ENU=Change data for an item, such as its location, dimension, or lot number.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 393;
                      Image=OpenWorksheet }
      { 84      ;1   ;Action    ;
                      CaptionML=[DAN=Vare&sporing;
                                 ENU=Item &Tracing];
                      ToolTipML=[DAN=Spor, hvor en lot- eller et serienummer, som varen er blevet tildelt, blev anvendt, eksempelvis for at finde ud af, hvilket lot en defekt komponent stammer fra, eller for at finde alle de debitorer, som har modtaget varer, der indeholder den defekte komponent.;
                                 ENU=Trace where a lot or serial number assigned to the item was used, for example, to find which lot a defective component came from or to find all the customers that have received items containing the defective component.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 6520;
                      Image=ItemTracing }
    }
  }
  CONTROLS
  {
    { 1900000008;0;Container;
                ContainerType=RoleCenterArea }

    { 1900724808;1;Group   }

    { 1906245608;2;Part   ;
                ApplicationArea=#Warehouse;
                PagePartID=Page9050;
                PartType=Page }

    { 1907692008;2;Part   ;
                ApplicationArea=#Warehouse;
                PagePartID=Page9150;
                PartType=Page }

    { 1900724708;1;Group   }

    { 4   ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page760;
                Visible=FALSE;
                PartType=Page }

    { 18  ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page675;
                Visible=false;
                PartType=Page }

    { 19  ;2   ;Part      ;
                ApplicationArea=#Warehouse;
                PagePartID=Page681;
                PartType=Page }

    { 1901377608;2;Part   ;
                ApplicationArea=#Advanced;
                PartType=System;
                SystemPartID=MyNotes }

  }
  CODE
  {

    BEGIN
    END.
  }
}

