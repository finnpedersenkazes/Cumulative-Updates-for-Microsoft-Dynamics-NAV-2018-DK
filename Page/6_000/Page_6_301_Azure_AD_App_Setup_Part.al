OBJECT Page 6301 Azure AD App Setup Part
{
  OBJECT-PROPERTIES
  {
    Date=26-01-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20348;
  }
  PROPERTIES
  {
    CaptionML=[DAN=<Del til konfiguration af Azure AD>;
               ENU=<Azure AD Application Setup Part>];
    SourceTable=Table6300;
    PageType=CardPart;
    OnOpenPage=VAR
                 AzureADMgt@1000 : Codeunit 6300;
               BEGIN
                 IF NOT FINDFIRST THEN
                   INIT;

                 HomePageUrl := GETURL(CLIENTTYPE::Web);
                 RedirectUrl := AzureADMgt.GetRedirectUrl;
                 AppId := "App ID";
                 SecretKey := GetSecretKey;
               END;

  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 5   ;1   ;Field     ;
                Name=HomePageUrl;
                CaptionML=[DAN=URL-adresse til hjemmeside;
                           ENU=Home page URL];
                ToolTipML=[DAN=Dette er URL-adressen til hjemmesiden. Du skal angive adressen, n†r du registrerer et Azure-program.;
                           ENU=Specifies the home page URL to enter when registering an Azure application.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=HomePageUrl;
                Editable=FALSE }

    { 4   ;1   ;Field     ;
                Name=RedirectUrl;
                CaptionML=[DAN=URL-svaradresse;
                           ENU=Reply URL];
                ToolTipML=[DAN=Angiver den URL-svaradresse, der skal angives, n†r du registrerer et Azure-program.;
                           ENU=Specifies the reply URL to enter when registering an Azure application.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=RedirectUrl }

    { 2   ;1   ;Field     ;
                Name=AppId;
                CaptionML=[DAN=Program-id;
                           ENU=Application ID];
                ToolTipML=[DAN=Angiver det id, der knyttes til programmet, n†r det registreres i Azure AD.ÿId'et benyttes til godkendelse med Azure AD. Dette kaldes ogs† kunde-id.;
                           ENU=Specifies the ID that is assigned to the application when it is registered in Azure AD.ÿ The ID is used for authenticating with Azure AD. This is also referred to as the client ID.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=AppId;
                ShowMandatory=True }

    { 3   ;1   ;Field     ;
                Name=SecretKey;
                CaptionML=[DAN=N›gle;
                           ENU=Key];
                ToolTipML=[DAN=Angiver den hemmelige n›gle (eller klienthemmelighed), der benyttes sammen med program-id'et til godkendelse med Azure AD.;
                           ENU=Specifies the secret key (or client secret) that is used along with the Application ID for authenticating with Azure AD.];
                ApplicationArea=#Basic,#Suite;
                NotBlank=Yes;
                SourceExpr=SecretKey;
                ShowMandatory=True }

  }
  CODE
  {
    VAR
      HomePageUrl@1005 : Text;
      RedirectUrl@1004 : Text[150];
      SecretKey@1000 : Text;
      AppId@1001 : GUID;
      InvalidAppIdErr@1003 : TextConst 'DAN=Indtast gyldigt GUID for Program-id.;ENU=Enter valid GUID for Application ID.';
      InvalidClientSecretErr@1002 : TextConst 'DAN=N›gle er p†kr‘vet.;ENU=Key is required.';

    [External]
    PROCEDURE Save@5();
    BEGIN
      "Redirect URL" := RedirectUrl;
      "App ID" := AppId;
      SetSecretKey(SecretKey);

      IF NOT MODIFY(TRUE) THEN
        INSERT(TRUE);
    END;

    [External]
    PROCEDURE ValidateFields@1();
    BEGIN
      IF ISNULLGUID(AppId) THEN
        ERROR(InvalidAppIdErr);

      IF SecretKey = '' THEN
        ERROR(InvalidClientSecretErr);
    END;

    PROCEDURE SetReplyURLWithDefault@3();
    VAR
      AzureADMgt@1000 : Codeunit 6300;
    BEGIN
      RedirectUrl := AzureADMgt.GetDefaultRedirectUrl;
    END;

    PROCEDURE SetAppDetails@6(ApplicationId@1000 : GUID;Key@1001 : Text);
    BEGIN
      AppId := ApplicationId;
      SecretKey := Key;
    END;

    PROCEDURE GetRedirectUrl@2() : Text;
    BEGIN
      EXIT(RedirectUrl);
    END;

    BEGIN
    END.
  }
}

