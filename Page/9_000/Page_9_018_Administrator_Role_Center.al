OBJECT Page 9018 Administrator Role Center
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[@@@="{Dependency=Match,""ProfileDescription_ITMANAGER""}";
               DAN=It-chef;
               ENU=IT Manager];
    PageType=RoleCenter;
    ActionList=ACTIONS
    {
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 33      ;1   ;Action    ;
                      CaptionML=[DAN=Kontroller for ne&gativt lager;
                                 ENU=Check on Ne&gative Inventory];
                      ToolTipML=[DAN=Vis en liste over varer med negativ beholdning og Übne lagerdokumenter for en lokation.;
                                 ENU=View a list of items with negative inventory and open warehouse documents for a location.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 5757;
                      Image=Report }
      { 1900000011;0 ;ActionContainer;
                      ToolTipML=[DAN=Konfigurer brugere og vërdier pÜ tvërs af produkter, f.eks. nummerserier og postnumre.;
                                 ENU=Set up users and cross-product values, such as number series and post codes.];
                      ActionContainerType=HomeItems }
      { 46      ;1   ;Action    ;
                      CaptionML=[DAN=Opgavekõposter;
                                 ENU=Job Queue Entries];
                      ToolTipML=[DAN=Vis eller rediger de opgaver, der er konfigureret til at kõre virksomhedsprocesser automatisk ved brugerdefinerede intervaller.;
                                 ENU=View or edit the tasks that are set up to run business processes automatically at user-defined intervals.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 672 }
      { 2       ;1   ;Action    ;
                      CaptionML=[DAN=Brugeropsëtning;
                                 ENU=User Setup];
                      ToolTipML=[DAN=Konfigurer brugere, og definer deres rettigheder.;
                                 ENU=Set up users and define their permissions.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 119;
                      Image=UserSetup }
      { 3       ;1   ;Action    ;
                      CaptionML=[DAN=Nummerserie;
                                 ENU=No. Series];
                      ToolTipML=[DAN=Konfigurer den nummerserie, som et nyt nummer automatisk tildeles til nye kort og dokumenter fra, som f.eks. varekort og salgsfakturaer.;
                                 ENU=Set up the number series from which a new number is automatically assigned to new cards and documents, such as item cards and sales invoices.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 456 }
      { 7       ;1   ;Action    ;
                      CaptionML=[DAN=Brugeropsëtning af godkendelser;
                                 ENU=Approval User Setup];
                      ToolTipML=[DAN=Vis eller rediger oplysninger om workflow-brugere, der er involveret i godkendelsesprocesser, f.eks. belõbsgodkendelsesgrënser for bestemte typer anmodninger og stedfortrëdergodkendere, som godkendelsesanmodninger er uddelegeret til, nÜr den oprindelige godkender er fravërende.;
                                 ENU=View or edit information about workflow users who are involved in approval processes, such as approval amount limits for specific types of requests and substitute approvers to whom approval requests are delegated when the original approver is absent.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 663 }
      { 8       ;1   ;Action    ;
                      CaptionML=[DAN=Brugergrupper for workflow;
                                 ENU=Workflow User Groups];
                      ToolTipML=[DAN=Vis eller rediger listen over brugere, der indgÜr i workflows, og hvilke workflow brugergrupper de tilhõrer.;
                                 ENU=View or edit the list of users that take part in workflows and which workflow user groups they belong to.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 1533;
                      Image=Users }
      { 57      ;1   ;Action    ;
                      CaptionML=[DAN=Workflows;
                                 ENU=Workflows];
                      ToolTipML=[DAN=Konfigurer eller aktivÇr workflows, som forbinder de opgaver i forretningsprocessen, der udfõres af forskellige brugere. Systemhandlinger som f.eks. automatisk bogfõring kan inkluderes som trin i workflows, fõr eller efter brugernes opgaver. Anmodning om og tildeling af godkendelse for at oprette nye records er typiske workflowtrin.;
                                 ENU=Set up or enable workflows that connect business-process tasks performed by different users. System tasks, such as automatic posting, can be included as steps in workflows, preceded or followed by user tasks. Requesting and granting approval to create new records are typical workflow steps.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 1500;
                      Image=ApprovalSetup }
      { 9       ;1   ;Action    ;
                      CaptionML=[DAN=Liste over dataskabeloner;
                                 ENU=Data Templates List];
                      ToolTipML=[DAN=Viser eller rediger den skabelon, der bruges til dataoverfõrsel.;
                                 ENU=View or edit template that are being used for data migration.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 8620 }
      { 10      ;1   ;Action    ;
                      CaptionML=[DAN=Basiskalenderoversigt;
                                 ENU=Base Calendar List];
                      ToolTipML=[DAN=Vis oversigten over kalendere til din virksomhed og dine forretningspartnere for at definere de aftalte arbejdsdage.;
                                 ENU=View the list of calendars that exist for your company and your business partners to define the agreed working days.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 7601 }
      { 11      ;1   ;Action    ;
                      CaptionML=[DAN=Postnumre;
                                 ENU=Post Codes];
                      ToolTipML=[DAN=Konfigurer postnumre for de byer, hvor dine forretningspartnere er placeret.;
                                 ENU=Set up the post codes of cities where your business partners are located.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 367 }
      { 12      ;1   ;Action    ;
                      CaptionML=[DAN=èrsagskoder;
                                 ENU=Reason Codes];
                      ToolTipML=[DAN=Vis eller konfigurer koder, der angiver Ürsager til oprettelse af poster (f.eks. Returvare), for at angive, hvorfor en kõbskreditnota er bogfõrt.;
                                 ENU=View or set up codes that specify reasons why entries were created, such as Return, to specify why a purchase credit memo was posted.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 259 }
      { 13      ;1   ;Action    ;
                      CaptionML=[DAN=Udvidet tekst;
                                 ENU=Extended Text];
                      ToolTipML=[DAN=Vis eller rediger supplerende tekst til varebeskrivelserne. Den udvidede tekst kan indsëttes under feltet Beskrivelse i dokumentlinjerne for varen.;
                                 ENU=View or edit additional text for the descriptions of items. Extended text can be inserted under the Description field on document lines for the item.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 391 }
      { 1900000012;0 ;ActionContainer;
                      ActionContainerType=ActivityButtons }
      { 53      ;1   ;ActionGroup;
                      CaptionML=[DAN=Opgavekõ;
                                 ENU=Job Queue];
                      ToolTipML=[DAN=Angiv, hvordan rapporter, kõrsler og codeunits kõres.;
                                 ENU=Specify how reports, batch jobs, and codeunits are run.];
                      Image=ExecuteBatch }
      { 54      ;2   ;Action    ;
                      Name=JobQueue_JobQueueEntries;
                      CaptionML=[DAN=Opgavekõposter;
                                 ENU=Job Queue Entries];
                      ToolTipML=[DAN=Vis eller rediger de opgaver, der er konfigureret til at kõre virksomhedsprocesser automatisk ved brugerdefinerede intervaller.;
                                 ENU=View or edit the tasks that are set up to run business processes automatically at user-defined intervals.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 672 }
      { 55      ;2   ;Action    ;
                      CaptionML=[DAN=Kategoriliste til opgavekõ;
                                 ENU=Job Queue Category List];
                      ToolTipML=[DAN=Vis eller rediger de opgavekategorier, der er konfigureret til at kõre virksomhedsprocesser automatisk ved brugerdefinerede intervaller.;
                                 ENU=View or edit the task categories that are set up to run business processes automatically at user-defined intervals.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 671 }
      { 56      ;2   ;Action    ;
                      CaptionML=[DAN=Logposter i opgavekõ;
                                 ENU=Job Queue Log Entries];
                      ToolTipML=[DAN=Vis oplysninger om opgavekõposter, der er kõrer ikke eller er kõrt pÜ grund af fejl, herunder opgavekõposter med status som afventende.;
                                 ENU=View information for job queue entries that have run or have not run due to errors including job queue entries that have the status On Hold.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 674 }
      { 59      ;1   ;ActionGroup;
                      CaptionML=[DAN=Workflow;
                                 ENU=Workflow];
                      ToolTipML=[DAN=Opsët workflow og godkendelsesbrugere, og opret workflows, der styrer, hvordan brugere interagerer i processer.;
                                 ENU=Set up workflow and approval users, and create workflows that govern how the users interact in processes.] }
      { 60      ;2   ;Action    ;
                      Name=Workflows;
                      CaptionML=[DAN=Workflows;
                                 ENU=Workflows];
                      ToolTipML=[DAN=Konfigurer eller aktivÇr workflows, som forbinder de opgaver i forretningsprocessen, der udfõres af forskellige brugere. Systemhandlinger som f.eks. automatisk bogfõring kan inkluderes som trin i workflows, fõr eller efter brugernes opgaver. Anmodning om og tildeling af godkendelse for at oprette nye records er typiske workflowtrin.;
                                 ENU=Set up or enable workflows that connect business-process tasks performed by different users. System tasks, such as automatic posting, can be included as steps in workflows, preceded or followed by user tasks. Requesting and granting approval to create new records are typical workflow steps.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 1500;
                      Image=ApprovalSetup }
      { 62      ;2   ;Action    ;
                      CaptionML=[DAN=Workflowskabeloner;
                                 ENU=Workflow Templates];
                      ToolTipML=[DAN=Vis oversigten over workflowskabeloner, der findes i standardversion af Dynamics NAV til understõttede scenarier. Koderne til workflowskabeloner, der tilfõjes af Microsoft, har MS- som prëfiks. Du kan ikke ëndre en workflowskabelon, men du kan bruge den til at oprette et workflow.;
                                 ENU=View the list of workflow templates that exist in the standard version of Dynamics NAV for supported scenarios. The codes for workflow templates that are added by Microsoft are prefixed with MS-. You cannot modify a workflow template, but you use it to create a workflow.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 1505;
                      Image=Setup }
      { 64      ;2   ;Action    ;
                      Name=ApprovalUserSetup;
                      CaptionML=[DAN=Brugeropsëtning af godkendelser;
                                 ENU=Approval User Setup];
                      ToolTipML=[DAN=Vis eller rediger oplysninger om workflow-brugere, der er involveret i godkendelsesprocesser, f.eks. belõbsgodkendelsesgrënser for bestemte typer anmodninger og stedfortrëdergodkendere, som godkendelsesanmodninger er uddelegeret til, nÜr den oprindelige godkender er fravërende.;
                                 ENU=View or edit information about workflow users who are involved in approval processes, such as approval amount limits for specific types of requests and substitute approvers to whom approval requests are delegated when the original approver is absent.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 663 }
      { 61      ;2   ;Action    ;
                      Name=WorkflowUserGroups;
                      CaptionML=[DAN=Brugergrupper for workflow;
                                 ENU=Workflow User Groups];
                      ToolTipML=[DAN=Vis eller rediger listen over brugere, der indgÜr i workflows, og hvilke workflow brugergrupper de tilhõrer.;
                                 ENU=View or edit the list of users that take part in workflows and which workflow user groups they belong to.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 1533;
                      Image=Users }
      { 16      ;1   ;ActionGroup;
                      CaptionML=[DAN=Intrastat;
                                 ENU=Intrastat];
                      ToolTipML=[DAN=Konfigurer Intrastat-rapporteringsvërdier, f.eks. varekoder.;
                                 ENU=Set up Intrastat reporting values, such as tariff numbers.];
                      Image=Intrastat }
      { 14      ;2   ;Action    ;
                      CaptionML=[DAN=Varekoder;
                                 ENU=Tariff Numbers];
                      ToolTipML=[DAN=Vis eller rediger oversigten over tarifnumre for varer, som din virksomhed kõber og sëlger i EU. Numrene bruges i forbindelse med Intrastat-rapportering. Skattemyndighederne offentliggõr tarifnumre, der er 8-cifrede koder, for et stort antal produkter.;
                                 ENU=View or edit the list of tariff numbers for item that your company buys and sells in the EU. The numbers are used to report Intrastat. The tax and customs authorities publish tariff numbers, which are eight-digit item codes, for a large number of products.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 310 }
      { 15      ;2   ;Action    ;
                      CaptionML=[DAN=Transaktionsarter;
                                 ENU=Transaction Types];
                      ToolTipML=[DAN=Vis oplysninger, som alle virksomheder i EU skal rapportere om deres handel med andre EU-lande/-omrÜder i forbindelse med Intrastat-rapportering.;
                                 ENU=View information that all EU businesses must report for their trade with other EU countries/regions for Intrastat reporting.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 308 }
      { 17      ;2   ;Action    ;
                      CaptionML=[DAN=Transaktionsspecifikationer;
                                 ENU=Transaction Specifications];
                      ToolTipML=[DAN=Vis flere oplysninger om rapportering til Intrastat.;
                                 ENU=View additional information about Intrastat reporting.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 406 }
      { 18      ;2   ;Action    ;
                      CaptionML=[DAN=TransportmÜder;
                                 ENU=Transport Methods];
                      ToolTipML=[DAN=Vis oplysninger om, hvordan dine varer transporteres mellem EU-lande/-omrÜder ved rapportering til Intrastat.;
                                 ENU=View information about how your items are transported between EU country/regions, for Intrastat reporting.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 309 }
      { 19      ;2   ;Action    ;
                      CaptionML=[DAN=Indfõrsels-/udfõrselssteder;
                                 ENU=Entry/Exit Points];
                      ToolTipML=[DAN=Vis eller rediger koder for den lokation, som varer fra udlandet sendes til, eller hvorfra der afsendes varer i udlandet. Oplysningerne bruges ved rapportering til Intrastat.;
                                 ENU=View or edit codes for the location to which items from abroad are shipped or from which you ship items abroad. The information is used when reporting to Intrastat.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 394 }
      { 20      ;2   ;Action    ;
                      CaptionML=[DAN=OmrÜder;
                                 ENU=Areas];
                      ToolTipML=[DAN=Vis eller rediger oplysninger om de omrÜder, som du har defineret for din konfiguration. Oplysningerne omfatter en optëlling af, hvor mange tabeller der ligger inden for hver kategori.;
                                 ENU=View or edit information about the areas that you have set up for your configuration. The information includes a count of how many tables fall within each category.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 405 }
      { 39      ;1   ;ActionGroup;
                      CaptionML=[DAN=SE/CVR-numre.;
                                 ENU=VAT Registration Numbers];
                      ToolTipML=[DAN=Konfigurer og vedligehold SE/CVR-nummerformater.;
                                 ENU=Set up and maintain VAT registration number formats.];
                      Image=Bank }
      { 22      ;2   ;Action    ;
                      CaptionML=[DAN=SE/CVR-nr.formater;
                                 ENU=VAT Registration No. Formats];
                      ToolTipML=[DAN=FÜ vist formater for momsregistreringsnumre i forskellige lande/omrÜder.;
                                 ENU=View the formats for VAT registration number in different countries/regions.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 575 }
      { 6       ;1   ;ActionGroup;
                      CaptionML=[DAN=Analysevisning;
                                 ENU=Analysis View];
                      ToolTipML=[DAN=Konfigurer visninger til analyse af salg, kõb og lager.;
                                 ENU=Set up views for analysis of sales, purchases, and inventory.];
                      Image=AnalysisView }
      { 49      ;2   ;Action    ;
                      CaptionML=[DAN=Salgsanalysevisningsliste;
                                 ENU=Sales Analysis View List];
                      ToolTipML=[DAN=Vis oversigten over visninger, som bruges til at analysere salgsmëngderne. Du kan ogsÜ bruge rapporten til at analysere debitorprëstationer.;
                                 ENU=View the list of views that you use to analyze the dynamics of your sales volumes. You can also use the report to analyze your customer's performance.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9371 }
      { 50      ;2   ;Action    ;
                      CaptionML=[DAN=Kõbsanalysevisningsliste;
                                 ENU=Purchase Analysis View List];
                      ToolTipML=[DAN=Vis oversigten over visninger, som bruges til at analysere kõbsmëngderne. Du kan ogsÜ bruge rapporten til at analysere kreditorprëstationer og kõbspriser.;
                                 ENU=View the list of views that you use to analyze the dynamics of your purchase volumes. You can also use the report to analyze your vendors' performance and purchase prices.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9370 }
      { 51      ;2   ;Action    ;
                      CaptionML=[DAN=Lageranalysevisningsliste;
                                 ENU=Inventory Analysis View List];
                      ToolTipML=[DAN=Vis eller rediger dine foruddefinerede visninger af varer pÜ en bestemt lokation i henhold til deres kombination af dimensioner.;
                                 ENU=View or edit your predefined views of items at a specified location per their combination of dimensions.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9372 }
      { 4       ;0   ;ActionContainer;
                      ActionContainerType=NewDocumentItems }
      { 21      ;1   ;Action    ;
                      CaptionML=[DAN=Kõbs&ordre;
                                 ENU=Purchase &Order];
                      ToolTipML=[DAN=Opret en ny kõbsordre.;
                                 ENU=Create a new purchase order.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 50;
                      Promoted=No;
                      Image=Document;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 23      ;1   ;Separator ;
                      CaptionML=[DAN=Opgaver;
                                 ENU=Tasks];
                      IsHeader=Yes }
      { 24      ;1   ;Action    ;
                      CaptionML=[DAN=Virksomhedsopl&ysninger;
                                 ENU=Com&pany Information];
                      ToolTipML=[DAN=Angiv grundlëggende oplysninger om din virksomhed, der angiver et komplet sët regnskabsoplysninger og Ürsregnskaber for en virksomhed. Du skal angive oplysninger om f.eks. navn, adresser og leveringsoplysninger. Oplysningerne i vinduet Virksomhedsoplysninger udskrives pÜ bilag , f.eks. salgsfakturaer.;
                                 ENU=Specify basic information about your company, which designates a complete set of accounting information and financial statements for a business entity. You enter information such as name, addresses, and shipping information. The information in the Company Information window is printed on documents, such as sales invoices.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 1;
                      Image=CompanyInformation }
      { 25      ;1   ;Action    ;
                      CaptionML=[DAN=&HÜndter typografiark;
                                 ENU=&Manage Style Sheets];
                      ToolTipML=[DAN=Skift formateringen af datafiler, som du importerer og eksporterer som Excel-filer.;
                                 ENU=Change the formatting of data files that you import and export as Excel files.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 697;
                      Image=StyleSheet }
      { 26      ;1   ;Action    ;
                      CaptionML=[DAN=O&verflytningsoversigt;
                                 ENU=Migration O&verview];
                      ToolTipML=[DAN=Vis dataoverfõrselsoversigten.;
                                 ENU=Show the data migration overview.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 8614;
                      Image=Migration }
      { 27      ;1   ;Action    ;
                      CaptionML=[DAN=&Flyt vedhëftede filer;
                                 ENU=Relocate &Attachments];
                      ToolTipML=[DAN=Angiv, hvor vedhëftede filer skal gemmes.;
                                 ENU=Specify where to store attachments.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 5181;
                      Image=ChangeTo }
      { 28      ;1   ;Action    ;
                      CaptionML=[DAN=Opret l&agerlokation;
                                 ENU=Create Warehouse &Location];
                      ToolTipML=[DAN=Giv en eksisterende lagerbeholdningslokation mulighed for at bruge zoner og placeringer og fungere som en lagerlokation. Kõrslen opretter de oprindelige lagerposter til en lagerreguleringsplacering for alle varer med lager pÜ denne lokation. Det er nõdvendigt at udfõre en fysisk lageropgõrelse, nÜr kõrslen er fërdig, sÜ de oprindelige poster kan afstemmes ved at bogfõre de fysiske lagerposter.;
                                 ENU=Enable an existing inventory location to use zones and bins to operate as a warehouse location. The batch job creates initial warehouse entries for the warehouse adjustment bin for all items that have inventory in the location. It is necessary to perform a physical inventory after this batch job is finished so that these initial entries can be balanced by posting warehouse physical inventory entries.];
                      ApplicationArea=#Warehouse;
                      RunObject=Report 5756;
                      Image=NewWarehouse }
      { 29      ;1   ;Action    ;
                      CaptionML=[DAN=Ops&ëtning af ëndringslog;
                                 ENU=C&hange Log Setup];
                      ToolTipML=[DAN=Definer, hvilke kontraktëndringer der logfõres.;
                                 ENU=Define which contract changes are logged.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 592;
                      Image=LogSetup }
      { 30      ;1   ;Separator  }
      { 31      ;1   ;ActionGroup;
                      CaptionML=[DAN=R&ediger opsëtning;
                                 ENU=&Change Setup];
                      Image=Setup }
      { 38      ;2   ;Action    ;
                      CaptionML=[DAN=Konfigurationssp&õrgeskema;
                                 ENU=Setup &Questionnaire];
                      ToolTipML=[DAN=Opret et nyt spõrgeskema, som debitoren skal udfylde for at strukturere og dokumentere lõsningsbehovene og konfigurere data.;
                                 ENU=Create a new questionnaires that the customer will fill in to structure and document the solution needs and setup data.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 8610;
                      Image=QuestionaireSetup }
      { 40      ;2   ;Action    ;
                      CaptionML=[DAN=Opsëtning af &Finans;
                                 ENU=&General Ledger Setup];
                      ToolTipML=[DAN=Definer dine regnskabspolitikker, f.eks. fakturaafrunding, valutakode for den lokale valuta, adresseformater, og om du vil bruge en ekstra rapporteringsvaluta.;
                                 ENU=Define your accounting policies, such as invoice rounding details, the currency code for your local currency, address formats, and whether you want to use an additional reporting currency.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 118;
                      Image=Setup }
      { 41      ;2   ;Action    ;
                      CaptionML=[DAN=Salgsopsë&tning;
                                 ENU=Sales && Re&ceivables Setup];
                      ToolTipML=[DAN=Definer dine generelle politikker for fakturering af salg og for returneringer, som f.eks. hvornÜr krediterings- og beholdningsadvarsler skal vises, og hvordan salgsrabatter skal bogfõres. Konfigurer dine nummerserier for oprettelse af debitorer og forskellige salgsbilag.;
                                 ENU=Define your general policies for sales invoicing and returns, such as when to show credit and stockout warnings and how to post sales discounts. Set up your number series for creating customers and different sales documents.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 459;
                      Image=Setup }
      { 42      ;2   ;Action    ;
                      CaptionML=[DAN=Kõ&bsopsëtning;
                                 ENU=Purchase && &Payables Setup];
                      ToolTipML=[DAN=Definer dine generelle politikker for fakturering af kõb og for returneringer, som f.eks. om kreditorfakturanumre skal angives, og hvordan kõbsrabatter skal bogfõres. Konfigurer dine nummerserier for oprettelse af kreditorer og forskellige kõbsbilag.;
                                 ENU=Define your general policies for purchase invoicing and returns, such as whether to require vendor invoice numbers and how to post purchase discounts. Set up your number series for creating vendors and different purchase documents.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 460;
                      Image=ReceivablesPayablesSetup }
      { 43      ;2   ;Action    ;
                      CaptionML=[DAN=&Anlëgsopsëtning;
                                 ENU=Fixed &Asset Setup];
                      ToolTipML=[DAN=Konfigurer virksomhedens politikker for administration af anlëgsaktiver.;
                                 ENU=Configure your company's policies for managing fixed assets.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5607;
                      Image=Setup }
      { 44      ;2   ;Action    ;
                      CaptionML=[DAN=Mar&ketingopsëtning;
                                 ENU=Mar&keting Setup];
                      ToolTipML=[DAN=Konfigurer dine virksomhedspolitikker for marketing.;
                                 ENU=Configure your company's policies for marketing.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5094;
                      Image=MarketingSetup }
      { 45      ;2   ;Action    ;
                      CaptionML=[DAN=Opsëtn. af beregn. af lev.ti&d;
                                 ENU=Or&der Promising Setup];
                      ToolTipML=[DAN=Konfigurer virksomhedens politikker for beregning af leveringsdatoer.;
                                 ENU=Configure your company's policies for calculating delivery dates.];
                      ApplicationArea=#Planning;
                      RunObject=Page 99000958;
                      Image=OrderPromisingSetup }
      { 63      ;2   ;Action    ;
                      CaptionML=[DAN=Katalog&vareopsëtning;
                                 ENU=Nonstock &Item Setup];
                      ToolTipML=[DAN=Konfigurer virksomhedens politikker for varer, du sëlger, men lagerfõrer.;
                                 ENU=Configure your company's policies for items that you sell but do keep on inventory.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5732;
                      Image=NonStockItemSetup }
      { 65      ;2   ;Action    ;
                      CaptionML=[DAN=Opsëtning af i&nteraktionsskbl.;
                                 ENU=Interaction &Template Setup];
                      ToolTipML=[DAN=Konfigurer, hvordan du bruger skabeloner til at oprette interaktioner.;
                                 ENU=Configure how you use templates to create interactions.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5186;
                      Image=InteractionTemplateSetup }
      { 67      ;2   ;Action    ;
                      CaptionML=[DAN=Opsëtning af &Lager;
                                 ENU=Inve&ntory Setup];
                      ToolTipML=[DAN=Definer dine gennerelle lagerpolitikker, som f.eks. om negativ beholdning er tilladt, og hvordan varepriser skal bogfõres og reguleres. Konfigurer dine nummerserier for oprettelse af nye lagervarer eller -tjenester.;
                                 ENU=Define your general inventory policies, such as whether to allow negative inventory and how to post and adjust item costs. Set up your number series for creating new inventory items or services.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 461;
                      Image=InventorySetup }
      { 34      ;2   ;Action    ;
                      CaptionML=[DAN=Logi&stikopsëtning;
                                 ENU=&Warehouse Setup];
                      ToolTipML=[DAN=Konfigurer din virksomheds lagerpolitikker, f.eks. om varer skal plukkes ud og lëgges pÜ lager pÜ lokationer som standard.;
                                 ENU=Configure your company's warehouse policies, such as whether to require picking and putting away at locations by default.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 5775;
                      Image=WarehouseSetup }
      { 35      ;2   ;Action    ;
                      CaptionML=[DAN=Min&iformularer;
                                 ENU=Mini&forms];
                      ToolTipML=[DAN="Vis eller rediger sërlige sider til brugere af hÜndholdte enheder. ";
                                 ENU="View or edit special pages for users of hand-held devices. "];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7703;
                      Image=MiniForm }
      { 69      ;2   ;Action    ;
                      CaptionML=[DAN=Prod&uktionsopsëtning;
                                 ENU=Man&ufacturing Setup];
                      ToolTipML=[DAN=Definer virksomhedens produktionspolitikker, f.eks. standardsikkerhedstiden og om advarsler vises i planlëgningskladden.;
                                 ENU=Define company policies for manufacturing, such as the default safety lead time and whether warnings are displayed in the planning worksheet.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000768;
                      Image=ProductionSetup }
      { 70      ;2   ;Action    ;
                      CaptionML=[DAN=Ress&ourceopsëtning;
                                 ENU=Res&ources Setup];
                      ToolTipML=[DAN=Konfigurer virksomhedens politikker for ressourceplanlëgning, f.eks. hvilke timesedler der skal bruges.;
                                 ENU=Configure your company's policies for resource planning, such as which time sheets to use.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 462;
                      Image=ResourceSetup }
      { 71      ;2   ;Action    ;
                      CaptionML=[DAN=&Serviceopsëtning;
                                 ENU=&Service Setup];
                      ToolTipML=[DAN=Konfigurer dine virksomhedspolitikker for servicestyring.;
                                 ENU=Configure your company policies for service management.];
                      ApplicationArea=#Service;
                      RunObject=Page 5919;
                      Image=ServiceSetup }
      { 72      ;2   ;Action    ;
                      CaptionML=[DAN=&Personaleopsëtning;
                                 ENU=&Human Resource Setup];
                      ToolTipML=[DAN=Definer dine politikker for personale, f.eks. nummerserie for medarbejdere og mÜleenheder.;
                                 ENU=Define your policies for human resource management, such as number series for employees and units of measure.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5233;
                      Image=HRSetup }
      { 74      ;2   ;Action    ;
                      CaptionML=[DAN=Opsëtning af servi&ceordrestatus;
                                 ENU=&Service Order Status Setup];
                      ToolTipML=[DAN=Vis eller rediger forskellige indstillinger for serviceordrestatus samt det prioritetsniveau, der er tildelt til hver enkelt.;
                                 ENU=View or edit different service order status options and the level of priority assigned to each one.];
                      ApplicationArea=#Service;
                      RunObject=Page 5943;
                      Image=ServiceOrderSetup }
      { 75      ;2   ;Action    ;
                      CaptionML=[DAN=&Opsëtning af reparationsstatus;
                                 ENU=&Repair Status Setup];
                      ToolTipML=[DAN=Vis eller rediger de forskellige indstillinger for reparationsstatus, som du kan tildele til serviceartikler. Du kan bruge angivelsen af reparationsstatus til at identificere forlõbet for serviceartiklernes reparation og vedligeholdelse.;
                                 ENU=View or edit the different repair status options that you can assign to service items. You can use repair status to identify the progress of repair and maintenance of service items.];
                      ApplicationArea=#Service;
                      RunObject=Page 5941;
                      Image=ServiceSetup }
      { 77      ;2   ;Action    ;
                      CaptionML=[DAN=O&psëtning af ëndringslog;
                                 ENU=C&hange Log Setup];
                      ToolTipML=[DAN=Definer, hvilke kontraktëndringer der logfõres.;
                                 ENU=Define which contract changes are logged.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 592;
                      Image=LogSetup }
      { 78      ;2   ;Action    ;
                      CaptionML=[DAN=&MapPoint-opsëtning;
                                 ENU=&MapPoint Setup];
                      ToolTipML=[DAN=Konfigurer en online-korttjeneste for at fÜ vist adresser pÜ et kort.;
                                 ENU=Configure an online map service to show addresses on a map.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 800;
                      Image=MapSetup }
      { 79      ;2   ;Action    ;
                      CaptionML=[DAN=Ops&ëtning af SMTP-mail;
                                 ENU=SMTP Mai&l Setup];
                      ToolTipML=[DAN=Konfigurer integrationen og sikkerheden for den mailserver pÜ dit websted, der hÜndterer mail.;
                                 ENU=Set up the integration and security of the mail server at your site that handles email.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 409;
                      Image=MailSetup }
      { 81      ;2   ;Action    ;
                      CaptionML=[DAN=Opsëtn. af pro&filspõrgeskema;
                                 ENU=Profile Quest&ionnaire Setup];
                      ToolTipML=[DAN=Definer profilspõrgeskemaer, som skal bruges ved angivelse af oplysninger om kontaktpersonernes profiler. Du kan i det enkelte spõrgeskema definere forskellige spõrgsmÜl, du vil stille dine kontaktpersoner. Du kan ogsÜ kõre spõrgeskemaet for at besvare nogle af spõrgsmÜlene baseret pÜ dataene for kontakten, kunden eller leverandõren automatisk.;
                                 ENU=Set up profile questionnaires that you want to use when entering information about your contacts' profiles. Within each questionnaire, you can set up the different questions you intend to ask your contacts. You can also run the questionnaire to answer some of the questions based on contact, customer, or vendor data automatically.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5110;
                      Image=QuestionaireSetup }
      { 82      ;1   ;ActionGroup;
                      CaptionML=[DAN=Rapportval&g;
                                 ENU=&Report Selection];
                      Image=SelectReport }
      { 83      ;2   ;Action    ;
                      CaptionML=[DAN=Rapportvalg - &bankkonto;
                                 ENU=Report Selection - &Bank Account];
                      ToolTipML=[DAN=Vis eller rediger listen over rapporter, der kan udskrives, nÜr du arbejder med bankkonti.;
                                 ENU=View or edit the list of reports that can be printed when you work with bank accounts.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 385;
                      Image=SelectReport }
      { 85      ;2   ;Action    ;
                      CaptionML=[DAN=Rapportvalg - &rykkere og rentenotaer;
                                 ENU=Report Selection - &Reminder && Finance Charge];
                      ToolTipML=[DAN=Vis eller rediger listen over rapporter, der kan udskrives, nÜr du arbejder med rykkere og renter.;
                                 ENU=View or edit the list of reports that can be printed when you work with reminders and finance charges.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 524;
                      Image=SelectReport }
      { 86      ;2   ;Action    ;
                      CaptionML=[DAN=Rapportvalg - &salg;
                                 ENU=Report Selection - &Sales];
                      ToolTipML=[DAN=Vis eller rediger listen over rapporter, der kan udskrives, nÜr du arbejder med salg.;
                                 ENU=View or edit the list of reports that can be printed when you work with sales.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 306;
                      Image=SelectReport }
      { 87      ;2   ;Action    ;
                      CaptionML=[DAN=Rapportvalg - &kõb;
                                 ENU=Report Selection - &Purchase];
                      ToolTipML=[DAN=Vis eller rediger listen over rapporter, der kan udskrives, nÜr du arbejder med kõb.;
                                 ENU=View or edit the list of reports that can be printed when you work with purchasing.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 347;
                      Image=SelectReport }
      { 88      ;2   ;Action    ;
                      CaptionML=[DAN=Rapportvalg - &lager;
                                 ENU=Report Selection - &Inventory];
                      ToolTipML=[DAN=Vis eller rediger listen over rapporter, der kan udskrives, nÜr du arbejder med lager.;
                                 ENU=View or edit the list of reports that can be printed when you work with inventory.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5754;
                      Image=SelectReport }
      { 89      ;2   ;Action    ;
                      CaptionML=[DAN=Rapportvalg - prod.&ordre;
                                 ENU=Report Selection - Prod. &Order];
                      ToolTipML=[DAN=Vis eller rediger listen over rapporter, der kan udskrives, nÜr du arbejder med produktion.;
                                 ENU=View or edit the list of reports that can be printed when you work with manufacturing.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000917;
                      Image=SelectReport }
      { 91      ;2   ;Action    ;
                      CaptionML=[DAN=Rapportvalg - s&ervice;
                                 ENU=Report Selection - S&ervice];
                      ToolTipML=[DAN=Vis eller rediger listen over rapporter, der kan udskrives, nÜr du arbejder med servicestyring.;
                                 ENU=View or edit the list of reports that can be printed when you work with service management.];
                      ApplicationArea=#Service;
                      RunObject=Page 5932;
                      Image=SelectReport }
      { 1       ;2   ;Action    ;
                      CaptionML=[DAN=Rapportvalg - pengestrõm;
                                 ENU=Report Selection - Cash Flow];
                      ToolTipML=[DAN=Vis eller rediger listen over rapporter, der kan udskrives, nÜr du arbejder med pengestrõmme.;
                                 ENU=View or edit the list of reports that can be printed when you work with cash flow.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 865;
                      Image=SelectReport }
      { 93      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Datokomprimering;
                                 ENU=&Date Compression];
                      Image=Compress }
      { 94      ;2   ;Action    ;
                      CaptionML=[DAN=Datokomprimer &finansposter;
                                 ENU=Date Compress &G/L Entries];
                      ToolTipML=[DAN=Spar plads i databasen ved at kombinere relaterede poster til Çn ny post. Du kan kun komprimere poster fra afsluttede regnskabsÜr.;
                                 ENU=Save database space by combining related entries in one new entry. You can compress entries from closed fiscal years only.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 98;
                      Image=GeneralLedger }
      { 95      ;2   ;Action    ;
                      CaptionML=[DAN=Datokomprimer &momsposter;
                                 ENU=Date Compress &VAT Entries];
                      ToolTipML=[DAN=Spar plads i databasen ved at kombinere relaterede poster til Çn ny post. Du kan kun komprimere poster fra afsluttede regnskabsÜr.;
                                 ENU=Save database space by combining related entries in one new entry. You can compress entries from closed fiscal years only.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 95;
                      Image=VATStatement }
      { 96      ;2   ;Action    ;
                      CaptionML=[DAN=Datokomprimer &bankkontoposter;
                                 ENU=Date Compress Bank &Account Ledger Entries];
                      ToolTipML=[DAN=Spar plads i databasen ved at kombinere relaterede poster til Çn ny post. Du kan kun komprimere poster fra afsluttede regnskabsÜr.;
                                 ENU=Save database space by combining related entries in one new entry. You can compress entries from closed fiscal years only.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 1498;
                      Image=BankAccount }
      { 97      ;2   ;Action    ;
                      CaptionML=[DAN=Datokomprimer finansb&udgetposter;
                                 ENU=Date Compress G/L &Budget Entries];
                      ToolTipML=[DAN=Spar plads i databasen ved at kombinere relaterede poster til Çn ny post. Du kan kun komprimere poster fra afsluttede regnskabsÜr.;
                                 ENU=Save database space by combining related entries in one new entry. You can compress entries from closed fiscal years only.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 97;
                      Image=LedgerBudget }
      { 98      ;2   ;Action    ;
                      CaptionML=[DAN=D&atokomprimer debitorposter;
                                 ENU=Date Compress &Customer Ledger Entries];
                      ToolTipML=[DAN=Spar plads i databasen ved at kombinere relaterede poster til Çn ny post. Du kan kun komprimere poster fra afsluttede regnskabsÜr.;
                                 ENU=Save database space by combining related entries in one new entry. You can compress entries from closed fiscal years only.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 198;
                      Image=Customer }
      { 99      ;2   ;Action    ;
                      CaptionML=[DAN=Datokomprimer kr&editorposter;
                                 ENU=Date Compress V&endor Ledger Entries];
                      ToolTipML=[DAN=Spar plads i databasen ved at kombinere relaterede poster til Çn ny post. Du kan kun komprimere poster fra afsluttede regnskabsÜr.;
                                 ENU=Save database space by combining related entries in one new entry. You can compress entries from closed fiscal years only.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 398;
                      Image=Vendor }
      { 90      ;2   ;Action    ;
                      CaptionML=[DAN=Da&tokomprimer ressourceposter;
                                 ENU=Date Compress &Resource Ledger Entries];
                      ToolTipML=[DAN=Spar plads i databasen ved at kombinere relaterede poster til Çn ny post. Du kan kun komprimere poster fra afsluttede regnskabsÜr.;
                                 ENU=Save database space by combining related entries in one new entry. You can compress entries from closed fiscal years only.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 1198;
                      Image=Resource }
      { 102     ;2   ;Action    ;
                      CaptionML=[DAN=Datokomprimer a&nlëgsfinansposter;
                                 ENU=Date Compress &FA Ledger Entries];
                      ToolTipML=[DAN=Spar plads i databasen ved at kombinere relaterede poster til Çn ny post. Du kan kun komprimere poster fra afsluttede regnskabsÜr.;
                                 ENU=Save database space by combining related entries in one new entry. You can compress entries from closed fiscal years only.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 5696;
                      Image=FixedAssets }
      { 103     ;2   ;Action    ;
                      CaptionML=[DAN=Datokomprimer &reparationsposter;
                                 ENU=Date Compress &Maintenance Ledger Entries];
                      ToolTipML=[DAN=Spar plads i databasen ved at kombinere relaterede poster til Çn ny post. Du kan kun komprimere poster fra afsluttede regnskabsÜr.;
                                 ENU=Save database space by combining related entries in one new entry. You can compress entries from closed fiscal years only.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 5698;
                      Image=Tools }
      { 104     ;2   ;Action    ;
                      CaptionML=[DAN=Dat&okomprimer forsikringsposter;
                                 ENU=Date Compress &Insurance Ledger Entries];
                      ToolTipML=[DAN=Spar plads i databasen ved at kombinere relaterede poster til Çn ny post. Du kan kun komprimere poster fra afsluttede regnskabsÜr.;
                                 ENU=Save database space by combining related entries in one new entry. You can compress entries from closed fiscal years only.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 5697;
                      Image=Insurance }
      { 105     ;2   ;Action    ;
                      CaptionML=[DAN=Datokomprimer la&gerposter;
                                 ENU=Date Compress &Warehouse Entries];
                      ToolTipML=[DAN=Spar plads i databasen ved at kombinere relaterede poster til Çn ny post. Du kan kun komprimere poster fra afsluttede regnskabsÜr.;
                                 ENU=Save database space by combining related entries in one new entry. You can compress entries from closed fiscal years only.];
                      ApplicationArea=#Warehouse;
                      RunObject=Report 7398;
                      Image=Bin }
      { 264     ;1   ;Separator  }
      { 106     ;1   ;ActionGroup;
                      CaptionML=[DAN=Kon&takter;
                                 ENU=Con&tacts];
                      Image=CustomerContact }
      { 108     ;2   ;Action    ;
                      CaptionML=[DAN=Opret kontakter fra &debitor;
                                 ENU=Create Contacts from &Customer];
                      ToolTipML=[DAN=Opret et kontaktkort ud fra oplysninger om kontakten hos debitoren.;
                                 ENU=Create a contact card from information about the customer's contact person.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 5195;
                      Image=CustomerContact }
      { 109     ;2   ;Action    ;
                      CaptionML=[DAN=Opret kontakter fra &kreditor;
                                 ENU=Create Contacts from &Vendor];
                      ToolTipML=[DAN=Opret et kontaktkort ud fra oplysninger om kontakten hos kreditoren.;
                                 ENU=Create a contact card from information about the vendor's contact person.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 5194;
                      Image=VendorContact }
      { 110     ;2   ;Action    ;
                      CaptionML=[DAN=Opret kontakter fra &bankkonto;
                                 ENU=Create Contacts from &Bank Account];
                      ToolTipML=[DAN=Opret et kontaktkort ud fra oplysninger om kontakten hos bankkontoen.;
                                 ENU=Create a contact card from information about the bank account's contact person.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 5193;
                      Image=BankContact }
      { 37      ;2   ;Action    ;
                      CaptionML=[DAN=Opgave&aktiviteter;
                                 ENU=Task &Activities];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5101;
                      Image=TaskList }
      { 47      ;1   ;Separator  }
      { 48      ;1   ;Action    ;
                      CaptionML=[DAN=Servi&cefejlfinding;
                                 ENU=Service Trou&bleshooting];
                      ToolTipML=[DAN=Vis eller rediger oplysninger om tekniske problemer med en serviceartikel.;
                                 ENU=View or edit information about technical problems with a service item.];
                      ApplicationArea=#Service;
                      RunObject=Page 5990;
                      Image=Troubleshoot }
      { 114     ;1   ;ActionGroup;
                      CaptionML=[DAN=&Indlës;
                                 ENU=&Import];
                      Image=Import }
      { 260     ;2   ;Action    ;
                      CaptionML=[DAN=Indlës IRIS til &omrÜde/symptomkode;
                                 ENU=Import IRIS to &Area/Symptom Code];
                      ToolTipML=[DAN=ImportÇr det internationale reparationskodesystem IRIS (International Repair Coding System) for at definere omrÜde/symptomkoder for serviceartikler.;
                                 ENU=Import the International Repair Coding System to define area/symptom codes for service items.];
                      ApplicationArea=#Service;
                      RunObject=XMLport 5900;
                      Image=Import }
      { 261     ;2   ;Action    ;
                      CaptionML=[DAN=Indlës IRIS til &fejlkoder;
                                 ENU=Import IRIS to &Fault Codes];
                      ToolTipML=[DAN=ImportÇr det internationale reparationskodesystem IRIS (International Repair Coding System) for at definere fejlkoder for serviceartikler.;
                                 ENU=Import the International Repair Coding System to define fault codes for service items.];
                      ApplicationArea=#Service;
                      RunObject=XMLport 5901;
                      Image=Import }
      { 262     ;2   ;Action    ;
                      CaptionML=[DAN=Indlës I&RIS til lõsningskoder;
                                 ENU=Import IRIS to &Resolution Codes];
                      ToolTipML=[DAN=ImportÇr det internationale reparationskodesystem IRIS (International Repair Coding System) for at definere lõsningskoder for serviceartikler.;
                                 ENU=Import the International Repair Coding System to define resolution codes for service items.];
                      ApplicationArea=#Service;
                      RunObject=XMLport 5902;
                      Image=Import }
      { 263     ;1   ;Separator  }
      { 118     ;1   ;ActionGroup;
                      CaptionML=[DAN=&Salgsanalyse;
                                 ENU=&Sales Analysis];
                      Image=Segment }
      { 119     ;2   ;Action    ;
                      Name=SalesAnalysisLineTmpl;
                      CaptionML=[DAN=Salgsanalyse - &linjeskabeloner;
                                 ENU=Sales Analysis &Line Templates];
                      ToolTipML=[DAN=Definer layoutet af dine visninger for at analysere udviklingen i dine salgsmëngder.;
                                 ENU=Define the layout of your views to analyze the dynamics of your sales volumes.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 7112;
                      RunPageView=SORTING(Analysis Area,Name)
                                  WHERE(Analysis Area=CONST(Sales));
                      Image=SetupLines }
      { 120     ;2   ;Action    ;
                      Name=SalesAnalysisColumnTmpl;
                      CaptionML=[DAN=Salgsanalyse - &Kolonneskabeloner;
                                 ENU=Sales Analysis &Column Templates];
                      ToolTipML=[DAN=Definer layoutet af dine visninger for at analysere udviklingen i dine salgsmëngder.;
                                 ENU=Define the layout of your views to analyze the dynamics of your sales volumes.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 7113;
                      RunPageView=SORTING(Analysis Area,Name)
                                  WHERE(Analysis Area=CONST(Sales));
                      Image=SetupColumns }
      { 122     ;1   ;ActionGroup;
                      CaptionML=[DAN=Kõ&bsanalyse;
                                 ENU=P&urchase Analysis];
                      Image=Purchasing }
      { 123     ;2   ;Action    ;
                      Name=PurchaseAnalysisLineTmpl;
                      CaptionML=[DAN=Kõbs&analyselinjeskabeloner;
                                 ENU=Purchase &Analysis Line Templates];
                      ToolTipML=[DAN=Definer layoutet af dine visninger for at analysere udviklingen i dine kõbsmëngder.;
                                 ENU=Define the layout of your views to analyze the dynamics of your purchase volumes.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 7112;
                      RunPageView=SORTING(Analysis Area,Name)
                                  WHERE(Analysis Area=CONST(Purchase));
                      Image=SetupLines }
      { 124     ;2   ;Action    ;
                      Name=PurchaseAnalysisColumnTmpl;
                      CaptionML=[DAN=Kõbsanal&ysekolonneskabeloner;
                                 ENU=Purchase Analysis &Column Templates];
                      ToolTipML=[DAN=Definer layoutet af dine visninger for at analysere udviklingen i dine kõbsmëngder.;
                                 ENU=Define the layout of your views to analyze the dynamics of your purchase volumes.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 7113;
                      RunPageView=SORTING(Analysis Area,Name)
                                  WHERE(Analysis Area=CONST(Purchase));
                      Image=SetupColumns }
    }
  }
  CONTROLS
  {
    { 1900000008;0;Container;
                ContainerType=RoleCenterArea }

    { 1900724808;1;Group   }

    { 1904484608;2;Part   ;
                ApplicationArea=#Advanced;
                PagePartID=Page9072;
                PartType=Page }

    { 58  ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page5371;
                Visible=false;
                PartType=Page }

    { 52  ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page1278;
                Visible=false;
                PartType=Page }

    { 1900724708;1;Group   }

    { 36  ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page681;
                PartType=Page }

    { 32  ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page675;
                Visible=false;
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

