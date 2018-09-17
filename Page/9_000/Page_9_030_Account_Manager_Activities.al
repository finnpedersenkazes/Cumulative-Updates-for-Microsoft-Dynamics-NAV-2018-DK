OBJECT Page 9030 Account Manager Activities
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Aktiviteter;
               ENU=Activities];
    SourceTable=Table9054;
    PageType=CardPart;
    RefreshOnActivate=Yes;
    OnOpenPage=BEGIN
                 RESET;
                 IF NOT GET THEN BEGIN
                   INIT;
                   INSERT;
                 END;

                 SETFILTER("Due Date Filter",'<=%1',WORKDATE);
                 SETFILTER("Overdue Date Filter",'<%1',WORKDATE);
                 SETFILTER("User ID Filter",USERID);
               END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 6   ;1   ;Group     ;
                CaptionML=[DAN=Betalinger;
                           ENU=Payments];
                GroupType=CueGroup;
                ActionList=ACTIONS
                {
                  { 1       ;0   ;Action    ;
                                  CaptionML=[DAN=Rediger indbetalingskladde;
                                             ENU=Edit Cash Receipt Journal];
                                  ToolTipML=[DAN=Registrer modtagne betalinger i en indbetalingskladde, der muligvis allerede indeholder kladdelinjerne.;
                                             ENU=Register received payments in a cash receipt journal that may already contain journal lines.];
                                  ApplicationArea=#Basic,#Suite;
                                  RunObject=Page 255 }
                  { 3       ;0   ;Action    ;
                                  CaptionML=[DAN=Ny salgskreditnota;
                                             ENU=New Sales Credit Memo];
                                  ToolTipML=[DAN=Behandl en returnering eller refusion ved at oprette en ny salgskreditnota.;
                                             ENU=Process a return or refund by creating a new sales credit memo.];
                                  ApplicationArea=#Basic,#Suite;
                                  RunObject=Page 44;
                                  RunPageMode=Create }
                  { 4       ;0   ;Action    ;
                                  CaptionML=[DAN=Rediger udbetalingskladde;
                                             ENU=Edit Payment Journal];
                                  ToolTipML=[DAN=Betal dine kreditorer ved at udfylde betalingskladden automatisk i henhold til de forfaldne betalinger, og eksport‚r eventuelt alle betalinger til din bank til automatisk behandling.;
                                             ENU=Pay your vendors by filling the payment journal automatically according to payments due, and potentially export all payment to your bank for automatic processing.];
                                  ApplicationArea=#Basic,#Suite;
                                  RunObject=Page 256 }
                  { 5       ;0   ;Action    ;
                                  CaptionML=[DAN=Ny k›bskreditnota;
                                             ENU=New Purchase Credit Memo];
                                  ToolTipML=[DAN=Angiver en ny k›bskreditnota, s† du kan administrere varer, der er returneret til en kreditor.;
                                             ENU=Specifies a new purchase credit memo so you can manage returned items to a vendor.];
                                  ApplicationArea=#Basic,#Suite;
                                  RunObject=Page 52;
                                  RunPageMode=Create }
                }
                 }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal fakturaer, hvor debitoren er forsinket med betalingen.;
                           ENU=Specifies the number of invoices where the customer is late with payment.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Overdue Sales Documents";
                DrillDownPageID=Customer Ledger Entries }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal k›bsfakturaer, hvor du er forsinket med betalingen.;
                           ENU=Specifies the number of purchase invoices where you are late with payment.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Purchase Documents Due Today";
                DrillDownPageID=Vendor Ledger Entries }

    { 19  ;1   ;Group     ;
                CaptionML=[DAN=Dokumentgodkendelser;
                           ENU=Document Approvals];
                GroupType=CueGroup;
                ActionList=ACTIONS
                {
                  { 25      ;0   ;Action    ;
                                  CaptionML=[DAN=Opret rykkere...;
                                             ENU=Create Reminders...];
                                  ToolTipML=[DAN=P†mind dine debitorer om sene betalinger.;
                                             ENU=Remind your customers of late payments.];
                                  ApplicationArea=#Advanced;
                                  RunObject=Report 188;
                                  Image=CreateReminders }
                  { 26      ;0   ;Action    ;
                                  CaptionML=[DAN=Opret rentenotaer...;
                                             ENU=Create Finance Charge Memos...];
                                  ToolTipML=[DAN=Udsted rentenotaer til dine debitorer som f›lge af sen betaling.;
                                             ENU=Issue finance charge memos to your customers as a consequence of late payment.];
                                  ApplicationArea=#Advanced;
                                  RunObject=Report 191;
                                  Image=CreateFinanceChargememo }
                }
                 }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal k›bsordrer, der har udest†ende godkendelser.;
                           ENU=Specifies the number of purchase orders that are pending approval.];
                ApplicationArea=#Suite;
                SourceExpr="POs Pending Approval";
                DrillDownPageID=Purchase Order List }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal salgsordrer, der har udest†ende godkendelser.;
                           ENU=Specifies the number of sales orders that are pending approval.];
                ApplicationArea=#Suite;
                SourceExpr="SOs Pending Approval";
                DrillDownPageID=Sales Order List }

    { 14  ;1   ;Group     ;
                CaptionML=[DAN=Likviditetsstyring;
                           ENU=Cash Management];
                GroupType=CueGroup;
                ActionList=ACTIONS
                {
                  { 15      ;    ;Action    ;
                                  CaptionML=[DAN=Ny betalingsudligningskladde;
                                             ENU=New Payment Reconciliation Journal];
                                  ToolTipML=[DAN=Afstem automatisk ubetalte dokumenter med deres relaterede banktransaktioner ved at importere et feed eller en fil med kontoudtog.;
                                             ENU=Reconcile unpaid documents automatically with their related bank transactions by importing bank a bank statement feed or file.];
                                  ApplicationArea=#Basic,#Suite;
                                  OnAction=VAR
                                             BankAccReconciliation@1000 : Record 273;
                                           BEGIN
                                             BankAccReconciliation.OpenNewWorksheet
                                           END;
                                            }
                }
                 }

    { 11  ;2   ;Field     ;
                CaptionML=[DAN=Betalingsudligningskladder;
                           ENU=Payment Reconciliation Journals];
                ToolTipML=[DAN=Angiver et tidsrum for afstemning af ubetalte bilag automatisk med deres relaterede banktransaktioner ved at importere et bankkontoudtog eller en fil. I betalingsudligningskladden udlignes indg†ende eller udg†ende betalinger for din bank automatisk eller delvist automatisk med deres relaterede †bne debitor- eller kreditorposter. Alle †bne bankkontoposter i forhold til de udlignede debitor- eller kreditorposter bliver lukket, n†r du v‘lger handlingen Bogf›r betalinger og Afstem bankkontoen. Det betyder, at bankkontoen automatisk afstemmes for de betalinger, som du bogf›rer med kladden.;
                           ENU=Specifies a window to reconcile unpaid documents automatically with their related bank transactions by importing a bank statement feed or file. In the payment reconciliation journal, incoming or outgoing payments on your bank are automatically, or semi-automatically, applied to their related open customer or vendor ledger entries. Any open bank account ledger entries related to the applied customer or vendor ledger entries will be closed when you choose the Post Payments and Reconcile Bank Account action. This means that the bank account is automatically reconciled for payments that you post with the journal.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Non-Applied Payments";
                DrillDownPageID=Pmt. Reconciliation Journals;
                Image=Cash }

    { 2   ;1   ;Group     ;
                CaptionML=[DAN=Indg†ende bilag;
                           ENU=Incoming Documents];
                GroupType=CueGroup;
                ActionList=ACTIONS
                {
                  { 12      ;    ;Action    ;
                                  Name=CheckForOCR;
                                  CaptionML=[DAN=Modtag fra OCR-tjeneste;
                                             ENU=Receive from OCR Service];
                                  ToolTipML=[DAN=Behandl nye indkommende elektroniske dokumenter, som er oprettet med OCR-tjenesten, og som du kan konvertere til f.eks. k›bsfakturaer.;
                                             ENU=Process new incoming electronic documents that have been created by the OCR service and that you can convert to, for example, purchase invoices.];
                                  ApplicationArea=#Basic,#Suite;
                                  RunObject=Codeunit 881;
                                  RunPageMode=View }
                }
                 }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af nye indg†ende bilag i virksomheden. Bilagene filtreres efter dags dato.;
                           ENU=Specifies the number of new incoming documents in the company. The documents are filtered by today's date.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="New Incoming Documents";
                DrillDownPageID=Incoming Documents }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af nye godkendte indg†ende bilag i virksomheden. Bilagene filtreres efter dags dato.;
                           ENU=Specifies the number of approved incoming documents in the company. The documents are filtered by today's date.];
                ApplicationArea=#Suite;
                SourceExpr="Approved Incoming Documents";
                DrillDownPageID=Incoming Documents }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver indg†ende bilagsrecords, som er oprettet af OCR-tjenesten.;
                           ENU=Specifies that incoming document records that have been created by the OCR service.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="OCR Completed";
                DrillDownPageID=Incoming Documents }

    { 17  ;1   ;Group     ;
                CaptionML=[DAN=Mine brugeropgaver;
                           ENU=My User Tasks];
                GroupType=CueGroup }

    { 16  ;2   ;Field     ;
                CaptionML=[DAN=Ventende brugeropgaver;
                           ENU=Pending User Tasks];
                ToolTipML=[DAN=Angiver det antal ventende opgaver, som du er blevet tildelt.;
                           ENU=Specifies the number of pending tasks that are assigned to you.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pending Tasks";
                DrillDownPageID=User Task List;
                Image=Checklist }

  }
  CODE
  {

    BEGIN
    END.
  }
}

