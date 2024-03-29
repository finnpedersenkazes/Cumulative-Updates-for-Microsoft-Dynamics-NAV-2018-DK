OBJECT Codeunit 17 Gen. Jnl.-Post Reverse
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    TableNo=81;
    Permissions=TableData 17=m,
                TableData 21=imd,
                TableData 25=imd,
                TableData 45=rm,
                TableData 253=rimd,
                TableData 254=imd,
                TableData 271=imd,
                TableData 272=imd,
                TableData 379=imd,
                TableData 380=imd;
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      GenJnlPostLine@1002 : Codeunit 12;
      ReversalMismatchErr@1026 : TextConst 'DAN=Tilbagef�rslen fandt %1 uden en tilsvarende finanspost.;ENU=Reversal found a %1 without a matching general ledger entry.';
      CannotReverseErr@1023 : TextConst 'DAN=Du kan ikke tilbagef�re transaktionen, fordi den allerede er tilbagef�rt.;ENU=You cannot reverse the transaction, because it has already been reversed.';
      DimCombBlockedErr@1027 : TextConst 'DAN=Kombinationen af dimensioner, der bliver brugt i finansposten %1, er sp�rret. %2.;ENU=The combination of dimensions used in general ledger entry %1 is blocked. %2.';

    [Internal]
    PROCEDURE Reverse@72(VAR ReversalEntry@1002 : Record 179;VAR ReversalEntry2@1000 : Record 179);
    VAR
      SourceCodeSetup@1016 : Record 242;
      GLEntry2@1003 : Record 17;
      GLReg@1019 : Record 45;
      GLReg2@1021 : Record 45;
      GenJnlLine@1017 : Record 81;
      CustLedgEntry@1004 : Record 21;
      TempCustLedgEntry@1005 : TEMPORARY Record 21;
      VendLedgEntry@1008 : Record 25;
      TempVendLedgEntry@1012 : TEMPORARY Record 25;
      EmployeeLedgerEntry@1022 : Record 5222;
      TempEmployeeLedgerEntry@1023 : TEMPORARY Record 5222;
      BankAccLedgEntry@1009 : Record 271;
      TempBankAccLedgEntry@1015 : TEMPORARY Record 271;
      VATEntry@1010 : Record 254;
      FALedgEntry@1007 : Record 5601;
      MaintenanceLedgEntry@1011 : Record 5625;
      TempRevertTransactionNo@1024 : TEMPORARY Record 2000000026;
      FAInsertLedgEntry@1006 : Codeunit 5600;
      UpdateAnalysisView@1020 : Codeunit 410;
      NextDtldCustLedgEntryEntryNo@1014 : Integer;
      NextDtldVendLedgEntryEntryNo@1013 : Integer;
      NextDtldEmplLedgEntryNo@1025 : Integer;
      TransactionKey@1001 : Integer;
    BEGIN
      OnBeforeReverse(ReversalEntry,ReversalEntry2);

      SourceCodeSetup.GET;
      IF ReversalEntry2."Reversal Type" = ReversalEntry2."Reversal Type"::Register THEN
        GLReg2."No." := ReversalEntry2."G/L Register No.";

      ReversalEntry.CopyReverseFilters(
        GLEntry2,CustLedgEntry,VendLedgEntry,BankAccLedgEntry,VATEntry,FALedgEntry,MaintenanceLedgEntry,EmployeeLedgerEntry);

      IF ReversalEntry2."Reversal Type" = ReversalEntry2."Reversal Type"::Transaction THEN BEGIN
        IF ReversalEntry2.FINDSET(FALSE,FALSE) THEN
          REPEAT
            TempRevertTransactionNo.Number := ReversalEntry2."Transaction No.";
            IF TempRevertTransactionNo.INSERT THEN;
          UNTIL ReversalEntry2.NEXT = 0;
      END;

      TransactionKey := GetTransactionKey;
      SaveReversalEntries(ReversalEntry2,TransactionKey);

      GenJnlLine.INIT;
      GenJnlLine."Source Code" := SourceCodeSetup.Reversal;

      IF GenJnlPostLine.GetNextEntryNo = 0 THEN
        GenJnlPostLine.StartPosting(GenJnlLine)
      ELSE
        GenJnlPostLine.ContinuePosting(GenJnlLine);

      GenJnlPostLine.SetGLRegReverse(GLReg);

      CopyCustLedgEntry(CustLedgEntry,TempCustLedgEntry);
      CopyVendLedgEntry(VendLedgEntry,TempVendLedgEntry);
      CopyEmplLedgEntry(EmployeeLedgerEntry,TempEmployeeLedgerEntry);
      CopyBankAccLedgEntry(BankAccLedgEntry,TempBankAccLedgEntry);

      IF TempRevertTransactionNo.FINDSET THEN;
      REPEAT
        IF ReversalEntry2."Reversal Type" = ReversalEntry2."Reversal Type"::Transaction THEN
          GLEntry2.SETRANGE("Transaction No.",TempRevertTransactionNo.Number);
        ReverseGLEntry(
          GLEntry2,GenJnlLine,TempCustLedgEntry,
          TempVendLedgEntry,TempEmployeeLedgerEntry,TempBankAccLedgEntry,NextDtldCustLedgEntryEntryNo,NextDtldVendLedgEntryEntryNo,
          NextDtldEmplLedgEntryNo,FAInsertLedgEntry);
      UNTIL TempRevertTransactionNo.NEXT = 0;

      IF FALedgEntry.FINDSET THEN
        REPEAT
          FAInsertLedgEntry.CheckFAReverseEntry(FALedgEntry)
        UNTIL FALedgEntry.NEXT = 0;

      IF MaintenanceLedgEntry.FINDFIRST THEN
        REPEAT
          FAInsertLedgEntry.CheckMaintReverseEntry(MaintenanceLedgEntry)
        UNTIL FALedgEntry.NEXT = 0;

      FAInsertLedgEntry.FinishFAReverseEntry(GLReg);

      IF NOT TempCustLedgEntry.ISEMPTY THEN
        ERROR(ReversalMismatchErr,CustLedgEntry.TABLECAPTION);
      IF NOT TempVendLedgEntry.ISEMPTY THEN
        ERROR(ReversalMismatchErr,VendLedgEntry.TABLECAPTION);
      IF NOT TempEmployeeLedgerEntry.ISEMPTY THEN
        ERROR(ReversalMismatchErr,EmployeeLedgerEntry.TABLECAPTION);
      IF NOT TempBankAccLedgEntry.ISEMPTY THEN
        ERROR(ReversalMismatchErr,BankAccLedgEntry.TABLECAPTION);

      GenJnlPostLine.FinishPosting;

      IF GLReg2."No." <> 0 THEN
        IF GLReg2.FIND THEN BEGIN
          GLReg2.Reversed := TRUE;
          GLReg2.MODIFY;
        END;

      DeleteReversalEntries(TransactionKey);

      UpdateAnalysisView.UpdateAll(0,TRUE);
    END;

    LOCAL PROCEDURE ReverseGLEntry@6(VAR GLEntry2@1000 : Record 17;VAR GenJnlLine@1003 : Record 81;VAR TempCustLedgEntry@1006 : TEMPORARY Record 21;VAR TempVendLedgEntry@1007 : TEMPORARY Record 25;VAR TempEmployeeLedgerEntry@1005 : TEMPORARY Record 5222;VAR TempBankAccLedgEntry@1008 : TEMPORARY Record 271;VAR NextDtldCustLedgEntryEntryNo@1009 : Integer;VAR NextDtldVendLedgEntryEntryNo@1010 : Integer;VAR NextDtldEmplLedgEntryNo@1011 : Integer;FAInsertLedgerEntry@1002 : Codeunit 5600);
    VAR
      GLEntry@1001 : Record 17;
      ReversedGLEntry@1004 : Record 17;
    BEGIN
      WITH GLEntry2 DO
        IF FIND('+') THEN
          REPEAT
            IF "Reversed by Entry No." <> 0 THEN
              ERROR(CannotReverseErr);
            CheckDimComb("Entry No.","Dimension Set ID",DATABASE::"G/L Account","G/L Account No.",0,'');
            GLEntry := GLEntry2;
            IF "FA Entry No." <> 0 THEN
              FAInsertLedgerEntry.InsertReverseEntry(
                GenJnlPostLine.GetNextEntryNo,"FA Entry Type","FA Entry No.",GLEntry."FA Entry No.",
                GenJnlPostLine.GetNextTransactionNo);
            GLEntry.Amount := -Amount;
            GLEntry.Quantity := -Quantity;
            GLEntry."VAT Amount" := -"VAT Amount";
            GLEntry."Debit Amount" := -"Debit Amount";
            GLEntry."Credit Amount" := -"Credit Amount";
            GLEntry."Additional-Currency Amount" := -"Additional-Currency Amount";
            GLEntry."Add.-Currency Debit Amount" := -"Add.-Currency Debit Amount";
            GLEntry."Add.-Currency Credit Amount" := -"Add.-Currency Credit Amount";
            GLEntry."Entry No." := GenJnlPostLine.GetNextEntryNo;
            GLEntry."Transaction No." := GenJnlPostLine.GetNextTransactionNo;
            GLEntry."User ID" := USERID;
            GenJnlLine.Correction :=
              (GLEntry."Debit Amount" < 0) OR (GLEntry."Credit Amount" < 0) OR
              (GLEntry."Add.-Currency Debit Amount" < 0) OR (GLEntry."Add.-Currency Credit Amount" < 0);
            GLEntry."Journal Batch Name" := '';
            GLEntry."Source Code" := GenJnlLine."Source Code";
            SetReversalDescription(GLEntry2,GLEntry.Description);
            GLEntry."Reversed Entry No." := "Entry No.";
            GLEntry.Reversed := TRUE;
            // Reversal of Reversal
            IF "Reversed Entry No." <> 0 THEN BEGIN
              ReversedGLEntry.GET("Reversed Entry No.");
              ReversedGLEntry."Reversed by Entry No." := 0;
              ReversedGLEntry.Reversed := FALSE;
              ReversedGLEntry.MODIFY;
              "Reversed Entry No." := GLEntry."Entry No.";
              GLEntry."Reversed by Entry No." := "Entry No.";
            END;
            "Reversed by Entry No." := GLEntry."Entry No.";
            Reversed := TRUE;
            MODIFY;
            OnReverseGLEntryOnBeforeInsertGLEntry(GLEntry,GenJnlLine,GLEntry2);
            GenJnlPostLine.InsertGLEntry(GenJnlLine,GLEntry,FALSE);

            CASE TRUE OF
              TempCustLedgEntry.GET("Entry No."):
                BEGIN
                  CheckDimComb("Entry No.","Dimension Set ID",
                    DATABASE::Customer,TempCustLedgEntry."Customer No.",
                    DATABASE::"Salesperson/Purchaser",TempCustLedgEntry."Salesperson Code");
                  ReverseCustLedgEntry(
                    TempCustLedgEntry,GLEntry."Entry No.",GenJnlLine.Correction,GenJnlLine."Source Code",
                    NextDtldCustLedgEntryEntryNo);
                  TempCustLedgEntry.DELETE;
                END;
              TempVendLedgEntry.GET("Entry No."):
                BEGIN
                  CheckDimComb("Entry No.","Dimension Set ID",
                    DATABASE::Vendor,TempVendLedgEntry."Vendor No.",
                    DATABASE::"Salesperson/Purchaser",TempVendLedgEntry."Purchaser Code");
                  ReverseVendLedgEntry(
                    TempVendLedgEntry,GLEntry."Entry No.",GenJnlLine.Correction,GenJnlLine."Source Code",
                    NextDtldVendLedgEntryEntryNo);
                  TempVendLedgEntry.DELETE;
                END;
              TempEmployeeLedgerEntry.GET("Entry No."):
                BEGIN
                  CheckDimComb(
                    "Entry No.","Dimension Set ID",DATABASE::Employee,TempEmployeeLedgerEntry."Employee No.",0,'');
                  ReverseEmplLedgEntry(
                    TempEmployeeLedgerEntry,GLEntry."Entry No.",GenJnlLine.Correction,GenJnlLine."Source Code",
                    NextDtldEmplLedgEntryNo);
                  TempEmployeeLedgerEntry.DELETE;
                END;
              TempBankAccLedgEntry.GET("Entry No."):
                BEGIN
                  CheckDimComb("Entry No.","Dimension Set ID",
                    DATABASE::"Bank Account",TempBankAccLedgEntry."Bank Account No.",0,'');
                  ReverseBankAccLedgEntry(TempBankAccLedgEntry,GLEntry."Entry No.",GenJnlLine."Source Code");
                  TempBankAccLedgEntry.DELETE;
                END;
            END;

            ReverseVAT(GLEntry,GenJnlLine."Source Code");
          UNTIL NEXT(-1) = 0;
    END;

    LOCAL PROCEDURE ReverseCustLedgEntry@71(CustLedgEntry@1000 : Record 21;NewEntryNo@1001 : Integer;Correction@1006 : Boolean;SourceCode@1009 : Code[10];VAR NextDtldCustLedgEntryEntryNo@1003 : Integer);
    VAR
      NewCustLedgEntry@1002 : Record 21;
      ReversedCustLedgEntry@1007 : Record 21;
      DtldCustLedgEntry@1005 : Record 379;
      NewDtldCustLedgEntry@1004 : Record 379;
    BEGIN
      WITH NewCustLedgEntry DO BEGIN
        NewCustLedgEntry := CustLedgEntry;
        "Sales (LCY)" := -"Sales (LCY)";
        "Profit (LCY)" := -"Profit (LCY)";
        "Inv. Discount (LCY)" := -"Inv. Discount (LCY)";
        "Original Pmt. Disc. Possible" := -"Original Pmt. Disc. Possible";
        "Pmt. Disc. Given (LCY)" := -"Pmt. Disc. Given (LCY)";
        Positive := NOT Positive;
        "Adjusted Currency Factor" := "Adjusted Currency Factor";
        "Original Currency Factor" := "Original Currency Factor";
        "Remaining Pmt. Disc. Possible" := -"Remaining Pmt. Disc. Possible";
        "Max. Payment Tolerance" := -"Max. Payment Tolerance";
        "Accepted Payment Tolerance" := -"Accepted Payment Tolerance";
        "Pmt. Tolerance (LCY)" := -"Pmt. Tolerance (LCY)";
        "User ID" := USERID;
        "Entry No." := NewEntryNo;
        "Transaction No." := GenJnlPostLine.GetNextTransactionNo;
        "Journal Batch Name" := '';
        "Source Code" := SourceCode;
        SetReversalDescription(CustLedgEntry,Description);
        "Reversed Entry No." := CustLedgEntry."Entry No.";
        Reversed := TRUE;
        "Applies-to ID" := '';
        // Reversal of Reversal
        IF CustLedgEntry."Reversed Entry No." <> 0 THEN BEGIN
          ReversedCustLedgEntry.GET(CustLedgEntry."Reversed Entry No.");
          ReversedCustLedgEntry."Reversed by Entry No." := 0;
          ReversedCustLedgEntry.Reversed := FALSE;
          ReversedCustLedgEntry.MODIFY;
          CustLedgEntry."Reversed Entry No." := "Entry No.";
          "Reversed by Entry No." := CustLedgEntry."Entry No.";
        END;
        CustLedgEntry."Applies-to ID" := '';
        CustLedgEntry."Reversed by Entry No." := "Entry No.";
        CustLedgEntry.Reversed := TRUE;
        CustLedgEntry.MODIFY;
        OnReverseCustLedgEntryOnBeforeInsertCustLedgEntry(NewCustLedgEntry,CustLedgEntry);
        INSERT;

        IF NextDtldCustLedgEntryEntryNo = 0 THEN BEGIN
          DtldCustLedgEntry.FINDLAST;
          NextDtldCustLedgEntryEntryNo := DtldCustLedgEntry."Entry No." + 1;
        END;
        DtldCustLedgEntry.SETCURRENTKEY("Cust. Ledger Entry No.");
        DtldCustLedgEntry.SETRANGE("Cust. Ledger Entry No.",CustLedgEntry."Entry No.");
        DtldCustLedgEntry.SETRANGE(Unapplied,FALSE);
        DtldCustLedgEntry.FINDSET;
        REPEAT
          DtldCustLedgEntry.TESTFIELD("Entry Type",DtldCustLedgEntry."Entry Type"::"Initial Entry");
          NewDtldCustLedgEntry := DtldCustLedgEntry;
          NewDtldCustLedgEntry.Amount := -NewDtldCustLedgEntry.Amount;
          NewDtldCustLedgEntry."Amount (LCY)" := -NewDtldCustLedgEntry."Amount (LCY)";
          NewDtldCustLedgEntry.UpdateDebitCredit(Correction);
          NewDtldCustLedgEntry."Cust. Ledger Entry No." := NewEntryNo;
          NewDtldCustLedgEntry."User ID" := USERID;
          NewDtldCustLedgEntry."Transaction No." := GenJnlPostLine.GetNextTransactionNo;
          NewDtldCustLedgEntry."Entry No." := NextDtldCustLedgEntryEntryNo;
          NextDtldCustLedgEntryEntryNo := NextDtldCustLedgEntryEntryNo + 1;
          OnReverseCustLedgEntryOnBeforeInsertDtldCustLedgEntry(NewDtldCustLedgEntry,DtldCustLedgEntry);
          NewDtldCustLedgEntry.INSERT(TRUE);
        UNTIL DtldCustLedgEntry.NEXT = 0;

        ApplyCustLedgEntryByReversal(
          CustLedgEntry,NewCustLedgEntry,NewDtldCustLedgEntry,"Entry No.",NextDtldCustLedgEntryEntryNo);
        ApplyCustLedgEntryByReversal(
          NewCustLedgEntry,CustLedgEntry,DtldCustLedgEntry,"Entry No.",NextDtldCustLedgEntryEntryNo);
      END;
    END;

    LOCAL PROCEDURE ReverseVendLedgEntry@70(VendLedgEntry@1000 : Record 25;NewEntryNo@1001 : Integer;Correction@1006 : Boolean;SourceCode@1009 : Code[10];VAR NextDtldVendLedgEntryEntryNo@1003 : Integer);
    VAR
      NewVendLedgEntry@1002 : Record 25;
      ReversedVendLedgEntry@1008 : Record 25;
      DtldVendLedgEntry@1005 : Record 380;
      NewDtldVendLedgEntry@1004 : Record 380;
    BEGIN
      WITH NewVendLedgEntry DO BEGIN
        NewVendLedgEntry := VendLedgEntry;
        "Purchase (LCY)" := -"Purchase (LCY)";
        "Inv. Discount (LCY)" := -"Inv. Discount (LCY)";
        "Original Pmt. Disc. Possible" := -"Original Pmt. Disc. Possible";
        "Pmt. Disc. Rcd.(LCY)" := -"Pmt. Disc. Rcd.(LCY)";
        Positive := NOT Positive;
        "Adjusted Currency Factor" := "Adjusted Currency Factor";
        "Original Currency Factor" := "Original Currency Factor";
        "Remaining Pmt. Disc. Possible" := -"Remaining Pmt. Disc. Possible";
        "Max. Payment Tolerance" := -"Max. Payment Tolerance";
        "Accepted Payment Tolerance" := -"Accepted Payment Tolerance";
        "Pmt. Tolerance (LCY)" := -"Pmt. Tolerance (LCY)";
        "User ID" := USERID;
        "Entry No." := NewEntryNo;
        "Transaction No." := GenJnlPostLine.GetNextTransactionNo;
        "Journal Batch Name" := '';
        "Source Code" := SourceCode;
        SetReversalDescription(VendLedgEntry,Description);
        "Reversed Entry No." := VendLedgEntry."Entry No.";
        Reversed := TRUE;
        "Applies-to ID" := '';
        // Reversal of Reversal
        IF VendLedgEntry."Reversed Entry No." <> 0 THEN BEGIN
          ReversedVendLedgEntry.GET(VendLedgEntry."Reversed Entry No.");
          ReversedVendLedgEntry."Reversed by Entry No." := 0;
          ReversedVendLedgEntry.Reversed := FALSE;
          ReversedVendLedgEntry.MODIFY;
          VendLedgEntry."Reversed Entry No." := "Entry No.";
          "Reversed by Entry No." := VendLedgEntry."Entry No.";
        END;
        VendLedgEntry."Applies-to ID" := '';
        VendLedgEntry."Reversed by Entry No." := "Entry No.";
        VendLedgEntry.Reversed := TRUE;
        VendLedgEntry.MODIFY;
        OnReverseVendLedgEntryOnBeforeInsertVendLedgEntry(NewVendLedgEntry,VendLedgEntry);
        INSERT;

        IF NextDtldVendLedgEntryEntryNo = 0 THEN BEGIN
          DtldVendLedgEntry.FINDLAST;
          NextDtldVendLedgEntryEntryNo := DtldVendLedgEntry."Entry No." + 1;
        END;
        DtldVendLedgEntry.SETCURRENTKEY("Vendor Ledger Entry No.");
        DtldVendLedgEntry.SETRANGE("Vendor Ledger Entry No.",VendLedgEntry."Entry No.");
        DtldVendLedgEntry.SETRANGE(Unapplied,FALSE);
        DtldVendLedgEntry.FINDSET;
        REPEAT
          DtldVendLedgEntry.TESTFIELD("Entry Type",DtldVendLedgEntry."Entry Type"::"Initial Entry");
          NewDtldVendLedgEntry := DtldVendLedgEntry;
          NewDtldVendLedgEntry.Amount := -NewDtldVendLedgEntry.Amount;
          NewDtldVendLedgEntry."Amount (LCY)" := -NewDtldVendLedgEntry."Amount (LCY)";
          NewDtldVendLedgEntry.UpdateDebitCredit(Correction);
          NewDtldVendLedgEntry."Vendor Ledger Entry No." := NewEntryNo;
          NewDtldVendLedgEntry."User ID" := USERID;
          NewDtldVendLedgEntry."Transaction No." := GenJnlPostLine.GetNextTransactionNo;
          NewDtldVendLedgEntry."Entry No." := NextDtldVendLedgEntryEntryNo;
          NextDtldVendLedgEntryEntryNo := NextDtldVendLedgEntryEntryNo + 1;
          OnReverseVendLedgEntryOnBeforeInsertDtldVendLedgEntry(NewDtldVendLedgEntry,DtldVendLedgEntry);
          NewDtldVendLedgEntry.INSERT(TRUE);
        UNTIL DtldVendLedgEntry.NEXT = 0;

        ApplyVendLedgEntryByReversal(
          VendLedgEntry,NewVendLedgEntry,NewDtldVendLedgEntry,"Entry No.",NextDtldVendLedgEntryEntryNo);
        ApplyVendLedgEntryByReversal(
          NewVendLedgEntry,VendLedgEntry,DtldVendLedgEntry,"Entry No.",NextDtldVendLedgEntryEntryNo);
      END;
    END;

    LOCAL PROCEDURE ReverseEmplLedgEntry@24(EmployeeLedgerEntry@1000 : Record 5222;NewEntryNo@1004 : Integer;Correction@1003 : Boolean;SourceCode@1002 : Code[10];VAR NextDtldEmplLedgEntryNo@1001 : Integer);
    VAR
      NewEmployeeLedgerEntry@1005 : Record 5222;
      ReversedEmployeeLedgerEntry@1006 : Record 5222;
      DetailedEmployeeLedgerEntry@1007 : Record 5223;
      NewDetailedEmployeeLedgerEntry@1008 : Record 5223;
    BEGIN
      WITH NewEmployeeLedgerEntry DO BEGIN
        NewEmployeeLedgerEntry := EmployeeLedgerEntry;
        Positive := NOT Positive;
        "User ID" := USERID;
        "Entry No." := NewEntryNo;
        "Transaction No." := GenJnlPostLine.GetNextTransactionNo;
        "Journal Batch Name" := '';
        "Source Code" := SourceCode;
        SetReversalDescription(EmployeeLedgerEntry,Description);
        "Reversed Entry No." := EmployeeLedgerEntry."Entry No.";
        Reversed := TRUE;
        "Applies-to ID" := '';
        // Reversal of Reversal
        IF EmployeeLedgerEntry."Reversed Entry No." <> 0 THEN BEGIN
          ReversedEmployeeLedgerEntry.GET(EmployeeLedgerEntry."Reversed Entry No.");
          ReversedEmployeeLedgerEntry."Reversed by Entry No." := 0;
          ReversedEmployeeLedgerEntry.Reversed := FALSE;
          ReversedEmployeeLedgerEntry.MODIFY;
          EmployeeLedgerEntry."Reversed Entry No." := "Entry No.";
          "Reversed by Entry No." := EmployeeLedgerEntry."Entry No.";
        END;
        EmployeeLedgerEntry."Applies-to ID" := '';
        EmployeeLedgerEntry."Reversed by Entry No." := "Entry No.";
        EmployeeLedgerEntry.Reversed := TRUE;
        EmployeeLedgerEntry.MODIFY;
        OnReverseEmplLedgEntryOnBeforeInsertEmplLedgEntry(NewEmployeeLedgerEntry,EmployeeLedgerEntry);
        INSERT;

        IF NextDtldEmplLedgEntryNo = 0 THEN BEGIN
          DetailedEmployeeLedgerEntry.FINDLAST;
          NextDtldEmplLedgEntryNo := DetailedEmployeeLedgerEntry."Entry No." + 1;
        END;
        DetailedEmployeeLedgerEntry.SETCURRENTKEY("Employee Ledger Entry No.");
        DetailedEmployeeLedgerEntry.SETRANGE("Employee Ledger Entry No.",EmployeeLedgerEntry."Entry No.");
        DetailedEmployeeLedgerEntry.SETRANGE(Unapplied,FALSE);
        DetailedEmployeeLedgerEntry.FINDSET;
        REPEAT
          DetailedEmployeeLedgerEntry.TESTFIELD("Entry Type",DetailedEmployeeLedgerEntry."Entry Type"::"Initial Entry");
          NewDetailedEmployeeLedgerEntry := DetailedEmployeeLedgerEntry;
          NewDetailedEmployeeLedgerEntry.Amount := -DetailedEmployeeLedgerEntry.Amount;
          NewDetailedEmployeeLedgerEntry."Amount (LCY)" := -DetailedEmployeeLedgerEntry."Amount (LCY)";
          NewDetailedEmployeeLedgerEntry.UpdateDebitCredit(Correction);
          NewDetailedEmployeeLedgerEntry."Employee Ledger Entry No." := NewEntryNo;
          NewDetailedEmployeeLedgerEntry."User ID" := USERID;
          NewDetailedEmployeeLedgerEntry."Transaction No." := GenJnlPostLine.GetNextTransactionNo;
          NewDetailedEmployeeLedgerEntry."Entry No." := NextDtldEmplLedgEntryNo;
          NextDtldEmplLedgEntryNo += 1;
          OnReverseEmplLedgEntryOnBeforeInsertDtldEmplLedgEntry(NewDetailedEmployeeLedgerEntry,DetailedEmployeeLedgerEntry);
          NewDetailedEmployeeLedgerEntry.INSERT(TRUE);
        UNTIL DetailedEmployeeLedgerEntry.NEXT = 0;

        ApplyEmplLedgEntryByReversal(
          EmployeeLedgerEntry,NewEmployeeLedgerEntry,NewDetailedEmployeeLedgerEntry,"Entry No.",NextDtldEmplLedgEntryNo);
        ApplyEmplLedgEntryByReversal(
          NewEmployeeLedgerEntry,EmployeeLedgerEntry,DetailedEmployeeLedgerEntry,"Entry No.",NextDtldEmplLedgEntryNo);
      END;
    END;

    LOCAL PROCEDURE ReverseBankAccLedgEntry@68(BankAccLedgEntry@1000 : Record 271;NewEntryNo@1001 : Integer;SourceCode@1005 : Code[10]);
    VAR
      NewBankAccLedgEntry@1002 : Record 271;
      ReversedBankAccLedgEntry@1004 : Record 271;
    BEGIN
      WITH NewBankAccLedgEntry DO BEGIN
        NewBankAccLedgEntry := BankAccLedgEntry;
        Amount := -Amount;
        "Remaining Amount" := -"Remaining Amount";
        "Amount (LCY)" := -"Amount (LCY)";
        "Debit Amount" := -"Debit Amount";
        "Credit Amount" := -"Credit Amount";
        "Debit Amount (LCY)" := -"Debit Amount (LCY)";
        "Credit Amount (LCY)" := -"Credit Amount (LCY)";
        Positive := NOT Positive;
        "User ID" := USERID;
        "Entry No." := NewEntryNo;
        "Transaction No." := GenJnlPostLine.GetNextTransactionNo;
        "Journal Batch Name" := '';
        "Source Code" := SourceCode;
        SetReversalDescription(BankAccLedgEntry,Description);
        "Reversed Entry No." := BankAccLedgEntry."Entry No.";
        Reversed := TRUE;
        // Reversal of Reversal
        IF BankAccLedgEntry."Reversed Entry No." <> 0 THEN BEGIN
          ReversedBankAccLedgEntry.GET(BankAccLedgEntry."Reversed Entry No.");
          ReversedBankAccLedgEntry."Reversed by Entry No." := 0;
          ReversedBankAccLedgEntry.Reversed := FALSE;
          ReversedBankAccLedgEntry.MODIFY;
          BankAccLedgEntry."Reversed Entry No." := "Entry No.";
          "Reversed by Entry No." := BankAccLedgEntry."Entry No.";
        END;
        BankAccLedgEntry."Reversed by Entry No." := "Entry No.";
        BankAccLedgEntry.Reversed := TRUE;
        BankAccLedgEntry.MODIFY;
        OnReverseBankAccLedgEntryOnBeforeInsert(NewBankAccLedgEntry,BankAccLedgEntry);
        INSERT;
      END;
    END;

    LOCAL PROCEDURE ReverseVAT@67(GLEntry@1005 : Record 17;SourceCode@1003 : Code[10]);
    VAR
      VATEntry@1000 : Record 254;
      NewVATEntry@1001 : Record 254;
      ReversedVATEntry@1002 : Record 254;
      GLEntryVATEntryLink@1004 : Record 253;
    BEGIN
      GLEntryVATEntryLink.SETRANGE("G/L Entry No.",GLEntry."Reversed Entry No.");
      IF GLEntryVATEntryLink.FINDSET THEN
        REPEAT
          VATEntry.GET(GLEntryVATEntryLink."VAT Entry No.");
          IF VATEntry."Reversed by Entry No." <> 0 THEN
            ERROR(CannotReverseErr);
          WITH NewVATEntry DO BEGIN
            NewVATEntry := VATEntry;
            Base := -Base;
            Amount := -Amount;
            "Unrealized Amount" := -"Unrealized Amount";
            "Unrealized Base" := -"Unrealized Base";
            "Remaining Unrealized Amount" := -"Remaining Unrealized Amount";
            "Remaining Unrealized Base" := -"Remaining Unrealized Base";
            "Additional-Currency Amount" := -"Additional-Currency Amount";
            "Additional-Currency Base" := -"Additional-Currency Base";
            "Add.-Currency Unrealized Amt." := -"Add.-Currency Unrealized Amt.";
            "Add.-Curr. Rem. Unreal. Amount" := -"Add.-Curr. Rem. Unreal. Amount";
            "Add.-Curr. Rem. Unreal. Base" := -"Add.-Curr. Rem. Unreal. Base";
            "VAT Difference" := -"VAT Difference";
            "Add.-Curr. VAT Difference" := -"Add.-Curr. VAT Difference";
            "Transaction No." := GenJnlPostLine.GetNextTransactionNo;
            "Source Code" := SourceCode;
            "User ID" := USERID;
            "Entry No." := GenJnlPostLine.GetNextVATEntryNo;
            "Reversed Entry No." := VATEntry."Entry No.";
            Reversed := TRUE;
            // Reversal of Reversal
            IF VATEntry."Reversed Entry No." <> 0 THEN BEGIN
              ReversedVATEntry.GET(VATEntry."Reversed Entry No.");
              ReversedVATEntry."Reversed by Entry No." := 0;
              ReversedVATEntry.Reversed := FALSE;
              ReversedVATEntry.MODIFY;
              VATEntry."Reversed Entry No." := "Entry No.";
              "Reversed by Entry No." := VATEntry."Entry No.";
            END;
            VATEntry."Reversed by Entry No." := "Entry No.";
            VATEntry.Reversed := TRUE;
            VATEntry.MODIFY;
            OnReverseVATEntryOnBeforeInsert(NewVATEntry,VATEntry);
            INSERT;
            GLEntryVATEntryLink.InsertLink(GLEntry."Entry No.","Entry No.");
            GenJnlPostLine.IncrNextVATEntryNo;
          END;
        UNTIL GLEntryVATEntryLink.NEXT = 0;
    END;

    LOCAL PROCEDURE ApplyCustLedgEntryByReversal@75(CustLedgEntry@1000 : Record 21;CustLedgEntry2@1001 : Record 21;DtldCustLedgEntry2@1002 : Record 379;AppliedEntryNo@1005 : Integer;VAR NextDtldCustLedgEntryEntryNo@1004 : Integer);
    VAR
      NewDtldCustLedgEntry@1003 : Record 379;
    BEGIN
      CustLedgEntry2.CALCFIELDS("Remaining Amount","Remaining Amt. (LCY)");
      CustLedgEntry."Closed by Entry No." := CustLedgEntry2."Entry No.";
      CustLedgEntry."Closed at Date" := CustLedgEntry2."Posting Date";
      CustLedgEntry."Closed by Amount" := -CustLedgEntry2."Remaining Amount";
      CustLedgEntry."Closed by Amount (LCY)" := -CustLedgEntry2."Remaining Amt. (LCY)";
      CustLedgEntry."Closed by Currency Code" := CustLedgEntry2."Currency Code";
      CustLedgEntry."Closed by Currency Amount" := -CustLedgEntry2."Remaining Amount";
      CustLedgEntry.Open := FALSE;
      CustLedgEntry.MODIFY;

      NewDtldCustLedgEntry := DtldCustLedgEntry2;
      NewDtldCustLedgEntry."Cust. Ledger Entry No." := CustLedgEntry."Entry No.";
      NewDtldCustLedgEntry."Entry Type" := NewDtldCustLedgEntry."Entry Type"::Application;
      NewDtldCustLedgEntry."Applied Cust. Ledger Entry No." := AppliedEntryNo;
      NewDtldCustLedgEntry."User ID" := USERID;
      NewDtldCustLedgEntry."Transaction No." := GenJnlPostLine.GetNextTransactionNo;
      NewDtldCustLedgEntry."Entry No." := NextDtldCustLedgEntryEntryNo;
      NextDtldCustLedgEntryEntryNo := NextDtldCustLedgEntryEntryNo + 1;
      OnApplyCustLedgEntryByReversalOnBeforeInsertDtldCustLedgEntry(NewDtldCustLedgEntry,DtldCustLedgEntry2);
      NewDtldCustLedgEntry.INSERT(TRUE);
    END;

    LOCAL PROCEDURE ApplyVendLedgEntryByReversal@76(VendLedgEntry@1000 : Record 25;VendLedgEntry2@1001 : Record 25;DtldVendLedgEntry2@1002 : Record 380;AppliedEntryNo@1005 : Integer;VAR NextDtldVendLedgEntryEntryNo@1004 : Integer);
    VAR
      NewDtldVendLedgEntry@1003 : Record 380;
    BEGIN
      VendLedgEntry2.CALCFIELDS("Remaining Amount","Remaining Amt. (LCY)");
      VendLedgEntry."Closed by Entry No." := VendLedgEntry2."Entry No.";
      VendLedgEntry."Closed at Date" := VendLedgEntry2."Posting Date";
      VendLedgEntry."Closed by Amount" := -VendLedgEntry2."Remaining Amount";
      VendLedgEntry."Closed by Amount (LCY)" := -VendLedgEntry2."Remaining Amt. (LCY)";
      VendLedgEntry."Closed by Currency Code" := VendLedgEntry2."Currency Code";
      VendLedgEntry."Closed by Currency Amount" := -VendLedgEntry2."Remaining Amount";
      VendLedgEntry.Open := FALSE;
      VendLedgEntry.MODIFY;

      NewDtldVendLedgEntry := DtldVendLedgEntry2;
      NewDtldVendLedgEntry."Vendor Ledger Entry No." := VendLedgEntry."Entry No.";
      NewDtldVendLedgEntry."Entry Type" := NewDtldVendLedgEntry."Entry Type"::Application;
      NewDtldVendLedgEntry."Applied Vend. Ledger Entry No." := AppliedEntryNo;
      NewDtldVendLedgEntry."User ID" := USERID;
      NewDtldVendLedgEntry."Transaction No." := GenJnlPostLine.GetNextTransactionNo;
      NewDtldVendLedgEntry."Entry No." := NextDtldVendLedgEntryEntryNo;
      NextDtldVendLedgEntryEntryNo := NextDtldVendLedgEntryEntryNo + 1;
      OnApplyVendLedgEntryByReversalOnBeforeInsertDtldVendLedgEntry(NewDtldVendLedgEntry,DtldVendLedgEntry2);
      NewDtldVendLedgEntry.INSERT(TRUE);
    END;

    LOCAL PROCEDURE ApplyEmplLedgEntryByReversal@26(EmployeeLedgerEntry@1000 : Record 5222;EmployeeLedgerEntry2@1001 : Record 5222;DetailedEmployeeLedgerEntry2@1002 : Record 5223;AppliedEntryNo@1004 : Integer;VAR NextDtldEmplLedgEntryNo@1003 : Integer);
    VAR
      NewDetailedEmployeeLedgerEntry@1005 : Record 5223;
    BEGIN
      EmployeeLedgerEntry2.CALCFIELDS("Remaining Amount","Remaining Amt. (LCY)");
      EmployeeLedgerEntry."Closed by Entry No." := EmployeeLedgerEntry2."Entry No.";
      EmployeeLedgerEntry."Closed at Date" := EmployeeLedgerEntry2."Posting Date";
      EmployeeLedgerEntry."Closed by Amount" := -EmployeeLedgerEntry2."Remaining Amount";
      EmployeeLedgerEntry."Closed by Amount (LCY)" := -EmployeeLedgerEntry2."Remaining Amt. (LCY)";
      EmployeeLedgerEntry.Open := FALSE;
      EmployeeLedgerEntry.MODIFY;

      NewDetailedEmployeeLedgerEntry := DetailedEmployeeLedgerEntry2;
      NewDetailedEmployeeLedgerEntry."Employee Ledger Entry No." := EmployeeLedgerEntry."Entry No.";
      NewDetailedEmployeeLedgerEntry."Entry Type" := NewDetailedEmployeeLedgerEntry."Entry Type"::Application;
      NewDetailedEmployeeLedgerEntry."Applied Empl. Ledger Entry No." := AppliedEntryNo;
      NewDetailedEmployeeLedgerEntry."User ID" := USERID;
      NewDetailedEmployeeLedgerEntry."Transaction No." := GenJnlPostLine.GetNextTransactionNo;
      NewDetailedEmployeeLedgerEntry."Entry No." := NextDtldEmplLedgEntryNo;
      NextDtldEmplLedgEntryNo += 1;
      OnApplyEmplLedgEntryByReversalOnBeforeInsertDtldEmplLedgEntry(NewDetailedEmployeeLedgerEntry,DetailedEmployeeLedgerEntry2);
      NewDetailedEmployeeLedgerEntry.INSERT(TRUE);
    END;

    LOCAL PROCEDURE CheckDimComb@91(EntryNo@1001 : Integer;DimSetID@1002 : Integer;TableID1@1006 : Integer;AccNo1@1007 : Code[20];TableID2@1009 : Integer;AccNo2@1008 : Code[20]);
    VAR
      DimMgt@1010 : Codeunit 408;
      TableID@1003 : ARRAY [10] OF Integer;
      AccNo@1005 : ARRAY [10] OF Code[20];
    BEGIN
      IF NOT DimMgt.CheckDimIDComb(DimSetID) THEN
        ERROR(DimCombBlockedErr,EntryNo,DimMgt.GetDimCombErr);
      CLEAR(TableID);
      CLEAR(AccNo);
      TableID[1] := TableID1;
      AccNo[1] := AccNo1;
      TableID[2] := TableID2;
      AccNo[2] := AccNo2;
      IF NOT DimMgt.CheckDimValuePosting(TableID,AccNo,DimSetID) THEN
        ERROR(DimMgt.GetDimValuePostingErr);
    END;

    LOCAL PROCEDURE CopyCustLedgEntry@1(VAR CustLedgEntry@1000 : Record 21;VAR TempCustLedgEntry@1001 : TEMPORARY Record 21);
    BEGIN
      IF CustLedgEntry.FINDSET THEN
        REPEAT
          IF CustLedgEntry."Reversed by Entry No." <> 0 THEN
            ERROR(CannotReverseErr);
          TempCustLedgEntry := CustLedgEntry;
          TempCustLedgEntry.INSERT;
        UNTIL CustLedgEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE CopyVendLedgEntry@3(VAR VendLedgEntry@1000 : Record 25;VAR TempVendLedgEntry@1001 : TEMPORARY Record 25);
    BEGIN
      IF VendLedgEntry.FINDSET THEN
        REPEAT
          IF VendLedgEntry."Reversed by Entry No." <> 0 THEN
            ERROR(CannotReverseErr);
          TempVendLedgEntry := VendLedgEntry;
          TempVendLedgEntry.INSERT;
        UNTIL VendLedgEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE CopyEmplLedgEntry@21(VAR EmployeeLedgerEntry@1000 : Record 5222;VAR TempEmployeeLedgerEntry@1001 : TEMPORARY Record 5222);
    BEGIN
      IF EmployeeLedgerEntry.FINDSET THEN
        REPEAT
          IF EmployeeLedgerEntry."Reversed by Entry No." <> 0 THEN
            ERROR(CannotReverseErr);
          TempEmployeeLedgerEntry := EmployeeLedgerEntry;
          TempEmployeeLedgerEntry.INSERT;
        UNTIL EmployeeLedgerEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE CopyBankAccLedgEntry@4(VAR BankAccLedgEntry@1000 : Record 271;VAR TempBankAccLedgEntry@1001 : TEMPORARY Record 271);
    BEGIN
      IF BankAccLedgEntry.FINDSET THEN
        REPEAT
          IF BankAccLedgEntry."Reversed by Entry No." <> 0 THEN
            ERROR(CannotReverseErr);
          TempBankAccLedgEntry := BankAccLedgEntry;
          TempBankAccLedgEntry.INSERT;
        UNTIL BankAccLedgEntry.NEXT = 0;
    END;

    PROCEDURE SetReversalDescription@2(RecVar@1000 : Variant;VAR Description@1002 : Text[50]);
    VAR
      ReversalEntry@1005 : Record 179;
    BEGIN
      FilterReversalEntry(ReversalEntry,RecVar);
      IF ReversalEntry.FINDFIRST THEN
        Description := ReversalEntry.Description;
    END;

    LOCAL PROCEDURE GetTransactionKey@11() : Integer;
    VAR
      ReversalEntry@1000 : Record 179;
    BEGIN
      ReversalEntry.SETCURRENTKEY("Transaction No.");
      ReversalEntry.SETFILTER("Transaction No.",'<%1',0);
      IF ReversalEntry.FINDFIRST THEN;
      EXIT(ReversalEntry."Transaction No." - 1);
    END;

    LOCAL PROCEDURE FilterReversalEntry@5(VAR ReversalEntry@1000 : Record 179;RecVar@1001 : Variant);
    VAR
      GLEntry@1002 : Record 17;
      CustLedgerEntry@1003 : Record 21;
      VendorLedgerEntry@1004 : Record 25;
      EmployeeLedgerEntry@1009 : Record 5222;
      BankAccountLedgerEntry@1005 : Record 271;
      FALedgerEntry@1006 : Record 5601;
      MaintenanceLedgerEntry@1007 : Record 5625;
      RecRef@1008 : RecordRef;
    BEGIN
      RecRef.GETTABLE(RecVar);
      CASE RecRef.NUMBER OF
        DATABASE::"G/L Entry":
          BEGIN
            ReversalEntry.SETRANGE("Entry Type",ReversalEntry."Entry Type"::"G/L Account");
            GLEntry := RecVar;
            ReversalEntry.SETRANGE("Entry No.",GLEntry."Entry No.");
          END;
        DATABASE::"Cust. Ledger Entry":
          BEGIN
            ReversalEntry.SETRANGE("Entry Type",ReversalEntry."Entry Type"::Customer);
            CustLedgerEntry := RecVar;
            ReversalEntry.SETRANGE("Entry No.",CustLedgerEntry."Entry No.");
          END;
        DATABASE::"Vendor Ledger Entry":
          BEGIN
            ReversalEntry.SETRANGE("Entry Type",ReversalEntry."Entry Type"::Vendor);
            VendorLedgerEntry := RecVar;
            ReversalEntry.SETRANGE("Entry No.",VendorLedgerEntry."Entry No.");
          END;
        DATABASE::"Employee Ledger Entry":
          BEGIN
            ReversalEntry.SETRANGE("Entry Type",ReversalEntry."Entry Type"::Employee);
            EmployeeLedgerEntry := RecVar;
            ReversalEntry.SETRANGE("Entry No.",EmployeeLedgerEntry."Entry No.");
          END;
        DATABASE::"Bank Account Ledger Entry":
          BEGIN
            ReversalEntry.SETRANGE("Entry Type",ReversalEntry."Entry Type"::"Bank Account");
            BankAccountLedgerEntry := RecVar;
            ReversalEntry.SETRANGE("Entry No.",BankAccountLedgerEntry."Entry No.");
          END;
        DATABASE::"FA Ledger Entry":
          BEGIN
            ReversalEntry.SETRANGE("Entry Type",ReversalEntry."Entry Type"::"Fixed Asset");
            FALedgerEntry := RecVar;
            ReversalEntry.SETRANGE("Entry No.",FALedgerEntry."Entry No.");
          END;
        DATABASE::"Maintenance Ledger Entry":
          BEGIN
            ReversalEntry.SETRANGE("Entry Type",ReversalEntry."Entry Type"::Maintenance);
            MaintenanceLedgerEntry := RecVar;
            ReversalEntry.SETRANGE("Entry No.",MaintenanceLedgerEntry."Entry No.");
          END;
      END;
    END;

    LOCAL PROCEDURE SaveReversalEntries@22(VAR TempReversalEntry@1000 : TEMPORARY Record 179;TransactionKey@1002 : Integer);
    VAR
      ReversalEntry@1001 : Record 179;
    BEGIN
      IF TempReversalEntry.FINDSET THEN
        REPEAT
          ReversalEntry := TempReversalEntry;
          ReversalEntry."Transaction No." := TransactionKey;
          ReversalEntry.INSERT;
        UNTIL TempReversalEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE DeleteReversalEntries@23(TransactionKey@1001 : Integer);
    VAR
      ReversalEntry@1000 : Record 179;
    BEGIN
      ReversalEntry.SETRANGE("Transaction No.",TransactionKey);
      ReversalEntry.DELETEALL;
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeReverse@7(VAR ReversalEntry@1000 : Record 179;VAR ReversalEntry2@1001 : Record 179);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnReverseGLEntryOnBeforeInsertGLEntry@8(VAR GLEntry@1001 : Record 17;GenJnlLine@1000 : Record 81;GLEntry2@1002 : Record 17);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnReverseCustLedgEntryOnBeforeInsertCustLedgEntry@9(VAR NewCustLedgerEntry@1000 : Record 21;CustLedgerEntry@1002 : Record 21);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnReverseVendLedgEntryOnBeforeInsertVendLedgEntry@10(VAR NewVendLedgEntry@1000 : Record 25;VendLedgEntry@1002 : Record 25);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnReverseEmplLedgEntryOnBeforeInsertEmplLedgEntry@31(VAR NewEmployeeLedgerEntry@1000 : Record 5222;EmployeeLedgerEntry@1002 : Record 5222);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnReverseBankAccLedgEntryOnBeforeInsert@12(VAR NewBankAccLedgEntry@1002 : Record 271;BankAccLedgEntry@1001 : Record 271);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnReverseCustLedgEntryOnBeforeInsertDtldCustLedgEntry@14(VAR NewDtldCustLedgEntry@1000 : Record 379;DtldCustLedgEntry@1001 : Record 379);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnReverseVendLedgEntryOnBeforeInsertDtldVendLedgEntry@15(VAR NewDtldVendLedgEntry@1000 : Record 380;DtldVendLedgEntry@1001 : Record 380);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnReverseEmplLedgEntryOnBeforeInsertDtldEmplLedgEntry@32(VAR NewDetailedEmployeeLedgerEntry@1000 : Record 5223;DetailedEmployeeLedgerEntry@1001 : Record 5223);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnReverseVATEntryOnBeforeInsert@17(VAR NewVATEntry@1000 : Record 254;VATEntry@1001 : Record 254);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnApplyCustLedgEntryByReversalOnBeforeInsertDtldCustLedgEntry@19(VAR NewDtldCustLedgEntry@1000 : Record 379;DtldCustLedgEntry@1001 : Record 379);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnApplyVendLedgEntryByReversalOnBeforeInsertDtldVendLedgEntry@20(VAR NewDtldVendLedgEntry@1000 : Record 380;DtldVendLedgEntry@1001 : Record 380);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnApplyEmplLedgEntryByReversalOnBeforeInsertDtldEmplLedgEntry@33(VAR NewDetailedEmployeeLedgerEntry@1000 : Record 5223;DetailedEmployeeLedgerEntry@1001 : Record 5223);
    BEGIN
    END;

    BEGIN
    END.
  }
}

