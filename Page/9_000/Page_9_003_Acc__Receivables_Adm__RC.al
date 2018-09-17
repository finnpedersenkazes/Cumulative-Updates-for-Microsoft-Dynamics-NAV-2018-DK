OBJECT Page 9003 Acc. Receivables Adm. RC
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232,NAVDK11.00.00.24232;
  }
  PROPERTIES
  {
    CaptionML=[@@@="{Dependency=Match,""ProfileDescription_ARADMINISTRATOR""}";
               DAN=Administrator af tilgodehavender;
               ENU=Accounts Receivable Administrator];
    PageType=RoleCenter;
    ActionList=ACTIONS
    {
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 9       ;1   ;Action    ;
                      CaptionML=[DAN=D&ebitor - stamoplysninger;
                                 ENU=C&ustomer - List];
                      ToolTipML=[DAN=Vis diverse stamoplysninger om debitorer, f.eks. debitorbogf�ringsgruppe, rabatgruppe, rente- og betalingsoplysninger, s�lger, debitors basisvaluta, kreditmaksimum (i RV) og debitorens aktuelle saldo (i RV).;
                                 ENU=View various information for customers, such as customer posting group, discount group, finance charge and payment information, salesperson, the customer's default currency and credit limit (in LCY), and the customer's current balance (in LCY).];
                      ApplicationArea=#Advanced;
                      RunObject=Report 101;
                      Image=Report }
      { 13      ;1   ;Action    ;
                      CaptionML=[DAN=Debitor - &saldo til dato;
                                 ENU=Customer - &Balance to Date];
                      ToolTipML=[DAN=Vis en liste over debitorers betalingshistorik op til en bestemt dato. Du kan bruge rapporten til at udtr�kke oplysninger om din samlede salgsindkomst ved slutningen af en regnskabsperiode eller et regnskabs�r.;
                                 ENU=View a list with customers' payment history up until a certain date. You can use the report to extract your total sales income at the close of an accounting period or fiscal year.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 121;
                      Image=Report }
      { 16      ;1   ;Action    ;
                      CaptionML=[DAN=Aldersf&ordelte tilgodehavender;
                                 ENU=Aged &Accounts Receivable];
                      ToolTipML=[DAN=Vis en oversigt over, hvorn�r dine tilgodehavender fra debitorer skal betales eller rykkes for (opdelt i fire tidsperioder). Du skal angive den dato, som aldersfordelingen skal beregnes ud fra, og du skal angive den periode, som hver kolonne skal indeholde data for.;
                                 ENU=View an overview of when your receivables from customers are due or overdue (divided into four periods). You must specify the date you want aging calculated from and the length of the period that each column will contain data for.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 120;
                      Image=Report }
      { 17      ;1   ;Action    ;
                      CaptionML=[DAN=Debitor - &aldersfordelt saldo;
                                 ENU=Customer - &Summary Aging Simp.];
                      ToolTipML=[DAN=Vis, udskriv eller gem en oversigt over hver debitors samlede forfaldne betalinger, opdelt i tre tidsperioder. Rapporten kan bruges til at bestemme, hvorn�r der skal udstedes rykkere, til at vurdere en debitors kreditv�rdighed eller til at udarbejde likviditetsanalyser.;
                                 ENU=View, print, or save a summary of each customer's total payments due, divided into three time periods. The report can be used to decide when to issue reminders, to evaluate a customer's creditworthiness, or to prepare liquidity analyses.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 109;
                      Image=Report }
      { 18      ;1   ;Action    ;
                      CaptionML=[DAN=Debitor - balan&ce;
                                 ENU=Customer - Trial Balan&ce];
                      ToolTipML=[DAN=Vis start- og slutsaldi for debitorer med poster i en bestemt periode. Rapporten kan bruges til at bekr�fte, at saldoen for en debitorbogf�ringsgruppe svarer til saldoen p� den tilsvarende finanskonto p� en bestemt dato.;
                                 ENU=View the beginning and ending balance for customers with entries within a specified period. The report can be used to verify that the balance for a customer posting group is equal to the balance on the corresponding general ledger account on a certain date.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 129;
                      Image=Report }
      { 19      ;1   ;Action    ;
                      CaptionML=[DAN=&Kunde/varestatistik;
                                 ENU=Cus&tomer/Item Sales];
                      ToolTipML=[DAN=Vis en oversigt over varesalg i den valgte periode for hver debitor. Rapporten viser oplysninger om antal, salgsbel�b, avance og eventuel rabat. Du kan f.eks. bruge rapporten til at analysere en virksomheds debitorgrupper.;
                                 ENU=View a list of item sales for each customer during a selected time period. The report contains information on quantity, sales amount, profit, and possible discounts. It can be used, for example, to analyze a company's customer groups.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 113;
                      Image=Report }
      { 20      ;1   ;Separator  }
      { 22      ;1   ;Action    ;
                      CaptionML=[DAN=&Debitorbilagsnumre;
                                 ENU=Customer &Document Nos.];
                      ToolTipML=[DAN=F� vist en liste over debitorposter, sorteret efter dokumenttype og nummer. Rapporten viser bl.a. dokumenttype, bilagsnummer, bogf�ringsdato samt kildespor for posten, navn og nummer p� debitoren osv. Der vises en advarsel, hvis der er et hul i nummerserien, eller hvis bilagene ikke blev bogf�rt i nummerorden.;
                                 ENU=View a list of customer ledger entries, sorted by document type and number. The report includes the document type, document number, posting date and source code of the entry, the name and number of the customer, and so on. A warning appears when there is a gap in the number series or when the documents were not posted in document-number order.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 128;
                      Image=Report }
      { 23      ;1   ;Action    ;
                      CaptionML=[DAN=Salgs&fakturanumre;
                                 ENU=Sales &Invoice Nos.];
                      ToolTipML=[DAN=Vis eller rediger nummerserien til salgsfakturaer.;
                                 ENU=View or edit number series for sales invoices.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 124;
                      Image=Report }
      { 24      ;1   ;Action    ;
                      CaptionML=[DAN=Sa&lgskreditnotanumre;
                                 ENU=Sa&les Credit Memo Nos.];
                      ToolTipML=[DAN=Vis eller rediger nummerserien til salgskreditnotaer.;
                                 ENU=View or edit number series for sales credit memos.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 125;
                      Image=Report }
      { 27      ;1   ;Action    ;
                      CaptionML=[DAN=Rykkernu&mre;
                                 ENU=Re&minder Nos.];
                      ToolTipML=[DAN=Vis eller angiv nummerserien for rykkere.;
                                 ENU=View or set up number series for reminders.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 126;
                      Image=Report }
      { 28      ;1   ;Action    ;
                      CaptionML=[DAN=Rentenotanum&re;
                                 ENU=Finance Cha&rge Memo Nos.];
                      ToolTipML=[DAN=Vis eller rediger nummerserien til rentenotaer.;
                                 ENU=View or edit number series for finance charge memos.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 127;
                      Image=Report }
      { 1900000011;0 ;ActionContainer;
                      ActionContainerType=HomeItems }
      { 12      ;1   ;Action    ;
                      Name=Customers;
                      CaptionML=[DAN=Debitorer;
                                 ENU=Customers];
                      ToolTipML=[DAN=F� vist eller rediger detaljerede oplysninger om de debitorer, som du handler med. Fra det enkelte debitorkort kan du f� adgang til relaterede oplysninger som f.eks. salgsstatistik og igangv�rende ordrer, og du kan definere specialpriser og linjerabatter, som debitoren f�r, n�r bestemte betingelser er opfyldt.;
                                 ENU=View or edit detailed information for the customers that you trade with. From each customer card, you can open related information, such as sales statistics and ongoing orders, and you can define special prices and line discounts that you grant if certain conditions are met.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 22;
                      Image=Customer }
      { 2       ;1   ;Action    ;
                      Name=CustomersBalance;
                      CaptionML=[DAN=Saldo;
                                 ENU=Balance];
                      ToolTipML=[DAN=Se en oversigt over kontosaldoen i forskellige perioder.;
                                 ENU=View a summary of the bank account balance in different periods.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 22;
                      RunPageView=WHERE(Balance (LCY)=FILTER(<>0));
                      Image=Balance }
      { 14      ;1   ;Action    ;
                      CaptionML=[DAN=Salgsordrer;
                                 ENU=Sales Orders];
                      ToolTipML=[DAN=Registrer dine aftaler med debitorer for at s�lge bestemte varer p� bestemte leverings- og betalingsbetingelser. Salgsordrer g�r det i mods�tning til salgsfakturaer muligt at levere delvist, levere direkte fra kreditoren til debitoren, starte lagerekspedition og udskrive forskellige dokumenter til kunderne. Salgsfakturering er integreret i salgsordreprocessen.;
                                 ENU=Record your agreements with customers to sell certain products on certain delivery and payment terms. Sales orders, unlike sales invoices, allow you to ship partially, deliver directly from your vendor to your customer, initiate warehouse handling, and print various customer-facing documents. Sales invoicing is integrated in the sales order process.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9305;
                      Image=Order }
      { 92      ;1   ;Action    ;
                      CaptionML=[DAN=Salgsfakturaer;
                                 ENU=Sales Invoices];
                      ToolTipML=[DAN=Registrer dit salg til debitorer, og inviter dem til at betale i henhold til leverings- og betalingsbetingelserne ved at sende dem et salgsfakturadokument. Bogf�ring af en salgsfaktura registrerer leveringen og registrerer en �ben tilgodehavendepost p� debitorens konto, som vil blive lukket, n�r betalingen er modtaget. Brug salgsordrer, hvor salgsfaktureringen er integreret, til at administrere leveringsprocessen.;
                                 ENU=Register your sales to customers and invite them to pay according to the delivery and payment terms by sending them a sales invoice document. Posting a sales invoice registers shipment and records an open receivable entry on the customer's account, which will be closed when payment is received. To manage the shipment process, use sales orders, in which sales invoicing is integrated.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9301;
                      Image=Invoice }
      { 3       ;1   ;Action    ;
                      CaptionML=[DAN=Salgsreturvareordrer;
                                 ENU=Sales Return Orders];
                      ToolTipML=[DAN=Kompenser dine kunder for forkerte eller beskadigede varer, som du har sendt til dem og modtaget betaling for. Salgsreturvareordrer g�r det muligt at modtage varer fra flere salgsbilag med samme salgsreturnering, automatisk oprette de relaterede salgskreditnotaer eller andre returneringsbilag, f.eks. en erstatningssalgsordre, og underst�tte bilag for lagerekspeditionen. Bem�rk: Hvis et fejlbeh�ftet salg endnu ikke er betalt, kan du blot annullere den bogf�rte salgsfaktura for automatisk at tilbagef�re den �konomiske transaktion.;
                                 ENU=Compensate your customers for incorrect or damaged items that you sent to them and received payment for. Sales return orders enable you to receive items from multiple sales documents with one sales return, automatically create related sales credit memos or other return-related documents, such as a replacement sales order, and support warehouse documents for the item handling. Note: If an erroneous sale has not been paid yet, you can simply cancel the posted sales invoice to automatically revert the financial transaction.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9304;
                      Image=ReturnOrder }
      { 5       ;1   ;Action    ;
                      CaptionML=[DAN=Bankkonti;
                                 ENU=Bank Accounts];
                      ToolTipML=[DAN=F� vist eller konfigurer detaljerede oplysninger om din bankkonto, f.eks. hvilken valuta der skal bruges, formatet p� de bankfiler, du importerer og eksporterer som elektroniske betalinger, samt nummereringen af checks.;
                                 ENU=View or set up detailed information about your bank account, such as which currency to use, the format of bank files that you import and export as electronic payments, and the numbering of checks.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 371;
                      Image=BankAccount }
      { 6       ;1   ;Action    ;
                      CaptionML=[DAN=Rykkere;
                                 ENU=Reminders];
                      ToolTipML=[DAN=P�mind debitorer om forfaldne bel�b ud fra rykkerbetingelserne og de relaterede rykkerniveauer. Hvert rykkerniveau omfatter regler om, hvorn�r rykkeren skal udstedes i forhold til fakturaens forfaldsdato eller datoen for den forrige rykker, og om der p�l�ber renter. Rykkerne integreres i rentenotaerne, som er dokumenter, der informerer debitorerne om renter eller andre skyldige sanktioner for forsinket betaling.;
                                 ENU=Remind customers about overdue amounts based on reminder terms and the related reminder levels. Each reminder level includes rules about when the reminder will be issued in relation to the invoice due date or the date of the previous reminder and whether interests are added. Reminders are integrated with finance charge memos, which are documents informing customers of interests or other money penalties for payment delays.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 436;
                      Image=Reminder }
      { 7       ;1   ;Action    ;
                      CaptionML=[DAN=Rentenotaer;
                                 ENU=Finance Charge Memos];
                      ToolTipML=[DAN=Send rentenotaer til debitorer med forsinkede betalinger, hvilket typisk f�lger efter en rykkerprocedure. Renter beregnes automatisk og f�jes til de forfaldne bel�b p� debitorens konto i henhold til de angivne rentebetingelser og sanktions- eller rentebel�b.;
                                 ENU=Send finance charge memos to customers with delayed payments, typically following a reminder process. Finance charges are calculated automatically and added to the overdue amounts on the customer's account according to the specified finance charge terms and penalty/interest amounts.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 448;
                      Image=FinChargeMemo }
      { 8       ;1   ;Action    ;
                      CaptionML=[DAN=Varer;
                                 ENU=Items];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om de produkter, du handler med. Varekortet kan v�re af typen lager eller tjeneste for at angive, om varen er en fysisk enhed eller en best�r af arbejdstimer. Her angiver du ogs�, om varerne p� lager eller i indg�ende ordrer automatisk reserveres til udg�ende bilag, og om der er oprettet ordresporingsbindinger mellem behov og forsyning for at afspejle planl�gningshandlinger.;
                                 ENU=View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 31;
                      Image=Item }
      { 31      ;1   ;Action    ;
                      Name=SalesJournals;
                      CaptionML=[DAN=Salgskladder;
                                 ENU=Sales Journals];
                      ToolTipML=[DAN=Bogf�r enhver transaktion, der er relateret til salg, direkte til en debitor-, bankkonto eller finanskonto i stedet at bruge dedikerede bilag. Du kan bogf�re alle typer finansielle salgstransaktioner, herunder betalinger, refusioner og finansgebyrbel�b. Bem�rk, at du ikke kan bogf�re varebeholdninger med en salgskladde.;
                                 ENU=Post any sales-related transaction directly to a customer, bank, or general ledger account instead of using dedicated documents. You can post all types of financial sales transactions, including payments, refunds, and finance charge amounts. Note that you cannot post item quantities with a sales journal.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 251;
                      RunPageView=WHERE(Template Type=CONST(Sales),
                                        Recurring=CONST(No)) }
      { 32      ;1   ;Action    ;
                      Name=CashReceiptJournals;
                      CaptionML=[DAN=Indbetalingskladder;
                                 ENU=Cash Receipt Journals];
                      ToolTipML=[DAN=Registrer modtagne betalinger ved at udligne dem manuelt for de relaterede debitor-, kreditor- eller bankposter. Bogf�r derefter betalingerne til finanskontiene, s� du kan lukke de relaterede poster.;
                                 ENU=Register received payments by manually applying them to the related customer, vendor, or bank ledger entries. Then, post the payments to G/L accounts and thereby close the related ledger entries.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 251;
                      RunPageView=WHERE(Template Type=CONST(Cash Receipts),
                                        Recurring=CONST(No));
                      Image=Journals }
      { 33      ;1   ;Action    ;
                      Name=GeneralJournals;
                      CaptionML=[DAN=Finanskladder;
                                 ENU=General Journals];
                      ToolTipML=[DAN=Bogf�r �konomiske transaktioner direkte til finanskonti og andre konti som f.eks. bank-, debitor-, kreditor- og medarbejderkonti. Bogf�ring med en finanskladde opretter altid poster p� finanskontiene. Dette g�lder ogs�, n�r du eksempelvis bogf�rer en kladdelinje til en debitorkonto, fordi der er bogf�rt en post til finansregnskabets konto for tilgodehavender via en bogf�ringsgruppe.;
                                 ENU=Post financial transactions directly to general ledger accounts and other accounts, such as bank, customer, vendor, and employee accounts. Posting with a general journal always creates entries on general ledger accounts. This is true even when, for example, you post a journal line to a customer account, because an entry is posted to a general ledger receivables account through a posting group.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 251;
                      RunPageView=WHERE(Template Type=CONST(General),
                                        Recurring=CONST(No));
                      Image=Journal }
      { 4       ;1   ;Action    ;
                      CaptionML=[DAN=Direct Debit-opkr�vninger;
                                 ENU=Direct Debit Collections];
                      ToolTipML=[DAN=Bed din bank om at tr�kke betalingsbel�b fra debitorens bankkonto og overf�re dem til din virksomheds konto. En Direct Debit-opkr�vning indeholder oplysninger om debitorens bankkonto, de ber�rte salgsfakturaer og debitorens aftale, dvs. den s�kaldte Direct Debit-betalingsaftale. Ud fra den resulterede Direct Debit-opkr�vningspost kan du derefter eksportere en XML-fil, som du kan sende eller overf�re til din bank til behandling.;
                                 ENU=Instruct your bank to withdraw payment amounts from your customer' s bank account and transfer them to your company' s account. A direct debit collection holds information about the customer' s bank account, the affected sales invoices, and the customer's agreement, the so-called direct-debit mandate. From the resulting direct-debit collection entry, you can then export an XML file that you send or upload to your bank for processing.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 1207 }
      { 1900000012;0 ;ActionContainer;
                      ActionContainerType=ActivityButtons }
      { 39      ;1   ;ActionGroup;
                      CaptionML=[DAN=Bogf�rte dokumenter;
                                 ENU=Posted Documents];
                      Image=FiledPosted }
      { 11      ;2   ;Action    ;
                      CaptionML=[DAN=Bogf. salgsleverancer;
                                 ENU=Posted Sales Shipments];
                      ToolTipML=[DAN=�bn listen over bogf�rte salgsleverancer.;
                                 ENU=Open the list of posted sales shipments.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 142;
                      Image=PostedShipment }
      { 25      ;2   ;Action    ;
                      CaptionML=[DAN=Bogf. salgsfakturaer;
                                 ENU=Posted Sales Invoices];
                      ToolTipML=[DAN=�bn listen over bogf�rte salgsfakturaer.;
                                 ENU=Open the list of posted sales invoices.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 143;
                      Image=PostedOrder }
      { 10      ;2   ;Action    ;
                      CaptionML=[DAN=Bogf�rte returvaremodt.;
                                 ENU=Posted Return Receipts];
                      ToolTipML=[DAN=�bn listen over bogf�rte returvaremodtagelser.;
                                 ENU=Open the list of posted return receipts.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 6662;
                      Image=PostedReturnReceipt }
      { 26      ;2   ;Action    ;
                      CaptionML=[DAN=Bogf. salgskr.notaer;
                                 ENU=Posted Sales Credit Memos];
                      ToolTipML=[DAN=�bn listen over bogf�rte salgskreditnotaer.;
                                 ENU=Open the list of posted sales credit memos.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 144;
                      Image=PostedOrder }
      { 34      ;2   ;Action    ;
                      CaptionML=[DAN=Bogf. k�bsfakturaer;
                                 ENU=Posted Purchase Invoices];
                      ToolTipML=[DAN=�bn listen over bogf�rte k�bsfakturaer.;
                                 ENU=Open the list of posted purchase invoices.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 146 }
      { 35      ;2   ;Action    ;
                      CaptionML=[DAN=Bogf�rte k�bskreditnotaer;
                                 ENU=Posted Purchase Credit Memos];
                      ToolTipML=[DAN=�bn listen over bogf�rte k�bskreditnotaer.;
                                 ENU=Open the list of posted purchase credit memos.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 147 }
      { 29      ;2   ;Action    ;
                      CaptionML=[DAN=Udstedte rykkere;
                                 ENU=Issued Reminders];
                      ToolTipML=[DAN=Vis oversigten over udstedte rykkere.;
                                 ENU=View the list of issued reminders.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 440;
                      Image=OrderReminder }
      { 30      ;2   ;Action    ;
                      CaptionML=[DAN=Udstedte rentenotaer;
                                 ENU=Issued Fin. Charge Memos];
                      ToolTipML=[DAN=Vis oversigten over udstedte rentenotaer.;
                                 ENU=View the list of issued finance charge memos.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 452;
                      Image=PostedMemo }
      { 102     ;2   ;Action    ;
                      CaptionML=[DAN=Finansjournaler;
                                 ENU=G/L Registers];
                      ToolTipML=[DAN=Vis bogf�rte finansposter.;
                                 ENU=View posted G/L entries.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 116;
                      Image=GLRegisters }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 64      ;1   ;Separator ;
                      CaptionML=[DAN=Ny;
                                 ENU=New];
                      IsHeader=Yes }
      { 103     ;1   ;Action    ;
                      CaptionML=[DAN=D&ebitor;
                                 ENU=C&ustomer];
                      ToolTipML=[DAN=Opret et nyt debitorkort.;
                                 ENU=Create a new customer card.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 21;
                      Promoted=No;
                      Image=Customer;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 36      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Salg;
                                 ENU=&Sales];
                      Image=Sales }
      { 37      ;2   ;Action    ;
                      CaptionML=[DAN=&Salgsordre;
                                 ENU=Sales &Order];
                      ToolTipML=[DAN=Opret en ny salgsordre for varer eller servicer.;
                                 ENU=Create a new sales order for items or services.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 42;
                      Promoted=No;
                      Image=Document;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 104     ;2   ;Action    ;
                      CaptionML=[DAN=Salgs&faktura;
                                 ENU=Sales &Invoice];
                      ToolTipML=[DAN=Opret en ny faktura for salget af varer eller servicer. Fakturam�ngder kan ikke bogf�res delvist.;
                                 ENU=Create a new invoice for the sales of items or services. Invoice quantities cannot be posted partially.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 43;
                      Promoted=No;
                      Image=NewSalesInvoice;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 65      ;2   ;Action    ;
                      CaptionML=[DAN=Salgs&kreditnota;
                                 ENU=Sales &Credit Memo];
                      ToolTipML=[DAN=Opret en ny salgskreditnota for at tilbagef�re en bogf�rt salgsfaktura.;
                                 ENU=Create a new sales credit memo to revert a posted sales invoice.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 44;
                      Promoted=No;
                      Image=CreditMemo;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 105     ;2   ;Action    ;
                      CaptionML=[DAN=Re&ntenota;
                                 ENU=Sales &Fin. Charge Memo];
                      ToolTipML=[DAN=Opret en ny rentenota for at opkr�ve gebyr fra en debitor for sen betaling.;
                                 ENU=Create a new finance charge memo to fine a customer for late payment.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 446;
                      Promoted=No;
                      Image=FinChargeMemo;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 106     ;2   ;Action    ;
                      CaptionML=[DAN=R&ykker;
                                 ENU=Sales &Reminder];
                      ToolTipML=[DAN=Opret en ny rykker for en debitor, som har forfaldne betalinger.;
                                 ENU=Create a new reminder for a customer who has overdue payments.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 434;
                      Promoted=No;
                      Image=Reminder;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 67      ;1   ;Separator ;
                      CaptionML=[DAN=Opgaver;
                                 ENU=Tasks];
                      IsHeader=Yes }
      { 74      ;1   ;Action    ;
                      CaptionML=[DAN=Indbetalings&kladde;
                                 ENU=Cash Receipt &Journal];
                      ToolTipML=[DAN=�bn indbetalingskladden for at bogf�re indg�ende betalinger.;
                                 ENU=Open the cash receipt journal to post incoming payments.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 255;
                      Image=CashReceiptJournal }
      { 111     ;1   ;Separator  }
      { 112     ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Tillad sa&mlefaktura;
                                 ENU=Combine Shi&pments];
                      ToolTipML=[DAN=Inkluder alle ikke-fakturerede leverancer til samme debitor p� �n salgsfaktura.;
                                 ENU=Gather all non-invoiced shipments to the same customer on one sales invoice.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 295;
                      Image=Action }
      { 113     ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Saml returvareleverancer;
                                 ENU=Combine Return S&hipments];
                      ToolTipML=[DAN=Returner varer, der d�kkes af forskellige k�bsreturvareordrer, til den samme kreditor p� en leverance. N�r du leverer varerne, bogf�rer du de relaterede returvareordrer som leveret, og dette opretter bogf�rte returvareleverancer. N�r du er klar til at fakturere varerne, kan du oprette �n k�bskreditnota, der indeholder de bogf�rte returvareleverancelinjer automatisk, s� du kan fakturere alle de �bne k�bsreturvareordrer samtidigt.;
                                 ENU=Return items covered by different purchase return orders to the same vendor on one shipment. When you ship the items, you post the related purchase return orders as shipped and this creates posted purchase return shipments. When you are ready to invoice these items, you can create one purchase credit memo that automatically includes the posted purchase return shipment lines so that you invoice all the open purchase return orders at the same time.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 6653;
                      Image=Action }
      { 1060000 ;1   ;Action    ;
                      CaptionML=[DAN=Opret elektroniske fakturaer;
                                 ENU=Create Electronic Invoices];
                      ToolTipML=[DAN=Opret en elektronisk version af det aktuelle dokument.;
                                 ENU=Create an electronic version of the current document.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 13600;
                      Image=ElectronicDoc }
      { 1060001 ;1   ;Action    ;
                      CaptionML=[DAN=Opret elektroniske kreditnotaer;
                                 ENU=Create Electronic Credit Memos];
                      ToolTipML=[DAN=Opret en elektronisk version af det aktuelle dokument.;
                                 ENU=Create an electronic version of the current document.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 13601;
                      Image=ElectronicDoc }
      { 1060002 ;1   ;Action    ;
                      CaptionML=[DAN=Opret elektroniske rykkere;
                                 ENU=Create Electronic Reminders];
                      ToolTipML=[DAN=Opret en elektronisk version af det aktuelle dokument.;
                                 ENU=Create an electronic version of the current document.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 13602;
                      Image=Report }
      { 1060003 ;1   ;Action    ;
                      CaptionML=[DAN=Opret elektroniske rentenotaer;
                                 ENU=Create Electronic Fin. Chrg. Memos];
                      ToolTipML=[DAN=Opret en elektronisk version af det aktuelle dokument.;
                                 ENU=Create an electronic version of the current document.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 13603;
                      Image=ElectronicDoc }
      { 15      ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Opret tilbagevendende fakturaer;
                                 ENU=Create Recurring Invoices];
                      ToolTipML=[DAN="Opret salgsfakturaer i overensstemmelse med standardsalgslinjer, der er knyttet til debitorer og med bogf�ringsdatoer, der ligger inden for de gyldig fra- og gyldig til-datoer, du angiver p� standardsalgskoden. Kan ogs� bruges til SEPA Direct Debit. ";
                                 ENU="Create sales invoices according to standard sales lines that are assigned to the customers and with posting dates within the valid-from and valid-to dates that you specify on the standard sales code. Can also be used for SEPA direct debit. "];
                      ApplicationArea=#Advanced;
                      RunObject=Report 172;
                      Image=CreateDocument }
      { 84      ;1   ;Separator ;
                      CaptionML=[DAN=Ops�tning;
                                 ENU=Administration];
                      IsHeader=Yes }
      { 86      ;1   ;Action    ;
                      CaptionML=[DAN=Sal&gsops�tning;
                                 ENU=Sales && Recei&vables Setup];
                      ToolTipML=[DAN=Definer dine generelle politikker for fakturering af salg og for returneringer, som f.eks. hvorn�r krediterings- og beholdningsadvarsler skal vises, og hvordan salgsrabatter skal bogf�res. Konfigurer dine nummerserier for oprettelse af debitorer og forskellige salgsbilag.;
                                 ENU=Define your general policies for sales invoicing and returns, such as when to show credit and stockout warnings and how to post sales discounts. Set up your number series for creating customers and different sales documents.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 459;
                      Image=Setup }
      { 89      ;1   ;Separator ;
                      CaptionML=[DAN=Oversigt;
                                 ENU=History];
                      IsHeader=Yes }
      { 90      ;1   ;Action    ;
                      CaptionML=[DAN=&Naviger;
                                 ENU=Navi&gate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes for bilagsnummeret og bogf�ringsdatoen p� den valgte post eller det valgte bilag.;
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

    { 1902899408;2;Part   ;
                ApplicationArea=#Advanced;
                PagePartID=Page9034;
                PartType=Page }

    { 1900724708;1;Group   }

    { 1907692008;2;Part   ;
                ApplicationArea=#Advanced;
                PagePartID=Page9150;
                PartType=Page }

    { 1905989608;2;Part   ;
                ApplicationArea=#Advanced;
                PagePartID=Page9152;
                Visible=FALSE;
                PartType=Page }

    { 38  ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page681;
                PartType=Page }

    { 1   ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page675;
                Visible=false;
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

