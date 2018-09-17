OBJECT Page 9016 Service Dispatcher Role Center
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846,NAVDK11.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[@@@="{Dependency=Match,""ProfileDescription_DISPATCHER""}";
               DAN=Sender - kundeservice;
               ENU=Dispatcher - Customer Service];
    PageType=RoleCenter;
    ActionList=ACTIONS
    {
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 5       ;1   ;Action    ;
                      CaptionML=[DAN=&Serviceopgaver;
                                 ENU=Service Ta&sks];
                      ToolTipML=[DAN=Vis eller rediger oplysninger om serviceopgaver, f.eks. serviceordrenummer, serviceartikelbeskrivelse, reparationsstatus og serviceartikel. Du kan udskrive en oversigt over de serviceopgaver, der er blevet angivet.;
                                 ENU=View or edit service task information, such as service order number, service item description, repair status, and service item. You can print a list of the service tasks that have been entered.];
                      ApplicationArea=#Service;
                      RunObject=Report 5904;
                      Image=ServiceTasks }
      { 6       ;1   ;Action    ;
                      CaptionML=[DAN=Service&belastningsniveau;
                                 ENU=Service &Load Level];
                      ToolTipML=[DAN=Vis ressourcens kapacitet, forbrug, antal ubrugte, antal ubrugte i procent, salg og salgsprocentdel. Du kan kontrollere ressourcernes servicebelastningsniveau.;
                                 ENU=View the capacity, usage, unused, unused percentage, sales, and sales percentage of the resource. You can test what the service load is of your resources.];
                      ApplicationArea=#Service;
                      RunObject=Report 5956;
                      Image=Report }
      { 8       ;1   ;Action    ;
                      CaptionML=[DAN=Ressourceforbr&ug;
                                 ENU=Resource &Usage];
                      ToolTipML=[DAN=Vis oplysninger om den samlede brug af serviceartikler, bÜde omkostninger og belõb, avancebelõb og avanceprocent.;
                                 ENU=View details about the total use of service items, both cost and amount, profit amount, and profit percentage.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 5939;
                      Image=Report }
      { 9       ;1   ;Separator  }
      { 13      ;1   ;Action    ;
                      CaptionML=[DAN=Service&art. - garanti udlõbet;
                                 ENU=Service I&tems Out of Warranty];
                      ToolTipML=[DAN=Vis oplysninger om garantiudlõbsdatoer, serienumre, antal aktive kontrakter, varebeskrivelse og navne pÜ debitorer. Du kan udskrive en oversigt over serviceartikler, hvis garanti er udlõbet.;
                                 ENU=View information about warranty end dates, serial numbers, number of active contracts, items description, and names of customers. You can print a list of service items that are out of warranty.];
                      ApplicationArea=#Service;
                      RunObject=Report 5937;
                      Image=Report }
      { 14      ;1   ;Separator  }
      { 28      ;1   ;Action    ;
                      CaptionML=[DAN=Avance - service&kontrakter;
                                 ENU=Profit Service &Contracts];
                      ToolTipML=[DAN=Vis oplysninger om servicebelõb, kontraktrabatbelõb, servicerabatbelõb, serviceomkostningsbelõb, avancebelõb og avance. Du kan udskrive oplysninger om serviceavancen pÜ servicekontrakter, baseret pÜ forskellen mellem servicebelõb og serviceomkostninger.;
                                 ENU=View details about service amount, contract discount amount, service discount amount, service cost amount, profit amount, and profit. You can print information about service profit for service contracts, based on the difference between the service amount and service cost.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 5976;
                      Image=Report }
      { 38      ;1   ;Action    ;
                      CaptionML=[DAN=Avance - service&ordrer;
                                 ENU=Profit Service &Orders];
                      ToolTipML=[DAN=Vis kundenummer, serienummer, beskrivelse, serviceartikelnummer, kontraktnummer og kontraktbelõb. Du kan udskrive oplysninger om serviceavancen for serviceordrer, baseret pÜ forskellen mellem servicebelõb og serviceomkostninger.;
                                 ENU=View the customer number, serial number, description, item number, contract number, and contract amount. You can print information about service profit for service orders, based on the difference between service amount and service cost.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 5910;
                      Image=Report }
      { 41      ;1   ;Action    ;
                      CaptionML=[DAN=Avance (serv&iceartikler);
                                 ENU=Profit Service &Items];
                      ToolTipML=[DAN=Vis oplysninger om servicebelõb, kontraktrabatbelõb, servicerabatbelõb, serviceomkostningsbelõb, avancebelõb og avance. Du kan udskrive oplysninger om serviceavance for serviceartikler.;
                                 ENU=View details about service amount, contract discount amount, service discount amount, service cost amount, profit amount, and profit. You can print information about service profit for service items.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 5938;
                      Image=Report }
      { 1900000011;0 ;ActionContainer;
                      ActionContainerType=HomeItems }
      { 7       ;1   ;Action    ;
                      CaptionML=[DAN=Servicekontrakttilbud;
                                 ENU=Service Contract Quotes];
                      ToolTipML=[DAN=Vis oversigten over igangvërende servicekontrakttilbud.;
                                 ENU=View the list of ongoing service contract quotes.];
                      ApplicationArea=#Service;
                      RunObject=Page 9322 }
      { 11      ;1   ;Action    ;
                      Name=ServiceContracts;
                      CaptionML=[DAN=Servicekontrakter;
                                 ENU=Service Contracts];
                      ToolTipML=[DAN=Vis oversigten over igangvërende servicekontrakter.;
                                 ENU=View the list of ongoing service contracts.];
                      ApplicationArea=#Service;
                      RunObject=Page 9321;
                      Image=ServiceAgreement }
      { 46      ;1   ;Action    ;
                      Name=ServiceContractsOpen;
                      ShortCutKey=Return;
                      CaptionML=[DAN=èbn;
                                 ENU=Open];
                      ToolTipML=[DAN=èbn kortet for den valgte record.;
                                 ENU=Open the card for the selected record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9321;
                      RunPageView=WHERE(Change Status=FILTER(Open));
                      Image=Edit }
      { 12      ;1   ;Action    ;
                      CaptionML=[DAN=Servicetilbud;
                                 ENU=Service Quotes];
                      ToolTipML=[DAN=Vis oversigten over igangvërende servicetilbud.;
                                 ENU=View the list of ongoing service quotes.];
                      ApplicationArea=#Service;
                      RunObject=Page 9317;
                      Image=Quote }
      { 15      ;1   ;Action    ;
                      CaptionML=[DAN=Serviceordrer;
                                 ENU=Service Orders];
                      ToolTipML=[DAN=èbn oversigten over igangvërende serviceordrer.;
                                 ENU=Open the list of ongoing service orders.];
                      ApplicationArea=#Service;
                      RunObject=Page 9318;
                      Image=Document }
      { 54      ;1   ;Action    ;
                      CaptionML=[DAN=Standardservicekoder;
                                 ENU=Standard Service Codes];
                      ToolTipML=[DAN="Vis eller rediger serviceordrelinjer, som du har konfigureret for tilbagevendende servicer. ";
                                 ENU="View or edit service order lines that you have set up for recurring services. "];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5958;
                      Image=ServiceCode }
      { 55      ;1   ;Action    ;
                      CaptionML=[DAN=UdlÜnsvarer;
                                 ENU=Loaners];
                      ToolTipML=[DAN=FÜ vist eller vëlg blandt de artikler, du udlÜner midlertidigt til debitorer som erstatning for de artikler, de har til service.;
                                 ENU=View or select from items that you lend out temporarily to customers to replace items that they have in service.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5923;
                      Image=Loaners }
      { 56      ;1   ;Action    ;
                      CaptionML=[DAN=Debitorer;
                                 ENU=Customers];
                      ToolTipML=[DAN=FÜ vist eller rediger detaljerede oplysninger om de debitorer, som du handler med. Fra det enkelte debitorkort kan du fÜ adgang til relaterede oplysninger som f.eks. salgsstatistik og igangvërende ordrer, og du kan definere specialpriser og linjerabatter, som debitoren fÜr, nÜr bestemte betingelser er opfyldt.;
                                 ENU=View or edit detailed information for the customers that you trade with. From each customer card, you can open related information, such as sales statistics and ongoing orders, and you can define special prices and line discounts that you grant if certain conditions are met.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 22;
                      Image=Customer }
      { 57      ;1   ;Action    ;
                      CaptionML=[DAN=Serviceartikler;
                                 ENU=Service Items];
                      ToolTipML=[DAN=Vis listen over serviceelementer.;
                                 ENU=View the list of service items.];
                      ApplicationArea=#Service;
                      RunObject=Page 5981;
                      Image=ServiceItem }
      { 58      ;1   ;Action    ;
                      CaptionML=[DAN=Varer;
                                 ENU=Items];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om de produkter, du handler med. Varekortet kan vëre af typen lager eller tjeneste for at angive, om varen er en fysisk enhed eller en bestÜr af arbejdstimer. Her angiver du ogsÜ, om varerne pÜ lager eller i indgÜende ordrer automatisk reserveres til udgÜende bilag, og om der er oprettet ordresporingsbindinger mellem behov og forsyning for at afspejle planlëgningshandlinger.;
                                 ENU=View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 31;
                      Image=Item }
      { 59      ;1   ;Action    ;
                      CaptionML=[DAN=Varekladder;
                                 ENU=Item Journals];
                      ToolTipML=[DAN=Bogfõr varetransaktioner direkte pÜ varekladden for at regulere lagerbeholdningen i forbindelse med kõb, salg, opreguleringer eller nedreguleringer uden brug af bilag. Du kan gemme hele sët med varekladdelinjer som standardkladder, sÜ du hurtigt kan udfõre tilbagevendende bogfõringer. Der findes en komprimeret version af varekladdefunktionen pÜ varekort, som gõr det muligt at foretage en hurtig regulering af et varelagerantal.;
                                 ENU=Post item transactions directly to the item ledger to adjust inventory in connection with purchases, sales, and positive or negative adjustments without using documents. You can save sets of item journal lines as standard journals so that you can perform recurring postings quickly. A condensed version of the item journal function exists on item cards for quick adjustment of an items inventory quantity.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 262;
                      RunPageView=WHERE(Template Type=CONST(Item),
                                        Recurring=CONST(No)) }
      { 25      ;1   ;Action    ;
                      CaptionML=[DAN=Indkõbskladder;
                                 ENU=Requisition Worksheets];
                      ToolTipML=[DAN=Beregn en forsyningsplan for at opfylde varebehov via indkõb eller overfõrsler.;
                                 ENU=Calculate a supply plan to fulfill item demand with purchases or transfers.];
                      ApplicationArea=#Planning;
                      RunObject=Page 295;
                      RunPageView=WHERE(Template Type=CONST(Req.),
                                        Recurring=CONST(No)) }
      { 1900000012;0 ;ActionContainer;
                      ActionContainerType=ActivityButtons }
      { 39      ;1   ;ActionGroup;
                      CaptionML=[DAN=Bogfõrte dokumenter;
                                 ENU=Posted Documents];
                      Image=FiledPosted }
      { 60      ;2   ;Action    ;
                      CaptionML=[DAN=Bogfõrte serviceleverancer;
                                 ENU=Posted Service Shipments];
                      ToolTipML=[DAN=èbn listen over bogfõrte serviceleverancer.;
                                 ENU=Open the list of posted service shipments.];
                      ApplicationArea=#Service;
                      RunObject=Page 5974;
                      Image=PostedShipment }
      { 61      ;2   ;Action    ;
                      CaptionML=[DAN=Bogfõrte servicefakturaer;
                                 ENU=Posted Service Invoices];
                      ToolTipML=[DAN=èbn listen over bogfõrte servicefakturaer.;
                                 ENU=Open the list of posted service invoices.];
                      ApplicationArea=#Service;
                      RunObject=Page 5977;
                      Image=PostedServiceOrder }
      { 62      ;2   ;Action    ;
                      CaptionML=[DAN=Bogfõrte servicekreditnotaer;
                                 ENU=Posted Service Credit Memos];
                      ToolTipML=[DAN=èbn listen over bogfõrte servicekreditnotaer.;
                                 ENU=Open the list of posted service credit memos.];
                      ApplicationArea=#Service;
                      RunObject=Page 5971 }
      { 1       ;0   ;ActionContainer;
                      ActionContainerType=NewDocumentItems }
      { 18      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Service;
                                 ENU=&Service];
                      Image=Tools }
      { 17      ;2   ;Action    ;
                      CaptionML=[DAN=&Servicekontrakttilbud;
                                 ENU=Service Contract &Quote];
                      ToolTipML=[DAN=Opret et nyt tilbud om at udfõre service pÜ varen for en debitor.;
                                 ENU=Create a new quote to perform service on a customer's item.];
                      ApplicationArea=#Service;
                      RunObject=Page 6053;
                      Promoted=No;
                      Image=AgreementQuote;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 10      ;2   ;Action    ;
                      CaptionML=[DAN=&Servicekontrakt;
                                 ENU=Service &Contract];
                      ToolTipML=[DAN=Opret en ny servicekontrakt.;
                                 ENU=Create a new service contract.];
                      ApplicationArea=#Service;
                      RunObject=Page 6050;
                      Promoted=No;
                      Image=Agreement;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 16      ;2   ;Action    ;
                      CaptionML=[DAN=&Servicetilbud;
                                 ENU=Service Q&uote];
                      ToolTipML=[DAN=Opret et nyt servicetilbud.;
                                 ENU=Create a new service quote.];
                      ApplicationArea=#Service;
                      RunObject=Page 5964;
                      Promoted=No;
                      Image=Quote;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 4       ;2   ;Action    ;
                      CaptionML=[DAN=Service&ordre;
                                 ENU=Service &Order];
                      ToolTipML=[DAN=Opret en ny serviceordre for at udfõre service pÜ varen for en debitor.;
                                 ENU=Create a new service order to perform service on a customer's item.];
                      ApplicationArea=#Service;
                      RunObject=Page 5900;
                      Promoted=No;
                      Image=Document;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 3       ;1   ;Action    ;
                      CaptionML=[DAN=&Salgsordre;
                                 ENU=Sales Or&der];
                      ToolTipML=[DAN=Opret en ny salgsordre pÜ varer eller servicer, som krëver delvis bogfõring eller ordrebekrëftelse.;
                                 ENU=Create a new sales order for items or services that require partial posting or order confirmation.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 42;
                      Promoted=No;
                      Image=Document;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 2       ;1   ;Action    ;
                      CaptionML=[DAN=&Overflytningsordre;
                                 ENU=Transfer &Order];
                      ToolTipML=[DAN=Forbered overflytning af varer til en anden lokation.;
                                 ENU=Prepare to transfer items to another location.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5740;
                      Promoted=No;
                      Image=Document;
                      PromotedCategory=Process;
                      RunPageMode=Create }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 19      ;1   ;Separator ;
                      CaptionML=[DAN=Opgaver;
                                 ENU=Tasks];
                      IsHeader=Yes }
      { 20      ;1   ;Action    ;
                      CaptionML=[DAN=Servi&ceopgaver;
                                 ENU=Service Tas&ks];
                      ToolTipML=[DAN=Vis eller rediger oplysninger om serviceopgaver, f.eks. serviceordrenummer, serviceartikelbeskrivelse, reparationsstatus og serviceartikel. Du kan udskrive en oversigt over de serviceopgaver, der er blevet angivet.;
                                 ENU=View or edit service task information, such as service order number, service item description, repair status, and service item. You can print a list of the service tasks that have been entered.];
                      ApplicationArea=#Service;
                      RunObject=Page 5915;
                      Image=ServiceTasks }
      { 22      ;1   ;Action    ;
                      CaptionML=[DAN=Op&ret kontraktserviceordrer;
                                 ENU=C&reate Contract Service Orders];
                      ToolTipML=[DAN=KopiÇr oplysninger fra en eksisterende produktionsordrerecord til en ny. Det kan gõres uanset produktionsordrens statustype. Du kan f.eks. kopiere fra en frigivet produktionsordre til en ny planlagt produktionsordre. Bemërk, at du skal oprette den nye record, fõr du begynder at kopiere.;
                                 ENU=Copy information from an existing production order record to a new one. This can be done regardless of the status type of the production order. You can, for example, copy from a released production order to a new planned production order. Note that before you start to copy, you have to create the new record.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 6036;
                      Image=Report }
      { 24      ;1   ;Action    ;
                      CaptionML=[DAN=Opret kontraktfakt&uraer;
                                 ENU=Create Contract In&voices];
                      ToolTipML=[DAN="Opret servicefakturaer pÜ servicekontrakter, der er forfaldne til fakturering. ";
                                 ENU="Create service invoices for service contracts that are due for invoicing. "];
                      ApplicationArea=#Advanced;
                      RunObject=Report 6030;
                      Image=Report }
      { 26      ;1   ;Action    ;
                      CaptionML=[DAN=Bogfõr forudbet. kontrakt&poster;
                                 ENU=Post &Prepaid Contract Entries];
                      ToolTipML=[DAN=Overfõrer forudbetalte belõb for servicekontraktposter fra forudbetalingskonti til resultatopgõrelseskonti.;
                                 ENU=Transfers prepaid service contract ledger entries amounts from prepaid accounts to income accounts.];
                      ApplicationArea=#Prepayments;
                      RunObject=Report 6032;
                      Image=Report }
      { 1060000 ;1   ;Action    ;
                      CaptionML=[DAN=Opret elektroniske servicefakturaer;
                                 ENU=Create Electronic Service Invoices];
                      ToolTipML=[DAN=Opret en elektronisk version af det aktuelle dokument.;
                                 ENU=Create an electronic version of the current document.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 13604;
                      Image=ElectronicDoc }
      { 1060001 ;1   ;Action    ;
                      CaptionML=[DAN=Opret elektroniske servicekreditnotaer;
                                 ENU=Create Electronic Service Credit Memos];
                      ToolTipML=[DAN=Opret en elektronisk version af det aktuelle dokument.;
                                 ENU=Create an electronic version of the current document.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 13605;
                      Image=ElectronicDoc }
      { 27      ;1   ;Separator  }
      { 29      ;1   ;Action    ;
                      CaptionML=[DAN=Ordrepla&nlëgning;
                                 ENU=Order Pla&nning];
                      ToolTipML=[DAN=Planlëg forsyningsordrer ordre for ordre for at opfylde nye behov.;
                                 ENU=Plan supply orders order by order to fulfill new demand.];
                      ApplicationArea=#Planning;
                      RunObject=Page 5522;
                      Image=Planning }
      { 30      ;1   ;Separator ;
                      CaptionML=[DAN=Opsëtning;
                                 ENU=Administration];
                      IsHeader=Yes }
      { 33      ;1   ;Action    ;
                      CaptionML=[DAN=St&andardservicekoder;
                                 ENU=St&andard Service Codes];
                      ToolTipML=[DAN="Vis eller rediger serviceordrelinjer, som du har konfigureret for tilbagevendende servicer. ";
                                 ENU="View or edit service order lines that you have set up for recurring services. "];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5958;
                      Image=ServiceCode }
      { 23      ;1   ;Action    ;
                      CaptionML=[DAN=Ordreoversigt;
                                 ENU=Dispatch Board];
                      ToolTipML=[DAN=FÜ en oversigt over dine serviceordrer. Definer f.eks. filtre, hvis du kun vil have vist serviceordrer for en bestemt debitor eller servicezone, eller hvis du kun vil have vist de serviceordrer, hvor genallokering er nõdvendig.;
                                 ENU=Get an overview of your service orders. Set filters, for example, if you only want to view service orders for a particular customer, service zone or you only want to view service orders needing reallocation.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 6000;
                      Image=ListPage }
      { 34      ;1   ;Separator ;
                      CaptionML=[DAN=Oversigt;
                                 ENU=History];
                      IsHeader=Yes }
      { 36      ;1   ;Action    ;
                      CaptionML=[DAN=&Varesporing;
                                 ENU=Item &Tracing];
                      ToolTipML=[DAN=Spor, hvor en lot- eller et serienummer, som varen er blevet tildelt, blev anvendt, eksempelvis for at finde ud af, hvilket lot en defekt komponent stammer fra, eller for at finde alle de debitorer, som har modtaget varer, der indeholder den defekte komponent.;
                                 ENU=Trace where a lot or serial number assigned to the item was used, for example, to find which lot a defective component came from or to find all the customers that have received items containing the defective component.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 6520;
                      Image=ItemTracing }
      { 37      ;1   ;Action    ;
                      CaptionML=[DAN=Nav&iger;
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

    { 1904652008;2;Part   ;
                ApplicationArea=#Advanced;
                PagePartID=Page9057;
                PartType=Page }

    { 1900724708;1;Group   }

    { 21  ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page675;
                Visible=false;
                PartType=Page }

    { 1907692008;2;Part   ;
                ApplicationArea=#Advanced;
                PagePartID=Page9150;
                PartType=Page }

    { 1905989608;2;Part   ;
                ApplicationArea=#Advanced;
                PagePartID=Page9152;
                PartType=Page }

    { 31  ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page681;
                Visible=FALSE;
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

