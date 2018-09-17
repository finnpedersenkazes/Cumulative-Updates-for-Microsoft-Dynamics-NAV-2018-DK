OBJECT Table 1531 Workflow Step Argument Archive
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
               ID := CREATEGUID;
             END;

    CaptionML=[DAN=Arkiv for workflowtrinargument;
               ENU=Workflow Step Argument Archive];
  }
  FIELDS
  {
    { 1   ;   ;ID                  ;GUID          ;CaptionML=[DAN=Id;
                                                              ENU=ID] }
    { 2   ;   ;Type                ;Option        ;CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=H‘ndelse,Svar;
                                                                    ENU=Event,Response];
                                                   OptionString=Event,Response }
    { 3   ;   ;General Journal Template Name;Code10;
                                                   CaptionML=[DAN=Finanskladdetypes navn;
                                                              ENU=General Journal Template Name] }
    { 4   ;   ;General Journal Batch Name;Code10  ;CaptionML=[DAN=Finanskladdenavn;
                                                              ENU=General Journal Batch Name] }
    { 5   ;   ;Notification User ID;Code50        ;DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id for notifikation;
                                                              ENU=Notification User ID] }
    { 6   ;   ;Notification User License Type;Option;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Lookup(User."License Type" WHERE (User Name=FIELD(Notification User ID)));
                                                   CaptionML=[DAN=Brugerlicenstype for notifikation;
                                                              ENU=Notification User License Type];
                                                   OptionCaptionML=[DAN=Fuld bruger,Begr‘nset bruger,Enhedsbruger,Windows-gruppe,Ekstern bruger;
                                                                    ENU=Full User,Limited User,Device Only User,Windows Group,External User];
                                                   OptionString=Full User,Limited User,Device Only User,Windows Group,External User }
    { 7   ;   ;Response Function Name;Code128     ;CaptionML=[DAN=Svarets funktionsnavn;
                                                              ENU=Response Function Name] }
    { 9   ;   ;Link Target Page    ;Integer       ;CaptionML=[DAN=Side, der linkes til;
                                                              ENU=Link Target Page] }
    { 10  ;   ;Custom Link         ;Text250       ;ExtendedDatatype=URL;
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
    { 14  ;   ;Workflow User Group Code;Code20    ;CaptionML=[DAN=Brugergruppekode for workflow;
                                                              ENU=Workflow User Group Code] }
    { 15  ;   ;Due Date Formula    ;DateFormula   ;CaptionML=[DAN=Formular for forfaldsdato;
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
    { 22  ;   ;Approver User ID    ;Code50        ;DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id for godkender;
                                                              ENU=Approver User ID] }
    { 23  ;   ;Response Type       ;Option        ;CaptionML=[DAN=Svartype;
                                                              ENU=Response Type];
                                                   OptionCaptionML=[DAN=Ikke ventet,Bruger-id;
                                                                    ENU=Not Expected,User ID];
                                                   OptionString=Not Expected,User ID }
    { 24  ;   ;Response User ID    ;Code50        ;DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Id for svarbruger;
                                                              ENU=Response User ID] }
    { 100 ;   ;Response Option Group;Code20       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Workflow Response"."Response Option Group" WHERE (Function Name=FIELD(Response Function Name)));
                                                   CaptionML=[DAN=Indstillinger for gruppesvar;
                                                              ENU=Response Option Group];
                                                   Editable=No }
    { 200 ;   ;Original Record ID  ;RecordID      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Oprindeligt record-id;
                                                              ENU=Original Record ID] }
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

    BEGIN
    END.
  }
}

