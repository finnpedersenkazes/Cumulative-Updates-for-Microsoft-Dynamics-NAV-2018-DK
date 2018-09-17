OBJECT Page 189 Incoming Document
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=IndgÜende bilag;
               ENU=Incoming Document];
    SourceTable=Table130;
    PageType=Document;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Frigiv,Status,IndgÜende bilag,OCR,Godkend,Anmod om godkendelse;
                                ENU=New,Process,Report,Release,Status,Incoming Document,OCR,Approve,Request Approval];
    OnInit=BEGIN
             IsDataExchTypeEditable := TRUE;
             EnableReceiveFromOCR := WaitingToReceiveFromOCR;
           END;

    OnOpenPage=VAR
                 FileManagement@1000 : Codeunit 419;
               BEGIN
                 IF FileManagement.CanRunDotNetOnClient THEN BEGIN
                   HasCamera := CameraProvider.IsAvailable;
                   IF HasCamera THEN
                     CameraProvider := CameraProvider.Create;
                 END;

                 UpdateOCRSetupVisibility;
               END;

    OnAfterGetRecord=BEGIN
                       URL := GetURL;
                       ShowErrors;
                       EnableReceiveFromOCR := WaitingToReceiveFromOCR;
                       CurrPage.EDITABLE(NOT Processed);
                     END;

    OnNewRecord=BEGIN
                  URL := '';
                END;

    OnInsertRecord=BEGIN
                     AttachEnabled := TRUE;
                   END;

    OnModifyRecord=VAR
                     IncomingDocumentAttachment@1000 : Record 133;
                   BEGIN
                     OCRDataCorrectionEnabled := GetGeneratedFromOCRAttachment(IncomingDocumentAttachment);
                     RecordHasAttachment := HasAttachment;
                   END;

    OnAfterGetCurrRecord=BEGIN
                           IsDataExchTypeEditable := NOT (Status IN [Status::Created,Status::Posted]);
                           ShowErrors;
                           SetCalculatedFields;
                           RecordHasAttachment := HasAttachment;
                           SetControlVisibility;
                           AttachEnabled := "Entry No." <> 0;
                         END;

    ActionList=ACTIONS
    {
      { 52      ;    ;ActionContainer;
                      CaptionML=[DAN=Ny;
                                 ENU=New];
                      ActionContainerType=NewDocumentItems }
      { 46      ;    ;ActionContainer;
                      CaptionML=[DAN=Relaterede oplysninger;
                                 ENU=Related Information];
                      ActionContainerType=RelatedInformation }
      { 57      ;1   ;ActionGroup;
                      CaptionML=[DAN=Opsëtning;
                                 ENU=Setup] }
      { 44      ;2   ;Action    ;
                      Name=Setup;
                      CaptionML=[DAN=Opsëtning;
                                 ENU=Setup];
                      ToolTipML=[DAN=Definer den finanskladdetype, der skal bruges til oprettelse af kladdelinjer. Du kan ogsÜ angive, om man skal have godkendelse for at oprette bilag og kladdelinjer.;
                                 ENU=Define the general journal type to use when creating journal lines. You can also specify whether it requires approval to create documents and journal lines.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 191;
                      Image=Setup }
      { 22      ;2   ;Action    ;
                      Name=DataExchangeTypes;
                      CaptionML=[DAN=Dataudvekslingstyper;
                                 ENU=Data Exchange Types];
                      ToolTipML=[DAN=FÜ vist de dataudvekslingstyper, der er tilgëngelige til konvertering af elektroniske dokumenter til dokumenter i Dynamics NAV.;
                                 ENU=View the data exchange types that are available to convert electronic documents to documents in Dynamics NAV.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 1213;
                      Promoted=Yes;
                      Image=Entries;
                      PromotedCategory=Category6 }
      { 73      ;2   ;Action    ;
                      Name=ActivityLog;
                      CaptionML=[DAN=Aktivitetslogfil;
                                 ENU=Activity Log];
                      ToolTipML=[DAN=Se status og eventuelle fejl, hvis dokumentet blev sendt som et elektronisk dokument eller OCR-fil via dokumentudvekslingstjenesten.;
                                 ENU=View the status and any errors if the document was sent as an electronic document or OCR file through the document exchange service.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Log;
                      OnAction=VAR
                                 ActivityLog@1002 : Record 710;
                               BEGIN
                                 ActivityLog.ShowEntries(RECORDID);
                               END;
                                }
      { 69      ;2   ;Action    ;
                      Name=OCRSetup;
                      CaptionML=[DAN=OCR-opsëtning;
                                 ENU=OCR Setup];
                      ToolTipML=[DAN=èbn vinduet Opsëtning af OCR-tjeneste for f.eks. at ëndre legitimationsoplysninger eller aktivere tjenesten.;
                                 ENU=Open the OCR Service Setup window, for example to change credentials or enable the service.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=ShowOCRSetup;
                      PromotedIsBig=Yes;
                      Image=ServiceSetup;
                      PromotedCategory=Category7;
                      OnAction=BEGIN
                                 PAGE.RUNMODAL(PAGE::"OCR Service Setup");
                                 CurrPage.UPDATE;
                                 IF ClientTypeManagement.GetCurrentClientType = CLIENTTYPE::Web THEN
                                   IF OCRIsEnabled THEN BEGIN
                                     OnCloseIncomingDocumentFromAction(Rec);
                                     CurrPage.CLOSE;
                                   END;
                               END;
                                }
      { 91      ;2   ;Action    ;
                      Name=ApprovalEntries;
                      AccessByPermission=TableData 454=R;
                      CaptionML=[DAN=Godkendelser;
                                 ENU=Approvals];
                      ToolTipML=[DAN=Se en liste over records, der afventer godkendelse, Du kan f.eks. se, hvem der har anmodet om godkendelse af recorden, hvornÜr den blev sendt, og hvornÜr den skal godkendes.;
                                 ENU=View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.];
                      ApplicationArea=#Suite;
                      Image=Approvals;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.OpenApprovalEntriesPage(RECORDID);
                               END;
                                }
      { 43      ;    ;ActionContainer;
                      CaptionML=[DAN=Proces;
                                 ENU=Process];
                      ActionContainerType=ActionItems }
      { 121     ;1   ;Action    ;
                      Name=CreateDocument;
                      CaptionML=[DAN=Opret dokument;
                                 ENU=Create Document];
                      ToolTipML=[DAN=Opret et dokument, f.eks. en kõbsfaktura, automatisk ved at konvertere det elektroniske dokument, som er vedhëftet den indgÜende bilagsrecord.;
                                 ENU=Create a document, such as a purchase invoice, automatically by converting the electronic document that is attached to the incoming document record.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=AutomaticCreationActionsAreEnabled;
                      PromotedIsBig=Yes;
                      Image=CreateDocument;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 "Created Doc. Error Msg. Type" := "Created Doc. Error Msg. Type"::Warning;
                                 MODIFY;
                                 CreateDocumentWithDataExchange;
                               END;
                                }
      { 31      ;1   ;Action    ;
                      Name=CreateGenJnlLine;
                      CaptionML=[DAN=Opret kladdelinje;
                                 ENU=Create Journal Line];
                      ToolTipML=[DAN=Opret et kladdelinje automatisk ved at konvertere det elektroniske dokument, som er vedhëftet den indgÜende bilagsrecord.;
                                 ENU=Create a journal line automatically by converting the electronic document that is attached to the incoming document record.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=AutomaticCreationActionsAreEnabled;
                      PromotedIsBig=Yes;
                      Image=TransferToGeneralJournal;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 CreateGeneralJournalLineWithDataExchange;
                               END;
                                }
      { 285     ;1   ;Action    ;
                      Name=CreateManually;
                      CaptionML=[DAN=Opret manuelt;
                                 ENU=Create Manually];
                      ToolTipML=[DAN=Opret et dokument, f.eks. en kõbsfaktura, manuelt fra oplysningerne i den fil, som er vedhëftet den indgÜende bilagsrecord.;
                                 ENU=Create a document, such as a purchase invoice, manually from information in the file that is attached to the incoming document record.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=CreateCreditMemo;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 IF NOT AskUserPermission THEN
                                   EXIT;

                                 CreateManually;
                               END;
                                }
      { 21      ;1   ;Action    ;
                      Name=AttachFile;
                      CaptionML=[DAN=Vedhëft fil;
                                 ENU=Attach File];
                      ToolTipML=[DAN=Vedhëft en fil til den indgÜende bilagsrecord.;
                                 ENU=Attach a file to the incoming document record.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Attach;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 ImportAttachment(Rec);
                                 CurrPage.UPDATE(TRUE);
                               END;
                                }
      { 85      ;1   ;Action    ;
                      Name=ReplaceMainAttachment;
                      CaptionML=[DAN=Erstat primër vedhëftet fil;
                                 ENU=Replace Main Attachment];
                      ToolTipML=[DAN=Vedhëft en anden fil, der skal bruges som primër vedhëftet fil pÜ den indgÜende bilagsrecord.;
                                 ENU=Attach another file to be used as the main file attachment on the incoming document record.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=ReplaceMainAttachmentEnabled;
                      Image=Interaction;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 ReplaceOrInsertMainAttachment;
                                 CLEAR("Data Exchange Type");
                               END;
                                }
      { 30      ;1   ;Action    ;
                      Name=AttachFromCamera;
                      CaptionML=[DAN=Vedhëft billede fra kamera;
                                 ENU=Attach Image from Camera];
                      ToolTipML=[DAN=Tilfõj et billede fra din enheds kamera, i dokumentet.;
                                 ENU=Add a picture from your device camera to the document.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Visible=HasCamera;
                      Enabled=AttachEnabled;
                      PromotedIsBig=Yes;
                      Image=Camera;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 CameraOptions@1000 : DotNet "'Microsoft.Dynamics.Nav.ClientExtensions, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.Capabilities.CameraOptions";
                               BEGIN
                                 IF NOT HasCamera THEN
                                   EXIT;
                                 CameraOptions := CameraOptions.CameraOptions;
                                 CameraOptions.Quality := 100; // 100%
                                 CameraProvider.RequestPictureAsync(CameraOptions);
                               END;
                                }
      { 64      ;1   ;Action    ;
                      Name=TextToAccountMapping;
                      CaptionML=[DAN=Knyt tekst til konto;
                                 ENU=Map Text to Account];
                      ToolTipML=[DAN=Opret en tilknytninger mellem tekst i indgÜende salgsbilag og identisk tekst i specifikke debet-, kredit- og modkonti i finansmodulet, eller pÜ bankkonti, sÜ det fërdige salgsdokument eller kladdelinjer pÜ forhÜnd er udfyldt med de angivne oplysninger.;
                                 ENU=Create a mapping of text on incoming documents to identical text on specific debit, credit, and balancing accounts in the general ledger or on bank accounts so that the resulting document or journal lines are prefilled with the specified information.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 1254;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=MapAccounts;
                      PromotedCategory=Process;
                      PromotedOnly=Yes }
      { 45      ;1   ;ActionGroup;
                      CaptionML=[DAN=Frigiv;
                                 ENU=Release] }
      { 12      ;2   ;Action    ;
                      Name=Release;
                      CaptionML=[DAN=Frigiv;
                                 ENU=Release];
                      ToolTipML=[DAN=Frigiv det indgÜende bilag for at indikere, at det er blevet godkendt af godkenderen af indgÜende bilag. Bemërk, at dette ikke har noget at gõre med godkendelsesworkflows.;
                                 ENU=Release the incoming document to indicate that it has been approved by the incoming document approver. Note that this is not related to approval workflows.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=RecordHasAttachment;
                      PromotedIsBig=Yes;
                      Image=Approve;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ReleaseIncomingDocument@1000 : Codeunit 132;
                               BEGIN
                                 ReleaseIncomingDocument.PerformManualRelease(Rec);
                               END;
                                }
      { 82      ;2   ;Action    ;
                      Name=Reopen;
                      CaptionML=[DAN=èbn igen;
                                 ENU=Reopen];
                      ToolTipML=[DAN=èbn den indgÜende bilagsrecord igen, efter at den er blevet godkendt af godkenderen af indgÜende bilag. Bemërk, at dette ikke har noget at gõre med godkendelsesworkflows.;
                                 ENU=Reopen the incoming document record after it has been approved by the incoming document approver. Note that this is not related to approval workflows.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=RecordHasAttachment;
                      PromotedIsBig=Yes;
                      Image=ReOpen;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ReleaseIncomingDocument@1000 : Codeunit 132;
                               BEGIN
                                 ReleaseIncomingDocument.PerformManualReopen(Rec);
                               END;
                                }
      { 9       ;2   ;Action    ;
                      Name=Reject;
                      CaptionML=[DAN=Afvis;
                                 ENU=Reject];
                      ToolTipML=[DAN=Afvis at godkende det indgÜende bilag. Bemërk, at dette ikke har noget at gõre med godkendelsesworkflows.;
                                 ENU=Reject to approve the incoming document. Note that this is not related to approval workflows.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=RecordHasAttachment;
                      PromotedIsBig=Yes;
                      Image=Reject;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ReleaseIncomingDocument@1000 : Codeunit 132;
                               BEGIN
                                 ReleaseIncomingDocument.PerformManualReject(Rec);
                               END;
                                }
      { 92      ;1   ;ActionGroup;
                      CaptionML=[DAN=Status;
                                 ENU=Status] }
      { 88      ;2   ;Action    ;
                      Name=SetToProcessed;
                      CaptionML=[DAN=Indstil til behandlet;
                                 ENU=Set To Processed];
                      ToolTipML=[DAN=Indstil det indgÜende bilag til behandlet. Det flyttes derefter til vinduet med behandlede, indgÜende bilag.;
                                 ENU=Set the incoming document to processed. It will then be moved to the Processed Incoming Documents window.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=NOT Processed;
                      PromotedIsBig=Yes;
                      Image=Archive;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 VALIDATE(Processed,TRUE);
                                 MODIFY(TRUE);
                               END;
                                }
      { 89      ;2   ;Action    ;
                      Name=SetToUnprocessed;
                      CaptionML=[DAN=Indstil til ikke-behandlet;
                                 ENU=Set To Unprocessed];
                      ToolTipML=[DAN=Indstil det indgÜende bilag til ikke-behandlet. PÜ denne mÜde kan du redigere oplysningerne eller udfõre handlinger i det indgÜende bilag.;
                                 ENU=Set the incoming document to unprocessed. This allows you to edit information or perform actions for the incoming document.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=Processed;
                      PromotedIsBig=Yes;
                      Image=ReOpen;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 VALIDATE(Processed,FALSE);
                                 MODIFY(TRUE);
                               END;
                                }
      { 74      ;1   ;ActionGroup;
                      CaptionML=[DAN=Godkendelse;
                                 ENU=Approval] }
      { 75      ;2   ;Action    ;
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
                      PromotedCategory=Category8;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 TestReadyForApproval;
                                 ApprovalsMgmt.ApproveRecordApprovalRequest(RECORDID);
                               END;
                                }
      { 76      ;2   ;Action    ;
                      Name=RejectApproval;
                      CaptionML=[DAN=Afvis;
                                 ENU=Reject];
                      ToolTipML=[DAN=Afvis at godkende det indgÜende bilag. Bemërk, at dette ikke har noget at gõre med godkendelsesworkflows.;
                                 ENU=Reject to approve the incoming document. Note that this is not related to approval workflows.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Visible=OpenApprovalEntriesExistForCurrUser;
                      PromotedIsBig=Yes;
                      Image=Reject;
                      PromotedCategory=Category8;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.RejectRecordApprovalRequest(RECORDID);
                               END;
                                }
      { 77      ;2   ;Action    ;
                      Name=Delegate;
                      CaptionML=[DAN=Uddeleger;
                                 ENU=Delegate];
                      ToolTipML=[DAN=Uddeleger godkendelsen til en stedfortrëdende godkender.;
                                 ENU=Delegate the approval to a substitute approver.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Visible=OpenApprovalEntriesExistForCurrUser;
                      Image=Delegate;
                      PromotedCategory=Category8;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.DelegateRecordApprovalRequest(RECORDID);
                               END;
                                }
      { 78      ;2   ;Action    ;
                      Name=Comment;
                      CaptionML=[DAN=Bemërkninger;
                                 ENU=Comments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Visible=OpenApprovalEntriesExistForCurrUser;
                      Image=ViewComments;
                      PromotedCategory=Category8;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.GetApprovalComment(Rec);
                               END;
                                }
      { 81      ;1   ;ActionGroup;
                      CaptionML=[DAN=Anmod om godkendelse;
                                 ENU=Request Approval];
                      Image=SendApprovalRequest }
      { 80      ;2   ;Action    ;
                      Name=SendApprovalRequest;
                      CaptionML=[DAN=Send godkendelsesan&modning;
                                 ENU=Send A&pproval Request];
                      ToolTipML=[DAN=Anmod om godkendelse af det indgÜende bilag. Du kan sende en godkendelsesanmodning som en del af et workflow, hvis det er konfigureret for din organisation.;
                                 ENU=Request approval of the incoming document. You can send an approval request as part of a workflow if this has been set up in your organization.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Enabled=NOT OpenApprovalEntriesExist;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category9;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ApprovalsMgmt@1001 : Codeunit 1535;
                               BEGIN
                                 TestReadyForApproval;
                                 IF ApprovalsMgmt.CheckIncomingDocApprovalsWorkflowEnabled(Rec) THEN
                                   ApprovalsMgmt.OnSendIncomingDocForApproval(Rec);
                               END;
                                }
      { 79      ;2   ;Action    ;
                      Name=CancelApprovalRequest;
                      CaptionML=[DAN=Annuller godk&endelsesanmodning;
                                 ENU=Cancel Approval Re&quest];
                      ToolTipML=[DAN=Annuller anmodning om godkendelse af det indgÜende bilag.;
                                 ENU=Cancel requesting approval of the incoming document.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Enabled=CanCancelApprovalForRecord;
                      Image=CancelApprovalRequest;
                      PromotedCategory=Category9;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ApprovalsMgmt@1001 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.OnCancelIncomingDocApprovalRequest(Rec);
                               END;
                                }
      { 66      ;1   ;ActionGroup;
                      CaptionML=[DAN=IndgÜende bilag;
                                 ENU=Incoming Document] }
      { 67      ;2   ;Action    ;
                      Name=OpenDocument;
                      CaptionML=[DAN=èbn record;
                                 ENU=Open Record];
                      ToolTipML=[DAN=èbn dokumentet, kladdelinjen eller posten, som det indgÜende bilag er tilknyttet.;
                                 ENU=Open the document, journal line, or entry that the incoming document is linked to.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=RecordLinkExists;
                      PromotedIsBig=Yes;
                      Image=ViewDetails;
                      PromotedCategory=Category6;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 ShowNAVRecord;
                               END;
                                }
      { 5       ;2   ;Action    ;
                      Name=RemoveReferencedRecord;
                      CaptionML=[DAN=Fjern reference til record;
                                 ENU=Remove Reference to Record];
                      ToolTipML=[DAN=Fjern tilknytningen fra det indgÜende bilag til et dokument, en kladdelinje eller en post.;
                                 ENU=Remove the link that exists from the incoming document to a document, journal line, or entry.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=RecordLinkExists;
                      PromotedIsBig=Yes;
                      Image=ClearLog;
                      PromotedCategory=Category6;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 RemoveReferencedRecords;
                               END;
                                }
      { 68      ;2   ;Action    ;
                      Name=Navigate;
                      CaptionML=[DAN=Naviger;
                                 ENU=Navigate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes til bilagsnummeret og bogfõringsdatoen pÜ den valgte post eller det valgte dokument.;
                                 ENU=Find all entries and documents that exist for the document number and posting date on the selected entry or document.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Navigate;
                      OnAction=VAR
                                 NavigatePage@1000 : Page 344;
                               BEGIN
                                 IF NOT Posted THEN
                                   ERROR(NoPostedDocumentsErr);
                                 NavigatePage.SetDoc("Posting Date","Document No.");
                                 NavigatePage.RUN;
                               END;
                                }
      { 51      ;2   ;ActionGroup;
                      CaptionML=[DAN=Record;
                                 ENU=Record];
                      Visible=FALSE;
                      Enabled=FALSE;
                      Image=Document }
      { 65      ;3   ;Action    ;
                      Name=Journal;
                      CaptionML=[DAN=Kladdelinje;
                                 ENU=Journal Line];
                      ToolTipML=[DAN=èbn den record, som det indgÜende bilag er tilknyttet.;
                                 ENU=Open the record that the incoming document is linked to.];
                      ApplicationArea=#Advanced;
                      Image=Journal;
                      OnAction=VAR
                                 GenJournalBatch@1001 : Record 232;
                                 GenJnlManagement@1002 : Codeunit 230;
                               BEGIN
                                 IF NOT AskUserPermission THEN
                                   EXIT;

                                 CreateGenJnlLine;
                                 IncomingDocumentsSetup.Fetch;
                                 GenJournalBatch.GET(IncomingDocumentsSetup."General Journal Template Name",IncomingDocumentsSetup."General Journal Batch Name");
                                 GenJnlManagement.TemplateSelectionFromBatch(GenJournalBatch);
                               END;
                                }
      { 49      ;3   ;Action    ;
                      Name=PurchaseInvoice;
                      CaptionML=[DAN=Kõbsfaktura;
                                 ENU=Purchase Invoice];
                      ToolTipML=[DAN=èbn den record, som det indgÜende bilag er tilknyttet.;
                                 ENU=Open the record that the incoming document is linked to.];
                      ApplicationArea=#Advanced;
                      Image=Purchase;
                      OnAction=BEGIN
                                 IF NOT AskUserPermission THEN
                                   EXIT;

                                 CreatePurchInvoice;
                               END;
                                }
      { 50      ;3   ;Action    ;
                      Name=PurchaseCreditMemo;
                      CaptionML=[DAN=Kõbskreditnota;
                                 ENU=Purchase Credit Memo];
                      ToolTipML=[DAN=èbn den record, som det indgÜende bilag er tilknyttet.;
                                 ENU=Open the record that the incoming document is linked to.];
                      ApplicationArea=#Advanced;
                      Image=CreditMemo;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF NOT AskUserPermission THEN
                                   EXIT;

                                 CreatePurchCreditMemo;
                               END;
                                }
      { 47      ;3   ;Action    ;
                      Name=SalesInvoice;
                      CaptionML=[DAN=Salgsfaktura;
                                 ENU=Sales Invoice];
                      ToolTipML=[DAN=èbn den record, som det indgÜende bilag er tilknyttet.;
                                 ENU=Open the record that the incoming document is linked to.];
                      ApplicationArea=#Advanced;
                      Image=Sales;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF NOT AskUserPermission THEN
                                   EXIT;

                                 CreateSalesInvoice;
                               END;
                                }
      { 48      ;3   ;Action    ;
                      Name=SalesCreditMemo;
                      CaptionML=[DAN=Salgskreditnota;
                                 ENU=Sales Credit Memo];
                      ToolTipML=[DAN=èbn den record, som det indgÜende bilag er tilknyttet.;
                                 ENU=Open the record that the incoming document is linked to.];
                      ApplicationArea=#Advanced;
                      Image=CreditMemo;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF NOT AskUserPermission THEN
                                   EXIT;

                                 CreateSalesCreditMemo;
                               END;
                                }
      { 59      ;1   ;ActionGroup;
                      CaptionML=[DAN=OCR;
                                 ENU=OCR] }
      { 42      ;2   ;Action    ;
                      Name=SendToJobQueue;
                      CaptionML=[DAN=Send til opgavekõ;
                                 ENU=Send to Job Queue];
                      ToolTipML=[DAN=Send den vedhëftede pdf- eller billedfil til OCR-tjenesten med opgavekõen i henhold til planen, forudsat at der ikke er nogen fejl.;
                                 ENU=Send the attached PDF or image file to the OCR service by the job queue according to the schedule, provided that no errors exist.];
                      ApplicationArea=#Basic,#Suite;
                      Visible=OCRServiceIsEnabled;
                      Enabled=RecordHasAttachment;
                      Image=Translation;
                      OnAction=BEGIN
                                 SendToJobQueue(TRUE);
                               END;
                                }
      { 56      ;2   ;Action    ;
                      Name=RemoveFromJobQueue;
                      CaptionML=[DAN=Fjern fra opgavekõ;
                                 ENU=Remove from Job Queue];
                      ToolTipML=[DAN=Fjern den planlagte behandling af denne record fra jobkõen.;
                                 ENU=Remove the scheduled processing of this record from the job queue.];
                      ApplicationArea=#Basic,#Suite;
                      Visible=OCRServiceIsEnabled;
                      Enabled=RecordHasAttachment;
                      Image=Translation;
                      OnAction=BEGIN
                                 RemoveFromJobQueue(TRUE);
                               END;
                                }
      { 54      ;2   ;Action    ;
                      Name=SendToOcr;
                      CaptionML=[DAN=Send til OCR-tjeneste;
                                 ENU=Send to OCR Service];
                      ToolTipML=[DAN=Send den vedhëftede pdf- eller billedfil til OCR-tjenesten med det samme.;
                                 ENU=Send the attached PDF or image file to the OCR service immediately.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=OCRServiceIsEnabled;
                      Enabled=CanBeSentToOCR;
                      PromotedIsBig=Yes;
                      Image=Translations;
                      PromotedCategory=Category7;
                      OnAction=BEGIN
                                 SendToOCR(TRUE);
                               END;
                                }
      { 55      ;2   ;Action    ;
                      Name=ReceiveFromOCR;
                      CaptionML=[DAN=Modtag fra OCR-tjeneste;
                                 ENU=Receive from OCR Service];
                      ToolTipML=[DAN=Hent alle elektroniske dokumenter, der er klar til modtagelse fra OCR-tjenesten.;
                                 ENU=Get any electronic documents that are ready to receive from the OCR service.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=OCRServiceIsEnabled;
                      Enabled=EnableReceiveFromOCR;
                      PromotedIsBig=Yes;
                      Image=Translations;
                      PromotedCategory=Category7;
                      OnAction=BEGIN
                                 RetrieveFromOCR(TRUE);
                               END;
                                }
      { 35      ;2   ;Action    ;
                      Name=CorrectOCRData;
                      CaptionML=[DAN=KorrigÇr OCR-data;
                                 ENU=Correct OCR Data];
                      ToolTipML=[DAN=èbn et vindue, hvor du kan indstille OCR-tjenesten til at fortolke data i pdf- og billedfiler, sÜ fremtidige dokumenter, som oprettes af OCR-tjenesten, er mere korrekte.;
                                 ENU=Open a window where you can teach the OCR service how to interpret data on PDF and image files so that future documents created by the OCR service are more correct.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 1272;
                      RunPageOnRec=Yes;
                      Promoted=Yes;
                      Visible=OCRServiceIsEnabled;
                      Enabled=OCRDataCorrectionEnabled;
                      PromotedIsBig=Yes;
                      Image=EditAttachment;
                      PromotedCategory=Category7 }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=General;
                CaptionML=[DAN=Generelt;
                           ENU=General];
                GroupType=Group }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af det indgÜende bilag. Du skal angive beskrivelsen manuelt.;
                           ENU=Specifies the description of the incoming document. You must enter the description manually.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description;
                Importance=Promoted }

    { 53  ;2   ;Field     ;
                Name=URL;
                ExtendedDatatype=URL;
                CaptionML=[DAN=Sammenkëd med dokument;
                           ENU=Link to Document];
                ToolTipML=[DAN=Angiver et link til den vedhëftede fil.;
                           ENU=Specifies a link to the attached file.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=URL;
                Importance=Additional;
                OnValidate=BEGIN
                             SetURL(URL);
                             CurrPage.UPDATE;
                           END;
                            }

    { 90  ;2   ;Field     ;
                Name=MainAttachment;
                CaptionML=[DAN=Primër vedhëftet fil;
                           ENU=Main Attachment];
                ToolTipML=[DAN=Angiver den primëre vedhëftede fil. Kun denne vedhëftede fil behandles af OCR og dokumentudvekslingstjenester.;
                           ENU=Specifies the main attachment. Only this attachment is processed by the OCR and document exchange services.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=AttachmentFileName;
                Enabled=RecordHasAttachment;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              MainAttachmentDrillDown;
                              CurrPage.UPDATE;
                            END;
                             }

    { 115 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken dataudvekslingstype, der bruges til at behandle det indgÜende bilag, nÜr det er et elektronisk dokument.;
                           ENU=Specifies the data exchange type that is used to process the incoming document when it is an electronic document.];
                ApplicationArea=#Advanced;
                SourceExpr="Data Exchange Type";
                Importance=Additional;
                Editable=IsDataExchTypeEditable;
                OnValidate=BEGIN
                             IF NOT DefaultAttachmentIsXML THEN
                               ERROR(InvalidTypeErr);
                           END;
                            }

    { 58  ;2   ;Field     ;
                Name=Record;
                CaptionML=[DAN=Record;
                           ENU=Record];
                ToolTipML=[DAN=Angiver record, dokument, kladdelinje eller post, der er knyttet til det indgÜende bilag.;
                           ENU=Specifies the record, document, journal line, or ledger entry, that is linked to the incoming document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=RecordLinkTxt;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              ShowNAVRecord;
                              CurrPage.UPDATE;
                            END;
                             }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen af det dokument eller den kladde, det indgÜende bilag kan forbindes med.;
                           ENU=Specifies the type of document or journal that the incoming document can be connected to.];
                ApplicationArea=#Advanced;
                SourceExpr="Document Type";
                Importance=Promoted;
                Visible=FALSE }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ det relaterede dokument eller den relaterede kladdelinje, som er oprettet for det indgÜende bilag.;
                           ENU=Specifies the number of the related document or journal line that is created for the incoming document.];
                ApplicationArea=#Advanced;
                SourceExpr="Document No.";
                Importance=Promoted;
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for den indgÜende bilagsrecord.;
                           ENU=Specifies the status of the incoming document record.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Status;
                Importance=Promoted }

    { 87  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for den indgÜende bilagsrecord, nÜr det er en del af OCR-processen.;
                           ENU=Specifies the status of the incoming document record when it takes part in the OCR process.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="OCR Status";
                OnDrillDown=VAR
                              OCRServiceSetup@1000 : Record 1270;
                              OCRServiceMgt@1001 : Codeunit 1294;
                            BEGIN
                              IF NOT OCRServiceSetup.ISEMPTY THEN
                                HYPERLINK(OCRServiceMgt.GetStatusHyperLink(Rec));
                            END;
                             }

    { 84  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for opgavekõposten, der behandler det indgÜende bilag.;
                           ENU=Specifies the status of the job queue entry that is processing the incoming document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Job Queue Status" }

    { 71  ;2   ;Group     ;
                GroupType=Group }

    { 29  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den dokumentskabelon, som du vil have OCR-tjenesteudbyderen til at bruge, nÜr den indgÜende bilagsfil konverteres til et elektronisk dokument. MarkÇr feltet for at vëlge en understõttet dokumentskabelon fra vinduet Opsëtning af OCR-tjeneste.;
                           ENU=Specifies the code of the document template that you want the OCR service provider to use when they convert the incoming-document file to an electronic document. Chose the field to pick a supported document template from the OCR Service Setup window.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="OCR Service Doc. Template Code";
                Importance=Additional }

    { 41  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ den dokumentskabelon, som du vil have OCR-tjenesteudbyderen til at bruge, nÜr den indgÜende bilagsfil konverteres til et elektronisk dokument. MarkÇr feltet for at vëlge en understõttet dokumentskabelon fra vinduet Opsëtning af OCR-tjeneste.;
                           ENU=Specifies the name of the document template that you want the OCR service provider to use when they convert the incoming-document file to an electronic document. Chose the field to pick a supported document template from the OCR Service Setup window.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="OCR Service Doc. Template Name";
                Importance=Additional }

    { 40  ;3   ;Field     ;
                CaptionML=[DAN=OCR-resultat;
                           ENU=OCR Result];
                ToolTipML=[DAN=Angiver procestrinnet for den vedhëftede pdf- eller billedfil i forhold til OCR-tjenesten.;
                           ENU=Specifies what process stage the attached PDF or image file is in relation to the OCR service.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=OCRResultFileName;
                Importance=Additional;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              OCRResultDrillDown;
                              CurrPage.UPDATE;
                            END;
                             }

    { 72  ;2   ;Group     ;
                GroupType=Group }

    { 4   ;3   ;Field     ;
                ToolTipML=[DAN=Angiver, hvornÜr den indgÜende bilagslinje blev oprettet.;
                           ENU=Specifies when the incoming document line was created.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Created Date-Time";
                Importance=Additional }

    { 6   ;3   ;Field     ;
                ToolTipML=[DAN=Indeholder navnet pÜ den bruger, som oprettede den indgÜende bilagslinje.;
                           ENU=Specifies the name of the user who created the incoming document line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Created By User Name";
                Importance=Additional }

    { 7   ;3   ;Field     ;
                ToolTipML=[DAN=Angiver, om det indgÜende bilag er godkendt.;
                           ENU=Specifies if the incoming document has been approved.];
                ApplicationArea=#Advanced;
                SourceExpr=Released;
                Visible=FALSE }

    { 8   ;3   ;Field     ;
                ToolTipML=[DAN=Angiver, hvornÜr det indgÜende bilag blev godkendt.;
                           ENU=Specifies when the incoming document was approved.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Released Date-Time";
                Importance=Additional }

    { 10  ;3   ;Field     ;
                ToolTipML=[DAN=Indeholder navnet pÜ den bruger, som godkendte det indgÜende bilag.;
                           ENU=Specifies the name of the user who approved the incoming document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Released By User Name";
                Importance=Additional }

    { 11  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver, hvornÜr den indgÜende bilagslinje sidst blev ëndret.;
                           ENU=Specifies when the incoming document line was last modified.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Last Date-Time Modified";
                Importance=Additional }

    { 13  ;3   ;Field     ;
                ToolTipML=[DAN=Indeholder navnet pÜ den bruger, som sidst ëndrede den indgÜende bilagslinje.;
                           ENU=Specifies the name of the user who last modified the incoming document line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Last Modified By User Name";
                Importance=Additional }

    { 14  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver, om det dokument eller den kladdelinje, der blev oprettet til dette indgÜende bilag, er blevet bogfõrt.;
                           ENU=Specifies if the document or journal line that was created for this incoming document has been posted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Posted }

    { 15  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver, hvornÜr det relaterede dokument eller kladdelinjen blev bogfõrt.;
                           ENU=Specifies when the related document or journal line was posted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Posted Date-Time";
                Importance=Additional }

    { 18  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver, hvornÜr det dokument eller den kladdelinje, der er relateret til det indgÜende bilag, blev bogfõrt.;
                           ENU=Specifies when the document or journal line that relates to the incoming document was posted.];
                ApplicationArea=#Advanced;
                SourceExpr="Posting Date";
                Visible=FALSE }

    { 37  ;1   ;Part      ;
                Name=SupportingAttachments;
                CaptionML=[DAN=Supplerende vedhëftede filer;
                           ENU=Supporting Attachments];
                ApplicationArea=#All;
                PagePartID=Page194;
                Visible=AdditionalAttachmentsPresent;
                PartType=Page;
                ShowFilter=No }

    { 70  ;1   ;Group     ;
                Name=FinancialInformation;
                CaptionML=[DAN=Finansielle oplysninger;
                           ENU=Financial Information];
                GroupType=Group }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ kreditoren pÜ det indgÜende bilag. Feltet udfyldes muligvis automatisk.;
                           ENU=Specifies the name of the vendor on the incoming document. The field may be filled automatically.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Vendor Name";
                Importance=Promoted;
                Editable=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens momsnummer, hvis bilaget indeholder dette nummer. Feltet kan blive udfyldt automatisk.;
                           ENU=Specifies the VAT registration number of the vendor, if the document contains that number. The field may be filled automatically.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Vendor VAT Registration No.";
                Editable=FALSE }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver IBAN-nummeret for kreditoren pÜ det indgÜende bilag.;
                           ENU=Specifies the IBAN of the vendor on the incoming document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Vendor IBAN";
                Editable=FALSE }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bankregistreringsnummer for kreditoren pÜ det indgÜende bilag.;
                           ENU=Specifies the bank branch number of the vendor on the incoming document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Vendor Bank Branch No.";
                Editable=FALSE }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bankkontonummer for kreditoren pÜ det indgÜende bilag.;
                           ENU=Specifies the bank account number of the vendor on the incoming document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Vendor Bank Account No.";
                Editable=FALSE }

    { 86  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver telefonnummer til kreditoren pÜ det indgÜende bilag.;
                           ENU=Specifies the phone number of the vendor on the incoming document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Vendor Phone No.";
                Editable=FALSE }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bilagsnummeret for det oprindelige bilag, du modtog fra kreditoren. Du kan krëve bilagsnummeret til bogfõring, eller du kan lade det vëre valgfrit. Det er pÜkrëvet som standard, sÜ dette bilag refererer til originalen. Det fjerner et trin fra bogfõringsprocessen at gõre bilagsnumre valgfri. Hvis du f.eks. vedhëfter den oprindelige faktura som en PDF-fil, behõver du mÜske ikke at angive bilagsnummeret. I vinduet Kõbsopsëtning kan du vëlge, om bilagsnumre er pÜkrëvet ved at vëlge eller rydde markeringen i afkrydsningsfeltet Eksternt bilagsnr. obl.;
                           ENU=Specifies the document number of the original document you received from the vendor. You can require the document number for posting, or let it be optional. By default, it's required, so that this document references the original. Making document numbers optional removes a step from the posting process. For example, if you attach the original invoice as a PDF, you might not need to enter the document number. To specify whether document numbers are required, in the Purchases & Payables Setup window, select or clear the Ext. Doc. No. Mandatory field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Vendor Invoice No.";
                Editable=FALSE }

    { 33  ;2   ;Field     ;
                CaptionML=[DAN=Kreditors ordrenr.;
                           ENU=Vendor Order No.];
                ToolTipML=[DAN=Angiver ordrenummeret, hvis bilaget indeholder dette nummer. Feltet kan blive udfyldt automatisk.;
                           ENU=Specifies the order number, if the document contains that number. The field may be filled automatically.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Order No.";
                Editable=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, der fremgÜr af det indgÜende bilag. Det kan f.eks. vëre den dato, hvor kreditoren oprettede fakturaen. Feltet bliver muligvis udfyldt automatisk.;
                           ENU=Specifies the date that is printed on the incoming document. This is the date when the vendor created the invoice, for example. The field may be filled automatically.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Date";
                Importance=Promoted;
                Editable=FALSE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor kreditorbilaget skal vëre betalt. Feltet udfyldes muligvis automatisk.;
                           ENU=Specifies the date when the vendor document must be paid. The field may be filled automatically.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Due Date";
                Editable=FALSE }

    { 61  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver valutakoden, hvis bilaget indeholder denne kode. Feltet kan blive udfyldt automatisk.;
                           ENU=Specifies the currency code, if the document contains that code. The field may be filled automatically.];
                ApplicationArea=#Suite;
                SourceExpr="Currency Code";
                Editable=FALSE }

    { 62  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver belõb ekskl. moms for hele bilaget. Feltet udfyldes muligvis automatisk.;
                           ENU=Specifies the amount excluding VAT for the whole document. The field may be filled automatically.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Amount Excl. VAT";
                Editable=FALSE }

    { 63  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver belõb inkl. moms for hele bilaget. Feltet udfyldes muligvis automatisk.;
                           ENU=Specifies the amount including VAT for the whole document. The field may be filled automatically.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Amount Incl. VAT";
                Editable=FALSE }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver momsbelõbet, som er inkluderet i totalbelõbet.;
                           ENU=Specifies the amount of VAT that is included in the total amount.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Amount";
                Editable=FALSE }

    { 20  ;1   ;Part      ;
                Name=ErrorMessagesPart;
                CaptionML=[DAN=Fejl og advarsler;
                           ENU=Errors and Warnings];
                ApplicationArea=#Basic,#Suite;
                PagePartID=Page701;
                PartType=Page;
                ShowFilter=No }

    { 36  ;0   ;Container ;
                ContainerType=FactBoxArea }

    { 83  ;1   ;Part      ;
                Name=WorkflowStatus;
                ApplicationArea=#All;
                PagePartID=Page1528;
                Visible=ShowWorkflowStatus;
                Enabled=FALSE;
                Editable=FALSE;
                PartType=Page;
                ShowFilter=No }

    { 38  ;1   ;Part      ;
                PartType=System;
                SystemPartID=RecordLinks }

    { 39  ;1   ;Part      ;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      IncomingDocumentsSetup@1000 : Record 131;
      AutomaticProcessingQst@1004 : TextConst '@@@=%1 is Data Exchange Type;DAN=Feltet Dataudvekslingstype er udfyldt i mindst Çt af de valgte indgÜende bilag.\\Er du sikker pÜ, at du vil oprette bilag manuelt?;ENU=The Data Exchange Type field is filled on at least one of the selected Incoming Documents.\\Are you sure you want to create documents manually?';
      ClientTypeManagement@1025 : Codeunit 4;
      CameraProvider@1005 : DotNet "'Microsoft.Dynamics.Nav.ClientExtensions, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.Capabilities.CameraProvider" WITHEVENTS RUNONCLIENT;
      HasCamera@1001 : Boolean;
      URL@1003 : Text;
      AttachmentFileName@1008 : Text;
      RecordLinkTxt@1007 : Text;
      OCRResultFileName@1009 : Text;
      IsDataExchTypeEditable@1002 : Boolean;
      OCRDataCorrectionEnabled@1006 : Boolean;
      AdditionalAttachmentsPresent@1010 : Boolean;
      InvalidTypeErr@1013 : TextConst 'DAN=Den vedhëftede standardfil er ikke et XML-dokument.;ENU=The default attachment is not an XML document.';
      OpenApprovalEntriesExistForCurrUser@1012 : Boolean;
      OpenApprovalEntriesExist@1015 : Boolean;
      ShowWorkflowStatus@1014 : Boolean;
      EnableReceiveFromOCR@1011 : Boolean;
      CanCancelApprovalForRecord@1016 : Boolean;
      OCRServiceIsEnabled@1017 : Boolean;
      ShowOCRSetup@1018 : Boolean;
      AutomaticCreationActionsAreEnabled@1019 : Boolean;
      RecordHasAttachment@1020 : Boolean;
      RecordLinkExists@1021 : Boolean;
      NoPostedDocumentsErr@1022 : TextConst 'DAN=Der er ingen posterede bilag.;ENU=There are no posted documents.';
      CanBeSentToOCR@1023 : Boolean;
      AttachEnabled@1026 : Boolean;
      ReplaceMainAttachmentEnabled@1024 : Boolean;

    LOCAL PROCEDURE AskUserPermission@1() : Boolean;
    BEGIN
      IF "Data Exchange Type" = '' THEN
        EXIT(TRUE);

      IF Status <> Status::New THEN
        EXIT(TRUE);

      EXIT(CONFIRM(AutomaticProcessingQst));
    END;

    LOCAL PROCEDURE ShowErrors@2();
    VAR
      ErrorMessage@1001 : Record 700;
      TempErrorMessage@1000 : TEMPORARY Record 700;
    BEGIN
      ErrorMessage.SETRANGE("Context Record ID",RECORDID);
      ErrorMessage.CopyToTemp(TempErrorMessage);
      CurrPage.ErrorMessagesPart.PAGE.SetRecords(TempErrorMessage);
      CurrPage.ErrorMessagesPart.PAGE.UPDATE;
    END;

    LOCAL PROCEDURE SetCalculatedFields@6();
    VAR
      IncomingDocumentAttachment@1000 : Record 133;
    BEGIN
      OCRDataCorrectionEnabled := GetGeneratedFromOCRAttachment(IncomingDocumentAttachment);
      AttachmentFileName := GetMainAttachmentFileName;
      RecordLinkTxt := GetRecordLinkText;
      OCRResultFileName := GetOCRResutlFileName;
      AdditionalAttachmentsPresent := GetAdditionalAttachments(IncomingDocumentAttachment);
      IF AdditionalAttachmentsPresent THEN
        CurrPage.SupportingAttachments.PAGE.LoadDataIntoPart(Rec);
    END;

    LOCAL PROCEDURE SetControlVisibility@9();
    VAR
      ApprovalsMgmt@1000 : Codeunit 1535;
      RelatedRecord@1002 : Variant;
    BEGIN
      OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RECORDID);
      OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);
      ShowWorkflowStatus := CurrPage.WorkflowStatus.PAGE.SetFilterOnWorkflowRecord(RECORDID);
      CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RECORDID);
      UpdateOCRSetupVisibility;
      AutomaticCreationActionsAreEnabled := "Data Exchange Type" <> '';
      RecordLinkExists := GetNAVRecord(RelatedRecord);
      CanBeSentToOCR := VerifyCanBeSentToOCR;
      ReplaceMainAttachmentEnabled := CanReplaceMainAttachment;
    END;

    [Integration(TRUE,TRUE)]
    [External]
    LOCAL PROCEDURE OnCloseIncomingDocumentFromAction@3(VAR IncomingDocument@1000 : Record 130);
    BEGIN
    END;

    LOCAL PROCEDURE VerifyCanBeSentToOCR@4() : Boolean;
    BEGIN
      IF NOT RecordHasAttachment THEN
        EXIT(FALSE);

      EXIT(NOT ("OCR Status" IN
                ["OCR Status"::Sent,"OCR Status"::Success,"OCR Status"::"Awaiting Verification"]));
    END;

    LOCAL PROCEDURE UpdateOCRSetupVisibility@5();
    BEGIN
      OCRServiceIsEnabled := OCRIsEnabled;
      ShowOCRSetup := NOT OCRServiceIsEnabled;
    END;

    EVENT CameraProvider@1005::PictureAvailable@11(PictureName@1001 : Text;PictureFilePath@1000 : Text);
    BEGIN
      AddAttachmentFromServerFile(PictureName,PictureFilePath);
    END;

    BEGIN
    END.
  }
}

