OBJECT Page 9000 Whse. WMS Role Center
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[@@@="{Dependency=Match,""ProfileDescription_SHIPPINGANDRECEIVING-WMS""}";
               DAN=Forsendelse og modtagelse - logistik;
               ENU=Shipping and Receiving - Warehouse Management System];
    PageType=RoleCenter;
    ActionList=ACTIONS
    {
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 5       ;1   ;Action    ;
                      CaptionML=[DAN=Pl&ukliste;
                                 ENU=&Picking List];
                      ToolTipML=[DAN=FÜ vist eller udskriv en detaljeret liste over varer, som skal plukkes.;
                                 ENU=View or print a detailed list of items that must be picked.];
                      ApplicationArea=#Warehouse;
                      RunObject=Report 5752;
                      Image=Report }
      { 6       ;1   ;Action    ;
                      CaptionML=[DAN=L&ëg-pÜ-lager-oversigt;
                                 ENU=P&ut-away List];
                      ToolTipML=[DAN=Vis oversigten over igangvërende lëg-pÜ-lager-aktiviteter.;
                                 ENU=View the list of ongoing put-aways.];
                      ApplicationArea=#Warehouse;
                      RunObject=Report 5751;
                      Image=Report }
      { 7       ;1   ;Action    ;
                      CaptionML=[DAN=Be&vëgelsesoversigt;
                                 ENU=M&ovement List];
                      ToolTipML=[DAN=Vis oversigten over igangvërende bevëgelser mellem placeringer.;
                                 ENU=View the list of ongoing movements between bins.];
                      ApplicationArea=#Warehouse;
                      RunObject=Report 7301;
                      Image=Report }
      { 8       ;1   ;Action    ;
                      CaptionML=[DAN=Lagerlev.&status;
                                 ENU=Whse. &Shipment Status];
                      ToolTipML=[DAN=Vis lagerleverancer efter status.;
                                 ENU=View warehouse shipments by status.];
                      ApplicationArea=#Warehouse;
                      RunObject=Report 7313;
                      Image=Report }
      { 13      ;1   ;Action    ;
                      CaptionML=[DAN=Lagerpla&ceringsoversigt;
                                 ENU=Warehouse &Bin List];
                      ToolTipML=[DAN=FÜ et overblik over lagerplaceringerne, opsëtningen og antallet af varer pÜ placeringerne.;
                                 ENU=Get an overview of warehouse bins, their setup, and the quantity of items within the bins.];
                      ApplicationArea=#Warehouse;
                      RunObject=Report 7319;
                      Image=Report }
      { 14      ;1   ;Action    ;
                      CaptionML=[DAN=Regul.p&lac. (logistik);
                                 ENU=Whse. &Adjustment Bin];
                      ToolTipML=[DAN=Reguler antallet af en vare pÜ Çn eller flere placeringer. Det kan f.eks. vëre, at du finder nogle varer pÜ en placering, der ikke er registreret i systemet, eller at du ikke kan plukke det nõdvendige antal, fordi der er fërre varer pÜ en placering, som programmet har beregnet. Placeringen opdateres derefter, sÜ den svarer til det faktiske antal pÜ placeringen. Desuden oprettes et udlignende antal pÜ reguleringsplaceringen til synkronisering med vareposter, som du derefter kan bogfõre med en varekladde.;
                                 ENU=Adjust the quantity of an item in a particular bin or bins. For instance, you might find some items in a bin that are not registered in the system, or you might not be able to pick the quantity needed because there are fewer items in a bin than was calculated by the program. The bin is then updated to correspond to the actual quantity in the bin. In addition, it creates a balancing quantity in the adjustment bin, for synchronization with item ledger entries, which you can then post with an item journal.];
                      ApplicationArea=#Warehouse;
                      RunObject=Report 7320;
                      Image=Report }
      { 15      ;1   ;Action    ;
                      CaptionML=[DAN=Lagersted - &fysisk lagerliste;
                                 ENU=Whse. Phys. Inventory &List];
                      ToolTipML=[DAN=Vis eller udskriv listen over de linjer, du har beregnet i vinduet Lagersted - fysisk lagerkladde. Du kan bruge denne rapport under den fysiske lageroptëlling til at notere det faktiske antal pÜ lager og sammenligne antallet med det antal, der er registreret i programmet.;
                                 ENU=View or print the list of the lines that you have calculated in the Whse. Phys. Invt. Journal window. You can use this report during the physical inventory count to mark down actual quantities on hand in the warehouse and compare them to what is recorded in the program.];
                      ApplicationArea=#Warehouse;
                      RunObject=Report 7307;
                      Image=Report }
      { 16      ;1   ;Action    ;
                      CaptionML=[DAN=Lageropg&õrelsesoversigt;
                                 ENU=P&hys. Inventory List];
                      ToolTipML=[DAN=Vis en liste over de linjer, du har beregnet i vinduet Lageropgõrelseskladde. Du kan bruge denne rapport under den fysiske lageroptëlling til at notere det faktiske antal pÜ lager og sammenligne antallet med det antal, der er registreret i programmet.;
                                 ENU=View a list of the lines that you have calculated in the Phys. Inventory Journal window. You can use this report during the physical inventory count to mark down actual quantities on hand in the warehouse and compare them to what is recorded in the program.];
                      ApplicationArea=#Warehouse;
                      RunObject=Report 722;
                      Image=Report }
      { 50      ;1   ;Action    ;
                      CaptionML=[DAN=&Debitor - etiketter;
                                 ENU=&Customer - Labels];
                      ToolTipML=[DAN=Vis, gem eller udskriv etiketter med debitornavn og -adresse. Rapporten kan f.eks. bruges, nÜr du udsender salgsbreve.;
                                 ENU=View, save, or print mailing labels with the customers' names and addresses. The report can be used to send sales letters, for example.];
                      ApplicationArea=#Warehouse;
                      RunObject=Report 110;
                      Image=Report }
      { 1900000011;0 ;ActionContainer;
                      ActionContainerType=HomeItems }
      { 9       ;1   ;Action    ;
                      Name=WhseShpt;
                      CaptionML=[DAN=Lagerleverancer;
                                 ENU=Warehouse Shipments];
                      ToolTipML=[DAN=Vis listen over igangvërende lagerleverancer.;
                                 ENU=View the list of ongoing warehouse shipments.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7339 }
      { 22      ;1   ;Action    ;
                      Name=WhseShptReleased;
                      CaptionML=[DAN=Frigivet;
                                 ENU=Released];
                      ToolTipML=[DAN=Vis listen over frigivne kildebilag, som er klar til lageraktiviteter.;
                                 ENU=View the list of released source documents that are ready for warehouse activities.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7339;
                      RunPageView=SORTING(No.)
                                  WHERE(Status=FILTER(Released)) }
      { 23      ;1   ;Action    ;
                      Name=WhseShptPartPicked;
                      CaptionML=[DAN=Delvist plukket;
                                 ENU=Partially Picked];
                      ToolTipML=[DAN=Vis listen over igangvërende lagerpluk, der er delvist fuldfõrt.;
                                 ENU=View the list of ongoing warehouse picks that are partially completed.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7339;
                      RunPageView=WHERE(Document Status=FILTER(Partially Picked)) }
      { 24      ;1   ;Action    ;
                      Name=WhseShptComplPicked;
                      CaptionML=[DAN=Fuldt plukket;
                                 ENU=Completely Picked];
                      ToolTipML=[DAN=Vis listen over afsluttede lagerpluk.;
                                 ENU=View the list of completed warehouse picks.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7339;
                      RunPageView=WHERE(Document Status=FILTER(Completely Picked)) }
      { 25      ;1   ;Action    ;
                      Name=WhseShptPartShipped;
                      CaptionML=[DAN=Delvist leveret;
                                 ENU=Partially Shipped];
                      ToolTipML=[DAN=Vis listen over igangvërende lagerleverancer, der er delvist fuldfõrt.;
                                 ENU=View the list of ongoing warehouse shipments that are partially completed.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7339;
                      RunPageView=WHERE(Document Status=FILTER(Partially Shipped)) }
      { 11      ;1   ;Action    ;
                      Name=WhseRcpt;
                      CaptionML=[DAN=Lagermodtagelser;
                                 ENU=Warehouse Receipts];
                      ToolTipML=[DAN=Vis listen over igangvërende lagermodtagelser.;
                                 ENU=View the list of ongoing warehouse receipts.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7332 }
      { 77      ;1   ;Action    ;
                      Name=WhseRcptPartReceived;
                      CaptionML=[DAN=Delvist modtaget;
                                 ENU=Partially Received];
                      ToolTipML=[DAN=Vis listen over igangvërende lagermodtagelser, der er delvist fuldfõrt.;
                                 ENU=View the list of ongoing warehouse receipts that are partially completed.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7332;
                      RunPageView=WHERE(Document Status=FILTER(Partially Received)) }
      { 47      ;1   ;Action    ;
                      Name=SalesOrders;
                      CaptionML=[DAN=Salgsordrer;
                                 ENU=Sales Orders];
                      ToolTipML=[DAN=Registrer dine aftaler med debitorer for at sëlge bestemte varer pÜ bestemte leverings- og betalingsbetingelser. Salgsordrer gõr det i modsëtning til salgsfakturaer muligt at levere delvist, levere direkte fra kreditoren til debitoren, starte lagerekspedition og udskrive forskellige dokumenter til kunderne. Salgsfakturering er integreret i salgsordreprocessen.;
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
                      ToolTipML=[DAN=Vis listen over igangvërende lagerleverancer, der er delvist fuldfõrt.;
                                 ENU=View the list of ongoing warehouse shipments that are partially completed.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 9305;
                      RunPageView=WHERE(Status=FILTER(Released),
                                        Completely Shipped=FILTER(No)) }
      { 82      ;1   ;Action    ;
                      Name=PurchaseReturnOrders;
                      CaptionML=[DAN=Kõbsreturvareordrer;
                                 ENU=Purchase Return Orders];
                      ToolTipML=[DAN=Opret kõbsreturvareordrer for at afspejle de salgsreturbilag, som leverandõrer sender til dig for forkerte eller beskadigede varer, som er blevet betalt og derefter returneret til kreditoren. Kõbsreturvareordrer gõr det muligt at returnere varer fra flere kõbsbilag med samme kõbsreturnering og understõtter lagerbilag for lagerekspeditionen. Kõbsreturvareordrer kan oprettes automatisk ud fra PDF- eller billedfiler fra dine kreditorer ved hjëlp af funktionen IndgÜende bilag. Bemërk: Hvis du endnu ikke har betalt for et fejlbehëftet kõb, kan du blot annullere den bogfõrte kõbsfaktura for automatisk at tilbagefõre den õkonomiske transaktion.;
                                 ENU=Create purchase return orders to mirror sales return documents that vendors send to you for incorrect or damaged items that you have paid for and then returned to the vendor. Purchase return orders enable you to ship back items from multiple purchase documents with one purchase return and support warehouse documents for the item handling. Purchase return orders can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature. Note: If you have not yet paid for an erroneous purchase, you can simply cancel the posted purchase invoice to automatically revert the financial transaction.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 9311 }
      { 83      ;1   ;Action    ;
                      Name=TransferOrders;
                      CaptionML=[DAN=Overflytningsordrer;
                                 ENU=Transfer Orders];
                      ToolTipML=[DAN=Flyt lagervarer mellem lokationer for virksomheden. Med overflytningsordrer kan du sende udgÜende overflytninger fra Çn lokation og modtage den indgÜende overfõrsel pÜ den anden lokation. Derved kan du administrere de involverede lageraktiviteter, og det õger sikkerheden for, at vareantallet opdateres korrekt.;
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
                      CaptionML=[DAN=Kõbsordrer;
                                 ENU=Purchase Orders];
                      ToolTipML=[DAN=Opret kõbsordrer for at afspejle de salgsbilag, som leverandõrer sender til dig. PÜ denne mÜde kan du registrere kõbsomkostninger og spore kreditorer. Bogfõringen af kõbsordrer opdaterer lagerniveauerne dynamisk, sÜ du kan minimere lageromkostningerne og levere bedre kundeservice. Kõbsordrer tillader delleverancer, modsat kõbsfakturaer, og muliggõr direkte levering fra kreditoren til debitoren. Kõbsordrer kan oprettes automatisk ud fra PDF- eller billedfiler fra dine kreditorer ved hjëlp af funktionen IndgÜende bilag.;
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
                      ToolTipML=[DAN=Vis listen over igangvërende lagermodtagelser, der er delvist fuldfõrt.;
                                 ENU=View the list of ongoing warehouse receipts that are partially completed.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 9307;
                      RunPageView=WHERE(Status=FILTER(Released),
                                        Completely Received=FILTER(No)) }
      { 27      ;1   ;Action    ;
                      Name=AssemblyOrders;
                      CaptionML=[DAN=Montageordrer;
                                 ENU=Assembly Orders];
                      ToolTipML=[DAN=Vis igangvërende montageordrer.;
                                 ENU=View ongoing assembly orders.];
                      ApplicationArea=#Assembly;
                      RunObject=Page 902 }
      { 35      ;1   ;Action    ;
                      Name=SalesReturnOrders;
                      CaptionML=[DAN=Salgsreturvareordrer;
                                 ENU=Sales Return Orders];
                      ToolTipML=[DAN=Kompenser dine kunder for forkerte eller beskadigede varer, som du har sendt til dem og modtaget betaling for. Salgsreturvareordrer gõr det muligt at modtage varer fra flere salgsbilag med samme salgsreturnering, automatisk oprette de relaterede salgskreditnotaer eller andre returneringsbilag, f.eks. en erstatningssalgsordre, og understõtte bilag for lagerekspeditionen. Bemërk: Hvis et fejlbehëftet salg endnu ikke er betalt, kan du blot annullere den bogfõrte salgsfaktura for automatisk at tilbagefõre den õkonomiske transaktion.;
                                 ENU=Compensate your customers for incorrect or damaged items that you sent to them and received payment for. Sales return orders enable you to receive items from multiple sales documents with one sales return, automatically create related sales credit memos or other return-related documents, such as a replacement sales order, and support warehouse documents for the item handling. Note: If an erroneous sale has not been paid yet, you can simply cancel the posted sales invoice to automatically revert the financial transaction.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 9304;
                      Image=ReturnOrder }
      { 56      ;1   ;Action    ;
                      Name=Picks;
                      CaptionML=[DAN=Pluk;
                                 ENU=Picks];
                      ToolTipML=[DAN="Vis listen over igangvërende lagerpluk. ";
                                 ENU="View the list of ongoing warehouse picks. "];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 9313 }
      { 87      ;1   ;Action    ;
                      Name=PicksUnassigned;
                      CaptionML=[DAN=Ikke tildelt;
                                 ENU=Unassigned];
                      ToolTipML=[DAN=Vis alle ikke-tildelte lageraktiviteter.;
                                 ENU=View all unassigned warehouse activities.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 9313;
                      RunPageView=WHERE(Assigned User ID=FILTER('')) }
      { 58      ;1   ;Action    ;
                      Name=Putaway;
                      CaptionML=[DAN=Lëg-pÜ-lager;
                                 ENU=Put-away];
                      ToolTipML=[DAN=Opret en ny lëg-pÜ-lager-aktivitet.;
                                 ENU=Create a new put-away.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 9312 }
      { 90      ;1   ;Action    ;
                      Name=PutawayUnassigned;
                      CaptionML=[DAN=Ikke tildelt;
                                 ENU=Unassigned];
                      ToolTipML=[DAN=Vis alle ikke-tildelte lageraktiviteter.;
                                 ENU=View all unassigned warehouse activities.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 9312;
                      RunPageView=WHERE(Assigned User ID=FILTER('')) }
      { 59      ;1   ;Action    ;
                      Name=Movements;
                      CaptionML=[DAN=Bevëgelser;
                                 ENU=Movements];
                      ToolTipML=[DAN=Vis oversigten over igangvërende bevëgelser mellem placeringer i henhold til en avanceret lagerkonfiguration.;
                                 ENU=View the list of ongoing movements between bins according to an advanced warehouse configuration.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 9314 }
      { 93      ;1   ;Action    ;
                      Name=MovementsUnassigned;
                      CaptionML=[DAN=Ikke tildelt;
                                 ENU=Unassigned];
                      ToolTipML=[DAN=Vis alle ikke-tildelte lageraktiviteter.;
                                 ENU=View all unassigned warehouse activities.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 9314;
                      RunPageView=WHERE(Assigned User ID=FILTER('')) }
      { 60      ;1   ;Action    ;
                      Name=WhseWorksheetNames;
                      CaptionML=[DAN=Bevëgelseskladder;
                                 ENU=Movement Worksheets];
                      ToolTipML=[DAN=Planlëg og start varebevëgelser mellem placeringer i henhold til en avanceret lagerkonfiguration.;
                                 ENU=Plan and initiate movements of items between bins according to an advanced warehouse configuration.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7346;
                      RunPageView=WHERE(Template Type=CONST(Movement)) }
      { 94      ;1   ;Action    ;
                      Name=BinContents;
                      CaptionML=[DAN=Placeringsindhold;
                                 ENU=Bin Contents];
                      ToolTipML=[DAN=Vis varer i placeringen, hvis den valgte linje indeholder en placeringskode.;
                                 ENU=View items in the bin if the selected line contains a bin code.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7305;
                      Image=BinContent }
      { 61      ;1   ;Action    ;
                      Name=WhseJournalBatches;
                      CaptionML=[DAN=Lagerkladder;
                                 ENU=Whse. Item Journals];
                      ToolTipML=[DAN=Reguler antallet af en vare pÜ Çn eller flere placeringer. Det kan f.eks. vëre, at du finder nogle varer pÜ en placering, der ikke er registreret i systemet, eller at du ikke kan plukke det nõdvendige antal, fordi der er fërre varer pÜ en placering, som programmet har beregnet. Placeringen opdateres derefter, sÜ den svarer til det faktiske antal pÜ placeringen. Desuden oprettes et udlignende antal pÜ reguleringsplaceringen til synkronisering med vareposter, som du derefter kan bogfõre med en varekladde.;
                                 ENU=Adjust the quantity of an item in a particular bin or bins. For instance, you might find some items in a bin that are not registered in the system, or you might not be able to pick the quantity needed because there are fewer items in a bin than was calculated by the program. The bin is then updated to correspond to the actual quantity in the bin. In addition, it creates a balancing quantity in the adjustment bin, for synchronization with item ledger entries, which you can then post with an item journal.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7329;
                      RunPageView=WHERE(Template Type=CONST(Item)) }
      { 1900000012;0 ;ActionContainer;
                      ActionContainerType=ActivityButtons }
      { 62      ;1   ;ActionGroup;
                      CaptionML=[DAN=Stamdata;
                                 ENU=Reference Data];
                      Image=ReferenceData }
      { 117     ;2   ;Action    ;
                      CaptionML=[DAN=Varer;
                                 ENU=Items];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om de produkter, du handler med. Varekortet kan vëre af typen lager eller tjeneste for at angive, om varen er en fysisk enhed eller en bestÜr af arbejdstimer. Her angiver du ogsÜ, om varerne pÜ lager eller i indgÜende ordrer automatisk reserveres til udgÜende bilag, og om der er oprettet ordresporingsbindinger mellem behov og forsyning for at afspejle planlëgningshandlinger.;
                                 ENU=View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 31;
                      Image=Item }
      { 118     ;2   ;Action    ;
                      CaptionML=[DAN=Debitorer;
                                 ENU=Customers];
                      ToolTipML=[DAN=FÜ vist eller rediger detaljerede oplysninger om de debitorer, som du handler med. Fra det enkelte debitorkort kan du fÜ adgang til relaterede oplysninger som f.eks. salgsstatistik og igangvërende ordrer, og du kan definere specialpriser og linjerabatter, som debitoren fÜr, nÜr bestemte betingelser er opfyldt.;
                                 ENU=View or edit detailed information for the customers that you trade with. From each customer card, you can open related information, such as sales statistics and ongoing orders, and you can define special prices and line discounts that you grant if certain conditions are met.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 22;
                      Image=Customer }
      { 119     ;2   ;Action    ;
                      CaptionML=[DAN=Kreditorer;
                                 ENU=Vendors];
                      ToolTipML=[DAN=FÜ vist eller rediger detaljerede oplysninger om de kreditorer, som du handler med. Fra det enkelte kreditorkort kan du fÜ adgang til relaterede oplysninger som f.eks. kõbsstatistik og igangvërende ordrer, og du kan definere specialpriser og linjerabatter, som kreditoren giver dig, nÜr bestemte betingelser er opfyldt.;
                                 ENU=View or edit detailed information for the vendors that you trade with. From each vendor card, you can open related information, such as purchase statistics and ongoing orders, and you can define special prices and line discounts that the vendor grants you if certain conditions are met.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 27;
                      Image=Vendor }
      { 120     ;2   ;Action    ;
                      CaptionML=[DAN=Lokationer;
                                 ENU=Locations];
                      ToolTipML=[DAN=Vis listen over lagerlokationer.;
                                 ENU=View the list of warehouse locations.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 15;
                      Image=Warehouse }
      { 121     ;2   ;Action    ;
                      CaptionML=[DAN=Speditõr;
                                 ENU=Shipping Agent];
                      ToolTipML=[DAN=Vis listen over speditõrer, som du bruger til at transportere varer.;
                                 ENU=View the list of shipping companies that you use to transport goods.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 428 }
      { 122     ;1   ;ActionGroup;
                      CaptionML=[DAN=Kladder;
                                 ENU=Journals];
                      Image=Journals }
      { 12      ;2   ;Action    ;
                      Name=WhseItemJournals;
                      CaptionML=[DAN=Lagerkladder;
                                 ENU=Whse. Item Journals];
                      ToolTipML=[DAN=Reguler antallet af en vare pÜ Çn eller flere placeringer. Det kan f.eks. vëre, at du finder nogle varer pÜ en placering, der ikke er registreret i systemet, eller at du ikke kan plukke det nõdvendige antal, fordi der er fërre varer pÜ en placering, som programmet har beregnet. Placeringen opdateres derefter, sÜ den svarer til det faktiske antal pÜ placeringen. Desuden oprettes et udlignende antal pÜ reguleringsplaceringen til synkronisering med vareposter, som du derefter kan bogfõre med en varekladde.;
                                 ENU=Adjust the quantity of an item in a particular bin or bins. For instance, you might find some items in a bin that are not registered in the system, or you might not be able to pick the quantity needed because there are fewer items in a bin than was calculated by the program. The bin is then updated to correspond to the actual quantity in the bin. In addition, it creates a balancing quantity in the adjustment bin, for synchronization with item ledger entries, which you can then post with an item journal.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7329;
                      RunPageView=WHERE(Template Type=CONST(Item)) }
      { 17      ;2   ;Action    ;
                      Name=WhseReclassJournals;
                      CaptionML=[DAN=Lageromposteringskladder;
                                 ENU=Whse. Reclass. Journals];
                      ToolTipML=[DAN=Rediger oplysningerne i lagerposter som f.eks. zonekoder og placeringskoder.;
                                 ENU=Change information on warehouse entries, such as zone codes and bin codes.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7329;
                      RunPageView=WHERE(Template Type=CONST(Reclassification)) }
      { 18      ;2   ;Action    ;
                      Name=WhsePhysInvtJournals;
                      CaptionML=[DAN=Lagerplacering - opg.kladder;
                                 ENU=Whse. Phys. Invt. Journals];
                      ToolTipML=[DAN=Forbered optëlling af lagerbeholdningen ved at klargõre de dokumenter, som lagermedarbejderne skal bruge, nÜr de foretager en lageropgõrelse af bestemte varer eller af hele lagerstedet. NÜr optëllingen er fërdig, skal du indtaste det antal varer, der findes pÜ placeringerne, i dette vindue, hvorefter du registrerer lageropgõrelsen.;
                                 ENU=Prepare to count inventories by preparing the documents that warehouse employees use when they perform a physical inventory of selected items or of all the inventory. When the physical count has been made, you enter the number of items that are in the bins in this window, and then you register the physical inventory.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7329;
                      RunPageView=WHERE(Template Type=CONST(Physical Inventory)) }
      { 19      ;2   ;Action    ;
                      Name=ItemJournals;
                      CaptionML=[DAN=Varekladder;
                                 ENU=Item Journals];
                      ToolTipML=[DAN=Bogfõr varetransaktioner direkte pÜ varekladden for at regulere lagerbeholdningen i forbindelse med kõb, salg, opreguleringer eller nedreguleringer uden brug af bilag. Du kan gemme hele sët med varekladdelinjer som standardkladder, sÜ du hurtigt kan udfõre tilbagevendende bogfõringer. Der findes en komprimeret version af varekladdefunktionen pÜ varekort, som gõr det muligt at foretage en hurtig regulering af et varelagerantal.;
                                 ENU=Post item transactions directly to the item ledger to adjust inventory in connection with purchases, sales, and positive or negative adjustments without using documents. You can save sets of item journal lines as standard journals so that you can perform recurring postings quickly. A condensed version of the item journal function exists on item cards for quick adjustment of an items inventory quantity.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 262;
                      RunPageView=WHERE(Template Type=CONST(Item),
                                        Recurring=CONST(No)) }
      { 123     ;2   ;Action    ;
                      Name=ItemReclassJournals;
                      CaptionML=[DAN=Vareomposteringskladder;
                                 ENU=Item Reclass. Journals];
                      ToolTipML=[DAN=Rediger oplysninger, der er registreret i vareposter. Typiske lageroplysninger, der skal omposteres, omfatter dimensioner og salgskampagnekoder, men du kan ogsÜ udfõre grundlëggende lageroverfõrsler ved at ompostere lokations- og placeringskoder. Serie- eller lotnumre og deres udlõbsdatoer skal omposteres vha. omposteringskladden til varesporing.;
                                 ENU=Change information recorded on item ledger entries. Typical inventory information to reclassify includes dimensions and sales campaign codes, but you can also perform basic inventory transfers by reclassifying location and bin codes. Serial or lot numbers and their expiration dates must be reclassified with the Item Tracking Reclassification journal.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 262;
                      RunPageView=WHERE(Template Type=CONST(Transfer),
                                        Recurring=CONST(No)) }
      { 126     ;2   ;Action    ;
                      Name=PhysInventoryJournals;
                      CaptionML=[DAN=Lageropgõrelseskladder;
                                 ENU=Phys. Inventory Journals];
                      ToolTipML=[DAN=Forbered optëlling af de faktiske varer pÜ lager for at kontrollere, om det antal, der er registreret i systemet, er det samme som den fysiske mëngde. Hvis der er forskelle, skal du bogfõre dem i varekladden med lageropgõrelseskladden, fõr du opgõr lagervërdien.;
                                 ENU=Prepare to count the actual items in inventory to check if the quantity registered in the system is the same as the physical quantity. If there are differences, post them to the item ledger with the physical inventory journal before you do the inventory valuation.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 262;
                      RunPageView=WHERE(Template Type=CONST(Phys. Inventory),
                                        Recurring=CONST(No)) }
      { 129     ;1   ;ActionGroup;
                      CaptionML=[DAN=Kladde;
                                 ENU=Worksheet];
                      Image=Worksheets }
      { 130     ;2   ;Action    ;
                      Name=PutawayWorksheets;
                      CaptionML=[DAN=Lëg-pÜ-lager-kladder;
                                 ENU=Put-away Worksheets];
                      ToolTipML=[DAN=Planlëg og start lëg-pÜ-lager-vareaktiviteter.;
                                 ENU=Plan and initialize item put-aways.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7346;
                      RunPageView=WHERE(Template Type=CONST(Put-away)) }
      { 131     ;2   ;Action    ;
                      Name=PickWorksheets;
                      CaptionML=[DAN=Plukkladder;
                                 ENU=Pick Worksheets];
                      ToolTipML=[DAN="Planlëg og start pluk af varer. ";
                                 ENU="Plan and initialize picks of items. "];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7346;
                      RunPageView=WHERE(Template Type=CONST(Pick)) }
      { 132     ;2   ;Action    ;
                      Name=MovementWorksheets;
                      CaptionML=[DAN=Bevëgelseskladder;
                                 ENU=Movement Worksheets];
                      ToolTipML=[DAN=Planlëg og start varebevëgelser mellem placeringer i henhold til en avanceret lagerkonfiguration.;
                                 ENU=Plan and initiate movements of items between bins according to an advanced warehouse configuration.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7346;
                      RunPageView=WHERE(Template Type=CONST(Movement)) }
      { 134     ;2   ;Action    ;
                      CaptionML=[DAN=Interne lëg-pÜ-lager-aktiviteter;
                                 ENU=Internal Put-aways];
                      ToolTipML=[DAN=Vis oversigten over igangvërende lëg-pÜ-lager-aktiviteter for interne aktiviteter, f.eks. produktion.;
                                 ENU=View the list of ongoing put-aways for internal activities, such as production.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7356 }
      { 135     ;2   ;Action    ;
                      CaptionML=[DAN=Interne pluk;
                                 ENU=Internal Picks];
                      ToolTipML=[DAN=Vis oversigten over igangvërende pluk for interne aktiviteter, f.eks. produktion.;
                                 ENU=View the list of ongoing picks for internal activities, such as production.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7359 }
      { 39      ;1   ;ActionGroup;
                      CaptionML=[DAN=Bogfõrte dokumenter;
                                 ENU=Posted Documents];
                      Image=FiledPosted }
      { 3       ;2   ;Action    ;
                      CaptionML=[DAN=Bogfõrte lagerleverancer;
                                 ENU=Posted Whse Shipments];
                      ToolTipML=[DAN=èbn listen over bogfõrte lagerleverancer.;
                                 ENU=Open the list of posted warehouse shipments.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7340 }
      { 136     ;2   ;Action    ;
                      CaptionML=[DAN=Bogfõrt salgsleverance;
                                 ENU=Posted Sales Shipment];
                      ToolTipML=[DAN=èbn listen over bogfõrte salgsleverancer.;
                                 ENU=Open the list of posted sales shipments.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 142 }
      { 137     ;2   ;Action    ;
                      CaptionML=[DAN=Bogf. overflytningsleverancer;
                                 ENU=Posted Transfer Shipments];
                      ToolTipML=[DAN=èbn listen over bogfõrte overflytningsleverancer.;
                                 ENU=Open the list of posted transfer shipments.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 5752 }
      { 138     ;2   ;Action    ;
                      CaptionML=[DAN=Bogfõrte returvareleverancer;
                                 ENU=Posted Return Shipments];
                      ToolTipML=[DAN=èbn listen over bogfõrte returvareleverancer.;
                                 ENU=Open the list of posted return shipments.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 6652 }
      { 10      ;2   ;Action    ;
                      CaptionML=[DAN=Bogfõrte lagermodtagelser;
                                 ENU=Posted Whse Receipts];
                      ToolTipML=[DAN=èbn listen over bogfõrte lagermodtagelser.;
                                 ENU=Open the list of posted warehouse receipts.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7333 }
      { 139     ;2   ;Action    ;
                      CaptionML=[DAN=Bogf. kõbsmodtagelser;
                                 ENU=Posted Purchase Receipts];
                      ToolTipML=[DAN=èbn listen over bogfõrte kõbsmodtagelser.;
                                 ENU=Open the list of posted purchase receipts.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 145 }
      { 140     ;2   ;Action    ;
                      CaptionML=[DAN=Bogf. overflytn.kvitteringer;
                                 ENU=Posted Transfer Receipts];
                      ToolTipML=[DAN=èbn listen over bogfõrte overflytningsmodtagelser.;
                                 ENU=Open the list of posted transfer receipts.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 5753 }
      { 141     ;2   ;Action    ;
                      CaptionML=[DAN=Bogfõrte returvaremodt.;
                                 ENU=Posted Return Receipts];
                      ToolTipML=[DAN=èbn listen over bogfõrte returvaremodtagelser.;
                                 ENU=Open the list of posted return receipts.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 6662;
                      Image=PostedReturnReceipt }
      { 32      ;2   ;Action    ;
                      CaptionML=[DAN=Bogfõrte montageordrer;
                                 ENU=Posted Assembly Orders];
                      ToolTipML=[DAN=Vis fuldfõrte montageordrer.;
                                 ENU=View completed assembly orders.];
                      ApplicationArea=#Assembly;
                      RunObject=Page 922 }
      { 57      ;1   ;ActionGroup;
                      CaptionML=[DAN=Registrerede dokumenter;
                                 ENU=Registered Documents];
                      Image=RegisteredDocs }
      { 43      ;2   ;Action    ;
                      CaptionML=[DAN=Registrerede pluk;
                                 ENU=Registered Picks];
                      ToolTipML=[DAN=Vis lagerpluk, der er foretaget.;
                                 ENU=View warehouse picks that have been performed.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 9344;
                      Image=RegisteredDocs }
      { 44      ;2   ;Action    ;
                      CaptionML=[DAN=Registrerede lëg-pÜ-lager-akt.;
                                 ENU=Registered Put-aways];
                      ToolTipML=[DAN=Vis listen over afsluttede lëg-pÜ-lager-aktiviteter.;
                                 ENU=View the list of completed put-away activities.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 9343;
                      Image=RegisteredDocs }
      { 45      ;2   ;Action    ;
                      CaptionML=[DAN=Registrerede bevëgelser;
                                 ENU=Registered Movements];
                      ToolTipML=[DAN=Vis listen over afsluttede lagerbevëgelser.;
                                 ENU=View the list of completed warehouse movements.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 9345;
                      Image=RegisteredDocs }
      { 26      ;0   ;ActionContainer;
                      ActionContainerType=NewDocumentItems }
      { 21      ;1   ;Action    ;
                      CaptionML=[DAN=&Lagerleverance;
                                 ENU=Whse. &Shipment];
                      ToolTipML=[DAN=Opret en ny lagerleverance.;
                                 ENU=Create a new warehouse shipment.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7335;
                      Promoted=No;
                      Image=Shipment;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 20      ;1   ;Action    ;
                      CaptionML=[DAN=&Overflytningsordre;
                                 ENU=T&ransfer Order];
                      ToolTipML=[DAN=Flyt varer fra Çt lager til et andet.;
                                 ENU=Move items from one warehouse location to another.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 5740;
                      Promoted=No;
                      Image=Document;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 2       ;1   ;Action    ;
                      CaptionML=[DAN=&Kõbsordre;
                                 ENU=&Purchase Order];
                      ToolTipML=[DAN=Kõb varer eller servicer fra en kreditor.;
                                 ENU=Purchase goods or services from a vendor.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 50;
                      Promoted=No;
                      Image=Document;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 1       ;1   ;Action    ;
                      CaptionML=[DAN=&Lagermodtagelse;
                                 ENU=&Whse. Receipt];
                      ToolTipML=[DAN="Registrer modtagelsen af varer i henhold til en avanceret lagerkonfiguation. ";
                                 ENU="Record the receipt of items according to an advanced warehouse configuration. "];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 5768;
                      Promoted=No;
                      Image=Receipt;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 28      ;1   ;Action    ;
                      CaptionML=[DAN=&Lëg-pÜ-lager-kladde;
                                 ENU=P&ut-away Worksheet];
                      ToolTipML=[DAN=Klargõr og start lëg-pÜ-lager-vareaktiviteter.;
                                 ENU=Prepare and initialize item put-aways.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7352;
                      Image=PutAwayWorksheet }
      { 29      ;1   ;Action    ;
                      CaptionML=[DAN=Pl&ukkladde;
                                 ENU=Pi&ck Worksheet];
                      ToolTipML=[DAN="Planlëg og start pluk af varer. ";
                                 ENU="Plan and initialize picks of items. "];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7345;
                      Image=PickWorksheet }
      { 30      ;1   ;Action    ;
                      CaptionML=[DAN=B&evëgelseskladde;
                                 ENU=M&ovement Worksheet];
                      ToolTipML=[DAN=Gõr klar til at flytte varer mellem placeringer pÜ lageret.;
                                 ENU=Prepare to move items between bins within the warehouse.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7351;
                      Image=MovementWorksheet }
      { 36      ;1   ;Action    ;
                      CaptionML=[DAN=L&agerkladde;
                                 ENU=W&hse. Item Journal];
                      ToolTipML=[DAN=Reguler antallet af en vare pÜ Çn eller flere placeringer. Det kan f.eks. vëre, at du finder nogle varer pÜ en placering, der ikke er registreret i systemet, eller at du ikke kan plukke det nõdvendige antal, fordi der er fërre varer pÜ en placering, som programmet har beregnet. Placeringen opdateres derefter, sÜ den svarer til det faktiske antal pÜ placeringen. Desuden oprettes et udlignende antal pÜ reguleringsplaceringen til synkronisering med vareposter, som du derefter kan bogfõre med en varekladde.;
                                 ENU=Adjust the quantity of an item in a particular bin or bins. For instance, you might find some items in a bin that are not registered in the system, or you might not be able to pick the quantity needed because there are fewer items in a bin than was calculated by the program. The bin is then updated to correspond to the actual quantity in the bin. In addition, it creates a balancing quantity in the adjustment bin, for synchronization with item ledger entries, which you can then post with an item journal.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7324;
                      Image=BinJournal }
      { 46      ;1   ;Action    ;
                      CaptionML=[DAN=Lager&sted - fysisk lagerkladde;
                                 ENU=Whse. &Phys. Invt. Journal];
                      ToolTipML=[DAN=Forbered optëlling af lagerbeholdningen ved at klargõre de dokumenter, som lagermedarbejderne skal bruge, nÜr de foretager en lageropgõrelse af bestemte varer eller af hele lagerstedet. NÜr optëllingen er fërdig, skal du indtaste det antal varer, der findes pÜ placeringerne, i dette vindue, hvorefter du registrerer lageropgõrelsen.;
                                 ENU=Prepare to count inventories by preparing the documents that warehouse employees use when they perform a physical inventory of selected items or of all the inventory. When the physical count has been made, you enter the number of items that are in the bins in this window, and then you register the physical inventory.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7326;
                      Image=InventoryJournal }
      { 84      ;1   ;Action    ;
                      CaptionML=[DAN=Vares&poring;
                                 ENU=Item &Tracing];
                      ToolTipML=[DAN=Spor, hvor en lot- eller et serienummer, som varen er blevet tildelt, blev anvendt, eksempelvis for at finde ud af, hvilket lot en defekt komponent stammer fra, eller for at finde alle de debitorer, som har modtaget varer, der indeholder den defekte komponent.;
                                 ENU=Trace where a lot or serial number assigned to the item was used, for example, to find which lot a defective component came from or to find all the customers that have received items containing the defective component.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 6520;
                      Image=ItemTracing }
    }
  }
  CONTROLS
  {
    { 1900000008;0;Container;
                ContainerType=RoleCenterArea }

    { 1900724808;1;Group   }

    { 1903327208;2;Part   ;
                ApplicationArea=#Warehouse;
                PagePartID=Page9053;
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

    { 37  ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page675;
                Visible=false;
                PartType=Page }

    { 40  ;2   ;Part      ;
                ApplicationArea=#Warehouse;
                PagePartID=Page681;
                PartType=Page }

    { 1903012608;2;Part   ;
                ApplicationArea=#Advanced;
                PagePartID=Page9175;
                Visible=FALSE;
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

