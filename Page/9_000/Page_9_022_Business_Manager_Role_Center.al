OBJECT Page 9022 Business Manager Role Center
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846,NAVDK11.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[@@@="{Dependency=Match,""ProfileDescription_SMALLBUSINESS""}";
               DAN=Virksomhedsleder;
               ENU=Business Manager];
    PageType=RoleCenter;
    ActionList=ACTIONS
    {
      { 1       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 4       ;1   ;ActionGroup;
                      CaptionML=[DAN=Ny;
                                 ENU=New] }
      { 52      ;2   ;Action    ;
                      CaptionML=[DAN=Salgstilbud;
                                 ENU=Sales Quote];
                      ToolTipML=[DAN=Tilbyd varer eller servicer til en debitor.;
                                 ENU=Offer items or services to a customer.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 41;
                      Image=NewSalesQuote;
                      RunPageMode=Create }
      { 85      ;2   ;Action    ;
                      CaptionML=[DAN=Salgsordre;
                                 ENU=Sales Order];
                      ToolTipML=[DAN=Opret en ny salgsordre for varer eller servicer.;
                                 ENU=Create a new sales order for items or services.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 42;
                      Image=NewOrder;
                      RunPageMode=Create }
      { 2       ;2   ;Action    ;
                      CaptionML=[DAN=Salgsfaktura;
                                 ENU=Sales Invoice];
                      ToolTipML=[DAN=Opret en ny faktura for salget af varer eller servicer. Fakturam�ngder kan ikke bogf�res delvist.;
                                 ENU=Create a new invoice for the sales of items or services. Invoice quantities cannot be posted partially.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 43;
                      Image=NewSalesInvoice;
                      RunPageMode=Create }
      { 5       ;2   ;Action    ;
                      Name=<Page Purchase Order>;
                      CaptionML=[DAN=K�bsordre;
                                 ENU=Purchase Order];
                      ToolTipML=[DAN=Opret en ny k�bsordre.;
                                 ENU=Create a new purchase order.];
                      ApplicationArea=#Suite;
                      RunObject=Page 50;
                      Image=NewOrder;
                      RunPageMode=Create }
      { 32      ;2   ;Action    ;
                      CaptionML=[DAN=K�bsfaktura;
                                 ENU=Purchase Invoice];
                      ToolTipML=[DAN=Opret k�bsfakturaer for at afspejle de salgsbilag, som leverand�rer sender til dig. P� denne m�de kan du registrere k�bsomkostninger og spore kreditorer. Bogf�ringen af k�bsfakturaer opdaterer lagerniveauerne dynamisk, s� du kan minimere lageromkostningerne og levere bedre kundeservice. K�bsfakturaer kan oprettes automatisk ud fra PDF- eller billedfiler fra dine kreditorer ved hj�lp af funktionen Indg�ende bilag.;
                                 ENU=Create purchase invoices to mirror sales documents that vendors send to you. This enables you to record the cost of purchases and to track accounts payable. Posting purchase invoices dynamically updates inventory levels so that you can minimize inventory costs and provide better customer service. Purchase invoices can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 51;
                      Image=NewPurchaseInvoice;
                      RunPageMode=Create }
      { 100     ;2   ;Action    ;
                      CaptionML=[DAN=Debitor;
                                 ENU=Customer];
                      ToolTipML=[DAN=Registrer en ny debitor.;
                                 ENU=Register a new customer.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 21;
                      Image=Customer;
                      RunPageMode=Create }
      { 101     ;2   ;Action    ;
                      CaptionML=[DAN=Kreditor;
                                 ENU=Vendor];
                      ToolTipML=[DAN=Registrer en ny kreditor.;
                                 ENU=Register a new vendor.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 26;
                      Image=Vendor;
                      RunPageMode=Create }
      { 89      ;1   ;ActionGroup;
                      CaptionML=[DAN=Betalinger;
                                 ENU=Payments] }
      { 88      ;2   ;ActionGroup;
                      CaptionML=[DAN=Behandl betalinger;
                                 ENU=Process Payments];
                      Image=Reconcile }
      { 87      ;3   ;Action    ;
                      Name=Payment Reconciliation Journals;
                      CaptionML=[DAN=Afstem importerede betalinger;
                                 ENU=Reconcile Imported Payments];
                      ToolTipML=[DAN=Afstem din bankkonto ved at importere transaktioner. Anvend dem, enten automatisk eller manuelt, p� �bne debitorposter, �bne kreditorposter eller �bne bankkontoposter.;
                                 ENU=Reconcile your bank account by importing transactions and applying them, automatically or manually, to open customer ledger entries, open vendor ledger entries, or open bank account ledger entries.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 9022;
                      Image=ApplyEntries }
      { 90      ;3   ;Action    ;
                      Name=Import Bank Transactions;
                      CaptionML=[DAN=Import�r banktransaktioner...;
                                 ENU=Import Bank Transactions...];
                      ToolTipML=[DAN=Hvis du vil p�begynde afstemningen af nye betalinger, skal du importere et bankfeed eller en elektronisk fil, der indeholder de relaterede banktransaktioner.;
                                 ENU=To start the process of reconciling new payments, import a bank feed or electronic file containing the related bank transactions.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 9023;
                      Image=Import }
      { 59      ;3   ;Action    ;
                      CaptionML=[DAN=Registrer debitorbetalinger;
                                 ENU=Register Customer Payments];
                      ToolTipML=[DAN=Du kan behandle debitorbetalinger ved at afstemme bel�b, der er modtaget p� bankkontoen, med de relaterede ubetalte salgsfakturaer og derefter bogf�re betalingerne.;
                                 ENU=Process you customers' payments by matching amounts received on your bank account with the related unpaid sales invoices, and then post the payments.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 981;
                      Image=Payment }
      { 97      ;1   ;ActionGroup;
                      CaptionML=[DAN=Rapporter;
                                 ENU=Reports] }
      { 83      ;2   ;ActionGroup;
                      CaptionML=[DAN=Regnskabsopg�relser;
                                 ENU=Financial Statements];
                      Image=ReferenceData }
      { 82      ;3   ;Action    ;
                      CaptionML=[DAN=Balance;
                                 ENU=Balance Sheet];
                      ToolTipML=[DAN=F� vist din virksomheds aktiver, passiver og egenkapital.;
                                 ENU=View your company's assets, liabilities, and equity.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 572;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 81      ;3   ;Action    ;
                      CaptionML=[DAN=Resultatopg�relse;
                                 ENU=Income Statement];
                      ToolTipML=[DAN=F� vist din virksomheds indt�gter og udgifter.;
                                 ENU=View your company's income and expenses.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 573;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 80      ;3   ;Action    ;
                      CaptionML=[DAN=Opg�relser over pengestr�m;
                                 ENU=Statement of Cash Flows];
                      ToolTipML=[DAN=Vis en regnskabsopg�relse, der viser, hvordan �ndringer i balancekonti og indt�gter p�virker virksomhedens kontantbeholdning, som vises for henholdsvis drifts-, investerings- og finansieringsaktiviteter.;
                                 ENU=View a financial statement that shows how changes in balance sheet accounts and income affect the company's cash holdings, displayed for operating, investing, and financing activities respectively.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 574;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 78      ;3   ;Action    ;
                      CaptionML=[DAN=Opg�relse af overf�rt resultat;
                                 ENU=Statement of Retained Earnings];
                      ToolTipML=[DAN=Vis en rapport, der viser din virksomheds �ndringer i overf�rte resultater for en bestemt periode ved at afstemme de overf�rte resultater i begyndelsen og slutningen af perioden ved hj�lp af oplysninger s�som �rets resultat fra andre �rsregnskaber.;
                                 ENU=View a report that shows your company's changes in retained earnings for a specified period by reconciling the beginning and ending retained earnings for the period, using information such as net income from the other financial statements.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 575;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 122     ;2   ;ActionGroup;
                      CaptionML=[DAN=Excel-rapporter;
                                 ENU=Excel Reports];
                      Image=Excel }
      { 108     ;3   ;Action    ;
                      Name=ExcelTemplatesBalanceSheet;
                      CaptionML=[DAN=Balance;
                                 ENU=Balance Sheet];
                      ToolTipML=[DAN=F� vist din virksomheds aktiver, passiver og egenkapital.;
                                 ENU=View your company's assets, liabilities, and equity.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 576;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 116     ;3   ;Action    ;
                      Name=ExcelTemplateIncomeStmt;
                      CaptionML=[DAN=Resultatopg�relse;
                                 ENU=Income Statement];
                      ToolTipML=[DAN=F� vist din virksomheds indt�gter og udgifter.;
                                 ENU=View your company's income and expenses.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 577;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 117     ;3   ;Action    ;
                      Name=ExcelTemplateCashFlowStmt;
                      CaptionML=[DAN=Pengestr�msopg�relse;
                                 ENU=Cash Flow Statement];
                      ToolTipML=[DAN=�bn et regneark, der viser, hvordan �ndringer i balancekonti og indt�gter p�virker virksomhedens kontantbeholdning.;
                                 ENU=Open a spreadsheet that shows how changes in balance sheet accounts and income affect the company's cash holdings.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 578;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 118     ;3   ;Action    ;
                      Name=ExcelTemplateRetainedEarn;
                      CaptionML=[DAN=Opg�relse over overf�rt resultat;
                                 ENU=Retained Earnings Statement];
                      ToolTipML=[DAN=�bn et regneark, der viser �ndringer i overf�rte resultater, der er baseret p� �rets resultat fra andre �rsregnskaber.;
                                 ENU=Open a spreadsheet that shows changes in retained earnings based on net income from the other financial statements.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 579;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 119     ;3   ;Action    ;
                      Name=ExcelTemplateTrialBalance;
                      CaptionML=[DAN=R�balance;
                                 ENU=Trial Balance];
                      ToolTipML=[DAN=�bn et regneark, der viser en oversigt over r�balance efter konto.;
                                 ENU=Open a spreadsheet that shows a summary trial balance by account.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 580;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 120     ;3   ;Action    ;
                      Name=ExcelTemplateAgedAccPay;
                      CaptionML=[DAN=Aldersfordelt g�ld;
                                 ENU=Aged Accounts Payable];
                      ToolTipML=[DAN=�bn et regneark, der viser en oversigt over aldersfordelte restsaldi for hver kreditor efter periode.;
                                 ENU=Open a spreadsheet that shows a list of aged remaining balances for each vendor by period.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 581;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 121     ;3   ;Action    ;
                      Name=ExcelTemplateAgedAccRec;
                      CaptionML=[DAN=Aldersfordelte tilgodehavender;
                                 ENU=Aged Accounts Receivable];
                      ToolTipML=[DAN=�bn et regneark, der viser, hvorn�r debitorbetalinger forfalder eller er forfaldne efter periode.;
                                 ENU=Open a spreadsheet that shows when customer payments are due or overdue by period.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 582;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 21      ;1   ;ActionGroup;
                      CaptionML=[DAN=Ops�tning;
                                 ENU=Setup];
                      Image=Setup }
      { 54      ;2   ;Action    ;
                      CaptionML=[DAN=Virksomhedsindstillinger;
                                 ENU=Company Settings];
                      ToolTipML=[DAN=Angiv firmanavnet, adressen og bankoplysningerne, der skal inds�ttes i dine forretningsdokumenter.;
                                 ENU=Enter the company name, address, and bank information that will be inserted on your business documents.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 1;
                      Image=CompanyInformation }
      { 27      ;2   ;Action    ;
                      CaptionML=[DAN=Assisteret ops�tning;
                                 ENU=Assisted Setup];
                      ToolTipML=[DAN=Konfigurer kernefunktionalitet s�som moms, og send dokumenter som mails og godkendelsesworkflow ved at k�re igennem et par sider, der vejleder dig i oplysningerne.;
                                 ENU=Set up core functionality such as sales tax, sending documents as email, and approval workflow by running through a few pages that guide you through the information.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 1801;
                      Image=QuestionaireSetup }
      { 49      ;2   ;ActionGroup;
                      CaptionML=[DAN=Tjenester og udvidelser;
                                 ENU=Services & Extensions];
                      Image=ServiceSetup }
      { 75      ;3   ;Action    ;
                      CaptionML=[DAN=Udvidelser;
                                 ENU=Extensions];
                      ToolTipML=[DAN=Install�r udvidelser for at optimere systemets funktionalitet.;
                                 ENU=Install Extensions for greater functionality of the system.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 2500;
                      Image=NonStockItemSetup }
      { 12      ;3   ;Action    ;
                      CaptionML=[DAN=Serviceforbindelser;
                                 ENU=Service Connections];
                      ToolTipML=[DAN=Aktiv�r og konfigurer eksterne tjenester, f.eks. opdateringer af valutakurser, Microsoft Social Engagement og elektronisk bankintegration.;
                                 ENU=Enable and configure external services, such as exchange rate updates, Microsoft Social Engagement, and electronic bank integration.];
                      ApplicationArea=#Service;
                      RunObject=Page 1279;
                      Image=ServiceTasks }
      { 8       ;0   ;ActionContainer;
                      ToolTipML=[DAN=Administrer din virksomhed. Se n�gletal, balance og dine foretrukne debitorer.;
                                 ENU=Manage your business. See KPIs, trial balance, and favorite customers.];
                      ActionContainerType=HomeItems }
      { 14      ;1   ;Action    ;
                      CaptionML=[DAN=Kunder (Debitorer);
                                 ENU=Customers];
                      ToolTipML=[DAN=F� vist eller rediger detaljerede oplysninger om de debitorer, som du handler med. Fra det enkelte debitorkort kan du f� adgang til relaterede oplysninger som f.eks. salgsstatistik og igangv�rende ordrer, og du kan definere specialpriser og linjerabatter, som debitoren f�r, n�r bestemte betingelser er opfyldt.;
                                 ENU=View or edit detailed information for the customers that you trade with. From each customer card, you can open related information, such as sales statistics and ongoing orders, and you can define special prices and line discounts that you grant if certain conditions are met.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 22 }
      { 6       ;1   ;Action    ;
                      CaptionML=[DAN=Leverand�rer (Kreditorer);
                                 ENU=Vendors];
                      ToolTipML=[DAN=F� vist eller rediger detaljerede oplysninger om de kreditorer, som du handler med. Fra det enkelte kreditorkort kan du f� adgang til relaterede oplysninger som f.eks. k�bsstatistik og igangv�rende ordrer, og du kan definere specialpriser og linjerabatter, som kreditoren giver dig, n�r bestemte betingelser er opfyldt.;
                                 ENU=View or edit detailed information for the vendors that you trade with. From each vendor card, you can open related information, such as purchase statistics and ongoing orders, and you can define special prices and line discounts that the vendor grants you if certain conditions are met.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 27 }
      { 15      ;1   ;Action    ;
                      CaptionML=[DAN=Varer;
                                 ENU=Items];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om de produkter, du handler med. Varekortet kan v�re af typen lager eller tjeneste for at angive, om varen er en fysisk enhed eller en best�r af arbejdstimer. Her angiver du ogs�, om varerne p� lager eller i indg�ende ordrer automatisk reserveres til udg�ende bilag, og om der er oprettet ordresporingsbindinger mellem behov og forsyning for at afspejle planl�gningshandlinger.;
                                 ENU=View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 31 }
      { 115     ;1   ;Action    ;
                      CaptionML=[DAN=Bankkonti;
                                 ENU=Bank Accounts];
                      ToolTipML=[DAN=F� vist eller konfigurer detaljerede oplysninger om din bankkonto, f.eks. hvilken valuta der skal bruges, formatet p� de bankfiler, du importerer og eksporterer som elektroniske betalinger, samt nummereringen af checks.;
                                 ENU=View or set up detailed information about your bank account, such as which currency to use, the format of bank files that you import and export as electronic payments, and the numbering of checks.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 371;
                      Image=BankAccount }
      { 114     ;1   ;Action    ;
                      CaptionML=[DAN=Kontoplan;
                                 ENU=Chart of Accounts];
                      ToolTipML=[DAN=F� vist eller arranger de finanskonti, der opbevarer dine �konomiske data. Alle v�rdier fra forretningstransaktioner eller interne reguleringer ender p� de angivne finanskonti. Dynamics NAV indeholder en standardkontoplan, som underst�tter virksomheder i dit land, men du kan �ndre standardkontiene og tilf�je nye.;
                                 ENU=View or organize the general ledger accounts that store your financial data. All values from business transactions or internal adjustments end up in designated G/L accounts. Dynamics NAV includes a standard chart of accounts that is ready to support businesses in your country, but you can change the default accounts and add new ones.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 16 }
      { 38      ;    ;ActionContainer;
                      ActionContainerType=ActivityButtons }
      { 39      ;1   ;ActionGroup;
                      CaptionML=[DAN=Finans;
                                 ENU=Finance];
                      ToolTipML=[DAN=Opkr�v og foretag betalinger, udarbejd udtog, og afstem bankkonti.;
                                 ENU=Collect and make payments, prepare statements, and reconcile bank accounts.];
                      Image=Journals }
      { 11      ;2   ;Action    ;
                      Name=GeneralJournals;
                      CaptionML=[DAN=Finanskladder;
                                 ENU=General Journals];
                      ToolTipML=[DAN=Bogf�r �konomiske transaktioner direkte til finanskonti og andre konti som f.eks. bank-, debitor-, kreditor- og medarbejderkonti. Bogf�ring med en finanskladde opretter altid poster p� finanskontiene. Dette g�lder ogs�, n�r du eksempelvis bogf�rer en kladdelinje til en debitorkonto, fordi der er bogf�rt en post til finansregnskabets konto for tilgodehavender via en bogf�ringsgruppe.;
                                 ENU=Post financial transactions directly to general ledger accounts and other accounts, such as bank, customer, vendor, and employee accounts. Posting with a general journal always creates entries on general ledger accounts. This is true even when, for example, you post a journal line to a customer account, because an entry is posted to a general ledger receivables account through a posting group.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 251;
                      RunPageView=WHERE(Template Type=CONST(General),
                                        Recurring=CONST(No));
                      Image=Journal }
      { 3       ;2   ;Action    ;
                      CaptionML=[DAN=Kontoplan;
                                 ENU=Chart of Accounts];
                      ToolTipML=[DAN=F� vist eller arranger de finanskonti, der opbevarer dine �konomiske data. Alle v�rdier fra forretningstransaktioner eller interne reguleringer ender p� de angivne finanskonti. Dynamics NAV indeholder en standardkontoplan, som underst�tter virksomheder i dit land, men du kan �ndre standardkontiene og tilf�je nye.;
                                 ENU=View or organize the general ledger accounts that store your financial data. All values from business transactions or internal adjustments end up in designated G/L accounts. Dynamics NAV includes a standard chart of accounts that is ready to support businesses in your country, but you can change the default accounts and add new ones.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 16 }
      { 74      ;2   ;Action    ;
                      CaptionML=[DAN=Kontoskemaer;
                                 ENU=Account Schedules];
                      ToolTipML=[DAN=F� indsigt i de finansielle data i din kontoplan. Kontoskemaer analyserer tal i finanskonti og sammenligner finansposter med finansbudgetposter. Eksempelvis kan du f� vist finansposterne som en procentsats af budgetposterne. Kontoskemaer indeholder data om de vigtigste �rsregnskaber og visninger, f.eks. pengestr�msdiagrammet.;
                                 ENU=Get insight into the financial data stored in your chart of accounts. Account schedules analyze figures in G/L accounts, and compare general ledger entries with general ledger budget entries. For example, you can view the general ledger entries as percentages of the budget entries. Account schedules provide the data for core financial statements and views, such as the Cash Flow chart.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 103 }
      { 84      ;2   ;Action    ;
                      CaptionML=[DAN=Finanskontokategorier;
                                 ENU=G/L Account Categories];
                      ToolTipML=[DAN=Tilpas strukturen for dit �rsregnskab ved at knytte finanskontiene til kontokategorier. Du kan oprette kategorigrupper ved at placere underkategorier under dem. Hver gruppe viser en totalsaldo. N�r du v�lger handlingen Gener�r kontoskemaer, opdateres kontoskemaerne for de underliggende finansrapporter. N�ste gang du k�rer en af disse rapporter som f.eks. resultatopg�relsen, tilf�jes der ny totaler og underposter ud fra dine �ndringer.;
                                 ENU=Personalize the structure of your financial statements by mapping general ledger accounts to account categories. You can create category groups by indenting subcategories under them. Each grouping shows a total balance. When you choose the Generate Account Schedules action, the account schedules for the underlying financial reports are updated. The next time you run one of these reports, such as the balance statement, new totals and subentries are added, based on your changes.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 790 }
      { 18      ;2   ;Action    ;
                      Name=CashReceiptJournals;
                      CaptionML=[DAN=Indbetalingskladder;
                                 ENU=Cash Receipt Journals];
                      ToolTipML=[DAN=Registrer modtagne betalinger ved at udligne dem manuelt for de relaterede debitor-, kreditor- eller bankposter. Bogf�r derefter betalingerne til finanskontiene, s� du kan lukke de relaterede poster.;
                                 ENU=Register received payments by manually applying them to the related customer, vendor, or bank ledger entries. Then, post the payments to G/L accounts and thereby close the related ledger entries.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 251;
                      RunPageView=WHERE(Template Type=CONST(Cash Receipts),
                                        Recurring=CONST(No));
                      Image=Journals }
      { 17      ;2   ;Action    ;
                      Name=PaymentJournals;
                      CaptionML=[DAN=Udbetalingskladder;
                                 ENU=Payment Journals];
                      ToolTipML=[DAN=Registrer betalinger til kreditorer. En betalingskladde er en finanskladde, der bruges til at bogf�re udg�ende betalingstransaktioner til finansregnskab, bank, debitor, kreditor, medarbejder og anl�gskonti. Funktionerne for Lav kreditorbetalingsforslag udfylder automatisk kladden med de forfaldne betalinger. N�r betalingerne er bogf�rt, kan du eksportere betalingerne til en bankfil med henblik p� overf�rsel til din bank, s�fremt systemet er konfigureret til elektronisk betaling. Du kan ogs� sende computercheck fra betalingskladden.;
                                 ENU=Register payments to vendors. A payment journal is a type of general journal that is used to post outgoing payment transactions to G/L, bank, customer, vendor, employee, and fixed assets accounts. The Suggest Vendor Payments functions automatically fills the journal with payments that are due. When payments are posted, you can export the payments to a bank file for upload to your bank if your system is set up for electronic banking. You can also issue computer checks from the payment journal.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 251;
                      RunPageView=WHERE(Template Type=CONST(Payments),
                                        Recurring=CONST(No));
                      Image=Journals }
      { 23      ;2   ;Action    ;
                      CaptionML=[DAN=Bankkonti;
                                 ENU=Bank Accounts];
                      ToolTipML=[DAN=F� vist eller konfigurer detaljerede oplysninger om din bankkonto, f.eks. hvilken valuta der skal bruges, formatet p� de bankfiler, du importerer og eksporterer som elektroniske betalinger, samt nummereringen af checks.;
                                 ENU=View or set up detailed information about your bank account, such as which currency to use, the format of bank files that you import and export as electronic payments, and the numbering of checks.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 371;
                      Image=BankAccount }
      { 20      ;2   ;Action    ;
                      CaptionML=[DAN=Betalingsudligningskladder;
                                 ENU=Payment Reconciliation Journals];
                      ToolTipML=[DAN=Afstem ubetalte bilag automatisk med deres relaterede banktransaktioner ved at importere et bankkontoudtog eller en fil. I betalingsudligningskladden udlignes indg�ende eller udg�ende betalinger for din bank automatisk eller delvist automatisk med deres relaterede �bne debitor- eller kreditorposter. Alle �bne bankkontoposter i forhold til de udlignede debitor- eller kreditorposter bliver lukket, n�r du v�lger handlingen Bogf�r betalinger og Afstem bankkontoen. Det betyder, at bankkontoen automatisk afstemmes for de betalinger, som du bogf�rer med kladden.;
                                 ENU=Reconcile unpaid documents automatically with their related bank transactions by importing a bank statement feed or file. In the payment reconciliation journal, incoming or outgoing payments on your bank are automatically, or semi-automatically, applied to their related open customer or vendor ledger entries. Any open bank account ledger entries related to the applied customer or vendor ledger entries will be closed when you choose the Post Payments and Reconcile Bank Account action. This means that the bank account is automatically reconciled for payments that you post with the journal.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 1294;
                      Image=ApplyEntries }
      { 19      ;2   ;Action    ;
                      CaptionML=[DAN=Bankkontoudtog;
                                 ENU=Bank Acc. Statements];
                      ToolTipML=[DAN=Vis kontoudtog for de valgte bankkonti. For hver banktransaktion viser rapporten en beskrivelse, et udlignet bel�b, et kontoudtogsbel�b og andre oplysninger.;
                                 ENU=View statements for selected bank accounts. For each bank transaction, the report shows a description, an applied amount, a statement amount, and other information.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 389;
                      Image=BankAccountStatement }
      { 24      ;2   ;Action    ;
                      CaptionML=[DAN=Direct Debit-opkr�vninger;
                                 ENU=Direct Debit Collections];
                      ToolTipML=[DAN=Bed din bank om at tr�kke betalingsbel�b fra debitorens bankkonto og overf�re dem til din virksomheds konto. En Direct Debit-opkr�vning indeholder oplysninger om debitorens bankkonto, de ber�rte salgsfakturaer og debitorens aftale, dvs. den s�kaldte Direct Debit-betalingsaftale. Ud fra den resulterede Direct Debit-opkr�vningspost kan du derefter eksportere en XML-fil, som du kan sende eller overf�re til din bank til behandling.;
                                 ENU=Instruct your bank to withdraw payment amounts from your customer' s bank account and transfer them to your company' s account. A direct debit collection holds information about the customer' s bank account, the affected sales invoices, and the customer's agreement, the so-called direct-debit mandate. From the resulting direct-debit collection entry, you can then export an XML file that you send or upload to your bank for processing.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 1207 }
      { 26      ;2   ;Action    ;
                      CaptionML=[DAN=Valutaer;
                                 ENU=Currencies];
                      ToolTipML=[DAN=F� vist de forskellige valutaer, du handler i, eller opdater valutakurserne ved at hente de seneste kurser fra en ekstern tjenesteudbyder.;
                                 ENU=View the different currencies that you trade in or update the exchange rates by getting the latest rates from an external service provider.];
                      ApplicationArea=#Suite;
                      RunObject=Page 5;
                      Image=Currency }
      { 25      ;2   ;Action    ;
                      CaptionML=[DAN=Medarbejdere;
                                 ENU=Employees];
                      ToolTipML=[DAN=Administrer medarbejderoplysninger og relaterede oplysninger som f.eks. kvalifikationer og billeder, eller registrer og analys�r medarbejderfrav�r. Sikring af opdaterede records om medarbejderne forenkler dine personaleopgaver. Hvis en medarbejder f.eks. skifter adresse, kan du registrere dette p� medarbejderkortet.;
                                 ENU=Manage employees' details and related information, such as qualifications and pictures, or register and analyze employee absence. Keeping up-to-date records about your employees simplifies personnel tasks. For example, if an employee's address changes, you register this on the employee card.];
                      ApplicationArea=#BasicHR;
                      RunObject=Page 5201 }
      { 28      ;2   ;Action    ;
                      CaptionML=[DAN=Momsangivelse;
                                 ENU=VAT Statements];
                      ToolTipML=[DAN=F� vist en opg�relse over de bogf�rte momsbel�b, beregn dine momsafregningsbel�b for en bestemt periode som f.eks. et kvartal, og forbered indsendelse af momsangivelsen til myndighederne.;
                                 ENU=View a statement of posted VAT amounts, calculate your VAT settlement amount for a certain period, such as a quarter, and prepare to send the settlement to the tax authorities.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 320 }
      { 30      ;2   ;Action    ;
                      CaptionML=[DAN=Intrastatkladder;
                                 ENU=Intrastat Journals];
                      ToolTipML=[DAN=Sammenfat v�rdien af dine k�b og salg i relation til forretningspartnere i EU med statistik for �je, og klarg�r tallene til afsendelse til den relevante myndighed.;
                                 ENU=Summarize the value of your purchases and sales with business partners in the EU for statistical purposes and prepare to send it to the relevant authority.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 327 }
      { 40      ;1   ;ActionGroup;
                      CaptionML=[DAN=Salg;
                                 ENU=Sales];
                      ToolTipML=[DAN=Opret tilbud, ordrer og kreditnotaer. Se debitorer og transaktionshistorik.;
                                 ENU=Make quotes, orders, and credit memos. See customers and transaction history.];
                      Image=Sales }
      { 33      ;2   ;Action    ;
                      Name=Sales_CustomerList;
                      CaptionML=[DAN=Debitorer;
                                 ENU=Customers];
                      ToolTipML=[DAN=F� vist eller rediger detaljerede oplysninger om de debitorer, som du handler med. Fra det enkelte debitorkort kan du f� adgang til relaterede oplysninger som f.eks. salgsstatistik og igangv�rende ordrer, og du kan definere specialpriser og linjerabatter, som debitoren f�r, n�r bestemte betingelser er opfyldt.;
                                 ENU=View or edit detailed information for the customers that you trade with. From each customer card, you can open related information, such as sales statistics and ongoing orders, and you can define special prices and line discounts that you grant if certain conditions are met.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 22 }
      { 29      ;2   ;Action    ;
                      CaptionML=[DAN=Salgstilbud;
                                 ENU=Sales Quotes];
                      ToolTipML=[DAN=Giv tilbud til debitorer for at s�lge bestemte varer p� bestemte leverings- og betalingsbetingelser. N�r du forhandler med en debitor, kan du �ndre og sende salgstilbud, s� mange gange du beh�ver. N�r debitoren accepterer tilbuddet, skal du konvertere salgstilbuddet til en salgsfaktura eller en salgsordre, som du bruger til at behandle salget.;
                                 ENU=Make offers to customers to sell certain products on certain delivery and payment terms. While you negotiate with a customer, you can change and resend the sales quote as much as needed. When the customer accepts the offer, you convert the sales quote to a sales invoice or a sales order in which you process the sale.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 9300 }
      { 86      ;2   ;Action    ;
                      CaptionML=[DAN=Salgsordrer;
                                 ENU=Sales Orders];
                      ToolTipML=[DAN=Registrer dine aftaler med debitorer for at s�lge bestemte varer p� bestemte leverings- og betalingsbetingelser. Salgsordrer g�r det i mods�tning til salgsfakturaer muligt at levere delvist, levere direkte fra kreditoren til debitoren, starte lagerekspedition og udskrive forskellige dokumenter til kunderne. Salgsfakturering er integreret i salgsordreprocessen.;
                                 ENU=Record your agreements with customers to sell certain products on certain delivery and payment terms. Sales orders, unlike sales invoices, allow you to ship partially, deliver directly from your vendor to your customer, initiate warehouse handling, and print various customer-facing documents. Sales invoicing is integrated in the sales order process.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 9305 }
      { 48      ;2   ;Action    ;
                      CaptionML=[DAN=Salgsfakturaer;
                                 ENU=Sales Invoices];
                      ToolTipML=[DAN=Registrer dit salg til debitorer, og inviter dem til at betale i henhold til leverings- og betalingsbetingelserne ved at sende dem et salgsfakturadokument. Bogf�ring af en salgsfaktura registrerer leveringen og registrerer en �ben tilgodehavendepost p� debitorens konto, som vil blive lukket, n�r betalingen er modtaget. Brug salgsordrer, hvor salgsfaktureringen er integreret, til at administrere leveringsprocessen.;
                                 ENU=Register your sales to customers and invite them to pay according to the delivery and payment terms by sending them a sales invoice document. Posting a sales invoice registers shipment and records an open receivable entry on the customer's account, which will be closed when payment is received. To manage the shipment process, use sales orders, in which sales invoicing is integrated.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 9301 }
      { 44      ;2   ;Action    ;
                      CaptionML=[DAN=Salgskreditnotaer;
                                 ENU=Sales Credit Memos];
                      ToolTipML=[DAN=Tilbagef�r �konomiske transaktioner, n�r debitorerne vil annullere et k�b eller returnere forkerte eller beskadigede varer, som du har sendt til dem og modtaget betaling for. For at f� de rette oplysninger med, kan du oprette salgskreditnotaen ud fra den relaterede bogf�rte salgsfaktura, eller du kan oprette en ny salgskreditnota, hvor du inds�tter en kopi af fakturaoplysninger. Hvis du har brug for flere kontrol over processen for salgsreturvarer som f.eks. bilag for den fysiske lagerekspedition, skal du bruge salgsreturvareordrer, hvor salgskreditnotaer er integreret. Bem�rk: Hvis et fejlbeh�ftet salg endnu ikke er blevet betalt, kan du blot annullere den bogf�rte salgsfaktura for automatisk at tilbagef�re den �konomiske transaktion.;
                                 ENU=Revert the financial transactions involved when your customers want to cancel a purchase or return incorrect or damaged items that you sent to them and received payment for. To include the correct information, you can create the sales credit memo from the related posted sales invoice or you can create a new sales credit memo with copied invoice information. If you need more control of the sales return process, such as warehouse documents for the physical handling, use sales return orders, in which sales credit memos are integrated. Note: If an erroneous sale has not been paid yet, you can simply cancel the posted sales invoice to automatically revert the financial transaction.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 9302 }
      { 123     ;2   ;Action    ;
                      CaptionML=[DAN="Salgsreturvareordrer ";
                                 ENU="Sales Return Orders "];
                      ToolTipML=[DAN=Kompenser kunderne for forkerte eller beskadigede varer, som du har sendt til dem og modtaget betaling for. Salgsreturvareordrer underst�tter lagerbilag for lagerekspeditionen, mulighed for at returnere varer fra flere salgsbilag med samme returnering, og automatisk oprettelse af relaterede salgskreditnotaer eller andre returneringsbilag som f.eks. en erstatningssalgsordre.;
                                 ENU=Compensate your customers for incorrect or damaged items that you sent to them and received payment for. Sales return orders support warehouse documents for the item handling, the ability to return items from multiple sales documents with one return, and automatic creation of related sales credit memos or other return-related documents, such as a replacement sales order.];
                      ApplicationArea=#SalesReturnOrder;
                      RunObject=Page 9304 }
      { 37      ;2   ;Action    ;
                      CaptionML=[DAN=Rykkere;
                                 ENU=Reminders];
                      ToolTipML=[DAN=P�mind debitorer om forfaldne bel�b ud fra rykkerbetingelserne og de relaterede rykkerniveauer. Hvert rykkerniveau omfatter regler om, hvorn�r rykkeren skal udstedes i forhold til fakturaens forfaldsdato eller datoen for den forrige rykker, og om der p�l�ber renter. Rykkerne integreres i rentenotaerne, som er dokumenter, der informerer debitorerne om renter eller andre skyldige sanktioner for forsinket betaling.;
                                 ENU=Remind customers about overdue amounts based on reminder terms and the related reminder levels. Each reminder level includes rules about when the reminder will be issued in relation to the invoice due date or the date of the previous reminder and whether interests are added. Reminders are integrated with finance charge memos, which are documents informing customers of interests or other money penalties for payment delays.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 436;
                      Image=Reminder }
      { 35      ;2   ;Action    ;
                      CaptionML=[DAN=Rentenotaer;
                                 ENU=Finance Charge Memos];
                      ToolTipML=[DAN=Send rentenotaer til debitorer med forsinkede betalinger, hvilket typisk f�lger efter en rykkerprocedure. Renter beregnes automatisk og f�jes til de forfaldne bel�b p� debitorens konto i henhold til de angivne rentebetingelser og sanktions- eller rentebel�b.;
                                 ENU=Send finance charge memos to customers with delayed payments, typically following a reminder process. Finance charges are calculated automatically and added to the overdue amounts on the customer's account according to the specified finance charge terms and penalty/interest amounts.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 448;
                      Image=FinChargeMemo }
      { 50      ;2   ;Action    ;
                      CaptionML=[DAN=Bogf. salgsfakturaer;
                                 ENU=Posted Sales Invoices];
                      ToolTipML=[DAN=�bn listen over bogf�rte salgsfakturaer.;
                                 ENU=Open the list of posted sales invoices.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 143 }
      { 45      ;2   ;Action    ;
                      CaptionML=[DAN=Bogf. salgskr.notaer;
                                 ENU=Posted Sales Credit Memos];
                      ToolTipML=[DAN=�bn listen over bogf�rte salgskreditnotaer.;
                                 ENU=Open the list of posted sales credit memos.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 144 }
      { 109     ;2   ;Action    ;
                      CaptionML=[DAN=Bogf�rte salgsreturvaremodtagelser;
                                 ENU=Posted Sales Return Receipts];
                      ToolTipML=[DAN=�bn listen over bogf�rste salgsreturmodtagelser.;
                                 ENU=Open the list of posted sales return receipts.];
                      ApplicationArea=#SalesReturnOrder;
                      RunObject=Page 6662 }
      { 43      ;2   ;Action    ;
                      CaptionML=[DAN=Udstedte rykkere;
                                 ENU=Issued Reminders];
                      ToolTipML=[DAN=Vis oversigten over udstedte rykkere.;
                                 ENU=View the list of issued reminders.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 440;
                      Image=OrderReminder }
      { 34      ;2   ;Action    ;
                      CaptionML=[DAN=Udstedte rentenotaer;
                                 ENU=Issued Finance Charge Memos];
                      ToolTipML=[DAN=Vis oversigten over udstedte rentenotaer.;
                                 ENU=View the list of issued finance charge memos.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 452;
                      Image=PostedMemo }
      { 41      ;1   ;ActionGroup;
                      CaptionML=[DAN=Indk�b;
                                 ENU=Purchasing];
                      ToolTipML=[DAN=Administrer k�bsordrer, fakturaer og kreditnotaer. Vedligehold kreditorer og historikken over disse.;
                                 ENU=Manage purchase invoices and credit memos. Maintain vendors and their history.];
                      Image=AdministrationSalesPurchases }
      { 36      ;2   ;Action    ;
                      Name=Purchase_VendorList;
                      CaptionML=[DAN=Kreditorer;
                                 ENU=Vendors];
                      ToolTipML=[DAN=F� vist eller rediger detaljerede oplysninger om de kreditorer, som du handler med. Fra det enkelte kreditorkort kan du f� adgang til relaterede oplysninger som f.eks. k�bsstatistik og igangv�rende ordrer, og du kan definere specialpriser og linjerabatter, som kreditoren giver dig, n�r bestemte betingelser er opfyldt.;
                                 ENU=View or edit detailed information for the vendors that you trade with. From each vendor card, you can open related information, such as purchase statistics and ongoing orders, and you can define special prices and line discounts that the vendor grants you if certain conditions are met.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 27 }
      { 79      ;2   ;Action    ;
                      CaptionML=[DAN=Indg�ende bilag;
                                 ENU=Incoming Documents];
                      ToolTipML=[DAN=H�ndter indg�ende bilag, f.eks. kreditorfakturaer i PDF- eller billedfiler, som kan bruges til manuel eller automatisk konvertering til bilagsrecords, f.eks. k�bsfakturaer. De eksterne filer, der repr�senterer indg�ende bilag, kan knyttes til ethvert procestrin, herunder bogf�rte bilag og de resulterende kreditor-, debitor- og finansposter.;
                                 ENU=Handle incoming documents, such as vendor invoices in PDF or as image files, that you can manually or automatically convert to document records, such as purchase invoices. The external files that represent incoming documents can be attached at any process stage, including to posted documents and to the resulting vendor, customer, and general ledger entries.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 190;
                      Gesture=None }
      { 22      ;2   ;Action    ;
                      Name=<Page Purchase Orders>;
                      CaptionML=[DAN=K�bsordrer;
                                 ENU=Purchase Orders];
                      ToolTipML=[DAN=Opret k�bsordrer for at afspejle de salgsbilag, som leverand�rer sender til dig. P� denne m�de kan du registrere k�bsomkostninger og spore kreditorer. Bogf�ringen af k�bsordrer opdaterer lagerniveauerne dynamisk, s� du kan minimere lageromkostningerne og levere bedre kundeservice. K�bsordrer tillader delleverancer, modsat k�bsfakturaer, og muligg�r direkte levering fra kreditoren til debitoren. K�bsordrer kan oprettes automatisk ud fra PDF- eller billedfiler fra dine kreditorer ved hj�lp af funktionen Indg�ende bilag.;
                                 ENU=Create purchase orders to mirror sales documents that vendors send to you. This enables you to record the cost of purchases and to track accounts payable. Posting purchase orders dynamically updates inventory levels so that you can minimize inventory costs and provide better customer service. Purchase orders allow partial receipts, unlike with purchase invoices, and enable drop shipment directly from your vendor to your customer. Purchase orders can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature.];
                      ApplicationArea=#Suite;
                      RunObject=Page 9307 }
      { 57      ;2   ;Action    ;
                      Name=<Page Purchase Invoices>;
                      CaptionML=[DAN=K�bsfakturaer;
                                 ENU=Purchase Invoices];
                      ToolTipML=[DAN=Opret k�bsfakturaer for at afspejle de salgsbilag, som leverand�rer sender til dig. P� denne m�de kan du registrere k�bsomkostninger og spore kreditorer. Bogf�ringen af k�bsfakturaer opdaterer lagerniveauerne dynamisk, s� du kan minimere lageromkostningerne og levere bedre kundeservice. K�bsfakturaer kan oprettes automatisk ud fra PDF- eller billedfiler fra dine kreditorer ved hj�lp af funktionen Indg�ende bilag.;
                                 ENU=Create purchase invoices to mirror sales documents that vendors send to you. This enables you to record the cost of purchases and to track accounts payable. Posting purchase invoices dynamically updates inventory levels so that you can minimize inventory costs and provide better customer service. Purchase invoices can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 9308 }
      { 56      ;2   ;Action    ;
                      Name=<Page Purchase Credit Memos>;
                      CaptionML=[DAN=K�bskreditnotaer;
                                 ENU=Purchase Credit Memos];
                      ToolTipML=[DAN=Opret k�bskreditnotaer for at afspejle de salgskreditnotaer, som leverand�rer sender til dig for forkerte eller beskadigede varer, som er blevet betalt og derefter returneret til kreditoren. Hvis du har behov for mere kontrol over k�bsreturneringsprocessen, herunder lagerbilag for den fysiske lagerekspedition, skal du bruge k�bsreturvareordrer, hvor k�bskreditnotaerne integreres. K�bskreditnotaer kan oprettes automatisk ud fra PDF- eller billedfiler fra dine kreditorer ved hj�lp af funktionen Indg�ende bilag. Bem�rk: Hvis du endnu ikke har betalt for et fejlbeh�ftet k�b, kan du blot annullere den bogf�rte k�bsfaktura for automatisk at tilbagef�re den �konomiske transaktion.;
                                 ENU=Create purchase credit memos to mirror sales credit memos that vendors send to you for incorrect or damaged items that you have paid for and then returned to the vendor. If you need more control of the purchase return process, such as warehouse documents for the physical handling, use purchase return orders, in which purchase credit memos are integrated. Purchase credit memos can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature. Note: If you have not yet paid for an erroneous purchase, you can simply cancel the posted purchase invoice to automatically revert the financial transaction.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 9309 }
      { 126     ;2   ;Action    ;
                      CaptionML=[DAN=K�bsreturvareordrer;
                                 ENU=Purchase Return Orders];
                      ToolTipML=[DAN=Opret k�bsreturvareordrer for at afspejle de salgsreturbilag, som leverand�rer sender til dig for forkerte eller beskadigede varer, som er blevet betalt og derefter returneret til kreditoren. K�bsreturvareordrer g�r det muligt at returnere varer fra flere k�bsbilag med samme k�bsreturnering og underst�tter lagerbilag for lagerekspeditionen. K�bsreturvareordrer kan oprettes automatisk ud fra PDF- eller billedfiler fra dine kreditorer ved hj�lp af funktionen Indg�ende bilag. Bem�rk: Hvis du endnu ikke har betalt for et fejlbeh�ftet k�b, kan du blot annullere den bogf�rte k�bsfaktura for automatisk at tilbagef�re den �konomiske transaktion.;
                                 ENU=Create purchase return orders to mirror sales return documents that vendors send to you for incorrect or damaged items that you have paid for and then returned to the vendor. Purchase return orders enable you to ship back items from multiple purchase documents with one purchase return and support warehouse documents for the item handling. Purchase return orders can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature. Note: If you have not yet paid for an erroneous purchase, you can simply cancel the posted purchase invoice to automatically revert the financial transaction.];
                      ApplicationArea=#SalesReturnOrder;
                      RunObject=Page 9311 }
      { 53      ;2   ;Action    ;
                      Name=<Page Posted Purchase Invoices>;
                      CaptionML=[DAN=Bogf. k�bsfakturaer;
                                 ENU=Posted Purchase Invoices];
                      ToolTipML=[DAN=�bn listen over bogf�rte k�bsfakturaer.;
                                 ENU=Open the list of posted purchase invoices.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 146 }
      { 51      ;2   ;Action    ;
                      Name=<Page Posted Purchase Credit Memos>;
                      CaptionML=[DAN=Bogf�rte k�bskreditnotaer;
                                 ENU=Posted Purchase Credit Memos];
                      ToolTipML=[DAN=�bn listen over bogf�rte k�bskreditnotaer.;
                                 ENU=Open the list of posted purchase credit memos.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 147 }
      { 31      ;2   ;Action    ;
                      Name=<Page Posted Purchase Receipts>;
                      CaptionML=[DAN=Bogf. k�bsmodtagelser;
                                 ENU=Posted Purchase Receipts];
                      ToolTipML=[DAN=�bn listen over bogf�rte k�bsmodtagelser.;
                                 ENU=Open the list of posted purchase receipts.];
                      ApplicationArea=#Suite;
                      RunObject=Page 145 }
      { 125     ;2   ;Action    ;
                      CaptionML=[DAN=Bogf�rte leverancer af k�bsreturvarer;
                                 ENU=Posted Purchase Return Shipments];
                      ToolTipML=[DAN=�bn listen over bogf�rte leverancer af k�bsreturvarer.;
                                 ENU=Open the list of posted purchase return shipments.];
                      ApplicationArea=#SalesReturnOrder;
                      RunObject=Page 6652 }
      { 76      ;1   ;ActionGroup;
                      CaptionML=[DAN=Godkendelser;
                                 ENU=Approvals];
                      ToolTipML=[DAN=Godkend anmodninger fra andre brugere.;
                                 ENU=Approve requests made by other users.] }
      { 77      ;2   ;Action    ;
                      CaptionML=[DAN=Anmodninger til godkendelse;
                                 ENU=Requests to Approve];
                      ToolTipML=[DAN=Accepter eller afvis andre brugeres anmodninger om at oprette eller �ndre bestemte dokumenter, kort eller kladdelinjer, som du skal godkende, f�r de kan forts�tte. Listen er filtreret til anmodninger, hvor du er konfigureret som godkender.;
                                 ENU=Accept or reject other users' requests to create or change certain documents, cards, or journal lines that you must approve before they can proceed. The list is filtered to requests where you are set up as the approver.];
                      ApplicationArea=#Suite;
                      RunObject=Page 654;
                      Image=Approvals }
      { 42      ;1   ;ActionGroup;
                      CaptionML=[DAN=Avanceret finans;
                                 ENU=Advanced Finance];
                      ToolTipML=[DAN=Administrer budgetter og anl�gsaktiver.;
                                 ENU=Manage budgets and fixed assets.];
                      Image=AnalysisView }
      { 63      ;2   ;Action    ;
                      CaptionML=[DAN=Finansbudgetter;
                                 ENU=G/L Budgets];
                      ToolTipML=[DAN=Vis en oversigt for det bel�b, der er budgetteret for hver enkelt finanskonto i forskellige perioder.;
                                 ENU=View summary information about the amount budgeted for each general ledger account in different time periods.];
                      ApplicationArea=#Suite;
                      RunObject=Page 121 }
      { 62      ;2   ;Action    ;
                      CaptionML=[DAN=Anl�g;
                                 ENU=Fixed Assets];
                      ToolTipML=[DAN=Administr�r periodisk afskrivning af dine maskiner, hold styr p� reparationsomkostningerne, administr�r forsikringspolicer vedr�rende faste anl�gsaktiver, og overv�g statistik for faste anl�gsaktiver.;
                                 ENU=Manage periodic depreciation of your machinery or machines, keep track of your maintenance costs, manage insurance policies related to fixed assets, and monitor fixed asset statistics.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5601 }
      { 73      ;2   ;Action    ;
                      CaptionML=[DAN=Salgsanalyserapporter;
                                 ENU=Sales Analysis Reports];
                      ToolTipML=[DAN=Analyser udviklingen i dit salg i henhold til n�glesalgsindikatorer, som du v�lger, f.eks. salgsoms�tningen i b�de bel�b og antal, d�kningsbidrag eller det aktuelle salgs forl�b i forhold til budgettet. Du kan ogs� anvende rapporten til at analysere dine gennemsnitlige salgspriser og evaluere din salgsstyrkes pr�stationer.;
                                 ENU=Analyze the dynamics of your sales according to key sales performance indicators that you select, for example, sales turnover in both amounts and quantities, contribution margin, or progress of actual sales against the budget. You can also use the report to analyze your average sales prices and evaluate the sales performance of your sales force.];
                      ApplicationArea=#Suite;
                      RunObject=Page 9376 }
      { 72      ;2   ;Action    ;
                      CaptionML=[DAN=K�bsanalyserapporter;
                                 ENU=Purchase Analysis Reports];
                      ToolTipML=[DAN=Analyser udviklingen i k�bsm�ngderne. Du kan ogs� bruge rapporten til at analysere kreditorpr�stationer og priser.;
                                 ENU=Analyze the dynamics of your purchase volumes. You can also use the report to analyze your vendors' performance and purchase prices.];
                      ApplicationArea=#Suite;
                      RunObject=Page 9375 }
      { 71      ;2   ;Action    ;
                      CaptionML=[DAN=Lageranalyserapporter;
                                 ENU=Inventory Analysis Reports];
                      ToolTipML=[DAN=Analyser udviklingen i lageret p� grundlag af de n�gleparametre, som du har valgt, f.eks. lageroms�tningen. Du kan ogs� bruge rapporten til at analysere lageromkostningerne, b�de med hensyn til direkte og indirekte omkostninger, samt v�rdien og m�ngden af forskellige typer beholdning.;
                                 ENU=Analyze the dynamics of your inventory according to key performance indicators that you select, for example inventory turnover. You can also use the report to analyze your inventory costs, in terms of direct and indirect costs, as well as the value and quantities of your different types of inventory.];
                      ApplicationArea=#Suite;
                      RunObject=Page 9377 }
      { 70      ;2   ;Action    ;
                      CaptionML=[DAN=Momsrapporter;
                                 ENU=VAT Reports];
                      ToolTipML=[DAN=F� vist momsrapporter.;
                                 ENU=View VAT Reports.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 744 }
      { 68      ;2   ;Action    ;
                      CaptionML=[DAN=Pengestr�msprognoser;
                                 ENU=Cash Flow Forecasts];
                      ToolTipML=[DAN=Kombiner forskellige finansielle datakilder for at finde ud af, hvorn�r et kontant overskud eller underskud sker, eller om du skal afbetale g�ld eller optage l�n for at opfylde kommende udgifter.;
                                 ENU=Combine various financial data sources to find out when a cash surplus or deficit might happen or whether you should pay down debt, or borrow to meet upcoming expenses.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 849 }
      { 67      ;2   ;Action    ;
                      CaptionML=[DAN=Pengestr�mskontoplan;
                                 ENU=Chart of Cash Flow Accounts];
                      ToolTipML=[DAN=F� vist et diagram med en grafisk gengivelse af �n eller flere pengestr�mskonti og �n eller flere pengestr�msops�tninger for det eller de inkluderede finansregnskab, k�b, salg, tjenester eller anl�gskonti.;
                                 ENU=View a chart contain a graphical representation of one or more cash flow accounts and one or more cash flow setups for the included general ledger, purchase, sales, services, or fixed assets accounts.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 851 }
      { 66      ;2   ;Action    ;
                      CaptionML=[DAN=Manuelle pengestr�msindt�gter;
                                 ENU=Cash Flow Manual Revenues];
                      ToolTipML=[DAN=Registrer manuelle indt�gter, f.eks. lejeindt�gter, renter fra finansielle anl�g eller ny privat kapital, der skal bruges i pengestr�msprognoser.;
                                 ENU=Record manual revenues, such as rental income, interest from financial assets, or new private capital to be used in cash flow forecasting.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 857 }
      { 64      ;2   ;Action    ;
                      CaptionML=[DAN=Manuelle pengestr�msudgifter;
                                 ENU=Cash Flow Manual Expenses];
                      ToolTipML=[DAN=Registrer manuelle udgifter, f.eks. l�nninger, renter p� kredit eller planlagte investeringer, der skal bruges i pengestr�msprognoser.;
                                 ENU=Record manual expenses, such as salaries, interest on credit, or planned investments to be used in cash flow forecasting.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 859 }
      { 61      ;1   ;ActionGroup;
                      CaptionML=[DAN=Selvbetjening;
                                 ENU=Self-Service];
                      ToolTipML=[DAN=Administrer dine timesedler og opgaver.;
                                 ENU=Manage your time sheets and assignments.];
                      Image=HumanResources }
      { 60      ;2   ;Action    ;
                      CaptionML=[DAN=Timesedler;
                                 ENU=Time Sheets];
                      ToolTipML=[DAN=Giv ressourcer mulighed for at tidsregistere. Efter godkendelsen, hvis en s�dan kr�ves, kan timeseddelposterne bogf�res for den relevante sagskladde eller ressourcekladde som en del af registreringen af projektforl�bet. Hvis du vil spare konfigurationstid og sikre, at dataene er korrekte, kan du kopiere sagsplanl�gningslinjerne til timesedlerne.;
                                 ENU=Enable resources to register time. When approved, if approval is required, time sheet entries can be posted to the relevant job journal or resource journal as part of project progress reporting. To save setup time and to ensure data correctness, you can copy job planning lines into time sheets.];
                      ApplicationArea=#Suite;
                      RunObject=Page 951 }
      { 111     ;2   ;Action    ;
                      Name=Page Time Sheet List Open;
                      CaptionML=[DAN=�bn;
                                 ENU=Open];
                      ToolTipML=[DAN=�bn kortet for den valgte record.;
                                 ENU=Open the card for the selected record.];
                      ApplicationArea=#Suite;
                      RunObject=Page 951;
                      RunPageView=WHERE(Open Exists=CONST(Yes)) }
      { 112     ;2   ;Action    ;
                      Name=Page Time Sheet List Submitted;
                      CaptionML=[DAN=Sendt;
                                 ENU=Submitted];
                      ToolTipML=[DAN=F� vist sendte timesedler.;
                                 ENU=View submitted time sheets.];
                      ApplicationArea=#Suite;
                      RunObject=Page 951;
                      RunPageView=WHERE(Submitted Exists=CONST(Yes)) }
      { 65      ;2   ;Action    ;
                      Name=Page Time Sheet List Rejected;
                      CaptionML=[DAN=Afvist;
                                 ENU=Rejected];
                      ToolTipML=[DAN=F� vist afviste timesedler.;
                                 ENU=View rejected time sheets.];
                      ApplicationArea=#Suite;
                      RunObject=Page 951;
                      RunPageView=WHERE(Rejected Exists=CONST(Yes)) }
      { 110     ;2   ;Action    ;
                      Name=Page Time Sheet List Approved;
                      CaptionML=[DAN=Godkendt;
                                 ENU=Approved];
                      ToolTipML=[DAN=F� vist godkendte timesedler.;
                                 ENU=View approved time sheets.];
                      ApplicationArea=#Suite;
                      RunObject=Page 951;
                      RunPageView=WHERE(Approved Exists=CONST(Yes)) }
      { 102     ;1   ;ActionGroup;
                      Name=SetupAndExtensions;
                      CaptionML=[DAN=Installation og udvidelser;
                                 ENU=Setup & Extensions];
                      ToolTipML=[DAN=Oversigt og �ndringssystem og programindstillinger samt administration af udvidelser og tjenester;
                                 ENU=Overview and change system and application settings, and manage extensions and services];
                      Image=Setup }
      { 104     ;2   ;Action    ;
                      CaptionML=[DAN=Assisteret ops�tning;
                                 ENU=Assisted Setup];
                      ToolTipML=[DAN=Konfigurer kernefunktioner s�som moms, og send dokumenter som mails og godkendelsesworkflow ved at k�re igennem et par sider, der vejleder dig i oplysningerne.;
                                 ENU=Set up core functionality such as sales tax, sending documents as email, and approval workflow by running through a few pages that guide you through the information.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 1801;
                      Image=QuestionaireSetup }
      { 99      ;2   ;Action    ;
                      Name=Manual Setup;
                      CaptionML=[DAN=Manuel ops�tning;
                                 ENU=Manual Setup];
                      ToolTipML=[DAN=Definer dine virksomhedspolitikker for afdelinger og generelle aktiviteter ved at udfylde ops�tningsvinduer manuelt.;
                                 ENU=Define your company policies for business departments and for general activities by filling setup windows manually.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 1875 }
      { 103     ;2   ;Action    ;
                      Name=General;
                      CaptionML=[DAN=Generelt;
                                 ENU=General];
                      ToolTipML=[DAN="Udfyld dine officielle virksomhedsoplysninger, og definer de generelle koder og oplysninger, der anvendes til alle virksomhedens funktioner, f.eks. valutaer og sprog. ";
                                 ENU="Fill in your official company information, and define general codes and information that is used across the business functionality, such as currencies and languages. "];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 1875;
                      RunPageView=SORTING(Name)
                                  WHERE(Area=FILTER(General)) }
      { 47      ;2   ;Action    ;
                      Name=Finance;
                      CaptionML=[DAN=Finans;
                                 ENU=Finance];
                      ToolTipML=[DAN=Definer dine generelle regnskabspolitikker, f.eks. den tilladte bogf�ringsperiode, og hvordan betalinger behandles. Konfigurer dine standarddimensioner for finansielle analyser.;
                                 ENU=Define your general accounting policies, such as the allowed posting period and how payments are processed. Set up your default dimensions for financial analysis.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 1875;
                      RunPageView=SORTING(Name)
                                  WHERE(Area=FILTER(Finance)) }
      { 105     ;2   ;Action    ;
                      Name=Sales;
                      CaptionML=[DAN=Salg;
                                 ENU=Sales];
                      ToolTipML=[DAN=Definer dine generelle politikker for salgsfakturering og returneringer, f.eks. hvorn�r advarsler om kredit og lagerbeholdning skal vises, og hvordan salgsrabatter skal bogf�res. Konfigurer dine nummerserier for oprettelse af debitorer og forskellige salgsbilag.;
                                 ENU=Define your general policies for sales invoicing and returns, such as when to show credit and stockout warnings and how to post sales discounts. Set up your number series for creating customers and different sales documents.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 1875;
                      RunPageView=SORTING(Name)
                                  WHERE(Area=FILTER(Sales)) }
      { 95      ;2   ;Action    ;
                      Name=Purchasing;
                      CaptionML=[DAN=Indk�b;
                                 ENU=Purchasing];
                      ToolTipML=[DAN=Definer dine generelle politikker for fakturering af k�b og for returneringer, f.eks. om kreditorfakturanumre skal angives, og hvordan k�bsrabatter skal bogf�res. Konfigurer dine nummerserier for oprettelse af kreditorer og forskellige k�bsbilag.;
                                 ENU=Define your general policies for purchase invoicing and returns, such as whether to require vendor invoice numbers and how to post purchase discounts. Set up your number series for creating vendors and different purchase documents.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 1875;
                      RunPageView=SORTING(Name)
                                  WHERE(Area=FILTER(Purchasing)) }
      { 58      ;2   ;Action    ;
                      Name=Jobs;
                      CaptionML=[DAN=Sager;
                                 ENU=Jobs];
                      ToolTipML=[DAN=Definer en projektaktivitet ved at oprette et sagskort med integrerede sagsopgaver og sagsplanl�gningslinjer, opdelt i to lag. Sagsopgaven giver dig mulighed for at konfigurere sagsplanl�gningslinjer og bogf�re forbrug for sagen. Sagsplanl�gningslinjer angiver brugen af ressourcer, varer og forskellige finansudgifter i detaljer.;
                                 ENU=Define a project activity by creating a job card with integrated job tasks and job planning lines, structured in two layers. The job task enables you to set up job planning lines and to post consumption to the job. The job planning lines specify the detailed use of resources, items, and various general ledger expenses.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 1875;
                      RunPageView=SORTING(Name)
                                  WHERE(Area=FILTER(Jobs)) }
      { 10      ;2   ;Action    ;
                      Name=Fixed Assets;
                      CaptionML=[DAN=Anl�gsaktiver;
                                 ENU=Fixed Assets];
                      ToolTipML=[DAN=Administr�r periodisk afskrivning af dine maskiner, hold styr p� reparationsomkostningerne, administr�r forsikringspolicer vedr�rende faste anl�gsaktiver, og overv�g statistik for faste anl�gsaktiver.;
                                 ENU=Manage periodic depreciation of your machinery or machines, keep track of your maintenance costs, manage insurance policies related to fixed assets, and monitor fixed asset statistics.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 1875;
                      RunPageView=SORTING(Name)
                                  WHERE(Area=FILTER(Fixed Assets)) }
      { 69      ;2   ;Action    ;
                      Name=HR;
                      CaptionML=[DAN=Personale;
                                 ENU=HR];
                      ToolTipML=[DAN=Konfigurer nummerserien for oprettelse af nye medarbejderkort, og definer, om ans�ttelsestiden skal m�les i dage eller timer.;
                                 ENU=Set up number series for creating new employee cards and define if employment time is measured by days or hours.];
                      ApplicationArea=#BasicHR;
                      RunObject=Page 1875;
                      RunPageView=SORTING(Name)
                                  WHERE(Area=FILTER(HR)) }
      { 91      ;2   ;Action    ;
                      Name=Inventory;
                      CaptionML=[DAN=Lager;
                                 ENU=Inventory];
                      ToolTipML=[DAN=Definer dine generelle lagerpolitikker, f.eks. om negativ lagerbeholdning er tilladt, og hvordan varepriser skal bogf�res og reguleres. Konfigurer dine nummerserier for oprettelse af nye lagervarer eller -servicer.;
                                 ENU=Define your general inventory policies, such as whether to allow negative inventory and how to post and adjust item costs. Set up your number series for creating new inventory items or services.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 1875;
                      RunPageView=SORTING(Name)
                                  WHERE(Area=FILTER(Inventory)) }
      { 92      ;2   ;Action    ;
                      Name=Service;
                      CaptionML=[DAN=Tjeneste;
                                 ENU=Service];
                      ToolTipML=[DAN=Konfigurer dine virksomhedspolitikker for servicestyring.;
                                 ENU=Configure your company policies for service management.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 1875;
                      RunPageView=SORTING(Name)
                                  WHERE(Area=FILTER(Service)) }
      { 93      ;2   ;Action    ;
                      Name=System;
                      CaptionML=[DAN=System;
                                 ENU=System];
                      ToolTipML=[DAN=System;
                                 ENU=System];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 1875;
                      RunPageView=SORTING(Name)
                                  WHERE(Area=FILTER(System)) }
      { 94      ;2   ;Action    ;
                      Name=Relationship Management;
                      CaptionML=[DAN=Relationsstyring;
                                 ENU=Relationship Management];
                      ToolTipML=[DAN=Opret forretningsrelationer, konfigurer salgsprocesser, kampagner og interaktioner, og definer koder for forskellig marketingkommunikation.;
                                 ENU=Set up business relations, configure sales cycles, campaigns, and interactions, and define codes for various marketing communication.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 1875;
                      RunPageView=SORTING(Name)
                                  WHERE(Area=FILTER(Relationship Mngt)) }
      { 124     ;2   ;Action    ;
                      Name=Intercompany;
                      CaptionML=[DAN=Koncernintern;
                                 ENU=Intercompany];
                      ToolTipML=[DAN=Konfigurer interne processer som f.eks. indbakke og udbakke for forretningsdokumenter, der udveksles i gruppen.;
                                 ENU=Configure intercompany processes, such as the inbox and outbox for business documents exchanged within your group.];
                      ApplicationArea=#Intercompany;
                      RunObject=Page 1875;
                      RunPageView=SORTING(Name)
                                  WHERE(Area=FILTER(Intercompany)) }
      { 107     ;2   ;Action    ;
                      CaptionML=[DAN=Serviceforbindelser;
                                 ENU=Service Connections];
                      ToolTipML=[DAN=Aktiv�r og konfigurer eksterne tjenester, f.eks. opdateringer af valutakurser, Microsoft Social Engagement og elektronisk bankintegration.;
                                 ENU=Enable and configure external services, such as exchange rate updates, Microsoft Social Engagement, and electronic bank integration.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 1279;
                      Image=ServiceTasks }
      { 106     ;2   ;Action    ;
                      CaptionML=[DAN=Udvidelser;
                                 ENU=Extensions];
                      ToolTipML=[DAN=Install�r udvidelser for at optimere systemets funktionalitet.;
                                 ENU=Install Extensions for greater functionality of the system.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 2500;
                      Image=NonStockItemSetup }
    }
  }
  CONTROLS
  {
    { 13  ;0   ;Container ;
                ContainerType=RoleCenterArea }

    { 16  ;1   ;Part      ;
                AccessByPermission=TableData 1313=I;
                ApplicationArea=#Basic,#Suite;
                PagePartID=Page1310;
                PartType=Page }

    { 55  ;1   ;Part      ;
                AccessByPermission=TableData 1803=I;
                CaptionML=[DAN="";
                           ENU=""];
                ToolTipML=[DAN=Angiver visningen af din virksomhedshj�lp;
                           ENU=Specifies the view of your business assistance];
                ApplicationArea=#Basic,#Suite;
                PagePartID=Page1392;
                PartType=Page }

    { 46  ;1   ;Part      ;
                ApplicationArea=#Suite;
                PagePartID=Page9043;
                PartType=Page }

    { 7   ;1   ;Part      ;
                CaptionML=[DAN=Favoritkonti;
                           ENU=Favorite Accounts];
                ApplicationArea=#Basic,#Suite;
                PagePartID=Page9153;
                PartType=Page }

    { 9   ;1   ;Part      ;
                AccessByPermission=TableData 17=R;
                ApplicationArea=#Basic,#Suite;
                PagePartID=Page1393;
                PartType=Page }

    { 96  ;1   ;Part      ;
                ApplicationArea=#Basic,#Suite;
                PagePartID=Page681;
                PartType=Page }

    { 98  ;1   ;Part      ;
                AccessByPermission=TableData 6304=I;
                ApplicationArea=#Basic,#Suite;
                PagePartID=Page6303;
                PartType=Page }

    { 113 ;1   ;Part      ;
                CaptionML=[DAN=" ";
                           ENU=" "];
                ApplicationArea=#Invoicing;
                PagePartID=Page2196;
                PartType=Page }

  }
  CODE
  {

    BEGIN
    {
      CurrPage."Help And Setup List".ShowFeatured;
    }
    END.
  }
}

