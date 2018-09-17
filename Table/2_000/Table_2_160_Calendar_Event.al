OBJECT Table 2160 Calendar Event
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
               Schedule;
             END;

    OnModify=BEGIN
               IF NOT Archived THEN
                 Schedule;
             END;

    OnDelete=VAR
               CalendarEventMangement@1000 : Codeunit 2160;
             BEGIN
               CheckIfArchived;

               Archived := TRUE;
               MODIFY;

               CalendarEventMangement.DescheduleCalendarEvent(Rec);
             END;

    CaptionML=[DAN=Kalenderh‘ndelse;
               ENU=Calendar Event];
  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Integer       ;AutoIncrement=Yes;
                                                   CaptionML=[DAN=Nr.;
                                                              ENU=No.] }
    { 2   ;   ;Scheduled Date      ;Date          ;OnValidate=BEGIN
                                                                CheckIfArchived;
                                                              END;

                                                   CaptionML=[DAN=Planlagt dato;
                                                              ENU=Scheduled Date] }
    { 3   ;   ;Archived            ;Boolean       ;CaptionML=[DAN=Arkiveret;
                                                              ENU=Archived] }
    { 4   ;   ;Description         ;Text50        ;OnValidate=BEGIN
                                                                CheckIfArchived;
                                                              END;

                                                   CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 5   ;   ;Object ID to Run    ;Integer       ;OnValidate=BEGIN
                                                                CheckIfArchived;
                                                              END;

                                                   CaptionML=[DAN=Objekt-id, der skal k›res;
                                                              ENU=Object ID to Run] }
    { 6   ;   ;Record ID to Process;RecordID      ;OnValidate=BEGIN
                                                                CheckIfArchived;
                                                              END;

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Record-id, der skal behandles;
                                                              ENU=Record ID to Process] }
    { 7   ;   ;State               ;Option        ;CaptionML=[DAN=Stat;
                                                              ENU=State];
                                                   OptionCaptionML=[DAN=I k›,I gang,Fuldf›rt,Mislykkedes;
                                                                    ENU=Queued,In Progress,Completed,Failed];
                                                   OptionString=Queued,In Progress,Completed,Failed }
    { 8   ;   ;Result              ;Text250       ;CaptionML=[DAN=Resultat;
                                                              ENU=Result] }
    { 9   ;   ;User                ;Code50        ;OnValidate=BEGIN
                                                                CheckIfArchived;
                                                              END;

                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger;
                                                              ENU=User] }
    { 10  ;   ;Type                ;Option        ;CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=Bruger,System;
                                                                    ENU=User,System];
                                                   OptionString=User,System }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
    {    ;Scheduled Date,Archived,User             }
  }
  FIELDGROUPS
  {
    { 1   ;Brick               ;Scheduled Date,Description,State         }
  }
  CODE
  {
    VAR
      AlreadyExecutedErr@1000 : TextConst 'DAN=Denne kalenderpost er allerede udf›rt og kan ikke ‘ndres.;ENU=This calendar entry has already been executed and cannot be modified.';

    LOCAL PROCEDURE Schedule@1();
    VAR
      CalendarEventMangement@1000 : Codeunit 2160;
    BEGIN
      // Validate entries
      TESTFIELD("Scheduled Date");
      TESTFIELD(Description);
      TESTFIELD("Object ID to Run");
      TESTFIELD(Archived,FALSE);

      User := USERID;

      CalendarEventMangement.CreateOrUpdateJobQueueEntry(Rec)
    END;

    LOCAL PROCEDURE CheckIfArchived@4();
    BEGIN
      IF Archived THEN
        ERROR(AlreadyExecutedErr);
    END;

    BEGIN
    END.
  }
}

