OBJECT Page 1797 Data Migration Error
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Dataoverf›rselsfejl;
               ENU=Data Migration Errors];
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table1797;
    PageType=List;
    OnOpenPage=VAR
                 Notification@1000 : Notification;
               BEGIN
                 Notification.MESSAGE := SkipEditNotificationMsg;
                 Notification.SEND;
               END;

    OnAfterGetCurrRecord=VAR
                           StagingTableRecId@1001 : RecordID;
                           DummyRecordId@1000 : RecordID;
                         BEGIN
                           StagingTableRecId := "Source Staging Table Record ID";
                           StagingTableRecIdSpecified := StagingTableRecId <> DummyRecordId;
                         END;

    ActionList=ACTIONS
    {
      { 5       ;    ;ActionContainer;
                      ActionContainerType=NewDocumentItems }
      { 6       ;1   ;Action    ;
                      Name=SkipSelection;
                      CaptionML=[DAN=Spring valg over;
                                 ENU=Skip Selections];
                      ToolTipML=[DAN=Udelad de valgte fejl fra overf›rslen.;
                                 ENU=Exclude the selected errors from the migration.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Enabled=StagingTableRecIdSpecified;
                      PromotedIsBig=Yes;
                      Image=Delete;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 DataMigrationError@1001 : Record 1797;
                               BEGIN
                                 CheckAtLeastOneSelected;
                                 IF NOT CONFIRM(SkipSelectionConfirmQst,FALSE) THEN
                                   EXIT;
                                 CurrPage.SETSELECTIONFILTER(DataMigrationError);
                                 DataMigrationError.FINDSET;
                                 REPEAT
                                   DataMigrationError.Ignore;
                                 UNTIL DataMigrationError.NEXT = 0;
                                 CurrPage.UPDATE;
                               END;
                                }
      { 7       ;1   ;Action    ;
                      Name=Edit;
                      CaptionML=[DAN=Rediger record;
                                 ENU=Edit Record];
                      ToolTipML=[DAN=Rediger den record, der for†rsagede fejlen.;
                                 ENU=Edit the record that caused the error.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Enabled=StagingTableRecIdSpecified;
                      PromotedIsBig=Yes;
                      Image=Edit;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 EditRecord;
                               END;
                                }
      { 8       ;1   ;Action    ;
                      Name=Migrate;
                      CaptionML=[DAN=Overf›r;
                                 ENU=Migrate];
                      ToolTipML=[DAN=Overf›r de valgte fejl.;
                                 ENU=Migrate the selected errors.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Enabled=StagingTableRecIdSpecified;
                      PromotedIsBig=Yes;
                      Image=Refresh;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 DataMigrationError@1000 : Record 1797;
                                 DataMigrationFacade@1002 : Codeunit 6100;
                                 DataMigrationOverview@1001 : Page 1799;
                               BEGIN
                                 CheckAtLeastOneSelected;
                                 CurrPage.SETSELECTIONFILTER(DataMigrationError);
                                 DataMigrationError.MODIFYALL("Scheduled For Retry",TRUE,TRUE);

                                 DataMigrationFacade.StartMigration("Migration Type",TRUE);

                                 MESSAGE(MigrationStartedMsg,DataMigrationOverview.CAPTION);
                                 CurrPage.CLOSE;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den fejlmeddelelse, der vedr›rer dataoverf›rslen.;
                           ENU=Specifies the error message that relates to the data migration.];
                ApplicationArea=#All;
                SourceExpr="Error Message";
                OnDrillDown=BEGIN
                              IF StagingTableRecIdSpecified THEN
                                EditRecord;
                            END;
                             }

  }
  CODE
  {
    VAR
      MultipleRecordsSelectedErr@1000 : TextConst 'DAN=Du kan f† vist indholdet i ‚n record ad gangen.;ENU=You can view the content of one record at a time.';
      MigrationStartedMsg@1001 : TextConst '@@@="%1 = Caption for the page Data Migration Overview";DAN=De valgte records er planlagt til dataoverf›rsel. Du kan kontrollere status for overf›rslen ved at g† til siden %1.;ENU=The selected records are scheduled for data migration. To check the status of the migration, go to the %1 page.';
      NoSelectionsMadeErr@1002 : TextConst 'DAN=Der er ikke valgt nogen records.;ENU=No records have been selected.';
      StagingTableRecIdSpecified@1003 : Boolean;
      SkipSelectionConfirmQst@1004 : TextConst 'DAN=De valgte fejl vil blive slettet, og de tilsvarende enheder overf›res ikke. Vil du forts‘tte?;ENU=The selected errors will be deleted and the corresponding entities will not be migrated. Do you want to continue?';
      ExtensionNotInstalledErr@1005 : TextConst 'DAN=Det ser ud til, at nogen har fjernet udvidelse til dataoverf›rsel, du pr›ver at anvende. N†r det sker, fjerner vi alle data, som ikke er blevet overf›rt helt.;ENU=Sorry, but it looks like someone uninstalled the data migration extension you are trying to use. When that happens, we remove all data that was not fully migrated.';
      SkipEditNotificationMsg@1006 : TextConst 'DAN=Spring over fejl, eller rediger objektet for at reparere dem og derefter overf›re igen.;ENU=Skip errors, or edit the entity to fix them, and then migrate again.';

    LOCAL PROCEDURE CheckAtLeastOneSelected@1();
    VAR
      DataMigrationError@1000 : Record 1797;
    BEGIN
      CurrPage.SETSELECTIONFILTER(DataMigrationError);
      IF DataMigrationError.COUNT = 0 THEN
        ERROR(NoSelectionsMadeErr);
    END;

    LOCAL PROCEDURE EditRecord@2();
    VAR
      DataMigrationError@1002 : Record 1797;
      DataMigrationStatus@1001 : Record 1799;
      RecordRef@1000 : RecordRef;
    BEGIN
      CheckAtLeastOneSelected;
      CurrPage.SETSELECTIONFILTER(DataMigrationError);
      IF DataMigrationError.COUNT > 1 THEN
        ERROR(MultipleRecordsSelectedErr);

      DataMigrationError.FINDFIRST;
      DataMigrationStatus.SETRANGE("Migration Type",DataMigrationError."Migration Type");
      DataMigrationStatus.SETRANGE("Destination Table ID",DataMigrationError."Destination Table ID");
      DataMigrationStatus.FINDFIRST;

      IF NOT RecordRef.GET(DataMigrationError."Source Staging Table Record ID") THEN
        ERROR(ExtensionNotInstalledErr);

      OpenStagingTablePage(DataMigrationStatus."Source Staging Table ID",RecordRef);
    END;

    LOCAL PROCEDURE OpenStagingTablePage@5(PageId@1000 : Integer;StagingTableRecord@1001 : Variant);
    BEGIN
      PAGE.RUNMODAL(PageId,StagingTableRecord);
    END;

    BEGIN
    END.
  }
}

