OBJECT Table 1248 Ledger Entry Matching Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Finanspost - matchbuffer;
               ENU=Ledger Entry Matching Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=L�benr.;
                                                              ENU=Entry No.] }
    { 2   ;   ;Account Type        ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kontotype;
                                                              ENU=Account Type];
                                                   OptionCaptionML=[DAN=Debitor,Kreditor,Finanskonto,Bankkonto;
                                                                    ENU=Customer,Vendor,G/L Account,Bank Account];
                                                   OptionString=Customer,Vendor,G/L Account,Bank Account }
    { 3   ;   ;Account No.         ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kontonr.;
                                                              ENU=Account No.] }
    { 4   ;   ;Bal. Account Type   ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Modkontotype;
                                                              ENU=Bal. Account Type];
                                                   OptionCaptionML=[DAN=Finanskonto,Debitor,Kreditor,Bankkonto,Anl�g;
                                                                    ENU=G/L Account,Customer,Vendor,Bank Account,Fixed Asset];
                                                   OptionString=G/L Account,Customer,Vendor,Bank Account,Fixed Asset }
    { 5   ;   ;Bal. Account No.    ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Modkonto;
                                                              ENU=Bal. Account No.] }
    { 8   ;   ;Document Type       ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bilagstype;
                                                              ENU=Document Type];
                                                   OptionCaptionML=[DAN=" ,Betaling,Faktura,Kreditnota,Rentenota,Rykker,Refusion";
                                                                    ENU=" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund"];
                                                   OptionString=[ ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund] }
    { 9   ;   ;Due Date            ;Date          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Forfaldsdato;
                                                              ENU=Due Date] }
    { 10  ;   ;Posting Date        ;Date          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bogf�ringsdato;
                                                              ENU=Posting Date] }
    { 11  ;   ;Document No.        ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.] }
    { 12  ;   ;External Document No.;Code35       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Eksternt bilagsnr.;
                                                              ENU=External Document No.] }
    { 20  ;   ;Remaining Amount    ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Restbel�b;
                                                              ENU=Remaining Amount] }
    { 21  ;   ;Remaining Amt. Incl. Discount;Decimal;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Restbel�b inkl. rabat;
                                                              ENU=Remaining Amt. Incl. Discount] }
    { 22  ;   ;Pmt. Discount Due Date;Date        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Forfaldsdato for kontantrabat;
                                                              ENU=Pmt. Discount Due Date] }
  }
  KEYS
  {
    {    ;Entry No.,Account Type                  ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    [External]
    PROCEDURE InsertFromCustomerLedgerEntry@1(CustLedgerEntry@1000 : Record 21;UseLCYAmounts@1001 : Boolean;VAR UsePaymentDiscounts@1002 : Boolean);
    BEGIN
      CLEAR(Rec);
      "Entry No." := CustLedgerEntry."Entry No.";
      "Account Type" := "Account Type"::Customer;
      "Account No." := CustLedgerEntry."Customer No.";
      "Due Date" := CustLedgerEntry."Due Date";
      "Posting Date" := CustLedgerEntry."Posting Date";
      "Document No." := CustLedgerEntry."Document No.";
      "External Document No." := CustLedgerEntry."External Document No.";

      IF UseLCYAmounts THEN
        "Remaining Amount" := CustLedgerEntry."Remaining Amt. (LCY)"
      ELSE
        "Remaining Amount" := CustLedgerEntry."Remaining Amount";

      "Pmt. Discount Due Date" := GetCustomerLedgerEntryDiscountDueDate(CustLedgerEntry);

      "Remaining Amt. Incl. Discount" := "Remaining Amount";
      IF "Pmt. Discount Due Date" > 0D THEN BEGIN
        IF UseLCYAmounts THEN
          "Remaining Amt. Incl. Discount" -=
            ROUND(CustLedgerEntry."Remaining Pmt. Disc. Possible" / CustLedgerEntry."Adjusted Currency Factor")
        ELSE
          "Remaining Amt. Incl. Discount" -= CustLedgerEntry."Remaining Pmt. Disc. Possible";
        UsePaymentDiscounts := TRUE;
      END;

      INSERT(TRUE);
    END;

    [External]
    PROCEDURE InsertFromVendorLedgerEntry@4(VendorLedgerEntry@1000 : Record 25;UseLCYAmounts@1001 : Boolean;VAR UsePaymentDiscounts@1002 : Boolean);
    BEGIN
      CLEAR(Rec);
      "Entry No." := VendorLedgerEntry."Entry No.";
      "Account Type" := "Account Type"::Vendor;
      "Account No." := VendorLedgerEntry."Vendor No.";
      "Due Date" := VendorLedgerEntry."Due Date";
      "Posting Date" := VendorLedgerEntry."Posting Date";
      "Document No." := VendorLedgerEntry."Document No.";
      "External Document No." := VendorLedgerEntry."External Document No.";

      IF UseLCYAmounts THEN
        "Remaining Amount" := VendorLedgerEntry."Remaining Amt. (LCY)"
      ELSE
        "Remaining Amount" := VendorLedgerEntry."Remaining Amount";

      "Pmt. Discount Due Date" := GetVendorLedgerEntryDiscountDueDate(VendorLedgerEntry);

      "Remaining Amt. Incl. Discount" := "Remaining Amount";
      IF "Pmt. Discount Due Date" > 0D THEN BEGIN
        IF UseLCYAmounts THEN
          "Remaining Amt. Incl. Discount" -=
            ROUND(VendorLedgerEntry."Remaining Pmt. Disc. Possible" / VendorLedgerEntry."Adjusted Currency Factor")
        ELSE
          "Remaining Amt. Incl. Discount" -= VendorLedgerEntry."Remaining Pmt. Disc. Possible";
        UsePaymentDiscounts := TRUE;
      END;

      INSERT(TRUE);
    END;

    [External]
    PROCEDURE InsertFromBankAccLedgerEntry@5(BankAccountLedgerEntry@1000 : Record 271);
    BEGIN
      CLEAR(Rec);
      "Entry No." := BankAccountLedgerEntry."Entry No.";
      "Account Type" := "Account Type"::"Bank Account";
      "Account No." := BankAccountLedgerEntry."Bank Account No.";
      "Bal. Account Type" := BankAccountLedgerEntry."Bal. Account Type";
      "Bal. Account No." := BankAccountLedgerEntry."Bal. Account No.";
      "Posting Date" := BankAccountLedgerEntry."Posting Date";
      "Document Type" := BankAccountLedgerEntry."Document Type";
      "Document No." := BankAccountLedgerEntry."Document No.";
      "External Document No." := BankAccountLedgerEntry."External Document No.";
      "Remaining Amount" := BankAccountLedgerEntry."Remaining Amount";
      "Remaining Amt. Incl. Discount" := "Remaining Amount";

      INSERT(TRUE);
    END;

    [External]
    PROCEDURE GetApplicableRemainingAmount@6(BankAccReconciliationLine@1000 : Record 274;UsePaymentDiscounts@1001 : Boolean) : Decimal;
    BEGIN
      IF NOT UsePaymentDiscounts THEN
        EXIT("Remaining Amount");

      IF BankAccReconciliationLine."Transaction Date" > "Pmt. Discount Due Date" THEN
        EXIT("Remaining Amount");

      EXIT("Remaining Amt. Incl. Discount");
    END;

    [External]
    PROCEDURE GetNoOfLedgerEntriesWithinRange@9(MinAmount@1001 : Decimal;MaxAmount@1000 : Decimal;TransactionDate@1002 : Date;UsePaymentDiscounts@1004 : Boolean) : Integer;
    BEGIN
      EXIT(GetNoOfLedgerEntriesInAmountRange(MinAmount,MaxAmount,TransactionDate,'>=%1&<=%2',UsePaymentDiscounts));
    END;

    [External]
    PROCEDURE GetNoOfLedgerEntriesOutsideRange@10(MinAmount@1002 : Decimal;MaxAmount@1001 : Decimal;TransactionDate@1000 : Date;UsePaymentDiscounts@1003 : Boolean) : Integer;
    BEGIN
      EXIT(GetNoOfLedgerEntriesInAmountRange(MinAmount,MaxAmount,TransactionDate,'<%1|>%2',UsePaymentDiscounts));
    END;

    LOCAL PROCEDURE GetNoOfLedgerEntriesInAmountRange@23(MinAmount@1001 : Decimal;MaxAmount@1000 : Decimal;TransactionDate@1002 : Date;RangeFilter@1004 : Text;UsePaymentDiscounts@1005 : Boolean) : Integer;
    VAR
      NoOfEntreis@1003 : Integer;
    BEGIN
      SETFILTER("Remaining Amount",RangeFilter,MinAmount,MaxAmount);
      SETFILTER("Pmt. Discount Due Date",'<%1',TransactionDate);
      NoOfEntreis := COUNT;

      SETRANGE("Remaining Amount");

      IF UsePaymentDiscounts THEN BEGIN
        SETFILTER("Remaining Amt. Incl. Discount",RangeFilter,MinAmount,MaxAmount);
        SETFILTER("Pmt. Discount Due Date",'>=%1',TransactionDate);
        NoOfEntreis += COUNT;
        SETRANGE("Remaining Amt. Incl. Discount");
      END;

      SETRANGE("Pmt. Discount Due Date");

      EXIT(NoOfEntreis);
    END;

    LOCAL PROCEDURE GetCustomerLedgerEntryDiscountDueDate@2(CustLedgerEntry@1000 : Record 21) : Date;
    BEGIN
      IF CustLedgerEntry."Remaining Pmt. Disc. Possible" = 0 THEN
        EXIT(0D);

      IF CustLedgerEntry."Pmt. Disc. Tolerance Date" >= CustLedgerEntry."Pmt. Discount Date" THEN
        EXIT(CustLedgerEntry."Pmt. Disc. Tolerance Date");

      EXIT(CustLedgerEntry."Pmt. Discount Date");
    END;

    LOCAL PROCEDURE GetVendorLedgerEntryDiscountDueDate@3(VendorLedgerEntry@1000 : Record 25) : Date;
    BEGIN
      IF VendorLedgerEntry."Remaining Pmt. Disc. Possible" = 0 THEN
        EXIT(0D);

      IF VendorLedgerEntry."Pmt. Disc. Tolerance Date" >= VendorLedgerEntry."Pmt. Discount Date" THEN
        EXIT(VendorLedgerEntry."Pmt. Disc. Tolerance Date");

      EXIT(VendorLedgerEntry."Pmt. Discount Date");
    END;

    BEGIN
    END.
  }
}

