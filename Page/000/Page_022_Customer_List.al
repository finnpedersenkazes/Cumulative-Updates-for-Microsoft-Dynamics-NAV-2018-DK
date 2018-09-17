OBJECT Page 22 Customer List
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Debitorer;
               ENU=Customers];
    SourceTable=Table18;
    PageType=List;
    CardPageID=Customer Card;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Godkend,Nyt bilag,Anmod om godkendelse,Debitor;
                                ENU=New,Process,Report,Approve,New Document,Request Approval,Customer];
    OnInit=BEGIN
             SetCustomerNoVisibilityOnFactBoxes;

             CaptionTxt := CurrPage.CAPTION;
             SetCaption(CaptionTxt);
             CurrPage.CAPTION(CaptionTxt);
           END;

    OnOpenPage=VAR
                 CRMIntegrationManagement@1000 : Codeunit 5330;
               BEGIN
                 CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;

                 SetWorkflowManagementEnabledState;
                 SETFILTER("Date Filter",'..%1',WORKDATE);

                 // Contextual Power BI FactBox: filtering available reports, setting context, loading Power BI related user settings
                 CurrPage."Power BI Report FactBox".PAGE.SetNameFilter(CurrPage.CAPTION);
                 CurrPage."Power BI Report FactBox".PAGE.SetContext(CurrPage.OBJECTID(FALSE));
                 PowerBIVisible := SetPowerBIUserConfig.SetUserConfig(PowerBIUserConfiguration,CurrPage.OBJECTID(FALSE));
               END;

    OnAfterGetCurrRecord=VAR
                           CRMCouplingManagement@1001 : Codeunit 5331;
                           WorkflowWebhookManagement@1000 : Codeunit 1543;
                         BEGIN
                           SetSocialListeningFactboxVisibility;

                           CRMIsCoupledToRecord :=
                             CRMCouplingManagement.IsRecordCoupledToCRM(RECORDID) AND CRMIntegrationEnabled;
                           OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);

                           CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RECORDID);

                           WorkflowWebhookManagement.GetCanRequestAndCanCancel(RECORDID,CanRequestApprovalForFlow,CanCancelApprovalForFlow);

                           // Contextual Power BI FactBox: send data to filter the report in the FactBox
                           CurrPage."Power BI Report FactBox".PAGE.SetCurrentListSelection("No.",FALSE);

                           SetWorkflowManagementEnabledState;
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 16      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Debitor;
                                 ENU=&Customer];
                      Image=Customer }
      { 20      ;2   ;Action    ;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 124;
                      RunPageLink=Table Name=CONST(Customer),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 66      ;2   ;ActionGroup;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      Image=Dimensions }
      { 84      ;3   ;Action    ;
                      Name=DimensionsSingle;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner - enkelt;
                                 ENU=Dimensions-Single];
                      ToolTipML=[DAN=FÜ vist eller rediger de enkelte sët af dimensioner, der er oprettet for den valgte record.;
                                 ENU=View or edit the single set of dimensions that are set up for the selected record.];
                      ApplicationArea=#Suite;
                      RunObject=Page 540;
                      RunPageLink=Table ID=CONST(18),
                                  No.=FIELD(No.);
                      Image=Dimensions }
      { 42      ;3   ;Action    ;
                      Name=DimensionsMultiple;
                      AccessByPermission=TableData 348=R;
                      CaptionML=[DAN=Dimensioner - &flere;
                                 ENU=Dimensions-&Multiple];
                      ToolTipML=[DAN=Vis eller rediger dimensionerne for en gruppe af records. Du kan tildele dimensionskoder til transaktioner for at fordele omkostninger og analysere historikken.;
                                 ENU=View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyze historical information.];
                      ApplicationArea=#Suite;
                      Image=DimensionSets;
                      OnAction=VAR
                                 Cust@1001 : Record 18;
                                 DefaultDimMultiple@1002 : Page 542;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(Cust);
                                 DefaultDimMultiple.SetMultiCust(Cust);
                                 DefaultDimMultiple.RUNMODAL;
                               END;
                                }
      { 58      ;2   ;Action    ;
                      CaptionML=[DAN=Bankkonti;
                                 ENU=Bank Accounts];
                      ToolTipML=[DAN=Se eller opret debitorens bankkonti. Du kan oprette et ubegrënset antal bankkonti til hver debitor.;
                                 ENU=View or set up the customer's bank accounts. You can set up any number of bank accounts for each customer.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 424;
                      RunPageLink=Customer No.=FIELD(No.);
                      Image=BankAccount }
      { 29      ;2   ;Action    ;
                      CaptionML=[DAN=Direct Debit-betalingsaftaler;
                                 ENU=Direct Debit Mandates];
                      ToolTipML=[DAN=Se den direkte debiterings-betalingsaftale med debitorer om opkrëvning af fakturabetalinger fra deres bankkonto.;
                                 ENU=View the direct-debit mandates that reflect agreements with customers to collect invoice payments from their bank account.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 1230;
                      RunPageLink=Customer No.=FIELD(No.);
                      Image=MakeAgreement }
      { 23      ;2   ;Action    ;
                      Name=ShipToAddresses;
                      CaptionML=[DAN=Leveringsad&resser;
                                 ENU=Ship-&to Addresses];
                      ToolTipML=[DAN=Vis eller rediger de alternative leveringsadresser, hvorpÜ debitoren õnsker varer leveret til, hvis adresserne adskiller sig standardadresserne.;
                                 ENU=View or edit alternate shipping addresses where the customer wants items delivered if different from the regular address.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 301;
                      RunPageLink=Customer No.=FIELD(No.);
                      Image=ShipAddress }
      { 60      ;2   ;Action    ;
                      AccessByPermission=TableData 5050=R;
                      CaptionML=[DAN=K&ontakt;
                                 ENU=C&ontact];
                      ToolTipML=[DAN=Se eller rediger detaljerede oplysninger om kontaktpersonen hos debitoren.;
                                 ENU=View or edit detailed information about the contact person at the customer.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=ContactPerson;
                      PromotedCategory=Category7;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 ShowContact;
                               END;
                                }
      { 45      ;2   ;Action    ;
                      CaptionML=[DAN=Varere&ferencer;
                                 ENU=Cross Re&ferences];
                      ToolTipML=[DAN=Konfigurer debitors egen identifikation af de varer, som du sëlger til debitor. Krydshenvisninger til debitors varenummer betyder, at varenummeret automatisk vises i salgsdokument i stedet for det nummer, som du anvender.;
                                 ENU=Set up the customer's own identification of items that you sell to the customer. Cross-references to the customer's item number means that the item number is automatically shown on sales documents instead of the number that you use.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5723;
                      RunPageView=SORTING(Cross-Reference Type,Cross-Reference Type No.);
                      RunPageLink=Cross-Reference Type=CONST(Customer),
                                  Cross-Reference Type No.=FIELD(No.);
                      Image=Change }
      { 64      ;2   ;Action    ;
                      Name=OnlineMap;
                      CaptionML=[DAN=Online Map;
                                 ENU=Online Map];
                      ToolTipML=[DAN=Vis adressen pÜ et onlinekort.;
                                 ENU=View the address on an online map.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Visible=FALSE;
                      PromotedIsBig=Yes;
                      Image=Map;
                      PromotedCategory=Category5;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 DisplayMap;
                               END;
                                }
      { 67      ;2   ;Action    ;
                      Name=ApprovalEntries;
                      AccessByPermission=TableData 454=R;
                      CaptionML=[DAN=Godkendelser;
                                 ENU=Approvals];
                      ToolTipML=[DAN=FÜ vist en liste over records, der afventer godkendelse. Du kan f.eks. se, hvem der har anmodet om godkendelse af recorden, hvornÜr den blev sendt og hvornÜr den skal godkendes.;
                                 ENU=View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Image=Approvals;
                      PromotedCategory=Category7;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 ApprovalsMgmt.OpenApprovalEntriesPage(RECORDID);
                               END;
                                }
      { 44      ;1   ;ActionGroup;
                      Name=ActionGroupCRM;
                      CaptionML=[DAN=Dynamics 365 for Sales;
                                 ENU=Dynamics 365 for Sales];
                      Visible=CRMIntegrationEnabled }
      { 41      ;2   ;Action    ;
                      Name=CRMGotoAccount;
                      CaptionML=[DAN=Konto;
                                 ENU=Account];
                      ToolTipML=[DAN=èbn den sammenkëdede Dynamics 365 for Sales-konto.;
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
      { 37      ;2   ;Action    ;
                      Name=CRMSynchronizeNow;
                      AccessByPermission=TableData 5331=IM;
                      CaptionML=[DAN=Synkroniser nu;
                                 ENU=Synchronize Now];
                      ToolTipML=[DAN=Send eller hent opdaterede data til eller fra Dynamics 365 for Sales.;
                                 ENU=Send or get updated data to or from Dynamics 365 for Sales.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Visible=CRMIntegrationEnabled;
                      Image=Refresh;
                      PromotedCategory=Category7;
                      OnAction=VAR
                                 Customer@1000 : Record 18;
                                 CRMIntegrationManagement@1001 : Codeunit 5330;
                                 CustomerRecordRef@1003 : RecordRef;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(Customer);
                                 Customer.NEXT;

                                 IF Customer.COUNT = 1 THEN
                                   CRMIntegrationManagement.UpdateOneNow(Customer.RECORDID)
                                 ELSE BEGIN
                                   CustomerRecordRef.GETTABLE(Customer);
                                   CRMIntegrationManagement.UpdateMultipleNow(CustomerRecordRef);
                                 END
                               END;
                                }
      { 97      ;2   ;Action    ;
                      Name=UpdateStatisticsInCRM;
                      CaptionML=[DAN=OpdatÇr kontostatistik;
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
      { 31      ;2   ;ActionGroup;
                      Name=Coupling;
                      CaptionML=[@@@=Coupling is a noun;
                                 DAN=Sammenkëdning;
                                 ENU=Coupling];
                      ToolTipML=[DAN=Opret, rediger eller slet en sammenkëdning mellem Microsoft Dynamics NAV-recorden og en Dynamics 365 for Sales-record.;
                                 ENU=Create, change, or delete a coupling between the Microsoft Dynamics NAV record and a Dynamics 365 for Sales record.];
                      Image=LinkAccount }
      { 49      ;3   ;Action    ;
                      Name=ManageCRMCoupling;
                      AccessByPermission=TableData 5331=IM;
                      CaptionML=[DAN=Konfigurer sammenkëdning;
                                 ENU=Set Up Coupling];
                      ToolTipML=[DAN=Opret eller rediger sammenkëdningen med en Dynamics 365 for Sales-konto.;
                                 ENU=Create or modify the coupling to a Dynamics 365 for Sales account.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Visible=CRMIntegrationEnabled;
                      Image=LinkAccount;
                      PromotedCategory=Category7;
                      OnAction=VAR
                                 CRMIntegrationManagement@1000 : Codeunit 5330;
                               BEGIN
                                 CRMIntegrationManagement.DefineCoupling(RECORDID);
                               END;
                                }
      { 47      ;3   ;Action    ;
                      Name=DeleteCRMCoupling;
                      AccessByPermission=TableData 5331=IM;
                      CaptionML=[DAN=Slet sammenkëdning;
                                 ENU=Delete Coupling];
                      ToolTipML=[DAN=Slet sammenkëdningen med en Dynamics 365 for Sales-konto.;
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
      { 53      ;2   ;ActionGroup;
                      Name=Create;
                      CaptionML=[DAN=Opret;
                                 ENU=Create];
                      Image=NewCustomer }
      { 57      ;3   ;Action    ;
                      Name=CreateInCRM;
                      CaptionML=[DAN=Opret konto i Dynamics 365 for Sales;
                                 ENU=Create Account in Dynamics 365 for Sales];
                      ToolTipML=[DAN=Opret kontoen i den sammenkëdede Dynamics 365 for Sales-konto.;
                                 ENU=Generate the account in the coupled Dynamics 365 for Sales account.];
                      ApplicationArea=#Suite;
                      Visible=CRMIntegrationEnabled;
                      Image=NewCustomer;
                      OnAction=VAR
                                 Customer@1001 : Record 18;
                                 CRMIntegrationManagement@1000 : Codeunit 5330;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(Customer);
                                 CRMIntegrationManagement.CreateNewRecordsInCRM(Customer);
                               END;
                                }
      { 17      ;3   ;Action    ;
                      Name=CreateFromCRM;
                      CaptionML=[DAN=Opret kreditor i Dynamics NAV;
                                 ENU=Create Customer in Dynamics NAV];
                      ToolTipML=[DAN=Opret debitoren pÜ den sammenkëdede Dynamics 365 for Sales-konto.;
                                 ENU=Generate the customer in the coupled Dynamics 365 for Sales account.];
                      ApplicationArea=#Suite;
                      Visible=CRMIntegrationEnabled;
                      Image=NewCustomer;
                      OnAction=VAR
                                 CRMIntegrationManagement@1000 : Codeunit 5330;
                               BEGIN
                                 CRMIntegrationManagement.CreateNewCustomerFromCRM;
                               END;
                                }
      { 86      ;2   ;Action    ;
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
      { 9       ;1   ;ActionGroup;
                      CaptionML=[DAN=Oversigt;
                                 ENU=History];
                      Image=History }
      { 22      ;2   ;Action    ;
                      Name=CustomerLedgerEntries;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=Post&er;
                                 ENU=Ledger E&ntries];
                      ToolTipML=[DAN=Se historikken over transaktioner, der er bogfõrt for den valgte record.;
                                 ENU=View the history of transactions that have been posted for the selected record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 25;
                      RunPageView=SORTING(Customer No.)
                                  ORDER(Descending);
                      RunPageLink=Customer No.=FIELD(No.);
                      Image=CustomerLedger }
      { 18      ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=FÜ vist statistiske oplysninger om recorden, f.eks. vërdien af bogfõrte poster.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 151;
                      RunPageLink=No.=FIELD(No.),
                                  Date Filter=FIELD(Date Filter),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 21      ;2   ;Action    ;
                      CaptionML=[DAN=Forfaldsoversig&t;
                                 ENU=S&ales];
                      ToolTipML=[DAN=Viser en oversigt over debitorposter. Du kan vëlge tidsintervallet i feltet Vis efter. Kolonnen Periodestart til venstre viser datoer efter det valgte tidsinterval.;
                                 ENU=Shows a summary of customer ledger entries. You select the time interval in the View by field. The Period column on the left contains a series of dates that are determined by the time interval you have selected.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 155;
                      RunPageLink=No.=FIELD(No.),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
                      Image=Sales }
      { 19      ;2   ;Action    ;
                      CaptionML=[DAN=Poststatistik;
                                 ENU=Entry Statistics];
                      ToolTipML=[DAN=Vis poststatistik for den pÜgëldende record.;
                                 ENU=View entry statistics for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 302;
                      RunPageLink=No.=FIELD(No.),
                                  Date Filter=FIELD(Date Filter),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
                      Image=EntryStatistics }
      { 63      ;2   ;Action    ;
                      CaptionML=[DAN=Va&lutastatistik;
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
                                 ItemTrackingDocMgt@1001 : Codeunit 6503;
                               BEGIN
                                 ItemTrackingDocMgt.ShowItemTrackingForMasterData(1,"No.",'','','','','');
                               END;
                                }
      { 24      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Salg;
                                 ENU=S&ales];
                      Image=Sales }
      { 25      ;2   ;Action    ;
                      Name=Sales_InvoiceDiscounts;
                      CaptionML=[DAN=Fakturara&batter;
                                 ENU=Invoice &Discounts];
                      ToolTipML=[DAN=Angiv forskellige rabatter, som kan tilfõjes fakturaer til debitor. Der gives automatisk en fakturarabat til debitor, nÜr det samlede fakturabelõb overstiger et vist belõb.;
                                 ENU=Set up different discounts that are applied to invoices for the customer. An invoice discount is automatically granted to the customer when the total on a sales invoice exceeds a certain amount.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 23;
                      RunPageLink=Code=FIELD(Invoice Disc. Code);
                      Image=CalculateInvoiceDiscount }
      { 26      ;2   ;Action    ;
                      Name=Sales_Prices;
                      CaptionML=[DAN=Salgspriser;
                                 ENU=Prices];
                      ToolTipML=[DAN=Vis eller angiv forskellige priser for de varer, du sëlger til debitoren. En varepris anfõres automatisk pÜ fakturalinjer, nÜr de specificerede kriterier er opfyldt, f.eks. debitor, mëngde eller slutdato.;
                                 ENU=View or set up different prices for items that you sell to the customer. An item price is automatically granted on invoice lines when the specified criteria are met, such as customer, quantity, or ending date.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 7002;
                      RunPageView=SORTING(Sales Type,Sales Code);
                      RunPageLink=Sales Type=CONST(Customer),
                                  Sales Code=FIELD(No.);
                      Image=Price }
      { 71      ;2   ;Action    ;
                      Name=Sales_LineDiscounts;
                      CaptionML=[DAN=Linjerabat;
                                 ENU=Line Discounts];
                      ToolTipML=[DAN=Vis eller angiv forskellige rabatter for de varer, du sëlger til debitoren. En varerabat anfõres automatisk pÜ fakturalinjer, nÜr de specificerede kriterier er opfyldt, f.eks. debitor, antal eller slutdato.;
                                 ENU=View or set up different discounts for items that you sell to the customer. An item discount is automatically granted on invoice lines when the specified criteria are met, such as customer, quantity, or ending date.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 7004;
                      RunPageView=SORTING(Sales Type,Sales Code);
                      RunPageLink=Sales Type=CONST(Customer),
                                  Sales Code=FIELD(No.);
                      Image=LineDiscount }
      { 82      ;2   ;Action    ;
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
      { 75      ;2   ;Action    ;
                      CaptionML=[DAN=St&andarddeb.salgskoder;
                                 ENU=S&td. Cust. Sales Codes];
                      ToolTipML=[DAN=Vis eller rediger tilbagevendende salgslinjer for debitoren.;
                                 ENU=View or edit recurring sales lines for the customer.];
                      ApplicationArea=#Suite;
                      RunObject=Page 173;
                      RunPageLink=Customer No.=FIELD(No.);
                      Image=CodesList }
      { 11      ;1   ;ActionGroup;
                      CaptionML=[DAN=Dokumenter;
                                 ENU=Documents];
                      Image=Documents }
      { 27      ;2   ;Action    ;
                      CaptionML=[DAN=Tilbud;
                                 ENU=Quotes];
                      ToolTipML=[DAN=Vi en oversigt over igangvërende salgstilbud.;
                                 ENU=View a list of ongoing sales quotes.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9300;
                      RunPageView=SORTING(Sell-to Customer No.);
                      RunPageLink=Sell-to Customer No.=FIELD(No.);
                      Image=Quote }
      { 28      ;2   ;Action    ;
                      CaptionML=[DAN=Ordrer;
                                 ENU=Orders];
                      ToolTipML=[DAN=Vis en liste med igangvërende salgsordrer for debitoren.;
                                 ENU=View a list of ongoing sales orders for the customer.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9305;
                      RunPageView=SORTING(Sell-to Customer No.);
                      RunPageLink=Sell-to Customer No.=FIELD(No.);
                      Image=Document }
      { 70      ;2   ;Action    ;
                      CaptionML=[DAN=Returvareordrer;
                                 ENU=Return Orders];
                      ToolTipML=[DAN=èbn oversigten over igangvërende returordrer.;
                                 ENU=Open the list of ongoing return orders.];
                      ApplicationArea=#SalesReturnOrder;
                      RunObject=Page 9304;
                      RunPageView=SORTING(Sell-to Customer No.);
                      RunPageLink=Sell-to Customer No.=FIELD(No.);
                      Image=ReturnOrder }
      { 76      ;2   ;ActionGroup;
                      CaptionML=[DAN=Udstedte dokumenter;
                                 ENU=Issued Documents];
                      Image=Documents }
      { 77      ;3   ;Action    ;
                      CaptionML=[DAN=Udstedte ry&kkere;
                                 ENU=Issued &Reminders];
                      ToolTipML=[DAN=Vis de pÜmindelser, du har sendt til debitoren.;
                                 ENU=View the reminders that you have sent to the customer.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 440;
                      RunPageView=SORTING(Customer No.,Posting Date);
                      RunPageLink=Customer No.=FIELD(No.);
                      Image=OrderReminder }
      { 78      ;3   ;Action    ;
                      CaptionML=[DAN=Udstedte &rentenotaer;
                                 ENU=Issued &Finance Charge Memos];
                      ToolTipML=[DAN=Vis de rentenotaer, du har sendt til debitoren.;
                                 ENU=View the finance charge memos that you have sent to the customer.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 452;
                      RunPageView=SORTING(Customer No.,Posting Date);
                      RunPageLink=Customer No.=FIELD(No.);
                      Image=FinChargeMemo }
      { 65      ;2   ;Action    ;
                      CaptionML=[DAN=Rammeordrer;
                                 ENU=Blanket Orders];
                      ToolTipML=[DAN=èbn oversigten over igangvërende rammeordrer.;
                                 ENU=Open the list of ongoing blanket orders.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9303;
                      RunPageView=SORTING(Document Type,Sell-to Customer No.);
                      RunPageLink=Sell-to Customer No.=FIELD(No.);
                      Image=BlanketOrder }
      { 14      ;1   ;ActionGroup;
                      CaptionML=[DAN=Service;
                                 ENU=Service];
                      Image=ServiceItem }
      { 81      ;2   ;Action    ;
                      CaptionML=[DAN=Serviceordrer;
                                 ENU=Service Orders];
                      ToolTipML=[DAN=èbn oversigten over igangvërende serviceordrer.;
                                 ENU=Open the list of ongoing service orders.];
                      ApplicationArea=#Service;
                      RunObject=Page 9318;
                      RunPageView=SORTING(Document Type,Customer No.);
                      RunPageLink=Customer No.=FIELD(No.);
                      Image=Document }
      { 68      ;2   ;Action    ;
                      CaptionML=[DAN=Servi&cekontrakter;
                                 ENU=Ser&vice Contracts];
                      ToolTipML=[DAN=èbn oversigten over igangvërende servicekontrakter.;
                                 ENU=Open the list of ongoing service contracts.];
                      ApplicationArea=#Service;
                      RunObject=Page 6065;
                      RunPageView=SORTING(Customer No.,Ship-to Code);
                      RunPageLink=Customer No.=FIELD(No.);
                      Image=ServiceAgreement }
      { 69      ;2   ;Action    ;
                      CaptionML=[DAN=Se&rviceartikler;
                                 ENU=Service &Items];
                      ToolTipML=[DAN=Vis eller rediger de serviceartikler, der er registreret for debitoren.;
                                 ENU=View or edit the service items that are registered for the customer.];
                      ApplicationArea=#Service;
                      RunObject=Page 5988;
                      RunPageView=SORTING(Customer No.,Ship-to Code,Item No.,Serial No.);
                      RunPageLink=Customer No.=FIELD(No.);
                      Image=ServiceItem }
      { 1900000005;0 ;ActionContainer;
                      ActionContainerType=NewDocumentItems }
      { 1902575205;1 ;Action    ;
                      Name=NewSalesBlanketOrder;
                      CaptionML=[DAN=Rammesalgsordre;
                                 ENU=Blanket Sales Order];
                      ToolTipML=[DAN=Opret en rammesalgsordre til debitoren.;
                                 ENU=Create a blanket sales order for the customer.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 507;
                      RunPageLink=Sell-to Customer No.=FIELD(No.);
                      Image=BlanketOrder;
                      RunPageMode=Create }
      { 1900246505;1 ;Action    ;
                      Name=NewSalesQuote;
                      CaptionML=[DAN=Salgstilbud;
                                 ENU=Sales Quote];
                      ToolTipML=[DAN=Tilbyd varer eller servicer til en debitor.;
                                 ENU=Offer items or services to a customer.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 41;
                      RunPageLink=Sell-to Customer No.=FIELD(No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=NewSalesQuote;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes;
                      RunPageMode=Create }
      { 1906384905;1 ;Action    ;
                      Name=NewSalesInvoice;
                      CaptionML=[DAN=Salgsfaktura;
                                 ENU=Sales Invoice];
                      ToolTipML=[DAN=Opret en salgsfaktura pÜ debitoren.;
                                 ENU=Create a sales invoice for the customer.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 43;
                      RunPageLink=Sell-to Customer No.=FIELD(No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=NewSalesInvoice;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes;
                      RunPageMode=Create }
      { 1904747105;1 ;Action    ;
                      Name=NewSalesOrder;
                      CaptionML=[DAN=Salgsordre;
                                 ENU=Sales Order];
                      ToolTipML=[DAN=Opret en salgsordre for debitoren.;
                                 ENU=Create a sales order for the customer.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 42;
                      RunPageLink=Sell-to Customer No.=FIELD(No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Document;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes;
                      RunPageMode=Create }
      { 1902583505;1 ;Action    ;
                      Name=NewSalesCrMemo;
                      CaptionML=[DAN=Salgskreditnota;
                                 ENU=Sales Credit Memo];
                      ToolTipML=[DAN=Opret en ny salgskreditnota for at tilbagefõre en bogfõrt salgsfaktura.;
                                 ENU=Create a new sales credit memo to revert a posted sales invoice.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 44;
                      RunPageLink=Sell-to Customer No.=FIELD(No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=CreditMemo;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes;
                      RunPageMode=Create }
      { 1905163705;1 ;Action    ;
                      Name=NewSalesReturnOrder;
                      CaptionML=[DAN=Salgsreturvareordre;
                                 ENU=Sales Return Order];
                      ToolTipML=[DAN=Opret en ny salgsreturordre for varer eller servicer.;
                                 ENU=Create a new sales return order for items or services.];
                      ApplicationArea=#SalesReturnOrder;
                      RunObject=Page 6630;
                      RunPageLink=Sell-to Customer No.=FIELD(No.);
                      Image=ReturnOrder;
                      RunPageMode=Create }
      { 1905185205;1 ;Action    ;
                      Name=NewServiceQuote;
                      CaptionML=[DAN=Servicetilbud;
                                 ENU=Service Quote];
                      ToolTipML=[DAN=Opret et nyt servicetilbud for debitoren.;
                                 ENU=Create a new service quote for the customer.];
                      ApplicationArea=#Service;
                      RunObject=Page 5964;
                      RunPageLink=Customer No.=FIELD(No.);
                      Image=Quote;
                      RunPageMode=Create }
      { 1902079405;1 ;Action    ;
                      Name=NewServiceInvoice;
                      CaptionML=[DAN=Servicefaktura;
                                 ENU=Service Invoice];
                      ToolTipML=[DAN=Opret en ny servicefaktura for debitoren.;
                                 ENU=Create a new service invoice for the customer.];
                      ApplicationArea=#Service;
                      RunObject=Page 5933;
                      RunPageLink=Customer No.=FIELD(No.);
                      Image=Invoice;
                      RunPageMode=Create }
      { 1907102005;1 ;Action    ;
                      Name=NewServiceOrder;
                      CaptionML=[DAN=Serviceordre;
                                 ENU=Service Order];
                      ToolTipML=[DAN=Opret en ny serviceordre for debitoren.;
                                 ENU=Create a new service order for the customer.];
                      ApplicationArea=#Service;
                      RunObject=Page 5900;
                      RunPageLink=Customer No.=FIELD(No.);
                      Image=Document;
                      RunPageMode=Create }
      { 1901662105;1 ;Action    ;
                      Name=NewServiceCrMemo;
                      CaptionML=[DAN=Servicekreditnota;
                                 ENU=Service Credit Memo];
                      ToolTipML=[DAN=Opret en ny servicekreditnota for debitoren.;
                                 ENU=Create a new service credit memo for the customer.];
                      ApplicationArea=#Service;
                      RunObject=Page 5935;
                      RunPageLink=Customer No.=FIELD(No.);
                      Image=CreditMemo;
                      RunPageMode=Create }
      { 1903839805;1 ;Action    ;
                      Name=NewReminder;
                      CaptionML=[DAN=Rykkermeddelelse;
                                 ENU=Reminder];
                      ToolTipML=[DAN=Opret en ny rykker til debitoren.;
                                 ENU=Create a new reminder for the customer.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 434;
                      RunPageLink=Customer No.=FIELD(No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Reminder;
                      PromotedCategory=Category5;
                      RunPageMode=Create }
      { 1901102005;1 ;Action    ;
                      Name=NewFinChargeMemo;
                      CaptionML=[DAN=Rentenota;
                                 ENU=Finance Charge Memo];
                      ToolTipML=[DAN=Opret en ny rentenota.;
                                 ENU=Create a new finance charge memo.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 446;
                      RunPageLink=Customer No.=FIELD(No.);
                      Image=FinChargeMemo;
                      RunPageMode=Create }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 104     ;1   ;ActionGroup;
                      CaptionML=[DAN=Oversigt;
                                 ENU=History];
                      Image=History }
      { 103     ;2   ;Action    ;
                      Name=CustomerLedgerEntriesHistory;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=V&areposter;
                                 ENU=Ledger E&ntries];
                      ToolTipML=[DAN=Se historikken over transaktioner, der er bogfõrt for den valgte record.;
                                 ENU=View the history of transactions that have been posted for the selected record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 25;
                      RunPageView=SORTING(Customer No.);
                      RunPageLink=Customer No.=FIELD(No.);
                      Image=CustomerLedger;
                      Scope=Repeater }
      { 102     ;1   ;ActionGroup;
                      Name=PricesAndDiscounts;
                      CaptionML=[DAN=Priser og rabatter;
                                 ENU=Prices and Discounts] }
      { 101     ;2   ;Action    ;
                      Name=Prices_InvoiceDiscounts;
                      CaptionML=[DAN=Faktura&rabatter;
                                 ENU=Invoice &Discounts];
                      ToolTipML=[DAN=Angiv forskellige rabatter, som kan tilfõjes fakturaer til den valgte debitor. Der gives automatisk en fakturarabat til debitor, nÜr det samlede fakturabelõb overstiger et vist belõb.;
                                 ENU=Set up different discounts applied to invoices for the selected customer. An invoice discount is automatically granted to the customer when the total on a sales invoice exceeds a certain amount.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 23;
                      RunPageLink=Code=FIELD(Invoice Disc. Code);
                      Image=CalculateInvoiceDiscount;
                      Scope=Repeater }
      { 100     ;2   ;Action    ;
                      Name=Prices_Prices;
                      CaptionML=[DAN=Priser;
                                 ENU=Prices];
                      ToolTipML=[DAN=Vis eller angiv forskellige priser for de varer, du sëlger til den valgte debitor. En varepris anfõres automatisk pÜ fakturalinjer, nÜr de specificerede kriterier er blevet opfyldt, f.eks. debitor, mëngde eller slutdato.;
                                 ENU=View or set up different prices for items that you sell to the selected customer. An item price is automatically granted on invoice lines when the specified criteria are met, such as customer, quantity, or ending date.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 7002;
                      RunPageView=SORTING(Sales Type,Sales Code);
                      RunPageLink=Sales Type=CONST(Customer),
                                  Sales Code=FIELD(No.);
                      Image=Price;
                      Scope=Repeater }
      { 98      ;2   ;Action    ;
                      Name=Prices_LineDiscounts;
                      CaptionML=[DAN=Linjerabat;
                                 ENU=Line Discounts];
                      ToolTipML=[DAN=Vis eller angiv forskellige rabatter for de varer, du sëlger til debitoren. En varerabat anfõres automatisk pÜ fakturalinjer, nÜr de specificerede kriterier er opfyldt, f.eks. debitor, antal eller slutdato.;
                                 ENU=View or set up different discounts for items that you sell to the customer. An item discount is automatically granted on invoice lines when the specified criteria are met, such as customer, quantity, or ending date.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 7004;
                      RunPageView=SORTING(Sales Type,Sales Code);
                      RunPageLink=Sales Type=CONST(Customer),
                                  Sales Code=FIELD(No.);
                      Image=LineDiscount;
                      Scope=Repeater }
      { 55      ;1   ;ActionGroup;
                      CaptionML=[DAN=Anmod om godkendelse;
                                 ENU=Request Approval];
                      Image=SendApprovalRequest }
      { 51      ;2   ;Action    ;
                      Name=SendApprovalRequest;
                      CaptionML=[DAN=Send go&dkendelsesanmodning;
                                 ENU=Send A&pproval Request];
                      ToolTipML=[DAN=Anmod om tilladelse til at ëndre recorden.;
                                 ENU=Request approval to change the record.];
                      ApplicationArea=#Advanced;
                      Enabled=(NOT OpenApprovalEntriesExist) AND EnabledApprovalWorkflowsExist AND CanRequestApprovalForFlow;
                      Image=SendApprovalRequest;
                      OnAction=VAR
                                 ApprovalsMgmt@1001 : Codeunit 1535;
                               BEGIN
                                 IF ApprovalsMgmt.CheckCustomerApprovalsWorkflowEnabled(Rec) THEN
                                   ApprovalsMgmt.OnSendCustomerForApproval(Rec);
                               END;
                                }
      { 39      ;2   ;Action    ;
                      Name=CancelApprovalRequest;
                      CaptionML=[DAN=Annuller godkendelsesan&modning;
                                 ENU=Cancel Approval Re&quest];
                      ToolTipML=[DAN=Annuller godkendelsesanmodningen.;
                                 ENU=Cancel the approval request.];
                      ApplicationArea=#Advanced;
                      Enabled=CanCancelApprovalForRecord OR CanCancelApprovalForFlow;
                      Image=CancelApprovalRequest;
                      OnAction=VAR
                                 ApprovalsMgmt@1001 : Codeunit 1535;
                                 WorkflowWebhookManagement@1000 : Codeunit 1543;
                               BEGIN
                                 ApprovalsMgmt.OnCancelCustomerApprovalRequest(Rec);
                                 WorkflowWebhookManagement.FindAndCancel(RECORDID);
                               END;
                                }
      { 85      ;1   ;ActionGroup;
                      CaptionML=[DAN=Workflow;
                                 ENU=Workflow] }
      { 15      ;2   ;Action    ;
                      Name=CreateApprovalWorkflow;
                      CaptionML=[DAN=Opret godkendelsesworkflow;
                                 ENU=Create Approval Workflow];
                      ToolTipML=[DAN=Opret et godkendelsesworkflow for oprettelse og ëndring af debitorer ved at gennemgÜ et par sider med instruktioner.;
                                 ENU=Set up an approval workflow for creating or changing customers, by going through a few pages that will guide you.];
                      ApplicationArea=#Suite;
                      Enabled=NOT EnabledApprovalWorkflowsExist;
                      Image=CreateWorkflow;
                      OnAction=BEGIN
                                 PAGE.RUNMODAL(PAGE::"Cust. Approval WF Setup Wizard");
                                 SetWorkflowManagementEnabledState;
                               END;
                                }
      { 13      ;2   ;Action    ;
                      Name=ManageApprovalWorkflows;
                      CaptionML=[DAN=Administrer godkendelsesworkflows;
                                 ENU=Manage Approval Workflows];
                      ToolTipML=[DAN=Se eller rediger eksisterende godkendelsesworkflows for oprettelse og ëndring af debitorer.;
                                 ENU=View or edit existing approval workflows for creating or changing customers.];
                      ApplicationArea=#Suite;
                      Enabled=EnabledApprovalWorkflowsExist;
                      Image=WorkflowSetup;
                      OnAction=VAR
                                 WorkflowManagement@1000 : Codeunit 1501;
                               BEGIN
                                 WorkflowManagement.NavigateToWorkflows(DATABASE::Customer,EventFilter);
                                 SetWorkflowManagementEnabledState;
                               END;
                                }
      { 1900839804;1 ;Action    ;
                      CaptionML=[DAN=Indbetalingskladde;
                                 ENU=Cash Receipt Journal];
                      ToolTipML=[DAN=èbn indbetalingskladden for at bogfõre indgÜende betalinger.;
                                 ENU=Open the cash receipt journal to post incoming payments.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 255;
                      Promoted=Yes;
                      Image=CashReceiptJournal;
                      PromotedCategory=Process }
      { 1905171704;1 ;Action    ;
                      CaptionML=[DAN=Salgskladde;
                                 ENU=Sales Journal];
                      ToolTipML=[DAN=Bogfõr alle salgstransaktioner for debitoren.;
                                 ENU=Post any sales transaction for the customer.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 253;
                      Promoted=Yes;
                      Image=Journals;
                      PromotedCategory=Process }
      { 108     ;1   ;Action    ;
                      Name=ApplyTemplate;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Anvend skabelon;
                                 ENU=Apply Template];
                      ToolTipML=[DAN=Anvend en skabelon for at opdatere en eller flere enheder med dine standardindstillinger for en bestemt enhedstype.;
                                 ENU=Apply a template to update one or more entities with your standard settings for a certain type of entity.];
                      ApplicationArea=#Basic,#Suite;
                      Image=ApplyTemplate;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 Customer@1001 : Record 18;
                                 MiniCustomerTemplate@1000 : Record 1300;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(Customer);
                                 MiniCustomerTemplate.UpdateCustomersFromTemplate(Customer);
                               END;
                                }
      { 105     ;1   ;ActionGroup;
                      CaptionML=[DAN=Vis;
                                 ENU=Display] }
      { 106     ;2   ;Action    ;
                      Name=ReportFactBoxVisibility;
                      CaptionML=[DAN=Vis/skjul Power BI-rapporter;
                                 ENU=Show/Hide Power BI Reports];
                      ToolTipML=[DAN=Vëlg, om faktaboksen Power BI skal vëre synlig eller ej.;
                                 ENU=Select if the Power BI FactBox is visible or not.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Report;
                      OnAction=BEGIN
                                 IF PowerBIVisible THEN
                                   PowerBIVisible := FALSE
                                 ELSE
                                   PowerBIVisible := TRUE;
                                 // save visibility value into the table
                                 CurrPage."Power BI Report FactBox".PAGE.SetFactBoxVisibility(PowerBIVisible);
                               END;
                                }
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 96      ;1   ;ActionGroup;
                      Name=Reports;
                      CaptionML=[DAN=Rapporter;
                                 ENU=Reports] }
      { 95      ;2   ;ActionGroup;
                      Name=SalesReports;
                      CaptionML=[DAN=Salgsrapporter;
                                 ENU=Sales Reports];
                      Image=Report }
      { 94      ;3   ;Action    ;
                      Name=ReportCustomerTop10List;
                      CaptionML=[DAN=Debitor - top 10-liste;
                                 ENU=Customer - Top 10 List];
                      ToolTipML=[DAN=Vis de debitorer, der kõber mest, eller som skylder mest, i en bestemt periode. Kun de debitorer, der har kõb i lõbet af perioden eller en saldo ved periodens afslutning, vil blive vist i rapporten.;
                                 ENU=View which customers purchase the most or owe the most in a selected period. Only customers that have either purchases during the period or a balance at the end of the period will be included.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 111;
                      Image=Report }
      { 93      ;3   ;Action    ;
                      Name=ReportCustomerSalesList;
                      CaptionML=[DAN=Debitor - salgsoversigt;
                                 ENU=Customer - Sales List];
                      ToolTipML=[DAN=Vis debitorsalg for en given periode, f.eks. for at rapportere om salgsaktivitet til SKAT. Du kan vëlge kun at medtage debitorer med et samlet salg, der overstiger et bestemt belõb. Du kan ogsÜ angive, om rapporten skal vise adresseoplysningerne for hver enkelt debitor.;
                                 ENU=View customer sales for a period, for example, to report sales activity to customs and tax authorities. You can choose to include only customers with total sales that exceed a minimum amount. You can also specify whether you want the report to show address details for each customer.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 119;
                      Image=Report }
      { 92      ;3   ;Action    ;
                      Name=ReportSalesStatistics;
                      CaptionML=[DAN=Salgsstatistik;
                                 ENU=Sales Statistics];
                      ToolTipML=[DAN=Vis debitorers samlede omkostninger, salg eller avance over tid, f.eks. med henblik pÜ at analysere indtjeningstendenser. Rapporten viser belõb for den oprindelige og regulerede kostpris, omsëtning, avance, fakturarabat, kontantrabat og avanceprocent i tre regulerbare perioder.;
                                 ENU=View customers' total costs, sales, and profits over time, for example, to analyze earnings trends. The report shows amounts for original and adjusted costs, sales, profits, invoice discounts, payment discounts, and profit percentage in three adjustable periods.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 112;
                      Image=Report }
      { 91      ;2   ;ActionGroup;
                      Name=FinanceReports;
                      CaptionML=[DAN=Finansrapporter;
                                 ENU=Finance Reports];
                      Image=Report }
      { 90      ;3   ;Action    ;
                      CaptionML=[DAN=Kontoudtog;
                                 ENU=Statement];
                      ToolTipML=[DAN=Vis en liste over debitors transaktioner i en bestemt periode, f.eks. for at sende udskriften til debitor i slutningen af en regnskabsperiode. Du kan vëlge at fÜ vist samtlige forfaldne saldi, uafhëngigt af den angivne periode, eller du kan vëlge at inkludere et aldersfordelingsinterval.;
                                 ENU=View a list of a customer's transactions for a selected period, for example, to send to the customer at the close of an accounting period. You can choose to have all overdue balances displayed regardless of the period specified, or you can choose to include an aging band.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 8810;
                      Image=Report }
      { 89      ;3   ;Action    ;
                      Name=ReportCustomerBalanceToDate;
                      CaptionML=[DAN=Debitor - saldo til dato;
                                 ENU=Customer - Balance to Date];
                      ToolTipML=[DAN=Vis en liste over debitorers betalingshistorik op til en bestemt dato. Du kan bruge rapporten til at udtrëkke oplysninger om din samlede salgsindkomst ved slutningen af en regnskabsperiode eller et regnskabsÜr.;
                                 ENU=View a list with customers' payment history up until a certain date. You can use the report to extract your total sales income at the close of an accounting period or fiscal year.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 121;
                      Image=Report }
      { 88      ;3   ;Action    ;
                      Name=ReportCustomerTrialBalance;
                      CaptionML=[DAN=Debitor - balance;
                                 ENU=Customer - Trial Balance];
                      ToolTipML=[DAN=Vis start- og slutsaldi for debitorer med poster i en bestemt periode. Rapporten kan bruges til at bekrëfte, at saldoen for en debitorbogfõringsgruppe svarer til saldoen pÜ den tilsvarende finanskonto pÜ en bestemt dato.;
                                 ENU=View the beginning and ending balance for customers with entries within a specified period. The report can be used to verify that the balance for a customer posting group is equal to the balance on the corresponding general ledger account on a certain date.];
                      ApplicationArea=#Suite;
                      RunObject=Report 129;
                      Image=Report }
      { 87      ;3   ;Action    ;
                      Name=ReportCustomerDetailTrial;
                      CaptionML=[DAN=Debitor - kontokort;
                                 ENU=Customer - Detail Trial Bal.];
                      ToolTipML=[DAN=Vis saldi for debitorer med saldi pÜ en bestemt dato. Rapporten kan f.eks. bruges i slutningen af en regnskabsperiode eller i forbindelse med revision.;
                                 ENU=View the balance for customers with balances on a specified date. The report can be used at the close of an accounting period, for example, or for an audit.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 104;
                      Image=Report }
      { 83      ;3   ;Action    ;
                      Name=ReportCustomerSummaryAging;
                      CaptionML=[DAN=Debitor - forfaldsoversigt;
                                 ENU=Customer - Summary Aging];
                      ToolTipML=[DAN=Vis, udskriv eller gem en oversigt over hver debitors samlede forfaldne betalinger, opdelt i tre tidsperioder. Rapporten kan bruges til at bestemme, hvornÜr der skal udstedes rykkere, til at vurdere en debitors kreditvërdighed eller til at udarbejde likviditetsanalyser.;
                                 ENU=View, print, or save a summary of each customer's total payments due, divided into three time periods. The report can be used to decide when to issue reminders, to evaluate a customer's creditworthiness, or to prepare liquidity analyses.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 105;
                      Image=Report }
      { 80      ;3   ;Action    ;
                      Name=ReportCustomerDetailedAging;
                      CaptionML=[DAN=Debitor - forfaldne debitorposter;
                                 ENU=Customer - Detailed Aging];
                      ToolTipML=[DAN=Vis, udskriv eller gem en detaljeret liste over hver debitors samlede forfaldne betalinger, opdelt i tre tidsperioder. Rapporten kan bruges til at bestemme, hvornÜr der skal udstedes rykkere, til at vurdere en debitors kreditvërdighed eller til at udarbejde likviditetsanalyser.;
                                 ENU=View, print, or save a detailed list of each customer's total payments due, divided into three time periods. The report can be used to decide when to issue reminders, to evaluate a customer's creditworthiness, or to prepare liquidity analyses.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 106;
                      Image=Report }
      { 74      ;3   ;Action    ;
                      Name=ReportAgedAccountsReceivable;
                      CaptionML=[DAN=Aldersfordelte tilgodehavender;
                                 ENU=Aged Accounts Receivable];
                      ToolTipML=[DAN=Vis en oversigt over, hvornÜr debitorers betalinger skal betales eller rykkes for, opdelt i fire perioder. Du skal angive den dato, som aldersfordelingen skal beregnes ud fra, og du skal angive den periode, som hver kolonne skal indeholde data for.;
                                 ENU=View an overview of when customer payments are due or overdue, divided into four periods. You must specify the date you want aging calculated from and the length of the period that each column will contain data for.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 120;
                      Image=Report }
      { 73      ;3   ;Action    ;
                      Name=ReportCustomerPaymentReceipt;
                      CaptionML=[DAN=Debitor - betalingskvittering;
                                 ENU=Customer - Payment Receipt];
                      ToolTipML=[DAN=Vis et bilag med de debitorposter, som en betaling er tildelt. Denne rapport kan anvendes som den betalingskvittering, du sender til debitor.;
                                 ENU=View a document showing which customer ledger entries that a payment has been applied to. This report can be used as a payment receipt that you send to the customer.];
                      ApplicationArea=#Suite;
                      RunObject=Report 211;
                      Image=Report }
      { 3       ;1   ;ActionGroup;
                      CaptionML=[DAN=Generelt;
                                 ENU=General] }
      { 1905562606;2 ;Action    ;
                      CaptionML=[DAN=Debitoroversigt;
                                 ENU=Customer List];
                      ToolTipML=[DAN=Vis diverse stamoplysninger, der er knyttet til debitoren, f.eks. debitorbogfõringsgruppe, rabatgruppe, rente- og betalingsoplysninger, sëlger, debitors basisvaluta, kreditmaksimum (i RV) og debitorens aktuelle saldo (i RV).;
                                 ENU=View various kinds of basic information for customers, such as customer posting group, discount group, finance charge and payment information, salesperson, the customer's default currency and credit limit (in LCY), and the customer's current balance (in LCY).];
                      ApplicationArea=#Advanced;
                      RunObject=Report 101;
                      Image=Report }
      { 1901007206;2 ;Action    ;
                      CaptionML=[DAN=Debitorjournal;
                                 ENU=Customer Register];
                      ToolTipML=[DAN=Vis bogfõrte debitorposter, der er inddelt i og sorteret efter hver journal. Ved hjëlp af et filter kan du vëlge prëcis de journalposter, du vil se. Hvis du har oprettet mange poster og ikke har angivet noget filter, vil der blive udskrevet en stor mëngde oplysninger.;
                                 ENU=View posted customer ledger entries divided into, and sorted according to, registers. By using a filter, you can select exactly the entries in the registers that you need to see. If you have created many entries and you do not set a filter, the report will print a large amount of information.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 103;
                      Image=Report }
      { 1907152806;2 ;Action    ;
                      CaptionML=[DAN=Debitor - top 10-liste;
                                 ENU=Customer - Top 10 List];
                      ToolTipML=[DAN=Vis de debitorer, der kõber mest, eller som skylder mest, i en bestemt periode. Kun de debitorer, der har kõb i lõbet af perioden eller en saldo ved periodens afslutning, vil blive vist i rapporten.;
                                 ENU=View which customers purchase the most or owe the most in a selected period. Only customers that have either purchases during the period or a balance at the end of the period will be included.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 111;
                      Image=Report }
      { 5       ;1   ;ActionGroup;
                      CaptionML=[DAN=Salg;
                                 ENU=Sales];
                      Image=Sales }
      { 1905727106;2 ;Action    ;
                      CaptionML=[DAN=Debitor - ordreoversigt;
                                 ENU=Customer - Order Summary];
                      ToolTipML=[DAN=Vis ordrebeholdningen (den ikke-leverede beholdning) pr. debitor i tre perioder Ö 30 dage med udgangspunkt i en valgt dato. Der vises desuden kolonner med ordrer, der skal leveres fõr og efter de tre perioder, og en kolonne med ordrebeholdningen pr. debitor i alt. Rapporten kan f.eks. bruges til at analysere virksomhedens forventede salgsomsëtning.;
                                 ENU=View the order detail (the quantity not yet shipped) for each customer in three periods of 30 days each, starting from a selected date. There are also columns with orders to be shipped before and after the three periods and a column with the total order detail for each customer. The report can be used to analyze a company's expected sales volume.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 107;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1900172506;2 ;Action    ;
                      CaptionML=[DAN=Debitor - ordrebeholdning;
                                 ENU=Customer - Order Detail];
                      ToolTipML=[DAN=Vis en oversigt over ordrer fordelt efter debitor. Ordrebelõbet lëgges sammen for hver debitor og for hele oversigten. Rapporten kan f.eks. bruges til at give et overblik over salget pÜ kort sigt eller til analyse af eventuelle leveringsproblemer.;
                                 ENU=View a list of orders divided by customer. The order amounts are totaled for each customer and for the entire list. The report can be used, for example, to obtain an overview of sales over the short term or to analyze possible shipment problems.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 108;
                      Image=Report }
      { 1906073506;2 ;Action    ;
                      CaptionML=[DAN=Debitor - salgsoversigt;
                                 ENU=Customer - Sales List];
                      ToolTipML=[DAN=Vis debitorsalg for en given periode, f.eks. for at rapportere om salgsaktivitet til SKAT. Du kan vëlge kun at medtage debitorer med et samlet salg, der overstiger et bestemt belõb. Du kan ogsÜ angive, om rapporten skal vise adresseoplysningerne for hver enkelt debitor.;
                                 ENU=View customer sales for a period, for example, to report sales activity to customs and tax authorities. You can choose to include only customers with total sales that exceed a minimum amount. You can also specify whether you want the report to show address details for each customer.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 119;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1904190506;2 ;Action    ;
                      CaptionML=[DAN=Salgsstatistik;
                                 ENU=Sales Statistics];
                      ToolTipML=[DAN=Vis debitorers samlede omkostninger, salg eller avance over tid, f.eks. med henblik pÜ at analysere indtjeningstendenser. Rapporten viser belõb for den oprindelige og regulerede kostpris, omsëtning, avance, fakturarabat, kontantrabat og avanceprocent i tre regulerbare perioder.;
                                 ENU=View customers' total costs, sales, and profits over time, for example, to analyze earnings trends. The report shows amounts for original and adjusted costs, sales, profits, invoice discounts, payment discounts, and profit percentage in three adjustable periods.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 112;
                      Image=Report }
      { 1900760706;2 ;Action    ;
                      CaptionML=[DAN=Kunde/varestatistik;
                                 ENU=Customer/Item Sales];
                      ToolTipML=[DAN=Vis en oversigt over varesalg i den valgte periode for hver debitor. Rapporten viser oplysninger om antal, salgsbelõb, avance og eventuel rabat. Du kan f.eks. bruge rapporten til at analysere debitorgrupper.;
                                 ENU=View a list of item sales for each customer during a selected time period. The report contains information on quantity, sales amount, profit, and possible discounts. It can be used, for example, to analyze a company's customer groups.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 113;
                      Image=Report }
      { 7       ;1   ;ActionGroup;
                      CaptionML=[DAN=Finans;
                                 ENU=Finance];
                      Image=Report }
      { 1906871306;2 ;Action    ;
                      CaptionML=[DAN=Debitor - kontokort;
                                 ENU=Customer - Detail Trial Bal.];
                      ToolTipML=[DAN=Vis saldi for debitorer med saldi pÜ en bestemt dato. Rapporten kan f.eks. bruges i slutningen af en regnskabsperiode eller i forbindelse med revision.;
                                 ENU=View the balance for customers with balances on a specified date. The report can be used at the close of an accounting period, for example, or for an audit.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 104;
                      Image=Report }
      { 1907944606;2 ;Action    ;
                      CaptionML=[DAN=Debitor - forfaldsoversigt;
                                 ENU=Customer - Summary Aging];
                      ToolTipML=[DAN=Vis, udskriv eller gem en oversigt over hver debitors samlede forfaldne betalinger, opdelt i tre tidsperioder. Rapporten kan bruges til at bestemme, hvornÜr der skal udstedes rykkere, til at vurdere en debitors kreditvërdighed eller til at udarbejde likviditetsanalyser.;
                                 ENU=View, print, or save a summary of each customer's total payments due, divided into three time periods. The report can be used to decide when to issue reminders, to evaluate a customer's creditworthiness, or to prepare liquidity analyses.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 105;
                      Image=Report }
      { 1906813206;2 ;Action    ;
                      CaptionML=[DAN=Forfaldne debitorposter;
                                 ENU=Customer Detailed Aging];
                      ToolTipML=[DAN=Vis en detaljeret liste over hver debitors samlede forfaldne betalinger, opdelt i tre tidsperioder. Rapporten kan bruges til at bestemme, hvornÜr der skal udstedes rykkere, til at vurdere en debitors kreditvërdighed eller til at udarbejde likviditetsanalyser.;
                                 ENU=View a detailed list of each customer's total payments due, divided into three time periods. The report can be used to decide when to issue reminders, to evaluate a customer's creditworthiness, or to prepare liquidity analyses.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 106;
                      Image=Report }
      { 1055    ;2   ;Action    ;
                      Name=Statement;
                      CaptionML=[DAN=Kontoudtog;
                                 ENU=Statement];
                      ToolTipML=[DAN=Vis en liste over en debitors transaktioner i en bestemt periode, f.eks. for at sende udskriften til debitor i slutningen af en regnskabsperiode. Du kan vëlge at fÜ vist samtlige forfaldne saldi, uafhëngigt af den angivne periode, eller du kan vëlge at inkludere et aldersfordelingsinterval.;
                                 ENU=View a list of a customer's transactions for a selected period, for example, to send to the customer at the close of an accounting period. You can choose to have all overdue balances displayed regardless of the period specified, or you can choose to include an aging band.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 8810;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1903839806;2 ;Action    ;
                      CaptionML=[DAN=Rykkermeddelelse;
                                 ENU=Reminder];
                      ToolTipML=[DAN=Opret en ny rykker til debitoren.;
                                 ENU=Create a new reminder for the customer.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 117;
                      Image=Reminder }
      { 1900711606;2 ;Action    ;
                      CaptionML=[DAN=Aldersfordelte tilgodehavender;
                                 ENU=Aged Accounts Receivable];
                      ToolTipML=[DAN=Vis en oversigt over, hvornÜr debitorers betalinger skal betales eller rykkes for, opdelt i fire perioder. Du skal angive den dato, som aldersfordelingen skal beregnes ud fra, og du skal angive den periode, som hver kolonne skal indeholde data for.;
                                 ENU=View an overview of when customer payments are due or overdue, divided into four periods. You must specify the date you want aging calculated from and the length of the period that each column will contain data for.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 120;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1902299006;2 ;Action    ;
                      CaptionML=[DAN=Debitor - saldo til dato;
                                 ENU=Customer - Balance to Date];
                      ToolTipML=[DAN=Vis en liste over debitorers betalingshistorik op til en bestemt dato. Du kan bruge rapporten til at udtrëkke oplysninger om din samlede salgsindkomst ved slutningen af en regnskabsperiode eller et regnskabsÜr.;
                                 ENU=View a list with customers' payment history up until a certain date. You can use the report to extract your total sales income at the close of an accounting period or fiscal year.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 121;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1906359306;2 ;Action    ;
                      CaptionML=[DAN=Debitor - balance;
                                 ENU=Customer - Trial Balance];
                      ToolTipML=[DAN=Vis start- og slutsaldi for debitorer med poster i en bestemt periode. Rapporten kan bruges til at bekrëfte, at saldoen for en debitorbogfõringsgruppe svarer til saldoen pÜ den tilsvarende finanskonto pÜ en bestemt dato.;
                                 ENU=View the beginning and ending balance for customers with entries within a specified period. The report can be used to verify that the balance for a customer posting group is equal to the balance on the corresponding general ledger account on a certain date.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 129;
                      Image=Report }
      { 1904039606;2 ;Action    ;
                      CaptionML=[DAN=Debitor - betalingskvittering;
                                 ENU=Customer - Payment Receipt];
                      ToolTipML=[DAN=Vis et bilag med de debitorposter, som en betaling er tildelt. Denne rapport kan anvendes som den betalingskvittering, du sender til debitor.;
                                 ENU=View a document showing which customer ledger entries that a payment has been applied to. This report can be used as a payment receipt that you send to the customer.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 211;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#All;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitorens navn. Navnet vises pÜ alle debitorens salgsbilag. Du kan bruge op til 50 tegn (bÜde tal og bogstaver).;
                           ENU=Specifies the customer's name. This name will appear on all sales documents for the customer. You can enter a maximum of 50 characters, both numbers and letters.];
                ApplicationArea=#All;
                SourceExpr=Name }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode for ansvarscenteret (f.eks. et distributionscenter), som er tildelt den involverede bruger, virksomhed, debitor eller kreditor.;
                           ENU=Specifies the code of the responsibility center, such as a distribution hub, that is associated with the involved user, company, customer, or vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Responsibility Center" }

    { 43  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, fra hvilken lokation salg til debitoren som standard skal behandles.;
                           ENU=Specifies from which location sales to this customer will be processed by default.];
                ApplicationArea=#Location;
                SourceExpr="Location Code" }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummer.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Post Code";
                Visible=FALSE }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressens land/omrÜde.;
                           ENU=Specifies the country/region of the address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Country/Region Code";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitorens telefonnummer.;
                           ENU=Specifies the customer's telephone number.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Phone No." }

    { 79  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitorens koncerninterne partnerkode.;
                           ENU=Specifies the customer's intercompany partner code.];
                ApplicationArea=#Intercompany;
                SourceExpr="IC Partner Code";
                Visible=FALSE }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ en fast kontakt hos debitoren.;
                           ENU=Specifies the name of the person you regularly contact when you do business with this customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Contact }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for den sëlger, der normalt hÜndterer denne debitorkonto.;
                           ENU=Specifies a code for the salesperson who normally handles this customer's account.];
                ApplicationArea=#Suite;
                SourceExpr="Salesperson Code";
                Visible=FALSE }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitorens markedstype, hvortil der skal knyttes forretningstransaktioner.;
                           ENU=Specifies the customer's market type to link business transactions to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Customer Posting Group";
                Visible=FALSE }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitorens handelstype for at knytte transaktioner, der er foretaget for denne debitor, til den relevante finanskonto i overensstemmelse med den generelle bogfõringsopsëtning.;
                           ENU=Specifies the customer's trade type to link transactions made for this customer with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Gen. Bus. Posting Group";
                Visible=FALSE }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede debitors eller kreditors momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogfõringsopsëtning.;
                           ENU=Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Bus. Posting Group";
                Visible=FALSE }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den debitorprisgruppekode, du kan bruge til at oprette salgspriser i vinduet Salgspriser.;
                           ENU=Specifies the customer price group code, which you can use to set up special sales prices in the Sales Prices window.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Customer Price Group";
                Visible=FALSE }

    { 72  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den debitorrabatgruppekode, du kan bruge som kriterie for at oprette specialrabatter i vinduet Salgslinjerabatter.;
                           ENU=Specifies the customer discount group code, which you can use as a criterion to set up special discounts in the Sales Line Discounts window.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Customer Disc. Group";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en formel, der beregner betalingens forfaldsdato, kontantrabatdato og kontantrabatbelõb.;
                           ENU=Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Terms Code";
                Visible=FALSE }

    { 61  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan rykkere om forfaldne betalinger hÜndteres for denne debitor.;
                           ENU=Specifies how reminders about late payments are handled for this customer.];
                ApplicationArea=#Advanced;
                SourceExpr="Reminder Terms Code";
                Visible=FALSE }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for de involverede renter i tilfëlde af sen betaling.;
                           ENU=Specifies the code for the involved finance charges in case of late payment.];
                ApplicationArea=#Advanced;
                SourceExpr="Fin. Charge Terms Code";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver standardvalutakoden for debitoren.;
                           ENU=Specifies the default currency for the customer.];
                ApplicationArea=#Suite;
                SourceExpr="Currency Code";
                Visible=FALSE }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det sprog, der bruges ved oversëttelse af angivet tekst i bilag til udenlandske forretningspartnere, f.eks. en beskrivelse af varen pÜ en ordrebekrëftelse.;
                           ENU=Specifies the language that is used when translating specified text on documents to foreign business partner, such as an item description on an order confirmation.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Language Code";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et alternativt navn, du kan bruge til at sõge efter den õnskede record, hvis du ikke kan huske vërdien i feltet Navn.;
                           ENU=Specifies an alternate name that you can use to search for the record in question when you cannot remember the value in the Name field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Search Name";
                Visible=FALSE }

    { 1102601000;2;Field  ;
                ToolTipML=[DAN=Angiver det maksimale belõb, som du tillader, at debitoren overskrider betalingssaldoen med, fõr der udstedes advarsler.;
                           ENU=Specifies the maximum amount you allow the customer to exceed the payment balance before warnings are issued.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Credit Limit (LCY)";
                Visible=FALSE }

    { 1102601002;2;Field  ;
                ToolTipML=[DAN=Angiver, at den relaterede record er forhindret i kunne bogfõres under transaktioner - eksempelvis en debitor, som er erklëret insolvent, eller en vare, som er sat i karantëne.;
                           ENU=Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Blocked;
                Visible=FALSE }

    { 200 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om adgangen til data skal begrënses for dataemnet i den daglige drift. Dette er eksempelvis nyttigt, nÜr du vil beskytte data mod ëndringer, mens det kontrolleres, om de indeholder personlige oplysninger.;
                           ENU=Specifies whether to limit access to data for the data subject during daily operations. This is useful, for example, when protecting data from changes while it is under privacy review.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Privacy Blocked";
                Visible=FALSE }

    { 1102601004;2;Field  ;
                ToolTipML=[DAN=Angiver, hvornÜr debitorkortet sidst blev ëndret.;
                           ENU=Specifies when the customer card was last modified.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Last Date Modified";
                Visible=FALSE }

    { 1102601006;2;Field  ;
                ToolTipML=[DAN=Angiver, hvordan du kan udligne betalinger pÜ poster for denne debitor.;
                           ENU=Specifies how to apply payments to entries for this customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Application Method";
                Visible=FALSE }

    { 1102601008;2;Field  ;
                ToolTipML=[DAN=Angiver, om flere ordrer, der er leveret til debitoren, kan fremgÜ af samme salgsfaktura.;
                           ENU=Specifies if several orders delivered to the customer can appear on the same sales invoice.];
                ApplicationArea=#Advanced;
                SourceExpr="Combine Shipments";
                Visible=FALSE }

    { 1102601010;2;Field  ;
                ToolTipML=[DAN=Angiver, om varer aldrig, automatisk (altid) eller eventuelt kan reserveres til denne debitor. Valgfri betyder, at du manuelt skal reservere varer til denne debitor.;
                           ENU=Specifies whether items will never, automatically (Always), or optionally be reserved for this customer. Optional means that you must manually reserve items for this customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Reserve;
                Visible=FALSE }

    { 1102601012;2;Field  ;
                ToolTipML=[DAN=Angiver, om debitoren accepterer dellevering af ordrer.;
                           ENU=Specifies if the customer accepts partial shipment of orders.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Shipping Advice";
                Visible=FALSE }

    { 1102601014;2;Field  ;
                ToolTipML=[DAN=Angiver koden for den speditõr, som transporterer varerne.;
                           ENU=Specifies the code for the shipping agent who is transporting the items.];
                ApplicationArea=#Suite;
                SourceExpr="Shipping Agent Code";
                Visible=FALSE }

    { 1102601016;2;Field  ;
                ToolTipML=[DAN=Angiver en redigerbar kalender for leveringsplanlëgning, der indeholder debitorens arbejdsdage og fridage.;
                           ENU=Specifies a customizable calendar for shipment planning that holds the customer's working days and holidays.];
                ApplicationArea=#Advanced;
                SourceExpr="Base Calendar Code";
                Visible=FALSE }

    { 62  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det betalingsbelõb, som debitoren skylder for afsluttede salg. Vërdien kaldes ogsÜ debitorsaldo.;
                           ENU=Specifies the payment amount that the customer owes for completed sales. This value is also known as the customer's balance.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Balance (LCY)";
                OnDrillDown=BEGIN
                              OpenCustomerLedgerEntries(FALSE);
                            END;
                             }

    { 59  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver betalinger fra debitoren, der er forfaldne pr. dags dato.;
                           ENU=Specifies payments from the customer that are overdue per today's date.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Balance Due (LCY)";
                OnDrillDown=BEGIN
                              OpenCustomerLedgerEntries(TRUE);
                            END;
                             }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede nettobelõb i RV, som debitoren har kõbt for.;
                           ENU=Specifies the total net amount of sales to the customer in LCY.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sales (LCY)" }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 861 ;1   ;Part      ;
                Name=Power BI Report FactBox;
                CaptionML=[DAN=Power BI-rapporter;
                           ENU=Power BI Reports];
                ApplicationArea=#Basic,#Suite;
                PagePartID=Page6306;
                Visible=PowerBIVisible;
                PartType=Page }

    { 99  ;1   ;Part      ;
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

    { 33  ;1   ;Part      ;
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

    { 1900316107;1;Part   ;
                Name=CustomerDetailsFactBox;
                ApplicationArea=#Basic,#Suite;
                SubPageLink=No.=FIELD(No.),
                            Currency Filter=FIELD(Currency Filter),
                            Date Filter=FIELD(Date Filter),
                            Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                            Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
                PagePartID=Page9084;
                Visible=FALSE;
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
      PowerBIUserConfiguration@1011 : Record 6304;
      ApprovalsMgmt@1010 : Codeunit 1535;
      SetPowerBIUserConfig@1000 : Codeunit 6305;
      SocialListeningSetupVisible@1009 : Boolean;
      SocialListeningVisible@1008 : Boolean;
      CRMIntegrationEnabled@1007 : Boolean;
      CRMIsCoupledToRecord@1006 : Boolean;
      OpenApprovalEntriesExist@1005 : Boolean;
      CanCancelApprovalForRecord@1004 : Boolean;
      EnabledApprovalWorkflowsExist@1003 : Boolean;
      PowerBIVisible@1002 : Boolean;
      CanRequestApprovalForFlow@1013 : Boolean;
      CanCancelApprovalForFlow@1014 : Boolean;
      EventFilter@1001 : Text;
      CaptionTxt@1012 : Text;

    [External]
    PROCEDURE GetSelectionFilter@2() : Text;
    VAR
      Cust@1001 : Record 18;
      SelectionFilterManagement@1002 : Codeunit 46;
    BEGIN
      CurrPage.SETSELECTIONFILTER(Cust);
      EXIT(SelectionFilterManagement.GetSelectionFilterForCustomer(Cust));
    END;

    [External]
    PROCEDURE SetSelection@1(VAR Cust@1000 : Record 18);
    BEGIN
      CurrPage.SETSELECTIONFILTER(Cust);
    END;

    LOCAL PROCEDURE SetSocialListeningFactboxVisibility@3();
    VAR
      SocialListeningMgt@1000 : Codeunit 871;
    BEGIN
      SocialListeningMgt.GetCustFactboxVisibility(Rec,SocialListeningSetupVisible,SocialListeningVisible);
    END;

    LOCAL PROCEDURE SetCustomerNoVisibilityOnFactBoxes@5();
    BEGIN
      CurrPage.SalesHistSelltoFactBox.PAGE.SetCustomerNoVisibility(FALSE);
      CurrPage.SalesHistBilltoFactBox.PAGE.SetCustomerNoVisibility(FALSE);
      CurrPage.CustomerDetailsFactBox.PAGE.SetCustomerNoVisibility(FALSE);
      CurrPage.CustomerStatisticsFactBox.PAGE.SetCustomerNoVisibility(FALSE);
    END;

    LOCAL PROCEDURE SetWorkflowManagementEnabledState@4();
    VAR
      WorkflowManagement@1001 : Codeunit 1501;
      WorkflowEventHandling@1000 : Codeunit 1520;
    BEGIN
      EventFilter := WorkflowEventHandling.RunWorkflowOnSendCustomerForApprovalCode + '|' +
        WorkflowEventHandling.RunWorkflowOnCustomerChangedCode;

      EnabledApprovalWorkflowsExist := WorkflowManagement.EnabledWorkflowExist(DATABASE::Customer,EventFilter);
    END;

    [Integration]
    PROCEDURE SetCaption@17(VAR InText@1000 : Text);
    BEGIN
    END;

    BEGIN
    END.
  }
}

