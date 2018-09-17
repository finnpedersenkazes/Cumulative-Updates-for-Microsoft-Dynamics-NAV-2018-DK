OBJECT Page 9002 Acc. Payables Coordinator RC
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    CaptionML=[@@@="{Dependency=Match,""ProfileDescription_APCOORDINATOR""} ";
               DAN=Leverandõrkoordinator;
               ENU=Accounts Payable Coordinator];
    PageType=RoleCenter;
    ActionList=ACTIONS
    {
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 45      ;1   ;Action    ;
                      CaptionML=[DAN=K&reditor - stamoplysninger;
                                 ENU=&Vendor - List];
                      ToolTipML=[DAN=Vis listen over kreditorer.;
                                 ENU=View the list of your vendors.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 301;
                      Image=Report }
      { 46      ;1   ;Action    ;
                      CaptionML=[DAN=Kredi&tor - saldo til dato;
                                 ENU=Vendor - &Balance to date];
                      ToolTipML=[DAN=Se, udskriv eller gem en detaljeret balance til dato for udvalgte kreditorer.;
                                 ENU=View, print, or save a detail balance to date for selected vendors.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 321;
                      Image=Report }
      { 47      ;1   ;Action    ;
                      CaptionML=[DAN=Kreditor - forfaldsoversi&gt;
                                 ENU=Vendor - &Summary Aging];
                      ToolTipML=[DAN=Vis en oversigt over skyldige belõb til hver kreditor, opdelt i tre tidsperioder.;
                                 ENU=View a summary of the payables owed to each vendor, divided into three time periods.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 305;
                      Image=Report }
      { 51      ;1   ;Action    ;
                      CaptionML=[DAN=&Aldersfordelt gëld;
                                 ENU=Aged &Accounts Payable];
                      ToolTipML=[DAN=Vis en oversigt over, hvornÜr dine skyldige belõb til kreditorer skal betales eller rykkes for (opdelt i fire tidsperioder). Du skal angive den dato, som aldersfordelingen skal beregnes ud fra, og du skal angive den periode, som hver kolonne skal indeholde data for.;
                                 ENU=View an overview of when your payables to vendors are due or overdue (divided into four periods). You must specify the date you want aging calculated from and the length of the period that each column will contain data for.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 322;
                      Image=Report }
      { 48      ;1   ;Action    ;
                      CaptionML=[DAN=Kr&editor - kõbsoversigt;
                                 ENU=Vendor - &Purchase List];
                      ToolTipML=[DAN=Vis en liste over dine kõb i en periode, f.eks. for at rapportere kõbsaktiviteter til SKAT.;
                                 ENU=View a list of your purchases in a period, for example, to report purchase activity to customs and tax authorities.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 309;
                      Image=Report }
      { 49      ;1   ;Action    ;
                      CaptionML=[DAN=Af&ventende kreditorposter;
                                 ENU=Pa&yments on Hold];
                      ToolTipML=[DAN=Vis en liste over alle de kreditorposter, hvor feltet Afvent er markeret.;
                                 ENU=View a list of all vendor ledger entries on which the On Hold field is marked.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 319;
                      Image=Report }
      { 50      ;1   ;Action    ;
                      CaptionML=[DAN=Kõ&bsstatistik;
                                 ENU=P&urchase Statistics];
                      ToolTipML=[DAN=Vis en liste over belõb for kõb, fakturarabat og kontantrabat i $ for hver kreditor.;
                                 ENU=View a list of amounts for purchases, invoice discount and payment discount in $ for each vendor.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 312;
                      Image=Report }
      { 63      ;1   ;Separator  }
      { 64      ;1   ;Action    ;
                      CaptionML=[DAN=Kre&ditorbilagsnumre;
                                 ENU=Vendor &Document Nos.];
                      ToolTipML=[DAN=FÜ vist en liste over kreditorposter, sorteret efter dokumenttype og nummer. Rapporten viser bl.a. dokumenttype, bilagsnummer, bogfõringsdato samt kildespor for posten, navn og nummer pÜ kreditoren osv. Der vises en advarsel, hvis der er et hul i nummerserien, eller hvis bilagene ikke blev bogfõrt i nummerorden.;
                                 ENU=View a list of vendor ledger entries, sorted by document type and number. The report includes the document type, document number, posting date and source code of the entry, the name and number of the vendor, and so on. A warning appears when there is a gap in the number series or the documents were not posted in document-number order.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 328;
                      Image=Report }
      { 65      ;1   ;Action    ;
                      CaptionML=[DAN=K&õbsfakturanumre;
                                 ENU=Purchase &Invoice Nos.];
                      ToolTipML=[DAN=Vis eller angiv nummerserien for kõbsfakturaer.;
                                 ENU=View or set up the number series for purchase invoices.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 324;
                      Image=Report }
      { 66      ;1   ;Action    ;
                      CaptionML=[DAN=Kõbskred&itnotanumre;
                                 ENU=Purchase &Credit Memo Nos.];
                      ToolTipML=[DAN=Vis eller angiv nummerserien for kõbskreditnotaer.;
                                 ENU=View or set up the number series for purchase credit memos.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 325;
                      Image=Report }
      { 1900000011;0 ;ActionContainer;
                      ToolTipML=[DAN=Vis og behandl kreditorbetalinger, og godkend indgÜende bilag.;
                                 ENU=View and process vendor payments, and approve incoming documents.];
                      ActionContainerType=HomeItems }
      { 3       ;1   ;Action    ;
                      Name=Vendors;
                      CaptionML=[DAN=Kreditorer;
                                 ENU=Vendors];
                      ToolTipML=[DAN=FÜ vist eller rediger detaljerede oplysninger om de kreditorer, som du handler med. Fra det enkelte kreditorkort kan du fÜ adgang til relaterede oplysninger som f.eks. kõbsstatistik og igangvërende ordrer, og du kan definere specialpriser og linjerabatter, som kreditoren giver dig, nÜr bestemte betingelser er opfyldt.;
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
                      CaptionML=[DAN=Kõbsordrer;
                                 ENU=Purchase Orders];
                      ToolTipML=[DAN=Opret kõbsordrer for at afspejle de salgsbilag, som leverandõrer sender til dig. PÜ denne mÜde kan du registrere kõbsomkostninger og spore kreditorer. Bogfõringen af kõbsordrer opdaterer lagerniveauerne dynamisk, sÜ du kan minimere lageromkostningerne og levere bedre kundeservice. Kõbsordrer tillader delleverancer, modsat kõbsfakturaer, og muliggõr direkte levering fra kreditoren til debitoren. Kõbsordrer kan oprettes automatisk ud fra PDF- eller billedfiler fra dine kreditorer ved hjëlp af funktionen IndgÜende bilag.;
                                 ENU=Create purchase orders to mirror sales documents that vendors send to you. This enables you to record the cost of purchases and to track accounts payable. Posting purchase orders dynamically updates inventory levels so that you can minimize inventory costs and provide better customer service. Purchase orders allow partial receipts, unlike with purchase invoices, and enable drop shipment directly from your vendor to your customer. Purchase orders can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9307 }
      { 94      ;1   ;Action    ;
                      CaptionML=[DAN=Kõbsfakturaer;
                                 ENU=Purchase Invoices];
                      ToolTipML=[DAN=Opret kõbsfakturaer for at afspejle de salgsbilag, som leverandõrer sender til dig. PÜ denne mÜde kan du registrere kõbsomkostninger og spore kreditorer. Bogfõringen af kõbsfakturaer opdaterer lagerniveauerne dynamisk, sÜ du kan minimere lageromkostningerne og levere bedre kundeservice. Kõbsfakturaer kan oprettes automatisk ud fra PDF- eller billedfiler fra dine kreditorer ved hjëlp af funktionen IndgÜende bilag.;
                                 ENU=Create purchase invoices to mirror sales documents that vendors send to you. This enables you to record the cost of purchases and to track accounts payable. Posting purchase invoices dynamically updates inventory levels so that you can minimize inventory costs and provide better customer service. Purchase invoices can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9308 }
      { 96      ;1   ;Action    ;
                      CaptionML=[DAN=Kõbsreturvareordrer;
                                 ENU=Purchase Return Orders];
                      ToolTipML=[DAN=Opret kõbsreturvareordrer for at afspejle de salgsreturbilag, som leverandõrer sender til dig for forkerte eller beskadigede varer, som er blevet betalt og derefter returneret til kreditoren. Kõbsreturvareordrer gõr det muligt at returnere varer fra flere kõbsbilag med samme kõbsreturnering og understõtter lagerbilag for lagerekspeditionen. Kõbsreturvareordrer kan oprettes automatisk ud fra PDF- eller billedfiler fra dine kreditorer ved hjëlp af funktionen IndgÜende bilag. Bemërk: Hvis du endnu ikke har betalt for et fejlbehëftet kõb, kan du blot annullere den bogfõrte kõbsfaktura for automatisk at tilbagefõre den õkonomiske transaktion.;
                                 ENU=Create purchase return orders to mirror sales return documents that vendors send to you for incorrect or damaged items that you have paid for and then returned to the vendor. Purchase return orders enable you to ship back items from multiple purchase documents with one purchase return and support warehouse documents for the item handling. Purchase return orders can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature. Note: If you have not yet paid for an erroneous purchase, you can simply cancel the posted purchase invoice to automatically revert the financial transaction.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9311 }
      { 17      ;1   ;Action    ;
                      CaptionML=[DAN=Kõbskreditnotaer;
                                 ENU=Purchase Credit Memos];
                      ToolTipML=[DAN=Opret kõbskreditnotaer for at afspejle de salgskreditnotaer, som leverandõrer sender til dig for forkerte eller beskadigede varer, som er blevet betalt og derefter returneret til kreditoren. Hvis du har behov for mere kontrol over kõbsreturneringsprocessen, herunder lagerbilag for den fysiske lagerekspedition, skal du bruge kõbsreturvareordrer, hvor kõbskreditnotaerne integreres. Kõbskreditnotaer kan oprettes automatisk ud fra PDF- eller billedfiler fra dine kreditorer ved hjëlp af funktionen IndgÜende bilag. Bemërk: Hvis du endnu ikke har betalt for et fejlbehëftet kõb, kan du blot annullere den bogfõrte kõbsfaktura for automatisk at tilbagefõre den õkonomiske transaktion.;
                                 ENU=Create purchase credit memos to mirror sales credit memos that vendors send to you for incorrect or damaged items that you have paid for and then returned to the vendor. If you need more control of the purchase return process, such as warehouse documents for the physical handling, use purchase return orders, in which purchase credit memos are integrated. Purchase credit memos can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature. Note: If you have not yet paid for an erroneous purchase, you can simply cancel the posted purchase invoice to automatically revert the financial transaction.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9309 }
      { 95      ;1   ;Action    ;
                      CaptionML=[DAN=Bankkonti;
                                 ENU=Bank Accounts];
                      ToolTipML=[DAN=FÜ vist eller konfigurer detaljerede oplysninger om din bankkonto, f.eks. hvilken valuta der skal bruges, formatet pÜ de bankfiler, du importerer og eksporterer som elektroniske betalinger, samt nummereringen af checks.;
                                 ENU=View or set up detailed information about your bank account, such as which currency to use, the format of bank files that you import and export as electronic payments, and the numbering of checks.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 371;
                      Image=BankAccount }
      { 11      ;1   ;Action    ;
                      CaptionML=[DAN=Varer;
                                 ENU=Items];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om de produkter, du handler med. Varekortet kan vëre af typen lager eller tjeneste for at angive, om varen er en fysisk enhed eller en bestÜr af arbejdstimer. Her angiver du ogsÜ, om varerne pÜ lager eller i indgÜende ordrer automatisk reserveres til udgÜende bilag, og om der er oprettet ordresporingsbindinger mellem behov og forsyning for at afspejle planlëgningshandlinger.;
                                 ENU=View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 31;
                      Image=Item }
      { 22      ;1   ;Action    ;
                      Name=PurchaseJournals;
                      CaptionML=[DAN=Kõbskladder;
                                 ENU=Purchase Journals];
                      ToolTipML=[DAN=Bogfõr enhver transaktion, der er relateret til kõb, direkte til en kreditor-, bankkonto eller finanskonto i stedet at bruge dedikerede bilag. Du kan bogfõre alle typer finansielle kõbstransaktioner, herunder betalinger, refusioner og finansgebyrbelõb. Bemërk, at du ikke kan bogfõre varebeholdninger med en kõbskladde.;
                                 ENU=Post any purchase-related transaction directly to a vendor, bank, or general ledger account instead of using dedicated documents. You can post all types of financial purchase transactions, including payments, refunds, and finance charge amounts. Note that you cannot post item quantities with a purchase journal.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 251;
                      RunPageView=WHERE(Template Type=CONST(Purchases),
                                        Recurring=CONST(No)) }
      { 23      ;1   ;Action    ;
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
      { 24      ;1   ;Action    ;
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
      { 1900000012;0 ;ActionContainer;
                      ActionContainerType=ActivityButtons }
      { 97      ;1   ;ActionGroup;
                      CaptionML=[DAN=Bogfõrte dokumenter;
                                 ENU=Posted Documents];
                      ToolTipML=[DAN=Vis bogfõrte kõbsordrer, fakturaer og kreditnotaer, og analysÇr finansjournaler.;
                                 ENU=View posted purchase invoices and credit memos, and analyze G/L registers.];
                      Image=FiledPosted }
      { 102     ;2   ;Action    ;
                      CaptionML=[DAN=Bogf. kõbsmodtagelser;
                                 ENU=Posted Purchase Receipts];
                      ToolTipML=[DAN=èbn listen over bogfõrte kõbsmodtagelser.;
                                 ENU=Open the list of posted purchase receipts.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 145 }
      { 103     ;2   ;Action    ;
                      CaptionML=[DAN=Bogf. kõbsfakturaer;
                                 ENU=Posted Purchase Invoices];
                      ToolTipML=[DAN=èbn listen over bogfõrte kõbsfakturaer.;
                                 ENU=Open the list of posted purchase invoices.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 146 }
      { 105     ;2   ;Action    ;
                      CaptionML=[DAN=Bogfõrte kõbskreditnotaer;
                                 ENU=Posted Purchase Credit Memos];
                      ToolTipML=[DAN=èbn listen over bogfõrte kõbskreditnotaer.;
                                 ENU=Open the list of posted purchase credit memos.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 147 }
      { 9       ;2   ;Action    ;
                      CaptionML=[DAN=Bogfõrte returvareleverancer;
                                 ENU=Posted Return Shipments];
                      ToolTipML=[DAN=èbn listen over bogfõrte returvareleverancer.;
                                 ENU=Open the list of posted return shipments.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 6652 }
      { 108     ;2   ;Action    ;
                      CaptionML=[DAN=Finansjournaler;
                                 ENU=G/L Registers];
                      ToolTipML=[DAN=Vis bogfõrte finansposter.;
                                 ENU=View posted G/L entries.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 116;
                      Image=GLRegisters }
      { 1       ;0   ;ActionContainer;
                      ActionContainerType=NewDocumentItems }
      { 8       ;1   ;Action    ;
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
      { 7       ;1   ;Action    ;
                      CaptionML=[DAN=&Kõbsordre;
                                 ENU=&Purchase Order];
                      ToolTipML=[DAN=Kõb varer eller servicer fra en kreditor.;
                                 ENU=Purchase goods or services from a vendor.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 50;
                      Promoted=No;
                      Image=Document;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 4       ;1   ;Action    ;
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
      { 2       ;1   ;Action    ;
                      CaptionML=[DAN=&Kõbskreditnota;
                                 ENU=Purchase Credit &Memo];
                      ToolTipML=[DAN=Opret en ny kõbskreditnota for at tilbagefõre en bogfõrt kõbsfaktura.;
                                 ENU=Create a new purchase credit memo to revert a posted purchase invoice.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 52;
                      Promoted=No;
                      Image=CreditMemo;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 18      ;1   ;Separator ;
                      CaptionML=[DAN=Opgaver;
                                 ENU=Tasks];
                      IsHeader=Yes }
      { 16      ;1   ;Action    ;
                      CaptionML=[DAN=&Udbetalingskladde;
                                 ENU=Payment &Journal];
                      ToolTipML=[DAN=Vis eller rediger den betalingskladde, hvor du kan registrere betalinger til kreditorer.;
                                 ENU=View or edit the payment journal where you can register payments to vendors.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 256;
                      Image=PaymentJournal }
      { 26      ;1   ;Action    ;
                      CaptionML=[DAN=Kõ&bskladde;
                                 ENU=P&urchase Journal];
                      ToolTipML=[DAN="Bogfõr alle kõbstransaktioner for kreditoren. ";
                                 ENU="Post any purchase transaction for the vendor. "];
                      ApplicationArea=#Advanced;
                      RunObject=Page 254;
                      Image=Journals }
      { 31      ;1   ;Separator ;
                      CaptionML=[DAN=Opsëtning;
                                 ENU=Administration];
                      IsHeader=Yes }
      { 20      ;1   ;Action    ;
                      CaptionML=[DAN=Kõbsop&sëtning;
                                 ENU=Purchases && Payables &Setup];
                      ToolTipML=[DAN=Definer dine generelle politikker for fakturering af kõb og for returneringer, som f.eks. om kreditorfakturanumre skal angives, og hvordan kõbsrabatter skal bogfõres. Konfigurer dine nummerserier for oprettelse af kreditorer og forskellige kõbsbilag.;
                                 ENU=Define your general policies for purchase invoicing and returns, such as whether to require vendor invoice numbers and how to post purchase discounts. Set up your number series for creating vendors and different purchase documents.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 460;
                      Image=Setup }
      { 40      ;1   ;Separator ;
                      CaptionML=[DAN=Oversigt;
                                 ENU=History];
                      IsHeader=Yes }
      { 41      ;1   ;Action    ;
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

    { 1900601808;2;Part   ;
                ApplicationArea=#Advanced;
                PagePartID=Page9032;
                PartType=Page }

    { 1905989608;2;Part   ;
                ApplicationArea=#Advanced;
                PagePartID=Page9152;
                PartType=Page }

    { 1900724708;1;Group   }

    { 1902476008;2;Part   ;
                ApplicationArea=#Advanced;
                PagePartID=Page9151;
                PartType=Page }

    { 10  ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page681;
                PartType=Page }

    { 12  ;2   ;Part      ;
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

