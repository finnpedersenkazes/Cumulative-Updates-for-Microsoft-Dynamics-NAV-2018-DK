OBJECT Codeunit 40 LogInManagement
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836,NAVDK11.00.00.21836;
  }
  PROPERTIES
  {
    Permissions=TableData 17=r,
                TableData 18=r,
                TableData 23=r,
                TableData 27=r,
                TableData 51=rimd,
                TableData 9150=rimd,
                TableData 9151=rimd,
                TableData 9152=rimd,
                TableData 9153=rimd;
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      PartnerAgreementNotAcceptedErr@1001 : TextConst 'DAN=Partneraftalen er ikke accepteret.;ENU=Partner Agreement has not been accepted.';
      PasswordChangeNeededErr@1007 : TextConst 'DAN=Du skal angive adgangskoden, f›r du kan forts‘tte.;ENU=You must change the password before you can continue.';
      GLSetup@1011 : Record 98;
      User@1003 : Record 2000000120 SECURITYFILTERING(Filtered);
      NoOfEntries@1060002 : Integer;
      LogInWorkDate@1006 : Date;
      LogInDate@1005 : Date;
      LogInTime@1004 : Time;
      GLSetupRead@1012 : Boolean;
      LicenseOverLimitErrTxt@1060000 : TextConst 'DAN=Din programlicens tillader ikke mere end %1 poster pr. regnskabs†r. I ›jeblikket er der %2 poster i virksomheden.\\Kontakt systemadministratoren for at opdatere programlicensen.;ENU=Your program license does not allow more than %1 entries per fiscal year. %2 entries currently exist in the company.\\Contact your system administrator to update the program license.';
      LicenseNearLimitMsg@1060001 : TextConst 'DAN=Du er ved at overskride gr‘nsen for det antal poster, programlicensen tillader: %1 af %2 i dette regnskabs†r.\\Kontakt systemadministratoren for at opdatere programlicensen.;ENU=You are about to exceed the limit of entries allowed by the program license: %1 of %2 in this fiscal year.\\Contact your system administrator to update the program license.';
      MicrosoftDynamicsC5Txt@1060003 : TextConst '@@@={Locked};DAN=Microsoft Dynamics C5;ENU=Microsoft Dynamics C5';

    [Internal]
    PROCEDURE CompanyOpen@1();
    BEGIN
      IF GUIALLOWED THEN
        LogInStart;
    END;

    [External]
    PROCEDURE CompanyClose@2();
    BEGIN
      IF GUIALLOWED OR (CURRENTCLIENTTYPE = CLIENTTYPE::Web) THEN
        LogInEnd;
    END;

    LOCAL PROCEDURE LogInStart@3();
    VAR
      Language@1005 : Record 2000000045;
      LicenseAgreement@1008 : Record 140;
      GLEntry@1060000 : Record 17;
      AccountingPeriod@1060001 : Record 50;
      ApplicationAreaSetup@1007 : Record 9178;
      ApplicationManagement@1009 : Codeunit 1;
      IdentityManagement@1002 : Codeunit 9801;
      CompanyInformationMgt@1000 : Codeunit 1306;
    BEGIN
      IF NOT CompanyInformationMgt.IsDemoCompany THEN
        IF LicenseAgreement.GET THEN
          IF LicenseAgreement.GetActive AND NOT LicenseAgreement.Accepted THEN BEGIN
            PAGE.RUNMODAL(PAGE::"Additional Customer Terms");
            LicenseAgreement.GET;
            IF NOT LicenseAgreement.Accepted THEN
              ERROR(PartnerAgreementNotAcceptedErr)
          END;

      Language.SETRANGE("Localization Exist",TRUE);
      Language.SETRANGE("Globally Enabled",TRUE);
      Language."Language ID" := GLOBALLANGUAGE;
      IF NOT Language.FIND THEN BEGIN
        Language."Language ID" := WINDOWSLANGUAGE;
        IF NOT Language.FIND THEN
          Language."Language ID" := ApplicationManagement.ApplicationLanguage;
      END;
      GLOBALLANGUAGE := Language."Language ID";

      // Check if the logged in user must change login before allowing access.
      IF NOT User.ISEMPTY THEN BEGIN
        IF IdentityManagement.IsUserNamePasswordAuthentication THEN BEGIN
          User.SETRANGE("User Security ID",USERSECURITYID);
          User.FINDFIRST;
          IF User."Change Password" THEN BEGIN
            PAGE.RUNMODAL(PAGE::"Change Password");
            SELECTLATESTVERSION;
            User.FINDFIRST;
            IF User."Change Password" THEN
              ERROR(PasswordChangeNeededErr);
          END;
        END;

        User.SETRANGE("User Security ID");
      END;

      InitializeCompany;
      UpdateUserPersonalization;
      CreateProfiles;

      LogInDate := TODAY;
      LogInTime := TIME;
      LogInWorkDate := 0D;

      WORKDATE := GetDefaultWorkDate;

      SetupMyRecords;

      ApplicationAreaSetup.SetupApplicationArea;

      OnAfterLogInStart;

      IF GLEntry.READPERMISSION AND AccountingPeriod.READPERMISSION THEN
        CheckLicenseWarning(LastTransactionNo,TODAY);
    END;

    LOCAL PROCEDURE LogInEnd@4();
    VAR
      UserSetup@1000 : Record 91;
      UserTimeRegister@1001 : Record 51;
      LogOutDate@1002 : Date;
      LogOutTime@1003 : Time;
      Minutes@1004 : Integer;
      UserSetupFound@1005 : Boolean;
      RegisterTime@1006 : Boolean;
    BEGIN
      IF LogInDate = 0D THEN
        EXIT;

      IF LogInWorkDate <> 0D THEN
        IF LogInWorkDate = LogInDate THEN
          WORKDATE := TODAY
        ELSE
          WORKDATE := LogInWorkDate;

      IF USERID <> '' THEN BEGIN
        IF UserSetup.GET(USERID) THEN BEGIN
          UserSetupFound := TRUE;
          RegisterTime := UserSetup."Register Time";
        END;
        IF NOT UserSetupFound THEN
          IF GetGLSetup THEN
            RegisterTime := GLSetup."Register Time";
        IF RegisterTime THEN BEGIN
          LogOutDate := TODAY;
          LogOutTime := TIME;
          IF (LogOutDate > LogInDate) OR (LogOutDate = LogInDate) AND (LogOutTime > LogInTime) THEN
            Minutes := ROUND((1440 * (LogOutDate - LogInDate)) + ((LogOutTime - LogInTime) / 60000),1);
          IF Minutes = 0 THEN
            Minutes := 1;
          UserTimeRegister.INIT;
          UserTimeRegister."User ID" := USERID;
          UserTimeRegister.Date := LogInDate;
          IF UserTimeRegister.FIND THEN BEGIN
            UserTimeRegister.Minutes := UserTimeRegister.Minutes + Minutes;
            UserTimeRegister.MODIFY;
          END ELSE BEGIN
            UserTimeRegister.Minutes := Minutes;
            UserTimeRegister.INSERT;
          END;
        END;
      END;
    END;

    [External]
    PROCEDURE InitializeCompany@10();
    BEGIN
      IF NOT GLSetup.GET THEN
        CODEUNIT.RUN(CODEUNIT::"Company-Initialize");
    END;

    [External]
    PROCEDURE CreateProfiles@12();
    VAR
      Profile@1001 : Record 2000000072;
    BEGIN
      IF Profile.ISEMPTY THEN BEGIN
        CODEUNIT.RUN(CODEUNIT::"Conf./Personalization Mgt.");
        COMMIT;
      END;
    END;

    LOCAL PROCEDURE GetGLSetup@5() : Boolean;
    BEGIN
      IF NOT GLSetupRead THEN
        GLSetupRead := GLSetup.GET;
      EXIT(GLSetupRead);
    END;

    PROCEDURE CheckLicense@1060000(PostingDate@1060002 : Date);
    VAR
      TransactionsThisYear@1060001 : Integer;
    BEGIN
      IF NOT LicenseHasTransactionLimit THEN
        EXIT;
      IF EntriesInFY(PostingDate) <= MaxNoOfEntries THEN
        EXIT;
      ERROR(LicenseOverLimitErrTxt,MaxNoOfEntries,EntriesInFY(PostingDate));
    END;

    LOCAL PROCEDURE CheckLicenseWarning@1060009(EntryNo@1060000 : Integer;PostingDate@1060002 : Date);
    VAR
      TransactInYear@1060001 : Integer;
    BEGIN
      IF NOT LicenseHasTransactionLimit THEN
        EXIT;
      IF EntryNo < NearMaxNoOfEntries THEN
        EXIT;

      TransactInYear := EntriesInFY(PostingDate);
      IF TransactInYear < NearMaxNoOfEntries THEN
        EXIT;

      IF TransactInYear >= MaxNoOfEntries THEN
        MESSAGE(LicenseOverLimitErrTxt,MaxNoOfEntries,TransactInYear)
      ELSE
        MESSAGE(LicenseNearLimitMsg,TransactInYear,MaxNoOfEntries);
    END;

    LOCAL PROCEDURE EntriesInFY@1060011(PostingDate@1060000 : Date) : Integer;
    VAR
      AccPeriod@1060005 : Record 50;
      GLEntry@1060004 : Record 17;
      StartDate@1060003 : Date;
      EndDate@1060002 : Date;
    BEGIN
      StartDate := AccPeriod.GetFiscalYearStartDate(PostingDate);
      EndDate := AccPeriod.GetFiscalYearEndDate(PostingDate);
      IF EndDate = 0D THEN
        EndDate := 31129999D;
      GLEntry.SETRANGE("Posting Date",StartDate,EndDate);
      EXIT(GLEntry.COUNT);
    END;

    LOCAL PROCEDURE LastTransactionNo@1060006() : Integer;
    VAR
      GLEntry@1060000 : Record 17;
    BEGIN
      IF GLEntry.FINDLAST THEN
        EXIT(GLEntry."Entry No.");
      EXIT(0);
    END;

    LOCAL PROCEDURE MaxNoOfEntries@1060001() : Integer;
    BEGIN
      EXIT(2500);
    END;

    LOCAL PROCEDURE NearMaxNoOfEntries@1060002() : Integer;
    BEGIN
      EXIT(ROUND(MaxNoOfEntries * 0.95,1));
    END;

    LOCAL PROCEDURE LicenseHasTransactionLimit@1060003() : Boolean;
    VAR
      LicensePermission@1060000 : Record 2000000043;
    BEGIN
      LicensePermission.SETRANGE("Object Type",LicensePermission."Object Type"::System);
      LicensePermission.SETRANGE("Execute Permission",LicensePermission."Execute Permission"::Yes);
      LicensePermission.SETRANGE("Object Number",LimitedTransactionsSysID);
      IF LicensePermission.ISEMPTY THEN
        EXIT(FALSE);

      LicensePermission.SETRANGE("Object Number",UnlimitedTransactionsSysID);
      EXIT(LicensePermission.ISEMPTY);
    END;

    LOCAL PROCEDURE LimitedTransactionsSysID@1060004() : Integer;
    BEGIN
      EXIT(6010);
    END;

    LOCAL PROCEDURE UnlimitedTransactionsSysID@1060005() : Integer;
    BEGIN
      EXIT(6011);
    END;

    [External]
    PROCEDURE GetDefaultWorkDate@6() : Date;
    VAR
      GLEntry@1000 : Record 17;
      CompanyInformationMgt@1002 : Codeunit 1306;
    BEGIN
      IF CompanyInformationMgt.IsDemoCompany THEN
        IF GLEntry.READPERMISSION THEN BEGIN
          GLEntry.SETCURRENTKEY("Posting Date");
          IF GLEntry.FINDLAST THEN BEGIN
            LogInWorkDate := NORMALDATE(GLEntry."Posting Date");
            EXIT(NORMALDATE(GLEntry."Posting Date"));
          END;
        END;

      EXIT(WORKDATE);
    END;

    PROCEDURE IsC5License@1060007() : Boolean;
    VAR
      LicenseInformation@1060000 : Record 2000000040;
    BEGIN
      LicenseInformation.SETFILTER(Text,'''@*'+ MicrosoftDynamicsC5Txt + '*''');
      EXIT(LicenseInformation.FINDFIRST);
    END;

    LOCAL PROCEDURE SetupMyRecords@17();
    VAR
      CompanyInformationMgt@1000 : Codeunit 1306;
    BEGIN
      IF NOT CompanyInformationMgt.IsDemoCompany THEN
        EXIT;

      IF SetupMyCustomer THEN
        EXIT;

      IF SetupMyItem THEN
        EXIT;

      IF SetupMyVendor THEN
        EXIT;

      SetupMyAccount;
    END;

    LOCAL PROCEDURE SetupMyCustomer@7() : Boolean;
    VAR
      Customer@1000 : Record 18;
      MyCustomer@1001 : Record 9150;
      MaxCustomersToAdd@1002 : Integer;
      I@1003 : Integer;
    BEGIN
      IF NOT Customer.READPERMISSION THEN
        EXIT;

      MyCustomer.SETRANGE("User ID",USERID);
      IF NOT MyCustomer.ISEMPTY THEN
        EXIT(TRUE);

      I := 0;
      MaxCustomersToAdd := 5;
      Customer.SETFILTER(Balance,'<>0');
      IF Customer.FINDSET THEN
        REPEAT
          I += 1;
          MyCustomer."User ID" := USERID;
          MyCustomer.VALIDATE("Customer No.",Customer."No.");
          IF MyCustomer.INSERT THEN;
        UNTIL (Customer.NEXT = 0) OR (I >= MaxCustomersToAdd);
    END;

    LOCAL PROCEDURE SetupMyItem@8() : Boolean;
    VAR
      Item@1000 : Record 27;
      MyItem@1001 : Record 9152;
      MaxItemsToAdd@1002 : Integer;
      I@1003 : Integer;
    BEGIN
      IF NOT Item.READPERMISSION THEN
        EXIT;

      MyItem.SETRANGE("User ID",USERID);
      IF NOT MyItem.ISEMPTY THEN
        EXIT(TRUE);

      I := 0;
      MaxItemsToAdd := 5;

      Item.SETFILTER("Unit Price",'<>0');
      IF Item.FINDSET THEN
        REPEAT
          I += 1;
          MyItem."User ID" := USERID;
          MyItem.VALIDATE("Item No.",Item."No.");
          IF MyItem.INSERT THEN;
        UNTIL (Item.NEXT = 0) OR (I >= MaxItemsToAdd);
    END;

    LOCAL PROCEDURE SetupMyVendor@9() : Boolean;
    VAR
      Vendor@1000 : Record 23;
      MyVendor@1001 : Record 9151;
      MaxVendorsToAdd@1002 : Integer;
      I@1003 : Integer;
    BEGIN
      IF NOT Vendor.READPERMISSION THEN
        EXIT;

      MyVendor.SETRANGE("User ID",USERID);
      IF NOT MyVendor.ISEMPTY THEN
        EXIT(TRUE);

      I := 0;
      MaxVendorsToAdd := 5;
      Vendor.SETFILTER(Balance,'<>0');
      IF Vendor.FINDSET THEN
        REPEAT
          I += 1;
          MyVendor."User ID" := USERID;
          MyVendor.VALIDATE("Vendor No.",Vendor."No.");
          IF MyVendor.INSERT THEN;
        UNTIL (Vendor.NEXT = 0) OR (I >= MaxVendorsToAdd);
    END;

    LOCAL PROCEDURE SetupMyAccount@11() : Boolean;
    VAR
      GLAccount@1000 : Record 15;
      MyAccount@1001 : Record 9153;
      MaxAccountsToAdd@1002 : Integer;
      I@1003 : Integer;
    BEGIN
      IF NOT GLAccount.READPERMISSION THEN
        EXIT;

      MyAccount.SETRANGE("User ID",USERID);
      IF NOT MyAccount.ISEMPTY THEN
        EXIT(TRUE);

      I := 0;
      MaxAccountsToAdd := 5;
      GLAccount.SETRANGE("Reconciliation Account",TRUE);
      IF GLAccount.FINDSET THEN
        REPEAT
          I += 1;
          MyAccount."User ID" := USERID;
          MyAccount.VALIDATE("Account No.",GLAccount."No.");
          IF MyAccount.INSERT THEN;
        UNTIL (GLAccount.NEXT = 0) OR (I >= MaxAccountsToAdd);
    END;

    [External]
    PROCEDURE UserLogonExistsWithinPeriod@13(PeriodType@1000 : 'Day,Week,Month,Quarter,Year,Accounting Period';NoOfPeriods@1001 : Integer) : Boolean;
    VAR
      SessionEvent@1002 : Record 2000000111;
      PeriodFormManagement@1003 : Codeunit 359;
      FromEventDateTime@1004 : DateTime;
    BEGIN
      FromEventDateTime := CREATEDATETIME(PeriodFormManagement.MoveDateByPeriod(TODAY,PeriodType,-NoOfPeriods),TIME);
      SessionEvent.SETRANGE("Event Datetime",FromEventDateTime,CURRENTDATETIME);
      SessionEvent.SETRANGE("Event Type",SessionEvent."Event Type"::Logon);
      // Filter out sessions of type Web Service, Client Service, NAS, Background and Management Client
      SessionEvent.SETFILTER("Client Type",'<%1|>%2',
        SessionEvent."Client Type"::"Web Service",SessionEvent."Client Type"::"Management Client");
      SessionEvent.SETRANGE("Database Name",GetDatabase);
      EXIT(NOT SessionEvent.ISEMPTY);
    END;

    LOCAL PROCEDURE GetDatabase@14() : Text[250];
    VAR
      ActiveSession@1000 : Record 2000000110;
    BEGIN
      ActiveSession.GET(SERVICEINSTANCEID,SESSIONID);
      EXIT(ActiveSession."Database Name");
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnAfterLogInStart@16();
    BEGIN
    END;

    LOCAL PROCEDURE UpdateUserPersonalization@15();
    VAR
      UserPersonalization@1001 : Record 2000000073;
      Profile@1002 : Record 2000000178;
      AllObjWithCaption@1003 : Record 2000000058;
      PermissionManager@1004 : Codeunit 9002;
      ProfileScope@1005 : 'System,Tenant';
      AppID@1006 : GUID;
    BEGIN
      IF NOT UserPersonalization.GET(USERSECURITYID) THEN
        EXIT;

      IF Profile.GET(UserPersonalization.Scope,UserPersonalization."App ID",UserPersonalization."Profile ID") THEN BEGIN
        AllObjWithCaption.SETRANGE("Object Type",AllObjWithCaption."Object Type"::Page);
        AllObjWithCaption.SETRANGE("Object Subtype",'RoleCenter');
        AllObjWithCaption.SETRANGE("Object ID",Profile."Role Center ID");
        IF AllObjWithCaption.ISEMPTY THEN BEGIN
          UserPersonalization."Profile ID" := '';
          UserPersonalization.MODIFY;
          COMMIT;
        END;
      END ELSE
        IF PermissionManager.SoftwareAsAService THEN BEGIN
          Profile.RESET;
          PermissionManager.GetDefaultProfileID(USERSECURITYID,Profile);

          IF NOT Profile.ISEMPTY THEN BEGIN
            UserPersonalization."Profile ID" := Profile."Profile ID";
            UserPersonalization.Scope := Profile.Scope;
            UserPersonalization."App ID" := Profile."App ID";
            UserPersonalization.MODIFY;
          END ELSE BEGIN
            UserPersonalization."Profile ID" := '';
            UserPersonalization.Scope := ProfileScope::System;
            UserPersonalization."App ID" := AppID;
            UserPersonalization.MODIFY;
          END;
        END;
    END;

    BEGIN
    END.
  }
}

