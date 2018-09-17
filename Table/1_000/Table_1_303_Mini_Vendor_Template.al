OBJECT Table 1303 Mini Vendor Template
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    OnInsert=VAR
               FieldRefArray@1001 : ARRAY [17] OF FieldRef;
               RecRef@1000 : RecordRef;
             BEGIN
               TESTFIELD("Template Name");
               RecRef.GETTABLE(Rec);
               CreateFieldRefArray(FieldRefArray,RecRef);

               InsertConfigurationTemplateHeaderAndLines;
             END;

    OnModify=VAR
               FieldRefArray@1000 : ARRAY [17] OF FieldRef;
               RecRef@1001 : RecordRef;
             BEGIN
               TESTFIELD(Code);
               TESTFIELD("Template Name");
               RecRef.GETTABLE(Rec);
               CreateFieldRefArray(FieldRefArray,RecRef);
               ConfigTemplateManagement.UpdateConfigTemplateAndLines(Code,"Template Name",DATABASE::Vendor,FieldRefArray);
             END;

    OnDelete=VAR
               ConfigTemplateHeader@1000 : Record 8618;
             BEGIN
               IF ConfigTemplateHeader.GET(Code) THEN BEGIN
                 ConfigTemplateManagement.DeleteRelatedTemplates(Code,DATABASE::"Default Dimension");
                 ConfigTemplateHeader.DELETE(TRUE);
               END;
             END;

    CaptionML=[DAN=Miniskabelon til kreditor;
               ENU=Mini Vendor Template];
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
    { 21  ;   ;Vendor Posting Group;Code20        ;TableRelation="Vendor Posting Group";
                                                   CaptionML=[DAN=Kreditorbogf›ringsgruppe;
                                                              ENU=Vendor Posting Group] }
    { 22  ;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   CaptionML=[DAN=Valutakode;
                                                              ENU=Currency Code] }
    { 24  ;   ;Language Code       ;Code10        ;TableRelation=Language;
                                                   CaptionML=[DAN=Sprogkode;
                                                              ENU=Language Code] }
    { 27  ;   ;Payment Terms Code  ;Code10        ;TableRelation="Payment Terms";
                                                   CaptionML=[DAN=Betalingsbetingelseskode;
                                                              ENU=Payment Terms Code] }
    { 28  ;   ;Fin. Charge Terms Code;Code10      ;TableRelation="Finance Charge Terms";
                                                   CaptionML=[DAN=Rentebetingelseskode;
                                                              ENU=Fin. Charge Terms Code] }
    { 33  ;   ;Invoice Disc. Code  ;Code20        ;TableRelation=Vendor;
                                                   CaptionML=[DAN=Fakturarabatkode;
                                                              ENU=Invoice Disc. Code] }
    { 35  ;   ;Country/Region Code ;Code10        ;TableRelation=Country/Region;
                                                   CaptionML=[DAN=Lande-/omr†dekode;
                                                              ENU=Country/Region Code] }
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
    { 110 ;   ;VAT Bus. Posting Group;Code20      ;TableRelation="VAT Business Posting Group";
                                                   CaptionML=[DAN=Momsvirksomhedsbogf.gruppe;
                                                              ENU=VAT Bus. Posting Group] }
    { 116 ;   ;Block Payment Tolerance;Boolean    ;CaptionML=[DAN=Ingen betalingstolerance;
                                                              ENU=Block Payment Tolerance] }
    { 7602;   ;Validate EU Vat Reg. No.;Boolean   ;CaptionML=[DAN=Kontroll‚r SE/CVR-nr. for EU;
                                                              ENU=Validate EU Vat Reg. No.] }
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
    PROCEDURE CreateFieldRefArray@12(VAR FieldRefArray@1000 : ARRAY [17] OF FieldRef;RecRef@1003 : RecordRef);
    VAR
      I@1002 : Integer;
    BEGIN
      I := 1;

      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO(City)));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Vendor Posting Group")));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Currency Code")));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Language Code")));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Payment Terms Code")));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Fin. Charge Terms Code")));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Invoice Disc. Code")));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Country/Region Code")));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Payment Method Code")));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Application Method")));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Prices Including VAT")));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Gen. Bus. Posting Group")));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Post Code")));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO(County)));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("VAT Bus. Posting Group")));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Block Payment Tolerance")));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Validate EU Vat Reg. No.")));
    END;

    LOCAL PROCEDURE AddToArray@4(VAR FieldRefArray@1000 : ARRAY [18] OF FieldRef;VAR I@1001 : Integer;CurrFieldRef@1002 : FieldRef);
    BEGIN
      FieldRefArray[I] := CurrFieldRef;
      I += 1;
    END;

    [External]
    PROCEDURE InitializeTempRecordFromConfigTemplate@1(VAR TempMiniVendorTemplate@1000 : TEMPORARY Record 1303;ConfigTemplateHeader@1001 : Record 8618);
    VAR
      RecRef@1003 : RecordRef;
    BEGIN
      TempMiniVendorTemplate.INIT;
      TempMiniVendorTemplate.Code := ConfigTemplateHeader.Code;
      TempMiniVendorTemplate."Template Name" := ConfigTemplateHeader.Description;
      TempMiniVendorTemplate.INSERT;

      RecRef.GETTABLE(TempMiniVendorTemplate);

      ConfigTemplateManagement.ApplyTemplateLinesWithoutValidation(ConfigTemplateHeader,RecRef);

      RecRef.SETTABLE(TempMiniVendorTemplate);
    END;

    [External]
    PROCEDURE CreateConfigTemplateFromExistingVendor@5(Vendor@1000 : Record 23;VAR TempMiniVendorTemplate@1001 : TEMPORARY Record 1303);
    VAR
      DimensionsTemplate@1002 : Record 1302;
      ConfigTemplateHeader@1006 : Record 8618;
      RecRef@1005 : RecordRef;
      FieldRefArray@1004 : ARRAY [17] OF FieldRef;
      NewTemplateCode@1003 : Code[10];
    BEGIN
      RecRef.GETTABLE(Vendor);
      CreateFieldRefArray(FieldRefArray,RecRef);

      ConfigTemplateManagement.CreateConfigTemplateAndLines(NewTemplateCode,'',DATABASE::Vendor,FieldRefArray);
      ConfigTemplateHeader.GET(NewTemplateCode);
      DimensionsTemplate.CreateTemplatesFromExistingMasterRecord(Vendor."No.",NewTemplateCode,DATABASE::Vendor);
      InitializeTempRecordFromConfigTemplate(TempMiniVendorTemplate,ConfigTemplateHeader);
    END;

    [External]
    PROCEDURE SaveAsTemplate@7(Vendor@1000 : Record 23);
    VAR
      TempMiniVendorTemplate@1001 : TEMPORARY Record 1303;
      VendorTemplateCard@1002 : Page 1344;
    BEGIN
      VendorTemplateCard.CreateFromVend(Vendor);
      VendorTemplateCard.SETRECORD(TempMiniVendorTemplate);
      VendorTemplateCard.LOOKUPMODE := TRUE;
      IF VendorTemplateCard.RUNMODAL = ACTION::LookupOK THEN;
    END;

    LOCAL PROCEDURE InsertConfigurationTemplateHeaderAndLines@2();
    VAR
      FieldRefArray@1001 : ARRAY [17] OF FieldRef;
      RecRef@1000 : RecordRef;
    BEGIN
      RecRef.GETTABLE(Rec);
      CreateFieldRefArray(FieldRefArray,RecRef);
      ConfigTemplateManagement.CreateConfigTemplateAndLines(Code,"Template Name",DATABASE::Vendor,FieldRefArray);
    END;

    [External]
    PROCEDURE NewVendorFromTemplate@3(VAR Vendor@1002 : Record 23) : Boolean;
    VAR
      ConfigTemplateHeader@1004 : Record 8618;
      ConfigTemplates@1001 : Page 1340;
    BEGIN
      ConfigTemplateHeader.SETRANGE("Table ID",DATABASE::Vendor);
      ConfigTemplateHeader.SETRANGE(Enabled,TRUE);

      IF ConfigTemplateHeader.COUNT = 1 THEN BEGIN
        ConfigTemplateHeader.FINDFIRST;
        InsertVendorFromTemplate(ConfigTemplateHeader,Vendor);
        EXIT(TRUE);
      END;

      IF (ConfigTemplateHeader.COUNT > 1) AND GUIALLOWED THEN BEGIN
        ConfigTemplates.SETTABLEVIEW(ConfigTemplateHeader);
        ConfigTemplates.LOOKUPMODE(TRUE);
        ConfigTemplates.SetNewMode;
        IF ConfigTemplates.RUNMODAL = ACTION::LookupOK THEN BEGIN
          ConfigTemplates.GETRECORD(ConfigTemplateHeader);
          InsertVendorFromTemplate(ConfigTemplateHeader,Vendor);
          EXIT(TRUE);
        END;
      END;

      EXIT(FALSE);
    END;

    [External]
    PROCEDURE UpdateVendorFromTemplate@8(VAR Vendor@1000 : Record 23);
    VAR
      ConfigTemplateHeader@1001 : Record 8618;
      DimensionsTemplate@1004 : Record 1302;
      ConfigTemplates@1003 : Page 1340;
      VendorRecRef@1002 : RecordRef;
    BEGIN
      IF GUIALLOWED THEN BEGIN
        ConfigTemplateHeader.SETRANGE("Table ID",DATABASE::Vendor);
        ConfigTemplateHeader.SETRANGE(Enabled,TRUE);
        ConfigTemplates.SETTABLEVIEW(ConfigTemplateHeader);
        ConfigTemplates.LOOKUPMODE(TRUE);
        IF ConfigTemplates.RUNMODAL = ACTION::LookupOK THEN BEGIN
          ConfigTemplates.GETRECORD(ConfigTemplateHeader);
          VendorRecRef.GETTABLE(Vendor);
          ConfigTemplateManagement.UpdateRecord(ConfigTemplateHeader,VendorRecRef);
          DimensionsTemplate.InsertDimensionsFromTemplates(ConfigTemplateHeader,Vendor."No.",DATABASE::Vendor);
          VendorRecRef.SETTABLE(Vendor);
          Vendor.FIND;
        END;
      END;
    END;

    [External]
    PROCEDURE InsertVendorFromTemplate@16(ConfigTemplateHeader@1006 : Record 8618;VAR Vendor@1003 : Record 23);
    VAR
      DimensionsTemplate@1001 : Record 1302;
      ConfigTemplateMgt@1002 : Codeunit 8612;
      RecRef@1000 : RecordRef;
    BEGIN
      Vendor.SetInsertFromTemplate(TRUE);
      InitVendorNo(Vendor,ConfigTemplateHeader);
      Vendor.INSERT(TRUE);
      RecRef.GETTABLE(Vendor);
      ConfigTemplateMgt.UpdateRecord(ConfigTemplateHeader,RecRef);
      RecRef.SETTABLE(Vendor);

      DimensionsTemplate.InsertDimensionsFromTemplates(ConfigTemplateHeader,Vendor."No.",DATABASE::Vendor);
      Vendor.FIND;
    END;

    [External]
    PROCEDURE UpdateVendorsFromTemplate@6(VAR Vendor@1000 : Record 23);
    VAR
      ConfigTemplateHeader@1001 : Record 8618;
      DimensionsTemplate@1004 : Record 1302;
      ConfigTemplates@1003 : Page 1340;
      VendorRecRef@1002 : RecordRef;
    BEGIN
      IF GUIALLOWED THEN BEGIN
        ConfigTemplateHeader.SETRANGE("Table ID",DATABASE::Vendor);
        ConfigTemplateHeader.SETRANGE(Enabled,TRUE);
        ConfigTemplates.SETTABLEVIEW(ConfigTemplateHeader);
        ConfigTemplates.LOOKUPMODE(TRUE);
        IF ConfigTemplates.RUNMODAL = ACTION::LookupOK THEN BEGIN
          ConfigTemplates.GETRECORD(ConfigTemplateHeader);
          VendorRecRef.GETTABLE(Vendor);
          IF VendorRecRef.FINDSET THEN
            REPEAT
              ConfigTemplateManagement.UpdateRecord(ConfigTemplateHeader,VendorRecRef);
              DimensionsTemplate.InsertDimensionsFromTemplates(ConfigTemplateHeader,Vendor."No.",DATABASE::Vendor);
            UNTIL VendorRecRef.NEXT = 0;
          VendorRecRef.SETTABLE(Vendor);
        END;
      END;
    END;

    LOCAL PROCEDURE InitVendorNo@9(VAR Vendor@1000 : Record 23;ConfigTemplateHeader@1004 : Record 8618);
    VAR
      NoSeriesMgt@1002 : Codeunit 396;
    BEGIN
      IF ConfigTemplateHeader."Instance No. Series" = '' THEN
        EXIT;
      NoSeriesMgt.InitSeries(ConfigTemplateHeader."Instance No. Series",'',0D,Vendor."No.",Vendor."No. Series");
    END;

    BEGIN
    END.
  }
}

