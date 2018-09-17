OBJECT Codeunit 1290 SOAP Web Service Request Mgt.
{
  OBJECT-PROPERTIES
  {
    Date=26-01-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20348;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      BodyPathTxt@1001 : TextConst '@@@={Locked};DAN=/soap:Envelope/soap:Body;ENU=/soap:Envelope/soap:Body';
      ContentTypeTxt@1000 : TextConst '@@@={Locked};DAN="multipart/form-data; charset=utf-8";ENU="multipart/form-data; charset=utf-8"';
      FaultStringXmlPathTxt@1012 : TextConst '@@@={Locked};DAN=/soap:Envelope/soap:Body/soap:Fault/faultstring;ENU=/soap:Envelope/soap:Body/soap:Fault/faultstring';
      NoRequestBodyErr@1015 : TextConst 'DAN=Anmodningsindholdet er ikke angivet.;ENU=The request body is not set.';
      NoServiceAddressErr@1017 : TextConst 'DAN=Webtjeneste-URI''en er ikke angivet.;ENU=The web service URI is not set.';
      ExpectedResponseNotReceivedErr@1009 : TextConst 'DAN=De forventede data blev ikke modtaget fra webtjenesten.;ENU=The expected data was not received from the web service.';
      SchemaNamespaceTxt@1007 : TextConst '@@@={Locked};DAN=http://www.w3.org/2001/XMLSchema;ENU=http://www.w3.org/2001/XMLSchema';
      SchemaInstanceNamespaceTxt@1006 : TextConst '@@@={Locked};DAN=http://www.w3.org/2001/XMLSchema-instance;ENU=http://www.w3.org/2001/XMLSchema-instance';
      SecurityUtilityNamespaceTxt@1003 : TextConst '@@@={Locked};DAN=http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd;ENU=http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd';
      SecurityExtensionNamespaceTxt@1004 : TextConst '@@@={Locked};DAN=http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd;ENU=http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd';
      SoapNamespaceTxt@1002 : TextConst '@@@={Locked};DAN=http://schemas.xmlsoap.org/soap/envelope/;ENU=http://schemas.xmlsoap.org/soap/envelope/';
      UsernameTokenNamepsaceTxt@1005 : TextConst '@@@={Locked};DAN=http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText;ENU=http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText';
      TempDebugLogTempBlob@1010 : TEMPORARY Record 99008535;
      ResponseBodyTempBlob@1020 : Record 99008535;
      ResponseInStreamTempBlob@1019 : Record 99008535;
      Trace@1016 : Codeunit 1292;
      GlobalRequestBodyInStream@1022 : InStream;
      HttpWebResponse@1021 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Net.HttpWebResponse";
      GlobalPassword@1013 : Text;
      GlobalURL@1014 : Text;
      GlobalUsername@1008 : Text;
      TraceLogEnabled@1011 : Boolean;
      GlobalTimeout@1024 : Integer;
      InternalErr@1028 : TextConst 'DAN=Fjerntjenesten har returneret f�lgende fejlmeddelelse:\\;ENU=The remote service has returned the following error message:\\';
      GlobalContentType@1026 : Text;
      GlobalSkipCheckHttps@1018 : Boolean;
      GlobalProgressDialogEnabled@1023 : Boolean;
      InvalidTokenFormatErr@1025 : TextConst 'DAN=Tokenet skal v�re i JWS- eller JWE-kompakt serialiseringsformat.;ENU=The token must be in JWS or JWE Compact Serialization Format.';

    [TryFunction]
    [Internal]
    PROCEDURE SendRequestToWebService@17();
    VAR
      WebRequestHelper@1000 : Codeunit 1299;
      HttpWebRequest@1007 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Net.HttpWebRequest";
      HttpStatusCode@1002 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Net.HttpStatusCode";
      ResponseHeaders@1001 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.Specialized.NameValueCollection";
      ResponseInStream@1006 : InStream;
    BEGIN
      CheckGlobals;
      BuildWebRequest(GlobalURL,HttpWebRequest);
      ResponseInStreamTempBlob.INIT;
      ResponseInStreamTempBlob.Blob.CREATEINSTREAM(ResponseInStream);
      CreateSoapRequest(HttpWebRequest.GetRequestStream,GlobalRequestBodyInStream,GlobalUsername,GlobalPassword);
      WebRequestHelper.GetWebResponse(HttpWebRequest,HttpWebResponse,ResponseInStream,
        HttpStatusCode,ResponseHeaders,GlobalProgressDialogEnabled);
      ExtractContentFromResponse(ResponseInStream,ResponseBodyTempBlob);
    END;

    LOCAL PROCEDURE BuildWebRequest@3(ServiceUrl@1000 : Text;VAR HttpWebRequest@1002 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Net.HttpWebRequest");
    VAR
      DecompressionMethods@1003 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Net.DecompressionMethods";
    BEGIN
      HttpWebRequest := HttpWebRequest.Create(ServiceUrl);
      HttpWebRequest.Method := 'POST';
      HttpWebRequest.KeepAlive := TRUE;
      HttpWebRequest.AllowAutoRedirect := TRUE;
      HttpWebRequest.UseDefaultCredentials := TRUE;
      IF GlobalContentType = '' THEN
        GlobalContentType := ContentTypeTxt;
      HttpWebRequest.ContentType := GlobalContentType;
      IF GlobalTimeout <= 0 THEN
        GlobalTimeout := 600000;
      HttpWebRequest.Timeout := GlobalTimeout;
      HttpWebRequest.AutomaticDecompression := DecompressionMethods.GZip;
    END;

    LOCAL PROCEDURE CreateSoapRequest@2(RequestOutStream@1000 : OutStream;BodyContentInStream@1004 : InStream;Username@1003 : Text;Password@1005 : Text);
    VAR
      XmlDoc@1007 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlDocument";
      BodyXmlNode@1016 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
    BEGIN
      CreateEnvelope(XmlDoc,BodyXmlNode,Username,Password);
      AddBodyToEnvelope(BodyXmlNode,BodyContentInStream);
      XmlDoc.Save(RequestOutStream);
      TraceLogXmlDocToTempFile(XmlDoc,'FullRequest');
    END;

    LOCAL PROCEDURE CreateEnvelope@11(VAR XmlDoc@1011 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlDocument";VAR BodyXmlNode@1001 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";Username@1009 : Text;Password@1010 : Text);
    VAR
      XMLDOMMgt@1000 : Codeunit 6224;
      EnvelopeXmlNode@1007 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      HeaderXmlNode@1006 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      SecurityXmlNode@1005 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      UsernameTokenXmlNode@1004 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      TempXmlNode@1003 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      PasswordXmlNode@1002 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
    BEGIN
      XmlDoc := XmlDoc.XmlDocument;
      WITH XMLDOMMgt DO BEGIN
        AddRootElementWithPrefix(XmlDoc,'Envelope','s',SoapNamespaceTxt,EnvelopeXmlNode);
        AddAttribute(EnvelopeXmlNode,'xmlns:u',SecurityUtilityNamespaceTxt);

        AddElementWithPrefix(EnvelopeXmlNode,'Header','','s',SoapNamespaceTxt,HeaderXmlNode);

        IF (Username <> '') OR (Password <> '') THEN BEGIN
          AddElementWithPrefix(HeaderXmlNode,'Security','','o',SecurityExtensionNamespaceTxt,SecurityXmlNode);
          AddAttributeWithPrefix(SecurityXmlNode,'mustUnderstand','s',SoapNamespaceTxt,'1');

          AddElementWithPrefix(SecurityXmlNode,'UsernameToken','','o',SecurityExtensionNamespaceTxt,UsernameTokenXmlNode);
          AddAttributeWithPrefix(UsernameTokenXmlNode,'Id','u',SecurityUtilityNamespaceTxt,CreateUUID);

          AddElementWithPrefix(UsernameTokenXmlNode,'Username',Username,'o',SecurityExtensionNamespaceTxt,TempXmlNode);
          AddElementWithPrefix(UsernameTokenXmlNode,'Password',Password,'o',SecurityExtensionNamespaceTxt,PasswordXmlNode);
          AddAttribute(PasswordXmlNode,'Type',UsernameTokenNamepsaceTxt);
        END;

        AddElementWithPrefix(EnvelopeXmlNode,'Body','','s',SoapNamespaceTxt,BodyXmlNode);
        AddAttribute(BodyXmlNode,'xmlns:xsi',SchemaInstanceNamespaceTxt);
        AddAttribute(BodyXmlNode,'xmlns:xsd',SchemaNamespaceTxt);
      END;
    END;

    LOCAL PROCEDURE CreateUUID@9() : Text;
    BEGIN
      EXIT('uuid-' + DELCHR(LOWERCASE(FORMAT(CREATEGUID)),'=','{}'));
    END;

    LOCAL PROCEDURE AddBodyToEnvelope@12(VAR BodyXmlNode@1005 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";BodyInStream@1000 : InStream);
    VAR
      XMLDOMManagement@1001 : Codeunit 6224;
      BodyContentXmlDoc@1003 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlDocument";
    BEGIN
      XMLDOMManagement.LoadXMLDocumentFromInStream(BodyInStream,BodyContentXmlDoc);
      TraceLogXmlDocToTempFile(BodyContentXmlDoc,'RequestBodyContent');

      BodyXmlNode.AppendChild(BodyXmlNode.OwnerDocument.ImportNode(BodyContentXmlDoc.DocumentElement,TRUE));
    END;

    LOCAL PROCEDURE ExtractContentFromResponse@4(ResponseInStream@1000 : InStream;VAR BodyTempBlob@1002 : Record 99008535);
    VAR
      XMLDOMMgt@1005 : Codeunit 6224;
      ResponseBodyXMLDoc@1004 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlDocument";
      ResponseBodyXmlNode@1006 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      XmlNode@1008 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      BodyOutStream@1007 : OutStream;
      Found@1001 : Boolean;
    BEGIN
      TraceLogStreamToTempFile(ResponseInStream,'FullResponse',TempDebugLogTempBlob);
      XMLDOMMgt.LoadXMLNodeFromInStream(ResponseInStream,XmlNode);

      Found := XMLDOMMgt.FindNodeWithNamespace(XmlNode,BodyPathTxt,'soap',SoapNamespaceTxt,ResponseBodyXmlNode);
      IF NOT Found THEN
        ERROR(ExpectedResponseNotReceivedErr);

      ResponseBodyXMLDoc := ResponseBodyXMLDoc.XmlDocument;
      ResponseBodyXMLDoc.AppendChild(ResponseBodyXMLDoc.ImportNode(ResponseBodyXmlNode.FirstChild,TRUE));

      BodyTempBlob.Blob.CREATEOUTSTREAM(BodyOutStream);
      ResponseBodyXMLDoc.Save(BodyOutStream);
      TraceLogXmlDocToTempFile(ResponseBodyXMLDoc,'ResponseBodyContent');
    END;

    [Internal]
    PROCEDURE GetResponseContent@22(VAR ResponseBodyInStream@1000 : InStream);
    BEGIN
      ResponseBodyTempBlob.Blob.CREATEINSTREAM(ResponseBodyInStream);
    END;

    [Internal]
    PROCEDURE ProcessFaultResponse@15(SupportInfo@1001 : Text);
    VAR
      WebRequestHelper@1002 : Codeunit 1299;
      XMLDOMMgt@1006 : Codeunit 6224;
      WebException@1005 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Net.WebException";
      XmlNode@1004 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      ResponseInputStream@1000 : InStream;
      ErrorText@1009 : Text;
      ServiceURL@1010 : Text;
    BEGIN
      ErrorText := WebRequestHelper.GetWebResponseError(WebException,ServiceURL);

      IF ErrorText <> '' THEN
        ERROR(ErrorText);

      ResponseInputStream := WebException.Response.GetResponseStream;
      IF TraceLogEnabled THEN
        Trace.LogStreamToTempFile(ResponseInputStream,'WebExceptionResponse',TempDebugLogTempBlob);

      XMLDOMMgt.LoadXMLNodeFromInStream(ResponseInputStream,XmlNode);

      ErrorText := XMLDOMMgt.FindNodeTextWithNamespace(XmlNode,FaultStringXmlPathTxt,'soap',SoapNamespaceTxt);
      IF ErrorText = '' THEN
        ErrorText := WebException.Message;
      ErrorText := InternalErr + ErrorText + ServiceURL;

      IF SupportInfo <> '' THEN
        ErrorText += '\\' + SupportInfo;

      ERROR(ErrorText);
    END;

    [External]
    PROCEDURE SetGlobals@10(RequestBodyInStream@1000 : InStream;URL@1001 : Text;Username@1002 : Text;Password@1003 : Text);
    BEGIN
      GlobalRequestBodyInStream := RequestBodyInStream;

      GlobalSkipCheckHttps := FALSE;

      GlobalURL := URL;
      GlobalUsername := Username;
      GlobalPassword := Password;

      GlobalProgressDialogEnabled := TRUE;

      TraceLogEnabled := FALSE;
    END;

    [External]
    PROCEDURE SetTimeout@7(NewTimeout@1000 : Integer);
    BEGIN
      GlobalTimeout := NewTimeout;
    END;

    [External]
    PROCEDURE SetContentType@20(NewContentType@1000 : Text);
    BEGIN
      GlobalContentType := NewContentType;
    END;

    LOCAL PROCEDURE CheckGlobals@14();
    VAR
      WebRequestHelper@1000 : Codeunit 1299;
    BEGIN
      IF GlobalRequestBodyInStream.EOS THEN
        ERROR(NoRequestBodyErr);

      IF GlobalURL = '' THEN
        ERROR(NoServiceAddressErr);

      IF GlobalSkipCheckHttps THEN
        WebRequestHelper.IsValidUri(GlobalURL)
      ELSE
        WebRequestHelper.IsSecureHttpUrl(GlobalURL);
    END;

    LOCAL PROCEDURE TraceLogStreamToTempFile@33(VAR ToLogInStream@1000 : InStream;Name@1005 : Text;VAR TraceLogTempBlob@1001 : Record 99008535);
    BEGIN
      IF TraceLogEnabled THEN
        Trace.LogStreamToTempFile(ToLogInStream,Name,TraceLogTempBlob);
    END;

    LOCAL PROCEDURE TraceLogXmlDocToTempFile@67(VAR XmlDoc@1004 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlDocument";Name@1005 : Text);
    BEGIN
      IF TraceLogEnabled THEN
        Trace.LogXmlDocToTempFile(XmlDoc,Name);
    END;

    [External]
    PROCEDURE SetTraceMode@1(NewTraceMode@1000 : Boolean);
    BEGIN
      TraceLogEnabled := NewTraceMode;
    END;

    [External]
    PROCEDURE DisableHttpsCheck@13();
    BEGIN
      GlobalSkipCheckHttps := TRUE;
    END;

    [External]
    PROCEDURE DisableProgressDialog@18();
    BEGIN
      GlobalProgressDialogEnabled := FALSE;
    END;

    [External]
    PROCEDURE HasJWTExpired@5(JsonWebToken@1000 : Text) : Boolean;
    VAR
      WebTokenAsJson@1001 : Text;
    BEGIN
      IF JsonWebToken = '' THEN
        EXIT(TRUE);
      IF NOT GetTokenDetailsAsJson(JsonWebToken,WebTokenAsJson) THEN
        ERROR(InvalidTokenFormatErr);
      EXIT(GetTokenDateTimeValue(WebTokenAsJson,'exp') < CURRENTDATETIME);
    END;

    [External]
    PROCEDURE GetTokenValue@6(WebTokenAsJson@1000 : Text;ClaimType@1001 : Text) : Text;
    VAR
      JSONManagement@1002 : Codeunit 5459;
      JObject@1004 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JObject";
      ClaimValue@1003 : Text;
    BEGIN
      JSONManagement.InitializeObject(WebTokenAsJson);
      JSONManagement.GetJSONObject(JObject);
      IF JSONManagement.GetStringPropertyValueFromJObjectByName(JObject,ClaimType,ClaimValue) THEN
        EXIT(ClaimValue);
    END;

    [External]
    PROCEDURE GetTokenDateTimeValue@8(WebTokenAsJson@1001 : Text;ClaimType@1000 : Text) : DateTime;
    VAR
      TypeHelper@1003 : Codeunit 10;
      Timestamp@1002 : Decimal;
    BEGIN
      IF NOT EVALUATE(Timestamp,GetTokenValue(WebTokenAsJson,ClaimType)) THEN
        EXIT;
      EXIT(TypeHelper.EvaluateUnixTimestamp(Timestamp));
    END;

    [TryFunction]
    [External]
    PROCEDURE GetTokenDetailsAsJson@19(JsonWebToken@1000 : Text;VAR WebTokenAsJson@1006 : Text);
    VAR
      JSONManagement@1005 : Codeunit 5459;
      JwtSecurityTokenHandler@1004 : DotNet "'System.IdentityModel.Tokens.Jwt'.System.IdentityModel.Tokens.Jwt.JwtSecurityTokenHandler";
      JwtSecurityToken@1003 : DotNet "'System.IdentityModel.Tokens.Jwt'.System.IdentityModel.Tokens.Jwt.JwtSecurityToken";
      Claim@1002 : DotNet "'mscorlib'.System.Security.Claims.Claim";
      JObject@1001 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JObject";
    BEGIN
      IF JsonWebToken = '' THEN
        EXIT;

      JwtSecurityTokenHandler := JwtSecurityTokenHandler.JwtSecurityTokenHandler;
      JwtSecurityToken := JwtSecurityTokenHandler.ReadToken(JsonWebToken);

      JSONManagement.InitializeEmptyObject;
      JSONManagement.GetJSONObject(JObject);
      FOREACH Claim IN JwtSecurityToken.Claims DO
        JSONManagement.AddJPropertyToJObject(JObject,Claim.Type,Claim.Value);

      WebTokenAsJson := JObject.ToString;
    END;

    BEGIN
    END.
  }
}

