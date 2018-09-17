OBJECT Table 1750 Fields Sync Status
{
  OBJECT-PROPERTIES
  {
    Date=06-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21441;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Status for feltsynkronisering;
               ENU=Fields Sync Status];
  }
  FIELDS
  {
    { 1   ;   ;ID                  ;Code2         ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Id;
                                                              ENU=ID] }
    { 2   ;   ;Last Sync Date Time ;DateTime      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dato/klokkesl‘t for seneste synkronisering;
                                                              ENU=Last Sync Date Time] }
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

