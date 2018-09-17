OBJECT Codeunit 1798 Data Migration Mgt.
{
  OBJECT-PROPERTIES
  {
    Date=25-05-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.22292;
  }
  PROPERTIES
  {
    TableNo=472;
    OnRun=VAR
            DataMigrationError@1002 : Record 1797;
            DataMigrationStatus@1000 : Record 1799;
            Retry@1001 : Boolean;
          BEGIN
            EnableDataMigrationNotificationForAllUsers;
            DataMigrationStatus.GET("Record ID to Process");
            DataMigrationStatus.SETRANGE("Migration Type",DataMigrationStatus."Migration Type");
            Retry := "Parameter String" = RetryTxt;

            OnBeforeMigrationStarted(DataMigrationStatus,Retry);

            IF NOT Retry THEN BEGIN
              DataMigrationStatus.SETRANGE(Status,DataMigrationStatus.Status::Pending);
              DataMigrationFacade.OnFillStagingTables;
              // Close the transaction here otherwise the CODEUNIT.RUN cannot be invoked
              COMMIT;
            END ELSE
              DataMigrationStatus.SETRANGE(Status,DataMigrationStatus.Status::"Completed with Errors");

            // migrate GL accounts (delete the existing ones on a first migration and if GL accounts are migrated)
            DataMigrationStatus.SETRANGE("Destination Table ID",DATABASE::"G/L Account");
            IF DataMigrationStatus.FINDFIRST AND NOT Retry THEN
              IF NOT CODEUNIT.RUN(CODEUNIT::"Data Migration Del G/L Account") THEN
                DataMigrationError.CreateEntryNoStagingTable(DataMigrationStatus."Migration Type",DATABASE::"G/L Account");

            IF CheckAbortRequestedAndMigrateEntity(
                 DataMigrationStatus,DATABASE::"G/L Account",CODEUNIT::"GL Acc. Data Migration Facade",Retry)
            THEN
              EXIT;

            // migrate customers
            IF CheckAbortRequestedAndMigrateEntity(DataMigrationStatus,DATABASE::Customer,CODEUNIT::"Customer Data Migration Facade",Retry) THEN
              EXIT;

            // migrate vendor
            IF CheckAbortRequestedAndMigrateEntity(DataMigrationStatus,DATABASE::Vendor,CODEUNIT::"Vendor Data Migration Facade",Retry) THEN
              EXIT;

            // migrate items
            IF CheckAbortRequestedAndMigrateEntity(DataMigrationStatus,DATABASE::Item,CODEUNIT::"Item Data Migration Facade",Retry) THEN
              EXIT;

            // migrate any other tables if any
            CheckAbortAndMigrateRemainingEntities(DataMigrationStatus,Retry);

            OnAfterMigrationFinished(DataMigrationStatus,FALSE,StartTime,Retry);
          END;

  }
  CODE
  {
    VAR
      DataMigrationStatusFacade@1000 : Codeunit 6101;
      DataMigrationFacade@1019 : Codeunit 6100;
      AbortRequested@1001 : Boolean;
      StartTime@1002 : DateTime;
      RetryTxt@1003 : TextConst '@@@={Locked};DAN=Retry;ENU=Retry';
      DataMigrationNotCompletedQst@1005 : TextConst '@@@=%1 is the caption for Data Migration Overview;DAN=En dataoverf›rsel er allerede i gang. G† til siden %1 for at f† vist status for overf›rslen. Vil du g›re dette nu?;ENU=A data migration is already in progress. To see the status of the migration, go to the %1 page. Do you want to do that now?';
      CustomerTableNotEmptyErr@1004 : TextConst 'DAN=Migreringen er standset, fordi vi har fundet nogle kunder i Dynamics NAV. Du skal slette dem og derefter genstarte migreringen.;ENU=The migration has stopped because we found some customers in Dynamics NAV. You must delete them and then restart the migration.';
      ItemTableNotEmptyErr@1006 : TextConst 'DAN=Migreringen er standset, fordi vi har fundet nogle varer i Dynamics NAV. Du skal slette dem og derefter genstarte migreringen.;ENU=The migration has stopped because we found some items in Dynamics NAV. You must delete them and then restart the migration.';
      VendorTableNotEmptyErr@1007 : TextConst 'DAN=Migreringen er standset, fordi vi har fundet nogle kreditorer i Dynamics NAV. Du skal slette dem og derefter genstarte migreringen.;ENU=The migration has stopped because we found some vendors in Dynamics NAV. You must delete them and then restart the migration.';
      DataMigrationInProgressMsg@1008 : TextConst '@@@="%1 product name ";DAN=Vi overf›rer data til %1.;ENU=We''re migrating data to %1.';
      DataMigrationCompletedWithErrosMsg@1015 : TextConst '@@@=%1 Data Migration Overview page;DAN=Dataoverf›rslen er afbrudt pga. fejl. G† til siden %1 for at rette dem.;ENU=Data migration has stopped due to errors. Go to the %1 page to fix them.';
      DataMigrationEntriesToPostMsg@1018 : TextConst 'DAN=Dataoverf›rslen er fuldf›rt, men der skal stadig g›re et par ting. Du kan finde flere oplysninger p† siden Dataoverf›rselsoversigt.;ENU=Data migration is complete, however, there are still a few things to do. Go to the Data Migration Overview page for more information.';
      DataMigrationFinishedMsg@1010 : TextConst 'DAN=Ja! De data, du har valgt, blev overflyttet.;ENU=Yes! The data you chose was successfully migrated.';
      DataMigrationNotificationNameTxt@1011 : TextConst 'DAN=Meddelelse om dataoverf›rsel;ENU=Data migration notification';
      DataMigrationNotificationDescTxt@1012 : TextConst 'DAN=Vis en advarsel, n†r en dataoverf›rsel er i gang eller er fuldf›rt.;ENU=Show a warning when data migration is either in progress or has completed.';
      DontShowTxt@1013 : TextConst 'DAN=Vis ikke igen;ENU=Don''t show again';
      MigrationStatus@1014 : 'Pending,In Progress,Completed with errors,Completed,Stopped,Failed,Not Started';
      GoThereNowTxt@1016 : TextConst 'DAN=G† dertil nu;ENU=Go there now';
      MoreInfoTxt@1017 : TextConst 'DAN=F† mere at vide;ENU=Learn more';
      DataMigrationHelpTopicURLTxt@1009 : TextConst '@@@=Locked;DAN="https://go.microsoft.com/fwlink/?linkid=859445";ENU="https://go.microsoft.com/fwlink/?linkid=859445"';

    LOCAL PROCEDURE HandleEntityMigration@25(VAR DataMigrationStatus@1003 : Record 1799;BaseAppMigrationCodeunitToRun@1000 : Integer;Retry@1004 : Boolean);
    VAR
      DataMigrationError@1001 : Record 1797;
    BEGIN
      IF DataMigrationStatus.FINDFIRST THEN
        IF DataMigrationStatus."Source Staging Table ID" > 0 THEN
          StagingTableEntityMigration(DataMigrationStatus,BaseAppMigrationCodeunitToRun,Retry)
        ELSE BEGIN
          DataMigrationStatusFacade.UpdateLineStatus(DataMigrationStatus."Migration Type",
            DataMigrationStatus."Destination Table ID",DataMigrationStatus.Status::"In Progress");
          DataMigrationError.ClearEntryNoStagingTable(DataMigrationStatus."Migration Type",
            DataMigrationStatus."Destination Table ID");
          COMMIT; // save the dashboard before calling the extension codeunit
          IF CODEUNIT.RUN(DataMigrationStatus."Migration Codeunit To Run") THEN BEGIN
            DataMigrationStatus.GET(DataMigrationStatus."Migration Type",DataMigrationStatus."Destination Table ID");
            IF DataMigrationStatus."Migrated Number" = 0 THEN
              DataMigrationStatusFacade.IncrementMigratedRecordCount(
                DataMigrationStatus."Migration Type",DataMigrationStatus."Destination Table ID",DataMigrationStatus."Total Number");
            DataMigrationStatus.SETRANGE(Status,DataMigrationStatus.Status::"In Progress");
            IF DataMigrationStatus.FINDSET THEN
              DataMigrationStatusFacade.UpdateLineStatus(
                DataMigrationStatus."Migration Type",DataMigrationStatus."Destination Table ID",DataMigrationStatus.Status::Completed);
          END ELSE BEGIN
            DataMigrationError.CreateEntryNoStagingTable(DataMigrationStatus."Migration Type",
              DataMigrationStatus."Destination Table ID");
            DataMigrationStatusFacade.UpdateLineStatus(
              DataMigrationStatus."Migration Type",
              DataMigrationStatus."Destination Table ID",
              DataMigrationStatus.Status::Failed);
          END;
        END;
    END;

    LOCAL PROCEDURE StagingTableEntityMigration@39(DataMigrationStatus@1003 : Record 1799;BaseAppCodeunitToRun@1000 : Integer;Retry@1008 : Boolean);
    VAR
      TempDataMigrationParametersBatch@1004 : TEMPORARY Record 1798;
      DummyDataMigrationStatus@1005 : Record 1799;
      DataMigrationError@1006 : Record 1797;
      StagingTableRecRef@1002 : RecordRef;
      Count@1001 : Integer;
    BEGIN
      StagingTableRecRef.OPEN(DataMigrationStatus."Source Staging Table ID");
      IF StagingTableRecRef.FINDSET THEN BEGIN
        DataMigrationStatusFacade.UpdateLineStatus(DataMigrationStatus."Migration Type",
          DataMigrationStatus."Destination Table ID",DummyDataMigrationStatus.Status::"In Progress");
        REPEAT
          IF AbortRequested THEN
            EXIT;

          DataMigrationError.RESET;
          IF NOT Retry OR
             (Retry AND
              DataMigrationError.FindEntry(DataMigrationStatus."Migration Type",
                DataMigrationStatus."Destination Table ID",StagingTableRecRef.RECORDID) AND
              DataMigrationError."Scheduled For Retry" = TRUE)
          THEN BEGIN
            Count += 1;

            TempDataMigrationParametersBatch.INIT;
            TempDataMigrationParametersBatch.Key := Count;
            TempDataMigrationParametersBatch."Migration Type" := DataMigrationStatus."Migration Type";
            TempDataMigrationParametersBatch."Staging Table Migr. Codeunit" := DataMigrationStatus."Migration Codeunit To Run";
            TempDataMigrationParametersBatch."Staging Table RecId To Process" := StagingTableRecRef.RECORDID;
            TempDataMigrationParametersBatch.INSERT;

            DataMigrationError.ClearEntry(DataMigrationStatus."Migration Type",
              DataMigrationStatus."Destination Table ID",
              StagingTableRecRef.RECORDID);
          END;
          IF Count = 100 THEN BEGIN
            // try to process batch
            COMMIT; // to save the transaction that has deleted the errors
            ProcessBatch(DataMigrationStatus,BaseAppCodeunitToRun,TempDataMigrationParametersBatch,Count);
            Count := 0;
            TempDataMigrationParametersBatch.DELETEALL;
          END;
        UNTIL StagingTableRecRef.NEXT = 0;

        IF AbortRequested THEN
          EXIT;

        IF Count > 0 THEN BEGIN
          COMMIT; // to save the transaction that has deleted the errors
          ProcessBatch(DataMigrationStatus,BaseAppCodeunitToRun,TempDataMigrationParametersBatch,Count);
        END;
      END;

      DataMigrationStatus.CALCFIELDS("Error Count");
      IF DataMigrationStatus."Error Count" = 0 THEN
        DataMigrationStatusFacade.UpdateLineStatus(
          DataMigrationStatus."Migration Type",DataMigrationStatus."Destination Table ID",
          DummyDataMigrationStatus.Status::Completed)
      ELSE
        DataMigrationStatusFacade.UpdateLineStatus(
          DataMigrationStatus."Migration Type",DataMigrationStatus."Destination Table ID",
          DummyDataMigrationStatus.Status::"Completed with Errors");
    END;

    LOCAL PROCEDURE ProcessBatch@9(DataMigrationStatus@1007 : Record 1799;BaseAppCodeunitToRun@1000 : Integer;VAR TempDataMigrationParametersBatch@1005 : TEMPORARY Record 1798;Count@1002 : Integer);
    VAR
      TempDataMigrationParametersSingle@1006 : TEMPORARY Record 1798;
      DataMigrationError@1003 : Record 1797;
    BEGIN
      // try to process batch
      IF CODEUNIT.RUN(BaseAppCodeunitToRun,TempDataMigrationParametersBatch) THEN BEGIN
        // the batch was processed fine, update the dashboard
        DataMigrationStatusFacade.IncrementMigratedRecordCount(DataMigrationStatus."Migration Type",
          DataMigrationStatus."Destination Table ID",Count);
        COMMIT; // save the dashboard status before calling the next Codeunit.RUN
      END ELSE BEGIN
        // the batch processing failed
        TempDataMigrationParametersBatch.FINDSET;
        REPEAT
          // process one by one
          TempDataMigrationParametersSingle.DELETEALL;
          TempDataMigrationParametersSingle.INIT;
          TempDataMigrationParametersSingle.TRANSFERFIELDS(TempDataMigrationParametersBatch);
          TempDataMigrationParametersSingle.INSERT;

          IF CODEUNIT.RUN(BaseAppCodeunitToRun,TempDataMigrationParametersSingle) THEN BEGIN
            // single record processing succeeded, update dashboard
            DataMigrationStatusFacade.IncrementMigratedRecordCount(DataMigrationStatus."Migration Type",
              DataMigrationStatus."Destination Table ID",1);
            COMMIT; // save the dashboard status before calling the next Codeunit.RUN
          END ELSE BEGIN
            DataMigrationError.CreateEntry(DataMigrationStatus."Migration Type",
              DataMigrationStatus."Destination Table ID",TempDataMigrationParametersSingle."Staging Table RecId To Process");
            COMMIT; // save the new errors discovered
          END;
        UNTIL TempDataMigrationParametersBatch.NEXT = 0;
      END;
    END;

    PROCEDURE RunStagingTableMigrationCodeunit@15(CodeunitToRun@1000 : Integer;StagingTableEntityVariant@1001 : Variant) : Boolean;
    BEGIN
      EXIT(CODEUNIT.RUN(CodeunitToRun,StagingTableEntityVariant));
    END;

    [EventSubscriber(Page,1799,OnRequestAbort)]
    LOCAL PROCEDURE OnRequestAbortSubscriber@1();
    BEGIN
      AbortRequested := TRUE;
    END;

    LOCAL PROCEDURE CheckAbortRequestedAndMigrateEntity@5(VAR DataMigrationStatus@1000 : Record 1799;DestinationTableId@1001 : Integer;BaseAppCodeunitToRun@1002 : Integer;ReRun@1003 : Boolean) : Boolean;
    BEGIN
      IF AbortRequested THEN BEGIN
        DataMigrationStatus.RESET;
        DataMigrationStatus.SETRANGE("Migration Type",DataMigrationStatus."Migration Type");
        SetAbortStatus(DataMigrationStatus);
        OnAfterMigrationFinished(DataMigrationStatus,TRUE,StartTime,ReRun);
        EXIT(TRUE);
      END;

      DataMigrationStatus.SETRANGE("Destination Table ID",DestinationTableId);
      HandleEntityMigration(DataMigrationStatus,BaseAppCodeunitToRun,ReRun);
    END;

    LOCAL PROCEDURE CheckAbortAndMigrateRemainingEntities@22(DataMigrationStatus@1000 : Record 1799;Retry@1001 : Boolean);
    BEGIN
      IF AbortRequested THEN BEGIN
        DataMigrationStatus.RESET;
        DataMigrationStatus.SETRANGE("Migration Type",DataMigrationStatus."Migration Type");
        SetAbortStatus(DataMigrationStatus);
        OnAfterMigrationFinished(DataMigrationStatus,TRUE,StartTime,Retry);
        EXIT;
      END;

      DataMigrationStatus.SETFILTER("Destination Table ID",STRSUBSTNO('<>%1&<>%2&<>%3&<>%4',
          DATABASE::Item,
          DATABASE::Customer,
          DATABASE::"G/L Account",
          DATABASE::Vendor));
      DataMigrationStatus.SETRANGE(Status,DataMigrationStatus.Status::Pending);
      IF DataMigrationStatus.FINDSET THEN
        REPEAT
          HandleEntityMigration(DataMigrationStatus,DataMigrationStatus."Migration Codeunit To Run",Retry);
        UNTIL DataMigrationStatus.NEXT = 0;
    END;

    PROCEDURE SetStartTime@11(Value@1000 : DateTime);
    BEGIN
      StartTime := Value;
    END;

    PROCEDURE SetAbortStatus@3(VAR DataMigrationStatus@1000 : Record 1799);
    BEGIN
      DataMigrationStatus.SETFILTER(
        Status,STRSUBSTNO('%1|%2',DataMigrationStatus.Status::"In Progress",DataMigrationStatus.Status::Pending));
      IF DataMigrationStatus.FINDSET THEN
        REPEAT
          DataMigrationStatus.Status := DataMigrationStatus.Status::Stopped;
          DataMigrationStatus.MODIFY(TRUE);
        UNTIL DataMigrationStatus.NEXT = 0;
    END;

    [Integration(TRUE)]
    PROCEDURE OnBeforeMigrationStarted@2(VAR DataMigrationStatus@1000 : Record 1799;Retry@1001 : Boolean);
    BEGIN
    END;

    [Integration]
    PROCEDURE OnAfterMigrationFinished@12(VAR DataMigrationStatus@1000 : Record 1799;WasAborted@1001 : Boolean;StartTime@1002 : DateTime;Retry@1003 : Boolean);
    BEGIN
    END;

    [EventSubscriber(Codeunit,1798,OnBeforeMigrationStarted,"",Skip,Skip)]
    LOCAL PROCEDURE OnBeforeMigrationStartedSubscriber@8(VAR Sender@1000 : Codeunit 1798;VAR DataMigrationStatus@1001 : Record 1799;Retry@1002 : Boolean);
    VAR
      Message@1003 : Text;
    BEGIN
      Sender.SetStartTime(CURRENTDATETIME);
      IF Retry THEN
        Message := 'Migration started.'
      ELSE
        Message := 'Migration restarted.';
      SENDTRACETAG(
        '00001I7',
        STRSUBSTNO('Data Migration (%1)',DataMigrationStatus."Migration Type"),
        VERBOSITY::Normal,
        Message);
    END;

    [EventSubscriber(Codeunit,1798,OnAfterMigrationFinished,"",Skip,Skip)]
    LOCAL PROCEDURE OnAfterMigrationFinishedSubscriber@10(VAR DataMigrationStatus@1000 : Record 1799;WasAborted@1001 : Boolean;StartTime@1003 : DateTime;Retry@1006 : Boolean);
    VAR
      TotalNumberOfRecords@1002 : Integer;
      Message@1004 : Text;
      MigrationDurationAsInt@1005 : BigInteger;
    BEGIN
      DataMigrationStatus.SETRANGE("Destination Table ID",DATABASE::"G/L Account");
      IF DataMigrationStatus.FINDFIRST THEN
        TotalNumberOfRecords += DataMigrationStatus."Total Number";

      DataMigrationStatus.SETRANGE("Destination Table ID",DATABASE::Item);
      IF DataMigrationStatus.FINDFIRST THEN
        TotalNumberOfRecords += DataMigrationStatus."Total Number";

      DataMigrationStatus.SETRANGE("Destination Table ID",DATABASE::Vendor);
      IF DataMigrationStatus.FINDFIRST THEN
        TotalNumberOfRecords += DataMigrationStatus."Total Number";

      DataMigrationStatus.SETRANGE("Destination Table ID",DATABASE::Customer);
      IF DataMigrationStatus.FINDFIRST THEN
        TotalNumberOfRecords += DataMigrationStatus."Total Number";

      MigrationDurationAsInt := CURRENTDATETIME - StartTime;
      IF WasAborted THEN
        Message := STRSUBSTNO('Migration aborted after %1',MigrationDurationAsInt)
      ELSE
        Message := STRSUBSTNO('The migration of %1 records in total took: %2.',TotalNumberOfRecords,MigrationDurationAsInt);

      IF Retry THEN
        Message += '(Migration was restarted)';

      SENDTRACETAG(
        '00001DA',
        STRSUBSTNO('Data Migration (%1)',DataMigrationStatus."Migration Type"),
        VERBOSITY::Normal,
        Message);
    END;

    [External]
    PROCEDURE StartMigration@4(MigrationType@1000 : Text[250];Retry@1001 : Boolean);
    VAR
      DataMigrationError@1006 : Record 1797;
      DataMigrationStatus@1004 : Record 1799;
      JobQueueEntry@1003 : Record 472;
      JobParameters@1005 : Text[250];
      StartNewSession@1002 : Boolean;
      CheckExistingData@1007 : Boolean;
    BEGIN
      CheckMigrationInProgress(Retry);

      StartNewSession := TRUE;
      CheckExistingData := TRUE;
      OnBeforeStartMigration(StartNewSession,CheckExistingData);

      IF CheckExistingData THEN
        CheckDataAlreadyExist(MigrationType,Retry);

      DataMigrationStatus.RESET;
      DataMigrationStatus.SETRANGE("Migration Type",MigrationType);
      IF NOT Retry THEN BEGIN
        DataMigrationStatus.SETRANGE(Status,DataMigrationStatus.Status::Pending);
        IF DataMigrationStatus.FINDSET THEN
          REPEAT
            DataMigrationError.SETRANGE("Migration Type",MigrationType);
            DataMigrationError.SETRANGE("Destination Table ID",DataMigrationStatus."Destination Table ID");
            DataMigrationError.DELETEALL;
          UNTIL DataMigrationStatus.NEXT = 0;
      END ELSE
        DataMigrationStatus.SETRANGE(Status,DataMigrationStatus.Status::"Completed with Errors");

      COMMIT; // commit the dashboard changes so the OnRun call on the migration codeunit will not fail because of this uncommited transaction

      IF Retry THEN
        JobParameters := RetryTxt;
      DataMigrationStatus.FINDFIRST;
      IF StartNewSession THEN
        // run the migration in a background session
        JobQueueEntry.ScheduleJobQueueEntryWithParameters(CODEUNIT::"Data Migration Mgt.",
          DataMigrationStatus.RECORDID,JobParameters)
      ELSE BEGIN
        JobQueueEntry."Record ID to Process" := DataMigrationStatus.RECORDID;
        JobQueueEntry."Parameter String" := JobParameters;
        CODEUNIT.RUN(CODEUNIT::"Data Migration Mgt.",JobQueueEntry);
      END;
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeStartMigration@6(VAR StartNewSession@1000 : Boolean;VAR CheckExistingData@1001 : Boolean);
    BEGIN
    END;

    [External]
    PROCEDURE CheckMigrationInProgress@13(Retry@1000 : Boolean);
    VAR
      JobQueueEntry@1002 : Record 472;
      DataMigrationOverview@1003 : Page 1799;
      Status@1001 : Option;
    BEGIN
      Status := GetMigrationStatus;

      JobQueueEntry.SETRANGE("Object ID to Run",CODEUNIT::"Data Migration Mgt.");
      JobQueueEntry.SETFILTER(Status,'%1|%2|%3',
        JobQueueEntry.Status::"In Process",
        JobQueueEntry.Status::"On Hold",
        JobQueueEntry.Status::Ready);
      IF (Status = MigrationStatus::Pending) AND NOT JobQueueEntry.FINDFIRST THEN
        EXIT;

      IF (Status IN [MigrationStatus::"Completed with errors",
                     MigrationStatus::"In Progress",
                     MigrationStatus::Pending]) AND NOT Retry
      THEN BEGIN
        IF CONFIRM(STRSUBSTNO(DataMigrationNotCompletedQst,DataMigrationOverview.CAPTION)) THEN
          DataMigrationOverview.RUN;
        ERROR('');
      END;
    END;

    [External]
    PROCEDURE GetMigrationStatus@20() : Integer;
    VAR
      DataMigrationStatus@1001 : Record 1799;
    BEGIN
      IF DataMigrationStatus.ISEMPTY THEN
        EXIT(MigrationStatus::"Not Started");

      DataMigrationStatus.SETRANGE(Status,DataMigrationStatus.Status::"In Progress");
      IF DataMigrationStatus.FINDFIRST THEN
        EXIT(MigrationStatus::"In Progress");

      DataMigrationStatus.SETRANGE(Status,DataMigrationStatus.Status::Stopped);
      IF DataMigrationStatus.FINDFIRST THEN
        EXIT(MigrationStatus::Stopped);

      DataMigrationStatus.SETFILTER(Status,'=%1',DataMigrationStatus.Status::Failed);
      IF DataMigrationStatus.FINDFIRST THEN
        EXIT(MigrationStatus::Failed);

      DataMigrationStatus.SETRANGE(Status,DataMigrationStatus.Status::"Completed with Errors");
      IF DataMigrationStatus.FINDFIRST THEN
        EXIT(MigrationStatus::"Completed with errors");

      DataMigrationStatus.SETFILTER(Status,'<>%1',DataMigrationStatus.Status::Completed);
      IF NOT DataMigrationStatus.FINDFIRST THEN
        EXIT(MigrationStatus::Completed);

      EXIT(MigrationStatus::Pending);
    END;

    LOCAL PROCEDURE CheckDataAlreadyExist@7(MigrationType@1001 : Text[250];Retry@1000 : Boolean);
    BEGIN
      IF Retry THEN
        EXIT;

      // check tables are clear. For GL accounts, we delete them automatically
      ThrowErrorIfTableNotEmpty(MigrationType,DATABASE::Customer,CustomerTableNotEmptyErr);
      ThrowErrorIfTableNotEmpty(MigrationType,DATABASE::Vendor,VendorTableNotEmptyErr);
      ThrowErrorIfTableNotEmpty(MigrationType,DATABASE::Item,ItemTableNotEmptyErr);
    END;

    LOCAL PROCEDURE ThrowErrorIfTableNotEmpty@17(MigrationType@1004 : Text[250];TableId@1000 : Integer;ErrorMessageErr@1001 : Text);
    VAR
      DataMigrationStatus@1002 : Record 1799;
      RecRef@1003 : RecordRef;
    BEGIN
      IF DataMigrationStatus.GET(MigrationType,TableId) THEN BEGIN
        IF DataMigrationStatus.Status <> DataMigrationStatus.Status::Pending THEN
          EXIT;
        RecRef.OPEN(TableId);
        IF NOT RecRef.ISEMPTY THEN
          ERROR(ErrorMessageErr);
      END;
    END;

    [External]
    PROCEDURE StartDataMigrationWizardFromNotification@14(Notification@1000 : Notification);
    BEGIN
      PAGE.RUN(PAGE::"Data Migration Wizard");
    END;

    [External]
    PROCEDURE ShowDataMigrationRelatedGlobalNotifications@16();
    VAR
      DataMigrationStatus@1002 : Record 1799;
      DataMigrationOverview@1000 : Page 1799;
      Notification@1001 : Notification;
    BEGIN
      IF NOT IsGlobalNotificationEnabled THEN
        EXIT;

      IF DataMigrationStatus.ISEMPTY THEN
        EXIT;

      Notification.ID(GetGlobalNotificationId);
      CASE GetMigrationStatus OF
        MigrationStatus::Pending,
        MigrationStatus::"In Progress":
          BEGIN
            Notification.MESSAGE(STRSUBSTNO(DataMigrationInProgressMsg,PRODUCTNAME.SHORT));
            Notification.ADDACTION(MoreInfoTxt,CODEUNIT::"Data Migration Mgt.",'ShowMoreInfoPage');
          END;
        MigrationStatus::"Completed with errors",
        MigrationStatus::Failed:
          BEGIN
            Notification.MESSAGE(STRSUBSTNO(DataMigrationCompletedWithErrosMsg,DataMigrationOverview.CAPTION));
            Notification.ADDACTION(GoThereNowTxt,CODEUNIT::"Data Migration Mgt.",'ShowDataMigrationOverviewFromNotification');
          END;
        MigrationStatus::Completed:
          IF CheckForEntitiesToBePosted THEN BEGIN
            Notification.MESSAGE(DataMigrationEntriesToPostMsg);
            Notification.ADDACTION(GoThereNowTxt,CODEUNIT::"Data Migration Mgt.",'ShowDataMigrationOverviewFromNotification');
          END ELSE BEGIN
            Notification.MESSAGE(DataMigrationFinishedMsg);
            Notification.ADDACTION(DontShowTxt,CODEUNIT::"Data Migration Mgt.",'DisableDataMigrationRelatedGlobalNotifications');
          END;
        ELSE
          EXIT;
      END;

      Notification.SEND;
    END;

    PROCEDURE GetGlobalNotificationId@19() : GUID;
    BEGIN
      EXIT('47707336-D917-4238-942F-39715F52BE4E');
    END;

    LOCAL PROCEDURE IsGlobalNotificationEnabled@24() : Boolean;
    VAR
      MyNotifications@1001 : Record 1518;
    BEGIN
      EXIT(MyNotifications.IsEnabled(GetGlobalNotificationId));
    END;

    [EventSubscriber(Page,1518,OnInitializingNotificationWithDefaultState)]
    LOCAL PROCEDURE OnInitializingNotificationWithDefaultState@29();
    VAR
      MyNotifications@1000 : Record 1518;
    BEGIN
      MyNotifications.InsertDefault(GetGlobalNotificationId,DataMigrationNotificationNameTxt,DataMigrationNotificationDescTxt,TRUE);
    END;

    [External]
    PROCEDURE ShowDataMigrationOverviewFromNotification@18(Notification@1000 : Notification);
    BEGIN
      PAGE.RUN(PAGE::"Data Migration Overview");
    END;

    [External]
    PROCEDURE IsMigrationInProgress@48() : Boolean;
    BEGIN
      EXIT(GetMigrationStatus IN [MigrationStatus::"In Progress",MigrationStatus::Pending]);
    END;

    [External]
    PROCEDURE ShowMoreInfoPage@55(Notification@1000 : Notification);
    BEGIN
      IF PAGE.RUNMODAL(PAGE::"Data Migration About") = ACTION::LookupOK THEN
        ShowDataMigrationOverviewFromNotification(Notification);
    END;

    PROCEDURE CheckForEntitiesToBePosted@28() : Boolean;
    VAR
      DataMigrationStatus@1000 : Record 1799;
      DummyCode@1001 : Code[10];
    BEGIN
      DataMigrationStatus.SETFILTER(
        Status,'%1|%2',DataMigrationStatus.Status::Completed,DataMigrationStatus.Status::"Completed with Errors");

      IF NOT DataMigrationStatus.FINDSET THEN
        EXIT(FALSE);
      REPEAT
        IF DestTableHasAnyTransactions(DataMigrationStatus,DummyCode) THEN
          EXIT(TRUE);
      UNTIL DataMigrationStatus.NEXT = 0;
    END;

    [Internal]
    PROCEDURE DestTableHasAnyTransactions@40(VAR DataMigrationStatus@1000 : Record 1799;VAR JournalBatchName@1004 : Code[10]) : Boolean;
    VAR
      GenJournalLine@1002 : Record 81;
      ItemJournalLine@1003 : Record 83;
    BEGIN
      CASE DataMigrationStatus."Destination Table ID" OF
        DATABASE::Vendor:
          BEGIN
            DataMigrationFacade.OnFindBatchForVendorTransactions(DataMigrationStatus."Migration Type",JournalBatchName);
            IF JournalBatchName = '' THEN
              EXIT(FALSE);
            GenJournalLine.SETRANGE("Journal Batch Name",JournalBatchName);
            GenJournalLine.SETRANGE("Account Type",GenJournalLine."Account Type"::Vendor);
            GenJournalLine.SETFILTER("Account No.",'<>%1','');
            EXIT(GenJournalLine.FINDFIRST);
          END;
        DATABASE::Customer:
          BEGIN
            DataMigrationFacade.OnFindBatchForCustomerTransactions(DataMigrationStatus."Migration Type",JournalBatchName);
            IF JournalBatchName = '' THEN
              EXIT(FALSE);
            GenJournalLine.SETRANGE("Journal Batch Name",JournalBatchName);
            GenJournalLine.SETRANGE("Account Type",GenJournalLine."Account Type"::Customer);
            GenJournalLine.SETFILTER("Account No.",'<>%1','');
            EXIT(GenJournalLine.FINDFIRST);
          END;
        DATABASE::Item:
          BEGIN
            DataMigrationFacade.OnFindBatchForItemTransactions(DataMigrationStatus."Migration Type",JournalBatchName);
            IF JournalBatchName = '' THEN
              EXIT(FALSE);
            ItemJournalLine.SETRANGE("Journal Batch Name",JournalBatchName);
            ItemJournalLine.SETFILTER("Item No.",'<>%1','');
            EXIT(ItemJournalLine.FINDFIRST);
          END;
        ELSE BEGIN
          DataMigrationFacade.OnFindBatchForAccountTransactions(DataMigrationStatus,JournalBatchName);
          IF JournalBatchName = '' THEN
            EXIT(FALSE);
          GenJournalLine.SETRANGE("Journal Batch Name",JournalBatchName);
          GenJournalLine.SETRANGE("Account Type",GenJournalLine."Account Type"::"G/L Account");
          GenJournalLine.SETFILTER("Account No.",'<>%1','');
          EXIT(GenJournalLine.FINDFIRST);
        END
      END;
    END;

    PROCEDURE ShowHelpTopicPage@56(Notification@1000 : Notification);
    BEGIN
      HYPERLINK(DataMigrationHelpTopicURLTxt);
    END;

    PROCEDURE GetDataMigrationHelpTopicURL@60() : Text;
    BEGIN
      EXIT(DataMigrationHelpTopicURLTxt)
    END;

    PROCEDURE DisableDataMigrationRelatedGlobalNotifications@27(Notification@1000 : Notification);
    VAR
      MyNotifications@1001 : Record 1518;
    BEGIN
      IF NOT MyNotifications.Disable(GetGlobalNotificationId) THEN
        MyNotifications.InsertDefault(GetGlobalNotificationId,DataMigrationNotificationNameTxt,DataMigrationNotificationDescTxt,FALSE);
    END;

    LOCAL PROCEDURE EnableDataMigrationNotificationForAllUsers@26();
    VAR
      MyNotifications@1000 : Record 1518;
    BEGIN
      MyNotifications.SETRANGE("Notification Id",GetGlobalNotificationId);
      IF MyNotifications.FINDSET THEN
        REPEAT
          MyNotifications.Enabled := TRUE;
          MyNotifications.MODIFY(TRUE);
        UNTIL MyNotifications.NEXT = 0;
    END;

    [EventSubscriber(Table,1797,OnAfterErrorInserted)]
    LOCAL PROCEDURE OnAfterErrorInsertedSubscriber@30(MigrationType@1000 : Text;ErrorMessage@1001 : Text);
    BEGIN
      SENDTRACETAG(
        '00001HY',
        STRSUBSTNO('Data Migration (%1)',MigrationType),
        VERBOSITY::Error,
        ErrorMessage);
    END;

    PROCEDURE CheckIfMigrationIsCompleted@21(CurrentDataMigrationStatus@1000 : Record 1799);
    VAR
      DataMigrationStatus@1001 : Record 1799;
      DataMigrationFacade@1003 : Codeunit 6100;
    BEGIN
      DataMigrationStatus.SETRANGE("Migration Type",CurrentDataMigrationStatus."Migration Type");
      DataMigrationStatus.SETFILTER("Destination Table ID",'<>%1',CurrentDataMigrationStatus."Destination Table ID");
      DataMigrationStatus.SETFILTER(
        Status,
        '%1|%2|%3',
        DataMigrationStatus.Status::"In Progress",
        DataMigrationStatus.Status::Pending,
        DataMigrationStatus.Status::"Completed with Errors");
      IF DataMigrationStatus.ISEMPTY THEN
        DataMigrationFacade.OnMigrationCompleted(CurrentDataMigrationStatus);
    END;

    BEGIN
    END.
  }
}

