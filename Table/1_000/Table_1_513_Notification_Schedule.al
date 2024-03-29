OBJECT Table 1513 Notification Schedule
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    OnModify=VAR
               JobQueueEntry@1000 : Record 472;
             BEGIN
               IF JobQueueEntry.GET("Last Scheduled Job") THEN BEGIN
                 JobQueueEntry.DELETE(TRUE);
                 Schedule;
               END;
             END;

    OnDelete=VAR
               JobQueueEntry@1000 : Record 472;
             BEGIN
               IF JobQueueEntry.GET("Last Scheduled Job") THEN BEGIN
                 JobQueueEntry.DELETE(TRUE);
                 ScheduleNow;
               END;
             END;

    CaptionML=[DAN=Notifikationsplan;
               ENU=Notification Schedule];
    LookupPageID=Page1513;
    DrillDownPageID=Page1513;
  }
  FIELDS
  {
    { 1   ;   ;User ID             ;Code50        ;TableRelation="User Setup";
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 2   ;   ;Notification Type   ;Option        ;CaptionML=[DAN=Notifikationstype;
                                                              ENU=Notification Type];
                                                   OptionCaptionML=[DAN=Ny record,Godkendelse,Forfald;
                                                                    ENU=New Record,Approval,Overdue];
                                                   OptionString=New Record,Approval,Overdue }
    { 3   ;   ;Recurrence          ;Option        ;InitValue=Instantly;
                                                   CaptionML=[DAN=Gentagelse;
                                                              ENU=Recurrence];
                                                   OptionCaptionML=[DAN=�jeblikkeligt,Dagligt,Ugentligt,M�nedligt;
                                                                    ENU=Instantly,Daily,Weekly,Monthly];
                                                   OptionString=Instantly,Daily,Weekly,Monthly }
    { 4   ;   ;Time                ;Time          ;InitValue=12:00:00;
                                                   CaptionML=[DAN=Tidspunkt;
                                                              ENU=Time] }
    { 5   ;   ;Daily Frequency     ;Option        ;InitValue=Weekday;
                                                   OnValidate=BEGIN
                                                                UpdateDailyFrequency;
                                                              END;

                                                   CaptionML=[DAN=Daglig frekvens;
                                                              ENU=Daily Frequency];
                                                   OptionCaptionML=[DAN=Ugedag,Dagligt;
                                                                    ENU=Weekday,Daily];
                                                   OptionString=Weekday,Daily }
    { 6   ;   ;Monday              ;Boolean       ;InitValue=Yes;
                                                   CaptionML=[DAN=Mandag;
                                                              ENU=Monday] }
    { 7   ;   ;Tuesday             ;Boolean       ;InitValue=Yes;
                                                   CaptionML=[DAN=Tirsdag;
                                                              ENU=Tuesday] }
    { 8   ;   ;Wednesday           ;Boolean       ;InitValue=Yes;
                                                   CaptionML=[DAN=Onsdag;
                                                              ENU=Wednesday] }
    { 9   ;   ;Thursday            ;Boolean       ;InitValue=Yes;
                                                   CaptionML=[DAN=Torsdag;
                                                              ENU=Thursday] }
    { 10  ;   ;Friday              ;Boolean       ;InitValue=Yes;
                                                   CaptionML=[DAN=Fredag;
                                                              ENU=Friday] }
    { 11  ;   ;Saturday            ;Boolean       ;CaptionML=[DAN=L�rdag;
                                                              ENU=Saturday] }
    { 12  ;   ;Sunday              ;Boolean       ;CaptionML=[DAN=S�ndag;
                                                              ENU=Sunday] }
    { 13  ;   ;Date of Month       ;Integer       ;CaptionML=[DAN=Dato i m�ned;
                                                              ENU=Date of Month];
                                                   MinValue=1;
                                                   MaxValue=31 }
    { 14  ;   ;Monthly Notification Date;Option   ;CaptionML=[DAN=M�nedlig notifikationsdato;
                                                              ENU=Monthly Notification Date];
                                                   OptionCaptionML=[DAN=F�rste arbejdsdag,Sidste arbejdsdag,Brugerdefineret;
                                                                    ENU=First Workday,Last Workday,Custom];
                                                   OptionString=First Workday,Last Workday,Custom }
    { 15  ;   ;Last Scheduled Job  ;GUID          ;TableRelation="Job Queue Entry";
                                                   CaptionML=[DAN=Sidste planlagte sag;
                                                              ENU=Last Scheduled Job] }
  }
  KEYS
  {
    {    ;User ID,Notification Type               ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      NotifyNowDescriptionTxt@1000 : TextConst 'DAN=Sag med �jeblik. notifikation;ENU=Instant Notification Job';

    [External]
    PROCEDURE NewRecord@4(NewUserID@1000 : Code[50];NewNotificationType@1001 : Option);
    BEGIN
      INIT;
      "User ID" := NewUserID;
      "Notification Type" := NewNotificationType;

      INSERT;
    END;

    LOCAL PROCEDURE UpdateDailyFrequency@8();
    BEGIN
      Monday := TRUE;
      Tuesday := TRUE;
      Wednesday := TRUE;
      Thursday := TRUE;
      Friday := TRUE;
      Saturday := "Daily Frequency" <> "Daily Frequency"::Weekday;
      Sunday := "Daily Frequency" <> "Daily Frequency"::Weekday;
    END;

    LOCAL PROCEDURE GetFirstWorkdateOfMonth@9(CurrentDate@1000 : Date) : Date;
    VAR
      Day@1002 : ',Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday';
    BEGIN
      IF DATE2DWY(CALCDATE('<-CM>',CurrentDate),1) IN [Day::Saturday,Day::Sunday] THEN
        EXIT(CALCDATE('<-CM+WD1>',CurrentDate));

      EXIT(CALCDATE('<-CM>',CurrentDate))
    END;

    LOCAL PROCEDURE GetScheduledFirstWorkdateOfMonth@2(CurrentDateTime@1000 : DateTime;ScheduledTime@1001 : Time) ScheduledDateTime : DateTime;
    VAR
      CurrentDate@1002 : Date;
    BEGIN
      CurrentDate := DT2DATE(CurrentDateTime);
      ScheduledDateTime := CREATEDATETIME(GetFirstWorkdateOfMonth(CurrentDate),ScheduledTime);

      IF ScheduledDateTime < CurrentDateTime THEN
        ScheduledDateTime := CREATEDATETIME(GetFirstWorkdateOfMonth(CALCDATE('<+1M>',CurrentDate)),ScheduledTime);
    END;

    LOCAL PROCEDURE GetLastWorkdateOfMonth@5(CurrentDate@1000 : Date) : Date;
    VAR
      Day@1002 : ',Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday';
    BEGIN
      IF DATE2DWY(CALCDATE('<+CM>',CurrentDate),1) IN [Day::Saturday,Day::Sunday] THEN
        EXIT(CALCDATE('<+CM-WD5>',CurrentDate));

      EXIT(CALCDATE('<+CM>',CurrentDate))
    END;

    LOCAL PROCEDURE GetScheduledLastWorkdateOfMonth@26(CurrentDateTime@1000 : DateTime;ScheduledTime@1001 : Time) ScheduledDateTime : DateTime;
    VAR
      CurrentDate@1002 : Date;
    BEGIN
      CurrentDate := DT2DATE(CurrentDateTime);
      ScheduledDateTime := CREATEDATETIME(GetLastWorkdateOfMonth(CurrentDate),ScheduledTime);

      IF ScheduledDateTime < CurrentDateTime THEN
        ScheduledDateTime := CREATEDATETIME(GetLastWorkdateOfMonth(CALCDATE('<+1M>',CurrentDate)),ScheduledTime);
    END;

    LOCAL PROCEDURE GetLastDateOfMonth@41(CurrentDate@1000 : Date) : Date;
    BEGIN
      EXIT(CALCDATE('<+CM>',CurrentDate))
    END;

    LOCAL PROCEDURE GetScheduledCustomWorkdateOfMonth@43(CurrentDateTime@1000 : DateTime;ScheduledTime@1001 : Time;ScheduledDay@1004 : Integer) : DateTime;
    VAR
      CurrentDate@1002 : Date;
      CurrentTime@1003 : Time;
      CurrentDay@1005 : Integer;
      CurrentMonth@1006 : Integer;
      CurrentYear@1007 : Integer;
    BEGIN
      CurrentDate := DT2DATE(CurrentDateTime);
      CurrentTime := DT2TIME(CurrentDateTime);
      CurrentDay := DATE2DMY(CurrentDate,1);
      CurrentMonth := DATE2DMY(CurrentDate,2);
      CurrentYear := DATE2DMY(CurrentDate,3);

      IF (ScheduledDay = CurrentDay) AND (CurrentTime < ScheduledTime) THEN
        EXIT(CREATEDATETIME(DMY2DATE(ScheduledDay,CurrentMonth,CurrentYear),ScheduledTime));

      IF ScheduledDay <= CurrentDay THEN BEGIN
        CurrentDate := CALCDATE('<+1M>',CurrentDate);
        CurrentMonth := DATE2DMY(CurrentDate,2);
        CurrentYear := DATE2DMY(CurrentDate,3);
      END;

      CurrentDate := GetLastDateOfMonth(CurrentDate);
      IF ScheduledDay > DATE2DMY(CurrentDate,1) THEN
        EXIT(CREATEDATETIME(CurrentDate,ScheduledTime));
      EXIT(CREATEDATETIME(DMY2DATE(ScheduledDay,CurrentMonth,CurrentYear),ScheduledTime))
    END;

    LOCAL PROCEDURE GetScheduledWeekDay@31(CurrentDateTime@1000 : DateTime;ScheduledTime@1001 : Time) : DateTime;
    VAR
      CurrentDate@1002 : Date;
      CurrentTime@1003 : Time;
      WeekDays@1005 : ARRAY [7] OF Boolean;
      Idx@1009 : Integer;
      NextWeekDayIdx@1006 : Integer;
      CurrWeekDay@1008 : Integer;
      NextWeekDay@1007 : Integer;
    BEGIN
      CurrentDate := DT2DATE(CurrentDateTime);
      CurrentTime := DT2TIME(CurrentDateTime);

      CurrWeekDay := DATE2DWY(CurrentDate,1);
      NextWeekDay := CurrWeekDay;

      WeekDays[1] := Monday;
      WeekDays[2] := Tuesday;
      WeekDays[3] := Wednesday;
      WeekDays[4] := Thursday;
      WeekDays[5] := Friday;
      WeekDays[6] := Saturday;
      WeekDays[7] := Sunday;

      IF WeekDays[CurrWeekDay] AND (CurrentTime < ScheduledTime) THEN
        EXIT(CREATEDATETIME(CurrentDate,ScheduledTime));

      FOR Idx := 0 TO 6 DO BEGIN
        NextWeekDayIdx := ((CurrWeekDay + Idx) MOD 7) + 1;
        IF WeekDays[NextWeekDayIdx] THEN BEGIN
          NextWeekDay := NextWeekDayIdx;
          BREAK;
        END;
      END;

      EXIT(CREATEDATETIME(CALCDATE(STRSUBSTNO('<+WD%1>',NextWeekDay),CurrentDate),ScheduledTime));
    END;

    [External]
    PROCEDURE CalculateExecutionTime@18(DateTime@1001 : DateTime) : DateTime;
    BEGIN
      CASE Recurrence OF
        Recurrence::Instantly:
          EXIT(CURRENTDATETIME);
        Recurrence::Daily,
        Recurrence::Weekly:
          EXIT(GetScheduledWeekDay(DateTime,Time));
        Recurrence::Monthly:
          CASE "Monthly Notification Date" OF
            "Monthly Notification Date"::"First Workday":
              EXIT(GetScheduledFirstWorkdateOfMonth(DateTime,Time));
            "Monthly Notification Date"::"Last Workday":
              EXIT(GetScheduledLastWorkdateOfMonth(DateTime,Time));
            "Monthly Notification Date"::Custom:
              EXIT(GetScheduledCustomWorkdateOfMonth(DateTime,Time,"Date of Month"));
          END;
      END;
    END;

    LOCAL PROCEDURE Schedule@12();
    BEGIN
      IF Recurrence = Recurrence::Instantly THEN
        ScheduleNow
      ELSE
        ScheduleForLater
    END;

    [External]
    PROCEDURE ScheduleNotification@7(NotificationEntry@1000 : Record 1511);
    BEGIN
      // Try to get a schedule if none exist use the default record values
      IF GET(NotificationEntry."Recipient User ID",NotificationEntry.Type) THEN;

      Schedule;
    END;

    LOCAL PROCEDURE OneMinuteFromNow@13() : DateTime;
    BEGIN
      EXIT(CURRENTDATETIME + 60000);
    END;

    LOCAL PROCEDURE ScheduleNow@10();
    VAR
      JobQueueEntry@1000 : Record 472;
      JobQueueCategory@1001 : Record 471;
    BEGIN
      IF JobQueueEntry.ReuseExistingJobFromCatagory(JobQueueCategory.NotifyNowCode,OneMinuteFromNow) THEN
        EXIT;

      JobQueueCategory.InsertRec(JobQueueCategory.NotifyNowCode,NotifyNowDescriptionTxt);
      JobQueueEntry.ScheduleJobQueueEntryForLater(
        CODEUNIT::"Notification Entry Dispatcher",OneMinuteFromNow,JobQueueCategory.NotifyNowCode,'');
    END;

    LOCAL PROCEDURE ScheduleForLater@11();
    VAR
      JobQueueEntry@1000 : Record 472;
      NotificationEntry@1002 : Record 1511;
      ExcetutionDateTime@1001 : DateTime;
    BEGIN
      ExcetutionDateTime := CalculateExecutionTime(CURRENTDATETIME);
      IF JobQueueEntry.ReuseExistingJobFromID("Last Scheduled Job",ExcetutionDateTime) THEN
        EXIT;

      NotificationEntry.SETRANGE("Recipient User ID","User ID");
      NotificationEntry.SETRANGE(Type,"Notification Type");
      JobQueueEntry.ScheduleJobQueueEntryForLater(
        CODEUNIT::"Notification Entry Dispatcher",ExcetutionDateTime,'',NotificationEntry.GETVIEW);
      "Last Scheduled Job" := JobQueueEntry.ID;
      MODIFY
    END;

    BEGIN
    END.
  }
}

