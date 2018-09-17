OBJECT Codeunit 400 SMTP Mail
{
  OBJECT-PROPERTIES
  {
    Date=25-05-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.22292;
  }
  PROPERTIES
  {
    Permissions=TableData 409=r;
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      SMTPMailSetup@1003 : Record 409;
      Mail@1000 : DotNet "'Microsoft.Dynamics.Nav.SMTP, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.SMTP.SmtpMessage";
      Text002@1002 : TextConst '@@@="%1=file name";DAN=Den vedh‘ftede fil %1 findes ikke eller kan ikke †bnes fra programmet.;ENU=Attachment %1 does not exist or can not be accessed from the program.';
      SendResult@1004 : Text;
      Text003@1005 : TextConst '@@@="%1=an error message";DAN=Mailsystemet returnerede f›lgende fejl: "%1".;ENU=The mail system returned the following error: "%1".';
      SendErr@1001 : TextConst 'DAN=Mailen kunne ikke sendes.;ENU=The email couldn''t be sent.';
      RecipientErr@1006 : TextConst '@@@="%1 = email address";DAN=Modtageren %1 kunne ikke tilf›jes.;ENU=Could not add recipient %1.';
      BodyErr@1007 : TextConst 'DAN=Der kunne ikke f›jes tekst til br›dteksten i mailen.;ENU=Could not add text to email body.';
      AttachErr@1008 : TextConst 'DAN=Der kunne ikke f›jes en vedh‘ftet fil til mailen.;ENU=Could not add an attachment to the email.';

    [External]
    PROCEDURE CreateMessage@1(SenderName@1008 : Text;SenderAddress@1000 : Text;Recipients@1001 : Text;Subject@1004 : Text;Body@1005 : Text;HtmlFormatted@1006 : Boolean);
    BEGIN
      IF Recipients <> '' THEN
        CheckValidEmailAddresses(Recipients);
      CheckValidEmailAddresses(SenderAddress);
      SMTPMailSetup.GET;
      SMTPMailSetup.TESTFIELD("SMTP Server");
      IF NOT ISNULL(Mail) THEN BEGIN
        Mail.Dispose;
        CLEAR(Mail);
      END;
      SendResult := '';
      Mail := Mail.SmtpMessage;
      Mail.FromName := SenderName;
      Mail.FromAddress := SenderAddress;
      Mail."To" := Recipients;
      Mail.Subject := Subject;
      Mail.Body := Body;
      Mail.HtmlFormatted := HtmlFormatted;

      IF HtmlFormatted THEN
        Mail.ConvertBase64ImagesToContentId;
    END;

    [External]
    PROCEDURE TrySend@10() : Boolean;
    VAR
      Password@1000 : Text;
    BEGIN
      OnBeforeTrySend;
      SendResult := '';
      Password := SMTPMailSetup.GetPassword;
      WITH SMTPMailSetup DO
        SendResult :=
          Mail.Send(
            "SMTP Server",
            "SMTP Server Port",
            Authentication <> Authentication::Anonymous,
            "User ID",
            Password,
            "Secure Connection");
      Mail.Dispose;
      CLEAR(Mail);

      EXIT(SendResult = '');
    END;

    [External]
    PROCEDURE Send@3();
    BEGIN
      IF NOT TrySend THEN
        ShowErrorNotification(SendErr,SendResult);
    END;

    [External]
    PROCEDURE AddRecipients@4(Recipients@1000 : Text);
    VAR
      Result@1001 : Text;
    BEGIN
      CheckValidEmailAddresses(Recipients);
      Result := Mail.AddRecipients(Recipients);
      IF Result <> '' THEN
        ShowErrorNotification(STRSUBSTNO(RecipientErr,Recipients),Result);
    END;

    [External]
    PROCEDURE AddCC@5(Recipients@1000 : Text);
    VAR
      Result@1001 : Text;
    BEGIN
      CheckValidEmailAddresses(Recipients);
      Result := Mail.AddCC(Recipients);
      IF Result <> '' THEN
        ShowErrorNotification(STRSUBSTNO(RecipientErr,Recipients),Result);
    END;

    [External]
    PROCEDURE AddBCC@6(Recipients@1000 : Text);
    VAR
      Result@1001 : Text;
    BEGIN
      CheckValidEmailAddresses(Recipients);
      Result := Mail.AddBCC(Recipients);
      IF Result <> '' THEN
        ShowErrorNotification(STRSUBSTNO(RecipientErr,Recipients),Result);
    END;

    [External]
    PROCEDURE AppendBody@7(BodyPart@1000 : Text);
    VAR
      Result@1001 : Text;
    BEGIN
      Result := Mail.AppendBody(BodyPart);
      IF Result <> '' THEN
        ShowErrorNotification(BodyErr,Result);
    END;

    [External]
    PROCEDURE AddAttachment@2(Attachment@1000 : Text;FileName@1002 : Text);
    VAR
      FileManagement@1003 : Codeunit 419;
      Result@1001 : Text;
    BEGIN
      IF Attachment = '' THEN
        EXIT;
      IF NOT EXISTS(Attachment) THEN
        ERROR(Text002,Attachment);

      FileName := FileManagement.StripNotsupportChrInFileName(FileName);
      FileName := DELCHR(FileName,'=',';'); // Used for splitting multiple file names in Mail .NET component

      Result := Mail.AddAttachmentWithName(Attachment,FileName);

      IF Result <> '' THEN
        ShowErrorNotification(AttachErr,Result);
    END;

    [External]
    PROCEDURE AddAttachmentStream@15(AttachmentStream@1000 : InStream;AttachmentName@1001 : Text);
    VAR
      FileManagement@1002 : Codeunit 419;
    BEGIN
      AttachmentName := FileManagement.StripNotsupportChrInFileName(AttachmentName);

      Mail.AddAttachment(AttachmentStream,AttachmentName);
    END;

    [External]
    PROCEDURE CheckValidEmailAddresses@8(Recipients@1000 : Text);
    VAR
      MailManagement@1002 : Codeunit 9520;
    BEGIN
      MailManagement.CheckValidEmailAddresses(Recipients);
    END;

    [External]
    PROCEDURE GetLastSendMailErrorText@9() : Text;
    BEGIN
      EXIT(SendResult);
    END;

    [External]
    PROCEDURE GetSMTPMessage@35(VAR SMTPMessage@1000 : DotNet "'Microsoft.Dynamics.Nav.SMTP, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.SMTP.SmtpMessage");
    BEGIN
      SMTPMessage := Mail;
    END;

    [External]
    PROCEDURE IsEnabled@11() : Boolean;
    BEGIN
      IF SMTPMailSetup.FIND THEN
        EXIT(NOT (SMTPMailSetup."SMTP Server" = ''));

      EXIT(FALSE);
    END;

    [EventSubscriber(Table,1400,OnRegisterServiceConnection)]
    [External]
    PROCEDURE HandleSMTPRegisterServiceConnection@14(VAR ServiceConnection@1000 : Record 1400);
    VAR
      SMTPMailSetup@1001 : Record 409;
      RecRef@1002 : RecordRef;
    BEGIN
      IF NOT SMTPMailSetup.GET THEN BEGIN
        IF NOT SMTPMailSetup.WRITEPERMISSION THEN
          EXIT;
        SMTPMailSetup.INIT;
        SMTPMailSetup.INSERT;
      END;

      RecRef.GETTABLE(SMTPMailSetup);

      ServiceConnection.Status := ServiceConnection.Status::Enabled;
      IF SMTPMailSetup."SMTP Server" = '' THEN
        ServiceConnection.Status := ServiceConnection.Status::Disabled;

      WITH SMTPMailSetup DO
        ServiceConnection.InsertServiceConnection(
          ServiceConnection,RecRef.RECORDID,TABLECAPTION,'',PAGE::"SMTP Mail Setup");
    END;

    [External]
    PROCEDURE GetBody@13() : Text;
    BEGIN
      EXIT(Mail.Body);
    END;

    [Integration(TRUE)]
    PROCEDURE OnBeforeTrySend@32();
    BEGIN
    END;

    LOCAL PROCEDURE ShowErrorNotification@20(ErrorMessage@1000 : Text;SmtpResult@1002 : Text);
    VAR
      Notification@1001 : Notification;
    BEGIN
      IF GUIALLOWED THEN BEGIN
        Notification.MESSAGE := ErrorMessage;
        Notification.SCOPE := NOTIFICATIONSCOPE::LocalScope;
        Notification.ADDACTION('Details',CODEUNIT::"SMTP Mail",'ShowNotificationDetail');
        Notification.SETDATA('Details',STRSUBSTNO(Text003,SmtpResult));
        Notification.SEND;
        ERROR('');
      END;
      ERROR(Text003,SmtpResult);
    END;

    PROCEDURE ShowNotificationDetail@22(Notification@1000 : Notification);
    BEGIN
      MESSAGE(Notification.GETDATA('Details'));
    END;

    [External]
    PROCEDURE GetO365SmtpServer@17() : Text[250];
    BEGIN
      EXIT('smtp.office365.com')
    END;

    [External]
    PROCEDURE GetOutlookSmtpServer@21() : Text[250];
    BEGIN
      EXIT('smtp-mail.outlook.com')
    END;

    [External]
    PROCEDURE GetGmailSmtpServer@23() : Text[250];
    BEGIN
      EXIT('smtp.gmail.com')
    END;

    [External]
    PROCEDURE GetYahooSmtpServer@24() : Text[250];
    BEGIN
      EXIT('smtp.mail.yahoo.com')
    END;

    [External]
    PROCEDURE GetDefaultSmtpPort@18() : Integer;
    BEGIN
      EXIT(587);
    END;

    [External]
    PROCEDURE GetYahooSmtpPort@36() : Integer;
    BEGIN
      EXIT(465);
    END;

    [External]
    PROCEDURE GetDefaultSmtpAuthType@19() : Integer;
    VAR
      SMTPMailSetup@1000 : Record 409;
    BEGIN
      EXIT(SMTPMailSetup.Authentication::Basic);
    END;

    LOCAL PROCEDURE ApplyDefaultSmtpConnectionSettings@25(VAR SMTPMailSetupConfig@1000 : Record 409);
    BEGIN
      SMTPMailSetupConfig.Authentication := GetDefaultSmtpAuthType;
      SMTPMailSetupConfig."Secure Connection" := TRUE;
    END;

    [External]
    PROCEDURE ApplyOffice365Smtp@12(VAR SMTPMailSetupConfig@1000 : Record 409);
    BEGIN
      // This might be changed by the Microsoft Office 365 team.
      // Current source: http://technet.microsoft.com/library/dn554323.aspx
      SMTPMailSetupConfig."SMTP Server" := GetO365SmtpServer;
      SMTPMailSetupConfig."SMTP Server Port" := GetDefaultSmtpPort;
      ApplyDefaultSmtpConnectionSettings(SMTPMailSetupConfig);
    END;

    [External]
    PROCEDURE ApplyOutlookSmtp@34(VAR SMTPMailSetupConfig@1000 : Record 409);
    BEGIN
      // This might be changed.
      SMTPMailSetupConfig."SMTP Server" := GetOutlookSmtpServer;
      SMTPMailSetupConfig."SMTP Server Port" := GetDefaultSmtpPort;
      ApplyDefaultSmtpConnectionSettings(SMTPMailSetupConfig);
    END;

    [External]
    PROCEDURE ApplyGmailSmtp@33(VAR SMTPMailSetupConfig@1000 : Record 409);
    BEGIN
      // This might be changed.
      SMTPMailSetupConfig."SMTP Server" := GetGmailSmtpServer;
      SMTPMailSetupConfig."SMTP Server Port" := GetDefaultSmtpPort;
      ApplyDefaultSmtpConnectionSettings(SMTPMailSetupConfig);
    END;

    [External]
    PROCEDURE ApplyYahooSmtp@31(VAR SMTPMailSetupConfig@1000 : Record 409);
    BEGIN
      // This might be changed.
      SMTPMailSetupConfig."SMTP Server" := GetYahooSmtpServer;
      SMTPMailSetupConfig."SMTP Server Port" := GetYahooSmtpPort;
      ApplyDefaultSmtpConnectionSettings(SMTPMailSetupConfig);
    END;

    [External]
    PROCEDURE IsOffice365Setup@16(VAR SMTPMailSetupConfig@1000 : Record 409) : Boolean;
    BEGIN
      IF SMTPMailSetupConfig."SMTP Server" <> GetO365SmtpServer THEN
        EXIT(FALSE);

      IF SMTPMailSetupConfig."SMTP Server Port" <> GetDefaultSmtpPort THEN
        EXIT(FALSE);

      EXIT(IsSmtpConnectionSetup(SMTPMailSetupConfig));
    END;

    [External]
    PROCEDURE IsOutlookSetup@38(VAR SMTPMailSetupConfig@1000 : Record 409) : Boolean;
    BEGIN
      IF SMTPMailSetupConfig."SMTP Server" <> GetOutlookSmtpServer THEN
        EXIT(FALSE);

      IF SMTPMailSetupConfig."SMTP Server Port" <> GetDefaultSmtpPort THEN
        EXIT(FALSE);

      EXIT(IsSmtpConnectionSetup(SMTPMailSetupConfig));
    END;

    [External]
    PROCEDURE IsGmailSetup@39(VAR SMTPMailSetupConfig@1000 : Record 409) : Boolean;
    BEGIN
      IF SMTPMailSetupConfig."SMTP Server" <> GetGmailSmtpServer THEN
        EXIT(FALSE);

      IF SMTPMailSetupConfig."SMTP Server Port" <> GetDefaultSmtpPort THEN
        EXIT(FALSE);

      EXIT(IsSmtpConnectionSetup(SMTPMailSetupConfig));
    END;

    [External]
    PROCEDURE IsYahooSetup@40(VAR SMTPMailSetupConfig@1000 : Record 409) : Boolean;
    BEGIN
      IF SMTPMailSetupConfig."SMTP Server" <> GetYahooSmtpServer THEN
        EXIT(FALSE);

      IF SMTPMailSetupConfig."SMTP Server Port" <> GetYahooSmtpPort THEN
        EXIT(FALSE);

      EXIT(IsSmtpConnectionSetup(SMTPMailSetupConfig));
    END;

    LOCAL PROCEDURE IsSmtpConnectionSetup@26(VAR SMTPMailSetupConfig@1000 : Record 409) : Boolean;
    BEGIN
      IF SMTPMailSetupConfig.Authentication <> GetDefaultSmtpAuthType THEN
        EXIT(FALSE);

      IF SMTPMailSetupConfig."Secure Connection" <> TRUE THEN
        EXIT(FALSE);

      EXIT(TRUE);
    END;

    BEGIN
    END.
  }
}

