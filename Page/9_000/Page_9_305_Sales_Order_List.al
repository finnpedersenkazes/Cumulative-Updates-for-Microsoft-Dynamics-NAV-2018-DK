OBJECT Page 9305 Sales Order List
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Salgsordrer;
               ENU=Sales Orders];
    SourceTable=Table36;
    SourceTableView=WHERE(Document Type=CONST(Order));
    DataCaptionFields=Sell-to Customer No.;
    PageType=List;
    CardPageID=Sales Order;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport‚r,Anmod om godkendelse,Bestil;
                                ENU=New,Process,Report,Request Approval,Order];
    OnOpenPage=VAR
                 SalesSetup@1000 : Record 311;
                 CRMIntegrationManagement@1001 : Codeunit 5330;
                 OfficeMgt@1002 : Codeunit 1630;
               BEGIN
                 IF UserMgt.GetSalesFilter <> '' THEN BEGIN
                   FILTERGROUP(2);
                   SETRANGE("Responsibility Center",UserMgt.GetSalesFilter);
                   FILTERGROUP(0);
                 END;

                 SETRANGE("Date Filter",0D,WORKDATE - 1);

                 JobQueueActive := SalesSetup.JobQueueActive;
                 CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
                 IsOfficeAddin := OfficeMgt.IsAvailable;

                 CopySellToCustomerFilter;

                 // Contextual Power BI FactBox: filtering available reports, setting context, loading Power BI related user settings
                 CurrPage."Power BI Report FactBox".PAGE.SetNameFilter(CurrPage.CAPTION);
                 CurrPage."Power BI Report FactBox".PAGE.SetContext(CurrPage.OBJECTID(FALSE));
                 PowerBIVisible := SetPowerBIUserConfig.SetUserConfig(PowerBIUserConfiguration,CurrPage.OBJECTID(FALSE));
               END;

    OnFindRecord=BEGIN
                   EXIT(FIND(Which) AND ShowHeader);
                 END;

    OnNextRecord=VAR
                   NewStepCount@1000 : Integer;
                 BEGIN
                   REPEAT
                     NewStepCount := NEXT(Steps);
                   UNTIL (NewStepCount = 0) OR ShowHeader;

                   EXIT(NewStepCount);
                 END;

    OnAfterGetCurrRecord=BEGIN
                           SetControlVisibility;
                           CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);

                           // Contextual Power BI FactBox: send data to filter the report in the FactBox
                           CurrPage."Power BI Report FactBox".PAGE.SetCurrentListSelection("No.",FALSE);
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102601000;1 ;ActionGroup;
                      CaptionML=[DAN=&Ordre;
                                 ENU=O&rder];
                      Image=Order }
      { 1102601013;2 ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDocDim;
                               END;
                                }
      { 1102601006;2 ;Action    ;
                      Name=Statistics;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=F† vist statistiske oplysninger som f.eks. v‘rdien for bogf›rte poster til recorden.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 OpenSalesOrderStatistics;
                               END;
                                }
      { 1102601014;2 ;Action    ;
                      Name=Approvals;
                      CaptionML=[DAN=Godkendelser;
                                 ENU=Approvals];
                      ToolTipML=[DAN=F† vist en liste over records, der afventer godkendelse. Du kan f.eks. se, hvem der har anmodet om godkendelse af recorden, hvorn†r den blev sendt og hvorn†r den skal godkendes.;
                                 ENU=View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Image=Approvals;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 WorkflowsEntriesBuffer@1000 : Record 832;
                               BEGIN
                                 WorkflowsEntriesBuffer.RunWorkflowEntriesPage(RECORDID,DATABASE::"Sales Header","Document Type","No.");
                               END;
                                }
      { 1102601008;2 ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 67;
                      RunPageLink=Document Type=FIELD(Document Type),
                                  No.=FIELD(No.),
                                  Document Line No.=CONST(0);
                      Image=ViewComments }
      { 9       ;1   ;ActionGroup;
                      CaptionML=[DAN=Dokumenter;
                                 ENU=Documents];
                      Image=Documents }
      { 1102601009;2 ;Action    ;
                      CaptionML=[DAN=Le&verancer;
                                 ENU=S&hipments];
                      ToolTipML=[DAN=Vis relaterede bogf›rte salgsleverancer.;
                                 ENU=View related posted sales shipments.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 142;
                      RunPageView=SORTING(Order No.);
                      RunPageLink=Order No.=FIELD(No.);
                      Image=Shipment }
      { 1102601010;2 ;Action    ;
                      Name=PostedSalesInvoices;
                      CaptionML=[DAN=Fakturaer;
                                 ENU=Invoices];
                      ToolTipML=[DAN=Vis en liste med igangv‘rende salgsfakturaer for ordren.;
                                 ENU=View a list of ongoing sales invoices for the order.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 143;
                      RunPageView=SORTING(Order No.);
                      RunPageLink=Order No.=FIELD(No.);
                      Image=Invoice }
      { 1102601011;2 ;Action    ;
                      Name=PostedSalesPrepmtInvoices;
                      CaptionML=[DAN=For&udbetalingsfakturaer;
                                 ENU=Prepa&yment Invoices];
                      ToolTipML=[DAN="Vis relaterede bogf›rte salgsfakturaer, der vedr›rer en forudbetaling. ";
                                 ENU="View related posted sales invoices that involve a prepayment. "];
                      ApplicationArea=#Prepayments;
                      RunObject=Page 143;
                      RunPageView=SORTING(Prepayment Order No.);
                      RunPageLink=Prepayment Order No.=FIELD(No.);
                      Image=PrepaymentInvoice }
      { 1102601012;2 ;Action    ;
                      CaptionML=[DAN=Forudbetalingskredi&tnotaer;
                                 ENU=Prepayment Credi&t Memos];
                      ToolTipML=[DAN="Vis relaterede bogf›rte kreditnotaer, der vedr›rer en forudbetaling. ";
                                 ENU="View related posted sales credit memos that involve a prepayment. "];
                      ApplicationArea=#Prepayments;
                      RunObject=Page 144;
                      RunPageView=SORTING(Prepayment Order No.);
                      RunPageLink=Prepayment Order No.=FIELD(No.);
                      Image=PrepaymentCreditMemo }
      { 10      ;1   ;ActionGroup;
                      CaptionML=[DAN=Lagersted;
                                 ENU=Warehouse];
                      Image=Warehouse }
      { 1102601016;2 ;Action    ;
                      CaptionML=[DAN=Lagerleverancelinjer;
                                 ENU=Whse. Shipment Lines];
                      ToolTipML=[DAN=Vis igangv‘rende lagerleverancer for bilaget, i avancerede lagerops‘tninger.;
                                 ENU=View ongoing warehouse shipments for the document, in advanced warehouse configurations.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7341;
                      RunPageView=SORTING(Source Type,Source Subtype,Source No.,Source Line No.);
                      RunPageLink=Source Type=CONST(37),
                                  Source Subtype=FIELD(Document Type),
                                  Source No.=FIELD(No.);
                      Image=ShipmentLines }
      { 1102601017;2 ;Action    ;
                      CaptionML=[DAN=L&‘g-p†-lager/pluklinjer (lag.);
                                 ENU=In&vt. Put-away/Pick Lines];
                      ToolTipML=[DAN=F† vist ind- eller udg†ende varer p† l‘g-p†-lager- eller lagerplukningsbilag for overflytningsordren.;
                                 ENU=View items that are inbound or outbound on inventory put-away or inventory pick documents for the transfer order.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 5774;
                      RunPageView=SORTING(Source Document,Source No.,Location Code);
                      RunPageLink=Source Document=CONST(Sales Order),
                                  Source No.=FIELD(No.);
                      Image=PickLines }
      { 32      ;1   ;ActionGroup;
                      Name=ActionGroupCRM;
                      CaptionML=[DAN=Dynamics 365 for Sales;
                                 ENU=Dynamics 365 for Sales];
                      Visible=CRMIntegrationEnabled }
      { 31      ;2   ;Action    ;
                      Name=CRMGoToSalesOrderListInNAV;
                      CaptionML=[DAN=Salgsordreoversigt;
                                 ENU=Sales Order List];
                      ToolTipML=[DAN=bn salgsordreoversigten - siden Dynamics 365 for Sales i Dynamics NAV;
                                 ENU=Open the Sales Order List - Dynamics 365 for Sales page in Dynamics NAV];
                      ApplicationArea=#Basic,#Suite;
                      Visible=CRMIntegrationEnabled;
                      Enabled=CRMIntegrationEnabled;
                      Image=Order;
                      OnAction=VAR
                                 CRMSalesorder@1000 : Record 5353;
                               BEGIN
                                 PAGE.RUN(PAGE::"CRM Sales Order List",CRMSalesorder);
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 12      ;1   ;ActionGroup;
                      CaptionML=[DAN=Frigiv;
                                 ENU=Release];
                      Image=ReleaseDoc }
      { 1102601049;2 ;Action    ;
                      Name=Release;
                      ShortCutKey=Ctrl+F9;
                      CaptionML=[DAN=&Frigiv;
                                 ENU=Re&lease];
                      ToolTipML=[DAN=Frigiv bilaget til n‘ste behandlingstrin. N†r et bilag frigives, bliver det inkluderet i alle disponeringsberegninger fra den dato, varerne forventes modtaget. Du skal gen†bne bilaget, f›r du kan foretage ‘ndringer i det.;
                                 ENU=Release the document to the next stage of processing. When a document is released, it will be included in all availability calculations from the expected receipt date of the items. You must reopen the document before you can make changes to it.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Image=ReleaseDoc;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 ReleaseSalesDoc@1000 : Codeunit 414;
                               BEGIN
                                 ReleaseSalesDoc.PerformManualRelease(Rec);
                               END;
                                }
      { 1102601050;2 ;Action    ;
                      Name=Reopen;
                      CaptionML=[DAN=&bn igen;
                                 ENU=Re&open];
                      ToolTipML=[DAN=bn bilaget igen for at ‘ndre det, efter at det er blevet godkendt. Godkendte bilag har status Frigivet og skal †bnes, f›r de kan ‘ndres;
                                 ENU=Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Image=ReOpen;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 ReleaseSalesDoc@1001 : Codeunit 414;
                               BEGIN
                                 ReleaseSalesDoc.PerformManualReopen(Rec);
                               END;
                                }
      { 1102601001;1 ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 102     ;2   ;Action    ;
                      CaptionML=[DAN=Pla&nl‘gning;
                                 ENU=Pla&nning];
                      ToolTipML=[DAN=bn et v‘rkt›j til manuel leveringsplanl‘gning, der viser alle nye behov sammen med beholdningsoplysninger og forslag til levering. Det sikre den synlighed og giver adgang til de v‘rkt›jer, der kr‘ves for at planl‘gge levering fra salgslinjer og komponentlinjer for derefter at oprette forskellige typer forsyningsordrer direkte.;
                                 ENU=Open a tool for manual supply planning that displays all new demand along with availability information and suggestions for supply. It provides the visibility and tools needed to plan for demand from sales lines and component lines and then create different types of supply orders directly.];
                      ApplicationArea=#Planning;
                      Image=Planning;
                      OnAction=VAR
                                 SalesOrderPlanningForm@1001 : Page 99000883;
                               BEGIN
                                 SalesOrderPlanningForm.SetSalesOrder("No.");
                                 SalesOrderPlanningForm.RUNMODAL;
                               END;
                                }
      { 1102601020;2 ;Action    ;
                      AccessByPermission=TableData 99000880=R;
                      CaptionML=[DAN=Beregning af leverings&tid;
                                 ENU=Order &Promising];
                      ToolTipML=[DAN=Beregn afsendelses- og leveringsdatoerne ud fra varens kendte og forventede tilg‘ngelighedsdatoer, og oplys derefter datoerne til debitoren.;
                                 ENU=Calculate the shipment and delivery dates based on the item's known and expected availability dates, and then promise the dates to the customer.];
                      ApplicationArea=#Planning;
                      Image=OrderPromising;
                      OnAction=VAR
                                 OrderPromisingLine@1000 : TEMPORARY Record 99000880;
                               BEGIN
                                 OrderPromisingLine.SETRANGE("Source Type","Document Type");
                                 OrderPromisingLine.SETRANGE("Source ID","No.");
                                 PAGE.RUNMODAL(PAGE::"Order Promising Lines",OrderPromisingLine);
                               END;
                                }
      { 1102601053;2 ;Action    ;
                      AccessByPermission=TableData 410=R;
                      CaptionML=[DAN=Send IC-salgsordrebekr‘ftelse;
                                 ENU=Send IC Sales Order Cnfmn.];
                      ToolTipML=[DAN=Send bilaget til den koncerninterne udbakke eller direkte til den koncerninterne partner, hvis automatisk transaktionsafsendelse er aktiveret.;
                                 ENU=Send the document to the intercompany outbox or directly to the intercompany partner if automatic transaction sending is enabled.];
                      ApplicationArea=#Intercompany;
                      Image=IntercompanyOrder;
                      OnAction=VAR
                                 ICInOutboxMgt@1000 : Codeunit 427;
                                 ApprovalsMgmt@1003 : Codeunit 1535;
                               BEGIN
                                 IF ApprovalsMgmt.PrePostApprovalCheckSales(Rec) THEN
                                   ICInOutboxMgt.SendSalesDoc(Rec,FALSE);
                               END;
                                }
      { 24      ;1   ;ActionGroup;
                      CaptionML=[DAN=Anmod om godkendelse;
                                 ENU=Request Approval] }
      { 1102601046;2 ;Action    ;
                      Name=SendApprovalRequest;
                      CaptionML=[DAN=Send go&dkendelsesanmodning;
                                 ENU=Send A&pproval Request];
                      ToolTipML=[DAN=Anmod om godkendelse af bilaget.;
                                 ENU=Request approval of the document.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Enabled=NOT OpenApprovalEntriesExist AND CanRequestApprovalForFlow;
                      PromotedIsBig=Yes;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ApprovalsMgmt@1001 : Codeunit 1535;
                               BEGIN
                                 IF ApprovalsMgmt.CheckSalesApprovalPossible(Rec) THEN
                                   ApprovalsMgmt.OnSendSalesDocForApproval(Rec);
                               END;
                                }
      { 1102601047;2 ;Action    ;
                      Name=CancelApprovalRequest;
                      CaptionML=[DAN=Annuller godkendelsesan&modning;
                                 ENU=Cancel Approval Re&quest];
                      ToolTipML=[DAN=Annuller godkendelsesanmodningen.;
                                 ENU=Cancel the approval request.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Enabled=CanCancelApprovalForRecord OR CanCancelApprovalForFlow;
                      PromotedIsBig=Yes;
                      Image=CancelApprovalRequest;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ApprovalsMgmt@1001 : Codeunit 1535;
                                 WorkflowWebhookManagement@1000 : Codeunit 1543;
                               BEGIN
                                 ApprovalsMgmt.OnCancelSalesApprovalRequest(Rec);
                                 WorkflowWebhookManagement.FindAndCancel(RECORDID);
                               END;
                                }
      { 3       ;1   ;ActionGroup;
                      CaptionML=[DAN=Lagersted;
                                 ENU=Warehouse];
                      Image=Warehouse }
      { 100     ;2   ;Action    ;
                      AccessByPermission=TableData 7342=R;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Opret l&‘g-p†-lager (lager)/pluk (lager);
                                 ENU=Create Inventor&y Put-away/Pick];
                      ToolTipML=[DAN=Opret en l‘g-p†-lager-aktivitet eller et lagerpluk til h†ndtering af varer p† bilaget i overensstemmelse med en grundl‘ggende lagerops‘tning, der ikke kr‘ver lagermodtagelse eller leverancedokumenter.;
                                 ENU=Create an inventory put-away or inventory pick to handle items on the document according to a basic warehouse configuration that does not require warehouse receipt or shipment documents.];
                      ApplicationArea=#Warehouse;
                      Image=CreatePutawayPick;
                      OnAction=BEGIN
                                 CreateInvtPutAwayPick;

                                 IF NOT FIND('=><') THEN
                                   INIT;
                               END;
                                }
      { 1102601043;2 ;Action    ;
                      AccessByPermission=TableData 7320=R;
                      CaptionML=[DAN=Opre&t lagerleverance;
                                 ENU=Create &Whse. Shipment];
                      ToolTipML=[DAN=Opret en lagerleverance for at starte et pluk eller en leveringsproces i henhold til en avanceret lagerops‘tning.;
                                 ENU=Create a warehouse shipment to start a pick a ship process according to an advanced warehouse configuration.];
                      ApplicationArea=#Warehouse;
                      Image=NewShipment;
                      OnAction=VAR
                                 GetSourceDocOutbound@1001 : Codeunit 5752;
                               BEGIN
                                 GetSourceDocOutbound.CreateFromSalesOrder(Rec);

                                 IF NOT FIND('=><') THEN
                                   INIT;
                               END;
                                }
      { 49      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Bogf›ring;
                                 ENU=P&osting];
                      Image=Post }
      { 1102601003;2 ;Action    ;
                      Name=Post;
                      ShortCutKey=F9;
                      Ellipsis=Yes;
                      CaptionML=[DAN=B&ogf›r;
                                 ENU=P&ost];
                      ToolTipML=[DAN=F‘rdigg›r bilaget eller kladden ved at bogf›re bel›b og antal p† de relaterede konti i regnskaberne.;
                                 ENU=Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostOrder;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 SalesHeader@1003 : Record 36;
                                 SalesBatchPostMgt@1002 : Codeunit 1371;
                                 BatchProcessingMgt@1001 : Codeunit 1380;
                                 BatchPostParameterTypes@1000 : Codeunit 1370;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(SalesHeader);
                                 IF SalesHeader.COUNT > 1 THEN BEGIN
                                   BatchProcessingMgt.AddParameter(BatchPostParameterTypes.Invoice,TRUE);
                                   BatchProcessingMgt.AddParameter(BatchPostParameterTypes.Ship,TRUE);

                                   SalesBatchPostMgt.SetBatchProcessor(BatchProcessingMgt);
                                   SalesBatchPostMgt.RunWithUI(SalesHeader,COUNT,ReadyToPostQst);
                                 END ELSE
                                   Post(CODEUNIT::"Sales-Post (Yes/No)");
                               END;
                                }
      { 25      ;2   ;Action    ;
                      Name=PostAndSend;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Bogf›r og send;
                                 ENU=Post and Send];
                      ToolTipML=[DAN=F‘rdigg›r bilaget, og klarg›r det til afsendelse i henhold til debitorens afsendelsesprofil, f.eks. vedh‘ftet en mail. Vinduet Send dokument til vises, s† du kan bekr‘fte eller v‘lge en afsendelsesprofil.;
                                 ENU=Finalize and prepare to send the document according to the customer's sending profile, such as attached to an email. The Send document to window opens where you can confirm or select a sending profile.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostMail;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Post(CODEUNIT::"Sales-Post and Send");
                               END;
                                }
      { 1102601002;2 ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kontroller;
                                 ENU=Test Report];
                      ToolTipML=[DAN=Vis en testrapport, s† du kan finde og rette eventuelle fejl, f›r du udf›rer den faktiske bogf›ring af kladden eller bilaget.;
                                 ENU=View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.];
                      ApplicationArea=#Advanced;
                      Image=TestReport;
                      OnAction=BEGIN
                                 ReportPrint.PrintSalesHeader(Rec);
                               END;
                                }
      { 50      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Masse&bogf›r;
                                 ENU=Post &Batch];
                      ToolTipML=[DAN=Bogf›r flere bilag p† ‚n gang. Der †bnes et anmodningsvindue, hvor du kan angive, hvilke bilag der skal bogf›res.;
                                 ENU=Post several documents at once. A report request window opens where you can specify which documents to post.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Image=PostBatch;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 REPORT.RUNMODAL(REPORT::"Batch Post Sales Orders",TRUE,TRUE,Rec);
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 8       ;2   ;Action    ;
                      CaptionML=[DAN=Fjern fra opgavek›;
                                 ENU=Remove From Job Queue];
                      ToolTipML=[DAN=Fjern den planlagte behandling af denne record fra jobk›en.;
                                 ENU=Remove the scheduled processing of this record from the job queue.];
                      ApplicationArea=#All;
                      Visible=JobQueueActive;
                      Image=RemoveLine;
                      OnAction=BEGIN
                                 CancelBackgroundPosting;
                               END;
                                }
      { 22      ;2   ;Action    ;
                      CaptionML=[DAN=Vis bogf›ring;
                                 ENU=Preview Posting];
                      ToolTipML=[DAN=Gennemse de forskellige typer poster, der oprettes, n†r du bogf›rer bilaget eller kladden.;
                                 ENU=Review the different types of entries that will be created when you post the document or journal.];
                      ApplicationArea=#Advanced;
                      Image=ViewPostedOrder;
                      OnAction=BEGIN
                                 ShowPreview
                               END;
                                }
      { 150     ;1   ;ActionGroup;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      Image=Print }
      { 152     ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Arbejdsseddel;
                                 ENU=Work Order];
                      ToolTipML=[DAN=G›r dig klar til at registrere det faktiske antal varer eller den faktiske tid, der er brugt i forbindelse med salgsordren. Bilaget kan f.eks. benyttes af personale, som udf›rer en eller anden form for behandling i forbindelse med salgsordren. Det kan ogs† udl‘ses til Excel, hvis der er brug for at behandle salgslinjedataene yderligere.;
                                 ENU=Prepare to registers actual item quantities or time used in connection with the sales order. For example, the document can be used by staff who perform any kind of processing work in connection with the sales order. It can also be exported to Excel if you need to process the sales line data further.];
                      ApplicationArea=#Advanced;
                      Image=Print;
                      OnAction=BEGIN
                                 DocPrint.PrintSalesOrder(Rec,Usage::"Work Order");
                               END;
                                }
      { 7       ;2   ;Action    ;
                      CaptionML=[DAN=Plukinstruktion;
                                 ENU=Pick Instruction];
                      ToolTipML=[DAN=Udskriv en plukliste, der viser, hvilke varer der skal plukkes og leveres for salgsordren. Rapporten indeholder r‘kker for de montagekomponenter, der skal plukkes, hvis en vare er monteret under en ordre. Du kan bruge denne rapport som en plukinstruktion til medarbejdere, der st†r for at plukke salgsvarer eller montagekomponenter for salgsordren.;
                                 ENU=Print a picking list that shows which items to pick and ship for the sales order. If an item is assembled to order, then the report includes rows for the assembly components that must be picked. Use this report as a pick instruction to employees in charge of picking sales items or assembly components for the sales order.];
                      ApplicationArea=#Warehouse;
                      Image=Print;
                      OnAction=BEGIN
                                 DocPrint.PrintSalesOrder(Rec,Usage::"Pick Instruction");
                               END;
                                }
      { 19      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Ordrebekr‘ftelse;
                                 ENU=&Order Confirmation];
                      Image=Email }
      { 18      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Mail bekr‘ftelse;
                                 ENU=Email Confirmation];
                      ToolTipML=[DAN=Send en ordrebekr‘ftelse via mail. Vinduet Send mail †bnes med debitorens oplysninger, s† du kan tilf›je eller redigere oplysninger, f›r du sender mailen.;
                                 ENU=Send an order confirmation by email. The Send Email window opens prefilled for the customer so you can add or change information before you send the email.];
                      ApplicationArea=#Advanced;
                      Image=Email;
                      OnAction=BEGIN
                                 DocPrint.EmailSalesHeader(Rec);
                               END;
                                }
      { 151     ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Udskriv bekr‘ftelse;
                                 ENU=Print Confirmation];
                      ToolTipML=[DAN=Udskriv en ordrebekr‘ftelse. Du f†r vist et rapportanmodningsvindue, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Print an order confirmation. A report request window opens where you can specify what to include on the print-out.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Visible=NOT IsOfficeAddin;
                      Image=Print;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 DocPrint.PrintSalesOrder(Rec,Usage::"Order Confirmation");
                               END;
                                }
      { 40      ;1   ;ActionGroup;
                      CaptionML=[DAN=Vis;
                                 ENU=Display] }
      { 38      ;2   ;Action    ;
                      Name=ReportFactBoxVisibility;
                      CaptionML=[DAN=Vis/skjul Power BI-rapporter;
                                 ENU=Show/Hide Power BI Reports];
                      ToolTipML=[DAN=V‘lg, om faktaboksen Power BI skal v‘re synlig eller ej.;
                                 ENU=Select if the Power BI FactBox is visible or not.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Report;
                      OnAction=BEGIN
                                 IF PowerBIVisible THEN
                                   PowerBIVisible := FALSE
                                 ELSE
                                   PowerBIVisible := TRUE;
                                 // save visibility value into the table
                                 CurrPage."Power BI Report FactBox".PAGE.SetFactBoxVisibility(PowerBIVisible);
                               END;
                                }
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 1904702706;1 ;Action    ;
                      CaptionML=[DAN=Disp. salgsreservation;
                                 ENU=Sales Reservation Avail.];
                      ToolTipML=[DAN=Vis, udskriv eller gem en oversigt over, hvilke varer der er disponible til levering p† salgsbilaget filtreret efter leveringsstatus.;
                                 ENU=View, print, or save an overview of availability of items for shipment on sales documents, filtered on shipment status.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 209;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
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
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† debitoren.;
                           ENU=Specifies the number of the customer.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Customer No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† debitoren.;
                           ENU=Specifies the name of the customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Customer Name" }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer, som bliver brugt i debitors eller kreditors nummereringssystem.;
                           ENU=Specifies a document number that refers to the customer's or vendor's numbering system.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="External Document No." }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret i debitorens prim‘re adresse.;
                           ENU=Specifies the postal code of the customer's main address.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Post Code";
                Visible=FALSE }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver landet/omr†dekoden for debitorens prim‘re adresse.;
                           ENU=Specifies the country/region code of the customer's main address.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Country/Region Code";
                Visible=FALSE }

    { 41  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† kontaktpersonen p† debitorens prim‘re adresse.;
                           ENU=Specifies the name of the contact person at the customer's main address.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Contact";
                Visible=FALSE }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den debitor, som du sender eller har sendt fakturaen eller kreditnotaen til.;
                           ENU=Specifies the number of the customer that you send or sent the invoice or credit memo to.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to Customer No.";
                Visible=FALSE }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den debitor, som du sender eller har sendt fakturaen eller kreditnotaen til.;
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
                ToolTipML=[DAN=Angiver landet/omr†dekoden for debitorens faktureringsadresse.;
                           ENU=Specifies the country/region code of the customer's billing address.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to Country/Region Code";
                Visible=FALSE }

    { 159 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† kontaktpersonen p† debitorens faktureringsadresse.;
                           ENU=Specifies the name of the contact person at the customer's billing address.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to Contact";
                Visible=FALSE }

    { 155 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for en alternativ leveringsadresse, hvis du vil sende til en anden adresse end den, der er indsat automatisk. Dette felt bruges ogs† i tilf‘lde af direkte levering.;
                           ENU=Specifies a code for an alternate shipment address if you want to ship to another address than the one that has been entered automatically. This field is also used in case of drop shipment.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Code";
                Visible=FALSE }

    { 153 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† debitoren p† den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the customer at the address that the items are shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Name";
                Visible=FALSE }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret p† den adresse, som varerne leveres til.;
                           ENU=Specifies the postal code of the address that the items are shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Post Code";
                Visible=FALSE }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver lande-/omr†dekoden p† den adresse, som varerne leveres til.;
                           ENU=Specifies the country/region code of the address that the items are shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Country/Region Code";
                Visible=FALSE }

    { 143 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† kontaktpersonen p† den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the contact person at the address that the items are shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Contact";
                Visible=FALSE }

    { 139 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor bogf›ringen af salgsdokumentet skal registreres.;
                           ENU=Specifies the date when the posting of the sales document will be recorded.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Posting Date";
                Visible=FALSE }

    { 121 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 119 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 123 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver placeringen, hvor lagervarer til debitoren p† salgsbilaget skal sendes som standard.;
                           ENU=Specifies the location from where inventory items to the customer on the sales document are to be shipped by default.];
                ApplicationArea=#Location;
                SourceExpr="Location Code" }

    { 99  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den s‘lger, der er tildelt til debitoren.;
                           ENU=Specifies the name of the salesperson who is assigned to the customer.];
                ApplicationArea=#Suite;
                SourceExpr="Salesperson Code";
                Visible=FALSE }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der er ansvarlig for bilaget.;
                           ENU=Specifies the ID of the user who is responsible for the document.];
                ApplicationArea=#Advanced;
                SourceExpr="Assigned User ID" }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver valutaen for bel›bene i salgsdokumentet.;
                           ENU=Specifies the currency of amounts on the sales document.];
                ApplicationArea=#Suite;
                SourceExpr="Currency Code";
                Visible=FALSE }

    { 1102601025;2;Field  ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Date" }

    { 1102601027;2;Field  ;
                ToolTipML=[DAN=Indeholder den dato, hvor debitoren har ›nsket varerne leveret.;
                           ENU=Specifies the date that the customer has asked for the order to be delivered.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Requested Delivery Date";
                Visible=FALSE }

    { 1102601005;2;Field  ;
                ToolTipML=[DAN=Angiver nummeret p† den kampagne, bilaget er knyttet til.;
                           ENU=Specifies the campaign number the document is linked to.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Campaign No.";
                Visible=FALSE }

    { 1102601029;2;Field  ;
                ToolTipML=[DAN=Angiver, om dokumentet er †bent, venter p† godkendelse, er faktureret til forudbetaling eller er frigivet til n‘ste fase i behandlingen.;
                           ENU=Specifies whether the document is open, waiting to be approved, has been invoiced for prepayment, or has been released to the next stage of processing.];
                ApplicationArea=#Advanced;
                SourceExpr=Status }

    { 1102601039;2;Field  ;
                ToolTipML=[DAN=Angiver en formel, der beregner betalingens forfaldsdato, kontantrabatdato og kontantrabatbel›b.;
                           ENU=Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Terms Code";
                Visible=FALSE }

    { 1102601041;2;Field  ;
                ToolTipML=[DAN=Angiver, hvorn†r salgsfakturaen skal betales.;
                           ENU=Specifies when the sales invoice must be paid.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Due Date";
                Visible=FALSE }

    { 1102601054;2;Field  ;
                ToolTipML=[DAN=Angiver den rabatprocent, der tildeles, hvis debitoren betaler p† eller f›r den dato, der er angivet i feltet Kont.rabatdato. Rabatprocenten er angivet i feltet Betalingsbetingelseskode.;
                           ENU=Specifies the payment discount percentage that is granted if the customer pays on or before the date entered in the Pmt. Discount Date field. The discount percentage is specified in the Payment Terms Code field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Discount %";
                Visible=FALSE }

    { 1102601035;2;Field  ;
                ToolTipML=[DAN=Angiver betingelserne for levering af den relaterede leverance, som f.eks. frit ombord (FOB).;
                           ENU=Specifies the delivery conditions of the related shipment, such as free on board (FOB).];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Shipment Method Code";
                Visible=FALSE }

    { 1102601033;2;Field  ;
                ToolTipML=[DAN=Angiver koden for den spedit›r, som transporterer varerne.;
                           ENU=Specifies the code for the shipping agent who is transporting the items.];
                ApplicationArea=#Suite;
                SourceExpr="Shipping Agent Code";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for servicen, f.eks. levering samme dag, som tilbydes af spedit›ren.;
                           ENU=Specifies the code for the service, such as a one-day delivery, that is offered by the shipping agent.];
                ApplicationArea=#Suite;
                SourceExpr="Shipping Agent Service Code";
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver spedit›rens pakkenummer.;
                           ENU=Specifies the shipping agent's package number.];
                ApplicationArea=#Suite;
                SourceExpr="Package Tracking No.";
                Visible=FALSE }

    { 1102601031;2;Field  ;
                ToolTipML=[DAN=Angiver, hvorn†r varerne p† bilaget er sendt eller leveret. En afsendelsesdato beregnes normalt ud fra en ›nsket leveringsdato plus leveringstiden.;
                           ENU=Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.];
                ApplicationArea=#Advanced;
                SourceExpr="Shipment Date";
                Visible=FALSE }

    { 1102601037;2;Field  ;
                ToolTipML=[DAN=Angiver, om debitoren accepterer dellevering af ordrer.;
                           ENU=Specifies if the customer accepts partial shipment of orders.];
                ApplicationArea=#Advanced;
                SourceExpr="Shipping Advice";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om alle varer i ordren er leveret, eller - hvis der er tale om indg†ende varer - modtaget helt.;
                           ENU=Specifies whether all the items on the order have been shipped or, in the case of inbound items, completely received.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Completely Shipped" }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for en opgavek›post eller opgave, der h†ndterer bogf›ring af salgsordrer.;
                           ENU=Specifies the status of a job queue entry or task that handles the posting of sales orders.];
                ApplicationArea=#All;
                SourceExpr="Job Queue Status";
                Visible=JobQueueActive }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver summen i RV for varer, der er leveret, men endnu ikke faktureret. Bel›bet beregnes som Bel›b inkl. moms x Lev. antal (ufakt.) / Antal.;
                           ENU=Specifies the sum, in LCY, for items that have been shipped but not yet been invoiced. The amount is calculated as Amount Including VAT x Qty. Shipped Not Invoiced / Quantity.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Amt. Ship. Not Inv. (LCY) Base" }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver summen i RV for varer, der er leveret, men endnu ikke faktureret. Bel›bet beregnes som Bel›b inkl. moms x Lev. antal (ufakt.) / Antal.;
                           ENU=Specifies the sum, in LCY, for items that have been shipped but not yet been invoiced. The amount is calculated as Amount Including VAT x Qty. Shipped Not Invoiced / Quantity.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Amt. Ship. Not Inv. (LCY)" }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver summen af bel›b i feltet Linjebel›b p† salgsordrelinjerne.;
                           ENU=Specifies the sum of amounts in the Line Amount field on the sales order lines.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Amount }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den samlede sum af bel›bene, herunder moms, p† alle dokumentets linjer.;
                           ENU=Specifies the total of the amounts, including VAT, on all the lines on the document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Amount Including VAT" }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 37  ;1   ;Part      ;
                Name=Power BI Report FactBox;
                CaptionML=[DAN=Power BI-rapporter;
                           ENU=Power BI Reports];
                ApplicationArea=#Basic,#Suite;
                PagePartID=Page6306;
                Visible=PowerBIVisible;
                PartType=Page }

    { 1902018507;1;Part   ;
                ApplicationArea=#Basic,#Suite;
                SubPageLink=No.=FIELD(Bill-to Customer No.),
                            Date Filter=FIELD(Date Filter);
                PagePartID=Page9082;
                PartType=Page }

    { 1900316107;1;Part   ;
                ApplicationArea=#Basic,#Suite;
                SubPageLink=No.=FIELD(Bill-to Customer No.),
                            Date Filter=FIELD(Date Filter);
                PagePartID=Page9084;
                PartType=Page }

    { 20  ;1   ;Part      ;
                Name=IncomingDocAttachFactBox;
                ApplicationArea=#Basic,#Suite;
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
      ApplicationAreaSetup@1007 : Record 9178;
      PowerBIUserConfiguration@1011 : Record 6304;
      SetPowerBIUserConfig@1010 : Codeunit 6305;
      DocPrint@1013 : Codeunit 229;
      ReportPrint@1012 : Codeunit 228;
      UserMgt@1009 : Codeunit 5700;
      Usage@1008 : 'Order Confirmation,Work Order,Pick Instruction';
      JobQueueActive@1006 : Boolean INDATASET;
      OpenApprovalEntriesExist@1005 : Boolean;
      CRMIntegrationEnabled@1004 : Boolean;
      IsOfficeAddin@1003 : Boolean;
      CanCancelApprovalForRecord@1002 : Boolean;
      SkipLinesWithoutVAT@1001 : Boolean;
      PowerBIVisible@1014 : Boolean;
      ReadyToPostQst@1000 : TextConst '@@@=%1 - selected count, %2 - total count;DAN=%1 ud af %2 valgte ordrer er klar til bogf›ring. \Vil du forts‘tte og bogf›re dem?;ENU=%1 out of %2 selected orders are ready for post. \Do you want to continue and post them?';
      CanRequestApprovalForFlow@1015 : Boolean;
      CanCancelApprovalForFlow@1016 : Boolean;

    [Internal]
    PROCEDURE ShowPreview@1();
    VAR
      SalesPostYesNo@1001 : Codeunit 81;
    BEGIN
      SalesPostYesNo.Preview(Rec);
    END;

    LOCAL PROCEDURE SetControlVisibility@5();
    VAR
      ApprovalsMgmt@1000 : Codeunit 1535;
      WorkflowWebhookManagement@1001 : Codeunit 1543;
    BEGIN
      OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);

      CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RECORDID);

      WorkflowWebhookManagement.GetCanRequestAndCanCancel(RECORDID,CanRequestApprovalForFlow,CanCancelApprovalForFlow);
    END;

    LOCAL PROCEDURE Post@4(PostingCodeunitID@1000 : Integer);
    VAR
      LinesInstructionMgt@1002 : Codeunit 1320;
    BEGIN
      IF ApplicationAreaSetup.IsFoundationEnabled THEN
        LinesInstructionMgt.SalesCheckAllLinesHaveQuantityAssigned(Rec);

      SendToPosting(PostingCodeunitID);

      CurrPage.UPDATE(FALSE);
    END;

    [External]
    PROCEDURE SkipShowingLinesWithoutVAT@2();
    BEGIN
      SkipLinesWithoutVAT := TRUE;
    END;

    LOCAL PROCEDURE ShowHeader@6() : Boolean;
    VAR
      CashFlowManagement@1000 : Codeunit 841;
    BEGIN
      IF NOT SkipLinesWithoutVAT THEN
        EXIT(TRUE);

      EXIT(CashFlowManagement.GetTaxAmountFromSalesOrder(Rec) <> 0);
    END;

    BEGIN
    END.
  }
}

