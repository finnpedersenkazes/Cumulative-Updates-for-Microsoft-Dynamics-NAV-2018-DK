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
               DAN=Leverand�rkoordinator;
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
                      ToolTipML=[DAN=Vis en oversigt over skyldige bel�b til hver kreditor, opdelt i tre tidsperioder.;
                                 ENU=View a summary of the payables owed to each vendor, divided into three time periods.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 305;
                      Image=Report }
      { 51      ;1   ;Action    ;
                      CaptionML=[DAN=&Aldersfordelt g�ld;
                                 ENU=Aged &Accounts Payable];
                      ToolTipML=[DAN=Vis en oversigt over, hvorn�r dine skyldige bel�b til kreditorer skal betales eller rykkes for (opdelt i fire tidsperioder). Du skal angive den dato, som aldersfordelingen skal beregnes ud fra, og du skal angive den periode, som hver kolonne skal indeholde data for.;
                                 ENU=View an overview of when your payables to vendors are due or overdue (divided into four periods). You must specify the date you want aging calculated from and the length of the period that each column will contain data for.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 322;
                      Image=Report }
      { 48      ;1   ;Action    ;
                      CaptionML=[DAN=Kr&editor - k�bsoversigt;
                                 ENU=Vendor - &Purchase List];
                      ToolTipML=[DAN=Vis en liste over dine k�b i en periode, f.eks. for at rapportere k�bsaktiviteter til SKAT.;
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
                      CaptionML=[DAN=K�&bsstatistik;
                                 ENU=P&urchase Statistics];
                      ToolTipML=[DAN=Vis en liste over bel�b for k�b, fakturarabat og kontantrabat i $ for hver kreditor.;
                                 ENU=View a list of amounts for purchases, invoice discount and payment discount in $ for each vendor.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 312;
                      Image=Report }
      { 63      ;1   ;Separator  }
      { 64      ;1   ;Action    ;
                      CaptionML=[DAN=Kre&ditorbilagsnumre;
                                 ENU=Vendor &Document Nos.];
                      ToolTipML=[DAN=F� vist en liste over kreditorposter, sorteret efter dokumenttype og nummer. Rapporten viser bl.a. dokumenttype, bilagsnummer, bogf�ringsdato samt kildespor for posten, navn og nummer p� kreditoren osv. Der vises en advarsel, hvis der er et hul i nummerserien, eller hvis bilagene ikke blev bogf�rt i nummerorden.;
                                 ENU=View a list of vendor ledger entries, sorted by document type and number. The report includes the document type, document number, posting date and source code of the entry, the name and number of the vendor, and so on. A warning appears when there is a gap in the number series or the documents were not posted in document-number order.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 328;
                      Image=Report }
      { 65      ;1   ;Action    ;
                      CaptionML=[DAN=K&�bsfakturanumre;
                                 ENU=Purchase &Invoice Nos.];
                      ToolTipML=[DAN=Vis eller angiv nummerserien for k�bsfakturaer.;
                                 ENU=View or set up the number series for purchase invoices.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 324;
                      Image=Report }
      { 66      ;1   ;Action    ;
                      CaptionML=[DAN=K�bskred&itnotanumre;
                                 ENU=Purchase &Credit Memo Nos.];
                      ToolTipML=[DAN=Vis eller angiv nummerserien for k�bskreditnotaer.;
                                 ENU=View or set up the number series for purchase credit memos.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 325;
                      Image=Report }
      { 1900000011;0 ;ActionContainer;
                      ToolTipML=[DAN=Vis og behandl kreditorbetalinger, og godkend indg�ende bilag.;
                                 ENU=View and process vendor payments, and approve incoming documents.];
                      ActionContainerType=HomeItems }
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
      { 6       ;1   ;Action    ;
                      CaptionML=[DAN=K�bsordrer;
                                 ENU=Purchase Orders];
                      ToolTipML=[DAN=Opret k�bsordrer for at afspejle de salgsbilag, som leverand�rer sender til dig. P� denne m�de kan du registrere k�bsomkostninger og spore kreditorer. Bogf�ringen af k�bsordrer opdaterer lagerniveauerne dynamisk, s� du kan minimere lageromkostningerne og levere bedre kundeservice. K�bsordrer tillader delleverancer, modsat k�bsfakturaer, og muligg�r direkte levering fra kreditoren til debitoren. K�bsordrer kan oprettes automatisk ud fra PDF- eller billedfiler fra dine kreditorer ved hj�lp af funktionen Indg�ende bilag.;
                                 ENU=Create purchase orders to mirror sales documents that vendors send to you. This enables you to record the cost of purchases and to track accounts payable. Posting purchase orders dynamically updates inventory levels so that you can minimize inventory costs and provide better customer service. Purchase orders allow partial receipts, unlike with purchase invoices, and enable drop shipment directly from your vendor to your customer. Purchase orders can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9307 }
      { 94      ;1   ;Action    ;
                      CaptionML=[DAN=K�bsfakturaer;
                                 ENU=Purchase Invoices];
                      ToolTipML=[DAN=Opret k�bsfakturaer for at afspejle de salgsbilag, som leverand�rer sender til dig. P� denne m�de kan du registrere k�bsomkostninger og spore kreditorer. Bogf�ringen af k�bsfakturaer opdaterer lagerniveauerne dynamisk, s� du kan minimere lageromkostningerne og levere bedre kundeservice. K�bsfakturaer kan oprettes automatisk ud fra PDF- eller billedfiler fra dine kreditorer ved hj�lp af funktionen Indg�ende bilag.;
                                 ENU=Create purchase invoices to mirror sales documents that vendors send to you. This enables you to record the cost of purchases and to track accounts payable. Posting purchase invoices dynamically updates inventory levels so that you can minimize inventory costs and provide better customer service. Purchase invoices can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9308 }
      { 96      ;1   ;Action    ;
                      CaptionML=[DAN=K�bsreturvareordrer;
                                 ENU=Purchase Return Orders];
                      ToolTipML=[DAN=Opret k�bsreturvareordrer for at afspejle de salgsreturbilag, som leverand�rer sender til dig for forkerte eller beskadigede varer, som er blevet betalt og derefter returneret til kreditoren. K�bsreturvareordrer g�r det muligt at returnere varer fra flere k�bsbilag med samme k�bsreturnering og underst�tter lagerbilag for lagerekspeditionen. K�bsreturvareordrer kan oprettes automatisk ud fra PDF- eller billedfiler fra dine kreditorer ved hj�lp af funktionen Indg�ende bilag. Bem�rk: Hvis du endnu ikke har betalt for et fejlbeh�ftet k�b, kan du blot annullere den bogf�rte k�bsfaktura for automatisk at tilbagef�re den �konomiske transaktion.;
                                 ENU=Create purchase return orders to mirror sales return documents that vendors send to you for incorrect or damaged items that you have paid for and then returned to the vendor. Purchase return orders enable you to ship back items from multiple purchase documents with one purchase return and support warehouse documents for the item handling. Purchase return orders can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature. Note: If you have not yet paid for an erroneous purchase, you can simply cancel the posted purchase invoice to automatically revert the financial transaction.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9311 }
      { 17      ;1   ;Action    ;
                      CaptionML=[DAN=K�bskreditnotaer;
                                 ENU=Purchase Credit Memos];
                      ToolTipML=[DAN=Opret k�bskreditnotaer for at afspejle de salgskreditnotaer, som leverand�rer sender til dig for forkerte eller beskadigede varer, som er blevet betalt og derefter returneret til kreditoren. Hvis du har behov for mere kontrol over k�bsreturneringsprocessen, herunder lagerbilag for den fysiske lagerekspedition, skal du bruge k�bsreturvareordrer, hvor k�bskreditnotaerne integreres. K�bskreditnotaer kan oprettes automatisk ud fra PDF- eller billedfiler fra dine kreditorer ved hj�lp af funktionen Indg�ende bilag. Bem�rk: Hvis du endnu ikke har betalt for et fejlbeh�ftet k�b, kan du blot annullere den bogf�rte k�bsfaktura for automatisk at tilbagef�re den �konomiske transaktion.;
                                 ENU=Create purchase credit memos to mirror sales credit memos that vendors send to you for incorrect or damaged items that you have paid for and then returned to the vendor. If you need more control of the purchase return process, such as warehouse documents for the physical handling, use purchase return orders, in which purchase credit memos are integrated. Purchase credit memos can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature. Note: If you have not yet paid for an erroneous purchase, you can simply cancel the posted purchase invoice to automatically revert the financial transaction.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9309 }
      { 95      ;1   ;Action    ;
                      CaptionML=[DAN=Bankkonti;
                                 ENU=Bank Accounts];
                      ToolTipML=[DAN=F� vist eller konfigurer detaljerede oplysninger om din bankkonto, f.eks. hvilken valuta der skal bruges, formatet p� de bankfiler, du importerer og eksporterer som elektroniske betalinger, samt nummereringen af checks.;
                                 ENU=View or set up detailed information about your bank account, such as which currency to use, the format of bank files that you import and export as electronic payments, and the numbering of checks.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 371;
                      Image=BankAccount }
      { 11      ;1   ;Action    ;
                      CaptionML=[DAN=Varer;
                                 ENU=Items];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om de produkter, du handler med. Varekortet kan v�re af typen lager eller tjeneste for at angive, om varen er en fysisk enhed eller en best�r af arbejdstimer. Her angiver du ogs�, om varerne p� lager eller i indg�ende ordrer automatisk reserveres til udg�ende bilag, og om der er oprettet ordresporingsbindinger mellem behov og forsyning for at afspejle planl�gningshandlinger.;
                                 ENU=View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 31;
                      Image=Item }
      { 22      ;1   ;Action    ;
                      Name=PurchaseJournals;
                      CaptionML=[DAN=K�bskladder;
                                 ENU=Purchase Journals];
                      ToolTipML=[DAN=Bogf�r enhver transaktion, der er relateret til k�b, direkte til en kreditor-, bankkonto eller finanskonto i stedet at bruge dedikerede bilag. Du kan bogf�re alle typer finansielle k�bstransaktioner, herunder betalinger, refusioner og finansgebyrbel�b. Bem�rk, at du ikke kan bogf�re varebeholdninger med en k�bskladde.;
                                 ENU=Post any purchase-related transaction directly to a vendor, bank, or general ledger account instead of using dedicated documents. You can post all types of financial purchase transactions, including payments, refunds, and finance charge amounts. Note that you cannot post item quantities with a purchase journal.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 251;
                      RunPageView=WHERE(Template Type=CONST(Purchases),
                                        Recurring=CONST(No)) }
      { 23      ;1   ;Action    ;
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
      { 24      ;1   ;Action    ;
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
      { 1900000012;0 ;ActionContainer;
                      ActionContainerType=ActivityButtons }
      { 97      ;1   ;ActionGroup;
                      CaptionML=[DAN=Bogf�rte dokumenter;
                                 ENU=Posted Documents];
                      ToolTipML=[DAN=Vis bogf�rte k�bsordrer, fakturaer og kreditnotaer, og analys�r finansjournaler.;
                                 ENU=View posted purchase invoices and credit memos, and analyze G/L registers.];
                      Image=FiledPosted }
      { 102     ;2   ;Action    ;
                      CaptionML=[DAN=Bogf. k�bsmodtagelser;
                                 ENU=Posted Purchase Receipts];
                      ToolTipML=[DAN=�bn listen over bogf�rte k�bsmodtagelser.;
                                 ENU=Open the list of posted purchase receipts.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 145 }
      { 103     ;2   ;Action    ;
                      CaptionML=[DAN=Bogf. k�bsfakturaer;
                                 ENU=Posted Purchase Invoices];
                      ToolTipML=[DAN=�bn listen over bogf�rte k�bsfakturaer.;
                                 ENU=Open the list of posted purchase invoices.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 146 }
      { 105     ;2   ;Action    ;
                      CaptionML=[DAN=Bogf�rte k�bskreditnotaer;
                                 ENU=Posted Purchase Credit Memos];
                      ToolTipML=[DAN=�bn listen over bogf�rte k�bskreditnotaer.;
                                 ENU=Open the list of posted purchase credit memos.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 147 }
      { 9       ;2   ;Action    ;
                      CaptionML=[DAN=Bogf�rte returvareleverancer;
                                 ENU=Posted Return Shipments];
                      ToolTipML=[DAN=�bn listen over bogf�rte returvareleverancer.;
                                 ENU=Open the list of posted return shipments.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 6652 }
      { 108     ;2   ;Action    ;
                      CaptionML=[DAN=Finansjournaler;
                                 ENU=G/L Registers];
                      ToolTipML=[DAN=Vis bogf�rte finansposter.;
                                 ENU=View posted G/L entries.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 116;
                      Image=GLRegisters }
      { 1       ;0   ;ActionContainer;
                      ActionContainerType=NewDocumentItems }
      { 8       ;1   ;Action    ;
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
      { 7       ;1   ;Action    ;
                      CaptionML=[DAN=&K�bsordre;
                                 ENU=&Purchase Order];
                      ToolTipML=[DAN=K�b varer eller servicer fra en kreditor.;
                                 ENU=Purchase goods or services from a vendor.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 50;
                      Promoted=No;
                      Image=Document;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 4       ;1   ;Action    ;
                      CaptionML=[DAN=&K�bsfaktura;
                                 ENU=Purchase &Invoice];
                      ToolTipML=[DAN=Opret en ny k�bsfaktura.;
                                 ENU=Create a new purchase invoice.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 51;
                      Promoted=No;
                      Image=NewPurchaseInvoice;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 2       ;1   ;Action    ;
                      CaptionML=[DAN=&K�bskreditnota;
                                 ENU=Purchase Credit &Memo];
                      ToolTipML=[DAN=Opret en ny k�bskreditnota for at tilbagef�re en bogf�rt k�bsfaktura.;
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
                      CaptionML=[DAN=K�&bskladde;
                                 ENU=P&urchase Journal];
                      ToolTipML=[DAN="Bogf�r alle k�bstransaktioner for kreditoren. ";
                                 ENU="Post any purchase transaction for the vendor. "];
                      ApplicationArea=#Advanced;
                      RunObject=Page 254;
                      Image=Journals }
      { 31      ;1   ;Separator ;
                      CaptionML=[DAN=Ops�tning;
                                 ENU=Administration];
                      IsHeader=Yes }
      { 20      ;1   ;Action    ;
                      CaptionML=[DAN=K�bsop&s�tning;
                                 ENU=Purchases && Payables &Setup];
                      ToolTipML=[DAN=Definer dine generelle politikker for fakturering af k�b og for returneringer, som f.eks. om kreditorfakturanumre skal angives, og hvordan k�bsrabatter skal bogf�res. Konfigurer dine nummerserier for oprettelse af kreditorer og forskellige k�bsbilag.;
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

