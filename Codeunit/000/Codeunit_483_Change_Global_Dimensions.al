OBJECT Codeunit 483 Change Global Dimensions
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    TableNo=483;
    Permissions=TableData 17=rm,
                TableData 21=rm,
                TableData 25=rm,
                TableData 32=rm,
                TableData 110=rm,
                TableData 111=rm,
                TableData 112=rm,
                TableData 113=rm,
                TableData 114=rm,
                TableData 115=rm,
                TableData 120=rm,
                TableData 121=rm,
                TableData 122=rm,
                TableData 123=rm,
                TableData 124=rm,
                TableData 125=rm,
                TableData 169=rm,
                TableData 203=rm,
                TableData 271=rm,
                TableData 281=rm,
                TableData 297=rm,
                TableData 304=rm,
                TableData 379=rm,
                TableData 380=rm,
                TableData 1005=rm,
                TableData 5222=rm,
                TableData 5223=rm,
                TableData 5405=rm,
                TableData 5406=rm,
                TableData 5407=rm,
                TableData 5409=rm,
                TableData 5410=rm,
                TableData 5411=rm,
                TableData 5412=rm,
                TableData 5413=rm,
                TableData 5414=rm,
                TableData 5415=rm,
                TableData 5416=rm,
                TableData 5601=rm,
                TableData 5625=rm,
                TableData 5629=rm,
                TableData 5802=rm,
                TableData 5832=rm,
                TableData 5900=rm,
                TableData 5901=rm,
                TableData 5902=rm,
                TableData 5907=rm,
                TableData 5965=rm,
                TableData 5970=rm,
                TableData 6650=rm,
                TableData 6651=rm,
                TableData 6660=rm,
                TableData 6661=rm;
    OnRun=BEGIN
            IF ChangeGlobalDimLogMgt.IsBufferClear THEN
              ChangeGlobalDimLogMgt.FillBuffer;
            BINDSUBSCRIPTION(ChangeGlobalDimLogMgt);
            IF RunTask(Rec) THEN BEGIN
              DeleteEntry(Rec);
              IF ChangeGlobalDimLogMgt.IsBufferClear THEN
                ResetState;
            END;
          END;

  }
  CODE
  {
    VAR
      ChangeGlobalDimHeader@1001 : Record 484;
      GeneralLedgerSetup@1000 : Record 98;
      ChangeGlobalDimLogMgt@1010 : Codeunit 484;
      Window@1005 : Dialog;
      CloseActiveSessionsMsg@1012 : TextConst 'DAN=Luk alle andre sessioner, der er aktive.;ENU=Close all other active sessions.';
      CloseSessionNotificationTok@1013 : TextConst '@@@={Locked};DAN=A2C57B69-B056-4B3B-8D0F-C0D997145EE7;ENU=A2C57B69-B056-4B3B-8D0F-C0D997145EE7';
      CurrRecord@1008 : Integer;
      NoOfRecords@1007 : Integer;
      ProgressMsg@1014 : TextConst '@@@="#1-Table Id and Name;#2 - progress bar.";DAN=Opdaterer #1#####\@2@@@@@@@@@@;ENU=Updating #1#####\@2@@@@@@@@@@';
      IsWindowOpen@1015 : Boolean;

    [External]
    PROCEDURE ResetIfAllCompleted@20();
    BEGIN
      ChangeGlobalDimLogMgt.FillBuffer;
      IF ChangeGlobalDimLogMgt.AreAllCompleted THEN
        ResetState;
    END;

    LOCAL PROCEDURE GetDelayInScheduling@19() : Integer;
    BEGIN
      // duration in milliseconds between scheduled jobs
      EXIT(100);
    END;

    PROCEDURE Prepare@10();
    BEGIN
      ChangeGlobalDimHeader.GET;
      IF IsPrepareEnabled(ChangeGlobalDimHeader) AND ChangeGlobalDimHeader."Parallel Processing" THEN
        IF IsCurrentSessionActiveOnly THEN
          PrepareTableList
        ELSE
          SendCloseSessionsNotification
    END;

    LOCAL PROCEDURE PrepareTableList@59() IsListFilled : Boolean;
    BEGIN
      IsListFilled := InitTableList;
      IF NOT IsListFilled THEN BEGIN
        UpdateGLSetup;
        RefreshHeader;
      END;
    END;

    LOCAL PROCEDURE ProcessTableList@61();
    VAR
      ChangeGlobalDimLogEntry@1000 : Record 483;
    BEGIN
      WITH ChangeGlobalDimLogEntry DO BEGIN
        RESET;
        SETFILTER("Table ID",'>0');
        SETRANGE("Parent Table ID",0);
        IF IsWindowOpen THEN BEGIN
          CurrRecord := 0;
          CALCSUMS("Total Records");
          NoOfRecords := "Total Records";
        END;
        IF FINDSET(TRUE) THEN
          REPEAT
            IF IsWindowOpen THEN
              Window.UPDATE(1,STRSUBSTNO('%1 %2',"Table ID","Table Name"));
            IF RunTask(ChangeGlobalDimLogEntry) THEN
              DeleteEntry(ChangeGlobalDimLogEntry);
          UNTIL NEXT = 0;
        ResetIfAllCompleted;
      END;
    END;

    PROCEDURE RemoveHeader@16();
    VAR
      ChangeGlobalDimHeader@1000 : Record 484;
      ChangeGlobalDimLogEntry@1001 : Record 483;
    BEGIN
      IF ChangeGlobalDimLogEntry.ISEMPTY THEN
        ChangeGlobalDimHeader.DELETEALL;
    END;

    PROCEDURE ResetState@47();
    VAR
      ChangeGlobalDimLogEntry@1000 : Record 483;
    BEGIN
      ChangeGlobalDimLogEntry.DELETEALL(TRUE);
      CLEARALL;
      ChangeGlobalDimLogMgt.ClearBuffer;
      RefreshHeader;
    END;

    [External]
    PROCEDURE Rerun@54(VAR ChangeGlobalDimLogEntry@1001 : Record 483);
    BEGIN
      ChangeGlobalDimLogEntry.LOCKTABLE;
      ChangeGlobalDimLogEntry.UpdateStatus;
      IF ChangeGlobalDimLogMgt.FillBuffer THEN
        RerunEntry(ChangeGlobalDimLogEntry);
    END;

    LOCAL PROCEDURE RunTask@52(VAR ChangeGlobalDimLogEntry@1001 : Record 483) Completed : Boolean;
    BEGIN
      ChangeGlobalDimLogEntry.SetSessionInProgress;
      IF ChangeGlobalDimHeader."Parallel Processing" THEN
        COMMIT;
      Completed := ChangeDimsOnTable(ChangeGlobalDimLogEntry);
    END;

    PROCEDURE Start@27();
    BEGIN
      ChangeGlobalDimHeader.GET;
      IF IsStartEnabled THEN BEGIN
        CompleteEmptyTables;
        UpdateGLSetup;
        ScheduleJobs(GetDelayInScheduling);
        RefreshHeader;
      END;
    END;

    PROCEDURE StartSequential@58();
    BEGIN
      ChangeGlobalDimHeader.GET;
      IF IsPrepareEnabled(ChangeGlobalDimHeader) AND NOT ChangeGlobalDimHeader."Parallel Processing" THEN BEGIN
        WindowOpen;
        IF PrepareTableList THEN BEGIN
          CompleteEmptyTables;
          UpdateGLSetup;
          ProcessTableList;
          RefreshHeader;
        END;
        WindowClose;
      END;
    END;

    LOCAL PROCEDURE CompleteEmptyTables@12();
    VAR
      ChangeGlobalDimLogEntry@1000 : Record 483;
      RecRef@1001 : RecordRef;
    BEGIN
      ChangeGlobalDimLogEntry.SETFILTER("Table ID",'>0');
      ChangeGlobalDimLogEntry.SETRANGE("Total Records",0);
      IF ChangeGlobalDimLogEntry.FINDSET(TRUE) THEN
        REPEAT
          RecRef.OPEN(ChangeGlobalDimLogEntry."Table ID");
          RecRef.LOCKTABLE(TRUE);
          ChangeGlobalDimLogEntry."Total Records" := RecRef.COUNT;
          IF ChangeGlobalDimLogEntry."Total Records" = 0 THEN
            DeleteEntry(ChangeGlobalDimLogEntry)
          ELSE
            ChangeGlobalDimLogEntry.MODIFY;
          RecRef.CLOSE;
        UNTIL ChangeGlobalDimLogEntry.NEXT = 0;
    END;

    PROCEDURE FillBuffer@4();
    BEGIN
      ChangeGlobalDimLogMgt.FillBuffer;
    END;

    LOCAL PROCEDURE FindChildTableNo@1(ChangeGlobalDimLogEntry@1000 : Record 483) : Integer;
    BEGIN
      IF ChangeGlobalDimLogEntry."Is Parent Table" THEN
        EXIT(ChangeGlobalDimLogMgt.FindChildTable(ChangeGlobalDimLogEntry."Table ID"));
      EXIT(0);
    END;

    LOCAL PROCEDURE FindDependentTableNo@23(VAR ChangeGlobalDimLogEntry@1003 : Record 483;ParentChangeGlobalDimLogEntry@1000 : Record 483;VAR DependentRecRef@1001 : RecordRef) : Boolean;
    VAR
      ChildTableNo@1002 : Integer;
    BEGIN
      WITH ChangeGlobalDimLogEntry DO BEGIN
        ChildTableNo := FindChildTableNo(ParentChangeGlobalDimLogEntry);
        IF ChildTableNo > 0 THEN
          IF GET(ChildTableNo) THEN BEGIN
            DependentRecRef.OPEN("Table ID");
            DependentRecRef.LOCKTABLE(TRUE);
            "Total Records" := DependentRecRef.COUNT;
            "Session ID" := SESSIONID;
            "Server Instance ID" := SERVICEINSTANCEID;
            EXIT("Total Records" > 0);
          END;
      END;
    END;

    PROCEDURE FindTablesForScheduling@31(VAR ChangeGlobalDimLogEntry@1000 : Record 483) : Boolean;
    BEGIN
      WITH ChangeGlobalDimLogEntry DO BEGIN
        SETRANGE("Parent Table ID",0);
        SETFILTER("Total Records",'>0');
        EXIT(FINDSET(TRUE))
      END;
    END;

    LOCAL PROCEDURE GetMinCommitSize@41() : Integer;
    BEGIN
      // number of records that should be modified between COMMIT calls
      EXIT(10);
    END;

    LOCAL PROCEDURE CalcRecordsWithinCommit@40(TotalRecords@1000 : Integer) RecordsWithinCommit : Integer;
    BEGIN
      RecordsWithinCommit := ROUND(TotalRecords / 100,1,'>');
      IF RecordsWithinCommit < GetMinCommitSize THEN
        RecordsWithinCommit := GetMinCommitSize;
    END;

    LOCAL PROCEDURE ChangeDimsOnTable@39(VAR ChangeGlobalDimLogEntry@1001 : Record 483) Completed : Boolean;
    VAR
      DependentChangeGlobalDimLogEntry@1003 : Record 483;
      RecRef@1002 : RecordRef;
      DependentRecRef@1005 : RecordRef;
      CurrentRecNo@1004 : Integer;
      DependentRecNo@1006 : Integer;
      RecordsWithinCommit@1000 : Integer;
      StartedFromRecord@1007 : Integer;
      StartedFromDependentRecord@1010 : Integer;
      DependentEntryCompleted@1008 : Boolean;
    BEGIN
      RecRef.OPEN(ChangeGlobalDimLogEntry."Table ID");
      RecRef.LOCKTABLE(TRUE);
      IF NOT RecRef.ISEMPTY THEN BEGIN
        CurrentRecNo := ChangeGlobalDimLogEntry."Completed Records";
        StartedFromRecord := CurrentRecNo;
        ChangeGlobalDimLogEntry."Total Records" := RecRef.COUNT;
        RecordsWithinCommit := CalcRecordsWithinCommit(ChangeGlobalDimLogEntry."Total Records");
        IF RecRef.FINDSET(TRUE) THEN BEGIN
          IF FindDependentTableNo(DependentChangeGlobalDimLogEntry,ChangeGlobalDimLogEntry,DependentRecRef) THEN BEGIN
            DependentChangeGlobalDimLogEntry.SetSessionInProgress;
            DependentRecNo := DependentChangeGlobalDimLogEntry."Completed Records";
            StartedFromDependentRecord := DependentRecNo;
            DependentChangeGlobalDimLogEntry."Earliest Start Date/Time" := CURRENTDATETIME;
          END;
          IF ChangeGlobalDimLogEntry."Completed Records" > 0 THEN
            RecRef.NEXT(ChangeGlobalDimLogEntry."Completed Records");
          ChangeGlobalDimLogEntry."Earliest Start Date/Time" := CURRENTDATETIME;
          REPEAT
            ChangeDimsOnRecord(ChangeGlobalDimLogEntry,RecRef);
            CurrentRecNo += 1;
            IF DependentChangeGlobalDimLogEntry."Total Records" > 0 THEN
              ChangeDependentRecords(ChangeGlobalDimLogEntry,DependentChangeGlobalDimLogEntry,RecRef,DependentRecRef,DependentRecNo);

            IF CurrentRecNo >= (ChangeGlobalDimLogEntry."Completed Records" + RecordsWithinCommit) THEN BEGIN
              DependentChangeGlobalDimLogEntry.Update(DependentRecNo,StartedFromDependentRecord);
              Completed := UpdateWithCommit(ChangeGlobalDimLogEntry,CurrentRecNo,StartedFromRecord);
              IF DependentRecNo > 0 THEN
                DependentRecRef.LOCKTABLE;
              RecRef.LOCKTABLE;
            END;
            IF IsWindowOpen THEN BEGIN
              CurrRecord += 1;
              IF CurrRecord MOD ROUND(NoOfRecords / 100,1,'>') = 1 THEN
                Window.UPDATE(2,ROUND(CurrRecord / NoOfRecords * 10000,1));
            END;
          UNTIL RecRef.NEXT = 0;
        END;
        IF DependentRecNo > 0 THEN BEGIN
          DependentRecRef.CLOSE;
          DependentChangeGlobalDimLogEntry.Update(DependentRecNo,StartedFromDependentRecord);
          IF DependentChangeGlobalDimLogEntry.Status = DependentChangeGlobalDimLogEntry.Status::Completed THEN
            DependentEntryCompleted := DeleteEntry(DependentChangeGlobalDimLogEntry);
          IF NOT DependentEntryCompleted THEN BEGIN
            DependentChangeGlobalDimLogEntry.Update(0,0);
            CurrentRecNo := 0; // set the parent to Incomplete
          END;
        END;
        Completed := UpdateWithCommit(ChangeGlobalDimLogEntry,CurrentRecNo,StartedFromRecord);
      END;
      RecRef.CLOSE;
    END;

    LOCAL PROCEDURE ChangeDimsOnRecord@50(ChangeGlobalDimLogEntry@1003 : Record 483;VAR RecRef@1000 : RecordRef) : Boolean;
    VAR
      GlobalDimFieldRef@1001 : ARRAY [2] OF FieldRef;
      OldDimValueCode@1002 : ARRAY [2] OF Code[20];
    BEGIN
      WITH ChangeGlobalDimLogEntry DO BEGIN
        IF ("Change Type 1" = "Change Type 1"::None) AND ("Change Type 2" = "Change Type 2"::None) THEN
          EXIT(FALSE);

        GetFieldRefValues(RecRef,GlobalDimFieldRef,OldDimValueCode);
        ChangeDimOnRecord(RecRef,1,GlobalDimFieldRef[1],OldDimValueCode[2]);
        ChangeDimOnRecord(RecRef,2,GlobalDimFieldRef[2],OldDimValueCode[1]);
        EXIT(RecRef.MODIFY);
      END;
    END;

    LOCAL PROCEDURE ChangeDependentRecords@42(ParentChangeGlobalDimLogEntry@1005 : Record 483;ChangeGlobalDimLogEntry@1009 : Record 483;ParentRecRef@1000 : RecordRef;VAR RecRef@1002 : RecordRef;VAR CurrentRecNo@1008 : Integer);
    VAR
      ParentKeyValue@1007 : Variant;
      GlobalDimFieldRef@1001 : ARRAY [2] OF FieldRef;
      ParentKeyFieldRef@1006 : FieldRef;
      ParentDimValueCode@1003 : ARRAY [2] OF Code[20];
      DimValueCode@1004 : ARRAY [2] OF Code[20];
    BEGIN
      ParentChangeGlobalDimLogEntry.GetFieldRefValues(ParentRecRef,GlobalDimFieldRef,ParentDimValueCode);
      ChangeGlobalDimLogEntry.GetPrimaryKeyFieldRef(ParentRecRef,ParentKeyFieldRef);
      ParentKeyValue := ParentKeyFieldRef.VALUE;

      ParentKeyFieldRef := RecRef.FIELD(2);
      ParentKeyFieldRef.SETRANGE(ParentKeyValue);
      IF RecRef.FINDSET(TRUE) THEN BEGIN
        REPEAT
          ChangeGlobalDimLogEntry.GetFieldRefValues(RecRef,GlobalDimFieldRef,DimValueCode);
          GlobalDimFieldRef[1].VALUE(ParentDimValueCode[1]);
          GlobalDimFieldRef[2].VALUE(ParentDimValueCode[2]);
          RecRef.MODIFY;
          CurrentRecNo += 1;
        UNTIL RecRef.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE RerunEntry@38(ChangeGlobalDimLogEntry@1000 : Record 483);
    BEGIN
      WITH ChangeGlobalDimLogEntry DO
        IF Status IN [Status::" ",Status::Incomplete,Status::Scheduled] THEN BEGIN
          IF "Parent Table ID" <> 0 THEN
            RescheduleParentTable("Parent Table ID")
          ELSE
            ScheduleJobForTable(ChangeGlobalDimLogEntry,CURRENTDATETIME + 2000);
        END;
    END;

    LOCAL PROCEDURE RescheduleParentTable@37(ParentTableID@1001 : Integer);
    VAR
      ParentChangeGlobalDimLogEntry@1000 : Record 483;
    BEGIN
      ParentChangeGlobalDimLogEntry.GET(ParentTableID);
      ParentChangeGlobalDimLogEntry.VALIDATE("Completed Records",0);
      ScheduleJobForTable(ParentChangeGlobalDimLogEntry,CURRENTDATETIME + 100);
    END;

    LOCAL PROCEDURE ScheduleJobs@11(DeltaMsec@1002 : Integer);
    VAR
      ChangeGlobalDimLogEntry@1000 : Record 483;
      StartTime@1001 : DateTime;
    BEGIN
      IF FindTablesForScheduling(ChangeGlobalDimLogEntry) THEN BEGIN
        StartTime := CURRENTDATETIME + 1000;
        REPEAT
          StartTime += DeltaMsec;
          ScheduleJobForTable(ChangeGlobalDimLogEntry,StartTime);
        UNTIL ChangeGlobalDimLogEntry.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE ScheduleJobForTable@24(ChangeGlobalDimLogEntry@1000 : Record 483;StartNotBefore@1003 : DateTime);
    VAR
      DoNotScheduleTask@1002 : Boolean;
      TaskID@1001 : GUID;
    BEGIN
      WITH ChangeGlobalDimLogEntry DO BEGIN
        OnBeforeScheduleTask("Table ID",DoNotScheduleTask,TaskID);
        IF DoNotScheduleTask THEN
          "Task ID" := TaskID
        ELSE BEGIN
          CancelTask;
          "Task ID" :=
            TASKSCHEDULER.CREATETASK(
              CODEUNIT::"Change Global Dimensions",CODEUNIT::"Change Global Dim Err. Handler",
              TRUE,COMPANYNAME,StartNotBefore,RECORDID);
        END;
        IF ISNULLGUID("Task ID") THEN
          Status := Status::" "
        ELSE
          Status := Status::Scheduled;
        "Earliest Start Date/Time" := StartNotBefore;
        MODIFY;
      END;
      IF ChangeGlobalDimLogEntry."Is Parent Table" THEN
        ScheduleDependentTables(ChangeGlobalDimLogEntry);
    END;

    LOCAL PROCEDURE ScheduleDependentTables@30(ChangeGlobalDimLogEntry@1000 : Record 483);
    VAR
      DependentChangeGlobalDimLogEntry@1001 : Record 483;
    BEGIN
      WITH DependentChangeGlobalDimLogEntry DO BEGIN
        SETRANGE("Parent Table ID",ChangeGlobalDimLogEntry."Table ID");
        IF FINDSET THEN
          REPEAT
            "Task ID" := ChangeGlobalDimLogEntry."Task ID";
            VALIDATE("Completed Records",0);
            Status := ChangeGlobalDimLogEntry.Status;
            MODIFY;
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE IsCurrentSessionActiveOnly@21() Result : Boolean;
    VAR
      ActiveSession@1000 : Record 2000000110;
    BEGIN
      OnCountingActiveSessions(Result);
      IF Result THEN
        EXIT(TRUE);
      // Ignore session types: Web Service,Client Service,NAS,Management Client
      ActiveSession.SETFILTER(
        "Client Type",'<>%1&<>%2&<>%3&<>%4',
        ActiveSession."Client Type"::"Web Service",ActiveSession."Client Type"::"Client Service",
        ActiveSession."Client Type"::NAS,ActiveSession."Client Type"::"Management Client");
      ActiveSession.SETFILTER("Session ID",'<>%1',SESSIONID);
      ActiveSession.SETRANGE("Server Instance ID",SERVICEINSTANCEID);
      EXIT(ActiveSession.ISEMPTY);
    END;

    PROCEDURE IsDimCodeEnabled@8() : Boolean;
    BEGIN
      EXIT(ChangeGlobalDimLogMgt.IsBufferClear);
    END;

    [External]
    PROCEDURE IsPrepareEnabled@5(VAR ChangeGlobalDimHeader@1000 : Record 484) : Boolean;
    BEGIN
      WITH ChangeGlobalDimHeader DO
        EXIT(
          (("Change Type 1" <> "Change Type 1"::None) OR ("Change Type 2" <> "Change Type 2"::None)) AND
          ChangeGlobalDimLogMgt.IsBufferClear);
    END;

    PROCEDURE IsStartEnabled@28() : Boolean;
    BEGIN
      IF ChangeGlobalDimLogMgt.IsBufferClear THEN
        EXIT(FALSE);
      EXIT(NOT ChangeGlobalDimLogMgt.IsStarted);
    END;

    [External]
    PROCEDURE RefreshHeader@3();
    BEGIN
      IF ChangeGlobalDimHeader.GET THEN BEGIN
        ChangeGlobalDimHeader.Refresh;
        ChangeGlobalDimHeader.MODIFY;
      END ELSE BEGIN
        ChangeGlobalDimHeader.Refresh;
        ChangeGlobalDimHeader.INSERT;
      END
    END;

    [External]
    PROCEDURE SetParallelProcessing@56(NewParallelProcessing@1000 : Boolean);
    BEGIN
      ChangeGlobalDimHeader.GET;
      ChangeGlobalDimHeader."Parallel Processing" := NewParallelProcessing;
      ChangeGlobalDimHeader.MODIFY;
    END;

    PROCEDURE InitTableList@7() : Boolean;
    VAR
      ChangeGlobalDimLogEntry@1002 : Record 483;
      TempAllObjWithCaption@1000 : TEMPORARY Record 2000000058;
      TempParentTableInteger@1001 : TEMPORARY Record 2000000026;
      TotalRecords@1003 : Integer;
    BEGIN
      TotalRecords := 0;
      ChangeGlobalDimHeader.GET;
      ChangeGlobalDimLogEntry.LOCKTABLE;
      ChangeGlobalDimLogEntry.DELETEALL(TRUE);
      IF FindTablesWithDims(TempAllObjWithCaption) THEN BEGIN
        REPEAT
          ChangeGlobalDimLogEntry.INIT;
          ChangeGlobalDimLogEntry."Table ID" := TempAllObjWithCaption."Object ID";
          ChangeGlobalDimLogEntry."Table Name" := TempAllObjWithCaption."Object Name";
          ChangeGlobalDimLogEntry."Change Type 1" := ChangeGlobalDimHeader."Change Type 1";
          ChangeGlobalDimLogEntry."Change Type 2" := ChangeGlobalDimHeader."Change Type 2";
          FillTableData(ChangeGlobalDimLogEntry);
          TotalRecords += ChangeGlobalDimLogEntry."Total Records";
          TempParentTableInteger.Number := ChangeGlobalDimLogEntry."Parent Table ID";
          IF TempParentTableInteger.Number <> 0 THEN
            TempParentTableInteger.INSERT;
          ChangeGlobalDimLogEntry.INSERT;
        UNTIL TempAllObjWithCaption.NEXT = 0;

        IF TempParentTableInteger.FINDSET THEN
          REPEAT
            IF ChangeGlobalDimLogEntry.GET(TempParentTableInteger.Number) THEN BEGIN
              ChangeGlobalDimLogEntry."Is Parent Table" := TRUE;
              ChangeGlobalDimLogEntry.MODIFY;
            END;
          UNTIL TempParentTableInteger.NEXT = 0;
      END;
      IF TotalRecords = 0 THEN
        ChangeGlobalDimLogEntry.DELETEALL(TRUE);
      ChangeGlobalDimLogMgt.FillBuffer;
      EXIT(TotalRecords <> 0);
    END;

    LOCAL PROCEDURE TestDirectModifyPermission@51(VAR RecRef@1000 : RecordRef);
    BEGIN
      IF RecRef.FINDFIRST THEN
        RecRef.MODIFY;
    END;

    LOCAL PROCEDURE DeleteEntry@2(ChangeGlobalDimLogEntry@1000 : Record 483) : Boolean;
    BEGIN
      IF ChangeGlobalDimLogEntry.DELETE THEN BEGIN
        ChangeGlobalDimLogMgt.ExcludeTable(ChangeGlobalDimLogEntry."Table ID");
        EXIT(TRUE);
      END
    END;

    LOCAL PROCEDURE FillTableData@49(VAR ChangeGlobalDimLogEntry@1001 : Record 483);
    VAR
      RecRef@1000 : RecordRef;
    BEGIN
      RecRef.OPEN(ChangeGlobalDimLogEntry."Table ID");
      TestDirectModifyPermission(RecRef);
      ChangeGlobalDimLogEntry.FillData(RecRef);
      RecRef.CLOSE;
    END;

    LOCAL PROCEDURE FindTablesWithDims@26(VAR TempAllObjWithCaption@1001 : TEMPORARY Record 2000000058) : Boolean;
    VAR
      DimensionManagement@1000 : Codeunit 408;
    BEGIN
      DimensionManagement.DefaultDimObjectNoWithGlobalDimsList(TempAllObjWithCaption);
      DimensionManagement.GlobalDimObjectNoList(TempAllObjWithCaption);
      DimensionManagement.JobTaskDimObjectNoList(TempAllObjWithCaption);
      OnAfterGetObjectNoList(TempAllObjWithCaption);
      EXIT(TempAllObjWithCaption.FINDSET);
    END;

    LOCAL PROCEDURE UpdateGLSetup@6();
    BEGIN
      GeneralLedgerSetup.GET;
      GeneralLedgerSetup.VALIDATE("Global Dimension 1 Code",ChangeGlobalDimHeader."Global Dimension 1 Code");
      GeneralLedgerSetup.VALIDATE("Global Dimension 2 Code",ChangeGlobalDimHeader."Global Dimension 2 Code");
      GeneralLedgerSetup.MODIFY(TRUE);

      UpdateDimValues;
      IF ChangeGlobalDimHeader."Parallel Processing" THEN
        COMMIT;
    END;

    LOCAL PROCEDURE UpdateDimValues@14();
    VAR
      DimensionValue@1000 : Record 349;
    BEGIN
      WITH DimensionValue DO BEGIN
        SETCURRENTKEY(Code,"Global Dimension No.");
        SETRANGE("Global Dimension No.",1,2);
        MODIFYALL("Global Dimension No.",0);
        RESET;
        IF ChangeGlobalDimHeader."Global Dimension 1 Code" <> '' THEN BEGIN
          SETRANGE("Dimension Code",ChangeGlobalDimHeader."Global Dimension 1 Code");
          MODIFYALL("Global Dimension No.",1);
        END;
        IF ChangeGlobalDimHeader."Global Dimension 2 Code" <> '' THEN BEGIN
          SETRANGE("Dimension Code",ChangeGlobalDimHeader."Global Dimension 2 Code");
          MODIFYALL("Global Dimension No.",2);
        END;
      END;
    END;

    PROCEDURE GetCloseSessionsNotificationID@45() Id : GUID;
    BEGIN
      EVALUATE(Id,CloseSessionNotificationTok);
    END;

    LOCAL PROCEDURE PrepareNotification@25(VAR Notification@1000 : Notification;ID@1001 : GUID;Msg@1002 : Text);
    BEGIN
      Notification.ID(ID);
      Notification.RECALL;
      Notification.MESSAGE(Msg);
      Notification.SCOPE(NOTIFICATIONSCOPE::LocalScope);
    END;

    LOCAL PROCEDURE SendCloseSessionsNotification@44();
    VAR
      DummySessionListPage@1001 : Page 9506;
      Notification@1000 : Notification;
    BEGIN
      PrepareNotification(Notification,GetCloseSessionsNotificationID,CloseActiveSessionsMsg);
      Notification.ADDACTION(DummySessionListPage.CAPTION,CODEUNIT::"Change Global Dimensions",'ShowActiveSessions');
      Notification.SEND;
    END;

    PROCEDURE ShowActiveSessions@46(BlockNotification@1000 : Notification);
    BEGIN
      PAGE.RUN(PAGE::"Concurrent Session List");
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterGetObjectNoList@18(VAR TempAllObjWithCaption@1000 : TEMPORARY Record 2000000058);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnCountingActiveSessions@36(VAR IsCurrSessionActiveOnly@1000 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeScheduleTask@29(TableNo@1002 : Integer;VAR DoNotScheduleTask@1000 : Boolean;VAR TaskID@1001 : GUID);
    BEGIN
    END;

    LOCAL PROCEDURE UpdateWithCommit@62(VAR ChangeGlobalDimLogEntry@1000 : Record 483;CurrentRecNo@1002 : Integer;StartedFromRecord@1001 : Integer) : Boolean;
    BEGIN
      IF ChangeGlobalDimHeader."Parallel Processing" THEN
        EXIT(ChangeGlobalDimLogEntry.UpdateWithCommit(CurrentRecNo,StartedFromRecord));
      EXIT(ChangeGlobalDimLogEntry.UpdateWithoutCommit(CurrentRecNo,StartedFromRecord));
    END;

    LOCAL PROCEDURE WindowOpen@67();
    BEGIN
      IF GUIALLOWED THEN BEGIN
        Window.OPEN(ProgressMsg);
        IsWindowOpen := TRUE;
      END;
    END;

    LOCAL PROCEDURE WindowClose@68();
    BEGIN
      IF IsWindowOpen THEN BEGIN
        Window.CLOSE;
        IsWindowOpen := FALSE;
      END;
    END;

    BEGIN
    END.
  }
}

