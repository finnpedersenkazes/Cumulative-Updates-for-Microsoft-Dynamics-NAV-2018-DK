OBJECT Page 9036 Bookkeeper Activities
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846,NAVDK11.00.00.19846;
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

    { 7   ;1   ;Group     ;
                CaptionML=[DAN=G‘ld;
                           ENU=Payables];
                GroupType=CueGroup;
                ActionList=ACTIONS
                {
                  { 11      ;0   ;Action    ;
                                  CaptionML=[DAN=Rediger udbetalingskladde;
                                             ENU=Edit Payment Journal];
                                  ToolTipML=[DAN=Betal dine kreditorer ved at udfylde betalingskladden automatisk i henhold til de forfaldne betalinger, og eksport‚r eventuelt alle betalinger til din bank til automatisk behandling.;
                                             ENU=Pay your vendors by filling the payment journal automatically according to payments due, and potentially export all payment to your bank for automatic processing.];
                                  ApplicationArea=#Basic,#Suite;
                                  RunObject=Page 256 }
                  { 12      ;0   ;Action    ;
                                  CaptionML=[DAN=Ny k›bskreditnota;
                                             ENU=New Purchase Credit Memo];
                                  ToolTipML=[DAN=Opret en ny k›bskreditnota, s† du kan administrere varer, der er returneret til en kreditor.;
                                             ENU=Create a new purchase credit memo so you can manage returned items to a vendor.];
                                  ApplicationArea=#Basic,#Suite;
                                  RunObject=Page 52;
                                  RunPageMode=Create }
                }
                 }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal k›bsfakturaer, hvor du er forsinket med betalingen.;
                           ENU=Specifies the number of purchase invoices where you are late with payment.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Purchase Documents Due Today";
                DrillDownPageID=Vendor Ledger Entries }

    { 1   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† kreditorer, hvortil din betaling afventer.;
                           ENU=Specifies the number of vendor to whom your payment is on hold.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Vendors - Payment on Hold";
                DrillDownPageID=Vendor List }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† godkendte k›bsordrer.;
                           ENU=Specifies the number of approved purchase orders.];
                ApplicationArea=#Advanced;
                SourceExpr="Approved Purchase Orders";
                DrillDownPageID=Purchase Order List }

    { 8   ;1   ;Group     ;
                CaptionML=[DAN=Tilgodehavender;
                           ENU=Receivables];
                GroupType=CueGroup;
                ActionList=ACTIONS
                {
                  { 20      ;0   ;Action    ;
                                  CaptionML=[DAN=Rediger indbetalingskladde;
                                             ENU=Edit Cash Receipt Journal];
                                  ToolTipML=[DAN=Registrer modtagne betalinger i en indbetalingskladde, der muligvis allerede indeholder kladdelinjerne.;
                                             ENU=Register received payments in a cash receipt journal that may already contain journal lines.];
                                  ApplicationArea=#Basic,#Suite;
                                  RunObject=Page 255 }
                  { 21      ;0   ;Action    ;
                                  CaptionML=[DAN=Ny salgskreditnota;
                                             ENU=New Sales Credit Memo];
                                  ToolTipML=[DAN=Behandl en returnering eller refusion ved at oprette en ny salgskreditnota.;
                                             ENU=Process a return or refund by creating a new sales credit memo.];
                                  ApplicationArea=#Basic,#Suite;
                                  RunObject=Page 44;
                                  RunPageMode=Create }
                  { 1060000 ;0   ;Action    ;
                                  CaptionML=[DAN=Opret elektronisk faktura;
                                             ENU=Create Electronic Invoice];
                                  ToolTipML=[DAN=Opret en elektronisk version af det aktuelle dokument.;
                                             ENU=Create an electronic version of the current document.];
                                  ApplicationArea=#Basic,#Suite;
                                  RunObject=Report 13600;
                                  Image=ElectronicDoc }
                  { 1060001 ;0   ;Action    ;
                                  CaptionML=[DAN=Opret elektronisk kreditnota;
                                             ENU=Create Electronic Credit Memo];
                                  ToolTipML=[DAN=Opret en elektronisk version af det aktuelle dokument.;
                                             ENU=Create an electronic version of the current document.];
                                  ApplicationArea=#Basic,#Suite;
                                  RunObject=Report 13601;
                                  Image=ElectronicDoc }
                }
                 }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal salgsordrer, der har udest†ende godkendelser.;
                           ENU=Specifies the number of sales orders that are pending approval.];
                ApplicationArea=#Suite;
                SourceExpr="SOs Pending Approval";
                DrillDownPageID=Sales Order List }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal salgsfakturaer, hvor debitoren er forsinket med betalingen.;
                           ENU=Specifies the number of sales invoices where the customer is late with payment.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Overdue Sales Documents";
                DrillDownPageID=Customer Ledger Entries }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† godkendte salgsordrer.;
                           ENU=Specifies the number of approved sales orders.];
                ApplicationArea=#Suite;
                SourceExpr="Approved Sales Orders";
                DrillDownPageID=Sales Order List }

    { 2   ;1   ;Group     ;
                CaptionML=[DAN=Godkendelser;
                           ENU=Approvals];
                GroupType=CueGroup }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver anmodninger om bestemte dokumenter, kort eller kladdelinjer, som din godkender skal godkende, f›r du kan forts‘tte.;
                           ENU=Specifies requests for certain documents, cards, or journal lines that your approver must approve before you can proceed.];
                ApplicationArea=#Suite;
                SourceExpr="Requests Sent for Approval";
                DrillDownPageID=Approval Entries }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver anmodninger om bestemte dokumenter, kort eller kladdelinjer, som du skal godkende for andre brugere, f›r de kan forts‘tte.;
                           ENU=Specifies requests for certain documents, cards, or journal lines that you must approve for other users before they can proceed.];
                ApplicationArea=#Suite;
                SourceExpr="Requests to Approve";
                DrillDownPageID=Requests to Approve }

    { 10  ;1   ;Group     ;
                CaptionML=[DAN=Likviditetsstyring;
                           ENU=Cash Management];
                GroupType=CueGroup;
                ActionList=ACTIONS
                {
                  { 16      ;    ;Action    ;
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

    { 6   ;2   ;Field     ;
                CaptionML=[DAN=Betalingsudligningskladder;
                           ENU=Payment Reconciliation Journals];
                ToolTipML=[DAN=Angiver et tidsrum for afstemning af ubetalte bilag automatisk med deres relaterede banktransaktioner ved at importere et bankkontoudtog eller en fil. I betalingsudligningskladden udlignes indg†ende eller udg†ende betalinger for din bank automatisk eller delvist automatisk med deres relaterede †bne debitor- eller kreditorposter. Alle †bne bankkontoposter i forhold til de udlignede debitor- eller kreditorposter bliver lukket, n†r du v‘lger handlingen Bogf›r betalinger og Afstem bankkontoen. Det betyder, at bankkontoen automatisk afstemmes for de betalinger, som du bogf›rer med kladden.;
                           ENU=Specifies a window to reconcile unpaid documents automatically with their related bank transactions by importing a bank statement feed or file. In the payment reconciliation journal, incoming or outgoing payments on your bank are automatically, or semi-automatically, applied to their related open customer or vendor ledger entries. Any open bank account ledger entries related to the applied customer or vendor ledger entries will be closed when you choose the Post Payments and Reconcile Bank Account action. This means that the bank account is automatically reconciled for payments that you post with the journal.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Non-Applied Payments";
                DrillDownPageID=Pmt. Reconciliation Journals;
                Image=Cash }

    { 18  ;1   ;Group     ;
                CaptionML=[DAN=Mine brugeropgaver;
                           ENU=My User Tasks];
                GroupType=CueGroup }

    { 17  ;2   ;Field     ;
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

