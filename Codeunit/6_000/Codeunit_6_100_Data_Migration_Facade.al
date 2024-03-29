OBJECT Codeunit 6100 Data Migration Facade
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

    [External]
    PROCEDURE StartMigration@4(MigrationType@1000 : Text[250];Retry@1001 : Boolean);
    VAR
      DataMigrationMgt@1002 : Codeunit 1798;
    BEGIN
      DataMigrationMgt.StartMigration(MigrationType,Retry);
    END;

    [EventSubscriber(Table,1800,OnRegisterDataMigrator)]
    LOCAL PROCEDURE OnRegisterDataMigratorWizardSubscriber@6(VAR Sender@1000 : Record 1800);
    BEGIN
      OnRegisterDataMigrator(Sender);
    END;

    [Integration(TRUE)]
    [External]
    PROCEDURE OnRegisterDataMigrator@1(VAR DataMigratorRegistration@1001 : Record 1800);
    BEGIN
      // Event which makes all data migrators register themselves in this table.
    END;

    [EventSubscriber(Table,1800,OnGetInstructions)]
    LOCAL PROCEDURE OnRegisterGetInstructionsWizardSubscriber@9(VAR Sender@1000 : Record 1800;VAR Instructions@1001 : Text;VAR Handled@1002 : Boolean);
    BEGIN
      OnGetInstructions(Sender,Instructions,Handled);
    END;

    [Integration(TRUE)]
    [External]
    PROCEDURE OnGetInstructions@3(VAR DataMigratorRegistration@1001 : Record 1800;VAR Instructions@1002 : Text;VAR Handled@1000 : Boolean);
    BEGIN
      // Event which makes all registered data migrators publish their instructions.
    END;

    [EventSubscriber(Table,1800,OnDataImport)]
    LOCAL PROCEDURE OnDataImportWizardSubscriber@15(VAR Sender@1000 : Record 1800;VAR Handled@1001 : Boolean);
    BEGIN
      OnDataImport(Sender,Handled);
    END;

    [Integration(TRUE)]
    [External]
    PROCEDURE OnDataImport@12(VAR DataMigratorRegistration@1000 : Record 1800;VAR Handled@1001 : Boolean);
    BEGIN
      // Event which makes all registered data migrators import data.
    END;

    [EventSubscriber(Table,1800,OnSelectDataToApply)]
    LOCAL PROCEDURE OnSelectDataToApplyWizardSubscriber@27(VAR Sender@1000 : Record 1800;VAR DataMigrationEntity@1001 : Record 1801;VAR Handled@1002 : Boolean);
    BEGIN
      OnSelectDataToApply(Sender,DataMigrationEntity,Handled);
    END;

    [Integration(TRUE)]
    [External]
    PROCEDURE OnSelectDataToApply@25(VAR DataMigratorRegistration@1001 : Record 1800;VAR DataMigrationEntity@1002 : Record 1801;VAR Handled@1000 : Boolean);
    BEGIN
      // Event which makes all registered data migrators populate the Data Migration Entities table, which allows the user to choose which imported data should be applied.
    END;

    [EventSubscriber(Table,1800,OnApplySelectedData)]
    LOCAL PROCEDURE OnApplySelectedDataWizardSubscriber@17(VAR Sender@1000 : Record 1800;VAR DataMigrationEntity@1001 : Record 1801;VAR Handled@1002 : Boolean);
    BEGIN
      OnApplySelectedData(Sender,DataMigrationEntity,Handled);
    END;

    [Integration(TRUE)]
    [External]
    PROCEDURE OnApplySelectedData@11(VAR DataMigratorRegistration@1000 : Record 1800;VAR DataMigrationEntity@1002 : Record 1801;VAR Handled@1001 : Boolean);
    BEGIN
      // Event which makes all registered data migrators apply the data, which is selected in the Data Migration Entities table.
    END;

    [EventSubscriber(Table,1800,OnShowThatsItMessage)]
    LOCAL PROCEDURE OnShowThatsItMessageWizardSubscriber@19(VAR Sender@1000 : Record 1800;VAR Message@1001 : Text);
    BEGIN
      OnShowThatsItMessage(Sender,Message);
    END;

    [Integration(TRUE)]
    PROCEDURE OnShowThatsItMessage@22(VAR DataMigratorRegistration@1001 : Record 1800;VAR Message@1000 : Text);
    BEGIN
      // Event which shows specific data migrator text at the last page
    END;

    [EventSubscriber(Table,1800,OnEnableTogglingDataMigrationOverviewPage)]
    LOCAL PROCEDURE OnEnableTogglingDataMigrationOverviewPageWizardSubscriber@20(VAR Sender@1000 : Record 1800;VAR EnableTogglingOverviewPage@1001 : Boolean);
    BEGIN
      OnEnableTogglingDataMigrationOverviewPage(Sender,EnableTogglingOverviewPage);
    END;

    [Integration(TRUE)]
    PROCEDURE OnEnableTogglingDataMigrationOverviewPage@24(VAR DataMigratorRegistration@1001 : Record 1800;VAR EnableTogglingOverviewPage@1000 : Boolean);
    BEGIN
      // Event which determines if the option to launch the overview page will be shown to the user at the end.
    END;

    [Integration]
    [External]
    PROCEDURE OnFillStagingTables@32();
    BEGIN
    END;

    [Integration]
    [External]
    PROCEDURE OnFindBatchForItemTransactions@43(MigrationType@1000 : Text[250];VAR ItemJournalBatchName@1001 : Code[10]);
    BEGIN
    END;

    [Integration]
    [External]
    PROCEDURE OnFindBatchForCustomerTransactions@42(MigrationType@1000 : Text[250];VAR GenJournalBatchName@1001 : Code[10]);
    BEGIN
    END;

    [Integration]
    [External]
    PROCEDURE OnFindBatchForVendorTransactions@41(MigrationType@1000 : Text[250];VAR GenJournalBatchName@1001 : Code[10]);
    BEGIN
    END;

    [Integration]
    [External]
    PROCEDURE OnFindBatchForAccountTransactions@7(DataMigrationStatus@1000 : Record 1799;VAR GenJournalBatchName@1001 : Code[10]);
    BEGIN
    END;

    [Integration]
    [External]
    PROCEDURE OnGetMigrationHelpTopicUrl@2(MigrationType@1001 : Text;VAR Url@1000 : Text);
    BEGIN
    END;

    [Integration]
    [External]
    PROCEDURE OnSelectRowFromDashboard@5(VAR DataMigrationStatus@1000 : Record 1799);
    BEGIN
    END;

    [Integration]
    PROCEDURE OnMigrationCompleted@13(DataMigrationStatus@1000 : Record 1799);
    BEGIN
    END;

    BEGIN
    END.
  }
}

