OBJECT Table 5223 Detailed Employee Ledger Entry
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    Permissions=TableData 5223=m;
    OnInsert=BEGIN
               SetLedgerEntryAmount;
             END;

    CaptionML=[DAN=Detaljeret medarbejderpost;
               ENU=Detailed Employee Ledger Entry];
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;CaptionML=[DAN=L›benummer;
                                                              ENU=Entry No.] }
    { 2   ;   ;Employee Ledger Entry No.;Integer  ;TableRelation="Employee Ledger Entry";
                                                   CaptionML=[DAN=Medarbejderpostnr.;
                                                              ENU=Employee Ledger Entry No.] }
    { 3   ;   ;Entry Type          ;Option        ;CaptionML=[DAN=Posttype;
                                                              ENU=Entry Type];
                                                   OptionCaptionML=[DAN=,Startpost,Udligning;
                                                                    ENU=,Initial Entry,Application];
                                                   OptionString=,Initial Entry,Application }
    { 4   ;   ;Posting Date        ;Date          ;CaptionML=[DAN=Bogf›ringsdato;
                                                              ENU=Posting Date] }
    { 5   ;   ;Document Type       ;Option        ;CaptionML=[DAN=Dokumenttype;
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
    { 9   ;   ;Employee No.        ;Code20        ;TableRelation=Employee;
                                                   CaptionML=[DAN=Medarbejdernr.;
                                                              ENU=Employee No.] }
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
    { 21  ;   ;Initial Entry Global Dim. 1;Code20 ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   CaptionML=[DAN=Global dim. 1 til startpost;
                                                              ENU=Initial Entry Global Dim. 1] }
    { 22  ;   ;Initial Entry Global Dim. 2;Code20 ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   CaptionML=[DAN=Global dim. 2 til startpost;
                                                              ENU=Initial Entry Global Dim. 2] }
    { 35  ;   ;Initial Document Type;Option       ;CaptionML=[DAN=Oprindelig dokumenttype;
                                                              ENU=Initial Document Type];
                                                   OptionCaptionML=[DAN=" ,Betaling,Faktura,Kreditnota,Rentenota,Rykker,Refusion";
                                                                    ENU=" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund"];
                                                   OptionString=[ ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund] }
    { 36  ;   ;Applied Empl. Ledger Entry No.;Integer;
                                                   CaptionML=[DAN=Udlignet medarbejderpostl›benr.;
                                                              ENU=Applied Empl. Ledger Entry No.] }
    { 37  ;   ;Unapplied           ;Boolean       ;CaptionML=[DAN=Udligning annulleret;
                                                              ENU=Unapplied] }
    { 38  ;   ;Unapplied by Entry No.;Integer     ;TableRelation="Detailed Vendor Ledg. Entry";
                                                   CaptionML=[DAN=Udlign. annulleret af l›benr.;
                                                              ENU=Unapplied by Entry No.] }
    { 42  ;   ;Application No.     ;Integer       ;CaptionML=[DAN=Udligningsnr.;
                                                              ENU=Application No.];
                                                   Editable=No }
    { 43  ;   ;Ledger Entry Amount ;Boolean       ;CaptionML=[DAN=Posteringsbel›b;
                                                              ENU=Ledger Entry Amount];
                                                   Editable=No }
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
      DtldEmplLedgEntry@1001 : Record 5223;
      ApplicationNo@1002 : Integer;
    BEGIN
      DtldEmplLedgEntry.SETCURRENTKEY("Transaction No.");
      DtldEmplLedgEntry.SETRANGE("Transaction No.",TransactionNo);
      IF DtldEmplLedgEntry.FINDSET(TRUE) THEN BEGIN
        ApplicationNo := DtldEmplLedgEntry."Entry No.";
        REPEAT
          DtldEmplLedgEntry."Transaction No." := 0;
          DtldEmplLedgEntry."Application No." := ApplicationNo;
          DtldEmplLedgEntry.MODIFY;
        UNTIL DtldEmplLedgEntry.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE SetLedgerEntryAmount@1();
    BEGIN
      "Ledger Entry Amount" := NOT ("Entry Type" = "Entry Type"::Application);
    END;

    BEGIN
    END.
  }
}

