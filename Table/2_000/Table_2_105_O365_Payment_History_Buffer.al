OBJECT Table 2105 O365 Payment History Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Buffer for O365-betalingshistorik;
               ENU=O365 Payment History Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Ledger Entry No.    ;Integer       ;TableRelation="G/L Entry";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Posteringsl›benr.;
                                                              ENU=Ledger Entry No.] }
    { 2   ;   ;Type                ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=" ,Betaling,Faktura,Kreditnota,Rentenota,Rykker,Refusion";
                                                                    ENU=" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund"];
                                                   OptionString=[ ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund] }
    { 3   ;   ;Amount              ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bel›b;
                                                              ENU=Amount];
                                                   AutoFormatType=10;
                                                   AutoFormatExpr='1' }
    { 4   ;   ;Date Received       ;Date          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dato for modtaget;
                                                              ENU=Date Received] }
    { 5   ;   ;Payment Method      ;Code10        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Betalingsform;
                                                              ENU=Payment Method] }
  }
  KEYS
  {
    {    ;Ledger Entry No.                        ;Clustered=Yes }
  }
  FIELDGROUPS
  {
    { 1   ;Brick               ;Date Received,Type,Amount,Payment Method }
  }
  CODE
  {
    VAR
      CanOnlyCancelPaymentsErr@1002 : TextConst 'DAN=Kun betalingsregistreringer kan annulleres.;ENU=Only payment registrations can be canceled.';
      CanOnlyCancelLastPaymentErr@1001 : TextConst 'DAN=Kun sidste betalingsregistrering kan annulleres.;ENU=Only the last payment registration can be canceled.';
      DevMsgNotTemporaryErr@1000 : TextConst 'DAN=Denne funktion kan kun bruges, n†r recorden er midlertidig.;ENU=This function can only be used when the record is temporary.';
      O365SalesInvoicePayment@1003 : Codeunit 2105;
      MarkAsUnpaidConfirmQst@1004 : TextConst 'DAN=Annuller denne betalingsregistrering?;ENU=Cancel this payment registration?';

    [External]
    PROCEDURE FillPaymentHistory@1(SalesInvoiceDocumentNo@1000 : Code[20];IncludeSalesInvoice@1001 : Boolean);
    VAR
      InvoiceCustLedgerEntry@1002 : Record 21;
      PaymentCustLedgerEntry@1003 : Record 21;
    BEGIN
      IF NOT ISTEMPORARY THEN
        ERROR(DevMsgNotTemporaryErr);

      RESET;
      DELETEALL;
      InvoiceCustLedgerEntry.SETRANGE("Document Type",InvoiceCustLedgerEntry."Document Type"::Invoice);
      InvoiceCustLedgerEntry.SETRANGE("Document No.",SalesInvoiceDocumentNo);
      IF NOT InvoiceCustLedgerEntry.FINDFIRST THEN
        EXIT;

      IF IncludeSalesInvoice THEN
        CopyFromCustomerLedgerEntry(InvoiceCustLedgerEntry);

      IF PaymentCustLedgerEntry.GET(InvoiceCustLedgerEntry."Closed by Entry No.") THEN
        CopyFromCustomerLedgerEntry(PaymentCustLedgerEntry);

      PaymentCustLedgerEntry.SETCURRENTKEY("Closed by Entry No.");
      PaymentCustLedgerEntry.SETRANGE("Closed by Entry No.",InvoiceCustLedgerEntry."Entry No.");
      IF PaymentCustLedgerEntry.FINDSET THEN
        REPEAT
          CopyFromCustomerLedgerEntry(PaymentCustLedgerEntry);
        UNTIL PaymentCustLedgerEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE CopyFromCustomerLedgerEntry@6(CustLedgerEntry@1000 : Record 21);
    BEGIN
      CustLedgerEntry.CALCFIELDS("Amount (LCY)");
      INIT;
      "Ledger Entry No." := CustLedgerEntry."Entry No.";
      Type := CustLedgerEntry."Document Type";
      Amount := CustLedgerEntry."Amount (LCY)";
      IF Type = Type::Payment THEN
        Amount := -Amount;
      "Date Received" := CustLedgerEntry."Posting Date";
      "Payment Method" := CustLedgerEntry."Payment Method Code";
      INSERT(TRUE);
    END;

    [Internal]
    PROCEDURE CancelPayment@2() : Boolean;
    VAR
      TempO365PaymentHistoryBuffer@1000 : TEMPORARY Record 2105;
    BEGIN
      IF Type <> Type::Payment THEN
        ERROR(CanOnlyCancelPaymentsErr);
      TempO365PaymentHistoryBuffer.COPY(Rec,TRUE);
      TempO365PaymentHistoryBuffer.SETFILTER("Ledger Entry No.",'>%1',"Ledger Entry No.");
      IF NOT TempO365PaymentHistoryBuffer.ISEMPTY THEN
        ERROR(CanOnlyCancelLastPaymentErr);
      IF NOT CONFIRM(MarkAsUnpaidConfirmQst) THEN
        EXIT(FALSE);

      O365SalesInvoicePayment.CancelCustLedgerEntry("Ledger Entry No.");
      EXIT(TRUE);
    END;

    BEGIN
    END.
  }
}

