OBJECT Codeunit 484 Change Global Dim. Log Mgt.
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    EventSubscriberInstance=Manual;
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      TempChangeGlobalDimLogEntry@1000 : TEMPORARY Record 483;

    [External]
    PROCEDURE AreAllCompleted@1() : Boolean;
    BEGIN
      TempChangeGlobalDimLogEntry.RESET;
      TempChangeGlobalDimLogEntry.SETFILTER(Status,'<>%1',TempChangeGlobalDimLogEntry.Status::Completed);
      EXIT(TempChangeGlobalDimLogEntry.ISEMPTY);
    END;

    [External]
    PROCEDURE ClearBuffer@30();
    BEGIN
      TempChangeGlobalDimLogEntry.RESET;
      TempChangeGlobalDimLogEntry.DELETEALL;
    END;

    [External]
    PROCEDURE IsBufferClear@3() : Boolean;
    BEGIN
      TempChangeGlobalDimLogEntry.RESET;
      EXIT(TempChangeGlobalDimLogEntry.ISEMPTY);
    END;

    [External]
    PROCEDURE IsStarted@32() : Boolean;
    BEGIN
      TempChangeGlobalDimLogEntry.RESET;
      TempChangeGlobalDimLogEntry.SETFILTER(Status,'<>%1',TempChangeGlobalDimLogEntry.Status::" ");
      EXIT(NOT TempChangeGlobalDimLogEntry.ISEMPTY);
    END;

    [External]
    PROCEDURE ExcludeTable@4(TableId@1000 : Integer);
    BEGIN
      IF TempChangeGlobalDimLogEntry.GET(TableId) THEN
        TempChangeGlobalDimLogEntry.DELETE;
      IF AreAllCompleted THEN
        ClearBuffer;
    END;

    [External]
    PROCEDURE FindChildTable@8(ParentTableID@1000 : Integer) : Integer;
    VAR
      TempChildChangeGlobalDimLogEntry@1001 : TEMPORARY Record 483;
    BEGIN
      TempChildChangeGlobalDimLogEntry.COPY(TempChangeGlobalDimLogEntry,TRUE);
      TempChildChangeGlobalDimLogEntry.SETRANGE("Parent Table ID",ParentTableID);
      IF TempChildChangeGlobalDimLogEntry.FINDFIRST THEN
        EXIT(TempChildChangeGlobalDimLogEntry."Table ID");
    END;

    [External]
    PROCEDURE FillBuffer@38() : Boolean;
    VAR
      ChangeGlobalDimLogEntry@1000 : Record 483;
    BEGIN
      ClearBuffer;
      IF ChangeGlobalDimLogEntry.ISEMPTY THEN
        EXIT(FALSE);
      ChangeGlobalDimLogEntry.FINDSET;
      REPEAT
        TempChangeGlobalDimLogEntry := ChangeGlobalDimLogEntry;
        TempChangeGlobalDimLogEntry.INSERT;
      UNTIL ChangeGlobalDimLogEntry.NEXT = 0;
      TempChangeGlobalDimLogEntry.SETRANGE("Total Records",0);
      TempChangeGlobalDimLogEntry.DELETEALL;
      EXIT(NOT IsBufferClear);
    END;

    [EventSubscriber(Codeunit,5150,OnGetIntegrationDisabled)]
    LOCAL PROCEDURE OnGetIntegrationDisabledHandler@5(VAR IsSyncDisabled@1000 : Boolean);
    BEGIN
      IsSyncDisabled := TRUE
    END;

    BEGIN
    END.
  }
}

