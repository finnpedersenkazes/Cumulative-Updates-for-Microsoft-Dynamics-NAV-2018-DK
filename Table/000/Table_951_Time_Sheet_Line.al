OBJECT Table 951 Time Sheet Line
{
  OBJECT-PROPERTIES
  {
    Date=28-06-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23019;
  }
  PROPERTIES
  {
    Permissions=TableData 5200=r;
    OnInsert=VAR
               Resource@1000 : Record 156;
             BEGIN
               GetTimeSheetResource(Resource);
               CheckResourcePrivacyBlocked(Resource);
               Resource.TESTFIELD(Blocked,FALSE);

               UpdateApproverID;
               "Time Sheet Starting Date" := TimeSheetHeader."Starting Date";
             END;

    OnModify=VAR
               Resource@1000 : Record 156;
             BEGIN
               GetTimeSheetResource(Resource);
               CheckResourcePrivacyBlocked(Resource);
               Resource.TESTFIELD(Blocked,FALSE);

               UpdateDetails;
             END;

    OnDelete=VAR
               TimeSheetCommentLine@1000 : Record 953;
               Resource@1001 : Record 156;
             BEGIN
               TestStatus;

               GetTimeSheetResource(Resource);
               CheckResourcePrivacyBlocked(Resource);
               Resource.TESTFIELD(Blocked,FALSE);

               TimeSheetDetail.SETRANGE("Time Sheet No.","Time Sheet No.");
               TimeSheetDetail.SETRANGE("Time Sheet Line No.","Line No.");
               TimeSheetDetail.DELETEALL;

               TimeSheetCommentLine.SETRANGE("No.","Time Sheet No.");
               TimeSheetCommentLine.SETRANGE("Time Sheet Line No.","Line No.");
               TimeSheetCommentLine.DELETEALL;
             END;

    CaptionML=[DAN=Timeseddellinje;
               ENU=Time Sheet Line];
  }
  FIELDS
  {
    { 1   ;   ;Time Sheet No.      ;Code20        ;TableRelation="Time Sheet Header";
                                                   CaptionML=[DAN=Timeseddelnr.;
                                                              ENU=Time Sheet No.] }
    { 2   ;   ;Line No.            ;Integer       ;CaptionML=[DAN=Linjenr.;
                                                              ENU=Line No.] }
    { 3   ;   ;Time Sheet Starting Date;Date      ;CaptionML=[DAN=Startdato for timeseddel;
                                                              ENU=Time Sheet Starting Date];
                                                   Editable=No }
    { 5   ;   ;Type                ;Option        ;OnValidate=BEGIN
                                                                TestStatus;
                                                                IF Type = Type::"Assembly Order" THEN
                                                                  FIELDERROR(Type);
                                                                IF Type <> xRec.Type THEN BEGIN
                                                                  TimeSheetDetail.SETRANGE("Time Sheet No.","Time Sheet No.");
                                                                  TimeSheetDetail.SETRANGE("Time Sheet Line No.","Line No.");
                                                                  IF NOT TimeSheetDetail.ISEMPTY THEN
                                                                    TimeSheetDetail.DELETEALL;
                                                                  "Job No." := '';
                                                                  "Job Task No." := '';
                                                                  "Service Order No." := '';
                                                                  "Service Order Line No." := 0;
                                                                  "Cause of Absence Code" := '';
                                                                  Description := '';
                                                                  "Assembly Order No." := '';
                                                                  "Assembly Order Line No." := 0;
                                                                  UpdateApproverID;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=" ,Ressource,Sag,Service,Frav�r,Montageordre";
                                                                    ENU=" ,Resource,Job,Service,Absence,Assembly Order"];
                                                   OptionString=[ ,Resource,Job,Service,Absence,Assembly Order] }
    { 6   ;   ;Job No.             ;Code20        ;TableRelation=Job;
                                                   OnValidate=BEGIN
                                                                IF "Job No." <> '' THEN BEGIN
                                                                  TESTFIELD(Type,Type::Job);
                                                                  Job.GET("Job No.");
                                                                  IF Job.Blocked = Job.Blocked::All THEN
                                                                    Job.TestBlocked;
                                                                END;
                                                                VALIDATE("Job Task No.",'');
                                                                UpdateApproverID;
                                                              END;

                                                   CaptionML=[DAN=Sagsnr.;
                                                              ENU=Job No.] }
    { 7   ;   ;Job Task No.        ;Code20        ;TableRelation="Job Task"."Job Task No." WHERE (Job No.=FIELD(Job No.));
                                                   OnValidate=BEGIN
                                                                IF "Job Task No." <> '' THEN BEGIN
                                                                  TESTFIELD(Type,Type::Job);
                                                                  JobTask.GET("Job No.","Job Task No.");
                                                                  JobTask.TESTFIELD("Job Task Type",JobTask."Job Task Type"::Posting);
                                                                  Description := JobTask.Description;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Sagsopgavenr.;
                                                              ENU=Job Task No.] }
    { 9   ;   ;Cause of Absence Code;Code10       ;TableRelation="Cause of Absence";
                                                   OnValidate=VAR
                                                                Resource@1002 : Record 156;
                                                                Employee@1001 : Record 5200;
                                                                CauseOfAbsence@1000 : Record 5206;
                                                              BEGIN
                                                                IF "Cause of Absence Code" <> '' THEN BEGIN
                                                                  TESTFIELD(Type,Type::Absence);
                                                                  CauseOfAbsence.GET("Cause of Absence Code");
                                                                  Description := CauseOfAbsence.Description;
                                                                  TimeSheetHeader.GET("Time Sheet No.");
                                                                  Resource.GET(TimeSheetHeader."Resource No.");
                                                                  Resource.TESTFIELD("Base Unit of Measure");
                                                                  Resource.TESTFIELD(Type,Resource.Type::Person);
                                                                  Employee.RESET;
                                                                  Employee.SETRANGE("Resource No.",TimeSheetHeader."Resource No.");
                                                                  IF Employee.ISEMPTY THEN
                                                                    ERROR(Text001,TimeSheetHeader."Resource No.");
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Frav�rs�rsagskode;
                                                              ENU=Cause of Absence Code] }
    { 10  ;   ;Description         ;Text50        ;OnValidate=BEGIN
                                                                TestStatus;
                                                              END;

                                                   CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 11  ;   ;Work Type Code      ;Code10        ;TableRelation="Work Type";
                                                   OnValidate=BEGIN
                                                                IF ("Work Type Code" <> xRec."Work Type Code") AND ("Work Type Code" <> '') THEN
                                                                  CheckWorkType;
                                                              END;

                                                   CaptionML=[DAN=Arbejdstypekode;
                                                              ENU=Work Type Code] }
    { 12  ;   ;Approver ID         ;Code50        ;TableRelation="User Setup";
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Godkender-id;
                                                              ENU=Approver ID];
                                                   Editable=No }
    { 13  ;   ;Service Order No.   ;Code20        ;TableRelation=IF (Posted=CONST(No)) "Service Header".No. WHERE (Document Type=CONST(Order));
                                                   OnValidate=VAR
                                                                ServiceHeader@1000 : Record 5900;
                                                              BEGIN
                                                                IF "Service Order No." <> '' THEN BEGIN
                                                                  TESTFIELD(Type,Type::Service);
                                                                  ServiceHeader.GET(ServiceHeader."Document Type"::Order,"Service Order No.");
                                                                  Description := COPYSTR(
                                                                      STRSUBSTNO(Text003,"Service Order No.",ServiceHeader."Customer No."),
                                                                      1,
                                                                      MAXSTRLEN(Description));
                                                                END ELSE
                                                                  Description := '';
                                                              END;

                                                   CaptionML=[DAN=Serviceordrenr.;
                                                              ENU=Service Order No.] }
    { 14  ;   ;Service Order Line No.;Integer     ;CaptionML=[DAN=Serviceordrelinjenr.;
                                                              ENU=Service Order Line No.] }
    { 15  ;   ;Total Quantity      ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Time Sheet Detail".Quantity WHERE (Time Sheet No.=FIELD(Time Sheet No.),
                                                                                                       Time Sheet Line No.=FIELD(Line No.)));
                                                   CaptionML=[DAN=I alt;
                                                              ENU=Total Quantity];
                                                   Editable=No }
    { 17  ;   ;Chargeable          ;Boolean       ;InitValue=Yes;
                                                   CaptionML=[DAN=Fakturerbar;
                                                              ENU=Chargeable] }
    { 18  ;   ;Assembly Order No.  ;Code20        ;TableRelation=IF (Posted=CONST(No)) "Assembly Header".No. WHERE (Document Type=CONST(Order));
                                                   CaptionML=[DAN=Montageordrenr.;
                                                              ENU=Assembly Order No.];
                                                   Editable=No }
    { 19  ;   ;Assembly Order Line No.;Integer    ;CaptionML=[DAN=Montageordrelinjenr.;
                                                              ENU=Assembly Order Line No.];
                                                   Editable=No }
    { 20  ;   ;Status              ;Option        ;CaptionML=[DAN=Status;
                                                              ENU=Status];
                                                   OptionCaptionML=[DAN=�ben,Sendt,Afvist,Godkendt;
                                                                    ENU=Open,Submitted,Rejected,Approved];
                                                   OptionString=Open,Submitted,Rejected,Approved;
                                                   Editable=No }
    { 21  ;   ;Approved By         ;Code50        ;TableRelation="User Setup";
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Godkendt af;
                                                              ENU=Approved By];
                                                   Editable=No }
    { 22  ;   ;Approval Date       ;Date          ;CaptionML=[DAN=Godkendelsesdato;
                                                              ENU=Approval Date];
                                                   Editable=No }
    { 23  ;   ;Posted              ;Boolean       ;CaptionML=[DAN=Bogf�rt;
                                                              ENU=Posted];
                                                   Editable=No }
    { 26  ;   ;Comment             ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Time Sheet Comment Line" WHERE (No.=FIELD(Time Sheet No.),
                                                                                                      Time Sheet Line No.=FIELD(Line No.)));
                                                   CaptionML=[DAN=Bem�rkning;
                                                              ENU=Comment];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Time Sheet No.,Line No.                 ;Clustered=Yes }
    {    ;Type                                     }
    {    ;Time Sheet No.,Status,Posted             }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      ResourcesSetup@1005 : Record 314;
      Job@1001 : Record 167;
      JobTask@1000 : Record 1001;
      TimeSheetHeader@1004 : Record 950;
      TimeSheetDetail@1003 : Record 952;
      Text001@1002 : TextConst 'DAN=Der er ingen medarbejdere knyttet til ressourcen %1.;ENU=There is no employee linked with resource %1.';
      Text002@1006 : TextConst 'DAN="Status skal v�re �ben eller Afvist i overensstemmelse med timeseddelnr. ''%1'', linjenr.=''%2''.";ENU="Status must be Open or Rejected in line with Time Sheet No.=''%1'', Line No.=''%2''."';
      Text003@1007 : TextConst 'DAN=Serviceordre %1 til debitor %2;ENU=Service order %1 for customer %2';
      Text005@1009 : TextConst 'DAN=V�lg en type, f�r du indtaster en aktivitet.;ENU=Select a type before you enter an activity.';
      PrivacyBlockedErr@1008 : TextConst '@@@="%1=resource no.";DAN=Du kan ikke anvende ressourcen %1, fordi de er markeret som blokeret pga. beskyttelse af personlige oplysninger.;ENU=You cannot use resource %1 because they are marked as blocked due to privacy.';

    [External]
    PROCEDURE TestStatus@3();
    BEGIN
      IF NOT (Status IN [Status::Open,Status::Rejected]) THEN
        ERROR(
          Text002,
          "Time Sheet No.",
          "Line No.");
    END;

    LOCAL PROCEDURE UpdateDetails@1();
    VAR
      TimeSheetDetail@1000 : Record 952;
    BEGIN
      TimeSheetDetail.SETRANGE("Time Sheet No.","Time Sheet No.");
      TimeSheetDetail.SETRANGE("Time Sheet Line No.","Line No.");
      IF TimeSheetDetail.FINDSET(TRUE) THEN
        REPEAT
          TimeSheetDetail.CopyFromTimeSheetLine(Rec);
          TimeSheetDetail.MODIFY;
        UNTIL TimeSheetDetail.NEXT = 0;
    END;

    LOCAL PROCEDURE GetTimeSheetResource@9(VAR Resource@1000 : Record 156);
    BEGIN
      TimeSheetHeader.GET("Time Sheet No.");
      Resource.GET(TimeSheetHeader."Resource No.");
    END;

    LOCAL PROCEDURE GetJobApproverID@6() : Code[50];
    VAR
      Resource@1000 : Record 156;
    BEGIN
      Job.GET("Job No.");
      Job.TESTFIELD("Person Responsible");
      Resource.GET(Job."Person Responsible");
      Resource.TESTFIELD("Time Sheet Owner User ID");
      EXIT(Resource."Time Sheet Owner User ID");
    END;

    [External]
    PROCEDURE UpdateApproverID@2();
    VAR
      Resource@1001 : Record 156;
    BEGIN
      ResourcesSetup.GET;
      GetTimeSheetResource(Resource);
      IF (Type = Type::Job) AND ("Job No." <> '') AND
         (((Resource.Type = Resource.Type::Person) AND
           (ResourcesSetup."Time Sheet by Job Approval" = ResourcesSetup."Time Sheet by Job Approval"::Always)) OR
          ((Resource.Type = Resource.Type::Machine) AND
           (ResourcesSetup."Time Sheet by Job Approval" IN [ResourcesSetup."Time Sheet by Job Approval"::"Machine Only",
                                                            ResourcesSetup."Time Sheet by Job Approval"::Always])))
      THEN
        "Approver ID" := GetJobApproverID
      ELSE BEGIN
        Resource.TESTFIELD("Time Sheet Approver User ID");
        "Approver ID" := Resource."Time Sheet Approver User ID";
      END;
    END;

    LOCAL PROCEDURE CheckWorkType@5();
    VAR
      Resource@1001 : Record 156;
      WorkType@1000 : Record 200;
    BEGIN
      IF WorkType.GET("Work Type Code") THEN BEGIN
        GetTimeSheetResource(Resource);
        WorkType.TESTFIELD("Unit of Measure Code",Resource."Base Unit of Measure");
      END;
    END;

    [External]
    PROCEDURE ShowLineDetails@4(ManagerRole@1004 : Boolean);
    VAR
      TimeSheetLineResDetail@1000 : Page 965;
      TimeSheetLineJobDetail@1003 : Page 966;
      TimeSheetLineServiceDetail@1005 : Page 967;
      TimeSheetLineAssembDetail@1006 : Page 968;
      TimeSheetLineAbsenceDetail@1007 : Page 969;
    BEGIN
      CASE Type OF
        Type::Resource:
          BEGIN
            TimeSheetLineResDetail.SetParameters(Rec,ManagerRole);
            IF TimeSheetLineResDetail.RUNMODAL = ACTION::OK THEN
              TimeSheetLineResDetail.GETRECORD(Rec);
          END;
        Type::Job:
          BEGIN
            TimeSheetLineJobDetail.SetParameters(Rec,ManagerRole);
            IF TimeSheetLineJobDetail.RUNMODAL = ACTION::OK THEN
              TimeSheetLineJobDetail.GETRECORD(Rec);
          END;
        Type::Absence:
          BEGIN
            TimeSheetLineAbsenceDetail.SetParameters(Rec,ManagerRole);
            IF TimeSheetLineAbsenceDetail.RUNMODAL = ACTION::OK THEN
              TimeSheetLineAbsenceDetail.GETRECORD(Rec);
          END;
        Type::Service:
          BEGIN
            TimeSheetLineServiceDetail.SetParameters(Rec,ManagerRole);
            IF TimeSheetLineServiceDetail.RUNMODAL = ACTION::OK THEN
              TimeSheetLineServiceDetail.GETRECORD(Rec);
          END;
        Type::"Assembly Order":
          BEGIN
            TimeSheetLineAssembDetail.SetParameters(Rec);
            IF TimeSheetLineAssembDetail.RUNMODAL = ACTION::OK THEN
              TimeSheetLineAssembDetail.GETRECORD(Rec);
          END;
        ELSE
          ERROR(Text005);
      END;
      MODIFY;
    END;

    [External]
    PROCEDURE GetAllowEdit@8(FldNo@1001 : Integer;ManagerRole@1000 : Boolean) : Boolean;
    BEGIN
      IF ManagerRole THEN
        EXIT((FldNo IN [FIELDNO("Work Type Code"),FIELDNO(Chargeable)]) AND (Status = Status::Submitted));

      EXIT(Status IN [Status::Open,Status::Rejected]);
    END;

    LOCAL PROCEDURE CheckResourcePrivacyBlocked@7(Resource@1000 : Record 156);
    BEGIN
      IF Resource."Privacy Blocked" THEN
        ERROR(PrivacyBlockedErr,Resource."No.");
    END;

    BEGIN
    END.
  }
}

