OBJECT Codeunit 452 Report Distribution Management
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    EventSubscriberInstance=Manual;
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      HideDialog@1008 : Boolean;

    [Internal]
    PROCEDURE VANDocumentReport@5(HeaderDoc@1000 : Variant;TempDocumentSendingProfile@1002 : TEMPORARY Record 60);
    VAR
      ElectronicDocumentFormat@1003 : Record 61;
      RecordExportBuffer@1008 : Record 62;
      DocExchServiceMgt@1005 : Codeunit 1410;
      RecordRef@1006 : RecordRef;
      SpecificRecordRef@1007 : RecordRef;
      XMLPath@1004 : Text[250];
      ClientFileName@1001 : Text[250];
    BEGIN
      RecordRef.GETTABLE(HeaderDoc);
      IF RecordRef.FINDSET THEN
        REPEAT
          SpecificRecordRef.GET(RecordRef.RECORDID);
          SpecificRecordRef.SETRECFILTER;
          ElectronicDocumentFormat.SendElectronically(
            XMLPath,ClientFileName,SpecificRecordRef,TempDocumentSendingProfile."Electronic Format");
          IF ElectronicDocumentFormat."Delivery Codeunit ID" = 0 THEN
            DocExchServiceMgt.SendDocument(SpecificRecordRef,XMLPath)
          ELSE BEGIN
            RecordExportBuffer.RecordID := SpecificRecordRef.RECORDID;
            RecordExportBuffer.ClientFileName := ClientFileName;
            RecordExportBuffer.ServerFilePath := XMLPath;
            CODEUNIT.RUN(ElectronicDocumentFormat."Delivery Codeunit ID",RecordExportBuffer);
          END;
        UNTIL RecordRef.NEXT = 0;
    END;

    [External]
    PROCEDURE DownloadPdfOnClient@12(ServerPdfFilePath@1000 : Text) : Text;
    VAR
      FileManagement@1001 : Codeunit 419;
      ClientPdfFilePath@1002 : Text;
    BEGIN
      ClientPdfFilePath := FileManagement.DownloadTempFile(ServerPdfFilePath);
      ERASE(ServerPdfFilePath);
      EXIT(ClientPdfFilePath);
    END;

    [External]
    PROCEDURE InitializeFrom@10(NewHideDialog@1001 : Boolean);
    BEGIN
      HideDialog := NewHideDialog;
    END;

    LOCAL PROCEDURE GetDocumentType@7(DocumentVariant@1000 : Variant) : Text[50];
    VAR
      DummySalesHeader@1002 : Record 36;
      DummyServiceHeader@1003 : Record 5900;
      DummyPurchaseHeader@1004 : Record 38;
      DocumentRecordRef@1005 : RecordRef;
    BEGIN
      DocumentRecordRef.GETTABLE(DocumentVariant);
      CASE DocumentRecordRef.NUMBER OF
        DATABASE::"Sales Invoice Header":
          EXIT(FORMAT(DummySalesHeader."Document Type"::Invoice));
        DATABASE::"Sales Cr.Memo Header":
          EXIT(FORMAT(DummySalesHeader."Document Type"::"Credit Memo"));
        DATABASE::"Service Invoice Header":
          EXIT(FORMAT(DummyServiceHeader."Document Type"::Invoice));
        DATABASE::"Service Cr.Memo Header":
          EXIT(FORMAT(DummyServiceHeader."Document Type"::"Credit Memo"));
        DATABASE::"Purchase Header":
          EXIT(FORMAT(DummyPurchaseHeader."Document Type"::Order));
        DATABASE::"Service Header":
          BEGIN
            DummyServiceHeader := DocumentVariant;
            IF DummyServiceHeader."Document Type" = DummyServiceHeader."Document Type"::Quote THEN
              EXIT(FORMAT(DummyServiceHeader."Document Type"::Quote));
          END;
        DATABASE::"Sales Header":
          BEGIN
            DummySalesHeader := DocumentVariant;
            IF DummySalesHeader."Document Type" = DummySalesHeader."Document Type"::Quote THEN
              EXIT(FORMAT(DummySalesHeader."Document Type"::Quote));
          END;
      END;
    END;

    LOCAL PROCEDURE GetBillToCustomer@16(VAR Customer@1000 : Record 18;DocumentVariant@1001 : Variant);
    VAR
      SalesInvoiceHeader@1003 : Record 112;
      SalesCrMemoHeader@1002 : Record 114;
      SalesHeader@1006 : Record 36;
      ServiceInvoiceHeader@1004 : Record 5992;
      ServiceCrMemoHeader@1007 : Record 5994;
      ServiceHeader@1008 : Record 5900;
      Job@1009 : Record 167;
      DocumentRecordRef@1005 : RecordRef;
    BEGIN
      DocumentRecordRef.GETTABLE(DocumentVariant);
      CASE DocumentRecordRef.NUMBER OF
        DATABASE::"Sales Invoice Header":
          BEGIN
            SalesInvoiceHeader := DocumentVariant;
            Customer.GET(SalesInvoiceHeader."Bill-to Customer No.");
          END;
        DATABASE::"Sales Cr.Memo Header":
          BEGIN
            SalesCrMemoHeader := DocumentVariant;
            Customer.GET(SalesCrMemoHeader."Bill-to Customer No.");
          END;
        DATABASE::"Service Invoice Header":
          BEGIN
            ServiceInvoiceHeader := DocumentVariant;
            Customer.GET(ServiceInvoiceHeader."Bill-to Customer No.");
          END;
        DATABASE::"Service Cr.Memo Header":
          BEGIN
            ServiceCrMemoHeader := DocumentVariant;
            Customer.GET(ServiceCrMemoHeader."Bill-to Customer No.");
          END;
        DATABASE::"Service Header":
          BEGIN
            ServiceHeader := DocumentVariant;
            Customer.GET(ServiceHeader."Bill-to Customer No.");
          END;
        DATABASE::"Sales Header":
          BEGIN
            SalesHeader := DocumentVariant;
            Customer.GET(SalesHeader."Bill-to Customer No.");
          END;
        DATABASE::Job:
          BEGIN
            Job := DocumentVariant;
            Customer.GET(Job."Bill-to Customer No.");
          END;
      END;
    END;

    LOCAL PROCEDURE GetBuyFromVendor@2(VAR Vendor@1001 : Record 23;DocumentVariant@1000 : Variant);
    VAR
      PurchaseHeader@1009 : Record 38;
      DocumentRecordRef@1002 : RecordRef;
    BEGIN
      DocumentRecordRef.GETTABLE(DocumentVariant);
      CASE DocumentRecordRef.NUMBER OF
        DATABASE::"Purchase Header":
          BEGIN
            PurchaseHeader := DocumentVariant;
            Vendor.GET(PurchaseHeader."Buy-from Vendor No.");
          END;
      END;
    END;

    [Internal]
    PROCEDURE SaveFileOnClient@14(ServerFilePath@1000 : Text;ClientFileName@1005 : Text);
    VAR
      FileManagement@1004 : Codeunit 419;
    BEGIN
      FileManagement.DownloadHandler(
        ServerFilePath,
        '',
        '',
        FileManagement.GetToFilterText('',ClientFileName),
        ClientFileName);
    END;

    LOCAL PROCEDURE SendAttachment@6(PostedDocumentNo@1000 : Code[20];SendEmailAddress@1001 : Text[250];AttachmentFilePath@1002 : Text[250];AttachmentFileName@1004 : Text[250];DocumentType@1005 : Text[50];SendTo@1009 : Option;ServerEmailBodyFilePath@1003 : Text[250];ReportUsage@1006 : Integer);
    VAR
      DocumentSendingProfile@1007 : Record 60;
      DocumentMailing@1008 : Codeunit 260;
    BEGIN
      IF SendTo = DocumentSendingProfile."Send To"::Disk THEN BEGIN
        SaveFileOnClient(AttachmentFilePath,AttachmentFileName);
        EXIT;
      END;

      DocumentMailing.EmailFile(
        AttachmentFilePath,AttachmentFileName,ServerEmailBodyFilePath,PostedDocumentNo,
        SendEmailAddress,DocumentType,HideDialog,ReportUsage);
    END;

    [Internal]
    PROCEDURE SendXmlEmailAttachment@4(DocumentVariant@1000 : Variant;DocumentFormat@1008 : Code[20];ServerEmailBodyFilePath@1004 : Text[250];SendToEmailAddress@1009 : Text[250]);
    VAR
      ElectronicDocumentFormat@1001 : Record 61;
      Customer@1002 : Record 18;
      DocumentSendingProfile@1007 : Record 60;
      ReportSelections@1011 : Record 77;
      DocumentMailing@1005 : Codeunit 260;
      XMLPath@1006 : Text[250];
      ClientFileName@1003 : Text[250];
      ReportUsage@1010 : Integer;
    BEGIN
      GetBillToCustomer(Customer,DocumentVariant);

      IF SendToEmailAddress = '' THEN
        SendToEmailAddress := DocumentMailing.GetToAddressFromCustomer(Customer."No.");

      DocumentSendingProfile.GET(Customer."Document Sending Profile");
      IF DocumentSendingProfile.Usage = DocumentSendingProfile.Usage::"Job Quote" THEN
        ReportUsage := ReportSelections.Usage::JQ;

      ElectronicDocumentFormat.SendElectronically(XMLPath,ClientFileName,DocumentVariant,DocumentFormat);
      COMMIT;
      SendAttachment(
        ElectronicDocumentFormat.GetDocumentNo(DocumentVariant),
        SendToEmailAddress,
        XMLPath,
        ClientFileName,
        GetDocumentType(DocumentVariant),
        DocumentSendingProfile."Send To"::"Electronic Document",
        ServerEmailBodyFilePath,ReportUsage);
    END;

    [Internal]
    PROCEDURE SendXmlEmailAttachmentVendor@1(DocumentVariant@1003 : Variant;DocumentFormat@1002 : Code[20];ServerEmailBodyFilePath@1001 : Text[250];SendToEmailAddress@1000 : Text[250]);
    VAR
      ElectronicDocumentFormat@1011 : Record 61;
      Vendor@1010 : Record 23;
      DocumentSendingProfile@1009 : Record 60;
      ReportSelections@1008 : Record 77;
      DocumentMailing@1007 : Codeunit 260;
      XMLPath@1006 : Text[250];
      ClientFileName@1005 : Text[250];
      ReportUsage@1004 : Integer;
    BEGIN
      GetBuyFromVendor(Vendor,DocumentVariant);

      IF SendToEmailAddress = '' THEN
        SendToEmailAddress := DocumentMailing.GetToAddressFromVendor(Vendor."No.");

      DocumentSendingProfile.GET(Vendor."Document Sending Profile");

      IF DocumentSendingProfile.Usage = DocumentSendingProfile.Usage::"Job Quote" THEN
        ReportUsage := ReportSelections.Usage::JQ;

      ElectronicDocumentFormat.SendElectronically(XMLPath,ClientFileName,DocumentVariant,DocumentFormat);
      COMMIT;
      SendAttachment(
        ElectronicDocumentFormat.GetDocumentNo(DocumentVariant),
        SendToEmailAddress,
        XMLPath,
        ClientFileName,
        GetDocumentType(DocumentVariant),
        DocumentSendingProfile."Send To"::"Electronic Document",
        ServerEmailBodyFilePath,ReportUsage);
    END;

    [Internal]
    PROCEDURE CreateOrAppendZipFile@17(VAR FileManagement@1000 : Codeunit 419;ServerFilePath@1001 : Text[250];ClientFileName@1004 : Text[250];VAR ZipPath@1003 : Text[250];VAR ClientZipFileName@1002 : Text[250]);
    BEGIN
      IF FileManagement.IsGZip(ServerFilePath) THEN BEGIN
        ZipPath := ServerFilePath;
        FileManagement.OpenZipFile(ZipPath);
        ClientZipFileName := ClientFileName;
      END ELSE BEGIN
        ZipPath := COPYSTR(FileManagement.CreateZipArchiveObject,1,250);
        FileManagement.AddFileToZipArchive(ServerFilePath,ClientFileName);
        ClientZipFileName := COPYSTR(FileManagement.GetFileNameWithoutExtension(ClientFileName) + '.zip',1,250);
      END;
    END;

    BEGIN
    END.
  }
}

