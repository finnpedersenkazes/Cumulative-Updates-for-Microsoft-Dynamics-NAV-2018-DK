OBJECT Page 2824 Native - Test Mail
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    Editable=Yes;
    CaptionML=[@@@={Locked};
               DAN=nativeInvoicingTestMail;
               ENU=nativeInvoicingTestMail];
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table2822;
    DelayedInsert=Yes;
    PageType=List;
    SourceTableTemporary=Yes;
    OnInsertRecord=VAR
                     SMTPTestMail@1000 : Codeunit 412;
                   BEGIN
                     CheckSmtpMailSetup;
                     SMTPTestMail.SendTestMail("E-mail");
                     EXIT(TRUE);
                   END;

    ODataKeyFields=Code;
  }
  CONTROLS
  {
    { 18  ;0   ;Container ;
                ContainerType=ContentArea }

    { 17  ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 4   ;2   ;Field     ;
                Name=email;
                CaptionML=[@@@={Locked};
                           DAN=email;
                           ENU=email];
                ApplicationArea=#All;
                SourceExpr="E-mail";
                OnValidate=BEGIN
                             IF "E-mail" = '' THEN
                               ERROR(EmailErr);
                           END;
                            }

  }
  CODE
  {
    VAR
      EmailErr@1000 : TextConst 'DAN=Mailadressen er ikke angivet.;ENU=The email address is not specified.';
      MailNotConfiguredErr@1001 : TextConst 'DAN=Du skal konfigurere en mailkonto for at kunne sende mails.;ENU=An email account must be configured to send emails.';

    LOCAL PROCEDURE CheckSmtpMailSetup@30();
    VAR
      O365SetupEmail@1001 : Codeunit 2135;
    BEGIN
      IF NOT O365SetupEmail.SMTPEmailIsSetUp THEN
        ERROR(MailNotConfiguredErr);
    END;

    BEGIN
    END.
  }
}

