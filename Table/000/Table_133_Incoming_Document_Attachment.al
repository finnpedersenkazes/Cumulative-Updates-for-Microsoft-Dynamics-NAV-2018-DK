OBJECT Table 133 Incoming Document Attachment
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               TESTFIELD("Incoming Document Entry No.");
               "Created Date-Time" := ROUNDDATETIME(CURRENTDATETIME,1000);
               "Created By User Name" := USERID;

               SetFirstAttachmentAsDefault;
               SetFirstAttachmentAsMain;

               CheckDefault;
               CheckMainAttachment;
             END;

    OnModify=BEGIN
               CheckDefault;
               CheckMainAttachment;
             END;

    OnDelete=VAR
               IncomingDocumentAttachment@1000 : Record 133;
             BEGIN
               IncomingDocumentAttachment.SETRANGE("Incoming Document Entry No.","Incoming Document Entry No.");
               IncomingDocumentAttachment.SETFILTER("Line No.",'<>%1',"Line No.");

               IF Default THEN BEGIN
                 IF NOT IncomingDocumentAttachment.ISEMPTY THEN
                   ERROR(DefaultAttachErr);
               END;

               IF "Main Attachment" THEN BEGIN
                 IF NOT IncomingDocumentAttachment.ISEMPTY THEN
                   ERROR(MainAttachErr);
               END;
             END;

    CaptionML=[DAN=Vedh�ftet fil til indg. bilag;
               ENU=Incoming Document Attachment];
  }
  FIELDS
  {
    { 1   ;   ;Incoming Document Entry No.;Integer;TableRelation="Incoming Document";
                                                   CaptionML=[DAN=L�benr. for indg�ende bilag;
                                                              ENU=Incoming Document Entry No.] }
    { 2   ;   ;Line No.            ;Integer       ;CaptionML=[DAN=Linjenr.;
                                                              ENU=Line No.] }
    { 3   ;   ;Created Date-Time   ;DateTime      ;CaptionML=[DAN=Oprettet dato/klokkesl�t;
                                                              ENU=Created Date-Time] }
    { 4   ;   ;Created By User Name;Code50        ;DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Brugernavn for oprettelse;
                                                              ENU=Created By User Name] }
    { 5   ;   ;Name                ;Text250       ;CaptionML=[DAN=Navn;
                                                              ENU=Name] }
    { 6   ;   ;Type                ;Option        ;CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=" ,Billede,PDF,Word,Excel,PowerPoint,Mail,XML,Andet";
                                                                    ENU=" ,Image,PDF,Word,Excel,PowerPoint,Email,XML,Other"];
                                                   OptionString=[ ,Image,PDF,Word,Excel,PowerPoint,Email,XML,Other] }
    { 7   ;   ;File Extension      ;Text30        ;OnValidate=BEGIN
                                                                CASE LOWERCASE("File Extension") OF
                                                                  'jpg','jpeg','bmp','png','tiff','tif','gif':
                                                                    Type := Type::Image;
                                                                  'pdf':
                                                                    Type := Type::PDF;
                                                                  'docx','doc':
                                                                    Type := Type::Word;
                                                                  'xlsx','xls':
                                                                    Type := Type::Excel;
                                                                  'pptx','ppt':
                                                                    Type := Type::PowerPoint;
                                                                  'msg':
                                                                    Type := Type::Email;
                                                                  'xml':
                                                                    Type := Type::XML;
                                                                  ELSE
                                                                    Type := Type::Other;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Filtype;
                                                              ENU=File Extension] }
    { 8   ;   ;Content             ;BLOB          ;CaptionML=[DAN=Indhold;
                                                              ENU=Content];
                                                   SubType=Bitmap }
    { 9   ;   ;Document No.        ;Code20        ;CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.] }
    { 10  ;   ;Posting Date        ;Date          ;CaptionML=[DAN=Bogf�ringsdato;
                                                              ENU=Posting Date] }
    { 11  ;   ;Document Table No. Filter;Integer  ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Filter for dokumenttabelnr.;
                                                              ENU=Document Table No. Filter] }
    { 12  ;   ;Document Type Filter;Option        ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Dokumenttypefilter;
                                                              ENU=Document Type Filter];
                                                   OptionCaptionML=[DAN=Tilbud,Ordre,Faktura,Kreditnota,Rammeordre,Returv.ordre;
                                                                    ENU=Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order];
                                                   OptionString=Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order }
    { 13  ;   ;Document No. Filter ;Code20        ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Bilagsnummerfilter;
                                                              ENU=Document No. Filter] }
    { 14  ;   ;Journal Template Name Filter;Code20;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Filter for kladdetypenavn;
                                                              ENU=Journal Template Name Filter] }
    { 15  ;   ;Journal Batch Name Filter;Code20   ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Filter for finanskladdenavn;
                                                              ENU=Journal Batch Name Filter] }
    { 16  ;   ;Journal Line No. Filter;Integer    ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Filter for kladdelinjenr.;
                                                              ENU=Journal Line No. Filter] }
    { 17  ;   ;Default             ;Boolean       ;OnValidate=BEGIN
                                                                IF Default AND (NOT xRec.Default) THEN BEGIN
                                                                  ClearDefaultAttachmentsFromIncomingDocument;
                                                                  FindDataExchType;
                                                                  UpdateIncomingDocumentHeaderFields;
                                                                END ELSE
                                                                  CheckDefault;
                                                              END;

                                                   CaptionML=[DAN=Standard;
                                                              ENU=Default] }
    { 18  ;   ;Use for OCR         ;Boolean       ;OnValidate=BEGIN
                                                                IF "Use for OCR" THEN
                                                                  IF NOT (Type IN [Type::PDF,Type::Image]) THEN
                                                                    ERROR(MustBePdfOrPictureErr,Type::PDF,Type::Image);
                                                              END;

                                                   CaptionML=[DAN=Brug til OCR;
                                                              ENU=Use for OCR] }
    { 19  ;   ;External Document Reference;Text50 ;CaptionML=[DAN=Ekstern bilagsreference;
                                                              ENU=External Document Reference] }
    { 20  ;   ;OCR Service Document Reference;Text50;
                                                   CaptionML=[DAN=OCR-servicedokumentreference;
                                                              ENU=OCR Service Document Reference] }
    { 21  ;   ;Generated from OCR  ;Boolean       ;CaptionML=[DAN=Genereret fra OCR;
                                                              ENU=Generated from OCR];
                                                   Editable=No }
    { 22  ;   ;Main Attachment     ;Boolean       ;OnValidate=BEGIN
                                                                CheckMainAttachment;
                                                              END;

                                                   CaptionML=[DAN=Prim�r vedh�ftet fil;
                                                              ENU=Main Attachment] }
    { 8000;   ;Id                  ;GUID          ;CaptionML=[DAN=Id;
                                                              ENU=Id] }
  }
  KEYS
  {
    {    ;Incoming Document Entry No.,Line No.    ;Clustered=Yes }
    {    ;Document No.,Posting Date                }
  }
  FIELDGROUPS
  {
    { 1   ;Brick               ;Created Date-Time,Name,File Extension,Type }
  }
  CODE
  {
    VAR
      DeleteQst@1004 : TextConst 'DAN=Vil du slette den vedh�ftede fil?;ENU=Do you want to delete the attachment?';
      DefaultAttachErr@1005 : TextConst 'DAN=Der kan kun v�re �n vedh�ftet standardfil.;ENU=There can only be one default attachment.';
      MainAttachErr@1000 : TextConst 'DAN=Der m� kun v�re �n prim�r vedh�ftet fil.;ENU=There can only be one main attachment.';
      MustBePdfOrPictureErr@1007 : TextConst '@@@=%1 and %2 are file types: PDF and Picture;DAN=Kun filer af typen %1 og %2 kan bruges til OCR.;ENU=Only files of type %1 and %2 can be used for OCR.';

    [External]
    PROCEDURE NewAttachment@1();
    BEGIN
      IF NOT CODEUNIT.RUN(CODEUNIT::"Import Attachment - Inc. Doc.",Rec) THEN
        ERROR('');
    END;

    [External]
    PROCEDURE NewAttachmentFromGenJnlLine@8(GenJournalLine@1000 : Record 81);
    BEGIN
      IF GenJournalLine."Line No." = 0 THEN
        EXIT;
      SETRANGE("Incoming Document Entry No.",GenJournalLine."Incoming Document Entry No.");
      SETRANGE("Journal Template Name Filter",GenJournalLine."Journal Template Name");
      SETRANGE("Journal Batch Name Filter",GenJournalLine."Journal Batch Name");
      SETRANGE("Journal Line No. Filter",GenJournalLine."Line No.");

      NewAttachment;
    END;

    [External]
    PROCEDURE NewAttachmentFromSalesDocument@15(SalesHeader@1000 : Record 36);
    BEGIN
      NewAttachmentFromDocument(
        SalesHeader."Incoming Document Entry No.",
        DATABASE::"Sales Header",
        SalesHeader."Document Type",
        SalesHeader."No.");
    END;

    [External]
    PROCEDURE NewAttachmentFromPurchaseDocument@9(PurchaseHeader@1000 : Record 38);
    BEGIN
      NewAttachmentFromDocument(
        PurchaseHeader."Incoming Document Entry No.",
        DATABASE::"Purchase Header",
        PurchaseHeader."Document Type",
        PurchaseHeader."No.");
    END;

    [External]
    PROCEDURE NewAttachmentFromDocument@10(EntryNo@1003 : Integer;TableID@1002 : Integer;DocumentType@1001 : Option;DocumentNo@1000 : Code[20]);
    BEGIN
      SETRANGE("Incoming Document Entry No.",EntryNo);
      SETRANGE("Document Table No. Filter",TableID);
      SETRANGE("Document Type Filter",DocumentType);
      SETRANGE("Document No. Filter",DocumentNo);
      NewAttachment;
    END;

    [External]
    PROCEDURE NewAttachmentFromPostedDocument@13(DocumentNo@1000 : Code[20];PostingDate@1001 : Date);
    BEGIN
      SETRANGE("Document No.",DocumentNo);
      SETRANGE("Posting Date",PostingDate);
      NewAttachment;
    END;

    [External]
    PROCEDURE Import@6() : Boolean;
    BEGIN
      EXIT(CODEUNIT.RUN(CODEUNIT::"Import Attachment - Inc. Doc.",Rec));
    END;

    [Internal]
    PROCEDURE Export@3(DefaultFileName@1003 : Text;ShowFileDialog@1002 : Boolean) : Text;
    VAR
      TempBlob@1001 : Record 99008535;
      FileMgt@1000 : Codeunit 419;
    BEGIN
      IF "Incoming Document Entry No." = 0 THEN
        EXIT;
      CALCFIELDS(Content);
      IF NOT Content.HASVALUE THEN
        EXIT;

      IF DefaultFileName = '' THEN
        DefaultFileName := Name + '.' + "File Extension";

      OnGetBinaryContent(TempBlob);
      IF NOT TempBlob.Blob.HASVALUE THEN
        TempBlob.Blob := Content;
      EXIT(FileMgt.BLOBExport(TempBlob,DefaultFileName,ShowFileDialog));
    END;

    [External]
    PROCEDURE DeleteAttachment@2();
    VAR
      IncomingDocument@1000 : Record 130;
    BEGIN
      TESTFIELD("Incoming Document Entry No.");
      TESTFIELD("Line No.");

      IF Default THEN
        ERROR(DefaultAttachErr);

      IncomingDocument.GET("Incoming Document Entry No.");
      IncomingDocument.TESTFIELD(Posted,FALSE);
      IF CONFIRM(DeleteQst,FALSE) THEN
        DELETE;
    END;

    LOCAL PROCEDURE CheckDefault@12();
    VAR
      IncomingDocumentAttachment@1000 : Record 133;
    BEGIN
      IncomingDocumentAttachment.SETRANGE("Incoming Document Entry No.","Incoming Document Entry No.");
      IncomingDocumentAttachment.SETFILTER("Line No.",'<>%1',"Line No.");
      IncomingDocumentAttachment.SETRANGE(Default,TRUE);
      IF IncomingDocumentAttachment.ISEMPTY THEN BEGIN
        IF NOT Default THEN
          ERROR(DefaultAttachErr);
      END ELSE
        IF Default THEN
          ERROR(DefaultAttachErr);
    END;

    LOCAL PROCEDURE ClearDefaultAttachmentsFromIncomingDocument@17();
    VAR
      IncomingDocumentAttachment@1000 : Record 133;
    BEGIN
      IncomingDocumentAttachment.SETRANGE("Incoming Document Entry No.","Incoming Document Entry No.");
      IncomingDocumentAttachment.SETFILTER("Line No.",'<>%1',"Line No.");
      IncomingDocumentAttachment.MODIFYALL(Default,FALSE);
    END;

    [Internal]
    PROCEDURE SendToOCR@14();
    VAR
      IncomingDocument@1000 : Record 130;
      TempBlob@1001 : Record 99008535;
      OCRServiceMgt@1002 : Codeunit 1294;
    BEGIN
      CALCFIELDS(Content);
      TempBlob.INIT;
      TempBlob."Primary Key" := "Incoming Document Entry No.";
      OnGetBinaryContent(TempBlob);
      IF NOT TempBlob.Blob.HASVALUE THEN
        TempBlob.Blob := Content;

      IF "External Document Reference" = '' THEN
        "External Document Reference" := LOWERCASE(DELCHR(FORMAT(CREATEGUID),'=','{}-'));
      MODIFY;
      IncomingDocument.GET("Incoming Document Entry No.");
      OCRServiceMgt.UploadAttachment(
        TempBlob,
        STRSUBSTNO('%1.%2',Name,"File Extension"),
        "External Document Reference",
        IncomingDocument."OCR Service Doc. Template Code",
        IncomingDocument.RECORDID);
    END;

    [External]
    PROCEDURE GetFullName@4() : Text;
    BEGIN
      EXIT(STRSUBSTNO('%1.%2',Name,"File Extension"));
    END;

    [Integration(TRUE)]
    [External]
    PROCEDURE OnAttachBinaryFile@16();
    BEGIN
    END;

    [Integration(TRUE)]
    [External]
    LOCAL PROCEDURE OnGetBinaryContent@22(VAR TempBlob@1000 : Record 99008535);
    BEGIN
    END;

    LOCAL PROCEDURE FindDataExchType@7();
    BEGIN
      IF Type <> Type::XML THEN
        EXIT;
      COMMIT;
      IF CODEUNIT.RUN(CODEUNIT::"Data Exch. Type Selector",Rec) THEN;
    END;

    LOCAL PROCEDURE UpdateIncomingDocumentHeaderFields@11();
    VAR
      TempBlob@1003 : Record 99008535;
      IncomingDocument@1004 : Record 130;
      XMLDOMManagement@1002 : Codeunit 6224;
      XMLRootNode@1005 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      InStream@1001 : InStream;
    BEGIN
      IF Type <> Type::XML THEN
        EXIT;
      TempBlob.INIT;
      OnGetBinaryContent(TempBlob);
      IF NOT TempBlob.Blob.HASVALUE THEN
        TempBlob.Blob := Content;
      TempBlob.Blob.CREATEINSTREAM(InStream);
      IF NOT XMLDOMManagement.LoadXMLNodeFromInStream(InStream,XMLRootNode) THEN
        EXIT;
      IF NOT IncomingDocument.GET("Incoming Document Entry No.") THEN
        EXIT;
      ExtractHeaderFields(XMLRootNode,IncomingDocument);
    END;

    [Internal]
    PROCEDURE ExtractHeaderFields@5(VAR XMLRootNode@1008 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";VAR IncomingDocument@1003 : Record 130);
    VAR
      TempFieldBuffer@1001 : TEMPORARY Record 8450;
    BEGIN
      AddFieldToFieldBuffer(TempFieldBuffer,IncomingDocument.FIELDNO("Vendor Id"));
      AddFieldToFieldBuffer(TempFieldBuffer,IncomingDocument.FIELDNO("Vendor Name"));
      AddFieldToFieldBuffer(TempFieldBuffer,IncomingDocument.FIELDNO("Vendor Invoice No."));
      AddFieldToFieldBuffer(TempFieldBuffer,IncomingDocument.FIELDNO("Order No."));
      AddFieldToFieldBuffer(TempFieldBuffer,IncomingDocument.FIELDNO("Document Date"));
      AddFieldToFieldBuffer(TempFieldBuffer,IncomingDocument.FIELDNO("Due Date"));
      AddFieldToFieldBuffer(TempFieldBuffer,IncomingDocument.FIELDNO("Amount Excl. VAT"));
      AddFieldToFieldBuffer(TempFieldBuffer,IncomingDocument.FIELDNO("Amount Incl. VAT"));
      AddFieldToFieldBuffer(TempFieldBuffer,IncomingDocument.FIELDNO("VAT Amount"));
      AddFieldToFieldBuffer(TempFieldBuffer,IncomingDocument.FIELDNO("Currency Code"));
      AddFieldToFieldBuffer(TempFieldBuffer,IncomingDocument.FIELDNO("Vendor VAT Registration No."));
      AddFieldToFieldBuffer(TempFieldBuffer,IncomingDocument.FIELDNO("Vendor IBAN"));
      AddFieldToFieldBuffer(TempFieldBuffer,IncomingDocument.FIELDNO("Vendor Bank Branch No."));
      AddFieldToFieldBuffer(TempFieldBuffer,IncomingDocument.FIELDNO("Vendor Bank Account No."));
      AddFieldToFieldBuffer(TempFieldBuffer,IncomingDocument.FIELDNO("Vendor Phone No."));

      OnBeforeExtractHeaderFields(TempFieldBuffer,IncomingDocument);

      TempFieldBuffer.RESET;
      TempFieldBuffer.FINDSET;
      REPEAT
        ExtractHeaderField(XMLRootNode,IncomingDocument,TempFieldBuffer."Field ID");
      UNTIL TempFieldBuffer.NEXT = 0;
    END;

    LOCAL PROCEDURE ExtractHeaderField@27(VAR XMLRootNode@1000 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";VAR IncomingDocument@1007 : Record 130;FieldNo@1006 : Integer);
    VAR
      Field@1001 : Record 2000000041;
      XMLDOMManagement@1004 : Codeunit 6224;
      OCRServiceMgt@1002 : Codeunit 1294;
      ImportXMLFileToDataExch@1005 : Codeunit 1203;
      RecRef@1009 : RecordRef;
      FieldRef@1010 : FieldRef;
      XmlNamespaceManager@1003 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNamespaceManager";
      DateVar@1011 : Date;
      DecimalVar@1012 : Decimal;
      IntegerVar@1013 : Integer;
      GuidVar@1015 : GUID;
      XmlValue@1014 : Text;
      XPath@1008 : Text;
    BEGIN
      IncomingDocument.FIND;
      XPath := IncomingDocument.GetDataExchangePath(FieldNo);
      IF XPath = '' THEN
        EXIT;
      XPath := ImportXMLFileToDataExch.EscapeMissingNamespacePrefix(XPath);
      RecRef.GETTABLE(IncomingDocument);
      FieldRef := RecRef.FIELD(FieldNo);
      Field.INIT;
      XMLDOMManagement.AddNamespaces(XmlNamespaceManager,XMLRootNode.OwnerDocument);
      XmlValue := XMLDOMManagement.FindNodeTextNs(XMLRootNode,XPath,XmlNamespaceManager);

      CASE FORMAT(FieldRef.TYPE) OF
        FORMAT(Field.Type::Text),FORMAT(Field.Type::Code):
          FieldRef.VALUE := COPYSTR(XmlValue,1,FieldRef.LENGTH);
        FORMAT(Field.Type::Date):
          IF EVALUATE(DateVar,XmlValue,9) THEN
            FieldRef.VALUE := DateVar
          ELSE
            IF EVALUATE(DateVar,OCRServiceMgt.DateConvertYYYYMMDD2XML(XmlValue),9) THEN
              FieldRef.VALUE := DateVar;
        FORMAT(Field.Type::Integer):
          IF EVALUATE(IntegerVar,XmlValue,9) THEN
            FieldRef.VALUE := IntegerVar;
        FORMAT(Field.Type::Decimal):
          IF EVALUATE(DecimalVar,XmlValue,9) THEN
            FieldRef.VALUE := DecimalVar;
        FORMAT(Field.Type::GUID):
          IF EVALUATE(GuidVar,XmlValue,9) THEN
            FieldRef.VALUE := GuidVar;
      END;
      RecRef.SETTABLE(IncomingDocument);
      IncomingDocument.MODIFY;
    END;

    LOCAL PROCEDURE CheckMainAttachment@20();
    VAR
      IncomingDocumentAttachment@1000 : Record 133;
      MoreThanOneMainAttachmentExist@1001 : Boolean;
      NoMainAttachmentExist@1002 : Boolean;
    BEGIN
      IncomingDocumentAttachment.SETRANGE("Incoming Document Entry No.","Incoming Document Entry No.");
      IncomingDocumentAttachment.SETFILTER("Line No.",'<>%1',"Line No.");
      IncomingDocumentAttachment.SETRANGE("Main Attachment",TRUE);

      MoreThanOneMainAttachmentExist := "Main Attachment" AND (NOT IncomingDocumentAttachment.ISEMPTY);
      NoMainAttachmentExist := (NOT "Main Attachment") AND IncomingDocumentAttachment.ISEMPTY;

      IF MoreThanOneMainAttachmentExist OR NoMainAttachmentExist THEN
        ERROR(MainAttachErr);
    END;

    LOCAL PROCEDURE SetFirstAttachmentAsDefault@18();
    VAR
      IncomingDocumentAttachment@1000 : Record 133;
    BEGIN
      IF NOT Default THEN BEGIN
        IncomingDocumentAttachment.SETRANGE("Incoming Document Entry No.","Incoming Document Entry No.");
        IncomingDocumentAttachment.SETRANGE(Default,TRUE);
        IF IncomingDocumentAttachment.ISEMPTY THEN
          VALIDATE(Default,TRUE);
      END;
    END;

    LOCAL PROCEDURE SetFirstAttachmentAsMain@19();
    VAR
      IncomingDocumentAttachment@1000 : Record 133;
    BEGIN
      IF NOT "Main Attachment" THEN BEGIN
        IncomingDocumentAttachment.SETRANGE("Incoming Document Entry No.","Incoming Document Entry No.");
        IncomingDocumentAttachment.SETRANGE("Main Attachment",TRUE);
        IF IncomingDocumentAttachment.ISEMPTY THEN
          VALIDATE("Main Attachment",TRUE);
      END;
    END;

    [External]
    PROCEDURE SetFiltersFromMainRecord@21(VAR MainRecordRef@1009 : RecordRef;VAR IncomingDocumentAttachment@1000 : Record 133);
    VAR
      SalesHeader@1001 : Record 36;
      PurchaseHeader@1002 : Record 38;
      GenJournalLine@1003 : Record 81;
      PurchInvHeader@1008 : Record 122;
      DataTypeManagement@1005 : Codeunit 701;
      DocumentNoFieldRef@1004 : FieldRef;
      PostingDateFieldRef@1006 : FieldRef;
      LineNoFieldRef@1011 : FieldRef;
      PostingDate@1007 : Date;
    BEGIN
      CASE MainRecordRef.NUMBER OF
        DATABASE::"Incoming Document":
          EXIT;
        DATABASE::"Sales Header":
          BEGIN
            MainRecordRef.SETTABLE(SalesHeader);
            IncomingDocumentAttachment.SETRANGE("Document Table No. Filter",MainRecordRef.NUMBER);
            IncomingDocumentAttachment.SETRANGE("Document Type Filter",SalesHeader."Document Type");
            IncomingDocumentAttachment.SETRANGE("Document No. Filter",SalesHeader."No.");
          END;
        DATABASE::"Purchase Header":
          BEGIN
            MainRecordRef.SETTABLE(PurchaseHeader);
            IncomingDocumentAttachment.SETRANGE("Document Table No. Filter",MainRecordRef.NUMBER);
            IncomingDocumentAttachment.SETRANGE("Document Type Filter",PurchaseHeader."Document Type");
            IncomingDocumentAttachment.SETRANGE("Document No. Filter",PurchaseHeader."No.");
          END;
        DATABASE::"Gen. Journal Line":
          BEGIN
            MainRecordRef.SETTABLE(GenJournalLine);
            IF NOT MainRecordRef.GET(MainRecordRef.RECORDID) THEN
              IF DataTypeManagement.FindFieldByName(
                   MainRecordRef,LineNoFieldRef,IncomingDocumentAttachment.FIELDNAME("Line No."))
              THEN BEGIN
                LineNoFieldRef.VALIDATE(GetGenJnlLineNextLineNo(GenJournalLine));
                MainRecordRef.INSERT(TRUE);
                COMMIT;
                MainRecordRef.SETTABLE(GenJournalLine);
              END;
            IncomingDocumentAttachment.SETRANGE("Document Table No. Filter",MainRecordRef.NUMBER);
            IncomingDocumentAttachment.SETRANGE("Journal Template Name Filter",GenJournalLine."Journal Template Name");
            IncomingDocumentAttachment.SETRANGE("Journal Batch Name Filter",GenJournalLine."Journal Batch Name");
            IncomingDocumentAttachment.SETRANGE("Journal Line No. Filter",GenJournalLine."Line No.");
          END;
        ELSE BEGIN
          IF NOT DataTypeManagement.FindFieldByName(MainRecordRef,DocumentNoFieldRef,GenJournalLine.FIELDNAME("Document No.")) THEN
            IF NOT DataTypeManagement.FindFieldByName(MainRecordRef,DocumentNoFieldRef,PurchInvHeader.FIELDNAME("No.")) THEN
              EXIT;
          IF NOT DataTypeManagement.FindFieldByName(MainRecordRef,PostingDateFieldRef,GenJournalLine.FIELDNAME("Posting Date")) THEN
            EXIT;
          IncomingDocumentAttachment.SETRANGE("Document No.",FORMAT(DocumentNoFieldRef.VALUE));
          EVALUATE(PostingDate,FORMAT(PostingDateFieldRef.VALUE));
          IncomingDocumentAttachment.SETRANGE("Posting Date",PostingDate);
        END;
      END;
    END;

    LOCAL PROCEDURE GetGenJnlLineNextLineNo@24(GenJournalLine@1000 : Record 81) : Integer;
    VAR
      LastGenJournalLine@1001 : Record 81;
    BEGIN
      LastGenJournalLine.SETFILTER("Journal Template Name",GenJournalLine."Journal Template Name");
      LastGenJournalLine.SETFILTER("Journal Batch Name",GenJournalLine."Journal Batch Name");
      IF LastGenJournalLine.FINDLAST THEN
        EXIT(LastGenJournalLine."Line No." + LineIncrement);
      EXIT(LineIncrement);
    END;

    LOCAL PROCEDURE LineIncrement@23() : Integer;
    BEGIN
      EXIT(10000);
    END;

    [External]
    PROCEDURE AddFieldToFieldBuffer@28(VAR TempFieldBuffer@1000 : TEMPORARY Record 8450;FieldID@1001 : Integer);
    BEGIN
      TempFieldBuffer.INIT;
      TempFieldBuffer.Order += 1;
      TempFieldBuffer."Table ID" := DATABASE::"Incoming Document";
      TempFieldBuffer."Field ID" := FieldID;
      TempFieldBuffer.INSERT;
    END;

    [Integration]
    PROCEDURE OnBeforeExtractHeaderFields@30(VAR TempFieldBuffer@1000 : TEMPORARY Record 8450;VAR IncomingDocument@1001 : Record 130);
    BEGIN
    END;

    BEGIN
    END.
  }
}

