OBJECT Page 43 Sales Invoice
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836,NAVDK11.00.00.21836;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Salgsfaktura;
               ENU=Sales Invoice];
    SourceTable=Table36;
    SourceTableView=WHERE(Document Type=FILTER(Invoice));
    PageType=Document;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,RapportÇr,Godkend,Bogfõring,Forbered,Faktura,Frigiv,Anmod om godkendelse,Vis;
                                ENU=New,Process,Report,Approve,Posting,Prepare,Invoice,Release,Request Approval,View];
    OnInit=VAR
             SalesReceivablesSetup@1001 : Record 311;
           BEGIN
             JobQueuesUsed := SalesReceivablesSetup.JobQueueActive;
             SetExtDocNoMandatoryCondition;

             SellToCustomerUsesOIOUBL := CustomerUsesOIOUBL("Sell-to Customer No.");
           END;

    OnOpenPage=VAR
                 OfficeMgt@1000 : Codeunit 1630;
                 PermissionManager@1001 : Codeunit 9002;
               BEGIN
                 IF UserMgt.GetSalesFilter <> '' THEN BEGIN
                   FILTERGROUP(2);
                   SETRANGE("Responsibility Center",UserMgt.GetSalesFilter);
                   FILTERGROUP(0);
                 END;

                 SetDocNoVisible;
                 SetControlAppearance;

                 IF "Quote No." <> '' THEN
                   ShowQuoteNo := TRUE;

                 IF "No." = '' THEN
                   IF OfficeMgt.CheckForExistingInvoice("Sell-to Customer No.") THEN
                     ERROR(''); // Cancel invoice creation
                 IsSaaS := PermissionManager.SoftwareAsAService;
                 IF ("No." <> '') AND ("Sell-to Customer No." = '') THEN
                   DocumentIsPosted := (NOT GET("Document Type","No."));
               END;

    OnAfterGetRecord=BEGIN
                       ShowQuoteNo := "Quote No." <> '';

                       SetControlAppearance;
                       WorkDescription := GetWorkDescription;
                       UpdateShipToBillToGroupVisibility
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
                         EXIT(ConfirmCloseUnposted)
                     END;

    OnAfterGetCurrRecord=BEGIN
                           SellToCustomerUsesOIOUBL := CustomerUsesOIOUBL("Sell-to Customer No.");
                           CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
                           CurrPage.ApprovalFactBox.PAGE.UpdateApprovalEntriesFromSourceRecord(RECORDID);
                           ShowWorkflowStatus := CurrPage.WorkflowStatus.PAGE.SetFilterOnWorkflowRecord(RECORDID);

                           UpdatePaymentService;
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 57      ;1   ;ActionGroup;
                      CaptionML=[DAN=F&aktura;
                                 ENU=&Invoice];
                      Image=Invoice }
      { 59      ;2   ;Action    ;
                      Name=Statistics;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=FÜ vist statistiske oplysninger som f.eks. vërdien for bogfõrte poster til recorden.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled="No." <> '';
                      Image=Statistics;
                      PromotedCategory=Category7;
                      OnAction=VAR
                                 Handled@1000 : Boolean;
                               BEGIN
                                 OnBeforeStatisticsAction(Rec,Handled);
                                 IF NOT Handled THEN BEGIN
                                   CalcInvDiscForHeader;
                                   COMMIT;
                                   PAGE.RUNMODAL(PAGE::"Sales Statistics",Rec);
                                   SalesCalcDiscountByType.ResetRecalculateInvoiceDisc(Rec);
                                 END
                               END;
                                }
      { 171     ;2   ;Separator  }
      { 61      ;2   ;Action    ;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 67;
                      RunPageLink=Document Type=FIELD(Document Type),
                                  No.=FIELD(No.),
                                  Document Line No.=CONST(0);
                      Promoted=Yes;
                      Image=ViewComments;
                      PromotedCategory=Category7 }
      { 162     ;2   ;Action    ;
                      Name=Approvals;
                      AccessByPermission=TableData 454=R;
                      CaptionML=[DAN=Godkendelser;
                                 ENU=Approvals];
                      ToolTipML=[DAN=FÜ vist en liste over records, der afventer godkendelse. Du kan f.eks. se, hvem der har anmodet om godkendelse af recorden, hvornÜr den blev sendt og hvornÜr den skal godkendes.;
                                 ENU=View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Approvals;
                      PromotedCategory=Category9;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 WorkflowsEntriesBuffer@1001 : Record 832;
                               BEGIN
                                 WorkflowsEntriesBuffer.RunWorkflowEntriesPage(RECORDID,DATABASE::"Sales Header","Document Type","No.");
                               END;
                                }
      { 6       ;2   ;Action    ;
                      Name=Function_CustomerCard;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Debitor;
                                 ENU=Customer];
                      ToolTipML=[DAN=Se eller rediger detaljerede oplysninger om debitoren i salgsbilaget.;
                                 ENU=View or edit detailed information about the customer on the sales document.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 21;
                      RunPageLink=No.=FIELD(Sell-to Customer No.);
                      Promoted=Yes;
                      Enabled=IsCustomerOrContactNotEmpty;
                      PromotedIsBig=Yes;
                      Image=Customer;
                      PromotedCategory=Category7;
                      PromotedOnly=Yes }
      { 116     ;2   ;Action    ;
                      Name=Dimensions;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omrÜde, projekt eller afdeling, som du kan tildele til salgs- og kõbsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Enabled="No." <> '';
                      PromotedIsBig=Yes;
                      Image=Dimensions;
                      PromotedCategory=Category7;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 ShowDocDim;
                                 CurrPage.SAVERECORD;
                               END;
                                }
      { 1900000004;  ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 29      ;1   ;ActionGroup;
                      CaptionML=[DAN=Godkendelse;
                                 ENU=Approval] }
      { 27      ;2   ;Action    ;
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
                      OnAction=BEGIN
                                 ApprovalsMgmt.ApproveRecordApprovalRequest(RECORDID);
                               END;
                                }
      { 25      ;2   ;Action    ;
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
                      OnAction=BEGIN
                                 ApprovalsMgmt.RejectRecordApprovalRequest(RECORDID);
                               END;
                                }
      { 23      ;2   ;Action    ;
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
                      OnAction=BEGIN
                                 ApprovalsMgmt.DelegateRecordApprovalRequest(RECORDID);
                               END;
                                }
      { 21      ;2   ;Action    ;
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
      { 9       ;1   ;ActionGroup;
                      CaptionML=[DAN=Frigiv;
                                 ENU=Release];
                      Image=ReleaseDoc }
      { 123     ;2   ;Action    ;
                      Name=Release;
                      ShortCutKey=Ctrl+F9;
                      CaptionML=[DAN=F&rigiv;
                                 ENU=Re&lease];
                      ToolTipML=[DAN=Frigiv bilaget til nëste behandlingstrin. NÜr et bilag frigives, bliver det inkluderet i alle disponeringsberegninger fra den dato, varerne forventes modtaget. Du skal genÜbne bilaget, fõr du kan foretage ëndringer i det.;
                                 ENU=Release the document to the next stage of processing. When a document is released, it will be included in all availability calculations from the expected receipt date of the items. You must reopen the document before you can make changes to it.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Enabled=IsCustomerOrContactNotEmpty;
                      PromotedIsBig=Yes;
                      Image=ReleaseDoc;
                      PromotedCategory=Category8;
                      OnAction=VAR
                                 ReleaseSalesDoc@1000 : Codeunit 414;
                               BEGIN
                                 ReleaseSalesDoc.PerformManualRelease(Rec);
                               END;
                                }
      { 124     ;2   ;Action    ;
                      Name=Reopen;
                      CaptionML=[DAN=&èbn igen;
                                 ENU=Re&open];
                      ToolTipML=[DAN=èbn bilaget igen for at ëndre det, efter at det er blevet godkendt. Godkendte bilag har status Frigivet og skal Übnes, fõr de kan ëndres;
                                 ENU=Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Enabled=Status <> Status::Open;
                      PromotedIsBig=Yes;
                      Image=ReOpen;
                      PromotedCategory=Category8;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ReleaseSalesDoc@1001 : Codeunit 414;
                               BEGIN
                                 ReleaseSalesDoc.PerformManualReopen(Rec);
                               END;
                                }
      { 62      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 74      ;2   ;Action    ;
                      Name=CreatePurchaseInvoice;
                      CaptionML=[DAN=Opret kõbsfaktura;
                                 ENU=Create Purchase Invoice];
                      ToolTipML=[DAN=Opret en ny kõbsfaktura for at kõbe alle varer, der krëves af salgsdokumentet, selvom nogle af varerne allerede er tilgëngelige.;
                                 ENU=Create a new purchase invoice to buy all the items that are required by the sales document, even if some of the items are already available.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=No;
                      PromotedIsBig=Yes;
                      Image=NewPurchaseInvoice;
                      PromotedCategory=Category7;
                      OnAction=VAR
                                 SelectedSalesLine@1001 : Record 37;
                                 PurchDocFromSalesDoc@1000 : Codeunit 1314;
                               BEGIN
                                 CurrPage.SalesLines.PAGE.SETSELECTIONFILTER(SelectedSalesLine);
                                 PurchDocFromSalesDoc.CreatePurchaseInvoice(Rec,SelectedSalesLine);
                               END;
                                }
      { 66      ;2   ;Action    ;
                      Name=GetRecurringSalesLines;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Hent tilbagevendende salgslinjer;
                                 ENU=Get Recurring Sales Lines];
                      ToolTipML=[DAN=Indsët salgsdokumentlinjer, som du har angivet for debitoren som tilbagevendende. Tilbagevendende salgslinjer kan vëre en mÜnedlig genbestillingsordre eller en fast fragtudgift.;
                                 ENU=Insert sales document lines that you have set up for the customer as recurring. Recurring sales lines could be for a monthly replenishment order or a fixed freight expense.];
                      ApplicationArea=#Suite;
                      Enabled=IsCustomerOrContactNotEmpty;
                      PromotedIsBig=Yes;
                      Image=CustomerCode;
                      PromotedCategory=Category7;
                      OnAction=VAR
                                 StdCustSalesCode@1000 : Record 172;
                               BEGIN
                                 StdCustSalesCode.InsertSalesLines(Rec);
                               END;
                                }
      { 63      ;2   ;Action    ;
                      Name=CalculateInvoiceDiscount;
                      AccessByPermission=TableData 19=R;
                      CaptionML=[DAN=&Beregn fakturarabat;
                                 ENU=Calculate &Invoice Discount];
                      ToolTipML=[DAN=Beregn fakturarabatten for hele salgsdokumentet, nÜr alle salgsfakturalinjer er angivet.;
                                 ENU=Calculate the invoice discount for the entire sales document when all sales invoice lines are entered.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=IsCustomerOrContactNotEmpty;
                      Image=CalculateInvoiceDiscount;
                      PromotedCategory=Category6;
                      OnAction=BEGIN
                                 ApproveCalcInvDisc;
                                 SalesCalcDiscountByType.ResetRecalculateInvoiceDisc(Rec);
                               END;
                                }
      { 64      ;2   ;Action    ;
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
      { 115     ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Flyt negative linjer;
                                 ENU=Move Negative Lines];
                      ToolTipML=[DAN=Gõr dig klar til at oprette en erstatningssalgsordre i en salgsreturproces.;
                                 ENU=Prepare to create a replacement sales order in a sales return process.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Image=MoveNegativeLines;
                      PromotedCategory=Category6;
                      OnAction=BEGIN
                                 CLEAR(MoveNegSalesLines);
                                 MoveNegSalesLines.SetSalesHeader(Rec);
                                 MoveNegSalesLines.RUNMODAL;
                                 MoveNegSalesLines.ShowDocument;
                               END;
                                }
      { 47      ;2   ;ActionGroup;
                      CaptionML=[DAN=IndgÜende bilag;
                                 ENU=Incoming Document];
                      ActionContainerType=NewDocumentItems;
                      Image=Documents }
      { 45      ;3   ;Action    ;
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
      { 41      ;3   ;Action    ;
                      Name=SelectIncomingDoc;
                      AccessByPermission=TableData 130=R;
                      CaptionML=[DAN=Vëlg indgÜende bilag;
                                 ENU=Select Incoming Document];
                      ToolTipML=[DAN=Vëlg en indgÜende bilagsrecord og vedhëftet fil, der skal knyttes til posten eller dokumentet.;
                                 ENU=Select an incoming document record and file attachment that you want to link to the entry or document.];
                      ApplicationArea=#Basic,#Suite;
                      Image=SelectLineToApply;
                      OnAction=VAR
                                 IncomingDocument@1000 : Record 130;
                               BEGIN
                                 VALIDATE("Incoming Document Entry No.",IncomingDocument.SelectIncomingDocument("Incoming Document Entry No.",RECORDID));
                               END;
                                }
      { 39      ;3   ;Action    ;
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
      { 37      ;3   ;Action    ;
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
      { 49      ;1   ;ActionGroup;
                      CaptionML=[DAN=Anmod om godkendelse;
                                 ENU=Request Approval] }
      { 159     ;2   ;Action    ;
                      Name=SendApprovalRequest;
                      CaptionML=[DAN=Send godkendelsesan&modning;
                                 ENU=Send A&pproval Request];
                      ToolTipML=[DAN=Anmod om godkendelse af bilaget.;
                                 ENU=Request approval of the document.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=NOT OpenApprovalEntriesExist AND CanRequestApprovalForFlow;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category9;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 IF ApprovalsMgmt.CheckSalesApprovalPossible(Rec) THEN
                                   ApprovalsMgmt.OnSendSalesDocForApproval(Rec);
                               END;
                                }
      { 160     ;2   ;Action    ;
                      Name=CancelApprovalRequest;
                      CaptionML=[DAN=Annuller godk&endelsesanmodning;
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
                                 WorkflowWebhookMgt@1000 : Codeunit 1543;
                               BEGIN
                                 ApprovalsMgmt.OnCancelSalesApprovalRequest(Rec);
                                 WorkflowWebhookMgt.FindAndCancel(RECORDID);
                               END;
                                }
      { 215     ;2   ;ActionGroup;
                      CaptionML=[DAN=Workflow;
                                 ENU=Flow];
                      Image=Flow }
      { 216     ;3   ;Action    ;
                      Name=CreateFlow;
                      CaptionML=[DAN=Opret et workflow;
                                 ENU=Create a Flow];
                      ToolTipML=[DAN=Opret et nyt workflow fra en liste over relevante workflowskabeloner.;
                                 ENU=Create a new Flow from a list of relevant Flow templates.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=IsSaaS;
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
      { 217     ;3   ;Action    ;
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
      { 69      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Bogfõring;
                                 ENU=P&osting];
                      Image=Post }
      { 71      ;2   ;Action    ;
                      Name=Post;
                      ShortCutKey=F9;
                      CaptionML=[DAN=B&ogfõr;
                                 ENU=P&ost];
                      ToolTipML=[DAN=Fërdiggõr bilaget eller kladden ved at bogfõre belõb og antal pÜ de relaterede konti i regnskaberne.;
                                 ENU=Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostOrder;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 Post(CODEUNIT::"Sales-Post (Yes/No)",NavigateAfterPost::"Posted Document");
                               END;
                                }
      { 7       ;2   ;Action    ;
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
                      PromotedCategory=Category5;
                      OnAction=BEGIN
                                 Post(CODEUNIT::"Sales-Post (Yes/No)",NavigateAfterPost::"New Document");
                               END;
                                }
      { 76      ;2   ;Action    ;
                      Name=PostAndSend;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Bogfõr og &send;
                                 ENU=Post and &Send];
                      ToolTipML=[DAN=Fërdiggõr bilaget, og klargõr det til afsendelse i henhold til debitorens afsendelsesprofil, f.eks. vedhëftet en mail. Vinduet Send dokument til vises, sÜ du kan bekrëfte eller vëlge en afsendelsesprofil.;
                                 ENU=Finalize and prepare to send the document according to the customer's sending profile, such as attached to an email. The Send document to window opens first so you can confirm or select a sending profile.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=PostSendTo;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 Post(CODEUNIT::"Sales-Post and Send",NavigateAfterPost::Nowhere);
                               END;
                                }
      { 68      ;2   ;Action    ;
                      Name=Preview;
                      CaptionML=[DAN=Vis bogfõring;
                                 ENU=Preview Posting];
                      ToolTipML=[DAN=Gennemse de forskellige typer poster, der oprettes, nÜr du bogfõrer bilaget eller kladden.;
                                 ENU=Review the different types of entries that will be created when you post the document or journal.];
                      ApplicationArea=#Basic,#Suite;
                      Image=ViewPostedOrder;
                      PromotedCategory=Category5;
                      OnAction=BEGIN
                                 ShowPreview;
                               END;
                                }
      { 55      ;2   ;Action    ;
                      Name=DraftInvoice;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kladdefaktura;
                                 ENU=Draft Invoice];
                      ToolTipML=[DAN=Se eller udskriv salgsfaktura som en kladde, fõr du udfõrer den faktiske bogfõring.;
                                 ENU=View or print the sales invoice as a draft before you perform the actual posting.];
                      ApplicationArea=#Basic,#Suite;
                      Image=ViewPostedOrder;
                      PromotedCategory=Category5;
                      OnAction=VAR
                                 DocumentPrint@1000 : Codeunit 229;
                               BEGIN
                                 DocumentPrint.PrintSalesHeader(Rec);
                               END;
                                }
      { 50      ;2   ;Action    ;
                      Name=ProformaInvoice;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Proformafaktura;
                                 ENU=Pro Forma Invoice];
                      ToolTipML=[DAN=FÜ vist eller udskriv fakturaen for proformasalg.;
                                 ENU=View or print the pro forma sales invoice.];
                      Image=ViewPostedOrder;
                      PromotedCategory=Category5;
                      OnAction=VAR
                                 DocumentPrint@1000 : Codeunit 229;
                               BEGIN
                                 DocumentPrint.PrintProformaSalesInvoice(Rec);
                               END;
                                }
      { 78      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Testrapport;
                                 ENU=Test Report];
                      ToolTipML=[DAN=Vis en testrapport, sÜ du kan finde og rette eventuelle fejl, fõr du udfõrer den faktiske bogfõring af kladden eller bilaget.;
                                 ENU=View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Image=TestReport;
                      PromotedCategory=Category5;
                      OnAction=BEGIN
                                 ReportPrint.PrintSalesHeader(Rec);
                               END;
                                }
      { 3       ;2   ;Action    ;
                      CaptionML=[DAN=Fjern fra opgavekõ;
                                 ENU=Remove From Job Queue];
                      ToolTipML=[DAN=Fjern den planlagte behandling af denne record fra jobkõen.;
                                 ENU=Remove the scheduled processing of this record from the job queue.];
                      ApplicationArea=#Advanced;
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
                CaptionML=[DAN=Generelt;
                           ENU=General];
                GroupType=Group }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#All;
                SourceExpr="No.";
                Importance=Additional;
                Visible=DocNoVisible;
                OnAssistEdit=BEGIN
                               IF AssistEdit(xRec) THEN
                                 CurrPage.UPDATE;
                             END;
                              }

    { 53  ;2   ;Field     ;
                CaptionML=[DAN=Debitornr.;
                           ENU=Customer No.];
                ToolTipML=[DAN=Angiver nummeret pÜ den debitor, der modtager produkterne og faktureres som standard.;
                           ENU=Specifies the number of the customer who will receive the products and be billed by default.];
                ApplicationArea=#Basic,#Suite;
                NotBlank=Yes;
                SourceExpr="Sell-to Customer No.";
                Importance=Additional;
                Visible=NOT IsSaaS;
                OnValidate=BEGIN
                             SelltoCustomerNoOnAfterValidate(Rec,xRec);
                             CurrPage.UPDATE;
                           END;
                            }

    { 4   ;2   ;Field     ;
                CaptionML=[DAN=Debitornavn;
                           ENU=Customer Name];
                ToolTipML=[DAN=Angiver navnet pÜ den debitor, der modtager produkterne og faktureres som standard.;
                           ENU=Specifies the name of the customer who will receive the products and be billed by default.];
                ApplicationArea=#Basic,#Suite;
                NotBlank=Yes;
                SourceExpr="Sell-to Customer Name";
                Importance=Promoted;
                OnValidate=VAR
                             ApplicationAreaSetup@1000 : Record 9178;
                           BEGIN
                             SelltoCustomerNoOnAfterValidate(Rec,xRec);

                             IF ApplicationAreaSetup.IsFoundationEnabled THEN
                               SalesCalcDiscountByType.ApplyDefaultInvoiceDiscount(0,Rec);

                             CurrPage.UPDATE;
                             SellToCustomerUsesOIOUBL := CustomerUsesOIOUBL("Sell-to Customer No.");
                           END;

                ShowMandatory=TRUE }

    { 100 ;2   ;Group     ;
                CaptionML=[DAN=Kunde;
                           ENU=Sell-to];
                GroupType=Group }

    { 75  ;3   ;Field     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                ToolTipML=[DAN=Angiver adressen pÜ debitorens lokalitet.;
                           ENU=Specifies the address where the customer is located.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Address";
                Importance=Additional }

    { 77  ;3   ;Field     ;
                CaptionML=[DAN=Adresse 2;
                           ENU=Address 2];
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Address 2";
                Importance=Additional }

    { 80  ;3   ;Field     ;
                CaptionML=[DAN=Postnr.;
                           ENU=Post Code];
                ToolTipML=[DAN=Angiver postnummer.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Post Code";
                Importance=Additional }

    { 79  ;3   ;Field     ;
                CaptionML=[DAN=By;
                           ENU=City];
                ToolTipML=[DAN=Angiver debitorens by pÜ salgsdokumentet.;
                           ENU=Specifies the city of the customer on the sales document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to City";
                Importance=Additional }

    { 87  ;3   ;Field     ;
                CaptionML=[DAN=Kontaktnr.;
                           ENU=Contact No.];
                ToolTipML=[DAN=Angiver nummeret pÜ den kontakt, som salgsdokumentet sendes til.;
                           ENU=Specifies the number of the contact that the sales document will be sent to.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Contact No.";
                Importance=Additional;
                OnValidate=BEGIN
                             IF ApplicationAreaSetup.IsAdvanced THEN
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
                Editable="Sell-to Customer No." <> '';
                ShowMandatory=SellToCustomerUsesOIOUBL }

    { 1101100006;2;Field  ;
                ToolTipML=[DAN=Angiver telefonnummeret pÜ kontaktpersonen hos debitoren.;
                           ENU=Specifies the telephone number of the contact person at the customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Contact Phone No." }

    { 1101100003;2;Field  ;
                ToolTipML=[DAN="Angiver faxnummeret pÜ kontaktpersonen hos debitoren. ";
                           ENU="Specifies the fax number of the contact person at the customer. "];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Contact Fax No." }

    { 1101100000;2;Field  ;
                ToolTipML=[DAN=Angiver mailadressen pÜ kontaktpersonen hos debitoren.;
                           ENU=Specifies the email address of the contact person at the customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Contact E-Mail" }

    { 1101100004;2;Field  ;
                ToolTipML=[DAN=Angiver rollen for kontaktpersonen hos debitoren.;
                           ENU=Specifies the role of the contact person at the customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Contact Role" }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitors reference. Referencen bliver udskrevet pÜ salgsdokumentet.;
                           ENU=Specifies the customer's reference. The contents will be printed on sales documents.];
                ApplicationArea=#Advanced;
                SourceExpr="Your Reference";
                Importance=Additional }

    { 43  ;2   ;Field     ;
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

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvornÜr salgsfakturaen skal betales.;
                           ENU=Specifies when the sales invoice must be paid.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Due Date";
                Importance=Promoted }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ det indgÜende bilag, som dette salgsbilag er oprettet til.;
                           ENU=Specifies the number of the incoming document that this sales document is created for.];
                ApplicationArea=#Advanced;
                SourceExpr="Incoming Document Entry No.";
                Importance=Additional;
                Visible=FALSE }

    { 126 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer, som bliver brugt i debitors eller kreditors nummereringssystem.;
                           ENU=Specifies a document number that refers to the customer's or vendor's numbering system.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="External Document No.";
                Importance=Additional;
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
                            }

    { 129 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den kampagne, som dokumentet er tilknyttet.;
                           ENU=Specifies the number of the campaign that the document is linked to.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Campaign No.";
                Importance=Additional }

    { 118 ;2   ;Field     ;
                AccessByPermission=TableData 5714=R;
                ToolTipML=[DAN=Angiver den kode for ansvarscenteret (f.eks. et distributionscenter), som er tildelt den involverede bruger, virksomhed, debitor eller kreditor.;
                           ENU=Specifies the code of the responsibility center, such as a distribution hub, that is associated with the involved user, company, customer, or vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Responsibility Center";
                Importance=Additional }

    { 67  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der er ansvarlig for bilaget.;
                           ENU=Specifies the ID of the user who is responsible for the document.];
                ApplicationArea=#Advanced;
                SourceExpr="Assigned User ID";
                Importance=Additional }

    { 112 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om dokumentet er Übent, venter pÜ godkendelse, er faktureret til forudbetaling eller er frigivet til nëste fase i behandlingen.;
                           ENU=Specifies whether the document is open, waiting to be approved, has been invoiced for prepayment, or has been released to the next stage of processing.];
                ApplicationArea=#Suite;
                SourceExpr=Status;
                Importance=Additional }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for en opgavekõpost eller opgave, der hÜndterer bogfõringen af salgsfakturaer.;
                           ENU=Specifies the status of a job queue entry or task that handles the posting of sales invoices.];
                ApplicationArea=#All;
                SourceExpr="Job Queue Status";
                Importance=Additional;
                Visible=JobQueuesUsed }

    { 135 ;2   ;Group     ;
                CaptionML=[DAN=Arbejdsbeskrivelse;
                           ENU=Work Description];
                GroupType=Group }

    { 117 ;3   ;Field     ;
                ToolTipML=[DAN=Angiver produkterne eller servicen, der tilbydes;
                           ENU=Specifies the products or service being offered];
                ApplicationArea=#Advanced;
                SourceExpr=WorkDescription;
                Importance=Additional;
                MultiLine=Yes;
                OnValidate=BEGIN
                             SetWorkDescription(WorkDescription);
                           END;

                ShowCaption=No }

    { 56  ;1   ;Part      ;
                Name=SalesLines;
                ApplicationArea=#Basic,#Suite;
                SubPageLink=Document No.=FIELD(No.);
                PagePartID=Page47;
                Enabled="Sell-to Customer No." <> '';
                Editable="Sell-to Customer No." <> '' }

    { 1905885101;1;Group  ;
                CaptionML=[DAN=Fakturadetaljer;
                           ENU=Invoice Details];
                GroupType=Group }

    { 107 ;2   ;Field     ;
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

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvornÜr varerne pÜ bilaget er sendt eller leveret. En afsendelsesdato beregnes normalt ud fra en õnsket leveringsdato plus leveringstiden.;
                           ENU=Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Shipment Date";
                Importance=Promoted }

    { 58  ;2   ;Group     ;
                Visible=ShowQuoteNo;
                GroupType=Group }

    { 83  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ det salgstilbud, salgsordren blev oprettet fra. Du kan spore nummeret til salgstilbudsdokumenter, som du har udskrevet, gemt eller sendt pr. mail.;
                           ENU=Specifies the number of the sales quote that the sales order was created from. You can track the number to sales quote documents that you have printed, saved, or emailed.];
                ApplicationArea=#All;
                SourceExpr="Quote No." }

    { 121 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om felterne Enhedspris og Linjebelõb pÜ bilagslinjer skal vises med eller uden moms.;
                           ENU=Specifies if the Unit Price and Line Amount fields on document lines should be shown with or without VAT.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Prices Including VAT" }

    { 156 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede debitors eller kreditors momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogfõringsopsëtning.;
                           ENU=Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Bus. Posting Group";
                OnValidate=VAR
                             ApplicationAreaSetup@1000 : Record 9178;
                           BEGIN
                             IF ApplicationAreaSetup.IsFoundationEnabled THEN
                               SalesCalcDiscountByType.ApplyDefaultInvoiceDiscount(0,Rec);

                             CurrPage.UPDATE;
                           END;
                            }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en formel, der beregner betalingens forfaldsdato, kontantrabatdato og kontantrabatbelõb.;
                           ENU=Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Terms Code";
                Importance=Promoted }

    { 101 ;2   ;Field     ;
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

    { 72  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om transaktionen er relateret til handel med tredjepart i EU.;
                           ENU=Specifies if the transaction is related to trade with a third party within the EU.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="EU 3-Party Trade" }

    { 174 ;2   ;Group     ;
                Visible=PaymentServiceVisible;
                GroupType=Group }

    { 175 ;3   ;Field     ;
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

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den transaktionstype, som bilaget reprësenterer med henblik pÜ rapportering til INTRASTAT.;
                           ENU=Specifies the type of transaction that the document represents, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Transaction Type" }

    { 84  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 1 Code";
                OnValidate=BEGIN
                             CurrPage.UPDATE;
                           END;
                            }

    { 88  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 2 Code";
                OnValidate=BEGIN
                             CurrPage.UPDATE;
                           END;
                            }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den rabatprocent, der tildeles, hvis debitoren betaler fõr eller pÜ den dato, der er angivet i feltet Kont.rabatdato.;
                           ENU=Specifies the payment discount percentage granted if the customer pays on or before the date entered in the Pmt. Discount Date field.];
                ApplicationArea=#Advanced;
                SourceExpr="Payment Discount %" }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor belõbet i posten skal vëre betalt, for at der kan opnÜs kontantrabat.;
                           ENU=Specifies the date on which the amount in the entry must be paid for a payment discount to be granted.];
                ApplicationArea=#Advanced;
                SourceExpr="Pmt. Discount Date";
                Importance=Additional }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den Direct Debit-betalingsaftale, som debitoren har underskrevet for at tillade Direct Debit-opkrëvning af betalinger.;
                           ENU=Specifies the direct-debit mandate that the customer has signed to allow direct debit collection of payments.];
                ApplicationArea=#Advanced;
                SourceExpr="Direct Debit Mandate ID" }

    { 90  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver placeringen, hvor lagervarer til debitoren pÜ salgsbilaget skal sendes som standard.;
                           ENU=Specifies the location from where inventory items to the customer on the sales document are to be shipped by default.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Importance=Additional }

    { 1900000002;1;Group  ;
                CaptionML=[DAN=Forsendelse og fakturering;
                           ENU=Shipping and Billing];
                Enabled="Sell-to Customer No." <> '';
                GroupType=Group }

    { 34  ;2   ;Group     ;
                GroupType=Group }

    { 200 ;3   ;Group     ;
                GroupType=Group }

    { 201 ;4   ;Field     ;
                Name=ShippingOptions;
                CaptionML=[DAN=Leveres til;
                           ENU=Ship-to];
                ToolTipML=[DAN=Angiver den adresse, som produkter i salgsdokumentet skal leveres til. Standard (Kundeadresse): Det samme som kundens adresse. Alternativ leveringsadresse: ên af kundens alternative leveringsadresser. Brugerdefineret adresse: En vilkÜrlig leveringsadresse, som du angiver i nedenstÜende felter.;
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

    { 202 ;4   ;Group     ;
                Visible=NOT (ShipToOptions = ShipToOptions::"Default (Sell-to Address)");
                GroupType=Group }

    { 65  ;5   ;Field     ;
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

    { 36  ;5   ;Field     ;
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver navnet, som produkter i salgsdokumentet skal leveres til.;
                           ENU=Specifies the name that products on the sales document will be shipped to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Name";
                Editable=ShipToOptions = ShipToOptions::"Custom Address" }

    { 38  ;5   ;Field     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                ToolTipML=[DAN=Angiver den adresse, som produkter i salgsdokumentet skal leveres til.;
                           ENU=Specifies the address that products on the sales document will be shipped to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Address";
                Editable=ShipToOptions = ShipToOptions::"Custom Address" }

    { 40  ;5   ;Field     ;
                CaptionML=[DAN=Adresse 2;
                           ENU=Address 2];
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Address 2";
                Editable=ShipToOptions = ShipToOptions::"Custom Address" }

    { 93  ;5   ;Field     ;
                CaptionML=[DAN=Postnr.;
                           ENU=Post Code];
                ToolTipML=[DAN=Angiver postnummer.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Post Code";
                Editable=ShipToOptions = ShipToOptions::"Custom Address" }

    { 42  ;5   ;Field     ;
                CaptionML=[DAN=By;
                           ENU=City];
                ToolTipML=[DAN=Angiver debitorens by pÜ salgsdokumentet.;
                           ENU=Specifies the city of the customer on the sales document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to City";
                Editable=ShipToOptions = ShipToOptions::"Custom Address" }

    { 17  ;5   ;Field     ;
                CaptionML=[DAN=Land/omrÜde;
                           ENU=Country/Region];
                ToolTipML=[DAN=Angiver debitorens land/omrÜde.;
                           ENU=Specifies the customer's country/region.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Country/Region Code";
                Importance=Additional;
                Editable=ShipToOptions = ShipToOptions::"Custom Address" }

    { 44  ;4   ;Field     ;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                ToolTipML=[DAN=Angiver navnet pÜ kontaktpersonen pÜ den adresse, som produkter i salgsdokumentet skal leveres til.;
                           ENU=Specifies the name of the contact person at the address that products on the sales document will be shipped to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Contact" }

    { 16  ;3   ;Group     ;
                CaptionML=[DAN=Leveringsform;
                           ENU=Shipment Method];
                GroupType=Group }

    { 46  ;4   ;Field     ;
                CaptionML=[DAN=Kode;
                           ENU=Code];
                ToolTipML=[DAN=Angiver, hvordan varer i salgsdokumentet sendes til debitoren.;
                           ENU=Specifies how items on the sales document are shipped to the customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Shipment Method Code";
                Importance=Additional }

    { 103 ;4   ;Field     ;
                CaptionML=[DAN=Speditõr;
                           ENU=Agent];
                ToolTipML=[DAN=Angiver, hvilken speditõr der bruges til at transportere varerne pÜ salgsbilaget til debitoren.;
                           ENU=Specifies which shipping agent is used to transport the items on the sales document to the customer.];
                ApplicationArea=#Suite;
                SourceExpr="Shipping Agent Code";
                Importance=Additional }

    { 11  ;4   ;Field     ;
                CaptionML=[DAN=Speditõrservice;
                           ENU=Agent service];
                ToolTipML=[DAN=Angiver, hvilken speditõrservice der bruges til at transportere varerne pÜ salgsbilaget til debitoren.;
                           ENU=Specifies which shipping agent service is used to transport the items on the sales document to the customer.];
                ApplicationArea=#Suite;
                SourceExpr="Shipping Agent Service Code";
                Importance=Additional }

    { 105 ;4   ;Field     ;
                ToolTipML=[DAN=Angiver speditõrens pakkenummer.;
                           ENU=Specifies the shipping agent's package number.];
                ApplicationArea=#Suite;
                SourceExpr="Package Tracking No.";
                Importance=Additional }

    { 203 ;2   ;Group     ;
                GroupType=Group }

    { 204 ;3   ;Field     ;
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

    { 205 ;3   ;Group     ;
                Visible=BillToOptions = BillToOptions::"Another Customer";
                GroupType=Group }

    { 14  ;4   ;Field     ;
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver den debitor, du vil sende salgsfakturaen til, nÜr det er til en anden debitor end den, du sëlger til.;
                           ENU=Specifies the customer to whom you will send the sales invoice, when different from the customer that you are selling to.];
                ApplicationArea=#Basic,#Suite;
                NotBlank=Yes;
                SourceExpr="Bill-to Name";
                Importance=Promoted;
                OnValidate=VAR
                             ApplicationAreaSetup@1000 : Record 9178;
                           BEGIN
                             IF GETFILTER("Bill-to Customer No.") = xRec."Bill-to Customer No." THEN
                               IF "Bill-to Customer No." <> xRec."Bill-to Customer No." THEN
                                 SETRANGE("Bill-to Customer No.");

                             IF ApplicationAreaSetup.IsFoundationEnabled THEN
                               SalesCalcDiscountByType.ApplyDefaultInvoiceDiscount(0,Rec);

                             CurrPage.UPDATE;
                           END;
                            }

    { 18  ;4   ;Field     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                ToolTipML=[DAN=Angiver debitorens adresse, som du vil sende fakturaen til.;
                           ENU=Specifies the address of the customer that you will send the invoice to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bill-to Address";
                Importance=Additional;
                Enabled="Bill-to Customer No." <> "Sell-to Customer No.";
                Editable="Bill-to Customer No." <> "Sell-to Customer No." }

    { 20  ;4   ;Field     ;
                CaptionML=[DAN=Adresse 2;
                           ENU=Address 2];
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bill-to Address 2";
                Importance=Additional;
                Enabled="Bill-to Customer No." <> "Sell-to Customer No.";
                Editable="Bill-to Customer No." <> "Sell-to Customer No." }

    { 85  ;4   ;Field     ;
                CaptionML=[DAN=Postnr.;
                           ENU=Post Code];
                ToolTipML=[DAN=Angiver postnummer.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bill-to Post Code";
                Importance=Additional;
                Enabled="Bill-to Customer No." <> "Sell-to Customer No.";
                Editable="Bill-to Customer No." <> "Sell-to Customer No." }

    { 22  ;4   ;Field     ;
                CaptionML=[DAN=By;
                           ENU=City];
                ToolTipML=[DAN=Angiver debitorens by pÜ salgsdokumentet.;
                           ENU=Specifies the city of the customer on the sales document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bill-to City";
                Importance=Additional;
                Enabled="Bill-to Customer No." <> "Sell-to Customer No.";
                Editable="Bill-to Customer No." <> "Sell-to Customer No." }

    { 86  ;4   ;Field     ;
                CaptionML=[DAN=Kontaktnr.;
                           ENU=Contact No.];
                ToolTipML=[DAN=Angiver nummeret pÜ den kontakt, som fakturaen skal sendes til.;
                           ENU=Specifies the number of the contact the invoice will be sent to.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to Contact No.";
                Importance=Additional;
                Enabled="Bill-to Customer No." <> "Sell-to Customer No.";
                Editable="Bill-to Customer No." <> "Sell-to Customer No." }

    { 24  ;4   ;Field     ;
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
                             CurrPage.SalesLines.PAGE.UpdatePage(TRUE);
                           END;
                            }

    { 1060001;2;Field     ;
                ToolTipML=[DAN=Angiver den profil, som debitoren krëver til elektroniske dokumenter.;
                           ENU=Specifies the profile that the customer requires for electronic documents.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="OIOUBL Profile Code" }

    { 1907468901;1;Group  ;
                CaptionML=[DAN=Udenrigshandel;
                           ENU=Foreign Trade];
                GroupType=Group }

    { 99  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en specifikation af bilagets transaktion med henblik pÜ rapportering til INTRASTAT.;
                           ENU=Specifies a specification of the document's transaction, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Transaction Specification" }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver transportmÜden ved rapportering til INTRASTAT.;
                           ENU=Specifies the transport method, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Transport Method" }

    { 95  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det udfõrselssted, hvor varerne blev udfõrt af landet/omrÜdet med henblik pÜ rapportering til Intrastat.;
                           ENU=Specifies the point of exit through which you ship the items out of your country/region, for reporting to Intrastat.];
                ApplicationArea=#Advanced;
                SourceExpr="Exit Point" }

    { 97  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitors eller kreditors omrÜde med henblik pÜ rapportering til INTRASTAT.;
                           ENU=Specifies the area of the customer or vendor, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr=Area }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 31  ;1   ;Part      ;
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
                Visible=FALSE;
                PartType=Page }

    { 1907234507;1;Part   ;
                ApplicationArea=#Advanced;
                SubPageLink=No.=FIELD(Bill-to Customer No.);
                PagePartID=Page9081;
                Visible=FALSE;
                PartType=Page }

    { 1902018507;1;Part   ;
                ApplicationArea=#Advanced;
                SubPageLink=No.=FIELD(Bill-to Customer No.);
                PagePartID=Page9082;
                PartType=Page }

    { 1900316107;1;Part   ;
                ApplicationArea=#Advanced;
                SubPageLink=No.=FIELD(Sell-to Customer No.);
                PagePartID=Page9084;
                PartType=Page }

    { 1906127307;1;Part   ;
                ApplicationArea=#Advanced;
                SubPageLink=Document Type=FIELD(Document Type),
                            Document No.=FIELD(Document No.),
                            Line No.=FIELD(Line No.);
                PagePartID=Page9087;
                ProviderID=56;
                Visible=FALSE;
                PartType=Page }

    { 1901314507;1;Part   ;
                ApplicationArea=#Advanced;
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page9089;
                ProviderID=56;
                PartType=Page }

    { 33  ;1   ;Part      ;
                Name=IncomingDocAttachFactBox;
                ApplicationArea=#Advanced;
                PagePartID=Page193;
                Visible=FALSE;
                PartType=Page;
                ShowFilter=No }

    { 1906354007;1;Part   ;
                Name=ApprovalFactBox;
                ApplicationArea=#Advanced;
                PagePartID=Page9092;
                Visible=FALSE;
                PartType=Page }

    { 1907012907;1;Part   ;
                ApplicationArea=#Advanced;
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page9108;
                ProviderID=56;
                Visible=FALSE;
                PartType=Page }

    { 51  ;1   ;Part      ;
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
      ApplicationAreaSetup@1011 : Record 9178;
      CopySalesDoc@1002 : Report 292;
      MoveNegSalesLines@1006 : Report 6699;
      ReportPrint@1003 : Codeunit 228;
      UserMgt@1004 : Codeunit 5700;
      SalesCalcDiscountByType@1007 : Codeunit 56;
      ApprovalsMgmt@1013 : Codeunit 1535;
      LinesInstructionMgt@1015 : Codeunit 1320;
      CustomerMgt@1059 : Codeunit 1302;
      ChangeExchangeRate@1001 : Page 511;
      NavigateAfterPost@1017 : 'Posted Document,New Document,Nowhere';
      WorkDescription@1018 : Text;
      HasIncomingDocument@1012 : Boolean;
      DocNoVisible@1005 : Boolean;
      SellToCustomerUsesOIOUBL@1060000 : Boolean;
      ExternalDocNoMandatory@1008 : Boolean;
      OpenApprovalEntriesExistForCurrUser@1009 : Boolean;
      OpenApprovalEntriesExist@1000 : Boolean;
      ShowWorkflowStatus@1010 : Boolean;
      PaymentServiceVisible@1032 : Boolean;
      PaymentServiceEnabled@1033 : Boolean;
      OpenPostedSalesInvQst@1020 : TextConst 'DAN=Fakturaen er blevet bogfõrt og flyttet til vinduet Bogfõrte salgsfakturaer.\\Vil du Übne den bogfõrte faktura?;ENU=The invoice has been posted and moved to the Posted Sales Invoices window.\\Do you want to open the posted invoice?';
      IsCustomerOrContactNotEmpty@1021 : Boolean;
      ShowQuoteNo@1029 : Boolean;
      JobQueuesUsed@1031 : Boolean;
      CanCancelApprovalForRecord@1014 : Boolean;
      DocumentIsPosted@1016 : Boolean;
      ShipToOptions@1050 : 'Default (Sell-to Address),Alternate Shipping Address,Custom Address';
      BillToOptions@1051 : 'Default (Customer),Another Customer';
      EmptyShipToCodeErr@1052 : TextConst 'DAN=Kodefeltet mÜ kun vëre tomt, hvis du vëlger Brugerdefineret adresse i feltet Leveres til.;ENU=The Code field can only be empty if you select Custom Address in the Ship-to field.';
      IsSaaS@1019 : Boolean;
      CanRequestApprovalForFlow@1023 : Boolean;
      CanCancelApprovalForFlow@1022 : Boolean;

    LOCAL PROCEDURE Post@4(PostingCodeunitID@1000 : Integer;Navigate@1005 : Option);
    VAR
      SalesHeader@1002 : Record 36;
      SalesInvoiceHeader@1003 : Record 112;
      OfficeMgt@1004 : Codeunit 1630;
      InstructionMgt@1006 : Codeunit 1330;
      PreAssignedNo@1001 : Code[20];
      IsScheduledPosting@1007 : Boolean;
    BEGIN
      LinesInstructionMgt.SalesCheckAllLinesHaveQuantityAssigned(Rec);
      PreAssignedNo := "No.";

      SendToPosting(PostingCodeunitID);

      IsScheduledPosting := "Job Queue Status" = "Job Queue Status"::"Scheduled for Posting";
      DocumentIsPosted := (NOT SalesHeader.GET("Document Type","No.")) OR IsScheduledPosting;

      IF IsScheduledPosting THEN
        CurrPage.CLOSE;
      CurrPage.UPDATE(FALSE);

      IF PostingCodeunitID <> CODEUNIT::"Sales-Post (Yes/No)" THEN
        EXIT;

      IF OfficeMgt.IsAvailable THEN BEGIN
        SalesInvoiceHeader.SETCURRENTKEY("Pre-Assigned No.");
        SalesInvoiceHeader.SETRANGE("Pre-Assigned No.",PreAssignedNo);
        IF SalesInvoiceHeader.FINDFIRST THEN
          PAGE.RUN(PAGE::"Posted Sales Invoice",SalesInvoiceHeader);
      END ELSE
        CASE Navigate OF
          NavigateAfterPost::"Posted Document":
            IF InstructionMgt.IsEnabled(InstructionMgt.ShowPostedConfirmationMessageCode) THEN
              ShowPostedConfirmationMessage(PreAssignedNo);
          NavigateAfterPost::"New Document":
            IF DocumentIsPosted THEN BEGIN
              SalesHeader.INIT;
              SalesHeader.VALIDATE("Document Type",SalesHeader."Document Type"::Invoice);
              SalesHeader.INSERT(TRUE);
              PAGE.RUN(PAGE::"Sales Invoice",SalesHeader);
            END;
        END;
    END;

    LOCAL PROCEDURE ApproveCalcInvDisc@8();
    BEGIN
      CurrPage.SalesLines.PAGE.ApproveCalcInvDisc;
    END;

    LOCAL PROCEDURE ShowPostedConfirmationMessage@17(PreAssignedNo@1001 : Code[20]);
    VAR
      SalesInvoiceHeader@1000 : Record 112;
      InstructionMgt@1002 : Codeunit 1330;
    BEGIN
      SalesInvoiceHeader.SETCURRENTKEY("Pre-Assigned No.");
      SalesInvoiceHeader.SETRANGE("Pre-Assigned No.",PreAssignedNo);
      IF SalesInvoiceHeader.FINDFIRST THEN
        IF InstructionMgt.ShowConfirm(OpenPostedSalesInvQst,InstructionMgt.ShowPostedConfirmationMessageCode) THEN
          PAGE.RUN(PAGE::"Posted Sales Invoice",SalesInvoiceHeader);
    END;

    LOCAL PROCEDURE SalespersonCodeOnAfterValidate@19011896();
    BEGIN
      CurrPage.SalesLines.PAGE.UpdatePage(TRUE);
    END;

    LOCAL PROCEDURE SetDocNoVisible@3();
    VAR
      DocumentNoVisibility@1000 : Codeunit 1400;
      DocType@1003 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Reminder,FinChMemo';
    BEGIN
      DocNoVisible := DocumentNoVisibility.SalesDocumentNoIsVisible(DocType::Invoice,"No.");
    END;

    LOCAL PROCEDURE CustomerUsesOIOUBL@1060000(CustomerNo@1060000 : Code[20]) : Boolean;
    VAR
      Customer@1060001 : Record 18;
    BEGIN
      IF Customer.GET(CustomerNo) THEN
        EXIT (Customer."OIOUBL Profile Code" <> '');
      EXIT(FALSE)
    END;

    LOCAL PROCEDURE SetExtDocNoMandatoryCondition@2();
    VAR
      SalesReceivablesSetup@1000 : Record 311;
    BEGIN
      SalesReceivablesSetup.GET;
      ExternalDocNoMandatory := SalesReceivablesSetup."Ext. Doc. No. Mandatory"
    END;

    LOCAL PROCEDURE ShowPreview@5();
    VAR
      SalesPostYesNo@1000 : Codeunit 81;
    BEGIN
      SalesPostYesNo.Preview(Rec);
    END;

    LOCAL PROCEDURE SetControlAppearance@6();
    VAR
      ApprovalsMgmt@1002 : Codeunit 1535;
      WorkflowWebhookMgt@1000 : Codeunit 1543;
    BEGIN
      HasIncomingDocument := "Incoming Document Entry No." <> 0;
      SetExtDocNoMandatoryCondition;

      OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RECORDID);
      OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);
      CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RECORDID);

      IsCustomerOrContactNotEmpty := ("Sell-to Customer No." <> '') OR ("Sell-to Contact No." <> '');

      WorkflowWebhookMgt.GetCanRequestAndCanCancel(RECORDID,CanRequestApprovalForFlow,CanCancelApprovalForFlow);
    END;

    LOCAL PROCEDURE UpdatePaymentService@7();
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
    LOCAL PROCEDURE OnBeforeStatisticsAction@1(VAR SalesHeader@1000 : Record 36;VAR Handled@1001 : Boolean);
    BEGIN
    END;

    BEGIN
    END.
  }
}

