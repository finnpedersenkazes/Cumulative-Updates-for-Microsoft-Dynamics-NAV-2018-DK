OBJECT Page 9300 Sales Quotes
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Salgstilbud;
               ENU=Sales Quotes];
    SourceTable=Table36;
    SourceTableView=WHERE(Document Type=CONST(Quote));
    DataCaptionFields=Sell-to Customer No.;
    PageType=List;
    CardPageID=Sales Quote;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Tilbud,Anmod om godkendelse;
                                ENU=New,Process,Report,Quote,Request Approval];
    OnOpenPage=VAR
                 OfficeMgt@1000 : Codeunit 1630;
               BEGIN
                 SetSecurityFilterOnRespCenter;
                 IsOfficeAddin := OfficeMgt.IsAvailable;

                 CopySellToCustomerFilter;
               END;

    OnAfterGetCurrRecord=BEGIN
                           SetControlAppearance;
                           CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;  ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 20      ;1   ;ActionGroup;
                      CaptionML=[DAN=T&ilbud;
                                 ENU=&Quote];
                      Image=Quote }
      { 1102601033;2 ;Action    ;
                      Name=Approvals;
                      AccessByPermission=TableData 454=R;
                      CaptionML=[DAN=Godkendelser;
                                 ENU=Approvals];
                      ToolTipML=[DAN=FÜ vist en liste over records, der afventer godkendelse. Du kan f.eks. se, hvem der har anmodet om godkendelse af recorden, hvornÜr den blev sendt og hvornÜr den skal godkendes.;
                                 ENU=View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Enabled=QuoteActionsEnabled;
                      PromotedIsBig=Yes;
                      Image=Approvals;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 WorkflowsEntriesBuffer@1001 : Record 832;
                               BEGIN
                                 WorkflowsEntriesBuffer.RunWorkflowEntriesPage(RECORDID,DATABASE::"Sales Header","Document Type","No.");
                               END;
                                }
      { 1102601032;2 ;Action    ;
                      Name=Dimensions;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omrÜde, projekt eller afdeling, som du kan tildele til salgs- og kõbsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Enabled=QuoteActionsEnabled;
                      PromotedIsBig=Yes;
                      Image=Dimensions;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 ShowDocDim;
                               END;
                                }
      { 16      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Vis;
                                 ENU=&View] }
      { 1102601029;2 ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Debitor;
                                 ENU=Customer];
                      ToolTipML=[DAN=FÜ vist eller rediger detaljerede oplysninger om debitoren.;
                                 ENU=View or edit detailed information about the customer.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 21;
                      RunPageLink=No.=FIELD(Sell-to Customer No.);
                      Promoted=Yes;
                      Enabled=CustomerSelected;
                      PromotedIsBig=Yes;
                      Image=Customer;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes }
      { 1102601030;2 ;Action    ;
                      CaptionML=[DAN=K&ontakt;
                                 ENU=C&ontact];
                      ToolTipML=[DAN=Se eller rediger detaljerede oplysninger om debitoren i salgsdokumentet.;
                                 ENU=View or edit detailed information about the contact person at the customer.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 5050;
                      RunPageLink=No.=FIELD(Sell-to Contact No.);
                      Promoted=Yes;
                      Enabled=ContactSelected;
                      PromotedIsBig=Yes;
                      Image=Card;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1102601026;1 ;ActionGroup;
                      CaptionML=[DAN=&Tilbud;
                                 ENU=&Quote];
                      Image=Quote }
      { 1102601028;2 ;Action    ;
                      Name=Statistics;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=FÜ vist statistiske oplysninger som f.eks. vërdien for bogfõrte poster til recorden.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Enabled=QuoteActionsEnabled;
                      Image=Statistics;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 CalcInvDiscForHeader;
                                 COMMIT;
                                 PAGE.RUNMODAL(PAGE::"Sales Statistics",Rec);
                               END;
                                }
      { 1102601031;2 ;Action    ;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 67;
                      RunPageLink=Document Type=FIELD(Document Type),
                                  No.=FIELD(No.),
                                  Document Line No.=CONST(0);
                      Enabled=QuoteActionsEnabled;
                      Image=ViewComments }
      { 69      ;2   ;Action    ;
                      Name=Print;
                      Ellipsis=Yes;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=Forbered udskrivning af bilaget. Du fÜr vist et anmodningsvindue for bilaget, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.];
                      ApplicationArea=#Basic,#Suite;
                      Visible=NOT IsOfficeAddin;
                      Enabled=QuoteActionsEnabled;
                      Image=Print;
                      OnAction=BEGIN
                                 CheckSalesCheckAllLinesHaveQuantityAssigned;
                                 DocPrint.PrintSalesHeader(Rec);
                               END;
                                }
      { 7       ;2   ;Action    ;
                      Name=Email;
                      CaptionML=[DAN=Send via mail;
                                 ENU=Send by Email];
                      ToolTipML=[DAN=Fërdiggõr og forbered dokumentet til afsendelse via mail. Vinduet Send mail Übnes med debitorens mailadresse angivet, sÜ du kan tilfõje eller redigere oplysninger.;
                                 ENU=Finalize and prepare to email the document. The Send Email window opens prefilled with the customer's email address so you can add or edit information.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=QuoteActionsEnabled;
                      PromotedIsBig=Yes;
                      Image=Email;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 CheckSalesCheckAllLinesHaveQuantityAssigned;
                                 DocPrint.EmailSalesHeader(Rec);
                               END;
                                }
      { 5       ;1   ;ActionGroup;
                      CaptionML=[DAN=Opret;
                                 ENU=Create] }
      { 68      ;2   ;Action    ;
                      Name=MakeOrder;
                      CaptionML=[DAN=Lav &ordre;
                                 ENU=Make &Order];
                      ToolTipML=[DAN=Omdan salgstilbuddet til en salgsordre. Salgsordren vil indeholde salgstilbudsnummeret.;
                                 ENU=Convert the sales quote to a sales order. The sales order will contain the sales quote number.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Enabled=QuoteActionsEnabled;
                      Image=MakeOrder;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 IF ApprovalsMgmt.PrePostApprovalCheckSales(Rec) THEN
                                   CODEUNIT.RUN(CODEUNIT::"Sales-Quote to Order (Yes/No)",Rec);
                               END;
                                }
      { 9       ;2   ;Action    ;
                      Name=MakeInvoice;
                      CaptionML=[DAN=Opret faktura;
                                 ENU=Make Invoice];
                      ToolTipML=[DAN=Omdan det valgte salgstilbud til en salgsfaktura.;
                                 ENU=Convert the selected sales quote to a sales invoice.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Enabled=QuoteActionsEnabled;
                      PromotedIsBig=Yes;
                      Image=MakeOrder;
                      PromotedCategory=Process;
                      Scope=Repeater;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 IF ApprovalsMgmt.PrePostApprovalCheckSales(Rec) THEN BEGIN
                                   CheckSalesCheckAllLinesHaveQuantityAssigned;
                                   CODEUNIT.RUN(CODEUNIT::"Sales-Quote to Invoice Yes/No",Rec);
                                 END;
                               END;
                                }
      { 1102601015;2 ;Action    ;
                      Name=CreateCustomer;
                      CaptionML=[DAN=&Opret debitor;
                                 ENU=C&reate Customer];
                      ToolTipML=[DAN=Opret et nyt debitorkort for kontaktpersonen.;
                                 ENU=Create a new customer card for the contact.];
                      ApplicationArea=#Advanced;
                      Enabled=ContactSelected AND NOT CustomerSelected;
                      Image=NewCustomer;
                      OnAction=BEGIN
                                 IF CheckCustomerCreated(FALSE) THEN
                                   CurrPage.UPDATE(TRUE);
                               END;
                                }
      { 1102601025;2 ;Action    ;
                      Name=CreateTask;
                      AccessByPermission=TableData 5050=R;
                      CaptionML=[DAN=Opret &opgave;
                                 ENU=Create &Task];
                      ToolTipML=[DAN=Opret en ny marketingopgave for kontaktpersonen.;
                                 ENU=Create a new marketing task for the contact.];
                      ApplicationArea=#Advanced;
                      Enabled=ContactSelected;
                      Image=NewToDo;
                      OnAction=BEGIN
                                 CreateTask;
                               END;
                                }
      { 3       ;1   ;ActionGroup;
                      CaptionML=[DAN=Frigiv;
                                 ENU=Release];
                      Image=ReleaseDoc }
      { 1102601020;2 ;Action    ;
                      Name=Release;
                      ShortCutKey=Ctrl+F9;
                      CaptionML=[DAN=&Frigiv;
                                 ENU=Re&lease];
                      ToolTipML=[DAN=Frigiv bilaget til nëste behandlingstrin. NÜr et bilag frigives, bliver det inkluderet i alle disponeringsberegninger fra den dato, varerne forventes modtaget. Du skal genÜbne bilaget, fõr du kan foretage ëndringer i det.;
                                 ENU=Release the document to the next stage of processing. When a document is released, it will be included in all availability calculations from the expected receipt date of the items. You must reopen the document before you can make changes to it.];
                      ApplicationArea=#Advanced;
                      Enabled=QuoteActionsEnabled;
                      Image=ReleaseDoc;
                      OnAction=VAR
                                 ReleaseSalesDoc@1000 : Codeunit 414;
                               BEGIN
                                 ReleaseSalesDoc.PerformManualRelease(Rec);
                               END;
                                }
      { 1102601021;2 ;Action    ;
                      Name=Reopen;
                      CaptionML=[DAN=&èbn igen;
                                 ENU=Re&open];
                      ToolTipML=[DAN=èbn bilaget igen for at ëndre det, efter at det er blevet godkendt. Godkendte bilag har status Frigivet og skal Übnes, fõr de kan ëndres.;
                                 ENU=Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed.];
                      ApplicationArea=#Advanced;
                      Enabled=QuoteActionsEnabled;
                      Image=ReOpen;
                      OnAction=VAR
                                 ReleaseSalesDoc@1001 : Codeunit 414;
                               BEGIN
                                 ReleaseSalesDoc.PerformManualReopen(Rec);
                               END;
                                }
      { 1102601000;1 ;ActionGroup;
                      CaptionML=[DAN=Anmod om godkendelse;
                                 ENU=Request Approval];
                      Image=Approval }
      { 1102601017;2 ;Action    ;
                      Name=SendApprovalRequest;
                      CaptionML=[DAN=Send go&dkendelsesanmodning;
                                 ENU=Send A&pproval Request];
                      ToolTipML=[DAN=Anmod om godkendelse af bilaget.;
                                 ENU=Request approval of the document.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Enabled=QuoteActionsEnabled AND NOT OpenApprovalEntriesExist AND CanRequestApprovalForFlow;
                      PromotedIsBig=Yes;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ApprovalsMgmt@1001 : Codeunit 1535;
                               BEGIN
                                 IF ApprovalsMgmt.CheckSalesApprovalPossible(Rec) THEN
                                   ApprovalsMgmt.OnSendSalesDocForApproval(Rec);
                               END;
                                }
      { 1102601018;2 ;Action    ;
                      Name=CancelApprovalRequest;
                      CaptionML=[DAN=Annuller godkendelsesan&modning;
                                 ENU=Cancel Approval Re&quest];
                      ToolTipML=[DAN=Annuller godkendelsesanmodningen.;
                                 ENU=Cancel the approval request.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Enabled=QuoteActionsEnabled AND (CanCancelApprovalForRecord OR CanCancelApprovalForFlow);
                      PromotedIsBig=Yes;
                      Image=CancelApprovalRequest;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ApprovalsMgmt@1001 : Codeunit 1535;
                                 WorkflowWebhookManagement@1000 : Codeunit 1543;
                               BEGIN
                                 ApprovalsMgmt.OnCancelSalesApprovalRequest(Rec);
                                 WorkflowWebhookManagement.FindAndCancel(RECORDID);
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
                ApplicationArea=#All;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ debitoren.;
                           ENU=Specifies the number of the customer.];
                ApplicationArea=#All;
                SourceExpr="Sell-to Customer No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ debitoren.;
                           ENU=Specifies the name of the customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Customer Name" }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer, som bliver brugt i debitors eller kreditors nummereringssystem.;
                           ENU=Specifies a document number that refers to the customer's or vendor's numbering system.];
                ApplicationArea=#Advanced;
                SourceExpr="External Document No." }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret i debitorens primëre adresse.;
                           ENU=Specifies the postal code of the customer's main address.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Post Code";
                Visible=FALSE }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver landet/omrÜdekoden for debitorens primëre adresse.;
                           ENU=Specifies the country/region code of the customer's main address.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Country/Region Code";
                Visible=FALSE }

    { 41  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ kontaktpersonen pÜ debitorens primëre adresse.;
                           ENU=Specifies the name of the contact person at the customer's main address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Contact" }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den debitor, som du sender eller har sendt fakturaen eller kreditnotaen til.;
                           ENU=Specifies the number of the customer that you send or sent the invoice or credit memo to.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to Customer No.";
                Visible=FALSE }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ den debitor, som du sender eller har sendt fakturaen eller kreditnotaen til.;
                           ENU=Specifies the name of the customer that you send or sent the invoice or credit memo to.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to Name";
                Visible=FALSE }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret i debitorens faktureringsadresse.;
                           ENU=Specifies the postal code of the customer's billing address.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to Post Code";
                Visible=FALSE }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver landet/omrÜdekoden for debitorens faktureringsadresse.;
                           ENU=Specifies the country/region code of the customer's billing address.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to Country/Region Code";
                Visible=FALSE }

    { 159 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ kontaktpersonen pÜ debitorens faktureringsadresse.;
                           ENU=Specifies the name of the contact person at the customer's billing address.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to Contact";
                Visible=FALSE }

    { 155 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for en alternativ leveringsadresse, hvis du vil sende til en anden adresse end den, der er indsat automatisk. Dette felt bruges ogsÜ i tilfëlde af direkte levering.;
                           ENU=Specifies a code for an alternate shipment address if you want to ship to another address than the one that has been entered automatically. This field is also used in case of drop shipment.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Code";
                Visible=FALSE }

    { 153 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ debitoren pÜ den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the customer at the address that the items are shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Name";
                Visible=FALSE }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret pÜ den adresse, som varerne leveres til.;
                           ENU=Specifies the postal code of the address that the items are shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Post Code";
                Visible=FALSE }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver lande-/omrÜdekoden pÜ den adresse, som varerne leveres til.;
                           ENU=Specifies the country/region code of the address that the items are shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Country/Region Code";
                Visible=FALSE }

    { 143 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ kontaktpersonen pÜ den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the contact person at the address that the items are shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Contact";
                Visible=FALSE }

    { 139 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor bogfõringen af salgsdokumentet skal registreres.;
                           ENU=Specifies the date when the posting of the sales document will be recorded.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Posting Date" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvornÜr salgsfakturaen skal betales.;
                           ENU=Specifies when the sales invoice must be paid.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Due Date" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Indeholder den dato, hvor debitoren har õnsket varerne leveret.;
                           ENU=Specifies the date that the customer has asked for the order to be delivered.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Requested Delivery Date" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver summen af belõb i feltet Linjebelõb pÜ salgsordrelinjerne. Den bruges til at beregne fakturarabatten for salgsordren.;
                           ENU=Specifies the sum of amounts in the Line Amount field on the sales order lines. It is used to calculate the invoice discount of the sales order.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Amount }

    { 121 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 119 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 123 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver placeringen, hvor lagervarer til debitoren pÜ salgsbilaget skal sendes som standard.;
                           ENU=Specifies the location from where inventory items to the customer on the sales document are to be shipped by default.];
                ApplicationArea=#Location;
                SourceExpr="Location Code" }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den speditõr, som transporterer varerne.;
                           ENU=Specifies the code for the shipping agent who is transporting the items.];
                ApplicationArea=#Suite;
                SourceExpr="Shipping Agent Code";
                Importance=Additional;
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for servicen, f.eks. levering samme dag, som tilbydes af speditõren.;
                           ENU=Specifies the code for the service, such as a one-day delivery, that is offered by the shipping agent.];
                ApplicationArea=#Suite;
                SourceExpr="Shipping Agent Service Code";
                Importance=Additional;
                Visible=FALSE }

    { 99  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ den sëlger, der er tildelt til debitoren.;
                           ENU=Specifies the name of the sales person who is assigned to the customer.];
                ApplicationArea=#Advanced;
                SourceExpr="Salesperson Code";
                Visible=FALSE }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der er ansvarlig for bilaget.;
                           ENU=Specifies the ID of the user who is responsible for the document.];
                ApplicationArea=#Advanced;
                SourceExpr="Assigned User ID" }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver valutaen for belõbene i salgsdokumentet.;
                           ENU=Specifies the currency of amounts on the sales document.];
                ApplicationArea=#Advanced;
                SourceExpr="Currency Code";
                Visible=FALSE }

    { 1102601001;2;Field  ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Document Date";
                Visible=FALSE }

    { 1102601003;2;Field  ;
                ToolTipML=[DAN=Angiver nummeret pÜ den kampagne, som dokumentet er tilknyttet.;
                           ENU=Specifies the number of the campaign that the document is linked to.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Campaign No.";
                Visible=FALSE }

    { 1102601005;2;Field  ;
                ToolTipML=[DAN=Angiver nummeret pÜ den salgsmulighed, som salgstilbuddet er tildelt.;
                           ENU=Specifies the number of the opportunity that the sales quote is assigned to.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Opportunity No.";
                Visible=FALSE }

    { 1102601007;2;Field  ;
                ToolTipML=[DAN=Angiver, om dokumentet er Übent, venter pÜ godkendelse, er faktureret til forudbetaling eller er frigivet til nëste fase i behandlingen.;
                           ENU=Specifies whether the document is open, waiting to be approved, has been invoiced for prepayment, or has been released to the next stage of processing.];
                ApplicationArea=#Advanced;
                SourceExpr=Status;
                Visible=FALSE }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1902018507;1;Part   ;
                ApplicationArea=#Advanced;
                SubPageLink=No.=FIELD(Bill-to Customer No.),
                            Date Filter=FIELD(Date Filter);
                PagePartID=Page9082;
                PartType=Page }

    { 1900316107;1;Part   ;
                ApplicationArea=#Advanced;
                SubPageLink=No.=FIELD(Bill-to Customer No.),
                            Date Filter=FIELD(Date Filter);
                PagePartID=Page9084;
                PartType=Page }

    { 8   ;1   ;Part      ;
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
      DocPrint@1102601000 : Codeunit 229;
      OpenApprovalEntriesExist@1002 : Boolean;
      IsOfficeAddin@1000 : Boolean;
      CanCancelApprovalForRecord@1001 : Boolean;
      CustomerSelected@1003 : Boolean;
      ContactSelected@1004 : Boolean;
      QuoteActionsEnabled@1005 : Boolean;
      CanRequestApprovalForFlow@1006 : Boolean;
      CanCancelApprovalForFlow@1007 : Boolean;

    LOCAL PROCEDURE SetControlAppearance@5();
    VAR
      ApprovalsMgmt@1000 : Codeunit 1535;
      WorkflowWebhookManagement@1001 : Codeunit 1543;
    BEGIN
      OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);

      CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RECORDID);
      CustomerSelected := "Sell-to Customer No." <> '';
      ContactSelected := "Sell-to Contact No." <> '';
      QuoteActionsEnabled := "No." <> '';

      WorkflowWebhookManagement.GetCanRequestAndCanCancel(RECORDID,CanRequestApprovalForFlow,CanCancelApprovalForFlow);
    END;

    LOCAL PROCEDURE CheckSalesCheckAllLinesHaveQuantityAssigned@6();
    VAR
      ApplicationAreaSetup@1000 : Record 9178;
      LinesInstructionMgt@1001 : Codeunit 1320;
    BEGIN
      IF ApplicationAreaSetup.IsFoundationEnabled THEN
        LinesInstructionMgt.SalesCheckAllLinesHaveQuantityAssigned(Rec);
    END;

    BEGIN
    END.
  }
}

