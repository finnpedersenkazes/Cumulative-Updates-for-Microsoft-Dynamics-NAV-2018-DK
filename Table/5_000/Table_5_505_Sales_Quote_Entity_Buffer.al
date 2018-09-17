OBJECT Table 5505 Sales Quote Entity Buffer
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

    CaptionML=[DAN=Buffer for salgstilbudsenhed;
               ENU=Sales Quote Entity Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Document Type       ;Option        ;InitValue=Invoice;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bilagstype;
                                                              ENU=Document Type];
                                                   OptionCaptionML=[DAN=Tilbud,Ordre,Faktura,Kreditnota,Rammeordre,Returvareordre;
                                                                    ENU=Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order];
                                                   OptionString=Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order }
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
    { 11  ;   ;Your Reference      ;Text35        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Reference;
                                                              ENU=Your Reference] }
    { 20  ;   ;Posting Date        ;Date          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bogf›ringsdato;
                                                              ENU=Posting Date] }
    { 23  ;   ;Payment Terms Code  ;Code10        ;TableRelation="Payment Terms";
                                                   OnValidate=BEGIN
                                                                UpdatePaymentTermsId;
                                                              END;

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Betalingsbetingelseskode;
                                                              ENU=Payment Terms Code] }
    { 24  ;   ;Due Date            ;Date          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Forfaldsdato;
                                                              ENU=Due Date] }
    { 27  ;   ;Shipment Method Code;Code10        ;TableRelation="Shipment Method";
                                                   OnValidate=BEGIN
                                                                UpdateShipmentMethodId;
                                                              END;

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Leveringskode;
                                                              ENU=Shipment Method Code] }
    { 31  ;   ;Customer Posting Group;Code20      ;TableRelation="Customer Posting Group";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Debitorbogf›ringsgruppe;
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
                                                   CaptionML=[DAN=S‘lgerkode;
                                                              ENU=Salesperson Code] }
    { 56  ;   ;Recalculate Invoice Disc.;Boolean  ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Sales Line" WHERE (Document Type=CONST(Invoice),
                                                                                         Document No.=FIELD(No.),
                                                                                         Recalculate Invoice Disc.=CONST(Yes)));
                                                   CaptionML=[DAN=Genberegn fakturarabat;
                                                              ENU=Recalculate Invoice Disc.];
                                                   Editable=No }
    { 60  ;   ;Amount              ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bel›b;
                                                              ENU=Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 61  ;   ;Amount Including VAT;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bel›b inkl. moms;
                                                              ENU=Amount Including VAT];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 70  ;   ;VAT Registration No.;Text20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=SE/CVR-nr.;
                                                              ENU=VAT Registration No.] }
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
                                                   CaptionML=[DAN=Lande-/omr†dekode for kunde;
                                                              ENU=Sell-to Country/Region Code] }
    { 99  ;   ;Document Date       ;Date          ;OnValidate=BEGIN
                                                                VALIDATE("Posting Date","Document Date");
                                                              END;

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bilagsdato;
                                                              ENU=Document Date] }
    { 100 ;   ;External Document No.;Code35       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Eksternt bilagsnr.;
                                                              ENU=External Document No.] }
    { 114 ;   ;Tax Area Code       ;Code20        ;TableRelation="Tax Area";
                                                   OnValidate=BEGIN
                                                                IF IsUsingVAT THEN
                                                                  ERROR(SalesTaxOnlyFieldErr,FIELDCAPTION("Tax Area Code"));
                                                              END;

                                                   ValidateTableRelation=No;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Skatteomr†dekode;
                                                              ENU=Tax Area Code] }
    { 115 ;   ;Tax Liable          ;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Skattepligtig;
                                                              ENU=Tax Liable] }
    { 116 ;   ;VAT Bus. Posting Group;Code20      ;TableRelation="VAT Business Posting Group";
                                                   OnValidate=BEGIN
                                                                IF NOT IsUsingVAT THEN
                                                                  ERROR(VATOnlyFieldErr,FIELDCAPTION("VAT Bus. Posting Group"));
                                                              END;

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Momsvirksomhedsbogf.gruppe;
                                                              ENU=VAT Bus. Posting Group] }
    { 121 ;   ;Invoice Discount Calculation;Option;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Beregning af fakturarabat;
                                                              ENU=Invoice Discount Calculation];
                                                   OptionCaptionML=[DAN=Ingen,%,Bel›b;
                                                                    ENU=None,%,Amount];
                                                   OptionString=None,%,Amount }
    { 122 ;   ;Invoice Discount Value;Decimal     ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Fakturarabatv‘rdi;
                                                              ENU=Invoice Discount Value];
                                                   AutoFormatType=1 }
    { 152 ;   ;Quote Valid Until Date;Date        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Tilbud gyldigt til dato;
                                                              ENU=Quote Valid Until Date] }
    { 153 ;   ;Quote Sent to Customer;DateTime    ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Tilbud sendt til debitor;
                                                              ENU=Quote Sent to Customer];
                                                   Editable=No }
    { 154 ;   ;Quote Accepted      ;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Tilbud accepteret;
                                                              ENU=Quote Accepted] }
    { 155 ;   ;Quote Accepted Date ;Date          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dato for tilbud accepteret;
                                                              ENU=Quote Accepted Date];
                                                   Editable=No }
    { 167 ;   ;Last Email Sent Status;Option      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Afsendelsesstatus for sidste mail;
                                                              ENU=Last Email Sent Status];
                                                   OptionCaptionML=[@@@={Locked};
                                                                    DAN=,In Process,Finished,Error;
                                                                    ENU=,In Process,Finished,Error];
                                                   OptionString=,In Process,Finished,Error }
    { 1304;   ;Cust. Ledger Entry No.;Integer     ;TableRelation="Cust. Ledger Entry"."Entry No.";
                                                   TestTableRelation=No;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Debitorpostl›benr.;
                                                              ENU=Cust. Ledger Entry No.] }
    { 1305;   ;Invoice Discount Amount;Decimal    ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Fakturarabatbel›b;
                                                              ENU=Invoice Discount Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 5052;   ;Sell-to Contact No. ;Code20        ;TableRelation=Contact;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kundeattentionnr.;
                                                              ENU=Sell-to Contact No.] }
    { 8000;   ;Id                  ;GUID          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Id;
                                                              ENU=Id] }
    { 9600;   ;Total Tax Amount    ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Totalt momsbel›b;
                                                              ENU=Total Tax Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 9601;   ;Status              ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Status;
                                                              ENU=Status];
                                                   OptionCaptionML=[@@@={Locked};
                                                                    DAN=Draft,Sent,Accepted;
                                                                    ENU=Draft,Sent,Accepted];
                                                   OptionString=[Draft,Sent,Accepted,Expired ] }
    { 9602;   ;Posted              ;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bogf›rt;
                                                              ENU=Posted] }
    { 9603;   ;Subtotal Amount     ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Subtotalbel›b;
                                                              ENU=Subtotal Amount];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 9624;   ;Discount Applied Before Tax;Boolean;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Rabat udlignet f›r skat;
                                                              ENU=Discount Applied Before Tax] }
    { 9630;   ;Last Modified Date Time;DateTime   ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dato/klokkesl‘t for seneste ‘ndring;
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
    { 9636;   ;Shipment Method Id  ;GUID          ;TableRelation="Shipment Method".Id;
                                                   OnValidate=BEGIN
                                                                UpdateShipmentMethodCode;
                                                              END;

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Id for leveringsform;
                                                              ENU=Shipment Method Id] }
    { 9637;   ;Tax Area ID         ;GUID          ;OnValidate=BEGIN
                                                                IF IsUsingVAT THEN
                                                                  UpdateVATBusinessPostingGroupCode
                                                                ELSE
                                                                  UpdateTaxAreaCode;
                                                              END;

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Skatteomr†de-id;
                                                              ENU=Tax Area ID] }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
    {    ;Id                                       }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      SalesTaxOnlyFieldErr@1001 : TextConst '@@@=%1 - Name of the field, e.g. Tax Liable, Tax Group Code, VAT Business posting group;DAN=Den aktuelle skatteops‘tning er indstillet til MOMS. Feltet %1 kan kun bruges sammen med salgsmoms.;ENU=Current Tax setup is set to VAT. Field %1 can only be used with Sales Tax.';
      VATOnlyFieldErr@1000 : TextConst '@@@=%1 - Name of the field, e.g. Tax Liable, Tax Group Code, VAT Business posting group;DAN=Den aktuelle skatteops‘tning er indstillet til salgsmoms. Feltet %1 kan kun bruges sammen med MOMS.;ENU=Current Tax setup is set to Sales Tax. Field %1 can only be used with VAT.';

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

    PROCEDURE UpdateShipmentMethodId@59();
    VAR
      ShipmentMethod@1000 : Record 10;
    BEGIN
      IF "Shipment Method Code" = '' THEN BEGIN
        CLEAR("Shipment Method Id");
        EXIT;
      END;

      IF NOT ShipmentMethod.GET("Shipment Method Code") THEN
        EXIT;

      "Shipment Method Id" := ShipmentMethod.Id;
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

    LOCAL PROCEDURE UpdateShipmentMethodCode@58();
    VAR
      ShipmentMethod@1001 : Record 10;
    BEGIN
      IF NOT ISNULLGUID("Shipment Method Id") THEN BEGIN
        ShipmentMethod.SETRANGE(Id,"Shipment Method Id");
        ShipmentMethod.FINDFIRST;
      END;

      VALIDATE("Shipment Method Code",ShipmentMethod.Code);
    END;

    PROCEDURE UpdateReferencedRecordIds@5();
    BEGIN
      UpdateCustomerId;
      UpdateCurrencyId;
      UpdatePaymentTermsId;
      UpdateShipmentMethodId;

      UpdateGraphContactId;
      UpdateTaxAreaId;
    END;

    PROCEDURE UpdateGraphContactId@6();
    VAR
      Contact@1000 : Record 5050;
      GraphIntegrationRecord@1001 : Record 5451;
      GraphID@1002 : Text[250];
    BEGIN
      IF "Sell-to Contact No." = '' THEN BEGIN
        CLEAR("Contact Graph Id");
        EXIT;
      END;

      IF NOT Contact.GET("Sell-to Contact No.") THEN
        EXIT;

      IF NOT GraphIntegrationRecord.FindIDFromRecordID(Contact.RECORDID,GraphID) THEN
        EXIT;

      "Contact Graph Id" := GraphID;
    END;

    LOCAL PROCEDURE UpdateTaxAreaId@65();
    VAR
      TaxArea@1000 : Record 318;
      VATBusinessPostingGroup@1001 : Record 323;
    BEGIN
      IF IsUsingVAT THEN BEGIN
        IF "VAT Bus. Posting Group" <> '' THEN BEGIN
          VATBusinessPostingGroup.SETRANGE(Code,"VAT Bus. Posting Group");
          IF VATBusinessPostingGroup.FINDFIRST THEN BEGIN
            "Tax Area ID" := VATBusinessPostingGroup.Id;
            EXIT;
          END;
        END;

        CLEAR("Tax Area ID");
        EXIT;
      END;

      IF "Tax Area Code" <> '' THEN BEGIN
        TaxArea.SETRANGE(Code,"Tax Area Code");
        IF TaxArea.FINDFIRST THEN BEGIN
          "Tax Area ID" := TaxArea.Id;
          EXIT;
        END;
      END;

      CLEAR("Tax Area ID");
    END;

    LOCAL PROCEDURE UpdateTaxAreaCode@66();
    VAR
      TaxArea@1000 : Record 318;
    BEGIN
      IF NOT ISNULLGUID("Tax Area ID") THEN BEGIN
        TaxArea.SETRANGE(Id,"Tax Area ID");
        IF TaxArea.FINDFIRST THEN BEGIN
          VALIDATE("Tax Area Code",TaxArea.Code);
          EXIT;
        END;
      END;

      CLEAR("Tax Area Code");
    END;

    LOCAL PROCEDURE UpdateVATBusinessPostingGroupCode@15();
    VAR
      VATBusinessPostingGroup@1000 : Record 323;
    BEGIN
      IF ISNULLGUID("Tax Area ID") THEN BEGIN
        VATBusinessPostingGroup.SETRANGE(Id,"Tax Area ID");
        IF VATBusinessPostingGroup.FINDFIRST THEN BEGIN
          VALIDATE("VAT Bus. Posting Group",VATBusinessPostingGroup.Code);
          EXIT;
        END;
      END;

      CLEAR("VAT Bus. Posting Group");
    END;

    PROCEDURE IsUsingVAT@12() : Boolean;
    VAR
      GeneralLedgerSetup@1000 : Record 98;
    BEGIN
      EXIT(GeneralLedgerSetup.UseVat);
    END;

    BEGIN
    END.
  }
}

