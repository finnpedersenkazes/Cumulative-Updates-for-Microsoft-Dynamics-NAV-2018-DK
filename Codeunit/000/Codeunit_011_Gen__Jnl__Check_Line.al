OBJECT Codeunit 11 Gen. Jnl.-Check Line
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    TableNo=81;
    Permissions=TableData 252=rimd;
    OnRun=BEGIN
            GLSetup.GET;
            RunCheck(Rec);
          END;

  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=kan kun v�re en ultimodato for finansposter;ENU=can only be a closing date for G/L entries';
      Text001@1001 : TextConst 'DAN=er ikke inden for den tilladte bogf�ringsperiode;ENU=is not within your range of allowed posting dates';
      Text002@1002 : TextConst 'DAN=%1 eller %2 skal v�re Finanskonto eller Bankkonto.;ENU=%1 or %2 must be G/L Account or Bank Account.';
      Text003@1003 : TextConst 'DAN=skal have samme fortegn som %1;ENU=must have the same sign as %1';
      Text004@1004 : TextConst 'DAN=Du m� ikke indtaste %1, n�r %2 er %3.;ENU=You must not specify %1 when %2 is %3.';
      Text005@1005 : TextConst 'DAN=%1 + %2 skal v�re %3.;ENU=%1 + %2 must be %3.';
      Text006@1006 : TextConst 'DAN=%1 + %2 skal v�re -%3.;ENU=%1 + %2 must be -%3.';
      Text007@1007 : TextConst 'DAN=skal v�re positiv;ENU=must be positive';
      Text008@1008 : TextConst 'DAN=skal v�re negativ;ENU=must be negative';
      Text009@1009 : TextConst 'DAN=skal have et andet fortegn end %1;ENU=must have a different sign than %1';
      Text010@1010 : TextConst 'DAN=%1 %2 og %3 %4 er ikke tilladt.;ENU=%1 %2 and %3 %4 is not allowed.';
      Text011@1011 : TextConst 'DAN=Kombinationen af dimensioner, der bliver brugt i %1 %2, %3, %4 er sp�rret. %5;ENU=The combination of dimensions used in %1 %2, %3, %4 is blocked. %5';
      Text012@1012 : TextConst 'DAN=En dimension, der bliver brugt i %1 %2, %3, %4, har for�rsaget en fejl. %5;ENU=A dimension used in %1 %2, %3, %4 has caused an error. %5';
      GLSetup@1014 : Record 98;
      UserSetup@1015 : Record 91;
      GenJnlTemplate@1020 : Record 80;
      CostAccSetup@1024 : Record 1108;
      DimMgt@1017 : Codeunit 408;
      CostAccMgt@1023 : Codeunit 1100;
      AllowPostingFrom@1018 : Date;
      AllowPostingTo@1019 : Date;
      GenJnlTemplateFound@1021 : Boolean;
      OverrideDimErr@1022 : Boolean;
      SalesDocAlreadyExistsErr@1026 : TextConst '@@@="%1 = Document Type; %2 = Document No.";DAN=Salg %1 %2 findes allerede.;ENU=Sales %1 %2 already exists.';
      PurchDocAlreadyExistsErr@1025 : TextConst '@@@="%1 = Document Type; %2 = Document No.";DAN=K�b %1 %2 findes allerede.;ENU=Purchase %1 %2 already exists.';
      IsBatchMode@1016 : Boolean;
      EmployeeBalancingDocTypeErr@1013 : TextConst 'DAN=Skal v�re tom eller angivet til Betaling, n�r feltet Modkontotype er angivet til Medarbejder;ENU=must be empty or set to Payment when Balancing Account Type field is set to Employee';
      EmployeeAccountDocTypeErr@1027 : TextConst 'DAN=Skal v�re tom eller angivet til Betaling, n�r feltet Kontotype er angivet til Medarbejder;ENU=must be empty or set to Payment when Account Type field is set to Employee';

    [External]
    PROCEDURE RunCheck@4(VAR GenJnlLine@1000 : Record 81);
    VAR
      ICGLAcount@1008 : Record 410;
    BEGIN
      WITH GenJnlLine DO BEGIN
        IF EmptyLine THEN
          EXIT;

        IF NOT GenJnlTemplateFound THEN BEGIN
          IF GenJnlTemplate.GET("Journal Template Name") THEN;
          GenJnlTemplateFound := TRUE;
        END;

        CheckDates(GenJnlLine);
        ValidateSalesPersonPurchaserCode(GenJnlLine);

        TESTFIELD("Document No.");

        IF ("Account Type" IN
            ["Account Type"::Customer,
             "Account Type"::Vendor,
             "Account Type"::"Fixed Asset",
             "Account Type"::"IC Partner"]) AND
           ("Bal. Account Type" IN
            ["Bal. Account Type"::Customer,
             "Bal. Account Type"::Vendor,
             "Bal. Account Type"::"Fixed Asset",
             "Bal. Account Type"::"IC Partner"])
        THEN
          ERROR(
            Text002,
            FIELDCAPTION("Account Type"),FIELDCAPTION("Bal. Account Type"));

        IF "Bal. Account No." = '' THEN
          TESTFIELD("Account No.");

        IF NeedCheckZeroAmount AND NOT (IsRecurring AND IsBatchMode) THEN
          TESTFIELD(Amount);

        IF ((Amount < 0) XOR ("Amount (LCY)" < 0)) AND (Amount <> 0) AND ("Amount (LCY)" <> 0) THEN
          FIELDERROR("Amount (LCY)",STRSUBSTNO(Text003,FIELDCAPTION(Amount)));

        IF ("Account Type" = "Account Type"::"G/L Account") AND
           ("Bal. Account Type" = "Bal. Account Type"::"G/L Account")
        THEN
          TESTFIELD("Applies-to Doc. No.",'');

        IF ("Recurring Method" IN
            ["Recurring Method"::"B  Balance","Recurring Method"::"RB Reversing Balance"]) AND
           ("Currency Code" <> '')
        THEN
          ERROR(
            Text004,
            FIELDCAPTION("Currency Code"),FIELDCAPTION("Recurring Method"),"Recurring Method");

        IF "Account No." <> '' THEN
          CheckAccountNo(GenJnlLine);

        IF "Bal. Account No." <> '' THEN
          CheckBalAccountNo(GenJnlLine);

        IF "IC Partner G/L Acc. No." <> '' THEN
          IF ICGLAcount.GET("IC Partner G/L Acc. No.") THEN
            ICGLAcount.TESTFIELD(Blocked,FALSE);

        IF (("Account Type" = "Account Type"::"G/L Account") AND
            ("Bal. Account Type" = "Bal. Account Type"::"G/L Account")) OR
           (("Document Type" <> "Document Type"::Invoice) AND
            (NOT
             (("Document Type" = "Document Type"::"Credit Memo") AND
              CalcPmtDiscOnCrMemos("Payment Terms Code"))))
        THEN BEGIN
          TESTFIELD("Pmt. Discount Date",0D);
          TESTFIELD("Payment Discount %",0);
        END;

        IF (("Account Type" = "Account Type"::"G/L Account") AND
            ("Bal. Account Type" = "Bal. Account Type"::"G/L Account")) OR
           ("Applies-to Doc. No." <> '')
        THEN
          TESTFIELD("Applies-to ID",'');

        IF ("Account Type" <> "Account Type"::"Bank Account") AND
           ("Bal. Account Type" <> "Bal. Account Type"::"Bank Account")
        THEN
          TESTFIELD("Bank Payment Type","Bank Payment Type"::" ");

        IF ("Account Type" = "Account Type"::"Fixed Asset") OR
           ("Bal. Account Type" = "Bal. Account Type"::"Fixed Asset")
        THEN
          CODEUNIT.RUN(CODEUNIT::"FA Jnl.-Check Line",GenJnlLine);

        IF ("Account Type" <> "Account Type"::"Fixed Asset") AND
           ("Bal. Account Type" <> "Bal. Account Type"::"Fixed Asset")
        THEN BEGIN
          TESTFIELD("Depreciation Book Code",'');
          TESTFIELD("FA Posting Type",0);
        END;

        IF NOT OverrideDimErr THEN
          CheckDimensions(GenJnlLine);
      END;

      IF CostAccSetup.GET THEN
        CostAccMgt.CheckValidCCAndCOInGLEntry(GenJnlLine."Dimension Set ID");

      OnAfterCheckGenJnlLine(GenJnlLine);
    END;

    LOCAL PROCEDURE CalcPmtDiscOnCrMemos@9(PaymentTermsCode@1000 : Code[10]) : Boolean;
    VAR
      PaymentTerms@1001 : Record 3;
    BEGIN
      IF PaymentTermsCode <> '' THEN BEGIN
        PaymentTerms.GET(PaymentTermsCode);
        EXIT(PaymentTerms."Calc. Pmt. Disc. on Cr. Memos");
      END;
    END;

    [External]
    PROCEDURE DateNotAllowed@1(PostingDate@1000 : Date) : Boolean;
    BEGIN
      IF (AllowPostingFrom = 0D) AND (AllowPostingTo = 0D) THEN BEGIN
        IF USERID <> '' THEN
          IF UserSetup.GET(USERID) THEN BEGIN
            AllowPostingFrom := UserSetup."Allow Posting From";
            AllowPostingTo := UserSetup."Allow Posting To";
          END;
        IF (AllowPostingFrom = 0D) AND (AllowPostingTo = 0D) THEN BEGIN
          GLSetup.GET;
          AllowPostingFrom := GLSetup."Allow Posting From";
          AllowPostingTo := GLSetup."Allow Posting To";
        END;
        IF AllowPostingTo = 0D THEN
          AllowPostingTo := DMY2DATE(31,12,9999);
      END;
      EXIT((PostingDate < AllowPostingFrom) OR (PostingDate > AllowPostingTo));
    END;

    LOCAL PROCEDURE ErrorIfPositiveAmt@2(GenJnlLine@1000 : Record 81);
    BEGIN
      IF GenJnlLine.Amount > 0 THEN
        GenJnlLine.FIELDERROR(Amount,Text008);
    END;

    LOCAL PROCEDURE ErrorIfNegativeAmt@3(GenJnlLine@1000 : Record 81);
    BEGIN
      IF GenJnlLine.Amount < 0 THEN
        GenJnlLine.FIELDERROR(Amount,Text007);
    END;

    [External]
    PROCEDURE SetOverDimErr@5();
    BEGIN
      OverrideDimErr := TRUE;
    END;

    LOCAL PROCEDURE CheckDates@14(GenJnlLine@1000 : Record 81);
    VAR
      AccountingPeriod@1001 : Record 50;
      DateCheckDone@1002 : Boolean;
    BEGIN
      WITH GenJnlLine DO BEGIN
        TESTFIELD("Posting Date");
        IF "Posting Date" <> NORMALDATE("Posting Date") THEN BEGIN
          IF ("Account Type" <> "Account Type"::"G/L Account") OR
             ("Bal. Account Type" <> "Bal. Account Type"::"G/L Account")
          THEN
            FIELDERROR("Posting Date",Text000);
          AccountingPeriod.GET(NORMALDATE("Posting Date") + 1);
          AccountingPeriod.TESTFIELD("New Fiscal Year",TRUE);
          AccountingPeriod.TESTFIELD("Date Locked",TRUE);
        END;

        OnBeforeDateNotAllowed(GenJnlLine,DateCheckDone);
        IF NOT DateCheckDone THEN
          IF DateNotAllowed("Posting Date") THEN
            FIELDERROR("Posting Date",Text001);

        IF "Document Date" <> 0D THEN
          IF ("Document Date" <> NORMALDATE("Document Date")) AND
             (("Account Type" <> "Account Type"::"G/L Account") OR
              ("Bal. Account Type" <> "Bal. Account Type"::"G/L Account"))
          THEN
            FIELDERROR("Document Date",Text000);
      END;
    END;

    LOCAL PROCEDURE CheckAccountNo@10(GenJnlLine@1000 : Record 81);
    VAR
      ICPartner@1001 : Record 413;
      CheckDone@1002 : Boolean;
    BEGIN
      OnBeforeCheckAccountNo(GenJnlLine,CheckDone);
      IF CheckDone THEN
        EXIT;

      WITH GenJnlLine DO
        CASE "Account Type" OF
          "Account Type"::"G/L Account":
            BEGIN
              IF ("Gen. Bus. Posting Group" <> '') OR ("Gen. Prod. Posting Group" <> '') OR
                 ("VAT Bus. Posting Group" <> '') OR ("VAT Prod. Posting Group" <> '')
              THEN
                TESTFIELD("Gen. Posting Type");
              IF ("Gen. Posting Type" <> "Gen. Posting Type"::" ") AND
                 ("VAT Posting" = "VAT Posting"::"Automatic VAT Entry")
              THEN BEGIN
                IF "VAT Amount" + "VAT Base Amount" <> Amount THEN
                  ERROR(
                    Text005,FIELDCAPTION("VAT Amount"),FIELDCAPTION("VAT Base Amount"),
                    FIELDCAPTION(Amount));
                IF "Currency Code" <> '' THEN
                  IF "VAT Amount (LCY)" + "VAT Base Amount (LCY)" <> "Amount (LCY)" THEN
                    ERROR(
                      Text005,FIELDCAPTION("VAT Amount (LCY)"),
                      FIELDCAPTION("VAT Base Amount (LCY)"),FIELDCAPTION("Amount (LCY)"));
              END;
            END;
          "Account Type"::Customer,"Account Type"::Vendor,"Account Type"::Employee:
            BEGIN
              TESTFIELD("Gen. Posting Type",0);
              TESTFIELD("Gen. Bus. Posting Group",'');
              TESTFIELD("Gen. Prod. Posting Group",'');
              TESTFIELD("VAT Bus. Posting Group",'');
              TESTFIELD("VAT Prod. Posting Group",'');

              IF (("Account Type" = "Account Type"::Customer) AND
                  ("Bal. Gen. Posting Type" = "Bal. Gen. Posting Type"::Purchase)) OR
                 (("Account Type" = "Account Type"::Vendor) AND
                  ("Bal. Gen. Posting Type" = "Bal. Gen. Posting Type"::Sale))
              THEN
                ERROR(
                  STRSUBSTNO(
                    Text010,
                    FIELDCAPTION("Account Type"),"Account Type",
                    FIELDCAPTION("Bal. Gen. Posting Type"),"Bal. Gen. Posting Type"));

              CheckDocType(GenJnlLine);

              IF NOT "System-Created Entry" AND
                 (((Amount < 0) XOR ("Sales/Purch. (LCY)" < 0)) AND (Amount <> 0) AND ("Sales/Purch. (LCY)" <> 0))
              THEN
                FIELDERROR("Sales/Purch. (LCY)",STRSUBSTNO(Text003,FIELDCAPTION(Amount)));
              TESTFIELD("Job No.",'');

              CheckICPartner("Account Type","Account No.","Document Type");
            END;
          "Account Type"::"Bank Account":
            BEGIN
              TESTFIELD("Gen. Posting Type",0);
              TESTFIELD("Gen. Bus. Posting Group",'');
              TESTFIELD("Gen. Prod. Posting Group",'');
              TESTFIELD("VAT Bus. Posting Group",'');
              TESTFIELD("VAT Prod. Posting Group",'');
              TESTFIELD("Job No.",'');
              IF (Amount < 0) AND ("Bank Payment Type" = "Bank Payment Type"::"Computer Check") THEN
                TESTFIELD("Check Printed",TRUE);
              IF ("Bank Payment Type" = "Bank Payment Type"::"Electronic Payment") OR
                 ("Bank Payment Type" = "Bank Payment Type"::"Electronic Payment-IAT")
              THEN BEGIN
                TESTFIELD("Exported to Payment File",TRUE);
                TESTFIELD("Check Transmitted",TRUE);
              END;
            END;
          "Account Type"::"IC Partner":
            BEGIN
              ICPartner.GET("Account No.");
              ICPartner.CheckICPartner;
              IF "Journal Template Name" <> '' THEN
                IF GenJnlTemplate.Type <> GenJnlTemplate.Type::Intercompany THEN
                  FIELDERROR("Account Type");
            END;
        END;
    END;

    LOCAL PROCEDURE CheckBalAccountNo@13(GenJnlLine@1000 : Record 81);
    VAR
      ICPartner@1001 : Record 413;
      CheckDone@1002 : Boolean;
    BEGIN
      OnBeforeCheckBalAccountNo(GenJnlLine,CheckDone);
      IF CheckDone THEN
        EXIT;

      WITH GenJnlLine DO
        CASE "Bal. Account Type" OF
          "Bal. Account Type"::"G/L Account":
            BEGIN
              IF ("Bal. Gen. Bus. Posting Group" <> '') OR ("Bal. Gen. Prod. Posting Group" <> '') OR
                 ("Bal. VAT Bus. Posting Group" <> '') OR ("Bal. VAT Prod. Posting Group" <> '')
              THEN
                TESTFIELD("Bal. Gen. Posting Type");
              IF ("Bal. Gen. Posting Type" <> "Bal. Gen. Posting Type"::" ") AND
                 ("VAT Posting" = "VAT Posting"::"Automatic VAT Entry")
              THEN BEGIN
                IF "Bal. VAT Amount" + "Bal. VAT Base Amount" <> -Amount THEN
                  ERROR(
                    Text006,FIELDCAPTION("Bal. VAT Amount"),FIELDCAPTION("Bal. VAT Base Amount"),
                    FIELDCAPTION(Amount));
                IF "Currency Code" <> '' THEN
                  IF "Bal. VAT Amount (LCY)" + "Bal. VAT Base Amount (LCY)" <> -"Amount (LCY)" THEN
                    ERROR(
                      Text006,FIELDCAPTION("Bal. VAT Amount (LCY)"),
                      FIELDCAPTION("Bal. VAT Base Amount (LCY)"),FIELDCAPTION("Amount (LCY)"));
              END;
            END;
          "Bal. Account Type"::Customer,"Bal. Account Type"::Vendor,"Bal. Account Type"::Employee:
            BEGIN
              TESTFIELD("Bal. Gen. Posting Type",0);
              TESTFIELD("Bal. Gen. Bus. Posting Group",'');
              TESTFIELD("Bal. Gen. Prod. Posting Group",'');
              TESTFIELD("Bal. VAT Bus. Posting Group",'');
              TESTFIELD("Bal. VAT Prod. Posting Group",'');

              IF (("Bal. Account Type" = "Bal. Account Type"::Customer) AND
                  ("Gen. Posting Type" = "Gen. Posting Type"::Purchase)) OR
                 (("Bal. Account Type" = "Bal. Account Type"::Vendor) AND
                  ("Gen. Posting Type" = "Gen. Posting Type"::Sale))
              THEN
                ERROR(
                  STRSUBSTNO(
                    Text010,
                    FIELDCAPTION("Bal. Account Type"),"Bal. Account Type",
                    FIELDCAPTION("Gen. Posting Type"),"Gen. Posting Type"));

              CheckBalDocType(GenJnlLine);

              IF ((Amount > 0) XOR ("Sales/Purch. (LCY)" < 0)) AND (Amount <> 0) AND ("Sales/Purch. (LCY)" <> 0) THEN
                FIELDERROR("Sales/Purch. (LCY)",STRSUBSTNO(Text009,FIELDCAPTION(Amount)));
              TESTFIELD("Job No.",'');

              CheckICPartner("Bal. Account Type","Bal. Account No.","Document Type");
            END;
          "Bal. Account Type"::"Bank Account":
            BEGIN
              TESTFIELD("Bal. Gen. Posting Type",0);
              TESTFIELD("Bal. Gen. Bus. Posting Group",'');
              TESTFIELD("Bal. Gen. Prod. Posting Group",'');
              TESTFIELD("Bal. VAT Bus. Posting Group",'');
              TESTFIELD("Bal. VAT Prod. Posting Group",'');
              IF (Amount > 0) AND ("Bank Payment Type" = "Bank Payment Type"::"Computer Check") THEN
                TESTFIELD("Check Printed",TRUE);
              IF ("Bank Payment Type" = "Bank Payment Type"::"Electronic Payment") OR
                 ("Bank Payment Type" = "Bank Payment Type"::"Electronic Payment-IAT")
              THEN BEGIN
                TESTFIELD("Exported to Payment File",TRUE);
                TESTFIELD("Check Transmitted",TRUE);
              END;
            END;
          "Bal. Account Type"::"IC Partner":
            BEGIN
              ICPartner.GET("Bal. Account No.");
              ICPartner.CheckICPartner;
              IF GenJnlTemplate.Type <> GenJnlTemplate.Type::Intercompany THEN
                FIELDERROR("Bal. Account Type");
            END;
        END;
    END;

    [External]
    PROCEDURE CheckSalesDocNoIsNotUsed@115(DocType@1000 : Option;DocNo@1001 : Code[20]);
    VAR
      OldCustLedgEntry@1002 : Record 21;
    BEGIN
      OldCustLedgEntry.SETRANGE("Document No.",DocNo);
      OldCustLedgEntry.SETRANGE("Document Type",DocType);
      IF OldCustLedgEntry.FINDFIRST THEN
        ERROR(SalesDocAlreadyExistsErr,OldCustLedgEntry."Document Type",DocNo);
    END;

    [External]
    PROCEDURE CheckPurchDocNoIsNotUsed@107(DocType@1000 : Option;DocNo@1002 : Code[20]);
    VAR
      OldVendLedgEntry@1001 : Record 25;
    BEGIN
      OldVendLedgEntry.SETRANGE("Document No.",DocNo);
      OldVendLedgEntry.SETRANGE("Document Type",DocType);
      IF OldVendLedgEntry.FINDFIRST THEN
        ERROR(PurchDocAlreadyExistsErr,OldVendLedgEntry."Document Type",DocNo);
    END;

    LOCAL PROCEDURE CheckDocType@7(GenJnlLine@1001 : Record 81);
    VAR
      IsPayment@1000 : Boolean;
    BEGIN
      WITH GenJnlLine DO
        IF "Document Type" <> 0 THEN BEGIN
          IF ("Account Type" = "Account Type"::Employee) AND NOT
             ("Document Type" IN ["Document Type"::Payment,"Document Type"::" "])
          THEN
            FIELDERROR("Document Type",EmployeeAccountDocTypeErr);

          IsPayment := "Document Type" IN ["Document Type"::Payment,"Document Type"::"Credit Memo"];
          IF IsPayment XOR (("Account Type" = "Account Type"::Customer) XOR IsVendorPaymentToCrMemo(GenJnlLine)) THEN
            ErrorIfNegativeAmt(GenJnlLine)
          ELSE
            ErrorIfPositiveAmt(GenJnlLine);
        END;
    END;

    LOCAL PROCEDURE CheckBalDocType@19(GenJnlLine@1000 : Record 81);
    VAR
      IsPayment@1001 : Boolean;
    BEGIN
      WITH GenJnlLine DO
        IF "Document Type" <> 0 THEN BEGIN
          IF ("Bal. Account Type" = "Bal. Account Type"::Employee) AND NOT
             ("Document Type" IN ["Document Type"::Payment,"Document Type"::" "])
          THEN
            FIELDERROR("Document Type",EmployeeBalancingDocTypeErr);

          IsPayment := "Document Type" IN ["Document Type"::Payment,"Document Type"::"Credit Memo"];
          IF IsPayment = ("Bal. Account Type" = "Bal. Account Type"::Customer) THEN
            ErrorIfNegativeAmt(GenJnlLine)
          ELSE
            ErrorIfPositiveAmt(GenJnlLine);
        END;
    END;

    LOCAL PROCEDURE CheckICPartner@11(AccountType@1004 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee';AccountNo@1000 : Code[20];DocumentType@1005 : Option);
    VAR
      Customer@1001 : Record 18;
      Vendor@1002 : Record 23;
      ICPartner@1003 : Record 413;
      Employee@1007 : Record 5200;
      CheckDone@1006 : Boolean;
    BEGIN
      OnBeforeCheckICPartner(AccountType,AccountNo,DocumentType,CheckDone);
      IF CheckDone THEN
        EXIT;

      CASE AccountType OF
        AccountType::Customer:
          IF Customer.GET(AccountNo) THEN BEGIN
            Customer.CheckBlockedCustOnJnls(Customer,DocumentType,TRUE);
            IF (Customer."IC Partner Code" <> '') AND (GenJnlTemplate.Type = GenJnlTemplate.Type::Intercompany) AND
               ICPartner.GET(Customer."IC Partner Code")
            THEN
              ICPartner.CheckICPartnerIndirect(FORMAT(AccountType),AccountNo);
          END;
        AccountType::Vendor:
          IF Vendor.GET(AccountNo) THEN BEGIN
            Vendor.CheckBlockedVendOnJnls(Vendor,DocumentType,TRUE);
            IF (Vendor."IC Partner Code" <> '') AND (GenJnlTemplate.Type = GenJnlTemplate.Type::Intercompany) AND
               ICPartner.GET(Vendor."IC Partner Code")
            THEN
              ICPartner.CheckICPartnerIndirect(FORMAT(AccountType),AccountNo);
          END;
        AccountType::Employee:
          IF Employee.GET(AccountNo) THEN
            Employee.CheckBlockedEmployeeOnJnls(TRUE)
      END;
    END;

    LOCAL PROCEDURE CheckDimensions@12(GenJnlLine@1000 : Record 81);
    VAR
      TableID@1002 : ARRAY [10] OF Integer;
      No@1001 : ARRAY [10] OF Code[20];
      CheckDone@1003 : Boolean;
    BEGIN
      OnBeforeCheckDimensions(GenJnlLine,CheckDone);
      IF CheckDone THEN
        EXIT;

      WITH GenJnlLine DO BEGIN
        IF NOT DimMgt.CheckDimIDComb("Dimension Set ID") THEN
          ThrowGenJnlLineError(GenJnlLine,Text011,DimMgt.GetDimCombErr);

        TableID[1] := DimMgt.TypeToTableID1("Account Type");
        No[1] := "Account No.";
        TableID[2] := DimMgt.TypeToTableID1("Bal. Account Type");
        No[2] := "Bal. Account No.";
        TableID[3] := DATABASE::Job;
        No[3] := "Job No.";
        TableID[4] := DATABASE::"Salesperson/Purchaser";
        No[4] := "Salespers./Purch. Code";
        TableID[5] := DATABASE::Campaign;
        No[5] := "Campaign No.";
        IF NOT DimMgt.CheckDimValuePosting(TableID,No,"Dimension Set ID") THEN
          ThrowGenJnlLineError(GenJnlLine,Text012,DimMgt.GetDimValuePostingErr);
      END;
    END;

    LOCAL PROCEDURE IsVendorPaymentToCrMemo@26(GenJournalLine@1002 : Record 81) : Boolean;
    VAR
      GenJournalTemplate@1001 : Record 80;
    BEGIN
      WITH GenJournalLine DO BEGIN
        IF ("Account Type" = "Account Type"::Vendor) AND
           ("Document Type" = "Document Type"::Payment) AND
           ("Applies-to Doc. Type" = "Applies-to Doc. Type"::"Credit Memo") AND
           ("Applies-to Doc. No." <> '') AND
           (("Bal. Account No." <> '') OR "Check Printed")
        THEN BEGIN
          GenJournalTemplate.GET("Journal Template Name");
          EXIT(GenJournalTemplate.Type = GenJournalTemplate.Type::Payments);
        END;
        EXIT(FALSE);
      END;
    END;

    LOCAL PROCEDURE ThrowGenJnlLineError@8(GenJournalLine@1000 : Record 81;ErrorTemplate@1001 : Text;ErrorText@1002 : Text);
    BEGIN
      WITH GenJournalLine DO
        IF "Line No." <> 0 THEN
          ERROR(
            ErrorTemplate,
            TABLECAPTION,"Journal Template Name","Journal Batch Name","Line No.",
            ErrorText);
      ERROR(ErrorText);
    END;

    [External]
    PROCEDURE SetBatchMode@30(NewBatchMode@1000 : Boolean);
    BEGIN
      IsBatchMode := NewBatchMode;
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCheckGenJnlLine@6(VAR GenJournalLine@1000 : Record 81);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeDateNotAllowed@15(GenJnlLine@1000 : Record 81;VAR DateCheckDone@1001 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeCheckAccountNo@18(VAR GenJnlLine@1001 : Record 81;VAR CheckDone@1000 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeCheckBalAccountNo@20(VAR GenJnlLine@1001 : Record 81;VAR CheckDone@1000 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeCheckDimensions@17(VAR GenJnlLine@1001 : Record 81;VAR CheckDone@1000 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeCheckICPartner@22(AccountType@1003 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';AccountNo@1002 : Code[20];DocumentType@1001 : Option;VAR CheckDone@1000 : Boolean);
    BEGIN
    END;

    BEGIN
    END.
  }
}

