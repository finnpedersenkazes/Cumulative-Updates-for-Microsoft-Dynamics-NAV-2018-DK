OBJECT Table 1662 Payroll Import Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=L›nimportbuffer;
               ENU=Payroll Import Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;AutoIncrement=Yes;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=L›benummer;
                                                              ENU=Entry No.] }
    { 10  ;   ;Transaction date    ;Date          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Transaktionsdato;
                                                              ENU=Transaction date] }
    { 11  ;   ;Account No.         ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kontonr.;
                                                              ENU=Account No.] }
    { 12  ;   ;Amount              ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bel›b;
                                                              ENU=Amount] }
    { 13  ;   ;Description         ;Text50        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
  }
  KEYS
  {
    {    ;Entry No.                               ;Clustered=Yes }
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

