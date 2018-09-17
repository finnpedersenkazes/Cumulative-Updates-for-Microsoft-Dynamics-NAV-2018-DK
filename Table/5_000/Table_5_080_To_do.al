OBJECT Table 5080 To-do
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    DataCaptionFields=No.,Description;
    OnInsert=BEGIN
               IF "No." = '' THEN BEGIN
                 RMSetup.GET;
                 RMSetup.TESTFIELD("To-do Nos.");
                 NoSeriesMgt.InitSeries(RMSetup."To-do Nos.",xRec."No. Series",0D,"No.","No. Series");
               END;
               IF (("System To-do Type" = "System To-do Type"::Organizer) AND
                   ("Team Code" = '')) OR
                  ("System To-do Type" = "System To-do Type"::Team)
               THEN
                 "Organizer To-do No." := "No.";
               "Last Date Modified" := TODAY;
               "Last Time Modified" := TIME;
             END;

    OnModify=BEGIN
               IF "No." <> '' THEN BEGIN
                 "Last Date Modified" := TODAY;
                 "Last Time Modified" := TIME;

                 UpdateAttendeeTasks("No.");
               END;
             END;

    OnDelete=VAR
               Attendee@1001 : Record 5199;
               Task@1000 : Record 5080;
               TaskInteractionLanguage@1002 : Record 5196;
               RMCommentLine@1003 : Record 5061;
             BEGIN
               RMCommentLine.SETRANGE("Table Name",RMCommentLine."Table Name"::"To-do");
               RMCommentLine.SETRANGE("No.","No.");
               RMCommentLine.DELETEALL;
               Task.SETRANGE("Organizer To-do No.","No.");
               Task.SETFILTER("No.",'<>%1',"No.");
               IF Task.FINDFIRST THEN
                 Task.DELETEALL;

               Attendee.SETRANGE("To-do No.","No.");
               Attendee.DELETEALL;

               TaskInteractionLanguage.SETRANGE("To-do No.","No.");
               TaskInteractionLanguage.DELETEALL(TRUE);
             END;

    CaptionML=[DAN=Opgave;
               ENU=Task];
    LookupPageID=Page5096;
    DrillDownPageID=Page5096;
  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Code20        ;OnValidate=BEGIN
                                                                IF "No." <> xRec."No." THEN BEGIN
                                                                  RMSetup.GET;
                                                                  NoSeriesMgt.TestManual(RMSetup."To-do Nos.");
                                                                  "No. Series" := '';
                                                                  IF ("System To-do Type" = "System To-do Type"::Organizer) OR
                                                                     ("System To-do Type" = "System To-do Type"::Team)
                                                                  THEN
                                                                    UpdateAttendeeTasks(xRec."No.");
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 2   ;   ;Team Code           ;Code10        ;TableRelation=Team;
                                                   OnValidate=BEGIN
                                                                IF ("Team Code" <> xRec."Team Code") AND
                                                                   ("No." <> '') AND
                                                                   IsCalledFromForm
                                                                THEN BEGIN
                                                                  IF ("Team Code" = '') AND ("Salesperson Code" = '') THEN
                                                                    ERROR(Text035,FIELDCAPTION("Salesperson Code"),FIELDCAPTION("Team Code"));
                                                                  IF xRec."Team Code" <> '' THEN BEGIN
                                                                    IF Closed THEN BEGIN
                                                                      IF CONFIRM(STRSUBSTNO(Text039,"No.",xRec."Team Code","Team Code")) THEN BEGIN
                                                                        ChangeTeam;
                                                                        GET("No.");
                                                                        VALIDATE(Closed,FALSE);
                                                                      END ELSE
                                                                        "Team Code" := xRec."Team Code"
                                                                    END ELSE BEGIN
                                                                      IF CONFIRM(STRSUBSTNO(TasksWillBeDeletedQst,xRec."Team Code","Team Code")) THEN
                                                                        ChangeTeam
                                                                      ELSE
                                                                        "Team Code" := xRec."Team Code"
                                                                    END
                                                                  END ELSE BEGIN
                                                                    IF Closed THEN BEGIN
                                                                      IF CONFIRM(STRSUBSTNO(Text042,"No.","Team Code")) THEN BEGIN
                                                                        ReassignSalespersonTaskToTeam;
                                                                        GET("No.");
                                                                        VALIDATE(Closed,FALSE);
                                                                      END ELSE
                                                                        "Team Code" := ''
                                                                    END ELSE
                                                                      ReassignSalespersonTaskToTeam;
                                                                  END
                                                                END
                                                              END;

                                                   CaptionML=[DAN=Teamkode;
                                                              ENU=Team Code] }
    { 3   ;   ;Salesperson Code    ;Code20        ;TableRelation=Salesperson/Purchaser;
                                                   OnValidate=BEGIN
                                                                IF (xRec."Salesperson Code" <> "Salesperson Code") AND
                                                                   ("No." <> '') AND
                                                                   IsCalledFromForm
                                                                THEN BEGIN
                                                                  IF ("Team Code" = '') AND ("Salesperson Code" = '') THEN
                                                                    ERROR(Text035,FIELDCAPTION("Salesperson Code"),FIELDCAPTION("Team Code"));
                                                                  IF (Type = Type::Meeting) AND ("Team Code" = '') THEN
                                                                    ERROR(Text009,FIELDCAPTION("Salesperson Code"));

                                                                  IF "Team Code" <> '' THEN BEGIN
                                                                    IF Type = Type::Meeting THEN
                                                                      IF Closed THEN
                                                                        IF CONFIRM(STRSUBSTNO(Text040,"No.","Salesperson Code")) THEN BEGIN
                                                                          ReassignTeamTaskToSalesperson;
                                                                          GET("No.");
                                                                          VALIDATE(Closed,FALSE);
                                                                        END ELSE
                                                                          "Salesperson Code" := xRec."Salesperson Code"
                                                                      ELSE
                                                                        IF CONFIRM(STRSUBSTNO(Text033,"No.","Salesperson Code")) THEN
                                                                          ReassignTeamTaskToSalesperson
                                                                        ELSE
                                                                          "Salesperson Code" := xRec."Salesperson Code"
                                                                    ELSE
                                                                      IF Closed THEN
                                                                        IF CONFIRM(STRSUBSTNO(Text041,"No.","Salesperson Code")) THEN BEGIN
                                                                          ReassignTeamTaskToSalesperson;
                                                                          GET("No.");
                                                                          VALIDATE(Closed,FALSE);
                                                                        END ELSE
                                                                          "Salesperson Code" := xRec."Salesperson Code"
                                                                      ELSE
                                                                        IF CONFIRM(STRSUBSTNO(Text032,"No.","Salesperson Code")) THEN
                                                                          ReassignTeamTaskToSalesperson
                                                                        ELSE
                                                                          "Salesperson Code" := xRec."Salesperson Code"
                                                                  END
                                                                END
                                                              END;

                                                   CaptionML=[DAN=S�lgerkode;
                                                              ENU=Salesperson Code] }
    { 4   ;   ;Campaign No.        ;Code20        ;TableRelation=Campaign;
                                                   CaptionML=[DAN=Kampagnenr.;
                                                              ENU=Campaign No.] }
    { 5   ;   ;Contact No.         ;Code20        ;TableRelation=Contact;
                                                   OnValidate=VAR
                                                                TempAttendee@1000 : TEMPORARY Record 5199;
                                                              BEGIN
                                                                IF Cont.GET("Contact No.") THEN
                                                                  "Contact Company No." := Cont."Company No."
                                                                ELSE
                                                                  CLEAR("Contact Company No.");

                                                                IF ("No." <> '') AND
                                                                   ("No." = "Organizer To-do No.") AND
                                                                   ("Contact No." <> xRec."Contact No.") AND
                                                                   (Type <> Type::Meeting)
                                                                THEN
                                                                  CASE TRUE OF
                                                                    (xRec."Contact No." = '') AND ("Contact No." <> ''):
                                                                      BEGIN
                                                                        TempAttendee.CreateAttendee(
                                                                          TempAttendee,
                                                                          "No.",10000,TempAttendee."Attendance Type"::Required,
                                                                          TempAttendee."Attendee Type"::Contact,
                                                                          "Contact No.",FALSE);
                                                                        CreateSubTask(TempAttendee,Rec);
                                                                      END;
                                                                    (xRec."Contact No." <> '') AND ("Contact No." = ''):
                                                                      BEGIN
                                                                        TempAttendee.CreateAttendee(
                                                                          TempAttendee,
                                                                          "No.",10000,TempAttendee."Attendance Type"::Required,
                                                                          TempAttendee."Attendee Type"::Contact,
                                                                          xRec."Contact No.",FALSE);
                                                                        DeleteAttendeeTask(TempAttendee);
                                                                      END;
                                                                    xRec."Contact No." <> "Contact No.":
                                                                      BEGIN
                                                                        TempAttendee.CreateAttendee(
                                                                          TempAttendee,
                                                                          "No.",10000,TempAttendee."Attendance Type"::Required,
                                                                          TempAttendee."Attendee Type"::Contact,
                                                                          xRec."Contact No.",FALSE);
                                                                        DeleteAttendeeTask(TempAttendee);
                                                                        TempAttendee.CreateAttendee(
                                                                          TempAttendee,
                                                                          "No.",20000,TempAttendee."Attendance Type"::Required,
                                                                          TempAttendee."Attendee Type"::Contact,
                                                                          "Contact No.",FALSE);
                                                                        CreateSubTask(TempAttendee,Rec);
                                                                      END;
                                                                  END;
                                                              END;

                                                   CaptionML=[DAN=Kontaktnr.;
                                                              ENU=Contact No.] }
    { 6   ;   ;Opportunity No.     ;Code20        ;TableRelation=Opportunity;
                                                   OnValidate=VAR
                                                                OppEntry@1001 : Record 5093;
                                                              BEGIN
                                                                OppEntry.RESET;
                                                                OppEntry.SETCURRENTKEY(Active,"Opportunity No.");
                                                                OppEntry.SETRANGE(Active,TRUE);
                                                                OppEntry.SETRANGE("Opportunity No.","Opportunity No.");
                                                                IF OppEntry.FINDFIRST THEN
                                                                  "Opportunity Entry No." := OppEntry."Entry No."
                                                                ELSE
                                                                  "Opportunity Entry No." := 0;
                                                              END;

                                                   CaptionML=[DAN=Salgsmulighednummer;
                                                              ENU=Opportunity No.] }
    { 7   ;   ;Segment No.         ;Code20        ;TableRelation="Segment Header";
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=M�lgruppenr.;
                                                              ENU=Segment No.] }
    { 8   ;   ;Type                ;Option        ;OnValidate=VAR
                                                                OldEndDate@1000 : Date;
                                                              BEGIN
                                                                IF "No." <> '' THEN BEGIN
                                                                  IF ((xRec.Type = Type::Meeting) AND (Type <> Type::Meeting)) OR
                                                                     ((xRec.Type <> Type::Meeting) AND (Type = Type::Meeting))
                                                                  THEN
                                                                    ERROR(Text012);
                                                                END ELSE BEGIN
                                                                  IF CurrFieldNo = 0 THEN
                                                                    EXIT;

                                                                  IF xRec.Type <> Type::Meeting THEN
                                                                    TempEndDateTime := CREATEDATETIME(xRec.Date,xRec."Start Time") - OneDayDuration + xRec.Duration
                                                                  ELSE
                                                                    TempEndDateTime := CREATEDATETIME(xRec.Date,xRec."Start Time") + xRec.Duration;

                                                                  OldEndDate := DT2DATE(TempEndDateTime);

                                                                  IF (xRec.Type = Type::Meeting) AND (Type <> Type::Meeting) THEN BEGIN
                                                                    "Start Time" := 0T;
                                                                    "All Day Event" := FALSE;
                                                                    SetDuration(OldEndDate,0T);
                                                                  END;

                                                                  IF (xRec.Type <> Type::Meeting) AND (Type = Type::Meeting) THEN BEGIN
                                                                    "Start Time" := 0T;
                                                                    IF OldEndDate = Date THEN BEGIN
                                                                      SetDuration(OldEndDate,DT2TIME(CREATEDATETIME(OldEndDate,0T) + 30 * 60 * 1000));
                                                                    END ELSE
                                                                      SetDuration(OldEndDate,0T);
                                                                  END;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=" ,M�de,Telefonopkald";
                                                                    ENU=" ,Meeting,Phone Call"];
                                                   OptionString=[ ,Meeting,Phone Call] }
    { 9   ;   ;Date                ;Date          ;OnValidate=BEGIN
                                                                IF (Date < DMY2DATE(1,1,1900)) OR (Date > DMY2DATE(31,12,2999)) THEN
                                                                  ERROR(Text006,DMY2DATE(1,1,1900),DMY2DATE(31,12,2999));

                                                                IF Date <> xRec.Date THEN
                                                                  GetEndDateTime;
                                                              END;

                                                   CaptionML=[DAN=Dato;
                                                              ENU=Date];
                                                   NotBlank=Yes }
    { 10  ;   ;Status              ;Option        ;OnValidate=BEGIN
                                                                IF Status = Status::Completed THEN
                                                                  VALIDATE(Closed,TRUE)
                                                                ELSE
                                                                  VALIDATE(Closed,FALSE);
                                                              END;

                                                   CaptionML=[DAN=Status;
                                                              ENU=Status];
                                                   OptionCaptionML=[DAN=Ikke startet,Igangsat,Afsluttet,Venter,Udsat;
                                                                    ENU=Not Started,In Progress,Completed,Waiting,Postponed];
                                                   OptionString=Not Started,In Progress,Completed,Waiting,Postponed }
    { 11  ;   ;Priority            ;Option        ;InitValue=Normal;
                                                   CaptionML=[DAN=Prioritet;
                                                              ENU=Priority];
                                                   OptionCaptionML=[DAN=Lav,Normal,H�j;
                                                                    ENU=Low,Normal,High];
                                                   OptionString=Low,Normal,High }
    { 12  ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 13  ;   ;Closed              ;Boolean       ;OnValidate=BEGIN
                                                                IF Closed THEN BEGIN
                                                                  "Date Closed" := TODAY;
                                                                  Status := Status::Completed;
                                                                  IF NOT Canceled THEN BEGIN
                                                                    IF ("Team Code" <> '') AND
                                                                       ("Completed By" = '')
                                                                    THEN
                                                                      ERROR(STRSUBSTNO(Text029,FIELDCAPTION("Completed By")));
                                                                    IF CurrFieldNo <> 0 THEN
                                                                      IF CONFIRM(Text004,TRUE) THEN
                                                                        CreateInteraction
                                                                  END;
                                                                  IF Recurring THEN
                                                                    CreateRecurringTask;
                                                                END ELSE BEGIN
                                                                  Canceled := FALSE;
                                                                  "Date Closed" := 0D;
                                                                  IF Status = Status::Completed THEN
                                                                    Status := Status::"In Progress";
                                                                  IF "Completed By" <> '' THEN
                                                                    "Completed By" := ''
                                                                END;
                                                                IF CurrFieldNo <> 0 THEN
                                                                  MODIFY(TRUE);
                                                              END;

                                                   CaptionML=[DAN=Lukket;
                                                              ENU=Closed] }
    { 14  ;   ;Date Closed         ;Date          ;CaptionML=[DAN=Lukket den;
                                                              ENU=Date Closed];
                                                   Editable=No }
    { 15  ;   ;No. Series          ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Nummerserie;
                                                              ENU=No. Series];
                                                   Editable=No }
    { 16  ;   ;Comment             ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Rlshp. Mgt. Comment Line" WHERE (Table Name=CONST(To-do),
                                                                                                       No.=FIELD(Organizer To-do No.),
                                                                                                       Sub No.=CONST(0)));
                                                   CaptionML=[DAN=Bem�rkning;
                                                              ENU=Comment];
                                                   Editable=No }
    { 17  ;   ;Canceled            ;Boolean       ;OnValidate=BEGIN
                                                                IF Canceled AND NOT Closed THEN
                                                                  VALIDATE(Closed,TRUE);
                                                                IF (NOT Canceled) AND Closed THEN
                                                                  VALIDATE(Closed,FALSE);
                                                              END;

                                                   CaptionML=[DAN=Annulleret;
                                                              ENU=Canceled] }
    { 18  ;   ;Contact Name        ;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Contact.Name WHERE (No.=FIELD(Contact No.)));
                                                   CaptionML=[DAN=Kontaktnavn;
                                                              ENU=Contact Name];
                                                   Editable=No }
    { 19  ;   ;Team Name           ;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Team.Name WHERE (Code=FIELD(Team Code)));
                                                   CaptionML=[DAN=Teamnavn;
                                                              ENU=Team Name];
                                                   NotBlank=No;
                                                   Editable=No }
    { 20  ;   ;Salesperson Name    ;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Salesperson/Purchaser.Name WHERE (Code=FIELD(Salesperson Code)));
                                                   CaptionML=[DAN=S�lgernavn;
                                                              ENU=Salesperson Name];
                                                   Editable=No }
    { 21  ;   ;Campaign Description;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Campaign.Description WHERE (No.=FIELD(Campaign No.)));
                                                   CaptionML=[DAN=Kampagnebeskrivelse;
                                                              ENU=Campaign Description];
                                                   Editable=No }
    { 22  ;   ;Contact Company No. ;Code20        ;TableRelation=Contact WHERE (Type=CONST(Company));
                                                   CaptionML=[DAN=Virksomhedsnummer;
                                                              ENU=Contact Company No.] }
    { 23  ;   ;Contact Company Name;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Contact.Name WHERE (No.=FIELD(Contact Company No.)));
                                                   CaptionML=[DAN=Virksomhed;
                                                              ENU=Contact Company Name];
                                                   Editable=No }
    { 24  ;   ;Recurring           ;Boolean       ;CaptionML=[DAN=Gentagelse;
                                                              ENU=Recurring] }
    { 25  ;   ;Recurring Date Interval;DateFormula;OnValidate=BEGIN
                                                                IF Recurring THEN
                                                                  TESTFIELD("Recurring Date Interval");
                                                              END;

                                                   CaptionML=[DAN=Gentagelsesinterval;
                                                              ENU=Recurring Date Interval] }
    { 26  ;   ;Calc. Due Date From ;Option        ;OnValidate=BEGIN
                                                                IF Recurring THEN
                                                                  TESTFIELD("Calc. Due Date From");
                                                              END;

                                                   CaptionML=[DAN=Beregn forfaldsdato ud fra;
                                                              ENU=Calc. Due Date From];
                                                   OptionCaptionML=[DAN=" ,Forfaldsdato,Ultimodato";
                                                                    ENU=" ,Due Date,Closing Date"];
                                                   OptionString=[ ,Due Date,Closing Date] }
    { 27  ;   ;Opportunity Description;Text50     ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Opportunity.Description WHERE (No.=FIELD(Opportunity No.)));
                                                   CaptionML=[DAN=Salgsmulighedbeskrivelse;
                                                              ENU=Opportunity Description];
                                                   Editable=No }
    { 28  ;   ;Start Time          ;Time          ;OnValidate=BEGIN
                                                                IF "Start Time" <> xRec."Start Time" THEN
                                                                  GetEndDateTime;
                                                              END;

                                                   CaptionML=[DAN=Starttidspunkt;
                                                              ENU=Start Time] }
    { 29  ;   ;Duration            ;Duration      ;OnValidate=BEGIN
                                                                IF Duration < 0 THEN
                                                                  ERROR(Text005);

                                                                IF Duration < (60 * 1000) THEN
                                                                  ERROR(Text007);

                                                                IF Duration > (CREATEDATETIME(TODAY + 3650,0T) - CREATEDATETIME(TODAY,0T)) THEN
                                                                  ERROR(Text008);

                                                                IF Duration <> xRec.Duration THEN
                                                                  GetEndDateTime;
                                                              END;

                                                   CaptionML=[DAN=Varighed;
                                                              ENU=Duration] }
    { 31  ;   ;Opportunity Entry No.;Integer      ;TableRelation="Opportunity Entry";
                                                   CaptionML=[DAN=Salgsmulighedpostl�benr.;
                                                              ENU=Opportunity Entry No.] }
    { 32  ;   ;Last Date Modified  ;Date          ;CaptionML=[DAN=Rettet den;
                                                              ENU=Last Date Modified] }
    { 33  ;   ;Last Time Modified  ;Time          ;CaptionML=[DAN=Rettet kl.;
                                                              ENU=Last Time Modified] }
    { 34  ;   ;All Day Event       ;Boolean       ;OnValidate=BEGIN
                                                                IF "All Day Event" THEN BEGIN
                                                                  "Start Time" := 0T;
                                                                  TempStartDateTime := CREATEDATETIME(Date,"Start Time");
                                                                  TempEndDateTime := TempStartDateTime + Duration;
                                                                  IF DT2DATE(TempEndDateTime) = Date THEN
                                                                    Duration := 1440 * 1000 * 60
                                                                  ELSE
                                                                    Duration := ROUNDDATETIME(TempEndDateTime + 1,1440 * 1000 * 60,'>') - TempStartDateTime;
                                                                END ELSE
                                                                  Duration := Duration - 1440 * 1000 * 60;
                                                              END;

                                                   CaptionML=[DAN=Hele dagen;
                                                              ENU=All Day Event] }
    { 35  ;   ;Location            ;Text50        ;CaptionML=[DAN=Sted;
                                                              ENU=Location] }
    { 36  ;   ;Organizer To-do No. ;Code20        ;TableRelation=To-do;
                                                   CaptionML=[DAN=Arrang�rs opgavenr.;
                                                              ENU=Organizer Task No.] }
    { 37  ;   ;Interaction Template Code;Code10   ;TableRelation="Interaction Template";
                                                   OnValidate=VAR
                                                                TaskInteractionLanguage@1000 : Record 5196;
                                                                Attachment@1001 : Record 5062;
                                                              BEGIN
                                                                IF "No." <> '' THEN
                                                                  UpdateInteractionTemplate(
                                                                    Rec,TaskInteractionLanguage,Attachment,"Interaction Template Code",FALSE);
                                                              END;

                                                   CaptionML=[DAN=Interaktionsskabelonkode;
                                                              ENU=Interaction Template Code] }
    { 38  ;   ;Language Code       ;Code10        ;TableRelation=Language;
                                                   OnValidate=VAR
                                                                TaskInteractionLanguage@1000 : Record 5196;
                                                              BEGIN
                                                                IF CurrFieldNo <> 0 THEN
                                                                  MODIFY;

                                                                IF "Language Code" = xRec."Language Code" THEN
                                                                  EXIT;

                                                                IF NOT TaskInteractionLanguage.GET("No.","Language Code") THEN BEGIN
                                                                  IF "No." = '' THEN
                                                                    EXIT;
                                                                  IF CurrFieldNo <> 0 THEN
                                                                    IF CONFIRM(Text010,TRUE,TaskInteractionLanguage.TABLECAPTION,"Language Code") THEN BEGIN
                                                                      TaskInteractionLanguage.INIT;
                                                                      TaskInteractionLanguage."To-do No." := "No.";
                                                                      TaskInteractionLanguage."Language Code" := "Language Code";
                                                                      TaskInteractionLanguage.Description := FORMAT("Interaction Template Code") + ' ' + FORMAT("Language Code");
                                                                      TaskInteractionLanguage.INSERT(TRUE);
                                                                      "Attachment No." := 0;
                                                                      MODIFY;
                                                                    END ELSE
                                                                      ERROR('');
                                                                END ELSE
                                                                  "Attachment No." := TaskInteractionLanguage."Attachment No.";
                                                              END;

                                                   OnLookup=VAR
                                                              TaskInteractionLanguage@1000 : Record 5196;
                                                            BEGIN
                                                              MODIFY;
                                                              COMMIT;

                                                              TaskInteractionLanguage.SETRANGE("To-do No.","Organizer To-do No.");
                                                              IF TaskInteractionLanguage.GET("Organizer To-do No.","Language Code") THEN;
                                                              IF PAGE.RUNMODAL(0,TaskInteractionLanguage) = ACTION::LookupOK THEN BEGIN
                                                                IF ("System To-do Type" = "System To-do Type"::Organizer) OR
                                                                   ("System To-do Type" = "System To-do Type"::Team)
                                                                THEN
                                                                  IF NOT TaskInteractionLanguage.ISEMPTY THEN BEGIN
                                                                    "Language Code" := TaskInteractionLanguage."Language Code";
                                                                    "Attachment No." := TaskInteractionLanguage."Attachment No.";
                                                                  END ELSE BEGIN
                                                                    "Language Code" := '';
                                                                    "Attachment No." := 0;
                                                                  END;
                                                              END ELSE
                                                                IF NOT TaskInteractionLanguage.ISEMPTY THEN BEGIN
                                                                  IF "Language Code" = TaskInteractionLanguage."Language Code" THEN
                                                                    "Attachment No." := TaskInteractionLanguage."Attachment No.";
                                                                END ELSE BEGIN
                                                                  "Language Code" := '';
                                                                  "Attachment No." := 0;
                                                                END;
                                                            END;

                                                   CaptionML=[DAN=Sprogkode;
                                                              ENU=Language Code] }
    { 39  ;   ;Attachment No.      ;Integer       ;CaptionML=[DAN=Vedh�ftet fil nr.;
                                                              ENU=Attachment No.] }
    { 40  ;   ;Subject             ;Text50        ;OnValidate=BEGIN
                                                                IF CurrFieldNo <> 0 THEN
                                                                  MODIFY;
                                                              END;

                                                   CaptionML=[DAN=Emne;
                                                              ENU=Subject] }
    { 41  ;   ;Unit Cost (LCY)     ;Decimal       ;OnValidate=BEGIN
                                                                IF CurrFieldNo <> 0 THEN
                                                                  MODIFY;
                                                              END;

                                                   CaptionML=[DAN=Kostpris (RV);
                                                              ENU=Unit Cost (LCY)];
                                                   DecimalPlaces=2:2 }
    { 42  ;   ;Unit Duration (Min.);Decimal       ;OnValidate=BEGIN
                                                                IF CurrFieldNo <> 0 THEN
                                                                  MODIFY;
                                                              END;

                                                   CaptionML=[DAN=Varighed af enhed (min.);
                                                              ENU=Unit Duration (Min.)];
                                                   DecimalPlaces=0:2 }
    { 43  ;   ;No. of Attendees    ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count(Attendee WHERE (To-do No.=FIELD(Organizer To-do No.)));
                                                   CaptionML=[DAN=Antal deltagere;
                                                              ENU=No. of Attendees];
                                                   Editable=No }
    { 44  ;   ;Attendees Accepted No.;Integer     ;FieldClass=FlowField;
                                                   CalcFormula=Count(Attendee WHERE (To-do No.=FIELD(Organizer To-do No.),
                                                                                     Invitation Response Type=CONST(Accepted)));
                                                   CaptionML=[DAN=Antal tilmeldinger;
                                                              ENU=Attendees Accepted No.];
                                                   Editable=No }
    { 45  ;   ;System To-do Type   ;Option        ;CaptionML=[DAN=Systemopgavetype;
                                                              ENU=System Task Type];
                                                   OptionCaptionML=[DAN=Arrang�r,S�lgerdeltager,Kontaktdeltager,Team;
                                                                    ENU=Organizer,Salesperson Attendee,Contact Attendee,Team];
                                                   OptionString=Organizer,Salesperson Attendee,Contact Attendee,Team }
    { 46  ;   ;Completed By        ;Code20        ;TableRelation=Salesperson/Purchaser.Code;
                                                   OnValidate=BEGIN
                                                                IF (xRec."Completed By" = '') AND
                                                                   ("Completed By" <> '')
                                                                THEN
                                                                  IF CONFIRM(Text034) THEN
                                                                    VALIDATE(Closed,TRUE)
                                                                  ELSE
                                                                    "Completed By" := '';
                                                              END;

                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Afsluttet af;
                                                              ENU=Completed By] }
    { 47  ;   ;Ending Date         ;Date          ;OnValidate=BEGIN
                                                                IF "Ending Date" <> xRec."Ending Date" THEN
                                                                  SetDuration("Ending Date","Ending Time");
                                                              END;

                                                   CaptionML=[DAN=Afslutningsdato;
                                                              ENU=Ending Date] }
    { 48  ;   ;Ending Time         ;Time          ;OnValidate=BEGIN
                                                                IF "Ending Time" <> xRec."Ending Time" THEN
                                                                  SetDuration("Ending Date","Ending Time");
                                                              END;

                                                   CaptionML=[DAN=Afslutningstidspunkt;
                                                              ENU=Ending Time] }
    { 9501;   ;Wizard Step         ;Option        ;CaptionML=[DAN=Trin i guiden;
                                                              ENU=Wizard Step];
                                                   OptionCaptionML=[DAN=" ,1,2,3,4,5,6";
                                                                    ENU=" ,1,2,3,4,5,6"];
                                                   OptionString=[ ,1,2,3,4,5,6];
                                                   Editable=No }
    { 9504;   ;Team To-do          ;Boolean       ;CaptionML=[DAN=Holdopgave;
                                                              ENU=Team Task] }
    { 9505;   ;Send on finish      ;Boolean       ;CaptionML=[DAN=Send ved afslutning;
                                                              ENU=Send on finish] }
    { 9506;   ;Segment Description ;Text50        ;CaptionML=[DAN=Beskrivelse af m�lgruppe;
                                                              ENU=Segment Description] }
    { 9507;   ;Team Meeting Organizer;Code20      ;CaptionML=[DAN=Arrang�r af teamm�de;
                                                              ENU=Team Meeting Organizer] }
    { 9508;   ;Activity Code       ;Code10        ;TableRelation=Activity.Code;
                                                   CaptionML=[DAN=Kode for aktivitet;
                                                              ENU=Activity Code] }
    { 9509;   ;Wizard Contact Name ;Text50        ;CaptionML=[DAN=Kontaktnavn i guide;
                                                              ENU=Wizard Contact Name] }
    { 9510;   ;Wizard Campaign Description;Text50 ;CaptionML=[DAN=Kampagnebeskrivelse i guide;
                                                              ENU=Wizard Campaign Description] }
    { 9511;   ;Wizard Opportunity Description;Text50;
                                                   CaptionML=[DAN=Beskrivelse af salgsmuligheder i guiden;
                                                              ENU=Wizard Opportunity Description] }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
    {    ;Contact Company No.,Date,Contact No.,Closed }
    {    ;Contact Company No.,Contact No.,Closed,Date }
    {    ;Salesperson Code,Date,Closed             }
    {    ;Team Code,Date,Closed                    }
    {    ;Campaign No.,Date                        }
    {    ;Segment No.,Date                         }
    {    ;Opportunity No.,Date,Closed              }
    {    ;Organizer To-do No.,System To-do Type    }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;No.,Description,Status                   }
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=%1 skal indtastes.;ENU=%1 must be specified.';
      Text001@1001 : TextConst 'DAN=%1 nr. %2 er blevet oprettet ud fra gentaget %3 %4.;ENU=%1 No. %2 has been created from recurring %3 %4.';
      Text002@1002 : TextConst '@@@="%1 = Segment Header No.";DAN=Vil du oprette en opgave til alle kontakter i segmentet %1?;ENU=Do you want to create a Task for all contacts in the %1 Segment';
      Text003@1003 : TextConst '@@@="%1 = Segment Header No.";DAN=Vil du tildele en aktivitet til alle kontakter i m�lgruppen %1?;ENU=Do you want to assign an activity to all Contacts in the %1 Segment';
      RMSetup@1004 : Record 5079;
      Cont@1005 : Record 5050;
      Salesperson@1021 : Record 13;
      Activity@1069 : Record 5081;
      Campaign@1059 : Record 5071;
      Team@1050 : Record 5083;
      Opp@1041 : Record 5092;
      SegHeader@1040 : Record 5076;
      TempAttendee@1039 : TEMPORARY Record 5199;
      TempTaskInteractionLanguage@1037 : TEMPORARY Record 5196;
      TempAttachment@1026 : TEMPORARY Record 5062;
      TempRMCommentLine@1024 : TEMPORARY Record 5061;
      NoSeriesMgt@1007 : Codeunit 396;
      Text004@1008 : TextConst 'DAN=Vil du registrere en interaktionslogpost?;ENU=Do you want to register an Interaction Log Entry?';
      TempEndDateTime@1012 : DateTime;
      Text005@1013 : TextConst 'DAN=De oplysninger, som du har angivet i dette felt, bevirker, at varigheden bliver negativ, hvilket ikke er muligt. Rediger v�rdien for slutdatoen/sluttidspunktet.;ENU=Information that you have entered in this field will cause the duration to be negative which is not allowed. Please modify the ending date/time value.';
      TempStartDateTime@1014 : DateTime;
      Text006@1015 : TextConst 'DAN=Det gyldige datointerval er fra %1 til %2. Angiv en dato inden for dette interval.;ENU=The valid range of dates is from %1 to %2. Please enter a date within this range.';
      Text007@1016 : TextConst 'DAN=De oplysninger, som du har angivet i dette felt, bevirker, at varigheden bliver mindre end �t minut, hvilket ikke er muligt. Rediger v�rdien for slutdatoen/sluttidspunktet.;ENU=Information that you have entered in this field will cause the duration to be less than 1 minute, which is not allowed. Please modify the ending date/time value.';
      Text008@1017 : TextConst 'DAN=De oplysninger, som du har angivet i dette felt, bevirker, at varigheden bliver mere end 10 �r, hvilket ikke er muligt. Rediger v�rdien for slutdatoen/sluttidspunktet.;ENU=Information that you have entered in this field will cause the duration to be more than 10 years, which is not allowed. Please modify the ending date/time value.';
      Text009@1022 : TextConst '@@@="%1=Salesperson Code";DAN=Du kan ikke �ndre %1 for denne opgave, fordi denne s�lger er m�dearrang�r.;ENU=You cannot change the %1 for this Task, because this salesperson is the meeting organizer.';
      Text010@1023 : TextConst '@@@="%1=Task Interaction Language,%2=Language Code";DAN=Vil du oprette en ny v�rdi for %2 i %1 for denne opgave?;ENU=Do you want to create a new %2 value in %1 for this Task?';
      Text012@1025 : TextConst 'DAN=Du kan ikke �ndre en opgavetype fra Tom eller Telefonopkald til M�de og omvendt. Du kan kun �ndre en opgavetype fra Tom til Telefonopkald eller fra Telefonopkald til Tom.;ENU=You cannot change a Task type from Blank or Phone Call to Meeting and vice versa. You can only change a Task type from Blank to Phone Call or from Phone Call to Blank.';
      Text015@1029 : TextConst 'DAN=K�re %1;ENU=Dear %1,';
      Text016@1030 : TextConst '@@@="%1 = Task Date,%2 = Task StartTime,%3=Task location";DAN=Du inviteres til at deltage i m�det, som finder sted den %1, %2 kl. %3.;ENU=You are cordially invited to attend the meeting, which will take place on %1, %2 at %3.';
      Text017@1028 : TextConst 'DAN=Med venlig hilsen;ENU=Yours sincerely,';
      Text018@1031 : TextConst 'DAN=Afkrydsningsfeltet %1 er ikke markeret.;ENU=The %1 check box is not selected.';
      Text019@1032 : TextConst 'DAN=Send invitationer til alle deltagere, hvor feltet %1 er markeret.;ENU=Send invitations to all Attendees with selected %1 check boxes.';
      Text020@1033 : TextConst 'DAN=Send invitationer til deltagere, som endnu ikke har modtaget invitationer.;ENU=Send invitations to Attendees who have not been sent invitations yet.';
      Text021@1034 : TextConst 'DAN=Send ikke invitationer.;ENU=Do not send invitations.';
      Text022@1035 : TextConst 'DAN=Der er allerede sendt invitationer til deltagere, som feltet %1 er markeret for. Vil du sende invitationerne igen?;ENU=Invitations have already been sent to Attendees with selected %1 check boxes. Do you want to resend the invitations?';
      Text023@1036 : TextConst 'DAN=Outlook kunne ikke sende en invitation til %1.;ENU=Outlook failed to send an invitation to %1.';
      Text029@1042 : TextConst '@@@="%1=Completed By";DAN=Feltet %1 skal udfyldes for opgaver, der er tildelt et team.;ENU=The %1 field must be filled in for Tasks assigned to a team.';
      TasksWillBeDeletedQst@1043 : TextConst '@@@="%1 = old Team code, %2 = new Team code";DAN=Opgaver for %1-teammedlemmerne, der ikke h�rer til %2-teamet, slettes. Vil du forts�tte?;ENU=Tasks of the %1 team members who do not belong to the %2 team will be deleted. Do you want to continue?';
      Text032@1045 : TextConst '@@@="%1=Task No.,%2=Salesperson Code";DAN=Opgavenr. %1 omfordeles til %2, og den tilh�rende s�lgers opgaver for teammedlemmer vil blive slettet. Vil du forts�tte?;ENU=Task No. %1 will be reassigned to %2 and the corresponding salesperson Tasks for team members will be deleted. Do you want to continue?';
      Text033@1046 : TextConst '@@@="%1=Task No.,%2=Salesperson Code";DAN=Opgavenr. %1 omfordeles til %2. Vil du forts�tte?;ENU=Task No. %1 will be reassigned to %2. Do you want to continue?';
      Text034@1047 : TextConst 'DAN=Vil du lukke opgaven?;ENU=Do you want to close the Task?';
      Text035@1027 : TextConst 'DAN=Du skal enten udfylde feltet %1 eller feltet %2.;ENU=You must fill in either the %1 field or the %2 field.';
      Text036@1049 : TextConst 'DAN=Opretter opgaver...\;ENU=Creating Tasks...\';
      TaskNoMsg@1048 : TextConst '@@@="%1 = counter";DAN=Opgavenr. #1##############\;ENU=Task No. #1##############\';
      Text038@1044 : TextConst 'DAN=Status    @2@@@@@@@@@@@@@@;ENU=Status    @2@@@@@@@@@@@@@@';
      Text039@1051 : TextConst '@@@="%1=Task No,%2=Team Code,%3=Team Code";DAN=Opgavenr. %1 lukkes og gen�bnes. Opgaverne for de %2-teammedlemmer, som ikke tilh�rer %3-teamet, bliver slettet. Vil du forts�tte?;ENU=Task No. %1 is closed and will be reopened. The Tasks of the %2 team members who do not belong to the %3 team will be deleted. Do you want to continue?';
      Text040@1052 : TextConst '@@@="%1=Task No.,%2=Salesperson Code";DAN=Opgavenr. %1 lukkes og gen�bnes. Den vil blive omfordelt til %2, og de tilh�rende s�lgeropgaver for teammedlemmerne vil blive slettet. Vil du forts�tte?;ENU=Task No. %1 is closed and will be reopened. It will be reassigned to %2, and the corresponding salesperson Tasks for team members will be deleted. Do you want to continue?';
      Text041@1053 : TextConst '@@@="%1=Task No.,%2=Salesperson Code";DAN=Opgavenr. %1 lukkes. Den vil blive �bnet igen og omfordelt til %2. Vil du forts�tte?;ENU=Task No. %1 is closed. It will be reopened and reassigned to %2. Do you want to continue?';
      Text042@1054 : TextConst '@@@="%1=Task No.,%2=Team Code";DAN=Opgavenr. %1 lukkes. Vil du �bne den igen og omfordele den til %2-teamet?;ENU=Task No. %1 is closed. Do you want to reopen it and assign to the %2 team?';
      Text043@1068 : TextConst 'DAN=Feltet %1 skal udfyldes.;ENU=You must fill in the %1 field.';
      Text047@1072 : TextConst 'DAN=Du kan ikke bruge guiden til at oprette en vedh�ftet fil. Du kan oprette en vedh�ftet fil i vinduet Interaktionsskabelon.;ENU=You cannot use the wizard to create an attachment. You can create an attachment in the Interaction Template window.';
      Text051@1077 : TextConst 'DAN=Aktivitetskode;ENU=Activity Code';
      Text053@1076 : TextConst 'DAN=Indtast %1 eller %2.;ENU=You must specify %1 or %2.';
      Text056@1073 : TextConst '@@@="%1=Activity Code";DAN=Aktiviteten %1 indeholder opgaver af typen M�de. Du skal udfylde feltet M�dearrang�r.;ENU=Activity %1 contains Tasks of type Meeting. You must fill in the Meeting Organizer field.';
      Text065@1083 : TextConst 'DAN=Du skal angive opgavearrang�ren.;ENU=You must specify the Task organizer.';
      Text067@1019 : TextConst 'DAN=%1 skal indeholde en vedh�ftet fil, hvis du vil sende en invitation til en %2 af typen Kontakt.;ENU=The %1 must contain an attachment if you want to send an invitation to an %2 of the contact type.';
      Text068@1080 : TextConst 'DAN=Du kan ikke markere afkrydsningsfeltet Send invitationer, n�r jeg klikker p� Udf�r, fordi ingen af afkrydsningsfelterne %1 er markeret.;ENU=You cannot select the Send invitation(s) on Finish check box, because none of the %1 check boxes are selected.';
      RunFormCode@1020 : Boolean;
      CreateExchangeAppointment@1009 : Boolean;

    [External]
    PROCEDURE CreateTaskFromTask@1(VAR Task@1000 : Record 5080);
    BEGIN
      DELETEALL;
      INIT;
      SetFilterFromTask(Task);
      StartWizard;
    END;

    [External]
    PROCEDURE CreateTaskFromSalesHeader@50(SalesHeader@1000 : Record 36);
    BEGIN
      DELETEALL;
      INIT;
      VALIDATE("Contact No.",SalesHeader."Sell-to Contact No.");
      SETRANGE("Contact No.",SalesHeader."Sell-to Contact No.");
      IF SalesHeader."Salesperson Code" <> '' THEN BEGIN
        "Salesperson Code" := SalesHeader."Salesperson Code";
        SETRANGE("Salesperson Code","Salesperson Code");
      END;
      IF SalesHeader."Campaign No." <> '' THEN BEGIN
        "Campaign No." := SalesHeader."Campaign No.";
        SETRANGE("Campaign No.","Campaign No.");
      END;

      StartWizard;
    END;

    [External]
    PROCEDURE CreateTaskFromInteractLogEntry@51(InteractionLogEntry@1000 : Record 5065);
    BEGIN
      INIT;
      VALIDATE("Contact No.",InteractionLogEntry."Contact No.");
      "Salesperson Code" := InteractionLogEntry."Salesperson Code";
      "Campaign No." := InteractionLogEntry."Campaign No.";

      StartWizard;
    END;

    LOCAL PROCEDURE CreateInteraction@10();
    VAR
      TempSegLine@1000 : TEMPORARY Record 5077;
    BEGIN
      CASE Type OF
        Type::" ":
          TempSegLine.CreateInteractionFromTask(Rec);
        Type::Meeting:
          ;
        Type::"Phone Call":
          BEGIN
            TempSegLine."Campaign No." := "Campaign No.";
            TempSegLine."Opportunity No." := "Opportunity No.";
            TempSegLine."Contact No." := "Contact No.";
            TempSegLine."To-do No." := "No.";
            TempSegLine."Salesperson Code" := "Salesperson Code";
            TempSegLine.CreatePhoneCall;
          END;
      END;
    END;

    LOCAL PROCEDURE CreateRecurringTask@4();
    VAR
      Task2@1002 : Record 5080;
      TaskInteractLanguage@1003 : Record 5196;
      Attachment@1004 : Record 5062;
      Attendee@1005 : Record 5199;
      TempAttendee@1007 : TEMPORARY Record 5199;
      RMCommentLine@1000 : Record 5061;
      RMCommentLine3@1006 : Record 5061;
    BEGIN
      TESTFIELD("Recurring Date Interval");
      IF "Calc. Due Date From" = "Calc. Due Date From"::" " THEN
        ERROR(
          STRSUBSTNO(Text000,FIELDCAPTION("Calc. Due Date From")));

      Task2 := Rec;
      WITH Task2 DO BEGIN
        Status := 0;
        Closed := FALSE;
        Canceled := FALSE;
        "Date Closed" := 0D;
        "Completed By" := '';
        CASE "Calc. Due Date From" OF
          "Calc. Due Date From"::"Due Date":
            Date := CALCDATE("Recurring Date Interval",Date);
          "Calc. Due Date From"::"Closing Date":
            Date := CALCDATE("Recurring Date Interval",TODAY);
        END;
        GetEndDateTime;

        RMCommentLine3.RESET;
        RMCommentLine3.SETRANGE("Table Name",RMCommentLine."Table Name"::"To-do");
        RMCommentLine3.SETRANGE("No.","No.");
        RMCommentLine3.SETRANGE("Sub No.",0);

        TaskInteractLanguage.SETRANGE("To-do No.","No.");

        IF Type = Type::Meeting THEN BEGIN
          Attendee.SETRANGE("To-do No.","No.");
          GET(InsertTaskAndRelatedData(
              Task2,TaskInteractLanguage,Attachment,Attendee,RMCommentLine3));
        END ELSE BEGIN
          CreateAttendeesFromTask(TempAttendee,Task2,'');
          GET(InsertTaskAndRelatedData(
              Task2,TaskInteractLanguage,Attachment,TempAttendee,RMCommentLine3));
        END;
      END;

      MESSAGE(
        STRSUBSTNO(Text001,
          TABLECAPTION,Task2."Organizer To-do No.",TABLECAPTION,"No."));
    END;

    PROCEDURE InsertTask@2(Task2@1000 : Record 5080;VAR RMCommentLine@1004 : Record 5061;VAR TempAttendee@1005 : TEMPORARY Record 5199;VAR TaskInteractionLanguage@1007 : Record 5196;VAR TempAttachment@1008 : TEMPORARY Record 5062;ActivityCode@1001 : Code[10];Deliver@1010 : Boolean);
    VAR
      SegHeader@1002 : Record 5076;
      SegLine@1003 : Record 5077;
      ConfirmText@1006 : Text[250];
    BEGIN
      IF SegHeader.GET(GETFILTER("Segment No.")) THEN BEGIN
        SegLine.SETRANGE("Segment No.",SegHeader."No.");
        SegLine.SETFILTER("Contact No.",'<>%1','');
        IF SegLine.FINDFIRST THEN BEGIN
          IF ActivityCode = '' THEN
            ConfirmText := Text002
          ELSE
            ConfirmText := Text003;
          IF CONFIRM(ConfirmText,TRUE,SegHeader."No.") THEN BEGIN
            IF ActivityCode = '' THEN BEGIN
              Task2.GET(InsertTaskAndRelatedData(
                  Task2,TaskInteractionLanguage,TempAttachment,TempAttendee,RMCommentLine));
              IF (Task2.Type = Type::Meeting) AND Deliver THEN
                SendMAPIInvitations(Task2,TRUE);
            END ELSE
              InsertActivityTask(Task2,ActivityCode,TempAttendee);
          END;
        END;
      END ELSE BEGIN
        IF ActivityCode = '' THEN BEGIN
          Task2.GET(InsertTaskAndRelatedData(
              Task2,TaskInteractionLanguage,TempAttachment,TempAttendee,RMCommentLine));
          IF (Task2.Type = Type::Meeting) AND Deliver THEN
            SendMAPIInvitations(Task2,TRUE);
        END ELSE
          InsertActivityTask(Task2,ActivityCode,TempAttendee);
      END;

      IF (Task2.Type = Task2.Type::Meeting) AND
         Task2.GET(Task2."Organizer To-do No.")
      THEN
        Task2.ArrangeOrganizerAttendee;
    END;

    LOCAL PROCEDURE InsertTaskAndRelatedData@14(Task2@1000 : Record 5080;VAR TaskInteractLanguage@1001 : Record 5196;VAR Attachment@1002 : Record 5062;VAR Attendee@1003 : Record 5199;VAR RMCommentLine@1004 : Record 5061) TaskNo : Code[20];
    VAR
      TaskInteractLanguage2@1005 : Record 5196;
      TempAttendee@1006 : TEMPORARY Record 5199;
      Task@1007 : Record 5080;
      TeamSalesperson@1008 : Record 5084;
      Attendee2@1010 : Record 5199;
      Window@1013 : Dialog;
      AttendeeCounter@1017 : Integer;
      TotalAttendees@1018 : Integer;
      CommentLineInserted@1019 : Boolean;
    BEGIN
      IF Task2."Team Code" = '' THEN
        Task2."System To-do Type" := "System To-do Type"::Organizer
      ELSE
        Task2."System To-do Type" := "System To-do Type"::Team;
      IF Task2.Type = Type::Meeting THEN BEGIN
        CLEAR(Task2."No.");
        IF Task2."System To-do Type" = Task2."System To-do Type"::Team THEN
          Task2."Salesperson Code" := '';
        Task2.INSERT(TRUE);

        CreateTaskInteractLanguages(TaskInteractLanguage,Attachment,Task2."No.");
        IF TaskInteractLanguage2.GET(Task2."No.",Task2."Language Code") THEN BEGIN
          Task2."Attachment No." := TaskInteractLanguage2."Attachment No.";
          Task2.MODIFY;
        END;

        IF "Team Code" <> '' THEN BEGIN
          Attendee.SETCURRENTKEY("To-do No.","Attendance Type");
          Attendee.SETRANGE("Attendance Type",Attendee."Attendance Type"::"To-do Organizer");
          IF Attendee.FIND('-') THEN BEGIN
            CreateSubTask(Attendee,Task2);
            Attendee2.INIT;
            Attendee2 := Attendee;
            Attendee2."To-do No." := Task2."No.";
            Attendee2.INSERT;
          END;
          Attendee.SETFILTER("Attendance Type",'<>%1',Attendee."Attendance Type"::"To-do Organizer")
        END;
        IF Attendee.FIND('-') THEN
          REPEAT
            CreateSubTask(Attendee,Task2);
            Attendee2.INIT;
            Attendee2 := Attendee;
            Attendee2."To-do No." := Task2."No.";
            Attendee2.INSERT
          UNTIL Attendee.NEXT = 0;

        Task2.GetMeetingOrganizerTask(Task);
        TaskNo := Task."No."
      END ELSE
        IF Task2."Segment No." = '' THEN BEGIN
          CLEAR(Task2."No.");

          Task2.INSERT(TRUE);
          TaskNo := Task2."No.";
          IF Task2."System To-do Type" = "System To-do Type"::Team THEN BEGIN
            TeamSalesperson.SETRANGE("Team Code",Task2."Team Code");
            IF TeamSalesperson.FIND('-') THEN
              REPEAT
                TempAttendee.CreateAttendee(
                  TempAttendee,
                  Task2."No.",10000,
                  TempAttendee."Attendance Type"::"To-do Organizer",
                  TempAttendee."Attendee Type"::Salesperson,
                  TeamSalesperson."Salesperson Code",
                  TRUE);
                CreateSubTask(TempAttendee,Task2);
                TempAttendee.DELETEALL
              UNTIL TeamSalesperson.NEXT = 0
          END;
          IF Attendee.FIND('-') THEN
            REPEAT
              CreateSubTask(Attendee,Task2);
            UNTIL Attendee.NEXT = 0;
        END ELSE
          IF Attendee.FIND('-') THEN BEGIN
            Window.OPEN(Text036 + TaskNoMsg + Text038);
            TotalAttendees := Attendee.COUNT;
            REPEAT
              IF Task2."System To-do Type" = "System To-do Type"::Team THEN BEGIN
                Task.INIT;
                Task := Task2;
                CLEAR(Task."No.");
                FillSalesPersonContact(Task,Attendee);
                Task.INSERT(TRUE);
                TaskNo := Task."No.";
                TempAttendee.INIT;
                TempAttendee := Attendee;
                TempAttendee.INSERT;
                CreateSubTask(TempAttendee,Task);
                TempAttendee.DELETEALL;
                TeamSalesperson.SETRANGE("Team Code",Task."Team Code");
                IF TeamSalesperson.FIND('-') THEN
                  REPEAT
                    TempAttendee.CreateAttendee(
                      TempAttendee,
                      "No.",10000,
                      TempAttendee."Attendance Type"::"To-do Organizer",
                      TempAttendee."Attendee Type"::Salesperson,
                      TeamSalesperson."Salesperson Code",
                      TRUE);
                    CreateSubTask(TempAttendee,Task);
                    TempAttendee.DELETEALL
                  UNTIL TeamSalesperson.NEXT = 0
              END ELSE BEGIN
                Task.INIT;
                Task := Task2;
                CLEAR(Task."No.");
                Task."System To-do Type" := "System To-do Type"::Organizer;
                FillSalesPersonContact(Task,Attendee);
                Task.INSERT(TRUE);
                TaskNo := Task."No.";

                TempAttendee.INIT;
                TempAttendee := Attendee;
                TempAttendee.INSERT;
                CreateSubTask(TempAttendee,Task);
              END;
              AttendeeCounter := AttendeeCounter + 1;
              CreateCommentLines(RMCommentLine,TaskNo);
              Window.UPDATE(1,Task."Organizer To-do No.");
              Window.UPDATE(2,ROUND(AttendeeCounter / TotalAttendees * 10000,1));
              COMMIT
            UNTIL Attendee.NEXT = 0;
            Window.CLOSE;
            CommentLineInserted := TRUE;
          END;
      IF NOT CommentLineInserted THEN
        CreateCommentLines(RMCommentLine,Task2."No.");
    END;

    [External]
    PROCEDURE CreateSubTask@15(VAR Attendee@1001 : Record 5199;Task@1000 : Record 5080) : Code[20];
    VAR
      Task2@1002 : Record 5080;
    BEGIN
      Task2.INIT;
      Task2.TRANSFERFIELDS(Task,FALSE);

      IF Attendee."Attendance Type" <> Attendee."Attendance Type"::"To-do Organizer" THEN BEGIN
        IF Attendee."Attendee Type" = Attendee."Attendee Type"::Salesperson THEN BEGIN
          Task2.VALIDATE("Salesperson Code",Attendee."Attendee No.");
          Task2."Organizer To-do No." := Task."No.";
          Task2."System To-do Type" := "System To-do Type"::"Salesperson Attendee";
        END ELSE BEGIN
          Task2.VALIDATE("Salesperson Code",Task."Salesperson Code");
          Task2.VALIDATE("Team Code",Task."Team Code");
          Task2.VALIDATE("Contact No.",Attendee."Attendee No.");
          Task2."Organizer To-do No." := Task."No.";
          Task2."System To-do Type" := "System To-do Type"::"Contact Attendee";
        END;
        Task2.INSERT(TRUE)
      END ELSE
        IF Task."Team Code" <> '' THEN BEGIN
          Task2."System To-do Type" := Task2."System To-do Type"::Organizer;
          Task2.VALIDATE("Salesperson Code",Attendee."Attendee No.");
          Task2.INSERT(TRUE);
        END;
      EXIT(Task2."No.")
    END;

    [External]
    PROCEDURE DeleteAttendeeTask@20(Attendee@1000 : Record 5199);
    VAR
      Task@1001 : Record 5080;
    BEGIN
      IF FindAttendeeTask(Task,Attendee) THEN
        Task.DELETE;
    END;

    [External]
    PROCEDURE FindAttendeeTask@25(VAR Task@1000 : Record 5080;Attendee@1001 : Record 5199) : Boolean;
    BEGIN
      Task.RESET;
      Task.SETCURRENTKEY("Organizer To-do No.","System To-do Type");
      Task.SETRANGE("Organizer To-do No.",Attendee."To-do No.");
      IF Attendee."Attendee Type" = Attendee."Attendee Type"::Contact THEN BEGIN
        Task.SETRANGE("System To-do Type",Task."System To-do Type"::"Contact Attendee");
        Task.SETRANGE("Contact No.",Attendee."Attendee No.")
      END ELSE BEGIN
        Task.SETRANGE("System To-do Type",Task."System To-do Type"::"Salesperson Attendee");
        Task.SETRANGE("Salesperson Code",Attendee."Attendee No.");
      END;
      EXIT(Task.FIND('-'));
    END;

    LOCAL PROCEDURE CreateAttendeesFromTask@19(VAR Attendee@1000 : Record 5199;Task@1001 : Record 5080;TeamMeetingOrganizer@1008 : Code[20]);
    VAR
      Cont@1002 : Record 5050;
      Salesperson@1003 : Record 13;
      SegHeader@1004 : Record 5076;
      SegLine@1005 : Record 5077;
      Opp@1006 : Record 5092;
      AttendeeLineNo@1007 : Integer;
    BEGIN
      IF Task."Segment No." = '' THEN BEGIN
        IF Task.Type = Type::Meeting THEN
          IF Task."Team Code" = '' THEN BEGIN
            IF Salesperson.GET(Task."Salesperson Code") THEN
              Attendee.CreateAttendee(
                Attendee,
                Task."No.",10000,Attendee."Attendance Type"::"To-do Organizer",
                Attendee."Attendee Type"::Salesperson,
                Salesperson.Code,TRUE)
          END ELSE
            Task.CreateAttendeesFromTeam(
              Attendee,
              TeamMeetingOrganizer);

        IF Attendee.FIND('+') THEN
          AttendeeLineNo := Attendee."Line No." + 10000
        ELSE
          AttendeeLineNo := 10000;

        IF Cont.GET(Task."Contact No.") THEN
          Attendee.CreateAttendee(
            Attendee,
            Task."No.",AttendeeLineNo,Attendee."Attendance Type"::Required,
            Attendee."Attendee Type"::Contact,
            Cont."No.",Cont."E-Mail" <> '');
      END ELSE BEGIN
        IF Task.Type = Type::Meeting THEN
          IF Task."Team Code" = '' THEN BEGIN
            IF Salesperson.GET(Task."Salesperson Code") THEN
              Attendee.CreateAttendee(
                Attendee,
                Task."No.",10000,Attendee."Attendance Type"::"To-do Organizer",
                Attendee."Attendee Type"::Salesperson,
                Salesperson.Code,TRUE);
          END ELSE
            Task.CreateAttendeesFromTeam(Attendee,Task."Team Meeting Organizer");

        IF Attendee.FIND('+') THEN
          AttendeeLineNo := Attendee."Line No." + 10000
        ELSE
          AttendeeLineNo := 10000;

        IF Opp.GET(Task."Opportunity No.") THEN
          Attendee.CreateAttendee(
            Attendee,
            Task."No.",AttendeeLineNo,Attendee."Attendance Type"::Required,
            Attendee."Attendee Type"::Contact,
            Opp."Contact No.",
            (Cont.GET(Opp."Contact No.") AND
             (Cont."E-Mail" <> '')))
        ELSE
          IF SegHeader.GET(Task."Segment No.") THEN BEGIN
            SegLine.SETRANGE("Segment No.",Task."Segment No.");
            SegLine.SETFILTER("Contact No.",'=%1',Task."Contact No.");
            IF SegLine.FIND('-') THEN
              REPEAT
                Attendee.CreateAttendee(
                  Attendee,
                  Task."No.",AttendeeLineNo,Attendee."Attendance Type"::Required,
                  Attendee."Attendee Type"::Contact,
                  SegLine."Contact No.",
                  (Cont.GET(SegLine."Contact No.") AND
                   (Cont."E-Mail" <> '')));
                AttendeeLineNo := AttendeeLineNo + 10000;
              UNTIL SegLine.NEXT = 0;
          END;
      END;
    END;

    LOCAL PROCEDURE CreateTaskInteractLanguages@17(VAR TaskInteractLanguage@1000 : Record 5196;VAR Attachment@1001 : Record 5062;TaskNo@1002 : Code[20]);
    VAR
      TaskInteractLanguage2@1003 : Record 5196;
      Attachment2@1004 : Record 5062;
      MarketingSetup@1006 : Record 5079;
      AttachmentManagement@1005 : Codeunit 5052;
      FileName@1007 : Text;
    BEGIN
      IF TaskInteractLanguage.FIND('-') THEN
        REPEAT
          TaskInteractLanguage2.INIT;
          TaskInteractLanguage2."To-do No." := TaskNo;
          TaskInteractLanguage2."Language Code" := TaskInteractLanguage."Language Code";
          TaskInteractLanguage2.Description := TaskInteractLanguage.Description;
          IF TaskInteractLanguage."Attachment No." <> 0 THEN BEGIN
            Attachment.GET(TaskInteractLanguage."Attachment No.");
            Attachment2.GET(AttachmentManagement.InsertAttachment(0));
            Attachment2.TRANSFERFIELDS(Attachment,FALSE);
            Attachment.CALCFIELDS("Attachment File");
            Attachment2."Attachment File" := Attachment."Attachment File";
            Attachment2.WizSaveAttachment;
            Attachment2.MODIFY(TRUE);
            MarketingSetup.GET;
            IF MarketingSetup."Attachment Storage Type" = MarketingSetup."Attachment Storage Type"::"Disk File" THEN
              IF Attachment2."No." <> 0 THEN BEGIN
                FileName := Attachment2.ConstDiskFileName;
                IF FileName <> '' THEN
                  Attachment.ExportAttachmentToServerFile(FileName);
              END;
            TaskInteractLanguage2."Attachment No." := Attachment2."No.";
          END ELSE
            TaskInteractLanguage2."Attachment No." := 0;
          TaskInteractLanguage2.INSERT;
        UNTIL TaskInteractLanguage.NEXT = 0;
    END;

    [External]
    PROCEDURE AssignActivityFromTask@9(VAR Task@1007 : Record 5080);
    BEGIN
      INIT;
      SetFilterFromTask(Task);
      StartWizard2;
    END;

    LOCAL PROCEDURE InsertActivityTask@3(Task2@1000 : Record 5080;ActivityCode@1001 : Code[10];VAR Attendee@1004 : Record 5199);
    VAR
      ActivityStep@1002 : Record 5082;
      TaskDate@1003 : Date;
    BEGIN
      TaskDate := Task2.Date;
      ActivityStep.SETRANGE("Activity Code",ActivityCode);
      IF ActivityStep.FIND('-') THEN BEGIN
        REPEAT
          InsertActivityStepTask(Task2,ActivityStep,TaskDate,Attendee);
        UNTIL ActivityStep.NEXT = 0;
      END ELSE
        InsertActivityStepTask(Task2,ActivityStep,TaskDate,Attendee);
    END;

    LOCAL PROCEDURE InsertActivityStepTask@22(Task2@1010 : Record 5080;ActivityStep@1009 : Record 5082;TaskDate@1012 : Date;VAR Attendee2@1015 : Record 5199) TaskNo : Code[20];
    VAR
      TempTask@1011 : TEMPORARY Record 5080;
      InteractionTemplateSetup@1008 : Record 5122;
      InteractionTemplate@1007 : Record 5064;
      TempTaskInteractionLanguage@1006 : TEMPORARY Record 5196;
      TempAttachment@1005 : TEMPORARY Record 5062;
      TempAttendee@1004 : TEMPORARY Record 5199;
      TempRMCommentLine@1003 : TEMPORARY Record 5061;
    BEGIN
      TempTask.INIT;
      TempTask := Task2;
      TempTask.INSERT;
      IF NOT ActivityStep.ISEMPTY THEN BEGIN
        TempTask.Type := ActivityStep.Type;
        TempTask.Priority := ActivityStep.Priority;
        TempTask.Description := ActivityStep.Description;
        TempTask.Date := CALCDATE(ActivityStep."Date Formula",TaskDate);
      END;

      IF TempTask.Type = Type::Meeting THEN BEGIN
        IF NOT Attendee2.ISEMPTY THEN BEGIN
          Attendee2.SETRANGE("Attendance Type",Attendee2."Attendance Type"::"To-do Organizer");
          Attendee2.FIND('-')
        END;
        TempAttendee.DELETEALL;
        TempTask.VALIDATE("All Day Event",TRUE);

        InteractionTemplateSetup.GET;
        IF (InteractionTemplateSetup."Meeting Invitation" <> '') AND
           InteractionTemplate.GET(InteractionTemplateSetup."Meeting Invitation")
        THEN
          UpdateInteractionTemplate(
            TempTask,TempTaskInteractionLanguage,TempAttachment,InteractionTemplate.Code,TRUE);

        CreateAttendeesFromTask(TempAttendee,TempTask,Attendee2."Attendee No.");

        TempTask.VALIDATE("Contact No.",'');

        TaskNo := InsertTaskAndRelatedData(
            TempTask,TempTaskInteractionLanguage,TempAttachment,TempAttendee,TempRMCommentLine);
      END ELSE BEGIN
        TempAttendee.DELETEALL;
        CreateAttendeesFromTask(TempAttendee,TempTask,'');

        InsertTaskAndRelatedData(
          TempTask,TempTaskInteractionLanguage,TempAttachment,TempAttendee,TempRMCommentLine);
      END;
      TempTask.DELETE;
    END;

    LOCAL PROCEDURE SetFilterFromTask@35(VAR Task@1000 : Record 5080);
    VAR
      Cont@1006 : Record 5050;
      Salesperson@1005 : Record 13;
      Team@1004 : Record 5083;
      Campaign@1003 : Record 5071;
      Opp@1002 : Record 5092;
      SegHeader@1001 : Record 5076;
    BEGIN
      IF Cont.GET(Task.GETFILTER("Contact Company No.")) THEN BEGIN
        Cont.CheckIfPrivacyBlockedGeneric;
        VALIDATE("Contact No.",Cont."No.");
        "Salesperson Code" := Cont."Salesperson Code";
        SETRANGE("Contact Company No.","Contact No.");
      END;
      IF Cont.GET(Task.GETFILTER("Contact No.")) THEN BEGIN
        Cont.CheckIfPrivacyBlockedGeneric;
        VALIDATE("Contact No.",Cont."No.");
        "Salesperson Code" := Cont."Salesperson Code";
        SETRANGE("Contact No.","Contact No.");
      END;
      IF Salesperson.GET(Task.GETFILTER("Salesperson Code")) THEN BEGIN
        "Salesperson Code" := Salesperson.Code;
        SETRANGE("Salesperson Code","Salesperson Code");
      END;
      IF Team.GET(Task.GETFILTER("Team Code")) THEN BEGIN
        VALIDATE("Team Code",Team.Code);
        SETRANGE("Team Code","Team Code");
      END;
      IF Campaign.GET(Task.GETFILTER("Campaign No.")) THEN BEGIN
        "Campaign No." := Campaign."No.";
        "Salesperson Code" := Campaign."Salesperson Code";
        SETRANGE("Campaign No.","Campaign No.");
      END;
      IF Opp.GET(Task.GETFILTER("Opportunity No.")) THEN BEGIN
        VALIDATE("Opportunity No.",Opp."No.");
        "Contact No." := Opp."Contact No.";
        "Contact Company No." := Opp."Contact Company No.";
        "Campaign No." := Opp."Campaign No.";
        "Salesperson Code" := Opp."Salesperson Code";
        SETRANGE("Opportunity No.","Opportunity No.");
      END;
      IF SegHeader.GET(Task.GETFILTER("Segment No.")) THEN BEGIN
        VALIDATE("Segment No.",SegHeader."No.");
        "Campaign No." := SegHeader."Campaign No.";
        "Salesperson Code" := SegHeader."Salesperson Code";
        SETRANGE("Segment No.","Segment No.");
      END;
    END;

    [External]
    PROCEDURE CancelOpenTasks@6(OpportunityNo@1000 : Code[20]);
    VAR
      OldTask@1001 : Record 5080;
      OldTask2@1002 : Record 5080;
    BEGIN
      IF OpportunityNo = '' THEN
        EXIT;

      OldTask.RESET;
      OldTask.SETCURRENTKEY("Opportunity No.");
      OldTask.SETRANGE("Opportunity No.",OpportunityNo);
      OldTask.SETRANGE(Closed,FALSE);
      OldTask.SETRANGE(Canceled,FALSE);

      IF OldTask.FIND('-') THEN
        REPEAT
          OldTask2.GET(OldTask."No.");
          OldTask2.Recurring := FALSE;
          OldTask2.VALIDATE(Canceled,TRUE);
          OldTask2.MODIFY;
        UNTIL OldTask.NEXT = 0;
    END;

    LOCAL PROCEDURE CreateCommentLines@7(VAR RMCommentLine2@1001 : Record 5061;TaskNo@1000 : Code[20]);
    VAR
      RMCommentLine@1002 : Record 5061;
    BEGIN
      IF RMCommentLine2.FIND('-') THEN
        REPEAT
          RMCommentLine.INIT;
          RMCommentLine := RMCommentLine2;
          RMCommentLine."No." := TaskNo;
          RMCommentLine.INSERT;
        UNTIL RMCommentLine2.NEXT = 0;
    END;

    [External]
    PROCEDURE SetDuration@16(EndingDate@1000 : Date;EndingTime@1001 : Time);
    BEGIN
      IF (EndingDate < DMY2DATE(1,1,1900)) OR (EndingDate > DMY2DATE(31,12,2999)) THEN
        ERROR(Text006,DMY2DATE(1,1,1900),DMY2DATE(31,12,2999));
      IF NOT "All Day Event" AND (Type = Type::Meeting) THEN
        Duration := CREATEDATETIME(EndingDate,EndingTime) - CREATEDATETIME(Date,"Start Time")
      ELSE
        Duration := CREATEDATETIME(EndingDate + 1,0T) - CREATEDATETIME(Date,0T);

      VALIDATE(Duration);
    END;

    [External]
    PROCEDURE GetEndDateTime@18();
    BEGIN
      IF (Type <> Type::Meeting) OR "All Day Event" THEN
        IF "Start Time" <> 0T THEN
          TempEndDateTime := CREATEDATETIME(Date - 1,"Start Time") + Duration
        ELSE BEGIN
          TempEndDateTime := CREATEDATETIME(Date,0T) + Duration;
          IF "All Day Event" THEN
            TempEndDateTime := CREATEDATETIME(DT2DATE(TempEndDateTime - 1000),0T);
        END
      ELSE
        TempEndDateTime := CREATEDATETIME(Date,"Start Time") + Duration;

      "Ending Date" := DT2DATE(TempEndDateTime);
      IF "All Day Event" THEN
        "Ending Time" := 0T
      ELSE
        "Ending Time" := DT2TIME(TempEndDateTime);
    END;

    LOCAL PROCEDURE UpdateAttendeeTasks@12(OldTaskNo@1003 : Code[20]);
    VAR
      Task2@1001 : Record 5080;
      TempTask@1002 : TEMPORARY Record 5080;
    BEGIN
      Task2.SETCURRENTKEY("Organizer To-do No.","System To-do Type");
      Task2.SETRANGE("Organizer To-do No.",OldTaskNo);
      IF "Team Code" = '' THEN
        Task2.SETFILTER(
          "System To-do Type",
          '%1|%2',
          Task2."System To-do Type"::"Salesperson Attendee",
          Task2."System To-do Type"::"Contact Attendee")
      ELSE
        Task2.SETFILTER("System To-do Type",'<>%1',Task2."System To-do Type"::Team);
      IF Task2.FIND('-') THEN
        REPEAT
          TempTask.INIT;
          TempTask.TRANSFERFIELDS(Task2,FALSE);
          TempTask.INSERT;
          Task2.TRANSFERFIELDS(Rec,FALSE);
          Task2."System To-do Type" := TempTask."System To-do Type";
          IF Task2."System To-do Type" = Task2."System To-do Type"::"Contact Attendee" THEN
            Task2.VALIDATE("Contact No.",TempTask."Contact No.")
          ELSE
            Task2."Salesperson Code" := TempTask."Salesperson Code";
          IF Task2."No." <> OldTaskNo THEN
            Task2.MODIFY(TRUE);
          TempTask.DELETE;
        UNTIL Task2.NEXT = 0
    END;

    LOCAL PROCEDURE UpdateInteractionTemplate@13(VAR Task@1004 : Record 5080;VAR TaskInteractionLanguage@1007 : Record 5196;VAR Attachment@1001 : Record 5062;InteractTmplCode@1006 : Code[10];AttachmentTemporary@1005 : Boolean);
    VAR
      InteractTmpl@1002 : Record 5064;
      InteractTemplLanguage@1008 : Record 5103;
      Attachment2@1003 : Record 5062;
      AttachmentManagement@1000 : Codeunit 5052;
    BEGIN
      Task.MODIFY;
      TaskInteractionLanguage.SETRANGE("To-do No.",Task."No.");

      IF AttachmentTemporary THEN
        TaskInteractionLanguage.DELETEALL
      ELSE
        TaskInteractionLanguage.DELETEALL(TRUE);

      Task."Interaction Template Code" := InteractTmplCode;

      IF InteractTmpl.GET(Task."Interaction Template Code") THEN BEGIN
        Task."Language Code" := InteractTmpl."Language Code (Default)";
        Task.Subject := InteractTmpl.Description;
        Task."Unit Cost (LCY)" := InteractTmpl."Unit Cost (LCY)";
        Task."Unit Duration (Min.)" := InteractTmpl."Unit Duration (Min.)";
        IF Task."Campaign No." = '' THEN
          Task."Campaign No." := InteractTmpl."Campaign No.";

        IF AttachmentTemporary THEN
          Attachment.DELETEALL;

        InteractTemplLanguage.RESET;
        InteractTemplLanguage.SETRANGE("Interaction Template Code",Task."Interaction Template Code");
        IF InteractTemplLanguage.FIND('-') THEN
          REPEAT
            TaskInteractionLanguage.INIT;
            TaskInteractionLanguage."To-do No." := Task."No.";
            TaskInteractionLanguage."Language Code" := InteractTemplLanguage."Language Code";
            TaskInteractionLanguage.Description := InteractTemplLanguage.Description;
            IF Attachment2.GET(InteractTemplLanguage."Attachment No.") THEN BEGIN
              IF AttachmentTemporary THEN BEGIN
                Attachment.INIT;
                IF Attachment2."Storage Type" = Attachment2."Storage Type"::Embedded THEN
                  Attachment2.CALCFIELDS("Attachment File");
                Attachment.TRANSFERFIELDS(Attachment2);
                Attachment.INSERT;
                TaskInteractionLanguage."Attachment No." := Attachment."No.";
              END ELSE
                TaskInteractionLanguage."Attachment No." :=
                  AttachmentManagement.InsertAttachment(InteractTemplLanguage."Attachment No.");
            END;
            TaskInteractionLanguage.INSERT;
          UNTIL InteractTemplLanguage.NEXT = 0
        ELSE
          Task."Attachment No." := 0;
      END ELSE BEGIN
        Task."Language Code" := '';
        Task.Subject := '';
        Task."Unit Cost (LCY)" := 0;
        Task."Unit Duration (Min.)" := 0;
        Task."Attachment No." := 0;
      END;

      IF TaskInteractionLanguage.GET(Task."No.",Task."Language Code") THEN
        Task."Attachment No." := TaskInteractionLanguage."Attachment No.";

      Task.MODIFY;
    END;

    [Internal]
    PROCEDURE SendMAPIInvitations@21(Task@1000 : Record 5080;FromWizard@1019 : Boolean);
    VAR
      Attendee@1001 : Record 5199;
      NoToSend@1014 : Integer;
      NoNotSent@1016 : Integer;
      Selected@1018 : Integer;
      Options@1017 : Text[1024];
    BEGIN
      IF Task."System To-do Type" <> Task."System To-do Type"::Organizer THEN
        Task.GetMeetingOrganizerTask(Task);
      IF Task."Attachment No." = 0 THEN BEGIN
        Attendee.SETRANGE("To-do No.",Task."Organizer To-do No.");
        Attendee.SETRANGE("Send Invitation",TRUE);
        Attendee.SETRANGE("Attendee Type",Attendee."Attendee Type"::Contact);
        IF NOT Attendee.ISEMPTY THEN BEGIN
          Attendee.SETCURRENTKEY("To-do No.","Attendance Type");
          Attendee.SETRANGE("Send Invitation");
          Attendee.SETRANGE("Attendee Type");
          Attendee.SETRANGE("Attendance Type",Attendee."Attendance Type"::"To-do Organizer");
          IF NOT Attendee.ISEMPTY THEN
            ERROR(Text067,Task.TABLECAPTION,Attendee.TABLECAPTION)
        END;
        Attendee.RESET;
      END;

      Attendee.SETRANGE("To-do No.",Task."Organizer To-do No.");
      Attendee.SETFILTER("Attendance Type",'<>%1',Attendee."Attendance Type"::"To-do Organizer");
      Attendee.SETRANGE("Send Invitation",TRUE);

      IF NOT FromWizard THEN BEGIN
        NoToSend := Attendee.COUNT;
        Attendee.SETRANGE("Invitation Sent",FALSE);
        NoNotSent := Attendee.COUNT;
        IF NoToSend = 0 THEN
          ERROR(Text018,Attendee.FIELDCAPTION("Send Invitation"));
        IF (NoToSend > NoNotSent) AND (NoNotSent <> 0) THEN BEGIN
          Options :=
            STRSUBSTNO(
              Text019,Attendee.FIELDCAPTION("Send Invitation")) + ',' +
            Text020 + ',' +
            Text021;
          Selected := STRMENU(Options,1);
          IF Selected IN [0,3] THEN
            ERROR('');
        END;
        IF NoNotSent = 0 THEN BEGIN
          IF NOT CONFIRM(
               STRSUBSTNO(
                 Text022,Attendee.FIELDCAPTION("Send Invitation")),FALSE)
          THEN
            ERROR('');
        END;
        IF NoToSend = NoNotSent THEN BEGIN
          IF NOT CONFIRM(STRSUBSTNO(Text019,Attendee.FIELDCAPTION("Send Invitation")),FALSE) THEN
            ERROR('');
        END;

        Attendee.RESET;
        Attendee.SETRANGE("To-do No.",Task."Organizer To-do No.");
        Attendee.SETRANGE("Send Invitation",TRUE);
        IF Selected = 2 THEN
          Attendee.SETRANGE("Invitation Sent",FALSE);
      END;

      IF Attendee.FINDFIRST THEN
        ProcessAttendeeAppointment(Task,Attendee);
    END;

    [Internal]
    PROCEDURE CreateAttachment@23(PageNotEditable@1000 : Boolean);
    VAR
      TaskInteractionLanguage@1001 : Record 5196;
    BEGIN
      IF "Interaction Template Code" = '' THEN
        EXIT;
      IF NOT TaskInteractionLanguage.GET("Organizer To-do No.","Language Code") THEN BEGIN
        TaskInteractionLanguage.INIT;
        TaskInteractionLanguage."To-do No." := "Organizer To-do No.";
        TaskInteractionLanguage."Language Code" := "Language Code";
        TaskInteractionLanguage.INSERT(TRUE);
      END;
      IF TaskInteractionLanguage.CreateAttachment(PageNotEditable) THEN BEGIN
        "Attachment No." := TaskInteractionLanguage."Attachment No.";
        MODIFY(TRUE);
      END;
    END;

    [Internal]
    PROCEDURE OpenAttachment@24(PageNotEditable@1000 : Boolean);
    VAR
      TaskInteractionLanguage@1001 : Record 5196;
    BEGIN
      IF "Interaction Template Code" = '' THEN
        EXIT;
      IF TaskInteractionLanguage.GET("Organizer To-do No.","Language Code") THEN
        IF TaskInteractionLanguage."Attachment No." <> 0 THEN
          TaskInteractionLanguage.OpenAttachment(PageNotEditable);
      MODIFY(TRUE);
    END;

    [Internal]
    PROCEDURE ImportAttachment@26();
    VAR
      TaskInteractionLanguage@1000 : Record 5196;
    BEGIN
      IF "Interaction Template Code" = '' THEN
        EXIT;

      IF NOT TaskInteractionLanguage.GET("Organizer To-do No.","Language Code") THEN BEGIN
        TaskInteractionLanguage.INIT;
        TaskInteractionLanguage."To-do No." := "Organizer To-do No.";
        TaskInteractionLanguage."Language Code" := "Language Code";
        TaskInteractionLanguage.INSERT(TRUE);
      END;
      TaskInteractionLanguage.ImportAttachment;
      "Attachment No." := TaskInteractionLanguage."Attachment No.";
      MODIFY(TRUE);
    END;

    [Internal]
    PROCEDURE ExportAttachment@27();
    VAR
      TaskInteractionLanguage@1000 : Record 5196;
    BEGIN
      IF "Interaction Template Code" = '' THEN
        EXIT;

      IF TaskInteractionLanguage.GET("Organizer To-do No.","Language Code") THEN
        IF TaskInteractionLanguage."Attachment No." <> 0 THEN
          TaskInteractionLanguage.ExportAttachment;
    END;

    [Internal]
    PROCEDURE RemoveAttachment@28(Prompt@1000 : Boolean);
    VAR
      TaskInteractionLanguage@1001 : Record 5196;
    BEGIN
      IF "Interaction Template Code" = '' THEN
        EXIT;

      IF TaskInteractionLanguage.GET("Organizer To-do No.","Language Code") THEN
        IF TaskInteractionLanguage."Attachment No." <> 0 THEN
          IF TaskInteractionLanguage.RemoveAttachment(Prompt) THEN BEGIN
            "Attachment No." := 0;
            MODIFY(TRUE);
          END;
      MODIFY(TRUE);
    END;

    LOCAL PROCEDURE LogTaskInteraction@30(VAR Task@1006 : Record 5080;VAR Task2@1000 : Record 5080;Deliver@1010 : Boolean);
    VAR
      TempSegLine@1001 : TEMPORARY Record 5077;
      Cont@1002 : Record 5050;
      Salesperson@1003 : Record 13;
      Campaign@1004 : Record 5071;
      Attachment@1007 : Record 5062;
      TempAttachment@1008 : TEMPORARY Record 5062;
      TempInterLogEntryCommentLine@1009 : TEMPORARY Record 5123;
      SegManagement@1005 : Codeunit 5051;
    BEGIN
      IF Attachment.GET(Task."Attachment No.") THEN BEGIN
        TempAttachment.DELETEALL;
        TempAttachment.INIT;
        TempAttachment.WizEmbeddAttachment(Attachment);
        TempAttachment.INSERT;
      END;

      TempSegLine.DELETEALL;
      TempSegLine.INIT;
      TempSegLine."To-do No." := Task."Organizer To-do No.";
      TempSegLine.SETRANGE("To-do No.",TempSegLine."To-do No.");
      IF Cont.GET(Task2."Contact No.") THEN
        TempSegLine.VALIDATE("Contact No.",Task2."Contact No.");
      IF Salesperson.GET(Task."Salesperson Code") THEN
        TempSegLine."Salesperson Code" := Salesperson.Code;
      IF Campaign.GET(Task."Campaign No.") THEN
        TempSegLine."Campaign No." := Campaign."No.";
      TempSegLine."Interaction Template Code" := Task."Interaction Template Code";
      TempSegLine."Attachment No." := Task."Attachment No.";
      TempSegLine."Language Code" := Task."Language Code";
      TempSegLine.Subject := Task.Description;
      TempSegLine.Description := Task.Description;
      TempSegLine."Correspondence Type" := TempSegLine."Correspondence Type"::Email;
      TempSegLine."Cost (LCY)" := Task."Unit Cost (LCY)";
      TempSegLine."Duration (Min.)" := Task."Unit Duration (Min.)";
      TempSegLine."Opportunity No." := Task."Opportunity No.";
      TempSegLine.VALIDATE(Date,WORKDATE);

      TempSegLine.INSERT;
      SegManagement.LogInteraction(TempSegLine,TempAttachment,TempInterLogEntryCommentLine,Deliver,FALSE);
    END;

    [External]
    PROCEDURE CreateAttendeesFromTeam@33(VAR Attendee@1002 : Record 5199;TeamMeetingOrganizer@1000 : Code[20]);
    VAR
      TeamSalesperson@1003 : Record 5084;
      AttendeeLineNo@1004 : Integer;
    BEGIN
      IF TeamMeetingOrganizer = '' THEN
        EXIT;
      Attendee.CreateAttendee(
        Attendee,
        "No.",10000,Attendee."Attendance Type"::"To-do Organizer",
        Attendee."Attendee Type"::Salesperson,
        TeamMeetingOrganizer,
        TRUE);

      TeamSalesperson.SETRANGE("Team Code","Team Code");
      IF TeamSalesperson.FIND('-') THEN BEGIN
        AttendeeLineNo := 20000;
        REPEAT
          IF TeamSalesperson."Salesperson Code" <> TeamMeetingOrganizer THEN
            Attendee.CreateAttendee(
              Attendee,
              "No.",AttendeeLineNo,Attendee."Attendance Type"::Required,
              Attendee."Attendee Type"::Salesperson,
              TeamSalesperson."Salesperson Code",
              FALSE);
          AttendeeLineNo := AttendeeLineNo + 10000;
        UNTIL TeamSalesperson.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE ChangeTeam@37();
    VAR
      Task@1000 : Record 5080;
      TeamSalesperson@1001 : Record 5084;
      TeamSalespersonOld@1004 : Record 5084;
      TempAttendee@1002 : TEMPORARY Record 5199;
      Attendee@1003 : Record 5199;
      Salesperson@1007 : Record 13;
      AttendeeLineNo@1005 : Integer;
      SendInvitation@1006 : Boolean;
      TeamCode@1009 : Code[10];
    BEGIN
      MODIFY;
      TeamSalespersonOld.SETRANGE("Team Code",xRec."Team Code");
      TeamSalesperson.SETRANGE("Team Code","Team Code");
      IF TeamSalesperson.FIND('-') THEN
        REPEAT
          TeamSalesperson.MARK(TRUE)
        UNTIL TeamSalesperson.NEXT = 0;

      IF Type = Type::Meeting THEN BEGIN
        Attendee.SETCURRENTKEY("To-do No.","Attendee Type","Attendee No.");
        Attendee.SETRANGE("To-do No.","Organizer To-do No.");
        Attendee.SETRANGE("Attendee Type",Attendee."Attendee Type"::Salesperson);
        IF Attendee.FIND('-') THEN
          REPEAT
            TeamSalesperson.SETRANGE("Salesperson Code",Attendee."Attendee No.");
            IF TeamSalesperson.FIND('-') THEN
              TeamSalesperson.MARK(FALSE)
            ELSE
              IF Attendee."Attendance Type" <> Attendee."Attendance Type"::"To-do Organizer" THEN BEGIN
                TeamSalespersonOld.SETRANGE("Salesperson Code",Attendee."Attendee No.");
                IF TeamSalespersonOld.FINDFIRST THEN BEGIN
                  Attendee.MARK(TRUE);
                  DeleteAttendeeTask(Attendee)
                END
              END
          UNTIL Attendee.NEXT = 0;
        Attendee.MARKEDONLY(TRUE);
        Attendee.DELETEALL
      END ELSE BEGIN
        Task.SETCURRENTKEY("Organizer To-do No.","System To-do Type");
        Task.SETRANGE("Organizer To-do No.","Organizer To-do No.");
        Task.SETFILTER("System To-do Type",'%1|%2',
          Task."System To-do Type"::Organizer,
          Task."System To-do Type"::"Salesperson Attendee");
        IF Task.FIND('-') THEN
          REPEAT
            TeamSalesperson.SETRANGE("Salesperson Code",Task."Salesperson Code");
            IF TeamSalesperson.FIND('-') THEN
              TeamSalesperson.MARK(FALSE)
            ELSE
              Task.DELETE(TRUE)
          UNTIL Task.NEXT = 0
      END;

      TeamCode := "Team Code";
      GET("No.");
      "Team Code" := TeamCode;

      TeamSalesperson.MARKEDONLY(TRUE);
      TeamSalesperson.SETRANGE("Salesperson Code");
      IF TeamSalesperson.FIND('-') THEN BEGIN
        IF Type = Type::Meeting THEN
          REPEAT
            Attendee.RESET;
            Attendee.SETRANGE("To-do No.","Organizer To-do No.");
            IF Attendee.FIND('+') THEN
              AttendeeLineNo := Attendee."Line No." + 10000
            ELSE
              AttendeeLineNo := 10000;
            IF Salesperson.GET(TeamSalesperson."Salesperson Code") THEN
              IF Salesperson."E-Mail" <> '' THEN
                SendInvitation := TRUE
              ELSE
                SendInvitation := FALSE;
            Attendee.CreateAttendee(
              Attendee,
              "Organizer To-do No.",AttendeeLineNo,
              Attendee."Attendance Type"::Required,
              Attendee."Attendee Type"::Salesperson,
              TeamSalesperson."Salesperson Code",SendInvitation);
            CreateSubTask(Attendee,Rec)
          UNTIL TeamSalesperson.NEXT = 0
        ELSE
          REPEAT
            TempAttendee.CreateAttendee(
              TempAttendee,
              "No.",10000,
              TempAttendee."Attendance Type"::"To-do Organizer",
              TempAttendee."Attendee Type"::Salesperson,
              TeamSalesperson."Salesperson Code",
              TRUE);
            CreateSubTask(TempAttendee,Rec);
            TempAttendee.DELETEALL
          UNTIL TeamSalesperson.NEXT = 0
      END;
      MODIFY(TRUE)
    END;

    LOCAL PROCEDURE ReassignTeamTaskToSalesperson@38();
    VAR
      Task@1000 : Record 5080;
      Attendee@1001 : Record 5199;
      AttendeeLineNo@1002 : Integer;
      SalespersonCode@1005 : Code[20];
    BEGIN
      MODIFY;
      IF Type = Type::Meeting THEN BEGIN
        Task.SETCURRENTKEY("Organizer To-do No.","System To-do Type");
        Task.SETRANGE("Organizer To-do No.","No.");
        Task.SETRANGE("Salesperson Code","Salesperson Code");
        IF Task.FINDFIRST THEN BEGIN
          Attendee.SETCURRENTKEY("To-do No.","Attendee Type","Attendee No.");
          Attendee.SETRANGE("To-do No.","No.");
          Attendee.SETRANGE("Attendee Type",Attendee."Attendee Type"::Salesperson);
          Attendee.SETRANGE("Attendee No.","Salesperson Code");
          IF Attendee.FINDFIRST THEN
            IF Attendee."Attendance Type" = Attendee."Attendance Type"::"To-do Organizer" THEN BEGIN
              Attendee.DELETE;
              Task.DELETE;
            END ELSE
              Attendee.DELETE(TRUE)
        END;

        SalespersonCode := "Salesperson Code";
        GET("No.");
        "Salesperson Code" := SalespersonCode;

        Task.SETRANGE("Salesperson Code");
        Task.SETRANGE("System To-do Type","System To-do Type"::Organizer);
        IF Task.FINDFIRST THEN BEGIN
          Attendee.RESET;
          Attendee.SETCURRENTKEY("To-do No.","Attendee Type","Attendee No.");
          Attendee.SETRANGE("To-do No.","No.");
          Attendee.SETRANGE("Attendee Type",Attendee."Attendee Type"::Salesperson);
          Attendee.SETRANGE("Attendee No.",Task."Salesperson Code");
          IF Attendee.FINDFIRST THEN BEGIN
            Attendee."Attendance Type" := Attendee."Attendance Type"::Required;
            Attendee.MODIFY
          END;
          Task."System To-do Type" := Task."System To-do Type"::"Salesperson Attendee";
          Task.MODIFY(TRUE)
        END;

        Attendee.RESET;
        Attendee.SETRANGE("To-do No.","No.");
        IF Attendee.FINDLAST THEN
          AttendeeLineNo := Attendee."Line No." + 10000
        ELSE
          AttendeeLineNo := 10000;
        Attendee.CreateAttendee(
          Attendee,"No.",AttendeeLineNo,
          Attendee."Attendance Type"::"To-do Organizer",
          Attendee."Attendee Type"::Salesperson,
          "Salesperson Code",TRUE);
        ArrangeOrganizerAttendee;
      END ELSE BEGIN
        Task.SETCURRENTKEY("Organizer To-do No.","System To-do Type");
        Task.SETRANGE("Organizer To-do No.","No.");
        Task.SETRANGE("System To-do Type","System To-do Type"::Organizer);
        IF Task.FINDFIRST THEN
          Task.DELETEALL(TRUE);

        IF "Contact No." <> '' THEN BEGIN
          Task.SETRANGE("System To-do Type","System To-do Type"::"Contact Attendee");
          IF Task.FINDFIRST THEN BEGIN
            Task."Salesperson Code" := "Salesperson Code";
            Task.MODIFY(TRUE)
          END
        END
      END;

      "System To-do Type" := "System To-do Type"::Organizer;
      "Team Code" := '';
      MODIFY(TRUE);
    END;

    LOCAL PROCEDURE ReassignSalespersonTaskToTeam@36();
    VAR
      TeamSalesperson@1000 : Record 5084;
      Attendee@1001 : Record 5199;
      TempAttendee@1002 : TEMPORARY Record 5199;
      Task@1003 : Record 5080;
      AttendeeLineNo@1004 : Integer;
      SendInvitation@1005 : Boolean;
      SalespersonCode@1006 : Code[20];
      TaskNo@1007 : Code[20];
    BEGIN
      MODIFY;
      SalespersonCode := "Salesperson Code";
      "Salesperson Code" := '';
      "System To-do Type" := "System To-do Type"::Team;
      MODIFY;

      Task.SETCURRENTKEY("Organizer To-do No.","System To-do Type");
      Task.SETRANGE("Organizer To-do No.","No.");

      IF Type = Type::Meeting THEN BEGIN
        Attendee.SETRANGE("To-do No.","No.");
        Attendee.SETRANGE("Attendance Type",Attendee."Attendance Type"::"To-do Organizer");
        IF Attendee.FINDFIRST THEN BEGIN
          Attendee."Attendance Type" := Attendee."Attendance Type"::Required;
          TaskNo := CreateSubTask(Attendee,Rec);
          Attendee."Attendance Type" := Attendee."Attendance Type"::"To-do Organizer";
          Attendee.MODIFY;
          IF Task.GET(TaskNo) THEN BEGIN
            Task."System To-do Type" := Task."System To-do Type"::Organizer;
            Task.MODIFY;
          END
        END;

        Task.SETFILTER("System To-do Type",'<>%1',Task."System To-do Type"::"Contact Attendee");
        TeamSalesperson.SETRANGE("Team Code","Team Code");
        IF TeamSalesperson.FIND('-') THEN
          REPEAT
            Task.SETRANGE("Salesperson Code",TeamSalesperson."Salesperson Code");
            IF Task.FINDFIRST THEN BEGIN
              IF (Task."System To-do Type" = Task."System To-do Type"::Organizer) AND
                 (Task."Salesperson Code" <> SalespersonCode)
              THEN BEGIN
                Task."System To-do Type" := Task."System To-do Type"::"Salesperson Attendee";
                MODIFY(TRUE)
              END
            END ELSE BEGIN
              Attendee.RESET;
              Attendee.SETRANGE("To-do No.","No.");
              IF Attendee.FINDLAST THEN
                AttendeeLineNo := Attendee."Line No." + 10000
              ELSE
                AttendeeLineNo := 10000;
              IF Salesperson.GET(TeamSalesperson."Salesperson Code") THEN
                IF Salesperson."E-Mail" <> '' THEN
                  SendInvitation := TRUE
                ELSE
                  SendInvitation := FALSE;
              Attendee.CreateAttendee(
                Attendee,"No.",AttendeeLineNo,
                Attendee."Attendance Type"::Required,
                Attendee."Attendee Type"::Salesperson,
                TeamSalesperson."Salesperson Code",
                SendInvitation);
              CreateSubTask(Attendee,Rec)
            END
          UNTIL TeamSalesperson.NEXT = 0
      END ELSE BEGIN
        TeamSalesperson.SETRANGE("Team Code","Team Code");
        IF TeamSalesperson.FIND('-') THEN
          REPEAT
            TempAttendee.CreateAttendee(
              TempAttendee,
              "No.",10000,
              TempAttendee."Attendance Type"::"To-do Organizer",
              TempAttendee."Attendee Type"::Salesperson,
              TeamSalesperson."Salesperson Code",
              TRUE);
            CreateSubTask(TempAttendee,Rec);
            TempAttendee.DELETEALL
          UNTIL TeamSalesperson.NEXT = 0;
      END;

      MODIFY(TRUE)
    END;

    [External]
    PROCEDURE GetMeetingOrganizerTask@39(VAR Task@1000 : Record 5080);
    BEGIN
      IF Type = Type::Meeting THEN
        IF "Team Code" <> '' THEN BEGIN
          Task.SETCURRENTKEY("Organizer To-do No.","System To-do Type");
          Task.SETRANGE("Organizer To-do No.","Organizer To-do No.");
          Task.SETRANGE("System To-do Type","System To-do Type"::Organizer);
          Task.FIND('-')
        END ELSE
          Task.GET("Organizer To-do No.")
    END;

    [External]
    PROCEDURE ArrangeOrganizerAttendee@40();
    VAR
      Attendee@1000 : Record 5199;
      FirstLineNo@1001 : Integer;
      LastLineNo@1002 : Integer;
      OrganizerLineNo@1003 : Integer;
    BEGIN
      Attendee.SETRANGE("To-do No.","No.");
      IF NOT Attendee.FINDFIRST THEN
        EXIT;
      FirstLineNo := Attendee."Line No.";
      Attendee.FINDLAST;
      LastLineNo := Attendee."Line No.";

      Attendee.SETCURRENTKEY("To-do No.","Attendance Type");
      Attendee.SETRANGE("Attendance Type",Attendee."Attendance Type"::"To-do Organizer");
      Attendee.FINDFIRST;
      OrganizerLineNo := Attendee."Line No.";

      IF FirstLineNo <> OrganizerLineNo THEN BEGIN
        Attendee.RENAME("No.",LastLineNo + 1);
        Attendee.GET("No.",FirstLineNo);
        Attendee.RENAME("No.",OrganizerLineNo);
        Attendee.GET("No.",LastLineNo + 1);
        Attendee.RENAME("No.",FirstLineNo)
      END
    END;

    LOCAL PROCEDURE StartWizard@48();
    BEGIN
      "Wizard Step" := "Wizard Step"::"1";

      "Wizard Contact Name" := GetContactName;
      IF Campaign.GET("Campaign No.") THEN
        "Wizard Campaign Description" := Campaign.Description;
      IF Opp.GET("Opportunity No.") THEN
        "Wizard Opportunity Description" := Opp.Description;
      IF SegHeader.GET(GETFILTER("Segment No.")) THEN
        "Segment Description" := SegHeader.Description;
      IF Team.GET(GETFILTER("Team Code")) THEN
        "Team To-do" := TRUE;

      Duration := 1440 * 1000 * 60;
      Date := TODAY;
      GetEndDateTime;

      INSERT;
      IF PAGE.RUNMODAL(PAGE::"Create Task",Rec) = ACTION::OK THEN;
    END;

    [External]
    PROCEDURE CheckStatus@42();
    VAR
      Salesperson@1001 : Record 13;
    BEGIN
      IF Date = 0D THEN
        ErrorMessage(FIELDCAPTION(Date));

      IF Description = '' THEN
        ErrorMessage(FIELDCAPTION(Description));

      IF "Team To-do" AND ("Team Code" = '') THEN
        ErrorMessage(FIELDCAPTION("Team Code"));

      IF NOT "Team To-do" AND ("Salesperson Code" = '') THEN
        ErrorMessage(FIELDCAPTION("Salesperson Code"));

      IF Type = Type::Meeting THEN BEGIN
        IF NOT "All Day Event" THEN BEGIN
          IF "Start Time" = 0T THEN
            ErrorMessage(FIELDCAPTION("Start Time"));
          IF Duration = 0 THEN
            ErrorMessage(FIELDCAPTION(Duration));
        END;

        IF ("Interaction Template Code" = '') AND "Send on finish" THEN
          ErrorMessage(FIELDCAPTION("Interaction Template Code"));

        TempAttendee.RESET;
        TempAttendee.SETRANGE("Attendance Type",TempAttendee."Attendance Type"::"To-do Organizer");
        IF TempAttendee.ISEMPTY THEN BEGIN
          TempAttendee.RESET;
          ERROR(Text065);
        END;

        IF TempAttendee.FIND('-') THEN
          Salesperson.GET(TempAttendee."Attendee No.");
        TempAttendee.RESET;
        IF ("Attachment No." = 0) AND "Send on finish" THEN BEGIN
          TempAttendee.SETRANGE("Send Invitation",TRUE);
          TempAttendee.SETRANGE("Attendee Type",TempAttendee."Attendee Type"::Contact);
          IF NOT TempAttendee.ISEMPTY THEN BEGIN
            TempAttendee.RESET;
            ERROR(Text067,TABLECAPTION,TempAttendee.TABLECAPTION);
          END;
          TempAttendee.RESET;
        END;
        TempAttendee.RESET;
        IF "Send on finish" THEN BEGIN
          TempAttendee.SETRANGE("Send Invitation",TRUE);
          IF TempAttendee.ISEMPTY THEN BEGIN
            TempAttendee.RESET;
            ERROR(Text068,TempAttendee.FIELDCAPTION("Send Invitation"));
          END;
          TempAttendee.RESET;
        END;
      END;

      IF (Location = '') AND "Send on finish" THEN
        ErrorMessage(FIELDCAPTION(Location));
    END;

    [Internal]
    PROCEDURE FinishWizard@41(SendExchangeAppointment@1002 : Boolean);
    VAR
      SegLine@1000 : Record 5077;
      SendOnFinish@1001 : Boolean;
    BEGIN
      CreateExchangeAppointment := SendExchangeAppointment;
      IF Recurring THEN BEGIN
        TESTFIELD("Recurring Date Interval");
        TESTFIELD("Calc. Due Date From");
      END;
      IF Type = Type::Meeting THEN BEGIN
        IF NOT "Team To-do" THEN BEGIN
          TempAttendee.SETRANGE("Attendance Type",TempAttendee."Attendance Type"::"To-do Organizer");
          TempAttendee.FIND('-');
          VALIDATE("Salesperson Code",TempAttendee."Attendee No.");
          TempAttendee.RESET;
        END;
        VALIDATE("Contact No.",'');
      END ELSE BEGIN
        IF Cont.GET("Contact No.") THEN
          TempAttendee.CreateAttendee(
            TempAttendee,
            "No.",10000,TempAttendee."Attendance Type"::Required,
            TempAttendee."Attendee Type"::Contact,
            Cont."No.",Cont."E-Mail" <> '');
        IF SegHeader.GET("Segment No.") THEN BEGIN
          SegLine.SETRANGE("Segment No.","Segment No.");
          SegLine.SETFILTER("Contact No.",'<>%1','');
          IF SegLine.FIND('-') THEN
            REPEAT
              TempAttendee.CreateAttendee(
                TempAttendee,
                "No.",SegLine."Line No.",TempAttendee."Attendance Type"::Required,
                TempAttendee."Attendee Type"::Contact,
                SegLine."Contact No.",
                (Cont.GET(SegLine."Contact No.") AND
                 (Cont."E-Mail" <> '')));
            UNTIL SegLine.NEXT = 0;
        END;
      END;

      SendOnFinish := "Send on finish";
      "Wizard Step" := "Wizard Step"::" ";
      "Team To-do" := FALSE;
      "Send on finish" := FALSE;
      "Segment Description" := '';
      "Team Meeting Organizer" := '';
      "Activity Code" := '';
      "Wizard Contact Name" := '';
      "Wizard Campaign Description" := '';
      "Wizard Opportunity Description" := '';
      MODIFY;
      InsertTask(Rec,TempRMCommentLine,TempAttendee,TempTaskInteractionLanguage,TempAttachment,'',SendOnFinish);
      DELETE;
    END;

    LOCAL PROCEDURE GetContactName@65() : Text[50];
    BEGIN
      IF Cont.GET("Contact No.") THEN
        EXIT(Cont.Name);
      IF Cont.GET("Contact Company No.") THEN
        EXIT(Cont.Name);
    END;

    LOCAL PROCEDURE ErrorMessage@47(FieldName@1000 : Text[1024]);
    BEGIN
      ERROR(Text043,FieldName);
    END;

    [Internal]
    PROCEDURE AssignDefaultAttendeeInfo@46();
    VAR
      InteractionTemplate@1002 : Record 5064;
      InteractionTemplateSetup@1001 : Record 5122;
      SegLine@1003 : Record 5077;
      TeamSalesperson@1004 : Record 5084;
      Salesperson@1000 : Record 13;
      AttendeeLineNo@1005 : Integer;
    BEGIN
      IF TempAttendee.FIND('+') THEN
        AttendeeLineNo := TempAttendee."Line No." + 10000
      ELSE
        AttendeeLineNo := 10000;
      CASE TRUE OF
        (GETFILTER("Contact No.") <> '') AND (GETFILTER("Salesperson Code") <> ''):
          BEGIN
            IF Salesperson.GET(GETFILTER("Salesperson Code")) THEN BEGIN
              TempAttendee.CreateAttendee(
                TempAttendee,
                "No.",AttendeeLineNo,
                TempAttendee."Attendance Type"::"To-do Organizer",
                TempAttendee."Attendee Type"::Salesperson,
                Salesperson.Code,TRUE);
              AttendeeLineNo += 10000;
            END;
            IF Cont.GET(GETFILTER("Contact No.")) THEN BEGIN
              TempAttendee.CreateAttendee(
                TempAttendee,
                "No.",AttendeeLineNo,
                TempAttendee."Attendance Type"::Required,
                TempAttendee."Attendee Type"::Contact,
                Cont."No.",
                Cont."E-Mail" <> '');
              AttendeeLineNo += 10000;
            END;
          END;
        (GETFILTER("Contact No.") <> '') AND (GETFILTER("Campaign No.") <> ''):
          BEGIN
            IF Campaign.GET(GETFILTER("Campaign No.")) THEN
              IF Salesperson.GET(Campaign."Salesperson Code") THEN BEGIN
                TempAttendee.CreateAttendee(
                  TempAttendee,
                  "No.",AttendeeLineNo,
                  TempAttendee."Attendance Type"::"To-do Organizer",
                  TempAttendee."Attendee Type"::Salesperson,
                  Salesperson.Code,TRUE);
                AttendeeLineNo += 10000
              END;
            IF Cont.GET(GETFILTER("Contact No.")) THEN BEGIN
              TempAttendee.CreateAttendee(
                TempAttendee,
                "No.",AttendeeLineNo,
                TempAttendee."Attendance Type"::Required,
                TempAttendee."Attendee Type"::Contact,
                Cont."No.",Cont."E-Mail" <> '');
              AttendeeLineNo += 10000;
            END;
          END
        ELSE BEGIN
          IF Cont.GET(GETFILTER("Contact No.")) THEN BEGIN
            IF Cont."Salesperson Code" <> '' THEN BEGIN
              TempAttendee.CreateAttendee(
                TempAttendee,
                "No.",AttendeeLineNo,
                TempAttendee."Attendance Type"::"To-do Organizer",
                TempAttendee."Attendee Type"::Salesperson,
                Cont."Salesperson Code",TRUE);
              AttendeeLineNo += 10000
            END;
            TempAttendee.CreateAttendee(
              TempAttendee,
              "No.",AttendeeLineNo,
              TempAttendee."Attendance Type"::Required,
              TempAttendee."Attendee Type"::Contact,
              Cont."No.",Cont."E-Mail" <> '');
            AttendeeLineNo += 10000;
          END ELSE
            IF Cont.GET(GETFILTER("Contact Company No.")) THEN BEGIN
              IF Cont."Salesperson Code" <> '' THEN BEGIN
                TempAttendee.CreateAttendee(
                  TempAttendee,
                  "No.",AttendeeLineNo,
                  TempAttendee."Attendance Type"::"To-do Organizer",
                  TempAttendee."Attendee Type"::Salesperson,
                  Cont."Salesperson Code",TRUE);
                AttendeeLineNo += 10000
              END;
              TempAttendee.CreateAttendee(
                TempAttendee,
                "No.",AttendeeLineNo,
                TempAttendee."Attendance Type"::Required,
                TempAttendee."Attendee Type"::Contact,
                Cont."No.",Cont."E-Mail" <> '');
              AttendeeLineNo += 10000;
            END;

          IF Salesperson.GET(GETFILTER("Salesperson Code")) THEN BEGIN
            TempAttendee.CreateAttendee(
              TempAttendee,
              "No.",AttendeeLineNo,
              TempAttendee."Attendance Type"::"To-do Organizer",
              TempAttendee."Attendee Type"::Salesperson,
              Salesperson.Code,TRUE);
            AttendeeLineNo += 10000;
          END;

          IF Campaign.GET(GETFILTER("Campaign No.")) THEN
            IF Salesperson.GET(Campaign."Salesperson Code") THEN BEGIN
              TempAttendee.CreateAttendee(
                TempAttendee,
                "No.",AttendeeLineNo,
                TempAttendee."Attendance Type"::"To-do Organizer",
                TempAttendee."Attendee Type"::Salesperson,
                Salesperson.Code,TRUE);
              AttendeeLineNo += 10000
            END;

          IF Opp.GET(GETFILTER("Opportunity No.")) THEN BEGIN
            IF Salesperson.GET(Opp."Salesperson Code") THEN BEGIN
              TempAttendee.CreateAttendee(
                TempAttendee,
                "No.",AttendeeLineNo,
                TempAttendee."Attendance Type"::"To-do Organizer",
                TempAttendee."Attendee Type"::Salesperson,
                Salesperson.Code,TRUE);
              AttendeeLineNo += 10000
            END;
            IF Cont.GET(Opp."Contact No.") THEN BEGIN
              TempAttendee.CreateAttendee(
                TempAttendee,
                "No.",AttendeeLineNo,
                TempAttendee."Attendance Type"::Required,
                TempAttendee."Attendee Type"::Contact,
                Cont."No.",Cont."E-Mail" <> '');
              AttendeeLineNo += 10000
            END;
          END;
        END;
      END;

      IF SegHeader.GET(GETFILTER("Segment No.")) THEN BEGIN
        IF Salesperson.GET(SegHeader."Salesperson Code") THEN BEGIN
          TempAttendee.CreateAttendee(
            TempAttendee,
            "No.",AttendeeLineNo,
            TempAttendee."Attendance Type"::"To-do Organizer",
            TempAttendee."Attendee Type"::Salesperson,
            Salesperson.Code,TRUE);
          AttendeeLineNo += 10000
        END;
        SegLine.SETRANGE("Segment No.","Segment No.");
        SegLine.SETFILTER("Contact No.",'<>%1','');
        IF SegLine.FIND('-') THEN
          REPEAT
            TempAttendee.CreateAttendee(
              TempAttendee,
              "No.",AttendeeLineNo,
              TempAttendee."Attendance Type"::Required,
              TempAttendee."Attendee Type"::Contact,
              SegLine."Contact No.",
              (Cont.GET(SegLine."Contact No.") AND
               (Cont."E-Mail" <> '')));
            AttendeeLineNo += 10000
          UNTIL SegLine.NEXT = 0;
      END;
      IF Team.GET("Team Code") THEN BEGIN
        TeamSalesperson.SETRANGE("Team Code",Team.Code);
        IF TeamSalesperson.FIND('-') THEN
          REPEAT
            TempAttendee.SETRANGE("Attendee Type",TempAttendee."Attendee Type"::Salesperson);
            TempAttendee.SETRANGE("Attendee No.",TeamSalesperson."Salesperson Code");
            IF NOT TempAttendee.FIND('-') THEN
              IF Salesperson.GET(TeamSalesperson."Salesperson Code") THEN BEGIN
                TempAttendee.RESET;
                TempAttendee.CreateAttendee(
                  TempAttendee,
                  "No.",AttendeeLineNo,
                  TempAttendee."Attendance Type"::Required,
                  TempAttendee."Attendee Type"::Salesperson,
                  TeamSalesperson."Salesperson Code",
                  Salesperson."E-Mail" <> '');
                AttendeeLineNo += 10000
              END;
            TempAttendee.RESET;
          UNTIL TeamSalesperson.NEXT = 0;
      END;

      InteractionTemplateSetup.GET;
      IF (InteractionTemplateSetup."Meeting Invitation" <> '') AND
         InteractionTemplate.GET(InteractionTemplateSetup."Meeting Invitation")
      THEN
        UpdateInteractionTemplate(
          Rec,TempTaskInteractionLanguage,TempAttachment,InteractionTemplate.Code,TRUE);
    END;

    [Internal]
    PROCEDURE ValidateInteractionTemplCode@66();
    BEGIN
      UpdateInteractionTemplate(
        Rec,TempTaskInteractionLanguage,TempAttachment,"Interaction Template Code",TRUE);
      LoadTempAttachment;
    END;

    [Internal]
    PROCEDURE AssistEditAttachment@58();
    BEGIN
      IF TempAttachment.GET("Attachment No.") THEN BEGIN
        TempAttachment.OpenAttachment("Interaction Template Code" + ' ' + Description,TRUE,"Language Code");
        TempAttachment.MODIFY;
      END ELSE
        ERROR(Text047);
    END;

    [External]
    PROCEDURE ValidateLanguageCode@67();
    BEGIN
      IF "Language Code" = xRec."Language Code" THEN
        EXIT;

      IF NOT TempTaskInteractionLanguage.GET("No.","Language Code") THEN BEGIN
        IF "No." = '' THEN
          ERROR(Text009,TempTaskInteractionLanguage.TABLECAPTION);
      END ELSE
        "Attachment No." := TempTaskInteractionLanguage."Attachment No.";
    END;

    [External]
    PROCEDURE LookupLanguageCode@68();
    BEGIN
      TempTaskInteractionLanguage.SETFILTER("To-do No.",'');
      IF TempTaskInteractionLanguage.GET('',"Language Code") THEN
        IF PAGE.RUNMODAL(0,TempTaskInteractionLanguage) = ACTION::LookupOK THEN BEGIN
          "Language Code" := TempTaskInteractionLanguage."Language Code";
          "Attachment No." := TempTaskInteractionLanguage."Attachment No.";
        END;
    END;

    [Internal]
    PROCEDURE LoadTempAttachment@45();
    VAR
      Attachment@1000 : Record 5062;
      TempAttachment2@1001 : TEMPORARY Record 5062;
    BEGIN
      IF TempAttachment.FINDSET THEN
        REPEAT
          TempAttachment2 := TempAttachment;
          TempAttachment2.INSERT;
        UNTIL TempAttachment.NEXT = 0;

      IF TempAttachment2.FINDSET THEN
        REPEAT
          Attachment.GET(TempAttachment2."No.");
          Attachment.CALCFIELDS("Attachment File");
          TempAttachment.GET(TempAttachment2."No.");
          TempAttachment.WizEmbeddAttachment(Attachment);
          TempAttachment."No." := TempAttachment2."No.";
          TempAttachment.MODIFY;
        UNTIL TempAttachment2.NEXT = 0;
    END;

    [External]
    PROCEDURE ClearDefaultAttendeeInfo@44();
    BEGIN
      TempAttendee.DELETEALL;
      TempAttachment.DELETEALL;
      TempTaskInteractionLanguage.DELETEALL;
      "Interaction Template Code" := '';
      "Language Code" := '';
      "Attachment No." := 0;
      Subject := '';
      "Unit Cost (LCY)" := 0;
      "Unit Duration (Min.)" := 0;
      MODIFY;
    END;

    [External]
    PROCEDURE GetAttendee@59(VAR Attendee@1000 : Record 5199);
    BEGIN
      Attendee.DELETEALL;
      IF TempAttendee.FIND('-') THEN
        REPEAT
          Attendee := TempAttendee;
          Attendee.INSERT;
        UNTIL TempAttendee.NEXT = 0;
    END;

    [External]
    PROCEDURE SetAttendee@49(VAR Attendee@1000 : Record 5199);
    BEGIN
      TempAttendee.DELETEALL;

      IF Attendee.FINDSET THEN
        REPEAT
          TempAttendee := Attendee;
          TempAttendee.INSERT;
        UNTIL Attendee.NEXT = 0;
    END;

    [External]
    PROCEDURE SetComments@53(VAR RMCommentLine@1001 : Record 5061);
    BEGIN
      TempRMCommentLine.DELETEALL;
      IF RMCommentLine.FINDSET THEN
        REPEAT
          TempRMCommentLine := RMCommentLine;
          TempRMCommentLine.INSERT;
        UNTIL RMCommentLine.NEXT = 0;
    END;

    LOCAL PROCEDURE StartWizard2@63();
    BEGIN
      "Wizard Contact Name" := GetContactName;
      IF Cont.GET(GETFILTER("Contact No.")) THEN
        "Wizard Contact Name" := Cont.Name
      ELSE
        IF Cont.GET(GETFILTER("Contact Company No.")) THEN
          "Wizard Contact Name" := Cont.Name;

      IF Campaign.GET(GETFILTER("Campaign No.")) THEN
        "Wizard Campaign Description" := Campaign.Description;

      IF SegHeader.GET(GETFILTER("Segment No.")) THEN
        "Segment Description" := SegHeader.Description;

      "Wizard Step" := "Wizard Step"::"1";
      Duration := 1440 * 1000 * 60;

      INSERT;

      IF PAGE.RUNMODAL(PAGE::"Assign Activity",Rec) = ACTION::OK THEN;
    END;

    [External]
    PROCEDURE CheckAssignActivityStatus@60();
    BEGIN
      IF "Activity Code" = '' THEN
        ErrorMessage(Text051);
      IF Date = 0D THEN
        ErrorMessage(FIELDCAPTION(Date));
      IF ("Team Code" = '') AND ("Salesperson Code" = '') THEN
        ERROR(Text053,FIELDCAPTION("Salesperson Code"),FIELDCAPTION("Team Code"));
      IF ("Team Code" <> '') AND
         Activity.IncludesMeeting("Activity Code") AND
         ("Team Meeting Organizer" = '')
      THEN
        ERROR(Text056,"Activity Code");
    END;

    PROCEDURE FinishAssignActivity@54();
    VAR
      TempRMCommentLine@1003 : TEMPORARY Record 5061;
      TempAttendee@1002 : TEMPORARY Record 5199;
      TempTaskInteractionLanguage@1001 : TEMPORARY Record 5196;
      TempAttachment@1000 : TEMPORARY Record 5062;
    BEGIN
      TempAttendee.DELETEALL;
      IF "Team Meeting Organizer" <> '' THEN
        TempAttendee.CreateAttendee(
          TempAttendee,
          "No.",10000,TempAttendee."Attendance Type"::"To-do Organizer",
          TempAttendee."Attendee Type"::Salesperson,
          "Team Meeting Organizer",
          TRUE)
      ELSE
        IF "Salesperson Code" <> '' THEN
          TempAttendee.CreateAttendee(
            TempAttendee,
            "No.",10000,TempAttendee."Attendance Type"::"To-do Organizer",
            TempAttendee."Attendee Type"::Salesperson,
            "Salesperson Code",
            TRUE);
      InsertTask(
        Rec,TempRMCommentLine,TempAttendee,
        TempTaskInteractionLanguage,TempAttachment,"Activity Code",FALSE);
      DELETE;
    END;

    LOCAL PROCEDURE FillSalesPersonContact@8(VAR TaskParameter@1000 : Record 5080;AttendeeParameter@1001 : Record 5199);
    BEGIN
      CASE AttendeeParameter."Attendee Type" OF
        AttendeeParameter."Attendee Type"::Contact:
          TaskParameter.VALIDATE("Contact No.",AttendeeParameter."Attendee No.");
        AttendeeParameter."Attendee Type"::Salesperson:
          TaskParameter.VALIDATE("Salesperson Code",AttendeeParameter."Attendee No.");
      END;
    END;

    [External]
    PROCEDURE SetRunFromForm@11();
    BEGIN
      RunFormCode := TRUE;
    END;

    LOCAL PROCEDURE IsCalledFromForm@29() : Boolean;
    BEGIN
      EXIT((CurrFieldNo <> 0) OR RunFormCode);
    END;

    LOCAL PROCEDURE OneDayDuration@31() : Integer;
    BEGIN
      EXIT(86400000); // 24 * 60 * 60 * 1000 = 86,400,000 ms in 24 hours
    END;

    LOCAL PROCEDURE GetCurrentUserTimeZone@32(VAR TimeZoneInfo@1006 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.TimeZoneInfo";TimeZoneID@1000 : Text);
    VAR
      TimeZoneInfoRussianStandard@1008 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.TimeZoneInfo";
    BEGIN
      IF TimeZoneID = 'Russian Standard Time' THEN BEGIN
        TimeZoneInfoRussianStandard := TimeZoneInfoRussianStandard.FindSystemTimeZoneById(TimeZoneID);
        TimeZoneInfo := TimeZoneInfo.CreateCustomTimeZone(TimeZoneID,TimeZoneInfoRussianStandard.BaseUtcOffset,'','');
      END ELSE
        TimeZoneInfo := TimeZoneInfo.FindSystemTimeZoneById(TimeZoneID);
    END;

    LOCAL PROCEDURE InitializeExchangeAppointment@81(VAR Appointment@1000 : DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IAppointment";VAR ExchangeWebServicesServer@1001 : Codeunit 5321);
    VAR
      TimeZoneInfo@1003 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.TimeZoneInfo";
    BEGIN
      SetupExchangeService(ExchangeWebServicesServer);
      ExchangeWebServicesServer.CreateAppointment(Appointment);
      GetCurrentUserTimeZone(TimeZoneInfo,ExchangeWebServicesServer.GetCurrentUserTimeZone);
      UpdateAppointment(Appointment,TimeZoneInfo);
    END;

    LOCAL PROCEDURE UpdateAppointmentSalesPersonList@82(VAR SalesPersonList@1000 : Text;AddSalesPersonName@1001 : Text[50]);
    BEGIN
      IF AddSalesPersonName <> '' THEN
        IF SalesPersonList = '' THEN
          SalesPersonList := AddSalesPersonName
        ELSE
          SalesPersonList += ', ' + AddSalesPersonName ;
    END;

    LOCAL PROCEDURE SaveAppointment@52(VAR Appointment@1001 : DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IAppointment");
    BEGIN
      Appointment.SendAppointment;
    END;

    [External]
    PROCEDURE UpdateAppointment@61(VAR Appointment@1000 : DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IAppointment";TimeZoneInfo@1002 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.TimeZoneInfo");
    VAR
      DateTime@1001 : DateTime;
    BEGIN
      Appointment.Subject := Description;
      Appointment.Location := Location;
      DateTime := CREATEDATETIME(Date,"Start Time");
      Appointment.MeetingStart := DateTime;
      IF "All Day Event" THEN
        Appointment.IsAllDayEvent := TRUE
      ELSE BEGIN
        DateTime := CREATEDATETIME("Ending Date","Ending Time");
        Appointment.MeetingEnd := DateTime;
      END;
      Appointment.StartTimeZone := TimeZoneInfo;
      Appointment.EndTimeZone := TimeZoneInfo;
    END;

    [Internal]
    PROCEDURE SetupExchangeService@62(VAR ExchangeWebServicesServer@1000 : Codeunit 5321);
    VAR
      User@1001 : Record 2000000120;
    BEGIN
      COMMIT;
      User.SETRANGE("User Name",USERID);
      IF NOT User.FINDFIRST AND NOT Initialize(ExchangeWebServicesServer,User."Authentication Email") THEN
        IF NOT InitializeServiceWithCredentials(ExchangeWebServicesServer) THEN
          ERROR('');
    END;

    LOCAL PROCEDURE MakeAppointmentBody@43(Task@1001 : Record 5080;SalespersonsList@1000 : Text;SalespersonName@1002 : Text[50]) : Text;
    BEGIN
      EXIT(
        STRSUBSTNO(Text015,SalespersonsList) + '<br/><br/>' +
        STRSUBSTNO(Text016,FORMAT(Task.Date),FORMAT(Task."Start Time"),FORMAT(Task.Location)) + '<br/><br/>' +
        Text017 + '<br/>' +
        SalespersonName + '<br/>' +
        FORMAT(TODAY) + ' ' + FORMAT(TIME));
    END;

    LOCAL PROCEDURE SetAttendeeInvitationSent@76(VAR Attendee@1000 : Record 5199);
    BEGIN
      Attendee."Invitation Sent" := TRUE;
      Attendee.MODIFY;
    END;

    [External]
    PROCEDURE AddAppointmentAttendee@70(VAR Appointment@1000 : DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IAppointment";VAR Attendee@1001 : Record 5199;Email@1002 : Text);
    BEGIN
      IF Attendee."Attendance Type" = Attendee."Attendance Type"::Required THEN
        Appointment.AddRequiredAttendee(Email)
      ELSE
        Appointment.AddOptionalAttendee(Email);
      SetAttendeeInvitationSent(Attendee);
    END;

    LOCAL PROCEDURE ProcessAttendeeAppointment@72(Task@1002 : Record 5080;VAR Attendee@1004 : Record 5199);
    VAR
      Task2@1003 : Record 5080;
      Salesperson@1006 : Record 13;
      Salesperson2@1005 : Record 13;
      ExchangeWebServicesServer@1001 : Codeunit 5321;
      Mail@1009 : Codeunit 397;
      Appointment@1000 : DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IAppointment";
      SalesPersonList@1007 : Text;
      Body@1008 : Text;
    BEGIN
      IF CreateExchangeAppointment THEN
        InitializeExchangeAppointment(Appointment,ExchangeWebServicesServer);
      REPEAT
        IF FindAttendeeTask(Task2,Attendee) THEN
          IF Attendee."Attendee Type" = Attendee."Attendee Type"::Salesperson THEN
            IF Salesperson2.GET(Task2."Salesperson Code") AND
               Salesperson.GET(Task."Salesperson Code")
            THEN
              IF CreateExchangeAppointment THEN BEGIN
                UpdateAppointmentSalesPersonList(SalesPersonList,Salesperson2.Name);
                IF Salesperson2."E-Mail" <> '' THEN
                  AddAppointmentAttendee(Appointment,Attendee,Salesperson2."E-Mail");
              END ELSE BEGIN
                Body := MakeAppointmentBody(Task,Salesperson2.Name,Salesperson.Name);
                IF Mail.NewMessage(Salesperson2."E-Mail",'','',Task2.Description,Body,'',FALSE) THEN
                  SetAttendeeInvitationSent(Attendee)
                ELSE
                  MESSAGE(Text023,Attendee."Attendee Name");
              END
            ELSE BEGIN
              LogTaskInteraction(Task,Task2,TRUE);
              SetAttendeeInvitationSent(Attendee);
            END;
      UNTIL Attendee.NEXT = 0;
      IF CreateExchangeAppointment AND (SalesPersonList <> '') THEN BEGIN
        Body := MakeAppointmentBody(Task,SalesPersonList,Salesperson.Name);
        Appointment.Body := Body;
        SaveAppointment(Appointment)
      END;
    END;

    [TryFunction]
    LOCAL PROCEDURE InitializeServiceWithCredentials@73(VAR ExchangeWebServicesServer@1001 : Codeunit 5321);
    VAR
      TempOfficeAdminCredentials@1000 : TEMPORARY Record 1612;
      WebCredentials@1004 : DotNet "'Microsoft.Exchange.WebServices, Version=15.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Exchange.WebServices.Data.WebCredentials";
      WebCredentialsLogin@1002 : Text[250];
    BEGIN
      TempOfficeAdminCredentials.INIT;
      TempOfficeAdminCredentials.INSERT;
      COMMIT;
      CLEARLASTERROR;
      IF PAGE.RUNMODAL(PAGE::"Office 365 Credentials",TempOfficeAdminCredentials) <> ACTION::LookupOK THEN
        ERROR('');
      WebCredentialsLogin := TempOfficeAdminCredentials.Email;
      WebCredentials := WebCredentials.WebCredentials(WebCredentialsLogin,TempOfficeAdminCredentials.GetPassword);
      TempOfficeAdminCredentials.DELETE;
      ExchangeWebServicesServer.Initialize(
        WebCredentialsLogin,ExchangeWebServicesServer.ProdEndpoint,WebCredentials,FALSE);
    END;

    [TryFunction]
    LOCAL PROCEDURE Initialize@34(VAR ExchangeWebServicesServer@1004 : Codeunit 5321;AuthenticationEmail@1003 : Text[250]);
    VAR
      ExchangeServiceSetup@1000 : Record 5324;
      AzureADMgt@1001 : Codeunit 6300;
      AccessToken@1002 : Text;
    BEGIN
      AccessToken := AzureADMgt.GetAccessToken(AzureADMgt.GetO365Resource,AzureADMgt.GetO365ResourceName,FALSE);

      IF AccessToken <> '' THEN BEGIN
        ExchangeWebServicesServer.InitializeWithOAuthToken(AccessToken,ExchangeWebServicesServer.GetEndpoint);
        EXIT;
      END;

      ExchangeServiceSetup.GET;

      ExchangeWebServicesServer.InitializeWithCertificate(
        ExchangeServiceSetup."Azure AD App. ID",ExchangeServiceSetup."Azure AD App. Cert. Thumbprint",
        ExchangeServiceSetup."Azure AD Auth. Endpoint",ExchangeServiceSetup."Exchange Service Endpoint",
        ExchangeServiceSetup."Exchange Resource Uri");

      ExchangeWebServicesServer.SetImpersonatedIdentity(AuthenticationEmail);
    END;

    BEGIN
    END.
  }
}

