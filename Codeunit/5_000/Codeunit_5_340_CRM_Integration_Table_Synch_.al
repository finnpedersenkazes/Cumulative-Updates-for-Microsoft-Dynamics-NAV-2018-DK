OBJECT Codeunit 5340 CRM Integration Table Synch.
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    TableNo=5335;
    OnRun=VAR
            CRMConnectionSetup@1002 : Record 5330;
            Field@1003 : Record 2000000041;
            OriginalJobQueueEntry@1000 : Record 472;
            ConnectionName@1001 : Text;
            LatestModifiedOn@1004 : ARRAY [2] OF DateTime;
          BEGIN
            ConnectionName := InitConnection;

            IF "Int. Table UID Field Type" = Field.Type::Option THEN
              SynchOption(Rec)
            ELSE BEGIN
              SetOriginalCRMJobQueueEntryOnHold(Rec,OriginalJobQueueEntry);
              IF Direction IN [Direction::ToIntegrationTable,Direction::Bidirectional] THEN
                LatestModifiedOn[2] := PerformScheduledSynchToIntegrationTable(Rec);
              IF Direction IN [Direction::FromIntegrationTable,Direction::Bidirectional] THEN
                LatestModifiedOn[1] :=
                  PerformScheduledSynchFromIntegrationTable(Rec,CRMConnectionSetup.GetIntegrationUserID);
              UpdateTableMappingModifiedOn(Rec,LatestModifiedOn);
              SetOriginalCRMJobQueueEntryReady(Rec,OriginalJobQueueEntry);
            END;

            CloseConnection(ConnectionName);
          END;

  }
  CODE
  {
    VAR
      ConnectionNotEnabledErr@1005 : TextConst '@@@="%1 = CRM product name";DAN=%1-forbindelsen er ikke aktiveret.;ENU=The %1 connection is not enabled.';
      RecordNotFoundErr@1006 : TextConst '@@@="%1 = Source table caption, %2 = The lookup value when searching for the source record";DAN=%1 blev ikke fundet i recorden %2.;ENU=Cannot find %1 record %2.';
      SourceRecordIsNotInMappingErr@1007 : TextConst '@@@=%1 Integration Table Mapping caption, %2 Integration Table Mapping Name;DAN=Tilknytningen %2 blev ikke fundet i tabellen %1.;ENU=Cannot find the mapping %2 in table %1.';
      CannotDetermineSourceOriginErr@1009 : TextConst '@@@=%1 the value of the source id;DAN=Det er ikke muligt at fastl�gge kildens oprindelse: %1.;ENU=Cannot determine the source origin: %1.';
      SynchronizeEmptySetErr@1001 : TextConst 'DAN=Der blev gjort et fors�g p� at synkronisere et tomt s�t records.;ENU=Attempted to synchronize an empty set of records.';
      CRMIntTableSubscriber@1000 : Codeunit 5341;
      CRMProductName@1004 : Codeunit 5344;
      TypeHelper@1010 : Codeunit 10;
      SupportedSourceType@1002 : ',RecordID,GUID';
      NoMappingErr@1003 : TextConst '@@@="%1=Table Caption";DAN=Ingen kobling er angivet for %1.;ENU=No mapping is set for %1.';

    LOCAL PROCEDURE InitConnection@21() ConnectionName : Text;
    VAR
      CRMConnectionSetup@1001 : Record 5330;
    BEGIN
      CRMConnectionSetup.GET;
      IF NOT CRMConnectionSetup."Is Enabled" THEN
        ERROR(STRSUBSTNO(ConnectionNotEnabledErr,CRMProductName.FULL));

      ConnectionName := FORMAT(CREATEGUID);

      IF CRMConnectionSetup."Is User Mapping Required" THEN
        ConnectionName := CRMConnectionSetup.RegisterUserConnection
      ELSE
        CRMConnectionSetup.RegisterConnectionWithName(ConnectionName);
      ClearCache;
    END;

    LOCAL PROCEDURE CloseConnection@23(ConnectionName@1000 : Text);
    VAR
      CRMConnectionSetup@1001 : Record 5330;
    BEGIN
      ClearCache;
      CRMConnectionSetup.UnregisterConnectionWithName(ConnectionName);
    END;

    LOCAL PROCEDURE ClearCache@28();
    BEGIN
      CRMIntTableSubscriber.ClearCache;
      CLEAR(CRMIntTableSubscriber);
    END;

    LOCAL PROCEDURE CacheTable@10(VAR RecordRef@1005 : RecordRef;VAR TempRecordRef@1000 : RecordRef);
    VAR
      OutlookSynchNAVMgt@1003 : Codeunit 5301;
    BEGIN
      TempRecordRef.OPEN(RecordRef.NUMBER,TRUE);
      IF RecordRef.FINDSET THEN
        REPEAT
          OutlookSynchNAVMgt.CopyRecordReference(RecordRef,TempRecordRef,FALSE);
        UNTIL RecordRef.NEXT = 0;
      RecordRef.CLOSE;
    END;

    LOCAL PROCEDURE CacheFilteredCRMTable@13(TempSourceRecordRef@1001 : RecordRef;IntegrationTableMapping@1000 : Record 5335;IntegrationUserId@1004 : GUID);
    VAR
      CRMRecordRef@1002 : RecordRef;
      ModifyByFieldRef@1003 : FieldRef;
    BEGIN
      CRMRecordRef.OPEN(IntegrationTableMapping."Integration Table ID");
      IntegrationTableMapping.SetIntRecordRefFilter(CRMRecordRef);
      // Exclude modifications by background job
      ModifyByFieldRef := CRMRecordRef.FIELD(GetModifyByFieldNo(IntegrationTableMapping."Integration Table ID"));
      ModifyByFieldRef.SETFILTER('<>%1',IntegrationUserId);
      CacheTable(CRMRecordRef,TempSourceRecordRef);
      CRMRecordRef.CLOSE;
    END;

    LOCAL PROCEDURE CacheFilteredNAVTable@16(TempSourceRecordRef@1000 : RecordRef;IntegrationTableMapping@1001 : Record 5335);
    VAR
      SourceRecordRef@1002 : RecordRef;
    BEGIN
      SourceRecordRef.OPEN(IntegrationTableMapping."Table ID");
      IntegrationTableMapping.SetRecordRefFilter(SourceRecordRef);
      CacheTable(SourceRecordRef,TempSourceRecordRef);
      SourceRecordRef.CLOSE;
    END;

    LOCAL PROCEDURE GetSourceRecordRef@15(IntegrationTableMapping@1004 : Record 5335;SourceID@1000 : Variant;VAR RecordRef@1001 : RecordRef);
    VAR
      RecordID@1003 : RecordID;
      CRMID@1002 : GUID;
    BEGIN
      CASE GetSourceType(SourceID) OF
        SupportedSourceType::RecordID:
          BEGIN
            RecordID := SourceID;
            IF RecordID.TABLENO = 0 THEN
              ERROR(CannotDetermineSourceOriginErr,SourceID);
            IF NOT (RecordID.TABLENO = IntegrationTableMapping."Table ID") THEN
              ERROR(SourceRecordIsNotInMappingErr,IntegrationTableMapping.TABLECAPTION,IntegrationTableMapping.Name);
            IF NOT RecordRef.GET(RecordID) THEN
              ERROR(RecordNotFoundErr,RecordRef.CAPTION,FORMAT(RecordID,0,1));
          END;
        SupportedSourceType::GUID:
          BEGIN
            CRMID := SourceID;
            IF ISNULLGUID(CRMID) THEN
              ERROR(CannotDetermineSourceOriginErr,SourceID);
            IF NOT IntegrationTableMapping.GetRecordRef(CRMID,RecordRef) THEN
              ERROR(RecordNotFoundErr,IntegrationTableMapping.GetExtendedIntegrationTableCaption,CRMID);
          END;
        ELSE
          ERROR(CannotDetermineSourceOriginErr,SourceID);
      END;
    END;

    LOCAL PROCEDURE GetSourceType@11(Source@1000 : Variant) : Integer;
    BEGIN
      IF Source.ISRECORDID THEN
        EXIT(SupportedSourceType::RecordID);
      IF Source.ISGUID THEN
        EXIT(SupportedSourceType::GUID);
      EXIT(0);
    END;

    LOCAL PROCEDURE FillCodeBufferFromOption@17(FieldRef@1005 : FieldRef;VAR TempNameValueBuffer@1000 : TEMPORARY Record 823) : Boolean;
    VAR
      TempNameValueBufferWithValue@1001 : TEMPORARY Record 823;
    BEGIN
      CollectOptionValues(FieldRef.OPTIONSTRING,TempNameValueBuffer);
      CollectOptionValues(FieldRef.OPTIONCAPTION,TempNameValueBufferWithValue);
      MergeBuffers(TempNameValueBuffer,TempNameValueBufferWithValue);
      EXIT(TempNameValueBuffer.FINDSET);
    END;

    LOCAL PROCEDURE FindModifiedIntegrationRecords@18(VAR IntegrationRecord@1000 : Record 5151;IntegrationTableMapping@1001 : Record 5335) : Boolean;
    BEGIN
      IntegrationRecord.SETRANGE("Table ID",IntegrationTableMapping."Table ID");
      IF IntegrationTableMapping."Synch. Modified On Filter" <> 0DT THEN
        IntegrationRecord.SETFILTER("Modified On",'>%1',IntegrationTableMapping."Synch. Modified On Filter");
      EXIT(IntegrationRecord.FINDSET);
    END;

    LOCAL PROCEDURE CollectOptionValues@12(OptionString@1001 : Text;VAR TempNameValueBuffer@1000 : TEMPORARY Record 823);
    VAR
      CommaPos@1005 : Integer;
      OptionValue@1003 : Text;
      OptionValueInt@1002 : Integer;
    BEGIN
      OptionValueInt := 0;
      TempNameValueBuffer.DELETEALL;
      WHILE STRLEN(OptionString) > 0 DO BEGIN
        CommaPos := STRPOS(OptionString,',');
        IF CommaPos = 0 THEN BEGIN
          OptionValue := OptionString;
          OptionString := '';
        END ELSE BEGIN
          OptionValue := COPYSTR(OptionString,1,CommaPos - 1);
          OptionString := COPYSTR(OptionString,CommaPos + 1);
        END;
        IF DELCHR(OptionValue,'=',' ') <> '' THEN BEGIN
          TempNameValueBuffer.INIT;
          TempNameValueBuffer.ID := OptionValueInt;
          TempNameValueBuffer.Name := COPYSTR(OptionValue,1,MAXSTRLEN(TempNameValueBuffer.Name));
          TempNameValueBuffer.INSERT
        END;
        OptionValueInt += 1;
      END;
    END;

    LOCAL PROCEDURE MergeBuffers@9(VAR TempNameValueBuffer@1000 : TEMPORARY Record 823;VAR TempNameValueBufferWithValue@1001 : TEMPORARY Record 823);
    BEGIN
      WITH TempNameValueBuffer DO BEGIN
        IF FINDSET THEN
          REPEAT
            IF TempNameValueBufferWithValue.GET(ID) THEN BEGIN
              Value := TempNameValueBufferWithValue.Name;
              MODIFY
            END;
          UNTIL NEXT = 0;
        TempNameValueBufferWithValue.DELETEALL;
      END;
    END;

    [Internal]
    PROCEDURE SynchOption@8(IntegrationTableMapping@1003 : Record 5335);
    VAR
      CRMOptionMapping@1007 : Record 5334;
      Field@1000 : Record 2000000041;
      TempNameValueBuffer@1004 : TEMPORARY Record 823;
      FieldRef@1001 : FieldRef;
      KeyRef@1005 : KeyRef;
      RecordRef@1002 : RecordRef;
      NewPK@1006 : Text;
    BEGIN
      IF TypeHelper.GetField(
           IntegrationTableMapping."Integration Table ID",IntegrationTableMapping."Integration Table UID Fld. No.",Field)
      THEN
        IF Field.Type = Field.Type::Option THEN BEGIN
          RecordRef.OPEN(Field.TableNo);
          FieldRef := RecordRef.FIELD(Field."No.");
          RecordRef.CLOSE;
          IF FillCodeBufferFromOption(FieldRef,TempNameValueBuffer) THEN BEGIN
            CRMOptionMapping.SETRANGE("Table ID",IntegrationTableMapping."Table ID");
            CRMOptionMapping.DELETEALL;

            RecordRef.OPEN(IntegrationTableMapping."Table ID");
            KeyRef := RecordRef.KEYINDEX(1);
            FieldRef := KeyRef.FIELDINDEX(1);
            REPEAT
              NewPK := COPYSTR(TempNameValueBuffer.Name,1,FieldRef.LENGTH);
              FieldRef.SETRANGE(NewPK);
              IF NOT RecordRef.FINDFIRST THEN BEGIN
                RecordRef.INIT;
                FieldRef.VALUE := NewPK;
                RecordRef.INSERT(TRUE);
              END;

              CRMOptionMapping.INIT;
              CRMOptionMapping."Record ID" := RecordRef.RECORDID;
              CRMOptionMapping."Option Value" := TempNameValueBuffer.ID;
              CRMOptionMapping."Option Value Caption" := TempNameValueBuffer.Value;
              CRMOptionMapping."Table ID" := IntegrationTableMapping."Table ID";
              CRMOptionMapping."Integration Table ID" := IntegrationTableMapping."Integration Table ID";
              CRMOptionMapping."Integration Field ID" := IntegrationTableMapping."Integration Table UID Fld. No.";
              CRMOptionMapping.INSERT;
            UNTIL TempNameValueBuffer.NEXT = 0;
            RecordRef.CLOSE;
          END;
        END;
    END;

    [Internal]
    PROCEDURE SynchRecord@1(IntegrationTableMapping@1002 : Record 5335;SourceID@1000 : Variant;ForceModify@1003 : Boolean;IgnoreSynchOnlyCoupledRecords@1011 : Boolean) JobID : GUID;
    VAR
      IntegrationTableSynch@1010 : Codeunit 5335;
      FromRecordRef@1008 : RecordRef;
      ToRecordRef@1009 : RecordRef;
    BEGIN
      GetSourceRecordRef(IntegrationTableMapping,SourceID,FromRecordRef);
      JobID := IntegrationTableSynch.BeginIntegrationSynchJob(TABLECONNECTIONTYPE::CRM,IntegrationTableMapping,FromRecordRef.NUMBER);
      IF NOT ISNULLGUID(JobID) THEN BEGIN
        IntegrationTableSynch.Synchronize(FromRecordRef,ToRecordRef,ForceModify,IgnoreSynchOnlyCoupledRecords);
        IntegrationTableSynch.EndIntegrationSynchJob;
      END;
    END;

    [Internal]
    PROCEDURE SynchRecordsToIntegrationTable@6(RecordsToSynchRecordRef@1002 : RecordRef;IgnoreChanges@1001 : Boolean;IgnoreSynchOnlyCoupledRecords@1000 : Boolean) JobID : GUID;
    VAR
      IntegrationTableMapping@1003 : Record 5335;
      IntegrationTableSynch@1010 : Codeunit 5335;
      IntegrationRecordRef@1008 : RecordRef;
    BEGIN
      IF NOT IntegrationTableMapping.FindMappingForTable(RecordsToSynchRecordRef.NUMBER) THEN
        ERROR(STRSUBSTNO(NoMappingErr,RecordsToSynchRecordRef.NAME));

      IF NOT RecordsToSynchRecordRef.FINDSET THEN
        ERROR(SynchronizeEmptySetErr);

      JobID :=
        IntegrationTableSynch.BeginIntegrationSynchJob(
          TABLECONNECTIONTYPE::CRM,IntegrationTableMapping,RecordsToSynchRecordRef.NUMBER);
      IF NOT ISNULLGUID(JobID) THEN BEGIN
        REPEAT
          IntegrationTableSynch.Synchronize(RecordsToSynchRecordRef,IntegrationRecordRef,IgnoreChanges,IgnoreSynchOnlyCoupledRecords)
        UNTIL RecordsToSynchRecordRef.NEXT = 0;
        IntegrationTableSynch.EndIntegrationSynchJob;
      END;
    END;

    LOCAL PROCEDURE SynchNAVTableToCRM@14(IntegrationTableMapping@1002 : Record 5335;VAR IntegrationTableSynch@1000 : Codeunit 5335) LatestModifiedOn : DateTime;
    VAR
      IntegrationRecord@1012 : Record 5151;
      TempCRMIntegrationRecord@1010 : TEMPORARY Record 5331;
      SourceRecordRef@1008 : RecordRef;
      DestinationRecordRef@1007 : RecordRef;
      IgnoreRecord@1001 : Boolean;
      ForceModify@1003 : Boolean;
      ModifiedOn@1005 : DateTime;
    BEGIN
      LatestModifiedOn := 0DT;
      IF FindModifiedIntegrationRecords(IntegrationRecord,IntegrationTableMapping) THEN BEGIN
        CreateCRMIntegrationRecordClone(IntegrationTableMapping."Table ID",TempCRMIntegrationRecord);
        CacheFilteredNAVTable(SourceRecordRef,IntegrationTableMapping);
        ForceModify := IntegrationTableMapping."Delete After Synchronization";
        REPEAT
          IgnoreRecord := FALSE;
          IF SourceRecordRef.GET(IntegrationRecord."Record ID") THEN BEGIN
            OnQueryPostFilterIgnoreRecord(SourceRecordRef,IgnoreRecord);
            IF NOT IgnoreRecord THEN BEGIN
              IF NOT TempCRMIntegrationRecord.IsIntegrationIdCoupled(IntegrationRecord."Integration ID") THEN
                IgnoreRecord := IntegrationTableMapping."Synch. Only Coupled Records";
              IF NOT IgnoreRecord THEN
                IF IntegrationTableSynch.Synchronize(SourceRecordRef,DestinationRecordRef,ForceModify,FALSE) THEN BEGIN
                  ModifiedOn := IntegrationTableSynch.GetRowLastModifiedOn(IntegrationTableMapping,SourceRecordRef);
                  IF ModifiedOn > LatestModifiedOn THEN
                    LatestModifiedOn := ModifiedOn;
                END;
            END;
          END;
        UNTIL IntegrationRecord.NEXT = 0;
      END;
      IF LatestModifiedOn = 0DT THEN
        LatestModifiedOn := IntegrationTableSynch.GetStartDateTime;
    END;

    LOCAL PROCEDURE SynchCRMTableToNAV@25(IntegrationTableMapping@1000 : Record 5335;IntegrationUserId@1005 : GUID;VAR IntegrationTableSynch@1003 : Codeunit 5335) LatestModifiedOn : DateTime;
    VAR
      TempCRMIntegrationRecord@1012 : TEMPORARY Record 5331;
      SourceRecordRef@1008 : RecordRef;
      DestinationRecordRef@1007 : RecordRef;
      ModifiedOn@1004 : DateTime;
      IgnoreRecord@1001 : Boolean;
      ForceModify@1002 : Boolean;
    BEGIN
      LatestModifiedOn := 0DT;
      CacheFilteredCRMTable(SourceRecordRef,IntegrationTableMapping,IntegrationUserId);
      CreateCRMIntegrationRecordClone(IntegrationTableMapping."Table ID",TempCRMIntegrationRecord);
      ForceModify := IntegrationTableMapping."Delete After Synchronization";
      IF SourceRecordRef.FINDSET THEN
        REPEAT
          IgnoreRecord := FALSE;
          OnQueryPostFilterIgnoreRecord(SourceRecordRef,IgnoreRecord);
          IF NOT IgnoreRecord THEN BEGIN
            IF TempCRMIntegrationRecord.IsCRMRecordRefCoupled(SourceRecordRef) THEN
              TempCRMIntegrationRecord.DELETE
            ELSE
              IgnoreRecord := IntegrationTableMapping."Synch. Only Coupled Records";
            IF NOT IgnoreRecord THEN
              IF IntegrationTableSynch.Synchronize(SourceRecordRef,DestinationRecordRef,ForceModify,FALSE) THEN BEGIN
                ModifiedOn := IntegrationTableSynch.GetRowLastModifiedOn(IntegrationTableMapping,SourceRecordRef);
                IF ModifiedOn > LatestModifiedOn THEN
                  LatestModifiedOn := ModifiedOn;
              END;
          END;
        UNTIL SourceRecordRef.NEXT = 0;
      IF LatestModifiedOn = 0DT THEN
        LatestModifiedOn := IntegrationTableSynch.GetStartDateTime;
    END;

    LOCAL PROCEDURE GetModifyByFieldNo@27(CRMTableID@1000 : Integer) : Integer;
    VAR
      Field@1002 : Record 2000000041;
    BEGIN
      Field.SETRANGE(TableNo,CRMTableID);
      Field.SETRANGE(FieldName,'ModifiedBy'); // All CRM tables should have "ModifiedBy" field
      Field.FINDFIRST;
      EXIT(Field."No.");
    END;

    LOCAL PROCEDURE MarkAllFailedCRMRecordsAsModified@39(LatestModifiedOn@1002 : DateTime);
    VAR
      CRMIntegrationRecord@1000 : Record 5331;
    BEGIN
      WITH CRMIntegrationRecord DO BEGIN
        SETRANGE(Skipped,FALSE);
        SETRANGE("Last Synch. CRM Result","Last Synch. CRM Result"::Failure);
        IF FINDSET THEN
          REPEAT
            SetIntegrationRecordModifiedOn("Integration ID",LatestModifiedOn);
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE MarkAllFailedRecordsAsModified@24(LatestModifiedOn@1002 : DateTime);
    VAR
      CRMIntegrationRecord@1000 : Record 5331;
    BEGIN
      WITH CRMIntegrationRecord DO BEGIN
        SETRANGE(Skipped,FALSE);
        SETRANGE("Last Synch. Result","Last Synch. Result"::Failure);
        IF FINDSET THEN
          REPEAT
            SetIntegrationRecordModifiedOn("Integration ID",LatestModifiedOn);
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE SetIntegrationRecordModifiedOn@40(IntegrationID@1000 : GUID;LatestModifiedOn@1001 : DateTime);
    VAR
      IntegrationRecord@1002 : Record 5151;
    BEGIN
      WITH IntegrationRecord DO
        IF GET(IntegrationID) THEN
          IF "Modified On" <= LatestModifiedOn THEN BEGIN
            "Modified On" := LatestModifiedOn + 999;
            MODIFY;
          END;
    END;

    LOCAL PROCEDURE PerformScheduledSynchToIntegrationTable@3(VAR IntegrationTableMapping@1000 : Record 5335) LatestModifiedOn : DateTime;
    VAR
      CRMFullSynchReviewLine@1004 : Record 5373;
      IntegrationTableSynch@1001 : Codeunit 5335;
      JobId@1003 : GUID;
    BEGIN
      JobId :=
        IntegrationTableSynch.BeginIntegrationSynchJob(
          TABLECONNECTIONTYPE::CRM,IntegrationTableMapping,IntegrationTableMapping."Table ID");
      IF NOT ISNULLGUID(JobId) THEN BEGIN
        CRMFullSynchReviewLine.FullSynchStarted(IntegrationTableMapping,JobId,IntegrationTableMapping.Direction::ToIntegrationTable);
        LatestModifiedOn := SynchNAVTableToCRM(IntegrationTableMapping,IntegrationTableSynch);
        MarkAllFailedCRMRecordsAsModified(LatestModifiedOn);
        IntegrationTableSynch.EndIntegrationSynchJob;
        CRMFullSynchReviewLine.FullSynchFinished(IntegrationTableMapping,IntegrationTableMapping.Direction::ToIntegrationTable);
      END;
    END;

    LOCAL PROCEDURE PerformScheduledSynchFromIntegrationTable@4(VAR IntegrationTableMapping@1000 : Record 5335;IntegrationUserId@1001 : GUID) LatestModifiedOn : DateTime;
    VAR
      CRMFullSynchReviewLine@1005 : Record 5373;
      IntegrationTableSynch@1003 : Codeunit 5335;
      JobId@1004 : GUID;
    BEGIN
      JobId :=
        IntegrationTableSynch.BeginIntegrationSynchJob(
          TABLECONNECTIONTYPE::CRM,IntegrationTableMapping,IntegrationTableMapping."Integration Table ID");
      IF NOT ISNULLGUID(JobId) THEN BEGIN
        CRMFullSynchReviewLine.FullSynchStarted(IntegrationTableMapping,JobId,IntegrationTableMapping.Direction::FromIntegrationTable);
        LatestModifiedOn := SynchCRMTableToNAV(IntegrationTableMapping,IntegrationUserId,IntegrationTableSynch);
        MarkAllFailedRecordsAsModified(LatestModifiedOn);
        IntegrationTableSynch.EndIntegrationSynchJob;
        CRMFullSynchReviewLine.FullSynchFinished(IntegrationTableMapping,IntegrationTableMapping.Direction::FromIntegrationTable);
      END;
    END;

    LOCAL PROCEDURE SetOriginalCRMJobQueueEntryOnHold@22(IntegrationTableMapping@1001 : Record 5335;VAR JobQueueEntry@1002 : Record 472);
    VAR
      OriginalIntegrationTableMapping@1000 : Record 5335;
    BEGIN
      IF IntegrationTableMapping."Full Sync is Running" THEN BEGIN
        OriginalIntegrationTableMapping.GET(IntegrationTableMapping."Parent Name");
        JobQueueEntry.SETRANGE("Record ID to Process",OriginalIntegrationTableMapping.RECORDID);
        IF JobQueueEntry.FINDFIRST THEN
          JobQueueEntry.SetStatus(JobQueueEntry.Status::"On Hold");
      END;
    END;

    LOCAL PROCEDURE SetOriginalCRMJobQueueEntryReady@20(IntegrationTableMapping@1002 : Record 5335;VAR JobQueueEntry@1001 : Record 472);
    VAR
      OriginalIntegrationTableMapping@1000 : Record 5335;
    BEGIN
      IF IntegrationTableMapping."Full Sync is Running" THEN BEGIN
        OriginalIntegrationTableMapping.GET(IntegrationTableMapping."Parent Name");
        OriginalIntegrationTableMapping.CopyModifiedOnFilters(IntegrationTableMapping);
        IF JobQueueEntry.FINDFIRST THEN
          JobQueueEntry.SetStatus(JobQueueEntry.Status::Ready);
      END;
    END;

    LOCAL PROCEDURE UpdateTableMappingModifiedOn@26(VAR IntegrationTableMapping@1001 : Record 5335;ModifiedOn@1000 : ARRAY [2] OF DateTime);
    BEGIN
      WITH IntegrationTableMapping DO BEGIN
        IF ModifiedOn[1] > "Synch. Modified On Filter" THEN
          "Synch. Modified On Filter" := ModifiedOn[1];
        IF ModifiedOn[2] > "Synch. Int. Tbl. Mod. On Fltr." THEN
          "Synch. Int. Tbl. Mod. On Fltr." := ModifiedOn[2];
        MODIFY(TRUE);
      END;
    END;

    LOCAL PROCEDURE CreateCRMIntegrationRecordClone@5(ForTable@1000 : Integer;VAR TempCRMIntegrationRecord@1001 : TEMPORARY Record 5331);
    VAR
      CRMIntegrationRecord@1002 : Record 5331;
    BEGIN
      TempCRMIntegrationRecord.RESET;
      TempCRMIntegrationRecord.DELETEALL;

      CRMIntegrationRecord.SETRANGE("Table ID",ForTable);
      IF NOT CRMIntegrationRecord.FINDSET THEN
        EXIT;

      REPEAT
        TempCRMIntegrationRecord.COPY(CRMIntegrationRecord,FALSE);
        TempCRMIntegrationRecord.INSERT;
      UNTIL CRMIntegrationRecord.NEXT = 0;
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnQueryPostFilterIgnoreRecord@2(SourceRecordRef@1001 : RecordRef;VAR IgnoreRecord@1002 : Boolean);
    BEGIN
    END;

    [EventSubscriber(Codeunit,5340,OnQueryPostFilterIgnoreRecord)]
    LOCAL PROCEDURE IgnoreCompanyContactOnQueryPostFilterIgnoreRecord@19(SourceRecordRef@1000 : RecordRef;VAR IgnoreRecord@1001 : Boolean);
    VAR
      Contact@1002 : Record 5050;
    BEGIN
      IF IgnoreRecord THEN
        EXIT;

      IF SourceRecordRef.NUMBER = DATABASE::Contact THEN BEGIN
        SourceRecordRef.SETTABLE(Contact);
        IF Contact.Type = Contact.Type::Company THEN
          IgnoreRecord := TRUE;
      END;
    END;

    [EventSubscriber(Table,472,OnBeforeModifyEvent)]
    LOCAL PROCEDURE OnBeforeModifyJobQueueEntry@7(VAR Rec@1000 : Record 472;VAR xRec@1001 : Record 472;RunTrigger@1002 : Boolean);
    VAR
      CRMFullSynchReviewLine@1003 : Record 5373;
    BEGIN
      CRMFullSynchReviewLine.OnBeforeModifyJobQueueEntry(Rec);
    END;

    BEGIN
    END.
  }
}

