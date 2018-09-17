OBJECT Table 455 Approval Comment Line
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
               EVALUATE("Table ID",GETFILTER("Table ID"));
               EVALUATE("Record ID to Approve",GETFILTER("Record ID to Approve"));
               "User ID" := USERID;
               "Date and Time" := CREATEDATETIME(TODAY,TIME);
               IF "Entry No." = 0 THEN
                 "Entry No." := GetNextEntryNo;
             END;

    CaptionML=[DAN=Bem‘rkningslinje til godkendelse;
               ENU=Approval Comment Line];
    LookupPageID=Page660;
    DrillDownPageID=Page660;
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;CaptionML=[DAN=L›benr.;
                                                              ENU=Entry No.];
                                                   Editable=No }
    { 2   ;   ;Table ID            ;Integer       ;CaptionML=[DAN=Tabel-id;
                                                              ENU=Table ID];
                                                   Editable=No }
    { 3   ;   ;Document Type       ;Option        ;CaptionML=[DAN=Bilagstype;
                                                              ENU=Document Type];
                                                   OptionCaptionML=[DAN="Tilbud,Ordre,Faktura,Kreditnota,Rammeordre,Returv.ordre, ";
                                                                    ENU="Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order, "];
                                                   OptionString=[Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order, ];
                                                   Editable=No }
    { 4   ;   ;Document No.        ;Code20        ;CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.];
                                                   Editable=No }
    { 5   ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
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
    { 6   ;   ;Date and Time       ;DateTime      ;CaptionML=[DAN=Dato og tidspunkt;
                                                              ENU=Date and Time];
                                                   Editable=No }
    { 7   ;   ;Comment             ;Text80        ;CaptionML=[DAN=Bem‘rkning;
                                                              ENU=Comment] }
    { 8   ;   ;Record ID to Approve;RecordID      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Record-id, der skal godkendes;
                                                              ENU=Record ID to Approve] }
    { 9   ;   ;Workflow Step Instance ID;GUID     ;CaptionML=[DAN=Id for workflowtrininstans;
                                                              ENU=Workflow Step Instance ID] }
  }
  KEYS
  {
    {    ;Entry No.                               ;Clustered=Yes }
    {    ;Table ID,Document Type,Document No.,Record ID to Approve }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    LOCAL PROCEDURE GetNextEntryNo@4() : Integer;
    VAR
      ApprovalCommentLine@1000 : Record 455;
    BEGIN
      ApprovalCommentLine.SETCURRENTKEY("Entry No.");
      IF ApprovalCommentLine.FINDLAST THEN
        EXIT(ApprovalCommentLine."Entry No." + 1);

      EXIT(1);
    END;

    BEGIN
    END.
  }
}

