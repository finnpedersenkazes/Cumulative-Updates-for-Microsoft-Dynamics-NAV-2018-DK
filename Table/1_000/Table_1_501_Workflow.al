OBJECT Table 1501 Workflow
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    Permissions=TableData 1502=rimd,
                TableData 1504=rm;
    DataCaptionFields=Code,Description;
    OnDelete=BEGIN
               CanDelete(TRUE);
               DeleteWorkflowSteps;
             END;

    OnRename=BEGIN
               CheckEditingIsAllowed;
             END;

    CaptionML=[DAN=Workflow;
               ENU=Workflow];
    DrillDownPageID=Page1501;
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code20        ;OnValidate=VAR
                                                                Workflow@1000 : Record 1501;
                                                              BEGIN
                                                                CheckEditingIsAllowed;
                                                                CheckWorkflowCodeDoesNotExistAsTemplate;
                                                                IF (xRec.Code = '') AND Workflow.GET THEN BEGIN
                                                                  Workflow.RENAME(Code);
                                                                  GET(Code);
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Kode;
                                                              ENU=Code];
                                                   NotBlank=Yes }
    { 2   ;   ;Description         ;Text100       ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 3   ;   ;Enabled             ;Boolean       ;OnValidate=VAR
                                                                Window@1000 : Dialog;
                                                              BEGIN
                                                                IF Template THEN
                                                                  ERROR(CannotEditTemplateWorkflowErr);

                                                                IF Enabled THEN BEGIN
                                                                  Window.OPEN(ValidateWorkflowProgressMsg);

                                                                  SetEntryPoint;
                                                                  CheckEntryPointsAreEvents;
                                                                  CheckEntryPointsAreNotSubWorkflows;
                                                                  CheckSingleEntryPointAsRoot;
                                                                  CheckOrphansNotExist;
                                                                  CheckFunctionNames;
                                                                  CheckSubWorkflowsEnabled;
                                                                  CheckResponseOptions;
                                                                  CheckEntryPointEventConditions;
                                                                  CheckEventTableRelation;
                                                                  CheckRecordChangedWorkflows;

                                                                  Window.CLOSE;
                                                                END ELSE BEGIN
                                                                  Window.OPEN(DisableReferringWorkflowsMsg);

                                                                  CheckEditingReferringWorkflowsIsAllowed;
                                                                  ClearEntryPointIfFirst;

                                                                  Window.CLOSE;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Aktiveret;
                                                              ENU=Enabled] }
    { 4   ;   ;Template            ;Boolean       ;InitValue=No;
                                                   OnValidate=BEGIN
                                                                IF xRec.Template AND Template THEN
                                                                  ERROR(CannotEditTemplateWorkflowErr);
                                                              END;

                                                   CaptionML=[DAN=Skabelon;
                                                              ENU=Template] }
    { 5   ;   ;Category            ;Code20        ;TableRelation="Workflow Category";
                                                   CaptionML=[DAN=Kategori;
                                                              ENU=Category] }
  }
  KEYS
  {
    {    ;Code                                    ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      CannotDeleteEnabledWorkflowErr@1000 : TextConst 'DAN=Aktiverede workflows kan ikke slettes.\\Du skal rydde feltet Aktiveret, f�r du sletter workflowet.;ENU=Enabled workflows cannot be deleted.\\You must clear the Enabled field box before you delete the workflow.';
      CannotDeleteWorkflowWithActiveInstancesErr@1008 : TextConst 'DAN=Du kan ikke slette workflowet, da der findes aktive workflowtrininstanser.;ENU=You cannot delete the workflow because active workflow step instances exist.';
      CannotEditEnabledWorkflowErr@1007 : TextConst 'DAN=Aktiverede workflows kan ikke redigeres.\\Du skal rydde feltet Aktiveret, f�r du redigerer workflowet.;ENU=Enabled workflows cannot be edited.\\You must clear the Enabled field box before you edit the workflow.';
      CannotEditTemplateWorkflowErr@1001 : TextConst 'DAN=Workflowskabeloner kan ikke redigeres.\\Du skal oprette et workflow ud fra skabelonen for at kunne redigere den.;ENU=Workflow templates cannot be edited.\\You must create a workflow from the template to edit it.';
      DisableReferringWorkflowsErr@1012 : TextConst '@@@="%1 = Workflow identifier (e.g. You cannot edit the MS-PIW workflow because it is used as a sub-workflow in other workflows. You must first disable the workflows that use the MS-PIW workflow.)";DAN=Du kan ikke redigere workflowet %1, fordi det er i brug som en underproces i andre workflows. Du skal f�rst deaktivere de workflows, der benytter workflowet %1.;ENU=You cannot edit the %1 workflow because it is used as a sub-workflow in other workflows. You must first disable the workflows that use the %1 workflow.';
      DisableReferringWorkflowsMsg@1011 : TextConst 'DAN=Andre workflows, hvor workflowet bruges som underordnet workflow, deaktiveres.;ENU=Other workflows where the workflow is used as a sub-workflow are being disabled.';
      DisableReferringWorkflowsQst@1010 : TextConst '@@@="%1 = Workflow Identifier (e.g. The MS-PIW workflow is used as a sub-workflow in other workflows, which you must disable before you can edit the MS-PIW workflow.\\Do you want to disable all workflows where the MS-PIW workflow is used?)";DAN=Workflowet %1 anvendes som en underproces til andre workflows, som du skal deaktivere, f�r du kan redigere workflowet %1.\\Vil du deaktivere alle workflows, hvor workflowet %1 er i brug?;ENU=The %1 workflow is used as a sub-workflow in other workflows, which you must disable before you can edit the %1 workflow.\\Do you want to disable all workflows where the %1 workflow is used?';
      EventOnlyEntryPointsErr@1006 : TextConst 'DAN=H�ndelser kan kun angives som startpunkter.;ENU=Events can only be specified as entry points.';
      MissingFunctionNamesErr@1015 : TextConst 'DAN=Alle workflowtrin skal have gyldige funktionsnavne.;ENU=All workflow steps must have valid function names.';
      MissingRespOptionsErr@1003 : TextConst 'DAN=Et eller flere workflowtrin mangler svarindstillinger.;ENU=Response options are missing in one or more workflow steps.';
      OneRootStepErr@1013 : TextConst 'DAN=Aktiverede workflows skal indeholde �t trin, som er et startpunkt, og som ikke har en v�rdi i feltet Id for foreg�ende workflowtrin.;ENU=Enabled workflows must have one step that is an entry point and does not have a value in the Previous Workflow Step ID field.';
      OrphanWorkflowStepsErr@1002 : TextConst 'DAN=Der m� kun v�re �t venstrejusteret workflowtrin.;ENU=There can be only one left-aligned workflow step.';
      SameEventConditionsErr@1005 : TextConst '@@@="%1=Table Caption";DAN=Der er et eller flere trin til startpunkter, der bruger den samme h�ndelse i tabellen %1. Du skal angive entydige h�ndelsesbetingelser i de trin til startpunkter, der bruger samme tabel.;ENU=One or more entry-point steps exist that use the same event on table %1. You must specify unique event conditions on entry-point steps that use the same table.';
      SubWorkflowNotEnabledErr@1009 : TextConst '@@@="%1 and %2 = Workflow Identifiers (e.g. You must enable the sub-workflow MS-PIW before you can enable the MS-SIAPW workflow.)";DAN=Du skal aktivere underprocessen %1 for at kunne aktivere workflowet %2.;ENU=You must enable the sub-workflow %1 before you can enable the %2 workflow.';
      ValidateWorkflowProgressMsg@1004 : TextConst 'DAN=Workflowet bliver valideret.;ENU=The workflow is being validated.';
      WorkflowStepInstanceLinkErr@1014 : TextConst '@@@="%1 and %2 = Workflow Identifiers (e.g. The MS-PIW workflow cannot start because all ending steps in the MS-SIAPW sub-workflow have a value in the Next Workflow Step ID field.\\Make sure that at least one step in the MS-SIAPW sub-workflow does not have a value in the Next Workflow Step ID field.)";DAN=Workflowet %1 kan ikke starte, fordi alle sluttrin i underprocessen %2 har en v�rdi i feltet Id for n�ste workflowtrin.\\Kontroll�r, at mindst et trin i underprocessen %2 ikke har en v�rdi i feltet Id for n�ste workflowtrin.;ENU=The %1 workflow cannot start because all ending steps in the %2 sub-workflow have a value in the Next Workflow Step ID field.\\Make sure that at least one step in the %2 sub-workflow does not have a value in the Next Workflow Step ID field.';
      ValidateTableRelationErr@1016 : TextConst 'DAN=Du skal definere en tabelrelation mellem alle records anvendt i h�ndelser.;ENU=You must define a table relation between all records used in events.';
      WorkflowExistsAsTemplateErr@1017 : TextConst 'DAN=Recorden findes allerede som en workflowskabelon.;ENU=The record already exists, as a workflow template.';
      WorkflowMustApplySavedValuesErr@1018 : TextConst 'DAN=Workflowet indeholder ikke et svar til at anvende til de gemte v�rdier.;ENU=The workflow does not contain a response to apply the saved values to.';
      WorkflowMustRevertValuesErr@1019 : TextConst 'DAN=Workflowet indeholder ikke et svar til at tilbagef�re og gemme de �ndrede feltv�rdier.;ENU=The workflow does not contain a response to revert and save the changed field values.';
      CannotDeleteWorkflowTemplatesErr@1020 : TextConst 'DAN=Du kan ikke slette en workflowskabelon.;ENU=You cannot delete a workflow template.';

    [External]
    PROCEDURE CreateInstance@24(VAR WorkflowStepInstance@1003 : Record 1504);
    VAR
      NextWorkflowStepQueue@1006 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.Queue";
      LeafWorkflowStepQueue@1004 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.Queue";
      WorkflowInstanceID@1001 : GUID;
      WorkflowInstanceCode@1000 : Code[20];
      WorkflowInstancePreviousStepID@1002 : Integer;
    BEGIN
      WorkflowInstanceID := CREATEGUID;
      WorkflowInstanceCode := Code;
      WorkflowInstancePreviousStepID := 0;

      NextWorkflowStepQueue := NextWorkflowStepQueue.Queue;

      CreateInstanceBreadthFirst(Code,WorkflowInstanceID,WorkflowInstanceCode,
        WorkflowInstancePreviousStepID,LeafWorkflowStepQueue,NextWorkflowStepQueue);

      UpdateWorkflowStepInstanceNextLinks(NextWorkflowStepQueue,WorkflowInstanceID);

      WorkflowStepInstance.SETRANGE(ID,WorkflowInstanceID);
      WorkflowStepInstance.SETRANGE("Entry Point",TRUE);
    END;

    LOCAL PROCEDURE CreateInstanceBreadthFirst@22(WorkflowCode@1000 : Code[20];InitialWorkflowInstanceID@1010 : GUID;InitialWorkflowInstanceCode@1011 : Code[20];InitialWorkflowInstancePreviousStepID@1013 : Integer;VAR LeafWorkflowStepQueue@1007 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.Queue";VAR NextWorkflowStepQueue@1015 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.Queue");
    VAR
      ChildWorkflowStep@1008 : Record 1502;
      ParentWorkflowStep@1006 : Record 1502;
      ParentWorkflowStepInstance@1009 : Record 1504;
      WorkflowStep@1001 : Record 1502;
      ParentWorkflowStepQueue@1003 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.Queue";
      WorkflowInstanceID@1002 : GUID;
      WorkflowInstanceCode@1012 : Code[20];
      WorkflowInstancePreviousStepID@1014 : Integer;
    BEGIN
      WorkflowStep.SETRANGE("Workflow Code",WorkflowCode);

      ParentWorkflowStepQueue := ParentWorkflowStepQueue.Queue;
      LeafWorkflowStepQueue := LeafWorkflowStepQueue.Queue;

      WorkflowStep.SETRANGE("Entry Point",TRUE);

      IF WorkflowStep.FINDFIRST THEN BEGIN
        WorkflowInstanceID := InitialWorkflowInstanceID;
        WorkflowInstanceCode := InitialWorkflowInstanceCode;
        WorkflowInstancePreviousStepID := InitialWorkflowInstancePreviousStepID;

        IF WorkflowStep.Type = WorkflowStep.Type::"Sub-Workflow" THEN
          CreateInstanceBreadthFirst(COPYSTR(WorkflowStep."Function Name",1,20),WorkflowInstanceID,WorkflowInstanceCode,
            WorkflowInstancePreviousStepID,LeafWorkflowStepQueue,NextWorkflowStepQueue)
        ELSE BEGIN
          WorkflowStep.CreateInstance(
            WorkflowInstanceID,WorkflowInstanceCode,WorkflowInstancePreviousStepID,WorkflowStep);

          UpdateWorkflowStepInstanceLeafLinks(ChildWorkflowStep,LeafWorkflowStepQueue,WorkflowInstanceID);

          IF WorkflowStep."Next Workflow Step ID" > 0 THEN
            NextWorkflowStepQueue.Enqueue(WorkflowStep.ToString);
        END;

        ParentWorkflowStepQueue.Enqueue(WorkflowStep.ToString);

        WHILE ParentWorkflowStepQueue.Count > 0 DO BEGIN
          ParentWorkflowStep.FindByAttributes(ParentWorkflowStepQueue.Dequeue);

          IF ParentWorkflowStep.Type <> ParentWorkflowStep.Type::"Sub-Workflow" THEN
            FindWorkflowStepInstance(ParentWorkflowStepInstance,ParentWorkflowStep,WorkflowInstanceID);

          IF NOT FindChildWorkflowSteps(ChildWorkflowStep,ParentWorkflowStep) THEN
            LeafWorkflowStepQueue.Enqueue(ParentWorkflowStep.ToString)
          ELSE
            REPEAT
              IF ChildWorkflowStep.Type = ChildWorkflowStep.Type::"Sub-Workflow" THEN BEGIN
                WorkflowInstancePreviousStepID := ParentWorkflowStepInstance."Workflow Step ID";

                CreateInstanceBreadthFirst(COPYSTR(ChildWorkflowStep."Function Name",1,20),WorkflowInstanceID,WorkflowInstanceCode,
                  WorkflowInstancePreviousStepID,LeafWorkflowStepQueue,NextWorkflowStepQueue);
              END ELSE BEGIN
                ChildWorkflowStep.CreateInstance(
                  WorkflowInstanceID,WorkflowInstanceCode,
                  ParentWorkflowStepInstance."Workflow Step ID",ChildWorkflowStep);

                UpdateWorkflowStepInstanceLeafLinks(ChildWorkflowStep,LeafWorkflowStepQueue,WorkflowInstanceID);

                IF ChildWorkflowStep."Next Workflow Step ID" > 0 THEN
                  NextWorkflowStepQueue.Enqueue(ChildWorkflowStep.ToString);
              END;

              ParentWorkflowStepQueue.Enqueue(ChildWorkflowStep.ToString);
            UNTIL ChildWorkflowStep.NEXT = 0;
        END;
      END;
    END;

    LOCAL PROCEDURE UpdateWorkflowStepInstanceLeafLinks@12(WorkflowStep@1005 : Record 1502;VAR LeafWorkflowStepQueue@1004 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.Queue";InstanceID@1010 : GUID);
    VAR
      LeafWorkflowStep@1000 : Record 1502;
      LeafWorkflowStepInstance@1006 : Record 1504;
      NextWorkflowStepInstance@1009 : Record 1504;
      PreviousWorkflowStep@1007 : Record 1502;
      WorkflowStepInstance@1001 : Record 1504;
      LeafCount@1002 : Integer;
      LoopLeafCount@1003 : Integer;
      WorkflowStepInstanceIsUpdated@1008 : Boolean;
    BEGIN
      IF LeafWorkflowStepQueue.Count = 0 THEN
        EXIT;

      IF NOT PreviousWorkflowStepIsSubWorkflow(PreviousWorkflowStep,WorkflowStep) THEN
        EXIT;

      FindWorkflowStepInstance(WorkflowStepInstance,WorkflowStep,InstanceID);
      LeafCount := LeafWorkflowStepQueue.Count;

      WHILE LeafWorkflowStepQueue.Count > 0 DO BEGIN
        LeafWorkflowStep.FindByAttributes(LeafWorkflowStepQueue.Dequeue);
        FindWorkflowStepInstance(LeafWorkflowStepInstance,LeafWorkflowStep,InstanceID);

        IF LeafWorkflowStepInstance."Next Workflow Step ID" > 0 THEN BEGIN
          LoopLeafCount += 1;

          IF FindNextWorkflowStepInstance(NextWorkflowStepInstance,WorkflowStep,
               LeafWorkflowStepInstance.ID,LeafWorkflowStepInstance."Workflow Code")
          THEN BEGIN
            LeafWorkflowStepInstance.VALIDATE("Next Workflow Step ID",NextWorkflowStepInstance."Workflow Step ID");
            LeafWorkflowStepInstance.MODIFY(TRUE);
          END;
        END ELSE
          IF WorkflowStepInstanceIsUpdated THEN BEGIN
            LeafWorkflowStepInstance.VALIDATE("Next Workflow Step ID",WorkflowStepInstance."Workflow Step ID");
            LeafWorkflowStepInstance.MODIFY(TRUE);
          END ELSE BEGIN
            WorkflowStepInstance.VALIDATE("Previous Workflow Step ID",LeafWorkflowStepInstance."Workflow Step ID");
            WorkflowStepInstance.MODIFY(TRUE);
            WorkflowStepInstanceIsUpdated := TRUE;
          END;
      END;

      IF (NOT WorkflowStepInstanceIsUpdated) OR (LoopLeafCount >= LeafCount) THEN
        ERROR(WorkflowStepInstanceLinkErr,WorkflowStepInstance."Original Workflow Code",PreviousWorkflowStep."Function Name");
    END;

    LOCAL PROCEDURE UpdateWorkflowStepInstanceNextLinks@21(NextWorkflowStepQueue@1000 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.Queue";InstanceID@1004 : GUID);
    VAR
      NextWorkflowStepInstance@1003 : Record 1504;
      WorkflowStep@1001 : Record 1502;
      WorkflowStepInstance@1002 : Record 1504;
    BEGIN
      WHILE NextWorkflowStepQueue.Count > 0 DO BEGIN
        WorkflowStep.FindByAttributes(NextWorkflowStepQueue.Dequeue);

        IF FindWorkflowStepInstance(WorkflowStepInstance,WorkflowStep,InstanceID) THEN
          IF FindNextWorkflowStepInstance(NextWorkflowStepInstance,WorkflowStep,InstanceID,WorkflowStepInstance."Workflow Code")
          THEN BEGIN
            FindLastResponseWorkflowStepInstanceBeforeEvent(NextWorkflowStepInstance,InstanceID,WorkflowStepInstance."Workflow Code");
            WorkflowStepInstance.VALIDATE("Next Workflow Step ID",NextWorkflowStepInstance."Workflow Step ID");
            WorkflowStepInstance.MODIFY(TRUE);
          END;
      END;
    END;

    LOCAL PROCEDURE PreviousWorkflowStepIsSubWorkflow@14(VAR PreviousWorkflowStep@1001 : Record 1502;WorkflowStep@1000 : Record 1502) : Boolean;
    BEGIN
      PreviousWorkflowStep.GET(WorkflowStep."Workflow Code",WorkflowStep."Previous Workflow Step ID");
      EXIT(PreviousWorkflowStep.Type = PreviousWorkflowStep.Type::"Sub-Workflow");
    END;

    LOCAL PROCEDURE FindChildWorkflowSteps@23(VAR ChildWorkflowStep@1000 : Record 1502;ParentWorkflowStep@1001 : Record 1502) : Boolean;
    BEGIN
      ChildWorkflowStep.SETRANGE("Workflow Code",ParentWorkflowStep."Workflow Code");
      ChildWorkflowStep.SETRANGE("Previous Workflow Step ID",ParentWorkflowStep.ID);
      EXIT(ChildWorkflowStep.FINDSET);
    END;

    LOCAL PROCEDURE FindWorkflowStepInstance@15(VAR WorkflowStepInstance@1000 : Record 1504;WorkflowStep@1001 : Record 1502;InstanceID@1002 : GUID) : Boolean;
    BEGIN
      WorkflowStepInstance.SETRANGE(ID,InstanceID);
      WorkflowStepInstance.SETRANGE("Original Workflow Code",WorkflowStep."Workflow Code");
      WorkflowStepInstance.SETRANGE("Original Workflow Step ID",WorkflowStep.ID);
      WorkflowStepInstance.SETRANGE(Type,WorkflowStep.Type);
      EXIT(WorkflowStepInstance.FINDFIRST);
    END;

    LOCAL PROCEDURE FindNextWorkflowStepInstance@27(VAR WorkflowStepInstance@1000 : Record 1504;WorkflowStep@1001 : Record 1502;InstanceID@1002 : GUID;WorkflowCode@1003 : Code[20]) : Boolean;
    BEGIN
      WorkflowStepInstance.SETRANGE(ID,InstanceID);
      WorkflowStepInstance.SETRANGE("Workflow Code",WorkflowCode);
      WorkflowStepInstance.SETRANGE("Original Workflow Code",WorkflowStep."Workflow Code");
      WorkflowStepInstance.SETRANGE("Original Workflow Step ID",WorkflowStep."Next Workflow Step ID");
      EXIT(WorkflowStepInstance.FINDFIRST);
    END;

    LOCAL PROCEDURE FindLastResponseWorkflowStepInstanceBeforeEvent@35(VAR WorkflowStepInstance@1000 : Record 1504;InstanceID@1003 : GUID;WorkflowCode@1002 : Code[20]);
    VAR
      NextWorkflowStepInstance@1001 : Record 1504;
      IsLastStep@1004 : Boolean;
      WorkflowStepInstanceNumber@1006 : Integer;
      i@1005 : Integer;
    BEGIN
      IF WorkflowStepInstance.Type = WorkflowStepInstance.Type::"Event" THEN
        EXIT;
      NextWorkflowStepInstance := WorkflowStepInstance;
      NextWorkflowStepInstance.SETCURRENTKEY(ID,"Workflow Code","Previous Workflow Step ID");
      NextWorkflowStepInstance.SETRANGE(ID,InstanceID);
      NextWorkflowStepInstance.SETRANGE("Workflow Code",WorkflowCode);
      WorkflowStepInstanceNumber := NextWorkflowStepInstance.COUNT - 1;
      REPEAT
        NextWorkflowStepInstance.SETRANGE("Previous Workflow Step ID",NextWorkflowStepInstance."Workflow Step ID");
        IF NOT NextWorkflowStepInstance.FINDFIRST THEN
          IsLastStep := TRUE;
        i += 1;
      UNTIL (NextWorkflowStepInstance.Type = NextWorkflowStepInstance.Type::"Event") OR IsLastStep OR (i = WorkflowStepInstanceNumber);
      IF IsLastStep THEN
        WorkflowStepInstance := NextWorkflowStepInstance
      ELSE
        WorkflowStepInstance.GET(InstanceID,WorkflowCode,NextWorkflowStepInstance."Previous Workflow Step ID");
    END;

    LOCAL PROCEDURE DeleteWorkflowSteps@1();
    VAR
      WorkflowStep@1000 : Record 1502;
    BEGIN
      WorkflowStep.SETRANGE("Workflow Code",Code);
      WorkflowStep.DELETEALL(TRUE);
    END;

    LOCAL PROCEDURE SetEntryPoint@2();
    VAR
      WorkflowStep@1000 : Record 1502;
    BEGIN
      WorkflowStep.SETRANGE("Workflow Code",Code);
      WorkflowStep.MODIFYALL("Entry Point",FALSE,TRUE);

      WorkflowStep.SETRANGE("Previous Workflow Step ID",0);
      IF WorkflowStep.FINDFIRST THEN BEGIN
        WorkflowStep.VALIDATE("Entry Point",TRUE);
        WorkflowStep.MODIFY(TRUE);
      END;
    END;

    LOCAL PROCEDURE ClearEntryPointIfFirst@25();
    VAR
      WorkflowStep@1000 : Record 1502;
    BEGIN
      WorkflowStep.SETRANGE("Workflow Code",Code);
      WorkflowStep.MODIFYALL("Entry Point",FALSE,FALSE);
    END;

    LOCAL PROCEDURE CheckEntryPointsAreEvents@4();
    VAR
      WorkflowStep@1000 : Record 1502;
    BEGIN
      WorkflowStep.SETRANGE("Workflow Code",Code);
      WorkflowStep.SETRANGE("Entry Point",TRUE);
      WorkflowStep.SETFILTER(Type,'<>%1',WorkflowStep.Type::"Event");

      IF NOT WorkflowStep.ISEMPTY THEN
        ERROR(EventOnlyEntryPointsErr);
    END;

    LOCAL PROCEDURE CheckEntryPointsAreNotSubWorkflows@16();
    VAR
      WorkflowStep@1000 : Record 1502;
    BEGIN
      WorkflowStep.SETRANGE("Workflow Code",Code);
      WorkflowStep.SETRANGE("Entry Point",TRUE);
      WorkflowStep.SETRANGE(Type,WorkflowStep.Type::"Sub-Workflow");

      IF NOT WorkflowStep.ISEMPTY THEN
        ERROR(EventOnlyEntryPointsErr);
    END;

    LOCAL PROCEDURE CheckSingleEntryPointAsRoot@19();
    VAR
      WorkflowStep@1000 : Record 1502;
    BEGIN
      WorkflowStep.SETRANGE("Workflow Code",Code);
      WorkflowStep.SETRANGE("Entry Point",TRUE);
      WorkflowStep.SETRANGE("Previous Workflow Step ID",0);

      IF WorkflowStep.COUNT <> 1 THEN
        ERROR(OneRootStepErr);
    END;

    LOCAL PROCEDURE CheckOrphansNotExist@5();
    VAR
      PreviousWorkflowStep@1002 : Record 1502;
      WorkflowStep@1000 : Record 1502;
    BEGIN
      WorkflowStep.SETRANGE("Workflow Code",Code);
      WorkflowStep.SETRANGE("Entry Point",FALSE);

      WorkflowStep.SETRANGE("Previous Workflow Step ID",0);
      IF NOT WorkflowStep.ISEMPTY THEN
        ERROR(OrphanWorkflowStepsErr);

      WorkflowStep.SETFILTER("Previous Workflow Step ID",'<>%1',0);
      IF WorkflowStep.FINDSET THEN
        REPEAT
          IF NOT PreviousWorkflowStep.GET(Code,WorkflowStep."Previous Workflow Step ID") THEN
            ERROR(OrphanWorkflowStepsErr);
        UNTIL WorkflowStep.NEXT = 0;
    END;

    LOCAL PROCEDURE CheckFunctionNames@17();
    VAR
      WorkflowStep@1000 : Record 1502;
    BEGIN
      WorkflowStep.SETRANGE("Workflow Code",Code);
      WorkflowStep.SETRANGE("Function Name",'');

      IF NOT WorkflowStep.ISEMPTY THEN
        ERROR(MissingFunctionNamesErr);
    END;

    LOCAL PROCEDURE CheckSubWorkflowsEnabled@11();
    VAR
      Workflow@1001 : Record 1501;
      WorkflowStep@1000 : Record 1502;
    BEGIN
      WorkflowStep.SETRANGE("Workflow Code",Code);
      WorkflowStep.SETRANGE(Type,WorkflowStep.Type::"Sub-Workflow");

      IF WorkflowStep.FINDSET THEN
        REPEAT
          Workflow.GET(WorkflowStep."Function Name");

          IF NOT Workflow.Enabled THEN
            ERROR(SubWorkflowNotEnabledErr,WorkflowStep."Function Name",Code);
        UNTIL WorkflowStep.NEXT = 0;
    END;

    LOCAL PROCEDURE CheckResponseOptions@8();
    VAR
      WorkflowStep@1003 : Record 1502;
      WorkflowResponseHandling@1001 : Codeunit 1521;
    BEGIN
      WorkflowStep.SETRANGE("Workflow Code",Code);
      WorkflowStep.SETRANGE(Type,WorkflowStep.Type::Response);

      IF WorkflowStep.FINDSET THEN
        REPEAT
          IF NOT WorkflowResponseHandling.HasRequiredArguments(WorkflowStep) THEN
            ERROR(MissingRespOptionsErr);
        UNTIL WorkflowStep.NEXT = 0;
    END;

    LOCAL PROCEDURE CheckEntryPointEventConditions@10();
    VAR
      ThisWorkflowStep@1004 : Record 1502;
      ThisWorkflowDefinition@1000 : Query 1502;
      SkipBlob@1002 : Boolean;
    BEGIN
      SkipBlob := TRUE;

      ThisWorkflowDefinition.SETRANGE(Code,Code);
      ThisWorkflowDefinition.SETRANGE(Entry_Point,TRUE);
      ThisWorkflowDefinition.SETRANGE(Type,ThisWorkflowDefinition.Type::"Event");
      ThisWorkflowDefinition.OPEN;

      WHILE ThisWorkflowDefinition.READ DO BEGIN
        ThisWorkflowStep.GET(ThisWorkflowDefinition.Code,ThisWorkflowDefinition.ID);
        CheckEntryPointsInSameWorkflow(ThisWorkflowStep,ThisWorkflowDefinition,SkipBlob);
        CheckEntryPointsInOtherEnabledWorkflows(ThisWorkflowStep,ThisWorkflowDefinition,SkipBlob);
      END;
    END;

    LOCAL PROCEDURE CheckEntryPointsInSameWorkflow@9(ThisWorkflowStep@1000 : Record 1502;ThisWorkflowDefinition@1001 : Query 1502;SkipBlob@1006 : Boolean);
    VAR
      OtherWorkflowStep@1004 : Record 1502;
      OtherWorkflowDefinition@1005 : Query 1502;
    BEGIN
      OtherWorkflowDefinition.SETRANGE(Code,ThisWorkflowDefinition.Code);
      OtherWorkflowDefinition.SETFILTER(ID,'<>%1',ThisWorkflowDefinition.ID);
      OtherWorkflowDefinition.SETRANGE(Entry_Point,TRUE);
      OtherWorkflowDefinition.SETRANGE(Type,OtherWorkflowDefinition.Type::"Event");
      OtherWorkflowDefinition.SETRANGE(Function_Name,ThisWorkflowDefinition.Function_Name);
      OtherWorkflowDefinition.SETRANGE(Table_ID,ThisWorkflowDefinition.Table_ID);
      OtherWorkflowDefinition.OPEN;

      WHILE OtherWorkflowDefinition.READ DO BEGIN
        OtherWorkflowStep.GET(OtherWorkflowDefinition.Code,OtherWorkflowDefinition.ID);
        CompareWorkflowStepArguments(ThisWorkflowStep,OtherWorkflowStep,ThisWorkflowDefinition,ThisWorkflowDefinition,SkipBlob);
      END;
    END;

    LOCAL PROCEDURE CheckEntryPointsInOtherEnabledWorkflows@20(ThisWorkflowStep@1000 : Record 1502;ThisWorkflowDefinition@1001 : Query 1502;SkipBlob@1006 : Boolean);
    VAR
      OtherWorkflowStep@1004 : Record 1502;
      OtherWorkflowDefinition@1005 : Query 1502;
    BEGIN
      OtherWorkflowDefinition.SETFILTER(Code,'<>%1',ThisWorkflowDefinition.Code);
      OtherWorkflowDefinition.SETRANGE(Enabled,TRUE);
      OtherWorkflowDefinition.SETRANGE(Entry_Point,TRUE);
      OtherWorkflowDefinition.SETRANGE(Type,OtherWorkflowDefinition.Type::"Event");
      OtherWorkflowDefinition.SETRANGE(Function_Name,ThisWorkflowDefinition.Function_Name);
      OtherWorkflowDefinition.SETRANGE(Table_ID,ThisWorkflowDefinition.Table_ID);
      OtherWorkflowDefinition.OPEN;

      WHILE OtherWorkflowDefinition.READ DO BEGIN
        OtherWorkflowStep.GET(OtherWorkflowDefinition.Code,OtherWorkflowDefinition.ID);
        CompareWorkflowStepArguments(ThisWorkflowStep,OtherWorkflowStep,ThisWorkflowDefinition,ThisWorkflowDefinition,SkipBlob);
      END;
    END;

    LOCAL PROCEDURE CheckEventTableRelation@28();
    VAR
      WorkflowStep@1000 : Record 1502;
      NextWorkflowStep@1003 : Record 1502;
      WorkflowEvent@1002 : Record 1520;
      WorkflowTableRelation@1005 : Record 1505;
      CurrentTable@1001 : Integer;
      NextTable@1004 : Integer;
    BEGIN
      WorkflowStep.SETRANGE("Workflow Code",Code);
      WorkflowStep.SETRANGE(Type,WorkflowStep.Type::"Event");
      IF WorkflowStep.FINDSET THEN
        REPEAT
          WorkflowEvent.GET(WorkflowStep."Function Name");
          CurrentTable := WorkflowEvent."Table ID";
          IF WorkflowStep.HasEventsInSubtree(NextWorkflowStep) THEN BEGIN
            WorkflowEvent.GET(NextWorkflowStep."Function Name");
            NextTable := WorkflowEvent."Table ID";
            IF CurrentTable <> NextTable THEN BEGIN
              WorkflowTableRelation.SETRANGE("Table ID",CurrentTable);
              WorkflowTableRelation.SETRANGE("Related Table ID",NextTable);
              IF WorkflowTableRelation.ISEMPTY THEN
                ERROR(ValidateTableRelationErr);
            END;
          END;
        UNTIL WorkflowStep.NEXT = 0;
    END;

    LOCAL PROCEDURE CheckRecordChangedWorkflows@29();
    VAR
      WorkflowStep@1000 : Record 1502;
      WorkflowResponseHandling@1001 : Codeunit 1521;
    BEGIN
      WorkflowStep.SETRANGE("Workflow Code",Code);
      WorkflowStep.SETRANGE(Type,WorkflowStep.Type::Response);
      WorkflowStep.SETRANGE("Function Name",WorkflowResponseHandling.RevertValueForFieldCode);
      IF NOT WorkflowStep.ISEMPTY THEN BEGIN
        WorkflowStep.SETRANGE("Function Name",WorkflowResponseHandling.ApplyNewValuesCode);
        IF WorkflowStep.ISEMPTY THEN
          ERROR(WorkflowMustApplySavedValuesErr);
      END;

      WorkflowStep.SETRANGE("Function Name",WorkflowResponseHandling.ApplyNewValuesCode);
      IF NOT WorkflowStep.ISEMPTY THEN BEGIN
        WorkflowStep.SETRANGE("Function Name",WorkflowResponseHandling.RevertValueForFieldCode);
        IF WorkflowStep.ISEMPTY THEN
          ERROR(WorkflowMustRevertValuesErr);
      END;
    END;

    LOCAL PROCEDURE CompareWorkflowStepArguments@3(ThisWorkflowStep@1004 : Record 1502;OtherWorkflowStep@1005 : Record 1502;ThisWorkflowDefinition@1000 : Query 1502;OtherWorkflowDefinition@1001 : Query 1502;SkipBlob@1003 : Boolean);
    VAR
      OtherWorkflowStepArgument@1007 : Record 1523;
      ThisWorkflowStepArgument@1006 : Record 1523;
      ThisWorkflowRule@1009 : Record 1524;
      OtherWorkflowRule@1008 : Record 1524;
      TableCaption@1002 : Text;
    BEGIN
      TableCaption := GetTableCaption(ThisWorkflowDefinition.Table_ID);

      IF ((NOT ThisWorkflowStepArgument.GET(ThisWorkflowDefinition.Argument)) AND
          (NOT ThisWorkflowStep.FindWorkflowRules(ThisWorkflowRule))) OR
         ((NOT OtherWorkflowStepArgument.GET(OtherWorkflowDefinition.Argument)) AND
          (NOT OtherWorkflowStep.FindWorkflowRules(OtherWorkflowRule)))
      THEN
        ERROR(SameEventConditionsErr,TableCaption);

      IF ThisWorkflowStepArgument.Equals(OtherWorkflowStepArgument,SkipBlob) AND
         ThisWorkflowStep.CompareEventConditions(OtherWorkflowStep) AND
         ThisWorkflowStep.CompareEventRule(OtherWorkflowStep)
      THEN
        ERROR(SameEventConditionsErr,TableCaption);
    END;

    LOCAL PROCEDURE GetTableCaption@26(TableID@1000 : Integer) : Text;
    VAR
      RecRef@1001 : RecordRef;
    BEGIN
      IF TableID = 0 THEN
        EXIT('');

      RecRef.OPEN(TableID);
      EXIT(RecRef.CAPTION);
    END;

    LOCAL PROCEDURE CheckEditingReferringWorkflowsIsAllowed@13();
    VAR
      Workflow@1002 : Record 1501;
      WorkflowStep@1001 : Record 1502;
      WorkflowDefinition@1000 : Query 1502;
    BEGIN
      WorkflowStep.SETRANGE(Type,WorkflowStep.Type::"Sub-Workflow");
      WorkflowStep.SETRANGE("Function Name",Code);

      IF NOT WorkflowStep.ISEMPTY THEN
        IF NOT CONFIRM(DisableReferringWorkflowsQst,FALSE,Code) THEN
          ERROR(DisableReferringWorkflowsErr,Code);

      WorkflowDefinition.SETFILTER(Code,'<>%1',Code);
      WorkflowDefinition.SETRANGE(Type,WorkflowDefinition.Type::"Sub-Workflow");
      WorkflowDefinition.SETRANGE(Function_Name,Code);
      WorkflowDefinition.SETRANGE(Enabled,TRUE);
      WorkflowDefinition.OPEN;

      WHILE WorkflowDefinition.READ DO BEGIN
        Workflow.GET(WorkflowDefinition.Code);
        Workflow.VALIDATE(Enabled,FALSE);
        Workflow.MODIFY(TRUE);
      END;
    END;

    [External]
    PROCEDURE CheckEditingIsAllowed@6();
    BEGIN
      IF Template THEN
        ERROR(CannotEditTemplateWorkflowErr);
      IF Enabled THEN
        ERROR(CannotEditEnabledWorkflowErr);
    END;

    LOCAL PROCEDURE CheckWorkflowCodeDoesNotExistAsTemplate@30();
    VAR
      Workflow@1000 : Record 1501;
    BEGIN
      Workflow.SETRANGE(Template,TRUE);
      Workflow.SETRANGE(Code,Code);
      IF NOT Workflow.ISEMPTY THEN
        ERROR(WorkflowExistsAsTemplateErr);
    END;

    [External]
    PROCEDURE LookupOtherWorkflowCode@7(VAR LookupCode@1001 : Code[20]) : Boolean;
    VAR
      Workflow@1000 : Record 1501;
    BEGIN
      Workflow.SETFILTER(Code,'<>%1',Code);

      IF PAGE.RUNMODAL(0,Workflow) = ACTION::LookupOK THEN BEGIN
        LookupCode := Workflow.Code;
        EXIT(TRUE);
      END;
    END;

    [External]
    PROCEDURE InsertAfterFunctionName@18(FunctionName@1001 : Code[128];NewFunctionName@1003 : Code[128];NewEntryPoint@1004 : Boolean;NewType@1005 : Option);
    VAR
      WorkflowStep@1000 : Record 1502;
      NewWorkflowStep@1002 : Record 1502;
    BEGIN
      WorkflowStep.SETRANGE("Workflow Code",Code);
      WorkflowStep.SETRANGE("Function Name",FunctionName);
      IF WorkflowStep.FINDSET THEN
        REPEAT
          NewWorkflowStep.INIT;
          NewWorkflowStep.VALIDATE("Workflow Code",Code);
          NewWorkflowStep.VALIDATE(Type,NewType);
          NewWorkflowStep.VALIDATE("Function Name",NewFunctionName);
          NewWorkflowStep.VALIDATE("Entry Point",NewEntryPoint);
          NewWorkflowStep.INSERT(TRUE);
          WorkflowStep.InsertAfterStep(NewWorkflowStep);
        UNTIL WorkflowStep.NEXT = 0;
    END;

    [Internal]
    PROCEDURE ExportToBlob@31(VAR TempBlob@1000 : Record 99008535);
    VAR
      OutStream@1001 : OutStream;
    BEGIN
      TempBlob.INIT;
      TempBlob.Blob.CREATEOUTSTREAM(OutStream);
      XMLPORT.EXPORT(XMLPORT::"Import / Export Workflow",OutStream,Rec);
    END;

    [Internal]
    PROCEDURE ImportFromBlob@32(VAR TempBlob@1000 : Record 99008535);
    VAR
      ImportExportWorkflow@1002 : XMLport 1501;
      InStream@1001 : InStream;
    BEGIN
      TempBlob.Blob.CREATEINSTREAM(InStream);
      ImportExportWorkflow.SETSOURCE(InStream);
      ImportExportWorkflow.InitWorkflow(Code);
      ImportExportWorkflow.SETTABLEVIEW(Rec);
      ImportExportWorkflow.IMPORT;
    END;

    PROCEDURE CanDelete@33(ThrowErrors@1000 : Boolean) : Boolean;
    VAR
      WorkflowStepInstance@1001 : Record 1504;
    BEGIN
      IF Enabled THEN
        EXIT(ThrowOrReturnFalse(ThrowErrors,CannotDeleteEnabledWorkflowErr));

      WorkflowStepInstance.SETRANGE("Workflow Code",Code);
      WorkflowStepInstance.SETRANGE(Status,WorkflowStepInstance.Status::Inactive,WorkflowStepInstance.Status::Active);
      IF NOT WorkflowStepInstance.ISEMPTY THEN
        EXIT(ThrowOrReturnFalse(ThrowErrors,CannotDeleteWorkflowWithActiveInstancesErr));

      IF Template THEN
        EXIT(ThrowOrReturnFalse(ThrowErrors,CannotDeleteWorkflowTemplatesErr));

      EXIT(TRUE);
    END;

    LOCAL PROCEDURE ThrowOrReturnFalse@34(ShouldThrow@1000 : Boolean;Message@1001 : Text) : Boolean;
    BEGIN
      IF ShouldThrow THEN
        ERROR(Message);

      EXIT(FALSE);
    END;

    BEGIN
    END.
  }
}

