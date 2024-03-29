OBJECT Codeunit 100 Calc. G/L Acc. Where-Used
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      GLAccWhereUsed@1000 : TEMPORARY Record 180;
      NextEntryNo@1001 : Integer;
      Text000@1002 : TextConst 'DAN=Opdateringen er afbrudt p� grund af advarslen.;ENU=The update has been interrupted to respect the warning.';
      Key@1004 : ARRAY [8] OF Text[50];
      Text002@1005 : TextConst 'DAN=Du kan ikke slette en %1, som bruges i et eller flere ops�tningsvinduer.\;ENU=You cannot delete a %1 that is used in one or more setup windows.\';
      Text003@1006 : TextConst 'DAN=Vil du �bne vinduet Finanskonto - indg�r-i-liste?;ENU=Do you want to open the G/L Account No. Where-Used List Window?';

    [External]
    PROCEDURE ShowSetupForm@8(GLAccWhereUsed@1000 : Record 180);
    VAR
      Currency@1002 : Record 4;
      GenJnlTemplate@1013 : Record 80;
      GenJnlBatch@1014 : Record 232;
      CustPostingGr@1004 : Record 92;
      VendPostingGr@1005 : Record 93;
      JobPostingGr@1006 : Record 208;
      GenJnlAlloc@1007 : Record 221;
      GenPostingSetup@1001 : Record 252;
      BankAccPostingGr@1008 : Record 277;
      VATPostingSetup@1009 : Record 325;
      FAPostingGr@1010 : Record 5606;
      FAAlloc@1003 : Record 5615;
      InventoryPostingSetup@1011 : Record 5813;
      ServiceContractAccGr@1012 : Record 5973;
      ICPartner@1015 : Record 413;
      PaymentMethod@1016 : Record 289;
    BEGIN
      WITH GLAccWhereUsed DO
        CASE "Table ID" OF
          DATABASE::Currency:
            BEGIN
              Currency.Code := COPYSTR("Key 1",1,MAXSTRLEN(Currency.Code));
              PAGE.RUN(0,Currency);
            END;
          DATABASE::"Gen. Journal Template":
            BEGIN
              GenJnlTemplate.Name := COPYSTR("Key 1",1,MAXSTRLEN(GenJnlTemplate.Name));
              PAGE.RUN(PAGE::"General Journal Templates",GenJnlTemplate);
            END;
          DATABASE::"Gen. Journal Batch":
            BEGIN
              GenJnlBatch."Journal Template Name" := COPYSTR("Key 1",1,MAXSTRLEN(GenJnlBatch."Journal Template Name"));
              GenJnlBatch.Name := COPYSTR("Key 2",1,MAXSTRLEN(GenJnlBatch.Name));
              GenJnlBatch.SETRANGE("Journal Template Name",GenJnlBatch."Journal Template Name");
              PAGE.RUN(0,GenJnlBatch);
            END;
          DATABASE::"Customer Posting Group":
            BEGIN
              CustPostingGr.Code := COPYSTR("Key 1",1,MAXSTRLEN(CustPostingGr.Code));
              PAGE.RUN(0,CustPostingGr);
            END;
          DATABASE::"Vendor Posting Group":
            BEGIN
              VendPostingGr.Code := COPYSTR("Key 1",1,MAXSTRLEN(VendPostingGr.Code));
              PAGE.RUN(0,VendPostingGr);
            END;
          DATABASE::"Job Posting Group":
            BEGIN
              JobPostingGr.Code := COPYSTR("Key 1",1,MAXSTRLEN(JobPostingGr.Code));
              PAGE.RUN(0,JobPostingGr);
            END;
          DATABASE::"Gen. Jnl. Allocation":
            BEGIN
              GenJnlAlloc."Journal Template Name" := COPYSTR("Key 1",1,MAXSTRLEN(GenJnlAlloc."Journal Template Name"));
              GenJnlAlloc."Journal Batch Name" := COPYSTR("Key 2",1,MAXSTRLEN(GenJnlAlloc."Journal Batch Name"));
              EVALUATE(GenJnlAlloc."Journal Line No.","Key 3");
              EVALUATE(GenJnlAlloc."Line No.","Key 4");
              GenJnlAlloc.SETRANGE("Journal Template Name",GenJnlAlloc."Journal Template Name");
              GenJnlAlloc.SETRANGE("Journal Batch Name",GenJnlAlloc."Journal Batch Name");
              GenJnlAlloc.SETRANGE("Journal Line No.",GenJnlAlloc."Journal Line No.");
              PAGE.RUN(PAGE::Allocations,GenJnlAlloc);
            END;
          DATABASE::"General Posting Setup":
            BEGIN
              GenPostingSetup."Gen. Bus. Posting Group" :=
                COPYSTR("Key 1",1,MAXSTRLEN(GenPostingSetup."Gen. Bus. Posting Group"));
              GenPostingSetup."Gen. Prod. Posting Group" :=
                COPYSTR("Key 2",1,MAXSTRLEN(GenPostingSetup."Gen. Prod. Posting Group"));
              PAGE.RUN(0,GenPostingSetup);
            END;
          DATABASE::"Bank Account Posting Group":
            BEGIN
              BankAccPostingGr.Code := COPYSTR("Key 1",1,MAXSTRLEN(BankAccPostingGr.Code));
              PAGE.RUN(0,BankAccPostingGr);
            END;
          DATABASE::"VAT Posting Setup":
            BEGIN
              VATPostingSetup."VAT Bus. Posting Group" :=
                COPYSTR("Key 1",1,MAXSTRLEN(VATPostingSetup."VAT Bus. Posting Group"));
              VATPostingSetup."VAT Prod. Posting Group" :=
                COPYSTR("Key 2",1,MAXSTRLEN(VATPostingSetup."VAT Prod. Posting Group"));
              PAGE.RUN(0,VATPostingSetup);
            END;
          DATABASE::"FA Posting Group":
            BEGIN
              FAPostingGr.Code := COPYSTR("Key 1",1,MAXSTRLEN(FAPostingGr.Code));
              PAGE.RUN(PAGE::"FA Posting Group Card",FAPostingGr);
            END;
          DATABASE::"FA Allocation":
            BEGIN
              FAAlloc.Code := COPYSTR("Key 1",1,MAXSTRLEN(FAAlloc.Code));
              EVALUATE(FAAlloc."Allocation Type","Key 2");
              EVALUATE(FAAlloc."Line No.","Key 3");
              FAAlloc.SETRANGE(Code,FAAlloc.Code);
              FAAlloc.SETRANGE("Allocation Type",FAAlloc."Allocation Type");
              PAGE.RUN(0,FAAlloc);
            END;
          DATABASE::"Inventory Posting Setup":
            BEGIN
              InventoryPostingSetup."Location Code" := COPYSTR("Key 1",1,MAXSTRLEN(InventoryPostingSetup."Location Code"));
              InventoryPostingSetup."Invt. Posting Group Code" :=
                COPYSTR("Key 2",1,MAXSTRLEN(InventoryPostingSetup."Invt. Posting Group Code"));
              PAGE.RUN(PAGE::"Inventory Posting Setup",InventoryPostingSetup);
            END;
          DATABASE::"Service Contract Account Group":
            BEGIN
              ServiceContractAccGr.Code := COPYSTR("Key 1",1,MAXSTRLEN(ServiceContractAccGr.Code));
              PAGE.RUN(0,ServiceContractAccGr);
            END;
          DATABASE::"IC Partner":
            BEGIN
              ICPartner.Code := COPYSTR("Key 1",1,MAXSTRLEN(ICPartner.Code));
              PAGE.RUN(0,ICPartner);
            END;
          DATABASE::"Payment Method":
            BEGIN
              PaymentMethod.Code := COPYSTR("Key 1",1,MAXSTRLEN(PaymentMethod.Code));
              PAGE.RUN(0,PaymentMethod);
            END;
        END;
    END;

    [External]
    PROCEDURE DeleteGLNo@14(GLAccNo@1000 : Code[20]) : Boolean;
    VAR
      GLSetup@1001 : Record 98;
      GLAcc@1002 : Record 15;
    BEGIN
      GLSetup.GET;
      IF GLSetup."Check G/L Account Usage" THEN BEGIN
        CheckPostingGroups(GLAccNo);
        IF GLAccWhereUsed.FINDFIRST THEN BEGIN
          COMMIT;
          IF CONFIRM(Text002 + Text003,TRUE,GLAcc.TABLECAPTION) THEN
            ShowGLAccWhereUsed;
          ERROR(Text000);
        END;
      END;
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE CheckGLAcc@5(GLAccNo@1000 : Code[20]);
    BEGIN
      CheckPostingGroups(GLAccNo);
      ShowGLAccWhereUsed;
    END;

    LOCAL PROCEDURE ShowGLAccWhereUsed@3();
    BEGIN
      GLAccWhereUsed.SETCURRENTKEY("Table Name");
      PAGE.RUNMODAL(0,GLAccWhereUsed);
    END;

    PROCEDURE InsertGroupForRecord@28(VAR TempGLAccountWhereUsed@1006 : TEMPORARY Record 180;TableID@1005 : Integer;TableCaption@1004 : Text[80];GLAccNo@1003 : Code[20];GLAccNo2@1002 : Code[20];FieldCaption@1001 : Text[80];Key@1000 : ARRAY [8] OF Text[80]);
    BEGIN
      TempGLAccountWhereUsed."Table ID" := TableID;
      TempGLAccountWhereUsed."Table Name" := TableCaption;
      GLAccWhereUsed.COPY(TempGLAccountWhereUsed,TRUE);
      InsertGroup(GLAccNo,GLAccNo2,FieldCaption,Key);
    END;

    LOCAL PROCEDURE InsertGroup@10(GLAccNo@1000 : Code[20];GLAccNo2@1001 : Code[20];FieldCaption@1003 : Text[80];Key@1002 : ARRAY [8] OF Text[80]);
    BEGIN
      IF GLAccNo = GLAccNo2 THEN BEGIN
        IF NextEntryNo = 0 THEN
          NextEntryNo := GetWhereUsedNextEntryNo;

        GLAccWhereUsed."Field Name" := FieldCaption;
        IF Key[1] <> '' THEN
          GLAccWhereUsed.Line := Key[1] + '=' + Key[4]
        ELSE
          GLAccWhereUsed.Line := '';
        IF Key[2] <> '' THEN
          GLAccWhereUsed.Line := GLAccWhereUsed.Line + ', ' + Key[2] + '=' + Key[5];
        IF Key[3] <> '' THEN
          GLAccWhereUsed.Line := GLAccWhereUsed.Line + ', ' + Key[3] + '=' + Key[6];
        IF Key[7] <> '' THEN
          GLAccWhereUsed.Line := GLAccWhereUsed.Line + ', ' + Key[7] + '=' + Key[8];
        GLAccWhereUsed."Entry No." := NextEntryNo;
        GLAccWhereUsed."Key 1" := COPYSTR(Key[4],1,MAXSTRLEN(GLAccWhereUsed."Key 1"));
        GLAccWhereUsed."Key 2" := COPYSTR(Key[5],1,MAXSTRLEN(GLAccWhereUsed."Key 2"));
        GLAccWhereUsed."Key 3" := COPYSTR(Key[6],1,MAXSTRLEN(GLAccWhereUsed."Key 3"));
        GLAccWhereUsed."Key 4" := COPYSTR(Key[8],1,MAXSTRLEN(GLAccWhereUsed."Key 4"));
        NextEntryNo := NextEntryNo + 1;
        GLAccWhereUsed.INSERT;
      END;
    END;

    LOCAL PROCEDURE CheckPostingGroups@18(GLAccNo@1000 : Code[20]);
    VAR
      GLAcc@1001 : Record 15;
    BEGIN
      NextEntryNo := 0;
      CLEAR(GLAccWhereUsed);
      GLAccWhereUsed.DELETEALL;
      GLAcc.GET(GLAccNo);
      GLAccWhereUsed."G/L Account No." := GLAccNo;
      GLAccWhereUsed."G/L Account Name" := GLAcc.Name;
      CheckCurrency(GLAccNo);
      CheckGenJnlTemplate(GLAccNo);
      CheckGenJnlBatch(GLAccNo);
      CheckCustPostingGr(GLAccNo);
      CheckVendPostingGr(GLAccNo);
      CheckJobPostingGr(GLAccNo);
      CheckGenJnlAlloc(GLAccNo);
      CheckGenPostingSetup(GLAccNo);
      CheckBankAccPostingGr(GLAccNo);
      CheckVATPostingSetup(GLAccNo);
      CheckFAPostingGr(GLAccNo);
      CheckFAAllocation(GLAccNo);
      CheckInventoryPostingSetup(GLAccNo);
      CheckServiceContractAccGr(GLAccNo);
      CheckICPartner(GLAccNo);
      CheckPaymentMethod(GLAccNo);
      CheckSalesReceivablesSetup(GLAccNo);
      CheckEmployeePostingGroup(GLAccNo);

      OnAfterCheckPostingGroups(GLAccWhereUsed,GLAccNo);
    END;

    LOCAL PROCEDURE CheckCurrency@6(GLAccNo@1000 : Code[20]);
    VAR
      Currency@1001 : Record 4;
    BEGIN
      CLEAR(Key);
      GLAccWhereUsed."Table ID" := DATABASE::Currency;
      GLAccWhereUsed."Table Name" := Currency.TABLECAPTION;
      WITH Currency DO BEGIN
        Key[1] := FIELDCAPTION(Code);
        IF FIND('-') THEN
          REPEAT
            Key[4] := Code;
            InsertGroup(GLAccNo,"Unrealized Gains Acc.",FIELDCAPTION("Unrealized Gains Acc."),Key);
            InsertGroup(GLAccNo,"Realized Gains Acc.",FIELDCAPTION("Realized Gains Acc."),Key);
            InsertGroup(GLAccNo,"Unrealized Losses Acc.",FIELDCAPTION("Unrealized Losses Acc."),Key);
            InsertGroup(GLAccNo,"Realized Losses Acc.",FIELDCAPTION("Realized Losses Acc."),Key);
            InsertGroup(GLAccNo,"Realized G/L Losses Account",FIELDCAPTION("Realized G/L Losses Account"),Key);
            InsertGroup(GLAccNo,"Realized G/L Gains Account",FIELDCAPTION("Realized G/L Gains Account"),Key);
            InsertGroup(GLAccNo,"Residual Gains Account",FIELDCAPTION("Residual Gains Account"),Key);
            InsertGroup(GLAccNo,"Residual Losses Account",FIELDCAPTION("Residual Losses Account"),Key);
            InsertGroup(GLAccNo,"Conv. LCY Rndg. Debit Acc.",FIELDCAPTION("Conv. LCY Rndg. Debit Acc."),Key);
            InsertGroup(GLAccNo,"Conv. LCY Rndg. Credit Acc.",FIELDCAPTION("Conv. LCY Rndg. Credit Acc."),Key);
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE CheckGenJnlTemplate@4(GLAccNo@1000 : Code[20]);
    VAR
      GenJnlTemplate@1001 : Record 80;
    BEGIN
      CLEAR(Key);
      GLAccWhereUsed."Table ID" := DATABASE::"Gen. Journal Template";
      GLAccWhereUsed."Table Name" := GenJnlTemplate.TABLECAPTION;
      WITH GenJnlTemplate DO BEGIN
        Key[1] := FIELDCAPTION(Name);
        IF FIND('-') THEN
          REPEAT
            Key[4] := Name;
            IF "Bal. Account Type" = "Bal. Account Type"::"G/L Account" THEN
              InsertGroup(GLAccNo,"Bal. Account No.",FIELDCAPTION("Bal. Account No."),Key);
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE CheckGenJnlBatch@9(GLAccNo@1000 : Code[20]);
    VAR
      GenJnlBatch@1001 : Record 232;
    BEGIN
      CLEAR(Key);
      GLAccWhereUsed."Table ID" := DATABASE::"Gen. Journal Batch";
      GLAccWhereUsed."Table Name" := GenJnlBatch.TABLECAPTION;
      WITH GenJnlBatch DO BEGIN
        Key[1] := FIELDCAPTION("Journal Template Name");
        Key[2] := FIELDCAPTION(Name);
        IF FIND('-') THEN
          REPEAT
            Key[4] := "Journal Template Name";
            Key[5] := Name;
            IF "Bal. Account Type" = "Bal. Account Type"::"G/L Account" THEN
              InsertGroup(GLAccNo,"Bal. Account No.",FIELDCAPTION("Bal. Account No."),Key);
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE CheckCustPostingGr@1(GLAccNo@1000 : Code[20]);
    VAR
      CustPostingGr@1001 : Record 92;
    BEGIN
      CLEAR(Key);
      GLAccWhereUsed."Table ID" := DATABASE::"Customer Posting Group";
      GLAccWhereUsed."Table Name" := CustPostingGr.TABLECAPTION;
      WITH CustPostingGr DO BEGIN
        Key[1] := FIELDCAPTION(Code);
        IF FIND('-') THEN
          REPEAT
            Key[4] := Code;
            InsertGroup(GLAccNo,"Receivables Account",FIELDCAPTION("Receivables Account"),Key);
            InsertGroup(GLAccNo,"Service Charge Acc.",FIELDCAPTION("Service Charge Acc."),Key);
            InsertGroup(GLAccNo,"Payment Disc. Debit Acc.",FIELDCAPTION("Payment Disc. Debit Acc."),Key);
            InsertGroup(GLAccNo,"Invoice Rounding Account",FIELDCAPTION("Invoice Rounding Account"),Key);
            InsertGroup(GLAccNo,"Additional Fee Account",FIELDCAPTION("Additional Fee Account"),Key);
            InsertGroup(GLAccNo,"Interest Account",FIELDCAPTION("Interest Account"),Key);
            InsertGroup(GLAccNo,"Debit Curr. Appln. Rndg. Acc.",FIELDCAPTION("Debit Curr. Appln. Rndg. Acc."),Key);
            InsertGroup(GLAccNo,"Credit Curr. Appln. Rndg. Acc.",FIELDCAPTION("Credit Curr. Appln. Rndg. Acc."),Key);
            InsertGroup(GLAccNo,"Debit Rounding Account",FIELDCAPTION("Debit Rounding Account"),Key);
            InsertGroup(GLAccNo,"Credit Rounding Account",FIELDCAPTION("Credit Rounding Account"),Key);
            InsertGroup(GLAccNo,"Payment Disc. Credit Acc.",FIELDCAPTION("Payment Disc. Credit Acc."),Key);
            InsertGroup(GLAccNo,"Payment Tolerance Debit Acc.",FIELDCAPTION("Payment Tolerance Debit Acc."),Key);
            InsertGroup(GLAccNo,"Payment Tolerance Credit Acc.",FIELDCAPTION("Payment Tolerance Credit Acc."),Key);
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE CheckVendPostingGr@15(GLAccNo@1000 : Code[20]);
    VAR
      VendPostingGr@1001 : Record 93;
    BEGIN
      CLEAR(Key);
      GLAccWhereUsed."Table ID" := DATABASE::"Vendor Posting Group";
      GLAccWhereUsed."Table Name" := VendPostingGr.TABLECAPTION;
      WITH VendPostingGr DO BEGIN
        Key[1] := FIELDCAPTION(Code);
        IF FIND('-') THEN
          REPEAT
            Key[4] := Code;
            InsertGroup(GLAccNo,"Payables Account",FIELDCAPTION("Payables Account"),Key);
            InsertGroup(GLAccNo,"Service Charge Acc.",FIELDCAPTION("Service Charge Acc."),Key);
            InsertGroup(GLAccNo,"Payment Disc. Debit Acc.",FIELDCAPTION("Payment Disc. Debit Acc."),Key);
            InsertGroup(GLAccNo,"Invoice Rounding Account",FIELDCAPTION("Invoice Rounding Account"),Key);
            InsertGroup(GLAccNo,"Debit Curr. Appln. Rndg. Acc.",FIELDCAPTION("Debit Curr. Appln. Rndg. Acc."),Key);
            InsertGroup(GLAccNo,"Credit Curr. Appln. Rndg. Acc.",FIELDCAPTION("Credit Curr. Appln. Rndg. Acc."),Key);
            InsertGroup(GLAccNo,"Debit Rounding Account",FIELDCAPTION("Debit Rounding Account"),Key);
            InsertGroup(GLAccNo,"Credit Rounding Account",FIELDCAPTION("Credit Rounding Account"),Key);
            InsertGroup(GLAccNo,"Payment Disc. Credit Acc.",FIELDCAPTION("Payment Disc. Credit Acc."),Key);
            InsertGroup(GLAccNo,"Payment Tolerance Debit Acc.",FIELDCAPTION("Payment Tolerance Debit Acc."),Key);
            InsertGroup(GLAccNo,"Payment Tolerance Credit Acc.",FIELDCAPTION("Payment Tolerance Credit Acc."),Key);
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE CheckJobPostingGr@12(GLAccNo@1000 : Code[20]);
    VAR
      JobPostingGr@1001 : Record 208;
    BEGIN
      CLEAR(Key);
      GLAccWhereUsed."Table ID" := DATABASE::"Job Posting Group";
      GLAccWhereUsed."Table Name" := JobPostingGr.TABLECAPTION;
      WITH JobPostingGr DO BEGIN
        Key[1] := FIELDCAPTION(Code);
        IF FIND('-') THEN
          REPEAT
            Key[4] := Code;
            InsertGroup(GLAccNo,"WIP Costs Account",FIELDCAPTION("WIP Costs Account"),Key);
            InsertGroup(GLAccNo,"WIP Accrued Costs Account",FIELDCAPTION("WIP Accrued Costs Account"),Key);
            InsertGroup(GLAccNo,"Job Costs Applied Account",FIELDCAPTION("Job Costs Applied Account"),Key);
            InsertGroup(GLAccNo,"Job Costs Adjustment Account",FIELDCAPTION("Job Costs Adjustment Account"),Key);
            InsertGroup(GLAccNo,"G/L Expense Acc. (Contract)",FIELDCAPTION("G/L Expense Acc. (Contract)"),Key);
            InsertGroup(GLAccNo,"Job Sales Adjustment Account",FIELDCAPTION("Job Sales Adjustment Account"),Key);
            InsertGroup(GLAccNo,"WIP Accrued Sales Account",FIELDCAPTION("WIP Accrued Sales Account"),Key);
            InsertGroup(GLAccNo,"WIP Invoiced Sales Account",FIELDCAPTION("WIP Invoiced Sales Account"),Key);
            InsertGroup(GLAccNo,"Job Sales Applied Account",FIELDCAPTION("Job Sales Applied Account"),Key);
            InsertGroup(GLAccNo,"Recognized Costs Account",FIELDCAPTION("Recognized Costs Account"),Key);
            InsertGroup(GLAccNo,"Recognized Sales Account",FIELDCAPTION("Recognized Sales Account"),Key);
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE CheckGenJnlAlloc@2(GLAccNo@1000 : Code[20]);
    VAR
      GenJnlAlloc@1001 : Record 221;
    BEGIN
      CLEAR(Key);
      GLAccWhereUsed."Table ID" := DATABASE::"Gen. Jnl. Allocation";
      GLAccWhereUsed."Table Name" := GenJnlAlloc.TABLECAPTION;
      WITH GenJnlAlloc DO BEGIN
        Key[1] := FIELDCAPTION("Journal Template Name");
        Key[2] := FIELDCAPTION("Journal Batch Name");
        Key[3] := FIELDCAPTION("Journal Line No.");
        Key[7] := FIELDCAPTION("Line No.");
        IF FIND('-') THEN
          REPEAT
            Key[4] := "Journal Template Name";
            Key[5] := "Journal Batch Name";
            Key[6] := FORMAT("Journal Line No.");
            Key[8] := FORMAT("Line No.");
            InsertGroup(GLAccNo,"Account No.",FIELDCAPTION("Account No."),Key);
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE CheckGenPostingSetup@7(GLAccNo@1000 : Code[20]);
    VAR
      GenPostingSetup@1001 : Record 252;
    BEGIN
      CLEAR(Key);
      GLAccWhereUsed."Table ID" := DATABASE::"General Posting Setup";
      GLAccWhereUsed."Table Name" := GenPostingSetup.TABLECAPTION;
      WITH GenPostingSetup DO BEGIN
        Key[1] := FIELDCAPTION("Gen. Bus. Posting Group");
        Key[2] := FIELDCAPTION("Gen. Prod. Posting Group");
        IF FIND('-') THEN
          REPEAT
            Key[4] := "Gen. Bus. Posting Group";
            Key[5] := "Gen. Prod. Posting Group";
            InsertGroup(GLAccNo,"Sales Account",FIELDCAPTION("Sales Account"),Key);
            InsertGroup(GLAccNo,"Sales Line Disc. Account",FIELDCAPTION("Sales Line Disc. Account"),Key);
            InsertGroup(GLAccNo,"Sales Inv. Disc. Account",FIELDCAPTION("Sales Inv. Disc. Account"),Key);
            InsertGroup(GLAccNo,"Sales Pmt. Disc. Debit Acc.",FIELDCAPTION("Sales Pmt. Disc. Debit Acc."),Key);
            InsertGroup(GLAccNo,"Purch. Account",FIELDCAPTION("Purch. Account"),Key);
            InsertGroup(GLAccNo,"Purch. Line Disc. Account",FIELDCAPTION("Purch. Line Disc. Account"),Key);
            InsertGroup(GLAccNo,"Purch. Inv. Disc. Account",FIELDCAPTION("Purch. Inv. Disc. Account"),Key);
            InsertGroup(GLAccNo,"Purch. Pmt. Disc. Credit Acc.",FIELDCAPTION("Purch. Pmt. Disc. Credit Acc."),Key);
            InsertGroup(GLAccNo,"COGS Account",FIELDCAPTION("COGS Account"),Key);
            InsertGroup(GLAccNo,"Inventory Adjmt. Account",FIELDCAPTION("Inventory Adjmt. Account"),Key);
            InsertGroup(GLAccNo,"Sales Credit Memo Account",FIELDCAPTION("Sales Credit Memo Account"),Key);
            InsertGroup(GLAccNo,"Purch. Credit Memo Account",FIELDCAPTION("Purch. Credit Memo Account"),Key);
            InsertGroup(GLAccNo,"Sales Pmt. Disc. Credit Acc.",FIELDCAPTION("Sales Pmt. Disc. Credit Acc."),Key);
            InsertGroup(GLAccNo,"Purch. Pmt. Disc. Debit Acc.",FIELDCAPTION("Purch. Pmt. Disc. Debit Acc."),Key);
            InsertGroup(GLAccNo,"Sales Pmt. Tol. Debit Acc.",FIELDCAPTION("Sales Pmt. Tol. Debit Acc."),Key);
            InsertGroup(GLAccNo,"Sales Pmt. Tol. Credit Acc.",FIELDCAPTION("Sales Pmt. Tol. Credit Acc."),Key);
            InsertGroup(GLAccNo,"Purch. Pmt. Tol. Debit Acc.",FIELDCAPTION("Purch. Pmt. Tol. Debit Acc."),Key);
            InsertGroup(GLAccNo,"Purch. Pmt. Tol. Credit Acc.",FIELDCAPTION("Purch. Pmt. Tol. Credit Acc."),Key);
            InsertGroup(GLAccNo,"Purch. FA Disc. Account",FIELDCAPTION("Purch. FA Disc. Account"),Key);
            InsertGroup(GLAccNo,"Invt. Accrual Acc. (Interim)",FIELDCAPTION("Invt. Accrual Acc. (Interim)"),Key);
            InsertGroup(GLAccNo,"COGS Account (Interim)",FIELDCAPTION("COGS Account (Interim)"),Key);
            InsertGroup(GLAccNo,"Direct Cost Applied Account",FIELDCAPTION("Direct Cost Applied Account"),Key);
            InsertGroup(GLAccNo,"Overhead Applied Account",FIELDCAPTION("Overhead Applied Account"),Key);
            InsertGroup(GLAccNo,"Purchase Variance Account",FIELDCAPTION("Purchase Variance Account"),Key);
            InsertGroup(GLAccNo,"Sales Prepayments Account",FIELDCAPTION("Sales Prepayments Account"),Key);
            InsertGroup(GLAccNo,"Purch. Prepayments Account",FIELDCAPTION("Purch. Prepayments Account"),Key);
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE CheckBankAccPostingGr@38(GLAccNo@1000 : Code[20]);
    VAR
      BankAccPostingGr@1001 : Record 277;
    BEGIN
      CLEAR(Key);
      GLAccWhereUsed."Table ID" := DATABASE::"Bank Account Posting Group";
      GLAccWhereUsed."Table Name" := BankAccPostingGr.TABLECAPTION;
      WITH BankAccPostingGr DO BEGIN
        Key[1] := FIELDCAPTION(Code);
        IF FIND('-') THEN
          REPEAT
            Key[4] := Code;
            InsertGroup(GLAccNo,"G/L Bank Account No.",FIELDCAPTION("G/L Bank Account No."),Key);
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE CheckVATPostingSetup@39(GLAccNo@1000 : Code[20]);
    VAR
      VATPostingSetup@1001 : Record 325;
    BEGIN
      CLEAR(Key);
      GLAccWhereUsed."Table ID" := DATABASE::"VAT Posting Setup";
      GLAccWhereUsed."Table Name" := VATPostingSetup.TABLECAPTION;
      WITH VATPostingSetup DO BEGIN
        Key[1] := FIELDCAPTION("VAT Bus. Posting Group");
        Key[2] := FIELDCAPTION("VAT Prod. Posting Group");
        IF FIND('-') THEN
          REPEAT
            Key[4] := "VAT Bus. Posting Group";
            Key[5] := "VAT Prod. Posting Group";
            InsertGroup(GLAccNo,"Sales VAT Account",FIELDCAPTION("Sales VAT Account"),Key);
            InsertGroup(GLAccNo,"Sales VAT Unreal. Account",FIELDCAPTION("Sales VAT Unreal. Account"),Key);
            InsertGroup(GLAccNo,"Purchase VAT Account",FIELDCAPTION("Purchase VAT Account"),Key);
            InsertGroup(GLAccNo,"Purch. VAT Unreal. Account",FIELDCAPTION("Purch. VAT Unreal. Account"),Key);
            InsertGroup(GLAccNo,"Reverse Chrg. VAT Acc.",FIELDCAPTION("Reverse Chrg. VAT Acc."),Key);
            InsertGroup(GLAccNo,"Reverse Chrg. VAT Unreal. Acc.",FIELDCAPTION("Reverse Chrg. VAT Unreal. Acc."),Key);
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE CheckFAPostingGr@40(GLAccNo@1000 : Code[20]);
    VAR
      FAPostingGr@1001 : Record 5606;
    BEGIN
      CLEAR(Key);
      GLAccWhereUsed."Table ID" := DATABASE::"FA Posting Group";
      GLAccWhereUsed."Table Name" := FAPostingGr.TABLECAPTION;
      WITH FAPostingGr DO BEGIN
        Key[1] := FIELDCAPTION(Code);
        IF FIND('-') THEN
          REPEAT
            Key[4] := Code;
            InsertGroup(GLAccNo,"Acquisition Cost Account",FIELDCAPTION("Acquisition Cost Account"),Key);
            InsertGroup(GLAccNo,"Accum. Depreciation Account",FIELDCAPTION("Accum. Depreciation Account"),Key);
            InsertGroup(GLAccNo,"Write-Down Account",FIELDCAPTION("Write-Down Account"),Key);
            InsertGroup(GLAccNo,"Appreciation Account",FIELDCAPTION("Appreciation Account"),Key);
            InsertGroup(GLAccNo,"Custom 1 Account",FIELDCAPTION("Custom 1 Account"),Key);
            InsertGroup(GLAccNo,"Custom 2 Account",FIELDCAPTION("Custom 2 Account"),Key);
            InsertGroup(GLAccNo,"Acq. Cost Acc. on Disposal",FIELDCAPTION("Acq. Cost Acc. on Disposal"),Key);
            InsertGroup(GLAccNo,"Accum. Depr. Acc. on Disposal",FIELDCAPTION("Accum. Depr. Acc. on Disposal"),Key);
            InsertGroup(GLAccNo,"Write-Down Acc. on Disposal",FIELDCAPTION("Write-Down Acc. on Disposal"),Key);
            InsertGroup(GLAccNo,"Appreciation Acc. on Disposal",FIELDCAPTION("Appreciation Acc. on Disposal"),Key);
            InsertGroup(GLAccNo,"Custom 1 Account on Disposal",FIELDCAPTION("Custom 1 Account on Disposal"),Key);
            InsertGroup(GLAccNo,"Custom 2 Account on Disposal",FIELDCAPTION("Custom 2 Account on Disposal"),Key);
            InsertGroup(GLAccNo,"Gains Acc. on Disposal",FIELDCAPTION("Gains Acc. on Disposal"),Key);
            InsertGroup(GLAccNo,"Losses Acc. on Disposal",FIELDCAPTION("Losses Acc. on Disposal"),Key);
            InsertGroup(GLAccNo,"Book Val. Acc. on Disp. (Gain)",FIELDCAPTION("Book Val. Acc. on Disp. (Gain)"),Key);
            InsertGroup(GLAccNo,"Sales Acc. on Disp. (Gain)",FIELDCAPTION("Sales Acc. on Disp. (Gain)"),Key);
            InsertGroup(GLAccNo,"Write-Down Bal. Acc. on Disp.",FIELDCAPTION("Write-Down Bal. Acc. on Disp."),Key);
            InsertGroup(GLAccNo,"Apprec. Bal. Acc. on Disp.",FIELDCAPTION("Apprec. Bal. Acc. on Disp."),Key);
            InsertGroup(GLAccNo,"Custom 1 Bal. Acc. on Disposal",FIELDCAPTION("Custom 1 Bal. Acc. on Disposal"),Key);
            InsertGroup(GLAccNo,"Custom 2 Bal. Acc. on Disposal",FIELDCAPTION("Custom 2 Bal. Acc. on Disposal"),Key);
            InsertGroup(GLAccNo,"Maintenance Expense Account",FIELDCAPTION("Maintenance Expense Account"),Key);
            InsertGroup(GLAccNo,"Maintenance Bal. Acc.",FIELDCAPTION("Maintenance Bal. Acc."),Key);
            InsertGroup(GLAccNo,"Acquisition Cost Bal. Acc.",FIELDCAPTION("Acquisition Cost Bal. Acc."),Key);
            InsertGroup(GLAccNo,"Depreciation Expense Acc.",FIELDCAPTION("Depreciation Expense Acc."),Key);
            InsertGroup(GLAccNo,"Write-Down Expense Acc.",FIELDCAPTION("Write-Down Expense Acc."),Key);
            InsertGroup(GLAccNo,"Appreciation Bal. Account",FIELDCAPTION("Appreciation Bal. Account"),Key);
            InsertGroup(GLAccNo,"Custom 1 Expense Acc.",FIELDCAPTION("Custom 1 Expense Acc."),Key);
            InsertGroup(GLAccNo,"Custom 2 Expense Acc.",FIELDCAPTION("Custom 2 Expense Acc."),Key);
            InsertGroup(GLAccNo,"Sales Bal. Acc.",FIELDCAPTION("Sales Bal. Acc."),Key);
            InsertGroup(GLAccNo,"Sales Acc. on Disp. (Loss)",FIELDCAPTION("Sales Acc. on Disp. (Loss)"),Key);
            InsertGroup(GLAccNo,"Book Val. Acc. on Disp. (Loss)",FIELDCAPTION("Book Val. Acc. on Disp. (Loss)"),Key);
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE CheckFAAllocation@11(GLAccNo@1000 : Code[20]);
    VAR
      FAAlloc@1001 : Record 5615;
    BEGIN
      CLEAR(Key);
      GLAccWhereUsed."Table ID" := DATABASE::"FA Allocation";
      GLAccWhereUsed."Table Name" := FAAlloc.TABLECAPTION;
      WITH FAAlloc DO BEGIN
        Key[1] := FIELDCAPTION(Code);
        Key[2] := FIELDCAPTION("Allocation Type");
        Key[3] := FIELDCAPTION("Line No.");
        IF FIND('-') THEN
          REPEAT
            Key[4] := Code;
            Key[5] := FORMAT("Allocation Type");
            Key[6] := FORMAT("Line No.");
            InsertGroup(GLAccNo,"Account No.",FIELDCAPTION("Account No."),Key);
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE CheckInventoryPostingSetup@41(GLAccNo@1000 : Code[20]);
    VAR
      InventoryPostingSetup@1001 : Record 5813;
    BEGIN
      CLEAR(Key);
      GLAccWhereUsed."Table ID" := DATABASE::"Inventory Posting Setup";
      GLAccWhereUsed."Table Name" := InventoryPostingSetup.TABLECAPTION;
      WITH InventoryPostingSetup DO BEGIN
        Key[1] := FIELDCAPTION("Location Code");
        Key[2] := FIELDCAPTION("Invt. Posting Group Code");
        IF FIND('-') THEN
          REPEAT
            Key[4] := "Location Code";
            Key[5] := "Invt. Posting Group Code";
            InsertGroup(GLAccNo,"Inventory Account",FIELDCAPTION("Inventory Account"),Key);
            InsertGroup(GLAccNo,"Inventory Account (Interim)",FIELDCAPTION("Inventory Account (Interim)"),Key);
            InsertGroup(GLAccNo,"WIP Account",FIELDCAPTION("WIP Account"),Key);
            InsertGroup(GLAccNo,"Material Variance Account",FIELDCAPTION("Material Variance Account"),Key);
            InsertGroup(GLAccNo,"Capacity Variance Account",FIELDCAPTION("Capacity Variance Account"),Key);
            InsertGroup(
              GLAccNo,"Mfg. Overhead Variance Account",FIELDCAPTION("Mfg. Overhead Variance Account"),Key);
            InsertGroup(
              GLAccNo,"Cap. Overhead Variance Account",FIELDCAPTION("Cap. Overhead Variance Account"),Key);
            InsertGroup(
              GLAccNo,"Subcontracted Variance Account",FIELDCAPTION("Subcontracted Variance Account"),Key);
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE CheckServiceContractAccGr@42(GLAccNo@1000 : Code[20]);
    VAR
      ServiceContractAccGr@1001 : Record 5973;
    BEGIN
      CLEAR(Key);
      GLAccWhereUsed."Table ID" := DATABASE::"Service Contract Account Group";
      GLAccWhereUsed."Table Name" := ServiceContractAccGr.TABLECAPTION;
      WITH ServiceContractAccGr DO BEGIN
        Key[1] := FIELDCAPTION(Code);
        IF FIND('-') THEN
          REPEAT
            Key[4] := Code;
            InsertGroup(GLAccNo,"Non-Prepaid Contract Acc.",FIELDCAPTION("Non-Prepaid Contract Acc."),Key);
            InsertGroup(GLAccNo,"Prepaid Contract Acc.",FIELDCAPTION("Prepaid Contract Acc."),Key);
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE CheckICPartner@13(GLAccNo@1000 : Code[20]);
    VAR
      ICPartner@1001 : Record 413;
    BEGIN
      CLEAR(Key);
      GLAccWhereUsed."Table ID" := DATABASE::"IC Partner";
      GLAccWhereUsed."Table Name" := ICPartner.TABLECAPTION;
      WITH ICPartner DO BEGIN
        Key[1] := FIELDCAPTION(Code);
        IF FIND('-') THEN
          REPEAT
            Key[4] := Code;
            InsertGroup(GLAccNo,"Receivables Account",FIELDCAPTION("Receivables Account"),Key);
            InsertGroup(GLAccNo,"Payables Account",FIELDCAPTION("Payables Account"),Key);
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE CheckPaymentMethod@16(GLAccNo@1000 : Code[20]);
    VAR
      PaymentMethod@1001 : Record 289;
    BEGIN
      CLEAR(Key);
      GLAccWhereUsed."Table ID" := DATABASE::"Payment Method";
      GLAccWhereUsed."Table Name" := PaymentMethod.TABLECAPTION;
      WITH PaymentMethod DO BEGIN
        Key[1] := FIELDCAPTION(Code);
        IF FIND('-') THEN
          REPEAT
            IF "Bal. Account Type" = "Bal. Account Type"::"G/L Account" THEN BEGIN
              Key[4] := Code;
              InsertGroup(GLAccNo,"Bal. Account No.",FIELDCAPTION("Bal. Account No."),Key);
            END
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE CheckSalesReceivablesSetup@17(GLAccNo@1000 : Code[20]);
    VAR
      SalesReceivablesSetup@1001 : Record 311;
    BEGIN
      CLEAR(Key);
      GLAccWhereUsed."Table ID" := DATABASE::"Sales & Receivables Setup";
      GLAccWhereUsed."Table Name" := SalesReceivablesSetup.TABLECAPTION;
      WITH SalesReceivablesSetup DO BEGIN
        Key[1] := FIELDCAPTION("Primary Key");
        GET;
        InsertGroup(GLAccNo,"Freight G/L Acc. No.",FIELDCAPTION("Freight G/L Acc. No."),Key);
      END;
    END;

    LOCAL PROCEDURE CheckEmployeePostingGroup@21(GLAccNo@1000 : Code[20]);
    VAR
      EmployeePostingGroup@1001 : Record 5221;
    BEGIN
      CLEAR(Key);
      GLAccWhereUsed."Table ID" := DATABASE::"Sales & Receivables Setup";
      GLAccWhereUsed."Table Name" := EmployeePostingGroup.TABLECAPTION;
      WITH EmployeePostingGroup DO BEGIN
        Key[1] := FIELDCAPTION(Code);
        IF FINDSET THEN
          REPEAT
            Key[4] := Code;
            InsertGroup(GLAccNo,"Payables Account",FIELDCAPTION("Payables Account"),Key);
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE GetWhereUsedNextEntryNo@24() : Integer;
    VAR
      TempGLAccountWhereUsed@1000 : TEMPORARY Record 180;
    BEGIN
      TempGLAccountWhereUsed.COPY(GLAccWhereUsed,TRUE);
      IF TempGLAccountWhereUsed.FINDLAST THEN
        EXIT(TempGLAccountWhereUsed."Entry No." + 1);
      EXIT(1);
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCheckPostingGroups@20(VAR TempGLAccountWhereUsed@1001 : TEMPORARY Record 180;GLAccNo@1000 : Code[20]);
    BEGIN
    END;

    BEGIN
    {
      Change in CheckGenPostingSetup
    }
    END.
  }
}

