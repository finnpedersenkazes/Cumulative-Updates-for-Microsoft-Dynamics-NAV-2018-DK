OBJECT Table 380 Detailed Vendor Ledg. Entry
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    Permissions=TableData 380=m;
    DataCaptionFields=Vendor No.;
    OnInsert=BEGIN
               SetLedgerEntryAmount;
             END;

    CaptionML=[DAN=Detaljeret kreditorpost;
               ENU=Detailed Vendor Ledg. Entry];
    LookupPageID=Page574;
    DrillDownPageID=Page574;
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;CaptionML=[DAN=L›benr.;
                                                              ENU=Entry No.] }
    { 2   ;   ;Vendor Ledger Entry No.;Integer    ;TableRelation="Vendor Ledger Entry";
                                                   CaptionML=[DAN=Kreditorl›benr.;
                                                              ENU=Vendor Ledger Entry No.] }
    { 3   ;   ;Entry Type          ;Option        ;CaptionML=[DAN=Posttype;
                                                              ENU=Entry Type];
                                                   OptionCaptionML=[DAN=,Startpost,Udligning,Urealiseret tab,Urealiseret gevinst,Realiseret tab,Realiseret gevinst,Kontantrabat,Kontantrabat (f›r moms),Kontantrabat (momsregul.),Udligningsafrunding,Rettelse af restbel›b,Betalingstolerance,Kontantrabattolerance,Betalingstolerance (f›r moms),Betalingstolerance (momsregul.),Kontantrabattolerance (f›r moms),Kontantrabattolerance (momsregul.);
                                                                    ENU=,Initial Entry,Application,Unrealized Loss,Unrealized Gain,Realized Loss,Realized Gain,Payment Discount,Payment Discount (VAT Excl.),Payment Discount (VAT Adjustment),Appln. Rounding,Correction of Remaining Amount,Payment Tolerance,Payment Discount Tolerance,Payment Tolerance (VAT Excl.),Payment Tolerance (VAT Adjustment),Payment Discount Tolerance (VAT Excl.),Payment Discount Tolerance (VAT Adjustment)];
                                                   OptionString=,Initial Entry,Application,Unrealized Loss,Unrealized Gain,Realized Loss,Realized Gain,Payment Discount,Payment Discount (VAT Excl.),Payment Discount (VAT Adjustment),Appln. Rounding,Correction of Remaining Amount,Payment Tolerance,Payment Discount Tolerance,Payment Tolerance (VAT Excl.),Payment Tolerance (VAT Adjustment),Payment Discount Tolerance (VAT Excl.),Payment Discount Tolerance (VAT Adjustment) }
    { 4   ;   ;Posting Date        ;Date          ;CaptionML=[DAN=Bogf›ringsdato;
                                                              ENU=Posting Date] }
    { 5   ;   ;Document Type       ;Option        ;CaptionML=[DAN=Bilagstype;
                                                              ENU=Document Type];
                                                   OptionCaptionML=[DAN=" ,Betaling,Faktura,Kreditnota,Rentenota,Rykker,Refusion";
                                                                    ENU=" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund"];
                                                   OptionString=[ ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund] }
    { 6   ;   ;Document No.        ;Code20        ;CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.] }
    { 7   ;   ;Amount              ;Decimal       ;CaptionML=[DAN=Bel›b;
                                                              ENU=Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 8   ;   ;Amount (LCY)        ;Decimal       ;CaptionML=[DAN=Bel›b (RV);
                                                              ENU=Amount (LCY)];
                                                   AutoFormatType=1 }
    { 9   ;   ;Vendor No.          ;Code20        ;TableRelation=Vendor;
                                                   CaptionML=[DAN=Kreditornr.;
                                                              ENU=Vendor No.] }
    { 10  ;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   CaptionML=[DAN=Valutakode;
                                                              ENU=Currency Code] }
    { 11  ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("User ID");
                                                            END;

                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 12  ;   ;Source Code         ;Code10        ;TableRelation="Source Code";
                                                   CaptionML=[DAN=Kildespor;
                                                              ENU=Source Code] }
    { 13  ;   ;Transaction No.     ;Integer       ;CaptionML=[DAN=Transaktionsnr.;
                                                              ENU=Transaction No.] }
    { 14  ;   ;Journal Batch Name  ;Code10        ;TestTableRelation=No;
                                                   CaptionML=[DAN=Kladdenavn;
                                                              ENU=Journal Batch Name] }
    { 15  ;   ;Reason Code         ;Code10        ;TableRelation="Reason Code";
                                                   CaptionML=[DAN=rsagskode;
                                                              ENU=Reason Code] }
    { 16  ;   ;Debit Amount        ;Decimal       ;CaptionML=[DAN=Debetbel›b;
                                                              ENU=Debit Amount];
                                                   BlankZero=Yes;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 17  ;   ;Credit Amount       ;Decimal       ;CaptionML=[DAN=Kreditbel›b;
                                                              ENU=Credit Amount];
                                                   BlankZero=Yes;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 18  ;   ;Debit Amount (LCY)  ;Decimal       ;CaptionML=[DAN=Debetbel›b (RV);
                                                              ENU=Debit Amount (LCY)];
                                                   BlankZero=Yes;
                                                   AutoFormatType=1 }
    { 19  ;   ;Credit Amount (LCY) ;Decimal       ;CaptionML=[DAN=Kreditbel›b (RV);
                                                              ENU=Credit Amount (LCY)];
                                                   BlankZero=Yes;
                                                   AutoFormatType=1 }
    { 20  ;   ;Initial Entry Due Date;Date        ;CaptionML=[DAN=Forfaldsdato for startpost;
                                                              ENU=Initial Entry Due Date] }
    { 21  ;   ;Initial Entry Global Dim. 1;Code20 ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   CaptionML=[DAN=Global dim. 1 til startpost;
                                                              ENU=Initial Entry Global Dim. 1] }
    { 22  ;   ;Initial Entry Global Dim. 2;Code20 ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   CaptionML=[DAN=Global dim. 2 til startpost;
                                                              ENU=Initial Entry Global Dim. 2] }
    { 24  ;   ;Gen. Bus. Posting Group;Code20     ;TableRelation="Gen. Business Posting Group";
                                                   CaptionML=[DAN=Virksomhedsbogf›ringsgruppe;
                                                              ENU=Gen. Bus. Posting Group] }
    { 25  ;   ;Gen. Prod. Posting Group;Code20    ;TableRelation="Gen. Product Posting Group";
                                                   CaptionML=[DAN=Produktbogf›ringsgruppe;
                                                              ENU=Gen. Prod. Posting Group] }
    { 29  ;   ;Use Tax             ;Boolean       ;CaptionML=[DAN=Use Tax;
                                                              ENU=Use Tax] }
    { 30  ;   ;VAT Bus. Posting Group;Code20      ;TableRelation="VAT Business Posting Group";
                                                   CaptionML=[DAN=Momsvirksomhedsbogf.gruppe;
                                                              ENU=VAT Bus. Posting Group] }
    { 31  ;   ;VAT Prod. Posting Group;Code20     ;TableRelation="VAT Product Posting Group";
                                                   CaptionML=[DAN=Momsproduktbogf.gruppe;
                                                              ENU=VAT Prod. Posting Group] }
    { 35  ;   ;Initial Document Type;Option       ;CaptionML=[DAN=Startbilagstype;
                                                              ENU=Initial Document Type];
                                                   OptionCaptionML=[DAN=" ,Betaling,Faktura,Kreditnota,Rentenota,Rykker,Refusion";
                                                                    ENU=" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund"];
                                                   OptionString=[ ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund] }
    { 36  ;   ;Applied Vend. Ledger Entry No.;Integer;
                                                   CaptionML=[DAN=Udlignet kreditorl›benr.;
                                                              ENU=Applied Vend. Ledger Entry No.] }
    { 37  ;   ;Unapplied           ;Boolean       ;CaptionML=[DAN=Udligning annulleret;
                                                              ENU=Unapplied] }
    { 38  ;   ;Unapplied by Entry No.;Integer     ;TableRelation="Detailed Vendor Ledg. Entry";
                                                   CaptionML=[DAN=Udlign. annulleret af l›benr.;
                                                              ENU=Unapplied by Entry No.] }
    { 39  ;   ;Remaining Pmt. Disc. Possible;Decimal;
                                                   CaptionML=[DAN=Mulig restkontantrabat;
                                                              ENU=Remaining Pmt. Disc. Possible];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 40  ;   ;Max. Payment Tolerance;Decimal     ;CaptionML=[DAN=Maks. betalingstolerance;
                                                              ENU=Max. Payment Tolerance];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 41  ;   ;Tax Jurisdiction Code;Code10       ;TableRelation="Tax Jurisdiction";
                                                   CaptionML=[DAN=Skatteregionkode;
                                                              ENU=Tax Jurisdiction Code];
                                                   Editable=No }
    { 42  ;   ;Application No.     ;Integer       ;CaptionML=[DAN=Programnr.;
                                                              ENU=Application No.];
                                                   Editable=No }
    { 43  ;   ;Ledger Entry Amount ;Boolean       ;CaptionML=[DAN=Posteringsbel›b;
                                                              ENU=Ledger Entry Amount];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Entry No.                               ;Clustered=Yes }
    {    ;Vendor Ledger Entry No.,Posting Date     }
    {    ;Vendor Ledger Entry No.,Entry Type,Posting Date;
                                                   SumIndexFields=Amount (LCY);
                                                   MaintainSQLIndex=No }
    {    ;Ledger Entry Amount,Vendor Ledger Entry No.,Posting Date;
                                                   SumIndexFields=Amount,Amount (LCY),Debit Amount,Credit Amount,Debit Amount (LCY),Credit Amount (LCY);
                                                   MaintainSQLIndex=No;
                                                   MaintainSIFTIndex=No }
    {    ;Initial Document Type,Entry Type,Vendor No.,Currency Code,Initial Entry Global Dim. 1,Initial Entry Global Dim. 2,Posting Date;
                                                   SumIndexFields=Amount,Amount (LCY);
                                                   MaintainSIFTIndex=No }
    {    ;Vendor No.,Currency Code,Initial Entry Global Dim. 1,Initial Entry Global Dim. 2,Initial Entry Due Date,Posting Date;
                                                   SumIndexFields=Amount,Amount (LCY) }
    {    ;Document No.,Document Type,Posting Date  }
    {    ;Applied Vend. Ledger Entry No.,Entry Type }
    {    ;Transaction No.,Vendor No.,Entry Type    }
    {    ;Application No.,Vendor No.,Entry Type    }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;Entry No.,Vendor Ledger Entry No.,Vendor No.,Posting Date,Document Type,Document No. }
  }
  CODE
  {

    [External]
    PROCEDURE UpdateDebitCredit@47(Correction@1000 : Boolean);
    BEGIN
      IF ((Amount > 0) OR ("Amount (LCY)" > 0)) AND NOT Correction OR
         ((Amount < 0) OR ("Amount (LCY)" < 0)) AND Correction
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
    PROCEDURE SetZeroTransNo@3(TransactionNo@1000 : Integer);
    VAR
      DtldVendLedgEntry@1001 : Record 380;
      ApplicationNo@1002 : Integer;
    BEGIN
      DtldVendLedgEntry.SETCURRENTKEY("Transaction No.");
      DtldVendLedgEntry.SETRANGE("Transaction No.",TransactionNo);
      IF DtldVendLedgEntry.FINDSET(TRUE) THEN BEGIN
        ApplicationNo := DtldVendLedgEntry."Entry No.";
        REPEAT
          DtldVendLedgEntry."Transaction No." := 0;
          DtldVendLedgEntry."Application No." := ApplicationNo;
          DtldVendLedgEntry.MODIFY;
        UNTIL DtldVendLedgEntry.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE SetLedgerEntryAmount@1();
    BEGIN
      "Ledger Entry Amount" :=
        NOT (("Entry Type" = "Entry Type"::Application) OR ("Entry Type" = "Entry Type"::"Appln. Rounding"));
    END;

    [External]
    PROCEDURE GetUnrealizedGainLossAmount@2(EntryNo@1000 : Integer) : Decimal;
    BEGIN
      SETCURRENTKEY("Vendor Ledger Entry No.","Entry Type");
      SETRANGE("Vendor Ledger Entry No.",EntryNo);
      SETRANGE("Entry Type","Entry Type"::"Unrealized Loss","Entry Type"::"Unrealized Gain");
      CALCSUMS("Amount (LCY)");
      EXIT("Amount (LCY)");
    END;

    BEGIN
    END.
  }
}

