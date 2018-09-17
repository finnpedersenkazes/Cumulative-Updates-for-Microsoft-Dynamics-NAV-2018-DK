OBJECT Table 1504 Workflow Step Instance
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    Permissions=TableData 1504=rd,
                TableData 1505=r,
                TableData 1506=rimd,
                TableData 1524=rd,
                TableData 1530=rimd;
    OnInsert=BEGIN
               "Created Date-Time" := ROUNDDATETIME(CURRENTDATETIME,60000);
               "Created By User ID" := USERID;
             END;

    OnModify=BEGIN
               "Last Modified Date-Time" := ROUNDDATETIME(CURRENTDATETIME,60000);
               "Last Modified By User ID" := USERID;
             END;

    OnDelete=VAR
               WorkflowTableRelationValue@1000 : Record 1506;
             BEGIN
               WorkflowTableRelationValue.SETRANGE("Workflow Step Instance ID",ID);
               WorkflowTableRelationValue.SETRANGE("Workflow Code","Workflow Code");
               WorkflowTableRelationValue.DELETEALL(TRUE);
               DeleteStepInstanceRules;
             END;

    CaptionML=[DAN=Workflowtrininstans;
               ENU=Workflow Step Instance];
  }
  FIELDS
  {
    { 1   ;   ;ID                  ;GUID          ;CaptionML=[DAN=Id;
                                                              ENU=ID] }
    { 2   ;   ;Workflow Code       ;Code20        ;TableRelation="Workflow Step"."Workflow Code";
                                                   CaptionML=[DAN=Workflowkode;
                                                              ENU=Workflow Code] }
    { 3   ;   ;Workflow Step ID    ;Integer       ;TableRelation="Workflow Step".ID WHERE (Workflow Code=FIELD(Workflow Code));
                                                   CaptionML=[DAN=Id for workflowtrin;
                                                              ENU=Workflow Step ID] }
    { 4   ;   ;Description         ;Text100       ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 9   ;   ;Entry Point         ;Boolean       ;CaptionML=[DAN=Startpunkt;
                                                              ENU=Entry Point] }
    { 11  ;   ;Record ID           ;RecordID      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Record-id;
                                                              ENU=Record ID] }
    { 12  ;   ;Created Date-Time   ;DateTime      ;CaptionML=[DAN=Oprettet dato/klokkesl�t;
                                                              ENU=Created Date-Time];
                                                   Editable=No }
    { 13  ;   ;Created By User ID  ;Code50        ;TableRelation=User."User Name";
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Oprettet af bruger-id;
                                                              ENU=Created By User ID];
                                                   Editable=No }
    { 14  ;   ;Last Modified Date-Time;DateTime   ;CaptionML=[DAN=Dato/klokkesl�t for seneste �ndring;
                                                              ENU=Last Modified Date-Time];
                                                   Editable=No }
    { 15  ;   ;Last Modified By User ID;Code50    ;TableRelation=User."User Name";
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id for seneste �ndring;
                                                              ENU=Last Modified By User ID];
                                                   Editable=No }
    { 17  ;   ;Status              ;Option        ;CaptionML=[DAN=Status;
                                                              ENU=Status];
                                                   OptionCaptionML=[DAN=Inaktiv,Aktiv,Afsluttet,Ignoreret,Behandler;
                                                                    ENU=Inactive,Active,Completed,Ignored,Processing];
                                                   OptionString=Inactive,Active,Completed,Ignored,Processing }
    { 18  ;   ;Previous Workflow Step ID;Integer  ;CaptionML=[DAN=Id for foreg�ende workflowtrin;
                                                              ENU=Previous Workflow Step ID] }
    { 19  ;   ;Next Workflow Step ID;Integer      ;CaptionML=[DAN=Id for n�ste workflowtrin;
                                                              ENU=Next Workflow Step ID] }
    { 21  ;   ;Type                ;Option        ;CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=H�ndelse,Svar;
                                                                    ENU=Event,Response];
                                                   OptionString=Event,Response }
    { 22  ;   ;Function Name       ;Code128       ;TableRelation=IF (Type=CONST(Event)) "Workflow Event"
                                                                 ELSE IF (Type=CONST(Response)) "Workflow Response";
                                                   CaptionML=[DAN=Funktionsnavn;
                                                              ENU=Function Name] }
    { 23  ;   ;Argument            ;GUID          ;TableRelation="Workflow Step Argument" WHERE (Type=FIELD(Type));
                                                   CaptionML=[DAN=Argument;
                                                              ENU=Argument] }
    { 30  ;   ;Original Workflow Code;Code20      ;TableRelation="Workflow Step"."Workflow Code";
                                                   CaptionML=[DAN=Oprindelig workflowkode;
                                                              ENU=Original Workflow Code] }
    { 31  ;   ;Original Workflow Step ID;Integer  ;TableRelation="Workflow Step".ID WHERE (Workflow Code=FIELD(Original Workflow Code));
                                                   CaptionML=[DAN=Id for oprindeligt workflowtrin;
                                                              ENU=Original Workflow Step ID] }
    { 32  ;   ;Sequence No.        ;Integer       ;CaptionML=[DAN=R�kkef�lgenr.;
                                                              ENU=Sequence No.] }
  }
  KEYS
  {
    {    ;ID,Workflow Code,Workflow Step ID       ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      ActiveInstancesWillBeArchivedQst@1000 : TextConst 'DAN=Er du sikker p�, at du vil arkivere alle workflowtrininstanser i workflowet?;ENU=Are you sure you want to archive all workflow step instances in the workflow?';
      NothingToArchiveMsg@1001 : TextConst 'DAN=Der er intet at arkivere.;ENU=There is nothing to archive.';

    [External]
    PROCEDURE MoveForward@5(Variant@1003 : Variant);
    VAR
      NextWorkflowStepInstance@1000 : Record 1504;
      WorkflowMgt@1002 : Codeunit 1501;
      RecRef@1001 : RecordRef;
    BEGIN
      RecRef.GETTABLE(Variant);
      "Record ID" := RecRef.RECORDID;

      IF "Next Workflow Step ID" > 0 THEN BEGIN
        WorkflowMgt.UpdateStatus(Rec,Status::Completed,Status::Inactive,Status::Ignored);
        NextWorkflowStepInstance.GET(ID,"Workflow Code","Next Workflow Step ID");

        CASE NextWorkflowStepInstance.Type OF
          NextWorkflowStepInstance.Type::"Event":
            WorkflowMgt.UpdateStatus(NextWorkflowStepInstance,Status::Active,Status::Inactive,Status::Ignored);
          NextWorkflowStepInstance.Type::Response:
            WorkflowMgt.UpdateStatus(NextWorkflowStepInstance,Status::Completed,Status::Active,Status::Ignored);
        END;
      END ELSE
        WorkflowMgt.UpdateStatus(Rec,Status::Completed,Status::Active,Status::Ignored);

      IF NOT TableRelationValuesExist(RecRef) THEN
        SetTableRelationValues(RecRef);
    END;

    [External]
    PROCEDURE TableRelationValuesExist@3(RecRef@1000 : RecordRef) : Boolean;
    VAR
      WorkflowTableRelationValue@1001 : Record 1506;
    BEGIN
      WorkflowTableRelationValue.SETRANGE("Workflow Step Instance ID",ID);
      WorkflowTableRelationValue.SETRANGE("Table ID",RecRef.NUMBER);
      EXIT(NOT WorkflowTableRelationValue.ISEMPTY);
    END;

    [External]
    PROCEDURE SetTableRelationValues@6(RecRef@1000 : RecordRef);
    VAR
      WorkflowTableRelation@1002 : Record 1505;
      WorkflowTableRelationValue@1003 : Record 1506;
      WorkflowInstance@1001 : Query 1501;
    BEGIN
      WorkflowTableRelation.SETRANGE("Table ID",RecRef.NUMBER);
      IF WorkflowTableRelation.FINDSET THEN
        REPEAT
          WorkflowInstance.SETRANGE(Code,"Workflow Code");
          WorkflowInstance.SETRANGE(Instance_ID,ID);
          WorkflowInstance.SETFILTER(Status,'<>%1|%2',Status::Completed,Status::Ignored);
          WorkflowInstance.OPEN;

          WHILE WorkflowInstance.READ DO
            WorkflowTableRelationValue.CreateNew(WorkflowInstance.Step_ID,Rec,WorkflowTableRelation,RecRef);
        UNTIL WorkflowTableRelation.NEXT = 0;
    END;

    [External]
    PROCEDURE MatchesRecordValues@7(RecRef@1003 : RecordRef) : Boolean;
    VAR
      WorkflowTableRelationValue@1002 : Record 1506;
      FieldRef@1001 : FieldRef;
      SkipRecord@1004 : Boolean;
      ComparisonValue@1005 : Text;
    BEGIN
      WorkflowTableRelationValue.SETRANGE("Workflow Step Instance ID",ID);
      WorkflowTableRelationValue.SETRANGE("Workflow Code","Workflow Code");
      WorkflowTableRelationValue.SETRANGE("Workflow Step ID","Workflow Step ID");
      WorkflowTableRelationValue.SETRANGE("Related Table ID",RecRef.NUMBER);
      IF WorkflowTableRelationValue.FINDSET THEN BEGIN
        REPEAT
          FieldRef := RecRef.FIELD(WorkflowTableRelationValue."Related Field ID");
          IF WorkflowTableRelationValue."Field ID" <> 0 THEN
            ComparisonValue := WorkflowTableRelationValue.Value
          ELSE
            ComparisonValue := FORMAT(WorkflowTableRelationValue."Record ID");
          IF FORMAT(FieldRef.VALUE) <> ComparisonValue THEN
            SkipRecord := TRUE;
        UNTIL (WorkflowTableRelationValue.NEXT = 0) OR SkipRecord;
        EXIT(NOT SkipRecord);
      END;

      EXIT(FALSE);
    END;

    [External]
    PROCEDURE ArchiveActiveInstances@1(Workflow@1000 : Record 1501);
    VAR
      WorkflowStepInstanceArchive@1001 : Record 1530;
    BEGIN
      Workflow.COPYFILTER(Code,"Workflow Code");
      IF NOT FINDSET THEN
        MESSAGE(NothingToArchiveMsg)
      ELSE
        IF CONFIRM(ActiveInstancesWillBeArchivedQst) THEN BEGIN
          REPEAT
            WorkflowStepInstanceArchive.TRANSFERFIELDS(Rec,TRUE);
            WorkflowStepInstanceArchive.INSERT(TRUE);
          UNTIL NEXT = 0;
          DELETEALL(TRUE);
        END;
    END;

    [External]
    PROCEDURE ToString@2() : Text;
    BEGIN
      EXIT(STRSUBSTNO('%1,%2,%3,%4,%5,%6',
          ID,"Workflow Code","Workflow Step ID",Type,"Original Workflow Code","Original Workflow Step ID"));
    END;

    LOCAL PROCEDURE DeleteStepInstanceRules@4();
    VAR
      WorkflowRule@1000 : Record 1524;
    BEGIN
      FindWorkflowRules(WorkflowRule);
      WorkflowRule.DELETEALL;
    END;

    [External]
    PROCEDURE FindWorkflowRules@19(VAR WorkflowRule@1000 : Record 1524) : Boolean;
    BEGIN
      WorkflowRule.SETRANGE("Workflow Code","Workflow Code");
      WorkflowRule.SETRANGE("Workflow Step ID","Workflow Step ID");
      WorkflowRule.SETRANGE("Workflow Step Instance ID",ID);
      EXIT(NOT WorkflowRule.ISEMPTY);
    END;

    [External]
    PROCEDURE BuildTempWorkflowTree@8(WorkflowInstanceId@1000 : GUID);
    VAR
      NewStepId@1004 : Integer;
    BEGIN
      IF NOT ISTEMPORARY THEN
        EXIT;

      CreateTree(Rec,WorkflowInstanceId,0,NewStepId);

      SETRANGE(ID,WorkflowInstanceId);
      SETRANGE("Workflow Step ID");
      IF FINDSET THEN;
    END;

    LOCAL PROCEDURE CreateTree@9(VAR TempWorkflowStepInstance@1000 : TEMPORARY Record 1504;WorkflowInstanceId@1003 : GUID;OriginalStepId@1004 : Integer;VAR NewStepId@1005 : Integer);
    VAR
      WorkflowStepInstance@1001 : Record 1504;
    BEGIN
      IF OriginalStepId <> 0 THEN
        CreateNode(TempWorkflowStepInstance,WorkflowInstanceId,OriginalStepId,NewStepId);

      WorkflowStepInstance.SETRANGE(ID,WorkflowInstanceId);
      WorkflowStepInstance.SETRANGE("Previous Workflow Step ID",OriginalStepId);
      WorkflowStepInstance.SETCURRENTKEY("Sequence No.");

      IF WorkflowStepInstance.FINDSET THEN
        REPEAT
          NewStepId += 1;
          CreateTree(TempWorkflowStepInstance,WorkflowInstanceId,WorkflowStepInstance."Workflow Step ID",NewStepId);
        UNTIL WorkflowStepInstance.NEXT = 0;
    END;

    LOCAL PROCEDURE CreateNode@10(VAR TempWorkflowStepInstance@1000 : TEMPORARY Record 1504;WorkflowInstanceId@1001 : GUID;OriginalStepId@1003 : Integer;NewStepId@1002 : Integer);
    VAR
      SrcWorkflowStepInstance@1007 : Record 1504;
    BEGIN
      SrcWorkflowStepInstance.SETRANGE(ID,WorkflowInstanceId);
      SrcWorkflowStepInstance.SETRANGE("Workflow Step ID",OriginalStepId);
      SrcWorkflowStepInstance.FINDFIRST;

      CLEAR(TempWorkflowStepInstance);
      TempWorkflowStepInstance.INIT;
      TempWorkflowStepInstance.COPY(SrcWorkflowStepInstance);
      TempWorkflowStepInstance."Workflow Step ID" := NewStepId;
      TempWorkflowStepInstance.INSERT;
    END;

    BEGIN
    END.
  }
}

