OBJECT Codeunit 7820 MS-QBO Table Mgt.
{
  OBJECT-PROPERTIES
  {
    Date=28-06-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23019;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      WebhooksAdapterMgt@1024 : Codeunit 2201;
      Consumer@1000 : DotNet "'Microsoft.Dynamics.Nav.OAuth, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.OAuthHelper.Consumer";
      Token@1001 : DotNet "'Microsoft.Dynamics.Nav.OAuth, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.OAuthHelper.Token";
      OAuthAuthorization@1002 : DotNet "'Microsoft.Dynamics.Nav.OAuth, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.OAuthHelper.OAuthAuthorization";
      HttpMessageHandler@1007 : DotNet "'System.Net.Http, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'.System.Net.Http.HttpMessageHandler";
      RealmId@1003 : Text;
      BaseUrlTxt@1004 : TextConst '@@@={Locked};DAN=https://quickbooks.api.intuit.com;ENU=https://quickbooks.api.intuit.com';
      ReconnectUrlTxt@1021 : TextConst '@@@={Locked};DAN=https://appcenter.intuit.com;ENU=https://appcenter.intuit.com';
      NotInitializedErr@1006 : TextConst '@@@=%1 is the codeunit number. This is a message for developers.;DAN=Codeunit %1 blev ikke startet.;ENU=The codeunit %1 has not been initialized.';
      HttpRequestMethodNotSupportedErr@1010 : TextConst 'DAN=Den angivne HTTP-anmodningsmetode underst›ttes ikke.;ENU=The HTTP request method provided is not supported.';
      ErrorsTxt@1008 : TextConst 'DAN=Vi fandt en eller flere fejl.;ENU=We found one or more errors.';
      FieldtErr@1005 : TextConst '@@@="%1=Field Name";DAN=Problemet findes i feltet %1.;ENU=The problem is in the %1 field.';
      FaultTypeTxt@1011 : TextConst '@@@="%1=Type of error";DAN=Fejltype: %1;ENU=Error Type: %1';
      ConsumerKey@1013 : Text;
      ConsumerSecret@1012 : Text;
      MessageTxt@1014 : TextConst '@@@="%1=Message error";DAN=Meddelelse: %1;ENU=Message: %1';
      DetailTxt@1015 : TextConst '@@@="%1=Details about the error";DAN=Detaljer: <pi>%1</pi>;ENU=Detail: <pi>%1</pi>';
      Initialized@1016 : Boolean;
      StartPositionTxt@1018 : TextConst '@@@={Locked};DAN=" STARTPOSITION %1";ENU=" STARTPOSITION %1"';
      QueryCountTxt@1009 : TextConst '@@@={Locked};DAN=" MAXRESULTS %1";ENU=" MAXRESULTS %1"';
      CannotCompareDiffTablesErr@1017 : TextConst '@@@="%1=the first record id;%2=the second record id";DAN=%1 kan ikke sammenlignes med %2.;ENU=Cannot compare %1 with %2.';
      ExpectedAnArrayErr@1019 : TextConst 'DAN=Et array var forventet i QuickBooks Online-svaret.;ENU=An array was expected in the QuickBooks Online response.';
      PageSize@1020 : Integer;
      KeyvaultAccessFailedTxt@1023 : TextConst 'DAN=Kunne ikke f† adgang til n›glesamlingen for at hente data.;ENU=Could not access the keyvault to retrieve data.';
      JsonMediaTypeTxt@1022 : TextConst '@@@={Locked};DAN=application/json;ENU=application/json';
      ReconnectTxt@1025 : TextConst '@@@={Locked};DAN=/api/v1/connection/reconnect;ENU=/api/v1/connection/reconnect';

    PROCEDURE Initialize@3();
    VAR
      MSQBOSetup@1005 : Record 7824;
      AzureKeyVaultManagement@1006 : Codeunit 2200;
      ConsumerKeyTxt@1001 : Text;
      ConsumerSecretTxt@1002 : Text;
    BEGIN
      MSQBOSetup.GET;

      GetConsumerKeyAndSecretText(MSQBOSetup."Target Application",ConsumerKeyTxt,ConsumerSecretTxt);
      IF ConsumerKey = '' THEN
        AzureKeyVaultManagement.GetAzureKeyVaultSecret(ConsumerKey,ConsumerKeyTxt);

      IF ConsumerSecret = '' THEN
        AzureKeyVaultManagement.GetAzureKeyVaultSecret(ConsumerSecret,ConsumerSecretTxt);

      Consumer := Consumer.Consumer(ConsumerKey,ConsumerSecret);
      Token := Token.Token(MSQBOSetup."Token Key",MSQBOSetup."Token Secret");
      OAuthAuthorization := OAuthAuthorization.OAuthAuthorization(Consumer,Token);
      RealmId := MSQBOSetup."Realm Id";
      PageSize := 100;
      Initialized := TRUE;
    END;

    PROCEDURE SetConsumerKeySecret@13(NewConsumerKey@1001 : Text;NewConsumerSecret@1000 : Text);
    BEGIN
      ConsumerKey := NewConsumerKey;
      ConsumerSecret := NewConsumerSecret;
    END;

    PROCEDURE GetEntity@27(ID@1002 : Text[250];EntityName@1001 : Text;VAR JToken@1000 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JToken");
    VAR
      JObject@1004 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JObject";
      Request@1003 : Text;
    BEGIN
      Request := STRSUBSTNO('/v3/company/%1/%2/%3?minorversion=4',RealmId,LOWERCASE(EntityName),ID);
      InvokeQuickBooksRESTRequest('GET',Request,EntityName,JObject,JToken,TRUE);
    END;

    PROCEDURE GetEntities@36(Query@1001 : Text;EntityName@1012 : Text;VAR JToken@1003 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JToken");
    VAR
      ResultJSONManagement@1008 : Codeunit 5459;
      CurrentJSONManagement@1006 : Codeunit 5459;
      HttpUtility@1013 : DotNet "'System.Web, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'.System.Web.HttpUtility";
      CurrentJtokenArray@1007 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JToken";
      JObject@1004 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JObject";
      JsonArray@1000 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JArray";
      Request@1002 : Text;
      QueryEncoded@1005 : Text;
      NbChildren@1009 : Integer;
      StartPosition@1010 : Integer;
    BEGIN
      StartPosition := 1;
      JsonArray := JsonArray.JArray;
      ResultJSONManagement.InitializeEmptyCollection;
      REPEAT
        QueryEncoded :=
          HttpUtility.UrlEncode(Query + STRSUBSTNO(StartPositionTxt,StartPosition) + STRSUBSTNO(QueryCountTxt,PageSize));
        Request := STRSUBSTNO('/v3/company/%1/query?query=%2&minorversion=4',RealmId,QueryEncoded);
        IF NOT InvokeQuickBooksRESTRequest('GET',Request,EntityName,JObject,CurrentJtokenArray,TRUE) THEN
          EXIT;

        IF NOT (FORMAT(CurrentJtokenArray.GetType) = FORMAT(JsonArray.GetType)) THEN
          ERROR(ExpectedAnArrayErr);

        CurrentJSONManagement.InitializeCollectionFromJArray(CurrentJtokenArray);
        NbChildren := CurrentJSONManagement.GetCollectionCount;
        IF NbChildren > 0 THEN
          ResultJSONManagement.AddJArrayContentToCollection(CurrentJtokenArray);
        IF NbChildren = PageSize THEN
          StartPosition := StartPosition + PageSize;
      UNTIL NbChildren < PageSize;
      ResultJSONManagement.GetJsonArray(JToken);
    END;

    PROCEDURE CreateEntity@37(EntityName@1000 : Text;JObject@1002 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JObject";VAR JToken@1003 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JToken") : Boolean;
    VAR
      Request@1001 : Text;
    BEGIN
      Request := STRSUBSTNO('/v3/company/%1/%2?minorversion=4',RealmId,LOWERCASE(EntityName));
      EXIT(InvokeQuickBooksRESTRequest('POST',Request,EntityName,JObject,JToken,TRUE));
    END;

    PROCEDURE UpdateEntity@38(EntityName@1002 : Text;JObject@1005 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JObject";VAR JToken@1000 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JToken") : Boolean;
    VAR
      Request@1004 : Text;
    BEGIN
      Request := STRSUBSTNO('/v3/company/%1/%2?minorversion=4',RealmId,LOWERCASE(EntityName));
      EXIT(InvokeQuickBooksRESTRequest('POST',Request,EntityName,JObject,JToken,TRUE));
    END;

    PROCEDURE DeleteEntity@39(EntityName@1003 : Text;JObject@1004 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JObject";VAR JToken@1001 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JToken");
    VAR
      Request@1000 : Text;
    BEGIN
      Request := STRSUBSTNO('/v3/company/%1/%2?operation=delete&minorversion=4',RealmId,LOWERCASE(EntityName));
      InvokeQuickBooksRESTRequest('POST',Request,EntityName,JObject,JToken,TRUE);
    END;

    PROCEDURE InvokeService@15(EntityName@1003 : Text;JObject@1002 : DotNet "'Newtonsoft.Json, Version=9.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed'.Newtonsoft.Json.Linq.JObject";VAR JToken@1001 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JToken");
    VAR
      Request@1000 : Text;
    BEGIN
      Request := STRSUBSTNO('/v3/company/%1/taxservice/taxcode?minorversion=4',RealmId);
      InvokeQuickBooksRESTRequest('POST',Request,EntityName,JObject,JToken,FALSE);
    END;

    PROCEDURE RegisterWebhookListener@21(RealmId@1004 : Text[250];JObject@1000 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JObject";AccessToken@1003 : Text) : Boolean;
    VAR
      StringContent@1002 : DotNet "'System.Net.Http, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'.System.Net.Http.StringContent";
      Response@1008 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.String";
      Encoding@1006 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Text.Encoding";
      Request@1001 : Text;
      AuthorizationHeader@1005 : Text;
      WasRequestSuccessful@1007 : Boolean;
    BEGIN
      Request := STRSUBSTNO('/api/v1.0/qboforward/%1',RealmId);
      AuthorizationHeader := STRSUBSTNO('Bearer %1',AccessToken);

      StringContent := StringContent.StringContent(JObject.ToString,Encoding.UTF8,JsonMediaTypeTxt);
      InvokeRestRequest('PUT',WebhooksAdapterMgt.GetWebhooksAdapterUri(FALSE),AuthorizationHeader,Request,
        StringContent,WasRequestSuccessful,Response,JsonMediaTypeTxt);
      EXIT(WasRequestSuccessful);
    END;

    PROCEDURE GetTextFromJToken@7(JToken@1000 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JToken";Path@1001 : Text) : Text;
    VAR
      SelectedJToken@1002 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JToken";
    BEGIN
      SelectedJToken := JToken.SelectToken(Path);

      IF NOT ISNULL(SelectedJToken) THEN
        EXIT(FORMAT(SelectedJToken));
    END;

    PROCEDURE GetBooleanFromJToken@35(JToken@1000 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JToken";Path@1001 : Text) : Boolean;
    VAR
      SelectedJToken@1002 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JToken";
      Result@1003 : Boolean;
    BEGIN
      SelectedJToken := JToken.SelectToken(Path);

      IF NOT ISNULL(SelectedJToken) THEN
        EVALUATE(Result,FORMAT(SelectedJToken));

      EXIT(Result);
    END;

    PROCEDURE GetIntegerFromJToken@23(JToken@1001 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JToken";Path@1000 : Text) : Integer;
    VAR
      SelectedJToken@1003 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JToken";
      Result@1002 : Integer;
    BEGIN
      SelectedJToken := JToken.SelectToken(Path);

      IF NOT ISNULL(SelectedJToken) THEN
        EVALUATE(Result,FORMAT(SelectedJToken));

      EXIT(Result);
    END;

    PROCEDURE GetDecimalFromJToken@24(JToken@1001 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JToken";Path@1000 : Text) : Decimal;
    VAR
      SelectedJToken@1003 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JToken";
      Result@1002 : Decimal;
    BEGIN
      SelectedJToken := JToken.SelectToken(Path);

      IF NOT ISNULL(SelectedJToken) THEN
        EVALUATE(Result,FORMAT(SelectedJToken));

      EXIT(Result);
    END;

    PROCEDURE GetDateFromJToken@25(JToken@1001 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JToken";Path@1000 : Text) : Date;
    VAR
      SelectedJToken@1003 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JToken";
      Result@1002 : Date;
    BEGIN
      SelectedJToken := JToken.SelectToken(Path);

      IF NOT ISNULL(SelectedJToken) THEN
        EVALUATE(Result,FORMAT(SelectedJToken,0,9),9);

      EXIT(Result);
    END;

    PROCEDURE GetDateTimeFromJToken@4(JToken@1001 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JToken";Path@1000 : Text) : DateTime;
    VAR
      SelectedJToken@1003 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JToken";
      Result@1002 : DateTime;
    BEGIN
      SelectedJToken := JToken.SelectToken(Path);

      IF NOT ISNULL(SelectedJToken) THEN
        EVALUATE(Result,FORMAT(SelectedJToken));

      EXIT(Result);
    END;

    PROCEDURE GetNestedValue@14(RecordRef@1004 : RecordRef;FieldNo@1005 : Integer;Path@1001 : Text) : Text;
    VAR
      JSONManagement@1003 : Codeunit 5459;
      Value@1006 : Variant;
      JObject@1002 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JObject";
      JsonText@1000 : Text;
    BEGIN
      JsonText := GetTextValueFromField(RecordRef.FIELD(FieldNo));

      JSONManagement.TryParseJObjectFromString(JObject,JsonText);
      JSONManagement.GetPropertyValueFromJObjectByPath(JObject,Path,Value);
      EXIT(FORMAT(Value));
    END;

    PROCEDURE SetNestedValue@8(VAR RecordRef@1003 : RecordRef;FieldNo@1004 : Integer;Path@1006 : Text;NewValue@1005 : Text) : Boolean;
    VAR
      JSONManagement@1002 : Codeunit 5459;
      FieldRef@1001 : FieldRef;
      JObject@1000 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JObject";
    BEGIN
      FieldRef := RecordRef.FIELD(FieldNo);
      GetJsonObjectFromField(FieldRef,JObject);

      JSONManagement.ReplaceOrAddDescendantJPropertyInJObject(JObject,Path,NewValue);

      EXIT(AssignValueFromText(FORMAT(JObject),FieldRef));
    END;

    PROCEDURE SetNestedValues@9(VAR FieldRef@1001 : FieldRef;Paths@1006 : ARRAY [10] OF Text;NewValues@1005 : ARRAY [10] OF Text;maxCounter@1004 : Integer) ValueChanged : Boolean;
    VAR
      JSONManagement@1002 : Codeunit 5459;
      JObject@1000 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JObject";
      counter@1003 : Integer;
    BEGIN
      GetJsonObjectFromField(FieldRef,JObject);

      FOR counter := 1 TO maxCounter DO BEGIN
        ValueChanged := ValueChanged OR
          JSONManagement.ReplaceOrAddDescendantJPropertyInJObject(JObject,Paths[counter],NewValues[counter]);
        WriteTextToField(FieldRef,FORMAT(JObject));
      END;
    END;

    LOCAL PROCEDURE GetJsonObjectFromField@10(FieldRef@1000 : FieldRef;VAR JObject@1002 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JObject");
    VAR
      JSONManagement@1004 : Codeunit 5459;
    BEGIN
      JSONManagement.InitializeObject(GetTextValueFromField(FieldRef));
      JSONManagement.GetJSONObject(JObject);
    END;

    PROCEDURE GetMessageHandler@17(MessageHandler@1000 : DotNet "'System.Net.Http, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'.System.Net.Http.HttpMessageHandler");
    BEGIN
      MessageHandler := HttpMessageHandler;
    END;

    PROCEDURE SetMessageHandler@19(MessageHandler@1000 : DotNet "'System.Net.Http, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'.System.Net.Http.HttpMessageHandler");
    BEGIN
      HttpMessageHandler := MessageHandler;
    END;

    PROCEDURE AssignValueFromField@5(SourceFieldRef@1004 : FieldRef;VAR DestinationFieldRef@1001 : FieldRef) : Boolean;
    VAR
      SourceValueAsText@1006 : Text;
    BEGIN
      SourceValueAsText := GetTextValueFromField(SourceFieldRef);
      EXIT(AssignValueFromText(SourceValueAsText,DestinationFieldRef));
    END;

    PROCEDURE AssignValueFromText@6(NewTextValue@1001 : Text;VAR DestinationFieldRef@1000 : FieldRef) ValueChanged : Boolean;
    VAR
      DestinationValueAsText@1003 : Text;
    BEGIN
      DestinationValueAsText := GetTextValueFromField(DestinationFieldRef);

      IF NewTextValue = DestinationValueAsText THEN
        ValueChanged := FALSE
      ELSE BEGIN
        WriteTextToField(DestinationFieldRef,NewTextValue);
        ValueChanged := TRUE;
      END;
    END;

    PROCEDURE GetTextValueFromField@2(FieldRef@1000 : FieldRef) Result : Text;
    VAR
      TypeHelper@1001 : Codeunit 10;
    BEGIN
      CASE FORMAT(FieldRef.TYPE) OF
        'Text',
        'Code',
        'DateTime',
        'Integer',
        'Decimal',
        'Date',
        'Boolean',
        'Option':
          EVALUATE(Result,FORMAT(FieldRef.VALUE,0,9));
        'BLOB':
          Result := TypeHelper.ReadBlob(FieldRef);
      END;
    END;

    PROCEDURE WriteTextToField@1(VAR DestinationFieldRef@1001 : FieldRef;TextToWrite@1000 : Text);
    VAR
      TypeHelper@1010 : Codeunit 10;
      Variant@1009 : Variant;
      BooleanVar@1002 : Boolean;
      DateTimeVar@1003 : DateTime;
      IntegerVar@1006 : Integer;
      DecimalVar@1008 : Decimal;
      DummyDateVar@1007 : Date;
    BEGIN
      CASE FORMAT(DestinationFieldRef.TYPE) OF
        'Text',
        'Code':
          DestinationFieldRef.VALUE := COPYSTR(TextToWrite,1,DestinationFieldRef.LENGTH);
        'Boolean':
          BEGIN
            EVALUATE(BooleanVar,TextToWrite);
            DestinationFieldRef.VALUE := BooleanVar;
          END;
        'DateTime':
          BEGIN
            EVALUATE(DateTimeVar,TextToWrite);
            DestinationFieldRef.VALUE := DateTimeVar;
          END;
        'Integer':
          BEGIN
            EVALUATE(IntegerVar,TextToWrite);
            DestinationFieldRef.VALUE := IntegerVar;
          END;
        'Decimal':
          BEGIN
            EVALUATE(DecimalVar,TextToWrite);
            DestinationFieldRef.VALUE := DecimalVar;
          END;
        'Date':
          BEGIN
            Variant := DummyDateVar;
            TypeHelper.Evaluate(Variant,TextToWrite,'yyyy-MM-dd','en-US');
            DestinationFieldRef.VALUE := Variant;
          END;
        'Option':
          DestinationFieldRef.VALUE := TypeHelper.GetOptionNo(TextToWrite,DestinationFieldRef.OPTIONSTRING);
        'BLOB':
          TypeHelper.WriteBlob(DestinationFieldRef,TextToWrite);
      END;
    END;

    PROCEDURE InvokeQuickBooksRESTRequest@18(RequestMethod@1006 : Text;Request@1004 : Text;EntityName@1003 : Text;JObject@1002 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JObject";VAR JToken@1001 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JToken";ReturnArray@1000 : Boolean) JsonParsed : Boolean;
    VAR
      StringContent@1010 : DotNet "'System.Net.Http, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'.System.Net.Http.StringContent";
      Response@1008 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.String";
      Encoding@1007 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Text.Encoding";
      AuthorizationHeader@1005 : Text;
      WasRequestSuccessful@1009 : Boolean;
      RequestBody@1011 : Text;
      ResponseText@1012 : Text;
    BEGIN
      IF ISNULL(OAuthAuthorization) THEN BEGIN
        ConnectionErrorOccured(STRSUBSTNO(NotInitializedErr,CODEUNIT::"MS-QBO Table Mgt."));
        EXIT;
      END;

      AuthorizationHeader := OAuthAuthorization.GetAuthorizationHeader(BaseUrlTxt + Request,UPPERCASE(RequestMethod));

      IF NOT ISNULL(JObject) THEN BEGIN
        StringContent := StringContent.StringContent(JObject.ToString,Encoding.UTF8,JsonMediaTypeTxt);
        RequestBody := JObject.ToString;
      END;
      InvokeRestRequest(RequestMethod,BaseUrlTxt,AuthorizationHeader,Request,StringContent,WasRequestSuccessful,
        Response,JsonMediaTypeTxt);
      JsonParsed := ParseResponseAsJson(Request,Response,EntityName,ReturnArray,WasRequestSuccessful,JToken);
      ResponseText := Response;
      IF (NOT WasRequestSuccessful) OR (NOT JsonParsed) THEN
        OnBadQuickBooksResponse(RequestMethod,BaseUrlTxt + Request,RequestBody,ResponseText);
    END;

    PROCEDURE InvokeReconnectRequest@20(VAR ResultXmlDocument@1003 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlDocument") : Boolean;
    VAR
      XMLDOMManagement@1007 : Codeunit 6224;
      StringContent@1005 : DotNet "'System.Net.Http, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'.System.Net.Http.StringContent";
      Response@1002 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.String";
      RequestMethod@1000 : Text;
      AuthorizationHeader@1001 : Text;
      WasRequestSuccessful@1004 : Boolean;
      ResponseText@1006 : Text;
    BEGIN
      IF ISNULL(OAuthAuthorization) THEN BEGIN
        ConnectionErrorOccured(STRSUBSTNO(NotInitializedErr,CODEUNIT::"MS-QBO Table Mgt."));
        EXIT;
      END;

      RequestMethod := 'GET';

      AuthorizationHeader := OAuthAuthorization.GetAuthorizationHeader(ReconnectUrlTxt + ReconnectTxt,RequestMethod);

      InvokeRestRequest(RequestMethod,ReconnectUrlTxt,AuthorizationHeader,ReconnectTxt,StringContent,
        WasRequestSuccessful,Response,'application/xml');
      ResponseText := Response;
      IF WasRequestSuccessful THEN BEGIN
        XMLDOMManagement.LoadXMLDocumentFromText(Response,ResultXmlDocument);
        EXIT(TRUE);
      END;
      OnBadQuickBooksResponse(RequestMethod,ReconnectUrlTxt + ReconnectTxt,'',ResponseText);
    END;

    [Integration]
    LOCAL PROCEDURE OnBadQuickBooksResponse@11(RequestMethod@1000 : Text;Request@1001 : Text;RequestBody@1002 : Text;ResponseTxt@1003 : Text);
    BEGIN
    END;

    LOCAL PROCEDURE InvokeRestRequest@40(RequestMethod@1018 : Text;Url@1021 : Text;AuthorizationHeader@1002 : Text;Request@1016 : Text;StringContent@1000 : DotNet "'System.Net.Http, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'.System.Net.Http.StringContent";VAR WasRequestSuccessful@1003 : Boolean;VAR Response@1001 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.String";ExpectedEncoding@1004 : Text);
    VAR
      HttpClient@1013 : DotNet "'System.Net.Http, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'.System.Net.Http.HttpClient";
      HttpRequestHeaders@1011 : DotNet "'System.Net.Http, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'.System.Net.Http.Headers.HttpRequestHeaders";
      HttpHeaderValueCollection@1010 : DotNet "'System.Net.Http, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'.System.Net.Http.Headers.HttpHeaderValueCollection`1";
      HttpResponseMessage@1009 : DotNet "'System.Net.Http, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'.System.Net.Http.HttpResponseMessage";
      HttpContent@1008 : DotNet "'System.Net.Http, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'.System.Net.Http.HttpContent";
      MediaTypeWithQualityHeaderValue@1007 : DotNet "'System.Net.Http, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'.System.Net.Http.Headers.MediaTypeWithQualityHeaderValue";
      Uri@1006 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Uri";
      Task@1005 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Threading.Tasks.Task`1";
    BEGIN
      IF ISNULL(HttpMessageHandler) THEN
        HttpClient := HttpClient.HttpClient
      ELSE
        HttpClient := HttpClient.HttpClient(HttpMessageHandler);

      HttpClient.BaseAddress := Uri.Uri(Url);
      HttpRequestHeaders := HttpClient.DefaultRequestHeaders;
      HttpRequestHeaders.TryAddWithoutValidation('Authorization',AuthorizationHeader);
      HttpHeaderValueCollection := HttpRequestHeaders.Accept;
      MediaTypeWithQualityHeaderValue :=
        MediaTypeWithQualityHeaderValue.MediaTypeWithQualityHeaderValue(ExpectedEncoding);
      HttpHeaderValueCollection.Add(MediaTypeWithQualityHeaderValue);

      CASE UPPERCASE(RequestMethod) OF
        'GET':
          Task := HttpClient.GetAsync(Request);
        'PUT':
          Task := HttpClient.PutAsync(Request,StringContent);
        'POST':
          Task := HttpClient.PostAsync(Request,StringContent);
        ELSE BEGIN
          ConnectionErrorOccured(HttpRequestMethodNotSupportedErr);
          EXIT;
        END;
      END;

      HttpResponseMessage := Task.Result;
      HttpContent := HttpResponseMessage.Content;
      Task := HttpContent.ReadAsStringAsync;

      HttpClient.Dispose;

      WasRequestSuccessful := HttpResponseMessage.IsSuccessStatusCode;
      Response := Task.Result;
    END;

    LOCAL PROCEDURE ParseResponseAsJson@30(Request@1006 : Text;Response@1000 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.String";EntityName@1008 : Text;ReturnArray@1002 : Boolean;WasRequestSuccessful@1001 : Boolean;VAR JToken@1003 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JToken") : Boolean;
    VAR
      JSONManagement@1010 : Codeunit 5459;
      JObject2@1004 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JObject";
      ErrorMessage@1005 : DotNet "'mscorlib'.System.Text.StringBuilder";
      JsonArray@1009 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JArray";
      TokenName@1007 : Text;
    BEGIN
      IF NOT JSONManagement.TryParseJObjectFromString(JObject2,Response) THEN BEGIN
        ConnectionErrorOccured(FORMAT(Response));
        EXIT;
      END;

      IF NOT WasRequestSuccessful THEN BEGIN
        GetErrors(JObject2,ErrorMessage);
        ValidationFaultOccured(ErrorMessage.ToString);
        EXIT;
      END;

      // Check if response contains multiple entities
      IF STRPOS(LOWERCASE(Request),'query') <> 0 THEN
        TokenName := 'QueryResponse.';
      JToken := JObject2.SelectToken(TokenName + EntityName,FALSE);
      IF ISNULL(JToken) THEN
        IF ReturnArray THEN
          JToken := JsonArray.JArray
        ELSE
          JToken := JObject2;

      EXIT(TRUE);
    END;

    LOCAL PROCEDURE GetErrors@76(JObjectError@1005 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JObject";VAR ErrorMessage@1007 : DotNet "'mscorlib'.System.Text.StringBuilder");
    VAR
      JToken@1006 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JToken";
      ChildJToken@1003 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JToken";
      Element@1008 : Text;
      Message@1009 : Text;
      Detail@1010 : Text;
    BEGIN
      ErrorMessage := ErrorMessage.StringBuilder;
      ErrorMessage.AppendLine(ErrorsTxt);
      ErrorMessage.AppendLine;
      ErrorMessage.AppendLine(STRSUBSTNO(FaultTypeTxt,GetTextFromJToken(JObjectError,'Fault.type')));

      // Parse Errors
      JToken := JObjectError.SelectToken('Fault.Error',TRUE);
      ChildJToken := JToken.First;

      WHILE NOT ISNULL(ChildJToken) DO BEGIN
        Element := GetTextFromJToken(ChildJToken,'element');
        // Element exists
        IF Element <> '' THEN
          ErrorMessage.AppendLine(STRSUBSTNO(FieldtErr,Element));

        Message := GetTextFromJToken(ChildJToken,'Message');
        // Message exists
        IF Message <> '' THEN
          ErrorMessage.AppendLine(STRSUBSTNO(MessageTxt,Message));

        Detail := GetTextFromJToken(ChildJToken,'Detail');
        // Detail exists
        IF Detail <> '' THEN
          ErrorMessage.AppendLine(STRSUBSTNO(DetailTxt,Detail));

        ErrorMessage.AppendLine;
        ChildJToken := ChildJToken.Next;
      END;
    END;

    PROCEDURE IsInitialized@12() : Boolean;
    BEGIN
      EXIT(Initialized);
    END;

    PROCEDURE GetKeyvaultAccessFailedTxt@29() : Text[1024];
    BEGIN
      EXIT(KeyvaultAccessFailedTxt);
    END;

    PROCEDURE AreRecordsDifferent@16(VAR MSQBOModifiedFieldList@1007 : Record 7823;NewRecordRef@1000 : RecordRef;OldRecordRef@1001 : RecordRef) RecordsAreDifferent : Boolean;
    VAR
      Field@1008 : Record 2000000041;
      TypeHelper@1009 : Codeunit 10;
      MSQBOTableMgt@1006 : Codeunit 7820;
      FirstFieldRef@1005 : FieldRef;
      SecondFieldRef@1004 : FieldRef;
    BEGIN
      IF NewRecordRef.NUMBER <> OldRecordRef.NUMBER THEN
        ERROR(CannotCompareDiffTablesErr,NewRecordRef.RECORDID,OldRecordRef.RECORDID);

      CLEAR(MSQBOModifiedFieldList);
      MSQBOModifiedFieldList.DELETEALL;

      IF TypeHelper.FindFields(NewRecordRef.NUMBER,Field) THEN
        REPEAT
          FirstFieldRef := NewRecordRef.FIELD(Field."No.");
          SecondFieldRef := OldRecordRef.FIELD(Field."No.");
          IF FieldShouldBeUsedToCompareValues(FirstFieldRef) THEN
            IF MSQBOTableMgt.GetTextValueFromField(FirstFieldRef) <> MSQBOTableMgt.GetTextValueFromField(SecondFieldRef) THEN BEGIN
              MSQBOModifiedFieldList.ExtractValueFromRecord(FirstFieldRef);
              RecordsAreDifferent := TRUE;
            END;
        UNTIL Field.NEXT = 0;
    END;

    PROCEDURE PopulateModifiedFieldListFromRecordId@32(VAR MSQBOModifiedFieldList@1001 : Record 7823;RecordID@1000 : RecordID);
    VAR
      Field@1005 : Record 2000000041;
      TypeHelper@1006 : Codeunit 10;
      RecordRef@1002 : RecordRef;
      FieldRef@1003 : FieldRef;
    BEGIN
      RecordRef.GET(RecordID);
      IF TypeHelper.FindFields(RecordRef.NUMBER,Field) THEN
        REPEAT
          FieldRef := RecordRef.FIELD(Field."No.");
          IF FieldShouldBeUsedToCompareValues(FieldRef) THEN
            MSQBOModifiedFieldList.ExtractValueFromRecord(FieldRef);
        UNTIL Field.NEXT = 0;
    END;

    LOCAL PROCEDURE FieldShouldBeUsedToCompareValues@26(FieldRef@1000 : FieldRef) : Boolean;
    VAR
      Item@1001 : Record 27;
      Customer@1002 : Record 18;
    BEGIN
      IF FieldRef.NUMBER = 0 THEN // time stamp values
        EXIT(FALSE);

      CASE FieldRef.RECORD.NUMBER OF
        DATABASE::Item:
          EXIT(FieldRef.CAPTION IN [Item.FIELDCAPTION("Unit Price"),
                                    Item.FIELDCAPTION("Unit Cost"),
                                    Item.FIELDCAPTION(Description)]);
        DATABASE::Customer:
          EXIT(FieldRef.CAPTION IN [Customer.FIELDCAPTION(Name),
                                    Customer.FIELDCAPTION("Tax Liable"),
                                    Customer.FIELDCAPTION("Phone No."),
                                    Customer.FIELDCAPTION(Address),
                                    Customer.FIELDCAPTION("Country/Region Code"),
                                    Customer.FIELDCAPTION("Post Code"),
                                    Customer.FIELDCAPTION(City),
                                    Customer.FIELDCAPTION("E-Mail")]);
      END;
      EXIT(TRUE);
    END;

    PROCEDURE GetLastUpdatedTimeAsUtc@22(QBOTableNum@1000 : Integer) : DateTime;
    VAR
      MSQBOCustomer@1001 : Record 7820;
      MSQBOItem@1002 : Record 7821;
      DateFilterCalc@1003 : Codeunit 358;
    BEGIN
      CASE QBOTableNum OF
        DATABASE::"MS-QBO Customer":
          BEGIN
            MSQBOCustomer.SETCURRENTKEY("MetaData LastUpdatedTime");
            IF MSQBOCustomer.FINDLAST THEN
              EXIT(DateFilterCalc.ConvertToUtcDateTime(MSQBOCustomer."MetaData LastUpdatedTime"));
          END;
        DATABASE::"MS-QBO Item":
          BEGIN
            MSQBOItem.SETCURRENTKEY("MetaData LastUpdatedTime");
            IF MSQBOItem.FINDLAST THEN
              EXIT(DateFilterCalc.ConvertToUtcDateTime(MSQBOItem."MetaData LastUpdatedTime"));
          END;
      END;
    END;

    [Integration]
    LOCAL PROCEDURE ConnectionErrorOccured@33(ErrorMessage@1000 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.String");
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE ValidationFaultOccured@34(ErrorMessage@1000 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.String");
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE GetConsumerKeyAndSecretText@31(TargetApplication@1002 : 'InvoicingApp,BusinessCenter,NativeInvoicingApp';VAR ConsumerKey@1001 : Text;VAR ConsumerSecret@1000 : Text);
    BEGIN
    END;

    BEGIN
    END.
  }
}

