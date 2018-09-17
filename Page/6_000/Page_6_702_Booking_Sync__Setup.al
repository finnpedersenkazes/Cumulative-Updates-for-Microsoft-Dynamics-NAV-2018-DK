OBJECT Page 6702 Booking Sync. Setup
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    Permissions=TableData 1261=rimd;
    CaptionML=[DAN=Ops‘tning af Bookings-synkronisering;
               ENU=Booking Sync. Setup];
    InsertAllowed=No;
    DeleteAllowed=No;
    LinksAllowed=No;
    SourceTable=Table6702;
    DataCaptionExpr="Booking Mailbox Name";
    PageType=Card;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Naviger,Filtrer;
                                ENU=New,Process,Report,Navigate,Filter];
    OnInit=VAR
             MarketingSetup@1000 : Record 5079;
           BEGIN
             IF MarketingSetup.GET THEN
               GraphSyncEnabled := MarketingSetup."Sync with Microsoft Graph";
           END;

    OnOpenPage=VAR
                 PermissionManager@1000 : Codeunit 9002;
               BEGIN
                 CheckExistingSetup;
                 GetExchangeAccount;
                 IsSyncUser := "User ID" = USERID;
                 IsSaaS := PermissionManager.SoftwareAsAService;
               END;

    ActionList=ACTIONS
    {
      { 6       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 18      ;1   ;ActionGroup;
                      CaptionML=[DAN=Proces;
                                 ENU=Process];
                      Image=Action }
      { 22      ;2   ;Action    ;
                      Name=Validate Exchange Connection;
                      CaptionML=[DAN=Kontroll‚r Exchange-forbindelse;
                                 ENU=Validate Exchange Connection];
                      ToolTipML=[DAN=Test, at den angivne Exchange Server-forbindelse fungerer.;
                                 ENU=Test that the provided exchange server connection works.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=ValidateEmailLoggingSetup;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF O365SyncManagement.IsO365Setup(FALSE) THEN
                                   O365SyncManagement.ValidateExchangeConnection(ExchangeAccountUserName,ExchangeSync);
                               END;
                                }
      { 28      ;2   ;Action    ;
                      Name=SyncWithBookings;
                      CaptionML=[DAN=Synkroniser med Bookings;
                                 ENU=Sync with Bookings];
                      ToolTipML=[DAN=Synkroniser ‘ndringer, der er foretaget i Bookings, siden sidste synkroniseringsdato og sidste ‘ndringsdato.;
                                 ENU=Synchronize changes made in Bookings since the last sync date and last modified date.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Refresh;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 O365SyncManagement@1002 : Codeunit 6700;
                               BEGIN
                                 CLEAR(O365SyncManagement);
                                 IF O365SyncManagement.IsO365Setup(FALSE) THEN BEGIN
                                   IF "Sync Customers" THEN
                                     O365SyncManagement.SyncBookingCustomers(Rec);
                                   IF "Sync Services" THEN
                                     O365SyncManagement.SyncBookingServices(Rec);
                                 END;
                               END;
                                }
      { 23      ;2   ;Action    ;
                      Name=SetSyncUser;
                      CaptionML=[DAN=Angiv synkroniseringsbruger;
                                 ENU=Set Sync. User];
                      ToolTipML=[DAN=Indstil synkroniseringsbrugeren til at v‘re dig.;
                                 ENU=Set the synchronization user to be you.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=NOT IsSyncUser;
                      Image=User;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF CONFIRM(SetSyncUserQst) THEN BEGIN
                                   VALIDATE("User ID",USERID);
                                   GetExchangeAccount;
                                 END;
                               END;
                                }
      { 7       ;2   ;Action    ;
                      Name=Invoice Appointments;
                      CaptionML=[DAN=Fakturaaftaler;
                                 ENU=Invoice Appointments];
                      ToolTipML=[DAN=Vis Bookings-aftaler, og opret fakturaer for dine debitorer.;
                                 ENU=View Booking appointments and create invoices for your customers.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=IsSaaS;
                      PromotedIsBig=Yes;
                      Image=NewInvoice;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 BookingManager@1003 : Codeunit 6721;
                               BEGIN
                                 BookingManager.InvoiceBookingItems;
                               END;
                                }
      { 16      ;1   ;ActionGroup;
                      CaptionML=[DAN=Filtrer;
                                 ENU=Filter] }
      { 17      ;2   ;Action    ;
                      Name=SetCustomerSyncFilter;
                      CaptionML=[DAN=Angiv debitorsynkroniseringsfilter;
                                 ENU=Set Customer Sync Filter];
                      ToolTipML=[DAN=Indstil et filter til brug under synkronisering af debitorer.;
                                 ENU=Set a filter to use when syncing customers.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=ContactFilter;
                      PromotedCategory=Category5;
                      OnAction=VAR
                                 BookingCustomerSync@1000 : Codeunit 6704;
                               BEGIN
                                 CALCFIELDS("Customer Filter");
                                 BookingCustomerSync.GetRequestParameters(Rec);
                               END;
                                }
      { 20      ;2   ;Action    ;
                      Name=SetServiceSyncFilter;
                      CaptionML=[DAN=Angiv tjenestesynkroniseringsfilter;
                                 ENU=Set Service Sync Filter];
                      ToolTipML=[DAN=Indstil et filter til brug under synkronisering af serviceartikler.;
                                 ENU=Set a filter to use when syncing service items.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Filter;
                      PromotedCategory=Category5;
                      OnAction=VAR
                                 BookingServiceSync@1004 : Codeunit 6705;
                               BEGIN
                                 CALCFIELDS("Item Filter");
                                 BookingServiceSync.GetRequestParameters(Rec);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=General;
                CaptionML=[DAN=Generelt;
                           ENU=General];
                GroupType=Group }

    { 3   ;2   ;Field     ;
                Name=Bookings Company;
                CaptionML=[DAN=Bookings-virksomhed;
                           ENU=Bookings Company];
                ToolTipML=[DAN=Angiver, den Bookings-virksomhed, hvormed debitorer og servicer skal synkroniseres.;
                           ENU=Specifies the Bookings company with which to synchronize customers and services.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Booking Mailbox Name";
                OnValidate=VAR
                             BookingMailbox@1001 : Record 6704;
                             BookingMailboxList@1000 : Page 6704;
                           BEGIN
                             IF FORMAT("Last Customer Sync") + FORMAT("Last Service Sync") <> '' THEN
                               IF NOT CONFIRM(ChangeCompanyQst) THEN BEGIN
                                 "Booking Mailbox Name" := xRec."Booking Mailbox Name";
                                 EXIT;
                               END;

                             O365SyncManagement.GetBookingMailboxes(Rec,TempBookingMailbox,"Booking Mailbox Name");

                             IF TempBookingMailbox.COUNT = 0 THEN
                               ERROR(NoMailboxErr);

                             IF TempBookingMailbox.COUNT = 1 THEN BEGIN
                               "Booking Mailbox Address" := TempBookingMailbox.SmtpAddress;
                               "Booking Mailbox Name" := TempBookingMailbox."Display Name";
                             END ELSE BEGIN
                               BookingMailboxList.SetMailboxes(TempBookingMailbox);
                               BookingMailboxList.LOOKUPMODE(TRUE);
                               IF BookingMailboxList.RUNMODAL IN [ACTION::LookupOK,ACTION::OK] THEN BEGIN
                                 BookingMailboxList.GETRECORD(BookingMailbox);
                                 "Booking Mailbox Address" := BookingMailbox.SmtpAddress;
                                 "Booking Mailbox Name" := BookingMailbox."Display Name";
                               END ELSE
                                 "Booking Mailbox Name" := xRec."Booking Mailbox Name";
                             END;

                             IF "Booking Mailbox Name" <> xRec."Booking Mailbox Name" THEN BEGIN
                               CLEAR("Last Customer Sync");
                               CLEAR("Last Service Sync");
                               MODIFY;
                               CurrPage.UPDATE;
                             END;
                           END;
                            }

    { 5   ;2   ;Field     ;
                Name=SyncUser;
                CaptionML=[DAN=Synkroniseringsbruger;
                           ENU=Synchronization User];
                ToolTipML=[DAN=Angiver den bruger, for hvem synkroniseringen skal udf›res.;
                           ENU=Specifies the user on behalf of which to run the synchronize operation.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="User ID";
                Enabled=false;
                Editable=false }

    { 8   ;2   ;Field     ;
                CaptionML=[DAN=Aktiv‚r baggrundssynkronisering;
                           ENU=Enable Background Synchronization];
                ToolTipML=[DAN=Angiver, om der skal tillades, at synkronisering regelm‘ssigt udf›res i baggrunden.;
                           ENU=Specifies whether to allow synchronization to occur periodically in the background.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Enabled }

    { 19  ;1   ;Group     ;
                Name=Synchronize;
                CaptionML=[DAN=Synkroniser;
                           ENU=Synchronize];
                GroupType=Group }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om Bookings-kunder skal synkroniseres.;
                           ENU=Specifies whether to synchronize Bookings customers.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sync Customers";
                Visible=NOT GraphSyncEnabled }

    { 13  ;2   ;Field     ;
                CaptionML=[DAN=Standardskabelon til debitor;
                           ENU=Default Customer Template];
                ToolTipML=[DAN=Angiver den debitorskabelon, der skal bruges ved oprettelse af nye debitorer fra Bookings-virksomheden.;
                           ENU=Specifies the customer template to use when creating new Customers from the Bookings company.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Customer Template Code";
                Visible=NOT GraphSyncEnabled }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om servicer skal synkroniseres.;
                           ENU=Specifies whether to synchronize services.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sync Services" }

    { 4   ;2   ;Field     ;
                CaptionML=[DAN=Standardvareskabelon;
                           ENU=Default Item Template];
                ToolTipML=[DAN=Angiver den skabelon, der skal bruges ved oprettelse af nye serviceartikler fra Bookings-virksomheden.;
                           ENU=Specifies the template to use when creating new service items from the Bookings company.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Item Template Code" }

  }
  CODE
  {
    VAR
      ExchangeSync@1000 : Record 6700;
      TempBookingMailbox@1002 : TEMPORARY Record 6704;
      O365SyncManagement@1004 : Codeunit 6700;
      ExchangeAccountUserName@1001 : Text[250];
      ChangeCompanyQst@1003 : TextConst 'DAN=Synkroniseringen er blevet k›rt i forhold til den aktuelle virksomhed. Processen vil ikke l‘ngere synkronisere debitor- og tjenesterecords med den aktuelle virksomhed og synkronisere i forhold til den nye valgte virksomhed. Vil du forts‘tte?;ENU=The synchronization has been run against the current company. The process will no longer synchronize customer and service records with the current company, and synchronize against the new selected company. Do you want to continue?';
      SetSyncUserQst@1008 : TextConst 'DAN=Ved indstilling af synkroniseringsbrugeren tildeles din Exchange-mail og -adgangskode som de anvendte legitimationsoplysninger ved synkronisering af debitorer og serviceartikler til Bookings for denne virksomhed. Enhver bruger, der allerede er tildelt som synkroniseringsbruger, erstattes med dit Bruger-id. Vil du forts‘tte?;ENU=Setting the synchronization user will assign your Exchange email and password as the credentials that are used to synchronize customers and service items to Bookings for this company. Any user already assigned as the synchronization user will be replaced with your User ID. Do you want to continue?';
      ExchangeSyncErr@1007 : TextConst 'DAN=Exchange-synkronisering skal konfigureres inden brug af Bookings-synkronisering.;ENU=Exchange sync. must be setup before using Bookings Sync.';
      NoMailboxErr@1010 : TextConst 'DAN=Der er ikke fundet nogen matchende postkasser.;ENU=No matching mailboxes found.';
      IsSyncUser@1005 : Boolean;
      GraphSyncEnabled@1006 : Boolean;
      IsSaaS@1009 : Boolean;

    LOCAL PROCEDURE CheckExistingSetup@6();
    BEGIN
      IF NOT ExchangeSync.GET(USERID) OR NOT O365SyncManagement.IsO365Setup(FALSE) THEN
        ERROR(ExchangeSyncErr);

      IF NOT GET THEN BEGIN
        INIT;
        "User ID" := USERID;
        O365SyncManagement.GetBookingMailboxes(Rec,TempBookingMailbox,'');
        IF TempBookingMailbox.COUNT = 1 THEN BEGIN
          "Booking Mailbox Address" := TempBookingMailbox.SmtpAddress;
          "Booking Mailbox Name" := TempBookingMailbox."Display Name";
        END;
        INSERT(TRUE);
      END;
    END;

    LOCAL PROCEDURE GetExchangeAccount@1();
    VAR
      User@1000 : Record 2000000120;
    BEGIN
      User.SETRANGE("User Name",USERID);
      IF User.FINDFIRST THEN
        ExchangeAccountUserName := User."Authentication Email";
    END;

    BEGIN
    END.
  }
}

