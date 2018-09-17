OBJECT Codeunit 448 Job Queue Dispatcher
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    TableNo=472;
    Permissions=TableData 472=rimd;
    OnRun=BEGIN
            SELECTLATESTVERSION;
            GET(ID);
            IF IsReadyToStart THEN
              IF IsExpired(CURRENTDATETIME) THEN
                DeleteTask
              ELSE
                IF WaitForOthersWithSameCategory(Rec) THEN
                  Reschedule(Rec)
                ELSE BEGIN
                  RefreshLocked;
                  IF NOT IsReadyToStart THEN
                    EXIT;
                  HandleRequest(Rec);
                END;
            COMMIT;
          END;

  }
  CODE
  {
    VAR
      TypeHelper@1000 : Codeunit 10;

    LOCAL PROCEDURE HandleRequest@6(VAR JobQueueEntry@1000 : Record 472);
    VAR
      JobQueueLogEntry@1003 : Record 474;
      WasSuccess@1002 : Boolean;
      WasInactive@1001 : Boolean;
    BEGIN
      WITH JobQueueEntry DO BEGIN
        IF Status = Status::Ready THEN BEGIN
          Status := Status::"In Process";
          "User Session Started" := CURRENTDATETIME;
          MODIFY;
        END;
        InsertLogEntry(JobQueueLogEntry);

        // Codeunit.Run is limited during write transactions because one or more tables will be locked.
        // To avoid NavCSideException we have either to add the COMMIT before the call or do not use a returned value.
        COMMIT;
        WasSuccess := CODEUNIT.RUN(CODEUNIT::"Job Queue Start Codeunit",JobQueueEntry);
        WasInactive := "On Hold Due to Inactivity";

        // user may have deleted it in the meantime
        IF DoesExistLocked THEN
          SetResult(WasSuccess,WasInactive)
        ELSE
          SetResultDeletedEntry;
        COMMIT;
        FinalizeLogEntry(JobQueueLogEntry);

        IF DoesExistLocked THEN
          FinalizeRun;
      END;
    END;

    LOCAL PROCEDURE WaitForOthersWithSameCategory@9(VAR CurrJobQueueEntry@1000 : Record 472) : Boolean;
    VAR
      JobQueueEntry@1001 : Record 472;
    BEGIN
      IF CurrJobQueueEntry."Job Queue Category Code" = '' THEN
        EXIT(FALSE);

      WITH JobQueueEntry DO BEGIN
        SETFILTER(ID,'<>%1',CurrJobQueueEntry.ID);
        SETRANGE("Job Queue Category Code",CurrJobQueueEntry."Job Queue Category Code");
        SETFILTER(Status,'%1|%2',Status::"In Process",Status::Ready);
        SETFILTER("Earliest Start Date/Time",'<%1',CURRENTDATETIME + 500); // already started or imminent start
        EXIT(NOT ISEMPTY);
      END;
    END;

    LOCAL PROCEDURE Reschedule@15(VAR JobQueueEntry@1000 : Record 472);
    BEGIN
      WITH JobQueueEntry DO BEGIN
        RANDOMIZE;
        CLEAR("System Task ID"); // to avoid canceling this task, which has already been executed
        "Earliest Start Date/Time" := CURRENTDATETIME + 2000 + RANDOM(5000);
        CODEUNIT.RUN(CODEUNIT::"Job Queue - Enqueue",JobQueueEntry);
      END;
    END;

    [External]
    PROCEDURE CalcNextRunTimeForRecurringJob@1(VAR JobQueueEntry@1000 : Record 472;StartingDateTime@1008 : DateTime) : DateTime;
    VAR
      NewRunDateTime@1002 : DateTime;
    BEGIN
      IF JobQueueEntry."No. of Minutes between Runs" > 0 THEN
        NewRunDateTime := TypeHelper.AddMinutesToDateTime(StartingDateTime,JobQueueEntry."No. of Minutes between Runs")
      ELSE BEGIN
        IF JobQueueEntry."Earliest Start Date/Time" <> 0DT THEN
          StartingDateTime := JobQueueEntry."Earliest Start Date/Time";
        NewRunDateTime := CREATEDATETIME(DT2DATE(StartingDateTime) + 1,0T);
      END;

      EXIT(CalcRunTimeForRecurringJob(JobQueueEntry,NewRunDateTime));
    END;

    [External]
    PROCEDURE CalcInitialRunTime@4(VAR JobQueueEntry@1000 : Record 472;StartingDateTime@1008 : DateTime) : DateTime;
    VAR
      EarliestPossibleRunTime@1001 : DateTime;
    BEGIN
      IF (JobQueueEntry."Earliest Start Date/Time" <> 0DT) AND (JobQueueEntry."Earliest Start Date/Time" > StartingDateTime) THEN
        EarliestPossibleRunTime := JobQueueEntry."Earliest Start Date/Time"
      ELSE
        EarliestPossibleRunTime := StartingDateTime;

      IF JobQueueEntry."Recurring Job" THEN
        EXIT(CalcRunTimeForRecurringJob(JobQueueEntry,EarliestPossibleRunTime));

      EXIT(EarliestPossibleRunTime);
    END;

    LOCAL PROCEDURE CalcRunTimeForRecurringJob@11(VAR JobQueueEntry@1000 : Record 472;StartingDateTime@1008 : DateTime) : DateTime;
    VAR
      NewRunDateTime@1001 : DateTime;
      RunOnDate@1003 : ARRAY [7] OF Boolean;
      StartingWeekDay@1005 : Integer;
      NoOfExtraDays@1004 : Integer;
      NoOfDays@1007 : Integer;
      Found@1006 : Boolean;
    BEGIN
      WITH JobQueueEntry DO BEGIN
        TESTFIELD("Recurring Job");
        RunOnDate[1] := "Run on Mondays";
        RunOnDate[2] := "Run on Tuesdays";
        RunOnDate[3] := "Run on Wednesdays";
        RunOnDate[4] := "Run on Thursdays";
        RunOnDate[5] := "Run on Fridays";
        RunOnDate[6] := "Run on Saturdays";
        RunOnDate[7] := "Run on Sundays";

        NewRunDateTime := StartingDateTime;
        NoOfDays := 0;
        IF ("Ending Time" <> 0T) AND (NewRunDateTime > GetEndingDateTime(NewRunDateTime)) THEN BEGIN
          NewRunDateTime := GetStartingDateTime(NewRunDateTime);
          NoOfDays := NoOfDays + 1;
        END;

        StartingWeekDay := DATE2DWY(DT2DATE(StartingDateTime),1);
        Found := RunOnDate[(StartingWeekDay - 1 + NoOfDays) MOD 7 + 1];
        WHILE NOT Found AND (NoOfExtraDays < 7) DO BEGIN
          NoOfExtraDays := NoOfExtraDays + 1;
          NoOfDays := NoOfDays + 1;
          Found := RunOnDate[(StartingWeekDay - 1 + NoOfDays) MOD 7 + 1];
        END;

        IF ("Starting Time" <> 0T) AND (NewRunDateTime < GetStartingDateTime(NewRunDateTime)) THEN
          NewRunDateTime := GetStartingDateTime(NewRunDateTime);

        IF (NoOfDays > 0) AND (NewRunDateTime > GetStartingDateTime(NewRunDateTime)) THEN
          NewRunDateTime := GetStartingDateTime(NewRunDateTime);

        IF ("Starting Time" = 0T) AND (NoOfExtraDays > 0) AND ("No. of Minutes between Runs" <> 0) THEN
          NewRunDateTime := CREATEDATETIME(DT2DATE(NewRunDateTime),0T);

        IF Found THEN
          NewRunDateTime := CREATEDATETIME(DT2DATE(NewRunDateTime) + NoOfDays,DT2TIME(NewRunDateTime));
      END;
      EXIT(NewRunDateTime);
    END;

    BEGIN
    END.
  }
}

