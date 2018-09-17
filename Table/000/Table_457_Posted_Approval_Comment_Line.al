OBJECT Table 457 Posted Approval Comment Line
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
               IF "Entry No." = 0 THEN
                 "Entry No." := GetNextEntryNo;
             END;

    CaptionML=[DAN=Bem‘rkningslinje til bogf›rt godkendelse;
               ENU=Posted Approval Comment Line];
    LookupPageID=Page661;
    DrillDownPageID=Page661;
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;CaptionML=[DAN=L›benr.;
                                                              ENU=Entry No.] }
    { 2   ;   ;Table ID            ;Integer       ;CaptionML=[DAN=Tabel-id;
                                                              ENU=Table ID] }
    { 4   ;   ;Document No.        ;Code20        ;CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.] }
    { 5   ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("User ID");
                                                            END;

                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 6   ;   ;Date and Time       ;DateTime      ;CaptionML=[DAN=Dato og tidspunkt;
                                                              ENU=Date and Time] }
    { 7   ;   ;Comment             ;Text80        ;CaptionML=[DAN=Bem‘rkning;
                                                              ENU=Comment] }
    { 8   ;   ;Posted Record ID    ;RecordID      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bogf›rt record-id;
                                                              ENU=Posted Record ID] }
  }
  KEYS
  {
    {    ;Entry No.                               ;Clustered=Yes }
    {    ;Table ID,Document No.,Date and Time      }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    LOCAL PROCEDURE GetNextEntryNo@4() : Integer;
    VAR
      PostedApprovalCommentLine@1000 : Record 457;
    BEGIN
      PostedApprovalCommentLine.SETCURRENTKEY("Entry No.");
      IF PostedApprovalCommentLine.FINDLAST THEN
        EXIT(PostedApprovalCommentLine."Entry No." + 1);

      EXIT(1);
    END;

    BEGIN
    END.
  }
}

