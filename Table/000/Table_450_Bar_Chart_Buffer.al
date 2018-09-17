OBJECT Table 450 Bar Chart Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Diagrambuffer;
               ENU=Bar Chart Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Series No.          ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Serienr.;
                                                              ENU=Series No.] }
    { 2   ;   ;Column No.          ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kolonnenr.;
                                                              ENU=Column No.] }
    { 3   ;   ;Y Value             ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Y-v‘rdi;
                                                              ENU=Y Value] }
    { 4   ;   ;X Value             ;Text100       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=X-v‘rdi;
                                                              ENU=X Value] }
    { 5   ;   ;Tag                 ;Text250       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kode;
                                                              ENU=Tag] }
  }
  KEYS
  {
    {    ;Series No.                              ;Clustered=Yes }
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

