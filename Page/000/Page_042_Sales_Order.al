OBJECT Page 42 Sales Order
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572,NAVDK11.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Salgsordre;
               ENU=Sales Order];
    SourceTable=Table36;
    SourceTableView=WHERE(Document Type=FILTER(Order));
    PageType=Document;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Godkend,Frigiv,Bogfõring,Forbered,Faktura,Anmod om godkendelse,Oversigt;
                                ENU=New,Process,Report,Approve,Release,Posting,Prepare,Invoice,Request Approval,History];
    OnInit=VAR
             SalesReceivablesSetup@1000 : Record 311;
           BEGIN
             JobQueuesUsed := SalesReceivablesSetup.JobQueueActive;
             SetExtDocNoMandatoryCondition;

             SellToCustomerUsesOIOUBL := CustomerUsesOIOUBL("Sell-to Customer No.")
           END;

    OnOpenPage=VAR
                 CRMIntegrationManagement@1000 : Codeunit 5330;
                 OfficeMgt@1001 : Codeunit 1630;
                 PermissionManager@1002 : Codeunit 9002;
               BEGIN
                 IF UserMgt.GetSalesFilter <> '' THEN BEGIN
                   FILTERGROUP(2);
                   SETRANGE("Responsibility Center",UserMgt.GetSalesFilter);
                   FILTERGROUP(0);
                 END;

                 SETRANGE("Date Filter",0D,WORKDATE - 1);

                 SetDocNoVisible;

                 CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
                 IsOfficeHost := OfficeMgt.IsAvailable;
                 IsSaas := PermissionManager.SoftwareAsAService;

                 IF "Quote No." <> '' THEN
                   ShowQuoteNo := TRUE;
                 IF ("No." <> '') AND ("Sell-to Customer No." = '') THEN
                   DocumentIsPosted := (NOT GET("Document Type","No."));
               END;

    OnAfterGetRecord=BEGIN
                       ShowQuoteNo := "Quote No." <> '';

                       SetControlVisibility;
                       UpdateShipToBillToGroupVisibility;
                       WorkDescription := GetWorkDescription;
                     END;

    OnNewRecord=BEGIN
                  xRec.INIT;
                  "Responsibility Center" := UserMgt.GetSalesFilter;
                  IF (NOT DocNoVisible) AND ("No." = '') THEN
                    SetSellToCustomerFromFilter;

                  SetDefaultPaymentServices;
                  UpdateShipToBillToGroupVisibility;
                END;

    OnInsertRecord=BEGIN
                     IF DocNoVisible THEN
                       CheckCreditMaxBeforeInsert;

                     IF ("Sell-to Customer No." = '') AND (GETFILTER("Sell-to Customer No.") <> '') THEN
                       CurrPage.UPDATE(FALSE);
                   END;

    OnDeleteRecord=BEGIN
                     CurrPage.SAVERECORD;
                     EXIT(ConfirmDeletion);
                   END;

    OnQueryClosePage=BEGIN
                       IF NOT DocumentIsPosted THEN
                         EXIT(ConfirmCloseUnposted);
                     END;

    OnAfterGetCurrRecord=VAR
                           SalesHeader@1001 : Record 36;
                           CRMCouplingManagement@1000 : Codeunit 5331;
                           CustCheckCrLimit@1002 : Codeunit 312;
                         BEGIN
                           DynamicEditable := CurrPage.EDITABLE;
                           SellToCustomerUsesOIOUBL := CustomerUsesOIOUBL("Sell-to Customer No.");
                           CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
                           CurrPage.ApprovalFactBox.PAGE.UpdateApprovalEntriesFromSourceRecord(RECORDID);
                           CRMIsCoupledToRecord := CRMIntegrationEnabled AND CRMCouplingManagement.IsRecordCoupledToCRM(RECORDID);
                           ShowWorkflowStatus := CurrPage.WorkflowStatus.PAGE.SetFilterOnWorkflowRecord(RECORDID);

                           UpdatePaymentService;
                           IF CallNotificationCheck THEN BEGIN
                             SalesHeader := Rec;
                             SalesHeader.CALCFIELDS("Amount Including VAT");
                             CustCheckCrLimit.SalesHeaderCheck(SalesHeader);
                             CheckItemAvailabilityInLines;
                             CallNotificationCheck := FALSE;
                           END;
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 59      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Ordre;
                                 ENU=O&rder];
                      Image=Order }
      { 61      ;2   ;Action    ;
                      Name=Statistics;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=Vis statistiske oplysninger sÜsom vërdien for bogfõrte poster til recorden.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 Handled@1000 : Boolean;
                               BEGIN
                                 OnBeforeStatisticsAction(Rec,Handled);
                                 IF NOT Handled THEN BEGIN
                                   OpenSalesOrderStatistics;
                                   SalesCalcDiscountByType.ResetRecalculateInvoiceDisc(Rec);
                                 END
                               END;
                                }
      { 62      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Debitor;
                                 ENU=Customer];
                      ToolTipML=[DAN=Se eller rediger detaljerede oplysninger om debitoren i salgsbilaget.;
                                 ENU=View or edit detailed information about the customer on the sales document.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 21;
                      RunPageLink=No.=FIELD(Sell-to Customer No.);
                      Enabled=IsCustomerOrContactNotEmpty;
                      Image=Customer }
      { 122     ;2   ;Action    ;
                      Name=Dimensions;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omrÜde, projekt eller afdeling, som du kan tildele til salgs- og kõbsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      Enabled="No." <> '';
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDocDim;
                                 CurrPage.SAVERECORD;
                               END;
                                }
      { 78      ;2   ;Action    ;
                      Name=Approvals;
                      AccessByPermission=TableData 454=R;
                      CaptionML=[DAN=Godkendelser;
                                 ENU=Approvals];
                      ToolTipML=[DAN=FÜ vist en liste over records, der afventer godkendelse. Du kan f.eks. se, hvem der har anmodet om godkendelse af recorden, hvornÜr den blev sendt og hvornÜr den skal godkendes.;
                                 ENU=View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Image=Approvals;
                      PromotedCategory=Category9;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 WorkflowsEntriesBuffer@1000 : Record 832;
                               BEGIN
                                 WorkflowsEntriesBuffer.RunWorkflowEntriesPage(RECORDID,DATABASE::"Sales Header","Document Type","No.");
                               END;
                                }
      { 63      ;2   ;Action    ;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 67;
                      RunPageLink=Document Type=FIELD(Document Type),
                                  No.=FIELD(No.),
                                  Document Line No.=CONST(0);
                      Image=ViewComments }
      { 11      ;2   ;Action    ;
                      Name=AssemblyOrders;
                      AccessByPermission=TableData 90=R;
                      CaptionML=[DAN=Montageordrer;
                                 ENU=Assembly Orders];
                      ToolTipML=[DAN="Vis igangvërende montageordrer, der er relateret til salgsordren. ";
                                 ENU="View ongoing assembly orders related to the sales order. "];
                      ApplicationArea=#Assembly;
                      Image=AssemblyOrder;
                      OnAction=VAR
                                 AssembleToOrderLink@1000 : Record 904;
                               BEGIN
                                 AssembleToOrderLink.ShowAsmOrders(Rec);
                               END;
                                }
      { 79      ;1   ;ActionGroup;
                      Name=ActionGroupCRM;
                      CaptionML=[DAN=Dynamics 365 for Sales;
                                 ENU=Dynamics 365 for Sales];
                      Visible=CRMIntegrationEnabled }
      { 71      ;2   ;Action    ;
                      Name=CRMGoToSalesOrder;
                      CaptionML=[DAN=Salgsordre;
                                 ENU=Sales Order];
                      ToolTipML=[DAN=FÜ vist den valgte salgsordre.;
                                 ENU=View the selected sales order.];
                      ApplicationArea=#Basic,#Suite;
                      Enabled=CRMIntegrationEnabled AND CRMIsCoupledToRecord;
                      Image=CoupledOrder;
                      OnAction=VAR
                                 CRMIntegrationManagement@1000 : Codeunit 5330;
                               BEGIN
                                 CRMIntegrationManagement.ShowCRMEntityFromRecordID(RECORDID);
                               END;
                                }
      { 13      ;1   ;ActionGroup;
                      CaptionML=[DAN=Dokumenter;
                                 ENU=Documents];
                      Image=Documents }
      { 64      ;2   ;Action    ;
                      CaptionML=[DAN=&Leverancer;
                                 ENU=S&hipments];
                      ToolTipML=[DAN=Vis relaterede bogfõrte salgsleverancer.;
                                 ENU=View related posted sales shipments.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 142;
                      RunPageView=SORTING(Order No.);
                      RunPageLink=Order No.=FIELD(No.);
                      Image=Shipment }
      { 65      ;2   ;Action    ;
                      CaptionML=[DAN=Fakturaer;
                                 ENU=Invoices];
                      ToolTipML=[DAN=Vis en liste med igangvërende salgsfakturaer for ordren.;
                                 ENU=View a list of ongoing sales invoices for the order.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 143;
                      RunPageView=SORTING(Order No.);
                      RunPageLink=Order No.=FIELD(No.);
                      Image=Invoice }
      { 15      ;1   ;ActionGroup;
                      CaptionML=[DAN=Lagersted;
                                 ENU=Warehouse];
                      Image=Warehouse }
      { 150     ;2   ;Action    ;
                      CaptionML=[DAN=L&ëg-pÜ-lager/pluklinjer (lag.);
                                 ENU=In&vt. Put-away/Pick Lines];
                      ToolTipML=[DAN=FÜ vist ind- eller udgÜende varer pÜ lëg-pÜ-lager- eller lagerplukningsbilag for overflytningsordren.;
                                 ENU=View items that are inbound or outbound on inventory put-away or inventory pick documents for the transfer order.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 5774;
                      RunPageView=SORTING(Source Document,Source No.,Location Code);
                      RunPageLink=Source Document=CONST(Sales Order),
                                  Source No.=FIELD(No.);
                      Image=PickLines }
      { 168     ;2   ;Action    ;
                      CaptionML=[DAN=Lagerleverancelinjer;
                                 ENU=Whse. Shipment Lines];
                      ToolTipML=[DAN=Vis igangvërende lagerleverancer for bilaget, i avancerede lageropsëtninger.;
                                 ENU=View ongoing warehouse shipments for the document, in advanced warehouse configurations.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7341;
                      RunPageView=SORTING(Source Type,Source Subtype,Source No.,Source Line No.);
                      RunPageLink=Source Type=CONST(37),
                                  Source Subtype=FIELD(Document Type),
                                  Source No.=FIELD(No.);
                      Image=ShipmentLines }
      { 17      ;1   ;ActionGroup;
                      CaptionML=[DAN=Forudbetaling;
                                 ENU=Prepayment];
                      Image=Prepayment }
      { 234     ;2   ;Action    ;
                      Name=PagePostedSalesPrepaymentInvoices;
                      CaptionML=[DAN=For&udbetalingsfakturaer;
                                 ENU=Prepa&yment Invoices];
                      ToolTipML=[DAN="Vis relaterede bogfõrte salgsfakturaer, der vedrõrer en forudbetaling. ";
                                 ENU="View related posted sales invoices that involve a prepayment. "];
                      ApplicationArea=#Prepayments;
                      RunObject=Page 143;
                      RunPageView=SORTING(Prepayment Order No.);
                      RunPageLink=Prepayment Order No.=FIELD(No.);
                      Image=PrepaymentInvoice }
      { 235     ;2   ;Action    ;
                      Name=PagePostedSalesPrepaymentCrMemos;
                      CaptionML=[DAN=Forudbetalingskred&itnotaer;
                                 ENU=Prepayment Credi&t Memos];
                      ToolTipML=[DAN="Vis relaterede bogfõrte kreditnotaer, der vedrõrer en forudbetaling. ";
                                 ENU="View related posted sales credit memos that involve a prepayment. "];
                      ApplicationArea=#Prepayments;
                      RunObject=Page 144;
                      RunPageView=SORTING(Prepayment Order No.);
                      RunPageLink=Prepayment Order No.=FIELD(No.);
                      Image=PrepaymentCreditMemo }
      { 108     ;1   ;ActionGroup;
                      CaptionML=[DAN=Oversigt;
                                 ENU=History] }
      { 110     ;2   ;Action    ;
                      Name=PageInteractionLogEntries;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=Interaktionslogp&oster;
                                 ENU=Interaction Log E&ntries];
                      ToolTipML=[DAN=Vis en oversigt over interaktionslogposter i forbindelse med dette dokument.;
                                 ENU=View a list of interaction log entries related to this document.];
                      ApplicationArea=#Suite;
                      Image=InteractionLog;
                      PromotedCategory=Category10;
                      OnAction=BEGIN
                                 ShowInteractionLogEntries;
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 47      ;1   ;ActionGroup;
                      CaptionML=[DAN=Godkendelse;
                                 ENU=Approval] }
      { 43      ;2   ;Action    ;
                      Name=Approve;
                      CaptionML=[DAN=Godkend;
                                 ENU=Approve];
                      ToolTipML=[DAN=Godkend de anmodede ëndringer.;
                                 ENU=Approve the requested changes.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Visible=OpenApprovalEntriesExistForCurrUser;
                      PromotedIsBig=Yes;
                      Image=Approve;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.ApproveRecordApprovalRequest(RECORDID);
                               END;
                                }
      { 41      ;2   ;Action    ;
                      Name=Reject;
                      CaptionML=[DAN=Afvis;
                                 ENU=Reject];
                      ToolTipML=[DAN=Afvis godkendelsesanmodningen.;
                                 ENU=Reject the approval request.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Visible=OpenApprovalEntriesExistForCurrUser;
                      PromotedIsBig=Yes;
                      Image=Reject;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.RejectRecordApprovalRequest(RECORDID);
                               END;
                                }
      { 39      ;2   ;Action    ;
                      Name=Delegate;
                      CaptionML=[DAN=Uddeleger;
                                 ENU=Delegate];
                      ToolTipML=[DAN=Uddeleger godkendelsen til en stedfortrëdende godkender.;
                                 ENU=Delegate the approval to a substitute approver.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Visible=OpenApprovalEntriesExistForCurrUser;
                      Image=Delegate;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.DelegateRecordApprovalRequest(RECORDID);
                               END;
                                }
      { 37      ;2   ;Action    ;
                      Name=Comment;
                      CaptionML=[DAN=Bemërkninger;
                                 ENU=Comments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Visible=OpenApprovalEntriesExistForCurrUser;
                      Image=ViewComments;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.GetApprovalComment(Rec);
                               END;
                                }
      { 21      ;1   ;ActionGroup;
                      CaptionML=[DAN=Frigiv;
                                 ENU=Release];
                      Image=ReleaseDoc }
      { 133     ;2   ;Action    ;
                      Name=Release;
                      ShortCutKey=Ctrl+F9;
                      CaptionML=[DAN=&Frigiv;
                                 ENU=Re&lease];
                      ToolTipML=[DAN=Frigiv bilaget til nëste behandlingstrin. NÜr et bilag frigives, bliver det inkluderet i alle disponeringsberegninger fra den dato, varerne forventes modtaget. Du skal genÜbne bilaget, fõr du kan foretage ëndringer i det.;
                                 ENU=Release the document to the next stage of processing. When a document is released, it will be included in all availability calculations from the expected receipt date of the items. You must reopen the document before you can make changes to it.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Image=ReleaseDoc;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 ReleaseSalesDoc@1000 : Codeunit 414;
                               BEGIN
                                 ReleaseSalesDoc.PerformManualRelease(Rec);
                               END;
                                }
      { 134     ;2   ;Action    ;
                      Name=Reopen;
                      CaptionML=[DAN=&èbn igen;
                                 ENU=Re&open];
                      ToolTipML=[DAN=èbn bilaget igen for at ëndre det, efter at det er blevet godkendt. Godkendte bilag har status Frigivet og skal Übnes, fõr de kan ëndres;
                                 ENU=Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=Status <> Status::Open;
                      Image=ReOpen;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ReleaseSalesDoc@1001 : Codeunit 414;
                               BEGIN
                                 ReleaseSalesDoc.PerformManualReopen(Rec);
                               END;
                                }
      { 66      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 102     ;2   ;ActionGroup;
                      CaptionML=[DAN=Opret kõbsdokument;
                                 ENU=Create Purchase Document];
                      ToolTipML=[DAN=Opret et nyt kõbsdokument, sÜ du kan kõbe varer fra en kreditor.;
                                 ENU=Create a new purchase document so you can buy items from a vendor.];
                      Image=NewPurchaseInvoice }
      { 104     ;3   ;Action    ;
                      Name=CreatePurchaseOrder;
                      CaptionML=[DAN=Opret kõbsordrer;
                                 ENU=Create Purchase Orders];
                      ToolTipML=[DAN=Opret en eller flere nye indkõbsordrer for at kõbe de varer, der krëves af dette salgsdokument minus eventuelle antal, der allerede er tilgëngelige.;
                                 ENU=Create one or more new purchase orders to buy the items that are required by this sales document, minus any quantity that is already available.];
                      ApplicationArea=#Suite;
                      Promoted=No;
                      PromotedIsBig=Yes;
                      Image=Document;
                      PromotedCategory=Category8;
                      OnAction=VAR
                                 PurchDocFromSalesDoc@1000 : Codeunit 1314;
                               BEGIN
                                 PurchDocFromSalesDoc.CreatePurchaseOrder(Rec);
                               END;
                                }
      { 87      ;3   ;Action    ;
                      Name=CreatePurchaseInvoice;
                      CaptionML=[DAN=Opret kõbsfaktura;
                                 ENU=Create Purchase Invoice];
                      ToolTipML=[DAN=Opret en ny kõbsfaktura for at kõbe alle varer, der krëves af salgsdokumentet, selvom nogle af varerne allerede er tilgëngelige.;
                                 ENU=Create a new purchase invoice to buy all the items that are required by the sales document, even if some of the items are already available.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=No;
                      PromotedIsBig=Yes;
                      Image=NewPurchaseInvoice;
                      PromotedCategory=Category8;
                      OnAction=VAR
                                 SelectedSalesLine@1001 : Record 37;
                                 PurchDocFromSalesDoc@1000 : Codeunit 1314;
                               BEGIN
                                 CurrPage.SalesLines.PAGE.SETSELECTIONFILTER(SelectedSalesLine);
                                 PurchDocFromSalesDoc.CreatePurchaseInvoice(Rec,SelectedSalesLine);
                               END;
                                }
      { 67      ;2   ;Action    ;
                      Name=CalculateInvoiceDiscount;
                      AccessByPermission=TableData 19=R;
                      CaptionML=[DAN=&Beregn fakturarabat;
                                 ENU=Calculate &Invoice Discount];
                      ToolTipML=[DAN=Beregn fakturarabatten for salgsordren.;
                                 ENU=Calculate the invoice discount that applies to the sales order.];
                      ApplicationArea=#Basic,#Suite;
                      Image=CalculateInvoiceDiscount;
                      OnAction=BEGIN
                                 ApproveCalcInvDisc;
                                 SalesCalcDiscountByType.ResetRecalculateInvoiceDisc(Rec);
                               END;
                                }
      { 167     ;2   ;Action    ;
                      Name=GetRecurringSalesLines;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Hent tilbagevendende salgslinjer;
                                 ENU=Get Recurring Sales Lines];
                      ToolTipML=[DAN=Indsët salgsbilagslinjer, som du har angivet for debitoren som tilbagevendende. Tilbagevendende salgslinjer kan vëre en mÜnedlig genbestillingsordre eller en fast fragtudgift.;
                                 ENU=Insert sales document lines that you have set up for the customer as recurring. Recurring sales lines could be for a monthly replenishment order or a fixed freight expense.];
                      ApplicationArea=#Suite;
                      Image=CustomerCode;
                      OnAction=VAR
                                 StdCustSalesCode@1000 : Record 172;
                               BEGIN
                                 StdCustSalesCode.InsertSalesLines(Rec);
                               END;
                                }
      { 68      ;2   ;Action    ;
                      Name=CopyDocument;
                      Ellipsis=Yes;
                      CaptionML=[DAN=KopiÇr dokument;
                                 ENU=Copy Document];
                      ToolTipML=[DAN=KopiÇr linjer og sidehovedoplysninger fra et andet salgsdokument til dette dokument. Du kan kopiere en bogfõrt salgsfaktura til en ny salgsfaktura, hvis du hurtigt vil oprette et lignende dokument.;
                                 ENU=Copy document lines and header information from another sales document to this document. You can copy a posted sales invoice into a new sales invoice to quickly create a similar document.];
                      ApplicationArea=#Suite;
                      Image=CopyDocument;
                      OnAction=BEGIN
                                 CopySalesDoc.SetSalesHeader(Rec);
                                 CopySalesDoc.RUNMODAL;
                                 CLEAR(CopySalesDoc);
                                 IF GET("Document Type","No.") THEN;
                               END;
                                }
      { 154     ;2   ;Action    ;
                      Name=MoveNegativeLines;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Flyt negative linjer;
                                 ENU=Move Negative Lines];
                      ToolTipML=[DAN=Gõr dig klar til at oprette en erstatningssalgsordre i en salgsreturproces.;
                                 ENU=Prepare to create a replacement sales order in a sales return process.];
                      ApplicationArea=#Advanced;
                      Image=MoveNegativeLines;
                      OnAction=BEGIN
                                 CLEAR(MoveNegSalesLines);
                                 MoveNegSalesLines.SetSalesHeader(Rec);
                                 MoveNegSalesLines.RUNMODAL;
                                 MoveNegSalesLines.ShowDocument;
                               END;
                                }
      { 196     ;2   ;Action    ;
                      Name=Archive Document;
                      CaptionML=[DAN=&Arkiver dokument;
                                 ENU=Archi&ve Document];
                      ToolTipML=[DAN=Send bilaget til arkivet, f.eks. fordi det er for tidligt at slette det. Senere skal du slette eller genbehandle det arkiverede bilag.;
                                 ENU=Send the document to the archive, for example because it is too soon to delete it. Later, you delete or reprocess the archived document.];
                      ApplicationArea=#Advanced;
                      Image=Archive;
                      OnAction=BEGIN
                                 ArchiveManagement.ArchiveSalesDocument(Rec);
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 204     ;2   ;Action    ;
                      AccessByPermission=TableData 410=R;
                      CaptionML=[DAN=Send IC-salgsordre;
                                 ENU=Send IC Sales Order];
                      ToolTipML=[DAN=Send salgsordren til den koncerninterne udbakke eller direkte til den koncerninterne partner, hvis automatisk transaktionsafsendelse er aktiveret.;
                                 ENU=Send the sales order to the intercompany outbox or directly to the intercompany partner if automatic transaction sending is enabled.];
                      ApplicationArea=#Intercompany;
                      Image=IntercompanyOrder;
                      OnAction=VAR
                                 ICInOutboxMgt@1000 : Codeunit 427;
                                 ApprovalsMgmt@1003 : Codeunit 1535;
                               BEGIN
                                 IF ApprovalsMgmt.PrePostApprovalCheckSales(Rec) THEN
                                   ICInOutboxMgt.SendSalesDoc(Rec,FALSE);
                               END;
                                }
      { 69      ;2   ;ActionGroup;
                      Name=IncomingDocument;
                      CaptionML=[DAN=IndgÜende bilag;
                                 ENU=Incoming Document];
                      ActionContainerType=NewDocumentItems;
                      Image=Documents }
      { 60      ;3   ;Action    ;
                      Name=IncomingDocCard;
                      CaptionML=[DAN=Vis indgÜende bilag;
                                 ENU=View Incoming Document];
                      ToolTipML=[DAN=Se alle indgÜende bilagsrecords og vedhëftede filer, der findes for posten eller bilaget.;
                                 ENU=View any incoming document records and file attachments that exist for the entry or document.];
                      ApplicationArea=#Basic,#Suite;
                      Enabled=HasIncomingDocument;
                      Image=ViewOrder;
                      OnAction=VAR
                                 IncomingDocument@1000 : Record 130;
                               BEGIN
                                 IncomingDocument.ShowCardFromEntryNo("Incoming Document Entry No.");
                               END;
                                }
      { 57      ;3   ;Action    ;
                      Name=SelectIncomingDoc;
                      AccessByPermission=TableData 130=R;
                      CaptionML=[DAN=Vëlg indgÜende bilag;
                                 ENU=Select Incoming Document];
                      ToolTipML=[DAN=Vëlg en indgÜende bilagsrecord og vedhëftet fil, der skal knyttes til posten eller bilaget.;
                                 ENU=Select an incoming document record and file attachment that you want to link to the entry or document.];
                      ApplicationArea=#Basic,#Suite;
                      Image=SelectLineToApply;
                      OnAction=VAR
                                 IncomingDocument@1000 : Record 130;
                               BEGIN
                                 VALIDATE("Incoming Document Entry No.",IncomingDocument.SelectIncomingDocument("Incoming Document Entry No.",RECORDID));
                               END;
                                }
      { 55      ;3   ;Action    ;
                      Name=IncomingDocAttachFile;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Opret indgÜende bilag ud fra fil;
                                 ENU=Create Incoming Document from File];
                      ToolTipML=[DAN=Opret en indgÜende bilagsrecord ved at vëlge en fil, der skal vedhëftes, og knyt derefter den indgÜende bilagsrecord til posten eller bilaget.;
                                 ENU=Create an incoming document record by selecting a file to attach, and then link the incoming document record to the entry or document.];
                      ApplicationArea=#Basic,#Suite;
                      Enabled=NOT HasIncomingDocument;
                      Image=Attach;
                      OnAction=VAR
                                 IncomingDocumentAttachment@1000 : Record 133;
                               BEGIN
                                 IncomingDocumentAttachment.NewAttachmentFromSalesDocument(Rec);
                               END;
                                }
      { 53      ;3   ;Action    ;
                      Name=RemoveIncomingDoc;
                      CaptionML=[DAN=Fjern indgÜende bilag;
                                 ENU=Remove Incoming Document];
                      ToolTipML=[DAN=Fjern eventuelle indgÜende bilagsrecords og vedhëftede filer.;
                                 ENU=Remove any incoming document records and file attachments.];
                      ApplicationArea=#Basic,#Suite;
                      Enabled=HasIncomingDocument;
                      Image=RemoveLine;
                      OnAction=VAR
                                 IncomingDocument@1000 : Record 130;
                               BEGIN
                                 IF IncomingDocument.GET("Incoming Document Entry No.") THEN
                                   IncomingDocument.RemoveLinkToRelatedRecord;
                                 "Incoming Document Entry No." := 0;
                                 MODIFY(TRUE);
                               END;
                                }
      { 23      ;1   ;ActionGroup;
                      CaptionML=[DAN=Planlëg;
                                 ENU=Plan];
                      Image=Planning }
      { 197     ;2   ;Action    ;
                      Name=OrderPromising;
                      AccessByPermission=TableData 99000880=R;
                      CaptionML=[DAN=Beregning af leverings&tid;
                                 ENU=Order &Promising];
                      ToolTipML=[DAN=Beregn afsendelses- og leveringsdatoerne ud fra varens kendte og forventede tilgëngelighedsdatoer, og oplys derefter datoerne til debitoren.;
                                 ENU=Calculate the shipment and delivery dates based on the item's known and expected availability dates, and then promise the dates to the customer.];
                      ApplicationArea=#Planning;
                      Image=OrderPromising;
                      OnAction=VAR
                                 OrderPromisingLine@1000 : TEMPORARY Record 99000880;
                               BEGIN
                                 OrderPromisingLine.SETRANGE("Source Type","Document Type");
                                 OrderPromisingLine.SETRANGE("Source ID","No.");
                                 PAGE.RUNMODAL(PAGE::"Order Promising Lines",OrderPromisingLine);
                               END;
                                }
      { 248     ;2   ;Action    ;
                      CaptionML=[DAN=Behovsoversigt;
                                 ENU=Demand Overview];
                      ToolTipML=[DAN=FÜ et overblik over behovet for dine varer ved planlëgning af salg, produktion, sager eller servicestyring, og hvornÜr de er tilgëngelige.;
                                 ENU=Get an overview of demand for your items when planning sales, production, jobs, or service management and when they will be available.];
                      ApplicationArea=#Advanced;
                      Image=Forecast;
                      OnAction=VAR
                                 DemandOverview@1000 : Page 5830;
                               BEGIN
                                 DemandOverview.SetCalculationParameter(TRUE);
                                 DemandOverview.Initialize(0D,1,"No.",'','');
                                 DemandOverview.RUNMODAL;
                               END;
                                }
      { 121     ;2   ;Action    ;
                      CaptionML=[DAN=&Planlëgning;
                                 ENU=Pla&nning];
                      ToolTipML=[DAN=èbn et vërktõj til manuel leveringsplanlëgning, der viser alle nye behov sammen med beholdningsoplysninger og forslag til levering. Det sikre den synlighed og giver adgang til de vërktõjer, der krëves for at planlëgge levering fra salgslinjer og komponentlinjer for derefter at oprette forskellige typer forsyningsordrer direkte.;
                                 ENU=Open a tool for manual supply planning that displays all new demand along with availability information and suggestions for supply. It provides the visibility and tools needed to plan for demand from sales lines and component lines and then create different types of supply orders directly.];
                      ApplicationArea=#Planning;
                      Image=Planning;
                      OnAction=VAR
                                 SalesPlanForm@1001 : Page 99000883;
                               BEGIN
                                 SalesPlanForm.SetSalesOrder("No.");
                                 SalesPlanForm.RUNMODAL;
                               END;
                                }
      { 25      ;1   ;ActionGroup;
                      CaptionML=[DAN=Anmod om godkendelse;
                                 ENU=Request Approval];
                      Image=SendApprovalRequest }
      { 250     ;2   ;Action    ;
                      Name=SendApprovalRequest;
                      CaptionML=[DAN=Send go&dkendelsesanmodning;
                                 ENU=Send A&pproval Request];
                      ToolTipML=[DAN=Anmod om godkendelse af bilaget.;
                                 ENU=Request approval of the document.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=NOT OpenApprovalEntriesExist AND CanRequestApprovalForFlow;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category9;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ApprovalsMgmt@1001 : Codeunit 1535;
                               BEGIN
                                 IF ApprovalsMgmt.CheckSalesApprovalPossible(Rec) THEN
                                   ApprovalsMgmt.OnSendSalesDocForApproval(Rec);
                               END;
                                }
      { 251     ;2   ;Action    ;
                      Name=CancelApprovalRequest;
                      CaptionML=[DAN=Annuller godkendelsesan&modning;
                                 ENU=Cancel Approval Re&quest];
                      ToolTipML=[DAN=Annuller godkendelsesanmodningen.;
                                 ENU=Cancel the approval request.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=CanCancelApprovalForRecord OR CanCancelApprovalForFlow;
                      Image=CancelApprovalRequest;
                      PromotedCategory=Category9;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ApprovalsMgmt@1001 : Codeunit 1535;
                                 WorkflowWebhookMgt@1000 : Codeunit 1543;
                               BEGIN
                                 ApprovalsMgmt.OnCancelSalesApprovalRequest(Rec);
                                 WorkflowWebhookMgt.FindAndCancel(RECORDID);
                               END;
                                }
      { 118     ;2   ;ActionGroup;
                      CaptionML=[DAN=Workflow;
                                 ENU=Flow];
                      Image=Flow }
      { 117     ;3   ;Action    ;
                      Name=CreateFlow;
                      CaptionML=[DAN=Opret et workflow;
                                 ENU=Create a Flow];
                      ToolTipML=[DAN=Opret et nyt workflow fra en liste over relevante workflowskabeloner.;
                                 ENU=Create a new Flow from a list of relevant Flow templates.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=IsSaas;
                      Image=Flow;
                      PromotedCategory=Category9;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 FlowServiceManagement@1001 : Codeunit 6400;
                                 FlowTemplateSelector@1000 : Page 6400;
                               BEGIN
                                 // Opens page 6400 where the user can use filtered templates to create new flows.
                                 FlowTemplateSelector.SetSearchText(FlowServiceManagement.GetSalesTemplateFilter);
                                 FlowTemplateSelector.RUN;
                               END;
                                }
      { 120     ;3   ;Action    ;
                      Name=SeeFlows;
                      CaptionML=[DAN=Se mine workflows;
                                 ENU=See my Flows];
                      ToolTipML=[DAN=FÜ vist og konfigurer de workflowforekomster, du har oprettet.;
                                 ENU=View and configure Flows that you created.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 6401;
                      Promoted=Yes;
                      Image=Flow;
                      PromotedCategory=Category9;
                      PromotedOnly=Yes }
      { 3       ;1   ;ActionGroup;
                      CaptionML=[DAN=Lagersted;
                                 ENU=Warehouse];
                      Image=Warehouse }
      { 148     ;2   ;Action    ;
                      AccessByPermission=TableData 7342=R;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Opret l&ëg-pÜ-lager (lager)/pluk (lager);
                                 ENU=Create Inventor&y Put-away/Pick];
                      ToolTipML=[DAN=Opret en lëg-pÜ-lager-aktivitet eller et lagerpluk til hÜndtering af varer pÜ bilaget i overensstemmelse med en grundlëggende lageropsëtning, der ikke krëver lagermodtagelse eller leverancedokumenter.;
                                 ENU=Create an inventory put-away or inventory pick to handle items on the document according to a basic warehouse configuration that does not require warehouse receipt or shipment documents.];
                      ApplicationArea=#Warehouse;
                      Promoted=Yes;
                      Image=CreateInventoryPickup;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CreateInvtPutAwayPick;

                                 IF NOT FIND('=><') THEN
                                   INIT;
                               END;
                                }
      { 149     ;2   ;Action    ;
                      AccessByPermission=TableData 7320=R;
                      CaptionML=[DAN=Opre&t lagerleverance;
                                 ENU=Create &Whse. Shipment];
                      ToolTipML=[DAN=Opret en lagerleverance for at starte et pluk eller en leveringsproces i henhold til en avanceret lageropsëtning.;
                                 ENU=Create a warehouse shipment to start a pick a ship process according to an advanced warehouse configuration.];
                      ApplicationArea=#Warehouse;
                      Image=NewShipment;
                      OnAction=VAR
                                 GetSourceDocOutbound@1001 : Codeunit 5752;
                               BEGIN
                                 GetSourceDocOutbound.CreateFromSalesOrder(Rec);

                                 IF NOT FIND('=><') THEN
                                   INIT;
                               END;
                                }
      { 73      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Bogfõring;
                                 ENU=P&osting];
                      Image=Post }
      { 75      ;2   ;Action    ;
                      Name=Post;
                      ShortCutKey=F9;
                      Ellipsis=Yes;
                      CaptionML=[DAN=B&ogfõr;
                                 ENU=P&ost];
                      ToolTipML=[DAN=Fërdiggõr bilaget eller kladden ved at bogfõre belõb og antal pÜ de relaterede konti i regnskaberne.;
                                 ENU=Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostOrder;
                      PromotedCategory=Category6;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 Post(CODEUNIT::"Sales-Post (Yes/No)",NavigateAfterPost::"Posted Document");
                               END;
                                }
      { 19      ;2   ;Action    ;
                      Name=PostAndNew;
                      ShortCutKey=Shift+F9;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Bogfõr og ny;
                                 ENU=Post and New];
                      ToolTipML=[DAN=Bogfõr salgsdokumentet, og opret en ny, tom Çn.;
                                 ENU=Post the sales document and create a new, empty one.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Image=PostOrder;
                      PromotedCategory=Category6;
                      OnAction=BEGIN
                                 Post(CODEUNIT::"Sales-Post (Yes/No)",NavigateAfterPost::"New Document");
                               END;
                                }
      { 29      ;2   ;Action    ;
                      Name=PostAndSend;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Bogfõr og send;
                                 ENU=Post and Send];
                      ToolTipML=[DAN=Fërdiggõr bilaget, og klargõr det til afsendelse i henhold til debitorens afsendelsesprofil, f.eks. vedhëftet en mail. Vinduet Send dokument til vises, sÜ du kan bekrëfte eller vëlge en afsendelsesprofil.;
                                 ENU=Finalize and prepare to send the document according to the customer's sending profile, such as attached to an email. The Send document to window opens first so you can confirm or select a sending profile.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=PostMail;
                      PromotedCategory=Category6;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 Post(CODEUNIT::"Sales-Post and Send",NavigateAfterPost::Nowhere);
                               END;
                                }
      { 74      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kontroller;
                                 ENU=Test Report];
                      ToolTipML=[DAN=Vis en testrapport, sÜ du kan finde og rette eventuelle fejl, fõr du udfõrer den faktiske bogfõring af kladden eller bilaget.;
                                 ENU=View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.];
                      ApplicationArea=#Advanced;
                      Image=TestReport;
                      OnAction=BEGIN
                                 ReportPrint.PrintSalesHeader(Rec);
                               END;
                                }
      { 7       ;2   ;Action    ;
                      CaptionML=[DAN=Fjern fra opgavekõ;
                                 ENU=Remove From Job Queue];
                      ToolTipML=[DAN=Fjern den planlagte behandling af denne record fra jobkõen.;
                                 ENU=Remove the scheduled processing of this record from the job queue.];
                      ApplicationArea=#All;
                      Visible=JobQueueVisible;
                      Image=RemoveLine;
                      OnAction=BEGIN
                                 CancelBackgroundPosting;
                               END;
                                }
      { 51      ;2   ;Action    ;
                      Name=PreviewPosting;
                      CaptionML=[DAN=Vis bogfõring;
                                 ENU=Preview Posting];
                      ToolTipML=[DAN=Gennemse de forskellige typer poster, der oprettes, nÜr du bogfõrer bilaget eller kladden.;
                                 ENU=Review the different types of entries that will be created when you post the document or journal.];
                      ApplicationArea=#Basic,#Suite;
                      Image=ViewPostedOrder;
                      OnAction=BEGIN
                                 ShowPreview;
                               END;
                                }
      { 52      ;2   ;Action    ;
                      Name=ProformaInvoice;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Proformafaktura;
                                 ENU=Pro Forma Invoice];
                      ToolTipML=[DAN=FÜ vist eller udskriv fakturaen for proformasalg.;
                                 ENU=View or print the pro forma sales invoice.];
                      Image=ViewPostedOrder;
                      PromotedCategory=Category5;
                      OnAction=BEGIN
                                 DocPrint.PrintProformaSalesInvoice(Rec);
                               END;
                                }
      { 236     ;2   ;ActionGroup;
                      CaptionML=[DAN=For&udbetaling;
                                 ENU=Prepa&yment];
                      Image=Prepayment }
      { 231     ;3   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Forudbetalings&testrapport;
                                 ENU=Prepayment &Test Report];
                      ToolTipML=[DAN="Gennemse de forudbetalingstransaktioner, der kommer ud af at bogfõre salgsdokumentet som faktureret. ";
                                 ENU="Preview the prepayment transactions that will results from posting the sales document as invoiced. "];
                      ApplicationArea=#Prepayments;
                      Image=PrepaymentSimulation;
                      OnAction=BEGIN
                                 ReportPrint.PrintSalesHeaderPrepmt(Rec);
                               END;
                                }
      { 232     ;3   ;Action    ;
                      Name=PostPrepaymentInvoice;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Bogfõr forudbetalings&faktura;
                                 ENU=Post Prepayment &Invoice];
                      ToolTipML=[DAN="Bogfõr de angivne forudbetalingsoplysninger. ";
                                 ENU="Post the specified prepayment information. "];
                      ApplicationArea=#Prepayments;
                      Image=PrepaymentPost;
                      OnAction=VAR
                                 SalesPostYNPrepmt@1000 : Codeunit 443;
                               BEGIN
                                 IF ApprovalsMgmt.PrePostApprovalCheckSales(Rec) THEN
                                   SalesPostYNPrepmt.PostPrepmtInvoiceYN(Rec,FALSE);
                               END;
                                }
      { 237     ;3   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Bogfõr og udskriv forudb&etalingsfaktura;
                                 ENU=Post and Print Prepmt. Invoic&e];
                      ToolTipML=[DAN="Bogfõr de angivne forudbetalingsoplysninger, og udskriv den relaterede rapport. ";
                                 ENU="Post the specified prepayment information and print the related report. "];
                      ApplicationArea=#Prepayments;
                      Image=PrepaymentPostPrint;
                      OnAction=VAR
                                 SalesPostYNPrepmt@1000 : Codeunit 443;
                               BEGIN
                                 IF ApprovalsMgmt.PrePostApprovalCheckSales(Rec) THEN
                                   SalesPostYNPrepmt.PostPrepmtInvoiceYN(Rec,TRUE);
                               END;
                                }
      { 233     ;3   ;Action    ;
                      Name=PostPrepaymentCreditMemo;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Bogfõr forudbetalings&kreditnota;
                                 ENU=Post Prepayment &Credit Memo];
                      ToolTipML=[DAN=Opret og bogfõr en kreditnota for de angivne forudbetalingsoplysninger.;
                                 ENU=Create and post a credit memo for the specified prepayment information.];
                      ApplicationArea=#Prepayments;
                      Image=PrepaymentPost;
                      OnAction=VAR
                                 SalesPostYNPrepmt@1000 : Codeunit 443;
                               BEGIN
                                 IF ApprovalsMgmt.PrePostApprovalCheckSales(Rec) THEN
                                   SalesPostYNPrepmt.PostPrepmtCrMemoYN(Rec,FALSE);
                               END;
                                }
      { 238     ;3   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Bogfõr og udskriv forudbetalingskreditn&ota;
                                 ENU=Post and Print Prepmt. Cr. Mem&o];
                      ToolTipML=[DAN=Opret og bogfõr en kreditnota for de angivne forudbetalingsoplysninger, og udskriv den relaterede rapport.;
                                 ENU=Create and post a credit memo for the specified prepayment information and print the related report.];
                      ApplicationArea=#Prepayments;
                      Image=PrepaymentPostPrint;
                      OnAction=VAR
                                 SalesPostYNPrepmt@1000 : Codeunit 443;
                               BEGIN
                                 IF ApprovalsMgmt.PrePostApprovalCheckSales(Rec) THEN
                                   SalesPostYNPrepmt.PostPrepmtCrMemoYN(Rec,TRUE);
                               END;
                                }
      { 223     ;1   ;ActionGroup;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      Image=Print }
      { 225     ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Arbejdsseddel;
                                 ENU=Work Order];
                      ToolTipML=[DAN=Gõr dig klar til at registrere det faktiske antal varer eller den faktiske tid, der er brugt i forbindelse med salgsordren. Bilaget kan f.eks. benyttes af personale, som udfõrer en eller anden form for behandling i forbindelse med salgsordren. Det kan ogsÜ udlëses til Excel, hvis der er brug for at behandle salgslinjedataene yderligere.;
                                 ENU=Prepare to registers actual item quantities or time used in connection with the sales order. For example, the document can be used by staff who perform any kind of processing work in connection with the sales order. It can also be exported to Excel if you need to process the sales line data further.];
                      ApplicationArea=#Manufacturing;
                      Image=Print;
                      OnAction=BEGIN
                                 DocPrint.PrintSalesOrder(Rec,Usage::"Work Order");
                               END;
                                }
      { 5       ;2   ;Action    ;
                      CaptionML=[DAN=Plukinstruktion;
                                 ENU=Pick Instruction];
                      ToolTipML=[DAN=Udskriv en plukliste, der viser, hvilke varer der skal plukkes og leveres for salgsordren. Rapporten indeholder rëkker for de montagekomponenter, der skal plukkes, hvis en vare er monteret under en ordre. Du kan bruge denne rapport som en plukinstruktion til medarbejdere, der stÜr for at plukke salgsvarer eller montagekomponenter for salgsordren.;
                                 ENU=Print a picking list that shows which items to pick and ship for the sales order. If an item is assembled to order, then the report includes rows for the assembly components that must be picked. Use this report as a pick instruction to employees in charge of picking sales items or assembly components for the sales order.];
                      ApplicationArea=#Warehouse;
                      Image=Print;
                      OnAction=BEGIN
                                 DocPrint.PrintSalesOrder(Rec,Usage::"Pick Instruction");
                               END;
                                }
      { 31      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Ordrebekrëftelse;
                                 ENU=&Order Confirmation];
                      Image=Email }
      { 33      ;2   ;Action    ;
                      Name=SendEmailConfirmation;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Mail bekrëftelse;
                                 ENU=Email Confirmation];
                      ToolTipML=[DAN=Send en salgsordrebekrëftelse via mail. Den vedhëftede fil sendes som en pdf-fil.;
                                 ENU=Send a sales order confirmation by email. The attachment is sent as a .pdf.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Email;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 DocPrint.EmailSalesHeader(Rec);
                               END;
                                }
      { 96      ;2   ;ActionGroup;
                      Visible=FALSE }
      { 224     ;3   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Udskriv bekrëftelse;
                                 ENU=Print Confirmation];
                      ToolTipML=[DAN=Udskriv en salgsordrebekrëftelse.;
                                 ENU=Print a sales order confirmation.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=NOT IsOfficeHost;
                      Image=Print;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 DocPrint.PrintSalesOrder(Rec,Usage::"Order Confirmation");
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
                Visible=DocNoVisible;
                OnAssistEdit=BEGIN
                               IF AssistEdit(xRec) THEN
                                 CurrPage.UPDATE;
                             END;
                              }

    { 98  ;2   ;Field     ;
                CaptionML=[DAN=Debitornr.;
                           ENU=Customer No.];
                ToolTipML=[DAN=Angiver nummeret pÜ den debitor, der modtager produkterne og faktureres som standard.;
                           ENU=Specifies the number of the customer who will receive the products and be billed by default.];
                ApplicationArea=#Basic,#Suite;
                NotBlank=Yes;
                SourceExpr="Sell-to Customer No.";
                Importance=Additional;
                OnValidate=BEGIN
                             SelltoCustomerNoOnAfterValidate(Rec,xRec);
                             CurrPage.UPDATE;
                           END;
                            }

    { 6   ;2   ;Field     ;
                CaptionML=[DAN=Debitornavn;
                           ENU=Customer Name];
                ToolTipML=[DAN=Angiver navnet pÜ den debitor, der modtager produkterne og faktureres som standard.;
                           ENU=Specifies the name of the customer who will receive the products and be billed by default.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Customer Name";
                OnValidate=BEGIN
                             SelltoCustomerNoOnAfterValidate(Rec,xRec);

                             IF ApplicationAreaSetup.IsFoundationEnabled THEN
                               SalesCalcDiscountByType.ApplyDefaultInvoiceDiscount(0,Rec);

                             SellToCustomerUsesOIOUBL := CustomerUsesOIOUBL("Sell-to Customer No.");

                             CurrPage.UPDATE;
                           END;

                ShowMandatory=TRUE }

    { 114 ;2   ;Group     ;
                Visible=ShowQuoteNo;
                GroupType=Group }

    { 243 ;3   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ det salgstilbud, salgsordren blev oprettet fra. Du kan spore nummeret til salgstilbudsdokumenter, som du har udskrevet, gemt eller sendt pr. mail.;
                           ENU=Specifies the number of the sales quote that the sales order was created from. You can track the number to sales quote documents that you have printed, saved, or emailed.];
                ApplicationArea=#All;
                SourceExpr="Quote No." }

    { 190 ;2   ;Group     ;
                CaptionML=[DAN=Kunde;
                           ENU=Sell-to];
                GroupType=Group }

    { 81  ;3   ;Field     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                ToolTipML=[DAN=Angiver adressen pÜ debitorens lokalitet.;
                           ENU=Specifies the address where the customer is located.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Address";
                Importance=Additional }

    { 83  ;3   ;Field     ;
                CaptionML=[DAN=Adresse 2;
                           ENU=Address 2];
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Address 2";
                Importance=Additional }

    { 72  ;3   ;Field     ;
                CaptionML=[DAN=Postnr.;
                           ENU=Post Code];
                ToolTipML=[DAN=Angiver postnummer.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Post Code";
                Importance=Additional }

    { 86  ;3   ;Field     ;
                CaptionML=[DAN=By;
                           ENU=City];
                ToolTipML=[DAN=Angiver debitorens by pÜ salgsdokumentet.;
                           ENU=Specifies the city of the customer on the sales document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to City";
                Importance=Additional }

    { 157 ;3   ;Field     ;
                CaptionML=[DAN=Kontaktnr.;
                           ENU=Contact No.];
                ToolTipML=[DAN=Angiver nummeret pÜ den kontakt, som salgsdokumentet sendes til.;
                           ENU=Specifies the number of the contact that the sales document will be sent to.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Contact No.";
                Importance=Additional;
                OnValidate=BEGIN
                             IF GETFILTER("Sell-to Contact No.") = xRec."Sell-to Contact No." THEN
                               IF "Sell-to Contact No." <> xRec."Sell-to Contact No." THEN
                                 SETRANGE("Sell-to Contact No.");
                           END;

                ShowMandatory=SellToCustomerUsesOIOUBL }

    { 8   ;2   ;Field     ;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                ToolTipML=[DAN=Angiver navnet pÜ personen, der kan kontaktes i debitorens virksomhed.;
                           ENU=Specifies the name of the person to contact at the customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Contact";
                Editable="Sell-to Customer No." <> '' }

    { 1101100000;2;Field  ;
                ToolTipML=[DAN=Angiver telefonnummeret pÜ kontaktpersonen hos debitoren.;
                           ENU=Specifies the telephone number of the contact person at the customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Contact Phone No." }

    { 1101100002;2;Field  ;
                ToolTipML=[DAN="Angiver faxnummeret pÜ kontaktpersonen hos debitoren. ";
                           ENU="Specifies the fax number of the contact person at the customer. "];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Contact Fax No." }

    { 1101100004;2;Field  ;
                ToolTipML=[DAN=Angiver mailadressen pÜ kontaktpersonen hos debitoren.;
                           ENU=Specifies the email address of the contact person at the customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Contact E-Mail" }

    { 1060004;2;Field     ;
                ToolTipML=[DAN=Angiver rollen for kontaktpersonen hos debitoren.;
                           ENU=Specifies the role of the contact person at the customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Contact Role" }

    { 198 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange arkiverede versioner der findes af dette bilag.;
                           ENU=Specifies the number of archived versions for this document.];
                ApplicationArea=#Advanced;
                SourceExpr="No. of Archived Versions";
                Importance=Additional }

    { 45  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Date";
                Importance=Additional }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor bogfõringen af salgsdokumentet skal registreres.;
                           ENU=Specifies the date when the posting of the sales document will be recorded.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Posting Date";
                Importance=Promoted }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor ordren blev oprettet.;
                           ENU=Specifies the date when the order was created.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Order Date";
                Importance=Promoted;
                QuickEntry=FALSE }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvornÜr den relaterede salgsfaktura skal betales.;
                           ENU=Specifies when the related sales invoice must be paid.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Due Date";
                Importance=Promoted }

    { 135 ;2   ;Field     ;
                ToolTipML=[DAN=Indeholder den dato, hvor debitoren har õnsket varerne leveret.;
                           ENU=Specifies the date that the customer has asked for the order to be delivered.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Requested Delivery Date" }

    { 137 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, du har lovet at levere ordren som resultat af funktionen Beregning af leveringstid.;
                           ENU=Specifies the date that you have promised to deliver the order, as a result of the Order Promising function.];
                ApplicationArea=#Advanced;
                SourceExpr="Promised Delivery Date";
                Importance=Additional }

    { 155 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer, som bliver brugt i debitors eller kreditors nummereringssystem.;
                           ENU=Specifies a document number that refers to the customer's or vendor's numbering system.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="External Document No.";
                Importance=Promoted;
                ShowMandatory=ExternalDocNoMandatory OR SellToCustomerUsesOIOUBL }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ den sëlger, der er tildelt til debitoren.;
                           ENU=Specifies the name of the salesperson who is assigned to the customer.];
                ApplicationArea=#Suite;
                SourceExpr="Salesperson Code";
                Importance=Additional;
                OnValidate=BEGIN
                             SalespersonCodeOnAfterValidate;
                           END;

                QuickEntry=FALSE }

    { 1148;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den kampagne, som dokumentet er tilknyttet.;
                           ENU=Specifies the number of the campaign that the document is linked to.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Campaign No.";
                Importance=Additional }

    { 245 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den salgsmulighed, som salgstilbuddet er tildelt.;
                           ENU=Specifies the number of the opportunity that the sales quote is assigned to.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Opportunity No.";
                Importance=Additional }

    { 124 ;2   ;Field     ;
                AccessByPermission=TableData 5714=R;
                ToolTipML=[DAN=Angiver den kode for ansvarscenteret (f.eks. et distributionscenter), som er tildelt den involverede bruger, virksomhed, debitor eller kreditor.;
                           ENU=Specifies the code of the responsibility center, such as a distribution hub, that is associated with the involved user, company, customer, or vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Responsibility Center";
                Importance=Additional }

    { 241 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der er ansvarlig for bilaget.;
                           ENU=Specifies the ID of the user who is responsible for the document.];
                ApplicationArea=#Advanced;
                SourceExpr="Assigned User ID";
                Importance=Additional }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for en opgavekõpost eller opgave, der hÜndterer bogfõring af salgsordrer.;
                           ENU=Specifies the status of a job queue entry or task that handles the posting of sales orders.];
                ApplicationArea=#All;
                SourceExpr="Job Queue Status";
                Importance=Additional;
                Visible=JobQueuesUsed }

    { 129 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om dokumentet er Übent, venter pÜ godkendelse, er faktureret til forudbetaling eller er frigivet til nëste fase i behandlingen.;
                           ENU=Specifies whether the document is open, waiting to be approved, has been invoiced for prepayment, or has been released to the next stage of processing.];
                ApplicationArea=#Suite;
                SourceExpr=Status;
                Importance=Additional;
                QuickEntry=FALSE }

    { 113 ;2   ;Group     ;
                CaptionML=[DAN=Arbejdsbeskrivelse;
                           ENU=Work Description];
                GroupType=Group }

    { 116 ;3   ;Field     ;
                ToolTipML=[DAN=Angiver de produkter eller den service, der tilbydes.;
                           ENU=Specifies the products or service being offered.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=WorkDescription;
                Importance=Additional;
                MultiLine=Yes;
                OnValidate=BEGIN
                             SetWorkDescription(WorkDescription);
                           END;

                ShowCaption=No }

    { 58  ;1   ;Part      ;
                Name=SalesLines;
                ApplicationArea=#Basic,#Suite;
                SubPageLink=Document No.=FIELD(No.);
                PagePartID=Page46;
                Enabled="Sell-to Customer No." <> '';
                Editable=DynamicEditable;
                UpdatePropagation=Both }

    { 1905885101;1;Group  ;
                CaptionML=[DAN=Fakturadetaljer;
                           ENU=Invoice Details];
                GroupType=Group }

    { 111 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver valutaen for belõbene i salgsdokumentet.;
                           ENU=Specifies the currency of amounts on the sales document.];
                ApplicationArea=#Suite;
                SourceExpr="Currency Code";
                Importance=Promoted;
                OnValidate=BEGIN
                             CurrPage.SAVERECORD;
                             SalesCalcDiscountByType.ApplyDefaultInvoiceDiscount(0,Rec);
                           END;

                OnAssistEdit=BEGIN
                               CLEAR(ChangeExchangeRate);
                               IF "Posting Date" <> 0D THEN
                                 ChangeExchangeRate.SetParameter("Currency Code","Currency Factor","Posting Date")
                               ELSE
                                 ChangeExchangeRate.SetParameter("Currency Code","Currency Factor",WORKDATE);
                               IF ChangeExchangeRate.RUNMODAL = ACTION::OK THEN BEGIN
                                 VALIDATE("Currency Factor",ChangeExchangeRate.GetParameter);
                                 CurrPage.UPDATE;
                               END;
                               CLEAR(ChangeExchangeRate);
                             END;
                              }

    { 131 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om felterne Enhedspris og Linjebelõb pÜ bilagslinjer skal vises med eller uden moms.;
                           ENU=Specifies if the Unit Price and Line Amount fields on document lines should be shown with or without VAT.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Prices Including VAT";
                OnValidate=BEGIN
                             PricesIncludingVATOnAfterValid;
                           END;
                            }

    { 221 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede debitors eller kreditors momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogfõringsopsëtning.;
                           ENU=Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Bus. Posting Group";
                OnValidate=BEGIN
                             IF ApplicationAreaSetup.IsFoundationEnabled THEN
                               SalesCalcDiscountByType.ApplyDefaultInvoiceDiscount(0,Rec);

                             CurrPage.UPDATE;
                           END;
                            }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en formel, der beregner betalingens forfaldsdato, kontantrabatdato og kontantrabatbelõb.;
                           ENU=Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Terms Code";
                Importance=Promoted }

    { 105 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan betalingen skal foretages, f.eks. via bankoverfõrsel, kontant eller med check.;
                           ENU=Specifies how to make payment, such as with bank transfer, cash,  or check.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Method Code";
                Importance=Additional;
                OnValidate=BEGIN
                             UpdatePaymentService;
                           END;
                            }

    { 1060002;2;Field     ;
                ToolTipML=[DAN=Angiver betalingsmetoden Offentlig Information Online UBL (OIOUBL) for bilaget.;
                           ENU=Specifies the Offentlig Information Online UBL (OIOUBL) payment method for the document.];
                ApplicationArea=#Basic,#Suite;
                BlankZero=Yes;
                SourceExpr="Payment Channel";
                ShowMandatory=SellToCustomerUsesOIOUBL }

    { 112 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om transaktionen er relateret til handel med tredjepart i EU.;
                           ENU=Specifies if the transaction is related to trade with a third party within the EU.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="EU 3-Party Trade" }

    { 76  ;2   ;Group     ;
                Visible=PaymentServiceVisible;
                GroupType=Group }

    { 16  ;3   ;Field     ;
                Name=SelectedPayments;
                CaptionML=[DAN=Betalingstjeneste;
                           ENU=Payment Service];
                ToolTipML=[DAN=Angiver onlinebetalingstjenesten, f.eks. PayPal, som debitorerne kan bruge til at betale salgsdokument.;
                           ENU=Specifies the online payment service, such as PayPal, that customers can use to pay the sales document.];
                ApplicationArea=#All;
                SourceExpr=GetSelectedPaymentServicesText;
                Enabled=PaymentServiceEnabled;
                Editable=FALSE;
                MultiLine=Yes;
                OnAssistEdit=BEGIN
                               ChangePaymentServiceSetting;
                             END;
                              }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den transaktionstype, som bilaget reprësenterer med henblik pÜ rapportering til INTRASTAT.;
                           ENU=Specifies the type of transaction that the document represents, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Transaction Type" }

    { 84  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                OnValidate=BEGIN
                             ShortcutDimension1CodeOnAfterV;
                           END;
                            }

    { 92  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code";
                OnValidate=BEGIN
                             ShortcutDimension2CodeOnAfterV;
                           END;
                            }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den rabatprocent, der tildeles, hvis debitoren betaler fõr eller pÜ den dato, der er angivet i feltet Kont.rabatdato.;
                           ENU=Specifies the payment discount percentage granted if the customer pays on or before the date entered in the Pmt. Discount Date field.];
                ApplicationArea=#Advanced;
                SourceExpr="Payment Discount %" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor belõbet i posten skal vëre betalt, for at der kan opnÜs kontantrabat.;
                           ENU=Specifies the date on which the amount in the entry must be paid for a payment discount to be granted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pmt. Discount Date";
                Importance=Additional }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den Direct Debit-betalingsaftale, som debitoren har underskrevet for at tillade Direct Debit-opkrëvning af betalinger.;
                           ENU=Specifies the direct-debit mandate that the customer has signed to allow direct debit collection of payments.];
                ApplicationArea=#Advanced;
                SourceExpr="Direct Debit Mandate ID" }

    { 1906801201;1;Group  ;
                CaptionML=[DAN=Forsendelse og fakturering;
                           ENU=Shipping and Billing];
                GroupType=Group }

    { 91  ;2   ;Group     ;
                GroupType=Group }

    { 90  ;3   ;Group     ;
                GroupType=Group }

    { 88  ;4   ;Field     ;
                Name=ShippingOptions;
                CaptionML=[DAN=Leveres til;
                           ENU=Ship-to];
                ToolTipML=[DAN=Angiver den adresse, som produkter i salgsbilaget skal leveres til. Standard (Kundeadresse): Det samme som kundens adresse. Alternativ leveringsadresse: ên af kundens alternative leveringsadresser. Brugerdefineret adresse: En vilkÜrlig leveringsadresse, som du angiver i nedenstÜende felter.;
                           ENU=Specifies the address that the products on the sales document are shipped to. Default (Sell-to Address): The same as the customer's sell-to address. Alternate Ship-to Address: One of the customer's alternate ship-to addresses. Custom Address: Any ship-to address that you specify in the fields below.];
                OptionCaptionML=[DAN=Standard (kundeadresse),alternativ leveringsadresse,brugerdefineret adresse;
                                 ENU=Default (Sell-to Address),Alternate Shipping Address,Custom Address];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ShipToOptions;
                OnValidate=VAR
                             ShipToAddress@1001 : Record 222;
                             ShipToAddressList@1000 : Page 301;
                           BEGIN
                             CASE ShipToOptions OF
                               ShipToOptions::"Default (Sell-to Address)":
                                 BEGIN
                                   VALIDATE("Ship-to Code",'');
                                   CopySellToAddressToShipToAddress;
                                 END;
                               ShipToOptions::"Alternate Shipping Address":
                                 BEGIN
                                   ShipToAddress.SETRANGE("Customer No.","Sell-to Customer No.");
                                   ShipToAddressList.LOOKUPMODE := TRUE;
                                   ShipToAddressList.SETTABLEVIEW(ShipToAddress);

                                   IF ShipToAddressList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                     ShipToAddressList.GETRECORD(ShipToAddress);
                                     VALIDATE("Ship-to Code",ShipToAddress.Code);
                                   END ELSE
                                     ShipToOptions := ShipToOptions::"Custom Address";
                                 END;
                               ShipToOptions::"Custom Address":
                                 VALIDATE("Ship-to Code",'');
                             END;
                           END;
                            }

    { 4   ;4   ;Group     ;
                Visible=NOT (ShipToOptions = ShipToOptions::"Default (Sell-to Address)");
                GroupType=Group }

    { 36  ;5   ;Field     ;
                CaptionML=[DAN=Kode;
                           ENU=Code];
                ToolTipML=[DAN=Angiver koden for en anden leveringsadresse end debitorens egen adresse, som angives som standard.;
                           ENU=Specifies the code for another shipment address than the customer's own address, which is entered by default.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Code";
                Importance=Promoted;
                Editable=ShipToOptions = ShipToOptions::"Alternate Shipping Address";
                OnValidate=BEGIN
                             IF (xRec."Ship-to Code" <> '') AND ("Ship-to Code" = '') THEN
                               ERROR(EmptyShipToCodeErr);
                           END;
                            }

    { 38  ;5   ;Field     ;
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver navnet, som produkter i salgsdokumentet skal leveres til.;
                           ENU=Specifies the name that products on the sales document will be shipped to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Name";
                Editable=ShipToOptions = ShipToOptions::"Custom Address" }

    { 40  ;5   ;Field     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                ToolTipML=[DAN=Angiver den adresse, som produkter i salgsdokumentet skal leveres til.;
                           ENU=Specifies the address that products on the sales document will be shipped to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Address";
                Editable=ShipToOptions = ShipToOptions::"Custom Address" }

    { 42  ;5   ;Field     ;
                CaptionML=[DAN=Adresse 2;
                           ENU=Address 2];
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Address 2";
                Editable=ShipToOptions = ShipToOptions::"Custom Address" }

    { 97  ;5   ;Field     ;
                CaptionML=[DAN=Postnr.;
                           ENU=Post Code];
                ToolTipML=[DAN=Angiver postnummer.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Post Code";
                Editable=ShipToOptions = ShipToOptions::"Custom Address" }

    { 44  ;5   ;Field     ;
                CaptionML=[DAN=By;
                           ENU=City];
                ToolTipML=[DAN=Angiver debitorens by pÜ salgsdokumentet.;
                           ENU=Specifies the city of the customer on the sales document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to City";
                Editable=ShipToOptions = ShipToOptions::"Custom Address" }

    { 95  ;5   ;Field     ;
                CaptionML=[DAN=Land/omrÜde;
                           ENU=Country/Region];
                ToolTipML=[DAN=Angiver debitorens land/omrÜde.;
                           ENU=Specifies the customer's country/region.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Country/Region Code";
                Importance=Additional;
                Editable=ShipToOptions = ShipToOptions::"Custom Address" }

    { 46  ;4   ;Field     ;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                ToolTipML=[DAN=Angiver navnet pÜ kontaktpersonen pÜ den adresse, som produkter i salgsdokumentet skal leveres til.;
                           ENU=Specifies the name of the contact person at the address that products on the sales document will be shipped to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Contact" }

    { 77  ;3   ;Group     ;
                CaptionML=[DAN=Leveringsform;
                           ENU=Shipment Method];
                GroupType=Group }

    { 48  ;4   ;Field     ;
                CaptionML=[DAN=Kode;
                           ENU=Code];
                ToolTipML=[DAN=Angiver, hvordan varer i salgsdokumentet sendes til debitoren.;
                           ENU=Specifies how items on the sales document are shipped to the customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Shipment Method Code";
                Importance=Additional }

    { 107 ;4   ;Field     ;
                CaptionML=[DAN=Speditõr;
                           ENU=Agent];
                ToolTipML=[DAN=Angiver, hvilken speditõr der bruges til at transportere varerne pÜ salgsbilaget til debitoren.;
                           ENU=Specifies which shipping agent is used to transport the items on the sales document to the customer.];
                ApplicationArea=#Suite;
                SourceExpr="Shipping Agent Code";
                Importance=Additional }

    { 139 ;4   ;Field     ;
                CaptionML=[DAN=Speditõrservice;
                           ENU=Agent Service];
                ToolTipML=[DAN=Angiver den kode, der reprësenterer den speditõrservice, du anvender som standard til salgsordren.;
                           ENU=Specifies the code that represents the default shipping agent service you are using for this sales order.];
                ApplicationArea=#Suite;
                SourceExpr="Shipping Agent Service Code";
                Importance=Additional }

    { 109 ;4   ;Field     ;
                ToolTipML=[DAN=Angiver speditõrens pakkenummer.;
                           ENU=Specifies the shipping agent's package number.];
                ApplicationArea=#Suite;
                SourceExpr="Package Tracking No.";
                Importance=Additional }

    { 85  ;2   ;Group     ;
                GroupType=Group }

    { 93  ;3   ;Field     ;
                CaptionML=[DAN=Faktureres til;
                           ENU=Bill-to];
                ToolTipML=[DAN=Angiver den kunde, som salgsfakturaen skal sendes til. Standard (Kunde): Den samme som kunden pÜ salgsfakturaen. En anden kunde: Enhver kunde, som du angiver i nedenstÜende felter.;
                           ENU=Specifies the customer that the sales invoice will be sent to. Default (Customer): The same as the customer on the sales invoice. Another Customer: Any customer that you specify in the fields below.];
                OptionCaptionML=[DAN=Standard (debitor),en anden debitor;
                                 ENU=Default (Customer),Another Customer];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=BillToOptions;
                OnValidate=BEGIN
                             IF BillToOptions = BillToOptions::"Default (Customer)" THEN BEGIN
                               VALIDATE("Bill-to Customer No.","Sell-to Customer No.");
                               RecallModifyAddressNotification(GetModifyBillToCustomerAddressNotificationId);
                             END;

                             CopySellToAddressToBillToAddress;
                           END;
                            }

    { 82  ;3   ;Group     ;
                Visible=BillToOptions = BillToOptions::"Another Customer";
                GroupType=Group }

    { 18  ;4   ;Field     ;
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver den debitor, du vil sende salgsfakturaen til, nÜr det er til en anden debitor end den, du sëlger til.;
                           ENU=Specifies the customer to whom you will send the sales invoice, when different from the customer that you are selling to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bill-to Name";
                Importance=Promoted;
                OnValidate=BEGIN
                             IF GETFILTER("Bill-to Customer No.") = xRec."Bill-to Customer No." THEN
                               IF "Bill-to Customer No." <> xRec."Bill-to Customer No." THEN
                                 SETRANGE("Bill-to Customer No.");

                             IF ApplicationAreaSetup.IsFoundationEnabled THEN
                               SalesCalcDiscountByType.ApplyDefaultInvoiceDiscount(0,Rec);

                             CurrPage.UPDATE;
                           END;
                            }

    { 20  ;4   ;Field     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                ToolTipML=[DAN=Angiver debitorens adresse, som du vil sende fakturaen til.;
                           ENU=Specifies the address of the customer that you will send the invoice to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bill-to Address";
                Importance=Additional;
                Enabled="Bill-to Customer No." <> "Sell-to Customer No.";
                Editable="Bill-to Customer No." <> "Sell-to Customer No." }

    { 22  ;4   ;Field     ;
                CaptionML=[DAN=Adresse 2;
                           ENU=Address 2];
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bill-to Address 2";
                Importance=Additional;
                Enabled="Bill-to Customer No." <> "Sell-to Customer No.";
                Editable="Bill-to Customer No." <> "Sell-to Customer No." }

    { 89  ;4   ;Field     ;
                CaptionML=[DAN=Postnr.;
                           ENU=Post Code];
                ToolTipML=[DAN=Angiver postnummer.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bill-to Post Code";
                Importance=Additional;
                Enabled="Bill-to Customer No." <> "Sell-to Customer No.";
                Editable="Bill-to Customer No." <> "Sell-to Customer No." }

    { 24  ;4   ;Field     ;
                CaptionML=[DAN=By;
                           ENU=City];
                ToolTipML=[DAN=Angiver debitorens by pÜ salgsdokumentet.;
                           ENU=Specifies the city of the customer on the sales document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bill-to City";
                Importance=Additional;
                Enabled="Bill-to Customer No." <> "Sell-to Customer No.";
                Editable="Bill-to Customer No." <> "Sell-to Customer No." }

    { 159 ;4   ;Field     ;
                CaptionML=[DAN=Kontaktnr.;
                           ENU=Contact No.];
                ToolTipML=[DAN=Angiver nummeret pÜ den kontakt, som fakturaen skal sendes til.;
                           ENU=Specifies the number of the contact the invoice will be sent to.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to Contact No.";
                Importance=Additional;
                Enabled="Bill-to Customer No." <> "Sell-to Customer No.";
                Editable="Bill-to Customer No." <> "Sell-to Customer No." }

    { 26  ;4   ;Field     ;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                ToolTipML=[DAN=Angiver navnet pÜ den kontaktperson, du kan kontakte hos den debitor, som fakturaen bliver sendt til.;
                           ENU=Specifies the name of the person you should contact at the customer who you are sending the invoice to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bill-to Contact";
                Enabled="Bill-to Customer No." <> "Sell-to Customer No.";
                Editable="Bill-to Customer No." <> "Sell-to Customer No." }

    { 1060000;2;Field     ;
                ToolTipML=[DAN=Angiver EAN-lokationsnummeret for debitoren.;
                           ENU=Specifies the EAN location number for the customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="EAN No." }

    { 1600002;2;Field     ;
                ToolTipML=[DAN=Angiver kontokoden for debitoren.;
                           ENU=Specifies the account code of the customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Account Code";
                OnValidate=BEGIN
                             AccountCodeOnAfterValidate;
                           END;
                            }

    { 1060001;2;Field     ;
                ToolTipML=[DAN=Angiver den profil, som debitoren krëver til elektroniske dokumenter.;
                           ENU=Specifies the profile that the customer requires for electronic documents.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="OIOUBL Profile Code" }

    { 94  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver placeringen, hvor lagervarer til debitoren pÜ salgsbilaget skal sendes som standard.;
                           ENU=Specifies the location from where inventory items to the customer on the sales document are to be shipped by default.];
                ApplicationArea=#Location;
                SourceExpr="Location Code" }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvornÜr varerne pÜ bilaget er sendt eller leveret. En afsendelsesdato beregnes normalt ud fra en õnsket leveringsdato plus leveringstiden.;
                           ENU=Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Shipment Date";
                Importance=Promoted }

    { 119 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om debitoren accepterer dellevering af ordrer.;
                           ENU=Specifies if the customer accepts partial shipment of orders.];
                ApplicationArea=#Advanced;
                SourceExpr="Shipping Advice";
                Importance=Additional;
                OnValidate=BEGIN
                             IF "Shipping Advice" <> xRec."Shipping Advice" THEN
                               IF NOT CONFIRM(Text001,FALSE,FIELDCAPTION("Shipping Advice")) THEN
                                 ERROR(Text002);
                           END;
                            }

    { 141 ;2   ;Field     ;
                ToolTipML=[DAN="Angiver en datoformel for den tid, det tager at gõre varerne klar til forsendelse fra denne lokation. Tidselementet anvendes ved beregning af leveringsdatoen pÜ fõlgende mÜde: Afsendelsesdato + UdgÜende lagerekspeditionstid = Planlagt afsendelsesdato + Transporttid = Planlagt leveringsdato.";
                           ENU="Specifies a date formula for the time it takes to get items ready to ship from this location. The time element is used in the calculation of the delivery date as follows: Shipment Date + Outbound Warehouse Handling Time = Planned Shipment Date + Shipping Time = Planned Delivery Date."];
                ApplicationArea=#Warehouse;
                SourceExpr="Outbound Whse. Handling Time";
                Importance=Additional }

    { 143 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor lang tid der gÜr, fra varerne er sendt fra lageret, til de er leveret.;
                           ENU=Specifies how long it takes from when the items are shipped from the warehouse to when they are delivered.];
                ApplicationArea=#Advanced;
                SourceExpr="Shipping Time";
                Importance=Additional }

    { 145 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at leverancen af en eller flere linjer er blevet forsinket, eller at afsendelsesdatoen ligger fõr arbejdsdatoen.;
                           ENU=Specifies that the shipment of one or more lines has been delayed, or that the shipment date is before the work date.];
                ApplicationArea=#Advanced;
                SourceExpr="Late Order Shipping";
                Importance=Additional }

    { 1907468901;1;Group  ;
                CaptionML=[DAN=Udenrigshandel;
                           ENU=Foreign Trade] }

    { 103 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en specifikation af bilagets transaktion med henblik pÜ rapportering til INTRASTAT.;
                           ENU=Specifies a specification of the document's transaction, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Transaction Specification" }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver transportmÜden ved rapportering til INTRASTAT.;
                           ENU=Specifies the transport method, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Transport Method" }

    { 99  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det udfõrselssted, hvor varerne blev udfõrt af landet/omrÜdet med henblik pÜ rapportering til Intrastat.;
                           ENU=Specifies the point of exit through which you ship the items out of your country/region, for reporting to Intrastat.];
                ApplicationArea=#Advanced;
                SourceExpr="Exit Point" }

    { 101 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitors eller kreditors omrÜde med henblik pÜ rapportering til INTRASTAT.;
                           ENU=Specifies the area of the customer or vendor, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr=Area }

    { 1900201301;1;Group  ;
                CaptionML=[DAN=Forudbetaling;
                           ENU=Prepayment] }

    { 228 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver forudbetalingsprocenten, der skal bruges til at beregne forudbetalingen for salg.;
                           ENU=Specifies the prepayment percentage to use to calculate the prepayment for sales.];
                ApplicationArea=#Prepayments;
                SourceExpr="Prepayment %";
                Importance=Promoted;
                OnValidate=BEGIN
                             Prepayment37OnAfterValidate;
                           END;
                            }

    { 229 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at forudbetalinger pÜ salgsordren kombineres, hvis de har samme finanskonto for forudbetalinger eller samme dimensioner.;
                           ENU=Specifies that prepayments on the sales order are combined if they have the same general ledger account for prepayments or the same dimensions.];
                ApplicationArea=#Prepayments;
                SourceExpr="Compress Prepayment" }

    { 162 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode, der reprësenterer betalingsbetingelserne for de forudbetalingsfakturaer, der hõrer til salgsdokumentet.;
                           ENU=Specifies the code that represents the payment terms for prepayment invoices related to the sales document.];
                ApplicationArea=#Prepayments;
                SourceExpr="Prepmt. Payment Terms Code" }

    { 239 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvornÜr forudbetalingsfakturaen for denne salgsordre forfalder.;
                           ENU=Specifies when the prepayment invoice for this sales order is due.];
                ApplicationArea=#Prepayments;
                SourceExpr="Prepayment Due Date";
                Importance=Promoted }

    { 164 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den rabatprocent, der tildeles pÜ forudbetalingen, hvis debitoren betaler fõr eller pÜ den dato, der er angivet i feltet Forudb. - dato for kont.rabat.;
                           ENU=Specifies the payment discount percent granted on the prepayment if the customer pays on or before the date entered in the Prepmt. Pmt. Discount Date field.];
                ApplicationArea=#Prepayments;
                SourceExpr="Prepmt. Payment Discount %" }

    { 70  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den sidste dato, hvor debitoren kan betale forudbetalingsfakturaen og stadig opnÜ en kontantrabat pÜ det forudbetalte belõb.;
                           ENU=Specifies the last date the customer can pay the prepayment invoice and still receive a payment discount on the prepayment amount.];
                ApplicationArea=#Prepayments;
                SourceExpr="Prepmt. Pmt. Discount Date" }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 35  ;1   ;Part      ;
                ApplicationArea=#All;
                SubPageLink=Table ID=CONST(36),
                            Document Type=FIELD(Document Type),
                            Document No.=FIELD(No.);
                PagePartID=Page9103;
                Visible=OpenApprovalEntriesExistForCurrUser;
                PartType=Page }

    { 1903720907;1;Part   ;
                ApplicationArea=#Advanced;
                SubPageLink=No.=FIELD(Sell-to Customer No.);
                PagePartID=Page9080;
                PartType=Page }

    { 1902018507;1;Part   ;
                ApplicationArea=#Advanced;
                SubPageLink=No.=FIELD(Bill-to Customer No.);
                PagePartID=Page9082;
                Visible=FALSE;
                PartType=Page }

    { 1900316107;1;Part   ;
                ApplicationArea=#Advanced;
                SubPageLink=No.=FIELD(Sell-to Customer No.);
                PagePartID=Page9084;
                PartType=Page }

    { 1906127307;1;Part   ;
                ApplicationArea=#Suite;
                SubPageLink=Document Type=FIELD(Document Type),
                            Document No.=FIELD(Document No.),
                            Line No.=FIELD(Line No.);
                PagePartID=Page9087;
                ProviderID=58;
                PartType=Page }

    { 1901314507;1;Part   ;
                ApplicationArea=#Advanced;
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page9089;
                ProviderID=58;
                PartType=Page }

    { 1906354007;1;Part   ;
                Name=ApprovalFactBox;
                ApplicationArea=#Advanced;
                PagePartID=Page9092;
                Visible=FALSE;
                PartType=Page }

    { 49  ;1   ;Part      ;
                Name=IncomingDocAttachFactBox;
                ApplicationArea=#Advanced;
                PagePartID=Page193;
                Visible=FALSE;
                PartType=Page;
                ShowFilter=No }

    { 1907012907;1;Part   ;
                ApplicationArea=#Advanced;
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page9108;
                ProviderID=58;
                Visible=FALSE;
                PartType=Page }

    { 1901796907;1;Part   ;
                ApplicationArea=#Advanced;
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page9109;
                ProviderID=58;
                Visible=FALSE;
                PartType=Page }

    { 1907234507;1;Part   ;
                ApplicationArea=#Advanced;
                SubPageLink=No.=FIELD(Bill-to Customer No.);
                PagePartID=Page9081;
                Visible=FALSE;
                PartType=Page }

    { 80  ;1   ;Part      ;
                Name=WorkflowStatus;
                ApplicationArea=#All;
                PagePartID=Page1528;
                Visible=ShowWorkflowStatus;
                Enabled=FALSE;
                Editable=FALSE;
                PartType=Page;
                ShowFilter=No }

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
      ApplicationAreaSetup@1022 : Record 9178;
      CopySalesDoc@1001 : Report 292;
      MoveNegSalesLines@1007 : Report 6699;
      ApprovalsMgmt@1012 : Codeunit 1535;
      ReportPrint@1002 : Codeunit 228;
      DocPrint@1003 : Codeunit 229;
      ArchiveManagement@1008 : Codeunit 5063;
      SalesCalcDiscountByType@1014 : Codeunit 56;
      UserMgt@1006 : Codeunit 5700;
      CustomerMgt@1047 : Codeunit 1302;
      ChangeExchangeRate@1005 : Page 511;
      Usage@1010 : 'Order Confirmation,Work Order,Pick Instruction';
      NavigateAfterPost@1029 : 'Posted Document,New Document,Nowhere';
      JobQueueVisible@1004 : Boolean INDATASET;
      Text001@1015 : TextConst 'DAN=Vil du ëndre %1 i alle tilknyttede records pÜ lageret?;ENU=Do you want to change %1 in all related records in the warehouse?';
      Text002@1011 : TextConst 'DAN=Opdateringen er afbrudt pÜ grund af advarslen.;ENU=The update has been interrupted to respect the warning.';
      DynamicEditable@1009 : Boolean;
      HasIncomingDocument@1020 : Boolean;
      DocNoVisible@1013 : Boolean;
      SellToCustomerUsesOIOUBL@1060000 : Boolean;
      ExternalDocNoMandatory@1016 : Boolean;
      OpenApprovalEntriesExistForCurrUser@1024 : Boolean;
      OpenApprovalEntriesExist@1023 : Boolean;
      CRMIntegrationEnabled@1000 : Boolean;
      CRMIsCoupledToRecord@1017 : Boolean;
      ShowWorkflowStatus@1018 : Boolean;
      IsOfficeHost@1019 : Boolean;
      CanCancelApprovalForRecord@1021 : Boolean;
      JobQueuesUsed@1026 : Boolean;
      ShowQuoteNo@1025 : Boolean;
      DocumentIsPosted@1027 : Boolean;
      OpenPostedSalesOrderQst@1028 : TextConst 'DAN=Ordren er blevet bogfõrt og flyttet til vinduet Bogfõrte salgsfakturaer.\\Vil du Übne den bogfõrte faktura?;ENU=The order has been posted and moved to the Posted Sales Invoices window.\\Do you want to open the posted invoice?';
      PaymentServiceVisible@1030 : Boolean;
      PaymentServiceEnabled@1031 : Boolean;
      CallNotificationCheck@1037 : Boolean;
      ShipToOptions@1033 : 'Default (Sell-to Address),Alternate Shipping Address,Custom Address';
      BillToOptions@1032 : 'Default (Customer),Another Customer';
      EmptyShipToCodeErr@1034 : TextConst 'DAN=Kodefeltet mÜ kun vëre tomt, hvis du vëlger Brugerdefineret adresse i feltet Leveres til.;ENU=The Code field can only be empty if you select Custom Address in the Ship-to field.';
      CanRequestApprovalForFlow@1036 : Boolean;
      CanCancelApprovalForFlow@1035 : Boolean;
      IsCustomerOrContactNotEmpty@1039 : Boolean;
      WorkDescription@1038 : Text;
      IsSaas@1041 : Boolean;

    LOCAL PROCEDURE Post@4(PostingCodeunitID@1000 : Integer;Navigate@1004 : Option);
    VAR
      SalesHeader@1001 : Record 36;
      LinesInstructionMgt@1002 : Codeunit 1320;
      InstructionMgt@1003 : Codeunit 1330;
      IsScheduledPosting@1005 : Boolean;
    BEGIN
      IF ApplicationAreaSetup.IsFoundationEnabled THEN
        LinesInstructionMgt.SalesCheckAllLinesHaveQuantityAssigned(Rec);

      SendToPosting(PostingCodeunitID);

      IsScheduledPosting := "Job Queue Status" = "Job Queue Status"::"Scheduled for Posting";
      DocumentIsPosted := (NOT SalesHeader.GET("Document Type","No.")) OR IsScheduledPosting;

      IF IsScheduledPosting THEN
        CurrPage.CLOSE;
      CurrPage.UPDATE(FALSE);

      IF PostingCodeunitID <> CODEUNIT::"Sales-Post (Yes/No)" THEN
        EXIT;

      CASE Navigate OF
        NavigateAfterPost::"Posted Document":
          IF InstructionMgt.IsEnabled(InstructionMgt.ShowPostedConfirmationMessageCode) THEN
            ShowPostedConfirmationMessage;
        NavigateAfterPost::"New Document":
          IF DocumentIsPosted THEN BEGIN
            SalesHeader.INIT;
            SalesHeader.VALIDATE("Document Type",SalesHeader."Document Type"::Order);
            SalesHeader.INSERT(TRUE);
            PAGE.RUN(PAGE::"Sales Order",SalesHeader);
          END;
      END;
    END;

    LOCAL PROCEDURE ApproveCalcInvDisc@3();
    BEGIN
      CurrPage.SalesLines.PAGE.ApproveCalcInvDisc;
    END;

    LOCAL PROCEDURE SalespersonCodeOnAfterValidate@19011896();
    BEGIN
      CurrPage.SalesLines.PAGE.UpdateForm(TRUE);
    END;

    LOCAL PROCEDURE ShortcutDimension1CodeOnAfterV@19029405();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE ShortcutDimension2CodeOnAfterV@19008725();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE PricesIncludingVATOnAfterValid@19009096();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE AccountCodeOnAfterValidate@19007267();
    BEGIN
      CurrPage.SalesLines.PAGE.UpdateForm(TRUE)
    END;

    LOCAL PROCEDURE Prepayment37OnAfterValidate@19040510();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE SetDocNoVisible@2();
    VAR
      DocumentNoVisibility@1000 : Codeunit 1400;
      DocType@1003 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Reminder,FinChMemo';
    BEGIN
      DocNoVisible := DocumentNoVisibility.SalesDocumentNoIsVisible(DocType::Order,"No.");
    END;

    LOCAL PROCEDURE CustomerUsesOIOUBL@1060000(CustomerNo@1060000 : Code[20]) : Boolean;
    VAR
      Customer@1060001 : Record 18;
    BEGIN
      IF Customer.GET(CustomerNo) THEN
        EXIT (Customer."OIOUBL Profile Code" <> '');
      EXIT(FALSE)
    END;

    LOCAL PROCEDURE SetExtDocNoMandatoryCondition@5();
    VAR
      SalesReceivablesSetup@1000 : Record 311;
    BEGIN
      SalesReceivablesSetup.GET;
      ExternalDocNoMandatory := SalesReceivablesSetup."Ext. Doc. No. Mandatory"
    END;

    LOCAL PROCEDURE ShowPreview@6();
    VAR
      SalesPostYesNo@1000 : Codeunit 81;
    BEGIN
      SalesPostYesNo.Preview(Rec);
    END;

    LOCAL PROCEDURE SetControlVisibility@7();
    VAR
      ApprovalsMgmt@1002 : Codeunit 1535;
      WorkflowWebhookMgt@1000 : Codeunit 1543;
    BEGIN
      JobQueueVisible := "Job Queue Status" = "Job Queue Status"::"Scheduled for Posting";
      HasIncomingDocument := "Incoming Document Entry No." <> 0;
      SetExtDocNoMandatoryCondition;

      OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RECORDID);
      OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);
      CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RECORDID);

      WorkflowWebhookMgt.GetCanRequestAndCanCancel(RECORDID,CanRequestApprovalForFlow,CanCancelApprovalForFlow);
      IsCustomerOrContactNotEmpty := ("Sell-to Customer No." <> '') OR ("Sell-to Contact No." <> '');
    END;

    LOCAL PROCEDURE ShowPostedConfirmationMessage@17();
    VAR
      OrderSalesHeader@1003 : Record 36;
      SalesInvoiceHeader@1000 : Record 112;
      InstructionMgt@1002 : Codeunit 1330;
    BEGIN
      IF NOT OrderSalesHeader.GET("Document Type","No.") THEN BEGIN
        SalesInvoiceHeader.SETRANGE("No.","Last Posting No.");
        IF SalesInvoiceHeader.FINDFIRST THEN
          IF InstructionMgt.ShowConfirm(OpenPostedSalesOrderQst,InstructionMgt.ShowPostedConfirmationMessageCode) THEN
            PAGE.RUN(PAGE::"Posted Sales Invoice",SalesInvoiceHeader);
      END;
    END;

    LOCAL PROCEDURE UpdatePaymentService@1();
    VAR
      PaymentServiceSetup@1000 : Record 1060;
    BEGIN
      PaymentServiceVisible := PaymentServiceSetup.IsPaymentServiceVisible;
      PaymentServiceEnabled := PaymentServiceSetup.CanChangePaymentService(Rec);
    END;

    LOCAL PROCEDURE UpdateShipToBillToGroupVisibility@9();
    BEGIN
      CustomerMgt.CalculateShipToBillToOptions(ShipToOptions,BillToOptions,Rec);
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnBeforeStatisticsAction@8(VAR SalesHeader@1000 : Record 36;VAR Handled@1001 : Boolean);
    BEGIN
    END;

    PROCEDURE CheckNotificationsOnce@10();
    BEGIN
      CallNotificationCheck := TRUE;
    END;

    BEGIN
    END.
  }
}

