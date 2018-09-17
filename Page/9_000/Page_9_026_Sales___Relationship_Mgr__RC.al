OBJECT Page 9026 Sales & Relationship Mgr. RC
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
               DAN=Salgs- og CRM-chef;
               ENU=Sales and Relationship Manager];
    PageType=RoleCenter;
    ActionList=ACTIONS
    {
      { 45      ;0   ;ActionContainer;
                      ActionContainerType=Reports }
      { 13      ;1   ;Action    ;
                      CaptionML=[DAN=Debitor - &ordreoversigt;
                                 ENU=Customer - &Order Summary];
                      ToolTipML=[DAN=Vis den ikke-leverede beholdning pr. debitor i tre perioder Ö 30 dage med udgangspunkt i en valgt dato. Der vises desuden kolonner med ordrer, der skal leveres fõr og efter de tre perioder, og en kolonne med ordrebeholdningen pr. debitor i alt. Rapporten kan f.eks. bruges til at analysere virksomhedens forventede omsëtning.;
                                 ENU=View the quantity not yet shipped for each customer in three periods of 30 days each, starting from a selected date. There are also columns with orders to be shipped before and after the three periods and a column with the total order detail for each customer. The report can be used to analyze a company's expected sales volume.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Report 107;
                      Image=Report }
      { 14      ;1   ;Action    ;
                      CaptionML=[DAN=Debitor - &top 10-liste;
                                 ENU=Customer - &Top 10 List];
                      ToolTipML=[DAN=Vis de debitorer, der kõber mest, eller som skylder mest, i en bestemt periode. Kun de debitorer, der har kõb i lõbet af perioden eller en saldo ved periodens afslutning, vil blive vist i rapporten.;
                                 ENU=View which customers purchase the most or owe the most in a selected period. Only customers that have either purchases during the period or a balance at the end of the period will be included.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Report 111;
                      Image=Report }
      { 17      ;1   ;Separator  }
      { 18      ;1   ;Action    ;
                      CaptionML=[DAN=S&algsstatistik;
                                 ENU=S&ales Statistics];
                      ToolTipML=[DAN=Se eller rediger detaljerede oplysninger om salget til dine debitorer.;
                                 ENU=View detailed information about sales to your customers.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Report 112;
                      Image=Report }
      { 19      ;1   ;Action    ;
                      CaptionML=[DAN=Sëlger - &salgsstatistik;
                                 ENU=Salesperson - Sales &Statistics];
                      ToolTipML=[DAN=Vis belõb for salg, avancebelõb, fakturarabat og kontantrabat samt avanceprocent for hver sëlger i den valgte periode. Desuden viser rapporten reguleret avance og reguleret avanceprocent, som afspejler evt. ëndringer i den oprindelige belõb for de varer, der indgÜr i salget.;
                                 ENU=View amounts for sales, profit, invoice discount, and payment discount, as well as profit percentage, for each salesperson for a selected period. The report also shows the adjusted profit and adjusted profit percentage, which reflect any changes to the original costs of the items in the sales.];
                      ApplicationArea=#Suite,#RelationshipMgmt;
                      RunObject=Report 114;
                      Image=Report }
      { 20      ;1   ;Action    ;
                      CaptionML=[DAN=Sëlger - salgs&provision;
                                 ENU=Salesperson - &Commission];
                      ToolTipML=[DAN=Vis en oversigt over fakturaer for hver sëlger i en valgt periode. Der vises fõlgende oplysninger om hver faktura: debitornummer, salgsbelõb, avancebelõb og provisionen pÜ salgsbelõbet og avancebelõbet. Desuden vises reguleret avance og reguleret avanceprovision, som er de avancetal, der afspejler evt. ëndringer i de oprindelige belõb for de solgte varer. Rapporten kan f.eks. bruges til beregning og dokumentation af sëlgerprovision.;
                                 ENU=View a list of invoices for each salesperson for a selected period. The following information is shown for each invoice: Customer number, sales amount, profit amount, and the commission on sales amount and profit amount. The report also shows the adjusted profit and the adjusted profit commission, which are the profit figures that reflect any changes to the original costs of the goods sold.];
                      ApplicationArea=#Suite,#RelationshipMgmt;
                      RunObject=Report 115;
                      Image=Report }
      { 22      ;1   ;Separator  }
      { 24      ;1   ;Action    ;
                      CaptionML=[DAN=Kampagne - &detaljer;
                                 ENU=Campaign - &Details];
                      ToolTipML=[DAN=Vis detaljerede oplysninger om kampagnen.;
                                 ENU=Show detailed information about the campaign.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Report 5060;
                      Image=Report }
      { 1900000011;0 ;ActionContainer;
                      ActionContainerType=HomeItems }
      { 8       ;1   ;Action    ;
                      CaptionML=[DAN=Kontakter;
                                 ENU=Contacts];
                      ToolTipML=[DAN=Vis en liste med alle dine kontakter.;
                                 ENU=View a list of all your contacts.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5052;
                      Image=CustomerContact }
      { 25      ;1   ;Action    ;
                      CaptionML=[DAN=Salgsmuligheder;
                                 ENU=Opportunities];
                      ToolTipML=[DAN=Vis de salgsmuligheder, der hÜndteres af sëlgere for kontakten. Salgsmuligheder skal omfatte en kontakt og kan knyttes til kampagner.;
                                 ENU=View the sales opportunities that are handled by salespeople for the contact. Opportunities must involve a contact and can be linked to campaigns.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5123 }
      { 5       ;1   ;Action    ;
                      CaptionML=[DAN=Salgstilbud;
                                 ENU=Sales Quotes];
                      ToolTipML=[DAN=Giv tilbud til debitorer for at sëlge bestemte varer pÜ bestemte leverings- og betalingsbetingelser. NÜr du forhandler med en debitor, kan du ëndre og sende salgstilbud, sÜ mange gange du behõver. NÜr debitoren accepterer tilbuddet, skal du konvertere salgstilbuddet til en salgsfaktura eller en salgsordre, som du bruger til at behandle salget.;
                                 ENU=Make offers to customers to sell certain products on certain delivery and payment terms. While you negotiate with a customer, you can change and resend the sales quote as much as needed. When the customer accepts the offer, you convert the sales quote to a sales invoice or a sales order in which you process the sale.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 9300;
                      Image=Quote }
      { 15      ;1   ;Action    ;
                      CaptionML=[DAN=Salgsordrer;
                                 ENU=Sales Orders];
                      ToolTipML=[DAN=Registrer dine aftaler med debitorer for at sëlge bestemte varer pÜ bestemte leverings- og betalingsbetingelser. Salgsordrer gõr det i modsëtning til salgsfakturaer muligt at levere delvist, levere direkte fra kreditoren til debitoren, starte lagerekspedition og udskrive forskellige dokumenter til kunderne. Salgsfakturering er integreret i salgsordreprocessen.;
                                 ENU=Record your agreements with customers to sell certain products on certain delivery and payment terms. Sales orders, unlike sales invoices, allow you to ship partially, deliver directly from your vendor to your customer, initiate warehouse handling, and print various customer-facing documents. Sales invoicing is integrated in the sales order process.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 9305;
                      Image=Order }
      { 41      ;1   ;Action    ;
                      CaptionML=[DAN=Debitorer;
                                 ENU=Customers];
                      ToolTipML=[DAN=FÜ vist eller rediger detaljerede oplysninger om de debitorer, som du handler med. Fra det enkelte debitorkort kan du fÜ adgang til relaterede oplysninger som f.eks. salgsstatistik og igangvërende ordrer, og du kan definere specialpriser og linjerabatter, som debitoren fÜr, nÜr bestemte betingelser er opfyldt.;
                                 ENU=View or edit detailed information for the customers that you trade with. From each customer card, you can open related information, such as sales statistics and ongoing orders, and you can define special prices and line discounts that you grant if certain conditions are met.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 22;
                      Image=Customer }
      { 23      ;1   ;Action    ;
                      CaptionML=[DAN=Varer;
                                 ENU=Items];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om de produkter, du handler med. Varekortet kan vëre af typen lager eller tjeneste for at angive, om varen er en fysisk enhed eller en bestÜr af arbejdstimer. Her angiver du ogsÜ, om varerne pÜ lager eller i indgÜende ordrer automatisk reserveres til udgÜende bilag, og om der er oprettet ordresporingsbindinger mellem behov og forsyning for at afspejle planlëgningshandlinger.;
                                 ENU=View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 31;
                      Image=Item }
      { 9       ;1   ;Action    ;
                      CaptionML=[DAN=Aktive mÜlgrupper;
                                 ENU=Active Segments];
                      ToolTipML=[DAN=Vis mÜlgrupper, der i õjeblikket bruges i aktive kampagner.;
                                 ENU=View segments that are currently used in active campaigns.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5093 }
      { 12      ;1   ;Action    ;
                      CaptionML=[DAN=Logfõrte mÜlgrupper;
                                 ENU=Logged Segments];
                      ToolTipML=[DAN=Vis en liste over mÜlgrupper, som du har logfõrt.;
                                 ENU=View a list of the segments that you have logged.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5139 }
      { 53      ;1   ;Action    ;
                      CaptionML=[DAN=Kampagner;
                                 ENU=Campaigns];
                      ToolTipML=[DAN=Vis en liste med alle dine kampagner.;
                                 ENU=View a list of all your campaigns.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5087;
                      Image=Campaign }
      { 28      ;1   ;Action    ;
                      CaptionML=[DAN=Sëlgere;
                                 ENU=Salespersons];
                      ToolTipML=[DAN=Vis en liste med dine salgsmedarbejdere.;
                                 ENU=View a list of your sales people.];
                      ApplicationArea=#Suite,#RelationshipMgmt;
                      RunObject=Page 14 }
      { 1900000012;0 ;ActionContainer;
                      ActionContainerType=ActivityButtons }
      { 39      ;1   ;ActionGroup;
                      CaptionML=[DAN=Administration - kõb/salg;
                                 ENU=Administration Sales/Purchase];
                      Image=AdministrationSalesPurchases }
      { 40      ;2   ;Action    ;
                      CaptionML=[DAN=Sëlgere/indkõbere;
                                 ENU=Salespeople/Purchasers];
                      ToolTipML=[DAN=Vis en liste med dine salgsmedarbejdere og dine indkõbere.;
                                 ENU=View a list of your sales people and your purchasers.];
                      ApplicationArea=#Suite,#RelationshipMgmt;
                      RunObject=Page 14 }
      { 30      ;2   ;Action    ;
                      CaptionML=[DAN=Debitorprisgrupper;
                                 ENU=Customer Price Groups];
                      ToolTipML=[DAN=Vis en liste med dine debitorprisgrupper.;
                                 ENU=View a list of your customer price groups.];
                      ApplicationArea=#Suite,#RelationshipMgmt;
                      RunObject=Page 7 }
      { 32      ;2   ;Action    ;
                      CaptionML=[DAN=Deb./fakt.-rabatter;
                                 ENU=Cust. Invoice Discounts];
                      ToolTipML=[DAN=Vis eller rediger fakturarabatter, som du giver til visse debitorer.;
                                 ENU=View or edit invoice discounts that you grant to certain customers.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 23 }
      { 33      ;2   ;Action    ;
                      CaptionML=[DAN=Kreditor/fakturarabatter;
                                 ENU=Vend. Invoice Discounts];
                      ToolTipML=[DAN=Vis de fakturarabatter, som dine kreditorer giver dig.;
                                 ENU=View the invoice discounts that your vendors grant you.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 28 }
      { 34      ;2   ;Action    ;
                      CaptionML=[DAN=Varerabatgrupper;
                                 ENU=Item Disc. Groups];
                      ToolTipML=[DAN=Vis eller rediger rabatgruppekoder, som du kan bruge som kriterier, nÜr du giver sërlige rabatter til debitorer.;
                                 ENU=View or edit discount group codes that you can use as criteria when you grant special discounts to customers.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 513 }
      { 55      ;2   ;Action    ;
                      CaptionML=[DAN=Salgsprocesser;
                                 ENU=Sales Cycles];
                      ToolTipML=[DAN=FÜ vist de forskellige salgsprocesser, som du bruger til at administrere salgsmuligheder.;
                                 ENU=View the different sales cycles that you use to manage sales opportunities.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5119 }
      { 7       ;1   ;ActionGroup;
                      CaptionML=[DAN=Analyse;
                                 ENU=Analysis] }
      { 46      ;2   ;Action    ;
                      CaptionML=[DAN=Salgsanalyserapporter;
                                 ENU=Sales Analysis Reports];
                      ToolTipML=[DAN=Analyser udviklingen i dit salg i henhold til nõglesalgsindikatorer, som du vëlger, f.eks. salgsomsëtningen i bÜde belõb og antal, dëkningsbidrag eller det aktuelle salgs forlõb i forhold til budgettet. Du kan ogsÜ anvende rapporten til at analysere dine gennemsnitlige salgspriser og evaluere din salgsstyrkes prëstationer.;
                                 ENU=Analyze the dynamics of your sales according to key sales performance indicators that you select, for example, sales turnover in both amounts and quantities, contribution margin, or progress of actual sales against the budget. You can also use the report to analyze your average sales prices and evaluate the sales performance of your sales force.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9376 }
      { 43      ;2   ;Action    ;
                      CaptionML=[DAN=Dimensionsanalyse - Salg;
                                 ENU=Sales Analysis by Dimensions];
                      ToolTipML=[DAN=Vis salgsbelõb i finanskonti efter deres dimensionsvërdier og andre filtre, som du definerer i en analysevisning og derefter viser i et matrixvindue.;
                                 ENU=View sales amounts in G/L accounts by their dimension values and other filters that you define in an analysis view and then show in a matrix window.];
                      ApplicationArea=#Dimensions;
                      RunObject=Page 9371 }
      { 31      ;2   ;Action    ;
                      CaptionML=[DAN=Salgsbudgetter;
                                 ENU=Sales Budgets];
                      ToolTipML=[DAN=Angiv varesalgsvërdier af typen belõb, antal eller omkostningen for det forventede varesalg i forskellige perioder. Du kan oprette salgsbudgetter ud fra varer, debitorer, debitorgrupper eller andre dimensioner i virksomheden. De resulterende salgsbudgetter kan gennemgÜs her, eller de kan bruges i sammenligning med faktiske salgsdata i salgsanalyserapporter.;
                                 ENU=Enter item sales values of type amount, quantity, or cost for expected item sales in different time periods. You can create sales budgets by items, customers, customer groups, or other dimensions in your business. The resulting sales budgets can be reviewed here or they can be used in comparisons with actual sales data in sales analysis reports.];
                      ApplicationArea=#SalesBudget;
                      RunObject=Page 9374 }
      { 38      ;2   ;Action    ;
                      CaptionML=[DAN=Kontakter;
                                 ENU=Contacts];
                      ToolTipML=[DAN=Vis en liste med alle dine kontakter.;
                                 ENU=View a list of all your contacts.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5052;
                      Image=CustomerContact }
      { 21      ;2   ;Action    ;
                      CaptionML=[DAN=Debitorer;
                                 ENU=Customers];
                      ToolTipML=[DAN=FÜ vist eller rediger detaljerede oplysninger om de debitorer, som du handler med. Fra det enkelte debitorkort kan du fÜ adgang til relaterede oplysninger som f.eks. salgsstatistik og igangvërende ordrer, og du kan definere specialpriser og linjerabatter, som debitoren fÜr, nÜr bestemte betingelser er opfyldt.;
                                 ENU=View or edit detailed information for the customers that you trade with. From each customer card, you can open related information, such as sales statistics and ongoing orders, and you can define special prices and line discounts that you grant if certain conditions are met.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 22;
                      Image=Customer }
      { 49      ;1   ;ActionGroup;
                      CaptionML=[DAN=Selvbetjening;
                                 ENU=Self-Service];
                      ToolTipML=[DAN=Administrer dine timesedler og opgaver.;
                                 ENU=Manage your time sheets and assignments.];
                      Image=HumanResources }
      { 36      ;2   ;Action    ;
                      CaptionML=[DAN=Timesedler;
                                 ENU=Time Sheets];
                      ToolTipML=[DAN=Giv ressourcer mulighed for at tidsregistere. Efter godkendelsen, hvis en sÜdan krëves, kan timeseddelposterne bogfõres for den relevante sagskladde eller ressourcekladde som en del af registreringen af projektforlõbet. Hvis du vil spare konfigurationstid og sikre, at dataene er korrekte, kan du kopiere sagsplanlëgningslinjerne til timesedlerne.;
                                 ENU=Enable resources to register time. When approved, if approval is required, time sheet entries can be posted to the relevant job journal or resource journal as part of project progress reporting. To save setup time and to ensure data correctness, you can copy job planning lines into time sheets.];
                      ApplicationArea=#Suite;
                      RunObject=Page 951;
                      Gesture=None }
      { 48      ;2   ;Action    ;
                      Name=Page Time Sheet List Open;
                      CaptionML=[DAN=èbn;
                                 ENU=Open];
                      ToolTipML=[DAN=èbn kortet for den valgte record.;
                                 ENU=Open the card for the selected record.];
                      ApplicationArea=#Suite;
                      RunObject=Page 951;
                      RunPageView=WHERE(Open Exists=CONST(Yes)) }
      { 47      ;2   ;Action    ;
                      Name=Page Time Sheet List Submitted;
                      CaptionML=[DAN=Sendt;
                                 ENU=Submitted];
                      ToolTipML=[DAN=FÜ vist sendte timesedler.;
                                 ENU=View submitted time sheets.];
                      ApplicationArea=#Suite;
                      RunObject=Page 951;
                      RunPageView=WHERE(Submitted Exists=CONST(Yes)) }
      { 37      ;2   ;Action    ;
                      Name=Page Time Sheet List Rejected;
                      CaptionML=[DAN=Afvist;
                                 ENU=Rejected];
                      ToolTipML=[DAN=FÜ vist afviste timesedler.;
                                 ENU=View rejected time sheets.];
                      ApplicationArea=#Suite;
                      RunObject=Page 951;
                      RunPageView=WHERE(Rejected Exists=CONST(Yes)) }
      { 35      ;2   ;Action    ;
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
      { 42      ;1   ;ActionGroup;
                      CaptionML=[DAN=Ny;
                                 ENU=New] }
      { 52      ;2   ;Action    ;
                      Name=NewContact;
                      CaptionML=[DAN=Kontakt;
                                 ENU=Contact];
                      ToolTipML=[DAN=Opret en ny kontakt.;
                                 ENU=Create a new contact.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5050;
                      Image=AddContacts;
                      RunPageMode=Create }
      { 51      ;2   ;Action    ;
                      Name=NewOpportunity;
                      CaptionML=[DAN=Salgsmulighed;
                                 ENU=Opportunity];
                      ToolTipML=[DAN=Vis de salgsmuligheder, der hÜndteres af sëlgere for kontakten. Salgsmuligheder skal omfatte en kontakt og kan knyttes til kampagner.;
                                 ENU=View the sales opportunities that are handled by salespeople for the contact. Opportunities must involve a contact and can be linked to campaigns.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5124;
                      Image=NewOpportunity;
                      RunPageMode=Create }
      { 50      ;2   ;Action    ;
                      Name=NewSegment;
                      CaptionML=[DAN=MÜlgruppe;
                                 ENU=Segment];
                      ToolTipML=[DAN=Opret et nyt segment, hvor du kan styre interaktioner med en kontakt.;
                                 ENU=Create a new segment where you manage interactions with a contact.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5091;
                      Image=Segment;
                      RunPageMode=Create }
      { 54      ;2   ;Action    ;
                      Name=NewCampaign;
                      CaptionML=[DAN=Kampagne;
                                 ENU=Campaign];
                      ToolTipML=[DAN=Opret en ny kampagne;
                                 ENU=Create a new campaign];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5086;
                      Image=Campaign;
                      RunPageMode=Create }
      { 44      ;1   ;ActionGroup;
                      CaptionML=[DAN=Salgspriser;
                                 ENU=Sales Prices] }
      { 26      ;2   ;Action    ;
                      CaptionML=[DAN=Salgs&priskladde;
                                 ENU=Sales Price &Worksheet];
                      ToolTipML=[DAN=Administrer salgspriser for individuelle debitorer, for en debitorgruppe, for alle debitorer eller for en kampagne.;
                                 ENU=Manage sales prices for individual customers, for a group of customers, for all customers, or for a campaign.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 7023;
                      Image=PriceWorksheet }
      { 3       ;2   ;Action    ;
                      CaptionML=[DAN=Salgs&priser;
                                 ENU=Sales &Prices];
                      ToolTipML=[DAN=Definer, hvordan salgsprisaftaler skal oprettes. Salgspriserne kan gëlde for individuelle debitorer, for debitorgrupper, for alle debitorer eller for en kampagne.;
                                 ENU=Define how to set up sales price agreements. These sales prices can be for individual customers, for a group of customers, for all customers, or for a campaign.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 7002;
                      Image=SalesPrices }
      { 10      ;2   ;Action    ;
                      CaptionML=[DAN=Salgslinje&rabatter;
                                 ENU=Sales Line &Discounts];
                      ToolTipML=[DAN=FÜ vist eller rediger de salgslinjerabatter, som du giver, nÜr bestemte betingelser er opfyldt, f.eks. debitor, mëngde eller slutdato. Rabataftalerne kan gëlde for individuelle debitorer, for debitorgrupper, for alle debitorer eller for en kampagne.;
                                 ENU=View or edit sales line discounts that you grant when certain conditions are met, such as customer, quantity, or ending date. The discount agreements can be for individual customers, for a group of customers, for all customers or for a campaign.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 7004;
                      Image=SalesLineDisc }
      { 29      ;1   ;ActionGroup;
                      CaptionML=[DAN=Flow;
                                 ENU=Flow] }
      { 27      ;2   ;Action    ;
                      Name=Manage Flows;
                      CaptionML=[DAN=HÜndter flow;
                                 ENU=Manage Flows];
                      ToolTipML=[DAN=Vis eller rediger automatiske workflows, der er oprettet med Flow.;
                                 ENU=View or edit automated workflows created with Flow.;
                                 ENG=View and manage your flows.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 6401;
                      Image=Flow }
    }
  }
  CONTROLS
  {
    { 1900000008;0;Container;
                ContainerType=RoleCenterArea }

    { 1   ;1   ;Part      ;
                ApplicationArea=#RelationshipMgmt;
                PagePartID=Page9076;
                PartType=Page }

    { 16  ;1   ;Part      ;
                ApplicationArea=#RelationshipMgmt;
                PagePartID=Page9042;
                PartType=Page }

    { 4   ;1   ;Part      ;
                ApplicationArea=#RelationshipMgmt;
                PagePartID=Page781;
                PartType=Page }

    { 6   ;1   ;Part      ;
                ApplicationArea=#RelationshipMgmt;
                PagePartID=Page782;
                PartType=Page }

    { 11  ;1   ;Part      ;
                ApplicationArea=#RelationshipMgmt;
                PagePartID=Page783;
                PartType=Page }

    { 2   ;1   ;Part      ;
                ApplicationArea=#RelationshipMgmt;
                PagePartID=Page6303;
                PartType=Page }

    { 56  ;1   ;Part      ;
                ApplicationArea=#RelationshipMgmt;
                PagePartID=Page9078;
                PartType=Page }

  }
  CODE
  {

    BEGIN
    END.
  }
}

