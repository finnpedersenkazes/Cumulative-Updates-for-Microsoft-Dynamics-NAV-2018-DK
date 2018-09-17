OBJECT Table 1542 Workflow Webhook Sub Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Underbuffer for workflow-webhook;
               ENU=Workflow Webhook Sub Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Id                  ;Integer       ;AutoIncrement=Yes;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Id;
                                                              ENU=Id] }
    { 2   ;   ;WF Definition Id    ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Id for workflowdefinition;
                                                              ENU=WF Definition Id] }
    { 3   ;   ;Client Id           ;GUID          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Klient-id;
                                                              ENU=Client Id] }
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

    BEGIN
    END.
  }
}

