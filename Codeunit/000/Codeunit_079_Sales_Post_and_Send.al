OBJECT Codeunit 79 Sales-Post and Send
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    TableNo=36;
    OnRun=BEGIN
            IF NOT FIND THEN
              ERROR(NothingToPostErr);

            SalesHeader.COPY(Rec);
            Code;
            Rec := SalesHeader;
          END;

  }
  CODE
  {
    VAR
      SalesHeader@1003 : Record 36;
      NotSupportedDocumentTypeErr@1012 : TextConst '@@@="%1=Document Type";DAN=Dokumenttypen %1 underst›ttes ikke.;ENU=Document type %1 is not supported.';
      NothingToPostErr@1000 : TextConst 'DAN=Der er intet at bogf›re.;ENU=There is nothing to post.';

    LOCAL PROCEDURE Code@2();
    VAR
      TempDocumentSendingProfile@1004 : TEMPORARY Record 60;
      SalesPost@1002 : Codeunit 80;
      SalesPostYesNo@1001 : Codeunit 81;
    BEGIN
      WITH SalesHeader DO
        CASE "Document Type" OF
          "Document Type"::Invoice,
          "Document Type"::"Credit Memo",
          "Document Type"::Order:
            IF NOT ConfirmPostAndSend(SalesHeader,TempDocumentSendingProfile) THEN
              EXIT;
          ELSE
            ERROR(STRSUBSTNO(NotSupportedDocumentTypeErr,"Document Type"));
        END;

      TempDocumentSendingProfile.CheckElectronicSendingEnabled;
      ValidateElectronicFormats(TempDocumentSendingProfile);

      IF SalesHeader."Document Type" = SalesHeader."Document Type"::Order THEN BEGIN
        SalesPostYesNo.PostAndSend(SalesHeader);
        IF NOT (SalesHeader.Ship OR SalesHeader.Invoice) THEN
          EXIT;
      END ELSE
        CODEUNIT.RUN(CODEUNIT::"Sales-Post",SalesHeader);

      COMMIT;

      SalesPost.SendPostedDocumentRecord(SalesHeader,TempDocumentSendingProfile);
    END;

    LOCAL PROCEDURE ConfirmPostAndSend@5(SalesHeader@1000 : Record 36;VAR TempDocumentSendingProfile@1001 : TEMPORARY Record 60) : Boolean;
    VAR
      Customer@1004 : Record 18;
      DocumentSendingProfile@1002 : Record 60;
      OfficeMgt@1003 : Codeunit 1630;
    BEGIN
      Customer.GET(SalesHeader."Bill-to Customer No.");
      IF OfficeMgt.IsAvailable THEN
        DocumentSendingProfile.GetOfficeAddinDefault(TempDocumentSendingProfile,OfficeMgt.AttachAvailable)
      ELSE BEGIN
        IF NOT DocumentSendingProfile.GET(Customer."Document Sending Profile") THEN
          DocumentSendingProfile.GetDefault(DocumentSendingProfile);

        COMMIT;
        TempDocumentSendingProfile.COPY(DocumentSendingProfile);
        TempDocumentSendingProfile.SetDocumentUsage(SalesHeader);
        TempDocumentSendingProfile.INSERT;
        IF PAGE.RUNMODAL(PAGE::"Post and Send Confirmation",TempDocumentSendingProfile) <> ACTION::Yes THEN
          EXIT(FALSE);
      END;

      EXIT(TRUE);
    END;

    LOCAL PROCEDURE ValidateElectronicFormats@3(DocumentSendingProfile@1000 : Record 60);
    VAR
      ElectronicDocumentFormat@1001 : Record 61;
    BEGIN
      IF (DocumentSendingProfile."E-Mail" <> DocumentSendingProfile."E-Mail"::No) AND
         (DocumentSendingProfile."E-Mail Attachment" <> DocumentSendingProfile."E-Mail Attachment"::PDF)
      THEN BEGIN
        ElectronicDocumentFormat.ValidateElectronicFormat(DocumentSendingProfile."E-Mail Format");
        ElectronicDocumentFormat.ValidateElectronicSalesDocument(SalesHeader,DocumentSendingProfile."E-Mail Format");
      END;

      IF (DocumentSendingProfile.Disk <> DocumentSendingProfile.Disk::No) AND
         (DocumentSendingProfile.Disk <> DocumentSendingProfile.Disk::PDF)
      THEN BEGIN
        ElectronicDocumentFormat.ValidateElectronicFormat(DocumentSendingProfile."Disk Format");
        ElectronicDocumentFormat.ValidateElectronicSalesDocument(SalesHeader,DocumentSendingProfile."Disk Format");
      END;

      IF DocumentSendingProfile."Electronic Document" <> DocumentSendingProfile."Electronic Document"::No THEN BEGIN
        ElectronicDocumentFormat.ValidateElectronicFormat(DocumentSendingProfile."Electronic Format");
        ElectronicDocumentFormat.ValidateElectronicSalesDocument(SalesHeader,DocumentSendingProfile."Electronic Format");
      END;
    END;

    BEGIN
    END.
  }
}

