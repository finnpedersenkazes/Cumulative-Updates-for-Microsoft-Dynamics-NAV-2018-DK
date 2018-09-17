OBJECT Codeunit 483 Change Global Dimensions
{
  OBJECT-PROPERTIES
  {
    Date=26-01-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20348;
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
                TableData 5601=rm,
                TableData 5625=rm,
                TableData 5629=rm,
                TableData 5802=rm,
                TableData 5832=rm,
                TableData 6650=rm,
                TableData 6651=rm,
                TableData 6660=rm,
                TableData 6661=rm;
    OnRun=VAR
            ExpectedDelay@1000 : Duration;
          BEGIN
            ExpectedDelay := FindConcurrentTaskInProgress("Table ID");
            IF ExpectedDelay > 0 THEN
              ScheduleJobForTable(Rec,CURRENTDATETIME + ExpectedDelay + 2000)
            ELSE
              IF RunTask THEN
                DeleteAllEntriesIfAllCompleted;
          END;

  }
  CODE
  {
    VAR
      GeneralLedgerSetup@1000 : Record 98;
      BlockTableOpsSubscriber@1010 : Codeunit 484;
      ChangeType@1002 : ARRAY [2] OF 'None,Blank,Replace,New';
      NewGlobalDimCode@1001 : ARRAY [2] OF Code[20];
      CurrentGlobalDimCode@1003 : ARRAY [2] OF Code[20];
      DimIsUsedInGLSetupErr@1006 : TextConst '@@@=%1 - a dimension code, like PROJECT;DAN=Dimensionen %1 bruges i vinduet Ops‘tning af Finans som en genvejsdimension.;ENU=The dimension %1 is used in General Ledger Setup window as a shortcut dimension.';
      BindNotificationIDTok@1009 : TextConst '@@@={Locked};DAN=CACDC1FF-2352-4B9D-9575-8BA4D85E64A0;ENU=CACDC1FF-2352-4B9D-9575-8BA4D85E64A0';
      BindNotificationMsg@1011 : TextConst 'DAN=Du skal genstarte den aktuelle session.;ENU=You must restart the current session.';
      CloseActiveSessionsMsg@1012 : TextConst 'DAN=Luk alle andre sessioner, der er aktive.;ENU=Close all other active sessions.';
      CloseSessionNotificationTok@1013 : TextConst '@@@={Locked};DAN=A2C57B69-B056-4B3B-8D0F-C0D997145EE7;ENU=A2C57B69-B056-4B3B-8D0F-C0D997145EE7';

    [External]
    PROCEDURE ActivateBlock@23();
    BEGIN
      IF BlockTableOpsSubscriber.IsClear THEN
        IF BlockTableOpsSubscriber.FindTablesToBlock THEN
          BINDSUBSCRIPTION(BlockTableOpsSubscriber);
    END;

    LOCAL PROCEDURE DeleteAllEntriesIfAllCompleted@20();
    VAR
      ChangeGlobalDimLogEntry@1000 : Record 483;
    BEGIN
      WITH ChangeGlobalDimLogEntry DO BEGIN
        SETFILTER(Status,'<>%1',Status::Completed);
        IF ISEMPTY THEN BEGIN
          RESET;
          DELETEALL;
        END;
      END;
    END;

    LOCAL PROCEDURE GetDelayInScheduling@19() : Integer;
    BEGIN
      // duration in milliseconds between scheduled jobs
      EXIT(100);
    END;

    PROCEDURE Prepare@10();
    VAR
      IsListEmpty@1000 : Boolean;
    BEGIN
      IF IsPrepareEnabled THEN
        IF IsCurrentSessionActiveOnly THEN BEGIN
          IsListEmpty := NOT InitTableList;
          IF IsListEmpty THEN BEGIN
            UpdateGLSetup;
            InitNewGlobalDimCodes;
          END;
        END ELSE
          SendCloseSessionsNotification;
    END;

    PROCEDURE Reset@47();
    VAR
      ChangeGlobalDimLogEntry@1000 : Record 483;
    BEGIN
      ChangeGlobalDimLogEntry.DELETEALL;
      CLEARALL;
      BlockTableOpsSubscriber.ClearState;
      UNBINDSUBSCRIPTION(BlockTableOpsSubscriber);
      InitNewGlobalDimCodes;
    END;

    PROCEDURE Start@27();
    BEGIN
      IF IsStartEnabled THEN
        IF BlockTableOpsSubscriber.IsSubscribed THEN BEGIN
          CompleteEmptyTables;
          UpdateGLSetup;
          ScheduleJobs(GetDelayInScheduling);
          InitNewGlobalDimCodes;
        END ELSE
          SendBindNotification;
    END;

    LOCAL PROCEDURE CompleteEmptyTables@12();
    VAR
      ChangeGlobalDimLogEntry@1000 : Record 483;
    BEGIN
      ChangeGlobalDimLogEntry.SETRANGE("Total Records",0);
      ChangeGlobalDimLogEntry.MODIFYALL(Progress,10000);
      ChangeGlobalDimLogEntry.MODIFYALL(Status,ChangeGlobalDimLogEntry.Status::Completed);
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

    PROCEDURE ChangeDimsOnTable@39(VAR ChangeGlobalDimLogEntry@1001 : Record 483) Completed : Boolean;
    VAR
      DependentChangeGlobalDimLogEntry@1003 : Record 483;
      RecRef@1002 : RecordRef;
      DependentRecRef@1005 : RecordRef;
      CurrentRecNo@1004 : Integer;
      DependentRecNo@1006 : Integer;
      RecordsWithinCommit@1000 : Integer;
      StartedFromRecord@1007 : Integer;
      StartedFromDependentRecord@1010 : Integer;
    BEGIN
      RecRef.OPEN(ChangeGlobalDimLogEntry."Table ID");
      RecRef.LOCKTABLE(TRUE);
      IF NOT RecRef.ISEMPTY THEN BEGIN
        CurrentRecNo := ChangeGlobalDimLogEntry."Completed Records";
        StartedFromRecord := CurrentRecNo;
        ChangeGlobalDimLogEntry."Total Records" := RecRef.COUNT;
        RecordsWithinCommit := CalcRecordsWithinCommit(ChangeGlobalDimLogEntry."Total Records");
        IF RecRef.FINDSET(TRUE) THEN BEGIN
          IF DependentChangeGlobalDimLogEntry.FindDependentTableNo(ChangeGlobalDimLogEntry,DependentRecRef) THEN BEGIN
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
              Completed := ChangeGlobalDimLogEntry.UpdateWithCommit(CurrentRecNo,StartedFromRecord);
              IF DependentRecNo > 0 THEN
                DependentRecRef.LOCKTABLE;
              RecRef.LOCKTABLE;
            END;
          UNTIL RecRef.NEXT = 0;
        END;
        IF DependentRecNo > 0 THEN BEGIN
          DependentRecRef.CLOSE;
          DependentChangeGlobalDimLogEntry.Update(DependentRecNo,StartedFromDependentRecord);
        END;
        Completed := ChangeGlobalDimLogEntry.UpdateWithCommit(CurrentRecNo,StartedFromRecord);
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

    PROCEDURE Rerun@38(ChangeGlobalDimLogEntry@1000 : Record 483);
    BEGIN
      WITH ChangeGlobalDimLogEntry DO
        IF Status IN [Status::" ",Status::Incomplete] THEN BEGIN
          IF "Parent Table ID" <> 0 THEN
            RescheduleParentTable("Parent Table ID")
          ELSE
            ScheduleJobForTable(ChangeGlobalDimLogEntry,CURRENTDATETIME);
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
        ELSE
          "Task ID" :=
            TASKSCHEDULER.CREATETASK(
              CODEUNIT::"Change Global Dimensions",0,TRUE,COMPANYNAME,StartNotBefore,RECORDID);
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

    LOCAL PROCEDURE FindConcurrentTaskInProgress@53(TableID@1000 : Integer) RemainingDuration : Duration;
    VAR
      ChangeGlobalDimLogEntry@1001 : Record 483;
    BEGIN
      ChangeGlobalDimLogEntry.SETFILTER("Table ID",GetConcurrentTableFilter(TableID));
      ChangeGlobalDimLogEntry.SETRANGE(Status,ChangeGlobalDimLogEntry.Status::"In Progress");
      IF ChangeGlobalDimLogEntry.FINDFIRST THEN
        RemainingDuration := ChangeGlobalDimLogEntry."Remaining Duration";
    END;

    LOCAL PROCEDURE GetConcurrentTableFilter@55(TableID@1000 : Integer) : Text;
    BEGIN
      CASE TableID OF
        DATABASE::"Sales Header",
        DATABASE::"Sales Line":
          EXIT('36|37');
        DATABASE::"Purchase Header",
        DATABASE::"Purchase Line":
          EXIT('38|39');
        DATABASE::"Cust. Ledger Entry",
        DATABASE::"Sales Invoice Header",
        DATABASE::"Sales Invoice Line",
        DATABASE::"Sales Cr.Memo Header",
        DATABASE::"Sales Cr.Memo Line":
          EXIT('21|112|113|114|115');
        DATABASE::"Vendor Ledger Entry",
        DATABASE::"Purch. Inv. Header",
        DATABASE::"Purch. Inv. Line",
        DATABASE::"Purch. Cr. Memo Hdr.",
        DATABASE::"Purch. Cr. Memo Line":
          EXIT('25|122|123|124|125');
      END;
    END;

    PROCEDURE IsDimCodeEnabled@8() : Boolean;
    VAR
      ChangeGlobalDimLogEntry@1000 : Record 483;
    BEGIN
      EXIT(ChangeGlobalDimLogEntry.ISEMPTY);
    END;

    [External]
    PROCEDURE IsPrepareEnabled@5() : Boolean;
    VAR
      ChangeGlobalDimLogEntry@1000 : Record 483;
    BEGIN
      EXIT(
        ((ChangeType[1] <> ChangeType[1]::None) OR (ChangeType[2] <> ChangeType[2]::None)) AND
        ChangeGlobalDimLogEntry.ISEMPTY);
    END;

    PROCEDURE IsStartEnabled@28() : Boolean;
    VAR
      ChangeGlobalDimLogEntry@1000 : Record 483;
    BEGIN
      IF ChangeGlobalDimLogEntry.ISEMPTY THEN
        EXIT(FALSE);
      EXIT(NOT IsStarted);
    END;

    LOCAL PROCEDURE IsStarted@32() : Boolean;
    VAR
      ChangeGlobalDimLogEntry@1000 : Record 483;
    BEGIN
      ChangeGlobalDimLogEntry.SETFILTER(Status,'<>%1',ChangeGlobalDimLogEntry.Status::" ");
      EXIT(NOT ChangeGlobalDimLogEntry.ISEMPTY);
    END;

    [External]
    PROCEDURE Initialize@33();
    BEGIN
      InitNewGlobalDimCodes;
      IF IsStartEnabled THEN
        RestoreNewDimCodes;
    END;

    [External]
    PROCEDURE InitNewGlobalDimCodes@3();
    BEGIN
      GeneralLedgerSetup.GET;
      CurrentGlobalDimCode[1] := GeneralLedgerSetup."Global Dimension 1 Code";
      CurrentGlobalDimCode[2] := GeneralLedgerSetup."Global Dimension 2 Code";
      NewGlobalDimCode[1] := CurrentGlobalDimCode[1];
      NewGlobalDimCode[2] := CurrentGlobalDimCode[2];
      CLEAR(ChangeType);
    END;

    [External]
    PROCEDURE GetCurrentGlobalDimCodes@16(VAR GlobalDimCode@1000 : ARRAY [2] OF Code[20]);
    BEGIN
      COPYARRAY(GlobalDimCode,CurrentGlobalDimCode,1);
    END;

    [External]
    PROCEDURE GetNewGlobalDimCodes@4(VAR GlobalDimCode@1000 : ARRAY [2] OF Code[20]) : Boolean;
    BEGIN
      COPYARRAY(GlobalDimCode,NewGlobalDimCode,1);
      EXIT(IsPrepareEnabled);
    END;

    [External]
    PROCEDURE SetNewGlobalDim1Code@1(NewCode@1000 : Code[20]);
    BEGIN
      ValidateDimCode(NewCode,NewGlobalDimCode[1]);
      IF NewGlobalDimCode[1] = NewGlobalDimCode[2] THEN BEGIN
        NewGlobalDimCode[2] := '';
        ChangeType[2] := ChangeType[2]::Blank
      END;
      CalcChangeType(1);
    END;

    [External]
    PROCEDURE SetNewGlobalDim2Code@2(NewCode@1000 : Code[20]);
    BEGIN
      ValidateDimCode(NewCode,NewGlobalDimCode[2]);
      IF NewGlobalDimCode[2] = NewGlobalDimCode[1] THEN BEGIN
        NewGlobalDimCode[1] := '';
        ChangeType[1] := ChangeType[1]::Blank
      END;
      CalcChangeType(2);
    END;

    LOCAL PROCEDURE CalcChangeType@13(DimNo@1002 : Integer);
    BEGIN
      IF NewGlobalDimCode[DimNo] = CurrentGlobalDimCode[GetOtherDimNo(DimNo)] THEN
        ChangeType[DimNo] := ChangeType[DimNo]::Replace
      ELSE
        IF NewGlobalDimCode[DimNo] = CurrentGlobalDimCode[DimNo] THEN
          ChangeType[DimNo] := ChangeType[DimNo]::None
        ELSE
          IF NewGlobalDimCode[DimNo] = '' THEN
            ChangeType[DimNo] := ChangeType[DimNo]::Blank
          ELSE
            ChangeType[DimNo] := ChangeType[DimNo]::New
    END;

    LOCAL PROCEDURE GetOtherDimNo@15(DimNo@1000 : Integer) : Integer;
    BEGIN
      IF DimNo = 1 THEN
        EXIT(2);
      EXIT(1);
    END;

    PROCEDURE InitTableList@7() : Boolean;
    VAR
      ChangeGlobalDimLogEntry@1002 : Record 483;
      TempAllObjWithCaption@1000 : TEMPORARY Record 2000000058;
      TempParentTableInteger@1001 : TEMPORARY Record 2000000026;
      TotalRecords@1003 : Integer;
    BEGIN
      TotalRecords := 0;
      ChangeGlobalDimLogEntry.LOCKTABLE;
      ChangeGlobalDimLogEntry.DELETEALL;
      IF FindTablesWithDims(TempAllObjWithCaption) THEN BEGIN
        InsertLogEntryWithNewDimCodes;
        REPEAT
          ChangeGlobalDimLogEntry.INIT;
          ChangeGlobalDimLogEntry."Table ID" := TempAllObjWithCaption."Object ID";
          ChangeGlobalDimLogEntry."Table Name" := TempAllObjWithCaption."Object Name";
          ChangeGlobalDimLogEntry."Change Type 1" := ChangeType[1];
          ChangeGlobalDimLogEntry."Change Type 2" := ChangeType[2];
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
        ChangeGlobalDimLogEntry.DELETEALL;
      EXIT(TotalRecords <> 0);
    END;

    LOCAL PROCEDURE TestDirectModifyPermission@51(VAR RecRef@1000 : RecordRef);
    BEGIN
      IF RecRef.FINDFIRST THEN
        RecRef.MODIFY;
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
      GeneralLedgerSetup.VALIDATE("Global Dimension 1 Code",NewGlobalDimCode[1]);
      GeneralLedgerSetup.VALIDATE("Global Dimension 2 Code",NewGlobalDimCode[2]);
      GeneralLedgerSetup.MODIFY(TRUE);

      UpdateDimValues;
      COMMIT;
    END;

    LOCAL PROCEDURE InsertLogEntryWithNewDimCodes@48();
    VAR
      ChangeGlobalDimLogEntry@1000 : Record 483;
    BEGIN
      ChangeGlobalDimLogEntry.INIT;
      ChangeGlobalDimLogEntry."Table ID" := 0;
      ChangeGlobalDimLogEntry."Table Name" := STRSUBSTNO('%1;%2',NewGlobalDimCode[1],NewGlobalDimCode[2]);
      ChangeGlobalDimLogEntry.INSERT;
    END;

    LOCAL PROCEDURE RestoreNewDimCodes@43();
    VAR
      ChangeGlobalDimLogEntry@1000 : Record 483;
      NewDimCodes@1001 : Code[30];
      Pos@1002 : Integer;
    BEGIN
      ChangeGlobalDimLogEntry.GET(0);
      NewDimCodes := ChangeGlobalDimLogEntry."Table Name";
      Pos := STRPOS(NewDimCodes,';');
      SetNewGlobalDim1Code(COPYSTR(NewDimCodes,1,Pos - 1));
      SetNewGlobalDim2Code(COPYSTR(NewDimCodes,Pos + 1));
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
        IF NewGlobalDimCode[1] <> '' THEN BEGIN
          SETRANGE("Dimension Code",NewGlobalDimCode[1]);
          MODIFYALL("Global Dimension No.",1);
        END;
        IF NewGlobalDimCode[2] <> '' THEN BEGIN
          SETRANGE("Dimension Code",NewGlobalDimCode[2]);
          MODIFYALL("Global Dimension No.",2);
        END;
      END;
    END;

    LOCAL PROCEDURE ValidateDimCode@9(NewCode@1000 : Code[20];VAR Code@1001 : Code[20]);
    VAR
      Dimension@1002 : Record 348;
    BEGIN
      IF NewCode <> '' THEN BEGIN
        Dimension.GET(NewCode);
        IF IsUsedInShortcurDims(NewCode) THEN
          ERROR(DimIsUsedInGLSetupErr,NewCode);
      END;
      Code := NewCode;
    END;

    LOCAL PROCEDURE IsUsedInShortcurDims@17(DimensionCode@1000 : Code[20]) : Boolean;
    BEGIN
      EXIT(
        DimensionCode IN
        [GeneralLedgerSetup."Shortcut Dimension 3 Code",
         GeneralLedgerSetup."Shortcut Dimension 4 Code",
         GeneralLedgerSetup."Shortcut Dimension 5 Code",
         GeneralLedgerSetup."Shortcut Dimension 6 Code",
         GeneralLedgerSetup."Shortcut Dimension 7 Code",
         GeneralLedgerSetup."Shortcut Dimension 8 Code"]);
    END;

    PROCEDURE GetBindNotificationID@34() Id : GUID;
    BEGIN
      EVALUATE(Id,BindNotificationIDTok);
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

    LOCAL PROCEDURE SendBindNotification@35();
    VAR
      Notification@1000 : Notification;
    BEGIN
      PrepareNotification(Notification,GetBindNotificationID,BindNotificationMsg);
      Notification.SEND;
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

    [EventSubscriber(Codeunit,1,OnBeforeCompanyOpen)]
    LOCAL PROCEDURE OnBeforeCompanyOpenHandler@22();
    BEGIN
      ActivateBlock;
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeScheduleTask@29(TableNo@1002 : Integer;VAR DoNotScheduleTask@1000 : Boolean;VAR TaskID@1001 : GUID);
    BEGIN
    END;

    BEGIN
    END.
  }
}

