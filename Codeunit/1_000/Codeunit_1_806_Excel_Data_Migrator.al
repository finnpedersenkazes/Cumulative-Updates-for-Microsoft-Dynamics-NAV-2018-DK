OBJECT Codeunit 1806 Excel Data Migrator
{
  OBJECT-PROPERTIES
  {
    Date=26-01-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20348;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      PackageCodeTxt@1000 : TextConst 'DAN=GB.ENU.EXCEL;ENU=GB.ENU.EXCEL';
      PackageNameTxt@1001 : TextConst 'DAN=Excel-dataoverf�rsel;ENU=Excel Data Migration';
      ConfigPackageManagement@1002 : Codeunit 8611;
      ConfigExcelExchange@1003 : Codeunit 8618;
      DataMigratorDescriptionTxt@1004 : TextConst 'DAN=Indl�s fra Excel;ENU=Import from Excel';
      Instruction1Txt@1008 : TextConst 'DAN=1) Hent Excel-skabelonen.;ENU=1) Download the Excel template.';
      Instruction2Txt@1005 : TextConst 'DAN=2) Udfyld skabelonen med dine data.;ENU=2) Fill in the template with your data.';
      Instruction3Txt@1021 : TextConst 'DAN=3) Valgfrit, men vigtigt: Angiv importindstillinger. Disse sikrer, at du kan bruge dine data med det samme.;ENU=3) Optional, but important: Specify import settings. These help ensure that you can use your data right away.';
      Instruction4Txt@1022 : TextConst 'DAN=4) V�lg N�ste for at overf�re din datafil.;ENU=4) Choose Next to upload your data file.';
      ImportingMsg@1007 : TextConst 'DAN=Importerer data...;ENU=Importing Data...';
      ApplyingMsg@1006 : TextConst 'DAN=Udligner data...;ENU=Applying Data...';
      ImportFromExcelTxt@1009 : TextConst 'DAN=Indl�s fra Excel;ENU=Import from Excel';
      ExcelFileExtensionTok@1010 : TextConst 'DAN=*.xlsx;ENU=*.xlsx';
      ExcelValidationErr@1013 : TextConst '@@@=%1 - product name;DAN=Den importerede fil er beskadiget. Den indeholder kolonner, der ikke kan vises i %1.;ENU=The file that you imported is corrupted. It contains columns that cannot be mapped to %1.';
      OpenAdvancedQst@1011 : TextConst 'DAN=Den avancerede konfiguration kr�ver, at du angiver, hvordan databasetabeller er konfigureret. Vi anbefaler, at du kun �bner den avancerede konfiguration, hvis du kender til RapidStart Services.\\Vil du forts�tte?;ENU=The advanced setup experience requires you to specify how database tables are configured. We recommend that you only access the advanced setup if you are familiar with RapidStart Services.\\Do you want to continue?';
      ExcelFileNameTok@1012 : TextConst '@@@="%1 = String generated from current datetime to make sure file names are unique ";DAN=Dataimport_Dynamics365%1.xlsx;ENU=DataImport_Dynamics365%1.xlsx';
      SettingsMissingQst@1014 : TextConst 'DAN=Vent et �jeblik. Du har ikke angivet importindstillinger. For at undg� ekstra arbejde og eventuelle fejl b�r du angive importindstillingerne nu i stedet for at opdatere dataene senere.\\Vil du angive indstillingerne?;ENU=Wait a minute. You have not specified import settings. To avoid extra work and potential errors, we recommend that you specify import settings now, rather than update the data later.\\Do you want to specify the settings?';
      ValidateErrorsBeforeApplyQst@1023 : TextConst 'DAN=Nogle af felterne kan ikke udlignes, fordi der blev fundet fejl i de importerede data.\\Vil du forts�tte?;ENU=Some of the fields will not be applied because errors were found in the imported data.\\Do you want to continue?';

    [Internal]
    PROCEDURE ImportExcelData@2() : Boolean;
    VAR
      FileManagement@1000 : Codeunit 419;
      ServerFile@1005 : Text[250];
    BEGIN
      OnUploadFile(ServerFile);
      IF ServerFile = '' THEN
        ServerFile := COPYSTR(FileManagement.UploadFile(ImportFromExcelTxt,ExcelFileExtensionTok),
            1,MAXSTRLEN(ServerFile));

      IF ServerFile <> '' THEN BEGIN
        ImportExcelDataByFileName(ServerFile);
        EXIT(TRUE);
      END;

      EXIT(FALSE);
    END;

    [Internal]
    PROCEDURE ImportExcelDataByFileName@56(FileName@1000 : Text[250]);
    VAR
      FileManagement@1002 : Codeunit 419;
      Window@1001 : Dialog;
    BEGIN
      Window.OPEN(ImportingMsg);

      FileManagement.ValidateFileExtension(FileName,ExcelFileExtensionTok);
      CreatePackageMetadata;
      ValidateTemplateAndImportData(FileName);

      Window.CLOSE;
    END;

    [Internal]
    PROCEDURE ExportExcelTemplate@4() : Boolean;
    VAR
      FileName@1001 : Text;
      HideDialog@1002 : Boolean;
    BEGIN
      OnDownloadTemplate(HideDialog);
      EXIT(ExportExcelTemplateByFileName(FileName,HideDialog));
    END;

    [Internal]
    PROCEDURE ExportExcelTemplateByFileName@35(VAR FileName@1000 : Text;HideDialog@1001 : Boolean) : Boolean;
    VAR
      ConfigPackageTable@1002 : Record 8613;
    BEGIN
      IF FileName = '' THEN
        FileName :=
          STRSUBSTNO(ExcelFileNameTok,FORMAT(CURRENTDATETIME,0,'<Day,2>_<Month,2>_<Year4>_<Hours24>_<Minutes,2>_<Seconds,2>'));

      CreatePackageMetadata;
      ConfigPackageTable.SETRANGE("Package Code",PackageCodeTxt);
      ConfigExcelExchange.SetHideDialog(HideDialog);
      EXIT(ConfigExcelExchange.ExportExcel(FileName,ConfigPackageTable,FALSE,TRUE));
    END;

    [External]
    PROCEDURE GetPackageCode@5() : Code[20];
    BEGIN
      EXIT(PackageCodeTxt);
    END;

    LOCAL PROCEDURE CreatePackageMetadata@12();
    VAR
      ConfigPackage@1000 : Record 8623;
      ConfigPackageManagement@1009 : Codeunit 8611;
      ApplicationManagement@1010 : Codeunit 1;
    BEGIN
      ConfigPackage.SETRANGE(Code,PackageCodeTxt);
      ConfigPackage.DELETEALL(TRUE);

      ConfigPackageManagement.InsertPackage(ConfigPackage,PackageCodeTxt,PackageNameTxt,FALSE);
      ConfigPackage."Language ID" := ApplicationManagement.ApplicationLanguage;
      ConfigPackage."Product Version" :=
        COPYSTR(ApplicationManagement.ApplicationVersion,1,STRLEN(ConfigPackage."Product Version"));
      ConfigPackage.MODIFY;

      InsertPackageTables;
      InsertPackageFields;
    END;

    LOCAL PROCEDURE InsertPackageTables@32();
    VAR
      ConfigPackageField@1001 : Record 8616;
      DataMigrationSetup@1005 : Record 1806;
    BEGIN
      IF NOT DataMigrationSetup.GET THEN BEGIN
        DataMigrationSetup.INIT;
        DataMigrationSetup.INSERT;
      END;

      InsertPackageTableCustomer(DataMigrationSetup);
      InsertPackageTableVendor(DataMigrationSetup);
      InsertPackageTableItem(DataMigrationSetup);
      InsertPackageTableAccount(DataMigrationSetup);

      ConfigPackageField.SETRANGE("Package Code",PackageCodeTxt);
      ConfigPackageField.MODIFYALL("Include Field",FALSE);
    END;

    LOCAL PROCEDURE InsertPackageFields@197();
    BEGIN
      InsertPackageFieldsCustomer;
      InsertPackageFieldsVendor;
      InsertPackageFieldsItem;
      InsertPackageFieldsAccount;
    END;

    LOCAL PROCEDURE InsertPackageTableCustomer@17(VAR DataMigrationSetup@1002 : Record 1806);
    VAR
      ConfigPackageTable@1001 : Record 8613;
      ConfigTableProcessingRule@1000 : Record 8631;
    BEGIN
      ConfigPackageManagement.InsertPackageTable(ConfigPackageTable,PackageCodeTxt,DATABASE::Customer);
      ConfigPackageTable."Data Template" := DataMigrationSetup."Default Customer Template";
      ConfigPackageTable.MODIFY;
      ConfigPackageManagement.InsertProcessingRuleCustom(
        ConfigTableProcessingRule,ConfigPackageTable,100000,CODEUNIT::"Excel Post Processor");
    END;

    LOCAL PROCEDURE InsertPackageFieldsCustomer@191();
    VAR
      ConfigPackageField@1001 : Record 8616;
    BEGIN
      ConfigPackageField.SETRANGE("Package Code",PackageCodeTxt);
      ConfigPackageField.SETRANGE("Table ID",DATABASE::Customer);
      ConfigPackageField.DELETEALL(TRUE);

      InsertPackageField(DATABASE::Customer,1,1);     // No.
      InsertPackageField(DATABASE::Customer,2,2);     // Name
      InsertPackageField(DATABASE::Customer,3,3);     // Search Name
      InsertPackageField(DATABASE::Customer,5,4);     // Address
      InsertPackageField(DATABASE::Customer,7,5);     // City
      InsertPackageField(DATABASE::Customer,92,6);    // County
      InsertPackageField(DATABASE::Customer,91,7);    // Post Code
      InsertPackageField(DATABASE::Customer,35,8);    // Country/Region Code
      InsertPackageField(DATABASE::Customer,8,9);     // Contact
      InsertPackageField(DATABASE::Customer,9,10);    // Phone No.
      InsertPackageField(DATABASE::Customer,102,11);  // E-Mail
      InsertPackageField(DATABASE::Customer,20,12);   // Credit Limit (LCY)
      InsertPackageField(DATABASE::Customer,21,13);   // Customer Posting Group
      InsertPackageField(DATABASE::Customer,27,14);   // Payment Terms Code
      InsertPackageField(DATABASE::Customer,88,15);   // Gen. Bus. Posting Group
    END;

    LOCAL PROCEDURE InsertPackageTableVendor@16(VAR DataMigrationSetup@1003 : Record 1806);
    VAR
      ConfigPackageTable@1001 : Record 8613;
      ConfigTableProcessingRule@1000 : Record 8631;
    BEGIN
      ConfigPackageManagement.InsertPackageTable(ConfigPackageTable,PackageCodeTxt,DATABASE::Vendor);
      ConfigPackageTable."Data Template" := DataMigrationSetup."Default Vendor Template";
      ConfigPackageTable.MODIFY;
      ConfigPackageManagement.InsertProcessingRuleCustom(
        ConfigTableProcessingRule,ConfigPackageTable,100000,CODEUNIT::"Excel Post Processor");
    END;

    LOCAL PROCEDURE InsertPackageFieldsVendor@192();
    VAR
      ConfigPackageField@1001 : Record 8616;
    BEGIN
      ConfigPackageField.SETRANGE("Package Code",PackageCodeTxt);
      ConfigPackageField.SETRANGE("Table ID",DATABASE::Vendor);
      ConfigPackageField.DELETEALL(TRUE);

      InsertPackageField(DATABASE::Vendor,1,1);     // No.
      InsertPackageField(DATABASE::Vendor,2,2);     // Name
      InsertPackageField(DATABASE::Vendor,3,3);     // Search Name
      InsertPackageField(DATABASE::Vendor,5,4);     // Address
      InsertPackageField(DATABASE::Vendor,7,5);     // City
      InsertPackageField(DATABASE::Vendor,92,6);    // County
      InsertPackageField(DATABASE::Vendor,91,7);    // Post Code
      InsertPackageField(DATABASE::Vendor,35,8);    // Country/Region Code
      InsertPackageField(DATABASE::Vendor,8,9);     // Contact
      InsertPackageField(DATABASE::Vendor,9,10);    // Phone No.
      InsertPackageField(DATABASE::Vendor,102,11);  // E-Mail
      InsertPackageField(DATABASE::Vendor,21,12);   // Vendor Posting Group
      InsertPackageField(DATABASE::Vendor,27,13);   // Payment Terms Code
      InsertPackageField(DATABASE::Vendor,88,14);   // Gen. Bus. Posting Group
    END;

    LOCAL PROCEDURE InsertPackageTableItem@18(VAR DataMigrationSetup@1003 : Record 1806);
    VAR
      ConfigPackageTable@1001 : Record 8613;
      ConfigTableProcessingRule@1004 : Record 8631;
    BEGIN
      ConfigPackageManagement.InsertPackageTable(ConfigPackageTable,PackageCodeTxt,DATABASE::Item);
      ConfigPackageTable."Data Template" := DataMigrationSetup."Default Item Template";
      ConfigPackageTable.MODIFY;
      ConfigPackageManagement.InsertProcessingRuleCustom(
        ConfigTableProcessingRule,ConfigPackageTable,100000,CODEUNIT::"Excel Post Processor")
    END;

    LOCAL PROCEDURE InsertPackageFieldsItem@193();
    VAR
      ConfigPackageField@1001 : Record 8616;
    BEGIN
      ConfigPackageField.SETRANGE("Package Code",PackageCodeTxt);
      ConfigPackageField.SETRANGE("Table ID",DATABASE::Item);
      ConfigPackageField.DELETEALL(TRUE);

      InsertPackageField(DATABASE::Item,1,1);     // No.
      InsertPackageField(DATABASE::Item,3,2);     // Description
      InsertPackageField(DATABASE::Item,4,3);     // Search Description
      InsertPackageField(DATABASE::Item,8,4);     // Base Unit of Measure
      InsertPackageField(DATABASE::Item,18,5);    // Unit Price
      InsertPackageField(DATABASE::Item,22,6);    // Unit Cost
      InsertPackageField(DATABASE::Item,24,7);    // Standard Cost
      InsertPackageField(DATABASE::Item,68,8);    // Inventory
      InsertPackageField(DATABASE::Item,35,9);    // Maximum Inventory
      InsertPackageField(DATABASE::Item,121,10);  // Prevent Negative Inventory
      InsertPackageField(DATABASE::Item,34,11);   // Reorder Point
      InsertPackageField(DATABASE::Item,36,12);   // Reorder Quantity
      InsertPackageField(DATABASE::Item,38,13);   // Unit List Price
      InsertPackageField(DATABASE::Item,41,14);   // Gross Weight
      InsertPackageField(DATABASE::Item,42,15);   // Net Weight
      InsertPackageField(DATABASE::Item,5411,16); // Minimum Order Quantity
      InsertPackageField(DATABASE::Item,5412,17); // Maximum Order Quantity
      InsertPackageField(DATABASE::Item,5413,18); // Safety Stock Quantity
    END;

    LOCAL PROCEDURE InsertPackageField@33(TableNo@1000 : Integer;FieldNo@1001 : Integer;ProcessingOrderNo@1002 : Integer);
    VAR
      ConfigPackageField@1004 : Record 8616;
      RecordRef@1003 : RecordRef;
      FieldRef@1005 : FieldRef;
    BEGIN
      RecordRef.OPEN(TableNo);
      FieldRef := RecordRef.FIELD(FieldNo);

      ConfigPackageManagement.InsertPackageField(ConfigPackageField,PackageCodeTxt,TableNo,
        FieldRef.NUMBER,FieldRef.NAME,FieldRef.CAPTION,TRUE,TRUE,FALSE,FALSE);
      ConfigPackageField.VALIDATE("Processing Order",ProcessingOrderNo);
      ConfigPackageField.MODIFY(TRUE);
    END;

    LOCAL PROCEDURE GetCodeunitNumber@8() : Integer;
    BEGIN
      EXIT(CODEUNIT::"Excel Data Migrator");
    END;

    LOCAL PROCEDURE ValidateTemplateAndImportData@29(FileName@1000 : Text);
    VAR
      TempExcelBuffer@1001 : TEMPORARY Record 370;
      ConfigPackage@1002 : Record 8623;
      ConfigPackageTable@1003 : Record 8613;
      ConfigPackageRecord@1005 : Record 8614;
      ConfigPackageField@1004 : Record 8616;
      ColumnHeaderRow@1006 : Integer;
      ColumnCount@1007 : Integer;
      RecordNo@1008 : Integer;
      FieldID@1009 : ARRAY [250] OF Integer;
      I@1010 : Integer;
    BEGIN
      ConfigPackage.GET(PackageCodeTxt);
      ConfigPackageTable.SETRANGE("Package Code",ConfigPackage.Code);

      ColumnHeaderRow := 3; // Data is stored in the Excel sheets starting from row 3

      IF ConfigPackageTable.FINDSET THEN
        REPEAT
          ConfigPackageField.RESET;

          // Check if Excel file contains data sheets with the supported master tables (Customer, Vendor, Item)
          IF IsTableInExcel(TempExcelBuffer,FileName,ConfigPackageTable) THEN BEGIN
            TempExcelBuffer.ReadSheet;
            // Jump to the Columns' header row
            TempExcelBuffer.SETFILTER("Row No.",'%1..',ColumnHeaderRow);

            ConfigPackageField.SETRANGE("Package Code",PackageCodeTxt);
            ConfigPackageField.SETRANGE("Table ID",ConfigPackageTable."Table ID");

            ColumnCount := 0;

            IF TempExcelBuffer.FINDSET THEN
              REPEAT
                IF TempExcelBuffer."Row No." = ColumnHeaderRow THEN BEGIN // Columns' header row
                  ConfigPackageField.SETRANGE("Field Caption",TempExcelBuffer."Cell Value as Text");

                  // Column can be mapped to a field, data will be imported to NAV
                  IF ConfigPackageField.FINDFIRST THEN BEGIN
                    FieldID[TempExcelBuffer."Column No."] := ConfigPackageField."Field ID";
                    ConfigPackageField."Include Field" := TRUE;
                    ConfigPackageField.MODIFY;
                    ColumnCount += 1;
                  END ELSE // Error is thrown when the template is corrupted (i.e., there are columns in Excel file that cannot be mapped to NAV)
                    ERROR(ExcelValidationErr,PRODUCTNAME.SHORT);
                END ELSE BEGIN // Read data row by row
                  // A record is created with every new row
                  ConfigPackageManagement.InitPackageRecord(ConfigPackageRecord,PackageCodeTxt,
                    ConfigPackageTable."Table ID");
                  RecordNo := ConfigPackageRecord."No.";
                  IF ConfigPackageTable."Table ID" = 15 THEN BEGIN
                    FOR I := 1 TO ColumnCount DO
                      IF TempExcelBuffer.GET(TempExcelBuffer."Row No.",I) THEN // Mapping for Account fields
                        InsertAccountsFieldData(ConfigPackageTable."Table ID",RecordNo,FieldID[I],TempExcelBuffer."Cell Value as Text")
                  END ELSE BEGIN
                    FOR I := 1 TO ColumnCount DO
                      IF TempExcelBuffer.GET(TempExcelBuffer."Row No.",I) THEN
                        // Fields are populated in the record created
                        InsertFieldData(
                          ConfigPackageTable."Table ID",RecordNo,FieldID[I],TempExcelBuffer."Cell Value as Text")
                      ELSE
                        InsertFieldData(
                          ConfigPackageTable."Table ID",RecordNo,FieldID[I],'');
                  END;

                  // Go to next line
                  TempExcelBuffer.SETFILTER("Row No.",'%1..',TempExcelBuffer."Row No." + 1);
                END;
              UNTIL TempExcelBuffer.NEXT = 0;

            TempExcelBuffer.RESET;
            TempExcelBuffer.DELETEALL;
            TempExcelBuffer.CloseBook;
          END ELSE BEGIN
            // Table is removed from the configuration package because it doen't exist in the Excel file
            TempExcelBuffer.QuitExcel;
            ConfigPackageTable.DELETE(TRUE);
          END;
        UNTIL ConfigPackageTable.NEXT = 0;
    END;

    [TryFunction]
    LOCAL PROCEDURE IsTableInExcel@40(VAR TempExcelBuffer@1004 : TEMPORARY Record 370;FileName@1003 : Text;ConfigPackageTable@1001 : Record 8613);
    BEGIN
      ConfigPackageTable.CALCFIELDS("Table Name","Table Caption");

      IF NOT TryOpenExcel(TempExcelBuffer,FileName,ConfigPackageTable."Table Name") THEN
        TryOpenExcel(TempExcelBuffer,FileName,ConfigPackageTable."Table Caption");
    END;

    [TryFunction]
    LOCAL PROCEDURE TryOpenExcel@34(VAR TempExcelBuffer@1004 : TEMPORARY Record 370;FileName@1003 : Text;SheetName@1000 : Text[250]);
    BEGIN
      TempExcelBuffer.OpenBook(FileName,SheetName);
    END;

    LOCAL PROCEDURE InsertFieldData@69(TableNo@1000 : Integer;RecordNo@1001 : Integer;FieldNo@1002 : Integer;Value@1003 : Text[250]);
    VAR
      ConfigPackageData@1004 : Record 8615;
    BEGIN
      ConfigPackageManagement.InsertPackageData(ConfigPackageData,PackageCodeTxt,
        TableNo,RecordNo,FieldNo,Value,FALSE);
    END;

    LOCAL PROCEDURE CreateDataMigrationEntites@24(VAR DataMigrationEntity@1002 : Record 1801);
    VAR
      ConfigPackage@1001 : Record 8623;
      ConfigPackageTable@1000 : Record 8613;
    BEGIN
      ConfigPackage.GET(PackageCodeTxt);
      ConfigPackageTable.SETRANGE("Package Code",ConfigPackage.Code);
      DataMigrationEntity.DELETEALL;

      WITH ConfigPackageTable DO
        IF FINDSET THEN
          REPEAT
            CALCFIELDS("No. of Package Records");
            DataMigrationEntity.InsertRecord("Table ID","No. of Package Records");
          UNTIL NEXT = 0;
    END;

    [EventSubscriber(Table,1800,OnRegisterDataMigrator)]
    LOCAL PROCEDURE RegisterExcelDataMigrator@3(VAR Sender@1000 : Record 1800);
    BEGIN
      Sender.RegisterDataMigrator(GetCodeunitNumber,DataMigratorDescriptionTxt);
    END;

    [EventSubscriber(Table,1800,OnHasSettings)]
    LOCAL PROCEDURE HasSettings@15(VAR Sender@1000 : Record 1800;VAR HasSettings@1001 : Boolean);
    BEGIN
      IF Sender."No." <> GetCodeunitNumber THEN
        EXIT;

      HasSettings := TRUE;
    END;

    [EventSubscriber(Table,1800,OnOpenSettings)]
    LOCAL PROCEDURE OpenSettings@11(VAR Sender@1000 : Record 1800;VAR Handled@1001 : Boolean);
    BEGIN
      IF Sender."No." <> GetCodeunitNumber THEN
        EXIT;

      PAGE.RUNMODAL(PAGE::"Data Migration Settings");
      Handled := TRUE;
    END;

    [EventSubscriber(Table,1800,OnValidateSettings)]
    LOCAL PROCEDURE ValidateSettings@26(VAR Sender@1000 : Record 1800);
    VAR
      DataMigrationSetup@1002 : Record 1806;
    BEGIN
      IF Sender."No." <> GetCodeunitNumber THEN
        EXIT;

      DataMigrationSetup.GET;
      IF (DataMigrationSetup."Default Customer Template" = '') AND
         (DataMigrationSetup."Default Vendor Template" = '') AND
         (DataMigrationSetup."Default Item Template" = '')
      THEN
        IF CONFIRM(SettingsMissingQst,TRUE) THEN
          PAGE.RUNMODAL(PAGE::"Data Migration Settings");
    END;

    [EventSubscriber(Table,1800,OnHasTemplate)]
    LOCAL PROCEDURE HasTemplate@13(VAR Sender@1000 : Record 1800;VAR HasTemplate@1001 : Boolean);
    BEGIN
      IF Sender."No." <> GetCodeunitNumber THEN
        EXIT;

      HasTemplate := TRUE;
    END;

    [EventSubscriber(Table,1800,OnGetInstructions)]
    LOCAL PROCEDURE GetInstructions@9(VAR Sender@1000 : Record 1800;VAR Instructions@1001 : Text;VAR Handled@1002 : Boolean);
    VAR
      CRLF@1003 : Text[2];
    BEGIN
      IF Sender."No." <> GetCodeunitNumber THEN
        EXIT;

      CRLF := '';
      CRLF[1] := 13;
      CRLF[2] := 10;

      Instructions := Instruction1Txt + CRLF + Instruction2Txt + CRLF + Instruction3Txt + CRLF + Instruction4Txt;

      Handled := TRUE;
    END;

    [EventSubscriber(Table,1800,OnDownloadTemplate)]
    LOCAL PROCEDURE DownloadTemplate@1(VAR Sender@1000 : Record 1800;VAR Handled@1001 : Boolean);
    BEGIN
      IF Sender."No." <> GetCodeunitNumber THEN
        EXIT;

      IF ExportExcelTemplate THEN BEGIN
        Handled := TRUE;
        EXIT;
      END;
    END;

    [EventSubscriber(Table,1800,OnDataImport)]
    LOCAL PROCEDURE ImportData@6(VAR Sender@1000 : Record 1800;VAR Handled@1001 : Boolean);
    BEGIN
      IF Sender."No." <> GetCodeunitNumber THEN
        EXIT;

      IF ImportExcelData THEN BEGIN
        Handled := TRUE;
        EXIT;
      END;

      Handled := FALSE;
    END;

    [EventSubscriber(Table,1800,OnSelectDataToApply)]
    LOCAL PROCEDURE SelectDataToApply@10(VAR Sender@1000 : Record 1800;VAR DataMigrationEntity@1001 : Record 1801;VAR Handled@1002 : Boolean);
    BEGIN
      IF Sender."No." <> GetCodeunitNumber THEN
        EXIT;

      CreateDataMigrationEntites(DataMigrationEntity);

      Handled := TRUE;
    END;

    [EventSubscriber(Table,1800,OnHasAdvancedApply)]
    LOCAL PROCEDURE HasAdvancedApply@20(VAR Sender@1000 : Record 1800;VAR HasAdvancedApply@1001 : Boolean);
    BEGIN
      IF Sender."No." <> GetCodeunitNumber THEN
        EXIT;

      HasAdvancedApply := FALSE;
    END;

    [EventSubscriber(Table,1800,OnOpenAdvancedApply)]
    LOCAL PROCEDURE OpenAdvancedApply@19(VAR Sender@1000 : Record 1800;VAR DataMigrationEntity@1001 : Record 1801;VAR Handled@1003 : Boolean);
    VAR
      ConfigPackage@1002 : Record 8623;
    BEGIN
      IF Sender."No." <> GetCodeunitNumber THEN
        EXIT;

      IF NOT CONFIRM(OpenAdvancedQst,TRUE) THEN
        EXIT;

      ConfigPackage.GET(PackageCodeTxt);
      PAGE.RUNMODAL(PAGE::"Config. Package Card",ConfigPackage);

      CreateDataMigrationEntites(DataMigrationEntity);
      Handled := TRUE;
    END;

    [EventSubscriber(Table,1800,OnApplySelectedData)]
    LOCAL PROCEDURE ApplySelectedData@7(VAR Sender@1000 : Record 1800;VAR DataMigrationEntity@1001 : Record 1801;VAR Handled@1003 : Boolean);
    VAR
      ConfigPackage@1006 : Record 8623;
      ConfigPackageTable@1005 : Record 8613;
      TempConfigPackageTable@1008 : TEMPORARY Record 8613;
      ConfigPackageManagement@1002 : Codeunit 8611;
      Window@1004 : Dialog;
    BEGIN
      IF Sender."No." <> GetCodeunitNumber THEN
        EXIT;

      ConfigPackage.GET(PackageCodeTxt);
      ConfigPackageTable.SETRANGE("Package Code",ConfigPackage.Code);

      // Validate the package
      ConfigPackageManagement.SetHideDialog(TRUE);
      ConfigPackageManagement.CleanPackageErrors(PackageCodeTxt,'');
      DataMigrationEntity.SETRANGE(Selected,TRUE);
      IF DataMigrationEntity.FINDSET THEN
        REPEAT
          ConfigPackageTable.SETRANGE("Table ID",DataMigrationEntity."Table ID");
          ConfigPackageManagement.ValidatePackageRelations(ConfigPackageTable,TempConfigPackageTable,TRUE);
        UNTIL DataMigrationEntity.NEXT = 0;
      DataMigrationEntity.SETRANGE(Selected);
      ConfigPackageTable.SETRANGE("Table ID");
      ConfigPackageManagement.SetHideDialog(FALSE);
      ConfigPackage.CALCFIELDS("No. of Errors");
      ConfigPackageManagement.CleanPackageErrors(PackageCodeTxt,'');

      IF ConfigPackage."No. of Errors" <> 0 THEN
        IF NOT CONFIRM(ValidateErrorsBeforeApplyQst) THEN
          EXIT;

      IF DataMigrationEntity.FINDSET THEN
        REPEAT
          IF NOT DataMigrationEntity.Selected THEN BEGIN
            ConfigPackageTable.GET(PackageCodeTxt,DataMigrationEntity."Table ID");
            ConfigPackageTable.DELETE(TRUE);
          END;
        UNTIL DataMigrationEntity.NEXT = 0;

      Window.OPEN(ApplyingMsg);
      RemoveDemoData(ConfigPackageTable);// Remove the demo data before importing Accounts(if any)
      ConfigPackageManagement.ApplyPackage(ConfigPackage,ConfigPackageTable,TRUE);
      Window.CLOSE;
      Handled := TRUE;
    END;

    [EventSubscriber(Table,1800,OnHasErrors)]
    LOCAL PROCEDURE HasErrors@22(VAR Sender@1000 : Record 1800;VAR HasErrors@1001 : Boolean);
    VAR
      ConfigPackage@1002 : Record 8623;
    BEGIN
      IF Sender."No." <> GetCodeunitNumber THEN
        EXIT;

      ConfigPackage.GET(PackageCodeTxt);
      ConfigPackage.CALCFIELDS("No. of Errors");
      HasErrors := ConfigPackage."No. of Errors" <> 0;
    END;

    [EventSubscriber(Table,1800,OnShowErrors)]
    LOCAL PROCEDURE ShowErrors@21(VAR Sender@1000 : Record 1800;VAR Handled@1001 : Boolean);
    VAR
      ConfigPackageError@1002 : Record 8617;
    BEGIN
      IF Sender."No." <> GetCodeunitNumber THEN
        EXIT;

      ConfigPackageError.SETRANGE("Package Code",PackageCodeTxt);
      PAGE.RUNMODAL(PAGE::"Config. Package Errors",ConfigPackageError);
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnUploadFile@23(VAR ServerFileName@1000 : Text);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnDownloadTemplate@31(VAR HideDialog@1000 : Boolean);
    BEGIN
    END;

    LOCAL PROCEDURE InsertPackageTableAccount@14(VAR DataMigrationSetup@1002 : Record 1806);
    VAR
      ConfigPackageTable@1001 : Record 8613;
      ConfigTableProcessingRule@1000 : Record 8631;
    BEGIN
      ConfigPackageManagement.InsertPackageTable(ConfigPackageTable,PackageCodeTxt,DATABASE::"G/L Account");
      ConfigPackageTable."Data Template" := DataMigrationSetup."Default Account Template";
      ConfigPackageTable.MODIFY;
      ConfigPackageManagement.InsertProcessingRuleCustom(
        ConfigTableProcessingRule,ConfigPackageTable,100000,CODEUNIT::"Excel Post Processor");
    END;

    LOCAL PROCEDURE InsertPackageFieldsAccount@28();
    VAR
      ConfigPackageField@1001 : Record 8616;
    BEGIN
      ConfigPackageField.SETRANGE("Package Code",PackageCodeTxt);
      ConfigPackageField.SETRANGE("Table ID",DATABASE::"G/L Account");
      ConfigPackageField.DELETEALL(TRUE);

      InsertPackageField(DATABASE::"G/L Account",1,1);     // No.
      InsertPackageField(DATABASE::"G/L Account",2,2);     // Name
      InsertPackageField(DATABASE::"G/L Account",3,3);     // Search Name
      InsertPackageField(DATABASE::"G/L Account",4,4);     // Account Type
      InsertPackageField(DATABASE::"G/L Account",8,5);     // Account Category
      InsertPackageField(DATABASE::"G/L Account",9,6);     // Income/Balance
      InsertPackageField(DATABASE::"G/L Account",10,7);    // Debit/Credit
      InsertPackageField(DATABASE::"G/L Account",13,8);    // Blocked
      InsertPackageField(DATABASE::"G/L Account",43,9);   // Gen. Posting Type
      InsertPackageField(DATABASE::"G/L Account",44,10);   // Gen. Bus. Posting Group
      InsertPackageField(DATABASE::"G/L Account",45,11);   // Gen. Prod. Posting Group
      InsertPackageField(DATABASE::"G/L Account",80,12);   // Account Subcategory Entry No.
    END;

    LOCAL PROCEDURE RemoveDemoData@25(VAR ConfigPackageTable@1002 : Record 8613);
    VAR
      ConfigPackageData@1001 : Record 8615;
      ConfigPackageRecord@1000 : Record 8614;
    BEGIN
      IF ConfigPackageTable.GET(PackageCodeTxt,DATABASE::"G/L Account") THEN BEGIN
        ConfigPackageRecord.SETRANGE("Package Code",ConfigPackageTable."Package Code");
        ConfigPackageRecord.SETRANGE("Table ID",ConfigPackageTable."Table ID");
        IF ConfigPackageRecord.FINDFIRST THEN BEGIN
          ConfigPackageData.SETRANGE("Package Code",ConfigPackageRecord."Package Code");
          ConfigPackageData.SETRANGE("Table ID",ConfigPackageRecord."Table ID");
          IF ConfigPackageData.FINDFIRST THEN
            CODEUNIT.RUN(CODEUNIT::"Data Migration Del G/L Account");
        END;
      END;
    END;

    LOCAL PROCEDURE InsertAccountsFieldData@36(TableNo@1000 : Integer;RecordNo@1001 : Integer;FieldNo@1002 : Integer;Value@1003 : Text[250]);
    VAR
      GLAccount@1005 : Record 15;
    BEGIN
      IF FieldNo = 4 THEN BEGIN
        IF Value = '0' THEN
          InsertFieldData(TableNo,RecordNo,FieldNo,FORMAT(GLAccount."Account Type"::Posting))
        ELSE
          IF Value = '1' THEN
            InsertFieldData(TableNo,RecordNo,FieldNo,FORMAT(GLAccount."Account Type"::Heading))
          ELSE
            IF Value = '2' THEN
              InsertFieldData(TableNo,RecordNo,FieldNo,FORMAT(GLAccount."Account Type"::Total))
            ELSE
              IF Value = '3' THEN
                InsertFieldData(TableNo,RecordNo,FieldNo,FORMAT(GLAccount."Account Type"::"Begin-Total"))
              ELSE
                IF Value = '4' THEN
                  InsertFieldData(TableNo,RecordNo,FieldNo,FORMAT(GLAccount."Account Type"::"End-Total"))
      END ELSE
        IF FieldNo = 8 THEN BEGIN
          IF Value = '0' THEN
            InsertFieldData(TableNo,RecordNo,FieldNo,FORMAT(GLAccount."Account Category"::" "))
          ELSE
            IF Value = '1' THEN
              InsertFieldData(TableNo,RecordNo,FieldNo,FORMAT(GLAccount."Account Category"::Assets))
            ELSE
              IF Value = '2' THEN
                InsertFieldData(TableNo,RecordNo,FieldNo,FORMAT(GLAccount."Account Category"::Liabilities))
              ELSE
                IF Value = '3' THEN
                  InsertFieldData(TableNo,RecordNo,FieldNo,FORMAT(GLAccount."Account Category"::Equity))
                ELSE
                  IF Value = '4' THEN
                    InsertFieldData(TableNo,RecordNo,FieldNo,FORMAT(GLAccount."Account Category"::Income))
                  ELSE
                    IF Value = '5' THEN
                      InsertFieldData(TableNo,RecordNo,FieldNo,FORMAT(GLAccount."Account Category"::"Cost of Goods Sold"))
                    ELSE
                      IF Value = '6' THEN
                        InsertFieldData(TableNo,RecordNo,FieldNo,FORMAT(GLAccount."Account Category"::Expense))
        END ELSE
          IF FieldNo = 9 THEN BEGIN
            IF Value = '0' THEN
              InsertFieldData(TableNo,RecordNo,FieldNo,FORMAT(GLAccount."Income/Balance"::"Income Statement"))
            ELSE
              IF Value = '1' THEN
                InsertFieldData(TableNo,RecordNo,FieldNo,FORMAT(GLAccount."Income/Balance"::"Balance Sheet"))
          END ELSE
            IF FieldNo = 10 THEN BEGIN
              IF Value = '0' THEN
                InsertFieldData(TableNo,RecordNo,FieldNo,FORMAT(GLAccount."Debit/Credit"::Both))
              ELSE
                IF Value = '1' THEN
                  InsertFieldData(TableNo,RecordNo,FieldNo,FORMAT(GLAccount."Debit/Credit"::Debit))
                ELSE
                  IF Value = '2' THEN
                    InsertFieldData(TableNo,RecordNo,FieldNo,FORMAT(GLAccount."Debit/Credit"::Credit))
            END ELSE
              IF FieldNo = 43 THEN BEGIN
                IF Value = '0' THEN
                  InsertFieldData(TableNo,RecordNo,FieldNo,FORMAT(GLAccount."Gen. Posting Type"::" "))
                ELSE
                  IF Value = '1' THEN
                    InsertFieldData(TableNo,RecordNo,FieldNo,FORMAT(GLAccount."Gen. Posting Type"::Purchase))
                  ELSE
                    IF Value = '2' THEN
                      InsertFieldData(TableNo,RecordNo,FieldNo,FORMAT(GLAccount."Gen. Posting Type"::Sale))
              END ELSE
                InsertFieldData(TableNo,RecordNo,FieldNo,Value)
    END;

    BEGIN
    END.
  }
}

