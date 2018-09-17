OBJECT Table 179 Reversal Entry
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Tilbagef›rselspost;
               ENU=Reversal Entry];
    PasteIsValid=No;
  }
  FIELDS
  {
    { 1   ;   ;Line No.            ;Integer       ;CaptionML=[DAN=Linjenr.;
                                                              ENU=Line No.] }
    { 2   ;   ;Entry Type          ;Option        ;CaptionML=[DAN=Posttype;
                                                              ENU=Entry Type];
                                                   OptionCaptionML=[DAN=" ,Finanskonto,Debitor,Kreditor,Bankkonto,Anl‘g,Reparation,Moms";
                                                                    ENU=" ,G/L Account,Customer,Vendor,Bank Account,Fixed Asset,Maintenance,VAT"];
                                                   OptionString=[ ,G/L Account,Customer,Vendor,Bank Account,Fixed Asset,Maintenance,VAT] }
    { 3   ;   ;Entry No.           ;Integer       ;TableRelation=IF (Entry Type=CONST(G/L Account)) "G/L Entry"
                                                                 ELSE IF (Entry Type=CONST(Customer)) "Cust. Ledger Entry"
                                                                 ELSE IF (Entry Type=CONST(Vendor)) "Vendor Ledger Entry"
                                                                 ELSE IF (Entry Type=CONST(Bank Account)) "Bank Account Ledger Entry"
                                                                 ELSE IF (Entry Type=CONST(Fixed Asset)) "FA Ledger Entry"
                                                                 ELSE IF (Entry Type=CONST(Maintenance)) "Maintenance Ledger Entry"
                                                                 ELSE IF (Entry Type=CONST(VAT)) "VAT Entry";
                                                   CaptionML=[DAN=L›benr.;
                                                              ENU=Entry No.] }
    { 4   ;   ;G/L Register No.    ;Integer       ;TableRelation="G/L Register";
                                                   CaptionML=[DAN=Finansjournalnr.;
                                                              ENU=G/L Register No.] }
    { 5   ;   ;Source Code         ;Code10        ;TableRelation="Source Code";
                                                   CaptionML=[DAN=Kildespor;
                                                              ENU=Source Code] }
    { 6   ;   ;Journal Batch Name  ;Code10        ;CaptionML=[DAN=Kladdenavn;
                                                              ENU=Journal Batch Name] }
    { 7   ;   ;Transaction No.     ;Integer       ;CaptionML=[DAN=Transaktionsnr.;
                                                              ENU=Transaction No.] }
    { 8   ;   ;Source Type         ;Option        ;CaptionML=[DAN=Kildetype;
                                                              ENU=Source Type];
                                                   OptionCaptionML=[DAN=" ,Debitor,Kreditor,Bankkonto,Anl‘g,IC-partner";
                                                                    ENU=" ,Customer,Vendor,Bank Account,Fixed Asset,IC Partner"];
                                                   OptionString=[ ,Customer,Vendor,Bank Account,Fixed Asset,IC Partner] }
    { 9   ;   ;Source No.          ;Code20        ;TableRelation=IF (Source Type=CONST(Customer)) Customer
                                                                 ELSE IF (Source Type=CONST(Vendor)) Vendor
                                                                 ELSE IF (Source Type=CONST(Bank Account)) "Bank Account"
                                                                 ELSE IF (Source Type=CONST(Fixed Asset)) "Fixed Asset";
                                                   CaptionML=[DAN=Kildenr.;
                                                              ENU=Source No.] }
    { 10  ;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   CaptionML=[DAN=Valutakode;
                                                              ENU=Currency Code] }
    { 11  ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 12  ;   ;Amount              ;Decimal       ;CaptionML=[DAN=Bel›b;
                                                              ENU=Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 13  ;   ;Debit Amount        ;Decimal       ;CaptionML=[DAN=Debetbel›b;
                                                              ENU=Debit Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 14  ;   ;Credit Amount       ;Decimal       ;CaptionML=[DAN=Kreditbel›b;
                                                              ENU=Credit Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 15  ;   ;Amount (LCY)        ;Decimal       ;CaptionML=[DAN=Bel›b (RV);
                                                              ENU=Amount (LCY)];
                                                   AutoFormatType=1 }
    { 16  ;   ;Debit Amount (LCY)  ;Decimal       ;CaptionML=[DAN=Debetbel›b (RV);
                                                              ENU=Debit Amount (LCY)];
                                                   AutoFormatType=1 }
    { 17  ;   ;Credit Amount (LCY) ;Decimal       ;CaptionML=[DAN=Kreditbel›b (RV);
                                                              ENU=Credit Amount (LCY)];
                                                   AutoFormatType=1 }
    { 18  ;   ;VAT Amount          ;Decimal       ;CaptionML=[DAN=Momsbel›b;
                                                              ENU=VAT Amount];
                                                   AutoFormatType=1 }
    { 19  ;   ;Posting Date        ;Date          ;CaptionML=[DAN=Bogf›ringsdato;
                                                              ENU=Posting Date] }
    { 20  ;   ;Document Type       ;Option        ;CaptionML=[DAN=Bilagstype;
                                                              ENU=Document Type];
                                                   OptionCaptionML=[DAN=" ,Betaling,Faktura,Kreditnota,Rentenota,Rykker,Refusion";
                                                                    ENU=" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund"];
                                                   OptionString=[ ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund] }
    { 21  ;   ;Document No.        ;Code20        ;CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.] }
    { 22  ;   ;Account No.         ;Code20        ;CaptionML=[DAN=Kontonr.;
                                                              ENU=Account No.] }
    { 23  ;   ;Account Name        ;Text50        ;CaptionML=[DAN=Kontonavn;
                                                              ENU=Account Name] }
    { 25  ;   ;Bal. Account Type   ;Option        ;CaptionML=[DAN=Modkontotype;
                                                              ENU=Bal. Account Type];
                                                   OptionCaptionML=[DAN=Finanskonto,Debitor,Kreditor,Bankkonto,Anl‘g,IC-partner;
                                                                    ENU=G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner];
                                                   OptionString=G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner }
    { 26  ;   ;Bal. Account No.    ;Code20        ;TableRelation=IF (Bal. Account Type=CONST(G/L Account)) "G/L Account"
                                                                 ELSE IF (Bal. Account Type=CONST(Customer)) Customer
                                                                 ELSE IF (Bal. Account Type=CONST(Vendor)) Vendor
                                                                 ELSE IF (Bal. Account Type=CONST(Bank Account)) "Bank Account"
                                                                 ELSE IF (Bal. Account Type=CONST(Fixed Asset)) "Fixed Asset";
                                                   CaptionML=[DAN=Modkonto;
                                                              ENU=Bal. Account No.] }
    { 27  ;   ;FA Posting Category ;Option        ;AccessByPermission=TableData 5600=R;
                                                   CaptionML=[DAN=Anl‘gsbogf›ringskategori;
                                                              ENU=FA Posting Category];
                                                   OptionCaptionML=[DAN=" ,Salg,Modpost salg";
                                                                    ENU=" ,Disposal,Bal. Disposal"];
                                                   OptionString=[ ,Disposal,Bal. Disposal] }
    { 28  ;   ;FA Posting Type     ;Option        ;AccessByPermission=TableData 5600=R;
                                                   CaptionML=[DAN=Anl‘gsbogf›ringstype;
                                                              ENU=FA Posting Type];
                                                   OptionCaptionML=[DAN=" ,Anskaffelse,Afskrivning,Nedskrivning,Opskrivning,Bruger 1,Bruger 2,Salg,Scrapv‘rdi,Tab/Vinding,Bogf›rt v‘rdi ved salg";
                                                                    ENU=" ,Acquisition Cost,Depreciation,Write-Down,Appreciation,Custom 1,Custom 2,Proceeds on Disposal,Salvage Value,Gain/Loss,Book Value on Disposal"];
                                                   OptionString=[ ,Acquisition Cost,Depreciation,Write-Down,Appreciation,Custom 1,Custom 2,Proceeds on Disposal,Salvage Value,Gain/Loss,Book Value on Disposal] }
    { 30  ;   ;Reversal Type       ;Option        ;CaptionML=[DAN=Tilbagef›rselstype;
                                                              ENU=Reversal Type];
                                                   OptionCaptionML=[DAN=Transaktion,Journal;
                                                                    ENU=Transaction,Register];
                                                   OptionString=Transaction,Register }
  }
  KEYS
  {
    {    ;Line No.                                ;Clustered=Yes }
    {    ;Entry Type                               }
    {    ;Document No.,Posting Date,Entry Type,Entry No. }
    {    ;Entry Type,Entry No.                     }
    {    ;Transaction No.                          }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      GLSetup@1000 : Record 98;
      TempReversalEntry@1001 : TEMPORARY Record 179;
      GLEntry@1007 : Record 17;
      CustLedgEntry@1006 : Record 21;
      VendLedgEntry@1005 : Record 25;
      BankAccLedgEntry@1004 : Record 271;
      VATEntry@1003 : Record 254;
      FALedgEntry@1002 : Record 5601;
      MaintenanceLedgEntry@1009 : Record 5625;
      GLReg@1008 : Record 45;
      Text000@1010 : TextConst 'DAN=Du kan ikke tilbagef›re %1 nr. %2, fordi posten enten er udlignet med en anden post eller er ‘ndret under en k›rsel.;ENU=You cannot reverse %1 No. %2 because the entry is either applied to an entry or has been changed by a batch job.';
      FAReg@1015 : Record 5617;
      GenJnlCheckLine@1011 : Codeunit 11;
      Text001@1012 : TextConst 'DAN=Du kan ikke tilbagef›re %1 nr. %2, fordi bogf›ringsdatoen ikke er inden for den tilladte bogf›ringsperiode.;ENU=You cannot reverse %1 No. %2 because the posting date is not within the allowed posting period.';
      AllowPostingFrom@1014 : Date;
      AllowPostingto@1013 : Date;
      Text002@1016 : TextConst 'DAN=Du kan ikke tilbagef›re transaktionen, fordi den ikke stemmer.;ENU=You cannot reverse the transaction because it is out of balance.';
      Text003@1017 : TextConst 'DAN=Du kan ikke tilbagef›re %1 nr. %2, fordi posten har en relateret checkpost.;ENU=You cannot reverse %1 No. %2 because the entry has a related check ledger entry.';
      Text004@1018 : TextConst 'DAN=Du kan kun tilbagef›re poster, der er bogf›rt fra en kladde.;ENU=You can only reverse entries that were posted from a journal.';
      Text005@1020 : TextConst 'DAN=Du kan ikke tilbagef›re %1 nr. %2, fordi %3 ikke er inden for den tilladte bogf›ringsperiode.;ENU=You cannot reverse %1 No. %2 because the %3 is not within the allowed posting period.';
      Text006@1022 : TextConst 'DAN=Du kan ikke tilbagef›re %1 nr. %2, fordi posten er lukket.;ENU=You cannot reverse %1 No. %2 because the entry is closed.';
      Text007@1021 : TextConst 'DAN=Du kan ikke tilbagef›re %1 nr. %2, fordi posten findes p† en bankkontos afstemningslinje. Bankafstemningen er endnu ikke bogf›rt.;ENU=You cannot reverse %1 No. %2 because the entry is included in a bank account reconciliation line. The bank reconciliation has not yet been posted.';
      Text008@1019 : TextConst 'DAN=Du kan ikke tilbagef›re transaktionen, fordi %1 er blevet solgt.;ENU=You cannot reverse the transaction because the %1 has been sold.';
      MaxPostingDate@1024 : Date;
      Text009@1025 : TextConst 'DAN=Transaktionen kan ikke tilbagef›res, fordi %1 er blevet komprimeret, eller fordi %2 er blevet slettet.;ENU=The transaction cannot be reversed, because the %1 has been compressed or a %2 has been deleted.';
      Text010@1023 : TextConst 'DAN=Du kan ikke tilbagef›re %1 nr. %2, fordi journalen allerede har v‘ret involveret i en tilbagef›rsel.;ENU=You cannot reverse %1 No. %2 because the register has already been involved in a reversal.';
      Text011@1026 : TextConst 'DAN=Du kan ikke tilbagef›re %1 nr. %2, fordi posten allerede har v‘ret involveret i en tilbagef›rsel.;ENU=You cannot reverse %1 No. %2 because the entry has already been involved in a reversal.';
      Text012@1028 : TextConst 'DAN=Du kan ikke fortryde registernr. %1, fordi det indeholder poster for kunder eller leverand›rer, som allerede er bogf›rt og anvendt i samme transaktion.\\Du skal fortryde hver transaktion i registernr. %1 separat.;ENU=You cannot reverse register No. %1 because it contains customer or vendor ledger entries that have been posted and applied in the same transaction.\\You must reverse each transaction in register No. %1 separately.';
      Text013@1039 : TextConst 'DAN=Du kan ikke tilbagef›re %1 nr. %2, fordi posten har en tilknyttet realiseret gevinst-/tabspost.;ENU=You cannot reverse %1 No. %2 because the entry has an associated Realized Gain/Loss entry.';
      HideDialog@1030 : Boolean;
      UnrealizedVATReverseErr@1027 : TextConst 'DAN=Du kan ikke tilbagef›re %1 nr. %2, fordi posten har et tilknyttet urealiseret momsl›benr.;ENU=You cannot reverse %1 No. %2 because the entry has an associated Unrealized VAT Entry.';
      HideWarningDialogs@1029 : Boolean;

    [External]
    PROCEDURE ReverseTransaction@8(TransactionNo@1000 : Integer);
    BEGIN
      ReverseEntries(TransactionNo,"Reversal Type"::Transaction);
    END;

    [External]
    PROCEDURE ReverseRegister@9(RegisterNo@1000 : Integer);
    VAR
      GLReg@1001 : Record 45;
    BEGIN
      GLReg.GET(RegisterNo);
      IF GLReg.Reversed THEN
        ERROR(Text010,GLReg.TABLECAPTION,GLReg."No.");
      IF GLReg."Journal Batch Name" = '' THEN
        TempReversalEntry.TestFieldError;

      ReverseEntries(RegisterNo,"Reversal Type"::Register);
    END;

    LOCAL PROCEDURE ReverseEntries@32(Number@1001 : Integer;RevType@1000 : 'Transaction,Register');
    VAR
      ReversalPost@1002 : Codeunit 179;
    BEGIN
      InsertReversalEntry(Number,RevType);
      TempReversalEntry.SETCURRENTKEY("Document No.","Posting Date","Entry Type","Entry No.");
      IF NOT HideDialog THEN
        PAGE.RUNMODAL(PAGE::"Reverse Entries",TempReversalEntry)
      ELSE BEGIN
        ReversalPost.SetPrint(FALSE);
        ReversalPost.SetHideDialog(HideWarningDialogs);
        ReversalPost.RUN(TempReversalEntry);
      END;
      TempReversalEntry.DELETEALL;
    END;

    LOCAL PROCEDURE InsertReversalEntry@7(Number@1000 : Integer;RevType@1007 : 'Transaction,Register');
    VAR
      TempRevertTransactionNo@1005 : TEMPORARY Record 2000000026;
      NextLineNo@1008 : Integer;
    BEGIN
      GLSetup.GET;
      TempReversalEntry.DELETEALL;
      NextLineNo := 1;
      TempRevertTransactionNo.Number := Number;
      TempRevertTransactionNo.INSERT;
      SetReverseFilter(Number,RevType);

      InsertFromCustLedgEntry(TempRevertTransactionNo,Number,RevType,NextLineNo);
      InsertFromVendLedgEntry(TempRevertTransactionNo,Number,RevType,NextLineNo);
      InsertFromBankAccLedgEntry(Number,RevType,NextLineNo);
      InsertFromFALedgEntry(Number,RevType,NextLineNo);
      InsertFromMaintenanceLedgEntry(Number,RevType,NextLineNo);
      InsertFromVATEntry(TempRevertTransactionNo,Number,RevType,NextLineNo);
      InsertFromGLEntry(TempRevertTransactionNo,Number,RevType,NextLineNo);
      IF TempReversalEntry.FIND('-') THEN;
    END;

    [External]
    PROCEDURE CheckEntries@14();
    VAR
      GLAcc@1001 : Record 15;
      DtldCustLedgEntry@1006 : Record 379;
      DtldVendLedgEntry@1007 : Record 380;
      DateComprReg@1000 : Record 87;
      BalanceCheckAmount@1012 : Decimal;
      BalanceCheckAddCurrAmount@1010 : Decimal;
    BEGIN
      DtldCustLedgEntry.LOCKTABLE;
      DtldVendLedgEntry.LOCKTABLE;
      GLEntry.LOCKTABLE;
      CustLedgEntry.LOCKTABLE;
      VendLedgEntry.LOCKTABLE;
      BankAccLedgEntry.LOCKTABLE;
      FALedgEntry.LOCKTABLE;
      MaintenanceLedgEntry.LOCKTABLE;
      VATEntry.LOCKTABLE;
      GLReg.LOCKTABLE;
      FAReg.LOCKTABLE;
      GLSetup.GET;
      MaxPostingDate := 0D;
      IF NOT GLEntry.FIND('-') THEN
        ERROR(Text009,GLEntry.TABLECAPTION,GLAcc.TABLECAPTION);
      IF GLEntry.FIND('-') THEN BEGIN
        IF GLEntry."Journal Batch Name" = '' THEN
          TestFieldError;
        REPEAT
          CheckGLAcc(GLEntry,BalanceCheckAmount,BalanceCheckAddCurrAmount);
        UNTIL GLEntry.NEXT = 0;
      END;
      IF (BalanceCheckAmount <> 0) OR (BalanceCheckAddCurrAmount <> 0) THEN
        ERROR(Text002);

      IF CustLedgEntry.FIND('-') THEN
        REPEAT
          CheckCust(CustLedgEntry);
        UNTIL CustLedgEntry.NEXT = 0;

      IF VendLedgEntry.FIND('-') THEN
        REPEAT
          CheckVend(VendLedgEntry);
        UNTIL VendLedgEntry.NEXT = 0;

      IF BankAccLedgEntry.FIND('-') THEN
        REPEAT
          CheckBankAcc(BankAccLedgEntry);
        UNTIL BankAccLedgEntry.NEXT = 0;

      IF FALedgEntry.FIND('-') THEN
        REPEAT
          CheckFA(FALedgEntry);
        UNTIL FALedgEntry.NEXT = 0;

      IF MaintenanceLedgEntry.FIND('-') THEN
        REPEAT
          CheckMaintenance(MaintenanceLedgEntry);
        UNTIL MaintenanceLedgEntry.NEXT = 0;

      IF VATEntry.FIND('-') THEN
        REPEAT
          CheckVAT(VATEntry);
        UNTIL VATEntry.NEXT = 0;
      DateComprReg.CheckMaxDateCompressed(MaxPostingDate,1);
    END;

    LOCAL PROCEDURE CheckGLAcc@13(GLEntry@1000 : Record 17;VAR BalanceCheckAmount@1002 : Decimal;VAR BalanceCheckAddCurrAmount@1001 : Decimal);
    VAR
      GLAcc@1003 : Record 15;
    BEGIN
      GLAcc.GET(GLEntry."G/L Account No.");
      CheckPostingDate(GLEntry."Posting Date",GLEntry.TABLECAPTION,GLEntry."Entry No.");
      GLAcc.TESTFIELD(Blocked,FALSE);
      GLEntry.TESTFIELD("Job No.",'');
      IF GLEntry.Reversed THEN
        AlreadyReversedEntry(GLEntry.TABLECAPTION,GLEntry."Entry No.");
      BalanceCheckAmount := BalanceCheckAmount + GLEntry.Amount;
      IF GLSetup."Additional Reporting Currency" <> '' THEN
        BalanceCheckAddCurrAmount := BalanceCheckAddCurrAmount + GLEntry."Additional-Currency Amount";
    END;

    LOCAL PROCEDURE CheckCust@16(CustLedgEntry@1001 : Record 21);
    VAR
      Cust@1000 : Record 18;
    BEGIN
      Cust.GET(CustLedgEntry."Customer No.");
      CheckPostingDate(
        CustLedgEntry."Posting Date",CustLedgEntry.TABLECAPTION,CustLedgEntry."Entry No.");
      Cust.CheckBlockedCustOnJnls(Cust,CustLedgEntry."Document Type",FALSE);
      IF CustLedgEntry.Reversed THEN
        AlreadyReversedEntry(CustLedgEntry.TABLECAPTION,CustLedgEntry."Entry No.");
      CheckDtldCustLedgEntry(CustLedgEntry);
    END;

    LOCAL PROCEDURE CheckVend@17(VendLedgEntry@1001 : Record 25);
    VAR
      Vend@1000 : Record 23;
    BEGIN
      Vend.GET(VendLedgEntry."Vendor No.");
      CheckPostingDate(
        VendLedgEntry."Posting Date",VendLedgEntry.TABLECAPTION,VendLedgEntry."Entry No.");
      Vend.CheckBlockedVendOnJnls(Vend,VendLedgEntry."Document Type",FALSE);
      IF VendLedgEntry.Reversed THEN
        AlreadyReversedEntry(VendLedgEntry.TABLECAPTION,VendLedgEntry."Entry No.");
      CheckDtldVendLedgEntry(VendLedgEntry);
    END;

    LOCAL PROCEDURE CheckBankAcc@18(BankAccLedgEntry@1000 : Record 271);
    VAR
      BankAcc@1001 : Record 270;
      CheckLedgEntry@1002 : Record 272;
    BEGIN
      BankAcc.GET(BankAccLedgEntry."Bank Account No.");
      CheckPostingDate(
        BankAccLedgEntry."Posting Date",BankAccLedgEntry.TABLECAPTION,BankAccLedgEntry."Entry No.");
      BankAcc.TESTFIELD(Blocked,FALSE);
      IF BankAccLedgEntry.Reversed THEN
        AlreadyReversedEntry(BankAccLedgEntry.TABLECAPTION,BankAccLedgEntry."Entry No.");
      IF NOT BankAccLedgEntry.Open THEN
        ERROR(
          Text006,BankAccLedgEntry.TABLECAPTION,BankAccLedgEntry."Entry No.");
      IF BankAccLedgEntry."Statement No." <> '' THEN
        ERROR(
          Text007,BankAccLedgEntry.TABLECAPTION,BankAccLedgEntry."Entry No.");
      CheckLedgEntry.SETRANGE("Bank Account Ledger Entry No.",BankAccLedgEntry."Entry No.");
      IF NOT CheckLedgEntry.ISEMPTY THEN
        ERROR(
          Text003,BankAccLedgEntry.TABLECAPTION,BankAccLedgEntry."Entry No.");
    END;

    LOCAL PROCEDURE CheckFA@19(FALedgEntry@1000 : Record 5601);
    VAR
      FA@1001 : Record 5600;
      FADeprBook@1002 : Record 5612;
      DeprCalc@1003 : Codeunit 5616;
    BEGIN
      FA.GET(FALedgEntry."FA No.");
      CheckPostingDate(
        FALedgEntry."Posting Date",FALedgEntry.TABLECAPTION,FALedgEntry."Entry No.");
      CheckFAPostingDate(
        FALedgEntry."FA Posting Date",FALedgEntry.TABLECAPTION,FALedgEntry."Entry No.");
      FA.TESTFIELD(Blocked,FALSE);
      FA.TESTFIELD(Inactive,FALSE);
      IF FALedgEntry.Reversed THEN
        AlreadyReversedEntry(FALedgEntry.TABLECAPTION,FALedgEntry."Entry No.");
      FALedgEntry.TESTFIELD("Depreciation Book Code");
      FADeprBook.GET(FA."No.",FALedgEntry."Depreciation Book Code");
      IF FADeprBook."Disposal Date" <> 0D THEN
        ERROR(Text008,DeprCalc.FAName(FA,FALedgEntry."Depreciation Book Code"));
      FALedgEntry.TESTFIELD("G/L Entry No.");
    END;

    LOCAL PROCEDURE CheckMaintenance@20(MaintenanceLedgEntry@1000 : Record 5625);
    VAR
      FA@1001 : Record 5600;
      FADeprBook@1002 : Record 5612;
    BEGIN
      FA.GET(MaintenanceLedgEntry."FA No.");
      CheckPostingDate(
        MaintenanceLedgEntry."Posting Date",MaintenanceLedgEntry.TABLECAPTION,MaintenanceLedgEntry."Entry No.");
      CheckFAPostingDate(
        MaintenanceLedgEntry."FA Posting Date",MaintenanceLedgEntry.TABLECAPTION,MaintenanceLedgEntry."Entry No.");
      FA.TESTFIELD(Blocked,FALSE);
      FA.TESTFIELD(Inactive,FALSE);
      MaintenanceLedgEntry.TESTFIELD("Depreciation Book Code");
      IF MaintenanceLedgEntry.Reversed THEN
        AlreadyReversedEntry(MaintenanceLedgEntry.TABLECAPTION,MaintenanceLedgEntry."Entry No.");
      FADeprBook.GET(FA."No.",MaintenanceLedgEntry."Depreciation Book Code");
      MaintenanceLedgEntry.TESTFIELD("G/L Entry No.");
    END;

    LOCAL PROCEDURE CheckVAT@21(VATEntry@1000 : Record 254);
    BEGIN
      CheckPostingDate(VATEntry."Posting Date",VATEntry.TABLECAPTION,VATEntry."Entry No.");
      IF VATEntry.Closed THEN
        ERROR(
          Text006,VATEntry.TABLECAPTION,VATEntry."Entry No.");
      IF VATEntry.Reversed THEN
        AlreadyReversedEntry(VATEntry.TABLECAPTION,VATEntry."Entry No.");
      IF VATEntry."Unrealized VAT Entry No." <> 0 THEN
        ERROR(UnrealizedVATReverseError(VATEntry.TABLECAPTION,VATEntry."Entry No."));
    END;

    LOCAL PROCEDURE CheckDtldCustLedgEntry@2(CustLedgEntry@1000 : Record 21);
    VAR
      DtldCustLedgEntry@1001 : Record 379;
    BEGIN
      DtldCustLedgEntry.SETCURRENTKEY("Cust. Ledger Entry No.","Entry Type");
      DtldCustLedgEntry.SETRANGE("Cust. Ledger Entry No.",CustLedgEntry."Entry No.");
      DtldCustLedgEntry.SETFILTER("Entry Type",'<>%1',DtldCustLedgEntry."Entry Type"::"Initial Entry");
      DtldCustLedgEntry.SETRANGE(Unapplied,FALSE);
      IF NOT DtldCustLedgEntry.ISEMPTY THEN
        ERROR(ReversalErrorForChangedEntry(CustLedgEntry.TABLECAPTION,CustLedgEntry."Entry No."));

      DtldCustLedgEntry.RESET;
      DtldCustLedgEntry.SETCURRENTKEY("Transaction No.","Customer No.","Entry Type");
      DtldCustLedgEntry.SETRANGE("Transaction No.",CustLedgEntry."Transaction No.");
      DtldCustLedgEntry.SETRANGE("Customer No.",CustLedgEntry."Customer No.");
      DtldCustLedgEntry.SETFILTER("Entry Type",'%1|%2',
        DtldCustLedgEntry."Entry Type"::"Realized Gain",DtldCustLedgEntry."Entry Type"::"Realized Loss");
      IF NOT DtldCustLedgEntry.ISEMPTY THEN
        ERROR(Text013,CustLedgEntry.TABLECAPTION,CustLedgEntry."Entry No.");
    END;

    LOCAL PROCEDURE CheckDtldVendLedgEntry@28(VendLedgEntry@1000 : Record 25);
    VAR
      DtldVendLedgEntry@1001 : Record 380;
    BEGIN
      DtldVendLedgEntry.SETCURRENTKEY("Vendor Ledger Entry No.","Entry Type");
      DtldVendLedgEntry.SETRANGE("Vendor Ledger Entry No.",VendLedgEntry."Entry No.");
      DtldVendLedgEntry.SETFILTER("Entry Type",'<>%1',DtldVendLedgEntry."Entry Type"::"Initial Entry");
      DtldVendLedgEntry.SETRANGE(Unapplied,FALSE);
      IF NOT DtldVendLedgEntry.ISEMPTY THEN
        ERROR(ReversalErrorForChangedEntry(VendLedgEntry.TABLECAPTION,VendLedgEntry."Entry No."));

      DtldVendLedgEntry.RESET;
      DtldVendLedgEntry.SETCURRENTKEY("Transaction No.","Vendor No.","Entry Type");
      DtldVendLedgEntry.SETRANGE("Transaction No.",VendLedgEntry."Transaction No.");
      DtldVendLedgEntry.SETRANGE("Vendor No.",VendLedgEntry."Vendor No.");
      DtldVendLedgEntry.SETFILTER("Entry Type",'%1|%2',
        DtldVendLedgEntry."Entry Type"::"Realized Gain",DtldVendLedgEntry."Entry Type"::"Realized Loss");
      IF NOT DtldVendLedgEntry.ISEMPTY THEN
        ERROR(Text013,VendLedgEntry.TABLECAPTION,VendLedgEntry."Entry No.");
    END;

    [External]
    PROCEDURE SetReverseFilter@1(Number@1001 : Integer;RevType@1000 : 'Transaction,Register');
    BEGIN
      IF RevType = RevType::Transaction THEN BEGIN
        GLEntry.SETCURRENTKEY("Transaction No.");
        CustLedgEntry.SETCURRENTKEY("Transaction No.");
        VendLedgEntry.SETCURRENTKEY("Transaction No.");
        BankAccLedgEntry.SETCURRENTKEY("Transaction No.");
        FALedgEntry.SETCURRENTKEY("Transaction No.");
        MaintenanceLedgEntry.SETCURRENTKEY("Transaction No.");
        VATEntry.SETCURRENTKEY("Transaction No.");
        GLEntry.SETRANGE("Transaction No.",Number);
        CustLedgEntry.SETRANGE("Transaction No.",Number);
        VendLedgEntry.SETRANGE("Transaction No.",Number);
        BankAccLedgEntry.SETRANGE("Transaction No.",Number);
        FALedgEntry.SETRANGE("Transaction No.",Number);
        FALedgEntry.SETFILTER("G/L Entry No.",'<>%1',0);
        MaintenanceLedgEntry.SETRANGE("Transaction No.",Number);
        VATEntry.SETRANGE("Transaction No.",Number);
      END ELSE BEGIN
        GLReg.GET(Number);
        GLEntry.SETRANGE("Entry No.",GLReg."From Entry No.",GLReg."To Entry No.");
        CustLedgEntry.SETRANGE("Entry No.",GLReg."From Entry No.",GLReg."To Entry No.");
        VendLedgEntry.SETRANGE("Entry No.",GLReg."From Entry No.",GLReg."To Entry No.");
        BankAccLedgEntry.SETRANGE("Entry No.",GLReg."From Entry No.",GLReg."To Entry No.");
        FALedgEntry.SETCURRENTKEY("G/L Entry No.");
        FALedgEntry.SETRANGE("G/L Entry No.",GLReg."From Entry No.",GLReg."To Entry No.");
        MaintenanceLedgEntry.SETCURRENTKEY("G/L Entry No.");
        MaintenanceLedgEntry.SETRANGE("G/L Entry No.",GLReg."From Entry No.",GLReg."To Entry No.");
        VATEntry.SETRANGE("Entry No.",GLReg."From VAT Entry No.",GLReg."To VAT Entry No.");
      END;
    END;

    [External]
    PROCEDURE CopyReverseFilters@15(VAR GLEntry2@1007 : Record 17;VAR CustLedgEntry2@1006 : Record 21;VAR VendLedgEntry2@1005 : Record 25;VAR BankAccLedgEntry2@1004 : Record 271;VAR VATEntry2@1003 : Record 254;VAR FALedgEntry2@1002 : Record 5601;VAR MaintenanceLedgEntry2@1001 : Record 5625);
    BEGIN
      GLEntry2.COPY(GLEntry);
      CustLedgEntry2.COPY(CustLedgEntry);
      VendLedgEntry2.COPY(VendLedgEntry);
      BankAccLedgEntry2.COPY(BankAccLedgEntry);
      VATEntry2.COPY(VATEntry);
      FALedgEntry2.COPY(FALedgEntry);
      MaintenanceLedgEntry2.COPY(MaintenanceLedgEntry);
    END;

    [External]
    PROCEDURE ShowGLEntries@22();
    BEGIN
      PAGE.RUN(0,GLEntry);
    END;

    [External]
    PROCEDURE ShowCustLedgEntries@26();
    BEGIN
      PAGE.RUN(0,CustLedgEntry);
    END;

    [External]
    PROCEDURE ShowVendLedgEntries@5();
    BEGIN
      PAGE.RUN(0,VendLedgEntry);
    END;

    [External]
    PROCEDURE ShowBankAccLedgEntries@6();
    BEGIN
      PAGE.RUN(0,BankAccLedgEntry);
    END;

    [External]
    PROCEDURE ShowFALedgEntries@10();
    BEGIN
      PAGE.RUN(0,FALedgEntry);
    END;

    [External]
    PROCEDURE ShowMaintenanceLedgEntries@12();
    BEGIN
      PAGE.RUN(0,MaintenanceLedgEntry);
    END;

    [External]
    PROCEDURE ShowVATEntries@11();
    BEGIN
      PAGE.RUN(0,VATEntry);
    END;

    [External]
    PROCEDURE Caption@3() : Text[250];
    VAR
      GLAcc@1000 : Record 15;
      GLEntry@1002 : Record 17;
      Cust@1001 : Record 18;
      CustLedgEntry@1003 : Record 21;
      Vend@1004 : Record 23;
      VendLedgEntry@1005 : Record 25;
      BankAcc@1006 : Record 270;
      BankAccLedgEntry@1007 : Record 271;
      FA@1008 : Record 5600;
      FALedgEntry@1009 : Record 5601;
      MaintenanceLedgEntry@1011 : Record 5625;
      VATEntry@1010 : Record 254;
    BEGIN
      IF "Entry Type" = "Entry Type"::"G/L Account" THEN BEGIN
        IF GLEntry.GET("Entry No.") THEN;
        IF GLAcc.GET(GLEntry."G/L Account No.") THEN;
        EXIT(STRSUBSTNO('%1 %2 %3',GLAcc.TABLECAPTION,GLAcc."No.",GLAcc.Name));
      END;
      IF "Entry Type" = "Entry Type"::Customer THEN BEGIN
        IF CustLedgEntry.GET("Entry No.") THEN;
        IF Cust.GET(CustLedgEntry."Customer No.") THEN;
        EXIT(STRSUBSTNO('%1 %2 %3',Cust.TABLECAPTION,Cust."No.",Cust.Name));
      END;
      IF "Entry Type" = "Entry Type"::Vendor THEN BEGIN
        IF VendLedgEntry.GET("Entry No.") THEN;
        IF Vend.GET(VendLedgEntry."Vendor No.") THEN;
        EXIT(STRSUBSTNO('%1 %2 %3',Vend.TABLECAPTION,Vend."No.",Vend.Name));
      END;
      IF "Entry Type" = "Entry Type"::"Bank Account" THEN BEGIN
        IF BankAccLedgEntry.GET("Entry No.") THEN;
        IF BankAcc.GET(BankAccLedgEntry."Bank Account No.") THEN;
        EXIT(STRSUBSTNO('%1 %2 %3',BankAcc.TABLECAPTION,BankAcc."No.",BankAcc.Name));
      END;
      IF "Entry Type" = "Entry Type"::"Fixed Asset" THEN BEGIN
        IF FALedgEntry.GET("Entry No.") THEN;
        IF FA.GET(FALedgEntry."FA No.") THEN;
        EXIT(STRSUBSTNO('%1 %2 %3',FA.TABLECAPTION,FA."No.",FA.Description));
      END;
      IF "Entry Type" = "Entry Type"::Maintenance THEN BEGIN
        IF MaintenanceLedgEntry.GET("Entry No.") THEN;
        IF FA.GET(MaintenanceLedgEntry."FA No.") THEN;
        EXIT(STRSUBSTNO('%1 %2 %3',FA.TABLECAPTION,FA."No.",FA.Description));
      END;
      IF "Entry Type" = "Entry Type"::VAT THEN
        EXIT(STRSUBSTNO('%1',VATEntry.TABLECAPTION));
    END;

    LOCAL PROCEDURE CheckPostingDate@23(PostingDate@1000 : Date;Caption@1002 : Text[50];EntryNo@1001 : Integer);
    BEGIN
      IF GenJnlCheckLine.DateNotAllowed(PostingDate) THEN
        ERROR(Text001,Caption,EntryNo);
      IF PostingDate > MaxPostingDate THEN
        MaxPostingDate := PostingDate;
    END;

    LOCAL PROCEDURE CheckFAPostingDate@24(FAPostingDate@1000 : Date;Caption@1004 : Text[50];EntryNo@1003 : Integer);
    VAR
      UserSetup@1001 : Record 91;
      FASetup@1002 : Record 5603;
    BEGIN
      IF (AllowPostingFrom = 0D) AND (AllowPostingto = 0D) THEN BEGIN
        IF USERID <> '' THEN
          IF UserSetup.GET(USERID) THEN BEGIN
            AllowPostingFrom := UserSetup."Allow FA Posting From";
            AllowPostingto := UserSetup."Allow FA Posting To";
          END;
        IF (AllowPostingFrom = 0D) AND (AllowPostingto = 0D) THEN BEGIN
          FASetup.GET;
          AllowPostingFrom := FASetup."Allow FA Posting From";
          AllowPostingto := FASetup."Allow FA Posting To";
        END;
        IF AllowPostingto = 0D THEN
          AllowPostingto := 31129998D;
      END;
      IF (FAPostingDate < AllowPostingFrom) OR (FAPostingDate > AllowPostingto) THEN
        ERROR(Text005,Caption,EntryNo,FALedgEntry.FIELDCAPTION("FA Posting Date"));
      IF FAPostingDate > MaxPostingDate THEN
        MaxPostingDate := FAPostingDate;
    END;

    [External]
    PROCEDURE TestFieldError@4();
    BEGIN
      ERROR(Text004);
    END;

    [External]
    PROCEDURE AlreadyReversedEntry@29(Caption@1000 : Text[50];EntryNo@1001 : Integer);
    BEGIN
      ERROR(Text011,Caption,EntryNo);
    END;

    [Internal]
    PROCEDURE VerifyReversalEntries@25(VAR ReversalEntry2@1000 : Record 179;Number@1002 : Integer;RevType@1001 : 'Transaction,Register') : Boolean;
    BEGIN
      InsertReversalEntry(Number,RevType);
      CLEAR(TempReversalEntry);
      CLEAR(ReversalEntry2);
      IF ReversalEntry2.FINDSET THEN
        REPEAT
          IF TempReversalEntry.NEXT = 0 THEN
            EXIT(FALSE);
          IF NOT TempReversalEntry.Equal(ReversalEntry2) THEN
            EXIT(FALSE);
        UNTIL ReversalEntry2.NEXT = 0;
      EXIT(TempReversalEntry.NEXT = 0);
    END;

    [External]
    PROCEDURE Equal@27(ReversalEntry2@1000 : Record 179) : Boolean;
    BEGIN
      EXIT(
        ("Entry Type" = ReversalEntry2."Entry Type") AND
        ("Entry No." = ReversalEntry2."Entry No."));
    END;

    [External]
    PROCEDURE ReversalErrorForChangedEntry@31(TableName@1000 : Text[50];EntryNo@1001 : Integer) : Text[1024];
    BEGIN
      EXIT(STRSUBSTNO(Text000,TableName,EntryNo));
    END;

    [External]
    PROCEDURE SetHideDialog@30(NewHideDialog@1000 : Boolean);
    BEGIN
      HideDialog := NewHideDialog;
    END;

    [External]
    PROCEDURE SetHideWarningDialogs@41();
    BEGIN
      HideDialog := TRUE;
      HideWarningDialogs := TRUE;
    END;

    LOCAL PROCEDURE UnrealizedVATReverseError@33(TableName@1001 : Text[50];EntryNo@1000 : Integer) : Text;
    BEGIN
      EXIT(STRSUBSTNO(UnrealizedVATReverseErr,TableName,EntryNo));
    END;

    LOCAL PROCEDURE InsertFromCustLedgEntry@34(VAR TempRevertTransactionNo@1006 : TEMPORARY Record 2000000026;Number@1001 : Integer;RevType@1002 : 'Transaction,Register';VAR NextLineNo@1003 : Integer);
    VAR
      Cust@1000 : Record 18;
      DtldCustLedgEntry@1004 : Record 379;
    BEGIN
      DtldCustLedgEntry.SETCURRENTKEY("Transaction No.","Customer No.","Entry Type");
      DtldCustLedgEntry.SETFILTER(
        "Entry Type",'<>%1',DtldCustLedgEntry."Entry Type"::"Initial Entry");
      IF CustLedgEntry.FINDSET THEN
        REPEAT
          DtldCustLedgEntry.SETRANGE("Transaction No.",CustLedgEntry."Transaction No.");
          DtldCustLedgEntry.SETRANGE("Customer No.",CustLedgEntry."Customer No.");
          IF (NOT DtldCustLedgEntry.ISEMPTY) AND (RevType = RevType::Register) THEN
            ERROR(Text012,Number);

          CLEAR(TempReversalEntry);
          IF RevType = RevType::Register THEN
            TempReversalEntry."G/L Register No." := Number;
          TempReversalEntry."Reversal Type" := RevType;
          TempReversalEntry."Entry Type" := TempReversalEntry."Entry Type"::Customer;
          Cust.GET(CustLedgEntry."Customer No.");
          TempReversalEntry."Account No." := Cust."No.";
          TempReversalEntry."Account Name" := Cust.Name;
          TempReversalEntry.CopyFromCustLedgEntry(CustLedgEntry);
          TempReversalEntry."Line No." := NextLineNo;
          NextLineNo := NextLineNo + 1;
          TempReversalEntry.INSERT;

          DtldCustLedgEntry.SETRANGE(Unapplied,TRUE);
          IF DtldCustLedgEntry.FINDSET THEN
            REPEAT
              InsertCustTempRevertTransNo(TempRevertTransactionNo,DtldCustLedgEntry."Unapplied by Entry No.");
            UNTIL DtldCustLedgEntry.NEXT = 0;
          DtldCustLedgEntry.SETRANGE(Unapplied);
        UNTIL CustLedgEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE InsertFromVendLedgEntry@35(VAR TempRevertTransactionNo@1005 : TEMPORARY Record 2000000026;Number@1002 : Integer;RevType@1001 : 'Transaction,Register';VAR NextLineNo@1000 : Integer);
    VAR
      Vend@1003 : Record 23;
      DtldVendLedgEntry@1004 : Record 380;
    BEGIN
      DtldVendLedgEntry.SETCURRENTKEY("Transaction No.","Vendor No.","Entry Type");
      DtldVendLedgEntry.SETFILTER(
        "Entry Type",'<>%1',DtldVendLedgEntry."Entry Type"::"Initial Entry");
      IF VendLedgEntry.FINDSET THEN
        REPEAT
          DtldVendLedgEntry.SETRANGE("Transaction No.",VendLedgEntry."Transaction No.");
          DtldVendLedgEntry.SETRANGE("Vendor No.",VendLedgEntry."Vendor No.");
          IF (NOT DtldVendLedgEntry.ISEMPTY) AND (RevType = RevType::Register) THEN
            ERROR(Text012,Number);

          CLEAR(TempReversalEntry);
          IF RevType = RevType::Register THEN
            TempReversalEntry."G/L Register No." := Number;
          TempReversalEntry."Reversal Type" := RevType;
          TempReversalEntry."Entry Type" := TempReversalEntry."Entry Type"::Vendor;
          Vend.GET(VendLedgEntry."Vendor No.");
          TempReversalEntry."Account No." := Vend."No.";
          TempReversalEntry."Account Name" := Vend.Name;
          TempReversalEntry.CopyFromVendLedgEntry(VendLedgEntry);
          TempReversalEntry."Line No." := NextLineNo;
          NextLineNo := NextLineNo + 1;
          TempReversalEntry.INSERT;

          DtldVendLedgEntry.SETRANGE(Unapplied,TRUE);
          IF DtldVendLedgEntry.FINDSET THEN
            REPEAT
              InsertVendTempRevertTransNo(TempRevertTransactionNo,DtldVendLedgEntry."Unapplied by Entry No.");
            UNTIL DtldVendLedgEntry.NEXT = 0;
          DtldVendLedgEntry.SETRANGE(Unapplied);
        UNTIL VendLedgEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE InsertFromBankAccLedgEntry@36(Number@1002 : Integer;RevType@1001 : 'Transaction,Register';VAR NextLineNo@1000 : Integer);
    VAR
      BankAcc@1003 : Record 270;
    BEGIN
      IF BankAccLedgEntry.FINDSET THEN
        REPEAT
          CLEAR(TempReversalEntry);
          IF RevType = RevType::Register THEN
            TempReversalEntry."G/L Register No." := Number;
          TempReversalEntry."Reversal Type" := RevType;
          TempReversalEntry."Entry Type" := TempReversalEntry."Entry Type"::"Bank Account";
          BankAcc.GET(BankAccLedgEntry."Bank Account No.");
          TempReversalEntry."Account No." := BankAcc."No.";
          TempReversalEntry."Account Name" := BankAcc.Name;
          TempReversalEntry.CopyFromBankAccLedgEntry(BankAccLedgEntry);
          TempReversalEntry."Line No." := NextLineNo;
          NextLineNo := NextLineNo + 1;
          TempReversalEntry.INSERT;
        UNTIL BankAccLedgEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE InsertFromFALedgEntry@37(Number@1002 : Integer;RevType@1001 : 'Transaction,Register';VAR NextLineNo@1000 : Integer);
    VAR
      FA@1003 : Record 5600;
    BEGIN
      IF FALedgEntry.FINDSET THEN
        REPEAT
          CLEAR(TempReversalEntry);
          IF RevType = RevType::Register THEN
            TempReversalEntry."G/L Register No." := Number;
          TempReversalEntry."Reversal Type" := RevType;
          TempReversalEntry."Entry Type" := TempReversalEntry."Entry Type"::"Fixed Asset";
          FA.GET(FALedgEntry."FA No.");
          TempReversalEntry."Account No." := FA."No.";
          TempReversalEntry."Account Name" := FA.Description;
          TempReversalEntry.CopyFromFALedgEntry(FALedgEntry);
          IF FALedgEntry."FA Posting Type" <> FALedgEntry."FA Posting Type"::"Salvage Value" THEN BEGIN
            TempReversalEntry."Line No." := NextLineNo;
            NextLineNo := NextLineNo + 1;
            TempReversalEntry.INSERT;
          END;
        UNTIL FALedgEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE InsertFromMaintenanceLedgEntry@38(Number@1002 : Integer;RevType@1001 : 'Transaction,Register';VAR NextLineNo@1000 : Integer);
    VAR
      FA@1003 : Record 5600;
    BEGIN
      IF MaintenanceLedgEntry.FINDSET THEN
        REPEAT
          CLEAR(TempReversalEntry);
          IF RevType = RevType::Register THEN
            TempReversalEntry."G/L Register No." := Number;
          TempReversalEntry."Reversal Type" := RevType;
          TempReversalEntry."Entry Type" := TempReversalEntry."Entry Type"::Maintenance;
          FA.GET(MaintenanceLedgEntry."FA No.");
          TempReversalEntry."Account No." := FA."No.";
          TempReversalEntry."Account Name" := FA.Description;
          TempReversalEntry.CopyFromMaintenanceEntry(MaintenanceLedgEntry);
          TempReversalEntry."Line No." := NextLineNo;
          NextLineNo := NextLineNo + 1;
          TempReversalEntry.INSERT;
        UNTIL MaintenanceLedgEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE InsertFromVATEntry@39(VAR TempRevertTransactionNo@1004 : TEMPORARY Record 2000000026;Number@1002 : Integer;RevType@1001 : 'Transaction,Register';VAR NextLineNo@1000 : Integer);
    BEGIN
      TempRevertTransactionNo.FINDSET;
      REPEAT
        IF RevType = RevType::Transaction THEN
          VATEntry.SETRANGE("Transaction No.",TempRevertTransactionNo.Number);
        IF VATEntry.FINDSET THEN
          REPEAT
            CLEAR(TempReversalEntry);
            IF RevType = RevType::Register THEN
              TempReversalEntry."G/L Register No." := Number;
            TempReversalEntry."Reversal Type" := RevType;
            TempReversalEntry."Entry Type" := TempReversalEntry."Entry Type"::VAT;
            TempReversalEntry.CopyFromVATEntry(VATEntry);
            TempReversalEntry."Line No." := NextLineNo;
            NextLineNo := NextLineNo + 1;
            TempReversalEntry.INSERT;
          UNTIL VATEntry.NEXT = 0;
      UNTIL TempRevertTransactionNo.NEXT = 0;
    END;

    LOCAL PROCEDURE InsertFromGLEntry@40(VAR TempRevertTransactionNo@1005 : TEMPORARY Record 2000000026;Number@1002 : Integer;RevType@1001 : 'Transaction,Register';VAR NextLineNo@1000 : Integer);
    VAR
      GLAcc@1004 : Record 15;
    BEGIN
      TempRevertTransactionNo.FINDSET;
      REPEAT
        IF RevType = RevType::Transaction THEN
          GLEntry.SETRANGE("Transaction No.",TempRevertTransactionNo.Number);
        IF GLEntry.FINDSET THEN
          REPEAT
            CLEAR(TempReversalEntry);
            IF RevType = RevType::Register THEN
              TempReversalEntry."G/L Register No." := Number;
            TempReversalEntry."Reversal Type" := RevType;
            TempReversalEntry."Entry Type" := TempReversalEntry."Entry Type"::"G/L Account";
            IF NOT GLAcc.GET(GLEntry."G/L Account No.") THEN
              ERROR(Text009,GLEntry.TABLECAPTION,GLAcc.TABLECAPTION);
            TempReversalEntry."Account No." := GLAcc."No.";
            TempReversalEntry."Account Name" := GLAcc.Name;
            TempReversalEntry.CopyFromGLEntry(GLEntry);
            TempReversalEntry."Line No." := NextLineNo;
            NextLineNo := NextLineNo + 1;
            TempReversalEntry.INSERT;
          UNTIL GLEntry.NEXT = 0;
      UNTIL TempRevertTransactionNo.NEXT = 0;
    END;

    PROCEDURE CopyFromCustLedgEntry@57(CustLedgEntry@1001 : Record 21);
    BEGIN
      "Entry No." := CustLedgEntry."Entry No.";
      "Posting Date" := CustLedgEntry."Posting Date";
      "Source Code" := CustLedgEntry."Source Code";
      "Journal Batch Name" := CustLedgEntry."Journal Batch Name";
      "Transaction No." := CustLedgEntry."Transaction No.";
      "Currency Code" := CustLedgEntry."Currency Code";
      Description := CustLedgEntry.Description;
      CustLedgEntry.CALCFIELDS(Amount,"Debit Amount","Credit Amount",
        "Amount (LCY)","Debit Amount (LCY)","Credit Amount (LCY)");
      Amount := CustLedgEntry.Amount;
      "Debit Amount" := CustLedgEntry."Debit Amount";
      "Credit Amount" := CustLedgEntry."Credit Amount";
      "Amount (LCY)" := CustLedgEntry."Amount (LCY)";
      "Debit Amount (LCY)" := CustLedgEntry."Debit Amount (LCY)";
      "Credit Amount (LCY)" := CustLedgEntry."Credit Amount (LCY)";
      "Document Type" := CustLedgEntry."Document Type";
      "Document No." := CustLedgEntry."Document No.";
      "Bal. Account Type" := CustLedgEntry."Bal. Account Type";
      "Bal. Account No." := CustLedgEntry."Bal. Account No.";
    END;

    PROCEDURE CopyFromBankAccLedgEntry@53(BankAccLedgEntry@1001 : Record 271);
    BEGIN
      "Entry No." := BankAccLedgEntry."Entry No.";
      "Posting Date" := BankAccLedgEntry."Posting Date";
      "Source Code" := BankAccLedgEntry."Source Code";
      "Journal Batch Name" := BankAccLedgEntry."Journal Batch Name";
      "Transaction No." := BankAccLedgEntry."Transaction No.";
      "Currency Code" := BankAccLedgEntry."Currency Code";
      Description := BankAccLedgEntry.Description;
      Amount := BankAccLedgEntry.Amount;
      "Debit Amount" := BankAccLedgEntry."Debit Amount";
      "Credit Amount" := BankAccLedgEntry."Credit Amount";
      "Amount (LCY)" := BankAccLedgEntry."Amount (LCY)";
      "Debit Amount (LCY)" := BankAccLedgEntry."Debit Amount (LCY)";
      "Credit Amount (LCY)" := BankAccLedgEntry."Credit Amount (LCY)";
      "Document Type" := BankAccLedgEntry."Document Type";
      "Document No." := BankAccLedgEntry."Document No.";
      "Bal. Account Type" := BankAccLedgEntry."Bal. Account Type";
      "Bal. Account No." := BankAccLedgEntry."Bal. Account No.";
    END;

    PROCEDURE CopyFromFALedgEntry@51(FALedgEntry@1001 : Record 5601);
    BEGIN
      "Entry No." := FALedgEntry."Entry No.";
      "Posting Date" := FALedgEntry."Posting Date";
      "FA Posting Category" := FALedgEntry."FA Posting Category";
      "FA Posting Type" := FALedgEntry."FA Posting Type" + 1;
      "Source Code" := FALedgEntry."Source Code";
      "Journal Batch Name" := FALedgEntry."Journal Batch Name";
      "Transaction No." := FALedgEntry."Transaction No.";
      Description := FALedgEntry.Description;
      "Amount (LCY)" := FALedgEntry.Amount;
      "Debit Amount (LCY)" := FALedgEntry."Debit Amount";
      "Credit Amount (LCY)" := FALedgEntry."Credit Amount";
      "VAT Amount" := FALedgEntry."VAT Amount";
      "Document Type" := FALedgEntry."Document Type";
      "Document No." := FALedgEntry."Document No.";
      "Bal. Account Type" := FALedgEntry."Bal. Account Type";
      "Bal. Account No." := FALedgEntry."Bal. Account No.";
    END;

    PROCEDURE CopyFromGLEntry@42(GLEntry@1000 : Record 17);
    BEGIN
      "Entry No." := GLEntry."Entry No.";
      "Posting Date" := GLEntry."Posting Date";
      "Source Code" := GLEntry."Source Code";
      "Journal Batch Name" := GLEntry."Journal Batch Name";
      "Transaction No." := GLEntry."Transaction No.";
      "Source Type" := GLEntry."Source Type";
      "Source No." := GLEntry."Source No.";
      Description := GLEntry.Description;
      "Amount (LCY)" := GLEntry.Amount;
      "Debit Amount (LCY)" := GLEntry."Debit Amount";
      "Credit Amount (LCY)" := GLEntry."Credit Amount";
      "VAT Amount" := GLEntry."VAT Amount";
      "Document Type" := GLEntry."Document Type";
      "Document No." := GLEntry."Document No.";
      "Bal. Account Type" := GLEntry."Bal. Account Type";
      "Bal. Account No." := GLEntry."Bal. Account No.";
    END;

    PROCEDURE CopyFromMaintenanceEntry@49(MaintenanceLedgEntry@1001 : Record 5625);
    BEGIN
      "Entry No." := MaintenanceLedgEntry."Entry No.";
      "Posting Date" := MaintenanceLedgEntry."Posting Date";
      "Source Code" := MaintenanceLedgEntry."Source Code";
      "Journal Batch Name" := MaintenanceLedgEntry."Journal Batch Name";
      "Transaction No." := MaintenanceLedgEntry."Transaction No.";
      Description := MaintenanceLedgEntry.Description;
      "Amount (LCY)" := MaintenanceLedgEntry.Amount;
      "Debit Amount (LCY)" := MaintenanceLedgEntry."Debit Amount";
      "Credit Amount (LCY)" := MaintenanceLedgEntry."Credit Amount";
      "VAT Amount" := MaintenanceLedgEntry."VAT Amount";
      "Document Type" := MaintenanceLedgEntry."Document Type";
      "Document No." := MaintenanceLedgEntry."Document No.";
      "Bal. Account Type" := MaintenanceLedgEntry."Bal. Account Type";
      "Bal. Account No." := MaintenanceLedgEntry."Bal. Account No.";
    END;

    PROCEDURE CopyFromVATEntry@47(VATEntry@1001 : Record 254);
    BEGIN
      "Entry No." := VATEntry."Entry No.";
      "Posting Date" := VATEntry."Posting Date";
      "Source Code" := VATEntry."Source Code";
      "Transaction No." := VATEntry."Transaction No.";
      Amount := VATEntry.Amount;
      "Amount (LCY)" := VATEntry.Amount;
      "Document Type" := VATEntry."Document Type";
      "Document No." := VATEntry."Document No.";
    END;

    PROCEDURE CopyFromVendLedgEntry@55(VendLedgEntry@1001 : Record 25);
    BEGIN
      "Entry No." := VendLedgEntry."Entry No.";
      "Posting Date" := VendLedgEntry."Posting Date";
      "Source Code" := VendLedgEntry."Source Code";
      "Journal Batch Name" := VendLedgEntry."Journal Batch Name";
      "Transaction No." := VendLedgEntry."Transaction No.";
      "Currency Code" := VendLedgEntry."Currency Code";
      Description := VendLedgEntry.Description;
      VendLedgEntry.CALCFIELDS(Amount,"Debit Amount","Credit Amount",
        "Amount (LCY)","Debit Amount (LCY)","Credit Amount (LCY)");
      Amount := VendLedgEntry.Amount;
      "Debit Amount" := VendLedgEntry."Debit Amount";
      "Credit Amount" := VendLedgEntry."Credit Amount";
      "Amount (LCY)" := VendLedgEntry."Amount (LCY)";
      "Debit Amount (LCY)" := VendLedgEntry."Debit Amount (LCY)";
      "Credit Amount (LCY)" := VendLedgEntry."Credit Amount (LCY)";
      "Document Type" := VendLedgEntry."Document Type";
      "Document No." := VendLedgEntry."Document No.";
      "Bal. Account Type" := VendLedgEntry."Bal. Account Type";
      "Bal. Account No." := VendLedgEntry."Bal. Account No.";
    END;

    LOCAL PROCEDURE InsertCustTempRevertTransNo@44(VAR TempRevertTransactionNo@1000 : TEMPORARY Record 2000000026;CustLedgEntryNo@1001 : Integer);
    VAR
      DtldCustLedgEntry@1002 : Record 379;
    BEGIN
      DtldCustLedgEntry.GET(CustLedgEntryNo);
      IF DtldCustLedgEntry."Transaction No." <> 0 THEN BEGIN
        TempRevertTransactionNo.Number := DtldCustLedgEntry."Transaction No.";
        IF TempRevertTransactionNo.INSERT THEN;
      END;
    END;

    LOCAL PROCEDURE InsertVendTempRevertTransNo@45(VAR TempRevertTransactionNo@1000 : TEMPORARY Record 2000000026;VendLedgEntryNo@1001 : Integer);
    VAR
      DtldVendLedgEntry@1002 : Record 380;
    BEGIN
      DtldVendLedgEntry.GET(VendLedgEntryNo);
      IF DtldVendLedgEntry."Transaction No." <> 0 THEN BEGIN
        TempRevertTransactionNo.Number := DtldVendLedgEntry."Transaction No.";
        IF TempRevertTransactionNo.INSERT THEN;
      END;
    END;

    BEGIN
    END.
  }
}

