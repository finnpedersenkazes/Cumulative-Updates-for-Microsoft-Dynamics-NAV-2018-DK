OBJECT Codeunit 228 Test Report-Print
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      ReportSelection@1002 : Record 77;
      GenJnlTemplate@1003 : Record 80;
      VATStmtTmpl@1004 : Record 255;
      ItemJnlTemplate@1005 : Record 82;
      IntraJnlTemplate@1007 : Record 261;
      GenJnlLine@1008 : Record 81;
      VATStmtLine@1009 : Record 256;
      ItemJnlLine@1010 : Record 83;
      IntrastatJnlLine@1012 : Record 263;
      ResJnlTemplate@1013 : Record 206;
      ResJnlLine@1014 : Record 207;
      JobJnlTemplate@1015 : Record 209;
      JobJnlLine@1016 : Record 210;
      FAJnlLine@1018 : Record 5621;
      FAJnlTemplate@1019 : Record 5619;
      InsuranceJnlLine@1020 : Record 5635;
      InsuranceJnlTempl@1021 : Record 5633;
      WhseJnlTemplate@1030 : Record 7309;
      WhseJnlLine@1029 : Record 7311;

    [External]
    PROCEDURE PrintGenJnlBatch@2(GenJnlBatch@1000 : Record 232);
    BEGIN
      GenJnlBatch.SETRECFILTER;
      GenJnlTemplate.GET(GenJnlBatch."Journal Template Name");
      GenJnlTemplate.TESTFIELD("Test Report ID");
      REPORT.RUN(GenJnlTemplate."Test Report ID",TRUE,FALSE,GenJnlBatch);
    END;

    [External]
    PROCEDURE PrintGenJnlLine@3(VAR NewGenJnlLine@1000 : Record 81);
    BEGIN
      GenJnlLine.COPY(NewGenJnlLine);
      GenJnlLine.SETRANGE("Journal Template Name",GenJnlLine."Journal Template Name");
      GenJnlLine.SETRANGE("Journal Batch Name",GenJnlLine."Journal Batch Name");
      GenJnlTemplate.GET(GenJnlLine."Journal Template Name");
      GenJnlTemplate.TESTFIELD("Test Report ID");
      REPORT.RUN(GenJnlTemplate."Test Report ID",TRUE,FALSE,GenJnlLine);
    END;

    [External]
    PROCEDURE PrintVATStmtName@4(VATStmtName@1000 : Record 257);
    BEGIN
      VATStmtName.SETRECFILTER;
      VATStmtTmpl.GET(VATStmtName."Statement Template Name");
      VATStmtTmpl.TESTFIELD("VAT Statement Report ID");
      REPORT.RUN(VATStmtTmpl."VAT Statement Report ID",TRUE,FALSE,VATStmtName);
    END;

    [External]
    PROCEDURE PrintVATStmtLine@5(VAR NewVATStatementLine@1000 : Record 256);
    BEGIN
      VATStmtLine.COPY(NewVATStatementLine);
      VATStmtLine.SETRANGE("Statement Template Name",VATStmtLine."Statement Template Name");
      VATStmtLine.SETRANGE("Statement Name",VATStmtLine."Statement Name");
      VATStmtTmpl.GET(VATStmtLine."Statement Template Name");
      VATStmtTmpl.TESTFIELD("VAT Statement Report ID");
      REPORT.RUN(VATStmtTmpl."VAT Statement Report ID",TRUE,FALSE,VATStmtLine);
    END;

    [External]
    PROCEDURE PrintItemJnlBatch@6(ItemJnlBatch@1000 : Record 233);
    BEGIN
      ItemJnlBatch.SETRECFILTER;
      ItemJnlTemplate.GET(ItemJnlBatch."Journal Template Name");
      ItemJnlTemplate.TESTFIELD("Test Report ID");
      REPORT.RUN(ItemJnlTemplate."Test Report ID",TRUE,FALSE,ItemJnlBatch);
    END;

    [External]
    PROCEDURE PrintItemJnlLine@7(VAR NewItemJnlLine@1000 : Record 83);
    BEGIN
      ItemJnlLine.COPY(NewItemJnlLine);
      ItemJnlLine.SETRANGE("Journal Template Name",ItemJnlLine."Journal Template Name");
      ItemJnlLine.SETRANGE("Journal Batch Name",ItemJnlLine."Journal Batch Name");
      ItemJnlTemplate.GET(ItemJnlLine."Journal Template Name");
      ItemJnlTemplate.TESTFIELD("Test Report ID");
      REPORT.RUN(ItemJnlTemplate."Test Report ID",TRUE,FALSE,ItemJnlLine);
    END;

    [External]
    PROCEDURE PrintIntrastatJnlLine@16(VAR NewIntrastatJnlLine@1000 : Record 263);
    VAR
      FileManagement@1009 : Codeunit 419;
    BEGIN
      IntrastatJnlLine.COPY(NewIntrastatJnlLine);
      IntrastatJnlLine.SETCURRENTKEY(Type,"Country/Region Code","Tariff No.","Transaction Type","Transport Method");
      IntrastatJnlLine.SETRANGE("Journal Template Name",IntrastatJnlLine."Journal Template Name");
      IntrastatJnlLine.SETRANGE("Journal Batch Name",IntrastatJnlLine."Journal Batch Name");
      IntraJnlTemplate.GET(IntrastatJnlLine."Journal Template Name");
      IntraJnlTemplate.TESTFIELD("Checklist Report ID");
      REPORT.SAVEASPDF(IntraJnlTemplate."Checklist Report ID",FileManagement.ServerTempFileName('tmp'),IntrastatJnlLine);
    END;

    [External]
    PROCEDURE PrintResJnlBatch@19(ResJnlBatch@1000 : Record 236);
    BEGIN
      ResJnlBatch.SETRECFILTER;
      ResJnlTemplate.GET(ResJnlBatch."Journal Template Name");
      ResJnlTemplate.TESTFIELD("Test Report ID");
      REPORT.RUN(ResJnlTemplate."Test Report ID",TRUE,FALSE,ResJnlBatch);
    END;

    [External]
    PROCEDURE PrintResJnlLine@20(VAR NewResJnlLine@1000 : Record 207);
    BEGIN
      ResJnlLine.COPY(NewResJnlLine);
      ResJnlLine.SETRANGE("Journal Template Name",ResJnlLine."Journal Template Name");
      ResJnlLine.SETRANGE("Journal Batch Name",ResJnlLine."Journal Batch Name");
      ResJnlTemplate.GET(ResJnlLine."Journal Template Name");
      ResJnlTemplate.TESTFIELD("Test Report ID");
      REPORT.RUN(ResJnlTemplate."Test Report ID",TRUE,FALSE,ResJnlLine);
    END;

    [External]
    PROCEDURE PrintSalesHeader@17(NewSalesHeader@1000 : Record 36);
    VAR
      SalesHeader@1002 : Record 36;
    BEGIN
      SalesHeader := NewSalesHeader;
      SalesHeader.SETRECFILTER;
      CalcSalesDisc(SalesHeader);
      ReportSelection.PrintWithCheck(ReportSelection.Usage::"S.Test",SalesHeader,SalesHeader.FIELDNO("Bill-to Customer No."));
    END;

    [External]
    PROCEDURE PrintSalesHeaderPrepmt@24(NewSalesHeader@1001 : Record 36);
    VAR
      SalesHeader@1000 : Record 36;
    BEGIN
      SalesHeader := NewSalesHeader;
      SalesHeader.SETRECFILTER;
      ReportSelection.PrintWithCheck(ReportSelection.Usage::"S.Test Prepmt.",SalesHeader,SalesHeader.FIELDNO("Bill-to Customer No."));
    END;

    [External]
    PROCEDURE PrintPurchHeader@18(NewPurchHeader@1000 : Record 38);
    VAR
      PurchHeader@1001 : Record 38;
    BEGIN
      PurchHeader := NewPurchHeader;
      PurchHeader.SETRECFILTER;
      CalcPurchDisc(PurchHeader);
      ReportSelection.PrintWithGUIYesNoWithCheckVendor(
        ReportSelection.Usage::"P.Test",PurchHeader,TRUE,PurchHeader.FIELDNO("Buy-from Vendor No."));
    END;

    [External]
    PROCEDURE PrintPurchHeaderPrepmt@26(NewPurchHeader@1000 : Record 38);
    VAR
      PurchHeader@1001 : Record 38;
    BEGIN
      PurchHeader := NewPurchHeader;
      PurchHeader.SETRECFILTER;
      ReportSelection.PrintWithGUIYesNoWithCheckVendor(
        ReportSelection.Usage::"P.Test Prepmt.",PurchHeader,TRUE,PurchHeader.FIELDNO("Buy-from Vendor No."));
    END;

    [External]
    PROCEDURE PrintBankAccRecon@12(NewBankAccRecon@1000 : Record 273);
    VAR
      BankAccRecon@1001 : Record 273;
    BEGIN
      BankAccRecon := NewBankAccRecon;
      BankAccRecon.SETRECFILTER;
      ReportSelection.PrintWithCheck(ReportSelection.Usage::"B.Recon.Test",BankAccRecon,0);
    END;

    [External]
    PROCEDURE PrintFAJnlBatch@14(FAJnlBatch@1000 : Record 5620);
    BEGIN
      FAJnlBatch.SETRECFILTER;
      FAJnlTemplate.GET(FAJnlBatch."Journal Template Name");
      FAJnlTemplate.TESTFIELD("Test Report ID");
      REPORT.RUN(FAJnlTemplate."Test Report ID",TRUE,FALSE,FAJnlBatch);
    END;

    [External]
    PROCEDURE PrintFAJnlLine@13(VAR NewFAJnlLine@1000 : Record 5621);
    BEGIN
      FAJnlLine.COPY(NewFAJnlLine);
      FAJnlLine.SETRANGE("Journal Template Name",FAJnlLine."Journal Template Name");
      FAJnlLine.SETRANGE("Journal Batch Name",FAJnlLine."Journal Batch Name");
      FAJnlTemplate.GET(FAJnlLine."Journal Template Name");
      FAJnlTemplate.TESTFIELD("Test Report ID");
      REPORT.RUN(FAJnlTemplate."Test Report ID",TRUE,FALSE,FAJnlLine);
    END;

    [External]
    PROCEDURE PrintInsuranceJnlBatch@21(InsuranceJnlBatch@1000 : Record 5634);
    BEGIN
      InsuranceJnlBatch.SETRECFILTER;
      InsuranceJnlTempl.GET(InsuranceJnlBatch."Journal Template Name");
      InsuranceJnlTempl.TESTFIELD("Test Report ID");
      REPORT.RUN(InsuranceJnlTempl."Test Report ID",TRUE,FALSE,InsuranceJnlBatch);
    END;

    [External]
    PROCEDURE PrintInsuranceJnlLine@15(VAR NewInsuranceJnlLine@1000 : Record 5635);
    BEGIN
      InsuranceJnlLine.COPY(NewInsuranceJnlLine);
      InsuranceJnlLine.SETRANGE("Journal Template Name",InsuranceJnlLine."Journal Template Name");
      InsuranceJnlLine.SETRANGE("Journal Batch Name",InsuranceJnlLine."Journal Batch Name");
      InsuranceJnlTempl.GET(InsuranceJnlLine."Journal Template Name");
      InsuranceJnlTempl.TESTFIELD("Test Report ID");
      REPORT.RUN(InsuranceJnlTempl."Test Report ID",TRUE,FALSE,InsuranceJnlLine);
    END;

    [External]
    PROCEDURE PrintServiceHeader@22(NewServiceHeader@1000 : Record 5900);
    VAR
      ServiceHeader@1002 : Record 5900;
    BEGIN
      ServiceHeader := NewServiceHeader;
      ServiceHeader.SETRECFILTER;
      CalcServDisc(ServiceHeader);
      ReportSelection.PrintWithCheck(ReportSelection.Usage::"SM.Test",ServiceHeader,ServiceHeader.FIELDNO("Bill-to Customer No."));
    END;

    [External]
    PROCEDURE PrintWhseJnlBatch@7300(WhseJnlBatch@1000 : Record 7310);
    BEGIN
      WhseJnlBatch.SETRECFILTER;
      WhseJnlTemplate.GET(WhseJnlBatch."Journal Template Name");
      WhseJnlTemplate.TESTFIELD("Test Report ID");
      REPORT.RUN(WhseJnlTemplate."Test Report ID",TRUE,FALSE,WhseJnlBatch);
    END;

    [External]
    PROCEDURE PrintWhseJnlLine@7301(VAR NewWhseJnlLine@1000 : Record 7311);
    BEGIN
      WhseJnlLine.COPY(NewWhseJnlLine);
      WhseJnlLine.SETRANGE("Journal Template Name",WhseJnlLine."Journal Template Name");
      WhseJnlLine.SETRANGE("Journal Batch Name",WhseJnlLine."Journal Batch Name");
      WhseJnlTemplate.GET(WhseJnlLine."Journal Template Name");
      WhseJnlTemplate.TESTFIELD("Test Report ID");
      REPORT.RUN(WhseJnlTemplate."Test Report ID",TRUE,FALSE,WhseJnlLine);
    END;

    [External]
    PROCEDURE PrintInvtPeriod@23(NewInvtPeriod@1000 : Record 5814);
    VAR
      InvtPeriod@1001 : Record 5814;
    BEGIN
      InvtPeriod := NewInvtPeriod;
      InvtPeriod.SETRECFILTER;

      ReportSelection.PrintWithCheck(ReportSelection.Usage::"Invt. Period Test",InvtPeriod,0);
    END;

    [External]
    PROCEDURE PrintJobJnlBatch@100(JobJnlBatch@1000 : Record 237);
    BEGIN
      JobJnlBatch.SETRECFILTER;
      JobJnlTemplate.GET(JobJnlBatch."Journal Template Name");
      JobJnlTemplate.TESTFIELD("Test Report ID");
      REPORT.RUN(JobJnlTemplate."Test Report ID",TRUE,FALSE,JobJnlBatch);
    END;

    [External]
    PROCEDURE PrintJobJnlLine@10(VAR NewJobJnlLine@1000 : Record 210);
    BEGIN
      JobJnlLine.COPY(NewJobJnlLine);
      JobJnlLine.SETRANGE("Journal Template Name",JobJnlLine."Journal Template Name");
      JobJnlLine.SETRANGE("Journal Batch Name",JobJnlLine."Journal Batch Name");
      JobJnlTemplate.GET(JobJnlLine."Journal Template Name");
      JobJnlTemplate.TESTFIELD("Test Report ID");
      REPORT.RUN(JobJnlTemplate."Test Report ID",TRUE,FALSE,JobJnlLine);
    END;

    LOCAL PROCEDURE CalcSalesDisc@25(VAR SalesHeader@1000 : Record 36);
    VAR
      SalesLine@1004 : Record 37;
      SalesSetup@1001 : Record 311;
    BEGIN
      SalesSetup.GET;
      IF SalesSetup."Calc. Inv. Discount" THEN BEGIN
        SalesLine.RESET;
        SalesLine.SETRANGE("Document Type",SalesHeader."Document Type");
        SalesLine.SETRANGE("Document No.",SalesHeader."No.");
        SalesLine.FINDFIRST;
        CODEUNIT.RUN(CODEUNIT::"Sales-Calc. Discount",SalesLine);
        SalesHeader.GET(SalesHeader."Document Type",SalesHeader."No.");
        COMMIT;
      END;
    END;

    LOCAL PROCEDURE CalcPurchDisc@28(VAR PurchHeader@1000 : Record 38);
    VAR
      PurchLine@1003 : Record 39;
      PurchSetup@1001 : Record 312;
    BEGIN
      PurchSetup.GET;
      IF PurchSetup."Calc. Inv. Discount" THEN BEGIN
        PurchLine.RESET;
        PurchLine.SETRANGE("Document Type",PurchHeader."Document Type");
        PurchLine.SETRANGE("Document No.",PurchHeader."No.");
        PurchLine.FINDFIRST;
        CODEUNIT.RUN(CODEUNIT::"Purch.-Calc.Discount",PurchLine);
        PurchHeader.GET(PurchHeader."Document Type",PurchHeader."No.");
        COMMIT;
      END;
    END;

    LOCAL PROCEDURE CalcServDisc@31(VAR ServHeader@1000 : Record 5900);
    VAR
      ServLine@1002 : Record 5902;
      SalesSetup@1001 : Record 311;
    BEGIN
      SalesSetup.GET;
      IF SalesSetup."Calc. Inv. Discount" THEN BEGIN
        ServLine.RESET;
        ServLine.SETRANGE("Document Type",ServHeader."Document Type");
        ServLine.SETRANGE("Document No.",ServHeader."No.");
        ServLine.FINDFIRST;
        CODEUNIT.RUN(CODEUNIT::"Service-Calc. Discount",ServLine);
        ServHeader.GET(ServHeader."Document Type",ServHeader."No.");
        COMMIT;
      END;
    END;

    BEGIN
    END.
  }
}

