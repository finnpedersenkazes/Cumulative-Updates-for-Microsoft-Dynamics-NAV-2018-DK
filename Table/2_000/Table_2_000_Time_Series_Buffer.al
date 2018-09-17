OBJECT Table 2000 Time Series Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Buffer for tidsserie;
               ENU=Time Series Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Group ID            ;Code50        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Gruppe-id;
                                                              ENU=Group ID] }
    { 2   ;   ;Period No.          ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Periodenr.;
                                                              ENU=Period No.] }
    { 3   ;   ;Period Start Date   ;Date          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Periodes startdato;
                                                              ENU=Period Start Date] }
    { 4   ;   ;Value               ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=V‘rdi;
                                                              ENU=Value] }
  }
  KEYS
  {
    {    ;Group ID,Period No.                     ;Clustered=Yes }
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

