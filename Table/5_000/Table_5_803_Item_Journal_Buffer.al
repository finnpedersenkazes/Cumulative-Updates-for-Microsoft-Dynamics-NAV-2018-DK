OBJECT Table 5803 Item Journal Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Varekladdebuffer;
               ENU=Item Journal Buffer];
  }
  FIELDS
  {
    { 2   ;   ;Line No.            ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Linjenr.;
                                                              ENU=Line No.] }
    { 3   ;   ;Item No.            ;Code20        ;TableRelation=Item;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Varenr.;
                                                              ENU=Item No.] }
    { 8   ;   ;Location Code       ;Code10        ;TableRelation=Location;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code] }
    { 12  ;   ;Quantity            ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Antal;
                                                              ENU=Quantity];
                                                   DecimalPlaces=0:5 }
    { 5402;   ;Variant Code        ;Code10        ;TableRelation="Item Variant".Code WHERE (Item No.=FIELD(Item No.));
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Variantkode;
                                                              ENU=Variant Code] }
    { 5802;   ;Inventory Value (Calculated);Decimal;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Lagerv‘rdi (beregnet);
                                                              ENU=Inventory Value (Calculated)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
  }
  KEYS
  {
    {    ;Line No.                                ;Clustered=Yes }
    {    ;Item No.,Location Code,Variant Code      }
    {    ;Item No.,Variant Code                    }
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

