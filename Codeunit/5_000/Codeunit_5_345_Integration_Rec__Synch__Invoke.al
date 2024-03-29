OBJECT Codeunit 5345 Integration Rec. Synch. Invoke
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    OnRun=BEGIN
            CheckContext;
            SynchRecord(
              IntegrationTableMappingContext,SourceRecordRefContext,DestinationRecordRefContext,
              IntegrationRecordSynchContext,SynchActionContext,IgnoreSynchOnlyCoupledRecordsContext,
              JobIdContext,IntegrationTableConnectionTypeContext);
          END;

  }
  CODE
  {
    VAR
      IntegrationTableMappingContext@1015 : Record 5335;
      IntegrationRecordSynchContext@1012 : Codeunit 5336;
      SourceRecordRefContext@1014 : RecordRef;
      DestinationRecordRefContext@1013 : RecordRef;
      IntegrationTableConnectionTypeContext@1016 : TableConnectionType;
      JobIdContext@1009 : GUID;
      SynchActionType@1000 : 'None,Insert,Modify,ForceModify,IgnoreUnchanged,Fail,Skip';
      BothDestinationAndSourceIsNewerErr@1001 : TextConst '@@@="%1 = Source record table caption, %2 destination table caption";DAN=Recorden %2 kan ikke opdateres, fordi recorderne %1 og %2 er blevet �ndret.;ENU=Cannot update the %2 record because both the %1 record and the %2 record have been changed.';
      InsertFailedErr@1004 : TextConst '@@@="%1 = Table Caption, %2 = Error from insert process.";DAN=Inds�ttelse af %1 mislykkedes p� grund af f�lgende fejl: %2.;ENU=Inserting %1 failed because of the following error: %2.';
      ModifyFailedErr@1003 : TextConst '@@@="%1 = Table Caption, %2 = Error from modify process.";DAN=Redigering af %1 mislykkedes p� grund af f�lgende fejl: %2.;ENU=Modifying %1 failed because of the following error: %2.';
      ConfigurationTemplateNotFoundErr@1005 : TextConst '@@@="%1 = Configuration Template table caption, %2 = Configuration Template Name";DAN=%1 for %2 blev ikke fundet.;ENU=The %1 %2 was not found.';
      CoupledRecordIsDeletedErr@1006 : TextConst '@@@="1% = Source Table Caption";DAN=Recorden %1 kan ikke opdateres, fordi den er sammenk�det med en slettet record.;ENU=The %1 record cannot be updated because it is coupled to a deleted record.';
      CopyDataErr@1007 : TextConst '@@@="%1 = Error message from transferdata process.";DAN=Data blev ikke opdateret p� grund af f�lgende fejl: %1.;ENU=The data could not be updated because of the following error: %1.';
      IntegrationRecordNotFoundErr@1008 : TextConst '@@@="%1 = Internationalized RecordID, such as ''Customer 1234''";DAN=Integrationsrecorden for %1 blev ikke fundet.;ENU=The integration record for %1 was not found.';
      SynchActionContext@1011 : Option;
      IgnoreSynchOnlyCoupledRecordsContext@1010 : Boolean;
      IsContextInitialized@1017 : Boolean;
      ContextErr@1018 : TextConst 'DAN=Synkroniseringskonteksten for integrationsrecorden er ikke blevet initialiseret.;ENU=The integration record synchronization context has not been initialized.';

    [External]
    PROCEDURE SetContext@4(IntegrationTableMapping@1006 : Record 5335;SourceRecordRef@1005 : RecordRef;DestinationRecordRef@1004 : RecordRef;IntegrationRecordSynch@1010 : Codeunit 5336;SynchAction@1007 : Option;IgnoreSynchOnlyCoupledRecords@1003 : Boolean;JobId@1008 : GUID;IntegrationTableConnectionType@1009 : TableConnectionType);
    BEGIN
      IntegrationTableMappingContext := IntegrationTableMapping;
      IntegrationRecordSynchContext := IntegrationRecordSynch;
      SourceRecordRefContext := SourceRecordRef;
      DestinationRecordRefContext := DestinationRecordRef;
      SynchActionContext := SynchAction;
      IgnoreSynchOnlyCoupledRecordsContext := IgnoreSynchOnlyCoupledRecords;
      IntegrationTableConnectionTypeContext := IntegrationTableConnectionType;
      JobIdContext := JobId;
      IsContextInitialized := TRUE;
    END;

    [External]
    PROCEDURE GetContext@3(VAR IntegrationTableMapping@1006 : Record 5335;VAR SourceRecordRef@1005 : RecordRef;VAR DestinationRecordRef@1004 : RecordRef;VAR IntegrationRecordSynch@1010 : Codeunit 5336;VAR SynchAction@1000 : Option);
    BEGIN
      CheckContext;
      IntegrationTableMapping := IntegrationTableMappingContext;
      IntegrationRecordSynch := IntegrationRecordSynchContext;
      SourceRecordRef := SourceRecordRefContext;
      DestinationRecordRef := DestinationRecordRefContext;
      SynchAction := SynchActionContext;
    END;

    [Internal]
    PROCEDURE WasModifiedAfterLastSynch@36(IntegrationTableMapping@1000 : Record 5335;RecordRef@1001 : RecordRef) : Boolean;
    VAR
      IntegrationRecordManagement@1003 : Codeunit 5338;
      LastModifiedOn@1002 : DateTime;
    BEGIN
      LastModifiedOn := GetRowLastModifiedOn(IntegrationTableMapping,RecordRef);
      IF IntegrationTableMapping."Integration Table ID" = RecordRef.NUMBER THEN
        EXIT(
          IntegrationRecordManagement.IsModifiedAfterIntegrationTableRecordLastSynch(
            IntegrationTableConnectionTypeContext,RecordRef.FIELD(IntegrationTableMapping."Integration Table UID Fld. No.").VALUE,
            IntegrationTableMapping."Table ID",LastModifiedOn));

      EXIT(
        IntegrationRecordManagement.IsModifiedAfterRecordLastSynch(
          IntegrationTableConnectionTypeContext,RecordRef.RECORDID,LastModifiedOn));
    END;

    [External]
    PROCEDURE GetRowLastModifiedOn@2(IntegrationTableMapping@1000 : Record 5335;FromRecordRef@1001 : RecordRef) : DateTime;
    VAR
      IntegrationRecord@1002 : Record 5151;
      ModifiedFieldRef@1004 : FieldRef;
    BEGIN
      IF FromRecordRef.NUMBER = IntegrationTableMapping."Integration Table ID" THEN BEGIN
        ModifiedFieldRef := FromRecordRef.FIELD(IntegrationTableMapping."Int. Tbl. Modified On Fld. No.");
        EXIT(ModifiedFieldRef.VALUE);
      END;

      IF IntegrationRecord.FindByRecordId(FromRecordRef.RECORDID) THEN
        EXIT(IntegrationRecord."Modified On");
      ERROR(IntegrationRecordNotFoundErr,FORMAT(FromRecordRef.RECORDID,0,1));
    END;

    LOCAL PROCEDURE CheckContext@5();
    BEGIN
      IF NOT IsContextInitialized THEN
        ERROR(ContextErr);
    END;

    LOCAL PROCEDURE SynchRecord@9(VAR IntegrationTableMapping@1006 : Record 5335;VAR SourceRecordRef@1005 : RecordRef;VAR DestinationRecordRef@1004 : RecordRef;VAR IntegrationRecordSynch@1010 : Codeunit 5336;VAR SynchAction@1007 : Option;IgnoreSynchOnlyCoupledRecords@1003 : Boolean;JobId@1008 : GUID;IntegrationTableConnectionType@1009 : TableConnectionType);
    VAR
      AdditionalFieldsModified@1000 : Boolean;
      SourceWasChanged@1001 : Boolean;
      WasModified@1011 : Boolean;
      ConflictText@1002 : Text;
      RecordState@1012 : 'NotFound,Coupled,Decoupled';
    BEGIN
      // Find the coupled record or prepare a new one
      RecordState :=
        GetCoupledRecord(
          IntegrationTableMapping,SourceRecordRef,DestinationRecordRef,SynchAction,JobId,IntegrationTableConnectionType);
      IF RecordState = RecordState::NotFound THEN BEGIN
        IF SynchAction = SynchActionType::Fail THEN
          EXIT;
        IF IntegrationTableMapping."Synch. Only Coupled Records" AND NOT IgnoreSynchOnlyCoupledRecords THEN BEGIN
          SynchAction := SynchActionType::Skip;
          EXIT;
        END;
        PrepareNewDestination(IntegrationTableMapping,SourceRecordRef,DestinationRecordRef);
        SynchAction := SynchActionType::Insert;
      END;

      IF SynchAction = SynchActionType::Insert THEN
        SourceWasChanged := TRUE
      ELSE BEGIN
        SourceWasChanged := WasModifiedAfterLastSynch(IntegrationTableMapping,SourceRecordRef);
        IF SynchAction <> SynchActionType::ForceModify THEN
          IF SourceWasChanged THEN
            ConflictText :=
              ChangedDestinationConflictsWithSource(IntegrationTableMapping,DestinationRecordRef)
          ELSE
            SynchAction := SynchActionType::IgnoreUnchanged;
      END;

      IF NOT (SynchAction IN [SynchActionType::Insert,SynchActionType::Modify,SynchActionType::ForceModify]) THEN
        EXIT;

      IF SourceWasChanged OR (ConflictText <> '') OR (SynchAction = SynchActionType::ForceModify) THEN
        TransferFields(
          IntegrationRecordSynch,SourceRecordRef,DestinationRecordRef,SynchAction,AdditionalFieldsModified,JobId,ConflictText <> '');

      WasModified := IntegrationRecordSynch.GetWasModified OR AdditionalFieldsModified;
      IF WasModified THEN
        IF ConflictText <> '' THEN BEGIN
          SynchAction := SynchActionType::Fail;
          LogSynchError(
            SourceRecordRef,DestinationRecordRef,
            STRSUBSTNO(ConflictText,SourceRecordRef.CAPTION,DestinationRecordRef.CAPTION),JobId);
          MarkIntegrationRecordAsFailed(IntegrationTableMapping,SourceRecordRef,JobId,IntegrationTableConnectionType);
          EXIT;
        END;
      IF (SynchAction = SynchActionType::Modify) AND (NOT WasModified) THEN
        SynchAction := SynchActionType::IgnoreUnchanged;

      CASE SynchAction OF
        SynchActionType::Insert:
          InsertRecord(
            IntegrationTableMapping,SourceRecordRef,DestinationRecordRef,SynchAction,JobId,IntegrationTableConnectionType);
        SynchActionType::Modify,
        SynchActionType::ForceModify:
          ModifyRecord(
            IntegrationTableMapping,SourceRecordRef,DestinationRecordRef,SynchAction,JobId,IntegrationTableConnectionType);
        SynchActionType::IgnoreUnchanged:
          BEGIN
            UpdateIntegrationRecordCoupling(
              IntegrationTableMapping,SourceRecordRef,DestinationRecordRef,IntegrationTableConnectionType);
            OnAfterUnchangedRecordHandled(IntegrationTableMapping,SourceRecordRef,DestinationRecordRef);
            UpdateIntegrationRecordTimestamp(
              IntegrationTableMapping,SourceRecordRef,DestinationRecordRef,IntegrationTableConnectionType,JobId);
          END;
      END;
    END;

    LOCAL PROCEDURE InsertRecord@13(VAR IntegrationTableMapping@1010 : Record 5335;VAR SourceRecordRef@1009 : RecordRef;VAR DestinationRecordRef@1008 : RecordRef;VAR SynchAction@1000 : Option;JobId@1002 : GUID;IntegrationTableConnectionType@1003 : TableConnectionType);
    VAR
      TextManagement@1001 : Codeunit 41;
    BEGIN
      OnBeforeInsertRecord(IntegrationTableMapping,SourceRecordRef,DestinationRecordRef);
      IF DestinationRecordRef.INSERT(TRUE) THEN BEGIN
        ApplyConfigTemplate(IntegrationTableMapping,SourceRecordRef,DestinationRecordRef,JobId,SynchAction);
        IF SynchAction <> SynchActionType::Fail THEN BEGIN
          UpdateIntegrationRecordCoupling(
            IntegrationTableMapping,SourceRecordRef,DestinationRecordRef,IntegrationTableConnectionType);
          OnAfterInsertRecord(IntegrationTableMapping,SourceRecordRef,DestinationRecordRef);
          UpdateIntegrationRecordTimestamp(
            IntegrationTableMapping,SourceRecordRef,DestinationRecordRef,IntegrationTableConnectionType,JobId);
        END;
      END ELSE BEGIN
        OnErrorWhenInsertingRecord(IntegrationTableMapping,SourceRecordRef,DestinationRecordRef);
        SynchAction := SynchActionType::Fail;
        LogSynchError(
          SourceRecordRef,DestinationRecordRef,
          STRSUBSTNO(InsertFailedErr,DestinationRecordRef.CAPTION,TextManagement.RemoveMessageTrailingDots(GETLASTERRORTEXT)),JobId);
      END;
      COMMIT;
    END;

    LOCAL PROCEDURE ModifyRecord@15(VAR IntegrationTableMapping@1009 : Record 5335;VAR SourceRecordRef@1008 : RecordRef;VAR DestinationRecordRef@1007 : RecordRef;VAR SynchAction@1000 : Option;JobId@1002 : GUID;IntegrationTableConnectionType@1003 : TableConnectionType);
    VAR
      TextManagement@1001 : Codeunit 41;
    BEGIN
      OnBeforeModifyRecord(IntegrationTableMapping,SourceRecordRef,DestinationRecordRef);

      IF DestinationRecordRef.MODIFY(TRUE) THEN BEGIN
        UpdateIntegrationRecordCoupling(
          IntegrationTableMapping,SourceRecordRef,DestinationRecordRef,IntegrationTableConnectionType);
        OnAfterModifyRecord(IntegrationTableMapping,SourceRecordRef,DestinationRecordRef);
        UpdateIntegrationRecordTimestamp(
          IntegrationTableMapping,SourceRecordRef,DestinationRecordRef,IntegrationTableConnectionType,JobId);
      END ELSE BEGIN
        OnErrorWhenModifyingRecord(IntegrationTableMapping,SourceRecordRef,DestinationRecordRef);
        SynchAction := SynchActionType::Fail;
        LogSynchError(
          SourceRecordRef,DestinationRecordRef,
          STRSUBSTNO(ModifyFailedErr,DestinationRecordRef.CAPTION,TextManagement.RemoveMessageTrailingDots(GETLASTERRORTEXT)),JobId);
        MarkIntegrationRecordAsFailed(IntegrationTableMapping,SourceRecordRef,JobId,IntegrationTableConnectionType);
      END;
      COMMIT;
    END;

    LOCAL PROCEDURE ApplyConfigTemplate@6(VAR IntegrationTableMapping@1004 : Record 5335;VAR SourceRecordRef@1005 : RecordRef;VAR DestinationRecordRef@1000 : RecordRef;JobId@1006 : GUID;VAR SynchAction@1007 : Option);
    VAR
      ConfigTemplateHeader@1002 : Record 8618;
      ConfigTemplateManagement@1003 : Codeunit 8612;
      ConfigTemplateCode@1001 : Code[10];
    BEGIN
      IF DestinationRecordRef.NUMBER = IntegrationTableMapping."Integration Table ID" THEN
        ConfigTemplateCode := IntegrationTableMapping."Int. Tbl. Config Template Code"
      ELSE
        ConfigTemplateCode := IntegrationTableMapping."Table Config Template Code";
      IF ConfigTemplateCode <> '' THEN BEGIN
        OnBeforeApplyRecordTemplate(IntegrationTableMapping,SourceRecordRef,DestinationRecordRef,ConfigTemplateCode);

        IF ConfigTemplateHeader.GET(ConfigTemplateCode) THEN BEGIN
          ConfigTemplateManagement.UpdateRecord(ConfigTemplateHeader,DestinationRecordRef);

          OnAfterApplyRecordTemplate(IntegrationTableMapping,SourceRecordRef,DestinationRecordRef);
        END ELSE BEGIN
          SynchAction := SynchActionType::Fail;
          LogSynchError(
            SourceRecordRef,DestinationRecordRef,
            STRSUBSTNO(ConfigurationTemplateNotFoundErr,ConfigTemplateHeader.TABLECAPTION,ConfigTemplateCode),JobId);
        END;
      END;
    END;

    LOCAL PROCEDURE ChangedDestinationConflictsWithSource@1(IntegrationTableMapping@1002 : Record 5335;DestinationRecordRef@1001 : RecordRef) ConflictText : Text;
    BEGIN
      IF IntegrationTableMapping.GetDirection = IntegrationTableMapping.Direction::Bidirectional THEN
        IF WasModifiedAfterLastSynch(IntegrationTableMapping,DestinationRecordRef) THEN
          ConflictText := BothDestinationAndSourceIsNewerErr
    END;

    LOCAL PROCEDURE GetCoupledRecord@17(VAR IntegrationTableMapping@1002 : Record 5335;VAR RecordRef@1001 : RecordRef;VAR CoupledRecordRef@1000 : RecordRef;VAR SynchAction@1003 : Option;JobId@1005 : GUID;IntegrationTableConnectionType@1006 : TableConnectionType) : Integer;
    VAR
      IsDestinationMarkedAsDeleted@1004 : Boolean;
      RecordState@1007 : 'NotFound,Coupled,Decoupled';
    BEGIN
      IsDestinationMarkedAsDeleted := FALSE;
      RecordState :=
        FindRecord(
          IntegrationTableMapping,RecordRef,CoupledRecordRef,IsDestinationMarkedAsDeleted,IntegrationTableConnectionType);

      IF RecordState <> RecordState::NotFound THEN
        IF IsDestinationMarkedAsDeleted THEN BEGIN
          RecordState := RecordState::NotFound;
          SynchAction := SynchActionType::Fail;
          LogSynchError(RecordRef,CoupledRecordRef,STRSUBSTNO(CoupledRecordIsDeletedErr,RecordRef.CAPTION),JobId);
        END ELSE BEGIN
          IF RecordState = RecordState::Decoupled THEN
            SynchAction := SynchActionType::ForceModify;
          IF SynchAction <> SynchActionType::ForceModify THEN
            SynchAction := SynchActionType::Modify;
        END;
      EXIT(RecordState);
    END;

    LOCAL PROCEDURE FindRecord@26(VAR IntegrationTableMapping@1003 : Record 5335;VAR SourceRecordRef@1002 : RecordRef;VAR DestinationRecordRef@1001 : RecordRef;VAR IsDestinationDeleted@1000 : Boolean;IntegrationTableConnectionType@1007 : TableConnectionType) : Integer;
    VAR
      IntegrationRecordManagement@1004 : Codeunit 5338;
      IDFieldRef@1006 : FieldRef;
      RecordIDValue@1005 : RecordID;
      RecordState@1008 : 'NotFound,Coupled,Decoupled';
      RecordFound@1009 : Boolean;
    BEGIN
      IF SourceRecordRef.NUMBER = IntegrationTableMapping."Table ID" THEN // NAV -> Integration Table synch
        RecordFound :=
          FindIntegrationTableRecord(
            IntegrationTableMapping,SourceRecordRef,DestinationRecordRef,IsDestinationDeleted,IntegrationTableConnectionType)
      ELSE BEGIN  // Integration Table -> NAV synch
        IDFieldRef := SourceRecordRef.FIELD(IntegrationTableMapping."Integration Table UID Fld. No.");
        RecordFound :=
          IntegrationRecordManagement.FindRecordIdByIntegrationTableUid(
            IntegrationTableConnectionType,IDFieldRef.VALUE,IntegrationTableMapping."Table ID",RecordIDValue);
        IF RecordFound THEN
          IsDestinationDeleted := NOT DestinationRecordRef.GET(RecordIDValue);
      END;
      IF RecordFound THEN
        EXIT(RecordState::Coupled);

      // If no explicit coupling is found, attempt to find a match based on user data
      IF FindAndCoupleDestinationRecord(
           IntegrationTableMapping,SourceRecordRef,DestinationRecordRef,IsDestinationDeleted,IntegrationTableConnectionType)
      THEN
        EXIT(RecordState::Decoupled);
      EXIT(RecordState::NotFound);
    END;

    LOCAL PROCEDURE FindAndCoupleDestinationRecord@43(IntegrationTableMapping@1004 : Record 5335;SourceRecordRef@1003 : RecordRef;VAR DestinationRecordRef@1002 : RecordRef;VAR DestinationIsDeleted@1001 : Boolean;IntegrationTableConnectionType@1005 : TableConnectionType) DestinationFound : Boolean;
    BEGIN
      OnFindUncoupledDestinationRecord(
        IntegrationTableMapping,SourceRecordRef,DestinationRecordRef,DestinationIsDeleted,DestinationFound);
      IF DestinationFound THEN BEGIN
        UpdateIntegrationRecordCoupling(
          IntegrationTableMapping,SourceRecordRef,DestinationRecordRef,IntegrationTableConnectionType);
        UpdateIntegrationRecordTimestamp(
          IntegrationTableMapping,SourceRecordRef,DestinationRecordRef,IntegrationTableConnectionType,JobIdContext);
      END;
    END;

    LOCAL PROCEDURE FindIntegrationTableRecord@25(IntegrationTableMapping@1003 : Record 5335;VAR SourceRecordRef@1002 : RecordRef;VAR DestinationRecordRef@1001 : RecordRef;VAR IsDestinationDeleted@1000 : Boolean;IntegrationTableConnectionType@1005 : TableConnectionType) FoundDestination : Boolean;
    VAR
      IntegrationRecordManagement@1004 : Codeunit 5338;
      IDValue@1006 : Variant;
    BEGIN
      FoundDestination :=
        IntegrationRecordManagement.FindIntegrationTableUIdByRecordId(IntegrationTableConnectionType,SourceRecordRef.RECORDID,IDValue);

      IF FoundDestination THEN
        IsDestinationDeleted := NOT IntegrationTableMapping.GetRecordRef(IDValue,DestinationRecordRef);
    END;

    LOCAL PROCEDURE PrepareNewDestination@44(VAR IntegrationTableMapping@1003 : Record 5335;VAR RecordRef@1002 : RecordRef;VAR CoupledRecordRef@1001 : RecordRef);
    BEGIN
      CoupledRecordRef.CLOSE;

      IF RecordRef.NUMBER = IntegrationTableMapping."Table ID" THEN
        CoupledRecordRef.OPEN(IntegrationTableMapping."Integration Table ID")
      ELSE
        CoupledRecordRef.OPEN(IntegrationTableMapping."Table ID");

      CoupledRecordRef.INIT;
    END;

    LOCAL PROCEDURE LogSynchError@30(VAR SourceRecordRef@1000 : RecordRef;VAR DestinationRecordRef@1001 : RecordRef;ErrorMessage@1002 : Text;JobId@1005 : GUID);
    VAR
      IntegrationSynchJobErrors@1003 : Record 5339;
      EmptyRecordID@1004 : RecordID;
    BEGIN
      IF DestinationRecordRef.NUMBER = 0 THEN BEGIN
        EmptyRecordID := SourceRecordRef.RECORDID;
        CLEAR(EmptyRecordID);
        IntegrationSynchJobErrors.LogSynchError(JobId,SourceRecordRef.RECORDID,EmptyRecordID,ErrorMessage)
      END ELSE BEGIN
        IntegrationSynchJobErrors.LogSynchError(JobId,SourceRecordRef.RECORDID,DestinationRecordRef.RECORDID,ErrorMessage);

        // Close destination - it is in error state and can no longer be used.
        DestinationRecordRef.CLOSE;
      END;
    END;

    LOCAL PROCEDURE TransferFields@16(VAR IntegrationRecordSynch@1003 : Codeunit 5336;VAR SourceRecordRef@1000 : RecordRef;VAR DestinationRecordRef@1001 : RecordRef;VAR SynchAction@1002 : Option;VAR AdditionalFieldsModified@1006 : Boolean;JobId@1005 : GUID;ConflictFound@1007 : Boolean);
    VAR
      TextManagement@1004 : Codeunit 41;
    BEGIN
      OnBeforeTransferRecordFields(SourceRecordRef,DestinationRecordRef);

      IntegrationRecordSynch.SetParameters(SourceRecordRef,DestinationRecordRef,SynchAction <> SynchActionType::Insert);
      IF IntegrationRecordSynch.RUN THEN BEGIN
        IF ConflictFound AND IntegrationRecordSynch.GetWasModified THEN
          EXIT;
        OnAfterTransferRecordFields(SourceRecordRef,DestinationRecordRef,
          AdditionalFieldsModified,SynchAction <> SynchActionType::Insert);
        AdditionalFieldsModified := AdditionalFieldsModified OR IntegrationRecordSynch.GetWasModified;
      END ELSE BEGIN
        SynchAction := SynchActionType::Fail;
        LogSynchError(
          SourceRecordRef,DestinationRecordRef,
          STRSUBSTNO(CopyDataErr,TextManagement.RemoveMessageTrailingDots(GETLASTERRORTEXT)),JobId);
        COMMIT;
      END;
    END;

    PROCEDURE MarkIntegrationRecordAsFailed@8(IntegrationTableMapping@1003 : Record 5335;SourceRecordRef@1002 : RecordRef;JobId@1000 : GUID;IntegrationTableConnectionType@1006 : TableConnectionType);
    VAR
      IntegrationManagement@1004 : Codeunit 5150;
      IntegrationRecordManagement@1005 : Codeunit 5338;
      DirectionToIntTable@1007 : Boolean;
    BEGIN
      IF IntegrationManagement.IsIntegrationRecordChild(IntegrationTableMapping."Table ID") THEN
        EXIT;
      DirectionToIntTable := IntegrationTableMapping.Direction = IntegrationTableMapping.Direction::ToIntegrationTable;
      IntegrationRecordManagement.MarkLastSynchAsFailure(IntegrationTableConnectionType,SourceRecordRef,DirectionToIntTable,JobId);
    END;

    LOCAL PROCEDURE UpdateIntegrationRecordCoupling@24(IntegrationTableMapping@1006 : Record 5335;SourceRecordRef@1000 : RecordRef;DestinationRecordRef@1001 : RecordRef;IntegrationTableConnectionType@1008 : TableConnectionType);
    VAR
      IntegrationRecordManagement@1002 : Codeunit 5338;
      IntegrationManagement@1007 : Codeunit 5150;
      IntegrationTableUidFieldRef@1005 : FieldRef;
      IntegrationTableUid@1004 : Variant;
    BEGIN
      IF IntegrationManagement.IsIntegrationRecordChild(IntegrationTableMapping."Table ID") THEN
        EXIT;

      ArrangeRecordRefs(SourceRecordRef,DestinationRecordRef,IntegrationTableMapping."Table ID");
      IntegrationTableUidFieldRef := DestinationRecordRef.FIELD(IntegrationTableMapping."Integration Table UID Fld. No.");
      IntegrationTableUid := IntegrationTableUidFieldRef.VALUE;

      IntegrationRecordManagement.UpdateIntegrationTableCoupling(
        IntegrationTableConnectionType,IntegrationTableUid,SourceRecordRef.RECORDID);
    END;

    LOCAL PROCEDURE UpdateIntegrationRecordTimestamp@14(IntegrationTableMapping@1006 : Record 5335;SourceRecordRef@1000 : RecordRef;DestinationRecordRef@1001 : RecordRef;IntegrationTableConnectionType@1008 : TableConnectionType;JobID@1011 : GUID);
    VAR
      IntegrationRecordManagement@1002 : Codeunit 5338;
      IntegrationManagement@1007 : Codeunit 5150;
      IntegrationTableUidFieldRef@1004 : FieldRef;
      IntegrationTableUid@1003 : Variant;
      IntegrationTableModifiedOn@1009 : DateTime;
      ModifiedOn@1010 : DateTime;
    BEGIN
      IF IntegrationManagement.IsIntegrationRecordChild(IntegrationTableMapping."Table ID") THEN
        EXIT;

      ArrangeRecordRefs(SourceRecordRef,DestinationRecordRef,IntegrationTableMapping."Table ID");
      IntegrationTableUidFieldRef := DestinationRecordRef.FIELD(IntegrationTableMapping."Integration Table UID Fld. No.");
      IntegrationTableUid := IntegrationTableUidFieldRef.VALUE;
      IntegrationTableModifiedOn := GetRowLastModifiedOn(IntegrationTableMapping,DestinationRecordRef);
      ModifiedOn := GetRowLastModifiedOn(IntegrationTableMapping,SourceRecordRef);

      IntegrationRecordManagement.UpdateIntegrationTableTimestamp(
        IntegrationTableConnectionType,IntegrationTableUid,IntegrationTableModifiedOn,
        SourceRecordRef.NUMBER,ModifiedOn,JobID,IntegrationTableMapping.Direction);
      COMMIT;
    END;

    LOCAL PROCEDURE ArrangeRecordRefs@19(VAR SourceRecordRef@1001 : RecordRef;VAR DestinationRecordRef@1000 : RecordRef;TableID@1002 : Integer);
    VAR
      RecordRef@1003 : RecordRef;
    BEGIN
      IF SourceRecordRef.NUMBER <> TableID THEN BEGIN
        RecordRef := SourceRecordRef;
        SourceRecordRef := DestinationRecordRef;
        DestinationRecordRef := RecordRef;
      END;
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnBeforeTransferRecordFields@10(SourceRecordRef@1001 : RecordRef;VAR DestinationRecordRef@1002 : RecordRef);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnAfterTransferRecordFields@21(VAR SourceRecordRef@1002 : RecordRef;VAR DestinationRecordRef@1001 : RecordRef;VAR AdditionalFieldsWereModified@1000 : Boolean;DestinationIsInserted@1003 : Boolean);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnBeforeModifyRecord@27(IntegrationTableMapping@1003 : Record 5335;SourceRecordRef@1002 : RecordRef;VAR DestinationRecordRef@1001 : RecordRef);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnAfterModifyRecord@28(IntegrationTableMapping@1003 : Record 5335;VAR SourceRecordRef@1002 : RecordRef;VAR DestinationRecordRef@1001 : RecordRef);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnErrorWhenModifyingRecord@12(IntegrationTableMapping@1002 : Record 5335;VAR SourceRecordRef@1001 : RecordRef;VAR DestinationRecordRef@1000 : RecordRef);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnBeforeInsertRecord@29(IntegrationTableMapping@1003 : Record 5335;SourceRecordRef@1002 : RecordRef;VAR DestinationRecordRef@1001 : RecordRef);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnAfterInsertRecord@31(IntegrationTableMapping@1003 : Record 5335;VAR SourceRecordRef@1002 : RecordRef;VAR DestinationRecordRef@1001 : RecordRef);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnErrorWhenInsertingRecord@11(IntegrationTableMapping@1002 : Record 5335;VAR SourceRecordRef@1001 : RecordRef;VAR DestinationRecordRef@1000 : RecordRef);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterUnchangedRecordHandled@7(IntegrationTableMapping@1002 : Record 5335;SourceRecordRef@1001 : RecordRef;DestinationRecordRef@1000 : RecordRef);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnBeforeApplyRecordTemplate@32(IntegrationTableMapping@1003 : Record 5335;SourceRecordRef@1002 : RecordRef;VAR DestinationRecordRef@1001 : RecordRef;VAR TemplateCode@1000 : Code[10]);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnAfterApplyRecordTemplate@33(IntegrationTableMapping@1003 : Record 5335;SourceRecordRef@1002 : RecordRef;VAR DestinationRecordRef@1001 : RecordRef);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnFindUncoupledDestinationRecord@20(IntegrationTableMapping@1000 : Record 5335;SourceRecordRef@1001 : RecordRef;VAR DestinationRecordRef@1002 : RecordRef;VAR DestinationIsDeleted@1003 : Boolean;VAR DestinationFound@1004 : Boolean);
    BEGIN
    END;

    BEGIN
    END.
  }
}

