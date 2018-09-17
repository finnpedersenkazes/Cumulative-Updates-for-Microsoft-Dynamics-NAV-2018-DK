OBJECT Table 53 Batch Processing Parameter Map
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Parameteroversigt for k›rselsbehandling;
               ENU=Batch Processing Parameter Map];
  }
  FIELDS
  {
    { 1   ;   ;Record ID           ;RecordID      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Record-id;
                                                              ENU=Record ID] }
    { 2   ;   ;Batch ID            ;GUID          ;CaptionML=[DAN=K›rsel-id;
                                                              ENU=Batch ID] }
  }
  KEYS
  {
    {    ;Record ID                               ;Clustered=Yes }
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

