OBJECT Table 1170 User Task
{
  OBJECT-PROPERTIES
  {
    Date=26-01-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20348;
  }
  PROPERTIES
  {
    DataCaptionFields=Title;
    OnInsert=BEGIN
               VALIDATE("Created DateTime",CURRENTDATETIME);
               "Created By" := USERSECURITYID
             END;

    OnDelete=VAR
               DummyUserTask@1000 : Record 1170;
             BEGIN
               IF ("Percent Complete" > 0) AND ("Percent Complete" < 100) THEN
                 IF NOT CONFIRM(ConfirmDeleteQst) THEN
                   ERROR('');

               IF "Parent ID" > 0 THEN
                 IF CONFIRM(ConfirmDeleteAllOccurrencesQst) THEN BEGIN
                   DummyUserTask.COPYFILTERS(Rec);
                   RESET;
                   SETRANGE("Parent ID","Parent ID");
                   DELETEALL;
                   COPYFILTERS(DummyUserTask);
                 END
             END;

    CaptionML=[DAN=Brugeropgave;
               ENU=User Task];
  }
  FIELDS
  {
    { 1   ;   ;ID                  ;Integer       ;AutoIncrement=Yes;
                                                   CaptionML=[DAN=Id;
                                                              ENU=ID];
                                                   Editable=No }
    { 2   ;   ;Title               ;Text250       ;CaptionML=[DAN=Emne;
                                                              ENU=Subject] }
    { 3   ;   ;Created By          ;GUID          ;TableRelation=User."User Security ID" WHERE (License Type=CONST(Full User));
                                                   CaptionML=[DAN=Oprettet af;
                                                              ENU=Created By];
                                                   Editable=No }
    { 4   ;   ;Created DateTime    ;DateTime      ;CaptionML=[DAN=Oprettelsesdato;
                                                              ENU=Created Date];
                                                   Editable=No }
    { 5   ;   ;Assigned To         ;GUID          ;TableRelation=User."User Security ID" WHERE (License Type=CONST(Full User));
                                                   CaptionML=[DAN=Tildelt til;
                                                              ENU=Assigned To] }
    { 7   ;   ;Completed By        ;GUID          ;TableRelation=User."User Security ID" WHERE (License Type=CONST(Full User));
                                                   OnValidate=BEGIN
                                                                IF NOT ISNULLGUID("Completed By") THEN BEGIN
                                                                  "Percent Complete" := 100;
                                                                  IF "Completed DateTime" = 0DT THEN
                                                                    "Completed DateTime" := CURRENTDATETIME;
                                                                  IF "Start DateTime" = 0DT THEN
                                                                    "Start DateTime" := CURRENTDATETIME;
                                                                END ELSE BEGIN
                                                                  "Completed DateTime" := 0DT;
                                                                  "Percent Complete" := 0;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Afsluttet af;
                                                              ENU=Completed By] }
    { 8   ;   ;Completed DateTime  ;DateTime      ;OnValidate=BEGIN
                                                                IF "Completed DateTime" <> 0DT THEN BEGIN
                                                                  "Percent Complete" := 100;
                                                                  IF ISNULLGUID("Completed By") THEN
                                                                    "Completed By" := USERSECURITYID;
                                                                  IF "Start DateTime" = 0DT THEN
                                                                    "Start DateTime" := CURRENTDATETIME;
                                                                END ELSE BEGIN
                                                                  CLEAR("Completed By");
                                                                  "Percent Complete" := 0;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Fuldf�relsesdato;
                                                              ENU=Completed Date] }
    { 9   ;   ;Due DateTime        ;DateTime      ;CaptionML=[DAN=Forfaldsdato;
                                                              ENU=Due Date] }
    { 10  ;   ;Percent Complete    ;Integer       ;OnValidate=BEGIN
                                                                IF "Percent Complete" = 100 THEN BEGIN
                                                                  "Completed By" := USERSECURITYID;
                                                                  "Completed DateTime" := CURRENTDATETIME;
                                                                END ELSE BEGIN
                                                                  CLEAR("Completed By");
                                                                  CLEAR("Completed DateTime");
                                                                END;

                                                                IF "Percent Complete" = 0 THEN
                                                                  "Start DateTime" := 0DT
                                                                ELSE
                                                                  IF "Start DateTime" = 0DT THEN
                                                                    "Start DateTime" := CURRENTDATETIME;
                                                              END;

                                                   CaptionML=[DAN=% afsluttet;
                                                              ENU=% Complete];
                                                   MinValue=0;
                                                   MaxValue=100 }
    { 11  ;   ;Start DateTime      ;DateTime      ;CaptionML=[DAN=Startdato;
                                                              ENU=Start Date] }
    { 12  ;   ;Priority            ;Option        ;CaptionML=[DAN=Prioritet;
                                                              ENU=Priority];
                                                   OptionCaptionML=[DAN=,Lav,Normal,H�j;
                                                                    ENU=,Low,Normal,High];
                                                   OptionString=,Low,Normal,High }
    { 13  ;   ;Description         ;BLOB          ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description];
                                                   SubType=Memo }
    { 14  ;   ;Created By User Name;Code50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(User."User Name" WHERE (User Security ID=FIELD(Created By),
                                                                                              License Type=CONST(Full User)));
                                                   CaptionML=[DAN=Bruger oprettet af;
                                                              ENU=User Created By];
                                                   Editable=No }
    { 15  ;   ;Assigned To User Name;Code50       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(User."User Name" WHERE (User Security ID=FIELD(Assigned To),
                                                                                              License Type=CONST(Full User)));
                                                   CaptionML=[DAN=Bruger tildelt til;
                                                              ENU=User Assigned To];
                                                   Editable=No }
    { 16  ;   ;Completed By User Name;Code50      ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(User."User Name" WHERE (User Security ID=FIELD(Completed By),
                                                                                              License Type=CONST(Full User)));
                                                   CaptionML=[DAN=Bruger afsluttet af;
                                                              ENU=User Completed By];
                                                   Editable=No }
    { 17  ;   ;Object Type         ;Option        ;CaptionML=[DAN=Sammenk�d opgave med;
                                                              ENU=Link Task To];
                                                   OptionCaptionML=[DAN=,,,Rapport,,,,,Side;
                                                                    ENU=,,,Report,,,,,Page];
                                                   OptionString=,,,Report,,,,,Page }
    { 18  ;   ;Object ID           ;Integer       ;TableRelation=AllObj."Object ID" WHERE (Object Type=FIELD(Object Type));
                                                   CaptionML=[DAN=Objekt-id;
                                                              ENU=Object ID] }
    { 19  ;   ;Parent ID           ;Integer       ;CaptionML=[DAN=Id for overordnet;
                                                              ENU=Parent ID] }
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
    VAR
      ConfirmDeleteQst@1000 : TextConst 'DAN=Denne opgave er startet, men ikke fuldf�rt. Slet alligevel?;ENU=This task is started but not complete, delete anyway?';
      ConfirmDeleteAllOccurrencesQst@1001 : TextConst 'DAN=Vil du slette alle forekomster af denne opgave?;ENU=Delete all occurrences of this task?';

    PROCEDURE CreateRecurrence@3(RecurringStartDate@1000 : Date;Recurrence@1001 : DateFormula;Occurrences@1002 : Integer);
    VAR
      UserTaskTemp@1005 : Record 1170;
      Count@1004 : Integer;
      TempDueDate@1003 : Date;
    BEGIN
      VALIDATE("Parent ID",ID);
      VALIDATE("Due DateTime",CREATEDATETIME(RecurringStartDate,000000T));
      MODIFY(TRUE);

      TempDueDate := RecurringStartDate;
      WHILE Count < Occurrences - 1 DO BEGIN
        CLEAR(UserTaskTemp);
        UserTaskTemp.VALIDATE(Title,Title);
        UserTaskTemp.SetDescription(GetDescription);
        UserTaskTemp."Created By" := USERSECURITYID;
        UserTaskTemp.VALIDATE("Created DateTime",CURRENTDATETIME);
        UserTaskTemp.VALIDATE("Assigned To","Assigned To");
        UserTaskTemp.VALIDATE(Priority,Priority);
        UserTaskTemp.VALIDATE("Object Type","Object Type");
        UserTaskTemp.VALIDATE("Object ID","Object ID");
        UserTaskTemp.VALIDATE("Parent ID",ID);
        TempDueDate := CALCDATE(Recurrence,TempDueDate);
        UserTaskTemp.VALIDATE("Due DateTime",CREATEDATETIME(TempDueDate,000000T));
        UserTaskTemp.INSERT(TRUE);
        Count := Count + 1;
      END
    END;

    PROCEDURE SetCompleted@2();
    BEGIN
      "Percent Complete" := 100;
      "Completed By" := USERSECURITYID;
      "Completed DateTime" := CURRENTDATETIME;

      IF "Start DateTime" = 0DT THEN
        "Start DateTime" := CURRENTDATETIME;
    END;

    [External]
    PROCEDURE SetStyle@1() : Text;
    BEGIN
      IF "Percent Complete" <> 100 THEN BEGIN
        IF ("Due DateTime" <> 0DT) AND ("Due DateTime" <= CURRENTDATETIME) THEN
          EXIT('Unfavorable')
      END;
      EXIT('');
    END;

    PROCEDURE GetDescription@4() : Text;
    VAR
      TypeHelper@1000 : Codeunit 10;
      DescriptionFieldRef@1002 : FieldRef;
      UserTaskRecRef@1003 : RecordRef;
      StreamText@1001 : Text;
    BEGIN
      UserTaskRecRef.GETTABLE(Rec);
      DescriptionFieldRef := UserTaskRecRef.FIELD(FIELDNO(Description));
      StreamText := TypeHelper.ReadTextBlobWithTextEncoding(DescriptionFieldRef,TEXTENCODING::Windows);
      EXIT(StreamText);
    END;

    PROCEDURE SetDescription@5(StreamText@1000 : Text);
    VAR
      TypeHelper@1002 : Codeunit 10;
      DescriptionFieldRef@1003 : FieldRef;
      UserTaskRecRef@1004 : RecordRef;
    BEGIN
      CLEAR(Description);
      UserTaskRecRef.GETTABLE(Rec);
      DescriptionFieldRef := UserTaskRecRef.FIELD(FIELDNO(Description));
      IF TypeHelper.WriteBlobWithEncoding(DescriptionFieldRef,StreamText,TEXTENCODING::Windows) THEN BEGIN
        Description := DescriptionFieldRef.VALUE;
        IF MODIFY(TRUE) THEN;
      END;
    END;

    PROCEDURE IsCompleted@6() : Boolean;
    BEGIN
      EXIT("Percent Complete" = 100);
    END;

    BEGIN
    END.
  }
}

