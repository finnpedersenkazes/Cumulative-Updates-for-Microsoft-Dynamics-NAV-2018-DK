OBJECT Table 980 Payment Registration Setup
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    OnModify=BEGIN
               ValidateMandatoryFields(TRUE);
             END;

    CaptionML=[DAN=Ops�tning af betalingsregistrering;
               ENU=Payment Registration Setup];
  }
  FIELDS
  {
    { 1   ;   ;User ID             ;Code50        ;DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 2   ;   ;Journal Template Name;Code10       ;TableRelation="Gen. Journal Template";
                                                   OnValidate=BEGIN
                                                                "Journal Batch Name" := '';
                                                              END;

                                                   CaptionML=[DAN=Kladdetypenavn;
                                                              ENU=Journal Template Name] }
    { 3   ;   ;Journal Batch Name  ;Code10        ;TableRelation="Gen. Journal Batch".Name WHERE (Journal Template Name=FIELD(Journal Template Name));
                                                   OnValidate=VAR
                                                                GenJournalBatch@1000 : Record 232;
                                                              BEGIN
                                                                IF NOT GenJournalBatch.GET("Journal Template Name","Journal Batch Name") THEN
                                                                  EXIT;

                                                                CASE GenJournalBatch."Bal. Account Type" OF
                                                                  GenJournalBatch."Bal. Account Type"::"G/L Account":
                                                                    VALIDATE("Bal. Account Type","Bal. Account Type"::"G/L Account");
                                                                  GenJournalBatch."Bal. Account Type"::"Bank Account":
                                                                    VALIDATE("Bal. Account Type","Bal. Account Type"::"Bank Account");
                                                                  ELSE
                                                                    VALIDATE("Bal. Account Type","Bal. Account Type"::" ");
                                                                END;

                                                                IF GenJournalBatch."Bal. Account No." <> '' THEN
                                                                  VALIDATE("Bal. Account No.",GenJournalBatch."Bal. Account No.");
                                                              END;

                                                   CaptionML=[DAN=Kladdenavn;
                                                              ENU=Journal Batch Name] }
    { 4   ;   ;Bal. Account Type   ;Option        ;OnValidate=BEGIN
                                                                "Bal. Account No." := '';
                                                              END;

                                                   CaptionML=[DAN=Modkontotype;
                                                              ENU=Bal. Account Type];
                                                   OptionCaptionML=[DAN=" ,Finanskonto,Bankkonto";
                                                                    ENU=" ,G/L Account,Bank Account"];
                                                   OptionString=[ ,G/L Account,Bank Account] }
    { 5   ;   ;Bal. Account No.    ;Code20        ;TableRelation=IF (Bal. Account Type=CONST(G/L Account)) "G/L Account"
                                                                 ELSE IF (Bal. Account Type=CONST(Bank Account)) "Bank Account";
                                                   CaptionML=[DAN=Modkonto;
                                                              ENU=Bal. Account No.] }
    { 6   ;   ;Use this Account as Def.;Boolean   ;InitValue=Yes;
                                                   CaptionML=[DAN=Anvend denne konto som standard;
                                                              ENU=Use this Account as Def.] }
    { 7   ;   ;Auto Fill Date Received;Boolean    ;InitValue=Yes;
                                                   CaptionML=[DAN=Udfyld Dato for modtaget automatisk;
                                                              ENU=Auto Fill Date Received] }
  }
  KEYS
  {
    {    ;User ID                                 ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    [External]
    PROCEDURE GetGLBalAccountType@1() : Integer;
    VAR
      GenJnlLine@1000 : Record 81;
    BEGIN
      TESTFIELD("Bal. Account Type");
      CASE "Bal. Account Type" OF
        "Bal. Account Type"::"Bank Account":
          EXIT(GenJnlLine."Bal. Account Type"::"Bank Account");
        "Bal. Account Type"::"G/L Account":
          EXIT(GenJnlLine."Bal. Account Type"::"G/L Account");
      END;
    END;

    [External]
    PROCEDURE ValidateMandatoryFields@7(ShowError@1001 : Boolean) : Boolean;
    VAR
      GenJnlBatch@1000 : Record 232;
    BEGIN
      IF ShowError THEN BEGIN
        TESTFIELD("Journal Template Name");
        TESTFIELD("Journal Batch Name");

        TESTFIELD("Bal. Account Type");
        TESTFIELD("Bal. Account No.");

        GenJnlBatch.GET("Journal Template Name","Journal Batch Name");
        GenJnlBatch.TESTFIELD("No. Series");
        EXIT(TRUE);
      END;

      IF "Journal Template Name" = '' THEN
        EXIT(FALSE);

      IF "Journal Batch Name" = '' THEN
        EXIT(FALSE);

      IF "Bal. Account Type" = "Bal. Account Type"::" " THEN
        EXIT(FALSE);

      IF "Bal. Account No." = '' THEN
        EXIT(FALSE);

      IF NOT GenJnlBatch.GET("Journal Template Name","Journal Batch Name") THEN
        EXIT(FALSE);

      IF GenJnlBatch."No. Series" = '' THEN
        EXIT(FALSE);

      EXIT(TRUE);
    END;

    BEGIN
    END.
  }
}

