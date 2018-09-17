OBJECT Table 232 Gen. Journal Batch
{
  OBJECT-PROPERTIES
  {
    Date=28-06-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23019;
  }
  PROPERTIES
  {
    DataCaptionFields=Name,Description;
    OnInsert=BEGIN
               LOCKTABLE;
               GenJnlTemplate.GET("Journal Template Name");
               IF NOT GenJnlTemplate."Copy VAT Setup to Jnl. Lines" THEN
                 "Copy VAT Setup to Jnl. Lines" := FALSE;
               "Allow Payment Export" := GenJnlTemplate.Type = GenJnlTemplate.Type::Payments;

               SetLastModifiedDateTime;
             END;

    OnModify=BEGIN
               SetLastModifiedDateTime;
             END;

    OnDelete=BEGIN
               ApprovalsMgmt.OnCancelGeneralJournalBatchApprovalRequest(Rec);

               GenJnlAlloc.SETRANGE("Journal Template Name","Journal Template Name");
               GenJnlAlloc.SETRANGE("Journal Batch Name",Name);
               GenJnlAlloc.DELETEALL;
               GenJnlLine.SETRANGE("Journal Template Name","Journal Template Name");
               GenJnlLine.SETRANGE("Journal Batch Name",Name);
               GenJnlLine.DELETEALL(TRUE);
             END;

    OnRename=BEGIN
               ApprovalsMgmt.OnRenameRecordInApprovalRequest(xRec.RECORDID,RECORDID);

               SetLastModifiedDateTime;
             END;

    CaptionML=[DAN=Finanskladdenavn;
               ENU=Gen. Journal Batch];
    LookupPageID=Page251;
  }
  FIELDS
  {
    { 1   ;   ;Journal Template Name;Code10       ;TableRelation="Gen. Journal Template";
                                                   CaptionML=[DAN=Kladdetypenavn;
                                                              ENU=Journal Template Name];
                                                   NotBlank=Yes }
    { 2   ;   ;Name                ;Code10        ;CaptionML=[DAN=Navn;
                                                              ENU=Name];
                                                   NotBlank=Yes }
    { 3   ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 4   ;   ;Reason Code         ;Code10        ;TableRelation="Reason Code";
                                                   OnValidate=BEGIN
                                                                IF "Reason Code" <> xRec."Reason Code" THEN BEGIN
                                                                  ModifyLines(FIELDNO("Reason Code"));
                                                                  MODIFY;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=èrsagskode;
                                                              ENU=Reason Code] }
    { 5   ;   ;Bal. Account Type   ;Option        ;OnValidate=BEGIN
                                                                "Bal. Account No." := '';
                                                                IF "Bal. Account Type" <> "Bal. Account Type"::"G/L Account" THEN
                                                                  "Bank Statement Import Format" := '';
                                                              END;

                                                   CaptionML=[DAN=Modkontotype;
                                                              ENU=Bal. Account Type];
                                                   OptionCaptionML=[DAN=Finanskonto,Debitor,Kreditor,Bankkonto,Anlëg;
                                                                    ENU=G/L Account,Customer,Vendor,Bank Account,Fixed Asset];
                                                   OptionString=G/L Account,Customer,Vendor,Bank Account,Fixed Asset }
    { 6   ;   ;Bal. Account No.    ;Code20        ;TableRelation=IF (Bal. Account Type=CONST(G/L Account)) "G/L Account"
                                                                 ELSE IF (Bal. Account Type=CONST(Customer)) Customer
                                                                 ELSE IF (Bal. Account Type=CONST(Vendor)) Vendor
                                                                 ELSE IF (Bal. Account Type=CONST(Bank Account)) "Bank Account"
                                                                 ELSE IF (Bal. Account Type=CONST(Fixed Asset)) "Fixed Asset";
                                                   OnValidate=BEGIN
                                                                IF "Bal. Account Type" = "Bal. Account Type"::"G/L Account" THEN
                                                                  CheckGLAcc("Bal. Account No.");
                                                                CheckJnlIsNotRecurring;
                                                              END;

                                                   CaptionML=[DAN=Modkonto;
                                                              ENU=Bal. Account No.] }
    { 7   ;   ;No. Series          ;Code20        ;TableRelation="No. Series";
                                                   OnValidate=BEGIN
                                                                IF "No. Series" <> '' THEN BEGIN
                                                                  GenJnlTemplate.GET("Journal Template Name");
                                                                  IF GenJnlTemplate.Recurring THEN
                                                                    ERROR(
                                                                      Text000,
                                                                      FIELDCAPTION("Posting No. Series"));
                                                                  IF "No. Series" = "Posting No. Series" THEN
                                                                    VALIDATE("Posting No. Series",'');
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Nummerserie;
                                                              ENU=No. Series] }
    { 8   ;   ;Posting No. Series  ;Code20        ;TableRelation="No. Series";
                                                   OnValidate=BEGIN
                                                                IF ("Posting No. Series" = "No. Series") AND ("Posting No. Series" <> '') THEN
                                                                  FIELDERROR("Posting No. Series",STRSUBSTNO(Text001,"Posting No. Series"));
                                                                ModifyLines(FIELDNO("Posting No. Series"));
                                                                MODIFY;
                                                              END;

                                                   CaptionML=[DAN=Bogfõringsnummerserie;
                                                              ENU=Posting No. Series] }
    { 9   ;   ;Copy VAT Setup to Jnl. Lines;Boolean;
                                                   InitValue=Yes;
                                                   CaptionML=[DAN=Kopier momsopsët. t. kld.linje;
                                                              ENU=Copy VAT Setup to Jnl. Lines] }
    { 10  ;   ;Allow VAT Difference;Boolean       ;OnValidate=BEGIN
                                                                IF "Allow VAT Difference" THEN BEGIN
                                                                  GenJnlTemplate.GET("Journal Template Name");
                                                                  GenJnlTemplate.TESTFIELD("Allow VAT Difference",TRUE);
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Tillad momsdifference;
                                                              ENU=Allow VAT Difference] }
    { 11  ;   ;Allow Payment Export;Boolean       ;CaptionML=[DAN=Tillad eksport af betaling;
                                                              ENU=Allow Payment Export] }
    { 12  ;   ;Bank Statement Import Format;Code20;TableRelation="Bank Export/Import Setup".Code WHERE (Direction=CONST(Import));
                                                   OnValidate=BEGIN
                                                                IF ("Bank Statement Import Format" <> '') AND ("Bal. Account Type" <> "Bal. Account Type"::"G/L Account") THEN
                                                                  FIELDERROR("Bank Statement Import Format",BankStmtImpFormatBalAccErr);
                                                              END;

                                                   CaptionML=[DAN=Format til import af bankkontoudtog;
                                                              ENU=Bank Statement Import Format] }
    { 21  ;   ;Template Type       ;Option        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Gen. Journal Template".Type WHERE (Name=FIELD(Journal Template Name)));
                                                   CaptionML=[DAN=Skabelontype;
                                                              ENU=Template Type];
                                                   OptionCaptionML=[DAN=Generelt,Salg,Kõb,Indbetalinger,Betalinger,Anlëg,Intercompany,Sager;
                                                                    ENU=General,Sales,Purchases,Cash Receipts,Payments,Assets,Intercompany,Jobs];
                                                   OptionString=General,Sales,Purchases,Cash Receipts,Payments,Assets,Intercompany,Jobs;
                                                   Editable=No }
    { 22  ;   ;Recurring           ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Gen. Journal Template".Recurring WHERE (Name=FIELD(Journal Template Name)));
                                                   CaptionML=[DAN=Gentagelse;
                                                              ENU=Recurring];
                                                   Editable=No }
    { 23  ;   ;Suggest Balancing Amount;Boolean   ;CaptionML=[DAN=ForeslÜ modkontobelõb;
                                                              ENU=Suggest Balancing Amount] }
    { 8000;   ;Id                  ;GUID          ;CaptionML=[DAN=Id;
                                                              ENU=Id] }
    { 8001;   ;Last Modified DateTime;DateTime    ;CaptionML=[DAN=Dato/klokkeslët for seneste ëndring;
                                                              ENU=Last Modified DateTime] }
  }
  KEYS
  {
    {    ;Journal Template Name,Name              ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Kun feltet %1 kan udfyldes i gentagelseskladder.;ENU=Only the %1 field can be filled in on recurring journals.';
      Text001@1001 : TextConst 'DAN=mÜ ikke vëre %1;ENU=must not be %1';
      GenJnlTemplate@1002 : Record 80;
      GenJnlLine@1003 : Record 81;
      GenJnlAlloc@1004 : Record 221;
      BankStmtImpFormatBalAccErr@1005 : TextConst '@@@="FIELDERROR ex: Bank Statement Import Format must be blank. When Bal. Account Type = Bank Account, then Bank Statement Import Format on the Bank Account card will be used in Gen. Journal Batch Journal Template Name=''GENERAL'',Name=''CASH''.";DAN="skal vëre tom. NÜr Modkontotype = Bankkonto, bruges Format til import af bankkontoudtog pÜ bankkontokortet";ENU="must be blank. When Bal. Account Type = Bank Account, then Bank Statement Import Format on the Bank Account card will be used"';
      ApprovalsMgmt@1006 : Codeunit 1535;
      CannotBeSpecifiedForRecurrJnlErr@1007 : TextConst 'DAN=mÜ ikke vëre udfyldt, nÜr du bruger gentagelseskladder.;ENU=cannot be specified when using recurring journals';

    [External]
    PROCEDURE SetupNewBatch@1();
    BEGIN
      GenJnlTemplate.GET("Journal Template Name");
      "Bal. Account Type" := GenJnlTemplate."Bal. Account Type";
      "Bal. Account No." := GenJnlTemplate."Bal. Account No.";
      "No. Series" := GenJnlTemplate."No. Series";
      "Posting No. Series" := GenJnlTemplate."Posting No. Series";
      "Reason Code" := GenJnlTemplate."Reason Code";
      "Copy VAT Setup to Jnl. Lines" := GenJnlTemplate."Copy VAT Setup to Jnl. Lines";
      "Allow VAT Difference" := GenJnlTemplate."Allow VAT Difference";
    END;

    LOCAL PROCEDURE CheckGLAcc@2(AccNo@1000 : Code[20]);
    VAR
      GLAcc@1001 : Record 15;
    BEGIN
      IF AccNo <> '' THEN BEGIN
        GLAcc.GET(AccNo);
        GLAcc.CheckGLAcc;
        GLAcc.TESTFIELD("Direct Posting",TRUE);
      END;
    END;

    LOCAL PROCEDURE CheckJnlIsNotRecurring@4();
    BEGIN
      IF "Bal. Account No." = '' THEN
        EXIT;

      GenJnlTemplate.GET("Journal Template Name");
      IF GenJnlTemplate.Recurring THEN
        FIELDERROR("Bal. Account No.",CannotBeSpecifiedForRecurrJnlErr);
    END;

    LOCAL PROCEDURE ModifyLines@3(i@1000 : Integer);
    BEGIN
      GenJnlLine.LOCKTABLE;
      GenJnlLine.SETRANGE("Journal Template Name","Journal Template Name");
      GenJnlLine.SETRANGE("Journal Batch Name",Name);
      IF GenJnlLine.FIND('-') THEN
        REPEAT
          CASE i OF
            FIELDNO("Reason Code"):
              GenJnlLine.VALIDATE("Reason Code","Reason Code");
            FIELDNO("Posting No. Series"):
              GenJnlLine.VALIDATE("Posting No. Series","Posting No. Series");
          END;
          GenJnlLine.MODIFY(TRUE);
        UNTIL GenJnlLine.NEXT = 0;
    END;

    [External]
    PROCEDURE LinesExist@5() : Boolean;
    VAR
      GenJournalLine@1000 : Record 81;
    BEGIN
      GenJournalLine.SETRANGE("Journal Template Name","Journal Template Name");
      GenJournalLine.SETRANGE("Journal Batch Name",Name);
      EXIT(NOT GenJournalLine.ISEMPTY);
    END;

    [External]
    PROCEDURE GetBalance@6() : Decimal;
    VAR
      GenJournalLine@1000 : Record 81;
    BEGIN
      GenJournalLine.SETRANGE("Journal Template Name","Journal Template Name");
      GenJournalLine.SETRANGE("Journal Batch Name",Name);
      GenJournalLine.CALCSUMS("Balance (LCY)");
      EXIT(GenJournalLine."Balance (LCY)");
    END;

    [External]
    PROCEDURE CheckBalance@11() Balance : Decimal;
    BEGIN
      Balance := GetBalance;

      IF Balance = 0 THEN
        OnGeneralJournalBatchBalanced
      ELSE
        OnGeneralJournalBatchNotBalanced;
    END;

    [Integration(TRUE)]
    [External]
    LOCAL PROCEDURE OnGeneralJournalBatchBalanced@15();
    BEGIN
    END;

    [Integration(TRUE)]
    [External]
    LOCAL PROCEDURE OnGeneralJournalBatchNotBalanced@16();
    BEGIN
    END;

    [Integration(TRUE)]
    [External]
    PROCEDURE OnCheckGenJournalLineExportRestrictions@7();
    BEGIN
    END;

    [Integration(TRUE)]
    [External]
    PROCEDURE OnMoveGenJournalBatch@8(ToRecordID@1000 : RecordID);
    BEGIN
    END;

    LOCAL PROCEDURE SetLastModifiedDateTime@1165();
    BEGIN
      "Last Modified DateTime" := CURRENTDATETIME;
    END;

    BEGIN
    END.
  }
}

