OBJECT Codeunit 1430 Role Center Notification Mgt.
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
      EvaluationNotificationIdTxt@1013 : TextConst '@@@={Locked};DAN=cb28c63d-4daf-453a-b41b-a8de9963d563;ENU=cb28c63d-4daf-453a-b41b-a8de9963d563';
      TrialNotificationIdTxt@1012 : TextConst '@@@={Locked};DAN=2751b488-ca52-42ef-b6d7-d7b4ba841e80;ENU=2751b488-ca52-42ef-b6d7-d7b4ba841e80';
      TrialSuspendedNotificationIdTxt@1022 : TextConst '@@@={Locked};DAN=2751b488-ca52-42ef-b6d7-d7b4ba841e80;ENU=2751b488-ca52-42ef-b6d7-d7b4ba841e80';
      PaidWarningNotificationIdTxt@1011 : TextConst '@@@={Locked};DAN=2751b488-ca52-42ef-b6d7-d7b4ba841e80;ENU=2751b488-ca52-42ef-b6d7-d7b4ba841e80';
      PaidSuspendedNotificationIdTxt@1009 : TextConst '@@@={Locked};DAN=2751b488-ca52-42ef-b6d7-d7b4ba841e80;ENU=2751b488-ca52-42ef-b6d7-d7b4ba841e80';
      SandboxNotificationIdTxt@1015 : TextConst '@@@={Locked};DAN=d82835d9-a005-451a-972b-0d6532de2071;ENU=d82835d9-a005-451a-972b-0d6532de2071';
      TrialNotificationDaysSinceStartTxt@1014 : TextConst '@@@={Locked};DAN=1;ENU=1';
      EvaluationNotificationLinkTxt@1007 : TextConst 'DAN=Start prõveversion ...;ENU=Start trial...';
      TrialNotificationLinkTxt@1003 : TextConst 'DAN=Kõb abonnement ...;ENU=Buy subscription...';
      TrialSuspendedNotificationLinkTxt@1020 : TextConst 'DAN=Abonner nu...;ENU=Subscribe now...';
      PaidWarningNotificationLinkTxt@1008 : TextConst 'DAN=Forny abonnement ...;ENU=Renew subscription...';
      PaidSuspendedNotificationLinkTxt@1005 : TextConst 'DAN=Forny abonnement ...;ENU=Renew subscription...';
      EvaluationNotificationMsg@1000 : TextConst '@@@="%1=Trial duration in days";DAN=ùnsker du mere? Start en gratis %1-dages prõveversion. Du fÜr adgang til avancerede funktioner og kan bruge dine egne virksomhedsdata.;ENU=Want more? Start a free, %1-day trial to unlock advanced features and use your own company data.';
      TrialNotificationMsg@1001 : TextConst '@@@="%1=Count of days until trial expires";DAN=Din prõveperiode udlõber om %1 dage. Kunne du tënke dig et abonnement?;ENU=Your trial period expires in %1 days. Do you want to get a subscription?';
      TrialSuspendedNotificationMsg@1019 : TextConst '@@@="%1=Count of days until block of access";DAN=Din prõveperiode er udlõbet. Tegn abonnement inden for %1 dage for at bevare dine virksomhedsdata.;ENU=Your trial period has expired. Subscribe within %1 days and keep your company data.';
      PaidWarningNotificationMsg@1004 : TextConst '@@@="%1=Count of days until block of access";DAN=Dit abonnement udlõber om %1 dage. Forny snart for at bevare dit arbejde.;ENU=Your subscription expires in %1 days. Renew soon to keep your work.';
      PaidSuspendedNotificationMsg@1017 : TextConst '@@@="%1=Count of days until data deletion";DAN=Dit abonnement er udlõbet. Hvis du ikke vëlger fornyelse, sletter vi dine data om %1 dage.;ENU=Your subscription has expired. Unless you renew, we will delete your data in %1 days.';
      ChooseCompanyMsg@1002 : TextConst 'DAN=Vëlg en ikke-eksempelvirksomhed for at starte din prõveversion.;ENU=Choose a non-evaluation company to start your trial.';
      SignOutToStartTrialMsg@1010 : TextConst '@@@=%1 - product name;DAN=Vi er glade for, at du har valgt at se nërmere pÜ %1!\\Log pÜ igen for at komme videre.;ENU=We''re glad you''ve chosen to explore %1!\\To get going, sign in again.';
      SandboxNotificationMsg@1006 : TextConst 'DAN=Dette er et eksempel pÜ et sandkassemiljõ, kun til test-, demonstrations- eller udviklingsformÜl.;ENU=This is a sandbox environment (preview) for test, demo, or development purposes only.';
      SandboxNotificationNameTok@1016 : TextConst 'DAN=Giv brugeren besked om eksemplet pÜ sandkassemiljõet.;ENU=Notify user of sandbox environment (preview).';
      DontShowThisAgainMsg@1018 : TextConst 'DAN=Vis ikke dette igen.;ENU=Don''t show this again.';
      SandboxNotificationDescTok@1021 : TextConst 'DAN=Vis brugeren en notifikation om, at han eller hun arbejder i et eksempel pÜ et sandkassemiljõ.;ENU=Show a notification informing the user that they are working in a sandbox environment (preview).';

    LOCAL PROCEDURE CreateAndSendEvaluationNotification@10();
    VAR
      EvaluationNotification@1001 : Notification;
      TrialTotalDays@1000 : Integer;
    BEGIN
      TrialTotalDays := GetTrialTotalDays;
      EvaluationNotification.ID := GetEvaluationNotificationId;
      EvaluationNotification.MESSAGE := STRSUBSTNO(EvaluationNotificationMsg,TrialTotalDays);
      EvaluationNotification.SCOPE := NOTIFICATIONSCOPE::LocalScope;
      EvaluationNotification.ADDACTION(
        EvaluationNotificationLinkTxt,CODEUNIT::"Role Center Notification Mgt.",'EvaluationNotificationAction');
      EvaluationNotification.SEND;
    END;

    LOCAL PROCEDURE CreateAndSendTrialNotification@21();
    VAR
      TrialNotification@1001 : Notification;
      RemainingDays@1000 : Integer;
    BEGIN
      RemainingDays := GetLicenseRemainingDays;
      TrialNotification.ID := GetTrialNotificationId;
      TrialNotification.MESSAGE := STRSUBSTNO(TrialNotificationMsg,RemainingDays);
      TrialNotification.SCOPE := NOTIFICATIONSCOPE::LocalScope;
      TrialNotification.ADDACTION(
        TrialNotificationLinkTxt,CODEUNIT::"Role Center Notification Mgt.",'TrialNotificationAction');
      TrialNotification.SEND;
    END;

    LOCAL PROCEDURE CreateAndSendTrialSuspendedNotification@70();
    VAR
      TrialSuspendedNotification@1001 : Notification;
      RemainingDays@1000 : Integer;
    BEGIN
      RemainingDays := GetLicenseRemainingDays;
      TrialSuspendedNotification.ID := GetTrialSuspendedNotificationId;
      TrialSuspendedNotification.MESSAGE := STRSUBSTNO(TrialSuspendedNotificationMsg,RemainingDays);
      TrialSuspendedNotification.SCOPE := NOTIFICATIONSCOPE::LocalScope;
      TrialSuspendedNotification.ADDACTION(
        TrialSuspendedNotificationLinkTxt,CODEUNIT::"Role Center Notification Mgt.",'TrialSuspendedNotificationAction');
      TrialSuspendedNotification.SEND;
    END;

    LOCAL PROCEDURE CreateAndSendPaidWarningNotification@26();
    VAR
      PaidWarningNotification@1001 : Notification;
      RemainingDays@1000 : Integer;
    BEGIN
      RemainingDays := GetLicenseRemainingDays;
      PaidWarningNotification.ID := GetPaidWarningNotificationId;
      PaidWarningNotification.MESSAGE := STRSUBSTNO(PaidWarningNotificationMsg,RemainingDays);
      PaidWarningNotification.SCOPE := NOTIFICATIONSCOPE::LocalScope;
      PaidWarningNotification.ADDACTION(
        PaidWarningNotificationLinkTxt,CODEUNIT::"Role Center Notification Mgt.",'PaidWarningNotificationAction');
      PaidWarningNotification.SEND;
    END;

    LOCAL PROCEDURE CreateAndSendPaidSuspendedNotification@25();
    VAR
      PaidSuspendedNotification@1001 : Notification;
      RemainingDays@1000 : Integer;
    BEGIN
      RemainingDays := GetLicenseRemainingDays;
      PaidSuspendedNotification.ID := GetPaidSuspendedNotificationId;
      PaidSuspendedNotification.MESSAGE := STRSUBSTNO(PaidSuspendedNotificationMsg,RemainingDays);
      PaidSuspendedNotification.SCOPE := NOTIFICATIONSCOPE::LocalScope;
      PaidSuspendedNotification.ADDACTION(
        PaidSuspendedNotificationLinkTxt,CODEUNIT::"Role Center Notification Mgt.",'PaidSuspendedNotificationAction');
      PaidSuspendedNotification.SEND;
    END;

    LOCAL PROCEDURE CreateAndSendSandboxNotification@32();
    VAR
      SandboxNotification@1001 : Notification;
    BEGIN
      SandboxNotification.ID := GetSandboxNotificationId;
      SandboxNotification.MESSAGE := SandboxNotificationMsg;
      SandboxNotification.SCOPE := NOTIFICATIONSCOPE::LocalScope;
      SandboxNotification.ADDACTION(DontShowThisAgainMsg,CODEUNIT::"Role Center Notification Mgt.",'DisableSandboxNotification');
      SandboxNotification.SEND;
    END;

    PROCEDURE HideEvaluationNotificationAfterStartingTrial@13();
    VAR
      EvaluationNotification@1001 : Notification;
    BEGIN
      IF NOT IsTrialMode THEN
        EXIT;
      IF NOT AreNotificationsSupported THEN
        EXIT;
      EvaluationNotification.ID := GetEvaluationNotificationId;
      EvaluationNotification.RECALL;
    END;

    PROCEDURE GetEvaluationNotificationId@8() : GUID;
    VAR
      EvaluationNotificationId@1000 : GUID;
    BEGIN
      EVALUATE(EvaluationNotificationId,EvaluationNotificationIdTxt);
      EXIT(EvaluationNotificationId);
    END;

    PROCEDURE GetTrialNotificationId@19() : GUID;
    VAR
      TrialNotificationId@1000 : GUID;
    BEGIN
      EVALUATE(TrialNotificationId,TrialNotificationIdTxt);
      EXIT(TrialNotificationId);
    END;

    PROCEDURE GetTrialSuspendedNotificationId@63() : GUID;
    VAR
      TrialSuspendedNotificationId@1000 : GUID;
    BEGIN
      EVALUATE(TrialSuspendedNotificationId,TrialSuspendedNotificationIdTxt);
      EXIT(TrialSuspendedNotificationId);
    END;

    PROCEDURE GetPaidWarningNotificationId@31() : GUID;
    VAR
      PaidWarningNotificationId@1000 : GUID;
    BEGIN
      EVALUATE(PaidWarningNotificationId,PaidWarningNotificationIdTxt);
      EXIT(PaidWarningNotificationId);
    END;

    PROCEDURE GetPaidSuspendedNotificationId@28() : GUID;
    VAR
      PaidSuspendedNotificationId@1000 : GUID;
    BEGIN
      EVALUATE(PaidSuspendedNotificationId,PaidSuspendedNotificationIdTxt);
      EXIT(PaidSuspendedNotificationId);
    END;

    PROCEDURE GetSandboxNotificationId@36() : GUID;
    VAR
      SandboxNotificationId@1000 : GUID;
    BEGIN
      EVALUATE(SandboxNotificationId,SandboxNotificationIdTxt);
      EXIT(SandboxNotificationId);
    END;

    LOCAL PROCEDURE AreNotificationsSupported@22() : Boolean;
    VAR
      PermissionManager@1001 : Codeunit 9002;
      IdentityManagement@1000 : Codeunit 9801;
    BEGIN
      IF NOT GUIALLOWED THEN
        EXIT(FALSE);

      IF IdentityManagement.IsInvAppId THEN
        EXIT(FALSE);

      IF NOT PermissionManager.SoftwareAsAService THEN
        EXIT(FALSE);

      IF PermissionManager.IsSandboxConfiguration THEN
        EXIT(FALSE);

      IF PermissionManager.IsPreview THEN
        EXIT(FALSE);

      EXIT(TRUE);
    END;

    LOCAL PROCEDURE AreSandboxNotificationsSupported@41() : Boolean;
    VAR
      PermissionManager@1001 : Codeunit 9002;
      IdentityManagement@1000 : Codeunit 9801;
    BEGIN
      IF NOT GUIALLOWED THEN
        EXIT(FALSE);

      IF IdentityManagement.IsInvAppId THEN
        EXIT(FALSE);

      IF NOT PermissionManager.SoftwareAsAService THEN
        EXIT(FALSE);

      IF NOT PermissionManager.IsSandboxConfiguration THEN
        EXIT(FALSE);

      EXIT(TRUE);
    END;

    LOCAL PROCEDURE IsEvaluationNotificationEnabled@24() : Boolean;
    VAR
      RoleCenterNotifications@1000 : Record 1430;
    BEGIN
      IF NOT IsEvaluationMode THEN
        EXIT(FALSE);

      IF NOT AreNotificationsSupported THEN
        EXIT(FALSE);

      RoleCenterNotifications.Initialize;

      IF RoleCenterNotifications.GetEvaluationNotificationState =
         RoleCenterNotifications."Evaluation Notification State"::Disabled
      THEN
        EXIT(FALSE);

      EXIT(TRUE);
    END;

    LOCAL PROCEDURE IsTrialNotificationEnabled@12() : Boolean;
    VAR
      RoleCenterNotifications@1000 : Record 1430;
    BEGIN
      IF NOT IsTrialMode THEN
        EXIT(FALSE);

      IF NOT AreNotificationsSupported THEN
        EXIT(FALSE);

      IF RoleCenterNotifications.IsFirstLogon THEN
        EXIT(FALSE);

      IF GetLicenseFullyUsedDays < GetTrialNotificationDaysSinceStart THEN
        EXIT(FALSE);

      EXIT(IsBuyNotificationEnabled);
    END;

    LOCAL PROCEDURE IsTrialSuspendedNotificationEnabled@65() : Boolean;
    VAR
      RoleCenterNotifications@1000 : Record 1430;
    BEGIN
      IF NOT IsTrialSuspendedMode THEN
        EXIT(FALSE);

      IF NOT AreNotificationsSupported THEN
        EXIT(FALSE);

      IF RoleCenterNotifications.IsFirstLogon THEN
        EXIT(FALSE);

      EXIT(IsBuyNotificationEnabled);
    END;

    LOCAL PROCEDURE IsPaidWarningNotificationEnabled@35() : Boolean;
    VAR
      RoleCenterNotifications@1000 : Record 1430;
    BEGIN
      IF NOT IsPaidWarningMode THEN
        EXIT(FALSE);

      IF NOT AreNotificationsSupported THEN
        EXIT(FALSE);

      IF RoleCenterNotifications.IsFirstLogon THEN
        EXIT(FALSE);

      EXIT(IsBuyNotificationEnabled);
    END;

    LOCAL PROCEDURE IsPaidSuspendedNotificationEnabled@33() : Boolean;
    VAR
      RoleCenterNotifications@1000 : Record 1430;
    BEGIN
      IF NOT IsPaidSuspendedMode THEN
        EXIT(FALSE);

      IF NOT AreNotificationsSupported THEN
        EXIT(FALSE);

      IF RoleCenterNotifications.IsFirstLogon THEN
        EXIT(FALSE);

      EXIT(IsBuyNotificationEnabled);
    END;

    PROCEDURE ShowNotifications@34() : Boolean;
    VAR
      DataMigrationMgt@1006 : Codeunit 1798;
      DataClassificationMgt@1007 : Codeunit 1750;
      ResultEvaluation@1001 : Boolean;
      ResultTrial@1000 : Boolean;
      ResultTrialSuspended@1003 : Boolean;
      ResultPaidWarning@1005 : Boolean;
      ResultPaidSuspended@1004 : Boolean;
      ResultSandbox@1002 : Boolean;
    BEGIN
      ResultEvaluation := ShowEvaluationNotification;
      ResultTrial := ShowTrialNotification;
      ResultTrialSuspended := ShowTrialSuspendedNotification;
      ResultPaidWarning := ShowPaidWarningNotification;
      ResultPaidSuspended := ShowPaidSuspendedNotification;
      ResultSandbox := ShowSandboxNotification;

      DataMigrationMgt.ShowDataMigrationRelatedGlobalNotifications;
      DataClassificationMgt.ShowNotifications;

      COMMIT;
      EXIT(
        ResultEvaluation OR
        ResultTrial OR ResultTrialSuspended OR
        ResultPaidWarning OR ResultPaidSuspended OR
        ResultSandbox);
    END;

    PROCEDURE ShowEvaluationNotification@7() : Boolean;
    VAR
      Company@1000 : Record 2000000006;
    BEGIN
      IF NOT IsEvaluationNotificationEnabled THEN
        EXIT(FALSE);

      // Verify, that the user has company setup rights
      IF NOT Company.WRITEPERMISSION THEN
        EXIT(FALSE);

      CreateAndSendEvaluationNotification;
      EXIT(TRUE);
    END;

    PROCEDURE ShowTrialNotification@18() : Boolean;
    BEGIN
      IF NOT IsTrialNotificationEnabled THEN
        EXIT(FALSE);

      CreateAndSendTrialNotification;
      EXIT(TRUE);
    END;

    PROCEDURE ShowTrialSuspendedNotification@67() : Boolean;
    BEGIN
      IF NOT IsTrialSuspendedNotificationEnabled THEN
        EXIT(FALSE);

      CreateAndSendTrialSuspendedNotification;
      EXIT(TRUE);
    END;

    PROCEDURE ShowPaidWarningNotification@40() : Boolean;
    BEGIN
      IF NOT IsPaidWarningNotificationEnabled THEN
        EXIT(FALSE);

      CreateAndSendPaidWarningNotification;
      EXIT(TRUE);
    END;

    PROCEDURE ShowPaidSuspendedNotification@39() : Boolean;
    BEGIN
      IF NOT IsPaidSuspendedNotificationEnabled THEN
        EXIT(FALSE);

      CreateAndSendPaidSuspendedNotification;
      EXIT(TRUE);
    END;

    PROCEDURE ShowSandboxNotification@16() : Boolean;
    VAR
      MyNotifications@1000 : Record 1518;
    BEGIN
      IF NOT AreSandboxNotificationsSupported THEN
        EXIT(FALSE);

      IF NOT MyNotifications.IsEnabled(GetSandboxNotificationId) THEN
        EXIT(FALSE);

      CreateAndSendSandboxNotification;
      EXIT(TRUE);
    END;

    PROCEDURE EvaluationNotificationAction@4(EvaluationNotification@1000 : Notification);
    BEGIN
      StartTrial;
    END;

    PROCEDURE TrialNotificationAction@2(TrialNotification@1001 : Notification);
    BEGIN
      BuySubscription;
    END;

    PROCEDURE TrialSuspendedNotificationAction@38(TrialSuspendedNotification@1001 : Notification);
    BEGIN
      BuySubscription;
    END;

    PROCEDURE PaidWarningNotificationAction@45(PaidWarningNotification@1001 : Notification);
    BEGIN
      BuySubscription;
    END;

    PROCEDURE PaidSuspendedNotificationAction@42(PaidSuspendedNotification@1001 : Notification);
    BEGIN
      BuySubscription;
    END;

    LOCAL PROCEDURE IsEvaluationMode@6() : Boolean;
    VAR
      TenantLicenseState@1000 : Record 2000000189;
      CurrentState@1001 : Option;
      PreviousState@1002 : Option;
    BEGIN
      GetLicenseState(CurrentState,PreviousState);
      EXIT(CurrentState = TenantLicenseState.State::Evaluation);
    END;

    LOCAL PROCEDURE IsTrialMode@3() : Boolean;
    VAR
      TenantLicenseState@1000 : Record 2000000189;
      CurrentState@1002 : Option;
      PreviousState@1001 : Option;
    BEGIN
      GetLicenseState(CurrentState,PreviousState);
      EXIT(CurrentState = TenantLicenseState.State::Trial);
    END;

    LOCAL PROCEDURE IsTrialSuspendedMode@60() : Boolean;
    VAR
      TenantLicenseState@1000 : Record 2000000189;
      CurrentState@1002 : Option;
      PreviousState@1001 : Option;
    BEGIN
      GetLicenseState(CurrentState,PreviousState);
      EXIT((CurrentState = TenantLicenseState.State::Suspended) AND (PreviousState = TenantLicenseState.State::Trial));
    END;

    LOCAL PROCEDURE IsPaidWarningMode@48() : Boolean;
    VAR
      TenantLicenseState@1000 : Record 2000000189;
      CurrentState@1002 : Option;
      PreviousState@1001 : Option;
    BEGIN
      GetLicenseState(CurrentState,PreviousState);
      EXIT((CurrentState = TenantLicenseState.State::Warning) AND (PreviousState = TenantLicenseState.State::Paid));
    END;

    LOCAL PROCEDURE IsPaidSuspendedMode@47() : Boolean;
    VAR
      TenantLicenseState@1000 : Record 2000000189;
      CurrentState@1002 : Option;
      PreviousState@1001 : Option;
    BEGIN
      GetLicenseState(CurrentState,PreviousState);
      EXIT((CurrentState = TenantLicenseState.State::Suspended) AND (PreviousState = TenantLicenseState.State::Paid));
    END;

    LOCAL PROCEDURE GetLicenseState@5(VAR CurrentState@1001 : Option;VAR PreviousState@1002 : Option);
    VAR
      TenantLicenseState@1000 : Record 2000000189;
    BEGIN
      PreviousState := TenantLicenseState.State::Evaluation;
      IF TenantLicenseState.FIND('+') THEN BEGIN
        CurrentState := TenantLicenseState.State;
        IF (CurrentState = TenantLicenseState.State::Warning) OR (CurrentState = TenantLicenseState.State::Suspended) THEN BEGIN
          WHILE TenantLicenseState.NEXT(-1) <> 0 DO BEGIN
            PreviousState := TenantLicenseState.State;
            IF (PreviousState = TenantLicenseState.State::Trial) OR (PreviousState = TenantLicenseState.State::Paid) THEN
              EXIT;
          END;
          PreviousState := TenantLicenseState.State::Paid;
        END;
      END ELSE
        CurrentState := TenantLicenseState.State::Evaluation;
    END;

    PROCEDURE GetLicenseRemainingDays@11() : Integer;
    VAR
      TenantLicenseState@1000 : Record 2000000189;
      DateFilterCalc@1002 : Codeunit 358;
      Now@1001 : DateTime;
      TimeDuration@1003 : Decimal;
      MillisecondsPerDay@1005 : BigInteger;
      RemainingDays@1004 : Integer;
    BEGIN
      Now := DateFilterCalc.ConvertToUtcDateTime(CURRENTDATETIME);
      IF TenantLicenseState.FINDLAST THEN
        IF TenantLicenseState."End Date" > Now THEN BEGIN
          TimeDuration := TenantLicenseState."End Date" - Now;
          MillisecondsPerDay := 86400000;
          RemainingDays := ROUND(TimeDuration / MillisecondsPerDay,1,'=');
          EXIT(RemainingDays);
        END;
      EXIT(0);
    END;

    LOCAL PROCEDURE GetLicenseFullyUsedDays@37() : Integer;
    VAR
      TenantLicenseState@1000 : Record 2000000189;
      DateFilterCalc@1002 : Codeunit 358;
      Now@1001 : DateTime;
      TimeDuration@1003 : Decimal;
      MillisecondsPerDay@1005 : BigInteger;
      FullyUsedDays@1004 : Integer;
    BEGIN
      Now := DateFilterCalc.ConvertToUtcDateTime(CURRENTDATETIME);
      IF TenantLicenseState.FINDLAST THEN
        IF Now > TenantLicenseState."Start Date" THEN BEGIN
          TimeDuration := Now - TenantLicenseState."Start Date";
          MillisecondsPerDay := 86400000;
          FullyUsedDays := ROUND(TimeDuration / MillisecondsPerDay,1,'<');
          EXIT(FullyUsedDays);
        END;
      EXIT(0);
    END;

    PROCEDURE GetTrialTotalDays@9() : Integer;
    VAR
      TenantLicenseState@1002 : Record 2000000189;
      TenantLicenseStateMgt@1000 : Codeunit 2300;
      TrialTotalDays@1001 : Integer;
    BEGIN
      TrialTotalDays := TenantLicenseStateMgt.GetPeriod(TenantLicenseState.State::Trial);
      EXIT(TrialTotalDays);
    END;

    LOCAL PROCEDURE GetTrialNotificationDaysSinceStart@27() : Integer;
    VAR
      DaysSinceStart@1001 : Integer;
    BEGIN
      EVALUATE(DaysSinceStart,TrialNotificationDaysSinceStartTxt);
      EXIT(DaysSinceStart);
    END;

    LOCAL PROCEDURE StartTrial@43();
    VAR
      UserPersonalization@1001 : Record 2000000073;
      NewCompany@1000 : Text[30];
    BEGIN
      IF NOT GetMyCompany(NewCompany) THEN BEGIN
        MESSAGE(ChooseCompanyMsg);
        CreateAndSendEvaluationNotification;
        EXIT;
      END;

      ClickEvaluationNotification;
      COMMIT;

      UserPersonalization.GET(USERSECURITYID);
      // The wizard is started by OnBeforeValidate, it could raise an error if terms & conditions are not accepted
      UserPersonalization.VALIDATE(Company,NewCompany);
      UserPersonalization.MODIFY(TRUE);

      DisableEvaluationNotification;

      MESSAGE(STRSUBSTNO(SignOutToStartTrialMsg,PRODUCTNAME.MARKETING));
    END;

    LOCAL PROCEDURE BuySubscription@44();
    BEGIN
      DisableBuyNotification;
      PAGE.RUN(PAGE::"Buy Subscription");
    END;

    LOCAL PROCEDURE ClickEvaluationNotification@1();
    VAR
      RoleCenterNotifications@1000 : Record 1430;
    BEGIN
      RoleCenterNotifications.SetEvaluationNotificationState(RoleCenterNotifications."Evaluation Notification State"::Clicked);
    END;

    PROCEDURE DisableEvaluationNotification@29();
    VAR
      RoleCenterNotifications@1000 : Record 1430;
    BEGIN
      RoleCenterNotifications.SetEvaluationNotificationState(RoleCenterNotifications."Evaluation Notification State"::Disabled);
    END;

    PROCEDURE EnableEvaluationNotification@80();
    VAR
      RoleCenterNotifications@1000 : Record 1430;
    BEGIN
      RoleCenterNotifications.SetEvaluationNotificationState(RoleCenterNotifications."Evaluation Notification State"::Enabled);
    END;

    PROCEDURE IsEvaluationNotificationClicked@30() : Boolean;
    VAR
      RoleCenterNotifications@1000 : Record 1430;
    BEGIN
      EXIT(RoleCenterNotifications.GetEvaluationNotificationState = RoleCenterNotifications."Evaluation Notification State"::Clicked);
    END;

    PROCEDURE DisableBuyNotification@20();
    VAR
      RoleCenterNotifications@1000 : Record 1430;
    BEGIN
      RoleCenterNotifications.SetBuyNotificationState(RoleCenterNotifications."Buy Notification State"::Disabled);
    END;

    PROCEDURE EnableBuyNotification@79();
    VAR
      RoleCenterNotifications@1000 : Record 1430;
    BEGIN
      RoleCenterNotifications.SetBuyNotificationState(RoleCenterNotifications."Buy Notification State"::Enabled);
    END;

    LOCAL PROCEDURE IsBuyNotificationEnabled@17() : Boolean;
    VAR
      RoleCenterNotifications@1000 : Record 1430;
    BEGIN
      EXIT(RoleCenterNotifications.GetBuyNotificationState <> RoleCenterNotifications."Buy Notification State"::Disabled);
    END;

    PROCEDURE DisableSandboxNotification@46(Notification@1000 : Notification);
    VAR
      MyNotifications@1001 : Record 1518;
    BEGIN
      IF NOT MyNotifications.Disable(GetSandboxNotificationId) THEN
        MyNotifications.InsertDefault(GetSandboxNotificationId,SandboxNotificationNameTok,SandboxNotificationDescTok,FALSE);
    END;

    PROCEDURE CompanyNotSelectedMessage@14() : Text;
    BEGIN
      EXIT('');
    END;

    PROCEDURE EvaluationNotificationMessage@61() : Text;
    BEGIN
      EXIT(EvaluationNotificationMsg);
    END;

    PROCEDURE TrialNotificationMessage@68() : Text;
    BEGIN
      EXIT(TrialNotificationMsg);
    END;

    PROCEDURE TrialSuspendedNotificationMessage@71() : Text;
    BEGIN
      EXIT(TrialSuspendedNotificationMsg);
    END;

    PROCEDURE PaidWarningNotificationMessage@74() : Text;
    BEGIN
      EXIT(PaidWarningNotificationMsg);
    END;

    PROCEDURE PaidSuspendedNotificationMessage@75() : Text;
    BEGIN
      EXIT(PaidSuspendedNotificationMsg);
    END;

    PROCEDURE SandboxNotificationMessage@15() : Text;
    BEGIN
      EXIT(SandboxNotificationMsg);
    END;

    LOCAL PROCEDURE GetMyCompany@62(VAR MyCompany@1000 : Text[30]) : Boolean;
    VAR
      SelectedCompany@1002 : Record 2000000006;
      AllowedCompanies@1001 : Page 9177;
    BEGIN
      SelectedCompany.SETRANGE("Evaluation Company",FALSE);
      SelectedCompany.FINDFIRST;
      IF SelectedCompany.COUNT = 1 THEN BEGIN
        MyCompany := SelectedCompany.Name;
        EXIT(TRUE);
      END;

      AllowedCompanies.Initialize;

      IF SelectedCompany.GET(COMPANYNAME) THEN
        AllowedCompanies.SETRECORD(SelectedCompany);

      AllowedCompanies.LOOKUPMODE(TRUE);

      IF AllowedCompanies.RUNMODAL = ACTION::LookupOK THEN BEGIN
        AllowedCompanies.GETRECORD(SelectedCompany);
        IF SelectedCompany."Evaluation Company" THEN
          EXIT(FALSE);
        MyCompany := SelectedCompany.Name;
        EXIT(TRUE);
      END;

      EXIT(FALSE);
    END;

    [EventSubscriber(Page,1518,OnInitializingNotificationWithDefaultState)]
    PROCEDURE OnInitializingNotificationWithDefaultState@23();
    VAR
      MyNotifications@1000 : Record 1518;
    BEGIN
      IF AreSandboxNotificationsSupported THEN
        MyNotifications.InsertDefault(GetSandboxNotificationId,SandboxNotificationNameTok,SandboxNotificationDescTok,TRUE);
    END;

    BEGIN
    END.
  }
}

