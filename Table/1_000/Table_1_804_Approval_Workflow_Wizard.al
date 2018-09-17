OBJECT Table 1804 Approval Workflow Wizard
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Guide til godkendelsesworkflow;
               ENU=Approval Workflow Wizard];
  }
  FIELDS
  {
    { 1   ;   ;Primary Key         ;Code10        ;CaptionML=[DAN=Prim‘r n›gle;
                                                              ENU=Primary Key] }
    { 2   ;   ;Approver ID         ;Code50        ;TableRelation="User Setup"."User ID";
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Godkender-id;
                                                              ENU=Approver ID] }
    { 3   ;   ;Sales Invoice App. Workflow;Boolean;CaptionML=[DAN=Godkend.workflow for salgsfaktura;
                                                              ENU=Sales Invoice App. Workflow] }
    { 4   ;   ;Sales Amount Approval Limit;Integer;CaptionML=[DAN=Bel›bsgr‘nse for godkendelse af salg;
                                                              ENU=Sales Amount Approval Limit];
                                                   MinValue=0 }
    { 5   ;   ;Purch Invoice App. Workflow;Boolean;CaptionML=[DAN=Workflow for godkendelse af k›bsfaktura;
                                                              ENU=Purch Invoice App. Workflow] }
    { 6   ;   ;Purch Amount Approval Limit;Integer;CaptionML=[DAN=Gr‘nse for godkendelse af k›bsbel›b;
                                                              ENU=Purch Amount Approval Limit];
                                                   MinValue=0 }
    { 7   ;   ;Use Exist. Approval User Setup;Boolean;
                                                   CaptionML=[DAN=Brug eksisterende brugergodkendelsesops‘tning;
                                                              ENU=Use Exist. Approval User Setup] }
    { 10  ;   ;Field               ;Integer       ;TableRelation=Field.No. WHERE (TableNo=CONST(18));
                                                   CaptionML=[DAN=Felt;
                                                              ENU=Field] }
    { 11  ;   ;TableNo             ;Integer       ;CaptionML=[DAN=Tabelnr.;
                                                              ENU=TableNo] }
    { 12  ;   ;Field Caption       ;Text250       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Field."Field Caption" WHERE (TableNo=FIELD(TableNo),
                                                                                                   No.=FIELD(Field)));
                                                   CaptionML=[DAN=Felttitel;
                                                              ENU=Field Caption] }
    { 13  ;   ;Custom Message      ;Text250       ;CaptionML=[DAN=Brugerdefineret meddelelse;
                                                              ENU=Custom Message] }
    { 14  ;   ;App. Trigger        ;Option        ;CaptionML=[DAN=Trigger for godkendelse;
                                                              ENU=App. Trigger];
                                                   OptionCaptionML=[DAN=Bruger sender manuelt en godkendelsesanmodning,Brugeren ‘ndrer et bestemt felt;
                                                                    ENU=The user sends an approval requests manually,The user changes a specific field];
                                                   OptionString=The user sends an approval requests manually,The user changes a specific field }
    { 15  ;   ;Field Operator      ;Option        ;CaptionML=[DAN=Feltoperator;
                                                              ENU=Field Operator];
                                                   OptionCaptionML=[DAN=For›get,Reduceret,’ndret;
                                                                    ENU=Increased,Decreased,Changed];
                                                   OptionString=Increased,Decreased,Changed }
    { 38  ;   ;Journal Batch Name  ;Code10        ;TableRelation="Gen. Journal Batch".Name;
                                                   CaptionML=[DAN=Kladdenavn;
                                                              ENU=Journal Batch Name] }
    { 39  ;   ;For All Batches     ;Boolean       ;CaptionML=[DAN=For alle kladdebatches;
                                                              ENU=For All Batches] }
    { 40  ;   ;Journal Template Name;Code10       ;CaptionML=[DAN=Kladdetypenavn;
                                                              ENU=Journal Template Name] }
  }
  KEYS
  {
    {    ;Primary Key                             ;Clustered=Yes }
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

