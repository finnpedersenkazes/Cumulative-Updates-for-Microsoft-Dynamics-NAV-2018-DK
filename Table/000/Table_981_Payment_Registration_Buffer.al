OBJECT Table 981 Payment Registration Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Buffer til betalingsregistrering;
               ENU=Payment Registration Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Ledger Entry No.    ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Posteringsl›benr.;
                                                              ENU=Ledger Entry No.] }
    { 2   ;   ;Source No.          ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kildenr.;
                                                              ENU=Source No.] }
    { 3   ;   ;Document Type       ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bilagstype;
                                                              ENU=Document Type];
                                                   OptionCaptionML=[DAN=" ,Betaling,Faktura,Kreditnota,Rentenota,Rykker,Refusion";
                                                                    ENU=" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund"];
                                                   OptionString=[ ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund] }
    { 4   ;   ;Document No.        ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.] }
    { 5   ;   ;Description         ;Text50        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 6   ;   ;Due Date            ;Date          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Forfaldsdato;
                                                              ENU=Due Date] }
    { 7   ;   ;Name                ;Text50        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Navn;
                                                              ENU=Name] }
    { 8   ;   ;Remaining Amount    ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Restbel›b;
                                                              ENU=Remaining Amount] }
    { 9   ;   ;Payment Made        ;Boolean       ;OnValidate=BEGIN
                                                                IF NOT "Payment Made" THEN BEGIN
                                                                  "Amount Received" := 0;
                                                                  "Date Received" := 0D;
                                                                  "Remaining Amount" := "Original Remaining Amount";
                                                                  EXIT;
                                                                END;

                                                                AutoFillDate;
                                                                IF "Amount Received" = 0 THEN
                                                                  SuggestAmountReceivedBasedOnDate;
                                                                UpdateRemainingAmount;
                                                              END;

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Betaling foretaget;
                                                              ENU=Payment Made] }
    { 10  ;   ;Date Received       ;Date          ;OnValidate=BEGIN
                                                                IF "Date Received" <> 0D THEN
                                                                  VALIDATE("Payment Made",TRUE);
                                                              END;

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dato for modtaget;
                                                              ENU=Date Received] }
    { 11  ;   ;Amount Received     ;Decimal       ;OnValidate=VAR
                                                                MaximumRemainingAmount@1000 : Decimal;
                                                              BEGIN
                                                                IF "Limit Amount Received" THEN BEGIN
                                                                  MaximumRemainingAmount := GetMaximumPaymentAmountBasedOnDate;
                                                                  IF "Amount Received" > MaximumRemainingAmount THEN
                                                                    "Amount Received" := MaximumRemainingAmount;
                                                                END;

                                                                AutoFillDate;
                                                                "Payment Made" := TRUE;
                                                                UpdateRemainingAmount;
                                                              END;

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bel›b modtaget;
                                                              ENU=Amount Received] }
    { 12  ;   ;Original Remaining Amount;Decimal  ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Oprindeligt resterende bel›b;
                                                              ENU=Original Remaining Amount] }
    { 13  ;   ;Rem. Amt. after Discount;Decimal   ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Rest. bel. efter rabat;
                                                              ENU=Rem. Amt. after Discount] }
    { 14  ;   ;Pmt. Discount Date  ;Date          ;OnValidate=BEGIN
                                                                IF "Pmt. Discount Date" <> 0D THEN
                                                                  VALIDATE("Payment Made",TRUE);
                                                              END;

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kont.rabatdato;
                                                              ENU=Pmt. Discount Date] }
    { 15  ;   ;Limit Amount Received;Boolean      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Begr‘ns modtaget bel›b;
                                                              ENU=Limit Amount Received] }
    { 16  ;   ;Payment Method Code ;Code10        ;TableRelation="Payment Method" WHERE (Use for Invoicing=CONST(Yes));
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Betalingsformskode;
                                                              ENU=Payment Method Code] }
    { 17  ;   ;Bal. Account Type   ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Modkontotype;
                                                              ENU=Bal. Account Type];
                                                   OptionCaptionML=[DAN=Finanskonto,Bankkonto;
                                                                    ENU=G/L Account,Bank Account];
                                                   OptionString=G/L Account,Bank Account }
    { 18  ;   ;Bal. Account No.    ;Code20        ;TableRelation=IF (Bal. Account Type=CONST(G/L Account)) "G/L Account"
                                                                 ELSE IF (Bal. Account Type=CONST(Bank Account)) "Bank Account";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Modkonto;
                                                              ENU=Bal. Account No.] }
  }
  KEYS
  {
    {    ;Ledger Entry No.                        ;Clustered=Yes }
    {    ;Due Date                                 }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      DueDateMsg@1000 : TextConst 'DAN=Betalingsfristen er overskredet. Du kan beregne renter for forfaldne betalinger fra debitorer ved at v‘lge knappen Rentenota.;ENU=The payment is overdue. You can calculate interest for late payments from customers by choosing the Finance Charge Memo button.';
      PmtDiscMsg@1001 : TextConst 'DAN=Kontantrabatdatoen er tidligere end Dato for modtaget. Betalingen vil blive registreret som delvis betaling.;ENU=Payment Discount Date is earlier than Date Received. Payment will be registered as partial payment.';

    [External]
    PROCEDURE PopulateTable@1();
    VAR
      CustLedgerEntry@1000 : Record 21;
      Customer@1001 : Record 18;
      PaymentRegistrationSetup@1002 : Record 980;
    BEGIN
      PaymentRegistrationSetup.GET(USERID);
      PaymentRegistrationSetup.TESTFIELD("Bal. Account No.");

      RESET;
      DELETEALL;

      CustLedgerEntry.SETFILTER("Document Type",'<>%1',CustLedgerEntry."Document Type"::Payment);
      CustLedgerEntry.SETRANGE(Open,TRUE);
      IF CustLedgerEntry.FINDSET THEN BEGIN
        REPEAT
          CustLedgerEntry.CALCFIELDS("Remaining Amount");
          Customer.GET(CustLedgerEntry."Customer No.");

          INIT;
          "Ledger Entry No." := CustLedgerEntry."Entry No.";
          "Source No." := CustLedgerEntry."Customer No.";
          Name := Customer.Name;
          "Document No." := CustLedgerEntry."Document No.";
          "Document Type" := CustLedgerEntry."Document Type";
          Description := CustLedgerEntry.Description;
          "Due Date" := CustLedgerEntry."Due Date";
          "Remaining Amount" := CustLedgerEntry."Remaining Amount";
          "Original Remaining Amount" := CustLedgerEntry."Remaining Amount";
          "Pmt. Discount Date" := CustLedgerEntry."Pmt. Discount Date";
          "Rem. Amt. after Discount" := "Remaining Amount" - CustLedgerEntry."Remaining Pmt. Disc. Possible";
          "Payment Method Code" := GetO365DefalutPaymentMethodCode;
          "Bal. Account Type" := PaymentRegistrationSetup."Bal. Account Type";
          "Bal. Account No." := PaymentRegistrationSetup."Bal. Account No.";
          INSERT;
        UNTIL CustLedgerEntry.NEXT = 0;
      END;

      IF FINDSET THEN;
    END;

    [External]
    PROCEDURE Navigate@3();
    VAR
      CustLedgerEntry@1001 : Record 21;
      Navigate@1000 : Page 344;
    BEGIN
      CustLedgerEntry.GET("Ledger Entry No.");
      Navigate.SetDoc(CustLedgerEntry."Posting Date",CustLedgerEntry."Document No.");
      Navigate.RUN;
    END;

    [External]
    PROCEDURE Reload@15();
    VAR
      TempDataSavePmtRegnBuf@1001 : TEMPORARY Record 981;
      TempRecSavePmtRegnBuf@1000 : TEMPORARY Record 981;
    BEGIN
      TempRecSavePmtRegnBuf.COPY(Rec,TRUE);

      SaveUserValues(TempDataSavePmtRegnBuf);

      PopulateTable;

      RestoreUserValues(TempDataSavePmtRegnBuf);

      COPY(TempRecSavePmtRegnBuf);
      IF GET("Ledger Entry No.") THEN;
    END;

    LOCAL PROCEDURE SaveUserValues@12(VAR TempSavePmtRegnBuf@1000 : TEMPORARY Record 981);
    VAR
      TempWorkPmtRegnBuf@1001 : TEMPORARY Record 981;
    BEGIN
      TempWorkPmtRegnBuf.COPY(Rec,TRUE);
      TempWorkPmtRegnBuf.RESET;
      TempWorkPmtRegnBuf.SETRANGE("Payment Made",TRUE);
      IF TempWorkPmtRegnBuf.FINDSET THEN
        REPEAT
          TempSavePmtRegnBuf := TempWorkPmtRegnBuf;
          TempSavePmtRegnBuf.INSERT;
        UNTIL TempWorkPmtRegnBuf.NEXT = 0;
    END;

    LOCAL PROCEDURE RestoreUserValues@13(VAR TempSavePmtRegnBuf@1001 : TEMPORARY Record 981);
    BEGIN
      IF TempSavePmtRegnBuf.FINDSET THEN
        REPEAT
          IF GET(TempSavePmtRegnBuf."Ledger Entry No.") THEN BEGIN
            "Payment Made" := TempSavePmtRegnBuf."Payment Made";
            "Date Received" := TempSavePmtRegnBuf."Date Received";
            "Pmt. Discount Date" := TempSavePmtRegnBuf."Pmt. Discount Date";
            SuggestAmountReceivedBasedOnDate;
            "Remaining Amount" := TempSavePmtRegnBuf."Remaining Amount";
            "Amount Received" := TempSavePmtRegnBuf."Amount Received";
            MODIFY;
          END;
        UNTIL TempSavePmtRegnBuf.NEXT = 0;
    END;

    [External]
    PROCEDURE GetPmtDiscStyle@5() : Text;
    BEGIN
      IF ("Pmt. Discount Date" < "Date Received") AND ("Remaining Amount" <> 0) AND ("Date Received" < "Due Date") THEN
        EXIT('Unfavorable');
      EXIT('');
    END;

    [External]
    PROCEDURE GetDueDateStyle@8() : Text;
    BEGIN
      IF "Due Date" < "Date Received" THEN
        EXIT('Unfavorable');
      EXIT('');
    END;

    [External]
    PROCEDURE GetWarning@6() : Text;
    BEGIN
      IF "Date Received" <= "Pmt. Discount Date" THEN
        EXIT('');

      IF "Date Received" > "Due Date" THEN
        EXIT(DueDateMsg);

      IF "Remaining Amount" <> 0 THEN
        EXIT(PmtDiscMsg);

      EXIT('');
    END;

    LOCAL PROCEDURE AutoFillDate@2();
    VAR
      PaymentRegistrationSetup@1000 : Record 980;
    BEGIN
      IF "Date Received" = 0D THEN BEGIN
        PaymentRegistrationSetup.GET(USERID);
        IF PaymentRegistrationSetup."Auto Fill Date Received" THEN
          "Date Received" := WORKDATE;
      END;
    END;

    LOCAL PROCEDURE SuggestAmountReceivedBasedOnDate@4();
    BEGIN
      "Amount Received" := GetMaximumPaymentAmountBasedOnDate;
      IF "Date Received" = 0D THEN
        EXIT;
      "Remaining Amount" := 0;
    END;

    LOCAL PROCEDURE GetMaximumPaymentAmountBasedOnDate@9() : Decimal;
    BEGIN
      IF "Date Received" = 0D THEN
        EXIT(0);

      IF "Date Received" <= "Pmt. Discount Date" THEN
        EXIT("Rem. Amt. after Discount");

      EXIT("Original Remaining Amount");
    END;

    LOCAL PROCEDURE GetO365DefalutPaymentMethodCode@10() : Code[10];
    VAR
      O365SalesInitialSetup@1000 : Record 2110;
    BEGIN
      IF O365SalesInitialSetup.GET THEN
        EXIT(O365SalesInitialSetup."Default Payment Method Code");
    END;

    LOCAL PROCEDURE UpdateRemainingAmount@7();
    BEGIN
      IF "Date Received" = 0D THEN
        EXIT;
      IF ABS("Amount Received") >= ABS("Original Remaining Amount") THEN
        "Remaining Amount" := 0
      ELSE
        IF "Date Received" <= "Pmt. Discount Date" THEN BEGIN
          IF "Amount Received" >= "Rem. Amt. after Discount" THEN
            "Remaining Amount" := 0
          ELSE
            "Remaining Amount" := "Original Remaining Amount" - "Amount Received";
        END ELSE
          "Remaining Amount" := "Original Remaining Amount" - "Amount Received";
    END;

    BEGIN
    END.
  }
}

