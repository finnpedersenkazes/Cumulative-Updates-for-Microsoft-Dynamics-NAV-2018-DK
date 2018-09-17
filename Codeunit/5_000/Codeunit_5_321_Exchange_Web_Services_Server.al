OBJECT Codeunit 5321 Exchange Web Services Server
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
      Service@1000 : DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.ExchangeServiceWrapper";
      ProdEndpointTxt@1002 : TextConst '@@@={Locked};DAN=https://outlook.office365.com/EWS/Exchange.asmx;ENU=https://outlook.office365.com/EWS/Exchange.asmx';
      ExpiredTokenErr@1003 : TextConst 'DAN=Pr�ver at genoprette forbindelsen. Luk og gen�bn tilf�jelsesprogrammet.;ENU=Trying to reconnect. Please close and reopen the add-in.';

    LOCAL PROCEDURE InitializeForVersion@26(AutodiscoveryEmail@1000 : Text[250];VAR ServiceUri@1003 : Text;Credentials@1004 : DotNet "'Microsoft.Exchange.WebServices, Version=15.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Exchange.WebServices.Data.ExchangeCredentials";Rediscover@1001 : Boolean;ExchangeVersion@1005 : DotNet "'Microsoft.Exchange.WebServices, Version=15.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Exchange.WebServices.Data.ExchangeVersion") Result : Boolean;
    VAR
      ServiceFactory@1002 : DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.ServiceWrapperFactory";
    BEGIN
      IF ISNULL(Service) THEN
        Service := ServiceFactory.CreateServiceWrapperForVersion(ExchangeVersion);

      IF (ServiceUri = '') AND NOT Rediscover THEN
        ServiceUri := GetEndpoint;
      Service.ExchangeServiceUrl := ServiceUri;

      IF NOT ISNULL(Credentials) THEN
        Service.SetNetworkCredential(Credentials);

      IF (Service.ExchangeServiceUrl = '') OR Rediscover THEN BEGIN
        Result := Service.AutodiscoverServiceUrl(AutodiscoveryEmail);
        ServiceUri := Service.ExchangeServiceUrl;
      END ELSE
        Result := TRUE;
    END;

    [Internal]
    PROCEDURE Initialize@3(AutodiscoveryEmail@1000 : Text[250];ServiceUri@1003 : Text;Credentials@1004 : DotNet "'Microsoft.Exchange.WebServices, Version=15.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Exchange.WebServices.Data.ExchangeCredentials";Rediscover@1001 : Boolean) Result : Boolean;
    VAR
      ExchangeVersion@1005 : DotNet "'Microsoft.Exchange.WebServices, Version=15.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Exchange.WebServices.Data.ExchangeVersion";
    BEGIN
      Result := InitializeForVersion(AutodiscoveryEmail,ServiceUri,Credentials,Rediscover,ExchangeVersion.Exchange2013);
    END;

    [Internal]
    PROCEDURE InitializeAndValidate@24(AutodiscoveryEmail@1000 : Text[250];VAR ServiceUri@1003 : Text;Credentials@1004 : DotNet "'Microsoft.Exchange.WebServices, Version=15.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Exchange.WebServices.Data.ExchangeCredentials") Result : Boolean;
    VAR
      ExchangeVersion@1005 : DotNet "'Microsoft.Exchange.WebServices, Version=15.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Exchange.WebServices.Data.ExchangeVersion";
    BEGIN
      IF ServiceUri = '' THEN
        ServiceUri := GetEndpoint;

      IF InitializeForVersion(AutodiscoveryEmail,ServiceUri,Credentials,FALSE,ExchangeVersion.Exchange2013) THEN BEGIN
        Result := ValidCredentials;

        // If the email address was not found in the exchange server (404 error) then attempt to discover the exchange service endpoint.
        IF NOT Result AND (STRPOS(GETLASTERRORTEXT,'404') > 0) THEN
          IF InitializeForVersion(AutodiscoveryEmail,ServiceUri,Credentials,TRUE,ExchangeVersion.Exchange2013) AND
             ValidCredentials
          THEN BEGIN
            Result := TRUE;
            ServiceUri := Service.ExchangeServiceUrl;
          END;
      END;
    END;

    [Internal]
    PROCEDURE Initialize2010@23(AutodiscoveryEmail@1000 : Text[250];ServiceUri@1003 : Text;Credentials@1004 : DotNet "'Microsoft.Exchange.WebServices, Version=15.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Exchange.WebServices.Data.ExchangeCredentials";Rediscover@1001 : Boolean) Result : Boolean;
    VAR
      ExchangeVersion@1005 : DotNet "'Microsoft.Exchange.WebServices, Version=15.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Exchange.WebServices.Data.ExchangeVersion";
    BEGIN
      Result := InitializeForVersion(AutodiscoveryEmail,ServiceUri,Credentials,Rediscover,ExchangeVersion.Exchange2010);
    END;

    [Internal]
    PROCEDURE InitializeWithCertificate@6(ApplicationID@1000 : GUID;Thumbprint@1001 : Text[40];AuthenticationEndpoint@1002 : Text[250];ExchangeEndpoint@1003 : Text[250];ResourceUri@1005 : Text[250]);
    VAR
      ServiceFactory@1004 : DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.ServiceWrapperFactory";
    BEGIN
      Service := ServiceFactory.CreateServiceWrapperWithCertificate(ApplicationID,Thumbprint,AuthenticationEndpoint,ResourceUri);
      Service.ExchangeServiceUrl := ExchangeEndpoint;
    END;

    [Internal]
    PROCEDURE InitializeWithOAuthToken@8(Token@1000 : Text;ExchangeEndpoint@1002 : Text);
    VAR
      AzureADMgt@1001 : Codeunit 6300;
    BEGIN
      IF ExchangeEndpoint = '' THEN
        ExchangeEndpoint := GetEndpoint;

      AzureADMgt.CreateExchangeServiceWrapperWithToken(Token,Service);
      Service.ExchangeServiceUrl := ExchangeEndpoint;
    END;

    [TryFunction]
    [Internal]
    PROCEDURE ValidCredentials@7();
    VAR
      AzureADAuthFlow@1000 : Codeunit 6303;
    BEGIN
      IF AzureADAuthFlow.CanHandle THEN
        IF NOT Service.ValidateCredentials THEN
          ERROR('');
    END;

    [Internal]
    PROCEDURE SetImpersonatedIdentity@1(Email@1000 : Text[250]);
    BEGIN
      Service.SetImpersonatedIdentity(Email);
    END;

    [Internal]
    PROCEDURE InstallApp@2(ManifestPath@1000 : InStream);
    BEGIN
      Service.InstallApp(ManifestPath);
    END;

    [Internal]
    PROCEDURE CreateAppointment@19(VAR Appointment@1000 : DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IAppointment");
    BEGIN
      Appointment := Service.CreateAppointment;
    END;

    [TryFunction]
    [Internal]
    PROCEDURE SendEmailMessageWithAttachment@22(Subject@1000 : Text;RecipientAddress@1001 : Text;BodyHTML@1004 : Text;AttachmentPath@1002 : Text;SenderAddress@1003 : Text);
    BEGIN
      Service.SendMessageAndSaveToSentItems(Subject,RecipientAddress,BodyHTML,AttachmentPath,SenderAddress,'');
    END;

    [Internal]
    PROCEDURE SaveEmailToInbox@5(EmailMessage@1005 : Text);
    BEGIN
      Service.SaveEmlMessageToInbox(EmailMessage);
    END;

    [Internal]
    PROCEDURE SaveHTMLEmailToInbox@21(EmailSubject@1000 : Text;EmailBodyHTML@1001 : Text;SenderAddress@1002 : Text;SenderName@1003 : Text;RecipientAddress@1004 : Text);
    BEGIN
      Service.SaveHtmlMessageToInbox(EmailSubject,EmailBodyHTML,SenderAddress,SenderName,RecipientAddress);
    END;

    [Internal]
    PROCEDURE GetEmailFolder@4(FolderId@1000 : Text;VAR Folder@1001 : DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IEmailFolder") : Boolean;
    BEGIN
      Folder := Service.GetEmailFolder(FolderId);
      EXIT(NOT ISNULL(Folder));
    END;

    [Internal]
    PROCEDURE IdenticalMailExists@9(SampleMessage@1006 : DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IEmailMessage";TargetFolder@1000 : DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IEmailFolder";VAR TargetMessage@1005 : DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IEmailMessage") : Boolean;
    VAR
      FindResults@1004 : DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IFindEmailsResults";
      Enumerator@1003 : DotNet "'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.IEnumerator";
      FolderOffset@1002 : Integer;
    BEGIN
      TargetFolder.UseSampleEmailAsFilter(SampleMessage);
      FolderOffset := 0;
      REPEAT
        FindResults := TargetFolder.FindEmailMessages(50,FolderOffset);
        IF FindResults.TotalCount > 0 THEN BEGIN
          Enumerator := FindResults.GetEnumerator;
          WHILE Enumerator.MoveNext DO BEGIN
            TargetMessage := Enumerator.Current;
            IF SampleMessage.Subject = TargetMessage.Subject THEN
              IF SampleMessage.Body = TargetMessage.Body THEN BEGIN
                IF CompareEmailAttachments(SampleMessage,TargetMessage) THEN
                  EXIT(TRUE);
              END;
          END;
          FolderOffset := FindResults.NextPageOffset;
        END;
      UNTIL NOT FindResults.MoreAvailable;

      EXIT(FALSE);
    END;

    LOCAL PROCEDURE CompareEmailAttachments@10(LeftMsg@1001 : DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IEmailMessage";RightMsg@1000 : DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IEmailMessage") : Boolean;
    VAR
      LeftEnum@1007 : DotNet "'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.IEnumerator";
      RightEnum@1006 : DotNet "'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.IEnumerator";
      LeftAttrib@1005 : DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IAttachment";
      RightAttrib@1004 : DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IAttachment";
      LeftFlag@1003 : Boolean;
      RightFlag@1002 : Boolean;
    BEGIN
      LeftEnum := LeftMsg.Attachments.GetEnumerator;
      RightEnum := RightMsg.Attachments.GetEnumerator;

      LeftFlag := LeftEnum.MoveNext;
      RightFlag := RightEnum.MoveNext;
      WHILE LeftFlag AND RightFlag DO BEGIN
        LeftAttrib := LeftEnum.Current;
        RightAttrib := RightEnum.Current;
        IF (LeftAttrib.ContentId <> RightAttrib.ContentId) OR (LeftAttrib.ContentType <> RightAttrib.ContentType) THEN
          EXIT(FALSE);

        LeftFlag := LeftEnum.MoveNext;
        RightFlag := RightEnum.MoveNext;
      END;

      EXIT(LeftFlag = RightFlag);
    END;

    [TryFunction]
    LOCAL PROCEDURE TryGetEmailWithAttachments@15(VAR EmailMessage@1001 : DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IEmailMessage";ItemID@1000 : Text[250]);
    BEGIN
      EmailMessage := Service.GetEmailWithAttachments(ItemID);
    END;

    [Internal]
    PROCEDURE GetEmailAndAttachments@14(ItemID@1000 : Text[250];VAR TempExchangeObject@1001 : TEMPORARY Record 1602;Action@1003 : 'InitiateSendToOCR,InitiateSendToIncomingDocuments,InitiateSendToWorkFlow';VendorNumber@1004 : Code[20]);
    VAR
      EmailMessage@1002 : DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IEmailMessage";
      Attachments@1007 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.IEnumerable";
      Attachment@1008 : DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IAttachment";
    BEGIN
      IF TryGetEmailWithAttachments(EmailMessage,ItemID) THEN BEGIN
        IF NOT ISNULL(EmailMessage) THEN
          WITH TempExchangeObject DO BEGIN
            INIT;
            VALIDATE("Item ID",EmailMessage.Id);
            VALIDATE(Type,Type::Email);
            VALIDATE(Name,EmailMessage.Subject);
            VALIDATE(Owner,USERSECURITYID);
            SetBody(EmailMessage.TextBody);
            SetContent(EmailMessage.Content);
            SetViewLink(EmailMessage.LinkUrl);
            IF NOT INSERT(TRUE) THEN
              MODIFY(TRUE);

            Attachments := EmailMessage.Attachments;
            FOREACH Attachment IN Attachments DO BEGIN
              INIT;
              VALIDATE(Type,Type::Attachment);
              VALIDATE("Item ID",Attachment.Id);
              VALIDATE(Name,Attachment.Name);
              VALIDATE("Parent ID",EmailMessage.Id);
              VALIDATE("Content Type",Attachment.ContentType);
              VALIDATE(InitiatedAction,Action);
              VALIDATE(VendorNo,VendorNumber);
              VALIDATE(IsInline,Attachment.IsInline);
              SetContent(Attachment.Content);
              IF NOT INSERT(TRUE) THEN
                MODIFY(TRUE);
            END;
          END ELSE
          ERROR(ExpiredTokenErr)
      END ELSE
        ERROR(ExpiredTokenErr)
    END;

    [Internal]
    PROCEDURE GetEmailBody@12(ItemID@1000 : Text[250]) EmailBody : Text;
    VAR
      EmailMessage@1002 : DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IEmailMessage";
    BEGIN
      IF TryGetEmailWithAttachments(EmailMessage,ItemID) AND NOT ISNULL(EmailMessage) THEN
        EmailBody := EmailMessage.TextBody
      ELSE
        ERROR(ExpiredTokenErr)
    END;

    [TryFunction]
    LOCAL PROCEDURE TryEmailHasAttachments@17(VAR HasAttachments@1001 : Boolean;ItemID@1000 : Text[250]);
    BEGIN
      HasAttachments := Service.AttachmentsExists(ItemID);
    END;

    [Internal]
    PROCEDURE EmailHasAttachments@16(ItemID@1000 : Text[250]) : Boolean;
    VAR
      HasAttachments@1001 : Boolean;
    BEGIN
      IF NOT TryEmailHasAttachments(HasAttachments,ItemID) THEN
        EXIT(FALSE);
      EXIT(HasAttachments)
    END;

    [External]
    PROCEDURE GetEndpoint@11() Endpoint : Text;
    BEGIN
      Endpoint := ProdEndpoint;
    END;

    [External]
    PROCEDURE ProdEndpoint@13() : Text;
    BEGIN
      EXIT(ProdEndpointTxt);
    END;

    [Internal]
    PROCEDURE GetCurrentUserTimeZone@20() : Text;
    BEGIN
      EXIT(Service.GetExchangeUserTimeZone);
    END;

    BEGIN
    END.
  }
}

