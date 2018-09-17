OBJECT Codeunit 9033 Invite External Accountant
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      ErrorAcquiringTokenTxt@1000 : TextConst '@@@={Locked};DAN=Failed to acquire an access token.  This is necessary to invite the external accountant.  Contact your administrator.;ENU=Failed to acquire an access token.  This is necessary to invite the external accountant.  Contact your administrator.';
      InviteReedemUrlTxt@1001 : TextConst '@@@={Locked};DAN=inviteRedeemUrl;ENU=inviteRedeemUrl';
      InvitedUserIdTxt@1002 : TextConst '@@@={Locked};DAN=invitedUser;ENU=invitedUser';
      IdTxt@1003 : TextConst '@@@={Locked};DAN=id;ENU=id';
      ConsumedUnitsTxt@1004 : TextConst '@@@={Locked};DAN=consumedUnits;ENU=consumedUnits';
      ErrorTxt@1005 : TextConst '@@@={Locked};DAN=error;ENU=error';
      MessageTxt@1006 : TextConst '@@@={Locked};DAN=message;ENU=message';
      ValueTxt@1007 : TextConst '@@@={Locked};DAN=value;ENU=value';
      RoleTemplateIdTxt@1008 : TextConst '@@@={Locked};DAN=roleTemplateId;ENU=roleTemplateId';
      SkuIdTxt@1009 : TextConst '@@@={Locked};DAN=skuId;ENU=skuId';
      PrepaidUnitsTxt@1010 : TextConst '@@@={Locked};DAN=prepaidUnits;ENU=prepaidUnits';
      EnabledUnitsTxt@1011 : TextConst '@@@={Locked};DAN=enabled;ENU=enabled';
      GlobalAdministratorRoleTemplateIdTxt@1012 : TextConst '@@@={Locked};DAN=62e90394-69f5-4237-9190-012177145e10;ENU=62e90394-69f5-4237-9190-012177145e10';
      UserAdministratorRoleTemplateIdTxt@1013 : TextConst '@@@={Locked};DAN=fe930be7-5e62-47db-91af-98c3a49a38b1;ENU=fe930be7-5e62-47db-91af-98c3a49a38b1';
      ExternalAccountantLicenseSkuIdTxt@1014 : TextConst '@@@={Locked};DAN=9a1e33ed-9697-43f3-b84c-1b0959dbb1d4;ENU=9a1e33ed-9697-43f3-b84c-1b0959dbb1d4';
      TenantTxt@1016 : TextConst '@@@={Locked};DAN="TENANT ID:  %1.  ";ENU="TENANT ID:  %1.  "';
      CountryTxt@1018 : TextConst '@@@={Locked};DAN="Country:  %1.  ";ENU="Country:  %1.  "';
      InviteExternalAccountantTelemetryCategoryTxt@1019 : TextConst '@@@={Locked};DAN=AL Dynamics 365 Invite External Accountant;ENU=AL Dynamics 365 Invite External Accountant';
      InviteExternalAccountantTelemetryStartTxt@1020 : TextConst '@@@={Locked};DAN=Invite External Accountant process started.;ENU=Invite External Accountant process started.';
      InviteExternalAccountantTelemetryEndTxt@1021 : TextConst '@@@={Locked};DAN=Invite External Accountant process ended with the following result:  %1:  %2;ENU=Invite External Accountant process ended with the following result:  %1:  %2';
      InviteExternalAccountantTelemetryLicenseFailTxt@1022 : TextConst '@@@={Locked};DAN=Invite External Accountant wizard failed to start due to there being no external accountant license avaialble.;ENU=Invite External Accountant wizard failed to start due to there being no external accountant license avaialble.';
      InviteExternalAccountantTelemetryAADPermissionFailTxt@1023 : TextConst '@@@={Locked};DAN=Invite External Accountant wizard failed to start due to the user not having the necessary AAD permissions.;ENU=Invite External Accountant wizard failed to start due to the user not having the necessary AAD permissions.';
      InviteExternalAccountantTelemetryUserTablePermissionFailTxt@1028 : TextConst '@@@={Locked};DAN=Invite External Accountant wizard failed to start due to the session not being admin or the user being Super in all companies.;ENU=Invite External Accountant wizard failed to start due to the session not being admin or the user being Super in all companies.';
      InviteExternalAccountantTelemetryCreateNewUserSuccessTxt@1029 : TextConst '@@@={Locked};DAN=Invite External Accountant wizard successfully created a new user.;ENU=Invite External Accountant wizard successfully created a new user.';
      InviteExternalAccountantTelemetryCreateNewUserFailedTxt@1030 : TextConst '@@@={Locked};DAN=Invite External Accountant wizard was unable to create a new user.;ENU=Invite External Accountant wizard was unable to create a new user.';
      ResponseCodeTxt@1024 : TextConst '@@@={Locked};DAN=responseCode;ENU=responseCode';
      EmailAddressIsConsumerAccountTxt@1025 : TextConst 'DAN=Mailadressen ser ud til at v�re en privat mailadresse. Angiv din revisors arbejdsmailadresse for at forts�tte.;ENU=The email address looks like a personal email address.  Enter your accountant''s work email address to continue.';
      EmailAddressIsInvalidTxt@1026 : TextConst 'DAN=Mailadressen er ugyldig. Angiv din revisors arbejdsmailadresse for at forts�tte.;ENU=The email address is invalid.  Enter your accountant''s work email address to continue.';
      InsufficientDataReturnedFromInvitationsApiTxt@1027 : TextConst 'DAN=Utilstr�kkelig oplysninger blev returneret, da brugeren blev anmodet om. Kontakt systemadministratoren.;ENU=Insufficient information was returned when inviting the user. Please contact your administrator.';
      AccountantPortalTelemetryCategoryTxt@1031 : TextConst '@@@={Locked};DAN=AL Dynamics 365 Accountant Hub;ENU=AL Dynamics 365 Accountant Hub';
      AccountantPortalTelemetryGoToCompanyTxt@1015 : TextConst '@@@={Locked};DAN=EVENT:  Accountant Portal user logged into their clients company from the embedded company detail page.;ENU=EVENT:  Accountant Portal user logged into their clients company from the embedded company detail page.';

    PROCEDURE InvokeInvitationsRequest@2(DisplayName@1007 : Text;EmailAddress@1026 : Text;WebClientUrl@1027 : Text;VAR InvitedUserId@1000 : GUID;VAR InviteReedemUrl@1009 : Text;VAR ErrorMessage@1001 : Text) : Boolean;
    VAR
      JSONManagement@1002 : Codeunit 5459;
      JsonObject@1017 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JObject";
      InviteUserIdJsonObject@1024 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JObject";
      InviteUserIdObjectValue@1022 : Text;
      ResponseContent@1020 : Text;
      Body@1008 : Text;
      FoundInviteRedeemUrlValue@1028 : Boolean;
      FoundInvitedUserObjectValue@1029 : Boolean;
      FoundInviteUserIdValue@1030 : Boolean;
    BEGIN
      Body := '{';
      Body := Body + '"invitedUserDisplayName" : "' + DisplayName + '",';
      Body := Body + '"invitedUserEmailAddress" : "' + EmailAddress + '",';
      Body := Body + '"inviteRedirectUrl" : "' + WebClientUrl + '",';
      Body := Body + '"sendInvitationMessage" : "false"';
      Body := Body + '}';

      IF InvokeRequestWithGraphAccessToken(GetGraphInvitationsUrl,'POST',Body,ResponseContent) THEN BEGIN
        JSONManagement.InitializeObject(ResponseContent);
        JSONManagement.GetJSONObject(JsonObject);
        FoundInviteRedeemUrlValue :=
          JSONManagement.GetStringPropertyValueFromJObjectByName(JsonObject,InviteReedemUrlTxt,InviteReedemUrl);
        FoundInvitedUserObjectValue :=
          JSONManagement.GetStringPropertyValueFromJObjectByName(JsonObject,InvitedUserIdTxt,InviteUserIdObjectValue);
        JSONManagement.InitializeObject(InviteUserIdObjectValue);
        JSONManagement.GetJSONObject(InviteUserIdJsonObject);
        FoundInviteUserIdValue := JSONManagement.GetGuidPropertyValueFromJObjectByName(InviteUserIdJsonObject,IdTxt,InvitedUserId);

        IF FoundInviteRedeemUrlValue AND FoundInvitedUserObjectValue AND FoundInviteUserIdValue THEN
          EXIT(TRUE);

        ErrorMessage := InsufficientDataReturnedFromInvitationsApiTxt;
        EXIT(FALSE);
      END;

      ErrorMessage := GetMessageFromErrorJSON(ResponseContent);
      EXIT(FALSE);
    END;

    PROCEDURE InvokeUserProfileUpdateRequest@12(VAR GuestGraphUser@1002 : DotNet "'Microsoft.Azure.ActiveDirectory.GraphClient, Version=1.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Azure.ActiveDirectory.GraphClient.IUser";CountryLetterCode@1008 : Text;VAR ErrorMessage@1003 : Text) : Boolean;
    VAR
      Body@1004 : Text;
      ResponseContent@1006 : Text;
      GraphUserUrl@1007 : Text;
    BEGIN
      GraphUserUrl := GetGraphUserUrl + '/' + GuestGraphUser.ObjectId;
      Body := '{"usageLocation" : "' + CountryLetterCode + '"}';

      // Set usage location on guest user to current tenant's country letter code.
      IF InvokeRequestWithGraphAccessToken(GraphUserUrl,'PATCH',Body,ResponseContent) THEN
        EXIT(TRUE);

      ErrorMessage := GetMessageFromErrorJSON(ResponseContent);
      EXIT(FALSE);
    END;

    PROCEDURE InvokeUserAssignLicenseRequest@22(VAR GraphUser@1003 : DotNet "'Microsoft.Azure.ActiveDirectory.GraphClient, Version=1.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Azure.ActiveDirectory.GraphClient.IUser";VAR ErrorMessage@1007 : Text) : Boolean;
    VAR
      Body@1004 : Text;
      ResponseContent@1005 : Text;
      Url@1006 : Text;
    BEGIN
      Url := GetGraphUserUrl + '/' + GraphUser.ObjectId + '/assignLicense';

      Body := '{';
      Body := Body + '"addLicenses": [';
      Body := Body + '{';
      Body := Body + '"disabledPlans": [],';
      Body := Body + '"skuId": "9a1e33ed-9697-43f3-b84c-1b0959dbb1d4"';
      Body := Body + '}],';
      Body := Body + '"removeLicenses": []';
      Body := Body + '}';

      IF InvokeRequestWithGraphAccessToken(Url,'POST',Body,ResponseContent) THEN
        EXIT(TRUE);

      ErrorMessage := GetMessageFromErrorJSON(ResponseContent);
      EXIT(FALSE);
    END;

    PROCEDURE InvokeIsExternalAccountantLicenseAvailable@23(VAR ErrorMessage@1001 : Text) : Boolean;
    VAR
      JSONManagement@1002 : Codeunit 5459;
      JsonObject@1003 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JObject";
      JsonArray@1004 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JArray";
      PrepaidUnitsJsonObject@1005 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JObject";
      NumberSkus@1006 : Integer;
      ResponseContent@1007 : Text;
      SkuIdValue@1008 : Text;
      ConsumedUnitsValue@1009 : Decimal;
      PrepaidUnitsValue@1010 : Text;
      EnabledUnitsValue@1011 : Decimal;
    BEGIN
      IF InvokeRequestWithGraphAccessToken(GetGraphSubscribedSkusUrl,'GET','',ResponseContent) THEN BEGIN
        JSONManagement.InitializeObject(ResponseContent);
        JSONManagement.GetJSONObject(JsonObject);
        JSONManagement.GetArrayPropertyValueFromJObjectByName(JsonObject,ValueTxt,JsonArray);
        JSONManagement.InitializeCollectionFromJArray(JsonArray);

        NumberSkus := JSONManagement.GetCollectionCount;
        WHILE NumberSkus > 0 DO BEGIN
          NumberSkus := NumberSkus - 1;
          JSONManagement.GetJObjectFromCollectionByIndex(JsonObject,NumberSkus);
          JSONManagement.GetStringPropertyValueFromJObjectByName(JsonObject,SkuIdTxt,SkuIdValue);
          JSONManagement.GetDecimalPropertyValueFromJObjectByName(JsonObject,ConsumedUnitsTxt,ConsumedUnitsValue);

          // Check to see if there is an external accountant license available.
          IF SkuIdValue = ExternalAccountantLicenseSkuIdTxt THEN BEGIN
            JSONManagement.GetStringPropertyValueFromJObjectByName(JsonObject,PrepaidUnitsTxt,PrepaidUnitsValue);
            JSONManagement.InitializeObject(PrepaidUnitsValue);
            JSONManagement.GetJSONObject(PrepaidUnitsJsonObject);
            JSONManagement.GetDecimalPropertyValueFromJObjectByName(PrepaidUnitsJsonObject,EnabledUnitsTxt,EnabledUnitsValue);

            IF ConsumedUnitsValue < EnabledUnitsValue THEN
              EXIT(TRUE);

            EXIT(FALSE);
          END;
        END;
      END;

      ErrorMessage := GetMessageFromErrorJSON(ResponseContent);
      EXIT(FALSE);
    END;

    PROCEDURE VerifySMTPIsEnabledAndSetup@36() : Boolean;
    VAR
      SMTPMail@1010 : Codeunit 400;
    BEGIN
      IF NOT SMTPMail.IsEnabled THEN
        EXIT(FALSE);

      EXIT(TRUE);
    END;

    PROCEDURE InvokeEmailAddressIsAADAccount@38(EmailAddress@1010 : Text;VAR ErrorMessage@1011 : Text) : Boolean;
    VAR
      JSONManagement@1012 : Codeunit 5459;
      JsonObject@1013 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JObject";
      ResponseContent@1016 : Text;
      Url@1017 : Text;
      Body@1018 : Text;
      ResponseCodeValue@1019 : Text;
    BEGIN
      Url := GetSignupPrefix + 'api/signupservice/usersignup?api-version=1';
      Body := '{"emailaddress": "' + EmailAddress + '","skuid": "basic","skipVerificationEmail": true}';

      InvokeRequestWithSignupAccessToken(Url,'POST',Body,ResponseContent);
      JSONManagement.InitializeObject(ResponseContent);
      JSONManagement.GetJSONObject(JsonObject);
      JSONManagement.GetStringPropertyValueFromJObjectByName(JsonObject,ResponseCodeTxt,ResponseCodeValue);
      CASE ResponseCodeValue OF
        'Success':
          EXIT(TRUE);
        'UserExists':
          EXIT(TRUE);
        'ConsumerDomainNotAllowed':
          ErrorMessage := EmailAddressIsConsumerAccountTxt;
        ELSE
          ErrorMessage := EmailAddressIsInvalidTxt;
      END;

      EXIT(FALSE);
    END;

    PROCEDURE InvokeIsUserAdministrator@3(VAR ErrorMessage@1001 : Text) : Boolean;
    VAR
      JSONManagement@1002 : Codeunit 5459;
      JsonObject@1003 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JObject";
      JsonArray@1004 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JArray";
      NumberDirectoryRoles@1005 : Integer;
      ResponseContent@1006 : Text;
      RoleTemplateIdValue@1007 : Text;
    BEGIN
      IF InvokeRequestWithGraphAccessToken(GetGraphMemberOfUrl,'GET','',ResponseContent) THEN BEGIN
        JSONManagement.InitializeObject(ResponseContent);
        JSONManagement.GetJSONObject(JsonObject);
        JSONManagement.GetArrayPropertyValueFromJObjectByName(JsonObject,ValueTxt,JsonArray);
        JSONManagement.InitializeCollectionFromJArray(JsonArray);

        NumberDirectoryRoles := JSONManagement.GetCollectionCount;
        WHILE NumberDirectoryRoles > 0 DO BEGIN
          NumberDirectoryRoles := NumberDirectoryRoles - 1;
          JSONManagement.GetJObjectFromCollectionByIndex(JsonObject,NumberDirectoryRoles);
          JSONManagement.GetStringPropertyValueFromJObjectByName(JsonObject,RoleTemplateIdTxt,RoleTemplateIdValue);

          // Check to see if user is assigned to global/company administrator or user administrator AAD roles.
          IF (RoleTemplateIdValue = GlobalAdministratorRoleTemplateIdTxt) OR
             (RoleTemplateIdValue = UserAdministratorRoleTemplateIdTxt)
          THEN
            EXIT(TRUE);
        END;

        EXIT(FALSE);
      END;

      ErrorMessage := GetMessageFromErrorJSON(ResponseContent);
      EXIT(FALSE);
    END;

    PROCEDURE CreateNewUser@42(InvitedUserId@1003 : GUID);
    VAR
      AzureADUserManagement@1001 : Codeunit 9010;
      GuestGraphUser@1002 : DotNet "'Microsoft.Azure.ActiveDirectory.GraphClient, Version=1.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Azure.ActiveDirectory.GraphClient.IUser";
      Graph@1004 : DotNet "'Microsoft.Dynamics.Nav.AzureADGraphClient, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.AzureADGraphClient.GraphQuery";
      Count@1005 : Integer;
    BEGIN
      Graph := Graph.GraphQuery;

      REPEAT
        SLEEP(2000);
        Count := Count + 1;
        GuestGraphUser := Graph.GetUserByObjectId(InvitedUserId);
      UNTIL (GuestGraphUser.AssignedPlans.Count > 1) OR (Count = 10);

      IF GuestGraphUser.AssignedPlans.Count > 1 THEN BEGIN
        OnInvitationCreateNewUser(TRUE);
        AzureADUserManagement.CreateNewUserFromGraphUser(GuestGraphUser);
      END ELSE
        OnInvitationCreateNewUser(FALSE);
    END;

    PROCEDURE UpdateAssistedSetup@37();
    VAR
      AssistedSetup@1010 : Record 1803;
    BEGIN
      IF AssistedSetup.WRITEPERMISSION THEN
        IF AssistedSetup.GET(PAGE::"Invite External Accountant") THEN BEGIN
          AssistedSetup.VALIDATE(Status,AssistedSetup.Status::Completed);
          AssistedSetup.MODIFY(TRUE);
        END;
    END;

    LOCAL PROCEDURE InvokeRequestWithGraphAccessToken@39(Url@1010 : Text;Verb@1011 : Text;Body@1012 : Text;VAR ResponseContent@1013 : Text) : Boolean;
    BEGIN
      EXIT(InvokeRequest(Url,Verb,Body,GetGraphPrefix,ResponseContent));
    END;

    LOCAL PROCEDURE InvokeRequestWithSignupAccessToken@40(Url@1010 : Text;Verb@1011 : Text;Body@1012 : Text;VAR ResponseContent@1013 : Text) : Boolean;
    BEGIN
      EXIT(InvokeRequest(Url,Verb,Body,GetSignupPrefix,ResponseContent));
    END;

    LOCAL PROCEDURE InvokeRequest@24(Url@1007 : Text;Verb@1008 : Text;Body@1010 : Text;AuthResourceUrl@1031 : Text;VAR ResponseContent@1009 : Text) : Boolean;
    VAR
      TempBlob@1021 : Record 99008535;
      AzureADMgt@1006 : Codeunit 6300;
      IdentityManagement@1020 : Codeunit 9801;
      HttpWebRequestMgt@1022 : Codeunit 1297;
      WebRequestHelper@1023 : Codeunit 1299;
      HttpStatusCode@1024 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Net.HttpStatusCode";
      ResponseHeaders@1025 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.Specialized.NameValueCollection";
      WebException@1026 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Net.WebException";
      InStr@1027 : InStream;
      AccessToken@1005 : Text;
      ServiceUrl@1029 : Text;
      ChunkText@1028 : Text;
      WasSuccessful@1030 : Boolean;
    BEGIN
      AccessToken := AzureADMgt.GetGuestAccessToken(AuthResourceUrl,IdentityManagement.GetAadTenantId);

      IF AccessToken = '' THEN BEGIN
        ResponseContent := ErrorAcquiringTokenTxt;
        EXIT(FALSE);
      END;

      HttpWebRequestMgt.Initialize(Url);
      HttpWebRequestMgt.DisableUI;
      HttpWebRequestMgt.SetReturnType('application/json');
      HttpWebRequestMgt.SetContentType('application/json');
      HttpWebRequestMgt.SetMethod(Verb);
      HttpWebRequestMgt.AddHeader('Authorization','Bearer ' + AccessToken);
      IF Verb <> 'GET' THEN
        HttpWebRequestMgt.AddBodyAsText(Body);

      TempBlob.INIT;
      TempBlob.Blob.CREATEINSTREAM(InStr);
      IF HttpWebRequestMgt.GetResponse(InStr,HttpStatusCode,ResponseHeaders) THEN
        WasSuccessful := TRUE
      ELSE BEGIN
        WebRequestHelper.GetWebResponseError(WebException,ServiceUrl);
        WebException.Response.GetResponseStream.CopyTo(InStr);
        WasSuccessful := FALSE;
      END;

      WHILE NOT InStr.EOS DO BEGIN
        InStr.READTEXT(ChunkText);
        ResponseContent += ChunkText;
      END;

      EXIT(WasSuccessful);
    END;

    LOCAL PROCEDURE GetMessageFromErrorJSON@25(ResponseContent@1001 : Text) : Text;
    VAR
      JSONManagement@1002 : Codeunit 5459;
      JsonObject@1003 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JObject";
      ErrorObjectValue@1004 : Text;
      MessageValue@1005 : Text;
    BEGIN
      JSONManagement.InitializeObject(ResponseContent);
      JSONManagement.GetJSONObject(JsonObject);
      JSONManagement.GetStringPropertyValueFromJObjectByName(JsonObject,ErrorTxt,ErrorObjectValue);
      JSONManagement.InitializeObject(ErrorObjectValue);
      JSONManagement.GetJSONObject(JsonObject);
      JSONManagement.GetStringPropertyValueFromJObjectByName(JsonObject,MessageTxt,MessageValue);
      EXIT(MessageValue);
    END;

    LOCAL PROCEDURE GetGraphInvitationsUrl@4() : Text;
    BEGIN
      IF IsPPE THEN
        EXIT('https://graph.microsoft-ppe.com/beta/invitations');

      EXIT('https://graph.microsoft.com/v1.0/invitations');
    END;

    LOCAL PROCEDURE GetGraphUserUrl@26() : Text;
    BEGIN
      IF IsPPE THEN
        EXIT('https://graph.microsoft-ppe.com/v1.0/users');

      EXIT('https://graph.microsoft.com/v1.0/users');
    END;

    LOCAL PROCEDURE GetGraphMemberOfUrl@27() : Text;
    BEGIN
      IF IsPPE THEN
        EXIT('https://graph.microsoft-ppe.com/v1.0/me/memberOf/microsoft.graph.directoryRole');

      EXIT('https://graph.microsoft.com/v1.0/me/memberOf/microsoft.graph.directoryRole');
    END;

    LOCAL PROCEDURE GetGraphSubscribedSkusUrl@28() : Text;
    BEGIN
      IF IsPPE THEN
        EXIT('https://graph.microsoft-ppe.com/v1.0/subscribedSkus');

      EXIT('https://graph.microsoft.com/v1.0/subscribedSkus');
    END;

    LOCAL PROCEDURE GetGraphPrefix@5() : Text;
    BEGIN
      IF IsPPE THEN
        EXIT('https://graph.microsoft-ppe.com');

      EXIT('https://graph.microsoft.com');
    END;

    LOCAL PROCEDURE GetSignupPrefix@41() : Text;
    BEGIN
      IF IsPPE THEN
        EXIT('https://signupppe.microsoft.com/');

      EXIT('https://signup.microsoft.com/');
    END;

    LOCAL PROCEDURE IsPPE@29() : Boolean;
    VAR
      EnvironmentMgt@1000 : Codeunit 9005;
    BEGIN
      IF EnvironmentMgt.IsPPE THEN
        EXIT(TRUE);

      EXIT(FALSE);
    END;

    [EventSubscriber(Page,9033,OnInvitationStart)]
    LOCAL PROCEDURE SendTelemetryForInvitationStart@31();
    BEGIN
      SENDTRACETAG('0000178',InviteExternalAccountantTelemetryCategoryTxt,VERBOSITY::Normal,GetTelemetryCommonInformation +
        InviteExternalAccountantTelemetryStartTxt);
    END;

    [EventSubscriber(Page,9033,OnInvitationNoExternalAccountantLicenseFail)]
    LOCAL PROCEDURE SendTelemetryForInvitationNoExternalAccountantLicenseFail@32();
    BEGIN
      SENDTRACETAG('0000179',InviteExternalAccountantTelemetryCategoryTxt,VERBOSITY::Error,GetTelemetryCommonInformation +
        InviteExternalAccountantTelemetryLicenseFailTxt);
    END;

    [EventSubscriber(Page,9033,OnInvitationNoAADPermissionsFail)]
    LOCAL PROCEDURE SendTelemetryForInvitationNoAADPermissionsFail@33();
    BEGIN
      SENDTRACETAG('000017A',InviteExternalAccountantTelemetryCategoryTxt,VERBOSITY::Error,GetTelemetryCommonInformation +
        InviteExternalAccountantTelemetryAADPermissionFailTxt);
    END;

    [EventSubscriber(Page,9033,OnInvitationNoUserTablePermissionsFail)]
    LOCAL PROCEDURE SendTelemetryForInvitationNoUserTableWritePermissionsFail@43();
    BEGIN
      SENDTRACETAG('00001DK',InviteExternalAccountantTelemetryCategoryTxt,VERBOSITY::Error,GetTelemetryCommonInformation +
        InviteExternalAccountantTelemetryUserTablePermissionFailTxt);
    END;

    [EventSubscriber(Page,9033,OnInvitationEnd)]
    LOCAL PROCEDURE SendTelemetryForInvitationEnd@34(WasInvitationSuccessful@1001 : Boolean;Result@1002 : Text;Progress@1003 : Text);
    BEGIN
      IF WasInvitationSuccessful THEN
        SENDTRACETAG('000017B',InviteExternalAccountantTelemetryCategoryTxt,VERBOSITY::Normal,GetTelemetryCommonInformation +
          STRSUBSTNO(InviteExternalAccountantTelemetryEndTxt,Result,Progress))
      ELSE
        SENDTRACETAG('000017C',InviteExternalAccountantTelemetryCategoryTxt,VERBOSITY::Error,GetTelemetryCommonInformation +
          STRSUBSTNO(InviteExternalAccountantTelemetryEndTxt,Result,Progress));
    END;

    [EventSubscriber(Codeunit,9033,OnInvitationCreateNewUser)]
    LOCAL PROCEDURE SendTelemetryForInvitationCreateNewUser@45(UserCreated@1000 : Boolean);
    BEGIN
      IF UserCreated THEN
        SENDTRACETAG('00001DL',InviteExternalAccountantTelemetryCategoryTxt,VERBOSITY::Normal,GetTelemetryCommonInformation +
          InviteExternalAccountantTelemetryCreateNewUserSuccessTxt)
      ELSE
        SENDTRACETAG('00001DM',InviteExternalAccountantTelemetryCategoryTxt,VERBOSITY::Error,GetTelemetryCommonInformation +
          InviteExternalAccountantTelemetryCreateNewUserFailedTxt);
    END;

    [EventSubscriber(Page,1156,OnGoToCompany)]
    LOCAL PROCEDURE SendTelemetryForAccountantHubGoToClient@1();
    BEGIN
      SENDTRACETAG('00001HR',AccountantPortalTelemetryCategoryTxt,VERBOSITY::Normal,GetTelemetryCommonInformation +
        AccountantPortalTelemetryGoToCompanyTxt);
    END;

    LOCAL PROCEDURE GetTelemetryCommonInformation@35() : Text;
    VAR
      Graph@1001 : DotNet "'Microsoft.Dynamics.Nav.AzureADGraphClient, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.AzureADGraphClient.GraphQuery";
    BEGIN
      Graph := Graph.GraphQuery;
      EXIT(STRSUBSTNO(TenantTxt,Graph.GetTenantDetail.ObjectId) +
        STRSUBSTNO(CountryTxt,Graph.GetTenantDetail.CountryLetterCode));
    END;

    [Integration]
    LOCAL PROCEDURE OnInvitationCreateNewUser@44(UserCreated@1000 : Boolean);
    BEGIN
      // This event is called when the invitation process tries to create a user.
    END;

    BEGIN
    END.
  }
}

