OBJECT Table 5933 Service Order Posting Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Bogf.buffer til serviceordre;
               ENU=Service Order Posting Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Service Order No.   ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Serviceordrenr.;
                                                              ENU=Service Order No.] }
    { 2   ;   ;Entry Type          ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Posttype;
                                                              ENU=Entry Type];
                                                   OptionCaptionML=[DAN=Forbrug,Salg;
                                                                    ENU=Usage,Sale];
                                                   OptionString=Usage,Sale }
    { 3   ;   ;Posting Group Type  ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bogf›ringsgruppetype;
                                                              ENU=Posting Group Type];
                                                   OptionCaptionML=[DAN=" ,Ressource,Vare,Serviceomkostninger,Servicekontrakt";
                                                                    ENU=" ,Resource,Item,Service Cost,Service Contract"];
                                                   OptionString=[ ,Resource,Item,Service Cost,Service Contract] }
    { 4   ;   ;No.                 ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
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
    { 8   ;   ;Gen. Bus. Posting Group;Code20     ;TableRelation="Gen. Business Posting Group";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Virksomhedsbogf›ringsgruppe;
                                                              ENU=Gen. Bus. Posting Group] }
    { 9   ;   ;Gen. Prod. Posting Group;Code20    ;TableRelation="Gen. Product Posting Group";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Produktbogf›ringsgruppe;
                                                              ENU=Gen. Prod. Posting Group] }
    { 10  ;   ;Unit of Measure Code;Code10        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Enhedskode;
                                                              ENU=Unit of Measure Code] }
    { 11  ;   ;Work Type Code      ;Code10        ;TableRelation="Work Type";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Arbejdstypekode;
                                                              ENU=Work Type Code] }
    { 13  ;   ;Quantity            ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Antal;
                                                              ENU=Quantity];
                                                   DecimalPlaces=0:5 }
    { 14  ;   ;Total Cost          ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kostbel›b;
                                                              ENU=Total Cost];
                                                   AutoFormatType=1 }
    { 15  ;   ;Total Price         ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Salgsbel›b;
                                                              ENU=Total Price];
                                                   AutoFormatType=1 }
    { 16  ;   ;Appl.-to Service Entry;Integer     ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Udl.servicepostl›benr.;
                                                              ENU=Appl.-to Service Entry] }
    { 17  ;   ;Service Contract No.;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Servicekontraktnr.;
                                                              ENU=Service Contract No.] }
    { 18  ;   ;Service Item No.    ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Serviceartikelnr.;
                                                              ENU=Service Item No.] }
    { 21  ;   ;Qty. to Invoice     ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Fakturer (antal);
                                                              ENU=Qty. to Invoice];
                                                   AutoFormatType=1 }
    { 22  ;   ;Location Code       ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code] }
    { 23  ;   ;Dimension Entry No. ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dimensionsl›benr.;
                                                              ENU=Dimension Entry No.] }
    { 24  ;   ;Line Discount %     ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Linjerabatpct.;
                                                              ENU=Line Discount %] }
    { 480 ;   ;Dimension Set ID    ;Integer       ;TableRelation="Dimension Set Entry";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dimensionsgruppe-id;
                                                              ENU=Dimension Set ID];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Service Order No.,Entry Type,Posting Group Type,No.,Gen. Bus. Posting Group,Gen. Prod. Posting Group,Global Dimension 1 Code,Global Dimension 2 Code,Unit of Measure Code,Service Item No.,Location Code,Appl.-to Service Entry;
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

