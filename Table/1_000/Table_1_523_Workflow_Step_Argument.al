OBJECT Table 1523 Workflow Step Argument
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    Permissions=TableData 1523=rim;
    DataCaptionFields=General Journal Template Name,General Journal Batch Name,Notification User ID;
    OnInsert=BEGIN
               ID := CREATEGUID;
             END;

    OnModify=BEGIN
               CheckEditingIsAllowed;
             END;

    OnDelete=BEGIN
               CheckEditingIsAllowed;
             END;

    OnRename=BEGIN
               CheckEditingIsAllowed;
             END;

    CaptionML=[DAN=Argument i workflowtrin;
               ENU=Workflow Step Argument];
    LookupPageID=Page1523;
  }
  FIELDS
  {
    { 1   ;   ;ID                  ;GUID          ;CaptionML=[DAN=Id;
                                                              ENU=ID] }
    { 2   ;   ;Type                ;Option        ;TableRelation="Workflow Step".Type WHERE (Argument=FIELD(ID));
                                                   CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=H‘ndelse,Svar;
                                                                    ENU=Event,Response];
                                                   OptionString=Event,Response }
    { 3   ;   ;General Journal Template Name;Code10;
                                                   TableRelation="Gen. Journal Template".Name;
                                                   CaptionML=[DAN=Finanskladdetype - navn;
                                                              ENU=General Journal Template Name] }
    { 4   ;   ;General Journal Batch Name;Code10  ;TableRelation="Gen. Journal Batch".Name WHERE (Journal Template Name=FIELD(General Journal Template Name));
                                                   CaptionML=[DAN=Finanskladdenavn;
                                                              ENU=General Journal Batch Name] }
    { 5   ;   ;Notification User ID;Code50        ;TableRelation="User Setup"."User ID";
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Notifikationens bruger-id;
                                                              ENU=Notification User ID] }
    { 6   ;   ;Notification User License Type;Option;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Lookup(User."License Type" WHERE (User Name=FIELD(Notification User ID)));
                                                   CaptionML=[DAN=Notifikation om brugerlicenstype;
                                                              ENU=Notification User License Type];
                                                   OptionCaptionML=[DAN=Fuld bruger,Begr‘nset bruger,Enhedsbruger,Windows-gruppe,Ekstern bruger;
                                                                    ENU=Full User,Limited User,Device Only User,Windows Group,External User];
                                                   OptionString=Full User,Limited User,Device Only User,Windows Group,External User }
    { 7   ;   ;Response Function Name;Code128     ;TableRelation="Workflow Response"."Function Name";
                                                   CaptionML=[DAN=Svarets funktionsnavn;
                                                              ENU=Response Function Name] }
    { 9   ;   ;Link Target Page    ;Integer       ;TableRelation=AllObjWithCaption."Object ID" WHERE (Object Type=CONST(Page));
                                                   CaptionML=[DAN=Side, der linkes til;
                                                              ENU=Link Target Page] }
    { 10  ;   ;Custom Link         ;Text250       ;OnValidate=VAR
                                                                WebRequestHelper@1000 : Codeunit 1299;
                                                              BEGIN
                                                                IF "Custom Link" <> '' THEN
                                                                  WebRequestHelper.IsValidUri("Custom Link");
                                                              END;

                                                   ExtendedDatatype=URL;
                                                   CaptionML=[DAN=Brugerdefineret link;
                                                              ENU=Custom Link] }
    { 11  ;   ;Event Conditions    ;BLOB          ;CaptionML=[DAN=H‘ndelsesbetingelser;
                                                              ENU=Event Conditions] }
    { 12  ;   ;Approver Type       ;Option        ;CaptionML=[DAN=Godkendertype;
                                                              ENU=Approver Type];
                                                   OptionCaptionML=[DAN=S‘lger/K›ber,Godkender,Workflowbrugergruppe;
                                                                    ENU=Salesperson/Purchaser,Approver,Workflow User Group];
                                                   OptionString=Salesperson/Purchaser,Approver,Workflow User Group }
    { 13  ;   ;Approver Limit Type ;Option        ;CaptionML=[DAN=Godkenders gr‘nsetype;
                                                              ENU=Approver Limit Type];
                                                   OptionCaptionML=[DAN=Godkenderk‘de,Direkte godkender,F›rste kvalificerede godkender,Specifik godkender;
                                                                    ENU=Approver Chain,Direct Approver,First Qualified Approver,Specific Approver];
                                                   OptionString=Approver Chain,Direct Approver,First Qualified Approver,Specific Approver }
    { 14  ;   ;Workflow User Group Code;Code20    ;TableRelation="Workflow User Group".Code;
                                                   CaptionML=[DAN=Brugergruppekode for workflow;
                                                              ENU=Workflow User Group Code] }
    { 15  ;   ;Due Date Formula    ;DateFormula   ;OnValidate=BEGIN
                                                                IF COPYSTR(FORMAT("Due Date Formula"),1,1) = '-' THEN
                                                                  ERROR(STRSUBSTNO(NoNegValuesErr,FIELDCAPTION("Due Date Formula")));
                                                              END;

                                                   CaptionML=[DAN=Formular for forfaldsdato;
                                                              ENU=Due Date Formula] }
    { 16  ;   ;Message             ;Text250       ;CaptionML=[DAN=Meddelelse;
                                                              ENU=Message] }
    { 17  ;   ;Delegate After      ;Option        ;CaptionML=[DAN=Uddeleger efter;
                                                              ENU=Delegate After];
                                                   OptionCaptionML=[DAN=Aldrig,1 dag,2 dage,5 dage;
                                                                    ENU=Never,1 day,2 days,5 days];
                                                   OptionString=Never,1 day,2 days,5 days }
    { 18  ;   ;Show Confirmation Message;Boolean  ;CaptionML=[DAN=Vis bekr‘ftelsesmeddelelse;
                                                              ENU=Show Confirmation Message] }
    { 19  ;   ;Table No.           ;Integer       ;CaptionML=[DAN=Tabelnr.;
                                                              ENU=Table No.] }
    { 20  ;   ;Field No.           ;Integer       ;CaptionML=[DAN=Feltnr.;
                                                              ENU=Field No.] }
    { 21  ;   ;Field Caption       ;Text80        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Field."Field Caption" WHERE (TableNo=FIELD(Table No.),
                                                                                                   No.=FIELD(Field No.)));
                                                   CaptionML=[DAN=Felttitel;
                                                              ENU=Field Caption];
                                                   Editable=No }
    { 22  ;   ;Approver User ID    ;Code50        ;TableRelation="User Setup"."User ID";
                                                   OnLookup=VAR
                                                              UserSetup@1000 : Record 91;
                                                            BEGIN
                                                              IF PAGE.RUNMODAL(PAGE::"Approval User Setup",UserSetup) = ACTION::LookupOK THEN
                                                                VALIDATE("Approver User ID",UserSetup."User ID");
                                                            END;

                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id p† godkender;
                                                              ENU=Approver User ID] }
    { 23  ;   ;Response Type       ;Option        ;CaptionML=[DAN=Svartype;
                                                              ENU=Response Type];
                                                   OptionCaptionML=[DAN=Ikke ventet,Bruger-id;
                                                                    ENU=Not Expected,User ID];
                                                   OptionString=Not Expected,User ID }
    { 24  ;   ;Response User ID    ;Code50        ;TableRelation="User Setup"."User ID";
                                                   OnLookup=VAR
                                                              UserSetup@1000 : Record 91;
                                                            BEGIN
                                                              IF PAGE.RUNMODAL(PAGE::"User Setup",UserSetup) = ACTION::LookupOK THEN
                                                                VALIDATE("Response User ID",UserSetup."User ID");
                                                            END;

                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Id for svarbruger;
                                                              ENU=Response User ID] }
    { 100 ;   ;Response Option Group;Code20       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Workflow Response"."Response Option Group" WHERE (Function Name=FIELD(Response Function Name)));
                                                   CaptionML=[DAN=Indstillinger for gruppesvar;
                                                              ENU=Response Option Group];
                                                   Editable=No }
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
      NoNegValuesErr@1000 : TextConst 'DAN=%1 skal v‘re en positiv v‘rdi.;ENU=%1 must be a positive value.';

    [External]
    PROCEDURE Clone@1() : GUID;
    VAR
      WorkflowStepArgument@1001 : Record 1523;
    BEGIN
      CALCFIELDS("Event Conditions");
      WorkflowStepArgument.COPY(Rec);
      WorkflowStepArgument.INSERT(TRUE);
      EXIT(WorkflowStepArgument.ID);
    END;

    [Internal]
    PROCEDURE Equals@9(WorkflowStepArgument@1000 : Record 1523;SkipBlob@1004 : Boolean) : Boolean;
    VAR
      TypeHelper@1003 : Codeunit 10;
      OtherRecRef@1002 : RecordRef;
      ThisRecRef@1001 : RecordRef;
    BEGIN
      ThisRecRef.GETTABLE(Rec);
      OtherRecRef.GETTABLE(WorkflowStepArgument);

      IF NOT TypeHelper.Equals(ThisRecRef,OtherRecRef,SkipBlob) THEN
        EXIT(FALSE);

      EXIT(TRUE);
    END;

    [External]
    PROCEDURE GetEventFilters@8() Filters : Text;
    VAR
      FiltersInStream@1002 : InStream;
    BEGIN
      IF "Event Conditions".HASVALUE THEN BEGIN
        CALCFIELDS("Event Conditions");
        "Event Conditions".CREATEINSTREAM(FiltersInStream);
        FiltersInStream.READ(Filters);
      END;
    END;

    [External]
    PROCEDURE SetEventFilters@2(Filters@1000 : Text);
    VAR
      FiltersOutStream@1001 : OutStream;
    BEGIN
      "Event Conditions".CREATEOUTSTREAM(FiltersOutStream);
      FiltersOutStream.WRITE(Filters);
      MODIFY(TRUE);
    END;

    LOCAL PROCEDURE CheckEditingIsAllowed@12();
    VAR
      Workflow@1000 : Record 1501;
      WorkflowStep@1001 : Record 1502;
    BEGIN
      IF ISNULLGUID(ID) THEN
        EXIT;

      WorkflowStep.SETRANGE(Argument,ID);
      IF WorkflowStep.FINDFIRST THEN BEGIN
        Workflow.GET(WorkflowStep."Workflow Code");
        Workflow.CheckEditingIsAllowed;
      END;
    END;

    [External]
    PROCEDURE HideExternalUsers@5();
    VAR
      PermissionManager@1001 : Codeunit 9002;
      OriginalFilterGroup@1000 : Integer;
    BEGIN
      IF NOT PermissionManager.SoftwareAsAService THEN
        EXIT;

      OriginalFilterGroup := FILTERGROUP;
      FILTERGROUP := 2;
      CALCFIELDS("Notification User License Type");
      SETFILTER("Notification User License Type",'<>%1',"Notification User License Type"::"External User");
      FILTERGROUP := OriginalFilterGroup;
    END;

    BEGIN
    END.
  }
}

