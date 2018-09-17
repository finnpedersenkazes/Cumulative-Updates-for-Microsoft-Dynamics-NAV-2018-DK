OBJECT Table 5487 Balance Sheet Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Balancebuffer;
               ENU=Balance Sheet Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Line No.            ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Linjenr.;
                                                              ENU=Line No.] }
    { 2   ;   ;Description         ;Text250       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 3   ;   ;Balance             ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Saldo;
                                                              ENU=Balance] }
    { 4   ;   ;Date Filter         ;Date          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Datofilter;
                                                              ENU=Date Filter] }
    { 6   ;   ;Line Type           ;Text30        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Linjetype;
                                                              ENU=Line Type] }
    { 7   ;   ;Indentation         ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Indrykning;
                                                              ENU=Indentation] }
  }
  KEYS
  {
    {    ;Line No.                                ;Clustered=Yes }
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

