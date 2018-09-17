OBJECT Table 474 Job Queue Log Entry
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Logpost for opgavek›;
               ENU=Job Queue Log Entry];
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;AutoIncrement=Yes;
                                                   CaptionML=[DAN=L›benr.;
                                                              ENU=Entry No.] }
    { 2   ;   ;ID                  ;GUID          ;CaptionML=[DAN=Id;
                                                              ENU=ID] }
    { 3   ;   ;User ID             ;Text65        ;TableRelation=User."User Name";
                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 4   ;   ;Start Date/Time     ;DateTime      ;CaptionML=[DAN=Startdato/-tidspunkt;
                                                              ENU=Start Date/Time] }
    { 5   ;   ;End Date/Time       ;DateTime      ;CaptionML=[DAN=Slutdato/-tidspunkt;
                                                              ENU=End Date/Time] }
    { 6   ;   ;Object Type to Run  ;Option        ;CaptionML=[DAN=Objekttype, der skal aktiveres;
                                                              ENU=Object Type to Run];
                                                   OptionCaptionML=[DAN=,,,Rapport,,Codeunit;
                                                                    ENU=,,,Report,,Codeunit];
                                                   OptionString=,,,Report,,Codeunit }
    { 7   ;   ;Object ID to Run    ;Integer       ;CaptionML=[DAN=Objekt-id, der skal aktiveres;
                                                              ENU=Object ID to Run] }
    { 8   ;   ;Object Caption to Run;Text250      ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(AllObjWithCaption."Object Caption" WHERE (Object Type=FIELD(Object Type to Run),
                                                                                                                Object ID=FIELD(Object ID to Run)));
                                                   CaptionML=[DAN=Objektoverskrift, der skal k›res;
                                                              ENU=Object Caption to Run] }
    { 9   ;   ;Status              ;Option        ;CaptionML=[DAN=Status;
                                                              ENU=Status];
                                                   OptionCaptionML=[DAN=Fuldf›rt,Igangsat,Fejl;
                                                                    ENU=Success,In Process,Error];
                                                   OptionString=Success,In Process,Error }
    { 10  ;   ;Description         ;Text250       ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 11  ;   ;Error Message       ;Text250       ;CaptionML=[DAN=Fejlmeddelelse;
                                                              ENU=Error Message] }
    { 12  ;   ;Error Message 2     ;Text250       ;CaptionML=[DAN=Fejlmeddelelse 2;
                                                              ENU=Error Message 2] }
    { 13  ;   ;Error Message 3     ;Text250       ;CaptionML=[DAN=Fejlmeddelelse 3;
                                                              ENU=Error Message 3] }
    { 14  ;   ;Error Message 4     ;Text250       ;CaptionML=[DAN=Fejlmeddelelse 4;
                                                              ENU=Error Message 4] }
    { 16  ;   ;Processed by User ID;Text65        ;DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Behandlet af bruger-id;
                                                              ENU=Processed by User ID] }
    { 17  ;   ;Job Queue Category Code;Code10     ;TableRelation="Job Queue Category";
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Opgavek›kategorikode;
                                                              ENU=Job Queue Category Code] }
  }
  KEYS
  {
    {    ;Entry No.                               ;Clustered=Yes }
    {    ;ID                                       }
    {    ;Start Date/Time,ID                       }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text001@1001 : TextConst 'DAN=Der er ingen fejlmeddelelse.;ENU=There is no error message.';
      Text002@1000 : TextConst 'DAN=Er du sikker p†, at du vil slette opgavek›logposterne?;ENU=Are you sure that you want to delete job queue log entries?';
      Text003@1002 : TextConst 'DAN=Markeret som fejl af %1.;ENU=Marked as Error by %1.';
      Text004@1003 : TextConst 'DAN=Det er kun poster med statussen Igangv‘rende, der kan markeres som fejl.;ENU=Only entries with status In Progress can be marked as Error.';

    [External]
    PROCEDURE GetErrorMessage@1() : Text;
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

    [External]
    PROCEDURE DeleteEntries@3(DaysOld@1000 : Integer);
    BEGIN
      IF NOT CONFIRM(Text002) THEN
        EXIT;
      SETFILTER(Status,'<>%1',Status::"In Process");
      SETFILTER("End Date/Time",'<=%1',CREATEDATETIME(TODAY - DaysOld,TIME));
      DELETEALL;
      SETRANGE("End Date/Time");
      SETRANGE(Status);
    END;

    [External]
    PROCEDURE ShowErrorMessage@8();
    VAR
      e@1000 : Text;
    BEGIN
      e := GetErrorMessage;
      IF e = '' THEN
        e := Text001;
      MESSAGE(e);
    END;

    [External]
    PROCEDURE MarkAsError@4();
    VAR
      JobQueueEntry@1003 : Record 472;
      ErrorMessage@1002 : Text[1000];
    BEGIN
      IF Status <> Status::"In Process" THEN
        ERROR(Text004);

      ErrorMessage := STRSUBSTNO(Text003,USERID);

      IF JobQueueEntry.GET(ID) THEN
        JobQueueEntry.SetError(ErrorMessage);

      Status := Status::Error;
      SetErrorMessage(ErrorMessage);
      MODIFY;
    END;

    [External]
    PROCEDURE Duration@5() : Duration;
    BEGIN
      IF ("Start Date/Time" = 0DT) OR ("End Date/Time" = 0DT) THEN
        EXIT(0);
      EXIT(ROUND("End Date/Time" - "Start Date/Time",100));
    END;

    BEGIN
    END.
  }
}

