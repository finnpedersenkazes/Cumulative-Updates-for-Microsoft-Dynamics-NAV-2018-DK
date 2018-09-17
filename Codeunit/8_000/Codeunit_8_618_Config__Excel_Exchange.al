OBJECT Codeunit 8618 Config. Excel Exchange
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
      ConfigPackage@1019 : Record 8623;
      ConfigXMLExchange@1006 : Codeunit 8614;
      FileMgt@1003 : Codeunit 419;
      ConfigProgressBar@1004 : Codeunit 8615;
      ConfigValidateMgt@1021 : Codeunit 8617;
      TypeHelper@1027 : Codeunit 10;
      CannotCreateXmlSchemaErr@1016 : TextConst 'DAN=XML-skemaet kunne ikke oprettes.;ENU=Could not create XML Schema.';
      CreatingExcelMsg@1011 : TextConst 'DAN=Opretter Excel-regneark;ENU=Creating Excel worksheet';
      WrkbkReader@1000 : DotNet "'Microsoft.Dynamics.Nav.OpenXml, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.OpenXml.Spreadsheet.WorkbookReader";
      WrkbkWriter@1002 : DotNet "'Microsoft.Dynamics.Nav.OpenXml, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.OpenXml.Spreadsheet.WorkbookWriter";
      WrkShtWriter@1007 : DotNet "'Microsoft.Dynamics.Nav.OpenXml, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.OpenXml.Spreadsheet.WorksheetWriter";
      Worksheet@1025 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.Worksheet";
      Workbook@1026 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.Workbook";
      WorkBookPart@1030 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Packaging.WorkbookPart";
      CreateWrkBkFailedErr@1033 : TextConst 'DAN=Excel-regnearket kunne ikke oprettes.;ENU=Could not create the Excel workbook.';
      WrkShtHelper@1001 : DotNet "'Microsoft.Dynamics.Nav.OpenXml, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.OpenXml.Spreadsheet.WorksheetHelper";
      DataSet@1038 : DotNet "'System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Data.DataSet";
      DataTable@1037 : DotNet "'System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Data.DataTable";
      DataColumn@1040 : DotNet "'System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Data.DataColumn";
      StringBld@1014 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Text.StringBuilder";
      id@1013 : BigInteger;
      HideDialog@1005 : Boolean;

      CommentVmlShapeXmlTxt@1012 : TextConst
        '@@@={Locked}',
        'DAN="<v:shape id=""%1"" type=""#_x0000_t202"" style=''position:absolute;  margin-left:59.25pt;margin-top:1.5pt;width:96pt;height:55.5pt;z-index:1;  visibility:hidden'' fillcolor=""#ffffe1"" o:insetmode=""auto""><v:fill color2=""#ffffe1""/><v:shadow color=""black"" obscured=""t""/><v:path o:connecttype=""none""/><v:textbox style=''mso-direction-alt:auto''><div style=''text-align:left''/></v:textbox><x:ClientData ObjectType=""Note""><x:MoveWithCells/><x:SizeWithCells/><x:Anchor>%2</x:Anchor><x:AutoFill>False</x:AutoFill><x:Row>%3</x:Row><x:Column>%4</x:Column></x:ClientData></v:shape>"',
        'ENU="<v:shape id=""%1"" type=""#_x0000_t202"" style=''position:absolute;  margin-left:59.25pt;margin-top:1.5pt;width:96pt;height:55.5pt;z-index:1;  visibility:hidden'' fillcolor=""#ffffe1"" o:insetmode=""auto""><v:fill color2=""#ffffe1""/><v:shadow color=""black"" obscured=""t""/><v:path o:connecttype=""none""/><v:textbox style=''mso-direction-alt:auto''><div style=''text-align:left''/></v:textbox><x:ClientData ObjectType=""Note""><x:MoveWithCells/><x:SizeWithCells/><x:Anchor>%2</x:Anchor><x:AutoFill>False</x:AutoFill><x:Row>%3</x:Row><x:Column>%4</x:Column></x:ClientData></v:shape>"';
      VmlDrawingXmlTxt@1015 : TextConst '@@@={Locked};DAN="<xml xmlns:v=""urn:schemas-microsoft-com:vml"" xmlns:o=""urn:schemas-microsoft-com:office:office"" xmlns:x=""urn:schemas-microsoft-com:office:excel""><o:shapelayout v:ext=""edit""><o:idmap v:ext=""edit"" data=""1""/></o:shapelayout><v:shapetype id=""_x0000_t202"" coordsize=""21600,21600"" o:spt=""202""  path=""m,l,21600r21600,l21600,xe""><v:stroke joinstyle=""miter""/><v:path gradientshapeok=""t"" o:connecttype=""rect""/></v:shapetype>";ENU="<xml xmlns:v=""urn:schemas-microsoft-com:vml"" xmlns:o=""urn:schemas-microsoft-com:office:office"" xmlns:x=""urn:schemas-microsoft-com:office:excel""><o:shapelayout v:ext=""edit""><o:idmap v:ext=""edit"" data=""1""/></o:shapelayout><v:shapetype id=""_x0000_t202"" coordsize=""21600,21600"" o:spt=""202""  path=""m,l,21600r21600,l21600,xe""><v:stroke joinstyle=""miter""/><v:path gradientshapeok=""t"" o:connecttype=""rect""/></v:shapetype>"';
      EndXmlTokenTxt@1017 : TextConst '@@@={Locked};DAN=</xml>;ENU=</xml>';
      VmlShapeAnchorTxt@1018 : TextConst '@@@={Locked};DAN=%1,15,%2,10,%3,31,8,9;ENU=%1,15,%2,10,%3,31,8,9';
      FileExtensionFilterTok@1008 : TextConst 'DAN=Excel-filer (*.xlsx)|*.xlsx|Alle filer (*.*)|*.*;ENU=Excel Files (*.xlsx)|*.xlsx|All Files (*.*)|*.*';
      ExcelFileNameTok@1009 : TextConst '@@@="%1 = String generated from current datetime to make sure file names are unique ";DAN=*%1.xlsx;ENU=*%1.xlsx';
      ExcelFileExtensionTok@1010 : TextConst 'DAN=.xlsx;ENU=.xlsx';
      InvalidDataInSheetMsg@1020 : TextConst '@@@="%1=excel sheet name";DAN=Data p� arket ''%1'' kunne ikke importeres, fordi arket har et uventet format.;ENU=Data in sheet ''%1'' could not be imported, because the sheet has an unexpected format.';
      ImportFromExcelTxt@1022 : TextConst 'DAN=Indl�s fra Excel;ENU=Import from Excel';
      FileOnServer@1024 : Boolean;

    [Internal]
    PROCEDURE ExportExcelFromConfig@19(VAR ConfigLine@1006 : Record 8622) : Text;
    VAR
      ConfigPackageTable@1005 : Record 8613;
      ConfigMgt@1000 : Codeunit 8616;
      FileName@1001 : Text;
      Filter@1003 : Text;
    BEGIN
      ConfigLine.FINDFIRST;
      ConfigPackageTable.SETRANGE("Package Code",ConfigLine."Package Code");
      Filter := ConfigMgt.MakeTableFilter(ConfigLine,TRUE);
      IF Filter <> '' THEN
        ConfigPackageTable.SETFILTER("Table ID",Filter);

      ConfigPackageTable.SETRANGE("Dimensions as Columns",TRUE);
      IF ConfigPackageTable.FINDSET THEN
        REPEAT
          IF NOT (ConfigPackageTable.DimensionPackageDataExist OR (ConfigPackageTable.DimensionFieldsCount > 0)) THEN
            ConfigPackageTable.InitDimensionFields;
        UNTIL ConfigPackageTable.NEXT = 0;
      ConfigPackageTable.SETRANGE("Dimensions as Columns");
      ExportExcel(FileName,ConfigPackageTable,TRUE,FALSE);
      EXIT(FileName);
    END;

    [Internal]
    PROCEDURE ExportExcelFromPackage@20(ConfigPackage@1000 : Record 8623) : Boolean;
    VAR
      ConfigPackageTable@1006 : Record 8613;
      FileName@1001 : Text;
    BEGIN
      ConfigPackageTable.SETRANGE("Package Code",ConfigPackage.Code);
      EXIT(ExportExcel(FileName,ConfigPackageTable,FALSE,FALSE));
    END;

    [Internal]
    PROCEDURE ExportExcelFromTables@3(VAR ConfigPackageTable@1000 : Record 8613) : Boolean;
    VAR
      FileName@1001 : Text;
    BEGIN
      EXIT(ExportExcel(FileName,ConfigPackageTable,FALSE,FALSE));
    END;

    [Internal]
    PROCEDURE ExportExcelTemplateFromTables@21(VAR ConfigPackageTable@1000 : Record 8613) : Boolean;
    VAR
      FileName@1001 : Text;
    BEGIN
      EXIT(ExportExcel(FileName,ConfigPackageTable,FALSE,TRUE));
    END;

    [Internal]
    PROCEDURE ExportExcel@13(VAR FileName@1025 : Text;VAR ConfigPackageTable@1001 : Record 8613;ExportFromWksht@1010 : Boolean;SkipData@1002 : Boolean) : Boolean;
    VAR
      TempBlob@1007 : Record 99008535;
      VmlDrawingPart@1024 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Packaging.VmlDrawingPart";
      TableDefinitionPart@1018 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Packaging.TableDefinitionPart";
      TableParts@1027 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.TableParts";
      TablePart@1040 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.TablePart";
      SingleXMLCells@1033 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.SingleXmlCells";
      XmlTextWriter@1015 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlTextWriter";
      FileMode@1014 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.FileMode";
      Encoding@1011 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Text.Encoding";
      TempSetupDataFileName@1000 : Text;
      TempSchemaFileName@1004 : Text;
      DataTableCounter@1012 : Integer;
    BEGIN
      OnBeforeExportExcel(ConfigPackageTable);

      TempSchemaFileName := CreateSchemaFile(ConfigPackageTable);
      TempSetupDataFileName := BuildDataSetForPackageTable(ExportFromWksht,ConfigPackageTable);

      CreateBook(TempBlob);
      WrkShtHelper := WrkShtHelper.WorksheetHelper(WrkbkWriter.FirstWorksheet.Worksheet);
      ImportSchema(WrkbkWriter,TempSchemaFileName,1);
      CreateSchemaConnection(WrkbkWriter,TempSetupDataFileName);

      DataTableCounter := 1;

      IF NOT HideDialog THEN
        ConfigProgressBar.Init(ConfigPackageTable.COUNT,1,CreatingExcelMsg);

      DataTable := DataSet.Tables.Item(1);

      IF ConfigPackageTable.FINDSET THEN
        REPEAT
          IF ISNULL(StringBld) THEN BEGIN
            StringBld := StringBld.StringBuilder;
            StringBld.Append(VmlDrawingXmlTxt);
          END;

          ConfigPackageTable.CALCFIELDS("Table Caption");
          IF NOT HideDialog THEN
            ConfigProgressBar.Update(ConfigPackageTable."Table Caption");

          // Initialize WorkSheetWriter
          IF id < 1 THEN BEGIN
            WrkShtWriter := WrkbkWriter.FirstWorksheet;
            WrkShtWriter.Name := DELCHR(ConfigPackageTable."Table Caption",'=','/');
          END ELSE
            WrkShtWriter := WrkbkWriter.AddWorksheet(ConfigPackageTable."Table Caption");
          Worksheet := WrkShtWriter.Worksheet;

          // Add and initialize SingleCellTable part
          WrkShtWriter.AddSingleCellTablePart;
          SingleXMLCells := SingleXMLCells.SingleXmlCells;
          Worksheet.WorksheetPart.SingleCellTablePart.SingleXmlCells := SingleXMLCells;
          id += 3;

          AddAndInitializeCommentsPart(VmlDrawingPart);
          AddPackageAndTableInformation(ConfigPackageTable,SingleXMLCells);
          AddAndInitializeTableDefinitionPart(ConfigPackageTable,ExportFromWksht,DataTableCounter,TableDefinitionPart,SkipData);
          IF NOT SkipData THEN
            CopyDataToExcelTable;

          DataTableCounter += 2;
          TableParts := WrkShtWriter.CreateTableParts(1);
          WrkShtHelper.AppendElementToOpenXmlElement(Worksheet,TableParts);
          TablePart := WrkShtWriter.CreateTablePart(Worksheet.WorksheetPart.GetIdOfPart(TableDefinitionPart));
          WrkShtHelper.AppendElementToOpenXmlElement(TableParts,TablePart);

          StringBld.Append(EndXmlTokenTxt);

          XmlTextWriter := XmlTextWriter.XmlTextWriter(VmlDrawingPart.GetStream(FileMode.Create),Encoding.UTF8);
          XmlTextWriter.WriteRaw(StringBld.ToString);
          XmlTextWriter.Flush;
          XmlTextWriter.Close;

          CLEAR(StringBld);

        UNTIL ConfigPackageTable.NEXT = 0;

      FILE.ERASE(TempSchemaFileName);
      FILE.ERASE(TempSetupDataFileName);

      CleanMapInfo(WrkbkWriter.Workbook.WorkbookPart.CustomXmlMappingsPart.MapInfo);
      WrkbkWriter.Workbook.Save;
      WrkbkWriter.Close;
      ClearOpenXmlVariables;

      IF NOT HideDialog THEN
        ConfigProgressBar.Close;

      IF FileName = '' THEN
        FileName :=
          STRSUBSTNO(ExcelFileNameTok,FORMAT(CURRENTDATETIME,0,'<Day,2>_<Month,2>_<Year4>_<Hours24>_<Minutes,2>_<Seconds,2>'));

      IF NOT FileOnServer THEN
        FileName := FileMgt.BLOBExport(TempBlob,FileName,NOT HideDialog)
      ELSE
        FileMgt.BLOBExportToServerFile(TempBlob,FileName);

      EXIT(FileName <> '');
    END;

    [Internal]
    PROCEDURE ImportExcelFromConfig@16(ConfigLine@1000 : Record 8622);
    VAR
      TempBlob@1001 : Record 99008535;
    BEGIN
      ConfigLine.TESTFIELD("Line Type",ConfigLine."Line Type"::Table);
      ConfigLine.TESTFIELD("Table ID");
      IF ConfigPackage.GET(ConfigLine."Package Code") AND
         (FileMgt.BLOBImportWithFilter(TempBlob,ImportFromExcelTxt,'',FileExtensionFilterTok,ExcelFileExtensionTok) <> '')
      THEN
        ImportExcel(TempBlob);
    END;

    [Internal]
    PROCEDURE ImportExcelFromPackage@18() : Boolean;
    VAR
      TempBlob@1002 : Record 99008535;
    BEGIN
      IF FileMgt.BLOBImportWithFilter(TempBlob,ImportFromExcelTxt,'',FileExtensionFilterTok,ExcelFileExtensionTok) <> '' THEN
        EXIT(ImportExcel(TempBlob));
      EXIT(FALSE)
    END;

    [Internal]
    PROCEDURE ImportExcel@24(VAR TempBlob@1000 : Record 99008535) Imported : Boolean;
    VAR
      TempXMLBuffer@1012 : TEMPORARY Record 1235;
      WrkShtReader@1010 : DotNet "'Microsoft.Dynamics.Nav.OpenXml, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.OpenXml.Spreadsheet.WorksheetReader";
      DataRow@1006 : DotNet "'System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Data.DataRow";
      DataRow2@1025 : DotNet "'System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Data.DataRow";
      Enumerator@1008 : DotNet "'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.IEnumerator";
      CellData@1003 : DotNet "'Microsoft.Dynamics.Nav.OpenXml, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.OpenXml.Spreadsheet.CellData";
      WorkBookPart@1001 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Packaging.WorkbookPart";
      Type@1002 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Type";
      InStream@1009 : InStream;
      XMLSchemaDataFile@1005 : Text;
      CellValueText@1004 : Text;
      ColumnCount@1016 : Integer;
      TotalColumnCount@1017 : Integer;
      WrkSheetId@1023 : Integer;
      DataColumnTableId@1024 : Integer;
      SheetCount@1022 : Integer;
      RowIn@1014 : Integer;
      SheetHeaderRead@1013 : Boolean;
      CurrentRowIndex@1007 : Integer;
      RowChanged@1011 : Boolean;
      FirstDataRow@1015 : Integer;
    BEGIN
      TempBlob.Blob.CREATEINSTREAM(InStream);
      WrkbkReader := WrkbkReader.Open(InStream);
      WorkBookPart := WrkbkReader.Workbook.WorkbookPart;
      XMLSchemaDataFile := ExtractXMLSchema(WorkBookPart);

      WrkSheetId := WrkbkReader.FirstSheetId;
      SheetCount := WorkBookPart.Workbook.Sheets.ChildElements.Count + WrkSheetId;
      DataSet := DataSet.DataSet;
      DataSet.ReadXmlSchema(XMLSchemaDataFile);

      WrkSheetId := WrkbkReader.FirstSheetId;
      DataColumnTableId := 0;
      REPEAT
        WrkShtReader := WrkbkReader.GetWorksheetById(FORMAT(WrkSheetId));

        IF InitColumnMapping(WrkShtReader,TempXMLBuffer) THEN BEGIN
          Enumerator := WrkShtReader.GetEnumerator;
          IF GetDataTable(DataColumnTableId) THEN BEGIN
            DataColumn := DataTable.Columns.Item(1);
            DataColumn.DataType := Type.GetType('System.String');
            DataTable.BeginLoadData;
            DataRow := DataTable.NewRow;
            SheetHeaderRead := FALSE;
            DataColumn := DataTable.Columns.Item(1);
            RowIn := 1;
            ColumnCount := 0;
            TotalColumnCount := 0;
            CurrentRowIndex := 1;
            FirstDataRow := 4;
            WHILE Enumerator.MoveNext DO BEGIN
              CellData := Enumerator.Current;
              CellValueText := CellData.Value;
              RowChanged := CurrentRowIndex <> CellData.RowNumber;
              IF NOT SheetHeaderRead THEN BEGIN // Read config and table information
                IF (CellData.RowNumber = 1) AND (CellData.ColumnNumber = 1) THEN
                  DataRow.Item(1,CellValueText);
                IF (CellData.RowNumber = 1) AND (CellData.ColumnNumber = 3) THEN BEGIN
                  DataColumn := DataTable.Columns.Item(0);
                  DataRow.Item(0,CellValueText);
                  DataTable.Rows.Add(DataRow);
                  DataColumn := DataTable.Columns.Item(2);
                  DataColumn.AllowDBNull(TRUE);
                  DataTable := DataSet.Tables.Item(DataColumnTableId + 1);
                  ColumnCount := 0;
                  TotalColumnCount := DataTable.Columns.Count - 1;
                  REPEAT
                    DataColumn := DataTable.Columns.Item(ColumnCount);
                    DataColumn.DataType := Type.GetType('System.String');
                    ColumnCount += 1;
                  UNTIL ColumnCount = TotalColumnCount;
                  ColumnCount := 0;
                  DataRow2 := DataTable.NewRow;
                  DataRow2.SetParentRow(DataRow);
                  SheetHeaderRead := TRUE;
                END;
              END ELSE BEGIN // Read data rows
                IF (RowIn = 1) AND (CellData.RowNumber >= FirstDataRow) AND (CellData.ColumnNumber = 1) THEN BEGIN
                  TotalColumnCount := ColumnCount;
                  ColumnCount := 0;
                  RowIn += 1;
                  FirstDataRow := CellData.RowNumber;
                END;

                IF RowChanged AND (CellData.RowNumber > FirstDataRow) AND (RowIn <> 1) THEN BEGIN
                  DataTable.Rows.Add(DataRow2);
                  DataTable.EndLoadData;
                  DataRow2 := DataTable.NewRow;
                  DataRow2.SetParentRow(DataRow);
                  RowIn += 1;
                  ColumnCount := 0;
                END;

                IF RowIn <> 1 THEN
                  IF TempXMLBuffer.GET(CellData.ColumnNumber) THEN BEGIN
                    DataColumn := DataTable.Columns.Item(TempXMLBuffer."Parent Entry No.");
                    DataColumn.AllowDBNull(TRUE);
                    DataRow2.Item(TempXMLBuffer."Parent Entry No.",CellValueText);
                  END;

                ColumnCount := CellData.ColumnNumber + 1;
              END;
              CurrentRowIndex := CellData.RowNumber;
            END;
            // Add the last row
            DataTable.Rows.Add(DataRow2);
            DataTable.EndLoadData;
          END ELSE
            MESSAGE(InvalidDataInSheetMsg,WrkShtReader.Name);
        END;

        WrkSheetId += 1;
        DataColumnTableId += 2;
      UNTIL WrkSheetId >= SheetCount;

      TempBlob.INIT;
      TempBlob.Blob.CREATEINSTREAM(InStream);
      DataSet.WriteXml(InStream);
      ConfigXMLExchange.SetExcelMode(TRUE);
      IF ConfigXMLExchange.ImportPackageXMLFromStream(InStream) THEN
        Imported := TRUE;

      EXIT(Imported);
    END;

    [External]
    PROCEDURE ClearOpenXmlVariables@7();
    BEGIN
      CLEAR(WrkbkReader);
      CLEAR(WrkbkWriter);
      CLEAR(WrkShtWriter);
      CLEAR(Workbook);
      CLEAR(WorkBookPart);
      CLEAR(WrkShtHelper);
    END;

    LOCAL PROCEDURE CreateBook@27(VAR TempBlob@1000 : Record 99008535);
    VAR
      InStream@1001 : InStream;
    BEGIN
      TempBlob.Blob.CREATEINSTREAM(InStream);
      WrkbkWriter := WrkbkWriter.Create(InStream);
      IF ISNULL(WrkbkWriter) THEN
        ERROR(CreateWrkBkFailedErr);

      Workbook := WrkbkWriter.Workbook;
      WorkBookPart := Workbook.WorkbookPart;
    END;

    [External]
    PROCEDURE GetXLColumnID@14(ColumnNo@1003 : Integer) : Text[10];
    VAR
      ExcelBuf@1000 : Record 370;
    BEGIN
      ExcelBuf.INIT;
      ExcelBuf.VALIDATE("Column No.",ColumnNo);
      EXIT(ExcelBuf.xlColID);
    END;

    [External]
    PROCEDURE SetHideDialog@1(NewHideDialog@1000 : Boolean);
    BEGIN
      HideDialog := NewHideDialog;
    END;

    LOCAL PROCEDURE AddWorkSheetAuthor@11(Comments@1003 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.Comments";AuthorText@1002 : Text);
    VAR
      Author@1001 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.Author";
      Authors@1000 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.Authors";
    BEGIN
      Authors := Authors.Authors;
      WrkShtHelper.AppendElementToOpenXmlElement(Comments,Authors);
      Author := Author.Author;
      Author.Text := AuthorText;
      WrkShtHelper.AppendElementToOpenXmlElement(Authors,Author);
    END;

    LOCAL PROCEDURE ImportSchema@5(VAR WrkbkWriter@1000 : DotNet "'Microsoft.Dynamics.Nav.OpenXml, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.OpenXml.Spreadsheet.WorkbookWriter";SchemaFileName@1001 : Text;MapId@1009 : BigInteger);
    VAR
      CustomXMLMappingsPart@1003 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Packaging.CustomXmlMappingsPart";
      MapInfo@1004 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.MapInfo";
      Schema@1005 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.Schema";
      StreamReader@1006 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.StreamReader";
      OpenXmlUnknownElement@1008 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.OpenXmlUnknownElement";
      Map@1002 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.Map";
      DataBinding@1013 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.DataBinding";
      UInt32Value@1010 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.UInt32Value";
      StringValue@1011 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.StringValue";
      BooleanValue@1012 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.BooleanValue";
      StreamText@1007 : Text;
    BEGIN
      StreamReader := StreamReader.StreamReader(SchemaFileName);
      StreamReader.ReadLine;
      StreamText := StreamReader.ReadToEnd;
      StreamReader.Close;
      OpenXmlUnknownElement := OpenXmlUnknownElement.CreateOpenXmlUnknownElement(StreamText);

      Schema := WrkbkWriter.CreateSchemaFromOpenXmlUnknown(OpenXmlUnknownElement);
      Schema.Id := StringValue.StringValue('Schema1');

      MapInfo := MapInfo.MapInfo;
      MapInfo.SelectionNamespaces := StringValue.StringValue('');
      WrkShtHelper.AppendElementToOpenXmlElement(MapInfo,Schema);
      Map := Map.Map;
      UInt32Value := UInt32Value.UInt32Value;
      UInt32Value.Value := MapId;
      Map.ID := UInt32Value;
      Map.Name := StringValue.StringValue('DataList_Map');
      Map.RootElement := StringValue.StringValue('DataList');
      Map.SchemaId := Schema.Id;
      Map.ShowImportExportErrors := BooleanValue.BooleanValue(FALSE);
      Map.AutoFit := BooleanValue.BooleanValue(TRUE);
      Map.AppendData := BooleanValue.BooleanValue(FALSE);
      Map.PreserveAutoFilterState := BooleanValue.BooleanValue(TRUE);
      Map.PreserveFormat := BooleanValue.BooleanValue(TRUE);

      DataBinding := DataBinding.DataBinding;
      DataBinding.FileBinding := BooleanValue.BooleanValue(TRUE);
      DataBinding.ConnectionId := Map.ID;
      UInt32Value.Value := 1;
      DataBinding.DataBindingLoadMode := UInt32Value;
      WrkShtHelper.AppendElementToOpenXmlElement(MapInfo,Map);
      WrkShtHelper.AppendElementToOpenXmlElement(Map,DataBinding);

      CustomXMLMappingsPart := WrkbkWriter.AddCustomXmlMappingsPart;
      CustomXMLMappingsPart.MapInfo := MapInfo;
    END;

    LOCAL PROCEDURE CreateSchemaConnection@10(VAR WrkbkWriter@1000 : DotNet "'Microsoft.Dynamics.Nav.OpenXml, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.OpenXml.Spreadsheet.WorkbookWriter";SetupDataFileName@1001 : Text);
    VAR
      ConnectionsPart@1002 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Packaging.ConnectionsPart";
      Connections@1008 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.Connections";
      Connection@1003 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.Connection";
      UInt32Value@1004 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.UInt32Value";
      StringValue@1005 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.StringValue";
      BooleanTrueValue@1006 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.BooleanValue";
      WebQueryProperties@1007 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.WebQueryProperties";
      ByteValue@1009 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.ByteValue";
    BEGIN
      ConnectionsPart := WrkbkWriter.AddConnectionsPart;
      Connections := Connections.Connections;
      Connection := WrkbkWriter.CreateConnection(1);
      UInt32Value := UInt32Value.UInt32Value;
      Connection.Name := StringValue.StringValue(FileMgt.GetFileName(SetupDataFileName));
      UInt32Value.Value := 4;
      Connection.Type := UInt32Value;
      BooleanTrueValue := BooleanTrueValue.BooleanValue(TRUE);
      Connection.Background := BooleanTrueValue;
      ByteValue := ByteValue.ByteValue;
      ByteValue.Value := 0;
      Connection.RefreshedVersion := ByteValue;
      WebQueryProperties := WebQueryProperties.WebQueryProperties;
      WebQueryProperties.XmlSource := BooleanTrueValue;
      WebQueryProperties.SourceData := BooleanTrueValue;
      WebQueryProperties.Url := StringValue.StringValue(SetupDataFileName);
      WebQueryProperties.HtmlTables := BooleanTrueValue;
      WrkShtHelper.AppendElementToOpenXmlElement(Connection,WebQueryProperties);
      WrkShtHelper.AppendElementToOpenXmlElement(Connections,Connection);
      ConnectionsPart.Connections := Connections;
    END;

    LOCAL PROCEDURE AddSingleXMLCellProperties@9(VAR SingleXMLCell@1000 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.SingleXmlCell";CellReference@1001 : Text;XPath@1002 : Text;Mapid@1004 : Integer;ConnectionId@1007 : Integer);
    VAR
      XMLCellProperties@1008 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.XmlCellProperties";
      XMLProperties@1009 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.XmlProperties";
      UInt32Value@1005 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.UInt32Value";
      StringValue@1006 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.StringValue";
      XmlDataValues@1010 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.XmlDataValues";
      WrkShtWriter2@1003 : DotNet "'Microsoft.Dynamics.Nav.OpenXml, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.OpenXml.Spreadsheet.WorksheetWriter";
    BEGIN
      StringValue := StringValue.StringValue(CellReference);
      SingleXMLCell.CellReference := StringValue;
      UInt32Value := UInt32Value.UInt32Value;
      UInt32Value.Value := ConnectionId;
      SingleXMLCell.ConnectionId := UInt32Value;

      XMLCellProperties := XMLCellProperties.XmlCellProperties;
      WrkShtHelper.AppendElementToOpenXmlElement(SingleXMLCell,XMLCellProperties);
      UInt32Value.Value := 1;
      XMLCellProperties.Id := UInt32Value;
      StringValue := StringValue.StringValue(FORMAT(SingleXMLCell.Id));
      XMLCellProperties.UniqueName := StringValue;

      XMLProperties := XMLProperties.XmlProperties;
      WrkShtHelper.AppendElementToOpenXmlElement(XMLCellProperties,XMLProperties);
      UInt32Value.Value := Mapid;
      XMLProperties.MapId := UInt32Value;
      StringValue := StringValue.StringValue(XPath);
      XMLProperties.XPath := StringValue;
      XmlDataValues := XmlDataValues.String;

      XMLProperties.XmlDataType := WrkShtWriter2.GetEnumXmlDataValues(XmlDataValues);
    END;

    LOCAL PROCEDURE SetCellComment@2(WrkShtWriter@1010 : DotNet "'Microsoft.Dynamics.Nav.OpenXml, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.OpenXml.Spreadsheet.WorksheetWriter";CellReference@1000 : Text;CommentValue@1001 : Text);
    VAR
      Comment@1004 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.Comment";
      CommentText@1003 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.CommentText";
      Run@1006 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.Run";
      UInt32Value@1014 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.UInt32Value";
      StringValue@1015 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.StringValue";
      Int32Value@1020 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Int32Value";
      CommentList@1008 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.CommentList";
      Comments@1005 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.Comments";
      SpreadsheetText@1009 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.Text";
      RunProperties@1007 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.RunProperties";
      CommentsPart@1002 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Packaging.WorksheetCommentsPart";
      Worksheet@1011 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.Worksheet";
      Bold@1012 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.Bold";
      FontSize@1013 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.FontSize";
      DoubleValue@1016 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.DoubleValue";
      Color@1018 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.Color";
      RunFont@1017 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.RunFont";
      RunPropCharSet@1019 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.RunPropertyCharSet";
    BEGIN
      CommentsPart := WrkShtWriter.Worksheet.WorksheetPart.WorksheetCommentsPart;
      Comments := CommentsPart.Comments;

      IF ISNULL(Comments) THEN BEGIN
        Comments := Comments.Comments;
        CommentsPart.Comments := Comments;
      END;

      CommentList := Comments.CommentList;

      IF ISNULL(CommentList) THEN
        CommentList := WrkShtWriter.CreateCommentList(Comments);

      Comment := Comment.Comment;
      Comment.AuthorId := UInt32Value.FromUInt32(0);
      Comment.Reference := StringValue.StringValue(CellReference);

      CommentText := CommentText.CommentText;

      Run := Run.Run;

      RunProperties := RunProperties.RunProperties;
      Bold := Bold.Bold;

      FontSize := FontSize.FontSize;
      FontSize.Val := DoubleValue.FromDouble(9);

      Color := Color.Color;
      Color.Indexed := UInt32Value.FromUInt32(81);

      RunFont := RunFont.RunFont;
      RunFont.Val := StringValue.FromString('Tahoma');

      RunPropCharSet := RunPropCharSet.RunPropertyCharSet;
      RunPropCharSet.Val := Int32Value.FromInt32(1);

      WrkShtHelper.AppendElementToOpenXmlElement(RunProperties,Bold);
      WrkShtHelper.AppendElementToOpenXmlElement(RunProperties,FontSize);
      WrkShtHelper.AppendElementToOpenXmlElement(RunProperties,Color);
      WrkShtHelper.AppendElementToOpenXmlElement(RunProperties,RunFont);
      WrkShtHelper.AppendElementToOpenXmlElement(RunProperties,RunPropCharSet);

      SpreadsheetText := WrkShtWriter.AddText(CommentValue);
      SpreadsheetText.Text := CommentValue;

      WrkShtHelper.AppendElementToOpenXmlElement(Run,RunProperties);
      WrkShtHelper.AppendElementToOpenXmlElement(Run,SpreadsheetText);

      WrkShtHelper.AppendElementToOpenXmlElement(CommentText,Run);
      Comment.CommentText := CommentText;

      WrkShtWriter.AppendComment(CommentList,Comment);

      CommentsPart.Comments.Save;
      WrkShtWriter.Worksheet.Save;
      Worksheet := WrkShtWriter.Worksheet;
    END;

    LOCAL PROCEDURE CreateSchemaFile@15(VAR ConfigPackageTable@1000 : Record 8613) : Text;
    VAR
      ConfigDataSchema@1004 : XMLport 8610;
      OStream@1002 : OutStream;
      TempSchemaFile@1003 : File;
      TempSchemaFileName@1001 : Text;
    BEGIN
      TempSchemaFile.CREATETEMPFILE;
      TempSchemaFileName := TempSchemaFile.NAME + '.xsd';
      TempSchemaFile.CLOSE;
      TempSchemaFile.CREATE(TempSchemaFileName);
      TempSchemaFile.CREATEOUTSTREAM(OStream);
      ConfigDataSchema.SETDESTINATION(OStream);
      ConfigDataSchema.SETTABLEVIEW(ConfigPackageTable);
      IF NOT ConfigDataSchema.EXPORT THEN
        ERROR(CannotCreateXmlSchemaErr);
      TempSchemaFile.CLOSE;
      EXIT(TempSchemaFileName);
    END;

    LOCAL PROCEDURE CreateXMLPackage@4(TempSetupDataFileName@1000 : Text;ExportFromWksht@1001 : Boolean;VAR ConfigPackageTable@1002 : Record 8613) : Text;
    BEGIN
      CLEAR(ConfigXMLExchange);
      ConfigXMLExchange.SetExcelMode(TRUE);
      ConfigXMLExchange.SetCalledFromCode(TRUE);
      ConfigXMLExchange.SetPrefixMode(TRUE);
      ConfigXMLExchange.SetExportFromWksht(ExportFromWksht);
      ConfigXMLExchange.ExportPackageXML(ConfigPackageTable,TempSetupDataFileName);
      ConfigXMLExchange.SetExcelMode(FALSE);
      EXIT(TempSetupDataFileName);
    END;

    LOCAL PROCEDURE CreateTableColumnNames@6(VAR ConfigPackageField@1000 : Record 8616;VAR ConfigPackageTable@1006 : Record 8613;TableColumns@1008 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.TableColumns");
    VAR
      Field@1002 : Record 2000000041;
      Dimension@1004 : Record 348;
      XmlColumnProperties@1005 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.XmlColumnProperties";
      TableColumn@1007 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.TableColumn";
      WrkShtWriter2@1011 : DotNet "'Microsoft.Dynamics.Nav.OpenXml, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.OpenXml.Spreadsheet.WorksheetWriter";
      RecRef@1012 : RecordRef;
      FieldRef@1010 : FieldRef;
      TableColumnName@1003 : Text;
      ColumnID@1001 : Integer;
    BEGIN
      RecRef.OPEN(ConfigPackageTable."Table ID");
      ConfigPackageField.SETCURRENTKEY("Package Code","Table ID","Processing Order");
      IF ConfigPackageField.FINDSET THEN BEGIN
        ColumnID := 1;
        REPEAT
          IF TypeHelper.GetField(ConfigPackageField."Table ID",ConfigPackageField."Field ID",Field) OR
             ConfigPackageField.Dimension
          THEN BEGIN
            IF ConfigPackageField.Dimension THEN
              TableColumnName := ConfigPackageField."Field Caption" + ' ' + STRSUBSTNO('(%1)',Dimension.TABLECAPTION)
            ELSE
              TableColumnName := ConfigPackageField."Field Caption";
            XmlColumnProperties := WrkShtWriter2.CreateXmlColumnProperties(
                1,
                '/DataList/' + (ConfigXMLExchange.GetElementName(ConfigPackageTable."Table Caption") + 'List') +
                '/' + ConfigXMLExchange.GetElementName(ConfigPackageTable."Table Caption") +
                '/' + ConfigXMLExchange.GetElementName(ConfigPackageField."Field Caption"),
                WrkShtWriter.XmlDataType2XmlDataValues(
                  ConfigXMLExchange.GetXSDType(ConfigPackageTable."Table ID",ConfigPackageField."Field ID")));
            TableColumn := WrkShtWriter.CreateTableColumn(
                ColumnID,
                TableColumnName,
                ConfigXMLExchange.GetElementName(ConfigPackageField."Field Caption"));
            WrkShtHelper.AppendElementToOpenXmlElement(TableColumn,XmlColumnProperties);
            WrkShtHelper.AppendElementToOpenXmlElement(TableColumns,TableColumn);
            WrkShtWriter.SetCellValueText(3,GetXLColumnID(ColumnID),TableColumnName,WrkShtWriter.DefaultCellDecorator);
            IF NOT ConfigPackageField.Dimension THEN BEGIN
              FieldRef := RecRef.FIELD(ConfigPackageField."Field ID");
              SetCellComment(WrkShtWriter,GetXLColumnID(ColumnID) + '3',ConfigValidateMgt.AddComment(FieldRef));
              CreateCommentVmlShapeXml(ColumnID,3);
            END;
          END;
          ColumnID += 1;
        UNTIL ConfigPackageField.NEXT = 0;
      END;
      RecRef.CLOSE;
    END;

    LOCAL PROCEDURE CleanMapInfo@38(MapInfo@1000 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.MapInfo");
    VAR
      MapInfoString@1001 : Text;
    BEGIN
      MapInfoString :=
        ReplaceSubString(
          FORMAT(MapInfo.OuterXml),
          '<x:MapInfo SelectionNamespaces="" xmlns:x="http://schemas.openxmlformats.org/spreadsheetml/2006/main">',
          '');
      MapInfoString := ReplaceSubString(MapInfoString,'</x:MapInfo>','');
      MapInfoString := ReplaceSubString(MapInfoString,'x:','');
      MapInfo.InnerXml(MapInfoString);
    END;

    LOCAL PROCEDURE ReplaceSubString@17(String@1001 : Text;Old@1002 : Text;New@1003 : Text) : Text;
    VAR
      Pos@1000 : Integer;
    BEGIN
      Pos := STRPOS(String,Old);
      WHILE Pos <> 0 DO BEGIN
        String := DELSTR(String,Pos,STRLEN(Old));
        String := INSSTR(String,New,Pos);
        Pos := STRPOS(String,Old);
      END;
      EXIT(String);
    END;

    LOCAL PROCEDURE WriteCellValue@22(VAR WrkShtWriter@1001 : DotNet "'Microsoft.Dynamics.Nav.OpenXml, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.OpenXml.Spreadsheet.WorksheetWriter";DataColumnDataType@1000 : Text;VAR DataRow@1004 : DotNet "'System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Data.DataRow";RowsCount@1003 : Integer;ColumnsCount@1002 : Integer);
    BEGIN
      CASE DataColumnDataType OF
        'System.DateTime':
          WrkShtWriter.SetCellValueDate(RowsCount + 4,GetXLColumnID(ColumnsCount + 1),DataRow.Item(ColumnsCount),'',
            WrkShtWriter.DefaultCellDecorator);
        'System.Time':
          WrkShtWriter.SetCellValueTime(RowsCount + 4,GetXLColumnID(ColumnsCount + 1),DataRow.Item(ColumnsCount),'',
            WrkShtWriter.DefaultCellDecorator);
        'System.Boolean':
          WrkShtWriter.SetCellValueBoolean(RowsCount + 4,GetXLColumnID(ColumnsCount + 1),DataRow.Item(ColumnsCount),
            WrkShtWriter.DefaultCellDecorator);
        'System.Integer','System.Int32':
          WrkShtWriter.SetCellValueNumber(RowsCount + 4,GetXLColumnID(ColumnsCount + 1),FORMAT(DataRow.Item(ColumnsCount)),'',
            WrkShtWriter.DefaultCellDecorator);
        ELSE
          WrkShtWriter.SetCellValueText(RowsCount + 4,GetXLColumnID(ColumnsCount + 1),DataRow.Item(ColumnsCount),
            WrkShtWriter.DefaultCellDecorator);
      END;
    END;

    LOCAL PROCEDURE ExtractXMLSchema@109(WorkBookPart@1000 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Packaging.WorkbookPart") XMLSchemaDataFile : Text;
    VAR
      XMLWriter@1002 : DotNet "'System.Xml, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlWriter";
    BEGIN
      XMLSchemaDataFile := FileMgt.ServerTempFileName('');
      XMLWriter := XMLWriter.Create(XMLSchemaDataFile);
      WorkBookPart.CustomXmlMappingsPart.MapInfo.FirstChild.FirstChild.WriteTo(XMLWriter);
      XMLWriter.Close;
    END;

    LOCAL PROCEDURE CreateTableStyleInfo@25(VAR TableStyleInfo@1000 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.TableStyleInfo");
    VAR
      BooleanValue@1005 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.BooleanValue";
      StringValue@1006 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.StringValue";
    BEGIN
      TableStyleInfo.Name := StringValue.StringValue('TableStyleMedium2');
      TableStyleInfo.ShowFirstColumn := BooleanValue.BooleanValue(FALSE);
      TableStyleInfo.ShowLastColumn := BooleanValue.BooleanValue(FALSE);
      TableStyleInfo.ShowRowStripes := BooleanValue.BooleanValue(TRUE);
      TableStyleInfo.ShowColumnStripes := BooleanValue.BooleanValue(FALSE);
    END;

    LOCAL PROCEDURE CreateCommentVmlShapeXml@23(ColId@1000 : Integer;RowId@1001 : Integer);
    VAR
      Guid@1002 : GUID;
      Anchor@1003 : Text;
      CommentShape@1004 : Text;
    BEGIN
      Guid := CREATEGUID;

      Anchor := CreateCommentVmlAnchor(ColId,RowId);

      CommentShape := STRSUBSTNO(CommentVmlShapeXmlTxt,Guid,Anchor,RowId - 1,ColId - 1);

      StringBld.Append(CommentShape);
    END;

    LOCAL PROCEDURE CreateCommentVmlAnchor@39(ColId@1000 : Integer;RowId@1001 : Integer) : Text;
    BEGIN
      EXIT(STRSUBSTNO(VmlShapeAnchorTxt,ColId,RowId - 2,ColId + 2));
    END;

    LOCAL PROCEDURE AddVmlDrawingPart@59(VAR VmlDrawingPart@1002 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Packaging.VmlDrawingPart");
    VAR
      StringValue@1003 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.StringValue";
      LegacyDrawing@1000 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.LegacyDrawing";
      VmlPartId@1001 : Text;
    BEGIN
      VmlDrawingPart := WrkShtWriter.CreateVmlDrawingPart;
      VmlPartId := Worksheet.WorksheetPart.GetIdOfPart(VmlDrawingPart);
      LegacyDrawing := LegacyDrawing.LegacyDrawing;
      LegacyDrawing.Id := StringValue.FromString(VmlPartId);
      WrkShtHelper.AppendElementToOpenXmlElement(Worksheet.WorksheetPart.Worksheet,LegacyDrawing);
    END;

    LOCAL PROCEDURE AddPackageAndTableInformation@28(VAR ConfigPackageTable@1002 : Record 8613;VAR SingleXMLCells@1001 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.SingleXmlCells");
    VAR
      SingleXMLCell@1000 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.SingleXmlCell";
      RecRef@1003 : RecordRef;
      TableCaptionString@1004 : Text;
    BEGIN
      // Add package name
      SingleXMLCell := WrkShtWriter.AddSingleXmlCell(id);
      WrkShtHelper.AppendElementToOpenXmlElement(SingleXMLCells,SingleXMLCell);
      AddSingleXMLCellProperties(SingleXMLCell,'A1','/DataList/' +
        (ConfigXMLExchange.GetElementName(ConfigPackageTable."Table Caption") + 'List') + '/' +
        ConfigXMLExchange.GetElementName(ConfigPackageTable.FIELDNAME("Package Code")),1,1);
      WrkShtWriter.SetCellValueText(1,'A',ConfigPackageTable."Package Code",WrkShtWriter.DefaultCellDecorator);

      // Add Table name
      RecRef.OPEN(ConfigPackageTable."Table ID");
      TableCaptionString := RecRef.CAPTION;
      RecRef.CLOSE;
      WrkShtWriter.SetCellValueText(1,'B',TableCaptionString,WrkShtWriter.DefaultCellDecorator);

      // Add Table id
      id += 1;
      SingleXMLCell := WrkShtWriter.AddSingleXmlCell(id);
      WrkShtHelper.AppendElementToOpenXmlElement(SingleXMLCells,SingleXMLCell);

      AddSingleXMLCellProperties(SingleXMLCell,'C1','/DataList/' +
        (ConfigXMLExchange.GetElementName(ConfigPackageTable."Table Caption") + 'List') + '/' +
        ConfigXMLExchange.GetElementName(ConfigPackageTable.FIELDNAME("Table ID")),1,1);
      WrkShtWriter.SetCellValueText(1,'C',FORMAT(ConfigPackageTable."Table ID"),WrkShtWriter.DefaultCellDecorator);
    END;

    LOCAL PROCEDURE CopyDataToExcelTable@33();
    VAR
      DataRow@1004 : DotNet "'System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Data.DataRow";
      DataTableRowsCount@1003 : Integer;
      RowsCount@1002 : Integer;
      ColumnsCount@1001 : Integer;
      DataTableColumnsCount@1000 : Integer;
    BEGIN
      DataTableRowsCount := DataTable.Rows.Count;
      RowsCount := 0;
      DataTableColumnsCount := DataTable.Columns.Count;
      REPEAT
        DataRow := DataTable.Rows.Item(RowsCount);
        ColumnsCount := 0;
        REPEAT
          DataColumn := DataTable.Columns.Item(ColumnsCount);
          WriteCellValue(WrkShtWriter,FORMAT(DataColumn.DataType),DataRow,RowsCount,ColumnsCount);
          ColumnsCount += 1;
        UNTIL ColumnsCount = DataTableColumnsCount - 1;
        RowsCount += 1;
      UNTIL RowsCount = DataTableRowsCount;
    END;

    LOCAL PROCEDURE BuildDataSetForPackageTable@12(ExportFromWksht@1001 : Boolean;VAR ConfigPackageTable@1002 : Record 8613) : Text;
    VAR
      TempSetupDataFileName@1000 : Text;
    BEGIN
      TempSetupDataFileName := CreateXMLPackage(FileMgt.ServerTempFileName(''),ExportFromWksht,ConfigPackageTable);
      DataSet := DataSet.DataSet;
      DataSet.ReadXml(TempSetupDataFileName);
      EXIT(TempSetupDataFileName);
    END;

    LOCAL PROCEDURE AddAndInitializeCommentsPart@45(VAR VmlDrawingPart@1001 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Packaging.VmlDrawingPart");
    VAR
      WorkSheetCommentsPart@1000 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Packaging.WorksheetCommentsPart";
      Comments@1002 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.Comments";
    BEGIN
      WorkSheetCommentsPart := WrkShtWriter.CreateWorksheetCommentsPart;
      AddVmlDrawingPart(VmlDrawingPart);

      IF ISNULL(WorkSheetCommentsPart.Comments) THEN
        WorkSheetCommentsPart.Comments := Comments.Comments;

      AddWorkSheetAuthor(WorkSheetCommentsPart.Comments,USERID);

      WrkShtWriter.CreateCommentList(WorkSheetCommentsPart.Comments);
    END;

    LOCAL PROCEDURE AddAndInitializeTableDefinitionPart@26(VAR ConfigPackageTable@1003 : Record 8613;ExportFromWksht@1004 : Boolean;DataTableCounter@1005 : Integer;VAR TableDefinitionPart@1011 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Packaging.TableDefinitionPart";SkipData@1000 : Boolean);
    VAR
      ConfigPackageField@1002 : Record 8616;
      TableColumns@1001 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.TableColumns";
      Table@1007 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.Table";
      TableStyleInfo@1010 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.TableStyleInfo";
      BooleanValue@1006 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.BooleanValue";
      AutoFilter@1009 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.AutoFilter";
      StringValue@1008 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.StringValue";
      RowsCount@1012 : Integer;
    BEGIN
      TableDefinitionPart := WrkShtWriter.CreateTableDefinitionPart;
      ConfigPackageField.RESET;
      ConfigPackageField.SETRANGE("Package Code",ConfigPackageTable."Package Code");
      ConfigPackageField.SETRANGE("Table ID",ConfigPackageTable."Table ID");
      ConfigPackageField.SETRANGE("Include Field",TRUE);
      IF NOT ExportFromWksht THEN
        ConfigPackageField.SETRANGE(Dimension,FALSE);

      DataTable := DataSet.Tables.Item(DataTableCounter);

      id += 1;
      IF SkipData THEN
        RowsCount := 1
      ELSE
        RowsCount := DataTable.Rows.Count;
      Table := WrkShtWriter.CreateTable(id);
      Table.TotalsRowShown := BooleanValue.BooleanValue(FALSE);
      Table.Reference := StringValue.StringValue('A3:' +
          GetXLColumnID(ConfigPackageField.COUNT) + FORMAT(RowsCount + 3));
      Table.Name := StringValue.StringValue('Table' + FORMAT(id));
      Table.DisplayName := StringValue.StringValue('Table' + FORMAT(id));
      AutoFilter := AutoFilter.AutoFilter;
      AutoFilter.Reference :=
        StringValue.StringValue('A3:' + GetXLColumnID(ConfigPackageField.COUNT) + FORMAT(RowsCount + 3));
      WrkShtHelper.AppendElementToOpenXmlElement(Table,AutoFilter);
      TableColumns := WrkShtWriter.CreateTableColumns(ConfigPackageField.COUNT);

      CreateTableColumnNames(ConfigPackageField,ConfigPackageTable,TableColumns);
      WrkShtHelper.AppendElementToOpenXmlElement(Table,TableColumns);
      TableStyleInfo := TableStyleInfo.TableStyleInfo;
      CreateTableStyleInfo(TableStyleInfo);
      WrkShtHelper.AppendElementToOpenXmlElement(Table,TableStyleInfo);
      TableDefinitionPart.Table := Table;
    END;

    [TryFunction]
    LOCAL PROCEDURE GetDataTable@41(TableId@1000 : Integer);
    BEGIN
      DataTable := DataSet.Tables.Item(TableId);
    END;

    LOCAL PROCEDURE InitColumnMapping@8(WrkShtReader@1002 : DotNet "'Microsoft.Dynamics.Nav.OpenXml, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.OpenXml.Spreadsheet.WorksheetReader";VAR TempXMLBuffer@1003 : TEMPORARY Record 1235) : Boolean;
    VAR
      Table@1001 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.Table";
      TableColumn@1004 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.TableColumn";
      Enumerable@1009 : DotNet "'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.IEnumerable";
      Enumerator@1008 : DotNet "'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.IEnumerator";
      XmlColumnProperties@1012 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.XmlColumnProperties";
      OpenXmlElement@1011 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.OpenXmlElement";
      TableStartColumnIndex@1015 : Integer;
      Index@1016 : Integer;
    BEGIN
      TempXMLBuffer.DELETEALL;
      IF NOT FindTableDefinition(WrkShtReader,Table) THEN
        EXIT(FALSE);

      TableStartColumnIndex := GetTableStartColumnIndex(Table);
      Index := 0;
      Enumerable := Table.TableColumns;
      Enumerator := Enumerable.GetEnumerator;
      WHILE Enumerator.MoveNext DO BEGIN
        TableColumn := Enumerator.Current;
        XmlColumnProperties := TableColumn.XmlColumnProperties;
        IF NOT ISNULL(XmlColumnProperties) THEN BEGIN
          OpenXmlElement := XmlColumnProperties.XPath; // identifies column to xsd mapping.
          IF NOT ISNULL(OpenXmlElement) THEN
            InsertXMLBuffer(Index + TableStartColumnIndex,TempXMLBuffer);
        END;
        Index += 1;
      END;

      // RowCount > 2 means sheet has datarow(s)
      EXIT(WrkShtReader.RowCount > 2);
    END;

    LOCAL PROCEDURE FindTableDefinition@79(WrkShtReader@1002 : DotNet "'Microsoft.Dynamics.Nav.OpenXml, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.OpenXml.Spreadsheet.WorksheetReader";VAR Table@1003 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.Table") : Boolean;
    VAR
      TableDefinitionPart@1006 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Packaging.TableDefinitionPart";
      Enumerable@1009 : DotNet "'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.IEnumerable";
      Enumerator@1008 : DotNet "'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.IEnumerator";
    BEGIN
      Enumerable := WrkShtReader.Worksheet.WorksheetPart.TableDefinitionParts;
      Enumerator := Enumerable.GetEnumerator;
      Enumerator.MoveNext;
      TableDefinitionPart := Enumerator.Current;

      IF ISNULL(TableDefinitionPart) THEN
        EXIT(FALSE);

      Table := TableDefinitionPart.Table;
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE GetTableStartColumnIndex@31(Table@1000 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.Table") : Integer;
    VAR
      String@1001 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.String";
      Index@1002 : Integer;
      Length@1005 : Integer;
      ColumnIndex@1006 : Integer;
    BEGIN
      // <x:table id="5" ... ref="A3:E6" ...>
      // table.Reference = "A3:E6" (A3 - top left table corner, E6 - bottom right corner)
      // we convert "A" - to column index
      String := Table.Reference.Value;
      Length := String.IndexOf(':');
      String := DELCHR(String.Substring(0,Length),'=','0123456789');
      Length := String.Length - 1;
      FOR Index := 0 TO Length DO
        ColumnIndex += (String.Chars(Index) - 64) + Index * 26;
      EXIT(ColumnIndex);
    END;

    LOCAL PROCEDURE InsertXMLBuffer@71(ColumnIndex@1000 : Integer;VAR TempXMLBuffer@1001 : TEMPORARY Record 1235);
    BEGIN
      TempXMLBuffer.INIT;
      TempXMLBuffer."Entry No." := ColumnIndex; // column index in table definition
      TempXMLBuffer."Parent Entry No." := TempXMLBuffer.COUNT; // column index in dataset
      TempXMLBuffer.INSERT;
    END;

    PROCEDURE SetFileOnServer@29(NewFileOnServer@1000 : Boolean);
    BEGIN
      FileOnServer := NewFileOnServer;
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeExportExcel@72(VAR ConfigPackageTable@1000 : Record 8613);
    BEGIN
    END;

    BEGIN
    END.
  }
}

