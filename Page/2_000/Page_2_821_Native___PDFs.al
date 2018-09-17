OBJECT Page 2821 Native - PDFs
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[@@@={Locked};
               DAN=nativeInvoicingPDFs;
               ENU=nativeInvoicingPDFs];
    SourceTable=Table5509;
    PageType=List;
    SourceTableTemporary=Yes;
    OnOpenPage=BEGIN
                 BINDSUBSCRIPTION(NativeAPILanguageHandler);
               END;

    OnFindRecord=VAR
                   DocumentId@1005 : GUID;
                   DocumentIdFilter@1001 : Text;
                   FilterView@1000 : Text;
                 BEGIN
                   IF NOT PdfGenerated THEN BEGIN
                     FilterView := GETVIEW;
                     DocumentIdFilter := GETFILTER("Document Id");
                     IF DocumentIdFilter = '' THEN
                       DocumentIdFilter := GETFILTER(Id);
                     SETVIEW(FilterView);
                     DocumentId := GetDocumentId(DocumentIdFilter);
                     IF ISNULLGUID(DocumentId) THEN
                       EXIT(FALSE);
                     GeneratePdf(DocumentId);
                   END;
                   EXIT(TRUE);
                 END;

    ODataKeyFields=Document Id;
  }
  CONTROLS
  {
    { 18  ;0   ;Container ;
                ContainerType=ContentArea }

    { 17  ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 1   ;2   ;Field     ;
                Name=documentId;
                CaptionML=[@@@={Locked};
                           DAN=documentId;
                           ENU=documentId];
                ApplicationArea=#All;
                SourceExpr="Document Id" }

    { 7   ;2   ;Field     ;
                Name=fileName;
                CaptionML=[@@@={Locked};
                           DAN=fileName;
                           ENU=fileName];
                ApplicationArea=#All;
                SourceExpr="File Name" }

    { 4   ;2   ;Field     ;
                Name=content;
                CaptionML=[@@@={Locked};
                           DAN=content;
                           ENU=content];
                ApplicationArea=#All;
                SourceExpr=Content }

  }
  CODE
  {
    VAR
      CannotFindDocumentErr@1006 : TextConst '@@@=%1 - Error Message;DAN=Bilag %1 blev ikke fundet.;ENU=The document %1 cannot be found.';
      CannotOpenFileErr@1005 : TextConst '@@@=%1 - Error Message;DAN=èbning af filen mislykkedes pÜ grund af fõlgende fejl: \%1.;ENU=Opening the file failed because of the following error: \%1.';
      DocumentIDNotSpecifiedForAttachmentsErr@1010 : TextConst 'DAN=Du skal angive et dokument-id for at hente PDF-filen.;ENU=You must specify a document ID to get the PDF.';
      DocumentDoesNotExistErr@1009 : TextConst 'DAN=Der findes intet dokument med det angivne id.;ENU=No document with the specified ID exists.';
      NativeAPILanguageHandler@1000 : Codeunit 2850;
      PdfGenerated@1002 : Boolean;

    LOCAL PROCEDURE GetDocumentId@5(DocumentIdFilter@1001 : Text) : GUID;
    VAR
      SalesHeader@1003 : Record 36;
      SalesInvoiceHeader@1004 : Record 112;
      DataTypeManagement@1006 : Codeunit 701;
      DocumentRecordRef@1000 : RecordRef;
      DocumentIdFieldRef@1005 : FieldRef;
      DocumentId@1002 : GUID;
    BEGIN
      IF DocumentIdFilter = '' THEN
        ERROR(DocumentIDNotSpecifiedForAttachmentsErr);

      SalesHeader.SETFILTER(Id,DocumentIdFilter);
      IF SalesHeader.FINDFIRST THEN
        DocumentRecordRef.GETTABLE(SalesHeader)
      ELSE BEGIN
        SalesInvoiceHeader.SETFILTER(Id,DocumentIdFilter);
        IF SalesInvoiceHeader.FINDFIRST THEN
          DocumentRecordRef.GETTABLE(SalesInvoiceHeader)
        ELSE
          ERROR(DocumentDoesNotExistErr);
      END;

      DataTypeManagement.FindFieldByName(DocumentRecordRef,DocumentIdFieldRef,SalesHeader.FIELDNAME(Id));
      EVALUATE(DocumentId,FORMAT(DocumentIdFieldRef.VALUE));

      EXIT(DocumentId);
    END;

    LOCAL PROCEDURE GeneratePdf@21(DocumentId@1009 : GUID);
    VAR
      CompanyInformation@1004 : Record 79;
      SalesInvoiceHeader@1002 : Record 112;
      SalesHeader@1006 : Record 36;
      ReportSelections@1005 : Record 77;
      NativeReports@1011 : Codeunit 2822;
      DocumentMailing@1003 : Codeunit 260;
      GraphIntBusinessProfile@1013 : Codeunit 5442;
      File@1007 : File;
      InStream@1008 : InStream;
      OutStream@1010 : OutStream;
      Path@1001 : Text[250];
      Name@1000 : Text[250];
      ReportId@1012 : Integer;
    BEGIN
      GraphIntBusinessProfile.SyncFromGraphSynchronously;

      CompanyInformation.GET;
      SalesHeader.SETRANGE(Id,DocumentId);
      IF SalesHeader.FINDFIRST THEN
        CASE SalesHeader."Document Type" OF
          SalesHeader."Document Type"::Invoice:
            BEGIN
              ReportId := NativeReports.DraftSalesInvoiceReportId;
              ReportSelections.GetPdfReport(Path,ReportId,SalesHeader,SalesHeader."Sell-to Customer No.");
              DocumentMailing.GetAttachmentFileName(Name,SalesHeader."No.",SalesHeader.GetDocTypeTxt,ReportId);
            END;
          SalesHeader."Document Type"::Quote:
            BEGIN
              ReportId := NativeReports.SalesQuoteReportId;
              ReportSelections.GetPdfReport(Path,ReportId,SalesHeader,SalesHeader."Sell-to Customer No.");
              DocumentMailing.GetAttachmentFileName(Name,SalesHeader."No.",SalesHeader.GetDocTypeTxt,ReportId);
            END;
          ELSE
            ERROR(CannotFindDocumentErr,DocumentId);
        END
      ELSE BEGIN
        SalesInvoiceHeader.SETRANGE(Id,DocumentId);
        IF SalesInvoiceHeader.FINDFIRST THEN BEGIN
          ReportId := NativeReports.PostedSalesInvoiceReportId;
          ReportSelections.GetPdfReport(Path,ReportId,SalesInvoiceHeader,SalesInvoiceHeader."Sell-to Customer No.");
          DocumentMailing.GetAttachmentFileName(Name,SalesInvoiceHeader."No.",SalesInvoiceHeader.GetDocTypeTxt,ReportId);
        END ELSE
          ERROR(CannotFindDocumentErr,DocumentId);
      END;

      IF NOT File.OPEN(Path) THEN
        ERROR(CannotOpenFileErr,GETLASTERRORTEXT);

      INIT;
      Id := DocumentId;
      "Document Id" := DocumentId;
      "File Name" := Name;
      Type := Type::PDF;
      Content.CREATEOUTSTREAM(OutStream);
      File.CREATEINSTREAM(InStream);
      COPYSTREAM(OutStream,InStream);
      File.CLOSE;
      IF ERASE(Path) THEN;
      INSERT(TRUE);

      PdfGenerated := TRUE;
    END;

    BEGIN
    END.
  }
}

