OBJECT Table 1300 Mini Customer Template
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846,NAVDK11.00.00.19846;
  }
  PROPERTIES
  {
    OnInsert=VAR
               FieldRefArray@1001 : ARRAY [25] OF FieldRef;
               RecRef@1000 : RecordRef;
             BEGIN
               TESTFIELD("Template Name");
               RecRef.GETTABLE(Rec);
               CreateFieldRefArray(FieldRefArray,RecRef);

               InsertConfigurationTemplateHeaderAndLines;
             END;

    OnModify=VAR
               FieldRefArray@1000 : ARRAY [25] OF FieldRef;
               RecRef@1001 : RecordRef;
             BEGIN
               TESTFIELD(Code);
               TESTFIELD("Template Name");
               RecRef.GETTABLE(Rec);
               CreateFieldRefArray(FieldRefArray,RecRef);
               ConfigTemplateManagement.UpdateConfigTemplateAndLines(Code,"Template Name",DATABASE::Customer,FieldRefArray);
             END;

    OnDelete=VAR
               ConfigTemplateHeader@1000 : Record 8618;
             BEGIN
               IF ConfigTemplateHeader.GET(Code) THEN BEGIN
                 ConfigTemplateManagement.DeleteRelatedTemplates(Code,DATABASE::"Default Dimension");
                 ConfigTemplateHeader.DELETE(TRUE);
               END;
             END;

    CaptionML=[DAN=Miniskabelon til debitor;
               ENU=Mini Customer Template];
  }
  FIELDS
  {
    { 1   ;   ;Key                 ;Integer       ;AutoIncrement=Yes;
                                                   CaptionML=[DAN=N›gle;
                                                              ENU=Key] }
    { 2   ;   ;Code                ;Code10        ;CaptionML=[DAN=Kode;
                                                              ENU=Code];
                                                   NotBlank=Yes }
    { 3   ;   ;Template Name       ;Text50        ;CaptionML=[DAN=Typenavn;
                                                              ENU=Template Name];
                                                   NotBlank=Yes }
    { 7   ;   ;City                ;Text30        ;TableRelation=IF (Country/Region Code=CONST()) "Post Code".City
                                                                 ELSE IF (Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Country/Region Code));
                                                   OnValidate=VAR
                                                                PostCodeRec@1000 : Record 225;
                                                              BEGIN
                                                                IF City <> '' THEN BEGIN
                                                                  PostCodeRec.SETFILTER("Search City",City);

                                                                  CASE PostCodeRec.COUNT OF
                                                                    0:
                                                                      EXIT;
                                                                    1:
                                                                      PostCodeRec.FINDFIRST;
                                                                    ELSE
                                                                      IF PAGE.RUNMODAL(PAGE::"Post Codes",PostCodeRec,PostCodeRec.Code) <> ACTION::LookupOK THEN
                                                                        EXIT;
                                                                  END;

                                                                  "Post Code" := PostCodeRec.Code;
                                                                  "Country/Region Code" := PostCodeRec."Country/Region Code";
                                                                END;
                                                              END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=By;
                                                              ENU=City] }
    { 11  ;   ;Document Sending Profile;Code20    ;TableRelation="Document Sending Profile".Code;
                                                   CaptionML=[DAN=Dokumentafsendelsesprofil;
                                                              ENU=Document Sending Profile] }
    { 20  ;   ;Credit Limit (LCY)  ;Decimal       ;CaptionML=[DAN=Kreditmaksimum (RV);
                                                              ENU=Credit Limit (LCY)];
                                                   AutoFormatType=1 }
    { 21  ;   ;Customer Posting Group;Code20      ;TableRelation="Customer Posting Group";
                                                   CaptionML=[DAN=Debitorbogf›ringsgruppe;
                                                              ENU=Customer Posting Group] }
    { 22  ;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   CaptionML=[DAN=Valutakode;
                                                              ENU=Currency Code] }
    { 23  ;   ;Customer Price Group;Code10        ;TableRelation="Customer Price Group";
                                                   CaptionML=[DAN=Debitorprisgruppe;
                                                              ENU=Customer Price Group] }
    { 24  ;   ;Language Code       ;Code10        ;TableRelation=Language;
                                                   CaptionML=[DAN=Sprogkode;
                                                              ENU=Language Code] }
    { 27  ;   ;Payment Terms Code  ;Code10        ;TableRelation="Payment Terms";
                                                   CaptionML=[DAN=Betalingsbetingelseskode;
                                                              ENU=Payment Terms Code] }
    { 28  ;   ;Fin. Charge Terms Code;Code10      ;TableRelation="Finance Charge Terms";
                                                   CaptionML=[DAN=Rentebetingelseskode;
                                                              ENU=Fin. Charge Terms Code] }
    { 34  ;   ;Customer Disc. Group;Code20        ;TableRelation="Customer Discount Group";
                                                   CaptionML=[DAN=Debitorrabatgruppe;
                                                              ENU=Customer Disc. Group] }
    { 35  ;   ;Country/Region Code ;Code10        ;TableRelation=Country/Region;
                                                   CaptionML=[DAN=Lande-/omr†dekode;
                                                              ENU=Country/Region Code] }
    { 42  ;   ;Print Statements    ;Boolean       ;CaptionML=[DAN=Udskriv kontoudtog;
                                                              ENU=Print Statements] }
    { 47  ;   ;Payment Method Code ;Code10        ;TableRelation="Payment Method";
                                                   CaptionML=[DAN=Betalingsformskode;
                                                              ENU=Payment Method Code] }
    { 80  ;   ;Application Method  ;Option        ;CaptionML=[DAN=Udligningsmetode;
                                                              ENU=Application Method];
                                                   OptionCaptionML=[DAN=Manuelt,Saldo;
                                                                    ENU=Manual,Apply to Oldest];
                                                   OptionString=Manual,Apply to Oldest }
    { 82  ;   ;Prices Including VAT;Boolean       ;CaptionML=[DAN=Priser inkl. moms;
                                                              ENU=Prices Including VAT] }
    { 88  ;   ;Gen. Bus. Posting Group;Code20     ;TableRelation="Gen. Business Posting Group";
                                                   CaptionML=[DAN=Virksomhedsbogf›ringsgruppe;
                                                              ENU=Gen. Bus. Posting Group] }
    { 91  ;   ;Post Code           ;Code20        ;TableRelation=IF (Country/Region Code=CONST()) "Post Code"
                                                                 ELSE IF (Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Country/Region Code));
                                                   OnValidate=VAR
                                                                PostCodeRec@1000 : Record 225;
                                                              BEGIN
                                                                IF "Post Code" <> '' THEN BEGIN
                                                                  PostCodeRec.SETFILTER(Code,"Post Code");

                                                                  CASE PostCodeRec.COUNT OF
                                                                    0:
                                                                      EXIT;
                                                                    1:
                                                                      PostCodeRec.FINDFIRST;
                                                                    ELSE
                                                                      IF PAGE.RUNMODAL(PAGE::"Post Codes",PostCodeRec,PostCodeRec.Code) <> ACTION::LookupOK THEN
                                                                        EXIT;
                                                                  END;

                                                                  City := PostCodeRec.City;
                                                                  "Country/Region Code" := PostCodeRec."Country/Region Code";
                                                                END;
                                                              END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Postnr.;
                                                              ENU=Post Code] }
    { 92  ;   ;County              ;Text30        ;CaptionML=[DAN=Amt;
                                                              ENU=County] }
    { 104 ;   ;Reminder Terms Code ;Code10        ;TableRelation="Reminder Terms";
                                                   CaptionML=[DAN=Rykkerbetingelseskode;
                                                              ENU=Reminder Terms Code] }
    { 110 ;   ;VAT Bus. Posting Group;Code20      ;TableRelation="VAT Business Posting Group";
                                                   CaptionML=[DAN=Momsvirksomhedsbogf.gruppe;
                                                              ENU=VAT Bus. Posting Group] }
    { 116 ;   ;Block Payment Tolerance;Boolean    ;CaptionML=[DAN=Ingen betalingstolerance;
                                                              ENU=Block Payment Tolerance] }
    { 7001;   ;Allow Line Disc.    ;Boolean       ;InitValue=Yes;
                                                   CaptionML=[DAN=Tillad linjerabat;
                                                              ENU=Allow Line Disc.] }
    { 7602;   ;Validate EU Vat Reg. No.;Boolean   ;CaptionML=[DAN=Kontroll‚r SE/CVR-nr. for EU;
                                                              ENU=Validate EU Vat Reg. No.] }
    { 13604;  ;OIOUBL Profile Code ;Code10        ;TableRelation="OIOUBL Profile";
                                                   ObsoleteState=Pending;
                                                   ObsoleteReason=Moved to extension.;
                                                   CaptionML=[DAN=OIOUBL-profilkode;
                                                              ENU=OIOUBL Profile Code] }
    { 13605;  ;OIOUBL Profile Code Required;Boolean;
                                                   ObsoleteState=Pending;
                                                   ObsoleteReason=Moved to extension.;
                                                   CaptionML=[DAN=OIOUBL-profilkode kr‘ves;
                                                              ENU=OIOUBL Profile Code Required] }
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
      ConfigTemplateManagement@1000 : Codeunit 8612;

    [External]
    PROCEDURE CreateFieldRefArray@12(VAR FieldRefArray@1000 : ARRAY [24] OF FieldRef;RecRef@1003 : RecordRef);
    VAR
      I@1002 : Integer;
    BEGIN
      I := 1;

      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO(City)));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Document Sending Profile")));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Credit Limit (LCY)")));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Customer Posting Group")));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Currency Code")));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Customer Price Group")));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Language Code")));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Payment Terms Code")));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Fin. Charge Terms Code")));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Customer Disc. Group")));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Country/Region Code")));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Print Statements")));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Payment Method Code")));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Application Method")));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Prices Including VAT")));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Gen. Bus. Posting Group")));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Post Code")));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO(County)));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Reminder Terms Code")));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("VAT Bus. Posting Group")));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Block Payment Tolerance")));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Allow Line Disc.")));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Validate EU Vat Reg. No.")));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("OIOUBL Profile Code")));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("OIOUBL Profile Code Required")));
    END;

    LOCAL PROCEDURE AddToArray@4(VAR FieldRefArray@1000 : ARRAY [26] OF FieldRef;VAR I@1001 : Integer;CurrFieldRef@1002 : FieldRef);
    BEGIN
      FieldRefArray[I] := CurrFieldRef;
      I += 1;
    END;

    [External]
    PROCEDURE InitializeTempRecordFromConfigTemplate@1(VAR TempMiniCustomerTemplate@1000 : TEMPORARY Record 1300;ConfigTemplateHeader@1001 : Record 8618);
    VAR
      RecRef@1003 : RecordRef;
    BEGIN
      TempMiniCustomerTemplate.INIT;
      TempMiniCustomerTemplate.Code := ConfigTemplateHeader.Code;
      TempMiniCustomerTemplate."Template Name" := ConfigTemplateHeader.Description;
      TempMiniCustomerTemplate.INSERT;

      RecRef.GETTABLE(TempMiniCustomerTemplate);

      ConfigTemplateManagement.ApplyTemplateLinesWithoutValidation(ConfigTemplateHeader,RecRef);

      RecRef.SETTABLE(TempMiniCustomerTemplate);
    END;

    [External]
    PROCEDURE CreateConfigTemplateFromExistingCustomer@5(Customer@1000 : Record 18;VAR TempMiniCustomerTemplate@1001 : TEMPORARY Record 1300);
    VAR
      DimensionsTemplate@1002 : Record 1302;
      ConfigTemplateHeader@1006 : Record 8618;
      RecRef@1005 : RecordRef;
      FieldRefArray@1004 : ARRAY [25] OF FieldRef;
      NewTemplateCode@1003 : Code[10];
    BEGIN
      RecRef.GETTABLE(Customer);
      CreateFieldRefArray(FieldRefArray,RecRef);

      ConfigTemplateManagement.CreateConfigTemplateAndLines(NewTemplateCode,'',DATABASE::Customer,FieldRefArray);
      ConfigTemplateHeader.GET(NewTemplateCode);
      DimensionsTemplate.CreateTemplatesFromExistingMasterRecord(Customer."No.",NewTemplateCode,DATABASE::Customer);
      InitializeTempRecordFromConfigTemplate(TempMiniCustomerTemplate,ConfigTemplateHeader);
    END;

    [External]
    PROCEDURE SaveAsTemplate@7(Customer@1000 : Record 18);
    VAR
      TempMiniCustomerTemplate@1001 : TEMPORARY Record 1300;
      CustTemplateCard@1002 : Page 1341;
    BEGIN
      CustTemplateCard.CreateFromCust(Customer);
      CustTemplateCard.SETRECORD(TempMiniCustomerTemplate);
      CustTemplateCard.LOOKUPMODE := TRUE;
      IF CustTemplateCard.RUNMODAL = ACTION::LookupOK THEN;
    END;

    LOCAL PROCEDURE InsertConfigurationTemplateHeaderAndLines@2();
    VAR
      FieldRefArray@1001 : ARRAY [25] OF FieldRef;
      RecRef@1000 : RecordRef;
    BEGIN
      RecRef.GETTABLE(Rec);
      CreateFieldRefArray(FieldRefArray,RecRef);
      ConfigTemplateManagement.CreateConfigTemplateAndLines(Code,"Template Name",DATABASE::Customer,FieldRefArray);
    END;

    [Internal]
    PROCEDURE NewCustomerFromTemplate@3(VAR Customer@1001 : Record 18) : Boolean;
    VAR
      ConfigTemplateHeader@1004 : Record 8618;
      ConfigTemplates@1005 : Page 1340;
    BEGIN
      ConfigTemplateHeader.SETRANGE("Table ID",DATABASE::Customer);
      ConfigTemplateHeader.SETRANGE(Enabled,TRUE);

      IF ConfigTemplateHeader.COUNT = 1 THEN BEGIN
        ConfigTemplateHeader.FINDFIRST;
        InsertCustomerFromTemplate(ConfigTemplateHeader,Customer);
        EXIT(TRUE);
      END;

      IF (ConfigTemplateHeader.COUNT > 1) AND GUIALLOWED THEN BEGIN
        ConfigTemplates.SETTABLEVIEW(ConfigTemplateHeader);
        ConfigTemplates.LOOKUPMODE(TRUE);
        ConfigTemplates.SetNewMode;
        IF ConfigTemplates.RUNMODAL = ACTION::LookupOK THEN BEGIN
          ConfigTemplates.GETRECORD(ConfigTemplateHeader);
          InsertCustomerFromTemplate(ConfigTemplateHeader,Customer);
          EXIT(TRUE);
        END;
      END;

      EXIT(FALSE);
    END;

    [Internal]
    PROCEDURE UpdateCustomerFromTemplate@8(VAR Customer@1000 : Record 18);
    VAR
      ConfigTemplateHeader@1001 : Record 8618;
      DimensionsTemplate@1004 : Record 1302;
      ConfigTemplates@1003 : Page 1340;
      CustomerRecRef@1002 : RecordRef;
    BEGIN
      IF GUIALLOWED THEN BEGIN
        ConfigTemplateHeader.SETRANGE("Table ID",DATABASE::Customer);
        ConfigTemplateHeader.SETRANGE(Enabled,TRUE);
        ConfigTemplates.SETTABLEVIEW(ConfigTemplateHeader);
        ConfigTemplates.LOOKUPMODE(TRUE);
        IF ConfigTemplates.RUNMODAL = ACTION::LookupOK THEN BEGIN
          ConfigTemplates.GETRECORD(ConfigTemplateHeader);
          CustomerRecRef.GETTABLE(Customer);
          ConfigTemplateManagement.UpdateRecord(ConfigTemplateHeader,CustomerRecRef);
          DimensionsTemplate.InsertDimensionsFromTemplates(ConfigTemplateHeader,Customer."No.",DATABASE::Customer);
          CustomerRecRef.SETTABLE(Customer);
        END;
      END;
    END;

    [External]
    PROCEDURE InsertCustomerFromTemplate@16(ConfigTemplateHeader@1006 : Record 8618;VAR Customer@1003 : Record 18);
    VAR
      DimensionsTemplate@1001 : Record 1302;
      ConfigTemplateMgt@1002 : Codeunit 8612;
      RecRef@1000 : RecordRef;
    BEGIN
      Customer.SetInsertFromTemplate(TRUE);
      InitCustomerNo(Customer,ConfigTemplateHeader);
      Customer.INSERT(TRUE);
      RecRef.GETTABLE(Customer);
      ConfigTemplateMgt.UpdateRecord(ConfigTemplateHeader,RecRef);
      RecRef.SETTABLE(Customer);

      DimensionsTemplate.InsertDimensionsFromTemplates(ConfigTemplateHeader,Customer."No.",DATABASE::Customer);
    END;

    [Internal]
    PROCEDURE UpdateCustomersFromTemplate@6(VAR Customer@1000 : Record 18);
    VAR
      ConfigTemplateHeader@1001 : Record 8618;
      DimensionsTemplate@1004 : Record 1302;
      ConfigTemplates@1003 : Page 1340;
      CustomerRecRef@1002 : RecordRef;
    BEGIN
      IF GUIALLOWED THEN BEGIN
        ConfigTemplateHeader.SETRANGE("Table ID",DATABASE::Customer);
        ConfigTemplateHeader.SETRANGE(Enabled,TRUE);
        ConfigTemplates.SETTABLEVIEW(ConfigTemplateHeader);
        ConfigTemplates.LOOKUPMODE(TRUE);
        IF ConfigTemplates.RUNMODAL = ACTION::LookupOK THEN BEGIN
          ConfigTemplates.GETRECORD(ConfigTemplateHeader);
          CustomerRecRef.GETTABLE(Customer);
          IF CustomerRecRef.FINDSET THEN
            REPEAT
              ConfigTemplateManagement.UpdateRecord(ConfigTemplateHeader,CustomerRecRef);
              DimensionsTemplate.InsertDimensionsFromTemplates(ConfigTemplateHeader,Customer."No.",DATABASE::Customer);
            UNTIL CustomerRecRef.NEXT = 0;
          CustomerRecRef.SETTABLE(Customer);
        END;
      END;
    END;

    LOCAL PROCEDURE InitCustomerNo@9(VAR Customer@1000 : Record 18;ConfigTemplateHeader@1004 : Record 8618);
    VAR
      NoSeriesMgt@1002 : Codeunit 396;
    BEGIN
      IF ConfigTemplateHeader."Instance No. Series" = '' THEN
        EXIT;
      NoSeriesMgt.InitSeries(ConfigTemplateHeader."Instance No. Series",'',0D,Customer."No.",Customer."No. Series");
    END;

    BEGIN
    END.
  }
}

