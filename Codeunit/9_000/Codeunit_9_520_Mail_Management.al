OBJECT Codeunit 9520 Mail Management
{
  OBJECT-PROPERTIES
  {
    Date=25-05-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.22292;
  }
  PROPERTIES
  {
    OnRun=BEGIN
            IF NOT IsEnabled THEN
              ERROR(MailingNotSupportedErr);
            IF NOT DoSend THEN
              ERROR(MailWasNotSendErr);
          END;

  }
  CODE
  {
    VAR
      TempEmailItem@1001 : TEMPORARY Record 9500;
      SMTPMail@1010 : Codeunit 400;
      FileManagement@1009 : Codeunit 419;
      InvalidEmailAddressErr@1008 : TextConst 'DAN=Mailadressen "%1" er ugyldig.;ENU=The email address "%1" is not valid.';
      ClientTypeManagement@1020 : Codeunit 4;
      DoEdit@1007 : Boolean;
      HideMailDialog@1011 : Boolean;
      Cancelled@1016 : Boolean;
      MailSent@1017 : Boolean;
      MailingNotSupportedErr@1013 : TextConst 'DAN=Den p�kr�vede mail underst�ttes ikke.;ENU=The required email is not supported.';
      MailWasNotSendErr@1000 : TextConst 'DAN=Mailen blev ikke sendt.;ENU=The email was not sent.';
      FromAddressWasNotFoundErr@1003 : TextConst 'DAN=Der blev ikke fundet en fra-mailadresse. Kontakt en administrator.;ENU=An email from address was not found. Contact an administrator.';
      SaveFileDialogTitleMsg@1005 : TextConst 'DAN=Gem PDF-fil;ENU=Save PDF file';
      SaveFileDialogFilterMsg@1004 : TextConst 'DAN=PDF-filer (*.pdf)|*.pdf;ENU=PDF Files (*.pdf)|*.pdf';
      OutlookSupported@1014 : Boolean;
      SMTPSupported@1015 : Boolean;
      CannotSendMailThenDownloadQst@1012 : TextConst 'DAN=Vil du hente den vedh�ftede fil?;ENU=Do you want to download the attachment?';
      CannotSendMailThenDownloadErr@1019 : TextConst 'DAN=Du kan ikke sende mailen.\Kontroll�r, at mailindstillingerne er korrekte.;ENU=You cannot send the email.\Verify that the email settings are correct.';
      OutlookNotAvailableContinueEditQst@1006 : TextConst 'DAN=Microsoft Outlook er ikke tilg�ngelig.\\Vil du forts�tte med at redigere mailen?;ENU=Microsoft Outlook is not available.\\Do you want to continue to edit the email?';
      HideSMTPError@1002 : Boolean;
      EmailAttachmentTxt@1018 : TextConst '@@@={Locked};DAN=Email.html;ENU=Email.html';

    LOCAL PROCEDURE RunMailDialog@7() : Boolean;
    VAR
      EmailDialog@1001 : Page 9700;
    BEGIN
      EmailDialog.SetValues(TempEmailItem,OutlookSupported,SMTPSupported);

      IF NOT (EmailDialog.RUNMODAL = ACTION::OK) THEN BEGIN
        Cancelled := TRUE;
        EXIT(FALSE);
      END;
      EmailDialog.GETRECORD(TempEmailItem);
      DoEdit := EmailDialog.GetDoEdit;
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE SendViaSMTP@5() : Boolean;
    BEGIN
      WITH TempEmailItem DO BEGIN
        SMTPMail.CreateMessage("From Name","From Address","Send to",Subject,GetBodyText,NOT "Plaintext Formatted");
        SMTPMail.AddAttachment("Attachment File Path","Attachment Name");
        IF "Attachment File Path 2" <> '' THEN
          SMTPMail.AddAttachment("Attachment File Path 2","Attachment Name 2");
        IF "Attachment File Path 3" <> '' THEN
          SMTPMail.AddAttachment("Attachment File Path 3","Attachment Name 3");
        IF "Attachment File Path 4" <> '' THEN
          SMTPMail.AddAttachment("Attachment File Path 4","Attachment Name 4");
        IF "Attachment File Path 5" <> '' THEN
          SMTPMail.AddAttachment("Attachment File Path 5","Attachment Name 5");
        IF "Send CC" <> '' THEN
          SMTPMail.AddCC("Send CC");
        IF "Send BCC" <> '' THEN
          SMTPMail.AddBCC("Send BCC");
      END;
      MailSent := SMTPMail.TrySend;
      IF NOT MailSent AND NOT HideSMTPError THEN
        ERROR(SMTPMail.GetLastSendMailErrorText);
      EXIT(MailSent);
    END;

    [External]
    PROCEDURE InitializeFrom@10(NewHideMailDialog@1001 : Boolean;NewHideSMTPError@1000 : Boolean);
    BEGIN
      SetHideMailDialog(NewHideMailDialog);
      SetHideSMTPError(NewHideSMTPError);
    END;

    [External]
    PROCEDURE SetHideMailDialog@22(NewHideMailDialog@1001 : Boolean);
    BEGIN
      HideMailDialog := NewHideMailDialog;
    END;

    [External]
    PROCEDURE SetHideSMTPError@23(NewHideSMTPError@1000 : Boolean);
    BEGIN
      HideSMTPError := NewHideSMTPError;
    END;

    LOCAL PROCEDURE SendMailOnWinClient@3() : Boolean;
    VAR
      Mail@1003 : Codeunit 397;
      FileManagement@1006 : Codeunit 419;
      ClientAttachmentFilePath@1005 : Text;
      ClientAttachmentFullName@1009 : Text;
      BodyText@1000 : Text;
    BEGIN
      IF Mail.TryInitializeOutlook THEN
        WITH TempEmailItem DO BEGIN
          IF "Attachment File Path" <> '' THEN BEGIN
            ClientAttachmentFilePath := DownloadPdfOnClient("Attachment File Path");
            ClientAttachmentFullName := FileManagement.MoveAndRenameClientFile(ClientAttachmentFilePath,"Attachment Name",'');
          END;
          BodyText := ImageBase64ToUrl(GetBodyText);
          IF Mail.NewMessageAsync("Send to","Send CC","Send BCC",Subject,BodyText,ClientAttachmentFullName,NOT HideMailDialog) THEN BEGIN
            FileManagement.DeleteClientFile(ClientAttachmentFullName);
            MailSent := TRUE;
            EXIT(TRUE)
          END;
        END;
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE DownloadPdfOnClient@1(ServerPdfFilePath@1000 : Text) : Text;
    VAR
      FileManagement@1003 : Codeunit 419;
      ClientPdfFilePath@1002 : Text;
    BEGIN
      ClientPdfFilePath := FileManagement.DownloadTempFile(ServerPdfFilePath);
      ERASE(ServerPdfFilePath);
      EXIT(ClientPdfFilePath);
    END;

    [External]
    PROCEDURE CheckValidEmailAddresses@8(Recipients@1000 : Text);
    VAR
      TmpRecipients@1001 : Text;
    BEGIN
      IF Recipients = '' THEN
        ERROR(InvalidEmailAddressErr,Recipients);

      TmpRecipients := DELCHR(Recipients,'<>',';');
      WHILE STRPOS(TmpRecipients,';') > 1 DO BEGIN
        CheckValidEmailAddress(COPYSTR(TmpRecipients,1,STRPOS(TmpRecipients,';') - 1));
        TmpRecipients := COPYSTR(TmpRecipients,STRPOS(TmpRecipients,';') + 1);
      END;
      CheckValidEmailAddress(TmpRecipients);
    END;

    [TryFunction]
    [External]
    PROCEDURE CheckValidEmailAddress@12(EmailAddress@1000 : Text);
    VAR
      i@1001 : Integer;
      NoOfAtSigns@1002 : Integer;
    BEGIN
      EmailAddress := DELCHR(EmailAddress,'<>');

      IF EmailAddress = '' THEN
        ERROR(InvalidEmailAddressErr,EmailAddress);

      IF (EmailAddress[1] = '@') OR (EmailAddress[STRLEN(EmailAddress)] = '@') THEN
        ERROR(InvalidEmailAddressErr,EmailAddress);

      FOR i := 1 TO STRLEN(EmailAddress) DO BEGIN
        IF EmailAddress[i] = '@' THEN
          NoOfAtSigns := NoOfAtSigns + 1
        ELSE
          IF EmailAddress[i] = ' ' THEN
            ERROR(InvalidEmailAddressErr,EmailAddress);
      END;

      IF NoOfAtSigns <> 1 THEN
        ERROR(InvalidEmailAddressErr,EmailAddress);
    END;

    [TryFunction]
    [External]
    PROCEDURE ValidateEmailAddressField@27(VAR EmailAddress@1000 : Text);
    BEGIN
      EmailAddress := DELCHR(EmailAddress,'<>');

      IF EmailAddress = '' THEN
        EXIT;

      CheckValidEmailAddress(EmailAddress);
    END;

    [External]
    PROCEDURE IsSMTPEnabled@6() : Boolean;
    BEGIN
      EXIT(SMTPMail.IsEnabled);
    END;

    [External]
    PROCEDURE IsEnabled@11() : Boolean;
    BEGIN
      OutlookSupported := FALSE;
      SMTPSupported := FALSE;
      IF IsSMTPEnabled THEN
        SMTPSupported := TRUE;

      IF NOT FileManagement.CanRunDotNetOnClient THEN
        EXIT(SMTPSupported);

      // Assume Outlook is supported - a false check takes long time.
      OutlookSupported := TRUE;
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE IsCancelled@14() : Boolean;
    BEGIN
      EXIT(Cancelled);
    END;

    [External]
    PROCEDURE IsSent@15() : Boolean;
    BEGIN
      EXIT(MailSent);
    END;

    PROCEDURE Send@4(ParmEmailItem@1000 : Record 9500) : Boolean;
    BEGIN
      TempEmailItem := ParmEmailItem;
      QualifyFromAddress;
      MailSent := FALSE;
      EXIT(DoSend);
    END;

    LOCAL PROCEDURE DoSend@13() : Boolean;
    BEGIN
      IF NOT CanSend THEN
        EXIT(TRUE);
      Cancelled := TRUE;
      IF NOT HideMailDialog THEN BEGIN
        IF RunMailDialog THEN
          Cancelled := FALSE
        ELSE
          EXIT(TRUE);
        IF OutlookSupported THEN
          IF DoEdit THEN BEGIN
            IF SendMailOnWinClient THEN
              EXIT(TRUE);
            OutlookSupported := FALSE;
            IF NOT SMTPSupported THEN
              EXIT(FALSE);
            IF CONFIRM(OutlookNotAvailableContinueEditQst) THEN
              EXIT(DoSend);
          END
      END;
      IF SMTPSupported THEN
        EXIT(SendViaSMTP);

      EXIT(FALSE);
    END;

    LOCAL PROCEDURE QualifyFromAddress@2();
    VAR
      TempPossibleEmailNameValueBuffer@1000 : TEMPORARY Record 823;
      MailForEmails@1001 : Codeunit 397;
    BEGIN
      IF TempEmailItem."From Address" <> '' THEN
        EXIT;

      MailForEmails.CollectCurrentUserEmailAddresses(TempPossibleEmailNameValueBuffer);
      IF SMTPSupported THEN BEGIN
        IF AssignFromAddressIfExist(TempPossibleEmailNameValueBuffer,'SMTPSetup') THEN
          EXIT;
        IF AssignFromAddressIfExist(TempPossibleEmailNameValueBuffer,'UserSetup') THEN
          EXIT;
        IF AssignFromAddressIfExist(TempPossibleEmailNameValueBuffer,'ContactEmail') THEN
          EXIT;
        IF AssignFromAddressIfExist(TempPossibleEmailNameValueBuffer,'AuthEmail') THEN
          EXIT;
        IF AssignFromAddressIfExist(TempPossibleEmailNameValueBuffer,'AD') THEN
          EXIT;
      END;
      IF TempPossibleEmailNameValueBuffer.ISEMPTY THEN BEGIN
        IF FileManagement.IsWebClient THEN
          ERROR(FromAddressWasNotFoundErr);
        TempEmailItem."From Address" := '';
        EXIT;
      END;

      IF AssignFromAddressIfExist(TempPossibleEmailNameValueBuffer,'') THEN
        EXIT;
    END;

    LOCAL PROCEDURE AssignFromAddressIfExist@9(VAR TempPossibleEmailNameValueBuffer@1000 : TEMPORARY Record 823;FilteredName@1002 : Text) : Boolean;
    BEGIN
      IF FilteredName <> '' THEN
        TempPossibleEmailNameValueBuffer.SETFILTER(Name,FilteredName);
      IF NOT TempPossibleEmailNameValueBuffer.ISEMPTY THEN BEGIN
        TempPossibleEmailNameValueBuffer.FINDFIRST;
        IF TempPossibleEmailNameValueBuffer.Value <> '' THEN BEGIN
          TempEmailItem."From Address" := TempPossibleEmailNameValueBuffer.Value;
          EXIT(TRUE);
        END;
      END;

      TempPossibleEmailNameValueBuffer.RESET;
      EXIT(FALSE);
    END;

    PROCEDURE SendMailOrDownload@17(TempEmailItem@1002 : TEMPORARY Record 9500;HideMailDialog@1000 : Boolean);
    VAR
      MailManagement@1001 : Codeunit 9520;
      OfficeMgt@1003 : Codeunit 1630;
    BEGIN
      MailManagement.InitializeFrom(HideMailDialog,ClientTypeManagement.GetCurrentClientType <> CLIENTTYPE::Background);
      IF MailManagement.IsEnabled THEN
        IF MailManagement.Send(TempEmailItem) THEN BEGIN
          MailSent := MailManagement.IsSent;
          DeleteTempAttachments(TempEmailItem);
          EXIT;
        END;

      IF NOT GUIALLOWED OR (OfficeMgt.IsAvailable AND NOT OfficeMgt.IsPopOut) THEN
        ERROR(CannotSendMailThenDownloadErr);

      IF NOT CONFIRM(STRSUBSTNO('%1\\%2',CannotSendMailThenDownloadErr,CannotSendMailThenDownloadQst)) THEN
        EXIT;

      DownloadPdfAttachment(TempEmailItem);
    END;

    [Internal]
    PROCEDURE DownloadPdfAttachment@16(TempEmailItem@1000 : TEMPORARY Record 9500);
    VAR
      FileManagement@1002 : Codeunit 419;
    BEGIN
      WITH TempEmailItem DO
        IF "Attachment File Path" <> '' THEN
          FileManagement.DownloadHandler("Attachment File Path",SaveFileDialogTitleMsg,'',SaveFileDialogFilterMsg,"Attachment Name")
        ELSE
          IF "Body File Path" <> '' THEN
            FileManagement.DownloadHandler("Body File Path",SaveFileDialogTitleMsg,'',SaveFileDialogFilterMsg,EmailAttachmentTxt);
    END;

    PROCEDURE ImageBase64ToUrl@18(BodyText@1007 : Text) : Text;
    VAR
      Regex@1006 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Text.RegularExpressions.Regex";
      Convert@1005 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Convert";
      MemoryStream@1004 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.MemoryStream";
      SearchText@1003 : Text;
      Base64@1002 : Text;
      MimeType@1001 : Text;
      MediaId@1000 : GUID;
    BEGIN
      SearchText := '(.*<img src=\")data:image\/([a-z]+);base64,([a-zA-Z0-9\/+=]+)(\".*)';
      Regex := Regex.Regex(SearchText);
      WHILE Regex.IsMatch(BodyText) DO BEGIN
        Base64 := Regex.Replace(BodyText,'$3',1);
        MimeType := Regex.Replace(BodyText,'$2',1);
        MemoryStream := MemoryStream.MemoryStream(Convert.FromBase64String(Base64));
        // 20160 =  14days * 24/hours/day * 60min/hour
        MediaId := IMPORTSTREAMWITHURLACCESS(MemoryStream,FORMAT(CREATEGUID) + MimeType,20160);

        BodyText := Regex.Replace(BodyText,'$1' + GETDOCUMENTURL(MediaId) + '$4',1);
      END;
      EXIT(BodyText);
    END;

    LOCAL PROCEDURE DeleteTempAttachments@20(VAR EmailItem@1000 : Record 9500);
    BEGIN
      IF TryDeleteTempAttachment(EmailItem."Attachment File Path 2") THEN;
      IF TryDeleteTempAttachment(EmailItem."Attachment File Path 3") THEN;
      IF TryDeleteTempAttachment(EmailItem."Attachment File Path 4") THEN;
      IF TryDeleteTempAttachment(EmailItem."Attachment File Path 5") THEN;
    END;

    [TryFunction]
    LOCAL PROCEDURE TryDeleteTempAttachment@21(VAR FilePath@1000 : Text[250]);
    VAR
      FileManagement@1001 : Codeunit 419;
    BEGIN
      IF FilePath = '' THEN
        EXIT;
      FileManagement.DeleteServerFile(FilePath);
      FilePath := '';
    END;

    PROCEDURE GetSenderEmailAddress@24() : Text[250];
    BEGIN
      IF NOT IsEnabled THEN
        EXIT('');
      QualifyFromAddress;
      EXIT(TempEmailItem."From Address");
    END;

    LOCAL PROCEDURE CanSend@25() : Boolean;
    VAR
      CancelSending@1000 : Boolean;
    BEGIN
      OnBeforeDoSending(CancelSending);
      EXIT(NOT CancelSending);
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeDoSending@26(VAR CancelSending@1000 : Boolean);
    BEGIN
    END;

    BEGIN
    END.
  }
}

