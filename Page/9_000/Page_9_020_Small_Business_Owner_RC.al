OBJECT Page 9020 Small Business Owner RC
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232,NAVDK11.00.00.24232;
  }
  PROPERTIES
  {
    CaptionML=[@@@="{Dependency=Match,""ProfileDescription_PRESIDENT-SMALLBUSINESS""}";
               DAN=Adm. dir. - mindre virksomhed;
               ENU=President - Small Business];
    PageType=RoleCenter;
    ActionList=ACTIONS
    {
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 60      ;1   ;Action    ;
                      CaptionML=[DAN=Kon&toudtog;
                                 ENU=S&tatement];
                      ToolTipML=[DAN=Vis alle poster i den valgte periode for de valgte debitorer. Du kan vëlge at fÜ vist samtlige forfaldne saldi, uafhëngigt af den angivne periode. Du kan ogsÜ vëlge at medtage et aldersfordelingsinterval. Rapporten viser Übne poster og, hvis det er angivet i rapporten, forfaldne poster for hver valuta. Rapporten kan f.eks. sendes ud til debitorer i forbindelse med afslutningen pÜ en regnskabsperiode eller som en pÜmindelse om manglende betaling.;
                                 ENU=View all entries for selected customers for a selected period. You can choose to have all overdue balances displayed, regardless of the period specified. You can also choose to include an aging band. For each currency, the report displays open entries and, if specified in the report, overdue entries. The statement can be sent to customers, for example, at the close of an accounting period or as a reminder of overdue balances.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 116;
                      Image=Report }
      { 61      ;1   ;Separator  }
      { 62      ;1   ;Action    ;
                      CaptionML=[DAN=De&bitor - ordreoversigt;
                                 ENU=Customer - Order Su&mmary];
                      ToolTipML=[DAN=Vis ordrebeholdningen (den ikke-leverede beholdning) pr. debitor i tre perioder Ö 30 dage med udgangspunkt i en valgt dato. Der vises desuden kolonner med ordrer, der skal leveres fõr og efter de tre perioder, og en kolonne med ordrebeholdningen pr. debitor i alt. Rapporten kan f.eks. bruges til at analysere virksomhedens forventede salgsomsëtning.;
                                 ENU=View the order detail (the quantity not yet shipped) for each customer in three periods of 30 days each, starting from a selected date. There are also columns with orders to be shipped before and after the three periods and a column with the total order detail for each customer. The report can be used to analyze a company's expected sales volume.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 107;
                      Image=Report }
      { 63      ;1   ;Action    ;
                      CaptionML=[DAN=Debitor - top &10-liste;
                                 ENU=Customer - T&op 10 List];
                      ToolTipML=[DAN=Vis de debitorer, der kõber mest, eller som skylder mest, i en bestemt periode. Kun de debitorer, der har kõb i lõbet af perioden eller en saldo ved periodens afslutning, vil blive vist i rapporten.;
                                 ENU=View which customers purchase the most or owe the most in a selected period. Only customers that have either purchases during the period or a balance at the end of the period will be included.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 111;
                      Image=Report }
      { 74      ;1   ;Action    ;
                      CaptionML=[DAN=Kunde/va&restatistik;
                                 ENU=Customer/&Item Sales];
                      ToolTipML=[DAN=Vis en oversigt over varesalg i den valgte periode for hver debitor. Rapporten viser oplysninger om antal, salgsbelõb, avance og eventuel rabat. Du kan f.eks. bruge rapporten til at analysere en virksomheds debitorgrupper.;
                                 ENU=View a list of item sales for each customer during a selected time period. The report contains information on quantity, sales amount, profit, and possible discounts. It can be used, for example, to analyze a company's customer groups.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 113;
                      Image=Report }
      { 75      ;1   ;Separator  }
      { 76      ;1   ;Action    ;
                      CaptionML=[DAN=S&ëlger - salgsstatistik;
                                 ENU=Salesperson - Sales &Statistics];
                      ToolTipML=[DAN=Vis belõb for salg, avancebelõb, fakturarabat og kontantrabat samt avanceprocent for hver sëlger i den valgte periode. Desuden viser rapporten reguleret avance og reguleret avanceprocent, som afspejler evt. ëndringer i den oprindelige belõb for de varer, der indgÜr i salget.;
                                 ENU=View amounts for sales, profit, invoice discount, and payment discount, as well as profit percentage, for each salesperson for a selected period. The report also shows the adjusted profit and adjusted profit percentage, which reflect any changes to the original costs of the items in the sales.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 114;
                      Image=Report }
      { 77      ;1   ;Action    ;
                      CaptionML=[DAN=Pris&liste;
                                 ENU=Price &List];
                      ToolTipML=[DAN=Vis en liste over dine varer samt oplysninger om priser og omkostninger pÜ disse med henblik pÜ at sende den til debitorerne. Du kan oprette listen til specifikke debitorer, kampagner, valutaer eller til andre formÜl.;
                                 ENU=View a list of your items and their prices, for example, to send to customers. You can create the list for specific customers, campaigns, currencies, or other criteria.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 715;
                      Image=Report }
      { 93      ;1   ;Separator  }
      { 130     ;1   ;Action    ;
                      CaptionML=[DAN=Vare - rest&ordrer til kunder;
                                 ENU=Inventory - Sales &Back Orders];
                      ToolTipML=[DAN=Vis en oversigt med de ordrelinjer, hvor afsendelsesdatoen er overskredet. Der vises fõlgende oplysninger for de enkelte ordrer pÜ hver vare: nummer, debitornavn, debitorens telefonnummer, afsendelsesdato, ordrestõrrelse og antal i restordre. Rapporten viser ogsÜ, om debitoren har andre varer i restordre.;
                                 ENU=View a list with the order lines whose shipment date has been exceeded. The following information is shown for the individual orders for each item: number, customer name, customer's telephone number, shipment date, order quantity and quantity on back order. The report also shows whether there are other items for the customer on back order.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 718;
                      Image=Report }
      { 129     ;1   ;Separator  }
      { 32      ;1   ;Action    ;
                      CaptionML=[DAN=Finans - balan&ce;
                                 ENU=&G/L Trial Balance];
                      ToolTipML=[DAN=Vis, udskriv, eller send en rapport, der viser saldo for finanskontiene, herunder debet og kredit. Du kan bruge denne rapport til at sikre nõjagtig regnskabspraksis.;
                                 ENU=View, print, or send a report that shows the balances for the general ledger accounts, including the debits and credits. You can use this report to ensure accurate accounting practices.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 6;
                      Image=Report }
      { 37      ;1   ;Action    ;
                      CaptionML=[DAN=RÜbalance efter &periode;
                                 ENU=Trial Balance by &Period];
                      ToolTipML=[DAN=Viser primosaldoen efter finanskonto, bevëgelserne i den valgte periode for mÜned, kvartal eller Ür, og den resulterende ultimosaldo.;
                                 ENU=Show the opening balance by general ledger account, the movements in the selected period of month, quarter, or year, and the resulting closing balance.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 38;
                      Image=Report }
      { 48      ;1   ;Action    ;
                      CaptionML=[DAN=&èrsregnskab;
                                 ENU=Closing T&rial Balance];
                      ToolTipML=[DAN=Vis dette og sidste Ürs tal som en almindelig rÜbalance. For konti i resultatopgõrelsen vises saldi uden ultimoposter. Ultimoposter anfõres pÜ en fiktiv dato mellem den sidste dag i det gamle regnskabsÜr og den fõrste i det nye. Nulstilling af resultatopgõrelseskonti bogfõres ultimo i regnskabsÜret. Rapporten kan f.eks. bruges i forbindelse med Ürsafslutning.;
                                 ENU=View this year's and last year's figures as an ordinary trial balance. For income statement accounts, the balances are shown without closing entries. Closing entries are listed on a fictitious date that falls between the last day of one fiscal year and the first day of the next one. The closing of the income statement accounts is posted at the end of a fiscal year. The report can be used in connection with closing a fiscal year.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 10;
                      Image=Report }
      { 49      ;1   ;Separator  }
      { 50      ;1   ;Action    ;
                      CaptionML=[DAN=Alders&fordelte tilgodehavender;
                                 ENU=Aged Ac&counts Receivable];
                      ToolTipML=[DAN=Vis en oversigt over, hvornÜr dine tilgodehavender fra debitorer skal betales eller rykkes for (opdelt i fire tidsperioder). Du skal angive den dato, som aldersfordelingen skal beregnes ud fra, og du skal angive den periode, som hver kolonne skal indeholde data for.;
                                 ENU=View an overview of when your receivables from customers are due or overdue (divided into four periods). You must specify the date you want aging calculated from and the length of the period that each column will contain data for.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 120;
                      Image=Report }
      { 51      ;1   ;Action    ;
                      CaptionML=[DAN=Aldersfordelt &gëld;
                                 ENU=Aged Accounts Pa&yable];
                      ToolTipML=[DAN=Vis en oversigt over, hvornÜr dine skyldige belõb til kreditorer skal betales eller rykkes for (opdelt i fire tidsperioder). Du skal angive den dato, som aldersfordelingen skal beregnes ud fra, og du skal angive den periode, som hver kolonne skal indeholde data for.;
                                 ENU=View an overview of when your payables to vendors are due or overdue (divided into four periods). You must specify the date you want aging calculated from and the length of the period that each column will contain data for.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 322;
                      Image=Report }
      { 52      ;1   ;Action    ;
                      CaptionML=[DAN=Afste&m deb.- og kred.konti;
                                 ENU=Reconcile Cust. and &Vend. Accs];
                      ToolTipML=[DAN=Vis, om en bestemt finanskonto afstemmer balancen pÜ en bestemt dato for den tilsvarende bogfõringsgruppe. Rapporten viser de konti, der medtages i afstemningen af finansbalancen og debitor- eller kreditorbalancen for hver konto, samt eventuelle forskelle mellem finansbalancen og debitor- eller kreditorbalancen.;
                                 ENU=View if a certain general ledger account reconciles the balance on a certain date for the corresponding posting group. The report shows the accounts that are included in the reconciliation with the general ledger balance and the customer or the vendor ledger balance for each account and shows any differences between the general ledger balance and the customer or vendor ledger balance.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 33;
                      Image=Report }
      { 53      ;1   ;Separator  }
      { 54      ;1   ;Action    ;
                      CaptionML=[DAN=&Kontrol af SE/CVR-nr.;
                                 ENU=VAT Registration No. Chec&k];
                      ToolTipML=[DAN=Brug en tjeneste til validering af EU-momsnumre til at validere en forretningspartners momsnummer.;
                                 ENU=Use an EU VAT number validation service to validated the VAT number of a business partner.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 32;
                      Image=Report }
      { 55      ;1   ;Action    ;
                      CaptionML=[DAN=Momsun&dtagelser;
                                 ENU=VAT E&xceptions];
                      ToolTipML=[DAN=Vis de momsposter, der er bogfõrt og placeret i en finansjournal i forbindelse med en momsdifference. Rapporten bruges til at dokumentere reguleringer af momsbelõb, der er beregnet til brug intern eller ekstern revision.;
                                 ENU=View the VAT entries that were posted and placed in a general ledger register in connection with a VAT difference. The report is used to document adjustments made to VAT amounts that were calculated for use in internal or external auditing.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 31;
                      Image=Report }
      { 56      ;1   ;Action    ;
                      CaptionML=[DAN=Moms&angivelse;
                                 ENU=V&AT Statement];
                      ToolTipML=[DAN=Vis en opgõrelse over bogfõrt moms, og beregn de skyldige afgifter for den valgte periode til toldvësenet.;
                                 ENU=View a statement of posted VAT and calculate the duty liable to the customs authorities for the selected period.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 12;
                      Image=Report }
      { 57      ;1   ;Action    ;
                      CaptionML=[DAN=Moms - listea&ngivelse TS;
                                 ENU=VAT-VIES Declaration Tax A&uth];
                      ToolTipML=[DAN=Vis oplysninger til told- og skattemyndighederne ved salg til andre EU-lande/omrÜder. Hvis oplysningerne skal skrives til en fil, kan du bruge rapporten Moms - listeangivelse disk.;
                                 ENU=View information to the customs and tax authorities for sales to other EU countries/regions. If the information must be printed to a file, you can use the VAT- VIES Declaration Disk report.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 19;
                      Image=Report }
      { 58      ;1   ;Action    ;
                      CaptionML=[DAN=Moms - listeangivelse &disk;
                                 ENU=VAT - VIES Declaration &Disk];
                      ToolTipML=[DAN=RapportÇr dit salg til andre EU-lande/-omrÜder til SKAT. Hvis oplysningerne skal udskrives pÜ en printer, kan du bruge rapporten Moms - listeangivelse TS. Oplysningerne er opstillet pÜ samme mÜde som i listeangivelsen fra SKAT.;
                                 ENU=Report your sales to other EU countries or regions to the customs and tax authorities. If the information must be printed out on a printer, you can use the VAT- VIES Declaration Tax Auth report. The information is shown in the same format as in the declaration list from the customs and tax authorities.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 88;
                      Image=Report }
      { 59      ;1   ;Action    ;
                      CaptionML=[DAN=Oversigt over E&U-salg;
                                 ENU=EC Sal&es List];
                      ToolTipML=[DAN=Beregn momsbelõb fra salg, og indberet belõbene til skattemyndighederne.;
                                 ENU=Calculate VAT amounts from sales, and submit the amounts to a tax authority.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 130;
                      Image=Report }
      { 1900000011;0 ;ActionContainer;
                      ActionContainerType=HomeItems }
      { 107     ;1   ;Action    ;
                      CaptionML=[DAN=Salgstilbud;
                                 ENU=Sales Quotes];
                      ToolTipML=[DAN=Giv tilbud til debitorer for at sëlge bestemte varer pÜ bestemte leverings- og betalingsbetingelser. NÜr du forhandler med en debitor, kan du ëndre og sende salgstilbud, sÜ mange gange du behõver. NÜr debitoren accepterer tilbuddet, skal du konvertere salgstilbuddet til en salgsfaktura eller en salgsordre, som du bruger til at behandle salget.;
                                 ENU=Make offers to customers to sell certain products on certain delivery and payment terms. While you negotiate with a customer, you can change and resend the sales quote as much as needed. When the customer accepts the offer, you convert the sales quote to a sales invoice or a sales order in which you process the sale.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9300;
                      Image=Quote }
      { 115     ;1   ;Action    ;
                      CaptionML=[DAN=Salgsordrer;
                                 ENU=Sales Orders];
                      ToolTipML=[DAN=Registrer dine aftaler med debitorer for at sëlge bestemte varer pÜ bestemte leverings- og betalingsbetingelser. Salgsordrer gõr det i modsëtning til salgsfakturaer muligt at levere delvist, levere direkte fra kreditoren til debitoren, starte lagerekspedition og udskrive forskellige dokumenter til kunderne. Salgsfakturering er integreret i salgsordreprocessen.;
                                 ENU=Record your agreements with customers to sell certain products on certain delivery and payment terms. Sales orders, unlike sales invoices, allow you to ship partially, deliver directly from your vendor to your customer, initiate warehouse handling, and print various customer-facing documents. Sales invoicing is integrated in the sales order process.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9305;
                      Image=Order }
      { 43      ;1   ;Action    ;
                      CaptionML=[DAN=Salgsordrer - Microsoft Dynamics 365 for Sales;
                                 ENU=Sales Orders - Microsoft Dynamics 365 for Sales];
                      ToolTipML=[DAN=Vis salgsordrer i Dynamics 365 for Sales, der er sammenkëdet med salgsordrer i Dynamics NAV.;
                                 ENU=View sales orders in Dynamics 365 for Sales that are coupled with sales orders in Dynamics NAV.];
                      ApplicationArea=#Suite;
                      RunObject=Page 5353;
                      RunPageView=WHERE(StateCode=FILTER(Submitted),
                                        LastBackofficeSubmit=FILTER('')) }
      { 112     ;1   ;Action    ;
                      Name=Customers;
                      CaptionML=[DAN=Debitorer;
                                 ENU=Customers];
                      ToolTipML=[DAN=FÜ vist eller rediger detaljerede oplysninger om de debitorer, som du handler med. Fra det enkelte debitorkort kan du fÜ adgang til relaterede oplysninger som f.eks. salgsstatistik og igangvërende ordrer, og du kan definere specialpriser og linjerabatter, som debitoren fÜr, nÜr bestemte betingelser er opfyldt.;
                                 ENU=View or edit detailed information for the customers that you trade with. From each customer card, you can open related information, such as sales statistics and ongoing orders, and you can define special prices and line discounts that you grant if certain conditions are met.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 22;
                      Image=Customer }
      { 113     ;1   ;Action    ;
                      Name=CustomersBalance;
                      CaptionML=[DAN=Saldo;
                                 ENU=Balance];
                      ToolTipML=[DAN=Se en oversigt over kontosaldoen i forskellige perioder.;
                                 ENU=View a summary of the bank account balance in different periods.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 22;
                      RunPageView=WHERE(Balance (LCY)=FILTER(<>0));
                      Image=Balance }
      { 105     ;1   ;Action    ;
                      CaptionML=[DAN=Kõbsordrer;
                                 ENU=Purchase Orders];
                      ToolTipML=[DAN=Opret kõbsordrer for at afspejle de salgsbilag, som leverandõrer sender til dig. PÜ denne mÜde kan du registrere kõbsomkostninger og spore kreditorer. Bogfõringen af kõbsordrer opdaterer lagerniveauerne dynamisk, sÜ du kan minimere lageromkostningerne og levere bedre kundeservice. Kõbsordrer tillader delleverancer, modsat kõbsfakturaer, og muliggõr direkte levering fra kreditoren til debitoren. Kõbsordrer kan oprettes automatisk ud fra PDF- eller billedfiler fra dine kreditorer ved hjëlp af funktionen IndgÜende bilag.;
                                 ENU=Create purchase orders to mirror sales documents that vendors send to you. This enables you to record the cost of purchases and to track accounts payable. Posting purchase orders dynamically updates inventory levels so that you can minimize inventory costs and provide better customer service. Purchase orders allow partial receipts, unlike with purchase invoices, and enable drop shipment directly from your vendor to your customer. Purchase orders can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9307 }
      { 102     ;1   ;Action    ;
                      Name=Vendors;
                      CaptionML=[DAN=Kreditorer;
                                 ENU=Vendors];
                      ToolTipML=[DAN=FÜ vist eller rediger detaljerede oplysninger om de kreditorer, som du handler med. Fra det enkelte kreditorkort kan du fÜ adgang til relaterede oplysninger som f.eks. kõbsstatistik og igangvërende ordrer, og du kan definere specialpriser og linjerabatter, som kreditoren giver dig, nÜr bestemte betingelser er opfyldt.;
                                 ENU=View or edit detailed information for the vendors that you trade with. From each vendor card, you can open related information, such as purchase statistics and ongoing orders, and you can define special prices and line discounts that the vendor grants you if certain conditions are met.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 27;
                      Image=Vendor }
      { 103     ;1   ;Action    ;
                      Name=VendorsBalance;
                      CaptionML=[DAN=Saldo;
                                 ENU=Balance];
                      ToolTipML=[DAN=Se en oversigt over kontosaldoen i forskellige perioder.;
                                 ENU=View a summary of the bank account balance in different periods.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 27;
                      RunPageView=WHERE(Balance (LCY)=FILTER(<>0));
                      Image=Balance }
      { 110     ;1   ;Action    ;
                      CaptionML=[DAN=Varer;
                                 ENU=Items];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om de produkter, du handler med. Varekortet kan vëre af typen lager eller tjeneste for at angive, om varen er en fysisk enhed eller en bestÜr af arbejdstimer. Her angiver du ogsÜ, om varerne pÜ lager eller i indgÜende ordrer automatisk reserveres til udgÜende bilag, og om der er oprettet ordresporingsbindinger mellem behov og forsyning for at afspejle planlëgningshandlinger.;
                                 ENU=View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 31;
                      Image=Item }
      { 1900000012;0 ;ActionContainer;
                      ActionContainerType=ActivityButtons }
      { 109     ;1   ;ActionGroup;
                      CaptionML=[DAN=Kladder;
                                 ENU=Journals];
                      Image=Journals }
      { 6       ;2   ;Action    ;
                      Name=ItemJournals;
                      CaptionML=[DAN=Varekladder;
                                 ENU=Item Journals];
                      ToolTipML=[DAN=èbn en liste med kladder, hvor du kan justere det fysiske antal varer pÜ lager.;
                                 ENU=Open a list of journals where you can adjust the physical quantity of items on inventory.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 262;
                      RunPageView=WHERE(Template Type=CONST(Item),
                                        Recurring=CONST(No)) }
      { 8       ;2   ;Action    ;
                      Name=PhysicalInventoryJournals;
                      CaptionML=[DAN=Lageropgõrelseskladder;
                                 ENU=Physical Inventory Journals];
                      ToolTipML=[DAN=Forbered optëlling af de faktiske varer pÜ lager for at kontrollere, om det antal, der er registreret i systemet, er det samme som den fysiske mëngde. Hvis der er forskelle, skal du bogfõre dem i varekladden med lageropgõrelseskladden, fõr du opgõr lagervërdien.;
                                 ENU=Prepare to count the actual items in inventory to check if the quantity registered in the system is the same as the physical quantity. If there are differences, post them to the item ledger with the physical inventory journal before you do the inventory valuation.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 262;
                      RunPageView=WHERE(Template Type=CONST(Phys. Inventory),
                                        Recurring=CONST(No)) }
      { 18      ;2   ;Action    ;
                      Name=RevaluationJournals;
                      CaptionML=[DAN=Vërdireguleringskladder;
                                 ENU=Revaluation Journals];
                      ToolTipML=[DAN=Ret lagervërdien af varer, f.eks. nÜr du har foretaget en fysisk lageropgõrelse.;
                                 ENU=Change the inventory value of items, for example after doing a physical inventory.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 262;
                      RunPageView=WHERE(Template Type=CONST(Revaluation),
                                        Recurring=CONST(No)) }
      { 33      ;2   ;Action    ;
                      CaptionML=[DAN=Ressourcekladder;
                                 ENU=Resource Journals];
                      ToolTipML=[DAN=Vis alle ressourcekladder.;
                                 ENU=View all resource journals.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 272;
                      RunPageView=WHERE(Recurring=CONST(No)) }
      { 34      ;2   ;Action    ;
                      CaptionML=[DAN=Anlëgskladder;
                                 ENU=FA Journals];
                      ToolTipML=[DAN=Bogfõr poster i en afskrivningsprofil uden integration i finansregnskabet.;
                                 ENU=Post entries to a depreciation book without integration to the general ledger.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5633;
                      RunPageView=WHERE(Recurring=CONST(No)) }
      { 36      ;2   ;Action    ;
                      Name=CashReceiptJournals;
                      CaptionML=[DAN=Indbetalingskladder;
                                 ENU=Cash Receipt Journals];
                      ToolTipML=[DAN=Registrer modtagne betalinger ved at udligne dem manuelt for de relaterede debitor-, kreditor- eller bankposter. Bogfõr derefter betalingerne til finanskontiene, sÜ du kan lukke de relaterede poster.;
                                 ENU=Register received payments by manually applying them to the related customer, vendor, or bank ledger entries. Then, post the payments to G/L accounts and thereby close the related ledger entries.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 251;
                      RunPageView=WHERE(Template Type=CONST(Cash Receipts),
                                        Recurring=CONST(No));
                      Image=Journals }
      { 46      ;2   ;Action    ;
                      Name=PaymentJournals;
                      CaptionML=[DAN=Udbetalingskladder;
                                 ENU=Payment Journals];
                      ToolTipML=[DAN=Registrer betalinger til kreditorer. En betalingskladde er en finanskladde, der bruges til at bogfõre udgÜende betalingstransaktioner til finansregnskab, bank, debitor, kreditor, medarbejder og anlëgskonti. Funktionerne for Lav kreditorbetalingsforslag udfylder automatisk kladden med de forfaldne betalinger. NÜr betalingerne er bogfõrt, kan du eksportere betalingerne til en bankfil med henblik pÜ overfõrsel til din bank, sÜfremt systemet er konfigureret til elektronisk betaling. Du kan ogsÜ sende computercheck fra betalingskladden.;
                                 ENU=Register payments to vendors. A payment journal is a type of general journal that is used to post outgoing payment transactions to G/L, bank, customer, vendor, employee, and fixed assets accounts. The Suggest Vendor Payments functions automatically fills the journal with payments that are due. When payments are posted, you can export the payments to a bank file for upload to your bank if your system is set up for electronic banking. You can also issue computer checks from the payment journal.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 251;
                      RunPageView=WHERE(Template Type=CONST(Payments),
                                        Recurring=CONST(No));
                      Image=Journals }
      { 35      ;2   ;Action    ;
                      Name=GeneralJournals;
                      CaptionML=[DAN=Finanskladder;
                                 ENU=General Journals];
                      ToolTipML=[DAN=Bogfõr õkonomiske transaktioner direkte til finanskonti og andre konti som f.eks. bank-, debitor-, kreditor- og medarbejderkonti. Bogfõring med en finanskladde opretter altid poster pÜ finanskontiene. Dette gëlder ogsÜ, nÜr du eksempelvis bogfõrer en kladdelinje til en debitorkonto, fordi der er bogfõrt en post til finansregnskabets konto for tilgodehavender via en bogfõringsgruppe.;
                                 ENU=Post financial transactions directly to general ledger accounts and other accounts, such as bank, customer, vendor, and employee accounts. Posting with a general journal always creates entries on general ledger accounts. This is true even when, for example, you post a journal line to a customer account, because an entry is posted to a general ledger receivables account through a posting group.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 251;
                      RunPageView=WHERE(Template Type=CONST(General),
                                        Recurring=CONST(No));
                      Image=Journal }
      { 47      ;2   ;Action    ;
                      Name=RecurringJournals;
                      CaptionML=[DAN=Gentagelseskladder;
                                 ENU=Recurring Journals];
                      ToolTipML=[DAN=Vis alle gentagelseskladder;
                                 ENU=View all recurring journals];
                      ApplicationArea=#Advanced;
                      RunObject=Page 251;
                      RunPageView=WHERE(Template Type=CONST(General),
                                        Recurring=CONST(Yes)) }
      { 117     ;1   ;ActionGroup;
                      CaptionML=[DAN=Kladder;
                                 ENU=Worksheets];
                      Image=Worksheets }
      { 64      ;2   ;Action    ;
                      CaptionML=[DAN=Indkõbskladder;
                                 ENU=Requisition Worksheets];
                      ToolTipML=[DAN=Beregn en forsyningsplan for at opfylde varebehov via indkõb eller overfõrsler.;
                                 ENU=Calculate a supply plan to fulfill item demand with purchases or transfers.];
                      ApplicationArea=#Planning;
                      RunObject=Page 295;
                      RunPageView=WHERE(Template Type=CONST(Req.),
                                        Recurring=CONST(No)) }
      { 39      ;1   ;ActionGroup;
                      CaptionML=[DAN=Bogfõrte dokumenter;
                                 ENU=Posted Documents];
                      Image=FiledPosted }
      { 118     ;2   ;Action    ;
                      CaptionML=[DAN=Bogf. salgsleverancer;
                                 ENU=Posted Sales Shipments];
                      ToolTipML=[DAN=èbn listen over bogfõrte salgsleverancer.;
                                 ENU=Open the list of posted sales shipments.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 142;
                      Image=PostedShipment }
      { 25      ;2   ;Action    ;
                      CaptionML=[DAN=Bogf. salgsfakturaer;
                                 ENU=Posted Sales Invoices];
                      ToolTipML=[DAN=èbn listen over bogfõrte salgsfakturaer.;
                                 ENU=Open the list of posted sales invoices.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 143;
                      Image=PostedOrder }
      { 26      ;2   ;Action    ;
                      CaptionML=[DAN=Bogf. salgskr.notaer;
                                 ENU=Posted Sales Credit Memos];
                      ToolTipML=[DAN=èbn listen over bogfõrte salgskreditnotaer.;
                                 ENU=Open the list of posted sales credit memos.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 144;
                      Image=PostedOrder }
      { 119     ;2   ;Action    ;
                      CaptionML=[DAN=Bogf. kõbsmodtagelser;
                                 ENU=Posted Purchase Receipts];
                      ToolTipML=[DAN=èbn listen over bogfõrte kõbsmodtagelser.;
                                 ENU=Open the list of posted purchase receipts.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 145 }
      { 27      ;2   ;Action    ;
                      CaptionML=[DAN=Bogf. kõbsfakturaer;
                                 ENU=Posted Purchase Invoices];
                      ToolTipML=[DAN=èbn listen over bogfõrte kõbsfakturaer.;
                                 ENU=Open the list of posted purchase invoices.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 146 }
      { 28      ;2   ;Action    ;
                      CaptionML=[DAN=Bogfõrte kõbskreditnotaer;
                                 ENU=Posted Purchase Credit Memos];
                      ToolTipML=[DAN=èbn listen over bogfõrte kõbskreditnotaer.;
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
      { 143     ;1   ;ActionGroup;
                      CaptionML=[DAN=Finans;
                                 ENU=Finance];
                      Image=Bank }
      { 152     ;2   ;Action    ;
                      CaptionML=[DAN=Momsangivelse;
                                 ENU=VAT Statements];
                      ToolTipML=[DAN=FÜ vist en opgõrelse over de bogfõrte momsbelõb, beregn dine momsafregningsbelõb for en bestemt periode som f.eks. et kvartal, og forbered indsendelse af momsangivelsen til myndighederne.;
                                 ENU=View a statement of posted VAT amounts, calculate your VAT settlement amount for a certain period, such as a quarter, and prepare to send the settlement to the tax authorities.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 320 }
      { 154     ;2   ;Action    ;
                      CaptionML=[DAN=Kontoplan;
                                 ENU=Chart of Accounts];
                      ToolTipML=[DAN=Vis kontoplanen.;
                                 ENU=View the chart of accounts.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 16 }
      { 153     ;2   ;Action    ;
                      CaptionML=[DAN=Bankkonti;
                                 ENU=Bank Accounts];
                      ToolTipML=[DAN=FÜ vist eller konfigurer detaljerede oplysninger om din bankkonto, f.eks. hvilken valuta der skal bruges, formatet pÜ de bankfiler, du importerer og eksporterer som elektroniske betalinger, samt nummereringen af checks.;
                                 ENU=View or set up detailed information about your bank account, such as which currency to use, the format of bank files that you import and export as electronic payments, and the numbering of checks.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 371;
                      Image=BankAccount }
      { 144     ;2   ;Action    ;
                      CaptionML=[DAN=Valutaer;
                                 ENU=Currencies];
                      ToolTipML=[DAN=FÜ vist de forskellige valutaer, du handler i, eller opdater valutakurserne ved at hente de seneste kurser fra en ekstern tjenesteudbyder.;
                                 ENU=View the different currencies that you trade in or update the exchange rates by getting the latest rates from an external service provider.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5;
                      Image=Currency }
      { 145     ;2   ;Action    ;
                      CaptionML=[DAN=Regnskabsperioder;
                                 ENU=Accounting Periods];
                      ToolTipML=[DAN=Angiv antal regnskabsperioder - f.eks. 12 mÜnedsperioder - i regnskabsÜret, og angiv, hvilken periode der er starten pÜ det nye regnskabsÜr.;
                                 ENU=Set up the number of accounting periods, such as 12 monthly periods, within the fiscal year and specify which period is the start of the new fiscal year.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 100;
                      Image=AccountingPeriods }
      { 150     ;2   ;Action    ;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omrÜde, projekt eller afdeling, som du kan tildele til salgs- og kõbsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      RunObject=Page 536;
                      Image=Dimensions }
      { 151     ;2   ;Action    ;
                      CaptionML=[DAN=Bankkontobogfõringsgrupper;
                                 ENU=Bank Account Posting Groups];
                      ToolTipML=[DAN=Opret bogfõringsgrupper, sÜ betalinger til og fra de enkelte bankkonti bogfõres pÜ den angivne finanskonto.;
                                 ENU=Set up posting groups, so that payments in and out of each bank account are posted to the specified general ledger account.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 373 }
      { 155     ;1   ;ActionGroup;
                      CaptionML=[DAN=Marketing;
                                 ENU=Marketing];
                      Image=Marketing }
      { 156     ;2   ;Action    ;
                      CaptionML=[DAN=Kontakter;
                                 ENU=Contacts];
                      ToolTipML=[DAN=Vis en liste med alle dine kontakter.;
                                 ENU=View a list of all your contacts.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5052;
                      Image=CustomerContact }
      { 157     ;2   ;Action    ;
                      CaptionML=[DAN=Opgaver;
                                 ENU=Tasks];
                      ToolTipML=[DAN=FÜ vist listen over eksisterende marketingopgaver.;
                                 ENU=View the list of marketing tasks that exist.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5096;
                      Image=TaskList }
      { 158     ;1   ;ActionGroup;
                      CaptionML=[DAN=Salg;
                                 ENU=Sales];
                      Image=Sales }
      { 159     ;2   ;Action    ;
                      CaptionML=[DAN=Montagestykliste;
                                 ENU=Assembly BOM];
                      ToolTipML=[DAN=FÜ vist eller rediger den stykliste, der angiver, hvilke varer og ressourcer der krëves for at samle montageelementet.;
                                 ENU=View or edit the bill of material that specifies which items and resources are required to assemble the assembly item.];
                      ApplicationArea=#Assembly;
                      RunObject=Page 36;
                      Image=AssemblyBOM }
      { 160     ;2   ;Action    ;
                      CaptionML=[DAN=Salgskreditnotaer;
                                 ENU=Sales Credit Memos];
                      ToolTipML=[DAN=Tilbagefõr õkonomiske transaktioner, nÜr debitorerne vil annullere et kõb eller returnere forkerte eller beskadigede varer, som du har sendt til dem og modtaget betaling for. For at fÜ de rette oplysninger med, kan du oprette salgskreditnotaen ud fra den relaterede bogfõrte salgsfaktura, eller du kan oprette en ny salgskreditnota, hvor du indsëtter en kopi af fakturaoplysninger. Hvis du har brug for flere kontrol over processen for salgsreturvarer som f.eks. bilag for den fysiske lagerekspedition, skal du bruge salgsreturvareordrer, hvor salgskreditnotaer er integreret. Bemërk: Hvis et fejlbehëftet salg endnu ikke er blevet betalt, kan du blot annullere den bogfõrte salgsfaktura for automatisk at tilbagefõre den õkonomiske transaktion.;
                                 ENU=Revert the financial transactions involved when your customers want to cancel a purchase or return incorrect or damaged items that you sent to them and received payment for. To include the correct information, you can create the sales credit memo from the related posted sales invoice or you can create a new sales credit memo with copied invoice information. If you need more control of the sales return process, such as warehouse documents for the physical handling, use sales return orders, in which sales credit memos are integrated. Note: If an erroneous sale has not been paid yet, you can simply cancel the posted sales invoice to automatically revert the financial transaction.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9302 }
      { 161     ;2   ;Action    ;
                      CaptionML=[DAN=Standardsalgskoder;
                                 ENU=Standard Sales Codes];
                      ToolTipML=[DAN=Vis eller rediger kõbslinjer, som du har konfigureret for tilbagevendende salg, f.eks. en mÜnedlig genbestillingsordre.;
                                 ENU=View or edit purchase lines that you have set up for recurring sales, such as a monthly replenishment order.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 172 }
      { 162     ;2   ;Action    ;
                      CaptionML=[DAN=Sëlgere/indkõbere;
                                 ENU=Salespeople/Purchasers];
                      ToolTipML=[DAN=Vis en liste med dine salgsmedarbejdere og dine indkõbere.;
                                 ENU=View a list of your sales people and your purchasers.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 14 }
      { 163     ;2   ;Action    ;
                      CaptionML=[DAN=Debitorfakturarabat;
                                 ENU=Customer Invoice Discount];
                      ToolTipML=[DAN=Vis eller rediger betingelser for fakturarabatter og servicegebyrer for forskellige kreditorer.;
                                 ENU=View or edit conditions for invoice discounts and service charges for different customers.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 23 }
      { 92      ;1   ;ActionGroup;
                      CaptionML=[DAN=Indkõb;
                                 ENU=Purchasing];
                      Image=Purchasing }
      { 122     ;2   ;Action    ;
                      CaptionML=[DAN=Standardkõbskoder;
                                 ENU=Standard Purchase Codes];
                      ToolTipML=[DAN=Vis eller rediger kõbslinjer, som du har konfigureret for tilbagevendende kõb, f.eks. en mÜnedlig genbestillingsordre.;
                                 ENU=View or edit purchase lines that you have set up for recurring purchases, such as a monthly replenishment order.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 177 }
      { 123     ;2   ;Action    ;
                      CaptionML=[DAN=Kreditorfakturarabatter;
                                 ENU=Vendor Invoice Discounts];
                      ToolTipML=[DAN=Vis eller rediger betingelser for, hvornÜr dine kreditorer giver dig fakturarabatter. Hver linje indeholder et sët betingelser for en fakturarabat. Du kan oprette sÜ mange linjer som nõdvendigt, hvis du fÜr forskellige rabatprocentsatser for forskellige fakturabelõb og for forskellige valutaer.;
                                 ENU=View or edit conditions for when your vendors grant you invoice discounts. Each line contains a set of conditions for an invoice discount. You can set up as many lines as necessary if you receive different discount percentages for different invoice amounts and for different currencies.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 28 }
      { 124     ;2   ;Action    ;
                      CaptionML=[DAN=Varerabatgrupper;
                                 ENU=Item Discount Groups];
                      ToolTipML=[DAN=Opsët rabatgruppekoder, som du kan bruge som kriterier, nÜr du definerer sërlige rabatter pÜ et debitor-, kreditor- eller varekort.;
                                 ENU=Set up discount group codes that you can use as criteria when you define special discounts on a customer, vendor, or item card.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 513 }
      { 125     ;1   ;ActionGroup;
                      CaptionML=[DAN=Ressourcer;
                                 ENU=Resources];
                      Image=ResourcePlanning }
      { 126     ;2   ;Action    ;
                      CaptionML=[DAN=Ressourcer;
                                 ENU=Resources];
                      ToolTipML=[DAN=Administrer dine ressourcers sagsaktiviteter ved at angive deres omkostninger og priser. Reglerne for sagsrelaterede pris-, rabat- og kostfaktorer konfigureres for de respektive jobkort. Du kan angive omkostninger og priser for individuelle ressourcer, ressourcegrupper eller alle tilgëngelige ressourcer i virksomheden. NÜr ressourcerne anvendes eller sëlges i en sag, registreres de angivne priser og omkostninger for projektet.;
                                 ENU=Manage your resources' job activities by setting up their costs and prices. The job-related prices, discounts, and cost factor rules are set up on the respective job card. You can specify the costs and prices for individual resources, resource groups, or all available resources of the company. When resources are used or sold in a job, the specified prices and costs are recorded for the project.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 77 }
      { 131     ;2   ;Action    ;
                      CaptionML=[DAN=Ressourcegrupper;
                                 ENU=Resource Groups];
                      ToolTipML=[DAN=Vis alle ressourcegrupper.;
                                 ENU=View all resource groups.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 72 }
      { 136     ;2   ;Action    ;
                      CaptionML=[DAN=Ressourceprisforslag;
                                 ENU=Resource Price Changes];
                      ToolTipML=[DAN=Rediger eller opdater alternative ressourcepriser ved at kõre kõrslen ForeslÜ ress.salgspris (ress.) eller kõrslen ForeslÜ ress.salgspris (pris).;
                                 ENU=Edit or update alternate resource prices, by running either the Suggest Res. Price Chg. (Res.) batch job or the Suggest Res. Price Chg. (Price) batch job.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 493;
                      Image=ResourcePrice }
      { 137     ;2   ;Action    ;
                      CaptionML=[DAN=Ressourcejournaler;
                                 ENU=Resource Registers];
                      ToolTipML=[DAN=Vis en liste over alle ressourcejournaler. Hver gang en ressourcepost bliver bogfõrt, oprettes der en ressourcejournal. Hver journal viser det fõrste og sidste lõbenummer for posterne i den. Du kan bruge oplysningerne i en ressourcejournal til at dokumentere, hvornÜr posterne er bogfõrt.;
                                 ENU=View a list of all the resource registers. Every time a resource entry is posted, a register is created. Every register shows the first and last entry numbers of its entries. You can use the information in a resource register to document when entries were posted.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 274;
                      Image=ResourceRegisters }
      { 138     ;1   ;ActionGroup;
                      CaptionML=[DAN=Personale;
                                 ENU=Human Resources];
                      Image=HumanResources }
      { 139     ;2   ;Action    ;
                      CaptionML=[DAN=Medarbejdere;
                                 ENU=Employees];
                      ToolTipML=[DAN=Administrer medarbejderoplysninger og relaterede oplysninger som f.eks. kvalifikationer og billeder, eller registrer og analysÇr medarbejderfravër. Sikring af opdaterede records om medarbejderne forenkler dine personaleopgaver. Hvis en medarbejder f.eks. skifter adresse, kan du registrere dette pÜ medarbejderkortet.;
                                 ENU=Manage employees' details and related information, such as qualifications and pictures, or register and analyze employee absence. Keeping up-to-date records about your employees simplifies personnel tasks. For example, if an employee's address changes, you register this on the employee card.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5201;
                      Image=Employee }
      { 16      ;1   ;ActionGroup;
                      CaptionML=[DAN=Anlëg;
                                 ENU=Fixed Assets];
                      Image=FixedAssets }
      { 17      ;2   ;Action    ;
                      CaptionML=[DAN=Anlëg;
                                 ENU=Fixed Assets];
                      ToolTipML=[DAN=AdministrÇr periodisk afskrivning af dine maskiner, hold styr pÜ reparationsomkostningerne, administrÇr forsikringspolicer vedrõrende faste anlëgsaktiver, og overvÜg statistik for faste anlëgsaktiver.;
                                 ENU=Manage periodic depreciation of your machinery or machines, keep track of your maintenance costs, manage insurance policies related to fixed assets, and monitor fixed asset statistics.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5601 }
      { 140     ;1   ;ActionGroup;
                      CaptionML=[DAN=Opsëtning;
                                 ENU=Administration];
                      Image=Administration }
      { 141     ;2   ;Action    ;
                      CaptionML=[DAN=Brugeropsëtning;
                                 ENU=User Setup];
                      ToolTipML=[DAN=Konfigurer brugere, og definer deres rettigheder.;
                                 ENU=Set up users and define their permissions..];
                      ApplicationArea=#Advanced;
                      RunObject=Page 119;
                      Image=UserSetup }
      { 165     ;2   ;Action    ;
                      CaptionML=[DAN=Liste over dataskabeloner;
                                 ENU=Data Templates List];
                      ToolTipML=[DAN=Viser eller rediger den skabelon, der bruges til dataoverfõrsel.;
                                 ENU=View or edit template that are being used for data migration.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 8620 }
      { 166     ;2   ;Action    ;
                      CaptionML=[DAN=Basiskalenderoversigt;
                                 ENU=Base Calendar List];
                      ToolTipML=[DAN=Vis oversigten over kalendere til din virksomhed og dine forretningspartnere for at definere de aftalte arbejdsdage.;
                                 ENU=View the list of calendars that exist for your company and your business partners to define the agreed working days.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 7601 }
      { 167     ;2   ;Action    ;
                      CaptionML=[DAN=Postnumre;
                                 ENU=Post Codes];
                      ToolTipML=[DAN=Konfigurer postnumre for de byer, hvor dine forretningspartnere er placeret.;
                                 ENU=Set up the post codes of cities where your business partners are located.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 367 }
      { 168     ;2   ;Action    ;
                      CaptionML=[DAN=èrsagskoder;
                                 ENU=Reason Codes];
                      ToolTipML=[DAN=Vis eller konfigurer koder, der angiver Ürsager til oprettelse af poster (f.eks. Returvare), for at angive, hvorfor en kõbskreditnota er bogfõrt.;
                                 ENU=View or set up codes that specify reasons why entries were created, such as Return, to specify why a purchase credit memo was posted.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 259 }
      { 169     ;2   ;Action    ;
                      CaptionML=[DAN=Udvidede tekster;
                                 ENU=Extended Texts];
                      ToolTipML=[DAN=Vis eller rediger supplerende tekst til varebeskrivelserne. Den udvidede tekst kan indsëttes under feltet Beskrivelse i dokumentlinjerne for varen.;
                                 ENU=View or edit additional text for the descriptions of items. Extended text can be inserted under the Description field on document lines for the item.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 391;
                      Image=Text }
      { 1       ;0   ;ActionContainer;
                      ActionContainerType=NewDocumentItems }
      { 11      ;1   ;Action    ;
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
      { 1060043 ;1   ;Action    ;
                      CaptionML=[DAN=&Salgsordre;
                                 ENU=Sales &Order];
                      ToolTipML=[DAN=Opret en ny salgsordre.;
                                 ENU=Create a new sales order.];
                      RunObject=Page 42;
                      Promoted=No;
                      Image=Document;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 9       ;1   ;Action    ;
                      CaptionML=[DAN=Salgs&kreditnota;
                                 ENU=Sales Credit &Memo];
                      ToolTipML=[DAN=Opret en ny salgskreditnota for at tilbagefõre en bogfõrt salgsfaktura.;
                                 ENU=Create a new sales credit memo to revert a posted sales invoice.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 44;
                      Promoted=No;
                      Image=CreditMemo;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 7       ;1   ;Action    ;
                      CaptionML=[DAN=R&ykker;
                                 ENU=&Sales Reminder];
                      ToolTipML=[DAN=Opret en rykker for at minde en debitor om for sen betaling.;
                                 ENU=Create a reminder to remind a customer of overdue payment.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 434;
                      Promoted=No;
                      Image=Reminder;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 5       ;1   ;Separator  }
      { 4       ;1   ;Action    ;
                      CaptionML=[DAN=&Kreditor;
                                 ENU=&Vendor];
                      ToolTipML=[DAN="Opret en ny kreditor, som du kõber varer eller tjenester hos. ";
                                 ENU="Set up a new vendor from whom you buy goods or services. "];
                      ApplicationArea=#Advanced;
                      RunObject=Page 26;
                      Promoted=No;
                      Image=Vendor;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 1060012 ;1   ;Action    ;
                      CaptionML=[DAN=Kõbs&ordre;
                                 ENU=&Purchase Order];
                      ToolTipML=[DAN=Opret en ny kõbsordre.;
                                 ENU=Create a new purchase order.];
                      RunObject=Page 50;
                      Promoted=No;
                      Image=Document;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 13      ;1   ;Separator ;
                      CaptionML=[DAN=Opgaver;
                                 ENU=Tasks];
                      IsHeader=Yes }
      { 14      ;1   ;Action    ;
                      CaptionML=[DAN=&Indbetalingskladde;
                                 ENU=Cash Receipt &Journal];
                      ToolTipML=[DAN=èbn indbetalingskladden for at bogfõre indgÜende betalinger.;
                                 ENU=Open the cash receipt journal to post incoming payments.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 255;
                      Image=CashReceiptJournal }
      { 15      ;1   ;Action    ;
                      CaptionML=[DAN=Kreditor&udbetalingskladde;
                                 ENU=Vendor Pa&yment Journal];
                      ToolTipML=[DAN=Betal dine kreditorer ved at udfylde betalingskladden automatisk i henhold til de forfaldne betalinger, og eksportÇr eventuelt alle betalinger til din bank til automatisk behandling.;
                                 ENU=Pay your vendors by filling the payment journal automatically according to payments due, and potentially export all payment to your bank for automatic processing.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 256;
                      Image=VendorPaymentJournal }
      { 44      ;1   ;Action    ;
                      CaptionML=[DAN=Salgs&priskladde;
                                 ENU=Sales Price &Worksheet];
                      ToolTipML=[DAN=Administrer salgspriser for individuelle debitorer, for en debitorgruppe, for alle debitorer eller for en kampagne.;
                                 ENU=Manage sales prices for individual customers, for a group of customers, for all customers, or for a campaign.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 7023;
                      Image=PriceWorksheet }
      { 173     ;1   ;Action    ;
                      CaptionML=[DAN=Salgsp&riser;
                                 ENU=Sales P&rices];
                      ToolTipML=[DAN=FÜ vist eller rediger specialsalgspriser, som du giver, nÜr bestemte betingelser er opfyldt, f.eks. debitor, mëngde eller slutdato. Prisaftalerne kan gëlde for individuelle debitorer, for debitorgrupper, for alle debitorer eller for en kampagne.;
                                 ENU=View or edit special sales prices that you grant when certain conditions are met, such as customer, quantity, or ending date. The price agreements can be for individual customers, for a group of customers, for all customers or for a campaign.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 7002;
                      Image=SalesPrices }
      { 174     ;1   ;Action    ;
                      CaptionML=[DAN=Salgs&linjerabatter;
                                 ENU=Sales &Line Discounts];
                      ToolTipML=[DAN=FÜ vist de tilgëngelige salgslinjerabatter. Disse rabataftaler kan gëlde for individuelle debitorer, for debitorgrupper, for alle debitorer eller for en kampagne.;
                                 ENU=View the sales line discounts that are available. These discount agreements can be for individual customers, for a group of customers, for all customers or for a campaign.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 7004;
                      Image=SalesLineDisc }
      { 1060000 ;1   ;Action    ;
                      CaptionML=[DAN=Opret elektroniske fakturaer;
                                 ENU=Create Electronic Invoices];
                      ToolTipML=[DAN=Opret en elektronisk version af det aktuelle dokument.;
                                 ENU=Create an electronic version of the current document.];
                      RunObject=Report 13600;
                      Image=ElectronicDoc }
      { 1060001 ;1   ;Action    ;
                      CaptionML=[DAN=Opret elektroniske kreditnotaer;
                                 ENU=Create Electronic Credit Memos];
                      ToolTipML=[DAN=Opret en elektronisk version af det aktuelle dokument.;
                                 ENU=Create an electronic version of the current document.];
                      RunObject=Report 13601;
                      Image=ElectronicDoc }
      { 1060002 ;1   ;Action    ;
                      CaptionML=[DAN=Opret elektroniske rykkere;
                                 ENU=Create Electronic Reminders];
                      ToolTipML=[DAN=Opret en elektronisk version af det aktuelle dokument.;
                                 ENU=Create an electronic version of the current document.];
                      RunObject=Report 13602;
                      Image=Report }
      { 1060003 ;1   ;Action    ;
                      CaptionML=[DAN=Opret elektroniske rentenotaer;
                                 ENU=Create Electronic Fin. Chrg. Memos];
                      ToolTipML=[DAN=Opret en elektronisk version af det aktuelle dokument.;
                                 ENU=Create an electronic version of the current document.];
                      RunObject=Report 13603;
                      Image=ElectronicDoc }
      { 1060004 ;1   ;Action    ;
                      CaptionML=[DAN=Opret elektroniske servicefakturaer;
                                 ENU=Create Electronic Service Invoices];
                      ToolTipML=[DAN=Opret en elektronisk version af det aktuelle dokument.;
                                 ENU=Create an electronic version of the current document.];
                      RunObject=Report 13604;
                      Image=ElectronicDoc }
      { 1060005 ;1   ;Action    ;
                      CaptionML=[DAN=Opret elektroniske servicekreditnotaer;
                                 ENU=Create Electronic Service Credit Memos];
                      ToolTipML=[DAN=Opret en elektronisk version af det aktuelle dokument.;
                                 ENU=Create an electronic version of the current document.];
                      RunObject=Report 13605;
                      Image=ElectronicDoc }
      { 19      ;1   ;Separator  }
      { 20      ;1   ;Action    ;
                      CaptionML=[DAN=Bankkontoa&fstemning;
                                 ENU=&Bank Account Reconciliation];
                      ToolTipML=[DAN="Afstem poster i dine bankkontoposter med de faktiske transaktioner pÜ din bankkonto i henhold til den seneste bankkontoudtog. ";
                                 ENU="Reconcile entries in your bank account ledger entries with the actual transactions in your bank account, according to the latest bank statement. "];
                      ApplicationArea=#Advanced;
                      RunObject=Page 379;
                      Image=BankAccountRec }
      { 170     ;1   ;Action    ;
                      CaptionML=[DAN=Betalingsregistrering;
                                 ENU=Payment Registration];
                      ToolTipML=[DAN=Anvend debitorbetalinger pÜ bankkontoen pÜ ikke-bogfõrte salgsbilag for at registrere, at betalingen er foretaget.;
                                 ENU=Apply customer payments observed on your bank account to non-posted sales documents to record that payment is made.];
                      ApplicationArea=#Advanced;
                      RunObject=Codeunit 980;
                      Image=Payment }
      { 21      ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kursreguler valu&tabeholdninger;
                                 ENU=Adjust E&xchange Rates];
                      ToolTipML=[DAN=Reguler finans-, debitor-, kreditor- og bankkontoposter, sÜ de svarer til den opdaterede saldo i situationer, hvor kursen har ëndret sig siden bogfõringen.;
                                 ENU=Adjust general ledger, customer, vendor, and bank account entries to reflect a more updated balance if the exchange rate has changed since the entries were posted.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 595;
                      Image=AdjustExchangeRates }
      { 45      ;1   ;Action    ;
                      CaptionML=[DAN=R&eguler varepriser;
                                 ENU=Adjust &Item Costs/Prices];
                      ToolTipML=[DAN=Justerer felterne Sidste kõbspris, Kostpris (standard), Enhedspris, Avancepct. og Indir. omkost.pct. pÜ varekort eller lagervarekort. Du kan f.eks. ëndre den sidste kõbspris pÜ alle varer fra en bestemt leverandõr med 5 %. índringerne gennemfõres med det samme, nÜr kõrslen er sat i gang. De felter pÜ varekortet, som er afhëngige af det justerede felt, ëndres ogsÜ.;
                                 ENU=Adjusts the Last Direct Cost, Standard Cost, Unit Price, Profit %, and Indirect Cost % fields on the item or stockkeeping unit cards. For example, you can change Last Direct Cost by 5% on all items from a specific vendor. The changes are processed immediately when the batch job is started. The fields on the item card that are dependent on the adjusted field are also changed.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 794;
                      Image=AdjustItemCost }
      { 65      ;1   ;Action    ;
                      CaptionML=[DAN=&Juster kostpris - vareposter;
                                 ENU=Adjust &Cost - Item Entries];
                      ToolTipML=[DAN=Regulerer lagervërdierne i vareposter, sÜ du kan bruge den korrekte, regulerede kostpris til opdatering af finansregnskabet, og sÜ salgs- og indtjeningsstatistikkerne er opdateret.;
                                 ENU=Adjust inventory values in value entries so that you use the correct adjusted cost for updating the general ledger and so that sales and profit statistics are up to date.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 795;
                      Image=AdjustEntries }
      { 22      ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Bogf&õr lagerregulering;
                                 ENU=Post Inve&ntory Cost to G/L];
                      ToolTipML=[DAN=Bogfõr ëndringen i antal og vërdi for lageret i vareposterne og vërdiposterne, nÜr du bogfõrer lagertransaktioner som f.eks. salgsleverancer eller kõbsfakturaer.;
                                 ENU=Post the quantity and value changes to the inventory in the item ledger entries and the value entries when you post inventory transactions, such as sales shipments or purchase receipts.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 1002;
                      Image=PostInventoryToGL }
      { 23      ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Afregn &moms;
                                 ENU=Calc. and Post VAT Settlem&ent];
                      ToolTipML=[DAN=Luk Übne momsposter og overfõrer kõbs- og salgsmomsbelõb til momsafregningskontoen. For hver momsbogfõringsgruppe finder kõrslen alle momsposter i den momsposttabel, der er inkluderet i filtrene i definitionsvinduet.;
                                 ENU=Close open VAT entries and transfers purchase and sales VAT amounts to the VAT settlement account. For every VAT posting group, the batch job finds all the VAT entries in the VAT Entry table that are included in the filters in the definition window.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 20;
                      Image=SettleOpenTransactions }
      { 31      ;1   ;Separator ;
                      CaptionML=[DAN=Opsëtning;
                                 ENU=Administration];
                      IsHeader=Yes }
      { 38      ;1   ;Action    ;
                      CaptionML=[DAN=Opsëtning &af Finans;
                                 ENU=General Le&dger Setup];
                      ToolTipML=[DAN=Definer dine generelle regnskabspolitikker, f.eks. den tilladte bogfõringsperiode, og hvordan betalinger behandles. Konfigurer dine standarddimensioner for finansielle analyser.;
                                 ENU=Define your general accounting policies, such as the allowed posting period and how payments are processed. Set up your default dimensions for financial analysis.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 118;
                      Image=Setup }
      { 40      ;1   ;Action    ;
                      CaptionML=[DAN=S&algsopsëtning;
                                 ENU=S&ales && Receivables Setup];
                      ToolTipML=[DAN=Definer dine generelle politikker for fakturering af salg og for returneringer, som f.eks. hvornÜr krediterings- og beholdningsadvarsler skal vises, og hvordan salgsrabatter skal bogfõres. Konfigurer dine nummerserier for oprettelse af debitorer og forskellige salgsbilag.;
                                 ENU=Define your general policies for sales invoicing and returns, such as when to show credit and stockout warnings and how to post sales discounts. Set up your number series for creating customers and different sales documents.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 459;
                      Image=Setup }
      { 41      ;1   ;Separator ;
                      CaptionML=[DAN=Oversigt;
                                 ENU=History];
                      IsHeader=Yes }
      { 42      ;1   ;Action    ;
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

    { 78  ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page9073;
                PartType=Page }

    { 1900724708;1;Group   }

    { 69  ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page762;
                PartType=Page }

    { 66  ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page762;
                Visible=false;
                PartType=Page }

    { 70  ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page770;
                PartType=Page }

    { 68  ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page770;
                Visible=false;
                PartType=Page }

    { 2   ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page760;
                Visible=false;
                PartType=Page }

    { 12  ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page681;
                PartType=Page }

    { 1907692008;2;Part   ;
                ApplicationArea=#Advanced;
                PagePartID=Page9150;
                Visible=false;
                PartType=Page }

    { 1902476008;2;Part   ;
                ApplicationArea=#Advanced;
                PagePartID=Page9151;
                Visible=false;
                PartType=Page }

    { 99  ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page675;
                Visible=false;
                PartType=Page }

    { 1905989608;2;Part   ;
                ApplicationArea=#Advanced;
                PagePartID=Page9152;
                Visible=false;
                PartType=Page }

    { 67  ;2   ;Part      ;
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

