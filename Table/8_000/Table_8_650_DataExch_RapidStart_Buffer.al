OBJECT Table 8650 DataExch-RapidStart Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=DataExch-RapidStart Buffer;
               ENU=DataExch-RapidStart Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Node ID             ;Text250       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Node-id;
                                                              ENU=Node ID] }
    { 2   ;   ;RapidStart No.      ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=RapidStart-nr.;
                                                              ENU=RapidStart No.] }
  }
  KEYS
  {
    {    ;Node ID                                 ;Clustered=Yes }
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

