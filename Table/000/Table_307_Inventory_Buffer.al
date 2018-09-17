OBJECT Table 307 Inventory Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Modt/lev. beholdningsbuffer;
               ENU=Inventory Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Item No.            ;Code20        ;TableRelation=Item;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Varenr.;
                                                              ENU=Item No.] }
    { 4   ;   ;Location Code       ;Code10        ;TableRelation=Location;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code] }
    { 5   ;   ;Quantity            ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Antal;
                                                              ENU=Quantity];
                                                   DecimalPlaces=0:5 }
    { 6   ;   ;Dimension Entry No. ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dimensionsl›benr.;
                                                              ENU=Dimension Entry No.] }
    { 5400;   ;Variant Code        ;Code10        ;TableRelation="Item Variant".Code WHERE (Item No.=FIELD(Item No.));
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Variantkode;
                                                              ENU=Variant Code] }
    { 5401;   ;Bin Code            ;Code20        ;TableRelation=Bin.Code WHERE (Location Code=FIELD(Location Code));
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Placeringskode;
                                                              ENU=Bin Code] }
    { 6500;   ;Serial No.          ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Serienr.;
                                                              ENU=Serial No.] }
    { 6501;   ;Lot No.             ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Lotnr.;
                                                              ENU=Lot No.] }
  }
  KEYS
  {
    {    ;Item No.,Variant Code,Dimension Entry No.,Location Code,Bin Code,Lot No.,Serial No.;
                                                   Clustered=Yes }
    {    ;Location Code,Variant Code,Quantity     ;SumIndexFields=Quantity }
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

