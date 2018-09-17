OBJECT Table 383 Detailed CV Ledg. Entry Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Detalj. kunde/lev.bogf.buffer;
               ENU=Detailed CV Ledg. Entry Buffer];
    LookupPageID=Page573;
    DrillDownPageID=Page573;
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=L�benr.;
                                                              ENU=Entry No.] }
    { 2   ;   ;CV Ledger Entry No. ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kredit./debit.-l�benr.;
                                                              ENU=CV Ledger Entry No.] }
    { 3   ;   ;Entry Type          ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Posttype;
                                                              ENU=Entry Type];
                                                   OptionCaptionML=[DAN=,Startpost,Udligning,Urealiseret tab,Urealiseret gevinst,Realiseret tab,Realiseret gevinst,Kontantrabat,Kontantrabat (f�r moms),Kontantrabat (momsregul.),Udligningsafrunding,Rettelse af restbel�b,Betalingstolerance,Kontantrabattolerance,Betalingstolerance (f�r moms),Betalingstolerance (momsregul.),Kontantrabattolerance (f�r moms),Kontantrabattolerance (momsregul.);
                                                                    ENU=,Initial Entry,Application,Unrealized Loss,Unrealized Gain,Realized Loss,Realized Gain,Payment Discount,Payment Discount (VAT Excl.),Payment Discount (VAT Adjustment),Appln. Rounding,Correction of Remaining Amount,Payment Tolerance,Payment Discount Tolerance,Payment Tolerance (VAT Excl.),Payment Tolerance (VAT Adjustment),Payment Discount Tolerance (VAT Excl.),Payment Discount Tolerance (VAT Adjustment)];
                                                   OptionString=,Initial Entry,Application,Unrealized Loss,Unrealized Gain,Realized Loss,Realized Gain,Payment Discount,Payment Discount (VAT Excl.),Payment Discount (VAT Adjustment),Appln. Rounding,Correction of Remaining Amount,Payment Tolerance,Payment Discount Tolerance,Payment Tolerance (VAT Excl.),Payment Tolerance (VAT Adjustment),Payment Discount Tolerance (VAT Excl.),Payment Discount Tolerance (VAT Adjustment) }
    { 4   ;   ;Posting Date        ;Date          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bogf�ringsdato;
                                                              ENU=Posting Date] }
    { 5   ;   ;Document Type       ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bilagstype;
                                                              ENU=Document Type];
                                                   OptionCaptionML=[DAN=" ,Betaling,Faktura,Kreditnota,Rentenota,Rykker,Refusion";
                                                                    ENU=" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund"];
                                                   OptionString=[ ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund] }
    { 6   ;   ;Document No.        ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.] }
    { 7   ;   ;Amount              ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bel�b;
                                                              ENU=Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 8   ;   ;Amount (LCY)        ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bel�b (RV);
                                                              ENU=Amount (LCY)];
                                                   AutoFormatType=1 }
    { 9   ;   ;CV No.              ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Debitor/kreditornr.;
                                                              ENU=CV No.] }
    { 10  ;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Valutakode;
                                                              ENU=Currency Code] }
    { 11  ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("User ID");
                                                            END;

                                                   TestTableRelation=No;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 12  ;   ;Source Code         ;Code10        ;TableRelation="Source Code";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kildespor;
                                                              ENU=Source Code] }
    { 13  ;   ;Transaction No.     ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Transaktionsnr.;
                                                              ENU=Transaction No.] }
    { 14  ;   ;Journal Batch Name  ;Code10        ;TestTableRelation=No;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kladdenavn;
                                                              ENU=Journal Batch Name] }
    { 15  ;   ;Reason Code         ;Code10        ;TableRelation="Reason Code";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=�rsagskode;
                                                              ENU=Reason Code] }
    { 16  ;   ;Debit Amount        ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Debetbel�b;
                                                              ENU=Debit Amount];
                                                   BlankZero=Yes;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 17  ;   ;Credit Amount       ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kreditbel�b;
                                                              ENU=Credit Amount];
                                                   BlankZero=Yes;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 18  ;   ;Debit Amount (LCY)  ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Debetbel�b (RV);
                                                              ENU=Debit Amount (LCY)];
                                                   BlankZero=Yes;
                                                   AutoFormatType=1 }
    { 19  ;   ;Credit Amount (LCY) ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kreditbel�b (RV);
                                                              ENU=Credit Amount (LCY)];
                                                   BlankZero=Yes;
                                                   AutoFormatType=1 }
    { 20  ;   ;Initial Entry Due Date;Date        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Oprindelig posts forfaldsdato;
                                                              ENU=Initial Entry Due Date] }
    { 21  ;   ;Initial Entry Global Dim. 1;Code20 ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Global dim. 1 til startpost;
                                                              ENU=Initial Entry Global Dim. 1] }
    { 22  ;   ;Initial Entry Global Dim. 2;Code20 ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Global dim. 2 til startpost;
                                                              ENU=Initial Entry Global Dim. 2] }
    { 23  ;   ;Gen. Posting Type   ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bogf�ringstype;
                                                              ENU=Gen. Posting Type];
                                                   OptionCaptionML=[DAN=" ,K�b,Salg,Afregning";
                                                                    ENU=" ,Purchase,Sale,Settlement"];
                                                   OptionString=[ ,Purchase,Sale,Settlement] }
    { 24  ;   ;Gen. Bus. Posting Group;Code20     ;TableRelation="Gen. Business Posting Group";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Virksomhedsbogf�ringsgruppe;
                                                              ENU=Gen. Bus. Posting Group] }
    { 25  ;   ;Gen. Prod. Posting Group;Code20    ;TableRelation="Gen. Product Posting Group";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Produktbogf�ringsgruppe;
                                                              ENU=Gen. Prod. Posting Group] }
    { 26  ;   ;Tax Area Code       ;Code20        ;TableRelation="Tax Area";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Skatteomr�dekode;
                                                              ENU=Tax Area Code] }
    { 27  ;   ;Tax Liable          ;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Skattepligtig;
                                                              ENU=Tax Liable] }
    { 28  ;   ;Tax Group Code      ;Code20        ;TableRelation="Tax Group";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Skattegruppekode;
                                                              ENU=Tax Group Code] }
    { 29  ;   ;Use Tax             ;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Use Tax;
                                                              ENU=Use Tax] }
    { 30  ;   ;VAT Bus. Posting Group;Code20      ;TableRelation="VAT Business Posting Group";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Momsvirksomhedsbogf.gruppe;
                                                              ENU=VAT Bus. Posting Group] }
    { 31  ;   ;VAT Prod. Posting Group;Code20     ;TableRelation="VAT Product Posting Group";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Momsproduktbogf.gruppe;
                                                              ENU=VAT Prod. Posting Group] }
    { 32  ;   ;Additional-Currency Amount;Decimal ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Ekstra valuta (bel�b);
                                                              ENU=Additional-Currency Amount];
                                                   AutoFormatType=1 }
    { 33  ;   ;VAT Amount (LCY)    ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Momsbel�b (RV);
                                                              ENU=VAT Amount (LCY)];
                                                   AutoFormatType=1 }
    { 34  ;   ;Use Additional-Currency Amount;Boolean;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Brug bel�b i ekstra valuta;
                                                              ENU=Use Additional-Currency Amount] }
    { 35  ;   ;Initial Document Type;Option       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Startbilagstype;
                                                              ENU=Initial Document Type];
                                                   OptionCaptionML=[DAN=" ,Betaling,Faktura,Kreditnota,Rentenota,Rykker,Refusion";
                                                                    ENU=" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund"];
                                                   OptionString=[ ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund] }
    { 36  ;   ;Applied CV Ledger Entry No.;Integer;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Udlign. kredit./debit.-l�benr.;
                                                              ENU=Applied CV Ledger Entry No.] }
    { 39  ;   ;Remaining Pmt. Disc. Possible;Decimal;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Mulig restkontantrabat;
                                                              ENU=Remaining Pmt. Disc. Possible];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 40  ;   ;Max. Payment Tolerance;Decimal     ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Maks. betalingstolerance;
                                                              ENU=Max. Payment Tolerance];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 41  ;   ;Tax Jurisdiction Code;Code10       ;TableRelation="Tax Jurisdiction";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Skatteregionkode;
                                                              ENU=Tax Jurisdiction Code];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Entry No.                               ;Clustered=Yes }
    {    ;CV Ledger Entry No.,Entry Type          ;SumIndexFields=Amount,Amount (LCY),Debit Amount,Credit Amount,Debit Amount (LCY),Credit Amount (LCY) }
    {    ;CV No.,Initial Entry Due Date,Posting Date,Currency Code;
                                                   SumIndexFields=Amount,Amount (LCY),Debit Amount,Credit Amount,Debit Amount (LCY),Credit Amount (LCY) }
    {    ;CV No.,Posting Date,Entry Type,Currency Code;
                                                   SumIndexFields=Amount,Amount (LCY) }
    {    ;CV No.,Initial Document Type,Document Type;
                                                   SumIndexFields=Amount,Amount (LCY) }
    {    ;Document Type,Document No.,Posting Date  }
    {    ;Initial Document Type,CV No.,Posting Date,Currency Code,Entry Type;
                                                   SumIndexFields=Amount,Amount (LCY) }
    { No ;CV No.,Initial Entry Due Date,Posting Date,Initial Entry Global Dim. 1,Initial Entry Global Dim. 2,Currency Code;
                                                   SumIndexFields=Amount,Amount (LCY),Debit Amount,Credit Amount,Debit Amount (LCY),Credit Amount (LCY) }
    { No ;CV No.,Posting Date,Entry Type,Initial Entry Global Dim. 1,Initial Entry Global Dim. 2,Currency Code;
                                                   SumIndexFields=Amount,Amount (LCY) }
    { No ;CV No.,Initial Document Type,Document Type,Initial Entry Global Dim. 1,Initial Entry Global Dim. 2;
                                                   SumIndexFields=Amount,Amount (LCY) }
    { No ;Initial Document Type,CV No.,Posting Date,Currency Code,Entry Type,Initial Entry Global Dim. 1,Initial Entry Global Dim. 2;
                                                   SumIndexFields=Amount,Amount (LCY) }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    [External]
    PROCEDURE InsertDtldCVLedgEntry@53(VAR DtldCVLedgEntryBuf@1000 : Record 383;VAR CVLedgEntryBuf@1001 : Record 382;InsertZeroAmout@1004 : Boolean);
    VAR
      NewDtldCVLedgEntryBuf@1002 : Record 383;
      NextDtldBufferEntryNo@1003 : Integer;
    BEGIN
      IF (DtldCVLedgEntryBuf.Amount = 0) AND
         (DtldCVLedgEntryBuf."Amount (LCY)" = 0) AND
         (DtldCVLedgEntryBuf."VAT Amount (LCY)" = 0) AND
         (DtldCVLedgEntryBuf."Additional-Currency Amount" = 0) AND
         (NOT InsertZeroAmout)
      THEN
        EXIT;

      DtldCVLedgEntryBuf.TESTFIELD("Entry Type" );

      NewDtldCVLedgEntryBuf.INIT;
      NewDtldCVLedgEntryBuf := DtldCVLedgEntryBuf;

      IF NextDtldBufferEntryNo = 0 THEN BEGIN
        DtldCVLedgEntryBuf.RESET;
        IF DtldCVLedgEntryBuf.FINDLAST THEN
          NextDtldBufferEntryNo := DtldCVLedgEntryBuf."Entry No." + 1
        ELSE
          NextDtldBufferEntryNo := 1;
      END;

      DtldCVLedgEntryBuf.RESET;
      DtldCVLedgEntryBuf.SETRANGE("CV Ledger Entry No.",CVLedgEntryBuf."Entry No.");
      DtldCVLedgEntryBuf.SETRANGE("Entry Type",NewDtldCVLedgEntryBuf."Entry Type");
      DtldCVLedgEntryBuf.SETRANGE("Posting Date",NewDtldCVLedgEntryBuf."Posting Date");
      DtldCVLedgEntryBuf.SETRANGE("Document Type",NewDtldCVLedgEntryBuf."Document Type");
      DtldCVLedgEntryBuf.SETRANGE("Document No.",NewDtldCVLedgEntryBuf."Document No.");
      DtldCVLedgEntryBuf.SETRANGE("CV No.",NewDtldCVLedgEntryBuf."CV No.");
      DtldCVLedgEntryBuf.SETRANGE("Gen. Posting Type",NewDtldCVLedgEntryBuf."Gen. Posting Type");
      DtldCVLedgEntryBuf.SETRANGE(
        "Gen. Bus. Posting Group",NewDtldCVLedgEntryBuf."Gen. Bus. Posting Group");
      DtldCVLedgEntryBuf.SETRANGE(
        "Gen. Prod. Posting Group",NewDtldCVLedgEntryBuf."Gen. Prod. Posting Group");
      DtldCVLedgEntryBuf.SETRANGE(
        "VAT Bus. Posting Group",NewDtldCVLedgEntryBuf."VAT Bus. Posting Group");
      DtldCVLedgEntryBuf.SETRANGE(
        "VAT Prod. Posting Group",NewDtldCVLedgEntryBuf."VAT Prod. Posting Group");
      DtldCVLedgEntryBuf.SETRANGE("Tax Area Code",NewDtldCVLedgEntryBuf."Tax Area Code");
      DtldCVLedgEntryBuf.SETRANGE("Tax Liable",NewDtldCVLedgEntryBuf."Tax Liable");
      DtldCVLedgEntryBuf.SETRANGE("Tax Group Code",NewDtldCVLedgEntryBuf."Tax Group Code");
      DtldCVLedgEntryBuf.SETRANGE("Use Tax",NewDtldCVLedgEntryBuf."Use Tax");
      DtldCVLedgEntryBuf.SETRANGE(
        "Tax Jurisdiction Code",NewDtldCVLedgEntryBuf."Tax Jurisdiction Code");

      IF DtldCVLedgEntryBuf.FINDFIRST THEN BEGIN
        DtldCVLedgEntryBuf.Amount := DtldCVLedgEntryBuf.Amount + NewDtldCVLedgEntryBuf.Amount;
        DtldCVLedgEntryBuf."Amount (LCY)" :=
          DtldCVLedgEntryBuf."Amount (LCY)" + NewDtldCVLedgEntryBuf."Amount (LCY)";
        DtldCVLedgEntryBuf."VAT Amount (LCY)" :=
          DtldCVLedgEntryBuf."VAT Amount (LCY)" + NewDtldCVLedgEntryBuf."VAT Amount (LCY)";
        DtldCVLedgEntryBuf."Additional-Currency Amount" :=
          DtldCVLedgEntryBuf."Additional-Currency Amount" +
          NewDtldCVLedgEntryBuf."Additional-Currency Amount";
        DtldCVLedgEntryBuf.MODIFY;
      END ELSE BEGIN
        NewDtldCVLedgEntryBuf."Entry No." := NextDtldBufferEntryNo;
        NextDtldBufferEntryNo := NextDtldBufferEntryNo + 1;
        DtldCVLedgEntryBuf := NewDtldCVLedgEntryBuf;
        DtldCVLedgEntryBuf.INSERT;
      END;

      CVLedgEntryBuf."Amount to Apply" := NewDtldCVLedgEntryBuf.Amount + CVLedgEntryBuf."Amount to Apply";
      CVLedgEntryBuf."Remaining Amount" := NewDtldCVLedgEntryBuf.Amount + CVLedgEntryBuf."Remaining Amount";
      CVLedgEntryBuf."Remaining Amt. (LCY)" :=
        NewDtldCVLedgEntryBuf."Amount (LCY)" + CVLedgEntryBuf."Remaining Amt. (LCY)";

      IF DtldCVLedgEntryBuf."Entry Type" = DtldCVLedgEntryBuf."Entry Type"::"Initial Entry" THEN BEGIN
        CVLedgEntryBuf."Original Amount" := NewDtldCVLedgEntryBuf.Amount;
        CVLedgEntryBuf."Original Amt. (LCY)" := NewDtldCVLedgEntryBuf."Amount (LCY)";
      END;
      DtldCVLedgEntryBuf.RESET;
    END;

    [External]
    PROCEDURE CopyPostingGroupsFromVATEntry@1(VATEntry@1000 : Record 254);
    BEGIN
      "Gen. Posting Type" := VATEntry.Type;
      "Gen. Bus. Posting Group" := VATEntry."Gen. Bus. Posting Group";
      "Gen. Prod. Posting Group" := VATEntry."Gen. Prod. Posting Group";
      "VAT Bus. Posting Group" := VATEntry."VAT Bus. Posting Group";
      "VAT Prod. Posting Group" := VATEntry."VAT Prod. Posting Group";
      "Tax Area Code" := VATEntry."Tax Area Code";
      "Tax Liable" := VATEntry."Tax Liable";
      "Tax Group Code" := VATEntry."Tax Group Code";
      "Use Tax" := VATEntry."Use Tax";
    END;

    [External]
    PROCEDURE CopyFromGenJnlLine@2(GenJnlLine@1000 : Record 81);
    BEGIN
      "Entry Type" := "Entry Type"::"Initial Entry";
      "Posting Date" := GenJnlLine."Posting Date";
      "Document Type" := GenJnlLine."Document Type";
      "Document No." := GenJnlLine."Document No.";
      Amount := GenJnlLine.Amount;
      "Amount (LCY)" := GenJnlLine."Amount (LCY)";
      "Additional-Currency Amount" := GenJnlLine.Amount;
      "CV No." := GenJnlLine."Account No.";
      "Currency Code" := GenJnlLine."Currency Code";
      "User ID" := USERID;
      "Initial Entry Due Date" := GenJnlLine."Due Date";
      "Initial Entry Global Dim. 1" := GenJnlLine."Shortcut Dimension 1 Code";
      "Initial Entry Global Dim. 2" := GenJnlLine."Shortcut Dimension 2 Code";
      "Initial Document Type" := GenJnlLine."Document Type";
      OnAfterCopyFromGenJnlLine(Rec,GenJnlLine);
    END;

    [External]
    PROCEDURE InitFromGenJnlLine@7(GenJnlLine@1001 : Record 81);
    BEGIN
      INIT;
      "Posting Date" := GenJnlLine."Posting Date";
      "Document Type" := GenJnlLine."Document Type";
      "Document No." := GenJnlLine."Document No.";
      "User ID" := USERID;
    END;

    [External]
    PROCEDURE CopyFromCVLedgEntryBuf@20(CVLedgEntryBuf@1001 : Record 382);
    BEGIN
      "CV Ledger Entry No." := CVLedgEntryBuf."Entry No.";
      "CV No." := CVLedgEntryBuf."CV No.";
      "Currency Code" := CVLedgEntryBuf."Currency Code";
      "Initial Entry Due Date" := CVLedgEntryBuf."Due Date";
      "Initial Entry Global Dim. 1" := CVLedgEntryBuf."Global Dimension 1 Code";
      "Initial Entry Global Dim. 2" := CVLedgEntryBuf."Global Dimension 2 Code";
      "Initial Document Type" := CVLedgEntryBuf."Document Type";
    END;

    [External]
    PROCEDURE InitDtldCVLedgEntryBuf@26(GenJnlLine@1000 : Record 81;VAR CVLedgEntryBuf@1001 : Record 382;VAR DtldCVLedgEntryBuf@1002 : Record 383;EntryType@1009 : Option;AmountFCY@1003 : Decimal;AmountLCY@1004 : Decimal;AmountAddCurr@1005 : Decimal;AppliedEntryNo@1006 : Integer;RemainingPmtDiscPossible@1007 : Decimal;MaxPaymentTolerance@1008 : Decimal);
    BEGIN
      WITH DtldCVLedgEntryBuf DO BEGIN
        InitFromGenJnlLine(GenJnlLine);
        CopyFromCVLedgEntryBuf(CVLedgEntryBuf);
        "Entry Type" := EntryType;
        Amount := AmountFCY;
        "Amount (LCY)" := AmountLCY;
        "Additional-Currency Amount" := AmountAddCurr;
        "Applied CV Ledger Entry No." := AppliedEntryNo;
        "Remaining Pmt. Disc. Possible" := RemainingPmtDiscPossible;
        "Max. Payment Tolerance" := MaxPaymentTolerance;
        InsertDtldCVLedgEntry(DtldCVLedgEntryBuf,CVLedgEntryBuf,FALSE);
      END;
    END;

    [External]
    PROCEDURE FindVATEntry@3(VAR VATEntry@1000 : Record 254;TransactionNo@1001 : Integer);
    BEGIN
      VATEntry.RESET;
      VATEntry.SETCURRENTKEY("Transaction No.");
      VATEntry.SETRANGE("Transaction No.",TransactionNo);
      VATEntry.SETRANGE("VAT Bus. Posting Group","VAT Bus. Posting Group");
      VATEntry.SETRANGE("VAT Prod. Posting Group","VAT Prod. Posting Group");
      VATEntry.FINDFIRST;
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCopyFromGenJnlLine@1001(VAR DtldCVLedgEntryBuffer@1000 : Record 383;GenJnlLine@1001 : Record 81);
    BEGIN
    END;

    BEGIN
    END.
  }
}

