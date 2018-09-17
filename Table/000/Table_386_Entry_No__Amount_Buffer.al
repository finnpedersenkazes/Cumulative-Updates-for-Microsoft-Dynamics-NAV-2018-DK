OBJECT Table 386 Entry No. Amount Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=L›benr. - Bel›bsbuffer;
               ENU=Entry No. Amount Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=L›benr.;
                                                              ENU=Entry No.] }
    { 2   ;   ;Amount              ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bel›b;
                                                              ENU=Amount];
                                                   AutoFormatType=1 }
    { 3   ;   ;Amount2             ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bel›b 2;
                                                              ENU=Amount2];
                                                   AutoFormatType=1 }
    { 4   ;   ;Business Unit Code  ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Konc.virksomhedskode;
                                                              ENU=Business Unit Code] }
    { 5   ;   ;Start Date          ;Date          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Startdato;
                                                              ENU=Start Date] }
    { 6   ;   ;End Date            ;Date          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Slutdato;
                                                              ENU=End Date] }
  }
  KEYS
  {
    {    ;Business Unit Code,Entry No.            ;Clustered=Yes }
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

