OBJECT Page 138 Posted Purchase Invoice
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Bogfõrt kõbsfaktura;
               ENU=Posted Purchase Invoice];
    InsertAllowed=No;
    SourceTable=Table122;
    PageType=Document;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Ret,Faktura;
                                ENU=New,Process,Report,Correct,Invoice];
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
      { 53      ;1   ;ActionGroup;
                      CaptionML=[DAN=F&aktura;
                                 ENU=&Invoice];
                      Image=Invoice }
      { 45      ;2   ;Action    ;
                      Name=Statistics;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=FÜ vist statistiske oplysninger om recorden, f.eks. vërdien af bogfõrte poster.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 400;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 55      ;2   ;Action    ;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 66;
                      RunPageLink=Document Type=CONST(Posted Invoice),
                                  No.=FIELD(No.),
                                  Document Line No.=CONST(0);
                      Image=ViewComments }
      { 89      ;2   ;Action    ;
                      Name=Dimensions;
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
      { 106     ;2   ;Action    ;
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
      { 27      ;1   ;Action    ;
                      Name=Print;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Udskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=Forbered udskrivning af bilaget. Du fÜr vist et anmodningsvindue for bilaget, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=NOT IsOfficeAddin;
                      Image=Print;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CurrPage.SETSELECTIONFILTER(PurchInvHeader);
                                 PurchInvHeader.PrintRecords(TRUE);
                               END;
                                }
      { 25      ;1   ;ActionGroup;
                      CaptionML=[DAN=Ret;
                                 ENU=Correct] }
      { 23      ;2   ;Action    ;
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
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 CorrectPstdPurchInvYesNo@1000 : Codeunit 1324;
                               BEGIN
                                 IF CorrectPstdPurchInvYesNo.CorrectInvoice(Rec) THEN
                                   CurrPage.CLOSE;
                               END;
                                }
      { 11      ;2   ;Action    ;
                      Name=CancelInvoice;
                      CaptionML=[DAN=Annuller;
                                 ENU=Cancel];
                      ToolTipML=[DAN=Opret og bogfõr en kõbskreditnota, der tilbagefõrer denne bogfõrte kõbsfaktura. Denne bogfõrte kõbsfaktura bliver annulleret.;
                                 ENU=Create and post a purchase credit memo that reverses this posted purchase invoice. This posted purchase invoice will be canceled.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=IsFoundationEnabled;
                      PromotedIsBig=Yes;
                      Image=Cancel;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 CancelPstdPurchInvYesNo@1000 : Codeunit 1325;
                               BEGIN
                                 IF CancelPstdPurchInvYesNo.CancelInvoice(Rec) THEN
                                   CurrPage.CLOSE;
                               END;
                                }
      { 21      ;2   ;Action    ;
                      Name=CreateCreditMemo;
                      CaptionML=[DAN=Opret rettelseskreditnota;
                                 ENU=Create Corrective Credit Memo];
                      ToolTipML=[DAN=Opret en kreditnota til denne bogfõrte faktura, som du udfylder og bogfõrer manuelt for at tilbagefõre den bogfõrte faktura.;
                                 ENU=Create a credit memo for this posted invoice that you complete and post manually to reverse the posted invoice.];
                      ApplicationArea=#Basic,#Suite;
                      Image=CreateCreditMemo;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 PurchaseHeader@1001 : Record 38;
                                 CorrectPostedPurchInvoice@1000 : Codeunit 1313;
                               BEGIN
                                 CorrectPostedPurchInvoice.CreateCreditMemoCopyDocument(Rec,PurchaseHeader);
                                 PAGE.RUN(PAGE::"Purchase Credit Memo",PurchaseHeader);
                                 CurrPage.CLOSE;
                               END;
                                }
      { 49      ;2   ;Action    ;
                      Name=ShowCreditMemo;
                      CaptionML=[DAN=Vis annulleret kreditnota/rettelseskreditnota;
                                 ENU=Show Canceled/Corrective Credit Memo];
                      ToolTipML=[DAN=èbn den bogfõrte kõbskreditnota, som blev oprettet, da du annullerede den bogfõrte kõbsfaktura. Hvis den bogfõrte kõbsfaktura er resultatet af en annulleret kõbskreditnota, Übnes den annullerede kõbskreditnota.;
                                 ENU=Open the posted purchase credit memo that was created when you canceled the posted purchase invoice. If the posted purchase invoice is the result of a canceled purchase credit memo, then canceled purchase credit memo will open.];
                      ApplicationArea=#Basic,#Suite;
                      Enabled=Cancelled OR Corrective;
                      Image=CreditMemo;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 ShowCanceledOrCorrCrMemo;
                               END;
                                }
      { 39      ;1   ;ActionGroup;
                      CaptionML=[DAN=Handlinger;
                                 ENU=Actions];
                      Image=Invoice }
      { 37      ;2   ;Action    ;
                      Name=Vendor;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kreditor;
                                 ENU=Vendor];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om kreditoren i kõbsdokumentet.;
                                 ENU=View or edit detailed information about the vendor on the purchase document.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 26;
                      RunPageLink=No.=FIELD(Buy-from Vendor No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Vendor;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes }
      { 33      ;2   ;Action    ;
                      Name=Navigate;
                      CaptionML=[DAN=N&aviger;
                                 ENU=&Navigate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes til bilagsnummeret og bogfõringsdatoen pÜ det bogfõrte kõbsdokument.;
                                 ENU=Find all entries and documents that exist for the document number and posting date on the posted purchase document.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=NOT IsOfficeAddin;
                      PromotedIsBig=Yes;
                      Image=Navigate;
                      PromotedCategory=Category5;
                      OnAction=BEGIN
                                 Navigate;
                               END;
                                }
      { 57      ;1   ;Action    ;
                      CaptionML=[DAN=&Naviger;
                                 ENU=&Navigate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes til bilagsnummeret og bogfõringsdatoen pÜ den valgte post eller det valgte dokument.;
                                 ENU=Find all entries and documents that exist for the document number and posting date on the selected entry or document.];
                      ApplicationArea=#Advanced;
                      Visible=FALSE;
                      Image=Navigate;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Navigate;
                               END;
                                }
      { 19      ;1   ;ActionGroup;
                      Name=IncomingDocument;
                      CaptionML=[DAN=IndgÜende bilag;
                                 ENU=Incoming Document];
                      ActionContainerType=NewDocumentItems;
                      Image=Documents }
      { 17      ;2   ;Action    ;
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
      { 15      ;2   ;Action    ;
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
      { 13      ;2   ;Action    ;
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
                ToolTipML=[DAN=Angiver det bogfõrte fakturanummer.;
                           ENU=Specifies the posted invoice number.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No.";
                Importance=Additional;
                Editable=FALSE }

    { 59  ;2   ;Field     ;
                CaptionML=[DAN=Kreditor;
                           ENU=Vendor];
                ToolTipML=[DAN=Angiver navnet pÜ den kreditor, der leverede varerne.;
                           ENU=Specifies the name of the vendor who shipped the items.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Buy-from Vendor Name";
                TableRelation=Vendor.Name;
                Editable=FALSE }

    { 4   ;2   ;Group     ;
                CaptionML=[DAN=Leverandõr;
                           ENU=Buy-from];
                GroupType=Group }

    { 61  ;3   ;Field     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                ToolTipML=[DAN=Angiver adressen pÜ den kreditor, der afsendte varerne.;
                           ENU=Specifies the address of the vendor who shipped the items.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Buy-from Address";
                Importance=Additional;
                Editable=FALSE }

    { 63  ;3   ;Field     ;
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

    { 65  ;3   ;Field     ;
                CaptionML=[DAN=By;
                           ENU=City];
                ToolTipML=[DAN=Angiver byen for kreditoren pÜ kõbsdokumentet.;
                           ENU=Specifies the city of the vendor on the purchase document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Buy-from City";
                Importance=Additional;
                Editable=FALSE }

    { 100 ;3   ;Field     ;
                CaptionML=[DAN=Kontaktnr.;
                           ENU=Contact No.];
                ToolTipML=[DAN=Angiver nummeret pÜ den kontakt, som du har kõbt varerne af.;
                           ENU=Specifies the number of the contact you bought the items from.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Buy-from Contact No.";
                Importance=Additional;
                Editable=FALSE }

    { 67  ;2   ;Field     ;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                ToolTipML=[DAN=Angiver navnet pÜ den person, du kan kontakte hos den kreditor, der leverede varerne.;
                           ENU=Specifies the name of the person to contact at the vendor who shipped the items.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Buy-from Contact";
                Editable=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver datoen for bogfõring af kõbshovedet.;
                           ENU=Specifies the date the purchase header was posted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Posting Date";
                Importance=Promoted;
                Editable=FALSE }

    { 71  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor kõbsdokumentet blev oprettet.;
                           ENU=Specifies the date on which the purchase document was created.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Date";
                Importance=Additional;
                Editable=FALSE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvornÜr fakturaen er forfalden til betaling. Feltet beregnes automatisk ud fra data i felterne Betalingsbeting.kode og Bilagsdato pÜ kõbshovedet.;
                           ENU=Specifies when the invoice is due. The program calculates the date using the Payment Terms Code and Document Date fields on the purchase header.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Due Date";
                Importance=Promoted;
                Editable=FALSE }

    { 110 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ kõbstilbudsdokumentet, hvis kõbsprocessen tager udgangspunkt i et tilbud.;
                           ENU=Specifies the number of the purchase quote document if a quote was used to start the purchase process.];
                ApplicationArea=#Advanced;
                SourceExpr="Quote No.";
                Importance=Additional }

    { 81  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den kõbsordre, hvorfra fakturaen blev bogfõrt.;
                           ENU=Specifies the number of the purchase order that this invoice was posted from.];
                ApplicationArea=#Advanced;
                SourceExpr="Order No.";
                Importance=Additional;
                Editable=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens eget fakturanummer.;
                           ENU=Specifies the vendor's own invoice number.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Vendor Invoice No.";
                Importance=Promoted;
                Editable=FALSE }

    { 104 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens ordrenummer.;
                           ENU=Specifies the vendor's order number.];
                ApplicationArea=#Advanced;
                SourceExpr="Vendor Order No.";
                Importance=Additional;
                Editable=FALSE }

    { 83  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ kõbsdokumentet, som den bogfõrte faktura blev oprettet til.;
                           ENU=Specifies the number of the purchase document that the posted invoice was created for.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pre-Assigned No.";
                Importance=Additional;
                Editable=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange gange bilaget er blevet udskrevet.;
                           ENU=Specifies how many times the document has been printed.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No. Printed";
                Importance=Additional;
                Editable=FALSE }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bestillingsadressen for den relaterede kreditor.;
                           ENU=Specifies the order address of the related vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Order Address Code";
                Importance=Additional;
                Editable=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken indkõber der er tilknyttet kreditoren.;
                           ENU=Specifies which purchaser is assigned to the vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Purchaser Code";
                Importance=Additional;
                Editable=FALSE }

    { 92  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for det ansvarscenter, der betjener den pÜgëldende kreditor pÜ dette kõbsdokument.;
                           ENU=Specifies the code for the responsibility center that serves the vendor on this purchase document.];
                ApplicationArea=#Advanced;
                SourceExpr="Responsibility Center";
                Importance=Additional;
                Editable=FALSE }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om den bogfõrte kõbsfaktura er blevet rettet eller annulleret.;
                           ENU=Specifies if the posted purchase invoice has been either corrected or canceled.];
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

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om den bogfõrte kõbsfaktura er et rettelsesbilag.;
                           ENU=Specifies if the posted purchase invoice is a corrective document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Corrective;
                Importance=Additional;
                Style=Unfavorable;
                StyleExpr=Corrective;
                OnDrillDown=BEGIN
                              ShowCancelledCreditMemo;
                            END;
                             }

    { 52  ;1   ;Part      ;
                Name=PurchInvLines;
                ApplicationArea=#Basic,#Suite;
                SubPageLink=Document No.=FIELD(No.);
                PagePartID=Page139 }

    { 1905885101;1;Group  ;
                CaptionML=[DAN=Fakturadetaljer;
                           ENU=Invoice Details];
                GroupType=Group }

    { 87  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den valutakode, der er brugt til at beregne belõbene pÜ fakturaen.;
                           ENU=Specifies the currency code used to calculate the amounts on the invoice.];
                ApplicationArea=#Suite;
                SourceExpr="Currency Code";
                Importance=Promoted;
                OnAssistEdit=VAR
                               UpdateCurrencyFactor@1001 : Codeunit 325;
                               ChangeExchangeRate@1000 : Page 511;
                             BEGIN
                               ChangeExchangeRate.SetParameter("Currency Code","Currency Factor","Posting Date");
                               ChangeExchangeRate.EDITABLE(FALSE);
                               IF ChangeExchangeRate.RUNMODAL = ACTION::OK THEN BEGIN
                                 "Currency Factor" := ChangeExchangeRate.GetParameter;
                                 UpdateCurrencyFactor.ModifyPostedPurchaseInvoice(Rec);
                               END;
                             END;
                              }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor de fakturerede varer blev forventet modtaget.;
                           ENU=Specifies the date on which the invoiced items were expected.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Expected Receipt Date";
                Importance=Promoted;
                Editable=FALSE }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode, der skal bruges til at finde de betalingsbetingelser, som gëlder for kõbshovedet.;
                           ENU=Specifies the code to use to find the payment terms that apply to the purchase header.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Terms Code";
                Importance=Promoted;
                Editable=FALSE }

    { 84  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver betalingsformen for kreditorer. Koden kopieres automatisk fra feltet Betalingsformskode pÜ kõbshovedet.;
                           ENU=Specifies the method of payment to vendors. The program has copied the code from the Payment Method Code field on the purchase header.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Method Code";
                Importance=Additional;
                Editable=FALSE }

    { 72  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                Editable=FALSE }

    { 74  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code";
                Editable=FALSE }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den rabatprocent, der tildeles, hvis betaling gennemfõres fõr eller pÜ den dato, der er angivet i feltet Kont.rabatdato.;
                           ENU=Specifies the payment discount percent granted if payment is made on or before the date in the Pmt. Discount Date field.];
                ApplicationArea=#Advanced;
                SourceExpr="Payment Discount %";
                Editable=FALSE }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor belõbet i posten skal vëre betalt, for at der kan opnÜs kontantrabat.;
                           ENU=Specifies the date on which the amount in the entry must be paid for a payment discount to be granted.];
                ApplicationArea=#Advanced;
                SourceExpr="Pmt. Discount Date";
                Importance=Additional;
                Editable=FALSE }

    { 76  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, hvor varerne er registreret.;
                           ENU=Specifies the code for the location where the items are registered.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Importance=Additional;
                Editable=FALSE }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver betingelserne for levering af den relaterede leverance, som f.eks. frit ombord (FOB).;
                           ENU=Specifies the delivery conditions of the related shipment, such as free on board (FOB).];
                ApplicationArea=#Advanced;
                SourceExpr="Shipment Method Code";
                Importance=Additional;
                Editable=FALSE }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver betalingen for kõbsfakturaen.;
                           ENU=Specifies the payment of the purchase invoice.];
                ApplicationArea=#Advanced;
                SourceExpr="Payment Reference";
                Importance=Additional }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ kreditoren.;
                           ENU=Specifies the number of the vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Creditor No.";
                Importance=Additional }

    { 41  ;1   ;Group     ;
                CaptionML=[DAN=Forsendelse og betaling;
                           ENU=Shipping and Payment];
                GroupType=Group }

    { 1906801201;2;Group  ;
                CaptionML=[DAN=Leveres til;
                           ENU=Ship-to];
                GroupType=Group }

    { 47  ;3   ;Field     ;
                CaptionML=[DAN=Adressekode;
                           ENU=Address Code];
                ToolTipML=[DAN=Angiver adressen pÜ kõbsordrer, der leveres som en direkte levering direkte fra kreditoren til debitoren.;
                           ENU=Specifies the address on purchase orders shipped with a drop shipment directly from the vendor to a customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Code";
                Importance=Promoted }

    { 38  ;3   ;Field     ;
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver navnet pÜ firmaet med den adresse, som varerne i kõbsordren er leveret til.;
                           ENU=Specifies the name of the company at the address to which the items in the purchase order were shipped.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Name";
                Editable=FALSE }

    { 40  ;3   ;Field     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                ToolTipML=[DAN=Angiver den adresse, som varerne i kõbsordren er leveret til.;
                           ENU=Specifies the address that the items in the purchase order were shipped to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Address";
                Editable=FALSE }

    { 42  ;3   ;Field     ;
                CaptionML=[DAN=Adresse 2;
                           ENU=Address 2];
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Address 2";
                Editable=FALSE }

    { 8   ;3   ;Field     ;
                CaptionML=[DAN=Postnr.;
                           ENU=Post Code];
                ToolTipML=[DAN=Angiver postnummer.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Post Code";
                Editable=FALSE }

    { 44  ;3   ;Field     ;
                CaptionML=[DAN=By;
                           ENU=City];
                ToolTipML=[DAN=Angiver byen for kreditoren pÜ kõbsdokumentet.;
                           ENU=Specifies the city of the vendor on the purchase document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to City";
                Editable=FALSE }

    { 46  ;3   ;Field     ;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                ToolTipML=[DAN=Angiver navnet pÜ en kontaktperson pÜ den adresse, som varerne i kõbsordren er leveres til.;
                           ENU=Specifies the name of a contact person at the address that the items in the purchase order were shipped to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ship-to Contact";
                Editable=FALSE }

    { 43  ;2   ;Group     ;
                CaptionML=[DAN=Faktureres til;
                           ENU=Pay-to];
                GroupType=Group }

    { 20  ;3   ;Field     ;
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver navnet pÜ den kreditor, du har modtaget fakturaen fra.;
                           ENU=Specifies the name of the vendor who you received the invoice from.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pay-to Name";
                Importance=Promoted;
                Editable=FALSE }

    { 22  ;3   ;Field     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                ToolTipML=[DAN=Angiver adressen pÜ den kreditor, du har modtaget fakturaen fra.;
                           ENU=Specifies the address of the vendor that you received the invoice from.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pay-to Address";
                Importance=Additional;
                Editable=FALSE }

    { 24  ;3   ;Field     ;
                CaptionML=[DAN=Adresse 2;
                           ENU=Address 2];
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pay-to Address 2";
                Importance=Additional;
                Editable=FALSE }

    { 78  ;3   ;Field     ;
                CaptionML=[DAN=Postnr.;
                           ENU=Post Code];
                ToolTipML=[DAN=Angiver postnummer.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pay-to Post Code";
                Importance=Additional;
                Editable=FALSE }

    { 26  ;3   ;Field     ;
                CaptionML=[DAN=By;
                           ENU=City];
                ToolTipML=[DAN=Angiver byen for kreditoren pÜ kõbsdokumentet.;
                           ENU=Specifies the city of the vendor on the purchase document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pay-to City";
                Importance=Additional;
                Editable=FALSE }

    { 102 ;3   ;Field     ;
                CaptionML=[DAN=Kontaktnr.;
                           ENU=Contact No.];
                ToolTipML=[DAN=Angiver nummeret pÜ den kontakt, du har modtaget fakturaen fra.;
                           ENU=Specifies the number of the contact you received the invoice from.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pay-to Contact No.";
                Importance=Additional;
                Editable=FALSE }

    { 28  ;3   ;Field     ;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                ToolTipML=[DAN=Angiver navnet pÜ den kontaktperson, du kan kontakte hos den kreditor, du har modtaget fakturaen fra.;
                           ENU=Specifies the name of the person you should contact at the vendor who you received the invoice from.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pay-to Contact";
                Editable=FALSE }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 9   ;1   ;Part      ;
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
      ApplicationAreaSetup@1001 : Record 9178;
      PurchInvHeader@1000 : Record 122;
      HasIncomingDocument@1002 : Boolean;
      IsOfficeAddin@1003 : Boolean;
      IsFoundationEnabled@1004 : Boolean;

    BEGIN
    END.
  }
}

