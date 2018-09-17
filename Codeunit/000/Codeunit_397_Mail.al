OBJECT Codeunit 397 Mail
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
      Text001@1000 : TextConst '@@@="%1 = Contact Table Caption (eg. No registered email addresses found for this Contact.)";DAN=Der findes ingen registrerede mailadresser for %1.;ENU=No registered email addresses exist for this %1.';
      OutlookMessageHelper@1001 : DotNet "'Microsoft.Dynamics.Nav.Integration.Office, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Integration.Office.Outlook.IOutlookMessage" RUNONCLIENT;

    [Internal]
    PROCEDURE OpenNewMessage@1(ToName@1000 : Text);
    BEGIN
      Initialize;
      NewMessage(ToName,'','','','','',TRUE);
    END;

    [Internal]
    PROCEDURE NewMessageAsync@1000(ToAddresses@1001 : Text;CcAddresses@1002 : Text;BccAddresses@1000 : Text;Subject@1003 : Text;Body@1004 : Text;AttachFilename@1005 : Text;ShowNewMailDialogOnSend@1006 : Boolean) : Boolean;
    BEGIN
      EXIT(CreateAndSendMessage(ToAddresses,CcAddresses,BccAddresses,Subject,Body,AttachFilename,ShowNewMailDialogOnSend,FALSE));
    END;

    [Internal]
    PROCEDURE NewMessage@2(ToAddresses@1001 : Text;CcAddresses@1002 : Text;BccAddresses@1000 : Text;Subject@1003 : Text;Body@1004 : Text;AttachFilename@1005 : Text;ShowNewMailDialogOnSend@1006 : Boolean) : Boolean;
    BEGIN
      EXIT(CreateAndSendMessage(ToAddresses,CcAddresses,BccAddresses,Subject,Body,AttachFilename,ShowNewMailDialogOnSend,TRUE));
    END;

    LOCAL PROCEDURE CreateAndSendMessage@1001(ToAddresses@1001 : Text;CcAddresses@1002 : Text;BccAddresses@1007 : Text;Subject@1003 : Text;Body@1004 : Text;AttachFilename@1005 : Text;ShowNewMailDialogOnSend@1006 : Boolean;RunModal@1000 : Boolean) : Boolean;
    BEGIN
      Initialize;

      CreateMessage(ToAddresses,CcAddresses,BccAddresses,Subject,Body,ShowNewMailDialogOnSend,RunModal);
      AttachFile(AttachFilename);

      EXIT(Send);
    END;

    [Internal]
    PROCEDURE CreateMessage@26(ToAddresses@1001 : Text;CcAddresses@1002 : Text;BccAddresses@1007 : Text;Subject@1003 : Text;Body@1004 : Text;ShowNewMailDialogOnSend@1006 : Boolean;RunModal@1000 : Boolean);
    BEGIN
      Initialize;

      OutlookMessageHelper.Recipients := ToAddresses;
      OutlookMessageHelper.CarbonCopyRecipients := CcAddresses;
      OutlookMessageHelper.BlindCarbonCopyRecipients := BccAddresses;
      OutlookMessageHelper.Subject := Subject;
      OutlookMessageHelper.BodyFormat := 2;
      OutlookMessageHelper.ShowNewMailDialogOnSend := ShowNewMailDialogOnSend;
      OutlookMessageHelper.NewMailDialogIsModal := RunModal;
      OutlookMessageHelper.AttachmentFileNames.Clear;
      AddBodyline(Body);
    END;

    [Internal]
    PROCEDURE AddBodyline@5(TextLine@1000 : Text) : Boolean;
    BEGIN
      Initialize;

      IF TextLine <> '' THEN
        OutlookMessageHelper.Body.Append(FormatTextForHtml(TextLine));
      EXIT(TRUE);
    END;

    [Internal]
    PROCEDURE AttachFile@21(Filename@1000 : Text);
    BEGIN
      Initialize;

      IF Filename <> '' THEN
        OutlookMessageHelper.AttachmentFileNames.Add(Filename);
    END;

    [Internal]
    PROCEDURE Send@4() : Boolean;
    BEGIN
      Initialize;
      EXIT(OutlookMessageHelper.Send);
    END;

    [Internal]
    PROCEDURE GetErrorDesc@7() : Text;
    BEGIN
      Initialize;
      IF NOT ISNULL(OutlookMessageHelper.LastException) THEN
        EXIT(OutlookMessageHelper.LastException.Message);
    END;

    [External]
    PROCEDURE CollectAddresses@9(ContactNo@1000 : Code[20];VAR ContactThrough@1002 : Record 5100;ShowAddresses@1008 : Boolean) : Text[260];
    VAR
      Contact@1003 : Record 5050;
    BEGIN
      ContactThrough.RESET;
      ContactThrough.DELETEALL;
      IF NOT Contact.GET(ContactNo) THEN
        EXIT;

      CollectContactAddresses(ContactThrough,ContactNo);

      // Get linked Company Addresses
      IF (Contact.Type = Contact.Type::Person) AND (Contact."Company No." <> '') THEN
        CollectContactAddresses(ContactThrough,Contact."Company No.");

      IF ShowAddresses THEN
        IF ContactThrough.FIND('-') THEN BEGIN
          IF PAGE.RUNMODAL(PAGE::"Contact Through",ContactThrough) = ACTION::LookupOK THEN
            EXIT(ContactThrough."E-Mail");
        END ELSE
          ERROR(Text001,Contact.TABLECAPTION);
    END;

    LOCAL PROCEDURE TrimCode@8(Code@1001 : Code[20]) TrimString : Text[20];
    BEGIN
      TrimString := COPYSTR(Code,1,1) + LOWERCASE(COPYSTR(Code,2,STRLEN(Code) - 1))
    END;

    [External]
    PROCEDURE ValidateEmail@12(VAR ContactThrough@1000 : Record 5100;EMailToValidate@1001 : Text) EMailExists : Boolean;
    BEGIN
      ContactThrough.RESET;
      IF ContactThrough.FINDFIRST THEN BEGIN
        ContactThrough.SETRANGE("E-Mail",COPYSTR(EMailToValidate,1,MAXSTRLEN(ContactThrough."E-Mail")));
        EMailExists := NOT ContactThrough.ISEMPTY;
      END;
    END;

    LOCAL PROCEDURE CollectContactAddresses@14(VAR ContactThrough@1000 : Record 5100;ContactNo@1001 : Code[20]);
    VAR
      Contact@1007 : Record 5050;
      ContAltAddr@1005 : Record 5051;
      ContAltAddrDateRange@1004 : Record 5052;
      KeyNo@1002 : Integer;
    BEGIN
      IF NOT Contact.GET(ContactNo) THEN
        EXIT;
      WITH ContactThrough DO BEGIN
        IF FINDLAST THEN
          KeyNo := Key + 1
        ELSE
          KeyNo := 1;

        IF Contact."E-Mail" <> '' THEN BEGIN
          Key := KeyNo;
          "Contact No." := ContactNo;
          Name := Contact.Name;
          Description := COPYSTR(Contact.FIELDCAPTION("E-Mail"),1,MAXSTRLEN(Description));
          "E-Mail" := Contact."E-Mail";
          Type := Contact.Type;
          INSERT;
          KeyNo := KeyNo + 1;
        END;

        // Alternative address
        ContAltAddrDateRange.SETCURRENTKEY("Contact No.","Starting Date");
        ContAltAddrDateRange.SETRANGE("Contact No.",ContactNo);
        ContAltAddrDateRange.SETRANGE("Starting Date",0D,TODAY);
        ContAltAddrDateRange.SETFILTER("Ending Date",'>=%1|%2',TODAY,0D);
        IF ContAltAddrDateRange.FINDSET THEN
          REPEAT
            IF ContAltAddr.GET(Contact."No.",ContAltAddrDateRange."Contact Alt. Address Code") THEN
              IF ContAltAddr."E-Mail" <> '' THEN BEGIN
                Key := KeyNo;
                Description :=
                  COPYSTR(TrimCode(ContAltAddr.Code) + ' - ' + ContAltAddr.FIELDCAPTION("E-Mail"),1,MAXSTRLEN(Description));
                "E-Mail" := ContAltAddr."E-Mail";
                Type := Contact.Type;
                INSERT;
                KeyNo := KeyNo + 1;
              END;
          UNTIL ContAltAddrDateRange.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE Initialize@11();
    VAR
      OutlookMessageFactory@1001 : Codeunit 9530;
    BEGIN
      IF ISNULL(OutlookMessageHelper) THEN
        OutlookMessageFactory.CreateOutlookMessage(OutlookMessageHelper);
    END;

    [Internal]
    PROCEDURE TryInitializeOutlook@1002() : Boolean;
    BEGIN
      Initialize;
      EXIT(OutlookMessageHelper.CanInitializeOutlook);
    END;

    [External]
    PROCEDURE CollectCurrentUserEmailAddresses@6(VAR TempNameValueBuffer@1000 : TEMPORARY Record 823);
    VAR
      PermissionManager@1001 : Codeunit 9002;
    BEGIN
      AddAddressToCollection('UserSetup',GetEmailFromUserSetupTable,TempNameValueBuffer);
      AddAddressToCollection('ContactEmail',GetContactEmailFromUserTable,TempNameValueBuffer);
      AddAddressToCollection('AuthEmail',GetAuthenticationEmailFromUserTable,TempNameValueBuffer);
      IF NOT PermissionManager.SoftwareAsAService THEN
        AddAddressToCollection('AD',GetActiveDirectoryMailFromUser,TempNameValueBuffer);
      AddAddressToCollection('SMTPSetup',GetBasicAuthAddressFromSMTPSetup,TempNameValueBuffer);
    END;

    LOCAL PROCEDURE AddAddressToCollection@20(EmailKey@1003 : Text;EmailAddress@1000 : Text;VAR TempNameValueBuffer@1001 : TEMPORARY Record 823) : Boolean;
    VAR
      NextID@1002 : Integer;
    BEGIN
      IF EmailAddress = '' THEN
        EXIT;

      WITH TempNameValueBuffer DO BEGIN
        RESET;
        IF FINDSET THEN
          REPEAT
            IF UPPERCASE(Value) = UPPERCASE(EmailAddress) THEN
              EXIT(FALSE);
          UNTIL NEXT = 0;
        IF FINDLAST THEN
          NextID := ID + 1
        ELSE
          NextID := 1;

        INIT;

        ID := NextID;
        Name := COPYSTR(EmailKey,1,MAXSTRLEN(Name));
        Value := COPYSTR(EmailAddress,1,MAXSTRLEN(Value));
        INSERT;
      END;

      EXIT(TRUE);
    END;

    LOCAL PROCEDURE GetBasicAuthAddressFromSMTPSetup@17() : Text;
    VAR
      SMTPMailSetup@1000 : Record 409;
    BEGIN
      WITH SMTPMailSetup DO BEGIN
        IF NOT FINDFIRST THEN
          EXIT;
        IF Authentication = Authentication::Basic THEN
          IF "User ID" <> '' THEN
            IF STRPOS("User ID",'@') > 0 THEN
              EXIT("User ID");
      END;
    END;

    LOCAL PROCEDURE GetActiveDirectoryMailFromUser@16() : Text;
    VAR
      Email@1003 : Text;
      Handled@1001 : Boolean;
    BEGIN
      OnGetEmailAddressFromActiveDirectory(Email,Handled);
      IF Handled THEN
        EXIT(Email);
      EXIT(GetEmailAddressFromActiveDirectory);
    END;

    LOCAL PROCEDURE GetEmailAddressFromActiveDirectory@24() : Text;
    VAR
      FileManagement@1000 : Codeunit 419;
      ActiveDirectoryEmailAddress@1001 : Text;
    BEGIN
      IF FileManagement.CanRunDotNetOnClient THEN
        IF TryGetEmailAddressFromActiveDirectory(ActiveDirectoryEmailAddress) THEN;
      EXIT(ActiveDirectoryEmailAddress);
    END;

    LOCAL PROCEDURE GetAuthenticationEmailFromUserTable@15() : Text;
    VAR
      User@1000 : Record 2000000120;
    BEGIN
      User.SETRANGE("User Name",USERID);
      IF User.FINDFIRST THEN
        EXIT(User."Authentication Email");
    END;

    LOCAL PROCEDURE GetContactEmailFromUserTable@10() : Text;
    VAR
      User@1000 : Record 2000000120;
    BEGIN
      User.SETRANGE("User Name",USERID);
      IF User.FINDFIRST THEN
        EXIT(User."Contact Email");
    END;

    LOCAL PROCEDURE GetEmailFromUserSetupTable@13() : Text;
    VAR
      UserSetup@1000 : Record 91;
    BEGIN
      UserSetup.SETRANGE("User ID",USERID);
      IF UserSetup.FINDFIRST THEN
        EXIT(UserSetup."E-Mail");
    END;

    [TryFunction]
    LOCAL PROCEDURE TryGetEmailAddressFromActiveDirectory@19(VAR ActiveDirectoryEmailAddress@1000 : Text);
    VAR
      MailHelpers@1001 : DotNet "'Microsoft.Dynamics.Nav.SMTP, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.SMTP.MailHelpers" RUNONCLIENT;
    BEGIN
      IF CANLOADTYPE(MailHelpers) THEN
        ActiveDirectoryEmailAddress := MailHelpers.TryGetEmailAddressFromActiveDirectory;
    END;

    [External]
    PROCEDURE FormatTextForHtml@3(Text@1003 : Text) : Text;
    VAR
      String@1002 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.String";
      Char10@1001 : Char;
      Char13@1000 : Char;
    BEGIN
      IF Text <> '' THEN BEGIN
        Char13 := 13;
        Char10 := 10;
        String := Text;
        EXIT(String.Replace(FORMAT(Char13) + FORMAT(Char10),'<br />'));
      END;

      EXIT('');
    END;

    [Integration]
    PROCEDURE OnGetEmailAddressFromActiveDirectory@22(VAR Email@1001 : Text;VAR Handled@1000 : Boolean);
    BEGIN
    END;

    BEGIN
    END.
  }
}

