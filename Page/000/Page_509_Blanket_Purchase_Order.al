OBJECT Page 509 Blanket Purchase Order
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Rammekõbsordre;
               ENU=Blanket Purchase Order];
    SourceTable=Table38;
    SourceTableView=WHERE(Document Type=FILTER(Blanket Order));
    PageType=Document;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Godkend,Anmod om godkendelse;
                                ENU=New,Process,Report,Approve,Request Approval];
    OnOpenPage=BEGIN
                 IF UserMgt.GetPurchasesFilter <> '' THEN BEGIN
                   FILTERGROUP(2);
                   SETRANGE("Responsibility Center",UserMgt.GetPurchasesFilter);
                   FILTERGROUP(0);
                 END;

                 SetDocNoVisible;
               END;

    OnAfterGetRecord=BEGIN
                       SetControlAppearance;
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

    OnAfterGetCurrRecord=BEGIN
                           ShowWorkflowStatus := CurrPage.WorkflowStatus.PAGE.SetFilterOnWorkflowRecord(RECORDID);
                           CurrPage.ApprovalFactBox.PAGE.UpdateApprovalEntriesFromSourceRecord(RECORDID);
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 61      ;1   ;ActionGroup;
                      CaptionML=[DAN=O&rdre;
                                 ENU=O&rder];
                      Image=Order }
      { 63      ;2   ;Action    ;
                      Name=Statistics;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=FÜ vist statistiske oplysninger som f.eks. vërdien for bogfõrte poster til recorden.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 OpenPurchaseOrderStatistics;
                                 PurchCalcDiscByType.ResetRecalculateInvoiceDisc(Rec);
                               END;
                                }
      { 64      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om kreditoren i kõbsbilaget.;
                                 ENU=View or edit detailed information about the vendor on the purchase document.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 26;
                      RunPageLink=No.=FIELD(Buy-from Vendor No.);
                      Image=EditLines }
      { 65      ;2   ;Action    ;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 66;
                      RunPageLink=Document Type=CONST(Blanket Order),
                                  No.=FIELD(No.),
                                  Document Line No.=CONST(0);
                      Image=ViewComments }
      { 120     ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omrÜde, projekt eller afdeling, som du kan tildele til salgs- og kõbsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      Enabled="No." <> '';
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDocDim;
                               END;
                                }
      { 17      ;2   ;Action    ;
                      Name=Approvals;
                      AccessByPermission=TableData 454=R;
                      CaptionML=[DAN=Godkendelser;
                                 ENU=Approvals];
                      ToolTipML=[DAN=FÜ vist en liste over records, der afventer godkendelse. Du kan f.eks. se, hvem der har anmodet om godkendelse af recorden, hvornÜr den blev sendt og hvornÜr den skal godkendes.;
                                 ENU=View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.];
                      ApplicationArea=#Advanced;
                      Image=Approvals;
                      OnAction=VAR
                                 WorkflowsEntriesBuffer@1000 : Record 832;
                               BEGIN
                                 WorkflowsEntriesBuffer.RunWorkflowEntriesPage(RECORDID,DATABASE::"Purchase Header","Document Type","No.");
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 15      ;1   ;ActionGroup;
                      CaptionML=[DAN=Godkendelse;
                                 ENU=Approval] }
      { 13      ;2   ;Action    ;
                      Name=Approve;
                      CaptionML=[DAN=Godkend;
                                 ENU=Approve];
                      ToolTipML=[DAN=Godkend de anmodede ëndringer.;
                                 ENU=Approve the requested changes.];
                      ApplicationArea=#Advanced;
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
      { 11      ;2   ;Action    ;
                      Name=Reject;
                      CaptionML=[DAN=Afvis;
                                 ENU=Reject];
                      ToolTipML=[DAN=Afvis godkendelsesanmodningen.;
                                 ENU=Reject the approval request.];
                      ApplicationArea=#Advanced;
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
      { 9       ;2   ;Action    ;
                      Name=Delegate;
                      CaptionML=[DAN=Uddeleger;
                                 ENU=Delegate];
                      ToolTipML=[DAN=Uddeleger godkendelsen til en stedfortrëdende godkender.;
                                 ENU=Delegate the approval to a substitute approver.];
                      ApplicationArea=#Advanced;
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
      { 7       ;2   ;Action    ;
                      Name=Comment;
                      CaptionML=[DAN=Bemërkninger;
                                 ENU=Comments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
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
      { 68      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 69      ;2   ;Action    ;
                      Name=CalculateInvoiceDiscount;
                      AccessByPermission=TableData 24=R;
                      CaptionML=[DAN=&Beregn fakturarabat;
                                 ENU=Calculate &Invoice Discount];
                      ToolTipML=[DAN=Beregn fakturarabatten for hele kõbsfakturaen.;
                                 ENU=Calculate the invoice discount for the entire purchase invoice.];
                      ApplicationArea=#Advanced;
                      Image=CalculateInvoiceDiscount;
                      OnAction=BEGIN
                                 ApproveCalcInvDisc;
                                 PurchCalcDiscByType.ResetRecalculateInvoiceDisc(Rec);
                               END;
                                }
      { 133     ;2   ;Separator  }
      { 70      ;2   ;Action    ;
                      Name=CopyDocument;
                      Ellipsis=Yes;
                      CaptionML=[DAN=KopiÇr dokument;
                                 ENU=Copy Document];
                      ToolTipML=[DAN=KopiÇr linjer og sidehovedoplysninger fra et andet salgsbilag til dette bilag. Du kan kopiere en bogfõrt salgsfaktura til en ny salgsfaktura, hvis du hurtigt vil oprette et lignende bilag.;
                                 ENU=Copy document lines and header information from another sales document to this document. You can copy a posted sales invoice into a new sales invoice to quickly create a similar document.];
                      ApplicationArea=#Advanced;
                      Image=CopyDocument;
                      OnAction=BEGIN
                                 CopyPurchDoc.SetPurchHeader(Rec);
                                 CopyPurchDoc.RUNMODAL;
                                 CLEAR(CopyPurchDoc);
                               END;
                                }
      { 126     ;2   ;Action    ;
                      Name=Release;
                      ShortCutKey=Ctrl+F9;
                      CaptionML=[DAN=F&rigiv;
                                 ENU=Re&lease];
                      ToolTipML=[DAN=Frigiv bilaget til nëste behandlingstrin. NÜr et bilag frigives, bliver det inkluderet i alle disponeringsberegninger fra den dato, varerne forventes modtaget. Du skal genÜbne bilaget, fõr du kan foretage ëndringer i det.;
                                 ENU=Release the document to the next stage of processing. When a document is released, it will be included in all availability calculations from the expected receipt date of the items. You must reopen the document before you can make changes to it.];
                      ApplicationArea=#Advanced;
                      Image=ReleaseDoc;
                      OnAction=VAR
                                 ReleasePurchDoc@1000 : Codeunit 415;
                               BEGIN
                                 ReleasePurchDoc.PerformManualRelease(Rec);
                               END;
                                }
      { 127     ;2   ;Action    ;
                      Name=Reopen;
                      CaptionML=[DAN=&èbn igen;
                                 ENU=Re&open];
                      ToolTipML=[DAN=èbn bilaget igen for at ëndre det, efter at det er blevet godkendt. Godkendte bilag har status Frigivet og skal Übnes, fõr de kan ëndres;
                                 ENU=Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed];
                      ApplicationArea=#Advanced;
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
      { 19      ;1   ;ActionGroup;
                      CaptionML=[DAN=Anmod om godkendelse;
                                 ENU=Request Approval] }
      { 140     ;2   ;Action    ;
                      Name=SendApprovalRequest;
                      CaptionML=[DAN=Send go&dkendelsesanmodning;
                                 ENU=Send A&pproval Request];
                      ToolTipML=[DAN=Anmod om godkendelse af bilaget.;
                                 ENU=Request approval of the document.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Enabled=NOT OpenApprovalEntriesExist;
                      PromotedIsBig=Yes;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 IF ApprovalsMgmt.CheckPurchaseApprovalPossible(Rec) THEN
                                   ApprovalsMgmt.OnSendPurchaseDocForApproval(Rec);
                               END;
                                }
      { 141     ;2   ;Action    ;
                      Name=CancelApprovalRequest;
                      CaptionML=[DAN=Annuller godkendelsesan&modning;
                                 ENU=Cancel Approval Re&quest];
                      ToolTipML=[DAN=Annuller godkendelsesanmodningen.;
                                 ENU=Cancel the approval request.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Enabled=CanCancelApprovalForRecord;
                      PromotedIsBig=Yes;
                      Image=CancelApprovalRequest;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.OnCancelPurchaseApprovalRequest(Rec);
                               END;
                                }
      { 77      ;1   ;Action    ;
                      Name=MakeOrder;
                      CaptionML=[DAN=Lav &ordre;
                                 ENU=Make &Order];
                      ToolTipML=[DAN=Konverter rammekõbsordren til en kõbsordre.;
                                 ENU=Convert the blank purchase order to a purchase order.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Image=MakeOrder;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 ApprovalsMgmt@1001 : Codeunit 1535;
                               BEGIN
                                 IF ApprovalsMgmt.PrePostApprovalCheckPurch(Rec) THEN
                                   CODEUNIT.RUN(CODEUNIT::"Blnkt Purch Ord. to Ord. (Y/N)",Rec);
                               END;
                                }
      { 82      ;1   ;Action    ;
                      Name=Print;
                      Ellipsis=Yes;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=Gõr dig klar til at udskrive bilaget. Der Übnes et rapportanmodningsvindue for bilaget, hvor du kan angive, hvad der skal medtages pÜ udskriften.;
                                 ENU=Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Image=Print;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 DocPrint.PrintPurchHeader(Rec);
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
                ApplicationArea=#Advanced;
                SourceExpr="No.";
                Visible=DocNoVisible;
                OnAssistEdit=BEGIN
                               IF AssistEdit(xRec) THEN
                                 CurrPage.UPDATE;
                             END;
                              }

    { 4   ;2   ;Field     ;
                CaptionML=[DAN=Kreditornr.;
                           ENU=Vendor No.];
                ToolTipML=[DAN=Angiver nummeret pÜ den kreditor, der leverer produkterne.;
                           ENU=Specifies the number of the vendor who delivers the products.];
                ApplicationArea=#Advanced;
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
                ApplicationArea=#Advanced;
                SourceExpr="Buy-from Vendor Name";
                Importance=Promoted;
                OnValidate=BEGIN
                             OnAfterValidateBuyFromVendorNo(Rec,xRec);

                             CurrPage.UPDATE;
                           END;
                            }

    { 21  ;2   ;Group     ;
                CaptionML=[DAN=Leverandõr;
                           ENU=Buy-from];
                GroupType=Group }

    { 89  ;3   ;Field     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                ToolTipML=[DAN=Angiver adressen pÜ den kreditor, der leverer varerne.;
                           ENU=Specifies the address of the vendor who ships the items.];
                ApplicationArea=#Advanced;
                SourceExpr="Buy-from Address";
                Importance=Additional }

    { 91  ;3   ;Field     ;
                CaptionML=[DAN=Adresse 2;
                           ENU=Address 2];
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Advanced;
                SourceExpr="Buy-from Address 2";
                Importance=Additional }

    { 76  ;3   ;Field     ;
                CaptionML=[DAN=Postnr.;
                           ENU=Post Code];
                ToolTipML=[DAN=Angiver postnummer.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Advanced;
                SourceExpr="Buy-from Post Code";
                Importance=Additional }

    { 93  ;3   ;Field     ;
                CaptionML=[DAN=By;
                           ENU=City];
                ToolTipML=[DAN=Angiver byen for den kreditor, der leverer varerne.;
                           ENU=Specifies the city of the vendor who ships the items.];
                ApplicationArea=#Advanced;
                SourceExpr="Buy-from City";
                Importance=Additional }

    { 128 ;3   ;Field     ;
                CaptionML=[DAN=Kontaktnr.;
                           ENU=Contact No.];
                ToolTipML=[DAN=Angiver nummeret pÜ din kontakt hos kreditoren.;
                           ENU=Specifies the number of your contact at the vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Buy-from Contact No.";
                Importance=Additional }

    { 8   ;2   ;Field     ;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                ToolTipML=[DAN=Angiver navnet pÜ den person, der skal kontaktes om leveringen af varer fra denne kreditor.;
                           ENU=Specifies the name of the person to contact about shipment of the item from this vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Buy-from Contact";
                Editable="Buy-from Vendor No." <> '' }

    { 49  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Document Date" }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvornÜr den relaterede salgsfaktura skal betales.;
                           ENU=Specifies when the related sales invoice must be paid.];
                ApplicationArea=#Advanced;
                SourceExpr="Due Date" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor ordren blev oprettet.;
                           ENU=Specifies the date when the order was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Order Date" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens leverancenummer. Det indsëttes i det tilsvarende felt pÜ kildedokumentet ved bogfõringen.;
                           ENU=Specifies the vendor's shipment number. It is inserted in the corresponding field on the source document during posting.];
                ApplicationArea=#Advanced;
                SourceExpr="Vendor Shipment No." }

    { 96  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den bestillingsadressekode, der er knyttet til den pÜgëldende kreditors bestillingsadresse.;
                           ENU=Specifies the order address code linked to the relevant vendor's order address.];
                ApplicationArea=#Advanced;
                SourceExpr="Order Address Code" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens ordrenummer.;
                           ENU=Specifies the vendor's order number.];
                ApplicationArea=#Advanced;
                SourceExpr="Vendor Order No." }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken indkõber der er tilknyttet kreditoren.;
                           ENU=Specifies which purchaser is assigned to the vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Purchaser Code";
                OnValidate=BEGIN
                             PurchaserCodeOnAfterValidate;
                           END;
                            }

    { 1102601000;2;Field  ;
                ToolTipML=[DAN=Angiver nummeret pÜ den kampagne, bilaget er knyttet til.;
                           ENU=Specifies the campaign number the document is linked to.];
                ApplicationArea=#Advanced;
                SourceExpr="Campaign No." }

    { 122 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode for ansvarscenteret (f.eks. et distributionscenter), som er tildelt den involverede bruger, virksomhed, debitor eller kreditor.;
                           ENU=Specifies the code of the responsibility center, such as a distribution hub, that is associated with the involved user, company, customer, or vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Responsibility Center" }

    { 72  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der er ansvarlig for bilaget.;
                           ENU=Specifies the ID of the user who is responsible for the document.];
                ApplicationArea=#Advanced;
                SourceExpr="Assigned User ID" }

    { 124 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om recorden er Üben, afventer godkendelse, er faktureret til forudbetaling eller er frigivet til nëste fase i behandlingen.;
                           ENU=Specifies whether the record is open, waiting to be approved, invoiced for prepayment, or released to the next stage of processing.];
                ApplicationArea=#Advanced;
                SourceExpr=Status }

    { 60  ;1   ;Part      ;
                Name=PurchLines;
                ApplicationArea=#Advanced;
                SubPageLink=Document No.=FIELD(No.);
                PagePartID=Page510;
                Enabled="Buy-from Vendor No." <> '';
                Editable="Buy-from Vendor No." <> '';
                UpdatePropagation=Both }

    { 1905885101;1;Group  ;
                CaptionML=[DAN=Fakturadetaljer;
                           ENU=Invoice Details];
                GroupType=Group }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den valutakode, der er brugt i posten.;
                           ENU=Specifies the currency that is used on the entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Currency Code";
                OnValidate=BEGIN
                             CurrPage.UPDATE;
                             PurchCalcDiscByType.ApplyDefaultInvoiceDiscount(0,Rec);
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

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN="Angiver den dato, hvor du forventer, at varerne er tilgëngelige pÜ lageret. Hvis du lader feltet vëre tomt, bliver det beregnet pÜ fõlgende mÜde: Planlagt modtagelsesdato + Sikkerhedstid + IndgÜende lagerekspeditionstid = Forventet modtagelsesdato.";
                           ENU="Specifies the date you expect the items to be available in your warehouse. If you leave the field blank, it will be calculated as follows: Planned Receipt Date + Safety Lead Time + Inbound Warehouse Handling Time = Expected Receipt Date."];
                ApplicationArea=#Advanced;
                SourceExpr="Expected Receipt Date" }

    { 66  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om felterne Enhedspris og Linjebelõb pÜ bilagslinjer skal vises med eller uden moms.;
                           ENU=Specifies if the Unit Price and Line Amount fields on document lines should be shown with or without VAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Prices Including VAT";
                OnValidate=BEGIN
                             PricesIncludingVATOnAfterValid;
                           END;
                            }

    { 136 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede debitors eller kreditors momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogfõringsopsëtning.;
                           ENU=Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Advanced;
                SourceExpr="VAT Bus. Posting Group" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en formel, der beregner betalingens forfaldsdato, kontantrabatdato og kontantrabatbelõb.;
                           ENU=Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.];
                ApplicationArea=#Advanced;
                SourceExpr="Payment Terms Code" }

    { 78  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan betalingen skal foretages, f.eks. via bankoverfõrsel, kontant eller med check.;
                           ENU=Specifies how to make payment, such as with bank transfer, cash,  or check.];
                ApplicationArea=#Advanced;
                SourceExpr="Payment Method Code" }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den transaktionstype, som bilaget reprësenterer med henblik pÜ rapportering til INTRASTAT.;
                           ENU=Specifies the type of transaction that the document represents, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Transaction Type" }

    { 100 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                OnValidate=BEGIN
                             ShortcutDimension1CodeOnAfterV;
                           END;
                            }

    { 102 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code";
                OnValidate=BEGIN
                             ShortcutDimension2CodeOnAfterV;
                           END;
                            }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den rabatprocent, der tildeles, hvis du betaler pÜ eller fõr den dato, der er angivet i feltet Kont.rabatdato. Rabatprocenten er angivet i feltet Betalingsbetingelseskode.;
                           ENU=Specifies the payment discount percentage that is granted if you pay on or before the date entered in the Pmt. Discount Date field. The discount percentage is specified in the Payment Terms Code field.];
                ApplicationArea=#Advanced;
                SourceExpr="Payment Discount %" }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor belõbet i posten skal vëre betalt, for at der kan opnÜs kontantrabat.;
                           ENU=Specifies the date on which the amount in the entry must be paid for a payment discount to be granted.];
                ApplicationArea=#Advanced;
                SourceExpr="Pmt. Discount Date" }

    { 104 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for den lokation, hvor varerne skal placeres efter modtagelse.;
                           ENU=Specifies a code for the location where you want the items to be placed when they are received.];
                ApplicationArea=#Advanced;
                SourceExpr="Location Code" }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver betingelserne for levering af den relaterede leverance, som f.eks. frit ombord (FOB).;
                           ENU=Specifies the delivery conditions of the related shipment, such as free on board (FOB).];
                ApplicationArea=#Advanced;
                SourceExpr="Shipment Method Code" }

    { 106 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den tilknyttede post reprësenterer en ubetalt faktura, som der findes et betalingsforslag, en rykker eller en rentenota til.;
                           ENU=Specifies that the related entry represents an unpaid invoice for which either a payment suggestion, a reminder, or a finance charge memo exists.];
                ApplicationArea=#Advanced;
                SourceExpr="On Hold" }

    { 1906801201;1;Group  ;
                CaptionML=[DAN=Forsendelse og betaling;
                           ENU=Shipping and Payment];
                GroupType=Group }

    { 23  ;2   ;Group     ;
                CaptionML=[DAN=Leveres til;
                           ENU=Ship-to];
                GroupType=Group }

    { 42  ;3   ;Field     ;
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver navnet pÜ firmaet med den adresse, som varerne i kõbsordren skal leveres til.;
                           ENU=Specifies the name of the company at the address to which you want the items in the purchase order to be shipped.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Name";
                Importance=Additional }

    { 44  ;3   ;Field     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                ToolTipML=[DAN=Angiver den adresse, som varerne i kõbsordren skal leveres til.;
                           ENU=Specifies the address that you want the items in the purchase order to be shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Address";
                Importance=Additional }

    { 46  ;3   ;Field     ;
                CaptionML=[DAN=Adresse 2;
                           ENU=Address 2];
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Address 2";
                Importance=Additional }

    { 109 ;3   ;Field     ;
                CaptionML=[DAN=Postnr.;
                           ENU=Post Code];
                ToolTipML=[DAN=Angiver postnummer.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Post Code";
                Importance=Additional }

    { 48  ;3   ;Field     ;
                CaptionML=[DAN=By;
                           ENU=City];
                ToolTipML=[DAN=Angiver den by, som varerne i kõbsordren skal leveres til.;
                           ENU=Specifies the city the items in the purchase order will be shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to City";
                Importance=Additional }

    { 50  ;3   ;Field     ;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                ToolTipML=[DAN=Angiver navnet pÜ en kontaktperson pÜ den adresse, som varerne i kõbsordren skal leveres pÜ.;
                           ENU=Specifies the name of a contact person for the address where the items in the purchase order should be shipped.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Contact";
                Importance=Additional }

    { 25  ;2   ;Group     ;
                CaptionML=[DAN=Faktureres til;
                           ENU=Pay-to];
                GroupType=Group }

    { 24  ;3   ;Field     ;
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver navnet pÜ den kreditor, fakturaen er sendt fra.;
                           ENU=Specifies the name of the vendor sending the invoice.];
                ApplicationArea=#Advanced;
                SourceExpr="Pay-to Name";
                Importance=Promoted }

    { 26  ;3   ;Field     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                ToolTipML=[DAN=Angiver adressen pÜ den kreditor, fakturaen er sendt fra.;
                           ENU=Specifies the address of the vendor sending the invoice.];
                ApplicationArea=#Advanced;
                SourceExpr="Pay-to Address";
                Importance=Additional;
                Enabled="Buy-from Vendor No." <> "Pay-to Vendor No.";
                Editable="Buy-from Vendor No." <> "Pay-to Vendor No." }

    { 28  ;3   ;Field     ;
                CaptionML=[DAN=Adresse 2;
                           ENU=Address 2];
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Advanced;
                SourceExpr="Pay-to Address 2";
                Importance=Additional;
                Enabled="Buy-from Vendor No." <> "Pay-to Vendor No.";
                Editable="Buy-from Vendor No." <> "Pay-to Vendor No." }

    { 97  ;3   ;Field     ;
                CaptionML=[DAN=Postnr.;
                           ENU=Post Code];
                ToolTipML=[DAN=Angiver postnummer.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Advanced;
                SourceExpr="Pay-to Post Code";
                Importance=Additional;
                Enabled="Buy-from Vendor No." <> "Pay-to Vendor No.";
                Editable="Buy-from Vendor No." <> "Pay-to Vendor No." }

    { 30  ;3   ;Field     ;
                CaptionML=[DAN=By;
                           ENU=City];
                ToolTipML=[DAN=Angiver byen for den kreditor, fakturaen er sendt fra.;
                           ENU=Specifies the city of the vendor sending the invoice.];
                ApplicationArea=#Advanced;
                SourceExpr="Pay-to City";
                Importance=Additional;
                Enabled="Buy-from Vendor No." <> "Pay-to Vendor No.";
                Editable="Buy-from Vendor No." <> "Pay-to Vendor No." }

    { 130 ;3   ;Field     ;
                CaptionML=[DAN=Kontaktnr.;
                           ENU=Contact No.];
                ToolTipML=[DAN=Angiver nummeret pÜ den kontakt, der sender fakturaen.;
                           ENU=Specifies the number of the contact who sends the invoice.];
                ApplicationArea=#Advanced;
                SourceExpr="Pay-to Contact No.";
                Importance=Additional;
                Enabled="Buy-from Vendor No." <> "Pay-to Vendor No.";
                Editable="Buy-from Vendor No." <> "Pay-to Vendor No." }

    { 32  ;3   ;Field     ;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                ToolTipML=[DAN=Angiver navnet pÜ den kontaktperson hos kreditoren, som fakturaen er sendt fra.;
                           ENU=Specifies the name of the person to contact about an invoice from this vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Pay-to Contact";
                Importance=Additional;
                Enabled="Buy-from Vendor No." <> "Pay-to Vendor No.";
                Editable="Buy-from Vendor No." <> "Pay-to Vendor No." }

    { 1907468901;1;Group  ;
                CaptionML=[DAN=Udenrigshandel;
                           ENU=Foreign Trade] }

    { 115 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en specifikation af bilagets transaktion med henblik pÜ rapportering til INTRASTAT.;
                           ENU=Specifies a specification of the document's transaction, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Transaction Specification" }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver transportmÜden ved rapportering til INTRASTAT.;
                           ENU=Specifies the transport method, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Transport Method" }

    { 111 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for det indfõrselssted, hvor varerne kom ind i landet/omrÜdet, for rapportering til Intrastat.;
                           ENU=Specifies the code of the port of entry where the items pass into your country/region, for reporting to Intrastat.];
                ApplicationArea=#Advanced;
                SourceExpr="Entry Point" }

    { 113 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitors eller kreditors omrÜde med henblik pÜ rapportering til INTRASTAT.;
                           ENU=Specifies the area of the customer or vendor, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr=Area }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 5   ;1   ;Part      ;
                ApplicationArea=#Advanced;
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
                PartType=Page }

    { 1904651607;1;Part   ;
                ApplicationArea=#Advanced;
                SubPageLink=No.=FIELD(Pay-to Vendor No.);
                PagePartID=Page9094;
                PartType=Page }

    { 3   ;1   ;Part      ;
                ApplicationArea=#Advanced;
                SubPageLink=Document Type=FIELD(Document Type),
                            No.=FIELD(No.),
                            Line No.=FIELD(Line No.);
                PagePartID=Page9100;
                ProviderID=60;
                Visible=FALSE;
                PartType=Page }

    { 20  ;1   ;Part      ;
                Name=WorkflowStatus;
                ApplicationArea=#Advanced;
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
      CopyPurchDoc@1005 : Report 492;
      DocPrint@1006 : Codeunit 229;
      UserMgt@1009 : Codeunit 5700;
      PurchCalcDiscByType@1001 : Codeunit 66;
      ChangeExchangeRate@1002 : Page 511;
      DocNoVisible@1000 : Boolean;
      OpenApprovalEntriesExist@1003 : Boolean;
      OpenApprovalEntriesExistForCurrUser@1007 : Boolean;
      ShowWorkflowStatus@1004 : Boolean;
      CanCancelApprovalForRecord@1008 : Boolean;

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
      CurrPage.PurchLines.PAGE.UpdateForm(TRUE);
    END;

    LOCAL PROCEDURE ShortcutDimension2CodeOnAfterV@19008725();
    BEGIN
      CurrPage.PurchLines.PAGE.UpdateForm(TRUE);
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
      DocNoVisible := DocumentNoVisibility.PurchaseDocumentNoIsVisible(DocType::"Blanket Order","No.");
    END;

    LOCAL PROCEDURE SetControlAppearance@5();
    VAR
      ApprovalsMgmt@1002 : Codeunit 1535;
    BEGIN
      OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RECORDID);
      OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);

      CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RECORDID);
    END;

    BEGIN
    END.
  }
}

