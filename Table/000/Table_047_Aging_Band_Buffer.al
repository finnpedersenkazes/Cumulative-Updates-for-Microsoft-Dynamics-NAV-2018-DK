OBJECT Table 47 Aging Band Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Aldersfordelingsintervalbuffer;
               ENU=Aging Band Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Currency Code       ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Valutakode;
                                                              ENU=Currency Code] }
    { 2   ;   ;Column 1 Amt.       ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kolonne 1-bel›b;
                                                              ENU=Column 1 Amt.] }
    { 3   ;   ;Column 2 Amt.       ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kolonne 2-bel›b;
                                                              ENU=Column 2 Amt.] }
    { 4   ;   ;Column 3 Amt.       ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kolonne 3-bel›b;
                                                              ENU=Column 3 Amt.] }
    { 5   ;   ;Column 4 Amt.       ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kolonne 4-bel›b;
                                                              ENU=Column 4 Amt.] }
    { 6   ;   ;Column 5 Amt.       ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kolonne 5-bel›b;
                                                              ENU=Column 5 Amt.] }
  }
  KEYS
  {
    {    ;Currency Code                           ;Clustered=Yes }
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

