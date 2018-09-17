OBJECT Table 5222 Employee Ledger Entry
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Medarbejderpost;
               ENU=Employee Ledger Entry];
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;CaptionML=[DAN=Lõbenummer;
                                                              ENU=Entry No.] }
    { 3   ;   ;Employee No.        ;Code20        ;TableRelation=Employee;
                                                   CaptionML=[DAN=Medarbejdernr.;
                                                              ENU=Employee No.] }
    { 4   ;   ;Posting Date        ;Date          ;CaptionML=[DAN=Bogfõringsdato;
                                                              ENU=Posting Date] }
    { 5   ;   ;Document Type       ;Option        ;CaptionML=[DAN=Dokumenttype;
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
    { 13  ;   ;Amount              ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Employee Ledger Entry".Amount WHERE (Ledger Entry Amount=CONST(Yes),
                                                                                                                  Employee Ledger Entry No.=FIELD(Entry No.),
                                                                                                                  Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Belõb;
                                                              ENU=Amount];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 14  ;   ;Remaining Amount    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Employee Ledger Entry".Amount WHERE (Employee Ledger Entry No.=FIELD(Entry No.),
                                                                                                                  Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Restbelõb;
                                                              ENU=Remaining Amount];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 15  ;   ;Original Amt. (LCY) ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Employee Ledger Entry"."Amount (LCY)" WHERE (Employee Ledger Entry No.=FIELD(Entry No.),
                                                                                                                          Entry Type=FILTER(Initial Entry),
                                                                                                                          Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Opr. belõb (RV);
                                                              ENU=Original Amt. (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 16  ;   ;Remaining Amt. (LCY);Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Employee Ledger Entry"."Amount (LCY)" WHERE (Employee Ledger Entry No.=FIELD(Entry No.),
                                                                                                                          Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Restbelõb (RV);
                                                              ENU=Remaining Amt. (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 17  ;   ;Amount (LCY)        ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Employee Ledger Entry"."Amount (LCY)" WHERE (Ledger Entry Amount=CONST(Yes),
                                                                                                                          Employee Ledger Entry No.=FIELD(Entry No.),
                                                                                                                          Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Belõb (RV);
                                                              ENU=Amount (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 22  ;   ;Employee Posting Group;Code20      ;TableRelation="Employee Posting Group";
                                                   CaptionML=[DAN=Medarbejderbogfõringsgruppe;
                                                              ENU=Employee Posting Group] }
    { 23  ;   ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   CaptionML=[DAN=Global dimension 1-kode;
                                                              ENU=Global Dimension 1 Code];
                                                   CaptionClass='1,1,1' }
    { 24  ;   ;Global Dimension 2 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   CaptionML=[DAN=Global dimension 2-kode;
                                                              ENU=Global Dimension 2 Code];
                                                   CaptionClass='1,1,2' }
    { 25  ;   ;Salespers./Purch. Code;Code20      ;TableRelation=Salesperson/Purchaser;
                                                   CaptionML=[DAN=Sëlger/indkõberkode;
                                                              ENU=Salespers./Purch. Code] }
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
    { 34  ;   ;Applies-to Doc. Type;Option        ;CaptionML=[DAN=Udligningsbilagstype;
                                                              ENU=Applies-to Doc. Type];
                                                   OptionCaptionML=[DAN=" ,Betaling,Faktura,Kreditnota,Rentenota,Rykker,Refusion";
                                                                    ENU=" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund"];
                                                   OptionString=[ ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund] }
    { 35  ;   ;Applies-to Doc. No. ;Code20        ;CaptionML=[DAN=Udligningsbilagsnr.;
                                                              ENU=Applies-to Doc. No.] }
    { 36  ;   ;Open                ;Boolean       ;CaptionML=[DAN=èbn;
                                                              ENU=Open] }
    { 43  ;   ;Positive            ;Boolean       ;CaptionML=[DAN=Positiv;
                                                              ENU=Positive] }
    { 44  ;   ;Closed by Entry No. ;Integer       ;TableRelation="Employee Ledger Entry";
                                                   CaptionML=[DAN=Lukket af lõbenr.;
                                                              ENU=Closed by Entry No.] }
    { 45  ;   ;Closed at Date      ;Date          ;CaptionML=[DAN=Lukket den;
                                                              ENU=Closed at Date] }
    { 46  ;   ;Closed by Amount    ;Decimal       ;CaptionML=[DAN=Lukket med belõb;
                                                              ENU=Closed by Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 47  ;   ;Applies-to ID       ;Code50        ;OnValidate=BEGIN
                                                                TESTFIELD(Open,TRUE);
                                                              END;

                                                   CaptionML=[DAN=Udlignings-id;
                                                              ENU=Applies-to ID] }
    { 49  ;   ;Journal Batch Name  ;Code10        ;TestTableRelation=No;
                                                   CaptionML=[DAN=Kladdenavn;
                                                              ENU=Journal Batch Name] }
    { 50  ;   ;Reason Code         ;Code10        ;TableRelation="Reason Code";
                                                   CaptionML=[DAN=èrsagskode;
                                                              ENU=Reason Code] }
    { 51  ;   ;Bal. Account Type   ;Option        ;CaptionML=[DAN=Modkontotype;
                                                              ENU=Bal. Account Type];
                                                   OptionCaptionML=[DAN=Finanskonto,Debitor,Kreditor,Bankkonto,Anlëg;
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
    { 54  ;   ;Closed by Amount (LCY);Decimal     ;CaptionML=[DAN=Lukket med belõb (RV);
                                                              ENU=Closed by Amount (LCY)];
                                                   AutoFormatType=1 }
    { 58  ;   ;Debit Amount        ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Employee Ledger Entry"."Debit Amount" WHERE (Ledger Entry Amount=CONST(Yes),
                                                                                                                          Employee Ledger Entry No.=FIELD(Entry No.),
                                                                                                                          Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Debetbelõb;
                                                              ENU=Debit Amount];
                                                   BlankZero=Yes;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 59  ;   ;Credit Amount       ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Employee Ledger Entry"."Credit Amount" WHERE (Ledger Entry Amount=CONST(Yes),
                                                                                                                           Employee Ledger Entry No.=FIELD(Entry No.),
                                                                                                                           Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Kreditbelõb;
                                                              ENU=Credit Amount];
                                                   BlankZero=Yes;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 60  ;   ;Debit Amount (LCY)  ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Employee Ledger Entry"."Debit Amount (LCY)" WHERE (Ledger Entry Amount=CONST(Yes),
                                                                                                                                Employee Ledger Entry No.=FIELD(Entry No.),
                                                                                                                                Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Debetbelõb (RV);
                                                              ENU=Debit Amount (LCY)];
                                                   BlankZero=Yes;
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 61  ;   ;Credit Amount (LCY) ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Employee Ledger Entry"."Credit Amount (LCY)" WHERE (Ledger Entry Amount=CONST(Yes),
                                                                                                                                 Employee Ledger Entry No.=FIELD(Entry No.),
                                                                                                                                 Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Kreditbelõb (RV);
                                                              ENU=Credit Amount (LCY)];
                                                   BlankZero=Yes;
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 64  ;   ;No. Series          ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Nummerserie;
                                                              ENU=No. Series] }
    { 75  ;   ;Original Amount     ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Employee Ledger Entry".Amount WHERE (Employee Ledger Entry No.=FIELD(Entry No.),
                                                                                                                  Entry Type=FILTER(Initial Entry),
                                                                                                                  Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Oprindeligt belõb;
                                                              ENU=Original Amount];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 76  ;   ;Date Filter         ;Date          ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Datofilter;
                                                              ENU=Date Filter] }
    { 84  ;   ;Amount to Apply     ;Decimal       ;OnValidate=BEGIN
                                                                TESTFIELD(Open,TRUE);
                                                                CALCFIELDS("Remaining Amount");

                                                                IF "Amount to Apply" * "Remaining Amount" < 0 THEN
                                                                  FIELDERROR("Amount to Apply",MustHaveSameSignErr);

                                                                IF ABS("Amount to Apply") > ABS("Remaining Amount") THEN
                                                                  FIELDERROR("Amount to Apply",MustNotBeLargerErr);
                                                              END;

                                                   CaptionML=[DAN=Belõb, der skal udlignes;
                                                              ENU=Amount to Apply];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 86  ;   ;Applying Entry      ;Boolean       ;CaptionML=[DAN=Udlignende post;
                                                              ENU=Applying Entry] }
    { 170 ;   ;Creditor No.        ;Code20        ;CaptionML=[DAN=Kreditornummer;
                                                              ENU=Creditor No.];
                                                   Numeric=Yes }
    { 171 ;   ;Payment Reference   ;Code50        ;OnValidate=BEGIN
                                                                IF "Payment Reference" <> '' THEN
                                                                  TESTFIELD("Creditor No.");
                                                              END;

                                                   CaptionML=[DAN=Betalingsreference;
                                                              ENU=Payment Reference];
                                                   Numeric=Yes }
    { 172 ;   ;Payment Method Code ;Code10        ;TableRelation="Payment Method";
                                                   OnValidate=BEGIN
                                                                TESTFIELD(Open,TRUE);
                                                              END;

                                                   CaptionML=[DAN=Betalingsformkode;
                                                              ENU=Payment Method Code] }
    { 289 ;   ;Message to Recipient;Text140       ;OnValidate=BEGIN
                                                                TESTFIELD(Open,TRUE);
                                                              END;

                                                   CaptionML=[DAN=Meddelelse til modtager;
                                                              ENU=Message to Recipient] }
    { 290 ;   ;Exported to Payment File;Boolean   ;CaptionML=[DAN=Eksporteret til betalingsfil;
                                                              ENU=Exported to Payment File];
                                                   Editable=No }
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
    {    ;Employee No.,Applies-to ID,Open,Positive }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      MustHaveSameSignErr@1001 : TextConst 'DAN=skal have samme fortegn som restbelõbet;ENU=must have the same sign as remaining amount';
      MustNotBeLargerErr@1000 : TextConst 'DAN=mÜ ikke vëre stõrre end restbelõbet;ENU=must not be larger than remaining amount';

    [External]
    PROCEDURE CopyFromGenJnlLine@6(GenJnlLine@1000 : Record 81);
    BEGIN
      "Employee No." := GenJnlLine."Account No.";
      "Posting Date" := GenJnlLine."Posting Date";
      "Document Type" := GenJnlLine."Document Type";
      "Document No." := GenJnlLine."Document No.";
      Description := GenJnlLine.Description;
      "Amount (LCY)" := GenJnlLine."Amount (LCY)";
      "Employee Posting Group" := GenJnlLine."Posting Group";
      "Global Dimension 1 Code" := GenJnlLine."Shortcut Dimension 1 Code";
      "Global Dimension 2 Code" := GenJnlLine."Shortcut Dimension 2 Code";
      "Dimension Set ID" := GenJnlLine."Dimension Set ID";
      "Salespers./Purch. Code" := GenJnlLine."Salespers./Purch. Code";
      "Source Code" := GenJnlLine."Source Code";
      "Reason Code" := GenJnlLine."Reason Code";
      "Journal Batch Name" := GenJnlLine."Journal Batch Name";
      "User ID" := USERID;
      "Bal. Account Type" := GenJnlLine."Bal. Account Type";
      "Bal. Account No." := GenJnlLine."Bal. Account No.";
      "No. Series" := GenJnlLine."Posting No. Series";

      OnAfterCopyEmployeeLedgerEntryFromGenJnlLine(Rec,GenJnlLine);
    END;

    [External]
    PROCEDURE ShowDimensions@3();
    VAR
      DimMgt@1000 : Codeunit 408;
    BEGIN
      DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2',TABLECAPTION,"Entry No."));
    END;

    [External]
    PROCEDURE CopyFromCVLedgEntryBuffer@9(VAR CVLedgerEntryBuffer@1000 : Record 382);
    BEGIN
      "Entry No." := CVLedgerEntryBuffer."Entry No.";
      "Employee No." := CVLedgerEntryBuffer."CV No.";
      "Posting Date" := CVLedgerEntryBuffer."Posting Date";
      "Document Type" := CVLedgerEntryBuffer."Document Type";
      "Document No." := CVLedgerEntryBuffer."Document No.";
      Description := CVLedgerEntryBuffer.Description;
      "Currency Code" := CVLedgerEntryBuffer."Currency Code";
      "Source Code" := CVLedgerEntryBuffer."Source Code";
      "Reason Code" := CVLedgerEntryBuffer."Reason Code";
      Amount := CVLedgerEntryBuffer.Amount;
      "Remaining Amount" := CVLedgerEntryBuffer."Remaining Amount";
      "Original Amount" := CVLedgerEntryBuffer."Original Amount";
      "Original Amt. (LCY)" := CVLedgerEntryBuffer."Original Amt. (LCY)";
      "Remaining Amt. (LCY)" := CVLedgerEntryBuffer."Remaining Amt. (LCY)";
      "Amount (LCY)" := CVLedgerEntryBuffer."Amount (LCY)";
      "Employee Posting Group" := CVLedgerEntryBuffer."CV Posting Group";
      "Global Dimension 1 Code" := CVLedgerEntryBuffer."Global Dimension 1 Code";
      "Global Dimension 2 Code" := CVLedgerEntryBuffer."Global Dimension 2 Code";
      "Dimension Set ID" := CVLedgerEntryBuffer."Dimension Set ID";
      "Salespers./Purch. Code" := CVLedgerEntryBuffer."Salesperson Code";
      "User ID" := CVLedgerEntryBuffer."User ID";
      "Applies-to Doc. Type" := CVLedgerEntryBuffer."Applies-to Doc. Type";
      "Applies-to Doc. No." := CVLedgerEntryBuffer."Applies-to Doc. No.";
      Open := CVLedgerEntryBuffer.Open;
      Positive := CVLedgerEntryBuffer.Positive;
      "Closed by Entry No." := CVLedgerEntryBuffer."Closed by Entry No.";
      "Closed at Date" := CVLedgerEntryBuffer."Closed at Date";
      "Closed by Amount" := CVLedgerEntryBuffer."Closed by Amount";
      "Applies-to ID" := CVLedgerEntryBuffer."Applies-to ID";
      "Journal Batch Name" := CVLedgerEntryBuffer."Journal Batch Name";
      "Bal. Account Type" := CVLedgerEntryBuffer."Bal. Account Type";
      "Bal. Account No." := CVLedgerEntryBuffer."Bal. Account No.";
      "Transaction No." := CVLedgerEntryBuffer."Transaction No.";
      "Closed by Amount (LCY)" := CVLedgerEntryBuffer."Closed by Amount (LCY)";
      "Debit Amount" := CVLedgerEntryBuffer."Debit Amount";
      "Credit Amount" := CVLedgerEntryBuffer."Credit Amount";
      "Debit Amount (LCY)" := CVLedgerEntryBuffer."Debit Amount (LCY)";
      "Credit Amount (LCY)" := CVLedgerEntryBuffer."Credit Amount (LCY)";
      "No. Series" := CVLedgerEntryBuffer."No. Series";
      "Amount to Apply" := CVLedgerEntryBuffer."Amount to Apply";

      OnAfterCopyEmplLedgerEntryFromCVLedgEntryBuffer(Rec,CVLedgerEntryBuffer);
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnAfterCopyEmployeeLedgerEntryFromGenJnlLine@8(VAR EmployeeLedgerEntry@1000 : Record 5222;GenJournalLine@1001 : Record 81);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnAfterCopyEmplLedgerEntryFromCVLedgEntryBuffer@18(VAR EmployeeLedgerEntry@1000 : Record 5222;CVLedgerEntryBuffer@1001 : Record 382);
    BEGIN
    END;

    BEGIN
    END.
  }
}

