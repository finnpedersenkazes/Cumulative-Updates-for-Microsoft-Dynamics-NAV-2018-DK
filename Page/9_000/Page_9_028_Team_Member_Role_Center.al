OBJECT Page 9028 Team Member Role Center
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[@@@=Use same translation as 'Profile Description' (if applicable);
               DAN=Teammedlem;
               ENU=Team Member];
    PageType=RoleCenter;
    ActionList=ACTIONS
    {
      { 6       ;0   ;ActionContainer;
                      ActionContainerType=HomeItems }
      { 5       ;1   ;Action    ;
                      CaptionML=[DAN=Timesedler;
                                 ENU=Time Sheets];
                      ToolTipML=[DAN=Giv ressourcer mulighed for at tidsregistere. Efter godkendelsen, hvis en sÜdan krëves, kan timeseddelposterne bogfõres for den relevante sagskladde eller ressourcekladde som en del af registreringen af projektforlõbet. Hvis du vil spare konfigurationstid og sikre, at dataene er korrekte, kan du kopiere sagsplanlëgningslinjerne til timesedlerne.;
                                 ENU=Enable resources to register time. When approved, if approval is required, time sheet entries can be posted to the relevant job journal or resource journal as part of project progress reporting. To save setup time and to ensure data correctness, you can copy job planning lines into time sheets.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 951 }
      { 56      ;    ;ActionContainer;
                      ActionContainerType=ActivityButtons }
      { 55      ;1   ;ActionGroup;
                      CaptionML=[DAN=Finans;
                                 ENU=Finance];
                      ToolTipML=[DAN=Opkrëv og foretag betalinger, udarbejd kontoudtog, og afstem bankkonti.;
                                 ENU=Collect and make payments, prepare statements, and reconcile bank accounts.];
                      Image=Journals }
      { 54      ;2   ;Action    ;
                      Name=GeneralJournals;
                      CaptionML=[DAN=Finanskladder;
                                 ENU=General Journals];
                      ToolTipML=[DAN=Bogfõr õkonomiske transaktioner direkte til finanskonti og andre konti som f.eks. bank-, debitor-, kreditor- og medarbejderkonti. Bogfõring med en finanskladde opretter altid poster pÜ finanskontiene. Dette gëlder ogsÜ, nÜr du eksempelvis bogfõrer en kladdelinje til en debitorkonto, fordi der er bogfõrt en post til finansregnskabets konto for tilgodehavender via en bogfõringsgruppe.;
                                 ENU=Post financial transactions directly to general ledger accounts and other accounts, such as bank, customer, vendor, and employee accounts. Posting with a general journal always creates entries on general ledger accounts. This is true even when, for example, you post a journal line to a customer account, because an entry is posted to a general ledger receivables account through a posting group.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 251;
                      RunPageView=WHERE(Template Type=CONST(General),
                                        Recurring=CONST(No));
                      Image=Journal }
      { 53      ;2   ;Action    ;
                      CaptionML=[DAN=Kontoplan;
                                 ENU=Chart of Accounts];
                      ToolTipML=[DAN=Vis kontoplanen.;
                                 ENU=View the chart of accounts.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 16 }
      { 52      ;2   ;Action    ;
                      CaptionML=[DAN=Kontoskemaer;
                                 ENU=Account Schedules];
                      ToolTipML=[DAN=FÜ indsigt i de finansielle data i din kontoplan. Kontoskemaer analyserer tal i finanskonti og sammenligner finansposter med finansbudgetposter. Eksempelvis kan du fÜ vist finansposterne som en procentsats af budgetposterne. Kontoskemaer indeholder data om de vigtigste Ürsregnskaber og visninger, f.eks. pengestrõmsdiagrammet.;
                                 ENU=Get insight into the financial data stored in your chart of accounts. Account schedules analyze figures in G/L accounts, and compare general ledger entries with general ledger budget entries. For example, you can view the general ledger entries as percentages of the budget entries. Account schedules provide the data for core financial statements and views, such as the Cash Flow chart.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 103 }
      { 51      ;2   ;Action    ;
                      CaptionML=[DAN=Finanskontokategorier;
                                 ENU=G/L Account Categories];
                      ToolTipML=[DAN=Tilpas strukturen for dit Ürsregnskab ved at knytte finanskontiene til kontokategorier. Du kan oprette kategorigrupper ved at placere underkategorier under dem. Hver gruppe viser en totalsaldo. NÜr du vëlger handlingen GenerÇr kontoskemaer, opdateres kontoskemaerne for de underliggende finansrapporter. Nëste gang du kõrer en af disse rapporter som f.eks. resultatopgõrelsen, tilfõjes der ny totaler og underposter ud fra dine ëndringer.;
                                 ENU=Personalize the structure of your financial statements by mapping general ledger accounts to account categories. You can create category groups by indenting subcategories under them. Each grouping shows a total balance. When you choose the Generate Account Schedules action, the account schedules for the underlying financial reports are updated. The next time you run one of these reports, such as the balance statement, new totals and subentries are added, based on your changes.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 790 }
      { 50      ;2   ;Action    ;
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
      { 49      ;2   ;Action    ;
                      Name=PaymentJournals;
                      CaptionML=[DAN=Udbetalingskladder;
                                 ENU=Payment Journals];
                      ToolTipML=[DAN=Registrer betalinger til kreditorer. En betalingskladde er en finanskladde, der bruges til at bogfõre udgÜende betalingstransaktioner til finansregnskab, bank, debitor, kreditor, medarbejder og anlëgskonti. Funktionerne for Lav kreditorbetalingsforslag udfylder automatisk kladden med de forfaldne betalinger. NÜr betalingerne er bogfõrt, kan du eksportere betalingerne til en bankfil med henblik pÜ overfõrsel til din bank, sÜfremt systemet er konfigureret til elektronisk betaling. Du kan ogsÜ sende computercheck fra betalingskladden.;
                                 ENU=Register payments to vendors. A payment journal is a type of general journal that is used to post outgoing payment transactions to G/L, bank, customer, vendor, employee, and fixed assets accounts. The Suggest Vendor Payments functions automatically fills the journal with payments that are due. When payments are posted, you can export the payments to a bank file for upload to your bank if your system is set up for electronic banking. You can also issue computer checks from the payment journal.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 251;
                      RunPageView=WHERE(Template Type=CONST(Payments),
                                        Recurring=CONST(No));
                      Image=Journals }
      { 48      ;2   ;Action    ;
                      CaptionML=[DAN=Bankkonti;
                                 ENU=Bank Accounts];
                      ToolTipML=[DAN=FÜ vist eller konfigurer detaljerede oplysninger om din bankkonto, f.eks. hvilken valuta der skal bruges, formatet pÜ de bankfiler, du importerer og eksporterer som elektroniske betalinger, samt nummereringen af checks.;
                                 ENU=View or set up detailed information about your bank account, such as which currency to use, the format of bank files that you import and export as electronic payments, and the numbering of checks.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 371;
                      Image=BankAccount }
      { 47      ;2   ;Action    ;
                      CaptionML=[DAN=Betalingsudligningskladder;
                                 ENU=Payment Reconciliation Journals];
                      ToolTipML=[DAN=Afstem ubetalte bilag automatisk med deres relaterede banktransaktioner ved at importere et bankkontoudtog eller en fil. I betalingsudligningskladden udlignes indgÜende eller udgÜende betalinger for din bank automatisk eller delvist automatisk med deres relaterede Übne debitor- eller kreditorposter. Alle Übne bankkontoposter i forhold til de udlignede debitor- eller kreditorposter bliver lukket, nÜr du vëlger handlingen Bogfõr betalinger og Afstem bankkontoen. Det betyder, at bankkontoen automatisk afstemmes for de betalinger, som du bogfõrer med kladden.;
                                 ENU=Reconcile unpaid documents automatically with their related bank transactions by importing a bank statement feed or file. In the payment reconciliation journal, incoming or outgoing payments on your bank are automatically, or semi-automatically, applied to their related open customer or vendor ledger entries. Any open bank account ledger entries related to the applied customer or vendor ledger entries will be closed when you choose the Post Payments and Reconcile Bank Account action. This means that the bank account is automatically reconciled for payments that you post with the journal.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 1294;
                      Image=ApplyEntries }
      { 46      ;2   ;Action    ;
                      CaptionML=[DAN=Bankkontoudtog;
                                 ENU=Bank Acc. Statements];
                      ToolTipML=[DAN=Vis kontoudtog for de valgte bankkonti. For hver banktransaktion viser rapporten en beskrivelse, et udlignet belõb, et kontoudtogsbelõb og andre oplysninger.;
                                 ENU=View statements for selected bank accounts. For each bank transaction, the report shows a description, an applied amount, a statement amount, and other information.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 389;
                      Image=BankAccountStatement }
      { 45      ;2   ;Action    ;
                      CaptionML=[DAN=Direct Debit-opkrëvninger;
                                 ENU=Direct Debit Collections];
                      ToolTipML=[DAN=Bed din bank om at trëkke betalingsbelõb fra debitorens bankkonto og overfõre dem til din virksomheds konto. En Direct Debit-opkrëvning indeholder oplysninger om debitorens bankkonto, de berõrte salgsfakturaer og debitorens aftale, dvs. den sÜkaldte Direct Debit-betalingsaftale. Ud fra den resulterede Direct Debit-opkrëvningspost kan du derefter eksportere en XML-fil, som du kan sende eller overfõre til din bank til behandling.;
                                 ENU=Instruct your bank to withdraw payment amounts from your customer' s bank account and transfer them to your company' s account. A direct debit collection holds information about the customer' s bank account, the affected sales invoices, and the customer's agreement, the so-called direct-debit mandate. From the resulting direct-debit collection entry, you can then export an XML file that you send or upload to your bank for processing.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 1207 }
      { 44      ;2   ;Action    ;
                      CaptionML=[DAN=Valutaer;
                                 ENU=Currencies];
                      ToolTipML=[DAN=FÜ vist de forskellige valutaer, du handler i, eller opdater valutakurserne ved at hente de seneste kurser fra en ekstern tjenesteudbyder.;
                                 ENU=View the different currencies that you trade in or update the exchange rates by getting the latest rates from an external service provider.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5;
                      Image=Currency }
      { 43      ;2   ;Action    ;
                      CaptionML=[DAN=Medarbejdere;
                                 ENU=Employees];
                      ToolTipML=[DAN=Administrer medarbejderoplysninger og relaterede oplysninger som f.eks. kvalifikationer og billeder, eller registrer og analysÇr medarbejderfravër. Sikring af opdaterede records om medarbejderne forenkler dine personaleopgaver. Hvis en medarbejder f.eks. skifter adresse, kan du registrere dette pÜ medarbejderkortet.;
                                 ENU=Manage employees' details and related information, such as qualifications and pictures, or register and analyze employee absence. Keeping up-to-date records about your employees simplifies personnel tasks. For example, if an employee's address changes, you register this on the employee card.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5201 }
      { 42      ;2   ;Action    ;
                      CaptionML=[DAN=Momsangivelser;
                                 ENU=VAT Statements];
                      ToolTipML=[DAN=FÜ vist en opgõrelse over de bogfõrte momsbelõb, beregn dine momsafregningsbelõb for en bestemt periode som f.eks. et kvartal, og forbered indsendelse af momsangivelsen til myndighederne.;
                                 ENU=View a statement of posted VAT amounts, calculate your VAT settlement amount for a certain period, such as a quarter, and prepare to send the settlement to the tax authorities.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 320 }
      { 40      ;2   ;Action    ;
                      CaptionML=[DAN=Intrastatkladder;
                                 ENU=Intrastat Journals];
                      ToolTipML=[DAN=Sammenfat vërdien af dine kõb og salg i relation til forretningspartnere i EU med statistik for õje, og klargõr tallene til afsendelse til den relevante myndighed.;
                                 ENU=Summarize the value of your purchases and sales with business partners in the EU for statistical purposes and prepare to send it to the relevant authority.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 327 }
      { 41      ;1   ;ActionGroup;
                      CaptionML=[DAN=Salg;
                                 ENU=Sales];
                      ToolTipML=[DAN=Opret tilbud, ordrer og kreditnotaer. Se debitorer og transaktionshistorik.;
                                 ENU=Make quotes, orders, and credit memos. See customers and transaction history.];
                      Image=Sales }
      { 39      ;2   ;Action    ;
                      Name=Sales_CustomerList;
                      CaptionML=[DAN=Debitorer;
                                 ENU=Customers];
                      ToolTipML=[DAN=FÜ vist eller rediger detaljerede oplysninger om de debitorer, som du handler med. Fra det enkelte debitorkort kan du fÜ adgang til relaterede oplysninger som f.eks. salgsstatistik og igangvërende ordrer, og du kan definere specialpriser og linjerabatter, som debitoren fÜr, nÜr bestemte betingelser er opfyldt.;
                                 ENU=View or edit detailed information for the customers that you trade with. From each customer card, you can open related information, such as sales statistics and ongoing orders, and you can define special prices and line discounts that you grant if certain conditions are met.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 22 }
      { 38      ;2   ;Action    ;
                      CaptionML=[DAN=Salgstilbud;
                                 ENU=Sales Quotes];
                      ToolTipML=[DAN=Giv tilbud til debitorer for at sëlge bestemte varer pÜ bestemte leverings- og betalingsbetingelser. NÜr du forhandler med en debitor, kan du ëndre og sende salgstilbud, sÜ mange gange du behõver. NÜr debitoren accepterer tilbuddet, skal du konvertere salgstilbuddet til en salgsfaktura eller en salgsordre, som du bruger til at behandle salget.;
                                 ENU=Make offers to customers to sell certain products on certain delivery and payment terms. While you negotiate with a customer, you can change and resend the sales quote as much as needed. When the customer accepts the offer, you convert the sales quote to a sales invoice or a sales order in which you process the sale.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 9300 }
      { 37      ;2   ;Action    ;
                      CaptionML=[DAN=Salgsordrer;
                                 ENU=Sales Orders];
                      ToolTipML=[DAN=Registrer dine aftaler med debitorer for at sëlge bestemte varer pÜ bestemte leverings- og betalingsbetingelser. Salgsordrer gõr det i modsëtning til salgsfakturaer muligt at levere delvist, levere direkte fra kreditoren til debitoren, starte lagerekspedition og udskrive forskellige dokumenter til kunderne. Salgsfakturering er integreret i salgsordreprocessen.;
                                 ENU=Record your agreements with customers to sell certain products on certain delivery and payment terms. Sales orders, unlike sales invoices, allow you to ship partially, deliver directly from your vendor to your customer, initiate warehouse handling, and print various customer-facing documents. Sales invoicing is integrated in the sales order process.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 9305 }
      { 36      ;2   ;Action    ;
                      CaptionML=[DAN=Salgsfakturaer;
                                 ENU=Sales Invoices];
                      ToolTipML=[DAN=Registrer dit salg til debitorer, og inviter dem til at betale i henhold til leverings- og betalingsbetingelserne ved at sende dem et salgsfakturadokument. Bogfõring af en salgsfaktura registrerer leveringen og registrerer en Üben tilgodehavendepost pÜ debitorens konto, som vil blive lukket, nÜr betalingen er modtaget. Brug salgsordrer, hvor salgsfaktureringen er integreret, til at administrere leveringsprocessen.;
                                 ENU=Register your sales to customers and invite them to pay according to the delivery and payment terms by sending them a sales invoice document. Posting a sales invoice registers shipment and records an open receivable entry on the customer's account, which will be closed when payment is received. To manage the shipment process, use sales orders, in which sales invoicing is integrated.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 9301 }
      { 35      ;2   ;Action    ;
                      CaptionML=[DAN=Salgskreditnotaer;
                                 ENU=Sales Credit Memos];
                      ToolTipML=[DAN=Tilbagefõr õkonomiske transaktioner, nÜr debitorerne vil annullere et kõb eller returnere forkerte eller beskadigede varer, som du har sendt til dem og modtaget betaling for. For at fÜ de rette oplysninger med, kan du oprette salgskreditnotaen ud fra den relaterede bogfõrte salgsfaktura, eller du kan oprette en ny salgskreditnota, hvor du indsëtter en kopi af fakturaoplysninger. Hvis du har brug for flere kontrol over processen for salgsreturvarer som f.eks. bilag for den fysiske lagerekspedition, skal du bruge salgsreturvareordrer, hvor salgskreditnotaer er integreret. Bemërk: Hvis et fejlbehëftet salg endnu ikke er blevet betalt, kan du blot annullere den bogfõrte salgsfaktura for automatisk at tilbagefõre den õkonomiske transaktion.;
                                 ENU=Revert the financial transactions involved when your customers want to cancel a purchase or return incorrect or damaged items that you sent to them and received payment for. To include the correct information, you can create the sales credit memo from the related posted sales invoice or you can create a new sales credit memo with copied invoice information. If you need more control of the sales return process, such as warehouse documents for the physical handling, use sales return orders, in which sales credit memos are integrated. Note: If an erroneous sale has not been paid yet, you can simply cancel the posted sales invoice to automatically revert the financial transaction.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 9302 }
      { 34      ;2   ;Action    ;
                      CaptionML=[DAN=Rykkere;
                                 ENU=Reminders];
                      ToolTipML=[DAN=PÜmind debitorer om forfaldne belõb ud fra rykkerbetingelserne og de relaterede rykkerniveauer. Hvert rykkerniveau omfatter regler om, hvornÜr rykkeren skal udstedes i forhold til fakturaens forfaldsdato eller datoen for den forrige rykker, og om der pÜlõber renter. Rykkerne integreres i rentenotaerne, som er dokumenter, der informerer debitorerne om renter eller andre skyldige sanktioner for forsinket betaling.;
                                 ENU=Remind customers about overdue amounts based on reminder terms and the related reminder levels. Each reminder level includes rules about when the reminder will be issued in relation to the invoice due date or the date of the previous reminder and whether interests are added. Reminders are integrated with finance charge memos, which are documents informing customers of interests or other money penalties for payment delays.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 436;
                      Image=Reminder }
      { 33      ;2   ;Action    ;
                      CaptionML=[DAN=Rentenotaer;
                                 ENU=Finance Charge Memos];
                      ToolTipML=[DAN=Send rentenotaer til debitorer med forsinkede betalinger, hvilket typisk fõlger efter en rykkerprocedure. Renter beregnes automatisk og fõjes til de forfaldne belõb pÜ debitorens konto i henhold til de angivne rentebetingelser og sanktions- eller rentebelõb.;
                                 ENU=Send finance charge memos to customers with delayed payments, typically following a reminder process. Finance charges are calculated automatically and added to the overdue amounts on the customer's account according to the specified finance charge terms and penalty/interest amounts.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 448;
                      Image=FinChargeMemo }
      { 32      ;2   ;Action    ;
                      CaptionML=[DAN=Bogfõrte salgsfakturaer;
                                 ENU=Posted Sales Invoices];
                      ToolTipML=[DAN=èbn listen over bogfõrte salgsfakturaer.;
                                 ENU=Open the list of posted sales invoices.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 143 }
      { 31      ;2   ;Action    ;
                      CaptionML=[DAN=Bogfõrte salgskreditnotaer;
                                 ENU=Posted Sales Credit Memos];
                      ToolTipML=[DAN=èbn listen over bogfõrte salgskreditnotaer.;
                                 ENU=Open the list of posted sales credit memos.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 144 }
      { 30      ;2   ;Action    ;
                      CaptionML=[DAN=Udstedte rykkere;
                                 ENU=Issued Reminders];
                      ToolTipML=[DAN=Vis oversigten over udstedte rykkere.;
                                 ENU=View the list of issued reminders.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 440;
                      Image=OrderReminder }
      { 29      ;2   ;Action    ;
                      CaptionML=[DAN=Udstedte rentenotaer;
                                 ENU=Issued Finance Charge Memos];
                      ToolTipML=[DAN=Vis oversigten over udstedte rentenotaer.;
                                 ENU=View the list of issued finance charge memos.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 452;
                      Image=PostedMemo }
      { 28      ;1   ;ActionGroup;
                      CaptionML=[DAN=Indkõb;
                                 ENU=Purchasing];
                      ToolTipML=[DAN=Administrer kõbsfakturaer og kreditnotaer. Vedligehold kreditorer og historikken over disse.;
                                 ENU=Manage purchase invoices and credit memos. Maintain vendors and their history.];
                      Image=AdministrationSalesPurchases }
      { 27      ;2   ;Action    ;
                      Name=Purchase_VendorList;
                      CaptionML=[DAN=Kreditorer;
                                 ENU=Vendors];
                      ToolTipML=[DAN=FÜ vist eller rediger detaljerede oplysninger om de kreditorer, som du handler med. Fra det enkelte kreditorkort kan du fÜ adgang til relaterede oplysninger som f.eks. kõbsstatistik og igangvërende ordrer, og du kan definere specialpriser og linjerabatter, som kreditoren giver dig, nÜr bestemte betingelser er opfyldt.;
                                 ENU=View or edit detailed information for the vendors that you trade with. From each vendor card, you can open related information, such as purchase statistics and ongoing orders, and you can define special prices and line discounts that the vendor grants you if certain conditions are met.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 27 }
      { 26      ;2   ;Action    ;
                      CaptionML=[DAN=IndgÜende bilag;
                                 ENU=Incoming Documents];
                      ToolTipML=[DAN=HÜndter indgÜende bilag, f.eks. kreditorfakturaer i PDF- eller billedfiler, som kan bruges til manuel eller automatisk konvertering til bilagsrecords, f.eks. kõbsfakturaer. De eksterne filer, der reprësenterer indgÜende bilag, kan knyttes til ethvert procestrin, herunder bogfõrte bilag og de resulterende kreditor-, debitor- og finansposter.;
                                 ENU=Handle incoming documents, such as vendor invoices in PDF or as image files, that you can manually or automatically convert to document records, such as purchase invoices. The external files that represent incoming documents can be attached at any process stage, including to posted documents and to the resulting vendor, customer, and general ledger entries.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 190 }
      { 25      ;2   ;Action    ;
                      Name=<Page Purchase Orders>;
                      CaptionML=[DAN=Kõbsordrer;
                                 ENU=Purchase Orders];
                      ToolTipML=[DAN=Opret kõbsordrer for at afspejle de salgsbilag, som leverandõrer sender til dig. PÜ denne mÜde kan du registrere kõbsomkostninger og spore kreditorer. Bogfõringen af kõbsordrer opdaterer lagerniveauerne dynamisk, sÜ du kan minimere lageromkostningerne og levere bedre kundeservice. Kõbsordrer tillader delleverancer, modsat kõbsfakturaer, og muliggõr direkte levering fra kreditoren til debitoren. Kõbsordrer kan oprettes automatisk ud fra PDF- eller billedfiler fra dine kreditorer ved hjëlp af funktionen IndgÜende bilag.;
                                 ENU=Create purchase orders to mirror sales documents that vendors send to you. This enables you to record the cost of purchases and to track accounts payable. Posting purchase orders dynamically updates inventory levels so that you can minimize inventory costs and provide better customer service. Purchase orders allow partial receipts, unlike with purchase invoices, and enable drop shipment directly from your vendor to your customer. Purchase orders can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature.];
                      ApplicationArea=#Suite;
                      RunObject=Page 9307 }
      { 24      ;2   ;Action    ;
                      Name=<Page Purchase Invoices>;
                      CaptionML=[DAN=Kõbsfakturaer;
                                 ENU=Purchase Invoices];
                      ToolTipML=[DAN=Opret kõbsfakturaer for at afspejle de salgsbilag, som leverandõrer sender til dig. PÜ denne mÜde kan du registrere kõbsomkostninger og spore kreditorer. Bogfõringen af kõbsfakturaer opdaterer lagerniveauerne dynamisk, sÜ du kan minimere lageromkostningerne og levere bedre kundeservice. Kõbsfakturaer kan oprettes automatisk ud fra PDF- eller billedfiler fra dine kreditorer ved hjëlp af funktionen IndgÜende bilag.;
                                 ENU=Create purchase invoices to mirror sales documents that vendors send to you. This enables you to record the cost of purchases and to track accounts payable. Posting purchase invoices dynamically updates inventory levels so that you can minimize inventory costs and provide better customer service. Purchase invoices can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 9308 }
      { 23      ;2   ;Action    ;
                      Name=<Page Posted Purchase Invoices>;
                      CaptionML=[DAN=Bogfõrte kõbsfakturaer;
                                 ENU=Posted Purchase Invoices];
                      ToolTipML=[DAN=èbn listen over bogfõrte kõbsfakturaer.;
                                 ENU=Open the list of posted purchase invoices.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 146 }
      { 22      ;2   ;Action    ;
                      Name=<Page Purchase Credit Memos>;
                      CaptionML=[DAN=Kõbskreditnotaer;
                                 ENU=Purchase Credit Memos];
                      ToolTipML=[DAN=Opret kõbskreditnotaer for at afspejle de salgskreditnotaer, som leverandõrer sender til dig for forkerte eller beskadigede varer, som er blevet betalt og derefter returneret til kreditoren. Hvis du har behov for mere kontrol over kõbsreturneringsprocessen, herunder lagerbilag for den fysiske lagerekspedition, skal du bruge kõbsreturvareordrer, hvor kõbskreditnotaerne integreres. Kõbskreditnotaer kan oprettes automatisk ud fra PDF- eller billedfiler fra dine kreditorer ved hjëlp af funktionen IndgÜende bilag. Bemërk: Hvis du endnu ikke har betalt for et fejlbehëftet kõb, kan du blot annullere den bogfõrte kõbsfaktura for automatisk at tilbagefõre den õkonomiske transaktion.;
                                 ENU=Create purchase credit memos to mirror sales credit memos that vendors send to you for incorrect or damaged items that you have paid for and then returned to the vendor. If you need more control of the purchase return process, such as warehouse documents for the physical handling, use purchase return orders, in which purchase credit memos are integrated. Purchase credit memos can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature. Note: If you have not yet paid for an erroneous purchase, you can simply cancel the posted purchase invoice to automatically revert the financial transaction.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 9309 }
      { 21      ;2   ;Action    ;
                      Name=<Page Posted Purchase Credit Memos>;
                      CaptionML=[DAN=Bogfõrte kõbskreditnotaer;
                                 ENU=Posted Purchase Credit Memos];
                      ToolTipML=[DAN=èbn listen over bogfõrte kõbskreditnotaer.;
                                 ENU=Open the list of posted purchase credit memos.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 147 }
      { 20      ;2   ;Action    ;
                      Name=<Page Posted Purchase Receipts>;
                      CaptionML=[DAN=Bogfõrte kõbsmodtagelser;
                                 ENU=Posted Purchase Receipts];
                      ToolTipML=[DAN=èbn listen over bogfõrte kõbsmodtagelser.;
                                 ENU=Open the list of posted purchase receipts.];
                      ApplicationArea=#Suite;
                      RunObject=Page 145 }
      { 19      ;1   ;ActionGroup;
                      CaptionML=[DAN=Godkendelser;
                                 ENU=Approvals];
                      ToolTipML=[DAN=Godkend anmodninger fra andre brugere.;
                                 ENU=Approve requests made by other users.] }
      { 18      ;2   ;Action    ;
                      CaptionML=[DAN=Anmodninger til godkendelse;
                                 ENU=Requests to Approve];
                      ToolTipML=[DAN=Accepter eller afvis andre brugeres anmodninger om at oprette eller ëndre bestemte dokumenter, kort eller kladdelinjer, som du skal godkende, fõr de kan fortsëtte. Listen er filtreret til anmodninger, hvor du er konfigureret som godkender.;
                                 ENU=Accept or reject other users' requests to create or change certain documents, cards, or journal lines that you must approve before they can proceed. The list is filtered to requests where you are set up as the approver.];
                      ApplicationArea=#Suite;
                      RunObject=Page 654;
                      Image=Approvals }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=RoleCenterArea }

    { 2   ;1   ;Group     ;
                GroupType=Group }

    { 3   ;2   ;Part      ;
                ApplicationArea=#Suite;
                PagePartID=Page9042;
                PartType=Page }

    { 4   ;2   ;Part      ;
                ApplicationArea=#Suite;
                PagePartID=Page9155;
                PartType=Page }

    { 7   ;2   ;Part      ;
                ApplicationArea=#Suite;
                PagePartID=Page9078;
                PartType=Page }

  }
  CODE
  {

    BEGIN
    END.
  }
}

