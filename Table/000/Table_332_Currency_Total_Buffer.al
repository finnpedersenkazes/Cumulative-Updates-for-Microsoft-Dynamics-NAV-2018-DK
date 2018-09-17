OBJECT Table 332 Currency Total Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Valuta i alt (buffer);
               ENU=Currency Total Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Valutakode;
                                                              ENU=Currency Code] }
    { 2   ;   ;Total Amount        ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=I alt;
                                                              ENU=Total Amount];
                                                   AutoFormatType=1 }
    { 3   ;   ;Total Amount (LCY)  ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=I alt (RV);
                                                              ENU=Total Amount (LCY)];
                                                   AutoFormatType=1 }
    { 4   ;   ;Counter             ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=T‘ller;
                                                              ENU=Counter] }
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

    [External]
    PROCEDURE UpdateTotal@1(CurrencyCode@1000 : Code[10];Amount@1001 : Decimal;AmountLCY@1002 : Decimal;VAR Counter@1003 : Integer);
    BEGIN
      IF GET(CurrencyCode) THEN BEGIN
        "Total Amount" := "Total Amount" + Amount;
        "Total Amount (LCY)" := "Total Amount (LCY)" + AmountLCY;
        MODIFY;
      END ELSE BEGIN
        "Currency Code" := CurrencyCode;
        "Total Amount" := Amount;
        "Total Amount (LCY)" := AmountLCY;
        Counter := Counter + 1;
        INSERT;
      END;
    END;

    BEGIN
    END.
  }
}

