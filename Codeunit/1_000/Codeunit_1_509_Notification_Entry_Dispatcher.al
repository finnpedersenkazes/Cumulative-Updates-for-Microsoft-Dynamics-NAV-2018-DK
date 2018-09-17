OBJECT Codeunit 1509 Notification Entry Dispatcher
{
  OBJECT-PROPERTIES
  {
    Date=28-06-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23019;
  }
  PROPERTIES
  {
    TableNo=472;
    Permissions=TableData 91=r,
                TableData 1511=rimd,
                TableData 1514=rimd,
                TableData 9500=rimd;
    OnRun=BEGIN
            IF "Parameter String" = '' THEN
              DispatchInstantNotifications
            ELSE
              DispatchNotificationTypeForUser("Parameter String");
          END;

  }
  CODE
  {
    VAR
      NotificationManagement@1002 : Codeunit 1510;
      NotificationMailSubjectTxt@1000 : TextConst 'DAN=Notifikationsoversigt;ENU=Notification overview';
      HtmlBodyFilePath@1001 : Text;

    LOCAL PROCEDURE DispatchInstantNotifications@2();
    VAR
      UserSetup@1000 : Record 91;
      UserIDsbyNotificationType@1001 : Query 1511;
      UserIdWithError@1002 : Code[50];
    BEGIN
      UserIDsbyNotificationType.OPEN;
      WHILE UserIDsbyNotificationType.READ DO
        IF NOT UserSetup.GET(UserIDsbyNotificationType.Recipient_User_ID) THEN
          UserIdWithError := UserIDsbyNotificationType.Recipient_User_ID
        ELSE
          IF ScheduledInstantly(UserSetup."User ID",UserIDsbyNotificationType.Type) THEN
            DispatchForNotificationType(UserIDsbyNotificationType.Type,UserSetup);

      COMMIT;

      IF UserIdWithError <> '' THEN
        UserSetup.GET(UserIdWithError);
    END;

    LOCAL PROCEDURE DispatchNotificationTypeForUser@5(Parameter@1003 : Text);
    VAR
      UserSetup@1000 : Record 91;
      NotificationEntry@1001 : Record 1511;
    BEGIN
      NotificationEntry.SETVIEW(Parameter);
      UserSetup.GET(NotificationEntry.GETRANGEMAX("Recipient User ID"));
      DispatchForNotificationType(NotificationEntry.GETRANGEMAX(Type),UserSetup);
    END;

    LOCAL PROCEDURE DispatchForNotificationType@30(NotificationType@1007 : 'New Record,Approval,Overdue';UserSetup@1000 : Record 91);
    VAR
      NotificationEntry@1002 : Record 1511;
      NotificationSetup@1004 : Record 1512;
    BEGIN
      NotificationEntry.SETRANGE("Recipient User ID",UserSetup."User ID");
      NotificationEntry.SETRANGE(Type,NotificationType);

      DeleteOutdatedApprovalNotificationEntires(NotificationEntry);

      IF NOT NotificationEntry.FINDFIRST THEN
        EXIT;

      FilterToActiveNotificationEntries(NotificationEntry);

      NotificationSetup.GetNotificationSetupForUser(NotificationType,NotificationEntry."Recipient User ID");

      CASE NotificationSetup."Notification Method" OF
        NotificationSetup."Notification Method"::Email:
          CreateMailAndDispatch(NotificationEntry,UserSetup."E-Mail");
        NotificationSetup."Notification Method"::Note:
          CreateNoteAndDispatch(NotificationEntry);
      END;
    END;

    LOCAL PROCEDURE ScheduledInstantly@3(RecipientUserID@1000 : Code[50];NotificationType@1002 : Option) : Boolean;
    VAR
      NotificationSchedule@1001 : Record 1513;
    BEGIN
      IF NOT NotificationSchedule.GET(RecipientUserID,NotificationType) THEN
        EXIT(TRUE); // No rules are set up, send immediately

      EXIT(NotificationSchedule.Recurrence = NotificationSchedule.Recurrence::Instantly);
    END;

    LOCAL PROCEDURE CreateMailAndDispatch@13(VAR NotificationEntry@1005 : Record 1511;Email@1003 : Text);
    VAR
      NotificationSetup@1004 : Record 1512;
      DocumentMailing@1002 : Codeunit 260;
      BodyText@1007 : Text;
    BEGIN
      IF GetHTMLBodyText(NotificationEntry,BodyText) THEN
        IF DocumentMailing.EmailFileWithSubject('','',HtmlBodyFilePath,NotificationMailSubjectTxt,Email,TRUE) THEN
          NotificationManagement.MoveNotificationEntryToSentNotificationEntries(
            NotificationEntry,BodyText,TRUE,NotificationSetup."Notification Method"::Email)
        ELSE BEGIN
          NotificationEntry.SetErrorMessage(GETLASTERRORTEXT);
          CLEARLASTERROR;
          NotificationEntry.MODIFY(TRUE);
        END;
    END;

    LOCAL PROCEDURE CreateNoteAndDispatch@8(VAR NotificationEntry@1003 : Record 1511);
    VAR
      NotificationSetup@1001 : Record 1512;
      BodyText@1000 : Text;
    BEGIN
      REPEAT
        IF AddNote(NotificationEntry,BodyText) THEN
          NotificationManagement.MoveNotificationEntryToSentNotificationEntries(
            NotificationEntry,BodyText,FALSE,
            NotificationSetup."Notification Method"::Note);
      UNTIL NotificationEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE AddNote@6(VAR NotificationEntry@1008 : Record 1511;VAR Body@1002 : Text) : Boolean;
    VAR
      RecordLink@1001 : Record 2000000068;
      PageManagement@1005 : Codeunit 700;
      TypeHelper@1004 : Codeunit 10;
      RecRefLink@1003 : RecordRef;
      Link@1000 : Text;
    BEGIN
      WITH RecordLink DO BEGIN
        INIT;
        "Link ID" := 0;
        GetTargetRecRef(NotificationEntry,RecRefLink);
        IF NOT RecRefLink.HASFILTER THEN
          RecRefLink.SETRECFILTER;
        "Record ID" := RecRefLink.RECORDID;
        Link := GETURL(DEFAULTCLIENTTYPE,COMPANYNAME,OBJECTTYPE::Page,PageManagement.GetPageID(RecRefLink),RecRefLink,TRUE);
        URL1 := COPYSTR(Link,1,MAXSTRLEN(URL1));
        IF STRLEN(Link) > MAXSTRLEN(URL1) THEN
          URL2 := COPYSTR(Link,MAXSTRLEN(URL1) + 1,MAXSTRLEN(URL2));
        Description := COPYSTR(FORMAT(NotificationEntry."Triggered By Record"),1,250);
        Type := Type::Note;
        CreateNoteBody(NotificationEntry,Body);
        TypeHelper.WriteRecordLinkNote(RecordLink,Body);
        Created := CURRENTDATETIME;
        "User ID" := NotificationEntry."Created By";
        Company := COMPANYNAME;
        Notify := TRUE;
        "To User ID" := NotificationEntry."Recipient User ID";
        EXIT(INSERT(TRUE));
      END;

      EXIT(FALSE);
    END;

    LOCAL PROCEDURE FilterToActiveNotificationEntries@22(VAR NotificationEntry@1000 : Record 1511);
    BEGIN
      REPEAT
        NotificationEntry.MARK(TRUE);
      UNTIL NotificationEntry.NEXT = 0;
      NotificationEntry.MARKEDONLY(TRUE);
      NotificationEntry.FINDSET;
    END;

    LOCAL PROCEDURE ConvertHtmlFileToText@17(HtmlBodyFilePath@1000 : Text;VAR BodyText@1001 : Text);
    VAR
      TempBlob@1002 : TEMPORARY Record 99008535;
      FileManagement@1003 : Codeunit 419;
      BlobInStream@1004 : InStream;
    BEGIN
      TempBlob.INIT;
      FileManagement.BLOBImportFromServerFile(TempBlob,HtmlBodyFilePath);
      TempBlob.Blob.CREATEINSTREAM(BlobInStream);
      BlobInStream.READTEXT(BodyText);
    END;

    LOCAL PROCEDURE CreateNoteBody@28(VAR NotificationEntry@1000 : Record 1511;VAR Body@1001 : Text);
    VAR
      RecRef@1004 : RecordRef;
      DocumentType@1002 : Text;
      DocumentNo@1003 : Text;
      DocumentName@1006 : Text;
      ActionText@1007 : Text;
    BEGIN
      GetTargetRecRef(NotificationEntry,RecRef);
      NotificationManagement.GetDocumentTypeAndNumber(RecRef,DocumentType,DocumentNo);
      DocumentName := DocumentType + ' ' + DocumentNo;
      ActionText := NotificationManagement.GetActionTextFor(NotificationEntry);
      Body := DocumentName + ' ' + ActionText;
    END;

    [Internal]
    PROCEDURE GetHTMLBodyText@11(VAR NotificationEntry@1001 : Record 1511;VAR BodyTextOut@1003 : Text) : Boolean;
    VAR
      ReportLayoutSelection@1000 : Record 9651;
      FileManagement@1002 : Codeunit 419;
    BEGIN
      HtmlBodyFilePath := FileManagement.ServerTempFileName('html');
      ReportLayoutSelection.SetTempLayoutSelected('');
      IF NOT REPORT.SAVEASHTML(REPORT::"Notification Email",HtmlBodyFilePath,NotificationEntry) THEN BEGIN
        NotificationEntry.SetErrorMessage(GETLASTERRORTEXT);
        CLEARLASTERROR;
        NotificationEntry.MODIFY(TRUE);
        EXIT(FALSE);
      END;

      ConvertHtmlFileToText(HtmlBodyFilePath,BodyTextOut);
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE GetTargetRecRef@4(VAR NotificationEntry@1004 : Record 1511;VAR TargetRecRefOut@1001 : RecordRef);
    VAR
      ApprovalEntry@1003 : Record 454;
      OverdueApprovalEntry@1000 : Record 458;
      DataTypeManagement@1005 : Codeunit 701;
      RecRef@1002 : RecordRef;
    BEGIN
      DataTypeManagement.GetRecordRef(NotificationEntry."Triggered By Record",RecRef);

      CASE NotificationEntry.Type OF
        NotificationEntry.Type::"New Record":
          TargetRecRefOut := RecRef;
        NotificationEntry.Type::Approval:
          BEGIN
            RecRef.SETTABLE(ApprovalEntry);
            TargetRecRefOut.GET(ApprovalEntry."Record ID to Approve");
          END;
        NotificationEntry.Type::Overdue:
          BEGIN
            RecRef.SETTABLE(OverdueApprovalEntry);
            TargetRecRefOut.GET(OverdueApprovalEntry."Record ID to Approve");
          END;
      END;
    END;

    LOCAL PROCEDURE DeleteOutdatedApprovalNotificationEntires@1(VAR NotificationEntry@1000 : Record 1511);
    BEGIN
      IF NotificationEntry.FINDFIRST THEN
        REPEAT
          IF ApprovalNotificationEntryIsOutdated(NotificationEntry) THEN
            NotificationEntry.DELETE;
        UNTIL NotificationEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE ApprovalNotificationEntryIsOutdated@9(VAR NotificationEntry@1000 : Record 1511) : Boolean;
    VAR
      ApprovalEntry@1003 : Record 454;
      OverdueApprovalEntry@1002 : Record 458;
      DataTypeManagement@1004 : Codeunit 701;
      RecRef@1001 : RecordRef;
    BEGIN
      DataTypeManagement.GetRecordRef(NotificationEntry."Triggered By Record",RecRef);

      CASE NotificationEntry.Type OF
        NotificationEntry.Type::Approval:
          BEGIN
            RecRef.SETTABLE(ApprovalEntry);
            IF NOT RecRef.GET(ApprovalEntry."Record ID to Approve") THEN
              EXIT(TRUE);
          END;
        NotificationEntry.Type::Overdue:
          BEGIN
            RecRef.SETTABLE(OverdueApprovalEntry);
            IF NOT RecRef.GET(OverdueApprovalEntry."Record ID to Approve") THEN
              EXIT(TRUE);
          END;
      END;
    END;

    BEGIN
    END.
  }
}

