OBJECT Table 9150 My Customer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Min debitor;
               ENU=My Customer];
  }
  FIELDS
  {
    { 1   ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 2   ;   ;Customer No.        ;Code20        ;TableRelation=Customer;
                                                   OnValidate=BEGIN
                                                                SetCustomerFields;
                                                              END;

                                                   CaptionML=[DAN=Debitornr.;
                                                              ENU=Customer No.];
                                                   NotBlank=Yes }
    { 3   ;   ;Name                ;Text50        ;CaptionML=[DAN=Navn;
                                                              ENU=Name];
                                                   Editable=No }
    { 4   ;   ;Phone No.           ;Text30        ;CaptionML=[DAN=Telefon;
                                                              ENU=Phone No.];
                                                   Editable=No }
    { 5   ;   ;Balance (LCY)       ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE (Customer No.=FIELD(Customer No.)));
                                                   CaptionML=[DAN=Saldo (RV);
                                                              ENU=Balance (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
  }
  KEYS
  {
    {    ;User ID,Customer No.                    ;Clustered=Yes }
    {    ;Name                                     }
    {    ;Phone No.                                }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    [External]
    PROCEDURE SetCustomerFields@3();
    VAR
      Customer@1000 : Record 18;
    BEGIN
      IF Customer.GET("Customer No.") THEN BEGIN
        Name := Customer.Name;
        "Phone No." := Customer."Phone No.";
      END;
    END;

    BEGIN
    END.
  }
}

