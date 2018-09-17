OBJECT Table 1019 Job Difference Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Sagsdifferencebuffer;
               ENU=Job Difference Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Job No.             ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Sagsnr.;
                                                              ENU=Job No.] }
    { 2   ;   ;Job Task No.        ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Sagsopgavenr.;
                                                              ENU=Job Task No.] }
    { 3   ;   ;Type                ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=Ressource,Vare,Finanskonto;
                                                                    ENU=Resource,Item,G/L Account];
                                                   OptionString=Resource,Item,G/L Account }
    { 4   ;   ;Location Code       ;Code10        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code] }
    { 5   ;   ;Variant Code        ;Code10        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Variantkode;
                                                              ENU=Variant Code] }
    { 6   ;   ;Unit of Measure code;Code10        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=M†leenhedskode;
                                                              ENU=Unit of Measure code] }
    { 7   ;   ;Entry type          ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Posttype;
                                                              ENU=Entry type];
                                                   OptionCaptionML=[DAN=Budget,Forbrug;
                                                                    ENU=Budget,Usage];
                                                   OptionString=Budget,Usage }
    { 8   ;   ;Work Type Code      ;Code10        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Arbejdstypekode;
                                                              ENU=Work Type Code] }
    { 9   ;   ;No.                 ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 10  ;   ;Quantity            ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Antal;
                                                              ENU=Quantity] }
    { 11  ;   ;Total Cost          ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kostbel›b;
                                                              ENU=Total Cost] }
    { 12  ;   ;Line Amount         ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Linjebel›b;
                                                              ENU=Line Amount] }
  }
  KEYS
  {
    {    ;Job No.,Job Task No.,Type,Entry type,No.,Location Code,Variant Code,Unit of Measure code,Work Type Code;
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

