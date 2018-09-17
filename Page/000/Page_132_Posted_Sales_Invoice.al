OBJECT Page 132 Posted Sales Invoice
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846,NAVDK11.00.00.19846;
  }
  PROPERTIES
  {
    Permissions=TableData 112=rd;
    CaptionML=[DAN=Bogfõrt salgsfaktura;
               ENU=Posted Sales Invoice];
    InsertAllowed=No;
    SourceTable=Table112;
    PageType=Document;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,RapportÇr,Faktura,Korrekt;
                                ENU=New,Process,Report,Invoice,Correct];
    OnInit=BEGIN
             DocExcStatusVisible := TRUE;
           END;

    OnOpenPage=VAR
                 OfficeMgt@1001 : Codeunit 1630;
               BEGIN
                 SetSecurityFilterOnRespCenter;
                 CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;

                 IsOfficeAddin := OfficeMgt.IsAvailable;
                 IsFoundationEnabled := ApplicationAreaSetup.IsFoundationEnabled;
               END;

    OnAfterGetRecord=BEGIN
                       DocExchStatusStyle := GetDocExchStatusStyle;
                     END;

    OnAfterGetCurrRecord=VAR
                           IncomingDocument@1000 : Record 130;
                           CRMCouplingManagement@1001 : Codeunit 5331;
                         BEGIN
                           HasIncomingDocument := IncomingDocument.PostedDocExists("No.","Posting Date");
                           DocExchStatusStyle := GetDocExchStatusStyle;
                           CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
                           IF CRMIntegrationEnabled THEN BEGIN
                             CRMIsCoupledToRecord := CRMCouplingManagement.IsRecordCoupledToCRM(RECORDID);
                             IF "No." <> xRec."No." THEN
                               CRMIntegrationManagement.SendResultNotification(Rec);
                           END;
                           UpdatePaymentService;
                           DocExcStatusVisible := DocExchangeStatusIsSent;
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 55      ;1   ;ActionGroup;
                      CaptionML=[DAN=F&aktura;
                                 ENU=&Invoice];
                      Image=Invoice }
      { 8       ;2   ;Action    ;
                      Name=Statistics;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=FÜ vist statistiske oplysninger som f.eks. vërdien for bogfõrte poster til recorden.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 397;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Statistics;
                      PromotedCategory=Category4 }
      { 57      ;2   ;Action    ;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 67;
                      RunPageLink=Document Type=CONST(Posted Invoice),
                                  No.=FIELD(No.),
                                  Document Line No.=CONST(0);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ViewComments;
                      PromotedCategory=Category4 }
      { 89      ;2   ;Action    ;
                      Name=Dimensions;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omrÜde, projekt eller afdeling, som du kan tildele til salgs- og kõbsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Dimensions;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 ShowDimensions;
                               END;
                                }
      { 112     ;2   ;Action    ;
                      AccessByPermission=TableData 456=R;
                      CaptionML=[DAN=Godkendelser;
                                 ENU=Approvals];
                      ToolTipML=[DAN=FÜ vist en liste over records, der afventer godkendelse. Du kan f.eks. se, hvem der har anmodet om godkendelse af recorden, hvornÜr den blev sendt og hvornÜr den skal godkendes.;
                                 ENU=View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Approvals;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.ShowPostedApprovalEntries(RECORDID);
                               END;
                                }
      { 171     ;2   ;Separator  }
      { 35      ;2   ;Action    ;
                      Name=ChangePaymentService;
                      CaptionML=[DAN=Rediger betalingstjeneste;
                                 ENU=Change Payment Service];
                      ToolTipML=[DAN=Rediger eller tilfõj betalingstjenesten, f.eks. PayPal Standard, som skal medtages pÜ salgsbilaget, sÜ debitoren hurtigt kan fÜ adgang til betalingswebstedet.;
                                 ENU=Change or add the payment service, such as PayPal Standard, that will be included on the sales document so the customer can quickly access the payment site.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=PaymentServiceVisible;
                      PromotedIsBig=Yes;
                      Image=ElectronicPayment;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 PaymentServiceSetup@1000 : Record 1060;
                               BEGIN
                                 PaymentServiceSetup.ChangePaymentServicePostedInvoice(Rec);
                               END;
                                }
      { 45      ;1   ;ActionGroup;
                      Name=ActionGroupCRM;
                      CaptionML=[DAN=Dynamics 365 for Sales;
                                 ENU=Dynamics 365 for Sales];
                      Visible=CRMIntegrationEnabled }
      { 43      ;2   ;Action    ;
                      Name=CRMGotoInvoice;
                      CaptionML=[DAN=Faktura;
                                 ENU=Invoice];
                      ToolTipML=[DAN=èbn den sammenkëdede Dynamics 365 for Sales-faktura.;
                                 ENU=Open the coupled Dynamics 365 for Sales invoice.];
                      ApplicationArea=#Suite;
                      Enabled=CRMIsCoupledToRecord;
                      Image=CoupledSalesInvoice;
                      OnAction=VAR
                                 CRMIntegrationManagement@1000 : Codeunit 5330;
                               BEGIN
                                 CRMIntegrationManagement.ShowCRMEntityFromRecordID(RECORDID);
                               END;
                                }
      { 29      ;2   ;Action    ;
                      Name=CreateInCRM;
                      CaptionML=[DAN=Opret faktura i Dynamics 365 for Sales;
                                 ENU=Create Invoice in Dynamics 365 for Sales];
                      ToolTipML=[DAN=Opret en salgsfaktura i Dynamics 365 for Sales, som er forbundet til denne bogfõrte salgsfaktura.;
                                 ENU=Create a sales invoice in Dynamics 365 for Sales that is connected to this posted sales invoice.];
                      ApplicationArea=#Suite;
                      Enabled=NOT CRMIsCoupledToRecord;
                      Image=NewSalesInvoice;
                      OnAction=VAR
                                 CRMIntegrationManagement@1000 : Codeunit 5330;
                               BEGIN
                                 CRMIntegrationManagement.CreateNewRecordsInCRM(RECORDID);
                               END;
                                }
      { 84      ;2   ;Action    ;
                      Name=ShowLog;
                      CaptionML=[DAN=Synkroniseringslog;
                                 ENU=Synchronization Log];
                      ToolTipML=[DAN=Vis integrationssynkroniseringsjobs for bogfõrt salgsfaktura-tabellen.;
                                 ENU=View integration synchronization jobs for the posted sales invoice table.];
                      ApplicationArea=#Suite;
                      Image=Log;
                      OnAction=VAR
                                 CRMIntegrationManagement@1000 : Codeunit 5330;
                               BEGIN
                                 CRMIntegrationManagement.ShowLog(RECORDID);
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 108     ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 1060000 ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Opret elektronisk faktura;
                                 ENU=Create Electronic Invoice];
                      ToolTipML=[DAN=Opret en elektronisk version af det aktuelle dokument.;
                                 ENU=Create an electronic version of the current document.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=ElectronicDoc;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 SalesInvHeader := Rec;
                                 SalesInvHeader.SETRECFILTER;

                                 REPORT.RUNMODAL(REPORT::"Create Electronic Invoices",TRUE,FALSE,SalesInvHeader);
                               END;
                                }
      { 5       ;1   ;Action    ;
                      Name=SendCustom;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Send;
                                 ENU=Send];
                      ToolTipML=[DAN=Klargõr bilaget til afsendelse i henhold til debitorens afsendelsesprofil, f.eks. vedhëftet en mail. Vinduet Send dokument til vises, sÜ du kan bekrëfte eller vëlge en afsendelsesprofil.;
                                 ENU=Prepare to send the document according to the customer's sending profile, such as attached to an email. The Send document to window opens first so you can confirm or select a sending profile.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=SendToMultiple;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 SalesInvHeader@1000 : Record 112;
                               BEGIN
                                 SalesInvHeader := Rec;
                                 CurrPage.SETSELECTIONFILTER(SalesInvHeader);
                                 SalesInvHeader.SendRecords;
                               END;
                                }
      { 58      ;1   ;Action    ;
                      Name=Print;
                      Ellipsis=Yes;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=Forbered udskrivning af bilaget. Du fÜr vist et anmodningsvindue for bilaget, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.];
                      ApplicationArea=#Basic,#Suite;
                      Visible=NOT IsOfficeAddin;
                      Image=Print;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 SalesInvHeader := Rec;
                                 CurrPage.SETSELECTIONFILTER(SalesInvHeader);
                                 SalesInvHeader.PrintRecords(TRUE);
                               END;
                                }
      { 9       ;1   ;Action    ;
                      Name=Email;
                      CaptionML=[DAN=&Mail;
                                 ENU=&Email];
                      ToolTipML=[DAN=Forbered at afsende bilaget via mail. Vinduet Send mail Übnes med debitorens mailadresse angivet, sÜ du kan tilfõje eller redigere oplysninger.;
                                 ENU=Prepare to email the document. The Send Email window opens prefilled with the customer's email address so you can add or edit information.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Email;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 SalesInvHeader := Rec;
                                 CurrPage.SETSELECTIONFILTER(SalesInvHeader);
                                 SalesInvHeader.EmailRecords(TRUE);
                               END;
                                }
      { 59      ;1   ;Action    ;
                      CaptionML=[DAN=N&aviger;
                                 ENU=&Navigate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes til bilagsnummeret og bogfõringsdatoen pÜ den valgte post eller det valgte dokument.;
                                 ENU=Find all entries and documents that exist for the document number and posting date on the selected entry or document.];
                      ApplicationArea=#Basic,#Suite;
                      Visible=NOT IsOfficeAddin;
                      Image=Navigate;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 Navigate;
                               END;
                                }
      { 13      ;1   ;Action    ;
                      Name=ActivityLog;
                      CaptionML=[DAN=Aktivitetslogfil;
                                 ENU=Activity Log];
                      ToolTipML=[DAN=Se status og eventuelle fejl, hvis dokumentet blev sendt som et elektronisk dokument eller OCR-fil via dokumentudvekslingstjenesten.;
                                 ENU=View the status and any errors if the document was sent as an electronic document or OCR file through the document exchange service.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Log;
                      OnAction=BEGIN
                                 ShowActivityLog;
                               END;
                                }
      { 23      ;1   ;ActionGroup;
                      Name=IncomingDocument;
                      CaptionML=[DAN=IndgÜende bilag;
                                 ENU=Incoming Document];
                      ActionContainerType=NewDocumentItems;
                      Image=Documents }
      { 21      ;2   ;Action    ;
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
                                 IncomingDocument.ShowCard("No.","Posting Date");
                               END;
                                }
      { 19      ;2   ;Action    ;
                      Name=SelectIncomingDoc;
                      AccessByPermission=TableData 130=R;
                      CaptionML=[DAN=Vëlg indgÜende bilag;
                                 ENU=Select Incoming Document];
                      ToolTipML=[DAN=Vëlg en indgÜende bilagsrecord og vedhëftet fil, der skal knyttes til posten eller dokumentet.;
                                 ENU=Select an incoming document record and file attachment that you want to link to the entry or document.];
                      ApplicationArea=#Basic,#Suite;
                      Enabled=NOT HasIncomingDocument;
                      Image=SelectLineToApply;
                      OnAction=VAR
                                 IncomingDocument@1000 : Record 130;
                               BEGIN
                                 IncomingDocument.SelectIncomingDocumentForPostedDocument("No.","Posting Date",RECORDID);
                               END;
                                }
      { 17      ;2   ;Action    ;
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
                                 IncomingDocumentAttachment.NewAttachmentFromPostedDocument("No.","Posting Date");
                               END;
                                }
      { 41      ;1   ;ActionGroup;
                      CaptionML=[DAN=Ret;
                                 ENU=Correct] }
      { 39      ;2   ;Action    ;
                      Name=CorrectInvoice;
                      CaptionML=[DAN=Ret;
                                 ENU=Correct];
                      ToolTipML=[DAN=Tilbagefõr denne bogfõrte faktura, og opret automatisk en ny faktura med de samme oplysninger, som du kan rette, fõr du bogfõrer. Denne bogfõrte faktura bliver annulleret automatisk.;
                                 ENU=Reverse this posted invoice and automatically create a new invoice with the same information that you can correct before posting. This posted invoice will automatically be canceled.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=IsFoundationEnabled;
                      PromotedIsBig=Yes;
                      Image=Undo;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 CorrectPstdSalesInvYesNo@1000 : Codeunit 1322;
                               BEGIN
                                 IF CorrectPstdSalesInvYesNo.CorrectInvoice(Rec) THEN
                                   CurrPage.CLOSE;
                               END;
                                }
      { 37      ;2   ;Action    ;
                      Name=CancelInvoice;
                      CaptionML=[DAN=Annuller;
                                 ENU=Cancel];
                      ToolTipML=[DAN=Opret og bogfõr en salgskreditnota, der tilbagefõrer denne bogfõrte salgskreditnota. Denne bogfõrte salgskreditnota annulleres.;
                                 ENU=Create and post a sales credit memo that reverses this posted sales invoice. This posted sales invoice will be canceled.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=IsFoundationEnabled;
                      PromotedIsBig=Yes;
                      Image=Cancel;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 CancelPstdSalesInvYesNo@1000 : Codeunit 1323;
                               BEGIN
                                 IF CancelPstdSalesInvYesNo.CancelInvoice(Rec) THEN
                                   CurrPage.CLOSE;
                               END;
                                }
      { 33      ;2   ;Action    ;
                      Name=CreateCreditMemo;
                      CaptionML=[DAN=Opret rettelseskreditnota;
                                 ENU=Create Corrective Credit Memo];
                      ToolTipML=[DAN=Opret en kreditnota til denne bogfõrte faktura, som du udfylder og bogfõrer manuelt for at tilbagefõre den bogfõrte faktura.;
                                 ENU=Create a credit memo for this posted invoice that you complete and post manually to reverse the posted invoice.];
                      ApplicationArea=#Basic,#Suite;
                      Image=CreateCreditMemo;
                      PromotedCategory=Category5;
                      OnAction=VAR
                                 SalesHeader@1001 : Record 36;
                                 CorrectPostedSalesInvoice@1000 : Codeunit 1303;
                               BEGIN
                                 CorrectPostedSalesInvoice.CreateCreditMemoCopyDocument(Rec,SalesHeader);
                                 PAGE.RUN(PAGE::"Sales Credit Memo",SalesHeader);
                                 CurrPage.CLOSE;
                               END;
                                }
      { 51      ;1   ;ActionGroup;
                      CaptionML=[DAN=Faktura;
                                 ENU=Invoice];
                      Image=Invoice }
      { 49      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Debitor;
                                 ENU=Customer];
                      ToolTipML=[DAN=FÜ vist eller rediger detaljerede oplysninger om debitoren.;
                                 ENU=View or edit detailed information about the customer.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 21;
                      RunPageLink=No.=FIELD(Sell-to Customer No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Customer;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes }
      { 47      ;2   ;Action    ;
                      Name=ShowCreditMemo;
                      CaptionML=[DAN=Vis annulleret kreditnota/rettelseskreditnota;
                                 ENU=Show Canceled/Corrective Credit Memo];
                      ToolTipML=[DAN=èbn den bogfõrte salgskreditnota, som blev oprettet, da du annullerede den bogfõrte salgsfaktura. Hvis den bogfõrte salgsfaktura er resultatet af en annulleret salgskreditnota, Übnes den annullerede salgskreditnota.;
                                 ENU=Open the posted sales credit memo that was created when you canceled the posted sales invoice. If the posted sales invoice is the result of a canceled sales credit memo, then canceled sales credit memo will open.];
                      ApplicationArea=#Basic,#Suite;
                      Enabled=Cancelled OR Corrective;
                      Image=CreditMemo;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 ShowCanceledOrCorrCrMemo;
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
                ToolTipML=[DAN=Angiver det bogfõrte fakturanummer.;
                           ENU=Specifies the posted invoice number.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No.";
                Importance=Promoted;
                Editable=FALSE }

    { 61  ;2   ;Field     ;
                CaptionML=[DAN=Debitor;
                           ENU=Customer];
                ToolTipML=[DAN=Angiver navnet pÜ den debitor, som varerne i fakturaen er leveret til.;
                           ENU=Specifies the name of the customer that you shipped the items on the invoice to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Customer Name";
                TableRelation=Customer.Name;
                Importance=Promoted;
                Editable=FALSE }

    { 4   ;2   ;Group     ;
                CaptionML=[DAN=Kunde;
                           ENU=Sell-to];
                GroupType=Group }

    { 63  ;3   ;Field     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                ToolTipML=[DAN=Angiver adressen pÜ den debitor, som varerne i fakturaen er leveret til.;
                           ENU=Specifies the address of the customer that the items on the invoice were shipped to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Address";
                Importance=Additional;
                Editable=FALSE }

    { 65  ;3   ;Field     ;
                CaptionML=[DAN=Adresse 2;
                           ENU=Address 2];
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Address 2";
                Importance=Additional;
                Editable=FALSE }

    { 6   ;3   ;Field     ;
                CaptionML=[DAN=Postnr.;
                           ENU=Post Code];
                ToolTipML=[DAN=Angiver postnummer.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Post Code";
                Importance=Additional;
                Editable=FALSE }

    { 67  ;3   ;Field     ;
                CaptionML=[DAN=By;
                           ENU=City];
                ToolTipML=[DAN=Angiver debitorens by pÜ salgsdokumentet.;
                           ENU=Specifies the city of the customer on the sales document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to City";
                Importance=Additional;
                Editable=FALSE }

    { 96  ;3   ;Field     ;
                CaptionML=[DAN=Kontaktnr.;
                           ENU=Contact No.];
                ToolTipML=[DAN=Angiver nummeret pÜ den kontakt, som fakturaen er sendt til.;
                           ENU=Specifies the number of the contact that the invoice was sent to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Contact No.";
                Importance=Additional;
                Editable=FALSE }

    { 69  ;2   ;Field     ;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                ToolTipML=[DAN=Angiver navnet pÜ den person, der skal kontaktes hos den debitor, som varerne er leveret til.;
                           ENU=Specifies the name of the person to contact when you communicate with the customer who you shipped the items to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Contact";
                Editable=FALSE }

    { 1101100011;2;Field  ;
                ToolTipML=[DAN=Angiver telefonnummeret pÜ kontaktpersonen hos debitoren.;
                           ENU=Specifies the telephone number of the contact person at the customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Contact Phone No.";
                Editable=FALSE }

    { 1101100007;2;Field  ;
                ToolTipML=[DAN=Angiver faxnummeret pÜ kontaktpersonen hos debitoren.;
                           ENU=Specifies the fax number of the contact person at the customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Contact Fax No.";
                Editable=FALSE }

    { 1101100004;2;Field  ;
                ToolTipML=[DAN=Angiver mailadressen pÜ kontaktpersonen hos debitoren.;
                           ENU=Specifies the email address of the contact person at the customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Contact E-Mail";
                Editable=FALSE }

    { 1101100009;2;Field  ;
                ToolTipML=[DAN=Angiver rollen for kontaktpersonen hos debitoren.;
                           ENU=Specifies the role of the contact person at the customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Contact Role";
                Editable=FALSE }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor du oprettede salgsdokumentet.;
                           ENU=Specifies the date on which you created the sales document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Date";
                Importance=Additional;
                Editable=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor fakturaen blev bogfõrt.;
                           ENU=Specifies the date on which the invoice was posted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Posting Date";
                Editable=FALSE }

    { 68  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor fakturaen forfalder til betaling.;
                           ENU=Specifies the date on which the invoice is due for payment.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Due Date";
                Importance=Promoted;
                Editable=FALSE }

    { 3   ;2   ;Group     ;
                Visible=DocExcStatusVisible;
                GroupType=Group }

    { 27  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver status for dokumentet, hvis du bruger en dokumentudvekslingstjeneste til at sende det som et elektronisk dokument. Statusvërdierne rapporteres af dokumentudvekslingstjenesten.;
                           ENU=Specifies the status of the document if you are using a document exchange service to send it as an electronic document. The status values are reported by the document exchange service.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Exchange Status";
                Importance=Additional;
                Editable=FALSE;
                StyleExpr=DocExchStatusStyle;
                OnDrillDown=VAR
                              DocExchServDocStatus@1000 : Codeunit 1420;
                            BEGIN
                              DocExchServDocStatus.DocExchStatusDrillDown(Rec);
                            END;
                             }

    { 114 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ salgstilbudsdokumentet, hvis salgsprocessen tager udgangspunkt i et tilbud.;
                           ENU=Specifies the number of the sales quote document if a quote was used to start the sales process.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Quote No." }

    { 86  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den salgsordre, hvorfra fakturaen blev bogfõrt.;
                           ENU=Specifies the number of the sales order that this invoice was posted from.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Order No.";
                Importance=Promoted;
                Editable=FALSE }

    { 73  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ salgsdokumentet, som den bogfõrte faktura blev oprettet til.;
                           ENU=Specifies the number of the sales document that the posted invoice was created for.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pre-Assigned No.";
                Importance=Additional;
                Editable=FALSE }

    { 94  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det eksterne bilagsnummer, som angives i det salgshoved, som denne linje blev bogfõrt fra.;
                           ENU=Specifies the external document number that is entered on the sales header that this line was posted from.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="External Document No.";
                Importance=Additional;
                Editable=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken sëlger der er tilknyttet fakturaen.;
                           ENU=Specifies which salesperson is associated with the invoice.];
                ApplicationArea=#Suite;
                SourceExpr="Salesperson Code";
                Importance=Additional;
                Editable=FALSE }

    { 92  ;2   ;Field     ;
                AccessByPermission=TableData 5714=R;
                ToolTipML=[DAN=Angiver koden pÜ det ansvarscenter, der er knyttet til den bruger, der har oprettet fakturaen, dit regnskab eller debitoren i salgsfakturaen.;
                           ENU=Specifies the code of the responsibility center associated with the user who created the invoice, your company, or the customer in the sales invoice.];
                ApplicationArea=#Advanced;
                SourceExpr="Responsibility Center";
                Importance=Additional;
                Editable=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange gange bilaget er blevet udskrevet.;
                           ENU=Specifies how many times the document has been printed.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No. Printed";
                Importance=Additional;
                Editable=FALSE }

    { 77  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om den bogfõrte salgsfaktura er blevet rettet eller annulleret.;
                           ENU=Specifies if the posted sales invoice has been either corrected or canceled.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Cancelled;
                Importance=Additional;
                Visible=IsFoundationEnabled;
                Style=Unfavorable;
                StyleExpr=Cancelled;
                OnDrillDown=BEGIN
                              ShowCorrectiveCreditMemo;
                            END;
                             }

    { 102 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om den bogfõrte salgsfaktura er et rettelsesbilag.;
                           ENU=Specifies if the posted sales invoice is a corrective document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Corrective;
                Importance=Additional;
                Style=Unfavorable;
                StyleExpr=Corrective;
                OnDrillDown=BEGIN
                              ShowCancelledCreditMemo;
                            END;
                             }

    { 76  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om den bogfõrte faktura er betalt. Afkrydsningsfeltet er ogsÜ markeret, hvis der er oprettet en kreditnota for restbelõbet.;
                           ENU=Specifies if the posted invoice is paid. The check box will also be selected if a credit memo for the remaining amount has been applied.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Closed;
                Importance=Promoted }

    { 83  ;2   ;Group     ;
                CaptionML=[DAN=Arbejdsbeskrivelse;
                           ENU=Work Description];
                GroupType=Group }

    { 82  ;3   ;Field     ;
                ApplicationArea=#Advanced;
                SourceExpr=GetWorkDescription;
                Importance=Additional;
                Editable=FALSE;
                MultiLine=Yes;
                ShowCaption=No }

    { 54  ;1   ;Part      ;
                Name=SalesInvLines;
                ApplicationArea=#Basic,#Suite;
                SubPageLink=Document No.=FIELD(No.);
                PagePartID=Page133 }

    { 16  ;1   ;Group     ;
                CaptionML=[DAN=Fakturadetaljer;
                           ENU=Invoice Details];
                GroupType=Group }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver valutakoden for fakturaen.;
                           ENU=Specifies the currency code of the invoice.];
                ApplicationArea=#Suite;
                SourceExpr="Currency Code";
                Importance=Promoted;
                Editable=FALSE;
                OnAssistEdit=VAR
                               UpdateCurrencyFactor@1000 : Codeunit 325;
                             BEGIN
                               ChangeExchangeRate.SetParameter("Currency Code","Currency Factor","Posting Date");
                               ChangeExchangeRate.EDITABLE(FALSE);
                               IF ChangeExchangeRate.RUNMODAL = ACTION::OK THEN BEGIN
                                 "Currency Factor" := ChangeExchangeRate.GetParameter;
                                 UpdateCurrencyFactor.ModifyPostedSalesInvoice(Rec);
                               END;
                               CLEAR(ChangeExchangeRate);
                             END;
                              }

    { 62  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvornÜr varerne pÜ bilaget er sendt eller leveret. En afsendelsesdato beregnes normalt ud fra en õnsket leveringsdato plus leveringstiden.;
                           ENU=Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Shipment Date";
                Importance=Promoted;
                Editable=FALSE }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en formel, der beregner betalingens forfaldsdato, kontantrabatdato og kontantrabatbelõb pÜ salgsdokumentet.;
                           ENU=Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount on the sales document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Terms Code";
                Importance=Promoted;
                Editable=FALSE }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan debitoren skal betale for produkter i salgsdokumentet.;
                           ENU=Specifies how the customer must pay for products on the sales document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Method Code";
                Importance=Additional;
                Editable=FALSE }

    { 15  ;2   ;Group     ;
                Visible=PaymentServiceVisible;
                GroupType=Group }

    { 64  ;3   ;Field     ;
                Name=SelectedPayments;
                CaptionML=[DAN=Betalingstjeneste;
                           ENU=Payment Service];
                ToolTipML=[DAN=Angiver betalingstjenesten, f.eks. PayPal, som salgsfakturaen kan betales med.;
                           ENU=Specifies the payment service, such as PayPal, that the sales invoice can be paid with.];
                ApplicationArea=#All;
                SourceExpr=GetSelectedPaymentsText;
                Enabled=PaymentServiceEnabled;
                Editable=FALSE;
                MultiLine=Yes;
                OnAssistEdit=VAR
                               PaymentServiceSetup@1000 : Record 1060;
                             BEGIN
                               PaymentServiceSetup.ChangePaymentServicePostedInvoice(Rec);
                               CurrPage.UPDATE(FALSE);
                             END;
                              }

    { 66  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                Editable=FALSE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code";
                Editable=FALSE }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den rabatprocent, der tildeles, hvis betaling gennemfõres fõr eller pÜ den dato, der er angivet i feltet Kontantrabatdato.;
                           ENU=Specifies the payment discount percent granted if payment is made on or before the date in the Pmt. Discount Date field.];
                ApplicationArea=#Advanced;
                SourceExpr="Payment Discount %";
                Editable=FALSE }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor belõbet i posten skal vëre betalt, for at der kan opnÜs kontantrabat.;
                           ENU=Specifies the date on which the amount in the entry must be paid for a payment discount to be granted.];
                ApplicationArea=#Advanced;
                SourceExpr="Pmt. Discount Date";
                Importance=Additional;
                Editable=FALSE }

    { 70  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den Direct Debit-betalingsaftale, som debitoren har underskrevet for at tillade Direct Debit-opkrëvning af betalinger.;
                           ENU=Specifies the direct-debit mandate that the customer has signed to allow direct debit collection of payments.];
                ApplicationArea=#Advanced;
                SourceExpr="Direct Debit Mandate ID";
                Editable=FALSE }

    { 1060001;2;Field     ;
                ToolTipML=[DAN=Angiver betalingsmetoden Offentlig Information Online UBL (OIOUBL) for bilaget.;
                           ENU=Specifies the Offentlig Information Online UBL (OIOUBL) payment method for the document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Channel" }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden til den lokation, varerne er leveret fra.;
                           ENU=Specifies the code for the location from which the items were shipped.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Importance=Additional;
                Editable=FALSE }

    { 53  ;1   ;Group     ;
                CaptionML=[DAN=Forsendelse og fakturering;
                           ENU=Shipping and Billing];
                GroupType=Group }

    { 80  ;2   ;Group     ;
                CaptionML=[DAN=Leveringsoplysninger;
                           ENU=Shipping Details];
                GroupType=Group }

    { 71  ;3   ;Field     ;
                CaptionML=[DAN=Metode;
                           ENU=Method];
                ToolTipML=[DAN=Angiver koden for leveringsformen, der gëlder for fakturaen.;
                           ENU=Specifies the code that represents the shipment method for the invoice.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Shipment Method Code";
                Importance=Additional;
                Editable=FALSE }

    { 79  ;3   ;Field     ;
                CaptionML=[DAN=Speditõr;
                           ENU=Agent];
                ToolTipML=[DAN=Angiver, hvilken speditõr der bruges til at transportere varerne pÜ salgsbilaget til debitoren.;
                           ENU=Specifies which shipping agent is used to transport the items on the sales document to the customer.];
                ApplicationArea=#Suite;
                SourceExpr="Shipping Agent Code";
                Importance=Additional;
                Editable=FALSE }

    { 81  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver speditõrens pakkenummer.;
                           ENU=Specifies the shipping agent's package number.];
                ApplicationArea=#Suite;
                SourceExpr="Package Tracking No.";
                Importance=Additional;
                Editable=FALSE }

    { 1905885101;2;Group  ;
                CaptionML=[DAN=Leveres til;
                           ENU=Ship-to];
                GroupType=Group }

    { 56  ;3   ;Field     ;
                CaptionML=[DAN=Adressekode;
                           ENU=Address Code];
                ToolTipML=[DAN=Angiver adressen pÜ kõbsordrer, der leveres som en direkte levering direkte fra kreditoren til debitoren.;
                           ENU=Specifies the address on purchase orders shipped with a drop shipment directly from the vendor to a customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Code";
                Importance=Promoted;
                Editable=FALSE }

    { 46  ;3   ;Field     ;
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver navnet pÜ den debitor, som varerne er leveret til.;
                           ENU=Specifies the name of the customer that the items were shipped to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Name";
                Editable=FALSE }

    { 42  ;3   ;Field     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                ToolTipML=[DAN=Angiver den adresse, som varerne pÜ fakturaen er leveret til.;
                           ENU=Specifies the address that the items on the invoice were shipped to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Address";
                Editable=FALSE }

    { 44  ;3   ;Field     ;
                CaptionML=[DAN=Adresse 2;
                           ENU=Address 2];
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Address 2";
                Editable=FALSE }

    { 40  ;3   ;Field     ;
                CaptionML=[DAN=Postnr.;
                           ENU=Post Code];
                ToolTipML=[DAN=Angiver postnummer.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Post Code";
                Editable=FALSE }

    { 38  ;3   ;Field     ;
                CaptionML=[DAN=By;
                           ENU=City];
                ToolTipML=[DAN=Angiver debitorens by pÜ salgsdokumentet.;
                           ENU=Specifies the city of the customer on the sales document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to City";
                Editable=FALSE }

    { 36  ;3   ;Field     ;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                ToolTipML=[DAN=Angiver navnet pÜ den person, du normalt kontakter pÜ den adresse, som varerne er leveret til.;
                           ENU=Specifies the name of the person you regularly contact at the address that the items were shipped to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Contact";
                Editable=FALSE }

    { 60  ;2   ;Group     ;
                CaptionML=[DAN=Faktureres til;
                           ENU=Bill-to];
                GroupType=Group }

    { 18  ;3   ;Field     ;
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver navnet pÜ den debitor, fakturaen er sendt til.;
                           ENU=Specifies the name of the customer that the invoice was sent to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bill-to Name";
                Importance=Promoted;
                Editable=FALSE }

    { 20  ;3   ;Field     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                ToolTipML=[DAN=Angiver adressen pÜ den debitor, fakturaen er sendt til.;
                           ENU=Specifies the address of the customer that the invoice was sent to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bill-to Address";
                Importance=Additional;
                Editable=FALSE }

    { 22  ;3   ;Field     ;
                CaptionML=[DAN=Adresse 2;
                           ENU=Address 2];
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bill-to Address 2";
                Importance=Additional;
                Editable=FALSE }

    { 78  ;3   ;Field     ;
                CaptionML=[DAN=Postnr.;
                           ENU=Post Code];
                ToolTipML=[DAN=Angiver postnummer.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bill-to Post Code";
                Importance=Additional;
                Editable=FALSE }

    { 24  ;3   ;Field     ;
                CaptionML=[DAN=By;
                           ENU=City];
                ToolTipML=[DAN=Angiver debitorens by pÜ salgsdokumentet.;
                           ENU=Specifies the city of the customer on the sales document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bill-to City";
                Importance=Additional;
                Editable=FALSE }

    { 98  ;3   ;Field     ;
                CaptionML=[DAN=Kontaktnr.;
                           ENU=Contact No.];
                ToolTipML=[DAN=Angiver nummeret pÜ den kontakt, som fakturaen er sendt til.;
                           ENU=Specifies the number of the contact the invoice was sent to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bill-to Contact No.";
                Importance=Additional;
                Editable=FALSE }

    { 26  ;3   ;Field     ;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                ToolTipML=[DAN=Angiver navnet pÜ den person, du normalt kontakter hos den debitor, fakturaen er sendt til.;
                           ENU=Specifies the name of the person you regularly contact when you communicate with the customer to whom the invoice was sent.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bill-to Contact";
                Editable=FALSE }

    { 1101100000;2;Field  ;
                ToolTipML=[DAN=Angiver EAN-lokationsnummeret for debitoren, baseret pÜ feltet EAN-nr. i den oprindelige salgsordre.;
                           ENU=Specifies the EAN location number for the customer, based on the EAN No. field in the original sales order.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="EAN No.";
                Editable=FALSE }

    { 1101100002;2;Field  ;
                ToolTipML=[DAN=Angiver kontokoden for den debitor, som du vil sende fakturaen til.;
                           ENU=Specifies the account code of the customer who you will send the invoice to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Account Code";
                Editable=FALSE }

    { 1060002;2;Field     ;
                ToolTipML=[DAN=Angiver den profil, som debitoren krëver til elektroniske dokumenter.;
                           ENU=Specifies the profile that this customer requires for electronic documents.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="OIOUBL Profile Code";
                Editable=FALSE }

    { 1907468901;1;Group  ;
                CaptionML=[DAN=Udenrigshandel;
                           ENU=Foreign Trade] }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om fakturaen er en del af en EU-trekantshandel.;
                           ENU=Specifies whether the invoice was part of an EU 3-party trade transaction.];
                ApplicationArea=#Advanced;
                SourceExpr="EU 3-Party Trade";
                Editable=FALSE }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den transaktionsspecifikation, som blev brugt pÜ fakturaen.;
                           ENU=Specifies the transaction specification that was used in the invoice.];
                ApplicationArea=#Advanced;
                SourceExpr="Transaction Specification";
                Editable=FALSE }

    { 72  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver transportmÜden for det salgshoved, som linjen blev bogfõrt fra.;
                           ENU=Specifies the transport method of the sales header that this line was posted from.];
                ApplicationArea=#Advanced;
                SourceExpr="Transport Method";
                Editable=FALSE }

    { 74  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det udfõrselssted, hvor varerne blev udfõrt af landet/omrÜdet med henblik pÜ rapportering til Intrastat.;
                           ENU=Specifies the point of exit through which you ship the items out of your country/region, for reporting to Intrastat.];
                ApplicationArea=#Advanced;
                SourceExpr="Exit Point";
                Editable=FALSE }

    { 75  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den omrÜdekode, der bruges pÜ fakturaen.;
                           ENU=Specifies the area code used in the invoice.];
                ApplicationArea=#Advanced;
                SourceExpr=Area;
                Editable=FALSE }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 11  ;1   ;Part      ;
                Name=IncomingDocAttachFactBox;
                ApplicationArea=#Advanced;
                PagePartID=Page193;
                Visible=FALSE;
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
      ApplicationAreaSetup@1010 : Record 9178;
      SalesInvHeader@1000 : Record 112;
      CRMIntegrationManagement@1012 : Codeunit 5330;
      ChangeExchangeRate@1001 : Page 511;
      HasIncomingDocument@1002 : Boolean;
      DocExchStatusStyle@1003 : Text;
      CRMIntegrationEnabled@1004 : Boolean;
      CRMIsCoupledToRecord@1005 : Boolean;
      PaymentServiceVisible@1007 : Boolean;
      PaymentServiceEnabled@1008 : Boolean;
      DocExcStatusVisible@1006 : Boolean;
      IsOfficeAddin@1009 : Boolean;
      IsFoundationEnabled@1011 : Boolean;

    LOCAL PROCEDURE UpdatePaymentService@7();
    VAR
      PaymentServiceSetup@1000 : Record 1060;
    BEGIN
      PaymentServiceVisible := PaymentServiceSetup.IsPaymentServiceVisible;
      PaymentServiceEnabled := PaymentServiceSetup.CanChangePaymentService(Rec);
    END;

    BEGIN
    END.
  }
}

