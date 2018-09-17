OBJECT Table 5646 Depreciation Table Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Afskrivningstabelbuffer;
               ENU=Depreciation Table Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=L›benr.;
                                                              ENU=Entry No.] }
    { 2   ;   ;No. of Days in Period;Integer      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Antal dage i regnskabsperiode;
                                                              ENU=No. of Days in Period] }
    { 3   ;   ;Period Depreciation %;Decimal      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Periodeafskrivningspct.;
                                                              ENU=Period Depreciation %];
                                                   DecimalPlaces=1:1 }
  }
  KEYS
  {
    {    ;Entry No.                               ;Clustered=Yes }
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

