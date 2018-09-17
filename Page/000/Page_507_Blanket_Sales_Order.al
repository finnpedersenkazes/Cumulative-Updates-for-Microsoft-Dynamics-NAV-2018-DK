OBJECT Page 507 Blanket Sales Order
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572,NAVDK11.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Rammesalgsordre;
               ENU=Blanket Sales Order];
    SourceTable=Table36;
    SourceTableView=WHERE(Document Type=FILTER(Blanket Order));
    PageType=Document;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Godkend,Anmod om godkendelse;
                                ENU=New,Process,Report,Approve,Request Approval];
    OnOpenPage=BEGIN
                 IF UserMgt.GetSalesFilter <> '' THEN BEGIN
                   FILTERGROUP(2);
                   SETRANGE("Responsibility Center",UserMgt.GetSalesFilter);
                   FILTERGROUP(0);
                 END;

                 SetDocNoVisible;
               END;

    OnAfterGetRecord=BEGIN
                       SetControlAppearance;
                       UpdateShipToBillToGroupVisibility
                     END;

    OnNewRecord=BEGIN
                  xRec.INIT;
                  "Responsibility Center" := UserMgt.GetSalesFilter;
                  IF (NOT DocNoVisible) AND ("No." = '') THEN
                    SetSellToCustomerFromFilter;
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
                           ShowWorkflowStatus := CurrPage.WorkflowStatus.PAGE.SetFilterOnWorkflowRecord(RECORDID);
                           CurrPage.ApprovalFactBox.PAGE.UpdateApprovalEntriesFromSourceRecord(RECORDID);
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 59      ;1   ;ActionGroup;
                      CaptionML=[DAN=O&rdre;
                                 ENU=O&rder];
                      Image=Order }
      { 61      ;2   ;Action    ;
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
                      OnAction=VAR
                                 Handled@1000 : Boolean;
                               BEGIN
                                 OnBeforeStatisticsAction(Rec,Handled);
                                 IF NOT Handled THEN BEGIN
                                   OpenSalesOrderStatistics;
                                   SalesCalcDiscByType.ResetRecalculateInvoiceDisc(Rec);
                                 END
                               END;
                                }
      { 62      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Se eller rediger detaljerede oplysninger om debitoren i salgsbilaget.;
                                 ENU=View or edit detailed information about the customer on the sales document.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 21;
                      RunPageLink=No.=FIELD(Sell-to Customer No.);
                      Image=EditLines }
      { 63      ;2   ;Action    ;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 67;
                      RunPageLink=Document Type=CONST(Blanket Order),
                                  No.=FIELD(No.),
                                  Document Line No.=CONST(0);
                      Image=ViewComments }
      { 115     ;2   ;Action    ;
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
      { 137     ;2   ;Action    ;
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
                                 WorkflowsEntriesBuffer.RunWorkflowEntriesPage(RECORDID,DATABASE::"Sales Header","Document Type","No.");
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 11      ;1   ;ActionGroup;
                      CaptionML=[DAN=Godkendelse;
                                 ENU=Approval] }
      { 9       ;2   ;Action    ;
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
      { 7       ;2   ;Action    ;
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
      { 5       ;2   ;Action    ;
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
      { 3       ;2   ;Action    ;
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
      { 66      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 67      ;2   ;Action    ;
                      Name=CalculateInvoiceDiscount;
                      AccessByPermission=TableData 19=R;
                      CaptionML=[DAN=&Beregn fakturarabat;
                                 ENU=Calculate &Invoice Discount];
                      ToolTipML=[DAN=Beregn fakturarabatten for salgsordren.;
                                 ENU=Calculate the invoice discount that applies to the sales order.];
                      ApplicationArea=#Advanced;
                      Image=CalculateInvoiceDiscount;
                      OnAction=BEGIN
                                 ApproveCalcInvDisc;
                                 SalesCalcDiscByType.ResetRecalculateInvoiceDisc(Rec);
                               END;
                                }
      { 134     ;2   ;Separator  }
      { 68      ;2   ;Action    ;
                      Name=CopyDocument;
                      Ellipsis=Yes;
                      CaptionML=[DAN=KopiÇr dokument;
                                 ENU=Copy Document];
                      ToolTipML=[DAN=KopiÇr linjer og sidehovedoplysninger fra et andet salgsbilag til dette bilag. Du kan kopiere en bogfõrt salgsfaktura til en ny salgsfaktura, hvis du hurtigt vil oprette et lignende bilag.;
                                 ENU=Copy document lines and header information from another sales document to this document. You can copy a posted sales invoice into a new sales invoice to quickly create a similar document.];
                      ApplicationArea=#Advanced;
                      Image=CopyDocument;
                      OnAction=BEGIN
                                 CopySalesDoc.SetSalesHeader(Rec);
                                 CopySalesDoc.RUNMODAL;
                                 CLEAR(CopySalesDoc);
                               END;
                                }
      { 138     ;2   ;Separator  }
      { 121     ;2   ;Action    ;
                      Name=Release;
                      ShortCutKey=Ctrl+F9;
                      CaptionML=[DAN=F&rigiv;
                                 ENU=Re&lease];
                      ToolTipML=[DAN=Frigiv bilaget til nëste behandlingstrin. NÜr et bilag frigives, bliver det inkluderet i alle disponeringsberegninger fra den dato, varerne forventes modtaget. Du skal genÜbne bilaget, fõr du kan foretage ëndringer i det.;
                                 ENU=Release the document to the next stage of processing. When a document is released, it will be included in all availability calculations from the expected receipt date of the items. You must reopen the document before you can make changes to it.];
                      ApplicationArea=#Advanced;
                      Image=ReleaseDoc;
                      OnAction=VAR
                                 ReleaseSalesDoc@1000 : Codeunit 414;
                               BEGIN
                                 ReleaseSalesDoc.PerformManualRelease(Rec);
                               END;
                                }
      { 122     ;2   ;Action    ;
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
                                 ReleaseSalesDoc@1001 : Codeunit 414;
                               BEGIN
                                 ReleaseSalesDoc.PerformManualReopen(Rec);
                               END;
                                }
      { 73      ;1   ;Action    ;
                      Name=MakeOrder;
                      CaptionML=[DAN=Lav &ordre;
                                 ENU=Make &Order];
                      ToolTipML=[DAN=Konverter rammesalgsordren til en salgsordre.;
                                 ENU=Convert the blanket sales order to a sales order.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Image=MakeOrder;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 ApprovalsMgmt@1001 : Codeunit 1535;
                               BEGIN
                                 IF ApprovalsMgmt.PrePostApprovalCheckSales(Rec) THEN
                                   CODEUNIT.RUN(CODEUNIT::"Blnkt Sales Ord. to Ord. (Y/N)",Rec);
                               END;
                                }
      { 78      ;1   ;Action    ;
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
                                 DocPrint.PrintSalesHeader(Rec);
                               END;
                                }
      { 15      ;1   ;ActionGroup;
                      CaptionML=[DAN=Anmod om godkendelse;
                                 ENU=Request Approval] }
      { 139     ;2   ;Action    ;
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
                                 IF ApprovalsMgmt.CheckSalesApprovalPossible(Rec) THEN
                                   ApprovalsMgmt.OnSendSalesDocForApproval(Rec);
                               END;
                                }
      { 140     ;2   ;Action    ;
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
                                 ApprovalsMgmt.OnCancelSalesApprovalRequest(Rec);
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
                Importance=Additional;
                Visible=DocNoVisible;
                OnAssistEdit=BEGIN
                               IF AssistEdit(xRec) THEN
                                 CurrPage.UPDATE;
                             END;
                              }

    { 47  ;2   ;Field     ;
                CaptionML=[DAN=Debitornr.;
                           ENU=Customer No.];
                ToolTipML=[DAN=Angiver nummeret pÜ den debitor, der modtager produkterne og faktureres som standard.;
                           ENU=Specifies the number of the customer who will receive the products and be billed by default.];
                ApplicationArea=#Advanced;
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
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Customer Name";
                Importance=Promoted;
                OnValidate=BEGIN
                             SelltoCustomerNoOnAfterValidate(Rec,xRec);

                             CurrPage.UPDATE;
                           END;
                            }

    { 19  ;2   ;Group     ;
                CaptionML=[DAN=Kunde;
                           ENU=Sell-to];
                GroupType=Group }

    { 81  ;3   ;Field     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                ToolTipML=[DAN=Angiver debitorens adresse.;
                           ENU=Specifies the customer's address.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Address";
                Importance=Additional }

    { 83  ;3   ;Field     ;
                CaptionML=[DAN=Adresse 2;
                           ENU=Address 2];
                ToolTipML=[DAN=Angiver en supplerende del af debitorens adresse.;
                           ENU=Specifies an additional part of the customer's address.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Address 2";
                Importance=Additional }

    { 72  ;3   ;Field     ;
                CaptionML=[DAN=Postnr.;
                           ENU=Post Code];
                ToolTipML=[DAN=Angiver postnummeret i debitorens adresse.;
                           ENU=Specifies the postal code of the customer's address.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Post Code";
                Importance=Additional }

    { 86  ;3   ;Field     ;
                CaptionML=[DAN=By;
                           ENU=City];
                ToolTipML=[DAN=Angiver byen i debitorens adresse.;
                           ENU=Specifies the city of the customer's address.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to City";
                Importance=Additional }

    { 125 ;3   ;Field     ;
                CaptionML=[DAN=Kontaktnr.;
                           ENU=Contact No.];
                ToolTipML=[DAN=Angiver nummeret pÜ kontaktpersonen hos debitoren.;
                           ENU=Specifies the number of the contact person at the customer.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Contact No.";
                Importance=Additional;
                OnValidate=BEGIN
                             IF GETFILTER("Sell-to Contact No.") = xRec."Sell-to Contact No." THEN
                               IF "Sell-to Contact No." <> xRec."Sell-to Contact No." THEN
                                 SETRANGE("Sell-to Contact No.");
                           END;
                            }

    { 8   ;2   ;Field     ;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                ToolTipML=[DAN=Angiver navnet pÜ kontaktpersonen hos debitoren.;
                           ENU=Specifies the name of the contact person at the customer.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Contact";
                Editable="Sell-to Customer No." <> '' }

    { 1060005;2;Field     ;
                ToolTipML=[DAN=Angiver telefonnummeret pÜ kontaktpersonen hos debitoren.;
                           ENU=Specifies the telephone number of the contact person at the customer.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Contact Phone No." }

    { 1060003;2;Field     ;
                ToolTipML=[DAN="Angiver faxnummeret pÜ kontaktpersonen hos debitoren. ";
                           ENU="Specifies the fax number of the contact person at the customer. "];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Contact Fax No." }

    { 1101100004;2;Field  ;
                ToolTipML=[DAN=Angiver mailadressen pÜ kontaktpersonen hos debitoren.;
                           ENU=Specifies the email address of the contact person at the customer.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Contact E-Mail" }

    { 1101100006;2;Field  ;
                ToolTipML=[DAN=Angiver rollen for kontaktpersonen hos debitoren.;
                           ENU=Specifies the role of the contact person at the customer.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Contact Role" }

    { 45  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Document Date" }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvornÜr den relaterede salgsfaktura skal betales.;
                           ENU=Specifies when the related sales invoice must be paid.];
                ApplicationArea=#Advanced;
                SourceExpr="Due Date" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor ordren blev oprettet.;
                           ENU=Specifies the date when the order was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Order Date" }

    { 507 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer, som bliver brugt i debitors eller kreditors nummereringssystem.;
                           ENU=Specifies a document number that refers to the customer's or vendor's numbering system.];
                ApplicationArea=#Advanced;
                SourceExpr="External Document No." }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ den sëlger, der er tildelt til debitoren.;
                           ENU=Specifies the name of the salesperson who is assigned to the customer.];
                ApplicationArea=#Advanced;
                SourceExpr="Salesperson Code";
                OnValidate=BEGIN
                             SalespersonCodeOnAfterValidate;
                           END;
                            }

    { 105 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den kampagne, som bilaget er tilknyttet.;
                           ENU=Specifies the number of the campaign that the document is linked to.];
                ApplicationArea=#Advanced;
                SourceExpr="Campaign No." }

    { 117 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode for ansvarscenteret (f.eks. et distributionscenter), som er tildelt den involverede bruger, virksomhed, debitor eller kreditor.;
                           ENU=Specifies the code of the responsibility center, such as a distribution hub, that is associated with the involved user, company, customer, or vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Responsibility Center" }

    { 141 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der er ansvarlig for bilaget.;
                           ENU=Specifies the ID of the user who is responsible for the document.];
                ApplicationArea=#Advanced;
                SourceExpr="Assigned User ID" }

    { 119 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om bilaget er Übent, venter pÜ godkendelse, er faktureret til forudbetaling eller er frigivet til nëste fase i behandlingen.;
                           ENU=Specifies whether the document is open, waiting to be approved, has been invoiced for prepayment, or has been released to the next stage of processing.];
                ApplicationArea=#Advanced;
                SourceExpr=Status }

    { 58  ;1   ;Part      ;
                Name=SalesLines;
                ApplicationArea=#Advanced;
                SubPageLink=Document No.=FIELD(No.);
                PagePartID=Page508;
                Enabled="Sell-to Customer No." <> '';
                Editable="Sell-to Customer No." <> '';
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
                ApplicationArea=#Advanced;
                SourceExpr="Shipment Date" }

    { 71  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om felterne Enhedspris og Linjebelõb pÜ bilagslinjer skal vises med eller uden moms.;
                           ENU=Specifies if the Unit Price and Line Amount fields on document lines should be shown with or without VAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Prices Including VAT";
                OnValidate=BEGIN
                             PricesIncludingVATOnAfterValid;
                           END;
                            }

    { 135 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede debitors eller kreditors momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogfõringsopsëtning.;
                           ENU=Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Advanced;
                SourceExpr="VAT Bus. Posting Group" }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en formel, der beregner betalingens forfaldsdato, kontantrabatdato og kontantrabatbelõb.;
                           ENU=Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.];
                ApplicationArea=#Advanced;
                SourceExpr="Payment Terms Code" }

    { 74  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan betalingen skal foretages, f.eks. via bankoverfõrsel, kontant eller med check.;
                           ENU=Specifies how to make payment, such as with bank transfer, cash,  or check.];
                ApplicationArea=#Advanced;
                SourceExpr="Payment Method Code" }

    { 1060000;2;Field     ;
                ToolTipML=[DAN=Angiver betalingsmetoden Offentlig Information Online UBL (OIOUBL) for bilaget.;
                           ENU=Specifies the Offentlig Information Online UBL (OIOUBL) payment method for the document.];
                ApplicationArea=#Advanced;
                SourceExpr="Payment Channel" }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den transaktionstype, som bilaget reprësenterer med henblik pÜ rapportering til INTRASTAT.;
                           ENU=Specifies the type of transaction that the document represents, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Transaction Type" }

    { 84  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                OnValidate=BEGIN
                             ShortcutDimension1CodeOnAfterV;
                           END;
                            }

    { 92  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code";
                OnValidate=BEGIN
                             ShortcutDimension2CodeOnAfterV;
                           END;
                            }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor belõbet i posten skal vëre betalt, for at der kan opnÜs kontantrabat.;
                           ENU=Specifies the date on which the amount in the entry must be paid for a payment discount to be granted.];
                ApplicationArea=#Advanced;
                SourceExpr="Pmt. Discount Date" }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den rabatprocent, der tildeles, hvis debitoren betaler pÜ eller fõr den dato, der er angivet i feltet Kont.rabatdato. Rabatprocenten er angivet i feltet Betalingsbetingelseskode.;
                           ENU=Specifies the payment discount percentage that is granted if the customer pays on or before the date entered in the Pmt. Discount Date field. The discount percentage is specified in the Payment Terms Code field.];
                ApplicationArea=#Advanced;
                SourceExpr="Payment Discount %" }

    { 94  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver placeringen, hvorfra lagervarer til debitoren pÜ salgsbilaget skal sendes som standard.;
                           ENU=Specifies the location from where inventory items to the customer on the sales document are to be shipped by default.];
                ApplicationArea=#Location;
                SourceExpr="Location Code" }

    { 27  ;1   ;Group     ;
                CaptionML=[DAN=Forsendelse og fakturering;
                           ENU=Shipping and Billing];
                Enabled="Sell-to Customer No." <> '';
                GroupType=Group }

    { 25  ;2   ;Group     ;
                GroupType=Group }

    { 21  ;3   ;Group     ;
                GroupType=Group }

    { 16  ;4   ;Field     ;
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

    { 4   ;4   ;Group     ;
                Visible=NOT (ShipToOptions = ShipToOptions::"Default (Sell-to Address)");
                GroupType=Group }

    { 36  ;5   ;Field     ;
                CaptionML=[DAN=Kode;
                           ENU=Code];
                ToolTipML=[DAN=Angiver koden for en anden leveringsadresse end debitorens egen adresse, som angives som standard.;
                           ENU=Specifies the code for another shipment address than the customer's own address, which is entered by default.];
                ApplicationArea=#Advanced;
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
                ToolTipML=[DAN=Angiver navnet, som produkter i salgsbilaget skal leveres til.;
                           ENU=Specifies the name that products on the sales document will be shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Name";
                Editable=ShipToOptions = ShipToOptions::"Custom Address" }

    { 40  ;5   ;Field     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                ToolTipML=[DAN=Angiver den adresse, som produkter i salgsbilaget skal leveres til. Som standard udfyldes feltet med vërdien i feltet Adresse pÜ debitorkortet eller med vërdien i feltet Adresse i vinduet Leveringsadresse.;
                           ENU=Specifies the address that products on the sales document will be shipped to. By default, the field is filled with the value in the Address field on the customer card or with the value in the Address field in the Ship-to Address window.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Address";
                Editable=ShipToOptions = ShipToOptions::"Custom Address" }

    { 42  ;5   ;Field     ;
                CaptionML=[DAN=Adresse 2;
                           ENU=Address 2];
                ToolTipML=[DAN=Angiver en supplerende del af leveringsadressen.;
                           ENU=Specifies an additional part of the shipping address.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Address 2";
                Editable=ShipToOptions = ShipToOptions::"Custom Address" }

    { 97  ;5   ;Field     ;
                CaptionML=[DAN=Postnr.;
                           ENU=Post Code];
                ToolTipML=[DAN=Angiver postnummeret i leveringsadressen.;
                           ENU=Specifies the postal code of the shipping address.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Post Code";
                Editable=ShipToOptions = ShipToOptions::"Custom Address" }

    { 44  ;5   ;Field     ;
                CaptionML=[DAN=By;
                           ENU=City];
                ToolTipML=[DAN=Angiver byen i leveringsadressen.;
                           ENU=Specifies the city of the shipping address.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to City";
                Editable=ShipToOptions = ShipToOptions::"Custom Address" }

    { 29  ;5   ;Field     ;
                CaptionML=[DAN=Land/omrÜde;
                           ENU=Country/Region];
                ToolTipML=[DAN=Angiver land/omrÜde for leveringsadressen.;
                           ENU=Specifies the country/region of the shipping address.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Country/Region Code";
                Importance=Additional;
                Editable=ShipToOptions = ShipToOptions::"Custom Address" }

    { 46  ;4   ;Field     ;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                ToolTipML=[DAN=Angiver navnet pÜ kontaktpersonen pÜ den adresse, som produkter i salgsbilaget skal leveres til.;
                           ENU=Specifies the name of the contact person at the address that products on the sales document will be shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Contact" }

    { 39  ;3   ;Group     ;
                CaptionML=[DAN=Leveringsform;
                           ENU=Shipment Method];
                GroupType=Group }

    { 37  ;4   ;Field     ;
                CaptionML=[DAN=Kode;
                           ENU=Code];
                ToolTipML=[DAN=Angiver, hvordan varer i salgsbilaget sendes til debitoren.;
                           ENU=Specifies how items on the sales document are shipped to the customer.];
                ApplicationArea=#Advanced;
                SourceExpr="Shipment Method Code";
                Importance=Additional }

    { 35  ;4   ;Field     ;
                CaptionML=[DAN=Speditõr;
                           ENU=Agent];
                ToolTipML=[DAN=Angiver, hvilken speditõr der bruges til at transportere varerne pÜ salgsbilaget til debitoren.;
                           ENU=Specifies which shipping agent is used to transport the items on the sales document to the customer.];
                ApplicationArea=#Advanced;
                SourceExpr="Shipping Agent Code";
                Importance=Additional }

    { 33  ;4   ;Field     ;
                CaptionML=[DAN=Speditõrservice;
                           ENU=Agent service];
                ToolTipML=[DAN=Angiver, hvilken speditõrservice der bruges til at transportere varerne pÜ salgsbilaget til debitoren.;
                           ENU=Specifies which shipping agent service is used to transport the items on the sales document to the customer.];
                ApplicationArea=#Advanced;
                SourceExpr="Shipping Agent Service Code";
                Importance=Additional }

    { 31  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver speditõrens pakkenummer.;
                           ENU=Specifies the shipping agent's package number.];
                ApplicationArea=#Advanced;
                SourceExpr="Package Tracking No.";
                Importance=Additional }

    { 41  ;2   ;Group     ;
                GroupType=Group }

    { 23  ;3   ;Field     ;
                Name=BilltoOptions;
                CaptionML=[DAN=Faktureres til;
                           ENU=Bill-to];
                ToolTipML=[DAN=Angiver den kunde, som salgsfakturaen skal sendes til. Standard (Kunde): Den samme som kunden pÜ salgsfakturaen. En anden kunde: Enhver kunde, som du angiver i nedenstÜende felter.;
                           ENU=Specifies the customer that the sales invoice will be sent to. Default (Customer): The same as the customer on the sales invoice. Another Customer: Any customer that you specify in the fields below.];
                OptionCaptionML=[DAN=Standard (debitor),en anden debitor;
                                 ENU=Default (Customer),Another Customer];
                ApplicationArea=#Advanced;
                SourceExpr=BillToOptions;
                OnValidate=BEGIN
                             IF BillToOptions = BillToOptions::"Default (Customer)" THEN BEGIN
                               VALIDATE("Bill-to Customer No.","Sell-to Customer No.");
                               RecallModifyAddressNotification(GetModifyBillToCustomerAddressNotificationId);
                             END;

                             CopySellToAddressToBillToAddress;
                           END;
                            }

    { 43  ;3   ;Group     ;
                Visible=BillToOptions = BillToOptions::"Another Customer";
                GroupType=Group }

    { 18  ;4   ;Field     ;
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver den debitor, du vil sende fakturaen til, nÜr det er til en anden debitor end den, du sëlger til.;
                           ENU=Specifies the customer to whom you will send the invoice, when different from the customer that you are selling to.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to Name";
                Importance=Promoted;
                OnValidate=VAR
                             ApplicationAreaSetup@1000 : Record 9178;
                           BEGIN
                             IF GETFILTER("Bill-to Customer No.") = xRec."Bill-to Customer No." THEN
                               IF "Bill-to Customer No." <> xRec."Bill-to Customer No." THEN
                                 SETRANGE("Bill-to Customer No.");

                             IF ApplicationAreaSetup.IsFoundationEnabled THEN
                               SalesCalcDiscByType.ApplyDefaultInvoiceDiscount(0,Rec);
                           END;
                            }

    { 20  ;4   ;Field     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                ToolTipML=[DAN=Angiver adressen pÜ den debitor, som du vil sende fakturaen til.;
                           ENU=Specifies the address of the customer that you will send the invoice to.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to Address";
                Importance=Additional;
                Enabled="Bill-to Customer No." <> "Sell-to Customer No.";
                Editable="Bill-to Customer No." <> "Sell-to Customer No." }

    { 22  ;4   ;Field     ;
                CaptionML=[DAN=Adresse 2;
                           ENU=Address 2];
                ToolTipML=[DAN=Angiver en supplerende del af faktureringsadressen.;
                           ENU=Specifies an additional part of the billing address.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to Address 2";
                Importance=Additional;
                Enabled="Bill-to Customer No." <> "Sell-to Customer No.";
                Editable="Bill-to Customer No." <> "Sell-to Customer No." }

    { 89  ;4   ;Field     ;
                CaptionML=[DAN=Postnr.;
                           ENU=Post Code];
                ToolTipML=[DAN=Angiver postnummeret i faktureringsadressen.;
                           ENU=Specifies the postal code of the billing address.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to Post Code";
                Importance=Additional;
                Enabled="Bill-to Customer No." <> "Sell-to Customer No.";
                Editable="Bill-to Customer No." <> "Sell-to Customer No." }

    { 24  ;4   ;Field     ;
                CaptionML=[DAN=By;
                           ENU=City];
                ToolTipML=[DAN=Angiver byen i faktureringsadressen.;
                           ENU=Specifies the city of the billing address.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to City";
                Importance=Additional;
                Enabled="Bill-to Customer No." <> "Sell-to Customer No.";
                Editable="Bill-to Customer No." <> "Sell-to Customer No." }

    { 127 ;4   ;Field     ;
                CaptionML=[DAN=Kontaktnr.;
                           ENU=Contact No.];
                ToolTipML=[DAN=Angiver nummeret pÜ kontaktpersonen pÜ faktureringsadressen.;
                           ENU=Specifies the number of the contact person at the billing address.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to Contact No.";
                Importance=Additional;
                Enabled="Bill-to Customer No." <> "Sell-to Customer No.";
                Editable="Bill-to Customer No." <> "Sell-to Customer No." }

    { 26  ;4   ;Field     ;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                ToolTipML=[DAN=Angiver navnet pÜ kontaktpersonen pÜ faktureringsadressen;
                           ENU=Specifies the name of the contact person at the billing address];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to Contact";
                Enabled="Bill-to Customer No." <> "Sell-to Customer No.";
                Editable="Bill-to Customer No." <> "Sell-to Customer No." }

    { 1101100000;2;Field  ;
                ToolTipML=[DAN=Angiver EAN-lokationsnummeret for debitoren.;
                           ENU=Specifies the EAN location number for the customer.];
                ApplicationArea=#Advanced;
                SourceExpr="EAN No." }

    { 1101100002;2;Field  ;
                ToolTipML=[DAN=Angiver kontokoden for debitoren.;
                           ENU=Specifies the account code of the customer.];
                ApplicationArea=#Advanced;
                SourceExpr="Account Code";
                OnValidate=BEGIN
                             AccountCodeOnAfterValidate;
                           END;
                            }

    { 1907468901;1;Group  ;
                CaptionML=[DAN=Udenrigshandel;
                           ENU=Foreign Trade] }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om transaktionen er relateret til handel med tredjepart i EU.;
                           ENU=Specifies if the transaction is related to trade with a third party within the EU.];
                ApplicationArea=#Advanced;
                SourceExpr="EU 3-Party Trade" }

    { 103 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en specifikation af bilagets transaktion med henblik pÜ rapportering til INTRASTAT.;
                           ENU=Specifies a specification of the document's transaction, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Transaction Specification" }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver transportmÜden ved rapportering til INTRASTAT.;
                           ENU=Specifies the transport method, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Transport Method" }

    { 99  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det udfõrselssted, hvor varerne blev udfõrt af landet/omrÜdet med henblik pÜ rapportering til Intrastat.;
                           ENU=Specifies the point of exit through which you ship the items out of your country/region, for reporting to Intrastat.];
                ApplicationArea=#Advanced;
                SourceExpr="Exit Point" }

    { 101 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitors eller kreditors omrÜde med henblik pÜ rapportering til INTRASTAT.;
                           ENU=Specifies the area of the customer or vendor, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr=Area }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 13  ;1   ;Part      ;
                ApplicationArea=#Advanced;
                SubPageLink=Table ID=CONST(36),
                            Document Type=FIELD(Document Type),
                            Document No.=FIELD(No.);
                PagePartID=Page9103;
                Visible=OpenApprovalEntriesExistForCurrUser;
                PartType=Page }

    { 1902018507;1;Part   ;
                ApplicationArea=#Advanced;
                SubPageLink=No.=FIELD(Bill-to Customer No.);
                PagePartID=Page9082;
                PartType=Page }

    { 1900316107;1;Part   ;
                ApplicationArea=#Advanced;
                SubPageLink=No.=FIELD(Sell-to Customer No.);
                PagePartID=Page9084;
                PartType=Page }

    { 1906127307;1;Part   ;
                ApplicationArea=#Advanced;
                SubPageLink=Document Type=FIELD(Document Type),
                            Document No.=FIELD(Document No.),
                            Line No.=FIELD(Line No.);
                PagePartID=Page9087;
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

    { 17  ;1   ;Part      ;
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
      CopySalesDoc@1006 : Report 292;
      DocPrint@1007 : Codeunit 229;
      UserMgt@1009 : Codeunit 5700;
      SalesCalcDiscByType@1001 : Codeunit 56;
      CustomerMgt@1013 : Codeunit 1302;
      ChangeExchangeRate@1005 : Page 511;
      DocNoVisible@1000 : Boolean;
      OpenApprovalEntriesExistForCurrUser@1010 : Boolean;
      OpenApprovalEntriesExist@1008 : Boolean;
      ShowWorkflowStatus@1002 : Boolean;
      CanCancelApprovalForRecord@1003 : Boolean;
      ShipToOptions@1011 : 'Default (Sell-to Address),Alternate Shipping Address,Custom Address';
      BillToOptions@1004 : 'Default (Customer),Another Customer';
      EmptyShipToCodeErr@1012 : TextConst 'DAN=Kodefeltet mÜ kun vëre tomt, hvis du vëlger Brugerdefineret adresse i feltet Leveres til.;ENU=The Code field can only be empty if you select Custom Address in the Ship-to field.';

    LOCAL PROCEDURE ApproveCalcInvDisc@1();
    BEGIN
      CurrPage.SalesLines.PAGE.ApproveCalcInvDisc;
    END;

    LOCAL PROCEDURE SalespersonCodeOnAfterValidate@19011896();
    BEGIN
      CurrPage.SalesLines.PAGE.UpdateForm(TRUE);
    END;

    LOCAL PROCEDURE ShortcutDimension1CodeOnAfterV@19029405();
    BEGIN
      CurrPage.SalesLines.PAGE.UpdateForm(TRUE);
    END;

    LOCAL PROCEDURE ShortcutDimension2CodeOnAfterV@19008725();
    BEGIN
      CurrPage.SalesLines.PAGE.UpdateForm(TRUE);
    END;

    LOCAL PROCEDURE PricesIncludingVATOnAfterValid@19009096();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE AccountCodeOnAfterValidate@19007267();
    BEGIN
      CurrPage.SalesLines.PAGE.UpdateForm(TRUE)
    END;

    LOCAL PROCEDURE SetDocNoVisible@2();
    VAR
      DocumentNoVisibility@1001 : Codeunit 1400;
      DocType@1000 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Reminder,FinChMemo';
    BEGIN
      DocNoVisible := DocumentNoVisibility.SalesDocumentNoIsVisible(DocType::"Blanket Order","No.");
    END;

    LOCAL PROCEDURE SetControlAppearance@5();
    VAR
      ApprovalsMgmt@1002 : Codeunit 1535;
    BEGIN
      OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RECORDID);
      OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);
      CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RECORDID);
    END;

    LOCAL PROCEDURE UpdateShipToBillToGroupVisibility@9();
    BEGIN
      CustomerMgt.CalculateShipToBillToOptions(ShipToOptions,BillToOptions,Rec);
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnBeforeStatisticsAction@3(VAR SalesHeader@1000 : Record 36;VAR Handled@1001 : Boolean);
    BEGIN
    END;

    BEGIN
    END.
  }
}

