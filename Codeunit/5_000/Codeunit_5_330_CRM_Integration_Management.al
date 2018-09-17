OBJECT Codeunit 5330 CRM Integration Management
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    Permissions=TableData 1261=rimd;
    SingleInstance=Yes;
    OnRun=BEGIN
            CheckOrEnableCRMConnection;
          END;

  }
  CODE
  {
    VAR
      CRMEntityUrlTemplateTxt@1001 : TextConst '@@@={Locked};DAN="%1/main.aspx?pagetype=entityrecord&etn=%2&id=%3";ENU="%1/main.aspx?pagetype=entityrecord&etn=%2&id=%3"';
      UnableToResolveCRMEntityNameFrmTableIDErr@1002 : TextConst '@@@="%1 = table ID (numeric), %2 = CRM Product Name";DAN=Programmet er ikke designet til at integrere tabellen %1 med %2.;ENU=The application is not designed to integrate table %1 with %2.';
      CouplingNotFoundErr@1000 : TextConst '@@@="%1 = CRM Product Name";DAN=Recorden er ikke sammenk�det med %1.;ENU=The record is not coupled to %1.';
      NoCardPageActionDefinedForTableIdErr@1022 : TextConst '@@@="%1 = Table ID";DAN=Handlingen �bn side underst�ttes ikke for tabellen %1.;ENU=The open page action is not supported for Table %1.';
      IntegrationTableMappingNotFoundErr@1005 : TextConst '@@@="%1 = Integration Table Mapping caption, %2 = Table caption for the table which is not mapped";DAN=%1 blev ikke fundet for tabel %2 .;ENU=No %1 was found for table %2.';
      UpdateNowDirectionQst@1006 : TextConst '@@@="String menu options separated by comma. %1 = CRM Product Name";DAN=Send dataopdatering til %1.,Hent dataopdatering fra %1.;ENU=Send data update to %1.,Get data update from %1.';
      UpdateOneNowTitleTxt@1007 : TextConst '@@@="%1 = Table caption and value for the entity we want to synchronize now.";DAN=Synkroniser data for %1?;ENU=Synchronize data for %1?';
      UpdateMultipleNowTitleTxt@1014 : TextConst 'DAN=Vil du synkronisere data til de valgte records?;ENU=Synchronize data for the selected records?';
      ManageCouplingQst@1003 : TextConst '@@@="%1=The record caption (type), %2 = CRM Product Name";DAN=Recorden %1 er ikke sammenk�det med %2. Vil du oprette en sammenk�dning?;ENU=The %1 record is not coupled to %2. Do you want to create a coupling?';
      SyncNowFailedMsg@1037 : TextConst 'DAN=Synkroniseringen mislykkedes.;ENU=The synchronization failed.';
      SyncNowScheduledMsg@1004 : TextConst 'DAN=Synkroniseringen er blevet planlagt.;ENU=The synchronization has been scheduled.';
      SyncNowSkippedMsg@1053 : TextConst 'DAN=Synkroniseringen er blevet sprunget over.;ENU=The synchronization has been skipped.';
      SyncMultipleMsg@1038 : TextConst '@@@=%1,%2,%3,%4 are numbers of records;DAN=Synkroniseringen var planlagt for %1 af %4 records. %2 records mislykkedes. %3 records blev sprunget over.;ENU=The synchronization has been scheduled for %1 of %4 records. %2 records failed. %3 records were skipped.';
      SyncSkippedMsg@1008 : TextConst 'DAN=Recorden bliver sprunget over for yderligere synkronisering p� grund af en gentagelig fejl.;ENU=The record will be skipped for further synchronization due to a repeatable failure.';
      SyncRestoredMsg@1010 : TextConst 'DAN=Recorden er blevet gendannet til synkronisering.;ENU=The record has been restored for synchronization.';
      SyncMultipleRestoredMsg@1012 : TextConst '@@@=%1 - an integer, a count of records.;DAN=%1 records er blevet gendannet til synkronisering.;ENU=%1 records have been restored for synchronization.';
      DetailsTxt@1009 : TextConst 'DAN=Detaljer.;ENU=Details.';
      UpdateOneNowToCRMQst@1017 : TextConst '@@@="%1 = Table caption and value for the entity we want to synchronize now., %2 = short CRM Product Name";DAN=Send dataopdatering til %2 for %1?;ENU=Send data update to %2 for %1?';
      UpdateOneNowToModifiedCRMQst@1033 : TextConst '@@@="%1 = Table caption and value for the entity we want to synchronize now. %2 - product name, %3 = short CRM product name";DAN=Den %3-record, der er sammenk�det med %1, indeholder nyere data end %2-recorden. Vil du overskrive dataene i %3?;ENU=The %3 record coupled to %1 contains newer data than the %2 record. Do you want to overwrite the data in %3?';
      UpdateOneNowFromCRMQst@1018 : TextConst '@@@="%1 = Table caption and value for the entity we want to synchronize now., %2 = short CRM product name";DAN=Hent dataopdatering fra %2 for %1?;ENU=Get data update from %2 for %1?';
      UpdateOneNowFromOldCRMQst@1011 : TextConst '@@@="%1 = Table caption and value for the entity we want to synchronize now. %2 - product name, %3 = short CRM product name";DAN=%2-recorden %1 indeholder nyere data end recorden %3. Vil du hente en dataopdatering fra %3 og overskrive dataene i %2?;ENU=The %2 record %1 contains newer data than the %3 record. Get data update from %3, overwriting data in %2?';
      UpdateMultipleNowToCRMQst@1019 : TextConst '@@@="%1 = short CRM product name";DAN=Send dataopdatering til %1 for de valgte records?;ENU=Send data update to %1 for the selected records?';
      UpdateMultipleNowFromCRMQst@1020 : TextConst '@@@="%1 = short CRM product name";DAN=Hent dataopdatering fra %1 for de valgte records?;ENU=Get data update from %1 for the selected records?';
      AccountStatisticsUpdatedMsg@1024 : TextConst '@@@="%1 = short CRM product name";DAN=Debitorstatistik er opdateret i %1.;ENU=The customer statistics have been successfully updated in %1.';
      BothRecordsModifiedBiDirectionalMsg@1029 : TextConst '@@@="%1 and %2 area captions of tables such as Customer and CRM Account, %3 = short CRM product name";DAN=B�de recorden %1 og %3 %2-recorden er blevet �ndret siden den seneste synkronisering, eller synkroniseringen er aldrig blevet udf�rt. Hvis du forts�tter med synkroniseringen, vil data i �n af disse records g� tabt og blive erstattet af data fra den anden record.;ENU=Both the %1 record and the %3 %2 record have been changed since the last synchronization, or synchronization has never been performed. If you continue with synchronization, data on one of the records will be lost and replaced with data from the other record.';
      BothRecordsModifiedToCRMQst@1030 : TextConst '@@@="%1 is a formatted RecordID, such as ''Customer 1234''. %2 is the caption of a CRM table. %3 - product name, %4 = short CRM product name";DAN=B�de recorden %1 og %4 %2-recorden er blevet �ndret siden den seneste synkronisering, eller synkroniseringen er aldrig blevet udf�rt. Hvis du forts�tter med synkroniseringen, vil data i %4 blive overskrevet af data fra %3. Er du sikker p�, at du vil synkronisere?;ENU=Both %1 and the %4 %2 record have been changed since the last synchronization, or synchronization has never been performed. If you continue with synchronization, data in %4 will be overwritten with data from %3. Are you sure you want to synchronize?';
      BothRecordsModifiedToNAVQst@1031 : TextConst '@@@="%1 is a formatted RecordID, such as ''Customer 1234''. %2 is the caption of a CRM table. %3 - product name, %4 = short CRM product name";DAN=B�de recorden %1 og %4 %2-recorden er blevet �ndret siden den seneste synkronisering, eller synkroniseringen er aldrig blevet udf�rt. Hvis du forts�tter med synkroniseringen, vil data i %3 blive overskrevet af data fra %4. Er du sikker p�, at du vil synkronisere?;ENU=Both %1 and the %4 %2 record have been changed since the last synchronization, or synchronization has never been performed. If you continue with synchronization, data in %3 will be overwritten with data from %4. Are you sure you want to synchronize?';
      CRMProductName@1015 : Codeunit 5344;
      CRMIntegrationEnabledState@1021 : ' ,Not Enabled,Enabled,Enabled But Not For Current User';
      NotEnabledForCurrentUserMsg@1035 : TextConst '@@@="%1 = Current User Id %2 - product name, %3 = CRM product name";DAN=Integration af %3 er aktiveret.\Men da feltet %2-brugere skal knyttes til %3-brugere er markeret, er integration af %3 ikke aktiveret for %1.;ENU=%3 Integration is enabled.\However, because the %2 Users Must Map to %3 Users field is set, %3 integration is not enabled for %1.';
      CRMIntegrationEnabledLastError@1036 : Text;
      ImportSolutionConnectStringTok@1039 : TextConst '@@@={Locked};DAN=%1api%2/XRMServices/2011/Organization.svc;ENU=%1api%2/XRMServices/2011/Organization.svc';
      UserDoesNotExistCRMTxt@1042 : TextConst '@@@="%1 = User email address, %2 = CRM product name";DAN=Der er ingen bruger med mailadressen %1 i %2. Angiv en gyldig mailadresse.;ENU=There is no user with email address %1 in %2. Enter a valid email address.';
      RoleIdDoesNotExistCRMTxt@1043 : TextConst '@@@="%1 = CRM Product name";DAN=Integrationsrollen findes ikke i %1. \\Kontroll�r, at den relevante tilpasning er importeret, eller om navnet p� rollen er �ndret.;ENU=The Integration role does not exist in %1. \\Make sure the relevant customization is imported or check if the name of the role has changed.';
      EmailAndServerAddressEmptyErr@1046 : TextConst 'DAN=Integration-felterne Brugermail og Serveradresse m� ikke v�re tomme.;ENU=The Integration User Email and Server Address fields must not be empty.';
      CRMSolutionFileNotFoundErr@1041 : TextConst 'DAN=Der blev ikke fundet en fil til en CRM-l�sning.;ENU=A file for a CRM solution could not be found.';
      MicrosoftDynamicsNavIntegrationTxt@1040 : TextConst '@@@={Locked};DAN=MicrosoftDynamicsNavIntegration;ENU=MicrosoftDynamicsNavIntegration';
      AdminEmailPasswordWrongErr@1044 : TextConst '@@@="%1 = CRM product name";DAN=Indtast gyldige legitimationsoplysninger for en %1-administrator.;ENU=Enter valid %1 administrator credentials.';
      AdminUserDoesNotHavePriviligesErr@1045 : TextConst '@@@="%1 = CRM product name";DAN=Den angivne %1-administrator har ikke tilstr�kkelige rettigheder til at importere en %1-l�sning.;ENU=The specified %1 administrator does not have sufficient privileges to import a %1 solution.';
      InvalidUriErr@1050 : TextConst 'DAN=Den angivne v�rdi er ikke en gyldig URL-adresse.;ENU=The value entered is not a valid URL.';
      MustUseHttpsErr@1049 : TextConst '@@@="%1 = CRM product name";DAN=Programmet er kun konfigureret til at underst�tte sikre forbindelser (HTTPS) til %1. HTTP kan ikke anvendes.;ENU=The application is set up to support secure connections (HTTPS) to %1 only. You cannot use HTTP.';
      MustUseHttpOrHttpsErr@1048 : TextConst '@@@="%1 is a URI scheme, such as FTP, HTTP, chrome or file, %2 = CRM product name";DAN=%1 er ikke et gyldigt URI-skema til %2-forbindelser. Du kan kun bruge HTTPS eller HTTP som skema i URL-adressen.;ENU=%1 is not a valid URI scheme for %2 connections. You can only use HTTPS or HTTP as the scheme in the URL.';
      ReplaceServerAddressQst@1047 : TextConst '@@@=%1 and %2 are URLs;DAN=URL-adressen er ikke gyldig. Vil du erstatte den med den URL-adresse, der foresl�s nedenfor?\\Angivet URL-adresse: "%1".\Forslag til URL-adresse: "%2".;ENU=The URL is not valid. Do you want to replace it with the URL suggested below?\\Entered URL: "%1".\Suggested URL: "%2".';
      CRMConnectionURLWrongErr@1051 : TextConst '@@@="%1 = CRM product name";DAN=URL-adressen er forkert. Indtast URL-adressen til %1-forbindelsen.;ENU=The URL is incorrect. Enter the URL for the %1 connection.';
      NoOf@1052 : ',Scheduled,Failed,Skipped,Total';
      CRMConnSetupWizardQst@1013 : TextConst '@@@="%1 = CRM product name";DAN=Vil du �bne guiden til assisteret ops�tning for Konfiguration af %1-forbindelse?;ENU=Do you want to open the %1 Connection assisted setup wizard?';

    [External]
    PROCEDURE IsCRMIntegrationEnabled@5() : Boolean;
    VAR
      CRMConnectionSetup@1000 : Record 5330;
    BEGIN
      IF CRMIntegrationEnabledState = CRMIntegrationEnabledState::" " THEN BEGIN
        CLEARLASTERROR;
        CRMIntegrationEnabledState := CRMIntegrationEnabledState::"Not Enabled";
        CLEAR(CRMIntegrationEnabledLastError);
        IF CRMConnectionSetup.GET THEN
          IF CRMConnectionSetup."Is Enabled" THEN BEGIN
            IF NOT HASTABLECONNECTION(TABLECONNECTIONTYPE::CRM,GETDEFAULTTABLECONNECTION(TABLECONNECTIONTYPE::CRM)) THEN
              CRMConnectionSetup.RegisterUserConnection;
            IF NOT CRMConnectionSetup."Is User Mapping Required" THEN
              CRMIntegrationEnabledState := CRMIntegrationEnabledState::Enabled
            ELSE
              IF CRMConnectionSetup.IsCurrentUserMappedToCrmSystemUser THEN
                CRMIntegrationEnabledState := CRMIntegrationEnabledState::Enabled
              ELSE BEGIN
                CRMIntegrationEnabledState := CRMIntegrationEnabledState::"Enabled But Not For Current User";
                CRMIntegrationEnabledLastError := GetLastErrorMessage;
              END;
          END;
      END;

      EXIT(CRMIntegrationEnabledState = CRMIntegrationEnabledState::Enabled);
    END;

    [Internal]
    PROCEDURE IsCRMSolutionInstalled@19() : Boolean;
    BEGIN
      IF TryTouchCRMSolutionEntities THEN
        EXIT(TRUE);

      CLEARLASTERROR;
      EXIT(FALSE);
    END;

    [TryFunction]
    LOCAL PROCEDURE TryTouchCRMSolutionEntities@27();
    VAR
      CRMNAVConnection@1001 : Record 5368;
      CRMAccountStatistics@1000 : Record 5367;
    BEGIN
      IF CRMAccountStatistics.FINDFIRST THEN;
      IF CRMNAVConnection.FINDFIRST THEN;
    END;

    [External]
    PROCEDURE SetCRMNAVConnectionUrl@38(WebClientUrl@1000 : Text[250]);
    VAR
      CRMNAVConnection@1002 : Record 5368;
      NewConnection@1001 : Boolean;
    BEGIN
      IF NOT CRMNAVConnection.FINDFIRST THEN BEGIN
        CRMNAVConnection.INIT;
        NewConnection := TRUE;
      END;

      CRMNAVConnection."Dynamics NAV URL" := WebClientUrl;

      IF NewConnection THEN
        CRMNAVConnection.INSERT
      ELSE
        CRMNAVConnection.MODIFY;
    END;

    [External]
    PROCEDURE SetCRMNAVODataUrlCredentials@48(ODataUrl@1000 : Text[250];Username@1003 : Text[250];Accesskey@1004 : Text[250]);
    VAR
      CRMNAVConnection@1002 : Record 5368;
      NewConnection@1001 : Boolean;
    BEGIN
      IF NOT CRMNAVConnection.FINDFIRST THEN BEGIN
        CRMNAVConnection.INIT;
        NewConnection := TRUE;
      END;

      CRMNAVConnection."Dynamics NAV OData URL" := ODataUrl;
      CRMNAVConnection."Dynamics NAV OData Username" := Username;
      CRMNAVConnection."Dynamics NAV OData Accesskey" := Accesskey;

      IF NewConnection THEN
        CRMNAVConnection.INSERT
      ELSE
        CRMNAVConnection.MODIFY;
    END;

    [External]
    PROCEDURE UpdateMultipleNow@14(RecVariant@1007 : Variant);
    VAR
      RecRef@1015 : RecordRef;
      RecordCounter@1016 : ARRAY [4] OF Integer;
      ShouldSendNotification@1008 : Boolean;
    BEGIN
      RecordCounter[NoOf::Total] := GetRecordRef(RecVariant,RecRef);
      IF RecordCounter[NoOf::Total] = 0 THEN
        EXIT;

      IF RecRef.NUMBER = DATABASE::"CRM Integration Record" THEN
        ShouldSendNotification := UpdateCRMIntRecords(RecRef,RecordCounter)
      ELSE
        ShouldSendNotification := UpdateRecords(RecRef,RecordCounter);
      IF ShouldSendNotification THEN
        SendSyncNotification(RecordCounter);
    END;

    LOCAL PROCEDURE UpdateCRMIntRecords@80(VAR RecRef@1001 : RecordRef;VAR RecordCounter@1000 : ARRAY [4] OF Integer) : Boolean;
    VAR
      CRMIntegrationRecord@1004 : Record 5331;
      IntegrationRecord@1003 : Record 5151;
      IntegrationTableMapping@1002 : Record 5335;
      SourceRecRef@1005 : RecordRef;
      SelectedDirection@1008 : Integer;
      Direction@1007 : Integer;
      Unused@1006 : Boolean;
    BEGIN
      IF RecordCounter[NoOf::Total] = 1 THEN BEGIN
        RecRef.SETTABLE(CRMIntegrationRecord);
        GetIntegrationTableMapping(IntegrationTableMapping,CRMIntegrationRecord."Table ID");
        IntegrationRecord.GET(CRMIntegrationRecord."Integration ID");
        SourceRecRef.GET(IntegrationRecord."Record ID");
        SelectedDirection :=
          GetSelectedSingleSyncDirection(IntegrationTableMapping,SourceRecRef,CRMIntegrationRecord."CRM ID",Unused)
      END ELSE BEGIN
        IntegrationTableMapping.Direction := IntegrationTableMapping.Direction::Bidirectional;
        SelectedDirection := GetSelectedMultipleSyncDirection(IntegrationTableMapping);
      END;
      IF SelectedDirection = 0 THEN
        EXIT(FALSE); // The user cancelled

      REPEAT
        RecRef.SETTABLE(CRMIntegrationRecord);
        GetIntegrationTableMapping(IntegrationTableMapping,CRMIntegrationRecord."Table ID");
        IF IntegrationTableMapping.Direction = IntegrationTableMapping.Direction::Bidirectional THEN
          Direction := SelectedDirection
        ELSE
          Direction := IntegrationTableMapping.Direction;
        IntegrationRecord.GET(CRMIntegrationRecord."Integration ID");
        IF EnqueueSyncJob(IntegrationTableMapping,IntegrationRecord."Record ID",CRMIntegrationRecord."CRM ID",Direction) THEN BEGIN
          CRMIntegrationRecord.Skipped := FALSE;
          CRMIntegrationRecord.MODIFY;
          RecordCounter[NoOf::Scheduled] += 1;
        END ELSE
          RecordCounter[NoOf::Failed] += 1;
      UNTIL RecRef.NEXT = 0;
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE UpdateRecords@81(VAR RecRef@1001 : RecordRef;VAR RecordCounter@1000 : ARRAY [4] OF Integer) : Boolean;
    VAR
      IntegrationTableMapping@1005 : Record 5335;
      SelectedDirection@1004 : Integer;
      CRMID@1003 : GUID;
      Unused@1002 : Boolean;
    BEGIN
      GetIntegrationTableMapping(IntegrationTableMapping,RecRef.NUMBER);

      IF RecordCounter[NoOf::Total] = 1 THEN
        IF GetCoupledCRMID(RecRef.RECORDID,CRMID) THEN
          SelectedDirection :=
            GetSelectedSingleSyncDirection(IntegrationTableMapping,RecRef,CRMID,Unused)
        ELSE BEGIN
          DefineCouplingIfNotCoupled(RecRef.RECORDID,CRMID);
          EXIT(FALSE);
        END
      ELSE
        SelectedDirection := GetSelectedMultipleSyncDirection(IntegrationTableMapping);
      IF SelectedDirection = 0 THEN
        EXIT(FALSE); // The user cancelled

      REPEAT
        IF NOT GetCoupledCRMID(RecRef.RECORDID,CRMID) THEN
          RecordCounter[NoOf::Skipped] += 1
        ELSE BEGIN
          IF (RecordCounter[NoOf::Total] > 1) AND
             WasRecordModifiedAfterLastSynch(IntegrationTableMapping,RecRef,CRMID,SelectedDirection)
          THEN
            RecordCounter[NoOf::Skipped] += 1
          ELSE
            IF IsRecordSkipped(RecRef.RECORDID) THEN
              RecordCounter[NoOf::Skipped] += 1
            ELSE
              IF EnqueueSyncJob(IntegrationTableMapping,RecRef.RECORDID,CRMID,SelectedDirection) THEN
                RecordCounter[NoOf::Scheduled] += 1
              ELSE
                RecordCounter[NoOf::Failed] += 1;
        END;
      UNTIL RecRef.NEXT = 0;
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE UpdateOneNow@17(RecordID@1000 : RecordID);
    BEGIN
      // Extinct method. Kept for backward compatibility.
      UpdateMultipleNow(RecordID)
    END;

    [Internal]
    PROCEDURE UpdateSkippedNow@71(VAR CRMIntegrationRecord@1000 : Record 5331);
    VAR
      IntegrationRecord@1001 : Record 5151;
      RestoredRecCounter@1003 : Integer;
    BEGIN
      IF CRMIntegrationRecord.FINDSET THEN
        REPEAT
          IF IntegrationRecord.GET(CRMIntegrationRecord."Integration ID") THEN BEGIN
            CRMIntegrationRecord.Skipped := FALSE;
            CRMIntegrationRecord.MODIFY;
            RestoredRecCounter += 1;
          END;
        UNTIL CRMIntegrationRecord.NEXT = 0;
      SendRestoredSyncNotification(RestoredRecCounter);
    END;

    LOCAL PROCEDURE WasRecordModifiedAfterLastSynch@75(IntegrationTableMapping@1001 : Record 5335;RecRef@1003 : RecordRef;CRMID@1002 : GUID;SelectedDirection@1000 : Option) : Boolean;
    VAR
      IntegrationRecSynchInvoke@1007 : Codeunit 5345;
      CRMRecordRef@1006 : RecordRef;
      RecordModified@1005 : Boolean;
      CRMRecordModified@1004 : Boolean;
    BEGIN
      RecordModified := IntegrationRecSynchInvoke.WasModifiedAfterLastSynch(IntegrationTableMapping,RecRef);
      IntegrationTableMapping.GetRecordRef(CRMID,CRMRecordRef);
      CRMRecordModified := IntegrationRecSynchInvoke.WasModifiedAfterLastSynch(IntegrationTableMapping,CRMRecordRef);
      EXIT(
        ((SelectedDirection = IntegrationTableMapping.Direction::ToIntegrationTable) AND CRMRecordModified) OR
        ((SelectedDirection = IntegrationTableMapping.Direction::FromIntegrationTable) AND RecordModified))
    END;

    [External]
    PROCEDURE CheckOrEnableCRMConnection@23();
    BEGIN
      IF IsCRMIntegrationEnabled THEN
        EXIT;

      IF CRMIntegrationEnabledLastError <> '' THEN
        ERROR(CRMIntegrationEnabledLastError);

      IF CRMIntegrationEnabledState = CRMIntegrationEnabledState::"Enabled But Not For Current User" THEN
        MESSAGE(NotEnabledForCurrentUserMsg,USERID,PRODUCTNAME.SHORT,CRMProductName.SHORT)
      ELSE
        IF CONFIRM(CRMConnSetupWizardQst,TRUE,CRMProductName.SHORT) THEN
          PAGE.RUN(PAGE::"CRM Connection Setup Wizard");

      ERROR('');
    END;

    LOCAL PROCEDURE GetRecordRef@68(RecVariant@1000 : Variant;VAR RecordRef@1001 : RecordRef) : Integer;
    BEGIN
      CASE TRUE OF
        RecVariant.ISRECORD:
          RecordRef.GETTABLE(RecVariant);
        RecVariant.ISRECORDID:
          IF RecordRef.GET(RecVariant) THEN
            RecordRef.SETRECFILTER;
        RecVariant.ISRECORDREF:
          RecordRef := RecVariant;
        ELSE
          EXIT(0);
      END;
      IF RecordRef.FINDSET THEN
        EXIT(RecordRef.COUNT);
      EXIT(0);
    END;

    [External]
    PROCEDURE CreateNewRecordInCRM@25(RecordID@1000 : RecordID;ConfirmBeforeDeletingExistingCoupling@1003 : Boolean);
    BEGIN
      // Extinct method. Kept for backward compatibility.
      ConfirmBeforeDeletingExistingCoupling := FALSE;
      CreateNewRecordsInCRM(RecordID);
    END;

    [External]
    PROCEDURE CreateNewRecordsInCRM@22(RecVariant@1004 : Variant);
    VAR
      IntegrationTableMapping@1002 : Record 5335;
      RecRef@1000 : RecordRef;
      CRMID@1001 : GUID;
      RecordCounter@1005 : ARRAY [4] OF Integer;
    BEGIN
      RecordCounter[NoOf::Total] := GetRecordRef(RecVariant,RecRef);
      IF RecordCounter[NoOf::Total] = 0 THEN
        EXIT;
      GetIntegrationTableMapping(IntegrationTableMapping,RecRef.NUMBER);

      REPEAT
        IF GetCoupledCRMID(RecRef.RECORDID,CRMID) THEN
          RecordCounter[NoOf::Skipped] += 1
        ELSE
          IF EnqueueSyncJob(IntegrationTableMapping,RecRef.RECORDID,CRMID,IntegrationTableMapping.Direction::ToIntegrationTable) THEN
            RecordCounter[NoOf::Scheduled] += 1
          ELSE
            RecordCounter[NoOf::Failed] += 1;
      UNTIL RecRef.NEXT = 0;

      SendSyncNotification(RecordCounter);
    END;

    [Internal]
    PROCEDURE CreateNewRecordsFromCRM@15(RecVariant@1001 : Variant);
    VAR
      IntegrationTableMapping@1002 : Record 5335;
      CRMIntegrationRecord@1005 : Record 5331;
      RecRef@1000 : RecordRef;
      RecordID@1006 : RecordID;
      CRMID@1003 : GUID;
      RecordCounter@1009 : ARRAY [4] OF Integer;
    BEGIN
      RecordCounter[NoOf::Total] := GetRecordRef(RecVariant,RecRef);
      IF RecordCounter[NoOf::Total] = 0 THEN
        EXIT;
      GetIntegrationTableMapping(IntegrationTableMapping,RecRef.NUMBER);

      REPEAT
        CRMID := RecRef.FIELD(IntegrationTableMapping."Integration Table UID Fld. No.").VALUE;
        IF CRMIntegrationRecord.FindRecordIDFromID(CRMID,IntegrationTableMapping."Table ID",RecordID) THEN
          RecordCounter[NoOf::Skipped] += 1
        ELSE
          IF EnqueueSyncJob(IntegrationTableMapping,RecRef.RECORDID,CRMID,IntegrationTableMapping.Direction::FromIntegrationTable) THEN
            RecordCounter[NoOf::Scheduled] += 1
          ELSE
            RecordCounter[NoOf::Failed] += 1;
      UNTIL RecRef.NEXT = 0;

      SendSyncNotification(RecordCounter);
    END;

    LOCAL PROCEDURE PerformInitialSynchronization@16(RecordID@1000 : RecordID;CRMID@1002 : GUID;Direction@1001 : Option);
    VAR
      IntegrationTableMapping@1005 : Record 5335;
      RecordCounter@1003 : ARRAY [4] OF Integer;
    BEGIN
      RecordCounter[NoOf::Total] := 1;
      GetIntegrationTableMapping(IntegrationTableMapping,RecordID.TABLENO);
      IF EnqueueSyncJob(IntegrationTableMapping,RecordID,CRMID,Direction) THEN
        RecordCounter[NoOf::Scheduled] += 1
      ELSE
        RecordCounter[NoOf::Failed] += 1;

      SendSyncNotification(RecordCounter);
    END;

    LOCAL PROCEDURE GetIntegrationTableMapping@9(VAR IntegrationTableMapping@1001 : Record 5335;TableID@1000 : Integer);
    VAR
      TableMetadata@1002 : Record 2000000136;
    BEGIN
      IntegrationTableMapping.SETRANGE("Synch. Codeunit ID",CODEUNIT::"CRM Integration Table Synch.");
      IntegrationTableMapping.SETRANGE("Delete After Synchronization",FALSE);
      IF IsCRMTable(TableID) THEN
        IntegrationTableMapping.SETRANGE("Integration Table ID",TableID)
      ELSE
        IntegrationTableMapping.SETRANGE("Table ID",TableID);
      IF NOT IntegrationTableMapping.FINDFIRST THEN BEGIN
        TableMetadata.GET(TableID);
        ERROR(IntegrationTableMappingNotFoundErr,IntegrationTableMapping.TABLECAPTION,TableMetadata.Caption);
      END;
    END;

    [External]
    PROCEDURE IsCRMTable@51(TableID@1000 : Integer) : Boolean;
    VAR
      TableMetadata@1001 : Record 2000000136;
    BEGIN
      IF TableMetadata.GET(TableID) THEN
        EXIT(TableMetadata.TableType = TableMetadata.TableType::CRM);
    END;

    LOCAL PROCEDURE IsRecordSkipped@61(RecID@1001 : RecordID) : Boolean;
    VAR
      CRMIntegrationRecord@1000 : Record 5331;
    BEGIN
      IF CRMIntegrationRecord.FindByRecordID(RecID) THEN
        EXIT(CRMIntegrationRecord.Skipped);
    END;

    PROCEDURE EnqueueFullSyncJob@78(Name@1001 : Code[20]) : GUID;
    VAR
      IntegrationTableMapping@1000 : Record 5335;
      JobQueueEntry@1002 : Record 472;
      CRMSetupDefaults@1008 : Codeunit 5334;
    BEGIN
      IntegrationTableMapping.GET(Name);
      IntegrationTableMapping."Full Sync is Running" := TRUE;
      IntegrationTableMapping.CALCFIELDS("Table Filter","Integration Table Filter");
      AddIntegrationTableMapping(IntegrationTableMapping);
      COMMIT;
      IF CRMSetupDefaults.CreateJobQueueEntry(IntegrationTableMapping) THEN BEGIN
        JobQueueEntry.SETRANGE("Record ID to Process",IntegrationTableMapping.RECORDID);
        IF JobQueueEntry.FINDFIRST THEN
          EXIT(JobQueueEntry.ID);
      END;
    END;

    LOCAL PROCEDURE EnqueueSyncJob@56(IntegrationTableMapping@1006 : Record 5335;RecordID@1005 : RecordID;CRMID@1004 : GUID;Direction@1003 : Integer) : Boolean;
    VAR
      CRMSetupDefaults@1008 : Codeunit 5334;
    BEGIN
      IntegrationTableMapping.Direction := Direction;
      IF Direction = IntegrationTableMapping.Direction::FromIntegrationTable THEN
        IntegrationTableMapping.SetIntegrationTableFilter(GetTableViewForGuid(IntegrationTableMapping."Integration Table ID",CRMID))
      ELSE
        IntegrationTableMapping.SetTableFilter(GetTableViewForRecordID(RecordID));
      AddIntegrationTableMapping(IntegrationTableMapping);
      COMMIT;
      EXIT(CRMSetupDefaults.CreateJobQueueEntry(IntegrationTableMapping));
    END;

    LOCAL PROCEDURE AddIntegrationTableMapping@70(VAR IntegrationTableMapping@1005 : Record 5335);
    VAR
      SourceMappingName@1004 : Code[20];
    BEGIN
      SourceMappingName := IntegrationTableMapping.Name;
      IntegrationTableMapping.Name := COPYSTR(DELCHR(FORMAT(CREATEGUID),'=','{}-'),1,MAXSTRLEN(IntegrationTableMapping.Name));
      IntegrationTableMapping."Synch. Only Coupled Records" := FALSE;
      IntegrationTableMapping."Delete After Synchronization" := TRUE;
      IntegrationTableMapping."Parent Name" := SourceMappingName;
      CLEAR(IntegrationTableMapping."Synch. Modified On Filter");
      CLEAR(IntegrationTableMapping."Synch. Int. Tbl. Mod. On Fltr.");
      CLEAR(IntegrationTableMapping."Last Full Sync Start DateTime");
      IntegrationTableMapping.INSERT;

      CloneIntegrationFieldMapping(SourceMappingName,IntegrationTableMapping.Name);
    END;

    LOCAL PROCEDURE CloneIntegrationFieldMapping@62(SourceMappingName@1000 : Code[20];DestinationMappingName@1002 : Code[20]);
    VAR
      IntegrationFieldMapping@1001 : Record 5336;
      NewIntegrationFieldMapping@1003 : Record 5336;
    BEGIN
      IntegrationFieldMapping.SETRANGE("Integration Table Mapping Name",SourceMappingName);
      IF IntegrationFieldMapping.FINDSET THEN
        REPEAT
          NewIntegrationFieldMapping := IntegrationFieldMapping;
          NewIntegrationFieldMapping."No." := 0; // Autoincrement
          NewIntegrationFieldMapping."Integration Table Mapping Name" := DestinationMappingName;
          NewIntegrationFieldMapping.INSERT;
        UNTIL IntegrationFieldMapping.NEXT = 0;
    END;

    LOCAL PROCEDURE GetTableViewForGuid@57(TableNo@1004 : Integer;CRMId@1000 : GUID) View : Text;
    VAR
      FieldRef@1003 : FieldRef;
      KeyRef@1002 : KeyRef;
      RecordRef@1001 : RecordRef;
    BEGIN
      RecordRef.OPEN(TableNo);
      KeyRef := RecordRef.KEYINDEX(1); // Primary Key
      FieldRef := KeyRef.FIELDINDEX(1);
      FieldRef.SETRANGE(CRMId);
      View := RecordRef.GETVIEW;
      RecordRef.CLOSE;
    END;

    LOCAL PROCEDURE GetTableViewForRecordID@60(RecordID@1000 : RecordID) View : Text;
    VAR
      FieldRef@1003 : FieldRef;
      KeyRef@1002 : KeyRef;
      RecordRef@1001 : RecordRef;
      I@1005 : Integer;
    BEGIN
      RecordRef := RecordID.GETRECORD;
      KeyRef := RecordRef.KEYINDEX(1); // Primary Key
      FOR I := 1 TO KeyRef.FIELDCOUNT DO BEGIN
        FieldRef := KeyRef.FIELDINDEX(I);
        FieldRef.SETRANGE(FieldRef.VALUE);
      END;
      View := RecordRef.GETVIEW;
      RecordRef.CLOSE;
    END;

    [External]
    PROCEDURE CreateOrUpdateCRMAccountStatistics@20(Customer@1000 : Record 18);
    VAR
      CRMAccount@1004 : Record 5341;
      CRMStatisticsJob@1005 : Codeunit 5350;
      CRMID@1001 : GUID;
    BEGIN
      IF NOT GetCoupledCRMID(Customer.RECORDID,CRMID) THEN
        EXIT;

      CRMAccount.GET(CRMID);
      CRMStatisticsJob.CreateOrUpdateCRMAccountStatistics(Customer,CRMAccount);
      CRMStatisticsJob.UpdateStatusOfPaidInvoices(Customer."No.");
      MESSAGE(STRSUBSTNO(AccountStatisticsUpdatedMsg,CRMProductName.SHORT));
    END;

    [External]
    PROCEDURE ShowCRMEntityFromRecordID@8(RecordID@1000 : RecordID);
    VAR
      CRMID@1001 : GUID;
    BEGIN
      IF NOT DefineCouplingIfNotCoupled(RecordID,CRMID) THEN
        EXIT;

      HYPERLINK(GetCRMEntityUrlFromRecordID(RecordID));
    END;

    [External]
    PROCEDURE GetCRMEntityUrlFromRecordID@4(TargetRecordID@1000 : RecordID) : Text;
    VAR
      CRMIntegrationRecord@1001 : Record 5331;
      IntegrationRecord@1005 : Record 5151;
      CRMId@1004 : GUID;
    BEGIN
      IF NOT CRMIntegrationRecord.FindIDFromRecordID(TargetRecordID,CRMId) THEN
        ERROR(CouplingNotFoundErr,CRMProductName.FULL);

      IntegrationRecord.FindByRecordId(TargetRecordID);
      EXIT(GetCRMEntityUrlFromCRMID(IntegrationRecord."Table ID",CRMId));
    END;

    [External]
    PROCEDURE GetCRMEntityUrlFromCRMID@6(TableId@1001 : Integer;CRMId@1006 : GUID) : Text;
    VAR
      CRMConnectionSetup@1003 : Record 5330;
    BEGIN
      CRMConnectionSetup.GET;
      EXIT(STRSUBSTNO(CRMEntityUrlTemplateTxt,CRMConnectionSetup."Server Address",GetCRMEntityTypeName(TableId),CRMId));
    END;

    [External]
    PROCEDURE OpenCoupledNavRecordPage@35(CRMID@1000 : GUID;CRMEntityTypeName@1012 : Text) : Boolean;
    VAR
      CRMIntegrationRecord@1001 : Record 5331;
      TempNameValueBuffer@1013 : TEMPORARY Record 823;
      CRMSetupDefaults@1014 : Codeunit 5334;
      RecordID@1008 : RecordID;
      TableId@1002 : Integer;
    BEGIN
      // Find the corresponding NAV record and type
      CRMSetupDefaults.GetTableIDCRMEntityNameMapping(TempNameValueBuffer);
      TempNameValueBuffer.SETRANGE(Name,LOWERCASE(CRMEntityTypeName));
      IF NOT TempNameValueBuffer.FINDSET THEN
        EXIT(FALSE);

      REPEAT
        EVALUATE(TableId,TempNameValueBuffer.Value);
        IF CRMIntegrationRecord.FindRecordIDFromID(CRMID,TableId,RecordID) THEN
          BREAK;
      UNTIL TempNameValueBuffer.NEXT = 0;

      IF RecordID.TABLENO = 0 THEN
        EXIT(FALSE);

      OpenRecordCardPage(RecordID);
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE OpenRecordCardPage@36(RecordID@1008 : RecordID);
    VAR
      Customer@1007 : Record 18;
      Contact@1006 : Record 5050;
      Currency@1005 : Record 4;
      SalespersonPurchaser@1004 : Record 13;
      UnitOfMeasure@1003 : Record 204;
      Item@1002 : Record 27;
      Resource@1001 : Record 156;
      SalesInvoiceHeader@1015 : Record 112;
      CustomerPriceGroup@1009 : Record 6;
      RecordRef@1000 : RecordRef;
    BEGIN
      // Open the right kind of card page
      RecordRef := RecordID.GETRECORD;
      CASE RecordID.TABLENO OF
        DATABASE::Contact:
          BEGIN
            RecordRef.SETTABLE(Contact);
            PAGE.RUN(PAGE::"Contact Card",Contact);
          END;
        DATABASE::Currency:
          BEGIN
            RecordRef.SETTABLE(Currency);
            PAGE.RUN(PAGE::"Currency Card",Currency);
          END;
        DATABASE::Customer:
          BEGIN
            RecordRef.SETTABLE(Customer);
            PAGE.RUN(PAGE::"Customer Card",Customer);
          END;
        DATABASE::Item:
          BEGIN
            RecordRef.SETTABLE(Item);
            PAGE.RUN(PAGE::"Item Card",Item);
          END;
        DATABASE::"Sales Invoice Header":
          BEGIN
            RecordRef.SETTABLE(SalesInvoiceHeader);
            PAGE.RUN(PAGE::"Posted Sales Invoice",SalesInvoiceHeader);
          END;
        DATABASE::Resource:
          BEGIN
            RecordRef.SETTABLE(Resource);
            PAGE.RUN(PAGE::"Resource Card",Resource);
          END;
        DATABASE::"Salesperson/Purchaser":
          BEGIN
            RecordRef.SETTABLE(SalespersonPurchaser);
            PAGE.RUN(PAGE::"Salesperson/Purchaser Card",SalespersonPurchaser);
          END;
        DATABASE::"Unit of Measure":
          BEGIN
            RecordRef.SETTABLE(UnitOfMeasure);
            // There is no Unit of Measure card. Open the list, filtered down to this instance.
            PAGE.RUN(PAGE::"Units of Measure",UnitOfMeasure);
          END;
        DATABASE::"Customer Price Group":
          BEGIN
            RecordRef.SETTABLE(CustomerPriceGroup);
            // There is no Customer Price Group card. Open the list, filtered down to this instance.
            PAGE.RUN(PAGE::"Customer Price Groups",CustomerPriceGroup);
          END;
        ELSE
          ERROR(NoCardPageActionDefinedForTableIdErr,RecordID.TABLENO);
      END;
    END;

    [External]
    PROCEDURE GetCRMEntityTypeName@7(TableId@1000 : Integer) : Text;
    VAR
      TempNameValueBuffer@1001 : TEMPORARY Record 823;
      CRMSetupDefaults@1002 : Codeunit 5334;
    BEGIN
      CRMSetupDefaults.GetTableIDCRMEntityNameMapping(TempNameValueBuffer);
      TempNameValueBuffer.SETRANGE(Value,FORMAT(TableId));
      IF TempNameValueBuffer.FINDFIRST THEN
        EXIT(TempNameValueBuffer.Name);
      ERROR(UnableToResolveCRMEntityNameFrmTableIDErr,TableId,CRMProductName.SHORT);
    END;

    LOCAL PROCEDURE GetCoupledCRMID@18(RecordID@1000 : RecordID;VAR CRMID@1001 : GUID) : Boolean;
    VAR
      CRMIntegrationRecord@1002 : Record 5331;
    BEGIN
      EXIT(CRMIntegrationRecord.FindIDFromRecordID(RecordID,CRMID))
    END;

    LOCAL PROCEDURE DefineCouplingIfNotCoupled@30(RecordID@1000 : RecordID;VAR CRMID@1001 : GUID) : Boolean;
    VAR
      RecordRef@1004 : RecordRef;
    BEGIN
      IF GetCoupledCRMID(RecordID,CRMID) THEN
        EXIT(TRUE);

      RecordRef.OPEN(RecordID.TABLENO);
      IF CONFIRM(STRSUBSTNO(ManageCouplingQst,RecordRef.CAPTION,CRMProductName.FULL),FALSE) THEN
        IF DefineCoupling(RecordID) THEN
          EXIT(GetCoupledCRMID(RecordID,CRMID));
      EXIT(FALSE);
    END;

    [External]
    PROCEDURE DefineCoupling@101(RecordID@1000 : RecordID) : Boolean;
    VAR
      CRMCouplingManagement@1005 : Codeunit 5331;
      CreateNew@1001 : Boolean;
      Synchronize@1002 : Boolean;
      Direction@1003 : Option;
      CRMID@1004 : GUID;
    BEGIN
      IF CRMCouplingManagement.DefineCoupling(RecordID,CRMID,CreateNew,Synchronize,Direction) THEN BEGIN
        IF CreateNew THEN
          CreateNewRecordsInCRM(RecordID)
        ELSE
          IF Synchronize THEN
            PerformInitialSynchronization(RecordID,CRMID,Direction);
        EXIT(TRUE);
      END;

      EXIT(FALSE);
    END;

    [External]
    PROCEDURE ManageCreateNewRecordFromCRM@2(TableID@1000 : Integer);
    BEGIN
      // Extinct method. Kept for backward compatibility.
      CASE TableID OF
        DATABASE::Contact:
          CreateNewContactFromCRM;
        DATABASE::Customer:
          CreateNewCustomerFromCRM;
      END;
    END;

    [External]
    PROCEDURE CreateNewContactFromCRM@69();
    VAR
      IntegrationTableMapping@1001 : Record 5335;
    BEGIN
      GetIntegrationTableMapping(IntegrationTableMapping,DATABASE::Contact);
      PAGE.RUNMODAL(PAGE::"CRM Contact List");
    END;

    [External]
    PROCEDURE CreateNewCustomerFromCRM@67();
    VAR
      IntegrationTableMapping@1001 : Record 5335;
    BEGIN
      GetIntegrationTableMapping(IntegrationTableMapping,DATABASE::Customer);
      PAGE.RUNMODAL(PAGE::"CRM Account List");
    END;

    [Internal]
    PROCEDURE ShowCustomerCRMOpportunities@28(Customer@1002 : Record 18);
    VAR
      CRMOpportunity@1000 : Record 5343;
      CRMID@1001 : GUID;
    BEGIN
      IF NOT IsCRMIntegrationEnabled THEN
        EXIT;

      IF NOT DefineCouplingIfNotCoupled(Customer.RECORDID,CRMID) THEN
        EXIT;

      CRMOpportunity.FILTERGROUP := 2;
      CRMOpportunity.SETRANGE(ParentAccountId,CRMID);
      CRMOpportunity.SETRANGE(StateCode,CRMOpportunity.StateCode::Open);
      CRMOpportunity.FILTERGROUP := 0;
      PAGE.RUN(PAGE::"CRM Opportunity List",CRMOpportunity);
    END;

    [Internal]
    PROCEDURE ShowCustomerCRMQuotes@3(Customer@1002 : Record 18);
    VAR
      CRMQuote@1000 : Record 5351;
      CRMID@1001 : GUID;
    BEGIN
      IF NOT IsCRMIntegrationEnabled THEN
        EXIT;

      IF NOT DefineCouplingIfNotCoupled(Customer.RECORDID,CRMID) THEN
        EXIT;

      CRMQuote.FILTERGROUP := 2;
      CRMQuote.SETRANGE(CustomerId,CRMID);
      CRMQuote.SETRANGE(StateCode,CRMQuote.StateCode::Active);
      CRMQuote.FILTERGROUP := 0;
      PAGE.RUN(PAGE::"CRM Quote List",CRMQuote);
    END;

    [Internal]
    PROCEDURE ShowCustomerCRMCases@10(Customer@1002 : Record 18);
    VAR
      CRMIncident@1000 : Record 5349;
      CRMID@1001 : GUID;
    BEGIN
      IF NOT IsCRMIntegrationEnabled THEN
        EXIT;

      IF NOT DefineCouplingIfNotCoupled(Customer.RECORDID,CRMID) THEN
        EXIT;

      CRMIncident.FILTERGROUP := 2;
      CRMIncident.SETRANGE(CustomerId,CRMID);
      CRMIncident.SETRANGE(StateCode,CRMIncident.StateCode::Active);
      CRMIncident.FILTERGROUP := 2;
      PAGE.RUN(PAGE::"CRM Case List",CRMIncident);
    END;

    [External]
    PROCEDURE GetNoOfCRMOpportunities@13(Customer@1003 : Record 18) : Integer;
    VAR
      CRMOpportunity@1002 : Record 5343;
      CRMID@1001 : GUID;
    BEGIN
      IF NOT IsCRMIntegrationEnabled THEN
        EXIT(0);

      IF NOT GetCoupledCRMID(Customer.RECORDID,CRMID) THEN
        EXIT(0);

      CRMOpportunity.SETRANGE(ParentAccountId,CRMID);
      CRMOpportunity.SETRANGE(StateCode,CRMOpportunity.StateCode::Open);
      EXIT(CRMOpportunity.COUNT);
    END;

    [External]
    PROCEDURE GetNoOfCRMQuotes@12(Customer@1003 : Record 18) : Integer;
    VAR
      CRMQuote@1002 : Record 5351;
      CRMID@1001 : GUID;
    BEGIN
      IF NOT IsCRMIntegrationEnabled THEN
        EXIT(0);

      IF NOT GetCoupledCRMID(Customer.RECORDID,CRMID) THEN
        EXIT(0);

      CRMQuote.SETRANGE(CustomerId,CRMID);
      CRMQuote.SETRANGE(StateCode,CRMQuote.StateCode::Active);
      EXIT(CRMQuote.COUNT);
    END;

    [External]
    PROCEDURE GetNoOfCRMCases@31(Customer@1003 : Record 18) : Integer;
    VAR
      CRMIncident@1002 : Record 5349;
      CRMID@1000 : GUID;
    BEGIN
      IF NOT IsCRMIntegrationEnabled THEN
        EXIT(0);

      IF NOT GetCoupledCRMID(Customer.RECORDID,CRMID) THEN
        EXIT(0);

      CRMIncident.SETRANGE(StateCode,CRMIncident.StateCode::Active);
      CRMIncident.SETRANGE(CustomerId,CRMID);
      EXIT(CRMIncident.COUNT);
    END;

    LOCAL PROCEDURE GetSelectedMultipleSyncDirection@24(IntegrationTableMapping@1003 : Record 5335) : Integer;
    VAR
      SynchronizeNowQuestion@1004 : Text;
      AllowedDirection@1001 : Integer;
      RecommendedDirection@1000 : Integer;
    BEGIN
      AllowedDirection := IntegrationTableMapping.Direction;
      RecommendedDirection := AllowedDirection;
      CASE AllowedDirection OF
        IntegrationTableMapping.Direction::Bidirectional:
          EXIT(
            STRMENU(STRSUBSTNO(UpdateNowDirectionQst,CRMProductName.SHORT),RecommendedDirection,UpdateMultipleNowTitleTxt));
        IntegrationTableMapping.Direction::FromIntegrationTable:
          SynchronizeNowQuestion := STRSUBSTNO(UpdateMultipleNowFromCRMQst,CRMProductName.SHORT);
        ELSE
          SynchronizeNowQuestion := STRSUBSTNO(UpdateMultipleNowToCRMQst,CRMProductName.SHORT);
      END;

      IF CONFIRM(SynchronizeNowQuestion,TRUE) THEN
        EXIT(AllowedDirection);
      EXIT(0); // user canceled the process
    END;

    LOCAL PROCEDURE GetSelectedSingleSyncDirection@77(IntegrationTableMapping@1003 : Record 5335;RecordRef@1005 : RecordRef;CRMID@1012 : GUID;VAR RecommendedDirectionIgnored@1006 : Boolean) : Integer;
    VAR
      IntegrationRecSynchInvoke@1007 : Codeunit 5345;
      CRMRecordRef@1010 : RecordRef;
      RecordIDDescr@1000 : Text;
      SynchronizeNowQuestion@1004 : Text;
      AllowedDirection@1001 : Integer;
      RecommendedDirection@1002 : Integer;
      SelectedDirection@1008 : Integer;
      RecordModified@1013 : Boolean;
      CRMRecordModified@1014 : Boolean;
      DefaultAnswer@1015 : Boolean;
    BEGIN
      AllowedDirection := IntegrationTableMapping.Direction;

      // Determine which sides were modified since last synch
      IntegrationTableMapping.GetRecordRef(CRMID,CRMRecordRef);
      RecordModified := IntegrationRecSynchInvoke.WasModifiedAfterLastSynch(IntegrationTableMapping,RecordRef);
      CRMRecordModified := IntegrationRecSynchInvoke.WasModifiedAfterLastSynch(IntegrationTableMapping,CRMRecordRef);
      RecordIDDescr := FORMAT(RecordRef.RECORDID,0,1);
      IF RecordModified AND CRMRecordModified THEN
        // Changes on both sides. Bidirectional: warn user. Unidirectional: confirm and exit.
        CASE AllowedDirection OF
          IntegrationTableMapping.Direction::Bidirectional:
            MESSAGE(BothRecordsModifiedBiDirectionalMsg,RecordRef.CAPTION,CRMRecordRef.CAPTION,CRMProductName.SHORT);
          IntegrationTableMapping.Direction::ToIntegrationTable:
            BEGIN
              IF CONFIRM(
                   BothRecordsModifiedToCRMQst,FALSE,RecordIDDescr,CRMRecordRef.CAPTION,PRODUCTNAME.FULL,CRMProductName.SHORT)
              THEN
                EXIT(AllowedDirection);
              EXIT(0);
            END;
          IntegrationTableMapping.Direction::FromIntegrationTable:
            BEGIN
              IF CONFIRM(BothRecordsModifiedToNAVQst,FALSE,RecordIDDescr,CRMRecordRef.CAPTION,PRODUCTNAME.SHORT) THEN
                EXIT(AllowedDirection);
              EXIT(0);
            END;
        END;

      // Zero or one side changed. Synch for zero too because dependent objects could have changed.
      CASE AllowedDirection OF
        IntegrationTableMapping.Direction::Bidirectional:
          BEGIN
            // Default from NAV to CRM
            RecommendedDirection := IntegrationTableMapping.Direction::ToIntegrationTable;
            IF CRMRecordModified AND NOT RecordModified THEN
              RecommendedDirection := IntegrationTableMapping.Direction::FromIntegrationTable;
            SelectedDirection :=
              STRMENU(
                STRSUBSTNO(UpdateNowDirectionQst,CRMProductName.SHORT),RecommendedDirection,
                STRSUBSTNO(UpdateOneNowTitleTxt,RecordIDDescr));
            RecommendedDirectionIgnored := SelectedDirection <> RecommendedDirection;
            EXIT(SelectedDirection);
          END;
        IntegrationTableMapping.Direction::FromIntegrationTable:
          IF RecordModified THEN
            SynchronizeNowQuestion := STRSUBSTNO(UpdateOneNowFromOldCRMQst,RecordIDDescr,PRODUCTNAME.SHORT,CRMProductName.SHORT)
          ELSE BEGIN
            SynchronizeNowQuestion := STRSUBSTNO(UpdateOneNowFromCRMQst,RecordIDDescr,CRMProductName.SHORT);
            DefaultAnswer := TRUE;
          END;
        ELSE
          IF CRMRecordModified THEN
            SynchronizeNowQuestion := STRSUBSTNO(UpdateOneNowToModifiedCRMQst,RecordIDDescr,PRODUCTNAME.SHORT,CRMProductName.SHORT)
          ELSE BEGIN
            SynchronizeNowQuestion := STRSUBSTNO(UpdateOneNowToCRMQst,RecordIDDescr,CRMProductName.SHORT);
            DefaultAnswer := TRUE;
          END;
      END;

      IF CONFIRM(SynchronizeNowQuestion,DefaultAnswer) THEN
        EXIT(AllowedDirection);

      EXIT(0); // user canceled the process
    END;

    [EventSubscriber(Table,1400,OnRegisterServiceConnection)]
    [External]
    PROCEDURE HandleCRMRegisterServiceConnection@32(VAR ServiceConnection@1000 : Record 1400);
    VAR
      CRMConnectionSetup@1001 : Record 5330;
      RecRef@1002 : RecordRef;
    BEGIN
      IF NOT CRMConnectionSetup.GET THEN BEGIN
        IF NOT CRMConnectionSetup.WRITEPERMISSION THEN
          EXIT;
        CRMConnectionSetup.INIT;
        CRMConnectionSetup.INSERT;
      END;

      RecRef.GETTABLE(CRMConnectionSetup);
      ServiceConnection.Status := ServiceConnection.Status::Enabled;
      WITH CRMConnectionSetup DO BEGIN
        IF NOT "Is Enabled" THEN
          ServiceConnection.Status := ServiceConnection.Status::Disabled
        ELSE BEGIN
          IF TestConnection THEN
            ServiceConnection.Status := ServiceConnection.Status::Connected
          ELSE
            ServiceConnection.Status := ServiceConnection.Status::Error;
        END;
        ServiceConnection.InsertServiceConnectionExtended(
          ServiceConnection,RecRef.RECORDID,TABLECAPTION,"Server Address",PAGE::"CRM Connection Setup",
          PAGE::"CRM Connection Setup Wizard");
      END;
    END;

    [External]
    PROCEDURE ClearState@21();
    BEGIN
      CRMIntegrationEnabledState := CRMIntegrationEnabledState::" "
    END;

    [Internal]
    PROCEDURE GetLastErrorMessage@33() : Text;
    VAR
      ErrorObject@1000 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Exception";
    BEGIN
      ErrorObject := GETLASTERROROBJECT;
      IF ISNULL(ErrorObject) THEN
        EXIT('');
      IF STRPOS(ErrorObject.GetType.Name,'NavCrmException') > 0 THEN
        IF NOT ISNULL(ErrorObject.InnerException) THEN
          EXIT(ErrorObject.InnerException.Message);
      EXIT(GETLASTERRORTEXT);
    END;

    [TryFunction]
    [Internal]
    PROCEDURE ImportCRMSolution@34(ServerAddress@1006 : Text;IntegrationUserEmail@1017 : Text;AdminUserEmail@1000 : Text;AdminUserPassword@1001 : Text);
    VAR
      ServicePassword@1007 : Record 1261;
      URI@1004 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Uri";
      HomeRealmURI@1010 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Uri";
      ClientCredentials@1018 : DotNet "'System.ServiceModel, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.ServiceModel.Description.ClientCredentials";
      OrganizationServiceProxy@1002 : DotNet "'Microsoft.Xrm.Sdk, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Xrm.Sdk.Client.OrganizationServiceProxy";
      CRMHelper@1003 : DotNet "'Microsoft.Dynamics.Nav.CrmCustomizationHelper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.CrmCustomizationHelper.CrmHelper";
      UserGUID@1005 : GUID;
      IntegrationAdminRoleGUID@1013 : GUID;
      IntegrationUserRoleGUID@1014 : GUID;
    BEGIN
      CheckConnectRequiredFields(ServerAddress,IntegrationUserEmail);
      URI := URI.Uri(ConstructConnectionStringForSolutionImport(ServerAddress));
      ClientCredentials := ClientCredentials.ClientCredentials;
      ClientCredentials.UserName.UserName := AdminUserEmail;
      ServicePassword.GET(AdminUserPassword);
      ClientCredentials.UserName.Password := ServicePassword.GetPassword;
      IF NOT InitializeCRMConnection(URI,HomeRealmURI,ClientCredentials,CRMHelper,OrganizationServiceProxy) THEN
        ProcessConnectionFailures;

      IF ISNULL(OrganizationServiceProxy.ServiceManagement.GetIdentityProvider(AdminUserEmail)) THEN
        ERROR(STRSUBSTNO(AdminEmailPasswordWrongErr,CRMProductName.SHORT));

      UserGUID := GetUserGUID(OrganizationServiceProxy,IntegrationUserEmail);

      IF NOT CheckSolutionPresence(OrganizationServiceProxy) THEN
        IF NOT ImportDefaultCRMSolution(CRMHelper,OrganizationServiceProxy) THEN
          ProcessConnectionFailures;

      IntegrationAdminRoleGUID := GetRoleGUID(OrganizationServiceProxy,GetIntegrationAdminRoleID);
      IntegrationUserRoleGUID := GetRoleGUID(OrganizationServiceProxy,GetIntegrationUserRoleID);

      IF NOT CheckRoleAssignedToUser(OrganizationServiceProxy,UserGUID,IntegrationAdminRoleGUID) THEN
        AssociateUserWithRole(UserGUID,IntegrationAdminRoleGUID,OrganizationServiceProxy);
      IF NOT CheckRoleAssignedToUser(OrganizationServiceProxy,UserGUID,IntegrationUserRoleGUID) THEN
        AssociateUserWithRole(UserGUID,IntegrationUserRoleGUID,OrganizationServiceProxy);
    END;

    [TryFunction]
    LOCAL PROCEDURE ImportDefaultCRMSolution@45(CRMHelper@1001 : DotNet "'Microsoft.Dynamics.Nav.CrmCustomizationHelper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.CrmCustomizationHelper.CrmHelper";VAR OrganizationServiceProxy@1000 : DotNet "'Microsoft.Xrm.Sdk, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Xrm.Sdk.Client.OrganizationServiceProxy");
    BEGIN
      CRMHelper.ImportDefaultCrmSolution(OrganizationServiceProxy);
    END;

    LOCAL PROCEDURE AssociateUserWithRole@66(UserGUID@1000 : GUID;RoleGUID@1001 : GUID;VAR OrganizationServiceProxy@1014 : DotNet "'Microsoft.Xrm.Sdk, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Xrm.Sdk.Client.OrganizationServiceProxy");
    VAR
      AssociateRequest@1012 : DotNet "'Microsoft.Xrm.Sdk, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Xrm.Sdk.Messages.AssociateRequest";
    BEGIN
      CreateAssociateRequest(UserGUID,RoleGUID,AssociateRequest);
      OrganizationServiceProxy.Execute(AssociateRequest);
    END;

    LOCAL PROCEDURE GetQueryExpression@72(EntityName@1009 : Text;Column@1010 : Text;ConditionField@1011 : Text;ConditionFieldValue@1012 : Text;ErrorMsg@1005 : Text;VAR OrganizationServiceProxy@1006 : DotNet "'Microsoft.Xrm.Sdk, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Xrm.Sdk.Client.OrganizationServiceProxy") : GUID;
    VAR
      QueryExpression@1002 : DotNet "'Microsoft.Xrm.Sdk, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Xrm.Sdk.Query.QueryExpression";
      Entity@1007 : DotNet "'Microsoft.Xrm.Sdk, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Xrm.Sdk.Entity";
      EntityCollection@1013 : DotNet "'Microsoft.Xrm.Sdk, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Xrm.Sdk.EntityCollection";
      LinkEntity@1014 : DotNet "'Microsoft.Xrm.Sdk, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Xrm.Sdk.Query.LinkEntity";
    BEGIN
      CreateQueryExpression(EntityName,Column,ConditionField,ConditionFieldValue,LinkEntity,QueryExpression);
      IF NOT ProcessQueryExpression(OrganizationServiceProxy,EntityCollection,QueryExpression) THEN BEGIN
        OrganizationServiceProxy.Dispose;
        ProcessConnectionFailures;
      END;
      IF EntityCollection.Entities.Count = 0 THEN
        ERROR(STRSUBSTNO(ErrorMsg,ConditionFieldValue));
      Entity := EntityCollection.Item(0);
      EXIT(Entity.Id);
    END;

    LOCAL PROCEDURE GetUserGUID@41(VAR OrganizationServiceProxy@1001 : DotNet "'Microsoft.Xrm.Sdk, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Xrm.Sdk.Client.OrganizationServiceProxy";UserEmail@1000 : Text) : GUID;
    BEGIN
      EXIT(
        GetQueryExpression(
          'systemuser','systemuserid','internalemailaddress',UserEmail,
          STRSUBSTNO(UserDoesNotExistCRMTxt,UserEmail,CRMProductName.SHORT),OrganizationServiceProxy));
    END;

    LOCAL PROCEDURE GetRoleGUID@43(VAR OrganizationServiceProxy@1001 : DotNet "'Microsoft.Xrm.Sdk, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Xrm.Sdk.Client.OrganizationServiceProxy";RoleName@1000 : Text) : GUID;
    BEGIN
      EXIT(
        GetQueryExpression(
          'role','roleid','roleid',RoleName,STRSUBSTNO(RoleIdDoesNotExistCRMTxt,CRMProductName.SHORT),OrganizationServiceProxy));
    END;

    [External]
    PROCEDURE CheckConnectRequiredFields@46(ServerAddress@1000 : Text;IntegrationUserEmail@1001 : Text);
    BEGIN
      IF (IntegrationUserEmail = '') OR (ServerAddress = '') THEN
        ERROR(EmailAndServerAddressEmptyErr);
    END;

    [External]
    PROCEDURE CreateAssociateRequest@44(UserGUID@1001 : GUID;RoleGUID@1000 : GUID;VAR AssociateRequest@1002 : DotNet "'Microsoft.Xrm.Sdk, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Xrm.Sdk.Messages.AssociateRequest");
    VAR
      EntityReferenceCollection@1005 : DotNet "'Microsoft.Xrm.Sdk, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Xrm.Sdk.EntityReferenceCollection";
      RelationShip@1004 : DotNet "'Microsoft.Xrm.Sdk, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Xrm.Sdk.Relationship";
      EntityReference@1003 : DotNet "'Microsoft.Xrm.Sdk, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Xrm.Sdk.EntityReference";
    BEGIN
      EntityReferenceCollection := EntityReferenceCollection.EntityReferenceCollection;
      EntityReferenceCollection.Add(EntityReference.EntityReference('role',RoleGUID));
      RelationShip := RelationShip.Relationship('systemuserroles_association');
      AssociateRequest := AssociateRequest.AssociateRequest;
      AssociateRequest.Target(EntityReference.EntityReference('systemuser',UserGUID));
      AssociateRequest.RelatedEntities(EntityReferenceCollection);
      AssociateRequest.Relationship(RelationShip);
    END;

    [External]
    PROCEDURE CreateFilterExpression@64(AttributeName@1003 : Text;Value@1002 : Text;VAR FilterExpression@1000 : DotNet "'Microsoft.Xrm.Sdk, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Xrm.Sdk.Query.FilterExpression");
    VAR
      ConditionExpression@1001 : DotNet "'Microsoft.Xrm.Sdk, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Xrm.Sdk.Query.ConditionExpression";
      ConditionOperator@1004 : DotNet "'Microsoft.Xrm.Sdk, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Xrm.Sdk.Query.ConditionOperator";
    BEGIN
      ConditionExpression :=
        ConditionExpression.ConditionExpression(AttributeName,ConditionOperator.Equal,Value);
      FilterExpression := FilterExpression.FilterExpression;
      FilterExpression.AddCondition(ConditionExpression);
    END;

    [External]
    PROCEDURE CreateLinkEntity@55(VAR LinkEntity@1001 : DotNet "'Microsoft.Xrm.Sdk, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Xrm.Sdk.Query.LinkEntity";LinkFromEntityName@1000 : Text;LinkFromAttributeName@1002 : Text;LinkToEntityName@1003 : Text;LinkToAttributeName@1004 : Text);
    VAR
      JoinOperator@1005 : DotNet "'Microsoft.Xrm.Sdk, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Xrm.Sdk.Query.JoinOperator";
    BEGIN
      LinkEntity :=
        LinkEntity.LinkEntity(
          LinkFromEntityName,LinkToEntityName,LinkFromAttributeName,LinkToAttributeName,
          JoinOperator.Inner);
    END;

    [Internal]
    PROCEDURE CreateRoleToUserIDQueryExpression@40(UserIDGUID@1003 : GUID;RoleIDGUID@1004 : GUID;VAR QueryExpression@1000 : DotNet "'Microsoft.Xrm.Sdk, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Xrm.Sdk.Query.QueryExpression");
    VAR
      LinkEntity1@1002 : DotNet "'Microsoft.Xrm.Sdk, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Xrm.Sdk.Query.LinkEntity";
      LinkEntity2@1001 : DotNet "'Microsoft.Xrm.Sdk, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Xrm.Sdk.Query.LinkEntity";
      FilterExpression@1005 : DotNet "'Microsoft.Xrm.Sdk, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Xrm.Sdk.Query.FilterExpression";
    BEGIN
      CreateLinkEntity(LinkEntity1,'systemuserroles','systemuserid','systemuser','systemuserid');

      CreateFilterExpression('systemuserid',UserIDGUID,FilterExpression);
      LinkEntity1.LinkCriteria(FilterExpression);

      CreateLinkEntity(LinkEntity2,'role','roleid','systemuserroles','roleid');
      LinkEntity2.LinkEntities.Add(LinkEntity1);

      CreateQueryExpression('role','roleid','roleid',RoleIDGUID,LinkEntity2,QueryExpression);
    END;

    [Internal]
    PROCEDURE CreateAnyRoleToUserIDQueryExpression@54(UserIDGUID@1003 : GUID;VAR QueryExpression@1000 : DotNet "'Microsoft.Xrm.Sdk, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Xrm.Sdk.Query.QueryExpression");
    VAR
      LinkEntity1@1002 : DotNet "'Microsoft.Xrm.Sdk, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Xrm.Sdk.Query.LinkEntity";
      FilterExpression@1005 : DotNet "'Microsoft.Xrm.Sdk, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Xrm.Sdk.Query.FilterExpression";
      ColumnSet@1007 : DotNet "'Microsoft.Xrm.Sdk, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Xrm.Sdk.Query.ColumnSet";
    BEGIN
      CreateLinkEntity(LinkEntity1,'role','roleid','systemuserroles','roleid');

      CreateFilterExpression('systemuserid',UserIDGUID,FilterExpression);
      LinkEntity1.LinkCriteria(FilterExpression);

      QueryExpression := QueryExpression.QueryExpression('role');
      QueryExpression.ColumnSet(ColumnSet.ColumnSet);
      QueryExpression.LinkEntities.Add(LinkEntity1);
    END;

    LOCAL PROCEDURE CheckSolutionPresence@42(VAR OrganizationServiceProxy@1000 : DotNet "'Microsoft.Xrm.Sdk, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Xrm.Sdk.Client.OrganizationServiceProxy") : Boolean;
    VAR
      ColumnSet@1001 : DotNet "'Microsoft.Xrm.Sdk, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Xrm.Sdk.Query.ColumnSet";
      QueryExpression@1002 : DotNet "'Microsoft.Xrm.Sdk, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Xrm.Sdk.Query.QueryExpression";
      ConditionExpression@1004 : DotNet "'Microsoft.Xrm.Sdk, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Xrm.Sdk.Query.ConditionExpression";
      ConditionOperator@1003 : DotNet "'Microsoft.Xrm.Sdk, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Xrm.Sdk.Query.ConditionOperator";
      EntityCollection@1005 : DotNet "'Microsoft.Xrm.Sdk, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Xrm.Sdk.EntityCollection";
    BEGIN
      QueryExpression := QueryExpression.QueryExpression('solution');
      ColumnSet := ColumnSet.ColumnSet;
      QueryExpression.ColumnSet(ColumnSet);
      ConditionExpression :=
        ConditionExpression.ConditionExpression('uniquename',ConditionOperator.Equal,MicrosoftDynamicsNavIntegrationTxt);
      QueryExpression.Criteria.AddCondition(ConditionExpression);
      IF NOT ProcessQueryExpression(OrganizationServiceProxy,EntityCollection,QueryExpression) THEN
        ProcessConnectionFailures;
      EXIT(EntityCollection.Entities.Count > 0);
    END;

    [External]
    PROCEDURE CheckModifyCRMConnectionURL@37(VAR ServerAddress@1006 : Text[250]);
    VAR
      CRMSetupDefaults@1005 : Codeunit 5334;
      UriHelper@1004 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Uri";
      UriHelper2@1003 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Uri";
      UriKindHelper@1002 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.UriKind";
      UriPartialHelper@1001 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.UriPartial";
      ProposedUri@1000 : Text[250];
    BEGIN
      IF (ServerAddress = '') OR (ServerAddress = '@@test@@') THEN
        EXIT;

      ServerAddress := DELCHR(ServerAddress,'<>');

      IF NOT UriHelper.TryCreate(ServerAddress,UriKindHelper.Absolute,UriHelper2) THEN
        IF NOT UriHelper.TryCreate('https://' + ServerAddress,UriKindHelper.Absolute,UriHelper2) THEN
          ERROR(InvalidUriErr);

      IF UriHelper2.Scheme <> 'https' THEN BEGIN
        IF NOT CRMSetupDefaults.GetAllowNonSecureConnections THEN
          ERROR(STRSUBSTNO(MustUseHttpsErr,CRMProductName.SHORT));
        IF UriHelper2.Scheme <> 'http' THEN
          ERROR(STRSUBSTNO(MustUseHttpOrHttpsErr,UriHelper2.Scheme,CRMProductName.SHORT));
      END;

      ProposedUri := UriHelper2.GetLeftPart(UriPartialHelper.Authority);

      // Test that a specific port number is given
      IF ((UriHelper2.Port = 443) OR (UriHelper2.Port = 80)) AND (LOWERCASE(ServerAddress) <> LOWERCASE(ProposedUri)) THEN BEGIN
        IF CONFIRM(STRSUBSTNO(ReplaceServerAddressQst,ServerAddress,ProposedUri)) THEN
          ServerAddress := ProposedUri;
      END;
    END;

    PROCEDURE GetOrganizationFromUrl@76(ServerAddress@1006 : Text[250]) orgName : Text;
    VAR
      UriHelper@1004 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Uri";
      UriHelper2@1003 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Uri";
      UriKindHelper@1002 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.UriKind";
    BEGIN
      // Return the organization name from an OnPremise URL which is in the form
      // http://crm-server:port/organization-name
      // Notice that TryCreate will fail if the port is not a number

      IF (ServerAddress = '') OR (ServerAddress = '@@test@@') THEN
        EXIT('');

      ServerAddress := DELCHR(ServerAddress,'<>');

      IF NOT UriHelper.TryCreate(ServerAddress,UriKindHelper.Absolute,UriHelper2) THEN
        IF NOT UriHelper.TryCreate('https://' + ServerAddress,UriKindHelper.Absolute,UriHelper2) THEN
          ERROR(InvalidUriErr);

      orgName := UriHelper2.AbsolutePath;
      IF orgName = '/' THEN
        EXIT('');

      IF (orgName <> '') AND (STRLEN(orgName) > 1) THEN
        orgName := COPYSTR(orgName,2);
      EXIT(orgName);
    END;

    [Internal]
    PROCEDURE CreateQueryExpression@49(EntityName@1000 : Text;Column@1001 : Text;ConditionField@1006 : Text;ConditionFieldValue@1007 : Text;LinkEntity@1003 : DotNet "'Microsoft.Xrm.Sdk, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Xrm.Sdk.Query.LinkEntity";VAR QueryExpression@1002 : DotNet "'Microsoft.Xrm.Sdk, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Xrm.Sdk.Query.QueryExpression");
    VAR
      ColumnSet@1005 : DotNet "'Microsoft.Xrm.Sdk, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Xrm.Sdk.Query.ColumnSet";
      FilterExpression@1004 : DotNet "'Microsoft.Xrm.Sdk, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Xrm.Sdk.Query.FilterExpression";
    BEGIN
      ColumnSet := ColumnSet.ColumnSet;
      IF Column <> '' THEN
        ColumnSet.AddColumn(Column);
      CreateFilterExpression(ConditionField,ConditionFieldValue,FilterExpression);
      QueryExpression := QueryExpression.QueryExpression(EntityName);
      QueryExpression.ColumnSet(ColumnSet);
      IF NOT ISNULL(LinkEntity) THEN
        QueryExpression.LinkEntities.Add(LinkEntity);
      QueryExpression.Criteria(FilterExpression);
    END;

    LOCAL PROCEDURE CheckRoleAssignedToUser@59(VAR OrganizationServiceProxy@1001 : DotNet "'Microsoft.Xrm.Sdk, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Xrm.Sdk.Client.OrganizationServiceProxy";UserIDGUID@1000 : GUID;RoleIDGUID@1002 : GUID) : Boolean;
    VAR
      QueryExpression@1007 : DotNet "'Microsoft.Xrm.Sdk, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Xrm.Sdk.Query.QueryExpression";
      EntityCollection@1010 : DotNet "'Microsoft.Xrm.Sdk, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Xrm.Sdk.EntityCollection";
    BEGIN
      CreateRoleToUserIDQueryExpression(UserIDGUID,RoleIDGUID,QueryExpression);
      IF NOT ProcessQueryExpression(OrganizationServiceProxy,EntityCollection,QueryExpression) THEN
        ProcessConnectionFailures;
      EXIT(EntityCollection.Entities.Count > 0);
    END;

    [External]
    PROCEDURE ConstructConnectionStringForSolutionImport@39(ServerAddress@1005 : Text) : Text;
    VAR
      FirstPart@1000 : Text;
      SecondPart@1002 : Text;
      FirstLevel@1001 : Integer;
    BEGIN
      FirstLevel := STRPOS(ServerAddress,'.');
      IF FirstLevel = 0 THEN
        ERROR(STRSUBSTNO(CRMConnectionURLWrongErr,CRMProductName.SHORT));
      FirstPart := COPYSTR(ServerAddress,1,FirstLevel);
      SecondPart := COPYSTR(ServerAddress,FirstLevel);
      EXIT(STRSUBSTNO(ImportSolutionConnectStringTok,FirstPart,SecondPart));
    END;

    [TryFunction]
    LOCAL PROCEDURE InitializeCRMConnection@47(URI@1004 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Uri";HomeRealmURI@1003 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Uri";ClientCredentials@1002 : DotNet "'System.ServiceModel, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.ServiceModel.Description.ClientCredentials";VAR CRMHelper@1005 : DotNet "'Microsoft.Dynamics.Nav.CrmCustomizationHelper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.CrmCustomizationHelper.CrmHelper";VAR OrganizationServiceProxy@1000 : DotNet "'Microsoft.Xrm.Sdk, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Xrm.Sdk.Client.OrganizationServiceProxy");
    BEGIN
      OrganizationServiceProxy := CRMHelper.InitializeServiceProxy(URI,HomeRealmURI,ClientCredentials);
    END;

    [TryFunction]
    LOCAL PROCEDURE ProcessQueryExpression@58(VAR OrganizationServiceProxy@1000 : DotNet "'Microsoft.Xrm.Sdk, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Xrm.Sdk.Client.OrganizationServiceProxy";VAR EntityCollection@1002 : DotNet "'Microsoft.Xrm.Sdk, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Xrm.Sdk.EntityCollection";QueryExpression@1001 : DotNet "'Microsoft.Xrm.Sdk, Version=8.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Xrm.Sdk.Query.QueryExpression");
    BEGIN
      EntityCollection := OrganizationServiceProxy.RetrieveMultiple(QueryExpression);
    END;

    LOCAL PROCEDURE ProcessConnectionFailures@50();
    VAR
      DotNetExceptionHandler@1000 : Codeunit 1291;
      FaultException@1001 : DotNet "'System.ServiceModel, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.ServiceModel.FaultException";
      FileNotFoundException@1002 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.FileNotFoundException";
      ArgumentNullException@1003 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.ArgumentNullException";
      CRMHelper@1005 : DotNet "'Microsoft.Dynamics.Nav.CrmCustomizationHelper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.CrmCustomizationHelper.CrmHelper";
    BEGIN
      DotNetExceptionHandler.Collect;

      IF DotNetExceptionHandler.TryCastToType(GETDOTNETTYPE(FaultException)) THEN
        ERROR(STRSUBSTNO(AdminEmailPasswordWrongErr,CRMProductName.SHORT));
      IF DotNetExceptionHandler.TryCastToType(GETDOTNETTYPE(FileNotFoundException)) THEN
        ERROR(CRMSolutionFileNotFoundErr);
      IF DotNetExceptionHandler.TryCastToType(CRMHelper.OrganizationServiceFaultExceptionType) THEN
        ERROR(STRSUBSTNO(AdminUserDoesNotHavePriviligesErr,CRMProductName.SHORT));
      IF DotNetExceptionHandler.TryCastToType(CRMHelper.SystemNetWebException) THEN
        ERROR(STRSUBSTNO(CRMConnectionURLWrongErr,CRMProductName.SHORT));
      IF DotNetExceptionHandler.CastToType(ArgumentNullException,GETDOTNETTYPE(ArgumentNullException)) THEN
        IF ArgumentNullException.ParamName = 'identityProvider' THEN
          ERROR(STRSUBSTNO(AdminEmailPasswordWrongErr,CRMProductName.SHORT));
      DotNetExceptionHandler.Rethrow;
    END;

    [Internal]
    PROCEDURE SetupItemAvailabilityService@100();
    VAR
      TenantWebService@1000 : Record 2000000168;
      WebServiceManagement@1001 : Codeunit 9750;
    BEGIN
      WebServiceManagement.CreateTenantWebService(
        TenantWebService."Object Type"::Page,PAGE::"Product Item Availability",'ProductItemAvailability',TRUE);
    END;

    LOCAL PROCEDURE GetIntegrationAdminRoleID@29() : Text;
    BEGIN
      EXIT('8c8d4f51-a72b-e511-80d9-3863bb349780');
    END;

    LOCAL PROCEDURE GetIntegrationUserRoleID@53() : Text;
    BEGIN
      EXIT('6f960e32-a72b-e511-80d9-3863bb349780');
    END;

    LOCAL PROCEDURE SendRestoredSyncNotification@73(Counter@1000 : Integer);
    VAR
      Msg@1001 : Text;
    BEGIN
      IF Counter = 1 THEN
        Msg := SyncRestoredMsg
      ELSE
        Msg := STRSUBSTNO(SyncMultipleRestoredMsg,Counter);
      SendNotification(Msg);
    END;

    [External]
    PROCEDURE SendResultNotification@1(RecVariant@1000 : Variant) : Boolean;
    VAR
      CRMIntegrationRecord@1001 : Record 5331;
      IntegrationSynchJob@1004 : Record 5338;
      RecordRef@1002 : RecordRef;
      NotificationMessage@1003 : Text;
      FailureDatetime@1005 : DateTime;
      SuccessDateTime@1006 : DateTime;
    BEGIN
      RecordRef.GETTABLE(RecVariant);
      IF CRMIntegrationRecord.FindByRecordID(RecordRef.RECORDID) THEN BEGIN
        IF CRMIntegrationRecord.Skipped THEN
          EXIT(SendSkippedSyncNotification(CRMIntegrationRecord."Integration ID"));

        IF CRMIntegrationRecord."Last Synch. CRM Result" = CRMIntegrationRecord."Last Synch. CRM Result"::Failure THEN BEGIN
          IntegrationSynchJob.GET(CRMIntegrationRecord."Last Synch. CRM Job ID");
          NotificationMessage := IntegrationSynchJob.GetErrorForRecordID(RecordRef.RECORDID);
          FailureDatetime := CRMIntegrationRecord."Last Synch. CRM Modified On";
        END ELSE
          SuccessDateTime := CRMIntegrationRecord."Last Synch. CRM Modified On";

        IF CRMIntegrationRecord."Last Synch. Result" = CRMIntegrationRecord."Last Synch. Result"::Failure THEN BEGIN
          IntegrationSynchJob.GET(CRMIntegrationRecord."Last Synch. Job ID");
          NotificationMessage := IntegrationSynchJob.GetErrorForRecordID(RecordRef.RECORDID);
          FailureDatetime := CRMIntegrationRecord."Last Synch. Modified On";
        END ELSE
          SuccessDateTime := CRMIntegrationRecord."Last Synch. Modified On";

        IF SuccessDateTime > FailureDatetime THEN
          NotificationMessage := '';
      END ELSE BEGIN
        CLEAR(IntegrationSynchJob);
        IntegrationSynchJob."Synch. Direction" := IntegrationSynchJob."Synch. Direction"::ToIntegrationTable;
        NotificationMessage := IntegrationSynchJob.GetErrorForRecordID(RecordRef.RECORDID);
      END;
      IF NotificationMessage <> '' THEN
        EXIT(SendNotification(NotificationMessage));
    END;

    LOCAL PROCEDURE SendSkippedSyncNotification@52(IntegrationID@1000 : GUID) : Boolean;
    VAR
      SyncNotification@1001 : Notification;
    BEGIN
      SyncNotification.ID := CREATEGUID;
      SyncNotification.MESSAGE(SyncSkippedMsg);
      SyncNotification.SCOPE(NOTIFICATIONSCOPE::LocalScope);
      SyncNotification.SETDATA('IntegrationID',IntegrationID);
      SyncNotification.ADDACTION(DetailsTxt,CODEUNIT::"CRM Integration Management",'ShowSkippedRecords');
      SyncNotification.SEND;
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE SendSyncNotification@74(RecordCounter@1001 : ARRAY [4] OF Integer) : Boolean;
    BEGIN
      IF RecordCounter[NoOf::Total] = 1 THEN BEGIN
        IF RecordCounter[NoOf::Scheduled] = 1 THEN
          EXIT(SendNotification(SyncNowScheduledMsg));
        IF RecordCounter[NoOf::Skipped] = 1 THEN
          EXIT(SendNotification(SyncNowSkippedMsg));
        EXIT(SendNotification(SyncNowFailedMsg));
      END;
      EXIT(SendMultipleSyncNotification(RecordCounter));
    END;

    LOCAL PROCEDURE SendMultipleSyncNotification@65(RecordCounter@1001 : ARRAY [4] OF Integer) : Boolean;
    BEGIN
      EXIT(
        SendNotification(
          STRSUBSTNO(
            SyncMultipleMsg,
            RecordCounter[NoOf::Scheduled],RecordCounter[NoOf::Failed],
            RecordCounter[NoOf::Skipped],RecordCounter[NoOf::Total])));
    END;

    LOCAL PROCEDURE SendNotification@63(Msg@1000 : Text) : Boolean;
    VAR
      SyncNotification@1001 : Notification;
    BEGIN
      SyncNotification.ID := CREATEGUID;
      SyncNotification.MESSAGE(Msg);
      SyncNotification.SCOPE(NOTIFICATIONSCOPE::LocalScope);
      SyncNotification.SEND;
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE ShowLog@11(RecId@1000 : RecordID);
    VAR
      CRMIntegrationRecord@1003 : Record 5331;
      IntegrationTableMapping@1001 : Record 5335;
    BEGIN
      GetIntegrationTableMapping(IntegrationTableMapping,RecId.TABLENO);
      CRMIntegrationRecord.FindByRecordID(RecId);
      IntegrationTableMapping.ShowLog(CRMIntegrationRecord.GetLatestJobIDFilter);
    END;

    [External]
    PROCEDURE ShowSkippedRecords@26(SkippedSyncNotification@1000 : Notification);
    VAR
      CRMIntegrationRecord@1002 : Record 5331;
      IntegrationID@1001 : GUID;
    BEGIN
      IF EVALUATE(IntegrationID,SkippedSyncNotification.GETDATA('IntegrationID')) THEN BEGIN
        CRMIntegrationRecord.SETRANGE("Integration ID",IntegrationID);
        IF CRMIntegrationRecord.FINDFIRST THEN;
      END;
      CRMIntegrationRecord.RESET;
      PAGE.RUN(PAGE::"CRM Skipped Records",CRMIntegrationRecord);
    END;

    [External]
    PROCEDURE CoupleCRMEntity@79(RecordID@1001 : RecordID;CRMID@1003 : GUID;VAR Synchronize@1005 : Boolean;VAR Direction@1004 : Option) : Boolean;
    VAR
      CRMIntegrationRecord@1002 : Record 5331;
      CouplingRecordBuffer@1007 : Record 5332;
    BEGIN
      CouplingRecordBuffer.Initialize(RecordID);
      CouplingRecordBuffer."CRM ID" := CRMID;
      IF NOT CouplingRecordBuffer.INSERT THEN
        CouplingRecordBuffer.MODIFY;
      IF NOT ISNULLGUID(CouplingRecordBuffer."CRM ID") THEN BEGIN
        CRMIntegrationRecord.CoupleRecordIdToCRMID(CouplingRecordBuffer."NAV Record ID",CouplingRecordBuffer."CRM ID");
        IF CouplingRecordBuffer.GetPerformInitialSynchronization THEN BEGIN
          Synchronize := TRUE;
          Direction := CouplingRecordBuffer.GetInitialSynchronizationDirection;
          PerformInitialSynchronization(CouplingRecordBuffer."NAV Record ID",CouplingRecordBuffer."CRM ID",Direction);
        END;
      END ELSE
        EXIT(FALSE);
      EXIT(TRUE);
    END;

    BEGIN
    END.
  }
}

