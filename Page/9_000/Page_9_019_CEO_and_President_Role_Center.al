OBJECT Page 9019 CEO and President Role Center
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[@@@="{Dependency=Match,""ProfileDescription_PRESIDENT""}";
               DAN=Administrerende direktõr;
               ENU=President];
    PageType=RoleCenter;
    ActionList=ACTIONS
    {
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 1       ;1   ;Action    ;
                      CaptionML=[DAN=Lik&viditet;
                                 ENU=Recei&vables-Payables];
                      ToolTipML=[DAN=Foretag bogfõringsopgaver.;
                                 ENU=Perform bookkeeping tasks.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 5;
                      Image=ReceivablesPayables }
      { 2       ;1   ;Action    ;
                      CaptionML=[DAN=&Balance/budget;
                                 ENU=&Trial Balance/Budget];
                      ToolTipML=[DAN=Vis en rÜbalance, der sammenlignes med et budget. Du kan f.eks. vëlge at fÜ vist en rÜbalance for udvalgte dimensioner. Du kan bruge rapporten ved afslutningen af en regnskabsperiode eller ved Ürsopgõrelsen.;
                                 ENU=View a trial balance in comparison to a budget. You can choose to see a trial balance for selected dimensions. You can use the report at the close of an accounting period or fiscal year.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 9;
                      Image=Report }
      { 3       ;1   ;Action    ;
                      CaptionML=[DAN=è&rsregnskab;
                                 ENU=&Closing Trial Balance];
                      ToolTipML=[DAN=Vis, udskriv, eller send en rapport, der viser dette og sidste Ürs tal som en almindelig rÜbalance. Nulstilling af resultatopgõrelseskonti bogfõres ultimo i regnskabsÜret. Rapporten kan bruges i forbindelse med Ürsafslutning.;
                                 ENU=View, print, or send a report that shows this year's and last year's figures as an ordinary trial balance. The closing of the income statement accounts is posted at the end of a fiscal year. The report can be used in connection with closing a fiscal year.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 10;
                      Image=Report }
      { 5       ;1   ;Action    ;
                      CaptionML=[DAN=Saldo for regnskabs&Ür;
                                 ENU=&Fiscal Year Balance];
                      ToolTipML=[DAN=Vis, udskriv, eller send en rapport, der viser bevëgelser pÜ balancen for udvalgte perioder. Rapporten viser slutsaldoen ved afslutningen af det foregÜende regnskabsÜr for de valgte konti. Den viser ogsÜ regnskabsÜret til dato, dette regnskabsÜr ved afslutningen af den valgte periode og saldoen ved afslutningen af den valgte periode med undtagelse af ultimoposterne. Rapporten kan bruges ved afslutningen af en regnskabsperiode eller ved Ürsafslutningen.;
                                 ENU=View, print, or send a report that shows balance sheet movements for selected periods. The report shows the closing balance by the end of the previous fiscal year for the selected ledger accounts. It also shows the fiscal year until this date, the fiscal year by the end of the selected period, and the balance by the end of the selected period, excluding the closing entries. The report can be used at the close of an accounting period or fiscal year.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 36;
                      Image=Report }
      { 6       ;1   ;Separator  }
      { 7       ;1   ;Action    ;
                      CaptionML=[DAN=&Debitor - saldo;
                                 ENU=Customer - &Balance];
                      ToolTipML=[DAN=Vis en liste over debitorers betalingshistorik op til en bestemt dato. Du kan bruge rapporten til at udtrëkke oplysninger om din samlede salgsindkomst ved slutningen af en regnskabsperiode eller et regnskabsÜr.;
                                 ENU=View a list with customers' payment history up until a certain date. You can use the report to extract your total sales income at the close of an accounting period or fiscal year.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 121;
                      Image=Report }
      { 8       ;1   ;Action    ;
                      CaptionML=[DAN=Debitor - t&op 10-liste;
                                 ENU=Customer - T&op 10 List];
                      ToolTipML=[DAN=Vis de debitorer, der kõber mest, eller som skylder mest, i en bestemt periode. Kun de debitorer, der har kõb i lõbet af perioden eller en saldo ved periodens afslutning, vil blive vist i rapporten.;
                                 ENU=View which customers purchase the most or owe the most in a selected period. Only customers that have either purchases during the period or a balance at the end of the period will be included.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 111;
                      Image=Report }
      { 9       ;1   ;Action    ;
                      CaptionML=[DAN=Debitor - s&algsoversigt;
                                 ENU=Customer - S&ales List];
                      ToolTipML=[DAN=Vis debitorsalg for en given periode, f.eks. for at rapportere om salgsaktivitet til SKAT. Du kan vëlge kun at medtage debitorer med et samlet salg, der overstiger et bestemt belõb. Du kan ogsÜ angive, om rapporten skal vise adresseoplysningerne for hver enkelt debitor.;
                                 ENU=View customer sales for a period, for example, to report sales activity to customs and tax authorities. You can choose to include only customers with total sales that exceed a minimum amount. You can also specify whether you want the report to show address details for each customer.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 119;
                      Image=Report }
      { 10      ;1   ;Action    ;
                      CaptionML=[DAN=Sal&gsstatistik;
                                 ENU=Sales &Statistics];
                      ToolTipML=[DAN=Vis debitorers samlede omkostninger, salg eller avance over tid, f.eks. med henblik pÜ at analysere indtjeningstendenser. Rapporten viser belõb for den oprindelige og regulerede kostpris, omsëtning, avance, fakturarabat, kontantrabat og avanceprocent i tre regulerbare perioder.;
                                 ENU=View customers' total costs, sales, and profits over time, for example, to analyze earnings trends. The report shows amounts for original and adjusted costs, sales, profits, invoice discounts, payment discounts, and profit percentage in three adjustable periods.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 112;
                      Image=Report }
      { 11      ;1   ;Separator  }
      { 12      ;1   ;Action    ;
                      CaptionML=[DAN=Kreditor - &kõbsoversigt;
                                 ENU=Vendor - &Purchase List];
                      ToolTipML=[DAN=Vis en liste over dine kõb i en periode, f.eks. for at rapportere kõbsaktiviteter til SKAT.;
                                 ENU=View a list of your purchases in a period, for example, to report purchase activity to customs and tax authorities.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 309;
                      Image=Report }
      { 1900000011;0 ;ActionContainer;
                      ActionContainerType=HomeItems }
      { 13      ;1   ;Action    ;
                      CaptionML=[DAN=Kontoskemaer;
                                 ENU=Account Schedules];
                      ToolTipML=[DAN=FÜ indsigt i de finansielle data i din kontoplan. Kontoskemaer analyserer tal i finanskonti og sammenligner finansposter med finansbudgetposter. Eksempelvis kan du fÜ vist finansposterne som en procentsats af budgetposterne. Kontoskemaer indeholder data om de vigtigste Ürsregnskaber og visninger, f.eks. pengestrõmsdiagrammet.;
                                 ENU=Get insight into the financial data stored in your chart of accounts. Account schedules analyze figures in G/L accounts, and compare general ledger entries with general ledger budget entries. For example, you can view the general ledger entries as percentages of the budget entries. Account schedules provide the data for core financial statements and views, such as the Cash Flow chart.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 103 }
      { 14      ;1   ;Action    ;
                      CaptionML=[DAN=Dimensionsanalyse;
                                 ENU=Analysis by Dimensions];
                      ToolTipML=[DAN=Vis belõb i finanskonti efter deres dimensionsvërdier og andre filtre, som du definerer i en analysevisning og derefter viser i et matrixvindue.;
                                 ENU=View amounts in G/L accounts by their dimension values and other filters that you define in an analysis view and then show in a matrix window.];
                      ApplicationArea=#Dimensions;
                      RunObject=Page 556;
                      Image=AnalysisViewDimension }
      { 15      ;1   ;Action    ;
                      CaptionML=[DAN=Salgsanalyserapport;
                                 ENU=Sales Analysis Report];
                      ToolTipML=[DAN=Analyser udviklingen i dit salg i henhold til nõglesalgsindikatorer, som du vëlger, f.eks. salgsomsëtningen i bÜde belõb og antal, dëkningsbidrag eller det aktuelle salgs forlõb i forhold til budgettet. Du kan ogsÜ anvende rapporten til at analysere dine gennemsnitlige salgspriser og evaluere din salgsstyrkes prëstationer.;
                                 ENU=Analyze the dynamics of your sales according to key sales performance indicators that you select, for example, sales turnover in both amounts and quantities, contribution margin, or progress of actual sales against the budget. You can also use the report to analyze your average sales prices and evaluate the sales performance of your sales force.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9376;
                      RunPageView=WHERE(Analysis Area=FILTER(Sales)) }
      { 16      ;1   ;Action    ;
                      CaptionML=[DAN=Budgetter;
                                 ENU=Budgets];
                      ToolTipML=[DAN=Vis eller rediger anslÜede belõb for et interval af regnskabsperioder.;
                                 ENU=View or edit estimated amounts for a range of accounting periods.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 121 }
      { 17      ;1   ;Action    ;
                      CaptionML=[DAN=Salgsbudgetter;
                                 ENU=Sales Budgets];
                      ToolTipML=[DAN=Angiv varesalgsvërdier af typen belõb, antal eller omkostningen for det forventede varesalg i forskellige perioder. Du kan oprette salgsbudgetter ud fra varer, debitorer, debitorgrupper eller andre dimensioner i virksomheden. De resulterende salgsbudgetter kan gennemgÜs her, eller de kan bruges i sammenligning med faktiske salgsdata i salgsanalyserapporter.;
                                 ENU=Enter item sales values of type amount, quantity, or cost for expected item sales in different time periods. You can create sales budgets by items, customers, customer groups, or other dimensions in your business. The resulting sales budgets can be reviewed here or they can be used in comparisons with actual sales data in sales analysis reports.];
                      ApplicationArea=#SalesBudget;
                      RunObject=Page 7132;
                      RunPageView=WHERE(Analysis Area=FILTER(Sales)) }
      { 18      ;1   ;Action    ;
                      CaptionML=[DAN=Salgstilbud;
                                 ENU=Sales Quotes];
                      ToolTipML=[DAN=Giv tilbud til debitorer for at sëlge bestemte varer pÜ bestemte leverings- og betalingsbetingelser. NÜr du forhandler med en debitor, kan du ëndre og sende salgstilbud, sÜ mange gange du behõver. NÜr debitoren accepterer tilbuddet, skal du konvertere salgstilbuddet til en salgsfaktura eller en salgsordre, som du bruger til at behandle salget.;
                                 ENU=Make offers to customers to sell certain products on certain delivery and payment terms. While you negotiate with a customer, you can change and resend the sales quote as much as needed. When the customer accepts the offer, you convert the sales quote to a sales invoice or a sales order in which you process the sale.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9300;
                      Image=Quote }
      { 19      ;1   ;Action    ;
                      CaptionML=[DAN=Salgsordrer;
                                 ENU=Sales Orders];
                      ToolTipML=[DAN=Registrer dine aftaler med debitorer for at sëlge bestemte varer pÜ bestemte leverings- og betalingsbetingelser. Salgsordrer gõr det i modsëtning til salgsfakturaer muligt at levere delvist, levere direkte fra kreditoren til debitoren, starte lagerekspedition og udskrive forskellige dokumenter til kunderne. Salgsfakturering er integreret i salgsordreprocessen.;
                                 ENU=Record your agreements with customers to sell certain products on certain delivery and payment terms. Sales orders, unlike sales invoices, allow you to ship partially, deliver directly from your vendor to your customer, initiate warehouse handling, and print various customer-facing documents. Sales invoicing is integrated in the sales order process.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9305;
                      Image=Order }
      { 20      ;1   ;Action    ;
                      CaptionML=[DAN=Salgsfakturaer;
                                 ENU=Sales Invoices];
                      ToolTipML=[DAN=Registrer dit salg til debitorer, og inviter dem til at betale i henhold til leverings- og betalingsbetingelserne ved at sende dem et salgsfakturadokument. Bogfõring af en salgsfaktura registrerer leveringen og registrerer en Üben tilgodehavendepost pÜ debitorens konto, som vil blive lukket, nÜr betalingen er modtaget. Brug salgsordrer, hvor salgsfaktureringen er integreret, til at administrere leveringsprocessen.;
                                 ENU=Register your sales to customers and invite them to pay according to the delivery and payment terms by sending them a sales invoice document. Posting a sales invoice registers shipment and records an open receivable entry on the customer's account, which will be closed when payment is received. To manage the shipment process, use sales orders, in which sales invoicing is integrated.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9301;
                      Image=Invoice }
      { 22      ;1   ;Action    ;
                      CaptionML=[DAN=Debitorer;
                                 ENU=Customers];
                      ToolTipML=[DAN=FÜ vist eller rediger detaljerede oplysninger om de debitorer, som du handler med. Fra det enkelte debitorkort kan du fÜ adgang til relaterede oplysninger som f.eks. salgsstatistik og igangvërende ordrer, og du kan definere specialpriser og linjerabatter, som debitoren fÜr, nÜr bestemte betingelser er opfyldt.;
                                 ENU=View or edit detailed information for the customers that you trade with. From each customer card, you can open related information, such as sales statistics and ongoing orders, and you can define special prices and line discounts that you grant if certain conditions are met.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 22;
                      Image=Customer }
      { 23      ;1   ;Action    ;
                      CaptionML=[DAN=Kontakter;
                                 ENU=Contacts];
                      ToolTipML=[DAN=Vis en liste med alle dine kontakter.;
                                 ENU=View a list of all your contacts.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5052;
                      Image=CustomerContact }
      { 1900000012;0 ;ActionContainer;
                      ActionContainerType=ActivityButtons }
    }
  }
  CONTROLS
  {
    { 1900000008;0;Container;
                ContainerType=RoleCenterArea }

    { 1900724808;1;Group   }

    { 21  ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page762;
                PartType=Page }

    { 4   ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page762;
                Visible=false;
                PartType=Page }

    { 1907692008;2;Part   ;
                ApplicationArea=#Advanced;
                PagePartID=Page9150;
                PartType=Page }

    { 26  ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page9175;
                PartType=Page }

    { 1900724708;1;Group   }

    { 24  ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page869;
                PartType=Page }

    { 27  ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page770;
                PartType=Page }

    { 28  ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page770;
                Visible=false;
                PartType=Page }

    { 29  ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page681;
                PartType=Page }

    { 25  ;2   ;Part      ;
                ApplicationArea=#Advanced;
                PagePartID=Page675;
                Visible=false;
                PartType=Page }

    { 1902476008;2;Part   ;
                ApplicationArea=#Advanced;
                PagePartID=Page9151;
                Visible=false;
                PartType=Page }

    { 1905989608;2;Part   ;
                ApplicationArea=#Advanced;
                PagePartID=Page9152;
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

