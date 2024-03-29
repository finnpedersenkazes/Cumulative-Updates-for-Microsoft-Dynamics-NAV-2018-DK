OBJECT Table 5335 Integration Table Mapping
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    OnDelete=VAR
               CRMOptionMapping@1001 : Record 5334;
               IntegrationFieldMapping@1000 : Record 5336;
             BEGIN
               IntegrationFieldMapping.SETRANGE("Integration Table Mapping Name",Name);
               IntegrationFieldMapping.DELETEALL;

               CRMOptionMapping.SETRANGE("Table ID","Table ID");
               CRMOptionMapping.SETRANGE("Integration Table ID","Integration Table ID");
               CRMOptionMapping.SETRANGE("Integration Field ID","Integration Table UID Fld. No.");
               CRMOptionMapping.DELETEALL;
             END;

    CaptionML=[DAN=Integrationstabelkobling;
               ENU=Integration Table Mapping];
    LookupPageID=Page5335;
    DrillDownPageID=Page5335;
  }
  FIELDS
  {
    { 1   ;   ;Name                ;Code20        ;CaptionML=[DAN=Navn;
                                                              ENU=Name];
                                                   NotBlank=Yes }
    { 2   ;   ;Table ID            ;Integer       ;TableRelation="Table Metadata".ID;
                                                   CaptionML=[DAN=Tabel-id;
                                                              ENU=Table ID] }
    { 3   ;   ;Integration Table ID;Integer       ;TableRelation="Table Metadata".ID;
                                                   CaptionML=[DAN=Integrationstabel-id;
                                                              ENU=Integration Table ID] }
    { 4   ;   ;Synch. Codeunit ID  ;Integer       ;TableRelation="Table Metadata".ID;
                                                   CaptionML=[DAN=Synkr. codeunit-id;
                                                              ENU=Synch. Codeunit ID] }
    { 5   ;   ;Integration Table UID Fld. No.;Integer;
                                                   OnValidate=VAR
                                                                Field@1000 : Record 2000000041;
                                                                TypeHelper@1001 : Codeunit 10;
                                                              BEGIN
                                                                Field.GET("Integration Table ID","Integration Table UID Fld. No.");
                                                                TypeHelper.TestFieldIsNotObsolete(Field);
                                                                "Int. Table UID Field Type" := Field.Type;
                                                              END;

                                                   CaptionML=[DAN=UID-feltnr. for integrationstabel;
                                                              ENU=Integration Table UID Fld. No.];
                                                   Description=Integration Table Unique Identifier Field No. }
    { 6   ;   ;Int. Tbl. Modified On Fld. No.;Integer;
                                                   CaptionML=[DAN=Int.tbl. rettet p� feltnr.;
                                                              ENU=Int. Tbl. Modified On Fld. No.];
                                                   Description=Integration Table Modified On Field No. }
    { 7   ;   ;Int. Table UID Field Type;Integer  ;CaptionML=[DAN=UID-felttype for intern tabel;
                                                              ENU=Int. Table UID Field Type];
                                                   Editable=No }
    { 8   ;   ;Table Config Template Code;Code10  ;TableRelation="Config. Template Header".Code WHERE (Table ID=FIELD(Table ID));
                                                   CaptionML=[DAN=Skabelonkode til tabelkonfiguration;
                                                              ENU=Table Config Template Code] }
    { 9   ;   ;Int. Tbl. Config Template Code;Code10;
                                                   TableRelation="Config. Template Header".Code WHERE (Table ID=FIELD(Integration Table ID));
                                                   CaptionML=[DAN=Skabelonkode til int.tabelkonfiguration;
                                                              ENU=Int. Tbl. Config Template Code] }
    { 10  ;   ;Direction           ;Option        ;CaptionML=[DAN=Retning;
                                                              ENU=Direction];
                                                   OptionCaptionML=[DAN=Begge retninger,TilIntegrationstabel,FraIntegrationstabel;
                                                                    ENU=Bidirectional,ToIntegrationTable,FromIntegrationTable];
                                                   OptionString=Bidirectional,ToIntegrationTable,FromIntegrationTable }
    { 11  ;   ;Int. Tbl. Caption Prefix;Text30    ;CaptionML=[DAN=Int. Tab.tekstpr�fiks;
                                                              ENU=Int. Tbl. Caption Prefix] }
    { 12  ;   ;Synch. Int. Tbl. Mod. On Fltr.;DateTime;
                                                   CaptionML=[DAN=Synkr. Int.tbl. rettet p� feltnr.;
                                                              ENU=Synch. Int. Tbl. Mod. On Fltr.];
                                                   Description=Scheduled synch. Integration Table Modified On Filter }
    { 13  ;   ;Synch. Modified On Filter;DateTime ;CaptionML=[DAN=Synkr. rettet p� filter;
                                                              ENU=Synch. Modified On Filter];
                                                   Description=Scheduled synch. Modified On Filter }
    { 14  ;   ;Table Filter        ;BLOB          ;CaptionML=[DAN=Tabelfilter;
                                                              ENU=Table Filter] }
    { 15  ;   ;Integration Table Filter;BLOB      ;CaptionML=[DAN=Integrationstabelfilter;
                                                              ENU=Integration Table Filter] }
    { 16  ;   ;Synch. Only Coupled Records;Boolean;InitValue=Yes;
                                                   CaptionML=[DAN=Synkr. kun sammenk�dede records;
                                                              ENU=Synch. Only Coupled Records] }
    { 17  ;   ;Parent Name         ;Code20        ;CaptionML=[DAN=Overordnet navn;
                                                              ENU=Parent Name] }
    { 18  ;   ;Graph Delta Token   ;Text250       ;CaptionML=[DAN=Graph-deltatoken;
                                                              ENU=Graph Delta Token] }
    { 19  ;   ;Int. Tbl. Delta Token Fld. No.;Integer;
                                                   CaptionML=[DAN=Int.tbl. deltatoken-feltnr.;
                                                              ENU=Int. Tbl. Delta Token Fld. No.] }
    { 20  ;   ;Int. Tbl. ChangeKey Fld. No.;Integer;
                                                   CaptionML=[DAN=Int.tbl. ChangeKey-feltnr.;
                                                              ENU=Int. Tbl. ChangeKey Fld. No.] }
    { 21  ;   ;Int. Tbl. State Fld. No.;Integer   ;CaptionML=[DAN=Int.tbl. tilstandsfeltnr.;
                                                              ENU=Int. Tbl. State Fld. No.] }
    { 22  ;   ;Delete After Synchronization;Boolean;
                                                   CaptionML=[DAN=Slet efter synkronisering;
                                                              ENU=Delete After Synchronization] }
    { 30  ;   ;Dependency Filter   ;Text250       ;CaptionML=[DAN=Afh�ngighedsfilter;
                                                              ENU=Dependency Filter] }
    { 100 ;   ;Full Sync is Running;Boolean       ;OnValidate=BEGIN
                                                                IF xRec.GET(Name) THEN;
                                                                IF (NOT xRec."Full Sync is Running") AND "Full Sync is Running" THEN BEGIN
                                                                  "Last Full Sync Start DateTime" := CURRENTDATETIME;
                                                                  "Full Sync Session ID" := SESSIONID;
                                                                END;
                                                                IF NOT "Full Sync is Running" THEN
                                                                  "Full Sync Session ID" := 0;
                                                              END;

                                                   CaptionML=[DAN=Fuld synkronisering k�rer;
                                                              ENU=Full Sync is Running];
                                                   Description=This is set to TRUE when FullSync starts, and to FALSE when FullSync completes. }
    { 101 ;   ;Full Sync Session ID;Integer       ;CaptionML=[DAN=Sessions-id for fuld synkronisering;
                                                              ENU=Full Sync Session ID];
                                                   Description=The ID of the session running the FullSync must be 0 if FullSync is not running. }
    { 102 ;   ;Last Full Sync Start DateTime;DateTime;
                                                   CaptionML=[DAN=Seneste dato/klokkesl�t for start af fuld synkronisering;
                                                              ENU=Last Full Sync Start DateTime];
                                                   Description=The starting date and time of the last time FullSync was run. This is used to re-run in case FullSync failed to reset these fields. }
  }
  KEYS
  {
    {    ;Name                                    ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      JobLogEntryNo@1000 : Integer;

    [External]
    PROCEDURE FindMapping@16(TableNo@1001 : Integer;PrimaryKey@1000 : Variant) : Boolean;
    BEGIN
      IF PrimaryKey.ISRECORDID THEN
        EXIT(FindMappingForTable(TableNo));
      IF PrimaryKey.ISGUID THEN
        EXIT(FindMappingForIntegrationTable(TableNo));
    END;

    LOCAL PROCEDURE FindMappingForIntegrationTable@13(TableId@1000 : Integer) : Boolean;
    BEGIN
      SETRANGE("Integration Table ID",TableId);
      EXIT(FINDFIRST);
    END;

    [External]
    PROCEDURE FindMappingForTable@12(TableId@1000 : Integer) : Boolean;
    BEGIN
      SETRANGE("Table ID",TableId);
      EXIT(FINDFIRST);
    END;

    PROCEDURE IsFullSynch@27() : Boolean;
    BEGIN
      EXIT("Full Sync is Running" AND "Delete After Synchronization");
    END;

    [External]
    PROCEDURE GetName@22() Result : Code[20];
    BEGIN
      IF "Delete After Synchronization" THEN
        Result := "Parent Name";
      IF Result = '' THEN
        Result := Name;
    END;

    [External]
    PROCEDURE GetDirection@23() : Integer;
    VAR
      IntegrationTableMapping@1000 : Record 5335;
    BEGIN
      IntegrationTableMapping.GET(GetName);
      EXIT(IntegrationTableMapping.Direction);
    END;

    PROCEDURE GetJobLogEntryNo@26() : Integer;
    BEGIN
      EXIT(JobLogEntryNo)
    END;

    [External]
    PROCEDURE GetTempDescription@20() : Text;
    VAR
      Separator@1000 : Text;
    BEGIN
      CASE Direction OF
        Direction::Bidirectional:
          Separator := '<->';
        Direction::ToIntegrationTable:
          Separator := '->';
        Direction::FromIntegrationTable:
          Separator := '<-';
      END;
      EXIT(
        STRSUBSTNO(
          '%1 %2 %3',GetTableCaption("Table ID"),Separator,GetTableCaption("Integration Table ID")));
    END;

    [External]
    PROCEDURE GetExtendedIntegrationTableCaption@1() : Text;
    VAR
      TableCaption@1001 : Text;
    BEGIN
      TableCaption := GetTableCaption("Integration Table ID");
      IF TableCaption <> '' THEN
        IF "Int. Tbl. Caption Prefix" <> '' THEN
          EXIT(STRSUBSTNO('%1 %2',"Int. Tbl. Caption Prefix",TableCaption));
      EXIT(TableCaption);
    END;

    LOCAL PROCEDURE GetTableCaption@21(ID@1000 : Integer) : Text;
    VAR
      TableMetadata@1001 : Record 2000000136;
    BEGIN
      IF TableMetadata.GET(ID) THEN
        EXIT(TableMetadata.Caption);
      EXIT('');
    END;

    [External]
    PROCEDURE SetTableFilter@5(Filter@1000 : Text);
    VAR
      OutStream@1001 : OutStream;
    BEGIN
      "Table Filter".CREATEOUTSTREAM(OutStream);
      OutStream.WRITE(Filter);
    END;

    [External]
    PROCEDURE GetTableFilter@6() Value : Text;
    VAR
      InStream@1000 : InStream;
    BEGIN
      CALCFIELDS("Table Filter");
      "Table Filter".CREATEINSTREAM(InStream);
      InStream.READ(Value);
    END;

    [External]
    PROCEDURE SetIntegrationTableFilter@7(Filter@1000 : Text);
    VAR
      OutStream@1001 : OutStream;
    BEGIN
      "Integration Table Filter".CREATEOUTSTREAM(OutStream);
      OutStream.WRITE(Filter);
    END;

    [External]
    PROCEDURE GetIntegrationTableFilter@8() Value : Text;
    VAR
      InStream@1000 : InStream;
    BEGIN
      CALCFIELDS("Integration Table Filter");
      "Integration Table Filter".CREATEINSTREAM(InStream);
      InStream.READ(Value);
    END;

    [External]
    PROCEDURE SetIntTableModifiedOn@4(ModifiedOn@1000 : DateTime);
    BEGIN
      IF (ModifiedOn <> 0DT) AND (ModifiedOn > "Synch. Int. Tbl. Mod. On Fltr.") THEN BEGIN
        "Synch. Int. Tbl. Mod. On Fltr." := ModifiedOn;
        MODIFY(TRUE);
      END;
    END;

    [External]
    PROCEDURE SetTableModifiedOn@9(ModifiedOn@1000 : DateTime);
    BEGIN
      IF (ModifiedOn <> 0DT) AND (ModifiedOn > "Synch. Modified On Filter") THEN BEGIN
        "Synch. Modified On Filter" := ModifiedOn;
        MODIFY(TRUE);
      END;
    END;

    PROCEDURE SetJobLogEntryNo@25(NewJobLogEntryNo@1000 : Integer);
    BEGIN
      JobLogEntryNo := NewJobLogEntryNo;
    END;

    PROCEDURE ShowLog@24(JobIDFilter@1001 : Text);
    VAR
      IntegrationSynchJob@1000 : Record 5338;
    BEGIN
      IF Name = '' THEN
        EXIT;

      IntegrationSynchJob.SETCURRENTKEY("Start Date/Time",ID);
      IntegrationSynchJob.ASCENDING := FALSE;
      IntegrationSynchJob.FILTERGROUP(2);
      IntegrationSynchJob.SETRANGE("Integration Table Mapping Name",Name);
      IntegrationSynchJob.FILTERGROUP(0);
      IF JobIDFilter <> '' THEN
        IntegrationSynchJob.SETFILTER(ID,JobIDFilter);
      IF IntegrationSynchJob.FINDFIRST THEN;
      PAGE.RUN(PAGE::"Integration Synch. Job List",IntegrationSynchJob);
    END;

    [External]
    PROCEDURE SynchronizeNow@2(ResetLastSynchModifiedOnDateTime@1000 : Boolean);
    BEGIN
      IF ResetLastSynchModifiedOnDateTime THEN BEGIN
        CLEAR("Synch. Modified On Filter");
        CLEAR("Synch. Int. Tbl. Mod. On Fltr.");
        MODIFY;
        COMMIT;
      END;
      CODEUNIT.RUN("Synch. Codeunit ID",Rec);
    END;

    [External]
    PROCEDURE GetRecordRef@3(ID@1000 : Variant;VAR IntegrationRecordRef@1001 : RecordRef) : Boolean;
    VAR
      IDFieldRef@1002 : FieldRef;
      RecordID@1003 : RecordID;
      TextKey@1004 : Text;
    BEGIN
      IntegrationRecordRef.CLOSE;
      IF ID.ISGUID THEN BEGIN
        IntegrationRecordRef.OPEN("Integration Table ID");
        IDFieldRef := IntegrationRecordRef.FIELD("Integration Table UID Fld. No.");
        IDFieldRef.SETFILTER(ID);
        EXIT(IntegrationRecordRef.FINDFIRST);
      END;

      IF ID.ISRECORDID THEN BEGIN
        RecordID := ID;
        IF RecordID.TABLENO = "Table ID" THEN
          EXIT(IntegrationRecordRef.GET(ID));
      END;

      IF ID.ISTEXT THEN BEGIN
        IntegrationRecordRef.OPEN("Integration Table ID");
        IDFieldRef := IntegrationRecordRef.FIELD("Integration Table UID Fld. No.");
        TextKey := ID;
        IDFieldRef.SETFILTER('%1',TextKey);
        EXIT(IntegrationRecordRef.FINDFIRST);
      END;
    END;

    [External]
    PROCEDURE SetIntRecordRefFilter@10(VAR IntRecordRef@1000 : RecordRef);
    VAR
      ModifiedOnFieldRef@1003 : FieldRef;
      TableFilter@1001 : Text;
    BEGIN
      TableFilter := GetIntegrationTableFilter;
      IF TableFilter <> '' THEN
        IntRecordRef.SETVIEW(TableFilter);

      IF "Synch. Int. Tbl. Mod. On Fltr." <> 0DT THEN BEGIN
        ModifiedOnFieldRef := IntRecordRef.FIELD("Int. Tbl. Modified On Fld. No.");
        ModifiedOnFieldRef.SETFILTER('>%1',"Synch. Int. Tbl. Mod. On Fltr.");
      END;
    END;

    [External]
    PROCEDURE SetRecordRefFilter@11(VAR RecordRef@1000 : RecordRef);
    VAR
      TableFilter@1001 : Text;
    BEGIN
      TableFilter := GetTableFilter;
      IF TableFilter <> '' THEN
        RecordRef.SETVIEW(TableFilter);
    END;

    PROCEDURE CopyModifiedOnFilters@28(FromIntegrationTableMapping@1000 : Record 5335);
    BEGIN
      "Synch. Modified On Filter" := FromIntegrationTableMapping."Synch. Modified On Filter";
      "Synch. Int. Tbl. Mod. On Fltr." := FromIntegrationTableMapping."Synch. Int. Tbl. Mod. On Fltr.";
      MODIFY;
    END;

    [External]
    PROCEDURE CreateRecord@14(MappingName@1000 : Code[20];TableNo@1001 : Integer;IntegrationTableNo@1002 : Integer;IntegrationTableUIDFieldNo@1005 : Integer;IntegrationTableModifiedFieldNo@1006 : Integer;TableConfigTemplateCode@1003 : Code[10];IntegrationTableConfigTemplateCode@1007 : Code[10];SynchOnlyCoupledRecords@1009 : Boolean;DirectionArg@1004 : Option;Prefix@1010 : Text[30]);
    BEGIN
      IF GET(MappingName) THEN
        DELETE(TRUE);
      INIT;
      Name := MappingName;
      "Table ID" := TableNo;
      "Integration Table ID" := IntegrationTableNo;
      "Synch. Codeunit ID" := CODEUNIT::"CRM Integration Table Synch.";
      VALIDATE("Integration Table UID Fld. No.",IntegrationTableUIDFieldNo);
      "Int. Tbl. Modified On Fld. No." := IntegrationTableModifiedFieldNo;
      "Table Config Template Code" := TableConfigTemplateCode;
      "Int. Tbl. Config Template Code" := IntegrationTableConfigTemplateCode;
      Direction := DirectionArg;
      "Int. Tbl. Caption Prefix" := Prefix;
      "Synch. Only Coupled Records" := SynchOnlyCoupledRecords;
      INSERT;
    END;

    [External]
    PROCEDURE SetFullSyncStartAndCommit@15();
    BEGIN
      VALIDATE("Full Sync is Running",TRUE);
      MODIFY;
      COMMIT;
      GET(Name);
    END;

    [External]
    PROCEDURE SetFullSyncEndAndCommit@17();
    BEGIN
      VALIDATE("Full Sync is Running",FALSE);
      MODIFY;
      COMMIT;
      GET(Name);
    END;

    [External]
    PROCEDURE IsFullSyncAllowed@18() : Boolean;
    BEGIN
      GET(Name);
      IF NOT "Full Sync is Running" THEN
        EXIT(TRUE);

      IF NOT ISSESSIONACTIVE("Full Sync Session ID") THEN BEGIN
        SetFullSyncEndAndCommit;
        EXIT(TRUE);
      END;
      IF ABS(CURRENTDATETIME - "Last Full Sync Start DateTime") >= OneDayInMiliseconds THEN
        EXIT(TRUE);
      EXIT(FALSE)
    END;

    LOCAL PROCEDURE OneDayInMiliseconds@19() : Integer;
    BEGIN
      EXIT(24 * 60 * 60 * 1000)
    END;

    BEGIN
    END.
  }
}

