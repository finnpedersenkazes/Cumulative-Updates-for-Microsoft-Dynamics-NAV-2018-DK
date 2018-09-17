OBJECT Page 9027 Accountant Role Center
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
               DAN=Revisor;
               ENU=Accountant];
    PageType=RoleCenter;
    ActionList=ACTIONS
    {
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 111     ;1   ;ActionGroup;
                      CaptionML=[DAN=Finansrapporter;
                                 ENU=G/L Reports] }
      { 32      ;2   ;Action    ;
                      CaptionML=[DAN=&Finans - balance;
                                 ENU=&G/L Trial Balance];
                      ToolTipML=[DAN=Vis, udskriv, eller send en rapport, der viser saldo for finanskontiene, herunder debet og kredit. Du kan bruge denne rapport til at sikre nõjagtig regnskabspraksis.;
                                 ENU=View, print, or send a report that shows the balances for the general ledger accounts, including the debits and credits. You can use this report to ensure accurate accounting practices.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 6;
                      Image=Report }
      { 33      ;2   ;Action    ;
                      CaptionML=[DAN=&Bankoplysningers rÜbalance;
                                 ENU=&Bank Detail Trial Balance];
                      ToolTipML=[DAN=Vis, udskriv, eller send en rapport, der viser en detaljeret rÜbalance for udvalgte bankkonti. Du kan bruge rapporten ved afslutningen af en regnskabsperiode eller ved Ürsopgõrelsen.;
                                 ENU=View, print, or send a report that shows a detailed trial balance for selected bank accounts. You can use the report at the close of an accounting period or fiscal year.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 1404;
                      Image=Report }
      { 34      ;2   ;Action    ;
                      CaptionML=[DAN=Kontoske&ma;
                                 ENU=&Account Schedule];
                      ToolTipML=[DAN=èbn et kontoskema til at analysere tal i finanskonti eller sammenligne finansposter med finansbudgetposter.;
                                 ENU=Open an account schedule to analyze figures in general ledger accounts or to compare general ledger entries with general ledger budget entries.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 25;
                      Image=Report }
      { 35      ;2   ;Action    ;
                      CaptionML=[DAN=Bu&dget;
                                 ENU=Bu&dget];
                      ToolTipML=[DAN=Vis eller rediger anslÜede belõb for et interval af regnskabsperioder.;
                                 ENU=View or edit estimated amounts for a range of accounting periods.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 8;
                      Image=Report }
      { 36      ;2   ;Action    ;
                      CaptionML=[DAN=Balan&ce/budget;
                                 ENU=Trial Bala&nce/Budget];
                      ToolTipML=[DAN=Vis en rÜbalance, der sammenlignes med et budget. Du kan f.eks. vëlge at fÜ vist en rÜbalance for udvalgte dimensioner. Du kan bruge rapporten ved afslutningen af en regnskabsperiode eller ved Ürsopgõrelsen.;
                                 ENU=View a trial balance in comparison to a budget. You can choose to see a trial balance for selected dimensions. You can use the report at the close of an accounting period or fiscal year.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 9;
                      Image=Report }
      { 37      ;2   ;Action    ;
                      CaptionML=[DAN=RÜbalance efter &periode;
                                 ENU=Trial Balance by &Period];
                      ToolTipML=[DAN=Viser primosaldoen efter finanskonto, bevëgelserne i den valgte periode for mÜned, kvartal eller Ür, og den resulterende ultimosaldo.;
                                 ENU=Show the opening balance by general ledger account, the movements in the selected period of month, quarter, or year, and the resulting closing balance.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 38;
                      Image=Report }
      { 46      ;2   ;Action    ;
                      CaptionML=[DAN=&Saldo for regnskabsÜr;
                                 ENU=&Fiscal Year Balance];
                      ToolTipML=[DAN=Vis, udskriv, eller send en rapport, der viser bevëgelser pÜ balancen for udvalgte perioder. Rapporten viser slutsaldoen ved afslutningen af det foregÜende regnskabsÜr for de valgte konti. Den viser ogsÜ regnskabsÜret til dato, dette regnskabsÜr ved afslutningen af den valgte periode og saldoen ved afslutningen af den valgte periode med undtagelse af ultimoposterne. Rapporten kan bruges ved afslutningen af en regnskabsperiode eller ved Ürsafslutningen.;
                                 ENU=View, print, or send a report that shows balance sheet movements for selected periods. The report shows the closing balance by the end of the previous fiscal year for the selected ledger accounts. It also shows the fiscal year until this date, the fiscal year by the end of the selected period, and the balance by the end of the selected period, excluding the closing entries. The report can be used at the close of an accounting period or fiscal year.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 36;
                      Image=Report }
      { 47      ;2   ;Action    ;
                      CaptionML=[DAN=Saldosammenlign. - Forr. &Ür;
                                 ENU=Balance Comp. - Prev. Y&ear];
                      ToolTipML=[DAN=Vis en rapport, der viser din virksomheds aktiver, passiver og egenkapital sammenlignet med det forrige Ür.;
                                 ENU=View a report that shows your company's assets, liabilities, and equity compared to the previous year.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 37;
                      Image=Report }
      { 48      ;2   ;Action    ;
                      CaptionML=[DAN=è&rsregnskab;
                                 ENU=&Closing Trial Balance];
                      ToolTipML=[DAN=Vis, udskriv, eller send en rapport, der viser dette og sidste Ürs tal som en almindelig rÜbalance. Nulstilling af resultatopgõrelseskonti bogfõres ultimo i regnskabsÜret. Rapporten kan bruges i forbindelse med Ürsafslutning.;
                                 ENU=View, print, or send a report that shows this year's and last year's figures as an ordinary trial balance. The closing of the income statement accounts is posted at the end of a fiscal year. The report can be used in connection with closing a fiscal year.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 10;
                      Image=Report }
      { 153     ;2   ;Action    ;
                      CaptionML=[DAN=Dimensioner - i alt;
                                 ENU=Dimensions - Total];
                      ToolTipML=[DAN=Vis, hvordan dimensioner eller dimensionsgrupper anvendes pÜ poster ud fra belõb i alt i en bestemt periode og for en bestemt analysevisning.;
                                 ENU=View how dimensions or dimension sets are used on entries based on total amounts over a specified period and for a specified analysis view.];
                      ApplicationArea=#Suite;
                      RunObject=Report 27;
                      Image=Report }
      { 49      ;1   ;ActionGroup;
                      CaptionML=[DAN=Pengestrõm;
                                 ENU=Cash Flow] }
      { 104     ;2   ;Action    ;
                      CaptionML=[DAN=Pengestrõmsdatoliste;
                                 ENU=Cash Flow Date List];
                      ToolTipML=[DAN=FÜ vist prognoseposter for en periode, du angiver. De registrerede pengestrõmsprognoseposter organiseres efter kildetyper, f.eks. tilgodehavender, salgsordrer, skyldige belõb og kõbsordrer. Du angiver antal perioder og lëngden af dem.;
                                 ENU=View forecast entries for a period of time that you specify. The registered cash flow forecast entries are organized by source types, such as receivables, sales orders, payables, and purchase orders. You specify the number of periods and their length.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 846;
                      Image=Report }
      { 115     ;1   ;ActionGroup;
                      CaptionML=[DAN=Debitorer og kreditorer;
                                 ENU=Customers and Vendors] }
      { 50      ;2   ;Action    ;
                      CaptionML=[DAN=Aldersfordelte tilgode&havender;
                                 ENU=Aged Accounts &Receivable];
                      ToolTipML=[DAN=Vis en oversigt over, hvornÜr dine tilgodehavender fra debitorer skal betales eller rykkes for (opdelt i fire tidsperioder). Du skal angive den dato, som aldersfordelingen skal beregnes ud fra, og du skal angive den periode, som hver kolonne skal indeholde data for.;
                                 ENU=View an overview of when your receivables from customers are due or overdue (divided into four periods). You must specify the date you want aging calculated from and the length of the period that each column will contain data for.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 120;
                      Image=Report }
      { 51      ;2   ;Action    ;
                      CaptionML=[DAN=Aldersfordelt &gëld;
                                 ENU=Aged Accounts Pa&yable];
                      ToolTipML=[DAN=Vis en oversigt over, hvornÜr dine skyldige belõb til kreditorer skal betales eller rykkes for (opdelt i fire tidsperioder). Du skal angive den dato, som aldersfordelingen skal beregnes ud fra, og du skal angive den periode, som hver kolonne skal indeholde data for.;
                                 ENU=View an overview of when your payables to vendors are due or overdue (divided into four periods). You must specify the date you want aging calculated from and the length of the period that each column will contain data for.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 322;
                      Image=Report }
      { 52      ;2   ;Action    ;
                      CaptionML=[DAN=Afstem deb.- og &kred.konti;
                                 ENU=Reconcile Cus&t. and Vend. Accs];
                      ToolTipML=[DAN=Vis, om en bestemt finanskonto afstemmer balancen pÜ en bestemt dato for den tilsvarende bogfõringsgruppe. Rapporten viser de konti, der medtages i afstemningen af finansbalancen og debitor- eller leverandõrbalancen for hver konto, samt eventuelle forskelle mellem finansbalancen og debitor- eller leverandõrbalancen.;
                                 ENU=View if a certain general ledger account reconciles the balance on a certain date for the corresponding posting group. The report shows the accounts that are included in the reconciliation with the general ledger balance and the customer or the vendor ledger balance for each account and shows any differences between the general ledger balance and the customer or vendor ledger balance.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 33;
                      Image=Report }
      { 53      ;1   ;ActionGroup;
                      CaptionML=[DAN=Momsrapporter;
                                 ENU=VAT Reports] }
      { 54      ;2   ;Action    ;
                      CaptionML=[DAN=K&ontrol af SE/CVR-nr.;
                                 ENU=&VAT Registration No. Check];
                      ToolTipML=[DAN=Brug en tjeneste til validering af EU-momsnumre til at validere en forretningspartners momsnummer.;
                                 ENU=Use an EU VAT number validation service to validated the VAT number of a business partner.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 32;
                      Image=Report }
      { 55      ;2   ;Action    ;
                      CaptionML=[DAN=Momsun&dtagelser;
                                 ENU=VAT E&xceptions];
                      ToolTipML=[DAN=Vis de momsposter, der er bogfõrt og placeret i en finansjournal i forbindelse med en momsdifference. Rapporten bruges til at dokumentere reguleringer af momsbelõb, der er beregnet til brug intern eller ekstern revision.;
                                 ENU=View the VAT entries that were posted and placed in a general ledger register in connection with a VAT difference. The report is used to document adjustments made to VAT amounts that were calculated for use in internal or external auditing.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 31;
                      Image=Report }
      { 56      ;2   ;Action    ;
                      CaptionML=[DAN=Moms&angivelse;
                                 ENU=VAT &Statement];
                      ToolTipML=[DAN=Vis en opgõrelse over bogfõrt moms, og beregn de skyldige afgifter for den valgte periode til toldvësenet.;
                                 ENU=View a statement of posted VAT and calculate the duty liable to the customs authorities for the selected period.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 12;
                      Image=Report }
      { 57      ;2   ;Action    ;
                      CaptionML=[DAN=Moms - listeangivels&e TS;
                                 ENU=VAT - VIES Declaration Tax Aut&h];
                      ToolTipML=[DAN=Vis oplysninger til told- og skattemyndighederne ved salg til andre EU-lande/omrÜder. Hvis oplysningerne skal skrives til en fil, kan du bruge rapporten Moms - listeangivelse disk.;
                                 ENU=View information to the customs and tax authorities for sales to other EU countries/regions. If the information must be printed to a file, you can use the VAT- VIES Declaration Disk report.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 19;
                      Image=Report }
      { 58      ;2   ;Action    ;
                      CaptionML=[DAN=M&oms - listeangivelsesdisk;
                                 ENU=VAT - VIES Declaration Dis&k];
                      ToolTipML=[DAN=RapportÇr dit salg til andre EU-lande/-omrÜder til SKAT. Hvis oplysningerne skal udskrives pÜ en printer, kan du bruge rapporten Moms - listeangivelse TS. Oplysningerne er opstillet pÜ samme mÜde som i listeangivelsen fra SKAT.;
                                 ENU=Report your sales to other EU countries or regions to the customs and tax authorities. If the information must be printed out on a printer, you can use the VAT- VIES Declaration Tax Auth report. The information is shown in the same format as in the declaration list from the customs and tax authorities.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 88;
                      Image=Report }
      { 59      ;2   ;Action    ;
                      CaptionML=[DAN=Oversigt over EU-sa&lg;
                                 ENU=EC Sales &List];
                      ToolTipML=[DAN=Beregn momsbelõb fra salg, og indberet belõbene til skattemyndighederne.;
                                 ENU=Calculate VAT amounts from sales, and submit the amounts to a tax authority.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 130;
                      Image=Report }
      { 60      ;1   ;ActionGroup;
                      CaptionML=[DAN=Intrastat;
                                 ENU=Intrastat] }
      { 61      ;2   ;Action    ;
                      CaptionML=[DAN=&Intrastat - kontrolliste;
                                 ENU=&Intrastat - Checklist];
                      ToolTipML=[DAN=Vis en kontrolliste, som du kan bruge til at finde eventuelle fejl inden udskrivningen, og som dokumentation for, hvad der udskrives. Du kan bruge rapporten til at kontrollere Intrastatkladden, fõr du Intrastat - dan diskette TS.;
                                 ENU=View a checklist that you can use to find possible errors before printing and also as documentation for what is printed. You can use the report to check the Intrastat journal before you use the Intrastat - Make Disk Tax Auth batch job.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 502;
                      Image=Report }
      { 62      ;2   ;Action    ;
                      CaptionML=[DAN=Intrastat - bla&nket;
                                 ENU=Intrastat - For&m];
                      ToolTipML=[DAN=Vis alle de oplysninger, der skal overfõres til den udskrevne Intrastat-formular.;
                                 ENU=View all the information that must be transferred to the printed Intrastat form.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 501;
                      Image=Report }
      { 4       ;1   ;ActionGroup;
                      CaptionML=[DAN=Omkostningsregnskab;
                                 ENU=Cost Accounting] }
      { 7       ;2   ;Action    ;
                      CaptionML=[DAN=Resultatopgõrelse i omkostningsregnskab;
                                 ENU=Cost Accounting P/L Statement];
                      ToolTipML=[DAN=Vis kredit- og debetsaldi pr. omkostningstype sammen med diagrammet over omkostningstyper.;
                                 ENU=View the credit and debit balances per cost type, together with the chart of cost types.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Report 1126;
                      Image=Report }
      { 15      ;2   ;Action    ;
                      CaptionML=[DAN=CA-resultatopgõrelse pr. periode;
                                 ENU=CA P/L Statement per Period];
                      ToolTipML=[DAN=Vis resultatopgõrelsen for omkostningstyper over to perioder med sammenligning som en procentdel.;
                                 ENU=View profit and loss for cost types over two periods with the comparison as a percentage.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Report 1123;
                      Image=Report }
      { 21      ;2   ;Action    ;
                      CaptionML=[DAN=CA-resultatopgõrelse med budget;
                                 ENU=CA P/L Statement with Budget];
                      ToolTipML=[DAN=Vis en sammenligning af saldoen med budgettallene, som beregner varians og afvigelse i procent i den aktuelle regnskabsperiode, den akkumulerede regnskabsperiode og regnskabsÜret.;
                                 ENU=View a comparison of the balance to the budget figures and calculates the variance and the percent variance in the current accounting period, the accumulated accounting period, and the fiscal year.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Report 1133;
                      Image=Report }
      { 42      ;2   ;Action    ;
                      CaptionML=[DAN=Analyse af omkostningsregnskab;
                                 ENU=Cost Accounting Analysis];
                      ToolTipML=[DAN=Vis saldi pr. omkostningstype med kolonner for syv felter for omkostningssteder og omkostningsemner. Det bruges som omkostningsfordelingsark i omkostningsregnskabet. Strukturen i linjerne er baseret pÜ diagrammet over omkostningstyper. Du kan angive op til syv omkostningssteder og omkostningsemner, der vises som kolonner i rapporten.;
                                 ENU=View balances per cost type with columns for seven fields for cost centers and cost objects. It is used as the cost distribution sheet in Cost accounting. The structure of the lines is based on the chart of cost types. You define up to seven cost centers and cost objects that appear as columns in the report.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Report 1127;
                      Image=Report }
      { 1900000011;0 ;ActionContainer;
                      ActionContainerType=HomeItems }
      { 2       ;1   ;Action    ;
                      CaptionML=[DAN=Kontoplan;
                                 ENU=Chart of Accounts];
                      ToolTipML=[DAN=èbn kontoplanen.;
                                 ENU=Open the chart of accounts.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 16 }
      { 195     ;1   ;Action    ;
                      CaptionML=[DAN=Bankkonti;
                                 ENU=Bank Accounts];
                      ToolTipML=[DAN=FÜ vist eller konfigurer detaljerede oplysninger om din bankkonto, f.eks. hvilken valuta der skal bruges, formatet pÜ de bankfiler, du importerer og eksporterer som elektroniske betalinger, samt nummereringen af checks.;
                                 ENU=View or set up detailed information about your bank account, such as which currency to use, the format of bank files that you import and export as electronic payments, and the numbering of checks.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 371;
                      Image=BankAccount }
      { 201     ;1   ;Action    ;
                      Name=Customers;
                      CaptionML=[DAN=Kunder (Debitorer);
                                 ENU=Customers];
                      ToolTipML=[DAN=FÜ vist eller rediger detaljerede oplysninger om de debitorer, som du handler med. Fra det enkelte debitorkort kan du fÜ adgang til relaterede oplysninger som f.eks. salgsstatistik og igangvërende ordrer, og du kan definere specialpriser og linjerabatter, som debitoren fÜr, nÜr bestemte betingelser er opfyldt.;
                                 ENU=View or edit detailed information for the customers that you trade with. From each customer card, you can open related information, such as sales statistics and ongoing orders, and you can define special prices and line discounts that you grant if certain conditions are met.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 22;
                      Image=Customer }
      { 8       ;1   ;Action    ;
                      Name=Vendors;
                      CaptionML=[DAN=Kreditorer;
                                 ENU=Vendors];
                      ToolTipML=[DAN=FÜ vist eller rediger detaljerede oplysninger om de kreditorer, som du handler med. Fra det enkelte kreditorkort kan du fÜ adgang til relaterede oplysninger som f.eks. kõbsstatistik og igangvërende ordrer, og du kan definere specialpriser og linjerabatter, som kreditoren giver dig, nÜr bestemte betingelser er opfyldt.;
                                 ENU=View or edit detailed information for the vendors that you trade with. From each vendor card, you can open related information, such as purchase statistics and ongoing orders, and you can define special prices and line discounts that the vendor grants you if certain conditions are met.];
                      ApplicationArea=#Basic,#Suite;
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
                      CaptionML=[DAN=Kõbsordrer;
                                 ENU=Purchase Orders];
                      ToolTipML=[DAN=Opret kõbsordrer for at afspejle de salgsbilag, som leverandõrer sender til dig. PÜ denne mÜde kan du registrere kõbsomkostninger og spore kreditorer. Bogfõringen af kõbsordrer opdaterer lagerniveauerne dynamisk, sÜ du kan minimere lageromkostningerne og levere bedre kundeservice. Kõbsordrer tillader delleverancer, modsat kõbsfakturaer, og muliggõr direkte levering fra kreditoren til debitoren. Kõbsordrer kan oprettes automatisk ud fra PDF- eller billedfiler fra dine kreditorer ved hjëlp af funktionen IndgÜende bilag.;
                                 ENU=Create purchase orders to mirror sales documents that vendors send to you. This enables you to record the cost of purchases and to track accounts payable. Posting purchase orders dynamically updates inventory levels so that you can minimize inventory costs and provide better customer service. Purchase orders allow partial receipts, unlike with purchase invoices, and enable drop shipment directly from your vendor to your customer. Purchase orders can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9307 }
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
      { 119     ;1   ;Action    ;
                      CaptionML=[DAN=IndgÜende bilag;
                                 ENU=Incoming Documents];
                      ToolTipML=[DAN=HÜndter indgÜende bilag, f.eks. kreditorfakturaer i PDF- eller billedfiler, som kan bruges til manuel eller automatisk konvertering til bilagsrecords, f.eks. kõbsfakturaer. De eksterne filer, der reprësenterer indgÜende bilag, kan knyttes til ethvert procestrin, herunder bogfõrte bilag og de resulterende kreditor-, debitor- og finansposter.;
                                 ENU=Handle incoming documents, such as vendor invoices in PDF or as image files, that you can manually or automatically convert to document records, such as purchase invoices. The external files that represent incoming documents can be attached at any process stage, including to posted documents and to the resulting vendor, customer, and general ledger entries.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 190;
                      Image=Documents }
      { 203     ;1   ;Action    ;
                      CaptionML=[DAN=Kõbsfakturaer;
                                 ENU=Purchase Invoices];
                      ToolTipML=[DAN=Opret kõbsfakturaer for at afspejle de salgsbilag, som leverandõrer sender til dig. PÜ denne mÜde kan du registrere kõbsomkostninger og spore kreditorer. Bogfõringen af kõbsfakturaer opdaterer lagerniveauerne dynamisk, sÜ du kan minimere lageromkostningerne og levere bedre kundeservice. Kõbsfakturaer kan oprettes automatisk ud fra PDF- eller billedfiler fra dine kreditorer ved hjëlp af funktionen IndgÜende bilag.;
                                 ENU=Create purchase invoices to mirror sales documents that vendors send to you. This enables you to record the cost of purchases and to track accounts payable. Posting purchase invoices dynamically updates inventory levels so that you can minimize inventory costs and provide better customer service. Purchase invoices can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 9308;
                      Image=Invoice }
      { 143     ;1   ;Action    ;
                      CaptionML=[DAN=Oversigt over EU-salg;
                                 ENU=EC Sales List];
                      ToolTipML=[DAN=Beregn momsbelõb fra salg, og indberet belõbene til skattemyndighederne.;
                                 ENU=Calculate VAT amounts from sales, and submit the amounts to a tax authority.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 323 }
      { 145     ;1   ;Action    ;
                      CaptionML=[DAN=Momsrapportliste;
                                 ENU=VAT Returns];
                      ToolTipML=[DAN=Forbered momsrapporten, sÜ du kan indberette momsbelõb til skattemyndighederne.;
                                 ENU=Prepare the VAT Return report so you can submit VAT amounts to a tax authority.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 744 }
      { 198     ;1   ;Action    ;
                      CaptionML=[DAN=Budgetter;
                                 ENU=Budgets];
                      ToolTipML=[DAN=Vis eller rediger anslÜede belõb for et interval af regnskabsperioder.;
                                 ENU=View or edit estimated amounts for a range of accounting periods.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 121 }
      { 199     ;1   ;Action    ;
                      CaptionML=[DAN=Momsangivelser;
                                 ENU=VAT Statements];
                      ToolTipML=[DAN=FÜ vist en opgõrelse over de bogfõrte momsbelõb, beregn dine momsafregningsbelõb for en bestemt periode som f.eks. et kvartal, og forbered indsendelse af momsangivelsen til myndighederne.;
                                 ENU=View a statement of posted VAT amounts, calculate your VAT settlement amount for a certain period, such as a quarter, and prepare to send the settlement to the tax authorities.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 320;
                      Image=VATStatement }
      { 11      ;1   ;Action    ;
                      Name=Intrastat;
                      CaptionML=[DAN=Intrastat;
                                 ENU=Intrastat];
                      ToolTipML=[DAN=RapportÇr handel med andre EU-lande/omrÜder ved rapportering til Intrastat.;
                                 ENU=Report your trade with other EU countries/regions for Intrastat reporting.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 327 }
      { 1900000012;0 ;ActionContainer;
                      ActionContainerType=ActivityButtons }
      { 107     ;1   ;ActionGroup;
                      CaptionML=[DAN=Kladder;
                                 ENU=Journals];
                      ToolTipML=[DAN=Vis forskellige typer kladder.;
                                 ENU=View different types of journals.];
                      Image=Journals }
      { 117     ;2   ;Action    ;
                      Name=PurchaseJournals;
                      CaptionML=[DAN=Kõbskladder;
                                 ENU=Purchase Journals];
                      ToolTipML=[DAN=Bogfõr enhver transaktion, der er relateret til kõb, direkte til en kreditor-, bankkonto eller finanskonto i stedet at bruge dedikerede bilag. Du kan bogfõre alle typer finansielle kõbstransaktioner, herunder betalinger, refusioner og finansgebyrbelõb. Bemërk, at du ikke kan bogfõre varebeholdninger med en kõbskladde.;
                                 ENU=Post any purchase-related transaction directly to a vendor, bank, or general ledger account instead of using dedicated documents. You can post all types of financial purchase transactions, including payments, refunds, and finance charge amounts. Note that you cannot post item quantities with a purchase journal.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 251;
                      RunPageView=WHERE(Template Type=CONST(Purchases),
                                        Recurring=CONST(No)) }
      { 118     ;2   ;Action    ;
                      Name=SalesJournals;
                      CaptionML=[DAN=Salgskladder;
                                 ENU=Sales Journals];
                      ToolTipML=[DAN=Bogfõr enhver transaktion, der er relateret til salg, direkte til en debitor-, bankkonto eller finanskonto i stedet at bruge dedikerede bilag. Du kan bogfõre alle typer finansielle salgstransaktioner, herunder betalinger, refusioner og finansgebyrbelõb. Bemërk, at du ikke kan bogfõre varebeholdninger med en salgskladde.;
                                 ENU=Post any sales-related transaction directly to a customer, bank, or general ledger account instead of using dedicated documents. You can post all types of financial sales transactions, including payments, refunds, and finance charge amounts. Note that you cannot post item quantities with a sales journal.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 251;
                      RunPageView=WHERE(Template Type=CONST(Sales),
                                        Recurring=CONST(No)) }
      { 113     ;2   ;Action    ;
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
      { 114     ;2   ;Action    ;
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
      { 1102601000;2 ;Action    ;
                      Name=ICGeneralJournals;
                      CaptionML=[DAN=IC-finanskladder;
                                 ENU=IC General Journals];
                      ToolTipML=[DAN=Bogfõr koncerninterne transaktioner. Koncerninterne finanskladdelinjer skal indeholde en koncernintern partnerkonto eller en debitor- eller kreditorkonto, der er tildelt en koncernintern partnerkode.;
                                 ENU=Post intercompany transactions. IC general journal lines must contain either an IC partner account or a customer or vendor account that has been assigned an intercompany partner code.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 251;
                      RunPageView=WHERE(Template Type=CONST(Intercompany),
                                        Recurring=CONST(No)) }
      { 1102601001;2 ;Action    ;
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
      { 1102601002;2 ;Action    ;
                      CaptionML=[DAN=Intrastatkladder;
                                 ENU=Intrastat Journals];
                      ToolTipML=[DAN=Sammenfat vërdien af dine kõb og salg i relation til forretningspartnere i EU med statistik for õje, og klargõr tallene til afsendelse til den relevante myndighed.;
                                 ENU=Summarize the value of your purchases and sales with business partners in the EU for statistical purposes and prepare to send it to the relevant authority.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 327;
                      Image=Report }
      { 16      ;1   ;ActionGroup;
                      CaptionML=[DAN=Anlëg;
                                 ENU=Fixed Assets];
                      ToolTipML=[DAN=Administrer afskrivning og forsikring af anlëgsaktiver.;
                                 ENU=Manage depreciation and insurance of your fixed assets.];
                      Image=FixedAssets }
      { 17      ;2   ;Action    ;
                      CaptionML=[DAN=Anlëg;
                                 ENU=Fixed Assets];
                      ToolTipML=[DAN=AdministrÇr periodisk afskrivning af dine maskiner, hold styr pÜ reparationsomkostningerne, administrÇr forsikringspolicer vedrõrende faste anlëgsaktiver, og overvÜg statistik for faste anlëgsaktiver.;
                                 ENU=Manage periodic depreciation of your machinery or machines, keep track of your maintenance costs, manage insurance policies related to fixed assets, and monitor fixed asset statistics.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5601 }
      { 18      ;2   ;Action    ;
                      CaptionML=[DAN=Forsikring;
                                 ENU=Insurance];
                      ToolTipML=[DAN=Administrer forsikringspolicer for anlëgsaktiver, og overvÜg forsikringsdëkningen.;
                                 ENU=Manage insurance policies for fixed assets and monitor insurance coverage.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5645 }
      { 19      ;2   ;Action    ;
                      CaptionML=[DAN=Anlëgsfinanskladder;
                                 ENU=Fixed Assets G/L Journals];
                      ToolTipML=[DAN=Bogfõr transaktioner for faste anlëgsaktiver, f.eks. anskaffelse og afskrivning, med integration til finans. Anlëgsfinanskladden er en generel kladde, der er integreret med finans.;
                                 ENU=Post fixed asset transactions, such as acquisition and depreciation, in integration with the general ledger. The FA G/L Journal is a general journal, which is integrated into the general ledger.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 251;
                      RunPageView=WHERE(Template Type=CONST(Assets),
                                        Recurring=CONST(No)) }
      { 24      ;2   ;Action    ;
                      CaptionML=[DAN=Anlëgskladder;
                                 ENU=Fixed Assets Journals];
                      ToolTipML=[DAN=Bogfõr transaktioner for faste anlëgsaktiver, f.eks. anskaffelse og afskrivningsprofil, uden integration til finans.;
                                 ENU=Post fixed asset transactions, such as acquisition and depreciation book without integration to the general ledger.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5633;
                      RunPageView=WHERE(Recurring=CONST(No)) }
      { 20      ;2   ;Action    ;
                      CaptionML=[DAN=Anlëgsompost.kladde;
                                 ENU=Fixed Assets Reclass. Journals];
                      ToolTipML=[DAN=Overfõr, opdel eller kombiner faste anlëgsaktiver ved at gõre omposteringsposter klar til bogfõring i kladden for faste anlëgsaktiver.;
                                 ENU=Transfer, split, or combine fixed assets by preparing reclassification entries to be posted in the fixed asset journal.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5640 }
      { 22      ;2   ;Action    ;
                      CaptionML=[DAN=Forsikringskladder;
                                 ENU=Insurance Journals];
                      ToolTipML=[DAN=Bogfõr poster under forsikringsposter.;
                                 ENU=Post entries to the insurance coverage ledger.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5655 }
      { 3       ;2   ;Action    ;
                      Name=<Action3>;
                      CaptionML=[DAN=Gentagelseskladder;
                                 ENU=Recurring General Journals];
                      ToolTipML=[DAN=Definer, hvordan transaktioner, der gentages med fÜ eller ingen ëndringer, skal bogfõres pÜ finanskonti, bankkonti, debitor- og kreditorkonti eller anlëgskonti.;
                                 ENU=Define how to post transactions that recur with few or no changes to general ledger, bank, customer, vendor, or fixed asset accounts];
                      ApplicationArea=#Advanced;
                      RunObject=Page 251;
                      RunPageView=WHERE(Template Type=CONST(General),
                                        Recurring=CONST(Yes)) }
      { 23      ;2   ;Action    ;
                      CaptionML=[DAN=Anlëgsgentag.kladde;
                                 ENU=Recurring Fixed Asset Journals];
                      ToolTipML=[DAN=Bogfõr tilbagevendende transaktioner for faste anlëgsaktiver, f.eks. anskaffelse og afskrivningsprofil, uden integration til finans.;
                                 ENU=Post recurring fixed asset transactions, such as acquisition and depreciation book without integration to the general ledger.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5633;
                      RunPageView=WHERE(Recurring=CONST(Yes)) }
      { 121     ;1   ;ActionGroup;
                      CaptionML=[DAN=Pengestrõm;
                                 ENU=Cash Flow];
                      ToolTipML=[DAN=OvervÜg din pengestrõm, og konfigurer pengestrõmsprognoser.;
                                 ENU=Monitor your cash flow and set up cash flow forecasts.] }
      { 102     ;2   ;Action    ;
                      CaptionML=[DAN=Pengestrõmsprognoser;
                                 ENU=Cash Flow Forecasts];
                      ToolTipML=[DAN=Kombiner forskellige finansielle datakilder for at finde ud af, hvornÜr et kontant overskud eller underskud sker, eller om du skal afbetale gëld eller optage lÜn for at opfylde kommende udgifter.;
                                 ENU=Combine various financial data sources to find out when a cash surplus or deficit might happen or whether you should pay down debt, or borrow to meet upcoming expenses.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 849 }
      { 142     ;2   ;Action    ;
                      CaptionML=[DAN=Pengestrõmskontoplan;
                                 ENU=Chart of Cash Flow Accounts];
                      ToolTipML=[DAN=FÜ vist et diagram med en grafisk gengivelse af Çn eller flere pengestrõmskonti og Çn eller flere pengestrõmsopsëtninger for det eller de inkluderede finansregnskab, kõb, salg, tjenester eller anlëgskonti.;
                                 ENU=View a chart contain a graphical representation of one or more cash flow accounts and one or more cash flow setups for the included general ledger, purchase, sales, services, or fixed assets accounts.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 851 }
      { 174     ;2   ;Action    ;
                      CaptionML=[DAN=Manuelle pengestrõmsindtëgter;
                                 ENU=Cash Flow Manual Revenues];
                      ToolTipML=[DAN=Registrer manuelle indtëgter, f.eks. lejeindtëgter, renter fra finansielle anlëg eller ny privat kapital, der skal bruges i pengestrõmsprognoser.;
                                 ENU=Record manual revenues, such as rental income, interest from financial assets, or new private capital to be used in cash flow forecasting.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 857 }
      { 177     ;2   ;Action    ;
                      CaptionML=[DAN=Manuelle pengestrõmsudgifter;
                                 ENU=Cash Flow Manual Expenses];
                      ToolTipML=[DAN=Registrer manuelle udgifter, f.eks. lõnninger, renter pÜ kredit eller planlagte investeringer, der skal bruges i pengestrõmsprognoser.;
                                 ENU=Record manual expenses, such as salaries, interest on credit, or planned investments to be used in cash flow forecasting.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 859 }
      { 84      ;1   ;ActionGroup;
                      CaptionML=[DAN=Omkostningsregnskab;
                                 ENU=Cost Accounting];
                      ToolTipML=[DAN=Alloker faktiske og budgetterede omkostninger for operationer, afdelinger, produkter og projekter for at analysere din virksomheds rentabilitet.;
                                 ENU=Allocate actual and budgeted costs of operations, departments, products, and projects to analyze the profitability of your company.] }
      { 77      ;2   ;Action    ;
                      CaptionML=[DAN=Omkostningstyper;
                                 ENU=Cost Types];
                      ToolTipML=[DAN=Vis diagrammet over omkostningstyper med en struktur og funktionalitet, der minder om finanskontoplanen. Du kan overfõre finanskontoens resultatopgõrelseskonti eller oprette dit eget diagram over omkostningstyper.;
                                 ENU=View the chart of cost types with a structure and functionality that resembles the general ledger chart of accounts. You can transfer the general ledger income statement accounts or create your own chart of cost types.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Page 1100 }
      { 75      ;2   ;Action    ;
                      CaptionML=[DAN=Omkostningssteder;
                                 ENU=Cost Centers];
                      ToolTipML=[DAN=Administrer omkostningssteder, som er afdelinger og overskudscentre, der er ansvarlige for omkostninger og indtëgter. Der findes ofte flere omkostningssteder i et omkostningsregnskab end i en dimension, der er oprettet i finansregnskabet. I finansregnskabet anvendes normalt kun omkostningssteder pÜ fõrste niveau for direkte omkostninger, og de oprindelige omkostninger anvendes. I et omkostningsregnskab oprettes ekstra omkostningssteder for yderligere fordelingsniveauer.;
                                 ENU=Manage cost centers, which are departments and profit centers that are responsible for costs and income. Often, there are more cost centers set up in cost accounting than in any dimension that is set up in the general ledger. In the general ledger, usually only the first level cost centers for direct costs and the initial costs are used. In cost accounting, additional cost centers are created for additional allocation levels.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Page 1122 }
      { 74      ;2   ;Action    ;
                      CaptionML=[DAN=Omkostningsemner;
                                 ENU=Cost Objects];
                      ToolTipML=[DAN=Konfigurer omkostningsemner, som er en virksomheds produkter, produktgrupper eller servicer. Dette er en virksomheds fërdigvarer, der bërer omkostningerne. Du kan sammenkëde omkostningssteder med afdelinger og omkostningsemner til projekter i virksomheden.;
                                 ENU=Set up cost objects, which are products, product groups, or services of a company. These are the finished goods of a company that carry the costs. You can link cost centers to departments and cost objects to projects in your company.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Page 1123 }
      { 63      ;2   ;Action    ;
                      CaptionML=[DAN=Omkostningsfordelinger;
                                 ENU=Cost Allocations];
                      ToolTipML=[DAN=Administrer fordelingsregler for at fordele omkostninger og indtëgter mellem omkostningstyper, omkostningssteder og omkostningsemner. Hver fordeling bestÜr af en fordelingskilde og et eller flere fordelingsmÜl. Eksempelvis er alle omkostninger for omkostningstypen El og varme en fordelingskilde. Det er en god idÇ at fordele omkostningerne til omkostningsstederne Workshop, Produktion og Salg, som er tre fordelingsmÜl.;
                                 ENU=Manage allocation rules to allocate costs and revenues between cost types, cost centers, and cost objects. Each allocation consists of an allocation source and one or more allocation targets. For example, all costs for the cost type Electricity and Heating are an allocation source. You want to allocate the costs to the cost centers Workshop, Production, and Sales, which are three allocation targets.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Page 1102 }
      { 1       ;2   ;Action    ;
                      CaptionML=[DAN=Omkostningsbudgetter;
                                 ENU=Cost Budgets];
                      ToolTipML=[DAN=Konfigurer omkostningsregnskabsbudgetter, der er oprettet ud fra omkostningstyper, prëcis som et budget for finansregnskabet oprettes baseret pÜ finanskontiene. Et omkostningsbudget oprettes for en bestemt periode, f.eks. et regnskabsÜr. Du kan oprette et ubegrënset antal omkostningsbudgetter efter behov. Du kan oprette et nyt omkostningsbudget manuelt eller ved at importere et omkostningsbudget eller ved at kopiere et eksisterende omkostningsbudget som basis for budgettet.;
                                 ENU=Set up cost accounting budgets that are created based on cost types just as a budget for the general ledger is created based on general ledger accounts. A cost budget is created for a certain period of time, for example, a fiscal year. You can create as many cost budgets as needed. You can create a new cost budget manually, or by importing a cost budget, or by copying an existing cost budget as the budget base.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Page 1116 }
      { 39      ;1   ;ActionGroup;
                      CaptionML=[DAN=Bogfõrte dokumenter;
                                 ENU=Posted Documents];
                      ToolTipML=[DAN=Vis historik over salg, leverancer og lager.;
                                 ENU=View history for sales, shipments, and inventory.];
                      Image=FiledPosted }
      { 25      ;2   ;Action    ;
                      CaptionML=[DAN=Bogf. salgsfakturaer;
                                 ENU=Posted Sales Invoices];
                      ToolTipML=[DAN=èbn listen over bogfõrte salgsfakturaer.;
                                 ENU=Open the list of posted sales invoices.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 143;
                      Image=PostedOrder }
      { 26      ;2   ;Action    ;
                      CaptionML=[DAN=Bogf. salgskr.notaer;
                                 ENU=Posted Sales Credit Memos];
                      ToolTipML=[DAN=èbn listen over bogfõrte salgskreditnotaer.;
                                 ENU=Open the list of posted sales credit memos.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 144;
                      Image=PostedOrder }
      { 27      ;2   ;Action    ;
                      CaptionML=[DAN=Bogf. kõbsfakturaer;
                                 ENU=Posted Purchase Invoices];
                      ToolTipML=[DAN=èbn listen over bogfõrte kõbsfakturaer.;
                                 ENU=Open the list of posted purchase invoices.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 146 }
      { 28      ;2   ;Action    ;
                      CaptionML=[DAN=Bogfõrte kõbskreditnotaer;
                                 ENU=Posted Purchase Credit Memos];
                      ToolTipML=[DAN=èbn listen over bogfõrte kõbskreditnotaer.;
                                 ENU=Open the list of posted purchase credit memos.];
                      ApplicationArea=#Basic,#Suite;
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
                      ToolTipML=[DAN=Vis bogfõrte finansposter.;
                                 ENU=View posted G/L entries.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 116;
                      Image=GLRegisters }
      { 83      ;2   ;Action    ;
                      CaptionML=[DAN=Registre for omkostningsregnskab;
                                 ENU=Cost Accounting Registers];
                      ToolTipML=[DAN=FÜ et overblik over alle omkostningsposter sorteret efter bogfõringsdato.;
                                 ENU="Get an overview of all cost entries sorted by posting date. "];
                      ApplicationArea=#CostAccounting;
                      RunObject=Page 1104 }
      { 91      ;2   ;Action    ;
                      CaptionML=[DAN=Budgetregistre for omkostningsregnskab;
                                 ENU=Cost Accounting Budget Registers];
                      ToolTipML=[DAN=FÜ et overblik over alle omkostningsbudgetposter sorteret efter bogfõringsdato.;
                                 ENU="Get an overview of all cost budget entries sorted by posting date. "];
                      ApplicationArea=#CostAccounting;
                      RunObject=Page 1121 }
      { 31      ;1   ;ActionGroup;
                      CaptionML=[DAN=Opsëtning;
                                 ENU=Administration];
                      ToolTipML=[DAN=Konfigurer regnskabsperioder, betalingsbetingelser og andre vigtige finansielle omrÜder.;
                                 ENU=Set up accounting periods, payments terms, and other core financial areas.];
                      Image=Administration }
      { 38      ;2   ;Action    ;
                      CaptionML=[DAN=Valutaer;
                                 ENU=Currencies];
                      ToolTipML=[DAN=FÜ vist de forskellige valutaer, du handler i, eller opdater valutakurserne ved at hente de seneste kurser fra en ekstern tjenesteudbyder.;
                                 ENU=View the different currencies that you trade in or update the exchange rates by getting the latest rates from an external service provider.];
                      ApplicationArea=#Suite;
                      RunObject=Page 5;
                      Image=Currency }
      { 144     ;2   ;Action    ;
                      CaptionML=[DAN=Medarbejdere;
                                 ENU=Employees];
                      ToolTipML=[DAN=Administrer medarbejderoplysninger og relaterede oplysninger som f.eks. kvalifikationer og billeder, eller registrer og analysÇr medarbejderfravër. Sikring af opdaterede records om medarbejderne forenkler dine personaleopgaver. Hvis en medarbejder f.eks. skifter adresse, kan du registrere dette pÜ medarbejderkortet.;
                                 ENU=Manage employees' details and related information, such as qualifications and pictures, or register and analyze employee absence. Keeping up-to-date records about your employees simplifies personnel tasks. For example, if an employee's address changes, you register this on the employee card.];
                      ApplicationArea=#BasicHR;
                      RunObject=Page 5201 }
      { 40      ;2   ;Action    ;
                      CaptionML=[DAN=Regnskabsperioder;
                                 ENU=Accounting Periods];
                      ToolTipML=[DAN=Angiv antal regnskabsperioder, f.eks. 12 mÜnedsperioder, i regnskabsÜret, og angiv, hvilken periode der er starten pÜ det nye regnskabsÜr.;
                                 ENU=Set up the number of accounting periods, such as 12 monthly periods, within the fiscal year and specify which period is the start of the new fiscal year.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 100;
                      Image=AccountingPeriods }
      { 41      ;2   ;Action    ;
                      CaptionML=[DAN=Nummerserie;
                                 ENU=Number Series];
                      ToolTipML=[DAN=Vis eller rediger den nummerserie, der bruges til at organisere transaktioner;
                                 ENU=View or edit the number series that are used to organize transactions];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 456 }
      { 120     ;2   ;Action    ;
                      CaptionML=[DAN=Betalingsbetingelser;
                                 ENU=Payment Terms];
                      ToolTipML=[DAN=Opsët de betalingsbetingelser, du kan vëlge mellem pÜ debitorkort eller salgsbilag for at definere, hvornÜr debitoren skal betale, f.eks. inden for 14 dage.;
                                 ENU=Set up the payment terms that you select from customer cards or sales documents to define when the customer must pay, such as within 14 days.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 4;
                      Image=Payment }
      { 43      ;2   ;Action    ;
                      CaptionML=[DAN=Analysevisninger;
                                 ENU=Analysis Views];
                      ToolTipML=[DAN=AnalysÇr belõb pÜ din finanskonto efter deres dimensioner vha. analysevisninger, som du har konfigureret.;
                                 ENU=Analyze amounts in your general ledger by their dimensions using analysis views that you have set up.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 556 }
      { 93      ;2   ;Action    ;
                      CaptionML=[DAN=Kontoskemaer;
                                 ENU=Account Schedules];
                      ToolTipML=[DAN=FÜ indsigt i de finansielle data i din kontoplan. Kontoskemaer analyserer tal i finanskonti og sammenligner finansposter med finansbudgetposter. Eksempelvis kan du fÜ vist finansposterne som en procentsats af budgetposterne. Kontoskemaer indeholder data om de vigtigste Ürsregnskaber og visninger, f.eks. pengestrõmsdiagrammet.;
                                 ENU=Get insight into the financial data stored in your chart of accounts. Account schedules analyze figures in G/L accounts, and compare general ledger entries with general ledger budget entries. For example, you can view the general ledger entries as percentages of the budget entries. Account schedules provide the data for core financial statements and views, such as the Cash Flow chart.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 103 }
      { 116     ;2   ;Action    ;
                      CaptionML=[DAN=Finanskontokategorier;
                                 ENU=G/L Account Categories];
                      ToolTipML=[DAN=Tilpas strukturen for dit Ürsregnskab ved at knytte finanskontiene til kontokategorier. Du kan oprette kategorigrupper ved at placere underkategorier under dem. Hver gruppe viser en totalsaldo. NÜr du vëlger handlingen GenerÇr kontoskemaer, opdateres kontoskemaerne for de underliggende finansrapporter. Nëste gang du kõrer en af disse rapporter som f.eks. resultatopgõrelsen, tilfõjes der ny totaler og underposter ud fra dine ëndringer.;
                                 ENU=Personalize the structure of your financial statements by mapping general ledger accounts to account categories. You can create category groups by indenting subcategories under them. Each grouping shows a total balance. When you choose the Generate Account Schedules action, the account schedules for the underlying financial reports are updated. The next time you run one of these reports, such as the balance statement, new totals and subentries are added, based on your changes.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 790 }
      { 44      ;2   ;Action    ;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omrÜde, projekt eller afdeling, som du kan tildele til salgs- og kõbsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      RunObject=Page 536;
                      Image=Dimensions }
      { 45      ;2   ;Action    ;
                      CaptionML=[DAN=Bankkontobogfõringsgrupper;
                                 ENU=Bank Account Posting Groups];
                      ToolTipML=[DAN=Opret bogfõringsgrupper, sÜ betalinger til og fra de enkelte bankkonti bogfõres pÜ den angivne finanskonto.;
                                 ENU=Set up posting groups, so that payments in and out of each bank account are posted to the specified general ledger account.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 373 }
      { 131     ;1   ;ActionGroup;
                      CaptionML=[DAN=Selvbetjening;
                                 ENU=Self-Service];
                      ToolTipML=[DAN=Administrer dine timesedler og opgaver.;
                                 ENU=Manage your time sheets and assignments.];
                      Image=HumanResources }
      { 130     ;2   ;Action    ;
                      CaptionML=[DAN=Timesedler;
                                 ENU=Time Sheets];
                      ToolTipML=[DAN=Giv ressourcer mulighed for at tidsregistere. Efter godkendelsen, hvis en sÜdan krëves, kan timeseddelposterne bogfõres for den relevante sagskladde eller ressourcekladde som en del af registreringen af projektforlõbet. Hvis du vil spare konfigurationstid og sikre, at dataene er korrekte, kan du kopiere sagsplanlëgningslinjerne til timesedlerne.;
                                 ENU=Enable resources to register time. When approved, if approval is required, time sheet entries can be posted to the relevant job journal or resource journal as part of project progress reporting. To save setup time and to ensure data correctness, you can copy job planning lines into time sheets.];
                      ApplicationArea=#Suite;
                      RunObject=Page 951 }
      { 140     ;1   ;ActionGroup;
                      Name=SetupAndExtensions;
                      CaptionML=[DAN=Installation og udvidelser;
                                 ENU=Setup & Extensions];
                      ToolTipML=[DAN=Oversigt og ëndringssystem og programindstillinger samt administration af udvidelser og tjenester;
                                 ENU=Overview and change system and application settings, and manage extensions and services];
                      Image=Setup }
      { 141     ;2   ;Action    ;
                      CaptionML=[DAN=Assisteret opsëtning;
                                 ENU=Assisted Setup];
                      ToolTipML=[DAN=Konfigurer kernefunktioner sÜsom moms, og send dokumenter som mails og godkendelsesworkflow ved at kõre igennem et par sider, der vejleder dig i oplysningerne.;
                                 ENU=Set up core functionality such as sales tax, sending documents as email, and approval workflow by running through a few pages that guide you through the information.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 1801;
                      Image=QuestionaireSetup }
      { 138     ;2   ;Action    ;
                      Name=Manual Setup;
                      CaptionML=[DAN=Manuel opsëtning;
                                 ENU=Manual Setup];
                      ToolTipML=[DAN=Definer dine virksomhedspolitikker for afdelinger og generelle aktiviteter.;
                                 ENU=Define your company policies for business departments and for general activities.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 1875 }
      { 139     ;2   ;Action    ;
                      Name=General;
                      CaptionML=[DAN=Generelt;
                                 ENU=General];
                      ToolTipML=[DAN=Generelt;
                                 ENU=General];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 1875;
                      RunPageView=SORTING(Name)
                                  WHERE(Area=FILTER(General)) }
      { 136     ;2   ;Action    ;
                      Name=Finance;
                      CaptionML=[DAN=Finans;
                                 ENU=Finance];
                      ToolTipML=;
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 1875;
                      RunPageView=SORTING(Name)
                                  WHERE(Area=FILTER(Finance)) }
      { 137     ;2   ;Action    ;
                      Name=Sales;
                      CaptionML=[DAN=Salg;
                                 ENU=Sales];
                      ToolTipML=[DAN=Definer dine generelle politikker for salgsfakturering og returneringer, f.eks. hvornÜr advarsler om kredit og lagerbeholdning skal vises, og hvordan salgsrabatter skal bogfõres. Konfigurer dine nummerserier for oprettelse af debitorer og forskellige salgsbilag.;
                                 ENU=Define your general policies for sales invoicing and returns, such as when to show credit and stockout warnings and how to post sales discounts. Set up your number series for creating customers and different sales documents.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 1875;
                      RunPageView=SORTING(Name)
                                  WHERE(Area=FILTER(Sales)) }
      { 134     ;2   ;Action    ;
                      Name=Purchasing;
                      CaptionML=[DAN=Indkõb;
                                 ENU=Purchasing];
                      ToolTipML=[DAN=Definer dine generelle politikker for fakturering af kõb og for returneringer, f.eks. om kreditorfakturanumre skal angives, og hvordan kõbsrabatter skal bogfõres. Konfigurer dine nummerserier for oprettelse af kreditorer og forskellige kõbsbilag.;
                                 ENU=Define your general policies for purchase invoicing and returns, such as whether to require vendor invoice numbers and how to post purchase discounts. Set up your number series for creating vendors and different purchase documents.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 1875;
                      RunPageView=SORTING(Name)
                                  WHERE(Area=FILTER(Purchasing)) }
      { 135     ;2   ;Action    ;
                      Name=Jobs;
                      CaptionML=[DAN=Sager;
                                 ENU=Jobs];
                      ToolTipML=[DAN=Definer en projektaktivitet ved at oprette et sagskort med integrerede sagsopgaver og sagsplanlëgningslinjer, opdelt i to lag. Sagsopgaven giver dig mulighed for at konfigurere sagsplanlëgningslinjer og bogfõre forbrug for sagen. Sagsplanlëgningslinjer angiver brugen af ressourcer, varer og forskellige finansudgifter i detaljer.;
                                 ENU=Define a project activity by creating a job card with integrated job tasks and job planning lines, structured in two layers. The job task enables you to set up job planning lines and to post consumption to the job. The job planning lines specify the detailed use of resources, items, and various general ledger expenses.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 1875;
                      RunPageView=SORTING(Name)
                                  WHERE(Area=FILTER(Jobs)) }
      { 132     ;2   ;Action    ;
                      Name=Fixed Assets;
                      CaptionML=[DAN=Anlëgsaktiver;
                                 ENU=Fixed Assets];
                      ToolTipML=[DAN=AdministrÇr periodisk afskrivning af dine maskiner, hold styr pÜ reparationsomkostningerne, administrÇr forsikringspolicer vedrõrende faste anlëgsaktiver, og overvÜg statistik for faste anlëgsaktiver.;
                                 ENU=Manage periodic depreciation of your machinery or machines, keep track of your maintenance costs, manage insurance policies related to fixed assets, and monitor fixed asset statistics.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 1875;
                      RunPageView=SORTING(Name)
                                  WHERE(Area=FILTER(Fixed Assets)) }
      { 133     ;2   ;Action    ;
                      Name=HR;
                      CaptionML=[DAN=Personale;
                                 ENU=HR];
                      ToolTipML=[DAN=Administrer medarbejdere.;
                                 ENU=Manage employees.];
                      ApplicationArea=#BasicHR;
                      RunObject=Page 1875;
                      RunPageView=SORTING(Name)
                                  WHERE(Area=FILTER(HR)) }
      { 128     ;2   ;Action    ;
                      Name=Inventory;
                      CaptionML=[DAN=Lager;
                                 ENU=Inventory];
                      ToolTipML=[DAN=Lager;
                                 ENU=Inventory];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 1875;
                      RunPageView=SORTING(Name)
                                  WHERE(Area=FILTER(Inventory)) }
      { 129     ;2   ;Action    ;
                      Name=Service;
                      CaptionML=[DAN=Tjeneste;
                                 ENU=Service];
                      ToolTipML=;
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 1875;
                      RunPageView=SORTING(Name)
                                  WHERE(Area=FILTER(Service)) }
      { 126     ;2   ;Action    ;
                      Name=System;
                      CaptionML=[DAN=System;
                                 ENU=System];
                      ToolTipML=[DAN=System;
                                 ENU=System];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 1875;
                      RunPageView=SORTING(Name)
                                  WHERE(Area=FILTER(System)) }
      { 127     ;2   ;Action    ;
                      Name=Relationship Management;
                      CaptionML=[DAN=Relationsstyring;
                                 ENU=Relationship Management];
                      ToolTipML=[DAN=Opret forretningsrelationer, konfigurer salgsprocesser, kampagner og interaktioner, og definer koder for forskellig marketingkommunikation.;
                                 ENU=Set up business relations, configure sales cycles, campaigns, and interactions, and define codes for various marketing communication.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 1875;
                      RunPageView=SORTING(Name)
                                  WHERE(Area=FILTER(Relationship Mngt)) }
      { 10      ;2   ;Action    ;
                      Name=Intercompany;
                      CaptionML=[DAN=Koncernintern;
                                 ENU=Intercompany];
                      ToolTipML=[DAN=Koncerninterne bogfõringer;
                                 ENU=Intercompany Postings];
                      ApplicationArea=#Intercompany;
                      RunObject=Page 1875;
                      RunPageView=SORTING(Name)
                                  WHERE(Area=FILTER(Intercompany)) }
      { 124     ;2   ;Action    ;
                      CaptionML=[DAN=Serviceforbindelser;
                                 ENU=Service Connections];
                      ToolTipML=[DAN=AktivÇr og konfigurer eksterne tjenester, f.eks. opdateringer af valutakurser, Microsoft Social Engagement og elektronisk bankintegration.;
                                 ENU=Enable and configure external services, such as exchange rate updates, Microsoft Social Engagement, and electronic bank integration.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 1279;
                      Image=ServiceTasks }
      { 125     ;2   ;Action    ;
                      CaptionML=[DAN=Udvidelser;
                                 ENU=Extensions];
                      ToolTipML=[DAN=InstallÇr udvidelser for at optimere systemets funktionalitet.;
                                 ENU=Install Extensions for greater functionality of the system.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 2500;
                      Image=NonStockItemSetup }
      { 105     ;0   ;ActionContainer;
                      ActionContainerType=NewDocumentItems }
      { 66      ;1   ;Action    ;
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
      { 65      ;1   ;Action    ;
                      CaptionML=[DAN=&Kõbskreditnota;
                                 ENU=P&urchase Credit Memo];
                      ToolTipML=[DAN=Opret en ny kõbskreditnota, sÜ du kan administrere varer, der er returneret til en kreditor.;
                                 ENU=Create a new purchase credit memo so you can manage returned items to a vendor.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 52;
                      Promoted=No;
                      Image=CreditMemo;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 64      ;1   ;ActionGroup;
                      CaptionML=[DAN=Betalinger;
                                 ENU=Payments] }
      { 94      ;2   ;Action    ;
                      CaptionML=[DAN=Indbetaling&skladde;
                                 ENU=Cas&h Receipt Journal];
                      ToolTipML=[DAN=Udlign modtagne betalinger med de relaterede ikke-bogfõrte salgsbilag.;
                                 ENU=Apply received payments to the related non-posted sales documents.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 255;
                      Image=CashReceiptJournal }
      { 95      ;2   ;Action    ;
                      CaptionML=[DAN=&Udbetalingskladde;
                                 ENU=Pa&yment Journal];
                      ToolTipML=[DAN=Foretag betalinger til kreditorer.;
                                 ENU=Make payments to vendors.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 256;
                      Image=PaymentJournal }
      { 67      ;1   ;ActionGroup;
                      CaptionML=[DAN=Analyse;
                                 ENU=Analysis] }
      { 110     ;2   ;Action    ;
                      CaptionML=[DAN=Analy&sevisninger;
                                 ENU=Analysis &Views];
                      ToolTipML=[DAN=AnalysÇr belõb pÜ din finanskonto efter deres dimensioner vha. analysevisninger, som du har konfigureret.;
                                 ENU=Analyze amounts in your general ledger by their dimensions using analysis views that you have set up.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 556;
                      Image=AnalysisView }
      { 98      ;2   ;Action    ;
                      CaptionML=[DAN="&Dimensionsanalyse ";
                                 ENU=Analysis by &Dimensions];
                      ToolTipML=[DAN=Analyser aktiviteter pÜ grundlag af dimensionsoplysninger.;
                                 ENU=Analyze activities using dimensions information.];
                      ApplicationArea=#Dimensions;
                      RunObject=Page 554;
                      Image=AnalysisViewDimension }
      { 73      ;1   ;ActionGroup;
                      CaptionML=[DAN=Opgaver;
                                 ENU=Tasks] }
      { 68      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Beregn afskr&ivninger;
                                 ENU=Calculate Deprec&iation];
                      ToolTipML=[DAN=Beregn afskrivningerne i overensstemmelse med de betingelser, du angiver. Hvis de faste anlëgsaktiver i kõrslen er integreret med finans (defineret i den afskrivningsprofil, der bruges i kõrslen), overfõres posterne til finanskladden for faste anlëgsaktiver. Ellers overfõres posterne til kladden for faste anlëgsaktiver. Du kan postere kladden eller eventuelt justere posteringerne inden bogfõringen.;
                                 ENU=Calculate depreciation according to the conditions that you define. If the fixed assets that are included in the batch job are integrated with the general ledger (defined in the depreciation book that is used in the batch job), the resulting entries are transferred to the fixed assets general ledger journal. Otherwise, the batch job transfers the entries to the fixed asset journal. You can then post the journal or adjust the entries before posting, if necessary.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Report 5692;
                      Image=CalculateDepreciation }
      { 69      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Indl&ës konsolidering fra database;
                                 ENU=Import Co&nsolidation from Database];
                      ToolTipML=[DAN=ImportÇr poster fra de koncernvirksomheder, der skal indgÜ i en konsolidering. Du kan anvende kõrslen, hvis koncernvirksomheden stammer fra den samme database i Dynamics NAV som det konsoliderede regnskab.;
                                 ENU=Import entries from the business units that will be included in a consolidation. You can use the batch job if the business unit comes from the same database in Dynamics NAV as the consolidated company.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 90;
                      Image=ImportDatabase }
      { 70      ;2   ;Action    ;
                      CaptionML=[DAN=Bankkontoafst&emning;
                                 ENU=Bank Account R&econciliation];
                      ToolTipML=[DAN=Se posterne og saldoen pÜ dine bankkonti i forhold til et kontoudtog fra banken.;
                                 ENU=View the entries and the balance on your bank accounts against a statement from the bank.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 379;
                      Image=BankAccountRec }
      { 109     ;2   ;Action    ;
                      CaptionML=[DAN=Betalingsudligningskladder;
                                 ENU=Payment Reconciliation Journals];
                      ToolTipML=[DAN=Afstem ubetalte bilag automatisk med deres relaterede banktransaktioner ved at importere et bankkontoudtog eller en fil. I betalingsudligningskladden udlignes indgÜende eller udgÜende betalinger for din bank automatisk eller delvist automatisk med deres relaterede Übne debitor- eller kreditorposter. Alle Übne bankkontoposter i forhold til de udlignede debitor- eller kreditorposter bliver lukket, nÜr du vëlger handlingen Bogfõr betalinger og Afstem bankkontoen. Det betyder, at bankkontoen automatisk afstemmes for de betalinger, som du bogfõrer med kladden.;
                                 ENU=Reconcile unpaid documents automatically with their related bank transactions by importing a bank statement feed or file. In the payment reconciliation journal, incoming or outgoing payments on your bank are automatically, or semi-automatically, applied to their related open customer or vendor ledger entries. Any open bank account ledger entries related to the applied customer or vendor ledger entries will be closed when you choose the Post Payments and Reconcile Bank Account action. This means that the bank account is automatically reconciled for payments that you post with the journal.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 1294;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ApplyEntries;
                      RunPageMode=View }
      { 71      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kursreguler valu&tabeholdninger;
                                 ENU=Adjust E&xchange Rates];
                      ToolTipML=[DAN=Reguler finans-, debitor-, kreditor- og bankkontoposter, sÜ de svarer til den opdaterede saldo i situationer, hvor kursen har ëndret sig siden bogfõringen.;
                                 ENU=Adjust general ledger, customer, vendor, and bank account entries to reflect a more updated balance if the exchange rate has changed since the entries were posted.];
                      ApplicationArea=#Suite;
                      RunObject=Report 595;
                      Image=AdjustExchangeRates }
      { 72      ;2   ;Action    ;
                      CaptionML=[DAN=Bogf&õr lagerregulering;
                                 ENU=P&ost Inventory Cost to G/L];
                      ToolTipML=[DAN=Registrer ëndringen i antal og vërdi for lageret i vareposterne og vërdiposterne, nÜr du bogfõrer lagertransaktioner som f.eks. salgsleverancer eller kõbsfakturaer.;
                                 ENU=Record the quantity and value changes to the inventory in the item ledger entries and the value entries when you post inventory transactions, such as sales shipments or purchase receipts.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 1002;
                      Image=PostInventoryToGL }
      { 82      ;2   ;Action    ;
                      CaptionML=[DAN=Intrastat&kladde;
                                 ENU=Intrastat &Journal];
                      ToolTipML=[DAN=Sammenfat vërdien af dine kõb og salg i relation til forretningspartnere i EU med statistik for õje, og klargõr tallene til afsendelse til den relevante myndighed.;
                                 ENU=Summarize the value of your purchases and sales with business partners in the EU for statistical purposes and prepare to send it to the relevant authority.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 327;
                      Image=Journal }
      { 81      ;2   ;Action    ;
                      CaptionML=[DAN=Afregn &moms;
                                 ENU=Calc. and Pos&t VAT Settlement];
                      ToolTipML=[DAN=Luk Übne momsposter og overfõrer kõbs- og salgsmomsbelõb til momsafregningskontoen. For hver momsbogfõringsgruppe finder kõrslen alle momsposter i den momsposttabel, der er inkluderet i filtrene i definitionsvinduet.;
                                 ENU=Close open VAT entries and transfers purchase and sales VAT amounts to the VAT settlement account. For every VAT posting group, the batch job finds all the VAT entries in the VAT Entry table that are included in the filters in the definition window.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 20;
                      Image=SettleOpenTransactions }
      { 97      ;1   ;ActionGroup;
                      CaptionML=[DAN=Opret;
                                 ENU=Create] }
      { 78      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Op&ret rykkere;
                                 ENU=C&reate Reminders];
                      ToolTipML=[DAN=Opret rykkere for en eller flere debitorer med forfaldne betalinger.;
                                 ENU=Create reminders for one or more customers with overdue payments.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 188;
                      Image=CreateReminders }
      { 79      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=O&pret rentenotaer;
                                 ENU=Create Finance Charge &Memos];
                      ToolTipML=[DAN=Opret rentenotaer for en eller flere debitorer med forfaldne betalinger.;
                                 ENU=Create finance charge memos for one or more customers with overdue payments.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 191;
                      Image=CreateFinanceChargememo }
      { 150     ;1   ;ActionGroup;
                      CaptionML=[DAN=Rapporter;
                                 ENU=Reports] }
      { 151     ;2   ;ActionGroup;
                      CaptionML=[DAN=Regnskabsopgõrelser;
                                 ENU=Financial Statements];
                      Image=ReferenceData }
      { 148     ;3   ;Action    ;
                      CaptionML=[DAN=Balance;
                                 ENU=Balance Sheet];
                      ToolTipML=[DAN=Vis en rapport, der viser din virksomheds aktiver, passiver og egenkapital.;
                                 ENU=View a report that shows your company's assets, liabilities, and equity.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 572;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 149     ;3   ;Action    ;
                      CaptionML=[DAN=Resultatopgõrelse;
                                 ENU=Income Statement];
                      ToolTipML=[DAN=Vis en rapport, der viser din virksomheds indtëgter og udgifter.;
                                 ENU=View a report that shows your company's income and expenses.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 573;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 146     ;3   ;Action    ;
                      CaptionML=[DAN=Opgõrelser over pengestrõm;
                                 ENU=Statement of Cash Flows];
                      ToolTipML=[DAN=Vis en regnskabsopgõrelse, der viser, hvordan ëndringer i balancekonti og indtëgter pÜvirker virksomhedens kontantbeholdning, som vises for henholdsvis drifts-, investerings- og finansieringsaktiviteter.;
                                 ENU=View a financial statement that shows how changes in balance sheet accounts and income affect the company's cash holdings, displayed for operating, investing, and financing activities respectively.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 574;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 147     ;3   ;Action    ;
                      CaptionML=[DAN=Opgõrelse af overfõrt resultat;
                                 ENU=Statement of Retained Earnings];
                      ToolTipML=[DAN=Vis en rapport, der viser din virksomheds ëndringer i overfõrte resultater for en bestemt periode ved at afstemme de overfõrte resultater i begyndelsen og slutningen af perioden ved hjëlp af oplysninger sÜsom Ürets resultat fra andre Ürsregnskaber.;
                                 ENU=View a report that shows your company's changes in retained earnings for a specified period by reconciling the beginning and ending retained earnings for the period, using information such as net income from the other financial statements.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 575;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 156     ;2   ;ActionGroup;
                      CaptionML=[DAN=Excel-rapporter;
                                 ENU=Excel Reports];
                      Image=Excel }
      { 155     ;3   ;Action    ;
                      Name=ExcelTemplatesBalanceSheet;
                      CaptionML=[DAN=Balance;
                                 ENU=Balance Sheet];
                      ToolTipML=[DAN=èbn et regneark, der viser aktiver, passiver og egenkapital.;
                                 ENU=Open a spreadsheet that shows assets, liabilities, and equity.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 576;
                      Image=Report }
      { 154     ;3   ;Action    ;
                      Name=ExcelTemplateIncomeStmt;
                      CaptionML=[DAN=Resultatopgõrelse;
                                 ENU=Income Statement];
                      ToolTipML=[DAN=èbn et regneark, der viser virksomhedens indtëgter og udgifter.;
                                 ENU=Open a spreadsheet that shows the company income and expenses.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 577;
                      Image=Report }
      { 157     ;3   ;Action    ;
                      Name=ExcelTemplateCashFlowStmt;
                      CaptionML=[DAN=Pengestrõmsopgõrelse;
                                 ENU=Cash Flow Statement];
                      ToolTipML=[DAN=èbn et regneark, der viser, hvordan ëndringer i balancekonti og indtëgter pÜvirker virksomhedens kontantbeholdning.;
                                 ENU=Open a spreadsheet that shows how changes in balance sheet accounts and income affect the company's cash holdings.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 578;
                      Image=Report }
      { 158     ;3   ;Action    ;
                      Name=ExcelTemplateRetainedEarn;
                      CaptionML=[DAN=Opgõrelse over overfõrt resultat;
                                 ENU=Retained Earnings Statement];
                      ToolTipML=[DAN=èbn et regneark, der viser ëndringer i overfõrte resultater, der er baseret pÜ Ürets resultat fra andre Ürsregnskaber.;
                                 ENU=Open a spreadsheet that shows changes in retained earnings based on net income from the other financial statements.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 579;
                      Image=Report }
      { 159     ;3   ;Action    ;
                      Name=ExcelTemplateTrialBalance;
                      CaptionML=[DAN=RÜbalance;
                                 ENU=Trial Balance];
                      ToolTipML=[DAN=èbn et regneark, der viser en oversigt over rÜbalance efter konto.;
                                 ENU=Open a spreadsheet that shows a summary trial balance by account.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 580;
                      Image=Report }
      { 160     ;3   ;Action    ;
                      Name=ExcelTemplateAgedAccPay;
                      CaptionML=[DAN=Aldersfordelt gëld;
                                 ENU=Aged Accounts Payable];
                      ToolTipML=[DAN=èbn et regneark, der viser en oversigt over aldersfordelte restsaldi for hver kreditor efter periode.;
                                 ENU=Open a spreadsheet that shows a list of aged remaining balances for each vendor by period.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 581;
                      Image=Report }
      { 161     ;3   ;Action    ;
                      Name=ExcelTemplateAgedAccRec;
                      CaptionML=[DAN=Aldersfordelte tilgodehavender;
                                 ENU=Aged Accounts Receivable];
                      ToolTipML=[DAN=Vis en oversigt over, hvornÜr debitorers betalinger skal betales eller rykkes for, opdelt i fire perioder. Du skal angive den dato, som aldersfordelingen skal beregnes ud fra, og du skal angive den periode, som hver kolonne skal indeholde data for.;
                                 ENU=View an overview of when customer payments are due or overdue, divided into four periods. You must specify the date you want aging calculated from and the length of the period that each column will contain data for.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 582;
                      Image=Report }
      { 152     ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kõr konsolidering;
                                 ENU=Run Consolidation];
                      ToolTipML=[DAN=Kõr konsolideringsrapporten.;
                                 ENU=Run the Consolidation report.];
                      ApplicationArea=#Suite;
                      RunObject=Report 90;
                      Image=ImportDatabase }
      { 80      ;1   ;ActionGroup;
                      CaptionML=[DAN=Opsëtning;
                                 ENU=Setup] }
      { 112     ;2   ;Action    ;
                      CaptionML=[DAN=Assisteret opsëtning;
                                 ENU=Assisted Setup];
                      ToolTipML=[DAN=Konfigurer kernefunktioner sÜsom moms, og send dokumenter som mails og godkendelsesworkflow ved at kõre igennem et par sider, der vejleder dig i oplysningerne.;
                                 ENU=Set up core functionality such as sales tax, sending documents as email, and approval workflow by running through a few pages that guide you through the information.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 1801;
                      Image=QuestionaireSetup }
      { 85      ;2   ;Action    ;
                      CaptionML=[DAN=Opsëtning &af Finans;
                                 ENU=General &Ledger Setup];
                      ToolTipML=[DAN=Bogfõr õkonomiske transaktioner direkte til finanskonti og andre konti som f.eks. bank-, debitor-, kreditor- og medarbejderkonti. Bogfõring med en finanskladde opretter altid poster pÜ finanskontiene. Dette gëlder ogsÜ, nÜr du eksempelvis bogfõrer en kladdelinje til en debitorkonto, fordi der er bogfõrt en post til finansregnskabets konto for tilgodehavender via en bogfõringsgruppe.;
                                 ENU=Post financial transactions directly to general ledger accounts and other accounts, such as bank, customer, vendor, and employee accounts. Posting with a general journal always creates entries on general ledger accounts. This is true even when, for example, you post a journal line to a customer account, because an entry is posted to a general ledger receivables account through a posting group.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 118;
                      Image=Setup }
      { 86      ;2   ;Action    ;
                      CaptionML=[DAN=&Salgsopsëtning;
                                 ENU=&Sales && Receivables Setup];
                      ToolTipML=[DAN=Definer dine generelle politikker for fakturering af salg og for returneringer, som f.eks. hvornÜr krediterings- og beholdningsadvarsler skal vises, og hvordan salgsrabatter skal bogfõres. Konfigurer dine nummerserier for oprettelse af debitorer og forskellige salgsdokumenter.;
                                 ENU=Define your general policies for sales invoicing and returns, such as when to show credit and stockout warnings and how to post sales discounts. Set up your number series for creating customers and different sales documents.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 459;
                      Image=Setup }
      { 87      ;2   ;Action    ;
                      CaptionML=[DAN=Kõbsop&sëtning;
                                 ENU=&Purchases && Payables Setup];
                      ToolTipML=[DAN=Definer dine generelle politikker for fakturering af kõb og for returneringer, som f.eks. om kreditorfakturanumre skal angives, og hvordan kõbsrabatter skal bogfõres. Konfigurer dine nummerserier for oprettelse af kreditorer og forskellige kõbsdokumenter.;
                                 ENU=Define your general policies for purchase invoicing and returns, such as whether to require vendor invoice numbers and how to post purchase discounts. Set up your number series for creating vendors and different purchase documents.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 460;
                      Image=Setup }
      { 88      ;2   ;Action    ;
                      CaptionML=[DAN=&Anlëgsopsëtning;
                                 ENU=&Fixed Asset Setup];
                      ToolTipML=[DAN=Definer regnskabspolitikkerne for anlëgsaktiver, som f.eks. den tilladte bogfõringsperiode, og om bogfõring pÜ hovedanlëg er tilladt. Konfigurer nummerserien for oprettelse af nye anlëgsaktiver.;
                                 ENU=Define your accounting policies for fixed assets, such as the allowed posting period and whether to allow posting to main assets. Set up your number series for creating new fixed assets.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5607;
                      Image=Setup }
      { 101     ;2   ;Action    ;
                      CaptionML=[DAN=Pengestrõmskonfiguration;
                                 ENU=Cash Flow Setup];
                      ToolTipML=[DAN=Konfigurer de konti, hvor pengestrõmstal for salgs-, kõbs- og anlëgsposter gemmes.;
                                 ENU=Set up the accounts where cash flow figures for sales, purchase, and fixed-asset transactions are stored.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 846;
                      Image=CashFlowSetup }
      { 96      ;2   ;Action    ;
                      CaptionML=[DAN=Konfiguration af omkostningsregnskab;
                                 ENU=Cost Accounting Setup];
                      ToolTipML=[DAN=Angiv, hvordan du overfõrer finansposter til omkostningsregnskabet, hvordan du sammenkëder dimensioner med omkostningssteder og omkostningsemner, og hvordan du hÜndterer fordelings-id og fordelingsbilagsnummer.;
                                 ENU=Specify how you transfer general ledger entries to cost accounting, how you link dimensions to cost centers and cost objects, and how you handle the allocation ID and allocation document number.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Page 1113;
                      Image=CostAccountingSetup }
      { 89      ;1   ;ActionGroup;
                      CaptionML=[DAN=Oversigt;
                                 ENU=History] }
      { 90      ;2   ;Action    ;
                      CaptionML=[DAN=Nav&iger;
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

    { 99  ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page762;
                Visible=FALSE;
                PartType=Page }

    { 1902304208;2;Part   ;
                ApplicationArea=#Basic,#Suite;
                PagePartID=Page9037;
                PartType=Page }

    { 123 ;2   ;Part      ;
                ApplicationArea=#Suite;
                PagePartID=Page9042;
                PartType=Page }

    { 1907692008;2;Part   ;
                ApplicationArea=#Basic,#Suite;
                PagePartID=Page9153;
                PartType=Page }

    { 122 ;2   ;Part      ;
                ApplicationArea=#Basic,#Suite;
                PagePartID=Page6303;
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
                Visible=FALSE;
                PartType=Page }

    { 9   ;2   ;Part      ;
                AccessByPermission=TableData 1803=R;
                ToolTipML=[DAN=Angiver visningen af din virksomhedshjëlp;
                           ENU=Specifies the view of your business assistance];
                ApplicationArea=#Basic,#Suite;
                PagePartID=Page1392;
                PartType=Page }

    { 100 ;2   ;Part      ;
                ApplicationArea=#Basic,#Suite;
                PagePartID=Page869;
                PartType=Page }

    { 108 ;2   ;Part      ;
                ApplicationArea=#Basic,#Suite;
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

