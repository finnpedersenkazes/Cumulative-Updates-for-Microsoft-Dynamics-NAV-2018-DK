OBJECT Codeunit 453 Job Queue - Enqueue
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    TableNo=472;
    Permissions=TableData 472=rimd;
    OnRun=BEGIN
            EnqueueJobQueueEntry(Rec);
          END;

  }
  CODE
  {

    LOCAL PROCEDURE EnqueueJobQueueEntry@4(VAR JobQueueEntry@1000 : Record 472);
    VAR
      SavedStatus@1001 : Option;
    BEGIN
      WITH JobQueueEntry DO BEGIN
        SavedStatus := Status;
        InitEntryForSchedulerWithDelayInSec(JobQueueEntry,1);
        IF ISNULLGUID(ID) THEN
          INSERT(TRUE)
        ELSE BEGIN
          IF CanScheduleTask(JobQueueEntry) THEN
            CancelTask; // clears "System Task ID"
          MODIFY;
        END;

        IF CanScheduleTask(JobQueueEntry) AND NOT UpdateStatusOnHoldWithInactivityTimeout(JobQueueEntry,SavedStatus) THEN
          "System Task ID" := ScheduleTask;

        IF NOT ISNULLGUID("System Task ID") THEN BEGIN
          IF SavedStatus = Status::"On Hold with Inactivity Timeout" THEN
            Status := SavedStatus
          ELSE
            Status := Status::Ready;
          MODIFY;
        END;
      END;
    END;

    LOCAL PROCEDURE InitEntryForSchedulerWithDelayInSec@3(VAR JobQueueEntry@1001 : Record 472;DelayInSec@1000 : Integer);
    BEGIN
      WITH JobQueueEntry DO BEGIN
        Status := Status::"On Hold";
        "User Session Started" := 0DT;
        IF "Earliest Start Date/Time" < (CURRENTDATETIME + 1000) THEN
          "Earliest Start Date/Time" := CURRENTDATETIME + DelayInSec * 1000;
      END;
    END;

    LOCAL PROCEDURE UpdateStatusOnHoldWithInactivityTimeout@1(VAR JobQueueEntry@1000 : Record 472;SavedStatus@1001 : Integer) : Boolean;
    BEGIN
      WITH JobQueueEntry DO
        IF (SavedStatus = Status::"On Hold with Inactivity Timeout") AND ("Inactivity Timeout Period" = 0) THEN BEGIN
          IF Status <> Status::"On Hold with Inactivity Timeout" THEN BEGIN
            Status := Status::"On Hold with Inactivity Timeout";
            MODIFY;
          END;
          EXIT(TRUE);
        END;

      EXIT(FALSE);
    END;

    LOCAL PROCEDURE CanScheduleTask@5(VAR JobQueueEntry@1001 : Record 472) : Boolean;
    VAR
      DoNotScheduleTask@1000 : Boolean;
    BEGIN
      OnBeforeJobQueueScheduleTask(JobQueueEntry,DoNotScheduleTask);
      EXIT(NOT DoNotScheduleTask);
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnBeforeJobQueueScheduleTask@2(VAR JobQueueEntry@1001 : Record 472;VAR DoNotScheduleTask@1000 : Boolean);
    BEGIN
    END;

    BEGIN
    END.
  }
}

