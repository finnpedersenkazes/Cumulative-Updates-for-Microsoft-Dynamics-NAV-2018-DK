OBJECT Page 51 Purchase Invoice
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=K�bsfaktura;
               ENU=Purchase Invoice];
    SourceTable=Table38;
    SourceTableView=WHERE(Document Type=FILTER(Invoice));
    PageType=Document;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport�r,Godkend,Fakturer,Bogf�ring,Vis,Anmod om godkendelse,Indg�ende bilag;
                                ENU=New,Process,Report,Approve,Invoice,Posting,View,Request Approval,Incoming Document];
    OnInit=VAR
             PurchasesPayablesSetup@1001 : Record 312;
           BEGIN
             JobQueuesUsed := PurchasesPayablesSetup.JobQueueActive;
             SetExtDocNoMandatoryCondition;
             ShowShippingOptionsWithLocation := DummyApplicationAreaSetup.IsLocationEnabled OR DummyApplicationAreaSetup.IsAllDisabled;
           END;

    OnOpenPage=VAR
                 OfficeMgt@1000 : Codeunit 1630;
                 PermissionManager@1001 : Codeunit 9002;
               BEGIN
                 SetDocNoVisible;
                 IsOfficeAddin := OfficeMgt.IsAvailable;
                 CreateIncomingDocFromEmailAttachment := OfficeMgt.OCRAvailable;
                 CreateIncomingDocumentVisible := NOT OfficeMgt.IsOutlookMobileApp;
                 IsSaaS := PermissionManager.SoftwareAsAService;

                 IF UserMgt.GetPurchasesFilter <> '' THEN BEGIN
                   FILTERGROUP(2);
                   SETRANGE("Responsibility Center",UserMgt.GetPurchasesFilter);
                   FILTERGROUP(0);
                 END;
                 IF ("No." <> '') AND ("Buy-from Vendor No." = '') THEN
                   DocumentIsPosted := (NOT GET("Document Type","No."));
               END;

    OnAfterGetRecord=BEGIN
                       CalculateCurrentShippingAndPayToOption;
                     END;

    OnNewRecord=BEGIN
                  "Responsibility Center" := UserMgt.GetPurchasesFilter;

                  IF (NOT DocNoVisible) AND ("No." = '') THEN
                    SetBuyFromVendorFromFilter;
                END;

    OnDeleteRecord=BEGIN
                     CurrPage.SAVERECORD;
                     EXIT(ConfirmDeletion);
                   END;

    OnQueryClosePage=BEGIN
                       IF NOT DocumentIsPosted THEN
                         EXIT(ConfirmCloseUnposted);
                     END;

    OnAfterGetCurrRecord=BEGIN
                           CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
                           CurrPage.ApprovalFactBox.PAGE.UpdateApprovalEntriesFromSourceRecord(RECORDID);
                           ShowWorkflowStatus := CurrPage.WorkflowStatus.PAGE.SetFilterOnWorkflowRecord(RECORDID);
                           SetControlAppearance;
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;  ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 55      ;1   ;ActionGroup;
                      CaptionML=[DAN=F&aktura;
                                 ENU=&Invoice];
                      Image=Invoice }
      { 57      ;2   ;Action    ;
                      Name=Statistics;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=F� vist statistiske oplysninger som f.eks. v�rdien for bogf�rte poster til recorden.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Category5;
                      OnAction=BEGIN
                                 CalcInvDiscForHeader;
                                 COMMIT;
                                 PAGE.RUNMODAL(PAGE::"Purchase Statistics",Rec);
                                 PurchCalcDiscByType.ResetRecalculateInvoiceDisc(Rec);
                               END;
                                }
      { 58      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kreditor;
                                 ENU=Vendor];
                      ToolTipML=[DAN=F� vist eller rediger detaljerede oplysninger om kreditoren i k�bsdokumentet.;
                                 ENU=View or edit detailed information about the vendor on the purchase document.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 26;
                      RunPageLink=No.=FIELD(Buy-from Vendor No.);
                      Promoted=Yes;
                      Enabled="Buy-from Vendor No." <> '';
                      PromotedIsBig=Yes;
                      Image=Vendor;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes }
      { 59      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m�rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf�j bem�rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 66;
                      RunPageLink=Document Type=FIELD(Document Type),
                                  No.=FIELD(No.),
                                  Document Line No.=CONST(0);
                      Image=ViewComments }
      { 113     ;2   ;Action    ;
                      Name=Dimensions;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr�de, projekt eller afdeling, som du kan tildele til salgs- og k�bsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Enabled="No." <> '';
                      PromotedIsBig=Yes;
                      Image=Dimensions;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 ShowDocDim;
                                 CurrPage.SAVERECORD;
                               END;
                                }
      { 41      ;2   ;ActionGroup;
                      Name=IncomingDocument;
                      CaptionML=[DAN=Indg�ende bilag;
                                 ENU=Incoming Document];
                      Visible=FALSE }
      { 39      ;3   ;Action    ;
                      Name=IncomingDocCard;
                      CaptionML=[DAN=Vis;
                                 ENU=View];
                      ToolTipML=[DAN=Se alle indg�ende bilagsrecords og vedh�ftede filer, der findes for posten eller bilaget.;
                                 ENU=View any incoming document records and file attachments that exist for the entry or document.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=HasIncomingDocument;
                      PromotedIsBig=Yes;
                      Image=ViewOrder;
                      PromotedCategory=Category9;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 IncomingDocument@1000 : Record 130;
                               BEGIN
                                 IncomingDocument.ShowCardFromEntryNo("Incoming Document Entry No.");
                               END;
                                }
      { 37      ;3   ;Action    ;
                      Name=SelectIncomingDoc;
                      AccessByPermission=TableData 130=R;
                      CaptionML=[DAN=Marker;
                                 ENU=Select];
                      ToolTipML=[DAN=V�lg en indg�ende bilagsrecord og vedh�ftet fil, der skal knyttes til posten eller bilaget.;
                                 ENU=Select an incoming document record and file attachment that you want to link to the entry or document.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=SelectLineToApply;
                      PromotedCategory=Category9;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 IncomingDocument@1000 : Record 130;
                               BEGIN
                                 VALIDATE("Incoming Document Entry No.",IncomingDocument.SelectIncomingDocument("Incoming Document Entry No.",RECORDID));
                               END;
                                }
      { 35      ;3   ;Action    ;
                      Name=IncomingDocAttachFile;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Opret fra fil;
                                 ENU=Create from File];
                      ToolTipML=[DAN=Opret en indg�ende bilagsrecord ved at v�lge en fil, der skal vedh�ftes, og knyt derefter den indg�ende bilagsrecord til posten eller bilaget.;
                                 ENU=Create an incoming document record by selecting a file to attach, and then link the incoming document record to the entry or document.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=CreateIncomingDocumentVisible;
                      Enabled=CreateIncomingDocumentEnabled;
                      PromotedIsBig=Yes;
                      Image=Attach;
                      PromotedCategory=Category9;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 IncomingDocumentAttachment@1000 : Record 133;
                               BEGIN
                                 IncomingDocumentAttachment.NewAttachmentFromPurchaseDocument(Rec);
                               END;
                                }
      { 16      ;3   ;Action    ;
                      Name=IncomingDocEmailAttachment;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Opret fra vedh�ftet fil;
                                 ENU=Create from Attachment];
                      ToolTipML=[DAN=Opret en indg�ende bilagsrecord ved at v�lge en vedh�ftet fil fra en Outlook-mail og derefter knytte den indg�ende bilagsrecord til posten eller bilaget.;
                                 ENU=Create an incoming document record by selecting an attachment from outlook email, and then link the incoming document record to the entry or document.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=CreateIncomingDocFromEmailAttachment;
                      Enabled=IncomingDocEmailAttachmentEnabled;
                      PromotedIsBig=Yes;
                      Image=SendElectronicDocument;
                      PromotedCategory=Category9;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 OfficeMgt@1001 : Codeunit 1630;
                               BEGIN
                                 IF NOT INSERT(TRUE) THEN
                                   MODIFY(TRUE);
                                 OfficeMgt.InitiateSendToIncomingDocumentsWithPurchaseHeaderLink(Rec,"Buy-from Vendor No.");
                               END;
                                }
      { 29      ;3   ;Action    ;
                      Name=RemoveIncomingDoc;
                      CaptionML=[DAN=Fjern;
                                 ENU=Remove];
                      ToolTipML=[DAN=Fjern et eksternt dokument, der er registreret, manuelt eller automatisk, og vedh�ftet som fil i et dokument eller en finanspost.;
                                 ENU=Remove an external document that has been recorded, manually or automatically, and attached as a file to a document or ledger entry.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=HasIncomingDocument;
                      PromotedIsBig=Yes;
                      Image=RemoveLine;
                      PromotedCategory=Category9;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 IncomingDocument@1000 : Record 130;
                               BEGIN
                                 IF IncomingDocument.GET("Incoming Document Entry No.") THEN
                                   IncomingDocument.RemoveLinkToRelatedRecord;
                                 "Incoming Document Entry No." := 0;
                                 MODIFY(TRUE);
                               END;
                                }
      { 25      ;1   ;ActionGroup;
                      CaptionML=[DAN=Godkendelse;
                                 ENU=Approval] }
      { 23      ;2   ;Action    ;
                      Name=Approve;
                      CaptionML=[DAN=Godkend;
                                 ENU=Approve];
                      ToolTipML=[DAN=Godkend de anmodede �ndringer.;
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
                                 ApprovalsMgmt.ApproveRecordApprovalRequest(RECORDID)
                               END;
                                }
      { 21      ;2   ;Action    ;
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
                                 ApprovalsMgmt.RejectRecordApprovalRequest(RECORDID)
                               END;
                                }
      { 19      ;2   ;Action    ;
                      Name=Delegate;
                      CaptionML=[DAN=Uddeleger;
                                 ENU=Delegate];
                      ToolTipML=[DAN=Uddeleger godkendelsen til en stedfortr�dende godkender.;
                                 ENU=Delegate the approval to a substitute approver.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Visible=OpenApprovalEntriesExistForCurrUser;
                      Image=Delegate;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.DelegateRecordApprovalRequest(RECORDID)
                               END;
                                }
      { 13      ;2   ;Action    ;
                      Name=Comment;
                      CaptionML=[DAN=Bem�rkninger;
                                 ENU=Comments];
                      ToolTipML=[DAN=Se eller tilf�j bem�rkninger for recorden.;
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
                      Image=Release }
      { 120     ;2   ;Action    ;
                      ShortCutKey=Ctrl+F9;
                      CaptionML=[DAN=F&rigiv;
                                 ENU=Re&lease];
                      ToolTipML=[DAN=Frigiv bilaget til n�ste behandlingstrin. N�r et bilag frigives, bliver det inkluderet i alle disponeringsberegninger fra den dato, varerne forventes modtaget. Du skal gen�bne bilaget, f�r du kan foretage �ndringer i det.;
                                 ENU=Release the document to the next stage of processing. When a document is released, it will be included in all availability calculations from the expected receipt date of the items. You must reopen the document before you can make changes to it.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Image=ReleaseDoc;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 ReleasePurchDoc@1000 : Codeunit 415;
                               BEGIN
                                 ReleasePurchDoc.PerformManualRelease(Rec);
                               END;
                                }
      { 121     ;2   ;Action    ;
                      Name=Reopen;
                      CaptionML=[DAN=&�bn igen;
                                 ENU=Re&open];
                      ToolTipML=[DAN=�bn bilaget igen for at �ndre det, efter at det er blevet godkendt. Godkendte bilag har status Frigivet og skal �bnes, f�r de kan �ndres;
                                 ENU=Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Enabled=Status <> Status::Open;
                      PromotedIsBig=Yes;
                      Image=ReOpen;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ReleasePurchDoc@1001 : Codeunit 415;
                               BEGIN
                                 ReleasePurchDoc.PerformManualReopen(Rec);
                               END;
                                }
      { 60      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 4       ;2   ;Action    ;
                      Name=GetRecurringPurchaseLines;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Hent tilbagevendende k�bslinjer;
                                 ENU=Get Recurring Purchase Lines];
                      ToolTipML=[DAN=Inds�t k�bsdokumentlinjer, som du har angivet for kreditoren som tilbagevendende. Tilbagevendende k�bslinjer kan v�re en m�nedlig genbestillingsordre eller en fast fragtudgift.;
                                 ENU=Insert purchase document lines that you have set up for the vendor as recurring. Recurring purchase lines could be for a monthly replenishment order or a fixed freight expense.];
                      ApplicationArea=#Suite;
                      PromotedIsBig=Yes;
                      Image=VendorCode;
                      OnAction=VAR
                                 StdVendPurchCode@1000 : Record 175;
                               BEGIN
                                 StdVendPurchCode.InsertPurchLines(Rec);
                               END;
                                }
      { 63      ;2   ;Action    ;
                      Name=CopyDocument;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kopi�r dokument;
                                 ENU=Copy Document];
                      ToolTipML=[DAN=Kopi�r dokumentlinjer og sidehovedoplysninger fra et andet k�bsdokument til dette dokument. Du kan kopiere en bogf�rt k�bsfaktura til en ny k�bsfaktura, hvis du hurtigt vil oprette et lignende dokument.;
                                 ENU=Copy document lines and header information from another purchase document to this document. You can copy a posted purchase invoice into a new purchase invoice to quickly create a similar document.];
                      ApplicationArea=#Suite;
                      PromotedIsBig=Yes;
                      Image=CopyDocument;
                      OnAction=BEGIN
                                 CopyPurchDoc.SetPurchHeader(Rec);
                                 CopyPurchDoc.RUNMODAL;
                                 CLEAR(CopyPurchDoc);
                                 IF GET("Document Type","No.") THEN;
                               END;
                                }
      { 61      ;2   ;Action    ;
                      Name=CalculateInvoiceDiscount;
                      AccessByPermission=TableData 24=R;
                      CaptionML=[DAN=&Beregn fakturarabat;
                                 ENU=Calculate &Invoice Discount];
                      ToolTipML=[DAN=Beregne fakturarabatten for hele k�bsfakturaen.;
                                 ENU=Calculate the invoice discount for the entire purchase invoice.];
                      ApplicationArea=#Basic,#Suite;
                      Image=CalculateInvoiceDiscount;
                      OnAction=BEGIN
                                 ApproveCalcInvDisc;
                                 PurchCalcDiscByType.ResetRecalculateInvoiceDisc(Rec);
                               END;
                                }
      { 136     ;2   ;Separator  }
      { 137     ;2   ;Separator  }
      { 112     ;2   ;Action    ;
                      Name=MoveNegativeLines;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Flyt negative linjer;
                                 ENU=Move Negative Lines];
                      ToolTipML=[DAN=G�r dig klar til at oprette en erstatningssalgsordre i en salgsreturproces.;
                                 ENU=Prepare to create a replacement sales order in a sales return process.];
                      ApplicationArea=#Advanced;
                      Image=MoveNegativeLines;
                      OnAction=BEGIN
                                 CLEAR(MoveNegPurchLines);
                                 MoveNegPurchLines.SetPurchHeader(Rec);
                                 MoveNegPurchLines.RUNMODAL;
                                 MoveNegPurchLines.ShowDocument;
                               END;
                                }
      { 47      ;1   ;ActionGroup;
                      CaptionML=[DAN=Anmod om godkendelse;
                                 ENU=Request Approval] }
      { 45      ;2   ;Action    ;
                      Name=Approvals;
                      AccessByPermission=TableData 454=R;
                      CaptionML=[DAN=Godkendelser;
                                 ENU=Approvals];
                      ToolTipML=[DAN=F� vist en liste over records, der afventer godkendelse. Du kan f.eks. se, hvem der har anmodet om godkendelse af recorden, hvorn�r den blev sendt og hvorn�r den skal godkendes.;
                                 ENU=View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Approvals;
                      PromotedCategory=Category8;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 WorkflowsEntriesBuffer@1001 : Record 832;
                               BEGIN
                                 WorkflowsEntriesBuffer.RunWorkflowEntriesPage(RECORDID,DATABASE::"Purchase Header","Document Type","No.");
                               END;
                                }
      { 142     ;2   ;Action    ;
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
                      PromotedCategory=Category8;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 IF ApprovalsMgmt.CheckPurchaseApprovalPossible(Rec) THEN
                                   ApprovalsMgmt.OnSendPurchaseDocForApproval(Rec);
                               END;
                                }
      { 143     ;2   ;Action    ;
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
                      PromotedCategory=Category8;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                                 WorkflowWebhookMgt@1001 : Codeunit 1543;
                               BEGIN
                                 ApprovalsMgmt.OnCancelPurchaseApprovalRequest(Rec);
                                 WorkflowWebhookMgt.FindAndCancel(RECORDID);
                               END;
                                }
      { 62      ;1   ;ActionGroup;
                      CaptionML=[DAN=Flow;
                                 ENU=Flow];
                      Image=Flow }
      { 71      ;2   ;Action    ;
                      Name=CreateFlow;
                      CaptionML=[DAN=Opret et workflow;
                                 ENU=Create a Flow];
                      ToolTipML=[DAN=Opret et nyt workflow fra en liste over relevante workflowskabeloner.;
                                 ENU=Create a new Flow from a list of relevant Flow templates.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=IsSaaS;
                      Image=Flow;
                      PromotedCategory=Category8;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 FlowServiceManagement@1000 : Codeunit 6400;
                                 FlowTemplateSelector@1001 : Page 6400;
                               BEGIN
                                 // Opens page 6400 where the user can use filtered templates to create new flows.
                                 FlowTemplateSelector.SetSearchText(FlowServiceManagement.GetPurchasingTemplateFilter);
                                 FlowTemplateSelector.RUN;
                               END;
                                }
      { 73      ;2   ;Action    ;
                      Name=SeeFlows;
                      CaptionML=[DAN=Se mine workflows;
                                 ENU=See my Flows];
                      ToolTipML=[DAN=F� vist og konfigurer de workflowforekomster, du har oprettet.;
                                 ENU=View and configure Flows that you created.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 6401;
                      Promoted=Yes;
                      Image=Flow;
                      PromotedCategory=Category8;
                      PromotedOnly=Yes }
      { 66      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Bogf�ring;
                                 ENU=P&osting];
                      Image=Post }
      { 68      ;2   ;Action    ;
                      Name=Post;
                      ShortCutKey=F9;
                      CaptionML=[DAN=B&ogf�r;
                                 ENU=P&ost];
                      ToolTipML=[DAN=F�rdigg�r bilaget eller kladden ved at bogf�re bel�b og antal p� de relaterede konti i regnskaberne.;
                                 ENU=Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostOrder;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 VerifyTotal;
                                 Post(CODEUNIT::"Purch.-Post (Yes/No)");
                               END;
                                }
      { 33      ;2   ;Action    ;
                      Name=Preview;
                      CaptionML=[DAN=Vis bogf�ring;
                                 ENU=Preview Posting];
                      ToolTipML=[DAN=Gennemse de forskellige typer poster, der oprettes, n�r du bogf�rer bilaget eller kladden.;
                                 ENU=Review the different types of entries that will be created when you post the document or journal.];
                      ApplicationArea=#Basic,#Suite;
                      Image=ViewPostedOrder;
                      OnAction=VAR
                                 PurchPostYesNo@1000 : Codeunit 91;
                               BEGIN
                                 PurchPostYesNo.Preview(Rec);
                               END;
                                }
      { 67      ;2   ;Action    ;
                      Name=TestReport;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kontroller;
                                 ENU=Test Report];
                      ToolTipML=[DAN=Vis en testrapport, s� du kan finde og rette eventuelle fejl, f�r du udf�rer den faktiske bogf�ring af kladden eller bilaget.;
                                 ENU=View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.];
                      ApplicationArea=#Advanced;
                      Image=TestReport;
                      OnAction=BEGIN
                                 ReportPrint.PrintPurchHeader(Rec);
                               END;
                                }
      { 69      ;2   ;Action    ;
                      Name=PostAndPrint;
                      ShortCutKey=Shift+F9;
                      CaptionML=[DAN=Bogf�r og &udskriv;
                                 ENU=Post and &Print];
                      ToolTipML=[DAN=Bilaget eller kladden f�rdigg�res og forberedes til udskrivning. V�rdierne og antallene bogf�res p� de relaterede konti. Du f�r vist et rapportanmodningsvindue, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Visible=NOT IsOfficeAddin;
                      PromotedIsBig=Yes;
                      Image=PostPrint;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 VerifyTotal;
                                 Post(CODEUNIT::"Purch.-Post + Print");
                               END;
                                }
      { 70      ;2   ;Action    ;
                      Name=PostBatch;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Masse&bogf�r;
                                 ENU=Post &Batch];
                      ToolTipML=[DAN=Bogf�r flere bilag p� �n gang. Der �bnes et anmodningsvindue, hvor du kan angive, hvilke bilag der skal bogf�res.;
                                 ENU=Post several documents at once. A report request window opens where you can specify which documents to post.];
                      ApplicationArea=#Advanced;
                      Image=PostBatch;
                      OnAction=BEGIN
                                 VerifyTotal;
                                 REPORT.RUNMODAL(REPORT::"Batch Post Purchase Invoices",TRUE,TRUE,Rec);
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 7       ;2   ;Action    ;
                      Name=RemoveFromJobQueue;
                      CaptionML=[DAN=Fjern fra opgavek�;
                                 ENU=Remove From Job Queue];
                      ToolTipML=[DAN=Fjern den planlagte behandling af denne record fra jobk�en.;
                                 ENU=Remove the scheduled processing of this record from the job queue.];
                      ApplicationArea=#All;
                      Visible="Job Queue Status" = "Job Queue Status"::"Scheduled For Posting";
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
                           ENU=General] }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
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

    { 64  ;2   ;Field     ;
                CaptionML=[DAN=Kreditornr.;
                           ENU=Vendor No.];
                ToolTipML=[DAN=Angiver nummeret p� den kreditor, der leverer produkterne.;
                           ENU=Specifies the number of the vendor who delivers the products.];
                ApplicationArea=#All;
                NotBlank=Yes;
                SourceExpr="Buy-from Vendor No.";
                Importance=Additional;
                OnValidate=BEGIN
                             OnAfterValidateBuyFromVendorNo(Rec,xRec);
                             CurrPage.UPDATE;
                           END;
                            }

    { 6   ;2   ;Field     ;
                CaptionML=[DAN=Kreditornavn;
                           ENU=Vendor Name];
                ToolTipML=[DAN=Angiver navnet p� den kreditor, der leverer produkterne.;
                           ENU=Specifies the name of the vendor who delivers the products.];
                ApplicationArea=#All;
                NotBlank=Yes;
                SourceExpr="Buy-from Vendor Name";
                Importance=Promoted;
                OnValidate=VAR
                             ApplicationAreaSetup@1000 : Record 9178;
                           BEGIN
                             OnAfterValidateBuyFromVendorNo(Rec,xRec);

                             IF ApplicationAreaSetup.IsFoundationEnabled THEN
                               PurchCalcDiscByType.ApplyDefaultInvoiceDiscount(0,Rec);

                             CurrPage.UPDATE;
                           END;

                ShowMandatory=TRUE }

    { 51  ;2   ;Group     ;
                CaptionML=[DAN=Leverand�r;
                           ENU=Buy-from];
                GroupType=Group }

    { 72  ;3   ;Field     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                ToolTipML=[DAN=Angiver adressen p� den kreditor, der leverer varerne.;
                           ENU=Specifies the address of the vendor who ships the items.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Buy-from Address";
                Importance=Additional }

    { 74  ;3   ;Field     ;
                CaptionML=[DAN=Adresse 2;
                           ENU=Address 2];
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Buy-from Address 2";
                Importance=Additional }

    { 77  ;3   ;Field     ;
                CaptionML=[DAN=Postnr.;
                           ENU=Post Code];
                ToolTipML=[DAN=Angiver postnummer.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Buy-from Post Code";
                Importance=Additional }

    { 76  ;3   ;Field     ;
                CaptionML=[DAN=By;
                           ENU=City];
                ToolTipML=[DAN=Angiver byen for kreditoren p� k�bsdokumentet.;
                           ENU=Specifies the city of the vendor on the purchase document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Buy-from City";
                Importance=Additional }

    { 128 ;3   ;Field     ;
                CaptionML=[DAN=Kontaktnr.;
                           ENU=Contact No.];
                ToolTipML=[DAN=Angiver nummeret p� din kontakt hos kreditoren.;
                           ENU=Specifies the number of your contact at the vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Buy-from Contact No.";
                Importance=Additional }

    { 8   ;2   ;Field     ;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                ToolTipML=[DAN=Angiver navnet p� den person, der skal kontaktes om leveringen af varer fra denne kreditor.;
                           ENU=Specifies the name of the person to contact about shipment of the item from this vendor.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Buy-from Contact";
                Editable="Buy-from Vendor No." <> '' }

    { 43  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Date";
                Importance=Additional }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor bogf�ringen af k�bsdokumentet skal registreres.;
                           ENU=Specifies the date when the posting of the purchase document will be recorded.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Posting Date";
                Importance=Promoted }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn�r fakturaen er forfalden til betaling. Feltet beregnes automatisk ud fra data i felterne Betalingsbeting.kode og Bilagsdato.;
                           ENU=Specifies when the invoice is due. The program calculates the date using the Payment Terms Code and Document Date fields.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Due Date";
                Importance=Promoted }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� det indg�ende bilag, som dette k�bsbilag er oprettet til.;
                           ENU=Specifies the number of the incoming document that this purchase document is created for.];
                ApplicationArea=#Advanced;
                SourceExpr="Incoming Document Entry No.";
                Importance=Additional;
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bilagsnummeret for det oprindelige bilag, du modtog fra kreditoren. Du kan kr�ve bilagsnummeret til bogf�ring, eller du kan lade det v�re valgfrit. Det er p�kr�vet som standard, s� dette bilag refererer til originalen. Det fjerner et trin fra bogf�ringsprocessen at g�re bilagsnumre valgfri. Hvis du f.eks. vedh�fter den oprindelige faktura som en PDF-fil, beh�ver du m�ske ikke at angive dokumentnummeret. I vinduet K�bsops�tning kan du v�lge, om dokumentnumre er p�kr�vet ved at v�lge eller rydde markeringen i afkrydsningsfeltet Eksternt bilagsnr. obl.;
                           ENU=Specifies the document number of the original document you received from the vendor. You can require the document number for posting, or let it be optional. By default, it's required, so that this document references the original. Making document numbers optional removes a step from the posting process. For example, if you attach the original invoice as a PDF, you might not need to enter the document number. To specify whether document numbers are required, in the Purchases & Payables Setup window, select or clear the Ext. Doc. No. Mandatory field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Vendor Invoice No.";
                ShowMandatory=VendorInvoiceNoMandatory }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken indk�ber der er knyttet til den aktuelle kreditor.;
                           ENU=Specifies which purchaser is assigned to the vendor.];
                ApplicationArea=#Suite;
                SourceExpr="Purchaser Code";
                Importance=Additional;
                OnValidate=BEGIN
                             PurchaserCodeOnAfterValidate;
                           END;
                            }

    { 1102601000;2;Field  ;
                ToolTipML=[DAN=Angiver nummeret p� den kampagne, bilaget er knyttet til.;
                           ENU=Specifies the campaign number the document is linked to.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Campaign No.";
                Importance=Additional }

    { 84  ;2   ;Field     ;
                CaptionML=[DAN=Alternativ kreditoradressekode;
                           ENU=Alternate Vendor Address Code];
                ToolTipML=[DAN=Angiver bestillingsadressen for den relaterede kreditor.;
                           ENU=Specifies the order address of the related vendor.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Order Address Code";
                Importance=Additional }

    { 115 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode for ansvarscenteret (f.eks. et distributionscenter), som er tildelt den involverede bruger, virksomhed, debitor eller kreditor.;
                           ENU=Specifies the code of the responsibility center, such as a distribution hub, that is associated with the involved user, company, customer, or vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Responsibility Center";
                Importance=Additional }

    { 65  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der er ansvarlig for bilaget.;
                           ENU=Specifies the ID of the user who is responsible for the document.];
                ApplicationArea=#Advanced;
                SourceExpr="Assigned User ID";
                Importance=Additional }

    { 118 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om recorden er �ben, afventer godkendelse, er faktureret til forudbetaling eller er frigivet til n�ste fase i behandlingen.;
                           ENU=Specifies whether the record is open, waiting to be approved, invoiced for prepayment, or released to the next stage of processing.];
                ApplicationArea=#Suite;
                SourceExpr=Status;
                Importance=Additional }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for en opgavek�post, der h�ndterer bogf�ring af k�bsfakturaer.;
                           ENU=Specifies the status of a job queue entry that handles the posting of purchase invoices.];
                ApplicationArea=#All;
                SourceExpr="Job Queue Status";
                Importance=Additional;
                Visible=JobQueuesUsed }

    { 54  ;1   ;Part      ;
                Name=PurchLines;
                ApplicationArea=#Basic,#Suite;
                SubPageLink=Document No.=FIELD(No.);
                PagePartID=Page55;
                Enabled="Buy-from Vendor No." <> '';
                Editable="Buy-from Vendor No." <> '';
                UpdatePropagation=Both }

    { 1905885101;1;Group  ;
                CaptionML=[DAN=Fakturadetaljer;
                           ENU=Invoice Details];
                GroupType=Group }

    { 104 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver valutakoden for bel�bet p� k�bslinjerne.;
                           ENU=Specifies the currency code for amounts on the purchase lines.];
                ApplicationArea=#Suite;
                SourceExpr="Currency Code";
                Importance=Promoted;
                OnValidate=BEGIN
                             CurrPage.SAVERECORD;
                             PurchCalcDiscByType.ApplyDefaultInvoiceDiscount(0,Rec);
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
                ToolTipML=[DAN=Viser den dato, hvor varerne p� k�bsdokumentet forventes modtaget.;
                           ENU=Specifies the date you expect to receive the items on the purchase document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Expected Receipt Date";
                Importance=Promoted }

    { 108 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om felterne Enhedspris og Linjebel�b p� bilagslinjer skal vises med eller uden moms.;
                           ENU=Specifies if the Unit Price and Line Amount fields on document lines should be shown with or without VAT.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Prices Including VAT";
                OnValidate=BEGIN
                             PricesIncludingVATOnAfterValid;
                           END;
                            }

    { 138 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede debitors eller kreditors momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogf�ringsops�tning.;
                           ENU=Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Bus. Posting Group";
                OnValidate=VAR
                             ApplicationAreaSetup@1000 : Record 9178;
                           BEGIN
                             CurrPage.SAVERECORD;

                             IF ApplicationAreaSetup.IsFoundationEnabled THEN
                               PurchCalcDiscByType.ApplyDefaultInvoiceDiscount(0,Rec);
                           END;
                            }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en formel, der beregner betalingens forfaldsdato, kontantrabatdato og kontantrabatbel�b.;
                           ENU=Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Terms Code";
                Importance=Promoted }

    { 102 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan betalingen skal foretages, f.eks. via bankoverf�rsel, kontant eller med check.;
                           ENU=Specifies how to make payment, such as with bank transfer, cash,  or check.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Method Code";
                Importance=Additional }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den transaktionstype, som bilaget repr�senterer med henblik p� rapportering til INTRASTAT.;
                           ENU=Specifies the type of transaction that the document represents, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Transaction Type" }

    { 85  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops�tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                OnValidate=BEGIN
                             ShortcutDimension1CodeOnAfterV;
                           END;
                            }

    { 87  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dimensionsv�rdikode, der er tilknyttet k�bshovedet.;
                           ENU=Specifies the dimension value code associated with the purchase header.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code";
                OnValidate=BEGIN
                             ShortcutDimension2CodeOnAfterV;
                           END;
                            }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den rabatprocent, der tildeles, hvis betaling gennemf�res f�r eller p� den dato, der er angivet i feltet Kont.rabatdato.;
                           ENU=Specifies the payment discount percent granted if payment is made on or before the date in the Pmt. Discount Date field.];
                ApplicationArea=#Advanced;
                SourceExpr="Payment Discount %" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor bel�bet i posten skal v�re betalt, for at der kan opn�s kontantrabat.;
                           ENU=Specifies the date on which the amount in the entry must be paid for a payment discount to be granted.];
                ApplicationArea=#Advanced;
                SourceExpr="Pmt. Discount Date";
                Importance=Additional }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver betingelserne for levering af den relaterede leverance, som f.eks. frit ombord (FOB).;
                           ENU=Specifies the delivery conditions of the related shipment, such as free on board (FOB).];
                ApplicationArea=#Advanced;
                SourceExpr="Shipment Method Code";
                Importance=Additional }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver betalingen for k�bsfakturaen.;
                           ENU=Specifies the payment of the purchase invoice.];
                ApplicationArea=#Advanced;
                SourceExpr="Payment Reference";
                Importance=Additional }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kreditor, som har sendt k�bsfakturaen.;
                           ENU=Specifies the vendor who sent the purchase invoice.];
                ApplicationArea=#Advanced;
                SourceExpr="Creditor No.";
                Importance=Additional }

    { 91  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den tilknyttede post repr�senterer en ubetalt faktura, som der findes et betalingsforslag, en rykker eller en rentenota til.;
                           ENU=Specifies that the related entry represents an unpaid invoice for which either a payment suggestion, a reminder, or a finance charge memo exists.];
                ApplicationArea=#Advanced;
                SourceExpr="On Hold";
                Importance=Additional }

    { 1906801201;1;Group  ;
                CaptionML=[DAN=Forsendelse og betaling;
                           ENU=Shipping and Payment];
                GroupType=Group }

    { 53  ;2   ;Group     ;
                GroupType=Group }

    { 78  ;3   ;Group     ;
                GroupType=Group }

    { 75  ;4   ;Field     ;
                Name=ShippingOptionWithLocation;
                CaptionML=[DAN=Leveres til;
                           ENU=Ship-to];
                ToolTipML=[DAN=Angiver den adresse, som produkter i k�bsbilaget skal leveres til. Standard (firmaadresse): Det samme som den firmaadresse, der er angivet i vinduet Virksomhedsoplysninger. Lokation: �n af virksomhedens lokationsadresser. Brugerdefineret adresse: En vilk�rlig leveringsadresse, som du angiver i nedenst�ende felter.;
                           ENU=Specifies the address that the products on the purchase document are shipped to. Default (Company Address): The same as the company address specified in the Company Information window. Location: One of the company's location addresses. Custom Address: Any ship-to address that you specify in the fields below.];
                OptionCaptionML=[DAN=Standard (firmaadresse),lokation,Brugerdefineret adresse;
                                 ENU=Default (Company Address),Location,Custom Address];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ShipToOptions;
                Visible=ShowShippingOptionsWithLocation;
                OnValidate=BEGIN
                             ValidateShippingOption;
                           END;
                            }

    { 80  ;4   ;Field     ;
                Name=ShippingOptionWithoutLocation;
                CaptionML=[DAN=Leveres til;
                           ENU=Ship-to];
                ToolTipML=[DAN=Angiver den adresse, som produkter i k�bsbilaget skal leveres til. Standard (firmaadresse): Det samme som den firmaadresse, der er angivet i vinduet Virksomhedsoplysninger. Brugerdefineret adresse: En vilk�rlig leveringsadresse, som du angiver i nedenst�ende felter.;
                           ENU=Specifies the address that the products on the purchase document are shipped to. Default (Company Address): The same as the company address specified in the Company Information window. Custom Address: Any ship-to address that you specify in the fields below.];
                OptionCaptionML=[DAN=Standard (firmaadresse),,Brugerdefineret adresse;
                                 ENU=Default (Company Address),,Custom Address];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ShipToOptions;
                Visible=NOT ShowShippingOptionsWithLocation;
                OnValidate=BEGIN
                             ValidateShippingOption
                           END;
                            }

    { 79  ;4   ;Group     ;
                GroupType=Group }

    { 81  ;5   ;Group     ;
                Visible=ShipToOptions = ShipToOptions::Location;
                GroupType=Group }

    { 89  ;6   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for den lokation, som de bestilte varer skal placeres p� efter levering.;
                           ENU=Specifies a code for the location where you want the items to be placed when they are received.];
                ApplicationArea=#Location;
                SourceExpr="Location Code" }

    { 36  ;5   ;Field     ;
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver navnet p� firmaet med den adresse, som varerne p� k�bsbilaget skal leveres til.;
                           ENU=Specifies the name of the company at the address that you want the items on the purchase document to be shipped to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Name";
                Importance=Additional;
                Editable=ShipToOptions = ShipToOptions::"Custom Address" }

    { 38  ;5   ;Field     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                ToolTipML=[DAN=Angiver den adresse, som varerne p� k�bsbilaget skal leveres til.;
                           ENU=Specifies the address that you want the items on the purchase document to be shipped to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Address";
                Importance=Additional;
                Editable=ShipToOptions = ShipToOptions::"Custom Address" }

    { 40  ;5   ;Field     ;
                CaptionML=[DAN=Adresse 2;
                           ENU=Address 2];
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Address 2";
                Importance=Additional;
                Editable=ShipToOptions = ShipToOptions::"Custom Address" }

    { 94  ;5   ;Field     ;
                CaptionML=[DAN=Postnr.;
                           ENU=Post Code];
                ToolTipML=[DAN=Angiver postnummeret p� firmaet med den adresse, som varerne p� k�bsbilaget skal leveres til.;
                           ENU=Specifies the postal code of the address that you want the items on the purchase document to be shipped to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Post Code";
                Importance=Additional;
                Editable=ShipToOptions = ShipToOptions::"Custom Address" }

    { 42  ;5   ;Field     ;
                CaptionML=[DAN=By;
                           ENU=City];
                ToolTipML=[DAN=Angiver byen i den adresse, som varerne p� k�bsbilaget skal leveres til.;
                           ENU=Specifies the city of the address that you want the items on the purchase document to be shipped to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to City";
                Importance=Additional;
                Editable=ShipToOptions = ShipToOptions::"Custom Address" }

    { 83  ;5   ;Field     ;
                CaptionML=[DAN=Land/omr�de;
                           ENU=Country/Region];
                ToolTipML=[DAN=Angiver lande-/omr�dekoden for den adresse, som varerne p� k�bsbilaget skal leveres til.;
                           ENU=Specifies the country/region code of the address that you want the items on the purchase document to be shipped to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Country/Region Code";
                Importance=Additional;
                Editable=ShipToOptions = ShipToOptions::"Custom Address" }

    { 44  ;5   ;Field     ;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                ToolTipML=[DAN=Angiver navnet p� en kontaktperson p� den adresse, som varerne p� k�bsbilaget skal leveres til.;
                           ENU=Specifies the name of a contact person for the address of the address that you want the items on the purchase document to be shipped to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Contact";
                Importance=Additional;
                Editable=ShipToOptions = ShipToOptions::"Custom Address" }

    { 56  ;2   ;Group     ;
                GroupType=Group }

    { 86  ;3   ;Field     ;
                Name=PayToOptions;
                CaptionML=[DAN=Faktureres til;
                           ENU=Pay-to];
                ToolTipML=[DAN=Angiver den kreditor, som k�bsbilaget skal betales til. Standard (kreditor): Den samme som kreditoren p� k�bsbilaget. En anden kreditor: Enhver kreditor, som du angiver i nedenst�ende felter.;
                           ENU=Specifies the vendor that the purchase document will be paid to. Default (Vendor): The same as the vendor on the purchase document. Another Vendor: Any vendor that you specify in the fields below.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=PayToOptions;
                OnValidate=BEGIN
                             IF PayToOptions = PayToOptions::"Default (Vendor)" THEN
                               VALIDATE("Pay-to Vendor No.","Buy-from Vendor No.");
                           END;
                            }

    { 88  ;3   ;Group     ;
                Visible=PayToOptions = PayToOptions::"Another Vendor";
                GroupType=Group }

    { 18  ;4   ;Field     ;
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver navnet p� den kreditor, fakturaen er sendt fra.;
                           ENU=Specifies the name of the vendor sending the invoice.];
                ApplicationArea=#Basic,#Suite;
                NotBlank=Yes;
                SourceExpr="Pay-to Name";
                Importance=Promoted;
                OnValidate=VAR
                             ApplicationAreaSetup@1000 : Record 9178;
                           BEGIN
                             IF GETFILTER("Pay-to Vendor No.") = xRec."Pay-to Vendor No." THEN
                               IF "Pay-to Vendor No." <> xRec."Pay-to Vendor No." THEN
                                 SETRANGE("Pay-to Vendor No.");

                             IF ApplicationAreaSetup.IsFoundationEnabled THEN
                               PurchCalcDiscByType.ApplyDefaultInvoiceDiscount(0,Rec);

                             CurrPage.UPDATE;
                           END;
                            }

    { 20  ;4   ;Field     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                ToolTipML=[DAN=Angiver adressen p� den kreditor, fakturaen er sendt fra.;
                           ENU=Specifies the address of the vendor sending the invoice.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pay-to Address";
                Importance=Additional;
                Enabled="Buy-from Vendor No." <> "Pay-to Vendor No.";
                Editable="Buy-from Vendor No." <> "Pay-to Vendor No." }

    { 22  ;4   ;Field     ;
                CaptionML=[DAN=Adresse 2;
                           ENU=Address 2];
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pay-to Address 2";
                Importance=Additional;
                Enabled="Buy-from Vendor No." <> "Pay-to Vendor No.";
                Editable="Buy-from Vendor No." <> "Pay-to Vendor No." }

    { 82  ;4   ;Field     ;
                CaptionML=[DAN=Postnr.;
                           ENU=Post Code];
                ToolTipML=[DAN=Angiver postnummer.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pay-to Post Code";
                Importance=Additional;
                Enabled="Buy-from Vendor No." <> "Pay-to Vendor No.";
                Editable="Buy-from Vendor No." <> "Pay-to Vendor No." }

    { 24  ;4   ;Field     ;
                CaptionML=[DAN=By;
                           ENU=City];
                ToolTipML=[DAN=Angiver byen for kreditoren p� k�bsdokumentet.;
                           ENU=Specifies the city of the vendor on the purchase document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pay-to City";
                Importance=Additional;
                Enabled="Buy-from Vendor No." <> "Pay-to Vendor No.";
                Editable="Buy-from Vendor No." <> "Pay-to Vendor No." }

    { 130 ;4   ;Field     ;
                CaptionML=[DAN=Kontaktnr.;
                           ENU=Contact No.];
                ToolTipML=[DAN=Angiver nummeret p� den kontakt, der sender fakturaen.;
                           ENU=Specifies the number of the contact who sends the invoice.];
                ApplicationArea=#Advanced;
                SourceExpr="Pay-to Contact No.";
                Importance=Additional;
                Enabled="Buy-from Vendor No." <> "Pay-to Vendor No.";
                Editable="Buy-from Vendor No." <> "Pay-to Vendor No." }

    { 26  ;4   ;Field     ;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                ToolTipML=[DAN=Angiver navnet p� en kontaktperson hos den kreditor, fakturaen er sendt fra.;
                           ENU=Specifies the name of the person to contact about an invoice from this vendor.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pay-to Contact";
                Enabled="Buy-from Vendor No." <> "Pay-to Vendor No.";
                Editable="Buy-from Vendor No." <> "Pay-to Vendor No." }

    { 1907468901;1;Group  ;
                CaptionML=[DAN=Udenrigshandel;
                           ENU=Foreign Trade] }

    { 100 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en specifikation af bilagets transaktion med henblik p� rapportering til INTRASTAT.;
                           ENU=Specifies a specification of the document's transaction, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Transaction Specification" }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver transportm�den ved rapportering til INTRASTAT.;
                           ENU=Specifies the transport method, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Transport Method" }

    { 96  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for det indf�rselssted, hvor varerne kom ind i landet/omr�det, for rapportering til Intrastat.;
                           ENU=Specifies the code of the port of entry where the items pass into your country/region, for reporting to Intrastat.];
                ApplicationArea=#Advanced;
                SourceExpr="Entry Point" }

    { 98  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitors eller kreditors omr�de med henblik p� rapportering til INTRASTAT.;
                           ENU=Specifies the area of the customer or vendor, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr=Area }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 27  ;1   ;Part      ;
                ApplicationArea=#All;
                SubPageLink=Table ID=CONST(38),
                            Document Type=FIELD(Document Type),
                            Document No.=FIELD(No.);
                PagePartID=Page9103;
                Visible=OpenApprovalEntriesExistForCurrUser;
                PartType=Page }

    { 1906354007;1;Part   ;
                Name=ApprovalFactBox;
                ApplicationArea=#Advanced;
                PagePartID=Page9092;
                Visible=FALSE;
                PartType=Page }

    { 1901138007;1;Part   ;
                ApplicationArea=#Advanced;
                SubPageLink=No.=FIELD(Buy-from Vendor No.);
                PagePartID=Page9093;
                Visible=FALSE;
                PartType=Page }

    { 31  ;1   ;Part      ;
                Name=IncomingDocAttachFactBox;
                ApplicationArea=#Basic,#Suite;
                PagePartID=Page193;
                Visible=NOT IsOfficeAddin;
                PartType=Page;
                ShowFilter=No }

    { 1904651607;1;Part   ;
                ApplicationArea=#Advanced;
                SubPageLink=No.=FIELD(Pay-to Vendor No.);
                PagePartID=Page9094;
                PartType=Page }

    { 1903435607;1;Part   ;
                ApplicationArea=#Advanced;
                SubPageLink=No.=FIELD(Buy-from Vendor No.);
                PagePartID=Page9095;
                Visible=FALSE;
                PartType=Page }

    { 1906949207;1;Part   ;
                ApplicationArea=#Advanced;
                SubPageLink=No.=FIELD(Pay-to Vendor No.);
                PagePartID=Page9096;
                Visible=FALSE;
                PartType=Page }

    { 3   ;1   ;Part      ;
                ApplicationArea=#Advanced;
                SubPageLink=Document Type=FIELD(Document Type),
                            Document No.=FIELD(Document No.),
                            Line No.=FIELD(Line No.);
                PagePartID=Page9100;
                ProviderID=54;
                Visible=FALSE;
                PartType=Page }

    { 49  ;1   ;Part      ;
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
      DummyApplicationAreaSetup@1027 : Record 9178;
      CopyPurchDoc@1002 : Report 492;
      MoveNegPurchLines@1005 : Report 6698;
      ReportPrint@1003 : Codeunit 228;
      UserMgt@1004 : Codeunit 5700;
      PurchCalcDiscByType@1007 : Codeunit 66;
      OfficeMgt@1022 : Codeunit 1630;
      ChangeExchangeRate@1001 : Page 511;
      ShipToOptions@1025 : 'Default (Company Address),Location,Custom Address';
      PayToOptions@1028 : 'Default (Vendor),Another Vendor';
      HasIncomingDocument@1010 : Boolean;
      DocNoVisible@1006 : Boolean;
      VendorInvoiceNoMandatory@1008 : Boolean;
      OpenApprovalEntriesExist@1009 : Boolean;
      OpenApprovalEntriesExistForCurrUser@1000 : Boolean;
      ShowWorkflowStatus@1011 : Boolean;
      JobQueuesUsed@1014 : Boolean;
      OpenPostedPurchaseInvQst@1015 : TextConst 'DAN=Fakturaen er blevet bogf�rt og flyttet til vinduet Bogf�rte k�bsfakturaer.\\Vil du �bne den bogf�rte faktura?;ENU=The invoice has been posted and moved to the Posted Purchase Invoices window.\\Do you want to open the posted invoice?';
      IsOfficeAddin@1017 : Boolean;
      CanCancelApprovalForRecord@1013 : Boolean;
      DocumentIsPosted@1012 : Boolean;
      CreateIncomingDocumentEnabled@1016 : Boolean;
      CreateIncomingDocumentVisible@1021 : Boolean;
      CreateIncomingDocFromEmailAttachment@1018 : Boolean;
      TotalsMismatchErr@1019 : TextConst 'DAN=Fakturaen kan ikke bogf�res, fordi totalen afviger fra totalen p� det relaterede indg�ende bilag.;ENU=The invoice cannot be posted because the total is different from the total on the related incoming document.';
      IncomingDocEmailAttachmentEnabled@1020 : Boolean;
      CanRequestApprovalForFlow@1023 : Boolean;
      CanCancelApprovalForFlow@1024 : Boolean;
      ShowShippingOptionsWithLocation@1026 : Boolean;
      IsSaaS@1029 : Boolean;

    [External]
    PROCEDURE LineModified@7();
    BEGIN
    END;

    LOCAL PROCEDURE Post@4(PostingCodeunitID@1000 : Integer);
    VAR
      PurchaseHeader@1002 : Record 38;
      PurchInvHeader@1003 : Record 122;
      LinesInstructionMgt@1001 : Codeunit 1320;
      InstructionMgt@1004 : Codeunit 1330;
      IsScheduledPosting@1005 : Boolean;
    BEGIN
      IF DummyApplicationAreaSetup.IsFoundationEnabled THEN
        LinesInstructionMgt.PurchaseCheckAllLinesHaveQuantityAssigned(Rec);

      SendToPosting(PostingCodeunitID);

      IsScheduledPosting := "Job Queue Status" = "Job Queue Status"::"Scheduled for Posting";
      DocumentIsPosted := (NOT PurchaseHeader.GET("Document Type","No.")) OR IsScheduledPosting;

      IF IsScheduledPosting THEN
        CurrPage.CLOSE;
      CurrPage.UPDATE(FALSE);

      IF PostingCodeunitID <> CODEUNIT::"Purch.-Post (Yes/No)" THEN
        EXIT;

      IF IsOfficeAddin THEN BEGIN
        PurchInvHeader.SETRANGE("Pre-Assigned No.","No.");
        PurchInvHeader.SETRANGE("Order No.",'');
        IF PurchInvHeader.FINDFIRST THEN
          PAGE.RUN(PAGE::"Posted Purchase Invoice",PurchInvHeader);
      END ELSE
        IF InstructionMgt.IsEnabled(InstructionMgt.ShowPostedConfirmationMessageCode) THEN
          ShowPostedConfirmationMessage;
    END;

    LOCAL PROCEDURE VerifyTotal@22();
    BEGIN
      IF NOT IsTotalValid THEN
        ERROR(TotalsMismatchErr);
    END;

    LOCAL PROCEDURE ApproveCalcInvDisc@1();
    BEGIN
      CurrPage.PurchLines.PAGE.ApproveCalcInvDisc;
    END;

    LOCAL PROCEDURE PurchaserCodeOnAfterValidate@19046120();
    BEGIN
      CurrPage.PurchLines.PAGE.UpdateForm(TRUE);
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
      CALCFIELDS("Invoice Discount Amount");
    END;

    LOCAL PROCEDURE SetDocNoVisible@2();
    VAR
      DocumentNoVisibility@1000 : Codeunit 1400;
      DocType@1003 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Reminder,FinChMemo';
    BEGIN
      DocNoVisible := DocumentNoVisibility.PurchaseDocumentNoIsVisible(DocType::Invoice,"No.");
    END;

    LOCAL PROCEDURE SetExtDocNoMandatoryCondition@3();
    VAR
      PurchasesPayablesSetup@1000 : Record 312;
    BEGIN
      PurchasesPayablesSetup.GET;
      VendorInvoiceNoMandatory := PurchasesPayablesSetup."Ext. Doc. No. Mandatory"
    END;

    LOCAL PROCEDURE SetControlAppearance@5();
    VAR
      ApprovalsMgmt@1002 : Codeunit 1535;
      WorkflowWebhookMgt@1000 : Codeunit 1543;
    BEGIN
      HasIncomingDocument := "Incoming Document Entry No." <> 0;
      CreateIncomingDocumentEnabled := (NOT HasIncomingDocument) AND ("No." <> '');
      SetExtDocNoMandatoryCondition;

      IncomingDocEmailAttachmentEnabled := OfficeMgt.EmailHasAttachments;
      OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RECORDID);
      OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);

      CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RECORDID);

      WorkflowWebhookMgt.GetCanRequestAndCanCancel(RECORDID,CanRequestApprovalForFlow,CanCancelApprovalForFlow);
    END;

    LOCAL PROCEDURE ShowPostedConfirmationMessage@13();
    VAR
      PurchInvHeader@1000 : Record 122;
      InstructionMgt@1001 : Codeunit 1330;
    BEGIN
      PurchInvHeader.SETRANGE("Pre-Assigned No.","No.");
      PurchInvHeader.SETRANGE("Order No.",'');
      IF PurchInvHeader.FINDFIRST THEN
        IF InstructionMgt.ShowConfirm(OpenPostedPurchaseInvQst,InstructionMgt.ShowPostedConfirmationMessageCode) THEN
          PAGE.RUN(PAGE::"Posted Purchase Invoice",PurchInvHeader);
    END;

    LOCAL PROCEDURE ValidateShippingOption@8();
    BEGIN
      CASE ShipToOptions OF
        ShipToOptions::"Default (Company Address)",
        ShipToOptions::"Custom Address":
          VALIDATE("Location Code",'');
        ShipToOptions::Location:
          VALIDATE("Location Code");
      END;
    END;

    LOCAL PROCEDURE CalculateCurrentShippingAndPayToOption@36();
    BEGIN
      IF "Location Code" <> '' THEN
        ShipToOptions := ShipToOptions::Location
      ELSE
        IF ShipToAddressEqualsCompanyShipToAddress THEN
          ShipToOptions := ShipToOptions::"Default (Company Address)"
        ELSE
          ShipToOptions := ShipToOptions::"Custom Address";

      IF "Pay-to Vendor No." = "Buy-from Vendor No." THEN
        PayToOptions := PayToOptions::"Default (Vendor)"
      ELSE
        PayToOptions := PayToOptions::"Another Vendor";
    END;

    BEGIN
    END.
  }
}

