OBJECT Page 134 Posted Sales Credit Memo
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572,NAVDK11.00.00.23572;
  }
  PROPERTIES
  {
    Permissions=TableData 114=rd;
    CaptionML=[DAN=Bogf�rt salgskreditnota;
               ENU=Posted Sales Credit Memo];
    InsertAllowed=No;
    SourceTable=Table114;
    PageType=Document;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Kreditnota,Annuller;
                                ENU=New,Process,Report,Cr. Memo,Cancel];
    OnOpenPage=VAR
                 OfficeMgt@1000 : Codeunit 1630;
               BEGIN
                 SetSecurityFilterOnRespCenter;
                 IsOfficeAddin := OfficeMgt.IsAvailable;
                 IsFoundationEnabled := ApplicationAreaSetup.IsFoundationEnabled;
               END;

    OnAfterGetRecord=BEGIN
                       DocExchStatusStyle := GetDocExchStatusStyle;
                     END;

    OnAfterGetCurrRecord=VAR
                           IncomingDocument@1000 : Record 130;
                         BEGIN
                           HasIncomingDocument := IncomingDocument.PostedDocExists("No.","Posting Date");
                           DocExchStatusStyle := GetDocExchStatusStyle;
                           DocExchStatusVisible := DocExchangeStatusIsSent;
                           CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 47      ;1   ;ActionGroup;
                      CaptionML=[DAN=Kr&editnota;
                                 ENU=&Cr. Memo];
                      Image=CreditMemo }
      { 9       ;2   ;Action    ;
                      Name=Statistics;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=F� vist statistiske oplysninger om recorden, f.eks. v�rdien af bogf�rte poster.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 398;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Statistics;
                      PromotedCategory=Category4 }
      { 49      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m�rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf�j bem�rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 67;
                      RunPageLink=Document Type=CONST(Posted Credit Memo),
                                  No.=FIELD(No.),
                                  Document Line No.=CONST(0);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ViewComments;
                      PromotedCategory=Category4 }
      { 77      ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr�de, projekt eller afdeling, som du kan tildele til salgs- og k�bsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Dimensions;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 ShowDimensions;
                               END;
                                }
      { 92      ;2   ;Action    ;
                      AccessByPermission=TableData 456=R;
                      CaptionML=[DAN=Godkendelser;
                                 ENU=Approvals];
                      ToolTipML=[DAN=F� vist en liste over records, der afventer godkendelse. Du kan f.eks. se, hvem der har anmodet om godkendelse af recorden, hvorn�r den blev sendt og hvorn�r den skal godkendes.;
                                 ENU=View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.];
                      ApplicationArea=#Suite;
                      Image=Approvals;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.ShowPostedApprovalEntries(RECORDID);
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 90      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 1060000 ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Opret elektronisk kreditnota;
                                 ENU=Create Electronic Credit Memo];
                      ToolTipML=[DAN=Opret en elektronisk version af det aktuelle dokument.;
                                 ENU=Create an electronic version of the current document.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=ElectronicDoc;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 SalesCrMemoHeader := Rec;
                                 SalesCrMemoHeader.SETRECFILTER;

                                 REPORT.RUNMODAL(REPORT::"Create Electronic Credit Memos",TRUE,FALSE,SalesCrMemoHeader);
                               END;
                                }
      { 3       ;1   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Debitor;
                                 ENU=Customer];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om debitoren.;
                                 ENU=View or edit detailed information about the customer.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 21;
                      RunPageLink=No.=FIELD(Sell-to Customer No.);
                      Promoted=Yes;
                      Image=Customer;
                      PromotedCategory=Process }
      { 8       ;1   ;Action    ;
                      Name=SendCustom;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Send;
                                 ENU=Send];
                      ToolTipML=[DAN=Klarg�r bilaget til afsendelse i henhold til debitorens afsendelsesprofil, f.eks. vedh�ftet en mail. Vinduet Send dokument til vises, s� du kan bekr�fte eller v�lge en afsendelsesprofil.;
                                 ENU=Prepare to send the document according to the customer's sending profile, such as attached to an email. The Send document to window opens first so you can confirm or select a sending profile.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=SendToMultiple;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 SalesCrMemoHeader@1000 : Record 114;
                               BEGIN
                                 SalesCrMemoHeader := Rec;
                                 CurrPage.SETSELECTIONFILTER(SalesCrMemoHeader);
                                 SalesCrMemoHeader.SendRecords;
                               END;
                                }
      { 50      ;1   ;Action    ;
                      Name=Print;
                      Ellipsis=Yes;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=Forbered udskrivning af bilaget. Du f�r vist et anmodningsvindue for bilaget, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.];
                      ApplicationArea=#Basic,#Suite;
                      Visible=NOT IsOfficeAddin;
                      Image=Print;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 SalesCrMemoHeader := Rec;
                                 CurrPage.SETSELECTIONFILTER(SalesCrMemoHeader);
                                 SalesCrMemoHeader.PrintRecords(TRUE);
                               END;
                                }
      { 11      ;1   ;Action    ;
                      CaptionML=[DAN=Send via &mail;
                                 ENU=Send by &Email];
                      ToolTipML=[DAN=Send salgskreditnotabilaget som en PDF-fil, der er vedh�ftet en mail.;
                                 ENU=Send the sales credit memo document as a PDF file attached to an email.];
                      ApplicationArea=#All;
                      Image=Email;
                      OnAction=BEGIN
                                 SalesCrMemoHeader := Rec;
                                 CurrPage.SETSELECTIONFILTER(SalesCrMemoHeader);
                                 SalesCrMemoHeader.EmailRecords(TRUE);
                               END;
                                }
      { 51      ;1   ;Action    ;
                      CaptionML=[DAN=N&aviger;
                                 ENU=&Navigate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes til bilagsnummeret og bogf�ringsdatoen p� den valgte post eller det valgte dokument.;
                                 ENU=Find all entries and documents that exist for the document number and posting date on the selected entry or document.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=NOT IsOfficeAddin;
                      PromotedIsBig=Yes;
                      Image=Navigate;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 Navigate;
                               END;
                                }
      { 15      ;1   ;Action    ;
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
      { 39      ;1   ;ActionGroup;
                      CaptionML=[DAN=Annuller;
                                 ENU=Cancel] }
      { 35      ;2   ;Action    ;
                      Name=CancelCrMemo;
                      CaptionML=[DAN=Annuller;
                                 ENU=Cancel];
                      ToolTipML=[DAN=Opret og bogf�r en faktura, der tilbagef�rer denne bogf�rte salgskreditnota. Denne bogf�rte salgskreditnota annulleres.;
                                 ENU=Create and post a sales invoice that reverses this posted sales credit memo. This posted sales credit memo will be canceled.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=IsFoundationEnabled;
                      PromotedIsBig=Yes;
                      Image=Cancel;
                      PromotedCategory=Category5;
                      OnAction=BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Cancel PstdSalesCrM (Yes/No)",Rec);
                               END;
                                }
      { 33      ;2   ;Action    ;
                      Name=ShowInvoice;
                      CaptionML=[DAN=Vis annulleret faktura/rettelsesfaktura;
                                 ENU=Show Canceled/Corrective Invoice];
                      ToolTipML=[DAN=�bn den bogf�rte salgsfaktura, som blev oprettet, da du annullerede den bogf�rte salgskreditnota. Hvis den bogf�rte salgskreditnota er resultatet af en annulleret salgsfaktura, �bnes den annullerede faktura.;
                                 ENU=Open the posted sales invoice that was created when you canceled the posted sales credit memo. If the posted sales credit memo is the result of a canceled sales invoice, then canceled invoice will open.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=IsFoundationEnabled;
                      Enabled=Cancelled OR Corrective;
                      PromotedIsBig=Yes;
                      Image=Invoice;
                      PromotedCategory=Category5;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 ShowCanceledOrCorrInvoice;
                               END;
                                }
      { 21      ;1   ;ActionGroup;
                      Name=IncomingDocument;
                      CaptionML=[DAN=Indg�ende bilag;
                                 ENU=Incoming Document];
                      ActionContainerType=NewDocumentItems;
                      Image=Documents }
      { 23      ;2   ;Action    ;
                      Name=IncomingDocCard;
                      CaptionML=[DAN=Vis indg�ende bilag;
                                 ENU=View Incoming Document];
                      ToolTipML=[DAN=Se alle indg�ende bilagsrecords og vedh�ftede filer, der findes for posten eller bilaget.;
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
      { 17      ;2   ;Action    ;
                      Name=SelectIncomingDoc;
                      AccessByPermission=TableData 130=R;
                      CaptionML=[DAN=V�lg indg�ende bilag;
                                 ENU=Select Incoming Document];
                      ToolTipML=[DAN=V�lg en indg�ende bilagsrecord og vedh�ftet fil, der skal knyttes til posten eller bilaget.;
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
      { 19      ;2   ;Action    ;
                      Name=IncomingDocAttachFile;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Opret indg�ende bilag ud fra fil;
                                 ENU=Create Incoming Document from File];
                      ToolTipML=[DAN=Opret en indg�ende bilagsrecord ved at v�lge en fil, der skal vedh�ftes, og knyt derefter den indg�ende bilagsrecord til posten eller bilaget.;
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
                ToolTipML=[DAN=Angiver nummeret p� den bogf�rte kreditnota.;
                           ENU=Specifies the posted credit memo number.];
                ApplicationArea=#All;
                SourceExpr="No.";
                Importance=Promoted;
                Editable=FALSE }

    { 53  ;2   ;Field     ;
                CaptionML=[DAN=Debitor;
                           ENU=Customer];
                ToolTipML=[DAN=Angiver navnet p� den debitor, som varerne i kreditnotaen er leveret til.;
                           ENU=Specifies the name of the customer that you shipped the items on the credit memo to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Customer Name";
                TableRelation=Customer.Name;
                Editable=FALSE;
                ShowMandatory=TRUE }

    { 4   ;2   ;Group     ;
                CaptionML=[DAN=Kunde;
                           ENU=Sell-to];
                GroupType=Group }

    { 55  ;3   ;Field     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                ToolTipML=[DAN=Angiver adressen p� den debitor, som varerne i kreditnotaen er sendt til.;
                           ENU=Specifies the address of the customer that the items on the credit memo were sent to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Address";
                Importance=Additional;
                Editable=FALSE }

    { 57  ;3   ;Field     ;
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

    { 59  ;3   ;Field     ;
                CaptionML=[DAN=By;
                           ENU=City];
                ToolTipML=[DAN=Angiver debitorens by p� salgsdokumentet.;
                           ENU=Specifies the city of the customer on the sales document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to City";
                Importance=Additional;
                Editable=FALSE }

    { 95  ;3   ;Field     ;
                CaptionML=[DAN=Kontaktnr.;
                           ENU=Contact No.];
                ToolTipML=[DAN=Angiver nummeret p� kontaktpersonen hos den debitor, der h�ndterer kreditnotaen.;
                           ENU=Specifies the number of the contact at the customer who handles the credit memo.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Contact No.";
                Importance=Additional;
                Editable=FALSE }

    { 61  ;2   ;Field     ;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                ToolTipML=[DAN=Angiver navnet p� den person, der skal kontaktes hos den debitor, som varerne p� kreditnotaen er leveret til.;
                           ENU=Specifies the name of the person to contact when you communicate with the customer who you shipped the items on the credit memo to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Contact";
                Editable=FALSE }

    { 1060006;2;Field     ;
                ToolTipML=[DAN="Angiver telefonnummeret p� kontaktpersonen hos debitoren. ";
                           ENU="Specifies the telephone number of the contact person at the customer. "];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Contact Phone No.";
                Editable=FALSE }

    { 1060002;2;Field     ;
                ToolTipML=[DAN="Angiver faxnummeret p� kontaktpersonen hos debitoren. ";
                           ENU="Specifies the fax number of the contact person at the customer. "];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Contact Fax No.";
                Editable=FALSE }

    { 1060009;2;Field     ;
                ToolTipML=[DAN="Angiver mailadressen p� kontaktpersonen hos debitoren. ";
                           ENU="Specifies the email address of the contact person at the customer. "];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Contact E-Mail";
                Editable=FALSE }

    { 1060004;2;Field     ;
                ToolTipML=[DAN="Angiver rollen for kontaktpersonen hos debitoren. ";
                           ENU="Specifies the role of the contact person at the customer. "];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Contact Role";
                Editable=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor kreditnotaen blev bogf�rt.;
                           ENU=Specifies the date on which the credit memo was posted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Posting Date";
                Importance=Promoted;
                Editable=FALSE }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor du oprettede salgsdokumentet.;
                           ENU=Specifies the date on which you created the sales document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Date";
                Editable=FALSE }

    { 20  ;2   ;Group     ;
                Visible=DocExchStatusVisible;
                GroupType=Group }

    { 25  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver status for dokumentet, hvis du bruger en dokumentudvekslingstjeneste til at sende det som et elektronisk dokument. Statusv�rdierne rapporteres af dokumentudvekslingstjenesten.;
                           ENU=Specifies the status of the document if you are using a document exchange service to send it as an electronic document. The status values are reported by the document exchange service.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Exchange Status";
                Editable=FALSE;
                StyleExpr=DocExchStatusStyle;
                OnDrillDown=VAR
                              DocExchServDocStatus@1000 : Codeunit 1420;
                            BEGIN
                              DocExchServDocStatus.DocExchStatusDrillDown(Rec);
                            END;
                             }

    { 65  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den kreditnota, som den bogf�rte kreditnota er oprettet fra.;
                           ENU=Specifies the number of the credit memo that the posted credit memo was created from.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pre-Assigned No.";
                Importance=Additional;
                Editable=FALSE }

    { 84  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det eksterne bilagsnummer, som angives i det salgshoved, som denne linje blev bogf�rt fra.;
                           ENU=Specifies the external document number that is entered on the sales header that this line was posted from.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="External Document No.";
                Importance=Promoted;
                Editable=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken s�lger der er tilknyttet kreditnotaen.;
                           ENU=Specifies which salesperson is associated with the credit memo.];
                ApplicationArea=#Suite;
                SourceExpr="Salesperson Code";
                Importance=Additional;
                Editable=FALSE }

    { 80  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for det ansvarscenter, der betjener den p�g�ldende debitor p� dette salgsdokument.;
                           ENU=Specifies the code for the responsibility center that serves the customer on this sales document.];
                ApplicationArea=#Advanced;
                SourceExpr="Responsibility Center";
                Importance=Additional;
                Editable=FALSE }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om den bogf�rte salgsfaktura, der vedr�rer denne salgskreditnota, er rettet eller annulleret.;
                           ENU=Specifies if the posted sales invoice that relates to this sales credit memo has been either corrected or canceled.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Cancelled;
                Importance=Additional;
                Style=Unfavorable;
                StyleExpr=Cancelled;
                OnDrillDown=BEGIN
                              ShowCorrectiveInvoice;
                            END;
                             }

    { 37  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om den bogf�rte salgsfaktura er rettet eller annulleret af denne salgskreditnota.;
                           ENU=Specifies if the posted sales invoice has been either corrected or canceled by this sales credit memo.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Corrective;
                Importance=Additional;
                Style=Unfavorable;
                StyleExpr=Corrective;
                OnDrillDown=BEGIN
                              ShowCancelledInvoice;
                            END;
                             }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange gange bilaget er blevet udskrevet.;
                           ENU=Specifies how many times the document has been printed.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No. Printed";
                Importance=Additional;
                Editable=FALSE }

    { 46  ;1   ;Part      ;
                Name=SalesCrMemoLines;
                ApplicationArea=#Basic,#Suite;
                SubPageLink=Document No.=FIELD(No.);
                PagePartID=Page135 }

    { 1905885101;1;Group  ;
                CaptionML=[DAN=Fakturadetaljer;
                           ENU=Invoice Details];
                GroupType=Group }

    { 75  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver valutakoden for kreditnotaen.;
                           ENU=Specifies the currency code of the credit memo.];
                ApplicationArea=#Suite;
                SourceExpr="Currency Code";
                Importance=Promoted;
                OnAssistEdit=VAR
                               UpdateCurrencyFactor@1000 : Codeunit 325;
                             BEGIN
                               ChangeExchangeRate.SetParameter("Currency Code","Currency Factor","Posting Date");
                               ChangeExchangeRate.EDITABLE(FALSE);
                               IF ChangeExchangeRate.RUNMODAL = ACTION::OK THEN BEGIN
                                 "Currency Factor" := ChangeExchangeRate.GetParameter;
                                 UpdateCurrencyFactor.ModifyPostedSalesCreditMemo(Rec);
                               END;
                               CLEAR(ChangeExchangeRate);
                             END;
                              }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops�tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 1 Code";
                Editable=FALSE }

    { 66  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops�tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 2 Code";
                Editable=FALSE }

    { 68  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken lokation kreditnotaen er registreret p�.;
                           ENU=Specifies the location where the credit memo was registered.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Importance=Promoted;
                Editable=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den type bogf�rt bilag, som dette bilag eller denne kladdelinje udlignes med, n�r du bogf�rer, f.eks. til registrering af betaling.;
                           ENU=Specifies the type of the posted document that this document or journal line will be applied to when you post, for example to register payment.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Applies-to Doc. Type";
                Importance=Promoted;
                Editable=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� det bogf�rte bilag, som dette bilag eller denne kladdelinje udlignes p�, n�r du bogf�rer, f.eks. til registrering af betaling.;
                           ENU=Specifies the number of the posted document that this document or journal line will be applied to when you post, for example to register payment.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Applies-to Doc. No.";
                Importance=Promoted;
                Editable=FALSE }

    { 282 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitorens betalingsform. Koden kopieres automatisk fra feltet Betalingsformskode p� salgshovedet.;
                           ENU=Specifies the customer's method of payment. The program has copied the code from the Payment Method Code field on the sales header.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Method Code";
                Editable=FALSE }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om fakturaen er en del af en EU-trekantshandel.;
                           ENU=Specifies whether the invoice was part of an EU 3-party trade transaction.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="EU 3-Party Trade";
                Editable=FALSE }

    { 1906801201;1;Group  ;
                CaptionML=[DAN=Forsendelse og fakturering;
                           ENU=Shipping and Billing];
                GroupType=Group }

    { 5   ;2   ;Group     ;
                CaptionML=[DAN=Leveres til;
                           ENU=Ship-to];
                GroupType=Group }

    { 34  ;3   ;Field     ;
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver navnet p� den debitor, som varerne er leveret til.;
                           ENU=Specifies the name of the customer that the items were shipped to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Name";
                Editable=FALSE }

    { 36  ;3   ;Field     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                ToolTipML=[DAN=Angiver den adresse, som varerne er leveret til.;
                           ENU=Specifies the address that the items were shipped to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Address";
                Editable=FALSE }

    { 38  ;3   ;Field     ;
                CaptionML=[DAN=Adresse 2;
                           ENU=Address 2];
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Address 2";
                Editable=FALSE }

    { 72  ;3   ;Field     ;
                CaptionML=[DAN=Postnr.;
                           ENU=Post Code];
                ToolTipML=[DAN=Angiver postnummer.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Post Code";
                Editable=FALSE }

    { 40  ;3   ;Field     ;
                CaptionML=[DAN=By;
                           ENU=City];
                ToolTipML=[DAN=Angiver debitorens by p� salgsdokumentet.;
                           ENU=Specifies the city of the customer on the sales document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to City";
                Editable=FALSE }

    { 42  ;3   ;Field     ;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                ToolTipML=[DAN=Angiver navnet p� den person, du normalt kontakter hos den debitor, som varerne er leveret til.;
                           ENU=Specifies the name of the person you regularly contact at the customer to whom the items were shipped.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Contact";
                Editable=FALSE }

    { 27  ;2   ;Group     ;
                CaptionML=[DAN=Faktureres til;
                           ENU=Bill-to];
                GroupType=Group }

    { 22  ;3   ;Field     ;
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver navnet p� den debitor, kreditnotaen er sendt til.;
                           ENU=Specifies the name of the customer that the credit memo was sent to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bill-to Name";
                Importance=Promoted;
                Editable=FALSE }

    { 24  ;3   ;Field     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                ToolTipML=[DAN=Angiver adressen p� den debitor, kreditnotaen er sendt til.;
                           ENU=Specifies the address of the customer that the credit memo was sent to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bill-to Address";
                Importance=Additional;
                Editable=FALSE }

    { 26  ;3   ;Field     ;
                CaptionML=[DAN=Adresse 2;
                           ENU=Address 2];
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bill-to Address 2";
                Importance=Additional;
                Editable=FALSE }

    { 70  ;3   ;Field     ;
                CaptionML=[DAN=Postnr.;
                           ENU=Post Code];
                ToolTipML=[DAN=Angiver postnummer.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bill-to Post Code";
                Importance=Additional;
                Editable=FALSE }

    { 28  ;3   ;Field     ;
                CaptionML=[DAN=By;
                           ENU=City];
                ToolTipML=[DAN=Angiver debitorens by p� salgsdokumentet.;
                           ENU=Specifies the city of the customer on the sales document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bill-to City";
                Importance=Additional;
                Editable=FALSE }

    { 97  ;3   ;Field     ;
                CaptionML=[DAN=Kontaktnr.;
                           ENU=Contact No.];
                ToolTipML=[DAN=Angiver nummeret p� kontaktpersonen hos den debitor, der h�ndterer kreditnotaen.;
                           ENU=Specifies the number of the contact at the customer who handles the credit memo.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bill-to Contact No.";
                Importance=Additional;
                Editable=FALSE }

    { 30  ;3   ;Field     ;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                ToolTipML=[DAN=Angiver navnet p� den person, du normalt kontakter hos den debitor, kreditnotaen er sendt til.;
                           ENU=Specifies the name of the person you regularly contact when you communicate with the customer to whom the credit memo was sent.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bill-to Contact";
                Editable=FALSE }

    { 1060011;2;Field     ;
                ToolTipML=[DAN=Angiver EAN-lokationsnummeret for debitoren, baseret p� feltet EAN-nr. i den relevante salgsreturordre eller salgskreditnota.;
                           ENU=Specifies the EAN location number for the customer, based on the EAN No. field in the relevant sales return order or sales credit memo.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="EAN No.";
                Editable=FALSE }

    { 1060013;2;Field     ;
                ToolTipML=[DAN="Angiver kontokoden for den debitor, som du vil sende kreditnotaen til. ";
                           ENU="Specifies the account code of the customer who you will send the credit memo to. "];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Account Code";
                Editable=FALSE }

    { 1060001;2;Field     ;
                ToolTipML=[DAN=Angiver den profil, som debitoren kr�ver til elektroniske dokumenter.;
                           ENU=Specifies the profile that this customer requires for electronic documents.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="OIOUBL Profile Code";
                Editable=FALSE }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 13  ;1   ;Part      ;
                Name=IncomingDocAttachFactBox;
                ApplicationArea=#Basic,#Suite;
                PagePartID=Page193;
                Visible=NOT IsOfficeAddin;
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
      ApplicationAreaSetup@1006 : Record 9178;
      SalesCrMemoHeader@1000 : Record 114;
      ChangeExchangeRate@1001 : Page 511;
      HasIncomingDocument@1002 : Boolean;
      DocExchStatusStyle@1003 : Text;
      DocExchStatusVisible@1004 : Boolean;
      IsOfficeAddin@1005 : Boolean;
      IsFoundationEnabled@1007 : Boolean;

    BEGIN
    END.
  }
}

