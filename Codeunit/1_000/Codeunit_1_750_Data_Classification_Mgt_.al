OBJECT Codeunit 1750 Data Classification Mgt.
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      CountryRegion@1017 : Record 9;
      CountryCodeFilter@1014 : Text;
      ImportTitleTxt@1002 : TextConst 'DAN=Vëlg Excel-regnearket, hvor der er tilfõjet dataklassificeringer.;ENU=Choose the Excel worksheet where data classifications have been added.';
      DataSensitivityOptionStringTxt@1003 : TextConst '@@@=It needs to be translated as the field Data Sensitivity on Page 1751 Data Classification WorkSheet and field Data Sensitivity of Table 1180 Data Sensitivity Entities;DAN=Ikke klassificerede,Fõlsomme,Personlige,Virksomhedens fortrolige,Normal;ENU=Unclassified,Sensitive,Personal,Company Confidential,Normal';
      DataClassNotifActionTxt@1004 : TextConst 'DAN=èbn guiden Dataklassificering;ENU=Open Data Classification Guide';
      DataClassNotifMessageMsg@1005 : TextConst '@@@="%1=Data Subject";DAN=Det lader til, at du har %1 i EU. Har du klassificeret dataene? Vi kan hjëlpe dig med dette.;ENU=Looks like you have %1 in the EU. Have you classified your data? We can help you do that.';
      ExcelFileNameTxt@1001 : TextConst 'DAN=Klassificeringer.xlsx;ENU=Classifications.xlsx';
      CustomerFilterTxt@1009 : TextConst '@@@={Locked};DAN="WHERE(Partner Type=FILTER(Person))";ENU="WHERE(Partner Type=FILTER(Person))"';
      VendorFilterTxt@1008 : TextConst '@@@={Locked};DAN="WHERE(Partner Type=FILTER(Person))";ENU="WHERE(Partner Type=FILTER(Person))"';
      ContactFilterTxt@1007 : TextConst '@@@={Locked};DAN="WHERE(Type=FILTER(Person))";ENU="WHERE(Type=FILTER(Person))"';
      ResourceFilterTxt@1006 : TextConst '@@@={Locked};DAN="WHERE(Type=FILTER(Person))";ENU="WHERE(Type=FILTER(Person))"';
      SyncFieldsInFieldTableMsg@1010 : TextConst '@@@="%1=Number of days";DAN=Felterne er %1 dage gamle.;ENU=Your fields are %1 days old.';
      SyncAllFieldsTxt@1011 : TextConst 'DAN=Synkroniser alle felter;ENU=Synchronize all fields';
      UnclassifiedFieldsExistMsg@1013 : TextConst 'DAN=Du har ikke-klassificerede felter, der krëver din opmërksomhed.;ENU=You have unclassified fields that require your attention.';
      OpenWorksheetActionLbl@1012 : TextConst 'DAN=èbn regneark;ENU=Open worksheet';
      VendorsTok@1018 : TextConst 'DAN=kreditorer;ENU=vendors';
      CustomersTok@1019 : TextConst 'DAN=debitorer;ENU=customers';
      ContactsTok@1020 : TextConst 'DAN=kontakter;ENU=contacts';
      EmployeesTok@1021 : TextConst 'DAN=medarbejdere;ENU=employees';
      ResourcesTok@1022 : TextConst 'DAN=ressourcer;ENU=resources';
      DontShowAgainTok@1023 : TextConst 'DAN=Vis ikke dette igen;ENU=Don''t show me again';
      WrongFormatExcelFileErr@1025 : TextConst 'DAN=Det lader til, at det angivne Excel-regneark ikke er formateret korrekt.;ENU=Looks like the Excel worksheet you provided is not formatted correctly.';
      WrongSensitivityValueErr@1024 : TextConst '@@@="%1=Given Sensitivity %2=Available Options";DAN=%1 er ikke en gyldig klassificering. Klassificeringer kan vëre %2.;ENU=%1 is not a valid classification. Classifications can be %2.';
      LegalDisclaimerTxt@1016 : TextConst 'DAN=Microsoft tilbyder kun denne funktion til dataklassificering for at gõre tingene nemmere for dig. Du har selv ansvaret for at klassificere dataene korrekt og overholde de love og regler, der gëlder for dig. Microsoft fraskriver sig ethvert ansvar i forbindelse med krav vedrõrende din klassificering af dataene.;ENU=Microsoft is providing this Data Classification feature as a matter of convenience only. It''s your responsibility to classify the data appropriately and comply with any laws and regulations that are applicable to you. Microsoft disclaims all responsibility towards any claims related to your classification of the data.';

    PROCEDURE FillDataSensitivityTable@12();
    VAR
      Field@1000 : Record 2000000041;
      DataSensitivity@1001 : Record 2000000159;
      FieldsSyncStatus@1002 : Record 1750;
    BEGIN
      Field.SETRANGE(Enabled,TRUE);
      Field.SETFILTER(ObsoleteState,'<>%1',Field.ObsoleteState::Removed);
      Field.SETFILTER(
        DataClassification,
        STRSUBSTNO('%1|%2|%3',
          Field.DataClassification::CustomerContent,
          Field.DataClassification::EndUserIdentifiableInformation,
          Field.DataClassification::EndUserPseudonymousIdentifiers));
      Field.FINDSET;
      REPEAT
        DataSensitivity.INIT;
        DataSensitivity."Company Name" := COMPANYNAME;
        DataSensitivity."Table No" := Field.TableNo;
        DataSensitivity."Field No" := Field."No.";
        DataSensitivity."Data Sensitivity" := DataSensitivity."Data Sensitivity"::Unclassified;
        DataSensitivity.INSERT;
      UNTIL Field.NEXT = 0;
      IF FieldsSyncStatus.GET THEN BEGIN
        FieldsSyncStatus."Last Sync Date Time" := CURRENTDATETIME;
        FieldsSyncStatus.MODIFY;
      END ELSE BEGIN
        FieldsSyncStatus."Last Sync Date Time" := CURRENTDATETIME;
        FieldsSyncStatus.INSERT;
      END;
    END;

    PROCEDURE ImportExcelSheet@3();
    VAR
      TempExcelBuffer@1002 : TEMPORARY Record 370;
      DataSensitivity@1013 : Record 2000000159;
      TypeHelper@1000 : Codeunit 10;
      FileManagement@1017 : Codeunit 419;
      DataClassificationWorksheet@1003 : Page 1751;
      ExcelStream@1007 : InStream;
      RecordRef@1016 : RecordRef;
      FieldRef@1014 : FieldRef;
      FileName@1001 : Text;
      Class@1015 : Integer;
      TableNoColumn@1004 : Integer;
      FieldNoColumn@1005 : Integer;
      ClassColumn@1006 : Integer;
      Rows@1009 : Integer;
      Columns@1018 : Integer;
      Index@1010 : Integer;
      TableNo@1011 : Integer;
      FieldNo@1012 : Integer;
      ShouldUploadFile@1008 : Boolean;
    BEGIN
      DataSensitivity.SETRANGE("Company Name",COMPANYNAME);
      IF DataSensitivity.ISEMPTY THEN
        FillDataSensitivityTable;

      ShouldUploadFile := TRUE;
      OnUploadExcelSheet(TempExcelBuffer,ShouldUploadFile);
      IF ShouldUploadFile THEN BEGIN
        FileName := '';
        UPLOADINTOSTREAM(
          ImportTitleTxt,
          '',
          FileManagement.GetToFilterText('',ExcelFileNameTxt),
          FileName,
          ExcelStream);

        IF FileName = '' THEN
          ERROR('');
        TempExcelBuffer.OpenBookStream(ExcelStream,DataClassificationWorksheet.CAPTION);
        TempExcelBuffer.ReadSheet;
      END;

      IF TempExcelBuffer.FINDLAST THEN;

      Rows := TempExcelBuffer."Row No.";
      Columns := TempExcelBuffer."Column No.";
      IF (Rows < 2) OR (Columns < 6) THEN
        ERROR(WrongFormatExcelFileErr);

      TableNoColumn := 1;
      FieldNoColumn := 2;
      ClassColumn := 6;

      FOR Index := 2 TO Rows DO
        IF TempExcelBuffer.GET(Index,TableNoColumn) THEN BEGIN
          EVALUATE(TableNo,TempExcelBuffer."Cell Value as Text");

          IF TempExcelBuffer.GET(Index,FieldNoColumn) THEN BEGIN;
            EVALUATE(FieldNo,TempExcelBuffer."Cell Value as Text");

            IF TempExcelBuffer.GET(Index,ClassColumn) THEN
              IF DataSensitivity.GET(COMPANYNAME,TableNo,FieldNo) THEN BEGIN
                Class := TypeHelper.GetOptionNo(TempExcelBuffer."Cell Value as Text",DataSensitivityOptionStringTxt);
                IF Class < 0 THEN BEGIN
                  // Try the English version
                  RecordRef.OPEN(DATABASE::"Data Sensitivity");
                  FieldRef := RecordRef.FIELD(DataSensitivity.FIELDNO("Data Sensitivity"));
                  Class := TypeHelper.GetOptionNo(TempExcelBuffer."Cell Value as Text",FieldRef.OPTIONSTRING);
                  RecordRef.CLOSE;
                END;
                IF Class < 0 THEN
                  ERROR(STRSUBSTNO(WrongSensitivityValueErr,TempExcelBuffer."Cell Value as Text",DataSensitivityOptionStringTxt));
                IF Class <> DataSensitivity."Data Sensitivity"::Unclassified THEN BEGIN
                  DataSensitivity.VALIDATE("Data Sensitivity",Class);
                  DataSensitivity.VALIDATE("Last Modified By",USERSECURITYID);
                  DataSensitivity.VALIDATE("Last Modified",CURRENTDATETIME);
                  DataSensitivity.MODIFY(TRUE);
                END;
              END;
          END;
        END;

      TempExcelBuffer.CloseBook;
    END;

    PROCEDURE ExportToExcelSheet@16();
    VAR
      TempExcelBuffer@1001 : TEMPORARY Record 370;
      DataSensitivity@1000 : Record 2000000159;
      DataClassificationWorksheet@1002 : Page 1751;
      ShouldOpenFile@1003 : Boolean;
    BEGIN
      DataSensitivity.SETRANGE("Company Name",COMPANYNAME);
      IF NOT DataSensitivity.FINDSET THEN
        FillDataSensitivityTable;

      TempExcelBuffer.CreateNewBook(DataClassificationWorksheet.CAPTION);
      TempExcelBuffer.NewRow;
      TempExcelBuffer.AddColumn(
        DataSensitivity.FIELDNAME("Table No"),FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
      TempExcelBuffer.AddColumn(
        DataSensitivity.FIELDNAME("Field No"),FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
      TempExcelBuffer.AddColumn(
        DataSensitivity.FIELDNAME("Table Caption"),FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
      TempExcelBuffer.AddColumn(
        DataSensitivity.FIELDNAME("Field Caption"),FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
      TempExcelBuffer.AddColumn(
        DataSensitivity.FIELDNAME("Field Type"),FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
      TempExcelBuffer.AddColumn(
        DataSensitivity.FIELDNAME("Data Sensitivity"),FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
      REPEAT
        DataSensitivity.CALCFIELDS("Table Caption");
        DataSensitivity.CALCFIELDS("Field Caption");
        DataSensitivity.CALCFIELDS("Field Type");
        IF (DataSensitivity."Table Caption" <> '') AND (DataSensitivity."Field Caption" <> '') THEN BEGIN
          TempExcelBuffer.NewRow;
          TempExcelBuffer.AddColumn(
            DataSensitivity."Table No",FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Number);
          TempExcelBuffer.AddColumn(
            DataSensitivity."Field No",FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Number);
          TempExcelBuffer.AddColumn(
            DataSensitivity."Table Caption",FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
          TempExcelBuffer.AddColumn(
            DataSensitivity."Field Caption",FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
          CASE DataSensitivity."Field Type" OF
            DataSensitivity."Field Type"::BigInteger:
              TempExcelBuffer.AddColumn(
                'BigInteger',FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
            DataSensitivity."Field Type"::Binary:
              TempExcelBuffer.AddColumn(
                'Binary',FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
            DataSensitivity."Field Type"::BLOB:
              TempExcelBuffer.AddColumn(
                'BLOB',FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
            DataSensitivity."Field Type"::Boolean:
              TempExcelBuffer.AddColumn(
                'Boolean',FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
            DataSensitivity."Field Type"::Code:
              TempExcelBuffer.AddColumn(
                'Code',FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
            DataSensitivity."Field Type"::Date:
              TempExcelBuffer.AddColumn(
                'Date',FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
            DataSensitivity."Field Type"::DateFormula:
              TempExcelBuffer.AddColumn(
                'DateFormula',FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
            DataSensitivity."Field Type"::DateTime:
              TempExcelBuffer.AddColumn(
                'DateTime',FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
            DataSensitivity."Field Type"::Decimal:
              TempExcelBuffer.AddColumn(
                'Decimal',FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
            DataSensitivity."Field Type"::Duration:
              TempExcelBuffer.AddColumn(
                'Duration',FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
            DataSensitivity."Field Type"::GUID:
              TempExcelBuffer.AddColumn(
                'GUID',FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
            DataSensitivity."Field Type"::Integer:
              TempExcelBuffer.AddColumn(
                'Integer',FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
            DataSensitivity."Field Type"::Media:
              TempExcelBuffer.AddColumn(
                'Media',FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
            DataSensitivity."Field Type"::MediaSet:
              TempExcelBuffer.AddColumn(
                'MediaSet',FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
            DataSensitivity."Field Type"::OemCode:
              TempExcelBuffer.AddColumn(
                'OemCode',FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
            DataSensitivity."Field Type"::OemText:
              TempExcelBuffer.AddColumn(
                'OemText',FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
            DataSensitivity."Field Type"::Option:
              TempExcelBuffer.AddColumn(
                'Option',FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
            DataSensitivity."Field Type"::RecordID:
              TempExcelBuffer.AddColumn(
                'RecordID',FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
            DataSensitivity."Field Type"::TableFilter:
              TempExcelBuffer.AddColumn(
                'TableFilter',FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
            DataSensitivity."Field Type"::Text:
              TempExcelBuffer.AddColumn(
                'Text',FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
            DataSensitivity."Field Type"::Time:
              TempExcelBuffer.AddColumn(
                'Time',FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
          END;
          TempExcelBuffer.AddColumn(
            DataSensitivity."Data Sensitivity",FALSE,'',FALSE,FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
        END;
      UNTIL DataSensitivity.NEXT = 0;

      TempExcelBuffer.WriteSheet(DataClassificationWorksheet.CAPTION,COMPANYNAME,USERID);
      TempExcelBuffer.CloseBook;

      ShouldOpenFile := TRUE;
      OnOpenExcelSheet(TempExcelBuffer,ShouldOpenFile);
      IF ShouldOpenFile THEN
        TempExcelBuffer.OpenExcelWithName(ExcelFileNameTxt);
    END;

    [EventSubscriber(Codeunit,1750,OnGetPrivacyMasterTables)]
    LOCAL PROCEDURE OnGetPrivacyMasterTablesSubscriber@5(VAR DataPrivacyEntities@1000 : Record 1180);
    VAR
      DummyCustomer@1001 : Record 18;
      DummyVendor@1002 : Record 23;
      DummyContact@1003 : Record 5050;
      DummyResource@1004 : Record 156;
      DummyUser@1005 : Record 2000000120;
      DummyEmployee@1006 : Record 5200;
      DummySalespersonPurchaser@1007 : Record 13;
    BEGIN
      DataPrivacyEntities.InsertRow(
        DATABASE::Customer,
        PAGE::"Customer List",
        DummyCustomer.FIELDNO("No."),
        CustomerFilterTxt);
      DataPrivacyEntities.InsertRow(
        DATABASE::Vendor,
        PAGE::"Vendor List",
        DummyVendor.FIELDNO("No."),
        VendorFilterTxt);
      DataPrivacyEntities.InsertRow(
        DATABASE::"Salesperson/Purchaser",
        PAGE::"Salespersons/Purchasers",
        DummySalespersonPurchaser.FIELDNO(Code),
        ContactFilterTxt);
      DataPrivacyEntities.InsertRow(
        DATABASE::Contact,
        PAGE::"Contact List",
        DummyContact.FIELDNO("No."),
        ContactFilterTxt);
      DataPrivacyEntities.InsertRow(
        DATABASE::Employee,
        PAGE::"Employee List",
        DummyEmployee.FIELDNO("No."),
        '');
      DataPrivacyEntities.InsertRow(
        DATABASE::User,
        PAGE::Users,
        DummyUser.FIELDNO("User Name"),
        '');
      DataPrivacyEntities.InsertRow(
        DATABASE::Resource,
        PAGE::"Resource List",
        DummyResource.FIELDNO("No."),
        ResourceFilterTxt);
    END;

    [Integration]
    PROCEDURE OnGetPrivacyMasterTables@6(VAR DataPrivacyEntities@1000 : Record 1180);
    BEGIN
    END;

    PROCEDURE SetTableClassifications@4(VAR DataPrivacyEntities@1000 : Record 1180);
    BEGIN
      DataPrivacyEntities.SETRANGE(Include,TRUE);
      IF DataPrivacyEntities.FINDSET THEN
        REPEAT
          SetFieldsClassifications(DataPrivacyEntities."Table No.",DataPrivacyEntities."Default Data Sensitivity");
        UNTIL DataPrivacyEntities.NEXT = 0;
    END;

    LOCAL PROCEDURE SetFieldsClassifications@8(TableNo@1000 : Integer;Class@1001 : Option);
    VAR
      DataSensitivity@1002 : Record 2000000159;
    BEGIN
      DataSensitivity.SETRANGE("Company Name",COMPANYNAME);
      DataSensitivity.SETRANGE("Table No",TableNo);
      SetSensitivities(DataSensitivity,Class);
    END;

    LOCAL PROCEDURE FireDataClassificationNotification@15(EntityName@1001 : Text);
    VAR
      DataClassNotification@1000 : Notification;
    BEGIN
      DataClassNotification.ID := GetDataClassificationNotificationId;
      DataClassNotification.ADDACTION(DataClassNotifActionTxt,CODEUNIT::"Data Classification Mgt.",'OpenDataClassificationWizard');
      DataClassNotification.MESSAGE(STRSUBSTNO(DataClassNotifMessageMsg,EntityName));
      DataClassNotification.ADDACTION(DontShowAgainTok,CODEUNIT::"Data Classification Mgt.",'DisableNotifications');
      DataClassNotification.SEND;
    END;

    LOCAL PROCEDURE FireSyncFieldsNotification@21(DaysSinceLastSync@1003 : Integer);
    VAR
      SyncFieldsNotification@1000 : Notification;
    BEGIN
      SyncFieldsNotification.ID := GetSyncFieldsNotificationId;
      SyncFieldsNotification.MESSAGE := STRSUBSTNO(SyncFieldsInFieldTableMsg,DaysSinceLastSync);
      SyncFieldsNotification.ADDACTION(SyncAllFieldsTxt,CODEUNIT::"Data Classification Mgt.",'SyncAllFieldsFromNotification');
      SyncFieldsNotification.ADDACTION(DontShowAgainTok,CODEUNIT::"Data Classification Mgt.",'DisableNotifications');
      SyncFieldsNotification.SEND;
    END;

    LOCAL PROCEDURE FireUnclassifiedFieldsNotification@27();
    VAR
      Notification@1000 : Notification;
    BEGIN
      Notification.ID := GetUnclassifiedFieldsNotificationId;
      Notification.MESSAGE := UnclassifiedFieldsExistMsg;
      Notification.ADDACTION(OpenWorksheetActionLbl,CODEUNIT::"Data Classification Mgt.",'OpenClassificationWorksheetPage');
      Notification.ADDACTION(DontShowAgainTok,CODEUNIT::"Data Classification Mgt.",'DisableNotifications');
      Notification.SEND;
    END;

    PROCEDURE GetDataClassificationNotificationId@19() : GUID;
    BEGIN
      EXIT('23593a8e-947b-4b09-8382-36a8aaf89e01');
    END;

    PROCEDURE GetSyncFieldsNotificationId@42() : GUID;
    BEGIN
      EXIT('3bce2004-361a-4e7f-9ae6-2df91f29a195');
    END;

    PROCEDURE GetUnclassifiedFieldsNotificationId@43() : GUID;
    BEGIN
      EXIT('fe7fc3ad-2382-4cbd-93f8-79bcd5b538ae');
    END;

    PROCEDURE OpenDataClassificationWizard@23(Notification@1000 : Notification);
    BEGIN
      PAGE.RUN(PAGE::"Data Classification Wizard");
    END;

    PROCEDURE FindSimilarFields@13(VAR DataSensitivity@1000 : Record 2000000159);
    VAR
      TempDataPrivacyEntities@1002 : TEMPORARY Record 1180;
      FieldNameFilter@1003 : Text;
      TableNoFilter@1004 : Text;
      PrevTableNo@1001 : Integer;
    BEGIN
      IF DataSensitivity.FINDSET THEN BEGIN
        REPEAT
          IF PrevTableNo <> DataSensitivity."Table No" THEN BEGIN
            GetRelatedTablesForTable(TempDataPrivacyEntities,DataSensitivity."Table No");
            PrevTableNo := DataSensitivity."Table No";
          END;
          DataSensitivity.CALCFIELDS("Field Caption");
          FieldNameFilter += STRSUBSTNO('*%1*|',DELCHR(DataSensitivity."Field Caption",'=','()'));
        UNTIL DataSensitivity.NEXT = 0;

        FieldNameFilter := COPYSTR(FieldNameFilter,1,STRLEN(FieldNameFilter) - 1);
        DataSensitivity.RESET;
        DataSensitivity.SETRANGE("Company Name",COMPANYNAME);
        DataSensitivity.FILTERGROUP(2);
        DataSensitivity.SETFILTER("Field Caption",FieldNameFilter);

        IF TempDataPrivacyEntities.FINDSET THEN BEGIN
          REPEAT
            TableNoFilter += STRSUBSTNO('%1|',TempDataPrivacyEntities."Table No.");
          UNTIL TempDataPrivacyEntities.NEXT = 0;

          TableNoFilter := COPYSTR(TableNoFilter,1,STRLEN(TableNoFilter) - 1);
          DataSensitivity.SETFILTER("Table No",TableNoFilter);
        END;
      END;
    END;

    PROCEDURE GetRelatedTablesForTable@18(VAR TempDataPrivacyEntitiesOut@1000 : TEMPORARY Record 1180;TableNo@1001 : Integer);
    VAR
      TableRelationsMetadata@1002 : Record 2000000141;
    BEGIN
      TableRelationsMetadata.SETRANGE("Related Table ID",TableNo);
      IF TableRelationsMetadata.FINDSET THEN
        REPEAT
          TempDataPrivacyEntitiesOut.InsertRow(TableRelationsMetadata."Table ID",0,0,'');
        UNTIL TableRelationsMetadata.NEXT = 0;
    END;

    PROCEDURE GetTableNoFilterForTablesWhoseNameContains@9(Name@1001 : Text) : Text;
    VAR
      Field@1000 : Record 2000000041;
      PrevTableNo@1002 : Integer;
      TableNoFilter@1003 : Text;
    BEGIN
      PrevTableNo := 0;
      Field.SETRANGE(DataClassification,Field.DataClassification::CustomerContent);
      Field.SETFILTER(ObsoleteState,'<>%1',Field.ObsoleteState::Removed);
      Field.SETFILTER(TableName,STRSUBSTNO('*%1*',Name));
      IF Field.FINDSET THEN BEGIN
        REPEAT
          IF PrevTableNo <> Field.TableNo THEN
            TableNoFilter += STRSUBSTNO('%1|',Field.TableNo);
        UNTIL Field.NEXT = 0;

        TableNoFilter := COPYSTR(TableNoFilter,1,STRLEN(TableNoFilter) - 1);
      END;
      EXIT(TableNoFilter);
    END;

    PROCEDURE PopulateFieldValue@25(FieldRef@1005 : FieldRef;VAR FieldContentBuffer@1000 : Record 1754);
    VAR
      FieldValueText@1001 : Text;
    BEGIN
      IF IsFlowField(FieldRef) THEN
        FieldRef.CALCFIELD;
      EVALUATE(FieldValueText,FORMAT(FieldRef.VALUE,0,9));
      IF FieldValueText <> '' THEN
        IF NOT FieldContentBuffer.GET(FieldValueText) THEN BEGIN
          FieldContentBuffer.INIT;
          FieldContentBuffer.Value := COPYSTR(FieldValueText,1,250);
          FieldContentBuffer.INSERT;
        END;
    END;

    LOCAL PROCEDURE IsFlowField@26(FieldRef@1000 : FieldRef) : Boolean;
    VAR
      OptionVar@1001 : 'Normal,FlowFilter,FlowField';
    BEGIN
      EVALUATE(OptionVar,FORMAT(FieldRef.CLASS));
      EXIT(OptionVar = OptionVar::FlowField);
    END;

    PROCEDURE SyncAllFieldsFromNotification@41(Notification@1000 : Notification);
    BEGIN
      SyncAllFields;
      CheckForUnclassifiedFields;
    END;

    PROCEDURE SyncAllFields@39();
    VAR
      Field@1000 : Record 2000000041;
    BEGIN
      RunSync(Field);
    END;

    LOCAL PROCEDURE CheckForUnclassifiedFields@51();
    VAR
      DataSensitivity@1001 : Record 2000000159;
      CompanyInformation@1002 : Record 79;
    BEGIN
      IF NOT DataSensitivity.WRITEPERMISSION THEN
        EXIT;

      DataSensitivity.SETRANGE("Company Name",COMPANYNAME);
      DataSensitivity.SETRANGE("Data Sensitivity",DataSensitivity."Data Sensitivity"::Unclassified);
      IF DataSensitivity.ISEMPTY THEN
        EXIT;

      IF CompanyInformation.GET THEN;
      IF CompanyInformation."Demo Company" THEN
        EXIT;

      FireUnclassifiedFieldsNotification;
    END;

    [EventSubscriber(Page,2501,OnAfterActionEvent,Install,Skip,Skip)]
    LOCAL PROCEDURE AfterExtensionIsInstalled@74(VAR Rec@1000 : Record 2000000160);
    VAR
      DataSensitivity@1001 : Record 2000000159;
      NAVAppObjectMetadata@1002 : Record 2000000150;
      Field@1003 : Record 2000000041;
      FilterText@1004 : Text;
    BEGIN
      DataSensitivity.SETRANGE("Company Name",COMPANYNAME);
      IF DataSensitivity.ISEMPTY THEN
        EXIT;

      NAVAppObjectMetadata.SETRANGE("App Package ID",Rec."Package ID");
      NAVAppObjectMetadata.SETRANGE("Object Type",NAVAppObjectMetadata."Object Type"::Table);
      IF NAVAppObjectMetadata.FINDSET THEN BEGIN
        REPEAT
          FilterText += STRSUBSTNO('%1|',NAVAppObjectMetadata."Object ID");
        UNTIL NAVAppObjectMetadata.NEXT = 0;

        // Remove the last '|' character
        FilterText := COPYSTR(FilterText,1,STRLEN(FilterText) - 1);
        Field.SETFILTER(TableNo,FilterText);
        SetFilterOnField(Field);
        IF Field.FINDSET THEN BEGIN
          REPEAT
            IF NOT DataSensitivity.GET(COMPANYNAME,Field.TableNo,Field."No.") THEN BEGIN
              DataSensitivity.INIT;
              DataSensitivity."Company Name" := COMPANYNAME;
              DataSensitivity."Table No" := Field.TableNo;
              DataSensitivity."Field No" := Field."No.";
              DataSensitivity."Data Sensitivity" := DataSensitivity."Data Sensitivity"::Unclassified;
              DataSensitivity.INSERT;
            END;
          UNTIL Field.NEXT = 0;
          CheckForUnclassifiedFields;
        END;
      END;
    END;

    [EventSubscriber(Page,2501,OnAfterActionEvent,Uninstall,Skip,Skip)]
    LOCAL PROCEDURE AfterExtensionIsUninstalled@20(VAR Rec@1000 : Record 2000000160);
    VAR
      DataSensitivity@1001 : Record 2000000159;
      NAVAppObjectMetadata@1003 : Record 2000000150;
      FilterText@1002 : Text;
    BEGIN
      DataSensitivity.SETRANGE("Company Name",COMPANYNAME);
      IF DataSensitivity.ISEMPTY THEN
        EXIT;

      // Remove the fields from the Data Sensitivity table without a confirmation through a notification
      // as it should be quite fast to do so.
      NAVAppObjectMetadata.SETRANGE("App Package ID",Rec."Package ID");
      NAVAppObjectMetadata.SETRANGE("Object Type",NAVAppObjectMetadata."Object Type"::Table);
      IF NAVAppObjectMetadata.FINDSET THEN BEGIN
        REPEAT
          FilterText += STRSUBSTNO('%1|',NAVAppObjectMetadata."Object ID");
        UNTIL NAVAppObjectMetadata.NEXT = 0;

        // Remove the last '|' character
        FilterText := COPYSTR(FilterText,1,STRLEN(FilterText) - 1);

        DataSensitivity.SETFILTER("Table No",FilterText);
        DataSensitivity.SETRANGE("Data Sensitivity",DataSensitivity."Data Sensitivity"::Unclassified);
        DataSensitivity.DELETEALL;
      END;
    END;

    PROCEDURE OpenClassificationWorksheetPage@32(Notification@1001 : Notification);
    VAR
      DataSensitivity@1000 : Record 2000000159;
    BEGIN
      DataSensitivity.SETRANGE("Company Name",COMPANYNAME);
      DataSensitivity.SETRANGE("Data Sensitivity",DataSensitivity."Data Sensitivity"::Unclassified);
      PAGE.RUN(PAGE::"Data Classification Worksheet",DataSensitivity);
    END;

    LOCAL PROCEDURE SetFilterOnField@44(VAR Field@1000 : Record 2000000041);
    BEGIN
      Field.SETRANGE(Enabled,TRUE);
      Field.SETFILTER(ObsoleteState,'<>%1',Field.ObsoleteState::Removed);
      Field.SETRANGE(Class,Field.Class::Normal);
      Field.SETFILTER(DataClassification,STRSUBSTNO('%1|%2|%3',
          Field.DataClassification::CustomerContent,
          Field.DataClassification::EndUserIdentifiableInformation,
          Field.DataClassification::EndUserPseudonymousIdentifiers));
    END;

    PROCEDURE RunSync@77(Field@1000 : Record 2000000041);
    VAR
      DataSensitivity@1005 : Record 2000000159;
      TempDataSensitivity@1004 : TEMPORARY Record 2000000159;
      FieldsSyncStatus@1002 : Record 1750;
    BEGIN
      DataSensitivity.SETRANGE("Company Name",COMPANYNAME);
      IF DataSensitivity.ISEMPTY THEN BEGIN
        FillDataSensitivityTable;
        EXIT;
      END;

      SetFilterOnField(Field);
      IF Field.FINDSET THEN BEGIN
        // Read all records from Data Sensitivity into Temp var
        IF DataSensitivity.FINDSET THEN
          REPEAT
            TempDataSensitivity.TRANSFERFIELDS(DataSensitivity,TRUE);
            TempDataSensitivity.INSERT;
          UNTIL DataSensitivity.NEXT = 0;

        REPEAT
          IF NOT TempDataSensitivity.GET(COMPANYNAME,Field.TableNo,Field."No.") THEN BEGIN
            DataSensitivity.INIT;
            DataSensitivity."Company Name" := COMPANYNAME;
            DataSensitivity."Table No" := Field.TableNo;
            DataSensitivity."Field No" := Field."No.";
            DataSensitivity."Data Sensitivity" := DataSensitivity."Data Sensitivity"::Unclassified;
            DataSensitivity.INSERT;
          END ELSE
            TempDataSensitivity.DELETE;
        UNTIL Field.NEXT = 0;
      END;

      IF TempDataSensitivity.FINDSET THEN
        REPEAT
          IF TempDataSensitivity."Data Sensitivity" = DataSensitivity."Data Sensitivity"::Unclassified THEN BEGIN
            DataSensitivity.GET(TempDataSensitivity."Company Name",DataSensitivity."Table No",DataSensitivity."Field No");
            DataSensitivity.DELETE;
          END;
        UNTIL TempDataSensitivity.NEXT = 0;

      IF FieldsSyncStatus.GET THEN BEGIN
        FieldsSyncStatus."Last Sync Date Time" := CURRENTDATETIME;
        FieldsSyncStatus.MODIFY;
      END ELSE BEGIN
        FieldsSyncStatus."Last Sync Date Time" := CURRENTDATETIME;
        FieldsSyncStatus.INSERT;
      END;
    END;

    [Integration]
    LOCAL PROCEDURE OnOpenExcelSheet@1(VAR ExcelBuffer@1000 : Record 370;VAR ShouldOpenFile@1001 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnUploadExcelSheet@22(VAR ExcelBuffer@1000 : Record 370;VAR ShouldUploadFile@1001 : Boolean);
    BEGIN
    END;

    PROCEDURE ShowNotifications@10();
    VAR
      DataSensitivity@1000 : Record 2000000159;
      Vendor@1003 : Record 23;
      Customer@1004 : Record 18;
      Employee@1005 : Record 5200;
      Contact@1006 : Record 5050;
      Resource@1007 : Record 156;
      DataClassNotifSetup@1008 : Record 1751;
      CompanyInformation@1009 : Record 79;
      IdentityManagement@1002 : Codeunit 9801;
    BEGIN
      IF IdentityManagement.IsInvAppId THEN
        EXIT;

      IF NOT DataClassNotifSetup.ShowNotifications THEN
        EXIT;

      IF NOT DataSensitivity.WRITEPERMISSION THEN
        EXIT;

      IF CompanyInformation.GET THEN;
      IF CompanyInformation."Demo Company" THEN
        EXIT;

      DataSensitivity.SETRANGE("Company Name",COMPANYNAME);
      IF DataSensitivity.ISEMPTY THEN BEGIN
        IF CountryRegion.FINDSET THEN BEGIN
          REPEAT
            IF CountryRegion."EU Country/Region Code" <> '' THEN
              CountryCodeFilter += STRSUBSTNO('%1|',CountryRegion.Code);
          UNTIL CountryRegion.NEXT = 0;

          CountryCodeFilter := COPYSTR(CountryCodeFilter,1,STRLEN(CountryCodeFilter) - 1);
        END;

        Vendor.SETRANGE("Partner Type",Vendor."Partner Type"::Person);
        Vendor.SETFILTER("Country/Region Code",CountryCodeFilter);
        IF Vendor.FINDFIRST THEN BEGIN
          FireDataClassificationNotification(VendorsTok);
          EXIT;
        END;

        Customer.SETRANGE("Partner Type",Customer."Partner Type"::Person);
        Customer.SETFILTER("Country/Region Code",CountryCodeFilter);
        IF Customer.FINDFIRST THEN BEGIN
          FireDataClassificationNotification(CustomersTok);
          EXIT;
        END;

        Contact.SETRANGE(Type,Contact.Type::Person);
        Contact.SETFILTER("Country/Region Code",CountryCodeFilter);
        IF Contact.FINDFIRST THEN BEGIN
          FireDataClassificationNotification(ContactsTok);
          EXIT;
        END;

        Resource.SETRANGE(Type,Resource.Type::Person);
        Resource.SETFILTER("Country/Region Code",CountryCodeFilter);
        IF Resource.FINDFIRST THEN BEGIN
          FireDataClassificationNotification(ResourcesTok);
          EXIT;
        END;

        Employee.SETFILTER("Country/Region Code",CountryCodeFilter);
        IF Employee.FINDFIRST THEN BEGIN
          FireDataClassificationNotification(EmployeesTok);
          EXIT;
        END;
        EXIT;
      END;

      DataSensitivity.SETRANGE("Data Sensitivity",DataSensitivity."Data Sensitivity"::Unclassified);
      IF DataSensitivity.FINDFIRST THEN BEGIN
        FireUnclassifiedFieldsNotification;
        EXIT;
      END;

      ShowSyncFieldsNotification;
    END;

    PROCEDURE DisableNotifications@33(Notification@1000 : Notification);
    VAR
      DataClassNotifSetup@1001 : Record 1751;
    BEGIN
      DataClassNotifSetup.DisableNotifications;
    END;

    PROCEDURE ShowSyncFieldsNotification@28();
    VAR
      FieldsSyncStatus@1001 : Record 1750;
      CompanyInformation@1002 : Record 79;
      DataClassNotifSetup@1008 : Record 1751;
      DaysSinceLastSync@1000 : Integer;
    BEGIN
      IF NOT DataClassNotifSetup.ShowNotifications THEN
        EXIT;

      IF NOT FieldsSyncStatus.WRITEPERMISSION THEN
        EXIT;

      IF CompanyInformation.GET THEN;
      IF CompanyInformation."Demo Company" THEN
        EXIT;

      IF FieldsSyncStatus.GET THEN BEGIN
        DaysSinceLastSync := ROUND((CURRENTDATETIME - FieldsSyncStatus."Last Sync Date Time") / 1000 / 3600 / 24,1);
        IF DaysSinceLastSync > 30 THEN
          FireSyncFieldsNotification(DaysSinceLastSync);
      END;
    END;

    LOCAL PROCEDURE ClassifyTableFields@17(TableNo@1003 : Integer;Class@1000 : Option);
    VAR
      DataSensitivity@1002 : Record 2000000159;
    BEGIN
      DataSensitivity.SETRANGE("Company Name",COMPANYNAME);
      DataSensitivity.SETRANGE("Table No",TableNo);
      DataSensitivity.MODIFYALL("Data Sensitivity",Class);
    END;

    LOCAL PROCEDURE ClassifyField@7(TableNo@1000 : Integer;FieldNo@1001 : Integer;Class@1002 : Option);
    VAR
      DataSensitivity@1003 : Record 2000000159;
    BEGIN
      IF NOT DataSensitivity.GET(COMPANYNAME,TableNo,FieldNo) THEN
        EXIT;
      DataSensitivity.VALIDATE("Data Sensitivity",Class);
      DataSensitivity.MODIFY(TRUE);
    END;

    PROCEDURE CreateDemoData@2();
    VAR
      DataSensitivity@1002 : Record 2000000159;
      Field@1000 : Record 2000000041;
    BEGIN
      DataSensitivity.SETRANGE("Company Name",COMPANYNAME);
      IF NOT DataSensitivity.ISEMPTY THEN
        EXIT;

      // Set Everything to Normal and override later
      Field.SETFILTER(ObsoleteState,'<>%1',Field.ObsoleteState::Removed);
      Field.SETFILTER(DataClassification,STRSUBSTNO('%1|%2|%3',
          Field.DataClassification::CustomerContent,
          Field.DataClassification::EndUserIdentifiableInformation,
          Field.DataClassification::EndUserPseudonymousIdentifiers));
      IF Field.FINDSET THEN
        REPEAT
          DataSensitivity."Company Name" := COMPANYNAME;
          DataSensitivity."Table No" := Field.TableNo;
          DataSensitivity."Field No" := Field."No.";
          DataSensitivity."Data Sensitivity" := DataSensitivity."Data Sensitivity"::Normal;
          IF DataSensitivity.INSERT(TRUE) THEN;
        UNTIL Field.NEXT = 0;

      SetSensitivitiesForTablesWithASingleClassification;
      SetSensitivitiesForMasterTables;
      SetSensitivitiesForDocuments;
      SetSensitivitiesForLines;
      SetSensitivitiesForEntries;
      SetSensitivitiesForRest;

      // All EUII and EUPI Fields are set to Personal
      DataSensitivity.SETFILTER("Data Classification",
        STRSUBSTNO('%1|%2',
          DataSensitivity."Data Classification"::EndUserIdentifiableInformation,
          DataSensitivity."Data Classification"::EndUserPseudonymousIdentifiers));
      DataSensitivity.MODIFYALL("Data Sensitivity",DataSensitivity."Data Sensitivity"::Personal);
    END;

    LOCAL PROCEDURE SetSensitivitiesForTablesWithASingleClassification@11();
    VAR
      DataSensitivity@1000 : Record 2000000159;
    BEGIN
      ClassifyTableFields(DATABASE::"SEPA Direct Debit Mandate",DataSensitivity."Data Sensitivity"::"Company Confidential");
      ClassifyTableFields(DATABASE::"Employee Qualification",DataSensitivity."Data Sensitivity"::"Company Confidential");
      ClassifyTableFields(DATABASE::"Employee Absence",DataSensitivity."Data Sensitivity"::"Company Confidential");
    END;

    LOCAL PROCEDURE SetSensitivitiesForMasterTables@24();
    VAR
      DataSensitivity@1000 : Record 2000000159;
      I@1001 : Integer;
    BEGIN
      // Name
      ClassifyField(DATABASE::"Salesperson/Purchaser",2,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"IC Partner",2,DataSensitivity."Data Sensitivity"::Personal);

      // First Name,Middle Name,Last Name
      FOR I := 2 TO 4 DO
        ClassifyField(DATABASE::Employee,I,DataSensitivity."Data Sensitivity"::Personal);

      // Name,Search Name,Name 2,Address,Address 2, City, Contact,Phone No.,Telex No.
      FOR I := 2 TO 10 DO BEGIN
        ClassifyField(DATABASE::Customer,I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::Vendor,I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::Contact,I,DataSensitivity."Data Sensitivity"::Personal);
      END;

      // Name,Search Name,Name 2,Address,Address 2,City
      FOR I := 3 TO 8 DO
        ClassifyField(DATABASE::Resource,I,DataSensitivity."Data Sensitivity"::Personal);

      // Attendee Name
      ClassifyField(DATABASE::Attendee,6,DataSensitivity."Data Sensitivity"::Personal);

      // Search Name,Address,Address 2,City,Post Code,County,Phone No.,Mobile Phone No.,E-Mail,
      FOR I := 7 TO 15 DO
        ClassifyField(DATABASE::Employee,I,DataSensitivity."Data Sensitivity"::Personal);

      // Social Security No.
      ClassifyField(DATABASE::Resource,9,DataSensitivity."Data Sensitivity"::Sensitive);
      // Education
      ClassifyField(DATABASE::Resource,11,DataSensitivity."Data Sensitivity"::Sensitive);
      // Employment Date
      ClassifyField(DATABASE::Resource,13,DataSensitivity."Data Sensitivity"::Sensitive);

      // Picture,Birth Date
      FOR I := 19 TO 20 DO
        ClassifyField(DATABASE::Employee,I,DataSensitivity."Data Sensitivity"::Personal);
      // Social Security No.,Union Code,Union Membership No.,Gender
      FOR I := 21 TO 24 DO
        ClassifyField(DATABASE::Employee,I,DataSensitivity."Data Sensitivity"::Sensitive);
      // Employment Date
      ClassifyField(DATABASE::Employee,29,DataSensitivity."Data Sensitivity"::Sensitive);
      // Status,Inactive Date
      FOR I := 31 TO 32 DO
        ClassifyField(DATABASE::Employee,I,DataSensitivity."Data Sensitivity"::Sensitive);
      // Termination Date
      ClassifyField(DATABASE::Employee,34,DataSensitivity."Data Sensitivity"::Sensitive);
      // Extension
      ClassifyField(DATABASE::Employee,46,DataSensitivity."Data Sensitivity"::Personal);
      // Pager,Fax No.,Company E-Mail
      FOR I := 48 TO 50 DO
        ClassifyField(DATABASE::Employee,I,DataSensitivity."Data Sensitivity"::Personal);

      // Picture,Post Code,County
      FOR I := 52 TO 54 DO
        ClassifyField(DATABASE::Resource,I,DataSensitivity."Data Sensitivity"::Personal);

      // Bank Branch No.,Bank Account No.,IBAN
      FOR I := 56 TO 58 DO
        ClassifyField(DATABASE::Employee,I,DataSensitivity."Data Sensitivity"::Personal);
      // Fax No.,Telex Answer Back,VAT Registration No.
      FOR I := 84 TO 86 DO BEGIN
        ClassifyField(DATABASE::Customer,I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::Vendor,I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::Contact,I,DataSensitivity."Data Sensitivity"::Personal);
      END;

      // Picture,GLN,Post Code,Country
      FOR I := 89 TO 92 DO BEGIN
        ClassifyField(DATABASE::Contact,I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::Customer,I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::Vendor,I,DataSensitivity."Data Sensitivity"::Personal);
      END;

      // E-Mail,Home Page
      FOR I := 102 TO 103 DO BEGIN
        ClassifyField(DATABASE::Vendor,I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::Customer,I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::Contact,I,DataSensitivity."Data Sensitivity"::Personal);
      END;

      // Tax Area Code
      ClassifyField(DATABASE::Customer,108,DataSensitivity."Data Sensitivity"::"Company Confidential");
      ClassifyField(DATABASE::Vendor,108,DataSensitivity."Data Sensitivity"::"Company Confidential");
      // Image
      ClassifyField(DATABASE::Customer,140,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::Resource,140,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::Vendor,140,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::Contact,140,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Salesperson/Purchaser",140,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::Employee,140,DataSensitivity."Data Sensitivity"::Personal);
      // Creditor No.
      ClassifyField(DATABASE::Vendor,170,DataSensitivity."Data Sensitivity"::Personal);

      // First Name,Middle Name,Surname
      FOR I := 5054 TO 5056 DO
        ClassifyField(DATABASE::Contact,I,DataSensitivity."Data Sensitivity"::Personal);
      // Extension No.,Mobile Phone No.,Pager
      FOR I := 5060 TO 5062 DO
        ClassifyField(DATABASE::Contact,I,DataSensitivity."Data Sensitivity"::Personal);

      // Search E-Mail
      ClassifyField(DATABASE::Contact,5102,DataSensitivity."Data Sensitivity"::Personal);
      // E-mail 2
      ClassifyField(DATABASE::Contact,5105,DataSensitivity."Data Sensitivity"::Personal);

      // E-Mail
      ClassifyField(DATABASE::"Salesperson/Purchaser",5052,DataSensitivity."Data Sensitivity"::Personal);
      // Phone No.
      ClassifyField(DATABASE::"Salesperson/Purchaser",5053,DataSensitivity."Data Sensitivity"::Personal);
      // Job Title
      ClassifyField(DATABASE::"Salesperson/Purchaser",5062,DataSensitivity."Data Sensitivity"::"Company Confidential");
      // Search E-mail
      ClassifyField(DATABASE::"Salesperson/Purchaser",5085,DataSensitivity."Data Sensitivity"::Personal);
      // E-Mail 2
      ClassifyField(DATABASE::"Salesperson/Purchaser",5086,DataSensitivity."Data Sensitivity"::Personal);
    END;

    LOCAL PROCEDURE SetSensitivitiesForDocuments@31();
    VAR
      DataSensitivity@1000 : Record 2000000159;
      I@1001 : Integer;
    BEGIN
      // Name,Name 2,Address,Address 2,Post Code,City,County
      FOR I := 3 TO 9 DO BEGIN
        ClassifyField(DATABASE::"Reminder Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Issued Reminder Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Finance Charge Memo Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Issued Fin. Charge Memo Header",I,DataSensitivity."Data Sensitivity"::Personal);
      END;

      // Bill/Pay-to Name,Bill/Pay-to Name 2,Bill/Pay-to Address,Bill/Pay-to Address 2,Bill/Pay-to City,Bill/Pay-to Contact
      FOR I := 5 TO 10 DO BEGIN
        ClassifyField(DATABASE::"Sales Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Purchase Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Sales Shipment Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Sales Invoice Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Sales Cr.Memo Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Purch. Rcpt. Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Purch. Inv. Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Purch. Cr. Memo Hdr.",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Service Cr.Memo Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Sales Header Archive",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Purchase Header Archive",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Service Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Service Shipment Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Service Invoice Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Service Cr.Memo Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Return Shipment Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Return Receipt Header",I,DataSensitivity."Data Sensitivity"::Personal);
      END;

      // Name,Address,Address 2,Post Code,City,Contact Name
      FOR I := 8 TO 13 DO
        ClassifyField(DATABASE::"Filed Service Contract Header",I,DataSensitivity."Data Sensitivity"::Personal);

      // Contact
      ClassifyField(DATABASE::"Reminder Header",13,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Issued Reminder Header",13,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Finance Charge Memo Header",13,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Issued Fin. Charge Memo Header",13,DataSensitivity."Data Sensitivity"::Personal);

      // Ship-to Name
      ClassifyField(DATABASE::"IC Outbox Sales Header",13,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Handled IC Outbox Sales Header",13,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"IC Inbox Sales Header",13,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Handled IC Inbox Sales Header",13,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Service Contract Header",13,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"IC Outbox Purchase Header",13,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Handled IC Outbox Purch. Hdr",13,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"IC Inbox Purchase Header",13,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Handled IC Inbox Purch. Header",13,DataSensitivity."Data Sensitivity"::Personal);

      // Ship-to Name,Ship-to Name 2,Ship-to Address,Ship-to Address 2,Ship-to City,Ship-to Contact
      FOR I := 13 TO 18 DO BEGIN
        ClassifyField(DATABASE::"Sales Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Purchase Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Sales Shipment Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Sales Invoice Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Sales Cr.Memo Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Purch. Rcpt. Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Purch. Inv. Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Purch. Cr. Memo Hdr.",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Sales Header Archive",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Purchase Header Archive",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Service Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Service Shipment Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Service Invoice Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Service Cr.Memo Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Return Shipment Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Return Receipt Header",I,DataSensitivity."Data Sensitivity"::Personal);
      END;

      // Ship-to Address,Ship-to Address 2,Ship-to City
      FOR I := 15 TO 17 DO BEGIN
        ClassifyField(DATABASE::"IC Outbox Sales Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Handled IC Outbox Sales Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"IC Inbox Sales Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Handled IC Inbox Sales Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"IC Outbox Purchase Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Handled IC Outbox Purch. Hdr",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"IC Inbox Purchase Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Handled IC Inbox Purch. Header",I,DataSensitivity."Data Sensitivity"::Personal);
      END;

      // Bill-to Name,Bill-to Address,Bill-to Address 2,Bill-to Post Code,Bill-to City
      FOR I := 17 TO 21 DO
        ClassifyField(DATABASE::"Filed Service Contract Header",I,DataSensitivity."Data Sensitivity"::Personal);

      // VAT Registation No.
      ClassifyField(DATABASE::"Reminder Header",19,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Issued Reminder Header",19,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Finance Charge Memo Header",19,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Issued Fin. Charge Memo Header",19,DataSensitivity."Data Sensitivity"::Personal);

      // Ship-to Name,Ship-to Address,Ship-to Address 2,Ship-to Post Code,Ship-to City
      FOR I := 23 TO 27 DO
        ClassifyField(DATABASE::"Filed Service Contract Header",I,DataSensitivity."Data Sensitivity"::Personal);

      // Tax Area Code
      ClassifyField(DATABASE::"Reminder Header",41,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Issued Reminder Header",41,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Finance Charge Memo Header",41,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Issued Fin. Charge Memo Header",41,DataSensitivity."Data Sensitivity"::Personal);
      // VAT Registration No.
      ClassifyField(DATABASE::"Sales Header",70,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Purchase Header",70,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Sales Shipment Header",70,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Sales Invoice Header",70,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Sales Cr.Memo Header",70,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Purch. Rcpt. Header",70,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Purch. Inv. Header",70,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Purch. Cr. Memo Hdr.",70,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Sales Header Archive",70,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Purchase Header Archive",70,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Service Header",70,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Service Shipment Header",70,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Service Invoice Header",70,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Service Cr.Memo Header",70,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Return Shipment Header",70,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Return Receipt Header",70,DataSensitivity."Data Sensitivity"::Personal);
      // Creditor No.
      ClassifyField(DATABASE::"Purchase Header",70,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Purch. Inv. Header",70,DataSensitivity."Data Sensitivity"::Personal);
      // VAT Registration No.
      ClassifyField(DATABASE::"Sales Invoice Entity Aggregate",70,DataSensitivity."Data Sensitivity"::Personal);
      // Sell-to Customer Name
      ClassifyField(DATABASE::"O365 Sales Document",79,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Sales Invoice Entity Aggregate",79,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Purch. Inv. Entity Aggregate",79,DataSensitivity."Data Sensitivity"::Personal);

      // Sell-to/Buy-from Customer/Vendor Name,Sell-to/Buy-from Customer/Vendor Name 2,Sell-to Address,Sell-to/Buy-from Address 2,
      // Sell-to/Buy-from City,Sell-to/Buy-from Contact,Bill-to/Buy-from Post Code,Bill-to/Buy-from County
      FOR I := 79 TO 86 DO BEGIN
        ClassifyField(DATABASE::"Sales Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Purchase Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Sales Shipment Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Sales Invoice Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Sales Cr.Memo Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Purch. Rcpt. Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Purch. Inv. Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Purch. Cr. Memo Hdr.",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Sales Header Archive",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Purchase Header Archive",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Service Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Service Shipment Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Service Invoice Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Service Cr.Memo Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Return Shipment Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Return Receipt Header",I,DataSensitivity."Data Sensitivity"::Personal);
      END;

      // Sell-to/Buy-from Address,Sell-to/Buy-from Address 2,Sell-to/Buy-from City,Sell-to/Buy-from Contact
      FOR I := 81 TO 84 DO BEGIN
        ClassifyField(DATABASE::"Sales Invoice Entity Aggregate",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Purch. Inv. Entity Aggregate",I,DataSensitivity."Data Sensitivity"::Personal);
      END;

      // Sell-to Contact
      ClassifyField(DATABASE::"O365 Sales Document",84,DataSensitivity."Data Sensitivity"::Personal);

      // Phone No.,Fax No.,E-mail
      FOR I := 86 TO 88 DO
        ClassifyField(DATABASE::"Service Contract Header",I,DataSensitivity."Data Sensitivity"::Personal);

      // Phone No.,Fax No.,E-Mail,Bill-to County,County,Ship-to County
      FOR I := 86 TO 91 DO
        ClassifyField(DATABASE::"Filed Service Contract Header",I,DataSensitivity."Data Sensitivity"::Personal);

      // Sell-to/Buy-from Post Code, Sell-to/Buy-from Country
      FOR I := 88 TO 89 DO BEGIN
        ClassifyField(DATABASE::"Sales Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Purchase Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Sales Shipment Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Sales Invoice Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Sales Cr.Memo Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Purch. Rcpt. Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Purch. Inv. Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Purch. Cr. Memo Hdr.",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Sales Header Archive",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Purchase Header Archive",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Service Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Service Shipment Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Service Invoice Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Service Cr.Memo Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Return Shipment Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Return Receipt Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Sales Invoice Entity Aggregate",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Purch. Inv. Entity Aggregate",I,DataSensitivity."Data Sensitivity"::Personal);
      END;

      // Ship-to Post Code, Ship-to Country
      FOR I := 91 TO 92 DO BEGIN
        ClassifyField(DATABASE::"Sales Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Purchase Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Sales Shipment Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Sales Invoice Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Sales Cr.Memo Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Purch. Rcpt. Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Purch. Inv. Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Purch. Cr. Memo Hdr.",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Sales Header Archive",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Purchase Header Archive",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Service Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Service Shipment Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Service Invoice Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Service Cr.Memo Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Return Shipment Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Return Receipt Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"IC Outbox Sales Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Handled IC Outbox Sales Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"IC Inbox Sales Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Handled IC Inbox Sales Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"IC Outbox Purchase Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Handled IC Outbox Purch. Hdr",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"IC Inbox Purchase Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Handled IC Inbox Purch. Header",I,DataSensitivity."Data Sensitivity"::Personal);
      END;

      // Name 2,Bill-to Name 2,Ship-to Name 2
      FOR I := 95 TO 97 DO
        ClassifyField(DATABASE::"Filed Service Contract Header",I,DataSensitivity."Data Sensitivity"::Personal);

      // Filled By
      ClassifyField(DATABASE::"Filed Service Contract Header",103,DataSensitivity."Data Sensitivity"::Personal);

      // Tax Area Code
      ClassifyField(DATABASE::"Sales Header",114,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Purchase Header",114,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Sales Shipment Header",114,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Sales Invoice Header",114,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Sales Cr.Memo Header",114,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Purch. Rcpt. Header",114,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Purch. Inv. Header",114,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Purch. Cr. Memo Hdr.",114,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Sales Header Archive",114,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Purchase Header Archive",114,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Service Header",114,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Service Shipment Header",114,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Service Invoice Header",114,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Service Cr.Memo Header",114,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Return Shipment Header",114,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Return Receipt Header",114,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Sales Invoice Entity Aggregate",114,DataSensitivity."Data Sensitivity"::Personal);

      // Bill-to Contact
      ClassifyField(DATABASE::"Service Contract Header",5052,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Filed Service Contract Header",5052,DataSensitivity."Data Sensitivity"::Personal);

      // Phone No.,E-Mail,Phone No. 2,Fax No.
      FOR I := 5915 TO 5918 DO BEGIN
        ClassifyField(DATABASE::"Service Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Service Shipment Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Service Invoice Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Service Cr.Memo Header",I,DataSensitivity."Data Sensitivity"::Personal);
      END;

      // Ship-to Fax No.,Ship-to E-Mail,Ship-to Phone,Ship-to Phone 2
      FOR I := 5955 TO 5959 DO BEGIN
        ClassifyField(DATABASE::"Service Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Service Shipment Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Service Invoice Header",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Service Cr.Memo Header",I,DataSensitivity."Data Sensitivity"::Personal);
      END;

      // Contact Graph Id
      ClassifyField(DATABASE::"Sales Invoice Entity Aggregate",9633,DataSensitivity."Data Sensitivity"::Personal);
    END;

    LOCAL PROCEDURE SetSensitivitiesForLines@35();
    VAR
      DataSensitivity@1000 : Record 2000000159;
      I@1001 : Integer;
    BEGIN
      // Tax Area Code
      ClassifyField(DATABASE::"Sales Shipment Line",85,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Sales Invoice Line",85,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Sales Cr.Memo Line",85,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Purch. Rcpt. Line",85,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Purch. Inv. Line",85,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Purch. Cr. Memo Line",85,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Sales Line Archive",85,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Purchase Line Archive",85,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Service Line",85,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Service Shipment Line",85,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Service Invoice Line",85,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Service Cr.Memo Line",85,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Return Shipment Line",85,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Return Receipt Line",85,DataSensitivity."Data Sensitivity"::Personal);
      // Wizard Contact Name
      ClassifyField(DATABASE::"Segment Line",9502,DataSensitivity."Data Sensitivity"::Personal);
      // Related-Party Name
      ClassifyField(DATABASE::"Bank Acc. Reconciliation Line",15,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Posted Payment Recon. Line",15,DataSensitivity."Data Sensitivity"::Personal);

      // Related-Party Bank Acc. No.,Related-Party Address,Related-Party City
      FOR I := 24 TO 26 DO
        ClassifyField(DATABASE::"Bank Acc. Reconciliation Line",I,DataSensitivity."Data Sensitivity"::Personal);
    END;

    LOCAL PROCEDURE SetSensitivitiesForEntries@40();
    VAR
      DataSensitivity@1000 : Record 2000000159;
      Field@1001 : Record 2000000041;
    BEGIN
      // All fields of tables that contain Entry in their name are set to Company Confidential
      Field.SETRANGE(Enabled,TRUE);
      Field.SETFILTER(ObsoleteState,'<>%1',Field.ObsoleteState::Removed);
      Field.SETFILTER(
        DataClassification,
        STRSUBSTNO('%1|%2|%3',
          Field.DataClassification::CustomerContent,
          Field.DataClassification::EndUserIdentifiableInformation,
          Field.DataClassification::EndUserPseudonymousIdentifiers));
      Field.SETFILTER(TableName,'*Entry*');
      IF Field.FINDSET THEN
        REPEAT
          DataSensitivity.GET(COMPANYNAME,Field.TableNo,Field."No.");
          DataSensitivity.VALIDATE("Data Sensitivity",DataSensitivity."Data Sensitivity"::"Company Confidential");
          DataSensitivity.MODIFY(TRUE);
        UNTIL Field.NEXT = 0;
    END;

    LOCAL PROCEDURE SetSensitivitiesForRest@46();
    VAR
      DataSensitivity@1000 : Record 2000000159;
      I@1001 : Integer;
    BEGIN
      // VAT Registration No.
      ClassifyField(DATABASE::"Gen. Journal Line",119,DataSensitivity."Data Sensitivity"::Personal);
      // E-Mail
      ClassifyField(DATABASE::"User Setup",17,DataSensitivity."Data Sensitivity"::"Company Confidential");

      ClassifyTableFields(DATABASE::"Employee Relative",DataSensitivity."Data Sensitivity"::"Company Confidential");
      ClassifyTableFields(DATABASE::"Contact Alt. Address",DataSensitivity."Data Sensitivity"::Personal);

      // Contact No.,Code
      FOR I := 1 TO 2 DO
        ClassifyField(DATABASE::"Contact Alt. Address",I,DataSensitivity."Data Sensitivity"::Normal);

      // Name
      ClassifyField(DATABASE::"Customer Bank Account",3,DataSensitivity."Data Sensitivity"::Personal);
      ClassifyField(DATABASE::"Vendor Bank Account",3,DataSensitivity."Data Sensitivity"::Personal);

      // Name,Phone No.
      FOR I := 3 TO 4 DO BEGIN
        ClassifyField(DATABASE::"My Customer",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"My Vendor",I,DataSensitivity."Data Sensitivity"::Personal);
      END;

      // Name,Search Name,Name 2,Address,Address 2,City,Post Code
      FOR I := 3 TO 9 DO
        ClassifyField(DATABASE::"Work Center",I,DataSensitivity."Data Sensitivity"::Personal);

      // Name,Name 2,Address,Address 2,City,Contact,Phone No.,Telex No.
      FOR I := 3 TO 10 DO BEGIN
        ClassifyField(DATABASE::"Ship-to Address",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Order Address",I,DataSensitivity."Data Sensitivity"::Personal);
      END;

      // Field Description
      ClassifyField(DATABASE::"Confidential Information",4,DataSensitivity."Data Sensitivity"::"Company Confidential");

      // Field First Name,Field Middle Name,Field Last Name,Field Birth Date,Field Phone No.
      FOR I := 4 TO 8 DO
        ClassifyField(DATABASE::"Employee Relative",I,DataSensitivity."Data Sensitivity"::Personal);

      // Name
      ClassifyField(DATABASE::"Communication Method",5,DataSensitivity."Data Sensitivity"::Personal);

      // Name 2,Address,Address 2,City,Post Code,Contact,Phone No.,Telex No.,Bank Branch No.,Bank Account No.,Transit No.
      FOR I := 5 TO 14 DO BEGIN
        ClassifyField(DATABASE::"Customer Bank Account",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Vendor Bank Account",I,DataSensitivity."Data Sensitivity"::Personal);
      END;

      // Service Agent Name,ServiceAgent Phone No.,Service Agent Mobile Phone
      FOR I := 6 TO 8 DO
        ClassifyField(DATABASE::"Maintenance Registration",I,DataSensitivity."Data Sensitivity"::Personal);

      // Contact Name
      ClassifyField(DATABASE::"Office Contact Associations",6,DataSensitivity."Data Sensitivity"::Personal);
      // City
      ClassifyField(DATABASE::"Mini Vendor Template",7,DataSensitivity."Data Sensitivity"::Personal);

      // E-Mail
      ClassifyField(DATABASE::"Communication Method",7,DataSensitivity."Data Sensitivity"::Personal);
      // Last Date Modified
      ClassifyField(DATABASE::"Contact Alt. Address",21,DataSensitivity."Data Sensitivity"::Normal);

      // Country/Region Code,County,Fax No.,Telex Answer Back
      FOR I := 17 TO 20 DO BEGIN
        ClassifyField(DATABASE::"Customer Bank Account",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Vendor Bank Account",I,DataSensitivity."Data Sensitivity"::Personal);
      END;

      // E-Mail,Home Page,IBAN
      FOR I := 22 TO 24 DO BEGIN
        ClassifyField(DATABASE::"Customer Bank Account",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Vendor Bank Account",I,DataSensitivity."Data Sensitivity"::Personal);
      END;

      // Vendor Name,Vendor VAT Registration No.,Vendor IBAN
      FOR I := 23 TO 25 DO
        ClassifyField(DATABASE::"Incoming Document",I,DataSensitivity."Data Sensitivity"::Personal);

      // Vendor Bank Branch No.,Vendor Bank Account No.
      FOR I := 27 TO 28 DO
        ClassifyField(DATABASE::"Incoming Document",I,DataSensitivity."Data Sensitivity"::Personal);

      ClassifyField(DATABASE::"Incoming Document",57,DataSensitivity."Data Sensitivity"::Personal);

      // VAT Registration No.
      ClassifyField(DATABASE::"VAT Report Line",55,DataSensitivity."Data Sensitivity"::Personal);

      // Bill-to Name,Bill-to Address,Bill-to Address 2,Bill-to City
      FOR I := 58 TO 61 DO
        ClassifyField(DATABASE::Job,I,DataSensitivity."Data Sensitivity"::Personal);
      // Bill-to County
      ClassifyField(DATABASE::Job,63,DataSensitivity."Data Sensitivity"::Personal);
      // Bill-to Post Code
      ClassifyField(DATABASE::Job,64,DataSensitivity."Data Sensitivity"::Personal);
      // Bill-to Name 2
      ClassifyField(DATABASE::Job,68,DataSensitivity."Data Sensitivity"::Personal);
      // Country
      ClassifyField(DATABASE::"Work Center",83,DataSensitivity."Data Sensitivity"::Personal);

      // Fax No.,Telex Answer Back
      FOR I := 84 TO 85 DO BEGIN
        ClassifyField(DATABASE::"Ship-to Address",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Order Address",I,DataSensitivity."Data Sensitivity"::Personal);
      END;
      // Post Code,Country
      FOR I := 91 TO 92 DO BEGIN
        ClassifyField(DATABASE::"Ship-to Address",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Order Address",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Mini Vendor Template",I,DataSensitivity."Data Sensitivity"::Personal);
      END;
      // E-Mail,Home Page
      FOR I := 102 TO 103 DO BEGIN
        ClassifyField(DATABASE::"Ship-to Address",I,DataSensitivity."Data Sensitivity"::Personal);
        ClassifyField(DATABASE::"Order Address",I,DataSensitivity."Data Sensitivity"::Personal);
      END;
      // Tax Area Code
      ClassifyField(DATABASE::"Ship-to Address",108,DataSensitivity."Data Sensitivity"::Personal);
      // Bill-to Contact
      ClassifyField(DATABASE::Job,1003,DataSensitivity."Data Sensitivity"::Personal);
      // Profile Questionnaire Value
      ClassifyField(DATABASE::"Contact Profile Answer",5088,DataSensitivity."Data Sensitivity"::Sensitive);
      // Wizard Contact Name
      ClassifyField(DATABASE::Opportunity,9507,DataSensitivity."Data Sensitivity"::Personal);
      // Wizard Contact Name
      ClassifyField(DATABASE::"To-do",9509,DataSensitivity."Data Sensitivity"::Personal);
    END;

    PROCEDURE GetDataSensitivityOptionString@14() : Text;
    BEGIN
      EXIT(DataSensitivityOptionStringTxt);
    END;

    PROCEDURE SetSensitivities@29(VAR DataSensitivity@1000 : Record 2000000159;Sensitivity@1001 : Option);
    VAR
      Now@1002 : DateTime;
    BEGIN
      // MODIFYALL does not result in a bulk query for this table, looping through the records perfoms faster
      // and eliminates issues with the filters of the record
      Now := CURRENTDATETIME;
      IF DataSensitivity.FINDSET THEN
        REPEAT
          DataSensitivity."Data Sensitivity" := Sensitivity;
          DataSensitivity."Last Modified By" := USERSECURITYID;
          DataSensitivity."Last Modified" := Now;
          DataSensitivity.MODIFY;
        UNTIL DataSensitivity.NEXT = 0;
    END;

    [External]
    PROCEDURE GetLegalDisclaimerTxt@34() : Text;
    BEGIN
      EXIT(LegalDisclaimerTxt);
    END;

    BEGIN
    END.
  }
}

