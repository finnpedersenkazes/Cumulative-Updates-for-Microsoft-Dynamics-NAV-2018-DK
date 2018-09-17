OBJECT Table 63 Account Use Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Buffer for kontobrug;
               ENU=Account Use Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Account No.         ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kontonr.;
                                                              ENU=Account No.] }
    { 2   ;   ;No. of Use          ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Brugsnr.;
                                                              ENU=No. of Use] }
  }
  KEYS
  {
    {    ;Account No.                             ;Clustered=Yes }
    {    ;No. of Use                               }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    PROCEDURE UpdateBuffer@27(VAR RecRef@1000 : RecordRef;AccountFieldNo@1002 : Integer);
    VAR
      FieldRef@1001 : FieldRef;
      AccNo@1004 : Code[20];
    BEGIN
      IF RecRef.FINDSET THEN
        REPEAT
          FieldRef := RecRef.FIELD(AccountFieldNo);
          AccNo := FieldRef.VALUE;
          IF AccNo <> '' THEN
            IF GET(AccNo) THEN BEGIN
              "No. of Use" += 1;
              MODIFY;
            END ELSE BEGIN
              INIT;
              "Account No." := AccNo;
              "No. of Use" += 1;
              INSERT;
            END;
        UNTIL RecRef.NEXT = 0;
    END;

    BEGIN
    END.
  }
}

