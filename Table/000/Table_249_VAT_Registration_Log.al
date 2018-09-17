OBJECT Table 249 VAT Registration Log
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Log over SE/CVR-nr.;
               ENU=VAT Registration Log];
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;AutoIncrement=Yes;
                                                   CaptionML=[DAN=L›benr.;
                                                              ENU=Entry No.] }
    { 2   ;   ;VAT Registration No.;Text20        ;CaptionML=[DAN=SE/CVR-nr.;
                                                              ENU=VAT Registration No.];
                                                   NotBlank=Yes }
    { 3   ;   ;Account Type        ;Option        ;CaptionML=[DAN=Kontotype;
                                                              ENU=Account Type];
                                                   OptionCaptionML=[DAN=Debitor,Kreditor,Kontakt,Virksomhedsoplysninger;
                                                                    ENU=Customer,Vendor,Contact,Company Information];
                                                   OptionString=Customer,Vendor,Contact,Company Information }
    { 4   ;   ;Account No.         ;Code20        ;TableRelation=IF (Account Type=CONST(Customer)) Customer
                                                                 ELSE IF (Account Type=CONST(Vendor)) Vendor;
                                                   CaptionML=[DAN=Kontonr.;
                                                              ENU=Account No.] }
    { 5   ;   ;Country/Region Code ;Code10        ;TableRelation=Country/Region.Code;
                                                   CaptionML=[DAN=Lande-/omr†dekode;
                                                              ENU=Country/Region Code];
                                                   NotBlank=Yes }
    { 6   ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("User ID");
                                                            END;

                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 10  ;   ;Status              ;Option        ;CaptionML=[DAN=Status;
                                                              ENU=Status];
                                                   OptionCaptionML=[DAN=Ikke bekr‘ftet,Gyldig,Ugyldig;
                                                                    ENU=Not Verified,Valid,Invalid];
                                                   OptionString=Not Verified,Valid,Invalid }
    { 11  ;   ;Verified Name       ;Text150       ;CaptionML=[DAN=Bekr‘ftet navn;
                                                              ENU=Verified Name] }
    { 12  ;   ;Verified Address    ;Text150       ;CaptionML=[DAN=Bekr‘ftet adresse;
                                                              ENU=Verified Address] }
    { 13  ;   ;Verified Date       ;DateTime      ;CaptionML=[DAN=Bekr‘ftet dato;
                                                              ENU=Verified Date] }
    { 14  ;   ;Request Identifier  ;Text200       ;CaptionML=[DAN=Anmodnings-id;
                                                              ENU=Request Identifier] }
    { 15  ;   ;Verified Street     ;Text50        ;CaptionML=[DAN=Bekr‘ftet gadenavn;
                                                              ENU=Verified Street] }
    { 16  ;   ;Verified Postcode   ;Text20        ;CaptionML=[DAN=Bekr‘ftet postnummer;
                                                              ENU=Verified Postcode] }
    { 17  ;   ;Verified City       ;Text30        ;CaptionML=[DAN=Bekr‘ftet by;
                                                              ENU=Verified City] }
  }
  KEYS
  {
    {    ;Entry No.                               ;Clustered=Yes }
  }
  FIELDGROUPS
  {
    { 1   ;Brick               ;Country/Region Code,VAT Registration No.,Status }
  }
  CODE
  {

    [External]
    PROCEDURE GetCountryCode@2() : Code[10];
    VAR
      CompanyInformation@1000 : Record 79;
      CountryRegion@1001 : Record 9;
    BEGIN
      IF "Country/Region Code" = '' THEN BEGIN
        IF NOT CompanyInformation.GET THEN
          EXIT('');
        EXIT(CompanyInformation."Country/Region Code");
      END;
      CountryRegion.GET("Country/Region Code");
      IF CountryRegion."EU Country/Region Code" = '' THEN
        EXIT("Country/Region Code");
      EXIT(CountryRegion."EU Country/Region Code");
    END;

    [External]
    PROCEDURE GetVATRegNo@12() : Code[20];
    VAR
      VatRegNo@1000 : Code[20];
    BEGIN
      VatRegNo := UPPERCASE("VAT Registration No.");
      VatRegNo := DELCHR(VatRegNo,'=',DELCHR(VatRegNo,'=','ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'));
      IF STRPOS(VatRegNo,UPPERCASE(GetCountryCode)) = 1 THEN
        VatRegNo := DELSTR(VatRegNo,1,STRLEN(GetCountryCode));
      EXIT(VatRegNo);
    END;

    PROCEDURE InitVATRegLog@40(VAR VATRegistrationLog@1000 : Record 249;CountryCode@1001 : Code[10];AcountType@1002 : Option;AccountNo@1003 : Code[20];VATRegNo@1004 : Text[20]);
    BEGIN
      VATRegistrationLog.INIT;
      VATRegistrationLog."Account Type" := AcountType;
      VATRegistrationLog."Account No." := AccountNo;
      VATRegistrationLog."Country/Region Code" := CountryCode;
      VATRegistrationLog."VAT Registration No." := VATRegNo;
    END;

    BEGIN
    END.
  }
}

