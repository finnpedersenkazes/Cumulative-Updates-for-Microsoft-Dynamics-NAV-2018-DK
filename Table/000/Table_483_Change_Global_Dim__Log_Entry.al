OBJECT Table 483 Change Global Dim. Log Entry
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Rediger global dim.logpost;
               ENU=Change Global Dim. Log Entry];
  }
  FIELDS
  {
    { 1   ;   ;Table ID            ;Integer       ;CaptionML=[DAN=Tabel-id;
                                                              ENU=Table ID] }
    { 2   ;   ;Table Name          ;Text30        ;CaptionML=[DAN=Tabelnavn;
                                                              ENU=Table Name] }
    { 3   ;   ;Total Records       ;Integer       ;CaptionML=[DAN=Samlet antal records;
                                                              ENU=Total Records] }
    { 4   ;   ;Completed Records   ;Integer       ;OnValidate=BEGIN
                                                                CalcProgress;
                                                              END;

                                                   CaptionML=[DAN=Fuldf›rte records;
                                                              ENU=Completed Records] }
    { 5   ;   ;Progress            ;Decimal       ;ExtendedDatatype=Ratio;
                                                   CaptionML=[DAN="Status ";
                                                              ENU=Progress] }
    { 6   ;   ;Status              ;Option        ;CaptionML=[DAN=Status;
                                                              ENU=Status];
                                                   OptionCaptionML=[DAN=" ,Planlagt,Igangv‘rende,Afsluttet,Ikke fuldf›rt";
                                                                    ENU=" ,Scheduled,In Progress,Completed,Incomplete"];
                                                   OptionString=[ ,Scheduled,In Progress,Completed,Incomplete] }
    { 7   ;   ;Task ID             ;GUID          ;CaptionML=[DAN=Opgave-id;
                                                              ENU=Task ID] }
    { 8   ;   ;Session ID          ;Integer       ;CaptionML=[DAN=Sessions-id;
                                                              ENU=Session ID] }
    { 9   ;   ;Change Type 1       ;Option        ;CaptionML=[DAN=’ndringstype 1;
                                                              ENU=Change Type 1];
                                                   OptionCaptionML=[DAN=Ingen,Tom,Erstat,Ny;
                                                                    ENU=None,Blank,Replace,New];
                                                   OptionString=None,Blank,Replace,New }
    { 10  ;   ;Change Type 2       ;Option        ;CaptionML=[DAN=’ndringstype 2;
                                                              ENU=Change Type 2];
                                                   OptionCaptionML=[DAN=Ingen,Tom,Erstat,Ny;
                                                                    ENU=None,Blank,Replace,New];
                                                   OptionString=None,Blank,Replace,New }
    { 11  ;   ;Global Dim.1 Field No.;Integer     ;CaptionML=[DAN=Global dim. 1-feltnr.;
                                                              ENU=Global Dim.1 Field No.] }
    { 12  ;   ;Global Dim.2 Field No.;Integer     ;CaptionML=[DAN=Global dim. 2-feltnr.;
                                                              ENU=Global Dim.2 Field No.] }
    { 13  ;   ;Dim. Set ID Field No.;Integer      ;CaptionML=[DAN=Dim.s‘t id-feltnr.;
                                                              ENU=Dim. Set ID Field No.] }
    { 14  ;   ;Primary Key Field No.;Integer      ;CaptionML=[DAN=Nr. p† prim‘rn›glefelt;
                                                              ENU=Primary Key Field No.] }
    { 15  ;   ;Parent Table ID     ;Integer       ;CaptionML=[DAN=Overordnet tabel-id;
                                                              ENU=Parent Table ID] }
    { 16  ;   ;Is Parent Table     ;Boolean       ;CaptionML=[DAN=Er overordnet tabel;
                                                              ENU=Is Parent Table] }
    { 17  ;   ;Earliest Start Date/Time;DateTime  ;CaptionML=[DAN=Tidligste startdato/-tidspunkt;
                                                              ENU=Earliest Start Date/Time] }
    { 18  ;   ;Remaining Duration  ;Duration      ;CaptionML=[DAN=Resterende varighed;
                                                              ENU=Remaining Duration] }
  }
  KEYS
  {
    {    ;Table ID                                ;Clustered=Yes }
    {    ;Progress                                 }
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
      IF "Completed Records" <> CurrentRecNo THEN BEGIN
        "Remaining Duration" :=
          ROUND(
            ("Total Records" - CurrentRecNo) / (CurrentRecNo - StartedFromRecord) *
            (CURRENTDATETIME - "Earliest Start Date/Time"),1);
        VALIDATE("Completed Records",CurrentRecNo);
        IF "Completed Records" = "Total Records" THEN
          UpdateStatus;
        EXIT(MODIFY);
      END;
      EXIT(FALSE);
    END;

    PROCEDURE UpdateWithCommit@28(CurrentRecNo@1000 : Integer;StartedFromRecord@1001 : Integer) Completed : Boolean;
    BEGIN
      IF Update(CurrentRecNo,StartedFromRecord) THEN
        COMMIT;
      Completed := Status = Status::Completed;
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

    PROCEDURE FindDependentTableNo@23(ParentChangeGlobalDimLogEntry@1000 : Record 483;VAR DependentRecRef@1001 : RecordRef) : Boolean;
    BEGIN
      IF ParentChangeGlobalDimLogEntry."Is Parent Table" THEN BEGIN
        SETRANGE("Parent Table ID",ParentChangeGlobalDimLogEntry."Table ID");
        IF FINDFIRST THEN BEGIN
          DependentRecRef.OPEN("Table ID");
          DependentRecRef.LOCKTABLE(TRUE);
          "Total Records" := DependentRecRef.COUNT;
          "Session ID" := SESSIONID;
          EXIT("Total Records" > 0);
        END;
      END;
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

    [Internal]
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

    PROCEDURE Rerun@18();
    VAR
      ChangeGlobalDimensions@1000 : Codeunit 483;
    BEGIN
      UpdateStatus;
      ChangeGlobalDimensions.Rerun(Rec);
    END;

    PROCEDURE RunTask@7() Completed : Boolean;
    VAR
      ChangeGlobalDimensions@1000 : Codeunit 483;
    BEGIN
      SetSessionInProgress;
      COMMIT;
      Completed := ChangeGlobalDimensions.ChangeDimsOnTable(Rec);
    END;

    PROCEDURE SetSessionInProgress@6();
    BEGIN
      "Session ID" := SESSIONID;
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
          Status := Status::Completed
        END ELSE
          IF "Session ID" = 0 THEN BEGIN
            IF IsTaskScheduled THEN
              Status := Status::Scheduled
            ELSE
              Status := Status::Incomplete;
          END ELSE
            IF ActiveSession.GET(SERVICEINSTANCEID,"Session ID") THEN
              Status := Status::"In Progress"
            ELSE
              Status := Status::Incomplete;
    END;

    LOCAL PROCEDURE IsTaskScheduled@17() TaskExists : Boolean;
    BEGIN
      OnFindingScheduledTask("Task ID",TaskExists);
      IF NOT TaskExists THEN
        EXIT(TASKSCHEDULER.TASKEXISTS("Task ID"));
    END;

    [Business]
    LOCAL PROCEDURE OnFindingScheduledTask@15(TaskID@1001 : GUID;VAR IsTaskExist@1000 : Boolean);
    BEGIN
    END;

    BEGIN
    END.
  }
}

