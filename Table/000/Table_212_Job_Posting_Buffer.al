OBJECT Table 212 Job Posting Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Sagsbogf›ringsbuffer;
               ENU=Job Posting Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Job No.             ;Code20        ;TableRelation=Job;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Sagsnr.;
                                                              ENU=Job No.] }
    { 2   ;   ;Entry Type          ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Posttype;
                                                              ENU=Entry Type];
                                                   OptionCaptionML=[DAN=Forbrug,Salg;
                                                                    ENU=Usage,Sale];
                                                   OptionString=Usage,Sale }
    { 3   ;   ;Posting Group Type  ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bogf›ringsgruppetype;
                                                              ENU=Posting Group Type];
                                                   OptionCaptionML=[DAN=Ressource,Vare,Finanskonto;
                                                                    ENU=Resource,Item,G/L Account];
                                                   OptionString=Resource,Item,G/L Account }
    { 4   ;   ;No.                 ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 5   ;   ;Posting Group       ;Code20        ;TableRelation="Job Posting Group";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bogf›ringsgruppe;
                                                              ENU=Posting Group] }
    { 6   ;   ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Global dimension 1-kode;
                                                              ENU=Global Dimension 1 Code];
                                                   CaptionClass='1,1,1' }
    { 7   ;   ;Global Dimension 2 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Global dimension 2-kode;
                                                              ENU=Global Dimension 2 Code];
                                                   CaptionClass='1,1,2' }
    { 8   ;   ;Unit of Measure Code;Code10        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Enhedskode;
                                                              ENU=Unit of Measure Code] }
    { 9   ;   ;Work Type Code      ;Code10        ;TableRelation="Work Type";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Arbejdstypekode;
                                                              ENU=Work Type Code] }
    { 20  ;   ;Amount              ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bel›b;
                                                              ENU=Amount];
                                                   AutoFormatType=1 }
    { 21  ;   ;Quantity            ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Antal;
                                                              ENU=Quantity];
                                                   DecimalPlaces=0:5 }
    { 22  ;   ;Total Cost          ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kostbel›b;
                                                              ENU=Total Cost];
                                                   AutoFormatType=1 }
    { 23  ;   ;Total Price         ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Salgsbel›b;
                                                              ENU=Total Price];
                                                   AutoFormatType=1 }
    { 24  ;   ;Applies-to ID       ;Code50        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Udlignings-id;
                                                              ENU=Applies-to ID] }
    { 25  ;   ;Gen. Bus. Posting Group;Code20     ;TableRelation="Gen. Business Posting Group";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Virksomhedsbogf›ringsgruppe;
                                                              ENU=Gen. Bus. Posting Group] }
    { 26  ;   ;Gen. Prod. Posting Group;Code20    ;TableRelation="Gen. Product Posting Group";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Produktbogf›ringsgruppe;
                                                              ENU=Gen. Prod. Posting Group] }
    { 27  ;   ;Additional-Currency Amount;Decimal ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Ekstra valuta (bel›b);
                                                              ENU=Additional-Currency Amount];
                                                   AutoFormatType=1 }
    { 28  ;   ;Dimension Entry No. ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dimensionsl›benr.;
                                                              ENU=Dimension Entry No.] }
    { 29  ;   ;Variant Code        ;Code10        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Variantkode;
                                                              ENU=Variant Code] }
    { 480 ;   ;Dimension Set ID    ;Integer       ;TableRelation="Dimension Set Entry";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dimensionsgruppe-id;
                                                              ENU=Dimension Set ID];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Job No.,Entry Type,Posting Group Type,No.,Variant Code,Posting Group,Gen. Bus. Posting Group,Gen. Prod. Posting Group,Unit of Measure Code,Work Type Code,Dimension Entry No.;
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

