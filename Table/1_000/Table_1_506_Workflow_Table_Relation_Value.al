OBJECT Table 1506 Workflow Table Relation Value
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    Permissions=TableData 1504=r;
    CaptionML=[DAN=V‘rdi for workflowtabelrelation;
               ENU=Workflow Table Relation Value];
  }
  FIELDS
  {
    { 1   ;   ;Workflow Step Instance ID;GUID     ;TableRelation="Workflow Step Instance".ID;
                                                   CaptionML=[DAN=Id for workflowtrininstans;
                                                              ENU=Workflow Step Instance ID] }
    { 2   ;   ;Workflow Code       ;Code20        ;TableRelation="Workflow Step Instance"."Workflow Code" WHERE (ID=FIELD(Workflow Step Instance ID));
                                                   CaptionML=[DAN=Workflowkode;
                                                              ENU=Workflow Code] }
    { 3   ;   ;Workflow Step ID    ;Integer       ;TableRelation="Workflow Step Instance"."Workflow Step ID" WHERE (ID=FIELD(Workflow Step Instance ID),
                                                                                                                    Workflow Code=FIELD(Workflow Code));
                                                   CaptionML=[DAN=Id for workflowtrin;
                                                              ENU=Workflow Step ID] }
    { 4   ;   ;Table ID            ;Integer       ;TableRelation=AllObjWithCaption."Object ID" WHERE (Object Type=CONST(Table));
                                                   CaptionML=[DAN=Tabel-id;
                                                              ENU=Table ID] }
    { 5   ;   ;Field ID            ;Integer       ;TableRelation=Field.No. WHERE (TableNo=FIELD(Table ID));
                                                   CaptionML=[DAN=Felt-id;
                                                              ENU=Field ID] }
    { 6   ;   ;Related Table ID    ;Integer       ;TableRelation=AllObjWithCaption."Object ID" WHERE (Object Type=CONST(Table));
                                                   CaptionML=[DAN=Relateret tabel-id;
                                                              ENU=Related Table ID] }
    { 7   ;   ;Related Field ID    ;Integer       ;TableRelation=Field.No. WHERE (TableNo=FIELD(Related Table ID));
                                                   CaptionML=[DAN=Relateret felt-id;
                                                              ENU=Related Field ID] }
    { 8   ;   ;Value               ;Text250       ;CaptionML=[DAN=V‘rdi;
                                                              ENU=Value] }
    { 9   ;   ;Record ID           ;RecordID      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Record-id;
                                                              ENU=Record ID] }
  }
  KEYS
  {
    {    ;Workflow Step Instance ID,Workflow Code,Workflow Step ID,Table ID,Field ID,Related Table ID,Related Field ID;
                                                   Clustered=Yes }
    {    ;Record ID                                }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    [External]
    PROCEDURE CreateNew@1(NextStepId@1004 : Integer;WorkflowStepInstance@1001 : Record 1504;WorkflowTableRelation@1002 : Record 1505;RecRef@1003 : RecordRef);
    VAR
      FieldRef@1000 : FieldRef;
    BEGIN
      INIT;
      VALIDATE("Workflow Step Instance ID",WorkflowStepInstance.ID);
      VALIDATE("Workflow Code",WorkflowStepInstance."Workflow Code");
      VALIDATE("Workflow Step ID",NextStepId);
      "Table ID" := WorkflowTableRelation."Table ID";
      "Field ID" := WorkflowTableRelation."Field ID";
      "Related Table ID" := WorkflowTableRelation."Related Table ID";
      "Related Field ID" := WorkflowTableRelation."Related Field ID";
      FieldRef := RecRef.FIELD(WorkflowTableRelation."Field ID");
      Value := FieldRef.VALUE;
      "Record ID" := RecRef.RECORDID;
      INSERT;
    END;

    [External]
    PROCEDURE UpdateRelationValue@2(RecRef@1000 : RecordRef);
    VAR
      FieldRef@1001 : FieldRef;
    BEGIN
      FieldRef := RecRef.FIELD("Field ID");
      Value := FieldRef.VALUE;
      "Record ID" := RecRef.RECORDID;
      MODIFY;
    END;

    BEGIN
    END.
  }
}

