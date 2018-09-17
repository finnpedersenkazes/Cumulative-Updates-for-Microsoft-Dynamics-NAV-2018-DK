OBJECT Table 5641 FA Buffer Projection
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Anl‘gsbudgetbuffer;
               ENU=FA Buffer Projection];
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=L›benr.;
                                                              ENU=Entry No.] }
    { 2   ;   ;FA Posting Date     ;Date          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bogf›ringsdato for anl‘g;
                                                              ENU=FA Posting Date] }
    { 3   ;   ;Depreciation        ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Afskrivning;
                                                              ENU=Depreciation];
                                                   AutoFormatType=1 }
    { 4   ;   ;Custom 1            ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bruger 1;
                                                              ENU=Custom 1];
                                                   AutoFormatType=1 }
    { 5   ;   ;Code Name           ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kodenavn;
                                                              ENU=Code Name] }
  }
  KEYS
  {
    {    ;Code Name,FA Posting Date,Entry No.     ;Clustered=Yes }
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

