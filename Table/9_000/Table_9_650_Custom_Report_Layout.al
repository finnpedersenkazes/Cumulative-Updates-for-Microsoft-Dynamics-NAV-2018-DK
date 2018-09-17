OBJECT Table 9650 Custom Report Layout
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    DataPerCompany=No;
    OnInsert=BEGIN
               TESTFIELD("Report ID");
               IF Code = '' THEN
                 Code := GetDefaultCode("Report ID");
               SetUpdated;
             END;

    OnModify=BEGIN
               TESTFIELD("Report ID");
               SetUpdated;
             END;

    OnDelete=BEGIN
               IF "Built-In" THEN
                 ERROR(DeleteBuiltInLayoutErr);
             END;

    CaptionML=[DAN=Tilpasset rapportlayout;
               ENU=Custom Report Layout];
    LookupPageID=Page9650;
    DrillDownPageID=Page9650;
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code20        ;CaptionML=[DAN=Kode;
                                                              ENU=Code] }
    { 2   ;   ;Report ID           ;Integer       ;TableRelation=AllObjWithCaption."Object ID" WHERE (Object Type=CONST(Report));
                                                   CaptionML=[DAN=Rapport-id;
                                                              ENU=Report ID] }
    { 3   ;   ;Report Name         ;Text80        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(AllObjWithCaption."Object Caption" WHERE (Object Type=CONST(Report),
                                                                                                                Object ID=FIELD(Report ID)));
                                                   CaptionML=[DAN=Rapportnavn;
                                                              ENU=Report Name];
                                                   Editable=No }
    { 4   ;   ;Company Name        ;Text30        ;TableRelation=Company;
                                                   CaptionML=[DAN=Virksomhedsnavn;
                                                              ENU=Company Name] }
    { 6   ;   ;Type                ;Option        ;InitValue=Word;
                                                   CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=RDLC,Word;
                                                                    ENU=RDLC,Word];
                                                   OptionString=RDLC,Word }
    { 7   ;   ;Layout              ;BLOB          ;CaptionML=[DAN=Layout;
                                                              ENU=Layout] }
    { 8   ;   ;Last Modified       ;DateTime      ;CaptionML=[DAN=Sidst �ndret;
                                                              ENU=Last Modified];
                                                   Editable=No }
    { 9   ;   ;Last Modified by User;Code50       ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("Last Modified by User");
                                                            END;

                                                   ValidateTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Sidst �ndret af bruger;
                                                              ENU=Last Modified by User];
                                                   Editable=No }
    { 10  ;   ;File Extension      ;Text30        ;CaptionML=[DAN=Filtype;
                                                              ENU=File Extension];
                                                   Editable=No }
    { 11  ;   ;Description         ;Text250       ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 12  ;   ;Custom XML Part     ;BLOB          ;CaptionML=[DAN=Brugerdefineret XML-del;
                                                              ENU=Custom XML Part] }
    { 13  ;   ;App ID              ;GUID          ;CaptionML=[DAN=App-id;
                                                              ENU=App ID];
                                                   Editable=No }
    { 14  ;   ;Built-In            ;Boolean       ;CaptionML=[DAN=Indbygget;
                                                              ENU=Built-In];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Code                                    ;Clustered=Yes }
    {    ;Report ID,Company Name,Type              }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;Description                              }
  }
  CODE
  {
    VAR
      ImportWordTxt@1000 : TextConst 'DAN=Import�r Word-dokument;ENU=Import Word Document';
      ImportRdlcTxt@1006 : TextConst 'DAN=Import�r rapportlayout;ENU=Import Report Layout';
      FileFilterWordTxt@1001 : TextConst '@@@="{Split=r''\|''}{Locked=s''1''}";DAN=Word-filer (*.docx)|*.docx;ENU=Word Files (*.docx)|*.docx';
      FileFilterRdlcTxt@1005 : TextConst '@@@="{Split=r''\|''}{Locked=s''1''}";DAN="SQL Report Builder (*.rdl;*.rdlc)|*.rdl;*.rdlc";ENU="SQL Report Builder (*.rdl;*.rdlc)|*.rdl;*.rdlc"';
      NoRecordsErr@1002 : TextConst 'DAN=Der er ingen record p� listen.;ENU=There is no record in the list.';
      BuiltInTxt@1003 : TextConst 'DAN=Indbygget layout;ENU=Built-in layout';
      CopyOfTxt@1004 : TextConst 'DAN=Kopi af %1;ENU=Copy of %1';
      NewLayoutTxt@1007 : TextConst 'DAN=Nyt layout;ENU=New layout';
      ErrorInLayoutErr@1008 : TextConst '@@@="%1=a name, %2=a number, %3=a sentence/error description.";DAN=F�lgende problem er fundet i layoutet %1 for rapport-id''et %2:\%3.;ENU=The following issue has been found in the layout %1 for report ID  %2:\%3.';
      TemplateValidationQst@1011 : TextConst '@@@="%1 = an error message.";DAN=RDCL-layoutet stemmer ikke overens med det aktuelle rapportdesign (felter mangler f.eks., eller rapport-id''et er forkert).\F�lgende fejl er registreret under layoutvalideringen:\%1\Vil du forts�tte?;ENU=The RDLC layout does not comply with the current report design (for example, fields are missing or the report ID is wrong).\The following errors were detected during the layout validation:\%1\Do you want to continue?';
      TemplateValidationErr@1010 : TextConst 'DAN=RDLC-layoutet stemmer ikke overens med det aktuelle rapportdesign (felter mangler f.eks., eller rapport-id''et er forkert).\F�lgende fejl er registreret under dokumentvalideringen:\%1\Du skal opdatere layoutet, s� det stemmer overens med det aktuelle rapportdesign.;ENU=The RDLC layout does not comply with the current report design (for example, fields are missing or the report ID is wrong).\The following errors were detected during the document validation:\%1\You must update the layout to match the current report design.';
      AbortWithValidationErr@1009 : TextConst 'DAN=RDLC-layouthandlingen er annulleret p� grund af valideringsfejl.;ENU=The RDLC layout action has been canceled because of validation errors.';
      ModifyBuiltInLayoutQst@1012 : TextConst 'DAN=Dette er et indbygget, brugerdefineret rapportlayout, og det kan ikke �ndres.\\Vil du i stedet �ndre en kopi af det brugerdefinerede rapportlayout?;ENU=This is a built-in custom report layout, and it cannot be modified.\\Do you want to modify a copy of the custom report layout instead?';
      NoLayoutSelectedMsg@1013 : TextConst 'DAN=Du skal angive, om du vil inds�tte et Word-layout eller et RDLC-layout for rapporten.;ENU=You must specify if you want to insert a Word layout or an RDLC layout for the report.';
      DeleteBuiltInLayoutErr@1014 : TextConst 'DAN=Dette er et integreret brugerdefineret rapportlayout og kan ikke slettes.;ENU=This is a built-in custom report layout, and it cannot be deleted.';
      ModifyBuiltInLayoutErr@1015 : TextConst 'DAN=Dette er et integreret brugerdefineret rapportlayout og kan ikke �ndres.;ENU=This is a built-in custom report layout, and it cannot be modified.';

    LOCAL PROCEDURE SetUpdated@2();
    BEGIN
      "Last Modified" := ROUNDDATETIME(CURRENTDATETIME);
      "Last Modified by User" := USERID;
    END;

    [Internal]
    PROCEDURE InitBuiltInLayout@11(ReportID@1003 : Integer;LayoutType@1004 : Option) : Code[20];
    VAR
      CustomReportLayout@1002 : Record 9650;
      TempBlob@1007 : Record 99008535;
      DocumentReportMgt@1005 : Codeunit 9651;
      InStr@1001 : InStream;
      OutStr@1000 : OutStream;
    BEGIN
      IF ReportID = 0 THEN
        EXIT;

      CustomReportLayout.INIT;
      CustomReportLayout."Report ID" := ReportID;
      CustomReportLayout.Type := LayoutType;
      CustomReportLayout.Description := COPYSTR(STRSUBSTNO(CopyOfTxt,BuiltInTxt),1,MAXSTRLEN(Description));
      CustomReportLayout."Built-In" := FALSE;
      CustomReportLayout.Code := GetDefaultCode(ReportID);
      CustomReportLayout.INSERT(TRUE);

      CASE LayoutType OF
        CustomReportLayout.Type::Word:
          BEGIN
            TempBlob.Blob.CREATEOUTSTREAM(OutStr);
            IF NOT REPORT.WORDLAYOUT(ReportID,InStr) THEN BEGIN
              DocumentReportMgt.NewWordLayout(ReportID,OutStr);
              CustomReportLayout.Description := COPYSTR(NewLayoutTxt,1,MAXSTRLEN(Description));
            END ELSE
              COPYSTREAM(OutStr,InStr);
            CustomReportLayout.SetLayoutBlob(TempBlob);
          END;
        CustomReportLayout.Type::RDLC:
          IF REPORT.RDLCLAYOUT(ReportID,InStr) THEN BEGIN
            TempBlob.Blob.CREATEOUTSTREAM(OutStr);
            COPYSTREAM(OutStr,InStr);
            CustomReportLayout.SetLayoutBlob(TempBlob);
          END;
      END;

      CustomReportLayout.SetDefaultCustomXmlPart;

      EXIT(CustomReportLayout.Code);
    END;

    [Internal]
    PROCEDURE CopyBuiltInLayout@13();
    VAR
      ReportLayoutLookup@1000 : Page 9651;
      ReportID@1001 : Integer;
    BEGIN
      FILTERGROUP(4);
      IF GETFILTER("Report ID") = '' THEN
        FILTERGROUP(0);
      IF GETFILTER("Report ID") <> '' THEN
        IF EVALUATE(ReportID,GETFILTER("Report ID")) THEN
          ReportLayoutLookup.SetReportID(ReportID);
      FILTERGROUP(0);
      IF ReportLayoutLookup.RUNMODAL = ACTION::OK THEN BEGIN
        IF NOT ReportLayoutLookup.SelectedAddWordLayot AND NOT ReportLayoutLookup.SelectedAddRdlcLayot THEN BEGIN
          MESSAGE(NoLayoutSelectedMsg);
          EXIT;
        END;

        IF ReportLayoutLookup.SelectedAddWordLayot THEN
          InitBuiltInLayout(ReportLayoutLookup.SelectedReportID,Type::Word);
        IF ReportLayoutLookup.SelectedAddRdlcLayot THEN
          InitBuiltInLayout(ReportLayoutLookup.SelectedReportID,Type::RDLC);
      END;
    END;

    [Internal]
    PROCEDURE GetCustomRdlc@10(ReportID@1000 : Integer) : Text;
    VAR
      ReportLayoutSelection@1003 : Record 9651;
      InStream@1002 : InStream;
      RdlcTxt@1001 : Text;
      CustomLayoutCode@1004 : Code[20];
    BEGIN
      // Temporarily selected layout for Design-time report execution?
      IF ReportLayoutSelection.GetTempLayoutSelected <> '' THEN
        CustomLayoutCode := ReportLayoutSelection.GetTempLayoutSelected
      ELSE  // Normal selection
        IF ReportLayoutSelection.HasCustomLayout(ReportID) = 1 THEN
          CustomLayoutCode := ReportLayoutSelection."Custom Report Layout Code";

      IF (CustomLayoutCode <> '') AND GET(CustomLayoutCode) THEN BEGIN
        TESTFIELD(Type,Type::RDLC);
        IF UpdateLayout(TRUE,FALSE) THEN
          COMMIT; // Save the updated layout
        RdlcTxt := GetLayout;
      END ELSE BEGIN
        REPORT.RDLCLAYOUT(ReportID,InStream);
        InStream.READ(RdlcTxt);
      END;

      EXIT(RdlcTxt);
    END;

    [Internal]
    PROCEDURE CopyRecord@7() : Code[20];
    VAR
      CustomReportLayout@1001 : Record 9650;
      TempBlob@1002 : Record 99008535;
    BEGIN
      IF ISEMPTY THEN
        ERROR(NoRecordsErr);

      CALCFIELDS(Layout,"Custom XML Part");
      CustomReportLayout := Rec;

      Description := COPYSTR(STRSUBSTNO(CopyOfTxt,Description),1,MAXSTRLEN(Description));
      Code := GetDefaultCode("Report ID");
      "Built-In" := FALSE;
      INSERT(TRUE);

      IF CustomReportLayout."Built-In" THEN BEGIN
        CustomReportLayout.GetLayoutBlob(TempBlob);
        SetLayoutBlob(TempBlob);
      END;

      IF NOT HasCustomXmlPart THEN
        SetDefaultCustomXmlPart;

      EXIT(Code);
    END;

    [Internal]
    PROCEDURE ImportLayout@6(DefaultFileName@1005 : Text);
    VAR
      TempBlob@1000 : Record 99008535;
      FileMgt@1001 : Codeunit 419;
      FileName@1003 : Text;
      FileFilterTxt@1002 : Text;
      ImportTxt@1004 : Text;
    BEGIN
      IF ISEMPTY THEN
        ERROR(NoRecordsErr);

      IF NOT CanBeModified THEN
        EXIT;

      CASE Type OF
        Type::Word:
          BEGIN
            ImportTxt := ImportWordTxt;
            FileFilterTxt := FileFilterWordTxt;
          END;
        Type::RDLC:
          BEGIN
            ImportTxt := ImportRdlcTxt;
            FileFilterTxt := FileFilterRdlcTxt;
          END;
      END;
      FileName := FileMgt.BLOBImportWithFilter(TempBlob,ImportTxt,DefaultFileName,FileFilterTxt,FileFilterTxt);
      IF FileName = '' THEN
        EXIT;

      ImportLayoutBlob(TempBlob,UPPERCASE(FileMgt.GetExtension(FileName)));
    END;

    [Internal]
    PROCEDURE ImportLayoutBlob@17(VAR TempBlob@1000 : Record 99008535;FileExtension@1001 : Text[30]);
    VAR
      OutputTempBlob@1008 : Record 99008535;
      DocumentReportMgt@1006 : Codeunit 9651;
      DocumentInStream@1007 : InStream;
      DocumentOutStream@1009 : OutStream;
      ErrorMessage@1010 : Text;
      XmlPart@1002 : Text;
    BEGIN
      // Layout is stored in the DocumentInStream (RDLC requires UTF8 encoding for which reason is stream is created in the case block.
      // Result is stored in the DocumentOutStream (..)
      TESTFIELD("Report ID");
      OutputTempBlob.Blob.CREATEOUTSTREAM(DocumentOutStream);
      XmlPart := GetWordXmlPart("Report ID");

      CASE Type OF
        Type::Word:
          BEGIN
            // Run update
            TempBlob.Blob.CREATEINSTREAM(DocumentInStream);
            ErrorMessage := DocumentReportMgt.TryUpdateWordLayout(DocumentInStream,DocumentOutStream,'',XmlPart);
            // Validate the Word document layout against the layout of the current report
            IF ErrorMessage = '' THEN BEGIN
              COPYSTREAM(DocumentOutStream,DocumentInStream);
              DocumentReportMgt.ValidateWordLayout("Report ID",DocumentInStream,TRUE,TRUE);
            END;
          END;
        Type::RDLC:
          BEGIN
            // Update the Rdlc document layout against the layout of the current report
            TempBlob.Blob.CREATEINSTREAM(DocumentInStream,TEXTENCODING::UTF8);
            ErrorMessage := DocumentReportMgt.TryUpdateRdlcLayout("Report ID",DocumentInStream,DocumentOutStream,'',XmlPart,FALSE);
          END;
      END;

      SetLayoutBlob(OutputTempBlob);

      IF FileExtension <> '' THEN
        "File Extension" := FileExtension;
      SetDefaultCustomXmlPart;
      MODIFY(TRUE);
      COMMIT;

      IF ErrorMessage <> '' THEN
        MESSAGE(ErrorMessage);
    END;

    [Internal]
    PROCEDURE ExportLayout@1(DefaultFileName@1003 : Text;ShowFileDialog@1002 : Boolean) : Text;
    VAR
      TempBlob@1001 : Record 99008535;
      FileMgt@1000 : Codeunit 419;
    BEGIN
      UpdateLayout(TRUE,FALSE); // Don't block on errors (return false) as we in all cases want to have an export file to edit.

      GetLayoutBlob(TempBlob);
      IF NOT TempBlob.Blob.HASVALUE THEN
        EXIT('');

      IF DefaultFileName = '' THEN
        DefaultFileName := '*.' + GetFileExtension;

      EXIT(FileMgt.BLOBExport(TempBlob,DefaultFileName,ShowFileDialog));
    END;

    [Internal]
    PROCEDURE ValidateLayout@14(useConfirm@1002 : Boolean;UpdateContext@1003 : Boolean) : Boolean;
    VAR
      TempBlob@1005 : Record 99008535;
      DocumentReportMgt@1001 : Codeunit 9651;
      DocumentInStream@1000 : InStream;
      ValidationErrorFormat@1004 : Text;
    BEGIN
      TESTFIELD("Report ID");
      GetLayoutBlob(TempBlob);
      IF NOT TempBlob.Blob.HASVALUE THEN
        EXIT;

      TempBlob.Blob.CREATEINSTREAM(DocumentInStream);

      CASE Type OF
        Type::Word:
          EXIT(DocumentReportMgt.ValidateWordLayout("Report ID",DocumentInStream,useConfirm,UpdateContext));
        Type::RDLC:
          IF NOT TryValidateRdlcReport(DocumentInStream) THEN BEGIN
            IF useConfirm THEN BEGIN
              IF NOT CONFIRM(TemplateValidationQst,FALSE,GETLASTERRORTEXT) THEN
                ERROR(AbortWithValidationErr);
            END ELSE BEGIN
              ValidationErrorFormat := TemplateValidationErr;
              ERROR(ValidationErrorFormat,GETLASTERRORTEXT);
            END;
            EXIT(FALSE);
          END;
      END;

      EXIT(TRUE);
    END;

    [Internal]
    PROCEDURE UpdateLayout@22(ContinueOnError@1007 : Boolean;IgnoreDelete@1000 : Boolean) : Boolean;
    VAR
      ErrorMessage@1008 : Text;
    BEGIN
      ErrorMessage := TryUpdateLayout(IgnoreDelete);

      IF ErrorMessage = '' THEN BEGIN
        IF Type = Type::Word THEN
          EXIT(ValidateLayout(TRUE,TRUE));
        EXIT(TRUE); // We have no validate for RDLC
      END;

      ErrorMessage := STRSUBSTNO(ErrorInLayoutErr,Description,"Report ID",ErrorMessage);
      IF ContinueOnError THEN BEGIN
        MESSAGE(ErrorMessage);
        EXIT(TRUE);
      END;

      ERROR(ErrorMessage);
    END;

    [Internal]
    PROCEDURE TryUpdateLayout@16(IgnoreDelete@1006 : Boolean) : Text;
    VAR
      InTempBlob@1003 : Record 99008535;
      OutTempBlob@1005 : Record 99008535;
      DocumentReportMgt@1004 : Codeunit 9651;
      DocumentInStream@1000 : InStream;
      DocumentOutStream@1001 : OutStream;
      WordXmlPart@1002 : Text;
      ErrorMessage@1007 : Text;
    BEGIN
      GetLayoutBlob(InTempBlob);
      IF NOT InTempBlob.Blob.HASVALUE THEN
        EXIT('');

      TestCustomXmlPart;
      TESTFIELD("Report ID");

      WordXmlPart := GetWordXmlPart("Report ID");
      InTempBlob.Blob.CREATEINSTREAM(DocumentInStream);

      CASE Type OF
        Type::Word:
          BEGIN
            OutTempBlob.Blob.CREATEOUTSTREAM(DocumentOutStream);
            ErrorMessage := DocumentReportMgt.TryUpdateWordLayout(DocumentInStream,DocumentOutStream,GetCustomXmlPart,WordXmlPart);
          END;
        Type::RDLC:
          BEGIN
            OutTempBlob.Blob.CREATEOUTSTREAM(DocumentOutStream,TEXTENCODING::UTF8);
            ErrorMessage := DocumentReportMgt.TryUpdateRdlcLayout(
                "Report ID",DocumentInStream,DocumentOutStream,GetCustomXmlPart,WordXmlPart,IgnoreDelete);
          END;
      END;

      SetCustomXmlPart(WordXmlPart);

      IF OutTempBlob.Blob.HASVALUE THEN
        SetLayoutBlob(OutTempBlob);

      EXIT(ErrorMessage);
    END;

    LOCAL PROCEDURE GetWordXML@8(VAR TempBlob@1001 : Record 99008535);
    VAR
      OutStr@1000 : OutStream;
    BEGIN
      TESTFIELD("Report ID");
      TempBlob.Blob.CREATEOUTSTREAM(OutStr,TEXTENCODING::UTF16);
      OutStr.WRITETEXT(REPORT.WORDXMLPART("Report ID"));
    END;

    [Internal]
    PROCEDURE ExportSchema@9(DefaultFileName@1003 : Text;ShowFileDialog@1002 : Boolean) : Text;
    VAR
      TempBlob@1001 : Record 99008535;
      FileMgt@1000 : Codeunit 419;
    BEGIN
      TESTFIELD(Type,Type::Word);

      IF DefaultFileName = '' THEN
        DefaultFileName := '*.xml';

      GetWordXML(TempBlob);
      IF TempBlob.Blob.HASVALUE THEN
        EXIT(FileMgt.BLOBExport(TempBlob,DefaultFileName,ShowFileDialog));
    END;

    [Internal]
    PROCEDURE EditLayout@4();
    BEGIN
      IF CanBeModified THEN BEGIN
        UpdateLayout(TRUE,TRUE); // Don't block on errors (return false) as we in all cases want to have an export file to edit.

        CASE Type OF
          Type::Word:
            CODEUNIT.RUN(CODEUNIT::"Edit MS Word Report Layout",Rec);
          Type::RDLC:
            CODEUNIT.RUN(CODEUNIT::"Edit RDLC Report Layout",Rec);
        END;
      END;
    END;

    LOCAL PROCEDURE GetFileExtension@12() : Text[4];
    BEGIN
      CASE Type OF
        Type::Word:
          EXIT('docx');
        Type::RDLC:
          EXIT('rdl');
      END;
    END;

    [Internal]
    PROCEDURE GetWordXmlPart@18(ReportID@1000 : Integer) : Text;
    VAR
      WordXmlPart@1001 : Text;
    BEGIN
      // Store the current design as an extended WordXmlPart. This data is used for later updates / refactorings.
      WordXmlPart := REPORT.WORDXMLPART(ReportID,TRUE);
      EXIT(WordXmlPart);
    END;

    [External]
    PROCEDURE RunCustomReport@3();
    VAR
      ReportLayoutSelection@1000 : Record 9651;
    BEGIN
      IF "Report ID" = 0 THEN
        EXIT;

      ReportLayoutSelection.SetTempLayoutSelected(Code);
      REPORT.RUNMODAL("Report ID");
      ReportLayoutSelection.SetTempLayoutSelected('');
    END;

    [Internal]
    PROCEDURE ApplyUpgrade@5(VAR ReportUpgrade@1007 : DotNet "'Microsoft.Dynamics.Nav.DocumentReport, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.DocumentReport.ReportUpgradeSet";VAR ReportChangeLogCollection@1001 : DotNet "'Microsoft.Dynamics.Nav.Types.Report, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Types.Report.IReportChangeLogCollection";testOnly@1000 : Boolean);
    VAR
      InTempBlob@1005 : Record 99008535;
      OutTempBlob@1010 : Record 99008535;
      TempReportChangeLogCollection@1008 : DotNet "'Microsoft.Dynamics.Nav.Types.Report, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Types.Report.IReportChangeLogCollection";
      DataInStream@1004 : InStream;
      DataOutStream@1003 : OutStream;
      ModifyLayout@1002 : Boolean;
    BEGIN
      GetLayoutBlob(InTempBlob);
      IF NOT InTempBlob.Blob.HASVALUE THEN
        EXIT;

      IF ReportUpgrade.ChangeCount < 1 THEN
        EXIT;

      CLEAR(DataInStream);
      CLEAR(DataOutStream);

      IF Type = Type::Word THEN BEGIN
        InTempBlob.Blob.CREATEINSTREAM(DataInStream);
        OutTempBlob.Blob.CREATEOUTSTREAM(DataOutStream);
      END ELSE BEGIN
        InTempBlob.Blob.CREATEINSTREAM(DataInStream,TEXTENCODING::UTF8);
        OutTempBlob.Blob.CREATEOUTSTREAM(DataOutStream,TEXTENCODING::UTF8);
      END;

      TempReportChangeLogCollection := ReportUpgrade.Upgrade(Description,DataInStream,DataOutStream);

      IF NOT testOnly THEN BEGIN
        IF TempReportChangeLogCollection.Failures = 0 THEN BEGIN
          SetDefaultCustomXmlPart;
          ModifyLayout := TRUE;
        END;
        IF OutTempBlob.Blob.HASVALUE THEN BEGIN
          SetLayoutBlob(OutTempBlob);
          ModifyLayout := TRUE;
        END;
        IF ModifyLayout THEN
          COMMIT;
      END;

      IF TempReportChangeLogCollection.Count > 0 THEN BEGIN
        IF ISNULL(ReportChangeLogCollection) THEN
          ReportChangeLogCollection := TempReportChangeLogCollection
        ELSE
          ReportChangeLogCollection.AddRange(TempReportChangeLogCollection);
      END;
    END;

    [TryFunction]
    LOCAL PROCEDURE TryValidateRdlcReport@15(VAR InStr@1002 : InStream);
    VAR
      RdlcReportManager@1001 : DotNet "'Microsoft.Dynamics.Nav.DocumentReport, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.DocumentReport.RdlcReportManager";
      RdlcString@1000 : Text;
    BEGIN
      InStr.READ(RdlcString);
      RdlcReportManager.ValidateReport("Report ID",RdlcString);
    END;

    LOCAL PROCEDURE FilterOnReport@20(ReportID@1000 : Integer);
    BEGIN
      RESET;
      SETCURRENTKEY("Report ID","Company Name",Type);
      SETFILTER("Company Name",'%1|%2','',STRSUBSTNO('@%1',COMPANYNAME));
      SETRANGE("Report ID",ReportID);
    END;

    [External]
    PROCEDURE LookupLayoutOK@21(ReportID@1000 : Integer) : Boolean;
    BEGIN
      FilterOnReport(ReportID);
      EXIT(PAGE.RUNMODAL(PAGE::"Custom Report Layouts",Rec) = ACTION::LookupOK);
    END;

    [External]
    PROCEDURE GetDefaultCode@23(ReportID@1002 : Integer) : Code[20];
    VAR
      CustomReportLayout@1000 : Record 9650;
      NewCode@1001 : Code[20];
    BEGIN
      CustomReportLayout.SETRANGE("Report ID",ReportID);
      CustomReportLayout.SETFILTER(Code,STRSUBSTNO('%1-*',ReportID));
      IF CustomReportLayout.FINDLAST THEN
        NewCode := INCSTR(CustomReportLayout.Code)
      ELSE
        NewCode := STRSUBSTNO('%1-000001',ReportID);

      EXIT(NewCode);
    END;

    [Internal]
    PROCEDURE CanBeModified@24() : Boolean;
    BEGIN
      IF NOT "Built-In" THEN
        EXIT(TRUE);

      IF NOT CONFIRM(ModifyBuiltInLayoutQst) THEN
        EXIT(FALSE);

      CopyRecord;
      EXIT(TRUE);
    END;

    [Internal]
    PROCEDURE NewExtensionLayout@26(ExtensionAppId@1000 : GUID;LayoutDataTable@1003 : DotNet "'System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Data.DataTable");
    VAR
      Row@1006 : DotNet "'System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Data.DataRow";
      Version@1002 : Text;
    BEGIN
      Row := LayoutDataTable.Rows.Item(0);
      IF LayoutDataTable.Columns.Contains('NavApplicationVersion') THEN
        Version := Row.Item('NavApplicationVersion');

      CASE Version OF
        ELSE
          HandleW10Layout(ExtensionAppId,Row,LayoutDataTable);
      END;
    END;

    LOCAL PROCEDURE HandleW10Layout@25(ExtensionAppId@1005 : GUID;Row@1003 : DotNet "'System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Data.DataRow";LayoutDataTable@1004 : DotNet "'System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Data.DataTable");
    VAR
      CustomReportLayout@1002 : Record 9650;
      LayoutCode@1000 : Code[20];
    BEGIN
      IF NOT LayoutDataTable.Columns.Contains('Code') THEN BEGIN
        LayoutCode := 'MS-EXT-0000000001';
        CustomReportLayout.SETFILTER(Code,'MS-EXT-*');
        IF CustomReportLayout.FINDLAST THEN
          LayoutCode := INCSTR(CustomReportLayout.Code);
      END ELSE
        LayoutCode := Row.Item('Code');

      CustomReportLayout.RESET;
      CustomReportLayout.INIT;
      CustomReportLayout.Code := LayoutCode;
      CustomReportLayout."App ID" := ExtensionAppId;
      CustomReportLayout.Type := Row.Item('Type');
      CustomReportLayout."Custom XML Part" := Row.Item('CustomXMLPart');
      CustomReportLayout.Description := Row.Item('Description');
      CustomReportLayout.Layout := Row.Item('Layout');
      CustomReportLayout."Report ID" := Row.Item('ReportID');
      CustomReportLayout.CALCFIELDS("Report Name");
      CustomReportLayout."Built-In" := TRUE;
      CustomReportLayout.INSERT;
    END;

    [External]
    PROCEDURE HasLayout@29() : Boolean;
    BEGIN
      IF "Built-In" THEN
        EXIT(HasBuiltInLayout);
      EXIT(HasNonBuiltInLayout);
    END;

    [External]
    PROCEDURE HasCustomXmlPart@47() : Boolean;
    BEGIN
      IF "Built-In" THEN
        EXIT(HasBuiltInCustomXmlPart);
      EXIT(HasNonBuiltInCustomXmlPart);
    END;

    [External]
    PROCEDURE GetLayout@30() : Text;
    BEGIN
      IF "Built-In" THEN
        EXIT(GetBuiltInLayout);
      EXIT(GetNonBuiltInLayout);
    END;

    [External]
    PROCEDURE GetCustomXmlPart@46() : Text;
    BEGIN
      IF "Built-In" THEN
        EXIT(GetBuiltInCustomXmlPart);
      EXIT(GetNonBuiltInCustomXmlPart);
    END;

    [External]
    PROCEDURE GetLayoutBlob@105(VAR TempBlob@1000 : Record 99008535);
    VAR
      ReportLayout@1001 : Record 2000000082;
    BEGIN
      TempBlob.INIT;
      IF NOT "Built-In" THEN BEGIN
        CALCFIELDS(Layout);
        TempBlob.Blob := Layout;
      END ELSE BEGIN
        ReportLayout.GET(Code);
        ReportLayout.CALCFIELDS(Layout);
        TempBlob.Blob := ReportLayout.Layout;
      END;
    END;

    [External]
    PROCEDURE ClearLayout@57();
    BEGIN
      IF "Built-In" THEN
        ERROR(ModifyBuiltInLayoutErr);
      SetNonBuiltInLayout('');
    END;

    [External]
    PROCEDURE ClearCustomXmlPart@63();
    BEGIN
      IF "Built-In" THEN
        ERROR(ModifyBuiltInLayoutErr);
      SetNonBuiltInCustomXmlPart('');
    END;

    [External]
    PROCEDURE TestLayout@115();
    VAR
      ReportLayout@1000 : Record 2000000082;
    BEGIN
      IF NOT "Built-In" THEN BEGIN
        CALCFIELDS(Layout);
        TESTFIELD(Layout);
        EXIT;
      END;
      ReportLayout.GET(Code);
      ReportLayout.CALCFIELDS(Layout);
      ReportLayout.TESTFIELD(Layout);
    END;

    [External]
    PROCEDURE TestCustomXmlPart@117();
    VAR
      ReportLayout@1000 : Record 2000000082;
    BEGIN
      IF NOT "Built-In" THEN BEGIN
        CALCFIELDS("Custom XML Part");
        TESTFIELD("Custom XML Part");
        EXIT;
      END;
      ReportLayout.GET(Code);
      ReportLayout.CALCFIELDS("Custom XML Part");
      ReportLayout.TESTFIELD("Custom XML Part");
    END;

    [External]
    PROCEDURE SetLayout@19(Content@1000 : Text);
    BEGIN
      IF "Built-In" THEN
        ERROR(ModifyBuiltInLayoutErr);
      SetNonBuiltInLayout(Content);
    END;

    [External]
    PROCEDURE SetCustomXmlPart@45(Content@1000 : Text);
    BEGIN
      IF "Built-In" THEN
        ERROR(ModifyBuiltInLayoutErr);
      SetNonBuiltInCustomXmlPart(Content);
    END;

    [External]
    PROCEDURE SetDefaultCustomXmlPart@60();
    BEGIN
      SetCustomXmlPart(GetWordXmlPart("Report ID"));
    END;

    [External]
    PROCEDURE SetLayoutBlob@39(VAR TempBlob@1000 : Record 99008535);
    BEGIN
      IF "Built-In" THEN
        ERROR(ModifyBuiltInLayoutErr);
      CLEAR(Layout);
      IF TempBlob.Blob.HASVALUE THEN
        Layout := TempBlob.Blob;
      MODIFY;
    END;

    LOCAL PROCEDURE HasNonBuiltInLayout@35() : Boolean;
    BEGIN
      CALCFIELDS(Layout);
      EXIT(Layout.HASVALUE);
    END;

    LOCAL PROCEDURE HasNonBuiltInCustomXmlPart@53() : Boolean;
    BEGIN
      CALCFIELDS("Custom XML Part");
      EXIT("Custom XML Part".HASVALUE);
    END;

    LOCAL PROCEDURE HasBuiltInLayout@32() : Boolean;
    VAR
      ReportLayout@1000 : Record 2000000082;
    BEGIN
      IF NOT ReportLayout.GET(Code) THEN
        EXIT(FALSE);

      ReportLayout.CALCFIELDS(Layout);
      EXIT(ReportLayout.Layout.HASVALUE);
    END;

    LOCAL PROCEDURE HasBuiltInCustomXmlPart@50() : Boolean;
    VAR
      ReportLayout@1000 : Record 2000000082;
    BEGIN
      IF NOT ReportLayout.GET(Code) THEN
        EXIT(FALSE);

      ReportLayout.CALCFIELDS("Custom XML Part");
      EXIT(ReportLayout."Custom XML Part".HASVALUE);
    END;

    LOCAL PROCEDURE GetNonBuiltInLayout@34() : Text;
    VAR
      InStr@1002 : InStream;
      Content@1001 : Text;
    BEGIN
      CALCFIELDS(Layout);
      IF NOT Layout.HASVALUE THEN
        EXIT('');

      IF Type = Type::RDLC THEN
        Layout.CREATEINSTREAM(InStr,TEXTENCODING::UTF8)
      ELSE
        Layout.CREATEINSTREAM(InStr);

      InStr.READ(Content);
      EXIT(Content);
    END;

    LOCAL PROCEDURE GetNonBuiltInCustomXmlPart@52() : Text;
    VAR
      InStr@1002 : InStream;
      Content@1001 : Text;
    BEGIN
      CALCFIELDS("Custom XML Part");
      IF NOT "Custom XML Part".HASVALUE THEN
        EXIT('');

      "Custom XML Part".CREATEINSTREAM(InStr,TEXTENCODING::UTF16);
      InStr.READ(Content);
      EXIT(Content);
    END;

    LOCAL PROCEDURE GetBuiltInLayout@80() : Text;
    VAR
      ReportLayout@1000 : Record 2000000082;
      InStr@1002 : InStream;
      Content@1001 : Text;
    BEGIN
      IF NOT ReportLayout.GET(Code) THEN
        EXIT('');

      ReportLayout.CALCFIELDS(Layout);
      IF NOT ReportLayout.Layout.HASVALUE THEN
        EXIT('');

      IF Type = Type::RDLC THEN
        ReportLayout.Layout.CREATEINSTREAM(InStr,TEXTENCODING::UTF8)
      ELSE
        ReportLayout.Layout.CREATEINSTREAM(InStr);

      InStr.READ(Content);
      EXIT(Content);
    END;

    LOCAL PROCEDURE GetBuiltInCustomXmlPart@49() : Text;
    VAR
      ReportLayout@1000 : Record 2000000082;
      InStr@1002 : InStream;
      Content@1001 : Text;
    BEGIN
      IF NOT ReportLayout.GET(Code) THEN
        EXIT('');

      ReportLayout.CALCFIELDS("Custom XML Part");
      IF NOT ReportLayout."Custom XML Part".HASVALUE THEN
        EXIT('');

      ReportLayout."Custom XML Part".CREATEINSTREAM(InStr,TEXTENCODING::UTF16);
      InStr.READ(Content);
      EXIT(Content);
    END;

    LOCAL PROCEDURE SetNonBuiltInLayout@33(Content@1001 : Text);
    VAR
      OutStr@1002 : OutStream;
    BEGIN
      CLEAR(Layout);
      IF Content <> '' THEN BEGIN
        IF Type = Type::RDLC THEN
          Layout.CREATEOUTSTREAM(OutStr,TEXTENCODING::UTF8)
        ELSE
          Layout.CREATEOUTSTREAM(OutStr);
        OutStr.WRITE(Content);
      END;
      MODIFY;
    END;

    LOCAL PROCEDURE SetNonBuiltInCustomXmlPart@51(Content@1001 : Text);
    VAR
      OutStr@1002 : OutStream;
    BEGIN
      CLEAR("Custom XML Part");
      IF Content <> '' THEN BEGIN
        "Custom XML Part".CREATEOUTSTREAM(OutStr,TEXTENCODING::UTF16);
        OutStr.WRITE(Content);
      END;
      MODIFY;
    END;

    BEGIN
    END.
  }
}

