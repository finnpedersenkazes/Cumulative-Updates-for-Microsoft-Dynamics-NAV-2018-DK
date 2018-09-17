OBJECT Table 347 Close Income Statement Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Nulstil res.opg.buffer;
               ENU=Close Income Statement Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Closing Date        ;Date          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Ultimodato;
                                                              ENU=Closing Date] }
    { 2   ;   ;G/L Account No.     ;Code20        ;TableRelation="G/L Account";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Finanskontonr.;
                                                              ENU=G/L Account No.] }
  }
  KEYS
  {
    {    ;Closing Date,G/L Account No.            ;Clustered=Yes }
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

