OBJECT Page 1799 Data Migration Overview
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Dataoverf›rselsoversigt;
               ENU=Data Migration Overview];
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table1799;
    PageType=List;
    RefreshOnActivate=Yes;
    OnOpenPage=BEGIN
                 ShowNotifications;
               END;

    OnAfterGetRecord=VAR
                       AllObjWithCaption@1000 : Record 2000000058;
                       DataMigrationMgt@1001 : Codeunit 1798;
                       DummyCode@1002 : Code[10];
                     BEGIN
                       NextTask := NextTask::" ";
                       ErrorStyle := 'Standard';

                       CASE Status OF
                         Status::Completed:
                           BEGIN
                             StatusStyle := 'Favorable'; // bold green
                             IF DataMigrationMgt.DestTableHasAnyTransactions(Rec,DummyCode) THEN
                               NextTask := NextTask::"Review and post";
                           END;
                         Status::"Completed with Errors":
                           BEGIN
                             NextTask := NextTask::"Review and fix errors";
                             StatusStyle := 'Attention';
                           END;
                         Status::Stopped,
                         Status::Failed:
                           BEGIN
                             StatusStyle := 'Attention'; // red
                             IF DataMigrationMgt.DestTableHasAnyTransactions(Rec,DummyCode) THEN
                               NextTask := NextTask::"Review and Delete";
                           END;
                         Status::"In Progress":
                           StatusStyle := 'StandardAccent'; // blue
                         Status::Pending:
                           StatusStyle := 'Standard'; // black
                       END;

                       CALCFIELDS("Error Count");
                       IF "Error Count" = 0 THEN
                         ErrorStyle := 'Subordinate';

                       AllObjWithCaption.SETRANGE("Object Type",AllObjWithCaption."Object Type"::Table);
                       AllObjWithCaption.SETRANGE("Object ID","Destination Table ID");
                       IF AllObjWithCaption.FINDFIRST THEN
                         TableNameToMigrate := AllObjWithCaption."Object Caption";
                     END;

    ActionList=ACTIONS
    {
      { 9       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 14      ;1   ;Action    ;
                      Name=Refresh;
                      CaptionML=[DAN=Opdater;
                                 ENU=Refresh];
                      ToolTipML=;
                      ApplicationArea=#All;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Refresh;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 CurrPage.UPDATE;
                                 ShowNotifications;
                               END;
                                }
      { 10      ;1   ;Action    ;
                      Name=Stop Data Migration;
                      CaptionML=[DAN=Stop alle overf›rsler;
                                 ENU=Stop All Migrations];
                      ToolTipML=[DAN=Stop alle overf›rsler af data, der er i gang eller afventer.;
                                 ENU=Stop all data migrations that are in progress or pending.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Stop;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 DataMigrationStatus@1001 : Record 1799;
                                 DataMigrationMgt@1000 : Codeunit 1798;
                               BEGIN
                                 OnRequestAbort;
                                 DataMigrationStatus.SETFILTER(
                                   Status,'%1|%2',DataMigrationStatus.Status::"In Progress",DataMigrationStatus.Status::Pending);
                                 IF DataMigrationStatus.FINDFIRST THEN
                                   DataMigrationMgt.SetAbortStatus(DataMigrationStatus);
                               END;
                                }
      { 13      ;    ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 11      ;1   ;Action    ;
                      Name=Show Errors;
                      CaptionML=[DAN=Vis fejl;
                                 ENU=Show Errors];
                      ToolTipML=[DAN=Vis de fejl, der opstod under overf›rslen.;
                                 ENU=Show the errors that occurred during migration.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ErrorLog;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 ShowErrors;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;    ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver dataoverf›rselstypen.;
                           ENU=Specifies the type of data migration.];
                ApplicationArea=#All;
                SourceExpr="Migration Type";
                Visible=false }

    { 5   ;2   ;Field     ;
                CaptionML=[DAN=Tabelnavn;
                           ENU=Table Name];
                ToolTipML=[DAN=Angiver navnet p† tabellen;
                           ENU=Specifies the Table Name];
                ApplicationArea=#All;
                SourceExpr=TableNameToMigrate }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af records, der er overflyttet.;
                           ENU=Specifies the number of records that were migrated.];
                ApplicationArea=#All;
                SourceExpr="Migrated Number" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal records, der er overflyttet.;
                           ENU=Specifies the total number of records that were migrated.];
                ApplicationArea=#All;
                SourceExpr="Total Number";
                OnDrillDown=BEGIN
                              DataMigrationFacade.OnSelectRowFromDashboard(Rec);
                            END;
                             }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver dataoverf›rslens fremdriftsstatus.;
                           ENU=Specifies the progress of the data migration.];
                ApplicationArea=#All;
                SourceExpr="Progress Percent" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver dataoverf›rslens status.;
                           ENU=Specifies the status of the data migration.];
                ApplicationArea=#All;
                SourceExpr=Status;
                StyleExpr=StatusStyle }

    { 15  ;2   ;Field     ;
                Name=Next Task;
                CaptionML=[DAN=N‘ste opgave;
                           ENU=Next Task];
                ToolTipML=[DAN=Angiver den n‘ste opgave, der kr‘ves for at fuldf›re overf›rslen.;
                           ENU=Specifies then next task needed to complete the migration.];
                ApplicationArea=#All;
                SourceExpr=NextTask;
                OnDrillDown=BEGIN
                              CASE NextTask OF
                                NextTask::"Review and fix errors":
                                  ShowErrors;
                                NextTask::"Review and post",
                                NextTask::"Review and Delete":
                                  CASE "Destination Table ID" OF
                                    DATABASE::Vendor:
                                      GoToGeneralJournalForVendors;
                                    DATABASE::Customer:
                                      GoToGeneralJournalForCustomers;
                                    DATABASE::Item:
                                      GoToItemJournal;
                                    ELSE
                                      GoToGeneralJournalForAccounts;
                                  END;
                              END;
                            END;
                             }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange records, der ikke kunne overf›res p† grund af en fejl.;
                           ENU=Specifies how many records could not be migrated because of an error.];
                ApplicationArea=#All;
                SourceExpr="Error Count";
                StyleExpr=ErrorStyle;
                OnDrillDown=BEGIN
                              IF "Error Count" = 0 THEN
                                EXIT;
                              ShowErrors;
                            END;
                             }

  }
  CODE
  {
    VAR
      DataMigrationFacade@1015 : Codeunit 6100;
      RefreshNotification@1012 : Notification;
      StatusStyle@1000 : Text INDATASET;
      TableNameToMigrate@1001 : Text[250] INDATASET;
      DashboardEmptyNotificationMsg@1003 : TextConst 'DAN=Denne side viser status for en dataoverf›rsel. Den er tom, fordi du ikke har overf›rt data.;ENU=This page shows the status of a data migration. It''s empty because you have not migrated data.';
      StartDataMigrationMsg@1004 : TextConst 'DAN=Start dataoverf›rsel;ENU=Start data migration';
      RefreshNotificationMsg@1002 : TextConst 'DAN=Dataoverf›rsel er i gang. Opdater siden for at opdatere overflytningsstatus.;ENU=Data migration is in progress. Refresh the page to update the migration status.';
      RefreshNotificationShown@1008 : Boolean;
      LearnMoreTxt@1014 : TextConst 'DAN=F† mere at vide;ENU=Learn more';
      NextTask@1016 : ' ,Review and fix errors,Review and post,Review and Delete';
      ErrorStyle@1005 : Text;

    [Integration]
    LOCAL PROCEDURE OnRequestAbort@1();
    BEGIN
    END;

    LOCAL PROCEDURE ShowErrors@3();
    VAR
      DataMigrationError@1000 : Record 1797;
    BEGIN
      DataMigrationError.SETRANGE("Migration Type","Migration Type");
      DataMigrationError.SETRANGE("Destination Table ID","Destination Table ID");
      PAGE.RUNMODAL(PAGE::"Data Migration Error",DataMigrationError);
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE ShowNotifications@4();
    BEGIN
      IF ShowDashboardEmptyNotification THEN
        EXIT;

      ShowRefreshNotification;
    END;

    LOCAL PROCEDURE ShowDashboardEmptyNotification@5() NotificationShown : Boolean;
    VAR
      DataMigrationStatus@1000 : Record 1799;
      DashboardEmptyNotification@1001 : Notification;
    BEGIN
      IF NOT DataMigrationStatus.ISEMPTY THEN
        EXIT;

      DashboardEmptyNotification.MESSAGE(DashboardEmptyNotificationMsg);
      DashboardEmptyNotification.ADDACTION(
        StartDataMigrationMsg,CODEUNIT::"Data Migration Mgt.",'StartDataMigrationWizardFromNotification');
      DashboardEmptyNotification.ADDACTION(LearnMoreTxt,CODEUNIT::"Data Migration Mgt.",'ShowHelpTopicPage');
      DashboardEmptyNotification.SEND;
      NotificationShown := TRUE;
    END;

    LOCAL PROCEDURE ShowRefreshNotification@2() NotificationShown : Boolean;
    VAR
      DataMigrationMgt@1002 : Codeunit 1798;
    BEGIN
      IF NOT DataMigrationMgt.IsMigrationInProgress THEN BEGIN
        IF RefreshNotificationShown THEN
          RefreshNotification.RECALL;
        EXIT;
      END;

      IF RefreshNotificationShown THEN
        EXIT;

      RefreshNotification.MESSAGE(RefreshNotificationMsg);
      RefreshNotification.SEND;
      NotificationShown := TRUE;
      RefreshNotificationShown := TRUE;
    END;

    PROCEDURE GoToItemJournal@21();
    VAR
      ItemJournalLine@1001 : Record 83;
      ItemJournalBatchName@1003 : Code[10];
    BEGIN
      DataMigrationFacade.OnFindBatchForItemTransactions("Migration Type",ItemJournalBatchName);
      IF ItemJournalBatchName <> '' THEN BEGIN
        ItemJournalLine.SETRANGE("Journal Batch Name",ItemJournalBatchName);
        IF ItemJournalLine.FINDFIRST THEN BEGIN
          ItemJournalLine.SETRANGE("Journal Template Name",ItemJournalLine."Journal Template Name");
          PAGE.RUN(PAGE::"Item Journal",ItemJournalLine);
          EXIT;
        END;
      END;
      PAGE.RUN(PAGE::"Item Journal");
    END;

    PROCEDURE GoToGeneralJournalForCustomers@23();
    VAR
      GenJournalLine@1002 : Record 81;
      GenJournalBatchName@1003 : Code[10];
    BEGIN
      DataMigrationFacade.OnFindBatchForCustomerTransactions("Migration Type",GenJournalBatchName);
      IF GenJournalBatchName <> '' THEN BEGIN
        GenJournalLine.SETRANGE("Journal Batch Name",GenJournalBatchName);
        IF GenJournalLine.FINDFIRST THEN BEGIN
          GenJournalLine.SETRANGE("Journal Template Name",GenJournalLine."Journal Template Name");
          GenJournalLine.SETRANGE("Account Type",GenJournalLine."Account Type"::Customer);
          PAGE.RUN(PAGE::"General Journal",GenJournalLine);
          EXIT;
        END;
      END;
      PAGE.RUN(PAGE::"General Journal");
    END;

    PROCEDURE GoToGeneralJournalForVendors@36();
    VAR
      GenJournalLine@1000 : Record 81;
      GenJournalBatchName@1003 : Code[10];
    BEGIN
      DataMigrationFacade.OnFindBatchForVendorTransactions("Migration Type",GenJournalBatchName);
      IF GenJournalBatchName <> '' THEN BEGIN
        GenJournalLine.SETRANGE("Journal Batch Name",GenJournalBatchName);
        IF GenJournalLine.FINDFIRST THEN BEGIN
          GenJournalLine.SETRANGE("Journal Template Name",GenJournalLine."Journal Template Name");
          GenJournalLine.SETRANGE("Account Type",GenJournalLine."Account Type"::Vendor);
          PAGE.RUN(PAGE::"General Journal",GenJournalLine);
          EXIT;
        END;
      END;
      PAGE.RUN(PAGE::"General Journal");
    END;

    LOCAL PROCEDURE GoToGeneralJournalForAccounts@19();
    VAR
      GenJournalLine@1001 : Record 81;
      GenJournalBatchName@1000 : Code[10];
    BEGIN
      DataMigrationFacade.OnFindBatchForAccountTransactions(Rec,GenJournalBatchName);
      IF GenJournalBatchName <> '' THEN BEGIN
        GenJournalLine.SETRANGE("Journal Batch Name",GenJournalBatchName);
        IF GenJournalLine.FINDFIRST THEN BEGIN
          GenJournalLine.SETRANGE("Journal Template Name",GenJournalLine."Journal Template Name");
          GenJournalLine.SETRANGE("Account Type",GenJournalLine."Account Type"::"G/L Account");
          PAGE.RUN(PAGE::"General Journal",GenJournalLine);
          EXIT;
        END;
      END;
      PAGE.RUN(PAGE::"General Journal");
    END;

    BEGIN
    END.
  }
}

