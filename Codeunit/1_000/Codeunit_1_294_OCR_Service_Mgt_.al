OBJECT Codeunit 1294 OCR Service Mgt.
{
  OBJECT-PROPERTIES
  {
    Date=28-06-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23019;
  }
  PROPERTIES
  {
    Permissions=TableData 1260=r;
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      MissingCredentialsQst@1000 : TextConst '@@@="%1=error message. %2=OCR Service Setup";DAN=%1\ Vil du �bne %2 for at angive de manglende v�rdier?;ENU=%1\ Do you want to open %2 to specify the missing values?';
      MissingCredentialsErr@1001 : TextConst '@@@="%1 = OCR Service Setup";DAN=Du skal udfylde felterne Brugernavn, Adgangskode og Autorisationsn�gle.;ENU=You must fill the User Name, Password, and Authorization Key fields.';
      OCRServiceSetup@1003 : Record 1270;
      AuthCookie@1002 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Net.Cookie";
      ConnectionSuccessMsg@1006 : TextConst 'DAN=Forbindelsen er oprettet.;ENU=Connection succeeded.';
      ConnectionFailedErr@1005 : TextConst 'DAN=Forbindelsen blev afbrudt. Kontroller, at felterne Brugernavn, Adgangskode og Autorisationsn�gle er udfyldt korrekt.;ENU=The connection failed. Check that the User Name, Password, and Authorization Key fields are filled correctly.';
      NoFileContentErr@1004 : TextConst 'DAN=Filen er tom.;ENU=The file is empty.';
      InitiateUploadMsg@1010 : TextConst 'DAN=Start overf�rsel af bilag.;ENU=Initiate document upload.';
      GetDocumentConfirmMsg@1019 : TextConst 'DAN=Bekr�ft modtagelse af bilag.;ENU=Acknowledge document receipt.';
      DocumentDownloadedTxt@1018 : TextConst '@@@="%1 = Document Identifier (usually a guid)";DAN=Hentet %1;ENU=Downloaded %1';
      UploadFileMsg@1013 : TextConst 'DAN=Send til OCR-tjeneste.;ENU=Send to OCR service.';
      AuthenticateMsg@1015 : TextConst 'DAN=Log p� OCR-tjeneste.;ENU=Log in to OCR service.';
      GetNewDocumentsMsg@1016 : TextConst 'DAN=Hent modtagne OCR-dokumenter.;ENU=Get received OCR documents.';
      GetDocumentMsg@1017 : TextConst 'DAN=Modtag OCR-dokument.;ENU=Receive OCR document.';
      UploadFileFailedMsg@1014 : TextConst '@@@="%1 = Response from OCR service, this will probably be an XML string";DAN=Overf�rsel af dokument mislykkedes. Tjenestefejl: %1;ENU=The document failed to upload. Service Error: %1';
      UploadTotalSuccessMsg@1011 : TextConst '@@@="%1 = Number of documents to be uploaded";DAN=Meddel OCR-tjeneste, at %1 bilag er klar til overf�rsel.;ENU=Notify OCR service that %1 documents are ready for upload.';
      NewDocumentsTotalMsg@1020 : TextConst '@@@="%1 = Number of documents downloaded (e.g. 5)";DAN=Hentede %1 dokumenter;ENU=Downloaded %1 documents';
      ImportSuccessMsg@1007 : TextConst 'DAN=Dokumentet er modtaget.;ENU=The document was successfully received.';
      DocumentNotReadyMsg@1008 : TextConst 'DAN=Dokumentet kan ikke modtages endnu. Pr�v igen om nogle f� minutter.;ENU=The document cannot be received yet. Try again in a few moments.';
      NotUploadedErr@1009 : TextConst 'DAN=Du skal overf�re billedet f�rst.;ENU=You must upload the image first.';
      NotValidDocIDErr@1110 : TextConst '@@@=%1 is the value.;DAN=Det modtagne dokument-id %1 indeholder ugyldige tegn.;ENU=Received document ID %1 contains invalid characters.';
      LoggingConstTxt@1012 : TextConst 'DAN=OCR-tjeneste;ENU=OCR Service';
      UploadSuccessMsg@1021 : TextConst 'DAN=Dokumentet blev sendt til OCR-tjenesten.;ENU=The document was successfully sent to the OCR service.';
      NoOCRDataCorrectionMsg@1022 : TextConst 'DAN=Der er ikke foretaget nogen korrektion af OCR-data.;ENU=You have made no OCR data corrections.';
      VerifyMsg@1023 : TextConst 'DAN=Dokumentet venter p� din manuelle godkendelse p� OCR-tjenestens websted.\\V�lg linket Afventer verificering i feltet OCR-status.;ENU=The document is awaiting your manual verification on the OCR service site.\\Choose the Awaiting Verification link in the OCR Status field.';
      FailedMsg@1024 : TextConst 'DAN=Bilaget kunne ikke behandles.;ENU=The document failed to be processed.';
      MethodGetTok@1038 : TextConst '@@@={Locked};DAN=GET;ENU=GET';
      MethodPutTok@1037 : TextConst '@@@={Locked};DAN=PUT;ENU=PUT';
      MethodPostTok@1039 : TextConst '@@@={Locked};DAN=POST;ENU=POST';
      MethodDeleteTok@1040 : TextConst '@@@={Locked};DAN=DELETE;ENU=DELETE';

    [External]
    PROCEDURE SetURLsToDefaultRSO@2(VAR OCRServiceSetup@1000 : Record 1270);
    BEGIN
      OCRServiceSetup."Sign-up URL" := 'https://store.readsoftonline.com/nav';
      OCRServiceSetup."Service URL" := 'https://services.readsoftonline.com';
      OCRServiceSetup."Sign-in URL" := 'https://nav.readsoftonline.com';
    END;

    [External]
    PROCEDURE CheckCredentials@4();
    VAR
      OCRServiceSetup@1000 : Record 1270;
    BEGIN
      WITH OCRServiceSetup DO BEGIN
        IF NOT HasCredentials(OCRServiceSetup) THEN
          IF CONFIRM(STRSUBSTNO(GetCredentialsQstText),TRUE) THEN BEGIN
            COMMIT;
            PAGE.RUNMODAL(PAGE::"OCR Service Setup",OCRServiceSetup);
          END;

        IF NOT HasCredentials(OCRServiceSetup) THEN
          ERROR(GetCredentialsErrText);
      END;
    END;

    LOCAL PROCEDURE HasCredentials@34(OCRServiceSetup@1000 : Record 1270) : Boolean;
    BEGIN
      WITH OCRServiceSetup DO
        EXIT(
          GET AND
          HasPassword("Password Key") AND
          HasPassword("Authorization Key") AND
          ("User Name" <> ''));
    END;

    [External]
    PROCEDURE GetCredentialsErrText@3() : Text;
    BEGIN
      EXIT(MissingCredentialsErr);
    END;

    [External]
    PROCEDURE GetCredentialsQstText@8() : Text;
    VAR
      OCRServiceSetup@1000 : Record 1270;
    BEGIN
      EXIT(STRSUBSTNO(MissingCredentialsQst,GetCredentialsErrText,OCRServiceSetup.TABLECAPTION));
    END;

    [Internal]
    PROCEDURE Authenticate@5() : Boolean;
    VAR
      AuthenticationSucceeded@1000 : Boolean;
    BEGIN
      IF NOT TryAuthenticate(AuthenticationSucceeded) THEN
        EXIT(FALSE);

      IF NOT AuthenticationSucceeded THEN
        LogActivityFailed(OCRServiceSetup.RECORDID,AuthenticateMsg,ConnectionFailedErr)
      ELSE
        LogActivitySucceeded(OCRServiceSetup.RECORDID,AuthenticateMsg,'');

      EXIT(TRUE);
    END;

    [TryFunction]
    LOCAL PROCEDURE TryAuthenticate@27(VAR AuthenticationSucceeded@1006 : Boolean);
    VAR
      TempBlob@1003 : Record 99008535;
      HttpWebRequestMgt@1000 : Codeunit 1297;
      HttpStatusCode@1004 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Net.HttpStatusCode";
      ResponseHeaders@1005 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.Specialized.NameValueCollection";
      InStr@1002 : InStream;
      ResponseString@1007 : Text;
      ResponseReceived@1001 : Boolean;
    BEGIN
      GetOcrServiceSetup(FALSE);
      HttpWebRequestMgt.Initialize(STRSUBSTNO('%1/authentication/rest/authenticate',OCRServiceSetup."Service URL"));
      HttpWebRequestMgt.DisableUI;
      RsoAddHeaders(HttpWebRequestMgt);
      HttpWebRequestMgt.SetMethod(MethodPostTok);
      HttpWebRequestMgt.AddBodyAsText(
        STRSUBSTNO(
          '<AuthenticationCredentials><UserName>%1</UserName><Password>%2</Password>' +
          '<AuthenticationType>SetCookie</AuthenticationType></AuthenticationCredentials>',
          OCRServiceSetup."User Name",OCRServiceSetup.GetPassword(OCRServiceSetup."Password Key")));
      TempBlob.INIT;
      TempBlob.Blob.CREATEINSTREAM(InStr);
      ResponseReceived := HttpWebRequestMgt.GetResponse(InStr,HttpStatusCode,ResponseHeaders);

      IF ResponseReceived THEN BEGIN
        InStr.READTEXT(ResponseString);
        AuthenticationSucceeded := STRPOS(ResponseString,'<Status>Success</Status>') >= 1;
      END;

      IF AuthenticationSucceeded THEN
        HttpWebRequestMgt.GetCookie(AuthCookie);
    END;

    [Internal]
    PROCEDURE UpdateOrganizationInfo@16(VAR OCRServiceSetup@1001 : Record 1270);
    VAR
      XMLDOMManagement@1008 : Codeunit 6224;
      XMLRootNode@1014 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      XMLNode@1010 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      ResponseStr@1000 : InStream;
    BEGIN
      IF NOT RsoGetRequest('accounts/rest/currentcustomer',ResponseStr) THEN
        ERROR(GETLASTERRORTEXT);
      XMLDOMManagement.LoadXMLNodeFromInStream(ResponseStr,XMLRootNode);
      IF XMLDOMManagement.FindNode(XMLRootNode,'Id',XMLNode) THEN
        OCRServiceSetup."Customer ID" := COPYSTR(XMLNode.InnerText,1,MAXSTRLEN(OCRServiceSetup."Customer ID"));
      IF XMLDOMManagement.FindNode(XMLRootNode,'Name',XMLNode) THEN
        OCRServiceSetup."Customer Name" := COPYSTR(XMLNode.InnerText,1,MAXSTRLEN(OCRServiceSetup."Customer Name"));
      IF XMLDOMManagement.FindNode(XMLRootNode,'ActivationStatus',XMLNode) THEN
        OCRServiceSetup."Customer Status" := COPYSTR(XMLNode.InnerText,1,MAXSTRLEN(OCRServiceSetup."Customer Status"));
      RsoGetRequest('users/rest/currentuser',ResponseStr);
      XMLDOMManagement.LoadXMLNodeFromInStream(ResponseStr,XMLRootNode);

      IF XMLDOMManagement.FindNode(XMLRootNode,'OrganizationId',XMLNode) THEN
        OCRServiceSetup."Organization ID" := COPYSTR(XMLNode.InnerText,1,MAXSTRLEN(OCRServiceSetup."Organization ID"));
      OCRServiceSetup.MODIFY;
    END;

    [Internal]
    PROCEDURE UpdateOcrDocumentTemplates@9();
    VAR
      OCRServiceDocumentTemplate@1003 : Record 1271;
      XMLDOMManagement@1002 : Codeunit 6224;
      XMLRootNode@1001 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      XMLNode@1000 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      XMLNode2@1004 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      ResponseStr@1005 : InStream;
    BEGIN
      GetOcrServiceSetup(FALSE);
      OCRServiceSetup.TESTFIELD("Organization ID");

      RsoGetRequest(STRSUBSTNO('accounts/rest/customers/%1/userconfiguration',OCRServiceSetup."Organization ID"),ResponseStr);
      XMLDOMManagement.LoadXMLNodeFromInStream(ResponseStr,XMLRootNode);

      OCRServiceDocumentTemplate.LOCKTABLE;
      OCRServiceDocumentTemplate.DELETEALL;
      FOREACH XMLNode IN XMLRootNode.SelectNodes('AvailableDocumentTypes/UserConfigurationDocumentType') DO BEGIN
        OCRServiceDocumentTemplate.INIT;
        XMLNode2 := XMLNode.SelectSingleNode('SystemName');
        OCRServiceDocumentTemplate.Code := COPYSTR(XMLNode2.InnerText,1,MAXSTRLEN(OCRServiceDocumentTemplate.Code));
        XMLNode2 := XMLNode.SelectSingleNode('Name');
        OCRServiceDocumentTemplate.Name := COPYSTR(XMLNode2.InnerText,1,MAXSTRLEN(OCRServiceDocumentTemplate.Name));
        OCRServiceDocumentTemplate.INSERT;
      END;
    END;

    [Internal]
    PROCEDURE RsoGetRequest@13(PathQuery@1015 : Text;VAR ResponseStr@1000 : InStream) : Boolean;
    BEGIN
      EXIT(RsoRequest(PathQuery,MethodGetTok,'',ResponseStr));
    END;

    [TryFunction]
    [Internal]
    PROCEDURE RsoGetRequestBinary@26(PathQuery@1015 : Text;VAR ResponseStr@1000 : InStream;VAR ContentType@1005 : Text);
    VAR
      HttpWebRequestMgt@1001 : Codeunit 1297;
      HttpStatusCode@1003 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Net.HttpStatusCode";
      ResponseHeaders@1002 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.Specialized.NameValueCollection";
    BEGIN
      GetOcrServiceSetup(TRUE);

      HttpWebRequestMgt.Initialize(STRSUBSTNO('%1/%2',OCRServiceSetup."Service URL",PathQuery));
      HttpWebRequestMgt.DisableUI;
      RsoAddCookie(HttpWebRequestMgt);
      RsoAddHeaders(HttpWebRequestMgt);
      HttpWebRequestMgt.SetMethod(MethodGetTok);
      HttpWebRequestMgt.CreateInstream(ResponseStr);
      HttpWebRequestMgt.GetResponse(ResponseStr,HttpStatusCode,ResponseHeaders);
      ContentType := ResponseHeaders.Item('Content-Type');
    END;

    [Internal]
    PROCEDURE RsoPutRequest@10(PathQuery@1015 : Text;Data@1001 : Text;VAR ResponseStr@1000 : InStream) : Boolean;
    BEGIN
      EXIT(RsoRequest(PathQuery,MethodPutTok,Data,ResponseStr));
    END;

    [Internal]
    PROCEDURE RsoPostRequest@41(PathQuery@1015 : Text;Data@1000 : Text;VAR ResponseStr@1001 : InStream) : Boolean;
    BEGIN
      EXIT(RsoRequest(PathQuery,MethodPostTok,Data,ResponseStr));
    END;

    [Internal]
    PROCEDURE RsoDeleteRequest@57(PathQuery@1015 : Text;Data@1000 : Text;VAR ResponseStr@1001 : InStream) : Boolean;
    BEGIN
      EXIT(RsoRequest(PathQuery,MethodDeleteTok,Data,ResponseStr));
    END;

    PROCEDURE RsoRequest@14(PathQuery@1015 : Text;RequestAction@1002 : Code[6];BodyText@1004 : Text;VAR ResponseStr@1003 : InStream) : Boolean;
    VAR
      HttpWebRequestMgt@1000 : Codeunit 1297;
      HttpStatusCode@1005 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Net.HttpStatusCode";
      ResponseHeaders@1006 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.Specialized.NameValueCollection";
    BEGIN
      GetOcrServiceSetup(TRUE);

      HttpWebRequestMgt.Initialize(STRSUBSTNO('%1/%2',OCRServiceSetup."Service URL",PathQuery));
      HttpWebRequestMgt.DisableUI;
      RsoAddCookie(HttpWebRequestMgt);
      RsoAddHeaders(HttpWebRequestMgt);
      HttpWebRequestMgt.SetMethod(RequestAction);
      IF BodyText <> '' THEN
        HttpWebRequestMgt.AddBodyAsText(BodyText);
      HttpWebRequestMgt.CreateInstream(ResponseStr);
      EXIT(HttpWebRequestMgt.GetResponse(ResponseStr,HttpStatusCode,ResponseHeaders));
    END;

    LOCAL PROCEDURE RsoAddHeaders@6(VAR HttpWebRequestMgt@1000 : Codeunit 1297);
    BEGIN
      HttpWebRequestMgt.AddHeader('x-rs-version','2011-10-14');
      HttpWebRequestMgt.AddHeader('x-rs-key',OCRServiceSetup.GetPassword(OCRServiceSetup."Authorization Key"));
      HttpWebRequestMgt.AddHeader('x-rs-culture','en-US');
      HttpWebRequestMgt.AddHeader('x-rs-uiculture','en-US');
    END;

    LOCAL PROCEDURE RsoAddCookie@11(VAR HttpWebRequestMgt@1000 : Codeunit 1297);
    BEGIN
      IF ISNULL(AuthCookie) THEN
        IF NOT Authenticate THEN
          ERROR(GETLASTERRORTEXT);
      IF AuthCookie.Expired THEN
        IF NOT Authenticate THEN
          ERROR(GETLASTERRORTEXT);

      HttpWebRequestMgt.SetCookie(AuthCookie);
    END;

    LOCAL PROCEDURE URLEncode@19(InText@1000 : Text) : Text;
    VAR
      SystemWebHttpUtility@1001 : DotNet "'System.Web, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'.System.Web.HttpUtility";
    BEGIN
      SystemWebHttpUtility := SystemWebHttpUtility.HttpUtility;
      EXIT(SystemWebHttpUtility.UrlEncode(InText));
    END;

    [External]
    PROCEDURE DateConvertYYYYMMDD2XML@25(YYYYMMDD@1000 : Text) : Text;
    BEGIN
      IF STRLEN(YYYYMMDD) <> 8 THEN
        EXIT(YYYYMMDD);
      EXIT(STRSUBSTNO('%1-%2-%3',COPYSTR(YYYYMMDD,1,4),COPYSTR(YYYYMMDD,5,2),COPYSTR(YYYYMMDD,7,2)));
    END;

    [External]
    PROCEDURE DateConvertXML2YYYYMMDD@37(XMLDate@1000 : Text) : Text;
    BEGIN
      EXIT(DELCHR(XMLDate,'=','-'))
    END;

    LOCAL PROCEDURE GetOcrServiceSetup@61(VerifyEnable@1001 : Boolean);
    BEGIN
      GetOcrServiceSetupExtended(OCRServiceSetup,VerifyEnable);
    END;

    PROCEDURE GetOcrServiceSetupExtended@1(VAR OCRServiceSetup@1001 : Record 1270;VerifyEnable@1000 : Boolean);
    BEGIN
      OCRServiceSetup.GET;
      IF OCRServiceSetup."Service URL" <> '' THEN
        EXIT;
      IF VerifyEnable THEN
        OCRServiceSetup.CheckEnabled;
      OCRServiceSetup.TESTFIELD("User Name");
      OCRServiceSetup.TESTFIELD("Service URL");
    END;

    [Internal]
    PROCEDURE StartUpload@18(NumberOfUploads@1000 : Integer) : Boolean;
    VAR
      ResponseStr@1001 : InStream;
      ResponseText@1002 : Text;
    BEGIN
      IF NumberOfUploads < 1 THEN
        EXIT(FALSE);

      // Initialize upload
      RsoGetRequest(STRSUBSTNO('files/rest/requestupload?targetCount=%1',NumberOfUploads),ResponseStr);
      ResponseStr.READTEXT(ResponseText);
      IF ResponseText = '' THEN BEGIN
        LogActivityFailed(OCRServiceSetup.RECORDID,InitiateUploadMsg,'');
        EXIT(FALSE);
      END;

      LogActivitySucceeded(OCRServiceSetup.RECORDID,InitiateUploadMsg,STRSUBSTNO(UploadTotalSuccessMsg,NumberOfUploads));
      EXIT(TRUE);
    END;

    [Internal]
    PROCEDURE UploadImage@17(VAR TempBlob@1008 : Record 99008535;FileName@1010 : Text;ExternalReference@1014 : Text[50];Template@1002 : Code[20];LoggingRecordId@1003 : RecordID) : Boolean;
    VAR
      HttpRequestURL@1000 : Text;
      APIPart@1001 : Text;
    BEGIN
      GetOcrServiceSetup(TRUE);
      APIPart := STRSUBSTNO(
          'files/rest/image2?filename=%1&customerid=&batchexternalid=%2&buyerid=&documenttype=%3&sortingmethod=OneDocumentPerFile',
          URLEncode(FileName),ExternalReference,Template);
      HttpRequestURL := STRSUBSTNO('%1/%2',OCRServiceSetup."Service URL",APIPart);
      EXIT(UploadFile(TempBlob,HttpRequestURL,'*/*','application/octet-stream',LoggingRecordId));
    END;

    [Internal]
    PROCEDURE UploadLearningDocument@36(VAR TempBlob@1008 : Record 99008535;DocumentId@1014 : Text;LoggingRecordId@1002 : RecordID) : Boolean;
    VAR
      HttpRequestURL@1003 : Text;
      APIPart@1000 : Text;
    BEGIN
      GetOcrServiceSetup(TRUE);
      APIPart := STRSUBSTNO('documents/rest/%1/learningdocument',DocumentId);
      HttpRequestURL := STRSUBSTNO('%1/%2',OCRServiceSetup."Service URL",APIPart);
      EXIT(UploadFile(TempBlob,HttpRequestURL,'','',LoggingRecordId));
    END;

    LOCAL PROCEDURE UploadFile@39(VAR TempBlob@1001 : Record 99008535;HttpRequestURL@1002 : Text;HttpRequestReturnType@1003 : Text;HttpRequestContentType@1004 : Text;LoggingRecordId@1000 : RecordID) : Boolean;
    VAR
      HttpWebRequestMgt@1009 : Codeunit 1297;
      OfficeMgt@1010 : Codeunit 1630;
      HttpStatusCode@1008 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Net.HttpStatusCode";
      ResponseHeaders@1007 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.Specialized.NameValueCollection";
      ResponseStr@1006 : InStream;
      ResponseText@1005 : Text;
    BEGIN
      IF NOT TempBlob.Blob.HASVALUE THEN
        LogActivityFailed(LoggingRecordId,UploadFileMsg,NoFileContentErr); // throws error

      GetOcrServiceSetup(TRUE);

      HttpWebRequestMgt.Initialize(HttpRequestURL);
      HttpWebRequestMgt.SetTraceLogEnabled(FALSE); // Activity Log will log for us
      HttpWebRequestMgt.DisableUI;
      RsoAddCookie(HttpWebRequestMgt);
      RsoAddHeaders(HttpWebRequestMgt);
      IF HttpRequestReturnType <> '' THEN
        HttpWebRequestMgt.SetReturnType(HttpRequestReturnType);
      IF HttpRequestContentType <> '' THEN
        HttpWebRequestMgt.SetContentType(HttpRequestContentType);
      HttpWebRequestMgt.SetMethod(MethodPostTok);
      HttpWebRequestMgt.AddBodyBlob(TempBlob);
      HttpWebRequestMgt.CreateInstream(ResponseStr);

      IF NOT HttpWebRequestMgt.GetResponse(ResponseStr,HttpStatusCode,ResponseHeaders) THEN BEGIN
        IF HttpWebRequestMgt.ProcessFaultXMLResponse('','/ServiceError/Message','','') THEN;
        LogActivityFailed(LoggingRecordId,UploadFileMsg,'');
        EXIT(FALSE); // in case error text is empty
      END;

      ResponseStr.READTEXT(ResponseText);

      IF ResponseText = '<BoolValue xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><Value>true</Value></BoolValue>' THEN BEGIN
        LogActivitySucceeded(LoggingRecordId,UploadFileMsg,'');
        IF GUIALLOWED AND (NOT OfficeMgt.IsAvailable) THEN
          MESSAGE(UploadSuccessMsg);
        EXIT(TRUE);
      END;

      LogActivityFailed(LoggingRecordId,UploadFileMsg,STRSUBSTNO(UploadFileFailedMsg,ResponseText));
    END;

    [Internal]
    PROCEDURE UploadAttachment@21(VAR TempBlob@1008 : Record 99008535;FileName@1010 : Text;ExternalReference@1014 : Text[50];Template@1000 : Code[20];RelatedRecordId@1001 : RecordID) : Boolean;
    BEGIN
      IF NOT TempBlob.Blob.HASVALUE THEN
        ERROR(NoFileContentErr);

      IF NOT StartUpload(1) THEN
        EXIT(FALSE);

      EXIT(UploadImage(TempBlob,FileName,ExternalReference,Template,RelatedRecordId));
    END;

    [Internal]
    PROCEDURE UploadCorrectedOCRFile@33(IncomingDocument@1001 : Record 130) : Boolean;
    VAR
      TempBlob@1000 : Record 99008535;
      DocumentId@1002 : Text;
    BEGIN
      IF NOT IncomingDocument."OCR Data Corrected" THEN BEGIN
        MESSAGE(NoOCRDataCorrectionMsg);
        EXIT;
      END;

      DocumentId := GetOCRServiceDocumentReference(IncomingDocument);
      CorrectOCRFile(IncomingDocument,TempBlob);
      IF NOT TempBlob.Blob.HASVALUE THEN
        ERROR(NoFileContentErr);

      IF NOT StartUpload(1) THEN
        EXIT(FALSE);

      EXIT(UploadLearningDocument(TempBlob,DocumentId,IncomingDocument.RECORDID));
    END;

    [Internal]
    PROCEDURE CorrectOCRFile@38(IncomingDocument@1001 : Record 130;VAR TempBlob@1000 : Record 99008535);
    VAR
      OCRFileXMLRootNode@1002 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      OutStream@1003 : OutStream;
    BEGIN
      ValidateUpdatedOCRFields(IncomingDocument);

      GetOriginalOCRXMLRootNode(IncomingDocument,OCRFileXMLRootNode);

      WITH IncomingDocument DO BEGIN
        CorrectOCRFileNode(OCRFileXMLRootNode,IncomingDocument,FIELDNO("Vendor Name"));
        CorrectOCRFileNode(OCRFileXMLRootNode,IncomingDocument,FIELDNO("Vendor Invoice No."));
        CorrectOCRFileNode(OCRFileXMLRootNode,IncomingDocument,FIELDNO("Order No."));
        CorrectOCRFileNode(OCRFileXMLRootNode,IncomingDocument,FIELDNO("Document Date"));
        CorrectOCRFileNode(OCRFileXMLRootNode,IncomingDocument,FIELDNO("Due Date"));
        CorrectOCRFileNode(OCRFileXMLRootNode,IncomingDocument,FIELDNO("Amount Excl. VAT"));
        CorrectOCRFileNode(OCRFileXMLRootNode,IncomingDocument,FIELDNO("Amount Incl. VAT"));
        CorrectOCRFileNode(OCRFileXMLRootNode,IncomingDocument,FIELDNO("VAT Amount"));
        CorrectOCRFileNode(OCRFileXMLRootNode,IncomingDocument,FIELDNO("Currency Code"));
        CorrectOCRFileNode(OCRFileXMLRootNode,IncomingDocument,FIELDNO("Vendor VAT Registration No."));
        CorrectOCRFileNode(OCRFileXMLRootNode,IncomingDocument,FIELDNO("Vendor IBAN"));
        CorrectOCRFileNode(OCRFileXMLRootNode,IncomingDocument,FIELDNO("Vendor Bank Branch No."));
        CorrectOCRFileNode(OCRFileXMLRootNode,IncomingDocument,FIELDNO("Vendor Bank Account No."));
        CorrectOCRFileNode(OCRFileXMLRootNode,IncomingDocument,FIELDNO("Vendor Phone No."));
      END;
      TempBlob.INIT;
      TempBlob.Blob.CREATEOUTSTREAM(OutStream);
      OCRFileXMLRootNode.OwnerDocument.Save(OutStream);
    END;

    [Internal]
    PROCEDURE CorrectOCRFileNode@32(VAR OCRFileXMLRootNode@1000 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";IncomingDocument@1001 : Record 130;FieldNo@1003 : Integer);
    VAR
      XMLDOMManagement@1002 : Codeunit 6224;
      CorrectionXMLNode@1004 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      EmptyCorrectionXMLNode@1010 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      CorrectionXMLNodeParent@1009 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      PositionXMLNode@1008 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      IncomingDocumentRecRef@1005 : RecordRef;
      IncomingDocumentFieldRef@1006 : FieldRef;
      XPath@1014 : Text;
      CorrectionValue@1007 : Text;
      CorrectionNeeded@1011 : Boolean;
      CorrectionValueAsDecimal@1012 : Decimal;
      OriginalValueAsDecimal@1013 : Decimal;
    BEGIN
      IncomingDocumentRecRef.GETTABLE(IncomingDocument);
      XPath := IncomingDocument.GetDataExchangePath(FieldNo);
      IF XPath = '' THEN
        EXIT;
      IF XMLDOMManagement.FindNode(OCRFileXMLRootNode,XPath,CorrectionXMLNode) THEN BEGIN
        IncomingDocumentFieldRef := IncomingDocumentRecRef.FIELD(FieldNo);

        CASE FORMAT(IncomingDocumentFieldRef.TYPE) OF
          'Date':
            BEGIN
              CorrectionValue := DateConvertXML2YYYYMMDD(FORMAT(IncomingDocumentFieldRef.VALUE,0,9));
              CorrectionNeeded := CorrectionXMLNode.InnerText <> CorrectionValue;
            END;
          'Decimal':
            BEGIN
              CorrectionValueAsDecimal := IncomingDocumentFieldRef.VALUE;
              CorrectionValue := FORMAT(IncomingDocumentFieldRef.VALUE,0,9);
              IF EVALUATE(OriginalValueAsDecimal,CorrectionXMLNode.InnerText,9) THEN;
              CorrectionNeeded := OriginalValueAsDecimal <> CorrectionValueAsDecimal;
            END;
          ELSE BEGIN
            CorrectionValue := FORMAT(IncomingDocumentFieldRef.VALUE,0,9);
            CorrectionNeeded := CorrectionXMLNode.InnerText <> CorrectionValue;
          END;
        END;

        IF CorrectionNeeded THEN BEGIN
          IF XMLDOMManagement.FindNode(CorrectionXMLNode,'../Position',PositionXMLNode) THEN
            PositionXMLNode.InnerText := '0, 0, 0, 0';
          IF CorrectionValue = '' THEN BEGIN
            CorrectionXMLNodeParent := CorrectionXMLNode.ParentNode;
            EmptyCorrectionXMLNode := CorrectionXMLNodeParent.OwnerDocument.CreateElement(CorrectionXMLNode.Name);
            CorrectionXMLNodeParent.ReplaceChild(EmptyCorrectionXMLNode,CorrectionXMLNode);
          END ELSE
            CorrectionXMLNode.InnerText := CorrectionValue
        END;
      END;
    END;

    [External]
    PROCEDURE ValidateUpdatedOCRFields@28(IncomingDocument@1000 : Record 130);
    BEGIN
      IncomingDocument.TESTFIELD("Vendor Name");
    END;

    [Internal]
    PROCEDURE GetOriginalOCRXMLRootNode@49(IncomingDocument@1004 : Record 130;VAR OriginalXMLRootNode@1007 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode");
    VAR
      IncomingDocumentAttachment@1000 : Record 133;
      TempBlob@1001 : Record 99008535;
      XMLDOMManagement@1003 : Codeunit 6224;
      InStream@1002 : InStream;
      IncDocAttachmentRecRef@1005 : RecordRef;
      OriginalXMLContentFieldRef@1006 : FieldRef;
    BEGIN
      IncomingDocument.TESTFIELD(Posted,FALSE);
      IncomingDocumentAttachment.SETRANGE("Incoming Document Entry No.",IncomingDocument."Entry No.");
      IncomingDocumentAttachment.SETRANGE("Generated from OCR",TRUE);
      IncomingDocumentAttachment.SETRANGE(Default,TRUE);
      IF NOT IncomingDocumentAttachment.FINDFIRST THEN
        EXIT;
      IncDocAttachmentRecRef.GETTABLE(IncomingDocumentAttachment);
      OriginalXMLContentFieldRef := IncDocAttachmentRecRef.FIELD(IncomingDocumentAttachment.FIELDNO(Content));
      OriginalXMLContentFieldRef.CALCFIELD;

      TempBlob.INIT;
      TempBlob.Blob := OriginalXMLContentFieldRef.VALUE;
      TempBlob.Blob.CREATEINSTREAM(InStream);
      XMLDOMManagement.LoadXMLNodeFromInStream(InStream,OriginalXMLRootNode);
    END;

    [External]
    PROCEDURE GetOCRServiceDocumentReference@35(IncomingDocument@1004 : Record 130) : Text[50];
    VAR
      IncomingDocumentAttachment@1000 : Record 133;
    BEGIN
      IncomingDocumentAttachment.SETRANGE("Incoming Document Entry No.",IncomingDocument."Entry No.");
      IncomingDocumentAttachment.SETRANGE("Generated from OCR",TRUE);
      IF NOT IncomingDocumentAttachment.FINDFIRST THEN
        EXIT('');
      EXIT(IncomingDocumentAttachment."OCR Service Document Reference");
    END;

    [Internal]
    PROCEDURE GetDocumentList@15(VAR ResponseStr@1001 : InStream) : Boolean;
    BEGIN
      EXIT(RsoGetRequest('currentuser/documents?pageIndex=0&pageSize=1000',ResponseStr));
    END;

    [Internal]
    PROCEDURE GetDocuments@12(ExternalBatchFilter@1002 : Text) : Integer;
    VAR
      TypeHelper@1005 : Codeunit 10;
      XMLDOMManagement@1008 : Codeunit 6224;
      XMLRootNode@1001 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      XMLNode@1000 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      ChildNode@1006 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      ResponseStr@1009 : InStream;
      ExternalBatchId@1004 : Text[50];
      DocId@1007 : Text[50];
      DocCount@1003 : Integer;
    BEGIN
      GetOcrServiceSetup(TRUE);

      RsoGetRequest(STRSUBSTNO('documents/rest/customers/%1/outputdocuments',OCRServiceSetup."Customer ID"),ResponseStr);

      XMLDOMManagement.LoadXMLNodeFromInStream(ResponseStr,XMLRootNode);

      FOREACH XMLNode IN XMLRootNode.ChildNodes DO BEGIN
        ChildNode := XMLNode.SelectSingleNode('BatchExternalId');
        ExternalBatchId := ChildNode.InnerText;
        IF (ExternalBatchFilter = '') OR (ExternalBatchFilter = ExternalBatchId) THEN
          FOREACH ChildNode IN XMLNode.SelectNodes('DocumentId') DO BEGIN
            DocId := ChildNode.InnerText;

            IF NOT TypeHelper.IsMatch(DocId,'^[a-zA-Z0-9\-\{\}]*$') THEN
              ERROR(NotValidDocIDErr,DocId);

            DocCount += DownloadDocument(ExternalBatchId,DocId);

            IF DocCount > GetMaxDocDownloadCount THEN BEGIN
              LogActivitySucceeded(OCRServiceSetup.RECORDID,GetNewDocumentsMsg,STRSUBSTNO(NewDocumentsTotalMsg,DocCount));
              EXIT(DocCount);
            END;
          END;
      END;

      LogActivitySucceeded(OCRServiceSetup.RECORDID,GetNewDocumentsMsg,STRSUBSTNO(NewDocumentsTotalMsg,DocCount));

      IF (ExternalBatchFilter <> '') AND (DocCount > 0) THEN
        EXIT(DocCount);

      IF ExternalBatchFilter <> '' THEN
        GetDocumentStatus(ExternalBatchFilter)
      ELSE
        GetDocumentsExcludeProcessed;

      EXIT(DocCount);
    END;

    [Internal]
    PROCEDURE GetDocumentsExcludeProcessed@23();
    VAR
      IncomingDocument@1009 : Record 130;
      IncomingDocumentAttachment@1011 : Record 133;
      TempIncomingDocumentAttachment@1010 : TEMPORARY Record 133;
    BEGIN
      GetOcrServiceSetup(TRUE);

      IncomingDocument.SETRANGE("OCR Status",IncomingDocument."OCR Status"::Sent);
      IF NOT IncomingDocument.FINDSET THEN
        EXIT;

      REPEAT
        IncomingDocumentAttachment.SETRANGE("Incoming Document Entry No.",IncomingDocument."Entry No.");
        IncomingDocumentAttachment.SETRANGE(Default,TRUE);
        IncomingDocumentAttachment.FINDFIRST;
        TempIncomingDocumentAttachment := IncomingDocumentAttachment;
        TempIncomingDocumentAttachment.INSERT;
      UNTIL IncomingDocument.NEXT = 0;

      GetBatches(TempIncomingDocumentAttachment,'');
    END;

    [Internal]
    PROCEDURE GetDocumentStatus@43(ExternalBatchFilter@1002 : Text);
    VAR
      IncomingDocument@1009 : Record 130;
      IncomingDocumentAttachment@1011 : Record 133;
      TempIncomingDocumentAttachment@1010 : TEMPORARY Record 133;
    BEGIN
      GetOcrServiceSetup(TRUE);

      IncomingDocumentAttachment.SETRANGE("External Document Reference",ExternalBatchFilter);
      IncomingDocumentAttachment.SETRANGE(Default,TRUE);
      IncomingDocumentAttachment.FINDFIRST;

      IncomingDocument.GET(IncomingDocumentAttachment."Incoming Document Entry No.");
      IF IncomingDocument."OCR Status" <> IncomingDocument."OCR Status"::Sent THEN
        EXIT;

      TempIncomingDocumentAttachment := IncomingDocumentAttachment;
      TempIncomingDocumentAttachment.INSERT;

      GetBatches(TempIncomingDocumentAttachment,ExternalBatchFilter);
    END;

    [Internal]
    PROCEDURE GetDocumentForAttachment@7(VAR IncomingDocumentAttachment@1003 : Record 133) : Integer;
    VAR
      IncomingDocument@1000 : Record 130;
      Status@1001 : Integer;
    BEGIN
      IF IncomingDocumentAttachment."External Document Reference" = '' THEN
        ERROR(NotUploadedErr);

      IF GetDocuments(IncomingDocumentAttachment."External Document Reference") > 0 THEN
        Status := IncomingDocument."OCR Status"::Success
      ELSE BEGIN
        IncomingDocument.GET(IncomingDocumentAttachment."Incoming Document Entry No.");
        Status := IncomingDocument."OCR Status";
      END;

      CASE Status OF
        IncomingDocument."OCR Status"::Success:
          MESSAGE(ImportSuccessMsg);
        IncomingDocument."OCR Status"::"Awaiting Verification":
          MESSAGE(VerifyMsg);
        IncomingDocument."OCR Status"::Error:
          MESSAGE(FailedMsg);
        IncomingDocument."OCR Status"::Sent: // Pending Result
          MESSAGE(DocumentNotReadyMsg);
        ELSE
          MESSAGE(DocumentNotReadyMsg);
      END;

      EXIT(Status);
    END;

    LOCAL PROCEDURE GetBatchDocuments@42(VAR XMLRootNode@1009 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";BatchFilter@1001 : Text);
    VAR
      XMLDOMManagement@1007 : Codeunit 6224;
      ResponseStr@1005 : InStream;
      Path@1000 : Text;
      PageSize@1004 : Integer;
      CurrentPage@1003 : Integer;
    BEGIN
      PageSize := 200;
      CurrentPage := 0;
      Path := STRSUBSTNO(
          'documents/rest/customers/%1/batches/%2/documents?pageIndex=%3&pageSize=%4',OCRServiceSetup."Customer ID",
          BatchFilter,CurrentPage,PageSize);
      RsoGetRequest(Path,ResponseStr);
      XMLDOMManagement.LoadXMLNodeFromInStream(ResponseStr,XMLRootNode);
    END;

    LOCAL PROCEDURE GetBatchesApi@79(VAR XMLRootNode@1009 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";ExternalBatchFilter@1001 : Text);
    VAR
      XMLDOMManagement@1007 : Codeunit 6224;
      ResponseStr@1005 : InStream;
      Path@1000 : Text;
      PageSize@1004 : Integer;
      CurrentPage@1003 : Integer;
    BEGIN
      PageSize := 200;
      CurrentPage := 0;
      IF ExternalBatchFilter <> '' THEN
        Path := STRSUBSTNO(
            'documents/rest/customers/%1/batches?pageIndex=%2&pageSize=%3&externalId=%4',OCRServiceSetup."Customer ID",
            CurrentPage,PageSize,ExternalBatchFilter)
      ELSE
        Path := STRSUBSTNO(
            'documents/rest/customers/%1/batches?pageIndex=%2&pageSize=%3&excludeProcessed=1',OCRServiceSetup."Customer ID",
            CurrentPage,PageSize);

      RsoGetRequest(Path,ResponseStr);
      XMLDOMManagement.LoadXMLNodeFromInStream(ResponseStr,XMLRootNode);
    END;

    LOCAL PROCEDURE GetBatches@48(VAR TempIncomingDocumentAttachment@1011 : TEMPORARY Record 133;ExternalBatchFilter@1001 : Text);
    VAR
      IncomingDocument@1010 : Record 130;
      XMLDOMManagement@1007 : Codeunit 6224;
      SendIncomingDocumentToOCR@1006 : Codeunit 133;
      XMLRootNode@1005 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      CurrentPage@1003 : Integer;
      TotalPages@1002 : Integer;
    BEGIN
      REPEAT
        GetBatchesApi(XMLRootNode,ExternalBatchFilter);
        EVALUATE(TotalPages,XMLDOMManagement.FindNodeText(XMLRootNode,'//PageCount'));

        XMLDOMManagement.FindNode(XMLRootNode,'//Batches',XMLRootNode);
        FindDocumentFromList(XMLRootNode,TempIncomingDocumentAttachment);

        CurrentPage += 1;
      UNTIL (TempIncomingDocumentAttachment.COUNT = 0) OR (CurrentPage > TotalPages);

      IF TempIncomingDocumentAttachment.FINDSET THEN
        REPEAT
          IncomingDocument.GET(TempIncomingDocumentAttachment."Incoming Document Entry No.");
          SendIncomingDocumentToOCR.SetStatusToFailed(IncomingDocument);
        UNTIL TempIncomingDocumentAttachment.NEXT = 0;
    END;

    [Internal]
    PROCEDURE GetDocumentId@50(ExternalBatchFilter@1000 : Text) : Text;
    VAR
      XMLDOMManagement@1003 : Codeunit 6224;
      XMLRootNode@1004 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      BatchID@1005 : Text;
      DocumentID@1006 : Text;
    BEGIN
      GetOcrServiceSetup(TRUE);

      GetBatchesApi(XMLRootNode,ExternalBatchFilter);
      BatchID := XMLDOMManagement.FindNodeText(XMLRootNode,'/PagedBatches/Batches/Batch/Id');

      GetBatchDocuments(XMLRootNode,BatchID);
      DocumentID := XMLDOMManagement.FindNodeText(XMLRootNode,'/PagedDocuments/Documents/Document/Id');

      EXIT(DocumentID);
    END;

    LOCAL PROCEDURE DownloadDocument@22(ExternalBatchId@1003 : Text[50];DocId@1005 : Text[50]) : Integer;
    VAR
      IncomingDocument@1000 : Record 130;
      IncomingDocumentAttachment@1009 : Record 133;
      XMLDOMManagement@1006 : Codeunit 6224;
      SendIncomingDocumentToOCR@1007 : Codeunit 133;
      ImageInStr@1011 : InStream;
      ResponseStr@1010 : InStream;
      XMLRootNode@1004 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      AttachmentName@1001 : Text[250];
      ContentType@1008 : Text[50];
    BEGIN
      RsoGetRequest(STRSUBSTNO('documents/rest/%1',DocId),ResponseStr);
      IF NOT XMLDOMManagement.LoadXMLNodeFromInStream(ResponseStr,XMLRootNode) THEN BEGIN
        LogActivityFailed(OCRServiceSetup.RECORDID,GetDocumentMsg,'');
        EXIT(0);
      END;

      IF ExternalBatchId <> '' THEN
        IncomingDocumentAttachment.SETRANGE("External Document Reference",ExternalBatchId);
      IF (ExternalBatchId <> '') AND IncomingDocumentAttachment.FINDFIRST THEN BEGIN
        IncomingDocument.GET(IncomingDocumentAttachment."Incoming Document Entry No.");
        AttachmentName := IncomingDocumentAttachment.Name;
      END ELSE BEGIN  // New Incoming Document
        AttachmentName := COPYSTR(XMLDOMManagement.FindNodeText(XMLRootNode,'OriginalFilename'),1,MAXSTRLEN(AttachmentName));
        IncomingDocument.INIT;
        IncomingDocument.CreateIncomingDocument(AttachmentName,'');
        IncomingDocumentAttachment.SETRANGE("External Document Reference");
        IF RsoGetRequestBinary(STRSUBSTNO('documents/rest/file/%1/image',DocId),ImageInStr,ContentType) THEN
          IncomingDocument.AddAttachmentFromStream(
            IncomingDocumentAttachment,AttachmentName,GetExtensionFromContentType(AttachmentName,ContentType),ImageInStr);
      END;
      IncomingDocument.CheckNotCreated;
      IncomingDocumentAttachment.SETRANGE("External Document Reference");
      IncomingDocument.AddAttachmentFromStream(IncomingDocumentAttachment,AttachmentName,'xml',ResponseStr);
      IncomingDocumentAttachment."Generated from OCR" := TRUE;
      IncomingDocumentAttachment."OCR Service Document Reference" := DocId;
      IncomingDocumentAttachment.VALIDATE(Default,TRUE);
      IncomingDocumentAttachment.MODIFY;

      IncomingDocument.GET(IncomingDocument."Entry No.");
      SendIncomingDocumentToOCR.SetStatusToReceived(IncomingDocument);

      UpdateIncomingDocWithOCRData(IncomingDocument,XMLRootNode);
      LogActivitySucceeded(IncomingDocument.RECORDID,GetDocumentMsg,STRSUBSTNO(DocumentDownloadedTxt,DocId));

      RsoPutRequest(
        STRSUBSTNO('documents/rest/%1/downloaded',DocId),
        '<UploadDataCollection xmlns:i="http://www.w3.org/2001/XMLSchema-instance" />',ResponseStr);
      LogActivitySucceeded(IncomingDocument.RECORDID,GetDocumentConfirmMsg,STRSUBSTNO(DocumentDownloadedTxt,DocId));
      EXIT(1);
    END;

    [Internal]
    PROCEDURE UpdateIncomingDocWithOCRData@24(VAR IncomingDocument@1000 : Record 130;VAR XMLRootNode@1002 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode");
    VAR
      Vendor@1006 : Record 23;
      IncomingDocumentAttachment@1003 : Record 133;
      XMLDOMManagement@1004 : Codeunit 6224;
    BEGIN
      WITH IncomingDocument DO BEGIN
        IF "Data Exchange Type" = '' THEN
          EXIT;

        IncomingDocumentAttachment.SETRANGE("Incoming Document Entry No.","Entry No.");
        IncomingDocumentAttachment.SETRANGE("Generated from OCR",TRUE);
        IncomingDocumentAttachment.SETRANGE(Default,TRUE);
        IF NOT IncomingDocumentAttachment.FINDFIRST THEN
          EXIT;
        IncomingDocumentAttachment.ExtractHeaderFields(XMLRootNode,IncomingDocument);
        GET("Entry No.");

        IF XMLDOMManagement.FindNodeText(XMLRootNode,'HeaderFields/HeaderField/Text[../Type/text() = "creditinvoice"]') =
           'true'
        THEN
          "Document Type" := "Document Type"::"Purchase Credit Memo";

        IF NOT ISNULLGUID("Vendor Id") THEN BEGIN
          Vendor.SETRANGE(Id,"Vendor Id");
          IF Vendor.FINDFIRST THEN
            VALIDATE("Vendor No.",Vendor."No.");
        END ELSE
          IF "Vendor VAT Registration No." <> '' THEN BEGIN
            Vendor.SETRANGE("VAT Registration No.","Vendor VAT Registration No.");
            IF Vendor.FINDFIRST THEN
              VALIDATE("Vendor No.",Vendor."No.");
          END;

        MODIFY;
      END;
    END;

    PROCEDURE LogActivitySucceeded@31(RelatedRecordID@1001 : RecordID;ActivityDescription@1002 : Text;ActivityMessage@1003 : Text);
    VAR
      ActivityLog@1000 : Record 710;
    BEGIN
      ActivityLog.LogActivity(RelatedRecordID,ActivityLog.Status::Success,LoggingConstTxt,
        ActivityDescription,ActivityMessage);
    END;

    PROCEDURE LogActivityFailed@29(RelatedRecordID@1001 : RecordID;ActivityDescription@1002 : Text;ActivityMessage@1003 : Text);
    VAR
      ActivityLog@1000 : Record 710;
    BEGIN
      ActivityMessage := GETLASTERRORTEXT + ' ' + ActivityMessage;
      CLEARLASTERROR;

      ActivityLog.LogActivity(RelatedRecordID,ActivityLog.Status::Failed,LoggingConstTxt,
        ActivityDescription,ActivityMessage);

      COMMIT;

      IF DELCHR(ActivityMessage,'<>',' ') <> '' THEN
        ERROR(ActivityMessage);
    END;

    [EventSubscriber(Table,1400,OnRegisterServiceConnection)]
    [External]
    PROCEDURE HandleOCRRegisterServiceConnection@20(VAR ServiceConnection@1003 : Record 1400);
    VAR
      OCRServiceSetup@1001 : Record 1270;
      RecRef@1002 : RecordRef;
    BEGIN
      IF NOT OCRServiceSetup.GET THEN BEGIN
        OCRServiceSetup.INIT;
        OCRServiceSetup.INSERT(TRUE);
      END;
      RecRef.GETTABLE(OCRServiceSetup);

      IF OCRServiceSetup.Enabled THEN
        ServiceConnection.Status := ServiceConnection.Status::Enabled
      ELSE
        ServiceConnection.Status := ServiceConnection.Status::Disabled;
      WITH OCRServiceSetup DO
        ServiceConnection.InsertServiceConnection(
          ServiceConnection,RecRef.RECORDID,TABLENAME,"Service URL",PAGE::"OCR Service Setup");
    END;

    LOCAL PROCEDURE GetMaxDocDownloadCount@30() : Integer;
    BEGIN
      EXIT(1000);
    END;

    LOCAL PROCEDURE GetDocumentSimplifiedStatus@45(ObjectStatus@1000 : Integer) : Integer;
    VAR
      IncomingDocument@1001 : Record 130;
    BEGIN
      // Status definitions can be found at http://docs.readsoftonline.com/help/eng/partner/#reference/batch-statuses.htm%3FTocPath%3DReference%7C_____6
      // Status codes can be found at https://services.readsoftonline.com/documentation/rest?s=-940536891&m=173766930
      CASE ObjectStatus OF
        0: // 'BATCHCREATED'
          EXIT(IncomingDocument."OCR Status"::Sent);
        1: // 'BATCHINPUTVALIDATIONFAILED'
          EXIT(IncomingDocument."OCR Status"::Error);
        3: // 'BATCHPENDINGPROCESSSTART'
          EXIT(IncomingDocument."OCR Status"::Sent);
        7: // 'BATCHCLASSIFICATIONINPROGRESS'
          EXIT(IncomingDocument."OCR Status"::Sent);
        10: // 'BATCHPENDINGCORRECTION'
          EXIT(IncomingDocument."OCR Status"::"Awaiting Verification");
        15: // 'BATCHEXTRACTIONINPROGRESS'
          EXIT(IncomingDocument."OCR Status"::Sent);
        20: // 'BATCHMANUALVERIFICATION'
          EXIT(IncomingDocument."OCR Status"::"Awaiting Verification");
        23: // 'BATCHREQUESTINFORMATION'
          EXIT(IncomingDocument."OCR Status"::"Awaiting Verification");
        25: // 'BATCHAPPROVALINPROGRESS'
          EXIT(IncomingDocument."OCR Status"::Sent);
        26: // 'BATCHPENDINGREGISTRATION'
          EXIT(IncomingDocument."OCR Status"::Sent);
        27: // 'BATCHREGISTRATIONINPROGRESS'
          EXIT(IncomingDocument."OCR Status"::Sent);
        28: // 'BATCHPENDINGPOST'
          EXIT(IncomingDocument."OCR Status"::Sent);
        29: // 'BATCHPOSTINPROGRESS'
          EXIT(IncomingDocument."OCR Status"::Sent);
        30: // 'BATCHPENDINGEXPORT'
          EXIT(IncomingDocument."OCR Status"::Sent);
        33: // 'BATCHEXPORTINPROGRESS'
          EXIT(IncomingDocument."OCR Status"::Success);
        35: // 'BATCHEXPORTFAILED'
          EXIT(IncomingDocument."OCR Status"::Error);
        40: // 'BATCHSUCCESSFULLYPROCESSED'
          EXIT(IncomingDocument."OCR Status"::Sent);
        50: // 'BATCHREJECTED'
          EXIT(IncomingDocument."OCR Status"::Error);
        100: // 'BATCHDELETED'
          EXIT(IncomingDocument."OCR Status"::Error);
        200: // 'BATCHPREPROCESSINGINPROGRESS'
          EXIT(IncomingDocument."OCR Status"::Sent);
        13: // 'BATCHMANUALSEPERATION'
          EXIT(IncomingDocument."OCR Status"::"Awaiting Verification");
        14: // 'BATCHSEPERATIONINPROGRESS'
          EXIT(IncomingDocument."OCR Status"::Sent);
        95: // 'BATCHDELETEINPROGRESS'
          EXIT(IncomingDocument."OCR Status"::Error);
        ELSE
          EXIT(IncomingDocument."OCR Status"::" ");
      END;
    END;

    LOCAL PROCEDURE FindDocumentFromList@51(VAR XMLRootNode@1000 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";VAR TempIncomingDocumentAttachment@1001 : TEMPORARY Record 133);
    VAR
      IncomingDocument@1009 : Record 130;
      XMLDOMManagement@1008 : Codeunit 6224;
      SendIncomingDocumentToOCR@1006 : Codeunit 133;
      XMLNode@1005 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      DocId@1002 : Text;
      DocStatus@1007 : Integer;
      StatusAsInt@1004 : Integer;
    BEGIN
      FOREACH XMLNode IN XMLRootNode.ChildNodes DO BEGIN
        IF TempIncomingDocumentAttachment.ISEMPTY THEN
          EXIT;

        DocId := XMLDOMManagement.FindNodeText(XMLNode,'./ExternalId');
        TempIncomingDocumentAttachment.SETRANGE("External Document Reference",DocId);
        IF TempIncomingDocumentAttachment.FINDSET THEN
          REPEAT
            EVALUATE(StatusAsInt,XMLDOMManagement.FindNodeText(XMLNode,'./StatusAsInt'));
            DocStatus := GetDocumentSimplifiedStatus(StatusAsInt);
            IncomingDocument.GET(TempIncomingDocumentAttachment."Incoming Document Entry No.");
            CASE DocStatus OF
              IncomingDocument."OCR Status"::Error:
                SendIncomingDocumentToOCR.SetStatusToFailed(IncomingDocument);
              IncomingDocument."OCR Status"::"Awaiting Verification":
                SendIncomingDocumentToOCR.SetStatusToVerify(IncomingDocument);
            END;

            TempIncomingDocumentAttachment.DELETE;
          UNTIL TempIncomingDocumentAttachment.NEXT = 0;

        // Remove filter
        TempIncomingDocumentAttachment.SETRANGE("External Document Reference");
        IF TempIncomingDocumentAttachment.FINDSET THEN;
      END;
    END;

    [Internal]
    PROCEDURE TestConnection@46(VAR OCRServiceSetup@1000 : Record 1270);
    BEGIN
      IF SetupConnection(OCRServiceSetup) THEN
        MESSAGE(ConnectionSuccessMsg);
    END;

    [Internal]
    PROCEDURE SetupConnection@40(VAR OCRServiceSetup@1000 : Record 1270) : Boolean;
    BEGIN
      IF NOT HasCredentials(OCRServiceSetup) THEN
        ERROR(GetCredentialsErrText);
      IF NOT Authenticate THEN
        ERROR(ConnectionFailedErr);
      UpdateOrganizationInfo(OCRServiceSetup);
      UpdateOcrDocumentTemplates;
      EXIT(TRUE);
    END;

    [EventSubscriber(Page,189,OnCloseIncomingDocumentFromAction)]
    LOCAL PROCEDURE OnCloseIncomingDocumentHandler@44(VAR IncomingDocument@1001 : Record 130);
    BEGIN
      PAGE.RUN(PAGE::"Incoming Document",IncomingDocument);
    END;

    [EventSubscriber(Page,190,OnCloseIncomingDocumentsFromActions)]
    LOCAL PROCEDURE OnCloseIncomingDocumentsHandler@47(VAR IncomingDocument@1001 : Record 130);
    BEGIN
      PAGE.RUN(PAGE::"Incoming Documents",IncomingDocument);
    END;

    [External]
    PROCEDURE OcrServiceIsEnable@52() : Boolean;
    BEGIN
      IF NOT OCRServiceSetup.GET THEN
        EXIT(FALSE);

      IF
         (OCRServiceSetup."Service URL" = '') OR
         (OCRServiceSetup.Enabled = FALSE)
      THEN
        EXIT(FALSE);

      EXIT(TRUE);
    END;

    [Internal]
    PROCEDURE GetStatusHyperLink@83(IncomingDocument@1000 : Record 130) : Text;
    VAR
      IncomingDocumentAttachment@1001 : Record 133;
      DocumentID@1002 : Text;
    BEGIN
      IF IncomingDocument."OCR Status" = IncomingDocument."OCR Status"::"Awaiting Verification" THEN BEGIN
        IncomingDocument.GetMainAttachment(IncomingDocumentAttachment);
        IF IncomingDocumentAttachment."External Document Reference" = '' THEN
          EXIT('');

        DocumentID := GetDocumentId(IncomingDocumentAttachment."External Document Reference");
        EXIT(STRSUBSTNO('%1/documents/%2',OCRServiceSetup."Sign-in URL",DocumentID));
      END;

      IF OCRServiceSetup.Enabled AND (OCRServiceSetup."Sign-in URL" <> '') THEN
        EXIT(OCRServiceSetup."Sign-in URL");
    END;

    LOCAL PROCEDURE GetExtensionFromContentType@66(AttachmentName@1001 : Text;ContentType@1000 : Text) : Text;
    VAR
      FileManagement@1002 : Codeunit 419;
    BEGIN
      IF STRPOS(ContentType,'application/pdf') <> 0 THEN
        EXIT('pdf');
      EXIT(FileManagement.GetExtension(AttachmentName));
    END;

    BEGIN
    END.
  }
}

