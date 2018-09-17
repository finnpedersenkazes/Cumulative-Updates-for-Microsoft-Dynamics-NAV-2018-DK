OBJECT Table 1114 Cost Budget Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Omkostningsbudgetbuffer;
               ENU=Cost Budget Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Cost Type No.       ;Code20        ;TableRelation="Cost Type";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Omkostningstypenr.;
                                                              ENU=Cost Type No.] }
    { 2   ;   ;Budget Name         ;Code10        ;TableRelation="Cost Budget Name";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Budgetnavn;
                                                              ENU=Budget Name] }
    { 3   ;   ;Date                ;Date          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dato;
                                                              ENU=Date];
                                                   ClosingDates=Yes }
    { 4   ;   ;Cost Center Code    ;Code20        ;TableRelation="Cost Center";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Omkostningsstedskode;
                                                              ENU=Cost Center Code] }
    { 5   ;   ;Cost Object Code    ;Code20        ;TableRelation="Cost Object";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Omkostningsemnekode;
                                                              ENU=Cost Object Code] }
    { 6   ;   ;Amount              ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bel›b;
                                                              ENU=Amount] }
  }
  KEYS
  {
    {    ;Cost Type No.,Cost Center Code,Cost Object Code,Date;
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

