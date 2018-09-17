OBJECT Codeunit 1 ApplicationManagement
{
  OBJECT-PROPERTIES
  {
    Date=06-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21441;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      DebuggerManagement@1017 : Codeunit 9500;
      LogInManagement@1027 : Codeunit 40;
      TextManagement@1003 : Codeunit 41;
      CaptionManagement@1000 : Codeunit 42;
      LanguageManagement@1002 : Codeunit 43;
      AutoFormatManagement@1012 : Codeunit 45;
      NotSupportedErr@1004 : TextConst 'DAN=V�rdien underst�ttes ikke.;ENU=The value is not supported.';

    [Internal]
    PROCEDURE CompanyOpen@30();
    VAR
      LogonManagement@1000 : Codeunit 9802;
    BEGIN
      LogonManagement.SetLogonInProgress(TRUE);

      // This needs to be the very first thing to run before company open
      CODEUNIT.RUN(CODEUNIT::"Azure AD User Management");

      OnBeforeCompanyOpen;
      LogInManagement.CompanyOpen;
      OnAfterCompanyOpen;
      LogonManagement.SetLogonInProgress(FALSE);
    END;

    [External]
    PROCEDURE GetSystemIndicator@51(VAR Text@1000 : Text[250];VAR Style@1001 : 'Standard,Accent1,Accent2,Accent3,Accent4,Accent5,Accent6,Accent7,Accent8,Accent9');
    VAR
      CompanyInformation@1002 : Record 79;
    BEGIN
      IF CompanyInformation.GET THEN
        CompanyInformation.GetSystemIndicator(Text,Style);
      OnAfterGetSystemIndicator(Text,Style);
    END;

    [External]
    PROCEDURE CompanyClose@31();
    BEGIN
      OnBeforeCompanyClose;
      LogInManagement.CompanyClose;
      OnAfterCompanyClose;
    END;

    [External]
    PROCEDURE FindPrinter@11(ReportID@1000 : Integer) : Text[250];
    VAR
      PrinterSelection@1001 : Record 78;
      PrinterName@1002 : Text[250];
    BEGIN
      CLEAR(PrinterSelection);

      IF PrinterSelection.READPERMISSION THEN
        IF NOT PrinterSelection.GET(USERID,ReportID) THEN
          IF NOT PrinterSelection.GET('',ReportID) THEN
            IF NOT PrinterSelection.GET(USERID,0) THEN
              IF PrinterSelection.GET('',0) THEN;
      PrinterName := PrinterSelection."Printer Name";
      OnAfterFindPrinter(ReportID,PrinterName);
      EXIT(PrinterName);
    END;

    [External]
    PROCEDURE ApplicationVersion@2() : Text[248];
    VAR
      AppVersion@1000 : Text[248];
    BEGIN
      AppVersion := CustomApplicationVersion('DK Dynamics NAV 11.0');
      OnAfterGetApplicationVersion(AppVersion);
      EXIT(AppVersion);
    END;

    LOCAL PROCEDURE CustomApplicationVersion@1051(BaseBuildVersion@1000 : Text[80]) : Text[80];
    BEGIN
      EXIT(BaseBuildVersion);
    END;

    [External]
    PROCEDURE ApplicationBuild@3() : Text[80];
    BEGIN
      // Must ever only be the build number of the server building the app.
      EXIT(CustomApplicationBuild('21441'));
    END;

    LOCAL PROCEDURE CustomApplicationBuild@1050(BaseBuildNumber@1000 : Text[80]) : Text[80];
    BEGIN
      EXIT(BaseBuildNumber);
    END;

    [External]
    PROCEDURE ApplicationLanguage@4() : Integer;
    BEGIN
      EXIT(1033);
    END;

    [Internal]
    PROCEDURE DefaultRoleCenter@50() : Integer;
    VAR
      ConfPersMgt@1000 : Codeunit 9170;
      AzureADUserManagement@1002 : Codeunit 9010;
      PermissionManager@1003 : Codeunit 9002;
      DefaultRoleCenterID@1001 : Integer;
    BEGIN
      IF PermissionManager.SoftwareAsAService THEN
        IF AzureADUserManagement.TryGetAzureUserPlanRoleCenterId(DefaultRoleCenterID,USERSECURITYID) THEN;

      IF DefaultRoleCenterID = 0 THEN
        DefaultRoleCenterID := ConfPersMgt.DefaultRoleCenterID;

      OnAfterGetDefaultRoleCenter(DefaultRoleCenterID);
      EXIT(DefaultRoleCenterID);
    END;

    [External]
    PROCEDURE MakeDateTimeText@114(VAR DateTimeText@1000 : Text[250]) : Integer;
    BEGIN
      EXIT(TextManagement.MakeDateTimeText(DateTimeText));
    END;

    [External]
    PROCEDURE GetSeparateDateTime@10011(DateTimeText@1000 : Text[250];VAR Date@1005 : Date;VAR Time@1006 : Time) : Boolean;
    BEGIN
      EXIT(TextManagement.GetSeparateDateTime(DateTimeText,Date,Time));
    END;

    [External]
    PROCEDURE MakeDateText@105(VAR DateText@1000 : Text[250]) : Integer;
    VAR
      Position@1001 : Integer;
    BEGIN
      Position := TextManagement.MakeDateText(DateText);
      OnAfterMakeDateText(Position,DateText);
      EXIT(Position);
    END;

    [External]
    PROCEDURE MakeTimeText@106(VAR TimeText@1000 : Text[250]) : Integer;
    VAR
      Position@1001 : Integer;
    BEGIN
      Position := TextManagement.MakeTimeText(TimeText);
      OnAfterMakeTimeText(Position,TimeText);
      EXIT(Position);
    END;

    [External]
    PROCEDURE MakeText@107(VAR Text@1000 : Text[250]) : Integer;
    VAR
      Position@1001 : Integer;
    BEGIN
      Position := TextManagement.MakeText(Text);
      OnAfterMakeText(Position,Text);
      EXIT(Position);
    END;

    [External]
    PROCEDURE MakeDateTimeFilter@214(VAR DateTimeFilterText@1000 : Text[250]) : Integer;
    VAR
      Position@1001 : Integer;
    BEGIN
      Position := TextManagement.MakeDateTimeFilter(DateTimeFilterText);
      OnAfterMakeDateTimeFilter(Position,DateTimeFilterText);
      EXIT(Position);
    END;

    [External]
    PROCEDURE MakeDateFilter@205(VAR DateFilterText@1000 : Text) : Integer;
    VAR
      Position@1001 : Integer;
    BEGIN
      Position := TextManagement.MakeDateFilter(DateFilterText);
      OnAfterMakeDateFilter(Position,DateFilterText);
      EXIT(Position);
    END;

    [Internal]
    PROCEDURE MakeTextFilter@207(VAR TextFilterText@1000 : Text) : Integer;
    VAR
      Position@1001 : Integer;
    BEGIN
      Position := TextManagement.MakeTextFilter(TextFilterText);
      OnAfterMakeTextFilter(Position,TextFilterText);
      EXIT(Position);
    END;

    [Internal]
    PROCEDURE MakeCodeFilter@209(VAR TextFilterText@1000 : Text) : Integer;
    VAR
      Position@1001 : Integer;
    BEGIN
      Position := TextManagement.MakeTextFilter(TextFilterText);
      OnAfterMakeCodeFilter(Position,TextFilterText);
      EXIT(Position);
    END;

    [External]
    PROCEDURE MakeTimeFilter@206(VAR TimeFilterText@1000 : Text[250]) : Integer;
    VAR
      Position@1001 : Integer;
    BEGIN
      Position := TextManagement.MakeTimeFilter(TimeFilterText);
      OnAfterMakeTimeFilter(Position,TimeFilterText);
      EXIT(Position);
    END;

    [External]
    PROCEDURE AutoFormatTranslate@12(AutoFormatType@1000 : Integer;AutoFormatExpr@1001 : Text[80]) : Text[80];
    VAR
      AutoFormatTranslation@1002 : Text[80];
    BEGIN
      AutoFormatTranslation := AutoFormatManagement.AutoFormatTranslate(AutoFormatType,AutoFormatExpr);
      OnAfterAutoFormatTranslate(AutoFormatType,AutoFormatExpr,AutoFormatTranslation);
      EXIT(AutoFormatTranslation);
    END;

    [External]
    PROCEDURE ReadRounding@14() : Decimal;
    BEGIN
      EXIT(AutoFormatManagement.ReadRounding);
    END;

    [External]
    PROCEDURE CaptionClassTranslate@15(Language@1000 : Integer;CaptionExpr@1001 : Text[1024]) : Text[1024];
    VAR
      Caption@1002 : Text[1024];
    BEGIN
      Caption := CaptionManagement.CaptionClassTranslate(Language,CaptionExpr);
      OnAfterCaptionClassTranslate(Language,CaptionExpr,Caption);
      EXIT(Caption);
    END;

    [External]
    PROCEDURE GetCueStyle@16(TableId@1000 : Integer;FieldNo@1002 : Integer;CueValue@1001 : Decimal) : Text;
    VAR
      CueSetup@1003 : Codeunit 9701;
    BEGIN
      EXIT(CueSetup.GetCustomizedCueStyle(TableId,FieldNo,CueValue));
    END;

    [Internal]
    PROCEDURE SetGlobalLanguage@5();
    BEGIN
      LanguageManagement.SetGlobalLanguage;
    END;

    [Internal]
    PROCEDURE ValidateApplicationlLanguage@1102601001(LanguageID@1037 : Integer);
    BEGIN
      LanguageManagement.ValidateApplicationLanguage(LanguageID);
    END;

    [Internal]
    PROCEDURE LookupApplicationlLanguage@1102601005(VAR LanguageID@1040 : Integer);
    BEGIN
      LanguageManagement.LookupApplicationLanguage(LanguageID);
    END;

    [External]
    PROCEDURE GetGlobalTableTriggerMask@20(TableID@1000 : Integer) : Integer;
    VAR
      TableTriggerMask@1001 : Integer;
    BEGIN
      // Replaced by GetDatabaseTableTriggerSetup
      OnAfterGetGlobalTableTriggerMask(TableID,TableTriggerMask);
      EXIT(TableTriggerMask);
    END;

    [External]
    PROCEDURE OnGlobalInsert@21(RecRef@1000 : RecordRef);
    BEGIN
      // Replaced by OnDataBaseInsert. This trigger is only called from pages.
      OnAfterOnGlobalInsert(RecRef);
    END;

    [External]
    PROCEDURE OnGlobalModify@22(RecRef@1000 : RecordRef;xRecRef@1002 : RecordRef);
    BEGIN
      // Replaced by OnDataBaseModify. This trigger is only called from pages.
      OnAfterOnGlobalModify(RecRef,xRecRef);
    END;

    [External]
    PROCEDURE OnGlobalDelete@23(RecRef@1000 : RecordRef);
    BEGIN
      // Replaced by OnDataBaseDelete. This trigger is only called from pages.
      OnAfterOnGlobalDelete(RecRef);
    END;

    [External]
    PROCEDURE OnGlobalRename@24(RecRef@1000 : RecordRef;xRecRef@1002 : RecordRef);
    BEGIN
      // Replaced by OnDataBaseRename. This trigger is only called from pages.
      OnAfterOnGlobalRename(RecRef,xRecRef);
    END;

    [Internal]
    PROCEDURE GetDatabaseTableTriggerSetup@25(TableId@1000 : Integer;VAR OnDatabaseInsert@1001 : Boolean;VAR OnDatabaseModify@1002 : Boolean;VAR OnDatabaseDelete@1003 : Boolean;VAR OnDatabaseRename@1004 : Boolean);
    VAR
      IntegrationManagement@1005 : Codeunit 5150;
      ChangeLogMgt@1006 : Codeunit 423;
    BEGIN
      ChangeLogMgt.GetDatabaseTableTriggerSetup(TableId,OnDatabaseInsert,OnDatabaseModify,OnDatabaseDelete,OnDatabaseRename);
      IntegrationManagement.GetDatabaseTableTriggerSetup(TableId,OnDatabaseInsert,OnDatabaseModify,OnDatabaseDelete,OnDatabaseRename);
      OnAfterGetDatabaseTableTriggerSetup(TableId,OnDatabaseInsert,OnDatabaseModify,OnDatabaseDelete,OnDatabaseRename);
    END;

    [Internal]
    PROCEDURE OnDatabaseInsert@26(RecRef@1000 : RecordRef);
    VAR
      IntegrationManagement@1001 : Codeunit 5150;
      ChangeLogMgt@1002 : Codeunit 423;
    BEGIN
      OnBeforeOnDatabaseInsert(RecRef);
      ChangeLogMgt.LogInsertion(RecRef);
      IntegrationManagement.OnDatabaseInsert(RecRef);
      OnAfterOnDatabaseInsert(RecRef);
    END;

    [Internal]
    PROCEDURE OnDatabaseModify@27(RecRef@1000 : RecordRef);
    VAR
      IntegrationManagement@1001 : Codeunit 5150;
      ChangeLogMgt@1002 : Codeunit 423;
    BEGIN
      OnBeforeOnDatabaseModify(RecRef);
      ChangeLogMgt.LogModification(RecRef);
      IntegrationManagement.OnDatabaseModify(RecRef);
      OnAfterOnDatabaseModify(RecRef);
    END;

    [Internal]
    PROCEDURE OnDatabaseDelete@28(RecRef@1000 : RecordRef);
    VAR
      IntegrationManagement@1001 : Codeunit 5150;
      ChangeLogMgt@1002 : Codeunit 423;
    BEGIN
      OnBeforeOnDatabaseDelete(RecRef);
      ChangeLogMgt.LogDeletion(RecRef);
      IntegrationManagement.OnDatabaseDelete(RecRef);
      OnAfterOnDatabaseDelete(RecRef);
    END;

    [Internal]
    PROCEDURE OnDatabaseRename@29(RecRef@1000 : RecordRef;xRecRef@1001 : RecordRef);
    VAR
      IntegrationManagement@1002 : Codeunit 5150;
      ChangeLogMgt@1003 : Codeunit 423;
    BEGIN
      OnBeforeOnDatabaseRename(RecRef,xRecRef);
      ChangeLogMgt.LogRename(RecRef,xRecRef);
      IntegrationManagement.OnDatabaseRename(RecRef,xRecRef);
      OnAfterOnDatabaseRename(RecRef,xRecRef);
    END;

    [Internal]
    PROCEDURE OnDebuggerBreak@55(ErrorMessage@1000 : Text);
    BEGIN
      DebuggerManagement.ProcessDebuggerBreak(ErrorMessage);
    END;

    [External]
    PROCEDURE LaunchDebugger@60();
    BEGIN
      PAGE.RUN(PAGE::"Session List");
    END;

    [External]
    PROCEDURE OpenSettings@65();
    BEGIN
      PAGE.RUN(PAGE::"My Settings");
    END;

    [External]
    PROCEDURE OpenContactMSSales@6();
    BEGIN
      PAGE.RUN(PAGE::"Contact MS Sales");
    END;

    [External]
    PROCEDURE InvokeExtensionInstallation@8(AppId@1000 : Text;ResponseUrl@1002 : Text);
    VAR
      ExtensionMarketplaceMgmt@1001 : Codeunit 2501;
    BEGIN
      IF NOT ExtensionMarketplaceMgmt.InstallExtension(AppId,ResponseUrl) THEN
        MESSAGE(GETLASTERRORTEXT);
    END;

    [Internal]
    PROCEDURE CustomizeChart@70(VAR TempChart@1000 : TEMPORARY Record 2000000078) : Boolean;
    VAR
      GenericChartMgt@1001 : Codeunit 9180;
    BEGIN
      EXIT(GenericChartMgt.ChartCustomization(TempChart));
    END;

    [External]
    PROCEDURE HasCustomLayout@76(ObjectType@1004 : 'Report,Page';ObjectID@1000 : Integer) : Integer;
    VAR
      ReportLayoutSelection@1003 : Record 9651;
    BEGIN
      // Return value:
      // 0: No custom layout
      // 1: RDLC layout
      // 2: Word layout
      IF ObjectType <> ObjectType::Report THEN
        ERROR(NotSupportedErr);

      EXIT(ReportLayoutSelection.HasCustomLayout(ObjectID));
    END;

    [Internal]
    PROCEDURE MergeDocument@77(ObjectType@1006 : 'Report,Page';ObjectID@1000 : Integer;ReportAction@1001 : 'SaveAsPdf,SaveAsWord,SaveAsExcel,Preview,Print,SaveAsHtml';XmlData@1002 : InStream;FileName@1003 : Text);
    VAR
      DocumentReportMgt@1004 : Codeunit 9651;
    BEGIN
      IF ObjectType <> ObjectType::Report THEN
        ERROR(NotSupportedErr);

      DocumentReportMgt.MergeWordLayout(ObjectID,ReportAction,XmlData,FileName);
    END;

    [Internal]
    PROCEDURE ReportGetCustomRdlc@78(ReportId@1000 : Integer) : Text;
    VAR
      CustomReportLayout@1002 : Record 9650;
    BEGIN
      EXIT(CustomReportLayout.GetCustomRdlc(ReportId));
    END;

    [External]
    PROCEDURE ReportScheduler@79(ReportId@1000 : Integer;RequestPageXml@1001 : Text) : Boolean;
    VAR
      ScheduleAReport@1002 : Page 682;
    BEGIN
      EXIT(ScheduleAReport.ScheduleAReport(ReportId,RequestPageXml));
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnAfterGetApplicationVersion@1(VAR AppVersion@1000 : Text[248]);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnBeforeCompanyOpen@1010();
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnAfterCompanyOpen@1007();
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnBeforeCompanyClose@1017();
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnAfterCompanyClose@1013();
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnAfterGetSystemIndicator@1018(VAR Text@1000 : Text[250];VAR Style@1001 : 'Standard,Accent1,Accent2,Accent3,Accent4,Accent5,Accent6,Accent7,Accent8,Accent9');
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnAfterFindPrinter@1023(ReportID@1000 : Integer;VAR PrinterName@1001 : Text[250]);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnAfterGetDefaultRoleCenter@1033(VAR DefaultRoleCenterID@1000 : Integer);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnAfterMakeDateText@1036(VAR Position@1000 : Integer;VAR DateText@1001 : Text[250]);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnAfterMakeTimeText@1039(VAR Position@1001 : Integer;VAR TimeText@1000 : Text[250]);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnAfterMakeText@1040(VAR Position@1001 : Integer;VAR Text@1000 : Text[250]);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnAfterMakeDateTimeFilter@1045(VAR Position@1001 : Integer;VAR DateTimeFilterText@1000 : Text[250]);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnAfterMakeDateFilter@1046(VAR Position@1001 : Integer;VAR DateFilterText@1000 : Text);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnAfterMakeTextFilter@1047(VAR Position@1001 : Integer;VAR TextFilterText@1000 : Text);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnAfterMakeCodeFilter@1052(VAR Position@1001 : Integer;VAR TextFilterText@1000 : Text);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnAfterMakeTimeFilter@1053(VAR Position@1001 : Integer;VAR TimeFilterText@1000 : Text[250]);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnAfterAutoFormatTranslate@1056(AutoFormatType@1001 : Integer;AutoFormatExpression@1000 : Text[80];VAR AutoFormatTranslation@1002 : Text[80]);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnAfterCaptionClassTranslate@1061(Language@1001 : Integer;CaptionExpression@1000 : Text[1024];VAR Caption@1002 : Text[1024]);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnAfterGetGlobalTableTriggerMask@1001(TableID@1000 : Integer;VAR TableTriggerMask@1002 : Integer);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnAfterOnGlobalInsert@1002(RecRef@1000 : RecordRef);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnAfterOnGlobalModify@1003(RecRef@1000 : RecordRef;xRecRef@1002 : RecordRef);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnAfterOnGlobalDelete@1004(RecRef@1000 : RecordRef);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnAfterOnGlobalRename@1005(RecRef@1000 : RecordRef;xRecRef@1002 : RecordRef);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnAfterGetDatabaseTableTriggerSetup@1020(TableId@1000 : Integer;VAR OnDatabaseInsert@1001 : Boolean;VAR OnDatabaseModify@1002 : Boolean;VAR OnDatabaseDelete@1003 : Boolean;VAR OnDatabaseRename@1004 : Boolean);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnAfterOnDatabaseInsert@1035(RecRef@1000 : RecordRef);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnAfterOnDatabaseModify@1034(RecRef@1000 : RecordRef);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnAfterOnDatabaseDelete@1032(RecRef@1000 : RecordRef);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnAfterOnDatabaseRename@1024(RecRef@1000 : RecordRef;xRecRef@1001 : RecordRef);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnBeforeOnDatabaseInsert@1037(RecRef@1000 : RecordRef);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnBeforeOnDatabaseModify@1038(RecRef@1000 : RecordRef);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnBeforeOnDatabaseDelete@1041(RecRef@1000 : RecordRef);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnBeforeOnDatabaseRename@1042(RecRef@1000 : RecordRef;xRecRef@1001 : RecordRef);
    BEGIN
    END;

    [Integration]
    [External]
    PROCEDURE OnEditInExcel@82(ServiceName@1000 : Text[240];ODataFilter@1001 : Text);
    BEGIN
    END;

    [Integration]
    [External]
    PROCEDURE OnInstallAppPerDatabase@83();
    BEGIN
    END;

    [Integration]
    [External]
    PROCEDURE OnInstallAppPerCompany@84();
    BEGIN
    END;

    [Integration]
    [External]
    PROCEDURE OnCheckPreconditionsPerDatabase@87();
    BEGIN
    END;

    [Integration]
    [External]
    PROCEDURE OnCheckPreconditionsPerCompany@88();
    BEGIN
    END;

    [Integration]
    [External]
    PROCEDURE OnUpgradePerDatabase@89();
    BEGIN
    END;

    [Integration]
    [External]
    PROCEDURE OnUpgradePerCompany@90();
    BEGIN
    END;

    [Integration]
    [External]
    PROCEDURE OnValidateUpgradePerDatabase@91();
    BEGIN
    END;

    [Integration]
    [External]
    PROCEDURE OnValidateUpgradePerCompany@92();
    BEGIN
    END;

    BEGIN
    END.
  }
}

