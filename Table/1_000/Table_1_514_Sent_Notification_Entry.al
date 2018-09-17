OBJECT Table 1514 Sent Notification Entry
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Send notifikationspost;
               ENU=Sent Notification Entry];
    LookupPageID=Page1514;
    DrillDownPageID=Page1514;
  }
  FIELDS
  {
    { 1   ;   ;ID                  ;Integer       ;CaptionML=[DAN=Id;
                                                              ENU=ID] }
    { 3   ;   ;Type                ;Option        ;CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=Ny record,Godkendelse,Forfald;
                                                                    ENU=New Record,Approval,Overdue];
                                                   OptionString=New Record,Approval,Overdue }
    { 4   ;   ;Recipient User ID   ;Code50        ;DataClassification=EndUserIdentifiableInformation;
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
    { 9   ;   ;Created Date-Time   ;DateTime      ;CaptionML=[DAN=Oprettet dato/klokkesl‘t;
                                                              ENU=Created Date-Time] }
    { 10  ;   ;Created By          ;Code50        ;TableRelation=User."User Name";
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Oprettet af;
                                                              ENU=Created By] }
    { 11  ;   ;Sent Date-Time      ;DateTime      ;CaptionML=[DAN=Dato og klokkesl‘t for afsendelse;
                                                              ENU=Sent Date-Time] }
    { 12  ;   ;Notification Content;BLOB          ;CaptionML=[DAN=Notifikationsindhold;
                                                              ENU=Notification Content] }
    { 13  ;   ;Notification Method ;Option        ;CaptionML=[DAN=Notifikationsmetode;
                                                              ENU=Notification Method];
                                                   OptionCaptionML=[DAN=Mail,Notat;
                                                                    ENU=Email,Note];
                                                   OptionString=Email,Note }
    { 14  ;   ;Aggregated with Entry;Integer      ;TableRelation="Sent Notification Entry";
                                                   CaptionML=[DAN=Akkumuleret med post;
                                                              ENU=Aggregated with Entry] }
  }
  KEYS
  {
    {    ;ID                                      ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    [External]
    PROCEDURE NewRecord@11(NotificationEntry@1000 : Record 1511;NotificationContent@1001 : Text;NotificationMethod@1005 : Option);
    VAR
      SentNotificationEntry@1002 : Record 1514;
      OutStream@1004 : OutStream;
    BEGIN
      CLEAR(Rec);
      IF SentNotificationEntry.FINDLAST THEN;
      TRANSFERFIELDS(NotificationEntry);
      ID := SentNotificationEntry.ID + 1;
      "Notification Content".CREATEOUTSTREAM(OutStream);
      OutStream.WRITETEXT(NotificationContent);
      "Notification Method" := NotificationMethod;
      "Sent Date-Time" := CURRENTDATETIME;
      INSERT(TRUE);
    END;

    [Internal]
    PROCEDURE ExportContent@2(UseDialog@1002 : Boolean) : Text;
    VAR
      TempBlob@1000 : Record 99008535;
      FileMgt@1001 : Codeunit 419;
    BEGIN
      CALCFIELDS("Notification Content");
      IF "Notification Content".HASVALUE THEN BEGIN
        TempBlob.Blob := "Notification Content";
        IF "Notification Method" = "Notification Method"::Note THEN
          EXIT(FileMgt.BLOBExport(TempBlob,'*.txt',UseDialog));
        EXIT(FileMgt.BLOBExport(TempBlob,'*.htm',UseDialog))
      END;
    END;

    BEGIN
    END.
  }
}

