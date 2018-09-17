OBJECT Table 5098 Saved Segment Criteria
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
               "User ID" := USERID;
             END;

    OnDelete=VAR
               SavedSegCriteriaLine@1000 : Record 5099;
             BEGIN
               SavedSegCriteriaLine.SETRANGE("Segment Criteria Code",Code);
               SavedSegCriteriaLine.DELETEALL(TRUE);
             END;

    CaptionML=[DAN=Gemte m†lgruppekriterier;
               ENU=Saved Segment Criteria];
    LookupPageID=Page5141;
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code10        ;CaptionML=[DAN=Kode;
                                                              ENU=Code];
                                                   NotBlank=Yes }
    { 2   ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 4   ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("User ID");
                                                            END;

                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID];
                                                   Editable=No }
    { 5   ;   ;No. of Actions      ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Saved Segment Criteria Line" WHERE (Segment Criteria Code=FIELD(Code),
                                                                                                          Type=CONST(Action)));
                                                   CaptionML=[DAN=Antal handlinger;
                                                              ENU=No. of Actions];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Code                                    ;Clustered=Yes }
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

