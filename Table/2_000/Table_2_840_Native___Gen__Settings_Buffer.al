OBJECT Table 2840 Native - Gen. Settings Buffer
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Oprindelig - buffer for generelle indstillinger;
               ENU=Native - Gen. Settings Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Primary Key         ;Code10        ;CaptionML=[DAN=Prim‘r n›gle;
                                                              ENU=Primary Key] }
    { 2   ;   ;Currency Symbol     ;Text10        ;CaptionML=[DAN=Valutasymbol;
                                                              ENU=Currency Symbol] }
    { 3   ;   ;Paypal Email Address;Text250       ;CaptionML=[DAN=PayPal-mailadresse;
                                                              ENU=Paypal Email Address] }
    { 4   ;   ;Country/Region Code ;Code10        ;CaptionML=[DAN=Lande-/omr†dekode;
                                                              ENU=Country/Region Code] }
    { 5   ;   ;Language Locale ID  ;Integer       ;CaptionML=[DAN=Id for landestandard;
                                                              ENU=Language Locale ID] }
    { 6   ;   ;Language Code       ;Text50        ;CaptionML=[DAN=Sprogkode;
                                                              ENU=Language Code] }
    { 7   ;   ;Language Display Name;Text80       ;CaptionML=[DAN=Visningsnavn for sprog;
                                                              ENU=Language Display Name] }
    { 50  ;   ;Default Tax ID      ;GUID          ;CaptionML=[DAN=Standardskatte-id;
                                                              ENU=Default Tax ID];
                                                   Editable=No }
    { 51  ;   ;Defauilt Tax Description;Text50    ;CaptionML=[DAN=Beskrivelse af standardskat;
                                                              ENU=Defauilt Tax Description];
                                                   Editable=No }
    { 52  ;   ;Default Payment Terms ID;GUID      ;CaptionML=[DAN=Id for standardbetalingsbetingelser;
                                                              ENU=Default Payment Terms ID];
                                                   Editable=No }
    { 53  ;   ;Def. Pmt. Term Description;Text50  ;CaptionML=[DAN=Beskrivelse af vilk†r for udskudt betaling;
                                                              ENU=Def. Pmt. Term Description];
                                                   Editable=No }
    { 54  ;   ;Default Payment Method ID;GUID     ;CaptionML=[DAN=Id for standardbetalingsmetode;
                                                              ENU=Default Payment Method ID];
                                                   Editable=No }
    { 55  ;   ;Def. Pmt. Method Description;Text50;CaptionML=[DAN=Beskrivelse af metode til udskudt betaling;
                                                              ENU=Def. Pmt. Method Description];
                                                   Editable=No }
    { 56  ;   ;Amount Rounding Precision;Decimal  ;CaptionML=[DAN=Pr‘cision ved afrunding af bel›b;
                                                              ENU=Amount Rounding Precision];
                                                   Editable=No }
    { 60  ;   ;EnableSync          ;Boolean       ;CaptionML=[DAN=EnableSync;
                                                              ENU=EnableSync] }
    { 61  ;   ;EnableSyncCoupons   ;Boolean       ;CaptionML=[DAN=EnableSyncCoupons;
                                                              ENU=EnableSyncCoupons] }
  }
  KEYS
  {
    {    ;Primary Key                             ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      RecordMustBeTemporaryErr@1000 : TextConst 'DAN=Buffer for generelle indstillinger skal bruges som en midlertidig record.;ENU=General Settings Buffer must be used as a temporary record.';
      CannotEnableCouponsSyncErr@1001 : TextConst 'DAN=Kuponsynkronisering kan ikke aktiveres, n†r Microsoft Graph-synkronisering er deaktiveret.;ENU=Cannot enable coupons synchronization while Microsoft Graph synchronization is turned off.';
      CannotSetWebhookSubscriptionUserErr@1007 : TextConst 'DAN=Bruger for Webhook-abonnement kan ikke angives.;ENU=Cannot set the webhook subscription user.';
      CannotGetCompanyInformationErr@1003 : TextConst 'DAN=Der kan ikke hentes virksomhedsoplysninger.;ENU=Cannot get the company information.';
      SyncOnlyAllowedInSaasErr@1004 : TextConst 'DAN=Microsoft Graph-synkronisering er kun tilladt i SaaS.;ENU=Microsoft Graph synchronization is only allowed in SaaS.';
      SyncNotAllowedInDemoCompanyErr@1005 : TextConst 'DAN=Microsoft Graph-synkronisering er ikke tilladt i en demovirksomhed.;ENU=Microsoft Graph synchronization is not allowed in a demo company.';
      SyncNotAllowedErr@1006 : TextConst 'DAN=Microsoft Graph-synkronisering er ikke tilladt.;ENU=Microsoft Graph synchronization is not allowed.';

    PROCEDURE LoadRecord@2();
    VAR
      CompanyInformation@1001 : Record 79;
      O365SalesInitialSetup@1003 : Record 2110;
      GeneralLedgerSetup@1004 : Record 98;
      PaymentMethod@1005 : Record 289;
      PaymentTerms@1006 : Record 3;
      TempNativeAPITaxSetup@1007 : TEMPORARY Record 2850;
      MarketingSetup@1008 : Record 5079;
      PaypalAccountProxy@1002 : Codeunit 1060;
    BEGIN
      IF NOT ISTEMPORARY THEN
        ERROR(RecordMustBeTemporaryErr);

      DELETEALL;
      CLEAR(Rec);

      CompanyInformation.GET;
      "Country/Region Code" := CompanyInformation."Country/Region Code";

      GeneralLedgerSetup.GET;
      "Currency Symbol" := GeneralLedgerSetup.GetCurrencySymbol;
      "Amount Rounding Precision" := GetNumberOfDecimals(GeneralLedgerSetup."Amount Rounding Precision");

      PaypalAccountProxy.GetPaypalAccount("Paypal Email Address");

      O365SalesInitialSetup.GET;
      IF PaymentTerms.GET(O365SalesInitialSetup."Default Payment Terms Code") THEN BEGIN
        "Default Payment Terms ID" := PaymentTerms.Id;
        "Def. Pmt. Term Description" := PaymentTerms.GetDescriptionInCurrentLanguage;
      END;

      IF PaymentMethod.GET(O365SalesInitialSetup."Default Payment Method Code") THEN BEGIN
        "Default Payment Method ID" := PaymentMethod.Id;
        "Def. Pmt. Method Description" :=
          COPYSTR(PaymentMethod.GetDescriptionInCurrentLanguage,1,MAXSTRLEN("Def. Pmt. Method Description"));
      END;

      TempNativeAPITaxSetup.LoadSetupRecords;
      TempNativeAPITaxSetup.SETRANGE(Default,TRUE);
      IF TempNativeAPITaxSetup.FINDFIRST THEN BEGIN
        "Default Tax ID" := TempNativeAPITaxSetup.Id;
        "Defauilt Tax Description" := TempNativeAPITaxSetup.Description;
      END;

      GetLanguageInfo;

      IF MarketingSetup.GET THEN BEGIN
        EnableSync := MarketingSetup."Sync with Microsoft Graph";
        IF EnableSync THEN
          EnableSyncCoupons := O365SalesInitialSetup."Coupons Integration Enabled";
      END;

      INSERT(TRUE);
    END;

    PROCEDURE SaveRecord@1();
    VAR
      PaypalAccountProxy@1000 : Codeunit 1060;
    BEGIN
      IF xRec."Currency Symbol" <> "Currency Symbol" THEN
        UpdateCurrencySymbol;

      IF xRec."Paypal Email Address" <> "Paypal Email Address" THEN
        PaypalAccountProxy.SetPaypalAccount("Paypal Email Address",TRUE);

      IF xRec."Country/Region Code" <> "Country/Region Code" THEN
        UpdateCountryRegionCode;

      IF xRec."Language Locale ID" <> "Language Locale ID" THEN
        UpdateLanguageId;

      IF xRec.EnableSync <> EnableSync THEN
        UpdateSync;

      IF xRec.EnableSyncCoupons <> EnableSyncCoupons THEN
        UpdateCouponsSync;
    END;

    LOCAL PROCEDURE UpdateCurrencySymbol@3();
    VAR
      GeneralLedgerSetup@1000 : Record 98;
    BEGIN
      GeneralLedgerSetup.GET;
      IF "Currency Symbol" <> GeneralLedgerSetup."Local Currency Symbol" THEN BEGIN
        GeneralLedgerSetup.VALIDATE("Local Currency Symbol","Currency Symbol");
        GeneralLedgerSetup.MODIFY(TRUE);
      END;
    END;

    LOCAL PROCEDURE UpdateCountryRegionCode@6();
    VAR
      CompanyInformation@1000 : Record 79;
    BEGIN
      CompanyInformation.GET;
      IF CompanyInformation."Country/Region Code" <> "Country/Region Code" THEN BEGIN
        CompanyInformation.VALIDATE("Country/Region Code","Country/Region Code");
        CompanyInformation.MODIFY(TRUE);
      END;
    END;

    LOCAL PROCEDURE UpdateLanguageId@9();
    VAR
      UserPersonalization@1000 : Record 2000000073;
    BEGIN
      UserPersonalization.GET(USERSECURITYID);
      IF "Language Locale ID" <> UserPersonalization."Language ID" THEN BEGIN
        UserPersonalization.VALIDATE("Language ID","Language Locale ID");
        UserPersonalization.MODIFY(TRUE);
        GetLanguageInfo;
      END;
    END;

    LOCAL PROCEDURE UpdateSync@7();
    VAR
      MarketingSetup@1001 : Record 5079;
      O365SalesBackgroundSetup@1000 : Codeunit 2111;
    BEGIN
      CheckSyncAllowed;

      O365SalesBackgroundSetup.InitializeGraphSync(EnableSync,FALSE);

      MarketingSetup.GET;
      EnableSync := MarketingSetup."Sync with Microsoft Graph";

      IF NOT EnableSync THEN
        EnableSyncCoupons := FALSE;
    END;

    LOCAL PROCEDURE UpdateCouponsSync@10();
    VAR
      MarketingSetup@1000 : Record 5079;
      O365SalesInitialSetup@1001 : Record 2110;
    BEGIN
      IF EnableSyncCoupons THEN BEGIN
        CheckSyncAllowed;
        MarketingSetup.GET;
        IF NOT MarketingSetup."Sync with Microsoft Graph" THEN
          ERROR(CannotEnableCouponsSyncErr);
        IF MarketingSetup.TrySetWebhookSubscriptionUser(USERSECURITYID) THEN
          ERROR(CannotSetWebhookSubscriptionUserErr);
      END;
      O365SalesInitialSetup.GET;
      O365SalesInitialSetup."Coupons Integration Enabled" := EnableSyncCoupons;
      O365SalesInitialSetup.MODIFY(TRUE);
    END;

    LOCAL PROCEDURE GetNumberOfDecimals@4(AmountRoundingPrecision@1000 : Decimal) : Integer;
    VAR
      Count@1001 : Integer;
    BEGIN
      Count := 0;

      IF AmountRoundingPrecision >= 1 THEN
        EXIT(Count);

      REPEAT
        Count += 1;
        AmountRoundingPrecision := AmountRoundingPrecision * 10;
      UNTIL AmountRoundingPrecision >= 1;

      EXIT(Count);
    END;

    LOCAL PROCEDURE GetLanguageInfo@5();
    VAR
      UserPersonalization@1001 : Record 2000000073;
      WindowsLanguage@1000 : Record 2000000045;
      CultureInfo@1002 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Globalization.CultureInfo";
    BEGIN
      UserPersonalization.GET(USERSECURITYID);
      "Language Locale ID" := UserPersonalization."Language ID";
      CultureInfo := CultureInfo.CultureInfo("Language Locale ID");
      "Language Code" := CultureInfo.Name;
      IF WindowsLanguage.GET("Language Locale ID") THEN
        "Language Display Name" := WindowsLanguage.Name;
    END;

    PROCEDURE CheckSyncAllowed@8();
    VAR
      CompanyInformation@1003 : Record 79;
      CompanyInformationMgt@1002 : Codeunit 1306;
      PermissionManager@1001 : Codeunit 9002;
      WebhookManagement@1000 : Codeunit 5377;
    BEGIN
      IF WebhookManagement.IsSyncAllowed THEN
        EXIT;

      IF NOT CompanyInformation.GET THEN
        ERROR(CannotGetCompanyInformationErr);

      IF NOT PermissionManager.SoftwareAsAService THEN
        ERROR(SyncOnlyAllowedInSaasErr);

      IF CompanyInformationMgt.IsDemoCompany THEN
        ERROR(SyncNotAllowedInDemoCompanyErr);

      ERROR(SyncNotAllowedErr);
    END;

    BEGIN
    END.
  }
}

