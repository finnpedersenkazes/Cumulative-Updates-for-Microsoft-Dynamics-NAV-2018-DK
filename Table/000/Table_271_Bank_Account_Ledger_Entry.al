OBJECT Table 271 Bank Account Ledger Entry
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Bankkontopost;
               ENU=Bank Account Ledger Entry];
    LookupPageID=Page372;
    DrillDownPageID=Page372;
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;CaptionML=[DAN=L›benr.;
                                                              ENU=Entry No.] }
    { 3   ;   ;Bank Account No.    ;Code20        ;TableRelation="Bank Account";
                                                   CaptionML=[DAN=Bankkontonr.;
                                                              ENU=Bank Account No.] }
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
    { 11  ;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   CaptionML=[DAN=Valutakode;
                                                              ENU=Currency Code] }
    { 13  ;   ;Amount              ;Decimal       ;CaptionML=[DAN=Bel›b;
                                                              ENU=Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 14  ;   ;Remaining Amount    ;Decimal       ;CaptionML=[DAN=Restbel›b;
                                                              ENU=Remaining Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 17  ;   ;Amount (LCY)        ;Decimal       ;CaptionML=[DAN=Bel›b (RV);
                                                              ENU=Amount (LCY)];
                                                   AutoFormatType=1 }
    { 22  ;   ;Bank Acc. Posting Group;Code20     ;TableRelation="Bank Account Posting Group";
                                                   CaptionML=[DAN=Bankbogf›ringsgruppe;
                                                              ENU=Bank Acc. Posting Group] }
    { 23  ;   ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   CaptionML=[DAN=Global dimension 1-kode;
                                                              ENU=Global Dimension 1 Code];
                                                   CaptionClass='1,1,1' }
    { 24  ;   ;Global Dimension 2 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   CaptionML=[DAN=Global dimension 2-kode;
                                                              ENU=Global Dimension 2 Code];
                                                   CaptionClass='1,1,2' }
    { 25  ;   ;Our Contact Code    ;Code20        ;TableRelation=Salesperson/Purchaser;
                                                   CaptionML=[DAN=Vores attentionkode;
                                                              ENU=Our Contact Code] }
    { 27  ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("User ID");
                                                            END;

                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 28  ;   ;Source Code         ;Code10        ;TableRelation="Source Code";
                                                   CaptionML=[DAN=Kildespor;
                                                              ENU=Source Code] }
    { 36  ;   ;Open                ;Boolean       ;CaptionML=[DAN=ben;
                                                              ENU=Open] }
    { 43  ;   ;Positive            ;Boolean       ;CaptionML=[DAN=Positiv;
                                                              ENU=Positive] }
    { 44  ;   ;Closed by Entry No. ;Integer       ;TableRelation="Bank Account Ledger Entry";
                                                   CaptionML=[DAN=Lukket af l›benr.;
                                                              ENU=Closed by Entry No.] }
    { 45  ;   ;Closed at Date      ;Date          ;CaptionML=[DAN=Lukket den;
                                                              ENU=Closed at Date] }
    { 49  ;   ;Journal Batch Name  ;Code10        ;CaptionML=[DAN=Kladdenavn;
                                                              ENU=Journal Batch Name] }
    { 50  ;   ;Reason Code         ;Code10        ;TableRelation="Reason Code";
                                                   CaptionML=[DAN=rsagskode;
                                                              ENU=Reason Code] }
    { 51  ;   ;Bal. Account Type   ;Option        ;CaptionML=[DAN=Modkontotype;
                                                              ENU=Bal. Account Type];
                                                   OptionCaptionML=[DAN=Finanskonto,Debitor,Kreditor,Bankkonto,Anl‘g;
                                                                    ENU=G/L Account,Customer,Vendor,Bank Account,Fixed Asset];
                                                   OptionString=G/L Account,Customer,Vendor,Bank Account,Fixed Asset }
    { 52  ;   ;Bal. Account No.    ;Code20        ;TableRelation=IF (Bal. Account Type=CONST(G/L Account)) "G/L Account"
                                                                 ELSE IF (Bal. Account Type=CONST(Customer)) Customer
                                                                 ELSE IF (Bal. Account Type=CONST(Vendor)) Vendor
                                                                 ELSE IF (Bal. Account Type=CONST(Bank Account)) "Bank Account"
                                                                 ELSE IF (Bal. Account Type=CONST(Fixed Asset)) "Fixed Asset";
                                                   CaptionML=[DAN=Modkonto;
                                                              ENU=Bal. Account No.] }
    { 53  ;   ;Transaction No.     ;Integer       ;CaptionML=[DAN=Transaktionsnr.;
                                                              ENU=Transaction No.] }
    { 55  ;   ;Statement Status    ;Option        ;CaptionML=[DAN=Kontoudtogsstatus;
                                                              ENU=Statement Status];
                                                   OptionCaptionML=[DAN=ben,Bankpostudlignet,Checkpost udlignet,Lukket;
                                                                    ENU=Open,Bank Acc. Entry Applied,Check Entry Applied,Closed];
                                                   OptionString=Open,Bank Acc. Entry Applied,Check Entry Applied,Closed }
    { 56  ;   ;Statement No.       ;Code20        ;TableRelation="Bank Acc. Reconciliation Line"."Statement No." WHERE (Bank Account No.=FIELD(Bank Account No.));
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Kontoudtogsnr.;
                                                              ENU=Statement No.] }
    { 57  ;   ;Statement Line No.  ;Integer       ;TableRelation="Bank Acc. Reconciliation Line"."Statement Line No." WHERE (Bank Account No.=FIELD(Bank Account No.),
                                                                                                                             Statement No.=FIELD(Statement No.));
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Kontoudtogslinjenr.;
                                                              ENU=Statement Line No.] }
    { 58  ;   ;Debit Amount        ;Decimal       ;CaptionML=[DAN=Debetbel›b;
                                                              ENU=Debit Amount];
                                                   BlankZero=Yes;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 59  ;   ;Credit Amount       ;Decimal       ;CaptionML=[DAN=Kreditbel›b;
                                                              ENU=Credit Amount];
                                                   BlankZero=Yes;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 60  ;   ;Debit Amount (LCY)  ;Decimal       ;CaptionML=[DAN=Debetbel›b (RV);
                                                              ENU=Debit Amount (LCY)];
                                                   BlankZero=Yes;
                                                   AutoFormatType=1 }
    { 61  ;   ;Credit Amount (LCY) ;Decimal       ;CaptionML=[DAN=Kreditbel›b (RV);
                                                              ENU=Credit Amount (LCY)];
                                                   BlankZero=Yes;
                                                   AutoFormatType=1 }
    { 62  ;   ;Document Date       ;Date          ;CaptionML=[DAN=Bilagsdato;
                                                              ENU=Document Date];
                                                   ClosingDates=Yes }
    { 63  ;   ;External Document No.;Code35       ;CaptionML=[DAN=Eksternt bilagsnr.;
                                                              ENU=External Document No.] }
    { 64  ;   ;Reversed            ;Boolean       ;CaptionML=[DAN=Tilbagef›rt;
                                                              ENU=Reversed] }
    { 65  ;   ;Reversed by Entry No.;Integer      ;TableRelation="Bank Account Ledger Entry";
                                                   CaptionML=[DAN=Tilbagef›rt af l›benr.;
                                                              ENU=Reversed by Entry No.];
                                                   BlankZero=Yes }
    { 66  ;   ;Reversed Entry No.  ;Integer       ;TableRelation="Bank Account Ledger Entry";
                                                   CaptionML=[DAN=Tilbagef›rt l›benr.;
                                                              ENU=Reversed Entry No.];
                                                   BlankZero=Yes }
    { 70  ;   ;Check Ledger Entries;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Check Ledger Entry" WHERE (Bank Account Ledger Entry No.=FIELD(Entry No.)));
                                                   CaptionML=[DAN=Checkposter;
                                                              ENU=Check Ledger Entries] }
    { 480 ;   ;Dimension Set ID    ;Integer       ;TableRelation="Dimension Set Entry";
                                                   OnLookup=BEGIN
                                                              ShowDimensions;
                                                            END;

                                                   CaptionML=[DAN=Dimensionsgruppe-id;
                                                              ENU=Dimension Set ID];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Entry No.                               ;Clustered=Yes }
    {    ;Bank Account No.,Posting Date           ;SumIndexFields=Amount,Amount (LCY),Debit Amount,Credit Amount,Debit Amount (LCY),Credit Amount (LCY) }
    {    ;Bank Account No.,Open                    }
    {    ;Document Type,Bank Account No.,Posting Date;
                                                   SumIndexFields=Amount;
                                                   MaintainSQLIndex=No }
    {    ;Document No.,Posting Date                }
    {    ;Transaction No.                          }
    { No ;Bank Account No.,Global Dimension 1 Code,Global Dimension 2 Code,Posting Date;
                                                   SumIndexFields=Amount,Amount (LCY),Debit Amount,Credit Amount,Debit Amount (LCY),Credit Amount (LCY) }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;Entry No.,Description,Bank Account No.,Posting Date,Document Type,Document No. }
  }
  CODE
  {
    VAR
      DimMgt@1000 : Codeunit 408;

    [External]
    PROCEDURE ShowDimensions@1();
    BEGIN
      DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2',TABLECAPTION,"Entry No."));
    END;

    [External]
    PROCEDURE CopyFromGenJnlLine@3(GenJnlLine@1000 : Record 81);
    BEGIN
      "Bank Account No." := GenJnlLine."Account No.";
      "Posting Date" := GenJnlLine."Posting Date";
      "Document Date" := GenJnlLine."Document Date";
      "Document Type" := GenJnlLine."Document Type";
      "Document No." := GenJnlLine."Document No.";
      "External Document No." := GenJnlLine."External Document No.";
      Description := GenJnlLine.Description;
      "Global Dimension 1 Code" := GenJnlLine."Shortcut Dimension 1 Code";
      "Global Dimension 2 Code" := GenJnlLine."Shortcut Dimension 2 Code";
      "Dimension Set ID" := GenJnlLine."Dimension Set ID";
      "Our Contact Code" := GenJnlLine."Salespers./Purch. Code";
      "Source Code" := GenJnlLine."Source Code";
      "Journal Batch Name" := GenJnlLine."Journal Batch Name";
      "Reason Code" := GenJnlLine."Reason Code";
      "Currency Code" := GenJnlLine."Currency Code";
      "User ID" := USERID;
      "Bal. Account Type" := GenJnlLine."Bal. Account Type";
      "Bal. Account No." := GenJnlLine."Bal. Account No.";

      OnAfterCopyFromGenJnlLine(Rec,GenJnlLine);
    END;

    [External]
    PROCEDURE UpdateDebitCredit@2(Correction@1000 : Boolean);
    BEGIN
      IF (Amount > 0) AND (NOT Correction) OR
         (Amount < 0) AND Correction
      THEN BEGIN
        "Debit Amount" := Amount;
        "Credit Amount" := 0;
        "Debit Amount (LCY)" := "Amount (LCY)";
        "Credit Amount (LCY)" := 0;
      END ELSE BEGIN
        "Debit Amount" := 0;
        "Credit Amount" := -Amount;
        "Debit Amount (LCY)" := 0;
        "Credit Amount (LCY)" := -"Amount (LCY)";
      END;
    END;

    [External]
    PROCEDURE IsApplied@4() IsApplied : Boolean;
    VAR
      CheckLedgerEntry@1000 : Record 272;
    BEGIN
      CheckLedgerEntry.SETRANGE("Bank Account No.","Bank Account No.");
      CheckLedgerEntry.SETRANGE("Bank Account Ledger Entry No.","Entry No.");
      CheckLedgerEntry.SETRANGE(Open,TRUE);
      CheckLedgerEntry.SETRANGE("Statement Status",CheckLedgerEntry."Statement Status"::"Check Entry Applied");
      CheckLedgerEntry.SETFILTER("Statement No.",'<>%1','');
      CheckLedgerEntry.SETFILTER("Statement Line No.",'<>%1',0);
      IsApplied := NOT CheckLedgerEntry.ISEMPTY;

      IsApplied := IsApplied OR
        (("Statement Status" = "Statement Status"::"Bank Acc. Entry Applied") AND
         ("Statement No." <> '') AND ("Statement Line No." <> 0));

      EXIT(IsApplied);
    END;

    [External]
    PROCEDURE SetStyle@5() : Text;
    BEGIN
      IF IsApplied THEN
        EXIT('Favorable');

      EXIT('');
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
    PROCEDURE OnAfterCopyFromGenJnlLine@7(VAR BankAccountLedgerEntry@1000 : Record 271;GenJournalLine@1001 : Record 81);
    BEGIN
    END;

    BEGIN
    END.
  }
}

