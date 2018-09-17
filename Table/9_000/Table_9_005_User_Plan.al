OBJECT Table 9005 User Plan
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    DataPerCompany=No;
    CaptionML=[DAN=Brugerplan;
               ENU=User Plan];
  }
  FIELDS
  {
    { 1   ;   ;User Security ID    ;GUID          ;TableRelation=User."User Security ID";
                                                   DataClassification=EndUserPseudonymousIdentifiers;
                                                   CaptionML=[DAN=Brugersikkerheds-id;
                                                              ENU=User Security ID] }
    { 2   ;   ;Plan ID             ;GUID          ;TableRelation=Plan."Plan ID";
                                                   CaptionML=[DAN=Plan-id;
                                                              ENU=Plan ID] }
    { 10  ;   ;User Name           ;Code50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(User."User Name" WHERE (User Security ID=FIELD(User Security ID)));
                                                   CaptionML=[DAN=Brugernavn;
                                                              ENU=User Name] }
    { 11  ;   ;User Full Name      ;Text80        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(User."Full Name" WHERE (User Security ID=FIELD(User Security ID)));
                                                   CaptionML=[DAN=Fulde navn;
                                                              ENU=Full Name] }
    { 12  ;   ;Plan Name           ;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Plan.Name WHERE (Plan ID=FIELD(Plan ID)));
                                                   CaptionML=[DAN=Navn p† plan;
                                                              ENU=Plan Name] }
  }
  KEYS
  {
    {    ;Plan ID,User Security ID                ;Clustered=Yes }
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

