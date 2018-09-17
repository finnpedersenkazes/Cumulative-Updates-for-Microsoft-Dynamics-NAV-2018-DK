OBJECT Table 375 Dimension Code Amount Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Dimensionskodebel›bsbuffer;
               ENU=Dimension Code Amount Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Line Code           ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Linjekode;
                                                              ENU=Line Code] }
    { 2   ;   ;Column Code         ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kolonnekode;
                                                              ENU=Column Code] }
    { 3   ;   ;Amount              ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bel›b;
                                                              ENU=Amount];
                                                   AutoFormatType=1 }
  }
  KEYS
  {
    {    ;Line Code,Column Code                   ;Clustered=Yes }
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

