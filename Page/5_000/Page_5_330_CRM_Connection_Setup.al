OBJECT Page 5330 CRM Connection Setup
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Konfiguration af Microsoft Dynamics 365 for Sales-forbindelse;
               ENU=Microsoft Dynamics 365 for Sales Connection Setup];
    InsertAllowed=No;
    DeleteAllowed=No;
    LinksAllowed=No;
    SourceTable=Table5330;
    PromotedActionCategoriesML=[DAN=Ny,Forbindelse,Tilknytning,Synkronisering,Kryptering;
                                ENU=New,Connection,Mapping,Synchronization,Encryption];
    ShowFilter=No;
    OnInit=VAR
             PermissionManager@1000 : Codeunit 9002;
           BEGIN
             CODEUNIT.RUN(CODEUNIT::"Check App. Area Only Basic");
             AssistedSetupAvailable :=
               AssistedSetup.GET(PAGE::"CRM Connection Setup Wizard") AND
               AssistedSetup.Visible;
             SoftwareAsAService := PermissionManager.SoftwareAsAService;
           END;

    OnOpenPage=BEGIN
                 IF NOT GET THEN BEGIN
                   INIT;
                   INSERT;
                 END ELSE BEGIN
                   ConnectionString := GetConnectionString;
                   UnregisterConnection;
                   IF "Is Enabled" THEN
                     RegisterUserConnection;
                 END;
               END;

    OnAfterGetRecord=BEGIN
                       IF HasPassword THEN
                         CRMPassword := '*';
                       RefreshData;
                     END;

    OnQueryClosePage=BEGIN
                       IF NOT "Is Enabled" THEN
                         IF NOT CONFIRM(STRSUBSTNO(EnableServiceQst,CurrPage.CAPTION),TRUE) THEN
                           EXIT(FALSE);
                     END;

    ActionList=ACTIONS
    {
      { 4       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 35      ;1   ;Action    ;
                      Name=Assisted Setup;
                      CaptionML=[DAN=Assisteret ops‘tning;
                                 ENU=Assisted Setup];
                      ToolTipML=[DAN=K›rer guiden Ops‘tning af Dynamics NAV-forbindelse.;
                                 ENU=Runs Dynamics NAV Connection Setup Wizard.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Enabled=AssistedSetupAvailable;
                      Image=Setup;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF AssistedSetupAvailable THEN BEGIN
                                   AssistedSetup.Run;
                                   CurrPage.UPDATE(FALSE);
                                 END;
                               END;
                                }
      { 5       ;1   ;Action    ;
                      Name=Test Connection;
                      CaptionML=[@@@=Test is a verb.;
                                 DAN=Afpr›v forbindelse;
                                 ENU=Test Connection];
                      ToolTipML=[DAN=Afpr›ver forbindelsen til Dynamics 365 for Sales ved hj‘lp af de angivne indstillinger.;
                                 ENU=Tests the connection to Dynamics 365 for Sales using the specified settings.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Image=ValidateEmailLoggingSetup;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 PerformTestConnection;
                               END;
                                }
      { 13      ;1   ;Action    ;
                      Name=ResetConfiguration;
                      CaptionML=[DAN=Brug standardops‘tning af synkronisering;
                                 ENU=Use Default Synchronization Setup];
                      ToolTipML=[DAN=Nulstiller integrationstabelkoblingerne og synkroniseringsjob til standardv‘rdierne for en forbindelse med Dynamics 365 for Sales. Alle eksisterende koblinger slettes.;
                                 ENU=Resets the integration table mappings and synchronization jobs to the default values for a connection with Dynamics 365 for Sales. All current mappings are deleted.];
                      ApplicationArea=#Suite;
                      Enabled="Is Enabled";
                      Image=ResetStatus;
                      OnAction=VAR
                                 CRMSetupDefaults@1000 : Codeunit 5334;
                               BEGIN
                                 IF CONFIRM(ResetIntegrationTableMappingConfirmQst,FALSE,CRMProductName.SHORT) THEN BEGIN
                                   CRMSetupDefaults.ResetConfiguration(Rec);
                                   MESSAGE(SetupSuccessfulMsg,CRMProductName.SHORT);
                                 END;
                                 RefreshDataFromCRM;
                               END;
                                }
      { 41      ;1   ;Action    ;
                      Name=CoupleUsers;
                      CaptionML=[DAN=Couple Salespersons;
                                 ENU=Couple Salespersons];
                      ToolTipML=[DAN=Open the list of users in Dynamics 365 for Sales for manual coupling to salespersons in Dynamics 365, Business edition.;
                                 ENU=Open the list of users in Dynamics 365 for Sales for manual coupling to salespersons in Dynamics 365, Business edition.];
                      ApplicationArea=#Suite;
                      Image=CoupledUsers;
                      OnAction=VAR
                                 CRMSystemuserList@1000 : Page 5340;
                               BEGIN
                                 CRMSystemuserList.Initialize(TRUE);
                                 CRMSystemuserList.RUNMODAL;
                               END;
                                }
      { 10      ;1   ;Action    ;
                      Name=StartInitialSynchAction;
                      CaptionML=[DAN=K›r fuld synkronisering;
                                 ENU=Run Full Synchronization];
                      ToolTipML=[DAN=Start alle standardintegrationsjobs til synkronisering af Dynamics NAV-recordtyper og Dynamics 365 for Sales-poster som defineret p† siden Integrationstabelkoblinger.;
                                 ENU=Start all the default integration jobs for synchronizing Dynamics NAV record types and Dynamics 365 for Sales entities, as defined on the Integration Table Mappings page.];
                      ApplicationArea=#Suite;
                      Enabled="Is Enabled For User";
                      Image=RefreshLines;
                      OnAction=BEGIN
                                 PAGE.RUN(PAGE::"CRM Full Synch. Review");
                               END;
                                }
      { 17      ;1   ;Action    ;
                      Name=Reset Web Client URL;
                      CaptionML=[DAN=Nulstil URL-adresse til webklient;
                                 ENU=Reset Web Client URL];
                      ToolTipML=[DAN=Fortryd din ‘ndring, og indtast standard-URL'en i feltet URL til Dynamics NAV-webklient.;
                                 ENU=Undo your change and enter the default URL in the Dynamics NAV web Client URL field.];
                      ApplicationArea=#Suite;
                      Enabled=IsWebCliResetEnabled;
                      Image=ResetStatus;
                      OnAction=BEGIN
                                 PerformWebClientUrlReset;
                                 MESSAGE(WebClientUrlResetMsg,PRODUCTNAME.SHORT);
                               END;
                                }
      { 23      ;1   ;Action    ;
                      Name=SynchronizeNow;
                      CaptionML=[DAN=Synkroniser ‘ndrede records;
                                 ENU=Synchronize Modified Records];
                      ToolTipML=[DAN=Synkroniser records, der er ‘ndret siden sidste gang, de blev synkroniseret.;
                                 ENU=Synchronize records that have been modified since the last time they were synchronized.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Enabled="Is Enabled For User";
                      PromotedIsBig=Yes;
                      Image=Refresh;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 IntegrationSynchJobList@1000 : Page 5338;
                               BEGIN
                                 IF NOT CONFIRM(SynchronizeModifiedQst) THEN
                                   EXIT;

                                 SynchronizeNow(FALSE);
                                 MESSAGE(SyncNowSuccessMsg,IntegrationSynchJobList.CAPTION);
                               END;
                                }
      { 9       ;1   ;Action    ;
                      Name=Generate Integration IDs;
                      CaptionML=[DAN=Gener‚r integrations-id'er;
                                 ENU=Generate Integration IDs];
                      ToolTipML=[DAN=Opret integrations-id'er for nye records, der er blevet tilf›jet, mens forbindelsen var deaktiveret, f.eks. n†r du har genoprettet en Dynamics 365 for Sales-forbindelse.;
                                 ENU=Create integration IDs for new records that were added while the connection was disabled, for example, after you re-enable a Dynamics 365 for Sales connection.];
                      ApplicationArea=#Suite;
                      Image=Reconcile;
                      OnAction=VAR
                                 IntegrationManagement@1000 : Codeunit 5150;
                               BEGIN
                                 IF CONFIRM(ConfirmGenerateIntegrationIdsQst,TRUE) THEN BEGIN
                                   IntegrationManagement.SetupIntegrationTables;
                                   MESSAGE(GenerateIntegrationIdsSuccessMsg);
                                 END;
                               END;
                                }
      { 14      ;    ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 19      ;1   ;Action    ;
                      Name=Integration Table Mappings;
                      CaptionML=[DAN=Integrationstabelkoblinger;
                                 ENU=Integration Table Mappings];
                      ToolTipML=[DAN=Vis poster, der knytter integrationstabeller til forretningsdatatabeller i Dynamics NAV. Integrationstabeller er konfigureret til at fungere som gr‘nseflader til synkroniseringsdata mellem en ekstern databasetabel s†som Dynamics 365 for Sales og en tilsvarende forretningsdatatabel i Dynamics NAV.;
                                 ENU=View entries that map integration tables to business data tables in Dynamics NAV. Integration tables are set up to act as interfaces for synchronizing data between an external database table, such as Dynamics 365 for Sales, and a corresponding business data table in Dynamics NAV.];
                      ApplicationArea=#Suite;
                      RunObject=Page 5335;
                      Promoted=Yes;
                      Image=Relationship;
                      PromotedCategory=Report;
                      RunPageMode=Edit }
      { 12      ;1   ;Action    ;
                      Name=Synch. Job Queue Entries;
                      CaptionML=[DAN=Poster i synk.jobk›;
                                 ENU=Synch. Job Queue Entries];
                      ToolTipML=[DAN=Vis opgavek›poster, der administrerer den planlagte synkronisering mellem Dynamics 365 for Sales og Dynamics NAV.;
                                 ENU=View the job queue entries that manage the scheduled synchronization between Dynamics 365 for Sales and Dynamics NAV.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Image=JobListSetup;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 JobQueueEntry@1000 : Record 472;
                               BEGIN
                                 JobQueueEntry.FILTERGROUP := 2;
                                 JobQueueEntry.SETRANGE("Object Type to Run",JobQueueEntry."Object Type to Run"::Codeunit);
                                 JobQueueEntry.SETFILTER("Object ID to Run",GetJobQueueEntriesObjectIDToRunFilter);
                                 JobQueueEntry.FILTERGROUP := 0;

                                 PAGE.RUN(PAGE::"Job Queue Entries",JobQueueEntry);
                               END;
                                }
      { 29      ;1   ;Action    ;
                      Name=SkippedSynchRecords;
                      CaptionML=[DAN=Synkr. records, der springes over;
                                 ENU=Skipped Synch. Records];
                      ToolTipML=[DAN=Vis listen over records, der vil blive sprunget over i synkroniseringen.;
                                 ENU=View the list of records that will be skipped for synchronization.];
                      ApplicationArea=#Suite;
                      RunObject=Page 5333;
                      Promoted=Yes;
                      Enabled="Is Enabled";
                      Image=NegativeLines;
                      PromotedCategory=Category4;
                      RunPageMode=View }
      { 6       ;1   ;Action    ;
                      Name=EncryptionManagement;
                      CaptionML=[DAN=Administration af kryptering;
                                 ENU=Encryption Management];
                      ToolTipML=[DAN=Aktiv‚r eller deaktiver datakryptering. Datakryptering er med til at sikre, at uautoriserede brugere ikke kan l‘se virksomhedsdata.;
                                 ENU=Enable or disable data encryption. Data encryption helps make sure that unauthorized users cannot read business data.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 9905;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=EncryptionKeys;
                      PromotedCategory=Category5;
                      RunPageMode=View }
    }
  }
  CONTROLS
  {
    { 1900000001;;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                Name=NAVToCRM;
                CaptionML=[DAN=Forbindelse fra Dynamics NAV til Dynamics 365 for Sales;
                           ENU=Connection from Dynamics NAV to Dynamics 365 for Sales];
                GroupType=Group }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver URL-adressen til den Dynamics 365 for Sales-server, der hoster den Dynamics 365 for Sales-l›sning, som du vil oprette forbindelse til.;
                           ENU=Specifies the URL of the Dynamics 365 for Sales server that hosts the Dynamics 365 for Sales solution that you want to connect to.];
                ApplicationArea=#Suite;
                SourceExpr="Server Address";
                Editable=IsEditable;
                OnValidate=BEGIN
                             ConnectionString := GetConnectionString;
                           END;
                            }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver brugernavnet p† en Dynamics 365 for Sales-konto.;
                           ENU=Specifies the user name of a Dynamics 365 for Sales account.];
                ApplicationArea=#Suite;
                SourceExpr="User Name";
                Editable=IsEditable;
                OnValidate=BEGIN
                             ConnectionString := GetConnectionString;
                           END;
                            }

    { 7   ;2   ;Field     ;
                Name=Password;
                ExtendedDatatype=Masked;
                ToolTipML=[DAN=Angiver adgangskoden til en Dynamics 365 for Sales-brugerkonto.;
                           ENU=Specifies the password of a Dynamics 365 for Sales user account.];
                ApplicationArea=#Suite;
                SourceExpr=CRMPassword;
                Enabled=IsEditable;
                OnValidate=BEGIN
                             IF (CRMPassword <> '') AND (NOT ENCRYPTIONENABLED) THEN
                               IF CONFIRM(EncryptionIsNotActivatedQst) THEN
                                 PAGE.RUNMODAL(PAGE::"Data Encryption Management");
                             SetPassword(CRMPassword);
                           END;
                            }

    { 11  ;2   ;Field     ;
                CaptionML=[@@@=Name of tickbox which shows whether the connection is enabled or disabled;
                           DAN=Aktiveret;
                           ENU=Enabled];
                ToolTipML=[DAN=Angiver, om forbindelsen til Dynamics 365 for Sales er aktiveret.;
                           ENU=Specifies if the connection to Dynamics 365 for Sales is enabled.];
                ApplicationArea=#Suite;
                SourceExpr="Is Enabled";
                OnValidate=BEGIN
                             CurrPage.UPDATE(TRUE);
                           END;
                            }

    { 22  ;2   ;Field     ;
                Name=ScheduledSynchJobsActive;
                CaptionML=[DAN=Aktive planlagte synkroniseringsjob;
                           ENU=Active scheduled synchronization jobs];
                ToolTipML=[DAN=Angiver, hvor mange af standardposterne i jobk›er til integrationssynkronisering er klar til automatisk at synkronisere data mellem Dynamics NAV og Dynamics 365 for Sales.;
                           ENU=Specifies how many of the default integration synchronization job queue entries ready to automatically synchronize data between Dynamics NAV and Dynamics 365 for Sales.];
                ApplicationArea=#Suite;
                SourceExpr=ScheduledSynchJobsRunning;
                Editable=false;
                StyleExpr=ScheduledSynchJobsRunningStyleExpr;
                OnDrillDown=VAR
                              ScheduledSynchJobsRunningMsg@1000 : Text;
                            BEGIN
                              IF TotalJobs = 0 THEN
                                ScheduledSynchJobsRunningMsg := JobQueueIsNotRunningMsg
                              ELSE
                                IF ActiveJobs = TotalJobs THEN
                                  ScheduledSynchJobsRunningMsg := AllScheduledJobsAreRunningMsg
                                ELSE
                                  ScheduledSynchJobsRunningMsg := STRSUBSTNO(PartialScheduledJobsAreRunningMsg,ActiveJobs,TotalJobs);
                              MESSAGE(ScheduledSynchJobsRunningMsg);
                            END;
                             }

    { 33  ;2   ;Field     ;
                ApplicationArea=#Suite }

    { 8   ;1   ;Group     ;
                Name=CRMToNAV;
                CaptionML=[DAN=Forbindelse fra Dynamics 365 for Sales til Dynamics NAV;
                           ENU=Connection from Dynamics 365 for Sales to Dynamics NAV];
                Visible="Is Enabled";
                GroupType=Group }

    { 16  ;2   ;Field     ;
                Name=NAVURL;
                CaptionML=[DAN=URL til Dynamics NAV-webklient;
                           ENU=Dynamics NAV Web Client URL];
                ToolTipML=[DAN=Angiver URL-adressen til Dynamics NAV-webklienten. Fra records i Dynamics 365 for Sales, f.eks. en konto eller et produkt, kan brugere †bne en tilsvarende (sammenk‘det) record i Dynamics NAV, som †bnes i Dynamics NAV-webklienten. Angiv dette felt til URL-adressen til den forekomst af Dynamics NAV-webklienten, der skal bruges.;
                           ENU=Specifies the URL of Dynamics NAV web client. From records in Dynamics 365 for Sales, such as an account or product, users can open a corresponding (coupled) record in Dynamics NAV, which opens in the Dynamics NAV web client. Set this field to the URL of the Dynamics NAV web client instance to use.];
                ApplicationArea=#Suite;
                SourceExpr="Dynamics NAV URL";
                Enabled="Is CRM Solution Installed" }

    { 28  ;2   ;Field     ;
                ApplicationArea=#Suite }

    { 34  ;2   ;Field     ;
                ApplicationArea=#Suite }

    { 24  ;2   ;Field     ;
                Name=NAVODataURL;
                CaptionML=[DAN=Dynamics NAV OData-webtjenestes URL-adresse;
                           ENU=Dynamics NAV OData Webservice URL];
                ToolTipML=[DAN=Angiver URL-adressen til Dynamics NAV OData-webtjenester. Fra salgsordrerecords i Dynamics 365 for Sales kan brugere hente oplysninger om varedisponering for en Dynamics NAV-vare sammenk‘det med -produktet i posten med salgsordrerecords i Dynamics 365 for Sales. Angiv dette felt til URL-adressen til de Dynamics NAV OData-webtjenester, der skal bruges.;
                           ENU=Specifies the URL of Dynamics NAV OData web services. From sales order records in Dynamics 365 for Sales, users can retrieve item availability information for Dynamics NAV items coupled to sales order detail records in Dynamics 365 for Sales. Set this field to the URL of the Dynamics NAV OData web services to use.];
                ApplicationArea=#Suite;
                SourceExpr="Dynamics NAV OData URL";
                Enabled="Is CRM Solution Installed" }

    { 31  ;2   ;Field     ;
                Name=NAVODataUsername;
                Lookup=Yes;
                CaptionML=[DAN=Brugernavn for Dynamics NAV OData-webtjeneste;
                           ENU=Dynamics NAV OData Webservice Username];
                ToolTipML=[DAN=Angiver brugernavnet for at adgang til Dynamics NAV OData-webtjenester.;
                           ENU=Specifies the user name to access Dynamics NAV OData web services.];
                ApplicationArea=#Suite;
                SourceExpr="Dynamics NAV OData Username";
                Enabled="Is CRM Solution Installed";
                LookupPageID=Users }

    { 32  ;2   ;Field     ;
                Name=NAVODataAccesskey;
                CaptionML=[DAN=Adgangsn›gle for Dynamics NAV OData-webtjeneste;
                           ENU=Dynamics NAV OData Webservice Accesskey];
                ToolTipML=[DAN=Angiver adgangsn›glen for at adgang til Dynamics NAV OData-webtjenester.;
                           ENU=Specifies the access key to access Dynamics NAV OData web services.];
                ApplicationArea=#Suite;
                SourceExpr="Dynamics NAV OData Accesskey";
                Enabled="Is CRM Solution Installed";
                Editable=FALSE }

    { 20  ;1   ;Group     ;
                Name=CRMSettings;
                CaptionML=[DAN=Indstillinger for Dynamics 365 for Sales;
                           ENU=Dynamics 365 for Sales Settings];
                Visible="Is Enabled";
                GroupType=Group }

    { 25  ;2   ;Field     ;
                CaptionML=[DAN=Version;
                           ENU=Version];
                ToolTipML=[DAN=Angiver versionen af Dynamics 365 for Sales.;
                           ENU=Specifies the version of Dynamics 365 for Sales.];
                ApplicationArea=#Suite;
                SourceExpr="CRM Version";
                Editable=FALSE;
                StyleExpr=CRMVersionStyleExpr;
                OnDrillDown=BEGIN
                              IF IsVersionValid THEN
                                MESSAGE(FavorableCRMVersionMsg,CRMProductName.SHORT)
                              ELSE
                                MESSAGE(UnfavorableCRMVersionMsg,PRODUCTNAME.SHORT,CRMProductName.SHORT);
                            END;
                             }

    { 15  ;2   ;Field     ;
                CaptionML=[DAN=Dynamics NAV-integrationsl›sning importeret;
                           ENU=Dynamics NAV Integration Solution Imported];
                ToolTipML=[DAN=Angiver, om Dynamics NAV-integrationsl›sningen er installeret og konfigureret i Dynamics 365 for Sales. Du kan ikke ‘ndre denne indstilling.;
                           ENU=Specifies whether the Dynamics NAV Integration Solution is installed and configured in Dynamics 365 for Sales. You cannot change this setting.];
                ApplicationArea=#Suite;
                SourceExpr="Is CRM Solution Installed";
                Editable=FALSE;
                StyleExpr=CRMSolutionInstalledStyleExpr;
                OnDrillDown=BEGIN
                              IF "Is CRM Solution Installed" THEN
                                MESSAGE(FavorableCRMSolutionInstalledMsg,PRODUCTNAME.SHORT,CRMProductName.SHORT)
                              ELSE
                                MESSAGE(UnfavorableCRMSolutionInstalledMsg,PRODUCTNAME.SHORT);
                            END;
                             }

    { 21  ;2   ;Field     ;
                CaptionML=[DAN=Integration af salgsordrer er aktiveret;
                           ENU=Sales Order Integration Enabled];
                ToolTipML=[DAN=Angiver, at det er muligt for Dynamics 365 for Sales-brugere at sende salgsordrer, der derefter kan vises i og importeres til Dynamics NAV.;
                           ENU=Specifies that it is possible for Dynamics 365 for Sales users to submit sales orders that can then be viewed and imported in Dynamics NAV.];
                ApplicationArea=#Suite;
                SourceExpr="Is S.Order Integration Enabled";
                OnValidate=BEGIN
                             SetAutoCreateSalesOrdersEditable;
                           END;
                            }

    { 40  ;2   ;Field     ;
                CaptionML=[DAN=Opret salgsordrer automatisk;
                           ENU=Automatically Create Sales Orders];
                ToolTipML=[DAN=Angiver, at salgsordrer oprettes automatisk fra salgsordrer, der sendes i Dynamics 365 for Sales.;
                           ENU=Specifies that sales orders will be created automatically from sales orders that are submitted in Dynamics 365 for Sales.];
                ApplicationArea=#Suite;
                SourceExpr="Auto Create Sales Orders";
                Editable=IsAutoCreateSalesOrdersEditable }

    { 26  ;1   ;Group     ;
                Name=AdvancedSettings;
                CaptionML=[DAN=Avancerede indstillinger;
                           ENU=Advanced Settings];
                Visible="Is Enabled";
                GroupType=Group }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at Dynamics NAV-brugere skal have en tilsvarende brugerkonto i Dynamics 365 for Sales for at have Dynamics 365 for Sales-integrationsfunktioner i brugergr‘nsefladen.;
                           ENU=Specifies that Dynamics NAV users must have a matching user account in Dynamics 365 for Sales to have Dynamics 365 for Sales integration capabilities in the user interface.];
                ApplicationArea=#Suite;
                SourceExpr="Is User Mapping Required";
                OnValidate=BEGIN
                             UpdateIsEnabledState;
                             SetStyleExpr;
                           END;
                            }

    { 18  ;2   ;Field     ;
                CaptionML=[DAN=Den aktuelle Dynamics NAV-bruger er knyttet til en Dynamics 365 for Sales-bruger;
                           ENU=Current Dynamics NAV User is Mapped to a Dynamics 365 for Sales User];
                ToolTipML=[DAN=Angiver, at den brugerkonto, du har brugt til at logge p† med, har en tilsvarende brugerkonto i Dynamics 365 for Sales.;
                           ENU=Specifies that the user account that you used to sign in with has a matching user account in Dynamics 365 for Sales.];
                ApplicationArea=#Suite;
                SourceExpr="Is User Mapped To CRM User";
                Visible="Is User Mapping Required";
                Editable=FALSE;
                StyleExpr=UserMappedToCRMUserStyleExpr;
                OnDrillDown=BEGIN
                              IF "Is User Mapped To CRM User" THEN
                                MESSAGE(CurrentuserIsMappedToCRMUserMsg,USERID,PRODUCTNAME.SHORT,CRMProductName.SHORT)
                              ELSE
                                MESSAGE(CurrentuserIsNotMappedToCRMUserMsg,USERID,PRODUCTNAME.SHORT,CRMProductName.SHORT);
                            END;
                             }

    { 30  ;2   ;Field     ;
                ApplicationArea=#Suite }

    { 36  ;1   ;Group     ;
                Name=AuthTypeDetails;
                CaptionML=[DAN=Detaljer om godkendelsestype;
                           ENU=Authentication Type Details];
                Visible=NOT SoftwareAsAService;
                GroupType=Group }

    { 37  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den godkendelsestype, der anvendes til at godkende med Dynamics 365 for Sales.;
                           ENU=Specifies the authentication type that will be used to authenticate with Dynamics 365 for Sales];
                ApplicationArea=#Advanced;
                SourceExpr="Authentication Type";
                Editable=NOT "Is Enabled";
                OnValidate=BEGIN
                             SetIsConnectionStringEditable;
                             ConnectionString := GetConnectionString;
                           END;
                            }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver dom‘nenavnet for din Dynamics 365 for Sales-installation.;
                           ENU=Specifies the domain name of your Dynamics 365 for Sales deployment.];
                ApplicationArea=#Advanced;
                SourceExpr=Domain }

    { 38  ;2   ;Field     ;
                Name=Connection String;
                CaptionML=[DAN=Forbindelsesstreng;
                           ENU=Connection String];
                ToolTipML=[DAN=Angiver den forbindelsesstreng, der anvendes til at oprette forbindelse til Dynamics 365 for Sales.;
                           ENU=Specifies the connection string that will be used to connect to Dynamics 365 for Sales];
                ApplicationArea=#Advanced;
                SourceExpr=ConnectionString;
                Editable=IsConnectionStringEditable;
                OnValidate=BEGIN
                             SetConnectionString(ConnectionString);
                           END;
                            }

  }
  CODE
  {
    VAR
      AssistedSetup@1010 : Record 1803;
      CRMProductName@1017 : Codeunit 5344;
      CRMPassword@1000 : Text;
      ResetIntegrationTableMappingConfirmQst@1003 : TextConst '@@@="%1 = CRM product name";DAN=Dette sletter alle eksisterende integrationstabelkoblinger og %1-synkroniseringsjob og installerer standardkoblingerne for integrationstabeller og job til %1-synkronisering.\\Vil du forts‘tte?;ENU=This will delete all existing integration table mappings and %1 synchronization jobs and install the default integration table mappings and jobs for %1 synchronization.\\Are you sure that you want to continue?';
      ConfirmGenerateIntegrationIdsQst@1006 : TextConst 'DAN=Du er ved at inds‘tte integrationsoplysninger i tabeller. Det kan tage flere minutter. Vil du forts‘tte?;ENU=You are about to add integration data to tables. This process may take several minutes. Do you want to continue?';
      GenerateIntegrationIdsSuccessMsg@1005 : TextConst 'DAN=Integrationsoplysningerne er indsat i tabellerne.;ENU=The integration data has been added to the tables.';
      EncryptionIsNotActivatedQst@1016 : TextConst 'DAN=Datakryptering er ikke aktiveret i ›jeblikket. Vi anbefaler, at du krypterer data. \Vil du †bne vinduet Administration af datakryptering?;ENU=Data encryption is currently not enabled. We recommend that you encrypt data. \Do you want to open the Data Encryption Management window?';
      WebClientUrlResetMsg@1014 : TextConst '@@@=%1 - product name;DAN=URL-adressen til %1-webklienten er blevet nulstillet til standardv‘rdien.;ENU=The %1 Web Client URL has been reset to the default value.';
      SyncNowSuccessMsg@1018 : TextConst '@@@="%1 = Page 5338 Caption";DAN=Synkronisering af ‘ndrede records er fuldf›rt.\Detaljerne kan ses i vinduet %1.;ENU=Synchronize Modified Records completed.\See the %1 window for details.';
      UnfavorableCRMVersionMsg@1033 : TextConst '@@@="%1 - product name, %2 = CRM product name";DAN=Denne version af %2 fungerer muligvis ikke korrekt sammen med %1. Vi anbefaler, at du opgraderer til en underst›ttet version.;ENU=This version of %2 might not work correctly with %1. We recommend you upgrade to a supported version.';
      FavorableCRMVersionMsg@1034 : TextConst '@@@="%1 = CRM product name";DAN=Denne version af %1 er gyldig.;ENU=The version of %1 is valid.';
      UnfavorableCRMSolutionInstalledMsg@1036 : TextConst '@@@=%1 - product name;DAN=%1-integrationsl›sningen blev ikke registreret.;ENU=The %1 Integration Solution was not detected.';
      FavorableCRMSolutionInstalledMsg@1037 : TextConst '@@@="%1 - product name, %2 = CRM product name";DAN=%1-integrationsl›sningen er installeret i %2.;ENU=The %1 Integration Solution is installed in %2.';
      SynchronizeModifiedQst@1038 : TextConst 'DAN=Dette synkroniserer alle ‘ndrede records i alle integrationstabelkoblinger.\\Vil du forts‘tte?;ENU=This will synchronize all modified records in all Integration Table Mappings.\\Do you want to continue?';
      ReadyScheduledSynchJobsTok@1049 : TextConst '@@@="%1 = Count of scheduled job queue entries in ready or in process state, %2 count of all scheduled jobs";DAN=%1 af %2;ENU=%1 of %2';
      ScheduledSynchJobsRunning@1002 : Text;
      CurrentuserIsMappedToCRMUserMsg@1053 : TextConst '@@@="%1 = Current User ID, %2 - product name, %3 = CRM product name";DAN=%2-brugeren (%1) er koblet til en %3.;ENU=%2 user (%1) is mapped to a %3 user.';
      CurrentuserIsNotMappedToCRMUserMsg@1054 : TextConst '@@@="%1 = Current User ID, %2 - product name, %3 = CRM product name";DAN=Da feltet %2-brugere skal kobles til %3-brugere er markeret, er integration af %3 ikke aktiveret for %1.\\Hvis du vil aktivere %3-integration for %2-brugeren %1, skal godkendelsesmailadressen v‘re den samme som en %3-brugers prim‘re mailadresse.;ENU=Because the %2 Users Must Map to %3 Users field is set, %3 integration is not enabled for %1.\\To enable %3 integration for %2 user %1, the authentication email must match the primary email of a %3 user.';
      EnableServiceQst@1057 : TextConst '@@@="%1 = This Page Caption (Microsoft Dynamics 365 Connection Setup)";DAN=%1 er ikke aktiveret. Er du sikker p†, at du vil afslutte?;ENU=The %1 is not enabled. Are you sure you want to exit?';
      PartialScheduledJobsAreRunningMsg@1046 : TextConst '@@@="%1 = Count of scheduled job queue entries in ready or in process state, %2 count of all scheduled jobs";DAN=En aktiv opgavek› er tilg‘ngelig, men kun %1 ud af de %2 planlagte synkroniseringsjob er klar eller ved at blive behandlet.;ENU=An active job queue is available but only %1 of the %2 scheduled synchronization jobs are ready or in process.';
      JobQueueIsNotRunningMsg@1048 : TextConst 'DAN=Der er ikke startet en opgavek›. Behandling af planlagte synkroniseringsopgaver kr‘ver, at der findes en aktiv opgavek›.\\Kontakt din administrator for at f† konfigureret og startet en opgavek›.;ENU=There is no job queue started. Scheduled synchronization jobs require an active job queue to process jobs.\\Contact your administrator to get a job queue configured and started.';
      AllScheduledJobsAreRunningMsg@1045 : TextConst 'DAN=Der er startet en opgavek›, og alle planlagte synkroniseringsopgaver er klar eller ved at blive behandlet.;ENU=An job queue is started and all scheduled synchronization jobs are ready or already processing.';
      SetupSuccessfulMsg@1001 : TextConst '@@@="%1 = CRM product name";DAN=Standardops‘tningen af %1-synkronisering er fuldf›rt.;ENU=The default setup for %1 synchronization has completed successfully.';
      ScheduledSynchJobsRunningStyleExpr@1011 : Text;
      CRMSolutionInstalledStyleExpr@1012 : Text;
      CRMVersionStyleExpr@1013 : Text;
      UserMappedToCRMUserStyleExpr@1019 : Text;
      ConnectionString@1020 : Text;
      ActiveJobs@1007 : Integer;
      TotalJobs@1004 : Integer;
      IsEditable@1008 : Boolean;
      IsWebCliResetEnabled@1009 : Boolean;
      AssistedSetupAvailable@1058 : Boolean;
      SoftwareAsAService@1015 : Boolean;
      IsConnectionStringEditable@1022 : Boolean;
      IsAutoCreateSalesOrdersEditable@1021 : Boolean;

    LOCAL PROCEDURE RefreshData@19();
    BEGIN
      UpdateIsEnabledState;
      SetIsConnectionStringEditable;
      RefreshDataFromCRM;
      SetAutoCreateSalesOrdersEditable;
      RefreshSynchJobsData;
      UpdateEnableFlags;
      SetStyleExpr;
    END;

    LOCAL PROCEDURE RefreshSynchJobsData@20();
    BEGIN
      CountCRMJobQueueEntries(ActiveJobs,TotalJobs);
      ScheduledSynchJobsRunning := STRSUBSTNO(ReadyScheduledSynchJobsTok,ActiveJobs,TotalJobs);
      ScheduledSynchJobsRunningStyleExpr := GetRunningJobsStyleExpr;
    END;

    LOCAL PROCEDURE SetStyleExpr@9();
    BEGIN
      CRMSolutionInstalledStyleExpr := GetStyleExpr("Is CRM Solution Installed");
      CRMVersionStyleExpr := GetStyleExpr(IsVersionValid);
      UserMappedToCRMUserStyleExpr := GetStyleExpr("Is User Mapped To CRM User");
    END;

    LOCAL PROCEDURE SetIsConnectionStringEditable@4();
    BEGIN
      IsConnectionStringEditable :=
        NOT "Is Enabled";
    END;

    LOCAL PROCEDURE SetAutoCreateSalesOrdersEditable@2();
    BEGIN
      IsAutoCreateSalesOrdersEditable := "Is S.Order Integration Enabled";
    END;

    LOCAL PROCEDURE GetRunningJobsStyleExpr@1() StyleExpr : Text;
    BEGIN
      IF ActiveJobs < TotalJobs THEN
        StyleExpr := 'Ambiguous'
      ELSE
        StyleExpr := GetStyleExpr((ActiveJobs = TotalJobs) AND (TotalJobs <> 0))
    END;

    LOCAL PROCEDURE GetStyleExpr@6(Favorable@1000 : Boolean) StyleExpr : Text;
    BEGIN
      IF Favorable THEN
        StyleExpr := 'Favorable'
      ELSE
        StyleExpr := 'Unfavorable'
    END;

    LOCAL PROCEDURE UpdateEnableFlags@3();
    BEGIN
      IsEditable := NOT "Is Enabled";
      IsWebCliResetEnabled := "Is CRM Solution Installed" AND "Is Enabled For User";
    END;

    BEGIN
    END.
  }
}

