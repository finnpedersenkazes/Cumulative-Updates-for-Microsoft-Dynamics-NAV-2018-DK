OBJECT Table 9153 My Account
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Min konto;
               ENU=My Account];
  }
  FIELDS
  {
    { 1   ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 2   ;   ;Account No.         ;Code20        ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                SetAccountFields;
                                                              END;

                                                   CaptionML=[DAN=Kontonr.;
                                                              ENU=Account No.];
                                                   NotBlank=Yes }
    { 3   ;   ;Name                ;Text50        ;CaptionML=[DAN=Navn;
                                                              ENU=Name];
                                                   Editable=No }
    { 4   ;   ;Balance             ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("G/L Entry".Amount WHERE (G/L Account No.=FIELD(Account No.)));
                                                   CaptionML=[DAN=Saldo;
                                                              ENU=Balance];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;User ID,Account No.                     ;Clustered=Yes }
    {    ;Name                                     }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    LOCAL PROCEDURE SetAccountFields@1();
    VAR
      GLAccount@1000 : Record 15;
    BEGIN
      IF GLAccount.GET("Account No.") THEN
        Name := GLAccount.Name;
    END;

    BEGIN
    END.
  }
}

