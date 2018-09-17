OBJECT Page 143 Posted Sales Invoices
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846,NAVDK11.00.00.19846;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Bogf. salgsfakturaer;
               ENU=Posted Sales Invoices];
    SourceTable=Table112;
    SourceTableView=SORTING(Posting Date)
                    ORDER(Descending);
    PageType=List;
    CardPageID=Posted Sales Invoice;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,RapportÇr,Faktura,Naviger,Ret;
                                ENU=New,Process,Report,Invoice,Navigate,Correct];
    OnInit=BEGIN
             DocExchStatusVisible := FALSE;
           END;

    OnOpenPage=VAR
                 SalesInvoiceHeader@1002 : Record 112;
                 CRMIntegrationManagement@1000 : Codeunit 5330;
                 OfficeMgt@1001 : Codeunit 1630;
                 HasFilters@1003 : Boolean;
               BEGIN
                 HasFilters := GETFILTERS <> '';
                 SetSecurityFilterOnRespCenter;
                 CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
                 IF HasFilters THEN
                   IF FINDFIRST THEN;
                 IsOfficeAddin := OfficeMgt.IsAvailable;
                 IsPostedSalesInvoicesEmpty := SalesInvoiceHeader.ISEMPTY;
                 IsFoundationEnabled := ApplicationAreaSetup.IsFoundationEnabled;
               END;

    OnAfterGetRecord=VAR
                       SalesInvoiceHeader@1000 : Record 112;
                     BEGIN
                       DocExchStatusStyle := GetDocExchStatusStyle;

                       SalesInvoiceHeader.COPYFILTERS(Rec);
                       IsPostedSalesInvoicesEmpty := SalesInvoiceHeader.ISEMPTY;
                       SalesInvoiceHeader.SETFILTER("Document Exchange Status",'<>%1',"Document Exchange Status"::"Not Sent");
                       DocExchStatusVisible := NOT SalesInvoiceHeader.ISEMPTY;
                     END;

    OnAfterGetCurrRecord=VAR
                           CRMCouplingManagement@1000 : Codeunit 5331;
                         BEGIN
                           DocExchStatusStyle := GetDocExchStatusStyle;
                           CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
                           CRMIsCoupledToRecord := CRMIntegrationEnabled AND CRMCouplingManagement.IsRecordCoupledToCRM(RECORDID);
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 19      ;1   ;ActionGroup;
                      CaptionML=[DAN=F&aktura;
                                 ENU=&Invoice];
                      Image=Invoice }
      { 31      ;2   ;Action    ;
                      Name=Statistics;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=FÜ vist statistiske oplysninger om recorden, f.eks. vërdien af bogfõrte poster.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 397;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Statistics;
                      PromotedCategory=Category4 }
      { 32      ;2   ;Action    ;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 67;
                      RunPageLink=Document Type=CONST(Posted Invoice),
                                  No.=FIELD(No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ViewComments;
                      PromotedCategory=Category4 }
      { 1102601000;2 ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omrÜde, projekt eller afdeling, som du kan tildele til salgs- og kõbsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Dimensions;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 ShowDimensions;
                               END;
                                }
      { 1060000 ;2   ;Separator  }
      { 1060001 ;2   ;Action    ;
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
      { 9       ;2   ;Action    ;
                      Name=IncomingDoc;
                      AccessByPermission=TableData 130=R;
                      CaptionML=[DAN=IndgÜende bilag;
                                 ENU=Incoming Document];
                      ToolTipML=[DAN=Vis eller opret en indgÜende bilagsrecord, som er knyttet til posten eller bilaget.;
                                 ENU=View or create an incoming document record that is linked to the entry or document.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Image=Document;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 IncomingDocument@1000 : Record 130;
                               BEGIN
                                 IncomingDocument.ShowCard("No.","Posting Date");
                               END;
                                }
      { 16      ;1   ;ActionGroup;
                      Name=ActionGroupCRM;
                      CaptionML=[DAN=Dynamics 365 for Sales;
                                 ENU=Dynamics 365 for Sales];
                      Visible=CRMIntegrationEnabled }
      { 14      ;2   ;Action    ;
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
      { 12      ;2   ;Action    ;
                      Name=CreateInCRM;
                      CaptionML=[DAN=Opret faktura i Dynamics 365 for Sales;
                                 ENU=Create Invoice in Dynamics 365 for Sales];
                      ToolTipML=[DAN=Opret bilaget pÜ den sammenkëdede Dynamics 365 for Sales-konto.;
                                 ENU=Generate the document in the coupled Dynamics 365 for Sales account.];
                      ApplicationArea=#Suite;
                      Enabled=NOT CRMIsCoupledToRecord;
                      Image=NewSalesInvoice;
                      OnAction=VAR
                                 SalesInvoiceHeader@1003 : Record 112;
                                 CRMIntegrationManagement@1000 : Codeunit 5330;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(SalesInvoiceHeader);
                                 CRMIntegrationManagement.CreateNewRecordsInCRM(SalesInvoiceHeader);
                               END;
                                }
      { 43      ;2   ;Action    ;
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
      { 7       ;1   ;Action    ;
                      Name=SendCustom;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Send;
                                 ENU=Send];
                      ToolTipML=[DAN=Klargõr bilaget til afsendelse i henhold til debitorens afsendelsesprofil, f.eks. vedhëftet en mail. Vinduet Send dokument til vises, sÜ du kan bekrëfte eller vëlge en afsendelsesprofil.;
                                 ENU=Prepare to send the document according to the customer's sending profile, such as attached to an email. The Send document to window opens where you can confirm or select a sending profile.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=NOT IsPostedSalesInvoicesEmpty;
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
      { 20      ;1   ;Action    ;
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
                      OnAction=VAR
                                 SalesInvHeader@1102 : Record 112;
                               BEGIN
                                 SalesInvHeader := Rec;
                                 CurrPage.SETSELECTIONFILTER(SalesInvHeader);
                                 SalesInvHeader.PrintRecords(TRUE);
                               END;
                                }
      { 3       ;1   ;Action    ;
                      Name=Email;
                      CaptionML=[DAN=Send via &mail;
                                 ENU=Send by &Email];
                      ToolTipML=[DAN=Forbered at afsende bilaget via mail. Vinduet Send mail Übnes med debitorens oplysninger, sÜ du kan tilfõje eller redigere oplysninger, fõr du sender mailen.;
                                 ENU=Prepare to send the document by email. The Send Email window opens prefilled for the customer where you can add or change information before you send the email.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Email;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 SalesInvHeader@1000 : Record 112;
                               BEGIN
                                 SalesInvHeader := Rec;
                                 CurrPage.SETSELECTIONFILTER(SalesInvHeader);
                                 SalesInvHeader.EmailRecords(TRUE);
                               END;
                                }
      { 25      ;1   ;Action    ;
                      Name=Navigate;
                      CaptionML=[DAN=&Naviger;
                                 ENU=&Navigate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes til bilagsnummeret og bogfõringsdatoen pÜ den valgte post eller det valgte dokument.;
                                 ENU=Find all entries and documents that exist for the document number and posting date on the selected entry or document.];
                      ApplicationArea=#Basic,#Suite;
                      Visible=NOT IsOfficeAddin;
                      Image=Navigate;
                      PromotedCategory=Category5;
                      OnAction=BEGIN
                                 Navigate;
                               END;
                                }
      { 10      ;1   ;Action    ;
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
      { 38      ;1   ;ActionGroup;
                      CaptionML=[DAN=Ret;
                                 ENU=Correct] }
      { 36      ;2   ;Action    ;
                      Name=CorrectInvoice;
                      CaptionML=[DAN=Ret;
                                 ENU=Correct];
                      ToolTipML=[DAN=Tilbagefõr denne bogfõrte faktura, og opret automatisk en ny faktura med de samme oplysninger, som du kan rette, fõr du bogfõrer. Denne bogfõrte faktura bliver annulleret automatisk.;
                                 ENU=Reverse this posted invoice and automatically create a new invoice with the same information that you can correct before posting. This posted invoice will automatically be canceled.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=IsFoundationEnabled;
                      Enabled=NOT IsPostedSalesInvoicesEmpty;
                      PromotedIsBig=Yes;
                      Image=Undo;
                      PromotedCategory=Category6;
                      PromotedOnly=Yes;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Correct PstdSalesInv (Yes/No)",Rec);
                               END;
                                }
      { 34      ;2   ;Action    ;
                      Name=CancelInvoice;
                      CaptionML=[DAN=Annuller;
                                 ENU=Cancel];
                      ToolTipML=[DAN=Opret og bogfõr en salgskreditnota, der tilbagefõrer denne bogfõrte salgskreditnota. Denne bogfõrte salgskreditnota annulleres.;
                                 ENU=Create and post a sales credit memo that reverses this posted sales invoice. This posted sales invoice will be canceled.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=IsFoundationEnabled;
                      Enabled=NOT IsPostedSalesInvoicesEmpty;
                      PromotedIsBig=Yes;
                      Image=Cancel;
                      PromotedCategory=Category6;
                      PromotedOnly=Yes;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Cancel PstdSalesInv (Yes/No)",Rec);
                               END;
                                }
      { 30      ;2   ;Action    ;
                      Name=CreateCreditMemo;
                      CaptionML=[DAN=Opret rettelseskreditnota;
                                 ENU=Create Corrective Credit Memo];
                      ToolTipML=[DAN=Opret en kreditnota til denne bogfõrte faktura, som du udfylder og bogfõrer manuelt for at tilbagefõre den bogfõrte faktura.;
                                 ENU=Create a credit memo for this posted invoice that you complete and post manually to reverse the posted invoice.];
                      ApplicationArea=#Basic,#Suite;
                      Enabled=NOT IsPostedSalesInvoicesEmpty;
                      Image=CreateCreditMemo;
                      PromotedCategory=Category6;
                      Scope=Repeater;
                      OnAction=VAR
                                 SalesHeader@1001 : Record 36;
                                 CorrectPostedSalesInvoice@1000 : Codeunit 1303;
                               BEGIN
                                 CorrectPostedSalesInvoice.CreateCreditMemoCopyDocument(Rec,SalesHeader);
                                 PAGE.RUN(PAGE::"Sales Credit Memo",SalesHeader);
                               END;
                                }
      { 42      ;1   ;ActionGroup;
                      CaptionML=[DAN=Faktura;
                                 ENU=Invoice];
                      Image=Invoice }
      { 41      ;2   ;Action    ;
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
                      PromotedOnly=Yes;
                      Scope=Repeater }
      { 40      ;2   ;Action    ;
                      Name=ShowCreditMemo;
                      CaptionML=[DAN=Vis annulleret kreditnota/rettelseskreditnota;
                                 ENU=Show Canceled/Corrective Credit Memo];
                      ToolTipML=[DAN=èbn den bogfõrte salgskreditnota, som blev oprettet, da du annullerede den bogfõrte salgsfaktura. Hvis den bogfõrte salgsfaktura er resultatet af en annulleret salgskreditnota, Übnes den annullerede salgskreditnota.;
                                 ENU=Open the posted sales credit memo that was created when you canceled the posted sales invoice. If the posted sales invoice is the result of a canceled sales credit memo, then canceled sales credit memo will open.];
                      ApplicationArea=#Basic,#Suite;
                      Enabled=Cancelled OR Corrective;
                      Image=CreditMemo;
                      PromotedCategory=Category4;
                      Scope=Repeater;
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
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                CaptionML=[DAN=Debitornr.;
                           ENU=Customer No.];
                ToolTipML=[DAN=Angiver nummeret pÜ den debitor, fakturaen vedrõrer.;
                           ENU=Specifies the number of the customer the invoice concerns.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Customer No." }

    { 6   ;2   ;Field     ;
                CaptionML=[DAN=Debitor;
                           ENU=Customer];
                ToolTipML=[DAN=Angiver navnet pÜ den debitor, som varerne i fakturaen er leveret til.;
                           ENU=Specifies the name of the customer that you shipped the items on the invoice to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Customer Name" }

    { 37  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver valutakoden for fakturaen.;
                           ENU=Specifies the currency code of the invoice.];
                ApplicationArea=#Advanced;
                SourceExpr="Currency Code" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor fakturaen forfalder til betaling.;
                           ENU=Specifies the date on which the invoice is due for payment.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Due Date" }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den samlede sum af belõbene pÜ alle fakturaens linjer, angivet i fakturavalutaen. Belõbet er uden moms.;
                           ENU=Specifies the total, in the currency of the invoice, of the amounts on all the invoice lines. The amount does not include VAT.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Amount;
                OnDrillDown=BEGIN
                              SETRANGE("No.");
                              PAGE.RUNMODAL(PAGE::"Posted Sales Invoice",Rec)
                            END;
                             }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den samlede sum af belõbene, herunder moms, pÜ alle dokumentets linjer.;
                           ENU=Specifies the total of the amounts, including VAT, on all the lines on the document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Amount Including VAT";
                OnDrillDown=BEGIN
                              SETRANGE("No.");
                              PAGE.RUNMODAL(PAGE::"Posted Sales Invoice",Rec)
                            END;
                             }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det belõb, der mangler at blive betalt for den bogfõrte salgsfaktura.;
                           ENU=Specifies the amount that remains to be paid for the posted sales invoice.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Remaining Amount" }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret i debitorens primëre adresse.;
                           ENU=Specifies the postal code of the customer's main address.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Post Code";
                Visible=FALSE }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver landet/omrÜdekoden for debitorens primëre adresse.;
                           ENU=Specifies the country/region code of the customer's main address.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Country/Region Code";
                Visible=FALSE }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ kontaktpersonen pÜ debitorens primëre adresse.;
                           ENU=Specifies the name of the contact person at the customer's main address.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Contact";
                Visible=FALSE }

    { 147 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den debitor, som du sender eller har sendt fakturaen eller kreditnotaen til.;
                           ENU=Specifies the number of the customer that you send or sent the invoice or credit memo to.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to Customer No.";
                Visible=FALSE }

    { 145 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ den debitor, som du sender eller har sendt fakturaen eller kreditnotaen til.;
                           ENU=Specifies the name of the customer that you send or sent the invoice or credit memo to.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to Name";
                Visible=FALSE }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret i debitorens faktureringsadresse.;
                           ENU=Specifies the postal code of the customer's billing address.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to Post Code";
                Visible=FALSE }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver landet/omrÜdekoden for debitorens faktureringsadresse.;
                           ENU=Specifies the country/region code of the customer's billing address.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to Country/Region Code";
                Visible=FALSE }

    { 129 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ kontaktpersonen pÜ debitorens faktureringsadresse.;
                           ENU=Specifies the name of the contact person at the customer's billing address.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to Contact";
                Visible=FALSE }

    { 125 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for en alternativ leveringsadresse, hvis du vil sende til en anden adresse end den, der er indsat automatisk. Dette felt bruges ogsÜ i tilfëlde af direkte levering.;
                           ENU=Specifies a code for an alternate shipment address if you want to ship to another address than the one that has been entered automatically. This field is also used in case of drop shipment.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Code";
                Visible=FALSE }

    { 123 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ debitoren pÜ den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the customer at the address that the items are shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Name";
                Visible=FALSE }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret pÜ den adresse, som varerne leveres til.;
                           ENU=Specifies the postal code of the address that the items are shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Post Code";
                Visible=FALSE }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver lande-/omrÜdekoden pÜ den adresse, som varerne leveres til.;
                           ENU=Specifies the country/region code of the address that the items are shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Country/Region Code";
                Visible=FALSE }

    { 113 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ kontaktpersonen pÜ den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the contact person at the address that the items are shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Contact";
                Visible=FALSE }

    { 109 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor fakturaen blev bogfõrt.;
                           ENU=Specifies the date when the invoice was posted.];
                ApplicationArea=#Advanced;
                SourceExpr="Posting Date";
                Visible=FALSE }

    { 69  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken sëlger der er tilknyttet fakturaen.;
                           ENU=Specifies which salesperson is associated with the invoice.];
                ApplicationArea=#Advanced;
                SourceExpr="Salesperson Code";
                Visible=FALSE }

    { 91  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 89  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 93  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden til den lokation, varerne er leveret fra.;
                           ENU=Specifies the code for the location from which the items were shipped.];
                ApplicationArea=#Location;
                SourceExpr="Location Code" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange gange bilaget er blevet udskrevet.;
                           ENU=Specifies how many times the document has been printed.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No. Printed" }

    { 1102601001;2;Field  ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Document Date";
                Visible=FALSE }

    { 45  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer, som bliver brugt i debitors eller kreditors nummereringssystem.;
                           ENU=Specifies a document number that refers to the customer's or vendor's numbering system.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="External Document No.";
                Visible=FALSE }

    { 1102601003;2;Field  ;
                ToolTipML=[DAN=Angiver en formel, der beregner betalingens forfaldsdato, kontantrabatdato og kontantrabatbelõb.;
                           ENU=Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.];
                ApplicationArea=#Advanced;
                SourceExpr="Payment Terms Code";
                Visible=FALSE }

    { 1102601009;2;Field  ;
                ToolTipML=[DAN=Angiver den rabatprocent, der tildeles, hvis betaling gennemfõres fõr eller pÜ den dato, der er angivet i feltet Kontantrabatdato.;
                           ENU=Specifies the payment discount percent granted if payment is made on or before the date in the Pmt. Discount Date field.];
                ApplicationArea=#Advanced;
                SourceExpr="Payment Discount %";
                Visible=FALSE }

    { 1102601011;2;Field  ;
                ToolTipML=[DAN=Angiver betingelserne for levering af den relaterede leverance, som f.eks. frit ombord (FOB).;
                           ENU=Specifies the delivery conditions of the related shipment, such as free on board (FOB).];
                ApplicationArea=#Advanced;
                SourceExpr="Shipment Method Code";
                Visible=FALSE }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den speditõr, som transporterer varerne.;
                           ENU=Specifies the code for the shipping agent who is transporting the items.];
                ApplicationArea=#Suite;
                SourceExpr="Shipping Agent Code";
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om den bogfõrte salgsfaktura er betalt. Afkrydsningsfeltet markeres ogsÜ, hvis der er oprettet en kreditnota for restbelõbet.;
                           ENU=Specifies if the posted sales invoice is paid. The check box will also be selected if a credit memo for the remaining amount has been applied.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Closed }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om den bogfõrte salgsfaktura er blevet rettet eller annulleret.;
                           ENU=Specifies if the posted sales invoice has been either corrected or canceled.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Cancelled;
                Visible=IsFoundationEnabled;
                HideValue=NOT Cancelled;
                Style=Unfavorable;
                StyleExpr=Cancelled;
                OnDrillDown=BEGIN
                              ShowCorrectiveCreditMemo;
                            END;
                             }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om den bogfõrte salgsfaktura er et rettelsesbilag.;
                           ENU=Specifies if the posted sales invoice is a corrective document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Corrective;
                HideValue=NOT Corrective;
                Style=Unfavorable;
                StyleExpr=Corrective;
                OnDrillDown=BEGIN
                              ShowCancelledCreditMemo;
                            END;
                             }

    { 1102601013;2;Field  ;
                ToolTipML=[DAN=Angiver, hvornÜr varerne pÜ bilaget er sendt eller leveret. En afsendelsesdato beregnes normalt ud fra en õnsket leveringsdato plus leveringstiden.;
                           ENU=Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.];
                ApplicationArea=#Advanced;
                SourceExpr="Shipment Date";
                Visible=FALSE }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for dokumentet, hvis du bruger en dokumentudvekslingstjeneste til at sende det som et elektronisk dokument. Statusvërdierne rapporteres af dokumentudvekslingstjenesten.;
                           ENU=Specifies the status of the document if you are using a document exchange service to send it as an electronic document. The status values are reported by the document exchange service.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Exchange Status";
                Visible=DocExchStatusVisible;
                StyleExpr=DocExchStatusStyle;
                OnDrillDown=VAR
                              DocExchServDocStatus@1000 : Codeunit 1420;
                            BEGIN
                              DocExchServDocStatus.DocExchStatusDrillDown(Rec);
                            END;
                             }

    { 18  ;2   ;Field     ;
                Name=<Document Exchange Status>;
                ToolTipML=[DAN=Angiver, at den bogfõrte salgsordre er sammenkëdet med en salgsordre i Dynamics 365 for Sales.;
                           ENU=Specifies that the posted sales order is coupled to a sales order in Dynamics 365 for Sales.];
                ApplicationArea=#All;
                SourceExpr="Coupled to CRM";
                Visible=CRMIntegrationEnabled }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 5   ;1   ;Part      ;
                Name=IncomingDocAttachFactBox;
                ApplicationArea=#Advanced;
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
      SalesInvHeader@1060100 : Record 112;
      ApplicationAreaSetup@1004 : Record 9178;
      DocExchStatusStyle@1111 : Text;
      CRMIntegrationEnabled@1222 : Boolean;
      CRMIsCoupledToRecord@1001 : Boolean;
      DocExchStatusVisible@1000 : Boolean;
      IsOfficeAddin@1002 : Boolean;
      IsPostedSalesInvoicesEmpty@1003 : Boolean;
      IsFoundationEnabled@1005 : Boolean;

    BEGIN
    END.
  }
}

