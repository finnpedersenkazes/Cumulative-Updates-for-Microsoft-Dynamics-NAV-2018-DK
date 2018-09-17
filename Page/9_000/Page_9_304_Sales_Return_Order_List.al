OBJECT Page 9304 Sales Return Order List
{
  OBJECT-PROPERTIES
  {
    Date=26-01-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20348;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Salgsreturvareordrer;
               ENU=Sales Return Orders];
    SourceTable=Table36;
    SourceTableView=WHERE(Document Type=CONST(Return Order));
    DataCaptionFields=Sell-to Customer No.;
    PageType=List;
    CardPageID=Sales Return Order;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport‚r,Anmod om godkendelse,Frigiv;
                                ENU=New,Process,Report,Request Approval,Release];
    OnOpenPage=VAR
                 SalesSetup@1000 : Record 311;
               BEGIN
                 SetSecurityFilterOnRespCenter;

                 JobQueueActive := SalesSetup.JobQueueActive;

                 CopySellToCustomerFilter;
               END;

    OnAfterGetCurrRecord=BEGIN
                           SetControlAppearance;
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102601026;1 ;ActionGroup;
                      CaptionML=[DAN=&Returvareordre;
                                 ENU=&Return Order];
                      Image=Return }
      { 1102601028;2 ;Action    ;
                      Name=Statistics;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=F† vist statistiske oplysninger som f.eks. v‘rdien for bogf›rte poster til recorden.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#SalesReturnOrder;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Statistics;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 OpenSalesOrderStatistics;
                               END;
                                }
      { 1102601033;2 ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      Promoted=No;
                      PromotedIsBig=No;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDocDim;
                               END;
                                }
      { 1102601034;2 ;Action    ;
                      Name=Approvals;
                      AccessByPermission=TableData 454=R;
                      CaptionML=[DAN=Godkendelser;
                                 ENU=Approvals];
                      ToolTipML=[DAN=F† vist en liste over records, der afventer godkendelse. Du kan f.eks. se, hvem der har anmodet om godkendelse af recorden, hvorn†r den blev sendt og hvorn†r den skal godkendes.;
                                 ENU=View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.];
                      ApplicationArea=#Suite;
                      Image=Approvals;
                      OnAction=VAR
                                 WorkflowsEntriesBuffer@1000 : Record 832;
                               BEGIN
                                 WorkflowsEntriesBuffer.RunWorkflowEntriesPage(RECORDID,DATABASE::"Sales Header","Document Type","No.");
                               END;
                                }
      { 1102601030;2 ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 67;
                      RunPageLink=Document Type=CONST(Return Order),
                                  No.=FIELD(No.),
                                  Document Line No.=CONST(0);
                      Promoted=No;
                      PromotedIsBig=No;
                      Image=ViewComments }
      { 9       ;1   ;ActionGroup;
                      CaptionML=[DAN=Dokumenter;
                                 ENU=Documents];
                      Image=Documents }
      { 1102601031;2 ;Action    ;
                      CaptionML=[DAN=Returvaremodtagelse;
                                 ENU=Return Receipts];
                      ToolTipML=[DAN=Vis en liste over bogf›rte returvaremodtagelser for ordren.;
                                 ENU=View a list of posted return receipts for the order.];
                      ApplicationArea=#SalesReturnOrder;
                      RunObject=Page 6662;
                      RunPageView=SORTING(Return Order No.);
                      RunPageLink=Return Order No.=FIELD(No.);
                      Image=ReturnReceipt }
      { 1102601032;2 ;Action    ;
                      CaptionML=[DAN=Kred&itnotaer;
                                 ENU=Cred&it Memos];
                      ToolTipML=[DAN=Vis en liste med igangv‘rende kreditnotaer for ordren.;
                                 ENU=View a list of ongoing credit memos for the order.];
                      ApplicationArea=#SalesReturnOrder;
                      RunObject=Page 144;
                      RunPageView=SORTING(Return Order No.);
                      RunPageLink=Return Order No.=FIELD(No.);
                      Image=CreditMemo }
      { 10      ;1   ;ActionGroup;
                      CaptionML=[DAN=Lagersted;
                                 ENU=Warehouse];
                      Image=Warehouse }
      { 1102601037;2 ;Action    ;
                      CaptionML=[DAN=L&‘g-p†-lager/pluklinjer (lag.);
                                 ENU=In&vt. Put-away/Pick Lines];
                      ToolTipML=[DAN=F† vist ind- eller udg†ende varer p† l‘g-p†-lager- eller lagerplukningsbilag for overflytningsordren.;
                                 ENU=View items that are inbound or outbound on inventory put-away or inventory pick documents for the transfer order.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 5774;
                      RunPageView=SORTING(Source Document,Source No.,Location Code);
                      RunPageLink=Source Document=CONST(Sales Return Order),
                                  Source No.=FIELD(No.);
                      Image=PickLines }
      { 1102601036;2 ;Action    ;
                      CaptionML=[DAN=Lagermodtagelseslinjer;
                                 ENU=Whse. Receipt Lines];
                      ToolTipML=[DAN=Vis igangv‘rende lagermodtagelser for bilaget, i avancerede lagerops‘tninger.;
                                 ENU=View ongoing warehouse receipts for the document, in advanced warehouse configurations.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7342;
                      RunPageView=SORTING(Source Type,Source Subtype,Source No.,Source Line No.);
                      RunPageLink=Source Type=CONST(37),
                                  Source Subtype=FIELD(Document Type),
                                  Source No.=FIELD(No.);
                      Image=ReceiptLines }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 48      ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=G›r dig klar til at udskrive bilaget. Der †bnes et rapportanmodningsvindue for bilaget, hvor du kan angive, hvad der skal medtages p† udskriften.;
                                 ENU=Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.];
                      ApplicationArea=#SalesReturnOrder;
                      Promoted=Yes;
                      Image=Print;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 DocPrint.PrintSalesHeader(Rec);
                               END;
                                }
      { 7       ;1   ;ActionGroup;
                      CaptionML=[DAN=Frigiv;
                                 ENU=Release];
                      Image=ReleaseDoc }
      { 1102601022;2 ;Action    ;
                      Name=Release;
                      ShortCutKey=Ctrl+F9;
                      CaptionML=[DAN=&Frigiv;
                                 ENU=Re&lease];
                      ToolTipML=[DAN=Frigiv bilaget til n‘ste behandlingstrin. N†r et bilag frigives, bliver det inkluderet i alle disponeringsberegninger fra den dato, varerne forventes modtaget. Du skal gen†bne bilaget, f›r du kan foretage ‘ndringer i det.;
                                 ENU=Release the document to the next stage of processing. When a document is released, it will be included in all availability calculations from the expected receipt date of the items. You must reopen the document before you can make changes to it.];
                      ApplicationArea=#SalesReturnOrder;
                      Promoted=Yes;
                      Image=ReleaseDoc;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ReleaseSalesDoc@1000 : Codeunit 414;
                               BEGIN
                                 ReleaseSalesDoc.PerformManualRelease(Rec);
                               END;
                                }
      { 1102601023;2 ;Action    ;
                      Name=Reopen;
                      CaptionML=[DAN=&bn igen;
                                 ENU=Re&open];
                      ToolTipML=[DAN=bn dokumentet igen for at ‘ndre det, efter at det er blevet godkendt. Godkendte dokumenter har status Frigivet og skal †bnes, f›r de kan ‘ndres;
                                 ENU=Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed];
                      ApplicationArea=#SalesReturnOrder;
                      Promoted=Yes;
                      Image=ReOpen;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ReleaseSalesDoc@1001 : Codeunit 414;
                               BEGIN
                                 ReleaseSalesDoc.PerformManualReopen(Rec);
                               END;
                                }
      { 1102601000;1 ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 1102601014;2 ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Hent bogf›rte bilagslinje&r, der skal tilbagef›res;
                                 ENU=Get Posted Doc&ument Lines to Reverse];
                      ToolTipML=[DAN=Kopi‚r en eller flere bogf›rte salgsbilagslinjer for at tilbagef›re den oprindelige ordre.;
                                 ENU=Copy one or more posted sales document lines in order to reverse the original order.];
                      ApplicationArea=#SalesReturnOrder;
                      Promoted=Yes;
                      Image=ReverseLines;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 GetPstdDocLinesToRevere;
                               END;
                                }
      { 1102601021;2 ;Separator  }
      { 1102601025;2 ;Action    ;
                      AccessByPermission=TableData 410=R;
                      CaptionML=[DAN=Send IC-returvareordrebekr‘ftelse;
                                 ENU=Send IC Return Order Cnfmn.];
                      ToolTipML=[DAN=Send bilaget til den koncerninterne udbakke eller direkte til den koncerninterne partner, hvis automatisk transaktionsafsendelse er aktiveret.;
                                 ENU=Send the document to the intercompany outbox or directly to the intercompany partner if automatic transaction sending is enabled.];
                      ApplicationArea=#Intercompany;
                      Image=IntercompanyOrder;
                      OnAction=VAR
                                 ICInboxOutboxMgt@1000 : Codeunit 427;
                                 ApprovalsMgmt@1003 : Codeunit 1535;
                               BEGIN
                                 IF ApprovalsMgmt.PrePostApprovalCheckSales(Rec) THEN
                                   ICInboxOutboxMgt.SendSalesDoc(Rec,FALSE);
                               END;
                                }
      { 16      ;1   ;ActionGroup;
                      CaptionML=[DAN=Anmod om godkendelse;
                                 ENU=Request Approval] }
      { 1102601019;2 ;Action    ;
                      Name=SendApprovalRequest;
                      CaptionML=[DAN=Send go&dkendelsesanmodning;
                                 ENU=Send A&pproval Request];
                      ToolTipML=[DAN=Anmod om godkendelse af bilaget.;
                                 ENU=Request approval of the document.];
                      ApplicationArea=#SalesReturnOrder;
                      Promoted=Yes;
                      Enabled=NOT OpenApprovalEntriesExist;
                      PromotedIsBig=Yes;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 IF ApprovalsMgmt.CheckSalesApprovalPossible(Rec) THEN
                                   ApprovalsMgmt.OnSendSalesDocForApproval(Rec);
                               END;
                                }
      { 1102601020;2 ;Action    ;
                      Name=CancelApprovalRequest;
                      CaptionML=[DAN=Annuller godkendelsesan&modning;
                                 ENU=Cancel Approval Re&quest];
                      ToolTipML=[DAN=Annuller godkendelsesanmodningen.;
                                 ENU=Cancel the approval request.];
                      ApplicationArea=#SalesReturnOrder;
                      Promoted=Yes;
                      Enabled=CanCancelApprovalForRecord;
                      PromotedIsBig=Yes;
                      Image=CancelApprovalRequest;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.OnCancelSalesApprovalRequest(Rec);
                               END;
                                }
      { 8       ;1   ;ActionGroup;
                      CaptionML=[DAN=Lagersted;
                                 ENU=Warehouse];
                      Image=Warehouse }
      { 1102601017;2 ;Action    ;
                      AccessByPermission=TableData 7340=R;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Opret l&‘g-p†-lager (lager)/pluk (lager);
                                 ENU=Create Inventor&y Put-away/Pick];
                      ToolTipML=[DAN=Opret en l‘g-p†-lager-aktivitet eller et lagerpluk til h†ndtering af varer p† bilaget i overensstemmelse med en grundl‘ggende lagerops‘tning, der ikke kr‘ver lagermodtagelse eller leverancedokumenter.;
                                 ENU=Create an inventory put-away or inventory pick to handle items on the document according to a basic warehouse configuration that does not require warehouse receipt or shipment documents.];
                      ApplicationArea=#Warehouse;
                      Image=CreatePutawayPick;
                      OnAction=BEGIN
                                 CreateInvtPutAwayPick;
                               END;
                                }
      { 1102601016;2 ;Action    ;
                      AccessByPermission=TableData 7316=R;
                      CaptionML=[DAN=Opr&et lagermodtagelse;
                                 ENU=Create &Whse. Receipt];
                      ToolTipML=[DAN=Opret en lagermodtagelse for at starte en l‘g-p†-lager-proces i henhold til en avanceret lagerops‘tning.;
                                 ENU=Create a warehouse receipt to start a receive and put-away process according to an advanced warehouse configuration.];
                      ApplicationArea=#Warehouse;
                      Image=NewReceipt;
                      OnAction=VAR
                                 GetSourceDocInbound@1000 : Codeunit 5751;
                               BEGIN
                                 GetSourceDocInbound.CreateFromSalesReturnOrder(Rec);
                               END;
                                }
      { 49      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Bogf›ring;
                                 ENU=P&osting];
                      Image=Post }
      { 54      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kontroller;
                                 ENU=Test Report];
                      ToolTipML=[DAN=Vis en testrapport, s† du kan finde og rette eventuelle fejl, f›r du udf›rer den faktiske bogf›ring af kladden eller bilaget.;
                                 ENU=View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.];
                      ApplicationArea=#SalesReturnOrder;
                      Image=TestReport;
                      OnAction=BEGIN
                                 ReportPrint.PrintSalesHeader(Rec);
                               END;
                                }
      { 52      ;2   ;Action    ;
                      Name=Post;
                      ShortCutKey=F9;
                      Ellipsis=Yes;
                      CaptionML=[DAN=B&ogf›r;
                                 ENU=P&ost];
                      ToolTipML=[DAN=F‘rdigg›r bilaget eller kladden ved at bogf›re bel›b og antal p† de relaterede konti i regnskaberne.;
                                 ENU=Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostOrder;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 SalesHeader@1003 : Record 36;
                                 SalesBatchPostMgt@1002 : Codeunit 1371;
                                 BatchProcessingMgt@1001 : Codeunit 1380;
                                 BatchPostParameterTypes@1000 : Codeunit 1370;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(SalesHeader);
                                 IF SalesHeader.COUNT > 1 THEN BEGIN
                                   BatchProcessingMgt.AddParameter(BatchPostParameterTypes.Invoice,TRUE);
                                   BatchProcessingMgt.AddParameter(BatchPostParameterTypes.Receive,TRUE);

                                   SalesBatchPostMgt.SetBatchProcessor(BatchProcessingMgt);
                                   SalesBatchPostMgt.RunWithUI(SalesHeader,COUNT,ReadyToPostQst);
                                 END ELSE
                                   SendToPosting(CODEUNIT::"Sales-Post (Yes/No)");
                               END;
                                }
      { 14      ;2   ;Action    ;
                      CaptionML=[DAN=Vis bogf›ring;
                                 ENU=Preview Posting];
                      ToolTipML=[DAN=Gennemse de forskellige typer poster, der oprettes, n†r du bogf›rer bilaget eller kladden.;
                                 ENU=Review the different types of entries that will be created when you post the document or journal.];
                      ApplicationArea=#SalesReturnOrder;
                      Image=ViewPostedOrder;
                      OnAction=VAR
                                 SalesPostYesNo@1001 : Codeunit 81;
                               BEGIN
                                 SalesPostYesNo.Preview(Rec);
                               END;
                                }
      { 51      ;2   ;Action    ;
                      ShortCutKey=Shift+F9;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Bogf›r og &udskriv;
                                 ENU=Post and &Print];
                      ToolTipML=[DAN=Bilaget eller kladden f‘rdigg›res og forberedes til udskrivning. V‘rdierne og antallene bogf›res p† de relaterede konti. Du f†r vist et rapportanmodningsvindue, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.];
                      ApplicationArea=#SalesReturnOrder;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostPrint;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 SendToPosting(CODEUNIT::"Sales-Post + Print");
                               END;
                                }
      { 12      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Bogf›r og mail;
                                 ENU=Post and Email];
                      ToolTipML=[DAN=Bogf›r salgsbilaget, og vedh‘ft det i en mail til debitoren.;
                                 ENU=Post the sales document and attach it to an email addressed to the customer.];
                      ApplicationArea=#SalesReturnOrder;
                      Promoted=Yes;
                      Image=PostMail;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 SalesPostPrint@1000 : Codeunit 82;
                               BEGIN
                                 SalesPostPrint.PostAndEmail(Rec);
                               END;
                                }
      { 50      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Masse&bogf›r;
                                 ENU=Post &Batch];
                      ToolTipML=[DAN=Bogf›r flere bilag p† ‚n gang. Der †bnes et anmodningsvindue, hvor du kan angive, hvilke bilag der skal bogf›res.;
                                 ENU=Post several documents at once. A report request window opens where you can specify which documents to post.];
                      ApplicationArea=#SalesReturnOrder;
                      Promoted=Yes;
                      Image=PostBatch;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 REPORT.RUNMODAL(REPORT::"Batch Post Sales Return Orders",TRUE,TRUE,Rec);
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 3       ;2   ;Action    ;
                      CaptionML=[DAN=Fjern fra opgavek›;
                                 ENU=Remove From Job Queue];
                      ToolTipML=[DAN=Fjern den planlagte behandling af denne record fra jobk›en.;
                                 ENU=Remove the scheduled processing of this record from the job queue.];
                      ApplicationArea=#SalesReturnOrder;
                      Visible=JobQueueActive;
                      Image=RemoveLine;
                      OnAction=BEGIN
                                 CancelBackgroundPosting;
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
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† debitoren.;
                           ENU=Specifies the number of the customer.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Sell-to Customer No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† debitoren.;
                           ENU=Specifies the name of the customer.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Sell-to Customer Name" }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer, som bliver brugt i debitors eller kreditors nummereringssystem.;
                           ENU=Specifies a document number that refers to the customer's or vendor's numbering system.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="External Document No." }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret i debitorens prim‘re adresse.;
                           ENU=Specifies the postal code of the customer's main address.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Sell-to Post Code";
                Visible=FALSE }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver landet/omr†dekoden for debitorens prim‘re adresse.;
                           ENU=Specifies the country/region code of the customer's main address.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Sell-to Country/Region Code";
                Visible=FALSE }

    { 41  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† kontaktpersonen p† debitorens prim‘re adresse.;
                           ENU=Specifies the name of the contact person at the customer's main address.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Sell-to Contact";
                Visible=FALSE }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den debitor, som du sender eller har sendt fakturaen eller kreditnotaen til.;
                           ENU=Specifies the number of the customer that you send or sent the invoice or credit memo to.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Bill-to Customer No.";
                Visible=FALSE }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den debitor, som du sender eller har sendt fakturaen eller kreditnotaen til.;
                           ENU=Specifies the name of the customer that you send or sent the invoice or credit memo to.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Bill-to Name";
                Visible=FALSE }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret i debitorens faktureringsadresse.;
                           ENU=Specifies the postal code of the customer's billing address.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Bill-to Post Code";
                Visible=FALSE }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver landet/omr†dekoden for debitorens faktureringsadresse.;
                           ENU=Specifies the country/region code of the customer's billing address.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Bill-to Country/Region Code";
                Visible=FALSE }

    { 159 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† kontaktpersonen p† debitorens faktureringsadresse.;
                           ENU=Specifies the name of the contact person at the customer's billing address.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Bill-to Contact";
                Visible=FALSE }

    { 155 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for en alternativ leveringsadresse, hvis du vil sende til en anden adresse end den, der er indsat automatisk. Dette felt bruges ogs† i tilf‘lde af direkte levering.;
                           ENU=Specifies a code for an alternate shipment address if you want to ship to another address than the one that has been entered automatically. This field is also used in case of drop shipment.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Ship-to Code";
                Visible=FALSE }

    { 153 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† debitoren p† den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the customer at the address that the items are shipped to.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Ship-to Name";
                Visible=FALSE }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret p† den adresse, som varerne leveres til.;
                           ENU=Specifies the postal code of the address that the items are shipped to.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Ship-to Post Code";
                Visible=FALSE }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver lande-/omr†dekoden p† den adresse, som varerne leveres til.;
                           ENU=Specifies the country/region code of the address that the items are shipped to.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Ship-to Country/Region Code";
                Visible=FALSE }

    { 143 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† kontaktpersonen p† den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the contact person at the address that the items are shipped to.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Ship-to Contact";
                Visible=FALSE }

    { 139 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postens bogf›ringsdato.;
                           ENU=Specifies the entry's posting date.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Posting Date";
                Visible=FALSE }

    { 121 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 119 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 123 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver placeringen, hvorfra lagervarer til debitoren p† salgsbilaget skal sendes som standard.;
                           ENU=Specifies the location from where inventory items to the customer on the sales document are to be shipped by default.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Location Code" }

    { 99  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken s‘lger der er tilknyttet leverancen.;
                           ENU=Specifies which salesperson is associated with the shipment.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Salesperson Code";
                Visible=FALSE }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der er ansvarlig for bilaget.;
                           ENU=Specifies the ID of the user who is responsible for the document.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Assigned User ID" }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den valutakode, der er brugt i posten.;
                           ENU=Specifies the currency that is used on the entry.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Currency Code";
                Visible=FALSE }

    { 1102601001;2;Field  ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Document Date";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver om bilaget er †bent, venter p† godkendelse, er faktureret til forudbetaling eller er frigivet til n‘ste fase i behandlingen.;
                           ENU=Specifies if the document is open, waiting to be approved, has been invoiced for prepayment, or has been released to the next stage of processing.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr=Status }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en formel, der beregner betalingens forfaldsdatoen, kontantrabatdato og kontantrabatbel›b.;
                           ENU=Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Payment Terms Code";
                Visible=FALSE }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn†r salgsreturvareordren skal betales.;
                           ENU=Specifies when the sales return order must be paid.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Due Date";
                Visible=FALSE }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den betalingsrabatprocent, der tildeles, hvis debitoren betaler p† eller f›r den dato, der er angivet i feltet Kont.rabatdato. Rabatprocenten er angivet i feltet Betalingsbetingelseskode.;
                           ENU=Specifies the payment discount percentage that is granted if the customer pays on or before the date entered in the Pmt. Discount Date field. The discount percentage is specified in the Payment Terms Code field.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Payment Discount %";
                Visible=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den spedit›r, som transporterer varerne.;
                           ENU=Specifies the code for the shipping agent who is transporting the items.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Shipping Agent Code";
                Visible=FALSE }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for servicen, f.eks. levering samme dag, som tilbydes af spedit›ren.;
                           ENU=Specifies the code for the service, such as a one-day delivery, that is offered by the shipping agent.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Shipping Agent Service Code";
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver spedit›rens pakkenummer.;
                           ENU=Specifies the shipping agent's package number.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Package Tracking No.";
                Visible=FALSE }

    { 1102601007;2;Field  ;
                ToolTipML=[DAN=Angiver, hvorn†r varerne p† bilaget er sendt eller leveret. En afsendelsesdato beregnes normalt ud fra en ›nsket leveringsdato plus leveringstiden.;
                           ENU=Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Shipment Date";
                Visible=FALSE }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om debitoren accepterer delvis levering af ordrer.;
                           ENU=Specifies if the customer accepts partial shipment of orders.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Shipping Advice";
                Visible=FALSE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om alle varer i ordren er leveret, eller - hvis der er tale om indg†ende varer - modtaget helt.;
                           ENU=Specifies if all the items on the order have been shipped or, in the case of inbound items, completely received.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Completely Shipped";
                Visible=FALSE }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for en opgavek›post eller opgave, der h†ndterer bogf›ring af salgsreturvareordrer.;
                           ENU=Specifies the status of a job queue entry or task that handles the posting of sales return orders.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Job Queue Status";
                Visible=JobQueueActive }

    { 1102601003;2;Field  ;
                ToolTipML=[DAN=Angiver nummeret p† den kampagne, som bilaget er knyttet til.;
                           ENU=Specifies the campaign number that the document is linked to.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Campaign No.";
                Visible=FALSE }

    { 1102601005;2;Field  ;
                ToolTipML=[DAN=Angiver den type bogf›rt bilag, som dette bilag eller denne kladdelinje udlignes med, n†r du bogf›rer, f.eks. til registrering af betaling.;
                           ENU=Specifies the type of the posted document that this document or journal line will be applied to when you post, for example to register payment.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Applies-to Doc. Type";
                Visible=FALSE }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver summen af bel›b i feltet Linjebel›b p† bilagslinjerne.;
                           ENU=Specifies the sum of amounts in the Line Amount field on the document lines.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr=Amount }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den samlede sum af bel›bene, herunder moms, p† alle linjerne i bilaget.;
                           ENU=Specifies the total of the amounts, including VAT, on all the lines in the document.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Amount Including VAT" }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1902018507;1;Part   ;
                ApplicationArea=#SalesReturnOrder;
                SubPageLink=No.=FIELD(Bill-to Customer No.),
                            Date Filter=FIELD(Date Filter);
                PagePartID=Page9082;
                PartType=Page }

    { 1900316107;1;Part   ;
                ApplicationArea=#SalesReturnOrder;
                SubPageLink=No.=FIELD(Bill-to Customer No.),
                            Date Filter=FIELD(Date Filter);
                PagePartID=Page9084;
                PartType=Page }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      ReportPrint@1102601001 : Codeunit 228;
      DocPrint@1102601000 : Codeunit 229;
      JobQueueActive@1000 : Boolean INDATASET;
      OpenApprovalEntriesExist@1004 : Boolean;
      CanCancelApprovalForRecord@1001 : Boolean;
      ReadyToPostQst@1002 : TextConst '@@@=%1 - selected count, %2 - total count;DAN=%1 ud af %2 valgte returvareordrer er klar til bogf›ring. \Vil du forts‘tte og bogf›re dem?;ENU=%1 out of %2 selected return orders are ready for post. \Do you want to continue and post them?';

    LOCAL PROCEDURE SetControlAppearance@5();
    VAR
      ApprovalsMgmt@1000 : Codeunit 1535;
    BEGIN
      OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);

      CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RECORDID);
    END;

    BEGIN
    END.
  }
}

