OBJECT Page 9006 Order Processor Role Center
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[@@@="{Dependency=Match,""ProfileDescription_ORDERPROCESSOR""}";
               DAN=Salgsordrebehandler;
               ENU=Sales Order Processor];
    PageType=RoleCenter;
    ActionList=ACTIONS
    {
      { 1900000011;0 ;ActionContainer;
                      ToolTipML=[DAN=Administrer salgsprocesser. Se nõgletal og dine foretrukne varer og debitorer.;
                                 ENU=Manage sales processes. See KPIs and your favorite items and customers.];
                      ActionContainerType=HomeItems }
      { 2       ;1   ;Action    ;
                      Name=SalesOrders;
                      CaptionML=[DAN=Salgsordrer;
                                 ENU=Sales Orders];
                      ToolTipML=[DAN=Registrer dine aftaler med debitorer for at sëlge bestemte varer pÜ bestemte leverings- og betalingsbetingelser. Salgsordrer gõr det i modsëtning til salgsfakturaer muligt at levere delvist, levere direkte fra kreditoren til debitoren, starte lagerekspedition og udskrive forskellige dokumenter til kunderne. Salgsfakturering er integreret i salgsordreprocessen.;
                                 ENU=Record your agreements with customers to sell certain products on certain delivery and payment terms. Sales orders, unlike sales invoices, allow you to ship partially, deliver directly from your vendor to your customer, initiate warehouse handling, and print various customer-facing documents. Sales invoicing is integrated in the sales order process.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 9305;
                      Image=Order }
      { 6       ;1   ;Action    ;
                      Name=SalesOrdersShptNotInv;
                      CaptionML=[DAN=Lev. belõb (ufakt.);
                                 ENU=Shipped Not Invoiced];
                      ToolTipML=[DAN=Vis salg, der leveres, men endnu ikke faktureret.;
                                 ENU=View sales that are shipped but not yet invoiced.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 9305;
                      RunPageView=WHERE(Shipped Not Invoiced=CONST(Yes)) }
      { 7       ;1   ;Action    ;
                      Name=SalesOrdersComplShtNotInv;
                      CaptionML=[DAN=Helt leveret (ufakt.);
                                 ENU=Completely Shipped Not Invoiced];
                      ToolTipML=[DAN=Vis salgsdokumenter, der er fuldt leveret men ikke er fuldt faktureret.;
                                 ENU=View sales documents that are fully shipped but not fully invoiced.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 9305;
                      RunPageView=WHERE(Completely Shipped=CONST(Yes),
                                        Invoice=CONST(No)) }
      { 25      ;1   ;Action    ;
                      CaptionML=[DAN=Salgsordrer - Microsoft Dynamics 365 for Sales;
                                 ENU=Sales Orders - Microsoft Dynamics 365 for Sales];
                      ToolTipML=[DAN=Vis salgsordrer i Dynamics 365 for Sales, der er sammenkëdet med salgsordrer i Dynamics NAV.;
                                 ENU=View sales orders in Dynamics 365 for Sales that are coupled with sales orders in Dynamics NAV.];
                      ApplicationArea=#Suite;
                      RunObject=Page 5353;
                      RunPageView=WHERE(StateCode=FILTER(Submitted),
                                        LastBackofficeSubmit=FILTER('')) }
      { 11      ;1   ;Action    ;
                      CaptionML=[DAN=Salgstilbud;
                                 ENU=Sales Quotes];
                      ToolTipML=[DAN=Giv tilbud til debitorer for at sëlge bestemte varer pÜ bestemte leverings- og betalingsbetingelser. NÜr du forhandler med en debitor, kan du ëndre og sende salgstilbud, sÜ mange gange du behõver. NÜr debitoren accepterer tilbuddet, skal du konvertere salgstilbuddet til en salgsfaktura eller en salgsordre, som du bruger til at behandle salget.;
                                 ENU=Make offers to customers to sell certain products on certain delivery and payment terms. While you negotiate with a customer, you can change and resend the sales quote as much as needed. When the customer accepts the offer, you convert the sales quote to a sales invoice or a sales order in which you process the sale.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 9300;
                      Image=Quote }
      { 49      ;1   ;Action    ;
                      CaptionML=[DAN=Rammesalgsordrer;
                                 ENU=Blanket Sales Orders];
                      ToolTipML=[DAN=Brug rammesalgsordrer som en ramme for en langsigtet aftale mellem dig og dine debitorer for at sëlge et stort antal varer, der skal leveres i flere mindre portioner i lõbet af en bestemt periode. En rammeordre omfatter ofte kun en enkelt vare med leveringsdatoer, der er fastsat pÜ forhÜnd. Den vësentligste Ürsag til at bruge en rammeordre i stedet for en salgsordre er, at de antal, der angives i en rammeordre, ikke pÜvirker varedisponeringen, og at oplysningerne dermed kan bruges til overvÜgnings-, prognose- og planlëgningsformÜl.;
                                 ENU=Use blanket sales orders as a framework for a long-term agreement between you and your customers to sell large quantities that are to be delivered in several smaller shipments over a certain period of time. Blanket orders often cover only one item with predetermined delivery dates. The main reason for using a blanket order rather than a sales order is that quantities entered on a blanket order do not affect item availability and thus can be used as a worksheet for monitoring, forecasting, and planning purposes..];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9303 }
      { 50      ;1   ;Action    ;
                      CaptionML=[DAN=Salgsfakturaer;
                                 ENU=Sales Invoices];
                      ToolTipML=[DAN=Registrer dit salg til debitorer, og inviter dem til at betale i henhold til leverings- og betalingsbetingelserne ved at sende dem et salgsfakturadokument. Bogfõring af en salgsfaktura registrerer leveringen og registrerer en Üben tilgodehavendepost pÜ debitorens konto, som vil blive lukket, nÜr betalingen er modtaget. Brug salgsordrer, hvor salgsfaktureringen er integreret, til at administrere leveringsprocessen.;
                                 ENU=Register your sales to customers and invite them to pay according to the delivery and payment terms by sending them a sales invoice document. Posting a sales invoice registers shipment and records an open receivable entry on the customer's account, which will be closed when payment is received. To manage the shipment process, use sales orders, in which sales invoicing is integrated.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 9301;
                      Image=Invoice }
      { 52      ;1   ;Action    ;
                      CaptionML=[DAN=Salgskreditnotaer;
                                 ENU=Sales Credit Memos];
                      ToolTipML=[DAN=Tilbagefõr õkonomiske transaktioner, nÜr debitorerne vil annullere et kõb eller returnere forkerte eller beskadigede varer, som du har sendt til dem og modtaget betaling for. For at fÜ de rette oplysninger med, kan du oprette salgskreditnotaen ud fra den relaterede bogfõrte salgsfaktura, eller du kan oprette en ny salgskreditnota, hvor du indsëtter en kopi af fakturaoplysninger. Hvis du har brug for flere kontrol over processen for salgsreturvarer som f.eks. bilag for den fysiske lagerekspedition, skal du bruge salgsreturvareordrer, hvor salgskreditnotaer er integreret. Bemërk: Hvis et fejlbehëftet salg endnu ikke er blevet betalt, kan du blot annullere den bogfõrte salgsfaktura for automatisk at tilbagefõre den õkonomiske transaktion.;
                                 ENU=Revert the financial transactions involved when your customers want to cancel a purchase or return incorrect or damaged items that you sent to them and received payment for. To include the correct information, you can create the sales credit memo from the related posted sales invoice or you can create a new sales credit memo with copied invoice information. If you need more control of the sales return process, such as warehouse documents for the physical handling, use sales return orders, in which sales credit memos are integrated. Note: If an erroneous sale has not been paid yet, you can simply cancel the posted sales invoice to automatically revert the financial transaction.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 9302 }
      { 51      ;1   ;Action    ;
                      CaptionML=[DAN=Salgsreturvareordrer;
                                 ENU=Sales Return Orders];
                      ToolTipML=[DAN=Kompenser dine kunder for forkerte eller beskadigede varer, som du har sendt til dem og modtaget betaling for. Salgsreturvareordrer gõr det muligt at modtage varer fra flere salgsbilag med samme salgsreturnering, automatisk oprette de relaterede salgskreditnotaer eller andre returneringsbilag, f.eks. en erstatningssalgsordre, og understõtte bilag for lagerekspeditionen. Bemërk: Hvis et fejlbehëftet salg endnu ikke er betalt, kan du blot annullere den bogfõrte salgsfaktura for automatisk at tilbagefõre den õkonomiske transaktion.;
                                 ENU=Compensate your customers for incorrect or damaged items that you sent to them and received payment for. Sales return orders enable you to receive items from multiple sales documents with one sales return, automatically create related sales credit memos or other return-related documents, such as a replacement sales order, and support warehouse documents for the item handling. Note: If an erroneous sale has not been paid yet, you can simply cancel the posted sales invoice to automatically revert the financial transaction.];
                      ApplicationArea=#SalesReturnOrder;
                      RunObject=Page 9304;
                      Image=ReturnOrder }
      { 23      ;1   ;Action    ;
                      CaptionML=[DAN=Varer;
                                 ENU=Items];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om de produkter, du handler med. Varekortet kan vëre af typen lager eller tjeneste for at angive, om varen er en fysisk enhed eller en bestÜr af arbejdstimer. Her angiver du ogsÜ, om varerne pÜ lager eller i indgÜende ordrer automatisk reserveres til udgÜende bilag, og om der er oprettet ordresporingsbindinger mellem behov og forsyning for at afspejle planlëgningshandlinger.;
                                 ENU=View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 31;
                      Image=Item }
      { 26      ;1   ;Action    ;
                      CaptionML=[DAN=Debitorer;
                                 ENU=Customers];
                      ToolTipML=[DAN=FÜ vist eller rediger detaljerede oplysninger om de debitorer, som du handler med. Fra det enkelte debitorkort kan du fÜ adgang til relaterede oplysninger som f.eks. salgsstatistik og igangvërende ordrer, og du kan definere specialpriser og linjerabatter, som debitoren fÜr, nÜr bestemte betingelser er opfyldt.;
                                 ENU=View or edit detailed information for the customers that you trade with. From each customer card, you can open related information, such as sales statistics and ongoing orders, and you can define special prices and line discounts that you grant if certain conditions are met.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 22;
                      Image=Customer }
      { 3       ;1   ;Action    ;
                      CaptionML=[DAN=Varekladder;
                                 ENU=Item Journals];
                      ToolTipML=[DAN=Bogfõr varetransaktioner direkte pÜ varekladden for at regulere lagerbeholdningen i forbindelse med kõb, salg, opreguleringer eller nedreguleringer uden brug af bilag. Du kan gemme hele sët med varekladdelinjer som standardkladder, sÜ du hurtigt kan udfõre tilbagevendende bogfõringer. Der findes en komprimeret version af varekladdefunktionen pÜ varekort, som gõr det muligt at foretage en hurtig regulering af et varelagerantal.;
                                 ENU=Post item transactions directly to the item ledger to adjust inventory in connection with purchases, sales, and positive or negative adjustments without using documents. You can save sets of item journal lines as standard journals so that you can perform recurring postings quickly. A condensed version of the item journal function exists on item cards for quick adjustment of an items inventory quantity.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 262;
                      RunPageView=WHERE(Template Type=CONST(Item),
                                        Recurring=CONST(No)) }
      { 5       ;1   ;Action    ;
                      Name=SalesJournals;
                      CaptionML=[DAN=Salgskladder;
                                 ENU=Sales Journals];
                      ToolTipML=[DAN=Bogfõr enhver transaktion, der er relateret til salg, direkte til en debitor-, bankkonto eller finanskonto i stedet at bruge dedikerede bilag. Du kan bogfõre alle typer finansielle salgstransaktioner, herunder betalinger, refusioner og finansgebyrbelõb. Bemërk, at du ikke kan bogfõre varebeholdninger med en salgskladde.;
                                 ENU=Post any sales-related transaction directly to a customer, bank, or general ledger account instead of using dedicated documents. You can post all types of financial sales transactions, including payments, refunds, and finance charge amounts. Note that you cannot post item quantities with a sales journal.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 251;
                      RunPageView=WHERE(Template Type=CONST(Sales),
                                        Recurring=CONST(No)) }
      { 10      ;1   ;Action    ;
                      Name=CashReceiptJournals;
                      CaptionML=[DAN=Indbetalingskladder;
                                 ENU=Cash Receipt Journals];
                      ToolTipML=[DAN=Registrer modtagne betalinger ved at udligne dem manuelt for de relaterede debitor-, kreditor- eller bankposter. Bogfõr derefter betalingerne til finanskontiene, sÜ du kan lukke de relaterede poster.;
                                 ENU=Register received payments by manually applying them to the related customer, vendor, or bank ledger entries. Then, post the payments to G/L accounts and thereby close the related ledger entries.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 251;
                      RunPageView=WHERE(Template Type=CONST(Cash Receipts),
                                        Recurring=CONST(No));
                      Image=Journals }
      { 20      ;1   ;Action    ;
                      CaptionML=[DAN=Overflytningsordrer;
                                 ENU=Transfer Orders];
                      ToolTipML=[DAN=Flyt lagervarer mellem lokationer for virksomheden. Med overflytningsordrer kan du sende udgÜende overflytninger fra Çn lokation og modtage den indgÜende overfõrsel pÜ den anden lokation. Derved kan du administrere de involverede lageraktiviteter, og det õger sikkerheden for, at vareantallet opdateres korrekt.;
                                 ENU=Move inventory items between company locations. With transfer orders, you ship the outbound transfer from one location and receive the inbound transfer at the other location. This allows you to manage the involved warehouse activities and provides more certainty that inventory quantities are updated correctly.];
                      ApplicationArea=#Location;
                      RunObject=Page 5742 }
      { 1900000012;0 ;ActionContainer;
                      ActionContainerType=ActivityButtons }
      { 39      ;1   ;ActionGroup;
                      CaptionML=[DAN=Bogfõrte dokumenter;
                                 ENU=Posted Documents];
                      ToolTipML=[DAN=Vis historik over salg, leverancer og lager.;
                                 ENU=View history for sales, shipments, and inventory.];
                      Image=FiledPosted }
      { 40      ;2   ;Action    ;
                      CaptionML=[DAN=Bogf. salgsleverancer;
                                 ENU=Posted Sales Shipments];
                      ToolTipML=[DAN=èbn listen over bogfõrte salgsleverancer.;
                                 ENU=Open the list of posted sales shipments.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 142;
                      Image=PostedShipment }
      { 32      ;2   ;Action    ;
                      CaptionML=[DAN=Bogf. salgsfakturaer;
                                 ENU=Posted Sales Invoices];
                      ToolTipML=[DAN=èbn listen over bogfõrte salgsfakturaer.;
                                 ENU=Open the list of posted sales invoices.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 143;
                      Image=PostedOrder }
      { 33      ;2   ;Action    ;
                      CaptionML=[DAN=Bogfõrte returvaremodt.;
                                 ENU=Posted Return Receipts];
                      ToolTipML=[DAN=èbn listen over bogfõrte returvaremodtagelser.;
                                 ENU=Open the list of posted return receipts.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 6662;
                      Image=PostedReturnReceipt }
      { 34      ;2   ;Action    ;
                      CaptionML=[DAN=Bogf. salgskr.notaer;
                                 ENU=Posted Sales Credit Memos];
                      ToolTipML=[DAN=èbn listen over bogfõrte salgskreditnotaer.;
                                 ENU=Open the list of posted sales credit memos.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 144;
                      Image=PostedOrder }
      { 99      ;2   ;Action    ;
                      CaptionML=[DAN=Bogfõrte salgsreturordrer;
                                 ENU=Posted Sales Return Orders];
                      ToolTipML=[DAN=èbn listen over bogfõrte salgsreturordrer.;
                                 ENU=Open the list of posted sales return orders.];
                      ApplicationArea=#SalesReturnOrder;
                      RunObject=Page 6662;
                      Image=PostedOrder }
      { 53      ;2   ;Action    ;
                      CaptionML=[DAN=Bogf. kõbsmodtagelser;
                                 ENU=Posted Purchase Receipts];
                      ToolTipML=[DAN=èbn listen over bogfõrte kõbsmodtagelser.;
                                 ENU=Open the list of posted purchase receipts.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 145 }
      { 54      ;2   ;Action    ;
                      CaptionML=[DAN=Bogf. kõbsfakturaer;
                                 ENU=Posted Purchase Invoices];
                      ToolTipML=[DAN=èbn listen over bogfõrte kõbsfakturaer.;
                                 ENU=Open the list of posted purchase invoices.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 146 }
      { 17      ;2   ;Action    ;
                      CaptionML=[DAN=Bogf. overflytningsleverancer;
                                 ENU=Posted Transfer Shipments];
                      ToolTipML=[DAN=èbn listen over bogfõrte overflytningsleverancer.;
                                 ENU=Open the list of posted transfer shipments.];
                      ApplicationArea=#Location;
                      RunObject=Page 5752 }
      { 19      ;2   ;Action    ;
                      CaptionML=[DAN=Bogf. overflytn.kvitteringer;
                                 ENU=Posted Transfer Receipts];
                      ToolTipML=[DAN=èbn listen over bogfõrte overflytningsmodtagelser.;
                                 ENU=Open the list of posted transfer receipts.];
                      ApplicationArea=#Location;
                      RunObject=Page 5753 }
      { 57      ;1   ;ActionGroup;
                      CaptionML=[DAN=Selvbetjening;
                                 ENU=Self-Service];
                      ToolTipML=[DAN=Administrer dine timesedler og opgaver.;
                                 ENU=Manage your time sheets and assignments.];
                      Image=HumanResources }
      { 24      ;2   ;Action    ;
                      CaptionML=[DAN=Timesedler;
                                 ENU=Time Sheets];
                      ToolTipML=[DAN=Giv ressourcer mulighed for at tidsregistere. Efter godkendelsen, hvis en sÜdan krëves, kan timeseddelposterne bogfõres for den relevante sagskladde eller ressourcekladde som en del af registreringen af projektforlõbet. Hvis du vil spare konfigurationstid og sikre, at dataene er korrekte, kan du kopiere sagsplanlëgningslinjerne til timesedlerne.;
                                 ENU=Enable resources to register time. When approved, if approval is required, time sheet entries can be posted to the relevant job journal or resource journal as part of project progress reporting. To save setup time and to ensure data correctness, you can copy job planning lines into time sheets.];
                      ApplicationArea=#Suite;
                      RunObject=Page 951;
                      Gesture=None }
      { 60      ;2   ;Action    ;
                      Name=Page Time Sheet List Open;
                      CaptionML=[DAN=èbn;
                                 ENU=Open];
                      ToolTipML=[DAN=èbn kortet for den valgte record.;
                                 ENU=Open the card for the selected record.];
                      ApplicationArea=#Suite;
                      RunObject=Page 951;
                      RunPageView=WHERE(Open Exists=CONST(Yes)) }
      { 59      ;2   ;Action    ;
                      Name=Page Time Sheet List Submitted;
                      CaptionML=[DAN=Sendt;
                                 ENU=Submitted];
                      ToolTipML=[DAN=FÜ vist sendte timesedler.;
                                 ENU=View submitted time sheets.];
                      ApplicationArea=#Suite;
                      RunObject=Page 951;
                      RunPageView=WHERE(Submitted Exists=CONST(Yes)) }
      { 58      ;2   ;Action    ;
                      Name=Page Time Sheet List Rejected;
                      CaptionML=[DAN=Afvist;
                                 ENU=Rejected];
                      ToolTipML=[DAN=FÜ vist afviste timesedler.;
                                 ENU=View rejected time sheets.];
                      ApplicationArea=#Suite;
                      RunObject=Page 951;
                      RunPageView=WHERE(Rejected Exists=CONST(Yes)) }
      { 56      ;2   ;Action    ;
                      Name=Page Time Sheet List Approved;
                      CaptionML=[DAN=Godkendt;
                                 ENU=Approved];
                      ToolTipML=[DAN=FÜ vist godkendte timesedler.;
                                 ENU=View approved time sheets.];
                      ApplicationArea=#Suite;
                      RunObject=Page 951;
                      RunPageView=WHERE(Approved Exists=CONST(Yes)) }
      { 16      ;0   ;ActionContainer;
                      ActionContainerType=NewDocumentItems }
      { 18      ;1   ;Action    ;
                      CaptionML=[DAN=&Salgstilbud;
                                 ENU=Sales &Quote];
                      ToolTipML=[DAN=Tilbyd varer eller servicer til en debitor.;
                                 ENU=Offer items or services to a customer.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 41;
                      Promoted=No;
                      Image=NewSalesQuote;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 15      ;1   ;Action    ;
                      CaptionML=[DAN=Salgs&faktura;
                                 ENU=Sales &Invoice];
                      ToolTipML=[DAN=Opret en ny faktura for salget af varer eller servicer. Fakturamëngder kan ikke bogfõres delvist.;
                                 ENU=Create a new invoice for the sales of items or services. Invoice quantities cannot be posted partially.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 43;
                      Promoted=No;
                      Image=NewSalesInvoice;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 12      ;1   ;Action    ;
                      CaptionML=[DAN=&Salgsordre;
                                 ENU=Sales &Order];
                      ToolTipML=[DAN=Opret en ny salgsordre for varer eller servicer.;
                                 ENU=Create a new sales order for items or services.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 42;
                      Promoted=No;
                      Image=Document;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 9       ;1   ;Action    ;
                      CaptionML=[DAN=&Salgsreturvareordre;
                                 ENU=Sales &Return Order];
                      ToolTipML=[DAN=Kompenser dine kunder for forkerte eller beskadigede varer, som du har sendt til dem og modtaget betaling for. Salgsreturvareordrer gõr det muligt at modtage varer fra flere salgsbilag med samme salgsreturnering, automatisk oprette de relaterede salgskreditnotaer eller andre returneringsbilag, f.eks. en erstatningssalgsordre, og understõtte bilag for lagerekspeditionen. Bemërk: Hvis et fejlbehëftet salg endnu ikke er betalt, kan du blot annullere den bogfõrte salgsfaktura for automatisk at tilbagefõre den õkonomiske transaktion.;
                                 ENU=Compensate your customers for incorrect or damaged items that you sent to them and received payment for. Sales return orders enable you to receive items from multiple sales documents with one sales return, automatically create related sales credit memos or other return-related documents, such as a replacement sales order, and support warehouse documents for the item handling. Note: If an erroneous sale has not been paid yet, you can simply cancel the posted sales invoice to automatically revert the financial transaction.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 6630;
                      Promoted=No;
                      Image=ReturnOrder;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 8       ;1   ;Action    ;
                      CaptionML=[DAN=Salgs&kreditnota;
                                 ENU=Sales &Credit Memo];
                      ToolTipML=[DAN=Opret en ny salgskreditnota for at tilbagefõre en bogfõrt salgsfaktura.;
                                 ENU=Create a new sales credit memo to revert a posted sales invoice.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 44;
                      Promoted=No;
                      Image=CreditMemo;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 35      ;1   ;ActionGroup;
                      CaptionML=[DAN=Opgaver;
                                 ENU=Tasks] }
      { 36      ;2   ;Action    ;
                      CaptionML=[DAN=Salgskla&dde;
                                 ENU=Sales &Journal];
                      ToolTipML=[DAN=èbn en salgskladde, hvor du kan massebogfõre salgstransaktioner til finans-, bank-, debitor-, kreditor- og anlëgskonti.;
                                 ENU=Open a sales journal where you can batch post sales transactions to G/L, bank, customer, vendor and fixed assets accounts.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 253;
                      Image=Journals }
      { 38      ;2   ;Action    ;
                      CaptionML=[DAN=Salgspriskladd&e;
                                 ENU=Sales Price &Worksheet];
                      ToolTipML=[DAN=Administrer salgspriser for individuelle debitorer, for en debitorgruppe, for alle debitorer eller for en kampagne.;
                                 ENU=Manage sales prices for individual customers, for a group of customers, for all customers, or for a campaign.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 7023;
                      Image=PriceWorksheet }
      { 42      ;1   ;ActionGroup;
                      CaptionML=[DAN=Salg;
                                 ENU=Sales] }
      { 43      ;2   ;Action    ;
                      CaptionML=[DAN=&Priser;
                                 ENU=&Prices];
                      ToolTipML=[DAN=Angiv forskellige priser for de varer, du sëlger til kunden. En varepris anfõres automatisk pÜ fakturalinjer, nÜr de specificerede kriterier er blevet opfyldt, f.eks. kunde, mëngde eller slutdato.;
                                 ENU=Set up different prices for items that you sell to the customer. An item price is automatically granted on invoice lines when the specified criteria are met, such as customer, quantity, or ending date.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 7002;
                      Image=SalesPrices }
      { 44      ;2   ;Action    ;
                      CaptionML=[DAN=&Linjerabat;
                                 ENU=&Line Discounts];
                      ToolTipML=[DAN=Angiv forskellige rabatter for de varer, du sëlger til debitoren. En varerabat anfõres automatisk pÜ fakturalinjer, nÜr de specificerede kriterier er blevet opfyldt, f.eks. debitor, mëngde eller slutdato.;
                                 ENU=Set up different discounts for items that you sell to the customer. An item discount is automatically granted on invoice lines when the specified criteria are met, such as customer, quantity, or ending date.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 7004;
                      Image=SalesLineDisc }
      { 27      ;1   ;ActionGroup;
                      CaptionML=[DAN=Rapporter;
                                 ENU=Reports] }
      { 55      ;2   ;ActionGroup;
                      CaptionML=[DAN=Debitor;
                                 ENU=Customer];
                      Image=Customer }
      { 48      ;3   ;Action    ;
                      CaptionML=[DAN=Debitor - &ordreoversigt;
                                 ENU=Customer - &Order Summary];
                      ToolTipML=[DAN=Vis den ikke-leverede beholdning pr. debitor i tre perioder Ö 30 dage med udgangspunkt i en valgt dato. Der vises desuden kolonner med ordrer, der skal leveres fõr og efter de tre perioder, og en kolonne med ordrebeholdningen pr. debitor i alt. Rapporten kan f.eks. bruges til at analysere virksomhedens forventede omsëtning.;
                                 ENU=View the quantity not yet shipped for each customer in three periods of 30 days each, starting from a selected date. There are also columns with orders to be shipped before and after the three periods and a column with the total order detail for each customer. The report can be used to analyze a company's expected sales volume.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 107;
                      Image=Report }
      { 41      ;3   ;Action    ;
                      CaptionML=[DAN=Debitor - &top 10-liste;
                                 ENU=Customer - &Top 10 List];
                      ToolTipML=[DAN=Vis de debitorer, der kõber mest, eller som skylder mest, i en bestemt periode. Kun de debitorer, der har kõb i lõbet af perioden eller en saldo ved periodens afslutning, vil blive vist i rapporten.;
                                 ENU=View which customers purchase the most or owe the most in a selected period. Only customers that have either purchases during the period or a balance at the end of the period will be included.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 111;
                      Image=Report }
      { 37      ;3   ;Action    ;
                      CaptionML=[DAN=Kunde/va&restatistik;
                                 ENU=Customer/&Item Sales];
                      ToolTipML=[DAN=Vis en oversigt over varesalg i den valgte periode for hver debitor. Rapporten viser oplysninger om antal, salgsbelõb, avance og eventuel rabat. Du kan f.eks. bruge rapporten til at analysere kundegrupper.;
                                 ENU=View a list of item sales for each customer during a selected time period. The report contains information on quantity, sales amount, profit, and possible discounts. It can be used, for example, to analyze a company's customer groups.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 113;
                      Image=Report }
      { 31      ;2   ;ActionGroup;
                      CaptionML=[DAN=Salg;
                                 ENU=Sales];
                      Image=Sales }
      { 30      ;3   ;Action    ;
                      CaptionML=[DAN=S&ëlger - salgsstatistik;
                                 ENU=Salesperson - Sales &Statistics];
                      ToolTipML=[DAN=Vis belõb for salg, avancebelõb, fakturarabat og kontantrabat samt avanceprocent for hver sëlger i den valgte periode. Desuden viser rapporten reguleret avance og reguleret avanceprocent, som afspejler evt. ëndringer i den oprindelige belõb for de varer, der indgÜr i salget.;
                                 ENU=View amounts for sales, profit, invoice discount, and payment discount, as well as profit percentage, for each salesperson for a selected period. The report also shows the adjusted profit and adjusted profit percentage, which reflect any changes to the original costs of the items in the sales.];
                      ApplicationArea=#Suite;
                      RunObject=Report 114;
                      Image=Report }
      { 29      ;3   ;Action    ;
                      CaptionML=[DAN=Pris&liste;
                                 ENU=Price &List];
                      ToolTipML=[DAN=Vis en liste over dine varer samt oplysninger om priser og omkostninger pÜ disse med henblik pÜ at sende den til debitorerne. Du kan oprette listen til specifikke debitorer, kampagner, valutaer eller til andre formÜl.;
                                 ENU=View a list of your items and their prices, for example, to send to customers. You can create the list for specific customers, campaigns, currencies, or other criteria.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 715;
                      Image=Report }
      { 28      ;3   ;Action    ;
                      CaptionML=[DAN=Vare - rest&ordrer til kunder;
                                 ENU=Inventory - Sales &Back Orders];
                      ToolTipML=[DAN=Vis en oversigt med de ordrelinjer, hvor afsendelsesdatoen er overskredet. Der vises fõlgende oplysninger for de enkelte ordrer pÜ hver vare: nummer, debitornavn, debitorens telefonnummer, afsendelsesdato, ordrestõrrelse og antal i restordre. Rapporten viser ogsÜ, om kunden har andre varer i restordre.;
                                 ENU=View a list with the order lines whose shipment date has been exceeded. The following information is shown for the individual orders for each item: number, customer name, customer's telephone number, shipment date, order quantity and quantity on back order. The report also shows whether there are other items for the customer on back order.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 718;
                      Image=Report }
      { 45      ;1   ;ActionGroup;
                      CaptionML=[DAN=Oversigt;
                                 ENU=History] }
      { 46      ;2   ;Action    ;
                      CaptionML=[DAN=&Naviger;
                                 ENU=Navi&gate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes til bilagsnummeret og bogfõringsdatoen pÜ den valgte post eller det valgte bilag.;
                                 ENU=Find all entries and documents that exist for the document number and posting date on the selected entry or document.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 344;
                      Image=Navigate }
    }
  }
  CONTROLS
  {
    { 1900000008;0;Container;
                ContainerType=RoleCenterArea }

    { 1900724808;1;Group   }

    { 1901851508;2;Part   ;
                AccessByPermission=TableData 110=R;
                ApplicationArea=#Basic,#Suite;
                PagePartID=Page9060;
                PartType=Page }

    { 14  ;2   ;Part      ;
                ApplicationArea=#Suite;
                PagePartID=Page9042;
                PartType=Page }

    { 1907692008;2;Part   ;
                ApplicationArea=#Basic,#Suite;
                PagePartID=Page9150;
                PartType=Page }

    { 13  ;2   ;Part      ;
                ApplicationArea=#Basic,#Suite;
                PagePartID=Page6303;
                PartType=Page }

    { 1900724708;1;Group   }

    { 1   ;2   ;Part      ;
                AccessByPermission=TableData 110=R;
                ApplicationArea=#Basic,#Suite;
                PagePartID=Page760;
                PartType=Page }

    { 4   ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page675;
                Visible=false;
                PartType=Page }

    { 1905989608;2;Part   ;
                AccessByPermission=TableData 9152=R;
                ApplicationArea=#Basic,#Suite;
                PagePartID=Page9152;
                PartType=Page }

    { 21  ;2   ;Part      ;
                AccessByPermission=TableData 477=R;
                ApplicationArea=#Suite;
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

