OBJECT Page 21 Customer Card
{
  OBJECT-PROPERTIES
  {
    Date=26-01-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20348,NAVDK11.00.00.20348;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Debitorkort;
               ENU=Customer Card];
    SourceTable=Table18;
    PageType=Card;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport�r,Nyt bilag,Godkend,Anmod om godkendelse,Priser og rabatter,Naviger,Debitor;
                                ENU=New,Process,Report,New Document,Approve,Request Approval,Prices and Discounts,Navigate,Customer];
    OnInit=VAR
             ApplicationAreaSetup@1000 : Record 9178;
           BEGIN
             FoundationOnly := ApplicationAreaSetup.IsFoundationEnabled;

             SetCustomerNoVisibilityOnFactBoxes;

             ContactEditable := TRUE;

             OpenApprovalEntriesExistCurrUser := TRUE;
             GLNNoMandatory := "OIOUBL Profile Code" <> '';

             CaptionTxt := CurrPage.CAPTION;
             SetCaption(CaptionTxt);
             CurrPage.CAPTION(CaptionTxt);
           END;

    OnOpenPage=VAR
                 OfficeManagement@1002 : Codeunit 1630;
                 PermissionManager@1000 : Codeunit 9002;
               BEGIN
                 ActivateFields;

                 CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;

                 SetNoFieldVisible;
                 IsOfficeAddin := OfficeManagement.IsAvailable;
                 IsSaaS := PermissionManager.SoftwareAsAService;

                 IF FoundationOnly THEN
                   CurrPage.PriceAndLineDisc.PAGE.InitPage(FALSE);

                 ShowCharts := "No." <> '';
               END;

    OnAfterGetRecord=BEGIN
                       ActivateFields;
                       StyleTxt := SetStyle;
                     END;

    OnNewRecord=VAR
                  DocumentNoVisibility@1004 : Codeunit 1400;
                BEGIN
                  IF GUIALLOWED THEN
                    IF "No." = '' THEN
                      IF DocumentNoVisibility.CustomerNoSeriesIsDefault THEN
                        NewMode := TRUE;
                END;

    OnAfterGetCurrRecord=VAR
                           CRMCouplingManagement@1001 : Codeunit 5331;
                           WorkflowManagement@1000 : Codeunit 1501;
                           WorkflowEventHandling@1003 : Codeunit 1520;
                           WorkflowWebhookManagement@1002 : Codeunit 1543;
                           AgedAccReceivable@1004 : Codeunit 763;
                         BEGIN
                           CreateCustomerFromTemplate;
                           ActivateFields;
                           StyleTxt := SetStyle;
                           ShowWorkflowStatus := CurrPage.WorkflowStatus.PAGE.SetFilterOnWorkflowRecord(RECORDID);
                           IF CRMIntegrationEnabled THEN BEGIN
                             CRMIsCoupledToRecord := CRMCouplingManagement.IsRecordCoupledToCRM(RECORDID);
                             IF "No." <> xRec."No." THEN
                               CRMIntegrationManagement.SendResultNotification(Rec);
                           END;
                           OpenApprovalEntriesExistCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RECORDID);
                           OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);

                           IF FoundationOnly THEN BEGIN
                             GetSalesPricesAndSalesLineDisc;
                             BalanceExhausted := 10000 <= CalcCreditLimitLCYExpendedPct;
                             DaysPastDueDate := AgedAccReceivable.InvoicePaymentDaysAverage("No.");
                             AttentionToPaidDay := DaysPastDueDate > 0;
                           END;

                           CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RECORDID);

                           EventFilter := WorkflowEventHandling.RunWorkflowOnSendCustomerForApprovalCode + '|' +
                             WorkflowEventHandling.RunWorkflowOnCustomerChangedCode;

                           EnabledApprovalWorkflowsExist := WorkflowManagement.EnabledWorkflowExist(DATABASE::Customer,EventFilter);

                           WorkflowWebhookManagement.GetCanRequestAndCanCancel(RECORDID,CanRequestApprovalForFlow,CanCancelApprovalForFlow);

                           IF "No." <> '' THEN BEGIN
                             IF ShowCharts THEN
                               CurrPage.AgedAccReceivableChart.PAGE.UpdateChartForCustomer("No.");
                             IF IsOfficeAddin THEN
                               CurrPage.AgedAccReceivableChart2.PAGE.UpdateChartForCustomer("No.");
                           END;
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 74      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Debitor;
                                 ENU=&Customer];
                      Image=Customer }
      { 84      ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr�de, projekt eller afdeling, som du kan tildele til salgs- og k�bsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      RunObject=Page 540;
                      RunPageLink=Table ID=CONST(18),
                                  No.=FIELD(No.);
                      Image=Dimensions }
      { 99      ;2   ;Action    ;
                      CaptionML=[DAN=Bankkonti;
                                 ENU=Bank Accounts];
                      ToolTipML=[DAN=Se eller opret debitorens bankkonti. Du kan oprette et ubegr�nset antal bankkonti til hver debitor.;
                                 ENU=View or set up the customer's bank accounts. You can set up any number of bank accounts for each customer.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 424;
                      RunPageLink=Customer No.=FIELD(No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=BankAccount;
                      PromotedCategory=Category9;
                      PromotedOnly=Yes }
      { 19      ;2   ;Action    ;
                      CaptionML=[DAN=Direct Debit-betalingsaftaler;
                                 ENU=Direct Debit Mandates];
                      ToolTipML=[DAN=Se den direkte debiterings-betalingsaftale med debitorer om opkr�vning af fakturabetalinger fra deres bankkonto.;
                                 ENU=View the direct-debit mandates that reflect agreements with customers to collect invoice payments from their bank account.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 1230;
                      RunPageLink=Customer No.=FIELD(No.);
                      Promoted=Yes;
                      Image=MakeAgreement;
                      PromotedCategory=Category9;
                      PromotedOnly=Yes }
      { 81      ;2   ;Action    ;
                      Name=ShipToAddresses;
                      CaptionML=[DAN=&Leveringsadresser;
                                 ENU=Ship-&to Addresses];
                      ToolTipML=[DAN=Vis eller rediger de alternative leveringsadresser, hvorp� debitoren �nsker varer leveret til, hvis adresserne adskiller sig standardadresserne.;
                                 ENU=View or edit alternate shipping addresses where the customer wants items delivered if different from the regular address.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 301;
                      RunPageLink=Customer No.=FIELD(No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ShipAddress;
                      PromotedCategory=Category9;
                      PromotedOnly=Yes }
      { 14      ;2   ;Action    ;
                      Name=Contact;
                      AccessByPermission=TableData 5050=R;
                      CaptionML=[DAN=&Kontakt;
                                 ENU=C&ontact];
                      ToolTipML=[DAN=Se eller rediger detaljerede oplysninger om kontaktpersonen hos debitoren.;
                                 ENU=View or edit detailed information about the contact person at the customer.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ContactPerson;
                      PromotedCategory=Category9;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 ShowContact;
                               END;
                                }
      { 94      ;2   ;Action    ;
                      CaptionML=[DAN=Varere&ferencer;
                                 ENU=Cross Re&ferences];
                      ToolTipML=[DAN=Konfigurer debitors egen identifikation af de varer, som du s�lger til debitor. Krydshenvisninger til debitors varenummer betyder, at varenummeret automatisk vises i salgsdokument i stedet for det nummer, som du anvender.;
                                 ENU=Set up the customer's own identification of items that you sell to the customer. Cross-references to the customer's item number means that the item number is automatically shown on sales documents instead of the number that you use.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 5723;
                      RunPageView=SORTING(Cross-Reference Type,Cross-Reference Type No.);
                      RunPageLink=Cross-Reference Type=CONST(Customer),
                                  Cross-Reference Type No.=FIELD(No.);
                      Image=Change }
      { 78      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m�rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf�j bem�rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 124;
                      RunPageLink=Table Name=CONST(Customer),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 59      ;2   ;Action    ;
                      Name=ApprovalEntries;
                      AccessByPermission=TableData 454=R;
                      CaptionML=[DAN=Godkendelser;
                                 ENU=Approvals];
                      ToolTipML=[DAN=F� vist en liste over records, der afventer godkendelse. Du kan f.eks. se, hvem der har anmodet om godkendelse af recorden, hvorn�r den blev sendt og hvorn�r den skal godkendes.;
                                 ENU=View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Image=Approvals;
                      PromotedCategory=Category6;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 ApprovalsMgmt.OpenApprovalEntriesPage(RECORDID);
                               END;
                                }
      { 243     ;2   ;Action    ;
                      Name=CustomerReportSelections;
                      CaptionML=[DAN=Dokumentlayouts;
                                 ENU=Document Layouts];
                      ToolTipML=[DAN=Opret et layout for forskellige typer dokumenter, f.eks. fakturaer, tilbud og kreditnotaer.;
                                 ENU=Set up a layout for different types of documents such as invoices, quotes, and credit memos.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Quote;
                      OnAction=VAR
                                 CustomReportSelection@1000 : Record 9657;
                               BEGIN
                                 CustomReportSelection.SETRANGE("Source Type",DATABASE::Customer);
                                 CustomReportSelection.SETRANGE("Source No.","No.");
                                 PAGE.RUNMODAL(PAGE::"Customer Report Selections",CustomReportSelection);
                               END;
                                }
      { 31      ;1   ;ActionGroup;
                      Name=ActionGroupCRM;
                      CaptionML=[DAN=Dynamics 365 for Sales;
                                 ENU=Dynamics 365 for Sales];
                      Visible=CRMIntegrationEnabled }
      { 33      ;2   ;Action    ;
                      Name=CRMGotoAccount;
                      CaptionML=[DAN=Konto;
                                 ENU=Account];
                      ToolTipML=[DAN=�bn den sammenk�dede Dynamics 365 for Sales-konto.;
                                 ENU=Open the coupled Dynamics 365 for Sales account.];
                      ApplicationArea=#Suite;
                      Visible=CRMIntegrationEnabled;
                      Image=CoupledCustomer;
                      OnAction=VAR
                                 CRMIntegrationManagement@1000 : Codeunit 5330;
                               BEGIN
                                 CRMIntegrationManagement.ShowCRMEntityFromRecordID(RECORDID);
                               END;
                                }
      { 53      ;2   ;Action    ;
                      Name=CRMSynchronizeNow;
                      AccessByPermission=TableData 5331=IM;
                      CaptionML=[DAN=Synkroniser;
                                 ENU=Synchronize];
                      ToolTipML=[DAN=Send eller hent opdaterede data til eller fra Dynamics 365 for Sales.;
                                 ENU=Send or get updated data to or from Dynamics 365 for Sales.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Visible=CRMIntegrationEnabled;
                      Image=Refresh;
                      PromotedCategory=Category9;
                      OnAction=VAR
                                 CRMIntegrationManagement@1001 : Codeunit 5330;
                               BEGIN
                                 CRMIntegrationManagement.UpdateOneNow(RECORDID);
                               END;
                                }
      { 43      ;2   ;Action    ;
                      Name=UpdateStatisticsInCRM;
                      CaptionML=[DAN=Opdat�r kontostatistik;
                                 ENU=Update Account Statistics];
                      ToolTipML=[DAN=Send debitorstatistikdata til Dynamics 365 for Sales til opdatering af faktaboksen Kontostatistik.;
                                 ENU=Send customer statistics data to Dynamics 365 for Sales to update the Account Statistics FactBox.];
                      ApplicationArea=#Suite;
                      Visible=CRMIntegrationEnabled;
                      Enabled=CRMIsCoupledToRecord;
                      Image=UpdateXML;
                      OnAction=VAR
                                 CRMIntegrationManagement@1000 : Codeunit 5330;
                               BEGIN
                                 CRMIntegrationManagement.CreateOrUpdateCRMAccountStatistics(Rec);
                               END;
                                }
      { 51      ;2   ;ActionGroup;
                      Name=Coupling;
                      CaptionML=[@@@=Coupling is a noun;
                                 DAN=Sammenk�dning;
                                 ENU=Coupling];
                      ToolTipML=[DAN=Opret, rediger eller slet en sammenk�dning mellem Microsoft Dynamics NAV-recorden og en Dynamics 365 for Sales-record.;
                                 ENU=Create, change, or delete a coupling between the Microsoft Dynamics NAV record and a Dynamics 365 for Sales record.];
                      Image=LinkAccount }
      { 47      ;3   ;Action    ;
                      Name=ManageCRMCoupling;
                      AccessByPermission=TableData 5331=IM;
                      CaptionML=[DAN=Konfigurer sammenk�dning;
                                 ENU=Set Up Coupling];
                      ToolTipML=[DAN=Opret eller rediger sammenk�dningen med en Dynamics 365 for Sales-konto.;
                                 ENU=Create or modify the coupling to a Dynamics 365 for Sales account.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Visible=CRMIntegrationEnabled;
                      Image=LinkAccount;
                      PromotedCategory=Category9;
                      OnAction=VAR
                                 CRMIntegrationManagement@1000 : Codeunit 5330;
                               BEGIN
                                 CRMIntegrationManagement.DefineCoupling(RECORDID);
                               END;
                                }
      { 49      ;3   ;Action    ;
                      Name=DeleteCRMCoupling;
                      AccessByPermission=TableData 5331=IM;
                      CaptionML=[DAN=Slet sammenk�dning;
                                 ENU=Delete Coupling];
                      ToolTipML=[DAN=Slet sammenk�dningen med en Dynamics 365 for Sales-konto.;
                                 ENU=Delete the coupling to a Dynamics 365 for Sales account.];
                      ApplicationArea=#Suite;
                      Visible=CRMIntegrationEnabled;
                      Enabled=CRMIsCoupledToRecord;
                      Image=UnLinkAccount;
                      OnAction=VAR
                                 CRMCouplingManagement@1000 : Codeunit 5331;
                               BEGIN
                                 CRMCouplingManagement.RemoveCoupling(RECORDID);
                               END;
                                }
      { 150     ;2   ;Action    ;
                      Name=ShowLog;
                      CaptionML=[DAN=Synkroniseringslog;
                                 ENU=Synchronization Log];
                      ToolTipML=[DAN=Vis integrationssynkroniseringsjobs for debitortabellen.;
                                 ENU=View integration synchronization jobs for the customer table.];
                      ApplicationArea=#Suite;
                      Visible=CRMIntegrationEnabled;
                      Image=Log;
                      OnAction=VAR
                                 CRMIntegrationManagement@1000 : Codeunit 5330;
                               BEGIN
                                 CRMIntegrationManagement.ShowLog(RECORDID);
                               END;
                                }
      { 5       ;1   ;ActionGroup;
                      CaptionML=[DAN=Oversigt;
                                 ENU=History];
                      Image=History }
      { 80      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=Post&er;
                                 ENU=Ledger E&ntries];
                      ToolTipML=[DAN=Se historikken over transaktioner, der er bogf�rt for den valgte record.;
                                 ENU=View the history of transactions that have been posted for the selected record.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 25;
                      RunPageView=SORTING(Customer No.)
                                  ORDER(Descending);
                      RunPageLink=Customer No.=FIELD(No.);
                      Promoted=No;
                      Image=CustomerLedger;
                      PromotedCategory=Process }
      { 76      ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=F� vist statistiske oplysninger om recorden, f.eks. v�rdien af bogf�rte poster.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 151;
                      RunPageLink=No.=FIELD(No.),
                                  Date Filter=FIELD(Date Filter),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
                      Image=Statistics;
                      PromotedCategory=Process }
      { 79      ;2   ;Action    ;
                      CaptionML=[DAN=Forfaldsoversig&t;
                                 ENU=S&ales];
                      ToolTipML=[DAN=Vis en oversigt over debitorposter. Du kan v�lge tidsintervallet i feltet Vis efter. Kolonnen Periodestart til venstre viser datoer efter det valgte tidsinterval.;
                                 ENU=View a summary of customer ledger entries. You select the time interval in the View by field. The Period column on the left contains a series of dates that are determined by the time interval you have selected.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 155;
                      RunPageLink=No.=FIELD(No.),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
                      Image=Sales }
      { 77      ;2   ;Action    ;
                      CaptionML=[DAN=Poststatistik;
                                 ENU=Entry Statistics];
                      ToolTipML=[DAN=Vis poststatistik for den p�g�ldende record.;
                                 ENU=View entry statistics for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 302;
                      RunPageLink=No.=FIELD(No.),
                                  Date Filter=FIELD(Date Filter),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
                      Image=EntryStatistics }
      { 112     ;2   ;Action    ;
                      CaptionML=[DAN=&Valutastatistik;
                                 ENU=Statistics by C&urrencies];
                      ToolTipML=[DAN=Vis statistik for debitorer, der bruger forskellige valutaer.;
                                 ENU=View statistics for customers that use multiple currencies.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 486;
                      RunPageLink=Customer Filter=FIELD(No.),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
                                  Date Filter=FIELD(Date Filter);
                      Image=Currencies }
      { 6500    ;2   ;Action    ;
                      CaptionML=[DAN=&Varesporingsposter;
                                 ENU=Item &Tracking Entries];
                      ToolTipML=[DAN=Vis serie- eller lotnumre, der er tildelt til varer.;
                                 ENU=View serial or lot numbers that are assigned to items.];
                      ApplicationArea=#ItemTracking;
                      Image=ItemTrackingLedger;
                      OnAction=VAR
                                 ItemTrackingDocMgt@1000 : Codeunit 6503;
                               BEGIN
                                 ItemTrackingDocMgt.ShowItemTrackingForMasterData(1,"No.",'','','','','');
                               END;
                                }
      { 140     ;2   ;Separator  }
      { 130     ;1   ;ActionGroup;
                      Name=Prices and Discounts;
                      CaptionML=[DAN=Priser og rabatter;
                                 ENU=Prices and Discounts] }
      { 83      ;2   ;Action    ;
                      CaptionML=[DAN=Fakturara&batter;
                                 ENU=Invoice &Discounts];
                      ToolTipML=[DAN=Angiv forskellige rabatter, som kan tilf�jes fakturaer til debitor. Der gives automatisk en fakturarabat til debitor, n�r det samlede fakturabel�b overstiger et vist bel�b.;
                                 ENU=Set up different discounts that are applied to invoices for the customer. An invoice discount is automatically granted to the customer when the total on a sales invoice exceeds a certain amount.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 23;
                      RunPageLink=Code=FIELD(Invoice Disc. Code);
                      Image=CalculateInvoiceDiscount;
                      PromotedCategory=Category7 }
      { 113     ;2   ;Action    ;
                      CaptionML=[DAN=Priser;
                                 ENU=Prices];
                      ToolTipML=[DAN=Vis eller angiv forskellige priser for de varer, du s�lger til debitoren. En varepris anf�res automatisk p� fakturalinjer, n�r de specificerede kriterier er opfyldt, f.eks. debitor, m�ngde eller slutdato.;
                                 ENU=View or set up different prices for items that you sell to the customer. An item price is automatically granted on invoice lines when the specified criteria are met, such as customer, quantity, or ending date.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 7002;
                      RunPageView=SORTING(Sales Type,Sales Code);
                      RunPageLink=Sales Type=CONST(Customer),
                                  Sales Code=FIELD(No.);
                      Image=Price }
      { 136     ;2   ;Action    ;
                      CaptionML=[DAN=Linjerabat;
                                 ENU=Line Discounts];
                      ToolTipML=[DAN=Vis eller angiv forskellige rabatter for de varer, du s�lger til debitoren. En varerabat anf�res automatisk p� fakturalinjer, n�r de specificerede kriterier er opfyldt, f.eks. debitor, antal eller slutdato.;
                                 ENU=View or set up different discounts for items that you sell to the customer. An item discount is automatically granted on invoice lines when the specified criteria are met, such as customer, quantity, or ending date.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 7004;
                      RunPageView=SORTING(Sales Type,Sales Code);
                      RunPageLink=Sales Type=CONST(Customer),
                                  Sales Code=FIELD(No.);
                      Image=LineDiscount }
      { 82      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Salg;
                                 ENU=S&ales];
                      Image=Sales }
      { 162     ;2   ;Action    ;
                      CaptionML=[DAN=Forudb&etalingsprocenter;
                                 ENU=Prepa&yment Percentages];
                      ToolTipML=[DAN="Vis eller rediger de procentdele af prisen, der kan betales som forudbetaling. ";
                                 ENU="View or edit the percentages of the price that can be paid as a prepayment. "];
                      ApplicationArea=#Prepayments;
                      RunObject=Page 664;
                      RunPageView=SORTING(Sales Type,Sales Code);
                      RunPageLink=Sales Type=CONST(Customer),
                                  Sales Code=FIELD(No.);
                      Image=PrepaymentPercentages }
      { 118     ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Tilbagevendende salgslinjer;
                                 ENU=Recurring Sales Lines];
                      ToolTipML=[DAN=Ops�tning af tilbagevendende salgslinjer for debitor, f.eks. en m�nedlig genbestillingsordre, som hurtigt vil kunne inds�ttes i et debitorsalgsdokument.;
                                 ENU=Set up recurring sales lines for the customer, such as a monthly replenishment order, that can quickly be inserted on a sales document for the customer.];
                      ApplicationArea=#Suite;
                      RunObject=Page 173;
                      RunPageLink=Customer No.=FIELD(No.);
                      PromotedIsBig=Yes;
                      Image=CustomerCode;
                      PromotedCategory=Category5 }
      { 7       ;1   ;ActionGroup;
                      CaptionML=[DAN=Dokumenter;
                                 ENU=Documents];
                      Image=Documents }
      { 85      ;2   ;Action    ;
                      CaptionML=[DAN=Tilbud;
                                 ENU=Quotes];
                      ToolTipML=[DAN=Vis en liste med igangv�rende salgstilbud for debitoren.;
                                 ENU=View a list of ongoing sales quotes for the customer.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 9300;
                      RunPageView=SORTING(Document Type,Sell-to Customer No.);
                      RunPageLink=Sell-to Customer No.=FIELD(No.);
                      Image=Quote }
      { 157     ;2   ;Action    ;
                      CaptionML=[DAN=Fakturaer;
                                 ENU=Invoices];
                      ToolTipML=[DAN=Vis en liste med igangv�rende salgsfakturaer for debitoren.;
                                 ENU=View a list of ongoing sales invoices for the customer.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 9301;
                      RunPageView=SORTING(Document Type,Sell-to Customer No.);
                      RunPageLink=Sell-to Customer No.=FIELD(No.);
                      Image=Invoice }
      { 86      ;2   ;Action    ;
                      CaptionML=[DAN=Ordrer;
                                 ENU=Orders];
                      ToolTipML=[DAN=Vis en liste med igangv�rende salgsordrer for debitoren.;
                                 ENU=View a list of ongoing sales orders for the customer.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 9305;
                      RunPageView=SORTING(Document Type,Sell-to Customer No.);
                      RunPageLink=Sell-to Customer No.=FIELD(No.);
                      Image=Document }
      { 121     ;2   ;Action    ;
                      CaptionML=[DAN=Returvareordrer;
                                 ENU=Return Orders];
                      ToolTipML=[DAN=�bn oversigten over igangv�rende returordrer.;
                                 ENU=Open the list of ongoing return orders.];
                      ApplicationArea=#SalesReturnOrder;
                      RunObject=Page 9304;
                      RunPageView=SORTING(Document Type,Sell-to Customer No.);
                      RunPageLink=Sell-to Customer No.=FIELD(No.);
                      Image=ReturnOrder }
      { 151     ;2   ;ActionGroup;
                      CaptionML=[DAN=Udstedte dokumenter;
                                 ENU=Issued Documents];
                      Image=Documents }
      { 152     ;3   ;Action    ;
                      CaptionML=[DAN=Udstedte ry&kkere;
                                 ENU=Issued &Reminders];
                      ToolTipML=[DAN=Se de p�mindelser, du har sendt til debitoren.;
                                 ENU=View the reminders that you have sent to the customer.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 440;
                      RunPageView=SORTING(Customer No.,Posting Date);
                      RunPageLink=Customer No.=FIELD(No.);
                      Image=OrderReminder }
      { 153     ;3   ;Action    ;
                      CaptionML=[DAN=Udstedte &rentenotaer;
                                 ENU=Issued &Finance Charge Memos];
                      ToolTipML=[DAN=Se de rentenotaer, du har sendt til debitoren.;
                                 ENU=View the finance charge memos that you have sent to the customer.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 452;
                      RunPageView=SORTING(Customer No.,Posting Date);
                      RunPageLink=Customer No.=FIELD(No.);
                      Image=FinChargeMemo }
      { 114     ;2   ;Action    ;
                      CaptionML=[DAN=Rammeordrer;
                                 ENU=Blanket Orders];
                      ToolTipML=[DAN=�bn oversigten over igangv�rende rammeordrer.;
                                 ENU=Open the list of ongoing blanket orders.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9303;
                      RunPageView=SORTING(Document Type,Sell-to Customer No.);
                      RunPageLink=Sell-to Customer No.=FIELD(No.);
                      Image=BlanketOrder }
      { 147     ;2   ;Action    ;
                      CaptionML=[DAN=S&ager;
                                 ENU=&Jobs];
                      ToolTipML=[DAN=�bn listen over igangv�rende sager.;
                                 ENU=Open the list of ongoing jobs.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 89;
                      RunPageView=SORTING(Bill-to Customer No.);
                      RunPageLink=Bill-to Customer No.=FIELD(No.);
                      Image=Job }
      { 13      ;1   ;ActionGroup;
                      CaptionML=[DAN=Service;
                                 ENU=Service];
                      Image=ServiceItem }
      { 128     ;2   ;Action    ;
                      CaptionML=[DAN=Serviceordrer;
                                 ENU=Service Orders];
                      ToolTipML=[DAN=�bn oversigten over igangv�rende serviceordrer.;
                                 ENU=Open the list of ongoing service orders.];
                      ApplicationArea=#Service;
                      RunObject=Page 9318;
                      RunPageView=SORTING(Document Type,Customer No.);
                      RunPageLink=Customer No.=FIELD(No.);
                      Image=Document }
      { 126     ;2   ;Action    ;
                      CaptionML=[DAN=S&ervicekontrakter;
                                 ENU=Ser&vice Contracts];
                      ToolTipML=[DAN=�bn oversigten over igangv�rende servicekontrakter.;
                                 ENU=Open the list of ongoing service contracts.];
                      ApplicationArea=#Service;
                      RunObject=Page 6065;
                      RunPageView=SORTING(Customer No.,Ship-to Code);
                      RunPageLink=Customer No.=FIELD(No.);
                      Image=ServiceAgreement }
      { 127     ;2   ;Action    ;
                      CaptionML=[DAN=Se&rviceartikler;
                                 ENU=Service &Items];
                      ToolTipML=[DAN=Vis eller rediger de serviceartikler, der er registreret for debitoren.;
                                 ENU=View or edit the service items that are registered for the customer.];
                      ApplicationArea=#Service;
                      RunObject=Page 5988;
                      RunPageView=SORTING(Customer No.,Ship-to Code,Item No.,Serial No.);
                      RunPageLink=Customer No.=FIELD(No.);
                      Image=ServiceItem }
      { 9       ;    ;ActionContainer;
                      ActionContainerType=NewDocumentItems }
      { 1902575205;1 ;Action    ;
                      Name=NewBlanketSalesOrder;
                      AccessByPermission=TableData 36=RIM;
                      CaptionML=[DAN=Rammesalgsordre;
                                 ENU=Blanket Sales Order];
                      ToolTipML=[DAN=Opret en rammesalgsordre p� debitoren.;
                                 ENU=Create a blanket sales order for the customer.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 507;
                      RunPageLink=Sell-to Customer No.=FIELD(No.);
                      Promoted=No;
                      Image=BlanketOrder;
                      PromotedCategory=Category4;
                      RunPageMode=Create }
      { 1900246505;1 ;Action    ;
                      Name=NewSalesQuote;
                      AccessByPermission=TableData 36=RIM;
                      CaptionML=[DAN=Salgstilbud;
                                 ENU=Sales Quote];
                      ToolTipML=[DAN=Tilbyd varer eller servicer til en debitor.;
                                 ENU=Offer items or services to a customer.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 41;
                      RunPageLink=Sell-to Customer No.=FIELD(No.);
                      Promoted=Yes;
                      Visible=NOT IsOfficeAddin;
                      Image=NewSalesQuote;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      RunPageMode=Create }
      { 1906384905;1 ;Action    ;
                      Name=NewSalesInvoice;
                      AccessByPermission=TableData 36=RIM;
                      CaptionML=[DAN=Salgsfaktura;
                                 ENU=Sales Invoice];
                      ToolTipML=[DAN=Opret en salgsfaktura p� debitoren.;
                                 ENU=Create a sales invoice for the customer.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 43;
                      RunPageLink=Sell-to Customer No.=FIELD(No.);
                      Promoted=Yes;
                      Visible=NOT IsOfficeAddin;
                      Image=NewSalesInvoice;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      RunPageMode=Create }
      { 1904747105;1 ;Action    ;
                      Name=NewSalesOrder;
                      AccessByPermission=TableData 36=RIM;
                      CaptionML=[DAN=Salgsordre;
                                 ENU=Sales Order];
                      ToolTipML=[DAN=Opret en salgsordre for debitoren.;
                                 ENU=Create a sales order for the customer.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 42;
                      RunPageLink=Sell-to Customer No.=FIELD(No.);
                      Promoted=Yes;
                      Visible=NOT IsOfficeAddin;
                      Image=Document;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      RunPageMode=Create }
      { 1902583505;1 ;Action    ;
                      Name=NewSalesCreditMemo;
                      AccessByPermission=TableData 36=RIM;
                      CaptionML=[DAN=Salgskreditnota;
                                 ENU=Sales Credit Memo];
                      ToolTipML=[DAN=Opret en ny salgskreditnota for at tilbagef�re en bogf�rt salgsfaktura.;
                                 ENU=Create a new sales credit memo to revert a posted sales invoice.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 44;
                      RunPageLink=Sell-to Customer No.=FIELD(No.);
                      Promoted=Yes;
                      Visible=NOT IsOfficeAddin;
                      Image=CreditMemo;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      RunPageMode=Create }
      { 164     ;1   ;Action    ;
                      Name=NewSalesQuoteAddin;
                      AccessByPermission=TableData 36=RIM;
                      CaptionML=[DAN=Salgstilbud;
                                 ENU=Sales Quote];
                      ToolTipML=[DAN=Tilbyd varer eller servicer til en debitor.;
                                 ENU=Offer items or services to a customer.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=IsOfficeAddin;
                      Image=NewSalesQuote;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 CreateAndShowNewQuote;
                               END;
                                }
      { 159     ;1   ;Action    ;
                      Name=NewSalesInvoiceAddin;
                      AccessByPermission=TableData 36=RIM;
                      CaptionML=[DAN=Salgsfaktura;
                                 ENU=Sales Invoice];
                      ToolTipML=[DAN=Opret en salgsfaktura til debitoren.;
                                 ENU=Create a sales invoice for the customer.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=IsOfficeAddin;
                      Image=NewSalesInvoice;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 CreateAndShowNewInvoice;
                               END;
                                }
      { 155     ;1   ;Action    ;
                      Name=NewSalesOrderAddin;
                      AccessByPermission=TableData 36=RIM;
                      CaptionML=[DAN=Salgsordre;
                                 ENU=Sales Order];
                      ToolTipML=[DAN=Opret en salgsordre for debitoren.;
                                 ENU=Create a sales order for the customer.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=IsOfficeAddin;
                      Image=Document;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 CreateAndShowNewOrder;
                               END;
                                }
      { 137     ;1   ;Action    ;
                      Name=NewSalesCreditMemoAddin;
                      AccessByPermission=TableData 36=RIM;
                      CaptionML=[DAN=Salgskreditnota;
                                 ENU=Sales Credit Memo];
                      ToolTipML=[DAN=Opret en ny salgskreditnota for at tilbagef�re en bogf�rt salgsfaktura.;
                                 ENU=Create a new sales credit memo to revert a posted sales invoice.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=IsOfficeAddin;
                      Image=CreditMemo;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 CreateAndShowNewCreditMemo;
                               END;
                                }
      { 1905163705;1 ;Action    ;
                      Name=NewSalesReturnOrder;
                      AccessByPermission=TableData 36=RIM;
                      CaptionML=[DAN=Salgsreturvareordre;
                                 ENU=Sales Return Order];
                      ToolTipML=[DAN=Opret en ny salgsreturordre for varer eller servicer.;
                                 ENU=Create a new sales return order for items or services.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 6630;
                      RunPageLink=Sell-to Customer No.=FIELD(No.);
                      Promoted=No;
                      Image=ReturnOrder;
                      PromotedCategory=Category4;
                      RunPageMode=Create }
      { 1905185205;1 ;Action    ;
                      Name=NewServiceQuote;
                      AccessByPermission=TableData 5900=RIM;
                      CaptionML=[DAN=Servicetilbud;
                                 ENU=Service Quote];
                      ToolTipML=[DAN=Opret et nyt servicetilbud for debitoren.;
                                 ENU=Create a new service quote for the customer.];
                      ApplicationArea=#Service;
                      RunObject=Page 5964;
                      RunPageLink=Customer No.=FIELD(No.);
                      Promoted=No;
                      Image=Quote;
                      PromotedCategory=Category4;
                      RunPageMode=Create }
      { 1902079405;1 ;Action    ;
                      Name=NewServiceInvoice;
                      AccessByPermission=TableData 5900=RIM;
                      CaptionML=[DAN=Servicefaktura;
                                 ENU=Service Invoice];
                      ToolTipML=[DAN=Opret en ny servicefaktura for debitoren.;
                                 ENU=Create a new service invoice for the customer.];
                      ApplicationArea=#Service;
                      RunObject=Page 5933;
                      RunPageLink=Customer No.=FIELD(No.);
                      Promoted=No;
                      Image=Invoice;
                      PromotedCategory=Category4;
                      RunPageMode=Create }
      { 1907102005;1 ;Action    ;
                      Name=NewServiceOrder;
                      AccessByPermission=TableData 5900=RIM;
                      CaptionML=[DAN=Serviceordre;
                                 ENU=Service Order];
                      ToolTipML=[DAN=Opret en ny serviceordre for debitoren.;
                                 ENU=Create a new service order for the customer.];
                      ApplicationArea=#Service;
                      RunObject=Page 5900;
                      RunPageLink=Customer No.=FIELD(No.);
                      Promoted=No;
                      Image=Document;
                      PromotedCategory=Category4;
                      RunPageMode=Create }
      { 1901662105;1 ;Action    ;
                      Name=NewServiceCreditMemo;
                      AccessByPermission=TableData 5900=RIM;
                      CaptionML=[DAN=Servicekreditnota;
                                 ENU=Service Credit Memo];
                      ToolTipML=[DAN=Opret en ny servicekreditnota for debitoren.;
                                 ENU=Create a new service credit memo for the customer.];
                      ApplicationArea=#Service;
                      RunObject=Page 5935;
                      RunPageLink=Customer No.=FIELD(No.);
                      Promoted=No;
                      Image=CreditMemo;
                      PromotedCategory=Category4;
                      RunPageMode=Create }
      { 1903839805;1 ;Action    ;
                      Name=NewReminder;
                      AccessByPermission=TableData 295=RIM;
                      CaptionML=[DAN=Rykkermeddelelse;
                                 ENU=Reminder];
                      ToolTipML=[DAN=Opret en ny rykker til debitoren.;
                                 ENU=Create a new reminder for the customer.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 434;
                      RunPageLink=Customer No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Reminder;
                      PromotedCategory=Category4;
                      RunPageMode=Create }
      { 1901102005;1 ;Action    ;
                      Name=NewFinanceChargeMemo;
                      AccessByPermission=TableData 302=RIM;
                      CaptionML=[DAN=Rentenota;
                                 ENU=Finance Charge Memo];
                      ToolTipML=[DAN=Opret en ny rentenota.;
                                 ENU=Create a new finance charge memo.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 446;
                      RunPageLink=Customer No.=FIELD(No.);
                      Promoted=No;
                      Image=FinChargeMemo;
                      PromotedCategory=Category4;
                      RunPageMode=Create }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 57      ;1   ;ActionGroup;
                      CaptionML=[DAN=Godkendelse;
                                 ENU=Approval];
                      Visible=OpenApprovalEntriesExistCurrUser }
      { 56      ;2   ;Action    ;
                      Name=Approve;
                      CaptionML=[DAN=Godkend;
                                 ENU=Approve];
                      ToolTipML=[DAN=Godkend de anmodede �ndringer.;
                                 ENU=Approve the requested changes.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Visible=OpenApprovalEntriesExistCurrUser;
                      PromotedIsBig=Yes;
                      Image=Approve;
                      PromotedCategory=Category5;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.ApproveRecordApprovalRequest(RECORDID);
                               END;
                                }
      { 390     ;2   ;Action    ;
                      Name=Reject;
                      CaptionML=[DAN=Afvis;
                                 ENU=Reject];
                      ToolTipML=[DAN=Afvis godkendelsesanmodningen.;
                                 ENU=Reject the approval request.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Visible=OpenApprovalEntriesExistCurrUser;
                      PromotedIsBig=Yes;
                      Image=Reject;
                      PromotedCategory=Category5;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.RejectRecordApprovalRequest(RECORDID);
                               END;
                                }
      { 41      ;2   ;Action    ;
                      Name=Delegate;
                      CaptionML=[DAN=Uddeleger;
                                 ENU=Delegate];
                      ToolTipML=[DAN=Uddeleger godkendelsen til en stedfortr�dende godkender.;
                                 ENU=Delegate the approval to a substitute approver.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Visible=OpenApprovalEntriesExistCurrUser;
                      Image=Delegate;
                      PromotedCategory=Category5;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.DelegateRecordApprovalRequest(RECORDID);
                               END;
                                }
      { 148     ;2   ;Action    ;
                      Name=Comment;
                      CaptionML=[DAN=Bem�rkninger;
                                 ENU=Comments];
                      ToolTipML=[DAN=Se eller tilf�j bem�rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Visible=OpenApprovalEntriesExistCurrUser;
                      Image=ViewComments;
                      PromotedCategory=Category5;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.GetApprovalComment(Rec);
                               END;
                                }
      { 45      ;1   ;ActionGroup;
                      CaptionML=[DAN=Anmod om godkendelse;
                                 ENU=Request Approval];
                      Image=SendApprovalRequest }
      { 55      ;2   ;Action    ;
                      Name=SendApprovalRequest;
                      CaptionML=[DAN=Send go&dkendelsesanmodning;
                                 ENU=Send A&pproval Request];
                      ToolTipML=[DAN=Anmod om tilladelse til at �ndre recorden.;
                                 ENU=Request approval to change the record.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=(NOT OpenApprovalEntriesExist) AND EnabledApprovalWorkflowsExist AND CanRequestApprovalForFlow;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category6;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ApprovalsMgmt@1001 : Codeunit 1535;
                               BEGIN
                                 IF ApprovalsMgmt.CheckCustomerApprovalsWorkflowEnabled(Rec) THEN
                                   ApprovalsMgmt.OnSendCustomerForApproval(Rec);
                               END;
                                }
      { 37      ;2   ;Action    ;
                      Name=CancelApprovalRequest;
                      CaptionML=[DAN=Annuller godkendelsesan&modning;
                                 ENU=Cancel Approval Re&quest];
                      ToolTipML=[DAN=Annuller godkendelsesanmodningen.;
                                 ENU=Cancel the approval request.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=CanCancelApprovalForRecord OR CanCancelApprovalForFlow;
                      Image=CancelApprovalRequest;
                      PromotedCategory=Category6;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ApprovalsMgmt@1001 : Codeunit 1535;
                                 WorkflowWebhookManagement@1000 : Codeunit 1543;
                               BEGIN
                                 ApprovalsMgmt.OnCancelCustomerApprovalRequest(Rec);
                                 WorkflowWebhookManagement.FindAndCancel(RECORDID);
                               END;
                                }
      { 161     ;2   ;ActionGroup;
                      Name=Flow;
                      CaptionML=[DAN=Flow;
                                 ENU=Flow] }
      { 168     ;3   ;Action    ;
                      Name=CreateFlow;
                      CaptionML=[DAN=Opret et workflow;
                                 ENU=Create a Flow];
                      ToolTipML=[DAN=Opret et nyt workflow fra en liste over relevante workflowskabeloner.;
                                 ENU=Create a new Flow from a list of relevant Flow templates.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=IsSaaS;
                      Image=Flow;
                      PromotedCategory=Category6;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 FlowServiceManagement@1001 : Codeunit 6400;
                                 FlowTemplateSelector@1000 : Page 6400;
                               BEGIN
                                 // Opens page 6400 where the user can use filtered templates to create new flows.
                                 FlowTemplateSelector.SetSearchText(FlowServiceManagement.GetCustomerTemplateFilter);
                                 FlowTemplateSelector.RUN;
                               END;
                                }
      { 166     ;3   ;Action    ;
                      Name=SeeFlows;
                      CaptionML=[DAN=Se mine workflows;
                                 ENU=See my Flows];
                      ToolTipML=[DAN=F� vist og konfigurer de workflowforekomster, du har oprettet.;
                                 ENU=View and configure Flows that you created.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 6401;
                      Promoted=Yes;
                      Image=Flow;
                      PromotedCategory=Category6;
                      PromotedOnly=Yes }
      { 142     ;1   ;ActionGroup;
                      CaptionML=[DAN=Workflow;
                                 ENU=Workflow] }
      { 17      ;2   ;Action    ;
                      Name=CreateApprovalWorkflow;
                      CaptionML=[DAN=Opret godkendelsesworkflow;
                                 ENU=Create Approval Workflow];
                      ToolTipML=[DAN=Opret et godkendelsesworkflow for oprettelse og �ndring af debitorer ved at gennemg� et par sider med instruktioner.;
                                 ENU=Set up an approval workflow for creating or changing customers, by going through a few pages that will guide you.];
                      ApplicationArea=#Advanced;
                      Enabled=NOT EnabledApprovalWorkflowsExist;
                      Image=CreateWorkflow;
                      OnAction=BEGIN
                                 PAGE.RUNMODAL(PAGE::"Cust. Approval WF Setup Wizard");
                               END;
                                }
      { 138     ;2   ;Action    ;
                      Name=ManageApprovalWorkflows;
                      CaptionML=[DAN=Administrer godkendelsesworkflows;
                                 ENU=Manage Approval Workflows];
                      ToolTipML=[DAN=Se eller rediger eksisterende godkendelsesworkflows for oprettelse og �ndring af debitorer.;
                                 ENU=View or edit existing approval workflows for creating or changing customers.];
                      ApplicationArea=#Advanced;
                      Enabled=EnabledApprovalWorkflowsExist;
                      Image=WorkflowSetup;
                      OnAction=VAR
                                 WorkflowManagement@1000 : Codeunit 1501;
                               BEGIN
                                 WorkflowManagement.NavigateToWorkflows(DATABASE::Customer,EventFilter);
                               END;
                                }
      { 163     ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 139     ;2   ;Action    ;
                      Name=Templates;
                      CaptionML=[DAN=Skabeloner;
                                 ENU=Templates];
                      ToolTipML=[DAN=F� vist eller rediger debitorskabeloner.;
                                 ENU=View or edit customer templates.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 1340;
                      RunPageLink=Table ID=CONST(18);
                      PromotedIsBig=Yes;
                      Image=Template }
      { 167     ;2   ;Action    ;
                      Name=ApplyTemplate;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Anvend skabelon;
                                 ENU=Apply Template];
                      ToolTipML=[DAN=Anvend en skabelon for at opdatere enheden med dine standardindstillinger for en bestemt enhedstype.;
                                 ENU=Apply a template to update the entity with your standard settings for a certain type of entity.];
                      ApplicationArea=#Basic,#Suite;
                      Image=ApplyTemplate;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 MiniCustomerTemplate@1002 : Record 1300;
                               BEGIN
                                 MiniCustomerTemplate.UpdateCustomerFromTemplate(Rec);
                               END;
                                }
      { 132     ;2   ;Action    ;
                      Name=SaveAsTemplate;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Gem som skabelon;
                                 ENU=Save as Template];
                      ToolTipML=[DAN=Gem debitorkortet som en skabelon, der kan genbruges ved oprettelse af nye debitorkort. Debitorskabeloner indeholder forudindstillede oplysninger som en hj�lp til udfyldelse af debitorkortene.;
                                 ENU=Save the customer card as a template that can be reused to create new customer cards. Customer templates contain preset information to help you fill fields on customer cards.];
                      ApplicationArea=#Basic,#Suite;
                      PromotedIsBig=Yes;
                      Image=Save;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 TempMiniCustomerTemplate@1000 : TEMPORARY Record 1300;
                               BEGIN
                                 TempMiniCustomerTemplate.SaveAsTemplate(Rec);
                               END;
                                }
      { 1900839804;1 ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Bogf�r indbetalingskladder;
                                 ENU=Post Cash Receipts];
                      ToolTipML=[DAN=Opret en indbetalingskladdelinje for debitoren, eksempelvis for at bogf�re en betalingskvittering.;
                                 ENU=Create a cash receipt journal line for the customer, for example, to post a payment receipt.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 255;
                      Image=CashReceiptJournal;
                      PromotedCategory=Process }
      { 1905171704;1 ;Action    ;
                      CaptionML=[DAN=Salgskladde;
                                 ENU=Sales Journal];
                      ToolTipML=[DAN=Bogf�r alle salgstransaktioner for debitoren.;
                                 ENU=Post any sales transaction for the customer.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 253;
                      Image=Journals;
                      PromotedCategory=Process }
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 1906813206;1 ;Action    ;
                      Name=Report Customer Detailed Aging;
                      CaptionML=[DAN=Forfaldne debitorposter;
                                 ENU=Customer Detailed Aging];
                      ToolTipML=[DAN=Vis en detaljeret liste over hver debitors samlede forfaldne betalinger, opdelt i tre tidsperioder. Rapporten kan bruges til at bestemme, hvorn�r der skal udstedes rykkere, til at vurdere en debitors kreditv�rdighed eller til at udarbejde likviditetsanalyser.;
                                 ENU=View a detailed list of each customer's total payments due, divided into three time periods. The report can be used to decide when to issue reminders, to evaluate a customer's creditworthiness, or to prepare liquidity analyses.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 RunReport(REPORT::"Customer Detailed Aging","No.");
                               END;
                                }
      { 1907586706;1 ;Action    ;
                      Name=Report Customer - Labels;
                      CaptionML=[DAN=Debitor - etiketter;
                                 ENU=Customer - Labels];
                      ToolTipML=[DAN=Vis adresseetiketter med navn og adresse p� debitorer.;
                                 ENU=View mailing labels with the customers' names and addresses.];
                      ApplicationArea=#Advanced;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Category9;
                      OnAction=BEGIN
                                 RunReport(REPORT::"Customer - Labels","No.");
                               END;
                                }
      { 1902299006;1 ;Action    ;
                      Name=Report Customer - Balance to Date;
                      CaptionML=[DAN=Debitor - saldo til dato;
                                 ENU=Customer - Balance to Date];
                      ToolTipML=[DAN=Vis en liste over debitorers betalingshistorik op til en bestemt dato. Du kan bruge rapporten til at udtr�kke oplysninger om din samlede salgsindkomst ved slutningen af en regnskabsperiode eller et regnskabs�r.;
                                 ENU=View a list with customers' payment history up until a certain date. You can use the report to extract your total sales income at the close of an accounting period or fiscal year.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Report;
                      PromotedCategory=Category9;
                      OnAction=BEGIN
                                 RunReport(REPORT::"Customer - Balance to Date","No.");
                               END;
                                }
      { 133     ;1   ;Action    ;
                      Name=Report Statement;
                      CaptionML=[DAN=Kontoudtog;
                                 ENU=Statement];
                      ToolTipML=[DAN=Vis en liste over debitors transaktioner i en bestemt periode, f.eks. for at sende udskriften til debitor i slutningen af en regnskabsperiode. Du kan v�lge at f� vist samtlige forfaldne saldi, uafh�ngigt af den angivne periode, eller du kan v�lge at inkludere et aldersfordelingsinterval.;
                                 ENU=View a list of a customer's transactions for a selected period, for example, to send to the customer at the close of an accounting period. You can choose to have all overdue balances displayed regardless of the period specified, or you can choose to include an aging band.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 8810;
                      Image=Report }
    }
  }
  CONTROLS
  {
    { 1900000001;;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitorens nummer. Feltet udfyldes enten automatisk fra en defineret nummerserie, eller du kan indtaste nummeret manuelt, fordi du har aktiveret manuel nummerindtastning i ops�tningen af nummerserier.;
                           ENU=Specifies the number of the customer. The field is either filled automatically from a defined number series, or you enter the number manually because you have enabled manual number entry in the number-series setup.];
                ApplicationArea=#All;
                SourceExpr="No.";
                Importance=Additional;
                Visible=NoFieldVisible;
                OnAssistEdit=BEGIN
                               IF AssistEdit(xRec) THEN
                                 CurrPage.UPDATE;
                             END;
                              }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitorens navn. Navnet vises p� alle debitorens salgsbilag. Du kan bruge op til 50 tegn (b�de tal og bogstaver).;
                           ENU=Specifies the customer's name. This name will appear on all sales documents for the customer. You can enter a maximum of 50 characters, both numbers and letters.];
                ApplicationArea=#All;
                SourceExpr=Name;
                Importance=Promoted;
                ShowMandatory=TRUE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et alternativt navn, du kan bruge til at s�ge efter en debitor.;
                           ENU=Specifies an alternate name that you can use to search for a customer.];
                ApplicationArea=#Advanced;
                SourceExpr="Search Name";
                Importance=Additional;
                Visible=FALSE }

    { 154 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitorens koncerninterne partnerkode.;
                           ENU=Specifies the customer's intercompany partner code.];
                ApplicationArea=#Intercompany;
                SourceExpr="IC Partner Code";
                Importance=Additional }

    { 20  ;2   ;Field     ;
                Name=Balance (LCY);
                ToolTipML=[DAN=Angiver det betalingsbel�b, som debitoren skylder for afsluttede salg. V�rdien kaldes ogs� debitorsaldo.;
                           ENU=Specifies the payment amount that the customer owes for completed sales. This value is also known as the customer's balance.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Balance (LCY)";
                OnDrillDown=BEGIN
                              OpenCustomerLedgerEntries(FALSE);
                            END;
                             }

    { 144 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver betalinger fra debitoren, der er forfaldne pr. dags dato.;
                           ENU=Specifies payments from the customer that are overdue per today's date.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Balance Due (LCY)";
                OnDrillDown=BEGIN
                              OpenCustomerLedgerEntries(TRUE);
                            END;
                             }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det maksimale bel�b, som du tillader, at debitoren overskrider betalingssaldoen med, f�r der udstedes advarsler.;
                           ENU=Specifies the maximum amount you allow the customer to exceed the payment balance before warnings are issued.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Credit Limit (LCY)";
                StyleExpr=StyleTxt;
                OnValidate=BEGIN
                             StyleTxt := SetStyle;
                           END;
                            }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilke transaktioner med debitoren der ikke kan blokeres, f.eks. fordi debitoren er insolvent.;
                           ENU=Specifies which transactions with the customer that cannot be blocked, for example, because the customer is insolvent.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Blocked }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for den s�lger, der normalt h�ndterer denne debitorkonto.;
                           ENU=Specifies a code for the salesperson who normally handles this customer's account.];
                ApplicationArea=#Suite;
                SourceExpr="Salesperson Code";
                Importance=Additional }

    { 64  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for det ansvarscenter, der som standard skal administrere denne debitor.;
                           ENU=Specifies the code for the responsibility center that will administer this customer by default.];
                ApplicationArea=#Advanced;
                SourceExpr="Responsibility Center";
                Importance=Additional }

    { 93  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den servicezone, der er tildelt debitoren.;
                           ENU=Specifies the code for the service zone that is assigned to the customer.];
                ApplicationArea=#Service;
                SourceExpr="Service Zone Code";
                Importance=Additional }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den foretrukne metode til afsendelse af dokumenter til denne debitor, s� du ikke beh�ver at v�lge en afsendelsesindstilling, hver gang du bogf�rer og sender et dokument til debitoren. Salgsdokumenter til denne debitor skal sendes med den angivne afsendelsesprofil og tilsides�tter standarddokumentafsendelsesprofilen.;
                           ENU=Specifies the preferred method of sending documents to this customer, so that you do not have to select a sending option every time that you post and send a document to the customer. Sales documents to this customer will be sent using the specified sending profile and will override the default document sending profile.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Sending Profile";
                Importance=Additional }

    { 73  ;2   ;Field     ;
                Name=TotalSales2;
                CaptionML=[DAN=Salg i alt;
                           ENU=Total Sales];
                ToolTipML=[DAN=Angiver den samlede salgsoms�tning med debitoren i det aktuelle regnskabs�r. Den beregnes ud fra bel�bene, ekskl. moms, p� alle afsluttede og �bne fakturaer og kreditnotaer.;
                           ENU=Specifies your total sales turnover with the customer in the current fiscal year. It is calculated from amounts excluding VAT on all completed and open invoices and credit memos.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=GetTotalSales;
                Style=Strong;
                StyleExpr=TRUE }

    { 72  ;2   ;Field     ;
                CaptionML=[DAN=Kostpriser (RV);
                           ENU=Costs (LCY)];
                ToolTipML=[DAN=Angiver, hvor meget kostpris der er p�l�bet fra debitoren i det aktuelle regnskabs�r.;
                           ENU=Specifies how much cost you have incurred from the customer in the current fiscal year.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=CustSalesLCY - CustProfit - AdjmtCostLCY;
                AutoFormatType=1 }

    { 71  ;2   ;Field     ;
                CaptionML=[DAN=Avancebel�b (RV);
                           ENU=Profit (LCY)];
                ToolTipML=[DAN=Angiver, hvor meget profit du har f�et fra debitoren i det aktuelle regnskabs�r.;
                           ENU=Specifies how much profit you have made from the customer in the current fiscal year.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=AdjCustProfit;
                AutoFormatType=1;
                Importance=Additional;
                Editable=False }

    { 69  ;2   ;Field     ;
                CaptionML=[DAN=Avancepct.;
                           ENU=Profit %];
                ToolTipML=[DAN=Angiver, hvor meget avance du har skabt p� debitoren i det aktuelle regnskabs�r, udtrykt som en procentdel af debitorens samlede salg.;
                           ENU=Specifies how much profit you have made from the customer in the current fiscal year, expressed as a percentage of the customer's total sales.];
                ApplicationArea=#Basic,#Suite;
                DecimalPlaces=1:1;
                SourceExpr=AdjProfitPct;
                Importance=Additional;
                Editable=False }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn�r debitorkortet sidst blev �ndret.;
                           ENU=Specifies when the customer card was last modified.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Last Date Modified";
                Importance=Additional }

    { 1902768601;1;Group  ;
                CaptionML=[DAN=Adresse og kontakt;
                           ENU=Address & Contact];
                GroupType=Group }

    { 63  ;2   ;Group     ;
                Name=AddressDetails;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                GroupType=Group }

    { 6   ;3   ;Field     ;
                Name=Address;
                ToolTipML=[DAN=Angiver debitorens adresse. Denne adresse vises p� alle salgsdokumenter for debitoren.;
                           ENU=Specifies the customer's address. This address will appear on all sales documents for the customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Address }

    { 8   ;3   ;Field     ;
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Address 2" }

    { 90  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver postnummer.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Post Code";
                Importance=Promoted }

    { 10  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver debitorens by.;
                           ENU=Specifies the customer's city.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=City }

    { 91  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver adressens land/omr�de.;
                           ENU=Specifies the country/region of the address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Country/Region Code" }

    { 125 ;3   ;Field     ;
                Name=ShowMap;
                ToolTipML=[DAN=Angiver debitorens adresse p� dit foretrukne kortwebsted.;
                           ENU=Specifies the customer's address on your preferred map website.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ShowMapLbl;
                Editable=FALSE;
                Style=StrongAccent;
                StyleExpr=TRUE;
                OnDrillDown=BEGIN
                              CurrPage.UPDATE(TRUE);
                              DisplayMap;
                            END;

                ShowCaption=No }

    { 65  ;2   ;Group     ;
                Name=ContactDetails;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                GroupType=Group }

    { 122 ;3   ;Field     ;
                CaptionML=[DAN=Prim�r kontaktkode;
                           ENU=Primary Contact Code];
                ToolTipML=[DAN=Angiver det prim�re kontaktnummer for debitoren.;
                           ENU=Specifies the primary contact number for the customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Primary Contact No." }

    { 16  ;3   ;Field     ;
                Name=ContactName;
                CaptionML=[DAN=Kontaktnavn;
                           ENU=Contact Name];
                ToolTipML=[DAN=Angiver navnet p� en fast kontakt hos debitoren.;
                           ENU=Specifies the name of the person you regularly contact when you do business with this customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Contact;
                Importance=Promoted;
                Editable=ContactEditable;
                OnValidate=BEGIN
                             ContactOnAfterValidate;
                           END;
                            }

    { 12  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver debitorens telefonnummer.;
                           ENU=Specifies the customer's telephone number.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Phone No." }

    { 107 ;3   ;Field     ;
                ExtendedDatatype=E-Mail;
                ToolTipML=[DAN=Angiver debitorens mailadresse.;
                           ENU=Specifies the customer's email address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="E-Mail";
                Importance=Promoted }

    { 104 ;3   ;Field     ;
                ToolTipML=[DAN=Angiver debitorens faxnummer.;
                           ENU=Specifies the customer's fax number.];
                ApplicationArea=#Advanced;
                SourceExpr="Fax No.";
                Importance=Additional }

    { 109 ;3   ;Field     ;
                ToolTipML=[DAN=Angiver debitorens internetadresse.;
                           ENU=Specifies the customer's home page address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Home Page" }

    { 66  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver det sprog, der skal anvendes p� udskrifter til denne debitor.;
                           ENU=Specifies the language to be used on printouts for this customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Language Code";
                Importance=Additional }

    { 1905885101;1;Group  ;
                CaptionML=[DAN=Fakturering;
                           ENU=Invoicing] }

    { 34  ;2   ;Field     ;
                CaptionML=[DAN=Faktureres til debitor;
                           ENU=Bill-to Customer];
                ToolTipML=[DAN=Angiver en anden debitor, der skal faktureres for produkter, du s�lger til debitoren, i feltet Navn p� debitorkortet.;
                           ENU=Specifies a different customer who will be invoiced for products that you sell to the customer in the Name field on the customer card.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bill-to Customer No.";
                Importance=Additional }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitorens CVR-nummer for debitorer i EU-lande/-omr�der.;
                           ENU=Specifies the customer's VAT registration number for customers in EU countries/regions.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Registration No.";
                OnDrillDown=VAR
                              VATRegistrationLogMgt@1000 : Codeunit 249;
                            BEGIN
                              VATRegistrationLogMgt.AssistEditCustomerVATReg(Rec);
                            END;
                             }

    { 61  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitoren i forbindelse med afsendelse af elektroniske dokumenter.;
                           ENU=Specifies the customer in connection with electronic document sending.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=GLN;
                Importance=Additional;
                ShowMandatory=GLNNoMandatory }

    { 156 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den debitoradresse, der inds�ttes p� salgstilbud, du opretter for debitoren.;
                           ENU=Specifies which customer address is inserted on sales quotes that you create for the customer.];
                ApplicationArea=#Advanced;
                SourceExpr="Copy Sell-to Addr. to Qte From" }

    { 1060002;2;Field     ;
                ToolTipML=[DAN=Angiver kontokoden for debitoren.;
                           ENU=Specifies the account code for the customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Account Code" }

    { 1060001;2;Field     ;
                ToolTipML=[DAN=Angiver den profil, som debitoren kr�ver til elektroniske dokumenter.;
                           ENU=Specifies the profile that this customer requires for electronic documents.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="OIOUBL Profile Code";
                OnValidate=BEGIN
                             GLNNoMandatory := "OIOUBL Profile Code" <> ''
                           END;
                            }

    { 1060003;2;Field     ;
                ToolTipML=[DAN=Angiver, om debitoren kr�ver en profilkode til elektroniske dokumenter.;
                           ENU=Specifies if this customer requires a profile code for electronic documents.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="OIOUBL Profile Code Required" }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange kopier af en faktura til debitoren, der skal udskrives ad gangen.;
                           ENU=Specifies how many copies of an invoice for the customer will be printed at a time.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Invoice Copies";
                Importance=Additional }

    { 170 ;2   ;Group     ;
                Name=PostingDetails;
                CaptionML=[DAN=Bogf�ringsoplysninger;
                           ENU=Posting Details];
                GroupType=Group }

    { 70  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver debitorens handelstype for at knytte transaktioner, der er foretaget for denne debitor, til den relevante finanskonto i overensstemmelse med den generelle bogf�ringsops�tning.;
                           ENU=Specifies the customer's trade type to link transactions made for this customer with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Gen. Bus. Posting Group";
                Importance=Promoted;
                ShowMandatory=TRUE }

    { 58  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver debitorens momsspecifikation, hvortil der skal knyttes transaktioner for denne debitor.;
                           ENU=Specifies the customer's VAT specification to link transactions made for this customer to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Bus. Posting Group";
                Importance=Additional }

    { 38  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver debitorens markedstype, hvortil der skal knyttes forretningstransaktioner.;
                           ENU=Specifies the customer's market type to link business transactions to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Customer Posting Group";
                Importance=Promoted;
                ShowMandatory=TRUE }

    { 68  ;2   ;Group     ;
                Name=PricesandDiscounts;
                CaptionML=[DAN=Priser og rabatter;
                           ENU=Prices and Discounts];
                GroupType=Group }

    { 67  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver standardvalutakoden for debitoren.;
                           ENU=Specifies the default currency for the customer.];
                ApplicationArea=#Suite;
                SourceExpr="Currency Code";
                Importance=Additional }

    { 40  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver den debitorprisgruppekode, du kan bruge til at oprette salgspriser i vinduet Salgspriser.;
                           ENU=Specifies the customer price group code, which you can use to set up special sales prices in the Sales Prices window.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Customer Price Group";
                Importance=Promoted }

    { 44  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver den debitorrabatgruppekode, du kan bruge som kriterie for at oprette specialrabatter i vinduet Salgslinjerabatter.;
                           ENU=Specifies the customer discount group code, which you can use as a criterion to set up special discounts in the Sales Line Discounts window.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Customer Disc. Group";
                Importance=Promoted }

    { 46  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver, om der beregnes salgslinjerabat, n�r en s�rlig salgspris tilbydes i overensstemmelse med ops�tningen i vinduet Salgspriser.;
                           ENU=Specifies if a sales line discount is calculated when a special sales price is offered according to setup in the Sales Prices window.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Allow Line Disc.";
                Importance=Additional }

    { 42  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for de fakturarabatbetingelser, du har defineret for debitoren.;
                           ENU=Specifies a code for the invoice discount terms that you have defined for the customer.];
                ApplicationArea=#Basic,#Suite;
                NotBlank=Yes;
                SourceExpr="Invoice Disc. Code";
                Importance=Additional }

    { 129 ;3   ;Field     ;
                ToolTipML=[DAN=Angiver, om felterne Enhedspris og Linjebel�b p� bilagslinjer skal vises med eller uden moms.;
                           ENU=Specifies if the Unit Price and Line Amount fields on document lines should be shown with or without VAT.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Prices Including VAT";
                Importance=Additional }

    { 1901677601;1;Group  ;
                CaptionML=[DAN=Betalinger;
                           ENU=Payments] }

    { 160 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en forudbetalingsprocent, der g�lder for alle ordrer fra denne debitor, uanset hvilke varer eller tjenester der er angivet p� ordrelinjerne.;
                           ENU=Specifies a prepayment percentage that applies to all orders for this customer, regardless of the items or services on the order lines.];
                ApplicationArea=#Prepayments;
                SourceExpr="Prepayment %";
                Importance=Additional }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan du kan udligne betalinger p� poster for denne debitor.;
                           ENU=Specifies how to apply payments to entries for this customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Application Method";
                Importance=Additional }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver i forbindelse med Direct Debit-opkr�vninger, om den debitor, som betalingen opkr�ves hos, er en person eller en virksomhed.;
                           ENU=Specifies for direct debit collections if the customer that the payment is collected from is a person or a company.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Partner Type";
                Importance=Additional }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode, der angiver, hvilke betalingsbetingelser du kr�ver, at debitoren overholder.;
                           ENU=Specifies a code that indicates the payment terms that you require of the customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Terms Code";
                Importance=Promoted;
                ShowMandatory=TRUE }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan debitoren normalt sender betaling, f.eks. via bankoverf�rsel eller check.;
                           ENU=Specifies how the customer usually submits payment, such as bank transfer or check.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Method Code";
                Importance=Additional }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan rykkere om forfaldne betalinger h�ndteres for denne debitor.;
                           ENU=Specifies how reminders about late payments are handled for this customer.];
                ApplicationArea=#Advanced;
                SourceExpr="Reminder Terms Code";
                Importance=Additional }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver de renter, der beregnes for debitoren.;
                           ENU=Specifies finance charges are calculated for the customer.];
                ApplicationArea=#Advanced;
                SourceExpr="Fin. Charge Terms Code";
                Importance=Additional }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en betalingsbetingelse, der skal bruges til at beregne pengestr�m for debitoren.;
                           ENU=Specifies a payment term that will be used to calculate cash flow for the customer.];
                ApplicationArea=#Advanced;
                SourceExpr="Cash Flow Payment Terms Code";
                Importance=Additional }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om denne debitor skal medtages ved udskrivning af kontoudtog.;
                           ENU=Specifies whether to include this customer when you print the Statement report.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Print Statements";
                Importance=Additional }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� det sidste kontoudtog, der blev udskrevet for denne debitor.;
                           ENU=Specifies the number of the last statement that was printed for this customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Last Statement No.";
                Importance=Additional }

    { 143 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at der ikke m� ydes betalingstolerance til debitoren.;
                           ENU=Specifies that the customer is not allowed a payment tolerance.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Block Payment Tolerance";
                Importance=Additional }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den debitorbankkonto, der skal bruges som standard, n�r du behandler refusioner til debitoren og Direct Debit-opkr�vninger.;
                           ENU=Specifies the customer's bank account that will be used by default when you process refunds to the customer and direct debit collections.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Preferred Bank Account Code";
                Importance=Additional }

    { 1906801201;1;Group  ;
                CaptionML=[DAN=Levering;
                           ENU=Shipping] }

    { 95  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, fra hvilken lokation salg til debitoren som standard skal behandles.;
                           ENU=Specifies from which location sales to this customer will be processed by default.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Importance=Promoted }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om flere ordrer, der er leveret til debitoren, kan fremg� af samme salgsfaktura.;
                           ENU=Specifies if several orders delivered to the customer can appear on the same sales invoice.];
                ApplicationArea=#Advanced;
                SourceExpr="Combine Shipments" }

    { 158 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om varer aldrig, automatisk (altid) eller eventuelt kan reserveres til denne debitor.;
                           ENU=Specifies whether items will never, automatically (Always), or optionally be reserved for this customer.];
                ApplicationArea=#Advanced;
                SourceExpr=Reserve }

    { 123 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om debitoren accepterer dellevering af ordrer.;
                           ENU=Specifies if the customer accepts partial shipment of orders.];
                ApplicationArea=#Advanced;
                SourceExpr="Shipping Advice";
                Importance=Promoted }

    { 145 ;2   ;Group     ;
                CaptionML=[DAN=Leveringsform;
                           ENU=Shipment Method];
                GroupType=Group }

    { 30  ;3   ;Field     ;
                CaptionML=[DAN=Kode;
                           ENU=Code];
                ToolTipML=[DAN=Angiver den leveringsform, der skal benyttes ved levering af varer til debitoren.;
                           ENU=Specifies which shipment method to use when you ship items to the customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Shipment Method Code";
                Importance=Promoted }

    { 101 ;3   ;Field     ;
                CaptionML=[DAN=Spedit�r;
                           ENU=Agent];
                ToolTipML=[DAN=Angiver den spedit�r, der skal benyttes ved levering af varer til debitoren.;
                           ENU=Specifies which shipping company is used when you ship items to the customer.];
                ApplicationArea=#Suite;
                SourceExpr="Shipping Agent Code";
                Importance=Additional }

    { 131 ;3   ;Field     ;
                CaptionML=[DAN=Spedit�rservice;
                           ENU=Agent Service];
                ToolTipML=[DAN=Angiver koden for den spedit�rtjeneste, der skal bruges til debitoren.;
                           ENU=Specifies the code for the shipping agent service to use for this customer.];
                ApplicationArea=#Suite;
                SourceExpr="Shipping Agent Service Code";
                Importance=Additional }

    { 119 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor lang tid der g�r, fra varerne er sendt fra lageret, til de er leveret.;
                           ENU=Specifies how long it takes from when the items are shipped from the warehouse to when they are delivered.];
                ApplicationArea=#Suite;
                SourceExpr="Shipping Time";
                Importance=Additional }

    { 141 ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver en redigerbar kalender for leveringsplanl�gning, der indeholder debitorens arbejdsdage og fridage.;
                           ENU=Specifies a customizable calendar for shipment planning that holds the customer's working days and holidays.];
                ApplicationArea=#Advanced;
                SourceExpr="Base Calendar Code" }

    { 146 ;2   ;Field     ;
                Name=Customized Calendar;
                CaptionML=[DAN=Tilpasset kalender;
                           ENU=Customized Calendar];
                ToolTipML=[DAN=Angiver, at du har oprettet en tilpasset version af en basiskalender.;
                           ENU=Specifies that you have set up a customized version of a base calendar.];
                ApplicationArea=#Advanced;
                SourceExpr=CalendarMgmt.CustomizedCalendarExistText(CustomizedCalendar."Source Type"::Customer,"No.",'',"Base Calendar Code");
                Editable=FALSE;
                OnDrillDown=BEGIN
                              CurrPage.SAVERECORD;
                              TESTFIELD("Base Calendar Code");
                              CalendarMgmt.ShowCustomizedCalendar(CustomizedCalEntry."Source Type"::Customer,"No.",'',"Base Calendar Code");
                            END;
                             }

    { 124 ;1   ;Group     ;
                Name=Statistics;
                CaptionML=[DAN=Statistik;
                           ENU=Statistics];
                Visible=FoundationOnly;
                Editable=false;
                GroupType=Group }

    { 120 ;2   ;Group     ;
                Name=Balance;
                CaptionML=[DAN=Saldo;
                           ENU=Balance];
                GroupType=Group }

    { 117 ;3   ;Field     ;
                Name=Balance (LCY)2;
                CaptionML=[DAN=Skyldige bel�b - aktuelle;
                           ENU=Money Owed - Current];
                ToolTipML=[DAN=Angiver det betalingsbel�b, som debitoren skylder for afsluttede salg samt salg, der stadig er igangv�rende. V�rdien kaldes ogs� debitorsaldo.;
                           ENU=Specifies the payment amount that the customer owes for completed sales. This value is also known as the customer's balance.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Balance (LCY)";
                OnDrillDown=BEGIN
                              OpenCustomerLedgerEntries(FALSE);
                            END;
                             }

    { 116 ;3   ;Field     ;
                CaptionML=[DAN=Skyldige bel�b - forventede;
                           ENU=Money Owed - Expected];
                ToolTipML=[DAN=Angiver det betalingsbel�b, som debitoren vil skylde, n�r l�bende salgsfakturaer og kreditnotaer er afsluttet.;
                           ENU=Specifies the payment amount that the customer will owe when ongoing sales invoices and credit memos are completed.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=GetMoneyOwedExpected;
                Importance=Additional;
                OnDrillDown=BEGIN
                              CustomerMgt.DrillDownMoneyOwedExpected("No.");
                            END;
                             }

    { 115 ;3   ;Field     ;
                Name=TotalMoneyOwed;
                CaptionML=[DAN=Skyldige bel�b - i alt;
                           ENU=Money Owed - Total];
                ToolTipML=[DAN=Angiver det betalingsbel�b, som debitoren skylder for afsluttede salg samt salg, der stadig er igangv�rende. V�rdien er summen af v�rdierne i felterne Skyldige bel�b - Skyldige bel�b - aktuelle - Forventet.;
                           ENU=Specifies the payment amount that the customer owes for completed sales plus sales that are still ongoing. The value is the sum of the values in the Money Owed - Current and Money Owed - Expected fields.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Balance (LCY)" + GetMoneyOwedExpected;
                Style=Strong;
                StyleExpr=TRUE }

    { 111 ;3   ;Field     ;
                Name=CreditLimit;
                CaptionML=[DAN=Kreditmaksimum;
                           ENU=Credit Limit];
                ToolTipML=[DAN=Angiver det maksimale bel�b, som du tillader, at debitoren overskrider betalingssaldoen med, f�r der udstedes advarsler.;
                           ENU=Specifies the maximum amount you allow the customer to exceed the payment balance before warnings are issued.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Credit Limit (LCY)" }

    { 110 ;3   ;Field     ;
                ExtendedDatatype=Ratio;
                CaptionML=[DAN=Udnyttet kreditmaksimum;
                           ENU=Usage Of Credit Limit];
                ToolTipML=[DAN=Angiver, hvor meget af debitorens betalingssaldo der best�r af kredit.;
                           ENU=Specifies how much of the customer's payment balance consists of credit.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=CalcCreditLimitLCYExpendedPct;
                Style=Attention;
                StyleExpr=BalanceExhausted }

    { 108 ;2   ;Group     ;
                CaptionML=[DAN=Betalinger;
                           ENU=Payments];
                GroupType=Group }

    { 106 ;3   ;Field     ;
                Name=Balance Due;
                ToolTipML=[DAN=Angiver summen af udest�ende betalinger fra debitoren.;
                           ENU=Specifies the sum of outstanding payments from the customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=CalcOverdueBalance;
                CaptionClass=FORMAT(STRSUBSTNO(OverduePaymentsMsg,FORMAT(WORKDATE)));
                OnDrillDown=VAR
                              DtldCustLedgEntry@1000 : Record 379;
                              CustLedgEntry@1001 : Record 21;
                            BEGIN
                              DtldCustLedgEntry.SETFILTER("Customer No.","No.");
                              COPYFILTER("Global Dimension 1 Filter",DtldCustLedgEntry."Initial Entry Global Dim. 1");
                              COPYFILTER("Global Dimension 2 Filter",DtldCustLedgEntry."Initial Entry Global Dim. 2");
                              COPYFILTER("Currency Filter",DtldCustLedgEntry."Currency Code");
                              CustLedgEntry.DrillDownOnOverdueEntries(DtldCustLedgEntry);
                            END;
                             }

    { 105 ;3   ;Field     ;
                CaptionML=[DAN=Betalinger dette �r;
                           ENU=Payments This Year];
                ToolTipML=[DAN=Angiver summen af betalinger, der er modtaget fra debitoren i det aktuelle regnskabs�r.;
                           ENU=Specifies the sum of payments received from the customer in the current fiscal year.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payments (LCY)" }

    { 103 ;3   ;Field     ;
                CaptionML=[DAN=Gnsn. antal kreditdage;
                           ENU=Average Collection Period (Days)];
                ToolTipML=[DAN=Angiver, hvor l�nge debitoren normalt er om at betale fakturaer i det aktuelle regnskabs�r.;
                           ENU=Specifies how long the customer typically takes to pay invoices in the current fiscal year.];
                ApplicationArea=#Basic,#Suite;
                DecimalPlaces=0:1;
                SourceExpr=CustomerMgt.AvgDaysToPay("No.");
                Importance=Additional }

    { 102 ;3   ;Field     ;
                Name=DaysPaidPastDueDate;
                CaptionML=[DAN=Gennemsnitlige forsinkede betalinger (dage);
                           ENU=Average Late Payments (Days)];
                ToolTipML=[DAN=Angiver det gennemsnitlige antal dage, debitoren er forsinket med betalinger.;
                           ENU=Specifies the average number of days the customer is late with payments.];
                ApplicationArea=#Basic,#Suite;
                DecimalPlaces=0:1;
                SourceExpr=DaysPastDueDate;
                Importance=Additional;
                Style=Attention;
                StyleExpr=AttentionToPaidDay }

    { 100 ;2   ;Group     ;
                CaptionML=[DAN=Oms�tning dette �r;
                           ENU=Sales This Year];
                GroupType=Group }

    { 98  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver dit salg til debitoren i det nuv�rende regnskabs�r baseret p� bogf�rte salgsfakturaer. Tallet i parentes angiver antal bogf�rte salgsfakturaer.;
                           ENU=Specifies your sales to the customer in the current fiscal year based on posted sales invoices. The figure in parenthesis Specifies the number of posted sales invoices.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=GetAmountOnPostedInvoices;
                CaptionClass=STRSUBSTNO(PostedInvoicesMsg,FORMAT(NoPostedInvoices));
                OnDrillDown=BEGIN
                              CustomerMgt.DrillDownOnPostedInvoices("No.")
                            END;
                             }

    { 97  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver dine forventede refusioner til debitoren i det nuv�rende regnskabs�r baseret p� bogf�rte kreditnotaer. Tallet i parentes viser antal bogf�rte kreditnotaer.;
                           ENU=Specifies your expected refunds to the customer in the current fiscal year based on posted sales credit memos. The figure in parenthesis shows the number of posted sales credit memos.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=GetAmountOnCrMemo;
                CaptionClass=STRSUBSTNO(CreditMemosMsg,FORMAT(NoPostedCrMemos));
                OnDrillDown=BEGIN
                              CustomerMgt.DrillDownOnPostedCrMemo("No.")
                            END;
                             }

    { 96  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver dit forventede salg til debitoren i det nuv�rende regnskabs�r baseret p� igangv�rende salgsfakturaer. Tallet i parentes viser antal igangv�rende salgsfakturaer.;
                           ENU=Specifies your expected sales to the customer in the current fiscal year based on ongoing sales invoices. The figure in parenthesis shows the number of ongoing sales invoices.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=GetAmountOnOutstandingInvoices;
                CaptionClass=STRSUBSTNO(OutstandingInvoicesMsg,FORMAT(NoOutstandingInvoices));
                OnDrillDown=BEGIN
                              CustomerMgt.DrillDownOnUnpostedInvoices("No.")
                            END;
                             }

    { 92  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver dine refusioner til debitoren i det nuv�rende regnskabs�r baseret p� igangv�rende salgskreditnotaer. Tallet i parentes viser antal igangv�rende salgskreditnotaer.;
                           ENU=Specifies your refunds to the customer in the current fiscal year based on ongoing sales credit memos. The figure in parenthesis shows the number of ongoing sales credit memos.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=GetAmountOnOutstandingCrMemos;
                CaptionClass=STRSUBSTNO(OutstandingCrMemosMsg,FORMAT(NoOutstandingCrMemos));
                OnDrillDown=BEGIN
                              CustomerMgt.DrillDownOnUnpostedCrMemos("No.")
                            END;
                             }

    { 89  ;3   ;Field     ;
                CaptionML=[DAN=Salg i alt;
                           ENU=Total Sales];
                ToolTipML=[DAN=Angiver den samlede salgsoms�tning med debitoren i det aktuelle regnskabs�r. Den beregnes ud fra bel�bene, ekskl. moms, p� alle afsluttede og �bne fakturaer og kreditnotaer.;
                           ENU=Specifies your total sales turnover with the customer in the current fiscal year. It is calculated from amounts excluding VAT on all completed and open invoices and credit memos.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Totals;
                Style=Strong;
                StyleExpr=TRUE }

    { 88  ;3   ;Field     ;
                CaptionML=[DAN=Fakturarabatter;
                           ENU=Invoice Discounts];
                ToolTipML=[DAN=Angiver totalen for alle fakturarabatter, der er ydet til debitoren i det aktuelle regnskabs�r.;
                           ENU=Specifies the total of all invoice discounts that you have granted to the customer in the current fiscal year.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=CustInvDiscAmountLCY }

    { 87  ;2   ;Part      ;
                Name=AgedAccReceivableChart;
                ApplicationArea=#Advanced;
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page768;
                Visible=ShowCharts;
                PartType=Page }

    { 75  ;1   ;Part      ;
                Name=PriceAndLineDisc;
                CaptionML=[DAN=Specialpriser og -rabatter;
                           ENU=Special Prices & Discounts];
                ApplicationArea=#All;
                PagePartID=Page1345;
                Visible=FoundationOnly;
                PartType=Page }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 149 ;1   ;Part      ;
                ApplicationArea=#Basic,#Suite;
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page785;
                Visible=NOT IsOfficeAddin;
                PartType=Page }

    { 135 ;1   ;Part      ;
                CaptionML=[DAN=Detaljer;
                           ENU=Details];
                ApplicationArea=#All;
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page1611;
                Visible=IsOfficeAddin;
                PartType=Page }

    { 134 ;1   ;Part      ;
                Name=AgedAccReceivableChart2;
                ApplicationArea=#All;
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page768;
                Visible=IsOfficeAddin;
                PartType=Page }

    { 39  ;1   ;Part      ;
                ApplicationArea=#All;
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page5360;
                Visible=CRMIsCoupledToRecord;
                PartType=Page }

    { 35  ;1   ;Part      ;
                ApplicationArea=#All;
                SubPageLink=Source Type=CONST(Customer),
                            Source No.=FIELD(No.);
                PagePartID=Page875;
                Visible=SocialListeningVisible;
                PartType=Page }

    { 27  ;1   ;Part      ;
                ApplicationArea=#All;
                SubPageLink=Source Type=CONST(Customer),
                            Source No.=FIELD(No.);
                PagePartID=Page876;
                Visible=SocialListeningSetupVisible;
                PartType=Page;
                UpdatePropagation=Both }

    { 1903720907;1;Part   ;
                Name=SalesHistSelltoFactBox;
                ApplicationArea=#Basic,#Suite;
                SubPageLink=No.=FIELD(No.),
                            Currency Filter=FIELD(Currency Filter),
                            Date Filter=FIELD(Date Filter),
                            Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                            Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
                PagePartID=Page9080;
                PartType=Page }

    { 1907234507;1;Part   ;
                Name=SalesHistBilltoFactBox;
                ApplicationArea=#All;
                SubPageLink=No.=FIELD(No.),
                            Currency Filter=FIELD(Currency Filter),
                            Date Filter=FIELD(Date Filter),
                            Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                            Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
                PagePartID=Page9081;
                Visible=FALSE;
                PartType=Page }

    { 1902018507;1;Part   ;
                Name=CustomerStatisticsFactBox;
                ApplicationArea=#Advanced;
                SubPageLink=No.=FIELD(No.),
                            Currency Filter=FIELD(Currency Filter),
                            Date Filter=FIELD(Date Filter),
                            Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                            Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
                PagePartID=Page9082;
                PartType=Page }

    { 1905532107;1;Part   ;
                ApplicationArea=#Advanced;
                SubPageLink=Table ID=CONST(18),
                            No.=FIELD(No.);
                PagePartID=Page9083;
                PartType=Page }

    { 1907829707;1;Part   ;
                ApplicationArea=#Advanced;
                SubPageLink=No.=FIELD(No.),
                            Currency Filter=FIELD(Currency Filter),
                            Date Filter=FIELD(Date Filter),
                            Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                            Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
                PagePartID=Page9085;
                Visible=FALSE;
                PartType=Page }

    { 1902613707;1;Part   ;
                ApplicationArea=#Advanced;
                SubPageLink=No.=FIELD(No.),
                            Currency Filter=FIELD(Currency Filter),
                            Date Filter=FIELD(Date Filter),
                            Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                            Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
                PagePartID=Page9086;
                Visible=FALSE;
                PartType=Page }

    { 62  ;1   ;Part      ;
                Name=WorkflowStatus;
                ApplicationArea=#Suite;
                PagePartID=Page1528;
                Visible=ShowWorkflowStatus;
                Enabled=FALSE;
                Editable=FALSE;
                PartType=Page;
                ShowFilter=No }

    { 1900383207;1;Part   ;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      CustomizedCalEntry@1001 : Record 7603;
      CustomizedCalendar@1005 : Record 7602;
      CalendarMgmt@1002 : Codeunit 7600;
      ApprovalsMgmt@1009 : Codeunit 1535;
      CRMIntegrationManagement@1045 : Codeunit 5330;
      CustomerMgt@1024 : Codeunit 1302;
      StyleTxt@1004 : Text;
      ContactEditable@19051436 : Boolean INDATASET;
      GLNNoMandatory@1060000 : Boolean;
      SocialListeningSetupVisible@1000 : Boolean INDATASET;
      SocialListeningVisible@1003 : Boolean INDATASET;
      ShowCharts@1040 : Boolean INDATASET;
      CRMIntegrationEnabled@1007 : Boolean;
      CRMIsCoupledToRecord@1006 : Boolean;
      OpenApprovalEntriesExistCurrUser@1008 : Boolean;
      OpenApprovalEntriesExist@1010 : Boolean;
      ShowWorkflowStatus@1011 : Boolean;
      NoFieldVisible@1014 : Boolean;
      BalanceExhausted@1032 : Boolean;
      AttentionToPaidDay@1035 : Boolean;
      IsOfficeAddin@1065 : Boolean;
      NoPostedInvoices@1015 : Integer;
      NoPostedCrMemos@1018 : Integer;
      NoOutstandingInvoices@1017 : Integer;
      NoOutstandingCrMemos@1016 : Integer;
      Totals@1019 : Decimal;
      AmountOnPostedInvoices@1023 : Decimal;
      AmountOnPostedCrMemos@1022 : Decimal;
      AmountOnOutstandingInvoices@1021 : Decimal;
      AmountOnOutstandingCrMemos@1020 : Decimal;
      AdjmtCostLCY@1028 : Decimal;
      AdjCustProfit@1027 : Decimal;
      CustProfit@1026 : Decimal;
      AdjProfitPct@1025 : Decimal;
      CustInvDiscAmountLCY@1029 : Decimal;
      CustPaymentsLCY@1030 : Decimal;
      CustSalesLCY@1031 : Decimal;
      OverduePaymentsMsg@1033 : TextConst '@@@=Overdue Payments as of 27-02-2012;DAN=Forfaldne betalinger pr. %1;ENU=Overdue Payments as of %1';
      DaysPastDueDate@1034 : Decimal;
      PostedInvoicesMsg@1036 : TextConst '@@@=Invoices (5);DAN=Bogf�rte fakturaer (%1);ENU=Posted Invoices (%1)';
      CreditMemosMsg@1037 : TextConst '@@@=Credit Memos (3);DAN=Bogf�rte kreditnotaer (%1);ENU=Posted Credit Memos (%1)';
      OutstandingInvoicesMsg@1039 : TextConst '@@@=Ongoing Invoices (4);DAN=Igangv�rende fakturaer (%1);ENU=Ongoing Invoices (%1)';
      OutstandingCrMemosMsg@1038 : TextConst '@@@=Ongoing Credit Memos (4);DAN=Igangv�rende kreditnotaer (%1);ENU=Ongoing Credit Memos (%1)';
      ShowMapLbl@1066 : TextConst 'DAN=Vis p� kort;ENU=Show on Map';
      FoundationOnly@1012 : Boolean;
      CanCancelApprovalForRecord@1013 : Boolean;
      EnabledApprovalWorkflowsExist@1041 : Boolean;
      NewMode@1044 : Boolean;
      EventFilter@1042 : Text;
      CaptionTxt@1043 : Text;
      CanRequestApprovalForFlow@1046 : Boolean;
      CanCancelApprovalForFlow@1047 : Boolean;
      IsSaaS@1048 : Boolean;

    LOCAL PROCEDURE GetTotalSales@6() : Decimal;
    BEGIN
      NoPostedInvoices := 0;
      NoPostedCrMemos := 0;
      NoOutstandingInvoices := 0;
      NoOutstandingCrMemos := 0;
      Totals := 0;

      AmountOnPostedInvoices := CustomerMgt.CalcAmountsOnPostedInvoices("No.",NoPostedInvoices);
      AmountOnPostedCrMemos := CustomerMgt.CalcAmountsOnPostedCrMemos("No.",NoPostedCrMemos);

      AmountOnOutstandingInvoices := CustomerMgt.CalculateAmountsOnUnpostedInvoices("No.",NoOutstandingInvoices);
      AmountOnOutstandingCrMemos := CustomerMgt.CalculateAmountsOnUnpostedCrMemos("No.",NoOutstandingCrMemos);

      Totals := AmountOnPostedInvoices + AmountOnPostedCrMemos + AmountOnOutstandingInvoices + AmountOnOutstandingCrMemos;

      CustomerMgt.CalculateStatistic(
        Rec,
        AdjmtCostLCY,AdjCustProfit,AdjProfitPct,
        CustInvDiscAmountLCY,CustPaymentsLCY,CustSalesLCY,
        CustProfit);
      EXIT(Totals)
    END;

    LOCAL PROCEDURE GetAmountOnPostedInvoices@5() : Decimal;
    BEGIN
      EXIT(AmountOnPostedInvoices)
    END;

    LOCAL PROCEDURE GetAmountOnCrMemo@8() : Decimal;
    BEGIN
      EXIT(AmountOnPostedCrMemos)
    END;

    LOCAL PROCEDURE GetAmountOnOutstandingInvoices@9() : Decimal;
    BEGIN
      EXIT(AmountOnOutstandingInvoices)
    END;

    LOCAL PROCEDURE GetAmountOnOutstandingCrMemos@10() : Decimal;
    BEGIN
      EXIT(AmountOnOutstandingCrMemos)
    END;

    LOCAL PROCEDURE GetMoneyOwedExpected@11() : Decimal;
    BEGIN
      EXIT(CustomerMgt.CalculateAmountsWithVATOnUnpostedDocuments("No."))
    END;

    LOCAL PROCEDURE GetSalesPricesAndSalesLineDisc@24();
    BEGIN
      IF "No." <> CurrPage.PriceAndLineDisc.PAGE.GetLoadedCustNo THEN BEGIN
        CurrPage.PriceAndLineDisc.PAGE.LoadCustomer(Rec);
        CurrPage.PriceAndLineDisc.PAGE.UPDATE(FALSE);
      END;
    END;

    LOCAL PROCEDURE ActivateFields@3();
    BEGIN
      SetSocialListeningFactboxVisibility;
      ContactEditable := "Primary Contact No." = '';
    END;

    LOCAL PROCEDURE ContactOnAfterValidate@19013243();
    BEGIN
      ActivateFields;
    END;

    LOCAL PROCEDURE SetSocialListeningFactboxVisibility@1();
    VAR
      SocialListeningMgt@1000 : Codeunit 871;
    BEGIN
      SocialListeningMgt.GetCustFactboxVisibility(Rec,SocialListeningSetupVisible,SocialListeningVisible);
    END;

    LOCAL PROCEDURE SetNoFieldVisible@13();
    VAR
      DocumentNoVisibility@1000 : Codeunit 1400;
    BEGIN
      NoFieldVisible := DocumentNoVisibility.CustomerNoIsVisible;
    END;

    LOCAL PROCEDURE SetCustomerNoVisibilityOnFactBoxes@12();
    BEGIN
      CurrPage.SalesHistSelltoFactBox.PAGE.SetCustomerNoVisibility(FALSE);
      CurrPage.SalesHistBilltoFactBox.PAGE.SetCustomerNoVisibility(FALSE);
      CurrPage.CustomerStatisticsFactBox.PAGE.SetCustomerNoVisibility(FALSE);
    END;

    [External]
    PROCEDURE RunReport@2(ReportNumber@1000 : Integer;CustomerNumber@1002 : Code[20]);
    VAR
      Customer@1001 : Record 18;
    BEGIN
      Customer.SETRANGE("No.",CustomerNumber);
      REPORT.RUNMODAL(ReportNumber,TRUE,TRUE,Customer);
    END;

    LOCAL PROCEDURE CreateCustomerFromTemplate@27();
    VAR
      MiniCustomerTemplate@1001 : Record 1300;
      Customer@1000 : Record 18;
      VATRegNoSrvConfig@1003 : Record 248;
      EUVATRegistrationNoCheck@1002 : Page 1339;
      CustomerRecRef@1004 : RecordRef;
    BEGIN
      OnBeforeCreateCustomerFromTemplate(NewMode);

      IF NewMode THEN BEGIN
        IF MiniCustomerTemplate.NewCustomerFromTemplate(Customer) THEN BEGIN
          IF VATRegNoSrvConfig.VATRegNoSrvIsEnabled THEN
            IF Customer."Validate EU Vat Reg. No." THEN BEGIN
              EUVATRegistrationNoCheck.SetRecordRef(Customer);
              COMMIT;
              EUVATRegistrationNoCheck.RUNMODAL;
              EUVATRegistrationNoCheck.GetRecordRef(CustomerRecRef);
              CustomerRecRef.SETTABLE(Customer);
            END;

          COPY(Customer);
          CurrPage.UPDATE;
        END;
        NewMode := FALSE;
      END;
    END;

    [Integration]
    PROCEDURE SetCaption@17(VAR InText@1000 : Text);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeCreateCustomerFromTemplate@4(VAR NewMode@1000 : Boolean);
    BEGIN
    END;

    BEGIN
    END.
  }
}

