OBJECT Page 6300 Azure AD App Setup Wizard
{
  OBJECT-PROPERTIES
  {
    Date=26-01-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20348;
  }
  PROPERTIES
  {
    CaptionML=[DAN=KONFIGURER AZURE ACTIVE DIRECTORY;
               ENU=SETUP AZURE ACTIVE DIRECTORY];
    PageType=NavigatePage;
    OnInit=VAR
             AzureADAppSetup@1000 : Record 6300;
           BEGIN
             // Checks user permissions and closes the wizard with an error message if necessary.
             IF NOT AzureADAppSetup.WRITEPERMISSION THEN
               ERROR(PermissionsErr);
             LoadTopBanners;
           END;

    OnOpenPage=BEGIN
                 // Always start on the introduction step
                 SetStep(CurrentStep::Intro);
               END;

    ActionList=ACTIONS
    {
      { 10      ;    ;ActionContainer;
                      Name=Actions;
                      ActionContainerType=ActionItems }
      { 22      ;1   ;Action    ;
                      Name=ActionReset;
                      CaptionML=[DAN=Nulstil URL-svaradresse;
                                 ENU=Reset Reply URL];
                      ApplicationArea=#Basic,#Suite;
                      Enabled=Step1Visible;
                      InFooterBar=Yes;
                      OnAction=BEGIN
                                 CurrPage.AzureAdSetup.PAGE.SetReplyURLWithDefault;
                               END;
                                }
      { 11      ;1   ;Action    ;
                      Name=ActionBack;
                      CaptionML=[DAN=Tilbage;
                                 ENU=Back];
                      ApplicationArea=#Basic,#Suite;
                      Enabled=BackEnabled;
                      InFooterBar=Yes;
                      Image=PreviousRecord;
                      OnAction=BEGIN
                                 GoToNextStep(FALSE);
                               END;
                                }
      { 12      ;1   ;Action    ;
                      Name=ActionNext;
                      CaptionML=[DAN=N‘ste;
                                 ENU=Next];
                      ApplicationArea=#Basic,#Suite;
                      Enabled=NextEnabled;
                      InFooterBar=Yes;
                      Image=NextRecord;
                      OnAction=BEGIN
                                 GoToNextStep(TRUE);
                               END;
                                }
      { 13      ;1   ;Action    ;
                      Name=ActionFinish;
                      CaptionML=[DAN=Udf›r;
                                 ENU=Finish];
                      ApplicationArea=#Basic,#Suite;
                      Enabled=FinishEnabled;
                      InFooterBar=Yes;
                      Image=Approve;
                      OnAction=BEGIN
                                 CurrPage.AzureAdSetup.PAGE.Save;

                                 // notify Assisted Setup that this setup has been completed
                                 AssistedSetup.SetStatus(PAGE::"Azure AD App Setup Wizard",AssistedSetup.Status::Completed);
                                 CurrPage.UPDATE(FALSE);
                                 CurrPage.CLOSE;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;    ;Container ;
                Name=Azure AD Application Setup;
                CaptionML=[DAN=Konfiguration af Azure AD;
                           ENU=Azure AD Application Setup];
                ContainerType=ContentArea }

    { 14  ;1   ;Group     ;
                Visible=TopBannerVisible AND NOT DoneVisible;
                Editable=FALSE;
                GroupType=Group }

    { 5   ;2   ;Field     ;
                Name=<MediaRepositoryStandard>;
                CaptionML=[DAN="";
                           ENU=""];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=MediaResourcesStandard."Media Reference";
                Editable=FALSE }

    { 4   ;1   ;Group     ;
                Visible=TopBannerVisible AND DoneVisible;
                Editable=FALSE;
                GroupType=Group }

    { 15  ;2   ;Field     ;
                Name=<MediaRepositoryDone>;
                CaptionML=[DAN="";
                           ENU=""];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=MediaResourcesDone."Media Reference";
                Editable=FALSE }

    { 8   ;1   ;Group     ;
                Name=Intro;
                CaptionML=[DAN=Intro;
                           ENU=Intro];
                Visible=IntroVisible;
                GroupType=Group }

    { 16  ;2   ;Group     ;
                Name=Para1.1;
                CaptionML=[DAN=Velkommen til Konfiguration af Azure Active Directory (Azure AD);
                           ENU=Welcome to Azure Active Directory (Azure AD) Setup];
                GroupType=Group }

    { 9   ;3   ;Field     ;
                Name=Para1.1.1;
                CaptionML=[DAN=N†r du registrerer et program p† Azure-portalen, aktiveres det i lokale programmer, s† det kan kommunikere direkte med Power BI, Microsoft Flow, Office 365 Exchange og andre Azure-tjenester. Registreringen skal kun foretages ‚n gang for hver forekomst af Microsoft Dynamics NAV.;
                           ENU=When you register an application in the Azure Portal, it enables on premise applications to communicate with Power BI, Microsoft Flow, Office 365 Exchange and other Azure services directly.  This registration is only required once for each Microsoft Dynamics NAV instance.];
                ApplicationArea=#Basic,#Suite }

    { 24  ;3   ;Field     ;
                ApplicationArea=#Basic,#Suite }

    { 17  ;3   ;Field     ;
                Name=Para1.1.2;
                CaptionML=[DAN=Denne guide f›rer dig gennem de trin, der kr‘ves for at registrere Microsoft Dynamics NAV p† Azure-portalen.;
                           ENU=This wizard will guide you through the steps required to register Microsoft Dynamics NAV in the Azure Portal.];
                ApplicationArea=#Basic,#Suite }

    { 26  ;3   ;Field     ;
                ApplicationArea=#Basic,#Suite }

    { 18  ;3   ;Field     ;
                Name=Para1.1.3;
                CaptionML=[DAN=I slutningen af registreringsprocessen angiver Azure-portalen et program-id og en n›gle, som kr‘ves for at fuldf›re konfigurationen.;
                           ENU=At the end of the registration process, the Azure Portal will provide an Application ID and Key that will be required to complete the setup.];
                ApplicationArea=#Basic,#Suite }

    { 19  ;2   ;Group     ;
                Name=Para1.2;
                CaptionML=[DAN=Lad os komme i gang!;
                           ENU=Let's go!];
                GroupType=Group;
                InstructionalTextML=[DAN=V‘lg N‘ste for at gennemg† registreringsprocessen for Microsoft Dynamics NAV p† Azure-portalen og hente de oplysninger, der er n›dvendige for at fuldf›re denne konfiguration.;
                                     ENU=Choose Next to step through the process of registering Microsoft Dynamics NAV in the Azure Portal and obtaining the necessary information to complete this setup.] }

    { 2   ;1   ;Group     ;
                Name=Step1;
                CaptionML=[DAN=Trin 1;
                           ENU=Step 1];
                Visible=Step1Visible;
                GroupType=Group }

    { 20  ;2   ;Group     ;
                Name=Para2.1;
                CaptionML=[DAN=Registrering af Microsoft Dynamics NAV;
                           ENU=Registering Microsoft Dynamics NAV];
                GroupType=Group }

    { 21  ;3   ;Field     ;
                Name=Para2.1.1;
                CaptionML=[DAN=Hvis du vil hente et program-id og en n›gle eller generere en n›gle til et eksisterende program-id, skal du v‘lge linket til automatisk registrering nedenfor (anbefales) eller angive det program-id og den n›gle, du har oprettet manuelt i Azure-portalen. Du kan ogs† finde flere oplysninger om, hvordan du manuelt opretter et program-id og en n›gle, i afsnittet med fremgangsm†den til registrering af Dynamics NAV i Azure-administrationsportalen i dokumentationen.;
                           ENU=To obtain an Application ID and Key, or to regenerate a Key for an existing Application ID, select the Auto Register link below (recommended) or enter the Application ID and Key you manually created in the Azure Portal.  You can also find more information on how to manually create an Application ID and Key in the 'How to:  Register Dynamics NAV in the Azure Management Portal' section of the documentation.];
                ApplicationArea=#Basic,#Suite }

    { 3   ;3   ;Part      ;
                Name=AzureAdSetup;
                CaptionML=[@@@={Locked};
                           DAN=" ";
                           ENU=" "];
                ApplicationArea=#Basic,#Suite;
                PagePartID=Page6301;
                PartType=Page;
                ShowFilter=No }

    { 28  ;3   ;Field     ;
                Name=OAuthIntegration;
                ApplicationArea=#Basic,#Suite;
                HideValue=TRUE;
                ControlAddIn=[Microsoft.Dynamics.Nav.Client.OAuthIntegration;PublicKeyToken=31bf3856ad364e35];
                ShowCaption=No }

    { 6   ;1   ;Group     ;
                Name=Done;
                CaptionML=[DAN=F‘rdig;
                           ENU=Done];
                Visible=DoneVisible;
                GroupType=Group }

    { 25  ;2   ;Group     ;
                Name=Para3.1;
                CaptionML=[DAN=Det var det hele!;
                           ENU=That's it!];
                GroupType=Group }

    { 7   ;3   ;Group     ;
                Name=Para3.1.1;
                CaptionML=[DAN="";
                           ENU=""];
                GroupType=Group;
                InstructionalTextML=[DAN=Hvis du vil begynde at bruge Azure Active Directory-tjenesterne, skal du v‘lge Udf›r.;
                                     ENU=To begin using the Azure Active Directory services, choose Finish.] }

  }
  CODE
  {
    VAR
      MediaRepositoryStandard@1010 : Record 9400;
      MediaRepositoryDone@1011 : Record 9400;
      MediaResourcesStandard@1014 : Record 2000000182;
      MediaResourcesDone@1013 : Record 2000000182;
      AssistedSetup@1008 : Record 1803;
      ClientTypeManagement@1077 : Codeunit 4;
      CurrentStep@1000 : 'Intro,AzureAD,Done';
      IntroVisible@1001 : Boolean;
      Step1Visible@1002 : Boolean;
      DoneVisible@1004 : Boolean;
      NextEnabled@1005 : Boolean;
      BackEnabled@1006 : Boolean;
      FinishEnabled@1007 : Boolean;
      StepOutOfRangeErr@1003 : TextConst 'DAN=Guidetrinnet er uden for intervallet.;ENU=Wizard step out of range.';
      PermissionsErr@1009 : TextConst 'DAN=Kontakt en administrator for at konfigurere programmet Azure Active Directory.;ENU=Please contact an administrator to set up your Azure Active Directory application.';
      TopBannerVisible@1012 : Boolean;
      NavRegistrationPortalTxt@1015 : TextConst '@@@={Locked};DAN="https://go.microsoft.com/fwlink/?linkid=862265&version=v1&replyUrl=%1&keyExpiration=%2";ENU="https://go.microsoft.com/fwlink/?linkid=862265&version=v1&replyUrl=%1&keyExpiration=%2"';
      AutoRegisterTxt@1016 : TextConst 'DAN=Automatisk registrering;ENU=Auto-Register';
      AutoRegisterTooltipTxt@1017 : TextConst 'DAN=Du bliver sendt videre til appregistreringsportalen.;ENU=You will be redirected to App Registration Portal.';
      NavRegistrationNotSupportedMsg@1018 : TextConst 'DAN=Du skal bruge Windows-klienten eller webklienten for at registrere Microsoft Dynamics NAV p† Azure-portalen.;ENU=You must use the Windows Client or Web Client to register Microsoft Dynamics NAV in the Azure Portal.';
      NavRegistrationGenericErr@1019 : TextConst 'DAN=Der opstod en fejl under registrering af appen. Pr›v igen, eller registrer programmet manuelt via Azure-portalen.;ENU=An error occurred while registering the app. Please try again or manually register the app using Azure portal.';

    LOCAL PROCEDURE SetStep@1(NewStep@1000 : Option);
    BEGIN
      IF (NewStep < CurrentStep::Intro) OR (NewStep > CurrentStep::Done) THEN
        ERROR(StepOutOfRangeErr);

      ClearStepControls;
      CurrentStep := NewStep;

      CASE NewStep OF
        CurrentStep::Intro:
          BEGIN
            IntroVisible := TRUE;
            NextEnabled := TRUE;
          END;
        CurrentStep::AzureAD:
          BEGIN
            Step1Visible := TRUE;
            BackEnabled := TRUE;
            NextEnabled := TRUE;
          END;
        CurrentStep::Done:
          BEGIN
            DoneVisible := TRUE;
            BackEnabled := TRUE;
            FinishEnabled := TRUE;
          END;
      END;

      CurrPage.UPDATE(TRUE);
    END;

    LOCAL PROCEDURE ClearStepControls@2();
    BEGIN
      // hide all tabs
      IntroVisible := FALSE;
      Step1Visible := FALSE;
      DoneVisible := FALSE;

      // disable all buttons
      BackEnabled := FALSE;
      NextEnabled := FALSE;
      FinishEnabled := FALSE;
    END;

    LOCAL PROCEDURE CalculateNextStep@7(Forward@1000 : Boolean) NextStep : Integer;
    BEGIN
      // // Calculates the next step and hides steps based on whether the Power BI setup is enabled or not

      // General cases
      IF Forward AND (CurrentStep < CurrentStep::Done) THEN
        // move forward 1 step
        NextStep := CurrentStep + 1
      ELSE
        IF NOT Forward AND (CurrentStep > CurrentStep::Intro) THEN
          // move backward 1 step
          NextStep := CurrentStep - 1
        ELSE
          // stay on the current step
          NextStep := CurrentStep;
    END;

    LOCAL PROCEDURE GoToNextStep@10(Forward@1000 : Boolean);
    BEGIN
      IF Forward THEN
        ValidateStep(CurrentStep);

      SetStep(CalculateNextStep(Forward));
    END;

    LOCAL PROCEDURE ValidateStep@11(Step@1000 : Option);
    BEGIN
      IF Step = CurrentStep::AzureAD THEN
        CurrPage.AzureAdSetup.PAGE.ValidateFields;
    END;

    LOCAL PROCEDURE LoadTopBanners@4();
    BEGIN
      IF MediaRepositoryStandard.GET('AssistedSetup-NoText-400px.png',FORMAT(ClientTypeManagement.GetCurrentClientType)) AND
         MediaRepositoryDone.GET('AssistedSetupDone-NoText-400px.png',FORMAT(ClientTypeManagement.GetCurrentClientType))
      THEN
        IF MediaResourcesStandard.GET(MediaRepositoryStandard."Media Resources Ref") AND
           MediaResourcesDone.GET(MediaRepositoryDone."Media Resources Ref")
        THEN
          TopBannerVisible := MediaResourcesDone."Media Reference".HASVALUE;
    END;

    EVENT OAuthIntegration@-28::AuthorizationCodeRetrieved@3(authorizationCode@1000 : Text);
    BEGIN
    END;

    EVENT OAuthIntegration@-28::AuthorizationErrorOccurred@4(error@1001 : Text;description@1000 : Text);
    BEGIN
    END;

    EVENT OAuthIntegration@-28::AppRegistrationInformationRetrieved@5(clientId@1001 : Text;clientSecret@1000 : Text);
    BEGIN
      CurrPage.AzureAdSetup.PAGE.SetAppDetails(clientId,clientSecret);
      CurrPage.UPDATE;
    END;

    EVENT OAuthIntegration@-28::AppRegistrationErrorOccurred@6(errorCode@1001 : Text;description@1000 : Text);
    BEGIN
      CASE errorCode OF
        'NotSupported':
          MESSAGE(NavRegistrationNotSupportedMsg);
        ELSE
          ERROR(NavRegistrationGenericErr);
      END;
    END;

    EVENT OAuthIntegration@-28::ControlAddInReady@7();
    VAR
      AzureADAppSetup@1002 : Record 6300;
      TypeHelper@1001 : Codeunit 10;
      Url@1000 : Text;
    BEGIN
      Url := CurrPage.AzureAdSetup.PAGE.GetRedirectUrl;
      Url := STRSUBSTNO(NavRegistrationPortalTxt,TypeHelper.UrlEncode(Url),FORMAT(CREATEDATETIME(CALCDATE('<1Y>',TODAY),TIME),0,9));

      IF AzureADAppSetup.FINDFIRST THEN
        Url := Url + '&clientId=' + FORMAT(AzureADAppSetup."App ID");

      CurrPage.OAuthIntegration.RegisterApp(Url,AutoRegisterTxt,AutoRegisterTooltipTxt);
    END;

    BEGIN
    END.
  }
}

