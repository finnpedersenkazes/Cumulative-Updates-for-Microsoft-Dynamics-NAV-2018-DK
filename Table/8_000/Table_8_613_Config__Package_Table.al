OBJECT Table 8613 Config. Package Table
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
               InitPackageFields;
             END;

    OnDelete=VAR
               ConfigLine@1003 : Record 8622;
               ConfigPackageField@1001 : Record 8616;
               ConfigPackageFilter@1000 : Record 8626;
               ConfigTableProcessingRule@1002 : Record 8631;
             BEGIN
               DeletePackageData;

               ConfigPackageField.SETRANGE("Package Code","Package Code");
               ConfigPackageField.SETRANGE("Table ID","Table ID");
               ConfigPackageField.DELETEALL(TRUE);

               ConfigPackageFilter.SETRANGE("Package Code","Package Code");
               ConfigPackageFilter.SETRANGE("Table ID","Table ID");
               ConfigPackageFilter.DELETEALL;

               ConfigTableProcessingRule.SETRANGE("Package Code","Package Code");
               ConfigTableProcessingRule.SETRANGE("Table ID","Table ID");
               ConfigTableProcessingRule.DELETEALL(TRUE);

               ConfigLine.SETRANGE("Package Code","Package Code");
               ConfigLine.SETRANGE("Table ID","Table ID");
               IF ConfigLine.FINDSET(TRUE) THEN
                 REPEAT
                   ConfigLine."Package Code" := '';
                   ConfigLine."Dimensions as Columns" := FALSE;
                   ConfigLine.MODIFY;
                 UNTIL ConfigLine.NEXT = 0;
             END;

    OnRename=BEGIN
               ERROR(Text004);
             END;

    CaptionML=[DAN=Konfig.pakketabel;
               ENU=Config. Package Table];
  }
  FIELDS
  {
    { 1   ;   ;Package Code        ;Code20        ;TableRelation="Config. Package";
                                                   CaptionML=[DAN=Pakkekode;
                                                              ENU=Package Code] }
    { 2   ;   ;Table ID            ;Integer       ;TableRelation=AllObjWithCaption."Object ID" WHERE (Object Type=CONST(Table));
                                                   OnValidate=BEGIN
                                                                IF ConfigMgt.IsSystemTable("Table ID") THEN
                                                                  ERROR(Text001,"Table ID");

                                                                IF "Table ID" <> xRec."Table ID" THEN
                                                                  "Page ID" := ConfigMgt.FindPage("Table ID");
                                                              END;

                                                   OnLookup=BEGIN
                                                              ConfigValidateMgt.LookupTable("Table ID");
                                                              IF "Table ID" <> 0 THEN
                                                                VALIDATE("Table ID");
                                                            END;

                                                   CaptionML=[DAN=Tabel-id;
                                                              ENU=Table ID];
                                                   NotBlank=Yes }
    { 3   ;   ;Table Name          ;Text250       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(AllObjWithCaption."Object Name" WHERE (Object Type=CONST(Table),
                                                                                                             Object ID=FIELD(Table ID)));
                                                   CaptionML=[DAN=Tabelnavn;
                                                              ENU=Table Name];
                                                   Editable=No }
    { 4   ;   ;No. of Package Records;Integer     ;FieldClass=FlowField;
                                                   CalcFormula=Count("Config. Package Record" WHERE (Package Code=FIELD(Package Code),
                                                                                                     Table ID=FIELD(Table ID)));
                                                   CaptionML=[DAN=Antal pakkerecords;
                                                              ENU=No. of Package Records];
                                                   Editable=No }
    { 5   ;   ;No. of Package Errors;Integer      ;FieldClass=FlowField;
                                                   CalcFormula=Count("Config. Package Error" WHERE (Package Code=FIELD(Package Code),
                                                                                                    Table ID=FIELD(Table ID)));
                                                   CaptionML=[DAN=Antal pakkefejl;
                                                              ENU=No. of Package Errors];
                                                   Editable=No }
    { 7   ;   ;Imported Date and Time;DateTime    ;CaptionML=[DAN=Dato/klokkesl‘t for indl‘sning;
                                                              ENU=Imported Date and Time];
                                                   Editable=No }
    { 8   ;   ;Exported Date and Time;DateTime    ;CaptionML=[DAN=Dato/klokkesl‘t for udl‘sning;
                                                              ENU=Exported Date and Time];
                                                   Editable=No }
    { 9   ;   ;Comments            ;Text250       ;CaptionML=[DAN=Bem‘rkninger;
                                                              ENU=Comments] }
    { 10  ;   ;Created Date and Time;DateTime     ;CaptionML=[DAN=Oprettet dato og klokkesl‘t;
                                                              ENU=Created Date and Time] }
    { 11  ;   ;Company Filter (Source Table);Text30;
                                                   FieldClass=FlowFilter;
                                                   TableRelation=Company;
                                                   CaptionML=[DAN=Regnskabsfilter (Kildetabel);
                                                              ENU=Company Filter (Source Table)] }
    { 12  ;   ;Table Caption       ;Text250       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(AllObjWithCaption."Object Caption" WHERE (Object Type=CONST(Table),
                                                                                                                Object ID=FIELD(Table ID)));
                                                   CaptionML=[DAN=Tabeltitel;
                                                              ENU=Table Caption];
                                                   Editable=No }
    { 13  ;   ;Data Template       ;Code10        ;TableRelation="Config. Template Header";
                                                   CaptionML=[DAN=Dataskabelon;
                                                              ENU=Data Template] }
    { 14  ;   ;Package Processing Order;Integer   ;CaptionML=[DAN=Pakkebehandlingsordre;
                                                              ENU=Package Processing Order];
                                                   Editable=No }
    { 15  ;   ;Page ID             ;Integer       ;TableRelation=AllObjWithCaption."Object ID" WHERE (Object Type=CONST(Page));
                                                   OnLookup=BEGIN
                                                              ConfigValidateMgt.LookupPage("Page ID");
                                                              VALIDATE("Page ID");
                                                            END;

                                                   CaptionML=[DAN=Side-id;
                                                              ENU=Page ID] }
    { 16  ;   ;Processing Order    ;Integer       ;CaptionML=[DAN=Behandlingsordre;
                                                              ENU=Processing Order] }
    { 17  ;   ;No. of Fields Included;Integer     ;FieldClass=FlowField;
                                                   CalcFormula=Count("Config. Package Field" WHERE (Package Code=FIELD(Package Code),
                                                                                                    Table ID=FIELD(Table ID),
                                                                                                    Include Field=CONST(Yes)));
                                                   CaptionML=[DAN=Antal inkluderede felter;
                                                              ENU=No. of Fields Included];
                                                   Editable=No }
    { 18  ;   ;No. of Fields Available;Integer    ;FieldClass=FlowField;
                                                   CalcFormula=Count("Config. Package Field" WHERE (Package Code=FIELD(Package Code),
                                                                                                    Table ID=FIELD(Table ID)));
                                                   CaptionML=[DAN=Antal disp. felter;
                                                              ENU=No. of Fields Available];
                                                   Editable=No }
    { 19  ;   ;No. of Fields to Validate;Integer  ;FieldClass=FlowField;
                                                   CalcFormula=Count("Config. Package Field" WHERE (Package Code=FIELD(Package Code),
                                                                                                    Table ID=FIELD(Table ID),
                                                                                                    Validate Field=CONST(Yes)));
                                                   CaptionML=[DAN=Antal felter, der skal valideres;
                                                              ENU=No. of Fields to Validate];
                                                   Editable=No }
    { 20  ;   ;Package Caption     ;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Config. Package"."Package Name" WHERE (Code=FIELD(Package Code)));
                                                   CaptionML=[DAN=Overskrift - pakke;
                                                              ENU=Package Caption];
                                                   Editable=No }
    { 21  ;   ;Imported by User ID ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserManagement@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserManagement.LookupUserID("Imported by User ID");
                                                            END;

                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Importeret af bruger-id;
                                                              ENU=Imported by User ID];
                                                   Editable=No }
    { 22  ;   ;Created by User ID  ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserManagement@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserManagement.LookupUserID("Created by User ID");
                                                            END;

                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Oprettet af bruger-id;
                                                              ENU=Created by User ID];
                                                   Editable=No }
    { 24  ;   ;Dimensions as Columns;Boolean      ;OnValidate=BEGIN
                                                                IF "Dimensions as Columns" THEN BEGIN
                                                                  InitDimensionFields;
                                                                  UpdateDimensionsPackageData;
                                                                END ELSE
                                                                  DeleteDimensionFields;
                                                              END;

                                                   CaptionML=[DAN=Dimensioner som kolonner;
                                                              ENU=Dimensions as Columns] }
    { 25  ;   ;Filtered            ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Config. Package Filter" WHERE (Package Code=FIELD(Package Code),
                                                                                                     Table ID=FIELD(Table ID)));
                                                   CaptionML=[DAN=Filtreret;
                                                              ENU=Filtered];
                                                   Editable=No }
    { 26  ;   ;Skip Table Triggers ;Boolean       ;CaptionML=[DAN=Spring tabeludl›sere over;
                                                              ENU=Skip Table Triggers] }
    { 27  ;   ;Delete Recs Before Processing;Boolean;
                                                   CaptionML=[DAN=Slet records f›r behandling;
                                                              ENU=Delete Recs Before Processing] }
    { 28  ;   ;Processing Report ID;Integer       ;TableRelation=AllObjWithCaption."Object ID" WHERE (Object Type=CONST(Report));
                                                   CaptionML=[DAN=Behandler rapport-id;
                                                              ENU=Processing Report ID] }
    { 29  ;   ;Parent Table ID     ;Integer       ;TableRelation="Config. Package Table"."Table ID" WHERE (Package Code=FIELD(Package Code),
                                                                                                           Parent Table ID=CONST(0));
                                                   OnValidate=VAR
                                                                ConfigPackageTableChild@1000 : Record 8613;
                                                              BEGIN
                                                                IF "Table ID" = "Parent Table ID" THEN
                                                                  FIELDERROR("Parent Table ID",STRSUBSTNO(CannotBeEqualToErr,FIELDCAPTION("Table ID")));

                                                                ConfigPackageTableChild.SETRANGE("Package Code","Package Code");
                                                                ConfigPackageTableChild.SETRANGE("Parent Table ID","Table ID");
                                                                IF NOT ConfigPackageTableChild.ISEMPTY THEN
                                                                  FIELDERROR("Parent Table ID",STRSUBSTNO(CannotBeSetDueToRelatedTablesErr,"Table ID"));
                                                              END;

                                                   CaptionML=[DAN=Overordnet tabel-id;
                                                              ENU=Parent Table ID] }
    { 30  ;   ;Validated           ;Boolean       ;CaptionML=[DAN=Valideret;
                                                              ENU=Validated] }
  }
  KEYS
  {
    {    ;Package Code,Table ID                   ;Clustered=Yes }
    {    ;Package Processing Order,Processing Order }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text001@1001 : TextConst 'DAN=Du kan ikke bruge systemtabel %1 i pakken.;ENU=You cannot use system table %1 in the package.';
      Text002@1005 : TextConst 'DAN=Du kan ikke bruge funktionen Dimensioner som kolonner for tabel %1.;ENU=You cannot use the Dimensions as Columns function for table %1.';
      Text003@1006 : TextConst 'DAN=Standarddimensionen og Dimensionsv‘rditabeller skal v‘re inkluderet i pakken %1, f›r du kan aktivere denne indstilling. De manglende tabeller vil blive tilf›jet pakken. Vil du forts‘tte?;ENU=The Default Dimension and Dimension Value tables must be included in the package %1 to enable this option. The missing tables will be added to the package. Do you want to continue?';
      Text004@1008 : TextConst 'DAN=Du kan ikke omd›be konfigurationspakketabellen.;ENU=You cannot rename the configuration package table.';
      Text005@1009 : TextConst 'DAN=Ops‘tningen af dimensioner som kolonner blev annulleret.;ENU=The setup of Dimensions as Columns was canceled.';
      Text010@1003 : TextConst 'DAN=Definer specifikationssiden i feltet %1.;ENU=Define the drill-down page in the %1 field.';
      ConfigValidateMgt@1000 : Codeunit 8617;
      ConfigMgt@1002 : Codeunit 8616;
      ConfigPackageMgt@1004 : Codeunit 8611;
      HideValidationDialog@1010 : Boolean;
      i@1007 : Integer;
      CannotBeEqualToErr@1011 : TextConst '@@@=%1 - name of the field "Table ID";DAN=m† ikke v‘re lig med %1.;ENU=cannot be equal to %1.';
      CannotBeSetDueToRelatedTablesErr@1012 : TextConst '@@@=%1 - an integer value;DAN=skal v‘re 0, fordi der er relaterede tabeller, hvor det overordnede tabel-id er %1.;ENU=must be 0 because there are related tables, where Parent Table ID is %1.';

    LOCAL PROCEDURE InitPackageFields@1() : Boolean;
    VAR
      ConfigPackageField@1001 : Record 8616;
      ConfigLine@1004 : Record 8622;
      Field@1000 : Record 2000000041;
      ProcessingOrder@1002 : Integer;
      FieldsAdded@1003 : Boolean;
    BEGIN
      FieldsAdded := FALSE;
      ConfigPackageMgt.SetFieldFilter(Field,"Table ID",0);
      IF Field.FINDSET THEN
        REPEAT
          IF NOT ConfigPackageField.GET("Package Code","Table ID",Field."No.") AND
             NOT ConfigPackageMgt.IsDimSetIDField("Table ID",Field."No.")
          THEN BEGIN
            ConfigPackageMgt.InsertPackageField(
              ConfigPackageField,"Package Code","Table ID",Field."No.",Field.FieldName,Field."Field Caption",
              TRUE,TRUE,FALSE,FALSE);
            ConfigPackageField.SETRANGE("Package Code","Package Code");
            ConfigPackageField.SETRANGE("Table ID","Table ID");
            ConfigPackageField.SETRANGE("Field ID",Field."No.");
            ConfigPackageMgt.SelectAllPackageFields(ConfigPackageField,TRUE);
            FieldsAdded := TRUE;
          END;
        UNTIL Field.NEXT = 0;

      IF FieldsAdded THEN BEGIN
        ProcessingOrder := 0;
        SetProcessingOrderPrimaryKey("Package Code","Table ID",ProcessingOrder);
        ConfigPackageField.RESET;
        ConfigPackageField.SETRANGE("Package Code","Package Code");
        ConfigPackageField.SETRANGE("Table ID","Table ID");
        ConfigPackageField.SETRANGE("Primary Key",FALSE);
        IF "Table ID" <> DATABASE::"Config. Line" THEN
          SetProcessingOrderFields(ConfigPackageField,ProcessingOrder)
        ELSE BEGIN
          ConfigPackageField.SETRANGE("Field ID",ConfigLine.FIELDNO("Line Type"),ConfigLine.FIELDNO("Table ID"));
          SetProcessingOrderFields(ConfigPackageField,ProcessingOrder);
          // package code must be processed just after table ID!
          ConfigPackageField.SETRANGE("Field ID",ConfigLine.FIELDNO("Package Code"));
          SetProcessingOrderFields(ConfigPackageField,ProcessingOrder);
          ConfigPackageField.SETRANGE("Field ID",ConfigLine.FIELDNO(Name),ConfigLine.FIELDNO("Package Code") - 1);
          SetProcessingOrderFields(ConfigPackageField,ProcessingOrder);
          ConfigPackageField.SETFILTER("Field ID",'%1..',ConfigLine.FIELDNO("Package Code") + 1);
          SetProcessingOrderFields(ConfigPackageField,ProcessingOrder);
        END;
      END;

      EXIT(FieldsAdded);
    END;

    LOCAL PROCEDURE SetProcessingOrderPrimaryKey@17(PackageCode@1006 : Code[20];TableID@1007 : Integer;VAR ProcessingOrder@1000 : Integer);
    VAR
      ConfigPackageField@1001 : Record 8616;
      RecRef@1004 : RecordRef;
      KeyRef@1003 : KeyRef;
      FieldRef@1002 : FieldRef;
      KeyFieldCount@1005 : Integer;
    BEGIN
      RecRef.OPEN(TableID);
      KeyRef := RecRef.KEYINDEX(1);
      FOR KeyFieldCount := 1 TO KeyRef.FIELDCOUNT DO BEGIN
        FieldRef := KeyRef.FIELDINDEX(KeyFieldCount);
        ConfigPackageField.GET(PackageCode,TableID,FieldRef.NUMBER);
        ProcessingOrder += 1;
        ConfigPackageField."Processing Order" := ProcessingOrder;
        ConfigPackageField.MODIFY;
      END;
    END;

    LOCAL PROCEDURE SetProcessingOrderFields@9(VAR ConfigPackageField@1000 : Record 8616;VAR ProcessingOrder@1002 : Integer);
    BEGIN
      IF ConfigPackageField.FINDSET THEN
        REPEAT
          ProcessingOrder += 1;
          ConfigPackageField."Processing Order" := ProcessingOrder;
          ConfigPackageField.MODIFY;
        UNTIL ConfigPackageField.NEXT = 0;
    END;

    [Internal]
    PROCEDURE InitDimensionFields@3();
    VAR
      Dimension@1002 : Record 348;
      ConfigPackageField@1000 : Record 8616;
      ConfigPackageTable@1001 : Record 8613;
      Confirmed@1004 : Boolean;
    BEGIN
      IF NOT (ConfigMgt.IsDimSetIDTable("Table ID") OR ConfigMgt.IsDefaultDimTable("Table ID")) THEN
        ERROR(Text002,"Table ID");

      IF ConfigMgt.IsDefaultDimTable("Table ID") THEN BEGIN
        Confirmed :=
          (ConfigPackageTable.GET("Package Code",DATABASE::"Dimension Value") AND
           ConfigPackageTable.GET("Package Code",DATABASE::"Default Dimension")) OR
          (HideValidationDialog OR NOT GUIALLOWED);
        IF NOT Confirmed THEN
          Confirmed := CONFIRM(Text003,TRUE,"Package Code");
        IF Confirmed THEN BEGIN
          ConfigPackageMgt.InsertPackageTable(ConfigPackageTable,"Package Code",DATABASE::"Dimension Value");
          ConfigPackageMgt.InsertPackageTable(ConfigPackageTable,"Package Code",DATABASE::"Default Dimension");
        END ELSE
          ERROR(Text005);
      END;

      i := 0;
      IF Dimension.FINDSET THEN
        REPEAT
          i := i + 1;
          ConfigPackageMgt.InsertPackageField(
            ConfigPackageField,"Package Code","Table ID",ConfigMgt.DimensionFieldID + i,
            Dimension.Code,Dimension."Code Caption",TRUE,FALSE,FALSE,TRUE);
        UNTIL Dimension.NEXT = 0;
    END;

    [External]
    PROCEDURE DeletePackageData@8();
    VAR
      ConfigPackageRecord@1001 : Record 8614;
    BEGIN
      ConfigPackageRecord.SETRANGE("Package Code","Package Code");
      ConfigPackageRecord.SETRANGE("Table ID","Table ID");
      ConfigPackageRecord.DELETEALL(TRUE);
    END;

    LOCAL PROCEDURE DeleteDimensionFields@7();
    VAR
      ConfigPackageField@1000 : Record 8616;
      ConfigPackageData@1002 : Record 8615;
    BEGIN
      ConfigPackageData.SETRANGE("Package Code","Package Code");
      ConfigPackageData.SETRANGE("Table ID","Table ID");
      ConfigPackageData.SETRANGE("Field ID",ConfigMgt.DimensionFieldID,ConfigMgt.DimensionFieldID + 999);
      ConfigPackageData.DELETEALL;

      ConfigPackageField.SETRANGE("Package Code","Package Code");
      ConfigPackageField.SETRANGE("Table ID","Table ID");
      ConfigPackageField.SETRANGE(Dimension,TRUE);
      ConfigPackageField.DELETEALL;
    END;

    [External]
    PROCEDURE DimensionFieldsCount@2() : Integer;
    VAR
      ConfigPackageField@1000 : Record 8616;
    BEGIN
      ConfigPackageField.SETRANGE("Package Code","Package Code");
      ConfigPackageField.SETRANGE("Table ID","Table ID");
      ConfigPackageField.SETRANGE(Dimension,TRUE);
      EXIT(ConfigPackageField.COUNT);
    END;

    [External]
    PROCEDURE DimensionPackageDataExist@6() : Boolean;
    VAR
      ConfigPackageData@1000 : Record 8615;
    BEGIN
      ConfigPackageData.SETRANGE("Package Code","Package Code");
      ConfigPackageData.SETRANGE("Table ID","Table ID");
      ConfigPackageData.SETRANGE("Field ID",ConfigMgt.DimensionFieldID,ConfigMgt.DimensionFieldID + 999);
      EXIT(NOT ConfigPackageData.ISEMPTY);
    END;

    [External]
    PROCEDURE ShowPackageRecords@5(Show@1004 : 'Records,Errors,All';ShowDim@1003 : Boolean);
    VAR
      ConfigPackageField@1000 : Record 8616;
      ConfigPackageRecord@1001 : Record 8614;
      ConfigPackageRecords@1002 : Page 8626;
      MatrixColumnCaptions@1005 : ARRAY [1000] OF Text[100];
    BEGIN
      ConfigPackageField.SETRANGE("Package Code","Package Code");
      ConfigPackageField.SETRANGE("Table ID","Table ID");
      ConfigPackageField.SETRANGE("Include Field",TRUE);
      IF NOT ShowDim THEN
        ConfigPackageField.SETRANGE(Dimension,FALSE);
      i := 1;
      CLEAR(MatrixColumnCaptions);
      IF ConfigPackageField.FINDSET THEN
        REPEAT
          MatrixColumnCaptions[i] := ConfigPackageField."Field Name";
          i := i + 1;
        UNTIL ConfigPackageField.NEXT = 0;

      CALCFIELDS("Table Caption");
      CLEAR(ConfigPackageRecords);
      ConfigPackageRecord.SETRANGE("Package Code","Package Code");
      ConfigPackageRecord.SETRANGE("Table ID","Table ID");
      CASE Show OF
        Show::Records:
          ConfigPackageRecord.SETRANGE(Invalid,FALSE);
        Show::Errors:
          ConfigPackageRecord.SETRANGE(Invalid,TRUE);
      END;
      ConfigPackageRecords.SETTABLEVIEW(ConfigPackageRecord);
      ConfigPackageRecords.LOOKUPMODE(TRUE);
      ConfigPackageRecords.Load(MatrixColumnCaptions,"Table Caption","Package Code","Table ID",ShowDim);
      ConfigPackageRecords.RUNMODAL;
    END;

    [External]
    PROCEDURE ShowDatabaseRecords@4();
    VAR
      ConfigLine@1000 : Record 8622;
    BEGIN
      IF "Page ID" <> 0 THEN
        PAGE.RUN("Page ID")
      ELSE BEGIN
        ConfigLine.SETRANGE("Package Code","Package Code");
        ConfigLine.SETRANGE("Table ID","Table ID");
        IF ConfigLine.FINDFIRST AND (ConfigLine."Page ID" > 0) THEN
          PAGE.RUN(ConfigLine."Page ID")
        ELSE
          ERROR(Text010,FIELDCAPTION("Page ID"));
      END;
    END;

    [Internal]
    PROCEDURE ShowPackageFields@11();
    BEGIN
      ShowFilteredPackageFields('');
    END;

    PROCEDURE ShowFilteredPackageFields@19(FilterValue@1002 : Text);
    VAR
      ConfigPackageField@1000 : Record 8616;
      ConfigPackageFields@1001 : Page 8624;
    BEGIN
      IF InitPackageFields THEN
        COMMIT;

      IF "Dimensions as Columns" THEN
        IF NOT DimensionPackageDataExist THEN BEGIN
          IF DimensionFieldsCount > 0 THEN
            DeleteDimensionFields;
          InitDimensionFields;
          COMMIT;
        END;

      ConfigPackageField.FILTERGROUP(2);
      ConfigPackageField.SETRANGE("Package Code","Package Code");
      ConfigPackageField.SETRANGE("Table ID","Table ID");
      IF FilterValue <> '' THEN
        ConfigPackageField.SETFILTER("Field ID",FilterValue);
      ConfigPackageField.FILTERGROUP(0);
      ConfigPackageFields.SETTABLEVIEW(ConfigPackageField);
      ConfigPackageFields.RUNMODAL;
      CLEAR(ConfigPackageFields);
    END;

    [External]
    PROCEDURE ShowPackageCard@14(PackageCode@1002 : Code[20]);
    VAR
      ConfigPackage@1000 : Record 8623;
      ConfigPackageCard@1001 : Page 8614;
    BEGIN
      ConfigPackage.FILTERGROUP(2);
      ConfigPackage.SETRANGE(Code,PackageCode);
      ConfigPackage.FILTERGROUP(0);
      ConfigPackageCard.SETTABLEVIEW(ConfigPackage);
      ConfigPackageCard.RUNMODAL;
      CLEAR(ConfigPackageCard);
    END;

    [External]
    PROCEDURE SetFieldStyle@12(FieldNumber@1000 : Integer) : Text;
    BEGIN
      CASE FieldNumber OF
        FIELDNO("No. of Package Records"):
          BEGIN
            CALCFIELDS("No. of Package Records");
            IF "No. of Package Records" > 0 THEN
              EXIT('Strong');
          END;
        FIELDNO("No. of Package Errors"):
          BEGIN
            CALCFIELDS("No. of Package Errors");
            IF "No. of Package Errors" > 0 THEN
              EXIT('Unfavorable');
          END;
      END;

      EXIT('');
    END;

    [External]
    PROCEDURE ShowFilters@10();
    VAR
      ConfigPackageFilter@1001 : Record 8626;
      ConfigPackageFilters@1000 : Page 8623;
    BEGIN
      ConfigPackageFilter.FILTERGROUP(2);
      ConfigPackageFilter.SETRANGE("Package Code","Package Code");
      ConfigPackageFilter.SETRANGE("Table ID","Table ID");
      ConfigPackageFilter.SETRANGE("Processing Rule No.",0);
      ConfigPackageFilter.FILTERGROUP(0);
      ConfigPackageFilters.SETTABLEVIEW(ConfigPackageFilter);
      ConfigPackageFilters.RUNMODAL;
      CLEAR(ConfigPackageFilters);
    END;

    [External]
    PROCEDURE ShowProcessingRules@18();
    VAR
      ConfigTableProcessingRule@1001 : Record 8631;
      ConfigTableProcessingRules@1000 : Page 8640;
    BEGIN
      ConfigTableProcessingRule.FILTERGROUP(2);
      ConfigTableProcessingRule.SETRANGE("Package Code","Package Code");
      ConfigTableProcessingRule.SETRANGE("Table ID","Table ID");
      ConfigTableProcessingRule.FILTERGROUP(0);
      ConfigTableProcessingRules.SETTABLEVIEW(ConfigTableProcessingRule);
      ConfigTableProcessingRules.RUNMODAL;
      CLEAR(ConfigTableProcessingRules);
    END;

    LOCAL PROCEDURE UpdateDimensionsPackageData@13();
    VAR
      ConfigPackageField@1000 : Record 8616;
      ConfigPackageRecord@1001 : Record 8614;
      ConfigPackageData@1002 : Record 8615;
    BEGIN
      ConfigPackageRecord.SETRANGE("Package Code","Package Code");
      ConfigPackageRecord.SETRANGE("Table ID","Table ID");
      IF ConfigPackageRecord.FINDSET THEN
        REPEAT
          ConfigPackageField.SETRANGE("Package Code","Package Code");
          ConfigPackageField.SETRANGE("Table ID","Table ID");
          ConfigPackageField.SETRANGE(Dimension,TRUE);
          IF ConfigPackageField.FINDSET THEN
            REPEAT
              ConfigPackageMgt.InsertPackageData(
                ConfigPackageData,"Package Code","Table ID",ConfigPackageRecord."No.",
                ConfigPackageField."Field ID",'',ConfigPackageRecord.Invalid);
            UNTIL ConfigPackageField.NEXT = 0;
        UNTIL ConfigPackageRecord.NEXT = 0;
    END;

    [External]
    PROCEDURE SetHideValidationDialog@16(NewHideValidationDialog@1000 : Boolean);
    BEGIN
      HideValidationDialog := NewHideValidationDialog;
    END;

    [Internal]
    PROCEDURE GetNoOfDatabaseRecords@15() : Integer;
    VAR
      ConfigXMLExchange@1002 : Codeunit 8614;
      RecRef@1000 : RecordRef;
    BEGIN
      IF "Table ID" = 0 THEN
        EXIT(0);

      IF NOT ConfigXMLExchange.TableObjectExists("Table ID") THEN
        EXIT(0);

      RecRef.OPEN("Table ID",FALSE,"Company Filter (Source Table)");
      EXIT(RecRef.COUNT);
    END;

    BEGIN
    END.
  }
}

