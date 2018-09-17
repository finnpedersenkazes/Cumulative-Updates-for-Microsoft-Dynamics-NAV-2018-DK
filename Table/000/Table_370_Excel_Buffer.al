OBJECT Table 370 Excel Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Excel-buffer;
               ENU=Excel Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Row No.             ;Integer       ;OnValidate=BEGIN
                                                                xlRowID := '';
                                                                IF "Row No." <> 0 THEN
                                                                  xlRowID := FORMAT("Row No.");
                                                              END;

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Rubriknr.;
                                                              ENU=Row No.] }
    { 2   ;   ;xlRowID             ;Text10        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Excel-r‘kke-id;
                                                              ENU=xlRowID] }
    { 3   ;   ;Column No.          ;Integer       ;OnValidate=VAR
                                                                x@1000 : Integer;
                                                                i@1001 : Integer;
                                                                y@1003 : Integer;
                                                                c@1002 : Char;
                                                                t@1102601000 : Text[30];
                                                              BEGIN
                                                                xlColID := '';
                                                                x := "Column No.";
                                                                WHILE x > 26 DO BEGIN
                                                                  y := x MOD 26;
                                                                  IF y = 0 THEN
                                                                    y := 26;
                                                                  c := 64 + y;
                                                                  i := i + 1;
                                                                  t[i] := c;
                                                                  x := (x - y) DIV 26;
                                                                END;
                                                                IF x > 0 THEN BEGIN
                                                                  c := 64 + x;
                                                                  i := i + 1;
                                                                  t[i] := c;
                                                                END;
                                                                FOR x := 1 TO i DO
                                                                  xlColID[x] := t[1 + i - x];
                                                              END;

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kolonnenr.;
                                                              ENU=Column No.] }
    { 4   ;   ;xlColID             ;Text10        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Excel-kolonne-id;
                                                              ENU=xlColID] }
    { 5   ;   ;Cell Value as Text  ;Text250       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Cellev‘rdi som tekst;
                                                              ENU=Cell Value as Text] }
    { 6   ;   ;Comment             ;Text250       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bem‘rkning;
                                                              ENU=Comment] }
    { 7   ;   ;Formula             ;Text250       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Formel;
                                                              ENU=Formula] }
    { 8   ;   ;Bold                ;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Fed;
                                                              ENU=Bold] }
    { 9   ;   ;Italic              ;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kursiv;
                                                              ENU=Italic] }
    { 10  ;   ;Underline           ;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Understreget;
                                                              ENU=Underline] }
    { 11  ;   ;NumberFormat        ;Text30        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Nummerformat;
                                                              ENU=NumberFormat] }
    { 12  ;   ;Formula2            ;Text250       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Formel2;
                                                              ENU=Formula2] }
    { 13  ;   ;Formula3            ;Text250       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Formel3;
                                                              ENU=Formula3] }
    { 14  ;   ;Formula4            ;Text250       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Formel4;
                                                              ENU=Formula4] }
    { 15  ;   ;Cell Type           ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Celletype;
                                                              ENU=Cell Type];
                                                   OptionCaptionML=[DAN=Nummer,Tekst,dato,Klokkesl‘t;
                                                                    ENU=Number,Text,Date,Time];
                                                   OptionString=Number,Text,Date,Time }
    { 16  ;   ;Double Underline    ;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dobbelt understregning;
                                                              ENU=Double Underline] }
  }
  KEYS
  {
    {    ;Row No.,Column No.                      ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst '@@@="{Locked=""Excel""}";DAN=Excel blev ikke fundet.;ENU=Excel not found.';
      Text001@1001 : TextConst 'DAN=Du skal angive et filnavn.;ENU=You must enter a file name.';
      Text002@1002 : TextConst '@@@="{Locked=""Excel""}";DAN=Du skal angive et navn p† et Excel-regneark.;ENU=You must enter an Excel worksheet name.';
      Text003@1003 : TextConst 'DAN=Filen %1 findes ikke.;ENU=The file %1 does not exist.';
      Text004@1004 : TextConst '@@@="{Locked=""Excel""}";DAN=Excel-regnearket %1 findes ikke.;ENU=The Excel worksheet %1 does not exist.';
      Text005@1005 : TextConst '@@@="{Locked=""Excel""}";DAN=Opretter Excel-regneark...\\;ENU=Creating Excel worksheet...\\';
      PageTxt@1006 : TextConst 'DAN=Side;ENU=Page';
      Text007@1007 : TextConst '@@@="{Locked=""Excel""}";DAN=L‘ser Excel-regneark...\\;ENU=Reading Excel worksheet...\\';
      Text013@1013 : TextConst 'DAN=&B;ENU=&B';
      Text014@1014 : TextConst 'DAN=&D;ENU=&D';
      Text015@1015 : TextConst 'DAN=&P;ENU=&P';
      Text016@1016 : TextConst 'DAN=A1;ENU=A1';
      Text017@1017 : TextConst 'DAN=SUMIF;ENU=SUMIF';
      Text018@1018 : TextConst 'DAN=#N/A;ENU=#N/A';
      Text019@1019 : TextConst '@@@={Locked} Used to define an Excel range name. You must refer to Excel rules to change this term.;DAN=GLAcc;ENU=GLAcc';
      Text020@1020 : TextConst '@@@={Locked} Used to define an Excel range name. You must refer to Excel rules to change this term.;DAN=Period;ENU=Period';
      Text021@1021 : TextConst 'DAN=Budget;ENU=Budget';
      TempInfoExcelBuf@1036 : TEMPORARY Record 370;
      FileManagement@1045 : Codeunit 419;
      XlWrkBkWriter@1022 : DotNet "'Microsoft.Dynamics.Nav.OpenXml, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.OpenXml.Spreadsheet.WorkbookWriter";
      XlWrkBkReader@1023 : DotNet "'Microsoft.Dynamics.Nav.OpenXml, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.OpenXml.Spreadsheet.WorkbookReader";
      XlWrkShtWriter@1024 : DotNet "'Microsoft.Dynamics.Nav.OpenXml, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.OpenXml.Spreadsheet.WorksheetWriter";
      XlWrkShtReader@1043 : DotNet "'Microsoft.Dynamics.Nav.OpenXml, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.OpenXml.Spreadsheet.WorksheetReader";
      XlApp@1044 : DotNet "'Microsoft.Office.Interop.Excel, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c'.Microsoft.Office.Interop.Excel.ApplicationClass" RUNONCLIENT;
      XlWrkBk@1051 : DotNet "'Microsoft.Office.Interop.Excel, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c'.Microsoft.Office.Interop.Excel.Workbook" RUNONCLIENT;
      XlWrkSht@1009 : DotNet "'Microsoft.Office.Interop.Excel, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c'.Microsoft.Office.Interop.Excel.Worksheet" RUNONCLIENT;
      XlHelper@1052 : DotNet "'Microsoft.Dynamics.Nav.Integration.Office, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Integration.Office.Excel.ExcelHelper" RUNONCLIENT;
      ActiveSheetName@1049 : Text[250];
      RangeStartXlRow@1034 : Text[30];
      RangeStartXlCol@1033 : Text[30];
      RangeEndXlRow@1032 : Text[30];
      RangeEndXlCol@1031 : Text[30];
      FileNameServer@1046 : Text;
      FriendlyName@1025 : Text;
      CurrentRow@1029 : Integer;
      CurrentCol@1030 : Integer;
      UseInfoSheet@1035 : Boolean;
      Text022@1041 : TextConst '@@@={Locked} Used to define an Excel range name. You must refer to Excel rules to change this term.;DAN=CostAcc;ENU=CostAcc';
      Text023@1037 : TextConst 'DAN=Oplysninger;ENU=Information';
      Text034@1039 : TextConst '@@@="{Split=r''\|\*\..{1,4}\|?''}{Locked=""Excel""}";DAN=Excel-filer (*.xls*)|*.xls*|Alle filer (*.*)|*.*;ENU=Excel Files (*.xls*)|*.xls*|All Files (*.*)|*.*';
      Text035@1040 : TextConst 'DAN=Operationen blev annulleret.;ENU=The operation was canceled.';
      Text036@1042 : TextConst '@@@="{Locked=""Excel""}";DAN=Excel-regnearket findes ikke.;ENU=The Excel workbook does not exist.';
      Text037@1047 : TextConst '@@@="{Locked=""Excel""}";DAN=Excel-regnearket kunne ikke oprettes.;ENU=Could not create the Excel workbook.';
      Text038@1048 : TextConst 'DAN=Den globale variabel %1 er ikke inkluderet i kontrollen.;ENU=Global variable %1 is not included for test.';
      Text039@1050 : TextConst 'DAN=Der er ikke angivet en celletype.;ENU=Cell type has not been set.';
      Text040@1008 : TextConst '@@@="{Locked=""Excel""}";DAN=Eksport‚r Excel-fil;ENU=Export Excel File';
      SavingDocumentMsg@1010 : TextConst 'DAN=Gemmer f›lgende dokument: %1.;ENU=Saving the following document: %1.';
      ExcelFileExtensionTok@1012 : TextConst '@@@={Locked};DAN=.xlsx;ENU=.xlsx';

    [External]
    PROCEDURE CreateNewBook@42(SheetName@1000 : Text[250]);
    BEGIN
      CreateBook('',SheetName);
    END;

    [Internal]
    PROCEDURE CreateBook@1(FileName@1001 : Text;SheetName@1000 : Text[250]);
    BEGIN
      IF SheetName = '' THEN
        ERROR(Text002);

      IF FileName = '' THEN
        FileNameServer := FileManagement.ServerTempFileName('xlsx')
      ELSE BEGIN
        IF EXISTS(FileName) THEN
          ERASE(FileName);
        FileNameServer := FileName;
      END;

      XlWrkBkWriter := XlWrkBkWriter.Create(FileNameServer);
      IF ISNULL(XlWrkBkWriter) THEN
        ERROR(Text037);

      XlWrkShtWriter := XlWrkBkWriter.FirstWorksheet;
      IF SheetName <> '' THEN BEGIN
        XlWrkShtWriter.Name := SheetName;
        ActiveSheetName := SheetName;
      END
    END;

    PROCEDURE OpenBook@2(FileName@1000 : Text;SheetName@1001 : Text[250]);
    BEGIN
      IF FileName = '' THEN
        ERROR(Text001);

      IF SheetName = '' THEN
        ERROR(Text002);

      IF SheetName = 'G/L Account' THEN
        SheetName := 'GL Account';

      XlWrkBkReader := XlWrkBkReader.Open(FileName);
      IF XlWrkBkReader.HasWorksheet(SheetName) THEN BEGIN
        XlWrkShtReader := XlWrkBkReader.GetWorksheetByName(SheetName);
      END ELSE BEGIN
        QuitExcel;
        ERROR(Text004,SheetName);
      END;
    END;

    [Internal]
    PROCEDURE UpdateBook@5(FileName@1000 : Text;SheetName@1001 : Text[250]);
    BEGIN
      UpdateBookExcel(FileName,SheetName,TRUE);
    END;

    [Internal]
    PROCEDURE UpdateBookExcel@48(FileName@1001 : Text;SheetName@1000 : Text[250];PreserveDataOnUpdate@1002 : Boolean);
    BEGIN
      IF FileName = '' THEN
        ERROR(Text001);

      IF SheetName = '' THEN
        ERROR(Text002);

      FileNameServer := FileName;
      XlWrkBkWriter := XlWrkBkWriter.Open(FileNameServer);
      IF XlWrkBkWriter.HasWorksheet(SheetName) THEN BEGIN
        XlWrkShtWriter := XlWrkBkWriter.GetWorksheetByName(SheetName);
        // Set PreserverDataOnUpdate to false if the sheet writer should clear all empty cells
        // in which NAV does not have new data. Notice that the sheet writer will only clear Excel
        // cells that are addressed by the writer. All other cells will be left unmodified.
        XlWrkShtWriter.PreserveDataOnUpdate := PreserveDataOnUpdate;
        ActiveSheetName := SheetName;
      END ELSE BEGIN
        QuitExcel;
        ERROR(Text004,SheetName);
      END;
    END;

    [External]
    PROCEDURE CloseBook@30();
    BEGIN
      IF NOT ISNULL(XlWrkBkWriter) THEN BEGIN
        XlWrkBkWriter.ClearFormulaCalculations;
        XlWrkBkWriter.ValidateDocument;
        XlWrkBkWriter.Close;
        CLEAR(XlWrkShtWriter);
        CLEAR(XlWrkBkWriter);
      END;

      IF NOT ISNULL(XlWrkBkReader) THEN BEGIN
        CLEAR(XlWrkShtReader);
        CLEAR(XlWrkBkReader);
      END;
    END;

    [External]
    PROCEDURE WriteSheet@37(ReportHeader@1001 : Text;CompanyName2@1002 : Text;UserID2@1003 : Text);
    VAR
      ExcelBufferDialogMgt@1009 : Codeunit 5370;
      OrientationValues@1000 : DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.OrientationValues";
      CRLF@1008 : Char;
      RecNo@1010 : Integer;
      InfoRecNo@1012 : Integer;
      TotalRecNo@1011 : Integer;
      LastUpdate@1004 : DateTime;
    BEGIN
      LastUpdate := CURRENTDATETIME;
      ExcelBufferDialogMgt.Open(Text005);

      CRLF := 10;
      RecNo := 1;
      TotalRecNo := COUNT + TempInfoExcelBuf.COUNT;
      RecNo := 0;

      XlWrkShtWriter.AddPageSetup(OrientationValues.Landscape,9); // 9 - default value for Paper Size - A4

      IF FINDSET THEN
        REPEAT
          RecNo := RecNo + 1;
          IF NOT UpdateProgressDialog(ExcelBufferDialogMgt,LastUpdate,RecNo,TotalRecNo) THEN BEGIN
            QuitExcel;
            ERROR(Text035)
          END;
          IF Formula = '' THEN
            WriteCellValue(Rec)
          ELSE
            WriteCellFormula(Rec)
        UNTIL NEXT = 0;

      IF ReportHeader <> '' THEN
        XlWrkShtWriter.AddHeader(
          TRUE,
          STRSUBSTNO('%1%2%1%3%4',GetExcelReference(1),ReportHeader,CRLF,CompanyName2));

      XlWrkShtWriter.AddHeader(
        FALSE,
        STRSUBSTNO('%1%3%4%3%5 %2',GetExcelReference(2),GetExcelReference(3),CRLF,UserID2,PageTxt));

      IF UseInfoSheet THEN
        IF TempInfoExcelBuf.FINDSET THEN BEGIN
          XlWrkShtWriter := XlWrkBkWriter.AddWorksheet(Text023);
          REPEAT
            InfoRecNo := InfoRecNo + 1;
            IF NOT UpdateProgressDialog(ExcelBufferDialogMgt,LastUpdate,RecNo + InfoRecNo,TotalRecNo) THEN BEGIN
              QuitExcel;
              ERROR(Text035)
            END;
            IF TempInfoExcelBuf.Formula = '' THEN
              WriteCellValue(TempInfoExcelBuf)
            ELSE
              WriteCellFormula(TempInfoExcelBuf)
          UNTIL TempInfoExcelBuf.NEXT = 0;
        END;

      ExcelBufferDialogMgt.Close;
    END;

    LOCAL PROCEDURE WriteCellValue@28(ExcelBuffer@1000 : Record 370);
    VAR
      Decorator@1001 : DotNet "'Microsoft.Dynamics.Nav.OpenXml, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.OpenXml.Spreadsheet.CellDecorator";
    BEGIN
      WITH ExcelBuffer DO BEGIN
        GetCellDecorator(Bold,Italic,Underline,"Double Underline",Decorator);

        CASE "Cell Type" OF
          "Cell Type"::Number:
            XlWrkShtWriter.SetCellValueNumber("Row No.",xlColID,"Cell Value as Text",NumberFormat,Decorator);
          "Cell Type"::Text:
            XlWrkShtWriter.SetCellValueText("Row No.",xlColID,"Cell Value as Text",Decorator);
          "Cell Type"::Date:
            XlWrkShtWriter.SetCellValueDate("Row No.",xlColID,"Cell Value as Text",NumberFormat,Decorator);
          "Cell Type"::Time:
            XlWrkShtWriter.SetCellValueTime("Row No.",xlColID,"Cell Value as Text",NumberFormat,Decorator);
          ELSE
            ERROR(Text039)
        END;
      END;
    END;

    LOCAL PROCEDURE WriteCellFormula@38(ExcelBuffer@1000 : Record 370);
    VAR
      Decorator@1001 : DotNet "'Microsoft.Dynamics.Nav.OpenXml, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.OpenXml.Spreadsheet.CellDecorator";
    BEGIN
      WITH ExcelBuffer DO BEGIN
        GetCellDecorator(Bold,Italic,Underline,"Double Underline",Decorator);

        XlWrkShtWriter.SetCellFormula("Row No.",xlColID,GetFormula,NumberFormat,Decorator);
      END;
    END;

    LOCAL PROCEDURE GetCellDecorator@33(IsBold@1000 : Boolean;IsItalic@1001 : Boolean;IsUnderlined@1002 : Boolean;IsDoubleUnderlined@1004 : Boolean;VAR Decorator@1003 : DotNet "'Microsoft.Dynamics.Nav.OpenXml, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.OpenXml.Spreadsheet.CellDecorator");
    BEGIN
      IF IsBold AND IsItalic THEN BEGIN
        IF IsDoubleUnderlined THEN BEGIN
          Decorator := XlWrkShtWriter.DefaultBoldItalicDoubleUnderlinedCellDecorator;
          EXIT;
        END;
        IF IsUnderlined THEN BEGIN
          Decorator := XlWrkShtWriter.DefaultBoldItalicUnderlinedCellDecorator;
          EXIT;
        END;
      END;

      IF IsBold AND IsItalic THEN BEGIN
        Decorator := XlWrkShtWriter.DefaultBoldItalicCellDecorator;
        EXIT;
      END;

      IF IsBold THEN BEGIN
        IF IsDoubleUnderlined THEN BEGIN
          Decorator := XlWrkShtWriter.DefaultBoldDoubleUnderlinedCellDecorator;
          EXIT;
        END;
        IF IsUnderlined THEN BEGIN
          Decorator := XlWrkShtWriter.DefaultBoldUnderlinedCellDecorator;
          EXIT;
        END;
      END;

      IF IsBold THEN BEGIN
        Decorator := XlWrkShtWriter.DefaultBoldCellDecorator;
        EXIT;
      END;

      IF IsItalic THEN BEGIN
        IF IsDoubleUnderlined THEN BEGIN
          Decorator := XlWrkShtWriter.DefaultItalicDoubleUnderlinedCellDecorator;
          EXIT;
        END;
        IF IsUnderlined THEN BEGIN
          Decorator := XlWrkShtWriter.DefaultItalicUnderlinedCellDecorator;
          EXIT;
        END;
      END;

      IF IsItalic THEN BEGIN
        Decorator := XlWrkShtWriter.DefaultItalicCellDecorator;
        EXIT;
      END;

      IF IsDoubleUnderlined THEN
        Decorator := XlWrkShtWriter.DefaultDoubleUnderlinedCellDecorator
      ELSE BEGIN
        IF IsUnderlined THEN
          Decorator := XlWrkShtWriter.DefaultUnderlinedCellDecorator
        ELSE
          Decorator := XlWrkShtWriter.DefaultCellDecorator;
      END;
    END;

    [Internal]
    PROCEDURE CreateRangeName@9(RangeName@1000 : Text[30];FromColumnNo@1001 : Integer;FromRowNo@1002 : Integer);
    VAR
      TempExcelBuf@1005 : TEMPORARY Record 370;
      ToxlRowID@1004 : Text[10];
    BEGIN
      SETCURRENTKEY("Row No.","Column No.");
      IF FIND('+') THEN
        ToxlRowID := xlRowID;
      TempExcelBuf.VALIDATE("Row No.",FromRowNo);
      TempExcelBuf.VALIDATE("Column No.",FromColumnNo);

      XlWrkShtWriter.AddRange(
        RangeName,
        GetExcelReference(4) + TempExcelBuf.xlColID + GetExcelReference(4) + TempExcelBuf.xlRowID +
        ':' +
        GetExcelReference(4) + TempExcelBuf.xlColID + GetExcelReference(4) + ToxlRowID);
    END;

    [Internal]
    PROCEDURE GiveUserControl@3();
    BEGIN
      IF NOT ISNULL(XlApp) THEN BEGIN
        XlApp.Visible := TRUE;
        XlApp.UserControl := TRUE;
        CLEAR(XlApp);
      END;
    END;

    [External]
    PROCEDURE ReadSheet@4();
    VAR
      ExcelBufferDialogMgt@1003 : Codeunit 5370;
      CellData@1002 : DotNet "'Microsoft.Dynamics.Nav.OpenXml, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.OpenXml.Spreadsheet.CellData";
      Enumerator@1001 : DotNet "'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.IEnumerator";
      RowCount@1009 : Integer;
      LastUpdate@1004 : DateTime;
    BEGIN
      LastUpdate := CURRENTDATETIME;
      ExcelBufferDialogMgt.Open(Text007);
      DELETEALL;

      Enumerator := XlWrkShtReader.GetEnumerator;
      RowCount := XlWrkShtReader.RowCount;
      WHILE Enumerator.MoveNext DO BEGIN
        CellData := Enumerator.Current;
        IF CellData.HasValue THEN BEGIN
          VALIDATE("Row No.",CellData.RowNumber);
          VALIDATE("Column No.",CellData.ColumnNumber);
          ParseCellValue(CellData.Value,CellData.Format);
          INSERT;

          IF NOT UpdateProgressDialog(ExcelBufferDialogMgt,LastUpdate,CellData.RowNumber,RowCount) THEN BEGIN
            QuitExcel;
            ERROR(Text035)
          END;
        END;
      END;

      QuitExcel;
      ExcelBufferDialogMgt.Close;
    END;

    LOCAL PROCEDURE ParseCellValue@40(Value@1000 : Text;FormatString@1001 : Text);
    VAR
      Decimal@1004 : Decimal;
    BEGIN
      // The format contains only en-US number separators, this is an OpenXML standard requirement
      // The algorithm sieves the data based on formatting as follows (the steps must run in this order)
      // 1. FormatString = '@' -> Text
      // 2. FormatString.Contains(':') -> Time
      // 3. FormatString.ContainsOneOf('y', 'm', 'd') && FormatString.DoesNotContain('Red') -> Date
      // 4. anything else -> Decimal

      NumberFormat := COPYSTR(FormatString,1,30);

      IF FormatString = '@' THEN BEGIN
        "Cell Type" := "Cell Type"::Text;
        "Cell Value as Text" := Value;
        EXIT;
      END;

      EVALUATE(Decimal,Value);

      IF STRPOS(FormatString,':') <> 0 THEN BEGIN
        // Excel Time is stored in OADate format
        "Cell Type" := "Cell Type"::Time;
        "Cell Value as Text" := FORMAT(DT2TIME(ConvertDateTimeDecimalToDateTime(Decimal)));
        EXIT;
      END;

      IF ((STRPOS(FormatString,'y') <> 0) OR
          (STRPOS(FormatString,'m') <> 0) OR
          (STRPOS(FormatString,'d') <> 0)) AND
         (STRPOS(FormatString,'Red') = 0)
      THEN BEGIN
        "Cell Type" := "Cell Type"::Date;
        "Cell Value as Text" := FORMAT(DT2DATE(ConvertDateTimeDecimalToDateTime(Decimal)));
        EXIT;
      END;

      "Cell Type" := "Cell Type"::Number;
      "Cell Value as Text" := FORMAT(ROUND(Decimal,0.000001),0,1);
    END;

    [External]
    PROCEDURE SelectSheetsName@6(FileName@1000 : Text) : Text[250];
    VAR
      TempNameValueBuffer@1009 : TEMPORARY Record 823;
      SheetNames@1008 : DotNet "'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.ArrayList";
      SheetName@1002 : Text[250];
      SelectedSheetName@1007 : Text[250];
      i@1001 : Integer;
    BEGIN
      IF FileName = '' THEN
        ERROR(Text001);

      XlWrkBkReader := XlWrkBkReader.Open(FileName);

      SelectedSheetName := '';
      SheetNames := SheetNames.ArrayList(XlWrkBkReader.SheetNames);
      IF NOT ISNULL(SheetNames) THEN BEGIN
        FOR i := 0 TO SheetNames.Count - 1 DO BEGIN
          SheetName := SheetNames.Item(i);
          IF SheetName <> '' THEN BEGIN
            TempNameValueBuffer.INIT;
            TempNameValueBuffer.ID := i;
            TempNameValueBuffer.Name := FORMAT(i + 1);
            TempNameValueBuffer.Value := SheetName;
            TempNameValueBuffer.INSERT;
          END;
        END;
        IF NOT TempNameValueBuffer.ISEMPTY THEN
          IF TempNameValueBuffer.COUNT = 1 THEN
            SelectedSheetName := TempNameValueBuffer.Value
          ELSE BEGIN
            TempNameValueBuffer.FINDFIRST;
            IF PAGE.RUNMODAL(PAGE::"Name/Value Lookup",TempNameValueBuffer) = ACTION::LookupOK THEN
              SelectedSheetName := TempNameValueBuffer.Value;
          END;
      END;

      QuitExcel;
      EXIT(SelectedSheetName);
    END;

    [External]
    PROCEDURE GetExcelReference@10(Which@1000 : Integer) : Text[250];
    BEGIN
      CASE Which OF
        1:
          EXIT(Text013);
        // DO NOT TRANSLATE: &B is the Excel code to turn bold printing on or off for customized Header/Footer.
        2:
          EXIT(Text014);
        // DO NOT TRANSLATE: &D is the Excel code to print the current date in customized Header/Footer.
        3:
          EXIT(Text015);
        // DO NOT TRANSLATE: &P is the Excel code to print the page number in customized Header/Footer.
        4:
          EXIT('$');
        // DO NOT TRANSLATE: $ is the Excel code for absolute reference to cells.
        5:
          EXIT(Text016);
        // DO NOT TRANSLATE: A1 is the Excel reference of the first cell.
        6:
          EXIT(Text017);
        // DO NOT TRANSLATE: SUMIF is the name of the Excel function used to summarize values according to some conditions.
        7:
          EXIT(Text018);
        // DO NOT TRANSLATE: The #N/A Excel error value occurs when a value is not available to a function or formula.
        8:
          EXIT(Text019);
        // DO NOT TRANSLATE: GLAcc is used to define an Excel range name. You must refer to Excel rules to change this term.
        9:
          EXIT(Text020);
        // DO NOT TRANSLATE: Period is used to define an Excel range name. You must refer to Excel rules to change this term.
        10:
          EXIT(Text021);
        // DO NOT TRANSLATE: Budget is used to define an Excel worksheet name. You must refer to Excel rules to change this term.
        11:
          EXIT(Text022);
        // DO NOT TRANSLATE: CostAcc is used to define an Excel range name. You must refer to Excel rules to change this term.
      END;
    END;

    [External]
    PROCEDURE ExportBudgetFilterToFormula@11(VAR ExcelBuf@1000 : Record 370) : Boolean;
    VAR
      TempExcelBufFormula@1001 : TEMPORARY Record 370;
      TempExcelBufFormula2@1004 : TEMPORARY Record 370;
      FirstRow@1002 : Integer;
      LastRow@1003 : Integer;
      HasFormulaError@1005 : Boolean;
      ThisCellHasFormulaError@1006 : Boolean;
    BEGIN
      ExcelBuf.SETFILTER(Formula,'<>%1','');
      IF ExcelBuf.FINDSET THEN
        REPEAT
          TempExcelBufFormula := ExcelBuf;
          TempExcelBufFormula.INSERT;
        UNTIL ExcelBuf.NEXT = 0;
      ExcelBuf.RESET;

      WITH TempExcelBufFormula DO
        IF FINDSET THEN
          REPEAT
            ThisCellHasFormulaError := FALSE;
            ExcelBuf.SETRANGE("Column No.",1);
            ExcelBuf.SETFILTER("Row No.",'<>%1',"Row No.");
            ExcelBuf.SETFILTER("Cell Value as Text",Formula);
            TempExcelBufFormula2 := TempExcelBufFormula;
            IF ExcelBuf.FINDSET THEN
              REPEAT
                IF NOT GET(ExcelBuf."Row No.","Column No.") THEN
                  ExcelBuf.MARK(TRUE);
              UNTIL ExcelBuf.NEXT = 0;
            TempExcelBufFormula := TempExcelBufFormula2;
            ClearFormula;
            ExcelBuf.SETRANGE("Cell Value as Text");
            ExcelBuf.SETRANGE("Row No.");
            IF ExcelBuf.FINDSET THEN
              REPEAT
                IF ExcelBuf.MARK THEN BEGIN
                  LastRow := ExcelBuf."Row No.";
                  IF FirstRow = 0 THEN
                    FirstRow := LastRow;
                END ELSE
                  IF FirstRow <> 0 THEN BEGIN
                    IF FirstRow = LastRow THEN
                      ThisCellHasFormulaError := AddToFormula(xlColID + FORMAT(FirstRow))
                    ELSE
                      ThisCellHasFormulaError :=
                        AddToFormula('SUM(' + xlColID + FORMAT(FirstRow) + ':' + xlColID + FORMAT(LastRow) + ')');
                    FirstRow := 0;
                    IF ThisCellHasFormulaError THEN
                      SetFormula(ExcelBuf.GetExcelReference(7));
                  END;
              UNTIL ThisCellHasFormulaError OR (ExcelBuf.NEXT = 0);

            IF NOT ThisCellHasFormulaError AND (FirstRow <> 0) THEN BEGIN
              IF FirstRow = LastRow THEN
                ThisCellHasFormulaError := AddToFormula(xlColID + FORMAT(FirstRow))
              ELSE
                ThisCellHasFormulaError :=
                  AddToFormula('SUM(' + xlColID + FORMAT(FirstRow) + ':' + xlColID + FORMAT(LastRow) + ')');
              FirstRow := 0;
              IF ThisCellHasFormulaError THEN
                SetFormula(ExcelBuf.GetExcelReference(7));
            END;

            ExcelBuf.RESET;
            ExcelBuf.GET("Row No.","Column No.");
            ExcelBuf.SetFormula(GetFormula);
            ExcelBuf.MODIFY;
            HasFormulaError := HasFormulaError OR ThisCellHasFormulaError;
          UNTIL NEXT = 0;

      EXIT(HasFormulaError);
    END;

    [External]
    PROCEDURE AddToFormula@12(Text@1001 : Text[30]) : Boolean;
    VAR
      Overflow@1002 : Boolean;
      LongFormula@1000 : Text[1000];
    BEGIN
      LongFormula := GetFormula;
      IF LongFormula = '' THEN
        LongFormula := '=';
      IF LongFormula <> '=' THEN
        IF STRLEN(LongFormula) + 1 > MAXSTRLEN(LongFormula) THEN
          Overflow := TRUE
        ELSE
          LongFormula := LongFormula + '+';
      IF STRLEN(LongFormula) + STRLEN(Text) > MAXSTRLEN(LongFormula) THEN
        Overflow := TRUE
      ELSE
        SetFormula(LongFormula + Text);
      EXIT(Overflow);
    END;

    [External]
    PROCEDURE GetFormula@13() : Text[1000];
    BEGIN
      EXIT(Formula + Formula2 + Formula3 + Formula4);
    END;

    [External]
    PROCEDURE SetFormula@22(LongFormula@1000 : Text[1000]);
    BEGIN
      ClearFormula;
      IF LongFormula = '' THEN
        EXIT;

      Formula := COPYSTR(LongFormula,1,MAXSTRLEN(Formula));
      IF STRLEN(LongFormula) > MAXSTRLEN(Formula) THEN
        Formula2 := COPYSTR(LongFormula,MAXSTRLEN(Formula) + 1,MAXSTRLEN(Formula2));
      IF STRLEN(LongFormula) > MAXSTRLEN(Formula) + MAXSTRLEN(Formula2) THEN
        Formula3 := COPYSTR(LongFormula,MAXSTRLEN(Formula) + MAXSTRLEN(Formula2) + 1,MAXSTRLEN(Formula3));
      IF STRLEN(LongFormula) > MAXSTRLEN(Formula) + MAXSTRLEN(Formula2) + MAXSTRLEN(Formula3) THEN
        Formula4 := COPYSTR(LongFormula,MAXSTRLEN(Formula) + MAXSTRLEN(Formula2) + MAXSTRLEN(Formula3) + 1,MAXSTRLEN(Formula4));
    END;

    [External]
    PROCEDURE ClearFormula@18();
    BEGIN
      Formula := '';
      Formula2 := '';
      Formula3 := '';
      Formula4 := '';
    END;

    [External]
    PROCEDURE NewRow@14();
    BEGIN
      CurrentRow := CurrentRow + 1;
      CurrentCol := 0;
    END;

    [External]
    PROCEDURE AddColumn@16(Value@1000 : Variant;IsFormula@1001 : Boolean;CommentText@1002 : Text[1000];IsBold@1003 : Boolean;IsItalics@1004 : Boolean;IsUnderline@1005 : Boolean;NumFormat@1006 : Text[30];CellType@1007 : Option);
    BEGIN
      IF CurrentRow < 1 THEN
        NewRow;

      CurrentCol := CurrentCol + 1;
      INIT;
      VALIDATE("Row No.",CurrentRow);
      VALIDATE("Column No.",CurrentCol);
      IF IsFormula THEN
        SetFormula(FORMAT(Value))
      ELSE
        "Cell Value as Text" := FORMAT(Value);
      Comment := CommentText;
      Bold := IsBold;
      Italic := IsItalics;
      Underline := IsUnderline;
      NumberFormat := NumFormat;
      "Cell Type" := CellType;
      INSERT;
    END;

    [External]
    PROCEDURE StartRange@19();
    VAR
      DummyExcelBuf@1000 : Record 370;
    BEGIN
      DummyExcelBuf.VALIDATE("Row No.",CurrentRow);
      DummyExcelBuf.VALIDATE("Column No.",CurrentCol);

      RangeStartXlRow := DummyExcelBuf.xlRowID;
      RangeStartXlCol := DummyExcelBuf.xlColID;
    END;

    [External]
    PROCEDURE EndRange@23();
    VAR
      DummyExcelBuf@1000 : Record 370;
    BEGIN
      DummyExcelBuf.VALIDATE("Row No.",CurrentRow);
      DummyExcelBuf.VALIDATE("Column No.",CurrentCol);

      RangeEndXlRow := DummyExcelBuf.xlRowID;
      RangeEndXlCol := DummyExcelBuf.xlColID;
    END;

    [External]
    PROCEDURE CreateRange@45(RangeName@1000 : Text[250]);
    BEGIN
      XlWrkShtWriter.AddRange(
        RangeName,
        GetExcelReference(4) + RangeStartXlCol + GetExcelReference(4) + RangeStartXlRow +
        ':' +
        GetExcelReference(4) + RangeEndXlCol + GetExcelReference(4) + RangeEndXlRow);
    END;

    [Internal]
    PROCEDURE AutoFit@20(RangeName@1000 : Text[50]);
    BEGIN
      IF NOT ISNULL(XlWrkBk) THEN
        XlHelper.AutoFitRangeColumns(XlWrkBk,ActiveSheetName,RangeName);
    END;

    [Internal]
    PROCEDURE BorderAround@39(RangeName@1000 : Text[50]);
    BEGIN
      IF NOT ISNULL(XlWrkBk) THEN
        XlHelper.BorderAroundRange(XlWrkBk,ActiveSheetName,RangeName,1);
    END;

    [External]
    PROCEDURE ClearNewRow@26();
    BEGIN
      CurrentRow := 0;
      CurrentCol := 0;
    END;

    [External]
    PROCEDURE SetUseInfoSheet@25();
    BEGIN
      UseInfoSheet := TRUE;
    END;

    [External]
    PROCEDURE AddInfoColumn@24(Value@1006 : Variant;IsFormula@1005 : Boolean;IsBold@1003 : Boolean;IsItalics@1002 : Boolean;IsUnderline@1001 : Boolean;NumFormat@1000 : Text[30];CellType@1007 : Option);
    BEGIN
      IF CurrentRow < 1 THEN
        NewRow;

      CurrentCol := CurrentCol + 1;
      INIT;
      TempInfoExcelBuf.VALIDATE("Row No.",CurrentRow);
      TempInfoExcelBuf.VALIDATE("Column No.",CurrentCol);
      IF IsFormula THEN
        TempInfoExcelBuf.SetFormula(FORMAT(Value))
      ELSE
        TempInfoExcelBuf."Cell Value as Text" := FORMAT(Value);
      TempInfoExcelBuf.Bold := IsBold;
      TempInfoExcelBuf.Italic := IsItalics;
      TempInfoExcelBuf.Underline := IsUnderline;
      TempInfoExcelBuf.NumberFormat := NumFormat;
      TempInfoExcelBuf."Cell Type" := CellType;
      TempInfoExcelBuf.INSERT;
    END;

    [External]
    PROCEDURE UTgetGlobalValue@35(globalVariable@1001 : Text[30];VAR value@1000 : Variant);
    BEGIN
      CASE globalVariable OF
        'CurrentRow':
          value := CurrentRow;
        'CurrentCol':
          value := CurrentCol;
        'RangeStartXlRow':
          value := RangeStartXlRow;
        'RangeStartXlCol':
          value := RangeStartXlCol;
        'RangeEndXlRow':
          value := RangeEndXlRow;
        'RangeEndXlCol':
          value := RangeEndXlCol;
        'XlWrkSht':
          value := XlWrkShtWriter;
        'ExcelFile':
          value := FileNameServer;
        ELSE
          ERROR(Text038,globalVariable);
      END;
    END;

    [External]
    PROCEDURE SetCurrent@27(NewCurrentRow@1000 : Integer;NewCurrentCol@1001 : Integer);
    BEGIN
      CurrentRow := NewCurrentRow;
      CurrentCol := NewCurrentCol;
    END;

    [Internal]
    PROCEDURE CreateValidationRule@17(Range@1000 : Code[20]);
    BEGIN
      XlWrkShtWriter.AddRangeDataValidation(
        Range,
        GetExcelReference(4) + RangeStartXlCol + GetExcelReference(4) + RangeStartXlRow +
        ':' +
        GetExcelReference(4) + RangeEndXlCol + GetExcelReference(4) + RangeEndXlRow);
    END;

    [Internal]
    PROCEDURE QuitExcel@29();
    BEGIN
      // Close and clear the OpenXml book
      CloseBook;

      // Clear the worksheet automation
      IF NOT ISNULL(XlWrkSht) THEN
        CLEAR(XlWrkSht);

      // Clear the workbook automation
      IF NOT ISNULL(XlWrkBk) THEN
        CLEAR(XlWrkBk);

      // Clear and quit the Excel application automation
      IF NOT ISNULL(XlApp) THEN BEGIN
        XlHelper.CallQuit(XlApp);
        CLEAR(XlApp);
      END;
    END;

    [External]
    PROCEDURE OpenExcel@31();
    VAR
      FileNameClient@1000 : Text;
    BEGIN
      IF OpenUsingDocumentService('') THEN
        EXIT;

      IF NOT PreOpenExcel THEN
        EXIT;

      // rename the Temporary filename into a more UI friendly name in a new subdirectory
      FileNameClient := FileManagement.DownloadTempFile(FileNameServer);
      FileNameClient := FileManagement.MoveAndRenameClientFile(FileNameClient,GetFriendlyFilename,FORMAT(CREATEGUID));

      XlWrkBk := XlHelper.CallOpen(XlApp,FileNameClient);

      PostOpenExcel;
    END;

    [Internal]
    PROCEDURE DownloadAndOpenExcel@34();
    VAR
      ClientFilename@1000 : Text;
    BEGIN
      ClientFilename := GetFriendlyFilename;

      IF FileManagement.CanRunDotNetOnClient THEN BEGIN
        ClientFilename := FileManagement.SaveFileDialog('Save file','',Text034);
        IF ClientFilename = '' THEN
          EXIT;
        IF FileManagement.GetExtension(ClientFilename) = '' THEN
          ClientFilename += ExcelFileExtensionTok;
      END;

      OverwriteAndOpenExistingExcel(ClientFilename);
    END;

    [Internal]
    PROCEDURE OverwriteAndOpenExistingExcel@15(FileName@1000 : Text);
    BEGIN
      IF FileName = '' THEN
        ERROR(Text001);

      IF OpenUsingDocumentService(FileName) THEN
        EXIT;

      IF NOT PreOpenExcel THEN
        EXIT;

      FileManagement.DownloadToFile(FileNameServer,FileName);
      XlWrkBk := XlHelper.CallOpen(XlApp,FileName);

      PostOpenExcel;
    END;

    LOCAL PROCEDURE OpenUsingDocumentService@21(FileName@1000 : Text) : Boolean;
    VAR
      DocumentServiceMgt@1005 : Codeunit 9510;
      FileMgt@1004 : Codeunit 419;
      PathHelper@1003 : DotNet "'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.Path";
      DialogWindow@1002 : Dialog;
      DocumentUrl@1001 : Text;
    BEGIN
      IF NOT EXISTS(FileNameServer) THEN
        ERROR(Text003,FileNameServer);

      // if document service is configured we save the generated document to SharePoint and open it from there.
      IF DocumentServiceMgt.IsConfigured THEN BEGIN
        IF FileName = '' THEN
          FileName := 'Book.' + PathHelper.ChangeExtension(PathHelper.GetRandomFileName,'xlsx')
        ELSE BEGIN
          // if file is not applicable for the service it can not be opened using the document service.
          IF NOT DocumentServiceMgt.IsServiceUri(FileName) THEN
            EXIT(FALSE);

          FileName := FileMgt.GetFileName(FileName);
        END;

        DialogWindow.OPEN(STRSUBSTNO(SavingDocumentMsg,FileName));
        DocumentUrl := DocumentServiceMgt.SaveFile(FileNameServer,FileName,TRUE);
        DocumentServiceMgt.OpenDocument(DocumentUrl);
        DialogWindow.CLOSE;
        EXIT(TRUE);
      END;

      EXIT(FALSE);
    END;

    LOCAL PROCEDURE PreOpenExcel@7() : Boolean;
    BEGIN
      IF NOT EXISTS(FileNameServer) THEN
        ERROR(Text003,FileNameServer);

      // Download file, if none RTC it should return a filename, and use client automation instead.
      IF NOT FileManagement.CanRunDotNetOnClient THEN BEGIN
        IF NOT FileManagement.DownloadHandler(FileNameServer,Text040,'',Text034,GetFriendlyFilename) THEN
          ERROR(Text001);
        EXIT(FALSE);
      END;

      XlApp := XlApp.ApplicationClass;
      IF ISNULL(XlApp) THEN
        ERROR(Text000);

      EXIT(TRUE);
    END;

    LOCAL PROCEDURE PostOpenExcel@8();
    BEGIN
      XlWrkBk := XlApp.ActiveWorkbook;

      IF ISNULL(XlWrkBk) THEN
        ERROR(Text036);

      // autofit all columns on all worksheets
      XlHelper.AutoFitColumnsInAllWorksheets(XlWrkBk);

      // activate the previous saved sheet name in the workbook
      XlHelper.ActivateSheet(XlWrkBk,ActiveSheetName);
    END;

    [Internal]
    PROCEDURE CreateBookAndOpenExcel@32(FileName@1004 : Text;SheetName@1000 : Text[250];ReportHeader@1003 : Text;CompanyName2@1002 : Text;UserID2@1001 : Text);
    BEGIN
      CreateBook(FileName,SheetName);
      WriteSheet(ReportHeader,CompanyName2,UserID2);
      CloseBook;
      OpenExcel;
      GiveUserControl;
    END;

    LOCAL PROCEDURE UpdateProgressDialog@36(VAR ExcelBufferDialogManagement@1000 : Codeunit 5370;VAR LastUpdate@1001 : DateTime;CurrentCount@1002 : Integer;TotalCount@1004 : Integer) : Boolean;
    VAR
      CurrentTime@1003 : DateTime;
    BEGIN
      // Refresh at 100%, and every second in between 0% to 100%
      // Duration is measured in miliseconds -> 1 sec = 1000 ms
      CurrentTime := CURRENTDATETIME;
      IF (CurrentCount = TotalCount) OR (CurrentTime - LastUpdate >= 1000) THEN BEGIN
        LastUpdate := CurrentTime;
        IF NOT ExcelBufferDialogManagement.SetProgress(ROUND(CurrentCount / TotalCount * 10000,1)) THEN
          EXIT(FALSE);
      END;

      EXIT(TRUE)
    END;

    LOCAL PROCEDURE GetFriendlyFilename@46() : Text;
    BEGIN
      IF FriendlyName = '' THEN
        EXIT('Book1' + ExcelFileExtensionTok);

      EXIT(FileManagement.StripNotsupportChrInFileName(FriendlyName) + ExcelFileExtensionTok);
    END;

    [External]
    PROCEDURE SetFriendlyFilename@41(Name@1000 : Text);
    BEGIN
      FriendlyName := Name;
    END;

    [External]
    PROCEDURE ConvertDateTimeDecimalToDateTime@43(DateTimeAsOADate@1000 : Decimal) : DateTime;
    VAR
      DotNetDateTime@1003 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.DateTime";
      DotNetDateTimeWithKind@1002 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.DateTime";
      DotNetDateTimeKind@1001 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.DateTimeKind";
    BEGIN
      DotNetDateTime := DotNetDateTime.FromOADate(DateTimeAsOADate);
      DotNetDateTimeWithKind := DotNetDateTime.DateTime(DotNetDateTime.Ticks,DotNetDateTimeKind.Local);
      EXIT(DotNetDateTimeWithKind);
    END;

    BEGIN
    END.
  }
}

