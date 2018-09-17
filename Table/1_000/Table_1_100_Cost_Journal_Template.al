OBJECT Table 1100 Cost Journal Template
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               TESTFIELD(Name);
               "Posting Report ID" := REPORT::"Cost Register";
             END;

    OnDelete=VAR
               CostJnlBatch@1000 : Record 1102;
             BEGIN
               CostJnlBatch.SETRANGE("Journal Template Name",Name);
               CostJnlBatch.DELETEALL(TRUE);
             END;

    CaptionML=[DAN=Omkostningskladdetype;
               ENU=Cost Journal Template];
    LookupPageID=Page1107;
  }
  FIELDS
  {
    { 1   ;   ;Name                ;Code10        ;ValidateTableRelation=No;
                                                   CaptionML=[DAN=Navn;
                                                              ENU=Name];
                                                   NotBlank=Yes }
    { 2   ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 3   ;   ;Reason Code         ;Code10        ;TableRelation="Reason Code";
                                                   CaptionML=[DAN=èrsagskode;
                                                              ENU=Reason Code] }
    { 6   ;   ;Source Code         ;Code10        ;TableRelation="Source Code";
                                                   CaptionML=[DAN=Kildespor;
                                                              ENU=Source Code] }
    { 7   ;   ;Posting Report ID   ;Integer       ;TableRelation=AllObjWithCaption."Object ID" WHERE (Object Type=CONST(Report));
                                                   CaptionML=[DAN=Journalrapport-id;
                                                              ENU=Posting Report ID] }
    { 8   ;   ;Posting Report Caption;Text250     ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(AllObjWithCaption."Object Caption" WHERE (Object Type=CONST(Report),
                                                                                                                Object ID=FIELD(Posting Report ID)));
                                                   CaptionML=[DAN=Overskrift pÜ bogfõringsrapport;
                                                              ENU=Posting Report Caption];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Name                                    ;Clustered=Yes }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;Name,Description                         }
  }
  CODE
  {

    BEGIN
    END.
  }
}

