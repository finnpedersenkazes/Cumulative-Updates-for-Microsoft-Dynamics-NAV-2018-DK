OBJECT Table 1797 Data Migration Error
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Dataoverf�rselsfejl;
               ENU=Data Migration Error];
  }
  FIELDS
  {
    { 1   ;   ;Id                  ;Integer       ;AutoIncrement=Yes;
                                                   CaptionML=[DAN=Id;
                                                              ENU=Id] }
    { 2   ;   ;Migration Type      ;Text250       ;CaptionML=[DAN=Overf�rselstype;
                                                              ENU=Migration Type] }
    { 3   ;   ;Destination Table ID;Integer       ;CaptionML=[DAN=Destinationstabel-id;
                                                              ENU=Destination Table ID] }
    { 4   ;   ;Source Staging Table Record ID;RecordID;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Record-id for kildens stadieinddelingstabel;
                                                              ENU=Source Staging Table Record ID] }
    { 5   ;   ;Error Message       ;Text250       ;CaptionML=[DAN=Fejlmeddelelse;
                                                              ENU=Error Message] }
    { 6   ;   ;Scheduled For Retry ;Boolean       ;CaptionML=[DAN=Planlagt til nyt fors�g;
                                                              ENU=Scheduled For Retry] }
  }
  KEYS
  {
    {    ;Id                                      ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    [External]
    PROCEDURE CreateEntryWithMessage@8(MigrationType@1000 : Text[250];DestinationTableId@1001 : Integer;SourceStagingTableRecordId@1002 : RecordID;ErrorMessage@1004 : Text[250]);
    VAR
      DataMigrationError@1003 : Record 1797;
    BEGIN
      INIT;
      IF DataMigrationError.FINDLAST THEN
        Id := DataMigrationError.Id + 1
      ELSE
        Id := 1;
      VALIDATE("Migration Type",MigrationType);
      VALIDATE("Destination Table ID",DestinationTableId);
      VALIDATE("Source Staging Table Record ID",SourceStagingTableRecordId);
      VALIDATE("Error Message",ErrorMessage);
      VALIDATE("Scheduled For Retry",FALSE);
      INSERT(TRUE);

      OnAfterErrorInserted(MigrationType,ErrorMessage);
    END;

    [External]
    PROCEDURE CreateEntry@1(MigrationType@1000 : Text[250];DestinationTableId@1001 : Integer;SourceStagingTableRecordId@1002 : RecordID);
    BEGIN
      CreateEntryWithMessage(MigrationType,DestinationTableId,SourceStagingTableRecordId,COPYSTR(GETLASTERRORTEXT,1,250));
    END;

    [External]
    PROCEDURE CreateEntryNoStagingTable@5(MigrationType@1000 : Text[250];DestinationTableId@1001 : Integer);
    VAR
      DummyRecordId@1002 : RecordID;
    BEGIN
      CreateEntry(MigrationType,DestinationTableId,DummyRecordId);
    END;

    [External]
    PROCEDURE CreateEntryNoStagingTableWithMessage@6(MigrationType@1000 : Text[250];DestinationTableId@1001 : Integer;ErrorMessage@1003 : Text[250]);
    VAR
      DummyRecordId@1002 : RecordID;
    BEGIN
      CreateEntryWithMessage(MigrationType,DestinationTableId,DummyRecordId,ErrorMessage);
    END;

    [External]
    PROCEDURE ClearEntry@2(MigrationType@1002 : Text[250];DestinationTableId@1001 : Integer;SourceStagingTableRecordId@1000 : RecordID);
    BEGIN
      IF FindEntry(MigrationType,DestinationTableId,SourceStagingTableRecordId) THEN
        DELETE(TRUE);
    END;

    [External]
    PROCEDURE ClearEntryNoStagingTable@7(MigrationType@1002 : Text[250];DestinationTableId@1001 : Integer);
    VAR
      DummyRecordId@1000 : RecordID;
    BEGIN
      ClearEntry(MigrationType,DestinationTableId,DummyRecordId);
    END;

    [External]
    PROCEDURE FindEntry@4(MigrationType@1002 : Text[250];DestinationTableId@1001 : Integer;SourceStagingTableRecordId@1000 : RecordID) : Boolean;
    BEGIN
      SETRANGE("Migration Type",MigrationType);
      SETRANGE("Destination Table ID",DestinationTableId);
      SETRANGE("Source Staging Table Record ID",SourceStagingTableRecordId);
      EXIT(FINDFIRST);
    END;

    [External]
    PROCEDURE Ignore@3();
    VAR
      DataMigrationStatusFacade@1000 : Codeunit 6101;
      RecordRef@1001 : RecordRef;
    BEGIN
      RecordRef.GET("Source Staging Table Record ID");
      RecordRef.DELETE(TRUE);
      DELETE(TRUE);
      DataMigrationStatusFacade.IgnoreErrors("Migration Type","Destination Table ID",1);
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterErrorInserted@9(MigrationType@1000 : Text;ErrorMessage@1001 : Text);
    BEGIN
    END;

    BEGIN
    END.
  }
}

