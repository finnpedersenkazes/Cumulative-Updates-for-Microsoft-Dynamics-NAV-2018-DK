OBJECT Table 8450 Field Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Feltbuffer;
               ENU=Field Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Order               ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Ordre;
                                                              ENU=Order] }
    { 2   ;   ;Table ID            ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Tabel-id;
                                                              ENU=Table ID] }
    { 3   ;   ;Field ID            ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Felt-id;
                                                              ENU=Field ID] }
  }
  KEYS
  {
    {    ;Order                                   ;Clustered=Yes }
    {    ;Table ID,Field ID                        }
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

