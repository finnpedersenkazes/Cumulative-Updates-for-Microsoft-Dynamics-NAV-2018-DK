OBJECT Page 41 Sales Quote
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Salgstilbud;
               ENU=Sales Quote];
    SourceTable=Table36;
    SourceTableView=WHERE(Document Type=FILTER(Quote));
    PageType=Document;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,RapportÇr,Tilbud,Vis,Godkend,Anmod om godkendelse,Oversigt;
                                ENU=New,Process,Report,Quote,View,Approve,Request Approval,History];
    OnInit=BEGIN
             EnableBillToCustomerNo := TRUE;
             EnableSellToCustomerTemplateCode := TRUE;
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

                 ActivateFields;

                 SetDocNoVisible;
                 IsOfficeAddin := OfficeMgt.IsAvailable;
                 SetControlAppearance;
                 IsSaaS := PermissionManager.SoftwareAsAService;
               END;

    OnAfterGetRecord=BEGIN
                       ActivateFields;
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
                  SetControlAppearance;
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

    OnAfterGetCurrRecord=BEGIN
                           ActivateFields;
                           CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
                           CurrPage.ApprovalFactBox.PAGE.UpdateApprovalEntriesFromSourceRecord(RECORDID);
                           ShowWorkflowStatus := CurrPage.WorkflowStatus.PAGE.SetFilterOnWorkflowRecord(RECORDID);
                           UpdatePaymentService;
                           SetControlAppearance;
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;  ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 82      ;1   ;ActionGroup;
                      CaptionML=[DAN=T&ilbud;
                                 ENU=&Quote];
                      Image=Quote }
      { 44      ;2   ;Action    ;
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
                      PromotedCategory=Category7;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 WorkflowsEntriesBuffer@1000 : Record 832;
                               BEGIN
                                 WorkflowsEntriesBuffer.RunWorkflowEntriesPage(RECORDID,DATABASE::"Sales Header","Document Type","No.");
                               END;
                                }
      { 104     ;2   ;Action    ;
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
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 ShowDocDim;
                                 CurrPage.SAVERECORD;
                               END;
                                }
      { 4       ;1   ;ActionGroup;
                      CaptionML=[DAN=&Vis;
                                 ENU=&View] }
      { 62      ;2   ;Action    ;
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
                      PromotedCategory=Category4;
                      PromotedOnly=Yes }
      { 146     ;2   ;Action    ;
                      CaptionML=[DAN=&Kontakt;
                                 ENU=C&ontact];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om kontaktpersonen hos debitoren.;
                                 ENU=View or edit detailed information about the contact person at the customer.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 5050;
                      RunPageLink=No.=FIELD(Sell-to Contact No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Card;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes }
      { 87      ;1   ;ActionGroup;
                      CaptionML=[DAN=Oversigt;
                                 ENU=History] }
      { 85      ;2   ;Action    ;
                      Name=PageInteractionLogEntries;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=Interaktionslogp&oster;
                                 ENU=Interaction Log E&ntries];
                      ToolTipML=[DAN=Vis en oversigt over interaktionslogposter i forbindelse med dette dokument.;
                                 ENU=View a list of interaction log entries related to this document.];
                      ApplicationArea=#Suite;
                      Image=InteractionLog;
                      PromotedCategory=Category8;
                      OnAction=BEGIN
                                 ShowInteractionLogEntries;
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 59      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Tilbud;
                                 ENU=&Quote];
                      Image=Quote }
      { 61      ;2   ;Action    ;
                      Name=Statistics;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=FÜ vist statistiske oplysninger som f.eks. vërdien for bogfõrte poster til recorden.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Enabled="No." <> '';
                      Image=Statistics;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 Handled@1000 : Boolean;
                               BEGIN
                                 OnBeforeStatisticsAction(Rec,Handled);
                                 IF NOT Handled THEN BEGIN
                                   CalcInvDiscForHeader;
                                   COMMIT;
                                   PAGE.RUNMODAL(PAGE::"Sales Statistics",Rec);
                                   SalesCalcDiscByType.ResetRecalculateInvoiceDisc(Rec);
                                 END
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
      { 69      ;2   ;Action    ;
                      Name=Print;
                      Ellipsis=Yes;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=Forbered udskrivning af bilaget. Du fÜr vist et anmodningsvindue for bilaget, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.];
                      ApplicationArea=#Basic,#Suite;
                      Visible=NOT IsOfficeAddin;
                      Enabled=IsCustomerOrContactNotEmpty;
                      Image=Print;
                      OnAction=BEGIN
                                 CheckSalesCheckAllLinesHaveQuantityAssigned;
                                 DocPrint.PrintSalesHeader(Rec);
                               END;
                                }
      { 9       ;2   ;Action    ;
                      Name=Email;
                      CaptionML=[DAN=Send via &mail;
                                 ENU=Send by &Email];
                      ToolTipML=[DAN=Forbered at afsende bilaget via mail. Vinduet Send mail Übnes med debitorens mailadresse angivet, sÜ du kan tilfõje eller redigere oplysninger.;
                                 ENU=Prepare to mail the document. The Send Email window opens prefilled with the customer's email address so you can add or edit information.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=IsCustomerOrContactNotEmpty;
                      PromotedIsBig=Yes;
                      Image=Email;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 CheckSalesCheckAllLinesHaveQuantityAssigned;
                                 IF NOT FIND THEN
                                   INSERT(TRUE);
                                 DocPrint.EmailSalesHeader(Rec);
                               END;
                                }
      { 124     ;2   ;Action    ;
                      Name=GetRecurringSalesLines;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Hent tilbagevendende salgslinjer;
                                 ENU=Get Recurring Sales Lines];
                      ToolTipML=[DAN=Hent standardsalgslinjer, der kan tildeles til debitorer.;
                                 ENU=Get standard sales lines that are available to assign to customers.];
                      ApplicationArea=#Suite;
                      Enabled=IsCustomerOrContactNotEmpty;
                      Image=CustomerCode;
                      OnAction=VAR
                                 StdCustSalesCode@1000 : Record 172;
                               BEGIN
                                 StdCustSalesCode.InsertSalesLines(Rec);
                               END;
                                }
      { 66      ;2   ;Action    ;
                      Name=CopyDocument;
                      Ellipsis=Yes;
                      CaptionML=[DAN=KopiÇr dokument;
                                 ENU=Copy Document];
                      ToolTipML=[DAN=KopiÇr linjer og sidehovedoplysninger fra et andet salgsdokument til dette dokument. Du kan kopiere en bogfõrt salgsfaktura til en ny salgsfaktura, hvis du hurtigt vil oprette et lignende dokument.;
                                 ENU=Copy document lines and header information from another sales document to this document. You can copy a posted sales invoice into a new sales invoice to quickly create a similar document.];
                      ApplicationArea=#Suite;
                      Image=CopyDocument;
                      OnAction=BEGIN
                                 IF NOT FIND THEN BEGIN
                                   INSERT(TRUE);
                                   COMMIT;
                                 END;
                                 CopySalesDoc.SetSalesHeader(Rec);
                                 CopySalesDoc.RUNMODAL;
                                 CLEAR(CopySalesDoc);
                                 IF GET("Document Type","No.") THEN;
                               END;
                                }
      { 21      ;1   ;ActionGroup;
                      CaptionML=[DAN=Godkendelse;
                                 ENU=Approval] }
      { 19      ;2   ;Action    ;
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
                      PromotedCategory=Category6;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.ApproveRecordApprovalRequest(RECORDID);
                               END;
                                }
      { 17      ;2   ;Action    ;
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
                      PromotedCategory=Category6;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.RejectRecordApprovalRequest(RECORDID);
                               END;
                                }
      { 14      ;2   ;Action    ;
                      Name=Delegate;
                      CaptionML=[DAN=Uddeleger;
                                 ENU=Delegate];
                      ToolTipML=[DAN=Uddeleger godkendelsen til en stedfortrëdende godkender.;
                                 ENU=Delegate the approval to a substitute approver.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Visible=OpenApprovalEntriesExistForCurrUser;
                      Image=Delegate;
                      PromotedCategory=Category6;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.DelegateRecordApprovalRequest(RECORDID);
                               END;
                                }
      { 13      ;2   ;Action    ;
                      Name=Comment;
                      CaptionML=[DAN=Bemërkninger;
                                 ENU=Comments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Visible=OpenApprovalEntriesExistForCurrUser;
                      Image=ViewComments;
                      PromotedCategory=Category6;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.GetApprovalComment(Rec);
                               END;
                                }
      { 5       ;1   ;ActionGroup;
                      CaptionML=[DAN=Opret;
                                 ENU=Create];
                      Image=NewCustomer }
      { 68      ;2   ;Action    ;
                      Name=MakeOrder;
                      CaptionML=[DAN=Lav &ordre;
                                 ENU=Make &Order];
                      ToolTipML=[DAN=Omdan salgstilbuddet til en salgsordre.;
                                 ENU=Convert the sales quote to a sales order.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=IsCustomerOrContactNotEmpty;
                      PromotedIsBig=Yes;
                      Image=MakeOrder;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 IF ApprovalsMgmt.PrePostApprovalCheckSales(Rec) THEN
                                   CODEUNIT.RUN(CODEUNIT::"Sales-Quote to Order (Yes/No)",Rec);
                               END;
                                }
      { 37      ;2   ;Action    ;
                      Name=MakeInvoice;
                      CaptionML=[DAN=Opret faktura;
                                 ENU=Make Invoice];
                      ToolTipML=[DAN=Omdan salgstilbuddet til en salgsfaktura.;
                                 ENU=Convert the sales quote to a sales invoice.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=IsCustomerOrContactNotEmpty;
                      PromotedIsBig=Yes;
                      Image=MakeOrder;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 IF ApprovalsMgmt.PrePostApprovalCheckSales(Rec) THEN BEGIN
                                   CheckSalesCheckAllLinesHaveQuantityAssigned;
                                   CODEUNIT.RUN(CODEUNIT::"Sales-Quote to Invoice Yes/No",Rec);
                                 END;
                               END;
                                }
      { 126     ;2   ;Action    ;
                      CaptionML=[DAN=&Opret debitor;
                                 ENU=C&reate Customer];
                      ToolTipML=[DAN=Opret et nyt debitorkort for kontaktpersonen.;
                                 ENU=Create a new customer card for the contact.];
                      ApplicationArea=#Advanced;
                      Image=NewCustomer;
                      OnAction=BEGIN
                                 IF CheckCustomerCreated(FALSE) THEN
                                   CurrPage.UPDATE(TRUE);
                               END;
                                }
      { 169     ;2   ;Action    ;
                      AccessByPermission=TableData 5050=R;
                      CaptionML=[DAN=Opret &opgave;
                                 ENU=Create &Task];
                      ToolTipML=[DAN=Opret en ny marketingopgave for kontaktpersonen.;
                                 ENU=Create a new marketing task for the contact.];
                      ApplicationArea=#Advanced;
                      Image=NewToDo;
                      OnAction=BEGIN
                                 CreateTask;
                               END;
                                }
      { 3       ;1   ;ActionGroup;
                      CaptionML=[DAN=Frigiv;
                                 ENU=Release];
                      Image=ReleaseDoc }
      { 115     ;2   ;Action    ;
                      Name=Release;
                      ShortCutKey=Ctrl+F9;
                      CaptionML=[DAN=F&rigiv;
                                 ENU=Re&lease];
                      ToolTipML=[DAN=Frigiv bilaget til nëste behandlingstrin. NÜr et bilag frigives, bliver det inkluderet i alle disponeringsberegninger fra den dato, varerne forventes modtaget. Du skal genÜbne bilaget, fõr du kan foretage ëndringer i det.;
                                 ENU=Release the document to the next stage of processing. When a document is released, it will be included in all availability calculations from the expected receipt date of the items. You must reopen the document before you can make changes to it.];
                      ApplicationArea=#Suite;
                      Image=ReleaseDoc;
                      OnAction=VAR
                                 ReleaseSalesDoc@1000 : Codeunit 414;
                               BEGIN
                                 ReleaseSalesDoc.PerformManualRelease(Rec);
                               END;
                                }
      { 116     ;2   ;Action    ;
                      Name=Reopen;
                      CaptionML=[DAN=&èbn igen;
                                 ENU=Re&open];
                      ToolTipML=[DAN=èbn bilaget igen for at ëndre det, efter at det er blevet godkendt. Godkendte bilag har status Frigivet og skal Übnes, fõr de kan ëndres;
                                 ENU=Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed.];
                      ApplicationArea=#Suite;
                      Enabled=Status <> Status::Open;
                      Image=ReOpen;
                      OnAction=VAR
                                 ReleaseSalesDoc@1001 : Codeunit 414;
                               BEGIN
                                 ReleaseSalesDoc.PerformManualReopen(Rec);
                               END;
                                }
      { 7       ;1   ;ActionGroup;
                      CaptionML=[DAN=Anmod om godkendelse;
                                 ENU=Request Approval];
                      Image=Approval }
      { 190     ;2   ;Action    ;
                      Name=SendApprovalRequest;
                      CaptionML=[DAN=Send go&dkendelsesanmodning;
                                 ENU=Send A&pproval Request];
                      ToolTipML=[DAN=Anmod om godkendelse af bilaget.;
                                 ENU=Request approval of the document.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=NOT OpenApprovalEntriesExist AND CanRequestApprovalForFlow;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category7;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ApprovalsMgmt@1001 : Codeunit 1535;
                               BEGIN
                                 IF ApprovalsMgmt.CheckSalesApprovalPossible(Rec) THEN
                                   ApprovalsMgmt.OnSendSalesDocForApproval(Rec);
                               END;
                                }
      { 191     ;2   ;Action    ;
                      Name=CancelApprovalRequest;
                      CaptionML=[DAN=Annuller godkendelsesan&modning;
                                 ENU=Cancel Approval Re&quest];
                      ToolTipML=[DAN=Annuller godkendelsesanmodningen.;
                                 ENU=Cancel the approval request.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=CanCancelApprovalForRecord OR CanCancelApprovalForFlow;
                      Image=CancelApprovalRequest;
                      PromotedCategory=Category7;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ApprovalsMgmt@1001 : Codeunit 1535;
                                 WorkflowWebhookMgt@1000 : Codeunit 1543;
                               BEGIN
                                 ApprovalsMgmt.OnCancelSalesApprovalRequest(Rec);
                                 WorkflowWebhookMgt.FindAndCancel(RECORDID);
                               END;
                                }
      { 94      ;2   ;ActionGroup;
                      CaptionML=[DAN=Flow;
                                 ENU=Flow];
                      Image=Flow }
      { 92      ;3   ;Action    ;
                      Name=CreateFlow;
                      CaptionML=[DAN=Opret et flow;
                                 ENU=Create a Flow];
                      ToolTipML=[DAN=Opret et nyt flow fra en liste over relevante flow-skabeloner.;
                                 ENU=Create a new Flow from a list of relevant Flow templates.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=IsSaaS;
                      Image=Flow;
                      PromotedCategory=Category7;
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
      { 88      ;3   ;Action    ;
                      Name=SeeFlows;
                      CaptionML=[DAN=Se mine flow;
                                 ENU=See my Flows];
                      ToolTipML=[DAN=FÜ vist og konfigurer de flow-forekomster, du har oprettet.;
                                 ENU=View and configure Flows that you created.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 6401;
                      Promoted=Yes;
                      Image=Flow;
                      PromotedCategory=Category7;
                      PromotedOnly=Yes }
      { 64      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 65      ;2   ;Action    ;
                      Name=CalculateInvoiceDiscount;
                      AccessByPermission=TableData 19=R;
                      CaptionML=[DAN=&Beregn fakturarabat;
                                 ENU=Calculate &Invoice Discount];
                      ToolTipML=[DAN=Beregn fakturarabatten for salgstilbuddet.;
                                 ENU=Calculate the invoice discount that applies to the sales quote.];
                      ApplicationArea=#Basic,#Suite;
                      Enabled=IsCustomerOrContactNotEmpty;
                      Image=CalculateInvoiceDiscount;
                      OnAction=BEGIN
                                 ApproveCalcInvDisc;
                                 SalesCalcDiscByType.ResetRecalculateInvoiceDisc(Rec);
                               END;
                                }
      { 139     ;2   ;Separator  }
      { 165     ;2   ;Action    ;
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
      { 35      ;2   ;ActionGroup;
                      Name=IncomingDocument;
                      CaptionML=[DAN=IndgÜende bilag;
                                 ENU=Incoming Document];
                      ActionContainerType=NewDocumentItems;
                      Image=Documents }
      { 29      ;3   ;Action    ;
                      Name=IncomingDocCard;
                      CaptionML=[DAN=Vis indgÜende bilag;
                                 ENU=View Incoming Document];
                      ToolTipML=[DAN=Se alle indgÜende bilagsrecords og vedhëftede filer, der findes for posten eller bilaget.;
                                 ENU=View any incoming document records and file attachments that exist for the entry or document.];
                      ApplicationArea=#Advanced;
                      Enabled=HasIncomingDocument;
                      Image=ViewOrder;
                      OnAction=VAR
                                 IncomingDocument@1000 : Record 130;
                               BEGIN
                                 IncomingDocument.ShowCardFromEntryNo("Incoming Document Entry No.");
                               END;
                                }
      { 23      ;3   ;Action    ;
                      Name=SelectIncomingDoc;
                      AccessByPermission=TableData 130=R;
                      CaptionML=[DAN=Vëlg indgÜende bilag;
                                 ENU=Select Incoming Document];
                      ToolTipML=[DAN=Vëlg en indgÜende bilagsrecord og vedhëftet fil, der skal knyttes til posten eller dokumentet.;
                                 ENU=Select an incoming document record and file attachment that you want to link to the entry or document.];
                      ApplicationArea=#Advanced;
                      Image=SelectLineToApply;
                      OnAction=VAR
                                 IncomingDocument@1000 : Record 130;
                               BEGIN
                                 VALIDATE("Incoming Document Entry No.",IncomingDocument.SelectIncomingDocument("Incoming Document Entry No.",RECORDID));
                               END;
                                }
      { 33      ;3   ;Action    ;
                      Name=IncomingDocAttachFile;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Opret indgÜende bilag ud fra fil;
                                 ENU=Create Incoming Document from File];
                      ToolTipML=[DAN=Opret en indgÜende bilagsrecord ved at vëlge en fil, der skal vedhëftes, og knyt derefter den indgÜende bilagsrecord til posten eller bilaget.;
                                 ENU=Create an incoming document record by selecting a file to attach, and then link the incoming document record to the entry or document.];
                      ApplicationArea=#Advanced;
                      Enabled=NOT HasIncomingDocument;
                      Image=Attach;
                      OnAction=VAR
                                 IncomingDocumentAttachment@1000 : Record 133;
                               BEGIN
                                 IncomingDocumentAttachment.NewAttachmentFromSalesDocument(Rec);
                               END;
                                }
      { 31      ;3   ;Action    ;
                      Name=RemoveIncomingDoc;
                      CaptionML=[DAN=Fjern indgÜende bilag;
                                 ENU=Remove Incoming Document];
                      ToolTipML=[DAN=Fjern eventuelle indgÜende bilagsrecords og vedhëftede filer.;
                                 ENU=Remove any incoming document records and file attachments.];
                      ApplicationArea=#Advanced;
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

    { 83  ;2   ;Field     ;
                CaptionML=[DAN=Debitornr.;
                           ENU=Customer No.];
                ToolTipML=[DAN=Angiver nummeret pÜ den debitor, der modtager produkterne og faktureres som standard.;
                           ENU=Specifies the number of the customer who will receive the products and be billed by default.];
                ApplicationArea=#All;
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
                ToolTipML=[DAN=Angiver navnet pÜ den debitor, der som standard modtager produkterne og faktureres.;
                           ENU=Specifies the name of the customer who will receive the products and be billed by default.];
                ApplicationArea=#All;
                NotBlank=Yes;
                SourceExpr="Sell-to Customer Name";
                Importance=Promoted;
                OnValidate=VAR
                             ApplicationAreaSetup@1001 : Record 9178;
                           BEGIN
                             SelltoCustomerNoOnAfterValidate(Rec,xRec);
                             CurrPage.UPDATE;

                             IF ApplicationAreaSetup.IsFoundationEnabled THEN
                               SalesCalcDiscByType.ApplyDefaultInvoiceDiscount(0,Rec);
                           END;

                ShowMandatory=TRUE }

    { 39  ;2   ;Group     ;
                CaptionML=[DAN=Kunde;
                           ENU=Sell-to];
                GroupType=Group }

    { 71  ;3   ;Field     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                ToolTipML=[DAN=Angiver adressen pÜ debitorens lokalitet.;
                           ENU=Specifies the address where the customer is located.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Address";
                Importance=Additional }

    { 73  ;3   ;Field     ;
                CaptionML=[DAN=Adresse 2;
                           ENU=Address 2];
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Address 2";
                Importance=Additional }

    { 77  ;3   ;Field     ;
                CaptionML=[DAN=Postnr.;
                           ENU=Post Code];
                ToolTipML=[DAN=Angiver postnummer.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Post Code";
                Importance=Additional }

    { 74  ;3   ;Field     ;
                CaptionML=[DAN=By;
                           ENU=City];
                ToolTipML=[DAN=Angiver debitorens by pÜ salgsdokumentet.;
                           ENU=Specifies the city of the customer on the sales document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to City";
                Importance=Additional }

    { 120 ;3   ;Field     ;
                CaptionML=[DAN=Kontaktnr.;
                           ENU=Contact No.];
                ToolTipML=[DAN=Angiver nummeret pÜ den kontakt, som salgsdokumentet sendes til.;
                           ENU=Specifies the number of the contact that the sales document will be sent to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Contact No.";
                Importance=Additional;
                OnValidate=BEGIN
                             ClearSellToFilter;
                             ActivateFields;
                             CurrPage.UPDATE
                           END;
                            }

    { 8   ;2   ;Field     ;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                ToolTipML=[DAN=Angiver navnet pÜ personen, der kan kontaktes i debitorens virksomhed.;
                           ENU=Specifies the name of the person to contact at the customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Contact";
                Editable="Sell-to Customer No." <> '' }

    { 183 ;2   ;Field     ;
                CaptionML=[DAN=Debitorskabelonkode;
                           ENU=Customer Template Code];
                ToolTipML=[DAN=Angiver koden for skabelonen til at oprette en ny debitor.;
                           ENU=Specifies the code for the template to create a new customer];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Customer Template Code";
                Importance=Additional;
                Enabled=EnableSellToCustomerTemplateCode;
                OnValidate=BEGIN
                             ActivateFields;
                             CurrPage.UPDATE;
                           END;
                            }

    { 163 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange arkiverede versioner der findes af dette bilag.;
                           ENU=Specifies the number of archived versions for this document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No. of Archived Versions";
                Importance=Additional;
                OnDrillDown=BEGIN
                              CurrPage.SAVERECORD;
                              COMMIT;
                              SalesHeaderArchive.SETRANGE("Document Type","Document Type"::Quote);
                              SalesHeaderArchive.SETRANGE("No.","No.");
                              SalesHeaderArchive.SETRANGE("Doc. No. Occurrence","Doc. No. Occurrence");
                              IF SalesHeaderArchive.GET("Document Type"::Quote,"No.","Doc. No. Occurrence","No. of Archived Versions") THEN ;
                              PAGE.RUNMODAL(PAGE::"Sales List Archive",SalesHeaderArchive);
                              CurrPage.UPDATE(FALSE);
                            END;
                             }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor den relaterede ordre blev oprettet.;
                           ENU=Specifies the date when the related order was created.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Order Date";
                Importance=Additional;
                QuickEntry=FALSE }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Date";
                Importance=Additional }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvornÜr den relaterede salgsfaktura skal betales.;
                           ENU=Specifies when the related sales invoice must be paid.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Due Date";
                Importance=Promoted }

    { 118 ;2   ;Field     ;
                ToolTipML=[DAN=Indeholder den dato, hvor debitoren har õnsket varerne leveret.;
                           ENU=Specifies the date that the customer has asked for the order to be delivered.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Requested Delivery Date" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ den sëlger, der er tildelt til debitoren.;
                           ENU=Specifies the name of the salesperson who is assigned to the customer.];
                ApplicationArea=#Suite;
                SourceExpr="Salesperson Code";
                Importance=Additional;
                OnValidate=BEGIN
                             CurrPage.SalesLines.PAGE.UpdateForm(TRUE)
                           END;
                            }

    { 103 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den kampagne, som bilaget er tilknyttet.;
                           ENU=Specifies the number of the campaign that the document is linked to.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Campaign No.";
                Importance=Additional;
                QuickEntry=FALSE }

    { 170 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den salgsmulighed, som salgstilbuddet er tildelt.;
                           ENU=Specifies the number of the opportunity that the sales quote is assigned to.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Opportunity No.";
                Importance=Additional;
                QuickEntry=FALSE }

    { 108 ;2   ;Field     ;
                AccessByPermission=TableData 5714=R;
                ToolTipML=[DAN=Angiver den kode for ansvarscenteret (f.eks. et distributionscenter), som er tildelt den involverede bruger, virksomhed, debitor eller kreditor.;
                           ENU=Specifies the code of the responsibility center, such as a distribution hub, that is associated with the involved user, company, customer, or vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Responsibility Center";
                Importance=Additional }

    { 192 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der er ansvarlig for bilaget.;
                           ENU=Specifies the ID of the user who is responsible for the document.];
                ApplicationArea=#Advanced;
                SourceExpr="Assigned User ID";
                Importance=Additional }

    { 106 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om dokumentet er Übent, venter pÜ godkendelse, er faktureret til forudbetaling eller er frigivet til nëste fase i behandlingen.;
                           ENU=Specifies whether the document is open, waiting to be approved, has been invoiced for prepayment, or has been released to the next stage of processing.];
                ApplicationArea=#Suite;
                SourceExpr=Status;
                Importance=Additional }

    { 55  ;2   ;Group     ;
                CaptionML=[DAN=Arbejdsbeskrivelse;
                           ENU=Work Description];
                GroupType=Group }

    { 57  ;3   ;Field     ;
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

    { 58  ;1   ;Part      ;
                Name=SalesLines;
                ApplicationArea=#Basic,#Suite;
                SubPageLink=Document No.=FIELD(No.);
                PagePartID=Page95;
                Enabled=("Sell-to Customer No." <> '') OR ("Sell-to Customer Template Code" <> '') OR ("Sell-to Contact No." <> '');
                Editable=("Sell-to Customer No." <> '') OR ("Sell-to Customer Template Code" <> '') OR ("Sell-to Contact No." <> '');
                UpdatePropagation=Both }

    { 1905885101;1;Group  ;
                CaptionML=[DAN=Fakturadetaljer;
                           ENU=Invoice Details];
                GroupType=Group }

    { 97  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver valutaen for belõbene i salgsdokumentet.;
                           ENU=Specifies the currency of amounts on the sales document.];
                ApplicationArea=#Suite;
                SourceExpr="Currency Code";
                Importance=Promoted;
                OnValidate=BEGIN
                             CurrPage.SAVERECORD;
                             SalesCalcDiscByType.ApplyDefaultInvoiceDiscount(0,Rec);
                           END;

                OnAssistEdit=BEGIN
                               CLEAR(ChangeExchangeRate);
                               ChangeExchangeRate.SetParameter("Currency Code","Currency Factor",WORKDATE);
                               IF ChangeExchangeRate.RUNMODAL = ACTION::OK THEN BEGIN
                                 VALIDATE("Currency Factor",ChangeExchangeRate.GetParameter);
                                 CurrPage.UPDATE;
                               END;
                               CLEAR(ChangeExchangeRate);
                             END;
                              }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvornÜr varerne pÜ bilaget er sendt eller leveret. En afsendelsesdato beregnes normalt ud fra en õnsket leveringsdato plus leveringstiden.;
                           ENU=Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Shipment Date";
                Importance=Promoted }

    { 113 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om felterne Enhedspris og Linjebelõb pÜ bilagslinjer skal vises med eller uden moms.;
                           ENU=Specifies if the Unit Price and Line Amount fields on document lines should be shown with or without VAT.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Prices Including VAT";
                OnValidate=BEGIN
                             CurrPage.UPDATE
                           END;
                            }

    { 187 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede debitors eller kreditors momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogfõringsopsëtning.;
                           ENU=Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Bus. Posting Group";
                OnValidate=VAR
                             TempApplicationAreaSetup@1000 : TEMPORARY Record 9178;
                           BEGIN
                             IF TempApplicationAreaSetup.IsFoundationEnabled THEN
                               SalesCalcDiscByType.ApplyDefaultInvoiceDiscount(0,Rec);
                           END;
                            }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en formel, der beregner betalingens forfaldsdato, kontantrabatdato og kontantrabatbelõb.;
                           ENU=Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Terms Code";
                Importance=Promoted }

    { 90  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan betalingen skal foretages, f.eks. via bankoverfõrsel, kontant eller med check.;
                           ENU=Specifies how to make payment, such as with bank transfer, cash,  or check.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Method Code";
                Importance=Additional }

    { 47  ;2   ;Group     ;
                Visible=PaymentServiceVisible;
                GroupType=Group }

    { 18  ;3   ;Field     ;
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

    { 80  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 1 Code";
                OnValidate=BEGIN
                             CurrPage.UPDATE
                           END;
                            }

    { 84  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 2 Code";
                OnValidate=BEGIN
                             CurrPage.UPDATE
                           END;
                            }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den rabatprocent, der tildeles, hvis debitoren betaler pÜ eller fõr den dato, der er angivet i feltet Kont.rabatdato. Rabatprocenten er angivet i feltet Betalingsbetingelseskode.;
                           ENU=Specifies the payment discount percentage that is granted if the customer pays on or before the date entered in the Pmt. Discount Date field. The discount percentage is specified in the Payment Terms Code field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Discount %" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor belõbet i posten skal vëre betalt, for at der kan opnÜs kontantrabat.;
                           ENU=Specifies the date on which the amount in the entry must be paid for a payment discount to be granted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pmt. Discount Date";
                Importance=Additional }

    { 86  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver placeringen, hvor lagervarer til debitoren pÜ salgsbilaget skal sendes som standard.;
                           ENU=Specifies the location from where inventory items to the customer on the sales document are to be shipped by default.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Importance=Additional }

    { 67  ;1   ;Group     ;
                CaptionML=[DAN=Forsendelse og fakturering;
                           ENU=Shipping and Billing];
                GroupType=Group }

    { 60  ;2   ;Group     ;
                GroupType=Group }

    { 53  ;3   ;Group     ;
                GroupType=Group }

    { 70  ;4   ;Field     ;
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

    { 72  ;4   ;Group     ;
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
                ToolTipML=[DAN=Angiver den adresse, som produkter i salgsdokumentet skal leveres til. Som standard udfyldes feltet med vërdien i feltet Adresse pÜ debitorkortet eller med vërdien i feltet Adresse i vinduet Leveringsadresse.;
                           ENU=Specifies the address that products on the sales document will be shipped to. By default, the field is filled with the value in the Address field on the customer card or with the value in the Address field in the Ship-to Address window.];
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

    { 95  ;5   ;Field     ;
                CaptionML=[DAN=Postnr.;
                           ENU=Post Code];
                ToolTipML=[DAN=Angiver postnummer.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Post Code";
                Editable=ShipToOptions = ShipToOptions::"Custom Address" }

    { 93  ;5   ;Field     ;
                CaptionML=[DAN=By;
                           ENU=City];
                ToolTipML=[DAN=Angiver debitorens by pÜ salgsdokumentet.;
                           ENU=Specifies the city of the customer on the sales document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to City";
                Editable=ShipToOptions = ShipToOptions::"Custom Address" }

    { 43  ;5   ;Field     ;
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

    { 79  ;3   ;Group     ;
                CaptionML=[DAN=Leveringsform;
                           ENU=Shipment Method];
                GroupType=Group }

    { 78  ;4   ;Field     ;
                CaptionML=[DAN=Kode;
                           ENU=Code];
                ToolTipML=[DAN=Angiver, hvordan varer i salgsbilaget sendes til debitoren.;
                           ENU=Specifies how items on the sales document are shipped to the customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Shipment Method Code";
                Importance=Additional }

    { 76  ;4   ;Field     ;
                CaptionML=[DAN=Speditõr;
                           ENU=Agent];
                ToolTipML=[DAN=Angiver, hvilken speditõr der bruges til at transportere varerne pÜ salgsbilaget til debitoren.;
                           ENU=Specifies which shipping agent is used to transport the items on the sales document to the customer.];
                ApplicationArea=#Suite;
                SourceExpr="Shipping Agent Code";
                Importance=Additional }

    { 75  ;4   ;Field     ;
                CaptionML=[DAN=Speditõrservice;
                           ENU=Agent service];
                ToolTipML=[DAN=Angiver, hvilken speditõrservice der bruges til at transportere varerne pÜ salgsbilaget til debitoren.;
                           ENU=Specifies which shipping agent service is used to transport the items on the sales document to the customer.];
                ApplicationArea=#Suite;
                SourceExpr="Shipping Agent Service Code";
                Importance=Additional }

    { 51  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver speditõrens pakkenummer.;
                           ENU=Specifies the shipping agent's package number.];
                ApplicationArea=#Suite;
                SourceExpr="Package Tracking No.";
                Importance=Additional }

    { 49  ;2   ;Group     ;
                Enabled=NOT EnableSellToCustomerTemplateCode;
                GroupType=Group }

    { 48  ;3   ;Field     ;
                Name=BillToOptions;
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

    { 41  ;3   ;Group     ;
                Visible=BillToOptions = BillToOptions::"Another Customer";
                GroupType=Group }

    { 16  ;3   ;Field     ;
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver den debitor, du vil sende salgsfakturaen til, nÜr det er til en anden debitor end den, du sëlger til.;
                           ENU=Specifies the customer to whom you will send the sales invoice, when different from the customer that you are selling to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bill-to Name";
                Importance=Promoted;
                Enabled=EnableBillToCustomerNo;
                OnValidate=VAR
                             ApplicationAreaSetup@1000 : Record 9178;
                           BEGIN
                             IF GETFILTER("Bill-to Customer No.") = xRec."Bill-to Customer No." THEN
                               IF "Bill-to Customer No." <> xRec."Bill-to Customer No." THEN
                                 SETRANGE("Bill-to Customer No.");

                             IF ApplicationAreaSetup.IsFoundationEnabled THEN
                               SalesCalcDiscByType.ApplyDefaultInvoiceDiscount(0,Rec);

                             CurrPage.UPDATE;
                           END;
                            }

    { 20  ;3   ;Field     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                ToolTipML=[DAN=Angiver debitorens adresse, som du vil sende fakturaen til.;
                           ENU=Specifies the address of the customer that you will send the invoice to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bill-to Address";
                Importance=Additional;
                Enabled="Bill-to Customer No." <> "Sell-to Customer No.";
                Editable="Bill-to Customer No." <> "Sell-to Customer No." }

    { 22  ;3   ;Field     ;
                CaptionML=[DAN=Adresse 2;
                           ENU=Address 2];
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bill-to Address 2";
                Importance=Additional;
                Enabled="Bill-to Customer No." <> "Sell-to Customer No.";
                Editable="Bill-to Customer No." <> "Sell-to Customer No." }

    { 91  ;3   ;Field     ;
                CaptionML=[DAN=Postnr.;
                           ENU=Post Code];
                ToolTipML=[DAN=Angiver postnummer.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bill-to Post Code";
                Importance=Additional;
                Enabled="Bill-to Customer No." <> "Sell-to Customer No.";
                Editable="Bill-to Customer No." <> "Sell-to Customer No." }

    { 89  ;3   ;Field     ;
                CaptionML=[DAN=By;
                           ENU=City];
                ToolTipML=[DAN=Angiver debitorens by pÜ salgsdokumentet.;
                           ENU=Specifies the city of the customer on the sales document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bill-to City";
                Importance=Additional;
                Enabled="Bill-to Customer No." <> "Sell-to Customer No.";
                Editable="Bill-to Customer No." <> "Sell-to Customer No." }

    { 122 ;3   ;Field     ;
                CaptionML=[DAN=Kontaktnr.;
                           ENU=Contact No.];
                ToolTipML=[DAN=Angiver nummeret pÜ den kontakt, som fakturaen skal sendes til.;
                           ENU=Specifies the number of the contact the invoice will be sent to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bill-to Contact No.";
                Importance=Additional;
                Enabled="Bill-to Customer No." <> "Sell-to Customer No.";
                Editable="Bill-to Customer No." <> "Sell-to Customer No." }

    { 26  ;3   ;Field     ;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                ToolTipML=[DAN=Angiver navnet pÜ den kontaktperson, du kan kontakte hos den debitor, som fakturaen bliver sendt til.;
                           ENU=Specifies the name of the person you should contact at the customer who you are sending the invoice to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bill-to Contact";
                Enabled="Bill-to Customer No." <> "Sell-to Customer No.";
                Editable="Bill-to Customer No." <> "Sell-to Customer No." }

    { 1907468901;1;Group  ;
                CaptionML=[DAN=Udenrigshandel;
                           ENU=Foreign Trade] }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om transaktionen er relateret til handel med tredjepart i EU.;
                           ENU=Specifies if the transaction is related to trade with a third party within the EU.];
                ApplicationArea=#Advanced;
                SourceExpr="EU 3-Party Trade" }

    { 81  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en specifikation af bilagets transaktion med henblik pÜ rapportering til INTRASTAT.;
                           ENU=Specifies a specification of the document's transaction, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Transaction Specification" }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver transportmÜden ved rapportering til INTRASTAT.;
                           ENU=Specifies the transport method, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Transport Method" }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det udfõrselssted, hvor varerne blev udfõrt af landet/omrÜdet med henblik pÜ rapportering til Intrastat.;
                           ENU=Specifies the point of exit through which you ship the items out of your country/region, for reporting to Intrastat.];
                ApplicationArea=#Advanced;
                SourceExpr="Exit Point" }

    { 45  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitors eller kreditors omrÜde med henblik pÜ rapportering til INTRASTAT.;
                           ENU=Specifies the area of the customer or vendor, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr=Area }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 24  ;1   ;Part      ;
                Name=IncomingDocAttachFactBox;
                ApplicationArea=#Advanced;
                PagePartID=Page193;
                Visible=FALSE;
                PartType=Page;
                ShowFilter=No }

    { 11  ;1   ;Part      ;
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
                Visible=FALSE;
                PartType=Page }

    { 1900316107;1;Part   ;
                ApplicationArea=#Advanced;
                SubPageLink=No.=FIELD(Sell-to Customer No.);
                PagePartID=Page9084;
                Visible=FALSE;
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
                Visible=FALSE;
                PartType=Page }

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
                ProviderID=58;
                Visible=FALSE;
                PartType=Page }

    { 27  ;1   ;Part      ;
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
      SalesHeaderArchive@1006 : Record 5107;
      CopySalesDoc@1003 : Report 292;
      DocPrint@1004 : Codeunit 229;
      UserMgt@1005 : Codeunit 5700;
      ArchiveManagement@1007 : Codeunit 5063;
      SalesCalcDiscByType@1008 : Codeunit 56;
      CustomerMgt@1032 : Codeunit 1302;
      ChangeExchangeRate@1002 : Page 511;
      EnableBillToCustomerNo@6785 : Boolean INDATASET;
      EnableSellToCustomerTemplateCode@1021 : Boolean;
      HasIncomingDocument@1010 : Boolean;
      DocNoVisible@1001 : Boolean;
      OpenApprovalEntriesExistForCurrUser@1014 : Boolean;
      OpenApprovalEntriesExist@1013 : Boolean;
      ShowWorkflowStatus@1009 : Boolean;
      IsOfficeAddin@1000 : Boolean;
      CanCancelApprovalForRecord@1011 : Boolean;
      PaymentServiceVisible@1016 : Boolean;
      PaymentServiceEnabled@1015 : Boolean;
      IsCustomerOrContactNotEmpty@1022 : Boolean;
      WorkDescription@1017 : Text;
      ShipToOptions@1019 : 'Default (Sell-to Address),Alternate Shipping Address,Custom Address';
      BillToOptions@1018 : 'Default (Customer),Another Customer';
      EmptyShipToCodeErr@1020 : TextConst 'DAN=Kodefeltet mÜ kun vëre tomt, hvis du vëlger Brugerdefineret adresse i feltet Leveres til.;ENU=The Code field can only be empty if you select Custom Address in the Ship-to field.';
      CanRequestApprovalForFlow@1023 : Boolean;
      CanCancelApprovalForFlow@1012 : Boolean;
      IsSaaS@1025 : Boolean;

    LOCAL PROCEDURE ActivateFields@2();
    BEGIN
      EnableBillToCustomerNo := "Bill-to Customer Template Code" = '';
      EnableSellToCustomerTemplateCode := "Sell-to Customer No." = '';
    END;

    LOCAL PROCEDURE ApproveCalcInvDisc@3();
    BEGIN
      CurrPage.SalesLines.PAGE.ApproveCalcInvDisc;
    END;

    LOCAL PROCEDURE ClearSellToFilter@1100();
    BEGIN
      IF GETFILTER("Sell-to Customer No.") = xRec."Sell-to Customer No." THEN
        IF "Sell-to Customer No." <> xRec."Sell-to Customer No." THEN
          SETRANGE("Sell-to Customer No.");
      IF GETFILTER("Sell-to Contact No.") = xRec."Sell-to Contact No." THEN
        IF "Sell-to Contact No." <> xRec."Sell-to Contact No." THEN
          SETRANGE("Sell-to Contact No.");
    END;

    LOCAL PROCEDURE SetDocNoVisible@4();
    VAR
      DocumentNoVisibility@1000 : Codeunit 1400;
      DocType@1003 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Reminder,FinChMemo';
    BEGIN
      DocNoVisible := DocumentNoVisibility.SalesDocumentNoIsVisible(DocType::Quote,"No.");
    END;

    LOCAL PROCEDURE SetControlAppearance@5();
    VAR
      ApprovalsMgmt@1002 : Codeunit 1535;
      WorkflowWebhookMgt@1000 : Codeunit 1543;
    BEGIN
      HasIncomingDocument := "Incoming Document Entry No." <> 0;

      OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RECORDID);
      OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);
      CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RECORDID);
      IsCustomerOrContactNotEmpty := ("Sell-to Customer No." <> '') OR ("Sell-to Contact No." <> '');

      WorkflowWebhookMgt.GetCanRequestAndCanCancel(RECORDID,CanRequestApprovalForFlow,CanCancelApprovalForFlow);
    END;

    LOCAL PROCEDURE CheckSalesCheckAllLinesHaveQuantityAssigned@6();
    VAR
      ApplicationAreaSetup@1000 : Record 9178;
      LinesInstructionMgt@1001 : Codeunit 1320;
    BEGIN
      IF ApplicationAreaSetup.IsFoundationEnabled THEN
        LinesInstructionMgt.SalesCheckAllLinesHaveQuantityAssigned(Rec);
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
    LOCAL PROCEDURE OnBeforeStatisticsAction@7(VAR SalesHeader@1000 : Record 36;VAR Handled@1001 : Boolean);
    BEGIN
    END;

    BEGIN
    END.
  }
}

