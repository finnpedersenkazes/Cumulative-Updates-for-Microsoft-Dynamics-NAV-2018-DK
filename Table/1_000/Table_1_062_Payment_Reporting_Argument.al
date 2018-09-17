OBJECT Table 1062 Payment Reporting Argument
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Betalingsrapporteringsargument;
               ENU=Payment Reporting Argument];
  }
  FIELDS
  {
    { 1   ;   ;Key                 ;Integer       ;AutoIncrement=Yes;
                                                   CaptionML=[DAN=N›gle;
                                                              ENU=Key] }
    { 3   ;   ;Document Record ID  ;RecordID      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dokumentrecord-id;
                                                              ENU=Document Record ID] }
    { 4   ;   ;Setup Record ID     ;RecordID      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Konfigurationsrecord-id;
                                                              ENU=Setup Record ID] }
    { 10  ;   ;Logo                ;BLOB          ;CaptionML=[DAN=Logo;
                                                              ENU=Logo] }
    { 12  ;   ;URL Caption         ;Text250       ;CaptionML=[DAN=Titel for URL-adresse;
                                                              ENU=URL Caption] }
    { 13  ;   ;Target URL          ;BLOB          ;CaptionML=[DAN=URL-adresse til tjeneste;
                                                              ENU=Service URL] }
    { 30  ;   ;Language Code       ;Code10        ;CaptionML=[DAN=Sprogkode;
                                                              ENU=Language Code] }
    { 35  ;   ;Payment Service ID  ;Integer       ;CaptionML=[DAN=Betalingstjeneste-id;
                                                              ENU=Payment Service ID] }
  }
  KEYS
  {
    {    ;Key                                     ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      PaymentServiceID@1000 : ',PayPal,MS Wallet,WorldPay';

    [External]
    PROCEDURE GetTargetURL@10() TargetURL : Text;
    VAR
      InStream@1000 : InStream;
    BEGIN
      CALCFIELDS("Target URL");
      IF "Target URL".HASVALUE THEN BEGIN
        "Target URL".CREATEINSTREAM(InStream);
        InStream.READ(TargetURL);
      END;
    END;

    [External]
    PROCEDURE SetTargetURL@20(ServiceURL@1000 : Text);
    VAR
      WebRequestHelper@1002 : Codeunit 1299;
      OutStream@1001 : OutStream;
    BEGIN
      WebRequestHelper.IsValidUri(ServiceURL);
      WebRequestHelper.IsHttpUrl(ServiceURL);

      "Target URL".CREATEOUTSTREAM(OutStream);
      OutStream.WRITE(ServiceURL);
      MODIFY;
    END;

    [External]
    PROCEDURE GetCurrencyCode@5(CurrencyCode@1000 : Code[10]) : Code[10];
    VAR
      GeneralLedgerSetup@1001 : Record 98;
    BEGIN
      IF CurrencyCode <> '' THEN
        EXIT(CurrencyCode);

      GeneralLedgerSetup.GET;
      GeneralLedgerSetup.GetCurrencyCode(CurrencyCode);
      EXIT(GeneralLedgerSetup."LCY Code");
    END;

    [External]
    PROCEDURE GetPayPalServiceID@2() : Integer;
    BEGIN
      EXIT(PaymentServiceID::PayPal);
    END;

    [External]
    PROCEDURE GetMSWalletServiceID@6() : Integer;
    BEGIN
      EXIT(PaymentServiceID::"MS Wallet");
    END;

    [External]
    PROCEDURE GetWorldPayServiceID@8() : Integer;
    BEGIN
      EXIT(PaymentServiceID::WorldPay);
    END;

    BEGIN
    END.
  }
}

