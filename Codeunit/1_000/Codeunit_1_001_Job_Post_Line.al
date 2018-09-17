OBJECT Codeunit 1001 Job Post-Line
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    Permissions=TableData 169=rm,
                TableData 1003=rimd;
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      TempSalesLineJob@1005 : TEMPORARY Record 37;
      TempPurchaseLineJob@1002 : TEMPORARY Record 39;
      TempJobJournalLine@1004 : TEMPORARY Record 210;
      JobJnlPostLine@1003 : Codeunit 1012;
      JobTransferLine@1001 : Codeunit 1004;
      Text000@1011 : TextConst 'DAN="er blevet �ndret (oprindeligt en %1: %2= %3, %4= %5)";ENU="has been changed (initial a %1: %2= %3, %4= %5)"';
      Text003@1000 : TextConst 'DAN=Du kan ikke �ndre salgslinjen, fordi den er knyttet til\;ENU=You cannot change the sales line because it is linked to\';
      Text004@1014 : TextConst 'DAN=" %1: %2= %3, %4= %5.";ENU=" %1: %2= %3, %4= %5."';
      Text005@1015 : TextConst 'DAN="Du skal bogf�re mere forbrug eller kreditere salget af %1 %2 i %3 %4, inden du kan bogf�re k�bskreditnota %5 %6 = %7.";ENU="You must post more usage or credit the sale of %1 %2 in %3 %4 before you can post purchase credit memo %5 %6 = %7."';

    [External]
    PROCEDURE InsertPlLineFromLedgEntry@2(JobLedgEntry@1003 : Record 169);
    VAR
      JobPlanningLine@1002 : Record 1003;
    BEGIN
      IF JobLedgEntry."Line Type" = JobLedgEntry."Line Type"::" " THEN
        EXIT;
      CLEARALL;
      JobPlanningLine."Job No." := JobLedgEntry."Job No.";
      JobPlanningLine."Job Task No." := JobLedgEntry."Job Task No.";
      JobPlanningLine.SETRANGE("Job No.",JobPlanningLine."Job No.");
      JobPlanningLine.SETRANGE("Job Task No.",JobPlanningLine."Job Task No.");
      IF JobPlanningLine.FINDLAST THEN;
      JobPlanningLine."Line No." := JobPlanningLine."Line No." + 10000;
      JobPlanningLine.INIT;
      JobPlanningLine.RESET;
      CLEAR(JobTransferLine);
      JobTransferLine.FromJobLedgEntryToPlanningLine(JobLedgEntry,JobPlanningLine);
      PostPlanningLine(JobPlanningLine);
    END;

    LOCAL PROCEDURE PostPlanningLine@9(JobPlanningLine@1000 : Record 1003);
    VAR
      Job@1001 : Record 167;
    BEGIN
      IF JobPlanningLine."Line Type" = JobPlanningLine."Line Type"::"Both Budget and Billable" THEN BEGIN
        Job.GET(JobPlanningLine."Job No.");
        IF NOT Job."Allow Schedule/Contract Lines" OR
           (JobPlanningLine.Type = JobPlanningLine.Type::"G/L Account")
        THEN BEGIN
          JobPlanningLine.VALIDATE("Line Type",JobPlanningLine."Line Type"::Budget);
          JobPlanningLine.INSERT(TRUE);
          InsertJobUsageLink(JobPlanningLine);
          JobPlanningLine.VALIDATE("Qty. to Transfer to Journal",0);
          JobPlanningLine.MODIFY(TRUE);
          JobPlanningLine."Job Contract Entry No." := 0;
          JobPlanningLine."Line No." := JobPlanningLine."Line No." + 10000;
          JobPlanningLine.VALIDATE("Line Type",JobPlanningLine."Line Type"::Billable);
        END;
      END;
      IF (JobPlanningLine.Type = JobPlanningLine.Type::"G/L Account") AND
         (JobPlanningLine."Line Type" = JobPlanningLine."Line Type"::Billable)
      THEN
        ChangeGLNo(JobPlanningLine);
      JobPlanningLine.INSERT(TRUE);
      JobPlanningLine.VALIDATE("Qty. to Transfer to Journal",0);
      JobPlanningLine.MODIFY(TRUE);
      IF JobPlanningLine."Line Type" IN
         [JobPlanningLine."Line Type"::Budget,JobPlanningLine."Line Type"::"Both Budget and Billable"]
      THEN
        InsertJobUsageLink(JobPlanningLine);
    END;

    LOCAL PROCEDURE InsertJobUsageLink@4(JobPlanningLine@1001 : Record 1003);
    VAR
      JobUsageLink@1000 : Record 1020;
      JobLedgerEntry@1002 : Record 169;
    BEGIN
      IF NOT JobPlanningLine."Usage Link" THEN
        EXIT;
      JobLedgerEntry.GET(JobPlanningLine."Job Ledger Entry No.");
      JobUsageLink.Create(JobPlanningLine,JobLedgerEntry);
    END;

    PROCEDURE PostInvoiceContractLine@14(SalesHeader@1006 : Record 36;SalesLine@1000 : Record 37);
    VAR
      Job@1003 : Record 167;
      JobPlanningLine@1001 : Record 1003;
      JobPlanningLineInvoice@1009 : Record 1022;
      EntryType@1010 : 'Usage,Sale';
      JobLedgEntryNo@1004 : Integer;
    BEGIN
      JobPlanningLine.SETCURRENTKEY("Job Contract Entry No.");
      JobPlanningLine.SETRANGE("Job Contract Entry No.",SalesLine."Job Contract Entry No.");
      JobPlanningLine.FINDFIRST;
      Job.GET(JobPlanningLine."Job No.");

      IF Job."Invoice Currency Code" = '' THEN BEGIN
        Job.TESTFIELD("Currency Code",SalesHeader."Currency Code");
        Job.TESTFIELD("Currency Code",JobPlanningLine."Currency Code");
        SalesHeader.TESTFIELD("Currency Code",JobPlanningLine."Currency Code");
        SalesHeader.TESTFIELD("Currency Factor",JobPlanningLine."Currency Factor");
      END ELSE BEGIN
        Job.TESTFIELD("Currency Code",'');
        JobPlanningLine.TESTFIELD("Currency Code",'');
      END;

      SalesHeader.TESTFIELD("Bill-to Customer No.",Job."Bill-to Customer No.");
      JobPlanningLine.CALCFIELDS("Qty. Transferred to Invoice");
      IF JobPlanningLine.Type <> JobPlanningLine.Type::Text THEN
        JobPlanningLine.TESTFIELD("Qty. Transferred to Invoice");

      ValidateRelationship(SalesHeader,SalesLine,JobPlanningLine);

      CASE SalesHeader."Document Type" OF
        SalesHeader."Document Type"::Invoice:
          IF JobPlanningLineInvoice.GET(JobPlanningLine."Job No.",JobPlanningLine."Job Task No.",JobPlanningLine."Line No.",
               JobPlanningLineInvoice."Document Type"::Invoice,SalesHeader."No.",SalesLine."Line No.")
          THEN BEGIN
            JobPlanningLineInvoice.DELETE(TRUE);
            JobPlanningLineInvoice."Document Type" := JobPlanningLineInvoice."Document Type"::"Posted Invoice";
            JobPlanningLineInvoice."Document No." := SalesLine."Document No.";
            JobLedgEntryNo := FindNextJobLedgEntryNo(JobPlanningLineInvoice);
            JobPlanningLineInvoice.INSERT(TRUE);

            JobPlanningLineInvoice."Invoiced Date" := SalesHeader."Posting Date";
            JobPlanningLineInvoice."Invoiced Amount (LCY)" :=
              CalcLineAmountLCY(JobPlanningLine,JobPlanningLineInvoice."Quantity Transferred");
            JobPlanningLineInvoice."Invoiced Cost Amount (LCY)" :=
              JobPlanningLineInvoice."Quantity Transferred" * JobPlanningLine."Unit Cost (LCY)";
            JobPlanningLineInvoice."Job Ledger Entry No." := JobLedgEntryNo;
            JobPlanningLineInvoice.MODIFY;
          END;
        SalesHeader."Document Type"::"Credit Memo":
          IF JobPlanningLineInvoice.GET(JobPlanningLine."Job No.",JobPlanningLine."Job Task No.",JobPlanningLine."Line No.",
               JobPlanningLineInvoice."Document Type"::"Credit Memo",SalesHeader."No.",SalesLine."Line No.")
          THEN BEGIN
            JobPlanningLineInvoice.DELETE(TRUE);
            JobPlanningLineInvoice."Document Type" := JobPlanningLineInvoice."Document Type"::"Posted Credit Memo";
            JobPlanningLineInvoice."Document No." := SalesLine."Document No.";
            JobLedgEntryNo := FindNextJobLedgEntryNo(JobPlanningLineInvoice);
            JobPlanningLineInvoice.INSERT(TRUE);

            JobPlanningLineInvoice."Invoiced Date" := SalesHeader."Posting Date";
            JobPlanningLineInvoice."Invoiced Amount (LCY)" :=
              CalcLineAmountLCY(JobPlanningLine,JobPlanningLineInvoice."Quantity Transferred");
            JobPlanningLineInvoice."Invoiced Cost Amount (LCY)" :=
              JobPlanningLineInvoice."Quantity Transferred" * JobPlanningLine."Unit Cost (LCY)";
            JobPlanningLineInvoice."Job Ledger Entry No." := JobLedgEntryNo;
            JobPlanningLineInvoice.MODIFY;
          END;
      END;

      JobPlanningLine.UpdateQtyToInvoice;
      JobPlanningLine.MODIFY;

      IF JobPlanningLine.Type <> JobPlanningLine.Type::Text THEN
        PostJobOnSalesLine(JobPlanningLine,SalesHeader,SalesLine,EntryType::Sale);
    END;

    LOCAL PROCEDURE ValidateRelationship@7(SalesHeader@1006 : Record 36;SalesLine@1000 : Record 37;JobPlanningLine@1005 : Record 1003);
    VAR
      JobTask@1002 : Record 1001;
      Txt@1001 : Text[500];
    BEGIN
      JobTask.GET(JobPlanningLine."Job No.",JobPlanningLine."Job Task No.");
      Txt := STRSUBSTNO(Text000,
          JobTask.TABLECAPTION,JobTask.FIELDCAPTION("Job No."),JobTask."Job No.",
          JobTask.FIELDCAPTION("Job Task No."),JobTask."Job Task No.");

      IF JobPlanningLine.Type = JobPlanningLine.Type::Text THEN
        IF SalesLine.Type <> SalesLine.Type::" " THEN
          SalesLine.FIELDERROR(Type,Txt);
      IF JobPlanningLine.Type = JobPlanningLine.Type::Resource THEN
        IF SalesLine.Type <> SalesLine.Type::Resource THEN
          SalesLine.FIELDERROR(Type,Txt);
      IF JobPlanningLine.Type = JobPlanningLine.Type::Item THEN
        IF SalesLine.Type <> SalesLine.Type::Item THEN
          SalesLine.FIELDERROR(Type,Txt);
      IF JobPlanningLine.Type = JobPlanningLine.Type::"G/L Account" THEN
        IF SalesLine.Type <> SalesLine.Type::"G/L Account" THEN
          SalesLine.FIELDERROR(Type,Txt);

      IF SalesLine."No." <> JobPlanningLine."No." THEN
        SalesLine.FIELDERROR("No.",Txt);
      IF SalesLine."Location Code" <> JobPlanningLine."Location Code" THEN
        SalesLine.FIELDERROR("Location Code",Txt);
      IF SalesLine."Work Type Code" <> JobPlanningLine."Work Type Code" THEN
        SalesLine.FIELDERROR("Work Type Code",Txt);
      IF SalesLine."Unit of Measure Code" <> JobPlanningLine."Unit of Measure Code" THEN
        SalesLine.FIELDERROR("Unit of Measure Code",Txt);
      IF SalesLine."Variant Code" <> JobPlanningLine."Variant Code" THEN
        SalesLine.FIELDERROR("Variant Code",Txt);
      IF SalesLine."Gen. Prod. Posting Group" <> JobPlanningLine."Gen. Prod. Posting Group" THEN
        SalesLine.FIELDERROR("Gen. Prod. Posting Group",Txt);
      IF SalesLine."Line Discount %" <> JobPlanningLine."Line Discount %" THEN
        SalesLine.FIELDERROR("Line Discount %",Txt);
      IF JobPlanningLine."Unit Cost (LCY)" <> SalesLine."Unit Cost (LCY)" THEN
        SalesLine.FIELDERROR("Unit Cost (LCY)",Txt);
      IF SalesLine.Type = SalesLine.Type::" " THEN BEGIN
        IF SalesLine."Line Amount" <> 0 THEN
          SalesLine.FIELDERROR("Line Amount",Txt);
      END;
      IF SalesHeader."Prices Including VAT" THEN BEGIN
        IF JobPlanningLine."VAT %" <> SalesLine."VAT %" THEN
          SalesLine.FIELDERROR("VAT %",Txt);
      END;
    END;

    LOCAL PROCEDURE PostJobOnSalesLine@21(JobPlanningLine@1000 : Record 1003;SalesHeader@1003 : Record 36;SalesLine@1002 : Record 37;EntryType@1004 : 'Usage,Sale');
    VAR
      JobJnlLine@1001 : Record 210;
    BEGIN
      JobTransferLine.FromPlanningSalesLineToJnlLine(JobPlanningLine,SalesHeader,SalesLine,JobJnlLine,EntryType);
      IF SalesLine.Type = SalesLine.Type::"G/L Account" THEN BEGIN
        TempSalesLineJob := SalesLine;
        TempSalesLineJob.INSERT;
        InsertTempJobJournalLine(JobJnlLine,TempSalesLineJob."Line No.");
      END ELSE
        JobJnlPostLine.RunWithCheck(JobJnlLine);
    END;

    LOCAL PROCEDURE CalcLineAmountLCY@19(JobPlanningLine@1002 : Record 1003;Qty@1000 : Decimal) : Decimal;
    VAR
      TotalPrice@1001 : Decimal;
    BEGIN
      TotalPrice := ROUND(Qty * JobPlanningLine."Unit Price (LCY)",0.01);
      EXIT(TotalPrice - ROUND(TotalPrice * JobPlanningLine."Line Discount %" / 100,0.01));
    END;

    PROCEDURE PostGenJnlLine@1(GenJnlLine@1000 : Record 81;GLEntry@1002 : Record 17);
    VAR
      JobJnlLine@1001 : Record 210;
      Job@1004 : Record 167;
      JT@1003 : Record 1001;
      SourceCodeSetup@1007 : Record 242;
      JobTransferLine@1005 : Codeunit 1004;
    BEGIN
      IF GenJnlLine."System-Created Entry" THEN
        EXIT;
      IF GenJnlLine."Job No." = '' THEN
        EXIT;
      SourceCodeSetup.GET;
      IF GenJnlLine."Source Code" = SourceCodeSetup."Job G/L WIP" THEN
        EXIT;
      GenJnlLine.TESTFIELD("Job Task No.");
      GenJnlLine.TESTFIELD("Job Quantity");
      Job.LOCKTABLE;
      JT.LOCKTABLE;
      Job.GET(GenJnlLine."Job No.");
      GenJnlLine.TESTFIELD("Job Currency Code",Job."Currency Code");
      JT.GET(GenJnlLine."Job No.",GenJnlLine."Job Task No.");
      JT.TESTFIELD("Job Task Type",JT."Job Task Type"::Posting);
      JobTransferLine.FromGenJnlLineToJnlLine(GenJnlLine,JobJnlLine);

      JobJnlPostLine.SetGLEntryNo(GLEntry."Entry No.");
      JobJnlPostLine.RunWithCheck(JobJnlLine);
      JobJnlPostLine.SetGLEntryNo(0);
    END;

    PROCEDURE PostJobOnPurchaseLine@12(VAR PurchHeader@1006 : Record 38;VAR PurchInvHeader@1004 : Record 122;VAR PurchCrMemoHdr@1005 : Record 124;PurchLine@1000 : Record 39;Sourcecode@1007 : Code[10]);
    VAR
      JobJnlLine@1003 : Record 210;
      Job@1001 : Record 167;
      JobTask@1002 : Record 1001;
    BEGIN
      OnBeforePostJobOnPurchaseLine(PurchHeader,PurchInvHeader,PurchCrMemoHdr,PurchLine,JobJnlLine);

      IF (PurchLine.Type <> PurchLine.Type::Item) AND (PurchLine.Type <> PurchLine.Type::"G/L Account") THEN
        EXIT;
      CLEAR(JobJnlLine);
      PurchLine.TESTFIELD("Job No.");
      PurchLine.TESTFIELD("Job Task No.");
      Job.LOCKTABLE;
      JobTask.LOCKTABLE;
      Job.GET(PurchLine."Job No.");
      PurchLine.TESTFIELD("Job Currency Code",Job."Currency Code");
      JobTask.GET(PurchLine."Job No.",PurchLine."Job Task No.");
      JobTransferLine.FromPurchaseLineToJnlLine(
        PurchHeader,PurchInvHeader,PurchCrMemoHdr,PurchLine,Sourcecode,JobJnlLine);
      JobJnlLine."Job Posting Only" := TRUE;

      IF PurchLine.Type = PurchLine.Type::"G/L Account" THEN BEGIN
        TempPurchaseLineJob := PurchLine;
        TempPurchaseLineJob.INSERT;
        InsertTempJobJournalLine(JobJnlLine,TempPurchaseLineJob."Line No.");
      END ELSE
        JobJnlPostLine.RunWithCheck(JobJnlLine);
    END;

    [External]
    PROCEDURE TestSalesLine@11(VAR SalesLine@1000 : Record 37);
    VAR
      JT@1003 : Record 1001;
      JobPlanningLine@1001 : Record 1003;
      Txt@1002 : Text[250];
    BEGIN
      IF SalesLine."Job Contract Entry No." = 0 THEN
        EXIT;
      JobPlanningLine.SETCURRENTKEY("Job Contract Entry No.");
      JobPlanningLine.SETRANGE("Job Contract Entry No.",SalesLine."Job Contract Entry No.");
      IF JobPlanningLine.FINDFIRST THEN BEGIN
        JT.GET(JobPlanningLine."Job No.",JobPlanningLine."Job Task No.");
        Txt := Text003 + STRSUBSTNO(Text004,
            JT.TABLECAPTION,JT.FIELDCAPTION("Job No."),JT."Job No.",
            JT.FIELDCAPTION("Job Task No."),JT."Job Task No.");
        ERROR(Txt);
      END;
    END;

    LOCAL PROCEDURE ChangeGLNo@13(VAR JobPlanningLine@1000 : Record 1003);
    VAR
      GLAcc@1003 : Record 15;
      Job@1001 : Record 167;
      JT@1002 : Record 1001;
      JobPostingGr@1004 : Record 208;
      Cust@1005 : Record 18;
    BEGIN
      JT.GET(JobPlanningLine."Job No.",JobPlanningLine."Job Task No.");
      Job.GET(JobPlanningLine."Job No.");
      Cust.GET(Job."Bill-to Customer No.");
      IF JT."Job Posting Group" <> '' THEN
        JobPostingGr.GET(JT."Job Posting Group")
      ELSE BEGIN
        Job.TESTFIELD("Job Posting Group");
        JobPostingGr.GET(Job."Job Posting Group");
      END;
      IF JobPostingGr."G/L Expense Acc. (Contract)" = '' THEN
        EXIT;
      GLAcc.GET(JobPostingGr."G/L Expense Acc. (Contract)");
      GLAcc.CheckGLAcc;
      JobPlanningLine."No." := GLAcc."No.";
      JobPlanningLine."Gen. Bus. Posting Group" := Cust."Gen. Bus. Posting Group";
      JobPlanningLine."Gen. Prod. Posting Group" := GLAcc."Gen. Prod. Posting Group";
    END;

    [External]
    PROCEDURE CheckItemQuantityPurchCredit@15(VAR PurchaseHeader@1006 : Record 38;VAR PurchaseLine@1001 : Record 39);
    VAR
      Item@1003 : Record 27;
      Job@1007 : Record 167;
    BEGIN
      Job.GET(PurchaseLine."Job No.");
      IF Job.GetQuantityAvailable(PurchaseLine."No.",PurchaseLine."Location Code",PurchaseLine."Variant Code",0,2) <
         -PurchaseLine."Return Qty. to Ship (Base)"
      THEN
        ERROR(
          Text005,Item.TABLECAPTION,PurchaseLine."No.",Job.TABLECAPTION,
          PurchaseLine."Job No.",PurchaseHeader."No.",
          PurchaseLine.FIELDCAPTION("Line No."),PurchaseLine."Line No.");
    END;

    PROCEDURE PostPurchaseGLAccounts@5(TempInvoicePostBuffer@1000 : TEMPORARY Record 49;GLEntryNo@1001 : Integer);
    BEGIN
      WITH TempPurchaseLineJob DO BEGIN
        RESET;
        SETRANGE("Job No.",TempInvoicePostBuffer."Job No.");
        SETRANGE("No.",TempInvoicePostBuffer."G/L Account");
        SETRANGE("Gen. Bus. Posting Group",TempInvoicePostBuffer."Gen. Bus. Posting Group");
        SETRANGE("Gen. Prod. Posting Group",TempInvoicePostBuffer."Gen. Prod. Posting Group");
        SETRANGE("VAT Bus. Posting Group",TempInvoicePostBuffer."VAT Bus. Posting Group");
        SETRANGE("VAT Prod. Posting Group",TempInvoicePostBuffer."VAT Prod. Posting Group");
        IF FINDSET THEN BEGIN
          REPEAT
            TempJobJournalLine.RESET;
            TempJobJournalLine.SETRANGE("Line No.","Line No.");
            TempJobJournalLine.FINDFIRST;
            JobJnlPostLine.SetGLEntryNo(GLEntryNo);
            JobJnlPostLine.RunWithCheck(TempJobJournalLine);
          UNTIL NEXT = 0;
          DELETEALL;
        END;
      END;
    END;

    PROCEDURE PostSalesGLAccounts@8(TempInvoicePostBuffer@1005 : TEMPORARY Record 49;GLEntryNo@1000 : Integer);
    BEGIN
      WITH TempSalesLineJob DO BEGIN
        RESET;
        SETRANGE("Job No.",TempInvoicePostBuffer."Job No.");
        SETRANGE("No.",TempInvoicePostBuffer."G/L Account");
        SETRANGE("Gen. Bus. Posting Group",TempInvoicePostBuffer."Gen. Bus. Posting Group");
        SETRANGE("Gen. Prod. Posting Group",TempInvoicePostBuffer."Gen. Prod. Posting Group");
        SETRANGE("VAT Bus. Posting Group",TempInvoicePostBuffer."VAT Bus. Posting Group");
        SETRANGE("VAT Prod. Posting Group",TempInvoicePostBuffer."VAT Prod. Posting Group");
        IF FINDSET THEN BEGIN
          REPEAT
            TempJobJournalLine.RESET;
            TempJobJournalLine.SETRANGE("Line No.","Line No.");
            TempJobJournalLine.FINDFIRST;
            JobJnlPostLine.SetGLEntryNo(GLEntryNo);
            JobJnlPostLine.RunWithCheck(TempJobJournalLine);
          UNTIL NEXT = 0;
          DELETEALL;
        END;
      END;
    END;

    LOCAL PROCEDURE InsertTempJobJournalLine@23(JobJournalLine@1000 : Record 210;LineNo@1001 : Integer);
    BEGIN
      TempJobJournalLine := JobJournalLine;
      TempJobJournalLine."Line No." := LineNo;
      TempJobJournalLine.INSERT;
    END;

    LOCAL PROCEDURE FindNextJobLedgEntryNo@3(JobPlanningLineInvoice@1001 : Record 1022) : Integer;
    VAR
      RelatedJobPlanningLineInvoice@1000 : Record 1022;
      JobLedgEntry@1002 : Record 169;
    BEGIN
      RelatedJobPlanningLineInvoice.SETRANGE("Document Type",JobPlanningLineInvoice."Document Type");
      RelatedJobPlanningLineInvoice.SETRANGE("Document No.",JobPlanningLineInvoice."Document No.");
      IF RelatedJobPlanningLineInvoice.FINDLAST THEN
        EXIT(RelatedJobPlanningLineInvoice."Job Ledger Entry No." + 1);
      IF JobLedgEntry.FINDLAST THEN
        EXIT(JobLedgEntry."Entry No." + 1);
      EXIT(1);
    END;

    [Integration(DEFAULT,TRUE)]
    LOCAL PROCEDURE OnBeforePostJobOnPurchaseLine@24(VAR PurchHeader@1000 : Record 38;VAR PurchInvHeader@1002 : Record 122;VAR PurchCrMemoHdr@1003 : Record 124;VAR PurchLine@1004 : Record 39;VAR JobJnlLine@1005 : Record 210);
    BEGIN
    END;

    BEGIN
    END.
  }
}

