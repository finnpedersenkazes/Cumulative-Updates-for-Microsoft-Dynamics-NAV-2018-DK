OBJECT Page 9015 Job Project Manager RC
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    CaptionML=[@@@="{Dependency=Match,""ProfileDescription_PROJECTMANAGER""}";
               DAN=Projektleder;
               ENU=Project Manager];
    PageType=RoleCenter;
    ActionList=ACTIONS
    {
      { 1900000011;0 ;ActionContainer;
                      ActionContainerType=HomeItems }
      { 12      ;1   ;Action    ;
                      Name=Jobs;
                      CaptionML=[DAN=Sager;
                                 ENU=Jobs];
                      ToolTipML=[DAN=Definer en projektaktivitet ved at oprette et sagskort med integrerede sagsopgaver og sagsplanlëgningslinjer, opdelt i to lag. Sagsopgaven giver dig mulighed for at konfigurere sagsplanlëgningslinjer og bogfõre forbrug for sagen. Sagsplanlëgningslinjer angiver brugen af ressourcer, varer og forskellige finansudgifter i detaljer.;
                                 ENU=Define a project activity by creating a job card with integrated job tasks and job planning lines, structured in two layers. The job task enables you to set up job planning lines and to post consumption to the job. The job planning lines specify the detailed use of resources, items, and various general ledger expenses.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 89;
                      Image=Job }
      { 53      ;1   ;Action    ;
                      Name=JobsOnOrder;
                      CaptionML=[DAN=èbn;
                                 ENU=Open];
                      ToolTipML=[DAN=èbn kortet for den valgte record.;
                                 ENU=Open the card for the selected record.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 89;
                      RunPageView=WHERE(Status=FILTER(Open)) }
      { 54      ;1   ;Action    ;
                      Name=JobsPlannedAndQuoted;
                      CaptionML=[DAN=Planlagt og givet tilbud;
                                 ENU=Planned and Quoted];
                      ToolTipML=[DAN=Vis alle planlagte sager og sager, der er givet tilbud pÜ.;
                                 ENU=View all planned and quoted jobs.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 89;
                      RunPageView=WHERE(Status=FILTER(Quote|Planning)) }
      { 35      ;1   ;Action    ;
                      Name=JobsCompleted;
                      CaptionML=[DAN=Afsluttet;
                                 ENU=Completed];
                      ToolTipML=[DAN=Vis alle fuldfõrte sager.;
                                 ENU=View all completed jobs.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 89;
                      RunPageView=WHERE(Status=FILTER(Completed)) }
      { 55      ;1   ;Action    ;
                      Name=JobsUnassigned;
                      CaptionML=[DAN=Ikke tildelt;
                                 ENU=Unassigned];
                      ToolTipML=[DAN=Vis alle ikke-tildelte sager.;
                                 ENU=View all unassigned jobs.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 89;
                      RunPageView=WHERE(Person Responsible=FILTER('')) }
      { 36      ;1   ;Action    ;
                      CaptionML=[DAN=Sagsopgaver;
                                 ENU=Job Tasks];
                      ToolTipML=[DAN=Definer de forskellige opgaver, der er involveret i en sag. Du skal oprette mindst Çn sagsopgave pr. sag, fordi al bogfõring henviser til en sagsopgave. Ved at have mindst Çn sagsopgave i en sag kan du konfigurere sagsplanlëgningslinjer og bogfõre forbrug for sagen.;
                                 ENU=Define the various tasks involved in a job. You must create at least one job task per job because all posting refers to a job task. Having at least one job task in your job enables you to set up job planning lines and to post consumption to the job.];
                      ApplicationArea=#Suite;
                      RunObject=Page 1004 }
      { 37      ;1   ;Action    ;
                      CaptionML=[DAN=Salgsfakturaer;
                                 ENU=Sales Invoices];
                      ToolTipML=[DAN=Registrer dit salg til debitorer, og inviter dem til at betale i henhold til leverings- og betalingsbetingelserne ved at sende dem et salgsfakturadokument. Bogfõring af en salgsfaktura registrerer leveringen og registrerer en Üben tilgodehavendepost pÜ debitorens konto, som vil blive lukket, nÜr betalingen er modtaget. Brug salgsordrer, hvor salgsfaktureringen er integreret, til at administrere leveringsprocessen.;
                                 ENU=Register your sales to customers and invite them to pay according to the delivery and payment terms by sending them a sales invoice document. Posting a sales invoice registers shipment and records an open receivable entry on the customer's account, which will be closed when payment is received. To manage the shipment process, use sales orders, in which sales invoicing is integrated.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 9301;
                      Image=Invoice }
      { 38      ;1   ;Action    ;
                      CaptionML=[DAN=Salgskreditnotaer;
                                 ENU=Sales Credit Memos];
                      ToolTipML=[DAN=Tilbagefõr õkonomiske transaktioner, nÜr debitorerne vil annullere et kõb eller returnere forkerte eller beskadigede varer, som du har sendt til dem og modtaget betaling for. For at fÜ de rette oplysninger med, kan du oprette salgskreditnotaen ud fra den relaterede bogfõrte salgsfaktura, eller du kan oprette en ny salgskreditnota, hvor du indsëtter en kopi af fakturaoplysninger. Hvis du har brug for flere kontrol over processen for salgsreturvarer som f.eks. bilag for den fysiske lagerekspedition, skal du bruge salgsreturvareordrer, hvor salgskreditnotaer er integreret. Bemërk: Hvis et fejlbehëftet salg endnu ikke er blevet betalt, kan du blot annullere den bogfõrte salgsfaktura for automatisk at tilbagefõre den õkonomiske transaktion.;
                                 ENU=Revert the financial transactions involved when your customers want to cancel a purchase or return incorrect or damaged items that you sent to them and received payment for. To include the correct information, you can create the sales credit memo from the related posted sales invoice or you can create a new sales credit memo with copied invoice information. If you need more control of the sales return process, such as warehouse documents for the physical handling, use sales return orders, in which sales credit memos are integrated. Note: If an erroneous sale has not been paid yet, you can simply cancel the posted sales invoice to automatically revert the financial transaction.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 9302 }
      { 39      ;1   ;Action    ;
                      CaptionML=[DAN=Kõbsordrer;
                                 ENU=Purchase Orders];
                      ToolTipML=[DAN=Opret kõbsordrer for at afspejle de salgsbilag, som leverandõrer sender til dig. PÜ denne mÜde kan du registrere kõbsomkostninger og spore kreditorer. Bogfõringen af kõbsordrer opdaterer lagerniveauerne dynamisk, sÜ du kan minimere lageromkostningerne og levere bedre kundeservice. Kõbsordrer tillader delleverancer, modsat kõbsfakturaer, og muliggõr direkte levering fra kreditoren til debitoren. Kõbsordrer kan oprettes automatisk ud fra PDF- eller billedfiler fra dine kreditorer ved hjëlp af funktionen IndgÜende bilag.;
                                 ENU=Create purchase orders to mirror sales documents that vendors send to you. This enables you to record the cost of purchases and to track accounts payable. Posting purchase orders dynamically updates inventory levels so that you can minimize inventory costs and provide better customer service. Purchase orders allow partial receipts, unlike with purchase invoices, and enable drop shipment directly from your vendor to your customer. Purchase orders can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature.];
                      ApplicationArea=#Suite;
                      RunObject=Page 9307 }
      { 40      ;1   ;Action    ;
                      CaptionML=[DAN=Kõbsfakturaer;
                                 ENU=Purchase Invoices];
                      ToolTipML=[DAN=Opret kõbsfakturaer for at afspejle de salgsbilag, som leverandõrer sender til dig. PÜ denne mÜde kan du registrere kõbsomkostninger og spore kreditorer. Bogfõringen af kõbsfakturaer opdaterer lagerniveauerne dynamisk, sÜ du kan minimere lageromkostningerne og levere bedre kundeservice. Kõbsfakturaer kan oprettes automatisk ud fra PDF- eller billedfiler fra dine kreditorer ved hjëlp af funktionen IndgÜende bilag.;
                                 ENU=Create purchase invoices to mirror sales documents that vendors send to you. This enables you to record the cost of purchases and to track accounts payable. Posting purchase invoices dynamically updates inventory levels so that you can minimize inventory costs and provide better customer service. Purchase invoices can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature.];
                      ApplicationArea=#Suite;
                      RunObject=Page 9308 }
      { 41      ;1   ;Action    ;
                      CaptionML=[DAN=Kõbskreditnotaer;
                                 ENU=Purchase Credit Memos];
                      ToolTipML=[DAN=Opret kõbskreditnotaer for at afspejle de salgskreditnotaer, som leverandõrer sender til dig for forkerte eller beskadigede varer, som er blevet betalt og derefter returneret til kreditoren. Hvis du har behov for mere kontrol over kõbsreturneringsprocessen, herunder lagerbilag for den fysiske lagerekspedition, skal du bruge kõbsreturvareordrer, hvor kõbskreditnotaerne integreres. Kõbskreditnotaer kan oprettes automatisk ud fra PDF- eller billedfiler fra dine kreditorer ved hjëlp af funktionen IndgÜende bilag. Bemërk: Hvis du endnu ikke har betalt for et fejlbehëftet kõb, kan du blot annullere den bogfõrte kõbsfaktura for automatisk at tilbagefõre den õkonomiske transaktion.;
                                 ENU=Create purchase credit memos to mirror sales credit memos that vendors send to you for incorrect or damaged items that you have paid for and then returned to the vendor. If you need more control of the purchase return process, such as warehouse documents for the physical handling, use purchase return orders, in which purchase credit memos are integrated. Purchase credit memos can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature. Note: If you have not yet paid for an erroneous purchase, you can simply cancel the posted purchase invoice to automatically revert the financial transaction.];
                      ApplicationArea=#Suite;
                      RunObject=Page 9309 }
      { 42      ;1   ;Action    ;
                      CaptionML=[DAN=Ressourcer;
                                 ENU=Resources];
                      ToolTipML=[DAN=Administrer dine ressourcers sagsaktiviteter ved at angive deres omkostninger og priser. Reglerne for sagsrelaterede pris-, rabat- og kostfaktorer konfigureres for de respektive jobkort. Du kan angive omkostninger og priser for individuelle ressourcer, ressourcegrupper eller alle tilgëngelige ressourcer i virksomheden. NÜr ressourcerne anvendes eller sëlges i en sag, registreres de angivne priser og omkostninger for projektet.;
                                 ENU=Manage your resources' job activities by setting up their costs and prices. The job-related prices, discounts, and cost factor rules are set up on the respective job card. You can specify the costs and prices for individual resources, resource groups, or all available resources of the company. When resources are used or sold in a job, the specified prices and costs are recorded for the project.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 77 }
      { 43      ;1   ;Action    ;
                      CaptionML=[DAN=Ressourcegrupper;
                                 ENU=Resource Groups];
                      ToolTipML=[DAN=Vis alle ressourcegrupper.;
                                 ENU=View all resource groups.];
                      ApplicationArea=#Suite;
                      RunObject=Page 72 }
      { 44      ;1   ;Action    ;
                      CaptionML=[DAN=Varer;
                                 ENU=Items];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om de produkter, du handler med. Varekortet kan vëre af typen lager eller tjeneste for at angive, om varen er en fysisk enhed eller en bestÜr af arbejdstimer. Her angiver du ogsÜ, om varerne pÜ lager eller i indgÜende ordrer automatisk reserveres til udgÜende bilag, og om der er oprettet ordresporingsbindinger mellem behov og forsyning for at afspejle planlëgningshandlinger.;
                                 ENU=View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 31;
                      Image=Item }
      { 45      ;1   ;Action    ;
                      CaptionML=[DAN=Debitorer;
                                 ENU=Customers];
                      ToolTipML=[DAN=FÜ vist eller rediger detaljerede oplysninger om de debitorer, som du handler med. Fra det enkelte debitorkort kan du fÜ adgang til relaterede oplysninger som f.eks. salgsstatistik og igangvërende ordrer, og du kan definere specialpriser og linjerabatter, som debitoren fÜr, nÜr bestemte betingelser er opfyldt.;
                                 ENU=View or edit detailed information for the customers that you trade with. From each customer card, you can open related information, such as sales statistics and ongoing orders, and you can define special prices and line discounts that you grant if certain conditions are met.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 22;
                      Image=Customer }
      { 4       ;1   ;Action    ;
                      CaptionML=[DAN=Timesedler;
                                 ENU=Time Sheets];
                      ToolTipML=[DAN=Giv ressourcer mulighed for at tidsregistere. Efter godkendelsen, hvis en sÜdan krëves, kan timeseddelposterne bogfõres for den relevante sagskladde eller ressourcekladde som en del af registreringen af projektforlõbet. Hvis du vil spare konfigurationstid og sikre, at dataene er korrekte, kan du kopiere sagsplanlëgningslinjerne til timesedlerne.;
                                 ENU=Enable resources to register time. When approved, if approval is required, time sheet entries can be posted to the relevant job journal or resource journal as part of project progress reporting. To save setup time and to ensure data correctness, you can copy job planning lines into time sheets.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 951 }
      { 11      ;1   ;Action    ;
                      Name=Page Manager Time Sheets;
                      CaptionML=[DAN=Leders timesedler;
                                 ENU=Manager Time Sheets];
                      ToolTipML=[DAN=èbn listen med dine timesedler.;
                                 ENU=Open the list of your time sheets.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 953 }
      { 1900000012;0 ;ActionContainer;
                      ActionContainerType=ActivityButtons }
      { 13      ;1   ;ActionGroup;
                      CaptionML=[DAN=Kladder;
                                 ENU=Journals];
                      Image=Journals }
      { 18      ;2   ;Action    ;
                      Name=JobJournals;
                      CaptionML=[DAN=Sagskladder;
                                 ENU=Job Journals];
                      ToolTipML=[DAN=Vis alle sagskladder.;
                                 ENU=View all job journals.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 276;
                      RunPageView=WHERE(Recurring=CONST(No)) }
      { 19      ;2   ;Action    ;
                      Name=JobGLJournals;
                      CaptionML=[DAN=Sagsfinanskladde;
                                 ENU=Job G/L Journals];
                      ToolTipML=[DAN=Vis alle sagsfinanskladder.;
                                 ENU=View all job G/L journals.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 251;
                      RunPageView=WHERE(Template Type=CONST(Jobs),
                                        Recurring=CONST(No)) }
      { 20      ;2   ;Action    ;
                      Name=ResourceJournals;
                      CaptionML=[DAN=Ressourcekladder;
                                 ENU=Resource Journals];
                      ToolTipML=[DAN=Vis alle ressourcekladder.;
                                 ENU=View all resource journals.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 272;
                      RunPageView=WHERE(Recurring=CONST(No)) }
      { 22      ;2   ;Action    ;
                      Name=ItemJournals;
                      CaptionML=[DAN=Varekladder;
                                 ENU=Item Journals];
                      ToolTipML=[DAN=Bogfõr varetransaktioner direkte pÜ varekladden for at regulere lagerbeholdningen i forbindelse med kõb, salg, opreguleringer eller nedreguleringer uden brug af bilag. Du kan gemme hele sët med varekladdelinjer som standardkladder, sÜ du hurtigt kan udfõre tilbagevendende bogfõringer. Der findes en komprimeret version af varekladdefunktionen pÜ varekort, som gõr det muligt at foretage en hurtig regulering af et varelagerantal.;
                                 ENU=Post item transactions directly to the item ledger to adjust inventory in connection with purchases, sales, and positive or negative adjustments without using documents. You can save sets of item journal lines as standard journals so that you can perform recurring postings quickly. A condensed version of the item journal function exists on item cards for quick adjustment of an items inventory quantity.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 262;
                      RunPageView=WHERE(Template Type=CONST(Item),
                                        Recurring=CONST(No)) }
      { 23      ;2   ;Action    ;
                      Name=RecurringJobJournals;
                      CaptionML=[DAN=Sagsgentagelseskladder;
                                 ENU=Recurring Job Journals];
                      ToolTipML=[DAN=Vis alle sagsgentagelseskladder.;
                                 ENU=View all recurring job journals.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 276;
                      RunPageView=WHERE(Recurring=CONST(Yes)) }
      { 46      ;2   ;Action    ;
                      Name=RecurringResourceJournals;
                      CaptionML=[DAN=Ressourcegentagelseskladder;
                                 ENU=Recurring Resource Journals];
                      ToolTipML=[DAN=Vis alle ressourcegentagelseskladder.;
                                 ENU=View all recurring resource journals.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 272;
                      RunPageView=WHERE(Recurring=CONST(Yes)) }
      { 47      ;2   ;Action    ;
                      Name=RecurringItemJournals;
                      CaptionML=[DAN=Varegentagelseskladde;
                                 ENU=Recurring Item Journals];
                      ToolTipML=[DAN=Vis alle varegentagelseskladder.;
                                 ENU=View all recurring item journals.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 262;
                      RunPageView=WHERE(Template Type=CONST(Item),
                                        Recurring=CONST(Yes)) }
      { 62      ;1   ;ActionGroup;
                      CaptionML=[DAN=Bogfõrte dokumenter;
                                 ENU=Posted Documents];
                      ToolTipML=[DAN=Vis historik over salg, leverancer og lager.;
                                 ENU=View history for sales, shipments, and inventory.];
                      Image=FiledPosted }
      { 67      ;2   ;Action    ;
                      CaptionML=[DAN=Bogfõrte leverancer;
                                 ENU=Posted Shipments];
                      ToolTipML=[DAN=èbn listen over bogfõrte leverancer.;
                                 ENU=Open the list of posted shipments.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 142 }
      { 68      ;2   ;Action    ;
                      CaptionML=[DAN=Bogf. salgsfakturaer;
                                 ENU=Posted Sales Invoices];
                      ToolTipML=[DAN=èbn listen over bogfõrte salgsfakturaer.;
                                 ENU=Open the list of posted sales invoices.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 143;
                      Image=PostedOrder }
      { 69      ;2   ;Action    ;
                      CaptionML=[DAN=Bogf. salgskr.notaer;
                                 ENU=Posted Sales Credit Memos];
                      ToolTipML=[DAN=èbn listen over bogfõrte salgskreditnotaer.;
                                 ENU=Open the list of posted sales credit memos.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 144;
                      Image=PostedOrder }
      { 70      ;2   ;Action    ;
                      CaptionML=[DAN=Bogf. kõbsmodtagelser;
                                 ENU=Posted Purchase Receipts];
                      ToolTipML=[DAN=èbn listen over bogfõrte kõbsmodtagelser.;
                                 ENU=Open the list of posted purchase receipts.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 145 }
      { 71      ;2   ;Action    ;
                      CaptionML=[DAN=Bogf. kõbsfakturaer;
                                 ENU=Posted Purchase Invoices];
                      ToolTipML=[DAN=èbn listen over bogfõrte kõbskreditnotaer.;
                                 ENU=Open the list of posted purchase credit memos.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 146 }
      { 72      ;2   ;Action    ;
                      CaptionML=[DAN=Bogfõrte kõbskreditnotaer;
                                 ENU=Posted Purchase Credit Memos];
                      ToolTipML=[DAN=èbn listen over bogfõrte kõbskreditnotaer.;
                                 ENU=Open the list of posted purchase credit memos.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 147 }
      { 73      ;2   ;Action    ;
                      CaptionML=[DAN=Finansjournaler;
                                 ENU=G/L Registers];
                      ToolTipML=[DAN=Vis bogfõrte finansposter.;
                                 ENU=View posted G/L entries.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 116;
                      Image=GLRegisters }
      { 74      ;2   ;Action    ;
                      CaptionML=[DAN=Sagsjournaler;
                                 ENU=Job Registers];
                      ToolTipML=[DAN=Vis alle sagsjournaler.;
                                 ENU=View all job registers.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 278;
                      Image=JobRegisters }
      { 75      ;2   ;Action    ;
                      CaptionML=[DAN=Varejournaler;
                                 ENU=Item Registers];
                      ToolTipML=[DAN=Vis alle varejournaler.;
                                 ENU=View all item registers.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 117;
                      Image=ItemRegisters }
      { 76      ;2   ;Action    ;
                      CaptionML=[DAN=Ressourcejournaler;
                                 ENU=Resource Registers];
                      ToolTipML=[DAN=Vis en liste over alle ressourcejournaler. Hver gang en ressourcepost bliver bogfõrt, oprettes der en ressourcejournal. Hver journal viser det fõrste og sidste lõbenummer for posterne i den. Du kan bruge oplysningerne i en ressourcejournal til at dokumentere, hvornÜr posterne er bogfõrt.;
                                 ENU=View a list of all the resource registers. Every time a resource entry is posted, a register is created. Every register shows the first and last entry numbers of its entries. You can use the information in a resource register to document when entries were posted.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 274;
                      Image=ResourceRegisters }
      { 85      ;1   ;ActionGroup;
                      CaptionML=[DAN=Selvbetjening;
                                 ENU=Self-Service];
                      ToolTipML=[DAN=Administrer dine timesedler og opgaver.;
                                 ENU=Manage your time sheets and assignments.];
                      Image=HumanResources }
      { 82      ;2   ;Action    ;
                      CaptionML=[DAN=Timesedler;
                                 ENU=Time Sheets];
                      ToolTipML=[DAN=Giv ressourcer mulighed for at tidsregistere. Efter godkendelsen, hvis en sÜdan krëves, kan timeseddelposterne bogfõres for den relevante sagskladde eller ressourcekladde som en del af registreringen af projektforlõbet. Hvis du vil spare konfigurationstid og sikre, at dataene er korrekte, kan du kopiere sagsplanlëgningslinjerne til timesedlerne.;
                                 ENU=Enable resources to register time. When approved, if approval is required, time sheet entries can be posted to the relevant job journal or resource journal as part of project progress reporting. To save setup time and to ensure data correctness, you can copy job planning lines into time sheets.];
                      ApplicationArea=#Suite;
                      RunObject=Page 951;
                      Gesture=None }
      { 80      ;2   ;Action    ;
                      Name=Page Time Sheet List Open;
                      CaptionML=[DAN=èbn;
                                 ENU=Open];
                      ToolTipML=[DAN=èbn kortet for den valgte record.;
                                 ENU=Open the card for the selected record.];
                      ApplicationArea=#Suite;
                      RunObject=Page 951;
                      RunPageView=WHERE(Open Exists=CONST(Yes)) }
      { 79      ;2   ;Action    ;
                      Name=Page Time Sheet List Submitted;
                      CaptionML=[DAN=Sendt;
                                 ENU=Submitted];
                      ToolTipML=[DAN=FÜ vist sendte timesedler.;
                                 ENU=View submitted time sheets.];
                      ApplicationArea=#Suite;
                      RunObject=Page 951;
                      RunPageView=WHERE(Submitted Exists=CONST(Yes)) }
      { 78      ;2   ;Action    ;
                      Name=Page Time Sheet List Rejected;
                      CaptionML=[DAN=Afvist;
                                 ENU=Rejected];
                      ToolTipML=[DAN=FÜ vist afviste timesedler.;
                                 ENU=View rejected time sheets.];
                      ApplicationArea=#Suite;
                      RunObject=Page 951;
                      RunPageView=WHERE(Rejected Exists=CONST(Yes)) }
      { 17      ;2   ;Action    ;
                      Name=Page Time Sheet List Approved;
                      CaptionML=[DAN=Godkendt;
                                 ENU=Approved];
                      ToolTipML=[DAN=FÜ vist godkendte timesedler.;
                                 ENU=View approved time sheets.];
                      ApplicationArea=#Suite;
                      RunObject=Page 951;
                      RunPageView=WHERE(Approved Exists=CONST(Yes)) }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 58      ;1   ;ActionGroup;
                      Name=NewGroup;
                      CaptionML=[DAN=Ny;
                                 ENU=New];
                      ActionContainerType=NewDocumentItems }
      { 59      ;2   ;Action    ;
                      Name=Page Job;
                      CaptionML=[DAN=Sag;
                                 ENU=Job];
                      ToolTipML=[DAN=Opret en ny sag.;
                                 ENU=Create a new job.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 1816;
                      Promoted=Yes;
                      Image=Job;
                      PromotedCategory=New;
                      RunPageMode=Create }
      { 57      ;2   ;Action    ;
                      CaptionML=[DAN=S&agskladde;
                                 ENU=Job J&ournal];
                      ToolTipML=[DAN=èbn siden Rediger sagskladde.;
                                 ENU=Open the Edit Job Journal page.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 201;
                      Promoted=Yes;
                      Image=JobJournal;
                      PromotedCategory=New }
      { 52      ;2   ;Action    ;
                      CaptionML=[DAN=Sagsfinans&kladde;
                                 ENU=Job G/L &Journal];
                      ToolTipML=[DAN=èbn siden Rediger sagsfinanskladde.;
                                 ENU=Open the Edit Job G/L Journal page.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 1020;
                      Promoted=Yes;
                      Image=GLJournal;
                      PromotedCategory=New }
      { 51      ;2   ;Action    ;
                      CaptionML=[DAN=R&essourcekladde;
                                 ENU=R&esource Journal];
                      ToolTipML=[DAN=èbn siden Rediger ressourcekladde.;
                                 ENU=Open the Edit Resource Journal page.];
                      ApplicationArea=#Suite;
                      RunObject=Page 207;
                      Promoted=Yes;
                      Image=ResourceJournal;
                      PromotedCategory=New }
      { 48      ;2   ;Action    ;
                      CaptionML=[DAN=Opret &salgsfaktura for sag;
                                 ENU=Job &Create Sales Invoice];
                      ToolTipML=[DAN=Kõr rapporten Opret salgsfaktura for sag.;
                                 ENU=Run the Job Create Sales Invoice report.];
                      ApplicationArea=#Jobs;
                      RunObject=Report 1093;
                      Image=CreateJobSalesInvoice }
      { 49      ;2   ;Action    ;
                      CaptionML=[DAN=Opdater &varekostpris for sag;
                                 ENU=Update Job I&tem Cost];
                      ToolTipML=[DAN=Kõr rapporten Opdater varekostpris for sag.;
                                 ENU=Run Update Job Item Cost report.];
                      ApplicationArea=#Suite;
                      RunObject=Report 1095;
                      Image=Report }
      { 50      ;1   ;ActionGroup;
                      CaptionML=[DAN=Rapporter;
                                 ENU=Reports] }
      { 30      ;2   ;ActionGroup;
                      CaptionML=[DAN=Sagsrapporter;
                                 ENU=Job Reports];
                      Image=ReferenceData }
      { 29      ;3   ;Action    ;
                      CaptionML=[DAN=Sags&analyse;
                                 ENU=Job &Analysis];
                      ToolTipML=[DAN=Vis rapporten Sagsanalyse.;
                                 ENU=View the Job Analysis report.];
                      ApplicationArea=#Jobs;
                      RunObject=Report 1008;
                      Image=Report }
      { 26      ;3   ;Action    ;
                      CaptionML=[DAN=Sag - realiseret/&budget;
                                 ENU=Job Actual To &Budget];
                      ToolTipML=[DAN=Vis rapporten Sag - realiseret/budget.;
                                 ENU=View the Job Actual to Budget report.];
                      ApplicationArea=#Jobs;
                      RunObject=Report 1009;
                      Image=Report }
      { 25      ;3   ;Action    ;
                      CaptionML=[DAN=Sag - pla&nlëgningslinje;
                                 ENU=Job - Pla&nning Line];
                      ToolTipML=[DAN=Definer sagsopgaver for at hente alle oplysninger, du vil spore for en sag. Du kan bruge planlëgningslinjer at tilfõje oplysninger, f.eks. hvilke ressourcer der krëves, eller for at registrere, hvilke varer der skal bruges til at udfõre kõrslen.;
                                 ENU=Define job tasks to capture any information that you want to track for a job. You can use planning lines to add information such as what resources are required or to capture what items are needed to perform the job.];
                      ApplicationArea=#Jobs;
                      RunObject=Report 1006;
                      Image=Report }
      { 16      ;3   ;Separator  }
      { 15      ;3   ;Action    ;
                      CaptionML=[DAN=Sag - faktureringsforsla&g;
                                 ENU=Job Su&ggested Billing];
                      ToolTipML=[DAN=Vis rapporten Sag - foreslÜet fakturering.;
                                 ENU=View the Job Suggested Billing report.];
                      ApplicationArea=#Jobs;
                      RunObject=Report 1011;
                      Image=Report }
      { 14      ;3   ;Action    ;
                      CaptionML=[DAN=Sager pr. &debitor;
                                 ENU=Jobs per &Customer];
                      ToolTipML=[DAN=Vis rapporten Sager pr. debitor.;
                                 ENU=View the Jobs per Customer report.];
                      ApplicationArea=#Jobs;
                      RunObject=Report 1012;
                      Image=Report }
      { 8       ;3   ;Action    ;
                      CaptionML=[DAN=Varer pr. &sag;
                                 ENU=Items per &Job];
                      ToolTipML=[DAN=Vis rapporten Varer pr. sag.;
                                 ENU=View the Items per Job report.];
                      ApplicationArea=#Jobs;
                      RunObject=Report 1013;
                      Image=Report }
      { 6       ;3   ;Action    ;
                      CaptionML=[DAN=Sager pr. &vare;
                                 ENU=Jobs per &Item];
                      ToolTipML=[DAN=Vis rapporten Sager pr. vare.;
                                 ENU=View the Jobs per Item report.];
                      ApplicationArea=#Jobs;
                      RunObject=Report 1014;
                      Image=Report }
      { 84      ;2   ;ActionGroup;
                      CaptionML=[DAN=Fravërsrapporter;
                                 ENU=Absence Reports];
                      Image=ReferenceData }
      { 83      ;3   ;Action    ;
                      Name=Employee - Staff Absences;
                      CaptionML=[DAN=Medarbejder - Personalefravër;
                                 ENU=Employee - Staff Absences];
                      ToolTipML=[DAN=Vis rapporten Personalefravër.;
                                 ENU=View the Staff Absences report.];
                      ApplicationArea=#BasicHR;
                      RunObject=Report 5204;
                      Image=Report }
      { 81      ;3   ;Action    ;
                      Name=Employee - Absences by Causes;
                      CaptionML=[DAN=Medarbejder - Fravër pr. Ürsag;
                                 ENU=Employee - Absences by Causes];
                      ToolTipML=[DAN=Vis rapporten Fravër pr. Ürsag.;
                                 ENU=View the Absences by Causes report.];
                      ApplicationArea=#BasicHR;
                      RunObject=Report 5205;
                      Image=Report }
      { 60      ;1   ;ActionGroup;
                      CaptionML=[DAN=Administrer;
                                 ENU=Manage] }
      { 61      ;2   ;ActionGroup;
                      Name=Timesheet;
                      CaptionML=[DAN=Timeseddel;
                                 ENU=Time Sheet];
                      Image=Worksheets }
      { 65      ;3   ;Action    ;
                      Name=Create Time Sheets;
                      CaptionML=[DAN=Opret timesedler;
                                 ENU=Create Time Sheets];
                      ToolTipML=[DAN=Opret nye timesedler for de valgte ressourcer.;
                                 ENU=Create new time sheets for selected resources.];
                      ApplicationArea=#Jobs;
                      RunObject=Report 950;
                      Image=JobTimeSheet }
      { 66      ;3   ;Action    ;
                      Name=Manage Time Sheets;
                      CaptionML=[DAN=Leders timesedler;
                                 ENU=Manager Time Sheets];
                      ToolTipML=[DAN=èbn listen med dine timesedler.;
                                 ENU=Open the list of your time sheets.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 952;
                      Image=JobTimeSheet }
      { 1       ;3   ;Action    ;
                      CaptionML=[DAN=Leders timeseddel efter sag;
                                 ENU=Manager Time Sheet by Job];
                      ToolTipML=[DAN=èbn listen med dine timesedler efter sag.;
                                 ENU=Open the list of your time sheets by job.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 954;
                      Image=JobTimeSheet }
      { 5       ;3   ;Separator  }
      { 7       ;3   ;Separator  }
      { 63      ;2   ;ActionGroup;
                      Name=WIP;
                      CaptionML=[DAN=Sagsafslutning;
                                 ENU=Job Closing];
                      Image=Job }
      { 9       ;3   ;Action    ;
                      CaptionML=[DAN=Be&regn VIA - finansafstemning;
                                 ENU=Job Calculate &WIP];
                      ToolTipML=[DAN=Beregn de finansposter, der skal opdateres, eller luk sagen.;
                                 ENU=Calculate the general ledger entries needed to update or close the job.];
                      ApplicationArea=#Jobs;
                      RunObject=Report 1086;
                      Image=CalculateWIP }
      { 10      ;3   ;Action    ;
                      CaptionML=[DAN=&Bogfõr VIA - finansafstemning;
                                 ENU=Jo&b Post WIP to G/L];
                      ToolTipML=[DAN=Bogfõr de poster, der er beregnet for dine sager, i finansregnskabet.;
                                 ENU=Post to the general ledger the entries calculated for your jobs.];
                      ApplicationArea=#Jobs;
                      RunObject=Report 1085;
                      Image=PostOrder }
      { 27      ;3   ;Action    ;
                      CaptionML=[DAN=Igangvërende arbejder for sag;
                                 ENU=Job WIP];
                      ToolTipML=[DAN=Oversigt over igangvërende arbejde for sag;
                                 ENU=Overview of Job WIP];
                      ApplicationArea=#Suite;
                      RunObject=Page 1027;
                      Image=WIP }
      { 64      ;1   ;ActionGroup;
                      CaptionML=[DAN=Oversigt;
                                 ENU=History] }
      { 24      ;2   ;Action    ;
                      CaptionML=[DAN=Navi&ger;
                                 ENU=Navi&gate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes for bilagsnummeret og bogfõringsdatoen pÜ den valgte post eller det valgte bilag.;
                                 ENU=Find all entries and documents that exist for the document number and posting date on the selected entry or document.];
                      ApplicationArea=#Suite;
                      RunObject=Page 344;
                      Image=Navigate }
    }
  }
  CONTROLS
  {
    { 1900000008;0;Container;
                ContainerType=RoleCenterArea }

    { 1900724808;1;Group   }

    { 33  ;2   ;Part      ;
                ApplicationArea=#Jobs;
                PagePartID=Page9068;
                PartType=Page }

    { 77  ;2   ;Part      ;
                ApplicationArea=#Suite;
                PagePartID=Page9042;
                PartType=Page }

    { 34  ;2   ;Part      ;
                ApplicationArea=#Jobs;
                PagePartID=Page9154;
                PartType=Page }

    { 56  ;2   ;Part      ;
                Name=Job Actual Price to Budget Price;
                CaptionML=[DAN=Sag - faktisk pris ift. budgetteret pris;
                           ENU=Job Actual Price to Budget Price];
                ApplicationArea=#Jobs;
                PagePartID=Page731;
                PartType=Page }

    { 1900724708;1;Group   }

    { 32  ;2   ;Part      ;
                Name=Job Profitability;
                CaptionML=[DAN=Sagsrentabilitet;
                           ENU=Job Profitability];
                ApplicationArea=#Jobs;
                PagePartID=Page759;
                PartType=Page }

    { 28  ;2   ;Part      ;
                Name=Job Actual Cost to Budget Cost;
                CaptionML=[DAN=Sag - faktisk kostpris ift. budgetteret kostpris;
                           ENU=Job Actual Cost to Budget Cost];
                ApplicationArea=#Jobs;
                PagePartID=Page730;
                PartType=Page }

    { 1907692008;2;Part   ;
                ApplicationArea=#Advanced;
                PagePartID=Page9150;
                Visible=false;
                Enabled=false;
                Editable=false;
                PartType=Page }

    { 21  ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page675;
                Visible=false;
                PartType=Page }

    { 31  ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page681;
                Visible=FALSE;
                PartType=Page }

    { 1901377608;2;Part   ;
                ApplicationArea=#Advanced;
                Visible=False;
                PartType=System;
                SystemPartID=MyNotes }

  }
  CODE
  {

    BEGIN
    END.
  }
}

