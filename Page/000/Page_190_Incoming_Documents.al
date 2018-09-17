OBJECT Page 190 Incoming Documents
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=IndgÜende bilag;
               ENU=Incoming Documents];
    SourceTable=Table130;
    DataCaptionFields=Description;
    PageType=List;
    CardPageID=Incoming Document;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,RapportÇr,Frigiv,Status,Vis;
                                ENU=New,Process,Report,Release,Status,Show];
    OnOpenPage=BEGIN
                 IsDataExchTypeEditable := TRUE;
                 HasCamera := CameraProvider.IsAvailable;
                 IF HasCamera THEN
                   CameraProvider := CameraProvider.Create;
                 EnableReceiveFromOCR := WaitingToReceiveFromOCR;
                 UpdateOCRSetupVisibility;

                 FILTERGROUP(0);
                 SetProcessedDocumentsVisibility(GETFILTER(Processed) = FORMAT(TRUE));
               END;

    OnAfterGetRecord=BEGIN
                       URL := GetURL;
                       StatusStyleText := GetStatusStyleText;
                     END;

    OnNewRecord=BEGIN
                  URL := '';
                  StatusStyleText := GetStatusStyleText;
                END;

    OnAfterGetCurrRecord=BEGIN
                           IsDataExchTypeEditable := NOT (Status IN [Status::Created,Status::Posted]);
                           StatusStyleText := GetStatusStyleText;
                           SetControlVisibility;
                           CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromIncomingDocument(Rec);
                           SetToProcessedIsEnable := NOT Processed;
                         END;

    ActionList=ACTIONS
    {
      { 22      ;    ;ActionContainer;
                      CaptionML=[DAN=Ny;
                                 ENU=New];
                      ActionContainerType=NewDocumentItems }
      { 56      ;1   ;Action    ;
                      Name=CreateFromCamera;
                      CaptionML=[DAN=Opret fra kamera;
                                 ENU=Create from Camera];
                      ToolTipML=[DAN=Opret en ny indgÜende bilagsrecord ved at tage et billede.;
                                 ENU=Create a new incoming document record by taking a picture.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Visible=HasCamera;
                      PromotedIsBig=Yes;
                      Image=Camera;
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
      { 50      ;1   ;Action    ;
                      Name=CreateFromAttachment;
                      CaptionML=[DAN=Opret fra fil;
                                 ENU=Create from File];
                      ToolTipML=[DAN=Opret en ny indgÜende bilagsrecord ved fõrst at vëlge den fil, den er baseret pÜ. Den valgte fil vedhëftes.;
                                 ENU=Create a new incoming document record by first selecting the file it will be based on. The selected file will be attached.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ExportAttachment;
                      OnAction=BEGIN
                                 CreateFromAttachment;
                               END;
                                }
      { 33      ;    ;ActionContainer;
                      CaptionML=[DAN=Relaterede oplysninger;
                                 ENU=Related Information];
                      ActionContainerType=RelatedInformation }
      { 28      ;1   ;ActionGroup;
                      CaptionML=[DAN=Opsëtning;
                                 ENU=Setup] }
      { 32      ;2   ;Action    ;
                      Name=Setup;
                      CaptionML=[DAN=Konfiguration;
                                 ENU=Setup];
                      ToolTipML=[DAN=Definer den finanskladdetype, der skal bruges til oprettelse af kladdelinjer. Du kan ogsÜ angive, om man skal have godkendelse for at oprette bilag og kladdelinjer.;
                                 ENU=Define the general journal type to use when creating journal lines. You can also specify whether it requires approval to create documents and journal lines.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 191;
                      Image=Setup;
                      PromotedCategory=Category5 }
      { 42      ;2   ;Action    ;
                      Name=DataExchangeTypes;
                      CaptionML=[DAN=Dataudvekslingstyper;
                                 ENU=Data Exchange Types];
                      ToolTipML=[DAN=FÜ vist de dataudvekslingstyper, der er tilgëngelige til konvertering af elektroniske dokumenter til dokumenter i Dynamics NAV.;
                                 ENU=View the data exchange types that are available to convert electronic documents to documents in Dynamics NAV.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 1213;
                      Image=Entries;
                      PromotedCategory=Category5 }
      { 46      ;2   ;Action    ;
                      Name=OCRSetup;
                      CaptionML=[DAN=Opsëtning af OCR-tjeneste;
                                 ENU=OCR Service Setup];
                      ToolTipML=[DAN=èbn vinduet Opsëtning af OCR-tjeneste for f.eks. at ëndre legitimationsoplysninger eller aktivere tjenesten.;
                                 ENU=Open the OCR Service Setup window, for example to change credentials or enable the service.];
                      ApplicationArea=#Basic,#Suite;
                      Visible=ShowOCRSetup;
                      Image=ServiceSetup;
                      OnAction=BEGIN
                                 PAGE.RUNMODAL(PAGE::"OCR Service Setup");
                                 CurrPage.UPDATE;
                                 IF ClientTypeManagement.GetCurrentClientType = CLIENTTYPE::Web THEN
                                   IF OCRIsEnabled THEN BEGIN
                                     OnCloseIncomingDocumentsFromActions(Rec);
                                     CurrPage.CLOSE;
                                   END;
                               END;
                                }
      { 66      ;1   ;Action    ;
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
      { 29      ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 54      ;1   ;ActionGroup;
                      CaptionML=[DAN=Proces;
                                 ENU=Process] }
      { 45      ;2   ;Action    ;
                      Name=CreateDocument;
                      CaptionML=[DAN=Opret dokument;
                                 ENU=Create Document];
                      ToolTipML=[DAN=Opret et dokument, f.eks. en kõbsfaktura, automatisk ved at konvertere det elektroniske dokument, som er vedhëftet den indgÜende bilagsrecord.;
                                 ENU=Create a document, such as a purchase invoice, automatically by converting the electronic document that is attached to the incoming document record.];
                      ApplicationArea=#Basic,#Suite;
                      Enabled=AutomaticCreationActionsAreEnabled;
                      PromotedIsBig=Yes;
                      Image=CreateDocument;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IncomingDocumentMultiSelectAction(MultiSelectAction::CreateDocument);
                                 CurrPage.UPDATE;
                               END;
                                }
      { 51      ;2   ;Action    ;
                      Name=CreateGenJnlLine;
                      CaptionML=[DAN=Opret kladdelinje;
                                 ENU=Create Journal Line];
                      ToolTipML=[DAN=Opret et kladdelinje automatisk ved at konvertere det elektroniske dokument, som er vedhëftet den indgÜende bilagsrecord.;
                                 ENU=Create a journal line automatically by converting the electronic document that is attached to the incoming document record.];
                      ApplicationArea=#Basic,#Suite;
                      Enabled=AutomaticCreationActionsAreEnabled;
                      PromotedIsBig=Yes;
                      Image=TransferToGeneralJournal;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IncomingDocumentMultiSelectAction(MultiSelectAction::CreateGenJnlLineWithDataExchange);
                                 CurrPage.UPDATE;
                               END;
                                }
      { 63      ;2   ;Action    ;
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
                      OnAction=BEGIN
                                 IncomingDocumentMultiSelectAction(MultiSelectAction::CreateManually);
                               END;
                                }
      { 39      ;2   ;Action    ;
                      Name=AttachFile;
                      CaptionML=[DAN=Vedhëft fil;
                                 ENU=Attach File];
                      ToolTipML=[DAN=Vedhëft en fil til den indgÜende bilagsrecord.;
                                 ENU=Attach a file to the incoming document record.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Attach;
                      PromotedCategory=Process;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 ImportAttachment(Rec);
                               END;
                                }
      { 49      ;2   ;Action    ;
                      Name=TextToAccountMapping;
                      CaptionML=[DAN=Knyt tekst til konto;
                                 ENU=Map Text to Account];
                      ToolTipML=[DAN=Opret en tilknytninger mellem tekst i indgÜende salgsbilag og identisk tekst i specifikke debet-, kredit- og modkonti i finansmodulet, eller pÜ bankkonti, sÜ det fërdige salgsdokument eller kladdelinjer pÜ forhÜnd er udfyldt med de angivne oplysninger.;
                                 ENU=Create a mapping of text on incoming documents to identical text on specific debit, credit, and balancing accounts in the general ledger or on bank accounts so that the resulting document or journal lines are prefilled with the specified information.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 1254;
                      Image=MapAccounts;
                      PromotedCategory=Category5 }
      { 53      ;1   ;ActionGroup;
                      CaptionML=[DAN=Frigiv;
                                 ENU=Release] }
      { 30      ;2   ;Action    ;
                      Name=Release;
                      CaptionML=[DAN=Frigiv;
                                 ENU=Release];
                      ToolTipML=[DAN=Frigiv det indgÜende bilag for at indikere, at det er blevet godkendt af godkenderen af indgÜende bilag. Bemërk, at dette ikke har noget at gõre med godkendelsesworkflows.;
                                 ENU=Release the incoming document to indicate that it has been approved by the incoming document approver. Note that this is not related to approval workflows.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Approve;
                      PromotedCategory=Category4;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 IncomingDocumentMultiSelectAction(MultiSelectAction::Release);
                               END;
                                }
      { 67      ;2   ;Action    ;
                      Name=Reopen;
                      CaptionML=[DAN=èbn igen;
                                 ENU=Reopen];
                      ToolTipML=[DAN=èbn den indgÜende bilagsrecord igen, efter at den er blevet godkendt af godkenderen af indgÜende bilag. Bemërk, at dette ikke har noget at gõre med godkendelsesworkflows.;
                                 ENU=Reopen the incoming document record after it has been approved by the incoming document approver. Note that this is not related to approval workflows.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ReOpen;
                      PromotedCategory=Category4;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 IncomingDocumentMultiSelectAction(MultiSelectAction::Reopen);
                               END;
                                }
      { 31      ;2   ;Action    ;
                      Name=Reject;
                      CaptionML=[DAN=Afvis;
                                 ENU=Reject];
                      ToolTipML=[DAN=Afvis at godkende det indgÜende bilag. Bemërk, at dette ikke har noget at gõre med godkendelsesworkflows.;
                                 ENU=Reject to approve the incoming document. Note that this is not related to approval workflows.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Reject;
                      PromotedCategory=Category4;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 IncomingDocumentMultiSelectAction(MultiSelectAction::Reject);
                               END;
                                }
      { 68      ;1   ;ActionGroup;
                      CaptionML=[DAN=Status;
                                 ENU=Status] }
      { 65      ;2   ;Action    ;
                      Name=SetToProcessed;
                      CaptionML=[DAN=Indstil til behandlet;
                                 ENU=Set To Processed];
                      ToolTipML=[DAN=Indstil det indgÜende bilag til behandlet. Det vises derefter i vinduet IndgÜende bilag, nÜr Vis alt er valgt.;
                                 ENU=Set the incoming document to processed. It will then be shown in the Incoming Documents window when the Show All view is selected.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=SetToProcessedIsEnable;
                      PromotedIsBig=Yes;
                      Image=Archive;
                      PromotedCategory=Category5;
                      Scope=Repeater;
                      OnAction=VAR
                                 IncomingDocument@1000 : Record 130;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(IncomingDocument);
                                 IncomingDocument.MODIFYALL(Processed,TRUE);
                               END;
                                }
      { 64      ;2   ;Action    ;
                      Name=SetToUnprocessed;
                      CaptionML=[DAN=Indstil til ikke-behandlet;
                                 ENU=Set To Unprocessed];
                      ToolTipML=[DAN=Angiv det indgÜende salgsbilag til ikke-behandlet. Det vises derefter i vinduet indgÜende salgsbilag, nÜr Vis ikke-behandlede er valgt.;
                                 ENU=Set the incoming document to unprocessed. It will then be shown in the Incoming Documents window when the Show Unprocessed view is selected.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=NOT SetToProcessedIsEnable;
                      PromotedIsBig=Yes;
                      Image=ReOpen;
                      PromotedCategory=Category5;
                      Scope=Repeater;
                      OnAction=VAR
                                 IncomingDocument@1000 : Record 130;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(IncomingDocument);
                                 IncomingDocument.MODIFYALL(Processed,FALSE);
                               END;
                                }
      { 61      ;1   ;ActionGroup;
                      CaptionML=[DAN=Anmod om godkendelse;
                                 ENU=Request Approval];
                      Image=SendApprovalRequest }
      { 60      ;2   ;Action    ;
                      Name=SendApprovalRequest;
                      CaptionML=[DAN=Send godkendelsesan&modning;
                                 ENU=Send A&pproval Request];
                      ToolTipML=[DAN=Anmod om godkendelse af det indgÜende bilag. Du kan sende en godkendelsesanmodning som en del af et workflow, hvis det er konfigureret for din organisation.;
                                 ENU=Request approval of the incoming document. You can send an approval request as part of a workflow if this has been set up in your organization.];
                      ApplicationArea=#Suite;
                      Enabled=NOT OpenApprovalEntriesExist;
                      Image=SendApprovalRequest;
                      Scope=Repeater;
                      OnAction=VAR
                                 ApprovalsMgmt@1001 : Codeunit 1535;
                               BEGIN
                                 TestReadyForApproval;
                                 IF ApprovalsMgmt.CheckIncomingDocApprovalsWorkflowEnabled(Rec) THEN
                                   ApprovalsMgmt.OnSendIncomingDocForApproval(Rec);
                               END;
                                }
      { 59      ;2   ;Action    ;
                      Name=CancelApprovalRequest;
                      CaptionML=[DAN=Annuller godk&endelsesanmodning;
                                 ENU=Cancel Approval Re&quest];
                      ToolTipML=[DAN=Annuller anmodning om godkendelse af det indgÜende bilag.;
                                 ENU=Cancel requesting approval of the incoming document.];
                      ApplicationArea=#Suite;
                      Enabled=CanCancelApprovalForRecord;
                      Image=CancelApprovalRequest;
                      Scope=Repeater;
                      OnAction=VAR
                                 ApprovalsMgmt@1001 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.OnCancelIncomingDocApprovalRequest(Rec);
                               END;
                                }
      { 57      ;1   ;ActionGroup;
                      CaptionML=[DAN=IndgÜende bilag;
                                 ENU=Incoming Documents] }
      { 58      ;2   ;Action    ;
                      Name=OpenDocument;
                      CaptionML=[DAN=èbn record;
                                 ENU=Open Record];
                      ToolTipML=[DAN=èbn dokumentet, kladdelinjen eller posten, som det indgÜende bilag er tilknyttet.;
                                 ENU=Open the document, journal line, or entry that the incoming document is linked to.];
                      ApplicationArea=#Basic,#Suite;
                      Image=ViewDetails;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 ShowNAVRecord;
                               END;
                                }
      { 40      ;2   ;Action    ;
                      Name=RemoveReferencedRecord;
                      CaptionML=[DAN=Fjern reference til record;
                                 ENU=Remove Reference to Record];
                      ToolTipML=[DAN=Fjern tilknytningen fra det indgÜende bilag til et dokument, en kladdelinje eller en post.;
                                 ENU=Remove the link that exists from the incoming document to a document, journal line, or entry.];
                      ApplicationArea=#Basic,#Suite;
                      PromotedIsBig=Yes;
                      Image=ClearLog;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 RemoveReferencedRecords;
                               END;
                                }
      { 55      ;2   ;Action    ;
                      Name=Navigate;
                      CaptionML=[DAN=Naviger;
                                 ENU=Navigate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes til bilagsnummeret og bogfõringsdatoen pÜ den valgte post eller det valgte dokument.;
                                 ENU=Find all entries and documents that exist for the document number and posting date on the selected entry or document.];
                      ApplicationArea=#Basic,#Suite;
                      PromotedIsBig=Yes;
                      Image=Navigate;
                      Scope=Repeater;
                      OnAction=VAR
                                 NavigatePage@1000 : Page 344;
                               BEGIN
                                 TESTFIELD(Posted);
                                 NavigatePage.SetDoc("Posting Date","Document No.");
                                 NavigatePage.RUN;
                               END;
                                }
      { 52      ;2   ;ActionGroup;
                      Name=Document;
                      CaptionML=[DAN=Record;
                                 ENU=Record];
                      Visible=FALSE;
                      Enabled=FALSE;
                      Image=Document }
      { 23      ;3   ;Action    ;
                      Name=Journal;
                      CaptionML=[DAN=Kladdelinje;
                                 ENU=Journal Line];
                      ToolTipML=[DAN=èbn den record, som det indgÜende bilag er tilknyttet.;
                                 ENU=Open the record that the incoming document is linked to.];
                      ApplicationArea=#Advanced;
                      Image=Journal;
                      Scope=Repeater;
                      OnAction=VAR
                                 GenJournalBatch@1001 : Record 232;
                                 GenJnlManagement@1002 : Codeunit 230;
                               BEGIN
                                 IncomingDocumentMultiSelectAction(MultiSelectAction::CreateGenJnlLine);
                                 IncomingDocumentsSetup.Fetch;
                                 GenJournalBatch.GET(IncomingDocumentsSetup."General Journal Template Name",IncomingDocumentsSetup."General Journal Batch Name");
                                 GenJnlManagement.TemplateSelectionFromBatch(GenJournalBatch);
                               END;
                                }
      { 26      ;3   ;Action    ;
                      Name=PurchaseInvoice;
                      CaptionML=[DAN=Kõbsfaktura;
                                 ENU=Purchase Invoice];
                      ToolTipML=[DAN=èbn den record, som det indgÜende bilag er tilknyttet.;
                                 ENU=Open the record that the incoming document is linked to.];
                      ApplicationArea=#Advanced;
                      Image=Purchase;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 IncomingDocumentMultiSelectAction(MultiSelectAction::CreatePurchInvoice);
                               END;
                                }
      { 27      ;3   ;Action    ;
                      Name=PurchaseCreditMemo;
                      CaptionML=[DAN=Kõbskreditnota;
                                 ENU=Purchase Credit Memo];
                      ToolTipML=[DAN=èbn den record, som det indgÜende bilag er tilknyttet.;
                                 ENU=Open the record that the incoming document is linked to.];
                      ApplicationArea=#Advanced;
                      Image=CreditMemo;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 IncomingDocumentMultiSelectAction(MultiSelectAction::CreatePurchCreditMemo);
                               END;
                                }
      { 24      ;3   ;Action    ;
                      Name=SalesInvoice;
                      CaptionML=[DAN=Salgsfaktura;
                                 ENU=Sales Invoice];
                      ToolTipML=[DAN=èbn den record, som det indgÜende bilag er tilknyttet.;
                                 ENU=Open the record that the incoming document is linked to.];
                      ApplicationArea=#Advanced;
                      Image=Sales;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 IncomingDocumentMultiSelectAction(MultiSelectAction::CreateSalesInvoice);
                               END;
                                }
      { 25      ;3   ;Action    ;
                      Name=SalesCreditMemo;
                      CaptionML=[DAN=Salgskreditnota;
                                 ENU=Sales Credit Memo];
                      ToolTipML=[DAN=èbn den record, som det indgÜende bilag er tilknyttet.;
                                 ENU=Open the record that the incoming document is linked to.];
                      ApplicationArea=#Advanced;
                      Image=CreditMemo;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 IncomingDocumentMultiSelectAction(MultiSelectAction::CreateSalesCreditMemo);
                               END;
                                }
      { 44      ;1   ;ActionGroup;
                      CaptionML=[DAN=OCR;
                                 ENU=OCR] }
      { 41      ;2   ;Action    ;
                      Name=SetReadyForOCR;
                      CaptionML=[DAN=Send til opgavekõ;
                                 ENU=Send to Job Queue];
                      ToolTipML=[DAN=Indstil det indgÜende bilag til at blive sendt til modtagerne hurtigst muligt.;
                                 ENU=Set the incoming document to be sent to its recipient as soon as possible.];
                      ApplicationArea=#Basic,#Suite;
                      Visible=OCRServiceIsEnabled;
                      Image=Translation;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 IncomingDocumentMultiSelectAction(MultiSelectAction::SetReadyForOcr);
                               END;
                                }
      { 43      ;2   ;Action    ;
                      Name=UndoSetReadyForOCR;
                      CaptionML=[DAN=Fjern fra opgavekõ;
                                 ENU=Remove from Job Queue];
                      ToolTipML=[DAN=Fjern den planlagte behandling af denne record fra jobkõen.;
                                 ENU=Remove the scheduled processing of this record from the job queue.];
                      ApplicationArea=#Basic,#Suite;
                      Visible=OCRServiceIsEnabled;
                      Image=Translation;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 IncomingDocumentMultiSelectAction(MultiSelectAction::UndoReadyForOcr);
                               END;
                                }
      { 12      ;2   ;Action    ;
                      Name=SendToOcr;
                      CaptionML=[DAN=Send til OCR-tjeneste;
                                 ENU=Send to OCR Service];
                      ToolTipML=[DAN=Send den vedhëftede pdf- eller billedfil til OCR-tjenesten med det samme.;
                                 ENU=Send the attached PDF or image file to the OCR service immediately.];
                      ApplicationArea=#Basic,#Suite;
                      Visible=OCRServiceIsEnabled;
                      Image=Translations;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 IncomingDocumentMultiSelectAction(MultiSelectAction::SendToOcr);
                               END;
                                }
      { 47      ;2   ;Action    ;
                      Name=ReceiveFromOCR;
                      CaptionML=[DAN=Modtag fra OCR-tjeneste;
                                 ENU=Receive from OCR Service];
                      ToolTipML=[DAN=Hent alle elektroniske dokumenter, der er klar til modtagelse fra OCR-tjenesten.;
                                 ENU=Get any electronic documents that are ready to receive from the OCR service.];
                      ApplicationArea=#Basic,#Suite;
                      Visible=OCRServiceIsEnabled;
                      Enabled=EnableReceiveFromOCR;
                      PromotedIsBig=Yes;
                      Image=Import;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"OCR - Receive from Service");
                               END;
                                }
      { 73      ;1   ;ActionGroup;
                      CaptionML=[DAN=Indstil visning;
                                 ENU=Set View] }
      { 71      ;2   ;Action    ;
                      Name=ShowAll;
                      CaptionML=[DAN=Vis alle;
                                 ENU=Show All];
                      ToolTipML=[DAN=Vis bÜde behandlede og ikke-behandlede indgÜende bilag.;
                                 ENU=Show both processed and non-processed incoming documents.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=NOT ShowAllDocsIsEnable;
                      PromotedIsBig=Yes;
                      Image=AllLines;
                      PromotedCategory=Category6;
                      OnAction=BEGIN
                                 SetProcessedDocumentsVisibility(TRUE);
                               END;
                                }
      { 72      ;2   ;Action    ;
                      Name=ShowUnprocessed;
                      CaptionML=[DAN=Vis ikke-behandlede;
                                 ENU=Show Unprocessed];
                      ToolTipML=[DAN=Vis kun ikke-behandlede indgÜende bilag.;
                                 ENU=Show only unprocessed incoming documents.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=ShowAllDocsIsEnable;
                      PromotedIsBig=Yes;
                      Image=Document;
                      PromotedCategory=Category6;
                      OnAction=BEGIN
                                 SetProcessedDocumentsVisibility(FALSE);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Entry No.";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af det indgÜende bilag. Du skal angive beskrivelsen manuelt.;
                           ENU=Specifies the description of the incoming document. You must enter the description manually.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ kreditoren pÜ det indgÜende bilag. Feltet udfyldes muligvis automatisk.;
                           ENU=Specifies the name of the vendor on the incoming document. The field may be filled automatically.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Vendor Name" }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, der fremgÜr af det indgÜende bilag. Det kan f.eks. vëre den dato, hvor kreditoren oprettede fakturaen. Feltet bliver muligvis udfyldt automatisk.;
                           ENU=Specifies the date that is printed on the incoming document. This is the date when the vendor created the invoice, for example. The field may be filled automatically.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Date" }

    { 37  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bilagsnummeret for det oprindelige bilag, du modtog fra kreditoren. Du kan krëve bilagsnummeret til bogfõring, eller du kan lade det vëre valgfrit. Det er pÜkrëvet som standard, sÜ dette bilag refererer til originalen. Det fjerner et trin fra bogfõringsprocessen at gõre bilagsnumre valgfri. Hvis du f.eks. vedhëfter den oprindelige faktura som en PDF-fil, behõver du mÜske ikke at angive bilagsnummeret. I vinduet Kõbsopsëtning kan du vëlge, om bilagsnumre er pÜkrëvet ved at vëlge eller rydde markeringen i afkrydsningsfeltet Eksternt bilagsnr. obl.;
                           ENU=Specifies the document number of the original document you received from the vendor. You can require the document number for posting, or let it be optional. By default, it's required, so that this document references the original. Making document numbers optional removes a step from the posting process. For example, if you attach the original invoice as a PDF, you might not need to enter the document number. To specify whether document numbers are required, in the Purchases & Payables Setup window, select or clear the Ext. Doc. No. Mandatory field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Vendor Invoice No." }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver valutakoden, hvis bilaget indeholder denne kode. Feltet kan blive udfyldt automatisk.;
                           ENU=Specifies the currency code, if the document contains that code. The field may be filled automatically.];
                ApplicationArea=#Suite;
                SourceExpr="Currency Code" }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver belõb inkl. moms for hele bilaget. Feltet udfyldes muligvis automatisk.;
                           ENU=Specifies the amount including VAT for the whole document. The field may be filled automatically.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Amount Incl. VAT" }

    { 34  ;2   ;Field     ;
                ExtendedDatatype=URL;
                CaptionML=[DAN=Sammenkëd med dokument;
                           ENU=Link to Document];
                ToolTipML=[DAN=Angiver placeringen af den fil, der reprësenterer det indgÜende bilag.;
                           ENU=Specifies the location of the file that represents the incoming document.];
                ApplicationArea=#Advanced;
                SourceExpr=URL;
                Importance=Additional;
                Visible=FALSE;
                OnValidate=BEGIN
                             SetURL(URL);
                           END;
                            }

    { 140 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken dataudvekslingstype, der bruges til at behandle det indgÜende bilag, nÜr det er et elektronisk dokument.;
                           ENU=Specifies the data exchange type that is used to process the incoming document when it is an electronic document.];
                ApplicationArea=#Advanced;
                SourceExpr="Data Exchange Type";
                Visible=FALSE;
                Editable=IsDataExchTypeEditable }

    { 17  ;2   ;Field     ;
                DrillDown=Yes;
                ToolTipML=[DAN=Angiver status for den indgÜende bilagsrecord.;
                           ENU=Specifies the status of the incoming document record.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Status;
                StyleExpr=StatusStyleText;
                OnDrillDown=VAR
                              ErrorMessage@1000 : Record 700;
                            BEGIN
                              ErrorMessage.SetContext(RECORDID);
                              ErrorMessage.ShowErrorMessages(FALSE);
                            END;
                             }

    { 62  ;2   ;Field     ;
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

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvornÜr den indgÜende bilagslinje blev oprettet.;
                           ENU=Specifies when the incoming document line was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Created Date-Time";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Indeholder navnet pÜ den bruger, som oprettede den indgÜende bilagslinje.;
                           ENU=Specifies the name of the user who created the incoming document line.];
                ApplicationArea=#Advanced;
                SourceExpr="Created By User Name";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvornÜr det indgÜende bilag blev godkendt.;
                           ENU=Specifies when the incoming document was approved.];
                ApplicationArea=#Advanced;
                SourceExpr="Released Date-Time";
                Visible=FALSE }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Indeholder navnet pÜ den bruger, som godkendte det indgÜende bilag.;
                           ENU=Specifies the name of the user who approved the incoming document.];
                ApplicationArea=#Advanced;
                SourceExpr="Released By User Name";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvornÜr den indgÜende bilagslinje sidst blev ëndret.;
                           ENU=Specifies when the incoming document line was last modified.];
                ApplicationArea=#Advanced;
                SourceExpr="Last Date-Time Modified";
                Visible=FALSE }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Indeholder navnet pÜ den bruger, som sidst ëndrede den indgÜende bilagslinje.;
                           ENU=Specifies the name of the user who last modified the incoming document line.];
                ApplicationArea=#Advanced;
                SourceExpr="Last Modified By User Name";
                Visible=FALSE }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvornÜr det relaterede dokument eller kladdelinjen blev bogfõrt.;
                           ENU=Specifies when the related document or journal line was posted.];
                ApplicationArea=#Advanced;
                SourceExpr="Posted Date-Time";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen af det dokument eller den kladde, det indgÜende bilag kan forbindes med.;
                           ENU=Specifies the type of document or journal that the incoming document can be connected to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Type" }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ det relaterede dokument eller den relaterede kladdelinje, som er oprettet for det indgÜende bilag.;
                           ENU=Specifies the number of the related document or journal line that is created for the incoming document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document No." }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvornÜr det dokument eller den kladdelinje, der er relateret til det indgÜende bilag, blev bogfõrt.;
                           ENU=Specifies when the document or journal line that relates to the incoming document was posted.];
                ApplicationArea=#Advanced;
                SourceExpr="Posting Date";
                Visible=FALSE }

    { 70  ;2   ;Field     ;
                DrillDown=Yes;
                ToolTipML=[DAN=Angiver, om det indgÜende bilag er blevet godkendt.;
                           ENU=Specifies if the incoming document has been processed.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Processed;
                StyleExpr=StatusStyleText;
                OnDrillDown=VAR
                              ErrorMessage@1000 : Record 700;
                            BEGIN
                              ErrorMessage.SetContext(RECORDID);
                              ErrorMessage.ShowErrorMessages(FALSE);
                            END;
                             }

    { 18  ;0   ;Container ;
                ContainerType=FactBoxArea }

    { 7   ;1   ;Part      ;
                Name=IncomingDocAttachFactBox;
                ApplicationArea=#Basic,#Suite;
                SubPageLink=Incoming Document Entry No.=FIELD(Entry No.);
                PagePartID=Page193;
                PartType=Page;
                ShowFilter=No }

    { 19  ;1   ;Part      ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=Notes }

    { 20  ;1   ;Part      ;
                ApplicationArea=#Advanced;
                Visible=FALSE;
                PartType=System;
                SystemPartID=MyNotes }

    { 21  ;1   ;Part      ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

  }
  CODE
  {
    VAR
      IncomingDocumentsSetup@1001 : Record 131;
      AutomaticProcessingQst@1005 : TextConst 'DAN=Feltet Dataudvekslingstype er udfyldt i mindst Çt af de valgte indgÜende bilag.\\Er du sikker pÜ, at du vil oprette bilag manuelt?;ENU=The Data Exchange Type field is filled on at least one of the selected Incoming Documents.\\Are you sure you want to create documents manually?';
      ClientTypeManagement@1015 : Codeunit 4;
      CameraProvider@1008 : DotNet "'Microsoft.Dynamics.Nav.ClientExtensions, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.Capabilities.CameraProvider" WITHEVENTS RUNONCLIENT;
      HasCamera@1003 : Boolean;
      URL@1006 : Text;
      StatusStyleText@1004 : Text;
      MultiSelectAction@1002 : 'CreateGenJnlLine,CreatePurchInvoice,CreatePurchCreditMemo,CreateSalesInvoice,CreateSalesCreditMemo,Release,Reopen,Reject,CreateDocument,SetReadyForOcr,UndoReadyForOcr,SendToOcr,CreateGenJnlLineWithDataExchange,CreateManually';
      IsDataExchTypeEditable@1000 : Boolean;
      OpenApprovalEntriesExist@1009 : Boolean;
      EnableReceiveFromOCR@1007 : Boolean;
      CanCancelApprovalForRecord@1010 : Boolean;
      ShowOCRSetup@1011 : Boolean;
      OCRServiceIsEnabled@1012 : Boolean;
      AutomaticCreationActionsAreEnabled@1013 : Boolean;
      SetToProcessedIsEnable@1014 : Boolean;
      ShowAllDocsIsEnable@1022 : Boolean;

    LOCAL PROCEDURE IncomingDocumentMultiSelectAction@10(ActionName@1000 : Option);
    VAR
      IncomingDocument@1001 : Record 130;
      ReleaseIncomingDocument@1002 : Codeunit 132;
    BEGIN
      IF NOT AskUserPermission(ActionName) THEN
        EXIT;

      CurrPage.SETSELECTIONFILTER(IncomingDocument);
      IF IncomingDocument.FINDSET THEN
        REPEAT
          CASE ActionName OF
            MultiSelectAction::CreateDocument:
              IncomingDocument.CreateDocumentWithDataExchange;
            MultiSelectAction::CreateManually:
              IncomingDocument.CreateManually;
            MultiSelectAction::CreateGenJnlLine:
              IncomingDocument.CreateGenJnlLine;
            MultiSelectAction::CreateGenJnlLineWithDataExchange:
              IncomingDocument.CreateGeneralJournalLineWithDataExchange;
            MultiSelectAction::CreatePurchInvoice:
              IncomingDocument.CreatePurchInvoice;
            MultiSelectAction::CreatePurchCreditMemo:
              IncomingDocument.CreatePurchCreditMemo;
            MultiSelectAction::CreateSalesInvoice:
              IncomingDocument.CreateSalesInvoice;
            MultiSelectAction::CreateSalesCreditMemo:
              IncomingDocument.CreateSalesCreditMemo;
            MultiSelectAction::Release:
              ReleaseIncomingDocument.PerformManualRelease(IncomingDocument);
            MultiSelectAction::Reopen:
              ReleaseIncomingDocument.PerformManualReopen(IncomingDocument);
            MultiSelectAction::Reject:
              ReleaseIncomingDocument.PerformManualReject(IncomingDocument);
            MultiSelectAction::SetReadyForOcr:
              IncomingDocument.SendToJobQueue(FALSE);
            MultiSelectAction::UndoReadyForOcr:
              IncomingDocument.RemoveFromJobQueue(FALSE);
            MultiSelectAction::SendToOcr:
              IncomingDocument.SendToOCR(FALSE);
          END;
        UNTIL IncomingDocument.NEXT = 0;
    END;

    LOCAL PROCEDURE AskUserPermission@7(ActionName@1000 : Option) : Boolean;
    VAR
      IncomingDocument@1001 : Record 130;
    BEGIN
      CurrPage.SETSELECTIONFILTER(IncomingDocument);
      IF ActionName IN [MultiSelectAction::Reject,
                        MultiSelectAction::Release,
                        MultiSelectAction::SetReadyForOcr,
                        MultiSelectAction::CreateDocument]
      THEN
        EXIT(TRUE);

      IF Status <> Status::New THEN
        EXIT(TRUE);

      IncomingDocument.SETFILTER("Data Exchange Type",'<>%1','');
      IF IncomingDocument.ISEMPTY THEN
        EXIT(TRUE);

      EXIT(CONFIRM(AutomaticProcessingQst));
    END;

    LOCAL PROCEDURE SetControlVisibility@9();
    VAR
      ApprovalsMgmt@1000 : Codeunit 1535;
    BEGIN
      OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);
      EnableReceiveFromOCR := WaitingToReceiveFromOCR;
      UpdateOCRSetupVisibility;
      CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RECORDID);
      AutomaticCreationActionsAreEnabled := "Data Exchange Type" <> '';
    END;

    [Integration(TRUE,TRUE)]
    [External]
    LOCAL PROCEDURE OnCloseIncomingDocumentsFromActions@3(VAR IncomingDocument@1000 : Record 130);
    BEGIN
    END;

    LOCAL PROCEDURE SetProcessedDocumentsVisibility@1(ShowProcessedItems@1000 : Boolean);
    BEGIN
      FILTERGROUP(0);

      IF ShowProcessedItems THEN BEGIN
        SETRANGE(Processed);
        ShowAllDocsIsEnable := TRUE;
      END ELSE BEGIN
        SETRANGE(Processed,FALSE);
        ShowAllDocsIsEnable := FALSE;
      END;
    END;

    LOCAL PROCEDURE UpdateOCRSetupVisibility@5();
    BEGIN
      OCRServiceIsEnabled := OCRIsEnabled;
      ShowOCRSetup := NOT OCRServiceIsEnabled;
    END;

    EVENT CameraProvider@1008::PictureAvailable@11(PictureName@1001 : Text;PictureFilePath@1000 : Text);
    BEGIN
      CreateIncomingDocumentFromServerFile(PictureName,PictureFilePath);
    END;

    BEGIN
    END.
  }
}

