OBJECT Table 5495 Sales Order Entity Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               "Last Modified Date Time" := CURRENTDATETIME;
               UpdateReferencedRecordIds;
             END;

    OnModify=BEGIN
               "Last Modified Date Time" := CURRENTDATETIME;
               UpdateReferencedRecordIds;
             END;

    OnRename=BEGIN
               "Last Modified Date Time" := CURRENTDATETIME;
               UpdateReferencedRecordIds;
             END;

    CaptionML=[DAN=Buffer for salgsordreenhed;
               ENU=Sales Order Entity Buffer];
  }
  FIELDS
  {
    { 2   ;   ;Sell-to Customer No.;Code20        ;TableRelation=Customer;
                                                   OnValidate=BEGIN
                                                                UpdateCustomerId;
                                                              END;

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kundenr.;
                                                              ENU=Sell-to Customer No.];
                                                   NotBlank=Yes }
    { 3   ;   ;No.                 ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Nr.;
                                                              ENU=No.] }
    { 23  ;   ;Payment Terms Code  ;Code10        ;TableRelation="Payment Terms";
                                                   OnValidate=BEGIN
                                                                UpdatePaymentTermsId;
                                                              END;

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Betalingsbetingelseskode;
                                                              ENU=Payment Terms Code] }
    { 31  ;   ;Customer Posting Group;Code20      ;TableRelation="Customer Posting Group";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Debitorbogfõringsgruppe;
                                                              ENU=Customer Posting Group] }
    { 32  ;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   OnValidate=BEGIN
                                                                UpdateCurrencyId;
                                                              END;

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Valutakode;
                                                              ENU=Currency Code] }
    { 35  ;   ;Prices Including VAT;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Priser inkl. moms;
                                                              ENU=Prices Including VAT] }
    { 43  ;   ;Salesperson Code    ;Code20        ;TableRelation=Salesperson/Purchaser;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Sëlgerkode;
                                                              ENU=Salesperson Code] }
    { 56  ;   ;Recalculate Invoice Disc.;Boolean  ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Sales Line" WHERE (Document Type=CONST(Invoice),
                                                                                         Document No.=FIELD(No.),
                                                                                         Recalculate Invoice Disc.=CONST(Yes)));
                                                   CaptionML=[DAN=Genberegn fakturarabat;
                                                              ENU=Recalculate Invoice Disc.];
                                                   Editable=No }
    { 60  ;   ;Amount              ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Belõb;
                                                              ENU=Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 61  ;   ;Amount Including VAT;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Belõb inkl. moms;
                                                              ENU=Amount Including VAT];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 79  ;   ;Sell-to Customer Name;Text50       ;TableRelation=Customer.Name;
                                                   ValidateTableRelation=No;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kundenavn;
                                                              ENU=Sell-to Customer Name] }
    { 81  ;   ;Sell-to Address     ;Text50        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kundeadresse;
                                                              ENU=Sell-to Address] }
    { 82  ;   ;Sell-to Address 2   ;Text50        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kundeadresse 2;
                                                              ENU=Sell-to Address 2] }
    { 83  ;   ;Sell-to City        ;Text30        ;TableRelation=IF (Sell-to Country/Region Code=CONST()) "Post Code".City
                                                                 ELSE IF (Sell-to Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Sell-to Country/Region Code));
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kundeby;
                                                              ENU=Sell-to City] }
    { 84  ;   ;Sell-to Contact     ;Text50        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kundeattention;
                                                              ENU=Sell-to Contact] }
    { 88  ;   ;Sell-to Post Code   ;Code20        ;TableRelation=IF (Sell-to Country/Region Code=CONST()) "Post Code"
                                                                 ELSE IF (Sell-to Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Sell-to Country/Region Code));
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kundepostnr.;
                                                              ENU=Sell-to Post Code] }
    { 89  ;   ;Sell-to County      ;Text30        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kundeamt;
                                                              ENU=Sell-to County] }
    { 90  ;   ;Sell-to Country/Region Code;Code10 ;TableRelation=Country/Region;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Lande-/omrÜdekode for kunde;
                                                              ENU=Sell-to Country/Region Code] }
    { 99  ;   ;Document Date       ;Date          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bilagsdato;
                                                              ENU=Document Date] }
    { 100 ;   ;External Document No.;Code35       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Eksternt bilagsnr.;
                                                              ENU=External Document No.] }
    { 1304;   ;Cust. Ledger Entry No.;Integer     ;TableRelation="Cust. Ledger Entry"."Entry No.";
                                                   TestTableRelation=No;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Debitorpostlõbenr.;
                                                              ENU=Cust. Ledger Entry No.] }
    { 1305;   ;Invoice Discount Amount;Decimal    ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Fakturarabatbelõb;
                                                              ENU=Invoice Discount Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 5052;   ;Sell-To Contact No. ;Code20        ;TableRelation=Contact;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kundeattentionnr.;
                                                              ENU=Sell-To Contact No.] }
    { 5750;   ;Shipping Advice     ;Option        ;AccessByPermission=TableData 110=R;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Afsendelsesadvis;
                                                              ENU=Shipping Advice];
                                                   OptionCaptionML=[DAN=Delvis,Komplet;
                                                                    ENU=Partial,Complete];
                                                   OptionString=Partial,Complete }
    { 5752;   ;Completely Shipped  ;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Levering komplet;
                                                              ENU=Completely Shipped] }
    { 5790;   ;Requested Delivery Date;Date       ;AccessByPermission=TableData 99000880=R;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=ùnsket leveringsdato;
                                                              ENU=Requested Delivery Date] }
    { 8000;   ;Id                  ;GUID          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Id;
                                                              ENU=Id] }
    { 9600;   ;Total Tax Amount    ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Totalt momsbelõb;
                                                              ENU=Total Tax Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 9601;   ;Status              ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Status;
                                                              ENU=Status];
                                                   OptionCaptionML=[@@@={Locked};
                                                                    DAN=Draft,In Review,Open;
                                                                    ENU=Draft,In Review,Open];
                                                   OptionString=Draft,In Review,Open }
    { 9624;   ;Discount Applied Before Tax;Boolean;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Rabat udlignet fõr skat;
                                                              ENU=Discount Applied Before Tax] }
    { 9630;   ;Last Modified Date Time;DateTime   ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dato/klokkeslët for seneste ëndring;
                                                              ENU=Last Modified Date Time] }
    { 9631;   ;Customer Id         ;GUID          ;TableRelation=Customer.Id;
                                                   OnValidate=BEGIN
                                                                UpdateCustomerNo;
                                                              END;

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Debitor-id;
                                                              ENU=Customer Id] }
    { 9633;   ;Contact Graph Id    ;Text250       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Graph-id for kontakt;
                                                              ENU=Contact Graph Id] }
    { 9634;   ;Currency Id         ;GUID          ;TableRelation=Currency.Id;
                                                   OnValidate=BEGIN
                                                                UpdateCurrencyCode;
                                                              END;

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Valuta-id;
                                                              ENU=Currency Id] }
    { 9635;   ;Payment Terms Id    ;GUID          ;TableRelation="Payment Terms".Id;
                                                   OnValidate=BEGIN
                                                                UpdatePaymentTermsCode;
                                                              END;

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Id for betalingsbetingelser;
                                                              ENU=Payment Terms Id] }
  }
  KEYS
  {
    {    ;No.                                      }
    {    ;Id                                      ;Clustered=Yes }
    {    ;Cust. Ledger Entry No.                   }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    LOCAL PROCEDURE UpdateCustomerId@2();
    VAR
      Customer@1000 : Record 18;
    BEGIN
      IF "Sell-to Customer No." = '' THEN BEGIN
        CLEAR("Customer Id");
        EXIT;
      END;

      IF NOT Customer.GET("Sell-to Customer No.") THEN
        EXIT;

      "Customer Id" := Customer.Id;
    END;

    PROCEDURE UpdateCurrencyId@9();
    VAR
      Currency@1000 : Record 4;
    BEGIN
      IF "Currency Code" = '' THEN BEGIN
        CLEAR("Currency Id");
        EXIT;
      END;

      IF NOT Currency.GET("Currency Code") THEN
        EXIT;

      "Currency Id" := Currency.Id;
    END;

    PROCEDURE UpdatePaymentTermsId@57();
    VAR
      PaymentTerms@1000 : Record 3;
    BEGIN
      IF "Payment Terms Code" = '' THEN BEGIN
        CLEAR("Payment Terms Id");
        EXIT;
      END;

      IF NOT PaymentTerms.GET("Payment Terms Code") THEN
        EXIT;

      "Payment Terms Id" := PaymentTerms.Id;
    END;

    LOCAL PROCEDURE UpdateCustomerNo@1();
    VAR
      Customer@1000 : Record 18;
    BEGIN
      IF NOT ISNULLGUID("Customer Id") THEN BEGIN
        Customer.SETRANGE(Id,"Customer Id");
        Customer.FINDFIRST;
      END;

      VALIDATE("Sell-to Customer No.",Customer."No.");
    END;

    LOCAL PROCEDURE UpdateCurrencyCode@10();
    VAR
      Currency@1000 : Record 4;
    BEGIN
      IF NOT ISNULLGUID("Currency Id") THEN BEGIN
        Currency.SETRANGE(Id,"Currency Id");
        Currency.FINDFIRST;
      END;

      VALIDATE("Currency Code",Currency.Code);
    END;

    LOCAL PROCEDURE UpdatePaymentTermsCode@56();
    VAR
      PaymentTerms@1001 : Record 3;
    BEGIN
      IF NOT ISNULLGUID("Payment Terms Id") THEN BEGIN
        PaymentTerms.SETRANGE(Id,"Payment Terms Id");
        PaymentTerms.FINDFIRST;
      END;

      VALIDATE("Payment Terms Code",PaymentTerms.Code);
    END;

    PROCEDURE UpdateReferencedRecordIds@5();
    BEGIN
      UpdateCustomerId;
      UpdateCurrencyId;
      UpdatePaymentTermsId;

      UpdateGraphContactId;
    END;

    PROCEDURE UpdateGraphContactId@6();
    VAR
      Contact@1000 : Record 5050;
      GraphIntegrationRecord@1001 : Record 5451;
      GraphID@1002 : Text[250];
    BEGIN
      IF "Sell-To Contact No." = '' THEN BEGIN
        CLEAR("Contact Graph Id");
        EXIT;
      END;

      IF NOT Contact.GET("Sell-To Contact No.") THEN
        EXIT;

      IF NOT GraphIntegrationRecord.FindIDFromRecordID(Contact.RECORDID,GraphID) THEN
        EXIT;

      "Contact Graph Id" := GraphID;
    END;

    BEGIN
    END.
  }
}

