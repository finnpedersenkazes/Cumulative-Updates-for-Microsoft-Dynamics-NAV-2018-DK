OBJECT Table 1660 Payroll Setup
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Ops‘tning af L›n;
               ENU=Payroll Setup];
    LookupPageID=Page191;
    DrillDownPageID=Page191;
  }
  FIELDS
  {
    { 1   ;   ;Primary Key         ;Integer       ;AutoIncrement=Yes;
                                                   CaptionML=[DAN=Prim‘r n›gle;
                                                              ENU=Primary Key] }
    { 2   ;   ;General Journal Template Name;Code10;
                                                   TableRelation="Gen. Journal Template" WHERE (Type=FILTER(General),
                                                                                                Recurring=CONST(No));
                                                   OnValidate=VAR
                                                                GenJournalTemplate@1000 : Record 80;
                                                                xGenJournalTemplate@1001 : Record 80;
                                                              BEGIN
                                                                IF "General Journal Template Name" = '' THEN BEGIN
                                                                  "General Journal Batch Name" := '';
                                                                  EXIT;
                                                                END;
                                                                GenJournalTemplate.GET("General Journal Template Name");
                                                                IF NOT (GenJournalTemplate.Type IN
                                                                        [GenJournalTemplate.Type::General,GenJournalTemplate.Type::Purchases,GenJournalTemplate.Type::Payments,
                                                                         GenJournalTemplate.Type::Sales,GenJournalTemplate.Type::"Cash Receipts"])
                                                                THEN
                                                                  ERROR(
                                                                    TemplateTypeErr,
                                                                    GenJournalTemplate.Type::General,GenJournalTemplate.Type::Purchases,GenJournalTemplate.Type::Payments,
                                                                    GenJournalTemplate.Type::Sales,GenJournalTemplate.Type::"Cash Receipts");
                                                                IF xRec."General Journal Template Name" <> '' THEN
                                                                  IF xGenJournalTemplate.GET(xRec."General Journal Template Name") THEN;
                                                                IF GenJournalTemplate.Type <> xGenJournalTemplate.Type THEN
                                                                  "General Journal Batch Name" := '';
                                                              END;

                                                   CaptionML=[DAN=Finanskladdetype - navn;
                                                              ENU=General Journal Template Name] }
    { 3   ;   ;General Journal Batch Name;Code10  ;TableRelation="Gen. Journal Batch".Name WHERE (Journal Template Name=FIELD(General Journal Template Name));
                                                   OnValidate=VAR
                                                                GenJournalBatch@1000 : Record 232;
                                                              BEGIN
                                                                IF "General Journal Batch Name" <> '' THEN
                                                                  TESTFIELD("General Journal Template Name");
                                                                GenJournalBatch.GET("General Journal Template Name","General Journal Batch Name");
                                                                GenJournalBatch.TESTFIELD(Recurring,FALSE);
                                                              END;

                                                   CaptionML=[DAN=Finanskladdenavn;
                                                              ENU=General Journal Batch Name] }
    { 10  ;   ;User Name           ;Code50        ;DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Brugernavn;
                                                              ENU=User Name] }
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
    VAR
      Fetched@1000 : Boolean;
      TemplateTypeErr@1001 : TextConst '@@@="%1..5 lists Type=General,Purchases,Payments,Sales,Cash Receipts";DAN=Kun finanskladdetyper af typen %1, %2, %3, %4 eller %5 er tilladt.;ENU=Only General Journal Templates of type %1, %2, %3, %4, or %5 are allowed.';

    [External]
    PROCEDURE Fetch@1();
    BEGIN
      IF Fetched THEN
        EXIT;
      Fetched := TRUE;
      IF NOT GET THEN
        INIT;
    END;

    BEGIN
    END.
  }
}

