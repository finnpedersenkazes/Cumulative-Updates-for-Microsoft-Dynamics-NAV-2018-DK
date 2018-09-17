OBJECT Codeunit 1432 Net Promoter Score Mgt.
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
      DisplayDataTxt@1003 : TextConst '@@@={Locked};DAN="display/financials/?puid=%1";ENU="display/financials/?puid=%1"';
      RenderDataTxt@1004 : TextConst '@@@={Locked};DAN="render/financials/?culture=%1&puid=%2";ENU="render/financials/?culture=%1&puid=%2"';
      ClientTypeManagement@1000 : Codeunit 4;

    [Internal]
    PROCEDURE ShowNpsDialog@1() : Boolean;
    VAR
      NetPromoterScoreSetup@1002 : Record 1432;
    BEGIN
      IF NOT ShouldBePrompted THEN
        EXIT(FALSE);

      IF NetPromoterScoreSetup.GetApiUrl = '' THEN
        EXIT(FALSE);

      DisableRequestSending;

      COMMIT;
      PAGE.RUNMODAL(PAGE::"Net Promoter Score");
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE ShouldBePrompted@4() : Boolean;
    VAR
      NetPromoterScore@1001 : Record 1433;
      DisplayUrl@1004 : Text;
      RenderUrl@1000 : Text;
      Response@1010 : Text;
      Display@1006 : Boolean;
    BEGIN
      IF NOT NetPromoterScore.ShouldSendRequest THEN
        EXIT(FALSE);

      IF NOT IsNpsSupported THEN
        EXIT(FALSE);

      DisplayUrl := GetDisplayUrl;
      IF DisplayUrl = '' THEN
        EXIT(FALSE);

      RenderUrl := GetRenderUrl;
      IF RenderUrl = '' THEN
        EXIT(FALSE);

      IF NOT ExecuteWebRequest(DisplayUrl,Response) THEN
        EXIT(FALSE);

      IF NOT TryGetDisplayProperty(Response,Display) THEN
        EXIT(FALSE);

      EXIT(Display);
    END;

    [External]
    PROCEDURE IsNpsSupported@10() : Boolean;
    VAR
      PermissionManager@1002 : Codeunit 9002;
    BEGIN
      IF NOT GUIALLOWED THEN
        EXIT(FALSE);

      IF ClientTypeManagement.GetCurrentClientType IN [CLIENTTYPE::Phone,CLIENTTYPE::Tablet] THEN
        EXIT(FALSE);

      IF NOT PermissionManager.SoftwareAsAService THEN
        EXIT(FALSE);

      IF PermissionManager.IsSandboxConfiguration THEN
        EXIT(FALSE);

      IF GetApiUrl = '' THEN
        EXIT(FALSE);

      EXIT(TRUE);
    END;

    PROCEDURE TestConnection@5(BaseUrl@1001 : Text;VAR Response@1000 : Text;VAR ErrorMessage@1002 : Text) : Boolean;
    VAR
      TestUrl@1003 : Text;
      Success@1004 : Boolean;
    BEGIN
      TestUrl := GetTestUrl(BaseUrl);
      Success := ExecuteWebRequest(TestUrl,Response);
      IF NOT Success THEN
        ErrorMessage := GETLASTERRORTEXT;
      EXIT(Success);
    END;

    [TryFunction]
    [External]
    PROCEDURE ExecuteWebRequest@3(Url@1006 : Text;VAR Response@1004 : Text);
    VAR
      TempBlob@1005 : TEMPORARY Record 99008535;
      HttpWebRequestMgt@1002 : Codeunit 1297;
      HttpStatusCode@1001 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Net.HttpStatusCode";
      Headers@1000 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.Specialized.NameValueCollection";
      ResponseStream@1003 : InStream;
    BEGIN
      TempBlob.INIT;
      TempBlob.Blob.CREATEINSTREAM(ResponseStream);
      HttpWebRequestMgt.Initialize(Url);
      HttpWebRequestMgt.DisableUI;
      HttpWebRequestMgt.SetReturnType('application/json');
      HttpWebRequestMgt.AddHeader('Accept-Encoding','utf-8');
      HttpWebRequestMgt.SetMethod('GET');
      IF NOT HttpWebRequestMgt.GetResponse(ResponseStream,HttpStatusCode,Headers) THEN
        ERROR(GETLASTERRORTEXT);
      ResponseStream.READTEXT(Response);
    END;

    [Internal]
    PROCEDURE GetPuid@9() : Text;
    VAR
      IdentityManagement@1000 : Codeunit 9801;
      Puid@1001 : Text;
      Guid@1002 : GUID;
    BEGIN
      Puid := IdentityManagement.GetObjectId(USERSECURITYID);
      IF NOT EVALUATE(Guid,Puid) THEN
        Puid := '';
      EXIT(Puid);
    END;

    [External]
    PROCEDURE GetDisplayUrl@12() : Text;
    VAR
      Data@1001 : Text;
      BaseUrl@1002 : Text;
      FullUrl@1000 : Text;
    BEGIN
      Data := GetDisplayData;
      BaseUrl := GetApiUrl;
      FullUrl := GetFullUrl(BaseUrl,Data);
      EXIT(FullUrl);
    END;

    [External]
    PROCEDURE GetRenderUrl@13() : Text;
    VAR
      Data@1002 : Text;
      BaseUrl@1001 : Text;
      FullUrl@1000 : Text;
    BEGIN
      Data := GetRenderData;
      BaseUrl := GetApiUrl;
      FullUrl := GetFullUrl(BaseUrl,Data);
      EXIT(FullUrl);
    END;

    [External]
    PROCEDURE GetTestUrl@27(BaseUrl@1000 : Text) : Text;
    VAR
      Data@1001 : Text;
      FullUrl@1002 : Text;
    BEGIN
      Data := GetTestData;
      FullUrl := GetFullUrl(BaseUrl,Data);
      EXIT(FullUrl);
    END;

    LOCAL PROCEDURE GetFullUrl@7(BaseUrl@1001 : Text;Data@1003 : Text) : Text;
    VAR
      FullUrl@1002 : Text;
    BEGIN
      IF (BaseUrl <> '') AND (Data <> '') THEN
        FullUrl := STRSUBSTNO('%1%2',BaseUrl,Data);
      EXIT(FullUrl);
    END;

    LOCAL PROCEDURE GetApiUrl@2() : Text;
    VAR
      NetPromoterScoreSetup@1000 : Record 1432;
      Url@1001 : Text;
    BEGIN
      Url := NetPromoterScoreSetup.GetApiUrl;
      EXIT(Url);
    END;

    LOCAL PROCEDURE GetTestData@15() : Text;
    VAR
      Data@1001 : Text;
    BEGIN
      Data := STRSUBSTNO(DisplayDataTxt,'');
      EXIT(Data);
    END;

    LOCAL PROCEDURE GetDisplayData@18() : Text;
    VAR
      Puid@1000 : Text;
      Data@1001 : Text;
    BEGIN
      Puid := GetPuid;
      Data := STRSUBSTNO(DisplayDataTxt,Puid);
      EXIT(Data);
    END;

    LOCAL PROCEDURE GetRenderData@17() : Text;
    VAR
      TypeHelper@1003 : Codeunit 10;
      Culture@1002 : Text;
      Puid@1000 : Text;
      Data@1001 : Text;
    BEGIN
      Culture := LOWERCASE(TypeHelper.LanguageIDToCultureName(GLOBALLANGUAGE));
      Puid := GetPuid;
      Data := STRSUBSTNO(RenderDataTxt,Culture,Puid);
      EXIT(Data);
    END;

    [TryFunction]
    LOCAL PROCEDURE TryGetDisplayProperty@25(Data@1000 : Text;VAR DisplayProperty@1002 : Boolean);
    VAR
      JSONManagement@1003 : Codeunit 5459;
      JObject@1001 : DotNet "'Newtonsoft.Json, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed'.Newtonsoft.Json.Linq.JObject";
    BEGIN
      JSONManagement.InitializeObject(Data);
      JSONManagement.GetJSONObject(JObject);
      JSONManagement.GetBoolPropertyValueFromJObjectByName(JObject,'display',DisplayProperty);
    END;

    [TryFunction]
    [External]
    PROCEDURE TryGetMessageType@35(Data@1000 : Text;VAR MessageType@1002 : Text);
    VAR
      JSONManagement@1003 : Codeunit 5459;
      JObject@1001 : DotNet "'Newtonsoft.Json, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed'.Newtonsoft.Json.Linq.JObject";
    BEGIN
      JSONManagement.InitializeObject(Data);
      JSONManagement.GetJSONObject(JObject);
      JSONManagement.GetStringPropertyValueFromJObjectByName(JObject,'msgType',MessageType);
    END;

    [EventSubscriber(Codeunit,1,OnAfterCompanyOpen)]
    LOCAL PROCEDURE OnAfterCompanyUpdateRequestSendingStatus@6();
    VAR
      NetPromoterScore@1000 : Record 1433;
    BEGIN
      NetPromoterScore.UpdateRequestSendingStatus;
    END;

    [EventSubscriber(Codeunit,2,OnCompanyInitialize)]
    [External]
    PROCEDURE OnCompanyInitializeInvalidateCache@11();
    VAR
      NetPromoterScoreSetup@1000 : Record 1432;
    BEGIN
      IF NetPromoterScoreSetup.GET THEN BEGIN
        NetPromoterScoreSetup."Expire Time" := CURRENTDATETIME;
        NetPromoterScoreSetup.MODIFY;
      END;
    END;

    [External]
    PROCEDURE DisableRequestSending@8();
    VAR
      NetPromoterScore@1001 : Record 1433;
    BEGIN
      NetPromoterScore.DisableRequestSending;
    END;

    BEGIN
    END.
  }
}

