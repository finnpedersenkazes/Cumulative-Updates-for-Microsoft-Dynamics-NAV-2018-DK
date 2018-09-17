OBJECT Table 371 Budget Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Budgetbuffer;
               ENU=Budget Buffer];
  }
  FIELDS
  {
    { 1   ;   ;G/L Account No.     ;Code20        ;TableRelation="G/L Account";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Finanskontonr.;
                                                              ENU=G/L Account No.] }
    { 2   ;   ;Dimension Value Code 1;Code20      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dimensionsv‘rdikode 1;
                                                              ENU=Dimension Value Code 1] }
    { 3   ;   ;Dimension Value Code 2;Code20      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dimensionsv‘rdikode 2;
                                                              ENU=Dimension Value Code 2] }
    { 4   ;   ;Dimension Value Code 3;Code20      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dimensionsv‘rdikode 3;
                                                              ENU=Dimension Value Code 3] }
    { 5   ;   ;Dimension Value Code 4;Code20      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dimensionsv‘rdikode 4;
                                                              ENU=Dimension Value Code 4] }
    { 6   ;   ;Dimension Value Code 5;Code20      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dimensionsv‘rdikode 5;
                                                              ENU=Dimension Value Code 5] }
    { 7   ;   ;Dimension Value Code 6;Code20      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dimensionsv‘rdikode 6;
                                                              ENU=Dimension Value Code 6] }
    { 8   ;   ;Dimension Value Code 7;Code20      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dimensionsv‘rdikode 7;
                                                              ENU=Dimension Value Code 7] }
    { 9   ;   ;Dimension Value Code 8;Code20      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dimensionsv‘rdikode 8;
                                                              ENU=Dimension Value Code 8] }
    { 10  ;   ;Date                ;Date          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dato;
                                                              ENU=Date] }
    { 11  ;   ;Amount              ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bel›b;
                                                              ENU=Amount];
                                                   AutoFormatType=1 }
  }
  KEYS
  {
    {    ;G/L Account No.,Dimension Value Code 1,Dimension Value Code 2,Dimension Value Code 3,Dimension Value Code 4,Dimension Value Code 5,Dimension Value Code 6,Dimension Value Code 7,Dimension Value Code 8,Date;
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

