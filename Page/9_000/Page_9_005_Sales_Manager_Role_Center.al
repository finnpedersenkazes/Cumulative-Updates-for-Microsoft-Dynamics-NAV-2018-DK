OBJECT Page 9005 Sales Manager Role Center
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[@@@="{Dependency=Match,""ProfileDescription_SALESMANAGER""}";
               DAN=Salgschef;
               ENU=Sales Manager];
    PageType=RoleCenter;
    ActionList=ACTIONS
    {
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 13      ;1   ;Action    ;
                      CaptionML=[DAN=Debitor - &ordreoversigt;
                                 ENU=Customer - &Order Summary];
                      ToolTipML=[DAN=Vis den ikke-leverede beholdning pr. debitor i tre perioder Ö 30 dage med udgangspunkt i en valgt dato. Der vises desuden kolonner med ordrer, der skal leveres fõr og efter de tre perioder, og en kolonne med ordrebeholdningen pr. debitor i alt. Rapporten kan f.eks. bruges til at analysere virksomhedens forventede omsëtning.;
                                 ENU=View the quantity not yet shipped for each customer in three periods of 30 days each, starting from a selected date. There are also columns with orders to be shipped before and after the three periods and a column with the total order detail for each customer. The report can be used to analyze a company's expected sales volume.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 107;
                      Image=Report }
      { 14      ;1   ;Action    ;
                      CaptionML=[DAN=Debitor - &top 10-liste;
                                 ENU=Customer - &Top 10 List];
                      ToolTipML=[DAN=Vis de debitorer, der kõber mest, eller som skylder mest, i en bestemt periode. Kun de debitorer, der har kõb i lõbet af perioden eller en saldo ved periodens afslutning, vil blive vist i rapporten.;
                                 ENU=View which customers purchase the most or owe the most in a selected period. Only customers that have either purchases during the period or a balance at the end of the period will be included.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 111;
                      Image=Report }
      { 17      ;1   ;Separator  }
      { 18      ;1   ;Action    ;
                      CaptionML=[DAN=S&algsstatistik;
                                 ENU=S&ales Statistics];
                      ToolTipML=[DAN=Se eller rediger detaljerede oplysninger om salget til dine debitorer.;
                                 ENU=View detailed information about sales to your customers.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 112;
                      Image=Report }
      { 19      ;1   ;Action    ;
                      CaptionML=[DAN=Sëlger - &salgsstatistik;
                                 ENU=Salesperson - Sales &Statistics];
                      ToolTipML=[DAN=Vis belõb for salg, avancebelõb, fakturarabat og kontantrabat samt avanceprocent for hver sëlger i den valgte periode. Desuden viser rapporten reguleret avance og reguleret avanceprocent, som afspejler evt. ëndringer i den oprindelige belõb for de varer, der indgÜr i salget.;
                                 ENU=View amounts for sales, profit, invoice discount, and payment discount, as well as profit percentage, for each salesperson for a selected period. The report also shows the adjusted profit and adjusted profit percentage, which reflect any changes to the original costs of the items in the sales.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 114;
                      Image=Report }
      { 20      ;1   ;Action    ;
                      CaptionML=[DAN=Sëlger - salgs&provision;
                                 ENU=Salesperson - &Commission];
                      ToolTipML=[DAN=Vis en oversigt over fakturaer for hver sëlger i en valgt periode. Der vises fõlgende oplysninger om hver faktura: debitornummer, salgsbelõb, avancebelõb og provisionen pÜ salgsbelõbet og avancebelõbet. Desuden vises reguleret avance og reguleret avanceprovision, som er de avancetal, der afspejler evt. ëndringer i de oprindelige belõb for de solgte varer. Rapporten kan f.eks. bruges til beregning og dokumentation af sëlgerprovision.;
                                 ENU=View a list of invoices for each salesperson for a selected period. The following information is shown for each invoice: Customer number, sales amount, profit amount, and the commission on sales amount and profit amount. The report also shows the adjusted profit and the adjusted profit commission, which are the profit figures that reflect any changes to the original costs of the goods sold.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 115;
                      Image=Report }
      { 22      ;1   ;Separator  }
      { 24      ;1   ;Action    ;
                      CaptionML=[DAN=Kampagne - &detaljer;
                                 ENU=Campaign - &Details];
                      ToolTipML=[DAN=Vis detaljerede oplysninger om kampagnen.;
                                 ENU=Show detailed information about the campaign.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 5060;
                      Image=Report }
      { 1900000011;0 ;ActionContainer;
                      ActionContainerType=HomeItems }
      { 9       ;1   ;Action    ;
                      CaptionML=[DAN=Salgsanalyserapporter;
                                 ENU=Sales Analysis Reports];
                      ToolTipML=[DAN=Analyser udviklingen i dit salg i henhold til nõglesalgsindikatorer, som du vëlger, f.eks. salgsomsëtningen i bÜde belõb og antal, dëkningsbidrag eller det aktuelle salgs forlõb i forhold til budgettet. Du kan ogsÜ anvende rapporten til at analysere dine gennemsnitlige salgspriser og evaluere din salgsstyrkes prëstationer.;
                                 ENU=Analyze the dynamics of your sales according to key sales performance indicators that you select, for example, sales turnover in both amounts and quantities, contribution margin, or progress of actual sales against the budget. You can also use the report to analyze your average sales prices and evaluate the sales performance of your sales force.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9376 }
      { 12      ;1   ;Action    ;
                      CaptionML=[DAN=Dimensionsanalyse - Salg;
                                 ENU=Sales Analysis by Dimensions];
                      ToolTipML=[DAN=Vis salgsbelõb i finanskonti efter deres dimensionsvërdier og andre filtre, som du definerer i en analysevisning og derefter viser i et matrixvindue.;
                                 ENU=View sales amounts in G/L accounts by their dimension values and other filters that you define in an analysis view and then show in a matrix window.];
                      ApplicationArea=#Dimensions;
                      RunObject=Page 9371 }
      { 8       ;1   ;Action    ;
                      CaptionML=[DAN=Salgsbudgetter;
                                 ENU=Sales Budgets];
                      ToolTipML=[DAN=Angiv varesalgsvërdier af typen belõb, antal eller omkostningen for det forventede varesalg i forskellige perioder. Du kan oprette salgsbudgetter ud fra varer, debitorer, debitorgrupper eller andre dimensioner i virksomheden. De resulterende salgsbudgetter kan gennemgÜs her, eller de kan bruges i sammenligning med faktiske salgsdata i salgsanalyserapporter.;
                                 ENU=Enter item sales values of type amount, quantity, or cost for expected item sales in different time periods. You can create sales budgets by items, customers, customer groups, or other dimensions in your business. The resulting sales budgets can be reviewed here or they can be used in comparisons with actual sales data in sales analysis reports.];
                      ApplicationArea=#SalesBudget;
                      RunObject=Page 9374 }
      { 5       ;1   ;Action    ;
                      CaptionML=[DAN=Salgstilbud;
                                 ENU=Sales Quotes];
                      ToolTipML=[DAN=Giv tilbud til debitorer for at sëlge bestemte varer pÜ bestemte leverings- og betalingsbetingelser. NÜr du forhandler med en debitor, kan du ëndre og sende salgstilbud, sÜ mange gange du behõver. NÜr debitoren accepterer tilbuddet, skal du konvertere salgstilbuddet til en salgsfaktura eller en salgsordre, som du bruger til at behandle salget.;
                                 ENU=Make offers to customers to sell certain products on certain delivery and payment terms. While you negotiate with a customer, you can change and resend the sales quote as much as needed. When the customer accepts the offer, you convert the sales quote to a sales invoice or a sales order in which you process the sale.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9300;
                      Image=Quote }
      { 15      ;1   ;Action    ;
                      Name=SalesOrders;
                      CaptionML=[DAN=Salgsordrer;
                                 ENU=Sales Orders];
                      ToolTipML=[DAN=Registrer dine aftaler med debitorer for at sëlge bestemte varer pÜ bestemte leverings- og betalingsbetingelser. Salgsordrer gõr det i modsëtning til salgsfakturaer muligt at levere delvist, levere direkte fra kreditoren til debitoren, starte lagerekspedition og udskrive forskellige dokumenter til kunderne. Salgsfakturering er integreret i salgsordreprocessen.;
                                 ENU=Record your agreements with customers to sell certain products on certain delivery and payment terms. Sales orders, unlike sales invoices, allow you to ship partially, deliver directly from your vendor to your customer, initiate warehouse handling, and print various customer-facing documents. Sales invoicing is integrated in the sales order process.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9305;
                      Image=Order }
      { 7       ;1   ;Action    ;
                      Name=SalesOrdersOpen;
                      ShortCutKey=Return;
                      CaptionML=[DAN=èbn;
                                 ENU=Open];
                      ToolTipML=[DAN=èbn kortet for den valgte record.;
                                 ENU=Open the card for the selected record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9305;
                      RunPageView=WHERE(Status=FILTER(Open));
                      Image=Edit }
      { 36      ;1   ;Action    ;
                      CaptionML=[DAN=Salgsordrer - Microsoft Dynamics 365 for Sales;
                                 ENU=Sales Orders - Microsoft Dynamics 365 for Sales];
                      ToolTipML=[DAN=Vis salgsordrer i Dynamics 365 for Sales, der er sammenkëdet med salgsordrer i Dynamics NAV.;
                                 ENU=View sales orders in Dynamics 365 for Sales that are coupled with sales orders in Dynamics NAV.];
                      ApplicationArea=#Suite;
                      RunObject=Page 5353;
                      RunPageView=WHERE(StateCode=FILTER(Submitted),
                                        LastBackofficeSubmit=FILTER('')) }
      { 35      ;1   ;Action    ;
                      Name=SalesInvoices;
                      CaptionML=[DAN=Salgsfakturaer;
                                 ENU=Sales Invoices];
                      ToolTipML=[DAN=Registrer dit salg til debitorer, og inviter dem til at betale i henhold til leverings- og betalingsbetingelserne ved at sende dem et salgsfakturadokument. Bogfõring af en salgsfaktura registrerer leveringen og registrerer en Üben tilgodehavendepost pÜ debitorens konto, som vil blive lukket, nÜr betalingen er modtaget. Brug salgsordrer, hvor salgsfaktureringen er integreret, til at administrere leveringsprocessen.;
                                 ENU=Register your sales to customers and invite them to pay according to the delivery and payment terms by sending them a sales invoice document. Posting a sales invoice registers shipment and records an open receivable entry on the customer's account, which will be closed when payment is received. To manage the shipment process, use sales orders, in which sales invoicing is integrated.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9301;
                      Image=Invoice }
      { 16      ;1   ;Action    ;
                      Name=SalesInvoicesOpen;
                      ShortCutKey=Return;
                      CaptionML=[DAN=èbn;
                                 ENU=Open];
                      ToolTipML=[DAN=èbn kortet for den valgte record.;
                                 ENU=Open the card for the selected record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9301;
                      RunPageView=WHERE(Status=FILTER(Open));
                      Image=Edit }
      { 23      ;1   ;Action    ;
                      CaptionML=[DAN=Varer;
                                 ENU=Items];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om de produkter, du handler med. Varekortet kan vëre af typen lager eller tjeneste for at angive, om varen er en fysisk enhed eller en bestÜr af arbejdstimer. Her angiver du ogsÜ, om varerne pÜ lager eller i indgÜende ordrer automatisk reserveres til udgÜende bilag, og om der er oprettet ordresporingsbindinger mellem behov og forsyning for at afspejle planlëgningshandlinger.;
                                 ENU=View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 31;
                      Image=Item }
      { 25      ;1   ;Action    ;
                      CaptionML=[DAN=Kontakter;
                                 ENU=Contacts];
                      ToolTipML=[DAN=Vis en liste med alle dine kontakter.;
                                 ENU=View a list of all your contacts.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5052;
                      Image=CustomerContact }
      { 26      ;1   ;Action    ;
                      CaptionML=[DAN=Debitorer;
                                 ENU=Customers];
                      ToolTipML=[DAN=FÜ vist eller rediger detaljerede oplysninger om de debitorer, som du handler med. Fra det enkelte debitorkort kan du fÜ adgang til relaterede oplysninger som f.eks. salgsstatistik og igangvërende ordrer, og du kan definere specialpriser og linjerabatter, som debitoren fÜr, nÜr bestemte betingelser er opfyldt.;
                                 ENU=View or edit detailed information for the customers that you trade with. From each customer card, you can open related information, such as sales statistics and ongoing orders, and you can define special prices and line discounts that you grant if certain conditions are met.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 22;
                      Image=Customer }
      { 27      ;1   ;Action    ;
                      CaptionML=[DAN=Kampagner;
                                 ENU=Campaigns];
                      ToolTipML=[DAN=Vis en liste med alle dine kampagner.;
                                 ENU=View a list of all your campaigns.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5087;
                      Image=Campaign }
      { 28      ;1   ;Action    ;
                      CaptionML=[DAN=MÜlgrupper;
                                 ENU=Segments];
                      ToolTipML=[DAN=Opret et nyt segment, hvor du kan styre interaktioner med en kontakt.;
                                 ENU=Create a new segment where you manage interactions with a contact.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5093;
                      Image=Segment }
      { 29      ;1   ;Action    ;
                      CaptionML=[DAN=Opgaver;
                                 ENU=Tasks];
                      ToolTipML=[DAN=FÜ vist listen over eksisterende marketingopgaver.;
                                 ENU=View the list of marketing tasks that exist.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5096;
                      Image=TaskList }
      { 30      ;1   ;Action    ;
                      CaptionML=[DAN=Teams;
                                 ENU=Teams];
                      ToolTipML=[DAN=FÜ vist listen over eksisterende marketingteams.;
                                 ENU=View the list of marketing teams that exist.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5105;
                      Image=TeamSales }
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
                      ApplicationArea=#Advanced;
                      RunObject=Page 14 }
      { 32      ;2   ;Action    ;
                      CaptionML=[DAN=Deb./fakt.-rabatter;
                                 ENU=Cust. Invoice Discounts];
                      ToolTipML=[DAN=Vis eller rediger fakturarabatter, som du giver til visse debitorer.;
                                 ENU=View or edit invoice discounts that you grant to certain customers.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 23 }
      { 33      ;2   ;Action    ;
                      CaptionML=[DAN=Kred./fakt.-rabatter;
                                 ENU=Vend. Invoice Discounts];
                      ToolTipML=[DAN=Vis de fakturarabatter, som dine kreditorer giver dig.;
                                 ENU=View the invoice discounts that your vendors grant you.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 28 }
      { 34      ;2   ;Action    ;
                      CaptionML=[DAN=Varerabatgrupper;
                                 ENU=Item Disc. Groups];
                      ToolTipML=[DAN=Vis eller rediger rabatgruppekoder, som du kan bruge som kriterier, nÜr du giver sërlige rabatter til debitorer.;
                                 ENU=View or edit discount group codes that you can use as criteria when you grant special discounts to customers.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 513 }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 48      ;1   ;Separator ;
                      CaptionML=[DAN=Opgaver;
                                 ENU=Tasks];
                      IsHeader=Yes }
      { 37      ;1   ;Action    ;
                      CaptionML=[DAN=Salgspris&kladde;
                                 ENU=Sales Price &Worksheet];
                      ToolTipML=[DAN=Administrer salgspriser for individuelle debitorer, for en debitorgruppe, for alle debitorer eller for en kampagne.;
                                 ENU=Manage sales prices for individual customers, for a group of customers, for all customers, or for a campaign.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 7023;
                      Image=PriceWorksheet }
      { 2       ;1   ;Separator  }
      { 3       ;1   ;Action    ;
                      CaptionML=[DAN=Salgs&priser;
                                 ENU=Sales &Prices];
                      ToolTipML=[DAN=Definer, hvordan salgsprisaftaler skal oprettes. Salgspriserne kan gëlde for individuelle debitorer, for debitorgrupper, for alle debitorer eller for en kampagne.;
                                 ENU=Define how to set up sales price agreements. These sales prices can be for individual customers, for a group of customers, for all customers, or for a campaign.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 7002;
                      Image=SalesPrices }
      { 10      ;1   ;Action    ;
                      CaptionML=[DAN=Salgslinje&rabatter;
                                 ENU=Sales Line &Discounts];
                      ToolTipML=[DAN=FÜ vist eller rediger de salgslinjerabatter, som du giver, nÜr bestemte betingelser er opfyldt, f.eks. debitor, mëngde eller slutdato. Rabataftalerne kan gëlde for individuelle debitorer, for debitorgrupper, for alle debitorer eller for en kampagne.;
                                 ENU=View or edit sales line discounts that you grant when certain conditions are met, such as customer, quantity, or ending date. The discount agreements can be for individual customers, for a group of customers, for all customers or for a campaign.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 7004;
                      Image=SalesLineDisc }
    }
  }
  CONTROLS
  {
    { 1900000008;0;Container;
                ContainerType=RoleCenterArea }

    { 1900724808;1;Group   }

    { 21  ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page9175;
                PartType=Page }

    { 1907692008;2;Part   ;
                ApplicationArea=#Advanced;
                PagePartID=Page9150;
                PartType=Page }

    { 1900724708;1;Group   }

    { 11  ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page770;
                PartType=Page }

    { 4   ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page760;
                PartType=Page }

    { 1   ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page675;
                Visible=false;
                PartType=Page }

    { 1902476008;2;Part   ;
                ApplicationArea=#Advanced;
                PagePartID=Page9151;
                Visible=false;
                PartType=Page }

    { 6   ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page681;
                PartType=Page }

    { 31  ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PartType=System;
                SystemPartID=MyNotes }

    { 42  ;2   ;Group     ;
                CaptionML=[DAN=Mine brugeropgaver;
                           ENU=My User Tasks];
                GroupType=Group }

    { 41  ;3   ;Part      ;
                CaptionML=[DAN=Brugeropgaver;
                           ENU=User Tasks];
                ApplicationArea=#Advanced;
                PagePartID=Page9078;
                PartType=Page }

  }
  CODE
  {

    BEGIN
    END.
  }
}

