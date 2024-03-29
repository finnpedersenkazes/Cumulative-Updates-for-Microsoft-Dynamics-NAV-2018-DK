OBJECT Codeunit 8611 Config. Package Management
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    TableNo=8614;
    OnRun=BEGIN
            CLEAR(RecordsInsertedCount);
            CLEAR(RecordsModifiedCount);
            InsertPackageRecord(Rec);
          END;

  }
  CODE
  {
    VAR
      KeyFieldValueMissingErr@1033 : TextConst '@@@=Parameter 1 - field name, 2 - table name, 3 - code value. Example: The value of the key field Customer Posting Group has not been filled in for record Customer : XXXXX.;DAN=V�rdien af n�glefeltet %1 er ikke udfyldt i recorden %2: %3.;ENU=The value of the key field %1 has not been filled in for record %2 : %3.';
      ValidatingTableRelationsMsg@1000 : TextConst 'DAN=Validerer tabelrelationer;ENU=Validating table relations';
      RecordsXofYMsg@1011 : TextConst '@@@="Sample: 5 of 1025. 1025 is total number of records, 5 is a number of the current record ";DAN=Records: %1 af %2;ENU=Records: %1 of %2';
      ApplyingPackageMsg@1001 : TextConst '@@@="%1 = The name of the package being applied.";DAN=Anvender pakke %1;ENU=Applying package %1';
      ApplyingTableMsg@1010 : TextConst '@@@="%1 = The name of the table being applied.";DAN=Udligner tabellen %1;ENU=Applying table %1';
      NoTablesAndErrorsMsg@1002 : TextConst '@@@="%1 = number of tables processed, %2 = number of errors, %3 = number of records inserted, %4 = number of records modified";DAN=%1 tabeller er behandlet.\%2 blev fundet.\%3 records er indsat.\%4 records er �ndret.;ENU=%1 tables are processed.\%2 errors found.\%3 records inserted.\%4 records modified.';
      NoTablesMsg@1003 : TextConst '@@@="%1 = The number of tables that were processed.";DAN=%1 tabeller behandles.;ENU=%1 tables are processed.';
      UpdatingDimSetsMsg@1006 : TextConst 'DAN=Opdaterer dimensionsgrupper;ENU=Updating dimension sets';
      TempConfigRecordForProcessing@1015 : TEMPORARY Record 8632;
      TempAppliedConfigPackageRecord@1016 : TEMPORARY Record 8614;
      ConfigProgressBar@1005 : Codeunit 8615;
      ConfigValidateMgt@1014 : Codeunit 8617;
      ConfigMgt@1007 : Codeunit 8616;
      TypeHelper@1021 : Codeunit 10;
      ValidationFieldID@1037 : Integer;
      RecordsInsertedCount@1017 : Integer;
      RecordsModifiedCount@1018 : Integer;
      ApplyMode@1013 : ',PrimaryKey,NonKeyFields';
      ProcessingOrderErr@1122 : TextConst '@@@="%1 = The name of the table.";DAN=Behandling af ordrenumre kunne ikke konfigureres: Der findes allerede en cyklusreference i prim�rn�glerne til tabel %1.;ENU=Cannot set up processing order numbers. A cycle reference exists in the primary keys for table %1.';
      ErrorTypeEnum@1123 : 'General,TableRelation';
      HideDialog@1012 : Boolean;
      ReferenceSameTableErr@1004 : TextConst 'DAN=Nogle af linjerne henviser til samme tabel. Du kan ikke tildele en tabel til et pakkenavn mere end �n gang.;ENU=Some lines refer to the same table. You cannot assign a table to a package more than one time.';
      BlankTxt@1008 : TextConst 'DAN=[Tom];ENU=[Blank]';
      DimValueDoesNotExistsErr@1009 : TextConst '@@@="%1 = Dimension Code, %2 = Dimension Value Code";DAN=Dimensionsv�rdien %1 %2 findes ikke.;ENU=Dimension Value %1 %2 does not exist.';
      MSGPPackageCodeTxt@1019 : TextConst 'DAN=GB.ENU.CSV;ENU=GB.ENU.CSV';
      QBPackageCodeTxt@1020 : TextConst 'DAN=DM.IIF;ENU=DM.IIF';

    [External]
    PROCEDURE InsertPackage@2(VAR ConfigPackage@1001 : Record 8623;PackageCode@1003 : Code[20];PackageName@1002 : Text[50];ExcludeConfigTables@1000 : Boolean);
    BEGIN
      ConfigPackage.Code := PackageCode;
      ConfigPackage."Package Name" := PackageName;
      ConfigPackage."Exclude Config. Tables" := ExcludeConfigTables;
      ConfigPackage.INSERT;
    END;

    [External]
    PROCEDURE InsertPackageTable@58(VAR ConfigPackageTable@1001 : Record 8613;PackageCode@1002 : Code[20];TableID@1000 : Integer);
    BEGIN
      IF NOT ConfigPackageTable.GET(PackageCode,TableID) THEN BEGIN
        ConfigPackageTable.INIT;
        ConfigPackageTable.VALIDATE("Package Code",PackageCode);
        ConfigPackageTable.VALIDATE("Table ID",TableID);
        ConfigPackageTable.INSERT(TRUE);
      END;
    END;

    [External]
    PROCEDURE InsertPackageTableWithoutValidation@84(VAR ConfigPackageTable@1001 : Record 8613;PackageCode@1002 : Code[20];TableID@1000 : Integer);
    BEGIN
      IF NOT ConfigPackageTable.GET(PackageCode,TableID) THEN BEGIN
        ConfigPackageTable.INIT;
        ConfigPackageTable."Package Code" := PackageCode;
        ConfigPackageTable."Table ID" := TableID;
        ConfigPackageTable.INSERT;
      END;
    END;

    [Internal]
    PROCEDURE InsertPackageField@19(VAR ConfigPackageField@1007 : Record 8616;PackageCode@1006 : Code[20];TableID@1000 : Integer;FieldID@1001 : Integer;FieldName@1008 : Text[30];FieldCaption@1009 : Text[250];SetInclude@1002 : Boolean;SetValidate@1003 : Boolean;SetLocalize@1005 : Boolean;SetDimension@1004 : Boolean);
    BEGIN
      IF NOT ConfigPackageField.GET(PackageCode,TableID,FieldID) THEN BEGIN
        ConfigPackageField.INIT;
        ConfigPackageField.VALIDATE("Package Code",PackageCode);
        ConfigPackageField.VALIDATE("Table ID",TableID);
        ConfigPackageField.VALIDATE(Dimension,SetDimension);
        ConfigPackageField.VALIDATE("Field ID",FieldID);
        ConfigPackageField."Field Name" := FieldName;
        ConfigPackageField."Field Caption" := FieldCaption;
        ConfigPackageField."Primary Key" := ConfigValidateMgt.IsKeyField(TableID,FieldID);
        ConfigPackageField."Include Field" := SetInclude OR ConfigPackageField."Primary Key";
        IF NOT SetDimension THEN BEGIN
          ConfigPackageField."Relation Table ID" := ConfigValidateMgt.GetRelationTableID(TableID,FieldID);
          ConfigPackageField."Validate Field" :=
            ConfigPackageField."Include Field" AND SetValidate AND NOT ValidateException(TableID,FieldID);
        END;
        ConfigPackageField."Localize Field" := SetLocalize;
        ConfigPackageField.Dimension := SetDimension;
        IF SetDimension THEN
          ConfigPackageField."Processing Order" := ConfigPackageField."Field ID";
        ConfigPackageField.INSERT;
      END;
    END;

    [External]
    PROCEDURE InsertPackageFilter@10(VAR ConfigPackageFilter@1004 : Record 8626;PackageCode@1003 : Code[20];TableID@1002 : Integer;ProcessingRuleNo@1006 : Integer;FieldID@1001 : Integer;FieldFilter@1005 : Text[250]);
    BEGIN
      IF NOT ConfigPackageFilter.GET(PackageCode,TableID,0,FieldID) THEN BEGIN
        ConfigPackageFilter.INIT;
        ConfigPackageFilter.VALIDATE("Package Code",PackageCode);
        ConfigPackageFilter.VALIDATE("Table ID",TableID);
        ConfigPackageFilter.VALIDATE("Processing Rule No.",ProcessingRuleNo);
        ConfigPackageFilter.VALIDATE("Field ID",FieldID);
        ConfigPackageFilter.VALIDATE("Field Filter",FieldFilter);
        ConfigPackageFilter.INSERT;
      END ELSE
        IF ConfigPackageFilter."Field Filter" <> FieldFilter THEN BEGIN
          ConfigPackageFilter."Field Filter" := FieldFilter;
          ConfigPackageFilter.MODIFY;
        END;
    END;

    [Internal]
    PROCEDURE InsertPackageRecord@3(ConfigPackageRecord@1001 : Record 8614);
    VAR
      RecRef@1000 : RecordRef;
      DelayedInsert@1002 : Boolean;
    BEGIN
      IF (ConfigPackageRecord."Package Code" = '') OR (ConfigPackageRecord."Table ID" = 0) THEN
        EXIT;

      IF ConfigMgt.IsSystemTable(ConfigPackageRecord."Table ID") THEN
        EXIT;

      RecRef.OPEN(ConfigPackageRecord."Table ID");
      IF ApplyMode <> ApplyMode::NonKeyFields THEN
        RecRef.INIT;

      InsertPrimaryKeyFields(RecRef,ConfigPackageRecord,TRUE,DelayedInsert);

      IF ApplyMode = ApplyMode::PrimaryKey THEN
        UpdateKeyInfoForConfigPackageRecord(RecRef,ConfigPackageRecord);

      IF (ApplyMode = ApplyMode::NonKeyFields) OR DelayedInsert THEN
        ModifyRecordDataFields(RecRef,ConfigPackageRecord,TRUE,DelayedInsert);
    END;

    [External]
    PROCEDURE InsertPackageData@31(VAR ConfigPackageData@1000 : Record 8615;PackageCode@1001 : Code[20];TableID@1002 : Integer;No@1003 : Integer;FieldID@1004 : Integer;Value@1005 : Text[250];Invalid@1006 : Boolean);
    BEGIN
      IF NOT ConfigPackageData.GET(PackageCode,TableID,No,FieldID) THEN BEGIN
        ConfigPackageData.INIT;
        ConfigPackageData."Package Code" := PackageCode;
        ConfigPackageData."Table ID" := TableID;
        ConfigPackageData."No." := No;
        ConfigPackageData."Field ID" := FieldID;
        ConfigPackageData.Value := Value;
        ConfigPackageData.Invalid := Invalid;
        ConfigPackageData.INSERT;
      END ELSE
        IF ConfigPackageData.Value <> Value THEN BEGIN
          ConfigPackageData.Value := Value;
          ConfigPackageData.MODIFY;
        END;
    END;

    [External]
    PROCEDURE InsertProcessingRule@71(VAR ConfigTableProcessingRule@1000 : Record 8631;ConfigPackageTable@1001 : Record 8613;RuleNo@1002 : Integer;NewAction@1003 : Option);
    BEGIN
      WITH ConfigTableProcessingRule DO BEGIN
        VALIDATE("Package Code",ConfigPackageTable."Package Code");
        VALIDATE("Table ID",ConfigPackageTable."Table ID");
        VALIDATE("Rule No.",RuleNo);
        VALIDATE(Action,NewAction);
        INSERT(TRUE);
      END;
    END;

    [External]
    PROCEDURE InsertProcessingRuleCustom@66(VAR ConfigTableProcessingRule@1000 : Record 8631;ConfigPackageTable@1001 : Record 8613;RuleNo@1002 : Integer;CodeunitID@1003 : Integer);
    BEGIN
      WITH ConfigTableProcessingRule DO BEGIN
        VALIDATE("Package Code",ConfigPackageTable."Package Code");
        VALIDATE("Table ID",ConfigPackageTable."Table ID");
        VALIDATE("Rule No.",RuleNo);
        VALIDATE(Action,Action::Custom);
        VALIDATE("Custom Processing Codeunit ID",CodeunitID);
        INSERT(TRUE);
      END;
    END;

    [External]
    PROCEDURE SetSkipTableTriggers@55(VAR ConfigPackageTable@1001 : Record 8613;PackageCode@1002 : Code[20];TableID@1000 : Integer;Skip@1003 : Boolean);
    BEGIN
      IF ConfigPackageTable.GET(PackageCode,TableID) THEN BEGIN
        ConfigPackageTable.VALIDATE("Skip Table Triggers",Skip);
        ConfigPackageTable.MODIFY(TRUE);
      END;
    END;

    [External]
    PROCEDURE GetNumberOfRecordsInserted@80() : Integer;
    BEGIN
      EXIT(RecordsInsertedCount);
    END;

    [External]
    PROCEDURE GetNumberOfRecordsModified@81() : Integer;
    BEGIN
      EXIT(RecordsModifiedCount);
    END;

    LOCAL PROCEDURE InsertPrimaryKeyFields@40(VAR RecRef@1000 : RecordRef;ConfigPackageRecord@1002 : Record 8614;DoInsert@1008 : Boolean;VAR DelayedInsert@1006 : Boolean);
    VAR
      ConfigPackageData@1001 : Record 8615;
      ConfigPackageField@1007 : Record 8616;
      TempConfigPackageField@1010 : TEMPORARY Record 8616;
      ConfigPackageError@1005 : Record 8617;
      RecRef1@1004 : RecordRef;
      FieldRef@1003 : FieldRef;
    BEGIN
      ConfigPackageData.SETRANGE("Package Code",ConfigPackageRecord."Package Code");
      ConfigPackageData.SETRANGE("Table ID",ConfigPackageRecord."Table ID");
      ConfigPackageData.SETRANGE("No.",ConfigPackageRecord."No.");

      GetKeyFieldsOrder(RecRef,ConfigPackageRecord."Package Code",TempConfigPackageField);
      GetFieldsMarkedAsPrimaryKey(ConfigPackageRecord."Package Code",RecRef.NUMBER,TempConfigPackageField);

      TempConfigPackageField.RESET;
      TempConfigPackageField.SETCURRENTKEY("Package Code","Table ID","Processing Order");

      TempConfigPackageField.FINDSET;
      REPEAT
        FieldRef := RecRef.FIELD(TempConfigPackageField."Field ID");
        ConfigPackageData.SETRANGE("Field ID",TempConfigPackageField."Field ID");
        IF ConfigPackageData.FINDFIRST THEN BEGIN
          ConfigPackageField.GET(ConfigPackageData."Package Code",ConfigPackageData."Table ID",ConfigPackageData."Field ID");
          UpdateValueUsingMapping(ConfigPackageData,ConfigPackageField,ConfigPackageRecord."Package Code");
          ValidationFieldID := FieldRef.NUMBER;
          ConfigValidateMgt.EvaluateTextToFieldRef(
            ConfigPackageData.Value,FieldRef,ConfigPackageField."Validate Field" AND (ApplyMode = ApplyMode::PrimaryKey));
        END ELSE
          ERROR(KeyFieldValueMissingErr,FieldRef.NAME,RecRef.NAME,ConfigPackageData."No.");
      UNTIL TempConfigPackageField.NEXT = 0;

      RecRef1 := RecRef.DUPLICATE;

      IF RecRef1.FIND THEN BEGIN
        RecRef := RecRef1;
        EXIT
      END;
      IF ((ConfigPackageRecord."Package Code" = QBPackageCodeTxt) OR (ConfigPackageRecord."Package Code" = MSGPPackageCodeTxt)) AND
         (ConfigPackageRecord."Table ID" = 15)
      THEN
        IF ConfigPackageError.GET(
             ConfigPackageRecord."Package Code",ConfigPackageRecord."Table ID",ConfigPackageRecord."No.",1)
        THEN
          EXIT;

      IF DoInsert THEN BEGIN
        DelayedInsert := InsertRecord(RecRef,ConfigPackageRecord);
        RecordsInsertedCount += 1;
      END ELSE
        DelayedInsert := FALSE;
    END;

    LOCAL PROCEDURE UpdateKeyInfoForConfigPackageRecord@128(RecRef@1001 : RecordRef;ConfigPackageRecord@1000 : Record 8614);
    VAR
      ConfigPackageData@1005 : Record 8615;
      KeyRef@1004 : KeyRef;
      FieldRef@1003 : FieldRef;
      KeyFieldCount@1002 : Integer;
    BEGIN
      KeyRef := RecRef.KEYINDEX(1);
      FOR KeyFieldCount := 1 TO KeyRef.FIELDCOUNT DO BEGIN
        FieldRef := KeyRef.FIELDINDEX(KeyFieldCount);

        ConfigPackageData.GET(
          ConfigPackageRecord."Package Code",ConfigPackageRecord."Table ID",ConfigPackageRecord."No.",FieldRef.NUMBER);
        ConfigPackageData.Value := FieldRef.VALUE;
        ConfigPackageData.MODIFY;
      END;
    END;

    [External]
    PROCEDURE InitPackageRecord@42(VAR ConfigPackageRecord@1001 : Record 8614;PackageCode@1002 : Code[20];TableID@1000 : Integer);
    VAR
      NextNo@1003 : Integer;
    BEGIN
      ConfigPackageRecord.RESET;
      ConfigPackageRecord.SETRANGE("Package Code",PackageCode);
      ConfigPackageRecord.SETRANGE("Table ID",TableID);
      IF ConfigPackageRecord.FINDLAST THEN
        NextNo := ConfigPackageRecord."No." + 1
      ELSE
        NextNo := 1;

      ConfigPackageRecord.INIT;
      ConfigPackageRecord."Package Code" := PackageCode;
      ConfigPackageRecord."Table ID" := TableID;
      ConfigPackageRecord."No." := NextNo;
      ConfigPackageRecord.INSERT;
    END;

    LOCAL PROCEDURE InsertRecord@86(VAR RecRef@1000 : RecordRef;ConfigPackageRecord@1001 : Record 8614) : Boolean;
    VAR
      ConfigPackageTable@1003 : Record 8613;
      ConfigInsertWithValidation@1004 : Codeunit 8622;
    BEGIN
      ConfigPackageTable.GET(ConfigPackageRecord."Package Code",ConfigPackageRecord."Table ID");
      IF ConfigPackageTable."Skip Table Triggers" THEN
        RecRef.INSERT
      ELSE BEGIN
        COMMIT;
        ConfigInsertWithValidation.SetInsertParameters(RecRef);
        IF NOT ConfigInsertWithValidation.RUN THEN BEGIN
          CLEARLASTERROR;
          EXIT(TRUE);
        END;
      END;
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE ModifyRecordDataFields@39(VAR RecRef@1004 : RecordRef;ConfigPackageRecord@1005 : Record 8614;DoModify@1013 : Boolean;DelayedInsert@1009 : Boolean);
    VAR
      ConfigPackageData@1002 : Record 8615;
      ConfigPackageField@1000 : Record 8616;
      ConfigQuestion@1003 : Record 8612;
      Field@1007 : Record 2000000041;
      ConfigPackageTable@1012 : Record 8613;
      ConfigPackageError@1008 : Record 8617;
      ConfigQuestionnaireMgt@1006 : Codeunit 8610;
      FieldRef@1001 : FieldRef;
      IsTemplate@1010 : Boolean;
    BEGIN
      ConfigPackageField.RESET;
      ConfigPackageField.SETCURRENTKEY("Package Code","Table ID","Processing Order");
      ConfigPackageField.SETRANGE("Package Code",ConfigPackageRecord."Package Code");
      ConfigPackageField.SETRANGE("Table ID",ConfigPackageRecord."Table ID");
      ConfigPackageField.SETRANGE("Include Field",TRUE);
      ConfigPackageField.SETRANGE(Dimension,FALSE);

      ConfigPackageTable.GET(ConfigPackageRecord."Package Code",ConfigPackageRecord."Table ID");
      IF DoModify OR DelayedInsert THEN
        ApplyTemplate(ConfigPackageTable,RecRef);

      IF ConfigPackageField.FINDSET THEN
        REPEAT
          ValidationFieldID := ConfigPackageField."Field ID";
          IF ((ConfigPackageRecord."Package Code" = QBPackageCodeTxt) OR (ConfigPackageRecord."Package Code" = MSGPPackageCodeTxt)) AND
             ((ConfigPackageRecord."Table ID" = 15) OR (ConfigPackageRecord."Table ID" = 18) OR
              (ConfigPackageRecord."Table ID" = 23) OR (ConfigPackageRecord."Table ID" = 27))
          THEN
            IF ConfigPackageError.GET(
                 ConfigPackageRecord."Package Code",ConfigPackageRecord."Table ID",ConfigPackageRecord."No.",1)
            THEN
              EXIT;

          IF ConfigPackageData.GET(
               ConfigPackageRecord."Package Code",ConfigPackageRecord."Table ID",ConfigPackageRecord."No.",
               ConfigPackageField."Field ID")
          THEN
            IF NOT ConfigPackageField."Primary Key" THEN BEGIN
              IsTemplate := IsTemplateField(ConfigPackageTable."Data Template",ConfigPackageField."Field ID");
              IF NOT IsTemplate OR (IsTemplate AND (ConfigPackageData.Value <> '')) THEN BEGIN
                FieldRef := RecRef.FIELD(ConfigPackageField."Field ID");
                UpdateValueUsingMapping(ConfigPackageData,ConfigPackageField,ConfigPackageRecord."Package Code");

                CASE TRUE OF
                  IsBLOBField(ConfigPackageData."Table ID",ConfigPackageData."Field ID"):
                    EvaluateBLOBToFieldRef(ConfigPackageData,FieldRef);
                  IsMediaSetField(ConfigPackageData."Table ID",ConfigPackageData."Field ID"):
                    ImportMediaSetFiles(ConfigPackageData,FieldRef,DoModify);
                  IsMediaField(ConfigPackageData."Table ID",ConfigPackageData."Field ID"):
                    ImportMediaFiles(ConfigPackageData,FieldRef,DoModify);
                  ELSE
                    ConfigValidateMgt.EvaluateTextToFieldRef(
                      ConfigPackageData.Value,FieldRef,
                      ConfigPackageField."Validate Field" AND ((ApplyMode = ApplyMode::NonKeyFields) OR DelayedInsert));
                END;
              END;
            END;
        UNTIL ConfigPackageField.NEXT = 0;

      IF DoModify THEN BEGIN
        IF DelayedInsert THEN
          RecRef.INSERT(TRUE)
        ELSE BEGIN
          RecRef.MODIFY(NOT ConfigPackageTable."Skip Table Triggers");
          RecordsModifiedCount += 1;
        END;

        IF RecRef.NUMBER <> DATABASE::"Config. Question" THEN
          EXIT;

        RecRef.SETTABLE(ConfigQuestion);

        SetFieldFilter(Field,ConfigQuestion."Table ID",ConfigQuestion."Field ID");
        IF Field.FINDFIRST THEN
          ConfigQuestionnaireMgt.ModifyConfigQuestionAnswer(ConfigQuestion,Field);
      END;
    END;

    LOCAL PROCEDURE ApplyTemplate@68(ConfigPackageTable@1002 : Record 8613;VAR RecRef@1000 : RecordRef);
    VAR
      ConfigTemplateHeader@1003 : Record 8618;
      ConfigTemplateMgt@1001 : Codeunit 8612;
    BEGIN
      IF ConfigTemplateHeader.GET(ConfigPackageTable."Data Template") THEN BEGIN
        ConfigTemplateMgt.UpdateRecord(ConfigTemplateHeader,RecRef);
        InsertDimensionsFromTemplates(ConfigPackageTable."Table ID",ConfigTemplateHeader,RecRef);
      END;
    END;

    LOCAL PROCEDURE InsertDimensionsFromTemplates@89(TableID@1005 : Integer;ConfigTemplateHeader@1001 : Record 8618;VAR RecRef@1000 : RecordRef);
    VAR
      DimensionsTemplate@1004 : Record 1302;
      KeyRef@1003 : KeyRef;
      FieldRef@1002 : FieldRef;
    BEGIN
      KeyRef := RecRef.KEYINDEX(1);
      IF KeyRef.FIELDCOUNT = 1 THEN BEGIN
        FieldRef := KeyRef.FIELDINDEX(1);
        IF FORMAT(FieldRef.VALUE) <> '' THEN
          DimensionsTemplate.InsertDimensionsFromTemplates(
            ConfigTemplateHeader,FORMAT(FieldRef.VALUE),TableID);
      END;
    END;

    LOCAL PROCEDURE IsTemplateField@88(TemplateCode@1005 : Code[20];FieldNo@1003 : Integer) : Boolean;
    VAR
      ConfigTemplateHeader@1002 : Record 8618;
      ConfigTemplateLine@1001 : Record 8619;
    BEGIN
      IF TemplateCode = '' THEN
        EXIT(FALSE);

      IF NOT ConfigTemplateHeader.GET(TemplateCode) THEN
        EXIT(FALSE);

      ConfigTemplateLine.SETRANGE("Data Template Code",ConfigTemplateHeader.Code);
      ConfigTemplateLine.SETRANGE("Field ID",FieldNo);
      ConfigTemplateLine.SETRANGE(Type,ConfigTemplateLine.Type::Field);
      IF NOT ConfigTemplateLine.ISEMPTY THEN
        EXIT(TRUE);

      ConfigTemplateLine.SETRANGE("Field ID");
      ConfigTemplateLine.SETRANGE(Type,ConfigTemplateLine.Type::Template);
      IF ConfigTemplateLine.FINDSET THEN
        REPEAT
          IF IsTemplateField(ConfigTemplateLine."Template Code",FieldNo) THEN
            EXIT(TRUE);
        UNTIL ConfigTemplateLine.NEXT = 0;
      EXIT(FALSE);
    END;

    [Internal]
    PROCEDURE ValidatePackageRelations@11(VAR ConfigPackageTable@1000 : Record 8613;VAR TempConfigPackageTable@1001 : TEMPORARY Record 8613;SetupProcessingOrderForTables@1003 : Boolean);
    VAR
      TableCount@1002 : Integer;
    BEGIN
      IF SetupProcessingOrderForTables THEN
        SetupProcessingOrder(ConfigPackageTable);

      WITH ConfigPackageTable DO BEGIN
        TableCount := COUNT;
        IF NOT HideDialog THEN
          ConfigProgressBar.Init(TableCount,1,ValidatingTableRelationsMsg);

        MODIFYALL(Validated,FALSE);

        SETCURRENTKEY("Package Processing Order","Processing Order");
        IF FINDSET THEN
          REPEAT
            CALCFIELDS("Table Name");
            IF NOT HideDialog THEN
              ConfigProgressBar.Update("Table Name");
            ValidateTableRelation("Package Code","Table ID",TempConfigPackageTable);

            TempConfigPackageTable.INIT;
            TempConfigPackageTable."Package Code" := "Package Code";
            TempConfigPackageTable."Table ID" := "Table ID";
            TempConfigPackageTable.INSERT;
            Validated := TRUE;
            MODIFY;
          UNTIL NEXT = 0;
        IF NOT HideDialog THEN
          ConfigProgressBar.Close;
      END;

      IF NOT HideDialog THEN
        MESSAGE(NoTablesMsg,TableCount);
    END;

    LOCAL PROCEDURE ValidateTableRelation@46(PackageCode@1003 : Code[20];TableId@1000 : Integer;VAR ValidatedConfigPackageTable@1002 : Record 8613);
    VAR
      ConfigPackageField@1001 : Record 8616;
    BEGIN
      ConfigPackageField.SETCURRENTKEY("Package Code","Table ID","Processing Order");
      ConfigPackageField.SETRANGE("Package Code",PackageCode);
      ConfigPackageField.SETRANGE("Table ID",TableId);
      ConfigPackageField.SETRANGE("Validate Field",TRUE);
      IF ConfigPackageField.FINDSET THEN
        REPEAT
          ValidateFieldRelation(ConfigPackageField,ValidatedConfigPackageTable);
        UNTIL ConfigPackageField.NEXT = 0;
    END;

    [Internal]
    PROCEDURE ValidateFieldRelation@35(ConfigPackageField@1007 : Record 8616;VAR ValidatedConfigPackageTable@1006 : Record 8613) NoValidateErrors : Boolean;
    VAR
      ConfigPackageData@1005 : Record 8615;
    BEGIN
      NoValidateErrors := TRUE;

      ConfigPackageData.SETRANGE("Package Code",ConfigPackageField."Package Code");
      ConfigPackageData.SETRANGE("Table ID",ConfigPackageField."Table ID");
      ConfigPackageData.SETRANGE("Field ID",ConfigPackageField."Field ID");
      IF ConfigPackageData.FINDSET THEN
        REPEAT
          NoValidateErrors :=
            NoValidateErrors AND
            ValidatePackageDataRelation(ConfigPackageData,ValidatedConfigPackageTable,ConfigPackageField,TRUE);
        UNTIL ConfigPackageData.NEXT = 0;
    END;

    [Internal]
    PROCEDURE ValidateSinglePackageDataRelation@38(VAR ConfigPackageData@1002 : Record 8615) : Boolean;
    VAR
      TempConfigPackageTable@1000 : TEMPORARY Record 8613;
      ConfigPackageField@1001 : Record 8616;
    BEGIN
      ConfigPackageField.GET(ConfigPackageData."Package Code",ConfigPackageData."Table ID",ConfigPackageData."Field ID");
      EXIT(ValidatePackageDataRelation(ConfigPackageData,TempConfigPackageTable,ConfigPackageField,FALSE));
    END;

    LOCAL PROCEDURE ValidatePackageDataRelation@36(VAR ConfigPackageData@1000 : Record 8615;VAR ValidatedConfigPackageTable@1002 : Record 8613;VAR ConfigPackageField@1003 : Record 8616;GenerateFieldError@1001 : Boolean) : Boolean;
    VAR
      ErrorText@1006 : Text[250];
      RelationTableNo@1005 : Integer;
      RelationFieldNo@1004 : Integer;
      DataInPackageData@1007 : Boolean;
    BEGIN
      IF FORMAT(ConfigPackageData.Value) <> '' THEN BEGIN
        DataInPackageData := FALSE;
        IF GetRelationInfo(ConfigPackageField,RelationTableNo,RelationFieldNo) THEN
          DataInPackageData :=
            ValidateFieldRelationAgainstPackageData(
              ConfigPackageData,ValidatedConfigPackageTable,RelationTableNo,RelationFieldNo);

        IF NOT DataInPackageData THEN BEGIN
          ErrorText := ValidateFieldRelationAgainstCompanyData(ConfigPackageData);
          IF ErrorText <> '' THEN BEGIN
            IF GenerateFieldError THEN
              FieldError(ConfigPackageData,ErrorText,ErrorTypeEnum::TableRelation);
            EXIT(FALSE);
          END;
        END;
      END;

      IF PackageErrorsExists(ConfigPackageData,ErrorTypeEnum::TableRelation) THEN
        CleanFieldError(ConfigPackageData);
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE ValidateException@20(TableID@1000 : Integer;FieldID@1001 : Integer) : Boolean;
    BEGIN
      CASE TableID OF
        // Dimension Value ID: ERROR message
        DATABASE::"Dimension Value":
          EXIT(FieldID = 12);
        // Default Dimension: multi-relations
        DATABASE::"Default Dimension":
          EXIT(FieldID = 2);
        // VAT %: CheckVATIdentifier
        DATABASE::"VAT Posting Setup":
          EXIT(FieldID = 4);
        // Table ID - OnValidate
        DATABASE::"Config. Template Header":
          EXIT(FieldID = 3);
        // Field ID relation
        DATABASE::"Config. Template Line":
          EXIT(FieldID IN [4,8,12]);
        // Dimensions as Columns
        DATABASE::"Config. Line":
          EXIT(FieldID = 12);
        // Customer : Contact OnValidate
        DATABASE::Customer:
          EXIT(FieldID = 8);
        // Vendor : Contact OnValidate
        DATABASE::Vendor:
          EXIT(FieldID = 8);
        // Item : Base Unit of Measure OnValidate
        DATABASE::Item:
          EXIT(FieldID = 8);
        // "No." to pass not manual No. Series
        DATABASE::"Sales Header",DATABASE::"Purchase Header":
          EXIT(FieldID = 3);
        // "Document No." conditional relation
        DATABASE::"Sales Line",DATABASE::"Purchase Line":
          EXIT(FieldID = 3);
      END;
      EXIT(FALSE);
    END;

    [External]
    PROCEDURE IsDimSetIDField@44(TableId@1001 : Integer;FieldId@1002 : Integer) : Boolean;
    VAR
      DimensionValue@1000 : Record 349;
    BEGIN
      EXIT((TableId = DATABASE::"Dimension Value") AND (DimensionValue.FIELDNO("Dimension Value ID") = FieldId));
    END;

    LOCAL PROCEDURE GetRelationInfo@43(ConfigPackageField@1004 : Record 8616;VAR RelationTableNo@1000 : Integer;VAR RelationFieldNo@1001 : Integer) : Boolean;
    BEGIN
      EXIT(
        ConfigValidateMgt.GetRelationInfoByIDs(
          ConfigPackageField."Table ID",ConfigPackageField."Field ID",RelationTableNo,RelationFieldNo));
    END;

    LOCAL PROCEDURE ValidateFieldRelationAgainstCompanyData@25(ConfigPackageData@1006 : Record 8615) : Text[250];
    VAR
      TempConfigPackageField@1003 : TEMPORARY Record 8616;
      ConfigPackageRecord@1002 : Record 8614;
      RecRef@1001 : RecordRef;
      FieldRef@1000 : FieldRef;
      DelayedInsert@1004 : Boolean;
    BEGIN
      RecRef.OPEN(ConfigPackageData."Table ID");
      ConfigPackageRecord.GET(ConfigPackageData."Package Code",ConfigPackageData."Table ID",ConfigPackageData."No.");
      InsertPrimaryKeyFields(RecRef,ConfigPackageRecord,FALSE,DelayedInsert);
      ModifyRecordDataFields(RecRef,ConfigPackageRecord,FALSE,FALSE);

      FieldRef := RecRef.FIELD(ConfigPackageData."Field ID");
      ConfigValidateMgt.EvaluateValue(FieldRef,ConfigPackageData.Value,FALSE);

      GetFieldsOrder(RecRef,ConfigPackageRecord."Package Code",TempConfigPackageField);
      EXIT(ConfigValidateMgt.ValidateFieldRefRelationAgainstCompanyData(FieldRef,TempConfigPackageField));
    END;

    LOCAL PROCEDURE ValidateFieldRelationAgainstPackageData@29(ConfigPackageData@1002 : Record 8615;VAR ValidatedConfigPackageTable@1001 : Record 8613;RelationTableNo@1005 : Integer;RelationFieldNo@1004 : Integer) : Boolean;
    VAR
      RelatedConfigPackageData@1006 : Record 8615;
      ConfigPackageTable@1000 : Record 8613;
      TablePriority@1003 : Integer;
    BEGIN
      IF NOT ConfigPackageTable.GET(ConfigPackageData."Package Code",RelationTableNo) THEN
        EXIT(FALSE);

      TablePriority := ConfigPackageTable."Processing Order";
      IF ConfigValidateMgt.IsRelationInKeyFields(ConfigPackageData."Table ID",ConfigPackageData."Field ID") THEN BEGIN
        ConfigPackageTable.GET(ConfigPackageData."Package Code",ConfigPackageData."Table ID");

        IF ConfigPackageTable."Processing Order" < TablePriority THEN
          EXIT(FALSE);

        // That current order will be for apply data
        ValidatedConfigPackageTable.RESET;
        ValidatedConfigPackageTable.SETRANGE("Table ID",RelationTableNo);
        IF ValidatedConfigPackageTable.ISEMPTY THEN
          EXIT(FALSE);
      END;

      RelatedConfigPackageData.SETRANGE("Package Code",ConfigPackageData."Package Code");
      RelatedConfigPackageData.SETRANGE("Table ID",RelationTableNo);
      RelatedConfigPackageData.SETRANGE("Field ID",RelationFieldNo);
      RelatedConfigPackageData.SETRANGE(Value,ConfigPackageData.Value);
      EXIT(NOT RelatedConfigPackageData.ISEMPTY);
    END;

    [Internal]
    PROCEDURE RecordError@8(VAR ConfigPackageRecord@1000 : Record 8614;ValidationFieldID@1003 : Integer;ErrorText@1001 : Text[250]);
    VAR
      ConfigPackageError@1002 : Record 8617;
      ConfigPackageData@1004 : Record 8615;
      RecordID@1005 : RecordID;
    BEGIN
      IF ErrorText = '' THEN
        EXIT;

      ConfigPackageError.INIT;
      ConfigPackageError."Package Code" := ConfigPackageRecord."Package Code";
      ConfigPackageError."Table ID" := ConfigPackageRecord."Table ID";
      ConfigPackageError."Record No." := ConfigPackageRecord."No.";
      ConfigPackageError."Field ID" := ValidationFieldID;
      ConfigPackageError."Error Text" := ErrorText;

      ConfigPackageData.SETRANGE("Package Code",ConfigPackageRecord."Package Code");
      ConfigPackageData.SETRANGE("Table ID",ConfigPackageRecord."Table ID");
      ConfigPackageData.SETRANGE("No.",ConfigPackageRecord."No.");
      IF EVALUATE(RecordID,GetRecordIDOfRecordError(ConfigPackageData)) THEN
        ConfigPackageError."Record ID" := RecordID;
      IF NOT ConfigPackageError.INSERT THEN
        ConfigPackageError.MODIFY;
      ConfigPackageRecord.Invalid := TRUE;
      ConfigPackageRecord.MODIFY;
    END;

    [Internal]
    PROCEDURE FieldError@9(VAR ConfigPackageData@1000 : Record 8615;ErrorText@1001 : Text[250];ErrorType@1004 : ',TableRelation');
    VAR
      ConfigPackageRecord@1003 : Record 8614;
      ConfigPackageError@1002 : Record 8617;
      ConfigPackageData2@1006 : Record 8615;
      RecordID@1005 : RecordID;
    BEGIN
      IF ErrorText = '' THEN
        EXIT;

      ConfigPackageError.INIT;
      ConfigPackageError."Package Code" := ConfigPackageData."Package Code";
      ConfigPackageError."Table ID" := ConfigPackageData."Table ID";
      ConfigPackageError."Record No." := ConfigPackageData."No.";
      ConfigPackageError."Field ID" := ConfigPackageData."Field ID";
      ConfigPackageError."Error Text" := ErrorText;
      ConfigPackageError."Error Type" := ErrorType;

      ConfigPackageData2.SETRANGE("Package Code",ConfigPackageData."Package Code");
      ConfigPackageData2.SETRANGE("Table ID",ConfigPackageData."Table ID");
      ConfigPackageData2.SETRANGE("No.",ConfigPackageData."No.");
      IF EVALUATE(RecordID,GetRecordIDOfRecordError(ConfigPackageData2)) THEN
        ConfigPackageError."Record ID" := RecordID;
      IF NOT ConfigPackageError.INSERT THEN
        ConfigPackageError.MODIFY;

      ConfigPackageData.Invalid := TRUE;
      ConfigPackageData.MODIFY;

      ConfigPackageRecord.GET(ConfigPackageData."Package Code",ConfigPackageData."Table ID",ConfigPackageData."No.");
      ConfigPackageRecord.Invalid := TRUE;
      ConfigPackageRecord.MODIFY;
    END;

    [External]
    PROCEDURE CleanRecordError@15(VAR ConfigPackageRecord@1000 : Record 8614);
    VAR
      ConfigPackageError@1001 : Record 8617;
    BEGIN
      ConfigPackageError.SETRANGE("Package Code",ConfigPackageRecord."Package Code");
      ConfigPackageError.SETRANGE("Table ID",ConfigPackageRecord."Table ID");
      ConfigPackageError.SETRANGE("Record No.",ConfigPackageRecord."No.");
      ConfigPackageError.DELETEALL;
    END;

    [External]
    PROCEDURE CleanFieldError@18(VAR ConfigPackageData@1000 : Record 8615);
    VAR
      ConfigPackageError@1001 : Record 8617;
      ConfigPackageRecord@1002 : Record 8614;
    BEGIN
      ConfigPackageError.SETRANGE("Package Code",ConfigPackageData."Package Code");
      ConfigPackageError.SETRANGE("Table ID",ConfigPackageData."Table ID");
      ConfigPackageError.SETRANGE("Record No.",ConfigPackageData."No.");
      ConfigPackageError.SETRANGE("Field ID",ConfigPackageData."Field ID");
      ConfigPackageError.DELETEALL;

      ConfigPackageData.Invalid := FALSE;
      ConfigPackageData.MODIFY;

      ConfigPackageRecord.GET(ConfigPackageData."Package Code",ConfigPackageData."Table ID",ConfigPackageData."No.");

      ConfigPackageError.RESET;
      ConfigPackageError.SETRANGE("Package Code",ConfigPackageData."Package Code");
      ConfigPackageError.SETRANGE("Table ID",ConfigPackageData."Table ID");
      ConfigPackageError.SETRANGE("Record No.",ConfigPackageData."No.");
      IF ConfigPackageError.FINDFIRST THEN
        ConfigPackageRecord.Invalid := TRUE
      ELSE
        ConfigPackageRecord.Invalid := FALSE;

      ConfigPackageRecord.MODIFY;
    END;

    [External]
    PROCEDURE CleanPackageErrors@45(PackageCode@1000 : Code[20];TableFilter@1002 : Text);
    VAR
      ConfigPackageError@1001 : Record 8617;
    BEGIN
      ConfigPackageError.SETRANGE("Package Code",PackageCode);
      IF TableFilter <> '' THEN
        ConfigPackageError.SETFILTER("Table ID",TableFilter);

      ConfigPackageError.DELETEALL;
    END;

    LOCAL PROCEDURE PackageErrorsExists@59(ConfigPackageData@1000 : Record 8615;ErrorType@1001 : 'General,TableRelation') : Boolean;
    VAR
      ConfigPackageError@1002 : Record 8617;
    BEGIN
      IF NOT ConfigPackageError.GET(
           ConfigPackageData."Package Code",ConfigPackageData."Table ID",ConfigPackageData."No.",ConfigPackageData."Field ID")
      THEN
        EXIT(FALSE);

      IF ConfigPackageError."Error Type" = ErrorType THEN
        EXIT(TRUE);

      EXIT(FALSE)
    END;

    [External]
    PROCEDURE GetValidationFieldID@33() : Integer;
    BEGIN
      EXIT(ValidationFieldID);
    END;

    [Internal]
    PROCEDURE ApplyConfigLines@17(VAR ConfigLine@1003 : Record 8622);
    VAR
      ConfigPackage@1000 : Record 8623;
      ConfigPackageTable@1002 : Record 8613;
      ConfigMgt@1004 : Codeunit 8616;
      Filter@1001 : Text;
    BEGIN
      ConfigLine.FINDFIRST;
      ConfigPackage.GET(ConfigLine."Package Code");
      ConfigPackageTable.SETRANGE("Package Code",ConfigLine."Package Code");
      Filter := ConfigMgt.MakeTableFilter(ConfigLine,FALSE);

      IF Filter = '' THEN
        EXIT;

      ConfigPackageTable.SETFILTER("Table ID",Filter);
      ApplyPackage(ConfigPackage,ConfigPackageTable,TRUE);
    END;

    [Internal]
    PROCEDURE ApplyPackage@12(ConfigPackage@1004 : Record 8623;VAR ConfigPackageTable@1000 : Record 8613;SetupProcessingOrderForTables@1003 : Boolean) ErrorCount : Integer;
    VAR
      DimSetEntry@1006 : Record 480;
      ConfigManagement@1002 : Codeunit 8616;
      IntegrationManagement@1005 : Codeunit 5150;
      TableCount@1001 : Integer;
      DimSetIDUsed@1007 : Boolean;
    BEGIN
      BINDSUBSCRIPTION(ConfigManagement);
      IntegrationManagement.ResetIntegrationActivated;

      ConfigPackage.CALCFIELDS("No. of Records","No. of Errors");
      TableCount := ConfigPackageTable.COUNT;
      IF (ConfigPackage.Code <> MSGPPackageCodeTxt) AND (ConfigPackage.Code <> QBPackageCodeTxt) THEN
        // Hold the error count for duplicate records.
        ErrorCount := ConfigPackage."No. of Errors";
      IF (TableCount = 0) OR (ConfigPackage."No. of Records" = 0) THEN
        EXIT;
      IF (ConfigPackage.Code <> MSGPPackageCodeTxt) AND (ConfigPackage.Code <> QBPackageCodeTxt) THEN
        // Skip this code to hold the error count for duplicate records.
        CleanPackageErrors(ConfigPackage.Code,ConfigPackageTable.GETFILTER("Table ID"));

      IF SetupProcessingOrderForTables THEN BEGIN
        SetupProcessingOrder(ConfigPackageTable);
        COMMIT;
      END;

      DimSetIDUsed := FALSE;
      IF ConfigPackageTable.FINDSET THEN
        REPEAT
          DimSetIDUsed := ConfigMgt.IsDimSetIDTable(ConfigPackageTable."Table ID");
        UNTIL (ConfigPackageTable.NEXT = 0) OR DimSetIDUsed;

      IF DimSetIDUsed AND NOT DimSetEntry.ISEMPTY THEN
        UpdateDimSetIDValues(ConfigPackage);
      IF (ConfigPackage.Code <> MSGPPackageCodeTxt) AND (ConfigPackage.Code <> QBPackageCodeTxt) THEN
        DeleteAppliedPackageRecords(TempAppliedConfigPackageRecord); // Do not delete PackageRecords till transactions are created

      COMMIT;

      TempAppliedConfigPackageRecord.DELETEALL;
      TempConfigRecordForProcessing.DELETEALL;
      CLEAR(RecordsInsertedCount);
      CLEAR(RecordsModifiedCount);

      // Handle independent tables
      ConfigPackageTable.SETRANGE("Parent Table ID",0);
      ApplyPackageTables(ConfigPackage,ConfigPackageTable,ApplyMode::PrimaryKey);
      ApplyPackageTables(ConfigPackage,ConfigPackageTable,ApplyMode::NonKeyFields);

      // Handle children tables
      ConfigPackageTable.SETFILTER("Parent Table ID",'>0');
      ApplyPackageTables(ConfigPackage,ConfigPackageTable,ApplyMode::PrimaryKey);
      ApplyPackageTables(ConfigPackage,ConfigPackageTable,ApplyMode::NonKeyFields);

      ProcessAppliedPackageRecords(TempConfigRecordForProcessing,TempAppliedConfigPackageRecord);
      IF (ConfigPackage.Code <> MSGPPackageCodeTxt) AND (ConfigPackage.Code <> QBPackageCodeTxt) THEN
        DeleteAppliedPackageRecords(TempAppliedConfigPackageRecord); // Do not delete PackageRecords till transactions are created

      ConfigPackage.CALCFIELDS("No. of Errors");
      ErrorCount := ConfigPackage."No. of Errors" - ErrorCount;
      IF ErrorCount < 0 THEN
        ErrorCount := 0;

      RecordsModifiedCount := MaxInt(RecordsModifiedCount - RecordsInsertedCount,0);

      IF NOT HideDialog THEN
        MESSAGE(NoTablesAndErrorsMsg,TableCount,ErrorCount,RecordsInsertedCount,RecordsModifiedCount);

      FixIntegrationRecordIds;
    END;

    LOCAL PROCEDURE ApplyPackageTables@24(ConfigPackage@1002 : Record 8623;VAR ConfigPackageTable@1000 : Record 8613;ApplyMode@1003 : ',PrimaryKey,NonKeyFields');
    VAR
      ConfigPackageRecord@1001 : Record 8614;
    BEGIN
      ConfigPackageTable.SETCURRENTKEY("Package Processing Order","Processing Order");

      IF NOT HideDialog THEN
        ConfigProgressBar.Init(ConfigPackageTable.COUNT,1,
          STRSUBSTNO(ApplyingPackageMsg,ConfigPackage.Code));
      IF ConfigPackageTable.FINDSET THEN
        REPEAT
          ConfigPackageTable.CALCFIELDS("Table Name");
          ConfigPackageRecord.SETRANGE("Package Code",ConfigPackageTable."Package Code");
          ConfigPackageRecord.SETRANGE("Table ID",ConfigPackageTable."Table ID");
          IF NOT HideDialog THEN
            ConfigProgressBar.Update(ConfigPackageTable."Table Name");
          IF NOT IsTableErrorsExists(ConfigPackageTable) THEN// Added to show item duplicate errors
            ApplyPackageRecords(
              ConfigPackageRecord,ConfigPackageTable."Package Code",ConfigPackageTable."Table ID",ApplyMode);
        UNTIL ConfigPackageTable.NEXT = 0;

      IF NOT HideDialog THEN
        ConfigProgressBar.Close;
    END;

    [Internal]
    PROCEDURE ApplySelectedPackageRecords@14(VAR ConfigPackageRecord@1000 : Record 8614;PackageCode@1002 : Code[20];TableNo@1006 : Integer);
    BEGIN
      TempAppliedConfigPackageRecord.DELETEALL;
      TempConfigRecordForProcessing.DELETEALL;

      ApplyPackageRecords(ConfigPackageRecord,PackageCode,TableNo,ApplyMode::PrimaryKey);
      ApplyPackageRecords(ConfigPackageRecord,PackageCode,TableNo,ApplyMode::NonKeyFields);

      ProcessAppliedPackageRecords(TempConfigRecordForProcessing,TempAppliedConfigPackageRecord);
      DeleteAppliedPackageRecords(TempAppliedConfigPackageRecord);
    END;

    LOCAL PROCEDURE ApplyPackageRecords@67(VAR ConfigPackageRecord@1000 : Record 8614;PackageCode@1002 : Code[20];TableNo@1006 : Integer;ApplyMode@1004 : ',PrimaryKey,NonKeyFields');
    VAR
      ConfigPackageTable@1005 : Record 8613;
      ConfigTableProcessingRule@1012 : Record 8631;
      ConfigPackageMgt@1003 : Codeunit 8611;
      ConfigProgressBarRecord@1008 : Codeunit 8615;
      RecRef@1001 : RecordRef;
      RecordCount@1007 : Integer;
      StepCount@1009 : Integer;
      Counter@1010 : Integer;
      ProcessingRuleIsSet@1013 : Boolean;
    BEGIN
      ConfigPackageTable.GET(PackageCode,TableNo);
      ProcessingRuleIsSet := ConfigTableProcessingRule.FindTableRules(ConfigPackageTable);

      ConfigPackageMgt.SetApplyMode(ApplyMode);
      RecordCount := ConfigPackageRecord.COUNT;
      IF NOT HideDialog AND (RecordCount > 1000) THEN BEGIN
        StepCount := ROUND(RecordCount / 100,1);
        ConfigPackageTable.CALCFIELDS("Table Name");
        ConfigProgressBarRecord.Init(
          RecordCount,StepCount,STRSUBSTNO(ApplyingTableMsg,ConfigPackageTable."Table Name"));
      END;

      Counter := 0;
      IF ConfigPackageRecord.FINDSET THEN BEGIN
        RecRef.OPEN(ConfigPackageRecord."Table ID");
        IF ConfigPackageTable."Delete Recs Before Processing" THEN BEGIN
          RecRef.DELETEALL;
          COMMIT;
        END;
        REPEAT
          Counter := Counter + 1;
          IF (ApplyMode = ApplyMode::PrimaryKey) OR NOT IsRecordErrorsExistsInPrimaryKeyFields(ConfigPackageRecord) THEN BEGIN
            IF ConfigPackageMgt.RUN(ConfigPackageRecord) THEN BEGIN
              IF NOT ((ApplyMode = ApplyMode::PrimaryKey) OR IsRecordErrorsExists(ConfigPackageRecord)) THEN BEGIN
                CollectAppliedPackageRecord(ConfigPackageRecord,TempAppliedConfigPackageRecord);
                IF ProcessingRuleIsSet THEN
                  CollectRecordForProcessingAction(ConfigPackageRecord,ConfigTableProcessingRule);
              END
            END ELSE
              IF GETLASTERRORTEXT <> '' THEN BEGIN
                ConfigPackageMgt.RecordError(
                  ConfigPackageRecord,ConfigPackageMgt.GetValidationFieldID,COPYSTR(GETLASTERRORTEXT,1,250));
                CLEARLASTERROR;
                COMMIT;
              END;
            RecordsInsertedCount += ConfigPackageMgt.GetNumberOfRecordsInserted;
            RecordsModifiedCount += ConfigPackageMgt.GetNumberOfRecordsModified;
          END;
          IF NOT HideDialog AND (RecordCount > 1000) THEN
            ConfigProgressBarRecord.Update(STRSUBSTNO(RecordsXofYMsg,Counter,RecordCount));
        UNTIL ConfigPackageRecord.NEXT = 0;
      END;

      IF NOT HideDialog AND (RecordCount > 1000) THEN
        ConfigProgressBarRecord.Close;
    END;

    LOCAL PROCEDURE CollectRecordForProcessingAction@70(ConfigPackageRecord@1000 : Record 8614;VAR ConfigTableProcessingRule@1001 : Record 8631);
    BEGIN
      ConfigTableProcessingRule.FINDSET;
      REPEAT
        IF ConfigPackageRecord.FitsProcessingFilter(ConfigTableProcessingRule."Rule No.") THEN
          TempConfigRecordForProcessing.AddRecord(ConfigPackageRecord,ConfigTableProcessingRule."Rule No.");
      UNTIL ConfigTableProcessingRule.NEXT = 0;
    END;

    LOCAL PROCEDURE CollectAppliedPackageRecord@85(ConfigPackageRecord@1000 : Record 8614;VAR TempConfigPackageRecord@1001 : TEMPORARY Record 8614);
    BEGIN
      TempConfigPackageRecord.INIT;
      TempConfigPackageRecord := ConfigPackageRecord;
      TempConfigPackageRecord.INSERT;
    END;

    LOCAL PROCEDURE DeleteAppliedPackageRecords@82(VAR TempConfigPackageRecord@1000 : TEMPORARY Record 8614);
    VAR
      ConfigPackageRecord@1001 : Record 8614;
    BEGIN
      IF TempConfigPackageRecord.FINDSET THEN
        REPEAT
          ConfigPackageRecord.TRANSFERFIELDS(TempConfigPackageRecord);
          ConfigPackageRecord.DELETE(TRUE);
        UNTIL TempConfigPackageRecord.NEXT = 0;
      TempConfigPackageRecord.DELETEALL;
      COMMIT;
    END;

    [Internal]
    PROCEDURE ApplyConfigTables@47(ConfigPackage@1002 : Record 8623);
    VAR
      ConfigPackageTable@1000 : Record 8613;
    BEGIN
      ConfigPackageTable.RESET;
      ConfigPackageTable.SETRANGE("Package Code",ConfigPackage.Code);
      ConfigPackageTable.SETFILTER("Table ID",'%1|%2|%3|%4|%5|%6|%7|%8',
        DATABASE::"Config. Template Header",DATABASE::"Config. Template Line",
        DATABASE::"Config. Questionnaire",DATABASE::"Config. Question Area",DATABASE::"Config. Question",
        DATABASE::"Config. Line",DATABASE::"Config. Package Filter",DATABASE::"Config. Table Processing Rule");
      IF NOT ConfigPackageTable.ISEMPTY THEN BEGIN
        COMMIT;
        SetHideDialog(TRUE);
        ApplyPackageTables(ConfigPackage,ConfigPackageTable,ApplyMode::PrimaryKey);
        ApplyPackageTables(ConfigPackage,ConfigPackageTable,ApplyMode::NonKeyFields);
        DeleteAppliedPackageRecords(TempAppliedConfigPackageRecord);
      END;
    END;

    LOCAL PROCEDURE ProcessAppliedPackageRecords@76(VAR TempConfigRecordForProcessing@1000 : TEMPORARY Record 8632;VAR TempConfigPackageRecord@1003 : TEMPORARY Record 8614);
    VAR
      ConfigTableProcessingRule@1001 : Record 8631;
      Subscriber@1002 : Variant;
    BEGIN
      OnPreProcessPackage(TempConfigRecordForProcessing,Subscriber);
      IF TempConfigRecordForProcessing.FINDSET THEN
        REPEAT
          IF NOT ConfigTableProcessingRule.Process(TempConfigRecordForProcessing) THEN BEGIN
            TempConfigRecordForProcessing.FindConfigRecord(TempConfigPackageRecord);
            RecordError(TempConfigPackageRecord,0,COPYSTR(GETLASTERRORTEXT,1,250));
            TempConfigPackageRecord.DELETE; // Remove it from the buffer to avoid deletion in the package
            COMMIT;
          END;
        UNTIL TempConfigRecordForProcessing.NEXT = 0;
      TempConfigRecordForProcessing.DELETEALL;
      OnPostProcessPackage;
    END;

    [External]
    PROCEDURE SetApplyMode@41(NewApplyMode@1000 : ',PrimaryKey,NonKeyFields');
    BEGIN
      ApplyMode := NewApplyMode;
    END;

    [Internal]
    PROCEDURE SetFieldFilter@4(VAR Field@1000 : Record 2000000041;TableID@1001 : Integer;FieldID@1002 : Integer);
    BEGIN
      Field.RESET;
      IF TableID > 0 THEN
        Field.SETRANGE(TableNo,TableID);
      IF FieldID > 0 THEN
        Field.SETRANGE("No.",FieldID);
      Field.SETRANGE(Class,Field.Class::Normal);
      Field.SETRANGE(Enabled,TRUE);
      Field.SETFILTER(ObsoleteState,'<>%1',Field.ObsoleteState::Removed);
    END;

    [External]
    PROCEDURE SelectAllPackageFields@32(VAR ConfigPackageField@1000 : Record 8616;SetInclude@1003 : Boolean);
    VAR
      ConfigPackageField2@1004 : Record 8616;
    BEGIN
      ConfigPackageField.SETRANGE("Primary Key",FALSE);
      ConfigPackageField.SETRANGE("Include Field",NOT SetInclude);
      IF ConfigPackageField.FINDSET THEN
        REPEAT
          ConfigPackageField2.GET(ConfigPackageField."Package Code",ConfigPackageField."Table ID",ConfigPackageField."Field ID");
          ConfigPackageField2."Include Field" := SetInclude;
          ConfigPackageField2."Validate Field" :=
            SetInclude AND NOT ValidateException(ConfigPackageField."Table ID",ConfigPackageField."Field ID");
          ConfigPackageField2.MODIFY;
        UNTIL ConfigPackageField.NEXT = 0;
      ConfigPackageField.SETRANGE("Include Field");
      ConfigPackageField.SETRANGE("Primary Key");
    END;

    [Internal]
    PROCEDURE SetupProcessingOrder@53(VAR ConfigPackageTable@1000 : Record 8613);
    VAR
      ConfigPackageTableLoop@1001 : Record 8613;
      TempConfigPackageTable@1003 : TEMPORARY Record 8613;
      Flag@1002 : Integer;
    BEGIN
      ConfigPackageTableLoop.COPYFILTERS(ConfigPackageTable);
      IF NOT ConfigPackageTableLoop.FINDSET(TRUE) THEN
        EXIT;

      Flag := -1; // flag for all selected records: record processing order no was not initialized

      REPEAT
        ConfigPackageTableLoop."Processing Order" := Flag;
        ConfigPackageTableLoop.MODIFY;
      UNTIL ConfigPackageTableLoop.NEXT = 0;

      ConfigPackageTable.FINDSET(TRUE);
      REPEAT
        IF ConfigPackageTable."Processing Order" = Flag THEN BEGIN
          SetupTableProcessingOrder(ConfigPackageTable."Package Code",ConfigPackageTable."Table ID",TempConfigPackageTable,1);
          TempConfigPackageTable.RESET;
          TempConfigPackageTable.DELETEALL;
        END;
      UNTIL ConfigPackageTable.NEXT = 0;
    END;

    LOCAL PROCEDURE SetupTableProcessingOrder@49(PackageCode@1010 : Code[20];TableId@1000 : Integer;VAR CheckedConfigPackageTable@1009 : Record 8613;StackLevel@1011 : Integer) : Integer;
    VAR
      ConfigPackageTable@1007 : Record 8613;
      RecRef@1004 : RecordRef;
      FieldRef@1003 : FieldRef;
      KeyRef@1002 : KeyRef;
      I@1001 : Integer;
      ProcessingOrder@1008 : Integer;
    BEGIN
      IF CheckedConfigPackageTable.GET(PackageCode,TableId) THEN
        ERROR(ProcessingOrderErr,TableId);

      CheckedConfigPackageTable.INIT;
      CheckedConfigPackageTable."Package Code" := PackageCode;
      CheckedConfigPackageTable."Table ID" := TableId;
      // level to cleanup temptable from field branch checking history for case with multiple field branches
      CheckedConfigPackageTable."Processing Order" := StackLevel;
      CheckedConfigPackageTable.INSERT;

      RecRef.OPEN(TableId);
      KeyRef := RecRef.KEYINDEX(1);

      ProcessingOrder := 1;

      FOR I := 1 TO KeyRef.FIELDCOUNT DO BEGIN
        FieldRef := KeyRef.FIELDINDEX(I);
        IF (FieldRef.RELATION <> 0) AND (FieldRef.RELATION <> TableId) THEN
          IF ConfigPackageTable.GET(PackageCode,FieldRef.RELATION) THEN BEGIN
            ProcessingOrder :=
              MaxInt(
                SetupTableProcessingOrder(PackageCode,FieldRef.RELATION,CheckedConfigPackageTable,StackLevel + 1) + 1,ProcessingOrder);
            ClearFieldBranchCheckingHistory(PackageCode,CheckedConfigPackageTable,StackLevel);
          END;
      END;

      IF ConfigPackageTable.GET(PackageCode,TableId) THEN BEGIN
        ConfigPackageTable."Processing Order" := ProcessingOrder;
        AdjustProcessingOrder(ConfigPackageTable);
        ConfigPackageTable.MODIFY;
      END;

      EXIT(ProcessingOrder);
    END;

    LOCAL PROCEDURE AdjustProcessingOrder@74(VAR ConfigPackageTable@1000 : Record 8613);
    VAR
      RelatedConfigPackageTable@1001 : Record 8613;
    BEGIN
      WITH ConfigPackageTable DO
        CASE "Table ID" OF
          DATABASE::"G/L Account Category": // Pushing G/L Account Category before G/L Account
            IF RelatedConfigPackageTable.GET("Package Code",DATABASE::"G/L Account") THEN
              "Processing Order" := RelatedConfigPackageTable."Processing Order" - 1;
          DATABASE::"Sales Header"..DATABASE::"Purchase Line": // Moving Sales/Purchase Documents down
            "Processing Order" += 4;
          DATABASE::"Company Information":
            "Processing Order" += 1;
          DATABASE::"Custom Report Layout": // Moving Layouts to be on the top
            "Processing Order" := 0;
          // Moving Jobs tables down so contacts table can be processed first
          DATABASE::Job, DATABASE::"Job Task", DATABASE::"Job Planning Line", DATABASE::"Job Journal Line",
          DATABASE::"Job Journal Batch", DATABASE::"Job Posting Group", DATABASE::"Job Journal Template",
          DATABASE::"Job Responsibility":
            "Processing Order" += 4;
        END;
    END;

    LOCAL PROCEDURE ClearFieldBranchCheckingHistory@37(PackageCode@1002 : Code[20];VAR CheckedConfigPackageTable@1001 : Record 8613;StackLevel@1000 : Integer);
    BEGIN
      CheckedConfigPackageTable.SETRANGE("Package Code",PackageCode);
      CheckedConfigPackageTable.SETFILTER("Processing Order",'>%1',StackLevel);
      CheckedConfigPackageTable.DELETEALL;
    END;

    LOCAL PROCEDURE MaxInt@50(Int1@1000 : Integer;Int2@1001 : Integer) : Integer;
    BEGIN
      IF Int1 > Int2 THEN
        EXIT(Int1);

      EXIT(Int2);
    END;

    LOCAL PROCEDURE GetDimSetID@57(PackageCode@1005 : Code[20];DimSetValue@1000 : Text[250]) : Integer;
    VAR
      ConfigPackageData@1001 : Record 8615;
      ConfigPackageData2@1003 : Record 8615;
      TempDimSetEntry@1002 : TEMPORARY Record 480;
      DimMgt@1004 : Codeunit 408;
    BEGIN
      ConfigPackageData.SETRANGE("Package Code",PackageCode);
      ConfigPackageData.SETRANGE("Table ID",DATABASE::"Dimension Set Entry");
      ConfigPackageData.SETRANGE("Field ID",TempDimSetEntry.FIELDNO("Dimension Set ID"));
      IF ConfigPackageData.FINDSET THEN
        REPEAT
          IF ConfigPackageData.Value = DimSetValue THEN BEGIN
            TempDimSetEntry.INIT;
            ConfigPackageData2.GET(
              ConfigPackageData."Package Code",ConfigPackageData."Table ID",ConfigPackageData."No.",
              TempDimSetEntry.FIELDNO("Dimension Code"));
            TempDimSetEntry.VALIDATE("Dimension Code",FORMAT(ConfigPackageData2.Value));
            ConfigPackageData2.GET(
              ConfigPackageData."Package Code",ConfigPackageData."Table ID",ConfigPackageData."No.",
              TempDimSetEntry.FIELDNO("Dimension Value Code"));
            TempDimSetEntry.VALIDATE(
              "Dimension Value Code",COPYSTR(FORMAT(ConfigPackageData2.Value),1,MAXSTRLEN(TempDimSetEntry."Dimension Value Code")));
            TempDimSetEntry.INSERT;
          END;
        UNTIL ConfigPackageData.NEXT = 0;

      EXIT(DimMgt.GetDimensionSetID(TempDimSetEntry));
    END;

    [Internal]
    PROCEDURE GetDimSetIDForRecord@1(ConfigPackageRecord@1000 : Record 8614) : Integer;
    VAR
      ConfigPackageData@1001 : Record 8615;
      ConfigPackageField@1004 : Record 8616;
      TempDimSetEntry@1003 : TEMPORARY Record 480;
      DimValue@1005 : Record 349;
      DimMgt@1002 : Codeunit 408;
      ConfigPackageMgt@1008 : Codeunit 8611;
      DimCode@1006 : Code[20];
      DimValueCode@1007 : Code[20];
      DimValueNotFound@1009 : Boolean;
    BEGIN
      ConfigPackageData.SETRANGE("Package Code",ConfigPackageRecord."Package Code");
      ConfigPackageData.SETRANGE("Table ID",ConfigPackageRecord."Table ID");
      ConfigPackageData.SETRANGE("No.",ConfigPackageRecord."No.");
      ConfigPackageData.SETRANGE("Field ID",ConfigMgt.DimensionFieldID,ConfigMgt.DimensionFieldID + 999);
      ConfigPackageData.SETFILTER(Value,'<>%1','');
      IF ConfigPackageData.FINDSET THEN
        REPEAT
          IF ConfigPackageField.GET(ConfigPackageData."Package Code",ConfigPackageData."Table ID",ConfigPackageData."Field ID") THEN BEGIN
            ConfigPackageField.TESTFIELD(Dimension);
            DimCode := COPYSTR(FORMAT(ConfigPackageField."Field Name"),1,20);
            DimValueCode := COPYSTR(FORMAT(ConfigPackageData.Value),1,MAXSTRLEN(TempDimSetEntry."Dimension Value Code"));
            TempDimSetEntry.INIT;
            TempDimSetEntry.VALIDATE("Dimension Code",DimCode);
            IF DimValue.GET(DimCode,DimValueCode) THEN BEGIN
              TempDimSetEntry.VALIDATE("Dimension Value Code",DimValueCode);
              TempDimSetEntry.INSERT;
            END ELSE BEGIN
              ConfigPackageMgt.FieldError(
                ConfigPackageData,STRSUBSTNO(DimValueDoesNotExistsErr,DimCode,DimValueCode),ErrorTypeEnum::General);
              DimValueNotFound := TRUE;
            END;
          END;
        UNTIL ConfigPackageData.NEXT = 0;
      IF DimValueNotFound THEN
        EXIT(0);
      EXIT(DimMgt.GetDimensionSetID(TempDimSetEntry));
    END;

    LOCAL PROCEDURE UpdateDimSetIDValues@61(ConfigPackage@1001 : Record 8623);
    VAR
      ConfigPackageData@1000 : Record 8615;
      ConfigPackageTable@1004 : Record 8613;
      ConfigPackageTableDim@1002 : Record 8613;
      ConfigPackageDataDimSet@1003 : Record 8615;
      DimSetEntry@1005 : Record 480;
    BEGIN
      ConfigPackageTableDim.SETRANGE("Package Code",ConfigPackage.Code);
      ConfigPackageTableDim.SETRANGE("Table ID",DATABASE::Dimension,DATABASE::"Default Dimension Priority");
      IF NOT ConfigPackageTableDim.ISEMPTY THEN BEGIN
        ApplyPackageTables(ConfigPackage,ConfigPackageTableDim,ApplyMode::PrimaryKey);
        ApplyPackageTables(ConfigPackage,ConfigPackageTableDim,ApplyMode::NonKeyFields);
      END;

      ConfigPackageDataDimSet.SETRANGE("Package Code",ConfigPackage.Code);
      ConfigPackageDataDimSet.SETRANGE("Table ID",DATABASE::"Dimension Set Entry");
      ConfigPackageDataDimSet.SETRANGE("Field ID",DimSetEntry.FIELDNO("Dimension Set ID"));
      IF ConfigPackageDataDimSet.ISEMPTY THEN
        EXIT;

      ConfigPackageData.RESET;
      ConfigPackageData.SETRANGE("Package Code",ConfigPackage.Code);
      ConfigPackageData.SETFILTER("Table ID",'<>%1',DATABASE::"Dimension Set Entry");
      ConfigPackageData.SETRANGE("Field ID",DATABASE::"Dimension Set Entry");
      IF ConfigPackageData.FINDSET(TRUE) THEN BEGIN
        IF NOT HideDialog THEN
          ConfigProgressBar.Init(ConfigPackageData.COUNT,1,UpdatingDimSetsMsg);
        REPEAT
          ConfigPackageTable.GET(ConfigPackage.Code,ConfigPackageData."Table ID");
          ConfigPackageTable.CALCFIELDS("Table Name");
          IF NOT HideDialog THEN
            ConfigProgressBar.Update(ConfigPackageTable."Table Name");
          IF ConfigPackageData.Value <> '' THEN BEGIN
            ConfigPackageData.Value := FORMAT(GetDimSetID(ConfigPackage.Code,ConfigPackageData.Value));
            ConfigPackageData.MODIFY;
          END;
        UNTIL ConfigPackageData.NEXT = 0;
        IF NOT HideDialog THEN
          ConfigProgressBar.Close;
      END;
    END;

    [Internal]
    PROCEDURE UpdateDefaultDimValues@30(ConfigPackageRecord@1001 : Record 8614;MasterNo@1007 : Code[20]);
    VAR
      ConfigPackageTableDim@1000 : Record 8613;
      ConfigPackageRecordDim@1003 : Record 8614;
      ConfigPackageDataDim@1004 : ARRAY [4] OF Record 8615;
      ConfigPackageField@1006 : Record 8616;
      ConfigPackageData@1002 : Record 8615;
      DefaultDim@1005 : Record 352;
      DimValue@1009 : Record 349;
      RecordFound@1008 : Boolean;
    BEGIN
      ConfigPackageRecord.TESTFIELD("Package Code");
      ConfigPackageRecord.TESTFIELD("Table ID");

      ConfigPackageData.RESET;
      ConfigPackageData.SETRANGE("Package Code",ConfigPackageRecord."Package Code");
      ConfigPackageData.SETRANGE("Table ID",ConfigPackageRecord."Table ID");
      ConfigPackageData.SETRANGE("No.",ConfigPackageRecord."No.");
      ConfigPackageData.SETRANGE("Field ID",ConfigMgt.DimensionFieldID,ConfigMgt.DimensionFieldID + 999);
      ConfigPackageData.SETFILTER(Value,'<>%1','');
      IF ConfigPackageData.FINDSET THEN
        REPEAT
          IF ConfigPackageField.GET(ConfigPackageData."Package Code",ConfigPackageData."Table ID",ConfigPackageData."Field ID") THEN BEGIN
            // find if Dimension Code already exist
            RecordFound := FALSE;
            ConfigPackageDataDim[1].SETRANGE("Package Code",ConfigPackageRecord."Package Code");
            ConfigPackageDataDim[1].SETRANGE("Table ID",DATABASE::"Default Dimension");
            ConfigPackageDataDim[1].SETRANGE("Field ID",DefaultDim.FIELDNO("Table ID"));
            ConfigPackageDataDim[1].SETRANGE(Value,FORMAT(ConfigPackageRecord."Table ID"));
            IF ConfigPackageDataDim[1].FINDSET THEN
              REPEAT
                ConfigPackageDataDim[2].SETRANGE("Package Code",ConfigPackageRecord."Package Code");
                ConfigPackageDataDim[2].SETRANGE("Table ID",DATABASE::"Default Dimension");
                ConfigPackageDataDim[2].SETRANGE("No.",ConfigPackageDataDim[1]."No.");
                ConfigPackageDataDim[2].SETRANGE("Field ID",DefaultDim.FIELDNO("No."));
                ConfigPackageDataDim[2].SETRANGE(Value,MasterNo);
                IF ConfigPackageDataDim[2].FINDSET THEN
                  REPEAT
                    ConfigPackageDataDim[3].SETRANGE("Package Code",ConfigPackageRecord."Package Code");
                    ConfigPackageDataDim[3].SETRANGE("Table ID",DATABASE::"Default Dimension");
                    ConfigPackageDataDim[3].SETRANGE("No.",ConfigPackageDataDim[2]."No.");
                    ConfigPackageDataDim[3].SETRANGE("Field ID",DefaultDim.FIELDNO("Dimension Code"));
                    ConfigPackageDataDim[3].SETRANGE(Value,ConfigPackageField."Field Name");
                    RecordFound := ConfigPackageDataDim[3].FINDFIRST;
                  UNTIL (ConfigPackageDataDim[2].NEXT = 0) OR RecordFound;
              UNTIL (ConfigPackageDataDim[1].NEXT = 0) OR RecordFound;
            IF NOT RecordFound THEN BEGIN
              IF NOT ConfigPackageTableDim.GET(ConfigPackageRecord."Package Code",DATABASE::"Default Dimension") THEN
                InsertPackageTable(ConfigPackageTableDim,ConfigPackageRecord."Package Code",DATABASE::"Default Dimension");
              InitPackageRecord(ConfigPackageRecordDim,ConfigPackageTableDim."Package Code",ConfigPackageTableDim."Table ID");
              // Insert Default Dimension record
              InsertPackageData(ConfigPackageDataDim[4],
                ConfigPackageRecordDim."Package Code",ConfigPackageRecordDim."Table ID",ConfigPackageRecordDim."No.",
                DefaultDim.FIELDNO("Table ID"),FORMAT(ConfigPackageRecord."Table ID"),FALSE);
              InsertPackageData(ConfigPackageDataDim[4],
                ConfigPackageRecordDim."Package Code",ConfigPackageRecordDim."Table ID",ConfigPackageRecordDim."No.",
                DefaultDim.FIELDNO("No."),FORMAT(MasterNo),FALSE);
              InsertPackageData(ConfigPackageDataDim[4],
                ConfigPackageRecordDim."Package Code",ConfigPackageRecordDim."Table ID",ConfigPackageRecordDim."No.",
                DefaultDim.FIELDNO("Dimension Code"),ConfigPackageField."Field Name",FALSE);
              IF IsBlankDim(ConfigPackageData.Value) THEN
                InsertPackageData(ConfigPackageDataDim[4],
                  ConfigPackageRecordDim."Package Code",ConfigPackageRecordDim."Table ID",ConfigPackageRecordDim."No.",
                  DefaultDim.FIELDNO("Dimension Value Code"),'',FALSE)
              ELSE
                InsertPackageData(ConfigPackageDataDim[4],
                  ConfigPackageRecordDim."Package Code",ConfigPackageRecordDim."Table ID",ConfigPackageRecordDim."No.",
                  DefaultDim.FIELDNO("Dimension Value Code"),ConfigPackageData.Value,FALSE);
            END ELSE BEGIN
              ConfigPackageDataDim[3].SETRANGE("Field ID",DefaultDim.FIELDNO("Dimension Value Code"));
              ConfigPackageDataDim[3].SETRANGE(Value);
              ConfigPackageDataDim[3].FINDFIRST;
              ConfigPackageDataDim[3].Value := ConfigPackageData.Value;
              ConfigPackageDataDim[3].MODIFY;
            END;
            // Insert Dimension value if needed
            IF NOT IsBlankDim(ConfigPackageData.Value) THEN
              IF NOT DimValue.GET(ConfigPackageField."Field Name",ConfigPackageData.Value) THEN BEGIN
                ConfigPackageRecord.TESTFIELD("Package Code");
                IF NOT ConfigPackageTableDim.GET(ConfigPackageRecord."Package Code",DATABASE::"Dimension Value") THEN
                  InsertPackageTable(ConfigPackageTableDim,ConfigPackageRecord."Package Code",DATABASE::"Dimension Value");
                InitPackageRecord(ConfigPackageRecordDim,ConfigPackageTableDim."Package Code",ConfigPackageTableDim."Table ID");
                InsertPackageData(ConfigPackageDataDim[4],
                  ConfigPackageRecordDim."Package Code",ConfigPackageRecordDim."Table ID",ConfigPackageRecordDim."No.",
                  DimValue.FIELDNO("Dimension Code"),ConfigPackageField."Field Name",FALSE);
                InsertPackageData(ConfigPackageDataDim[4],
                  ConfigPackageRecordDim."Package Code",ConfigPackageRecordDim."Table ID",ConfigPackageRecordDim."No.",
                  DimValue.FIELDNO(Code),ConfigPackageData.Value,FALSE);
              END;
          END;
        UNTIL ConfigPackageData.NEXT = 0;
    END;

    LOCAL PROCEDURE IsBlankDim@28(Value@1000 : Text[250]) : Boolean;
    BEGIN
      EXIT(UPPERCASE(Value) = UPPERCASE(BlankTxt));
    END;

    [External]
    PROCEDURE SetHideDialog@48(NewHideDialog@1000 : Boolean);
    BEGIN
      HideDialog := NewHideDialog;
    END;

    [External]
    PROCEDURE AddConfigTables@5(PackageCode@1000 : Code[20]);
    VAR
      ConfigPackageTable@1001 : Record 8613;
      ConfigPackageFilter@1002 : Record 8626;
      ConfigLine@1003 : Record 8622;
    BEGIN
      ConfigPackageTable.INIT;
      InsertPackageTable(ConfigPackageTable,PackageCode,DATABASE::"Config. Questionnaire");
      InsertPackageTable(ConfigPackageTable,PackageCode,DATABASE::"Config. Question Area");
      InsertPackageTable(ConfigPackageTable,PackageCode,DATABASE::"Config. Question");
      InsertPackageTable(ConfigPackageTable,PackageCode,DATABASE::"Config. Template Header");
      InsertPackageTable(ConfigPackageTable,PackageCode,DATABASE::"Config. Template Line");
      InsertPackageTable(ConfigPackageTable,PackageCode,DATABASE::"Config. Tmpl. Selection Rules");
      InsertPackageTable(ConfigPackageTable,PackageCode,DATABASE::"Config. Line");
      InsertPackageFilter(ConfigPackageFilter,PackageCode,DATABASE::"Config. Line",0,ConfigLine.FIELDNO("Package Code"),PackageCode);
      InsertPackageTable(ConfigPackageTable,PackageCode,DATABASE::"Config. Package Filter");
      InsertPackageFilter(
        ConfigPackageFilter,PackageCode,DATABASE::"Config. Package Filter",0,ConfigPackageFilter.FIELDNO("Package Code"),PackageCode);
      InsertPackageTable(ConfigPackageTable,PackageCode,DATABASE::"Config. Field Mapping");
      InsertPackageTable(ConfigPackageTable,PackageCode,DATABASE::"Config. Table Processing Rule");
      SetSkipTableTriggers(ConfigPackageTable,PackageCode,DATABASE::"Config. Table Processing Rule",TRUE);
      InsertPackageFilter(
        ConfigPackageFilter,PackageCode,DATABASE::"Config. Table Processing Rule",0,
        ConfigPackageFilter.FIELDNO("Package Code"),PackageCode);
    END;

    [External]
    PROCEDURE AssignPackage@13(VAR ConfigLine@1000 : Record 8622;PackageCode@1005 : Code[20]);
    VAR
      ConfigLine2@1001 : Record 8622;
      TempConfigLine@1002 : TEMPORARY Record 8622;
      ConfigPackageTable@1003 : Record 8613;
      ConfigPackageTable2@1004 : Record 8613;
      LineTypeFilter@1006 : Text;
    BEGIN
      CreateConfigLineBuffer(ConfigLine,TempConfigLine,PackageCode);
      CheckConfigLinesToAssign(TempConfigLine);

      LineTypeFilter := ConfigLine.GETFILTER("Line Type");
      ConfigLine.SETFILTER("Package Code",'<>%1',PackageCode);
      ConfigLine.SETRANGE("Line Type");
      IF ConfigLine.FINDSET(TRUE) THEN
        REPEAT
          ConfigLine.CheckBlocked;
          IF ConfigLine.Status <= ConfigLine.Status::"In Progress" THEN BEGIN
            IF ConfigLine."Line Type" = ConfigLine."Line Type"::Table THEN BEGIN
              ConfigLine.TESTFIELD("Table ID");
              IF ConfigPackageTable.GET(ConfigLine."Package Code",ConfigLine."Table ID") THEN BEGIN
                ConfigLine2.SETRANGE("Package Code",PackageCode);
                ConfigLine2.SETRANGE("Table ID",ConfigLine."Table ID");
                CheckConfigLinesToAssign(ConfigLine2);
                InsertPackageTable(ConfigPackageTable2,PackageCode,ConfigLine."Table ID");
                ChangePackageCode(ConfigLine."Package Code",PackageCode,ConfigLine."Table ID");
                ConfigPackageTable.DELETE(TRUE);
              END ELSE
                IF NOT ConfigPackageTable.GET(PackageCode,ConfigLine."Table ID") THEN
                  InsertPackageTable(ConfigPackageTable,PackageCode,ConfigLine."Table ID");
            END;
            ConfigLine."Package Code" := PackageCode;
            ConfigLine.MODIFY;
          END;
        UNTIL ConfigLine.NEXT = 0;

      ConfigLine.SETRANGE("Package Code");
      IF LineTypeFilter <> '' THEN
        ConfigLine.SETFILTER("Line Type",LineTypeFilter);
    END;

    LOCAL PROCEDURE ChangePackageCode@34(OldPackageCode@1000 : Code[20];NewPackageCode@1001 : Code[20];TableID@1010 : Integer);
    VAR
      ConfigPackageRecord@1006 : Record 8614;
      TempConfigPackageRecord@1007 : TEMPORARY Record 8614;
      ConfigPackageData@1008 : Record 8615;
      TempConfigPackageData@1009 : TEMPORARY Record 8615;
      ConfigPackageFilter@1005 : Record 8626;
      TempConfigPackageFilter@1004 : TEMPORARY Record 8626;
      ConfigPackageError@1003 : Record 8617;
      TempConfigPackageError@1002 : TEMPORARY Record 8617;
    BEGIN
      TempConfigPackageRecord.DELETEALL;
      ConfigPackageRecord.SETRANGE("Package Code",OldPackageCode);
      ConfigPackageRecord.SETRANGE("Table ID",TableID);
      IF ConfigPackageRecord.FINDSET(TRUE,TRUE) THEN
        REPEAT
          TempConfigPackageRecord := ConfigPackageRecord;
          TempConfigPackageRecord."Package Code" := NewPackageCode;
          TempConfigPackageRecord.INSERT;
        UNTIL ConfigPackageRecord.NEXT = 0;
      IF TempConfigPackageRecord.FINDSET THEN
        REPEAT
          ConfigPackageRecord := TempConfigPackageRecord;
          ConfigPackageRecord.INSERT;
        UNTIL TempConfigPackageRecord.NEXT = 0;

      TempConfigPackageData.DELETEALL;
      ConfigPackageData.SETRANGE("Package Code",OldPackageCode);
      ConfigPackageData.SETRANGE("Table ID",TableID);
      IF ConfigPackageData.FINDSET(TRUE,TRUE) THEN
        REPEAT
          TempConfigPackageData := ConfigPackageData;
          TempConfigPackageData."Package Code" := NewPackageCode;
          TempConfigPackageData.INSERT;
        UNTIL ConfigPackageData.NEXT = 0;
      IF TempConfigPackageData.FINDSET THEN
        REPEAT
          ConfigPackageData := TempConfigPackageData;
          ConfigPackageData.INSERT;
        UNTIL TempConfigPackageData.NEXT = 0;

      TempConfigPackageError.DELETEALL;
      ConfigPackageError.SETRANGE("Package Code",OldPackageCode);
      ConfigPackageError.SETRANGE("Table ID",TableID);
      IF ConfigPackageError.FINDSET(TRUE,TRUE) THEN
        REPEAT
          TempConfigPackageError := ConfigPackageError;
          TempConfigPackageError."Package Code" := NewPackageCode;
          TempConfigPackageError.INSERT;
        UNTIL ConfigPackageError.NEXT = 0;
      IF TempConfigPackageError.FINDSET THEN
        REPEAT
          ConfigPackageError := TempConfigPackageError;
          ConfigPackageError.INSERT;
        UNTIL TempConfigPackageError.NEXT = 0;

      TempConfigPackageFilter.DELETEALL;
      ConfigPackageFilter.SETRANGE("Package Code",OldPackageCode);
      ConfigPackageFilter.SETRANGE("Table ID",TableID);
      IF ConfigPackageFilter.FINDSET(TRUE,TRUE) THEN
        REPEAT
          TempConfigPackageFilter := ConfigPackageFilter;
          TempConfigPackageFilter."Package Code" := NewPackageCode;
          TempConfigPackageFilter.INSERT;
        UNTIL ConfigPackageFilter.NEXT = 0;
      IF TempConfigPackageFilter.FINDSET THEN
        REPEAT
          ConfigPackageFilter := TempConfigPackageFilter;
          ConfigPackageFilter.INSERT;
        UNTIL TempConfigPackageFilter.NEXT = 0;
    END;

    [External]
    PROCEDURE CheckConfigLinesToAssign@7(VAR ConfigLine@1000 : Record 8622);
    VAR
      TempObject@1001 : TEMPORARY Record 2000000001;
    BEGIN
      ConfigLine.SETRANGE("Line Type",ConfigLine."Line Type"::Table);
      IF ConfigLine.FINDSET THEN
        REPEAT
          IF TempObject.GET(TempObject.Type::Table,'',ConfigLine."Table ID") THEN
            ERROR(ReferenceSameTableErr);
          TempObject.Type := TempObject.Type::Table;
          TempObject.ID := ConfigLine."Table ID";
          TempObject.INSERT;
        UNTIL ConfigLine.NEXT = 0;
    END;

    LOCAL PROCEDURE CreateConfigLineBuffer@16(VAR ConfigLineNew@1000 : Record 8622;VAR ConfigLineBuffer@1002 : Record 8622;PackageCode@1001 : Code[20]);
    VAR
      ConfigLine@1003 : Record 8622;
    BEGIN
      ConfigLine.SETRANGE("Package Code",PackageCode);
      AddConfigLineToBuffer(ConfigLine,ConfigLineBuffer);
      AddConfigLineToBuffer(ConfigLineNew,ConfigLineBuffer);
    END;

    LOCAL PROCEDURE AddConfigLineToBuffer@21(VAR ConfigLine@1001 : Record 8622;VAR ConfigLineBuffer@1000 : Record 8622);
    BEGIN
      IF ConfigLine.FINDSET THEN
        REPEAT
          IF NOT ConfigLineBuffer.GET(ConfigLine."Line No.") THEN BEGIN
            ConfigLineBuffer.INIT;
            ConfigLineBuffer.TRANSFERFIELDS(ConfigLine);
            ConfigLineBuffer.INSERT;
          END;
        UNTIL ConfigLine.NEXT = 0;
    END;

    [Internal]
    PROCEDURE GetRelatedTables@22(VAR ConfigPackageTable@1000 : Record 8613);
    VAR
      TempConfigPackageTable@1001 : TEMPORARY Record 8613;
      Field@1002 : Record 2000000041;
    BEGIN
      TempConfigPackageTable.DELETEALL;
      IF ConfigPackageTable.FINDSET THEN
        REPEAT
          SetFieldFilter(Field,ConfigPackageTable."Table ID",0);
          Field.SETFILTER(RelationTableNo,'<>%1&<>%2&..%3',0,ConfigPackageTable."Table ID",99000999);
          IF Field.FINDSET THEN
            REPEAT
              TempConfigPackageTable."Package Code" := ConfigPackageTable."Package Code";
              TempConfigPackageTable."Table ID" := Field.RelationTableNo;
              IF TempConfigPackageTable.INSERT THEN;
            UNTIL Field.NEXT = 0;
        UNTIL ConfigPackageTable.NEXT = 0;

      ConfigPackageTable.RESET;
      IF TempConfigPackageTable.FINDSET THEN
        REPEAT
          IF NOT ConfigPackageTable.GET(TempConfigPackageTable."Package Code",TempConfigPackageTable."Table ID") THEN
            InsertPackageTable(ConfigPackageTable,TempConfigPackageTable."Package Code",TempConfigPackageTable."Table ID");
        UNTIL TempConfigPackageTable.NEXT = 0;
    END;

    LOCAL PROCEDURE GetKeyFieldsOrder@27(RecRef@1000 : RecordRef;PackageCode@1003 : Code[20];VAR TempConfigPackageField@1001 : TEMPORARY Record 8616);
    VAR
      ConfigPackageField@1002 : Record 8616;
      KeyRef@1006 : KeyRef;
      FieldRef@1007 : FieldRef;
      KeyFieldCount@1005 : Integer;
    BEGIN
      KeyRef := RecRef.KEYINDEX(1);
      FOR KeyFieldCount := 1 TO KeyRef.FIELDCOUNT DO BEGIN
        FieldRef := KeyRef.FIELDINDEX(KeyFieldCount);
        ValidationFieldID := FieldRef.NUMBER;

        IF ConfigPackageField.GET(PackageCode,RecRef.NUMBER,FieldRef.NUMBER) THEN;

        TempConfigPackageField.INIT;
        TempConfigPackageField."Package Code" := PackageCode;
        TempConfigPackageField."Table ID" := RecRef.NUMBER;
        TempConfigPackageField."Field ID" := FieldRef.NUMBER;
        TempConfigPackageField."Processing Order" := ConfigPackageField."Processing Order";
        TempConfigPackageField.INSERT;
      END;
    END;

    LOCAL PROCEDURE GetFieldsMarkedAsPrimaryKey@87(PackageCode@1001 : Code[20];TableID@1002 : Integer;VAR TempConfigPackageField@1000 : TEMPORARY Record 8616);
    VAR
      ConfigPackageField@1003 : Record 8616;
    BEGIN
      ConfigPackageField.SETRANGE("Package Code",PackageCode);
      ConfigPackageField.SETRANGE("Table ID",TableID);
      ConfigPackageField.SETRANGE("Primary Key",TRUE);
      IF ConfigPackageField.FINDSET THEN
        REPEAT
          TempConfigPackageField.TRANSFERFIELDS(ConfigPackageField);
          IF TempConfigPackageField.INSERT THEN;
        UNTIL ConfigPackageField.NEXT = 0;
    END;

    [External]
    PROCEDURE GetFieldsOrder@23(RecRef@1000 : RecordRef;PackageCode@1003 : Code[20];VAR TempConfigPackageField@1001 : TEMPORARY Record 8616);
    VAR
      ConfigPackageField@1002 : Record 8616;
      Field@1004 : Record 2000000041;
      FieldRef@1007 : FieldRef;
    BEGIN
      IF TypeHelper.FindFields(RecRef.NUMBER,Field) THEN
        REPEAT
          FieldRef := RecRef.FIELD(Field."No.");

          IF ConfigPackageField.GET(PackageCode,RecRef.NUMBER,FieldRef.NUMBER) THEN;

          TempConfigPackageField.INIT;
          TempConfigPackageField."Package Code" := PackageCode;
          TempConfigPackageField."Table ID" := RecRef.NUMBER;
          TempConfigPackageField."Field ID" := FieldRef.NUMBER;
          TempConfigPackageField."Processing Order" := ConfigPackageField."Processing Order";
          TempConfigPackageField.INSERT;
        UNTIL Field.NEXT = 0;
    END;

    LOCAL PROCEDURE IsRecordErrorsExists@26(ConfigPackageRecord@1001 : Record 8614) : Boolean;
    VAR
      ConfigPackageError@1000 : Record 8617;
    BEGIN
      ConfigPackageError.SETRANGE("Package Code",ConfigPackageRecord."Package Code");
      ConfigPackageError.SETRANGE("Table ID",ConfigPackageRecord."Table ID");
      ConfigPackageError.SETRANGE("Record No.",ConfigPackageRecord."No.");
      EXIT(NOT ConfigPackageError.ISEMPTY);
    END;

    LOCAL PROCEDURE IsRecordErrorsExistsInPrimaryKeyFields@60(ConfigPackageRecord@1001 : Record 8614) : Boolean;
    VAR
      ConfigPackageError@1000 : Record 8617;
    BEGIN
      WITH ConfigPackageError DO BEGIN
        SETRANGE("Package Code",ConfigPackageRecord."Package Code");
        SETRANGE("Table ID",ConfigPackageRecord."Table ID");
        SETRANGE("Record No.",ConfigPackageRecord."No.");

        IF FINDSET THEN
          REPEAT
            IF ConfigValidateMgt.IsKeyField("Table ID","Field ID") THEN
              EXIT(TRUE);
          UNTIL NEXT = 0;
      END;

      EXIT(FALSE);
    END;

    [External]
    PROCEDURE UpdateConfigLinePackageData@6(ConfigPackageCode@1004 : Code[20]);
    VAR
      ConfigLine@1000 : Record 8622;
      ConfigPackageData@1003 : Record 8615;
      ShiftLineNo@1001 : BigInteger;
      ShiftVertNo@1002 : Integer;
      TempValue@1005 : BigInteger;
    BEGIN
      ConfigLine.RESET;
      IF NOT ConfigLine.FINDLAST THEN
        EXIT;

      ShiftLineNo := ConfigLine."Line No." + 10000L;
      ShiftVertNo := ConfigLine."Vertical Sorting" + 1;

      WITH ConfigPackageData DO BEGIN
        SETRANGE("Package Code",ConfigPackageCode);
        SETRANGE("Table ID",DATABASE::"Config. Line");
        SETRANGE("Field ID",ConfigLine.FIELDNO("Line No."));
        IF FINDSET THEN
          REPEAT
            IF EVALUATE(TempValue,Value) THEN BEGIN
              Value := FORMAT(TempValue + ShiftLineNo);
              MODIFY;
            END;
          UNTIL NEXT = 0;
        SETRANGE("Field ID",ConfigLine.FIELDNO("Vertical Sorting"));
        IF FINDSET THEN
          REPEAT
            IF EVALUATE(TempValue,Value) THEN BEGIN
              Value := FORMAT(TempValue + ShiftVertNo);
              MODIFY;
            END;
          UNTIL NEXT = 0;
      END;
    END;

    [Internal]
    PROCEDURE HandlePackageDataDimSetIDForRecord@51(ConfigPackageRecord@1004 : Record 8614);
    VAR
      ConfigPackageData@1003 : Record 8615;
      ConfigPackageMgt@1000 : Codeunit 8611;
      DimPackageDataExists@1001 : Boolean;
      DimSetID@1002 : Integer;
    BEGIN
      DimSetID := ConfigPackageMgt.GetDimSetIDForRecord(ConfigPackageRecord);
      DimPackageDataExists :=
        GetDimPackageDataFromRecord(ConfigPackageData,ConfigPackageRecord);
      IF DimSetID = 0 THEN BEGIN
        IF DimPackageDataExists THEN
          ConfigPackageData.DELETE(TRUE);
      END ELSE
        IF NOT DimPackageDataExists THEN
          CreateDimPackageDataFromRecord(ConfigPackageData,ConfigPackageRecord,DimSetID)
        ELSE
          IF ConfigPackageData.Value <> FORMAT(DimSetID) THEN BEGIN
            ConfigPackageData.Value := FORMAT(DimSetID);
            ConfigPackageData.MODIFY;
          END;
    END;

    LOCAL PROCEDURE GetDimPackageDataFromRecord@54(VAR ConfigPackageData@1000 : Record 8615;ConfigPackageRecord@1001 : Record 8614) : Boolean;
    BEGIN
      EXIT(
        ConfigPackageData.GET(
          ConfigPackageRecord."Package Code",ConfigPackageRecord."Table ID",ConfigPackageRecord."No.",
          DATABASE::"Dimension Set Entry"));
    END;

    LOCAL PROCEDURE CreateDimPackageDataFromRecord@52(VAR ConfigPackageData@1000 : Record 8615;ConfigPackageRecord@1003 : Record 8614;DimSetID@1002 : Integer);
    VAR
      ConfigPackageField@1001 : Record 8616;
    BEGIN
      IF ConfigPackageField.GET(ConfigPackageRecord."Package Code",ConfigPackageRecord."Table ID",DATABASE::"Dimension Set Entry") THEN BEGIN
        ConfigPackageField.VALIDATE("Include Field",TRUE);
        ConfigPackageField.MODIFY(TRUE);
      END;

      WITH ConfigPackageData DO BEGIN
        INIT;
        "Package Code" := ConfigPackageRecord."Package Code";
        "Table ID" := ConfigPackageRecord."Table ID";
        "Field ID" := DATABASE::"Dimension Set Entry";
        "No." := ConfigPackageRecord."No.";
        Value := FORMAT(DimSetID);
        INSERT;
      END;
    END;

    LOCAL PROCEDURE UpdateValueUsingMapping@56(VAR ConfigPackageData@1000 : Record 8615;ConfigPackageField@1002 : Record 8616;PackageCode@1003 : Code[20]);
    VAR
      ConfigFieldMapping@1001 : Record 8628;
      NewValue@1004 : Text[250];
    BEGIN
      IF ConfigFieldMapping.GET(
           ConfigPackageData."Package Code",
           ConfigPackageField."Table ID",
           ConfigPackageField."Field ID",
           ConfigPackageData.Value)
      THEN
        NewValue := ConfigFieldMapping."New Value";

      IF (NewValue = '') AND (ConfigPackageField."Relation Table ID" <> 0) THEN
        NewValue := GetMappingFromPKOfRelatedTable(ConfigPackageField,ConfigPackageData.Value);

      IF NewValue <> '' THEN BEGIN
        ConfigPackageData.VALIDATE(Value,NewValue);
        ConfigPackageData.MODIFY;
      END;

      IF ConfigPackageField."Create Missing Codes" THEN
        CreateMissingCodes(ConfigPackageData,ConfigPackageField."Relation Table ID",PackageCode);
    END;

    LOCAL PROCEDURE CreateMissingCodes@106(VAR ConfigPackageData@1000 : Record 8615;RelationTableID@1001 : Integer;PackageCode@1006 : Code[20]);
    VAR
      RecRef@1004 : RecordRef;
      KeyRef@1003 : KeyRef;
      FieldRef@1002 : ARRAY [16] OF FieldRef;
      i@1007 : Integer;
    BEGIN
      RecRef.OPEN(RelationTableID);
      KeyRef := RecRef.KEYINDEX(1);
      FOR i := 1 TO KeyRef.FIELDCOUNT DO BEGIN
        FieldRef[i] := KeyRef.FIELDINDEX(i);
        FieldRef[i].VALUE(RelatedKeyFieldValue(ConfigPackageData,RelationTableID,FieldRef[i].NUMBER));
      END;

      // even "Create Missing Codes" is marked we should not create for blank account numbers and blank/zero account categories should not be created
      IF ConfigPackageData."Table ID" <> 15 THEN BEGIN
        IF RecRef.INSERT THEN;
      END ELSE
        IF (ConfigPackageData.Value <> '') AND ((ConfigPackageData.Value <> '0') AND (ConfigPackageData."Field ID" = 80)) OR
           ((PackageCode <> QBPackageCodeTxt) AND (PackageCode <> MSGPPackageCodeTxt))
        THEN
          IF RecRef.INSERT THEN;
    END;

    LOCAL PROCEDURE RelatedKeyFieldValue@94(VAR ConfigPackageData@1006 : Record 8615;TableID@1003 : Integer;FieldNo@1004 : Integer) : Text[250];
    VAR
      ConfigPackageDataOtherFields@1001 : Record 8615;
      TableRelationsMetadata@1000 : Record 2000000141;
    BEGIN
      TableRelationsMetadata.SETRANGE("Table ID",TableID);
      TableRelationsMetadata.SETRANGE("Field No.",FieldNo);
      TableRelationsMetadata.SETRANGE("Related Table ID",ConfigPackageData."Table ID");
      IF TableRelationsMetadata.FINDFIRST THEN BEGIN
        ConfigPackageDataOtherFields.SETRANGE("Package Code",ConfigPackageData."Package Code");
        ConfigPackageDataOtherFields.SETRANGE("Table ID",ConfigPackageData."Table ID");
        ConfigPackageDataOtherFields.SETRANGE("No.",ConfigPackageData."No.");
        ConfigPackageDataOtherFields.SETRANGE("Field ID",TableRelationsMetadata."Related Field No.");
        ConfigPackageDataOtherFields.FINDFIRST;
        EXIT(ConfigPackageDataOtherFields.Value);
      END;
      EXIT(ConfigPackageData.Value);
    END;

    LOCAL PROCEDURE GetMappingFromPKOfRelatedTable@63(ConfigPackageField@1002 : Record 8616;MappingOldValue@1003 : Text[250]) : Text[250];
    VAR
      ConfigPackageField2@1001 : Record 8616;
      ConfigFieldMapping@1000 : Record 8628;
    BEGIN
      ConfigPackageField2.SETRANGE("Package Code",ConfigPackageField."Package Code");
      ConfigPackageField2.SETRANGE("Table ID",ConfigPackageField."Relation Table ID");
      ConfigPackageField2.SETRANGE("Primary Key",TRUE);
      IF ConfigPackageField2.FINDFIRST THEN
        IF ConfigFieldMapping.GET(
             ConfigPackageField2."Package Code",
             ConfigPackageField2."Table ID",
             ConfigPackageField2."Field ID",
             MappingOldValue)
        THEN
          EXIT(ConfigFieldMapping."New Value");
    END;

    [External]
    PROCEDURE ShowFieldMapping@62(ConfigPackageField@1000 : Record 8616);
    VAR
      ConfigFieldMapping@1001 : Record 8628;
      ConfigFieldMappingPage@1002 : Page 8636;
    BEGIN
      CLEAR(ConfigFieldMappingPage);
      ConfigFieldMapping.FILTERGROUP(2);
      ConfigFieldMapping.SETRANGE("Package Code",ConfigPackageField."Package Code");
      ConfigFieldMapping.SETRANGE("Table ID",ConfigPackageField."Table ID");
      ConfigFieldMapping.SETRANGE("Field ID",ConfigPackageField."Field ID");
      ConfigFieldMapping.FILTERGROUP(0);
      ConfigFieldMappingPage.SETTABLEVIEW(ConfigFieldMapping);
      ConfigFieldMappingPage.RUNMODAL;
    END;

    [External]
    PROCEDURE IsBLOBField@64(TableId@1000 : Integer;FieldId@1001 : Integer) : Boolean;
    VAR
      Field@1002 : Record 2000000041;
    BEGIN
      IF TypeHelper.GetField(TableId,FieldId,Field) THEN
        EXIT(Field.Type = Field.Type::BLOB);
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE EvaluateBLOBToFieldRef@65(VAR ConfigPackageData@1000 : Record 8615;VAR FieldRef@1001 : FieldRef);
    BEGIN
      ConfigPackageData.CALCFIELDS("BLOB Value");
      FieldRef.VALUE := ConfigPackageData."BLOB Value";
    END;

    [External]
    PROCEDURE IsMediaSetField@73(TableId@1000 : Integer;FieldId@1001 : Integer) : Boolean;
    VAR
      Field@1002 : Record 2000000041;
    BEGIN
      IF TypeHelper.GetField(TableId,FieldId,Field) THEN
        EXIT(Field.Type = Field.Type::MediaSet);
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE ImportMediaSetFiles@72(VAR ConfigPackageData@1000 : Record 8615;VAR FieldRef@1001 : FieldRef;DoModify@1010 : Boolean);
    VAR
      TempConfigMediaBuffer@1007 : TEMPORARY Record 8630;
      MediaSetIDConfigPackageData@1005 : Record 8615;
      BlobMediaSetConfigPackageData@1002 : Record 8615;
      BlobInStream@1011 : InStream;
      MediaSetID@1006 : Text;
    BEGIN
      IF NOT CanImportMediaField(ConfigPackageData,FieldRef,DoModify,MediaSetID) THEN
        EXIT;

      MediaSetIDConfigPackageData.SETRANGE("Package Code",ConfigPackageData."Package Code");
      MediaSetIDConfigPackageData.SETRANGE("Table ID",DATABASE::"Config. Media Buffer");
      MediaSetIDConfigPackageData.SETRANGE("Field ID",TempConfigMediaBuffer.FIELDNO("Media Set ID"));
      MediaSetIDConfigPackageData.SETRANGE(Value,MediaSetID);

      IF NOT MediaSetIDConfigPackageData.FINDSET THEN
        EXIT;

      TempConfigMediaBuffer.INIT;
      TempConfigMediaBuffer.INSERT;
      BlobMediaSetConfigPackageData.SETAUTOCALCFIELDS("BLOB Value");

      REPEAT
        BlobMediaSetConfigPackageData.GET(
          MediaSetIDConfigPackageData."Package Code",MediaSetIDConfigPackageData."Table ID",MediaSetIDConfigPackageData."No.",
          TempConfigMediaBuffer.FIELDNO("Media Blob"));
        BlobMediaSetConfigPackageData."BLOB Value".CREATEINSTREAM(BlobInStream);
        TempConfigMediaBuffer."Media Set".IMPORTSTREAM(BlobInStream,'');
        TempConfigMediaBuffer.MODIFY;
      UNTIL MediaSetIDConfigPackageData.NEXT = 0;

      FieldRef.VALUE := FORMAT(TempConfigMediaBuffer."Media Set");
    END;

    [External]
    PROCEDURE IsMediaField@78(TableId@1000 : Integer;FieldId@1001 : Integer) : Boolean;
    VAR
      Field@1002 : Record 2000000041;
    BEGIN
      IF TypeHelper.GetField(TableId,FieldId,Field) THEN
        EXIT(Field.Type = Field.Type::Media);
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE ImportMediaFiles@77(VAR ConfigPackageData@1000 : Record 8615;VAR FieldRef@1001 : FieldRef;DoModify@1010 : Boolean);
    VAR
      TempConfigMediaBuffer@1007 : TEMPORARY Record 8630;
      MediaIDConfigPackageData@1005 : Record 8615;
      BlobMediaConfigPackageData@1002 : Record 8615;
      BlobInStream@1011 : InStream;
      MediaID@1006 : Text;
    BEGIN
      IF NOT CanImportMediaField(ConfigPackageData,FieldRef,DoModify,MediaID) THEN
        EXIT;

      MediaIDConfigPackageData.SETRANGE("Package Code",ConfigPackageData."Package Code");
      MediaIDConfigPackageData.SETRANGE("Table ID",DATABASE::"Config. Media Buffer");
      MediaIDConfigPackageData.SETRANGE("Field ID",TempConfigMediaBuffer.FIELDNO("Media ID"));
      MediaIDConfigPackageData.SETRANGE(Value,MediaID);

      IF NOT MediaIDConfigPackageData.FINDFIRST THEN
        EXIT;

      BlobMediaConfigPackageData.SETAUTOCALCFIELDS("BLOB Value");

      BlobMediaConfigPackageData.GET(
        MediaIDConfigPackageData."Package Code",MediaIDConfigPackageData."Table ID",MediaIDConfigPackageData."No.",
        TempConfigMediaBuffer.FIELDNO("Media Blob"));
      BlobMediaConfigPackageData."BLOB Value".CREATEINSTREAM(BlobInStream);

      TempConfigMediaBuffer.INIT;
      TempConfigMediaBuffer.Media.IMPORTSTREAM(BlobInStream,'');
      TempConfigMediaBuffer.INSERT;

      FieldRef.VALUE := FORMAT(TempConfigMediaBuffer.Media);
    END;

    LOCAL PROCEDURE CanImportMediaField@75(VAR ConfigPackageData@1003 : Record 8615;VAR FieldRef@1002 : FieldRef;DoModify@1001 : Boolean;VAR MediaID@1004 : Text) : Boolean;
    VAR
      RecRef@1000 : RecordRef;
      DummyNotInitializedGuid@1005 : GUID;
    BEGIN
      IF NOT DoModify THEN
        EXIT(FALSE);

      RecRef := FieldRef.RECORD;
      IF RecRef.NUMBER = DATABASE::"Config. Media Buffer" THEN
        EXIT(FALSE);

      MediaID := FORMAT(ConfigPackageData.Value);
      IF (MediaID = FORMAT(DummyNotInitializedGuid)) OR (MediaID = '') THEN
        EXIT(FALSE);

      EXIT(TRUE);
    END;

    LOCAL PROCEDURE GetRecordIDOfRecordError@79(VAR ConfigPackageData@1000 : Record 8615) : Text[250];
    VAR
      RecRef@1001 : RecordRef;
      FieldRef@1002 : FieldRef;
      KeyRef@1004 : KeyRef;
      RecordID@1003 : Text;
      KeyFieldCount@1005 : Integer;
      KeyFieldValNotEmpty@1006 : Boolean;
    BEGIN
      IF NOT ConfigPackageData.FINDSET THEN
        EXIT;

      RecRef.OPEN(ConfigPackageData."Table ID");
      KeyRef := RecRef.KEYINDEX(1);
      FOR KeyFieldCount := 1 TO KeyRef.FIELDCOUNT DO BEGIN
        FieldRef := KeyRef.FIELDINDEX(KeyFieldCount);

        IF NOT ConfigPackageData.GET(ConfigPackageData."Package Code",ConfigPackageData."Table ID",ConfigPackageData."No.",
             FieldRef.NUMBER)
        THEN
          EXIT;

        IF ConfigPackageData.Value <> '' THEN
          KeyFieldValNotEmpty := TRUE;

        IF KeyFieldCount = 1 THEN
          RecordID := RecRef.NAME + ': ' + ConfigPackageData.Value
        ELSE
          RecordID += ', ' + ConfigPackageData.Value;
      END;

      IF NOT KeyFieldValNotEmpty THEN
        EXIT;

      EXIT(COPYSTR(RecordID,1,250));
    END;

    LOCAL PROCEDURE IsTableErrorsExists@83(ConfigPackageTable@1001 : Record 8613) : Boolean;
    VAR
      ConfigPackageError@1000 : Record 8617;
    BEGIN
      IF ConfigPackageTable."Table ID" = 27 THEN BEGIN
        ConfigPackageError.SETRANGE("Package Code",ConfigPackageTable."Package Code");
        ConfigPackageError.SETRANGE("Table ID",ConfigPackageTable."Table ID");
        IF ConfigPackageError.FIND('-') THEN
          REPEAT
            IF STRPOS(ConfigPackageError."Error Text",'is a duplicate item number') > 0 THEN
              EXIT(NOT ConfigPackageError.ISEMPTY);
          UNTIL ConfigPackageError.NEXT = 0;
      END
    END;

    LOCAL PROCEDURE FixIntegrationRecordIds@69();
    VAR
      GraphMgtGeneralTools@1000 : Codeunit 5465;
    BEGIN
      COMMIT;
      GraphMgtGeneralTools.APISetupIfEnabled;
    END;

    PROCEDURE IsFieldMultiRelation@90(TableID@1000 : Integer;FieldID@1001 : Integer) : Boolean;
    VAR
      TableRelationsMetadata@1002 : Record 2000000141;
    BEGIN
      TableRelationsMetadata.SETRANGE("Table ID",TableID);
      TableRelationsMetadata.SETRANGE("Field No.",FieldID);
      EXIT(TableRelationsMetadata.COUNT > 1);
    END;

    [Integration]
    PROCEDURE OnPreProcessPackage@91(VAR ConfigRecordForProcessing@1000 : Record 8632;VAR Subscriber@1001 : Variant);
    BEGIN
    END;

    [Integration]
    PROCEDURE OnPostProcessPackage@92();
    BEGIN
    END;

    BEGIN
    END.
  }
}

