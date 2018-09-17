OBJECT Codeunit 2020 Image Analysis Management
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
      HttpMessageHandler@1001 : DotNet "'System.Net.Http, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'.System.Net.Http.HttpMessageHandler";
      Key@1002 : Text;
      Uri@1008 : Text;
      LimitType@1011 : 'Year,Month,Day,Hour';
      LimitValue@1012 : Integer;
      ImagePath@1003 : Text;
      SetMediaErr@1004 : TextConst 'DAN=Der opstod et problem under overf�rsel af billedfilen. Pr�v igen.;ENU=There was a problem uploading the image file. Please try again.';
      CognitiveServicesErr@1005 : TextConst '@@@=%1: Error returned from called API. %2: HTTP status code of error;DAN=Kunne ikke kontakte %1. %2 Statuskode: %3.;ENU=Could not contact the %1. %2 Status code: %3.';
      NoApiKeyUriErr@1006 : TextConst 'DAN=Hvis du vil analysere billeder, skal du angive en API-n�gle og et URI for API for Computer Vision.;ENU=To analyze images, you must provide an API key and an API URI for Computer Vision.';
      NoImageErr@1007 : TextConst 'DAN=Du har ikke overf�rt et billede til analyse.;ENU=You haven''t uploaded an image to analyze.';
      LastError@1000 : Text;
      IsLastErrorUsageLimitError@1010 : Boolean;
      GenericErrorErr@1009 : TextConst 'DAN=Der opstod en fejl i kontakten med Computer Vision-API''en. Pr�v igen, eller kontakt en administrator.;ENU=There was an error in contacting the Computer Vision API. Please try again or contact an administrator.';
      ComputerVisionApiTxt@1013 : TextConst 'DAN=Computer Vision-API;ENU=Computer Vision API';
      CustomVisionServiceTxt@1014 : TextConst 'DAN=Tilpasset Vision-tjeneste;ENU=Custom Vision Service';
      IsInitialized@1015 : Boolean;
      ChangingLimitAfterInitErr@1016 : TextConst 'DAN=Du kan ikke �ndre indstillingen for gr�nse efter initialisering.;ENU=You cannot change the limit setting after initialization.';

    [External]
    PROCEDURE Initialize@1();
    VAR
      ImageAnalysisSetup@1000 : Record 2020;
      AzureKeyVaultManagement@1002 : Codeunit 2200;
    BEGIN
      IF IsInitialized THEN
        EXIT;
      IF NOT ImageAnalysisSetup.GET THEN BEGIN
        ImageAnalysisSetup.INIT;
        ImageAnalysisSetup.INSERT;
      END;

      IF (Key = '') OR (Uri = '') THEN BEGIN
        Key := ImageAnalysisSetup.GetApiKey;
        Uri := ImageAnalysisSetup."Api Uri";
      END;

      IF LimitValue = 0 THEN BEGIN
        LimitType := ImageAnalysisSetup."Limit type";
        LimitValue := ImageAnalysisSetup."Limit value";
      END;

      IF LimitValue = 0 THEN
        SetLimitInYears(999);

      IF (Key = '') OR (Uri = '') THEN
        AzureKeyVaultManagement.GetImageAnalysisCredentials(Key,Uri,LimitType,LimitValue);

      IsInitialized := TRUE;
    END;

    [External]
    PROCEDURE SetMedia@6(MediaId@1000 : GUID);
    VAR
      TenantMedia@1001 : Record 2000000184;
      FileManagement@1002 : Codeunit 419;
    BEGIN
      IF TenantMedia.GET(MediaId) THEN BEGIN
        ImagePath := FileManagement.ServerTempFileName('');
        TenantMedia.CALCFIELDS(Content);
        TenantMedia.Content.EXPORT(ImagePath);
      END ELSE
        ERROR(SetMediaErr);
    END;

    [External]
    PROCEDURE SetImagePath@8(Path@1000 : Text);
    BEGIN
      ImagePath := Path;
    END;

    [External]
    PROCEDURE SetBlob@10(TempBlob@1000 : TEMPORARY Record 99008535);
    VAR
      FileManagement@1001 : Codeunit 419;
    BEGIN
      ImagePath := FileManagement.ServerTempFileName('');
      FileManagement.BLOBExportToServerFile(TempBlob,ImagePath);
    END;

    [External]
    PROCEDURE SetUriAndKey@14(UriValue@1000 : Text;KeyValue@1001 : Text);
    BEGIN
      Uri := UriValue;
      Key := KeyValue;
    END;

    [External]
    PROCEDURE SetLimitInYears@24(Value@1000 : Integer);
    BEGIN
      IF IsInitialized THEN
        ERROR(ChangingLimitAfterInitErr);
      IF Value <= 0 THEN
        EXIT;
      LimitType := LimitType::Year;
      LimitValue := Value;
    END;

    [External]
    PROCEDURE SetLimitInMonths@26(Value@1000 : Integer);
    BEGIN
      IF IsInitialized THEN
        ERROR(ChangingLimitAfterInitErr);
      IF Value <= 0 THEN
        EXIT;
      LimitType := LimitType::Month;
      LimitValue := Value;
    END;

    [External]
    PROCEDURE SetLimitInDays@27(Value@1000 : Integer);
    BEGIN
      IF IsInitialized THEN
        ERROR(ChangingLimitAfterInitErr);
      IF Value <= 0 THEN
        EXIT;
      LimitType := LimitType::Day;
      LimitValue := Value;
    END;

    [External]
    PROCEDURE SetLimitInHours@29(Value@1000 : Integer);
    BEGIN
      IF IsInitialized THEN
        ERROR(ChangingLimitAfterInitErr);
      IF Value <= 0 THEN
        EXIT;
      LimitType := LimitType::Hour;
      LimitValue := Value;
    END;

    [External]
    PROCEDURE AnalyzeTags@20(VAR ImageAnalysisResult@1000 : Codeunit 2021) : Boolean;
    VAR
      AnalysisType@1001 : 'Tags,Faces,Color';
    BEGIN
      EXIT(Analyze(ImageAnalysisResult,AnalysisType::Tags));
    END;

    [External]
    PROCEDURE AnalyzeColors@19(VAR ImageAnalysisResult@1000 : Codeunit 2021) : Boolean;
    VAR
      AnalysisType@1001 : 'Tags,Faces,Color';
    BEGIN
      EXIT(Analyze(ImageAnalysisResult,AnalysisType::Color));
    END;

    [External]
    PROCEDURE AnalyzeFaces@7(VAR ImageAnalysisResult@1000 : Codeunit 2021) : Boolean;
    VAR
      AnalysisType@1001 : 'Tags,Faces,Color';
    BEGIN
      EXIT(Analyze(ImageAnalysisResult,AnalysisType::Faces));
    END;

    LOCAL PROCEDURE Analyze@12(VAR ImageAnalysisResult@1000 : Codeunit 2021;AnalysisType@1001 : 'Tags,Faces,Color') : Boolean;
    VAR
      ImageAnalysisSetup@1016 : Record 2020;
      JSONManagement@1013 : Codeunit 5459;
      UsageLimitError@1017 : Text;
    BEGIN
      Initialize;
      SetLastError('',FALSE);
      OnBeforeImageAnalysis;

      IF (Key = '') OR (Uri = '') THEN
        SetLastError(NoApiKeyUriErr,FALSE)
      ELSE
        IF ImagePath = '' THEN
          SetLastError(NoImageErr,FALSE)
        ELSE
          IF ImageAnalysisSetup.IsUsageLimitReached(UsageLimitError,LimitValue,LimitType) THEN
            SetLastError(UsageLimitError,TRUE)
          ELSE
            IF InvokeAnalysis(JSONManagement,AnalysisType) THEN
              ImageAnalysisSetup.Increment(LimitType)
            ELSE
              IF LastError = '' THEN
                SetLastError(GenericErrorErr,FALSE);

      ImageAnalysisResult.SetJson(JSONManagement,AnalysisType);
      OnAfterImageAnalysis(ImageAnalysisResult);

      EXIT(NOT HasError);
    END;

    [TryFunction]
    LOCAL PROCEDURE InvokeAnalysis@18(VAR JSONManagement@1000 : Codeunit 5459;AnalysisType@1015 : 'Tags,Faces,Color');
    VAR
      HttpClient@1013 : DotNet "'System.Net.Http, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'.System.Net.Http.HttpClient";
      StreamContent@1012 : DotNet "'System.Net.Http, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'.System.Net.Http.StreamContent";
      HttpResponseMessage@1011 : DotNet "'System.Net.Http, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'.System.Net.Http.HttpResponseMessage";
      HttpRequestHeaders@1010 : DotNet "'System.Net.Http, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'.System.Net.Http.Headers.HttpRequestHeaders";
      MediaTypeWithQualityHeaderValue@1009 : DotNet "'System.Net.Http, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'.System.Net.Http.Headers.MediaTypeWithQualityHeaderValue";
      HttpContent@1008 : DotNet "'System.Net.Http, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'.System.Net.Http.HttpContent";
      HttpContentHeaders@1007 : DotNet "'System.Net.Http, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'.System.Net.Http.Headers.HttpContentHeaders";
      HttpHeaderValueCollection@1006 : DotNet "'System.Net.Http, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'.System.Net.Http.Headers.HttpHeaderValueCollection`1";
      ApiUri@1005 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Uri";
      Task@1004 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Threading.Tasks.Task`1";
      File@1003 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.File";
      FileStream@1002 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.FileStream";
      JsonResult@1001 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JObject";
      MessageText@1014 : Text;
      PostParameters@1016 : Text;
    BEGIN
      IF ISNULL(HttpMessageHandler) THEN
        HttpClient := HttpClient.HttpClient
      ELSE
        HttpClient := HttpClient.HttpClient(HttpMessageHandler);

      HttpClient.BaseAddress := ApiUri.Uri(Uri);

      HttpRequestHeaders := HttpClient.DefaultRequestHeaders;
      IF HasCustomVisionUri THEN
        HttpRequestHeaders.TryAddWithoutValidation('Prediction-Key',Key)
      ELSE BEGIN
        HttpRequestHeaders.TryAddWithoutValidation('Ocp-Apim-Subscription-Key',Key);
        PostParameters := STRSUBSTNO('?visualFeatures=%1',FORMAT(AnalysisType));
      END;
      HttpHeaderValueCollection := HttpRequestHeaders.Accept;
      MediaTypeWithQualityHeaderValue :=
        MediaTypeWithQualityHeaderValue.MediaTypeWithQualityHeaderValue('application/json');
      HttpHeaderValueCollection.Add(MediaTypeWithQualityHeaderValue);

      FileStream := File.OpenRead(ImagePath);
      StreamContent := StreamContent.StreamContent(FileStream);
      HttpContentHeaders := StreamContent.Headers;
      HttpContentHeaders.Add('Content-Type','application/octet-stream');

      Task := HttpClient.PostAsync(PostParameters,StreamContent);

      HttpResponseMessage := Task.Result;
      HttpContent := HttpResponseMessage.Content;
      Task := HttpContent.ReadAsStringAsync;
      JSONManagement.InitializeObject(Task.Result);

      FileStream.Dispose;
      StreamContent.Dispose;
      HttpClient.Dispose;

      IF NOT HttpResponseMessage.IsSuccessStatusCode THEN BEGIN
        JSONManagement.GetJSONObject(JsonResult);
        JSONManagement.GetStringPropertyValueFromJObjectByName(JsonResult,'message',MessageText);
        IF HasCustomVisionUri THEN
          SetLastError(STRSUBSTNO(CognitiveServicesErr,CustomVisionServiceTxt,MessageText,HttpResponseMessage.StatusCode),FALSE)
        ELSE
          SetLastError(STRSUBSTNO(CognitiveServicesErr,ComputerVisionApiTxt,MessageText,HttpResponseMessage.StatusCode),FALSE);
        ERROR('');
      END;
    END;

    PROCEDURE SetHttpMessageHandler@49(NewHttpMessageHandler@1000 : DotNet "'System.Net.Http, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'.System.Net.Http.HttpMessageHandler");
    BEGIN
      HttpMessageHandler := NewHttpMessageHandler;
    END;

    [External]
    PROCEDURE GetLastError@2(VAR Message@1000 : Text;VAR IsUsageLimitError@1001 : Boolean) : Boolean;
    BEGIN
      Message := LastError;
      IsUsageLimitError := IsLastErrorUsageLimitError;
      EXIT(HasError);
    END;

    LOCAL PROCEDURE SetLastError@4(ErrorMsg@1000 : Text;IsUsageLimitError@1001 : Boolean);
    BEGIN
      LastError := ErrorMsg;
      IsLastErrorUsageLimitError := IsUsageLimitError;
    END;

    [External]
    PROCEDURE GetNoImageErr@17() : Text;
    BEGIN
      EXIT(NoImageErr);
    END;

    [External]
    PROCEDURE HasError@13() : Boolean;
    BEGIN
      EXIT(LastError <> '');
    END;

    [External]
    PROCEDURE GetLimitParams@3(VAR LimitTypeOut@1001 : 'Year,Month,Day,Hour';VAR LimitValueOut@1000 : Integer);
    BEGIN
      LimitTypeOut := LimitType;
      LimitValueOut := LimitValue;
    END;

    LOCAL PROCEDURE HasCustomVisionUri@9() : Boolean;
    BEGIN
      EXIT(STRPOS(Uri,'/customvision/') <> 0);
    END;

    [Integration(TRUE)]
    LOCAL PROCEDURE OnBeforeImageAnalysis@5();
    BEGIN
    END;

    [Integration(TRUE)]
    LOCAL PROCEDURE OnAfterImageAnalysis@15(ImageAnalysisResult@1004 : Codeunit 2021);
    BEGIN
    END;

    BEGIN
    END.
  }
}

