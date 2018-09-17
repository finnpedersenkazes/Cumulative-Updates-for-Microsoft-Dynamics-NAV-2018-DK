OBJECT Table 1522 Workflow Event Queue
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Workflowh‘ndelsesk›;
               ENU=Workflow Event Queue];
  }
  FIELDS
  {
    { 1   ;   ;ID                  ;Integer       ;AutoIncrement=Yes;
                                                   CaptionML=[DAN=Id;
                                                              ENU=ID] }
    { 2   ;   ;Session ID          ;Integer       ;CaptionML=[DAN=Sessions-id;
                                                              ENU=Session ID] }
    { 3   ;   ;Step Record ID      ;RecordID      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Trinrecord-id;
                                                              ENU=Step Record ID] }
    { 4   ;   ;Record ID           ;RecordID      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Record-id;
                                                              ENU=Record ID] }
    { 5   ;   ;Status              ;Option        ;CaptionML=[DAN=Status;
                                                              ENU=Status];
                                                   OptionCaptionML=[DAN=I k›,Udf›rer,Udf›rt;
                                                                    ENU=Queued,Executing,Executed];
                                                   OptionString=Queued,Executing,Executed }
    { 6   ;   ;Record Index        ;Integer       ;CaptionML=[DAN=Indeks for record;
                                                              ENU=Record Index] }
    { 7   ;   ;xRecord Index       ;Integer       ;CaptionML=[@@@={Locked};
                                                              DAN=xRecord Index;
                                                              ENU=xRecord Index] }
  }
  KEYS
  {
    {    ;ID                                      ;Clustered=Yes }
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

