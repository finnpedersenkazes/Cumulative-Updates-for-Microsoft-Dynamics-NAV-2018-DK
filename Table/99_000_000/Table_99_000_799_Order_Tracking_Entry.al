OBJECT Table 99000799 Order Tracking Entry
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Ordresporingspost;
               ENU=Order Tracking Entry];
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;CaptionML=[DAN=L›benr.;
                                                              ENU=Entry No.] }
    { 2   ;   ;Supplied by         ;Text80        ;DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Forsynet af;
                                                              ENU=Supplied by] }
    { 3   ;   ;Demanded by         ;Text80        ;DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Behov fra;
                                                              ENU=Demanded by] }
    { 8   ;   ;Shipment Date       ;Date          ;CaptionML=[DAN=Afsendelsesdato;
                                                              ENU=Shipment Date] }
    { 9   ;   ;Expected Receipt Date;Date         ;CaptionML=[DAN=Forventet modt.dato;
                                                              ENU=Expected Receipt Date] }
    { 11  ;   ;Item No.            ;Code20        ;TableRelation=Item;
                                                   CaptionML=[DAN=Varenr.;
                                                              ENU=Item No.] }
    { 13  ;   ;Quantity            ;Decimal       ;CaptionML=[DAN=Antal;
                                                              ENU=Quantity];
                                                   DecimalPlaces=0:5 }
    { 14  ;   ;Level               ;Integer       ;CaptionML=[DAN=Niveau;
                                                              ENU=Level] }
    { 20  ;   ;For Type            ;Integer       ;CaptionML=[DAN=Til type;
                                                              ENU=For Type] }
    { 21  ;   ;For Subtype         ;Integer       ;CaptionML=[DAN=Til undertype;
                                                              ENU=For Subtype] }
    { 22  ;   ;For ID              ;Code20        ;CaptionML=[DAN=Til id;
                                                              ENU=For ID] }
    { 23  ;   ;For Batch Name      ;Code10        ;CaptionML=[DAN=Til kld.navn;
                                                              ENU=For Batch Name] }
    { 24  ;   ;For Prod. Order Line;Integer       ;CaptionML=[DAN=Til prod.ordrelinje;
                                                              ENU=For Prod. Order Line] }
    { 25  ;   ;For Ref. No.        ;Integer       ;CaptionML=[DAN=Til ref.nr.;
                                                              ENU=For Ref. No.] }
    { 26  ;   ;From Type           ;Integer       ;CaptionML=[DAN=Fra type;
                                                              ENU=From Type] }
    { 27  ;   ;From Subtype        ;Integer       ;CaptionML=[DAN=Fra undertype;
                                                              ENU=From Subtype] }
    { 28  ;   ;From ID             ;Code20        ;CaptionML=[DAN=Fra id;
                                                              ENU=From ID] }
    { 29  ;   ;From Batch Name     ;Code10        ;CaptionML=[DAN=Fra kld.navn;
                                                              ENU=From Batch Name] }
    { 30  ;   ;From Prod. Order Line;Integer      ;CaptionML=[DAN=Fra prod.ordrelinje;
                                                              ENU=From Prod. Order Line] }
    { 31  ;   ;From Ref. No.       ;Integer       ;CaptionML=[DAN=Fra ref.nr.;
                                                              ENU=From Ref. No.] }
    { 40  ;   ;Starting Date       ;Date          ;CaptionML=[DAN=Startdato;
                                                              ENU=Starting Date] }
    { 41  ;   ;Ending Date         ;Date          ;CaptionML=[DAN=Slutdato;
                                                              ENU=Ending Date] }
    { 42  ;   ;Name                ;Text80        ;CaptionML=[DAN=Navn;
                                                              ENU=Name] }
    { 43  ;   ;Warning             ;Boolean       ;CaptionML=[DAN=Advarsel;
                                                              ENU=Warning] }
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

