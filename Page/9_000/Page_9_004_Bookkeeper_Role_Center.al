OBJECT Page 9004 Bookkeeper Role Center
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846,NAVDK11.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[@@@="{Dependency=Match,""ProfileDescription_BOOKKEEPER""}";
               DAN=Bogholder;
               ENU=Bookkeeper];
    PageType=RoleCenter;
    ActionList=ACTIONS
    {
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 34      ;1   ;Action    ;
                      CaptionML=[DAN=Kon&toskema;
                                 ENU=A&ccount Schedule];
                      ToolTipML=[DAN=Analys�r tal i finanskonti, eller sammenlign finansposter med finansbudgetposter. Du kan f.eks. f� vist finansposter som procenter af budgetposter. Du kan bruge vinduet Kontoskema til at oprette kontoskemaer.;
                                 ENU=Analyze figures in general ledger accounts or compare general ledger entries with general ledger budget entries. For example, you can view the G/L entries as percentages of the budget entries. You use the Account Schedule window to set up account schedules.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 25;
                      Image=Report }
      { 9       ;1   ;ActionGroup;
                      CaptionML=[DAN=&Balance;
                                 ENU=&Trial Balance];
                      Image=Balance }
      { 32      ;2   ;Action    ;
                      CaptionML=[DAN=&Finans - balance;
                                 ENU=&G/L Trial Balance];
                      ToolTipML=[DAN=Vis, udskriv, eller send en rapport, der viser saldo for finanskontiene, herunder debet og kredit. Du kan bruge denne rapport til at sikre n�jagtig regnskabspraksis.;
                                 ENU=View, print, or send a report that shows the balances for the general ledger accounts, including the debits and credits. You can use this report to ensure accurate accounting practices.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 6;
                      Image=Report }
      { 33      ;2   ;Action    ;
                      CaptionML=[DAN=Bank - &kontokort;
                                 ENU=Bank &Detail Trial Balance];
                      ToolTipML=[DAN=Vis transaktioner for alle bankkonti med subtotaler pr. konto. Hver konto viser primosaldoen p� den f�rste linje p� listen over transaktioner for kontoen og en slutsaldo p� den sidste linje.;
                                 ENU=View transactions for all bank accounts with subtotals per account. Each account shows the opening balance on the first line, the list of transactions for the account and a closing balance on the last line.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 1404;
                      Image=Report }
      { 36      ;2   ;Action    ;
                      CaptionML=[DAN=B&alance/budget;
                                 ENU=T&rial Balance/Budget];
                      ToolTipML=[DAN=Vis en r�balance, der sammenlignes med et budget. Du kan f.eks. v�lge at f� vist en r�balance for udvalgte dimensioner. Du kan bruge rapporten ved afslutningen af en regnskabsperiode eller ved �rsopg�relsen.;
                                 ENU=View a trial balance in comparison to a budget. You can choose to see a trial balance for selected dimensions. You can use the report at the close of an accounting period or fiscal year.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 9;
                      Image=Report }
      { 37      ;2   ;Action    ;
                      CaptionML=[DAN=R�balance efter &periode;
                                 ENU=Trial Balance by &Period];
                      ToolTipML=[DAN=Viser primosaldoen efter finanskonto, bev�gelserne i den valgte periode for m�ned, kvartal eller �r, og den resulterende ultimosaldo.;
                                 ENU=Show the opening balance by general ledger account, the movements in the selected period of month, quarter, or year, and the resulting closing balance.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 38;
                      Image=Report }
      { 48      ;2   ;Action    ;
                      CaptionML=[DAN=�rsr&egnskab;
                                 ENU=Closing Tria&l Balance];
                      ToolTipML=[DAN=Vis dette og sidste �rs tal som en almindelig r�balance. For konti i resultatopg�relsen vises saldi uden ultimoposter. Ultimoposter anf�res p� en fiktiv dato mellem den sidste dag i det gamle regnskabs�r og den f�rste i det nye. Nulstilling af resultatopg�relseskonti bogf�res ultimo i regnskabs�ret. Rapporten kan f.eks. bruges i forbindelse med �rsafslutning.;
                                 ENU=View this year's and last year's figures as an ordinary trial balance. For income statement accounts, the balances are shown without closing entries. Closing entries are listed on a fictitious date that falls between the last day of one fiscal year and the first day of the next one. The closing of the income statement accounts is posted at the end of a fiscal year. The report can be used in connection with closing a fiscal year.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 10;
                      Image=Report }
      { 46      ;1   ;Action    ;
                      CaptionML=[DAN=Saldo for regnskabs&�r;
                                 ENU=&Fiscal Year Balance];
                      ToolTipML=[DAN=Vis, udskriv, eller send en rapport, der viser bev�gelser p� balancen for udvalgte perioder. Rapporten viser slutsaldoen ved afslutningen af det foreg�ende regnskabs�r for de valgte konti. Den viser ogs� regnskabs�ret til dato, dette regnskabs�r ved afslutningen af den valgte periode og saldoen ved afslutningen af den valgte periode med undtagelse af ultimoposterne. Rapporten kan bruges ved afslutningen af en regnskabsperiode eller ved �rsafslutningen.;
                                 ENU=View, print, or send a report that shows balance sheet movements for selected periods. The report shows the closing balance by the end of the previous fiscal year for the selected ledger accounts. It also shows the fiscal year until this date, the fiscal year by the end of the selected period, and the balance by the end of the selected period, excluding the closing entries. The report can be used at the close of an accounting period or fiscal year.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 36;
                      Image=Report }
      { 47      ;1   ;Action    ;
                      CaptionML=[DAN=Saldosammenlign. - &Forr. �r;
                                 ENU=Balance C&omp. . Prev. Year];
                      ToolTipML=[DAN=Vis en rapport, der viser din virksomheds aktiver, passiver og egenkapital sammenlignet med det forrige �r.;
                                 ENU=View a report that shows your company's assets, liabilities, and equity compared to the previous year.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 37;
                      Image=Report }
      { 49      ;1   ;Separator  }
      { 50      ;1   ;Action    ;
                      CaptionML=[DAN=&Aldersfordelte tilgodehavender;
                                 ENU=&Aged Accounts Receivable];
                      ToolTipML=[DAN=Vis forfaldne debitorbetalinger.;
                                 ENU=View overdue customer payments.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 120;
                      Image=Report }
      { 51      ;1   ;Action    ;
                      CaptionML=[DAN=Aldersfor&delt g�ld;
                                 ENU=Aged Accou&nts Payable];
                      ToolTipML=[DAN=Vis en oversigt over, hvorn�r dine skyldige bel�b til kreditorer skal betales eller rykkes for (opdelt i fire tidsperioder). Du skal angive den dato, som aldersfordelingen skal beregnes ud fra, og du skal angive den periode, som hver kolonne skal indeholde data for.;
                                 ENU=View an overview of when your payables to vendors are due or overdue (divided into four periods). You must specify the date you want aging calculated from and the length of the period that each column will contain data for.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 322;
                      Image=Report }
      { 52      ;1   ;Action    ;
                      CaptionML=[DAN=Afste&m deb.- og kred.konti;
                                 ENU=Reconcile Cust. and &Vend. Accs];
                      ToolTipML=[DAN=Vis, om en bestemt finanskonto afstemmer balancen p� en bestemt dato for den tilsvarende bogf�ringsgruppe. Rapporten viser de konti, der medtages i afstemningen af finansbalancen og debitor- eller kreditorbalancen for hver konto, samt eventuelle forskelle mellem finansbalancen og debitor- eller kreditorbalancen.;
                                 ENU=View if a certain general ledger account reconciles the balance on a certain date for the corresponding posting group. The report shows the accounts that are included in the reconciliation with the general ledger balance and the customer or the vendor ledger balance for each account and shows any differences between the general ledger balance and the customer or vendor ledger balance.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 33;
                      Image=Report }
      { 53      ;1   ;Separator  }
      { 54      ;1   ;Action    ;
                      CaptionML=[DAN=Kontrol af SE/&CVR-nr.;
                                 ENU=VAT Reg&istration No. Check];
                      ToolTipML=[DAN=Brug en tjeneste til validering af EU-momsnumre til at validere en forretningspartners momsnummer.;
                                 ENU=Use an EU VAT number validation service to validated the VAT number of a business partner.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 32;
                      Image=Report }
      { 55      ;1   ;Action    ;
                      CaptionML=[DAN=Momsu&ndtagelser;
                                 ENU=VAT E&xceptions];
                      ToolTipML=[DAN=Vis de momsposter, der er bogf�rt og placeret i en finansjournal i forbindelse med en momsdifference. Rapporten bruges til at dokumentere reguleringer af momsbel�b, der er beregnet til brug intern eller ekstern revision.;
                                 ENU=View the VAT entries that were posted and placed in a general ledger register in connection with a VAT difference. The report is used to document adjustments made to VAT amounts that were calculated for use in internal or external auditing.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 31;
                      Image=Report }
      { 56      ;1   ;Action    ;
                      CaptionML=[DAN=Momsan&givelse;
                                 ENU=VAT State&ment];
                      ToolTipML=[DAN=Vis en opg�relse over bogf�rt moms, og beregn de skyldige afgifter for den valgte periode til toldv�senet.;
                                 ENU=View a statement of posted VAT and calculate the duty liable to the customs authorities for the selected period.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 12;
                      Image=Report }
      { 57      ;1   ;Action    ;
                      CaptionML=[DAN=Moms - list&eangivelse TS;
                                 ENU=VAT - VI&ES Declaration Tax Auth];
                      ToolTipML=[DAN=Vis oplysninger til told- og skattemyndighederne ved salg til andre EU-lande/omr�der. Hvis oplysningerne skal skrives til en fil, kan du bruge rapporten Moms - listeangivelse disk.;
                                 ENU=View information to the customs and tax authorities for sales to other EU countries/regions. If the information must be printed to a file, you can use the VAT- VIES Declaration Disk report.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 19;
                      Image=Report }
      { 58      ;1   ;Action    ;
                      CaptionML=[DAN=M&oms - listeangivelse disk;
                                 ENU=VAT - VIES Declaration Dis&k];
                      ToolTipML=[DAN=Rapport�r dit salg til andre EU-lande/-omr�der til SKAT. Hvis oplysningerne skal udskrives p� en printer, kan du bruge rapporten Moms - listeangivelse TS. Oplysningerne er opstillet p� samme m�de som i listeangivelsen fra SKAT.;
                                 ENU=Report your sales to other EU countries or regions to the customs and tax authorities. If the information must be printed out on a printer, you can use the VAT- VIES Declaration Tax Auth report. The information is shown in the same format as in the declaration list from the customs and tax authorities.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 88;
                      Image=Report }
      { 59      ;1   ;Action    ;
                      CaptionML=[DAN=Oversigt over E&U-salg;
                                 ENU=EC &Sales List];
                      ToolTipML=[DAN=Beregn momsbel�b fra salg, og indberet bel�bene til skattemyndighederne.;
                                 ENU=Calculate VAT amounts from sales, and submit the amounts to a tax authority.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 130;
                      Image=Report }
      { 1900000011;0 ;ActionContainer;
                      ToolTipML=[DAN=Opkr�v og foretag betalinger, udarbejd udtog, og h�ndter rykkere.;
                                 ENU=Collect and make payments, prepare statements, and manage reminders.];
                      ActionContainerType=HomeItems }
      { 2       ;1   ;Action    ;
                      CaptionML=[DAN=Kontoplan;
                                 ENU=Chart of Accounts];
                      ToolTipML=[DAN=Vis kontoplanen.;
                                 ENU=View the chart of accounts.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 16 }
      { 63      ;1   ;Action    ;
                      CaptionML=[DAN=Bankkonti;
                                 ENU=Bank Accounts];
                      ToolTipML=[DAN=F� vist eller konfigurer detaljerede oplysninger om din bankkonto, f.eks. hvilken valuta der skal bruges, formatet p� de bankfiler, du importerer og eksporterer som elektroniske betalinger, samt nummereringen af checks.;
                                 ENU=View or set up detailed information about your bank account, such as which currency to use, the format of bank files that you import and export as electronic payments, and the numbering of checks.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 371;
                      Image=BankAccount }
      { 12      ;1   ;Action    ;
                      Name=Customers;
                      CaptionML=[DAN=Debitorer;
                                 ENU=Customers];
                      ToolTipML=[DAN=F� vist eller rediger detaljerede oplysninger om de debitorer, som du handler med. Fra det enkelte debitorkort kan du f� adgang til relaterede oplysninger som f.eks. salgsstatistik og igangv�rende ordrer, og du kan definere specialpriser og linjerabatter, som debitoren f�r, n�r bestemte betingelser er opfyldt.;
                                 ENU=View or edit detailed information for the customers that you trade with. From each customer card, you can open related information, such as sales statistics and ongoing orders, and you can define special prices and line discounts that you grant if certain conditions are met.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 22;
                      Image=Customer }
      { 20      ;1   ;Action    ;
                      Name=CustomersBalance;
                      CaptionML=[DAN=Saldo;
                                 ENU=Balance];
                      ToolTipML=[DAN=Se en oversigt over kontosaldoen i forskellige perioder.;
                                 ENU=View a summary of the bank account balance in different periods.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 22;
                      RunPageView=WHERE(Balance (LCY)=FILTER(<>0));
                      Image=Balance }
      { 3       ;1   ;Action    ;
                      Name=Vendors;
                      CaptionML=[DAN=Kreditorer;
                                 ENU=Vendors];
                      ToolTipML=[DAN=F� vist eller rediger detaljerede oplysninger om de kreditorer, som du handler med. Fra det enkelte kreditorkort kan du f� adgang til relaterede oplysninger som f.eks. k�bsstatistik og igangv�rende ordrer, og du kan definere specialpriser og linjerabatter, som kreditoren giver dig, n�r bestemte betingelser er opfyldt.;
                                 ENU=View or edit detailed information for the vendors that you trade with. From each vendor card, you can open related information, such as purchase statistics and ongoing orders, and you can define special prices and line discounts that the vendor grants you if certain conditions are met.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 27;
                      Image=Vendor }
      { 5       ;1   ;Action    ;
                      Name=VendorsBalance;
                      CaptionML=[DAN=Saldo;
                                 ENU=Balance];
                      ToolTipML=[DAN=Se en oversigt over kontosaldoen i forskellige perioder.;
                                 ENU=View a summary of the bank account balance in different periods.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 27;
                      RunPageView=WHERE(Balance (LCY)=FILTER(<>0));
                      Image=Balance }
      { 83      ;1   ;Action    ;
                      Name=VendorsPaymentonHold;
                      CaptionML=[DAN=Afventer betaling;
                                 ENU=Payment on Hold];
                      ToolTipML=[DAN=Vis en liste over alle de kreditorposter, hvor feltet Afvent er markeret.;
                                 ENU=View a list of all vendor ledger entries on which the On Hold field is marked.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 27;
                      RunPageView=WHERE(Blocked=FILTER(Payment)) }
      { 10      ;1   ;Action    ;
                      CaptionML=[DAN=Momsangivelse;
                                 ENU=VAT Statements];
                      ToolTipML=[DAN=F� vist en opg�relse over de bogf�rte momsbel�b, beregn dine momsafregningsbel�b for en bestemt periode som f.eks. et kvartal, og forbered indsendelse af momsangivelsen til myndighederne.;
                                 ENU=View a statement of posted VAT amounts, calculate your VAT settlement amount for a certain period, such as a quarter, and prepare to send the settlement to the tax authorities.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 320 }
      { 91      ;1   ;Action    ;
                      CaptionML=[DAN=K�bsfakturaer;
                                 ENU=Purchase Invoices];
                      ToolTipML=[DAN=Opret k�bsfakturaer for at afspejle de salgsbilag, som leverand�rer sender til dig. P� denne m�de kan du registrere k�bsomkostninger og spore kreditorer. Bogf�ringen af k�bsfakturaer opdaterer lagerniveauerne dynamisk, s� du kan minimere lageromkostningerne og levere bedre kundeservice. K�bsfakturaer kan oprettes automatisk ud fra PDF- eller billedfiler fra dine kreditorer ved hj�lp af funktionen Indg�ende bilag.;
                                 ENU=Create purchase invoices to mirror sales documents that vendors send to you. This enables you to record the cost of purchases and to track accounts payable. Posting purchase invoices dynamically updates inventory levels so that you can minimize inventory costs and provide better customer service. Purchase invoices can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9308 }
      { 6       ;1   ;Action    ;
                      CaptionML=[DAN=K�bsordrer;
                                 ENU=Purchase Orders];
                      ToolTipML=[DAN=Opret k�bsordrer for at afspejle de salgsbilag, som leverand�rer sender til dig. P� denne m�de kan du registrere k�bsomkostninger og spore kreditorer. Bogf�ringen af k�bsordrer opdaterer lagerniveauerne dynamisk, s� du kan minimere lageromkostningerne og levere bedre kundeservice. K�bsordrer tillader delleverancer, modsat k�bsfakturaer, og muligg�r direkte levering fra kreditoren til debitoren. K�bsordrer kan oprettes automatisk ud fra PDF- eller billedfiler fra dine kreditorer ved hj�lp af funktionen Indg�ende bilag.;
                                 ENU=Create purchase orders to mirror sales documents that vendors send to you. This enables you to record the cost of purchases and to track accounts payable. Posting purchase orders dynamically updates inventory levels so that you can minimize inventory costs and provide better customer service. Purchase orders allow partial receipts, unlike with purchase invoices, and enable drop shipment directly from your vendor to your customer. Purchase orders can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9307 }
      { 92      ;1   ;Action    ;
                      CaptionML=[DAN=Salgsfakturaer;
                                 ENU=Sales Invoices];
                      ToolTipML=[DAN=Registrer dit salg til debitorer, og inviter dem til at betale i henhold til leverings- og betalingsbetingelserne ved at sende dem et salgsfakturadokument. Bogf�ring af en salgsfaktura registrerer leveringen og registrerer en �ben tilgodehavendepost p� debitorens konto, som vil blive lukket, n�r betalingen er modtaget. Brug salgsordrer, hvor salgsfaktureringen er integreret, til at administrere leveringsprocessen.;
                                 ENU=Register your sales to customers and invite them to pay according to the delivery and payment terms by sending them a sales invoice document. Posting a sales invoice registers shipment and records an open receivable entry on the customer's account, which will be closed when payment is received. To manage the shipment process, use sales orders, in which sales invoicing is integrated.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9301;
                      Image=Invoice }
      { 14      ;1   ;Action    ;
                      CaptionML=[DAN=Salgsordrer;
                                 ENU=Sales Orders];
                      ToolTipML=[DAN=Registrer dine aftaler med debitorer for at s�lge bestemte varer p� bestemte leverings- og betalingsbetingelser. Salgsordrer g�r det i mods�tning til salgsfakturaer muligt at levere delvist, levere direkte fra kreditoren til debitoren, starte lagerekspedition og udskrive forskellige dokumenter til kunderne. Salgsfakturering er integreret i salgsordreprocessen.;
                                 ENU=Record your agreements with customers to sell certain products on certain delivery and payment terms. Sales orders, unlike sales invoices, allow you to ship partially, deliver directly from your vendor to your customer, initiate warehouse handling, and print various customer-facing documents. Sales invoicing is integrated in the sales order process.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9305;
                      Image=Order }
      { 21      ;1   ;Action    ;
                      CaptionML=[DAN=Godkendelser;
                                 ENU=Approvals];
                      ToolTipML=[DAN=F� vist en liste over records, der afventer godkendelse. Du kan f.eks. se, hvem der har anmodet om godkendelse af recorden, hvorn�r den blev sendt og hvorn�r den skal godkendes.;
                                 ENU=View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 654;
                      Image=Approvals }
      { 95      ;1   ;Action    ;
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
      { 96      ;1   ;Action    ;
                      Name=PaymentJournals;
                      CaptionML=[DAN=Udbetalingskladder;
                                 ENU=Payment Journals];
                      ToolTipML=[DAN=Registrer betalinger til kreditorer. En betalingskladde er en finanskladde, der bruges til at bogf�re udg�ende betalingstransaktioner til finansregnskab, bank, debitor, kreditor, medarbejder og anl�gskonti. Funktionerne for Lav kreditorbetalingsforslag udfylder automatisk kladden med de forfaldne betalinger. N�r betalingerne er bogf�rt, kan du eksportere betalingerne til en bankfil med henblik p� overf�rsel til din bank, s�fremt systemet er konfigureret til elektronisk betaling. Du kan ogs� sende computercheck fra betalingskladden.;
                                 ENU=Register payments to vendors. A payment journal is a type of general journal that is used to post outgoing payment transactions to G/L, bank, customer, vendor, employee, and fixed assets accounts. The Suggest Vendor Payments functions automatically fills the journal with payments that are due. When payments are posted, you can export the payments to a bank file for upload to your bank if your system is set up for electronic banking. You can also issue computer checks from the payment journal.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 251;
                      RunPageView=WHERE(Template Type=CONST(Payments),
                                        Recurring=CONST(No));
                      Image=Journals }
      { 97      ;1   ;Action    ;
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
      { 98      ;1   ;Action    ;
                      Name=RecurringGeneralJournals;
                      CaptionML=[DAN=Gentagelseskladder;
                                 ENU=Recurring General Journals];
                      ToolTipML=[DAN=Definer, hvordan transaktioner, der gentages med f� eller ingen �ndringer, skal bogf�res p� finanskonti, bankkonti, debitor- og kreditorkonti eller anl�gskonti.;
                                 ENU=Define how to post transactions that recur with few or no changes to general ledger, bank, customer, vendor, or fixed asset accounts];
                      ApplicationArea=#Advanced;
                      RunObject=Page 251;
                      RunPageView=WHERE(Template Type=CONST(General),
                                        Recurring=CONST(Yes)) }
      { 99      ;1   ;Action    ;
                      CaptionML=[DAN=Intrastatkladder;
                                 ENU=Intrastat Journals];
                      ToolTipML=[DAN=Sammenfat v�rdien af dine k�b og salg i relation til forretningspartnere i EU med statistik for �je, og klarg�r tallene til afsendelse til den relevante myndighed.;
                                 ENU=Summarize the value of your purchases and sales with business partners in the EU for statistical purposes and prepare to send it to the relevant authority.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 327 }
      { 1900000012;0 ;ActionContainer;
                      ActionContainerType=ActivityButtons }
      { 39      ;1   ;ActionGroup;
                      CaptionML=[DAN=Bogf�rte dokumenter;
                                 ENU=Posted Documents];
                      ToolTipML=[DAN=Vis bogf�rte fakturaer og kreditnotaer, og analys�r finansjournaler.;
                                 ENU=View posted invoices and credit memos, and analyze G/L registers.];
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
      { 13      ;2   ;Action    ;
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
      { 100     ;2   ;Action    ;
                      CaptionML=[DAN=Bogf. k�bsmodtagelser;
                                 ENU=Posted Purchase Receipts];
                      ToolTipML=[DAN=�bn listen over bogf�rte k�bsmodtagelser.;
                                 ENU=Open the list of posted purchase receipts.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 145 }
      { 27      ;2   ;Action    ;
                      CaptionML=[DAN=Bogf. k�bsfakturaer;
                                 ENU=Posted Purchase Invoices];
                      ToolTipML=[DAN=�bn listen over bogf�rte k�bsfakturaer.;
                                 ENU=Open the list of posted purchase invoices.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 146 }
      { 101     ;2   ;Action    ;
                      CaptionML=[DAN=Bogf�rte returvareleverancer;
                                 ENU=Posted Return Shipments];
                      ToolTipML=[DAN=�bn listen over bogf�rte returvareleverancer.;
                                 ENU=Open the list of posted return shipments.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 6652 }
      { 28      ;2   ;Action    ;
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
                                 ENU=Issued Fi. Charge Memos];
                      ToolTipML=[DAN=Vis oversigten over udstedte rentenotaer.;
                                 ENU=View the list of issued finance charge memos.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 452 }
      { 102     ;2   ;Action    ;
                      CaptionML=[DAN=Finansjournaler;
                                 ENU=G/L Registers];
                      ToolTipML=[DAN=Vis bogf�rte finansposter.;
                                 ENU=View posted G/L entries.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 116;
                      Image=GLRegisters }
      { 22      ;1   ;ActionGroup;
                      CaptionML=[DAN=Godkendelser;
                                 ENU=Approvals];
                      ToolTipML=[DAN=Anmod om godkendelse af dine dokumenter, kort eller kladdelinjer, eller godkend anmodninger fra andre brugere som godkender.;
                                 ENU=Request approval of your documents, cards, or journal lines or, as the approver, approve requests made by other users.] }
      { 24      ;2   ;Action    ;
                      CaptionML=[DAN=Anmodninger sendt til godkendelse;
                                 ENU=Requests Sent for Approval];
                      ToolTipML=[DAN=Vis de godkendelsesanmodninger, du har sendt.;
                                 ENU=View the approval requests that you have sent.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 658;
                      RunPageView=SORTING(Record ID to Approve,Workflow Step Instance ID,Sequence No.)
                                  ORDER(Ascending)
                                  WHERE(Status=FILTER(Open));
                      Image=Approvals }
      { 23      ;2   ;Action    ;
                      Name=RequestsToApprove;
                      CaptionML=[DAN=Anmodninger til godkendelse;
                                 ENU=Requests to Approve];
                      ToolTipML=[DAN=Accepter eller afvis andre brugeres anmodninger om at oprette eller �ndre bestemte dokumenter, kort eller kladdelinjer, som du skal godkende, f�r de kan forts�tte. Listen er filtreret til anmodninger, hvor du er konfigureret som godkender.;
                                 ENU=Accept or reject other users' requests to create or change certain documents, cards, or journal lines that you must approve before they can proceed. The list is filtered to requests where you are set up as the approver.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 654;
                      Image=Approvals }
      { 31      ;1   ;ActionGroup;
                      CaptionML=[DAN=Ops�tning;
                                 ENU=Administration];
                      Image=Administration }
      { 38      ;2   ;Action    ;
                      CaptionML=[DAN=Valutaer;
                                 ENU=Currencies];
                      ToolTipML=[DAN=F� vist de forskellige valutaer, du handler i, eller opdater valutakurserne ved at hente de seneste kurser fra en ekstern tjenesteudbyder.;
                                 ENU=View the different currencies that you trade in or update the exchange rates by getting the latest rates from an external service provider.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5;
                      Image=Currency }
      { 40      ;2   ;Action    ;
                      CaptionML=[DAN=Regnskabsperioder;
                                 ENU=Accounting Periods];
                      ToolTipML=[DAN=Angiv antal regnskabsperioder - f.eks. 12 m�nedsperioder - i regnskabs�ret, og angiv, hvilken periode der er starten p� det nye regnskabs�r.;
                                 ENU=Set up the number of accounting periods, such as 12 monthly periods, within the fiscal year and specify which period is the start of the new fiscal year.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 100;
                      Image=AccountingPeriods }
      { 41      ;2   ;Action    ;
                      CaptionML=[DAN=Nummerserie;
                                 ENU=Number Series];
                      ToolTipML=[DAN=Vis eller rediger den nummerserie, der bruges til at organisere transaktioner;
                                 ENU=View or edit the number series that are used to organize transactions];
                      ApplicationArea=#Advanced;
                      RunObject=Page 456 }
      { 16      ;0   ;ActionContainer;
                      ActionContainerType=NewDocumentItems }
      { 15      ;1   ;Action    ;
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
      { 104     ;1   ;Action    ;
                      CaptionML=[DAN=Salgs&faktura;
                                 ENU=Sales &Invoice];
                      ToolTipML=[DAN=Opret en ny salgsfaktura.;
                                 ENU=Create a new sales invoice.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 43;
                      Promoted=No;
                      Image=NewSalesInvoice;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 7       ;1   ;Action    ;
                      CaptionML=[DAN=&Salgskreditnota;
                                 ENU=Sales Credit &Memo];
                      ToolTipML=[DAN=Opret en ny salgskreditnota for at tilbagef�re en bogf�rt salgsfaktura.;
                                 ENU=Create a new sales credit memo to revert a posted sales invoice.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 44;
                      Promoted=No;
                      Image=CreditMemo;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 4       ;1   ;Action    ;
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
      { 1       ;1   ;Action    ;
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
      { 554     ;1   ;Separator  }
      { 555     ;1   ;Action    ;
                      CaptionML=[DAN=&Kreditor;
                                 ENU=&Vendor];
                      ToolTipML=[DAN="Opret en ny kreditor, som du k�ber varer eller tjenester hos. ";
                                 ENU="Set up a new vendor from whom you buy goods or services. "];
                      ApplicationArea=#Advanced;
                      RunObject=Page 26;
                      Promoted=No;
                      Image=Vendor;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 66      ;1   ;Action    ;
                      CaptionML=[DAN=&K�bsfaktura;
                                 ENU=&Purchase Invoice];
                      ToolTipML=[DAN=Opret en ny k�bsfaktura.;
                                 ENU=Create a new purchase invoice.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 51;
                      Promoted=No;
                      Image=NewPurchaseInvoice;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 67      ;1   ;Separator ;
                      CaptionML=[DAN=Opgaver;
                                 ENU=Tasks];
                      IsHeader=Yes }
      { 74      ;1   ;Action    ;
                      CaptionML=[DAN=Ind&betalingskladde;
                                 ENU=Cash Re&ceipt Journal];
                      ToolTipML=[DAN=�bn indbetalingskladden for at bogf�re indg�ende betalinger.;
                                 ENU=Open the cash receipt journal to post incoming payments.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 255;
                      Image=CashReceiptJournal }
      { 75      ;1   ;Action    ;
                      CaptionML=[DAN=&Udbetalingskladde;
                                 ENU=Payment &Journal];
                      ToolTipML=[DAN=Vis eller rediger den betalingskladde, hvor du kan registrere betalinger til kreditorer.;
                                 ENU=View or edit the payment journal where you can register payments to vendors.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 256;
                      Image=PaymentJournal }
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
                      CaptionML=[DAN=Opret elektronisk rykker;
                                 ENU=Create Electronic Reminder];
                      ToolTipML=[DAN=Opret en elektronisk version af det aktuelle dokument.;
                                 ENU=Create an electronic version of the current document.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 13602;
                      Image=CreateElectronicReminder }
      { 1060003 ;1   ;Action    ;
                      CaptionML=[DAN=Opret elektroniske rentenotaer;
                                 ENU=Create Electronic Fin. Chrg. Memos];
                      ToolTipML=[DAN=Opret en elektronisk version af det aktuelle dokument.;
                                 ENU=Create an electronic version of the current document.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 13603;
                      Image=ElectronicDoc }
      { 1060004 ;1   ;Action    ;
                      CaptionML=[DAN=Opret elektroniske servicefakturaer;
                                 ENU=Create Electronic Service Invoices];
                      ToolTipML=[DAN=Opret en elektronisk version af det aktuelle dokument.;
                                 ENU=Create an electronic version of the current document.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 13604;
                      Image=ElectronicDoc }
      { 1060005 ;1   ;Action    ;
                      CaptionML=[DAN=Opret elektroniske servicekreditnotaer;
                                 ENU=Create Electronic Service Credit Memos];
                      ToolTipML=[DAN=Opret en elektronisk version af det aktuelle dokument.;
                                 ENU=Create an electronic version of the current document.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 13605;
                      Image=ElectronicDoc }
      { 19      ;1   ;Action    ;
                      CaptionML=[DAN=Betalingsregistrering;
                                 ENU=Payment Registration];
                      ToolTipML=[DAN=Anvend debitorbetalinger p� bankkontoen p� ikke-bogf�rte salgsbilag for at registrere, at betalingen er foretaget.;
                                 ENU=Apply customer payments observed on your bank account to non-posted sales documents to record that payment is made.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 981;
                      Image=Payment }
      { 77      ;1   ;Separator  }
      { 135     ;1   ;Action    ;
                      CaptionML=[DAN=Betalingsudligningskladder;
                                 ENU=Payment Reconciliation Journals];
                      ToolTipML=[DAN=Afstem ubetalte bilag automatisk med deres relaterede banktransaktioner ved at importere et bankkontoudtog eller en fil. I betalingsudligningskladden udlignes indg�ende eller udg�ende betalinger for din bank automatisk eller delvist automatisk med deres relaterede �bne debitor- eller kreditorposter. Alle �bne bankkontoposter i forhold til de udlignede debitor- eller kreditorposter bliver lukket, n�r du v�lger handlingen Bogf�r betalinger og Afstem bankkontoen. Det betyder, at bankkontoen automatisk afstemmes for de betalinger, som du bogf�rer med kladden.;
                                 ENU=Reconcile unpaid documents automatically with their related bank transactions by importing a bank statement feed or file. In the payment reconciliation journal, incoming or outgoing payments on your bank are automatically, or semi-automatically, applied to their related open customer or vendor ledger entries. Any open bank account ledger entries related to the applied customer or vendor ledger entries will be closed when you choose the Post Payments and Reconcile Bank Account action. This means that the bank account is automatically reconciled for payments that you post with the journal.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 1294;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ApplyEntries;
                      RunPageMode=View }
      { 78      ;1   ;Action    ;
                      CaptionML=[DAN=Bankkontoafs&temning;
                                 ENU=B&ank Account Reconciliations];
                      ToolTipML=[DAN=Afstem poster i dine bankkontoposter med de faktiske transaktioner p� din bankkonto i henhold til den seneste bankkontoudtog.;
                                 ENU=Reconcile entries in your bank account ledger entries with the actual transactions in your bank account, according to the latest bank statement.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 379;
                      Image=BankAccountRec }
      { 110     ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kursreguler &valutabeholdninger;
                                 ENU=Adjust E&xchange Rates];
                      ToolTipML=[DAN=Reguler finans-, debitor-, kreditor- og bankkontoposter, s� de svarer til den opdaterede saldo i situationer, hvor kursen har �ndret sig siden bogf�ringen.;
                                 ENU=Adjust general ledger, customer, vendor, and bank account entries to reflect a more updated balance if the exchange rate has changed since the entries were posted.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 595;
                      Image=AdjustExchangeRates }
      { 112     ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Bogf&�r lagerregulering;
                                 ENU=Post Inventor&y Cost to G/L];
                      ToolTipML=[DAN=Bogf�r �ndringen i antal og v�rdi for lageret i vareposterne og v�rdiposterne, n�r du bogf�rer lagertransaktioner som f.eks. salgsleverancer eller k�bsfakturaer.;
                                 ENU=Post the quantity and value changes to the inventory in the item ledger entries and the value entries when you post inventory transactions, such as sales shipments or purchase receipts.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 1002;
                      Image=PostInventoryToGL }
      { 113     ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Afregn &moms;
                                 ENU=Calc. and Pos&t VAT Settlement];
                      ToolTipML=[DAN=Luk �bne momsposter og overf�rer k�bs- og salgsmomsbel�b til momsafregningskontoen. For hver momsbogf�ringsgruppe finder k�rslen alle momsposter i den momsposttabel, der er inkluderet i filtrene i definitionsvinduet.;
                                 ENU=Close open VAT entries and transfers purchase and sales VAT amounts to the VAT settlement account. For every VAT posting group, the batch job finds all the VAT entries in the VAT Entry table that are included in the filters in the definition window.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 20;
                      Image=SettleOpenTransactions }
      { 84      ;1   ;Separator ;
                      CaptionML=[DAN=Ops�tning;
                                 ENU=Administration];
                      IsHeader=Yes }
      { 86      ;1   ;Action    ;
                      CaptionML=[DAN=Sa&lgsops�tning;
                                 ENU=Sa&les && Receivables Setup];
                      ToolTipML=[DAN=Definer dine generelle politikker for salgsfakturering og returneringer, f.eks. hvorn�r advarsler om kredit og lagerbeholdning skal vises, og hvordan salgsrabatter skal bogf�res. Konfigurer dine nummerserier for oprettelse af debitorer og forskellige salgsbilag.;
                                 ENU=Define your general policies for sales invoicing and returns, such as when to show credit and stockout warnings and how to post sales discounts. Set up your number series for creating customers and different sales documents.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 459;
                      Image=Setup }
      { 89      ;1   ;Separator ;
                      CaptionML=[DAN=Oversigt;
                                 ENU=History];
                      IsHeader=Yes }
      { 90      ;1   ;Action    ;
                      CaptionML=[DAN=Navi&ger;
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

    { 1901197008;2;Part   ;
                ApplicationArea=#Advanced;
                PagePartID=Page9036;
                PartType=Page }

    { 1907692008;2;Part   ;
                ApplicationArea=#Advanced;
                PagePartID=Page9150;
                PartType=Page }

    { 1900724708;1;Group   }

    { 17  ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page675;
                Visible=false;
                PartType=Page }

    { 1902476008;2;Part   ;
                ApplicationArea=#Advanced;
                PagePartID=Page9151;
                PartType=Page }

    { 18  ;2   ;Part      ;
                ApplicationArea=#Advanced;
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

