OBJECT Table 382 CV Ledger Entry Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Kunde/leverand�r - bogf.buffer;
               ENU=CV Ledger Entry Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=L�benr.;
                                                              ENU=Entry No.] }
    { 3   ;   ;CV No.              ;Code20        ;TableRelation=Customer;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Debitor/kreditornr.;
                                                              ENU=CV No.] }
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
    { 7   ;   ;Description         ;Text50        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 11  ;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Valutakode;
                                                              ENU=Currency Code] }
    { 13  ;   ;Amount              ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bel�b;
                                                              ENU=Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 14  ;   ;Remaining Amount    ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Restbel�b;
                                                              ENU=Remaining Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 15  ;   ;Original Amt. (LCY) ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Opr. bel�b (RV);
                                                              ENU=Original Amt. (LCY)];
                                                   AutoFormatType=1 }
    { 16  ;   ;Remaining Amt. (LCY);Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Restbel�b (RV);
                                                              ENU=Remaining Amt. (LCY)];
                                                   AutoFormatType=1 }
    { 17  ;   ;Amount (LCY)        ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bel�b (RV);
                                                              ENU=Amount (LCY)];
                                                   AutoFormatType=1 }
    { 18  ;   ;Sales/Purchase (LCY);Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Salg/k�b (RV);
                                                              ENU=Sales/Purchase (LCY)];
                                                   AutoFormatType=1 }
    { 19  ;   ;Profit (LCY)        ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Avancebel�b (RV);
                                                              ENU=Profit (LCY)];
                                                   AutoFormatType=1 }
    { 20  ;   ;Inv. Discount (LCY) ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Fakt.rabatbel�b (RV);
                                                              ENU=Inv. Discount (LCY)];
                                                   AutoFormatType=1 }
    { 21  ;   ;Bill-to/Pay-to CV No.;Code20       ;TableRelation=Customer;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kunde/leverand�rnr.;
                                                              ENU=Bill-to/Pay-to CV No.] }
    { 22  ;   ;CV Posting Group    ;Code20        ;TableRelation="Customer Posting Group";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bogf.gruppe - kunde/leverand�r;
                                                              ENU=CV Posting Group] }
    { 23  ;   ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Global dimension 1-kode;
                                                              ENU=Global Dimension 1 Code];
                                                   CaptionClass='1,1,1' }
    { 24  ;   ;Global Dimension 2 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Global dimension 2-kode;
                                                              ENU=Global Dimension 2 Code];
                                                   CaptionClass='1,1,2' }
    { 25  ;   ;Salesperson Code    ;Code20        ;TableRelation=Salesperson/Purchaser;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=S�lgerkode;
                                                              ENU=Salesperson Code] }
    { 27  ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("User ID");
                                                            END;

                                                   TestTableRelation=No;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 28  ;   ;Source Code         ;Code10        ;TableRelation="Source Code";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kildespor;
                                                              ENU=Source Code] }
    { 33  ;   ;On Hold             ;Code3         ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Afvent;
                                                              ENU=On Hold] }
    { 34  ;   ;Applies-to Doc. Type;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Udligningsbilagstype;
                                                              ENU=Applies-to Doc. Type];
                                                   OptionCaptionML=[DAN=" ,Betaling,Faktura,Kreditnota,Rentenota,Rykker,Refusion";
                                                                    ENU=" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund"];
                                                   OptionString=[ ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund] }
    { 35  ;   ;Applies-to Doc. No. ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Udligningsbilagsnr.;
                                                              ENU=Applies-to Doc. No.] }
    { 36  ;   ;Open                ;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=�ben;
                                                              ENU=Open] }
    { 37  ;   ;Due Date            ;Date          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Forfaldsdato;
                                                              ENU=Due Date] }
    { 38  ;   ;Pmt. Discount Date  ;Date          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kont.rabatdato;
                                                              ENU=Pmt. Discount Date] }
    { 39  ;   ;Original Pmt. Disc. Possible;Decimal;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Oprindelig mulig kont.rabat;
                                                              ENU=Original Pmt. Disc. Possible];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 40  ;   ;Pmt. Disc. Given (LCY);Decimal     ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Ydet kont.rabat (RV);
                                                              ENU=Pmt. Disc. Given (LCY)];
                                                   AutoFormatType=1 }
    { 43  ;   ;Positive            ;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Positiv;
                                                              ENU=Positive] }
    { 44  ;   ;Closed by Entry No. ;Integer       ;TableRelation="Cust. Ledger Entry";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Lukket af l�benr.;
                                                              ENU=Closed by Entry No.] }
    { 45  ;   ;Closed at Date      ;Date          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Lukket den;
                                                              ENU=Closed at Date] }
    { 46  ;   ;Closed by Amount    ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Lukket med bel�b;
                                                              ENU=Closed by Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 47  ;   ;Applies-to ID       ;Code50        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Udlignings-id;
                                                              ENU=Applies-to ID] }
    { 49  ;   ;Journal Batch Name  ;Code10        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kladdenavn;
                                                              ENU=Journal Batch Name] }
    { 50  ;   ;Reason Code         ;Code10        ;TableRelation="Reason Code";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=�rsagskode;
                                                              ENU=Reason Code] }
    { 51  ;   ;Bal. Account Type   ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Modkontotype;
                                                              ENU=Bal. Account Type];
                                                   OptionCaptionML=[DAN=Finanskonto,Debitor,Kreditor,Bankkonto,Anl�g;
                                                                    ENU=G/L Account,Customer,Vendor,Bank Account,Fixed Asset];
                                                   OptionString=G/L Account,Customer,Vendor,Bank Account,Fixed Asset }
    { 52  ;   ;Bal. Account No.    ;Code20        ;TableRelation=IF (Bal. Account Type=CONST(G/L Account)) "G/L Account"
                                                                 ELSE IF (Bal. Account Type=CONST(Customer)) Customer
                                                                 ELSE IF (Bal. Account Type=CONST(Vendor)) Vendor
                                                                 ELSE IF (Bal. Account Type=CONST(Bank Account)) "Bank Account"
                                                                 ELSE IF (Bal. Account Type=CONST(Fixed Asset)) "Fixed Asset";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Modkonto;
                                                              ENU=Bal. Account No.] }
    { 53  ;   ;Transaction No.     ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Transaktionsnr.;
                                                              ENU=Transaction No.] }
    { 54  ;   ;Closed by Amount (LCY);Decimal     ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Lukket med bel�b (RV);
                                                              ENU=Closed by Amount (LCY)];
                                                   AutoFormatType=1 }
    { 58  ;   ;Debit Amount        ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Debetbel�b;
                                                              ENU=Debit Amount];
                                                   BlankZero=Yes;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 59  ;   ;Credit Amount       ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kreditbel�b;
                                                              ENU=Credit Amount];
                                                   BlankZero=Yes;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 60  ;   ;Debit Amount (LCY)  ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Debetbel�b (RV);
                                                              ENU=Debit Amount (LCY)];
                                                   BlankZero=Yes;
                                                   AutoFormatType=1 }
    { 61  ;   ;Credit Amount (LCY) ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kreditbel�b (RV);
                                                              ENU=Credit Amount (LCY)];
                                                   BlankZero=Yes;
                                                   AutoFormatType=1 }
    { 62  ;   ;Document Date       ;Date          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bilagsdato;
                                                              ENU=Document Date] }
    { 63  ;   ;External Document No.;Code35       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Eksternt bilagsnr.;
                                                              ENU=External Document No.] }
    { 64  ;   ;Calculate Interest  ;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Beregn rente;
                                                              ENU=Calculate Interest] }
    { 65  ;   ;Closing Interest Calculated;Boolean;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Beregnet Lukkerente;
                                                              ENU=Closing Interest Calculated] }
    { 66  ;   ;No. Series          ;Code20        ;TableRelation="No. Series";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Nummerserie;
                                                              ENU=No. Series] }
    { 67  ;   ;Closed by Currency Code;Code10     ;TableRelation=Currency;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Lukket med valutakode;
                                                              ENU=Closed by Currency Code] }
    { 68  ;   ;Closed by Currency Amount;Decimal  ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Lukket med valutabel�b;
                                                              ENU=Closed by Currency Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Closed by Currency Code" }
    { 70  ;   ;Rounding Currency   ;Code10        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Afrundingsvaluta;
                                                              ENU=Rounding Currency] }
    { 71  ;   ;Rounding Amount     ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Afrundingsbel�b;
                                                              ENU=Rounding Amount];
                                                   AutoFormatType=1 }
    { 72  ;   ;Rounding Amount (LCY);Decimal      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Afrundingsbel�b (RV);
                                                              ENU=Rounding Amount (LCY)];
                                                   AutoFormatType=1 }
    { 73  ;   ;Adjusted Currency Factor;Decimal   ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Reguleret valutafaktor;
                                                              ENU=Adjusted Currency Factor];
                                                   AutoFormatType=1 }
    { 74  ;   ;Original Currency Factor;Decimal   ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Oprindelig valutafaktor;
                                                              ENU=Original Currency Factor];
                                                   AutoFormatType=1 }
    { 75  ;   ;Original Amount     ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Oprindeligt bel�b;
                                                              ENU=Original Amount];
                                                   AutoFormatType=1 }
    { 77  ;   ;Remaining Pmt. Disc. Possible;Decimal;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Mulig restkontantrabat;
                                                              ENU=Remaining Pmt. Disc. Possible];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 78  ;   ;Pmt. Disc. Tolerance Date;Date     ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kontantrabattolerancedato;
                                                              ENU=Pmt. Disc. Tolerance Date] }
    { 79  ;   ;Max. Payment Tolerance;Decimal     ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Maks. betalingstolerance;
                                                              ENU=Max. Payment Tolerance] }
    { 81  ;   ;Accepted Payment Tolerance;Decimal ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Godkendt betalingstolerance;
                                                              ENU=Accepted Payment Tolerance] }
    { 82  ;   ;Accepted Pmt. Disc. Tolerance;Boolean;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Godkendt kont.rabattolerance;
                                                              ENU=Accepted Pmt. Disc. Tolerance] }
    { 83  ;   ;Pmt. Tolerance (LCY);Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Betalingstolerance (RV);
                                                              ENU=Pmt. Tolerance (LCY)] }
    { 84  ;   ;Amount to Apply     ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bel�b, der skal udlignes;
                                                              ENU=Amount to Apply];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 90  ;   ;Prepayment          ;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Forudbetaling;
                                                              ENU=Prepayment] }
    { 480 ;   ;Dimension Set ID    ;Integer       ;TableRelation="Dimension Set Entry";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dimensionsgruppe-id;
                                                              ENU=Dimension Set ID];
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
    PROCEDURE CopyFromCustLedgEntry@1(CustLedgEntry@1001 : Record 21);
    BEGIN
      TRANSFERFIELDS(CustLedgEntry);
      Amount := CustLedgEntry.Amount;
      "Amount (LCY)" := CustLedgEntry."Amount (LCY)";
      "Remaining Amount" := CustLedgEntry."Remaining Amount";
      "Remaining Amt. (LCY)" := CustLedgEntry."Remaining Amt. (LCY)";
      "Original Amount" := CustLedgEntry."Original Amount";
      "Original Amt. (LCY)" := CustLedgEntry."Original Amt. (LCY)";

      OnAfterCopyFromCustLedgerEntry(Rec,CustLedgEntry);
    END;

    [External]
    PROCEDURE CopyFromVendLedgEntry@4(VendLedgEntry@1000 : Record 25);
    BEGIN
      "Entry No." := VendLedgEntry."Entry No.";
      "CV No." := VendLedgEntry."Vendor No.";
      "Posting Date" := VendLedgEntry."Posting Date";
      "Document Type" := VendLedgEntry."Document Type";
      "Document No." := VendLedgEntry."Document No.";
      Description := VendLedgEntry.Description;
      "Currency Code" := VendLedgEntry."Currency Code";
      Amount := VendLedgEntry.Amount;
      "Remaining Amount" := VendLedgEntry."Remaining Amount";
      "Original Amount" := VendLedgEntry."Original Amount";
      "Original Amt. (LCY)" := VendLedgEntry."Original Amt. (LCY)";
      "Remaining Amt. (LCY)" := VendLedgEntry."Remaining Amt. (LCY)";
      "Amount (LCY)" := VendLedgEntry."Amount (LCY)";
      "Sales/Purchase (LCY)" := VendLedgEntry."Purchase (LCY)";
      "Inv. Discount (LCY)" := VendLedgEntry."Inv. Discount (LCY)";
      "Bill-to/Pay-to CV No." := VendLedgEntry."Buy-from Vendor No.";
      "CV Posting Group" := VendLedgEntry."Vendor Posting Group";
      "Global Dimension 1 Code" := VendLedgEntry."Global Dimension 1 Code";
      "Global Dimension 2 Code" := VendLedgEntry."Global Dimension 2 Code";
      "Dimension Set ID" := VendLedgEntry."Dimension Set ID";
      "Salesperson Code" := VendLedgEntry."Purchaser Code";
      "User ID" := VendLedgEntry."User ID";
      "Source Code" := VendLedgEntry."Source Code";
      "On Hold" := VendLedgEntry."On Hold";
      "Applies-to Doc. Type" := VendLedgEntry."Applies-to Doc. Type";
      "Applies-to Doc. No." := VendLedgEntry."Applies-to Doc. No.";
      Open := VendLedgEntry.Open;
      "Due Date" := VendLedgEntry."Due Date" ;
      "Pmt. Discount Date" := VendLedgEntry."Pmt. Discount Date";
      "Original Pmt. Disc. Possible" := VendLedgEntry."Original Pmt. Disc. Possible";
      "Remaining Pmt. Disc. Possible" := VendLedgEntry."Remaining Pmt. Disc. Possible";
      "Pmt. Disc. Given (LCY)" := VendLedgEntry."Pmt. Disc. Rcd.(LCY)";
      Positive := VendLedgEntry.Positive;
      "Closed by Entry No." := VendLedgEntry."Closed by Entry No.";
      "Closed at Date" := VendLedgEntry."Closed at Date";
      "Closed by Amount" := VendLedgEntry."Closed by Amount";
      "Applies-to ID" := VendLedgEntry."Applies-to ID";
      "Journal Batch Name" := VendLedgEntry."Journal Batch Name";
      "Reason Code" := VendLedgEntry."Reason Code";
      "Bal. Account Type" := VendLedgEntry."Bal. Account Type";
      "Bal. Account No." := VendLedgEntry."Bal. Account No.";
      "Transaction No." := VendLedgEntry."Transaction No.";
      "Closed by Amount (LCY)" := VendLedgEntry."Closed by Amount (LCY)";
      "Debit Amount" := VendLedgEntry."Debit Amount";
      "Credit Amount" := VendLedgEntry."Credit Amount";
      "Debit Amount (LCY)" := VendLedgEntry."Debit Amount (LCY)";
      "Credit Amount (LCY)" := VendLedgEntry."Credit Amount (LCY)";
      "Document Date" := VendLedgEntry."Document Date";
      "External Document No." := VendLedgEntry."External Document No.";
      "No. Series" := VendLedgEntry."No. Series";
      "Closed by Currency Code" := VendLedgEntry."Closed by Currency Code";
      "Closed by Currency Amount" := VendLedgEntry."Closed by Currency Amount";
      "Adjusted Currency Factor" := VendLedgEntry."Adjusted Currency Factor";
      "Original Currency Factor" := VendLedgEntry."Original Currency Factor";
      "Pmt. Disc. Tolerance Date" := VendLedgEntry."Pmt. Disc. Tolerance Date";
      "Max. Payment Tolerance" := VendLedgEntry."Max. Payment Tolerance";
      "Accepted Payment Tolerance" := VendLedgEntry."Accepted Payment Tolerance";
      "Accepted Pmt. Disc. Tolerance" := VendLedgEntry."Accepted Pmt. Disc. Tolerance";
      "Amount to Apply" := VendLedgEntry."Amount to Apply";
      Prepayment := VendLedgEntry.Prepayment;

      OnAfterCopyFromVendLedgerEntry(Rec,VendLedgEntry);
    END;

    [External]
    PROCEDURE CopyFromEmplLedgEntry@2(EmplLedgEntry@1000 : Record 5222);
    BEGIN
      "Entry No." := EmplLedgEntry."Entry No.";
      "CV No." := EmplLedgEntry."Employee No.";
      "Posting Date" := EmplLedgEntry."Posting Date";
      "Document Type" := EmplLedgEntry."Document Type";
      "Document No." := EmplLedgEntry."Document No.";
      Description := EmplLedgEntry.Description;
      "Currency Code" := EmplLedgEntry."Currency Code";
      Amount := EmplLedgEntry.Amount;
      "Remaining Amount" := EmplLedgEntry."Remaining Amount";
      "Original Amount" := EmplLedgEntry."Original Amount";
      "Original Amt. (LCY)" := EmplLedgEntry."Original Amt. (LCY)";
      "Remaining Amt. (LCY)" := EmplLedgEntry."Remaining Amt. (LCY)";
      "Amount (LCY)" := EmplLedgEntry."Amount (LCY)";
      "CV Posting Group" := EmplLedgEntry."Employee Posting Group";
      "Global Dimension 1 Code" := EmplLedgEntry."Global Dimension 1 Code";
      "Global Dimension 2 Code" := EmplLedgEntry."Global Dimension 2 Code";
      "Dimension Set ID" := EmplLedgEntry."Dimension Set ID";
      "Salesperson Code" := EmplLedgEntry."Salespers./Purch. Code";
      "User ID" := EmplLedgEntry."User ID";
      "Applies-to Doc. Type" := EmplLedgEntry."Applies-to Doc. Type";
      "Applies-to Doc. No." := EmplLedgEntry."Applies-to Doc. No.";
      Open := EmplLedgEntry.Open;
      Positive := EmplLedgEntry.Positive;
      "Closed by Entry No." := EmplLedgEntry."Closed by Entry No.";
      "Closed at Date" := EmplLedgEntry."Closed at Date";
      "Closed by Amount" := EmplLedgEntry."Closed by Amount";
      "Applies-to ID" := EmplLedgEntry."Applies-to ID";
      "Journal Batch Name" := EmplLedgEntry."Journal Batch Name";
      "Bal. Account Type" := EmplLedgEntry."Bal. Account Type";
      "Bal. Account No." := EmplLedgEntry."Bal. Account No.";
      "Transaction No." := EmplLedgEntry."Transaction No.";
      "Closed by Amount (LCY)" := EmplLedgEntry."Closed by Amount (LCY)";
      "Adjusted Currency Factor" := 1;
      "Original Currency Factor" := 1;
      "Debit Amount" := EmplLedgEntry."Debit Amount";
      "Credit Amount" := EmplLedgEntry."Credit Amount";
      "Debit Amount (LCY)" := EmplLedgEntry."Debit Amount (LCY)";
      "Credit Amount (LCY)" := EmplLedgEntry."Credit Amount (LCY)";
      "No. Series" := EmplLedgEntry."No. Series";
      "Amount to Apply" := EmplLedgEntry."Amount to Apply";

      OnAfterCopyFromEmplLedgerEntry(Rec,EmplLedgEntry);
    END;

    [Internal]
    PROCEDURE RecalculateAmounts@41(FromCurrencyCode@1002 : Code[10];ToCurrencyCode@1001 : Code[10];PostingDate@1000 : Date);
    VAR
      CurrExchRate@1004 : Record 330;
    BEGIN
      IF ToCurrencyCode = FromCurrencyCode THEN
        EXIT;

      "Remaining Amount" :=
        CurrExchRate.ExchangeAmount("Remaining Amount",FromCurrencyCode,ToCurrencyCode,PostingDate);
      "Remaining Pmt. Disc. Possible" :=
        CurrExchRate.ExchangeAmount("Remaining Pmt. Disc. Possible",FromCurrencyCode,ToCurrencyCode,PostingDate);
      "Amount to Apply" :=
        CurrExchRate.ExchangeAmount("Amount to Apply",FromCurrencyCode,ToCurrencyCode,PostingDate);
    END;

    [External]
    PROCEDURE SetClosedFields@5(EntryNo@1000 : Integer;PostingDate@1001 : Date;NewAmount@1002 : Decimal;AmountLCY@1003 : Decimal;CurrencyCode@1004 : Code[10];CurrencyAmount@1005 : Decimal);
    BEGIN
      "Closed by Entry No." := EntryNo;
      "Closed at Date" := PostingDate;
      "Closed by Amount" := NewAmount;
      "Closed by Amount (LCY)" := AmountLCY;
      "Closed by Currency Code" := CurrencyCode;
      "Closed by Currency Amount" := CurrencyAmount;
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnAfterCopyFromCustLedgerEntry@8(VAR CVLedgerEntryBuffer@1000 : Record 382;CustLedgerEntry@1001 : Record 21);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnAfterCopyFromVendLedgerEntry@9(VAR CVLedgerEntryBuffer@1000 : Record 382;VendorLedgerEntry@1001 : Record 25);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnAfterCopyFromEmplLedgerEntry@3(VAR CVLedgerEntryBuffer@1000 : Record 382;EmployeeLedgerEntry@1001 : Record 5222);
    BEGIN
    END;

    BEGIN
    END.
  }
}

