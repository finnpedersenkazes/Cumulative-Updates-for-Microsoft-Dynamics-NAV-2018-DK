OBJECT Table 1541 Workflow User Group Member
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Medlem af brugergruppe for workflow;
               ENU=Workflow User Group Member];
  }
  FIELDS
  {
    { 1   ;   ;Workflow User Group Code;Code20    ;TableRelation="Workflow User Group".Code;
                                                   CaptionML=[DAN=Brugergruppekode for workflow;
                                                              ENU=Workflow User Group Code] }
    { 2   ;   ;User Name           ;Code50        ;TableRelation="User Setup"."User ID";
                                                   OnValidate=VAR
                                                                UserSetup@1000 : Record 91;
                                                                WorkflowUserGroupMember@1001 : Record 1541;
                                                                SequenceNo@1002 : Integer;
                                                              BEGIN
                                                                UserSetup.GET("User Name");

                                                                IF "Sequence No." = 0 THEN BEGIN
                                                                  SequenceNo := 1;
                                                                  WorkflowUserGroupMember.SETCURRENTKEY("Workflow User Group Code","Sequence No.");
                                                                  WorkflowUserGroupMember.SETRANGE("Workflow User Group Code","Workflow User Group Code");
                                                                  IF WorkflowUserGroupMember.FINDLAST THEN
                                                                    SequenceNo := WorkflowUserGroupMember."Sequence No." + 1;
                                                                  VALIDATE("Sequence No.",SequenceNo);
                                                                END;
                                                              END;

                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Brugernavn;
                                                              ENU=User Name] }
    { 3   ;   ;Sequence No.        ;Integer       ;CaptionML=[DAN=R�kkef�lgenr.;
                                                              ENU=Sequence No.];
                                                   MinValue=1 }
  }
  KEYS
  {
    {    ;Workflow User Group Code,User Name      ;Clustered=Yes }
    {    ;Workflow User Group Code,Sequence No.,User Name }
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

