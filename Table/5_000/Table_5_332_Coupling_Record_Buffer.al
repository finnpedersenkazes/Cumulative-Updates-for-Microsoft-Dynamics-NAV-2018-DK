OBJECT Table 5332 Coupling Record Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Sammenk‘dningsrecordbuffer;
               ENU=Coupling Record Buffer];
  }
  FIELDS
  {
    { 1   ;   ;NAV Name            ;Text250       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=NAV-navn;
                                                              ENU=NAV Name] }
    { 2   ;   ;CRM Name            ;Text250       ;OnValidate=VAR
                                                                CRMIntegrationRecord@1001 : Record 5331;
                                                              BEGIN
                                                                IF FindCRMRecordByName("CRM Name") THEN BEGIN
                                                                  IF "Saved CRM ID" <> "CRM ID" THEN
                                                                    CRMIntegrationRecord.AssertRecordIDCanBeCoupled("NAV Record ID","CRM ID");
                                                                  "CRM Name" := CalcCRMName;
                                                                END ELSE
                                                                  ERROR(NoSuchCRMRecordErr,"CRM Name",CRMProductName.SHORT);
                                                              END;

                                                   OnLookup=VAR
                                                              CRMIntegrationRecord@1001 : Record 5331;
                                                            BEGIN
                                                              IF LookupCRMTables.Lookup("CRM Table ID","NAV Table ID","Saved CRM ID","CRM ID") THEN BEGIN
                                                                IF "Saved CRM ID" <> "CRM ID" THEN
                                                                  CRMIntegrationRecord.AssertRecordIDCanBeCoupled("NAV Record ID","CRM ID");
                                                                "CRM Name" := CalcCRMName;
                                                              END;
                                                            END;

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=CRM-navn;
                                                              ENU=CRM Name] }
    { 3   ;   ;NAV Table ID        ;Integer       ;OnValidate=VAR
                                                                IntegrationTableMapping@1000 : Record 5335;
                                                              BEGIN
                                                                IntegrationTableMapping.SETRANGE("Table ID","NAV Table ID");
                                                                IntegrationTableMapping.SETRANGE("Delete After Synchronization",FALSE);
                                                                IF IntegrationTableMapping.FINDFIRST THEN
                                                                  "CRM Table Name" := IntegrationTableMapping.Name
                                                                ELSE
                                                                  "CRM Table Name" := '';
                                                              END;

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=NAV-tabel-id;
                                                              ENU=NAV Table ID] }
    { 4   ;   ;CRM Table ID        ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=CRM-tabel-id;
                                                              ENU=CRM Table ID] }
    { 5   ;   ;Sync Action         ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Synkroniseringshandling;
                                                              ENU=Sync Action];
                                                   OptionCaptionML=[DAN=Synkroniser ikke,Til integrationstabel,Fra integrationstabel;
                                                                    ENU=Do Not Synchronize,To Integration Table,From Integration Table];
                                                   OptionString=Do Not Synchronize,To Integration Table,From Integration Table }
    { 8   ;   ;NAV Record ID       ;RecordID      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=NAV-record-id;
                                                              ENU=NAV Record ID] }
    { 9   ;   ;CRM ID              ;GUID          ;OnValidate=BEGIN
                                                                "CRM Name" := CalcCRMName;
                                                              END;

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=CRM-id;
                                                              ENU=CRM ID] }
    { 10  ;   ;Create New          ;Boolean       ;OnValidate=VAR
                                                                NullGUID@1000 : GUID;
                                                              BEGIN
                                                                IF "Create New" THEN BEGIN
                                                                  "Saved Sync Action" := "Sync Action";
                                                                  "Saved CRM ID" := "CRM ID";
                                                                  VALIDATE("Sync Action","Sync Action"::"To Integration Table");
                                                                  CLEAR(NullGUID);
                                                                  VALIDATE("CRM ID",NullGUID);
                                                                END ELSE BEGIN
                                                                  VALIDATE("Sync Action","Saved Sync Action");
                                                                  VALIDATE("CRM ID","Saved CRM ID");
                                                                END;
                                                              END;

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Opret ny;
                                                              ENU=Create New] }
    { 11  ;   ;Saved Sync Action   ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Gemt synkroniseringshandling;
                                                              ENU=Saved Sync Action];
                                                   OptionCaptionML=[DAN=Synkroniser ikke,Til integrationstabel,Fra integrationstabel;
                                                                    ENU=Do Not Synchronize,To Integration Table,From Integration Table];
                                                   OptionString=Do Not Synchronize,To Integration Table,From Integration Table }
    { 12  ;   ;Saved CRM ID        ;GUID          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Gemt CRM-id;
                                                              ENU=Saved CRM ID] }
    { 13  ;   ;CRM Table Name      ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=CRM-tabelnavn;
                                                              ENU=CRM Table Name];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;NAV Name                                ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      InitialSynchDisabledErr@1001 : TextConst 'DAN=Der blev ikke angivet en oprindelig synkroniseringsretning, da oprindelig synkronisering blev deaktiveret.;ENU=No initial synchronization direction was specified because initial synchronization was disabled.';
      NoSuchCRMRecordErr@1000 : TextConst '@@@="%1 = The record name entered by the user, %2 = CRM product name";DAN=En record med navnet %1 findes ikke i %2.;ENU=A record with the name %1 does not exist in %2.';
      CRMSetupDefaults@1002 : Codeunit 5334;
      LookupCRMTables@1003 : Codeunit 5332;
      CRMProductName@1004 : Codeunit 5344;

    [External]
    PROCEDURE Initialize@1(NAVRecordID@1000 : RecordID);
    VAR
      IntegrationTableMapping@1004 : Record 5335;
      RecordRef@1003 : RecordRef;
    BEGIN
      RecordRef := NAVRecordID.GETRECORD;
      RecordRef.FIND;

      INIT;
      VALIDATE("NAV Table ID",NAVRecordID.TABLENO);
      "NAV Record ID" := NAVRecordID;
      "NAV Name" := NameValue(RecordRef);
      "CRM Table ID" := CRMSetupDefaults.GetCRMTableNo("NAV Table ID");
      IF CRMSetupDefaults.GetDefaultDirection("NAV Table ID") = IntegrationTableMapping.Direction::FromIntegrationTable THEN
        VALIDATE("Sync Action","Sync Action"::"From Integration Table")
      ELSE
        VALIDATE("Sync Action","Sync Action"::"To Integration Table");
      IF FindCRMId THEN BEGIN
        "CRM Name" := CalcCRMName;
        VALIDATE("Sync Action","Sync Action"::"Do Not Synchronize");
        "Saved CRM ID" := "CRM ID";
      END
    END;

    LOCAL PROCEDURE FindCRMId@8() : Boolean;
    VAR
      CRMIntegrationRecord@1002 : Record 5331;
    BEGIN
      EXIT(CRMIntegrationRecord.FindIDFromRecordID("NAV Record ID","CRM ID"))
    END;

    LOCAL PROCEDURE FindCRMRecordByName@7(VAR CRMName@1004 : Text[250]) : Boolean;
    VAR
      RecordRef@1002 : RecordRef;
      FieldRef@1001 : FieldRef;
      Found@1003 : Boolean;
    BEGIN
      RecordRef.OPEN("CRM Table ID");
      FieldRef := RecordRef.FIELD(CRMSetupDefaults.GetNameFieldNo("CRM Table ID"));
      FieldRef.SETRANGE(CRMName);
      IF RecordRef.FINDFIRST THEN
        Found := TRUE
      ELSE BEGIN
        RecordRef.CURRENTKEYINDEX(2); // "Name" key should be the second key in a CRM table
        FieldRef := RecordRef.FIELD(CRMSetupDefaults.GetNameFieldNo("CRM Table ID"));
        FieldRef.SETFILTER("CRM Name" + '*');
        IF RecordRef.FINDFIRST THEN
          Found := TRUE;
      END;
      IF Found THEN BEGIN
        CRMName := NameValue(RecordRef);
        "CRM ID" := PrimaryKeyValue(RecordRef);
      END;
      RecordRef.CLOSE;
      EXIT(Found);
    END;

    LOCAL PROCEDURE CalcCRMName@9() : Text[250];
    VAR
      RecordRef@1003 : RecordRef;
      CRMName@1000 : Text[250];
    BEGIN
      RecordRef.OPEN("CRM Table ID");
      FindCRMRecRefByPK(RecordRef,"CRM ID");
      CRMName := NameValue(RecordRef);
      RecordRef.CLOSE;
      EXIT(CRMName);
    END;

    [External]
    PROCEDURE GetInitialSynchronizationDirection@13() : Integer;
    VAR
      IntegrationTableMapping@1000 : Record 5335;
    BEGIN
      IF "Sync Action" = "Sync Action"::"Do Not Synchronize" THEN
        ERROR(InitialSynchDisabledErr);

      IF "Sync Action" = "Sync Action"::"To Integration Table" THEN
        EXIT(IntegrationTableMapping.Direction::ToIntegrationTable);

      EXIT(IntegrationTableMapping.Direction::FromIntegrationTable);
    END;

    [External]
    PROCEDURE GetPerformInitialSynchronization@6() : Boolean;
    BEGIN
      EXIT("Sync Action" <> "Sync Action"::"Do Not Synchronize");
    END;

    LOCAL PROCEDURE NameValue@10(RecordRef@1000 : RecordRef) : Text[250];
    VAR
      FieldRef@1001 : FieldRef;
    BEGIN
      FieldRef := RecordRef.FIELD(CRMSetupDefaults.GetNameFieldNo(RecordRef.NUMBER));
      EXIT(COPYSTR(FORMAT(FieldRef.VALUE),1,MAXSTRLEN("CRM Name")));
    END;

    LOCAL PROCEDURE PrimaryKeyValue@12(RecordRef@1000 : RecordRef) : GUID;
    VAR
      FieldRef@1002 : FieldRef;
      PrimaryKeyRef@1001 : KeyRef;
    BEGIN
      PrimaryKeyRef := RecordRef.KEYINDEX(1);
      FieldRef := PrimaryKeyRef.FIELDINDEX(1);
      EXIT(FieldRef.VALUE);
    END;

    LOCAL PROCEDURE FindCRMRecRefByPK@5(VAR RecordRef@1000 : RecordRef;CRMId@1001 : GUID) : Boolean;
    VAR
      FieldRef@1002 : FieldRef;
      PrimaryKeyRef@1003 : KeyRef;
    BEGIN
      PrimaryKeyRef := RecordRef.KEYINDEX(1);
      FieldRef := PrimaryKeyRef.FIELDINDEX(1);
      FieldRef.SETRANGE(CRMId);
      EXIT(RecordRef.FINDFIRST);
    END;

    BEGIN
    END.
  }
}

