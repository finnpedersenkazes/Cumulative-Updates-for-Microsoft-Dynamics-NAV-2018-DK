OBJECT Page 9007 Purchasing Agent Role Center
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[@@@="{Dependency=Match,""ProfileDescription_PURCHASINGAGENT""}";
               DAN=Indkõbsagent;
               ENU=Purchasing Agent];
    PageType=RoleCenter;
    ActionList=ACTIONS
    {
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 5       ;1   ;Action    ;
                      CaptionML=[DAN=Kreditor - t&op 10-liste;
                                 ENU=Vendor - T&op 10 List];
                      ToolTipML=[DAN=Vis en liste over, hvilke kreditorer du kõber mest hos, eller som du skylder mest til.;
                                 ENU=View a list of the vendors from whom you purchase the most or to whom you owe the most.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 311;
                      Image=Report }
      { 6       ;1   ;Action    ;
                      CaptionML=[DAN=Kreditor/varek&õb;
                                 ENU=Vendor/&Item Purchases];
                      ToolTipML=[DAN=Vis en liste over vareposter for hver kreditor i en valgt periode.;
                                 ENU=View a list of item entries for each vendor in a selected period.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 313;
                      Image=Report }
      { 28      ;1   ;Separator  }
      { 8       ;1   ;Action    ;
                      CaptionML=[DAN=Vare - &disponeringsoversigt;
                                 ENU=Inventory - &Availability Plan];
                      ToolTipML=[DAN=Vis en liste over antallet af de enkelte varer fordelt pÜ henholdsvis debitor-, kõbs- og overflytningsordrer, samt det antal der er disponibelt pÜ lageret. Oversigten er inddelt i kolonner, der dëkker seks perioder med angivne start- og slutdatoer, samt perioderne fõr og efter de pÜgëldende seks perioder. Listen er praktisk ved planlëgning af vareindkõb.;
                                 ENU=View a list of the quantity of each item in customer, purchase, and transfer orders and the quantity available in inventory. The list is divided into columns that cover six periods with starting and ending dates as well as the periods before and after those periods. The list is useful when you are planning your inventory purchases.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 707;
                      Image=ItemAvailability }
      { 9       ;1   ;Action    ;
                      CaptionML=[DAN=Varer i &kõbsordrer;
                                 ENU=Inventory &Purchase Orders];
                      ToolTipML=[DAN=Vis en oversigt over varer, der er bestilt hos kreditorer. Rapporten indeholder ogsÜ oplysninger om forventet modtagelsesdato og restordrer i antal og belõb. Rapporten kan f.eks. bruges til at give et overblik over det forventede leveringstidspunkt for varerne, og om der skal rykkes for restordrer.;
                                 ENU=View a list of items on order from vendors. The report also shows the expected receipt date and the quantity and amount on back orders. The report can be used, for example, to see when items should be received and whether a reminder of a back order should be issued.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 709;
                      Image=Report }
      { 13      ;1   ;Action    ;
                      CaptionML=[DAN=Vare/leverandõr&statistik;
                                 ENU=Inventory - &Vendor Purchases];
                      ToolTipML=[DAN=FÜ vist en liste over de leverandõrer, virksomheden har indkõbt varer hos i den valgte periode. Der vises oplysninger om faktureret antal, belõb og rabat. Rapporten kan bruges til analyse af virksomhedens varekõb.;
                                 ENU=View a list of the vendors that your company has purchased items from within a selected period. It shows invoiced quantity, amount and discount. The report can be used to analyze a company's item purchases.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 714;
                      Image=Report }
      { 14      ;1   ;Action    ;
                      CaptionML=[DAN=Intern &prisliste;
                                 ENU=Inventory &Cost and Price List];
                      ToolTipML=[DAN=Vis prisoplysninger om dine varer eller lagervarer, f.eks. direkte kostpris, sidste kõbspris, enhedspris, avanceprocent og avance.;
                                 ENU=View price information for your items or stockkeeping units, such as direct unit cost, last direct cost, unit price, profit percentage, and profit.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 716;
                      Image=Report }
      { 1900000011;0 ;ActionContainer;
                      ActionContainerType=HomeItems }
      { 7       ;1   ;Action    ;
                      Name=PurchaseOrders;
                      CaptionML=[DAN=Kõbsordrer;
                                 ENU=Purchase Orders];
                      ToolTipML=[DAN=Opret kõbsordrer for at afspejle de salgsbilag, som leverandõrer sender til dig. PÜ denne mÜde kan du registrere kõbsomkostninger og spore kreditorer. Bogfõringen af kõbsordrer opdaterer lagerniveauerne dynamisk, sÜ du kan minimere lageromkostningerne og levere bedre kundeservice. Kõbsordrer tillader delleverancer, modsat kõbsfakturaer, og muliggõr direkte levering fra kreditoren til debitoren. Kõbsordrer kan oprettes automatisk ud fra PDF- eller billedfiler fra dine kreditorer ved hjëlp af funktionen IndgÜende bilag.;
                                 ENU=Create purchase orders to mirror sales documents that vendors send to you. This enables you to record the cost of purchases and to track accounts payable. Posting purchase orders dynamically updates inventory levels so that you can minimize inventory costs and provide better customer service. Purchase orders allow partial receipts, unlike with purchase invoices, and enable drop shipment directly from your vendor to your customer. Purchase orders can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9307 }
      { 3       ;1   ;Action    ;
                      Name=PurchaseOrdersPendConf;
                      CaptionML=[DAN=Afventer bekrëftelse;
                                 ENU=Pending Confirmation];
                      ToolTipML=[DAN="Vis listen over kõbsordrer, der afventer bekrëftelse fra kreditoren. ";
                                 ENU="View the list of purchase orders that await the vendor's confirmation. "];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9307;
                      RunPageView=WHERE(Status=FILTER(Open)) }
      { 23      ;1   ;Action    ;
                      Name=PurchaseOrdersPartDeliv;
                      CaptionML=[DAN=Delvist leveret;
                                 ENU=Partially Delivered];
                      ToolTipML=[DAN=Vis oversigten over kõb, der er delvist modtaget.;
                                 ENU=View the list of purchases that are partially received.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9307;
                      RunPageView=WHERE(Status=FILTER(Released),
                                        Receive=FILTER(Yes),
                                        Completely Received=FILTER(No)) }
      { 76      ;1   ;Action    ;
                      CaptionML=[DAN=Kõbsrekvisition;
                                 ENU=Purchase Quotes];
                      ToolTipML=[DAN=Opret kõbstilbud, som reprësenterer din anmodning om tilbud fra kreditorer. Tilbud kan konverteres til kõbsordrer.;
                                 ENU=Create purchase quotes to represent your request for quotes from vendors. Quotes can be converted to purchase orders.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9306 }
      { 78      ;1   ;Action    ;
                      CaptionML=[DAN=Rammekõbsordrer;
                                 ENU=Blanket Purchase Orders];
                      ToolTipML=[DAN=Brug rammekõbsordrer som en ramme for en langsigtet aftale mellem dig og dine kreditorer for at kõbe et stort antal varer, der skal leveres i flere mindre portioner i lõbet af en bestemt periode. En rammeordre omfatter ofte kun en enkelt vare med leveringsdatoer, der er fastsat pÜ forhÜnd. Den vësentligste Ürsag til at bruge en rammeordre i stedet for en kõbsordre er, at de antal, der angives i en rammeordre, ikke pÜvirker varedisponeringen, og at oplysningerne dermed kan bruges til overvÜgnings-, prognose- og planlëgningsformÜl.;
                                 ENU=Use blanket purchase orders as a framework for a long-term agreement between you and your vendors to buy large quantities that are to be delivered in several smaller shipments over a certain period of time. Blanket orders often cover only one item with predetermined delivery dates. The main reason for using a blanket order rather than a purchase order is that quantities entered on a blanket order do not affect item availability and thus can be used as a worksheet for monitoring, forecasting, and planning purposes..];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9310 }
      { 82      ;1   ;Action    ;
                      CaptionML=[DAN=Kõbsfakturaer;
                                 ENU=Purchase Invoices];
                      ToolTipML=[DAN=Opret kõbsfakturaer for at afspejle de salgsbilag, som leverandõrer sender til dig. PÜ denne mÜde kan du registrere kõbsomkostninger og spore kreditorer. Bogfõringen af kõbsfakturaer opdaterer lagerniveauerne dynamisk, sÜ du kan minimere lageromkostningerne og levere bedre kundeservice. Kõbsfakturaer kan oprettes automatisk ud fra PDF- eller billedfiler fra dine kreditorer ved hjëlp af funktionen IndgÜende bilag.;
                                 ENU=Create purchase invoices to mirror sales documents that vendors send to you. This enables you to record the cost of purchases and to track accounts payable. Posting purchase invoices dynamically updates inventory levels so that you can minimize inventory costs and provide better customer service. Purchase invoices can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9308 }
      { 83      ;1   ;Action    ;
                      CaptionML=[DAN=Kõbsreturvareordrer;
                                 ENU=Purchase Return Orders];
                      ToolTipML=[DAN=Opret kõbsreturvareordrer for at afspejle de salgsreturbilag, som leverandõrer sender til dig for forkerte eller beskadigede varer, som er blevet betalt og derefter returneret til kreditoren. Kõbsreturvareordrer gõr det muligt at returnere varer fra flere kõbsbilag med samme kõbsreturnering og understõtter lagerbilag for lagerekspeditionen. Kõbsreturvareordrer kan oprettes automatisk ud fra PDF- eller billedfiler fra dine kreditorer ved hjëlp af funktionen IndgÜende bilag. Bemërk: Hvis du endnu ikke har betalt for et fejlbehëftet kõb, kan du blot annullere den bogfõrte kõbsfaktura for automatisk at tilbagefõre den õkonomiske transaktion.;
                                 ENU=Create purchase return orders to mirror sales return documents that vendors send to you for incorrect or damaged items that you have paid for and then returned to the vendor. Purchase return orders enable you to ship back items from multiple purchase documents with one purchase return and support warehouse documents for the item handling. Purchase return orders can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature. Note: If you have not yet paid for an erroneous purchase, you can simply cancel the posted purchase invoice to automatically revert the financial transaction.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9311 }
      { 31      ;1   ;Action    ;
                      CaptionML=[DAN=Kõbskreditnotaer;
                                 ENU=Purchase Credit Memos];
                      ToolTipML=[DAN=Opret kõbskreditnotaer for at afspejle de salgskreditnotaer, som leverandõrer sender til dig for forkerte eller beskadigede varer, som er blevet betalt og derefter returneret til kreditoren. Hvis du har behov for mere kontrol over kõbsreturneringsprocessen, herunder lagerbilag for den fysiske lagerekspedition, skal du bruge kõbsreturvareordrer, hvor kõbskreditnotaerne integreres. Kõbskreditnotaer kan oprettes automatisk ud fra PDF- eller billedfiler fra dine kreditorer ved hjëlp af funktionen IndgÜende bilag. Bemërk: Hvis du endnu ikke har betalt for et fejlbehëftet kõb, kan du blot annullere den bogfõrte kõbsfaktura for automatisk at tilbagefõre den õkonomiske transaktion.;
                                 ENU=Create purchase credit memos to mirror sales credit memos that vendors send to you for incorrect or damaged items that you have paid for and then returned to the vendor. If you need more control of the purchase return process, such as warehouse documents for the physical handling, use purchase return orders, in which purchase credit memos are integrated. Purchase credit memos can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature. Note: If you have not yet paid for an erroneous purchase, you can simply cancel the posted purchase invoice to automatically revert the financial transaction.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9309 }
      { 26      ;1   ;Action    ;
                      CaptionML=[DAN=Montageordrer;
                                 ENU=Assembly Orders];
                      ToolTipML=[DAN=Vis igangvërende montageordrer.;
                                 ENU=View ongoing assembly orders.];
                      ApplicationArea=#Assembly;
                      RunObject=Page 902 }
      { 32      ;1   ;Action    ;
                      CaptionML=[DAN=Salgsordrer;
                                 ENU=Sales Orders];
                      ToolTipML=[DAN=Registrer dine aftaler med debitorer for at sëlge bestemte varer pÜ bestemte leverings- og betalingsbetingelser. Salgsordrer gõr det i modsëtning til salgsfakturaer muligt at levere delvist, levere direkte fra kreditoren til debitoren, starte lagerekspedition og udskrive forskellige dokumenter til kunderne. Salgsfakturering er integreret i salgsordreprocessen.;
                                 ENU=Record your agreements with customers to sell certain products on certain delivery and payment terms. Sales orders, unlike sales invoices, allow you to ship partially, deliver directly from your vendor to your customer, initiate warehouse handling, and print various customer-facing documents. Sales invoicing is integrated in the sales order process.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9305;
                      Image=Order }
      { 85      ;1   ;Action    ;
                      CaptionML=[DAN=Kreditorer;
                                 ENU=Vendors];
                      ToolTipML=[DAN=FÜ vist eller rediger detaljerede oplysninger om de kreditorer, som du handler med. Fra det enkelte kreditorkort kan du fÜ adgang til relaterede oplysninger som f.eks. kõbsstatistik og igangvërende ordrer, og du kan definere specialpriser og linjerabatter, som kreditoren giver dig, nÜr bestemte betingelser er opfyldt.;
                                 ENU=View or edit detailed information for the vendors that you trade with. From each vendor card, you can open related information, such as purchase statistics and ongoing orders, and you can define special prices and line discounts that the vendor grants you if certain conditions are met.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 27;
                      Image=Vendor }
      { 88      ;1   ;Action    ;
                      CaptionML=[DAN=Varer;
                                 ENU=Items];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om de produkter, du handler med. Varekortet kan vëre af typen lager eller tjeneste for at angive, om varen er en fysisk enhed eller en bestÜr af arbejdstimer. Her angiver du ogsÜ, om varerne pÜ lager eller i indgÜende ordrer automatisk reserveres til udgÜende bilag, og om der er oprettet ordresporingsbindinger mellem behov og forsyning for at afspejle planlëgningshandlinger.;
                                 ENU=View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 31;
                      Image=Item }
      { 91      ;1   ;Action    ;
                      CaptionML=[DAN=Katalogvarer;
                                 ENU=Nonstock Items];
                      ToolTipML=[DAN="Vis oversigten over varer, du ikke lagerfõrer. ";
                                 ENU="View the list of items that you do not carry in inventory. "];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5726;
                      Image=NonStockItem }
      { 94      ;1   ;Action    ;
                      CaptionML=[DAN=Lagervarer;
                                 ENU=Stockkeeping Units];
                      ToolTipML=[DAN="èbn oversigten over lagervarer for varen for at vise eller redigere forekomster af varen pÜ forskellige lokationer eller med forskellige varianter. ";
                                 ENU="Open the list of item SKUs to view or edit instances of item at different locations or with different variants. "];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 5701;
                      Image=SKU }
      { 95      ;1   ;Action    ;
                      CaptionML=[DAN=Kõbsanalyserapporter;
                                 ENU=Purchase Analysis Reports];
                      ToolTipML=[DAN=Analyser udviklingen i kõbsmëngderne. Du kan ogsÜ bruge rapporten til at analysere kreditorprëstationer og priser.;
                                 ENU=Analyze the dynamics of your purchase volumes. You can also use the report to analyze your vendors' performance and purchase prices.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9375;
                      RunPageView=WHERE(Analysis Area=FILTER(Purchase)) }
      { 96      ;1   ;Action    ;
                      CaptionML=[DAN=Lageranalyserapporter;
                                 ENU=Inventory Analysis Reports];
                      ToolTipML=[DAN=Analyser udviklingen i lageret pÜ grundlag af de nõgleparametre, som du har valgt, f.eks. lageromsëtningen. Du kan ogsÜ bruge rapporten til at analysere lageromkostningerne, bÜde med hensyn til direkte og indirekte omkostninger, samt vërdien og mëngden af forskellige typer beholdning.;
                                 ENU=Analyze the dynamics of your inventory according to key performance indicators that you select, for example inventory turnover. You can also use the report to analyze your inventory costs, in terms of direct and indirect costs, as well as the value and quantities of your different types of inventory.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9377;
                      RunPageView=WHERE(Analysis Area=FILTER(Inventory)) }
      { 10      ;1   ;Action    ;
                      CaptionML=[DAN=Varekladder;
                                 ENU=Item Journals];
                      ToolTipML=[DAN=Bogfõr varetransaktioner direkte pÜ varekladden for at regulere lagerbeholdningen i forbindelse med kõb, salg, opreguleringer eller nedreguleringer uden brug af bilag. Du kan gemme hele sët med varekladdelinjer som standardkladder, sÜ du hurtigt kan udfõre tilbagevendende bogfõringer. Der findes en komprimeret version af varekladdefunktionen pÜ varekort, som gõr det muligt at foretage en hurtig regulering af et varelagerantal.;
                                 ENU=Post item transactions directly to the item ledger to adjust inventory in connection with purchases, sales, and positive or negative adjustments without using documents. You can save sets of item journal lines as standard journals so that you can perform recurring postings quickly. A condensed version of the item journal function exists on item cards for quick adjustment of an items inventory quantity.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 262;
                      RunPageView=WHERE(Template Type=CONST(Item),
                                        Recurring=CONST(No)) }
      { 17      ;1   ;Action    ;
                      CaptionML=[DAN=Kõbskladder;
                                 ENU=Purchase Journals];
                      ToolTipML=[DAN=Bogfõr enhver transaktion, der er relateret til kõb, direkte til en kreditor-, bankkonto eller finanskonto i stedet at bruge dedikerede bilag. Du kan bogfõre alle typer finansielle kõbstransaktioner, herunder betalinger, refusioner og finansgebyrbelõb. Bemërk, at du ikke kan bogfõre varebeholdninger med en kõbskladde.;
                                 ENU=Post any purchase-related transaction directly to a vendor, bank, or general ledger account instead of using dedicated documents. You can post all types of financial purchase transactions, including payments, refunds, and finance charge amounts. Note that you cannot post item quantities with a purchase journal.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 251;
                      RunPageView=WHERE(Template Type=CONST(Purchases),
                                        Recurring=CONST(No)) }
      { 19      ;1   ;Action    ;
                      Name=RequisitionWorksheets;
                      CaptionML=[DAN=Indkõbskladder;
                                 ENU=Requisition Worksheets];
                      ToolTipML=[DAN=Beregn en forsyningsplan for at opfylde varebehov via indkõb eller overfõrsler.;
                                 ENU=Calculate a supply plan to fulfill item demand with purchases or transfers.];
                      ApplicationArea=#Planning;
                      RunObject=Page 295;
                      RunPageView=WHERE(Template Type=CONST(Req.),
                                        Recurring=CONST(No)) }
      { 20      ;1   ;Action    ;
                      Name=SubcontractingWorksheets;
                      CaptionML=[DAN=Underleverandõrkladder;
                                 ENU=Subcontracting Worksheets];
                      ToolTipML=[DAN=Beregn den nõdvendige produktionsforsyning, find de produktionsordrer med materiale, der allerede er parat til afsendelse til en underleverandõr, og opret automatisk kõbsordrer pÜ operationer fra produktionsordreruter, der skal udfõres hos en underleverandõr.;
                                 ENU=Calculate the needed production supply, find the production orders that have material ready to send to a subcontractor, and automatically create purchase orders for subcontracted operations from production order routings.];
                      ApplicationArea=#Planning;
                      RunObject=Page 295;
                      RunPageView=WHERE(Template Type=CONST(For. Labor),
                                        Recurring=CONST(No)) }
      { 22      ;1   ;Action    ;
                      CaptionML=[DAN=Standardkostpriskladder;
                                 ENU=Standard Cost Worksheets];
                      ToolTipML=[DAN=Gennemse eller opdater standardomkostninger. Indkõbere, produktions- eller montageadministratorer kan bruge kladden til at simulere indflydelsen pÜ kostprisen pÜ den producerede eller samlede vare, hvis standardkostprisen for forbrug, produktionskapacitetsforbruget eller montageressourceforbruget ëndres. Du kan angive, at en kostprisëndring fõrst trëder i kraft pÜ en bestemt dato.;
                                 ENU=Review or update standard costs. Purchasers, production or assembly managers can use the worksheet to simulate the effect on the cost of the manufactured or assembled item if the standard cost for consumption, production capacity usage, or assembly resource usage is changed. You can set a cost change to take effect on a specified date.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5840 }
      { 1900000012;0 ;ActionContainer;
                      ActionContainerType=ActivityButtons }
      { 39      ;1   ;ActionGroup;
                      CaptionML=[DAN=Bogfõrte dokumenter;
                                 ENU=Posted Documents];
                      Image=FiledPosted }
      { 40      ;2   ;Action    ;
                      CaptionML=[DAN=Bogf. kõbsmodtagelser;
                                 ENU=Posted Purchase Receipts];
                      ToolTipML=[DAN=èbn listen over bogfõrte kõbsmodtagelser.;
                                 ENU=Open the list of posted purchase receipts.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 145 }
      { 42      ;2   ;Action    ;
                      CaptionML=[DAN=Bogf. kõbsfakturaer;
                                 ENU=Posted Purchase Invoices];
                      ToolTipML=[DAN=èbn listen over bogfõrte kõbsfakturaer.;
                                 ENU=Open the list of posted purchase invoices.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 146 }
      { 12      ;2   ;Action    ;
                      CaptionML=[DAN=Bogfõrte returvareleverancer;
                                 ENU=Posted Return Shipments];
                      ToolTipML=[DAN=èbn listen over bogfõrte returvareleverancer.;
                                 ENU=Open the list of posted return shipments.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 6652 }
      { 15      ;2   ;Action    ;
                      CaptionML=[DAN=Bogfõrte kõbskreditnotaer;
                                 ENU=Posted Purchase Credit Memos];
                      ToolTipML=[DAN=èbn listen over bogfõrte kõbskreditnotaer.;
                                 ENU=Open the list of posted purchase credit memos.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 147 }
      { 27      ;2   ;Action    ;
                      CaptionML=[DAN=Bogfõrte montageordrer;
                                 ENU=Posted Assembly Orders];
                      ToolTipML=[DAN=Vis fuldfõrte montageordrer.;
                                 ENU=View completed assembly orders.];
                      ApplicationArea=#Assembly;
                      RunObject=Page 922 }
      { 1       ;0   ;ActionContainer;
                      ActionContainerType=NewDocumentItems }
      { 18      ;1   ;Action    ;
                      CaptionML=[DAN=&Kõbsrekvisition;
                                 ENU=Purchase &Quote];
                      ToolTipML=[DAN=Opret en ny kõbsrekvisition, f.eks. for at afspejle en tilbudsanmodning.;
                                 ENU=Create a new purchase quote, for example to reflect a request for quote.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 49;
                      Promoted=No;
                      Image=Quote;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 16      ;1   ;Action    ;
                      CaptionML=[DAN=&Kõbsfaktura;
                                 ENU=Purchase &Invoice];
                      ToolTipML=[DAN=Opret en ny kõbsfaktura.;
                                 ENU=Create a new purchase invoice.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 51;
                      Promoted=No;
                      Image=NewPurchaseInvoice;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 4       ;1   ;Action    ;
                      CaptionML=[DAN=Kõbs&ordre;
                                 ENU=Purchase &Order];
                      ToolTipML=[DAN=Opret en ny kõbsordre.;
                                 ENU=Create a new purchase order.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 50;
                      Promoted=No;
                      Image=Document;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 2       ;1   ;Action    ;
                      CaptionML=[DAN=&Kõbsreturvareordre;
                                 ENU=Purchase &Return Order];
                      ToolTipML=[DAN=Opret en ny kõbsreturvareordre for at returnere modtagne varer.;
                                 ENU=Create a new purchase return order to return received items.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 6640;
                      Promoted=No;
                      Image=ReturnOrder;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 24      ;1   ;Separator ;
                      CaptionML=[DAN=Opgaver;
                                 ENU=Tasks];
                      IsHeader=Yes }
      { 29      ;1   ;Action    ;
                      CaptionML=[DAN=Kõb&skladde;
                                 ENU=&Purchase Journal];
                      ToolTipML=[DAN=Bogfõr kõbstransaktioner direkte i finansregnskabet. Kõbskladden indeholder muligvis allerede kladdelinjer, der er oprettet som et resultat af relaterede funktioner.;
                                 ENU=Post purchase transactions directly to the general ledger. The purchase journal may already contain journal lines that are created as a result of related functions.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 254;
                      Image=Journals }
      { 30      ;1   ;Action    ;
                      CaptionML=[DAN=&Varekladde;
                                 ENU=Item &Journal];
                      ToolTipML=[DAN=Juster det fysiske antal varer pÜ lager.;
                                 ENU=Adjust the physical quantity of items on inventory.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 40;
                      Image=Journals }
      { 11      ;1   ;Action    ;
                      CaptionML=[DAN=Ordrepla&nlëgning;
                                 ENU=Order Plan&ning];
                      ToolTipML=[DAN=Planlëg forsyningsordrer ordre for ordre for at opfylde nye behov.;
                                 ENU=Plan supply orders order by order to fulfill new demand.];
                      ApplicationArea=#Planning;
                      RunObject=Page 5522;
                      Image=Planning }
      { 38      ;1   ;Separator  }
      { 33      ;1   ;Action    ;
                      CaptionML=[DAN=In&dkõbskladde;
                                 ENU=Requisition &Worksheet];
                      ToolTipML=[DAN=Beregn en forsyningsplan for at opfylde varebehov via indkõb eller overfõrsler.;
                                 ENU=Calculate a supply plan to fulfill item demand with purchases or transfers.];
                      ApplicationArea=#Planning;
                      RunObject=Page 295;
                      RunPageView=WHERE(Template Type=CONST(Req.),
                                        Recurring=CONST(No));
                      Image=Worksheet }
      { 34      ;1   ;Action    ;
                      CaptionML=[DAN=Kõbs&priser;
                                 ENU=Pur&chase Prices];
                      ToolTipML=[DAN=Vis eller angiv forskellige priser for de varer, du kõber hos kreditoren. En varepris anfõres automatisk pÜ fakturalinjer, nÜr de specificerede kriterier er blevet opfyldt, f.eks. kreditor, mëngde eller slutdato.;
                                 ENU=View or set up different prices for items that you buy from the vendor. An item price is automatically granted on invoice lines when the specified criteria are met, such as vendor, quantity, or ending date.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 7012;
                      Image=Price }
      { 41      ;1   ;Action    ;
                      CaptionML=[DAN=Kõbs&linjerabatter;
                                 ENU=Purchase &Line Discounts];
                      ToolTipML=[DAN=Vis eller angiv forskellige rabatter for de varer, du kõber hos kreditoren. En varerabat anfõres automatisk pÜ fakturalinjer, nÜr de specificerede kriterier er blevet opfyldt, f.eks. kreditor, antal eller slutdato.;
                                 ENU=View or set up different discounts for items that you buy from the vendor. An item discount is automatically granted on invoice lines when the specified criteria are met, such as vendor, quantity, or ending date.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 7014;
                      Image=LineDiscount }
      { 36      ;1   ;Separator ;
                      CaptionML=[DAN=Oversigt;
                                 ENU=History];
                      IsHeader=Yes }
      { 46      ;1   ;Action    ;
                      CaptionML=[DAN=Navi&ger;
                                 ENU=Navi&gate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes for bilagsnummeret og bogfõringsdatoen pÜ den valgte post eller det valgte bilag.;
                                 ENU=Find all entries and documents that exist for the document number and posting date on the selected entry or document.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 344;
                      Image=Navigate }
    }
  }
  CONTROLS
  {
    { 1900000008;0;Container;
                ContainerType=RoleCenterArea }

    { 1900724808;1;Group   }

    { 1907662708;2;Part   ;
                ApplicationArea=#Advanced;
                PagePartID=Page9063;
                PartType=Page }

    { 1902476008;2;Part   ;
                ApplicationArea=#Advanced;
                PagePartID=Page9151;
                PartType=Page }

    { 1900724708;1;Group   }

    { 25  ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page771;
                PartType=Page }

    { 37  ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page771;
                Visible=false;
                PartType=Page }

    { 21  ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page772;
                PartType=Page }

    { 44  ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page772;
                Visible=false;
                PartType=Page }

    { 45  ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page681;
                PartType=Page }

    { 35  ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page675;
                Visible=false;
                PartType=Page }

    { 1905989608;2;Part   ;
                ApplicationArea=#Advanced;
                PagePartID=Page9152;
                PartType=Page }

    { 1903012608;2;Part   ;
                ApplicationArea=#Advanced;
                PagePartID=Page9175;
                Visible=FALSE;
                PartType=Page }

    { 43  ;2   ;Part      ;
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

