OBJECT Table 7330 Bin Content Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Placeringsindh.buffer;
               ENU=Bin Content Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Location Code       ;Code10        ;TableRelation=Location;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code];
                                                   NotBlank=Yes }
    { 2   ;   ;Zone Code           ;Code10        ;TableRelation=Zone.Code WHERE (Location Code=FIELD(Location Code));
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Zonekode;
                                                              ENU=Zone Code];
                                                   NotBlank=Yes }
    { 3   ;   ;Bin Code            ;Code20        ;TableRelation=IF (Zone Code=FILTER('')) Bin.Code WHERE (Location Code=FIELD(Location Code))
                                                                 ELSE IF (Zone Code=FILTER(<>'')) Bin.Code WHERE (Location Code=FIELD(Location Code),
                                                                                                                  Zone Code=FIELD(Zone Code));
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Placeringskode;
                                                              ENU=Bin Code];
                                                   NotBlank=Yes }
    { 4   ;   ;Item No.            ;Code20        ;TableRelation=Item;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Varenr.;
                                                              ENU=Item No.];
                                                   NotBlank=Yes }
    { 5   ;   ;Variant Code        ;Code10        ;TableRelation="Item Variant".Code WHERE (Item No.=FIELD(Item No.));
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Variantkode;
                                                              ENU=Variant Code] }
    { 6   ;   ;Unit of Measure Code;Code10        ;TableRelation="Item Unit of Measure".Code WHERE (Item No.=FIELD(Item No.));
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Enhedskode;
                                                              ENU=Unit of Measure Code] }
    { 10  ;   ;Cubage              ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Rumm†l;
                                                              ENU=Cubage];
                                                   DecimalPlaces=0:5 }
    { 11  ;   ;Weight              ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=V‘gt;
                                                              ENU=Weight];
                                                   DecimalPlaces=0:5 }
    { 12  ;   ;Base Unit of Measure;Code10        ;TableRelation="Item Unit of Measure".Code WHERE (Item No.=FIELD(Item No.));
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Basisenhed;
                                                              ENU=Base Unit of Measure] }
    { 50  ;   ;Qty. to Handle (Base);Decimal      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=H†ndteringsantal (basis);
                                                              ENU=Qty. to Handle (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 51  ;   ;Qty. Outstanding (Base);Decimal    ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Antal udest†ende (basis);
                                                              ENU=Qty. Outstanding (Base)];
                                                   DecimalPlaces=0:5 }
    { 6500;   ;Lot No.             ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Lotnr.;
                                                              ENU=Lot No.] }
    { 6501;   ;Serial No.          ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Serienr.;
                                                              ENU=Serial No.] }
  }
  KEYS
  {
    {    ;Location Code,Bin Code,Item No.,Variant Code,Unit of Measure Code,Lot No.,Serial No.;
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

