OBJECT Table 7360 Reservation Entry Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Reservationspostbuffer;
               ENU=Reservation Entry Buffer];
  }
  FIELDS
  {
    { 4   ;   ;Quantity (Base)     ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Antal (basis);
                                                              ENU=Quantity (Base)];
                                                   DecimalPlaces=0:5 }
    { 10  ;   ;Source Type         ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kildetype;
                                                              ENU=Source Type] }
    { 11  ;   ;Source Subtype      ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kildeundertype;
                                                              ENU=Source Subtype];
                                                   OptionCaptionML=[DAN=0,1,2,3,4,5,6,7,8,9,10;
                                                                    ENU=0,1,2,3,4,5,6,7,8,9,10];
                                                   OptionString=0,1,2,3,4,5,6,7,8,9,10 }
    { 12  ;   ;Source ID           ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kilde-id;
                                                              ENU=Source ID] }
    { 13  ;   ;Source Batch Name   ;Code10        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kildekladdenavn;
                                                              ENU=Source Batch Name] }
    { 14  ;   ;Source Prod. Order Line;Integer    ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kildeprod.ordrelinje;
                                                              ENU=Source Prod. Order Line] }
    { 15  ;   ;Source Ref. No.     ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kildereferencenr.;
                                                              ENU=Source Ref. No.] }
  }
  KEYS
  {
    {    ;Source Type,Source Subtype,Source ID,Source Batch Name,Source Prod. Order Line,Source Ref. No.;
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

