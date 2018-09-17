OBJECT Page 26 Vendor Card
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Kreditorkort;
               ENU=Vendor Card];
    SourceTable=Table23;
    PageType=Card;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,RapportÇr,Godkend,Anmod om godkendelse,Nyt bilag,Naviger,IndgÜende bilag;
                                ENU=New,Process,Report,Approve,Request Approval,New Document,Navigate,Incoming Documents];
    OnInit=BEGIN
             SetVendorNoVisibilityOnFactBoxes;

             ContactEditable := TRUE;
           END;

    OnOpenPage=VAR
                 PermissionManager@1000 : Codeunit 9002;
               BEGIN
                 ActivateFields;
                 IsOfficeAddin := OfficeMgt.IsAvailable;
                 SetNoFieldVisible;
                 IsSaaS := PermissionManager.SoftwareAsAService;
               END;

    OnAfterGetRecord=BEGIN
                       ActivateFields;
                     END;

    OnNewRecord=VAR
                  DocumentNoVisibility@1003 : Codeunit 1400;
                BEGIN
                  IF GUIALLOWED THEN
                    IF "No." = '' THEN
                      IF DocumentNoVisibility.VendorNoSeriesIsDefault THEN
                        NewMode := TRUE;
                END;

    OnAfterGetCurrRecord=BEGIN
                           CreateVendorFromTemplate;
                           ActivateFields;
                           OpenApprovalEntriesExistCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RECORDID);
                           OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);
                           ShowWorkflowStatus := CurrPage.WorkflowStatus.PAGE.SetFilterOnWorkflowRecord(RECORDID);
                           CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RECORDID);
                           WorkflowWebhookManagement.GetCanRequestAndCanCancel(RECORDID,CanRequestApprovalForFlow,CanCancelApprovalForFlow);

                           IF "No." <> '' THEN
                             CurrPage.AgedAccPayableChart.PAGE.UpdateChartForVendor("No.");
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 64      ;1   ;ActionGroup;
                      CaptionML=[DAN=Kre&ditor;
                                 ENU=Ven&dor];
                      Image=Vendor }
      { 184     ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omrÜde, projekt eller afdeling, som du kan tildele til salgs- og kõbsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      RunObject=Page 540;
                      RunPageLink=Table ID=CONST(23),
                                  No.=FIELD(No.);
                      Image=Dimensions }
      { 87      ;2   ;Action    ;
                      CaptionML=[DAN=Bankkonti;
                                 ENU=Bank Accounts];
                      ToolTipML=[DAN=Se eller opret dine kreditorers bankkonti. Du kan oprette et ubegrënset antal bankkonti til hver kreditor.;
                                 ENU=View or set up the vendor's bank accounts. You can set up any number of bank accounts for each vendor.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 426;
                      RunPageLink=Vendor No.=FIELD(No.);
                      Image=BankAccount }
      { 14      ;2   ;Action    ;
                      Name=ContactBtn;
                      AccessByPermission=TableData 5050=R;
                      CaptionML=[DAN=Ko&ntakt;
                                 ENU=C&ontact];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om kontaktpersonen hos kreditoren.;
                                 ENU=View or edit detailed information about the contact person at the vendor.];
                      ApplicationArea=#Basic,#Suite;
                      PromotedIsBig=Yes;
                      Image=ContactPerson;
                      PromotedCategory=Category7;
                      OnAction=BEGIN
                                 ShowContact;
                               END;
                                }
      { 54      ;2   ;Action    ;
                      Name=OrderAddresses;
                      CaptionML=[DAN=B&estillingsadresser;
                                 ENU=Order &Addresses];
                      ToolTipML=[DAN=Se en liste over alternative bestillingsadresser for kreditoren.;
                                 ENU=View a list of alternate order addresses for the vendor.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 369;
                      RunPageLink=Vendor No.=FIELD(No.);
                      Image=Addresses }
      { 68      ;2   ;Action    ;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 124;
                      RunPageLink=Table Name=CONST(Vendor),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 76      ;2   ;Action    ;
                      Name=ApprovalEntries;
                      AccessByPermission=TableData 454=R;
                      CaptionML=[DAN=Godkendelser;
                                 ENU=Approvals];
                      ToolTipML=[DAN=Se en liste over records, der afventer godkendelse, Du kan f.eks. se, hvem der har anmodet om godkendelse af recorden, hvornÜr den blev sendt, og hvornÜr den skal godkendes.;
                                 ENU=View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Image=Approvals;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 ApprovalsMgmt.OpenApprovalEntriesPage(RECORDID);
                               END;
                                }
      { 84      ;2   ;Action    ;
                      CaptionML=[DAN=Varereferencer;
                                 ENU=Cross References];
                      ToolTipML=[DAN=Konfigurer en debitors eller kreditors egen identifikation af den valgte vare. Krydshenvisninger til debitorens varenummer betyder, at debitorens varenummer automatisk vises i salgsbilag i stedet for det nummer, du anvender.;
                                 ENU=Set up a customer's or vendor's own identification of the selected item. Cross-references to the customer's item number means that the item number is automatically shown on sales documents instead of the number that you use.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 5723;
                      RunPageView=SORTING(Cross-Reference Type,Cross-Reference Type No.);
                      RunPageLink=Cross-Reference Type=CONST(Vendor),
                                  Cross-Reference Type No.=FIELD(No.);
                      Image=Change }
      { 225     ;2   ;Action    ;
                      Name=VendorReportSelections;
                      CaptionML=[DAN=Dokumentlayouts;
                                 ENU=Document Layouts];
                      ToolTipML=[DAN=Opret et layout for forskellige typer dokumenter, f.eks. fakturaer, tilbud og kreditnotaer.;
                                 ENU=Set up a layout for different types of documents such as invoices, quotes, and credit memos.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Quote;
                      OnAction=VAR
                                 CustomReportSelection@1001 : Record 9657;
                               BEGIN
                                 CustomReportSelection.SETRANGE("Source Type",DATABASE::Vendor);
                                 CustomReportSelection.SETRANGE("Source No.","No.");
                                 PAGE.RUNMODAL(PAGE::"Vendor Report Selections",CustomReportSelection);
                               END;
                                }
      { 71      ;1   ;ActionGroup;
                      CaptionML=[DAN=Kõ&b;
                                 ENU=&Purchases];
                      Image=Purchasing }
      { 118     ;2   ;Action    ;
                      CaptionML=[DAN=Varer;
                                 ENU=Items];
                      ToolTipML=[DAN=èbn listen over varer, som du handler med.;
                                 ENU=Open the list of items that you trade in.];
                      ApplicationArea=#Planning;
                      RunObject=Page 297;
                      RunPageView=SORTING(Vendor No.,Item No.);
                      RunPageLink=Vendor No.=FIELD(No.);
                      Image=Item }
      { 73      ;2   ;Action    ;
                      CaptionML=[DAN=Fakturara&batter;
                                 ENU=Invoice &Discounts];
                      ToolTipML=[DAN=Angiv forskellige rabatter, som kan tilfõjes fakturaer til debitor. Der gives automatisk en fakturarabat til debitor, nÜr det samlede fakturabelõb overstiger et vist belõb.;
                                 ENU=Set up different discounts that are applied to invoices for the customer. An invoice discount is automatically granted to the customer when the total on a sales invoice exceeds a certain amount.];
                      ApplicationArea=#Suite;
                      RunObject=Page 28;
                      RunPageLink=Code=FIELD(Invoice Disc. Code);
                      Image=CalculateInvoiceDiscount }
      { 72      ;2   ;Action    ;
                      CaptionML=[DAN=Priser;
                                 ENU=Prices];
                      ToolTipML=[DAN=Vis eller angiv forskellige priser for de varer, du kõber hos kreditoren. En varepris anfõres automatisk pÜ fakturalinjer, nÜr de specificerede kriterier er blevet opfyldt, f.eks. kreditor, mëngde eller slutdato.;
                                 ENU=View or set up different prices for items that you buy from the vendor. An item price is automatically granted on invoice lines when the specified criteria are met, such as vendor, quantity, or ending date.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 7012;
                      RunPageView=SORTING(Vendor No.);
                      RunPageLink=Vendor No.=FIELD(No.);
                      Image=Price }
      { 116     ;2   ;Action    ;
                      CaptionML=[DAN=Linjerabat;
                                 ENU=Line Discounts];
                      ToolTipML=[DAN=Vis eller angiv forskellige rabatter for de varer, du kõber hos kreditoren. En varerabat anfõres automatisk pÜ fakturalinjer, nÜr de specificerede kriterier er blevet opfyldt, f.eks. kreditor, antal eller slutdato.;
                                 ENU=View or set up different discounts for items that you buy from the vendor. An item discount is automatically granted on invoice lines when the specified criteria are met, such as vendor, quantity, or ending date.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 7014;
                      RunPageView=SORTING(Vendor No.);
                      RunPageLink=Vendor No.=FIELD(No.);
                      Image=LineDiscount }
      { 129     ;2   ;Action    ;
                      CaptionML=[DAN=Forudb&etalingsprocenter;
                                 ENU=Prepa&yment Percentages];
                      ToolTipML=[DAN="Vis eller rediger de procentdele af prisen, der kan betales som forudbetaling. ";
                                 ENU="View or edit the percentages of the price that can be paid as a prepayment. "];
                      ApplicationArea=#Prepayments;
                      RunObject=Page 665;
                      RunPageView=SORTING(Vendor No.);
                      RunPageLink=Vendor No.=FIELD(No.);
                      Image=PrepaymentPercentages }
      { 123     ;2   ;Action    ;
                      CaptionML=[DAN=S&td.kred.kõbskoder;
                                 ENU=S&td. Vend. Purchase Codes];
                      ToolTipML=[DAN=Vis eller rediger tilbagevendende kõbslinjer hos kreditoren.;
                                 ENU=View or edit recurring purchase lines for the vendor.];
                      ApplicationArea=#Suite;
                      RunObject=Page 178;
                      RunPageLink=Vendor No.=FIELD(No.);
                      Image=CodesList }
      { 78      ;2   ;Action    ;
                      CaptionML=[DAN=Koblingstekst til konto;
                                 ENU=Mapping Text to Account];
                      ToolTipML=[DAN=Side for tekst til konto-tilknytning;
                                 ENU=Page mapping text to account];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 1254;
                      RunPageLink=Vendor No.=FIELD(No.);
                      Image=MapAccounts }
      { 5       ;1   ;ActionGroup;
                      CaptionML=[DAN=Dokumenter;
                                 ENU=Documents];
                      Image=Administration }
      { 74      ;2   ;Action    ;
                      CaptionML=[DAN=Rekvisition;
                                 ENU=Quotes];
                      ToolTipML=[DAN=Vi en oversigt over igangvërende salgstilbud.;
                                 ENU=View a list of ongoing sales quotes.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9306;
                      RunPageView=SORTING(Document Type,Buy-from Vendor No.);
                      RunPageLink=Buy-from Vendor No.=FIELD(No.);
                      Image=Quote }
      { 75      ;2   ;Action    ;
                      CaptionML=[DAN=Ordrer;
                                 ENU=Orders];
                      ToolTipML=[DAN=Vis en liste med igangvërende kõbsordrer for kreditoren.;
                                 ENU=View a list of ongoing purchase orders for the vendor.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9307;
                      RunPageView=SORTING(Document Type,Buy-from Vendor No.);
                      RunPageLink=Buy-from Vendor No.=FIELD(No.);
                      Image=Document }
      { 99      ;2   ;Action    ;
                      CaptionML=[DAN=Returvareordrer;
                                 ENU=Return Orders];
                      ToolTipML=[DAN=èbn oversigten over igangvërende returordrer.;
                                 ENU=Open the list of ongoing return orders.];
                      ApplicationArea=#PurchReturnOrder;
                      RunObject=Page 9311;
                      RunPageView=SORTING(Document Type,Buy-from Vendor No.);
                      RunPageLink=Buy-from Vendor No.=FIELD(No.);
                      Image=ReturnOrder }
      { 21      ;2   ;Action    ;
                      CaptionML=[DAN=Rammeordrer;
                                 ENU=Blanket Orders];
                      ToolTipML=[DAN=èbn oversigten over igangvërende rammeordrer.;
                                 ENU=Open the list of ongoing blanket orders.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9310;
                      RunPageView=SORTING(Document Type,Buy-from Vendor No.);
                      RunPageLink=Buy-from Vendor No.=FIELD(No.);
                      Image=BlanketOrder }
      { 7       ;1   ;ActionGroup;
                      CaptionML=[DAN=Oversigt;
                                 ENU=History];
                      Image=History }
      { 70      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=Post&er;
                                 ENU=Ledger E&ntries];
                      ToolTipML=[DAN=Se historikken over transaktioner, der er bogfõrt for den valgte record.;
                                 ENU=View the history of transactions that have been posted for the selected record.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 29;
                      RunPageView=SORTING(Vendor No.)
                                  ORDER(Descending);
                      RunPageLink=Vendor No.=FIELD(No.);
                      Promoted=No;
                      Image=VendorLedger;
                      PromotedCategory=Process }
      { 66      ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=FÜ vist statistiske oplysninger om recorden, f.eks. vërdien af bogfõrte poster.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 152;
                      RunPageLink=No.=FIELD(No.),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 69      ;2   ;Action    ;
                      CaptionML=[DAN=Kõb;
                                 ENU=Purchases];
                      ToolTipML=[DAN=Viser en oversigt over kreditorposter. Du kan vëlge tidsintervallet i feltet Vis efter. Kolonnen Periodestart til venstre viser datoer efter det valgte tidsinterval.;
                                 ENU=Shows a summary of vendor ledger entries. You select the time interval in the View by field. The Period column on the left contains a series of dates that are determined by the time interval you have selected.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 156;
                      RunPageLink=No.=FIELD(No.),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
                      Image=Purchase }
      { 67      ;2   ;Action    ;
                      CaptionML=[DAN=Poststatistik;
                                 ENU=Entry Statistics];
                      ToolTipML=[DAN=Vis poststatistik for den pÜgëldende record.;
                                 ENU=View entry statistics for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 303;
                      RunPageLink=No.=FIELD(No.),
                                  Date Filter=FIELD(Date Filter),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
                      Image=EntryStatistics }
      { 20      ;2   ;Action    ;
                      CaptionML=[DAN=Va&lutastatistik;
                                 ENU=Statistics by C&urrencies];
                      ToolTipML=[DAN=Vis statistik for kreditorer, der bruger forskellige valutaer.;
                                 ENU=View statistics for vendors that use multiple currencies.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 487;
                      RunPageLink=Vendor Filter=FIELD(No.),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
                                  Date Filter=FIELD(Date Filter);
                      Image=Currencies }
      { 6500    ;2   ;Action    ;
                      CaptionML=[DAN=Vare&sporingsposter;
                                 ENU=Item &Tracking Entries];
                      ToolTipML=[DAN=Vis serie- eller lotnumre, der er tildelt til varer.;
                                 ENU=View serial or lot numbers that are assigned to items.];
                      ApplicationArea=#ItemTracking;
                      Image=ItemTrackingLedger;
                      OnAction=VAR
                                 ItemTrackingDocMgt@1000 : Codeunit 6503;
                               BEGIN
                                 ItemTrackingDocMgt.ShowItemTrackingForMasterData(2,"No.",'','','','','');
                               END;
                                }
      { 1900000005;0 ;ActionContainer;
                      ActionContainerType=NewDocumentItems }
      { 1903213705;1 ;Action    ;
                      Name=NewBlanketPurchaseOrder;
                      CaptionML=[DAN=Rammekõbsordre;
                                 ENU=Blanket Purchase Order];
                      ToolTipML=[DAN=Opret en ny rammekõbsordre for kreditoren.;
                                 ENU=Create a new blanket purchase order for the vendor.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 509;
                      RunPageLink=Buy-from Vendor No.=FIELD(No.);
                      Promoted=No;
                      Image=BlanketOrder;
                      PromotedCategory=Category6;
                      RunPageMode=Create }
      { 1901469405;1 ;Action    ;
                      Name=NewPurchaseQuote;
                      CaptionML=[DAN=Kõbsrekvisition;
                                 ENU=Purchase Quote];
                      ToolTipML=[DAN=Opret et nyt kõbstilbud for kreditoren.;
                                 ENU=Create a new purchase quote for the vendor.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 49;
                      RunPageLink=Buy-from Vendor No.=FIELD(No.);
                      Promoted=No;
                      Image=Quote;
                      PromotedCategory=Category6;
                      RunPageMode=Create }
      { 1907709505;1 ;Action    ;
                      Name=NewPurchaseInvoice;
                      CaptionML=[DAN=Kõbsfaktura;
                                 ENU=Purchase Invoice];
                      ToolTipML=[DAN=Opret en ny kõbsfaktura for varer eller servicer.;
                                 ENU=Create a new purchase invoice for items or services.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 51;
                      RunPageLink=Buy-from Vendor No.=FIELD(No.);
                      Promoted=Yes;
                      Visible=NOT IsOfficeAddin;
                      Image=NewPurchaseInvoice;
                      PromotedCategory=Category6;
                      PromotedOnly=Yes;
                      RunPageMode=Create }
      { 1907375405;1 ;Action    ;
                      Name=NewPurchaseOrder;
                      CaptionML=[DAN=Kõbsordre;
                                 ENU=Purchase Order];
                      ToolTipML=[DAN=Opret en ny kõbsordre.;
                                 ENU=Create a new purchase order.];
                      ApplicationArea=#Suite;
                      RunObject=Page 50;
                      RunPageLink=Buy-from Vendor No.=FIELD(No.);
                      Promoted=Yes;
                      Visible=NOT IsOfficeAddin;
                      Image=Document;
                      PromotedCategory=Category6;
                      PromotedOnly=Yes;
                      RunPageMode=Create }
      { 1905024805;1 ;Action    ;
                      Name=NewPurchaseCrMemo;
                      CaptionML=[DAN=Kõbskreditnota;
                                 ENU=Purchase Credit Memo];
                      ToolTipML=[DAN=Opret en ny kõbskreditnota for at tilbagefõre en bogfõrt kõbsfaktura.;
                                 ENU=Create a new purchase credit memo to revert a posted purchase invoice.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 52;
                      RunPageLink=Buy-from Vendor No.=FIELD(No.);
                      Promoted=Yes;
                      Visible=NOT IsOfficeAddin;
                      Image=CreditMemo;
                      PromotedCategory=Category6;
                      PromotedOnly=Yes;
                      RunPageMode=Create }
      { 1904749705;1 ;Action    ;
                      Name=NewPurchaseReturnOrder;
                      CaptionML=[DAN=Kõbsreturvareordre;
                                 ENU=Purchase Return Order];
                      ToolTipML=[DAN=Opret en ny kõbsreturvareordre for kreditoren.;
                                 ENU=Create a new purchase return order for the vendor.];
                      ApplicationArea=#PurchReturnOrder;
                      RunObject=Page 6640;
                      RunPageLink=Buy-from Vendor No.=FIELD(No.);
                      Promoted=No;
                      Image=ReturnOrder;
                      PromotedCategory=Category6;
                      RunPageMode=Create }
      { 97      ;1   ;Action    ;
                      Name=NewPurchaseInvoiceAddin;
                      CaptionML=[DAN=Kõbsfaktura;
                                 ENU=Purchase Invoice];
                      ToolTipML=[DAN=Opret en ny kõbsfaktura for varer eller servicer.;
                                 ENU=Create a new purchase invoice for items or services.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=IsOfficeAddin;
                      Image=NewPurchaseInvoice;
                      PromotedCategory=Category6;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 CreateAndShowNewInvoice;
                               END;
                                }
      { 95      ;1   ;Action    ;
                      Name=NewPurchaseOrderAddin;
                      CaptionML=[DAN=Kõbsordre;
                                 ENU=Purchase Order];
                      ToolTipML=[DAN=Opret en ny kõbsordre.;
                                 ENU=Create a new purchase order.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Visible=IsOfficeAddin;
                      Image=Document;
                      PromotedCategory=Category6;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 CreateAndShowNewPurchaseOrder;
                               END;
                                }
      { 93      ;1   ;Action    ;
                      Name=NewPurchaseCrMemoAddin;
                      CaptionML=[DAN=Kõbskreditnota;
                                 ENU=Purchase Credit Memo];
                      ToolTipML=[DAN=Opret en ny kõbskreditnota for at tilbagefõre en bogfõrt kõbsfaktura.;
                                 ENU=Create a new purchase credit memo to revert a posted purchase invoice.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=IsOfficeAddin;
                      Image=CreditMemo;
                      PromotedCategory=Category6;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 CreateAndShowNewCreditMemo;
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 39      ;1   ;ActionGroup;
                      CaptionML=[DAN=Godkendelse;
                                 ENU=Approval] }
      { 37      ;2   ;Action    ;
                      Name=Approve;
                      CaptionML=[DAN=Godkend;
                                 ENU=Approve];
                      ToolTipML=[DAN=Godkend de anmodede ëndringer.;
                                 ENU=Approve the requested changes.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Visible=OpenApprovalEntriesExistCurrUser;
                      PromotedIsBig=Yes;
                      Image=Approve;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.ApproveRecordApprovalRequest(RECORDID);
                               END;
                                }
      { 35      ;2   ;Action    ;
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
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.RejectRecordApprovalRequest(RECORDID);
                               END;
                                }
      { 33      ;2   ;Action    ;
                      Name=Delegate;
                      CaptionML=[DAN=Uddeleger;
                                 ENU=Delegate];
                      ToolTipML=[DAN=Uddeleger godkendelsen til en stedfortrëdende godkender.;
                                 ENU=Delegate the approval to a substitute approver.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Visible=OpenApprovalEntriesExistCurrUser;
                      Image=Delegate;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.DelegateRecordApprovalRequest(RECORDID);
                               END;
                                }
      { 77      ;2   ;Action    ;
                      Name=Comment;
                      CaptionML=[DAN=Bemërkninger;
                                 ENU=Comments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Visible=OpenApprovalEntriesExistCurrUser;
                      Image=ViewComments;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.GetApprovalComment(Rec);
                               END;
                                }
      { 31      ;1   ;ActionGroup;
                      CaptionML=[DAN=Anmod om godkendelse;
                                 ENU=Request Approval];
                      Image=SendApprovalRequest }
      { 29      ;2   ;Action    ;
                      Name=SendApprovalRequest;
                      CaptionML=[DAN=Send godkendelsesan&modning;
                                 ENU=Send A&pproval Request];
                      ToolTipML=[DAN=Anmod om tilladelse til at ëndre recorden.;
                                 ENU=Request approval to change the record.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=NOT OpenApprovalEntriesExist AND CanRequestApprovalForFlow;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ApprovalsMgmt@1001 : Codeunit 1535;
                               BEGIN
                                 IF ApprovalsMgmt.CheckVendorApprovalsWorkflowEnabled(Rec) THEN
                                   ApprovalsMgmt.OnSendVendorForApproval(Rec);
                               END;
                                }
      { 27      ;2   ;Action    ;
                      Name=CancelApprovalRequest;
                      CaptionML=[DAN=Annuller godk&endelsesanmodning;
                                 ENU=Cancel Approval Re&quest];
                      ToolTipML=[DAN=Annuller godkendelsesanmodningen.;
                                 ENU=Cancel the approval request.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=CanCancelApprovalForRecord OR CanCancelApprovalForFlow;
                      Image=CancelApprovalRequest;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ApprovalsMgmt@1001 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.OnCancelVendorApprovalRequest(Rec);
                                 WorkflowWebhookManagement.FindAndCancel(RECORDID);
                               END;
                                }
      { 83      ;2   ;ActionGroup;
                      Name=Flow;
                      CaptionML=[DAN=Flow;
                                 ENU=Flow] }
      { 91      ;3   ;Action    ;
                      Name=CreateFlow;
                      CaptionML=[DAN=Opret et workflow;
                                 ENU=Create a Flow];
                      ToolTipML=[DAN=Opret et nyt workflow fra en liste over relevante Flow-skabeloner.;
                                 ENU=Create a new Flow from a list of relevant Flow templates.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=IsSaaS;
                      Image=Flow;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 FlowServiceManagement@1000 : Codeunit 6400;
                                 FlowTemplateSelector@1001 : Page 6400;
                               BEGIN
                                 // Opens page 6400 where the user can use filtered templates to create new Flows.
                                 FlowTemplateSelector.SetSearchText(FlowServiceManagement.GetVendorTemplateFilter);
                                 FlowTemplateSelector.RUN;
                               END;
                                }
      { 89      ;3   ;Action    ;
                      Name=SeeFlows;
                      CaptionML=[DAN=Se mine workflows;
                                 ENU=See my Flows];
                      ToolTipML=[DAN=FÜ vist og konfigurer de workflows, du har oprettet.;
                                 ENU=View and configure Flows that you created.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 6401;
                      Promoted=Yes;
                      Image=Flow;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes }
      { 130     ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 59      ;2   ;Action    ;
                      Name=Templates;
                      CaptionML=[DAN=Skabeloner;
                                 ENU=Templates];
                      ToolTipML=[DAN=Vis eller rediger kreditorskabeloner.;
                                 ENU=View or edit vendor templates.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 1340;
                      RunPageLink=Table ID=CONST(23);
                      PromotedIsBig=Yes;
                      Image=Template }
      { 131     ;2   ;Action    ;
                      Name=ApplyTemplate;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Anvend skabelon;
                                 ENU=Apply Template];
                      ToolTipML=[DAN=Anvend en skabelon for at opdatere enheden med dine standardindstillinger for en bestemt enhedstype.;
                                 ENU=Apply a template to update the entity with your standard settings for a certain type of entity.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ApplyTemplate;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 MiniVendorTemplate@1002 : Record 1303;
                               BEGIN
                                 MiniVendorTemplate.UpdateVendorFromTemplate(Rec);
                               END;
                                }
      { 51      ;2   ;Action    ;
                      Name=SaveAsTemplate;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Gem som skabelon;
                                 ENU=Save as Template];
                      ToolTipML=[DAN=Gem kreditorkortet som en skabelon, der kan genbruges ved oprettelse af nye kreditorkort. Kreditorskabeloner indeholder forudindstillede oplysninger som en hjëlp til udfyldelse af kreditorkortene.;
                                 ENU=Save the vendor card as a template that can be reused to create new vendor cards. Vendor templates contain preset information to help you fill fields on vendor cards.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Save;
                      OnAction=VAR
                                 TempMiniVendorTemplate@1000 : TEMPORARY Record 1303;
                               BEGIN
                                 TempMiniVendorTemplate.SaveAsTemplate(Rec);
                               END;
                                }
      { 1902327104;1 ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Opret betalinger;
                                 ENU=Create Payments];
                      ToolTipML=[DAN=Se eller rediger den udbetalingskladde, hvor du kan registrere betalinger til kreditorer.;
                                 ENU=View or edit the payment journal where you can register payments to vendors.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 256;
                      Promoted=Yes;
                      Image=PaymentJournal;
                      PromotedCategory=Process }
      { 1906371704;1 ;Action    ;
                      CaptionML=[DAN=Kõbskladde;
                                 ENU=Purchase Journal];
                      ToolTipML=[DAN="Bogfõr alle kõbstransaktioner for kreditoren. ";
                                 ENU="Post any purchase transaction for the vendor. "];
                      ApplicationArea=#Advanced;
                      RunObject=Page 254;
                      Promoted=Yes;
                      Image=Journals;
                      PromotedCategory=Process }
      { 63      ;1   ;ActionGroup;
                      CaptionML=[DAN=IndgÜende bilag;
                                 ENU=Incoming Documents];
                      Image=SendApprovalRequest }
      { 65      ;2   ;Action    ;
                      Name=SendToIncomingDocuments;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Send til IndgÜende bilag;
                                 ENU=Send to Incoming Documents];
                      ToolTipML=[DAN=Send til IndgÜende bilag;
                                 ENU=Send to Incoming Documents];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=SendToIncomingDocumentVisible;
                      Enabled=SendToIncomingDocEnabled;
                      PromotedIsBig=Yes;
                      Image=SendElectronicDocument;
                      PromotedCategory=Category8;
                      OnAction=BEGIN
                                 OfficeMgt.InitiateSendToIncomingDocuments("No.");
                               END;
                                }
      { 61      ;2   ;Action    ;
                      Name=SendToOCR;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Send til OCR;
                                 ENU=Send To OCR];
                      ToolTipML=[DAN=Send til OCR;
                                 ENU=Send To OCR];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=SendToOCRVisible;
                      Enabled=SendToOCREnabled;
                      PromotedIsBig=Yes;
                      Image=SendElectronicDocument;
                      PromotedCategory=Category8;
                      OnAction=BEGIN
                                 OfficeMgt.InitiateSendToOCR("No.");
                               END;
                                }
      { 62      ;2   ;Action    ;
                      Name=SendIncomingDocApprovalRequest;
                      AccessByPermission=TableData 454=I;
                      CaptionML=[DAN=Send godkendelsesan&modning;
                                 ENU=Send A&pproval Request];
                      ToolTipML=[DAN=Anmod om tilladelse til at ëndre recorden.;
                                 ENU=Request approval to change the record.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=SendIncomingDocApprovalRequestVisible;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category8;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 OfficeMgt.InitiateSendApprovalRequest("No.");
                               END;
                                }
      { 57      ;1   ;Action    ;
                      CaptionML=[DAN=Kreditor - forfaldsoversigt;
                                 ENU=Vendor - Summary Aging];
                      ToolTipML=[DAN=Vis en oversigt over skyldige belõb til hver kreditor, opdelt i tre tidsperioder.;
                                 ENU=View a summary of the payables owed to each vendor, divided into three time periods.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 RunReport(REPORT::"Vendor - Summary Aging");
                               END;
                                }
      { 1905916106;1 ;Action    ;
                      CaptionML=[DAN=Kreditor - etiketter;
                                 ENU=Vendor - Labels];
                      ToolTipML=[DAN=Vis adresseetiketter med navn og adresse pÜ kreditorer.;
                                 ENU=View mailing labels with the vendors' names and addresses.];
                      ApplicationArea=#Advanced;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 RunReport(REPORT::"Vendor - Labels");
                               END;
                                }
      { 1904504206;1 ;Action    ;
                      CaptionML=[DAN=Kreditor - saldo til dato;
                                 ENU=Vendor - Balance to Date];
                      ToolTipML=[DAN=Vis en detaljeret balance for udvalgte kreditorer.;
                                 ENU=View a detail balance for selected vendors.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 RunReport(REPORT::"Vendor - Balance to Date");
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
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
                ToolTipML=[DAN=Angiver kreditorens navn. Du kan bruge op til 30 tegn, bÜde tal og bogstaver.;
                           ENU=Specifies the vendor's name. You can enter a maximum of 30 characters, both numbers and letters.];
                ApplicationArea=#All;
                SourceExpr=Name;
                Importance=Promoted;
                ShowMandatory=TRUE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den relaterede record er forhindret i kunne bogfõres under transaktioner - eksempelvis en debitor, som er erklëret insolvent, eller en vare, som er sat i karantëne.;
                           ENU=Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Blocked }

    { 200 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om adgangen til data skal begrënses for dataemnet i den daglige drift. Dette er eksempelvis nyttigt, nÜr du vil beskytte data mod ëndringer, mens det kontrolleres, om de indeholder personlige oplysninger.;
                           ENU=Specifies whether to limit access to data for the data subject during daily operations. This is useful, for example, when protecting data from changes while it is under privacy review.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Privacy Blocked";
                Importance=Additional }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvornÜr kreditorkortet sidst blev ëndret.;
                           ENU=Specifies when the vendor card was last modified.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Last Date Modified";
                Importance=Additional }

    { 92  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den samlede vërdi af dine gennemfõrte kõb fra kreditoren i det aktuelle regnskabsÜr. Den beregnes ud fra belõbene, ekskl. moms, pÜ alle afsluttede og Übne kõbsfakturaer og kreditnotaer.;
                           ENU=Specifies the total value of your completed purchases from the vendor in the current fiscal year. It is calculated from amounts excluding VAT on all completed purchase invoices and credit memos.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Balance (LCY)";
                OnDrillDown=BEGIN
                              OpenVendorLedgerEntries(FALSE);
                            END;
                             }

    { 45  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den samlede vërdi af dine ubetalte kõb fra kreditoren i det aktuelle regnskabsÜr. Den beregnes ud fra belõbene, ekskl. moms, pÜ alle Übne kõbsfakturaer og kreditnotaer.;
                           ENU=Specifies the total value of your unpaid purchases from the vendor in the current fiscal year. It is calculated from amounts excluding VAT on all open purchase invoices and credit memos.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Balance Due (LCY)";
                OnDrillDown=BEGIN
                              OpenVendorLedgerEntries(TRUE);
                            END;
                             }

    { 80  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den foretrukne metode til afsendelse af dokumenter til denne kreditor, sÜ du ikke behõver at vëlge en afsendelsesindstilling, hver gang du bogfõrer og sender et dokument til kreditoren. Dokumenter til denne kreditor skal sendes med den angivne afsendelsesprofil og tilsidesëtter standarddokumentafsendelsesprofilen.;
                           ENU=Specifies the preferred method of sending documents to this vendor, so that you do not have to select a sending option every time that you post and send a document to the vendor. Documents to this vendor will be sent using the specified sending profile and will override the default document sending profile.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Sending Profile";
                Importance=Additional }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et alternativt navn, du kan bruge til at sõge efter den õnskede record, hvis du ikke kan huske vërdien i feltet Navn.;
                           ENU=Specifies an alternate name that you can use to search for the record in question when you cannot remember the value in the Name field.];
                ApplicationArea=#Advanced;
                SourceExpr="Search Name";
                Importance=Additional }

    { 85  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens IC-partnerkode, hvis kreditoren er en koncernintern partner.;
                           ENU=Specifies the vendor's IC partner code, if the vendor is one of your intercompany partners.];
                ApplicationArea=#Intercompany;
                SourceExpr="IC Partner Code";
                Importance=Additional }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken indkõber der er tilknyttet kreditoren.;
                           ENU=Specifies which purchaser is assigned to the vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Purchaser Code";
                Importance=Additional }

    { 55  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode for ansvarscenteret (f.eks. et distributionscenter), som er tildelt den involverede bruger, virksomhed, debitor eller kreditor.;
                           ENU=Specifies the code of the responsibility center, such as a distribution hub, that is associated with the involved user, company, customer, or vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Responsibility Center";
                Importance=Additional }

    { 1902768601;1;Group  ;
                CaptionML=[DAN=Adresse og kontakt;
                           ENU=Address & Contact];
                GroupType=Group }

    { 43  ;2   ;Group     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                GroupType=Group }

    { 6   ;3   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens adresse.;
                           ENU=Specifies the vendor's address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Address }

    { 8   ;3   ;Field     ;
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Address 2" }

    { 79  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver postnummer.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Post Code";
                Importance=Promoted }

    { 10  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens by.;
                           ENU=Specifies the vendor's city.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=City }

    { 81  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver adressens land/omrÜde.;
                           ENU=Specifies the country/region of the address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Country/Region Code" }

    { 49  ;3   ;Field     ;
                Name=ShowMap;
                ToolTipML=[DAN=Angiver, at du kan se debitors adresse pÜ dit foretrukne kortwebsted.;
                           ENU=Specifies you can view the customer's address on your preferred map website.];
                ApplicationArea=#Advanced;
                SourceExpr=ShowMapLbl;
                Editable=FALSE;
                Style=StrongAccent;
                StyleExpr=TRUE;
                OnDrillDown=BEGIN
                              CurrPage.UPDATE(TRUE);
                              DisplayMap;
                            END;

                ShowCaption=No }

    { 44  ;2   ;Group     ;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                GroupType=Group }

    { 11  ;3   ;Field     ;
                CaptionML=[DAN=Primër kontaktkode;
                           ENU=Primary Contact Code];
                ToolTipML=[DAN=Angiver det primëre kontaktnummer for debitoren.;
                           ENU=Specifies the primary contact number for the customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Primary Contact No." }

    { 16  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ den person, du normalt er i kontakt med, nÜr du handler med kreditoren.;
                           ENU=Specifies the name of the person you regularly contact when you do business with this vendor.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Contact;
                Importance=Promoted;
                Editable=ContactEditable;
                OnValidate=BEGIN
                             ContactOnAfterValidate;
                           END;
                            }

    { 12  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens telefonnummer.;
                           ENU=Specifies the vendor's telephone number.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Phone No." }

    { 48  ;3   ;Field     ;
                ExtendedDatatype=E-Mail;
                ToolTipML=[DAN=Angiver kreditorens mailadresse.;
                           ENU=Specifies the vendor's email address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="E-Mail";
                Importance=Promoted }

    { 58  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver debitorens faxnummer.;
                           ENU=Specifies the customer's fax number.];
                ApplicationArea=#Advanced;
                SourceExpr="Fax No.";
                Importance=Additional }

    { 86  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens websted.;
                           ENU=Specifies the vendor's web site.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Home Page" }

    { 50  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver dit kontonummer hos kreditoren, hvis du har en konto.;
                           ENU=Specifies your account number with the vendor, if you have one.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Our Account No." }

    { 56  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver det sprog, der bruges ved oversëttelse af angivet tekst i bilag til udenlandske forretningspartnere, f.eks. en beskrivelse af varen pÜ en ordrebekrëftelse.;
                           ENU=Specifies the language that is used when translating specified text on documents to foreign business partner, such as an item description on an order confirmation.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Language Code";
                Importance=Additional }

    { 1905885101;1;Group  ;
                CaptionML=[DAN=Fakturering;
                           ENU=Invoicing] }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens CVR-nummer.;
                           ENU=Specifies the vendor's VAT registration number.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Registration No.";
                OnDrillDown=VAR
                              VATRegistrationLogMgt@1000 : Codeunit 249;
                            BEGIN
                              VATRegistrationLogMgt.AssistEditVendorVATReg(Rec);
                            END;
                             }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditoren i forbindelse med modtagelse af elektroniske dokumenter.;
                           ENU=Specifies the vendor in connection with electronic document receiving.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=GLN;
                Importance=Additional }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ en anden kreditor, som du betaler for produkter, der leveres af kreditoren, pÜ kreditorkortet.;
                           ENU=Specifies the number of a different vendor whom you pay for products delivered by the vendor on the vendor card.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pay-to Vendor No.";
                Importance=Additional }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens fakturarabatkode. NÜr du opretter et nyt kreditorkort, indsëttes det nummer, du har angivet i feltet Nummer, automatisk.;
                           ENU=Specifies the vendor's invoice discount code. When you set up a new vendor card, the number you have entered in the No. field is automatically inserted.];
                ApplicationArea=#Basic,#Suite;
                NotBlank=Yes;
                SourceExpr="Invoice Disc. Code";
                Importance=Additional }

    { 94  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om felterne Enhedspris og Linjebelõb pÜ bilagslinjer skal vises med eller uden moms.;
                           ENU=Specifies if the Unit Price and Line Amount fields on document lines should be shown with or without VAT.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Prices Including VAT" }

    { 46  ;2   ;Group     ;
                CaptionML=[DAN=Bogfõringsoplysninger;
                           ENU=Posting Details];
                GroupType=Group }

    { 60  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens handelstype for at knytte transaktioner, der er foretaget for denne kreditoren, til den relevante finanskonto i overensstemmelse med den generelle bogfõringsopsëtning.;
                           ENU=Specifies the vendor's trade type to link transactions made for this vendor with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Gen. Bus. Posting Group";
                Importance=Additional;
                ShowMandatory=TRUE }

    { 90  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede debitors eller kreditors momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogfõringsopsëtning.;
                           ENU=Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Bus. Posting Group";
                Importance=Additional }

    { 32  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens markedstype for at knytte forretningstransaktioner, der er foretaget for denne kreditor, til den relevante finanskonto.;
                           ENU=Specifies the vendor's market type to link business transactions made for the vendor with the appropriate account in the general ledger.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Vendor Posting Group";
                Importance=Additional;
                ShowMandatory=TRUE }

    { 47  ;2   ;Group     ;
                CaptionML=[DAN=Udenrigshandel;
                           ENU=Foreign Trade];
                GroupType=Group }

    { 52  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver den valutakode, der som standard er indsat, nÜr du opretter kõbsdokumenter eller kladdelinjer til kreditoren.;
                           ENU=Specifies the currency code that is inserted by default when you create purchase documents or journal lines for the vendor.];
                ApplicationArea=#Suite;
                SourceExpr="Currency Code";
                Importance=Additional }

    { 1901677601;1;Group  ;
                CaptionML=[DAN=Betalinger;
                           ENU=Payments] }

    { 88  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en forudbetalingsprocent, der gëlder for alle ordrer fra denne kreditor, uanset hvilke varer eller tjenester der er angivet pÜ ordrelinjerne.;
                           ENU=Specifies a prepayment percentage that applies to all orders for this vendor, regardless of the items or services on the order lines.];
                ApplicationArea=#Prepayments;
                SourceExpr="Prepayment %";
                Importance=Additional }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan du kan udligne betalinger pÜ poster for denne kreditor.;
                           ENU=Specifies how to apply payments to entries for this vendor.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Application Method" }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en formel, der beregner betalingens forfaldsdato, kontantrabatdato og kontantrabatbelõb.;
                           ENU=Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Terms Code";
                Importance=Promoted }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan betalingen skal foretages, f.eks. via bankoverfõrsel, kontant eller med check.;
                           ENU=Specifies how to make payment, such as with bank transfer, cash,  or check.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Method Code";
                Importance=Promoted }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver vigtigheden af kreditoren, nÜr der foreslÜs betalinger ved brug af funktionen Lav kreditorbetalingsforslag.;
                           ENU=Specifies the importance of the vendor when suggesting payments using the Suggest Vendor Payments function.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Priority }

    { 119 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om kreditoren tillader betalingstolerance.;
                           ENU=Specifies if the vendor allows payment tolerance.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Block Payment Tolerance";
                OnValidate=BEGIN
                             IF "Block Payment Tolerance" THEN BEGIN
                               IF CONFIRM(Text002,FALSE) THEN
                                 PaymentToleranceMgt.DelTolVendLedgEntry(Rec);
                             END ELSE BEGIN
                               IF CONFIRM(Text001,FALSE) THEN
                                 PaymentToleranceMgt.CalcTolVendLedgEntry(Rec);
                             END;
                           END;
                            }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kreditorbankkonto, der skal bruges som standard pÜ betalingskladdelinjer til eksport til en betalingsbankfil.;
                           ENU=Specifies the vendor bank account that will be used by default on payment journal lines for export to a payment bank file.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Preferred Bank Account Code" }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om kreditoren er en person eller en virksomhed.;
                           ENU=Specifies if the vendor is a person or a company.];
                ApplicationArea=#Advanced;
                SourceExpr="Partner Type" }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en betalingsbetingelse, der skal bruges til beregning af pengestrõm.;
                           ENU=Specifies a payment term that will be used for calculating cash flow.];
                ApplicationArea=#Advanced;
                SourceExpr="Cash Flow Payment Terms Code" }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ kreditoren.;
                           ENU=Specifies the number of the vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Creditor No." }

    { 1901075901;1;Group  ;
                CaptionML=[DAN=Modtagelse;
                           ENU=Receiving] }

    { 100 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den lagerlokation, hvor varer fra kreditoren som standard skal modtages.;
                           ENU=Specifies the warehouse location where items from the vendor must be received by default.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Importance=Promoted }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver betingelserne for levering af den relaterede leverance, som f.eks. frit ombord (FOB).;
                           ENU=Specifies the delivery conditions of the related shipment, such as free on board (FOB).];
                ApplicationArea=#Advanced;
                SourceExpr="Shipment Method Code";
                Importance=Promoted }

    { 96  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en datoformel for det tidsrum, det tager at genbestille varen.;
                           ENU=Specifies a date formula for the amount of time it takes to replenish the item.];
                ApplicationArea=#Advanced;
                SourceExpr="Lead Time Calculation";
                Importance=Promoted }

    { 112 ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver en redigerbar kalender for leveringsplanlëgning, der indeholder kreditorens arbejdsdage og fridage.;
                           ENU=Specifies a customizable calendar for delivery planning that holds the vendor's working days and holidays.];
                ApplicationArea=#Advanced;
                SourceExpr="Base Calendar Code" }

    { 121 ;2   ;Field     ;
                Name=Customized Calendar;
                CaptionML=[DAN=Tilpasset kalender;
                           ENU=Customized Calendar];
                ToolTipML=[DAN=Angiver, om du har oprettet en tilpasset kalender for kreditoren.;
                           ENU=Specifies if you have set up a customized calendar for the vendor.];
                ApplicationArea=#Advanced;
                SourceExpr=CalendarMgmt.CustomizedCalendarExistText(CustomizedCalendar."Source Type"::Vendor,"No.",'',"Base Calendar Code");
                Editable=FALSE;
                OnDrillDown=BEGIN
                              CurrPage.SAVERECORD;
                              TESTFIELD("Base Calendar Code");
                              CalendarMgmt.ShowCustomizedCalendar(CustomizedCalEntry."Source Type"::Vendor,"No.",'',"Base Calendar Code");
                            END;
                             }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 82  ;1   ;Part      ;
                ApplicationArea=#Basic,#Suite;
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page786;
                Visible=NOT IsOfficeAddin;
                PartType=Page }

    { 1904651607;1;Part   ;
                Name=VendorStatisticsFactBox;
                ApplicationArea=#All;
                SubPageLink=No.=FIELD(No.),
                            Currency Filter=FIELD(Currency Filter),
                            Date Filter=FIELD(Date Filter),
                            Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                            Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
                PagePartID=Page9094;
                PartType=Page }

    { 53  ;1   ;Part      ;
                Name=AgedAccPayableChart;
                ApplicationArea=#Basic,#Suite;
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page769;
                Visible=IsOfficeAddin;
                PartType=Page }

    { 17  ;1   ;Part      ;
                ApplicationArea=#All;
                SubPageLink=Source Type=CONST(Vendor),
                            Source No.=FIELD(No.);
                PagePartID=Page875;
                Visible=SocialListeningVisible;
                PartType=Page }

    { 19  ;1   ;Part      ;
                ApplicationArea=#All;
                SubPageLink=Source Type=CONST(Vendor),
                            Source No.=FIELD(No.);
                PagePartID=Page876;
                Visible=SocialListeningSetupVisible;
                PartType=Page;
                UpdatePropagation=Both }

    { 1903435607;1;Part   ;
                Name=VendorHistBuyFromFactBox;
                ApplicationArea=#Basic,#Suite;
                SubPageLink=No.=FIELD(No.),
                            Currency Filter=FIELD(Currency Filter),
                            Date Filter=FIELD(Date Filter),
                            Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                            Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
                PagePartID=Page9095;
                PartType=Page }

    { 1906949207;1;Part   ;
                Name=VendorHistPayToFactBox;
                ApplicationArea=#All;
                SubPageLink=No.=FIELD(No.),
                            Currency Filter=FIELD(Currency Filter),
                            Date Filter=FIELD(Date Filter),
                            Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                            Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
                PagePartID=Page9096;
                Visible=FALSE;
                PartType=Page }

    { 41  ;1   ;Part      ;
                Name=WorkflowStatus;
                ApplicationArea=#All;
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
      CustomizedCalEntry@1003 : Record 7603;
      CustomizedCalendar@1001 : Record 7602;
      OfficeMgt@1015 : Codeunit 1630;
      CalendarMgmt@1000 : Codeunit 7600;
      PaymentToleranceMgt@1002 : Codeunit 426;
      WorkflowWebhookManagement@1025 : Codeunit 1543;
      ApprovalsMgmt@1010 : Codeunit 1535;
      Text001@1005 : TextConst 'DAN=Vil du tillade betalingstolerance for poster, der aktuelt er Übne?;ENU=Do you want to allow payment tolerance for entries that are currently open?';
      Text002@1004 : TextConst 'DAN=Vil du fjerne betalingstolerance fra poster, der aktuelt er Übne?;ENU=Do you want to remove payment tolerance from entries that are currently open?';
      ContactEditable@19051436 : Boolean INDATASET;
      SocialListeningSetupVisible@1007 : Boolean INDATASET;
      SocialListeningVisible@1006 : Boolean INDATASET;
      OpenApprovalEntriesExistCurrUser@1009 : Boolean;
      OpenApprovalEntriesExist@1008 : Boolean;
      ShowWorkflowStatus@1011 : Boolean;
      ShowMapLbl@1014 : TextConst 'DAN=Vis pÜ kort;ENU=Show on Map';
      IsOfficeAddin@1012 : Boolean;
      CanCancelApprovalForRecord@1013 : Boolean;
      SendToOCREnabled@1016 : Boolean;
      SendToOCRVisible@1017 : Boolean;
      SendToIncomingDocEnabled@1018 : Boolean;
      SendIncomingDocApprovalRequestVisible@1019 : Boolean;
      SendToIncomingDocumentVisible@1020 : Boolean;
      NoFieldVisible@1021 : Boolean;
      NewMode@1022 : Boolean;
      CanRequestApprovalForFlow@1023 : Boolean;
      CanCancelApprovalForFlow@1024 : Boolean;
      IsSaaS@1026 : Boolean;

    LOCAL PROCEDURE ActivateFields@3();
    BEGIN
      SetSocialListeningFactboxVisibility;
      ContactEditable := "Primary Contact No." = '';
      IF OfficeMgt.IsAvailable THEN
        ActivateIncomingDocumentsFields;
    END;

    LOCAL PROCEDURE ContactOnAfterValidate@19013243();
    BEGIN
      ActivateFields;
    END;

    LOCAL PROCEDURE SetSocialListeningFactboxVisibility@1();
    VAR
      SocialListeningMgt@1000 : Codeunit 871;
    BEGIN
      SocialListeningMgt.GetVendFactboxVisibility(Rec,SocialListeningSetupVisible,SocialListeningVisible);
    END;

    LOCAL PROCEDURE SetVendorNoVisibilityOnFactBoxes@2();
    BEGIN
      CurrPage.VendorHistBuyFromFactBox.PAGE.SetVendorNoVisibility(FALSE);
      CurrPage.VendorHistPayToFactBox.PAGE.SetVendorNoVisibility(FALSE);
      CurrPage.VendorStatisticsFactBox.PAGE.SetVendorNoVisibility(FALSE);
    END;

    LOCAL PROCEDURE RunReport@4(ReportNumber@1000 : Integer);
    VAR
      Vendor@1001 : Record 23;
    BEGIN
      Vendor.SETRANGE("No.","No.");
      REPORT.RUNMODAL(ReportNumber,TRUE,TRUE,Vendor);
    END;

    LOCAL PROCEDURE ActivateIncomingDocumentsFields@11();
    VAR
      IncomingDocument@1001 : Record 130;
    BEGIN
      IF OfficeMgt.OCRAvailable THEN BEGIN
        SendToIncomingDocumentVisible := TRUE;
        SendToIncomingDocEnabled := OfficeMgt.EmailHasAttachments;
        SendToOCREnabled := OfficeMgt.EmailHasAttachments;
        SendToOCRVisible := IncomingDocument.OCRIsEnabled AND NOT IsIncomingDocApprovalsWorkflowEnabled;
        SendIncomingDocApprovalRequestVisible := IsIncomingDocApprovalsWorkflowEnabled;
      END;
    END;

    LOCAL PROCEDURE IsIncomingDocApprovalsWorkflowEnabled@30() : Boolean;
    VAR
      WorkflowEventHandling@1000 : Codeunit 1520;
      WorkflowDefinition@1005 : Query 1502;
    BEGIN
      WorkflowDefinition.SETRANGE(Table_ID,DATABASE::"Incoming Document");
      WorkflowDefinition.SETRANGE(Entry_Point,TRUE);
      WorkflowDefinition.SETRANGE(Enabled,TRUE);
      WorkflowDefinition.SETRANGE(Type,WorkflowDefinition.Type::"Event");
      WorkflowDefinition.SETRANGE(Function_Name,WorkflowEventHandling.RunWorkflowOnSendIncomingDocForApprovalCode);
      WorkflowDefinition.OPEN;
      WHILE WorkflowDefinition.READ DO
        EXIT(TRUE);

      EXIT(FALSE);
    END;

    LOCAL PROCEDURE CreateVendorFromTemplate@10();
    VAR
      MiniVendorTemplate@1001 : Record 1303;
      Vendor@1000 : Record 23;
      VATRegNoSrvConfig@1003 : Record 248;
      EUVATRegistrationNoCheck@1002 : Page 1339;
      VendorRecRef@1004 : RecordRef;
    BEGIN
      IF NewMode THEN BEGIN
        IF MiniVendorTemplate.NewVendorFromTemplate(Vendor) THEN BEGIN
          IF VATRegNoSrvConfig.VATRegNoSrvIsEnabled THEN
            IF Vendor."Validate EU Vat Reg. No." THEN BEGIN
              EUVATRegistrationNoCheck.SetRecordRef(Vendor);
              COMMIT;
              EUVATRegistrationNoCheck.RUNMODAL;
              EUVATRegistrationNoCheck.GetRecordRef(VendorRecRef);
              VendorRecRef.SETTABLE(Vendor);
            END;
          COPY(Vendor);
          CurrPage.UPDATE;
        END;
        NewMode := FALSE;
      END;
    END;

    LOCAL PROCEDURE SetNoFieldVisible@13();
    VAR
      DocumentNoVisibility@1000 : Codeunit 1400;
    BEGIN
      NoFieldVisible := DocumentNoVisibility.VendorNoIsVisible;
    END;

    BEGIN
    END.
  }
}

