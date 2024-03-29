OBJECT Codeunit 6700 O365 Sync. Management
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    Permissions=TableData 1261=rimd;
    OnRun=BEGIN
            CODEUNIT.RUN(CODEUNIT::"Exchange Contact Sync.");
            CODEUNIT.RUN(CODEUNIT::"Booking Customer Sync.");
            CODEUNIT.RUN(CODEUNIT::"Booking Service Sync.");
          END;

  }
  CODE
  {
    VAR
      ProgressWindow@1009 : Dialog;
      BookingsConnectionID@1000 : Text;
      ConnectionErr@1006 : TextConst '@@@="%1 = User who cannot connect";DAN=%1 kunne ikke oprette forbindelse til Exchange. Dette kan skyldes, at tjenesten er nede, eller at legitimationsoplysningerne er ugyldige.;ENU=%1 is unable to connect to Exchange. This may be due to a service outage or invalid credentials.';
      LoggingConstTxt@1001 : TextConst 'DAN=Kontaktsynkronisering.;ENU=Contact synchronization.';
      O365RecordMissingErr@1002 : TextConst 'DAN=Konfigurationsrecorden for Office 365-synkronisering er ikke konfigureret korrekt.;ENU=The Office 365 synchronization setup record is not configured correctly.';
      ExchangeConnectionID@1004 : Text;
      RegisterConnectionTxt@1005 : TextConst 'DAN=Registrer forbindelse.;ENU=Register connection.';
      SetupO365Qst@1008 : TextConst 'DAN=Vil du konfigurere forbindelsen til Office 365 nu?;ENU=Would you like to configure your connection to Office 365 now?';
      BookingsConnectionString@1010 : Text;
      ExchangeConnectionString@1011 : Text;
      GettingContactsTxt@1003 : TextConst 'DAN=Henter kontakter fra Exchange.;ENU=Getting Exchange contacts.';
      GettingBookingCustomersTxt@1012 : TextConst 'DAN=Henter Bookings-debitorer.;ENU=Getting Booking customers.';
      GettingBookingServicesTxt@1013 : TextConst 'DAN=Henter Bookings-tjenester.;ENU=Getting Booking services.';
      NoUserAccessErr@1007 : TextConst '@@@="%1 = The Bookings company; %2 = The user";DAN=Kunne ikke oprette forbindelse til %1. Bekr�ft, at %2 er en administrator i Bookings-postkassen.;ENU=Could not connect to %1. Verify that %2 is an administrator in the Bookings mailbox.';

    [TryFunction]
    [Internal]
    PROCEDURE GetBookingMailboxes@21(BookingSync@1000 : Record 6702;VAR TempBookingMailbox@1002 : TEMPORARY Record 6704;MailboxName@1003 : Text);
    VAR
      BookingMailbox@1001 : Record 6704;
    BEGIN
      BookingSync."Booking Mailbox Address" := COPYSTR(MailboxName,1,80);
      RegisterBookingsConnection(BookingSync);
      TempBookingMailbox.RESET;
      TempBookingMailbox.DELETEALL;
      IF BookingMailbox.FINDSET THEN
        REPEAT
          TempBookingMailbox.INIT;
          TempBookingMailbox.TRANSFERFIELDS(BookingMailbox);
          TempBookingMailbox.INSERT;
        UNTIL BookingMailbox.NEXT = 0;
    END;

    [Internal]
    PROCEDURE CreateExchangeConnection@17(VAR ExchangeSync@1000 : Record 6700) Valid : Boolean;
    VAR
      User@1001 : Record 2000000120;
      AuthenticationEmail@1002 : Text[250];
    BEGIN
      IsO365Setup(FALSE);
      IF GetUser(User,ExchangeSync."User ID") THEN BEGIN
        AuthenticationEmail := User."Authentication Email";
        Valid := ValidateExchangeConnection(AuthenticationEmail,ExchangeSync);
      END;
    END;

    [Internal]
    PROCEDURE IsO365Setup@8(AddOnTheFly@1000 : Boolean) : Boolean;
    VAR
      User@1001 : Record 2000000120;
      LocalExchangeSync@1003 : Record 6700;
      AuthenticationEmail@1002 : Text[250];
      Password@1004 : Text;
      Token@1005 : Text;
    BEGIN
      WITH LocalExchangeSync DO BEGIN
        IF GetUser(User,USERID) THEN
          AuthenticationEmail := User."Authentication Email";

        IF NOT GET(USERID) OR
           (AuthenticationEmail = '') OR ("Folder ID" = '') OR NOT GetPasswordOrToken(LocalExchangeSync,Password,Token)
        THEN BEGIN
          IF AddOnTheFly THEN BEGIN
            IF NOT OpenSetupWindow THEN
              ERROR(O365RecordMissingErr)
          END ELSE
            ERROR(O365RecordMissingErr);
        END;
      END;

      EXIT(TRUE);
    END;

    [External]
    PROCEDURE OpenSetupWindow@16() : Boolean;
    VAR
      ExchangeSyncSetup@1000 : Page 6700;
    BEGIN
      IF CONFIRM(SetupO365Qst,TRUE) THEN
        EXIT(ExchangeSyncSetup.RUNMODAL = ACTION::OK);
    END;

    [EventSubscriber(Codeunit,2,OnCompanyInitialize)]
    LOCAL PROCEDURE SetupContactSyncJobQueue@22();
    VAR
      JobQueueEntry@1000 : Record 472;
      TwentyFourHours@1001 : Integer;
    BEGIN
      WITH JobQueueEntry DO BEGIN
        SETRANGE("Object Type to Run","Object Type to Run"::Codeunit);
        SETRANGE("Object ID to Run",CODEUNIT::"O365 Sync. Management");

        IF ISEMPTY THEN BEGIN
          TwentyFourHours := 24 * 60;
          InitRecurringJob(TwentyFourHours);
          "Object Type to Run" := "Object Type to Run"::Codeunit;
          "Object ID to Run" := CODEUNIT::"O365 Sync. Management";
          CODEUNIT.RUN(CODEUNIT::"Job Queue - Enqueue",JobQueueEntry);
        END;
      END;
    END;

    [Internal]
    PROCEDURE SyncBookingCustomers@6(VAR BookingSync@1000 : Record 6702);
    VAR
      BookingCustomerSync@1003 : Codeunit 6704;
    BEGIN
      CheckUserAccess(BookingSync);
      ShowProgress(GettingBookingCustomersTxt);
      RegisterBookingsConnection(BookingSync);
      CloseProgress;
      BookingCustomerSync.SyncRecords(BookingSync);
    END;

    [Internal]
    PROCEDURE SyncBookingServices@13(VAR BookingSync@1000 : Record 6702);
    VAR
      BookingServiceSync@1003 : Codeunit 6705;
    BEGIN
      CheckUserAccess(BookingSync);
      ShowProgress(GettingBookingServicesTxt);
      RegisterBookingsConnection(BookingSync);
      CloseProgress;
      BookingServiceSync.SyncRecords(BookingSync);
    END;

    [Internal]
    PROCEDURE SyncExchangeContacts@14(ExchangeSync@1003 : Record 6700;FullSync@1001 : Boolean);
    VAR
      ExchangeContactSync@1000 : Codeunit 6703;
    BEGIN
      ShowProgress(GettingContactsTxt);
      RegisterExchangeConnection(ExchangeSync);
      CloseProgress;
      ExchangeContactSync.SyncRecords(ExchangeSync,FullSync);
    END;

    [Internal]
    PROCEDURE LogActivityFailed@7(RecordID@1002 : Variant;UserID@1005 : Code[50];ActivityDescription@1001 : Text;ActivityMessage@1000 : Text);
    VAR
      ActivityLog@1003 : Record 710;
    BEGIN
      ActivityMessage := GETLASTERRORTEXT + ' ' + ActivityMessage;
      CLEARLASTERROR;

      ActivityLog.LogActivityForUser(RecordID,ActivityLog.Status::Failed,COPYSTR(LoggingConstTxt,1,30),
        ActivityDescription,ActivityMessage,UserID);
    END;

    [Internal]
    PROCEDURE BuildBookingsConnectionString@15(VAR BookingSync@1000 : Record 6702) ConnectionString : Text;
    VAR
      User@1003 : Record 2000000120;
      ExchangeSync@1001 : Record 6700;
      Password@1002 : Text;
      Token@1005 : Text;
    BEGIN
      // Example connection string
      // {UserName}="user@user.onmicrosoft.com";{Password}="1234";{FolderID}="Dynamics NAV";{Uri}=https://outlook.office365.com/EWS/Exchange.asmx
      ExchangeSync.GET(BookingSync."User ID");
      IF (NOT GetUser(User,BookingSync."User ID")) OR
         (User."Authentication Email" = '') OR
         (NOT GetPasswordOrToken(ExchangeSync,Password,Token))
      THEN
        ERROR(O365RecordMissingErr);

      ConnectionString :=
        STRSUBSTNO(
          '{UserName}=%1;{Password}=%2;{Token}=%3;{Mailbox}=%4;',
          User."Authentication Email",
          Password,
          Token,
          BookingSync."Booking Mailbox Address");

      IF Token <> '' THEN
        ConnectionString := STRSUBSTNO('%1;{Uri}=%2',ConnectionString,ExchangeSync.GetExchangeEndpoint);
    END;

    [Internal]
    PROCEDURE BuildExchangeConnectionString@1(VAR ExchangeSync@1000 : Record 6700) ConnectionString : Text;
    VAR
      User@1001 : Record 2000000120;
      Token@1003 : Text;
      Password@1005 : Text;
    BEGIN
      // Example connection string
      // {UserName}="user@user.onmicrosoft.com";{Password}="1234";{FolderID}="Dynamics NAV";{Uri}=https://outlook.office365.com/EWS/Exchange.asmx
      IF (NOT GetUser(User,ExchangeSync."User ID")) OR
         (User."Authentication Email" = '') OR
         (ExchangeSync."Folder ID" = '') OR (NOT GetPasswordOrToken(ExchangeSync,Password,Token))
      THEN
        ERROR(O365RecordMissingErr);

      ConnectionString :=
        STRSUBSTNO(
          '{UserName}=%1;{Password}=%2;{Token}=%3;{FolderID}=%4;',
          User."Authentication Email",
          Password,
          Token,
          ExchangeSync."Folder ID");

      IF Token <> '' THEN
        ConnectionString := STRSUBSTNO('%1;{Uri}=%2',ConnectionString,ExchangeSync.GetExchangeEndpoint);
    END;

    [Internal]
    PROCEDURE RegisterBookingsConnection@20(BookingSync@1001 : Record 6702);
    VAR
      ExchangeSync@1002 : Record 6700;
    BEGIN
      IF ExchangeConnectionID <> '' THEN
        UnregisterConnection(ExchangeConnectionID);

      IF BookingsConnectionReady(BookingSync) THEN
        EXIT;

      IF BookingsConnectionID <> '' THEN
        UnregisterConnection(BookingsConnectionID);

      ExchangeSync.GET(BookingSync."User ID");
      BookingsConnectionID := CREATEGUID;

      IF RegisterConnection(ExchangeSync,BookingsConnectionID,BookingsConnectionString) THEN
        SetConnection(ExchangeSync,BookingsConnectionID);
    END;

    [Internal]
    PROCEDURE RegisterExchangeConnection@25(ExchangeSync@1000 : Record 6700);
    BEGIN
      IF BookingsConnectionID <> '' THEN
        UnregisterConnection(BookingsConnectionID);

      IF ExchangeConnectionReady(ExchangeSync) THEN
        EXIT;

      IF ExchangeConnectionID <> '' THEN
        UnregisterConnection(ExchangeConnectionID);

      ExchangeConnectionID := CREATEGUID;
      IF RegisterConnection(ExchangeSync,ExchangeConnectionID,ExchangeConnectionString) THEN
        SetConnection(ExchangeSync,ExchangeConnectionID);
    END;

    [TryFunction]
    LOCAL PROCEDURE TryRegisterConnection@2(ConnectionID@1000 : GUID;ConnectionString@1001 : Text);
    BEGIN
      // Using a try function, as these may throw an exception under certain circumstances (improper credentials, broken connection)
      REGISTERTABLECONNECTION(TABLECONNECTIONTYPE::Exchange,ConnectionID,ConnectionString);
    END;

    LOCAL PROCEDURE RegisterConnection@24(ExchangeSync@1002 : Record 6700;ConnectionID@1000 : GUID;ConnectionString@1001 : Text) Success : Boolean;
    BEGIN
      Success := TryRegisterConnection(ConnectionID,ConnectionString);
      IF NOT Success THEN
        ConnectionFailure(ExchangeSync);
    END;

    [TryFunction]
    LOCAL PROCEDURE TrySetConnection@28(ConnectionID@1000 : GUID);
    BEGIN
      // Using a try function, as these may throw an exception under certain circumstances (improper credentials, broken connection)
      SETDEFAULTTABLECONNECTION(TABLECONNECTIONTYPE::Exchange,ConnectionID);
    END;

    LOCAL PROCEDURE SetConnection@3(ExchangeSync@1001 : Record 6700;ConnectionID@1000 : GUID) Success : Boolean;
    BEGIN
      Success := TrySetConnection(ConnectionID);
      IF NOT Success THEN
        ConnectionFailure(ExchangeSync);
    END;

    [TryFunction]
    LOCAL PROCEDURE UnregisterConnection@4(VAR ConnectionID@1000 : Text);
    BEGIN
      UNREGISTERTABLECONNECTION(TABLECONNECTIONTYPE::Exchange,ConnectionID);
      ConnectionID := '';
    END;

    LOCAL PROCEDURE ConnectionFailure@31(ExchangeSync@1000 : Record 6700);
    BEGIN
      WITH ExchangeSync DO BEGIN
        LogActivityFailed(RECORDID,RegisterConnectionTxt,STRSUBSTNO(ConnectionErr,"User ID"),"User ID");
        IF GUIALLOWED THEN BEGIN
          CloseProgress;
          ERROR(STRSUBSTNO(ConnectionErr,"User ID"));
        END;
      END;
    END;

    [Internal]
    PROCEDURE ValidateExchangeConnection@10(AuthenticationEmail@1001 : Text[250];VAR ExchangeSync@1000 : Record 6700) Valid : Boolean;
    VAR
      ExchangeWebServicesServer@1003 : Codeunit 5321;
      Credentials@1002 : DotNet "'Microsoft.Exchange.WebServices, Version=15.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Exchange.WebServices.Data.ExchangeCredentials";
      Endpoint@1004 : Text[250];
    BEGIN
      CreateExchangeAccountCredentials(ExchangeSync,Credentials);
      Endpoint := ExchangeSync."Exchange Service URI";
      Valid := ExchangeWebServicesServer.InitializeAndValidate(AuthenticationEmail,Endpoint,Credentials);
      IF Valid AND (Endpoint <> ExchangeSync."Exchange Service URI") THEN BEGIN
        ExchangeSync.VALIDATE("Exchange Service URI",Endpoint);
        ExchangeSync.MODIFY;
      END;
    END;

    LOCAL PROCEDURE CreateExchangeAccountCredentials@11(VAR ExchangeSync@1001 : Record 6700;VAR Credentials@1000 : DotNet "'Microsoft.Exchange.WebServices, Version=15.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Exchange.WebServices.Data.ExchangeCredentials");
    VAR
      User@1003 : Record 2000000120;
      WebCredentials@1008 : DotNet "'Microsoft.Exchange.WebServices, Version=15.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Exchange.WebServices.Data.WebCredentials";
      OAuthCredentials@1007 : DotNet "'Microsoft.Exchange.WebServices, Version=15.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Exchange.WebServices.Data.OAuthCredentials";
      AuthenticationEmail@1002 : Text[250];
      Token@1004 : Text;
      Password@1005 : Text;
    BEGIN
      WITH ExchangeSync DO BEGIN
        IF GetUser(User,"User ID") THEN
          AuthenticationEmail := User."Authentication Email";
        IF AuthenticationEmail = '' THEN
          ERROR(O365RecordMissingErr);
        IF NOT GetPasswordOrToken(ExchangeSync,Password,Token) THEN
          ERROR(O365RecordMissingErr);

        IF Token <> '' THEN
          Credentials := OAuthCredentials.OAuthCredentials(Token)
        ELSE
          Credentials := WebCredentials.WebCredentials(AuthenticationEmail,Password);
      END;
    END;

    LOCAL PROCEDURE GetUser@12(VAR User@1001 : Record 2000000120;UserID@1000 : Text[50]) : Boolean;
    BEGIN
      User.SETRANGE("User Name",UserID);
      EXIT(User.FINDFIRST);
    END;

    [External]
    PROCEDURE ShowProgress@18(Message@1000 : Text);
    BEGIN
      IF GUIALLOWED THEN BEGIN
        CloseProgress;
        ProgressWindow.OPEN(Message);
      END;
    END;

    [External]
    PROCEDURE CloseProgress@19();
    BEGIN
      IF GUIALLOWED THEN
        IF TryCloseProgress THEN;
    END;

    [TryFunction]
    LOCAL PROCEDURE TryCloseProgress@30();
    BEGIN
      ProgressWindow.CLOSE;
    END;

    LOCAL PROCEDURE BookingsConnectionReady@26(BookingSync@1000 : Record 6702) Ready : Boolean;
    VAR
      NewConnectionString@1001 : Text;
    BEGIN
      NewConnectionString := BuildBookingsConnectionString(BookingSync);
      Ready := (BookingsConnectionID <> '') AND (NewConnectionString = BookingsConnectionString);
      BookingsConnectionString := NewConnectionString;
    END;

    LOCAL PROCEDURE ExchangeConnectionReady@27(ExchangeSync@1000 : Record 6700) Ready : Boolean;
    VAR
      NewConnectionString@1001 : Text;
    BEGIN
      NewConnectionString := BuildExchangeConnectionString(ExchangeSync);
      Ready := (ExchangeConnectionID <> '') AND (NewConnectionString = ExchangeConnectionString);
      ExchangeConnectionString := NewConnectionString;
    END;

    LOCAL PROCEDURE GetPasswordOrToken@23(ExchangeSync@1000 : Record 6700;VAR Password@1001 : Text;VAR Token@1002 : Text) : Boolean;
    VAR
      ServicePassword@1003 : Record 1261;
      AzureADMgt@1004 : Codeunit 6300;
    BEGIN
      Token := AzureADMgt.GetAccessToken(AzureADMgt.GetO365Resource,AzureADMgt.GetO365ResourceName,FALSE);

      IF (Token = '') AND NOT ISNULLGUID(ExchangeSync."Exchange Account Password Key") THEN
        IF ServicePassword.GET(ExchangeSync."Exchange Account Password Key") THEN
          Password := ServicePassword.GetPassword;

      EXIT((Token <> '') OR (Password <> ''));
    END;

    LOCAL PROCEDURE CheckUserAccess@5(BookingSync@1000 : Record 6702);
    VAR
      ExchangeSync@1004 : Record 6700;
      Credentials@1005 : DotNet "'Microsoft.Exchange.WebServices, Version=15.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Exchange.WebServices.Data.ExchangeCredentials";
      ExchangeServiceFactory@1002 : DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.ServiceWrapperFactory";
      ExchangeService@1001 : DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.ExchangeServiceWrapper";
    BEGIN
      ExchangeSync.GET(BookingSync."User ID");
      ExchangeService := ExchangeServiceFactory.CreateServiceWrapper2013;
      CreateExchangeAccountCredentials(ExchangeSync,Credentials);
      ExchangeService.SetNetworkCredential(Credentials);
      ExchangeService.ExchangeServiceUrl := ExchangeSync.GetExchangeEndpoint;

      IF NOT ExchangeService.CanAccessBookingMailbox(BookingSync."Booking Mailbox Address") THEN
        ERROR(NoUserAccessErr,BookingSync."Booking Mailbox Name",BookingSync."User ID");
    END;

    BEGIN
    END.
  }
}

