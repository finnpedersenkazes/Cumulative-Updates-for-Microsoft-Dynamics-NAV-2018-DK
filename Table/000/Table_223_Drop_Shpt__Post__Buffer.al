OBJECT Table 223 Drop Shpt. Post. Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Dir.lev. bogf.buffer;
               ENU=Drop Shpt. Post. Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Order No.           ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Ordrenr.;
                                                              ENU=Order No.] }
    { 2   ;   ;Order Line No.      ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Ordrelinjenr.;
                                                              ENU=Order Line No.] }
    { 3   ;   ;Item Shpt. Entry No.;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Varelev.postl›benr.;
                                                              ENU=Item Shpt. Entry No.] }
    { 4   ;   ;Quantity            ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Antal;
                                                              ENU=Quantity];
                                                   DecimalPlaces=0:5 }
    { 5   ;   ;Quantity (Base)     ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Antal (basis);
                                                              ENU=Quantity (Base)];
                                                   DecimalPlaces=0:5 }
  }
  KEYS
  {
    {    ;Order No.,Order Line No.                ;Clustered=Yes }
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

