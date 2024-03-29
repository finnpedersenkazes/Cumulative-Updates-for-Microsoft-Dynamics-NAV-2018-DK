OBJECT Codeunit 485 Change Global Dim Err. Handler
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
    OnRun=BEGIN
            LOCKTABLE;
            IF NOT GET("Table ID") THEN
              EXIT;
            UpdateStatus;
            MODIFY;
            LogError(Rec);
          END;

  }
  CODE
  {

    LOCAL PROCEDURE LogError@1(ChangeGlobalDimLogEntry@1000 : Record 483);
    VAR
      JobQueueLogEntry@1002 : Record 474;
    BEGIN
      JobQueueLogEntry.INIT;
      JobQueueLogEntry."Entry No." := 0;
      JobQueueLogEntry.ID := ChangeGlobalDimLogEntry."Task ID";
      JobQueueLogEntry."Object Type to Run" := JobQueueLogEntry."Object Type to Run"::Codeunit;
      JobQueueLogEntry."Object ID to Run" := CODEUNIT::"Change Global Dimensions";
      JobQueueLogEntry.Description := ChangeGlobalDimLogEntry."Table Name";
      JobQueueLogEntry.Status := JobQueueLogEntry.Status::Error;
      JobQueueLogEntry.SetErrorMessage(GETLASTERRORTEXT);
      JobQueueLogEntry."Start Date/Time" := CURRENTDATETIME;
      JobQueueLogEntry."End Date/Time" := JobQueueLogEntry."Start Date/Time";
      JobQueueLogEntry."User ID" := USERID;
      JobQueueLogEntry."Processed by User ID" := USERID;
      JobQueueLogEntry.INSERT(TRUE);
    END;

    BEGIN
    END.
  }
}

