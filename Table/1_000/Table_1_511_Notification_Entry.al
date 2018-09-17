OBJECT Table 1511 Notification Entry
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               "Created Date-Time" := ROUNDDATETIME(CURRENTDATETIME,60000);
               "Created By" := USERID;
             END;

    CaptionML=[DAN=Notifikationspost;
               ENU=Notification Entry];
  }
  FIELDS
  {
    { 1   ;   ;ID                  ;Integer       ;AutoIncrement=Yes;
                                                   CaptionML=[DAN=Id;
                                                              ENU=ID] }
    { 3   ;   ;Type                ;Option        ;CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=Ny record,Godkendelse,Forfald;
                                                                    ENU=New Record,Approval,Overdue];
                                                   OptionString=New Record,Approval,Overdue }
    { 4   ;   ;Recipient User ID   ;Code50        ;TableRelation="User Setup"."User ID";
                                                   ValidateTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Modtagers bruger-id;
                                                              ENU=Recipient User ID] }
    { 5   ;   ;Triggered By Record ;RecordID      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Udl›st af record;
                                                              ENU=Triggered By Record] }
    { 6   ;   ;Link Target Page    ;Integer       ;TableRelation="Page Metadata".ID;
                                                   CaptionML=[DAN=Side, der linkes til;
                                                              ENU=Link Target Page] }
    { 7   ;   ;Custom Link         ;Text250       ;ExtendedDatatype=URL;
                                                   CaptionML=[DAN=Brugerdefineret link;
                                                              ENU=Custom Link] }
    { 8   ;   ;Error Message       ;Text250       ;CaptionML=[DAN=Fejlmeddelelse;
                                                              ENU=Error Message];
                                                   Editable=No }
    { 9   ;   ;Created Date-Time   ;DateTime      ;CaptionML=[DAN=Oprettet dato/klokkesl‘t;
                                                              ENU=Created Date-Time];
                                                   Editable=No }
    { 10  ;   ;Created By          ;Code50        ;TableRelation=User."User Name";
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Oprettet af;
                                                              ENU=Created By];
                                                   Editable=No }
    { 15  ;   ;Error Message 2     ;Text250       ;CaptionML=[DAN=Fejlmeddelelse 2;
                                                              ENU=Error Message 2] }
    { 16  ;   ;Error Message 3     ;Text250       ;CaptionML=[DAN=Fejlmeddelelse 3;
                                                              ENU=Error Message 3] }
    { 17  ;   ;Error Message 4     ;Text250       ;CaptionML=[DAN=Fejlmeddelelse 4;
                                                              ENU=Error Message 4] }
  }
  KEYS
  {
    {    ;ID                                      ;Clustered=Yes }
    {    ;Created Date-Time                        }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      DataTypeManagement@1000 : Codeunit 701;

    [External]
    PROCEDURE CreateNew@1(NewType@1003 : 'New Record,Approval,Overdue';NewUserID@1002 : Code[50];NewRecord@1000 : Variant;NewLinkTargetPage@1004 : Integer;NewCustomLink@1005 : Text[250]);
    VAR
      NotificationSchedule@1006 : Record 1513;
      NewRecRef@1001 : RecordRef;
    BEGIN
      IF NOT DataTypeManagement.GetRecordRef(NewRecord,NewRecRef) THEN
        EXIT;

      CLEAR(Rec);
      Type := NewType;
      "Recipient User ID" := NewUserID;
      "Triggered By Record" := NewRecRef.RECORDID;
      "Link Target Page" := NewLinkTargetPage;
      "Custom Link" := NewCustomLink;
      INSERT(TRUE);

      NotificationSchedule.ScheduleNotification(Rec);
    END;

    [External]
    PROCEDURE GetErrorMessage@3() : Text;
    VAR
      TextMgt@1000 : Codeunit 41;
    BEGIN
      EXIT(TextMgt.GetRecordErrorMessage("Error Message","Error Message 2","Error Message 3","Error Message 4"));
    END;

    [External]
    PROCEDURE SetErrorMessage@2(ErrorText@1000 : Text);
    VAR
      TextMgt@1001 : Codeunit 41;
    BEGIN
      TextMgt.SetRecordErrorMessage("Error Message","Error Message 2","Error Message 3","Error Message 4",ErrorText);
    END;

    BEGIN
    END.
  }
}

