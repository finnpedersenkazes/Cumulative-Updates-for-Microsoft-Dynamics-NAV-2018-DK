OBJECT Table 1530 Workflow Step Instance Archive
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    Permissions=TableData 1531=md;
    OnDelete=VAR
               WorkflowStepArgumentArchive@1000 : Record 1531;
             BEGIN
               IF WorkflowStepArgumentArchive.GET(Argument) THEN
                 WorkflowStepArgumentArchive.DELETE(TRUE);
             END;

    CaptionML=[DAN=Arkiv for workflowtrininstans;
               ENU=Workflow Step Instance Archive];
  }
  FIELDS
  {
    { 1   ;   ;ID                  ;GUID          ;CaptionML=[DAN=Id;
                                                              ENU=ID] }
    { 2   ;   ;Workflow Code       ;Code20        ;CaptionML=[DAN=Workflowkode;
                                                              ENU=Workflow Code] }
    { 3   ;   ;Workflow Step ID    ;Integer       ;CaptionML=[DAN=Id for workflowtrin;
                                                              ENU=Workflow Step ID] }
    { 4   ;   ;Description         ;Text100       ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 9   ;   ;Entry Point         ;Boolean       ;CaptionML=[DAN=Startpunkt;
                                                              ENU=Entry Point] }
    { 11  ;   ;Record ID           ;RecordID      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Record-id;
                                                              ENU=Record ID] }
    { 12  ;   ;Created Date-Time   ;DateTime      ;CaptionML=[DAN=Oprettet dato/klokkesl‘t;
                                                              ENU=Created Date-Time];
                                                   Editable=No }
    { 13  ;   ;Created By User ID  ;Code50        ;DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Oprettet af bruger-id;
                                                              ENU=Created By User ID];
                                                   Editable=No }
    { 14  ;   ;Last Modified Date-Time;DateTime   ;CaptionML=[DAN=Dato/klokkesl‘t for seneste ‘ndring;
                                                              ENU=Last Modified Date-Time];
                                                   Editable=No }
    { 15  ;   ;Last Modified By User ID;Code50    ;TableRelation=User."User Name";
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id for seneste ‘ndring;
                                                              ENU=Last Modified By User ID];
                                                   Editable=No }
    { 17  ;   ;Status              ;Option        ;CaptionML=[DAN=Status;
                                                              ENU=Status];
                                                   OptionCaptionML=[DAN=Inaktiv,Aktiv,Afsluttet,Ignoreret,Behandler;
                                                                    ENU=Inactive,Active,Completed,Ignored,Processing];
                                                   OptionString=Inactive,Active,Completed,Ignored,Processing }
    { 18  ;   ;Previous Workflow Step ID;Integer  ;CaptionML=[DAN=Id for foreg†ende workflowtrin;
                                                              ENU=Previous Workflow Step ID] }
    { 19  ;   ;Next Workflow Step ID;Integer      ;CaptionML=[DAN=Id for n‘ste workflowtrin;
                                                              ENU=Next Workflow Step ID] }
    { 21  ;   ;Type                ;Option        ;CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=H‘ndelse,Svar;
                                                                    ENU=Event,Response];
                                                   OptionString=Event,Response }
    { 22  ;   ;Function Name       ;Code128       ;CaptionML=[DAN=Funktionsnavn;
                                                              ENU=Function Name] }
    { 23  ;   ;Argument            ;GUID          ;CaptionML=[DAN=Argument;
                                                              ENU=Argument] }
    { 30  ;   ;Original Workflow Code;Code20      ;CaptionML=[DAN=Oprindelig workflowkode;
                                                              ENU=Original Workflow Code] }
    { 31  ;   ;Original Workflow Step ID;Integer  ;CaptionML=[DAN=Id for oprindeligt workflowtrin;
                                                              ENU=Original Workflow Step ID] }
    { 32  ;   ;Sequence No.        ;Integer       ;CaptionML=[DAN=R‘kkef›lgenr.;
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

    BEGIN
    END.
  }
}

