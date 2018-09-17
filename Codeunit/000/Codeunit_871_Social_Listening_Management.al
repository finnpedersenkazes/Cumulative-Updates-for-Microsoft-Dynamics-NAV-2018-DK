OBJECT Codeunit 871 Social Listening Management
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      MslProductNameTxt@1000 : TextConst '@@@={locked};DAN=Microsoft Social Engagement;ENU=Microsoft Social Engagement';
      FailedToConnectTxt@1002 : TextConst '@@@="%1 = Microsoft Social Engagement, %2 = refresh, %3 - product name";DAN=Der kunne ikke oprettes forbindelse til %1.<br><br>Kontroll�r konfigurationen af %1 i %3.<br><br>Derefter %2 for at pr�ve at oprette forbindelse til %1 igen.;ENU=Failed to connect to %1.<br><br>Verify the configuration of %1 in %3.<br><br>Afterwards %2 to try connecting to %1 again.';
      HasNotBeenAuthenticatedTxt@1001 : TextConst '@@@="%1 = Microsoft Social Engagement, %2= Microsoft Social Engagement,%3 = refresh";DAN=%1 er ikke blevet godkendt.<br><br>G� til %2 for at �bne godkendelsesvinduet.<br><br>Derefter skal du %3 for at f� vist data.;ENU=%1 has not been authenticated.<br><br>Go to %2 to open the authentication window.<br><br>Afterwards %3 to show data.';
      ExpectedValueErr@1004 : TextConst 'DAN=Den forventede v�rdi skal v�re et heltal eller en URL-sti, der indeholder %2 i %1.;ENU=Expected value should be an integer or url path containing %2 in %1.';
      RefreshTxt@1003 : TextConst 'DAN=opdater;ENU=refresh';

    [External]
    PROCEDURE GetSignupURL@17() : Text[250];
    BEGIN
      EXIT('http://go.microsoft.com/fwlink/p/?LinkId=401462');
    END;

    [External]
    PROCEDURE GetTermsOfUseURL@1() : Text[250];
    BEGIN
      EXIT('http://go.microsoft.com/fwlink/?LinkID=389042');
    END;

    [External]
    PROCEDURE GetMSL_URL@5() : Text[250];
    VAR
      SocialListeningSetup@1000 : Record 870;
    BEGIN
      WITH SocialListeningSetup DO BEGIN
        IF GET AND ("Social Listening URL" <> '') THEN
          EXIT(COPYSTR("Social Listening URL",1,STRPOS("Social Listening URL",'/app/') - 1));
        TESTFIELD("Social Listening URL");
      END;
    END;

    [External]
    PROCEDURE GetMSLAppURL@15() : Text[250];
    BEGIN
      EXIT(STRSUBSTNO('%1/app/%2/',GetMSL_URL,GetMSLSubscriptionID));
    END;

    [External]
    PROCEDURE MSLUsersURL@16() : Text;
    BEGIN
      EXIT(STRSUBSTNO('%1/settings/%2/?locale=%3#page:users',GetMSL_URL,GetMSLSubscriptionID,GetLanguage));
    END;

    [External]
    PROCEDURE MSLSearchItemsURL@2() : Text;
    BEGIN
      EXIT(STRSUBSTNO('%1/app/%2/?locale=%3#search:topics',GetMSL_URL,GetMSLSubscriptionID,GetLanguage));
    END;

    LOCAL PROCEDURE MSLAuthenticationURL@3() : Text;
    BEGIN
      EXIT(STRSUBSTNO('%1/widgetapi/%2/authenticate.htm?lang=%3',GetMSL_URL,GetMSLSubscriptionID,GetLanguage));
    END;

    [External]
    PROCEDURE MSLAuthenticationStatusURL@4() : Text;
    BEGIN
      EXIT(STRSUBSTNO('%1/widgetapi/%2/auth_status.htm?lang=%3',GetMSL_URL,GetMSLSubscriptionID,GetLanguage));
    END;

    [External]
    PROCEDURE GetAuthenticationWidget@12(SearchTopic@1000 : Text) : Text;
    BEGIN
      EXIT(
        STRSUBSTNO(
          '%1/widgetapi/%2/?locale=%3#analytics:overview?date=today&nodeId=%4',
          GetMSL_URL,GetMSLSubscriptionID,GetLanguage,SearchTopic));
    END;

    LOCAL PROCEDURE GetAuthenticationLink@6() : Text;
    BEGIN
      EXIT(
        STRSUBSTNO(
          '<a style="text-decoration: none" href="javascript:;" onclick="openAuthenticationWindow(''%1'');">%2</a>',
          MSLAuthenticationURL,MslProductNameTxt));
    END;

    LOCAL PROCEDURE GetRefreshLink@8() : Text;
    BEGIN
      EXIT(STRSUBSTNO('<a style="text-decoration: none" href="javascript:;" onclick="raiseMessageLinkClick(1);">%1</a>',RefreshTxt));
    END;

    LOCAL PROCEDURE GetMSLSubscriptionID@18() : Text[250];
    VAR
      SocialListeningSetup@1000 : Record 870;
    BEGIN
      SocialListeningSetup.GET;
      SocialListeningSetup.TESTFIELD("Solution ID");
      EXIT(SocialListeningSetup."Solution ID");
    END;

    LOCAL PROCEDURE GetLanguage@30() : Text;
    VAR
      CultureInfo@1000 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Globalization.CultureInfo";
    BEGIN
      CultureInfo := CultureInfo.CultureInfo(GLOBALLANGUAGE);
      EXIT(CultureInfo.TwoLetterISOLanguageName);
    END;

    [External]
    PROCEDURE GetAuthenticationConectionErrorMsg@10() : Text;
    BEGIN
      EXIT(STRSUBSTNO(FailedToConnectTxt,MslProductNameTxt,GetRefreshLink,PRODUCTNAME.FULL));
    END;

    [External]
    PROCEDURE GetAuthenticationUserErrorMsg@11() : Text;
    BEGIN
      EXIT(STRSUBSTNO(HasNotBeenAuthenticatedTxt,MslProductNameTxt,GetAuthenticationLink,GetRefreshLink));
    END;

    [External]
    PROCEDURE GetCustFactboxVisibility@7(Cust@1000 : Record 18;VAR MSLSetupVisibilty@1001 : Boolean;VAR MSLVisibility@1002 : Boolean);
    VAR
      SocialListeningSetup@1005 : Record 870;
      SocialListeningSearchTopic@1004 : Record 871;
    BEGIN
      WITH SocialListeningSetup DO
        MSLSetupVisibilty := GET AND "Show on Customers" AND "Accept License Agreement" AND ("Solution ID" <> '');

      WITH SocialListeningSearchTopic DO
        MSLVisibility := FindSearchTopic("Source Type"::Customer,Cust."No.") AND ("Search Topic" <> '') AND MSLSetupVisibilty;
    END;

    [External]
    PROCEDURE GetVendFactboxVisibility@9(Vend@1000 : Record 23;VAR MSLSetupVisibilty@1001 : Boolean;VAR MSLVisibility@1002 : Boolean);
    VAR
      SocialListeningSetup@1005 : Record 870;
      SocialListeningSearchTopic@1004 : Record 871;
    BEGIN
      WITH SocialListeningSetup DO
        MSLSetupVisibilty := GET AND "Show on Vendors" AND "Accept License Agreement" AND ("Solution ID" <> '');

      WITH SocialListeningSearchTopic DO
        MSLVisibility := FindSearchTopic("Source Type"::Vendor,Vend."No.") AND ("Search Topic" <> '') AND MSLSetupVisibilty;
    END;

    [External]
    PROCEDURE GetItemFactboxVisibility@14(Item@1000 : Record 27;VAR MSLSetupVisibilty@1001 : Boolean;VAR MSLVisibility@1002 : Boolean);
    VAR
      SocialListeningSetup@1005 : Record 870;
      SocialListeningSearchTopic@1004 : Record 871;
    BEGIN
      IF NOT SocialListeningSetup.GET THEN
        MSLSetupVisibilty := FALSE
      ELSE
        MSLSetupVisibilty := SocialListeningSetup."Show on Items" AND
          SocialListeningSetup."Accept License Agreement" AND (SocialListeningSetup."Solution ID" <> '');

      IF NOT SocialListeningSearchTopic.FindSearchTopic(SocialListeningSearchTopic."Source Type"::Item,Item."No.") THEN
        MSLVisibility := FALSE
      ELSE
        MSLVisibility := (SocialListeningSearchTopic."Search Topic" <> '') AND MSLSetupVisibilty;
    END;

    [External]
    PROCEDURE ConvertURLToID@13(URL@1000 : Text;where@1006 : Text) : Text[250];
    VAR
      i@1001 : Integer;
      j@1003 : Integer;
      PositionOfID@1004 : Integer;
      ID@1002 : Text;
      IntegerValue@1005 : Integer;
    BEGIN
      IF URL = '' THEN
        EXIT(URL);
      IF EVALUATE(IntegerValue,URL) THEN
        EXIT(URL);

      PositionOfID := STRPOS(LOWERCASE(URL),LOWERCASE(where));
      IF PositionOfID = 0 THEN
        ERROR(ExpectedValueErr,where,URL);

      j := 1;
      FOR i := PositionOfID + STRLEN(where) TO STRLEN(URL) DO BEGIN
        IF NOT (URL[i] IN ['0'..'9']) THEN
          BREAK;

        ID[j] := URL[i];
        j += 1;
      END;

      IF ID = '' THEN
        ERROR(ExpectedValueErr,where,LOWERCASE(GetMSL_URL));
      EXIT(ID);
    END;

    [EventSubscriber(Table,1400,OnRegisterServiceConnection)]
    [External]
    PROCEDURE HandleMSERegisterServiceConnection@19(VAR ServiceConnection@1003 : Record 1400);
    VAR
      SocialListeningSetup@1001 : Record 870;
      PermissionManager@1000 : Codeunit 9002;
      RecRef@1002 : RecordRef;
    BEGIN
      IF PermissionManager.SoftwareAsAService THEN
        EXIT;

      SocialListeningSetup.GET;
      RecRef.GETTABLE(SocialListeningSetup);

      WITH SocialListeningSetup DO BEGIN
        ServiceConnection.Status := ServiceConnection.Status::Enabled;
        IF NOT "Show on Items" AND NOT "Show on Customers" AND NOT "Show on Vendors" THEN
          ServiceConnection.Status := ServiceConnection.Status::Disabled;
        ServiceConnection.InsertServiceConnection(
          ServiceConnection,RecRef.RECORDID,TABLECAPTION,"Social Listening URL",PAGE::"Social Listening Setup");
      END;
    END;

    [External]
    PROCEDURE CheckURLPath@20(URL@1000 : Text;where@1001 : Text);
    VAR
      IntegerValue@1002 : Integer;
    BEGIN
      IF URL = '' THEN
        EXIT;
      IF EVALUATE(IntegerValue,URL) THEN
        EXIT;

      IF STRPOS(LOWERCASE(URL),LOWERCASE(GetMSL_URL)) = 0 THEN
        ERROR(ExpectedValueErr,where,LOWERCASE(GetMSL_URL));
    END;

    BEGIN
    END.
  }
}

