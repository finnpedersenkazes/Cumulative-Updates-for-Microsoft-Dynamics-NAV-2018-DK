OBJECT Table 1500 Workflow Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    OnDelete=VAR
               Workflow@1000 : Record 1501;
               TempWorkflowBuffer@1001 : TEMPORARY Record 1500;
             BEGIN
               IF "Workflow Code" = '' THEN
                 ERROR('');
               CALCFIELDS(Template);
               IF Template THEN
                 ERROR('');
               Workflow.GET("Workflow Code");
               Workflow.DELETE(TRUE);

               TempWorkflowBuffer.COPY(Rec,TRUE);
               TempWorkflowBuffer.SETRANGE("Category Code","Category Code");
               TempWorkflowBuffer.SETFILTER("Workflow Code",'<>%1&<>%2','',"Workflow Code");
               IF TempWorkflowBuffer.ISEMPTY THEN BEGIN
                 TempWorkflowBuffer.GET("Category Code",'');
                 TempWorkflowBuffer.DELETE(FALSE);
               END;
             END;

    CaptionML=[DAN=" Workflowbuffer";
               ENU=Workflow Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Category Code       ;Code20        ;TableRelation="Workflow Category".Code;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kategorikode;
                                                              ENU=Category Code] }
    { 2   ;   ;Workflow Code       ;Code20        ;TableRelation=Workflow.Code;
                                                   TestTableRelation=No;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Workflowkode;
                                                              ENU=Workflow Code] }
    { 3   ;   ;Indentation         ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Indrykning;
                                                              ENU=Indentation] }
    { 4   ;   ;Description         ;Text100       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description];
                                                   Editable=No }
    { 6   ;   ;Template            ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Workflow.Template WHERE (Code=FIELD(Workflow Code)));
                                                   CaptionML=[DAN=Skabelon;
                                                              ENU=Template];
                                                   Editable=No }
    { 7   ;   ;Enabled             ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Workflow.Enabled WHERE (Code=FIELD(Workflow Code)));
                                                   CaptionML=[DAN=Aktiveret;
                                                              ENU=Enabled];
                                                   Editable=No }
    { 8   ;   ;External Client ID  ;GUID          ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Workflow Webhook Subscription"."Client Id" WHERE (WF Definition Id=FIELD(Workflow Code),
                                                                                                                         Enabled=CONST(Yes)));
                                                   CaptionML=[DAN=Eksternt klient-id;
                                                              ENU=External Client ID];
                                                   Editable=No }
    { 9   ;   ;External Client Type;Text30        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Workflow Webhook Subscription"."Client Type" WHERE (WF Definition Id=FIELD(Workflow Code),
                                                                                                                           Enabled=CONST(Yes)));
                                                   CaptionML=[DAN=Ekstern klienttype;
                                                              ENU=External Client Type];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Category Code,Workflow Code             ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    LOCAL PROCEDURE InitBuffer@1(VAR TempWorkflowBuffer@1000 : TEMPORARY Record 1500;Template@1001 : Boolean);
    VAR
      Workflow@1002 : Record 1501;
    BEGIN
      DELETEALL(FALSE);
      Workflow.SETRANGE(Template,Template);
      IF Workflow.FINDSET THEN
        REPEAT
          IF NOT TempWorkflowBuffer.GET(Workflow.Category,'') THEN
            AddCategory(TempWorkflowBuffer,Workflow.Category);
          AddWorkflow(TempWorkflowBuffer,Workflow.Category,Workflow.Code);
        UNTIL Workflow.NEXT = 0;
    END;

    [External]
    PROCEDURE InitBufferForWorkflows@2(VAR TempWorkflowBuffer@1000 : TEMPORARY Record 1500);
    BEGIN
      InitBuffer(TempWorkflowBuffer,FALSE);
    END;

    [External]
    PROCEDURE InitBufferForTemplates@3(VAR TempWorkflowBuffer@1000 : TEMPORARY Record 1500);
    BEGIN
      InitBuffer(TempWorkflowBuffer,TRUE);
    END;

    LOCAL PROCEDURE AddCategory@4(VAR TempWorkflowBuffer@1001 : TEMPORARY Record 1500;CategoryCode@1000 : Code[20]);
    BEGIN
      InsertRec(TempWorkflowBuffer,CategoryCode,'',0);
    END;

    LOCAL PROCEDURE AddWorkflow@5(VAR TempWorkflowBuffer@1002 : TEMPORARY Record 1500;CategoryCode@1000 : Code[20];WorkflowCode@1001 : Code[20]);
    BEGIN
      InsertRec(TempWorkflowBuffer,CategoryCode,WorkflowCode,1);
    END;

    LOCAL PROCEDURE InsertRec@6(VAR TempWorkflowBuffer@1003 : TEMPORARY Record 1500;CategoryCode@1000 : Code[20];WorkflowCode@1001 : Code[20];Indent@1002 : Integer);
    VAR
      Workflow@1004 : Record 1501;
      WorkflowCategory@1005 : Record 1508;
    BEGIN
      TempWorkflowBuffer.INIT;
      TempWorkflowBuffer."Category Code" := CategoryCode;
      TempWorkflowBuffer."Workflow Code" := WorkflowCode;
      TempWorkflowBuffer.Indentation := Indent;
      IF WorkflowCode = '' THEN BEGIN
        IF WorkflowCategory.GET(CategoryCode) THEN
          TempWorkflowBuffer.Description := WorkflowCategory.Description
      END ELSE
        IF Workflow.GET(WorkflowCode) THEN
          TempWorkflowBuffer.Description := Workflow.Description;

      IF TempWorkflowBuffer.INSERT THEN;
    END;

    [External]
    PROCEDURE CopyWorkflow@7(WorkflowBuffer@1003 : Record 1500);
    VAR
      FromWorkflow@1000 : Record 1501;
      ToWorkflow@1001 : Record 1501;
      CopyWorkflow@1002 : Report 1510;
    BEGIN
      IF NOT FromWorkflow.GET(WorkflowBuffer."Workflow Code") THEN
        ERROR('');
      IF FromWorkflow.Template OR (INCSTR(FromWorkflow.Code) = '') THEN
        ToWorkflow.Code := COPYSTR(FromWorkflow.Code,1,MAXSTRLEN(ToWorkflow.Code) - 3) + '-01'
      ELSE
        ToWorkflow.Code := FromWorkflow.Code;
      WHILE ToWorkflow.GET(ToWorkflow.Code) DO
        ToWorkflow.Code := INCSTR(ToWorkflow.Code);
      ToWorkflow.INIT;
      ToWorkflow.INSERT;
      CopyWorkflow.InitCopyWorkflow(FromWorkflow,ToWorkflow);
      CopyWorkflow.USEREQUESTPAGE(FALSE);
      CopyWorkflow.RUN;
      PAGE.RUN(PAGE::Workflow,ToWorkflow);
    END;

    BEGIN
    END.
  }
}

