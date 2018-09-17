OBJECT Table 283 Line Number Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Linjenummerbuffer;
               ENU=Line Number Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Old Line Number     ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Gammelt linjenr.;
                                                              ENU=Old Line Number] }
    { 2   ;   ;New Line Number     ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Nyt linjenr.;
                                                              ENU=New Line Number] }
  }
  KEYS
  {
    {    ;Old Line Number                         ;Clustered=Yes }
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

