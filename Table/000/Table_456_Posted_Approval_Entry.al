OBJECT Table 456 Posted Approval Entry
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    OnDelete=VAR
               PostedApprovalCommentLine@1000 : Record 457;
             BEGIN
               PostedApprovalCommentLine.SETRANGE("Posted Record ID","Posted Record ID");
               PostedApprovalCommentLine.DELETEALL;
             END;

    CaptionML=[DAN=Bogf�rt godkendelsespost;
               ENU=Posted Approval Entry];
  }
  FIELDS
  {
    { 1   ;   ;Table ID            ;Integer       ;CaptionML=[DAN=Tabel-id;
                                                              ENU=Table ID] }
    { 3   ;   ;Document No.        ;Code20        ;CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.] }
    { 4   ;   ;Sequence No.        ;Integer       ;CaptionML=[DAN=R�kkef�lgenr.;
                                                              ENU=Sequence No.] }
    { 5   ;   ;Approval Code       ;Code20        ;CaptionML=[DAN=Godkendelseskode;
                                                              ENU=Approval Code] }
    { 6   ;   ;Sender ID           ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=BEGIN
                                                              UserMgt.LookupUserID("Sender ID");
                                                            END;

                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Afsender-id;
                                                              ENU=Sender ID] }
    { 7   ;   ;Salespers./Purch. Code;Code20      ;CaptionML=[DAN=S�lger/indk�berkode;
                                                              ENU=Salespers./Purch. Code] }
    { 8   ;   ;Approver ID         ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=BEGIN
                                                              UserMgt.LookupUserID("Approver ID");
                                                            END;

                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Godkender-id;
                                                              ENU=Approver ID] }
    { 9   ;   ;Status              ;Option        ;CaptionML=[DAN=Status;
                                                              ENU=Status];
                                                   OptionCaptionML=[DAN=Oprettet,�ben,Annulleret,Afvist,Godkendt;
                                                                    ENU=Created,Open,Canceled,Rejected,Approved];
                                                   OptionString=Created,Open,Canceled,Rejected,Approved }
    { 10  ;   ;Date-Time Sent for Approval;DateTime;
                                                   CaptionML=[DAN=Afsendelsesdato/-tidspunkt for godkendelse;
                                                              ENU=Date-Time Sent for Approval] }
    { 11  ;   ;Last Date-Time Modified;DateTime   ;CaptionML=[DAN=Dato/tidspunkt for sidste �ndring;
                                                              ENU=Last Date-Time Modified] }
    { 12  ;   ;Last Modified By ID ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=BEGIN
                                                              UserMgt.LookupUserID("Last Modified By ID");
                                                            END;

                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Sidst �ndret af id;
                                                              ENU=Last Modified By ID] }
    { 13  ;   ;Comment             ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Posted Approval Comment Line" WHERE (Table ID=FIELD(Table ID),
                                                                                                           Document No.=FIELD(Document No.)));
                                                   CaptionML=[DAN=Bem�rkning;
                                                              ENU=Comment];
                                                   Editable=No }
    { 14  ;   ;Due Date            ;Date          ;CaptionML=[DAN=Forfaldsdato;
                                                              ENU=Due Date] }
    { 15  ;   ;Amount              ;Decimal       ;CaptionML=[DAN=Bel�b;
                                                              ENU=Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 16  ;   ;Amount (LCY)        ;Decimal       ;CaptionML=[DAN=Bel�b (RV);
                                                              ENU=Amount (LCY)];
                                                   AutoFormatType=1 }
    { 17  ;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   CaptionML=[DAN=Valutakode;
                                                              ENU=Currency Code] }
    { 18  ;   ;Approval Type       ;Option        ;CaptionML=[DAN=Godkendelsestype;
                                                              ENU=Approval Type];
                                                   OptionCaptionML=[DAN=Workflowbrugergruppe,S�lger/K�ber,Godkender;
                                                                    ENU=Workflow User Group,Sales Pers./Purchaser,Approver];
                                                   OptionString=Workflow User Group,Sales Pers./Purchaser,Approver }
    { 19  ;   ;Limit Type          ;Option        ;CaptionML=[DAN=Gr�nsetype;
                                                              ENU=Limit Type];
                                                   OptionCaptionML=[DAN=Godkendelsesgr�nser,Kreditgr�nser,Anmodningsgr�nser,Ingen gr�nser;
                                                                    ENU=Approval Limits,Credit Limits,Request Limits,No Limits];
                                                   OptionString=Approval Limits,Credit Limits,Request Limits,No Limits }
    { 20  ;   ;Available Credit Limit (LCY);Decimal;
                                                   CaptionML=[DAN=Tilg�ngelig kreditgr�nse (RV);
                                                              ENU=Available Credit Limit (LCY)] }
    { 22  ;   ;Posted Record ID    ;RecordID      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bogf�rt record-id;
                                                              ENU=Posted Record ID] }
    { 23  ;   ;Delegation Date Formula;DateFormula;CaptionML=[DAN=Uddelegeringsdatoformel;
                                                              ENU=Delegation Date Formula] }
    { 26  ;   ;Number of Approved Requests;Integer;CaptionML=[DAN=Antal godkendte anmodninger;
                                                              ENU=Number of Approved Requests] }
    { 27  ;   ;Number of Rejected Requests;Integer;CaptionML=[DAN=Antal afviste anmodninger;
                                                              ENU=Number of Rejected Requests] }
    { 28  ;   ;Iteration No.       ;Integer       ;CaptionML=[DAN=Gentagelsesnr.;
                                                              ENU=Iteration No.] }
    { 29  ;   ;Entry No.           ;Integer       ;AutoIncrement=Yes;
                                                   CaptionML=[DAN=L�benummer;
                                                              ENU=Entry No.] }
  }
  KEYS
  {
    {    ;Entry No.                               ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      UserMgt@1000 : Codeunit 418;

    [Internal]
    PROCEDURE ShowRecord@1();
    VAR
      PageManagement@1001 : Codeunit 700;
      RecRef@1000 : RecordRef;
    BEGIN
      IF NOT RecRef.GET("Posted Record ID") THEN
        EXIT;
      RecRef.SETRECFILTER;
      PageManagement.PageRun(RecRef);
    END;

    BEGIN
    END.
  }
}

