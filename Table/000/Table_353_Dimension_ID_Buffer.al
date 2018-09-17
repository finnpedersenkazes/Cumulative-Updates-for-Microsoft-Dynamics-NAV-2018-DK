OBJECT Table 353 Dimension ID Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Dimensions-id-buffer;
               ENU=Dimension ID Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Parent ID           ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Id for overordnet;
                                                              ENU=Parent ID] }
    { 2   ;   ;Dimension Code      ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dimensionskode;
                                                              ENU=Dimension Code] }
    { 3   ;   ;Dimension Value     ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dimensionsv‘rdi;
                                                              ENU=Dimension Value] }
    { 4   ;   ;ID                  ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Id;
                                                              ENU=ID] }
  }
  KEYS
  {
    {    ;Parent ID,Dimension Code,Dimension Value;Clustered=Yes }
    {    ;ID                                       }
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

