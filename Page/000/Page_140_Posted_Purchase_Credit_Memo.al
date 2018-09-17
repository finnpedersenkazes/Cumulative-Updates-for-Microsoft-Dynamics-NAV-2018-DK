OBJECT Page 140 Posted Purchase Credit Memo
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Bogfõrt kõbskreditnota;
               ENU=Posted Purchase Credit Memo];
    InsertAllowed=No;
    SourceTable=Table124;
    PageType=Document;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Annuller;
                                ENU=New,Process,Report,Cancel];
    OnOpenPage=VAR
                 OfficeMgt@1000 : Codeunit 1630;
               BEGIN
                 SetSecurityFilterOnRespCenter;
                 IsOfficeAddin := OfficeMgt.IsAvailable;
                 IsFoundationEnabled := ApplicationAreaSetup.IsFoundationEnabled;
               END;

    OnAfterGetCurrRecord=VAR
                           IncomingDocument@1000 : Record 130;
                         BEGIN
                           HasIncomingDocument := IncomingDocument.PostedDocExists("No.","Posting Date");
                           CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 45      ;1   ;ActionGroup;
                      CaptionML=[DAN=Kr&editnota;
                                 ENU=&Cr. Memo];
                      Image=CreditMemo }
      { 8       ;2   ;Action    ;
                      Name=Statistics;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=FÜ vist statistiske oplysninger om recorden, f.eks. vërdien af bogfõrte poster.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 401;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 47      ;2   ;Action    ;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 66;
                      RunPageLink=Document Type=CONST(Posted Credit Memo),
                                  No.=FIELD(No.),
                                  Document Line No.=CONST(0);
                      Image=ViewComments }
      { 79      ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omrÜde, projekt eller afdeling, som du kan tildele til salgs- og kõbsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                               END;
                                }
      { 88      ;2   ;Action    ;
                      AccessByPermission=TableData 456=R;
                      CaptionML=[DAN=Godkendelser;
                                 ENU=Approvals];
                      ToolTipML=[DAN=FÜ vist en liste over records, der afventer godkendelse. Du kan f.eks. se, hvem der har anmodet om godkendelse af recorden, hvornÜr den blev sendt og hvornÜr den skal godkendes.;
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
      { 15      ;1   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kreditor;
                                 ENU=Vendor];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om kreditoren i kõbsdokumentet.;
                                 ENU=View or edit detailed information about the vendor on the purchase document.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 26;
                      RunPageLink=No.=FIELD(Buy-from Vendor No.);
                      Promoted=Yes;
                      Image=Vendor;
                      PromotedCategory=Process }
      { 48      ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=Forbered udskrivning af bilaget. Du fÜr vist et anmodningsvindue for bilaget, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=NOT IsOfficeAddin;
                      Image=Print;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CurrPage.SETSELECTIONFILTER(PurchCrMemoHeader);
                                 PurchCrMemoHeader.PrintRecords(TRUE);
                               END;
                                }
      { 49      ;1   ;Action    ;
                      CaptionML=[DAN=&Naviger;
                                 ENU=&Navigate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes til bilagsnummeret og bogfõringsdatoen pÜ den valgte post eller det valgte dokument.;
                                 ENU=Find all entries and documents that exist for the document number and posting date on the selected entry or document.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=NOT IsOfficeAddin;
                      Image=Navigate;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Navigate;
                               END;
                                }
      { 29      ;1   ;ActionGroup;
                      CaptionML=[DAN=Annuller;
                                 ENU=Cancel] }
      { 24      ;2   ;Action    ;
                      Name=CancelCrMemo;
                      CaptionML=[DAN=Annuller;
                                 ENU=Cancel];
                      ToolTipML=[DAN=Opret og bogfõr en kõbsfaktura, der tilbagefõrer denne bogfõrte kõbskreditnota. Denne bogfõrte kõbskreditnota bliver annulleret.;
                                 ENU=Create and post a purchase invoice that reverses this posted purchase credit memo. This posted purchase credit memo will be canceled.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=IsFoundationEnabled;
                      PromotedIsBig=Yes;
                      Image=Cancel;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Cancel PstdPurchCrM (Yes/No)",Rec);
                               END;
                                }
      { 27      ;2   ;Action    ;
                      Name=ShowInvoice;
                      CaptionML=[DAN=Vis annulleret faktura/rettelsesfaktura;
                                 ENU=Show Canceled/Corrective Invoice];
                      ToolTipML=[DAN=èbn den bogfõrte salgsfaktura, som blev oprettet, da du annullerede den bogfõrte salgskreditnota. Hvis den bogfõrte salgskreditnota er resultatet af en annulleret salgsfaktura, Übnes den annullerede faktura.;
                                 ENU=Open the posted sales invoice that was created when you canceled the posted sales credit memo. If the posted sales credit memo is the result of a canceled sales invoice, then canceled invoice will open.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=IsFoundationEnabled;
                      Enabled=Cancelled OR Corrective;
                      PromotedIsBig=Yes;
                      Image=Invoice;
                      PromotedCategory=Category4;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 ShowCanceledOrCorrInvoice;
                               END;
                                }
      { 13      ;1   ;ActionGroup;
                      Name=IncomingDocument;
                      CaptionML=[DAN=IndgÜende bilag;
                                 ENU=Incoming Document];
                      ActionContainerType=NewDocumentItems;
                      Image=Documents }
      { 11      ;2   ;Action    ;
                      Name=IncomingDocCard;
                      CaptionML=[DAN=Vis indgÜende bilag;
                                 ENU=View Incoming Document];
                      ToolTipML=[DAN=Se alle indgÜende bilagsrecords og vedhëftede filer, der findes for posten eller bilaget.;
                                 ENU=View any incoming document records and file attachments that exist for the entry or document.];
                      ApplicationArea=#Basic,#Suite;
                      Visible=NOT IsOfficeAddin;
                      Enabled=HasIncomingDocument;
                      Image=ViewOrder;
                      OnAction=VAR
                                 IncomingDocument@1000 : Record 130;
                               BEGIN
                                 IncomingDocument.ShowCard("No.","Posting Date");
                               END;
                                }
      { 9       ;2   ;Action    ;
                      Name=SelectIncomingDoc;
                      AccessByPermission=TableData 130=R;
                      CaptionML=[DAN=Vëlg indgÜende bilag;
                                 ENU=Select Incoming Document];
                      ToolTipML=[DAN=Vëlg en indgÜende bilagsrecord og vedhëftet fil, der skal knyttes til posten eller bilaget.;
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
      { 5       ;2   ;Action    ;
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
                ToolTipML=[DAN=Angiver nummeret pÜ den bogfõrte kreditnota.;
                           ENU=Specifies the posted credit memo number.];
                ApplicationArea=#All;
                SourceExpr="No.";
                Importance=Promoted;
                Editable=FALSE }

    { 51  ;2   ;Field     ;
                CaptionML=[DAN=Kreditor;
                           ENU=Vendor];
                ToolTipML=[DAN=Angiver navnet pÜ den kreditor, der leverede varerne.;
                           ENU=Specifies the name of the vendor who shipped the items.];
                ApplicationArea=#All;
                SourceExpr="Buy-from Vendor Name";
                TableRelation=Vendor.Name;
                Importance=Promoted;
                Editable=FALSE }

    { 4   ;2   ;Group     ;
                CaptionML=[DAN=Leverandõr;
                           ENU=Buy-from];
                GroupType=Group }

    { 53  ;3   ;Field     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                ToolTipML=[DAN=Angiver adressen pÜ den kreditor, der afsendte varerne.;
                           ENU=Specifies the address of the vendor who shipped the items.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Buy-from Address";
                Importance=Additional;
                Editable=FALSE }

    { 55  ;3   ;Field     ;
                CaptionML=[DAN=Adresse 2;
                           ENU=Address 2];
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Buy-from Address 2";
                Importance=Additional;
                Editable=FALSE }

    { 6   ;3   ;Field     ;
                CaptionML=[DAN=Postnr.;
                           ENU=Post Code];
                ToolTipML=[DAN=Angiver postnummer.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Buy-from Post Code";
                Importance=Additional;
                Editable=FALSE }

    { 57  ;3   ;Field     ;
                CaptionML=[DAN=By;
                           ENU=City];
                ToolTipML=[DAN=Angiver byen for kreditoren pÜ kõbsdokumentet.;
                           ENU=Specifies the city of the vendor on the purchase document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Buy-from City";
                Importance=Additional;
                Editable=FALSE }

    { 91  ;3   ;Field     ;
                CaptionML=[DAN=Kontaktnr.;
                           ENU=Contact No.];
                ToolTipML=[DAN=Angiver nummeret pÜ den kontaktperson, du har sendt kõbskreditnotaen til.;
                           ENU=Specifies the number of the contact who you sent the purchase credit memo to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Buy-from Contact No.";
                Importance=Additional;
                Editable=FALSE }

    { 59  ;2   ;Field     ;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                ToolTipML=[DAN=Angiver navnet pÜ den person, du kan kontakte hos den kreditor, der leverede varerne.;
                           ENU=Specifies the name of the person to contact at the vendor who shipped the items.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Buy-from Contact";
                Editable=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor kreditnotaen blev bogfõrt.;
                           ENU=Specifies the date the credit memo was posted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Posting Date";
                Importance=Promoted;
                Editable=FALSE }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor kõbsdokumentet blev oprettet.;
                           ENU=Specifies the date on which the purchase document was created.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Date";
                Editable=FALSE }

    { 63  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den kreditnota, som den bogfõrte kreditnota er oprettet fra.;
                           ENU=Specifies the number of the credit memo that the posted credit memo was created from.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pre-Assigned No.";
                Importance=Additional;
                Editable=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens nummer for denne kreditnota.;
                           ENU=Specifies the vendor's number for this credit memo.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Vendor Cr. Memo No.";
                Importance=Promoted;
                Editable=FALSE }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bestillingsadressen for den relaterede kreditor.;
                           ENU=Specifies the order address of the related vendor.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Order Address Code";
                Editable=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken indkõber der er tilknyttet kreditoren.;
                           ENU=Specifies which purchaser is assigned to the vendor.];
                ApplicationArea=#Suite;
                SourceExpr="Purchaser Code";
                Importance=Additional;
                Editable=FALSE }

    { 80  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for det ansvarscenter, der betjener den pÜgëldende kreditor pÜ dette kõbsdokument.;
                           ENU=Specifies the code for the responsibility center that serves the vendor on this purchase document.];
                ApplicationArea=#Advanced;
                SourceExpr="Responsibility Center";
                Importance=Additional;
                Editable=FALSE }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om den bogfõrte kõbsfaktura, der vedrõrer denne kõbskreditnota, er rettet eller annulleret.;
                           ENU=Specifies if the posted purchase invoice that relates to this purchase credit memo has been either corrected or canceled.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Cancelled;
                Importance=Additional;
                Style=Unfavorable;
                StyleExpr=Cancelled;
                OnDrillDown=BEGIN
                              ShowCorrectiveInvoice;
                            END;
                             }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om den bogfõrte kõbsfaktura er rettet eller annulleret af denne kõbskreditnota.;
                           ENU=Specifies if the posted purchase invoice has been either corrected or canceled by this purchase credit memo .];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Corrective;
                Importance=Additional;
                Style=Unfavorable;
                StyleExpr=Corrective;
                OnDrillDown=BEGIN
                              ShowCancelledInvoice;
                            END;
                             }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange gange bilaget er blevet udskrevet.;
                           ENU=Specifies how many times the document has been printed.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No. Printed";
                Importance=Additional;
                Editable=FALSE }

    { 44  ;1   ;Part      ;
                Name=PurchCrMemoLines;
                ApplicationArea=#Basic,#Suite;
                SubPageLink=Document No.=FIELD(No.);
                PagePartID=Page141 }

    { 1905885101;1;Group  ;
                CaptionML=[DAN=Fakturadetaljer;
                           ENU=Invoice Details];
                GroupType=Group }

    { 75  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den valutakode, der er brugt til at beregne belõbene pÜ kreditnotaen.;
                           ENU=Specifies the currency code used to calculate the amounts on the credit memo.];
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
                                 UpdateCurrencyFactor.ModifyPostedPurchaseCreditMemo(Rec);
                               END;
                               CLEAR(ChangeExchangeRate);
                             END;
                              }

    { 64  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 1 Code";
                Importance=Additional;
                Editable=FALSE }

    { 66  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 2 Code";
                Importance=Additional;
                Editable=FALSE }

    { 68  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, der blev brugt ved bogfõring af kreditnotaen.;
                           ENU=Specifies the code for the location used when you posted the credit memo.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Editable=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den type bogfõrt bilag, som dette bilag eller denne kladdelinje udlignes med, nÜr du bogfõrer, f.eks. til registrering af betaling.;
                           ENU=Specifies the type of the posted document that this document or journal line will be applied to when you post, for example to register payment.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Applies-to Doc. Type";
                Editable=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ det bogfõrte bilag, som dette bilag eller denne kladdelinje udlignes pÜ, nÜr du bogfõrer, f.eks. til registrering af betaling.;
                           ENU=Specifies the number of the posted document that this document or journal line will be applied to when you post, for example to register payment.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Applies-to Doc. No.";
                Editable=FALSE }

    { 1906801201;1;Group  ;
                CaptionML=[DAN=Forsendelse og betaling;
                           ENU=Shipping and Payment];
                GroupType=Group }

    { 19  ;2   ;Group     ;
                CaptionML=[DAN=Leveres til;
                           ENU=Ship-to];
                GroupType=Group }

    { 34  ;3   ;Field     ;
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver navnet pÜ firmaet med den adresse, som varerne i kõbsordren er leveret til.;
                           ENU=Specifies the name of the company at the address to which the items in the purchase order were shipped.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Name";
                Editable=FALSE }

    { 36  ;3   ;Field     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                ToolTipML=[DAN=Angiver den adresse, som varerne i kõbsordren er leveret til.;
                           ENU=Specifies the address that the items in the purchase order were shipped to.];
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
                ToolTipML=[DAN=Angiver byen for kreditoren pÜ kõbsdokumentet.;
                           ENU=Specifies the city of the vendor on the purchase document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to City";
                Editable=FALSE }

    { 42  ;3   ;Field     ;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                ToolTipML=[DAN=Angiver navnet pÜ en kontaktperson pÜ den adresse, som varerne er leveret til.;
                           ENU=Specifies the name of a contact person at the address that the items were shipped to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Contact";
                Editable=FALSE }

    { 17  ;2   ;Group     ;
                CaptionML=[DAN=Faktureres til;
                           ENU=Pay-to];
                GroupType=Group }

    { 22  ;3   ;Field     ;
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver navnet pÜ den kreditor, du har modtaget kreditnotaen fra.;
                           ENU=Specifies the name of the vendor that you received the credit memo from.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pay-to Name";
                Importance=Promoted;
                Editable=FALSE }

    { 26  ;3   ;Field     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                ToolTipML=[DAN=Angiver adressen pÜ den kreditor, du har modtaget kreditnotaen fra.;
                           ENU=Specifies the address of the vendor that you received the credit memo from.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pay-to Address";
                Importance=Additional;
                Editable=FALSE }

    { 28  ;3   ;Field     ;
                CaptionML=[DAN=Adresse 2;
                           ENU=Address 2];
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pay-to Address 2";
                Importance=Additional;
                Editable=FALSE }

    { 70  ;3   ;Field     ;
                CaptionML=[DAN=Postnr.;
                           ENU=Post Code];
                ToolTipML=[DAN=Angiver postnummer.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pay-to Post Code";
                Importance=Additional;
                Editable=FALSE }

    { 30  ;3   ;Field     ;
                CaptionML=[DAN=By;
                           ENU=City];
                ToolTipML=[DAN=Angiver byen for kreditoren pÜ kõbsdokumentet.;
                           ENU=Specifies the city of the vendor on the purchase document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pay-to City";
                Importance=Additional;
                Editable=FALSE }

    { 93  ;3   ;Field     ;
                CaptionML=[DAN=Kontaktnr.;
                           ENU=Contact No.];
                ToolTipML=[DAN=Angiver nummeret pÜ kontaktpersonen hos den kreditor, der hÜndterer kreditnotaen.;
                           ENU=Specifies the number of the contact at the vendor who handles the credit memo.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pay-to Contact No.";
                Importance=Additional;
                Editable=FALSE }

    { 32  ;3   ;Field     ;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                ToolTipML=[DAN=Angiver navnet pÜ den kontaktperson, du kan kontakte hos den kreditor, du har modtaget kreditnotaen fra.;
                           ENU=Specifies the name of the person you should contact at the vendor who you received the credit memo from.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pay-to Contact";
                Editable=FALSE }

    { 1907468901;1;Group  ;
                CaptionML=[DAN=Udenrigshandel;
                           ENU=Foreign Trade] }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 3   ;1   ;Part      ;
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
      ApplicationAreaSetup@1004 : Record 9178;
      PurchCrMemoHeader@1000 : Record 124;
      ChangeExchangeRate@1001 : Page 511;
      HasIncomingDocument@1002 : Boolean;
      IsOfficeAddin@1003 : Boolean;
      IsFoundationEnabled@1005 : Boolean;

    BEGIN
    END.
  }
}

