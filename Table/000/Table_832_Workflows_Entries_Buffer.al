OBJECT Table 832 Workflows Entries Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Buffer for workflowposter;
               ENU=Workflows Entries Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Created by Application;Option      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Oprettet af program;
                                                              ENU=Created by Application];
                                                   OptionCaptionML=[DAN=Microsoft Flow,Dynamics 365,Dynamics NAV;
                                                                    ENU=Microsoft Flow,Dynamics 365,Dynamics NAV];
                                                   OptionString=Microsoft Flow,Dynamics 365,Dynamics NAV }
    { 2   ;   ;Entry No.           ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=L�benummer;
                                                              ENU=Entry No.] }
    { 3   ;   ;Workflow Step Instance ID;GUID     ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Id for workflowtrininstans;
                                                              ENU=Workflow Step Instance ID] }
    { 4   ;   ;Record ID           ;RecordID      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Record-id;
                                                              ENU=Record ID] }
    { 5   ;   ;Initiated By User ID;Code50        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Iv�rksat af bruger-id;
                                                              ENU=Initiated By User ID] }
    { 6   ;   ;To Be Approved By User ID;Code50   ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Skal godkendes af bruger-id;
                                                              ENU=To Be Approved By User ID] }
    { 7   ;   ;Date-Time Initiated ;DateTime      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dato/klokkesl�t for iv�rks�ttelse;
                                                              ENU=Date-Time Initiated] }
    { 8   ;   ;Last Date-Time Modified;DateTime   ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dato/klokkesl�t for seneste �ndring;
                                                              ENU=Last Date-Time Modified] }
    { 9   ;   ;Last Modified By User ID;Code50    ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bruger-id for seneste �ndring;
                                                              ENU=Last Modified By User ID] }
    { 10  ;   ;Status              ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Status;
                                                              ENU=Status];
                                                   OptionCaptionML=[DAN="Oprettet,�ben,Annulleret,Afvist,Godkendt, ";
                                                                    ENU="Created,Open,Canceled,Rejected,Approved, "];
                                                   OptionString=[Created,Open,Canceled,Rejected,Approved, ] }
    { 11  ;   ;Response            ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Svar;
                                                              ENU=Response];
                                                   OptionCaptionML=[DAN="Uventet,Ventende,Annuller,Forts�t,Afvis, ";
                                                                    ENU="NotExpected,Pending,Cancel,Continue,Reject, "];
                                                   OptionString=[NotExpected,Pending,Cancel,Continue,Reject, ] }
    { 12  ;   ;Amount              ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bel�b;
                                                              ENU=Amount] }
    { 13  ;   ;Due Date            ;Date          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Forfaldsdato;
                                                              ENU=Due Date] }
  }
  KEYS
  {
    {    ;Workflow Step Instance ID               ;Clustered=Yes }
    {    ;Entry No.                                }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    PROCEDURE AddWorkflowWebhookEntry@4(WorkflowWebhookEntry@1000 : Record 467;VAR WorkflowsCounter@1001 : Integer);
    BEGIN
      IF NOT GET(WorkflowWebhookEntry."Workflow Step Instance ID") THEN BEGIN
        WorkflowsCounter := WorkflowsCounter + 1;
        INIT;
        "Created by Application" := "Created by Application"::"Microsoft Flow";
        "Entry No." := WorkflowWebhookEntry."Entry No.";
        "Workflow Step Instance ID" := WorkflowWebhookEntry."Workflow Step Instance ID";
        "Record ID" := WorkflowWebhookEntry."Record ID";
        "Initiated By User ID" := WorkflowWebhookEntry."Initiated By User ID";
        "Date-Time Initiated" := WorkflowWebhookEntry."Date-Time Initiated";
        "Last Date-Time Modified" := WorkflowWebhookEntry."Last Date-Time Modified";
        "Last Modified By User ID" := WorkflowWebhookEntry."Last Modified By User ID";
        Response := WorkflowWebhookEntry.Response;
        Status := Status::" ";
        INSERT;
      END;
    END;

    PROCEDURE AddApprovalEntry@5(ApprovalEntry@1000 : Record 454;VAR WorkflowsCounter@1001 : Integer);
    VAR
      AzureAdMgt@1002 : Codeunit 6300;
    BEGIN
      IF NOT GET(ApprovalEntry."Workflow Step Instance ID") THEN BEGIN
        WorkflowsCounter := WorkflowsCounter + 1;
        INIT;
        IF AzureAdMgt.IsSaaS THEN
          "Created by Application" := "Created by Application"::"Dynamics 365"
        ELSE
          "Created by Application" := "Created by Application"::"Dynamics NAV";
        "Entry No." := WorkflowsCounter;
        "Workflow Step Instance ID" := ApprovalEntry."Workflow Step Instance ID";
        "Record ID" := ApprovalEntry."Record ID to Approve";
        "Initiated By User ID" := ApprovalEntry."Sender ID";
        "To Be Approved By User ID" := ApprovalEntry."Approver ID";
        "Date-Time Initiated" := ApprovalEntry."Date-Time Sent for Approval";
        "Last Date-Time Modified" := ApprovalEntry."Last Date-Time Modified";
        "Last Modified By User ID" := ApprovalEntry."Last Modified By User ID";
        Status := ApprovalEntry.Status;
        Response := Response::" ";
        "Due Date" := ApprovalEntry."Due Date";
        INSERT;
      END;
    END;

    [External]
    PROCEDURE RunWorkflowEntriesPage@1(RecordIDInput@1002 : RecordID;TableId@1008 : Integer;DocumentType@1007 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';DocumentNo@1000 : Code[20]);
    VAR
      ApprovalEntry@1006 : Record 454;
      WorkflowWebhookEntry@1001 : Record 467;
      Approvals@1004 : Page 832;
      WorkflowWebhookEntries@1003 : Page 830;
      ApprovalEntries@1005 : Page 658;
    BEGIN
      // if we are looking at a particular record, we want to see only record related workflow entries
      IF DocumentNo <> '' THEN BEGIN
        ApprovalEntry.SETRANGE("Record ID to Approve",RecordIDInput);
        WorkflowWebhookEntry.SETRANGE("Record ID",RecordIDInput);
        // if we have flows created by multiple applications, start generic page filtered for this RecordID
        IF ApprovalEntry.FINDFIRST AND WorkflowWebhookEntry.FINDFIRST THEN BEGIN
          Approvals.Setfilters(RecordIDInput);
          Approvals.RUN;
        END ELSE BEGIN
          // otherwise, open the page filtered for this record that corresponds to the type of the flow
          IF WorkflowWebhookEntry.FINDFIRST THEN BEGIN
            WorkflowWebhookEntries.Setfilters(RecordIDInput);
            WorkflowWebhookEntries.RUN;
            EXIT;
          END;

          IF ApprovalEntry.FINDFIRST THEN BEGIN
            ApprovalEntries.Setfilters(TableId,DocumentType,DocumentNo);
            ApprovalEntries.RUN;
            EXIT;
          END;

          // if no workflow exist, show (empty) joint workflows page
          Approvals.Setfilters(RecordIDInput);
          Approvals.RUN;
        END
      END ELSE
        // otherwise, open the page with all workflow entries
        Approvals.RUN;
    END;

    BEGIN
    END.
  }
}

