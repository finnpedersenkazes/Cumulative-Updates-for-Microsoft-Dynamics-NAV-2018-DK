OBJECT Table 331 Adjust Exchange Rate Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Reguler valutakursbuffer;
               ENU=Adjust Exchange Rate Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Valutakode;
                                                              ENU=Currency Code] }
    { 2   ;   ;Posting Group       ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bogf›ringsgruppe;
                                                              ENU=Posting Group] }
    { 3   ;   ;AdjBase             ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=RegGrundlag;
                                                              ENU=AdjBase];
                                                   AutoFormatType=1 }
    { 4   ;   ;AdjBaseLCY          ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=RegGrundlagRV;
                                                              ENU=AdjBaseLCY];
                                                   AutoFormatType=1 }
    { 5   ;   ;AdjAmount           ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=RegBel›b;
                                                              ENU=AdjAmount];
                                                   AutoFormatType=1 }
    { 6   ;   ;TotalGainsAmount    ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=TotalGevinstBel›b;
                                                              ENU=TotalGainsAmount];
                                                   AutoFormatType=1 }
    { 7   ;   ;TotalLossesAmount   ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=TotalTabBel›b;
                                                              ENU=TotalLossesAmount];
                                                   AutoFormatType=1 }
    { 8   ;   ;Dimension Entry No. ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dimensionsl›benr.;
                                                              ENU=Dimension Entry No.] }
    { 9   ;   ;Posting Date        ;Date          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bogf›ringsdato;
                                                              ENU=Posting Date] }
    { 10  ;   ;IC Partner Code     ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=IC-partner kode;
                                                              ENU=IC Partner Code] }
    { 11  ;   ;Index               ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Indekser;
                                                              ENU=Index] }
  }
  KEYS
  {
    {    ;Currency Code,Posting Group,Dimension Entry No.,Posting Date,IC Partner Code;
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

