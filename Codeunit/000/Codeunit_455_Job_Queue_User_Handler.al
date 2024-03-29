OBJECT Codeunit 455 Job Queue User Handler
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    OnRun=BEGIN
            RescheduleJobQueueEntries;
          END;

  }
  CODE
  {

    LOCAL PROCEDURE RescheduleJobQueueEntries@5();
    VAR
      JobQueueEntry@1001 : Record 472;
    BEGIN
      JobQueueEntry.SETFILTER(
        Status,'<>%1&<>%2&<>%3',
        JobQueueEntry.Status::"On Hold",JobQueueEntry.Status::Finished,JobQueueEntry.Status::"On Hold with Inactivity Timeout");
      JobQueueEntry.SETRANGE("Recurring Job",TRUE);
      IF JobQueueEntry.FINDSET(TRUE) THEN
        REPEAT
          IF JobShouldBeRescheduled(JobQueueEntry) THEN
            JobQueueEntry.Restart;
        UNTIL JobQueueEntry.NEXT = 0;

      JobQueueEntry.FilterInactiveOnHoldEntries;
      IF JobQueueEntry.FINDSET(TRUE) THEN
        REPEAT
          IF JobQueueEntry.DoesJobNeedToBeRun THEN
            JobQueueEntry.Restart;
        UNTIL JobQueueEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE JobShouldBeRescheduled@3(JobQueueEntry@1000 : Record 472) : Boolean;
    VAR
      User@1001 : Record 2000000120;
    BEGIN
      IF JobQueueEntry."User ID" = USERID THEN BEGIN
        JobQueueEntry.CALCFIELDS(Scheduled);
        EXIT(NOT JobQueueEntry.Scheduled);
      END;
      User.SETRANGE("User Name",JobQueueEntry."User ID");
      EXIT(User.ISEMPTY);
    END;

    [EventSubscriber(Codeunit,1,OnAfterCompanyOpen,"",Skip,Skip)]
    LOCAL PROCEDURE RescheduleJobQueueEntriesOnCompanyOpen@1();
    VAR
      JobQueueEntry@1001 : Record 472;
      User@1000 : Record 2000000120;
    BEGIN
      IF NOT GUIALLOWED THEN
        EXIT;
      IF NOT (JobQueueEntry.WRITEPERMISSION AND JobQueueEntry.READPERMISSION) THEN
        EXIT;
      IF NOT TASKSCHEDULER.CANCREATETASK THEN
        EXIT;
      IF NOT User.GET(USERSECURITYID) THEN
        EXIT;
      IF User."License Type" = User."License Type"::"Limited User" THEN
        EXIT;

      TASKSCHEDULER.CREATETASK(CODEUNIT::"Job Queue User Handler",0,TRUE,COMPANYNAME,CURRENTDATETIME + 15000); // Add 15s
    END;

    BEGIN
    END.
  }
}

