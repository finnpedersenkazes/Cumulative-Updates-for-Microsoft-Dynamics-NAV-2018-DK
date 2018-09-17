OBJECT Page 9037 Accountant Activities
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
    OnInit=VAR
             PermissionManager@1000 : Codeunit 9002;
           BEGIN
             ReplayGettingStartedVisible := FALSE;
             IF PermissionManager.SoftwareAsAService THEN
               ReplayGettingStartedVisible := TRUE;
           END;

    OnOpenPage=VAR
                 RoleCenterNotificationMgt@1000 : Codeunit 1430;
               BEGIN
                 RESET;
                 IF NOT GET THEN BEGIN
                   INIT;
                   INSERT;
                 END;

                 SETFILTER("Due Date Filter",'<=%1',WORKDATE);
                 SETFILTER("Overdue Date Filter",'<%1',WORKDATE);
                 SETFILTER("Due Next Week Filter",'%1..%2',CALCDATE('<1D>',WORKDATE),CALCDATE('<1W>',WORKDATE));
                 SETRANGE("User ID Filter",USERID);

                 ShowProductVideosActivities := TRUE;

                 RoleCenterNotificationMgt.ShowNotifications;

                 IF PageNotifier.IsAvailable THEN BEGIN
                   PageNotifier := PageNotifier.Create;
                   PageNotifier.NotifyPageReady;
                 END;
               END;

    OnAfterGetRecord=BEGIN
                       CalculateCueFieldValues;
                       SetActivityGroupVisibility;
                     END;

    OnAfterGetCurrRecord=VAR
                           RoleCenterNotificationMgt@1000 : Codeunit 1430;
                           PermissionManager@1001 : Codeunit 9002;
                         BEGIN
                           ReplayGettingStartedVisible := FALSE;
                           IF PermissionManager.SoftwareAsAService THEN
                             ReplayGettingStartedVisible := TRUE;
                           RoleCenterNotificationMgt.HideEvaluationNotificationAfterStartingTrial;
                         END;

    ActionList=ACTIONS
    {
      { 22      ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 24      ;1   ;Action    ;
                      Name=Set Up Cues;
                      CaptionML=[DAN=Konfigurer kõindikatorer;
                                 ENU=Set Up Cues];
                      ToolTipML=[DAN=Konfigurer kõindikatorer (statusfliser) relateret til rollen.;
                                 ENU=Set up the cues (status tiles) related to the role.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Setup;
                      OnAction=VAR
                                 CueSetup@1001 : Codeunit 9701;
                                 CueRecordRef@1000 : RecordRef;
                               BEGIN
                                 CueRecordRef.GETTABLE(Rec);
                                 CueSetup.OpenCustomizePageForCurrentUser(CueRecordRef.NUMBER);
                               END;
                                }
    }
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
                                  ToolTipML=[DAN=Betal dine kreditorer ved at udfylde betalingskladden automatisk i henhold til de forfaldne betalinger, og eksportÇr eventuelt alle betalinger til din bank til automatisk behandling.;
                                             ENU=Pay your vendors by filling the payment journal automatically according to payments due, and potentially export all payment to your bank for automatic processing.];
                                  ApplicationArea=#Basic,#Suite;
                                  RunObject=Page 256 }
                  { 5       ;0   ;Action    ;
                                  CaptionML=[DAN=Ny kõbskreditnota;
                                             ENU=New Purchase Credit Memo];
                                  ToolTipML=[DAN=Opret en ny kõbskreditnota, sÜ du kan administrere varer, der er returneret til en kreditor.;
                                             ENU=Create a new purchase credit memo so you can manage returned items to a vendor.];
                                  ApplicationArea=#Basic,#Suite;
                                  RunObject=Page 52;
                                  RunPageMode=Create }
                }
                 }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal kõbsfakturaer, hvor din betaling er forsinket.;
                           ENU=Specifies the number of purchase invoices where your payment is late.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Overdue Purchase Documents";
                DrillDownPageID=Vendor Ledger Entries }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ de kõbsfakturaer, som forfalder til betaling i dag.;
                           ENU=Specifies the number of purchase invoices that are due for payment today.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Purchase Documents Due Today";
                DrillDownPageID=Vendor Ledger Entries }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af betalinger til kreditorer, der forfalder i nëste uge.;
                           ENU=Specifies the number of payments to vendors that are due next week.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Purch. Invoices Due Next Week" }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af kõbsrabatter, der er tilgëngelige i nëste uge, f.eks. fordi rabatten udlõber efter nëste uge.;
                           ENU=Specifies the number of purchase discounts that are available next week, for example, because the discount expires after next week.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Purchase Discounts Next Week" }

    { 19  ;1   ;Group     ;
                CaptionML=[DAN=Dokumentgodkendelser;
                           ENU=Document Approvals];
                GroupType=CueGroup;
                ActionList=ACTIONS
                {
                  { 25      ;0   ;Action    ;
                                  CaptionML=[DAN=Opret rykkere...;
                                             ENU=Create Reminders...];
                                  ToolTipML=[DAN=PÜmind dine debitorer om sene betalinger.;
                                             ENU=Remind your customers of late payments.];
                                  ApplicationArea=#Advanced;
                                  RunObject=Report 188;
                                  Image=CreateReminders }
                  { 26      ;0   ;Action    ;
                                  CaptionML=[DAN=Opret rentenotaer...;
                                             ENU=Create Finance Charge Memos...];
                                  ToolTipML=[DAN=Udsted rentenotaer til dine debitorer som fõlge af sen betaling.;
                                             ENU=Issue finance charge memos to your customers as a consequence of late payment.];
                                  ApplicationArea=#Advanced;
                                  RunObject=Report 191;
                                  Image=CreateFinanceChargememo }
                }
                 }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal kõbsordrer, der har udestÜende godkendelser.;
                           ENU=Specifies the number of purchase orders that are pending approval.];
                ApplicationArea=#Suite;
                SourceExpr="POs Pending Approval";
                DrillDownPageID=Purchase Order List }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal salgsordrer, der har udestÜende godkendelser.;
                           ENU=Specifies the number of sales orders that are pending approval.];
                ApplicationArea=#Suite;
                SourceExpr="SOs Pending Approval";
                DrillDownPageID=Sales Order List }

    { 14  ;1   ;Group     ;
                CaptionML=[DAN=Finansielle oplysninger;
                           ENU=Financials];
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

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver summen af de konti, som har en kategori for kassekonto.;
                           ENU=Specifies the sum of the accounts that have the cash account category.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Cash Accounts Balance";
                DrillDownPageID=Chart of Accounts;
                OnDrillDown=VAR
                              ActivitiesMgt@1000 : Codeunit 1311;
                            BEGIN
                              ActivitiesMgt.DrillDownCalcCashAccountsBalances;
                            END;

                Image=Cash }

    { 11  ;2   ;Field     ;
                CaptionML=[DAN=Betalingsudligningskladder;
                           ENU=Payment Reconciliation Journals];
                ToolTipML=[DAN=Angiver et tidsrum for afstemning af ubetalte bilag automatisk med deres relaterede banktransaktioner ved at importere et bankkontoudtog eller en fil. I betalingsudligningskladden udlignes indgÜende eller udgÜende betalinger for din bank automatisk eller delvist automatisk med deres relaterede Übne debitor- eller kreditorposter. Alle Übne bankkontoposter i forhold til de udlignede debitor- eller kreditorposter bliver lukket, nÜr du vëlger handlingen Bogfõr betalinger og Afstem bankkontoen. Det betyder, at bankkontoen automatisk afstemmes for de betalinger, som du bogfõrer med kladden.;
                           ENU=Specifies a window to reconcile unpaid documents automatically with their related bank transactions by importing a bank statement feed or file. In the payment reconciliation journal, incoming or outgoing payments on your bank are automatically, or semi-automatically, applied to their related open customer or vendor ledger entries. Any open bank account ledger entries related to the applied customer or vendor ledger entries will be closed when you choose the Post Payments and Reconcile Bank Account action. This means that the bank account is automatically reconciled for payments that you post with the journal.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Non-Applied Payments";
                DrillDownPageID=Pmt. Reconciliation Journals;
                Image=Cash }

    { 2   ;1   ;Group     ;
                CaptionML=[DAN=IndgÜende bilag;
                           ENU=Incoming Documents];
                GroupType=CueGroup;
                ActionList=ACTIONS
                {
                  { 12      ;    ;Action    ;
                                  Name=CheckForOCR;
                                  CaptionML=[DAN=Modtag fra OCR-tjeneste;
                                             ENU=Receive from OCR Service];
                                  ToolTipML=[DAN=Behandl nye indkommende elektroniske dokumenter, som er oprettet med OCR-tjenesten, og som du kan konvertere til f.eks. kõbsfakturaer i Dynamics NAV.;
                                             ENU=Process new incoming electronic documents that have been created by the OCR service and that you can convert to, for example, purchase invoices in Dynamics NAV.];
                                  ApplicationArea=#Basic,#Suite;
                                  RunObject=Codeunit 881;
                                  RunPageMode=View }
                }
                 }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af nye indgÜende bilag i virksomheden. Bilagene filtreres efter dags dato.;
                           ENU=Specifies the number of new incoming documents in the company. The documents are filtered by today's date.];
                ApplicationArea=#Advanced;
                SourceExpr="New Incoming Documents";
                DrillDownPageID=Incoming Documents }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af nye godkendte indgÜende bilag i virksomheden. Bilagene filtreres efter dags dato.;
                           ENU=Specifies the number of approved incoming documents in the company. The documents are filtered by today's date.];
                ApplicationArea=#Advanced;
                SourceExpr="Approved Incoming Documents";
                DrillDownPageID=Incoming Documents }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver indgÜende bilagsrecords, som er oprettet af OCR-tjenesten.;
                           ENU=Specifies that incoming document records that have been created by the OCR service.];
                ApplicationArea=#Advanced;
                SourceExpr="OCR Completed";
                DrillDownPageID=Incoming Documents }

    { 35  ;1   ;Group     ;
                CaptionML=[DAN=Mine brugeropgaver;
                           ENU=My User Tasks];
                GroupType=CueGroup }

    { 34  ;2   ;Field     ;
                CaptionML=[DAN=Ventende brugeropgaver;
                           ENU=Pending User Tasks];
                ToolTipML=[DAN=Angiver det antal ventende opgaver, som du er blevet tildelt.;
                           ENU=Specifies the number of pending tasks that are assigned to you.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pending Tasks";
                DrillDownPageID=User Task List;
                Image=Checklist }

    { 18  ;1   ;Group     ;
                CaptionML=[DAN=Nye kladdeposter;
                           ENU=New Journal Entries];
                GroupType=CueGroup;
                ActionList=ACTIONS
                {
                  { 21      ;    ;Action    ;
                                  CaptionML=[DAN=Ny finanskladdepost;
                                             ENU=New G/L Journal Entry];
                                  ToolTipML=[DAN=Vër klar til at bogfõre enhver transaktion pÜ virksomhedens konti.;
                                             ENU=Prepare to post any transaction to the company books.];
                                  ApplicationArea=#Basic,#Suite;
                                  RunObject=Page 39;
                                  Image=TileNew }
                  { 28      ;    ;Action    ;
                                  CaptionML=[DAN=Ny betalingskladdepost;
                                             ENU=New Payment Journal Entry];
                                  ToolTipML=[DAN=Betal dine kreditorer ved at udfylde betalingskladden automatisk i henhold til de forfaldne betalinger, og eksportÇr eventuelt alle betalinger til din bank til automatisk behandling.;
                                             ENU=Pay your vendors by filling the payment journal automatically according to payments due, and potentially export all payment to your bank for automatic processing.];
                                  ApplicationArea=#Basic,#Suite;
                                  RunObject=Page 256;
                                  Image=TileNew }
                }
                 }

    { 33  ;1   ;Group     ;
                CaptionML=[DAN=Produktvideoer;
                           ENU=Product Videos];
                Visible=ShowProductVideosActivities;
                GroupType=CueGroup;
                ActionList=ACTIONS
                {
                  { 32      ;    ;Action    ;
                                  CaptionML=[DAN=Produktvideoer;
                                             ENU=Product Videos];
                                  ToolTipML=[DAN=èbn en liste med videoer, der viser nogle af produktegenskaberne.;
                                             ENU=Open a list of videos that showcase some of the product capabilities.];
                                  ApplicationArea=#Basic,#Suite;
                                  RunObject=Page 1470;
                                  Image=TileVideo }
                }
                 }

    { 31  ;1   ;Group     ;
                CaptionML=[DAN=Kom i gang;
                           ENU=Get started];
                Visible=ReplayGettingStartedVisible;
                GroupType=CueGroup;
                ActionList=ACTIONS
                {
                  { 27      ;    ;Action    ;
                                  Name=ShowStartInMyCompany;
                                  CaptionML=[DAN=Prõv med dine egne data;
                                             ENU=Try with my own data];
                                  ToolTipML=[DAN=Konfigurer virksomheden med de indstillinger, du õnsker. Vi viser dig hvordan - det er nemt.;
                                             ENU=Set up My Company with the settings you choose. We'll show you how, it's easy.];
                                  ApplicationArea=#Basic,#Suite;
                                  Visible=FALSE;
                                  Image=TileSettings;
                                  OnAction=BEGIN
                                             IF UserTours.IsAvailable AND O365GettingStartedMgt.AreUserToursEnabled THEN
                                               UserTours.StartUserTour(O365GettingStartedMgt.GetChangeCompanyTourID);
                                           END;
                                            }
                  { 30      ;    ;Action    ;
                                  Name=ReplayGettingStarted;
                                  CaptionML=[DAN=Afspil introduktion;
                                             ENU=Play Getting Started];
                                  ToolTipML=[DAN=Vis introduktionsvejledningen igen.;
                                             ENU=Show the Getting Started guide again.];
                                  ApplicationArea=#Basic,#Suite;
                                  Image=TileVideo;
                                  OnAction=VAR
                                             O365GettingStarted@1000 : Record 1309;
                                           BEGIN
                                             IF O365GettingStarted.GET(USERID,ClientTypeManagement.GetCurrentClientType) THEN BEGIN
                                               O365GettingStarted."Tour in Progress" := FALSE;
                                               O365GettingStarted."Current Page" := 1;
                                               O365GettingStarted.MODIFY;
                                               COMMIT;
                                             END;

                                             O365GettingStartedMgt.LaunchWizard(TRUE,FALSE);
                                           END;
                                            }
                }
                 }

  }
  CODE
  {
    VAR
      O365GettingStartedMgt@1002 : Codeunit 1309;
      ClientTypeManagement@1077 : Codeunit 4;
      PageNotifier@1000 : DotNet "'Microsoft.Dynamics.Nav.ClientExtensions, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.PageNotifier" WITHEVENTS RUNONCLIENT;
      UserTours@1003 : DotNet "'Microsoft.Dynamics.Nav.ClientExtensions, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.Capabilities.UserTours" WITHEVENTS RUNONCLIENT;
      ShowProductVideosActivities@1005 : Boolean;
      HideNpsDialog@1006 : Boolean;
      ReplayGettingStartedVisible@1001 : Boolean;
      WhatIsNewTourVisible@1007 : Boolean;

    LOCAL PROCEDURE CalculateCueFieldValues@1();
    VAR
      ActivitiesMgt@1000 : Codeunit 1311;
    BEGIN
      IF FIELDACTIVE("Cash Accounts Balance") THEN
        "Cash Accounts Balance" := ActivitiesMgt.CalcCashAccountsBalances;
    END;

    LOCAL PROCEDURE SetActivityGroupVisibility@12();
    VAR
      ProductVideosActivitiesMgt@1000 : Codeunit 1345;
    BEGIN
      ShowProductVideosActivities := ProductVideosActivitiesMgt.IsActivitiesVisible;
    END;

    LOCAL PROCEDURE StartWhatIsNewTour@45(hasTourCompleted@1000 : Boolean);
    VAR
      O365UserTours@1001 : Record 1314;
      TourID@1003 : Integer;
    BEGIN
      TourID := O365GettingStartedMgt.GetWhatIsNewTourID;

      IF O365UserTours.AlreadyCompleted(TourID) THEN
        EXIT;

      IF NOT hasTourCompleted THEN BEGIN
        UserTours.StartUserTour(TourID);
        WhatIsNewTourVisible := TRUE;
        EXIT;
      END;

      IF WhatIsNewTourVisible THEN BEGIN
        O365UserTours.MarkAsCompleted(TourID);
        WhatIsNewTourVisible := FALSE;
      END;
    END;

    EVENT PageNotifier@1000::PageReady@9();
    VAR
      NetPromoterScoreMgt@1000 : Codeunit 1432;
    BEGIN
      NetPromoterScoreMgt.ShowNpsDialog;
    END;

    EVENT UserTours@1003::ShowTourWizard@15(hasTourCompleted@1000 : Boolean);
    VAR
      NetPromoterScoreMgt@1001 : Codeunit 1432;
    BEGIN
      IF O365GettingStartedMgt.IsGettingStartedSupported THEN
        IF O365GettingStartedMgt.LaunchWizard(FALSE,hasTourCompleted) THEN
          EXIT;

      IF (NOT hasTourCompleted) AND (NOT HideNpsDialog) THEN
        IF NetPromoterScoreMgt.ShowNpsDialog THEN BEGIN
          HideNpsDialog := TRUE;
          EXIT;
        END;

      StartWhatIsNewTour(hasTourCompleted);
    END;

    EVENT UserTours@1003::IsTourInProgressResultReady@16(isInProgress@1000 : Boolean);
    BEGIN
    END;

    BEGIN
    END.
  }
}

