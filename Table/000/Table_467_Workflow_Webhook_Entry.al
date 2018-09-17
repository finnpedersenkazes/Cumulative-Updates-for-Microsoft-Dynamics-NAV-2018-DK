OBJECT Table 467 Workflow Webhook Entry
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    OnModify=BEGIN
               "Last Date-Time Modified" := CREATEDATETIME(TODAY,TIME);
               "Last Modified By User ID" := USERID;
             END;

    CaptionML=[DAN=Webhook-workflowpost;
               ENU=Workflow Webhook Entry];
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;AutoIncrement=Yes;
                                                   CaptionML=[DAN=L�benummer;
                                                              ENU=Entry No.] }
    { 3   ;   ;Workflow Step Instance ID;GUID     ;CaptionML=[DAN=Id for workflowtrininstans;
                                                              ENU=Workflow Step Instance ID] }
    { 5   ;   ;Initiated By User ID;Code50        ;OnLookup=BEGIN
                                                              UserMgt.LookupUserID("Initiated By User ID");
                                                            END;

                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Iv�rksat af bruger-id;
                                                              ENU=Initiated By User ID] }
    { 7   ;   ;Response            ;Option        ;CaptionML=[DAN=Svar;
                                                              ENU=Response];
                                                   OptionCaptionML=[DAN=Ikke forventet,Ventende,Annuller,Forts�t,Afvis;
                                                                    ENU=NotExpected,Pending,Cancel,Continue,Reject];
                                                   OptionString=NotExpected,Pending,Cancel,Continue,Reject }
    { 8   ;   ;Response Argument   ;GUID          ;CaptionML=[DAN=Svarargument;
                                                              ENU=Response Argument] }
    { 9   ;   ;Date-Time Initiated ;DateTime      ;CaptionML=[DAN=Dato/klokkesl�t for iv�rks�ttelse;
                                                              ENU=Date-Time Initiated] }
    { 11  ;   ;Last Date-Time Modified;DateTime   ;CaptionML=[DAN=Dato/tidspunkt for sidste �ndring;
                                                              ENU=Last Date-Time Modified] }
    { 13  ;   ;Last Modified By User ID;Code50    ;OnLookup=BEGIN
                                                              UserMgt.LookupUserID("Last Modified By User ID");
                                                            END;

                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id for seneste �ndring;
                                                              ENU=Last Modified By User ID] }
    { 15  ;   ;Data ID             ;GUID          ;CaptionML=[DAN=Data-id;
                                                              ENU=Data ID] }
    { 17  ;   ;Record ID           ;RecordID      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Record-id;
                                                              ENU=Record ID] }
  }
  KEYS
  {
    {    ;Entry No.                               ;Clustered=Yes }
    {    ;Workflow Step Instance ID                }
    {    ;Data ID                                  }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      UserMgt@1000 : Codeunit 418;
      PageManagement@1001 : Codeunit 700;

    PROCEDURE SetDefaultFilter@1(VAR WorkflowWebhookEntry@1000 : Record 467);
    VAR
      UserSetup@1002 : Record 91;
      IsApprovalAdmin@1001 : Boolean;
      ResponseUserID@1005 : Code[50];
    BEGIN
      IsApprovalAdmin := FALSE;

      IF UserSetup.GET(USERID) THEN BEGIN
        IF UserSetup."Approval Administrator" THEN
          IsApprovalAdmin := TRUE;
      END;

      CLEAR(WorkflowWebhookEntry);
      WorkflowWebhookEntry.INIT;
      WorkflowWebhookEntry.SETRANGE(Response,WorkflowWebhookEntry.Response::Pending);

      IF NOT IsApprovalAdmin THEN BEGIN
        IF WorkflowWebhookEntry.FINDSET THEN
          REPEAT
            IF WorkflowWebhookEntry."Initiated By User ID" = USERID THEN
              WorkflowWebhookEntry.MARK(TRUE)
            ELSE
              // Look to see if the entry is awaiting a response from the active user
              IF GetResponseUserIdFromArgument(WorkflowWebhookEntry."Response Argument",ResponseUserID) THEN
                IF ResponseUserID = USERID THEN
                  WorkflowWebhookEntry.MARK(TRUE);
          UNTIL WorkflowWebhookEntry.NEXT = 0;
        WorkflowWebhookEntry.MARKEDONLY(TRUE);
      END;
    END;

    LOCAL PROCEDURE GetResponseUserIdFromArgument@9(Argument@1000 : GUID;VAR ResponseUserID@1002 : Code[50]) : Boolean;
    VAR
      WorkflowStepArgument@1001 : Record 1523;
    BEGIN
      CLEAR(ResponseUserID);

      IF NOT ISNULLGUID(Argument) THEN BEGIN
        WorkflowStepArgument.INIT;
        IF WorkflowStepArgument.GET(Argument) THEN
          CASE WorkflowStepArgument."Response Type" OF
            WorkflowStepArgument."Response Type"::"User ID":
              BEGIN
                ResponseUserID := WorkflowStepArgument."Response User ID";
                EXIT(TRUE);
              END;
          END;
      END;

      EXIT(FALSE);
    END;

    [Internal]
    PROCEDURE ShowRecord@2();
    VAR
      RecRef@1000 : RecordRef;
    BEGIN
      // When called on a Workflow Webhook Entry row, finds the associated parent record and navigates to
      // the appropriate page to show that record.
      // Used by the Flow Entries page. Based on code from the Approval Entries page/Approval Entry table.
      IF NOT RecRef.GET("Record ID") THEN
        EXIT;
      RecRef.SETRECFILTER;
      PageManagement.PageRun(RecRef);
    END;

    BEGIN
    END.
  }
}

