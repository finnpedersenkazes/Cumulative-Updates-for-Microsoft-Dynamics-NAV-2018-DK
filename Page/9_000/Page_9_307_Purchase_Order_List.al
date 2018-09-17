OBJECT Page 9307 Purchase Order List
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=K›bsordrer;
               ENU=Purchase Orders];
    SourceTable=Table38;
    SourceTableView=WHERE(Document Type=CONST(Order));
    DataCaptionFields=Buy-from Vendor No.;
    PageType=List;
    CardPageID=Purchase Order;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport‚r,Anmod om godkendelse,Udskriv;
                                ENU=New,Process,Report,Request Approval,Print];
    OnOpenPage=VAR
                 PurchasesPayablesSetup@1000 : Record 312;
               BEGIN
                 IF GETFILTER(Receive) <> '' THEN
                   FilterPartialReceived;

                 SetSecurityFilterOnRespCenter;

                 JobQueueActive := PurchasesPayablesSetup.JobQueueActive;

                 CopyBuyFromVendorFilter;
               END;

    OnFindRecord=BEGIN
                   EXIT(FIND(Which) AND ShowHeader);
                 END;

    OnNextRecord=VAR
                   NewStepCount@1000 : Integer;
                 BEGIN
                   REPEAT
                     NewStepCount := NEXT(Steps);
                   UNTIL (NewStepCount = 0) OR ShowHeader;

                   EXIT(NewStepCount);
                 END;

    OnAfterGetCurrRecord=BEGIN
                           SetControlAppearance;
                           CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102601026;1 ;ActionGroup;
                      CaptionML=[DAN=&Ordre;
                                 ENU=O&rder];
                      Image=Order }
      { 1102601035;2 ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      Promoted=No;
                      PromotedIsBig=No;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDocDim;
                               END;
                                }
      { 1102601028;2 ;Action    ;
                      Name=Statistics;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=F† vist statistiske oplysninger som f.eks. v‘rdien for bogf›rte poster til recorden.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Statistics;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 OpenPurchaseOrderStatistics;
                               END;
                                }
      { 18      ;2   ;Action    ;
                      Name=Approvals;
                      AccessByPermission=TableData 454=R;
                      CaptionML=[DAN=Godkendelser;
                                 ENU=Approvals];
                      ToolTipML=[DAN=F† vist en liste over records, der afventer godkendelse. Du kan f.eks. se, hvem der har anmodet om godkendelse af recorden, hvorn†r den blev sendt og hvorn†r den skal godkendes.;
                                 ENU=View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.];
                      ApplicationArea=#Suite;
                      Image=Approvals;
                      OnAction=VAR
                                 WorkflowsEntriesBuffer@1001 : Record 832;
                               BEGIN
                                 WorkflowsEntriesBuffer.RunWorkflowEntriesPage(RECORDID,DATABASE::"Purchase Header","Document Type","No.");
                               END;
                                }
      { 1102601030;2 ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 66;
                      RunPageLink=Document Type=FIELD(Document Type),
                                  No.=FIELD(No.),
                                  Document Line No.=CONST(0);
                      Image=ViewComments }
      { 7       ;1   ;ActionGroup;
                      CaptionML=[DAN=Dokumenter;
                                 ENU=Documents];
                      Image=Documents }
      { 1102601031;2 ;Action    ;
                      CaptionML=[DAN=Modtagelser;
                                 ENU=Receipts];
                      ToolTipML=[DAN=Vis en liste over bogf›rte k›bsmodtagelser for ordren.;
                                 ENU=View a list of posted purchase receipts for the order.];
                      ApplicationArea=#Suite;
                      RunObject=Page 145;
                      RunPageView=SORTING(Order No.);
                      RunPageLink=Order No.=FIELD(No.);
                      Promoted=No;
                      PromotedIsBig=No;
                      Image=PostedReceipts }
      { 1102601032;2 ;Action    ;
                      Name=PostedPurchaseInvoices;
                      CaptionML=[DAN=Fakturaer;
                                 ENU=Invoices];
                      ToolTipML=[DAN=Vis en liste med igangv‘rende k›bsfakturaer for ordren.;
                                 ENU=View a list of ongoing purchase invoices for the order.];
                      ApplicationArea=#Suite;
                      RunObject=Page 146;
                      RunPageView=SORTING(Order No.);
                      RunPageLink=Order No.=FIELD(No.);
                      Promoted=No;
                      PromotedIsBig=No;
                      Image=Invoice }
      { 1102601033;2 ;Action    ;
                      Name=PostedPurchasePrepmtInvoices;
                      CaptionML=[DAN=For&udbetalingsfakturaer;
                                 ENU=Prepa&yment Invoices];
                      ToolTipML=[DAN="Vis relaterede bogf›rte salgsfakturaer, der vedr›rer en forudbetaling. ";
                                 ENU="View related posted sales invoices that involve a prepayment. "];
                      ApplicationArea=#Prepayments;
                      RunObject=Page 146;
                      RunPageView=SORTING(Prepayment Order No.);
                      RunPageLink=Prepayment Order No.=FIELD(No.);
                      Image=PrepaymentInvoice }
      { 1102601034;2 ;Action    ;
                      CaptionML=[DAN=Forudbetalingskredi&tnotaer;
                                 ENU=Prepayment Credi&t Memos];
                      ToolTipML=[DAN="Vis relaterede bogf›rte kreditnotaer, der vedr›rer en forudbetaling. ";
                                 ENU="View related posted sales credit memos that involve a prepayment. "];
                      ApplicationArea=#Prepayments;
                      RunObject=Page 147;
                      RunPageView=SORTING(Prepayment Order No.);
                      RunPageLink=Prepayment Order No.=FIELD(No.);
                      Image=PrepaymentCreditMemo }
      { 8       ;1   ;ActionGroup;
                      CaptionML=[DAN=Lagersted;
                                 ENU=Warehouse];
                      Image=Warehouse }
      { 1102601039;2 ;Action    ;
                      CaptionML=[DAN=L&‘g-p†-lager/pluklinjer (lag.);
                                 ENU=In&vt. Put-away/Pick Lines];
                      ToolTipML=[DAN=F† vist ind- eller udg†ende varer p† l‘g-p†-lager- eller lagerplukningsbilag for overflytningsordren.;
                                 ENU=View items that are inbound or outbound on inventory put-away or inventory pick documents for the transfer order.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 5774;
                      RunPageView=SORTING(Source Document,Source No.,Location Code);
                      RunPageLink=Source Document=CONST(Purchase Order),
                                  Source No.=FIELD(No.);
                      Image=PickLines }
      { 1102601038;2 ;Action    ;
                      CaptionML=[DAN=Lagermodtagelseslinjer;
                                 ENU=Whse. Receipt Lines];
                      ToolTipML=[DAN=Vis igangv‘rende lagermodtagelser for bilaget, i avancerede lagerops‘tninger.;
                                 ENU=View ongoing warehouse receipts for the document, in advanced warehouse configurations.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7342;
                      RunPageView=SORTING(Source Type,Source Subtype,Source No.,Source Line No.);
                      RunPageLink=Source Type=CONST(39),
                                  Source Subtype=FIELD(Document Type),
                                  Source No.=FIELD(No.);
                      Image=ReceiptLines }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 9       ;1   ;ActionGroup;
                      CaptionML=[DAN=Udskriv;
                                 ENU=Print];
                      Image=Print }
      { 55      ;2   ;Action    ;
                      Name=Print;
                      Ellipsis=Yes;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=Forbered udskrivning af bilaget. Du f†r vist et anmodningsvindue for bilaget, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Prepare to print the document. The report request window for the document opens where you can specify what to include on the print-out.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Image=Print;
                      PromotedCategory=Category5;
                      OnAction=VAR
                                 PurchaseHeader@1000 : Record 38;
                               BEGIN
                                 PurchaseHeader := Rec;
                                 CurrPage.SETSELECTIONFILTER(PurchaseHeader);
                                 PurchaseHeader.PrintRecords(TRUE);
                               END;
                                }
      { 24      ;2   ;Action    ;
                      Name=Send;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Send;
                                 ENU=Send];
                      ToolTipML=[DAN=Klarg›r bilaget til afsendelse i henhold til kreditorens afsendelsesprofil, f.eks. vedh‘ftet til en mail. Vinduet Send dokument til vises, s† du kan bekr‘fte eller v‘lge en afsendelsesprofil f›rst.;
                                 ENU=Prepare to send the document according to the vendor's sending profile, such as attached to an email. The Send document to window opens first so you can confirm or select a sending profile.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=SendToMultiple;
                      PromotedCategory=Category5;
                      OnAction=VAR
                                 PurchaseHeader@1000 : Record 38;
                               BEGIN
                                 PurchaseHeader := Rec;
                                 CurrPage.SETSELECTIONFILTER(PurchaseHeader);
                                 PurchaseHeader.SendRecords;
                               END;
                                }
      { 10      ;1   ;ActionGroup;
                      CaptionML=[DAN=Frigiv;
                                 ENU=Release];
                      Image=ReleaseDoc }
      { 1102601021;2 ;Action    ;
                      Name=Release;
                      ShortCutKey=Ctrl+F9;
                      CaptionML=[DAN=&Frigiv;
                                 ENU=Re&lease];
                      ToolTipML=[DAN=Frigiv bilaget til n‘ste behandlingstrin. N†r et bilag frigives, bliver det inkluderet i alle disponeringsberegninger fra den dato, varerne forventes modtaget. Du skal gen†bne bilaget, f›r du kan foretage ‘ndringer i det.;
                                 ENU=Release the document to the next stage of processing. When a document is released, it will be included in all availability calculations from the expected receipt date of the items. You must reopen the document before you can make changes to it.];
                      ApplicationArea=#Advanced;
                      Image=ReleaseDoc;
                      OnAction=VAR
                                 ReleasePurchDoc@1000 : Codeunit 415;
                               BEGIN
                                 ReleasePurchDoc.PerformManualRelease(Rec);
                               END;
                                }
      { 1102601022;2 ;Action    ;
                      Name=Reopen;
                      CaptionML=[DAN=&bn igen;
                                 ENU=Re&open];
                      ToolTipML=[DAN=bn dokumentet igen for at ‘ndre det, efter at det er blevet godkendt. Godkendte dokumenter har status Frigivet og skal †bnes, f›r de kan ‘ndres;
                                 ENU=Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed];
                      ApplicationArea=#Suite;
                      Image=ReOpen;
                      OnAction=VAR
                                 ReleasePurchDoc@1001 : Codeunit 415;
                               BEGIN
                                 ReleasePurchDoc.PerformManualReopen(Rec);
                               END;
                                }
      { 1102601000;1 ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 1102601025;2 ;Action    ;
                      AccessByPermission=TableData 410=R;
                      CaptionML=[DAN=Send IC-k›bsordre;
                                 ENU=Send IC Purchase Order];
                      ToolTipML=[DAN=Send bilaget til den koncerninterne udbakke eller direkte til den koncerninterne partner, hvis automatisk transaktionsafsendelse er aktiveret.;
                                 ENU=Send the document to the intercompany outbox or directly to the intercompany partner if automatic transaction sending is enabled.];
                      ApplicationArea=#Intercompany;
                      Image=IntercompanyOrder;
                      OnAction=VAR
                                 ICInOutboxMgt@1000 : Codeunit 427;
                                 ApprovalsMgmt@1003 : Codeunit 1535;
                               BEGIN
                                 IF ApprovalsMgmt.PrePostApprovalCheckPurch(Rec) THEN
                                   ICInOutboxMgt.SendPurchDoc(Rec,FALSE);
                               END;
                                }
      { 19      ;1   ;ActionGroup;
                      CaptionML=[DAN=Anmod om godkendelse;
                                 ENU=Request Approval] }
      { 1102601018;2 ;Action    ;
                      Name=SendApprovalRequest;
                      CaptionML=[DAN=Send go&dkendelsesanmodning;
                                 ENU=Send A&pproval Request];
                      ToolTipML=[DAN=Anmod om godkendelse af bilaget.;
                                 ENU=Request approval of the document.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=NOT OpenApprovalEntriesExist AND CanRequestApprovalForFlow;
                      PromotedIsBig=Yes;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ApprovalsMgmt@1001 : Codeunit 1535;
                               BEGIN
                                 IF ApprovalsMgmt.CheckPurchaseApprovalPossible(Rec) THEN
                                   ApprovalsMgmt.OnSendPurchaseDocForApproval(Rec);
                               END;
                                }
      { 1102601019;2 ;Action    ;
                      Name=CancelApprovalRequest;
                      CaptionML=[DAN=Annuller godkendelsesan&modning;
                                 ENU=Cancel Approval Re&quest];
                      ToolTipML=[DAN=Annuller godkendelsesanmodningen.;
                                 ENU=Cancel the approval request.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=CanCancelApprovalForRecord OR CanCancelApprovalForFlow;
                      PromotedIsBig=Yes;
                      Image=CancelApprovalRequest;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ApprovalsMgmt@1001 : Codeunit 1535;
                                 WorkflowWebhookManagement@1000 : Codeunit 1543;
                               BEGIN
                                 ApprovalsMgmt.OnCancelPurchaseApprovalRequest(Rec);
                                 WorkflowWebhookManagement.FindAndCancel(RECORDID);
                               END;
                                }
      { 12      ;1   ;ActionGroup;
                      CaptionML=[DAN=Lagersted;
                                 ENU=Warehouse];
                      Image=Warehouse }
      { 1102601015;2 ;Action    ;
                      AccessByPermission=TableData 7316=R;
                      CaptionML=[DAN=Opr&et lagermodtagelse;
                                 ENU=Create &Whse. Receipt];
                      ToolTipML=[DAN=Opret en lagermodtagelse for at starte en l‘g-p†-lager-proces i henhold til en avanceret lagerops‘tning.;
                                 ENU=Create a warehouse receipt to start a receive and put-away process according to an advanced warehouse configuration.];
                      ApplicationArea=#Warehouse;
                      Image=NewReceipt;
                      OnAction=VAR
                                 GetSourceDocInbound@1001 : Codeunit 5751;
                               BEGIN
                                 GetSourceDocInbound.CreateFromPurchOrder(Rec);

                                 IF NOT FIND('=><') THEN
                                   INIT;
                               END;
                                }
      { 1102601016;2 ;Action    ;
                      AccessByPermission=TableData 7340=R;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Opret l&‘g-p†-lager (lager)/pluk (lager);
                                 ENU=Create Inventor&y Put-away/Pick];
                      ToolTipML=[DAN=Opret en l‘g-p†-lager-aktivitet eller et lagerpluk til h†ndtering af varer p† bilaget i overensstemmelse med en grundl‘ggende lagerops‘tning, der ikke kr‘ver lagermodtagelse eller leverancedokumenter.;
                                 ENU=Create an inventory put-away or inventory pick to handle items on the document according to a basic warehouse configuration that does not require warehouse receipt or shipment documents.];
                      ApplicationArea=#Warehouse;
                      Image=CreatePutawayPick;
                      OnAction=BEGIN
                                 CreateInvtPutAwayPick;

                                 IF NOT FIND('=><') THEN
                                   INIT;
                               END;
                                }
      { 50      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Bogf›ring;
                                 ENU=P&osting];
                      Image=Post }
      { 51      ;2   ;Action    ;
                      Name=TestReport;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kontroller;
                                 ENU=Test Report];
                      ToolTipML=[DAN=Vis en testrapport, s† du kan finde og rette eventuelle fejl, f›r du udf›rer den faktiske bogf›ring af kladden eller bilaget.;
                                 ENU=View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.];
                      ApplicationArea=#Advanced;
                      Image=TestReport;
                      OnAction=BEGIN
                                 ReportPrint.PrintPurchHeader(Rec);
                               END;
                                }
      { 52      ;2   ;Action    ;
                      Name=Post;
                      ShortCutKey=F9;
                      Ellipsis=Yes;
                      CaptionML=[DAN=B&ogf›r;
                                 ENU=P&ost];
                      ToolTipML=[DAN=F‘rdigg›r bilaget eller kladden ved at bogf›re bel›b og antal p† de relaterede konti i regnskaberne.;
                                 ENU=Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostOrder;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 PurchaseHeader@1003 : Record 38;
                                 PurchaseBatchPostMgt@1002 : Codeunit 1372;
                                 BatchProcessingMgt@1001 : Codeunit 1380;
                                 BatchPostParameterTypes@1000 : Codeunit 1370;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(PurchaseHeader);
                                 IF PurchaseHeader.COUNT > 1 THEN BEGIN
                                   BatchProcessingMgt.AddParameter(BatchPostParameterTypes.Invoice,TRUE);
                                   BatchProcessingMgt.AddParameter(BatchPostParameterTypes.Receive,TRUE);

                                   PurchaseBatchPostMgt.SetBatchProcessor(BatchProcessingMgt);
                                   PurchaseBatchPostMgt.RunWithUI(PurchaseHeader,COUNT,ReadyToPostQst);
                                 END ELSE
                                   SendToPosting(CODEUNIT::"Purch.-Post (Yes/No)");
                               END;
                                }
      { 16      ;2   ;Action    ;
                      Name=Preview;
                      CaptionML=[DAN=Vis bogf›ring;
                                 ENU=Preview Posting];
                      ToolTipML=[DAN=Gennemse de forskellige typer poster, der oprettes, n†r du bogf›rer bilaget eller kladden.;
                                 ENU=Review the different types of entries that will be created when you post the document or journal.];
                      ApplicationArea=#Suite;
                      Image=ViewPostedOrder;
                      OnAction=VAR
                                 PurchPostYesNo@1001 : Codeunit 91;
                               BEGIN
                                 PurchPostYesNo.Preview(Rec);
                               END;
                                }
      { 53      ;2   ;Action    ;
                      Name=PostAndPrint;
                      ShortCutKey=Shift+F9;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Bogf›r og &udskriv;
                                 ENU=Post and &Print];
                      ToolTipML=[DAN=F‘rdigg›r dokumentet eller kladden, og forbered udskrivning. V‘rdierne og m‘ngderne bogf›res p† de relevante konti. Du f†r vist et rapportanmodningsvindue, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostPrint;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 SendToPosting(CODEUNIT::"Purch.-Post + Print");
                               END;
                                }
      { 54      ;2   ;Action    ;
                      Name=PostBatch;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Masse&bogf›r;
                                 ENU=Post &Batch];
                      ToolTipML=[DAN=Bogf›r flere bilag p† ‚n gang. Der †bnes et anmodningsvindue, hvor du kan angive, hvilke bilag der skal bogf›res.;
                                 ENU=Post several documents at once. A report request window opens where you can specify which documents to post.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Image=PostBatch;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 REPORT.RUNMODAL(REPORT::"Batch Post Purchase Orders",TRUE,TRUE,Rec);
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 3       ;2   ;Action    ;
                      Name=RemoveFromJobQueue;
                      CaptionML=[DAN=Fjern fra opgavek›;
                                 ENU=Remove From Job Queue];
                      ToolTipML=[DAN=Fjern den planlagte behandling af denne record fra jobk›en.;
                                 ENU=Remove the scheduled processing of this record from the job queue.];
                      ApplicationArea=#Suite;
                      Visible=JobQueueActive;
                      Image=RemoveLine;
                      OnAction=BEGIN
                                 CancelBackgroundPosting;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Suite;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den kreditor, der leverede varerne.;
                           ENU=Specifies the name of the vendor who delivered the items.];
                ApplicationArea=#Advanced;
                SourceExpr="Buy-from Vendor No." }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bestillingsadressen for den relaterede kreditor.;
                           ENU=Specifies the order address of the related vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Order Address Code";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den kreditor, der leverede varerne.;
                           ENU=Specifies the name of the vendor who delivered the items.];
                ApplicationArea=#Suite;
                SourceExpr="Buy-from Vendor Name" }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kompensationsaftalens identifikationsnummer, som nogle gange kaldes RMA-nummeret (Returns Materials Authorization).;
                           ENU=Specifies the compensation agreement identification number, sometimes referred to as the RMA No. (Returns Materials Authorization).];
                ApplicationArea=#Advanced;
                SourceExpr="Vendor Authorization No." }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret p† den kreditor, der leverede varerne.;
                           ENU=Specifies the post code of the vendor who delivered the items.];
                ApplicationArea=#Advanced;
                SourceExpr="Buy-from Post Code";
                Visible=FALSE }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver byen for den kreditor, der leverede varerne.;
                           ENU=Specifies the city of the vendor who delivered the items.];
                ApplicationArea=#Advanced;
                SourceExpr="Buy-from Country/Region Code";
                Visible=FALSE }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† kontaktpersonen hos den kreditor, der leverede varerne.;
                           ENU=Specifies the name of the contact person at the vendor who delivered the items.];
                ApplicationArea=#Advanced;
                SourceExpr="Buy-from Contact";
                Visible=FALSE }

    { 163 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den kreditor, du har modtaget fakturaen fra.;
                           ENU=Specifies the number of the vendor that you received the invoice from.];
                ApplicationArea=#Advanced;
                SourceExpr="Pay-to Vendor No.";
                Visible=FALSE }

    { 161 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den kreditor, du har modtaget fakturaen fra.;
                           ENU=Specifies the name of the vendor who you received the invoice from.];
                ApplicationArea=#Advanced;
                SourceExpr="Pay-to Name";
                Visible=FALSE }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret for den kreditor, du har modtaget fakturaen fra.;
                           ENU=Specifies the post code of the vendor that you received the invoice from.];
                ApplicationArea=#Advanced;
                SourceExpr="Pay-to Post Code";
                Visible=FALSE }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressens lande-/omr†dekode.;
                           ENU=Specifies the country/region code of the address.];
                ApplicationArea=#Advanced;
                SourceExpr="Pay-to Country/Region Code";
                Visible=FALSE }

    { 151 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† en kontaktperson hos den kreditor, fakturaen er sendt fra.;
                           ENU=Specifies the name of the person to contact about an invoice from this vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Pay-to Contact";
                Visible=FALSE }

    { 147 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for en alternativ leveringsadresse, hvis du vil sende til en anden adresse end den, der er indsat automatisk. Dette felt bruges ogs† i tilf‘lde af direkte levering.;
                           ENU=Specifies a code for an alternate shipment address if you want to ship to another address than the one that has been entered automatically. This field is also used in case of drop shipment.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Code";
                Visible=FALSE }

    { 145 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† debitoren p† den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the customer at the address that the items are shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Name";
                Visible=FALSE }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret p† den adresse, som varerne leveres til.;
                           ENU=Specifies the postal code of the address that the items are shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Post Code";
                Visible=FALSE }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver lande-/omr†dekoden p† den adresse, som varerne leveres til.;
                           ENU=Specifies the country/region code of the address that the items are shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Country/Region Code";
                Visible=FALSE }

    { 135 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† kontaktpersonen p† den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the contact person at the address that the items are shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Contact";
                Visible=FALSE }

    { 131 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor bogf›ringen af k›bsdokumentet skal registreres.;
                           ENU=Specifies the date when the posting of the purchase document will be recorded.];
                ApplicationArea=#Suite;
                SourceExpr="Posting Date";
                Visible=FALSE }

    { 113 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 111 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 115 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for den lokation, som de bestilte varer skal placeres p† efter levering.;
                           ENU=Specifies a code for the location where you want the items to be placed when they are received.];
                ApplicationArea=#Location;
                SourceExpr="Location Code" }

    { 99  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken indk›ber der er knyttet til den aktuelle kreditor.;
                           ENU=Specifies which purchaser is assigned to the vendor.];
                ApplicationArea=#Suite;
                SourceExpr="Purchaser Code";
                Visible=FALSE }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der er ansvarlig for bilaget.;
                           ENU=Specifies the ID of the user who is responsible for the document.];
                ApplicationArea=#Advanced;
                SourceExpr="Assigned User ID" }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver valutakoden for bel›bene p† k›bslinjerne.;
                           ENU=Specifies the code of the currency of the amounts on the purchase lines.];
                ApplicationArea=#Suite;
                SourceExpr="Currency Code";
                Visible=FALSE }

    { 1102601001;2;Field  ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Suite;
                SourceExpr="Document Date" }

    { 1102601003;2;Field  ;
                ToolTipML=[DAN=Angiver, om recorden er †ben, afventer godkendelse, er faktureret til forudbetaling eller er frigivet til n‘ste fase i behandlingen.;
                           ENU=Specifies whether the record is open, waiting to be approved, invoiced for prepayment, or released to the next stage of processing.];
                ApplicationArea=#Advanced;
                SourceExpr=Status;
                Visible=FALSE }

    { 1102601005;2;Field  ;
                ToolTipML=[DAN=Angiver en formel, der beregner betalingens forfaldsdato, kontantrabatdato og kontantrabatbel›b.;
                           ENU=Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.];
                ApplicationArea=#Suite;
                SourceExpr="Payment Terms Code";
                Visible=FALSE }

    { 1102601007;2;Field  ;
                ToolTipML=[DAN=Angiver, hvorn†r k›bsfakturaen forfalder til betaling.;
                           ENU=Specifies when the purchase invoice is due for payment.];
                ApplicationArea=#Suite;
                SourceExpr="Due Date";
                Visible=FALSE }

    { 1102601009;2;Field  ;
                ToolTipML=[DAN=Angiver den rabatprocent, der tildeles, hvis betaling gennemf›res f›r eller p† den dato, der er angivet i feltet Kont.rabatdato.;
                           ENU=Specifies the payment discount percent granted if payment is made on or before the date in the Pmt. Discount Date field.];
                ApplicationArea=#Advanced;
                SourceExpr="Payment Discount %";
                Visible=FALSE }

    { 1102601011;2;Field  ;
                ToolTipML=[DAN=Angiver, hvordan betalingen skal foretages, f.eks. via bankoverf›rsel, kontant eller med check.;
                           ENU=Specifies how to make payment, such as with bank transfer, cash,  or check.];
                ApplicationArea=#Suite;
                SourceExpr="Payment Method Code";
                Visible=FALSE }

    { 1102601013;2;Field  ;
                ToolTipML=[DAN=Angiver betingelserne for levering af den relaterede leverance, som f.eks. frit ombord (FOB).;
                           ENU=Specifies the delivery conditions of the related shipment, such as free on board (FOB).];
                ApplicationArea=#Advanced;
                SourceExpr="Shipment Method Code";
                Visible=FALSE }

    { 1102601027;2;Field  ;
                ToolTipML=[DAN=Angiver den dato, som du har bedt kreditoren om at levere ordren p† til leveringsadressen. V‘rdien i feltet bruges til at beregne, hvilken dato du senest kan bestille varerne, hvis de skal v‘re leveret p† den ›nskede modtagelsesdato. Hvis det ikke er n›dvendigt med levering p† en bestemt dato, kan du lade feltet st† tomt.;
                           ENU=Specifies the date that you want the vendor to deliver to the ship-to address. The value in the field is used to calculate the latest date you can order the items to have them delivered on the requested receipt date. If you do not need delivery on a specific date, you can leave the field blank.];
                ApplicationArea=#Suite;
                SourceExpr="Requested Receipt Date";
                Visible=FALSE }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for en opgavek›post, der h†ndterer bogf›ring af k›bsordrer.;
                           ENU=Specifies the status of a job queue entry that handles the posting of purchase orders.];
                ApplicationArea=#Suite;
                SourceExpr="Job Queue Status";
                Visible=JobQueueActive }

    { 25  ;2   ;Field     ;
                Name=Amount Received Not Invoiced excl. VAT (LCY);
                ToolTipML=[DAN=Angiver bel›bet ekskl. moms for de bestilte varer, som er blevet modtaget, men endnu ikke faktureret.;
                           ENU=Specifies the amount excluding VAT for the items on the order that have been received but are not yet invoiced.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="A. Rcd. Not Inv. Ex. VAT (LCY)";
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                Name=Amount Received Not Invoiced (LCY);
                ToolTipML=[DAN=Angiver summen i RV for varer, der er modtaget, men endnu ikke er blevet faktureret. V‘rdien i feltet Bel›b modt. ufaktureret (RV) bruges til poster i tabellen K›bslinje med dokumenttypen Ordre til at beregne og opdatere indholdet i feltet.;
                           ENU=Specifies the sum, in LCY, for items that have been received but have not yet been invoiced. The value in the Amt. Rcd. Not Invoiced (LCY) field is used for entries in the Purchase Line table of document type Order to calculate and update the contents of this field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Amt. Rcd. Not Invoiced (LCY)";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver summen af bel›b i feltet Linjebel›b p† k›bsordrelinjerne.;
                           ENU=Specifies the sum of amounts in the Line Amount field on the purchase order lines.];
                ApplicationArea=#Suite;
                SourceExpr=Amount }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den samlede sum af bel›bene, herunder moms, p† alle dokumentets linjer.;
                           ENU=Specifies the total of the amounts, including VAT, on all the lines on the document.];
                ApplicationArea=#Suite;
                SourceExpr="Amount Including VAT" }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 14  ;1   ;Part      ;
                Name=IncomingDocAttachFactBox;
                ApplicationArea=#Suite;
                PagePartID=Page193;
                Visible=FALSE;
                PartType=Page;
                ShowFilter=No }

    { 1901138007;1;Part   ;
                ApplicationArea=#Suite;
                SubPageLink=No.=FIELD(Buy-from Vendor No.),
                            Date Filter=FIELD(Date Filter);
                PagePartID=Page9093;
                PartType=Page }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      ReportPrint@1102601001 : Codeunit 228;
      JobQueueActive@1003 : Boolean INDATASET;
      OpenApprovalEntriesExist@1002 : Boolean;
      CanCancelApprovalForRecord@1001 : Boolean;
      SkipLinesWithoutVAT@1000 : Boolean;
      ReadyToPostQst@1004 : TextConst '@@@=%1 - selected count, %2 - total count;DAN=%1 ud af %2 valgte ordrer er klar til bogf›ring. \Vil du forts‘tte og bogf›re dem?;ENU=%1 out of %2 selected orders are ready for post. \Do you want to continue and post them?';
      CanRequestApprovalForFlow@1005 : Boolean;
      CanCancelApprovalForFlow@1006 : Boolean;

    LOCAL PROCEDURE SetControlAppearance@5();
    VAR
      ApprovalsMgmt@1000 : Codeunit 1535;
      WorkflowWebhookManagement@1001 : Codeunit 1543;
    BEGIN
      OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);

      CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RECORDID);

      WorkflowWebhookManagement.GetCanRequestAndCanCancel(RECORDID,CanRequestApprovalForFlow,CanCancelApprovalForFlow);
    END;

    [External]
    PROCEDURE SkipShowingLinesWithoutVAT@2();
    BEGIN
      SkipLinesWithoutVAT := TRUE;
    END;

    LOCAL PROCEDURE ShowHeader@6() : Boolean;
    VAR
      CashFlowManagement@1000 : Codeunit 841;
    BEGIN
      IF NOT SkipLinesWithoutVAT THEN
        EXIT(TRUE);

      EXIT(CashFlowManagement.GetTaxAmountFromPurchaseOrder(Rec) <> 0);
    END;

    LOCAL PROCEDURE FilterPartialReceived@1();
    VAR
      PurchaseHeaderOriginal@1000 : Record 38;
      PurchaseLine@1002 : Record 39;
      ReceiveFilter@1004 : Text;
      IsMarked@1003 : Boolean;
      ReceiveValue@1001 : Boolean;
    BEGIN
      ReceiveFilter := GETFILTER(Receive);
      SETRANGE(Receive);
      EVALUATE(ReceiveValue,ReceiveFilter);

      PurchaseHeaderOriginal := Rec;
      IF FINDSET THEN
        REPEAT
          PurchaseLine.SETRANGE("Document Type","Document Type");
          PurchaseLine.SETRANGE("Document No.","No.");
          PurchaseLine.SETFILTER("Quantity Received",'<>%1',0);
          IsMarked := ReceiveValue AND NOT PurchaseLine.ISEMPTY;
          MARK(IsMarked);
        UNTIL NEXT = 0;

      Rec := PurchaseHeaderOriginal;
      MARKEDONLY(TRUE);
    END;

    BEGIN
    END.
  }
}

