OBJECT Page 52 Purchase Credit Memo
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Kõbskreditnota;
               ENU=Purchase Credit Memo];
    SourceTable=Table38;
    SourceTableView=WHERE(Document Type=FILTER(Credit Memo));
    PageType=Document;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Godkend,Anmod om godkendelse;
                                ENU=New,Process,Report,Approve,Request Approval];
    OnInit=VAR
             PurchasesPayablesSetup@1000 : Record 312;
           BEGIN
             JobQueueUsed := PurchasesPayablesSetup.JobQueueActive;
             SetExtDocNoMandatoryCondition;
           END;

    OnOpenPage=VAR
                 OfficeMgt@1000 : Codeunit 1630;
                 PermissionManager@1001 : Codeunit 9002;
               BEGIN
                 SetDocNoVisible;
                 IsOfficeAddin := OfficeMgt.IsAvailable;
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
                       CalculateCurrentShippingOption;
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
                           SetControlAppearance;
                           CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
                           CurrPage.ApprovalFactBox.PAGE.UpdateApprovalEntriesFromSourceRecord(RECORDID);
                           ShowWorkflowStatus := CurrPage.WorkflowStatus.PAGE.SetFilterOnWorkflowRecord(RECORDID);
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 47      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Kreditnota;
                                 ENU=&Credit Memo];
                      Image=CreditMemo }
      { 49      ;2   ;Action    ;
                      Name=Statistics;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=FÜ vist statistiske oplysninger som f.eks. vërdien for bogfõrte poster til recorden.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CalcInvDiscForHeader;
                                 COMMIT;
                                 PAGE.RUNMODAL(PAGE::"Purchase Statistics",Rec);
                                 PurchCalcDiscByType.ResetRecalculateInvoiceDisc(Rec);
                               END;
                                }
      { 50      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kreditor;
                                 ENU=Vendor];
                      ToolTipML=[DAN=FÜ vist eller rediger detaljerede oplysninger om kreditoren i kõbsdokumentet.;
                                 ENU=View or edit detailed information about the vendor on the purchase document.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 26;
                      RunPageLink=No.=FIELD(Buy-from Vendor No.);
                      Enabled="Buy-from Vendor No." <> '';
                      Image=Vendor }
      { 105     ;2   ;Action    ;
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
      { 43      ;2   ;Action    ;
                      Name=Approvals;
                      AccessByPermission=TableData 454=R;
                      CaptionML=[DAN=Godkendelser;
                                 ENU=Approvals];
                      ToolTipML=[DAN=FÜ vist en liste over records, der afventer godkendelse. Du kan f.eks. se, hvem der har anmodet om godkendelse af recorden, hvornÜr den blev sendt og hvornÜr den skal godkendes.;
                                 ENU=View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.];
                      ApplicationArea=#Suite;
                      Image=Approvals;
                      OnAction=VAR
                                 WorkflowsEntriesBuffer@1001 : Record 832;
                               BEGIN
                                 WorkflowsEntriesBuffer.RunWorkflowEntriesPage(RECORDID,DATABASE::"Purchase Header","Document Type","No.");
                               END;
                                }
      { 51      ;2   ;Action    ;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 66;
                      RunPageLink=Document Type=FIELD(Document Type),
                                  No.=FIELD(No.),
                                  Document Line No.=CONST(0);
                      Image=ViewComments }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 23      ;1   ;ActionGroup;
                      CaptionML=[DAN=Godkendelse;
                                 ENU=Approval] }
      { 25      ;2   ;Action    ;
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
      { 19      ;2   ;Action    ;
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
      { 21      ;2   ;Action    ;
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
      { 17      ;2   ;Action    ;
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
      { 112     ;2   ;Action    ;
                      Name=Release;
                      ShortCutKey=Ctrl+F9;
                      CaptionML=[DAN=F&rigiv;
                                 ENU=Re&lease];
                      ToolTipML=[DAN=Frigiv bilaget til nëste behandlingstrin. NÜr et bilag frigives, bliver det inkluderet i alle disponeringsberegninger fra den dato, varerne forventes modtaget. Du skal genÜbne bilaget, fõr du kan foretage ëndringer i det.;
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
      { 113     ;2   ;Action    ;
                      Name=Reopen;
                      CaptionML=[DAN=&èbn igen;
                                 ENU=Re&open];
                      ToolTipML=[DAN=èbn bilaget igen for at ëndre det, efter at det er blevet godkendt. Godkendte bilag har status Frigivet og skal Übnes, fõr de kan ëndres;
                                 ENU=Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Enabled=Status <> Status::Open;
                      Image=ReOpen;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 ReleasePurchDoc@1001 : Codeunit 415;
                               BEGIN
                                 ReleasePurchDoc.PerformManualReopen(Rec);
                               END;
                                }
      { 52      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 127     ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Hent s&td.kred.kõbskoder;
                                 ENU=Get St&d. Vend. Purchase Codes];
                      ToolTipML=[DAN=Vis en liste over standardkõbslinjer, som den aktuelle kreditor er blevet tildelt til brug ved tilbagevendende kõb.;
                                 ENU=View a list of the standard purchase lines that have been assigned to the vendor to be used for recurring purchases.];
                      ApplicationArea=#Advanced;
                      Image=VendorCode;
                      OnAction=VAR
                                 StdVendPurchCode@1000 : Record 175;
                               BEGIN
                                 StdVendPurchCode.InsertPurchLines(Rec);
                               END;
                                }
      { 53      ;2   ;Action    ;
                      Name=CalculateInvoiceDiscount;
                      AccessByPermission=TableData 24=R;
                      CaptionML=[DAN=&Beregn fakturarabat;
                                 ENU=Calculate &Invoice Discount];
                      ToolTipML=[DAN=Beregn fakturarabatten for hele dokumentet.;
                                 ENU=Calculate the invoice discount for the entire document.];
                      ApplicationArea=#Basic,#Suite;
                      Image=CalculateInvoiceDiscount;
                      OnAction=BEGIN
                                 ApproveCalcInvDisc;
                                 PurchCalcDiscByType.ResetRecalculateInvoiceDisc(Rec);
                               END;
                                }
      { 128     ;2   ;Separator  }
      { 93      ;2   ;Action    ;
                      Name=ApplyEntries;
                      ShortCutKey=Shift+F11;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Udlign;
                                 ENU=Apply Entries];
                      ToolTipML=[DAN=Udlign Übne poster for den relevante kontotype.;
                                 ENU=Apply open entries for the relevant account type.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=ApplyEntries;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Purchase Header Apply",Rec);
                               END;
                                }
      { 129     ;2   ;Separator  }
      { 143     ;2   ;Action    ;
                      Name=GetPostedDocumentLinesToReverse;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Hent bogfõrte bilagslinje&r, der skal tilbagefõres;
                                 ENU=Get Posted Doc&ument Lines to Reverse];
                      ToolTipML=[DAN=KopiÇr en eller flere bogfõrte indkõbsdokumentlinjer for at tilbagefõre den oprindelige ordre.;
                                 ENU=Copy one or more posted purchase document lines in order to reverse the original order.];
                      ApplicationArea=#Advanced;
                      Image=ReverseLines;
                      OnAction=BEGIN
                                 GetPstdDocLinesToRevere;
                               END;
                                }
      { 54      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=KopiÇr dokument;
                                 ENU=Copy Document];
                      ToolTipML=[DAN=KopiÇr linjer og sidehovedoplysninger fra et andet salgsbilag til dette bilag. Du kan kopiere en bogfõrt salgsfaktura til en ny salgsfaktura, hvis du hurtigt vil oprette et lignende bilag.;
                                 ENU=Copy document lines and header information from another sales document to this document. You can copy a posted sales invoice into a new sales invoice to quickly create a similar document.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Image=CopyDocument;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CopyPurchDoc.SetPurchHeader(Rec);
                                 CopyPurchDoc.RUNMODAL;
                                 CLEAR(CopyPurchDoc);
                                 IF GET("Document Type","No.") THEN;
                               END;
                                }
      { 131     ;2   ;Separator  }
      { 114     ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Flyt negative linjer;
                                 ENU=Move Negative Lines];
                      ToolTipML=[DAN=Gõr dig klar til at oprette en erstatningssalgsordre i en salgsreturproces.;
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
      { 132     ;2   ;Separator  }
      { 37      ;2   ;ActionGroup;
                      Name=IncomingDocument;
                      CaptionML=[DAN=IndgÜende bilag;
                                 ENU=Incoming Document];
                      ActionContainerType=NewDocumentItems;
                      Image=Documents }
      { 35      ;3   ;Action    ;
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
      { 33      ;3   ;Action    ;
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
      { 31      ;3   ;Action    ;
                      Name=IncomingDocAttachFile;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Opret indgÜende bilag ud fra fil;
                                 ENU=Create Incoming Document from File];
                      ToolTipML=[DAN=Opret en indgÜende bilagsrecord ved at vëlge en fil, der skal vedhëftes, og knyt derefter den indgÜende bilagsrecord til posten eller bilaget.;
                                 ENU=Create an incoming document record by selecting a file to attach, and then link the incoming document record to the entry or document.];
                      ApplicationArea=#Basic,#Suite;
                      Enabled=CreateIncomingDocumentEnabled;
                      Image=Attach;
                      OnAction=VAR
                                 IncomingDocumentAttachment@1000 : Record 133;
                               BEGIN
                                 IncomingDocumentAttachment.NewAttachmentFromPurchaseDocument(Rec);
                               END;
                                }
      { 41      ;3   ;Action    ;
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
      { 11      ;1   ;ActionGroup;
                      CaptionML=[DAN=Anmod om godkendelse;
                                 ENU=Request Approval];
                      Image=Approval }
      { 146     ;2   ;Action    ;
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
                      PromotedCategory=Category5;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ApprovalsMgmt@1001 : Codeunit 1535;
                               BEGIN
                                 IF ApprovalsMgmt.CheckPurchaseApprovalPossible(Rec) THEN
                                   ApprovalsMgmt.OnSendPurchaseDocForApproval(Rec);
                               END;
                                }
      { 147     ;2   ;Action    ;
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
                      PromotedCategory=Category5;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ApprovalsMgmt@1001 : Codeunit 1535;
                                 WorkflowWebhookMgt@1000 : Codeunit 1543;
                               BEGIN
                                 ApprovalsMgmt.OnCancelPurchaseApprovalRequest(Rec);
                                 WorkflowWebhookMgt.FindAndCancel(RECORDID);
                               END;
                                }
      { 144     ;2   ;Separator  }
      { 61      ;2   ;ActionGroup;
                      CaptionML=[DAN=Flow;
                                 ENU=Flow];
                      Image=Flow }
      { 62      ;3   ;Action    ;
                      Name=CreateFlow;
                      CaptionML=[DAN=Opret et workflow;
                                 ENU=Create a Flow];
                      ToolTipML=[DAN=Opret et nyt workflow fra en liste over relevante workflowskabeloner.;
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
                                 // Opens page 6400 where the user can use filtered templates to create new flows.
                                 FlowTemplateSelector.SetSearchText(FlowServiceManagement.GetPurchasingTemplateFilter);
                                 FlowTemplateSelector.RUN;
                               END;
                                }
      { 64      ;3   ;Action    ;
                      Name=SeeFlows;
                      CaptionML=[DAN=Se mine workflows;
                                 ENU=See my Flows];
                      ToolTipML=[DAN=FÜ vist og konfigurer de workflowforekomster, du har oprettet.;
                                 ENU=View and configure Flows that you created.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 6401;
                      Promoted=Yes;
                      Image=Flow;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes }
      { 57      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Bogfõring;
                                 ENU=P&osting];
                      Image=Post }
      { 59      ;2   ;Action    ;
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
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Post(CODEUNIT::"Purch.-Post (Yes/No)");
                               END;
                                }
      { 27      ;2   ;Action    ;
                      Name=Preview;
                      CaptionML=[DAN=Vis bogfõring;
                                 ENU=Preview Posting];
                      ToolTipML=[DAN=Gennemse de forskellige typer poster, der oprettes, nÜr du bogfõrer bilaget eller kladden.;
                                 ENU=Review the different types of entries that will be created when you post the document or journal.];
                      ApplicationArea=#Basic,#Suite;
                      Image=ViewPostedOrder;
                      OnAction=VAR
                                 PurchPostYesNo@1000 : Codeunit 91;
                               BEGIN
                                 PurchPostYesNo.Preview(Rec);
                               END;
                                }
      { 58      ;2   ;Action    ;
                      Name=TestReport;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kontroller;
                                 ENU=Test Report];
                      ToolTipML=[DAN=Vis en testrapport, sÜ du kan finde og rette eventuelle fejl, fõr du udfõrer den faktiske bogfõring af kladden eller bilaget.;
                                 ENU=View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.];
                      ApplicationArea=#Advanced;
                      Image=TestReport;
                      OnAction=BEGIN
                                 ReportPrint.PrintPurchHeader(Rec);
                               END;
                                }
      { 60      ;2   ;Action    ;
                      Name=PostAndPrint;
                      ShortCutKey=Shift+F9;
                      CaptionML=[DAN=Bogfõr og &udskriv;
                                 ENU=Post and &Print];
                      ToolTipML=[DAN=Fërdiggõr bilaget eller kladden, og forbered udskrivning. Vërdierne og mëngderne bogfõres pÜ de relevante konti. Du fÜr vist et rapportanmodningsvindue, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=NOT IsOfficeAddin;
                      PromotedIsBig=Yes;
                      Image=PostPrint;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Post(CODEUNIT::"Purch.-Post + Print");
                               END;
                                }
      { 3       ;2   ;Action    ;
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
                Visible=DocNoVisible;
                OnAssistEdit=BEGIN
                               IF AssistEdit(xRec) THEN
                                 CurrPage.UPDATE;
                             END;
                              }

    { 22  ;2   ;Field     ;
                CaptionML=[DAN=Kreditornr.;
                           ENU=Vendor No.];
                ToolTipML=[DAN=Angiver nummeret pÜ den kreditor, der leverer produkterne.;
                           ENU=Specifies the number of the vendor who delivers the products.];
                ApplicationArea=#Basic,#Suite;
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
                ToolTipML=[DAN=Angiver navnet pÜ den kreditor, der leverer produkterne.;
                           ENU=Specifies the name of the vendor who delivers the products.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Buy-from Vendor Name";
                Importance=Promoted;
                OnValidate=VAR
                             ApplicationAreaSetup@1001 : Record 9178;
                           BEGIN
                             IF "No." = '' THEN
                               InitRecord;

                             OnAfterValidateBuyFromVendorNo(Rec,xRec);

                             IF ApplicationAreaSetup.IsFoundationEnabled THEN
                               PurchCalcDiscByType.ApplyDefaultInvoiceDiscount(0,Rec);

                             CurrPage.UPDATE;
                           END;

                ShowMandatory=TRUE;
                QuickEntry=FALSE }

    { 4   ;2   ;Group     ;
                CaptionML=[DAN=Leverandõr;
                           ENU=Buy-from];
                GroupType=Group }

    { 63  ;3   ;Field     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                ToolTipML=[DAN=Angiver adressen pÜ den kreditor, der leverer varerne.;
                           ENU=Specifies the address of the vendor who ships the items.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Buy-from Address";
                Importance=Additional }

    { 65  ;3   ;Field     ;
                CaptionML=[DAN=Adresse 2;
                           ENU=Address 2];
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Buy-from Address 2";
                Importance=Additional }

    { 68  ;3   ;Field     ;
                CaptionML=[DAN=Postnr.;
                           ENU=Post Code];
                ToolTipML=[DAN=Angiver postnummer.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Buy-from Post Code";
                Importance=Additional }

    { 67  ;3   ;Field     ;
                CaptionML=[DAN=By;
                           ENU=City];
                ToolTipML=[DAN=Angiver byen for kreditoren pÜ kõbsdokumentet.;
                           ENU=Specifies the city of the vendor on the purchase document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Buy-from City";
                Importance=Additional;
                QuickEntry=FALSE }

    { 123 ;3   ;Field     ;
                CaptionML=[DAN=Kontaktnr.;
                           ENU=Contact No.];
                ToolTipML=[DAN=Angiver nummeret pÜ din kontakt hos kreditoren.;
                           ENU=Specifies the number of your contact at the vendor.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Buy-from Contact No.";
                Importance=Additional;
                QuickEntry=FALSE }

    { 8   ;2   ;Field     ;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                ToolTipML=[DAN=Angiver navnet pÜ den person, der skal kontaktes om leveringen af varer fra denne kreditor.;
                           ENU=Specifies the name of the person to contact about shipment of the item from this vendor.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Buy-from Contact";
                Editable="Buy-from Vendor No." <> '' }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor bogfõringen af kõbsdokumentet skal registreres.;
                           ENU=Specifies the date when the posting of the purchase document will be recorded.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Posting Date";
                Importance=Additional;
                QuickEntry=FALSE }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Date";
                Importance=Additional;
                QuickEntry=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvornÜr fakturaen er forfalden til betaling. Feltet beregnes automatisk ud fra data i felterne Betalingsbeting.kode og Bilagsdato.;
                           ENU=Specifies when the invoice is due. The program calculates the date using the Payment Terms Code and Document Date fields.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Due Date";
                Importance=Promoted }

    { 96  ;2   ;Field     ;
                ToolTipML=[DAN=Viser den dato, hvor varerne pÜ kõbsdokumentet forventes modtaget.;
                           ENU=Specifies the date you expect to receive the items on the purchase document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Expected Receipt Date" }

    { 115 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for en kompensationsaftale.;
                           ENU=Specifies the identification number of a compensation agreement.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Vendor Authorization No." }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ det indgÜende bilag, som dette kõbsbilag er oprettet til.;
                           ENU=Specifies the number of the incoming document that this purchase document is created for.];
                ApplicationArea=#Advanced;
                SourceExpr="Incoming Document Entry No.";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bilagsnummeret for det oprindelige bilag, du modtog fra kreditoren. Du kan krëve bilagsnummeret til bogfõring, eller du kan lade det vëre valgfrit. Det er pÜkrëvet som standard, sÜ dette bilag refererer til originalen. Det fjerner et trin fra bogfõringsprocessen at gõre bilagsnumre valgfri. Hvis du f.eks. vedhëfter den oprindelige faktura som en PDF-fil, behõver du mÜske ikke at angive dokumentnummeret. I vinduet Kõbsopsëtning kan du vëlge, om dokumentnumre er pÜkrëvet ved at vëlge eller rydde markeringen i afkrydsningsfeltet Eksternt bilagsnr. obl.;
                           ENU=Specifies the document number of the original document you received from the vendor. You can require the document number for posting, or let it be optional. By default, it's required, so that this document references the original. Making document numbers optional removes a step from the posting process. For example, if you attach the original invoice as a PDF, you might not need to enter the document number. To specify whether document numbers are required, in the Purchases & Payables Setup window, select or clear the Ext. Doc. No. Mandatory field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Vendor Cr. Memo No.";
                ShowMandatory=VendorCreditMemoNoMandatory }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken indkõber der er knyttet til den aktuelle kreditor.;
                           ENU=Specifies which purchaser is assigned to the vendor.];
                ApplicationArea=#Suite;
                SourceExpr="Purchaser Code";
                Importance=Additional;
                OnValidate=BEGIN
                             PurchaserCodeOnAfterValidate;
                           END;
                            }

    { 1102601000;2;Field  ;
                ToolTipML=[DAN=Angiver nummeret pÜ den kampagne, bilaget er knyttet til.;
                           ENU=Specifies the campaign number the document is linked to.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Campaign No.";
                Importance=Additional }

    { 107 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode for ansvarscenteret (f.eks. et distributionscenter), som er tildelt den involverede bruger, virksomhed, debitor eller kreditor.;
                           ENU=Specifies the code of the responsibility center, such as a distribution hub, that is associated with the involved user, company, customer, or vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Responsibility Center";
                Importance=Additional }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der er ansvarlig for bilaget.;
                           ENU=Specifies the ID of the user who is responsible for the document.];
                ApplicationArea=#Advanced;
                SourceExpr="Assigned User ID";
                Importance=Additional;
                QuickEntry=FALSE }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for en opgavekõpost, der hÜndterer bogfõring af kreditnotaer.;
                           ENU=Specifies the status of a job queue entry that handles the posting of purchase credit memos.];
                ApplicationArea=#All;
                SourceExpr="Job Queue Status";
                Importance=Additional;
                Visible=JobQueueUsed }

    { 101 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om recorden er Üben afventer godkendelse, er faktureret til forudbetaling eller er frigivet til nëste fase i behandlingen.;
                           ENU=Specifies whether the record is open, is waiting to be approved, has been invoiced for prepayment, or has been released to the next stage of processing.];
                ApplicationArea=#Suite;
                SourceExpr=Status;
                Importance=Additional;
                QuickEntry=FALSE }

    { 46  ;1   ;Part      ;
                Name=PurchLines;
                ApplicationArea=#Basic,#Suite;
                SubPageLink=Document No.=FIELD(No.);
                PagePartID=Page98;
                Enabled="Buy-from Vendor No." <> '';
                Editable="Buy-from Vendor No." <> '';
                UpdatePropagation=Both }

    { 1905885101;1;Group  ;
                CaptionML=[DAN=Fakturadetaljer;
                           ENU=Invoice Details];
                GroupType=Group }

    { 91  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver valutakoden for belõbet pÜ kõbslinjerne.;
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

    { 110 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om felterne Enhedspris og Linjebelõb pÜ bilagslinjer skal vises med eller uden moms.;
                           ENU=Specifies if the Unit Price and Line Amount fields on document lines should be shown with or without VAT.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Prices Including VAT";
                OnValidate=BEGIN
                             PricesIncludingVATOnAfterValid;
                           END;
                            }

    { 141 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede debitors eller kreditors momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogfõringsopsëtning.;
                           ENU=Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Bus. Posting Group";
                OnValidate=VAR
                             ApplicationAreaSetup@1000 : Record 9178;
                           BEGIN
                             IF ApplicationAreaSetup.IsFoundationEnabled THEN
                               PurchCalcDiscByType.ApplyDefaultInvoiceDiscount(0,Rec);
                           END;
                            }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en formel, der beregner betalingens forfaldsdato, kontantrabatdato og kontantrabatbelõb.;
                           ENU=Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Terms Code";
                Importance=Promoted }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den transaktionstype, som bilaget reprësenterer med henblik pÜ rapportering til INTRASTAT.;
                           ENU=Specifies the type of transaction that the document represents, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Transaction Type" }

    { 76  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 1 Code";
                OnValidate=BEGIN
                             ShortcutDimension1CodeOnAfterV;
                           END;
                            }

    { 78  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 2 Code";
                OnValidate=BEGIN
                             ShortcutDimension2CodeOnAfterV;
                           END;
                            }

    { 94  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den rabatprocent, der tildeles, hvis betaling gennemfõres fõr eller pÜ den dato, der er angivet i feltet Kontantrabatdato.;
                           ENU=Specifies the payment discount percent granted if payment is made on or before the date in the Pmt. Discount Date field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Discount %" }

    { 139 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor belõbet i posten skal vëre betalt, for at der kan opnÜs kontantrabat.;
                           ENU=Specifies the date on which the amount in the entry must be paid for a payment discount to be granted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pmt. Discount Date";
                Importance=Additional }

    { 80  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for den lokation, som de bestilte varer skal placeres pÜ efter levering.;
                           ENU=Specifies a code for the location where you want the items to be placed when they are received.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Importance=Additional }

    { 1906801201;1;Group  ;
                CaptionML=[DAN=Forsendelse og betaling;
                           ENU=Shipping and Payment];
                GroupType=Group }

    { 71  ;2   ;Group     ;
                GroupType=Group }

    { 70  ;3   ;Field     ;
                CaptionML=[DAN=Leveres til;
                           ENU=Ship-to];
                ToolTipML=[DAN=Angiver den adresse, som produkter i kõbsbilaget skal leveres til. Standard (firmaadresse): Det samme som den firmaadresse, der er angivet i vinduet Virksomhedsoplysninger. Lokation: ên af virksomhedens lokationsadresser. Brugerdefineret adresse: En vilkÜrlig leveringsadresse, som du angiver i nedenstÜende felter.;
                           ENU=Specifies the address that the products on the purchase document are shipped to. Default (Company Address): The same as the company address specified in the Company Information window. Location: One of the company's location addresses. Custom Address: Any ship-to address that you specify in the fields below.];
                OptionCaptionML=[DAN=Standard (kreditoradresse),alternativ kreditoradresse,brugerdefineret adresse;
                                 ENU=Default (Vendor Address),Alternate Vendor Address,Custom Address];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ShipToOptions;
                OnValidate=BEGIN
                             ValidateShippingOption;
                           END;
                            }

    { 69  ;2   ;Group     ;
                Visible=ShipToOptions = ShipToOptions::"Alternate Vendor Address";
                GroupType=Group }

    { 72  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver bestillingsadressen for den relaterede kreditor.;
                           ENU=Specifies the order address of the related vendor.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Order Address Code" }

    { 48  ;2   ;Group     ;
                CaptionML=[DAN=Leveres til;
                           ENU=Ship-to];
                GroupType=Group }

    { 32  ;3   ;Field     ;
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver navnet pÜ firmaet med den adresse, som varerne i kõbsordren skal leveres til.;
                           ENU=Specifies the name of the company at the address to which you want the items in the purchase order to be shipped.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Name";
                Importance=Additional;
                Editable=ShipToOptions = ShipToOptions::"Custom Address" }

    { 34  ;3   ;Field     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                ToolTipML=[DAN=Angiver den adresse, som varerne i kõbsordren skal leveres til.;
                           ENU=Specifies the address that you want the items in the purchase order to be shipped to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Address";
                Importance=Additional;
                Editable=ShipToOptions = ShipToOptions::"Custom Address" }

    { 36  ;3   ;Field     ;
                CaptionML=[DAN=Adresse 2;
                           ENU=Address 2];
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Address 2";
                Importance=Additional;
                Editable=ShipToOptions = ShipToOptions::"Custom Address" }

    { 83  ;3   ;Field     ;
                CaptionML=[DAN=Postnr.;
                           ENU=Post Code];
                ToolTipML=[DAN=Angiver postnummer.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Post Code";
                Importance=Additional;
                Editable=ShipToOptions = ShipToOptions::"Custom Address" }

    { 38  ;3   ;Field     ;
                CaptionML=[DAN=By;
                           ENU=City];
                ToolTipML=[DAN=Angiver byen for kreditoren pÜ kõbsdokumentet.;
                           ENU=Specifies the city of the vendor on the purchase document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to City";
                Importance=Additional;
                Editable=ShipToOptions = ShipToOptions::"Custom Address" }

    { 40  ;3   ;Field     ;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                ToolTipML=[DAN=Angiver navnet pÜ en kontaktperson pÜ den adresse, som varerne i kõbsordren skal leveres pÜ.;
                           ENU=Specifies the name of a contact person for the address where the items in the purchase order should be shipped.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Contact";
                Importance=Additional;
                Editable=ShipToOptions = ShipToOptions::"Custom Address" }

    { 55  ;2   ;Group     ;
                CaptionML=[DAN=Faktureres til;
                           ENU=Pay-to];
                GroupType=Group }

    { 20  ;3   ;Field     ;
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver den kreditor, fakturaen er sendt fra.;
                           ENU=Specifies the vendor who is sending the invoice.];
                ApplicationArea=#Basic,#Suite;
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

    { 24  ;3   ;Field     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                ToolTipML=[DAN=Angiver adressen pÜ den kreditor, fakturaen er sendt fra.;
                           ENU=Specifies the address of the vendor sending the invoice.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pay-to Address";
                Importance=Additional }

    { 26  ;3   ;Field     ;
                CaptionML=[DAN=Adresse 2;
                           ENU=Address 2];
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pay-to Address 2";
                Importance=Additional }

    { 73  ;3   ;Field     ;
                CaptionML=[DAN=Postnr.;
                           ENU=Post Code];
                ToolTipML=[DAN=Angiver postnummer.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pay-to Post Code";
                Importance=Additional }

    { 28  ;3   ;Field     ;
                CaptionML=[DAN=By;
                           ENU=City];
                ToolTipML=[DAN=Angiver byen for kreditoren pÜ kõbsdokumentet.;
                           ENU=Specifies the city of the vendor on the purchase document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pay-to City";
                Importance=Additional }

    { 125 ;3   ;Field     ;
                CaptionML=[DAN=Kontaktnr.;
                           ENU=Contact No.];
                ToolTipML=[DAN=Angiver nummeret pÜ den kontakt, der sender fakturaen.;
                           ENU=Specifies the number of the contact who sends the invoice.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pay-to Contact No.";
                Importance=Additional }

    { 30  ;3   ;Field     ;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                ToolTipML=[DAN=Angiver navnet pÜ en kontaktperson hos den kreditor, fakturaen er sendt fra.;
                           ENU=Specifies the name of the person to contact about an invoice from this vendor.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pay-to Contact" }

    { 1907468901;1;Group  ;
                CaptionML=[DAN=Udenrigshandel;
                           ENU=Foreign Trade] }

    { 89  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en specifikation af bilagets transaktion med henblik pÜ rapportering til INTRASTAT.;
                           ENU=Specifies a specification of the document's transaction, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Transaction Specification" }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver transportmÜden ved rapportering til INTRASTAT.;
                           ENU=Specifies the transport method, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Transport Method" }

    { 85  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for det indfõrselssted, hvor varerne kom ind i landet/omrÜdet, for rapportering til Intrastat.;
                           ENU=Specifies the code of the port of entry where the items pass into your country/region, for reporting to Intrastat.];
                ApplicationArea=#Advanced;
                SourceExpr="Entry Point" }

    { 87  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitors eller kreditors omrÜde med henblik pÜ rapportering til INTRASTAT.;
                           ENU=Specifies the area of the customer or vendor, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr=Area }

    { 1904409301;1;Group  ;
                CaptionML=[DAN=Udligning;
                           ENU=Application] }

    { 135 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den type bogfõrt bilag, som dette bilag eller denne kladdelinje udlignes pÜ, nÜr du bogfõrer, f.eks. til registrering af betaling.;
                           ENU=Specifies the type of the posted document that this document or journal line will be applied to when you post, for example to register payment.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Applies-to Doc. Type" }

    { 137 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ det bogfõrte bilag, som dette bilag eller denne kladdelinje udlignes pÜ, nÜr du bogfõrer, f.eks. til registrering af betaling.;
                           ENU=Specifies the number of the posted document that this document or journal line will be applied to when you post, for example to register payment.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Applies-to Doc. No." }

    { 133 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id for poster, der udlignes, nÜr du vëlger handlingen Udlign poster.;
                           ENU=Specifies the ID of entries that will be applied to when you choose the Apply Entries action.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Applies-to ID" }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 15  ;1   ;Part      ;
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

    { 1904651607;1;Part   ;
                ApplicationArea=#Advanced;
                SubPageLink=No.=FIELD(Pay-to Vendor No.);
                PagePartID=Page9094;
                PartType=Page }

    { 1903435607;1;Part   ;
                ApplicationArea=#Advanced;
                SubPageLink=No.=FIELD(Buy-from Vendor No.);
                PagePartID=Page9095;
                PartType=Page }

    { 1906949207;1;Part   ;
                ApplicationArea=#Advanced;
                SubPageLink=No.=FIELD(Pay-to Vendor No.);
                PagePartID=Page9096;
                Visible=FALSE;
                PartType=Page }

    { 29  ;1   ;Part      ;
                Name=IncomingDocAttachFactBox;
                ApplicationArea=#Advanced;
                PagePartID=Page193;
                Visible=NOT IsOfficeAddin;
                PartType=Page;
                ShowFilter=No }

    { 5   ;1   ;Part      ;
                ApplicationArea=#Advanced;
                SubPageLink=Document Type=FIELD(Document Type),
                            Document No.=FIELD(Document No.),
                            Line No.=FIELD(Line No.);
                PagePartID=Page9100;
                ProviderID=46;
                Visible=FALSE;
                PartType=Page }

    { 45  ;1   ;Part      ;
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
      CopyPurchDoc@1002 : Report 492;
      MoveNegPurchLines@1005 : Report 6698;
      ReportPrint@1003 : Codeunit 228;
      UserMgt@1004 : Codeunit 5700;
      PurchCalcDiscByType@1007 : Codeunit 66;
      LinesInstructionMgt@1017 : Codeunit 1320;
      ChangeExchangeRate@1001 : Page 511;
      ShipToOptions@1022 : 'Default (Vendor Address),Alternate Vendor Address,Custom Address';
      JobQueueVisible@1000 : Boolean INDATASET;
      JobQueueUsed@1019 : Boolean INDATASET;
      HasIncomingDocument@1010 : Boolean;
      DocNoVisible@1006 : Boolean;
      VendorCreditMemoNoMandatory@1008 : Boolean;
      OpenApprovalEntriesExist@1009 : Boolean;
      OpenApprovalEntriesExistForCurrUser@1012 : Boolean;
      ShowWorkflowStatus@1011 : Boolean;
      IsOfficeAddin@1015 : Boolean;
      CanCancelApprovalForRecord@1014 : Boolean;
      DocumentIsPosted@1018 : Boolean;
      OpenPostedPurchCrMemoQst@1013 : TextConst 'DAN=Kreditnotaen er blevet bogfõrt og arkiveret.\\Vil du Übne den bogfõrte kreditnota fra vinduet Bogfõrte kõbskreditnotaer?;ENU=The credit memo has been posted and archived.\\Do you want to open the posted credit memo from the Posted Purchase Credit Memos window?';
      CreateIncomingDocumentEnabled@1016 : Boolean;
      CanRequestApprovalForFlow@1020 : Boolean;
      CanCancelApprovalForFlow@1021 : Boolean;
      IsSaaS@1023 : Boolean;

    LOCAL PROCEDURE Post@4(PostingCodeunitID@1000 : Integer);
    VAR
      PurchaseHeader@1001 : Record 38;
      PurchCrMemoHdr@1002 : Record 124;
      ApplicationAreaSetup@1003 : Record 9178;
      InstructionMgt@1004 : Codeunit 1330;
      IsScheduledPosting@1005 : Boolean;
    BEGIN
      IF ApplicationAreaSetup.IsFoundationEnabled THEN
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
        PurchCrMemoHdr.SETRANGE("Pre-Assigned No.","No.");
        IF PurchCrMemoHdr.FINDFIRST THEN
          PAGE.RUN(PAGE::"Posted Purchase Credit Memo",PurchCrMemoHdr);
      END ELSE
        IF InstructionMgt.IsEnabled(InstructionMgt.ShowPostedConfirmationMessageCode) THEN
          ShowPostedConfirmationMessage;
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
    END;

    LOCAL PROCEDURE SetDocNoVisible@2();
    VAR
      DocumentNoVisibility@1001 : Codeunit 1400;
      DocType@1000 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Reminder,FinChMemo';
    BEGIN
      DocNoVisible := DocumentNoVisibility.PurchaseDocumentNoIsVisible(DocType::"Credit Memo","No.");
    END;

    LOCAL PROCEDURE SetExtDocNoMandatoryCondition@3();
    VAR
      PurchasesPayablesSetup@1000 : Record 312;
    BEGIN
      PurchasesPayablesSetup.GET;
      VendorCreditMemoNoMandatory := PurchasesPayablesSetup."Ext. Doc. No. Mandatory"
    END;

    LOCAL PROCEDURE SetControlAppearance@5();
    VAR
      ApprovalsMgmt@1002 : Codeunit 1535;
      WorkflowWebhookMgt@1000 : Codeunit 1543;
    BEGIN
      JobQueueVisible := "Job Queue Status" = "Job Queue Status"::"Scheduled for Posting";
      HasIncomingDocument := "Incoming Document Entry No." <> 0;
      CreateIncomingDocumentEnabled := (NOT HasIncomingDocument) AND ("No." <> '');
      SetExtDocNoMandatoryCondition;

      OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RECORDID);
      OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);

      CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RECORDID);

      WorkflowWebhookMgt.GetCanRequestAndCanCancel(RECORDID,CanRequestApprovalForFlow,CanCancelApprovalForFlow);
    END;

    LOCAL PROCEDURE ShowPostedConfirmationMessage@13();
    VAR
      PurchCrMemoHdr@1000 : Record 124;
      InstructionMgt@1001 : Codeunit 1330;
    BEGIN
      PurchCrMemoHdr.SETRANGE("Pre-Assigned No.","No.");
      IF PurchCrMemoHdr.FINDFIRST THEN
        IF InstructionMgt.ShowConfirm(OpenPostedPurchCrMemoQst,InstructionMgt.ShowPostedConfirmationMessageCode) THEN
          PAGE.RUN(PAGE::"Posted Purchase Credit Memo",PurchCrMemoHdr);
    END;

    LOCAL PROCEDURE ValidateShippingOption@7();
    BEGIN
      CASE ShipToOptions OF
        ShipToOptions::"Default (Vendor Address)":
          BEGIN
            VALIDATE("Order Address Code",'');
            VALIDATE("Buy-from Vendor No.");
          END;
        ShipToOptions::"Alternate Vendor Address":
          VALIDATE("Order Address Code",'');
      END
    END;

    LOCAL PROCEDURE CalculateCurrentShippingOption@8();
    BEGIN
      CASE TRUE OF
        "Order Address Code" <> '':
          ShipToOptions := ShipToOptions::"Alternate Vendor Address";
        BuyFromAddressEqualsShipToAddress:
          ShipToOptions := ShipToOptions::"Default (Vendor Address)";
        ELSE
          ShipToOptions := ShipToOptions::"Custom Address";
      END;
    END;

    BEGIN
    END.
  }
}

