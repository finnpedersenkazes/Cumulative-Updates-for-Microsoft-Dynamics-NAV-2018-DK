OBJECT Codeunit 1511 Notification Lifecycle Mgt.
{
  OBJECT-PROPERTIES
  {
    Date=28-06-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23019;
  }
  PROPERTIES
  {
    SingleInstance=Yes;
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      TempNotificationContext@1000 : TEMPORARY Record 1519;
      NotificationSentCategoryTxt@1003 : TextConst '@@@={LOCKED};DAN=AL Notification Sent;ENU=AL Notification Sent';
      NotificationSentTelemetryMsg@1001 : TextConst '@@@={LOCKED};DAN="A notification was sent with message: %1 ";ENU="A notification was sent with message: %1 "';

    [Internal]
    PROCEDURE SendNotification@10(NotificationToSend@1000 : Notification;RecId@1002 : RecordID);
    VAR
      NullGuid@1001 : GUID;
    BEGIN
      NullGuid := '00000000-0000-0000-0000-000000000000';
      IF NotificationToSend.ID = NullGuid THEN
        NotificationToSend.ID := CREATEGUID;

      NotificationToSend.SEND;
      OnAfterNotificationSent(NotificationToSend);
      CreateNotificationContext(NotificationToSend.ID,RecId);
    END;

    [Internal]
    PROCEDURE SendNotificationWithAdditionalContext@13(NotificationToSend@1000 : Notification;RecId@1001 : RecordID;AdditionalContextId@1002 : GUID);
    VAR
      NullGuid@1003 : GUID;
    BEGIN
      NullGuid := '00000000-0000-0000-0000-000000000000';
      IF NotificationToSend.ID = NullGuid THEN
        NotificationToSend.ID := CREATEGUID;

      NotificationToSend.SEND;
      OnAfterNotificationSent(NotificationToSend);
      CreateNotificationContextWithAdditionalContext(NotificationToSend.ID,RecId,AdditionalContextId);
    END;

    [Internal]
    PROCEDURE RecallNotificationsForRecord@4(RecId@1000 : RecordID;HandleDelayedInsert@1002 : Boolean);
    VAR
      TempNotificationContextToRecall@1001 : TEMPORARY Record 1519;
    BEGIN
      IF GetNotificationsForRecord(RecId,TempNotificationContextToRecall,HandleDelayedInsert) THEN
        RecallNotifications(TempNotificationContextToRecall);
    END;

    [Internal]
    PROCEDURE RecallNotificationsForRecordWithAdditionalContext@9(RecId@1000 : RecordID;AdditionalContextId@1003 : GUID;HandleDelayedInsert@1002 : Boolean);
    VAR
      TempNotificationContextToRecall@1001 : TEMPORARY Record 1519;
    BEGIN
      IF GetNotificationsForRecordWithAdditionalContext(RecId,AdditionalContextId,TempNotificationContextToRecall,HandleDelayedInsert) THEN
        RecallNotifications(TempNotificationContextToRecall);
    END;

    [External]
    PROCEDURE RecallAllNotifications@8();
    BEGIN
      TempNotificationContext.RESET;
      IF TempNotificationContext.FINDFIRST THEN
        RecallNotifications(TempNotificationContext);
    END;

    [External]
    PROCEDURE GetTmpNotificationContext@15(VAR TempNotificationContextOut@1000 : TEMPORARY Record 1519);
    BEGIN
      TempNotificationContext.RESET;
      TempNotificationContextOut.COPY(TempNotificationContext,TRUE);
    END;

    [Internal]
    PROCEDURE SetRecordID@11(RecId@1000 : RecordID);
    VAR
      RecRef@1001 : RecordRef;
    BEGIN
      RecRef.OPEN(RecId.TABLENO);
      UpdateRecordIDHandleDelayedInsert(RecRef.RECORDID,RecId,FALSE);
    END;

    [TryFunction]
    LOCAL PROCEDURE TryFctThrowsErrorIfRecordExists@17(RecId@1000 : RecordID;VAR Exists@1002 : Boolean);
    VAR
      RecRef@1001 : RecordRef;
    BEGIN
      // If record exists, in some cases RecRef.GET(RecId) throws an error
      Exists := RecRef.GET(RecId);
    END;

    LOCAL PROCEDURE UpdateRecordIDHandleDelayedInsert@16(CurrentRecId@1000 : RecordID;NewRecId@1001 : RecordID;HandleDelayedInsert@1003 : Boolean);
    VAR
      TempNotificationContextToUpdate@1002 : TEMPORARY Record 1519;
      Exists@1004 : Boolean;
    BEGIN
      IF NOT TryFctThrowsErrorIfRecordExists(NewRecId,Exists) THEN
        Exists := TRUE;

      IF NOT Exists THEN
        EXIT;

      IF GetNotificationsForRecord(CurrentRecId,TempNotificationContextToUpdate,HandleDelayedInsert) THEN
        REPEAT
          TempNotificationContextToUpdate."Record ID" := NewRecId;
          TempNotificationContextToUpdate.MODIFY(TRUE);
        UNTIL TempNotificationContextToUpdate.NEXT = 0
    END;

    [Internal]
    PROCEDURE UpdateRecordID@3(CurrentRecId@1000 : RecordID;NewRecId@1001 : RecordID);
    BEGIN
      UpdateRecordIDHandleDelayedInsert(CurrentRecId,NewRecId,TRUE);
    END;

    [Internal]
    PROCEDURE GetNotificationsForRecord@2(RecId@1000 : RecordID;VAR TempNotificationContextOut@1001 : TEMPORARY Record 1519;HandleDelayedInsert@1003 : Boolean) : Boolean;
    BEGIN
      TempNotificationContext.RESET;
      GetUsableRecordId(RecId,HandleDelayedInsert);
      TempNotificationContext.SETRANGE("Record ID",RecId);
      TempNotificationContextOut.COPY(TempNotificationContext,TRUE);
      EXIT(TempNotificationContextOut.FINDSET);
    END;

    [Internal]
    PROCEDURE GetNotificationsForRecordWithAdditionalContext@5(RecId@1000 : RecordID;AdditionalContextId@1001 : GUID;VAR TempNotificationContextOut@1002 : TEMPORARY Record 1519;HandleDelayedInsert@1004 : Boolean) : Boolean;
    BEGIN
      TempNotificationContext.RESET;
      GetUsableRecordId(RecId,HandleDelayedInsert);
      TempNotificationContext.SETRANGE("Record ID",RecId);
      TempNotificationContext.SETRANGE("Additional Context ID",AdditionalContextId);
      TempNotificationContextOut.COPY(TempNotificationContext,TRUE);
      EXIT(TempNotificationContextOut.FINDSET);
    END;

    LOCAL PROCEDURE CreateNotificationContext@7(NotificationId@1000 : GUID;RecId@1001 : RecordID);
    BEGIN
      DeleteAlreadyRegisteredNotificationBeforeInsert(NotificationId);
      TempNotificationContext.INIT;
      TempNotificationContext."Notification ID" := NotificationId;
      GetUsableRecordId(RecId,TRUE);
      TempNotificationContext."Record ID" := RecId;
      TempNotificationContext.INSERT(TRUE);

      OnAfterInsertNotificationContext(TempNotificationContext);
    END;

    LOCAL PROCEDURE CreateNotificationContextWithAdditionalContext@1(NotificationId@1000 : GUID;RecId@1001 : RecordID;AdditionalContextId@1002 : GUID);
    BEGIN
      DeleteAlreadyRegisteredNotificationBeforeInsert(NotificationId);
      TempNotificationContext.INIT;
      TempNotificationContext."Notification ID" := NotificationId;
      GetUsableRecordId(RecId,TRUE);
      TempNotificationContext."Record ID" := RecId;
      TempNotificationContext."Additional Context ID" := AdditionalContextId;
      TempNotificationContext.INSERT(TRUE);

      OnAfterInsertNotificationContext(TempNotificationContext);
    END;

    LOCAL PROCEDURE DeleteAlreadyRegisteredNotificationBeforeInsert@26(NotificationId@1000 : GUID);
    BEGIN
      TempNotificationContext.RESET;
      TempNotificationContext.SETRANGE("Notification ID",NotificationId);
      IF TempNotificationContext.FINDFIRST THEN BEGIN
        TempNotificationContext.DELETE(TRUE);
        OnAfterDeleteNotificationContext(TempNotificationContext);
      END;
    END;

    LOCAL PROCEDURE RecallNotifications@6(VAR TempNotificationContextToRecall@1000 : TEMPORARY Record 1519);
    VAR
      NotificationToRecall@1001 : Notification;
    BEGIN
      REPEAT
        NotificationToRecall.ID := TempNotificationContextToRecall."Notification ID";
        NotificationToRecall.RECALL;

        TempNotificationContextToRecall.DELETE(TRUE);
        OnAfterDeleteNotificationContext(TempNotificationContextToRecall);
      UNTIL TempNotificationContextToRecall.NEXT = 0
    END;

    LOCAL PROCEDURE GetUsableRecordId@12(VAR RecId@1000 : RecordID;HandleDelayedInsert@1002 : Boolean);
    VAR
      RecRef@1001 : RecordRef;
    BEGIN
      IF NOT HandleDelayedInsert THEN
        EXIT;

      // Handle delayed insert
      IF NOT RecRef.GET(RecId) THEN BEGIN
        RecRef.OPEN(RecId.TABLENO);
        RecId := RecRef.RECORDID;
      END;
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterNotificationSent@18(CurrentNotification@1001 : Notification);
    BEGIN
    END;

    [EventSubscriber(Codeunit,1511,OnAfterNotificationSent,"",Skip,Skip)]
    LOCAL PROCEDURE LogNotificationSentSubscriber@14(CurrentNotification@1000 : Notification);
    BEGIN
      SENDTRACETAG('00001KO',NotificationSentCategoryTxt,VERBOSITY::Normal,
        STRSUBSTNO(NotificationSentTelemetryMsg,CurrentNotification.MESSAGE));
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterInsertNotificationContext@24(NotificationContext@1000 : Record 1519);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterDeleteNotificationContext@28(NotificationContext@1000 : Record 1519);
    BEGIN
    END;

    BEGIN
    END.
  }
}

