OBJECT Table 469 Workflow Webhook Subscription
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               Id := CREATEGUID;
               "User Id" := USERID;
               "Created Date" := CURRENTDATETIME;
             END;

    OnModify=VAR
               WorkflowWebhookSubscriptionPreviousRec@1000 : Record 469;
               WorkflowWebhookSubBuffer@1001 : Record 1542;
             BEGIN
               // Inserting new record also calls OnModify so checking to ensure it's a proper insert rather than modify
               IF IsInsert THEN BEGIN
                 // Check if incoming Rec's Client ID exists already
                 WorkflowWebhookSubscriptionPreviousRec.SETRANGE("Client Id","Client Id");
                 WorkflowWebhookSubscriptionPreviousRec.SETRANGE(Enabled,TRUE);
                 WorkflowWebhookSubscriptionPreviousRec.SETCURRENTKEY("Created Date");
                 WorkflowWebhookSubscriptionPreviousRec.SETASCENDING("Created Date",FALSE);
                 IF WorkflowWebhookSubscriptionPreviousRec.FINDFIRST THEN
                   // will be creating new workflow so disable previous one
                   DisableWorkflow(WorkflowWebhookSubscriptionPreviousRec."WF Definition Id")
                 ELSE BEGIN
                   WorkflowWebhookSubBuffer.SETRANGE("Client Id","Client Id");
                   IF WorkflowWebhookSubBuffer.FINDSET THEN BEGIN
                     REPEAT
                       DisableWorkflow(WorkflowWebhookSubBuffer."WF Definition Id");
                     UNTIL WorkflowWebhookSubBuffer.NEXT = 0;
                   END;
                 END;

                 CreateWorkflowDefinition;
                 EnableSubscriptionAndWorkflow(Rec);
               END;
             END;

    OnDelete=VAR
               Workflow@1000 : Record 1501;
               WorkflowWebhookSubBuffer@1001 : Record 1542;
               IsTaskSchedulerAllowed@1002 : Boolean;
             BEGIN
               // this would also clean up related Workflow table entry and Workflow Steps
               IF Workflow.GET("WF Definition Id") THEN BEGIN
                 WorkflowWebhookSubBuffer.INIT;
                 WorkflowWebhookSubBuffer."WF Definition Id" := "WF Definition Id";
                 WorkflowWebhookSubBuffer."Client Id" := "Client Id";
                 WorkflowWebhookSubBuffer.INSERT;

                 IsTaskSchedulerAllowed := TRUE;
                 OnFindTaskSchedulerAllowed(IsTaskSchedulerAllowed);

                 IF IsTaskSchedulerAllowed THEN
                   TASKSCHEDULER.CREATETASK(CODEUNIT::"Workflow Webhook Sub Delete",0,TRUE,
                     COMPANYNAME,0DT,Workflow.RECORDID)
                 ELSE
                   CODEUNIT.RUN(CODEUNIT::"Workflow Webhook Sub Delete",Workflow);
               END;
             END;

    CaptionML=[DAN=Workflow for webhook-abonnement;
               ENU=Workflow Webhook Subscription];
  }
  FIELDS
  {
    { 1   ;   ;Id                  ;GUID          ;CaptionML=[DAN=Id;
                                                              ENU=Id] }
    { 2   ;   ;WF Definition Id    ;Code20        ;CaptionML=[DAN=Id for workflowdefinition;
                                                              ENU=WF Definition Id] }
    { 3   ;   ;Conditions          ;BLOB          ;CaptionML=[DAN=Betingelser;
                                                              ENU=Conditions] }
    { 4   ;   ;Notification Url    ;BLOB          ;CaptionML=[DAN=URL-adresse for notifikation;
                                                              ENU=Notification Url] }
    { 5   ;   ;Enabled             ;Boolean       ;CaptionML=[DAN=Aktiveret;
                                                              ENU=Enabled] }
    { 6   ;   ;User Id             ;Code50        ;DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User Id] }
    { 7   ;   ;Client Id           ;GUID          ;CaptionML=[DAN=Klient-id;
                                                              ENU=Client Id] }
    { 8   ;   ;Client Type         ;Text50        ;CaptionML=[DAN=Klienttype;
                                                              ENU=Client Type] }
    { 9   ;   ;Event Code          ;Code128       ;CaptionML=[DAN=H�ndelseskode;
                                                              ENU=Event Code] }
    { 10  ;   ;Created Date        ;DateTime      ;CaptionML=[DAN=Oprettelsesdato;
                                                              ENU=Created Date] }
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
    VAR
      WorkflowWebhookSetup@1004 : Codeunit 1540;
      UnableToParseEncodingErr@1003 : TextConst 'DAN=Der kunne ikke parses betingelser. De angivne betingelser var ikke det korrekte Base64-kodede format.;ENU=Unable to parse the Conditions. The provided Conditions were not in the correct Base64 encoded format.';
      UnableToParseInvalidJsonErr@1000 : TextConst 'DAN=Betingelserne kunne ikke parses. De angivne betingelsers JSON er ugyldigt.;ENU=Unable to parse the Conditions. The provided Conditions JSON was invalid.';
      NoControlOnPageErr@1005 : TextConst '@@@="%1=control name;%2=page name";DAN=Der blev ikke fundet et felt med kontrolelementnavnet ''%1''p� side ''%2''.;ENU=Unable to find a field with control name ''%1'' on page ''%2''.';
      JSONManagement@1006 : Codeunit 5459;
      UnableToParseJsonArrayErr@1001 : TextConst '@@@="%1=conditions property name";DAN=''%1'' kunne ikke parses, fordi det ikke var en gyldig JSON-matrix.;ENU=Unable to parse ''%1'' because it was not a valid JSON array.';

    PROCEDURE SetConditions@5(ConditionsTxt@1000 : Text);
    VAR
      StreamOutObj@1001 : OutStream;
    BEGIN
      // store as blob
      CLEAR(Conditions);
      Conditions.CREATEOUTSTREAM(StreamOutObj);
      StreamOutObj.WRITETEXT(ConditionsTxt);
    END;

    PROCEDURE SetNotificationUrl@6(NotificationURLTxt@1001 : Text);
    VAR
      StreamOutObj@1000 : OutStream;
    BEGIN
      // store as blob
      CLEAR("Notification Url");
      "Notification Url".CREATEOUTSTREAM(StreamOutObj);
      StreamOutObj.WRITETEXT(NotificationURLTxt);
    END;

    PROCEDURE GetConditions@4() ConditionsText : Text;
    VAR
      ReadStream@1000 : InStream;
    BEGIN
      CALCFIELDS(Conditions);
      Conditions.CREATEINSTREAM(ReadStream);
      ReadStream.READTEXT(ConditionsText);
    END;

    PROCEDURE GetNotificationUrl@2() NotificationUrlText : Text;
    VAR
      ReadStream@1000 : InStream;
    BEGIN
      CALCFIELDS("Notification Url");
      "Notification Url".CREATEINSTREAM(ReadStream);
      ReadStream.READTEXT(NotificationUrlText);
    END;

    LOCAL PROCEDURE CreateWorkflowDefinition@40();
    VAR
      EventConditions@1003 : Text;
    BEGIN
      EventConditions := CreateEventConditions(GetConditions,"Event Code");

      // the second argument, Name, is empty at this point by design (hardcoded to be a text constant inside the function)
      "WF Definition Id" := WorkflowWebhookSetup.CreateWorkflowDefinition("Event Code",'',EventConditions,USERID);
    END;

    LOCAL PROCEDURE IsInsert@55() : Boolean;
    BEGIN
      // This is how we know a new record is being inserted into table
      EXIT("WF Definition Id" = '');
    END;

    LOCAL PROCEDURE EnableSubscription@3(VAR WorkflowWebhookSubscriptionRec@1000 : Record 469);
    BEGIN
      // Turn On a Subscription
      WorkflowWebhookSubscriptionRec.Enabled := TRUE;
      WorkflowWebhookSubscriptionRec.MODIFY;
    END;

    LOCAL PROCEDURE EnableWorkflow@34(WorkflowCode@1000 : Code[20]);
    VAR
      Workflow@1001 : Record 1501;
    BEGIN
      // Enable a workflow
      IF Workflow.GET(WorkflowCode) THEN BEGIN
        Workflow.VALIDATE(Enabled,TRUE);
        Workflow.MODIFY;
      END;
    END;

    LOCAL PROCEDURE DisableWorkflow@22(WorkflowCode@1000 : Code[20]);
    VAR
      Workflow@1001 : Record 1501;
    BEGIN
      // Disable a workflow
      IF Workflow.GET(WorkflowCode) THEN BEGIN
        Workflow.VALIDATE(Enabled,FALSE);
        Workflow.MODIFY;
      END;
    END;

    LOCAL PROCEDURE EnableSubscriptionAndWorkflow@36(VAR WorkflowWebhookSubscriptionRec@1000 : Record 469);
    BEGIN
      // Enable Subscription and its corresponding Workflow
      EnableSubscription(WorkflowWebhookSubscriptionRec);
      EnableWorkflow(WorkflowWebhookSubscriptionRec."WF Definition Id");
    END;

    PROCEDURE CreateEventConditions@1(ConditionsTxt@1000 : Text;EventCode@1015 : Code[128]) : Text;
    VAR
      WorkflowEventHandling@1013 : Codeunit 1520;
      RequestPageParametersHelper@1002 : Codeunit 1530;
      EventConditions@1001 : FilterPageBuilder;
      ConditionsObject@1005 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JObject";
      ConditionsCount@1006 : Integer;
    BEGIN
      IF NOT TryDecodeConditions(ConditionsTxt) THEN
        SendAndLogError(GETLASTERRORTEXT,UnableToParseEncodingErr);

      IF NOT TryParseJson(ConditionsTxt,ConditionsObject) THEN
        SendAndLogError(GETLASTERRORTEXT,UnableToParseInvalidJsonErr);

      ConditionsCount := 1;
      CASE EventCode OF
        WorkflowEventHandling.RunWorkflowOnSendSalesDocForApprovalCode:
          BEGIN
            AddEventConditionsWrapper(
              'HeaderConditions',ConditionsObject,PAGE::"Sales Document Entity",EventConditions,ConditionsCount);
            AddEventConditionsWrapper(
              'LinesConditions',ConditionsObject,PAGE::"Sales Document Line Entity",EventConditions,ConditionsCount);
            EXIT(
              RequestPageParametersHelper.GetViewFromDynamicRequestPage(
                EventConditions,WorkflowWebhookSetup.GetSalesDocCategoryTxt,DATABASE::"Sales Header"));
          END;
        WorkflowEventHandling.RunWorkflowOnSendPurchaseDocForApprovalCode:
          BEGIN
            AddEventConditionsWrapper(
              'HeaderConditions',ConditionsObject,PAGE::"Purchase Document Entity",EventConditions,ConditionsCount);
            AddEventConditionsWrapper(
              'LinesConditions',ConditionsObject,PAGE::"Purchase Document Line Entity",EventConditions,ConditionsCount);
            EXIT(
              RequestPageParametersHelper.GetViewFromDynamicRequestPage(
                EventConditions,WorkflowWebhookSetup.GetPurchaseDocCategoryTxt,DATABASE::"Purchase Header"));
          END;
        WorkflowEventHandling.RunWorkflowOnSendGeneralJournalBatchForApprovalCode:
          BEGIN
            AddEventConditionsWrapper(
              'Conditions',ConditionsObject,PAGE::"Gen. Journal Batch Entity",EventConditions,ConditionsCount);
            EXIT(
              RequestPageParametersHelper.GetViewFromDynamicRequestPage(
                EventConditions,WorkflowWebhookSetup.GetFinCategoryTxt,DATABASE::"Gen. Journal Batch"));
          END;
        WorkflowEventHandling.RunWorkflowOnSendGeneralJournalLineForApprovalCode:
          BEGIN
            AddEventConditionsWrapper(
              'Conditions',ConditionsObject,PAGE::"Gen. Journal Line Entity",EventConditions,ConditionsCount);
            EXIT(
              RequestPageParametersHelper.GetViewFromDynamicRequestPage(
                EventConditions,WorkflowWebhookSetup.GetFinCategoryTxt,DATABASE::"Gen. Journal Line"));
          END;
        WorkflowEventHandling.RunWorkflowOnSendCustomerForApprovalCode:
          BEGIN
            AddEventConditionsWrapper(
              'Conditions',ConditionsObject,PAGE::"Workflow - Customer Entity",EventConditions,ConditionsCount);
            EXIT(
              RequestPageParametersHelper.GetViewFromDynamicRequestPage(
                EventConditions,WorkflowWebhookSetup.GetSalesMktCategoryTxt,DATABASE::Customer));
          END;
        WorkflowEventHandling.RunWorkflowOnSendItemForApprovalCode:
          BEGIN
            AddEventConditionsWrapper(
              'Conditions',ConditionsObject,PAGE::"Workflow - Item Entity",EventConditions,ConditionsCount);
            EXIT(
              RequestPageParametersHelper.GetViewFromDynamicRequestPage(
                EventConditions,WorkflowWebhookSetup.GetSalesMktCategoryTxt,DATABASE::Item));
          END;
        WorkflowEventHandling.RunWorkflowOnSendVendorForApprovalCode:
          BEGIN
            AddEventConditionsWrapper(
              'Conditions',ConditionsObject,PAGE::"Workflow - Vendor Entity",EventConditions,ConditionsCount);
            EXIT(
              RequestPageParametersHelper.GetViewFromDynamicRequestPage(
                EventConditions,WorkflowWebhookSetup.GetPurchPayCategoryTxt,DATABASE::Vendor));
          END
        ELSE
          SendAndLogError(
            STRSUBSTNO(WorkflowWebhookSetup.GetUnsupportedWorkflowEventCodeErr,EventCode),
            STRSUBSTNO(WorkflowWebhookSetup.GetUnsupportedWorkflowEventCodeErr,EventCode));
      END;
    END;

    LOCAL PROCEDURE AddEventConditionsWrapper@8(ConditionsPropertyName@1000 : Text;ConditionsObject@1002 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JObject";SourcePageNo@1005 : Integer;VAR EventConditions@1003 : FilterPageBuilder;VAR ConditionsCount@1001 : Integer);
    VAR
      ConditionsCollection@1004 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JObject";
    BEGIN
      IF ConditionsObject.TryGetValue(ConditionsPropertyName,ConditionsCollection) THEN BEGIN
        IF NOT TryInitializeCollection(ConditionsCollection) THEN
          SendAndLogError(GETLASTERRORTEXT,STRSUBSTNO(UnableToParseJsonArrayErr,ConditionsPropertyName));
        AddEventConditions(ConditionsCollection,EventConditions,SourcePageNo,ConditionsCount);
        ConditionsCount := ConditionsCount + 1;
      END;
    END;

    [TryFunction]
    LOCAL PROCEDURE TryInitializeCollection@20(VAR ConditionsCollection@1000 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JObject");
    BEGIN
      JSONManagement.InitializeCollectionFromJArray(ConditionsCollection);
      // need to do some action on the collection to check if it is of Collection type
      IF JSONManagement.GetCollectionCount < 0 THEN
        ERROR(GETLASTERRORTEXT);
    END;

    LOCAL PROCEDURE AddEventConditions@31(ConditionsArray@1000 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JObject";VAR EventConditions@1008 : FilterPageBuilder;SourcePageNo@1014 : Integer;ConditionIndex@1011 : Integer);
    VAR
      TableMetadata@1005 : Record 2000000136;
      PageControlField@1006 : Record 2000000192;
      RecRef@1003 : RecordRef;
      FieldRef@1002 : FieldRef;
      ConditionName@1010 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JObject";
      Condition@1001 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JObject";
      ConditionValue@1007 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JObject";
      FieldId@1004 : Integer;
      tableNo@1009 : Integer;
    BEGIN
      // get source table id
      PageControlField.SETFILTER(PageNo,'%1',SourcePageNo);
      PageControlField.FINDFIRST;
      tableNo := PageControlField.TableNo;
      RecRef.OPEN(tableNo);

      PageControlField.RESET;
      PageControlField.SETFILTER(PageNo,'%1',SourcePageNo);

      FOREACH Condition IN ConditionsArray DO
        IF Condition.TryGetValue('Name',ConditionName) AND Condition.TryGetValue('Value',ConditionValue) THEN BEGIN
          // get id of the field from the page in the page's source table
          PageControlField.SETFILTER(ControlName,ConditionName.ToString);
          IF NOT PageControlField.FINDFIRST THEN
            SendAndLogError(GETLASTERRORTEXT,STRSUBSTNO(NoControlOnPageErr,ConditionName.ToString,GetPageName(SourcePageNo)));

          FieldId := PageControlField.FieldNo;
          FieldRef := RecRef.FIELD(FieldId);

          // filter Header/Lines Table
          // throws an error message if can not convert types
          FieldRef.SETFILTER(ConditionValue.ToString);
        END;

      // create Filter Page Builder
      TableMetadata.GET(tableNo);
      EventConditions.ADDTABLE(TableMetadata.Caption,tableNo);
      EventConditions.SETVIEW(EventConditions.NAME(ConditionIndex),RecRef.GETVIEW);
    END;

    [TryFunction]
    LOCAL PROCEDURE TryParseJson@7(ConditionsTxt@1000 : Text;VAR ConditionsArray@1001 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JObject");
    BEGIN
      JSONManagement.InitializeObject(ConditionsTxt);
      JSONManagement.GetJSONObject(ConditionsArray);
    END;

    [TryFunction]
    LOCAL PROCEDURE TryDecodeConditions@30(VAR ConditionsTxt@1000 : Text);
    VAR
      Convert@1002 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Convert";
      Encoding@1001 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Text.Encoding";
    BEGIN
      ConditionsTxt := Encoding.UTF8.GetString(Convert.FromBase64String(ConditionsTxt));
    END;

    LOCAL PROCEDURE SendAndLogError@47(ErrorText@1000 : Text;Description@1003 : Text);
    VAR
      Company@1002 : Record 2000000006;
      ActivityLog@1001 : Record 710;
    BEGIN
      // log exact error message
      Company.GET(COMPANYNAME);
      ActivityLog.LogActivityForUser(
        Company.RECORDID,ActivityLog.Status::Failed,'Microsoft Flow',Description,ErrorText,USERID);
      // send descriptive error to user
      ERROR(Description);
    END;

    PROCEDURE GetPageName@58(PageId@1000 : Integer) : Text;
    VAR
      AllObj@1001 : Record 2000000038;
    BEGIN
      AllObj.SETFILTER("Object ID",FORMAT(PageId));
      AllObj.SETFILTER("Object Type",'PAGE');
      AllObj.FINDFIRST;
      EXIT(AllObj."Object Name");
    END;

    PROCEDURE GetUnableToParseEncodingErr@10() : Text;
    BEGIN
      EXIT(UnableToParseEncodingErr);
    END;

    PROCEDURE GetUnableToParseInvalidJsonErr@13() : Text;
    BEGIN
      EXIT(UnableToParseInvalidJsonErr);
    END;

    PROCEDURE GetNoControlOnPageErr@14() : Text;
    BEGIN
      EXIT(NoControlOnPageErr);
    END;

    PROCEDURE GetUnableToParseJsonArrayErr@15() : Text;
    BEGIN
      EXIT(UnableToParseJsonArrayErr);
    END;

    [Integration]
    LOCAL PROCEDURE OnFindTaskSchedulerAllowed@9(VAR IsTaskSchedulingAllowed@1000 : Boolean);
    BEGIN
    END;

    BEGIN
    END.
  }
}

