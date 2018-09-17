OBJECT Codeunit 8614 Config. XML Exchange
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
      FileManagement@1003 : Codeunit 419;
      ConfigPackageMgt@1000 : Codeunit 8611;
      ConfigProgressBar@1004 : Codeunit 8615;
      ConfigValidateMgt@1021 : Codeunit 8617;
      ConfigMgt@1014 : Codeunit 8616;
      ConfigPckgCompressionMgt@1016 : Codeunit 8619;
      TypeHelper@1024 : Codeunit 10;
      XMLDOMMgt@1012 : Codeunit 6224;
      ErrorTypeEnum@1027 : 'General,TableRelation';
      Advanced@1001 : Boolean;
      CalledFromCode@1002 : Boolean;
      PackageAllreadyContainsDataQst@1006 : TextConst '@@@=%1 - Package name;DAN=Pakken %1 indeholder allerede data, der overskrives af importen. Vil du forts�tte?;ENU=Package %1 already contains data that will be overwritten by the import. Do you want to continue?';
      TableContainsRecordsQst@1013 : TextConst '@@@="%1=The ID of the table being imported. %2=The Config Package Code. %3=The number of records in the config package.";DAN=Tabellen %1 i pakken %2 indeholder %3 records, der overskrives af importen. Vil du forts�tte?;ENU=Table %1 in the package %2 contains %3 records that will be overwritten by the import. Do you want to continue?';
      MissingInExcelFileErr@1011 : TextConst '@@@="%1=The Package Code field caption.";DAN=%1 mangler i Excel-filen.;ENU=%1 is missing in the Excel file.';
      ExportPackageTxt@1020 : TextConst 'DAN=Eksporterer pakke;ENU=Exporting package';
      ImportPackageTxt@1017 : TextConst 'DAN=Indl�ser pakke;ENU=Importing package';
      PackageFileNameTxt@1010 : TextConst '@@@={Locked};DAN=Package%1.rapidstart;ENU=Package%1.rapidstart';
      DownloadTxt@1009 : TextConst 'DAN=Hent;ENU=Download';
      ImportFileTxt@1008 : TextConst 'DAN=Indl�s fil;ENU=Import File';
      FileDialogFilterTxt@1007 : TextConst '@@@="Only translate ''RapidStart Files'' {Split=r""[\|\(]\*\.[^ |)]*[|) ]?""}";DAN=RapidStart-fil (*.rapidstart)|*.rapidstart|Alle filer (*.*)|*.*;ENU=RapidStart file (*.rapidstart)|*.rapidstart|All Files (*.*)|*.*';
      ExcelMode@1028 : Boolean;
      HideDialog@1005 : Boolean;
      DataListTxt@1025 : TextConst '@@@={Locked};DAN=DataList;ENU=DataList';
      TableDoesNotExistErr@1015 : TextConst 'DAN=Der opstod en fejl ved indl�sningen af tabellen %1. Tabellen findes ikke i databasen.;ENU=An error occurred while importing the %1 table. The table does not exist in the database.';
      WrongFileTypeErr@1018 : TextConst 'DAN=Den angivne fil kunne ikke indl�ses, da den ikke er en gyldig RapidStart-pakkefil.;ENU=The specified file could not be imported because it is not a valid RapidStart package file.';
      ExportFromWksht@1019 : Boolean;
      RecordProgressTxt@1022 : TextConst '@@@="%1=The name of the table being imported.";DAN=Import�r %1 records;ENU=Import %1 records';
      AddPrefixMode@1033 : Boolean;
      WorkingFolder@1023 : Text;

    LOCAL PROCEDURE AddXMLComment@35(VAR PackageXML@1102 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlDocument";VAR Node@1100 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";Comment@1001 : Text[250]);
    VAR
      CommentNode@1101 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
    BEGIN
      CommentNode := PackageXML.CreateComment(Comment);
      Node.AppendChild(CommentNode);
    END;

    LOCAL PROCEDURE AddTableAttributes@5(ConfigPackageTable@1000 : Record 8613;VAR PackageXML@1003 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlDocument";VAR TableNode@1001 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode");
    VAR
      FieldNode@1002 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
    BEGIN
      WITH ConfigPackageTable DO BEGIN
        IF "Page ID" > 0 THEN BEGIN
          FieldNode := PackageXML.CreateElement(GetElementName(FIELDNAME("Page ID")));
          FieldNode.InnerText := FORMAT("Page ID");
          TableNode.AppendChild(FieldNode);
        END;
        IF "Package Processing Order" > 0 THEN BEGIN
          FieldNode := PackageXML.CreateElement(GetElementName(FIELDNAME("Package Processing Order")));
          FieldNode.InnerText := FORMAT("Package Processing Order");
          TableNode.AppendChild(FieldNode);
        END;
        IF "Processing Order" > 0 THEN BEGIN
          FieldNode := PackageXML.CreateElement(GetElementName(FIELDNAME("Processing Order")));
          FieldNode.InnerText := FORMAT("Processing Order");
          TableNode.AppendChild(FieldNode);
        END;
        IF "Data Template" <> '' THEN BEGIN
          FieldNode := PackageXML.CreateElement(GetElementName(FIELDNAME("Data Template")));
          FieldNode.InnerText := FORMAT("Data Template");
          TableNode.AppendChild(FieldNode);
        END;
        IF Comments <> '' THEN BEGIN
          FieldNode := PackageXML.CreateElement(GetElementName(FIELDNAME(Comments)));
          FieldNode.InnerText := FORMAT(Comments);
          TableNode.AppendChild(FieldNode);
        END;
        IF "Created by User ID" <> '' THEN BEGIN
          FieldNode := PackageXML.CreateElement(GetElementName(FIELDNAME("Created by User ID")));
          FieldNode.InnerText := FORMAT("Created by User ID");
          TableNode.AppendChild(FieldNode);
        END;
        IF "Skip Table Triggers" THEN BEGIN
          FieldNode := PackageXML.CreateElement(GetElementName(FIELDNAME("Skip Table Triggers")));
          FieldNode.InnerText := '1';
          TableNode.AppendChild(FieldNode);
        END;
        IF "Parent Table ID" > 0 THEN BEGIN
          FieldNode := PackageXML.CreateElement(GetElementName(FIELDNAME("Parent Table ID")));
          FieldNode.InnerText := FORMAT("Parent Table ID");
          TableNode.AppendChild(FieldNode);
        END;
        IF "Delete Recs Before Processing" THEN BEGIN
          FieldNode := PackageXML.CreateElement(GetElementName(FIELDNAME("Delete Recs Before Processing")));
          FieldNode.InnerText := '1';
          TableNode.AppendChild(FieldNode);
        END;
        IF "Dimensions as Columns" THEN BEGIN
          FieldNode := PackageXML.CreateElement(GetElementName(FIELDNAME("Dimensions as Columns")));
          FieldNode.InnerText := '1';
          TableNode.AppendChild(FieldNode);
        END;
      END;
    END;

    LOCAL PROCEDURE AddFieldAttributes@14(ConfigPackageField@1000 : Record 8616;VAR FieldNode@1001 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode");
    BEGIN
      IF ConfigPackageField."Primary Key" THEN
        XMLDOMMgt.AddAttribute(FieldNode,GetElementName(ConfigPackageField.FIELDNAME("Primary Key")),'1');
      IF ConfigPackageField."Validate Field" THEN
        XMLDOMMgt.AddAttribute(FieldNode,GetElementName(ConfigPackageField.FIELDNAME("Validate Field")),'1');
      IF ConfigPackageField."Create Missing Codes" THEN
        XMLDOMMgt.AddAttribute(FieldNode,GetElementName(ConfigPackageField.FIELDNAME("Create Missing Codes")),'1');
      IF ConfigPackageField."Processing Order" <> 0 THEN
        XMLDOMMgt.AddAttribute(
          FieldNode,GetElementName(ConfigPackageField.FIELDNAME("Processing Order")),FORMAT(ConfigPackageField."Processing Order"));
    END;

    LOCAL PROCEDURE AddDimensionFields@16(VAR ConfigPackageField@1000 : Record 8616;VAR RecRef@1006 : RecordRef;VAR PackageXML@1003 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlDocument";VAR RecordNode@1007 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";VAR FieldNode@1002 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";ExportValue@1001 : Boolean);
    VAR
      DimCode@1005 : Code[20];
    BEGIN
      ConfigPackageField.SETRANGE(Dimension,TRUE);
      IF ConfigPackageField.FINDSET THEN
        REPEAT
          FieldNode :=
            PackageXML.CreateElement(
              GetElementName(ConfigValidateMgt.CheckName(ConfigPackageField."Field Name")));
          IF ExportValue THEN BEGIN
            DimCode := COPYSTR(ConfigPackageField."Field Name",1,20);
            FieldNode.InnerText := GetDimValueFromTable(RecRef,DimCode);
            RecordNode.AppendChild(FieldNode);
          END ELSE BEGIN
            FieldNode.InnerText := '';
            RecordNode.AppendChild(FieldNode);
          END;
        UNTIL ConfigPackageField.NEXT = 0;
    END;

    PROCEDURE ApplyPackageFilter@7(ConfigPackageTable@1001 : Record 8613;VAR RecRef@1000 : RecordRef);
    VAR
      ConfigPackageFilter@1002 : Record 8626;
      FieldRef@1003 : FieldRef;
    BEGIN
      ConfigPackageFilter.SETRANGE("Package Code",ConfigPackageTable."Package Code");
      ConfigPackageFilter.SETRANGE("Table ID",ConfigPackageTable."Table ID");
      ConfigPackageFilter.SETRANGE("Processing Rule No.",0);
      IF ConfigPackageFilter.FINDSET THEN
        REPEAT
          IF ConfigPackageFilter."Field Filter" <> '' THEN BEGIN
            FieldRef := RecRef.FIELD(ConfigPackageFilter."Field ID");
            FieldRef.SETFILTER(STRSUBSTNO('%1',ConfigPackageFilter."Field Filter"));
          END;
        UNTIL ConfigPackageFilter.NEXT = 0;
    END;

    LOCAL PROCEDURE CreateRecordNodes@11(VAR PackageXML@1100 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlDocument" RUNONCLIENT;ConfigPackageTable@1000 : Record 8613);
    VAR
      Field@1005 : Record 2000000041;
      ConfigPackageField@1007 : Record 8616;
      ConfigPackage@1001 : Record 8623;
      DocumentElement@1101 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      FieldNode@1102 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      RecordNode@1103 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      TableNode@1104 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      TableIDNode@1105 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      PackageCodeNode@1106 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      RecRef@1003 : RecordRef;
      FieldRef@1002 : FieldRef;
      ExportMetadata@1004 : Boolean;
    BEGIN
      ConfigPackageTable.TESTFIELD("Package Code");
      ConfigPackageTable.TESTFIELD("Table ID");
      ConfigPackage.GET(ConfigPackageTable."Package Code");
      DocumentElement := PackageXML.DocumentElement;
      TableNode := PackageXML.CreateElement(GetElementName(ConfigPackageTable."Table Name" + 'List'));
      DocumentElement.AppendChild(TableNode);

      TableIDNode := PackageXML.CreateElement(GetElementName(ConfigPackageTable.FIELDNAME("Table ID")));
      TableIDNode.InnerText := FORMAT(ConfigPackageTable."Table ID");
      TableNode.AppendChild(TableIDNode);

      IF ExcelMode THEN BEGIN
        PackageCodeNode := PackageXML.CreateElement(GetElementName(ConfigPackageTable.FIELDNAME("Package Code")));
        PackageCodeNode.InnerText := FORMAT(ConfigPackageTable."Package Code");
        TableNode.AppendChild(PackageCodeNode);
      END ELSE
        AddTableAttributes(ConfigPackageTable,PackageXML,TableNode);

      ExportMetadata := TRUE;
      RecRef.OPEN(ConfigPackageTable."Table ID");
      ApplyPackageFilter(ConfigPackageTable,RecRef);
      IF RecRef.FINDSET THEN
        REPEAT
          RecordNode := PackageXML.CreateElement(GetTableElementName(ConfigPackageTable."Table Name"));
          TableNode.AppendChild(RecordNode);

          ConfigPackageField.SETRANGE("Package Code",ConfigPackageTable."Package Code");
          ConfigPackageField.SETRANGE("Table ID",ConfigPackageTable."Table ID");
          ConfigPackageField.SETRANGE("Include Field",TRUE);
          ConfigPackageField.SETRANGE(Dimension,FALSE);
          ConfigPackageField.SETCURRENTKEY("Package Code","Table ID","Processing Order");
          IF ConfigPackageField.FINDSET THEN
            REPEAT
              FieldRef := RecRef.FIELD(ConfigPackageField."Field ID");
              IF TypeHelper.GetField(RecRef.NUMBER,FieldRef.NUMBER,Field) THEN BEGIN
                FieldNode :=
                  PackageXML.CreateElement(GetFieldElementName(ConfigValidateMgt.CheckName(FieldRef.NAME)));
                FieldNode.InnerText := FormatFieldValue(FieldRef,ConfigPackage);
                IF Advanced AND ConfigPackageField."Localize Field" THEN
                  AddXMLComment(PackageXML,FieldNode,'_locComment_text="{MaxLength=' + FORMAT(Field.Len) + '}"');
                RecordNode.AppendChild(FieldNode); // must be after AddXMLComment and before AddAttribute.
                IF NOT ExcelMode AND ExportMetadata THEN
                  AddFieldAttributes(ConfigPackageField,FieldNode);
                IF Advanced THEN
                  IF ConfigPackageField."Localize Field" THEN
                    XMLDOMMgt.AddAttribute(FieldNode,'_loc','locData')
                  ELSE
                    XMLDOMMgt.AddAttribute(FieldNode,'_loc','locNone');
              END;
            UNTIL ConfigPackageField.NEXT = 0;

          IF ConfigPackageTable."Dimensions as Columns" AND ExcelMode AND ExportFromWksht THEN
            AddDimensionFields(ConfigPackageField,RecRef,PackageXML,RecordNode,FieldNode,TRUE);
          ExportMetadata := FALSE;
        UNTIL RecRef.NEXT = 0
      ELSE BEGIN
        RecordNode := PackageXML.CreateElement(GetTableElementName(ConfigPackageTable."Table Name"));
        TableNode.AppendChild(RecordNode);

        ConfigPackageField.SETRANGE("Package Code",ConfigPackageTable."Package Code");
        ConfigPackageField.SETRANGE("Table ID",ConfigPackageTable."Table ID");
        ConfigPackageField.SETRANGE("Include Field",TRUE);
        ConfigPackageField.SETRANGE(Dimension,FALSE);
        IF ConfigPackageField.FINDSET THEN
          REPEAT
            FieldRef := RecRef.FIELD(ConfigPackageField."Field ID");
            FieldNode :=
              PackageXML.CreateElement(GetFieldElementName(ConfigValidateMgt.CheckName(FieldRef.NAME)));
            FieldNode.InnerText := '';
            RecordNode.AppendChild(FieldNode);
            IF NOT ExcelMode THEN
              AddFieldAttributes(ConfigPackageField,FieldNode);
          UNTIL ConfigPackageField.NEXT = 0;

        IF ConfigPackageTable."Dimensions as Columns" AND ExcelMode AND ExportFromWksht THEN
          AddDimensionFields(ConfigPackageField,RecRef,PackageXML,RecordNode,FieldNode,FALSE);
      END;
    END;

    [Internal]
    PROCEDURE ExportPackage@4(ConfigPackage@1000 : Record 8623);
    VAR
      ConfigPackageTable@1001 : Record 8613;
    BEGIN
      WITH ConfigPackage DO BEGIN
        TESTFIELD(Code);
        TESTFIELD("Package Name");
        ConfigPackageTable.SETRANGE("Package Code",Code);
        ExportPackageXML(ConfigPackageTable,'');
      END;
    END;

    [Internal]
    PROCEDURE ExportPackageXML@10(VAR ConfigPackageTable@1004 : Record 8613;XMLDataFile@1000 : Text) : Boolean;
    VAR
      ConfigPackage@1001 : Record 8623;
      PackageXML@1101 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlDocument";
      FileFilter@1002 : Text;
      ToFile@1003 : Text[50];
      CompressedFileName@1005 : Text;
    BEGIN
      ConfigPackageTable.FINDFIRST;
      ConfigPackage.GET(ConfigPackageTable."Package Code");
      ConfigPackage.TESTFIELD(Code);
      ConfigPackage.TESTFIELD("Package Name");
      IF NOT ConfigPackage."Exclude Config. Tables" AND NOT ExcelMode THEN
        ConfigPackageMgt.AddConfigTables(ConfigPackage.Code);

      IF NOT CalledFromCode THEN
        XMLDataFile := FileManagement.ServerTempFileName('');
      FileFilter := GetFileDialogFilter;
      IF ToFile = '' THEN
        ToFile := STRSUBSTNO(PackageFileNameTxt,ConfigPackage.Code);

      SetWorkingFolder(FileManagement.GetDirectoryName(XMLDataFile));
      PackageXML := PackageXML.XmlDocument;
      ExportPackageXMLDocument(PackageXML,ConfigPackageTable,ConfigPackage,Advanced);

      PackageXML.Save(XMLDataFile);

      IF NOT CalledFromCode THEN BEGIN
        CompressedFileName := FileManagement.ServerTempFileName('');
        ConfigPckgCompressionMgt.ServersideCompress(XMLDataFile,CompressedFileName);

        FileManagement.DownloadHandler(CompressedFileName,DownloadTxt,'',FileFilter,ToFile);
      END;

      EXIT(TRUE);
    END;

    [Internal]
    PROCEDURE ExportPackageXMLDocument@1100(VAR PackageXML@1100 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlDocument";VAR ConfigPackageTable@1101 : Record 8613;ConfigPackage@1001 : Record 8623;Advanced@1102 : Boolean);
    VAR
      DocumentElement@1000 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlElement";
      LocXML@1103 : Text[1024];
    BEGIN
      ConfigPackage.TESTFIELD(Code);
      ConfigPackage.TESTFIELD("Package Name");

      IF Advanced THEN
        LocXML := '<_locDefinition><_locDefault _loc="locNone"/></_locDefinition>';
      XMLDOMMgt.LoadXMLDocumentFromText(
        STRSUBSTNO(
          '<?xml version="1.0" encoding="UTF-16" standalone="yes"?><%1>%2</%1>',
          GetPackageTag,
          LocXML),
        PackageXML);

      CleanUpConfigPackageData(ConfigPackage);

      IF NOT ExcelMode THEN BEGIN
        InitializeMediaTempFolder;
        DocumentElement := PackageXML.DocumentElement;
        IF ConfigPackage."Exclude Config. Tables" THEN
          XMLDOMMgt.AddAttribute(DocumentElement,GetElementName(ConfigPackage.FIELDNAME("Exclude Config. Tables")),'1');
        IF ConfigPackage."Processing Order" > 0 THEN
          XMLDOMMgt.AddAttribute(
            DocumentElement,GetElementName(ConfigPackage.FIELDNAME("Processing Order")),FORMAT(ConfigPackage."Processing Order"));
        IF ConfigPackage."Language ID" > 0 THEN
          XMLDOMMgt.AddAttribute(
            DocumentElement,GetElementName(ConfigPackage.FIELDNAME("Language ID")),FORMAT(ConfigPackage."Language ID"));
        XMLDOMMgt.AddAttribute(
          DocumentElement,GetElementName(ConfigPackage.FIELDNAME("Product Version")),ConfigPackage."Product Version");
        XMLDOMMgt.AddAttribute(DocumentElement,GetElementName(ConfigPackage.FIELDNAME("Package Name")),ConfigPackage."Package Name");
        XMLDOMMgt.AddAttribute(DocumentElement,GetElementName(ConfigPackage.FIELDNAME(Code)),ConfigPackage.Code);
      END;

      IF NOT HideDialog THEN
        ConfigProgressBar.Init(ConfigPackageTable.COUNT,1,ExportPackageTxt);
      ConfigPackageTable.SETAUTOCALCFIELDS("Table Name");
      IF ConfigPackageTable.FINDSET THEN
        REPEAT
          IF NOT HideDialog THEN
            ConfigProgressBar.Update(ConfigPackageTable."Table Name");

          ExportConfigTableToXML(ConfigPackageTable,PackageXML);
        UNTIL ConfigPackageTable.NEXT = 0;

      IF NOT ExcelMode THEN BEGIN
        UpdateConfigPackageMediaSet(ConfigPackage);
        ExportConfigPackageMediaSetToXML(PackageXML,ConfigPackage);
      END;

      IF NOT HideDialog THEN
        ConfigProgressBar.Close;
    END;

    LOCAL PROCEDURE ExportConfigTableToXML@46(VAR ConfigPackageTable@1000 : Record 8613;VAR PackageXML@1001 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlDocument");
    BEGIN
      CreateRecordNodes(PackageXML,ConfigPackageTable);
      ConfigPackageTable."Exported Date and Time" := CREATEDATETIME(TODAY,TIME);
      ConfigPackageTable.MODIFY;
    END;

    [Internal]
    PROCEDURE ImportPackageXMLFromClient@1024() : Boolean;
    VAR
      ServerFileName@1000 : Text;
      DecompressedFileName@1001 : Text;
    BEGIN
      ServerFileName := FileManagement.ServerTempFileName('.xml');
      IF UploadXMLPackage(ServerFileName) THEN BEGIN
        DecompressedFileName := DecompressPackage(ServerFileName);

        EXIT(ImportPackageXML(DecompressedFileName));
      END;

      EXIT(FALSE);
    END;

    [Internal]
    PROCEDURE ImportPackageXML@12(XMLDataFile@1000 : Text) : Boolean;
    VAR
      PackageXML@1100 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlDocument";
    BEGIN
      XMLDOMMgt.LoadXMLDocumentFromFile(XMLDataFile,PackageXML);

      EXIT(ImportPackageXMLDocument(PackageXML));
    END;

    [Internal]
    PROCEDURE ImportPackageXMLFromStream@19(InStream@1000 : InStream) : Boolean;
    VAR
      PackageXML@1100 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlDocument";
    BEGIN
      XMLDOMMgt.LoadXMLDocumentFromInStream(InStream,PackageXML);

      EXIT(ImportPackageXMLDocument(PackageXML));
    END;

    [Internal]
    PROCEDURE ImportPackageXMLDocument@1104(PackageXML@1107 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlDocument") : Boolean;
    VAR
      ConfigPackage@1004 : Record 8623;
      ConfigPackageRecord@1008 : Record 8614;
      ConfigPackageData@1010 : Record 8615;
      ConfigPackageTable@1007 : Record 8613;
      DocumentElement@1101 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlElement";
      TableNodes@1102 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNodeList";
      TableNode@1002 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      PackageCode@1001 : Code[20];
      Value@1005 : Text;
      TableID@1003 : Integer;
      NodeCount@1000 : Integer;
      Confirmed@1006 : Boolean;
    BEGIN
      DocumentElement := PackageXML.DocumentElement;

      IF NOT ExcelMode THEN BEGIN
        PackageCode := GetPackageCode(PackageXML);
        IF ConfigPackage.GET(PackageCode) THEN BEGIN
          ConfigPackage.CALCFIELDS("No. of Records");
          Confirmed := TRUE;
          IF NOT HideDialog THEN
            IF ConfigPackage."No. of Records" > 0 THEN
              IF NOT CONFIRM(PackageAllreadyContainsDataQst,TRUE,PackageCode) THEN
                Confirmed := FALSE;
          IF NOT Confirmed THEN
            EXIT(FALSE);
          ConfigPackage.DELETE(TRUE);
          COMMIT;
        END;

        ConfigPackage.INIT;
        ConfigPackage.Code := PackageCode;
        ConfigPackage."Package Name" :=
          COPYSTR(
            GetAttribute(GetElementName(ConfigPackage.FIELDNAME("Package Name")),DocumentElement),1,
            MAXSTRLEN(ConfigPackage."Package Name"));
        Value := GetAttribute(GetElementName(ConfigPackage.FIELDNAME("Language ID")),DocumentElement);
        IF Value <> '' THEN
          EVALUATE(ConfigPackage."Language ID",Value);
        ConfigPackage."Product Version" :=
          COPYSTR(
            GetAttribute(GetElementName(ConfigPackage.FIELDNAME("Product Version")),DocumentElement),1,
            MAXSTRLEN(ConfigPackage."Product Version"));
        Value := GetAttribute(GetElementName(ConfigPackage.FIELDNAME("Processing Order")),DocumentElement);
        IF Value <> '' THEN
          EVALUATE(ConfigPackage."Processing Order",Value);
        Value := GetAttribute(GetElementName(ConfigPackage.FIELDNAME("Exclude Config. Tables")),DocumentElement);
        IF Value <> '' THEN
          EVALUATE(ConfigPackage."Exclude Config. Tables",Value);
        IF NOT ConfigPackage.MODIFY THEN
          ConfigPackage.INSERT;
      END;

      TableNodes := DocumentElement.ChildNodes;
      IF NOT HideDialog THEN
        ConfigProgressBar.Init(TableNodes.Count,1,ImportPackageTxt);
      FOR NodeCount := 0 TO (TableNodes.Count - 1) DO BEGIN
        TableNode := TableNodes.Item(NodeCount);
        IF EVALUATE(TableID,FORMAT(TableNode.FirstChild.InnerText)) THEN BEGIN
          FillPackageMetadataFromXML(PackageCode,TableID,TableNode);
          IF NOT TableObjectExists(TableID) THEN BEGIN
            ConfigPackageMgt.InsertPackageTableWithoutValidation(ConfigPackageTable,PackageCode,TableID);
            ConfigPackageMgt.InitPackageRecord(ConfigPackageRecord,PackageCode,TableID);
            ConfigPackageMgt.RecordError(ConfigPackageRecord,0,COPYSTR(STRSUBSTNO(TableDoesNotExistErr,TableID),1,250));
          END ELSE
            IF PackageDataExistsInXML(PackageCode,TableID,TableNode) THEN
              FillPackageDataFromXML(PackageCode,TableID,TableNode);
        END;
        IF ExcelMode THEN
          CASE TRUE OF // Dimensions
            ConfigMgt.IsDefaultDimTable(TableID):
              BEGIN
                ConfigPackageRecord.SETRANGE("Package Code",PackageCode);
                ConfigPackageRecord.SETRANGE("Table ID",TableID);
                IF ConfigPackageRecord.FINDSET THEN
                  REPEAT
                    ConfigPackageData.GET(
                      ConfigPackageRecord."Package Code",ConfigPackageRecord."Table ID",ConfigPackageRecord."No.",1);
                    ConfigPackageMgt.UpdateDefaultDimValues(ConfigPackageRecord,COPYSTR(ConfigPackageData.Value,1,20));
                  UNTIL ConfigPackageRecord.NEXT = 0;
              END;
            ConfigMgt.IsDimSetIDTable(TableID):
              BEGIN
                ConfigPackageRecord.SETRANGE("Package Code",PackageCode);
                ConfigPackageRecord.SETRANGE("Table ID",TableID);
                IF ConfigPackageRecord.FINDSET THEN
                  REPEAT
                    ConfigPackageMgt.HandlePackageDataDimSetIDForRecord(ConfigPackageRecord);
                  UNTIL ConfigPackageRecord.NEXT = 0;
              END;
          END;
      END;
      IF NOT HideDialog THEN
        ConfigProgressBar.Close;

      ConfigPackageMgt.UpdateConfigLinePackageData(ConfigPackage.Code);

      // autoapply configuration lines
      ConfigPackageMgt.ApplyConfigTables(ConfigPackage);

      EXIT(TRUE);
    END;

    LOCAL PROCEDURE PackageDataExistsInXML@52(PackageCode@1001 : Code[20];TableID@1000 : Integer;VAR TableNode@1007 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode") : Boolean;
    VAR
      ConfigPackageTable@1002 : Record 8613;
      ConfigPackageField@1010 : Record 8616;
      RecRef@1004 : RecordRef;
      RecordNodes@1006 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNodeList";
      RecordNode@1005 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      I@1003 : Integer;
    BEGIN
      IF NOT ConfigPackageTable.GET(PackageCode,TableID) THEN
        EXIT(FALSE);

      ConfigPackageTable.CALCFIELDS("Table Name");
      RecordNodes := TableNode.SelectNodes(GetElementName(ConfigPackageTable."Table Name"));

      IF RecordNodes.Count = 0 THEN
        EXIT(FALSE);

      FOR I := 0 TO RecordNodes.Count - 1 DO BEGIN
        RecordNode := RecordNodes.Item(I);
        IF RecordNode.HasChildNodes THEN BEGIN
          RecRef.OPEN(ConfigPackageTable."Table ID");
          ConfigPackageField.SETRANGE("Package Code",ConfigPackageTable."Package Code");
          ConfigPackageField.SETRANGE("Table ID",ConfigPackageTable."Table ID");
          IF ConfigPackageField.FINDSET THEN
            REPEAT
              IF ConfigPackageField."Include Field" AND FieldNodeExists(RecordNode,GetElementName(ConfigPackageField."Field Name")) THEN
                IF GetNodeValue(RecordNode,GetElementName(ConfigPackageField."Field Name")) <> '' THEN
                  EXIT(TRUE);
            UNTIL ConfigPackageField.NEXT = 0;
          RecRef.CLOSE;
        END;
      END;

      EXIT(FALSE);
    END;

    LOCAL PROCEDURE FillPackageMetadataFromXML@57(VAR PackageCode@1005 : Code[20];TableID@1001 : Integer;VAR TableNode@1000 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode");
    VAR
      ConfigPackageTable@1004 : Record 8613;
      ConfigPackageField@1003 : Record 8616;
      Field@1002 : Record 2000000041;
      ConfigMgt@1013 : Codeunit 8616;
      RecordNodes@1010 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNodeList";
      RecordNode@1009 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      FieldNode@1008 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      Value@1006 : Text;
    BEGIN
      IF (TableID > 0) AND (NOT ConfigPackageTable.GET(PackageCode,TableID)) THEN BEGIN
        IF NOT ExcelMode THEN BEGIN
          ConfigPackageTable.INIT;
          ConfigPackageTable."Package Code" := PackageCode;
          ConfigPackageTable."Table ID" := TableID;
          Value := GetNodeValue(TableNode,GetElementName(ConfigPackageTable.FIELDNAME("Page ID")));
          IF Value <> '' THEN
            EVALUATE(ConfigPackageTable."Page ID",Value);
          IF ConfigPackageTable."Page ID" = 0 THEN
            ConfigPackageTable."Page ID" := ConfigMgt.FindPage(TableID);
          Value := GetNodeValue(TableNode,GetElementName(ConfigPackageTable.FIELDNAME("Package Processing Order")));
          IF Value <> '' THEN
            EVALUATE(ConfigPackageTable."Package Processing Order",Value);
          Value := GetNodeValue(TableNode,GetElementName(ConfigPackageTable.FIELDNAME("Processing Order")));
          IF Value <> '' THEN
            EVALUATE(ConfigPackageTable."Processing Order",Value);
          Value := GetNodeValue(TableNode,GetElementName(ConfigPackageTable.FIELDNAME("Dimensions as Columns")));
          IF Value <> '' THEN
            EVALUATE(ConfigPackageTable."Dimensions as Columns",Value);
          Value := GetNodeValue(TableNode,GetElementName(ConfigPackageTable.FIELDNAME("Skip Table Triggers")));
          IF Value <> '' THEN
            EVALUATE(ConfigPackageTable."Skip Table Triggers",Value);
          Value := GetNodeValue(TableNode,GetElementName(ConfigPackageTable.FIELDNAME("Parent Table ID")));
          IF Value <> '' THEN
            EVALUATE(ConfigPackageTable."Parent Table ID",Value);
          Value := GetNodeValue(TableNode,GetElementName(ConfigPackageTable.FIELDNAME("Delete Recs Before Processing")));
          IF Value <> '' THEN
            EVALUATE(ConfigPackageTable."Delete Recs Before Processing",Value);
          Value := GetNodeValue(TableNode,GetElementName(ConfigPackageTable.FIELDNAME("Created by User ID")));
          IF Value <> '' THEN
            EVALUATE(ConfigPackageTable."Created by User ID",COPYSTR(Value,1,50));
          ConfigPackageTable."Data Template" :=
            COPYSTR(
              GetNodeValue(TableNode,GetElementName(ConfigPackageTable.FIELDNAME("Data Template"))),1,
              MAXSTRLEN(ConfigPackageTable."Data Template"));
          ConfigPackageTable.Comments :=
            COPYSTR(
              GetNodeValue(TableNode,GetElementName(ConfigPackageTable.FIELDNAME(Comments))),
              1,MAXSTRLEN(ConfigPackageTable.Comments));
          ConfigPackageTable."Imported Date and Time" := CREATEDATETIME(TODAY,TIME);
          ConfigPackageTable."Imported by User ID" := USERID;
          ConfigPackageTable.INSERT(TRUE);
          ConfigPackageField.SETRANGE("Package Code",ConfigPackageTable."Package Code");
          ConfigPackageField.SETRANGE("Table ID",ConfigPackageTable."Table ID");
          ConfigPackageMgt.SelectAllPackageFields(ConfigPackageField,FALSE);
        END ELSE BEGIN // Excel import
          Value := GetNodeValue(TableNode,GetElementName(ConfigPackageTable.FIELDNAME("Package Code")));
          IF Value <> '' THEN
            EVALUATE(ConfigPackageTable."Package Code",COPYSTR(Value,1,MAXSTRLEN(ConfigPackageTable."Package Code")))
          ELSE
            ERROR(MissingInExcelFileErr,ConfigPackageTable.FIELDCAPTION("Package Code"));
          Value := GetNodeValue(TableNode,GetElementName(ConfigPackageTable.FIELDNAME("Table ID")));
          IF Value <> '' THEN
            EVALUATE(ConfigPackageTable."Table ID",Value)
          ELSE
            ERROR(MissingInExcelFileErr,ConfigPackageTable.FIELDCAPTION("Table ID"));
          ConfigPackageTable.GET(ConfigPackageTable."Package Code",ConfigPackageTable."Table ID");
          PackageCode := ConfigPackageTable."Package Code";
        END;

        ConfigPackageTable.CALCFIELDS("Table Name");
        IF ConfigPackageTable."Table Name" <> '' THEN BEGIN
          RecordNodes := TableNode.SelectNodes(GetElementName(ConfigPackageTable."Table Name"));
          IF RecordNodes.Count > 0 THEN BEGIN
            RecordNode := RecordNodes.Item(0);
            IF RecordNode.HasChildNodes THEN BEGIN
              ConfigPackageMgt.SetFieldFilter(Field,TableID,0);
              IF Field.FINDSET THEN
                REPEAT
                  IF FieldNodeExists(RecordNode,GetElementName(Field.FieldName)) THEN BEGIN
                    ConfigPackageField.GET(PackageCode,TableID,Field."No.");
                    ConfigPackageField."Primary Key" := ConfigValidateMgt.IsKeyField(TableID,Field."No.");
                    ConfigPackageField."Include Field" := TRUE;
                    FieldNode := RecordNode.SelectSingleNode(GetElementName(Field.FieldName));
                    IF NOT ISNULL(FieldNode) AND NOT ExcelMode THEN BEGIN
                      Value := GetAttribute(GetElementName(ConfigPackageField.FIELDNAME("Primary Key")),FieldNode);
                      ConfigPackageField."Primary Key" := Value = '1';
                      Value := GetAttribute(GetElementName(ConfigPackageField.FIELDNAME("Validate Field")),FieldNode);
                      ConfigPackageField."Validate Field" := (Value = '1') AND
                        NOT ConfigPackageMgt.ValidateException(TableID,Field."No.");
                      Value := GetAttribute(GetElementName(ConfigPackageField.FIELDNAME("Create Missing Codes")),FieldNode);
                      ConfigPackageField."Create Missing Codes" := (Value = '1') AND
                        NOT ConfigPackageMgt.ValidateException(TableID,Field."No.");
                      Value := GetAttribute(GetElementName(ConfigPackageField.FIELDNAME("Processing Order")),FieldNode);
                      IF Value <> '' THEN
                        EVALUATE(ConfigPackageField."Processing Order",Value);
                    END;
                    ConfigPackageField.MODIFY;
                  END;
                UNTIL Field.NEXT = 0;
            END;
          END;
        END;
      END;
    END;

    LOCAL PROCEDURE FillPackageDataFromXML@54(PackageCode@1012 : Code[20];TableID@1000 : Integer;VAR TableNode@1007 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode");
    VAR
      ConfigPackageTable@1002 : Record 8613;
      ConfigPackageData@1001 : Record 8615;
      ConfigPackageRecord@1009 : Record 8614;
      ConfigPackageField@1010 : Record 8616;
      ConfigProgressBarRecord@1013 : Codeunit 8615;
      RecRef@1004 : RecordRef;
      FieldRef@1003 : FieldRef;
      RecordNodes@1006 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNodeList";
      RecordNode@1005 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      NodeCount@1008 : Integer;
      RecordCount@1014 : Integer;
      StepCount@1015 : Integer;
      ErrorText@1011 : Text[250];
    BEGIN
      IF ConfigPackageTable.GET(PackageCode,TableID) THEN BEGIN
        IF ExcelMode THEN BEGIN
          ConfigPackageTable.CALCFIELDS("No. of Package Records");
          IF ConfigPackageTable."No. of Package Records" > 0 THEN
            IF CONFIRM(TableContainsRecordsQst,TRUE,TableID,PackageCode,ConfigPackageTable."No. of Package Records") THEN
              ConfigPackageTable.DeletePackageData
            ELSE
              EXIT;
        END;
        ConfigPackageTable.CALCFIELDS("Table Name");
        IF NOT HideDialog THEN
          ConfigProgressBar.Update(ConfigPackageTable."Table Name");
        RecordNodes := TableNode.SelectNodes(GetElementName(ConfigPackageTable."Table Name"));
        RecordCount := RecordNodes.Count;

        IF NOT HideDialog AND (RecordCount > 1000) THEN BEGIN
          StepCount := ROUND(RecordCount / 100,1);
          ConfigProgressBarRecord.Init(RecordCount,StepCount,
            STRSUBSTNO(RecordProgressTxt,ConfigPackageTable."Table Name"));
        END;
        FOR NodeCount := 0 TO RecordCount - 1 DO BEGIN
          RecordNode := RecordNodes.Item(NodeCount);
          IF RecordNode.HasChildNodes THEN BEGIN
            ConfigPackageMgt.InitPackageRecord(ConfigPackageRecord,PackageCode,ConfigPackageTable."Table ID");

            RecRef.CLOSE;
            RecRef.OPEN(ConfigPackageTable."Table ID");
            ConfigPackageField.SETRANGE("Package Code",ConfigPackageTable."Package Code");
            ConfigPackageField.SETRANGE("Table ID",ConfigPackageTable."Table ID");
            ConfigPackageField.SETRANGE("Include Field",TRUE);
            IF ConfigPackageField.FINDSET THEN
              REPEAT
                ConfigPackageData.INIT;
                ConfigPackageData."Package Code" := ConfigPackageField."Package Code";
                ConfigPackageData."Table ID" := ConfigPackageField."Table ID";
                ConfigPackageData."Field ID" := ConfigPackageField."Field ID";
                ConfigPackageData."No." := ConfigPackageRecord."No.";
                IF FieldNodeExists(RecordNode,GetElementName(ConfigPackageField."Field Name")) OR ConfigPackageField.Dimension THEN
                  GetConfigPackageDataValue(ConfigPackageData,RecordNode,GetElementName(ConfigPackageField."Field Name"));
                ConfigPackageData.INSERT;

                IF NOT ConfigPackageField.Dimension THEN BEGIN
                  FieldRef := RecRef.FIELD(ConfigPackageData."Field ID");
                  IF ConfigPackageData.Value <> '' THEN BEGIN
                    ErrorText := ConfigValidateMgt.EvaluateValue(FieldRef,ConfigPackageData.Value,NOT ExcelMode);
                    IF ErrorText <> '' THEN
                      ConfigPackageMgt.FieldError(ConfigPackageData,ErrorText,ErrorTypeEnum::General)
                    ELSE
                      ConfigPackageData.Value := FORMAT(FieldRef.VALUE);

                    ConfigPackageData.MODIFY;
                  END;
                END;
              UNTIL ConfigPackageField.NEXT = 0;
            ConfigPackageTable."Imported Date and Time" := CURRENTDATETIME;
            ConfigPackageTable."Imported by User ID" := USERID;
            ConfigPackageTable.MODIFY;
            IF NOT HideDialog AND (RecordCount > 1000) THEN
              ConfigProgressBarRecord.Update(
                STRSUBSTNO('Records: %1 of %2',ConfigPackageRecord."No.",RecordCount));
          END;
        END;
        IF NOT HideDialog AND (RecordCount > 1000) THEN
          ConfigProgressBarRecord.Close;
      END;
    END;

    LOCAL PROCEDURE FieldNodeExists@36(VAR RecordNode@1100 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";FieldNodeName@1001 : Text[250]) : Boolean;
    VAR
      FieldNode@1101 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
    BEGIN
      FieldNode := RecordNode.SelectSingleNode(FieldNodeName);

      IF NOT ISNULL(FieldNode) THEN
        EXIT(TRUE);
    END;

    LOCAL PROCEDURE FormatFieldValue@9(VAR FieldRef@1001 : FieldRef;ConfigPackage@1000 : Record 8623) InnerText : Text;
    VAR
      TypeHelper@1002 : Codeunit 10;
      Date@1003 : Date;
    BEGIN
      IF NOT (((FORMAT(FieldRef.TYPE) = 'Integer') OR (FORMAT(FieldRef.TYPE) = 'BLOB')) AND
              (FieldRef.RELATION <> 0) AND (FORMAT(FieldRef.VALUE) = '0'))
      THEN
        InnerText := FORMAT(FieldRef.VALUE,0,ConfigValidateMgt.XMLFormat);

      IF NOT ExcelMode THEN BEGIN
        IF (FORMAT(FieldRef.TYPE) = 'Boolean') OR (FORMAT(FieldRef.TYPE) = 'Option') THEN
          InnerText := FORMAT(FieldRef.VALUE,0,2);
        IF (FORMAT(FieldRef.TYPE) = 'DateFormula') AND (FORMAT(FieldRef.VALUE) <> '') THEN
          InnerText := '<' + FORMAT(FieldRef.VALUE,0,ConfigValidateMgt.XMLFormat) + '>';
        IF FORMAT(FieldRef.TYPE) = 'BLOB' THEN
          InnerText := ConvertBLOBToBase64String(FieldRef);
        IF FORMAT(FieldRef.TYPE) = 'MediaSet' THEN
          InnerText := ExportMediaSet(FieldRef);
        IF FORMAT(FieldRef.TYPE) = 'Media' THEN
          InnerText := ExportMedia(FieldRef,ConfigPackage);
      END ELSE BEGIN
        IF FORMAT(FieldRef.TYPE) = 'Option' THEN
          InnerText := FORMAT(FieldRef.VALUE);
        IF (FORMAT(FieldRef.TYPE) = 'Date') AND (ConfigPackage."Language ID" <> 0) AND (InnerText <> '') THEN BEGIN
          EVALUATE(Date,FORMAT(FieldRef.VALUE));
          InnerText := TypeHelper.FormatDate(Date,ConfigPackage."Language ID");
        END;
      END;

      EXIT(InnerText);
    END;

    [External]
    PROCEDURE GetAttribute@2(AttributeName@1001 : Text[1024];VAR XMLNode@1000 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode") : Text[1000];
    VAR
      XMLAttributes@1002 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNamedNodeMap";
      XMLAttributeNode@1003 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
    BEGIN
      XMLAttributes := XMLNode.Attributes;
      XMLAttributeNode := XMLAttributes.GetNamedItem(AttributeName);
      IF ISNULL(XMLAttributeNode) THEN
        EXIT('');
      EXIT(FORMAT(XMLAttributeNode.InnerText));
    END;

    LOCAL PROCEDURE GetDimValueFromTable@13(VAR RecRef@1000 : RecordRef;DimCode@1001 : Code[20]) : Code[20];
    VAR
      DimSetEntry@1002 : Record 480;
      DefaultDim@1003 : Record 352;
      ConfigMgt@1007 : Codeunit 8616;
      FieldRef@1004 : FieldRef;
      DimSetID@1005 : Integer;
      MasterNo@1006 : Code[20];
    BEGIN
      IF RecRef.FIELDEXIST(480) THEN BEGIN // Dimension Set ID
        FieldRef := RecRef.FIELD(480);
        DimSetID := FieldRef.VALUE;
        IF DimSetID > 0 THEN BEGIN
          DimSetEntry.SETRANGE("Dimension Set ID",DimSetID);
          DimSetEntry.SETRANGE("Dimension Code",DimCode);
          IF DimSetEntry.FINDFIRST THEN
            EXIT(DimSetEntry."Dimension Value Code");
        END;
      END ELSE
        IF ConfigMgt.IsDefaultDimTable(RecRef.NUMBER) THEN BEGIN // Default Dimensions
          FieldRef := RecRef.FIELD(1);
          DefaultDim.SETRANGE("Table ID",RecRef.NUMBER);
          MasterNo := FORMAT(FieldRef.VALUE);
          DefaultDim.SETRANGE("No.",MasterNo);
          DefaultDim.SETRANGE("Dimension Code",DimCode);
          IF DefaultDim.FINDFIRST THEN
            EXIT(DefaultDim."Dimension Value Code");
        END;
    END;

    [External]
    PROCEDURE GetElementName@22(NameIn@1000 : Text[250]) : Text[250];
    VAR
      XMLDOMManagement@1001 : Codeunit 6224;
    BEGIN
      IF NOT XMLDOMManagement.IsValidXMLNameStartCharacter(NameIn[1]) THEN
        NameIn := '_' + NameIn;
      NameIn := COPYSTR(XMLDOMManagement.ReplaceXMLInvalidCharacters(NameIn,' '),1,MAXSTRLEN(NameIn));
      NameIn := DELCHR(NameIn,'=','?''`');
      NameIn := DELCHR(CONVERTSTR(NameIn,'<>,./\+-&()%:','             '),'=',' ');
      NameIn := DELCHR(NameIn,'=',' ');
      EXIT(NameIn);
    END;

    [External]
    PROCEDURE GetFieldElementName@120(NameIn@1000 : Text[250]) : Text[250];
    BEGIN
      IF AddPrefixMode THEN
        NameIn := COPYSTR('Field_' + NameIn,1,MAXSTRLEN(NameIn));

      EXIT(GetElementName(NameIn));
    END;

    [External]
    PROCEDURE GetTableElementName@124(NameIn@1000 : Text[250]) : Text[250];
    BEGIN
      IF AddPrefixMode THEN
        NameIn := COPYSTR('Table_' + NameIn,1,MAXSTRLEN(NameIn));

      EXIT(GetElementName(NameIn));
    END;

    LOCAL PROCEDURE GetNodeValue@26(VAR RecordNode@1100 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";FieldNodeName@1001 : Text[250]) : Text;
    VAR
      FieldNode@1101 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
    BEGIN
      FieldNode := RecordNode.SelectSingleNode(FieldNodeName);
      IF NOT ISNULL(FieldNode) THEN
        EXIT(FieldNode.InnerText);
    END;

    LOCAL PROCEDURE GetPackageTag@8() : Text;
    BEGIN
      EXIT(DataListTxt);
    END;

    [External]
    PROCEDURE GetPackageCode@20(PackageXML@1000 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlDocument") : Code[20];
    VAR
      ConfigPackage@1002 : Record 8623;
      DocumentElement@1001 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlElement";
    BEGIN
      DocumentElement := PackageXML.DocumentElement;
      EXIT(COPYSTR(GetAttribute(GetElementName(ConfigPackage.FIELDNAME(Code)),DocumentElement),1,MAXSTRLEN(ConfigPackage.Code)));
    END;

    LOCAL PROCEDURE InitializeMediaTempFolder@30();
    VAR
      MediaFolder@1000 : Text;
    BEGIN
      IF ExcelMode THEN
        EXIT;

      IF WorkingFolder = '' THEN
        EXIT;

      MediaFolder := GetCurrentMediaFolderPath;
      IF FileManagement.ServerDirectoryExists(MediaFolder) THEN
        FileManagement.ServerRemoveDirectory(MediaFolder,TRUE);

      FileManagement.ServerCreateDirectory(MediaFolder);
    END;

    LOCAL PROCEDURE GetCurrentMediaFolderPath@49() : Text;
    BEGIN
      EXIT(FileManagement.CombinePath(WorkingFolder,GetMediaFolderName));
    END;

    [Internal]
    PROCEDURE GetMediaFolder@37(VAR MediaFolderPath@1000 : Text;SourcePath@1001 : Text) : Boolean;
    VAR
      SourceDirectory@1002 : Text;
    BEGIN
      IF FileManagement.ServerFileExists(SourcePath) THEN
        SourceDirectory := FileManagement.GetDirectoryName(SourcePath)
      ELSE
        IF FileManagement.ServerDirectoryExists(SourcePath) THEN
          SourceDirectory := SourcePath;

      IF SourceDirectory = '' THEN
        EXIT(FALSE);

      MediaFolderPath := FileManagement.CombinePath(SourceDirectory,GetMediaFolderName);
      EXIT(FileManagement.ServerDirectoryExists(MediaFolderPath));
    END;

    [External]
    PROCEDURE GetMediaFolderName@31() : Text;
    BEGIN
      EXIT('Media');
    END;

    [External]
    PROCEDURE GetXSDType@3(TableID@1000 : Integer;FieldID@1001 : Integer) : Text[30];
    VAR
      Field@1002 : Record 2000000041;
    BEGIN
      IF Field.GET(TableID,FieldID) THEN
        CASE Field.Type OF
          Field.Type::Integer:
            EXIT('xsd:integer');
          Field.Type::Date:
            EXIT('xsd:date');
          Field.Type::Time:
            EXIT('xsd:time');
          Field.Type::Boolean:
            EXIT('xsd:boolean');
          Field.Type::DateTime:
            EXIT('xsd:dateTime');
          ELSE
            EXIT('xsd:string');
        END;

      EXIT('xsd:string');
    END;

    [External]
    PROCEDURE SetAdvanced@34(NewAdvanced@1000 : Boolean);
    BEGIN
      Advanced := NewAdvanced;
    END;

    [External]
    PROCEDURE SetCalledFromCode@1013(NewCalledFromCode@1000 : Boolean);
    BEGIN
      CalledFromCode := NewCalledFromCode;
    END;

    LOCAL PROCEDURE SetWorkingFolder@44(NewWorkingFolder@1000 : Text);
    BEGIN
      WorkingFolder := NewWorkingFolder;
    END;

    [External]
    PROCEDURE SetExcelMode@21(NewExcelMode@1000 : Boolean);
    BEGIN
      ExcelMode := NewExcelMode;
    END;

    [External]
    PROCEDURE SetHideDialog@1(NewHideDialog@1000 : Boolean);
    BEGIN
      HideDialog := NewHideDialog;
    END;

    [External]
    PROCEDURE SetExportFromWksht@17(NewExportFromWksht@1000 : Boolean);
    BEGIN
      ExportFromWksht := NewExportFromWksht;
    END;

    [External]
    PROCEDURE SetPrefixMode@125(PrefixMode@1000 : Boolean);
    BEGIN
      AddPrefixMode := PrefixMode;
    END;

    [External]
    PROCEDURE TableObjectExists@18(TableId@1000 : Integer) : Boolean;
    VAR
      AllObj@1001 : Record 2000000038;
    BEGIN
      EXIT(AllObj.GET(AllObj."Object Type"::Table,TableId));
    END;

    [Internal]
    PROCEDURE DecompressPackage@6(ServerFileName@1000 : Text) DecompressedFileName : Text;
    BEGIN
      DecompressedFileName := FileManagement.ServerTempFileName('');
      IF NOT ConfigPckgCompressionMgt.ServersideDecompress(ServerFileName,DecompressedFileName) THEN
        ERROR(WrongFileTypeErr);
    END;

    LOCAL PROCEDURE UploadXMLPackage@23(ServerFileName@1000 : Text) : Boolean;
    BEGIN
      EXIT(UPLOAD(ImportFileTxt,'',GetFileDialogFilter,'',ServerFileName));
    END;

    [External]
    PROCEDURE GetFileDialogFilter@15() : Text;
    BEGIN
      EXIT(FileDialogFilterTxt);
    END;

    LOCAL PROCEDURE ConvertBLOBToBase64String@25(VAR FieldRef@1000 : FieldRef) : Text;
    VAR
      TempBlob@1001 : Record 99008535;
    BEGIN
      FieldRef.CALCFIELD;
      TempBlob.Blob := FieldRef.VALUE;
      EXIT(TempBlob.ToBase64String);
    END;

    LOCAL PROCEDURE ExportMediaSet@29(VAR FieldRef@1000 : FieldRef) : Text;
    VAR
      TempConfigMediaBuffer@1004 : TEMPORARY Record 8630;
      FilesExported@1003 : Integer;
      ItemPrefixPath@1002 : Text;
      MediaFolder@1001 : Text;
    BEGIN
      IF ExcelMode THEN
        EXIT;

      IF NOT GetMediaFolder(MediaFolder,WorkingFolder) THEN
        EXIT('');

      TempConfigMediaBuffer.INIT;
      TempConfigMediaBuffer."Media Set" := FieldRef.VALUE;
      TempConfigMediaBuffer.INSERT;
      IF TempConfigMediaBuffer."Media Set".COUNT = 0 THEN
        EXIT;

      ItemPrefixPath := MediaFolder + '\' + FORMAT(TempConfigMediaBuffer."Media Set");
      FilesExported := TempConfigMediaBuffer."Media Set".EXPORTFILE(ItemPrefixPath);
      IF FilesExported <= 0 THEN
        EXIT('');

      EXIT(FORMAT(FieldRef.VALUE));
    END;

    LOCAL PROCEDURE ExportMedia@27(VAR FieldRef@1000 : FieldRef;ConfigPackage@1002 : Record 8623) : Text;
    VAR
      ConfigMediaBuffer@1001 : Record 8630;
      TempConfigMediaBuffer@1003 : TEMPORARY Record 8630;
      MediaOutStream@1004 : OutStream;
      MediaIDGuidText@1005 : Text;
      BlankGuid@1006 : GUID;
    BEGIN
      IF ExcelMode THEN
        EXIT;

      MediaIDGuidText := FORMAT(FieldRef.VALUE);
      IF (MediaIDGuidText = '') OR (MediaIDGuidText = FORMAT(BlankGuid)) THEN
        EXIT;

      ConfigMediaBuffer.INIT;
      ConfigMediaBuffer."Package Code" := ConfigPackage.Code;
      ConfigMediaBuffer."No." := ConfigMediaBuffer.GetNextNo;
      ConfigMediaBuffer."Media ID" := MediaIDGuidText;
      ConfigMediaBuffer.INSERT;

      ConfigMediaBuffer."Media Blob".CREATEOUTSTREAM(MediaOutStream);

      TempConfigMediaBuffer.INIT;
      TempConfigMediaBuffer.Media := FieldRef.VALUE;
      TempConfigMediaBuffer.INSERT;
      TempConfigMediaBuffer.Media.EXPORTSTREAM(MediaOutStream);

      ConfigMediaBuffer.MODIFY;

      EXIT(MediaIDGuidText);
    END;

    LOCAL PROCEDURE GetConfigPackageDataValue@28(VAR ConfigPackageData@1002 : Record 8615;VAR RecordNode@1001 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";FieldNodeName@1000 : Text[250]);
    VAR
      TempBlob@1003 : Record 99008535;
    BEGIN
      IF ConfigPackageMgt.IsBLOBField(ConfigPackageData."Table ID",ConfigPackageData."Field ID") AND NOT ExcelMode THEN BEGIN
        TempBlob.FromBase64String(GetNodeValue(RecordNode,FieldNodeName));
        ConfigPackageData."BLOB Value" := TempBlob.Blob;
      END ELSE
        ConfigPackageData.Value := COPYSTR(GetNodeValue(RecordNode,FieldNodeName),1,MAXSTRLEN(ConfigPackageData.Value));
    END;

    LOCAL PROCEDURE UpdateConfigPackageMediaSet@40(ConfigPackage@1001 : Record 8623);
    VAR
      TempNameValueBuffer@1007 : TEMPORARY Record 823;
      FileManagement@1006 : Codeunit 419;
      MediaFolder@1002 : Text;
    BEGIN
      IF NOT GetMediaFolder(MediaFolder,WorkingFolder) THEN
        EXIT;

      FileManagement.GetServerDirectoryFilesList(TempNameValueBuffer,MediaFolder);
      IF NOT TempNameValueBuffer.FINDSET THEN
        EXIT;

      REPEAT
        ImportMediaSetFromFile(ConfigPackage,TempNameValueBuffer.Name);
      UNTIL TempNameValueBuffer.NEXT = 0;

      FileManagement.ServerRemoveDirectory(MediaFolder,TRUE);
    END;

    LOCAL PROCEDURE ExportConfigPackageMediaSetToXML@51(VAR PackageXML@1004 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlDocument";ConfigPackage@1002 : Record 8623);
    VAR
      ConfigMediaBuffer@1000 : Record 8630;
      ConfigPackageTable@1003 : Record 8613;
      ConfigPackageManagement@1001 : Codeunit 8611;
    BEGIN
      IF ConfigMediaBuffer.ISEMPTY THEN
        EXIT;

      ConfigPackageManagement.InsertPackageTable(ConfigPackageTable,ConfigPackage.Code,DATABASE::"Config. Media Buffer");
      ConfigPackageTable.CALCFIELDS("Table Name");
      ExportConfigTableToXML(ConfigPackageTable,PackageXML);
    END;

    LOCAL PROCEDURE ImportMediaSetFromFile@67(ConfigPackage@1005 : Record 8623;FileName@1000 : Text);
    VAR
      TempBlob@1002 : TEMPORARY Record 99008535;
      ConfigMediaBuffer@1004 : Record 8630;
      FileManagement@1001 : Codeunit 419;
      DummyGuid@1003 : GUID;
    BEGIN
      ConfigMediaBuffer.INIT;
      FileManagement.BLOBImportFromServerFile(TempBlob,FileName);
      ConfigMediaBuffer."Media Blob" := TempBlob.Blob;
      ConfigMediaBuffer."Package Code" := ConfigPackage.Code;
      ConfigMediaBuffer."Media Set ID" := COPYSTR(FileManagement.GetFileNameWithoutExtension(FileName),1,STRLEN(FORMAT(DummyGuid)));
      ConfigMediaBuffer."No." := ConfigMediaBuffer.GetNextNo;
      ConfigMediaBuffer.INSERT;
    END;

    LOCAL PROCEDURE CleanUpConfigPackageData@39(ConfigPackage@1000 : Record 8623);
    VAR
      ConfigMediaBuffer@1001 : Record 8630;
    BEGIN
      ConfigMediaBuffer.SETRANGE("Package Code",ConfigPackage.Code);
      ConfigMediaBuffer.DELETEALL;
    END;

    BEGIN
    END.
  }
}

