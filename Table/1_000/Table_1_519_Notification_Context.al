OBJECT Table 1519 Notification Context
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
               Created := CURRENTDATETIME;
             END;

    OnModify=BEGIN
               Created := CURRENTDATETIME;
             END;

    CaptionML=[DAN=Notifikationskontekst;
               ENU=Notification Context];
  }
  FIELDS
  {
    { 1   ;   ;Notification ID     ;GUID          ;CaptionML=[DAN=Notifikations-id;
                                                              ENU=Notification ID] }
    { 2   ;   ;Record ID           ;RecordID      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Record-id;
                                                              ENU=Record ID] }
    { 3   ;   ;Additional Context ID;GUID         ;CaptionML=[DAN=Yderligere kontekst-id;
                                                              ENU=Additional Context ID] }
    { 4   ;   ;Created             ;DateTime      ;CaptionML=[DAN=Oprettet;
                                                              ENU=Created] }
  }
  KEYS
  {
    {    ;Notification ID                         ;Clustered=Yes }
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

