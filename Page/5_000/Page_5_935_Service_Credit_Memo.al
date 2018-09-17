OBJECT Page 5935 Service Credit Memo
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846,NAVDK11.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Servicekreditnota;
               ENU=Service Credit Memo];
    SourceTable=Table5900;
    SourceTableView=WHERE(Document Type=FILTER(Credit Memo));
    PageType=Document;
    RefreshOnActivate=Yes;
    OnOpenPage=BEGIN
                 SetSecurityFilterOnRespCenter;
                 IF ("No." <> '') AND ("Customer No." = '') THEN
                   DocumentIsPosted := (NOT GET("Document Type","No."));
               END;

    OnFindRecord=BEGIN
                   IF FIND(Which) THEN
                     EXIT(TRUE);

                   SETRANGE("No.");
                   EXIT(FIND(Which));
                 END;

    OnNewRecord=BEGIN
                  "Responsibility Center" := UserMgt.GetServiceFilter;

                  IF "No." = '' THEN
                    SetCustomerFromFilter;
                END;

    OnDeleteRecord=BEGIN
                     CurrPage.SAVERECORD;
                     CLEAR(ServLogMgt);
                     ServLogMgt.ServHeaderManualDelete(Rec);
                     EXIT(ConfirmDeletion);
                   END;

    OnQueryClosePage=BEGIN
                       IF NOT DocumentIsPosted THEN
                         EXIT(ConfirmCloseUnposted);
                     END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 49      ;1   ;ActionGroup;
                      CaptionML=[DAN=Kr&editnota;
                                 ENU=&Cr. Memo];
                      Image=CreditMemo }
      { 51      ;2   ;Action    ;
                      Name=Statistics;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=F† vist statistiske oplysninger om recorden, f.eks. v‘rdien af bogf›rte poster.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Service;
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CalcInvDiscForHeader;
                                 COMMIT;
                                 PAGE.RUNMODAL(PAGE::"Service Statistics",Rec);
                               END;
                                }
      { 52      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om den p†g‘ldende record p† bilaget eller kladdelinjen.;
                                 ENU=View or change detailed information about the record on the document or journal line.];
                      ApplicationArea=#Service;
                      RunObject=Page 21;
                      RunPageLink=No.=FIELD(Customer No.);
                      Image=EditLines }
      { 53      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Service;
                      RunObject=Page 5911;
                      RunPageLink=Table Name=CONST(Service Header),
                                  Table Subtype=FIELD(Document Type),
                                  No.=FIELD(No.),
                                  Type=CONST(General);
                      Image=ViewComments }
      { 105     ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      Enabled="No." <> '';
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDocDim;
                                 CurrPage.SAVERECORD;
                               END;
                                }
      { 30      ;2   ;Action    ;
                      CaptionML=[DAN=Servicedokumentlo&g;
                                 ENU=Service Document Lo&g];
                      ToolTipML=[DAN=F† vist en liste over de ‘ndringer i servicedokumentet, der er registreret. I programmet oprettes der poster i vinduet, f.eks. n†r svartiden eller serviceordrens status er ‘ndret, en ressource er allokeret, en serviceordre er leveret eller faktureret osv. Hver linje i vinduet identificerer den h‘ndelse, der er forekommet i servicedokumentet. Linjen indeholder oplysninger om det felt, der er ‘ndret, dets gamle og nye v‘rdi, datoen og tidspunktet for, hvorn†r ‘ndringen fandt sted, og id'et for den bruger, som foretog ‘ndringerne.;
                                 ENU=View a list of the service document changes that have been logged. The program creates entries in the window when, for example, the response time or service order status changed, a resource was allocated, a service order was shipped or invoiced, and so on. Each line in this window identifies the event that occurred to the service document. The line contains the information about the field that was changed, its old and new value, the date and time when the change took place, and the ID of the user who actually made the changes.];
                      ApplicationArea=#Service;
                      Image=Log;
                      OnAction=VAR
                                 TempServDocLog@1000 : TEMPORARY Record 5912;
                               BEGIN
                                 TempServDocLog.RESET;
                                 TempServDocLog.DELETEALL;
                                 TempServDocLog.CopyServLog(TempServDocLog."Document Type"::"Credit Memo","No.");

                                 TempServDocLog.RESET;
                                 TempServDocLog.SETCURRENTKEY("Change Date","Change Time");
                                 TempServDocLog.ASCENDING(FALSE);

                                 PAGE.RUN(0,TempServDocLog);
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 58      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 114     ;2   ;Action    ;
                      Name=Calculate Invoice Discount;
                      AccessByPermission=TableData 19=R;
                      CaptionML=[DAN=&Beregn fakturarabat;
                                 ENU=Calculate &Invoice Discount];
                      ToolTipML=[DAN=Beregn fakturarabatten for serviceordren.;
                                 ENU=Calculate the invoice discount that applies to the service order.];
                      ApplicationArea=#Service;
                      Image=CalculateInvoiceDiscount;
                      OnAction=BEGIN
                                 ApproveCalcInvDisc;
                               END;
                                }
      { 121     ;2   ;Action    ;
                      Name=ApplyEntries;
                      ShortCutKey=Shift+F11;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Udlign;
                                 ENU=Apply Entries];
                      ToolTipML=[DAN=V‘lg ‚n eller flere finansposter, denne record skal anvendes p†, s† de relaterede, bogf›rte bilag lukkes som betalte eller refunderede.;
                                 ENU=Select one or more ledger entries that you want to apply this record to so that the related posted documents are closed as paid or refunded.];
                      ApplicationArea=#Service;
                      Image=ApplyEntries;
                      OnAction=BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Service Header Apply",Rec);
                               END;
                                }
      { 112     ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=H&ent std.servicekoder;
                                 ENU=Get St&d. Service Codes];
                      ToolTipML=[DAN=Inds‘t serviceordrelinjer, som du har konfigureret for tilbagevendende servicer.;
                                 ENU="Insert service order lines that you have set up for recurring services. "];
                      ApplicationArea=#Service;
                      Image=ServiceCode;
                      OnAction=VAR
                                 StdServCode@1001 : Record 5996;
                               BEGIN
                                 StdServCode.InsertServiceLines(Rec);
                               END;
                                }
      { 120     ;2   ;Action    ;
                      CaptionML=[DAN=&Hent forudbetalte kontraktposter;
                                 ENU=Get Prepaid Contract E&ntries];
                      ToolTipML=[DAN=Angiv de forudbetalte kontraktposter for en bestemt servicekontrakt som servicelinjer p† kreditnotalinjerne.;
                                 ENU=Enter the prepaid contract ledger entries for a selected service contract as service lines on the credit memo lines.];
                      ApplicationArea=#Prepayments;
                      Image=ContractPayment;
                      OnAction=BEGIN
                                 CLEAR(GetPrepaidTransactions);
                                 GetPrepaidTransactions.Initialize(Rec);
                                 GetPrepaidTransactions.RUNMODAL;
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 59      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Bogf›ring;
                                 ENU=P&osting];
                      Image=Post }
      { 60      ;2   ;Action    ;
                      Name=TestReport;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kontroller;
                                 ENU=Test Report];
                      ToolTipML=[DAN=Vis en testrapport, s† du kan finde og rette eventuelle fejl, f›r du udf›rer den faktiske bogf›ring af kladden eller bilaget.;
                                 ENU=View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.];
                      ApplicationArea=#Service;
                      Image=TestReport;
                      OnAction=BEGIN
                                 ReportPrint.PrintServiceHeader(Rec);
                               END;
                                }
      { 61      ;2   ;Action    ;
                      Name=Post;
                      ShortCutKey=F9;
                      CaptionML=[DAN=&Bogf›r;
                                 ENU=P&ost];
                      ToolTipML=[DAN=F‘rdigg›r bilaget eller kladden ved at bogf›re bel›b og antal p† de relaterede konti i regnskaberne.;
                                 ENU=Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.];
                      ApplicationArea=#Service;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostOrder;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 ServiceHeader@1001 : Record 5900;
                                 ServPostYesNo@1000 : Codeunit 5981;
                                 InstructionMgt@1003 : Codeunit 1330;
                                 PreAssignedNo@1002 : Code[20];
                               BEGIN
                                 PreAssignedNo := "No.";
                                 ServPostYesNo.PostDocument(Rec);

                                 DocumentIsPosted := NOT ServiceHeader.GET("Document Type","No.");

                                 IF InstructionMgt.IsEnabled(InstructionMgt.ShowPostedConfirmationMessageCode) THEN
                                   ShowPostedConfirmationMessage(PreAssignedNo);
                               END;
                                }
      { 5       ;2   ;Action    ;
                      Name=Preview;
                      CaptionML=[DAN=Vis bogf›ring;
                                 ENU=Preview Posting];
                      ToolTipML=[DAN=Gennemse de forskellige typer poster, der oprettes, n†r du bogf›rer bilaget eller kladden.;
                                 ENU=Review the different types of entries that will be created when you post the document or journal.];
                      ApplicationArea=#Service;
                      Image=ViewPostedOrder;
                      OnAction=VAR
                                 ServiceHeader@1001 : Record 5900;
                                 ServPostYesNo@1000 : Codeunit 5981;
                               BEGIN
                                 ServPostYesNo.PreviewDocument(Rec);
                                 DocumentIsPosted := NOT ServiceHeader.GET("Document Type","No.");
                               END;
                                }
      { 3       ;2   ;Action    ;
                      Name=PostAndSend;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Bogf›r og &send;
                                 ENU=Post and &Send];
                      ToolTipML=[DAN=F‘rdigg›r bilaget, og klarg›r det til afsendelse i henhold til debitorens afsendelsesprofil, f.eks. vedh‘ftet en mail. Vinduet Send dokument til vises, s† du kan bekr‘fte eller v‘lge en afsendelsesprofil.;
                                 ENU=Finalize and prepare to send the document according to the customer's sending profile, such as attached to an email. The Send document to window opens first so you can confirm or select a sending profile.];
                      ApplicationArea=#Service;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostSendTo;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 ServiceHeader@1000 : Record 5900;
                               BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Service-Post and Send",Rec);
                                 DocumentIsPosted := NOT ServiceHeader.GET("Document Type","No.");
                               END;
                                }
      { 62      ;2   ;Action    ;
                      ShortCutKey=Shift+F9;
                      CaptionML=[DAN=Bogf›r og &udskriv;
                                 ENU=Post and &Print];
                      ToolTipML=[DAN=Bilaget eller kladden f‘rdigg›res og forberedes til udskrivning. V‘rdierne og antallene bogf›res p† de relaterede konti. Du f†r vist et rapportanmodningsvindue, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.];
                      ApplicationArea=#Service;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostPrint;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 ServPostPrint@1000 : Codeunit 5982;
                               BEGIN
                                 ServPostPrint.PostDocument(Rec);
                               END;
                                }
      { 63      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Massebogf›r;
                                 ENU=Post &Batch];
                      ToolTipML=[DAN=Bogf›r flere bilag p† ‚n gang. Der †bnes et anmodningsvindue, hvor du kan angive, hvilke bilag der skal bogf›res.;
                                 ENU=Post several documents at once. A report request window opens where you can specify which documents to post.];
                      ApplicationArea=#Service;
                      Image=PostBatch;
                      OnAction=BEGIN
                                 REPORT.RUNMODAL(REPORT::"Batch Post Service Cr. Memos",TRUE,TRUE,Rec);
                                 CurrPage.UPDATE(FALSE);
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
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Service;
                SourceExpr="No.";
                OnAssistEdit=BEGIN
                               IF AssistEdit(xRec) THEN
                                 CurrPage.UPDATE;
                             END;
                              }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den debitor, som ejer varerne i servicedokumentet.;
                           ENU=Specifies the number of the customer who owns the items in the service document.];
                ApplicationArea=#Service;
                SourceExpr="Customer No.";
                OnValidate=BEGIN
                             CustomerNoOnAfterValidate;
                           END;
                            }

    { 57  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den kontakt, som servicen skal leveres til.;
                           ENU=Specifies the number of the contact to whom you will deliver the service.];
                ApplicationArea=#Service;
                SourceExpr="Contact No.";
                OnValidate=BEGIN
                             IF GETFILTER("Contact No.") = xRec."Contact No." THEN
                               IF "Contact No." <> xRec."Contact No." THEN
                                 SETRANGE("Contact No.");
                           END;
                            }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den debitor, som varerne i bilaget skal leveres til.;
                           ENU=Specifies the name of the customer to whom the items on the document will be shipped.];
                ApplicationArea=#Service;
                SourceExpr=Name }

    { 65  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressen p† den debitor, som servicen skal leveres til.;
                           ENU=Specifies the address of the customer to whom the service will be shipped.];
                ApplicationArea=#Service;
                SourceExpr=Address }

    { 67  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Service;
                SourceExpr="Address 2" }

    { 70  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Service;
                SourceExpr="Post Code" }

    { 69  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver byen i adressen.;
                           ENU=Specifies the city of the address.];
                ApplicationArea=#Service;
                SourceExpr=City }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den kontakt, som vil modtage servicen.;
                           ENU=Specifies the name of the contact who will receive the service.];
                ApplicationArea=#Service;
                SourceExpr="Contact Name" }

    { 142 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver rollen for kontaktpersonen hos debitoren.;
                           ENU=Specifies the role of the contact person at the customer.];
                SourceExpr="Contact Role" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor servicedokumentet skal bogf›res.;
                           ENU=Specifies the date when the service document should be posted.];
                ApplicationArea=#Service;
                SourceExpr="Posting Date" }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Service;
                SourceExpr="Document Date" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den s‘lger, der er tilknyttet servicedokumentet.;
                           ENU=Specifies the code of the salesperson assigned to this service document.];
                ApplicationArea=#Service;
                SourceExpr="Salesperson Code";
                OnValidate=BEGIN
                             SalespersonCodeOnAfterValidate;
                           END;
                            }

    { 107 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode for ansvarscenteret (f.eks. et distributionscenter), som er tildelt den involverede bruger, virksomhed, debitor eller kreditor.;
                           ENU=Specifies the code of the responsibility center, such as a distribution hub, that is associated with the involved user, company, customer, or vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Responsibility Center";
                OnValidate=BEGIN
                             ResponsibilityCenterOnAfterVal;
                           END;
                            }

    { 111 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der er ansvarlig for bilaget.;
                           ENU=Specifies the ID of the user who is responsible for the document.];
                ApplicationArea=#Service;
                SourceExpr="Assigned User ID" }

    { 1101100004;2;Field  ;
                ToolTipML=[DAN=Angiver debitorens reference.;
                           ENU=Specifies the customer's reference.];
                SourceExpr="Your Reference" }

    { 48  ;1   ;Part      ;
                Name=ServLines;
                ApplicationArea=#Service;
                SubPageLink=Document No.=FIELD(No.);
                PagePartID=Page5936;
                PartType=Page }

    { 1905885101;1;Group  ;
                CaptionML=[DAN=Fakturering;
                           ENU=Invoicing] }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den debitor, som du sender eller har sendt fakturaen eller kreditnotaen til.;
                           ENU=Specifies the number of the customer that you send or sent the invoice or credit memo to.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Customer No.";
                OnValidate=BEGIN
                             BilltoCustomerNoOnAfterValidat;
                           END;
                            }

    { 124 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† kontaktpersonen p† debitorens faktureringsadresse.;
                           ENU=Specifies the number of the contact person at the customer's billing address.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Contact No." }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den debitor, som du sender eller har sendt fakturaen eller kreditnotaen til.;
                           ENU=Specifies the name of the customer that you send or sent the invoice or credit memo to.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Name" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressen p† den debitor, som du sender kreditnotaen til.;
                           ENU=Specifies the address of the customer to whom you will send the credit memo.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Address" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en supplerende linje i adressen.;
                           ENU=Specifies an additional line of the address.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Address 2" }

    { 75  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret i debitorens faktureringsadresse.;
                           ENU=Specifies the postal code of the customer's billing address.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Post Code" }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver byen i adressen.;
                           ENU=Specifies the city of the address.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to City" }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† kontaktpersonen p† debitorens faktureringsadresse.;
                           ENU=Specifies the name of the contact person at the customer's billing address.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Contact" }

    { 1101100000;2;Field  ;
                ToolTipML=[DAN=Angiver EAN-lokationsnummeret for debitoren.;
                           ENU=Specifies the EAN location number for the customer.];
                ApplicationArea=#Service;
                SourceExpr="EAN No." }

    { 1101100002;2;Field  ;
                ToolTipML=[DAN=Angiver kontokoden for debitoren.;
                           ENU=Specifies the account code of the customer.];
                ApplicationArea=#Service;
                SourceExpr="Account Code";
                OnValidate=BEGIN
                             AccountCodeOnAfterValidate;
                           END;
                            }

    { 1060000;2;Field     ;
                ToolTipML=[DAN=Angiver den profil, som debitoren kr‘ver til elektroniske dokumenter.;
                           ENU=Specifies the profile that this customer requires for electronic documents.];
                ApplicationArea=#Service;
                SourceExpr="OIOUBL Profile Code" }

    { 74  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                OnValidate=BEGIN
                             ShortcutDimension1CodeOnAfterV;
                           END;
                            }

    { 78  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code";
                OnValidate=BEGIN
                             ShortcutDimension2CodeOnAfterV;
                           END;
                            }

    { 131 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en formel, der beregner betalingens forfaldsdato, kontantrabatdato og kontantrabatbel›b.;
                           ENU=Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.];
                ApplicationArea=#Service;
                SourceExpr="Payment Terms Code" }

    { 133 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn†r den relaterede faktura skal betales.;
                           ENU=Specifies when the related invoice must be paid.];
                ApplicationArea=#Service;
                SourceExpr="Due Date" }

    { 135 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kontantrabatprocent, der gives, hvis debitoren betaler inden den dato, der er angivet i feltet Kont.rabatdato.;
                           ENU=Specifies the percentage of payment discount given, if the customer pays by the date entered in the Pmt. Discount Date field.];
                ApplicationArea=#Service;
                SourceExpr="Payment Discount %" }

    { 137 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor bel›bet i posten skal v‘re betalt, for at der kan opn†s kontantrabat.;
                           ENU=Specifies the date on which the amount in the entry must be paid for a payment discount to be granted.];
                ApplicationArea=#Service;
                SourceExpr="Pmt. Discount Date" }

    { 100 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om felterne Enhedspris og Linjebel›b p† bilagslinjer skal vises med eller uden moms.;
                           ENU=Specifies if the Unit Price and Line Amount fields on document lines should be shown with or without VAT.];
                ApplicationArea=#Service;
                SourceExpr="Prices Including VAT";
                OnValidate=BEGIN
                             PricesIncludingVATOnAfterValid;
                           END;
                            }

    { 1906801201;1;Group  ;
                CaptionML=[DAN=Levering;
                           ENU=Shipping] }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† debitoren p† den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the customer at the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Name" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den adresse, som varerne leveres til.;
                           ENU=Specifies the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Address" }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en supplerende del af leveringsadressen, hvis det er en lang adresse.;
                           ENU=Specifies an additional part of the ship-to address, in case it is a long address.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Address 2" }

    { 83  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret p† den adresse, som varerne leveres til.;
                           ENU=Specifies the postal code of the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Post Code" }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver byen i den adresse, som varerne leveres til.;
                           ENU=Specifies the city of the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to City" }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† kontaktpersonen p† den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the contact person at the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Contact" }

    { 80  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for lokationen (f.eks. lagersted eller distributionscenter) for de varer, der er angivet p† serviceartikellinjerne.;
                           ENU=Specifies the code of the location (for example, warehouse or distribution center) of the items specified on the service item lines.];
                ApplicationArea=#Location;
                SourceExpr="Location Code" }

    { 1907468901;1;Group  ;
                CaptionML=[DAN=Udenrigshandel;
                           ENU=Foreign Trade] }

    { 91  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver valutakoden for de forskellige bel›b p† servicelinjerne.;
                           ENU=Specifies the currency code for various amounts on the service lines.];
                ApplicationArea=#Advanced;
                SourceExpr="Currency Code";
                OnAssistEdit=BEGIN
                               CLEAR(ChangeExchangeRate);
                               ChangeExchangeRate.SetParameter("Currency Code","Currency Factor","Posting Date");
                               IF ChangeExchangeRate.RUNMODAL = ACTION::OK THEN BEGIN
                                 VALIDATE("Currency Factor",ChangeExchangeRate.GetParameter);
                                 CurrPage.UPDATE;
                               END;
                               CLEAR(ChangeExchangeRate);
                             END;
                              }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om transaktionen er relateret til handel med tredjepart i EU.;
                           ENU=Specifies if the transaction is related to trade with a third party within the EU.];
                ApplicationArea=#Service;
                SourceExpr="EU 3-Party Trade" }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den transaktionstype, som bilaget repr‘senterer med henblik p† rapportering til INTRASTAT.;
                           ENU=Specifies the type of transaction that the document represents, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Service;
                SourceExpr="Transaction Type" }

    { 89  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en specifikation af bilagets transaktion med henblik p† rapportering til INTRASTAT.;
                           ENU=Specifies a specification of the document's transaction, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Service;
                SourceExpr="Transaction Specification" }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver transportm†den ved rapportering til INTRASTAT.;
                           ENU=Specifies the transport method, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Service;
                SourceExpr="Transport Method" }

    { 85  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det udf›rselssted, hvor varerne blev udf›rt af landet/omr†det med henblik p† rapportering til Intrastat.;
                           ENU=Specifies the point of exit through which you ship the items out of your country/region, for reporting to Intrastat.];
                ApplicationArea=#Service;
                SourceExpr="Exit Point" }

    { 87  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitors eller kreditors omr†de med henblik p† rapportering til INTRASTAT.;
                           ENU=Specifies the area of the customer or vendor, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Service;
                SourceExpr=Area }

    { 1904409301;1;Group  ;
                CaptionML=[DAN=Udligning;
                           ENU=Application] }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den type bogf›rt bilag, som dette bilag eller denne kladdelinje udlignes med, n†r du bogf›rer, f.eks. til registrering af betaling.;
                           ENU=Specifies the type of the posted document that this document or journal line will be applied to when you post, for example to register payment.];
                ApplicationArea=#Service;
                SourceExpr="Applies-to Doc. Type" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det bogf›rte bilag, som dette bilag eller denne kladdelinje udlignes p†, n†r du bogf›rer, f.eks. til registrering af betaling.;
                           ENU=Specifies the number of the posted document that this document or journal line will be applied to when you post, for example to register payment.];
                ApplicationArea=#Service;
                SourceExpr="Applies-to Doc. No." }

    { 94  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id for poster, der udlignes, n†r du v‘lger handlingen Udlign poster.;
                           ENU=Specifies the ID of entries that will be applied to when you choose the Apply Entries action.];
                ApplicationArea=#Service;
                SourceExpr="Applies-to ID" }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1902018507;1;Part   ;
                ApplicationArea=#Service;
                SubPageLink=No.=FIELD(Bill-to Customer No.);
                PagePartID=Page9082;
                Visible=TRUE;
                PartType=Page }

    { 1900316107;1;Part   ;
                ApplicationArea=#Service;
                SubPageLink=No.=FIELD(Customer No.);
                PagePartID=Page9084;
                Visible=FALSE;
                PartType=Page }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                Visible=TRUE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      GetPrepaidTransactions@1006 : Report 6033;
      ReportPrint@1004 : Codeunit 228;
      UserMgt@1005 : Codeunit 5700;
      ServLogMgt@1000 : Codeunit 5906;
      ChangeExchangeRate@1002 : Page 511;
      DocumentIsPosted@1001 : Boolean;
      OpenPostedServiceCrMemoQst@1003 : TextConst 'DAN=Kreditnotaen er blevet bogf›rt og flyttet til vinduet Bogf›rte servicekreditnotaer.\\Vil du †bne den bogf›rte kreditnota?;ENU=The credit memo has been posted and moved to the Posted Service Credit Memos window.\\Do you want to open the posted credit memo?';

    LOCAL PROCEDURE ApproveCalcInvDisc@1();
    BEGIN
      CurrPage.ServLines.PAGE.ApproveCalcInvDisc;
    END;

    LOCAL PROCEDURE CustomerNoOnAfterValidate@19016267();
    BEGIN
      IF GETFILTER("Customer No.") = xRec."Customer No." THEN
        IF "Customer No." <> xRec."Customer No." THEN
          SETRANGE("Customer No.");
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE SalespersonCodeOnAfterValidate@19011896();
    BEGIN
      CurrPage.ServLines.PAGE.UpdateForm(TRUE);
    END;

    LOCAL PROCEDURE ResponsibilityCenterOnAfterVal@19032024();
    BEGIN
      CurrPage.ServLines.PAGE.UpdateForm(TRUE);
    END;

    LOCAL PROCEDURE BilltoCustomerNoOnAfterValidat@19044114();
    BEGIN
      CurrPage.UPDATE;
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

    LOCAL PROCEDURE AccountCodeOnAfterValidate@19007267();
    BEGIN
      CurrPage.ServLines.PAGE.UpdateForm(TRUE);
    END;

    LOCAL PROCEDURE ShowPostedConfirmationMessage@17(PreAssignedNo@1001 : Code[20]);
    VAR
      ServiceCrMemoHeader@1000 : Record 5994;
      InstructionMgt@1002 : Codeunit 1330;
    BEGIN
      ServiceCrMemoHeader.SETCURRENTKEY("Pre-Assigned No.");
      ServiceCrMemoHeader.SETRANGE("Pre-Assigned No.",PreAssignedNo);
      IF ServiceCrMemoHeader.FINDFIRST THEN
        IF InstructionMgt.ShowConfirm(OpenPostedServiceCrMemoQst,InstructionMgt.ShowPostedConfirmationMessageCode) THEN
          PAGE.RUN(PAGE::"Posted Service Credit Memo",ServiceCrMemoHeader);
    END;

    BEGIN
    END.
  }
}

