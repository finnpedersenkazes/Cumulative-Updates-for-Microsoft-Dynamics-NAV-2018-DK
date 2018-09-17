OBJECT Table 5890 Error Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Fejlbuffer;
               ENU=Error Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Error No.           ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Fejlnr.;
                                                              ENU=Error No.] }
    { 2   ;   ;Error Text          ;Text250       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Fejltekst;
                                                              ENU=Error Text] }
    { 3   ;   ;Source Table        ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kildetabel;
                                                              ENU=Source Table] }
    { 4   ;   ;Source No.          ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kildenr.;
                                                              ENU=Source No.] }
    { 5   ;   ;Source Ref. No.     ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kildereferencenr.;
                                                              ENU=Source Ref. No.] }
  }
  KEYS
  {
    {    ;Error No.                               ;Clustered=Yes }
    {    ;Source Table,Source No.,Source Ref. No.  }
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

