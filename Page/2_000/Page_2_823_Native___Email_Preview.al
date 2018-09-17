OBJECT Page 2823 Native - Email Preview
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[@@@={Locked};
               DAN=nativeInvoicingEmailPreview;
               ENU=nativeInvoicingEmailPreview];
    InsertAllowed=No;
    DeleteAllowed=No;
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
                   IF NOT IsGenerated THEN BEGIN
                     FilterView := GETVIEW;
                     DocumentIdFilter := GETFILTER("Document Id");
                     IF DocumentIdFilter = '' THEN
                       DocumentIdFilter := GETFILTER(Id);
                     SETVIEW(FilterView);
                     DocumentId := GetDocumentId(DocumentIdFilter);
                     IF ISNULLGUID(DocumentId) THEN
                       EXIT(FALSE);
                     GeneratePreview(DocumentId);
                     IsGenerated := TRUE;
                   END;
                   EXIT(TRUE);
                 END;

    OnModifyRecord=VAR
                     O365SalesEmailManagement@1001 : Codeunit 2151;
                   BEGIN
                     IF xRec."Document Id" <> "Document Id" THEN
                       ERROR(CannotChangeDocumentIdErr);

                     O365SalesEmailManagement.SaveEmailParametersIfChanged(
                       DocumentNo,ReportId,PrevEmail,Email,xRec."File Name",Subject);
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
                Name=email;
                CaptionML=[@@@={Locked};
                           DAN=email;
                           ENU=email];
                ToolTipML=[DAN=Angiver mailadressen.;
                           ENU=Specifies email address.];
                ApplicationArea=#All;
                SourceExpr=Email;
                OnValidate=VAR
                             MailManagement@1000 : Codeunit 9520;
                           BEGIN
                             IF Email = '' THEN
                               ERROR(EmptyEmailAddressErr);
                             IF Email = PrevEmail THEN
                               EXIT;
                             MailManagement.ValidateEmailAddressField(Email);
                           END;
                            }

    { 8   ;2   ;Field     ;
                Name=cc;
                CaptionML=[DAN=cc;
                           ENU=cc];
                ToolTipML=[DAN=Angiver cc-adresser.;
                           ENU=Specifies CC addresses.];
                ApplicationArea=#All;
                SourceExpr=CcJson;
                Editable=FALSE;
                OnValidate=BEGIN
                             ERROR(NotEditableCcErr);
                           END;

                ODataEDMType=Collection(Edm.String) }

    { 9   ;2   ;Field     ;
                Name=bcc;
                CaptionML=[DAN=bcc;
                           ENU=bcc];
                ToolTipML=[DAN=Angiver bcc-adresser.;
                           ENU=Specifies BCC addresses.];
                ApplicationArea=#All;
                SourceExpr=BccJson;
                Editable=FALSE;
                OnValidate=BEGIN
                             ERROR(NotEditableBccErr);
                           END;

                ODataEDMType=Collection(Edm.String) }

    { 2   ;2   ;Field     ;
                Name=subject;
                CaptionML=[DAN=emne;
                           ENU=subject];
                ToolTipML=[DAN=Angiver mailens emne.;
                           ENU=Specifies e-mail subject.];
                ApplicationArea=#All;
                SourceExpr=Subject;
                OnValidate=BEGIN
                             IF Subject = '' THEN
                               ERROR(EmptyEmailSubjectErr);
                           END;
                            }

    { 3   ;2   ;Field     ;
                Name=body;
                CaptionML=[DAN=tekst;
                           ENU=body];
                ToolTipML=[DAN=Angiver mailens tekst.;
                           ENU=Specifies e-mail body.];
                ApplicationArea=#All;
                SourceExpr=Content;
                Editable=FALSE }

  }
  CODE
  {
    VAR
      CannotChangeDocumentIdErr@1011 : TextConst 'DAN=documentId kan ikke ëndres.;ENU=The documentId cannot be changed.';
      CannotFindDocumentErr@1006 : TextConst '@@@=%1 - Error Message;DAN=Dokumentet %1 blev ikke fundet.;ENU=The Document %1 cannot be found.';
      CannotOpenFileErr@1005 : TextConst '@@@=%1 - Error Message;DAN=èbning af filen mislykkedes pÜ grund af fõlgende fejl: \%1.;ENU=Opening the file failed because of the following error: \%1.';
      DocumentIDNotSpecifiedErr@1010 : TextConst 'DAN=Du skal angive et dokument-id.;ENU=You must specify a document ID.';
      DocumentDoesNotExistErr@1009 : TextConst 'DAN=Der findes intet dokument med det angivne id.;ENU=No document with the specified ID exists.';
      NativeAPILanguageHandler@1025 : Codeunit 2850;
      IsGenerated@1002 : Boolean;
      PrevEmail@1023 : Text[250];
      Email@1004 : Text[250];
      CancelledDocumentErr@1000 : TextConst 'DAN=Dokumentet er blevet annulleret.;ENU=The document has been cancelled.';
      CcJson@1015 : Text;
      BccJson@1016 : Text;
      Subject@1007 : Text[250];
      EmptyEmailAddressErr@1022 : TextConst 'DAN=Mailadressen mÜ ikke vëre tom.;ENU=The email address cannot be empty.';
      EmptyEmailSubjectErr@1012 : TextConst 'DAN=Mailemnet mÜ ikke vëre tomt.;ENU=The email subject cannot be empty.';
      DocumentNo@1013 : Code[20];
      CustomerNo@1024 : Code[20];
      ReportId@1014 : Integer;
      NotEditableCcErr@1001 : TextConst 'DAN=Feltet Cc er skrivebeskyttet.;ENU=The cc is read only.';
      NotEditableBccErr@1003 : TextConst 'DAN=Feltet Bcc er skrivebeskyttet.;ENU=The bcc is read only.';
      MetaViewportStartTxt@1021 : TextConst '@@@={Locked};DAN="<meta name=""viewport""";ENU="<meta name=""viewport"""';
      MetaViewportFullTxt@1008 : TextConst '@@@={Locked};DAN="<meta name=""viewport"" content=""initial-scale=1.0"" />";ENU="<meta name=""viewport"" content=""initial-scale=1.0"" />"';
      HtmlTagTxt@1019 : TextConst '@@@={Locked};DAN=html;ENU=html';
      HeadTagTxt@1020 : TextConst '@@@={Locked};DAN=head;ENU=head';
      StartTagTxt@1017 : TextConst '@@@={Locked};DAN=<;ENU=<';
      EndTagTxt@1018 : TextConst '@@@={Locked};DAN=>;ENU=>';

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
        ERROR(DocumentIDNotSpecifiedErr);

      SalesHeader.SETFILTER(Id,DocumentIdFilter);
      IF SalesHeader.FINDFIRST THEN
        DocumentRecordRef.GETTABLE(SalesHeader)
      ELSE BEGIN
        SalesInvoiceHeader.SETFILTER(Id,DocumentIdFilter);
        IF SalesInvoiceHeader.FINDFIRST THEN BEGIN
          DocumentRecordRef.GETTABLE(SalesInvoiceHeader);
          SalesInvoiceHeader.CALCFIELDS(Cancelled);
          IF SalesInvoiceHeader.Cancelled THEN
            ERROR(CancelledDocumentErr);
        END ELSE
          ERROR(DocumentDoesNotExistErr);
      END;

      DataTypeManagement.FindFieldByName(DocumentRecordRef,DocumentIdFieldRef,SalesHeader.FIELDNAME(Id));
      EVALUATE(DocumentId,FORMAT(DocumentIdFieldRef.VALUE));

      EXIT(DocumentId);
    END;

    LOCAL PROCEDURE GeneratePreview@21(DocumentId@1009 : GUID);
    VAR
      GraphIntBusinessProfile@1001 : Codeunit 5442;
      Body@1000 : Text;
    BEGIN
      GraphIntBusinessProfile.SyncFromGraphSynchronously;

      GetEmailParameters(DocumentId,DocumentNo,CustomerNo,ReportId,Email,CcJson,BccJson,Subject,Body);
      PrevEmail := Email;
      FillRecord(DocumentId,Subject,Body);
    END;

    LOCAL PROCEDURE FillRecord@17(DocumentId@1010 : GUID;Subject@1003 : Text[250];Body@1002 : Text);
    BEGIN
      INIT;
      Id := DocumentId;
      "Document Id" := DocumentId;
      "File Name" := Subject;
      Type := Type::Email;
      SetTextContent(Body);
      INSERT(TRUE);
    END;

    LOCAL PROCEDURE GetEmailParameters@1(DocumentId@1009 : GUID;VAR DocumentNo@1019 : Code[20];VAR CustomerNo@1003 : Code[20];VAR ReportId@1018 : Integer;VAR EmailAddress@1011 : Text[250];VAR EmailCcJson@1024 : Text;VAR EmailBccJson@1020 : Text;VAR EmailSubject@1004 : Text[250];VAR EmailBody@1010 : Text);
    VAR
      SalesInvoiceHeader@1002 : Record 112;
      SalesHeader@1006 : Record 36;
      ReportSelections@1005 : Record 77;
      O365EmailSetup@1021 : Record 2118;
      DocumentMailing@1015 : Codeunit 260;
      NativeReports@1013 : Codeunit 2822;
      RecordVariant@1000 : Variant;
      FilePath@1001 : Text[250];
      DocumentName@1016 : Text[250];
    BEGIN
      SalesHeader.SETRANGE(Id,DocumentId);
      IF SalesHeader.FINDFIRST THEN
        CASE SalesHeader."Document Type" OF
          SalesHeader."Document Type"::Invoice:
            BEGIN
              RecordVariant := SalesHeader;
              DocumentName := SalesHeader.GetDocTypeTxt;
              DocumentNo := SalesHeader."No.";
              CustomerNo := SalesHeader."Sell-to Customer No.";
              ReportId := NativeReports.DraftSalesInvoiceReportId;
            END;
          SalesHeader."Document Type"::Quote:
            BEGIN
              RecordVariant := SalesHeader;
              DocumentName := SalesHeader.GetDocTypeTxt;
              DocumentNo := SalesHeader."No.";
              CustomerNo := SalesHeader."Sell-to Customer No.";
              ReportId := NativeReports.SalesQuoteReportId;
            END;
          ELSE
            ERROR(CannotFindDocumentErr,DocumentId);
        END
      ELSE BEGIN
        SalesInvoiceHeader.SETRANGE(Id,DocumentId);
        IF NOT SalesInvoiceHeader.FINDFIRST THEN
          ERROR(CannotFindDocumentErr,DocumentId);
        DocumentName := SalesInvoiceHeader.GetDefaultEmailDocumentName;
        RecordVariant := SalesInvoiceHeader;
        DocumentNo := SalesInvoiceHeader."No.";
        CustomerNo := SalesInvoiceHeader."Sell-to Customer No.";
        ReportId := NativeReports.PostedSalesInvoiceReportId;
      END;

      IF ReportSelections.GetEmailBody(FilePath,ReportId,RecordVariant,CustomerNo,EmailAddress) THEN
        EmailBody := GetEmailBody(FilePath);

      EmailSubject := DocumentMailing.GetEmailSubject(DocumentNo,DocumentName,ReportId);
      EmailCcJson := GetEmailsJSON(O365EmailSetup,O365EmailSetup.RecipientType::CC);
      EmailBccJson := GetEmailsJSON(O365EmailSetup,O365EmailSetup.RecipientType::BCC);
    END;

    PROCEDURE GetEmailsJSON@16(VAR O365EmailSetup@1000 : Record 2118;RecipientType@1001 : 'CC,BCC') : Text;
    VAR
      JSONManagement@1003 : Codeunit 5459;
      JsonArray@1005 : DotNet "'Newtonsoft.Json, Version=9.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed'.Newtonsoft.Json.Linq.JArray";
    BEGIN
      JSONManagement.InitializeEmptyCollection;
      JSONManagement.GetJsonArray(JsonArray);

      O365EmailSetup.SETRANGE(RecipientType,RecipientType);
      IF O365EmailSetup.FINDSET THEN
        REPEAT
          JsonArray.Add(O365EmailSetup.Email)
        UNTIL O365EmailSetup.NEXT = 0;
      O365EmailSetup.RESET;

      EXIT(JSONManagement.WriteCollectionToString);
    END;

    LOCAL PROCEDURE GetEmailBody@4(FilePath@1000 : Text[250]) : Text;
    VAR
      File@1001 : File;
      InStream@1002 : InStream;
      EmailBody@1005 : Text;
      Buffer@1003 : Text;
    BEGIN
      IF NOT File.OPEN(FilePath,TEXTENCODING::UTF8) THEN
        ERROR(CannotOpenFileErr,GETLASTERRORTEXT);
      File.CREATEINSTREAM(InStream);
      WHILE NOT InStream.EOS DO BEGIN
        InStream.READ(Buffer);
        EmailBody += Buffer;
      END;
      File.CLOSE;
      IF ERASE(FilePath) THEN;

      InjectMetaViewport(EmailBody);

      EXIT(EmailBody);
    END;

    LOCAL PROCEDURE InjectMetaViewport@2(VAR EmailBody@1000 : Text);
    VAR
      BodyStart@1004 : Text[1000];
      PosHtml@1005 : Integer;
      PosHead@1006 : Integer;
      PosMeta@1003 : Integer;
      PosTagBeforeMeta@1001 : Integer;
      BodyStartLength@1002 : Integer;
      MaxBodyStartLength@1007 : Integer;
    BEGIN
      BodyStartLength := STRLEN(EmailBody);
      MaxBodyStartLength := MAXSTRLEN(BodyStart);
      IF BodyStartLength > MaxBodyStartLength THEN
        BodyStartLength := MaxBodyStartLength;
      BodyStart := LOWERCASE(COPYSTR(EmailBody,1,BodyStartLength));
      IF STRPOS(BodyStart,MetaViewportStartTxt) > 0 THEN
        EXIT;

      PosHtml := STRPOS(BodyStart,StartTagTxt + HtmlTagTxt);
      IF PosHtml = 0 THEN
        EXIT;

      PosHead := STRPOS(BodyStart,StartTagTxt + HeadTagTxt);
      IF PosHead > 0 THEN
        PosTagBeforeMeta := PosHead
      ELSE
        PosTagBeforeMeta := PosHtml;

      PosMeta := PosTagBeforeMeta + STRPOS(COPYSTR(BodyStart,PosTagBeforeMeta + 1),EndTagTxt);
      IF PosMeta > 0 THEN
        EmailBody := COPYSTR(EmailBody,PosHtml,PosMeta - PosHtml + 1) + MetaViewportFullTxt + COPYSTR(EmailBody,PosMeta + 1);
    END;

    BEGIN
    END.
  }
}

