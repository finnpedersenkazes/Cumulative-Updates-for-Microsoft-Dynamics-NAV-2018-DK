OBJECT Table 78 Printer Selection
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
    CaptionML=[DAN=Printervalg;
               ENU=Printer Selection];
    LookupPageID=Page64;
  }
  FIELDS
  {
    { 1   ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   OnValidate=VAR
                                                                UserMgt@1000 : Codeunit 418;
                                                              BEGIN
                                                                UserMgt.ValidateUserID("User ID");
                                                              END;

                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("User ID");
                                                            END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 2   ;   ;Report ID           ;Integer       ;TableRelation=AllObjWithCaption."Object ID" WHERE (Object Type=CONST(Report));
                                                   CaptionML=[DAN=Rapport-id;
                                                              ENU=Report ID] }
    { 3   ;   ;Printer Name        ;Text250       ;TableRelation=Printer;
                                                   CaptionML=[DAN=Printernavn;
                                                              ENU=Printer Name] }
    { 4   ;   ;Report Caption      ;Text250       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(AllObjWithCaption."Object Caption" WHERE (Object Type=CONST(Report),
                                                                                                                Object ID=FIELD(Report ID)));
                                                   CaptionML=[DAN=Rapportoverskrift;
                                                              ENU=Report Caption];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;User ID,Report ID                       ;Clustered=Yes }
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

