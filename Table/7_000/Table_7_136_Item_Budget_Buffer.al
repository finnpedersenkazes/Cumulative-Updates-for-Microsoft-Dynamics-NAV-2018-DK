OBJECT Table 7136 Item Budget Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Varebudgetbuffer;
               ENU=Item Budget Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Item No.            ;Code20        ;TableRelation=Item;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Varenr.;
                                                              ENU=Item No.] }
    { 2   ;   ;Source Type         ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kildetype;
                                                              ENU=Source Type];
                                                   OptionCaptionML=[DAN=" ,Debitor,Kreditor,Vare";
                                                                    ENU=" ,Customer,Vendor,Item"];
                                                   OptionString=[ ,Customer,Vendor,Item] }
    { 3   ;   ;Source No.          ;Code20        ;TableRelation=IF (Source Type=CONST(Customer)) Customer
                                                                 ELSE IF (Source Type=CONST(Vendor)) Vendor
                                                                 ELSE IF (Source Type=CONST(Item)) Item;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kildenr.;
                                                              ENU=Source No.] }
    { 4   ;   ;Location Code       ;Code10        ;TableRelation=Location;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code] }
    { 5   ;   ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Global dimension 1-kode;
                                                              ENU=Global Dimension 1 Code];
                                                   CaptionClass='1,1,1' }
    { 6   ;   ;Global Dimension 2 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Global dimension 2-kode;
                                                              ENU=Global Dimension 2 Code];
                                                   CaptionClass='1,1,2' }
    { 7   ;   ;Budget Dimension 1 Code;Code20     ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Budgetdimension 1-kode;
                                                              ENU=Budget Dimension 1 Code] }
    { 8   ;   ;Budget Dimension 2 Code;Code20     ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Budgetdimension 2-kode;
                                                              ENU=Budget Dimension 2 Code] }
    { 9   ;   ;Budget Dimension 3 Code;Code20     ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Budgetdimension 3-kode;
                                                              ENU=Budget Dimension 3 Code] }
    { 10  ;   ;Date                ;Date          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dato;
                                                              ENU=Date] }
    { 11  ;   ;Quantity            ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Antal;
                                                              ENU=Quantity];
                                                   DecimalPlaces=0:5 }
    { 12  ;   ;Sales Amount        ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Salgsbel›b;
                                                              ENU=Sales Amount];
                                                   AutoFormatType=1 }
    { 13  ;   ;Cost Amount         ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kostbel›b;
                                                              ENU=Cost Amount];
                                                   AutoFormatType=1 }
    { 480 ;   ;Dimension Set ID    ;Integer       ;TableRelation="Dimension Set Entry";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dimensionsgruppe-id;
                                                              ENU=Dimension Set ID];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Item No.,Source Type,Source No.,Location Code,Global Dimension 1 Code,Global Dimension 2 Code,Budget Dimension 1 Code,Budget Dimension 2 Code,Budget Dimension 3 Code,Date;
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

