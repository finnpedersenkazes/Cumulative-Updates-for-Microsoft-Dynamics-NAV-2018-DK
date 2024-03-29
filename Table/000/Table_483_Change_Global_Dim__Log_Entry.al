OBJECT Table 483 Change Global Dim. Log Entry
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    Permissions=TableData 17=rm,
                TableData 21=rm,
                TableData 25=rm,
                TableData 32=rm,
                TableData 110=rm,
                TableData 111=rm,
                TableData 112=rm,
                TableData 113=rm,
                TableData 114=rm,
                TableData 115=rm,
                TableData 120=rm,
                TableData 121=rm,
                TableData 122=rm,
                TableData 123=rm,
                TableData 124=rm,
                TableData 125=rm,
                TableData 169=rm,
                TableData 203=rm,
                TableData 271=rm,
                TableData 281=rm,
                TableData 297=rm,
                TableData 304=rm,
                TableData 379=rm,
                TableData 380=rm,
                TableData 1005=rm,
                TableData 5222=rm,
                TableData 5223=rm,
                TableData 5405=rm,
                TableData 5406=rm,
                TableData 5407=rm,
                TableData 5409=rm,
                TableData 5410=rm,
                TableData 5411=rm,
                TableData 5412=rm,
                TableData 5413=rm,
                TableData 5414=rm,
                TableData 5415=rm,
                TableData 5416=rm,
                TableData 5601=rm,
                TableData 5625=rm,
                TableData 5629=rm,
                TableData 5802=rm,
                TableData 5832=rm,
                TableData 5900=rm,
                TableData 5901=rm,
                TableData 5902=rm,
                TableData 5907=rm,
                TableData 5965=rm,
                TableData 5970=rm,
                TableData 6650=rm,
                TableData 6651=rm,
                TableData 6660=rm,
                TableData 6661=rm;
    CaptionML=[DAN=Rediger global dim.logpost;
               ENU=Change Global Dim. Log Entry];
  }
  FIELDS
  {
    { 1   ;   ;Table ID            ;Integer       ;CaptionML=[DAN=Tabel-id;
                                                              ENU=Table ID] }
    { 2   ;   ;Table Name          ;Text50        ;CaptionML=[DAN=Tabelnavn;
                                                              ENU=Table Name] }
    { 3   ;   ;Total Records       ;Integer       ;CaptionML=[DAN=Samlet antal records;
                                                              ENU=Total Records] }
    { 4   ;   ;Completed Records   ;Integer       ;OnValidate=BEGIN
                                                                CalcProgress;
                                                              END;

                                                   CaptionML=[DAN=Fuldf�rte records;
                                                              ENU=Completed Records] }
    { 5   ;   ;Progress            ;Decimal       ;ExtendedDatatype=Ratio;
                                                   CaptionML=[DAN="Status ";
                                                              ENU=Progress] }
    { 6   ;   ;Status              ;Option        ;CaptionML=[DAN=Status;
                                                              ENU=Status];
                                                   OptionCaptionML=[DAN=" ,Planlagt,Igangv�rende,Afsluttet,Ikke fuldf�rt";
                                                                    ENU=" ,Scheduled,In Progress,Completed,Incomplete"];
                                                   OptionString=[ ,Scheduled,In Progress,Completed,Incomplete] }
    { 7   ;   ;Task ID             ;GUID          ;CaptionML=[DAN=Opgave-id;
                                                              ENU=Task ID] }
    { 8   ;   ;Session ID          ;Integer       ;CaptionML=[DAN=Sessions-id;
                                                              ENU=Session ID] }
    { 9   ;   ;Change Type 1       ;Option        ;CaptionML=[DAN=�ndringstype 1;
                                                              ENU=Change Type 1];
                                                   OptionCaptionML=[DAN=Ingen,Tom,Erstat,Ny;
                                                                    ENU=None,Blank,Replace,New];
                                                   OptionString=None,Blank,Replace,New }
    { 10  ;   ;Change Type 2       ;Option        ;CaptionML=[DAN=�ndringstype 2;
                                                              ENU=Change Type 2];
                                                   OptionCaptionML=[DAN=Ingen,Tom,Erstat,Ny;
                                                                    ENU=None,Blank,Replace,New];
                                                   OptionString=None,Blank,Replace,New }
    { 11  ;   ;Global Dim.1 Field No.;Integer     ;CaptionML=[DAN=Global dim. 1-feltnr.;
                                                              ENU=Global Dim.1 Field No.] }
    { 12  ;   ;Global Dim.2 Field No.;Integer     ;CaptionML=[DAN=Global dim. 2-feltnr.;
                                                              ENU=Global Dim.2 Field No.] }
    { 13  ;   ;Dim. Set ID Field No.;Integer      ;CaptionML=[DAN=Dim.s�t id-feltnr.;
                                                              ENU=Dim. Set ID Field No.] }
    { 14  ;   ;Primary Key Field No.;Integer      ;CaptionML=[DAN=Nr. p� prim�rn�glefelt;
                                                              ENU=Primary Key Field No.] }
    { 15  ;   ;Parent Table ID     ;Integer       ;CaptionML=[DAN=Overordnet tabel-id;
                                                              ENU=Parent Table ID] }
    { 16  ;   ;Is Parent Table     ;Boolean       ;CaptionML=[DAN=Er overordnet tabel;
                                                              ENU=Is Parent Table] }
    { 17  ;   ;Earliest Start Date/Time;DateTime  ;CaptionML=[DAN=Tidligste startdato/-tidspunkt;
                                                              ENU=Earliest Start Date/Time] }
    { 18  ;   ;Remaining Duration  ;Duration      ;CaptionML=[DAN=Resterende varighed;
                                                              ENU=Remaining Duration] }
    { 19  ;   ;Server Instance ID  ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Serverforekomst-id;
                                                              ENU=Server Instance ID] }
  }
  KEYS
  {
    {    ;Table ID                                ;Clustered=Yes }
    {    ;Progress                                 }
    {    ;Parent Table ID                          }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    LOCAL PROCEDURE CalcProgress@1();
    BEGIN
      Progress := 10000;
      IF ("Total Records" <> 0) AND ("Completed Records" <= "Total Records") THEN
        Progress := "Completed Records" / "Total Records" * 10000;
    END;

    PROCEDURE Update@37(CurrentRecNo@1000 : Integer;StartedFromRecord@1001 : Integer) : Boolean;
    BEGIN
      IF "Completed Records" = CurrentRecNo THEN
        EXIT(FALSE);

      IF CurrentRecNo >= "Total Records" THEN
        RecalculateTotalRecords;
      VALIDATE("Completed Records",CurrentRecNo);
      CASE "Completed Records" OF
        0:
          BEGIN
            Status := Status::Incomplete;
            CLEAR("Remaining Duration");
          END;
        "Total Records":
          Status := Status::Completed;
        ELSE
          IF CurrentRecNo - StartedFromRecord <> 0 THEN
            "Remaining Duration" :=
              ROUND(
                ("Total Records" - CurrentRecNo) / (CurrentRecNo - StartedFromRecord) *
                (CURRENTDATETIME - "Earliest Start Date/Time"),1);
      END;
      EXIT(MODIFY);
    END;

    PROCEDURE UpdateWithCommit@28(CurrentRecNo@1000 : Integer;StartedFromRecord@1001 : Integer) Completed : Boolean;
    BEGIN
      IF Update(CurrentRecNo,StartedFromRecord) THEN
        COMMIT;
      Completed := Status = Status::Completed;
    END;

    PROCEDURE UpdateWithoutCommit@7(CurrentRecNo@1000 : Integer;StartedFromRecord@1001 : Integer) Completed : Boolean;
    BEGIN
      Update(CurrentRecNo,StartedFromRecord);
      Completed := Status = Status::Completed;
    END;

    [External]
    PROCEDURE CancelTask@8();
    VAR
      ScheduledTask@1000 : Record 2000000175;
    BEGIN
      IF NOT ISNULLGUID("Task ID") THEN BEGIN
        IF ScheduledTask.GET("Task ID") THEN
          TASKSCHEDULER.CANCELTASK("Task ID");
        CLEAR("Task ID");
      END;
    END;

    PROCEDURE ChangeDimOnRecord@22(VAR RecRef@1000 : RecordRef;DimNo@1001 : Integer;GlobalDimFieldRef@1003 : FieldRef;OldDimValueCode@1004 : Code[20]);
    VAR
      NewValue@1002 : Code[20];
    BEGIN
      CASE GetChangeType(DimNo) OF
        "Change Type 1"::New:
          NewValue := FindDimensionValueCode(RecRef,DimNo);
        "Change Type 1"::Blank:
          NewValue := '';
        "Change Type 1"::Replace:
          NewValue := OldDimValueCode;
        "Change Type 1"::None:
          EXIT;
      END;
      GlobalDimFieldRef.VALUE(NewValue);
    END;

    PROCEDURE GetFieldRefValues@32(RecRef@1002 : RecordRef;VAR GlobalDimFieldRef@1001 : ARRAY [2] OF FieldRef;VAR DimValueCode@1000 : ARRAY [2] OF Code[20]);
    BEGIN
      GlobalDimFieldRef[1] := RecRef.FIELD("Global Dim.1 Field No.");
      DimValueCode[1] := GlobalDimFieldRef[1].VALUE;
      GlobalDimFieldRef[2] := RecRef.FIELD("Global Dim.2 Field No.");
      DimValueCode[2] := GlobalDimFieldRef[2].VALUE;
    END;

    PROCEDURE FindDimensionSetIDField@27(RecRef@1000 : RecordRef) : Boolean;
    VAR
      Field@1001 : Record 2000000041;
    BEGIN
      IF RecRef.FIELDEXIST(480) THEN BEGIN // W1 "Dimension Set ID" fields must have ID = 480
        "Dim. Set ID Field No." := 480;
        EXIT(TRUE);
      END;
      Field.SETRANGE(TableNo,RecRef.NUMBER);
      Field.SETRANGE(RelationTableNo,DATABASE::"Dimension Set Entry");
      Field.SETRANGE(FieldName,'Dimension Set ID');
      Field.SETFILTER(ObsoleteState,'<>%1',Field.ObsoleteState::Removed);
      IF Field.FINDFIRST THEN BEGIN
        "Dim. Set ID Field No." := Field."No.";
        EXIT(TRUE);
      END;
    END;

    PROCEDURE FindDimensionValueCode@5(RecRef@1003 : RecordRef;DimNo@1000 : Integer) : Code[20];
    VAR
      GeneralLedgerSetup@1001 : Record 98;
      DimensionCode@1002 : Code[20];
    BEGIN
      GeneralLedgerSetup.GET;
      CASE DimNo OF
        1:
          DimensionCode := GeneralLedgerSetup."Global Dimension 1 Code";
        2:
          DimensionCode := GeneralLedgerSetup."Global Dimension 2 Code";
      END;
      IF "Dim. Set ID Field No." = 0 THEN BEGIN
        IF RecRef.NUMBER = DATABASE::"Job Task" THEN
          EXIT(FindJobTaskDimensionValueCode(RecRef,DimensionCode));
        EXIT(FindDefaultDimensionValueCode(RecRef,DimensionCode));
      END;
      EXIT(FindDimSetDimensionValueCode(RecRef,DimensionCode));
    END;

    LOCAL PROCEDURE FindDefaultDimensionValueCode@9(RecRef@1002 : RecordRef;DimensionCode@1001 : Code[20]) : Code[20];
    VAR
      DefaultDimension@1000 : Record 352;
      PKFieldRef@1003 : FieldRef;
    BEGIN
      PKFieldRef := RecRef.FIELD("Primary Key Field No.");
      IF DefaultDimension.GET(RecRef.NUMBER,PKFieldRef.VALUE,DimensionCode) THEN
        EXIT(DefaultDimension."Dimension Value Code");
      EXIT('');
    END;

    LOCAL PROCEDURE FindDimSetDimensionValueCode@11(RecRef@1000 : RecordRef;DimensionCode@1001 : Code[20]) : Code[20];
    VAR
      DimensionSetEntry@1004 : Record 480;
      DimSetIDFieldRef@1003 : FieldRef;
    BEGIN
      DimSetIDFieldRef := RecRef.FIELD("Dim. Set ID Field No.");
      IF DimensionSetEntry.GET(DimSetIDFieldRef.VALUE,DimensionCode) THEN
        EXIT(DimensionSetEntry."Dimension Value Code");
      EXIT('');
    END;

    LOCAL PROCEDURE FindJobTaskDimensionValueCode@12(RecRef@1001 : RecordRef;DimensionCode@1000 : Code[20]) : Code[20];
    VAR
      JobTask@1002 : Record 1001;
      JobTaskDimension@1003 : Record 1002;
    BEGIN
      RecRef.SETTABLE(JobTask);
      IF JobTaskDimension.GET(JobTask."Job No.",JobTask."Job Task No.",DimensionCode) THEN
        EXIT(JobTaskDimension."Dimension Value Code");
      EXIT('');
    END;

    LOCAL PROCEDURE FindParentTable@14(RecRef@1000 : RecordRef) : Integer;
    VAR
      ParentKeyFieldRef@1001 : FieldRef;
    BEGIN
      IF RecRef.FIELDEXIST(2) THEN BEGIN // typical for Detailed Ledger Entry tables
        ParentKeyFieldRef := RecRef.FIELD(2);
        IF FORMAT(ParentKeyFieldRef.TYPE) = 'Integer' THEN
          EXIT(ParentKeyFieldRef.RELATION);
      END;
    END;

    PROCEDURE FillData@10(RecRef@1001 : RecordRef);
    VAR
      PKeyFieldRef@1002 : FieldRef;
    BEGIN
      "Total Records" := RecRef.COUNT;
      IF NOT FindDimensionSetIDField(RecRef) THEN BEGIN
        GetPrimaryKeyFieldRef(RecRef,PKeyFieldRef);
        IF FORMAT(PKeyFieldRef.TYPE) = 'Code' THEN
          "Primary Key Field No." := PKeyFieldRef.NUMBER
        ELSE
          "Parent Table ID" := FindParentTable(RecRef);
      END;
      FindFieldIDs;
    END;

    LOCAL PROCEDURE FindFieldIDs@2();
    VAR
      Field@1000 : Record 2000000041;
      DimensionManagement@1001 : Codeunit 408;
    BEGIN
      IF DimensionManagement.FindDimFieldInTable("Table ID",'Dimension 1 Code*|*Global Dim. 1',Field) THEN
        "Global Dim.1 Field No." := Field."No.";
      IF DimensionManagement.FindDimFieldInTable("Table ID",'Dimension 2 Code*|*Global Dim. 2',Field) THEN
        "Global Dim.2 Field No." := Field."No.";
    END;

    LOCAL PROCEDURE GetChangeType@16(DimNo@1000 : Integer) : Integer;
    BEGIN
      IF DimNo = 1 THEN
        EXIT("Change Type 1");
      EXIT("Change Type 2");
    END;

    PROCEDURE GetPrimaryKeyFieldRef@19(RecRef@1000 : RecordRef;VAR PKeyFieldRef@1001 : FieldRef);
    VAR
      PKeyRef@1002 : KeyRef;
    BEGIN
      PKeyRef := RecRef.KEYINDEX(1);
      PKeyFieldRef := PKeyRef.FIELDINDEX(1);
    END;

    LOCAL PROCEDURE RecalculateTotalRecords@21();
    VAR
      RecRef@1000 : RecordRef;
    BEGIN
      RecRef.OPEN("Table ID");
      "Total Records" := RecRef.COUNT;
      RecRef.CLOSE;
    END;

    PROCEDURE SetSessionInProgress@6();
    BEGIN
      "Session ID" := SESSIONID;
      "Server Instance ID" := SERVICEINSTANCEID;
      Status := Status::"In Progress";
      MODIFY;
    END;

    PROCEDURE UpdateStatus@4() OldStatus : Integer;
    VAR
      ActiveSession@1000 : Record 2000000110;
    BEGIN
      OldStatus := Status;
      IF ISNULLGUID("Task ID") THEN
        Status := Status::" "
      ELSE
        IF "Completed Records" = "Total Records" THEN BEGIN
          "Session ID" := -1; // to avoid match to real user sessions
          "Server Instance ID" := -1;
          Status := Status::Completed
        END ELSE
          IF "Session ID" = 0 THEN BEGIN
            IF IsTaskScheduled THEN
              Status := Status::Scheduled
            ELSE
              Status := Status::Incomplete;
          END ELSE
            IF ActiveSession.GET("Server Instance ID","Session ID") THEN
              Status := Status::"In Progress"
            ELSE BEGIN
              Status := Status::Incomplete;
              "Session ID" := -1;
              "Server Instance ID" := -1;
            END;
    END;

    PROCEDURE ShowError@3();
    VAR
      JobQueueLogEntry@1000 : Record 474;
    BEGIN
      IF ISNULLGUID("Task ID") THEN BEGIN
        JobQueueLogEntry.SETRANGE("Object Type to Run",JobQueueLogEntry."Object Type to Run"::Codeunit);
        JobQueueLogEntry.SETRANGE("Object ID to Run",CODEUNIT::"Change Global Dim Err. Handler");
        JobQueueLogEntry.SETRANGE(Description,"Table Name");
      END ELSE
        JobQueueLogEntry.SETRANGE(ID,"Task ID");
      JobQueueLogEntry.SETRANGE(Status,JobQueueLogEntry.Status::Error);
      PAGE.RUNMODAL(PAGE::"Job Queue Log Entries",JobQueueLogEntry);
    END;

    LOCAL PROCEDURE IsTaskScheduled@17() TaskExists : Boolean;
    VAR
      ScheduledTask@1000 : Record 2000000175;
    BEGIN
      OnFindingScheduledTask("Task ID",TaskExists);
      IF NOT TaskExists THEN
        EXIT(ScheduledTask.GET("Task ID"));
    END;

    [Business]
    LOCAL PROCEDURE OnFindingScheduledTask@15(TaskID@1001 : GUID;VAR IsTaskExist@1000 : Boolean);
    BEGIN
    END;

    BEGIN
    END.
  }
}

