OBJECT Page 1817 CRM Connection Setup Wizard
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
    CaptionML=[DAN=Konfiguration af Dynamics 365 for Sales-forbindelse;
               ENU=Dynamics 365 for Sales Connection Setup];
    SourceTable=Table5330;
    PageType=NavigatePage;
    SourceTableTemporary=Yes;
    OnInit=BEGIN
             LoadTopBanners;
           END;

    OnOpenPage=VAR
                 CRMConnectionSetup@1000 : Record 5330;
               BEGIN
                 INIT;
                 IF CRMConnectionSetup.GET THEN BEGIN
                   "Server Address" := CRMConnectionSetup."Server Address";
                   "User Name" := CRMConnectionSetup."User Name";
                 END;
                 INSERT;
                 Step := Step::Start;
                 EnableControls;
               END;

    OnQueryClosePage=VAR
                       AssistedSetup@1000 : Record 1803;
                     BEGIN
                       IF CloseAction = ACTION::OK THEN
                         IF AssistedSetup.GetStatus(PAGE::"CRM Connection Setup Wizard") = AssistedSetup.Status::"Not Completed" THEN
                           IF NOT CONFIRM(ConnectionNotSetUpQst,FALSE,CRMProductName.SHORT) THEN
                             ERROR('');
                     END;

    ActionList=ACTIONS
    {
      { 2       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 3       ;1   ;Action    ;
                      Name=ActionBack;
                      CaptionML=[DAN=Tilbage;
                                 ENU=Back];
                      ApplicationArea=#Basic,#Suite;
                      Enabled=BackActionEnabled;
                      InFooterBar=Yes;
                      Image=PreviousRecord;
                      OnAction=BEGIN
                                 NextStep(TRUE);
                               END;
                                }
      { 4       ;1   ;Action    ;
                      Name=ActionNext;
                      CaptionML=[DAN=N�ste;
                                 ENU=Next];
                      ApplicationArea=#Basic,#Suite;
                      Enabled=NextActionEnabled;
                      InFooterBar=Yes;
                      Image=NextRecord;
                      OnAction=BEGIN
                                 IF (Step = Step::Start) AND ("Server Address" = '') THEN
                                   ERROR(CRMURLShouldNotBeEmptyErr,CRMProductName.SHORT);
                                 NextStep(FALSE);
                               END;
                                }
      { 25      ;1   ;Action    ;
                      Name=ActionAdvanced;
                      CaptionML=[DAN=Avanceret;
                                 ENU=Advanced];
                      ApplicationArea=#Basic,#Suite;
                      Visible=AdvancedActionEnabled;
                      InFooterBar=Yes;
                      Image=Setup;
                      OnAction=BEGIN
                                 ShowAdvancedSettings := TRUE;
                                 AdvancedActionEnabled := FALSE;
                                 SimpleActionEnabled := TRUE;
                               END;
                                }
      { 27      ;1   ;Action    ;
                      Name=ActionSimple;
                      CaptionML=[DAN=Enkel;
                                 ENU=Simple];
                      ApplicationArea=#Basic,#Suite;
                      Visible=SimpleActionEnabled;
                      InFooterBar=Yes;
                      Image=Setup;
                      OnAction=BEGIN
                                 ShowAdvancedSettings := FALSE;
                                 AdvancedActionEnabled := TRUE;
                                 SimpleActionEnabled := FALSE;
                               END;
                                }
      { 5       ;1   ;Action    ;
                      Name=ActionFinish;
                      CaptionML=[DAN=Udf�r;
                                 ENU=Finish];
                      ApplicationArea=#Basic,#Suite;
                      Enabled=FinishActionEnabled;
                      InFooterBar=Yes;
                      Image=Approve;
                      OnAction=VAR
                                 AssistedSetup@1000 : Record 1803;
                                 CRMConnectionSetup@1001 : Record 5330;
                                 CRMSystemuser@1005 : Record 5340;
                                 LookupCRMTables@1004 : Codeunit 5332;
                                 CRMSystemuserList@1002 : Page 5340;
                                 IntTableFilter@1003 : Text;
                               BEGIN
                                 IF ("User Name" = '') OR (Password = '') THEN
                                   ERROR(CRMSynchUserCredentialsNeededErr,CRMProductName.SHORT);
                                 IF NOT FinalizeSetup THEN
                                   EXIT;
                                 AssistedSetup.SetStatus(PAGE::"CRM Connection Setup Wizard",AssistedSetup.Status::Completed);
                                 COMMIT;
                                 CRMConnectionSetup.GET;
                                 IF CRMConnectionSetup."Is Enabled" THEN
                                   IF CONFIRM(DoYouWantToMakeSalesPeopleMappingQst,TRUE,CRMProductName.SHORT) THEN BEGIN
                                     IntTableFilter :=
                                       LookupCRMTables.GetIntegrationTableFilter(DATABASE::"CRM Systemuser",DATABASE::"Salesperson/Purchaser");
                                     CRMSystemuser.SETVIEW(IntTableFilter);
                                     CRMSystemuserList.SETTABLEVIEW(CRMSystemuser);
                                     CRMSystemuserList.Initialize(TRUE);
                                     CRMSystemuserList.RUNMODAL;
                                   END;
                                 CurrPage.CLOSE;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;    ;Container ;
                Name=ContentArea;
                ContainerType=ContentArea }

    { 18  ;1   ;Group     ;
                Name=BannerStandard;
                CaptionML=[DAN="";
                           ENU=""];
                Visible=TopBannerVisible AND NOT CredentialsStepVisible;
                Editable=FALSE;
                GroupType=Group }

    { 17  ;2   ;Field     ;
                ApplicationArea=#Suite;
                SourceExpr=MediaResourcesStandard."Media Reference";
                Editable=FALSE;
                ShowCaption=No }

    { 16  ;1   ;Group     ;
                Name=BannerDone;
                CaptionML=[DAN="";
                           ENU=""];
                Visible=TopBannerVisible AND CredentialsStepVisible;
                Editable=FALSE;
                GroupType=Group }

    { 15  ;2   ;Field     ;
                ApplicationArea=#Suite;
                SourceExpr=MediaResourcesDone."Media Reference";
                Editable=FALSE;
                ShowCaption=No }

    { 6   ;1   ;Group     ;
                Name=Step1;
                Visible=FirstStepVisible;
                GroupType=Group }

    { 24  ;2   ;Group     ;
                CaptionML=[DAN=Velkommen til Konfiguration af Dynamics 365 for Sales-forbindelse;
                           ENU=Welcome to Dynamics 365 for Sales Connection Setup];
                GroupType=Group }

    { 23  ;3   ;Group     ;
                GroupType=Group;
                InstructionalTextML=[DAN=Du kan konfigurere en Dynamics 365 for Sales-forbindelse for at aktivere problemfri sammenk�dning af data.;
                                     ENU=You can set up a Dynamics 365 for Sales connection to enable seamless coupling of data.] }

    { 21  ;3   ;Group     ;
                GroupType=Group;
                InstructionalTextML=[DAN=Start med at specificere URL-adressen til din Dynamics 365 for Sales-l�sning, f.eks. https://mycrm.crm4.dynamics.com;
                                     ENU=Start by specifying the URL to your Dynamics 365 for Sales solution, such as https://mycrm.crm4.dynamics.com] }

    { 34  ;3   ;Field     ;
                Name=ServerAddress;
                ApplicationArea=#Suite;
                SourceExpr="Server Address";
                OnValidate=VAR
                             CRMIntegrationManagement@1000 : Codeunit 5330;
                           BEGIN
                             CRMIntegrationManagement.CheckModifyCRMConnectionURL("Server Address");
                           END;
                            }

    { 9   ;3   ;Group     ;
                GroupType=Group;
                InstructionalTextML=[DAN=Efter sammenk�dningen kan du arbejde med og synkronisere datatyper, der er f�lles for begge tjenester, f.eks. debitorer, kontakter og salgsoplysninger, og holde dataene opdaterede p� begge lokationer.;
                                     ENU=Once coupled, you can work with and synchronize data types that are common to both services, such as customers, contacts, and sales information, and keep the data up-to-date in both locations.] }

    { 8   ;1   ;Group     ;
                Name=Step2;
                CaptionML=[DAN="";
                           ENU=""];
                Visible=CredentialsStepVisible;
                GroupType=Group }

    { 19  ;2   ;Group     ;
                Name=Step2.1;
                CaptionML=[DAN="";
                           ENU=""];
                GroupType=Group;
                InstructionalTextML=[DAN=Angiv den bruger, der skal anvendes til synkronisering mellem de to tjenester.;
                                     ENU=Specify the user that will be used for synchronization between the two services.] }

    { 11  ;3   ;Field     ;
                Name=Email;
                ExtendedDatatype=E-Mail;
                CaptionML=[DAN=Mail;
                           ENU=Email];
                ApplicationArea=#Suite;
                SourceExpr="User Name" }

    { 12  ;3   ;Field     ;
                Name=Password;
                ExtendedDatatype=Masked;
                CaptionML=[DAN=Adgangskode;
                           ENU=Password];
                ApplicationArea=#Suite;
                SourceExpr=Password }

    { 22  ;2   ;Group     ;
                GroupType=Group;
                InstructionalTextML=[DAN=Denne konto skal allerede v�re en gyldig bruger i Dynamics 365 for Sales.;
                                     ENU=This account must already be a valid user in Dynamics 365 for Sales.] }

    { 7   ;2   ;Group     ;
                CaptionML=[DAN=Avancerede indstillinger;
                           ENU=Advanced Settings];
                Visible=ShowAdvancedSettings;
                GroupType=Group }

    { 32  ;3   ;Field     ;
                Name=ImportCRMSolution;
                CaptionML=[DAN=Import�r Dynamics 365 for Sales-l�sning;
                           ENU=Import Dynamics 365 for Sales Solution];
                ApplicationArea=#Suite;
                SourceExpr=ImportSolution;
                Enabled=ImportCRMSolutionEnabled;
                OnValidate=BEGIN
                             OnImportSolutionChange;
                           END;
                            }

    { 31  ;3   ;Field     ;
                Name=PublishItemAvailabilityService;
                CaptionML=[DAN=Udgiv webtjeneste Varedisponering;
                           ENU=Publish Item Availability Web Service];
                ApplicationArea=#Suite;
                SourceExpr=PublishItemAvailabilityService;
                Enabled=PublishItemAvailabilityServiceEnabled;
                OnValidate=BEGIN
                             IF NOT PublishItemAvailabilityService THEN BEGIN
                               CLEAR("Dynamics NAV OData Username");
                               CLEAR("Dynamics NAV OData Accesskey");
                             END;
                           END;
                            }

    { 26  ;3   ;Field     ;
                CaptionML=[DAN=Du skal tildele sikkerhedsrollen Dynamics NAV Product Availability User (Dynamics NAV-produkttilg�ngelighedsbruger) til dine salgsmedarbejdere i Dynamics 365 for Sales.;
                           ENU=You must assign the security role Dynamics NAV Product Availability User to your sales people in Dynamics 365 for Sales.];
                ApplicationArea=#Suite }

    { 30  ;3   ;Field     ;
                Name=NAVODataUsername;
                Lookup=Yes;
                CaptionML=[DAN=Brugernavn for Dynamics NAV OData-webtjeneste;
                           ENU=Dynamics NAV OData Web Service User Name];
                ApplicationArea=#Suite;
                SourceExpr="Dynamics NAV OData Username";
                Enabled=PublishItemAvailabilityServiceEnabled;
                Editable=PublishItemAvailabilityService;
                LookupPageID=Users;
                OnLookup=VAR
                           User@1000 : Record 2000000120;
                         BEGIN
                           IF PAGE.RUNMODAL(PAGE::Users,User) = ACTION::LookupOK THEN BEGIN
                             "Dynamics NAV OData Username" := User."User Name";
                             UpdateUserWebKey(User);
                           END;
                         END;
                          }

    { 14  ;3   ;Field     ;
                Name=NAVODataAccesskey;
                CaptionML=[DAN=Adgangsn�gle for Dynamics NAV OData-webtjeneste;
                           ENU=Dynamics NAV OData Web Service Access Key];
                ApplicationArea=#Suite;
                SourceExpr="Dynamics NAV OData Accesskey";
                Enabled=PublishItemAvailabilityServiceEnabled;
                Editable=FALSE }

    { 13  ;3   ;Field     ;
                Name=EnableSalesOrderIntegration;
                CaptionML=[DAN=Aktiv�r integration af salgsordrer;
                           ENU=Enable Sales Order Integration];
                ApplicationArea=#Suite;
                SourceExpr=EnableSalesOrderIntegration;
                Enabled=EnableSalesOrderIntegrationEnabled }

    { 10  ;3   ;Field     ;
                Name=EnableCRMConnection;
                CaptionML=[DAN=Aktiv�r Dynamics 365 for Sales-forbindelse;
                           ENU=Enable Dynamics 365 for Sales Connection];
                ApplicationArea=#Suite;
                SourceExpr=EnableCRMConnection;
                Enabled=EnableCRMConnectionEnabled }

    { 20  ;2   ;Group     ;
                GroupType=Group;
                InstructionalTextML=[DAN=Hvis du vil aktivere forbindelsen, skal du v�lge Udf�r. Du bliver bedt om at angive en administratorbrugerkonto i Dynamics 365 for Sales.;
                                     ENU=To enable the connection, choose Finish. You will be asked to specify an administrative user account in Dynamics 365 for Sales.] }

  }
  CODE
  {
    VAR
      MediaRepositoryStandard@1015 : Record 9400;
      MediaRepositoryDone@1014 : Record 9400;
      MediaResourcesStandard@1025 : Record 2000000182;
      MediaResourcesDone@1018 : Record 2000000182;
      CRMProductName@1029 : Codeunit 5344;
      ClientTypeManagement@1030 : Codeunit 4;
      Step@1000 : 'Start,Credentials,Finish';
      TopBannerVisible@1013 : Boolean;
      BackActionEnabled@1001 : Boolean;
      NextActionEnabled@1002 : Boolean;
      FinishActionEnabled@1003 : Boolean;
      FirstStepVisible@1004 : Boolean;
      CredentialsStepVisible@1006 : Boolean;
      EnableCRMConnection@1009 : Boolean;
      ImportSolution@1010 : Boolean;
      PublishItemAvailabilityService@1019 : Boolean;
      EnableCRMConnectionEnabled@1012 : Boolean;
      ImportCRMSolutionEnabled@1011 : Boolean;
      PublishItemAvailabilityServiceEnabled@1020 : Boolean;
      EnableSalesOrderIntegration@1021 : Boolean;
      EnableSalesOrderIntegrationEnabled@1022 : Boolean;
      ShowAdvancedSettings@1027 : Boolean;
      AdvancedActionEnabled@1017 : Boolean;
      SimpleActionEnabled@1007 : Boolean;
      Password@1008 : Text;
      ConnectionNotSetUpQst@1016 : TextConst '@@@="%1 = CRM product name";DAN=%1-forbindelsen er ikke konfigureret.\\Er du sikker p�, at du vil afslutte?;ENU=The %1 connection has not been set up.\\Are you sure you want to exit?';
      MustUpdateClientsQst@1023 : TextConst 'DAN=Hvis du �ndrer adgangsn�glen til webtjenesten, er den nuv�rende adgangsn�gle ikke l�ngere gyldig. Du skal opdatere alle klienter, der bruger den. Vil du forts�tte?;ENU=If you change the web service access key, the current access key will no longer be valid. You must update all clients that use it. Do you want to continue?';
      ConfirmCredentialsDomainQst@1024 : TextConst 'DAN=Administratorbrugerkontoen og integrationsbrugerkontoen ser ud til at v�re fra forskellige dom�ner. Er du sikker p�, at legitimationsoplysningerne er korrekte?;ENU=The administrator user account and the integration user account appear to be from different domains. Are you sure that the credentials are correct?';
      CRMURLShouldNotBeEmptyErr@1026 : TextConst '@@@="%1 = CRM product name";DAN=Du skal angive URL-adresse til din %1-l�sning.;ENU=You must specify the URL of your %1 solution.';
      CRMSynchUserCredentialsNeededErr@1005 : TextConst '@@@="%1 = CRM product name";DAN=Du skal angive legitimationsoplysningerne for brugerkontoen til synkronisering med %1.;ENU=You must specify the credentials for the user account for synchronization with %1.';
      DoYouWantToMakeSalesPeopleMappingQst@1028 : TextConst '@@@="%1 = CRM product name";DAN=�nsker du at knytte s�lgere til brugere i %1?;ENU=Do you want to map salespeople to users in %1?';

    LOCAL PROCEDURE LoadTopBanners@40();
    BEGIN
      IF MediaRepositoryStandard.GET('AssistedSetup-NoText-400px.png',FORMAT(ClientTypeManagement.GetCurrentClientType)) AND
         MediaRepositoryDone.GET('AssistedSetupDone-NoText-400px.png',FORMAT(ClientTypeManagement.GetCurrentClientType))
      THEN
        IF MediaResourcesStandard.GET(MediaRepositoryStandard."Media Resources Ref") AND
           MediaResourcesDone.GET(MediaRepositoryDone."Media Resources Ref")
        THEN
          TopBannerVisible := MediaResourcesDone."Media Reference".HASVALUE;
    END;

    LOCAL PROCEDURE NextStep@4(Backward@1000 : Boolean);
    BEGIN
      IF Backward THEN
        Step := Step - 1
      ELSE
        Step := Step + 1;

      EnableControls;
    END;

    LOCAL PROCEDURE ResetControls@11();
    BEGIN
      BackActionEnabled := FALSE;
      NextActionEnabled := FALSE;
      FinishActionEnabled := FALSE;
      AdvancedActionEnabled := FALSE;

      FirstStepVisible := FALSE;
      CredentialsStepVisible := FALSE;

      ImportCRMSolutionEnabled := TRUE;
      PublishItemAvailabilityServiceEnabled := TRUE;
      EnableSalesOrderIntegrationEnabled := TRUE;
      EnableSalesOrderIntegration := TRUE;
    END;

    LOCAL PROCEDURE EnableControls@18();
    BEGIN
      ResetControls;

      CASE Step OF
        Step::Start:
          ShowStartStep;
        Step::Credentials:
          ShowFinishStep;
      END;
    END;

    LOCAL PROCEDURE ShowStartStep@46();
    BEGIN
      BackActionEnabled := FALSE;
      NextActionEnabled := TRUE;
      FinishActionEnabled := FALSE;
      FirstStepVisible := TRUE;
      AdvancedActionEnabled := FALSE;
      SimpleActionEnabled := FALSE;
    END;

    LOCAL PROCEDURE ShowFinishStep@54();
    VAR
      CRMConnectionSetup@1000 : Record 5330;
      User@1001 : Record 2000000120;
      IdentityManagement@1002 : Codeunit 9801;
    BEGIN
      BackActionEnabled := TRUE;
      NextActionEnabled := FALSE;
      AdvancedActionEnabled := NOT ShowAdvancedSettings;
      SimpleActionEnabled := NOT AdvancedActionEnabled;
      CredentialsStepVisible := TRUE;
      FinishActionEnabled := TRUE;

      EnableSalesOrderIntegrationEnabled := ImportCRMSolutionEnabled;
      EnableCRMConnectionEnabled := "Server Address" <> '';
      IF User.GET(USERSECURITYID) THEN BEGIN
        "Dynamics NAV OData Accesskey" := IdentityManagement.GetWebServicesKey(User."User Security ID");
        IF "Dynamics NAV OData Accesskey" <> '' THEN
          "Dynamics NAV OData Username" := User."User Name";
      END;
      "Authentication Type" := "Authentication Type"::Office365;
      IF CRMConnectionSetup.GET THEN BEGIN
        EnableCRMConnection := TRUE;
        EnableCRMConnectionEnabled := NOT CRMConnectionSetup."Is Enabled";
        EnableSalesOrderIntegration := TRUE;
        EnableSalesOrderIntegrationEnabled := NOT CRMConnectionSetup."Is S.Order Integration Enabled";
        ImportSolution := TRUE;
        IF CRMConnectionSetup."Is CRM Solution Installed" THEN BEGIN
          ImportCRMSolutionEnabled := FALSE;
          "Dynamics NAV OData Username" := CRMConnectionSetup."Dynamics NAV OData Username";
          "Dynamics NAV OData Accesskey" := CRMConnectionSetup."Dynamics NAV OData Accesskey";
        END;
      END ELSE BEGIN
        IF ImportCRMSolutionEnabled THEN
          ImportSolution := TRUE;
        IF EnableCRMConnectionEnabled THEN
          EnableCRMConnection := TRUE;
      END;
    END;

    LOCAL PROCEDURE FinalizeSetup@1() : Boolean;
    VAR
      CRMConnectionSetup@1002 : Record 5330;
      CRMIntegrationManagement@1000 : Codeunit 5330;
      AdminEmail@1005 : Text[250];
      AdminPassKey@1003 : GUID;
    BEGIN
      IF ImportSolution AND ImportCRMSolutionEnabled THEN BEGIN
        IF NOT PromptForCredentials(AdminEmail,AdminPassKey) THEN
          EXIT(FALSE);
        CRMIntegrationManagement.ImportCRMSolution("Server Address","User Name",AdminEmail,AdminPassKey);
      END;
      IF PublishItemAvailabilityService THEN
        CRMIntegrationManagement.SetupItemAvailabilityService;

      CRMConnectionSetup.UpdateFromWizard(Rec,Password);
      IF EnableCRMConnection THEN
        CRMConnectionSetup.EnableCRMConnectionFromWizard;
      IF EnableSalesOrderIntegration AND EnableSalesOrderIntegrationEnabled THEN
        CRMConnectionSetup.SetCRMSOPEnabledWithCredentials(AdminEmail,AdminPassKey,TRUE);
      IF PublishItemAvailabilityService AND PublishItemAvailabilityServiceEnabled THEN BEGIN
        CRMIntegrationManagement.SetCRMNAVConnectionUrl(GETURL(CLIENTTYPE::Web));
        CRMIntegrationManagement.SetCRMNAVODataUrlCredentials(
          CRMIntegrationManagement.GetItemAvailabilityWebServiceURL,
          "Dynamics NAV OData Username","Dynamics NAV OData Accesskey");
      END;
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE OnImportSolutionChange@3();
    BEGIN
      PublishItemAvailabilityServiceEnabled := ImportSolution;
      PublishItemAvailabilityService := ImportSolution;
    END;

    LOCAL PROCEDURE UpdateUserWebKey@2(User@1002 : Record 2000000120);
    VAR
      PermissionManager@1001 : Codeunit 9002;
      IdentityManagement@1003 : Codeunit 9801;
      SetWebServiceAccessKey@1000 : Page 9812;
    BEGIN
      "Dynamics NAV OData Accesskey" := IdentityManagement.GetWebServicesKey(User."User Security ID");
      IF NOT (PermissionManager.SoftwareAsAService AND (USERSECURITYID <> User."User Security ID")) AND
         ("Dynamics NAV OData Accesskey" = '')
      THEN
        IF CONFIRM(MustUpdateClientsQst) THEN BEGIN
          User.SETCURRENTKEY("User Security ID");
          User.SETRANGE("User Name",User."User Name");
          SetWebServiceAccessKey.SETRECORD(User);
          SetWebServiceAccessKey.SETTABLEVIEW(User);
          IF SetWebServiceAccessKey.RUNMODAL = ACTION::OK THEN
            "Dynamics NAV OData Accesskey" := IdentityManagement.GetWebServicesKey(User."User Security ID");
        END;
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE PromptForCredentials@6(VAR AdminEmail@1002 : Text;VAR PasswordKey@1003 : GUID) : Boolean;
    VAR
      TempOfficeAdminCredentials@1000 : TEMPORARY Record 1612;
    BEGIN
      IF TempOfficeAdminCredentials.ISEMPTY THEN BEGIN
        TempOfficeAdminCredentials.INIT;
        TempOfficeAdminCredentials.INSERT(TRUE);
        COMMIT;
        IF PAGE.RUNMODAL(PAGE::"Dynamics CRM Admin Credentials",TempOfficeAdminCredentials) <> ACTION::LookupOK THEN
          EXIT(FALSE);
      END;
      IF (NOT TempOfficeAdminCredentials.FINDFIRST) OR
         (TempOfficeAdminCredentials.Email = '') OR (TempOfficeAdminCredentials.GetPassword = '')
      THEN BEGIN
        TempOfficeAdminCredentials.DELETEALL(TRUE);
        EXIT(FALSE);
      END;

      AdminEmail := TempOfficeAdminCredentials.Email;
      IF NOT CheckCredentialsSameDomain(AdminEmail) THEN
        EXIT(FALSE);
      PasswordKey := TempOfficeAdminCredentials.Password;
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE CheckCredentialsSameDomain@8(AdminEmail@1000 : Text) : Boolean;
    BEGIN
      IF (GetDomainFromEmail(AdminEmail) <> GetDomainFromEmail("User Name")) AND (AdminEmail <> '') THEN
        IF NOT CONFIRM(ConfirmCredentialsDomainQst) THEN
          EXIT(FALSE);
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE GetDomainFromEmail@5(Email@1000 : Text) : Text;
    BEGIN
      EXIT(DELSTR(Email,1,STRPOS(Email,'@')));
    END;

    BEGIN
    END.
  }
}

