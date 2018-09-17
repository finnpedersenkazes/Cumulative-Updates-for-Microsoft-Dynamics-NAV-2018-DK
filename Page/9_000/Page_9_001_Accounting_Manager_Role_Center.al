OBJECT Page 9001 Accounting Manager Role Center
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846,NAVDK11.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[@@@="{Dependency=Match,""ProfileDescription_ACCOUNTINGMANAGER""}";
               DAN=Regnskabschef;
               ENU=Accounting Manager];
    PageType=RoleCenter;
    ActionList=ACTIONS
    {
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 32      ;1   ;Action    ;
                      CaptionML=[DAN=&Finans - balance;
                                 ENU=&G/L Trial Balance];
                      ToolTipML=[DAN=Vis, udskriv, eller send en rapport, der viser saldo for finanskontiene, herunder debet og kredit. Du kan bruge denne rapport til at sikre n�jagtig regnskabspraksis.;
                                 ENU=View, print, or send a report that shows the balances for the general ledger accounts, including the debits and credits. You can use this report to ensure accurate accounting practices.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 6;
                      Image=Report }
      { 33      ;1   ;Action    ;
                      CaptionML=[DAN=&Bank - kontokort;
                                 ENU=&Bank Detail Trial Balance];
                      ToolTipML=[DAN=Vis, udskriv, eller send en rapport, der viser en detaljeret r�balance for udvalgte bankkonti. Du kan bruge rapporten ved afslutningen af en regnskabsperiode eller ved �rsopg�relsen.;
                                 ENU=View, print, or send a report that shows a detailed trial balance for selected bank accounts. You can use the report at the close of an accounting period or fiscal year.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 1404;
                      Image=Report }
      { 34      ;1   ;Action    ;
                      CaptionML=[DAN=Kontoske&ma;
                                 ENU=&Account Schedule];
                      ToolTipML=[DAN=�bn et kontoskema til at analysere tal i finanskonti eller sammenligne finansposter med finansbudgetposter.;
                                 ENU=Open an account schedule to analyze figures in general ledger accounts or to compare general ledger entries with general ledger budget entries.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 25;
                      Image=Report }
      { 35      ;1   ;Action    ;
                      CaptionML=[DAN=Bu&dget;
                                 ENU=Bu&dget];
                      ToolTipML=[DAN=Vis eller rediger ansl�ede bel�b for et interval af regnskabsperioder.;
                                 ENU=View or edit estimated amounts for a range of accounting periods.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 8;
                      Image=Report }
      { 36      ;1   ;Action    ;
                      CaptionML=[DAN=Balan&ce/budget;
                                 ENU=Trial Bala&nce/Budget];
                      ToolTipML=[DAN=Vis en r�balance, der sammenlignes med et budget. Du kan f.eks. v�lge at f� vist en r�balance for udvalgte dimensioner. Du kan bruge rapporten ved afslutningen af en regnskabsperiode eller ved �rsopg�relsen.;
                                 ENU=View a trial balance in comparison to a budget. You can choose to see a trial balance for selected dimensions. You can use the report at the close of an accounting period or fiscal year.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 9;
                      Image=Report }
      { 37      ;1   ;Action    ;
                      CaptionML=[DAN=R�balance efter &periode;
                                 ENU=Trial Balance by &Period];
                      ToolTipML=[DAN=Viser primosaldoen efter finanskonto, bev�gelserne i den valgte periode for m�ned, kvartal eller �r, og den resulterende ultimosaldo.;
                                 ENU=Show the opening balance by general ledger account, the movements in the selected period of month, quarter, or year, and the resulting closing balance.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 38;
                      Image=Report }
      { 46      ;1   ;Action    ;
                      CaptionML=[DAN=&Saldo for regnskabs�r;
                                 ENU=&Fiscal Year Balance];
                      ToolTipML=[DAN=Vis, udskriv, eller send en rapport, der viser bev�gelser p� balancen for udvalgte perioder. Rapporten viser slutsaldoen ved afslutningen af det foreg�ende regnskabs�r for de valgte konti. Den viser ogs� regnskabs�ret til dato, dette regnskabs�r ved afslutningen af den valgte periode og saldoen ved afslutningen af den valgte periode med undtagelse af ultimoposterne. Rapporten kan bruges ved afslutningen af en regnskabsperiode eller ved �rsafslutningen.;
                                 ENU=View, print, or send a report that shows balance sheet movements for selected periods. The report shows the closing balance by the end of the previous fiscal year for the selected ledger accounts. It also shows the fiscal year until this date, the fiscal year by the end of the selected period, and the balance by the end of the selected period, excluding the closing entries. The report can be used at the close of an accounting period or fiscal year.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 36;
                      Image=Report }
      { 47      ;1   ;Action    ;
                      CaptionML=[DAN=Saldosammenlign. - Forr. &�r;
                                 ENU=Balance Comp. - Prev. Y&ear];
                      ToolTipML=[DAN=Vis en rapport, der viser din virksomheds aktiver, passiver og egenkapital sammenlignet med det forrige �r.;
                                 ENU=View a report that shows your company's assets, liabilities, and equity compared to the previous year.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 37;
                      Image=Report }
      { 48      ;1   ;Action    ;
                      CaptionML=[DAN=�&rsregnskab;
                                 ENU=&Closing Trial Balance];
                      ToolTipML=[DAN=Vis, udskriv, eller send en rapport, der viser dette og sidste �rs tal som en almindelig r�balance. Nulstilling af resultatopg�relseskonti bogf�res ultimo i regnskabs�ret. Rapporten kan bruges i forbindelse med �rsafslutning.;
                                 ENU=View, print, or send a report that shows this year's and last year's figures as an ordinary trial balance. The closing of the income statement accounts is posted at the end of a fiscal year. The report can be used in connection with closing a fiscal year.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 10;
                      Image=Report }
      { 49      ;1   ;Separator  }
      { 104     ;1   ;Action    ;
                      CaptionML=[DAN=Pengestr�msdatoliste;
                                 ENU=Cash Flow Date List];
                      ToolTipML=[DAN=F� vist prognoseposter for en periode, du angiver. De registrerede pengestr�msprognoseposter organiseres efter kildetyper, f.eks. tilgodehavender, salgsordrer, skyldige bel�b og k�bsordrer. Du angiver antal perioder og l�ngden af dem.;
                                 ENU=View forecast entries for a period of time that you specify. The registered cash flow forecast entries are organized by source types, such as receivables, sales orders, payables, and purchase orders. You specify the number of periods and their length.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 846;
                      Image=Report }
      { 115     ;1   ;Separator  }
      { 50      ;1   ;Action    ;
                      CaptionML=[DAN=Aldersfordelte tilgode&havender;
                                 ENU=Aged Accounts &Receivable];
                      ToolTipML=[DAN=Vis en oversigt over, hvorn�r dine tilgodehavender fra debitorer skal betales eller rykkes for (opdelt i fire tidsperioder). Du skal angive den dato, som aldersfordelingen skal beregnes ud fra, og du skal angive den periode, som hver kolonne skal indeholde data for.;
                                 ENU=View an overview of when your receivables from customers are due or overdue (divided into four periods). You must specify the date you want aging calculated from and the length of the period that each column will contain data for.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 120;
                      Image=Report }
      { 51      ;1   ;Action    ;
                      CaptionML=[DAN=Aldersfordelt &g�ld;
                                 ENU=Aged Accounts Pa&yable];
                      ToolTipML=[DAN=Vis en oversigt over, hvorn�r dine skyldige bel�b til kreditorer skal betales eller rykkes for (opdelt i fire tidsperioder). Du skal angive den dato, som aldersfordelingen skal beregnes ud fra, og du skal angive den periode, som hver kolonne skal indeholde data for.;
                                 ENU=View an overview of when your payables to vendors are due or overdue (divided into four periods). You must specify the date you want aging calculated from and the length of the period that each column will contain data for.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 322;
                      Image=Report }
      { 52      ;1   ;Action    ;
                      CaptionML=[DAN=Afstem deb.- og &kred.konti;
                                 ENU=Reconcile Cus&t. and Vend. Accs];
                      ToolTipML=[DAN=Vis, om en bestemt finanskonto afstemmer balancen p� en bestemt dato for den tilsvarende bogf�ringsgruppe. Rapporten viser de konti, der medtages i afstemningen af finansbalancen og debitor- eller kreditorbalancen for hver konto, samt eventuelle forskelle mellem finansbalancen og debitor- eller kreditorbalancen.;
                                 ENU=View if a certain general ledger account reconciles the balance on a certain date for the corresponding posting group. The report shows the accounts that are included in the reconciliation with the general ledger balance and the customer or the vendor ledger balance for each account and shows any differences between the general ledger balance and the customer or vendor ledger balance.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 33;
                      Image=Report }
      { 53      ;1   ;Separator  }
      { 54      ;1   ;Action    ;
                      CaptionML=[DAN=K&ontrol af SE/CVR-nr.;
                                 ENU=&VAT Registration No. Check];
                      ToolTipML=[DAN=Brug en tjeneste til validering af EU-momsnumre til at validere en forretningspartners momsnummer.;
                                 ENU=Use an EU VAT number validation service to validated the VAT number of a business partner.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 32;
                      Image=Report }
      { 55      ;1   ;Action    ;
                      CaptionML=[DAN=Momsund&tagelser;
                                 ENU=VAT E&xceptions];
                      ToolTipML=[DAN=Vis de momsposter, der er bogf�rt og placeret i en finansjournal i forbindelse med en momsdifference. Rapporten bruges til at dokumentere reguleringer af momsbel�b, der er beregnet til brug intern eller ekstern revision.;
                                 ENU=View the VAT entries that were posted and placed in a general ledger register in connection with a VAT difference. The report is used to document adjustments made to VAT amounts that were calculated for use in internal or external auditing.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 31;
                      Image=Report }
      { 56      ;1   ;Action    ;
                      CaptionML=[DAN=Moms&angivelse;
                                 ENU=VAT &Statement];
                      ToolTipML=[DAN=Vis en opg�relse over bogf�rt moms, og beregn de skyldige afgifter for den valgte periode til toldv�senet.;
                                 ENU=View a statement of posted VAT and calculate the duty liable to the customs authorities for the selected period.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 12;
                      Image=Report }
      { 57      ;1   ;Action    ;
                      CaptionML=[DAN=Moms - listeangivels&e TS;
                                 ENU=VAT - VIES Declaration Tax Aut&h];
                      ToolTipML=[DAN=Vis oplysninger til told- og skattemyndighederne ved salg til andre EU-lande/omr�der. Hvis oplysningerne skal skrives til en fil, kan du bruge rapporten Moms - listeangivelse disk.;
                                 ENU=View information to the customs and tax authorities for sales to other EU countries/regions. If the information must be printed to a file, you can use the VAT- VIES Declaration Disk report.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 19;
                      Image=Report }
      { 58      ;1   ;Action    ;
                      CaptionML=[DAN=Moms - listeangi&velse disk;
                                 ENU=VAT - VIES Declaration Dis&k];
                      ToolTipML=[DAN=Rapport�r dit salg til andre EU-lande/-omr�der til SKAT. Hvis oplysningerne skal udskrives p� en printer, kan du bruge rapporten Moms - listeangivelse TS. Oplysningerne er opstillet p� samme m�de som i listeangivelsen fra SKAT.;
                                 ENU=Report your sales to other EU countries or regions to the customs and tax authorities. If the information must be printed out on a printer, you can use the VAT- VIES Declaration Tax Auth report. The information is shown in the same format as in the declaration list from the customs and tax authorities.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 88;
                      Image=Report }
      { 59      ;1   ;Action    ;
                      CaptionML=[DAN=Oversigt over EU-sa&lg;
                                 ENU=EC Sales &List];
                      ToolTipML=[DAN=Beregn momsbel�b fra salg, og indberet bel�bene til skattemyndighederne.;
                                 ENU=Calculate VAT amounts from sales, and submit the amounts to a tax authority.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 130;
                      Image=Report }
      { 60      ;1   ;Separator  }
      { 61      ;1   ;Action    ;
                      CaptionML=[DAN=&Intrastat - kontrolliste;
                                 ENU=&Intrastat - Checklist];
                      ToolTipML=[DAN=Vis en kontrolliste, som du kan bruge til at finde eventuelle fejl inden udskrivningen, og som dokumentation for, hvad der udskrives. Du kan bruge rapporten til at kontrollere Intrastatkladden, f�r du Intrastat - dan diskette TS.;
                                 ENU=View a checklist that you can use to find possible errors before printing and also as documentation for what is printed. You can use the report to check the Intrastat journal before you use the Intrastat - Make Disk Tax Auth batch job.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 502;
                      Image=Report }
      { 62      ;1   ;Action    ;
                      CaptionML=[DAN=Intrastat - bla&nket;
                                 ENU=Intrastat - For&m];
                      ToolTipML=[DAN=Vis alle de oplysninger, der skal overf�res til den udskrevne Intrastat-formular.;
                                 ENU=View all the information that must be transferred to the printed Intrastat form.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 501;
                      Image=Report }
      { 4       ;1   ;Separator  }
      { 7       ;1   ;Action    ;
                      CaptionML=[DAN=Resultatopg�relse i omkostningsregnskab;
                                 ENU=Cost Accounting P/L Statement];
                      ToolTipML=[DAN=Vis kredit- og debetsaldi pr. omkostningstype sammen med diagrammet over omkostningstyper.;
                                 ENU=View the credit and debit balances per cost type, together with the chart of cost types.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Report 1126;
                      Image=Report }
      { 15      ;1   ;Action    ;
                      CaptionML=[DAN=CA-resultatopg�relse pr. periode;
                                 ENU=CA P/L Statement per Period];
                      ToolTipML=[DAN=Vis resultatopg�relsen for omkostningstyper over to perioder med sammenligning som en procentdel.;
                                 ENU=View profit and loss for cost types over two periods with the comparison as a percentage.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Report 1123;
                      Image=Report }
      { 21      ;1   ;Action    ;
                      CaptionML=[DAN=CA-resultatopg�relse med budget;
                                 ENU=CA P/L Statement with Budget];
                      ToolTipML=[DAN=Vis en sammenligning af saldoen med budgettallene, som beregner varians og afvigelse i procent i den aktuelle regnskabsperiode, den akkumulerede regnskabsperiode og regnskabs�ret.;
                                 ENU=View a comparison of the balance to the budget figures and calculates the variance and the percent variance in the current accounting period, the accumulated accounting period, and the fiscal year.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Report 1133;
                      Image=Report }
      { 42      ;1   ;Action    ;
                      CaptionML=[DAN=Analyse af omkostningsregnskab;
                                 ENU=Cost Accounting Analysis];
                      ToolTipML=[DAN=Vis saldi pr. omkostningstype med kolonner for syv felter for omkostningssteder og omkostningsemner. Det bruges som omkostningsfordelingsark i omkostningsregnskabet. Strukturen i linjerne er baseret p� diagrammet over omkostningstyper. Du kan angive op til syv omkostningssteder og omkostningsemner, der vises som kolonner i rapporten.;
                                 ENU=View balances per cost type with columns for seven fields for cost centers and cost objects. It is used as the cost distribution sheet in Cost accounting. The structure of the lines is based on the chart of cost types. You define up to seven cost centers and cost objects that appear as columns in the report.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Report 1127;
                      Image=Report }
      { 1900000011;0 ;ActionContainer;
                      ActionContainerType=HomeItems }
      { 2       ;1   ;Action    ;
                      CaptionML=[DAN=Kontoplan;
                                 ENU=Chart of Accounts];
                      ToolTipML=[DAN=Vis kontoplanen.;
                                 ENU=View the chart of accounts.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 16 }
      { 8       ;1   ;Action    ;
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
      { 6       ;1   ;Action    ;
                      CaptionML=[DAN=K�bsordrer;
                                 ENU=Purchase Orders];
                      ToolTipML=[DAN=Opret k�bsordrer for at afspejle de salgsbilag, som leverand�rer sender til dig. P� denne m�de kan du registrere k�bsomkostninger og spore kreditorer. Bogf�ringen af k�bsordrer opdaterer lagerniveauerne dynamisk, s� du kan minimere lageromkostningerne og levere bedre kundeservice. K�bsordrer tillader delleverancer, modsat k�bsfakturaer, og muligg�r direkte levering fra kreditoren til debitoren. K�bsordrer kan oprettes automatisk ud fra PDF- eller billedfiler fra dine kreditorer ved hj�lp af funktionen Indg�ende bilag.;
                                 ENU=Create purchase orders to mirror sales documents that vendors send to you. This enables you to record the cost of purchases and to track accounts payable. Posting purchase orders dynamically updates inventory levels so that you can minimize inventory costs and provide better customer service. Purchase orders allow partial receipts, unlike with purchase invoices, and enable drop shipment directly from your vendor to your customer. Purchase orders can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9307 }
      { 76      ;1   ;Action    ;
                      CaptionML=[DAN=Budgetter;
                                 ENU=Budgets];
                      ToolTipML=[DAN=Vis eller rediger ansl�ede bel�b for et interval af regnskabsperioder.;
                                 ENU=View or edit estimated amounts for a range of accounting periods.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 121 }
      { 9       ;1   ;Action    ;
                      CaptionML=[DAN=Bankkonti;
                                 ENU=Bank Accounts];
                      ToolTipML=[DAN=F� vist eller konfigurer detaljerede oplysninger om din bankkonto, f.eks. hvilken valuta der skal bruges, formatet p� de bankfiler, du importerer og eksporterer som elektroniske betalinger, samt nummereringen af checks.;
                                 ENU=View or set up detailed information about your bank account, such as which currency to use, the format of bank files that you import and export as electronic payments, and the numbering of checks.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 371;
                      Image=BankAccount }
      { 10      ;1   ;Action    ;
                      CaptionML=[DAN=Momsangivelse;
                                 ENU=VAT Statements];
                      ToolTipML=[DAN=F� vist en opg�relse over de bogf�rte momsbel�b, beregn dine momsafregningsbel�b for en bestemt periode som f.eks. et kvartal, og forbered indsendelse af momsangivelsen til myndighederne.;
                                 ENU=View a statement of posted VAT amounts, calculate your VAT settlement amount for a certain period, such as a quarter, and prepare to send the settlement to the tax authorities.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 320 }
      { 11      ;1   ;Action    ;
                      CaptionML=[DAN=Varer;
                                 ENU=Items];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om de produkter, du handler med. Varekortet kan v�re af typen lager eller tjeneste for at angive, om varen er en fysisk enhed eller en best�r af arbejdstimer. Her angiver du ogs�, om varerne p� lager eller i indg�ende ordrer automatisk reserveres til udg�ende bilag, og om der er oprettet ordresporingsbindinger mellem behov og forsyning for at afspejle planl�gningshandlinger.;
                                 ENU=View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 31;
                      Image=Item }
      { 12      ;1   ;Action    ;
                      Name=Customers;
                      CaptionML=[DAN=Debitorer;
                                 ENU=Customers];
                      ToolTipML=[DAN=F� vist eller rediger detaljerede oplysninger om de debitorer, som du handler med. Fra det enkelte debitorkort kan du f� adgang til relaterede oplysninger som f.eks. salgsstatistik og igangv�rende ordrer, og du kan definere specialpriser og linjerabatter, som debitoren f�r, n�r bestemte betingelser er opfyldt.;
                                 ENU=View or edit detailed information for the customers that you trade with. From each customer card, you can open related information, such as sales statistics and ongoing orders, and you can define special prices and line discounts that you grant if certain conditions are met.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 22;
                      Image=Customer }
      { 13      ;1   ;Action    ;
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
      { 1102601003;1 ;Action    ;
                      CaptionML=[DAN=Rykkere;
                                 ENU=Reminders];
                      ToolTipML=[DAN=P�mind debitorer om forfaldne bel�b ud fra rykkerbetingelserne og de relaterede rykkerniveauer. Hvert rykkerniveau omfatter regler om, hvorn�r rykkeren skal udstedes i forhold til fakturaens forfaldsdato eller datoen for den forrige rykker, og om der p�l�ber renter. Rykkerne integreres i rentenotaerne, som er dokumenter, der informerer debitorerne om renter eller andre skyldige sanktioner for forsinket betaling.;
                                 ENU=Remind customers about overdue amounts based on reminder terms and the related reminder levels. Each reminder level includes rules about when the reminder will be issued in relation to the invoice due date or the date of the previous reminder and whether interests are added. Reminders are integrated with finance charge memos, which are documents informing customers of interests or other money penalties for payment delays.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 436;
                      Image=Reminder }
      { 1102601004;1 ;Action    ;
                      CaptionML=[DAN=Rentenotaer;
                                 ENU=Finance Charge Memos];
                      ToolTipML=[DAN=Send rentenotaer til debitorer med forsinkede betalinger, hvilket typisk f�lger efter en rykkerprocedure. Renter beregnes automatisk og f�jes til de forfaldne bel�b p� debitorens konto i henhold til de angivne rentebetingelser og sanktions- eller rentebel�b.;
                                 ENU=Send finance charge memos to customers with delayed payments, typically following a reminder process. Finance charges are calculated automatically and added to the overdue amounts on the customer's account according to the specified finance charge terms and penalty/interest amounts.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 448;
                      Image=FinChargeMemo }
      { 119     ;1   ;Action    ;
                      CaptionML=[DAN=Indg�ende bilag;
                                 ENU=Incoming Documents];
                      ToolTipML=[DAN=H�ndter indg�ende bilag, f.eks. kreditorfakturaer i PDF- eller billedfiler, som kan bruges til manuel eller automatisk konvertering til bilagsrecords, f.eks. k�bsfakturaer. De eksterne filer, der repr�senterer indg�ende bilag, kan knyttes til ethvert procestrin, herunder bogf�rte bilag og de resulterende kreditor-, debitor- og finansposter.;
                                 ENU=Handle incoming documents, such as vendor invoices in PDF or as image files, that you can manually or automatically convert to document records, such as purchase invoices. The external files that represent incoming documents can be attached at any process stage, including to posted documents and to the resulting vendor, customer, and general ledger entries.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 190;
                      Image=Documents }
      { 112     ;1   ;Action    ;
                      CaptionML=[DAN=Oversigt over EU-salg;
                                 ENU=EC Sales List];
                      ToolTipML=[DAN=Forbered rapporten med oversigt over EU-salg, s� du kan indberette momsbel�b til skattemyndighederne.;
                                 ENU=Prepare the EC Sales List report so you can submit VAT amounts to a tax authority.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 323 }
      { 1900000012;0 ;ActionContainer;
                      ActionContainerType=ActivityButtons }
      { 107     ;1   ;ActionGroup;
                      CaptionML=[DAN=Kladder;
                                 ENU=Journals];
                      Image=Journals }
      { 117     ;2   ;Action    ;
                      Name=PurchaseJournals;
                      CaptionML=[DAN=K�bskladder;
                                 ENU=Purchase Journals];
                      ToolTipML=[DAN=Bogf�r enhver transaktion, der er relateret til k�b, direkte til en kreditor-, bankkonto eller finanskonto i stedet at bruge dedikerede bilag. Du kan bogf�re alle typer finansielle k�bstransaktioner, herunder betalinger, refusioner og finansgebyrbel�b. Bem�rk, at du ikke kan bogf�re varebeholdninger med en k�bskladde.;
                                 ENU=Post any purchase-related transaction directly to a vendor, bank, or general ledger account instead of using dedicated documents. You can post all types of financial purchase transactions, including payments, refunds, and finance charge amounts. Note that you cannot post item quantities with a purchase journal.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 251;
                      RunPageView=WHERE(Template Type=CONST(Purchases),
                                        Recurring=CONST(No)) }
      { 118     ;2   ;Action    ;
                      Name=SalesJournals;
                      CaptionML=[DAN=Salgskladder;
                                 ENU=Sales Journals];
                      ToolTipML=[DAN=Bogf�r enhver transaktion, der er relateret til salg, direkte til en debitor-, bankkonto eller finanskonto i stedet at bruge dedikerede bilag. Du kan bogf�re alle typer finansielle salgstransaktioner, herunder betalinger, refusioner og finansgebyrbel�b. Bem�rk, at du ikke kan bogf�re varebeholdninger med en salgskladde.;
                                 ENU=Post any sales-related transaction directly to a customer, bank, or general ledger account instead of using dedicated documents. You can post all types of financial sales transactions, including payments, refunds, and finance charge amounts. Note that you cannot post item quantities with a sales journal.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 251;
                      RunPageView=WHERE(Template Type=CONST(Sales),
                                        Recurring=CONST(No)) }
      { 113     ;2   ;Action    ;
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
      { 114     ;2   ;Action    ;
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
      { 1102601000;2 ;Action    ;
                      Name=ICGeneralJournals;
                      CaptionML=[DAN=IC-finanskladder;
                                 ENU=IC General Journals];
                      ToolTipML=[DAN=Bogf�r koncerninterne transaktioner. Koncerninterne finanskladdelinjer skal indeholde en koncernintern partnerkonto eller en debitor- eller kreditorkonto, der er tildelt en koncernintern partnerkode.;
                                 ENU=Post intercompany transactions. IC general journal lines must contain either an IC partner account or a customer or vendor account that has been assigned an intercompany partner code.];
                      ApplicationArea=#Intercompany;
                      RunObject=Page 251;
                      RunPageView=WHERE(Template Type=CONST(Intercompany),
                                        Recurring=CONST(No)) }
      { 1102601001;2 ;Action    ;
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
      { 1102601002;2 ;Action    ;
                      CaptionML=[DAN=Intrastatkladder;
                                 ENU=Intrastat Journals];
                      ToolTipML=[DAN=Sammenfat v�rdien af dine k�b og salg i relation til forretningspartnere i EU med statistik for �je, og klarg�r tallene til afsendelse til den relevante myndighed.;
                                 ENU=Summarize the value of your purchases and sales with business partners in the EU for statistical purposes and prepare to send it to the relevant authority.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 327;
                      Image=Report }
      { 16      ;1   ;ActionGroup;
                      CaptionML=[DAN=Anl�g;
                                 ENU=Fixed Assets];
                      Image=FixedAssets }
      { 17      ;2   ;Action    ;
                      CaptionML=[DAN=Anl�g;
                                 ENU=Fixed Assets];
                      ToolTipML=[DAN=Administr�r periodisk afskrivning af dine maskiner, hold styr p� reparationsomkostningerne, administr�r forsikringspolicer vedr�rende faste anl�gsaktiver, og overv�g statistik for faste anl�gsaktiver.;
                                 ENU=Manage periodic depreciation of your machinery or machines, keep track of your maintenance costs, manage insurance policies related to fixed assets, and monitor fixed asset statistics.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5601 }
      { 18      ;2   ;Action    ;
                      CaptionML=[DAN=Forsikring;
                                 ENU=Insurance];
                      ToolTipML=[DAN=Administrer forsikringspolicer for anl�gsaktiver, og overv�g forsikringsd�kningen.;
                                 ENU=Manage insurance policies for fixed assets and monitor insurance coverage.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5645 }
      { 19      ;2   ;Action    ;
                      CaptionML=[DAN=Anl�gsfinanskladder;
                                 ENU=Fixed Assets G/L Journals];
                      ToolTipML=[DAN=Bogf�r transaktioner for faste anl�gsaktiver, f.eks. anskaffelse og afskrivning, med integration til finans. Anl�gsfinanskladden er en generel kladde, der er integreret med finans.;
                                 ENU=Post fixed asset transactions, such as acquisition and depreciation, in integration with the general ledger. The FA G/L Journal is a general journal, which is integrated into the general ledger.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 251;
                      RunPageView=WHERE(Template Type=CONST(Assets),
                                        Recurring=CONST(No)) }
      { 24      ;2   ;Action    ;
                      CaptionML=[DAN=Anl�gskladder;
                                 ENU=Fixed Assets Journals];
                      ToolTipML=[DAN=Bogf�r transaktioner for faste anl�gsaktiver, f.eks. anskaffelse og afskrivningsprofil, uden integration til finans.;
                                 ENU=Post fixed asset transactions, such as acquisition and depreciation book without integration to the general ledger.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5633;
                      RunPageView=WHERE(Recurring=CONST(No)) }
      { 20      ;2   ;Action    ;
                      CaptionML=[DAN=Anl�gsompost.kladde;
                                 ENU=Fixed Assets Reclass. Journals];
                      ToolTipML=[DAN=Overf�r, opdel eller kombiner anl�gsaktiver ved at g�re omposteringsposter klar til bogf�ring i anl�gskladden.;
                                 ENU=Transfer, split, or combine fixed assets by preparing reclassification entries to be posted in the fixed asset journal.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5640 }
      { 22      ;2   ;Action    ;
                      CaptionML=[DAN=Forsikringskladder;
                                 ENU=Insurance Journals];
                      ToolTipML=[DAN=Bogf�r poster under forsikringsposter.;
                                 ENU=Post entries to the insurance coverage ledger.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5655 }
      { 3       ;2   ;Action    ;
                      Name=<Action3>;
                      CaptionML=[DAN=Gentagelseskladder;
                                 ENU=Recurring General Journals];
                      ToolTipML=[DAN=Definer, hvordan transaktioner, der gentages med f� eller ingen �ndringer, skal bogf�res p� finanskonti, bankkonti, debitor- og kreditorkonti eller anl�gskonti.;
                                 ENU=Define how to post transactions that recur with few or no changes to general ledger, bank, customer, vendor, or fixed asset accounts];
                      ApplicationArea=#Advanced;
                      RunObject=Page 251;
                      RunPageView=WHERE(Template Type=CONST(General),
                                        Recurring=CONST(Yes)) }
      { 23      ;2   ;Action    ;
                      CaptionML=[DAN=Anl�gsgentag.kladde;
                                 ENU=Recurring Fixed Asset Journals];
                      ToolTipML=[DAN=Bogf�r tilbagevendende transaktioner for faste anl�gsaktiver, f.eks. anskaffelse og afskrivningsprofil, uden integration til finans.;
                                 ENU=Post recurring fixed asset transactions, such as acquisition and depreciation book without integration to the general ledger.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5633;
                      RunPageView=WHERE(Recurring=CONST(Yes)) }
      { 121     ;1   ;ActionGroup;
                      CaptionML=[DAN=Pengestr�m;
                                 ENU=Cash Flow] }
      { 102     ;2   ;Action    ;
                      CaptionML=[DAN=Pengestr�msprognoser;
                                 ENU=Cash Flow Forecasts];
                      ToolTipML=[DAN=Kombiner forskellige finansielle datakilder for at finde ud af, hvorn�r et kontant overskud eller underskud sker, eller om du skal afbetale g�ld eller optage l�n for at opfylde kommende udgifter.;
                                 ENU=Combine various financial data sources to find out when a cash surplus or deficit might happen or whether you should pay down debt, or borrow to meet upcoming expenses.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 849 }
      { 142     ;2   ;Action    ;
                      CaptionML=[DAN=Pengestr�mskontoplan;
                                 ENU=Chart of Cash Flow Accounts];
                      ToolTipML=[DAN=F� vist et diagram med en grafisk gengivelse af �n eller flere pengestr�mskonti og �n eller flere pengestr�msops�tninger for det eller de inkluderede finansregnskab, k�b, salg, tjenester eller anl�gskonti.;
                                 ENU=View a chart contain a graphical representation of one or more cash flow accounts and one or more cash flow setups for the included general ledger, purchase, sales, services, or fixed assets accounts.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 851 }
      { 174     ;2   ;Action    ;
                      CaptionML=[DAN=Manuelle pengestr�msindt�gter;
                                 ENU=Cash Flow Manual Revenues];
                      ToolTipML=[DAN=Registrer manuelle indt�gter, f.eks. lejeindt�gter, renter fra finansielle anl�g eller ny privat kapital, der skal bruges i pengestr�msprognoser.;
                                 ENU=Record manual revenues, such as rental income, interest from financial assets, or new private capital to be used in cash flow forecasting.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 857 }
      { 177     ;2   ;Action    ;
                      CaptionML=[DAN=Manuelle pengestr�msudgifter;
                                 ENU=Cash Flow Manual Expenses];
                      ToolTipML=[DAN=Registrer manuelle udgifter, f.eks. l�nninger, renter p� kredit eller planlagte investeringer, der skal bruges i pengestr�msprognoser.;
                                 ENU=Record manual expenses, such as salaries, interest on credit, or planned investments to be used in cash flow forecasting.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 859 }
      { 84      ;1   ;ActionGroup;
                      CaptionML=[DAN=Omkostningsregnskab;
                                 ENU=Cost Accounting] }
      { 77      ;2   ;Action    ;
                      CaptionML=[DAN=Omkostningstyper;
                                 ENU=Cost Types];
                      ToolTipML=[DAN=Vis diagrammet over omkostningstyper med en struktur og funktionalitet, der minder om finanskontoplanen. Du kan overf�re finanskontoens resultatopg�relseskonti eller oprette dit eget diagram over omkostningstyper.;
                                 ENU=View the chart of cost types with a structure and functionality that resembles the general ledger chart of accounts. You can transfer the general ledger income statement accounts or create your own chart of cost types.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Page 1100 }
      { 75      ;2   ;Action    ;
                      CaptionML=[DAN=Omkostningssteder;
                                 ENU=Cost Centers];
                      ToolTipML=[DAN=Administrer omkostningssteder, som er afdelinger og overskudscentre, der er ansvarlige for omkostninger og indt�gter. Der findes ofte flere omkostningssteder i et omkostningsregnskab end i en dimension, der er oprettet i finansregnskabet. I finansregnskabet anvendes normalt kun omkostningssteder p� f�rste niveau for direkte omkostninger, og de oprindelige omkostninger anvendes. I et omkostningsregnskab oprettes ekstra omkostningssteder for yderligere fordelingsniveauer.;
                                 ENU=Manage cost centers, which are departments and profit centers that are responsible for costs and income. Often, there are more cost centers set up in cost accounting than in any dimension that is set up in the general ledger. In the general ledger, usually only the first level cost centers for direct costs and the initial costs are used. In cost accounting, additional cost centers are created for additional allocation levels.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Page 1122 }
      { 74      ;2   ;Action    ;
                      CaptionML=[DAN=Omkostningsemner;
                                 ENU=Cost Objects];
                      ToolTipML=[DAN=Konfigurer omkostningsemner, som er en virksomheds produkter, produktgrupper eller servicer. Dette er en virksomheds f�rdigvarer, der b�rer omkostningerne. Du kan sammenk�de omkostningssteder med afdelinger og omkostningsemner til projekter i virksomheden.;
                                 ENU=Set up cost objects, which are products, product groups, or services of a company. These are the finished goods of a company that carry the costs. You can link cost centers to departments and cost objects to projects in your company.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Page 1123 }
      { 63      ;2   ;Action    ;
                      CaptionML=[DAN=Omkostningsfordelinger;
                                 ENU=Cost Allocations];
                      ToolTipML=[DAN=Administrer fordelingsregler for at fordele omkostninger og indt�gter mellem omkostningstyper, omkostningssteder og omkostningsemner. Hver fordeling best�r af en fordelingskilde og et eller flere fordelingsm�l. Eksempelvis er alle omkostninger for omkostningstypen El og varme en fordelingskilde. Det er en god id� at fordele omkostningerne til omkostningsstederne Workshop, Produktion og Salg, som er tre fordelingsm�l.;
                                 ENU=Manage allocation rules to allocate costs and revenues between cost types, cost centers, and cost objects. Each allocation consists of an allocation source and one or more allocation targets. For example, all costs for the cost type Electricity and Heating are an allocation source. You want to allocate the costs to the cost centers Workshop, Production, and Sales, which are three allocation targets.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Page 1102 }
      { 1       ;2   ;Action    ;
                      CaptionML=[DAN=Omkostningsbudgetter;
                                 ENU=Cost Budgets];
                      ToolTipML=[DAN=Konfigurer omkostningsregnskabsbudgetter, der er oprettet ud fra omkostningstyper, pr�cis som et budget for finansregnskabet oprettes baseret p� finanskontiene. Et omkostningsbudget oprettes for en bestemt periode, f.eks. et regnskabs�r. Du kan oprette et ubegr�nset antal omkostningsbudgetter efter behov. Du kan oprette et nyt omkostningsbudget manuelt eller ved at importere et omkostningsbudget eller ved at kopiere et eksisterende omkostningsbudget som basis for budgettet.;
                                 ENU=Set up cost accounting budgets that are created based on cost types just as a budget for the general ledger is created based on general ledger accounts. A cost budget is created for a certain period of time, for example, a fiscal year. You can create as many cost budgets as needed. You can create a new cost budget manually, or by importing a cost budget, or by copying an existing cost budget as the budget base.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Page 1116 }
      { 39      ;1   ;ActionGroup;
                      CaptionML=[DAN=Bogf�rte dokumenter;
                                 ENU=Posted Documents];
                      Image=FiledPosted }
      { 25      ;2   ;Action    ;
                      CaptionML=[DAN=Bogf. salgsfakturaer;
                                 ENU=Posted Sales Invoices];
                      ToolTipML=[DAN=�bn listen over bogf�rte salgsfakturaer.;
                                 ENU=Open the list of posted sales invoices.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 143;
                      Image=PostedOrder }
      { 26      ;2   ;Action    ;
                      CaptionML=[DAN=Bogf. salgskr.notaer;
                                 ENU=Posted Sales Credit Memos];
                      ToolTipML=[DAN=�bn listen over bogf�rte salgskreditnotaer.;
                                 ENU=Open the list of posted sales credit memos.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 144;
                      Image=PostedOrder }
      { 27      ;2   ;Action    ;
                      CaptionML=[DAN=Bogf. k�bsfakturaer;
                                 ENU=Posted Purchase Invoices];
                      ToolTipML=[DAN=�bn listen over bogf�rte k�bsfakturaer.;
                                 ENU=Open the list of posted purchase invoices.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 146 }
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
                                 ENU=Issued Fin. Charge Memos];
                      ToolTipML=[DAN=Vis oversigten over udstedte rentenotaer.;
                                 ENU=View the list of issued finance charge memos.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 452;
                      Image=PostedMemo }
      { 92      ;2   ;Action    ;
                      CaptionML=[DAN=Finansjournaler;
                                 ENU=G/L Registers];
                      ToolTipML=[DAN=Vis bogf�rte finansposter.;
                                 ENU=View posted G/L entries.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 116;
                      Image=GLRegisters }
      { 83      ;2   ;Action    ;
                      CaptionML=[DAN=Registre for omkostningsregnskab;
                                 ENU=Cost Accounting Registers];
                      ToolTipML=[DAN=F� et overblik over alle omkostningsposter sorteret efter bogf�ringsdato.;
                                 ENU="Get an overview of all cost entries sorted by posting date. "];
                      ApplicationArea=#CostAccounting;
                      RunObject=Page 1104 }
      { 91      ;2   ;Action    ;
                      CaptionML=[DAN=Budgetregistre for omkostningsregnskab;
                                 ENU=Cost Accounting Budget Registers];
                      ToolTipML=[DAN=F� et overblik over alle omkostningsbudgetposter sorteret efter bogf�ringsdato.;
                                 ENU="Get an overview of all cost budget entries sorted by posting date. "];
                      ApplicationArea=#CostAccounting;
                      RunObject=Page 1121 }
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
      { 43      ;2   ;Action    ;
                      CaptionML=[DAN=Analysevisninger;
                                 ENU=Analysis Views];
                      ToolTipML=[DAN=Analys�r bel�b p� din finanskonto efter deres dimensioner vha. analysevisninger, som du har konfigureret.;
                                 ENU=Analyze amounts in your general ledger by their dimensions using analysis views that you have set up.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 556 }
      { 93      ;2   ;Action    ;
                      CaptionML=[DAN=Kontoskemaer;
                                 ENU=Account Schedules];
                      ToolTipML=[DAN=F� indsigt i de finansielle data i din kontoplan. Kontoskemaer analyserer tal i finanskonti og sammenligner finansposter med finansbudgetposter. Eksempelvis kan du f� vist finansposterne som en procentsats af budgetposterne. Kontoskemaer indeholder data om de vigtigste �rsregnskaber og visninger, f.eks. pengestr�msdiagrammet.;
                                 ENU=Get insight into the financial data stored in your chart of accounts. Account schedules analyze figures in G/L accounts, and compare general ledger entries with general ledger budget entries. For example, you can view the general ledger entries as percentages of the budget entries. Account schedules provide the data for core financial statements and views, such as the Cash Flow chart.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 103 }
      { 44      ;2   ;Action    ;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr�de, projekt eller afdeling, som du kan tildele til salgs- og k�bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      RunObject=Page 536;
                      Image=Dimensions }
      { 45      ;2   ;Action    ;
                      CaptionML=[DAN=Bankkontobogf�ringsgrupper;
                                 ENU=Bank Account Posting Groups];
                      ToolTipML=[DAN=Opret bogf�ringsgrupper, s� betalinger til og fra de enkelte bankkonti bogf�res p� den angivne finanskonto.;
                                 ENU=Set up posting groups, so that payments in and out of each bank account are posted to the specified general ledger account.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 373 }
      { 105     ;0   ;ActionContainer;
                      ActionContainerType=NewDocumentItems }
      { 66      ;1   ;Action    ;
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
      { 65      ;1   ;Action    ;
                      CaptionML=[DAN=&K�bskreditnota;
                                 ENU=P&urchase Credit Memo];
                      ToolTipML=[DAN=Opret en ny k�bskreditnota, s� du kan administrere varer, der er returneret til en kreditor.;
                                 ENU=Create a new purchase credit memo so you can manage returned items to a vendor.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 52;
                      Promoted=No;
                      Image=CreditMemo;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 64      ;1   ;Separator ;
                      CaptionML=[DAN=Opgaver;
                                 ENU=Tasks];
                      IsHeader=Yes }
      { 94      ;1   ;Action    ;
                      CaptionML=[DAN=Indbetaling&skladde;
                                 ENU=Cas&h Receipt Journal];
                      ToolTipML=[DAN=Udlign modtagne betalinger med de relaterede ikke-bogf�rte salgsbilag.;
                                 ENU=Apply received payments to the related non-posted sales documents.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 255;
                      Image=CashReceiptJournal }
      { 95      ;1   ;Action    ;
                      CaptionML=[DAN=&Udbetalingskladde;
                                 ENU=Pa&yment Journal];
                      ToolTipML=[DAN=Foretag betalinger til kreditorer.;
                                 ENU=Make payments to vendors.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 256;
                      Image=PaymentJournal }
      { 67      ;1   ;Separator  }
      { 110     ;1   ;Action    ;
                      CaptionML=[DAN=Analy&sevisninger;
                                 ENU=Analysis &Views];
                      ToolTipML=[DAN=Analys�r bel�b p� din finanskonto efter deres dimensioner vha. analysevisninger, som du har konfigureret.;
                                 ENU=Analyze amounts in your general ledger by their dimensions using analysis views that you have set up.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 556;
                      Image=AnalysisView }
      { 98      ;1   ;Action    ;
                      CaptionML=[DAN=Di&mensionsanalyse;
                                 ENU=Analysis by &Dimensions];
                      ToolTipML=[DAN=Analys�r aktiviteter p� grundlag af dimensionsoplysninger.;
                                 ENU=Analyze activities using dimensions information.];
                      ApplicationArea=#Dimensions;
                      RunObject=Page 554;
                      Image=AnalysisViewDimension }
      { 68      ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Beregn afskr&ivninger;
                                 ENU=Calculate Deprec&iation];
                      ToolTipML=[DAN=Beregn afskrivningerne i overensstemmelse med de betingelser, du angiver. Hvis de faste anl�gsaktiver i k�rslen er integreret med finans (defineret i den afskrivningsprofil, der bruges i k�rslen), overf�res posterne til finanskladden for faste anl�gsaktiver. Ellers overf�res posterne til kladden for faste anl�gsaktiver. Du kan postere kladden eller eventuelt justere posteringerne inden bogf�ringen.;
                                 ENU=Calculate depreciation according to the conditions that you define. If the fixed assets that are included in the batch job are integrated with the general ledger (defined in the depreciation book that is used in the batch job), the resulting entries are transferred to the fixed assets general ledger journal. Otherwise, the batch job transfers the entries to the fixed asset journal. You can then post the journal or adjust the entries before posting, if necessary.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 5692;
                      Image=CalculateDepreciation }
      { 69      ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Indl&�s konsolidering fra database;
                                 ENU=Import Co&nsolidation from Database];
                      ToolTipML=[DAN=Import�r poster fra de koncernvirksomheder, der skal indg� i en konsolidering. Du kan anvende k�rslen, hvis koncernvirksomheden stammer fra den samme database i Dynamics NAV som det konsoliderede regnskab.;
                                 ENU=Import entries from the business units that will be included in a consolidation. You can use the batch job if the business unit comes from the same database in Dynamics NAV as the consolidated company.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 90;
                      Image=ImportDatabase }
      { 70      ;1   ;Action    ;
                      CaptionML=[DAN=Bankkontoafst&emning;
                                 ENU=Bank Account R&econciliation];
                      ToolTipML=[DAN=Se posterne og saldoen p� dine bankkonti i forhold til et kontoudtog fra banken.;
                                 ENU=View the entries and the balance on your bank accounts against a statement from the bank.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 379;
                      Image=BankAccountRec }
      { 109     ;1   ;Action    ;
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
      { 71      ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kursreguler valutabe&holdninger;
                                 ENU=Adjust E&xchange Rates];
                      ToolTipML=[DAN=Reguler finans-, debitor-, kreditor- og bankkontoposter, s� de svarer til den opdaterede saldo i situationer, hvor kursen har �ndret sig siden bogf�ringen.;
                                 ENU=Adjust general ledger, customer, vendor, and bank account entries to reflect a more updated balance if the exchange rate has changed since the entries were posted.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 595;
                      Image=AdjustExchangeRates }
      { 72      ;1   ;Action    ;
                      CaptionML=[DAN=Bog&f�r lagerregulering;
                                 ENU=P&ost Inventory Cost to G/L];
                      ToolTipML=[DAN=Registrer �ndringen i antal og v�rdi for lageret i vareposterne og v�rdiposterne, n�r du bogf�rer lagertransaktioner som f.eks. salgsleverancer eller k�bsmodtagelser.;
                                 ENU=Record the quantity and value changes to the inventory in the item ledger entries and the value entries when you post inventory transactions, such as sales shipments or purchase receipts.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 1002;
                      Image=PostInventoryToGL }
      { 97      ;1   ;Separator  }
      { 78      ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Op&ret rykkere;
                                 ENU=C&reate Reminders];
                      ToolTipML=[DAN=Opret rykkere for en eller flere debitorer med forfaldne betalinger.;
                                 ENU=Create reminders for one or more customers with overdue payments.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 188;
                      Image=CreateReminders }
      { 79      ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=O&pret rentenotaer;
                                 ENU=Create Finance Charge &Memos];
                      ToolTipML=[DAN=Opret rentenotaer for en eller flere debitorer med forfaldne betalinger.;
                                 ENU=Create finance charge memos for one or more customers with overdue payments.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 191;
                      Image=CreateFinanceChargememo }
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
      { 1060005 ;1   ;Action    ;
                      CaptionML=[DAN=Opret elektroniske servicefakturaer;
                                 ENU=Create Electronic Service Invoices];
                      ToolTipML=[DAN=Opret en elektronisk version af det aktuelle dokument.;
                                 ENU=Create an electronic version of the current document.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 13604;
                      Image=ElectronicDoc }
      { 1060004 ;1   ;Action    ;
                      CaptionML=[DAN=Opret elektroniske servicekreditnotaer;
                                 ENU=Create Electronic Service Credit Memos];
                      ToolTipML=[DAN=Opret en elektronisk version af det aktuelle dokument.;
                                 ENU=Create an electronic version of the current document.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 13605;
                      Image=ElectronicDoc }
      { 73      ;1   ;Separator  }
      { 81      ;1   ;Action    ;
                      CaptionML=[DAN=Intrastat&kladde;
                                 ENU=Intrastat &Journal];
                      ToolTipML=[DAN=Rapport�r handel med andre EU-lande/omr�der ved rapportering til Intrastat.;
                                 ENU=Report your trade with other EU countries/regions for Intrastat reporting.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 327;
                      Image=Journal }
      { 82      ;1   ;Action    ;
                      CaptionML=[DAN=Afreg&n moms;
                                 ENU=Calc. and Pos&t VAT Settlement];
                      ToolTipML=[DAN=Luk �bne momsposter og overf�rer k�bs- og salgsmomsbel�b til momsafregningskontoen. For hver momsbogf�ringsgruppe finder k�rslen alle momsposter i den momsposttabel, der er inkluderet i filtrene i definitionsvinduet.;
                                 ENU=Close open VAT entries and transfers purchase and sales VAT amounts to the VAT settlement account. For every VAT posting group, the batch job finds all the VAT entries in the VAT Entry table that are included in the filters in the definition window.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 20;
                      Image=SettleOpenTransactions }
      { 80      ;1   ;Separator ;
                      CaptionML=[DAN=Ops�tning;
                                 ENU=Administration];
                      IsHeader=Yes }
      { 85      ;1   ;Action    ;
                      CaptionML=[DAN=&Ops�tning af Finans;
                                 ENU=General &Ledger Setup];
                      ToolTipML=[DAN=Bogf�r �konomiske transaktioner direkte til finanskonti og andre konti som f.eks. bank-, debitor-, kreditor- og medarbejderkonti. Bogf�ring med en finanskladde opretter altid poster p� finanskontiene. Dette g�lder ogs�, n�r du eksempelvis bogf�rer en kladdelinje til en debitorkonto, fordi der er bogf�rt en post til finansregnskabets konto for tilgodehavender via en bogf�ringsgruppe.;
                                 ENU=Post financial transactions directly to general ledger accounts and other accounts, such as bank, customer, vendor, and employee accounts. Posting with a general journal always creates entries on general ledger accounts. This is true even when, for example, you post a journal line to a customer account, because an entry is posted to a general ledger receivables account through a posting group.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 118;
                      Image=Setup }
      { 86      ;1   ;Action    ;
                      CaptionML=[DAN=Salgsops�&tning;
                                 ENU=&Sales && Receivables Setup];
                      ToolTipML=[DAN=Definer dine generelle politikker for fakturering af salg og for returneringer, som f.eks. hvorn�r krediterings- og beholdningsadvarsler skal vises, og hvordan salgsrabatter skal bogf�res. Konfigurer dine nummerserier for oprettelse af debitorer og forskellige salgsbilag.;
                                 ENU=Define your general policies for sales invoicing and returns, such as when to show credit and stockout warnings and how to post sales discounts. Set up your number series for creating customers and different sales documents.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 459;
                      Image=Setup }
      { 87      ;1   ;Action    ;
                      CaptionML=[DAN=K�&bsops�tning;
                                 ENU=&Purchases && Payables Setup];
                      ToolTipML=[DAN=Definer dine generelle politikker for fakturering af k�b og for returneringer, som f.eks. om kreditorfakturanumre skal angives, og hvordan k�bsrabatter skal bogf�res. Konfigurer dine nummerserier for oprettelse af kreditorer og forskellige k�bsbilag.;
                                 ENU=Define your general policies for purchase invoicing and returns, such as whether to require vendor invoice numbers and how to post purchase discounts. Set up your number series for creating vendors and different purchase documents.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 460;
                      Image=Setup }
      { 88      ;1   ;Action    ;
                      CaptionML=[DAN=&Anl�gsops�tning;
                                 ENU=&Fixed Asset Setup];
                      ToolTipML=[DAN=Definer regnskabspolitikkerne for anl�gsaktiver som f.eks. den tilladte bogf�ringsperiode, og hvorvidt bogf�ring p� hovedanl�g er tilladt. Konfigurer nummerserien for oprettelse af nye anl�gsaktiver.;
                                 ENU=Define your accounting policies for fixed assets, such as the allowed posting period and whether to allow posting to main assets. Set up your number series for creating new fixed assets.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5607;
                      Image=Setup }
      { 101     ;1   ;Action    ;
                      CaptionML=[DAN=Pengestr�mskonfiguration;
                                 ENU=Cash Flow Setup];
                      ToolTipML=[DAN=Konfigurer de konti, hvor pengestr�mstal for salgs-, k�bs- og anl�gsposter gemmes.;
                                 ENU=Set up the accounts where cash flow figures for sales, purchase, and fixed-asset transactions are stored.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 846;
                      Image=CashFlowSetup }
      { 96      ;1   ;Action    ;
                      CaptionML=[DAN=Konfiguration af omkostningsregnskab;
                                 ENU=Cost Accounting Setup];
                      ToolTipML=[DAN=Angiv, hvordan du overf�rer finansposter til omkostningsregnskabet, hvordan du sammenk�der dimensioner med omkostningssteder og omkostningsemner, og hvordan du h�ndterer fordelings-id og fordelingsbilagsnummer.;
                                 ENU=Specify how you transfer general ledger entries to cost accounting, how you link dimensions to cost centers and cost objects, and how you handle the allocation ID and allocation document number.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Page 1113;
                      Image=CostAccountingSetup }
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

    { 99  ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page762;
                Visible=false;
                PartType=Page }

    { 1902304208;2;Part   ;
                ApplicationArea=#Advanced;
                PagePartID=Page9030;
                PartType=Page }

    { 1907692008;2;Part   ;
                ApplicationArea=#Advanced;
                PagePartID=Page9150;
                PartType=Page }

    { 1900724708;1;Group   }

    { 103 ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page760;
                Visible=FALSE;
                PartType=Page }

    { 106 ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page675;
                Visible=false;
                PartType=Page }

    { 100 ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page869;
                PartType=Page }

    { 1902476008;2;Part   ;
                ApplicationArea=#Advanced;
                PagePartID=Page9151;
                PartType=Page }

    { 108 ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page681;
                PartType=Page }

    { 1903012608;2;Part   ;
                ApplicationArea=#Advanced;
                PagePartID=Page9175;
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

