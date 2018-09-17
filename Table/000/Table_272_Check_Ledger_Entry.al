OBJECT Table 272 Check Ledger Entry
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Checkpost;
               ENU=Check Ledger Entry];
    LookupPageID=Page374;
    DrillDownPageID=Page374;
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;CaptionML=[DAN=L›benr.;
                                                              ENU=Entry No.] }
    { 2   ;   ;Bank Account No.    ;Code20        ;TableRelation="Bank Account";
                                                   CaptionML=[DAN=Bankkontonr.;
                                                              ENU=Bank Account No.] }
    { 3   ;   ;Bank Account Ledger Entry No.;Integer;
                                                   TableRelation="Bank Account Ledger Entry";
                                                   CaptionML=[DAN=L›benr. (bankkontopost);
                                                              ENU=Bank Account Ledger Entry No.] }
    { 4   ;   ;Posting Date        ;Date          ;CaptionML=[DAN=Bogf›ringsdato;
                                                              ENU=Posting Date] }
    { 5   ;   ;Document Type       ;Option        ;CaptionML=[DAN=Bilagstype;
                                                              ENU=Document Type];
                                                   OptionCaptionML=[DAN=" ,Betaling,Faktura,Kreditnota,Rentenota,Rykker,Refusion";
                                                                    ENU=" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund"];
                                                   OptionString=[ ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund] }
    { 6   ;   ;Document No.        ;Code20        ;CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.] }
    { 7   ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 8   ;   ;Amount              ;Decimal       ;CaptionML=[DAN=Bel›b;
                                                              ENU=Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr=GetCurrencyCodeFromBank }
    { 9   ;   ;Check Date          ;Date          ;CaptionML=[DAN=Checkdato;
                                                              ENU=Check Date] }
    { 10  ;   ;Check No.           ;Code20        ;CaptionML=[DAN=Checknr.;
                                                              ENU=Check No.] }
    { 11  ;   ;Check Type          ;Option        ;CaptionML=[DAN=Checktype;
                                                              ENU=Check Type];
                                                   OptionCaptionML=[DAN=Total check,Delvis check;
                                                                    ENU=Total Check,Partial Check];
                                                   OptionString=Total Check,Partial Check }
    { 12  ;   ;Bank Payment Type   ;Option        ;CaptionML=[DAN=Bankbetalingstype;
                                                              ENU=Bank Payment Type];
                                                   OptionCaptionML=[DAN=" ,Computercheck,Manuel check,Elektronisk betaling";
                                                                    ENU=" ,Computer Check,Manual Check,Electronic Payment"];
                                                   OptionString=[ ,Computer Check,Manual Check,Electronic Payment] }
    { 13  ;   ;Entry Status        ;Option        ;CaptionML=[DAN=Poststatus;
                                                              ENU=Entry Status];
                                                   OptionCaptionML=[DAN=,Udskrevet,Annulleret,Bogf›rt,Annulleret og tilbagef›rt,Kontroludskrift,Eksporteret,Overf›rt;
                                                                    ENU=,Printed,Voided,Posted,Financially Voided,Test Print,Exported,Transmitted];
                                                   OptionString=,Printed,Voided,Posted,Financially Voided,Test Print,Exported,Transmitted }
    { 14  ;   ;Original Entry Status;Option       ;CaptionML=[DAN=Oprindelig poststatus;
                                                              ENU=Original Entry Status];
                                                   OptionCaptionML=[DAN=" ,Udskrevet,Annulleret,Bogf›rt,Annulleret og tilbagef›rt";
                                                                    ENU=" ,Printed,Voided,Posted,Financially Voided"];
                                                   OptionString=[ ,Printed,Voided,Posted,Financially Voided] }
    { 15  ;   ;Bal. Account Type   ;Option        ;CaptionML=[DAN=Modkontotype;
                                                              ENU=Bal. Account Type];
                                                   OptionCaptionML=[DAN=Finanskonto,Debitor,Kreditor,Bankkonto,Anl‘g;
                                                                    ENU=G/L Account,Customer,Vendor,Bank Account,Fixed Asset];
                                                   OptionString=G/L Account,Customer,Vendor,Bank Account,Fixed Asset }
    { 16  ;   ;Bal. Account No.    ;Code20        ;TableRelation=IF (Bal. Account Type=CONST(G/L Account)) "G/L Account"
                                                                 ELSE IF (Bal. Account Type=CONST(Customer)) Customer
                                                                 ELSE IF (Bal. Account Type=CONST(Vendor)) Vendor
                                                                 ELSE IF (Bal. Account Type=CONST(Bank Account)) "Bank Account"
                                                                 ELSE IF (Bal. Account Type=CONST(Fixed Asset)) "Fixed Asset";
                                                   CaptionML=[DAN=Modkonto;
                                                              ENU=Bal. Account No.] }
    { 17  ;   ;Open                ;Boolean       ;CaptionML=[DAN=ben;
                                                              ENU=Open] }
    { 18  ;   ;Statement Status    ;Option        ;CaptionML=[DAN=Kontoudtogsstatus;
                                                              ENU=Statement Status];
                                                   OptionCaptionML=[DAN=ben,Bankpostudlignet,Checkpost udlignet,Lukket;
                                                                    ENU=Open,Bank Acc. Entry Applied,Check Entry Applied,Closed];
                                                   OptionString=Open,Bank Acc. Entry Applied,Check Entry Applied,Closed }
    { 19  ;   ;Statement No.       ;Code20        ;TableRelation="Bank Acc. Reconciliation Line"."Statement No." WHERE (Bank Account No.=FIELD(Bank Account No.));
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Kontoudtogsnr.;
                                                              ENU=Statement No.] }
    { 20  ;   ;Statement Line No.  ;Integer       ;TableRelation="Bank Acc. Reconciliation Line"."Statement Line No." WHERE (Bank Account No.=FIELD(Bank Account No.),
                                                                                                                             Statement No.=FIELD(Statement No.));
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Kontoudtogslinjenr.;
                                                              ENU=Statement Line No.] }
    { 21  ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("User ID");
                                                            END;

                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 22  ;   ;External Document No.;Code35       ;CaptionML=[DAN=Eksternt bilagsnr.;
                                                              ENU=External Document No.] }
    { 23  ;   ;Data Exch. Entry No.;Integer       ;TableRelation="Data Exch.";
                                                   CaptionML=[DAN=Dataudvekslingspostnr.;
                                                              ENU=Data Exch. Entry No.];
                                                   Editable=No }
    { 24  ;   ;Data Exch. Voided Entry No.;Integer;TableRelation="Data Exch.";
                                                   CaptionML=[DAN=Annulleret dataudvekslingspostnr.;
                                                              ENU=Data Exch. Voided Entry No.];
                                                   Editable=No }
    { 25  ;   ;Positive Pay Exported;Boolean      ;CaptionML=[DAN=Positive Pay-betalingsposter eksporteret;
                                                              ENU=Positive Pay Exported] }
    { 26  ;   ;Record ID to Print  ;RecordID      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Record-id, der skal udskrives;
                                                              ENU=Record ID to Print] }
  }
  KEYS
  {
    {    ;Entry No.                               ;Clustered=Yes }
    {    ;Bank Account No.,Check Date              }
    {    ;Bank Account No.,Entry Status,Check No.  }
    {    ;Bank Account Ledger Entry No.            }
    {    ;Bank Account No.,Open                    }
    {    ;Document No.,Posting Date                }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      NothingToExportErr@1000 : TextConst 'DAN=Der er ikke noget at eksportere.;ENU=There is nothing to export.';

    [External]
    PROCEDURE GetCurrencyCodeFromBank@1() : Code[10];
    VAR
      BankAcc@1000 : Record 270;
    BEGIN
      IF "Bank Account No." = BankAcc."No." THEN
        EXIT(BankAcc."Currency Code");

      IF BankAcc.GET("Bank Account No.") THEN
        EXIT(BankAcc."Currency Code");

      EXIT('');
    END;

    [External]
    PROCEDURE CopyFromBankAccLedgEntry@2(BankAccLedgEntry@1000 : Record 271);
    BEGIN
      "Bank Account No." := BankAccLedgEntry."Bank Account No.";
      "Bank Account Ledger Entry No." := BankAccLedgEntry."Entry No.";
      "Posting Date" := BankAccLedgEntry."Posting Date";
      "Document Type" := BankAccLedgEntry."Document Type";
      "Document No." := BankAccLedgEntry."Document No.";
      "External Document No." := BankAccLedgEntry."External Document No.";
      Description := BankAccLedgEntry.Description;
      "Bank Payment Type" := "Bank Payment Type";
      "Bal. Account Type" := BankAccLedgEntry."Bal. Account Type";
      "Bal. Account No." := BankAccLedgEntry."Bal. Account No.";
      "Entry Status" := "Entry Status"::Posted;
      Open := TRUE;
      "User ID" := USERID;
      "Check Date" := BankAccLedgEntry."Posting Date";
      "Check No." := BankAccLedgEntry."Document No.";

      OnAfterCopyFromBankAccLedgEntry(Rec,BankAccLedgEntry);
    END;

    [External]
    PROCEDURE ExportCheckFile@3();
    VAR
      BankAcc@1000 : Record 270;
    BEGIN
      IF NOT FINDSET THEN
        ERROR(NothingToExportErr);

      BankAcc.GET("Bank Account No.");
      IF BankAcc.GetPosPayExportCodeunitID > 0 THEN
        CODEUNIT.RUN(BankAcc.GetPosPayExportCodeunitID,Rec)
      ELSE
        CODEUNIT.RUN(CODEUNIT::"Exp. Launcher Pos. Pay",Rec);
    END;

    [External]
    PROCEDURE GetPayee@4() Payee : Text[50];
    VAR
      Vendor@1003 : Record 23;
      Customer@1002 : Record 18;
      GLAccount@1001 : Record 15;
      BankAccount@1000 : Record 270;
    BEGIN
      CASE "Bal. Account Type" OF
        "Bal. Account Type"::"G/L Account":
          IF "Bal. Account No." <> '' THEN BEGIN
            GLAccount.GET("Bal. Account No.");
            Payee := GLAccount.Name;
          END;
        "Bal. Account Type"::Customer:
          IF "Bal. Account No." <> '' THEN BEGIN
            Customer.GET("Bal. Account No.");
            Payee := Customer.Name;
          END;
        "Bal. Account Type"::Vendor:
          IF "Bal. Account No." <> '' THEN BEGIN
            Vendor.GET("Bal. Account No.");
            Payee := Vendor.Name;
          END;
        "Bal. Account Type"::"Bank Account":
          IF "Bal. Account No." <> '' THEN BEGIN
            BankAccount.GET("Bal. Account No.");
            Payee := BankAccount.Name;
          END;
        "Bal. Account Type"::"Fixed Asset":
          Payee := "Bal. Account No.";
      END;
    END;

    [External]
    PROCEDURE SetFilterBankAccNoOpen@6(BankAccNo@1000 : Code[20]);
    BEGIN
      RESET;
      SETCURRENTKEY("Bank Account No.",Open);
      SETRANGE("Bank Account No.",BankAccNo);
      SETRANGE(Open,TRUE);
    END;

    [Integration]
    [External]
    PROCEDURE OnAfterCopyFromBankAccLedgEntry@7(VAR CheckLedgerEntry@1000 : Record 272;BankAccountLedgerEntry@1001 : Record 271);
    BEGIN
    END;

    BEGIN
    END.
  }
}

