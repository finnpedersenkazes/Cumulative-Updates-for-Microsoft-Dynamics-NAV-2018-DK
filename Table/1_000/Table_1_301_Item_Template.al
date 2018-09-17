OBJECT Table 1301 Item Template
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
               ConfigTemplateManagement.UpdateConfigTemplateAndLines(Code,"Template Name",DATABASE::Item,FieldRefArray);
             END;

    OnDelete=VAR
               ConfigTemplateHeader@1000 : Record 8618;
             BEGIN
               IF ConfigTemplateHeader.GET(Code) THEN BEGIN
                 ConfigTemplateManagement.DeleteRelatedTemplates(Code,DATABASE::"Default Dimension");
                 ConfigTemplateHeader.DELETE(TRUE);
               END;
             END;

    CaptionML=[DAN=Vareskabelon;
               ENU=Item Template];
  }
  FIELDS
  {
    { 1   ;   ;Key                 ;Integer       ;AutoIncrement=Yes;
                                                   CaptionML=[DAN=N›gle;
                                                              ENU=Key] }
    { 2   ;   ;Code                ;Code10        ;OnValidate=VAR
                                                                InventorySetup@1000 : Record 313;
                                                              BEGIN
                                                                InventorySetup.GET;
                                                                "Costing Method" := InventorySetup."Default Costing Method";
                                                              END;

                                                   CaptionML=[DAN=Kode;
                                                              ENU=Code];
                                                   NotBlank=Yes }
    { 3   ;   ;Template Name       ;Text50        ;CaptionML=[DAN=Typenavn;
                                                              ENU=Template Name];
                                                   NotBlank=Yes }
    { 8   ;   ;Base Unit of Measure;Code10        ;TableRelation="Unit of Measure";
                                                   CaptionML=[DAN=Basisenhed;
                                                              ENU=Base Unit of Measure] }
    { 10  ;   ;Type                ;Option        ;OnValidate=BEGIN
                                                                IF Type = Type::Service THEN
                                                                  VALIDATE("Inventory Posting Group",'');
                                                              END;

                                                   CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=Lager,Service;
                                                                    ENU=Inventory,Service];
                                                   OptionString=Inventory,Service }
    { 11  ;   ;Inventory Posting Group;Code20     ;TableRelation="Inventory Posting Group";
                                                   CaptionML=[DAN=Varebogf›ringsgruppe;
                                                              ENU=Inventory Posting Group] }
    { 14  ;   ;Item Disc. Group    ;Code20        ;TableRelation="Item Discount Group";
                                                   CaptionML=[DAN=Varerabatgruppe;
                                                              ENU=Item Disc. Group] }
    { 15  ;   ;Allow Invoice Disc. ;Boolean       ;InitValue=Yes;
                                                   CaptionML=[DAN=Tillad fakturarabat;
                                                              ENU=Allow Invoice Disc.] }
    { 19  ;   ;Price/Profit Calculation;Option    ;CaptionML=[DAN=Avancepct.beregning;
                                                              ENU=Price/Profit Calculation];
                                                   OptionCaptionML=[DAN="Avance=Salgspris-Kostpris,Salgspris=Kostpris+Avance,Ingen";
                                                                    ENU="Profit=Price-Cost,Price=Cost+Profit,No Relationship"];
                                                   OptionString=Profit=Price-Cost,Price=Cost+Profit,No Relationship }
    { 20  ;   ;Profit %            ;Decimal       ;CaptionML=[DAN=Avancepct.;
                                                              ENU=Profit %];
                                                   DecimalPlaces=0:5;
                                                   MaxValue=100 }
    { 21  ;   ;Costing Method      ;Option        ;CaptionML=[DAN=Kostprisberegningsmetode;
                                                              ENU=Costing Method];
                                                   OptionCaptionML=[DAN=FIFO,LIFO,Serienummer,Gennemsnit,Standard;
                                                                    ENU=FIFO,LIFO,Specific,Average,Standard];
                                                   OptionString=FIFO,LIFO,Specific,Average,Standard }
    { 28  ;   ;Indirect Cost %     ;Decimal       ;CaptionML=[DAN=Indir. omkost.pct.;
                                                              ENU=Indirect Cost %];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 87  ;   ;Price Includes VAT  ;Boolean       ;CaptionML=[DAN=Salgspris inkl. moms;
                                                              ENU=Price Includes VAT] }
    { 91  ;   ;Gen. Prod. Posting Group;Code20    ;TableRelation="Gen. Product Posting Group";
                                                   CaptionML=[DAN=Produktbogf›ringsgruppe;
                                                              ENU=Gen. Prod. Posting Group] }
    { 96  ;   ;Automatic Ext. Texts;Boolean       ;CaptionML=[DAN=Automatisk udv. tekster;
                                                              ENU=Automatic Ext. Texts] }
    { 98  ;   ;Tax Group Code      ;Code20        ;TableRelation="Tax Group";
                                                   CaptionML=[DAN=Skattegruppekode;
                                                              ENU=Tax Group Code] }
    { 99  ;   ;VAT Prod. Posting Group;Code20     ;TableRelation="VAT Product Posting Group";
                                                   CaptionML=[DAN=Momsproduktbogf.gruppe;
                                                              ENU=VAT Prod. Posting Group] }
    { 5702;   ;Item Category Code  ;Code20        ;TableRelation="Item Category";
                                                   CaptionML=[DAN=Varekategorikode;
                                                              ENU=Item Category Code] }
    { 5900;   ;Service Item Group  ;Code10        ;TableRelation="Service Item Group".Code;
                                                   CaptionML=[DAN=Serviceartikelgruppe;
                                                              ENU=Service Item Group] }
    { 7300;   ;Warehouse Class Code;Code10        ;TableRelation="Warehouse Class";
                                                   CaptionML=[DAN=Lagerklassekode;
                                                              ENU=Warehouse Class Code] }
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

      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO(Type)));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Base Unit of Measure")));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Automatic Ext. Texts")));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Gen. Prod. Posting Group")));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("VAT Prod. Posting Group")));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Inventory Posting Group")));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Costing Method")));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Indirect Cost %")));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Price Includes VAT")));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Profit %")));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Price/Profit Calculation")));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Allow Invoice Disc.")));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Item Disc. Group")));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Tax Group Code")));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Warehouse Class Code")));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Item Category Code")));
      AddToArray(FieldRefArray,I,RecRef.FIELD(FIELDNO("Service Item Group")));
    END;

    LOCAL PROCEDURE AddToArray@4(VAR FieldRefArray@1000 : ARRAY [17] OF FieldRef;VAR I@1001 : Integer;CurrFieldRef@1002 : FieldRef);
    BEGIN
      FieldRefArray[I] := CurrFieldRef;
      I += 1;
    END;

    [External]
    PROCEDURE InitializeTempRecordFromConfigTemplate@1(VAR TempItemTemplate@1000 : TEMPORARY Record 1301;ConfigTemplateHeader@1001 : Record 8618);
    VAR
      RecRef@1003 : RecordRef;
    BEGIN
      TempItemTemplate.SETRANGE(Code,ConfigTemplateHeader.Code);
      TempItemTemplate.SETRANGE("Template Name",ConfigTemplateHeader.Description);
      IF NOT TempItemTemplate.FINDFIRST THEN BEGIN
        TempItemTemplate.INIT;
        TempItemTemplate.Code := ConfigTemplateHeader.Code;
        TempItemTemplate."Template Name" := ConfigTemplateHeader.Description;
        TempItemTemplate.INSERT;
      END;

      RecRef.GETTABLE(TempItemTemplate);

      ConfigTemplateManagement.ApplyTemplateLinesWithoutValidation(ConfigTemplateHeader,RecRef);

      RecRef.SETTABLE(TempItemTemplate);
    END;

    [External]
    PROCEDURE CreateConfigTemplateFromExistingItem@5(Item@1000 : Record 27;VAR TempItemTemplate@1001 : TEMPORARY Record 1301);
    VAR
      DimensionsTemplate@1002 : Record 1302;
      ConfigTemplateHeader@1010 : Record 8618;
      RecRef@1008 : RecordRef;
      FieldRefArray@1004 : ARRAY [17] OF FieldRef;
      NewTemplateCode@1011 : Code[10];
    BEGIN
      RecRef.GETTABLE(Item);
      CreateFieldRefArray(FieldRefArray,RecRef);

      ConfigTemplateManagement.CreateConfigTemplateAndLines(NewTemplateCode,'',DATABASE::Item,FieldRefArray);
      DimensionsTemplate.CreateTemplatesFromExistingMasterRecord(Item."No.",NewTemplateCode,DATABASE::Item);
      ConfigTemplateHeader.GET(NewTemplateCode);
      InitializeTempRecordFromConfigTemplate(TempItemTemplate,ConfigTemplateHeader);
    END;

    [External]
    PROCEDURE SaveAsTemplate@7(Item@1000 : Record 27);
    VAR
      TempItemTemplate@1001 : TEMPORARY Record 1301;
      ItemTemplateCard@1002 : Page 1342;
    BEGIN
      ItemTemplateCard.CreateFromItem(Item);
      ItemTemplateCard.SETRECORD(TempItemTemplate);
      ItemTemplateCard.LOOKUPMODE := TRUE;
      IF ItemTemplateCard.RUNMODAL = ACTION::LookupOK THEN;
    END;

    LOCAL PROCEDURE InsertConfigurationTemplateHeaderAndLines@2();
    VAR
      FieldRefArray@1001 : ARRAY [17] OF FieldRef;
      RecRef@1000 : RecordRef;
    BEGIN
      RecRef.GETTABLE(Rec);
      CreateFieldRefArray(FieldRefArray,RecRef);
      ConfigTemplateManagement.CreateConfigTemplateAndLines(Code,"Template Name",DATABASE::Item,FieldRefArray);
    END;

    [External]
    PROCEDURE NewItemFromTemplate@3(VAR Item@1002 : Record 27) : Boolean;
    VAR
      ConfigTemplateHeader@1004 : Record 8618;
      ConfigTemplates@1001 : Page 1340;
    BEGIN
      ConfigTemplateHeader.SETRANGE("Table ID",DATABASE::Item);
      ConfigTemplateHeader.SETRANGE(Enabled,TRUE);

      IF ConfigTemplateHeader.COUNT = 1 THEN BEGIN
        ConfigTemplateHeader.FINDFIRST;
        InsertItemFromTemplate(ConfigTemplateHeader,Item);
        EXIT(TRUE);
      END;

      IF (ConfigTemplateHeader.COUNT > 1) AND GUIALLOWED THEN BEGIN
        ConfigTemplates.SETTABLEVIEW(ConfigTemplateHeader);
        ConfigTemplates.LOOKUPMODE(TRUE);
        ConfigTemplates.SetNewMode;
        IF ConfigTemplates.RUNMODAL = ACTION::LookupOK THEN BEGIN
          ConfigTemplates.GETRECORD(ConfigTemplateHeader);
          InsertItemFromTemplate(ConfigTemplateHeader,Item);
          EXIT(TRUE);
        END;
      END;

      EXIT(FALSE);
    END;

    [External]
    PROCEDURE UpdateItemFromTemplate@8(VAR Item@1000 : Record 27);
    VAR
      ConfigTemplateHeader@1001 : Record 8618;
      DimensionsTemplate@1004 : Record 1302;
      ConfigTemplates@1003 : Page 1340;
      ItemRecRef@1002 : RecordRef;
    BEGIN
      IF GUIALLOWED THEN BEGIN
        ConfigTemplateHeader.SETRANGE("Table ID",DATABASE::Item);
        ConfigTemplateHeader.SETRANGE(Enabled,TRUE);
        ConfigTemplates.SETTABLEVIEW(ConfigTemplateHeader);
        ConfigTemplates.LOOKUPMODE(TRUE);
        IF ConfigTemplates.RUNMODAL = ACTION::LookupOK THEN BEGIN
          ConfigTemplates.GETRECORD(ConfigTemplateHeader);
          ItemRecRef.GETTABLE(Item);
          ConfigTemplateManagement.UpdateRecord(ConfigTemplateHeader,ItemRecRef);
          DimensionsTemplate.InsertDimensionsFromTemplates(ConfigTemplateHeader,Item."No.",DATABASE::Item);
          ItemRecRef.SETTABLE(Item);
          Item.FIND;
        END;
      END;
    END;

    [External]
    PROCEDURE InsertItemFromTemplate@16(ConfigTemplateHeader@1006 : Record 8618;VAR Item@1003 : Record 27);
    VAR
      DimensionsTemplate@1001 : Record 1302;
      UnitOfMeasure@1004 : Record 204;
      ConfigTemplateMgt@1002 : Codeunit 8612;
      RecRef@1000 : RecordRef;
    BEGIN
      InitItemNo(Item,ConfigTemplateHeader);
      Item.INSERT(TRUE);
      RecRef.GETTABLE(Item);
      ConfigTemplateMgt.UpdateRecord(ConfigTemplateHeader,RecRef);
      RecRef.SETTABLE(Item);
      IF Item."Base Unit of Measure" = '' THEN BEGIN
        UnitOfMeasure.SETRANGE("International Standard Code",'EA'); // 'Each' ~= 'PCS'
        IF NOT UnitOfMeasure.FINDFIRST THEN BEGIN
          UnitOfMeasure.SETRANGE("International Standard Code");
          IF UnitOfMeasure.FINDFIRST THEN;
        END;
        Item.VALIDATE("Base Unit of Measure",UnitOfMeasure.Code);
        Item.MODIFY(TRUE);
      END;
      DimensionsTemplate.InsertDimensionsFromTemplates(ConfigTemplateHeader,Item."No.",DATABASE::Item);
      Item.FIND;
    END;

    [External]
    PROCEDURE UpdateItemsFromTemplate@6(VAR Item@1000 : Record 27);
    VAR
      ConfigTemplateHeader@1001 : Record 8618;
      DimensionsTemplate@1004 : Record 1302;
      ConfigTemplates@1003 : Page 1340;
      ItemRecRef@1002 : RecordRef;
    BEGIN
      IF GUIALLOWED THEN BEGIN
        ConfigTemplateHeader.SETRANGE("Table ID",DATABASE::Item);
        ConfigTemplateHeader.SETRANGE(Enabled,TRUE);
        ConfigTemplates.SETTABLEVIEW(ConfigTemplateHeader);
        ConfigTemplates.LOOKUPMODE(TRUE);
        IF ConfigTemplates.RUNMODAL = ACTION::LookupOK THEN BEGIN
          ConfigTemplates.GETRECORD(ConfigTemplateHeader);
          ItemRecRef.GETTABLE(Item);
          IF ItemRecRef.FINDSET THEN
            REPEAT
              ConfigTemplateManagement.UpdateRecord(ConfigTemplateHeader,ItemRecRef);
              DimensionsTemplate.InsertDimensionsFromTemplates(ConfigTemplateHeader,Item."No.",DATABASE::Item);
            UNTIL ItemRecRef.NEXT = 0;
          ItemRecRef.SETTABLE(Item);
        END;
      END;
    END;

    LOCAL PROCEDURE InitItemNo@9(VAR Item@1000 : Record 27;ConfigTemplateHeader@1004 : Record 8618);
    VAR
      NoSeriesMgt@1002 : Codeunit 396;
    BEGIN
      IF ConfigTemplateHeader."Instance No. Series" = '' THEN
        EXIT;
      NoSeriesMgt.InitSeries(ConfigTemplateHeader."Instance No. Series",'',0D,Item."No.",Item."No. Series");
    END;

    BEGIN
    END.
  }
}

