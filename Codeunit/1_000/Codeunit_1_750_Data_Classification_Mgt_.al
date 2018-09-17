OBJECT Codeunit 1750 Data Classification Mgt.
{
  OBJECT-PROPERTIES
  {
    Date=28-06-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23019;
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
      ImportTitleTxt@1002 : TextConst 'DAN=V�lg Excel-regnearket, hvor der er tilf�jet dataklassificeringer.;ENU=Choose the Excel worksheet where data classifications have been added.';
      DataSensitivityOptionStringTxt@1003 : TextConst '@@@=It needs to be translated as the field Data Sensitivity on Page 1751 Data Classification WorkSheet and field Data Sensitivity of Table 1180 Data Sensitivity Entities;DAN=Ikke klassificerede,F�lsomme,Personlige,Virksomhedens fortrolige,Normal;ENU=Unclassified,Sensitive,Personal,Company Confidential,Normal';
      DataClassNotifActionTxt@1004 : TextConst 'DAN=�bn guiden Dataklassificering;ENU=Open Data Classification Guide';
      DataClassNotifMessageMsg@1005 : TextConst '@@@="%1=Data Subject";DAN=Det lader til, at du har %1 i EU. Har du klassificeret dataene? Vi kan hj�lpe dig med dette.;ENU=Looks like you have %1 in the EU. Have you classified your data? We can help you do that.';
      ExcelFileNameTxt@1001 : TextConst 'DAN=Klassificeringer.xlsx;ENU=Classifications.xlsx';
      CustomerFilterTxt@1009 : TextConst '@@@={Locked};DAN="WHERE(Partner Type=FILTER(Person))";ENU="WHERE(Partner Type=FILTER(Person))"';
      VendorFilterTxt@1008 : TextConst '@@@={Locked};DAN="WHERE(Partner Type=FILTER(Person))";ENU="WHERE(Partner Type=FILTER(Person))"';
      ContactFilterTxt@1007 : TextConst '@@@={Locked};DAN="WHERE(Type=FILTER(Person))";ENU="WHERE(Type=FILTER(Person))"';
      ResourceFilterTxt@1006 : TextConst '@@@={Locked};DAN="WHERE(Type=FILTER(Person))";ENU="WHERE(Type=FILTER(Person))"';
      SyncFieldsInFieldTableMsg@1010 : TextConst '@@@="%1=Number of days";DAN=Felterne er %1 dage gamle.;ENU=Your fields are %1 days old.';
      SyncAllFieldsTxt@1011 : TextConst 'DAN=Synkroniser alle felter;ENU=Synchronize all fields';
      UnclassifiedFieldsExistMsg@1013 : TextConst 'DAN=Du har ikke-klassificerede felter, der kr�ver din opm�rksomhed.;ENU=You have unclassified fields that require your attention.';
      OpenWorksheetActionLbl@1012 : TextConst 'DAN=�bn regneark;ENU=Open worksheet';
      VendorsTok@1018 : TextConst 'DAN=kreditorer;ENU=vendors';
      CustomersTok@1019 : TextConst 'DAN=debitorer;ENU=customers';
      ContactsTok@1020 : TextConst 'DAN=kontakter;ENU=contacts';
      EmployeesTok@1021 : TextConst 'DAN=medarbejdere;ENU=employees';
      ResourcesTok@1022 : TextConst 'DAN=ressourcer;ENU=resources';
      DontShowAgainTok@1023 : TextConst 'DAN=Vis ikke dette igen;ENU=Don''t show me again';
      WrongFormatExcelFileErr@1025 : TextConst 'DAN=Det lader til, at det angivne Excel-regneark ikke er formateret korrekt.;ENU=Looks like the Excel worksheet you provided is not formatted correctly.';
      WrongSensitivityValueErr@1024 : TextConst '@@@="%1=Given Sensitivity %2=Available Options";DAN=%1 er ikke en gyldig klassificering. Klassificeringer kan v�re %2.;ENU=%1 is not a valid classification. Classifications can be %2.';
      LegalDisclaimerTxt@1016 : TextConst 'DAN=Microsoft tilbyder kun denne funktion til dataklassificering for at g�re tingene nemmere for dig. Du har selv ansvaret for at klassificere dataene korrekt og overholde de love og regler, der g�lder for dig. Microsoft fraskriver sig ethvert ansvar i forbindelse med krav vedr�rende din klassificering af dataene.;ENU=Microsoft is providing this Data Classification feature as a matter of convenience only. It''s your responsibility to classify the data appropriately and comply with any laws and regulations that are applicable to you. Microsoft disclaims all responsibility towards any claims related to your classification of the data.';

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

        FieldNameFilter := DELCHR(FieldNameFilter,'>','|');
        DataSensitivity.RESET;
        DataSensitivity.SETRANGE("Company Name",COMPANYNAME);
        DataSensitivity.FILTERGROUP(2);
        DataSensitivity.SETFILTER("Field Caption",FieldNameFilter);

        IF TempDataPrivacyEntities.FINDSET THEN BEGIN
          REPEAT
            TableNoFilter += STRSUBSTNO('%1|',TempDataPrivacyEntities."Table No.");
          UNTIL TempDataPrivacyEntities.NEXT = 0;

          TableNoFilter := DELCHR(TableNoFilter,'>','|');
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

        TableNoFilter := DELCHR(TableNoFilter,'>','|');
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
        FilterText := DELCHR(FilterText,'>','|');
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
        FilterText := DELCHR(FilterText,'>','|');

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
        CountryRegion.SETFILTER("EU Country/Region Code",'<>%1','');
        IF CountryRegion.FINDSET THEN
          REPEAT
            CountryCodeFilter += STRSUBSTNO('%1|',CountryRegion.Code);
          UNTIL CountryRegion.NEXT = 0;

        IF CountryCodeFilter = '' THEN
          EXIT;

        CountryCodeFilter := DELCHR(CountryCodeFilter,'>','|');

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

    [External]
    PROCEDURE SetTableFieldsToNormal@231(TableNumber@1001 : Integer);
    VAR
      DataSensitivity@1000 : Record 2000000159;
      Field@1002 : Record 2000000041;
    BEGIN
      Field.SETRANGE(TableNo,TableNumber);
      Field.SETFILTER(
        DataClassification,
        STRSUBSTNO('%1|%2|%3',
          Field.DataClassification::CustomerContent,
          Field.DataClassification::EndUserIdentifiableInformation,
          Field.DataClassification::EndUserPseudonymousIdentifiers));
      IF Field.FINDSET THEN
        REPEAT
          IF DataSensitivity.GET(COMPANYNAME,Field.TableNo,Field."No.") THEN BEGIN
            DataSensitivity."Data Sensitivity" := DataSensitivity."Data Sensitivity"::Normal;
            DataSensitivity.MODIFY;
          END ELSE BEGIN
            DataSensitivity."Company Name" := COMPANYNAME;
            DataSensitivity."Table No" := Field.TableNo;
            DataSensitivity."Field No" := Field."No.";
            DataSensitivity."Data Sensitivity" := DataSensitivity."Data Sensitivity"::Normal;
            DataSensitivity.INSERT;
          END;
        UNTIL Field.NEXT = 0;
    END;

    [External]
    PROCEDURE SetFieldToPersonal@2(TableNo@1000 : Integer;FieldNo@1001 : Integer);
    VAR
      DataSensitivity@1002 : Record 2000000159;
    BEGIN
      IF DataSensitivity.GET(COMPANYNAME,TableNo,FieldNo) THEN BEGIN
        DataSensitivity."Data Sensitivity" := DataSensitivity."Data Sensitivity"::Personal;
        DataSensitivity.MODIFY;
      END ELSE BEGIN
        DataSensitivity."Company Name" := COMPANYNAME;
        DataSensitivity."Table No" := TableNo;
        DataSensitivity."Field No" := FieldNo;
        DataSensitivity."Data Sensitivity" := DataSensitivity."Data Sensitivity"::Personal;
        DataSensitivity.INSERT;
      END;
    END;

    [External]
    PROCEDURE SetFieldToSensitive@11(TableNo@1000 : Integer;FieldNo@1001 : Integer);
    VAR
      DataSensitivity@1002 : Record 2000000159;
    BEGIN
      IF DataSensitivity.GET(COMPANYNAME,TableNo,FieldNo) THEN BEGIN
        DataSensitivity."Data Sensitivity" := DataSensitivity."Data Sensitivity"::Sensitive;
        DataSensitivity.MODIFY;
      END ELSE BEGIN
        DataSensitivity."Company Name" := COMPANYNAME;
        DataSensitivity."Table No" := TableNo;
        DataSensitivity."Field No" := FieldNo;
        DataSensitivity."Data Sensitivity" := DataSensitivity."Data Sensitivity"::Sensitive;
        DataSensitivity.INSERT;
      END;
    END;

    [External]
    PROCEDURE SetFieldToCompanyConfidential@7(TableNo@1000 : Integer;FieldNo@1001 : Integer);
    VAR
      DataSensitivity@1002 : Record 2000000159;
    BEGIN
      IF DataSensitivity.GET(COMPANYNAME,TableNo,FieldNo) THEN BEGIN
        DataSensitivity."Data Sensitivity" := DataSensitivity."Data Sensitivity"::"Company Confidential";
        DataSensitivity.MODIFY;
      END ELSE BEGIN
        DataSensitivity."Company Name" := COMPANYNAME;
        DataSensitivity."Table No" := TableNo;
        DataSensitivity."Field No" := FieldNo;
        DataSensitivity."Data Sensitivity" := DataSensitivity."Data Sensitivity"::"Company Confidential";
        DataSensitivity.INSERT;
      END;
    END;

    [External]
    PROCEDURE SetFieldToNormal@17(TableNo@1000 : Integer;FieldNo@1001 : Integer);
    VAR
      DataSensitivity@1002 : Record 2000000159;
    BEGIN
      IF DataSensitivity.GET(COMPANYNAME,TableNo,FieldNo) THEN BEGIN
        DataSensitivity."Data Sensitivity" := DataSensitivity."Data Sensitivity"::Normal;
        DataSensitivity.MODIFY;
      END ELSE BEGIN
        DataSensitivity."Company Name" := COMPANYNAME;
        DataSensitivity."Table No" := TableNo;
        DataSensitivity."Field No" := FieldNo;
        DataSensitivity."Data Sensitivity" := DataSensitivity."Data Sensitivity"::Normal;
        DataSensitivity.INSERT;
      END;
    END;

    BEGIN
    END.
  }
}

