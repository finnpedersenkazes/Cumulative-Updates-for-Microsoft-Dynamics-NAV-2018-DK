OBJECT Page 27 Vendor List
{
  OBJECT-PROPERTIES
  {
    Date=06-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21441;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Kreditorer;
               ENU=Vendors];
    SourceTable=Table23;
    PageType=List;
    CardPageID=Vendor Card;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,RapportÇr,Nyt dokument,Kreditor;
                                ENU=New,Process,Report,New Document,Vendor];
    OnInit=BEGIN
             SetVendorNoVisibilityOnFactBoxes;
           END;

    OnOpenPage=BEGIN
                 // Contextual Power BI FactBox: filtering available reports, setting context, loading Power BI related user settings
                 CurrPage."Power BI Report FactBox".PAGE.SetNameFilter(CurrPage.CAPTION);
                 CurrPage."Power BI Report FactBox".PAGE.SetContext(CurrPage.OBJECTID(FALSE));
                 PowerBIVisible := SetPowerBIUserConfig.SetUserConfig(PowerBIUserConfiguration,CurrPage.OBJECTID(FALSE));

                 ResyncVisible := ReadSoftOCRMasterDataSync.IsSyncEnabled;
               END;

    OnAfterGetCurrRecord=BEGIN
                           SetSocialListeningFactboxVisibility;
                           OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);

                           CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RECORDID);

                           WorkflowWebhookManagement.GetCanRequestAndCanCancel(RECORDID,CanRequestApprovalForFlow,CanCancelApprovalForFlow);

                           // Contextual Power BI FactBox: send data to filter the report in the FactBox
                           CurrPage."Power BI Report FactBox".PAGE.SetCurrentListSelection("No.",FALSE);
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 16      ;1   ;ActionGroup;
                      CaptionML=[DAN=Kredito&r;
                                 ENU=Ven&dor];
                      Image=Vendor }
      { 44      ;2   ;ActionGroup;
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
                      RunPageLink=Table ID=CONST(23),
                                  No.=FIELD(No.);
                      Image=Dimensions }
      { 43      ;3   ;Action    ;
                      Name=DimensionsMultiple;
                      AccessByPermission=TableData 348=R;
                      CaptionML=[DAN=Dimensioner - &flere;
                                 ENU=Dimensions-&Multiple];
                      ToolTipML=[DAN=Vis eller rediger dimensionerne for en gruppe af records. Du kan tildele dimensionskoder til transaktioner for at fordele omkostninger og analysere historikken.;
                                 ENU=View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyze historical information.];
                      ApplicationArea=#Suite;
                      Image=DimensionSets;
                      OnAction=VAR
                                 Vend@1001 : Record 23;
                                 DefaultDimMultiple@1002 : Page 542;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(Vend);
                                 DefaultDimMultiple.SetMultiVendor(Vend);
                                 DefaultDimMultiple.RUNMODAL;
                               END;
                                }
      { 54      ;2   ;Action    ;
                      CaptionML=[DAN=Bankkonti;
                                 ENU=Bank Accounts];
                      ToolTipML=[DAN=èbn listen med kreditorens bankkonti;
                                 ENU=Open the list of the vendor's bank accounts];
                      ApplicationArea=#Advanced;
                      RunObject=Page 426;
                      RunPageLink=Vendor No.=FIELD(No.);
                      Image=BankAccount }
      { 56      ;2   ;Action    ;
                      AccessByPermission=TableData 5050=R;
                      CaptionML=[DAN=K&ontakt;
                                 ENU=C&ontact];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om kontaktpersonen hos kreditoren.;
                                 ENU=View or edit detailed information about the contact person at the vendor.];
                      ApplicationArea=#Advanced;
                      Image=ContactPerson;
                      OnAction=BEGIN
                                 ShowContact;
                               END;
                                }
      { 55      ;2   ;Separator  }
      { 53      ;2   ;Action    ;
                      Name=OrderAddresses;
                      CaptionML=[DAN=B&estillingsadresser;
                                 ENU=Order &Addresses];
                      ToolTipML=[DAN=Vis eller rediger alternative adresser for kreditoren.;
                                 ENU=View or edit alternate addresses for the vendor.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 369;
                      RunPageLink=Vendor No.=FIELD(No.);
                      Image=Addresses }
      { 20      ;2   ;Action    ;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 124;
                      RunPageLink=Table Name=CONST(Vendor),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 62      ;2   ;Action    ;
                      CaptionML=[DAN=Varere&ferencer;
                                 ENU=Cross Re&ferences];
                      ToolTipML=[DAN=Konfigurer en debitors eller kreditors egen identifikation af den valgte vare. Krydshenvisninger til debitorens varenummer betyder, at debitorens varenummer automatisk vises i salgsbilag i stedet for det nummer, du anvender.;
                                 ENU=Set up a customer's or vendor's own identification of the selected item. Cross-references to the customer's item number means that the item number is automatically shown on sales documents instead of the number that you use.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 5723;
                      RunPageView=SORTING(Cross-Reference Type,Cross-Reference Type No.);
                      RunPageLink=Cross-Reference Type=CONST(Vendor),
                                  Cross-Reference Type No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Change;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes }
      { 36      ;2   ;Action    ;
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
      { 23      ;1   ;ActionGroup;
                      CaptionML=[DAN=Kõ&b;
                                 ENU=&Purchases];
                      Image=Purchasing }
      { 66      ;2   ;Action    ;
                      CaptionML=[DAN=Varer;
                                 ENU=Items];
                      ToolTipML=[DAN=èbn listen over varer, som du handler med.;
                                 ENU=Open the list of items that you trade in.];
                      ApplicationArea=#Planning;
                      RunObject=Page 297;
                      RunPageView=SORTING(Vendor No.);
                      RunPageLink=Vendor No.=FIELD(No.);
                      Image=Item }
      { 25      ;2   ;Action    ;
                      CaptionML=[DAN=Fakturara&batter;
                                 ENU=Invoice &Discounts];
                      ToolTipML=[DAN=Angiv forskellige rabatter, som kan tilfõjes fakturaer til debitor. Der gives automatisk en fakturarabat til debitor, nÜr det samlede fakturabelõb overstiger et vist belõb.;
                                 ENU=Set up different discounts that are applied to invoices for the customer. An invoice discount is automatically granted to the customer when the total on a sales invoice exceeds a certain amount.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 28;
                      RunPageLink=Code=FIELD(Invoice Disc. Code);
                      Image=CalculateInvoiceDiscount }
      { 24      ;2   ;Action    ;
                      CaptionML=[DAN=Salgspriser;
                                 ENU=Prices];
                      ToolTipML=[DAN=Vis eller angiv forskellige priser for de varer, du kõber hos kreditoren. En varepris anfõres automatisk pÜ fakturalinjer, nÜr de specificerede kriterier er blevet opfyldt, f.eks. kreditor, mëngde eller slutdato.;
                                 ENU=View or set up different prices for items that you buy from the vendor. An item price is automatically granted on invoice lines when the specified criteria are met, such as vendor, quantity, or ending date.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 7012;
                      RunPageView=SORTING(Vendor No.);
                      RunPageLink=Vendor No.=FIELD(No.);
                      Image=Price }
      { 64      ;2   ;Action    ;
                      CaptionML=[DAN=Linjerabat;
                                 ENU=Line Discounts];
                      ToolTipML=[DAN=Vis eller angiv forskellige rabatter for de varer, du kõber hos kreditoren. En varerabat anfõres automatisk pÜ fakturalinjer, nÜr de specificerede kriterier er blevet opfyldt, f.eks. kreditor, antal eller slutdato.;
                                 ENU=View or set up different discounts for items that you buy from the vendor. An item discount is automatically granted on invoice lines when the specified criteria are met, such as vendor, quantity, or ending date.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 7014;
                      RunPageView=SORTING(Vendor No.);
                      RunPageLink=Vendor No.=FIELD(No.);
                      Image=LineDiscount }
      { 70      ;2   ;Action    ;
                      CaptionML=[DAN=Forudb&etalingsprocenter;
                                 ENU=Prepa&yment Percentages];
                      ToolTipML=[DAN="Vis eller rediger de procentdele af prisen, der kan betales som forudbetaling. ";
                                 ENU="View or edit the percentages of the price that can be paid as a prepayment. "];
                      ApplicationArea=#Prepayments;
                      RunObject=Page 665;
                      RunPageView=SORTING(Vendor No.);
                      RunPageLink=Vendor No.=FIELD(No.);
                      Image=PrepaymentPercentages }
      { 67      ;2   ;Action    ;
                      CaptionML=[DAN=S&td.kred.kõbskoder;
                                 ENU=S&td. Vend. Purchase Codes];
                      ToolTipML=[DAN=Vis eller rediger tilbagevendende kõbslinjer hos kreditoren.;
                                 ENU=View or edit recurring purchase lines for the vendor.];
                      ApplicationArea=#Suite;
                      RunObject=Page 178;
                      RunPageLink=Vendor No.=FIELD(No.);
                      Image=CodesList }
      { 38      ;2   ;Action    ;
                      CaptionML=[DAN=Koblingstekst til konto;
                                 ENU=Mapping Text to Account];
                      ToolTipML=[DAN=Side for tekst til konto-tilknytning;
                                 ENU=Page mapping text to account];
                      ApplicationArea=#Advanced;
                      RunObject=Page 1254;
                      RunPageLink=Vendor No.=FIELD(No.);
                      Image=MapAccounts }
      { 11      ;1   ;ActionGroup;
                      CaptionML=[DAN=Dokumenter;
                                 ENU=Documents];
                      Image=Administration }
      { 26      ;2   ;Action    ;
                      CaptionML=[DAN=Rekvisition;
                                 ENU=Quotes];
                      ToolTipML=[DAN=Vi en oversigt over igangvërende salgstilbud.;
                                 ENU=View a list of ongoing sales quotes.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9306;
                      RunPageView=SORTING(Document Type,Buy-from Vendor No.);
                      RunPageLink=Buy-from Vendor No.=FIELD(No.);
                      Image=Quote }
      { 27      ;2   ;Action    ;
                      CaptionML=[DAN=Ordrer;
                                 ENU=Orders];
                      ToolTipML=[DAN=Vis en liste med igangvërende kõbsordrer for kreditoren.;
                                 ENU=View a list of ongoing purchase orders for the vendor.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9307;
                      RunPageView=SORTING(Document Type,Buy-from Vendor No.);
                      RunPageLink=Buy-from Vendor No.=FIELD(No.);
                      Image=Document }
      { 63      ;2   ;Action    ;
                      CaptionML=[DAN=Returvareordrer;
                                 ENU=Return Orders];
                      ToolTipML=[DAN=èbn oversigten over igangvërende returordrer.;
                                 ENU=Open the list of ongoing return orders.];
                      ApplicationArea=#PurchReturnOrder;
                      RunObject=Page 9311;
                      RunPageView=SORTING(Document Type,Buy-from Vendor No.);
                      RunPageLink=Buy-from Vendor No.=FIELD(No.);
                      Image=ReturnOrder }
      { 58      ;2   ;Action    ;
                      CaptionML=[DAN=Rammeordrer;
                                 ENU=Blanket Orders];
                      ToolTipML=[DAN=èbn oversigten over igangvërende rammeordrer.;
                                 ENU=Open the list of ongoing blanket orders.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9310;
                      RunPageView=SORTING(Document Type,Buy-from Vendor No.);
                      RunPageLink=Buy-from Vendor No.=FIELD(No.);
                      Image=BlanketOrder }
      { 13      ;1   ;ActionGroup;
                      CaptionML=[DAN=Oversigt;
                                 ENU=History];
                      Image=History }
      { 22      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=Post&er;
                                 ENU=Ledger E&ntries];
                      ToolTipML=[DAN=Se historikken over transaktioner, der er bogfõrt for den valgte record.;
                                 ENU=View the history of transactions that have been posted for the selected record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 29;
                      RunPageView=SORTING(Vendor No.)
                                  ORDER(Descending);
                      RunPageLink=Vendor No.=FIELD(No.);
                      Promoted=Yes;
                      Image=VendorLedger;
                      PromotedCategory=Process }
      { 18      ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=FÜ vist statistiske oplysninger om recorden, f.eks. vërdien af bogfõrte poster.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 152;
                      RunPageLink=No.=FIELD(No.),
                                  Date Filter=FIELD(Date Filter),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 21      ;2   ;Action    ;
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
      { 19      ;2   ;Action    ;
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
      { 57      ;2   ;Action    ;
                      CaptionML=[DAN=&Valutastatistik;
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
                                 ItemTrackingDocMgt@1001 : Codeunit 6503;
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
                      Image=BlanketOrder;
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
                      Image=Quote;
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
                      Image=NewPurchaseInvoice;
                      PromotedCategory=Category4;
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
                      Image=Document;
                      PromotedCategory=Category4;
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
                      Image=CreditMemo;
                      PromotedCategory=Category4;
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
                      Image=ReturnOrder;
                      RunPageMode=Create }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 30      ;1   ;ActionGroup;
                      CaptionML=[DAN=Anmod om godkendelse;
                                 ENU=Request Approval];
                      Image=SendApprovalRequest }
      { 28      ;2   ;Action    ;
                      Name=SendApprovalRequest;
                      CaptionML=[DAN=Send godkendelsesan&modning;
                                 ENU=Send A&pproval Request];
                      ToolTipML=[DAN=Anmod om tilladelse til at ëndre recorden.;
                                 ENU=Request approval to change the record.];
                      ApplicationArea=#Advanced;
                      Enabled=NOT OpenApprovalEntriesExist AND CanRequestApprovalForFlow;
                      Image=SendApprovalRequest;
                      OnAction=VAR
                                 ApprovalsMgmt@1001 : Codeunit 1535;
                               BEGIN
                                 IF ApprovalsMgmt.CheckVendorApprovalsWorkflowEnabled(Rec) THEN
                                   ApprovalsMgmt.OnSendVendorForApproval(Rec);
                               END;
                                }
      { 17      ;2   ;Action    ;
                      Name=CancelApprovalRequest;
                      CaptionML=[DAN=Annuller godk&endelsesanmodning;
                                 ENU=Cancel Approval Re&quest];
                      ToolTipML=[DAN=Annuller godkendelsesanmodningen.;
                                 ENU=Cancel the approval request.];
                      ApplicationArea=#Advanced;
                      Enabled=CanCancelApprovalForRecord OR CanCancelApprovalForFlow;
                      Image=CancelApprovalRequest;
                      OnAction=VAR
                                 ApprovalsMgmt@1001 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.OnCancelVendorApprovalRequest(Rec);
                                 WorkflowWebhookManagement.FindAndCancel(RECORDID);
                               END;
                                }
      { 1902327104;1 ;Action    ;
                      CaptionML=[DAN=Udbetalingskladde;
                                 ENU=Payment Journal];
                      ToolTipML=[DAN=Vis eller rediger den udbetalingskladde, hvor du kan registrere betalinger til kreditorer.;
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
      { 48      ;1   ;Action    ;
                      Name=ApplyTemplate;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Anvend skabelon;
                                 ENU=Apply Template];
                      ToolTipML=[DAN=Anvend en skabelon for at opdatere en eller flere enheder med dine standardindstillinger for en bestemt enhedstype.;
                                 ENU=Apply a template to update one or more entities with your standard settings for a certain type of entity.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ApplyTemplate;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 Vendor@1000 : Record 23;
                                 MiniVendorTemplate@1001 : Record 1303;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(Vendor);
                                 MiniVendorTemplate.UpdateVendorsFromTemplate(Vendor);
                               END;
                                }
      { 46      ;1   ;ActionGroup;
                      CaptionML=[DAN=Vis;
                                 ENU=Display] }
      { 42      ;2   ;Action    ;
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
      { 50      ;1   ;ActionGroup;
                      CaptionML=[DAN=OCR;
                                 ENU=OCR] }
      { 52      ;2   ;Action    ;
                      Name=Resync;
                      CaptionML=[DAN=Synkroniser alle kreditorer igen;
                                 ENU=Resync all Vendors];
                      ToolTipML=[DAN=Synkroniser kreditorer og kreditorers bankkonti med OCR-tjenesten.;
                                 ENU=Synchronize vendors and vendor bank accounts with the OCR service.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=ResyncVisible;
                      Image=CopyFromChartOfAccounts;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 ReadSoftOCRMasterDataSync.SyncMasterData(TRUE,FALSE);
                               END;
                                }
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 3       ;1   ;ActionGroup;
                      CaptionML=[DAN=Generelt;
                                 ENU=General];
                      Image=Report }
      { 1900518506;2 ;Action    ;
                      CaptionML=[DAN=Kreditor - stamoplysninger;
                                 ENU=Vendor - List];
                      ToolTipML=[DAN=Vis diverse stamoplysninger om kreditorer, f.eks. kreditorbogfõringsgruppe, rabat- og betalingsoplysninger, prioritetsniveau, kreditors standardvaluta samt kreditorens aktuelle saldo (i RV). Rapporten kan f.eks. bruges til at vedligeholde oplysningerne i tabellen Kreditor.;
                                 ENU=View various kinds of basic information for vendors, such as vendor posting group, discount and payment information, priority level and the vendor's default currency, and the vendor's current balance (in LCY). The report can be used, for example, to maintain the information in the Vendor table.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 301;
                      Image=Report }
      { 1906328906;2 ;Action    ;
                      CaptionML=[DAN=Kreditorjournal;
                                 ENU=Vendor Register];
                      ToolTipML=[DAN=Vis kreditorposter, der er bogfõrt i forbindelse med en finansjournal. Posterne er opdelt i og sorteret efter finansjournaler. Ved hjëlp af et filter kan du vëlge prëcis de poster, du vil se. Rapporten kan bruges til at dokumentere indholdet af de forskellige journaler for intern eller ekstern revision.;
                                 ENU=View vendor ledger entries that have been posted in connection with a general ledger register. The entries are divided into, and sorted according to, G/L registers. By using a filter, you can select exactly the entries in the registers that you need to see. The report can be used to document the contents of the various registers for internal or external audits.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 303;
                      Image=Report }
      { 1906643406;2 ;Action    ;
                      CaptionML=[DAN=Kreditor/varer;
                                 ENU=Vendor Item Catalog];
                      ToolTipML=[DAN=Vis en liste over de varer, du kan kõbe hos dine kreditorer.;
                                 ENU=View a list of the items that your vendors supply.];
                      ApplicationArea=#Suite;
                      RunObject=Report 320;
                      Image=Report }
      { 1905916106;2 ;Action    ;
                      CaptionML=[DAN=Kreditor - etiketter;
                                 ENU=Vendor - Labels];
                      ToolTipML=[DAN=Vis adresseetiketter med navn og adresse pÜ kreditorer.;
                                 ENU=View mailing labels with the vendors' names and addresses.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 310;
                      Image=Report }
      { 1900497106;2 ;Action    ;
                      CaptionML=[DAN=Kreditor - top 10-liste;
                                 ENU=Vendor - Top 10 List];
                      ToolTipML=[DAN=Vis en liste over, hvilke kreditorer du kõber mest hos, eller som du skylder mest til.;
                                 ENU=View a list of the vendors from whom you purchase the most or to whom you owe the most.];
                      ApplicationArea=#Suite;
                      RunObject=Report 311;
                      Image=Report }
      { 5       ;1   ;ActionGroup;
                      CaptionML=[DAN=Ordrer;
                                 ENU=Orders];
                      Image=Report }
      { 1906294906;2 ;Action    ;
                      CaptionML=[DAN=Kreditor - ordreoversigt;
                                 ENU=Vendor - Order Summary];
                      ToolTipML=[DAN=Vis ordrebeholdningen (endnu ikke modtaget) pr. kreditor i tre perioder † 30 dage med udgangspunkt i en valgt dato. Desuden er der kolonner til ordrer fõr og efter de tre perioder og en kolonne med samlede ordrebeholdningen pr. kreditor. Rapporten kan f.eks. bruges til at analysere virksomhedens forventede kõbsmëngde.;
                                 ENU=View the order detail (the quantity not yet received) for each vendor in three periods of 30 days each, starting from a selected date. There are also columns with orders before and after the three periods and a column with the total order detail for each vendor. The report can be used to analyze a company's expected purchase volume.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 307;
                      Image=Report }
      { 1904076306;2 ;Action    ;
                      CaptionML=[DAN=Kreditor - ordrebeholdning;
                                 ENU=Vendor - Order Detail];
                      ToolTipML=[DAN=Vis en oversigt over varer fra alle kreditorer, der er bestilt, men som endnu ikke er leveret. Ordrebelõbet lëgges sammen for hver kreditor og for hele oversigten. Rapporten kan f.eks. bruges til at fÜ et kortsigtet overblik over omsëtningen eller til at analysere eventuelle leveringsproblemer.;
                                 ENU=View a list of items that have been ordered, but not yet received, from each vendor. The order amounts are totaled for each vendor and for the entire list. The report can be used, for example, to obtain an overview of purchases over the short term or to analyze possible receipt problems.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 308;
                      Image=Report }
      { 7       ;1   ;ActionGroup;
                      CaptionML=[DAN=Kõb;
                                 ENU=Purchase];
                      Image=Purchase }
      { 1907303206;2 ;Action    ;
                      CaptionML=[DAN=Kreditor - kõbsoversigt;
                                 ENU=Vendor - Purchase List];
                      ToolTipML=[DAN=Vis en liste over kreditorkõb for en valgt periode.;
                                 ENU=View a list of vendor purchases for a selected period.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 309;
                      Image=Report }
      { 1904498706;2 ;Action    ;
                      CaptionML=[DAN=Kreditor/varekõb;
                                 ENU=Vendor/Item Purchases];
                      ToolTipML=[DAN=Vis en liste over vareposter for hver kreditor i en valgt periode.;
                                 ENU=View a list of item entries for each vendor in a selected period.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 313;
                      Image=Report }
      { 1905448306;2 ;Action    ;
                      CaptionML=[DAN=Kõbsstatistik;
                                 ENU=Purchase Statistics];
                      ToolTipML=[DAN=Vis en liste over belõb for kõb, fakturarabat og kontantrabat i $ for hver kreditor.;
                                 ENU=View a list of amounts for purchases, invoice discount and payment discount in $ for each vendor.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 312;
                      Image=Report }
      { 9       ;1   ;ActionGroup;
                      CaptionML=[DAN=ùkonomistyring;
                                 ENU=Financial Management];
                      Image=Report }
      { 1905766406;2 ;Action    ;
                      CaptionML=[DAN=Afventende kreditorposter;
                                 ENU=Payments on Hold];
                      ToolTipML=[DAN=Vis en liste over alle de kreditorposter, hvor feltet Afvent er markeret.;
                                 ENU=View a list of all vendor ledger entries on which the On Hold field is marked.];
                      ApplicationArea=#Suite;
                      RunObject=Report 319;
                      Image=Report }
      { 1905685906;2 ;Action    ;
                      CaptionML=[DAN=Kreditor - forfaldsoversigt;
                                 ENU=Vendor - Summary Aging];
                      ToolTipML=[DAN=Vis, udskriv eller gem en oversigt over skyldige belõb til hver kreditor, opdelt i tre tidsperioder.;
                                 ENU=View, print, or save a summary of the payables owed to each vendor, divided into three time periods.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 305;
                      Image=Report }
      { 1905388206;2 ;Action    ;
                      CaptionML=[DAN=Aldersfordelt gëld;
                                 ENU=Aged Accounts Payable];
                      ToolTipML=[DAN=Vis en liste over forfaldne, udstÜende saldi for hver kreditor.;
                                 ENU=View a list of aged remaining balances for each vendor.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 322;
                      Image=Report }
      { 1904504206;2 ;Action    ;
                      CaptionML=[DAN=Kreditor - saldo til dato;
                                 ENU=Vendor - Balance to Date];
                      ToolTipML=[DAN=Se, udskriv eller gem en detaljeret balance til dato for udvalgte kreditorer.;
                                 ENU=View, print, or save a detail balance to date for selected vendors.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 321;
                      Image=Report }
      { 1906387606;2 ;Action    ;
                      CaptionML=[DAN=Kreditor - balance;
                                 ENU=Vendor - Trial Balance];
                      ToolTipML=[DAN=Vis start- og slutsaldi for kreditorer med poster i en bestemt periode. Rapporten kan bruges til at bekrëfte, at saldoen for en kreditorbogfõringsgruppe svarer til saldoen pÜ den tilsvarende finanskonto pÜ en bestemt dato.;
                                 ENU=View the beginning and ending balance for vendors with entries within a specified period. The report can be used to verify that the balance for a vendor posting group is equal to the balance on the corresponding general ledger account on a certain date.];
                      ApplicationArea=#Suite;
                      RunObject=Report 329;
                      Image=Report }
      { 1900639206;2 ;Action    ;
                      CaptionML=[DAN=Kreditor - kontokort;
                                 ENU=Vendor - Detail Trial Balance];
                      ToolTipML=[DAN=Vis en detaljeret rÜbalance for udvalgte kreditorer.;
                                 ENU=View a detail trial balance for selected vendors.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 304;
                      Image=Report }
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
                ToolTipML=[DAN=Angiver kreditorens navn. Du kan bruge op til 30 tegn, bÜde tal og bogstaver.;
                           ENU=Specifies the vendor's name. You can enter a maximum of 30 characters, both numbers and letters.];
                ApplicationArea=#All;
                SourceExpr=Name }

    { 41  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode for ansvarscenteret (f.eks. et distributionscenter), som er tildelt den involverede bruger, virksomhed, debitor eller kreditor.;
                           ENU=Specifies the code of the responsibility center, such as a distribution hub, that is associated with the involved user, company, customer, or vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Responsibility Center" }

    { 59  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den lagerlokation, hvor varer fra kreditoren som standard skal modtages.;
                           ENU=Specifies the warehouse location where items from the vendor must be received by default.];
                ApplicationArea=#Location;
                SourceExpr="Location Code" }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummer.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Post Code";
                Visible=FALSE }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressens land/omrÜde.;
                           ENU=Specifies the country/region of the address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Country/Region Code";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens telefonnummer.;
                           ENU=Specifies the vendor's telephone number.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Phone No." }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens faxnummer.;
                           ENU=Specifies the vendor's fax number.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Fax No.";
                Visible=FALSE }

    { 68  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens koncerninterne partnerkode.;
                           ENU=Specifies the vendor's intercompany partner code.];
                ApplicationArea=#Intercompany;
                SourceExpr="IC Partner Code";
                Visible=FALSE }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ den person, du normalt er i kontakt med, nÜr du handler med kreditoren.;
                           ENU=Specifies the name of the person you regularly contact when you do business with this vendor.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Contact }

    { 37  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken indkõber der er tilknyttet kreditoren.;
                           ENU=Specifies which purchaser is assigned to the vendor.];
                ApplicationArea=#Suite;
                SourceExpr="Purchaser Code";
                Visible=FALSE }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens markedstype for at knytte forretningstransaktioner, der er foretaget for denne kreditor, til den relevante finanskonto.;
                           ENU=Specifies the vendor's market type to link business transactions made for the vendor with the appropriate account in the general ledger.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Vendor Posting Group";
                Visible=FALSE }

    { 51  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens handelstype for at knytte transaktioner, der er foretaget for denne kreditoren, til den relevante finanskonto i overensstemmelse med den generelle bogfõringsopsëtning.;
                           ENU=Specifies the vendor's trade type to link transactions made for this vendor with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Gen. Bus. Posting Group";
                Visible=FALSE }

    { 49  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede debitors eller kreditors momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogfõringsopsëtning.;
                           ENU=Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Bus. Posting Group";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en formel, der beregner betalingens forfaldsdato, kontantrabatdato og kontantrabatbelõb.;
                           ENU=Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Terms Code";
                Visible=FALSE }

    { 45  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for de involverede renter i tilfëlde af sen betaling.;
                           ENU=Specifies the code for the involved finance charges in case of late payment.];
                ApplicationArea=#Advanced;
                SourceExpr="Fin. Charge Terms Code";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den valutakode, der som standard er indsat, nÜr du opretter kõbsdokumenter eller kladdelinjer til kreditoren.;
                           ENU=Specifies the currency code that is inserted by default when you create purchase documents or journal lines for the vendor.];
                ApplicationArea=#Suite;
                SourceExpr="Currency Code";
                Visible=FALSE }

    { 47  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det sprog, der bruges ved oversëttelse af angivet tekst i bilag til udenlandske forretningspartnere, f.eks. en beskrivelse af varen pÜ en ordrebekrëftelse.;
                           ENU=Specifies the language that is used when translating specified text on documents to foreign business partner, such as an item description on an order confirmation.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Language Code";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et alternativt navn, du kan bruge til at sõge efter den õnskede record, hvis du ikke kan huske vërdien i feltet Navn.;
                           ENU=Specifies an alternate name that you can use to search for the record in question when you cannot remember the value in the Name field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Search Name" }

    { 1102601000;2;Field  ;
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

    { 1102601002;2;Field  ;
                ToolTipML=[DAN=Angiver, hvornÜr kreditorkortet sidst blev ëndret.;
                           ENU=Specifies when the vendor card was last modified.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Last Date Modified";
                Visible=FALSE }

    { 1102601004;2;Field  ;
                ToolTipML=[DAN=Angiver, hvordan du kan udligne betalinger pÜ poster for denne kreditor.;
                           ENU=Specifies how to apply payments to entries for this vendor.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Application Method";
                Visible=FALSE }

    { 1102601006;2;Field  ;
                Name=Location Code2;
                ToolTipML=[DAN=Angiver den lagerlokation, hvor varer fra kreditoren som standard skal modtages.;
                           ENU=Specifies the warehouse location where items from the vendor must be received by default.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Visible=FALSE }

    { 1102601008;2;Field  ;
                ToolTipML=[DAN=Angiver betingelserne for levering af den relaterede leverance, som f.eks. frit ombord (FOB).;
                           ENU=Specifies the delivery conditions of the related shipment, such as free on board (FOB).];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Shipment Method Code";
                Visible=FALSE }

    { 1102601010;2;Field  ;
                ToolTipML=[DAN=Angiver en datoformel for det tidsrum, det tager at genbestille varen.;
                           ENU=Specifies a date formula for the amount of time it takes to replenish the item.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Lead Time Calculation";
                Visible=FALSE }

    { 1102601012;2;Field  ;
                ToolTipML=[DAN=Angiver en redigerbar kalender for leveringsplanlëgning, der indeholder kreditorens arbejdsdage og fridage.;
                           ENU=Specifies a customizable calendar for delivery planning that holds the vendor's working days and holidays.];
                ApplicationArea=#Advanced;
                SourceExpr="Base Calendar Code";
                Visible=FALSE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den samlede vërdi af dine gennemfõrte kõb fra kreditoren i det aktuelle regnskabsÜr. Den beregnes ud fra belõbene, ekskl. moms, pÜ alle afsluttede og Übne kõbsfakturaer og kreditnotaer.;
                           ENU=Specifies the total value of your completed purchases from the vendor in the current fiscal year. It is calculated from amounts excluding VAT on all completed purchase invoices and credit memos.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Balance (LCY)";
                OnDrillDown=BEGIN
                              OpenVendorLedgerEntries(FALSE);
                            END;
                             }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den samlede vërdi af dine ubetalte kõb fra kreditoren i det aktuelle regnskabsÜr. Den beregnes ud fra belõbene, ekskl. moms, pÜ alle Übne kõbsfakturaer og kreditnotaer.;
                           ENU=Specifies the total value of your unpaid purchases from the vendor in the current fiscal year. It is calculated from amounts excluding VAT on all open purchase invoices and credit memos.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Balance Due (LCY)";
                OnDrillDown=BEGIN
                              OpenVendorLedgerEntries(TRUE);
                            END;
                             }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 40  ;1   ;Part      ;
                Name=Power BI Report FactBox;
                CaptionML=[DAN=Power BI-rapporter;
                           ENU=Power BI Reports];
                ApplicationArea=#Basic,#Suite;
                PagePartID=Page6306;
                Visible=PowerBIVisible;
                PartType=Page }

    { 14  ;1   ;Part      ;
                ApplicationArea=#All;
                SubPageLink=Source Type=CONST(Vendor),
                            Source No.=FIELD(No.);
                PagePartID=Page875;
                Visible=SocialListeningVisible;
                PartType=Page }

    { 15  ;1   ;Part      ;
                ApplicationArea=#All;
                SubPageLink=Source Type=CONST(Vendor),
                            Source No.=FIELD(No.);
                PagePartID=Page876;
                Visible=SocialListeningSetupVisible;
                PartType=Page;
                UpdatePropagation=Both }

    { 1901138007;1;Part   ;
                Name=VendorDetailsFactBox;
                ApplicationArea=#Advanced;
                SubPageLink=No.=FIELD(No.),
                            Currency Filter=FIELD(Currency Filter),
                            Date Filter=FIELD(Date Filter),
                            Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                            Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
                PagePartID=Page9093;
                Visible=FALSE;
                PartType=Page }

    { 1904651607;1;Part   ;
                Name=VendorStatisticsFactBox;
                ApplicationArea=#Advanced;
                SubPageLink=No.=FIELD(No.),
                            Currency Filter=FIELD(Currency Filter),
                            Date Filter=FIELD(Date Filter),
                            Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                            Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
                PagePartID=Page9094;
                PartType=Page }

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
      PowerBIUserConfiguration@1005 : Record 6304;
      SetPowerBIUserConfig@1006 : Codeunit 6305;
      ApprovalsMgmt@1004 : Codeunit 1535;
      ReadSoftOCRMasterDataSync@1009 : Codeunit 884;
      WorkflowWebhookManagement@1012 : Codeunit 1543;
      SocialListeningSetupVisible@1003 : Boolean INDATASET;
      SocialListeningVisible@1002 : Boolean INDATASET;
      OpenApprovalEntriesExist@1001 : Boolean;
      CanCancelApprovalForRecord@1000 : Boolean;
      PowerBIVisible@1007 : Boolean;
      ResyncVisible@1008 : Boolean;
      CanRequestApprovalForFlow@1010 : Boolean;
      CanCancelApprovalForFlow@1011 : Boolean;

    [External]
    PROCEDURE GetSelectionFilter@3() : Text;
    VAR
      Vend@1001 : Record 23;
      SelectionFilterManagement@1002 : Codeunit 46;
    BEGIN
      CurrPage.SETSELECTIONFILTER(Vend);
      EXIT(SelectionFilterManagement.GetSelectionFilterForVendor(Vend));
    END;

    [External]
    PROCEDURE SetSelection@1(VAR Vend@1000 : Record 23);
    BEGIN
      CurrPage.SETSELECTIONFILTER(Vend);
    END;

    LOCAL PROCEDURE SetSocialListeningFactboxVisibility@2();
    VAR
      SocialListeningMgt@1000 : Codeunit 871;
    BEGIN
      SocialListeningMgt.GetVendFactboxVisibility(Rec,SocialListeningSetupVisible,SocialListeningVisible);
    END;

    LOCAL PROCEDURE SetVendorNoVisibilityOnFactBoxes@4();
    BEGIN
      CurrPage.VendorDetailsFactBox.PAGE.SetVendorNoVisibility(FALSE);
      CurrPage.VendorHistBuyFromFactBox.PAGE.SetVendorNoVisibility(FALSE);
      CurrPage.VendorHistPayToFactBox.PAGE.SetVendorNoVisibility(FALSE);
      CurrPage.VendorStatisticsFactBox.PAGE.SetVendorNoVisibility(FALSE);
    END;

    BEGIN
    END.
  }
}

