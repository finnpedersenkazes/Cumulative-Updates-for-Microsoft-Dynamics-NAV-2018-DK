OBJECT Table 274 Bank Acc. Reconciliation Line
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    Permissions=TableData 1221=rimd;
    OnInsert=BEGIN
               BankAccRecon.GET("Statement Type","Bank Account No.","Statement No.");
               "Applied Entries" := 0;
               VALIDATE("Applied Amount",0);
             END;

    OnModify=BEGIN
               IF xRec."Statement Amount" <> "Statement Amount" THEN
                 RemoveApplication(Type);
             END;

    OnDelete=BEGIN
               RemoveApplication(Type);
               ClearDataExchEntries;
               RemoveAppliedPaymentEntries;
               DeletePaymentMatchingDetails;
               UpdateParentLineStatementAmount;
               IF FIND THEN;
             END;

    OnRename=BEGIN
               ERROR(Text000,TABLECAPTION);
             END;

    CaptionML=[DAN=Bankkto.afstemningslinje;
               ENU=Bank Acc. Reconciliation Line];
  }
  FIELDS
  {
    { 1   ;   ;Bank Account No.    ;Code20        ;TableRelation="Bank Account";
                                                   CaptionML=[DAN=Bankkontonr.;
                                                              ENU=Bank Account No.] }
    { 2   ;   ;Statement No.       ;Code20        ;TableRelation="Bank Acc. Reconciliation"."Statement No." WHERE (Bank Account No.=FIELD(Bank Account No.));
                                                   CaptionML=[DAN=Kontoudtogsnr.;
                                                              ENU=Statement No.] }
    { 3   ;   ;Statement Line No.  ;Integer       ;CaptionML=[DAN=Kontoudtogslinjenr.;
                                                              ENU=Statement Line No.] }
    { 4   ;   ;Document No.        ;Code20        ;CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.] }
    { 5   ;   ;Transaction Date    ;Date          ;CaptionML=[DAN=Transaktionsdato;
                                                              ENU=Transaction Date] }
    { 6   ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 7   ;   ;Statement Amount    ;Decimal       ;OnValidate=BEGIN
                                                                Difference := "Statement Amount" - "Applied Amount";
                                                              END;

                                                   CaptionML=[DAN=Kontoudtogsbel�b;
                                                              ENU=Statement Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr=GetCurrencyCode }
    { 8   ;   ;Difference          ;Decimal       ;OnValidate=BEGIN
                                                                "Statement Amount" := "Applied Amount" + Difference;
                                                              END;

                                                   CaptionML=[DAN=Difference;
                                                              ENU=Difference];
                                                   BlankZero=Yes;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr=GetCurrencyCode }
    { 9   ;   ;Applied Amount      ;Decimal       ;OnValidate=BEGIN
                                                                Difference := "Statement Amount" - "Applied Amount";
                                                              END;

                                                   OnLookup=BEGIN
                                                              DisplayApplication;
                                                            END;

                                                   CaptionML=[DAN=Udligningsbel�b;
                                                              ENU=Applied Amount];
                                                   BlankZero=Yes;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr=GetCurrencyCode }
    { 10  ;   ;Type                ;Option        ;OnValidate=BEGIN
                                                                IF (Type <> xRec.Type) AND
                                                                   ("Applied Entries" <> 0)
                                                                THEN
                                                                  IF CONFIRM(Text001,FALSE) THEN BEGIN
                                                                    RemoveApplication(xRec.Type);
                                                                    VALIDATE("Applied Amount",0);
                                                                    "Applied Entries" := 0;
                                                                    "Check No." := '';
                                                                  END ELSE
                                                                    ERROR(Text002);
                                                              END;

                                                   CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=Bankkontopost,Checkpost,Difference;
                                                                    ENU=Bank Account Ledger Entry,Check Ledger Entry,Difference];
                                                   OptionString=Bank Account Ledger Entry,Check Ledger Entry,Difference }
    { 11  ;   ;Applied Entries     ;Integer       ;OnLookup=BEGIN
                                                              DisplayApplication;
                                                            END;

                                                   CaptionML=[DAN=Udlignede poster;
                                                              ENU=Applied Entries];
                                                   Editable=No }
    { 12  ;   ;Value Date          ;Date          ;CaptionML=[DAN=Val�rdato;
                                                              ENU=Value Date] }
    { 13  ;   ;Ready for Application;Boolean      ;CaptionML=[DAN=Klar til udligning;
                                                              ENU=Ready for Application] }
    { 14  ;   ;Check No.           ;Code20        ;CaptionML=[DAN=Checknr.;
                                                              ENU=Check No.] }
    { 15  ;   ;Related-Party Name  ;Text250       ;CaptionML=[DAN=Navn p� relateret part;
                                                              ENU=Related-Party Name] }
    { 16  ;   ;Additional Transaction Info;Text100;CaptionML=[DAN=Flere transaktionsoplysninger;
                                                              ENU=Additional Transaction Info] }
    { 17  ;   ;Data Exch. Entry No.;Integer       ;TableRelation="Data Exch.";
                                                   CaptionML=[DAN=Dataudvekslingspostnr.;
                                                              ENU=Data Exch. Entry No.];
                                                   Editable=No }
    { 18  ;   ;Data Exch. Line No. ;Integer       ;CaptionML=[DAN=Dataudvekslingslinjenr.;
                                                              ENU=Data Exch. Line No.];
                                                   Editable=No }
    { 20  ;   ;Statement Type      ;Option        ;CaptionML=[DAN=Kontoudtogstype;
                                                              ENU=Statement Type];
                                                   OptionCaptionML=[DAN=Bankudligning,Betalingsudligning;
                                                                    ENU=Bank Reconciliation,Payment Application];
                                                   OptionString=Bank Reconciliation,Payment Application }
    { 21  ;   ;Account Type        ;Option        ;OnValidate=BEGIN
                                                                TESTFIELD("Applied Amount",0);
                                                                IF "Account Type" <> xRec."Account Type" THEN
                                                                  VALIDATE("Account No.",'');
                                                              END;

                                                   CaptionML=[DAN=Kontotype;
                                                              ENU=Account Type];
                                                   OptionCaptionML=[DAN=Finanskonto,Debitor,Kreditor,Bankkonto,Anl�g,IC-partner;
                                                                    ENU=G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner];
                                                   OptionString=G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee }
    { 22  ;   ;Account No.         ;Code20        ;TableRelation=IF (Account Type=CONST(G/L Account)) "G/L Account" WHERE (Account Type=CONST(Posting),
                                                                                                                           Blocked=CONST(No))
                                                                                                                           ELSE IF (Account Type=CONST(Customer)) Customer
                                                                                                                           ELSE IF (Account Type=CONST(Vendor)) Vendor
                                                                                                                           ELSE IF (Account Type=CONST(Bank Account)) "Bank Account"
                                                                                                                           ELSE IF (Account Type=CONST(Fixed Asset)) "Fixed Asset"
                                                                                                                           ELSE IF (Account Type=CONST(IC Partner)) "IC Partner";
                                                   OnValidate=BEGIN
                                                                TESTFIELD("Applied Amount",0);
                                                                CreateDim(
                                                                  DimMgt.TypeToTableID1("Account Type"),"Account No.",
                                                                  DATABASE::"Salesperson/Purchaser",GetSalepersonPurchaserCode);
                                                                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
                                                              END;

                                                   CaptionML=[DAN=Kontonr.;
                                                              ENU=Account No.] }
    { 23  ;   ;Transaction Text    ;Text140       ;OnValidate=BEGIN
                                                                IF ("Statement Type" = "Statement Type"::"Payment Application") OR (Description = '') THEN
                                                                  Description := COPYSTR("Transaction Text",1,MAXSTRLEN(Description));
                                                              END;

                                                   CaptionML=[DAN=Transaktionstekst;
                                                              ENU=Transaction Text] }
    { 24  ;   ;Related-Party Bank Acc. No.;Text100;CaptionML=[DAN=Bankkontonr. p� relateret part;
                                                              ENU=Related-Party Bank Acc. No.] }
    { 25  ;   ;Related-Party Address;Text100      ;CaptionML=[DAN=Adresse p� relateret part;
                                                              ENU=Related-Party Address] }
    { 26  ;   ;Related-Party City  ;Text50        ;CaptionML=[DAN=By for relateret part;
                                                              ENU=Related-Party City] }
    { 31  ;   ;Shortcut Dimension 1 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   OnValidate=BEGIN
                                                                ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
                                                              END;

                                                   CaptionML=[DAN=Genvejsdimension 1-kode;
                                                              ENU=Shortcut Dimension 1 Code];
                                                   CaptionClass='1,2,1' }
    { 32  ;   ;Shortcut Dimension 2 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   OnValidate=BEGIN
                                                                ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
                                                              END;

                                                   CaptionML=[DAN=Genvejsdimension 2-kode;
                                                              ENU=Shortcut Dimension 2 Code];
                                                   CaptionClass='1,2,2' }
    { 50  ;   ;Match Confidence    ;Option        ;FieldClass=FlowField;
                                                   InitValue=None;
                                                   CalcFormula=Max("Applied Payment Entry"."Match Confidence" WHERE (Statement Type=FIELD(Statement Type),
                                                                                                                     Bank Account No.=FIELD(Bank Account No.),
                                                                                                                     Statement No.=FIELD(Statement No.),
                                                                                                                     Statement Line No.=FIELD(Statement Line No.)));
                                                   CaptionML=[DAN=Matchtillid;
                                                              ENU=Match Confidence];
                                                   OptionCaptionML=[DAN=Ingen,Lav,Medium,H�j,H�j - Tilknytning af tekst til konto,Manuel,Accepteret;
                                                                    ENU=None,Low,Medium,High,High - Text-to-Account Mapping,Manual,Accepted];
                                                   OptionString=None,Low,Medium,High,High - Text-to-Account Mapping,Manual,Accepted;
                                                   Editable=No }
    { 51  ;   ;Match Quality       ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Max("Applied Payment Entry".Quality WHERE (Bank Account No.=FIELD(Bank Account No.),
                                                                                                          Statement No.=FIELD(Statement No.),
                                                                                                          Statement Line No.=FIELD(Statement Line No.),
                                                                                                          Statement Type=FIELD(Statement Type)));
                                                   CaptionML=[DAN=Matchkvalitet;
                                                              ENU=Match Quality];
                                                   Editable=No }
    { 60  ;   ;Sorting Order       ;Integer       ;CaptionML=[DAN=Sorteringsr�kkef�lge;
                                                              ENU=Sorting Order] }
    { 61  ;   ;Parent Line No.     ;Integer       ;CaptionML=[DAN=Overordnet linjenr.;
                                                              ENU=Parent Line No.];
                                                   Editable=No }
    { 70  ;   ;Transaction ID      ;Text50        ;CaptionML=[DAN=Transaktions-id;
                                                              ENU=Transaction ID] }
    { 480 ;   ;Dimension Set ID    ;Integer       ;TableRelation="Dimension Set Entry";
                                                   OnValidate=BEGIN
                                                                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
                                                              END;

                                                   OnLookup=BEGIN
                                                              ShowDimensions;
                                                            END;

                                                   CaptionML=[DAN=Dimensionsgruppe-id;
                                                              ENU=Dimension Set ID];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Statement Type,Bank Account No.,Statement No.,Statement Line No.;
                                                   SumIndexFields=Statement Amount,Difference;
                                                   MaintainSIFTIndex=No;
                                                   Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=%1 kan ikke omd�bes.;ENU=You cannot rename a %1.';
      Text001@1001 : TextConst 'DAN=Slet udligning?;ENU=Delete application?';
      Text002@1002 : TextConst 'DAN=Opdateringen er afbrudt.;ENU=Update canceled.';
      BankAccLedgEntry@1003 : Record 271;
      CheckLedgEntry@1004 : Record 272;
      BankAccRecon@1005 : Record 273;
      BankAccSetStmtNo@1006 : Codeunit 375;
      CheckSetStmtNo@1007 : Codeunit 376;
      DimMgt@1009 : Codeunit 408;
      AmountWithinToleranceRangeTok@1011 : TextConst '@@@={Locked};DAN=">=%1&<=%2";ENU=">=%1&<=%2"';
      AmountOustideToleranceRangeTok@1012 : TextConst '@@@={Locked};DAN=<%1|>%2;ENU=<%1|>%2';
      TransactionAmountMustNotBeZeroErr@1008 : TextConst 'DAN=Feltet Transaktionsbel�b skal have en v�rdi, der ikke er 0 (nul).;ENU=The Transaction Amount field must have a value that is not 0.';
      CreditTheAccountQst@1013 : TextConst '@@@=%1 is the account name, %2 is the amount that is not applied (there is filed on the page named Remaining Amount To Apply);DAN=Restbel�bet til udligning er %2.\\Vil du oprette en ny betalingsudligning, som debiterer eller krediterer %1 med det resterende bel�b, n�r du bogf�rer betalingen?;ENU=The remaining amount to apply is %2.\\Do you want to create a new payment application line that will debit or credit %1 with the remaining amount when you post the payment?';
      ExcessiveAmountErr@1010 : TextConst '@@@=%1 is the amount that is not applied (there is filed on the page named Remaining Amount To Apply);DAN=Restbel�bet til udligning er %1.;ENU=The remaining amount to apply is %1.';
      ImportPostedTransactionsQst@1014 : TextConst 'DAN=Bankkontoudtoget indeholder betalinger, der allerede er foretaget, men de relaterede bankkontofinansposter er ikke lukket.\\Vil du inkludere disse betalinger i importen?;ENU=The bank statement contains payments that are already applied, but the related bank account ledger entries are not closed.\\Do you want to include these payments in the import?';

    [External]
    PROCEDURE DisplayApplication@2();
    VAR
      PaymentApplication@1000 : Page 1292;
    BEGIN
      CASE "Statement Type" OF
        "Statement Type"::"Bank Reconciliation":
          CASE Type OF
            Type::"Bank Account Ledger Entry":
              BEGIN
                BankAccLedgEntry.RESET;
                BankAccLedgEntry.SETCURRENTKEY("Bank Account No.",Open);
                BankAccLedgEntry.SETRANGE("Bank Account No.","Bank Account No.");
                BankAccLedgEntry.SETRANGE(Open,TRUE);
                BankAccLedgEntry.SETRANGE(
                  "Statement Status",BankAccLedgEntry."Statement Status"::"Bank Acc. Entry Applied");
                BankAccLedgEntry.SETRANGE("Statement No.","Statement No.");
                BankAccLedgEntry.SETRANGE("Statement Line No.","Statement Line No.");
                PAGE.RUN(0,BankAccLedgEntry);
              END;
            Type::"Check Ledger Entry":
              BEGIN
                CheckLedgEntry.RESET;
                CheckLedgEntry.SETCURRENTKEY("Bank Account No.",Open);
                CheckLedgEntry.SETRANGE("Bank Account No.","Bank Account No.");
                CheckLedgEntry.SETRANGE(Open,TRUE);
                CheckLedgEntry.SETRANGE(
                  "Statement Status",CheckLedgEntry."Statement Status"::"Check Entry Applied");
                CheckLedgEntry.SETRANGE("Statement No.","Statement No.");
                CheckLedgEntry.SETRANGE("Statement Line No.","Statement Line No.");
                PAGE.RUN(0,CheckLedgEntry);
              END;
          END;
        "Statement Type"::"Payment Application":
          BEGIN
            IF "Statement Amount" = 0 THEN
              ERROR(TransactionAmountMustNotBeZeroErr);
            PaymentApplication.SetBankAccReconcLine(Rec);
            PaymentApplication.RUNMODAL;
          END;
      END;
    END;

    [External]
    PROCEDURE GetCurrencyCode@3() : Code[10];
    VAR
      BankAcc@1000 : Record 270;
    BEGIN
      IF "Bank Account No." = BankAcc."No." THEN
        EXIT(BankAcc."Currency Code");

      IF BankAcc.GET("Bank Account No.") THEN
        EXIT(BankAcc."Currency Code");

      EXIT('');
    END;

    [External]
    PROCEDURE GetStyle@35() : Text;
    BEGIN
      IF "Applied Entries" <> 0 THEN
        EXIT('Favorable');

      EXIT('');
    END;

    [External]
    PROCEDURE ClearDataExchEntries@5();
    VAR
      DataExchField@1000 : Record 1221;
      BankAccReconciliationLine@1001 : Record 274;
    BEGIN
      DataExchField.DeleteRelatedRecords("Data Exch. Entry No.","Data Exch. Line No.");

      BankAccReconciliationLine.SETRANGE("Statement Type","Statement Type");
      BankAccReconciliationLine.SETRANGE("Bank Account No.","Bank Account No.");
      BankAccReconciliationLine.SETRANGE("Statement No.","Statement No.");
      BankAccReconciliationLine.SETRANGE("Data Exch. Entry No.","Data Exch. Entry No.");
      BankAccReconciliationLine.SETFILTER("Statement Line No.",'<>%1',"Statement Line No.");
      IF BankAccReconciliationLine.ISEMPTY THEN
        DataExchField.DeleteRelatedRecords("Data Exch. Entry No.",0);
    END;

    [External]
    PROCEDURE ShowDimensions@25();
    BEGIN
      "Dimension Set ID" :=
        DimMgt.EditDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2 %3',TABLECAPTION,"Statement No.","Statement Line No."));
      DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
    END;

    LOCAL PROCEDURE CreateDim@26(Type1@1000 : Integer;No1@1001 : Code[20];Type2@1007 : Integer;No2@1006 : Code[20]);
    VAR
      SourceCodeSetup@1002 : Record 242;
      BankAccReconciliation@1005 : Record 273;
      TableID@1003 : ARRAY [10] OF Integer;
      No@1004 : ARRAY [10] OF Code[20];
    BEGIN
      SourceCodeSetup.GET;
      TableID[1] := Type1;
      No[1] := No1;
      TableID[2] := Type2;
      No[2] := No2;
      OnAfterCreateDimTableIDs(Rec,CurrFieldNo,TableID,No);

      "Shortcut Dimension 1 Code" := '';
      "Shortcut Dimension 2 Code" := '';
      BankAccReconciliation.GET("Statement Type","Bank Account No.","Statement No.");
      "Dimension Set ID" :=
        DimMgt.GetRecDefaultDimID(
          Rec,CurrFieldNo,TableID,No,SourceCodeSetup."Payment Reconciliation Journal",
          "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",BankAccReconciliation."Dimension Set ID",DATABASE::"Bank Account");
    END;

    [External]
    PROCEDURE SetUpNewLine@34();
    BEGIN
      "Transaction Date" := WORKDATE;
      "Match Confidence" := "Match Confidence"::None;
      "Document No." := '';
    END;

    [External]
    PROCEDURE ValidateShortcutDimCode@29(FieldNumber@1000 : Integer;VAR ShortcutDimCode@1001 : Code[20]);
    BEGIN
      DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
    END;

    [External]
    PROCEDURE ShowShortcutDimCode@50(VAR ShortcutDimCode@1000 : ARRAY [8] OF Code[20]);
    BEGIN
      DimMgt.GetShortcutDimensions("Dimension Set ID",ShortcutDimCode);
    END;

    [External]
    PROCEDURE AcceptAppliedPaymentEntriesSelectedLines@12();
    BEGIN
      IF FINDSET THEN
        REPEAT
          AcceptApplication;
        UNTIL NEXT = 0;
    END;

    [External]
    PROCEDURE RejectAppliedPaymentEntriesSelectedLines@18();
    BEGIN
      IF FINDSET THEN
        REPEAT
          RejectAppliedPayment;
        UNTIL NEXT = 0;
    END;

    [External]
    PROCEDURE RejectAppliedPayment@6();
    BEGIN
      RemoveAppliedPaymentEntries;
      DeletePaymentMatchingDetails;
    END;

    [External]
    PROCEDURE AcceptApplication@4();
    VAR
      AppliedPaymentEntry@1000 : Record 1294;
    BEGIN
      // For customer payments, the applied amount is positive, so positive difference means excessive amount.
      // For vendor payments, the applied amount is negative, so negative difference means excessive amount.
      // If "Applied Amount" and Difference have the same sign, then this is an overpayment situation.
      // Two non-zero numbers have the same sign if and only if their product is a positive number.
      IF Difference * "Applied Amount" > 0 THEN BEGIN
        IF "Account Type" = "Account Type"::"Bank Account" THEN
          ERROR(ExcessiveAmountErr,Difference);
        IF NOT CONFIRM(STRSUBSTNO(CreditTheAccountQst,GetAppliedToName,Difference)) THEN
          EXIT;
        TransferRemainingAmountToAccount;
      END;

      AppliedPaymentEntry.FilterAppliedPmtEntry(Rec);
      AppliedPaymentEntry.MODIFYALL("Match Confidence","Match Confidence"::Accepted);
    END;

    LOCAL PROCEDURE RemoveApplication@1(AppliedType@1000 : Option);
    BEGIN
      IF "Statement Type" = "Statement Type"::"Bank Reconciliation" THEN
        CASE AppliedType OF
          Type::"Bank Account Ledger Entry":
            BEGIN
              BankAccLedgEntry.RESET;
              BankAccLedgEntry.SETCURRENTKEY("Bank Account No.",Open);
              BankAccLedgEntry.SETRANGE("Bank Account No.","Bank Account No.");
              BankAccLedgEntry.SETRANGE(Open,TRUE);
              BankAccLedgEntry.SETRANGE(
                "Statement Status",BankAccLedgEntry."Statement Status"::"Bank Acc. Entry Applied");
              BankAccLedgEntry.SETRANGE("Statement No.","Statement No.");
              BankAccLedgEntry.SETRANGE("Statement Line No.","Statement Line No.");
              BankAccLedgEntry.LOCKTABLE;
              CheckLedgEntry.LOCKTABLE;
              IF BankAccLedgEntry.FIND('-') THEN
                REPEAT
                  BankAccSetStmtNo.RemoveReconNo(BankAccLedgEntry,Rec,TRUE);
                UNTIL BankAccLedgEntry.NEXT = 0;
              "Applied Entries" := 0;
              VALIDATE("Applied Amount",0);
              MODIFY;
            END;
          Type::"Check Ledger Entry":
            BEGIN
              CheckLedgEntry.RESET;
              CheckLedgEntry.SETCURRENTKEY("Bank Account No.",Open);
              CheckLedgEntry.SETRANGE("Bank Account No.","Bank Account No.");
              CheckLedgEntry.SETRANGE(Open,TRUE);
              CheckLedgEntry.SETRANGE(
                "Statement Status",CheckLedgEntry."Statement Status"::"Check Entry Applied");
              CheckLedgEntry.SETRANGE("Statement No.","Statement No.");
              CheckLedgEntry.SETRANGE("Statement Line No.","Statement Line No.");
              BankAccLedgEntry.LOCKTABLE;
              CheckLedgEntry.LOCKTABLE;
              IF CheckLedgEntry.FIND('-') THEN
                REPEAT
                  CheckSetStmtNo.RemoveReconNo(CheckLedgEntry,Rec,TRUE);
                UNTIL CheckLedgEntry.NEXT = 0;
              "Applied Entries" := 0;
              VALIDATE("Applied Amount",0);
              "Check No." := '';
              MODIFY;
            END;
        END;
    END;

    [External]
    PROCEDURE SetManualApplication@33();
    VAR
      AppliedPaymentEntry@1000 : Record 1294;
    BEGIN
      AppliedPaymentEntry.FilterAppliedPmtEntry(Rec);
      AppliedPaymentEntry.MODIFYALL("Match Confidence","Match Confidence"::Manual)
    END;

    LOCAL PROCEDURE RemoveAppliedPaymentEntries@9();
    VAR
      AppliedPmtEntry@1000 : Record 1294;
    BEGIN
      VALIDATE("Applied Amount",0);
      VALIDATE("Applied Entries",0);
      VALIDATE("Account No.",'');
      MODIFY(TRUE);

      AppliedPmtEntry.FilterAppliedPmtEntry(Rec);
      AppliedPmtEntry.DELETEALL(TRUE);
    END;

    LOCAL PROCEDURE DeletePaymentMatchingDetails@10();
    VAR
      PaymentMatchingDetails@1000 : Record 1299;
    BEGIN
      PaymentMatchingDetails.SETRANGE("Statement Type","Statement Type");
      PaymentMatchingDetails.SETRANGE("Bank Account No.","Bank Account No.");
      PaymentMatchingDetails.SETRANGE("Statement No.","Statement No.");
      PaymentMatchingDetails.SETRANGE("Statement Line No.","Statement Line No.");
      PaymentMatchingDetails.DELETEALL(TRUE);
    END;

    [External]
    PROCEDURE GetAppliedEntryAccountName@47(AppliedToEntryNo@1000 : Integer) : Text;
    VAR
      AccountType@1005 : Option;
      AccountNo@1006 : Code[20];
    BEGIN
      AccountType := GetAppliedEntryAccountType(AppliedToEntryNo);
      AccountNo := GetAppliedEntryAccountNo(AppliedToEntryNo);
      EXIT(GetAccountName(AccountType,AccountNo));
    END;

    [External]
    PROCEDURE GetAppliedToName@14() : Text;
    VAR
      AccountType@1005 : Option;
      AccountNo@1006 : Code[20];
    BEGIN
      AccountType := GetAppliedToAccountType;
      AccountNo := GetAppliedToAccountNo;
      EXIT(GetAccountName(AccountType,AccountNo));
    END;

    [External]
    PROCEDURE GetAppliedEntryAccountType@43(AppliedToEntryNo@1000 : Integer) : Integer;
    VAR
      BankAccountLedgerEntry@1003 : Record 271;
    BEGIN
      IF "Account Type" = "Account Type"::"Bank Account" THEN
        IF BankAccountLedgerEntry.GET(AppliedToEntryNo) THEN
          EXIT(BankAccountLedgerEntry."Bal. Account Type");
      EXIT("Account Type");
    END;

    [External]
    PROCEDURE GetAppliedToAccountType@36() : Integer;
    VAR
      BankAccountLedgerEntry@1003 : Record 271;
    BEGIN
      IF "Account Type" = "Account Type"::"Bank Account" THEN
        IF BankAccountLedgerEntry.GET(GetFirstAppliedToEntryNo) THEN
          EXIT(BankAccountLedgerEntry."Bal. Account Type");
      EXIT("Account Type");
    END;

    [External]
    PROCEDURE GetAppliedEntryAccountNo@39(AppliedToEntryNo@1000 : Integer) : Code[20];
    VAR
      CustLedgerEntry@1001 : Record 21;
      VendorLedgerEntry@1002 : Record 25;
      BankAccountLedgerEntry@1003 : Record 271;
    BEGIN
      CASE "Account Type" OF
        "Account Type"::Customer:
          IF CustLedgerEntry.GET(AppliedToEntryNo) THEN
            EXIT(CustLedgerEntry."Customer No.");
        "Account Type"::Vendor:
          IF VendorLedgerEntry.GET(AppliedToEntryNo) THEN
            EXIT(VendorLedgerEntry."Vendor No.");
        "Account Type"::"Bank Account":
          IF BankAccountLedgerEntry.GET(AppliedToEntryNo) THEN
            EXIT(BankAccountLedgerEntry."Bal. Account No.");
      END;
      EXIT("Account No.");
    END;

    [External]
    PROCEDURE GetAppliedToAccountNo@37() : Code[20];
    VAR
      BankAccountLedgerEntry@1004 : Record 271;
    BEGIN
      IF "Account Type" = "Account Type"::"Bank Account" THEN
        IF BankAccountLedgerEntry.GET(GetFirstAppliedToEntryNo) THEN
          EXIT(BankAccountLedgerEntry."Bal. Account No.");
      EXIT("Account No.")
    END;

    LOCAL PROCEDURE GetAccountName@45(AccountType@1000 : Option;AccountNo@1001 : Code[20]) : Text;
    VAR
      Customer@1005 : Record 18;
      Vendor@1004 : Record 23;
      GLAccount@1003 : Record 15;
      BankAccount@1002 : Record 270;
      Name@1006 : Text;
    BEGIN
      CASE AccountType OF
        "Account Type"::Customer:
          IF Customer.GET(AccountNo) THEN
            Name := Customer.Name;
        "Account Type"::Vendor:
          IF Vendor.GET(AccountNo) THEN
            Name := Vendor.Name;
        "Account Type"::"G/L Account":
          IF GLAccount.GET(AccountNo) THEN
            Name := GLAccount.Name;
        "Account Type"::"Bank Account":
          IF BankAccount.GET(AccountNo) THEN
            Name := BankAccount.Name;
      END;

      EXIT(Name);
    END;

    [External]
    PROCEDURE AppliedEntryAccountDrillDown@46(AppliedEntryNo@1000 : Integer);
    VAR
      AccountType@1004 : Option;
      AccountNo@1003 : Code[20];
    BEGIN
      AccountType := GetAppliedEntryAccountType(AppliedEntryNo);
      AccountNo := GetAppliedEntryAccountNo(AppliedEntryNo);
      OpenAccountPage(AccountType,AccountNo);
    END;

    [External]
    PROCEDURE AppliedToDrillDown@16();
    VAR
      AccountType@1004 : Option;
      AccountNo@1003 : Code[20];
    BEGIN
      AccountType := GetAppliedToAccountType;
      AccountNo := GetAppliedToAccountNo;
      OpenAccountPage(AccountType,AccountNo);
    END;

    LOCAL PROCEDURE OpenAccountPage@40(AccountType@1006 : Option;AccountNo@1007 : Code[20]);
    VAR
      Customer@1002 : Record 18;
      Vendor@1001 : Record 23;
      GLAccount@1000 : Record 15;
      BankAccount@1005 : Record 270;
    BEGIN
      CASE AccountType OF
        "Account Type"::Customer:
          BEGIN
            Customer.GET(AccountNo);
            PAGE.RUN(PAGE::"Customer Card",Customer);
          END;
        "Account Type"::Vendor:
          BEGIN
            Vendor.GET(AccountNo);
            PAGE.RUN(PAGE::"Vendor Card",Vendor);
          END;
        "Account Type"::"G/L Account":
          BEGIN
            GLAccount.GET(AccountNo);
            PAGE.RUN(PAGE::"G/L Account Card",GLAccount);
          END;
        "Account Type"::"Bank Account":
          BEGIN
            BankAccount.GET(AccountNo);
            PAGE.RUN(PAGE::"Bank Account Card",BankAccount);
          END;
      END;
    END;

    [External]
    PROCEDURE DrillDownOnNoOfLedgerEntriesWithinAmountTolerance@21();
    BEGIN
      DrillDownOnNoOfLedgerEntriesBasedOnAmount(AmountWithinToleranceRangeTok);
    END;

    [External]
    PROCEDURE DrillDownOnNoOfLedgerEntriesOutsideOfAmountTolerance@23();
    BEGIN
      DrillDownOnNoOfLedgerEntriesBasedOnAmount(AmountOustideToleranceRangeTok);
    END;

    LOCAL PROCEDURE DrillDownOnNoOfLedgerEntriesBasedOnAmount@24(AmountFilter@1005 : Text);
    VAR
      CustLedgerEntry@1003 : Record 21;
      VendorLedgerEntry@1004 : Record 25;
      BankAccountLedgerEntry@1000 : Record 271;
      MinAmount@1001 : Decimal;
      MaxAmount@1002 : Decimal;
    BEGIN
      GetAmountRangeForTolerance(MinAmount,MaxAmount);

      CASE "Account Type" OF
        "Account Type"::Customer:
          BEGIN
            GetCustomerLedgerEntriesInAmountRange(CustLedgerEntry,"Account No.",AmountFilter,MinAmount,MaxAmount);
            PAGE.RUN(PAGE::"Customer Ledger Entries",CustLedgerEntry);
          END;
        "Account Type"::Vendor:
          BEGIN
            GetVendorLedgerEntriesInAmountRange(VendorLedgerEntry,"Account No.",AmountFilter,MinAmount,MaxAmount);
            PAGE.RUN(PAGE::"Vendor Ledger Entries",VendorLedgerEntry);
          END;
        "Account Type"::"Bank Account":
          BEGIN
            GetBankAccountLedgerEntriesInAmountRange(BankAccountLedgerEntry,AmountFilter,MinAmount,MaxAmount);
            PAGE.RUN(PAGE::"Bank Account Ledger Entries",BankAccountLedgerEntry);
          END;
      END;
    END;

    LOCAL PROCEDURE GetCustomerLedgerEntriesInAmountRange@41(VAR CustLedgerEntry@1004 : Record 21;AccountNo@1005 : Code[20];AmountFilter@1001 : Text;MinAmount@1002 : Decimal;MaxAmount@1003 : Decimal) : Integer;
    VAR
      BankAccount@1000 : Record 270;
    BEGIN
      CustLedgerEntry.SETAUTOCALCFIELDS("Remaining Amount","Remaining Amt. (LCY)");
      BankAccount.GET("Bank Account No.");
      GetApplicableCustomerLedgerEntries(CustLedgerEntry,BankAccount."Currency Code",AccountNo);

      IF BankAccount.IsInLocalCurrency THEN
        CustLedgerEntry.SETFILTER("Remaining Amt. (LCY)",AmountFilter,MinAmount,MaxAmount)
      ELSE
        CustLedgerEntry.SETFILTER("Remaining Amount",AmountFilter,MinAmount,MaxAmount);

      EXIT(CustLedgerEntry.COUNT);
    END;

    LOCAL PROCEDURE GetVendorLedgerEntriesInAmountRange@42(VAR VendorLedgerEntry@1004 : Record 25;AccountNo@1005 : Code[20];AmountFilter@1002 : Text;MinAmount@1001 : Decimal;MaxAmount@1000 : Decimal) : Integer;
    VAR
      BankAccount@1003 : Record 270;
    BEGIN
      VendorLedgerEntry.SETAUTOCALCFIELDS("Remaining Amount","Remaining Amt. (LCY)");

      BankAccount.GET("Bank Account No.");
      GetApplicableVendorLedgerEntries(VendorLedgerEntry,BankAccount."Currency Code",AccountNo);

      IF BankAccount.IsInLocalCurrency THEN
        VendorLedgerEntry.SETFILTER("Remaining Amt. (LCY)",AmountFilter,MinAmount,MaxAmount)
      ELSE
        VendorLedgerEntry.SETFILTER("Remaining Amount",AmountFilter,MinAmount,MaxAmount);

      EXIT(VendorLedgerEntry.COUNT);
    END;

    LOCAL PROCEDURE GetBankAccountLedgerEntriesInAmountRange@7(VAR BankAccountLedgerEntry@1004 : Record 271;AmountFilter@1002 : Text;MinAmount@1001 : Decimal;MaxAmount@1000 : Decimal) : Integer;
    VAR
      BankAccount@1003 : Record 270;
    BEGIN
      BankAccount.GET("Bank Account No.");
      GetApplicableBankAccountLedgerEntries(BankAccountLedgerEntry,BankAccount."Currency Code","Bank Account No.");

      BankAccountLedgerEntry.SETFILTER("Remaining Amount",AmountFilter,MinAmount,MaxAmount);

      EXIT(BankAccountLedgerEntry.COUNT);
    END;

    LOCAL PROCEDURE GetApplicableCustomerLedgerEntries@15(VAR CustLedgerEntry@1000 : Record 21;CurrencyCode@1001 : Code[10];AccountNo@1002 : Code[20]);
    BEGIN
      CustLedgerEntry.SETRANGE(Open,TRUE);
      CustLedgerEntry.SETRANGE("Applies-to ID",'');
      CustLedgerEntry.SETFILTER("Document Type",'<>%1&<>%2',
        CustLedgerEntry."Document Type"::Payment,
        CustLedgerEntry."Document Type"::Refund);

      IF CurrencyCode <> '' THEN
        CustLedgerEntry.SETRANGE("Currency Code",CurrencyCode);

      IF AccountNo <> '' THEN
        CustLedgerEntry.SETFILTER("Customer No.",AccountNo);
    END;

    LOCAL PROCEDURE GetApplicableVendorLedgerEntries@22(VAR VendorLedgerEntry@1000 : Record 25;CurrencyCode@1002 : Code[10];AccountNo@1001 : Code[20]);
    BEGIN
      VendorLedgerEntry.SETRANGE(Open,TRUE);
      VendorLedgerEntry.SETRANGE("Applies-to ID",'');
      VendorLedgerEntry.SETFILTER("Document Type",'<>%1&<>%2',
        VendorLedgerEntry."Document Type"::Payment,
        VendorLedgerEntry."Document Type"::Refund);

      IF CurrencyCode <> '' THEN
        VendorLedgerEntry.SETRANGE("Currency Code",CurrencyCode);

      IF AccountNo <> '' THEN
        VendorLedgerEntry.SETFILTER("Vendor No.",AccountNo);
    END;

    LOCAL PROCEDURE GetApplicableBankAccountLedgerEntries@11(VAR BankAccountLedgerEntry@1000 : Record 271;CurrencyCode@1002 : Code[10];AccountNo@1001 : Code[20]);
    BEGIN
      BankAccountLedgerEntry.SETRANGE(Open,TRUE);

      IF CurrencyCode <> '' THEN
        BankAccountLedgerEntry.SETRANGE("Currency Code",CurrencyCode);

      IF AccountNo <> '' THEN
        BankAccountLedgerEntry.SETRANGE("Bank Account No.",AccountNo);
    END;

    [External]
    PROCEDURE FilterBankRecLines@20(BankAccRecon@1000 : Record 273);
    BEGIN
      RESET;
      SETRANGE("Statement Type",BankAccRecon."Statement Type");
      SETRANGE("Bank Account No.",BankAccRecon."Bank Account No.");
      SETRANGE("Statement No.",BankAccRecon."Statement No.");
    END;

    [External]
    PROCEDURE LinesExist@19(BankAccRecon@1001 : Record 273) : Boolean;
    BEGIN
      FilterBankRecLines(BankAccRecon);
      EXIT(FINDSET);
    END;

    [External]
    PROCEDURE GetAppliedToDocumentNo@30() : Text;
    VAR
      ApplyType@1002 : 'Document No.,Entry No.';
    BEGIN
      EXIT(GetAppliedNo(ApplyType::"Document No."));
    END;

    [External]
    PROCEDURE GetAppliedToEntryNo@13() : Text;
    VAR
      ApplyType@1000 : 'Document No.,Entry No.';
    BEGIN
      EXIT(GetAppliedNo(ApplyType::"Entry No."));
    END;

    LOCAL PROCEDURE GetFirstAppliedToEntryNo@17() : Integer;
    VAR
      AppliedEntryNumbers@1001 : Text;
      AppliedToEntryNo@1003 : Integer;
    BEGIN
      AppliedEntryNumbers := GetAppliedToEntryNo;
      IF AppliedEntryNumbers = '' THEN
        EXIT(0);
      EVALUATE(AppliedToEntryNo,SELECTSTR(1,AppliedEntryNumbers));
      EXIT(AppliedToEntryNo);
    END;

    LOCAL PROCEDURE GetAppliedNo@32(ApplyType@1000 : 'Document No.,Entry No.') : Text;
    VAR
      AppliedPaymentEntry@1002 : Record 1294;
      AppliedNumbers@1001 : Text;
    BEGIN
      AppliedPaymentEntry.SETRANGE("Statement Type","Statement Type");
      AppliedPaymentEntry.SETRANGE("Bank Account No.","Bank Account No.");
      AppliedPaymentEntry.SETRANGE("Statement No.","Statement No.");
      AppliedPaymentEntry.SETRANGE("Statement Line No.","Statement Line No.");

      AppliedNumbers := '';
      IF AppliedPaymentEntry.FINDSET THEN BEGIN
        REPEAT
          IF ApplyType = ApplyType::"Document No." THEN BEGIN
            IF AppliedPaymentEntry."Document No." <> '' THEN
              IF AppliedNumbers = '' THEN
                AppliedNumbers := AppliedPaymentEntry."Document No."
              ELSE
                AppliedNumbers := AppliedNumbers + ', ' + AppliedPaymentEntry."Document No.";
          END ELSE BEGIN
            IF AppliedPaymentEntry."Applies-to Entry No." <> 0 THEN
              IF AppliedNumbers = '' THEN
                AppliedNumbers := FORMAT(AppliedPaymentEntry."Applies-to Entry No.")
              ELSE
                AppliedNumbers := AppliedNumbers + ', ' + FORMAT(AppliedPaymentEntry."Applies-to Entry No.");
          END;
        UNTIL AppliedPaymentEntry.NEXT = 0;
      END;

      EXIT(AppliedNumbers);
    END;

    [External]
    PROCEDURE TransferRemainingAmountToAccount@31();
    VAR
      AppliedPaymentEntry@1000 : Record 1294;
    BEGIN
      TESTFIELD("Account No.");

      AppliedPaymentEntry.TransferFromBankAccReconLine(Rec);
      AppliedPaymentEntry."Account Type" := GetAppliedToAccountType;
      AppliedPaymentEntry."Account No." := GetAppliedToAccountNo;
      AppliedPaymentEntry.VALIDATE("Applied Amount",Difference);
      AppliedPaymentEntry.VALIDATE("Match Confidence",AppliedPaymentEntry."Match Confidence"::Manual);
      AppliedPaymentEntry.INSERT(TRUE);
    END;

    [External]
    PROCEDURE GetAmountRangeForTolerance@8(VAR MinAmount@1001 : Decimal;VAR MaxAmount@1002 : Decimal);
    VAR
      BankAccount@1000 : Record 270;
      TempAmount@1003 : Decimal;
    BEGIN
      BankAccount.GET("Bank Account No.");
      CASE BankAccount."Match Tolerance Type" OF
        BankAccount."Match Tolerance Type"::Amount:
          BEGIN
            MinAmount := "Statement Amount" - BankAccount."Match Tolerance Value";
            MaxAmount := "Statement Amount" + BankAccount."Match Tolerance Value";

            IF ("Statement Amount" >= 0) AND (MinAmount < 0) THEN
              MinAmount := 0
            ELSE
              IF ("Statement Amount" < 0) AND (MaxAmount > 0) THEN
                MaxAmount := 0;
          END;
        BankAccount."Match Tolerance Type"::Percentage:
          BEGIN
            MinAmount := "Statement Amount" * (1 - BankAccount."Match Tolerance Value" / 100);
            MaxAmount := "Statement Amount" * (1 + BankAccount."Match Tolerance Value" / 100);

            IF "Statement Amount" < 0 THEN BEGIN
              TempAmount := MinAmount;
              MinAmount := MaxAmount;
              MaxAmount := TempAmount;
            END;
          END;
      END;

      MinAmount := ROUND(MinAmount);
      MaxAmount := ROUND(MaxAmount);
    END;

    [External]
    PROCEDURE GetAppliedPmtData@52(VAR AppliedPmtEntry@1000 : Record 1294;VAR RemainingAmountAfterPosting@1002 : Decimal;VAR DifferenceStatementAmtToApplEntryAmount@1001 : Decimal;PmtAppliedToTxt@1004 : Text);
    VAR
      CurrRemAmtAfterPosting@1003 : Decimal;
    BEGIN
      AppliedPmtEntry.INIT;
      RemainingAmountAfterPosting := 0;
      DifferenceStatementAmtToApplEntryAmount := 0;

      AppliedPmtEntry.FilterAppliedPmtEntry(Rec);
      AppliedPmtEntry.SETFILTER("Applies-to Entry No.",'<>0');
      IF AppliedPmtEntry.FINDSET THEN BEGIN
        DifferenceStatementAmtToApplEntryAmount := "Statement Amount";
        REPEAT
          CurrRemAmtAfterPosting :=
            AppliedPmtEntry.GetRemAmt -
            AppliedPmtEntry.GetAmtAppliedToOtherStmtLines;

          RemainingAmountAfterPosting += CurrRemAmtAfterPosting - AppliedPmtEntry."Applied Amount";
          DifferenceStatementAmtToApplEntryAmount -= CurrRemAmtAfterPosting - AppliedPmtEntry."Applied Pmt. Discount";
        UNTIL AppliedPmtEntry.NEXT = 0;
      END;

      IF "Applied Entries" > 1 THEN
        AppliedPmtEntry.Description := STRSUBSTNO(PmtAppliedToTxt,"Applied Entries");
    END;

    LOCAL PROCEDURE UpdateParentLineStatementAmount@38();
    VAR
      BankAccReconciliationLine@1000 : Record 274;
    BEGIN
      IF BankAccReconciliationLine.GET("Statement Type","Bank Account No.","Statement No.","Parent Line No.") THEN BEGIN
        BankAccReconciliationLine.VALIDATE("Statement Amount","Statement Amount" + BankAccReconciliationLine."Statement Amount");
        BankAccReconciliationLine.MODIFY(TRUE)
      END
    END;

    [External]
    PROCEDURE IsTransactionPostedAndReconciled@27() : Boolean;
    VAR
      PostedPaymentReconLine@1001 : Record 1296;
    BEGIN
      IF "Transaction ID" <> '' THEN BEGIN
        PostedPaymentReconLine.SETRANGE("Bank Account No.","Bank Account No.");
        PostedPaymentReconLine.SETRANGE("Transaction ID","Transaction ID");
        PostedPaymentReconLine.SETRANGE(Reconciled,TRUE);
        EXIT(PostedPaymentReconLine.FINDFIRST)
      END;
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE IsTransactionPostedAndNotReconciled@48() : Boolean;
    VAR
      PostedPaymentReconLine@1001 : Record 1296;
    BEGIN
      IF "Transaction ID" <> '' THEN BEGIN
        PostedPaymentReconLine.SETRANGE("Bank Account No.","Bank Account No.");
        PostedPaymentReconLine.SETRANGE("Transaction ID","Transaction ID");
        PostedPaymentReconLine.SETRANGE(Reconciled,FALSE);
        EXIT(PostedPaymentReconLine.FINDFIRST)
      END;
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE IsTransactionAlreadyImported@28() : Boolean;
    VAR
      BankAccReconciliationLine@1001 : Record 274;
    BEGIN
      IF "Transaction ID" <> '' THEN BEGIN
        BankAccReconciliationLine.SETRANGE("Statement Type","Statement Type");
        BankAccReconciliationLine.SETRANGE("Bank Account No.","Bank Account No.");
        BankAccReconciliationLine.SETRANGE("Transaction ID","Transaction ID");
        EXIT(BankAccReconciliationLine.FINDFIRST)
      END;
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE AllowImportOfPostedNotReconciledTransactions@49() : Boolean;
    VAR
      BankAccReconciliation@1000 : Record 273;
    BEGIN
      BankAccReconciliation.GET("Statement Type","Bank Account No.","Statement No.");
      IF BankAccReconciliation."Import Posted Transactions" = BankAccReconciliation."Import Posted Transactions"::" " THEN BEGIN
        BankAccReconciliation."Import Posted Transactions" := BankAccReconciliation."Import Posted Transactions"::No;
        IF GUIALLOWED THEN
          IF CONFIRM(ImportPostedTransactionsQst) THEN
            BankAccReconciliation."Import Posted Transactions" := BankAccReconciliation."Import Posted Transactions"::Yes;
        BankAccReconciliation.MODIFY;
      END;

      EXIT(BankAccReconciliation."Import Posted Transactions" = BankAccReconciliation."Import Posted Transactions"::Yes);
    END;

    [External]
    PROCEDURE CanImport@44() : Boolean;
    BEGIN
      IF IsTransactionPostedAndReconciled OR IsTransactionAlreadyImported THEN
        EXIT(FALSE);

      IF IsTransactionPostedAndNotReconciled THEN
        EXIT(AllowImportOfPostedNotReconciledTransactions);

      EXIT(TRUE);
    END;

    LOCAL PROCEDURE GetSalepersonPurchaserCode@51() : Code[20];
    VAR
      Customer@1002 : Record 18;
      Vendor@1003 : Record 23;
    BEGIN
      CASE "Account Type" OF
        "Account Type"::Customer:
          IF Customer.GET("Account No.") THEN
            EXIT(Customer."Salesperson Code");
        "Account Type"::Vendor:
          IF Vendor.GET("Account No.") THEN
            EXIT(Vendor."Purchaser Code");
      END;
    END;

    [External]
    PROCEDURE GetAppliesToID@62() : Code[50];
    VAR
      CustLedgerEntry@1001 : Record 21;
    BEGIN
      EXIT(COPYSTR(FORMAT("Statement No.") + '-' + FORMAT("Statement Line No."),1,MAXSTRLEN(CustLedgerEntry."Applies-to ID")));
    END;

    [External]
    PROCEDURE GetDescription@53() : Text[50];
    VAR
      AppliedPaymentEntry@1000 : Record 1294;
    BEGIN
      IF Description <> '' THEN
        EXIT(Description);

      AppliedPaymentEntry.FilterAppliedPmtEntry(Rec);
      AppliedPaymentEntry.SETFILTER("Applies-to Entry No.",'<>%1',0);
      IF AppliedPaymentEntry.FINDSET THEN
        IF AppliedPaymentEntry.NEXT = 0 THEN
          EXIT(AppliedPaymentEntry.Description);

      EXIT('');
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCreateDimTableIDs@164(VAR BankAccReconciliationLine@1000 : Record 274;FieldNo@1001 : Integer;TableID@1003 : ARRAY [10] OF Integer;No@1002 : ARRAY [10] OF Code[20]);
    BEGIN
    END;

    BEGIN
    END.
  }
}

