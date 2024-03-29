OBJECT Codeunit 9800 Log Table Permissions
{
  OBJECT-PROPERTIES
  {
    Date=25-05-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.22292;
  }
  PROPERTIES
  {
    SingleInstance=Yes;
    EventSubscriberInstance=Manual;
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      TempTablePermissionBuffer@1001 : TEMPORARY Record 9800;
      EventReceiver@1000 : DotNet "'Microsoft.Dynamics.Nav.EtwListener, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.EtwListener.NavPermissionEventReceiver" WITHEVENTS;

    [External]
    PROCEDURE Start@9();
    BEGIN
      TempTablePermissionBuffer.DELETEALL;
      IF ISNULL(EventReceiver) THEN
        EventReceiver := EventReceiver.NavPermissionEventReceiver(SESSIONID);

      EventReceiver.RegisterForEvents;
    END;

    [External]
    PROCEDURE Stop@12(VAR TempTablePermissionBufferVar@1001 : TEMPORARY Record 9800);
    BEGIN
      EventReceiver.UnregisterEvents;
      TempTablePermissionBufferVar.COPY(TempTablePermissionBuffer,TRUE)
    END;

    LOCAL PROCEDURE LogUsage@2(TypeOfObject@1004 : Option;ObjectId@1005 : Integer;Permissions@1006 : Integer;PermissionsFromCaller@1000 : Integer);
    BEGIN
      // Note: Do not start any write transactions inside this method and do not make
      // any commits. This code is invoked on permission checks - where there may be
      // no transaction.
      IF (ObjectId = DATABASE::"Table Permission Buffer") AND
         ((TypeOfObject = TempTablePermissionBuffer."Object Type"::Table) OR
          (TypeOfObject = TempTablePermissionBuffer."Object Type"::"Table Data") OR
          ((TypeOfObject = TempTablePermissionBuffer."Object Type"::Codeunit) AND (ObjectId = CODEUNIT::"Log Table Permissions")))
      THEN
        EXIT;

      IF NOT TempTablePermissionBuffer.GET(SESSIONID,TypeOfObject,ObjectId) THEN BEGIN
        TempTablePermissionBuffer.INIT;
        TempTablePermissionBuffer."Session ID" := SESSIONID;
        TempTablePermissionBuffer."Object Type" := TypeOfObject;
        TempTablePermissionBuffer."Object ID" := ObjectId;
        TempTablePermissionBuffer."Read Permission" := TempTablePermissionBuffer."Read Permission"::" ";
        TempTablePermissionBuffer."Insert Permission" := TempTablePermissionBuffer."Insert Permission"::" ";
        TempTablePermissionBuffer."Modify Permission" := TempTablePermissionBuffer."Modify Permission"::" ";
        TempTablePermissionBuffer."Delete Permission" := TempTablePermissionBuffer."Delete Permission"::" ";
        TempTablePermissionBuffer."Execute Permission" := TempTablePermissionBuffer."Execute Permission"::" ";
        TempTablePermissionBuffer.INSERT;
      END;

      TempTablePermissionBuffer."Object Type" := TypeOfObject;

      CASE SelectDirectOrIndirect(Permissions,PermissionsFromCaller) OF
        1:
          TempTablePermissionBuffer."Read Permission" :=
            GetMaxPermission(TempTablePermissionBuffer."Read Permission",TempTablePermissionBuffer."Read Permission"::Yes);
        32:
          TempTablePermissionBuffer."Read Permission" :=
            GetMaxPermission(TempTablePermissionBuffer."Read Permission",TempTablePermissionBuffer."Read Permission"::Indirect);
        2:
          TempTablePermissionBuffer."Insert Permission" :=
            GetMaxPermission(TempTablePermissionBuffer."Insert Permission",TempTablePermissionBuffer."Insert Permission"::Yes);
        64:
          TempTablePermissionBuffer."Insert Permission" :=
            GetMaxPermission(TempTablePermissionBuffer."Insert Permission",TempTablePermissionBuffer."Insert Permission"::Indirect);
        4:
          TempTablePermissionBuffer."Modify Permission" :=
            GetMaxPermission(TempTablePermissionBuffer."Modify Permission",TempTablePermissionBuffer."Modify Permission"::Yes);
        128:
          TempTablePermissionBuffer."Modify Permission" :=
            GetMaxPermission(TempTablePermissionBuffer."Modify Permission",TempTablePermissionBuffer."Modify Permission"::Indirect);
        8:
          TempTablePermissionBuffer."Delete Permission" :=
            GetMaxPermission(TempTablePermissionBuffer."Delete Permission",TempTablePermissionBuffer."Delete Permission"::Yes);
        256:
          TempTablePermissionBuffer."Delete Permission" :=
            GetMaxPermission(TempTablePermissionBuffer."Delete Permission",TempTablePermissionBuffer."Delete Permission"::Indirect);
        16:
          TempTablePermissionBuffer."Execute Permission" :=
            GetMaxPermission(TempTablePermissionBuffer."Execute Permission",TempTablePermissionBuffer."Execute Permission"::Yes);
        512:
          TempTablePermissionBuffer."Execute Permission" :=
            GetMaxPermission(TempTablePermissionBuffer."Execute Permission",TempTablePermissionBuffer."Execute Permission"::Indirect);
      END;
      TempTablePermissionBuffer.MODIFY;
    END;

    [External]
    PROCEDURE GetMaxPermission@1(CurrentPermission@1000 : Option;NewPermission@1001 : Option) : Integer;
    VAR
      Permission@1002 : Record 2000000005;
    BEGIN
      IF (CurrentPermission = Permission."Read Permission"::Indirect) AND (NewPermission = Permission."Read Permission"::Indirect) THEN
        EXIT(Permission."Read Permission"::Indirect);
      IF CurrentPermission = Permission."Read Permission"::" " THEN
        EXIT(NewPermission);
      EXIT(CurrentPermission);
    END;

    LOCAL PROCEDURE SelectDirectOrIndirect@3(DirectPermission@1000 : Integer;IndirectPermission@1001 : Integer) : Integer;
    BEGIN
      IF IndirectPermission = 0 THEN
        EXIT(DirectPermission);
      EXIT(IndirectPermission);
    END;

    EVENT EventReceiver@1000::OnPermissionCheckEvent@9(sender@1001 : Variant;e@1000 : DotNet "'Microsoft.Dynamics.Nav.EtwListener, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.EtwListener.PermissionCheckEventArgs");
    BEGIN
      CASE e.EventId OF
        801:
          CASE e.ValidationCategory OF
            EventReceiver.NormalValidationCategoryId,
            EventReceiver.ReadPermissionValidationCategoryId,
            EventReceiver.WritePermissionValidationCategoryId:
              LogUsage(e.ObjectType,e.ObjectId,e.Permissions,e.IndirectPermissionsFromCaller);
          END;
      END;
    END;

    BEGIN
    END.
  }
}

