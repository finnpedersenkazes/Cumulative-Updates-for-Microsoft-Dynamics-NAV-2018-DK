OBJECT Codeunit 1800 Assisted Company Setup
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
          END;

  }
  CODE
  {
    VAR
      EnableWizardErr@1002 : TextConst 'DAN=Du kan ikke aktivere assisteret ops‘tning af virksomhed p† en virksomhed, der allerede er aktiv.;ENU=You cannot enable the assisted company setup for an already active company.';
      NoConfigPackageFileMsg@1000 : TextConst 'DAN=Der er ikke defineret nogen konfigurationspakkefiler i systemet. Den assisterede virksomhedsops‘tning vil ikke v‘re fuldt funktionel. Kontakt systemadministratoren.;ENU=There are no configuration package files defined in your system. Assisted company setup will not be fully functional. Please contact your system administrator.';
      CompanyIsBeingSetUpMsg@1001 : TextConst 'DAN=Virksomheden er ved at blive konfigureret. Vent venligst...;ENU=The Company is being set up. Please wait...';
      StandardTxt@1004 : TextConst '@@@=Must be similar to "Data Type" option in table 101900 Demonstration Data Setup;DAN=Standard;ENU=Standard';
      EvaluationTxt@1003 : TextConst '@@@=Must be similar to "Data Type" option in table 101900 Demonstration Data Setup;DAN=Vurdering;ENU=Evaluation';
      ExtendedTxt@1005 : TextConst '@@@=Must be similar to "Data Type" option in table 101900 Demonstration Data Setup;DAN=Udvidet;ENU=Extended';
      CreatingCompanyMsg@1007 : TextConst 'DAN=Opretter virksomhed...;ENU=Creating company...';
      NoPermissionsErr@1006 : TextConst 'DAN=Du har ikke rettigheder til at oprette en ny virksomhed. Kontakt systemadministratoren.;ENU=You do not have permissions to create a new company. Contact your system administrator.';

    [External]
    PROCEDURE EnableAssistedCompanySetup@5(SetupCompanyName@1000 : Text[30];AssistedSetupEnabled@1002 : Boolean);
    VAR
      GLEntry@1001 : Record 17;
      ConfigurationPackageFile@1003 : Record 2000000170;
    BEGIN
      IF AssistedSetupEnabled THEN BEGIN
        GLEntry.CHANGECOMPANY(SetupCompanyName);
        IF NOT GLEntry.ISEMPTY THEN
          ERROR(EnableWizardErr);
        IF ConfigurationPackageFile.ISEMPTY THEN
          MESSAGE(NoConfigPackageFileMsg);
      END;
      SetAssistedCompanySetupVisibility(SetupCompanyName,AssistedSetupEnabled);
    END;

    LOCAL PROCEDURE RunAssistedCompanySetup@1();
    VAR
      AssistedSetup@1001 : Record 1803;
      IdentityManagement@1000 : Codeunit 9801;
    BEGIN
      IF NOT GUIALLOWED THEN
        EXIT;

      IF IdentityManagement.IsInvAppId THEN
        EXIT; // Invoicing handles company setup silently

      IF NOT AssistedSetup.READPERMISSION THEN
        EXIT;

      IF CompanyActive THEN
        EXIT;

      IF NOT AssistedSetupEnabled THEN
        EXIT;

      IF NOT AssistedSetup.GET(PAGE::"Assisted Company Setup Wizard") THEN
        EXIT;

      IF AssistedSetup.Status = AssistedSetup.Status::Completed THEN
        EXIT;

      COMMIT; // Make sure all data is committed before we run the wizard

      AssistedSetup.Run;
    END;

    [External]
    PROCEDURE ApplyUserInput@2(VAR TempConfigSetup@1000 : TEMPORARY Record 8627;VAR BankAccount@1003 : Record 270;AccountingPeriodStartDate@1002 : Date;SkipSetupCompanyInfo@1001 : Boolean);
    BEGIN
      IF NOT SkipSetupCompanyInfo THEN
        TempConfigSetup.CopyCompInfo;
      CreateAccountingPeriod(AccountingPeriodStartDate);
      SetupCompanyBankAccount(BankAccount);
    END;

    [Internal]
    PROCEDURE GetConfigurationPackageFile@22(ConfigurationPackageFile@1000 : Record 2000000170) ServerTempFileName : Text;
    VAR
      FileManagement@1004 : Codeunit 419;
      TempFile@1003 : File;
      OutStream@1002 : OutStream;
      InStream@1001 : InStream;
    BEGIN
      ServerTempFileName := FileManagement.ServerTempFileName('rapidstart');
      TempFile.CREATE(ServerTempFileName);
      TempFile.CREATEOUTSTREAM(OutStream);
      ConfigurationPackageFile.CALCFIELDS(Package);
      ConfigurationPackageFile.Package.CREATEINSTREAM(InStream);
      COPYSTREAM(OutStream,InStream);
      TempFile.CLOSE;
    END;

    PROCEDURE CreateAccountingPeriod@4(StartDate@1002 : Date);
    VAR
      AccountingPeriod@1003 : Record 50;
      CreateFiscalYear@1000 : Report 93;
      DateFormulaVariable@1001 : DateFormula;
    BEGIN
      // The wizard should only setup accounting periods, if non exist.
      IF NOT AccountingPeriod.ISEMPTY THEN
        EXIT;

      EVALUATE(DateFormulaVariable,'<1M>');
      CreateFiscalYear.InitializeRequest(12,DateFormulaVariable,StartDate);
      CreateFiscalYear.USEREQUESTPAGE(FALSE);
      CreateFiscalYear.HideConfirmationDialog(TRUE);
      CreateFiscalYear.RUNMODAL;
    END;

    LOCAL PROCEDURE SetupCompanyBankAccount@9(VAR BankAccount@1002 : Record 270);
    VAR
      CompanyInformation@1001 : Record 79;
      CompanyInformationMgt@1000 : Codeunit 1306;
    BEGIN
      CompanyInformation.GET;
      CompanyInformationMgt.UpdateCompanyBankAccount(CompanyInformation,'',BankAccount);
    END;

    LOCAL PROCEDURE AssistedSetupEnabled@12() : Boolean;
    VAR
      AssistedCompanySetupStatus@1000 : Record 1802;
    BEGIN
      EXIT(AssistedCompanySetupStatus.GET(COMPANYNAME) AND AssistedCompanySetupStatus.Enabled);
    END;

    LOCAL PROCEDURE CompanyActive@3() : Boolean;
    VAR
      GLEntry@1000 : Record 17;
    BEGIN
      IF NOT GLEntry.READPERMISSION THEN
        EXIT(TRUE);

      EXIT(NOT GLEntry.ISEMPTY);
    END;

    [External]
    PROCEDURE SetAssistedCompanySetupVisibility@6(SetupCompanyName@1002 : Text[30];IsVisible@1000 : Boolean);
    VAR
      AssistedSetup@1001 : Record 1803;
    BEGIN
      AssistedSetup.CHANGECOMPANY(SetupCompanyName);
      IF AssistedSetup.GET(PAGE::"Assisted Company Setup Wizard") THEN BEGIN
        AssistedSetup.Visible := IsVisible;
        AssistedSetup.MODIFY;
      END;
    END;

    LOCAL PROCEDURE FindJobQueueLogEntries@27(Name@1001 : Text[30];VAR JobQueueLogEntry@1000 : Record 474) : Boolean;
    VAR
      AssistedCompanySetupStatus@1002 : Record 1802;
    BEGIN
      IF NOT AssistedCompanySetupStatus.GET(Name) THEN
        EXIT(FALSE);
      JobQueueLogEntry.SETRANGE(ID,AssistedCompanySetupStatus."Task ID");
      EXIT(JobQueueLogEntry.FINDLAST);
    END;

    LOCAL PROCEDURE GetCompanySetupStatus@25(Name@1000 : Text[30]) : Integer;
    VAR
      JobQueueLogEntry@1002 : Record 474;
      SetupStatus@1001 : ' ,Completed,In Progress,Error,Missing Permission';
    BEGIN
      IF NOT JobQueueLogEntry.CHANGECOMPANY(Name) THEN
        EXIT(SetupStatus::"Missing Permission");
      IF FindJobQueueLogEntries(Name,JobQueueLogEntry) THEN
        EXIT(JobQueueLogEntry.Status + 1);
      IF IsCompanySetupInProgress(Name) THEN
        EXIT(SetupStatus::"In Progress");
      EXIT(SetupStatus::" ");
    END;

    [External]
    PROCEDURE IsCompanySetupInProgress@16(NewCompanyName@1002 : Text) : Boolean;
    VAR
      ActiveSession@1001 : Record 2000000110;
      AssistedCompanySetupStatus@1000 : Record 1802;
    BEGIN
      WITH AssistedCompanySetupStatus DO
        IF GET(NewCompanyName) THEN
          IF "Company Setup Session ID" <> 0 THEN
            EXIT(ActiveSession.GET(SERVICEINSTANCEID,"Company Setup Session ID"));
    END;

    [External]
    PROCEDURE WaitForPackageImportToComplete@15();
    VAR
      Window@1002 : Dialog;
    BEGIN
      IF IsCompanySetupInProgress(COMPANYNAME) THEN BEGIN
        Window.OPEN(CompanyIsBeingSetUpMsg);
        WHILE IsCompanySetupInProgress(COMPANYNAME) DO
          SLEEP(1000);
        Window.CLOSE;
      END;
    END;

    PROCEDURE FillCompanyData@28(NewCompanyName@1001 : Text[30];NewCompanyData@1000 : 'Evaluation Data,Standard Data,None,Extended Data,Full No Data');
    VAR
      Company@1002 : Record 2000000006;
      ConfigurationPackageFile@1003 : Record 2000000170;
      DataClassificationEvalData@1005 : Codeunit 1751;
    BEGIN
      IF NewCompanyData = NewCompanyData::"Evaluation Data" THEN BEGIN
        Company.GET(NewCompanyName);
        Company."Evaluation Company" := TRUE;
        Company.MODIFY;
        DataClassificationEvalData.CreateEvaluationData;
      END;
      IF FindConfigurationPackageFile(ConfigurationPackageFile,NewCompanyData) THEN
        ScheduleConfigPackageImport(ConfigurationPackageFile,NewCompanyName);
    END;

    LOCAL PROCEDURE FilterConfigurationPackageFile@24(VAR ConfigurationPackageFile@1000 : Record 2000000170;CompanyData@1001 : 'Evaluation Data,Standard Data,None,Extended Data,Full No Data') : Boolean;
    BEGIN
      CASE CompanyData OF
        CompanyData::"Evaluation Data":
          ConfigurationPackageFile.SETFILTER(Code,'*' + EvaluationTxt + '*');
        CompanyData::"Standard Data":
          ConfigurationPackageFile.SETFILTER(Code,'*' + StandardTxt + '*');
        CompanyData::"Extended Data":
          ConfigurationPackageFile.SETFILTER(Code,'*' + ExtendedTxt + '*');
        ELSE
          EXIT(FALSE);
      END;
      ConfigurationPackageFile.SETRANGE("Setup Type",ConfigurationPackageFile."Setup Type"::Company);
      ConfigurationPackageFile.SETRANGE("Language ID",GLOBALLANGUAGE);
      IF ConfigurationPackageFile.ISEMPTY THEN
        ConfigurationPackageFile.SETRANGE("Language ID");
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE ExistsConfigurationPackageFile@23(CompanyData@1000 : Option) : Boolean;
    VAR
      ConfigurationPackageFile@1001 : Record 2000000170;
    BEGIN
      IF FilterConfigurationPackageFile(ConfigurationPackageFile,CompanyData) THEN
        EXIT(NOT ConfigurationPackageFile.ISEMPTY);
      EXIT(FALSE);
    END;

    [External]
    PROCEDURE FindConfigurationPackageFile@21(VAR ConfigurationPackageFile@1000 : Record 2000000170;CompanyData@1001 : Option) : Boolean;
    BEGIN
      IF FilterConfigurationPackageFile(ConfigurationPackageFile,CompanyData) THEN
        EXIT(ConfigurationPackageFile.FINDFIRST);
      EXIT(FALSE);
    END;

    [External]
    PROCEDURE ScheduleConfigPackageImport@20(ConfigurationPackageFile@1001 : Record 2000000170;Name@1002 : Text);
    VAR
      AssistedCompanySetupStatus@1000 : Record 1802;
      DoNotScheduleTask@1003 : Boolean;
      TaskID@1004 : GUID;
      ImportSessionID@1005 : Integer;
    BEGIN
      WITH AssistedCompanySetupStatus DO BEGIN
        LOCKTABLE;
        GET(Name);
        OnBeforeScheduleTask(DoNotScheduleTask,TaskID);
        IF DoNotScheduleTask THEN
          "Task ID" := TaskID
        ELSE
          IF TASKSCHEDULER.CANCREATETASK THEN
            "Task ID" :=
              TASKSCHEDULER.CREATETASK(
                CODEUNIT::"Import Config. Package File",0,TRUE,"Company Name",CURRENTDATETIME,ConfigurationPackageFile.RECORDID)
          ELSE BEGIN
            COMMIT;
            ImportSessionID := 0;
            STARTSESSION(ImportSessionID,CODEUNIT::"Import Config. Package File","Company Name",ConfigurationPackageFile);
            EXIT;
          END;
        MODIFY;
        COMMIT;
      END;
    END;

    LOCAL PROCEDURE SetApplicationArea@30(NewCompanyName@1003 : Text[30];NewCompanyData@1002 : 'Evaluation Data,Standard Data,None,Extended Data,Full No Data');
    VAR
      ApplicationAreaSetup@1000 : Record 9178;
      ExperienceTier@1001 : ' ,,,,,Basic,,,,,,,,,,Suite,,,,,Custom,,,,,Advanced';
    BEGIN
      ApplicationAreaSetup.SETRANGE("Company Name",NewCompanyName);
      ApplicationAreaSetup.DELETEALL;

      CASE NewCompanyData OF
        NewCompanyData::"Standard Data",NewCompanyData::None:
          ExperienceTier := ExperienceTier::Suite;
        NewCompanyData::"Extended Data",NewCompanyData::"Full No Data":
          ExperienceTier := ExperienceTier::Advanced;
        NewCompanyData::"Evaluation Data":
          ExperienceTier := ExperienceTier::Basic;
      END;

      ApplicationAreaSetup.INIT;
      ApplicationAreaSetup."Company Name" := NewCompanyName;
      ApplicationAreaSetup.SetExperienceTier(ExperienceTier);
      ApplicationAreaSetup.INSERT;
    END;

    PROCEDURE SetUpNewCompany@29(NewCompanyName@1001 : Text[30];NewCompanyData@1000 : 'Evaluation Data,Standard Data,None,Extended Data,Full No Data');
    VAR
      AssistedCompanySetupStatus@1004 : Record 1802;
    BEGIN
      SetApplicationArea(NewCompanyName,NewCompanyData);
      IF NOT (NewCompanyData IN [NewCompanyData::None,NewCompanyData::"Full No Data"]) THEN BEGIN
        AssistedCompanySetupStatus.SetEnabled(NewCompanyName,NewCompanyData = NewCompanyData::"Standard Data",FALSE);
        FillCompanyData(NewCompanyName,NewCompanyData);
      END;
    END;

    PROCEDURE CreateNewCompany@32(NewCompanyName@1003 : Text[30]);
    VAR
      Company@1001 : Record 2000000006;
      GeneralLedgerSetup@1002 : Record 98;
      Window@1000 : Dialog;
    BEGIN
      Window.OPEN(CreatingCompanyMsg);

      Company.INIT;
      Company.Name := NewCompanyName;
      Company.INSERT;

      IF NOT GeneralLedgerSetup.CHANGECOMPANY(NewCompanyName) THEN
        ERROR(NoPermissionsErr);
      IF NOT GeneralLedgerSetup.WRITEPERMISSION THEN
        ERROR(NoPermissionsErr);

      COMMIT;

      Window.CLOSE;
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeScheduleTask@31(VAR DoNotScheduleTask@1000 : Boolean;VAR TaskID@1001 : GUID);
    BEGIN
    END;

    [EventSubscriber(Codeunit,2,OnCompanyInitialize)]
    LOCAL PROCEDURE OnCompanyInitialize@13();
    VAR
      AssistedSetup@1000 : Record 1803;
    BEGIN
      AssistedSetup.Initialize;
    END;

    [EventSubscriber(Table,1802,OnEnabled)]
    LOCAL PROCEDURE OnEnableAssistedCompanySetup@11(SetupCompanyName@1000 : Text[30];AssistedSetupEnabled@1002 : Boolean);
    BEGIN
      EnableAssistedCompanySetup(SetupCompanyName,AssistedSetupEnabled);
    END;

    [EventSubscriber(Codeunit,1,OnAfterCompanyOpen)]
    LOCAL PROCEDURE OnAfterCompanyOpenRunAssistedCompanySetup@7();
    BEGIN
      RunAssistedCompanySetup;
    END;

    [EventSubscriber(Page,9177,OnBeforeActionEvent,"Create New Company")]
    LOCAL PROCEDURE OnBeforeCreateNewCompanyActionOpenCompanyCreationWizard@8(VAR Rec@1000 : Record 2000000006);
    BEGIN
      PAGE.RUNMODAL(PAGE::"Company Creation Wizard");
    END;

    [EventSubscriber(Page,357,OnBeforeActionEvent,"Create New Company")]
    [Internal]
    LOCAL PROCEDURE OnBeforeCreateNewCompanyActionOnCompanyPageOpenCompanyCreationWizard@18(VAR Rec@1000 : Record 2000000006);
    BEGIN
      PAGE.RUNMODAL(PAGE::"Company Creation Wizard");
    END;

    [EventSubscriber(Table,1802,OnAfterValidateEvent,"Package Imported")]
    LOCAL PROCEDURE OnAfterPackageImportedValidate@10(VAR Rec@1000 : Record 1802;VAR xRec@1001 : Record 1802;CurrFieldNo@1002 : Integer);
    BEGIN
      // Send global notification that the new company is ready for use
    END;

    [EventSubscriber(Table,1802,OnAfterValidateEvent,"Import Failed")]
    LOCAL PROCEDURE OnAfterImportFailedValidate@14(VAR Rec@1000 : Record 1802;VAR xRec@1001 : Record 1802;CurrFieldNo@1002 : Integer);
    BEGIN
      // Send global notification that the company set up failed
    END;

    [EventSubscriber(Page,9176,OnCompanyChange)]
    LOCAL PROCEDURE OnCompanyChangeCheckForSetupCompletion@17(NewCompanyName@1000 : Text;VAR IsSetupInProgress@1001 : Boolean);
    BEGIN
      IsSetupInProgress := IsCompanySetupInProgress(NewCompanyName);
    END;

    [EventSubscriber(Table,1802,OnGetCompanySetupStatus)]
    LOCAL PROCEDURE OnGetIsCompanySetupInProgress@19(Name@1000 : Text[30];VAR SetupStatus@1001 : Integer);
    BEGIN
      SetupStatus := GetCompanySetupStatus(Name);
    END;

    [EventSubscriber(Table,1802,OnSetupStatusDrillDown)]
    LOCAL PROCEDURE OnSetupStatusDrillDown@26(Name@1000 : Text[30]);
    VAR
      JobQueueLogEntry@1001 : Record 474;
    BEGIN
      IF NOT JobQueueLogEntry.CHANGECOMPANY(Name) THEN
        EXIT;
      IF FindJobQueueLogEntries(Name,JobQueueLogEntry) THEN
        PAGE.RUNMODAL(PAGE::"Job Queue Log Entries",JobQueueLogEntry);
    END;

    BEGIN
    END.
  }
}

