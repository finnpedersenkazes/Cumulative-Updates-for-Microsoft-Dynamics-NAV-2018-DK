OBJECT Table 458 Overdue Approval Entry
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Forfalden godkendelsespost;
               ENU=Overdue Approval Entry];
  }
  FIELDS
  {
    { 1   ;   ;Table ID            ;Integer       ;CaptionML=[DAN=Tabel-id;
                                                              ENU=Table ID] }
    { 2   ;   ;Document Type       ;Option        ;CaptionML=[DAN=Bilagstype;
                                                              ENU=Document Type];
                                                   OptionCaptionML=[DAN="Tilbud,Ordre,Faktura,Kreditnota,Rammeordre,Returv.ordre, ";
                                                                    ENU="Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order, "];
                                                   OptionString=[Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order, ] }
    { 3   ;   ;Document No.        ;Code20        ;TableRelation=IF (Table ID=CONST(36)) "Sales Header".No. WHERE (Document Type=FIELD(Document Type))
                                                                 ELSE IF (Table ID=CONST(38)) "Purchase Header".No. WHERE (Document Type=FIELD(Document Type));
                                                   CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.] }
    { 4   ;   ;Sent to ID          ;Code50        ;TableRelation="User Setup";
                                                   CaptionML=[DAN=Sendt til id;
                                                              ENU=Sent to ID] }
    { 5   ;   ;Sent Time           ;Time          ;CaptionML=[DAN=Afsendelsestidspunkt;
                                                              ENU=Sent Time] }
    { 6   ;   ;Sent Date           ;Date          ;CaptionML=[DAN=Afsendelsesdato;
                                                              ENU=Sent Date] }
    { 7   ;   ;E-Mail              ;Text100       ;OnValidate=VAR
                                                                MailManagement@1000 : Codeunit 9520;
                                                              BEGIN
                                                                MailManagement.ValidateEmailAddressField("E-Mail");
                                                              END;

                                                   ExtendedDatatype=E-Mail;
                                                   CaptionML=[DAN=Mail;
                                                              ENU=Email] }
    { 8   ;   ;Sent to Name        ;Text30        ;CaptionML=[DAN=Sendt til navn;
                                                              ENU=Sent to Name] }
    { 9   ;   ;Sequence No.        ;Integer       ;CaptionML=[DAN=R‘kkef›lgenr.;
                                                              ENU=Sequence No.] }
    { 10  ;   ;Due Date            ;Date          ;CaptionML=[DAN=Forfaldsdato;
                                                              ENU=Due Date] }
    { 11  ;   ;Approver ID         ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("Approver ID");
                                                            END;

                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Godkender-id;
                                                              ENU=Approver ID] }
    { 12  ;   ;Approval Code       ;Code20        ;CaptionML=[DAN=Godkendelseskode;
                                                              ENU=Approval Code] }
    { 13  ;   ;Approval Type       ;Option        ;CaptionML=[DAN=Godkendelsestype;
                                                              ENU=Approval Type];
                                                   OptionCaptionML=[DAN=Workflowbrugergruppe,S‘lger/K›ber,Godkender;
                                                                    ENU=Workflow User Group,Sales Pers./Purchaser,Approver];
                                                   OptionString=Workflow User Group,Sales Pers./Purchaser,Approver }
    { 14  ;   ;Limit Type          ;Option        ;CaptionML=[DAN=Gr‘nsetype;
                                                              ENU=Limit Type];
                                                   OptionCaptionML=[DAN=Godkendelsesgr‘nser,Kreditgr‘nser,Anmodningsgr‘nser,Ingen gr‘nser;
                                                                    ENU=Approval Limits,Credit Limits,Request Limits,No Limits];
                                                   OptionString=Approval Limits,Credit Limits,Request Limits,No Limits }
    { 15  ;   ;Record ID to Approve;RecordID      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Record-id, der skal godkendes;
                                                              ENU=Record ID to Approve] }
  }
  KEYS
  {
    {    ;Table ID,Document Type,Document No.,Sequence No.,Sent Date,Sent Time,Record ID to Approve;
                                                   Clustered=Yes }
    {    ;Approver ID                              }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    [Internal]
    PROCEDURE ShowRecord@1();
    VAR
      PageManagement@1001 : Codeunit 700;
      RecRef@1000 : RecordRef;
    BEGIN
      IF NOT RecRef.GET("Record ID to Approve") THEN
        EXIT;
      PageManagement.PageRun(RecRef);
    END;

    BEGIN
    END.
  }
}

