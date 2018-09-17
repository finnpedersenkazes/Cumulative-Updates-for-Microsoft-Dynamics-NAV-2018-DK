OBJECT Page 1310 O365 Activities
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
    SourceTable=Table1313;
    PageType=CardPart;
    RefreshOnActivate=Yes;
    ShowFilter=No;
    OnInit=BEGIN
             IF UserTours.IsAvailable AND O365GettingStartedMgt.AreUserToursEnabled THEN
               O365GettingStartedMgt.UpdateGettingStartedVisible(TileGettingStartedVisible,ReplayGettingStartedVisible);
           END;

    OnOpenPage=VAR
                 BookingSync@1002 : Record 6702;
                 OCRServiceMgt@1000 : Codeunit 1294;
                 RoleCenterNotificationMgt@1001 : Codeunit 1430;
               BEGIN
                 RESET;
                 IF NOT GET THEN BEGIN
                   INIT;
                   INSERT;
                   COMMIT;
                 END;
                 SETFILTER("Due Date Filter",'>=%1',WORKDATE);
                 SETFILTER("Overdue Date Filter",'<%1',WORKDATE);
                 SETFILTER("Due Next Week Filter",'%1..%2',CALCDATE('<1D>',WORKDATE),CALCDATE('<1W>',WORKDATE));
                 SETRANGE("User ID Filter",USERID);

                 HasCamera := CameraProvider.IsAvailable;
                 IF HasCamera THEN
                   CameraProvider := CameraProvider.Create;

                 PrepareOnLoadDialog;

                 ShowBookings := BookingSync.IsSetup;
                 ShowCamera := TRUE;
                 ShowStartActivities := TRUE;
                 ShowSalesActivities := TRUE;
                 ShowPurchasesActivities := TRUE;
                 ShowPaymentsActivities := TRUE;
                 ShowIncomingDocuments := TRUE;
                 ShowProductVideosActivities := TRUE;
                 ShowAwaitingIncomingDoc := OCRServiceMgt.OcrServiceIsEnable;
                 ShowIntercompanyActivities := TRUE;

                 RoleCenterNotificationMgt.ShowNotifications;
               END;

    OnAfterGetRecord=VAR
                       DocExchServiceSetup@1000 : Record 1275;
                     BEGIN
                       CalculateCueFieldValues;
                       ShowDocumentsPendingDocExchService := FALSE;
                       IF DocExchServiceSetup.GET THEN
                         ShowDocumentsPendingDocExchService := DocExchServiceSetup.Enabled;
                       SetActivityGroupVisibility;
                     END;

    OnAfterGetCurrRecord=VAR
                           RoleCenterNotificationMgt@1000 : Codeunit 1430;
                         BEGIN
                           IF UserTours.IsAvailable AND O365GettingStartedMgt.AreUserToursEnabled THEN
                             O365GettingStartedMgt.UpdateGettingStartedVisible(TileGettingStartedVisible,ReplayGettingStartedVisible);
                           RoleCenterNotificationMgt.HideEvaluationNotificationAfterStartingTrial;
                         END;

    ActionList=ACTIONS
    {
      { 6       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 7       ;1   ;Action    ;
                      Name=Set Up Cues;
                      CaptionML=[DAN=Konfigurer kõindikatorer;
                                 ENU=Set Up Cues];
                      ToolTipML=[DAN=Konfigurer kõindikatorer (statusfliser) relateret til rollen.;
                                 ENU=Set up the cues (status tiles) related to the role.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Setup;
                      OnAction=VAR
                                 CueRecordRef@1000 : RecordRef;
                               BEGIN
                                 CueRecordRef.GETTABLE(Rec);
                                 CueSetup.OpenCustomizePageForCurrentUser(CueRecordRef.NUMBER);
                               END;
                                }
      { 36      ;1   ;ActionGroup;
                      Name=Show/Hide Activities;
                      CaptionML=[DAN=Vis/skjul aktiviteter;
                                 ENU=Show/Hide Activities];
                      Image=Answers }
      { 37      ;2   ;Action    ;
                      Name=[Sales ];
                      CaptionML=[DAN=Salg;
                                 ENU=Sales];
                      ToolTipML=[DAN=FÜ vist oversigten over igangvërende salgsordrer.;
                                 ENU=View the list of ongoing sales orders.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 1329;
                      Image=Sales }
      { 38      ;2   ;Action    ;
                      Name=Purchases;
                      CaptionML=[DAN=Kõb;
                                 ENU=Purchases];
                      ToolTipML=[DAN=FÜ vist oversigten over igangvërende kõbsordrer.;
                                 ENU=View the list of ongoing purchase orders.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 1331;
                      Image=Purchase }
      { 39      ;2   ;Action    ;
                      Name=Payments;
                      CaptionML=[DAN=Betalinger;
                                 ENU=Payments];
                      ToolTipML=[DAN=Angiver det belõb, der vedrõrer betalingerne.;
                                 ENU=Specifies the amount that relates to payments.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 1332;
                      Image=Payment }
      { 41      ;2   ;Action    ;
                      Name=Incoming Documents;
                      CaptionML=[DAN=IndgÜende bilag;
                                 ENU=Incoming Documents];
                      ToolTipML=[DAN=Vis oversigten over indgÜende bilag, f.eks. kreditorfakturaer i PDF- eller billedfiler, som kan bruges til manuel eller automatisk oprettelse af bilagsrecords, f.eks. kõbsfakturaer. De eksterne filer, der reprësenterer indgÜende bilag, kan knyttes til ethvert procestrin, herunder bogfõrte bilag og de resulterende kreditor-, debitor- og finansposter.;
                                 ENU=View the list of incoming documents, such as vendor invoices in PDF or as image files, that you can manually or automatically create document records, such as purchase invoices. The external files that represent incoming documents can be attached at any process stage, including to posted documents and to the resulting vendor, customer, and general ledger entries.];
                      ApplicationArea=#Suite;
                      RunObject=Codeunit 1333;
                      Image=Documents }
      { 53      ;2   ;Action    ;
                      Name=User Tasks;
                      CaptionML=[DAN=Brugeropgaver;
                                 ENU=User Tasks];
                      ToolTipML=[DAN=Vis eller skjul opgavekõindikatoren Brugeropgave.;
                                 ENU=Show or hide the User Task cue.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 1347;
                      Image=Task }
      { 40      ;2   ;Action    ;
                      Name=Start;
                      CaptionML=[DAN=Start;
                                 ENU=Start];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 1328;
                      Image=NewDocument }
      { 45      ;2   ;Action    ;
                      Name=Product Videos;
                      CaptionML=[DAN=Produktvideoer;
                                 ENU=Product Videos];
                      ToolTipML=[DAN=Vis oversigten over produktvideoer.;
                                 ENU=View the list of product videos.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 1345;
                      Image=Filed }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 35  ;1   ;Group     ;
                Name=Welcome;
                CaptionML=[DAN=Velkommen;
                           ENU=Welcome];
                Visible=TileGettingStartedVisible;
                GroupType=CueGroup;
                ActionList=ACTIONS
                {
                  { 4       ;    ;Action    ;
                                  Name=GettingStartedTile;
                                  CaptionML=[DAN=Returner til Introduktion;
                                             ENU=Return to Getting Started];
                                  ToolTipML=[DAN=FÜ at vide, hvordan du kommer i gang med Dynamics NAV.;
                                             ENU=Learn how to get started with Dynamics NAV.];
                                  ApplicationArea=#Basic,#Suite;
                                  Image=TileVideo;
                                  OnAction=BEGIN
                                             O365GettingStartedMgt.LaunchWizard(TRUE,FALSE);
                                           END;
                                            }
                }
                 }

    { 10  ;1   ;Group     ;
                CaptionML=[DAN=Igangvërende salg;
                           ENU=Ongoing Sales];
                Visible=ShowSalesActivities;
                GroupType=CueGroup }

    { 13  ;2   ;Field     ;
                CaptionML=[DAN=Tilbud;
                           ENU=Quotes];
                ToolTipML=[DAN=Angiver salgstilbud, der endnu ikke er konverteret til fakturaer eller ordrer.;
                           ENU=Specifies sales quotes that have not yet been converted to invoices or orders.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ongoing Sales Quotes";
                DrillDownPageID=Sales Quotes }

    { 20  ;2   ;Field     ;
                CaptionML=[DAN=Ordrer;
                           ENU=Orders];
                ToolTipML=[DAN=Angiver salgsordrer, der endnu ikke er bogfõrt eller kun er delvist bogfõrt.;
                           ENU=Specifies sales orders that are not yet posted or only partially posted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ongoing Sales Orders";
                DrillDownPageID=Sales Order List }

    { 2   ;2   ;Field     ;
                CaptionML=[DAN=Fakturaer;
                           ENU=Invoices];
                ToolTipML=[DAN=Angiver salgsfakturaer, der endnu ikke er bogfõrt eller kun er delvist bogfõrt.;
                           ENU=Specifies sales invoices that are not yet posted or only partially posted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ongoing Sales Invoices";
                DrillDownPageID=Sales Invoice List }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver summen af salg i den aktuelle mÜned.;
                           ENU=Specifies the sum of sales in the current month.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sales This Month";
                DrillDownPageID=Sales Invoice List;
                OnDrillDown=BEGIN
                              ActivitiesMgt.DrillDownSalesThisMonth;
                            END;
                             }

    { 46  ;2   ;Field     ;
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Uninvoiced Bookings";
                Visible=ShowBookings;
                Enabled=ShowBookings;
                OnDrillDown=VAR
                              BookingManager@1000 : Codeunit 6721;
                            BEGIN
                              BookingManager.InvoiceBookingItems;
                            END;
                             }

    { 28  ;1   ;Group     ;
                CaptionML=[DAN=Dokumentudvekslingstjeneste;
                           ENU=Document Exchange Service];
                Visible=ShowDocumentsPendingDocExchService;
                GroupType=CueGroup }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver salgsfakturaer, der afventer afsendelse til debitoren via dokumentudvekslingstjenesten.;
                           ENU=Specifies sales invoices that await sending to the customer through the document exchange service.];
                ApplicationArea=#Suite;
                SourceExpr="Sales Inv. - Pending Doc.Exch.";
                Visible=ShowDocumentsPendingDocExchService;
                DrillDownPageID=Posted Sales Invoices }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver salgskreditnotaer, der afventer afsendelse til debitoren via dokumentudvekslingstjenesten.;
                           ENU=Specifies sales credit memos that await sending to the customer through the document exchange service.];
                ApplicationArea=#Suite;
                SourceExpr="Sales CrM. - Pending Doc.Exch.";
                Visible=ShowDocumentsPendingDocExchService;
                DrillDownPageID=Posted Sales Credit Memos }

    { 9   ;1   ;Group     ;
                CaptionML=[DAN=Kõb;
                           ENU=Purchases];
                Visible=ShowPurchasesActivities;
                GroupType=CueGroup }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kõbsordrer, der ikke er bogfõrt eller kun er delvist bogfõrt.;
                           ENU=Specifies purchases orders that are not posted or only partially posted.];
                ApplicationArea=#Suite;
                SourceExpr="Purchase Orders";
                DrillDownPageID=Purchase Order List }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kõbsfakturaer, der endnu ikke er bogfõrt eller kun er delvist bogfõrt.;
                           ENU=Specifies purchases invoices that are not posted or only partially posted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ongoing Purchase Invoices";
                DrillDownPageID=Purchase Invoices }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver summen af dine forfaldne betalinger til kreditorer.;
                           ENU=Specifies the sum of your overdue payments to vendors.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Overdue Purch. Invoice Amount";
                OnDrillDown=BEGIN
                              ActivitiesMgt.DrillDownOverduePurchaseInvoiceAmount;
                            END;
                             }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af betalinger til kreditorer, der forfalder i nëste uge.;
                           ENU=Specifies the number of payments to vendors that are due next week.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Purch. Invoices Due Next Week" }

    { 24  ;1   ;Group     ;
                CaptionML=[DAN=Godkendelser;
                           ENU=Approvals];
                Visible=FALSE;
                GroupType=CueGroup }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af godkendelsesanmodninger, der krëver din godkendelse.;
                           ENU=Specifies the number of approval requests that require your approval.];
                ApplicationArea=#Suite;
                SourceExpr="Requests to Approve";
                DrillDownPageID=Requests to Approve }

    { 47  ;1   ;Group     ;
                CaptionML=[DAN=Koncernintern;
                           ENU=Intercompany];
                Visible=ShowIntercompanyActivities;
                GroupType=CueGroup }

    { 48  ;2   ;Field     ;
                CaptionML=[DAN=Ventende indbakketransaktioner;
                           ENU=Pending Inbox Transactions];
                ApplicationArea=#Intercompany;
                SourceExpr="IC Inbox Transactions";
                Visible="IC Inbox Transactions" <> 0;
                DrillDownPageID=IC Inbox Transactions }

    { 49  ;2   ;Field     ;
                CaptionML=[DAN=Ventende udbakketransaktioner;
                           ENU=Pending Outbox Transactions];
                ApplicationArea=#Intercompany;
                SourceExpr="IC Outbox Transactions";
                Visible="IC Outbox Transactions" <> 0;
                DrillDownPageID=IC Outbox Transactions }

    { 12  ;1   ;Group     ;
                CaptionML=[DAN=Betalinger;
                           ENU=Payments];
                Visible=ShowPaymentsActivities;
                GroupType=CueGroup }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver summen af forfaldne betalinger fra debitorer.;
                           ENU=Specifies the sum of overdue payments from customers.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Overdue Sales Invoice Amount";
                OnDrillDown=BEGIN
                              ActivitiesMgt.DrillDownCalcOverdueSalesInvoiceAmount;
                            END;
                             }

    { 29  ;2   ;Field     ;
                CaptionML=[DAN=Ubehandlede betalinger;
                           ENU=Unprocessed Payments];
                ToolTipML=[DAN=Angiver importerede banktransaktioner for betalinger, der endnu ikke er afstemt i vinduet Betalingsudligningskladde.;
                           ENU=Specifies imported bank transactions for payments that are not yet reconciled in the Payment Reconciliation Journal window.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Non-Applied Payments";
                OnDrillDown=BEGIN
                              CODEUNIT.RUN(CODEUNIT::"Pmt. Rec. Journals Launcher");
                            END;

                Image=Cash }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor lang tid debitorerne brugte pÜ at betale fakturaer i de seneste tre mÜneder. Dette er det gennemsnitlige antal dage, fra fakturaerne udstedes, til debitorerne betaler fakturaerne.;
                           ENU=Specifies how long customers took to pay invoices in the last three months. This is the average number of days from when invoices are issued to when customers pay the invoices.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Average Collection Days" }

    { 33  ;1   ;Group     ;
                CaptionML=[DAN=Kamera;
                           ENU=Camera];
                Visible=ShowCamera;
                GroupType=CueGroup;
                ActionList=ACTIONS
                {
                  { 21      ;    ;Action    ;
                                  Name=CreateIncomingDocumentFromCamera;
                                  CaptionML=[DAN=Opret indgÜende bilag fra kamera;
                                             ENU=Create Incoming Doc. from Camera];
                                  ToolTipML=[DAN=Opret et indgÜende bilag ved at tage et foto af bilaget med dit mobilkamera. Fotoet vil blive vedhëftet det nye bilag.;
                                             ENU=Create an incoming document by taking a photo of the document with your mobile device camera. The photo will be attached to the new document.];
                                  ApplicationArea=#Suite;
                                  Image=TileCamera;
                                  OnAction=VAR
                                             CameraOptions@1000 : DotNet "'Microsoft.Dynamics.Nav.ClientExtensions, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.Capabilities.CameraOptions";
                                           BEGIN
                                             IF NOT HasCamera THEN
                                               EXIT;

                                             CameraOptions := CameraOptions.CameraOptions;
                                             CameraOptions.Quality := 100; // 100%
                                             CameraProvider.RequestPictureAsync(CameraOptions);
                                           END;
                                            }
                }
                 }

    { 34  ;1   ;Group     ;
                CaptionML=[DAN=IndgÜende bilag;
                           ENU=Incoming Documents];
                Visible=ShowIncomingDocuments;
                GroupType=CueGroup }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver indgÜende bilag, der er tildelt til dig.;
                           ENU=Specifies incoming documents that are assigned to you.];
                ApplicationArea=#Suite;
                SourceExpr="My Incoming Documents" }

    { 32  ;2   ;Field     ;
                Name=Awaiting Verfication;
                DrillDown=Yes;
                ToolTipML=[DAN=Angiver indgÜende bilag i OCR-behandling, der krëver, at du logger pÜ OCR-tjenestens websted for manuelt at verificere OCR-vërdierne, fõr dokumenterne kan modtages.;
                           ENU=Specifies incoming documents in OCR processing that require you to log on to the OCR service website to manually verify the OCR values before the documents can be received.];
                ApplicationArea=#Suite;
                SourceExpr="Inc. Doc. Awaiting Verfication";
                Visible=ShowAwaitingIncomingDoc;
                OnDrillDown=VAR
                              OCRServiceSetup@1000 : Record 1270;
                            BEGIN
                              IF OCRServiceSetup.GET THEN
                                IF OCRServiceSetup.Enabled THEN
                                  HYPERLINK(OCRServiceSetup."Sign-in URL");
                            END;
                             }

    { 50  ;1   ;Group     ;
                CaptionML=[DAN=Mine brugeropgaver;
                           ENU=My User Tasks];
                Visible=ShowUserTaskActivities;
                GroupType=CueGroup }

    { 51  ;2   ;Field     ;
                CaptionML=[DAN=Ventende brugeropgaver;
                           ENU=Pending User Tasks];
                ToolTipML=[DAN=Angiver det antal ventende opgaver, som du er blevet tildelt.;
                           ENU=Specifies the number of pending tasks that are assigned to you.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pending Tasks";
                DrillDownPageID=User Task List;
                Image=Checklist }

    { 14  ;1   ;Group     ;
                CaptionML=[DAN=Start;
                           ENU=Start];
                Visible=ShowStartActivities;
                GroupType=CueGroup;
                ActionList=ACTIONS
                {
                  { 15      ;    ;Action    ;
                                  CaptionML=[DAN=Salgstilbud;
                                             ENU=Sales Quote];
                                  ToolTipML=[DAN=Tilbyd varer eller servicer til en debitor.;
                                             ENU=Offer items or services to a customer.];
                                  ApplicationArea=#Basic,#Suite;
                                  RunObject=Page 41;
                                  Image=TileNew;
                                  RunPageMode=Create }
                  { 31      ;    ;Action    ;
                                  CaptionML=[DAN=Salgsordre;
                                             ENU=Sales Order];
                                  ToolTipML=[DAN=Opret en ny salgsordre pÜ varer eller servicer, som krëver delvis bogfõring eller ordrebekrëftelse.;
                                             ENU=Create a new sales order for items or services that require partial posting or order confirmation.];
                                  ApplicationArea=#Basic,#Suite;
                                  RunObject=Page 42;
                                  Image=TileNew;
                                  RunPageMode=Create }
                  { 16      ;    ;Action    ;
                                  CaptionML=[DAN=Salgsfaktura;
                                             ENU=Sales Invoice];
                                  ToolTipML=[DAN=Opret en ny faktura for salget af varer eller servicer. Fakturamëngder kan ikke bogfõres delvist.;
                                             ENU=Create a new invoice for the sales of items or services. Invoice quantities cannot be posted partially.];
                                  ApplicationArea=#Basic,#Suite;
                                  RunObject=Page 43;
                                  Image=TileNew;
                                  RunPageMode=Create }
                  { 22      ;    ;Action    ;
                                  CaptionML=[DAN=Kõbsfaktura;
                                             ENU=Purchase Invoice];
                                  ToolTipML=[DAN=Opret en ny kõbsfaktura for varer eller servicer.;
                                             ENU=Create a new purchase invoice for items or services.];
                                  ApplicationArea=#Basic,#Suite;
                                  RunObject=Page 51;
                                  Image=TileNew;
                                  RunPageMode=Create }
                  { 100     ;    ;Action    ;
                                  CaptionML=[DAN=Salgsreturvareordre;
                                             ENU=Sales Return Order];
                                  ToolTipML=[DAN=Opret en ny salgsreturordre for varer eller servicer.;
                                             ENU=Create a new sales return order for items or services.];
                                  ApplicationArea=#SalesReturnOrder;
                                  RunObject=Page 6630;
                                  Image=TileNew;
                                  RunPageMode=Create }
                }
                 }

    { 52  ;1   ;Group     ;
                CaptionML=[DAN=Produktvideoer;
                           ENU=Product Videos];
                Visible=ShowProductVideosActivities;
                GroupType=CueGroup;
                ActionList=ACTIONS
                {
                  { 43      ;    ;Action    ;
                                  CaptionML=[DAN=Produktvideoer;
                                             ENU=Product Videos];
                                  ToolTipML=[DAN=èbn en liste med videoer, der viser nogle af produktegenskaberne.;
                                             ENU=Open a list of videos that showcase some of the product capabilities.];
                                  ApplicationArea=#Basic,#Suite;
                                  RunObject=Page 1470;
                                  Image=TileVideo }
                }
                 }

    { 44  ;1   ;Group     ;
                CaptionML=[DAN=Kom i gang;
                           ENU=Get started];
                Visible=ReplayGettingStartedVisible;
                GroupType=CueGroup;
                ActionList=ACTIONS
                {
                  { 23      ;    ;Action    ;
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
                  { 8       ;    ;Action    ;
                                  Name=ReplayGettingStarted;
                                  CaptionML=[DAN=Afspil Introduktion igen;
                                             ENU=Replay Getting Started];
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
      ActivitiesMgt@1009 : Codeunit 1311;
      CueSetup@1005 : Codeunit 9701;
      O365GettingStartedMgt@1004 : Codeunit 1309;
      ClientTypeManagement@1023 : Codeunit 4;
      CameraProvider@1007 : DotNet "'Microsoft.Dynamics.Nav.ClientExtensions, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.Capabilities.CameraProvider" WITHEVENTS RUNONCLIENT;
      UserTours@1001 : DotNet "'Microsoft.Dynamics.Nav.ClientExtensions, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.Capabilities.UserTours" WITHEVENTS RUNONCLIENT;
      PageNotifier@1002 : DotNet "'Microsoft.Dynamics.Nav.ClientExtensions, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.PageNotifier" WITHEVENTS RUNONCLIENT;
      HasCamera@1008 : Boolean;
      ShowBookings@1020 : Boolean;
      ShowCamera@1003 : Boolean;
      ShowDocumentsPendingDocExchService@1006 : Boolean;
      ShowStartActivities@1010 : Boolean;
      ShowIncomingDocuments@1011 : Boolean;
      ShowPaymentsActivities@1012 : Boolean;
      ShowPurchasesActivities@1013 : Boolean;
      ShowSalesActivities@1014 : Boolean;
      ShowAwaitingIncomingDoc@1015 : Boolean;
      ShowProductVideosActivities@1019 : Boolean;
      ShowIntercompanyActivities@1021 : Boolean;
      TileGettingStartedVisible@1000 : Boolean;
      ReplayGettingStartedVisible@1016 : Boolean;
      HideNpsDialog@1017 : Boolean;
      WhatIsNewTourVisible@1018 : Boolean;
      ShowUserTaskActivities@1022 : Boolean;

    LOCAL PROCEDURE CalculateCueFieldValues@6();
    BEGIN
      IF FIELDACTIVE("Overdue Sales Invoice Amount") THEN
        "Overdue Sales Invoice Amount" := ActivitiesMgt.CalcOverdueSalesInvoiceAmount(FALSE);
      IF FIELDACTIVE("Overdue Purch. Invoice Amount") THEN
        "Overdue Purch. Invoice Amount" := ActivitiesMgt.CalcOverduePurchaseInvoiceAmount(FALSE);
      IF FIELDACTIVE("Sales This Month") THEN
        "Sales This Month" := ActivitiesMgt.CalcSalesThisMonthAmount(FALSE);
      IF FIELDACTIVE("Top 10 Customer Sales YTD") THEN
        "Top 10 Customer Sales YTD" := ActivitiesMgt.CalcTop10CustomerSalesRatioYTD;
      IF FIELDACTIVE("Average Collection Days") THEN
        "Average Collection Days" := ActivitiesMgt.CalcAverageCollectionDays;
      IF FIELDACTIVE("Uninvoiced Bookings") THEN
        "Uninvoiced Bookings" := ActivitiesMgt.CalcUninvoicedBookings;
    END;

    LOCAL PROCEDURE SetActivityGroupVisibility@12();
    VAR
      StartActivitiesMgt@1001 : Codeunit 1328;
      SalesActivitiesMgt@1002 : Codeunit 1329;
      PurchasesActivitiesMgt@1003 : Codeunit 1331;
      PaymentsActivitiesMgt@1004 : Codeunit 1332;
      IncDocActivitiesMgt@1005 : Codeunit 1333;
      ProductVideosActivitiesMgt@1000 : Codeunit 1345;
      UserTaskActivitiesMgt@1006 : Codeunit 1347;
    BEGIN
      ShowStartActivities := StartActivitiesMgt.IsActivitiesVisible;
      ShowSalesActivities := SalesActivitiesMgt.IsActivitiesVisible;
      ShowPurchasesActivities := PurchasesActivitiesMgt.IsActivitiesVisible;
      ShowPaymentsActivities := PaymentsActivitiesMgt.IsActivitiesVisible;
      ShowIncomingDocuments := IncDocActivitiesMgt.IsActivitiesVisible;
      ShowProductVideosActivities := ProductVideosActivitiesMgt.IsActivitiesVisible;
      ShowCamera := HasCamera AND ShowIncomingDocuments;
      ShowIntercompanyActivities := ("IC Inbox Transactions" <> 0) OR ("IC Outbox Transactions" <> 0);
      ShowUserTaskActivities := UserTaskActivitiesMgt.IsActivitiesVisible;
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

    LOCAL PROCEDURE PrepareOnLoadDialog@30();
    BEGIN
      IF PrepareUserTours THEN
        EXIT;
      PreparePageNotifier;
    END;

    LOCAL PROCEDURE PreparePageNotifier@8();
    BEGIN
      IF NOT PageNotifier.IsAvailable THEN
        EXIT;
      PageNotifier := PageNotifier.Create;
      PageNotifier.NotifyPageReady;
    END;

    LOCAL PROCEDURE PrepareUserTours@9() : Boolean;
    VAR
      NetPromoterScore@1002 : Record 1433;
    BEGIN
      IF (NOT UserTours.IsAvailable) OR (NOT O365GettingStartedMgt.AreUserToursEnabled) THEN
        EXIT(FALSE);
      UserTours := UserTours.Create;
      UserTours.NotifyShowTourWizard;
      IF O365GettingStartedMgt.IsGettingStartedSupported THEN BEGIN
        HideNpsDialog := O365GettingStartedMgt.WizardHasToBeLaunched(FALSE);
        IF HideNpsDialog THEN
          NetPromoterScore.DisableRequestSending;
      END;
      EXIT(TRUE);
    END;

    EVENT CameraProvider@1007::PictureAvailable@10(PictureName@1001 : Text;PictureFilePath@1000 : Text);
    VAR
      IncomingDocument@1002 : Record 130;
    BEGIN
      IncomingDocument.CreateIncomingDocumentFromServerFile(PictureName,PictureFilePath);
      CurrPage.UPDATE;
    END;

    EVENT UserTours@1001::ShowTourWizard@13(hasTourCompleted@1000 : Boolean);
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

    EVENT UserTours@1001::IsTourInProgressResultReady@14(isInProgress@1000 : Boolean);
    BEGIN
    END;

    EVENT PageNotifier@1002::PageReady@9();
    VAR
      NetPromoterScoreMgt@1000 : Codeunit 1432;
    BEGIN
      IF O365GettingStartedMgt.WizardShouldBeOpenedForDevices THEN BEGIN
        COMMIT;
        PAGE.RUNMODAL(PAGE::"O365 Getting Started Device");
        EXIT;
      END;

      IF NOT HideNpsDialog THEN
        IF NetPromoterScoreMgt.ShowNpsDialog THEN
          HideNpsDialog := TRUE;
    END;

    BEGIN
    END.
  }
}

