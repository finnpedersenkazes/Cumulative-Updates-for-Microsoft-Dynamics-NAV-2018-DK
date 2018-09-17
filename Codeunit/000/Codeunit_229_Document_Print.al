OBJECT Codeunit 229 Document-Print
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
      Text001@1001 : TextConst 'DAN=%1 mangler for %2 %3.;ENU=%1 is missing for %2 %3.';
      Text002@1002 : TextConst 'DAN=%1 for %2 mangler i %3.;ENU=%1 for %2 is missing in %3.';
      SalesSetup@1003 : Record 311;
      PurchSetup@1004 : Record 312;

    [Internal]
    PROCEDURE EmailSalesHeader@12(SalesHeader@1000 : Record 36);
    BEGIN
      DoPrintSalesHeader(SalesHeader,TRUE);
    END;

    [Internal]
    PROCEDURE PrintSalesHeader@1(SalesHeader@1000 : Record 36);
    BEGIN
      DoPrintSalesHeader(SalesHeader,FALSE);
    END;

    LOCAL PROCEDURE DoPrintSalesHeader@14(SalesHeader@1000 : Record 36;SendAsEmail@1002 : Boolean);
    VAR
      ReportSelections@1001 : Record 77;
    BEGIN
      SalesHeader.SETRANGE("No.",SalesHeader."No.");
      CalcSalesDisc(SalesHeader);
      IF SendAsEmail THEN
        ReportSelections.SendEmailToCust(
          GetSalesDocTypeUsage(SalesHeader),SalesHeader,SalesHeader."No.",SalesHeader.GetDocTypeTxt,TRUE,SalesHeader.GetBillToNo)
      ELSE
        ReportSelections.Print(GetSalesDocTypeUsage(SalesHeader),SalesHeader,SalesHeader.FIELDNO("Bill-to Customer No."));
    END;

    [External]
    PROCEDURE PrintPurchHeader@5(PurchHeader@1000 : Record 38);
    VAR
      ReportSelections@1001 : Record 77;
    BEGIN
      PurchHeader.SETRANGE("No.",PurchHeader."No.");
      CalcPurchDisc(PurchHeader);

      ReportSelections.PrintWithGUIYesNoVendor(
        GetPurchDocTypeUsage(PurchHeader),PurchHeader,TRUE,PurchHeader.FIELDNO("Buy-from Vendor No."));
    END;

    [External]
    PROCEDURE PrintBankAccStmt@10(BankAccStmt@1000 : Record 275);
    VAR
      ReportSelections@1001 : Record 77;
    BEGIN
      BankAccStmt.SETRECFILTER;

      ReportSelections.Print(ReportSelections.Usage::"B.Stmt",BankAccStmt,0);
    END;

    [External]
    PROCEDURE PrintCheck@11(VAR NewGenJnlLine@1000 : Record 81);
    VAR
      GenJnlLine@1001 : Record 81;
      ReportSelections@1002 : Record 77;
    BEGIN
      GenJnlLine.COPY(NewGenJnlLine);
      GenJnlLine.OnCheckGenJournalLinePrintCheckRestrictions;

      ReportSelections.Print(ReportSelections.Usage::"B.Check",GenJnlLine,0);
    END;

    [External]
    PROCEDURE PrintTransferHeader@2(TransHeader@1000 : Record 5740);
    VAR
      ReportSelections@1001 : Record 77;
    BEGIN
      TransHeader.SETRANGE("No.",TransHeader."No.");

      ReportSelections.Print(ReportSelections.Usage::Inv1,TransHeader,0);
    END;

    [External]
    PROCEDURE PrintServiceContract@3(ServiceContract@1000 : Record 5965);
    VAR
      ReportSelection@1001 : Record 77;
    BEGIN
      ServiceContract.SETRANGE("Contract No.",ServiceContract."Contract No.");

      ReportSelection.FilterPrintUsage(GetServContractTypeUsage(ServiceContract));
      IF ReportSelection.ISEMPTY THEN
        ERROR(Text001,ReportSelection.TABLECAPTION,FORMAT(ServiceContract."Contract Type"),ServiceContract."Contract No.");

      ReportSelection.Print(
        GetServContractTypeUsage(ServiceContract),ServiceContract,ServiceContract.FIELDNO("Bill-to Customer No."));
    END;

    [External]
    PROCEDURE PrintServiceHeader@4(ServiceHeader@1000 : Record 5900);
    VAR
      ReportSelection@1001 : Record 77;
    BEGIN
      ServiceHeader.SETRANGE("No.",ServiceHeader."No.");
      CalcServDisc(ServiceHeader);

      ReportSelection.FilterPrintUsage(GetServHeaderDocTypeUsage(ServiceHeader));
      IF ReportSelection.ISEMPTY THEN
        ERROR(Text002,ReportSelection.FIELDCAPTION("Report ID"),ServiceHeader.TABLECAPTION,ReportSelection.TABLECAPTION);

      ReportSelection.Print(GetServHeaderDocTypeUsage(ServiceHeader),ServiceHeader,ServiceHeader.FIELDNO("Customer No."));
    END;

    [External]
    PROCEDURE PrintAsmHeader@9(AsmHeader@1000 : Record 900);
    VAR
      ReportSelections@1001 : Record 77;
    BEGIN
      AsmHeader.SETRANGE("No.",AsmHeader."No.");

      ReportSelections.Print(GetAsmHeaderDocTypeUsage(AsmHeader),AsmHeader,0);
    END;

    [External]
    PROCEDURE PrintSalesOrder@6(SalesHeader@1000 : Record 36;Usage@1001 : 'Order Confirmation,Work Order,Pick Instruction');
    VAR
      ReportSelection@1002 : Record 77;
    BEGIN
      IF SalesHeader."Document Type" <> SalesHeader."Document Type"::Order THEN
        EXIT;

      SalesHeader.SETRANGE("No.",SalesHeader."No.");
      CalcSalesDisc(SalesHeader);

      ReportSelection.PrintWithGUIYesNo(GetSalesOrderUsage(Usage),SalesHeader,GUIALLOWED,SalesHeader.FIELDNO("Bill-to Customer No."));
    END;

    [External]
    PROCEDURE PrintSalesHeaderArch@7(SalesHeaderArch@1000 : Record 5107);
    VAR
      ReportSelection@1001 : Record 77;
    BEGIN
      SalesHeaderArch.SETRECFILTER;

      ReportSelection.Print(GetSalesArchDocTypeUsage(SalesHeaderArch),SalesHeaderArch,SalesHeaderArch.FIELDNO("Bill-to Customer No."));
    END;

    [External]
    PROCEDURE PrintPurchHeaderArch@8(PurchHeaderArch@1000 : Record 5109);
    VAR
      ReportSelection@1001 : Record 77;
    BEGIN
      PurchHeaderArch.SETRECFILTER;

      ReportSelection.PrintWithGUIYesNoVendor(
        GetPurchArchDocTypeUsage(PurchHeaderArch),PurchHeaderArch,TRUE,PurchHeaderArch.FIELDNO("Buy-from Vendor No."));
    END;

    [External]
    PROCEDURE PrintProformaSalesInvoice@15(SalesHeader@1000 : Record 36);
    VAR
      ReportSelections@1001 : Record 77;
    BEGIN
      SalesHeader.SETRECFILTER;
      ReportSelections.Print(ReportSelections.Usage::"Pro Forma S. Invoice",SalesHeader,SalesHeader.FIELDNO("Bill-to Customer No."));
    END;

    LOCAL PROCEDURE GetSalesDocTypeUsage@23(SalesHeader@1000 : Record 36) : Integer;
    VAR
      ReportSelections@1001 : Record 77;
    BEGIN
      CASE SalesHeader."Document Type" OF
        SalesHeader."Document Type"::Quote:
          EXIT(ReportSelections.Usage::"S.Quote");
        SalesHeader."Document Type"::"Blanket Order":
          EXIT(ReportSelections.Usage::"S.Blanket");
        SalesHeader."Document Type"::Order:
          EXIT(ReportSelections.Usage::"S.Order");
        SalesHeader."Document Type"::"Return Order":
          EXIT(ReportSelections.Usage::"S.Return");
        SalesHeader."Document Type"::Invoice:
          EXIT(ReportSelections.Usage::"S.Invoice Draft");
        SalesHeader."Document Type"::"Credit Memo":
          EXIT(ReportSelections.Usage::"S.Cr.Memo");
        ELSE
          ERROR('');
      END;
    END;

    LOCAL PROCEDURE GetPurchDocTypeUsage@13(PurchHeader@1000 : Record 38) : Integer;
    VAR
      ReportSelections@1001 : Record 77;
    BEGIN
      CASE PurchHeader."Document Type" OF
        PurchHeader."Document Type"::Quote:
          EXIT(ReportSelections.Usage::"P.Quote");
        PurchHeader."Document Type"::"Blanket Order":
          EXIT(ReportSelections.Usage::"P.Blanket");
        PurchHeader."Document Type"::Order:
          EXIT(ReportSelections.Usage::"P.Order");
        PurchHeader."Document Type"::"Return Order":
          EXIT(ReportSelections.Usage::"P.Return");
        ELSE
          ERROR('');
      END;
    END;

    LOCAL PROCEDURE GetServContractTypeUsage@21(ServiceContractHeader@1000 : Record 5965) : Integer;
    VAR
      ReportSelections@1001 : Record 77;
    BEGIN
      CASE ServiceContractHeader."Contract Type" OF
        ServiceContractHeader."Contract Type"::Quote:
          EXIT(ReportSelections.Usage::"SM.Contract Quote");
        ServiceContractHeader."Contract Type"::Contract:
          EXIT(ReportSelections.Usage::"SM.Contract");
        ELSE
          ERROR('');
      END;
    END;

    LOCAL PROCEDURE GetServHeaderDocTypeUsage@22(ServiceHeader@1000 : Record 5900) : Integer;
    VAR
      ReportSelections@1001 : Record 77;
    BEGIN
      CASE ServiceHeader."Document Type" OF
        ServiceHeader."Document Type"::Quote:
          EXIT(ReportSelections.Usage::"SM.Quote");
        ServiceHeader."Document Type"::Order:
          EXIT(ReportSelections.Usage::"SM.Order");
        ServiceHeader."Document Type"::Invoice:
          EXIT(ReportSelections.Usage::"SM.Invoice");
        ServiceHeader."Document Type"::"Credit Memo":
          EXIT(ReportSelections.Usage::"SM.Credit Memo");
        ELSE
          ERROR('');
      END;
    END;

    LOCAL PROCEDURE GetAsmHeaderDocTypeUsage@18(AsmHeader@1000 : Record 900) : Integer;
    VAR
      ReportSelections@1001 : Record 77;
    BEGIN
      CASE AsmHeader."Document Type" OF
        AsmHeader."Document Type"::Quote,
        AsmHeader."Document Type"::"Blanket Order",
        AsmHeader."Document Type"::Order:
          EXIT(ReportSelections.Usage::"Asm. Order");
        ELSE
          ERROR('');
      END;
    END;

    LOCAL PROCEDURE GetSalesOrderUsage@24(Usage@1001 : 'Order Confirmation,Work Order,Pick Instruction') : Integer;
    VAR
      ReportSelections@1000 : Record 77;
    BEGIN
      CASE Usage OF
        Usage::"Order Confirmation":
          EXIT(ReportSelections.Usage::"S.Order");
        Usage::"Work Order":
          EXIT(ReportSelections.Usage::"S.Work Order");
        Usage::"Pick Instruction":
          EXIT(ReportSelections.Usage::"S.Order Pick Instruction");
        ELSE
          ERROR('');
      END;
    END;

    LOCAL PROCEDURE GetSalesArchDocTypeUsage@29(SalesHeaderArchive@1000 : Record 5107) : Integer;
    VAR
      ReportSelections@1001 : Record 77;
    BEGIN
      CASE SalesHeaderArchive."Document Type" OF
        SalesHeaderArchive."Document Type"::Quote:
          EXIT(ReportSelections.Usage::"S.Arch. Quote");
        SalesHeaderArchive."Document Type"::Order:
          EXIT(ReportSelections.Usage::"S.Arch. Order");
        SalesHeaderArchive."Document Type"::"Return Order":
          EXIT(ReportSelections.Usage::"S. Arch. Return Order");
        ELSE
          ERROR('');
      END
    END;

    LOCAL PROCEDURE GetPurchArchDocTypeUsage@35(PurchHeaderArchive@1000 : Record 5109) : Integer;
    VAR
      ReportSelections@1001 : Record 77;
    BEGIN
      CASE PurchHeaderArchive."Document Type" OF
        PurchHeaderArchive."Document Type"::Quote:
          EXIT(ReportSelections.Usage::"P.Arch. Quote");
        PurchHeaderArchive."Document Type"::Order:
          EXIT(ReportSelections.Usage::"P.Arch. Order");
        PurchHeaderArchive."Document Type"::"Return Order":
          EXIT(ReportSelections.Usage::"P. Arch. Return Order");
        ELSE
          ERROR('');
      END;
    END;

    LOCAL PROCEDURE CalcSalesDisc@25(VAR SalesHeader@1000 : Record 36);
    VAR
      SalesLine@1004 : Record 37;
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

