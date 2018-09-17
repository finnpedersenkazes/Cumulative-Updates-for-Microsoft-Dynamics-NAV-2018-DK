OBJECT Table 9151 My Vendor
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Min kreditor;
               ENU=My Vendor];
  }
  FIELDS
  {
    { 1   ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 2   ;   ;Vendor No.          ;Code20        ;TableRelation=Vendor;
                                                   OnValidate=BEGIN
                                                                SetVendorFields;
                                                              END;

                                                   CaptionML=[DAN=Leverand›rnr.;
                                                              ENU=Vendor No.];
                                                   NotBlank=Yes }
    { 3   ;   ;Name                ;Text50        ;CaptionML=[DAN=Navn;
                                                              ENU=Name];
                                                   Editable=No }
    { 4   ;   ;Phone No.           ;Text30        ;CaptionML=[DAN=Telefon;
                                                              ENU=Phone No.];
                                                   Editable=No }
    { 5   ;   ;Balance (LCY)       ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE (Vendor No.=FIELD(Vendor No.)));
                                                   CaptionML=[DAN=Saldo (RV);
                                                              ENU=Balance (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
  }
  KEYS
  {
    {    ;User ID,Vendor No.                      ;Clustered=Yes }
    {    ;Name                                     }
    {    ;Phone No.                                }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    [External]
    PROCEDURE SetVendorFields@3();
    VAR
      Vendor@1000 : Record 23;
    BEGIN
      IF Vendor.GET("Vendor No.") THEN BEGIN
        Name := Vendor.Name;
        "Phone No." := Vendor."Phone No.";
      END;
    END;

    BEGIN
    END.
  }
}

