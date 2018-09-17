OBJECT Table 472 Job Queue Entry
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    Permissions=TableData 472=rimd,
                TableData 474=rim;
    DataCaptionFields=Object Type to Run,Object ID to Run,Object Caption to Run;
    OnInsert=BEGIN
               IF ISNULLGUID(ID) THEN
                 ID := CREATEGUID;
               SetDefaultValues(TRUE);
             END;

    OnModify=VAR
               RunParametersChanged@1000 : Boolean;
             BEGIN
               RunParametersChanged := AreRunParametersChanged;
               IF RunParametersChanged THEN
                 Reschedule;
               SetDefaultValues(RunParametersChanged);
             END;

    OnDelete=BEGIN
               IF Status = Status::"In Process" THEN
                 ERROR(CannotDeleteEntryErr,Status);
               CancelTask;
             END;

    CaptionML=[DAN=Opgavek�post;
               ENU=Job Queue Entry];
    LookupPageID=Page672;
    DrillDownPageID=Page672;
  }
  FIELDS
  {
    { 1   ;   ;ID                  ;GUID          ;CaptionML=[DAN=Id;
                                                              ENU=ID] }
    { 2   ;   ;User ID             ;Text65        ;TableRelation=User."User Name";
                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID];
                                                   Editable=No }
    { 3   ;   ;XML                 ;BLOB          ;CaptionML=[DAN=XML;
                                                              ENU=XML] }
    { 4   ;   ;Last Ready State    ;DateTime      ;CaptionML=[DAN=Sidste klartilstand;
                                                              ENU=Last Ready State];
                                                   Editable=No }
    { 5   ;   ;Expiration Date/Time;DateTime      ;OnValidate=BEGIN
                                                                CheckStartAndExpirationDateTime;
                                                              END;

                                                   OnLookup=BEGIN
                                                              VALIDATE("Expiration Date/Time",LookupDateTime("Expiration Date/Time","Earliest Start Date/Time",0DT));
                                                            END;

                                                   CaptionML=[DAN=Udl�bsdato/-tidspunkt;
                                                              ENU=Expiration Date/Time] }
    { 6   ;   ;Earliest Start Date/Time;DateTime  ;OnValidate=BEGIN
                                                                CheckStartAndExpirationDateTime;
                                                                IF "Earliest Start Date/Time" <> xRec."Earliest Start Date/Time" THEN
                                                                  Reschedule;
                                                              END;

                                                   OnLookup=BEGIN
                                                              VALIDATE("Earliest Start Date/Time",LookupDateTime("Earliest Start Date/Time",0DT,"Expiration Date/Time"));
                                                            END;

                                                   CaptionML=[DAN=Tidligste startdato/-tidspunkt;
                                                              ENU=Earliest Start Date/Time] }
    { 7   ;   ;Object Type to Run  ;Option        ;InitValue=Report;
                                                   OnValidate=BEGIN
                                                                IF "Object Type to Run" <> xRec."Object Type to Run" THEN
                                                                  VALIDATE("Object ID to Run",0);
                                                              END;

                                                   CaptionML=[DAN=Objekttype, der skal aktiveres;
                                                              ENU=Object Type to Run];
                                                   OptionCaptionML=[DAN=,,,Rapport,,Codeunit;
                                                                    ENU=,,,Report,,Codeunit];
                                                   OptionString=,,,Report,,Codeunit }
    { 8   ;   ;Object ID to Run    ;Integer       ;TableRelation=AllObjWithCaption."Object ID" WHERE (Object Type=FIELD(Object Type to Run));
                                                   OnValidate=VAR
                                                                Object@1000 : Record 2000000001;
                                                              BEGIN
                                                                IF "Object ID to Run" <> xRec."Object ID to Run" THEN BEGIN
                                                                  CLEAR(XML);
                                                                  CLEAR(Description);
                                                                  CLEAR("Parameter String");
                                                                  CLEAR("Report Request Page Options");
                                                                END;
                                                                IF "Object ID to Run" = 0 THEN
                                                                  EXIT;
                                                                IF Object.GET("Object Type to Run",'',"Object ID to Run") THEN
                                                                  Object.TESTFIELD(Compiled);

                                                                CALCFIELDS("Object Caption to Run");
                                                                IF Description = '' THEN
                                                                  Description := GetDefaultDescription;

                                                                IF "Object Type to Run" <> "Object Type to Run"::Report THEN
                                                                  EXIT;
                                                                IF REPORT.DEFAULTLAYOUT("Object ID to Run") = DEFAULTLAYOUT::None THEN // Processing-only
                                                                  "Report Output Type" := "Report Output Type"::"None (Processing only)"
                                                                ELSE BEGIN
                                                                  "Report Output Type" := "Report Output Type"::PDF;
                                                                  IF REPORT.DEFAULTLAYOUT("Object ID to Run") = DEFAULTLAYOUT::Word THEN
                                                                    "Report Output Type" := "Report Output Type"::Word;
                                                                END;
                                                              END;

                                                   OnLookup=VAR
                                                              NewObjectID@1000 : Integer;
                                                            BEGIN
                                                              IF LookupObjectID(NewObjectID) THEN
                                                                VALIDATE("Object ID to Run",NewObjectID);
                                                            END;

                                                   CaptionML=[DAN=Objekt-id, der skal aktiveres;
                                                              ENU=Object ID to Run] }
    { 9   ;   ;Object Caption to Run;Text250      ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(AllObjWithCaption."Object Caption" WHERE (Object Type=FIELD(Object Type to Run),
                                                                                                                Object ID=FIELD(Object ID to Run)));
                                                   CaptionML=[DAN=Objektoverskrift, der skal k�res;
                                                              ENU=Object Caption to Run];
                                                   Editable=No }
    { 10  ;   ;Report Output Type  ;Option        ;OnValidate=VAR
                                                                ReportLayoutSelection@1000 : Record 9651;
                                                                InitServerPrinterTable@1001 : Codeunit 9655;
                                                                PermissionManager@1002 : Codeunit 9002;
                                                              BEGIN
                                                                TESTFIELD("Object Type to Run","Object Type to Run"::Report);

                                                                IF REPORT.DEFAULTLAYOUT("Object ID to Run") = DEFAULTLAYOUT::None THEN // Processing-only
                                                                  TESTFIELD("Report Output Type","Report Output Type"::"None (Processing only)")
                                                                ELSE BEGIN
                                                                  IF "Report Output Type" = "Report Output Type"::"None (Processing only)" THEN
                                                                    FIELDERROR("Report Output Type");
                                                                  IF ReportLayoutSelection.HasCustomLayout("Object ID to Run") = 2 THEN // Word layout
                                                                    IF NOT ("Report Output Type" IN ["Report Output Type"::Print,"Report Output Type"::Word]) THEN
                                                                      FIELDERROR("Report Output Type");
                                                                END;
                                                                IF "Report Output Type" = "Report Output Type"::Print THEN BEGIN
                                                                  IF PermissionManager.SoftwareAsAService THEN BEGIN
                                                                    "Report Output Type" := "Report Output Type"::PDF;
                                                                    MESSAGE(NoPrintOnSaaSMsg);
                                                                  END ELSE
                                                                    "Printer Name" := InitServerPrinterTable.FindClosestMatchToClientDefaultPrinter("Object ID to Run");
                                                                END ELSE
                                                                  "Printer Name" := '';
                                                              END;

                                                   CaptionML=[DAN=Rapportresultattype;
                                                              ENU=Report Output Type];
                                                   OptionCaptionML=[DAN=PDF,Word,Excel,Udskriv,Ingen (kun behandling);
                                                                    ENU=PDF,Word,Excel,Print,None (Processing only)];
                                                   OptionString=PDF,Word,Excel,Print,None (Processing only) }
    { 11  ;   ;Maximum No. of Attempts to Run;Integer;
                                                   CaptionML=[DAN=Maks. antal aktiveringsfors�g;
                                                              ENU=Maximum No. of Attempts to Run] }
    { 12  ;   ;No. of Attempts to Run;Integer     ;CaptionML=[DAN=Antal aktiveringsfors�g;
                                                              ENU=No. of Attempts to Run];
                                                   Editable=No }
    { 13  ;   ;Status              ;Option        ;CaptionML=[DAN=Status;
                                                              ENU=Status];
                                                   OptionCaptionML=[DAN=Klar,Igangv�rende,Fejl,Afvent,F�rdig,Afvent med inaktivitetstimeout;
                                                                    ENU=Ready,In Process,Error,On Hold,Finished,On Hold with Inactivity Timeout];
                                                   OptionString=Ready,In Process,Error,On Hold,Finished,On Hold with Inactivity Timeout;
                                                   Editable=No }
    { 14  ;   ;Priority            ;Integer       ;InitValue=1000;
                                                   CaptionML=[DAN=Prioritet;
                                                              ENU=Priority] }
    { 15  ;   ;Record ID to Process;RecordID      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Record-id, der skal behandles;
                                                              ENU=Record ID to Process] }
    { 16  ;   ;Parameter String    ;Text250       ;CaptionML=[DAN=Parameterstreng;
                                                              ENU=Parameter String] }
    { 17  ;   ;Recurring Job       ;Boolean       ;CaptionML=[DAN=Gentaget opgave;
                                                              ENU=Recurring Job] }
    { 18  ;   ;No. of Minutes between Runs;Integer;OnValidate=BEGIN
                                                                SetRecurringField;
                                                              END;

                                                   CaptionML=[DAN=Antal minutter mellem aktiveringer;
                                                              ENU=No. of Minutes between Runs] }
    { 19  ;   ;Run on Mondays      ;Boolean       ;OnValidate=BEGIN
                                                                SetRecurringField;
                                                              END;

                                                   CaptionML=[DAN=Aktiver hver mandag;
                                                              ENU=Run on Mondays] }
    { 20  ;   ;Run on Tuesdays     ;Boolean       ;OnValidate=BEGIN
                                                                SetRecurringField;
                                                              END;

                                                   CaptionML=[DAN=Aktiver hver tirsdag;
                                                              ENU=Run on Tuesdays] }
    { 21  ;   ;Run on Wednesdays   ;Boolean       ;OnValidate=BEGIN
                                                                SetRecurringField;
                                                              END;

                                                   CaptionML=[DAN=Aktiver hver onsdag;
                                                              ENU=Run on Wednesdays] }
    { 22  ;   ;Run on Thursdays    ;Boolean       ;OnValidate=BEGIN
                                                                SetRecurringField;
                                                              END;

                                                   CaptionML=[DAN=Aktiver hver torsdag;
                                                              ENU=Run on Thursdays] }
    { 23  ;   ;Run on Fridays      ;Boolean       ;OnValidate=BEGIN
                                                                SetRecurringField;
                                                              END;

                                                   CaptionML=[DAN=Aktiver hver fredag;
                                                              ENU=Run on Fridays] }
    { 24  ;   ;Run on Saturdays    ;Boolean       ;OnValidate=BEGIN
                                                                SetRecurringField;
                                                              END;

                                                   CaptionML=[DAN=Aktiver hver l�rdag;
                                                              ENU=Run on Saturdays] }
    { 25  ;   ;Run on Sundays      ;Boolean       ;OnValidate=BEGIN
                                                                SetRecurringField;
                                                              END;

                                                   CaptionML=[DAN=Aktiver hver s�ndag;
                                                              ENU=Run on Sundays] }
    { 26  ;   ;Starting Time       ;Time          ;OnValidate=BEGIN
                                                                TESTFIELD("Recurring Job");
                                                                IF "Starting Time" = 0T THEN
                                                                  "Reference Starting Time" := 0DT
                                                                ELSE
                                                                  "Reference Starting Time" := CREATEDATETIME(DMY2DATE(1,1,2000),"Starting Time");
                                                              END;

                                                   CaptionML=[DAN=Starttidspunkt;
                                                              ENU=Starting Time] }
    { 27  ;   ;Ending Time         ;Time          ;OnValidate=BEGIN
                                                                TESTFIELD("Recurring Job");
                                                              END;

                                                   CaptionML=[DAN=Sluttidspunkt;
                                                              ENU=Ending Time] }
    { 28  ;   ;Reference Starting Time;DateTime   ;OnValidate=BEGIN
                                                                "Starting Time" := DT2TIME("Reference Starting Time");
                                                              END;

                                                   CaptionML=[DAN=Referencestarttidspunkt;
                                                              ENU=Reference Starting Time];
                                                   Editable=No }
    { 30  ;   ;Description         ;Text250       ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 31  ;   ;Run in User Session ;Boolean       ;CaptionML=[DAN=K�r i brugersession;
                                                              ENU=Run in User Session];
                                                   Editable=No }
    { 32  ;   ;User Session ID     ;Integer       ;DataClassification=EndUserPseudonymousIdentifiers;
                                                   CaptionML=[DAN=Brugersessions-id;
                                                              ENU=User Session ID] }
    { 33  ;   ;Job Queue Category Code;Code10     ;TableRelation="Job Queue Category";
                                                   CaptionML=[DAN=Opgavek�kategorikode;
                                                              ENU=Job Queue Category Code] }
    { 34  ;   ;Error Message       ;Text250       ;CaptionML=[DAN=Fejlmeddelelse;
                                                              ENU=Error Message] }
    { 35  ;   ;Error Message 2     ;Text250       ;CaptionML=[DAN=Fejlmeddelelse 2;
                                                              ENU=Error Message 2] }
    { 36  ;   ;Error Message 3     ;Text250       ;CaptionML=[DAN=Fejlmeddelelse 3;
                                                              ENU=Error Message 3] }
    { 37  ;   ;Error Message 4     ;Text250       ;CaptionML=[DAN=Fejlmeddelelse 4;
                                                              ENU=Error Message 4] }
    { 40  ;   ;User Service Instance ID;Integer   ;DataClassification=EndUserPseudonymousIdentifiers;
                                                   CaptionML=[DAN=Brugertjenesteforekomst-id;
                                                              ENU=User Service Instance ID] }
    { 41  ;   ;User Session Started;DateTime      ;CaptionML=[DAN=Brugersession startet;
                                                              ENU=User Session Started];
                                                   Editable=No }
    { 42  ;   ;Timeout (sec.)      ;Integer       ;CaptionML=[DAN=Timeout (sek.);
                                                              ENU=Timeout (sec.)];
                                                   MinValue=0 }
    { 43  ;   ;Notify On Success   ;Boolean       ;CaptionML=[DAN=Informer i tilf�lde af succes;
                                                              ENU=Notify On Success] }
    { 44  ;   ;User Language ID    ;Integer       ;CaptionML=[DAN=Id for brugersprog;
                                                              ENU=User Language ID] }
    { 45  ;   ;Printer Name        ;Text250       ;OnValidate=VAR
                                                                InitServerPrinterTable@1000 : Codeunit 9655;
                                                              BEGIN
                                                                TESTFIELD("Report Output Type","Report Output Type"::Print);
                                                                IF "Printer Name" = '' THEN
                                                                  EXIT;
                                                                InitServerPrinterTable.ValidatePrinterName("Printer Name");
                                                              END;

                                                   OnLookup=VAR
                                                              Printer@1001 : Record 2000000039;
                                                              ServerPrinters@1000 : Page 683;
                                                            BEGIN
                                                              ServerPrinters.SetSelectedPrinterName("Printer Name");
                                                              IF ServerPrinters.RUNMODAL = ACTION::OK THEN BEGIN
                                                                ServerPrinters.GETRECORD(Printer);
                                                                "Printer Name" := Printer.ID;
                                                              END;
                                                            END;

                                                   CaptionML=[DAN=Printernavn;
                                                              ENU=Printer Name] }
    { 46  ;   ;Report Request Page Options;Boolean;OnValidate=BEGIN
                                                                IF "Report Request Page Options" THEN
                                                                  RunReportRequestPage
                                                                ELSE BEGIN
                                                                  CLEAR(XML);
                                                                  MESSAGE(RequestPagesOptionsDeletedMsg);
                                                                  "User ID" := USERID;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Sideindstillinger for rapportanmodning;
                                                              ENU=Report Request Page Options] }
    { 47  ;   ;Rerun Delay (sec.)  ;Integer       ;CaptionML=[DAN=Forsinkelse f�r genk�rsel (sek.);
                                                              ENU=Rerun Delay (sec.)];
                                                   MinValue=0;
                                                   MaxValue=3600 }
    { 48  ;   ;System Task ID      ;GUID          ;CaptionML=[DAN=Systemopgave-id;
                                                              ENU=System Task ID] }
    { 49  ;   ;Scheduled           ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Scheduled Task" WHERE (ID=FIELD(System Task ID)));
                                                   CaptionML=[DAN=Planlagt;
                                                              ENU=Scheduled] }
    { 50  ;   ;Manual Recurrence   ;Boolean       ;CaptionML=[DAN=Manuel gentagelse;
                                                              ENU=Manual Recurrence] }
    { 51  ;   ;On Hold Due to Inactivity;Boolean  ;ObsoleteState=Pending;
                                                   ObsoleteReason=Functionality moved into new job queue status;
                                                   CaptionML=[DAN=Afvent pga. inaktivitet;
                                                              ENU=On Hold Due to Inactivity] }
    { 52  ;   ;Inactivity Timeout Period;Integer  ;CaptionML=[DAN=Timeoutperiode for inaktivitet;
                                                              ENU=Inactivity Timeout Period] }
  }
  KEYS
  {
    {    ;ID                                      ;Clustered=Yes }
    {    ;Job Queue Category Code                  }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      NoErrMsg@1000 : TextConst 'DAN=Der er ingen fejlmeddelelse.;ENU=There is no error message.';
      CannotDeleteEntryErr@1001 : TextConst '@@@=%1 is a status value, such as Success or Error.;DAN=Du kan ikke slette en post med status %1.;ENU=You cannot delete an entry that has status %1.';
      DeletedEntryErr@1008 : TextConst 'DAN=Opgavek�posten er blevet slettet.;ENU=The job queue entry has been deleted.';
      ScheduledForPostingMsg@1002 : TextConst '@@@="%1=a date, %2 = a user.";DAN=Planlagt til bogf�ring den %1 af %2.;ENU=Scheduled for posting on %1 by %2.';
      NoRecordErr@1003 : TextConst 'DAN=Der er ikke knyttet nogen record til denne opgavek�record.;ENU=No record is associated with the job queue entry.';
      RequestPagesOptionsDeletedMsg@1004 : TextConst 'DAN=Du har ryddet rapportparametrene. Mark�r afkrydsningsfeltet for at f� vist siden Rapportanmodning igen.;ENU=You have cleared the report parameters. Select the check box in the field to show the report request page again.';
      ExpiresBeforeStartErr@1005 : TextConst '@@@="%1 = Expiration Date, %2=Start date";DAN=%1 skal ligge efter %2.;ENU=%1 must be later than %2.';
      UserSessionJobsCannotBeRecurringErr@1006 : TextConst 'DAN=Du kan ikke oprette tilbagevendende poster til jobk�en for brugersessioner.;ENU=You cannot set up recurring user session job queue entries.';
      NoPrintOnSaaSMsg@1007 : TextConst 'DAN=Du kan ikke v�lge en printer fra dette onlineprodukt. Gem i stedet som PDF eller et andet format, som du kan udskrive senere.\\Outputtypen er indstillet til PDF.;ENU=You cannot select a printer from this online product. Instead, save as PDF, or another format, which you can print later.\\The output type has been set to PDF.';
      LastJobQueueLogEntryNo@1009 : Integer;

    [External]
    PROCEDURE DoesExistLocked@38() : Boolean;
    BEGIN
      LOCKTABLE;
      EXIT(GET(ID));
    END;

    [External]
    PROCEDURE RefreshLocked@37();
    BEGIN
      LOCKTABLE;
      GET(ID);
    END;

    [External]
    PROCEDURE IsExpired@43(AtDateTime@1000 : DateTime) : Boolean;
    BEGIN
      EXIT((AtDateTime <> 0DT) AND ("Expiration Date/Time" <> 0DT) AND ("Expiration Date/Time" < AtDateTime));
    END;

    [External]
    PROCEDURE IsReadyToStart@60() : Boolean;
    BEGIN
      EXIT(Status IN [Status::Ready,Status::"In Process",Status::"On Hold with Inactivity Timeout"]);
    END;

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
    PROCEDURE ShowErrorMessage@8();
    VAR
      e@1000 : Text;
    BEGIN
      e := GetErrorMessage;
      IF e = '' THEN
        e := NoErrMsg;
      MESSAGE('%1',e);
    END;

    [External]
    PROCEDURE SetError@7(ErrorText@1000 : Text);
    BEGIN
      RefreshLocked;
      SetErrorMessage(ErrorText);
      ClearServiceValues;
      SetStatusValue(Status::Error);
    END;

    [Internal]
    PROCEDURE SetResult@39(IsSuccess@1000 : Boolean;PrevStatus@1002 : Option);
    BEGIN
      IF (Status = Status::"On Hold") OR "Manual Recurrence" THEN
        EXIT;
      IF IsSuccess THEN
        IF "Recurring Job" AND (PrevStatus IN [Status::"On Hold",Status::"On Hold with Inactivity Timeout"]) THEN
          Status := PrevStatus
        ELSE
          Status := Status::Finished
      ELSE BEGIN
        Status := Status::Error;
        SetErrorMessage(GETLASTERRORTEXT);
      END;
      MODIFY;
    END;

    [External]
    PROCEDURE SetResultDeletedEntry@46();
    BEGIN
      Status := Status::Error;
      SetErrorMessage(DeletedEntryErr);
      MODIFY;
    END;

    [External]
    PROCEDURE FinalizeRun@44();
    BEGIN
      CASE Status OF
        Status::Finished,Status::"On Hold with Inactivity Timeout":
          CleanupAfterExecution;
        Status::Error:
          HandleExecutionError;
      END;

      IF (Status = Status::Finished) OR ("Maximum No. of Attempts to Run" = "No. of Attempts to Run") THEN
        UpdateDocumentSentHistory;
    END;

    PROCEDURE GetLastLogEntryNo@52() : Integer;
    BEGIN
      EXIT(LastJobQueueLogEntryNo);
    END;

    [External]
    PROCEDURE InsertLogEntry@45(VAR JobQueueLogEntry@1000 : Record 474);
    BEGIN
      JobQueueLogEntry."Entry No." := 0;
      JobQueueLogEntry.INIT;
      JobQueueLogEntry.ID := ID;
      JobQueueLogEntry."User ID" := "User ID";
      JobQueueLogEntry."Start Date/Time" := "User Session Started";
      JobQueueLogEntry."Object Type to Run" := "Object Type to Run";
      JobQueueLogEntry."Object ID to Run" := "Object ID to Run";
      JobQueueLogEntry.Description := Description;
      JobQueueLogEntry.Status := JobQueueLogEntry.Status::"In Process";
      JobQueueLogEntry."Processed by User ID" := USERID;
      JobQueueLogEntry."Job Queue Category Code" := "Job Queue Category Code";
      JobQueueLogEntry.INSERT(TRUE);
      LastJobQueueLogEntryNo := JobQueueLogEntry."Entry No.";
    END;

    [External]
    PROCEDURE FinalizeLogEntry@51(JobQueueLogEntry@1000 : Record 474);
    BEGIN
      IF Status = Status::Error THEN BEGIN
        JobQueueLogEntry.Status := JobQueueLogEntry.Status::Error;
        JobQueueLogEntry.SetErrorMessage(GetErrorMessage);
      END ELSE
        JobQueueLogEntry.Status := JobQueueLogEntry.Status::Success;
      JobQueueLogEntry."End Date/Time" := CURRENTDATETIME;
      JobQueueLogEntry.MODIFY(TRUE);
    END;

    [External]
    PROCEDURE SetStatus@3(NewStatus@1000 : Option);
    BEGIN
      IF NewStatus = Status THEN
        EXIT;
      RefreshLocked;
      ClearServiceValues;
      SetStatusValue(NewStatus);
    END;

    [External]
    PROCEDURE Cancel@4();
    BEGIN
      IF DoesExistLocked THEN
        DeleteTask;
    END;

    [External]
    PROCEDURE DeleteTask@42();
    BEGIN
      Status := Status::Finished;
      DELETE(TRUE);
    END;

    [External]
    PROCEDURE DeleteTasks@48();
    BEGIN
      IF FINDSET THEN
        REPEAT
          DeleteTask;
        UNTIL NEXT = 0;
    END;

    [External]
    PROCEDURE Restart@5();
    BEGIN
      RefreshLocked;
      ClearServiceValues;
      IF (Status = Status::"On Hold with Inactivity Timeout") AND ("Inactivity Timeout Period" > 0) THEN
        "Earliest Start Date/Time" := CURRENTDATETIME;
      Status := Status::"On Hold";
      SetStatusValue(Status::Ready);
    END;

    LOCAL PROCEDURE EnqueueTask@40();
    BEGIN
      CODEUNIT.RUN(CODEUNIT::"Job Queue - Enqueue",Rec);
    END;

    [External]
    PROCEDURE CancelTask@32();
    VAR
      ScheduledTask@1000 : Record 2000000175;
    BEGIN
      IF NOT ISNULLGUID("System Task ID") THEN BEGIN
        IF ScheduledTask.GET("System Task ID") THEN
          TASKSCHEDULER.CANCELTASK("System Task ID");
        CLEAR("System Task ID");
      END;
    END;

    [External]
    PROCEDURE ScheduleTask@36() : GUID;
    VAR
      TaskGUID@1000 : GUID;
    BEGIN
      OnBeforeScheduleTask(Rec,TaskGUID);
      IF NOT ISNULLGUID(TaskGUID) THEN
        EXIT(TaskGUID);

      EXIT(
        TASKSCHEDULER.CREATETASK(
          CODEUNIT::"Job Queue Dispatcher",
          CODEUNIT::"Job Queue Error Handler",
          TRUE,COMPANYNAME,"Earliest Start Date/Time",RECORDID));
    END;

    LOCAL PROCEDURE Reschedule@31();
    BEGIN
      CancelTask;
      IF Status IN [Status::Ready,Status::"On Hold with Inactivity Timeout"] THEN BEGIN
        SetDefaultValues(FALSE);
        EnqueueTask;
      END;
    END;

    [External]
    PROCEDURE ReuseExistingJobFromID@34(JobID@1000 : GUID;ExecutionDateTime@1002 : DateTime) : Boolean;
    BEGIN
      IF GET(JobID) THEN BEGIN
        IF NOT (Status IN [Status::Ready,Status::"In Process"]) THEN BEGIN
          "Earliest Start Date/Time" := ExecutionDateTime;
          SetStatus(Status::Ready);
        END;
        EXIT(TRUE);
      END;

      EXIT(FALSE);
    END;

    [External]
    PROCEDURE ReuseExistingJobFromCatagory@35(JobQueueCatagoryCode@1001 : Code[10];ExecutionDateTime@1002 : DateTime) : Boolean;
    BEGIN
      SETRANGE("Job Queue Category Code",JobQueueCatagoryCode);
      IF FINDFIRST THEN
        EXIT(ReuseExistingJobFromID(ID,ExecutionDateTime));

      EXIT(FALSE);
    END;

    LOCAL PROCEDURE AreRunParametersChanged@41() : Boolean;
    BEGIN
      EXIT(
        ("User ID" = '') OR
        ("Object Type to Run" <> xRec."Object Type to Run") OR
        ("Object ID to Run" <> xRec."Object ID to Run") OR
        ("Parameter String" <> xRec."Parameter String"));
    END;

    LOCAL PROCEDURE SetDefaultValues@6(SetupUserId@1002 : Boolean);
    VAR
      Language@1001 : Record 8;
      IdentityManagement@1000 : Codeunit 9801;
    BEGIN
      "Last Ready State" := CURRENTDATETIME;
      IF IdentityManagement.IsInvAppId THEN
        "User Language ID" := Language.GetLanguageID(Language.GetUserLanguage)
      ELSE
        "User Language ID" := GLOBALLANGUAGE;
      IF SetupUserId THEN
        "User ID" := USERID;
      "No. of Attempts to Run" := 0;
    END;

    LOCAL PROCEDURE ClearServiceValues@9();
    BEGIN
      "User Session Started" := 0DT;
      "User Service Instance ID" := 0;
      "User Session ID" := 0;
    END;

    LOCAL PROCEDURE CleanupAfterExecution@11();
    VAR
      JobQueueDispatcher@1000 : Codeunit 448;
    BEGIN
      IF "Notify On Success" THEN
        CODEUNIT.RUN(CODEUNIT::"Job Queue - Send Notification",Rec);

      IF "Recurring Job" THEN BEGIN
        ClearServiceValues;
        IF Status = Status::"On Hold with Inactivity Timeout" THEN
          "Earliest Start Date/Time" := JobQueueDispatcher.CalcNextRunTimeHoldDuetoInactivityJob(Rec,CURRENTDATETIME)
        ELSE
          "Earliest Start Date/Time" := JobQueueDispatcher.CalcNextRunTimeForRecurringJob(Rec,CURRENTDATETIME);
        EnqueueTask;
      END ELSE
        DELETE;
    END;

    LOCAL PROCEDURE HandleExecutionError@12();
    BEGIN
      IF "Maximum No. of Attempts to Run" > "No. of Attempts to Run" THEN BEGIN
        "No. of Attempts to Run" += 1;
        "Earliest Start Date/Time" := CURRENTDATETIME + 1000 * "Rerun Delay (sec.)";
        EnqueueTask;
      END ELSE BEGIN
        SetStatusValue(Status::Error);
        COMMIT;
        IF CODEUNIT.RUN(CODEUNIT::"Job Queue - Send Notification",Rec) THEN;
      END;
    END;

    [External]
    PROCEDURE GetTimeout@10() : Integer;
    BEGIN
      IF "Timeout (sec.)" > 0 THEN
        EXIT("Timeout (sec.)");
      EXIT(1000000000);
    END;

    LOCAL PROCEDURE SetRecurringField@13();
    BEGIN
      "Recurring Job" :=
        "Run on Mondays" OR
        "Run on Tuesdays" OR "Run on Wednesdays" OR "Run on Thursdays" OR "Run on Fridays" OR "Run on Saturdays" OR "Run on Sundays";

      IF "Recurring Job" AND "Run in User Session" THEN
        ERROR(UserSessionJobsCannotBeRecurringErr);
    END;

    LOCAL PROCEDURE SetStatusValue@14(NewStatus@1000 : Option);
    VAR
      JobQueueDispatcher@1001 : Codeunit 448;
    BEGIN
      IF NewStatus = Status THEN
        EXIT;
      CASE NewStatus OF
        Status::Ready:
          BEGIN
            SetDefaultValues(FALSE);
            "Earliest Start Date/Time" := JobQueueDispatcher.CalcInitialRunTime(Rec,CURRENTDATETIME);
            EnqueueTask;
          END;
        Status::"On Hold":
          CancelTask;
        Status::"On Hold with Inactivity Timeout":
          IF "Inactivity Timeout Period" > 0 THEN BEGIN
            SetDefaultValues(FALSE);
            "Earliest Start Date/Time" := JobQueueDispatcher.CalcNextRunTimeHoldDuetoInactivityJob(Rec,CURRENTDATETIME);
            EnqueueTask;
          END;
      END;
      Status := NewStatus;
      MODIFY;
    END;

    [External]
    PROCEDURE ShowStatusMsg@15(JQID@1000 : GUID);
    VAR
      JobQueueEntry@1001 : Record 472;
    BEGIN
      IF JobQueueEntry.GET(JQID) THEN
        CASE JobQueueEntry.Status OF
          JobQueueEntry.Status::Error:
            MESSAGE(JobQueueEntry.GetErrorMessage);
          JobQueueEntry.Status::"In Process":
            MESSAGE(FORMAT(JobQueueEntry.Status::"In Process"));
          ELSE
            MESSAGE(ScheduledForPostingMsg,JobQueueEntry."User Session Started",JobQueueEntry."User ID");
        END;
    END;

    [External]
    PROCEDURE LookupRecordToProcess@16();
    VAR
      RecRef@1002 : RecordRef;
      RecVariant@1001 : Variant;
    BEGIN
      IF ISNULLGUID(ID) THEN
        EXIT;
      IF FORMAT("Record ID to Process") = '' THEN
        ERROR(NoRecordErr);
      RecRef.GET("Record ID to Process");
      RecRef.SETRECFILTER;
      RecVariant := RecRef;
      PAGE.RUN(0,RecVariant);
    END;

    [External]
    PROCEDURE LookupObjectID@19(VAR NewObjectID@1000 : Integer) : Boolean;
    VAR
      AllObjWithCaption@1002 : Record 2000000058;
      Objects@1001 : Page 358;
    BEGIN
      IF AllObjWithCaption.GET("Object Type to Run","Object ID to Run") THEN;
      AllObjWithCaption.FILTERGROUP(2);
      AllObjWithCaption.SETRANGE("Object Type","Object Type to Run");
      AllObjWithCaption.FILTERGROUP(0);
      Objects.SETRECORD(AllObjWithCaption);
      Objects.SETTABLEVIEW(AllObjWithCaption);
      Objects.LOOKUPMODE := TRUE;
      IF Objects.RUNMODAL = ACTION::LookupOK THEN BEGIN
        Objects.GETRECORD(AllObjWithCaption);
        NewObjectID := AllObjWithCaption."Object ID";
        EXIT(TRUE);
      END;
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE LookupDateTime@26(InitDateTime@1000 : DateTime;EarliestDateTime@1001 : DateTime;LatestDateTime@1003 : DateTime) : DateTime;
    VAR
      DateTimeDialog@1004 : Page 684;
      NewDateTime@1002 : DateTime;
    BEGIN
      NewDateTime := InitDateTime;
      IF InitDateTime < EarliestDateTime THEN
        InitDateTime := EarliestDateTime;
      IF (LatestDateTime <> 0DT) AND (InitDateTime > LatestDateTime) THEN
        InitDateTime := LatestDateTime;

      DateTimeDialog.SetDateTime(ROUNDDATETIME(InitDateTime,1000));

      IF DateTimeDialog.RUNMODAL = ACTION::OK THEN
        NewDateTime := DateTimeDialog.GetDateTime;
      EXIT(NewDateTime);
    END;

    LOCAL PROCEDURE CheckStartAndExpirationDateTime@24();
    BEGIN
      IF IsExpired("Earliest Start Date/Time") THEN
        ERROR(ExpiresBeforeStartErr,FIELDCAPTION("Expiration Date/Time"),FIELDCAPTION("Earliest Start Date/Time"));
    END;

    [External]
    PROCEDURE GetReportParameters@17() : Text;
    VAR
      InStr@1000 : InStream;
      Params@1001 : Text;
    BEGIN
      TESTFIELD("Object Type to Run","Object Type to Run"::Report);
      TESTFIELD("Object ID to Run");

      CALCFIELDS(XML);
      IF XML.HASVALUE THEN BEGIN
        XML.CREATEINSTREAM(InStr,TEXTENCODING::UTF8);
        InStr.READ(Params);
      END;

      EXIT(Params);
    END;

    [Internal]
    PROCEDURE SetReportParameters@20(Params@1002 : Text);
    VAR
      OutStr@1001 : OutStream;
    BEGIN
      TESTFIELD("Object Type to Run","Object Type to Run"::Report);
      TESTFIELD("Object ID to Run");
      CLEAR(XML);
      IF Params <> '' THEN BEGIN
        "Report Request Page Options" := TRUE;
        XML.CREATEOUTSTREAM(OutStr,TEXTENCODING::UTF8);
        OutStr.WRITE(Params);
      END;
      MODIFY; // Necessary because the following function does a CALCFIELDS(XML)
      Description := GetDefaultDescriptionFromReportRequestPage(Description);
      MODIFY;
    END;

    [Internal]
    PROCEDURE RunReportRequestPage@18();
    VAR
      Params@1000 : Text;
      OldParams@1001 : Text;
    BEGIN
      IF "Object Type to Run" <> "Object Type to Run"::Report THEN
        EXIT;
      IF "Object ID to Run" = 0 THEN
        EXIT;

      OldParams := GetReportParameters;
      Params := REPORT.RUNREQUESTPAGE("Object ID to Run",OldParams);

      IF (Params <> '') AND (Params <> OldParams) THEN BEGIN
        "User ID" := USERID;
        SetReportParameters(Params);
      END;
    END;

    [External]
    PROCEDURE ScheduleJobQueueEntry@54(CodeunitID@1001 : Integer;RecordIDToProcess@1000 : RecordID);
    BEGIN
      ScheduleJobQueueEntryWithParameters(CodeunitID,RecordIDToProcess,'');
    END;

    [External]
    PROCEDURE ScheduleJobQueueEntryWithParameters@21(CodeunitID@1000 : Integer;RecordIDToProcess@1001 : RecordID;JobParameter@1002 : Text[250]);
    BEGIN
      INIT;
      "Earliest Start Date/Time" := CREATEDATETIME(TODAY,TIME);
      "Object Type to Run" := "Object Type to Run"::Codeunit;
      "Object ID to Run" := CodeunitID;
      "Record ID to Process" := RecordIDToProcess;
      "Run in User Session" := FALSE;
      Priority := 1000;
      "Parameter String" := JobParameter;
      EnqueueTask;
    END;

    [External]
    PROCEDURE ScheduleJobQueueEntryForLater@33(CodeunitID@1000 : Integer;StartDateTime@1001 : DateTime;JobQueueCategoryCode@1002 : Code[10];JobParameter@1003 : Text);
    BEGIN
      INIT;
      "Earliest Start Date/Time" := StartDateTime;
      "Object Type to Run" := "Object Type to Run"::Codeunit;
      "Object ID to Run" := CodeunitID;
      "Run in User Session" := FALSE;
      Priority := 1000;
      "Job Queue Category Code" := JobQueueCategoryCode;
      "Maximum No. of Attempts to Run" := 3;
      "Rerun Delay (sec.)" := 60;
      "Parameter String" := COPYSTR(JobParameter,1,MAXSTRLEN("Parameter String"));
      EnqueueTask;
    END;

    [External]
    PROCEDURE GetStartingDateTime@27(Date@1000 : DateTime) : DateTime;
    BEGIN
      IF "Reference Starting Time" = 0DT THEN
        VALIDATE("Starting Time");
      EXIT(CREATEDATETIME(DT2DATE(Date),DT2TIME("Reference Starting Time")));
    END;

    [External]
    PROCEDURE GetEndingDateTime@30(Date@1000 : DateTime) : DateTime;
    BEGIN
      IF "Reference Starting Time" = 0DT THEN
        VALIDATE("Starting Time");
      IF "Ending Time" = 0T THEN
        EXIT(CREATEDATETIME(DT2DATE(Date),0T));
      IF "Starting Time" = 0T THEN
        EXIT(CREATEDATETIME(DT2DATE(Date),"Ending Time"));
      IF "Starting Time" < "Ending Time" THEN
        EXIT(CREATEDATETIME(DT2DATE(Date),"Ending Time"));
      EXIT(CREATEDATETIME(DT2DATE(Date) + 1,"Ending Time"));
    END;

    [External]
    PROCEDURE ScheduleRecurrentJobQueueEntry@25(ObjType@1001 : Option;ObjID@1002 : Integer;RecId@1000 : RecordID);
    BEGIN
      RESET;
      SETRANGE("Object Type to Run",ObjType);
      SETRANGE("Object ID to Run",ObjID);
      IF FORMAT(RecId) <> '' THEN
        SETFILTER("Record ID to Process",FORMAT(RecId));
      LOCKTABLE;

      IF NOT FINDFIRST THEN BEGIN
        InitRecurringJob(5);
        "Object Type to Run" := ObjType;
        "Object ID to Run" := ObjID;
        "Record ID to Process" := RecId;
        "Starting Time" := 080000T;
        "Maximum No. of Attempts to Run" := 3;
        EnqueueTask;
      END;
    END;

    [External]
    PROCEDURE InitRecurringJob@47(NoofMinutesbetweenRuns@1000 : Integer);
    BEGIN
      INIT;
      CLEAR(ID); // "Job Queue - Enqueue" is to define new ID
      "Recurring Job" := TRUE;
      "Run on Mondays" := TRUE;
      "Run on Tuesdays" := TRUE;
      "Run on Wednesdays" := TRUE;
      "Run on Thursdays" := TRUE;
      "Run on Fridays" := TRUE;
      "Run on Saturdays" := TRUE;
      "Run on Sundays" := TRUE;
      "No. of Minutes between Runs" := NoofMinutesbetweenRuns;
      "Earliest Start Date/Time" := CURRENTDATETIME;
    END;

    [External]
    PROCEDURE FindJobQueueEntry@23(ObjType@1002 : Option;ObjID@1001 : Integer) : Boolean;
    BEGIN
      RESET;
      SETRANGE("Object Type to Run",ObjType);
      SETRANGE("Object ID to Run",ObjID);
      EXIT(FINDFIRST);
    END;

    [Internal]
    PROCEDURE GetDefaultDescription@28() : Text[250];
    VAR
      DefaultDescription@1004 : Text[250];
    BEGIN
      CALCFIELDS("Object Caption to Run");
      DefaultDescription := COPYSTR("Object Caption to Run",1,MAXSTRLEN(DefaultDescription));
      IF "Object Type to Run" <> "Object Type to Run"::Report THEN
        EXIT(DefaultDescription);
      EXIT(GetDefaultDescriptionFromReportRequestPage(DefaultDescription));
    END;

    LOCAL PROCEDURE GetDefaultDescriptionFromReportRequestPage@29(DefaultDescription@1004 : Text[250]) : Text[250];
    VAR
      AccScheduleName@1005 : Record 84;
      XMLDOMManagement@1003 : Codeunit 6224;
      InStr@1002 : InStream;
      XMLRootNode@1001 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      XMLNode@1000 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
    BEGIN
      IF NOT ("Object ID to Run" IN [REPORT::"Account Schedule"]) THEN
        EXIT(DefaultDescription);

      CALCFIELDS(XML); // Requestpage data
      IF NOT XML.HASVALUE THEN
        EXIT(DefaultDescription);
      XML.CREATEINSTREAM(InStr);
      IF NOT XMLDOMManagement.LoadXMLNodeFromInStream(InStr,XMLRootNode) THEN
        EXIT(DefaultDescription);
      IF ISNULL(XMLRootNode) THEN
        EXIT(DefaultDescription);

      // Specific for report 25 Account Schedule
      XMLNode := XMLRootNode.SelectSingleNode('//Field[@name="AccSchedName"]');
      IF ISNULL(XMLNode) THEN
        EXIT(DefaultDescription);
      IF NOT AccScheduleName.GET(COPYSTR(XMLNode.InnerText,1,MAXSTRLEN(AccScheduleName.Name))) THEN
        EXIT(DefaultDescription);
      EXIT(AccScheduleName.Description);
    END;

    [External]
    PROCEDURE IsToReportInbox@22() : Boolean;
    BEGIN
      EXIT(
        ("Object Type to Run" = "Object Type to Run"::Report) AND
        ("Report Output Type" IN ["Report Output Type"::PDF,"Report Output Type"::Word,
                                  "Report Output Type"::Excel]));
    END;

    LOCAL PROCEDURE UpdateDocumentSentHistory@58();
    VAR
      O365DocumentSentHistory@1001 : Record 2158;
    BEGIN
      IF ("Object Type to Run" = "Object Type to Run"::Codeunit) AND ("Object ID to Run" = CODEUNIT::"Document-Mailing") THEN
        IF (Status = Status::Error) OR (Status = Status::Finished) THEN BEGIN
          O365DocumentSentHistory.SETRANGE("Job Queue Entry ID",ID);
          IF NOT O365DocumentSentHistory.FINDFIRST THEN
            EXIT;

          IF Status = Status::Error THEN
            O365DocumentSentHistory.SetStatusAsFailed
          ELSE
            O365DocumentSentHistory.SetStatusAsSuccessfullyFinished;
        END;
    END;

    [External]
    PROCEDURE FilterInactiveOnHoldEntries@53();
    BEGIN
      RESET;
      SETRANGE(Status,Status::"On Hold with Inactivity Timeout");
    END;

    [External]
    PROCEDURE DoesJobNeedToBeRun@49() Result : Boolean;
    BEGIN
      OnFindingIfJobNeedsToBeRun(Result);
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeScheduleTask@59(VAR JobQueueEntry@1000 : Record 472;VAR TaskGUID@1001 : GUID);
    BEGIN
    END;

    [Integration(TRUE)]
    LOCAL PROCEDURE OnFindingIfJobNeedsToBeRun@50(VAR Result@1000 : Boolean);
    BEGIN
    END;

    BEGIN
    END.
  }
}

