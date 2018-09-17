OBJECT Table 61 Electronic Document Format
{
  OBJECT-PROPERTIES
  {
    Date=25-05-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.22292;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               CheckCodeunitExist;
             END;

    OnModify=BEGIN
               CheckCodeunitExist;
             END;

    CaptionML=[DAN=Elektronisk dokumentformat;
               ENU=Electronic Document Format];
    LookupPageID=Page363;
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code20        ;CaptionML=[DAN=Kode;
                                                              ENU=Code];
                                                   NotBlank=Yes }
    { 2   ;   ;Usage               ;Option        ;CaptionML=[DAN=Forbrug;
                                                              ENU=Usage];
                                                   OptionCaptionML=[DAN=Salgsfaktura,Salgskreditnota,Salgsvalidering,Servicefaktura,Servicekreditnota,Servicevalidering,Antal i tilbud;
                                                                    ENU=Sales Invoice,Sales Credit Memo,Sales Validation,Service Invoice,Service Credit Memo,Service Validation,Job Quote];
                                                   OptionString=Sales Invoice,Sales Credit Memo,Sales Validation,Service Invoice,Service Credit Memo,Service Validation,Job Quote }
    { 4   ;   ;Description         ;Text250       ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 5   ;   ;Codeunit ID         ;Integer       ;TableRelation=AllObjWithCaption."Object ID" WHERE (Object Type=CONST(Codeunit));
                                                   CaptionML=[DAN=Codeunit-id;
                                                              ENU=Codeunit ID];
                                                   NotBlank=Yes;
                                                   BlankZero=Yes }
    { 6   ;   ;Codeunit Caption    ;Text250       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(AllObjWithCaption."Object Caption" WHERE (Object Type=CONST(Codeunit),
                                                                                                                Object ID=FIELD(Codeunit ID)));
                                                   CaptionML=[DAN=Codeunit-titel;
                                                              ENU=Codeunit Caption];
                                                   Editable=No }
    { 7   ;   ;Delivery Codeunit ID;Integer       ;TableRelation=AllObjWithCaption."Object ID" WHERE (Object Type=CONST(Codeunit));
                                                   CaptionML=[DAN=Leverings codeunit-id;
                                                              ENU=Delivery Codeunit ID];
                                                   BlankZero=Yes }
    { 8   ;   ;Delivery Codeunit Caption;Text250  ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(AllObjWithCaption."Object Caption" WHERE (Object Type=CONST(Codeunit),
                                                                                                                Object ID=FIELD(Delivery Codeunit ID)));
                                                   CaptionML=[DAN=Leverings codeunit-tekst;
                                                              ENU=Delivery Codeunit Caption];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Code,Usage                              ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      UnSupportedTableTypeErr@1000 : TextConst '@@@="%1 = Sales Document Type";DAN=Tabellen %1 underst�ttes ikke.;ENU=The %1 table is not supported.';
      NonExistingDocumentFormatErr@1001 : TextConst '@@@=%1 : document format, %2 document use eq Invoice;DAN=Det elektronisk dokuments format %1 findes ikke for dokumenttypen %2.;ENU=The electronic document format %1 does not exist for the document type %2.';
      UnSupportedDocumentTypeErr@1002 : TextConst '@@@="%1 : document ytp eq Invocie ";DAN=Dokumenttypen %1 underst�ttes ikke.;ENU=The document type %1 is not supported.';
      ElectronicDocumentNotCreatedErr@1003 : TextConst 'DAN=Det elektroniske dokument er ikke oprettet.;ENU=The electronic document has not been created.';
      ElectronicFormatErr@1004 : TextConst '@@@="%1=Specified Electronic Format";DAN=Dette elektroniske format %1 findes ikke.;ENU=The electronic format %1 does not exist.';
      FileManagement@1005 : Codeunit 419;

    [Internal]
    PROCEDURE SendElectronically@1(VAR ServerFilePath@1008 : Text[250];VAR ClientFileName@1009 : Text[250];DocumentVariant@1000 : Variant;ElectronicFormat@1003 : Code[20]);
    VAR
      RecordExportBuffer@1002 : Record 62;
      TempErrorMessage@1011 : TEMPORARY Record 700;
      ErrorMessage@1012 : Record 700;
      RecRef@1005 : RecordRef;
      DocumentUsage@1004 : 'Sales Invoice,Sales Credit Memo';
      StartID@1006 : Integer;
      EndID@1007 : Integer;
      IsMissingServerFile@1010 : Boolean;
    BEGIN
      GetDocumentUsage(DocumentUsage,DocumentVariant);

      IF NOT GET(ElectronicFormat,DocumentUsage) THEN
        ERROR(STRSUBSTNO(NonExistingDocumentFormatErr,ElectronicFormat,FORMAT(DocumentUsage)));

      RecRef.GETTABLE(DocumentVariant);

      RecordExportBuffer.LOCKTABLE;
      IF RecRef.FINDSET THEN
        REPEAT
          CLEAR(RecordExportBuffer);
          RecordExportBuffer.RecordID := RecRef.RECORDID;
          RecordExportBuffer.ClientFileName :=
            GetAttachmentFileName(GetDocumentNo(RecRef),GetDocumentType(RecRef),'xml');
          RecordExportBuffer.ZipFileName :=
            GetAttachmentFileName(GetDocumentNo(RecRef),GetDocumentType(RecRef),'zip');
          RecordExportBuffer.INSERT(TRUE);
          IF StartID = 0 THEN
            StartID := RecordExportBuffer.ID;
          EndID := RecordExportBuffer.ID;
        UNTIL RecRef.NEXT = 0;

      RecordExportBuffer.SETRANGE(ID,StartID,EndID);
      IF RecordExportBuffer.FINDSET THEN
        REPEAT
          ErrorMessage.SetContext(RecordExportBuffer);
          ErrorMessage.ClearLog;

          CODEUNIT.RUN("Codeunit ID",RecordExportBuffer);

          TempErrorMessage.CopyFromContext(RecordExportBuffer);
          ErrorMessage.ClearLog; // Clean up

          IF RecordExportBuffer.ServerFilePath = '' THEN
            IsMissingServerFile := TRUE;
        UNTIL RecordExportBuffer.NEXT = 0;

      // Display errors in case anything went wrong.
      TempErrorMessage.ShowErrorMessages(TRUE);
      IF IsMissingServerFile THEN
        ERROR(ElectronicDocumentNotCreatedErr);

      IF RecordExportBuffer.COUNT > 1 THEN BEGIN
        ServerFilePath := COPYSTR(FileManagement.CreateZipArchiveObject,1,250);
        ClientFileName := COPYSTR(RecordExportBuffer.ZipFileName,1,250);
        RecordExportBuffer.FINDSET;
        REPEAT
          FileManagement.AddFileToZipArchive(RecordExportBuffer.ServerFilePath,RecordExportBuffer.ClientFileName);
        UNTIL RecordExportBuffer.NEXT = 0;
        FileManagement.CloseZipArchive;
      END ELSE
        IF RecordExportBuffer.FINDFIRST THEN BEGIN
          ServerFilePath := RecordExportBuffer.ServerFilePath;
          ClientFileName := RecordExportBuffer.ClientFileName;
        END;

      RecordExportBuffer.DELETEALL;
    END;

    [External]
    PROCEDURE ValidateElectronicServiceDocument@11(ServiceHeader@1000 : Record 5900;ElectronicFormat@1001 : Code[20]);
    VAR
      ElectronicDocumentFormat@1002 : Record 61;
    BEGIN
      IF NOT ElectronicDocumentFormat.GET(ElectronicFormat,Usage::"Service Validation") THEN
        EXIT; // no validation required

      CODEUNIT.RUN(ElectronicDocumentFormat."Codeunit ID",ServiceHeader);
    END;

    [External]
    PROCEDURE ValidateElectronicSalesDocument@3(SalesHeader@1000 : Record 36;ElectronicFormat@1001 : Code[20]);
    VAR
      ElectronicDocumentFormat@1002 : Record 61;
    BEGIN
      IF NOT ElectronicDocumentFormat.GET(ElectronicFormat,Usage::"Sales Validation") THEN
        EXIT; // no validation required

      CODEUNIT.RUN(ElectronicDocumentFormat."Codeunit ID",SalesHeader);
    END;

    [External]
    PROCEDURE ValidateElectronicJobsDocument@6(Job@1000 : Record 167;ElectronicFormat@1001 : Code[20]);
    VAR
      ElectronicDocumentFormat@1002 : Record 61;
    BEGIN
      IF NOT ElectronicDocumentFormat.GET(ElectronicFormat,Usage::"Job Quote") THEN
        EXIT; // no validation required

      CODEUNIT.RUN(ElectronicDocumentFormat."Codeunit ID",Job);
    END;

    [External]
    PROCEDURE GetAttachmentFileName@30(DocumentNo@1003 : Code[20];DocumentType@1005 : Text;Extension@1001 : Code[3]) : Text[250];
    VAR
      FileMgt@1000 : Codeunit 419;
    BEGIN
      EXIT(
        COPYSTR(
          STRSUBSTNO('%1 - %2 %3.%4',FileMgt.StripNotsupportChrInFileName(COMPANYNAME),DocumentType,DocumentNo,Extension),1,250));
    END;

    [External]
    PROCEDURE GetDocumentUsage@4(VAR DocumentUsage@1000 : Option;DocumentVariant@1001 : Variant);
    VAR
      DocumentRecordRef@1003 : RecordRef;
    BEGIN
      DocumentRecordRef.GETTABLE(DocumentVariant);
      CASE DocumentRecordRef.NUMBER OF
        DATABASE::"Sales Invoice Header":
          DocumentUsage := Usage::"Sales Invoice";
        DATABASE::"Sales Cr.Memo Header":
          DocumentUsage := Usage::"Sales Credit Memo";
        DATABASE::"Service Invoice Header":
          DocumentUsage := Usage::"Service Invoice";
        DATABASE::"Service Cr.Memo Header":
          DocumentUsage := Usage::"Service Credit Memo";
        DATABASE::"Sales Header":
          GetDocumentUsageForSalesHeader(DocumentUsage,DocumentVariant);
        DATABASE::"Service Header":
          GetDocumentUsageForServiceHeader(DocumentUsage,DocumentVariant);
        DATABASE::Job:
          DocumentUsage := Usage::"Job Quote";
        ELSE
          ERROR(STRSUBSTNO(UnSupportedTableTypeErr,DocumentRecordRef.CAPTION));
      END;
    END;

    [External]
    PROCEDURE GetDocumentNo@7(DocumentVariant@1001 : Variant) : Code[20];
    VAR
      SalesInvoiceHeader@1000 : Record 112;
      SalesCrMemoHeader@1002 : Record 114;
      SalesHeader@1004 : Record 36;
      ServiceInvoiceHeader@1005 : Record 5992;
      ServiceCrMemoHeader@1006 : Record 5994;
      ServiceHeader@1007 : Record 5900;
      Job@1008 : Record 167;
      DocumentRecordRef@1003 : RecordRef;
    BEGIN
      IF DocumentVariant.ISRECORD THEN
        DocumentRecordRef.GETTABLE(DocumentVariant)
      ELSE
        IF DocumentVariant.ISRECORDREF THEN
          DocumentRecordRef := DocumentVariant;

      CASE DocumentRecordRef.NUMBER OF
        DATABASE::"Sales Invoice Header":
          BEGIN
            SalesInvoiceHeader := DocumentVariant;
            EXIT(SalesInvoiceHeader."No.");
          END;
        DATABASE::"Sales Cr.Memo Header":
          BEGIN
            SalesCrMemoHeader := DocumentVariant;
            EXIT(SalesCrMemoHeader."No.");
          END;
        DATABASE::"Service Invoice Header":
          BEGIN
            ServiceInvoiceHeader := DocumentVariant;
            EXIT(ServiceInvoiceHeader."No.");
          END;
        DATABASE::"Service Cr.Memo Header":
          BEGIN
            ServiceCrMemoHeader := DocumentVariant;
            EXIT(ServiceCrMemoHeader."No.");
          END;
        DATABASE::"Service Header":
          BEGIN
            ServiceHeader := DocumentVariant;
            EXIT(ServiceHeader."No.");
          END;
        DATABASE::"Sales Header":
          BEGIN
            SalesHeader := DocumentVariant;
            EXIT(SalesHeader."No.");
          END;
        DATABASE::Job:
          BEGIN
            Job := DocumentVariant;
            EXIT(Job."No.");
          END;
        ELSE
          ERROR(STRSUBSTNO(UnSupportedTableTypeErr,DocumentRecordRef.CAPTION));
      END;
    END;

    LOCAL PROCEDURE GetDocumentUsageForSalesHeader@2(VAR DocumentUsage@1001 : Option;SalesHeader@1000 : Record 36);
    BEGIN
      CASE SalesHeader."Document Type" OF
        SalesHeader."Document Type"::Order:
          EXIT;
        SalesHeader."Document Type"::Invoice:
          DocumentUsage := Usage::"Sales Invoice";
        SalesHeader."Document Type"::"Credit Memo":
          DocumentUsage := Usage::"Sales Credit Memo";
        ELSE
          ERROR(STRSUBSTNO(UnSupportedDocumentTypeErr,FORMAT(SalesHeader."Document Type")));
      END;
    END;

    LOCAL PROCEDURE GetDocumentUsageForServiceHeader@9(VAR DocumentUsage@1001 : Option;ServiceHeader@1000 : Record 5900);
    BEGIN
      CASE ServiceHeader."Document Type" OF
        ServiceHeader."Document Type"::Invoice:
          DocumentUsage := Usage::"Service Invoice";
        ServiceHeader."Document Type"::"Credit Memo":
          DocumentUsage := Usage::"Service Credit Memo";
        ELSE
          ERROR(STRSUBSTNO(UnSupportedDocumentTypeErr,FORMAT(ServiceHeader."Document Type")));
      END;
    END;

    LOCAL PROCEDURE CheckCodeunitExist@8();
    VAR
      AllObj@1000 : Record 2000000038;
    BEGIN
      AllObj.GET(AllObj."Object Type"::Codeunit,"Codeunit ID");
    END;

    [External]
    PROCEDURE ValidateElectronicFormat@5(ElectronicFormat@1001 : Code[20]);
    VAR
      ElectronicDocumentFormat@1000 : Record 61;
    BEGIN
      ElectronicDocumentFormat.SETRANGE(Code,ElectronicFormat);
      IF ElectronicDocumentFormat.ISEMPTY THEN
        ERROR(ElectronicFormatErr,ElectronicFormat);
    END;

    LOCAL PROCEDURE GetDocumentType@60(DocumentVariant@1000 : Variant) : Text[50];
    VAR
      DummySalesHeader@1002 : Record 36;
      DummyServiceHeader@1003 : Record 5900;
      DocumentRecordRef@1001 : RecordRef;
    BEGIN
      IF DocumentVariant.ISRECORD THEN
        DocumentRecordRef.GETTABLE(DocumentVariant)
      ELSE
        IF DocumentVariant.ISRECORDREF THEN
          DocumentRecordRef := DocumentVariant;
      CASE DocumentRecordRef.NUMBER OF
        DATABASE::"Sales Invoice Header":
          EXIT(FORMAT(DummySalesHeader."Document Type"::Invoice));
        DATABASE::"Sales Cr.Memo Header":
          EXIT(FORMAT(DummySalesHeader."Document Type"::"Credit Memo"));
        DATABASE::"Service Invoice Header":
          EXIT(FORMAT(DummyServiceHeader."Document Type"::Invoice));
        DATABASE::"Service Cr.Memo Header":
          EXIT(FORMAT(DummyServiceHeader."Document Type"::"Credit Memo"));
        DATABASE::Job:
          EXIT(FORMAT(DummyServiceHeader."Document Type"::Quote));
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

    [External]
    PROCEDURE InsertElectronicFormat@24(InsertElectronicFormatCode@1000 : Code[20];InsertElectronicFormatDescription@1001 : Text[250];CodeunitID@1002 : Integer;DeliveryCodeunitID@1005 : Integer;InsertElectronicFormatUsage@1004 : Option);
    VAR
      ElectronicDocumentFormat@1003 : Record 61;
    BEGIN
      IF ElectronicDocumentFormat.GET(InsertElectronicFormatCode,Usage) THEN
        EXIT;

      ElectronicDocumentFormat.INIT;
      ElectronicDocumentFormat.Code := InsertElectronicFormatCode;
      ElectronicDocumentFormat.Description := InsertElectronicFormatDescription;
      ElectronicDocumentFormat."Codeunit ID" := CodeunitID;
      ElectronicDocumentFormat."Delivery Codeunit ID" := DeliveryCodeunitID;
      ElectronicDocumentFormat.Usage := InsertElectronicFormatUsage;
      ElectronicDocumentFormat.INSERT;
    END;

    [Integration]
    PROCEDURE OnDiscoverElectronicFormat@10();
    BEGIN
    END;

    BEGIN
    END.
  }
}

