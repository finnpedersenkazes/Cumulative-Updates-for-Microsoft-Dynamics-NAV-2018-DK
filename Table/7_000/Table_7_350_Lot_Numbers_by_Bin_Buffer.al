OBJECT Table 7350 Lot Numbers by Bin Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Lotnumre efter placeringsbuffer;
               ENU=Lot Numbers by Bin Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Item No.            ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Varenr.;
                                                              ENU=Item No.] }
    { 2   ;   ;Variant Code        ;Code10        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Variantkode;
                                                              ENU=Variant Code] }
    { 3   ;   ;Location Code       ;Code10        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code] }
    { 4   ;   ;Zone Code           ;Code10        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Zonekode;
                                                              ENU=Zone Code] }
    { 5   ;   ;Bin Code            ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Placeringskode;
                                                              ENU=Bin Code] }
    { 6   ;   ;Lot No.             ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Lotnr.;
                                                              ENU=Lot No.] }
    { 7   ;   ;Qty. (Base)         ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Antal (basis);
                                                              ENU=Qty. (Base)];
                                                   DecimalPlaces=0:5 }
  }
  KEYS
  {
    {    ;Item No.,Variant Code,Location Code,Zone Code,Bin Code,Lot No.;
                                                   Clustered=Yes }
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

