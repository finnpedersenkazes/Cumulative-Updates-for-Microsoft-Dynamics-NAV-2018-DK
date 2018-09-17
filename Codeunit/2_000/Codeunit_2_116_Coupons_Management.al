OBJECT Codeunit 2116 Coupons Management
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      O365SalesInitialSetup@1010 : Record 2110;
      HttpWebRequestMgt@1000 : Codeunit 1297;
      GraphIntContact@1001 : Codeunit 5461;
      CustomerHasACouponTxt@1002 : TextConst '@@@="%1 = the name of the customer, ex. Stan";DAN=%1 har en tilg‘ngelig kupon.;ENU=%1 has a coupon available.';
      CouponExpiredOrInvalidMsg@1003 : TextConst 'DAN=En eller flere kuponer er ikke l‘ngere gyldige.;ENU=One or more coupons are no longer valid.';
      CouponsResourceUrlTxt@1004 : TextConst '@@@={Locked};DAN=https://api.connections.ms;ENU=https://api.connections.ms';
      TypeHelper@1005 : Codeunit 10;
      CouponsContextTxt@1006 : TextConst 'DAN=Webkald for kuponer;ENU=Coupons webcall';
      GetCouponsDescriptionTxt@1007 : TextConst '@@@="%1 = the GUID of a contact";DAN=Henter kuponer for kontakt-id''et %1.;ENU=Retrieving coupons for contact ID %1.';
      RedeemCouponsDescriptionTxt@1009 : TextConst '@@@="%1 = the GUID of a contact, %1 = the guid of a coupon id";DAN=Indl›ser kuponer for kontakt-id''et %1, kupon-id''et %2.;ENU=Redeeming coupons for contact ID %1, coupon ID %2.';
      CouponsErrorTxt@1008 : TextConst '@@@="%1 = a system error message, %2 = a number (ex. 200), %3 = the response received from the server";DAN=Mislykkedes med fejlen %1, modtaget statuskode %2 og svar %3.;ENU="Failed with error %1; received status code %2 and response %3."';
      OperationTimedOutTxt@1011 : TextConst '@@@={LOCKED};DAN=The operation has timed out;ENU=The operation has timed out';
      FetchingCouponsTimedOutDisableCouponsQst@1012 : TextConst 'DAN=Det tager meget l‘ngere tid end forventet at hente kuponerne. Vil du deaktivere kuponer?;ENU=It''s taking much longer than expected to get the coupons. Would you like to disable coupons?';
      CouponsCategoryTxt@1013 : TextConst '@@@={LOCKED};DAN=AL Coupons;ENU=AL Coupons';
      GetCouponClaimsFailedResponseTelemetryTxt@1014 : TextConst '@@@={LOCKED};DAN=Get coupons failed, Status code: %1, Response: %2, Error: %3, Duration: %4, Request id: %5.;ENU=Get coupons failed, Status code: %1, Response: %2, Error: %3, Duration: %4, Request id: %5.';
      RedeemCouponClaimFailedResponseTelemetryTxt@1015 : TextConst '@@@={LOCKED};DAN=Redeem coupons failed, Status code: %1, Response: %2, Error: %3, Duration: %4, Request id: %5.;ENU=Redeem coupons failed, Status code: %1, Response: %2, Error: %3, Duration: %4, Request id: %5.';
      GetCouponClaimsSuccessResponseTelemetryTxt@1017 : TextConst '@@@={LOCKED};DAN=Get coupons succeeded, Status code: %1, Response: %2, Duration: %3, Request id: %4.;ENU=Get coupons succeeded, Status code: %1, Response: %2, Duration: %3, Request id: %4.';
      RedeemCouponClaimSuccessResponseTelemetryTxt@1016 : TextConst '@@@={LOCKED};DAN=Redeem coupons succeeded, Status code: %1, Response: %2, Duration: %3, Request id: %4.;ENU=Redeem coupons succeeded, Status code: %1, Response: %2, Duration: %3, Request id: %4.';
      NumberOfValidCouponClaimsTxt@1020 : TextConst '@@@={LOCKED};DAN=Contact %1 has %2 coupons after request id %3.;ENU=Contact %1 has %2 coupons after request id %3.';
      NoAccessTokenErr@1018 : TextConst 'DAN=Tokenet til Connections kunne ikke hentes.;ENU=Could not get the token to access Connections.';
      NotificationLifecycleMgt@1023 : Codeunit 1511;
      RequestID@1019 : Text;
      NotificationGuidTxt@1021 : TextConst '@@@={Locked};DAN=b374dbf2-669f-478d-9f06-6d5f0cc616e3;ENU=b374dbf2-669f-478d-9f06-6d5f0cc616e3';
      ExpiredNotificationGuidTxt@1022 : TextConst '@@@={Locked};DAN=2d513ea1-26a4-47ee-951a-d1511b9a269c;ENU=2d513ea1-26a4-47ee-951a-d1511b9a269c';
      CannotPostInvoiceWithCouponWhenDisabledIntegrationErr@1024 : TextConst '@@@="%1 = a invoice number";DAN=Fakturaen %1 kan ikke bogf›res. En sammenk‘det kupon kan ikke indl›ses, fordi kuponintegration er deaktiveret.;ENU=Cannot post the invoice %1. A linked coupon cannot be redeemed because coupons integration is turned off.';
      CannotPostInvoiceWithAlreadyUsedCouponErr@1025 : TextConst '@@@="%1 = a invoice number";DAN=Fakturaen %1 kan ikke bogf›res. En tilknyttet kupon er allerede blevet brugt.;ENU=Cannot post the invoice %1. A linked coupon has already been used.';

    PROCEDURE GetCouponsForGraphContactId@5(GraphContactID@1002 : Text[250]);
    VAR
      DummyO365CouponClaim@1006 : Record 2115;
      TempJSONBuffer@1003 : TEMPORARY Record 1236;
      TempCouponsJSONBuffer@1004 : TEMPORARY Record 1236;
      ActivityLog@1005 : Record 710;
      StartTime@1008 : DateTime;
      CouponsCallDuration@1009 : Duration;
      Response@1001 : Text;
      OriginalGraphContactID@1007 : Text[250];
      StatusCode@1000 : Integer;
    BEGIN
      IF GraphContactID = '' THEN
        EXIT;
      IF NOT (O365SalesInitialSetup.GET AND O365SalesInitialSetup."Coupons Integration Enabled") THEN
        EXIT;

      StartTime := CURRENTDATETIME;
      OriginalGraphContactID := GraphContactID;
      IF NOT Initialize(STRSUBSTNO('api/v1/contacts/%1/claims',TypeHelper.UrlEncode(GraphContactID)),'GET') THEN
        EXIT;

      CLEARLASTERROR;
      IF (NOT ExecuteWebServiceRequest(Response,StatusCode)) OR (StatusCode <> 200) THEN BEGIN
        CouponsCallDuration := CURRENTDATETIME - StartTime;
        ActivityLog.LogActivity(DummyO365CouponClaim,ActivityLog.Status::Failed,CouponsContextTxt,
          STRSUBSTNO(GetCouponsDescriptionTxt,OriginalGraphContactID),
          STRSUBSTNO(CouponsErrorTxt,GETLASTERRORTEXT,StatusCode,Response));
        COMMIT; // Make sure we log this success no matter what fails afterwards
        OnAfterGetCouponClaims(FALSE,OriginalGraphContactID,StatusCode,Response,CouponsCallDuration,RequestID);
        IF STRPOS(GETLASTERRORTEXT,OperationTimedOutTxt) <> 0 THEN
          IF GUIALLOWED THEN
            IF CONFIRM(FetchingCouponsTimedOutDisableCouponsQst) THEN BEGIN
              O365SalesInitialSetup.GET;
              O365SalesInitialSetup.VALIDATE("Coupons Integration Enabled",FALSE);
              O365SalesInitialSetup.MODIFY(TRUE);
            END;
        EXIT;
      END;
      CouponsCallDuration := CURRENTDATETIME - StartTime;
      ActivityLog.LogActivity(DummyO365CouponClaim,ActivityLog.Status::Success,CouponsContextTxt,
        STRSUBSTNO(GetCouponsDescriptionTxt,OriginalGraphContactID),'');
      COMMIT; // Make sure we log this success no matter what fails afterwards
      TempJSONBuffer.ReadFromText(Response);

      IF TempJSONBuffer.FindArray(TempCouponsJSONBuffer,'result') THEN
        REPEAT
          CreateOrUpdateCouponClaimFromJSONBuffer(TempCouponsJSONBuffer,OriginalGraphContactID);
        UNTIL TempCouponsJSONBuffer.NEXT = 0;
      OnAfterGetCouponClaims(TRUE,OriginalGraphContactID,StatusCode,Response,CouponsCallDuration,RequestID);
    END;

    PROCEDURE RedeemClaim@1(CustomerNo@1005 : Code[20];ClaimID@1000 : Text[250]) : Boolean;
    VAR
      ActivityLog@1002 : Record 710;
      DummyO365CouponClaim@1003 : Record 2115;
      StartTime@1008 : DateTime;
      CouponsCallDuration@1007 : Duration;
      Response@1001 : Text;
      GraphContactID@1006 : Text[250];
      OriginalGraphContactID@1009 : Text[250];
      StatusCode@1004 : Integer;
    BEGIN
      IF NOT (O365SalesInitialSetup.GET AND O365SalesInitialSetup."Coupons Integration Enabled") THEN
        EXIT(FALSE);

      IF NOT GraphIntContact.FindGraphContactIdFromCustomerNo(GraphContactID,CustomerNo) THEN
        EXIT(FALSE);

      IF (GraphContactID = '') OR (ClaimID = '') THEN
        EXIT(FALSE);

      StartTime := CURRENTDATETIME;
      OriginalGraphContactID := GraphContactID;
      IF NOT Initialize(
           STRSUBSTNO('api/v1/contacts/%1/claims/%2/redeem',TypeHelper.UrlEncode(GraphContactID),TypeHelper.UrlEncode(ClaimID)),'POST')
      THEN
        EXIT(FALSE);
      IF NOT AddBodyText('"": ""') THEN // Add empty content
        EXIT(FALSE);

      CLEARLASTERROR;
      IF (NOT ExecuteWebServiceRequest(Response,StatusCode)) OR (StatusCode <> 200) THEN BEGIN
        CouponsCallDuration := CURRENTDATETIME - StartTime;
        ActivityLog.LogActivity(DummyO365CouponClaim,ActivityLog.Status::Failed,CouponsContextTxt,
          STRSUBSTNO(RedeemCouponsDescriptionTxt,OriginalGraphContactID,ClaimID),
          STRSUBSTNO(CouponsErrorTxt,GETLASTERRORTEXT,StatusCode,Response));
        COMMIT; // Make sure we log this success no matter what fails afterwards
        OnAfterRedeemCouponClaim(FALSE,OriginalGraphContactID,StatusCode,Response,CouponsCallDuration,RequestID);
        EXIT(FALSE);
      END;
      CouponsCallDuration := CURRENTDATETIME - StartTime;
      ActivityLog.LogActivity(DummyO365CouponClaim,ActivityLog.Status::Success,CouponsContextTxt,
        STRSUBSTNO(RedeemCouponsDescriptionTxt,OriginalGraphContactID,ClaimID),'');
      COMMIT; // Make sure we log this success no matter what fails afterwards
      OnAfterRedeemCouponClaim(TRUE,OriginalGraphContactID,StatusCode,Response,CouponsCallDuration,RequestID);

      EXIT(TRUE);
    END;

    PROCEDURE ShowNotificationIfAnyNotApplied@26(SalesHeader@1002 : Record 36) : Boolean;
    VAR
      O365CouponClaim@1003 : Record 2115;
      O365SalesInitialSetup@1007 : Record 2110;
      Customer@1000 : Record 18;
      CouponsNotification@1004 : Notification;
      CouponsNotificationGuid@1006 : GUID;
      GraphContactID@1001 : Text[250];
      DocumentTypeNumber@1005 : Integer;
    BEGIN
      IF NOT (O365SalesInitialSetup.GET AND O365SalesInitialSetup."Coupons Integration Enabled") THEN
        EXIT;

      IF NOT Customer.GET(SalesHeader."Sell-to Customer No.") THEN
        EXIT;

      IF NOT GraphIntContact.FindGraphContactIdFromCustomerNo(GraphContactID,Customer."No.") THEN
        EXIT;

      // Show notification if there are coupons which have not been applied to this invoice
      O365CouponClaim.SETRANGE("Graph Contact ID",GraphContactID);
      O365CouponClaim.SETRANGE("Document Type Filter",SalesHeader."Document Type");
      O365CouponClaim.SETRANGE("Document No. Filter",SalesHeader."No.");
      O365CouponClaim.SETRANGE("Is applied",FALSE);
      O365CouponClaim.SETRANGE("Is Valid",TRUE);
      O365CouponClaim.SETFILTER(Expiration,'>=%1',SalesHeader."Document Date");
      IF O365CouponClaim.ISEMPTY THEN
        EXIT;

      EVALUATE(CouponsNotificationGuid,NotificationGuidTxt);
      CouponsNotification.ID := CouponsNotificationGuid;
      CouponsNotification.SCOPE := NOTIFICATIONSCOPE::LocalScope;
      CouponsNotification.MESSAGE := STRSUBSTNO(CustomerHasACouponTxt,Customer.Name);
      CouponsNotification.ADDACTION('View',CODEUNIT::"Display Coupons",'ShowCoupons');
      DocumentTypeNumber := SalesHeader."Document Type";
      CouponsNotification.SETDATA('DocumentType',FORMAT(DocumentTypeNumber));
      CouponsNotification.SETDATA('DocumentNo',SalesHeader."No.");
      NotificationLifecycleMgt.SendNotification(CouponsNotification,SalesHeader.RECORDID);
      EXIT(TRUE);
    END;

    PROCEDURE WarnIfExpiredOrClaimedCoupons@3(DocumentType@1001 : Option;DocumentNo@1000 : Code[20]) : Boolean;
    VAR
      O365CouponClaim@1004 : Record 2115;
      SalesHeader@1002 : Record 36;
    BEGIN
      IF NOT SalesHeader.GET(DocumentType,DocumentNo) THEN
        EXIT;

      O365CouponClaim.SETRANGE("Document Type Filter",DocumentType);
      O365CouponClaim.SETRANGE("Document No. Filter",DocumentNo);
      O365CouponClaim.SETRANGE("Is applied",TRUE);
      O365CouponClaim.SETFILTER(Expiration,'<%1',SalesHeader."Document Date");
      IF NOT O365CouponClaim.ISEMPTY THEN BEGIN
        SendWarnExpiredMessage(DocumentType,DocumentNo,SalesHeader.RECORDID);
        EXIT(TRUE);
      END;

      O365CouponClaim.SETRANGE(Expiration);
      O365CouponClaim.SETRANGE("Is Valid",FALSE);
      IF NOT O365CouponClaim.ISEMPTY THEN BEGIN
        SendWarnExpiredMessage(DocumentType,DocumentNo,SalesHeader.RECORDID);
        EXIT(TRUE);
      END;
    END;

    PROCEDURE RecallNotifications@11(RecallCouponsNotification@1002 : Boolean;RecallCouponsExpiredNotification@1003 : Boolean);
    VAR
      CouponsNotification@1000 : Notification;
      CouponsNotificationGuid@1001 : GUID;
    BEGIN
      IF RecallCouponsNotification THEN BEGIN
        EVALUATE(CouponsNotificationGuid,NotificationGuidTxt);
        CouponsNotification.ID := CouponsNotificationGuid;
        CouponsNotification.RECALL;
      END;

      IF RecallCouponsExpiredNotification THEN BEGIN
        EVALUATE(CouponsNotificationGuid,ExpiredNotificationGuidTxt);
        CouponsNotification.ID := CouponsNotificationGuid;
        CouponsNotification.RECALL;
      END;
    END;

    LOCAL PROCEDURE SendWarnExpiredMessage@8(DocumentType@1001 : Integer;DocumentNo@1000 : Code[20];InvoiceRecordId@1004 : RecordID);
    VAR
      CouponExpiredNotification@1002 : Notification;
      CouponsNotificationGuid@1003 : GUID;
    BEGIN
      EVALUATE(CouponsNotificationGuid,ExpiredNotificationGuidTxt);
      CouponExpiredNotification.ID := CouponsNotificationGuid;
      CouponExpiredNotification.SCOPE := NOTIFICATIONSCOPE::LocalScope;
      CouponExpiredNotification.MESSAGE := CouponExpiredOrInvalidMsg;
      CouponExpiredNotification.ADDACTION('View',CODEUNIT::"Display Coupons",'ShowCoupons');
      CouponExpiredNotification.SETDATA('DocumentType',FORMAT(DocumentType));
      CouponExpiredNotification.SETDATA('DocumentNo',DocumentNo);
      NotificationLifecycleMgt.SendNotification(CouponExpiredNotification,InvoiceRecordId);
    END;

    [TryFunction]
    LOCAL PROCEDURE Initialize@12(URL@1002 : Text;Method@1001 : Text[6]);
    VAR
      O365SalesInitialSetup@1003 : Record 2110;
      ActiveSession@1005 : Record 2000000110;
      AzureADMgt@1004 : Codeunit 6300;
      ApplicationManagement@1000 : Codeunit 1;
      AccessToken@1007 : Text;
      CultureName@1008 : Text;
    BEGIN
      CLEAR(RequestID);
      O365SalesInitialSetup.GET;

      AccessToken := AzureADMgt.GetOnBehalfAccessToken(CouponsResourceUrlTxt);
      IF AccessToken = '' THEN
        ERROR(NoAccessTokenErr);

      CLEAR(HttpWebRequestMgt);
      RequestID := DELCHR(CREATEGUID,'=','{}');
      HttpWebRequestMgt.Initialize(STRSUBSTNO('https://%1/%2',O365SalesInitialSetup."Engage Endpoint",URL));
      HttpWebRequestMgt.SetMethod(Method);
      HttpWebRequestMgt.SetContentType('application/json');
      HttpWebRequestMgt.SetReturnType('application/json');
      HttpWebRequestMgt.SetTimeout(5000);
      HttpWebRequestMgt.AddHeader('Authorization',STRSUBSTNO('Bearer %1',AccessToken));
      HttpWebRequestMgt.AddHeader('X-Connections-Tracking-Data',RequestID);
      IF ActiveSession.FINDFIRST THEN
        HttpWebRequestMgt.AddHeader('X-Connections-DeviceId',ActiveSession."Server Computer Name");

      HttpWebRequestMgt.AddHeader(
        'X-Connections-Client',
        STRSUBSTNO('Invoicing (%1)',ApplicationManagement.ApplicationVersion));
      IF TryGetLanguageName(GLOBALLANGUAGE,CultureName) THEN BEGIN
        HttpWebRequestMgt.AddHeader('X-Connections-RequestedLocale',CultureName);
        HttpWebRequestMgt.AddHeader('Accept-Language',CultureName);
      END ELSE
        HttpWebRequestMgt.AddHeader('Accept-Language','en');
    END;

    [TryFunction]
    LOCAL PROCEDURE ExecuteWebServiceRequest@14(VAR Response@1002 : Text;VAR StatusCode@1005 : Integer);
    VAR
      ResponseTempBlob@1000 : Record 99008535;
      ResponseInStream@1001 : InStream;
      HttpStatusCode@1004 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Net.HttpStatusCode";
      ResponseHeaders@1003 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.Specialized.NameValueCollection";
    BEGIN
      CLEAR(ResponseTempBlob);
      ResponseTempBlob.INIT;
      ResponseTempBlob.Blob.CREATEINSTREAM(ResponseInStream);

      IF NOT GUIALLOWED THEN
        HttpWebRequestMgt.DisableUI;

      IF NOT HttpWebRequestMgt.GetResponse(ResponseInStream,HttpStatusCode,ResponseHeaders) THEN
        ERROR(GETLASTERRORTEXT);
      ResponseInStream.READTEXT(Response);
      StatusCode := HttpStatusCode;
    END;

    LOCAL PROCEDURE CreateOrUpdateCouponClaimFromJSONBuffer@7(VAR TempCouponsJSONBuffer@1001 : TEMPORARY Record 1236;GraphContactID@1004 : Text[250]);
    VAR
      O365CouponClaim@1000 : Record 2115;
      StatusValue@1002 : Text;
      OfferValue@1005 : Text;
      TermsValue@1006 : Text;
      UsageValue@1007 : Text;
      ClaimAlreadyExists@1003 : Boolean;
      isDiscountPercentage@1008 : Boolean;
    BEGIN
      IF NOT TempCouponsJSONBuffer.GetPropertyValue(O365CouponClaim."Claim ID",'id') THEN
        EXIT;
      ClaimAlreadyExists := O365CouponClaim.GET(O365CouponClaim."Claim ID",GraphContactID);
      O365CouponClaim.VALIDATE("Graph Contact ID",GraphContactID);
      TempCouponsJSONBuffer.Path := 'result[*].code';
      TempCouponsJSONBuffer.GetPropertyValue(O365CouponClaim.Code,'code');
      TempCouponsJSONBuffer.Path := '';
      TempCouponsJSONBuffer.GetPropertyValue(StatusValue,'status');
      O365CouponClaim."Is Valid" := CheckIfStatusIsValid(StatusValue);

      TempCouponsJSONBuffer.GetPropertyValue(OfferValue,'offer');
      O365CouponClaim.SetOffer(OfferValue);
      TempCouponsJSONBuffer.GetPropertyValue(TermsValue,'terms');
      O365CouponClaim.SetTerms(TermsValue);
      IF NOT (TempCouponsJSONBuffer.GetPropertyValue(UsageValue,'usage') AND EVALUATE(O365CouponClaim.Usage,UsageValue)) THEN
        O365CouponClaim.Usage := O365CouponClaim.Usage::oneTime; // If we cannot determine the usage, assume onetime

      IF NOT TempCouponsJSONBuffer.GetDatePropertyValue(O365CouponClaim.Expiration,'expiry') THEN
        O365CouponClaim.Expiration := DMY2DATE(1,1,2100); // Default expiration to year 2100 if no expiration
      TempCouponsJSONBuffer.GetDecimalPropertyValue(O365CouponClaim."Discount Value",'numericValue');
      TempCouponsJSONBuffer.GetBooleanPropertyValue(isDiscountPercentage,'isDiscountPercentage');
      IF O365CouponClaim."Discount Value" = 0 THEN
        O365CouponClaim.VALIDATE("Discount Type",O365CouponClaim."Discount Type"::Custom)
      ELSE BEGIN
        IF isDiscountPercentage THEN
          O365CouponClaim.VALIDATE("Discount Type",O365CouponClaim."Discount Type"::"%")
        ELSE
          O365CouponClaim.VALIDATE("Discount Type",O365CouponClaim."Discount Type"::Amount);
      END;

      IF ClaimAlreadyExists THEN
        O365CouponClaim.MODIFY
      ELSE
        O365CouponClaim.INSERT;
    END;

    LOCAL PROCEDURE CheckIfStatusIsValid@4(Status@1000 : Text) : Boolean;
    VAR
      StatusOption@1001 : 'invalid,valid,expired,claimed,claimedAndValid';
      NumberOfStatuses@1002 : Integer;
      StatusNumber@1003 : Integer;
    BEGIN
      NumberOfStatuses := STRLEN(Status) - STRLEN(DELCHR(Status,'=',',')) + 1;
      FOR StatusNumber := 1 TO NumberOfStatuses DO
        IF EVALUATE(StatusOption,SELECTSTR(StatusNumber,Status)) THEN
          CASE StatusOption OF
            StatusOption::valid,
            StatusOption::claimedAndValid:
              EXIT(TRUE);
          END;
      EXIT(FALSE);
    END;

    [EventSubscriber(Table,36,OnAfterDeleteEvent)]
    PROCEDURE OnDeleteSalesHeaderRemoveUnusedCouponEntries@2(VAR Rec@1000 : Record 36;RunTrigger@1001 : Boolean);
    VAR
      O365CouponClaimDocLink@1002 : Record 2116;
    BEGIN
      IF Rec.ISTEMPORARY THEN
        EXIT;

      O365CouponClaimDocLink.SETRANGE("Document Type",Rec."Document Type");
      O365CouponClaimDocLink.SETRANGE("Document No.",Rec."No.");
      IF NOT O365CouponClaimDocLink.ISEMPTY THEN
        O365CouponClaimDocLink.DELETEALL;
    END;

    [TryFunction]
    LOCAL PROCEDURE AddBodyText@6(BodyText@1000 : Text);
    BEGIN
      HttpWebRequestMgt.AddBodyAsText(BodyText);
    END;

    [TryFunction]
    LOCAL PROCEDURE TryGetLanguageName@25(CultureID@1000 : Integer;VAR CultureName@1002 : Text);
    VAR
      CultureInfo@1001 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Globalization.CultureInfo";
    BEGIN
      CultureInfo := CultureInfo.CultureInfo(CultureID);
      CultureName := CultureInfo.Name;
    END;

    [EventSubscriber(Codeunit,2116,OnAfterGetCouponClaims,"",Skip,Skip)]
    LOCAL PROCEDURE LogGetCouponClaimsStatus@19(Success@1000 : Boolean;GraphContactID@1001 : Text[250];StatusCode@1002 : Integer;Response@1003 : Text;CouponsCallDuration@1004 : Duration;CallRequestID@1006 : Text);
    VAR
      O365CouponClaim@1005 : Record 2115;
    BEGIN
      IF Success THEN
        SENDTRACETAG('00001HC',CouponsCategoryTxt,VERBOSITY::Normal,
          STRSUBSTNO(GetCouponClaimsSuccessResponseTelemetryTxt,StatusCode,Response,CouponsCallDuration,CallRequestID))
      ELSE
        SENDTRACETAG('00001HD',CouponsCategoryTxt,VERBOSITY::Error,
          STRSUBSTNO(GetCouponClaimsFailedResponseTelemetryTxt,StatusCode,Response,GETLASTERRORTEXT,CouponsCallDuration,RequestID));
      O365CouponClaim.SETRANGE("Graph Contact ID",GraphContactID);
      SENDTRACETAG('00001I2',CouponsCategoryTxt,VERBOSITY::Normal,
        STRSUBSTNO(NumberOfValidCouponClaimsTxt,GraphContactID,O365CouponClaim.COUNT,CallRequestID));
    END;

    [EventSubscriber(Codeunit,2116,OnAfterRedeemCouponClaim,"",Skip,Skip)]
    LOCAL PROCEDURE LogRedeemCouponClaimStatus@20(Success@1000 : Boolean;GraphContactID@1001 : Text[250];StatusCode@1002 : Integer;Response@1003 : Text;CouponsCallDuration@1004 : Duration;CallRequestID@1005 : Text);
    BEGIN
      IF Success THEN
        SENDTRACETAG('00001HE',CouponsCategoryTxt,VERBOSITY::Normal,
          STRSUBSTNO(RedeemCouponClaimSuccessResponseTelemetryTxt,StatusCode,Response,CouponsCallDuration,CallRequestID))
      ELSE
        SENDTRACETAG('00001HF',CouponsCategoryTxt,VERBOSITY::Error,
          STRSUBSTNO(RedeemCouponClaimFailedResponseTelemetryTxt,StatusCode,Response,GETLASTERRORTEXT,CouponsCallDuration,CallRequestID));
    END;

    [Integration]
    PROCEDURE OnAfterGetCouponClaims@9(Success@1000 : Boolean;GraphContactID@1001 : Text[250];StatusCode@1002 : Integer;Response@1003 : Text;CouponsCallDuration@1004 : Duration;CallRequestID@1005 : Text);
    BEGIN
    END;

    [Integration]
    PROCEDURE OnAfterRedeemCouponClaim@10(Success@1001 : Boolean;GraphContactID@1000 : Text[250];StatusCode@1003 : Integer;Response@1002 : Text;CouponsCallDuration@1004 : Duration;CallRequestID@1005 : Text);
    BEGIN
    END;

    [EventSubscriber(Codeunit,80,OnBeforePostSalesDoc)]
    LOCAL PROCEDURE OnBeforePostSalesDocCheckCouponIntegration@18(VAR SalesHeader@1000 : Record 36);
    VAR
      O365CouponClaimDocLink@1002 : Record 2116;
      O365CouponClaim@1005 : Record 2115;
      O365PostedCouponClaim@1004 : Record 2117;
      O365SalesInitialSetup@1003 : Record 2110;
      IdentityManagement@1001 : Codeunit 9801;
    BEGIN
      IF NOT IdentityManagement.IsInvAppId THEN
        EXIT;

      O365CouponClaimDocLink.SETRANGE("Document Type",SalesHeader."Document Type");
      O365CouponClaimDocLink.SETRANGE("Document No.",SalesHeader."No.");
      IF O365CouponClaimDocLink.ISEMPTY THEN
        EXIT;

      GetCouponsForGraphContactId(O365CouponClaimDocLink."Graph Contact ID");

      O365CouponClaim.GET(O365CouponClaimDocLink."Claim ID",O365CouponClaimDocLink."Graph Contact ID");

      IF NOT O365CouponClaim."Is Valid" THEN
        ERROR(CannotPostInvoiceWithAlreadyUsedCouponErr);

      IF O365CouponClaim.Usage = O365CouponClaim.Usage::oneTime THEN BEGIN
        O365PostedCouponClaim.SETRANGE("Claim ID",O365CouponClaimDocLink."Claim ID");
        O365PostedCouponClaim.SETRANGE("Graph Contact ID",O365CouponClaimDocLink."Graph Contact ID");
        IF NOT O365PostedCouponClaim.ISEMPTY THEN
          ERROR(CannotPostInvoiceWithAlreadyUsedCouponErr);
      END;

      IF NOT (O365SalesInitialSetup.GET AND O365SalesInitialSetup."Coupons Integration Enabled") THEN
        ERROR(CannotPostInvoiceWithCouponWhenDisabledIntegrationErr,SalesHeader."No.");
    END;

    BEGIN
    END.
  }
}

