OBJECT Table 5330 CRM Connection Setup
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    Permissions=TableData 1261=rimd;
    CaptionML=[DAN=Konfiguration af Microsoft Dynamics 365-forbindelse;
               ENU=Microsoft Dynamics 365 Connection Setup];
  }
  FIELDS
  {
    { 1   ;   ;Primary Key         ;Code20        ;CaptionML=[DAN=Prim‘rn›gle;
                                                              ENU=Primary Key] }
    { 2   ;   ;Server Address      ;Text250       ;OnValidate=BEGIN
                                                                CRMIntegrationManagement.CheckModifyCRMConnectionURL("Server Address");

                                                                IF STRPOS("Server Address",'.dynamics.com') > 0 THEN
                                                                  "Authentication Type" := "Authentication Type"::Office365
                                                                ELSE
                                                                  "Authentication Type" := "Authentication Type"::AD;
                                                                IF "User Name" <> '' THEN
                                                                  UpdateConnectionString;
                                                              END;

                                                   CaptionML=[DAN=URL-adresse til Dynamics 365 for Sales;
                                                              ENU=Dynamics 365 for Sales URL] }
    { 3   ;   ;User Name           ;Text250       ;OnValidate=BEGIN
                                                                "User Name" := DELCHR("User Name",'<>');
                                                                CheckUserName;
                                                                UpdateDomainName;
                                                                UpdateConnectionString;
                                                              END;

                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Brugernavn;
                                                              ENU=User Name] }
    { 4   ;   ;User Password Key   ;GUID          ;DataClassification=EndUserPseudonymousIdentifiers;
                                                   CaptionML=[DAN=Brugeradgangsn›gle;
                                                              ENU=User Password Key] }
    { 5   ;   ;Last Update Invoice Entry No.;Integer;
                                                   CaptionML=[DAN=Sidste opdatering af faktural›benr.;
                                                              ENU=Last Update Invoice Entry No.];
                                                   Editable=No }
    { 60  ;   ;Is Enabled          ;Boolean       ;OnValidate=BEGIN
                                                                EnableCRMConnection;
                                                                UpdateIsEnabledState;
                                                                RefreshDataFromCRM;
                                                              END;

                                                   CaptionML=[DAN=Er aktiveret;
                                                              ENU=Is Enabled] }
    { 61  ;   ;Is User Mapping Required;Boolean   ;OnValidate=BEGIN
                                                                UpdateAllConnectionRegistrations;
                                                                UpdateIsEnabledState;
                                                              END;

                                                   CaptionML=[DAN=Dynamics NAV-brugere skal knyttes til Dynamics 365 for Sales-brugere;
                                                              ENU=Dynamics NAV Users Must Map to Dynamics 365 for Sales Users] }
    { 62  ;   ;Is User Mapped To CRM User;Boolean ;CaptionML=[DAN=Er bruger knyttet til CRM-bruger;
                                                              ENU=Is User Mapped To CRM User] }
    { 63  ;   ;CRM Version         ;Text30        ;CaptionML=[DAN=CRM-version;
                                                              ENU=CRM Version] }
    { 66  ;   ;Is S.Order Integration Enabled;Boolean;
                                                   OnValidate=BEGIN
                                                                IF "Is S.Order Integration Enabled" THEN
                                                                  IF CONFIRM(STRSUBSTNO(SetCRMSOPEnableQst,PRODUCTNAME.SHORT)) THEN
                                                                    SetCRMSOPEnabled
                                                                  ELSE
                                                                    ERROR('')
                                                                ELSE
                                                                  SetCRMSOPDisabled;
                                                                RefreshDataFromCRM;

                                                                IF "Is S.Order Integration Enabled" THEN
                                                                  MESSAGE(SetCRMSOPEnableConfirmMsg,CRMProductName.SHORT)
                                                                ELSE
                                                                  MESSAGE(SetCRMSOPDisableConfirmMsg,CRMProductName.SHORT);
                                                              END;

                                                   CaptionML=[DAN=Er salgsordreintegration aktiveret;
                                                              ENU=Is S.Order Integration Enabled] }
    { 67  ;   ;Is CRM Solution Installed;Boolean  ;CaptionML=[DAN=Er CRM-l›sning installeret;
                                                              ENU=Is CRM Solution Installed] }
    { 68  ;   ;Is Enabled For User ;Boolean       ;CaptionML=[DAN=Er aktiveret til bruger;
                                                              ENU=Is Enabled For User] }
    { 69  ;   ;Dynamics NAV URL    ;Text250       ;OnValidate=BEGIN
                                                                CRMIntegrationManagement.SetCRMNAVConnectionUrl("Dynamics NAV URL");
                                                              END;

                                                   CaptionML=[DAN=Dynamics NAV URL-adresse;
                                                              ENU=Dynamics NAV URL] }
    { 70  ;   ;Dynamics NAV OData URL;Text250     ;OnValidate=BEGIN
                                                                CRMIntegrationManagement.SetCRMNAVODataUrlCredentials(
                                                                  "Dynamics NAV OData URL","Dynamics NAV OData Username","Dynamics NAV OData Accesskey");
                                                              END;

                                                   CaptionML=[DAN=URL-adresse for Dynamics NAV OData;
                                                              ENU=Dynamics NAV OData URL] }
    { 71  ;   ;Dynamics NAV OData Username;Text250;OnValidate=VAR
                                                                User@1000 : Record 2000000120;
                                                              BEGIN
                                                                User.SETRANGE("User Name","Dynamics NAV OData Username");
                                                                IF User.FINDFIRST THEN
                                                                  UpdateODataUsernameAccesskey(User)
                                                                ELSE BEGIN
                                                                  "Dynamics NAV OData Username" := '';
                                                                  "Dynamics NAV OData Accesskey" := '';
                                                                END;
                                                              END;

                                                   OnLookup=VAR
                                                              User@1000 : Record 2000000120;
                                                            BEGIN
                                                              IF PAGE.RUNMODAL(PAGE::Users,User) = ACTION::LookupOK THEN
                                                                UpdateODataUsernameAccesskey(User);
                                                            END;

                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Brugernavn for Dynamics NAV OData;
                                                              ENU=Dynamics NAV OData Username] }
    { 72  ;   ;Dynamics NAV OData Accesskey;Text250;
                                                   CaptionML=[DAN=Adgangsn›gle for Dynamics NAV OData;
                                                              ENU=Dynamics NAV OData Accesskey] }
    { 75  ;   ;Default CRM Price List ID;GUID     ;CaptionML=[DAN=Standard-id for CRM-prisliste;
                                                              ENU=Default CRM Price List ID] }
    { 80  ;   ;Auto Create Sales Orders;Boolean   ;OnValidate=VAR
                                                                CRMSetupDefaults@1000 : Codeunit 5334;
                                                              BEGIN
                                                                IF "Auto Create Sales Orders" THEN
                                                                  CRMSetupDefaults.RecreateAutoCreateSalesOrdersJobQueueEntry(DoReadCRMData)
                                                                ELSE
                                                                  CRMSetupDefaults.DeleteAutoCreateSalesOrdersJobQueueEntry;
                                                              END;

                                                   CaptionML=[DAN=Opret salgsordrer automatisk;
                                                              ENU=Automatically Create Sales Orders] }
    { 118 ;   ;CurrencyDecimalPrecision;Integer   ;CaptionML=[DAN=Valutadecimalpr‘cision;
                                                              ENU=Currency Decimal Precision];
                                                   Description=Number of decimal places that can be used for currency. }
    { 124 ;   ;BaseCurrencyId      ;GUID          ;TableRelation="CRM Transactioncurrency".TransactionCurrencyId;
                                                   ExternalAccess=Insert;
                                                   CaptionML=[DAN=Valuta;
                                                              ENU=Currency];
                                                   Description=Unique identifier of the base currency of the organization. }
    { 133 ;   ;BaseCurrencyPrecision;Integer      ;ExternalAccess=Read;
                                                   CaptionML=[DAN=Basisvalutapr‘cision;
                                                              ENU=Base Currency Precision];
                                                   MinValue=0;
                                                   MaxValue=4;
                                                   Description=Number of decimal places that can be used for the base currency. }
    { 134 ;   ;BaseCurrencySymbol  ;Text5         ;ExternalAccess=Read;
                                                   CaptionML=[DAN=Basisvalutasymbol;
                                                              ENU=Base Currency Symbol];
                                                   Description=Symbol used for the base currency. }
    { 135 ;   ;Authentication Type ;Option        ;OnValidate=BEGIN
                                                                IF xRec."Authentication Type" <> "Authentication Type" THEN
                                                                  VALIDATE("Is User Mapping Required",FALSE);
                                                                CASE "Authentication Type" OF
                                                                  "Authentication Type"::Office365:
                                                                    Domain := '';
                                                                  "Authentication Type"::AD:
                                                                    UpdateDomainName;
                                                                END;
                                                                UpdateConnectionString;
                                                              END;

                                                   CaptionML=[DAN=Godkendelsestype;
                                                              ENU=Authentication Type];
                                                   OptionCaptionML=[DAN=Office365,AD,IFD,OAuth;
                                                                    ENU=Office365,AD,IFD,OAuth];
                                                   OptionString=Office365,AD,IFD,OAuth }
    { 136 ;   ;Connection String   ;Text250       ;CaptionML=[DAN=Forbindelsesstreng;
                                                              ENU=Connection String] }
    { 137 ;   ;Domain              ;Text250       ;DataClassification=OrganizationIdentifiableInformation;
                                                   CaptionML=[DAN=Dom‘ne;
                                                              ENU=Domain];
                                                   Editable=No }
    { 138 ;   ;Server Connection String;BLOB      ;CaptionML=[DAN=Serverforbindelsesstreng;
                                                              ENU=Server Connection String] }
  }
  KEYS
  {
    {    ;Primary Key                             ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      CRMIntegrationManagement@1055 : Codeunit 5330;
      CantRegisterDisabledConnectionErr@1001 : TextConst 'DAN=En deaktiveret forbindelse kan ikke registreres.;ENU=A disabled connection cannot be registered.';
      ConnectionErr@1009 : TextConst '@@@=%1 Error message from the provider (.NET exception message);DAN=Ops‘tningen af forbindelsen kan ikke valideres. Kontroll‚r indstillingerne, og pr›v igen.\Detaljeret fejlbeskrivelse: %1.;ENU=The connection setup cannot be validated. Verify the settings and try again.\Detailed error description: %1.';
      ConnectionStringFormatTok@1000 : TextConst '@@@={Locked};DAN="Url=%1; UserName=%2; Password=%3; %4";ENU="Url=%1; UserName=%2; Password=%3; %4"';
      ConnectionSuccessMsg@1008 : TextConst 'DAN=Forbindelsen blev afpr›vet uden fejl. Indstillingerne er gyldige.;ENU=The connection test was successful. The settings are valid.';
      ConnectionSuccessNotEnabledForCurrentUserMsg@1007 : TextConst '@@@="%1 = Current User ID, %2 - product name, %3 = CRM product name";DAN=Forbindelsestesten er gennemf›rt. Indstillingerne er gyldige.\\Men da feltet %2-brugere skal knyttes til %3-brugere er markeret, er integration af %3 ikke aktiveret for %1.;ENU=The connection test was successful. The settings are valid.\\However, because the %2 Users Must Map to %3 Users field is set, %3 integration is not enabled for %1.';
      CannotResolveUserFromConnectionSetupErr@1013 : TextConst '@@@="%1 = CRM product name";DAN=Den %1-bruger, der er angivet i CRM-forbindelseskonfigurationen, findes ikke.;ENU=The %1 user that is specified in the CRM connection setup does not exist.';
      DetailsMissingErr@1006 : TextConst '@@@="%1 = CRM product name";DAN=En URL-adresse for %1, brugernavn og adgangskode er p†kr‘vet for at aktivere en forbindelse.;ENU=A %1 URL, user name and password are required to enable a connection.';
      UnableToRetrieveCrmVersionErr@1004 : TextConst '@@@="%1 = CRM product name";DAN=%1-versionen kunne ikke hentes.;ENU=Unable to retrieve the %1 version.';
      MissingUsernameTok@1003 : TextConst '@@@={Locked};DAN={USER};ENU={USER}';
      MissingPasswordTok@1005 : TextConst '@@@={Locked};DAN={PASSWORD};ENU={PASSWORD}';
      ProcessDialogMapTitleMsg@1011 : TextConst '@@@=@1 Progress dialog map no.;DAN=Synkroniserer @1;ENU=Synchronizing @1';
      UserCRMSetupTxt@1015 : TextConst 'DAN=Bruger-CRM-konfiguration;ENU=User CRM Setup';
      CannotConnectCRMErr@1014 : TextConst '@@@=%1 - email of the user;DAN=Systemet kan ikke oprette forbindelse til Microsoft Dynamics 365. Kontroll‚r legitimationsoplysningerne for forbindelsen for brugernavnet %1.;ENU=The system is unable to connect to Microsoft Dynamics 365. Verify credentials of the connection for the user name %1.';
      LCYMustMatchBaseCurrencyErr@1016 : TextConst '@@@=%1,%2 - ISO currency codes;DAN=RV-koden %1 stemmer ikke overens med valutakoden %2 for CRM-basisvalutaen.;ENU=LCY Code %1 does not match ISO Currency Code %2 of the CRM base currency.';
      UserNameMustIncludeDomainErr@1020 : TextConst 'DAN=Brugernavnet skal omfatte det dom‘ne, hvor godkendelsestypen er angivet til Active Directory.;ENU=The user name must include the domain when the authentication type is set to Active Directory.';
      UserNameMustBeEmailErr@1021 : TextConst 'DAN=Brugernavnet skal v‘re en gyldig mailadresse, hvor godkendelsestypen er angivet til Office 365.;ENU=The user name must be a valid email address when the authentication type is set to Office 365.';
      ConnectionStringPwdPlaceHolderMissingErr@1028 : TextConst 'DAN=Forbindelsesstrengen skal omfatte adgangskodens pladsholder {ADGANGSKODE}.;ENU=The connection string must include the password placeholder {PASSWORD}.';
      CannotDisableSalesOrderIntErr@1010 : TextConst 'DAN=Du kan ikke deaktivere integration af CRM-salgsordrer, n†r en CRM-salgsordre har statussen Sendt.;ENU=You cannot disable CRM sales order integration when a CRM sales order has the Submitted status.';
      SetCRMSOPEnableQst@1018 : TextConst '@@@=%1 - product name;DAN=N†r du aktiverer salgsordreintegration, kan du oprette %1 salgsordrer fra Dynamics CRM.\\Hvis du vil aktivere denne indstilling, skal du angive legitimationsoplysninger for Dynamics CRM-administratoren (brugernavn og adgangskode).\\Vil du forts‘tte?;ENU=Enabling Sales Order Integration will allow you to create %1 Sales Orders from Dynamics CRM.\\To enable this setting, you must provide Dynamics CRM administrator credentials (user name and password).\\Do you want to continue?';
      SetCRMSOPEnableConfirmMsg@1017 : TextConst '@@@="%1 = CRM product name";DAN=Integration af salgsordrer med %1 er aktiveret.;ENU=Sales Order Integration with %1 is enabled.';
      SetCRMSOPDisableConfirmMsg@1019 : TextConst '@@@="%1 = CRM product name";DAN=Integration af salgsordrer med %1 er deaktiveret.;ENU=Sales Order Integration with %1 is disabled.';
      CRMProductName@1002 : Codeunit 5344;

    [External]
    PROCEDURE CountCRMJobQueueEntries@30(VAR ActiveJobs@1000 : Integer;VAR TotalJobs@1001 : Integer);
    VAR
      JobQueueEntry@1002 : Record 472;
    BEGIN
      IF NOT "Is Enabled" THEN BEGIN
        TotalJobs := 0;
        ActiveJobs := 0;
      END ELSE BEGIN
        IF "Is CRM Solution Installed" THEN
          JobQueueEntry.SETFILTER("Object ID to Run",GetJobQueueEntriesObjectIDToRunFilter)
        ELSE
          JobQueueEntry.SETRANGE("Object ID to Run",CODEUNIT::"Integration Synch. Job Runner");
        TotalJobs := JobQueueEntry.COUNT;

        JobQueueEntry.SETFILTER(Status,'%1|%2',JobQueueEntry.Status::Ready,JobQueueEntry.Status::"In Process");
        ActiveJobs := JobQueueEntry.COUNT;
      END;
    END;

    [External]
    PROCEDURE HasPassword@8() : Boolean;
    BEGIN
      EXIT(GetPassword <> '');
    END;

    [External]
    PROCEDURE SetPassword@1(PasswordText@1000 : Text);
    VAR
      ServicePassword@1002 : Record 1261;
    BEGIN
      IF ISNULLGUID("User Password Key") OR NOT ServicePassword.GET("User Password Key") THEN BEGIN
        ServicePassword.SavePassword(PasswordText);
        ServicePassword.INSERT(TRUE);
        "User Password Key" := ServicePassword.Key;
      END ELSE BEGIN
        ServicePassword.SavePassword(PasswordText);
        ServicePassword.MODIFY;
      END;
    END;

    [Internal]
    PROCEDURE UpdateAllConnectionRegistrations@4();
    BEGIN
      UNREGISTERTABLECONNECTION(TABLECONNECTIONTYPE::CRM,GETDEFAULTTABLECONNECTION(TABLECONNECTIONTYPE::CRM));

      UnregisterConnection;
      IF "Is Enabled" THEN
        RegisterUserConnection;
    END;

    [External]
    PROCEDURE UpdateIsEnabledState@34();
    BEGIN
      "Is User Mapped To CRM User" := IsCurrentUserMappedToCrmSystemUser;
      "Is Enabled For User" :=
        "Is Enabled" AND
        ((NOT "Is User Mapping Required") OR ("Is User Mapping Required" AND "Is User Mapped To CRM User"));
    END;

    LOCAL PROCEDURE UpdateODataUsernameAccesskey@43(User@1000 : Record 2000000120);
    VAR
      IdentityManagement@1001 : Codeunit 9801;
    BEGIN
      "Dynamics NAV OData Username" := User."User Name";
      "Dynamics NAV OData Accesskey" := IdentityManagement.GetWebServicesKey(User."User Security ID");

      CRMIntegrationManagement.SetCRMNAVODataUrlCredentials(
        "Dynamics NAV OData URL","Dynamics NAV OData Username","Dynamics NAV OData Accesskey");
    END;

    [External]
    PROCEDURE RegisterConnection@17();
    BEGIN
      IF NOT HASTABLECONNECTION(TABLECONNECTIONTYPE::CRM,"Primary Key") THEN
        RegisterConnectionWithName("Primary Key");
    END;

    [External]
    PROCEDURE RegisterConnectionWithName@12(ConnectionName@1000 : Text);
    BEGIN
      REGISTERTABLECONNECTION(TABLECONNECTIONTYPE::CRM,ConnectionName,GetConnectionStringWithPassword);
      SETDEFAULTTABLECONNECTION(TABLECONNECTIONTYPE::CRM,GetDefaultCRMConnection(ConnectionName));
    END;

    [External]
    PROCEDURE UnregisterConnection@5() : Boolean;
    BEGIN
      EXIT(UnregisterConnectionWithName("Primary Key"));
    END;

    [TryFunction]
    [External]
    PROCEDURE UnregisterConnectionWithName@20(ConnectionName@1000 : Text);
    BEGIN
      UNREGISTERTABLECONNECTION(TABLECONNECTIONTYPE::CRM,ConnectionName);
    END;

    LOCAL PROCEDURE ConstructConnectionStringWithCalledID@16(CallerID@1000 : Text) : Text;
    BEGIN
      EXIT(GetConnectionStringWithPassword + 'CallerID=' + CallerID);
    END;

    LOCAL PROCEDURE GetConnectionStringWithPassword@53() ConnectionString : Text;
    VAR
      PasswordPlaceHolderPos@1000 : Integer;
    BEGIN
      ConnectionString := GetConnectionString;
      IF ConnectionString = '' THEN
        ConnectionString := UpdateConnectionString;
      IF "User Name" = '' THEN
        EXIT(ConnectionString);
      PasswordPlaceHolderPos := STRPOS(ConnectionString,MissingPasswordTok);
      ConnectionString :=
        COPYSTR(ConnectionString,1,PasswordPlaceHolderPos - 1) + GetPassword +
        COPYSTR(ConnectionString,PasswordPlaceHolderPos + STRLEN(MissingPasswordTok));
    END;

    [Internal]
    PROCEDURE RegisterUserConnection@6() ConnectionName : Text;
    VAR
      SyncUser@1000 : Record 2000000120;
      CallerID@1001 : GUID;
    BEGIN
      RegisterConnection;
      SyncUser."User Name" := COPYSTR("User Name",1,MAXSTRLEN(SyncUser."User Name"));
      SyncUser."Authentication Email" := "User Name";
      IF NOT TryGetSystemUserId(SyncUser,CallerID) THEN BEGIN
        UnregisterConnection;
        VALIDATE("Is Enabled",FALSE);
        VALIDATE("Is User Mapping Required",FALSE);
        MODIFY;
        ShowError(UserCRMSetupTxt,STRSUBSTNO(CannotConnectCRMErr,"User Name"));
      END ELSE
        ConnectionName := RegisterAuthUserConnection;
    END;

    LOCAL PROCEDURE RegisterAuthUserConnection@42() ConnectionName : Text;
    VAR
      User@1001 : Record 2000000120;
      CallerID@1000 : GUID;
    BEGIN
      IF GetUser(User) THEN
        IF NOT TryGetSystemUserId(User,CallerID) THEN BEGIN
          UnregisterConnection;
          ShowError(UserCRMSetupTxt,STRSUBSTNO(CannotConnectCRMErr,User."Authentication Email"));
        END ELSE
          IF NOT ISNULLGUID(CallerID) THEN BEGIN
            UnregisterConnection;
            ConnectionName := RegisterConnectionWithCallerID(CallerID);
          END;
    END;

    LOCAL PROCEDURE RegisterConnectionWithCallerID@11(CallerID@1000 : Text) ConnectionName : Text;
    BEGIN
      IF "Is Enabled" THEN BEGIN
        REGISTERTABLECONNECTION(TABLECONNECTIONTYPE::CRM,"Primary Key",ConstructConnectionStringWithCalledID(CallerID));
        ConnectionName := "Primary Key";
        IF "Primary Key" = '' THEN BEGIN
          ConnectionName := GetDefaultCRMConnection("Primary Key");
          SETDEFAULTTABLECONNECTION(TABLECONNECTIONTYPE::CRM,ConnectionName);
        END;
      END ELSE
        ShowError(UserCRMSetupTxt,CantRegisterDisabledConnectionErr);
    END;

    [External]
    PROCEDURE GetIntegrationUserID@7() IntegrationUserID : GUID;
    VAR
      CRMSystemuser@1001 : Record 5340;
    BEGIN
      GET;
      TESTFIELD("Is Enabled");
      FilterCRMSystemUser(CRMSystemuser);
      IF CRMSystemuser.FINDFIRST THEN
        IntegrationUserID := CRMSystemuser.SystemUserId;
      IF ISNULLGUID(IntegrationUserID) THEN
        ShowError(UserCRMSetupTxt,STRSUBSTNO(CannotResolveUserFromConnectionSetupErr,CRMProductName.SHORT));
    END;

    LOCAL PROCEDURE GetPassword@2() : Text;
    VAR
      ServicePassword@1000 : Record 1261;
    BEGIN
      IF NOT ISNULLGUID("User Password Key") THEN
        IF ServicePassword.GET("User Password Key") THEN
          EXIT(ServicePassword.GetPassword);
    END;

    LOCAL PROCEDURE GetUser@51(VAR User@1000 : Record 2000000120) : Boolean;
    BEGIN
      IF User.GET(DATABASE.USERSECURITYID) THEN
        EXIT(TRUE);
      User.RESET;
      User.SETRANGE("Windows Security ID",SID);
      EXIT(User.FINDFIRST);
    END;

    LOCAL PROCEDURE GetUserName@60() UserName : Text;
    BEGIN
      IF "User Name" = '' THEN
        UserName := MissingUsernameTok
      ELSE
        UserName := COPYSTR("User Name",STRPOS("User Name",'\') + 1);
    END;

    PROCEDURE GetJobQueueEntriesObjectIDToRunFilter@58() : Text;
    BEGIN
      EXIT(
        STRSUBSTNO(
          '%1|%2|%3',
          CODEUNIT::"Integration Synch. Job Runner",
          CODEUNIT::"CRM Statistics Job",
          CODEUNIT::"Auto Create Sales Orders"));
    END;

    [Internal]
    PROCEDURE PerformTestConnection@19();
    BEGIN
      VerifyTestConnection;

      IF "Is User Mapping Required" AND "Is Enabled" THEN
        IF NOT IsCurrentUserMappedToCrmSystemUser THEN BEGIN
          MESSAGE(ConnectionSuccessNotEnabledForCurrentUserMsg,USERID,PRODUCTNAME.SHORT,CRMProductName.SHORT);
          EXIT;
        END;

      MESSAGE(ConnectionSuccessMsg);
    END;

    [Internal]
    PROCEDURE VerifyTestConnection@21() : Boolean;
    BEGIN
      IF ("Server Address" = '') OR ("User Name" = '') OR NOT HasPassword THEN
        ERROR(DetailsMissingErr,CRMProductName.SHORT);

      CRMIntegrationManagement.ClearState;

      IF NOT TestConnection THEN
        ERROR(ConnectionErr,CRMIntegrationManagement.GetLastErrorMessage);

      EXIT(TRUE);
    END;

    [External]
    PROCEDURE TestConnection@9() Success : Boolean;
    VAR
      TestConnectionName@1000 : Text;
    BEGIN
      TestConnectionName := FORMAT(CREATEGUID);
      UnregisterConnectionWithName(TestConnectionName);
      RegisterConnectionWithName(TestConnectionName);
      SETDEFAULTTABLECONNECTION(
        TABLECONNECTIONTYPE::CRM,GetDefaultCRMConnection(TestConnectionName),TRUE);
      Success := TryReadSystemUsers;

      UnregisterConnectionWithName(TestConnectionName);
    END;

    [TryFunction]
    LOCAL PROCEDURE TryReadSystemUsers@14();
    VAR
      CRMSystemuser@1000 : Record 5340;
    BEGIN
      CRMSystemuser.FINDFIRST;
    END;

    LOCAL PROCEDURE CreateOrganizationService@10(VAR service@1000 : DotNet "'Microsoft.Xrm.Sdk, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Xrm.Sdk.IOrganizationService");
    VAR
      crmConnection@1002 : DotNet "'Microsoft.Xrm.Tooling.Connector, Version=2.2.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Xrm.Tooling.Connector.CrmServiceClient";
    BEGIN
      crmConnection := crmConnection.CrmServiceClient(GetConnectionStringWithPassword);
      IF crmConnection.IsReady THEN BEGIN
        IF NOT ISNULL(crmConnection.OrganizationWebProxyClient) THEN
          service := crmConnection.OrganizationWebProxyClient
        ELSE
          service := crmConnection.OrganizationServiceProxy;
        EXIT;
      END;

      IF NOT ISNULL(crmConnection.LastCrmException) THEN
        ERROR(crmConnection.LastCrmException.Message);
      ERROR(crmConnection.LastCrmError);
    END;

    [TryFunction]
    LOCAL PROCEDURE GetCrmVersion@15(VAR Version@1003 : Text);
    VAR
      service@1000 : DotNet "'Microsoft.Xrm.Sdk, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Xrm.Sdk.IOrganizationService";
      request@1001 : DotNet "'Microsoft.Xrm.Sdk, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Xrm.Sdk.OrganizationRequest";
      response@1002 : DotNet "'Microsoft.Xrm.Sdk, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Xrm.Sdk.OrganizationResponse";
    BEGIN
      IF NOT DoReadCRMData THEN
        EXIT;

      Version := '';
      CreateOrganizationService(service);
      request := request.OrganizationRequest;
      request.RequestName := 'RetrieveVersion';
      response := service.Execute(request);
      IF NOT response.Results.TryGetValue('Version',Version) THEN
        ERROR(UnableToRetrieveCrmVersionErr,CRMProductName.SHORT);
    END;

    [External]
    PROCEDURE IsVersionValid@33() : Boolean;
    VAR
      Version@1000 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Version";
    BEGIN
      IF "CRM Version" <> '' THEN
        IF Version.TryParse("CRM Version",Version) THEN
          EXIT((Version.Major > 6) AND NOT ((Version.Major = 7) AND (Version.Minor = 1)));
      EXIT(FALSE);
    END;

    [Internal]
    PROCEDURE IsCurrentUserMappedToCrmSystemUser@13() : Boolean;
    VAR
      User@1000 : Record 2000000120;
      CRMSystemUserId@1002 : GUID;
    BEGIN
      IF GetUser(User) THEN
        IF TryGetSystemUserId(User,CRMSystemUserId) THEN
          EXIT(NOT ISNULLGUID(CRMSystemUserId));
    END;

    [TryFunction]
    LOCAL PROCEDURE TryGetSystemUserId@18(User@1003 : Record 2000000120;VAR SystemUserId@1001 : GUID);
    VAR
      CRMSystemuser@1002 : Record 5340;
    BEGIN
      // Returns FALSE if CRMSystemuser.FINDFIRST throws an exception, e.g. due to wrong credentials;
      // Returns TRUE regardless of CRMSystemuser.FINDFIRST result,
      // further check of ISNULLGUID(SystemUserId) is required to identify if the user exists
      CLEAR(SystemUserId);
      IF "Is Enabled" THEN
        IF "Is User Mapping Required" THEN BEGIN
          CRMSystemuser.SETRANGE(IsDisabled,FALSE);
          CASE "Authentication Type" OF
            "Authentication Type"::AD,"Authentication Type"::IFD:
              CRMSystemuser.SETRANGE(DomainName,User."User Name");
            "Authentication Type"::Office365,"Authentication Type"::OAuth:
              CRMSystemuser.SETRANGE(InternalEMailAddress,User."Authentication Email");
          END;
          IF CRMSystemuser.FINDFIRST THEN
            SystemUserId := CRMSystemuser.SystemUserId;
        END;
    END;

    [External]
    PROCEDURE UpdateFromWizard@23(VAR SourceCRMConnectionSetup@1001 : Record 5330;PasswordText@1002 : Text);
    BEGIN
      IF NOT GET THEN BEGIN
        INIT;
        INSERT;
      END;
      VALIDATE("Server Address",SourceCRMConnectionSetup."Server Address");
      VALIDATE("Authentication Type","Authentication Type"::Office365);
      VALIDATE("User Name",SourceCRMConnectionSetup."User Name");
      SetPassword(PasswordText);
      MODIFY(TRUE);
    END;

    LOCAL PROCEDURE EnableCRMConnection@24();
    BEGIN
      IF "Is Enabled" = xRec."Is Enabled" THEN
        EXIT;

      IF NOT UnregisterConnection THEN
        CLEARLASTERROR;

      IF "Is Enabled" THEN BEGIN
        VerifyTestConnection;
        RegisterUserConnection;
        VerifyBaseCurrencyMatchesLCY;
        EnableIntegrationTables;
      END ELSE BEGIN
        "CRM Version" := '';
        "Is S.Order Integration Enabled" := FALSE;
        "Is CRM Solution Installed" := FALSE;
        CurrencyDecimalPrecision := 0;
        CLEAR(BaseCurrencyId);
        BaseCurrencyPrecision := 0;
        BaseCurrencySymbol := '';
        UpdateCRMJobQueueEntriesStatus;
      END;
    END;

    LOCAL PROCEDURE EnableIntegrationTables@27();
    VAR
      IntegrationTableMapping@1003 : Record 5335;
      IntegrationRecord@1002 : Record 5151;
      IntegrationManagement@1001 : Codeunit 5150;
      CRMSetupDefaults@1000 : Codeunit 5334;
    BEGIN
      IF IntegrationRecord.ISEMPTY THEN
        IntegrationManagement.SetupIntegrationTables;
      IntegrationManagement.SetConnectorIsEnabledForSession(TRUE);
      IF IntegrationTableMapping.ISEMPTY THEN BEGIN
        MODIFY; // Job Queue to read "Is Enabled"
        COMMIT;
        CRMSetupDefaults.ResetConfiguration(Rec);
      END ELSE
        UpdateCRMJobQueueEntriesStatus;
    END;

    [External]
    PROCEDURE EnableCRMConnectionFromWizard@25();
    VAR
      CRMSystemuser@1001 : Record 5340;
    BEGIN
      GET;
      "Is User Mapping Required" := FALSE;
      VALIDATE("Is Enabled",TRUE);
      MODIFY(TRUE);

      FilterCRMSystemUser(CRMSystemuser);
      CRMSystemuser.FINDFIRST;
      IF (CRMSystemuser.InviteStatusCode <> CRMSystemuser.InviteStatusCode::InvitationAccepted) OR
         (NOT CRMSystemuser.IsIntegrationUser)
      THEN BEGIN
        CRMSystemuser.InviteStatusCode := CRMSystemuser.InviteStatusCode::InvitationAccepted;
        CRMSystemuser.IsIntegrationUser := TRUE;
        CRMSystemuser.MODIFY(TRUE);
      END;
    END;

    [External]
    PROCEDURE SetCRMSOPEnabled@37();
    BEGIN
      TESTFIELD("Is CRM Solution Installed",TRUE);
      SetCRMSOPEnabledWithCredentials('',CREATEGUID,TRUE);
    END;

    PROCEDURE SetCRMSOPDisabled@55();
    VAR
      CRMSalesorder@1000 : Record 5353;
    BEGIN
      CRMSalesorder.SETRANGE(StateCode,CRMSalesorder.StateCode::Submitted);
      IF NOT CRMSalesorder.ISEMPTY THEN
        ERROR(CannotDisableSalesOrderIntErr);
      SetCRMSOPEnabledWithCredentials('',CREATEGUID,FALSE);
      VALIDATE("Auto Create Sales Orders",FALSE);
    END;

    [External]
    PROCEDURE SetCRMSOPEnabledWithCredentials@36(AdminEmail@1003 : Text[250];AdminPassKey@1004 : GUID;SOPIntegrationEnable@1006 : Boolean);
    VAR
      CRMOrganization@1000 : Record 5363;
      TempCRMConnectionSetup@1001 : TEMPORARY Record 5330;
      ServicePassword@1005 : Record 1261;
      ConnectionName@1002 : Text;
    BEGIN
      CreateTempAdminConnection(TempCRMConnectionSetup);
      IF (AdminEmail <> '') AND (NOT ISNULLGUID(AdminPassKey)) THEN BEGIN
        ServicePassword.GET(AdminPassKey);
        TempCRMConnectionSetup.SetPassword(ServicePassword.GetPassword);
        TempCRMConnectionSetup.VALIDATE("User Name",AdminEmail);
      END;
      ConnectionName := FORMAT(CREATEGUID);
      TempCRMConnectionSetup.RegisterConnectionWithName(ConnectionName);
      SETDEFAULTTABLECONNECTION(
        TABLECONNECTIONTYPE::CRM,GetDefaultCRMConnection(ConnectionName),TRUE);

      CRMOrganization.FINDFIRST;
      IF CRMOrganization.IsSOPIntegrationEnabled <> SOPIntegrationEnable THEN BEGIN
        CRMOrganization.IsSOPIntegrationEnabled := SOPIntegrationEnable;
        CRMOrganization.MODIFY(TRUE);
      END;

      TempCRMConnectionSetup.UnregisterConnectionWithName(ConnectionName);
    END;

    [External]
    PROCEDURE SetUserAsIntegrationUser@39();
    VAR
      CRMSystemuser@1000 : Record 5340;
      TempCRMConnectionSetup@1001 : TEMPORARY Record 5330;
      ConnectionName@1002 : Text;
    BEGIN
      CreateTempAdminConnection(TempCRMConnectionSetup);
      ConnectionName := FORMAT(CREATEGUID);
      TempCRMConnectionSetup.RegisterConnectionWithName(ConnectionName);
      SETDEFAULTTABLECONNECTION(
        TABLECONNECTIONTYPE::CRM,GetDefaultCRMConnection(ConnectionName),TRUE);
      FilterCRMSystemUser(CRMSystemuser);
      CRMSystemuser.FINDFIRST;

      IF (CRMSystemuser.InviteStatusCode <> CRMSystemuser.InviteStatusCode::InvitationAccepted) OR
         (NOT CRMSystemuser.IsIntegrationUser)
      THEN BEGIN
        CRMSystemuser.InviteStatusCode := CRMSystemuser.InviteStatusCode::InvitationAccepted;
        CRMSystemuser.IsIntegrationUser := TRUE;
        CRMSystemuser.MODIFY(TRUE);
      END;

      TempCRMConnectionSetup.UnregisterConnectionWithName(ConnectionName);
    END;

    LOCAL PROCEDURE CreateTempAdminConnection@40(VAR CRMConnectionSetup@1000 : Record 5330);
    BEGIN
      CreateTempNoDelegateConnection(CRMConnectionSetup);
      CLEAR(CRMConnectionSetup."User Password Key");
      CRMConnectionSetup.VALIDATE("User Name",'');
    END;

    LOCAL PROCEDURE CreateTempNoDelegateConnection@41(VAR CRMConnectionSetup@1000 : Record 5330);
    BEGIN
      CRMConnectionSetup.INIT;
      CALCFIELDS("Server Connection String");
      CRMConnectionSetup.TRANSFERFIELDS(Rec);
      CRMConnectionSetup."Primary Key" := COPYSTR('TEMP' + "Primary Key",1,MAXSTRLEN(CRMConnectionSetup."Primary Key"));
      CRMConnectionSetup."Is Enabled" := TRUE;
      CRMConnectionSetup."Is User Mapping Required" := FALSE;
    END;

    [Internal]
    PROCEDURE RefreshDataFromCRM@31();
    VAR
      TempCRMConnectionSetup@1000 : TEMPORARY Record 5330;
      ConnectionName@1001 : Text;
    BEGIN
      IF "Is Enabled" THEN BEGIN
        IF "Is User Mapping Required" THEN BEGIN
          CreateTempNoDelegateConnection(TempCRMConnectionSetup);
          ConnectionName := FORMAT(CREATEGUID);
          TempCRMConnectionSetup.RegisterConnectionWithName(ConnectionName);
          "Is User Mapped To CRM User" := IsCurrentUserMappedToCrmSystemUser;
        END;

        "Is CRM Solution Installed" := CRMIntegrationManagement.IsCRMSolutionInstalled;
        RefreshFromCRMConnectionInformation;
        IF TryRefreshCRMSettings THEN;

        IF ConnectionName <> '' THEN
          TempCRMConnectionSetup.UnregisterConnectionWithName(ConnectionName);
      END;
    END;

    LOCAL PROCEDURE RefreshFromCRMConnectionInformation@29();
    VAR
      CRMNAVConnection@1001 : Record 5368;
    BEGIN
      IF "Is CRM Solution Installed" THEN
        IF CRMNAVConnection.FINDFIRST THEN BEGIN
          "Dynamics NAV URL" := CRMNAVConnection."Dynamics NAV URL";
          "Dynamics NAV OData URL" := CRMNAVConnection."Dynamics NAV OData URL";
          "Dynamics NAV OData Username" := CRMNAVConnection."Dynamics NAV OData Username";
          "Dynamics NAV OData Accesskey" := CRMNAVConnection."Dynamics NAV OData Accesskey";
        END;
    END;

    [TryFunction]
    LOCAL PROCEDURE TryRefreshCRMSettings@26();
    VAR
      CRMOrganization@1001 : Record 5363;
    BEGIN
      GetCrmVersion("CRM Version");
      VALIDATE("CRM Version");

      IF CRMOrganization.FINDFIRST THEN BEGIN
        "Is S.Order Integration Enabled" := CRMOrganization.IsSOPIntegrationEnabled;
        CurrencyDecimalPrecision := CRMOrganization.CurrencyDecimalPrecision;
        BaseCurrencyId := CRMOrganization.BaseCurrencyId;
        BaseCurrencyPrecision := CRMOrganization.BaseCurrencyPrecision;
        BaseCurrencySymbol := CRMOrganization.BaseCurrencySymbol;
      END ELSE
        "Is S.Order Integration Enabled" := FALSE;
    END;

    LOCAL PROCEDURE VerifyBaseCurrencyMatchesLCY@35();
    VAR
      CRMOrganization@1001 : Record 5363;
      CRMTransactioncurrency@1002 : Record 5345;
      GLSetup@1000 : Record 98;
    BEGIN
      CRMOrganization.FINDFIRST;
      CRMTransactioncurrency.GET(CRMOrganization.BaseCurrencyId);
      GLSetup.GET;
      IF DELCHR(CRMTransactioncurrency.ISOCurrencyCode) <> DELCHR(GLSetup."LCY Code") THEN
        ERROR(STRSUBSTNO(LCYMustMatchBaseCurrencyErr,GLSetup."LCY Code",CRMTransactioncurrency.ISOCurrencyCode));
    END;

    [Internal]
    PROCEDURE PerformWebClientUrlReset@32();
    VAR
      TempCRMConnectionSetup@1000 : TEMPORARY Record 5330;
      CRMSetupDefaults@1002 : Codeunit 5334;
      ConnectionName@1001 : Text;
    BEGIN
      CreateTempNoDelegateConnection(TempCRMConnectionSetup);
      ConnectionName := FORMAT(CREATEGUID);
      TempCRMConnectionSetup.RegisterConnectionWithName(ConnectionName);
      SETDEFAULTTABLECONNECTION(
        TABLECONNECTIONTYPE::CRM,GetDefaultCRMConnection(ConnectionName),TRUE);

      CRMSetupDefaults.ResetCRMNAVConnectionData;

      TempCRMConnectionSetup.UnregisterConnectionWithName(ConnectionName);

      RefreshDataFromCRM;
    END;

    [External]
    PROCEDURE SynchronizeNow@44(DoFullSynch@1000 : Boolean);
    VAR
      IntegrationTableMapping@1006 : Record 5335;
      TempNameValueBuffer@1005 : TEMPORARY Record 823;
      CRMSetupDefaults@1004 : Codeunit 5334;
      ProgressWindow@1003 : Dialog;
      MappingCount@1002 : Integer;
      CurrentMappingIndex@1001 : Integer;
    BEGIN
      CRMSetupDefaults.GetPrioritizedMappingList(TempNameValueBuffer);
      TempNameValueBuffer.ASCENDING(TRUE);
      TempNameValueBuffer.FINDSET;

      CurrentMappingIndex := 0;
      MappingCount := TempNameValueBuffer.COUNT;
      ProgressWindow.OPEN(ProcessDialogMapTitleMsg,CurrentMappingIndex);
      REPEAT
        CurrentMappingIndex := CurrentMappingIndex + 1;
        ProgressWindow.UPDATE(1,ROUND(CurrentMappingIndex / MappingCount * 10000,1));
        IF IntegrationTableMapping.GET(TempNameValueBuffer.Value) THEN
          IntegrationTableMapping.SynchronizeNow(DoFullSynch);
      UNTIL TempNameValueBuffer.NEXT = 0;
      ProgressWindow.CLOSE;
    END;

    LOCAL PROCEDURE ShowError@336(ActivityDescription@1001 : Text[128];ErrorMessage@1000 : Text);
    VAR
      MyNotifications@1003 : Record 1518;
      LogonManagement@1002 : Codeunit 9802;
    BEGIN
      IF NOT LogonManagement.IsLogonInProgress THEN
        ERROR(ErrorMessage);

      MyNotifications.InsertDefault(GetCRMNotificationId,ActivityDescription,ErrorMessage,TRUE);
    END;

    LOCAL PROCEDURE GetCRMNotificationId@28() : GUID;
    BEGIN
      EXIT('692A2701-4BBB-4C5B-B4C0-629D96B60644');
    END;

    PROCEDURE DoReadCRMData@45() : Boolean;
    VAR
      SkipReading@1000 : Boolean;
    BEGIN
      OnReadingCRMData(SkipReading);
      EXIT(NOT SkipReading);
    END;

    [Integration]
    LOCAL PROCEDURE OnReadingCRMData@22(VAR SkipReading@1000 : Boolean);
    BEGIN
    END;

    [Internal]
    PROCEDURE GetDefaultCRMConnection@46(ConnectionName@1000 : Text) : Text;
    BEGIN
      OnGetDefaultCRMConnection(ConnectionName);
      EXIT(ConnectionName);
    END;

    [Integration]
    LOCAL PROCEDURE OnGetDefaultCRMConnection@48(VAR ConnectionName@1000 : Text);
    BEGIN
    END;

    LOCAL PROCEDURE CrmAuthenticationType@49() : Text;
    BEGIN
      CASE "Authentication Type" OF
        "Authentication Type"::Office365:
          EXIT('AuthType=Office365;');
        "Authentication Type"::AD:
          EXIT('AuthType=AD;' + GetDomain);
        "Authentication Type"::IFD:
          EXIT('AuthType=IFD;' + GetDomain + 'HomeRealmUri= ;');
        "Authentication Type"::OAuth:
          EXIT('AuthType=OAuth;' + 'AppId= ;' + 'RedirectUri= ;' + 'TokenCacheStorePath= ;' + 'LoginPrompt=Auto;');
      END;
    END;

    PROCEDURE UpdateConnectionString@50() ConnectionString : Text;
    BEGIN
      ConnectionString := STRSUBSTNO(
          ConnectionStringFormatTok,"Server Address",GetUserName,MissingPasswordTok,CrmAuthenticationType);
      SetConnectionString(ConnectionString);
    END;

    LOCAL PROCEDURE UpdateDomainName@54();
    BEGIN
      IF "User Name" <> '' THEN
        IF STRPOS("User Name",'\') > 0 THEN
          VALIDATE(Domain,COPYSTR("User Name",1,STRPOS("User Name",'\') - 1))
        ELSE
          Domain := '';
    END;

    LOCAL PROCEDURE CheckUserName@47();
    BEGIN
      IF "User Name" <> '' THEN
        CASE "Authentication Type" OF
          "Authentication Type"::AD:
            IF STRPOS("User Name",'\') = 0 THEN
              ERROR(UserNameMustIncludeDomainErr);
          "Authentication Type"::Office365:
            IF STRPOS("User Name",'@') = 0 THEN
              ERROR(UserNameMustBeEmailErr);
        END;
    END;

    LOCAL PROCEDURE GetDomain@68() : Text;
    BEGIN
      IF Domain <> '' THEN
        EXIT(STRSUBSTNO('Domain=%1;',Domain));
    END;

    LOCAL PROCEDURE FilterCRMSystemUser@57(VAR CRMSystemuser@1000 : Record 5340);
    BEGIN
      CASE "Authentication Type" OF
        "Authentication Type"::Office365,"Authentication Type"::OAuth:
          CRMSystemuser.SETRANGE(InternalEMailAddress,"User Name");
        "Authentication Type"::AD,"Authentication Type"::IFD:
          CRMSystemuser.SETRANGE(DomainName,"User Name");
      END;
    END;

    PROCEDURE UpdateCRMJobQueueEntriesStatus@52();
    VAR
      IntegrationTableMapping@1000 : Record 5335;
      JobQueueEntry@1001 : Record 472;
      NewStatus@1002 : Option;
    BEGIN
      IF "Is Enabled" THEN
        NewStatus := JobQueueEntry.Status::Ready
      ELSE
        NewStatus := JobQueueEntry.Status::"On Hold";
      IntegrationTableMapping.SETRANGE("Synch. Codeunit ID",CODEUNIT::"CRM Integration Table Synch.");
      IntegrationTableMapping.SETRANGE("Delete After Synchronization",FALSE);
      IF IntegrationTableMapping.FINDSET THEN
        REPEAT
          JobQueueEntry.SETRANGE("Record ID to Process",IntegrationTableMapping.RECORDID);
          IF JobQueueEntry.FINDSET THEN
            REPEAT
              JobQueueEntry.SetStatus(NewStatus);
            UNTIL JobQueueEntry.NEXT = 0;
        UNTIL IntegrationTableMapping.NEXT = 0;
    END;

    PROCEDURE UpdateLastUpdateInvoiceEntryNo@38() : Boolean;
    VAR
      DtldCustLedgEntry@1000 : Record 379;
    BEGIN
      GET;
      DtldCustLedgEntry.RESET;
      IF DtldCustLedgEntry.FINDLAST THEN
        IF "Last Update Invoice Entry No." <> DtldCustLedgEntry."Entry No." THEN BEGIN
          "Last Update Invoice Entry No." := DtldCustLedgEntry."Entry No.";
          EXIT(MODIFY);
        END;
    END;

    PROCEDURE GetConnectionString@3() ConnectionString : Text;
    VAR
      CRMConnectionSetup@1001 : Record 5330;
      InStream@1000 : InStream;
    BEGIN
      IF CRMConnectionSetup.GET("Primary Key") THEN
        CALCFIELDS("Server Connection String");
      "Server Connection String".CREATEINSTREAM(InStream);
      InStream.READTEXT(ConnectionString);
    END;

    PROCEDURE SetConnectionString@56(ConnectionString@1000 : Text);
    VAR
      OutStream@1001 : OutStream;
    BEGIN
      IF ConnectionString = '' THEN
        CLEAR("Server Connection String")
      ELSE BEGIN
        IF STRPOS(ConnectionString,MissingPasswordTok) = 0 THEN
          ERROR(ConnectionStringPwdPlaceHolderMissingErr);
        CLEAR("Server Connection String");
        "Server Connection String".CREATEOUTSTREAM(OutStream);
        OutStream.WRITETEXT(ConnectionString);
      END;
      IF NOT MODIFY THEN ;
    END;

    BEGIN
    END.
  }
}

