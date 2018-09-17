OBJECT Codeunit 9651 Document Report Mgt.
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      NotImplementedErr@1002 : TextConst 'DAN=Denne indstilling er ikke tilg�ngelig.;ENU=This option is not available.';
      TemplateValidationQst@1000 : TextConst 'DAN=Word-layoutet stemmer ikke overens med det aktuelle rapportdesign (felter mangler f.eks., eller rapport-id''et er forkert).\F�lgende fejl er registreret under layoutvalideringen:\%1\Vil du forts�tte?;ENU=The Word layout does not comply with the current report design (for example, fields are missing or the report ID is wrong).\The following errors were detected during the layout validation:\%1\Do you want to continue?';
      TemplateValidationErr@1003 : TextConst 'DAN=Word-layoutet stemmer ikke overens med det aktuelle rapportdesign (felter mangler f.eks., eller rapport-id''et er forkert).\F�lgende fejl er registreret under dokumentvalideringen:\%1\Du skal opdatere layoutet, s� det stemmer overens med det aktuelle rapportdesign.;ENU=The Word layout does not comply with the current report design (for example, fields are missing or the report ID is wrong).\The following errors were detected during the document validation:\%1\You must update the layout to match the current report design.';
      AbortWithValidationErr@1001 : TextConst 'DAN=Word-layouthandlingen er annulleret p� grund af valideringsfejl.;ENU=The Word layout action has been canceled because of validation errors.';
      TemplateValidationUpdateQst@1004 : TextConst 'DAN=Word-layoutet stemmer ikke overens med det aktuelle rapportdesign (felter mangler f.eks., eller rapport-id''et er forkert).\F�lgende fejl er registreret under layoutvalideringen:\%1\Vil du k�re en automatisk opdatering?;ENU=The Word layout does not comply with the current report design (for example, fields are missing or the report ID is wrong).\The following errors were detected during the layout validation:\%1\Do you want to run an automatic update?';
      TemplateAfterUpdateValidationErr@1006 : TextConst 'DAN=Den automatiske opdatering kan ikke l�se alle konflikter i det aktuelle Word-layout. Layoutet bruger f.eks. felter, der mangler i rapportdesignet, eller rapport-id''et er forkert).\F�lgende fejl er registreret under dokumentvalideringen:\%1\Du skal opdatere layoutet manuelt, s� det stemmer overens med det aktuelle rapportdesign.;ENU=The automatic update could not resolve all the conflicts in the current Word layout. For example, the layout uses fields that are missing in the report design or the report ID is wrong.\The following errors were detected:\%1\You must manually update the layout to match the current report design.';
      UpgradeMessageMsg@1005 : TextConst 'DAN=Rapportopgraderingsprocessen returnerede f�lgende logmeddelelser:\%1.;ENU=The report upgrade process returned the following log messages:\%1.';
      NoReportLayoutUpgradeRequiredMsg@1007 : TextConst 'DAN=Layoutopgraderingsprocessen blev fuldf�rt, uden at der blev registreret n�dvendige �ndringer i det aktuelle program.;ENU=The layout upgrade process completed without detecting any required changes in the current application.';
      CompanyInformationPicErr@1011 : TextConst 'DAN=Dokumentet indeholder elementer, der ikke kan konverteres til PDF. Dette kan skyldes manglende billeddata i dokumentet.;ENU=The document contains elements that cannot be converted to PDF. This may be caused by missing image data in the document.';
      FileTypeWordTxt@1008 : TextConst '@@@={Locked};DAN=docx;ENU=docx';
      FileTypePdfTxt@1009 : TextConst '@@@={Locked};DAN=pdf;ENU=pdf';
      FileTypeHtmlTxt@1010 : TextConst '@@@={Locked};DAN=html;ENU=html';
      NoOutputErr@1014 : TextConst 'DAN=Der findes ingen data for de angivne rapportfiltre.;ENU=No data exists for the specified report filters.';
      ClientTypeManagement@1012 : Codeunit 4;

    [Internal]
    PROCEDURE MergeWordLayout@5(ReportID@1000 : Integer;ReportAction@1007 : 'SaveAsPdf,SaveAsWord,SaveAsExcel,Preview,Print,SaveAsHtml';InStrXmlData@1002 : InStream;FileName@1001 : Text);
    VAR
      ReportLayoutSelection@1011 : Record 9651;
      CustomReportLayout@1003 : Record 9650;
      InTempBlob@1010 : Record 99008535;
      OutTempBlob@1009 : Record 99008535;
      FileMgt@1008 : Codeunit 419;
      InStrWordDoc@1006 : InStream;
      OutStrWordDoc@1005 : OutStream;
      NAVWordXMLMerger@1004 : DotNet "'Microsoft.Dynamics.Nav.DocumentReport, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.DocumentReport.WordReportManager";
      CustomLayoutCode@1012 : Code[20];
      CurrentFileType@1013 : Text;
      VerifyXmlHasData@1014 : Boolean;
    BEGIN
      // FileName contains printername for ReportAction::Print.
      // Temporarily selected layout for Design-time report execution?
      IF ReportLayoutSelection.GetTempLayoutSelected <> '' THEN
        CustomLayoutCode := ReportLayoutSelection.GetTempLayoutSelected
      ELSE  // Normal selection
        IF ReportLayoutSelection.GET(ReportID,COMPANYNAME) AND
           (ReportLayoutSelection.Type = ReportLayoutSelection.Type::"Custom Layout")
        THEN
          CustomLayoutCode := ReportLayoutSelection."Custom Report Layout Code";

      IF CustomLayoutCode <> '' THEN
        IF NOT CustomReportLayout.GET(CustomLayoutCode) THEN
          CustomLayoutCode := '';

      IF CustomLayoutCode = '' THEN
        REPORT.WORDLAYOUT(ReportID,InStrWordDoc)
      ELSE BEGIN
        ValidateAndUpdateWordLayoutOnRecord(CustomReportLayout);
        CustomReportLayout.GetLayoutBlob(InTempBlob);
        InTempBlob.Blob.CREATEINSTREAM(InStrWordDoc);
        ValidateWordLayoutCheckOnly(ReportID,InStrWordDoc);
      END;
      OutTempBlob.Blob.CREATEOUTSTREAM(OutStrWordDoc);

      // By default - throw an error in case of empty dataset
      VerifyXmlHasData := TRUE;
      OnBeforeMergeWordDocument(VerifyXmlHasData);
      IF VerifyXmlHasData THEN
        VerifyXmlContainsDataset(InStrXmlData);

      OutStrWordDoc := NAVWordXMLMerger.MergeWordDocument(InStrWordDoc,InStrXmlData,OutStrWordDoc) ;
      COMMIT;

      CurrentFileType := '';
      CASE ReportAction OF
        ReportAction::SaveAsWord:
          CurrentFileType := FileTypeWordTxt;
        ReportAction::SaveAsPdf:
          BEGIN
            CurrentFileType := FileTypePdfTxt;
            ConvertToPdf(OutTempBlob);
          END;
        ReportAction::SaveAsHtml:
          BEGIN
            CurrentFileType := FileTypeHtmlTxt;
            ConvertToHtml(OutTempBlob);
          END;
        ReportAction::SaveAsExcel:
          ERROR(NotImplementedErr);
        ReportAction::Print:
          PrintWordDoc(ReportID,OutTempBlob,FileName,TRUE);
        ReportAction::Preview:
          FileMgt.BLOBExport(OutTempBlob,UserFileName(ReportID,CurrentFileType),TRUE);
      END;

      // Export the file to the client of the action generates an output object in which case currentFileType is non-empty.
      IF CurrentFileType <> '' THEN
        IF FileName = '' THEN
          FileMgt.BLOBExport(OutTempBlob,UserFileName(ReportID,CurrentFileType),TRUE)
        ELSE
          // Dont' use FileMgt.BLOBExportToServerFile. It will fail if run through
          // CodeUnit 8800, as the filename will exist in a temp folder.
          OutTempBlob.Blob.EXPORT(FileName);
    END;

    [External]
    PROCEDURE ValidateWordLayout@2(ReportID@1001 : Integer;DocumentStream@1000 : InStream;useConfirm@1004 : Boolean;updateContext@1005 : Boolean) : Boolean;
    VAR
      NAVWordXMLMerger@1002 : DotNet "'Microsoft.Dynamics.Nav.DocumentReport, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.DocumentReport.WordReportManager";
      ValidationErrors@1003 : Text;
      ValidationErrorFormat@1006 : Text;
    BEGIN
      ValidationErrors := NAVWordXMLMerger.ValidateWordDocumentTemplate(DocumentStream,REPORT.WORDXMLPART(ReportID,TRUE));
      IF ValidationErrors <> '' THEN BEGIN
        IF useConfirm THEN BEGIN
          IF NOT CONFIRM(TemplateValidationQst,FALSE,ValidationErrors) THEN
            ERROR(AbortWithValidationErr);
        END ELSE BEGIN
          IF updateContext THEN
            ValidationErrorFormat := TemplateAfterUpdateValidationErr
          ELSE
            ValidationErrorFormat := TemplateValidationErr;

          ERROR(ValidationErrorFormat,ValidationErrors);
        END;

        EXIT(FALSE);
      END;
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE ValidateWordLayoutCheckOnly@4(ReportID@1001 : Integer;DocumentStream@1000 : InStream);
    VAR
      NAVWordXMLMerger@1002 : DotNet "'Microsoft.Dynamics.Nav.DocumentReport, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.DocumentReport.WordReportManager";
      ValidationErrors@1003 : Text;
      ValidationErrorFormat@1006 : Text;
    BEGIN
      ValidationErrors := NAVWordXMLMerger.ValidateWordDocumentTemplate(DocumentStream,REPORT.WORDXMLPART(ReportID,TRUE));
      IF ValidationErrors <> '' THEN BEGIN
        ValidationErrorFormat := TemplateAfterUpdateValidationErr;
        MESSAGE(ValidationErrorFormat,ValidationErrors);
      END;
    END;

    LOCAL PROCEDURE ValidateAndUpdateWordLayoutOnRecord@7(CustomReportLayout@1001 : Record 9650) : Boolean;
    VAR
      TempBlob@1000 : Record 99008535;
      NAVWordXMLMerger@1002 : DotNet "'Microsoft.Dynamics.Nav.DocumentReport, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.DocumentReport.WordReportManager";
      DocumentStream@1005 : InStream;
      ValidationErrors@1003 : Text;
    BEGIN
      CustomReportLayout.TESTFIELD(Type,CustomReportLayout.Type::Word);
      CustomReportLayout.GetLayoutBlob(TempBlob);
      TempBlob.Blob.CREATEINSTREAM(DocumentStream);
      NAVWordXMLMerger := NAVWordXMLMerger.WordReportManager;

      ValidationErrors :=
        NAVWordXMLMerger.ValidateWordDocumentTemplate(DocumentStream,REPORT.WORDXMLPART(CustomReportLayout."Report ID",TRUE));
      IF ValidationErrors <> '' THEN BEGIN
        IF CONFIRM(TemplateValidationUpdateQst,FALSE,ValidationErrors) THEN BEGIN
          ValidationErrors := CustomReportLayout.TryUpdateLayout(FALSE);
          COMMIT;
          EXIT(TRUE);
        END;
        ERROR(TemplateValidationErr,ValidationErrors);
      END;
      EXIT(FALSE);
    END;

    [External]
    PROCEDURE TryUpdateWordLayout@12(DocumentStream@1001 : InStream;VAR UpdateStream@1002 : OutStream;CachedCustomPart@1003 : Text;CurrentCustomPart@1004 : Text) : Text;
    VAR
      NAVWordXMLMerger@1007 : DotNet "'Microsoft.Dynamics.Nav.DocumentReport, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.DocumentReport.WordReportManager";
    BEGIN
      NAVWordXMLMerger := NAVWordXMLMerger.WordReportManager;
      NAVWordXMLMerger.UpdateWordDocumentLayout(DocumentStream,UpdateStream,CachedCustomPart,CurrentCustomPart,TRUE);
      EXIT(NAVWordXMLMerger.LastUpdateError);
    END;

    [External]
    PROCEDURE TryUpdateRdlcLayout@13(reportId@1001 : Integer;RdlcStream@1002 : InStream;RdlcUpdatedStream@1000 : OutStream;CachedCustomPart@1003 : Text;CurrentCustomPart@1004 : Text;IgnoreDelete@1005 : Boolean) : Text;
    VAR
      NAVWordXMLMerger@1007 : DotNet "'Microsoft.Dynamics.Nav.DocumentReport, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.DocumentReport.RdlcReportManager";
    BEGIN
      EXIT(NAVWordXMLMerger.TryUpdateRdlcLayout(reportId,RdlcStream,RdlcUpdatedStream,
          CachedCustomPart,CurrentCustomPart,IgnoreDelete));
    END;

    [External]
    PROCEDURE NewWordLayout@11(ReportId@1000 : Integer;VAR DocumentStream@1001 : OutStream);
    VAR
      NAVWordXmlMerger@1002 : DotNet "'Microsoft.Dynamics.Nav.DocumentReport, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.DocumentReport.WordReportManager";
    BEGIN
      NAVWordXmlMerger.NewWordDocumentLayout(DocumentStream,REPORT.WORDXMLPART(ReportId));
    END;

    LOCAL PROCEDURE ConvertToPdf@1(VAR TempBlob@1015 : Record 99008535);
    VAR
      TempBlobPdf@1006 : Record 99008535;
      InStreamWordDoc@1007 : InStream;
      OutStreamPdfDoc@1008 : OutStream;
    BEGIN
      TempBlob.Blob.CREATEINSTREAM(InStreamWordDoc);
      TempBlobPdf.Blob.CREATEOUTSTREAM(OutStreamPdfDoc);

      IF TryConvertToPdf(InStreamWordDoc,OutStreamPdfDoc) THEN
        TempBlob.Blob := TempBlobPdf.Blob
      ELSE
        ERROR(CompanyInformationPicErr);
    END;

    [TryFunction]
    LOCAL PROCEDURE TryConvertToPdf@23(InStreamWordDoc@1001 : InStream;OutStreamPdfDoc@1000 : OutStream);
    VAR
      PdfWriter@1002 : DotNet "'Microsoft.Dynamics.Nav.PdfWriter, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.PdfWriter.WordToPdf";
    BEGIN
      PdfWriter.ConvertToPdf(InStreamWordDoc,OutStreamPdfDoc);
    END;

    LOCAL PROCEDURE ConvertToHtml@22(VAR TempBlob@1015 : Record 99008535);
    VAR
      TempBlobHtml@1006 : Record 99008535;
      InStreamWordDoc@1007 : InStream;
      OutStreamHtmlDoc@1008 : OutStream;
      PdfWriter@1002 : DotNet "'Microsoft.Dynamics.Nav.PdfWriter, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.PdfWriter.WordToPdf";
    BEGIN
      TempBlob.Blob.CREATEINSTREAM(InStreamWordDoc);
      TempBlobHtml.Blob.CREATEOUTSTREAM(OutStreamHtmlDoc);
      PdfWriter.ConvertToHtml(InStreamWordDoc,OutStreamHtmlDoc);
      TempBlob.Blob := TempBlobHtml.Blob;
    END;

    LOCAL PROCEDURE PrintWordDoc@15(ReportID@1003 : Integer;VAR TempBlob@1015 : Record 99008535;PrinterName@1000 : Text;Collate@1002 : Boolean);
    VAR
      FileMgt@1001 : Codeunit 419;
    BEGIN
      IF FileMgt.IsWindowsClient THEN
        PrintWordDocInWord(ReportID,TempBlob,PrinterName,Collate,1)
      ELSE
        IF FileMgt.IsWebOrDeviceClient THEN BEGIN
          ConvertToPdf(TempBlob);
          FileMgt.BLOBExport(TempBlob,UserFileName(ReportID,FileTypePdfTxt),TRUE);
        END ELSE
          PrintWordDocOnServer(TempBlob,PrinterName,Collate);
    END;

    LOCAL PROCEDURE PrintWordDocInWord@17(ReportID@1006 : Integer;TempBlob@1015 : Record 99008535;PrinterName@1004 : Text;Collate@1007 : Boolean;Copies@1008 : Integer);
    VAR
      FileMgt@1005 : Codeunit 419;
      WordApplication@1001 : DotNet "'Microsoft.Office.Interop.Word, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c'.Microsoft.Office.Interop.Word.ApplicationClass" RUNONCLIENT;
      WordDocument@1000 : DotNet "'Microsoft.Office.Interop.Word, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c'.Microsoft.Office.Interop.Word.Document" RUNONCLIENT;
      WordHelper@1016 : DotNet "'Microsoft.Dynamics.Nav.Integration.Office, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Integration.Office.Word.WordHelper" RUNONCLIENT;
      FileName@1003 : Text;
      T0@1002 : DateTime;
    BEGIN
      IF GetWordApplication(WordApplication) AND NOT ISNULL(WordApplication) THEN BEGIN
        FileName := STRSUBSTNO('%1.docx',CREATEGUID);
        FileName := FileMgt.BLOBExport(TempBlob,FileName,FALSE);

        IF PrinterName = '' THEN
          IF NOT SelectPrinter(PrinterName,Collate,Copies) THEN
            EXIT;

        WordDocument := WordHelper.CallOpen(WordApplication,FileName,FALSE,FALSE);
        WordHelper.CallPrintOut(WordDocument,PrinterName,Collate,Copies);

        T0 := CURRENTDATETIME;
        WHILE (WordApplication.BackgroundPrintingStatus > 0) AND (CURRENTDATETIME < T0 + 180000) DO
          SLEEP(250);
        WordHelper.CallQuit(WordApplication,FALSE);
        IF DeleteClientFile(FileName) THEN;
      END ELSE BEGIN
        IF (PrinterName <> '') AND IsValidPrinter(PrinterName) THEN
          PrintWordDocOnServer(TempBlob,PrinterName,Collate) // Don't print on server if the printer has not been setup.
        ELSE
          FileMgt.BLOBExport(TempBlob,UserFileName(ReportID,FileTypeWordTxt),TRUE);
      END;
    END;

    LOCAL PROCEDURE SelectPrinter@8(VAR PrinterName@1006 : Text;VAR Collate@1005 : Boolean;VAR Copies@1004 : Integer) : Boolean;
    VAR
      DotNetPrintDialog@1002 : DotNet "'System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Windows.Forms.PrintDialog" RUNONCLIENT;
      DotNetDialogResult@1001 : DotNet "'System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Windows.Forms.DialogResult" RUNONCLIENT;
      DotNetPrinterSettings@1000 : DotNet "'System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'.System.Drawing.Printing.PrinterSettings" RUNONCLIENT;
      PrintDialogResult@1003 : Integer;
    BEGIN
      DotNetPrinterSettings := DotNetPrinterSettings.PrinterSettings;
      DotNetPrintDialog := DotNetPrintDialog.PrintDialog;

      DotNetPrintDialog.ShowNetwork := TRUE;
      DotNetDialogResult := DotNetPrintDialog.ShowDialog;
      PrintDialogResult := DotNetDialogResult;

      // 1 - means OK
      // 6 - means YES
      IF NOT (PrintDialogResult IN [1,6]) THEN
        EXIT(FALSE);

      DotNetPrinterSettings := DotNetPrintDialog.PrinterSettings;
      PrinterName := DotNetPrinterSettings.PrinterName;
      Collate := DotNetPrinterSettings.Collate;
      Copies := DotNetPrinterSettings.Copies;

      EXIT(TRUE);
    END;

    [TryFunction]
    LOCAL PROCEDURE DeleteClientFile@20(FileName@1000 : Text);
    VAR
      FileMgt@1001 : Codeunit 419;
    BEGIN
      FileMgt.DeleteClientFile(FileName);
    END;

    LOCAL PROCEDURE IsValidPrinter@19(PrinterName@1000 : Text) : Boolean;
    VAR
      Printer@1001 : Record 2000000039;
    BEGIN
      Printer.SETFILTER(Name,PrinterName);
      Printer.FINDFIRST;
      EXIT(NOT Printer.ISEMPTY);
    END;

    [TryFunction]
    LOCAL PROCEDURE GetWordApplication@18(VAR WordApplication@1000 : DotNet "'Microsoft.Office.Interop.Word, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c'.Microsoft.Office.Interop.Word.ApplicationClass" RUNONCLIENT);
    BEGIN
      WordApplication := WordApplication.ApplicationClass;
    END;

    LOCAL PROCEDURE PrintWordDocOnServer@16(TempBlob@1001 : Record 99008535;PrinterName@1000 : Text;Collate@1004 : Boolean);
    VAR
      PdfWriter@1003 : DotNet "'Microsoft.Dynamics.Nav.PdfWriter, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.PdfWriter.WordToPdf";
      InStreamWordDoc@1002 : InStream;
    BEGIN
      TempBlob.Blob.CREATEINSTREAM(InStreamWordDoc);
      PdfWriter.PrintWordDoc(InStreamWordDoc,PrinterName,Collate);
    END;

    LOCAL PROCEDURE UserFileName@6(ReportID@1000 : Integer;fileExtension@1003 : Text) : Text;
    VAR
      ReportMetadata@1001 : Record 2000000139;
      FileManagement@1004 : Codeunit 419;
    BEGIN
      ReportMetadata.GET(ReportID);
      IF fileExtension = '' THEN
        fileExtension := FileTypeWordTxt;

      EXIT(FileManagement.GetSafeFileName(ReportMetadata.Caption) + '.' + fileExtension);
    END;

    [Internal]
    PROCEDURE ApplyUpgradeToReports@10(VAR ReportUpgradeCollection@1007 : DotNet "'Microsoft.Dynamics.Nav.DocumentReport, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.DocumentReport.ReportUpgradeCollection";testOnly@1000 : Boolean) : Boolean;
    VAR
      CustomReportLayout@1005 : Record 9650;
      ReportUpgrade@1006 : DotNet "'Microsoft.Dynamics.Nav.DocumentReport, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.DocumentReport.ReportUpgradeSet";
      ReportChangeLogCollection@1008 : DotNet "'Microsoft.Dynamics.Nav.Types.Report, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Types.Report.IReportChangeLogCollection";
    BEGIN
      FOREACH ReportUpgrade IN ReportUpgradeCollection DO BEGIN
        CustomReportLayout.SETFILTER("Report ID",FORMAT(ReportUpgrade.ReportId));
        IF CustomReportLayout.FIND('-') THEN
          REPEAT
            CustomReportLayout.ApplyUpgrade(ReportUpgrade,ReportChangeLogCollection,testOnly);
          UNTIL CustomReportLayout.NEXT = 0;
      END;

      IF ISNULL(ReportChangeLogCollection) THEN BEGIN // Don't break upgrade process with user information
        IF (ClientTypeManagement.GetCurrentClientType <> CLIENTTYPE::Background) AND
           (ClientTypeManagement.GetCurrentClientType <> CLIENTTYPE::Management)
        THEN
          MESSAGE(NoReportLayoutUpgradeRequiredMsg);

        EXIT(FALSE);
      END;

      ProcessUpgradeLog(ReportChangeLogCollection);
      EXIT(ReportChangeLogCollection.Count > 0);
    END;

    [External]
    PROCEDURE CalculateUpgradeChangeSet@21(VAR ReportUpgradeCollection@1002 : DotNet "'Microsoft.Dynamics.Nav.DocumentReport, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.DocumentReport.ReportUpgradeCollection");
    VAR
      CustomReportLayout@1000 : Record 9650;
      ReportUpgradeSet@1001 : DotNet "'Microsoft.Dynamics.Nav.Types.Report, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Types.Report.IReportUpgradeSet";
    BEGIN
      IF CustomReportLayout.FIND('-') THEN
        REPEAT
          ReportUpgradeSet := ReportUpgradeCollection.AddReport(CustomReportLayout."Report ID"); // runtime will load the current XmlPart from metadata
          IF NOT ISNULL(ReportUpgradeSet) THEN
            ReportUpgradeSet.CalculateAutoChangeSet(CustomReportLayout.GetCustomXmlPart);
        UNTIL CustomReportLayout.NEXT <> 1;
    END;

    LOCAL PROCEDURE ProcessUpgradeLog@9(VAR ReportChangeLogCollection@1000 : DotNet "'Microsoft.Dynamics.Nav.Types.Report, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Types.Report.IReportChangeLogCollection");
    VAR
      ReportLayoutUpdateLog@1001 : Codeunit 9656;
    BEGIN
      IF ISNULL(ReportChangeLogCollection) THEN
        EXIT;

      IF (ClientTypeManagement.GetCurrentClientType <> CLIENTTYPE::Background) AND
         (ClientTypeManagement.GetCurrentClientType <> CLIENTTYPE::Management)
      THEN
        ReportLayoutUpdateLog.ViewLog(ReportChangeLogCollection)
      ELSE
        MESSAGE(UpgradeMessageMsg,FORMAT(ReportChangeLogCollection));
    END;

    [Internal]
    PROCEDURE BulkUpgrade@14(testMode@1002 : Boolean);
    VAR
      ReportUpgradeCollection@1000 : DotNet "'Microsoft.Dynamics.Nav.DocumentReport, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.DocumentReport.ReportUpgradeCollection";
    BEGIN
      ReportUpgradeCollection := ReportUpgradeCollection.ReportUpgradeCollection;
      CalculateUpgradeChangeSet(ReportUpgradeCollection);
      ApplyUpgradeToReports(ReportUpgradeCollection,testMode);
    END;

    LOCAL PROCEDURE VerifyXmlContainsDataset@24(XmlData@1000 : InStream);
    VAR
      XMLDOMManagement@1008 : Codeunit 6224;
      XmlNode@1007 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
    BEGIN
      IF XMLDOMManagement.LoadXMLNodeFromInStream(XmlData,XmlNode) AND
         XMLDOMManagement.FindNode(XmlNode,'DataItems',XmlNode)
      THEN
        IF XmlNode.ChildNodes.Count = 0 THEN
          ERROR(NoOutputErr);
    END;

    [Integration]
    PROCEDURE OnBeforeMergeWordDocument@25(VAR VerifyXmlHasData@1000 : Boolean);
    BEGIN
    END;

    BEGIN
    END.
  }
}

