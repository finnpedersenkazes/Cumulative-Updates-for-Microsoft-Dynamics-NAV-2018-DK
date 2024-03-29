OBJECT Codeunit 5338 Integration Record Management
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
          END;

  }
  CODE
  {
    VAR
      UnsupportedTableConnectionTypeErr@1001 : TextConst 'DAN=%1 er ikke en underst�ttet tabelforbindelsestype.;ENU=%1 is not a supported table connection type.';

    [External]
    PROCEDURE FindRecordIdByIntegrationTableUid@21(IntegrationTableConnectionType@1002 : TableConnectionType;IntegrationTableUid@1000 : Variant;DestinationTableId@1005 : Integer;VAR DestinationRecordId@1004 : RecordID) : Boolean;
    VAR
      CRMIntegrationRecord@1003 : Record 5331;
      ExtTxtIDIntegrationRecord@1006 : Record 5377;
      GraphIntegrationRecord@1001 : Record 5451;
    BEGIN
      CASE IntegrationTableConnectionType OF
        TABLECONNECTIONTYPE::CRM:
          EXIT(CRMIntegrationRecord.FindRecordIDFromID(IntegrationTableUid,DestinationTableId,DestinationRecordId));
        TABLECONNECTIONTYPE::MicrosoftGraph:
          EXIT(GraphIntegrationRecord.FindRecordIDFromID(IntegrationTableUid,DestinationTableId,DestinationRecordId));
        TABLECONNECTIONTYPE::ExternalSQL:
          EXIT(ExtTxtIDIntegrationRecord.FindRecordIDFromID(IntegrationTableUid,DestinationTableId,DestinationRecordId));
        ELSE
          ERROR(UnsupportedTableConnectionTypeErr,FORMAT(IntegrationTableConnectionType));
      END;
    END;

    [External]
    PROCEDURE FindIntegrationTableUIdByRecordId@29(IntegrationTableConnectionType@1002 : TableConnectionType;SourceRecordId@1000 : RecordID;VAR IntegrationTableUid@1003 : Variant) : Boolean;
    VAR
      CRMIntegrationRecord@1004 : Record 5331;
      GraphIntegrationRecord@1001 : Record 5451;
      ExtTxtIDIntegrationRecord@1005 : Record 5377;
    BEGIN
      CASE IntegrationTableConnectionType OF
        TABLECONNECTIONTYPE::CRM:
          EXIT(CRMIntegrationRecord.FindIDFromRecordID(SourceRecordId,IntegrationTableUid));
        TABLECONNECTIONTYPE::MicrosoftGraph:
          EXIT(GraphIntegrationRecord.FindIDFromRecordID(SourceRecordId,IntegrationTableUid));
        TABLECONNECTIONTYPE::ExternalSQL:
          EXIT(ExtTxtIDIntegrationRecord.FindIDFromRecordID(SourceRecordId,IntegrationTableUid));
        ELSE
          ERROR(UnsupportedTableConnectionTypeErr,FORMAT(IntegrationTableConnectionType));
      END;
    END;

    [External]
    PROCEDURE MarkLastSynchAsFailure@1(IntegrationTableConnectionType@1000 : TableConnectionType;SourceRecRef@1003 : RecordRef;DirectionToIntTable@1005 : Boolean;JobID@1002 : GUID);
    VAR
      CRMIntegrationRecord@1001 : Record 5331;
    BEGIN
      CASE IntegrationTableConnectionType OF
        TABLECONNECTIONTYPE::CRM:
          CRMIntegrationRecord.SetLastSynchResultFailed(SourceRecRef,DirectionToIntTable,JobID);
        TABLECONNECTIONTYPE::MicrosoftGraph,
        TABLECONNECTIONTYPE::ExternalSQL:
          ;
        ELSE
          ERROR(UnsupportedTableConnectionTypeErr,FORMAT(IntegrationTableConnectionType));
      END;
    END;

    [External]
    PROCEDURE UpdateIntegrationTableCoupling@30(IntegrationTableConnectionType@1002 : TableConnectionType;IntegrationTableUid@1000 : Variant;RecordId@1003 : RecordID);
    VAR
      CRMIntegrationRecord@1004 : Record 5331;
      ExtTxtIDIntegrationRecord@1007 : Record 5377;
      GraphIntegrationRecord@1001 : Record 5451;
    BEGIN
      CASE IntegrationTableConnectionType OF
        TABLECONNECTIONTYPE::CRM:
          CRMIntegrationRecord.CoupleCRMIDToRecordID(IntegrationTableUid,RecordId);
        TABLECONNECTIONTYPE::MicrosoftGraph:
          GraphIntegrationRecord.CoupleGraphIDToRecordID(IntegrationTableUid,RecordId);
        TABLECONNECTIONTYPE::ExternalSQL:
          ExtTxtIDIntegrationRecord.CoupleExternalIDToRecordID(IntegrationTableUid,RecordId);
        ELSE
          ERROR(UnsupportedTableConnectionTypeErr,FORMAT(IntegrationTableConnectionType));
      END;
    END;

    [External]
    PROCEDURE UpdateIntegrationTableTimestamp@3(IntegrationTableConnectionType@1002 : TableConnectionType;IntegrationTableUid@1000 : Variant;IntegrationTableModfiedOn@1005 : DateTime;TableID@1003 : Integer;ModifiedOn@1006 : DateTime;JobID@1008 : GUID;Direction@1009 : Option);
    VAR
      CRMIntegrationRecord@1004 : Record 5331;
      ExtTxtIDIntegrationRecord@1007 : Record 5377;
      GraphIntegrationRecord@1001 : Record 5451;
    BEGIN
      CASE IntegrationTableConnectionType OF
        TABLECONNECTIONTYPE::CRM:
          CRMIntegrationRecord.SetLastSynchModifiedOns(
            IntegrationTableUid,TableID,IntegrationTableModfiedOn,ModifiedOn,JobID,Direction);
        TABLECONNECTIONTYPE::MicrosoftGraph:
          GraphIntegrationRecord.SetLastSynchModifiedOns(IntegrationTableUid,TableID,IntegrationTableModfiedOn,ModifiedOn);
        TABLECONNECTIONTYPE::ExternalSQL:
          ExtTxtIDIntegrationRecord.SetLastSynchModifiedOns(
            IntegrationTableUid,TableID,IntegrationTableModfiedOn,ModifiedOn);
        ELSE
          ERROR(UnsupportedTableConnectionTypeErr,FORMAT(IntegrationTableConnectionType));
      END;
    END;

    [External]
    PROCEDURE IsModifiedAfterIntegrationTableRecordLastSynch@2(IntegrationTableConnectionType@1002 : TableConnectionType;IntegrationTableUid@1000 : Variant;DestinationTableId@1005 : Integer;LastModifiedOn@1003 : DateTime) : Boolean;
    VAR
      CRMIntegrationRecord@1004 : Record 5331;
      ExtTxtIDIntegrationRecord@1007 : Record 5377;
      GraphIntegrationRecord@1001 : Record 5451;
    BEGIN
      CASE IntegrationTableConnectionType OF
        TABLECONNECTIONTYPE::CRM:
          EXIT(CRMIntegrationRecord.IsModifiedAfterLastSynchonizedCRMRecord(IntegrationTableUid,DestinationTableId,LastModifiedOn));
        TABLECONNECTIONTYPE::MicrosoftGraph:
          EXIT(
            GraphIntegrationRecord.IsModifiedAfterLastSynchonizedGraphRecord(IntegrationTableUid,DestinationTableId,LastModifiedOn));
        TABLECONNECTIONTYPE::ExternalSQL:
          EXIT(ExtTxtIDIntegrationRecord.IsModifiedAfterLastSynchonizedExternalRecord(IntegrationTableUid,DestinationTableId,
              LastModifiedOn));
        ELSE
          ERROR(UnsupportedTableConnectionTypeErr,FORMAT(IntegrationTableConnectionType));
      END;
    END;

    [External]
    PROCEDURE IsModifiedAfterRecordLastSynch@5(IntegrationTableConnectionType@1002 : TableConnectionType;SourceRecordID@1000 : RecordID;LastModifiedOn@1003 : DateTime) : Boolean;
    VAR
      CRMIntegrationRecord@1004 : Record 5331;
      GraphIntegrationRecord@1001 : Record 5451;
      ExtTxtIDIntegrationRecord@1005 : Record 5377;
    BEGIN
      CASE IntegrationTableConnectionType OF
        TABLECONNECTIONTYPE::CRM:
          EXIT(CRMIntegrationRecord.IsModifiedAfterLastSynchronizedRecord(SourceRecordID,LastModifiedOn));
        TABLECONNECTIONTYPE::MicrosoftGraph:
          EXIT(GraphIntegrationRecord.IsModifiedAfterLastSynchronizedRecord(SourceRecordID,LastModifiedOn));
        TABLECONNECTIONTYPE::ExternalSQL:
          EXIT(ExtTxtIDIntegrationRecord.IsModifiedAfterLastSynchronizedRecord(SourceRecordID,LastModifiedOn));
        ELSE
          ERROR(UnsupportedTableConnectionTypeErr,FORMAT(IntegrationTableConnectionType));
      END;
    END;

    BEGIN
    END.
  }
}

