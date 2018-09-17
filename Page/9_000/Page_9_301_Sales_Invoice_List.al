OBJECT Page 9301 Sales Invoice List
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
    CaptionML=[DAN=Salgsfakturaer;
               ENU=Sales Invoices];
    SourceTable=Table36;
    SourceTableView=WHERE(Document Type=CONST(Invoice));
    DataCaptionFields=Sell-to Customer No.;
    PageType=List;
    CardPageID=Sales Invoice;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport‚r,Frigiv,Bogf›ring,Faktura,Anmod om godkendelse;
                                ENU=New,Process,Report,Release,Posting,Invoice,Request Approval];
    OnOpenPage=VAR
                 SalesSetup@1000 : Record 311;
               BEGIN
                 SetSecurityFilterOnRespCenter;
                 JobQueueActive := SalesSetup.JobQueueActive;

                 CopySellToCustomerFilter;
               END;

    OnAfterGetCurrRecord=BEGIN
                           SetControlAppearance;
                           CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102601019;1 ;ActionGroup;
                      CaptionML=[DAN=F&aktura;
                                 ENU=&Invoice];
                      Image=Invoice }
      { 1102601021;2 ;Action    ;
                      Name=Statistics;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=F† vist statistiske oplysninger som f.eks. v‘rdien for bogf›rte poster til recorden.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Category6;
                      OnAction=BEGIN
                                 CalcInvDiscForHeader;
                                 COMMIT;
                                 PAGE.RUNMODAL(PAGE::"Sales Statistics",Rec);
                               END;
                                }
      { 1102601023;2 ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 67;
                      RunPageLink=Document Type=FIELD(Document Type),
                                  No.=FIELD(No.),
                                  Document Line No.=CONST(0);
                      Promoted=Yes;
                      Image=ViewComments;
                      PromotedCategory=Category6 }
      { 1102601024;2 ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      Promoted=Yes;
                      Image=Dimensions;
                      PromotedCategory=Category6;
                      OnAction=BEGIN
                                 ShowDocDim;
                               END;
                                }
      { 1102601025;2 ;Action    ;
                      Name=Approvals;
                      AccessByPermission=TableData 454=R;
                      CaptionML=[DAN=Godkendelser;
                                 ENU=Approvals];
                      ToolTipML=[DAN=F† vist en liste over records, der afventer godkendelse. Du kan f.eks. se, hvem der har anmodet om godkendelse af recorden, hvorn†r den blev sendt og hvorn†r den skal godkendes.;
                                 ENU=View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Approvals;
                      PromotedCategory=Category6;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 WorkflowsEntriesBuffer@1001 : Record 832;
                               BEGIN
                                 WorkflowsEntriesBuffer.RunWorkflowEntriesPage(RECORDID,DATABASE::"Sales Header","Document Type","No.");
                               END;
                                }
      { 14      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Debitor;
                                 ENU=Customer];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om debitoren.;
                                 ENU=View or edit detailed information about the customer.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 21;
                      RunPageLink=No.=FIELD(Sell-to Customer No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Customer;
                      PromotedCategory=Category6;
                      PromotedOnly=Yes;
                      Scope=Repeater }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 8       ;1   ;ActionGroup;
                      Name=Invoice;
                      CaptionML=[DAN=&Fakturer;
                                 ENU=&Invoice];
                      Image=Invoice }
      { 7       ;1   ;ActionGroup;
                      CaptionML=[DAN=Frigiv;
                                 ENU=Release];
                      Image=ReleaseDoc }
      { 1102601017;2 ;Action    ;
                      ShortCutKey=Ctrl+F9;
                      CaptionML=[DAN=&Frigiv;
                                 ENU=Re&lease];
                      ToolTipML=[DAN=Frigiv bilaget til n‘ste behandlingstrin. N†r et bilag frigives, bliver det inkluderet i alle disponeringsberegninger fra den dato, varerne forventes modtaget. Du skal gen†bne bilaget, f›r du kan foretage ‘ndringer i det.;
                                 ENU=Release the document to the next stage of processing. When a document is released, it will be included in all availability calculations from the expected receipt date of the items. You must reopen the document before you can make changes to it.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Image=ReleaseDoc;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ReleaseSalesDoc@1000 : Codeunit 414;
                               BEGIN
                                 ReleaseSalesDoc.PerformManualRelease(Rec);
                               END;
                                }
      { 1102601018;2 ;Action    ;
                      CaptionML=[DAN=&bn igen;
                                 ENU=Re&open];
                      ToolTipML=[DAN=bn bilaget igen for at ‘ndre det, efter at det er blevet godkendt. Godkendte bilag har status Frigivet og skal †bnes, f›r de kan ‘ndres.;
                                 ENU=Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Image=ReOpen;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ReleaseSalesDoc@1001 : Codeunit 414;
                               BEGIN
                                 ReleaseSalesDoc.PerformManualReopen(Rec);
                               END;
                                }
      { 1102601000;1 ;ActionGroup;
                      CaptionML=[DAN=Anmod om godkendelse;
                                 ENU=Request Approval];
                      Image=Action }
      { 1102601014;2 ;Action    ;
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
                      PromotedCategory=Category7;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ApprovalsMgmt@1001 : Codeunit 1535;
                               BEGIN
                                 IF ApprovalsMgmt.CheckSalesApprovalPossible(Rec) THEN
                                   ApprovalsMgmt.OnSendSalesDocForApproval(Rec);
                               END;
                                }
      { 1102601015;2 ;Action    ;
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
                      PromotedCategory=Category7;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ApprovalsMgmt@1001 : Codeunit 1535;
                                 WorkflowWebhookManagement@1000 : Codeunit 1543;
                               BEGIN
                                 ApprovalsMgmt.OnCancelSalesApprovalRequest(Rec);
                                 WorkflowWebhookManagement.FindAndCancel(RECORDID);
                               END;
                                }
      { 49      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Bogf›ring;
                                 ENU=P&osting];
                      Image=Post }
      { 53      ;2   ;Action    ;
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
      { 51      ;2   ;Action    ;
                      Name=Post;
                      ShortCutKey=F9;
                      CaptionML=[DAN=&Bogf›r;
                                 ENU=P&ost];
                      ToolTipML=[DAN=F‘rdigg›r bilaget eller kladden ved at bogf›re bel›b og antal p† de relaterede konti i regnskaberne.;
                                 ENU=Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostOrder;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 SalesHeader@1000 : Record 36;
                                 SalesBatchPostMgt@1001 : Codeunit 1371;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(SalesHeader);
                                 IF SalesHeader.COUNT > 1 THEN
                                   SalesBatchPostMgt.RunWithUI(SalesHeader,COUNT,ReadyToPostQst)
                                 ELSE
                                   Post(CODEUNIT::"Sales-Post (Yes/No)");
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
                      PromotedCategory=Category5;
                      OnAction=BEGIN
                                 REPORT.RUNMODAL(REPORT::"Batch Post Sales Invoices",TRUE,TRUE,Rec);
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 59      ;2   ;Action    ;
                      Name=PostAndSend;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Bogf›r og &send;
                                 ENU=Post and &Send];
                      ToolTipML=[DAN=F‘rdigg›r bilaget, og klarg›r det til afsendelse i henhold til debitorens afsendelsesprofil, f.eks. vedh‘ftet en mail. Vinduet Send dokument til vises, s† du kan bekr‘fte eller v‘lge en afsendelsesprofil.;
                                 ENU=Finalize and prepare to send the document according to the customer's sending profile, such as attached to an email. The Send document to window opens first so you can confirm or select a sending profile.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostSendTo;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 LinesInstructionMgt.SalesCheckAllLinesHaveQuantityAssigned(Rec);
                                 SendToPosting(CODEUNIT::"Sales-Post and Send");
                               END;
                                }
      { 5       ;2   ;Action    ;
                      CaptionML=[DAN=Fjern fra opgavek›;
                                 ENU=Remove From Job Queue];
                      ToolTipML=[DAN=Fjern den planlagte behandling af denne record fra jobk›en.;
                                 ENU=Remove the scheduled processing of this record from the job queue.];
                      ApplicationArea=#All;
                      Visible=JobQueueActive;
                      Image=RemoveLine;
                      PromotedCategory=Category5;
                      OnAction=BEGIN
                                 CancelBackgroundPosting;
                               END;
                                }
      { 10      ;2   ;Action    ;
                      Name=Preview;
                      CaptionML=[DAN=Vis bogf›ring;
                                 ENU=Preview Posting];
                      ToolTipML=[DAN=Gennemse de forskellige typer poster, der oprettes, n†r du bogf›rer bilaget eller kladden.;
                                 ENU=Review the different types of entries that will be created when you post the document or journal.];
                      ApplicationArea=#Advanced;
                      Image=ViewPostedOrder;
                      OnAction=BEGIN
                                 ShowPreview;
                               END;
                                }
      { 43      ;0   ;ActionContainer;
                      ActionContainerType=Reports }
      { 38      ;1   ;ActionGroup;
                      Name=Reports;
                      CaptionML=[DAN=Rapporter;
                                 ENU=Reports];
                      ActionContainerType=Reports;
                      Image=Report }
      { 31      ;2   ;ActionGroup;
                      Name=FinanceReports;
                      CaptionML=[DAN=Finansrapporter;
                                 ENU=Finance Reports];
                      Image=Report }
      { 30      ;3   ;Action    ;
                      Name=Report Statement;
                      CaptionML=[DAN=Kontoudtog;
                                 ENU=Statement];
                      ToolTipML=[DAN=Vis en liste over debitors transaktioner i en bestemt periode, f.eks. for at sende udskriften til debitor i slutningen af en regnskabsperiode. Du kan v‘lge at f† vist samtlige forfaldne saldi, uafh‘ngigt af den angivne periode, eller du kan v‘lge at inkludere et aldersfordelingsinterval.;
                                 ENU=View a list of a customer's transactions for a selected period, for example, to send to the customer at the close of an accounting period. You can choose to have all overdue balances displayed regardless of the period specified, or you can choose to include an aging band.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Report;
                      OnAction=VAR
                                 Customer@1000 : Record 18;
                               BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Customer Layout - Statement",Customer);
                               END;
                                }
      { 28      ;3   ;Action    ;
                      CaptionML=[DAN=Debitor - saldo til dato;
                                 ENU=Customer - Balance to Date];
                      ToolTipML=[DAN=Vis en liste over debitorers betalingshistorik op til en bestemt dato. Du kan bruge rapporten til at udtr‘kke oplysninger om din samlede salgsindkomst ved slutningen af en regnskabsperiode eller et regnskabs†r.;
                                 ENU=View a list with customers' payment history up until a certain date. You can use the report to extract your total sales income at the close of an accounting period or fiscal year.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 121;
                      Image=Report }
      { 26      ;3   ;Action    ;
                      CaptionML=[DAN=Debitor - balance;
                                 ENU=Customer - Trial Balance];
                      ToolTipML=[DAN=Vis start- og slutsaldi for debitorer med poster i en bestemt periode. Rapporten kan bruges til at bekr‘fte, at saldoen for en debitorbogf›ringsgruppe svarer til saldoen p† den tilsvarende finanskonto p† en bestemt dato.;
                                 ENU=View the beginning and ending balance for customers with entries within a specified period. The report can be used to verify that the balance for a customer posting group is equal to the balance on the corresponding general ledger account on a certain date.];
                      ApplicationArea=#Suite;
                      RunObject=Report 129;
                      Image=Report }
      { 25      ;3   ;Action    ;
                      CaptionML=[DAN=Debitor - kontokort;
                                 ENU=Customer - Detail Trial Bal.];
                      ToolTipML=[DAN=Vis saldi for debitorer med saldi p† en bestemt dato. Rapporten kan f.eks. bruges i slutningen af en regnskabsperiode eller i forbindelse med revision.;
                                 ENU=View the balance for customers with balances on a specified date. The report can be used at the close of an accounting period, for example, or for an audit.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 104;
                      Image=Report }
      { 24      ;3   ;Action    ;
                      CaptionML=[DAN=Debitor - forfaldsoversigt;
                                 ENU=Customer - Summary Aging];
                      ToolTipML=[DAN=Vis, udskriv eller gem en oversigt over hver debitors samlede forfaldne betalinger, opdelt i tre tidsperioder. Rapporten kan bruges til at bestemme, hvorn†r der skal udstedes rykkere, til at vurdere en debitors kreditv‘rdighed eller til at udarbejde likviditetsanalyser.;
                                 ENU=View, print, or save a summary of each customer's total payments due, divided into three time periods. The report can be used to decide when to issue reminders, to evaluate a customer's creditworthiness, or to prepare liquidity analyses.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 105;
                      Image=Report }
      { 22      ;3   ;Action    ;
                      CaptionML=[DAN=Debitor - forfaldne debitorposter;
                                 ENU=Customer - Detailed Aging];
                      ToolTipML=[DAN=Vis, udskriv eller gem en detaljeret liste over hver debitors samlede forfaldne betalinger, opdelt i tre tidsperioder. Rapporten kan bruges til at bestemme, hvorn†r der skal udstedes rykkere, til at vurdere en debitors kreditv‘rdighed eller til at udarbejde likviditetsanalyser.;
                                 ENU=View, print, or save a detailed list of each customer's total payments due, divided into three time periods. The report can be used to decide when to issue reminders, to evaluate a customer's creditworthiness, or to prepare liquidity analyses.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 106;
                      Image=Report }
      { 20      ;3   ;Action    ;
                      CaptionML=[DAN=Aldersfordelte tilgodehavender;
                                 ENU=Aged Accounts Receivable];
                      ToolTipML=[DAN=Vis en oversigt over, hvorn†r debitorers betalinger skal betales eller rykkes for, opdelt i fire perioder. Du skal angive den dato, som aldersfordelingen skal beregnes ud fra, og du skal angive den periode, som hver kolonne skal indeholde data for.;
                                 ENU=View an overview of when customer payments are due or overdue, divided into four periods. You must specify the date you want aging calculated from and the length of the period that each column will contain data for.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 120;
                      Image=Report }
      { 19      ;3   ;Action    ;
                      CaptionML=[DAN=Debitor - betalingskvittering;
                                 ENU=Customer - Payment Receipt];
                      ToolTipML=[DAN=Vis et bilag med de debitorposter, som en betaling er tildelt. Denne rapport kan anvendes som den betalingskvittering, du sender til debitor.;
                                 ENU=View a document showing which customer ledger entries that a payment has been applied to. This report can be used as a payment receipt that you send to the customer.];
                      ApplicationArea=#Suite;
                      RunObject=Report 211;
                      Image=Report }
      { 37      ;2   ;ActionGroup;
                      Name=SalesReports;
                      CaptionML=[DAN=Salgsrapporter;
                                 ENU=Sales Reports];
                      Image=Report }
      { 36      ;3   ;Action    ;
                      CaptionML=[DAN=Debitor - top 10-liste;
                                 ENU=Customer - Top 10 List];
                      ToolTipML=[DAN=Vis de debitorer, der k›ber mest, eller som skylder mest, i en bestemt periode. Kun de debitorer, der har k›b i l›bet af perioden eller en saldo ved periodens afslutning, vil blive vist i rapporten.;
                                 ENU=View which customers purchase the most or owe the most in a selected period. Only customers that have either purchases during the period or a balance at the end of the period will be included.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 111;
                      Image=Report }
      { 34      ;3   ;Action    ;
                      CaptionML=[DAN=Debitor - salgsoversigt;
                                 ENU=Customer - Sales List];
                      ToolTipML=[DAN=Vis debitorsalg for en given periode, f.eks. for at rapportere om salgsaktivitet til SKAT. Du kan v‘lge kun at medtage debitorer med et samlet salg, der overstiger et bestemt bel›b. Du kan ogs† angive, om rapporten skal vise adresseoplysningerne for hver enkelt debitor.;
                                 ENU=View customer sales for a period, for example, to report sales activity to customs and tax authorities. You can choose to include only customers with total sales that exceed a minimum amount. You can also specify whether you want the report to show address details for each customer.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 119;
                      Image=Report }
      { 32      ;3   ;Action    ;
                      CaptionML=[DAN=Salgsstatistik;
                                 ENU=Sales Statistics];
                      ToolTipML=[DAN=Vis debitorens samlede omkostninger, salg eller avance over tid, f.eks. med henblik p† at analysere indtjeningstendenser. Rapporten viser bel›b for den oprindelige og regulerede kostpris, oms‘tning, avance, fakturarabat, kontantrabat og avanceprocent i tre regulerbare perioder.;
                                 ENU=View the customer's total cost, sale, and profit over time, for example, to analyze earnings trends. The report shows amounts for original and adjusted cost, sales, profit, invoice discount, payment discount, and profit percentage in three adjustable periods.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 112;
                      Image=Report }
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
                ApplicationArea=#Advanced;
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
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Contact" }

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
                SourceExpr="Posting Date" }

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
                ToolTipML=[DAN=Angiver placeringen, hvor lagervarer til debitoren p† salgsbilaget skal sendes som standard.;
                           ENU=Specifies the location from where inventory items to the customer on the sales document are to be shipped by default.];
                ApplicationArea=#Location;
                SourceExpr="Location Code" }

    { 99  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den s‘lger, der er tildelt til debitoren.;
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
                ToolTipML=[DAN=Angiver valutaen for bel›bene i salgsdokumentet.;
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
                ToolTipML=[DAN=Angiver nummeret p† den kampagne, som dokumentet er tilknyttet.;
                           ENU=Specifies the number of the campaign that the document is linked to.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Campaign No.";
                Visible=FALSE }

    { 1102601005;2;Field  ;
                ToolTipML=[DAN=Angiver, om dokumentet er †bent, venter p† godkendelse, er faktureret til forudbetaling eller er frigivet til n‘ste fase i behandlingen.;
                           ENU=Specifies whether the document is open, waiting to be approved, has been invoiced for prepayment, or has been released to the next stage of processing.];
                ApplicationArea=#Advanced;
                SourceExpr=Status;
                Visible=FALSE }

    { 1102601007;2;Field  ;
                ToolTipML=[DAN=Angiver en formel, der beregner betalingens forfaldsdato, kontantrabatdato og kontantrabatbel›b.;
                           ENU=Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.];
                ApplicationArea=#Advanced;
                SourceExpr="Payment Terms Code";
                Visible=FALSE }

    { 1102601009;2;Field  ;
                ToolTipML=[DAN=Angiver, hvorn†r salgsfakturaen skal betales.;
                           ENU=Specifies when the sales invoice must be paid.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Due Date" }

    { 1102601011;2;Field  ;
                ToolTipML=[DAN=Angiver den rabatprocent, der tildeles, hvis debitoren betaler f›r eller p† den dato, der er angivet i feltet Kont.rabatdato.;
                           ENU=Specifies the payment discount percentage granted if the customer pays on or before the date entered in the Pmt. Discount Date field.];
                ApplicationArea=#Advanced;
                SourceExpr="Payment Discount %";
                Visible=FALSE }

    { 1102601022;2;Field  ;
                ToolTipML=[DAN=Angiver betingelserne for levering af den relaterede leverance, som f.eks. frit ombord (FOB).;
                           ENU=Specifies the delivery conditions of the related shipment, such as free on board (FOB).];
                ApplicationArea=#Advanced;
                SourceExpr="Shipment Method Code";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den spedit›r, som transporterer varerne.;
                           ENU=Specifies the code for the shipping agent who is transporting the items.];
                ApplicationArea=#Suite;
                SourceExpr="Shipping Agent Code";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for servicen, f.eks. levering samme dag, som tilbydes af spedit›ren.;
                           ENU=Specifies the code for the service, such as a one-day delivery, that is offered by the shipping agent.];
                ApplicationArea=#Suite;
                SourceExpr="Shipping Agent Service Code";
                Visible=FALSE }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver spedit›rens pakkenummer.;
                           ENU=Specifies the shipping agent's package number.];
                ApplicationArea=#Suite;
                SourceExpr="Package Tracking No.";
                Visible=FALSE }

    { 1102601013;2;Field  ;
                ToolTipML=[DAN=Angiver, hvorn†r varerne p† bilaget er sendt eller leveret. En afsendelsesdato beregnes normalt ud fra en ›nsket leveringsdato plus leveringstiden.;
                           ENU=Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.];
                ApplicationArea=#Advanced;
                SourceExpr="Shipment Date";
                Visible=FALSE }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for en opgavek›post eller opgave, der h†ndterer bogf›ringen af salgsfakturaer.;
                           ENU=Specifies the status of a job queue entry or task that handles the posting of sales invoices.];
                ApplicationArea=#All;
                SourceExpr="Job Queue Status";
                Visible=JobQueueActive }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver summen af bel›b i feltet Linjebel›b p† salgsordrelinjerne. Den bruges til at beregne fakturarabatten for salgsordren.;
                           ENU=Specifies the sum of amounts in the Line Amount field on the sales order lines. It is used to calculate the invoice discount of the sales order.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Amount }

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

    { 9   ;1   ;Part      ;
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
      DummyApplicationAreaSetup@1001 : Record 9178;
      ReportPrint@1102601000 : Codeunit 228;
      LinesInstructionMgt@1003 : Codeunit 1320;
      JobQueueActive@1000 : Boolean INDATASET;
      OpenApprovalEntriesExist@1004 : Boolean;
      OpenPostedSalesInvQst@1006 : TextConst 'DAN=Fakturaen er blevet bogf›rt og flyttet til listen Bogf›rt salgsfaktura.\\Vil du †bne den bogf›rte faktura?;ENU=The invoice has been posted and moved to the Posted Sales Invoice list.\\Do you want to open the posted invoice?';
      CanCancelApprovalForRecord@1002 : Boolean;
      ReadyToPostQst@1005 : TextConst '@@@=%1 - selected count, %2 - total count;DAN=%1 ud af %2 valgte fakturaer er klar til bogf›ring. \Vil du forts‘tte og bogf›re dem?;ENU=%1 out of %2 selected invoices are ready for post. \Do you want to continue and post them?';
      CanRequestApprovalForFlow@1007 : Boolean;
      CanCancelApprovalForFlow@1008 : Boolean;

    [Internal]
    PROCEDURE ShowPreview@1();
    VAR
      SalesPostYesNo@1001 : Codeunit 81;
    BEGIN
      SalesPostYesNo.Preview(Rec);
    END;

    LOCAL PROCEDURE SetControlAppearance@5();
    VAR
      ApprovalsMgmt@1002 : Codeunit 1535;
      WorkflowWebhookManagement@1000 : Codeunit 1543;
    BEGIN
      OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);

      CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RECORDID);

      WorkflowWebhookManagement.GetCanRequestAndCanCancel(RECORDID,CanRequestApprovalForFlow,CanCancelApprovalForFlow);
    END;

    LOCAL PROCEDURE Post@4(PostingCodeunitID@1000 : Integer);
    VAR
      PreAssignedNo@1001 : Code[20];
    BEGIN
      IF DummyApplicationAreaSetup.IsFoundationEnabled THEN BEGIN
        LinesInstructionMgt.SalesCheckAllLinesHaveQuantityAssigned(Rec);
        PreAssignedNo := "No.";
      END;

      SendToPosting(PostingCodeunitID);

      IF DummyApplicationAreaSetup.IsFoundationEnabled THEN
        ShowPostedConfirmationMessage(PreAssignedNo);
    END;

    LOCAL PROCEDURE ShowPostedConfirmationMessage@7(PreAssignedNo@1001 : Code[20]);
    VAR
      SalesInvoiceHeader@1000 : Record 112;
    BEGIN
      SalesInvoiceHeader.SETRANGE("Pre-Assigned No.",PreAssignedNo);
      IF SalesInvoiceHeader.FINDFIRST THEN
        IF CONFIRM(OpenPostedSalesInvQst,FALSE) THEN
          PAGE.RUN(PAGE::"Posted Sales Invoice",SalesInvoiceHeader);
    END;

    BEGIN
    END.
  }
}

