OBJECT Codeunit 57 Document Totals
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      TotalVATLbl@1002 : TextConst 'DAN=Moms i alt;ENU=Total VAT';
      TotalAmountInclVatLbl@1001 : TextConst 'DAN=I alt inkl. moms;ENU=Total Incl. VAT';
      TotalAmountExclVATLbl@1000 : TextConst 'DAN=I alt ekskl. moms;ENU=Total Excl. VAT';
      InvoiceDiscountAmountLbl@1004 : TextConst 'DAN=Fakturarabatbel›b;ENU=Invoice Discount Amount';
      RefreshMsgTxt@1005 : TextConst 'DAN=Totaler eller rabatter er muligvis ikke opdaterede. V‘lg linket for at opdatere.;ENU=Totals or discounts may not be up-to-date. Choose the link to update.';
      PreviousTotalSalesHeader@1006 : Record 36;
      PreviousTotalPurchaseHeader@1007 : Record 38;
      ForceTotalsRecalculation@1008 : Boolean;
      PreviousTotalSalesVATDifference@1009 : Decimal;
      PreviousTotalPurchVATDifference@1010 : Decimal;
      TotalLineAmountLbl@1011 : TextConst 'DAN=Subtotal;ENU=Subtotal';

    [External]
    PROCEDURE CalculateSalesPageTotals@51(VAR TotalSalesLine@1000 : Record 37;VAR VATAmount@1001 : Decimal;VAR SalesLine@1002 : Record 37);
    VAR
      SalesHeader@1003 : Record 36;
    BEGIN
      IF SalesHeader.GET(SalesLine."Document Type",SalesLine."Document No.") THEN
        CalculateTotalSalesLineAndVATAmount(SalesHeader,VATAmount,TotalSalesLine);
    END;

    [External]
    PROCEDURE CalculateSalesTotals@11(VAR TotalSalesLine@1000 : Record 37;VAR VATAmount@1001 : Decimal;VAR SalesLine@1002 : Record 37);
    BEGIN
      CalculateSalesPageTotals(TotalSalesLine,VATAmount,SalesLine);
    END;

    [External]
    PROCEDURE CalculatePostedSalesInvoiceTotals@1(VAR SalesInvoiceHeader@1000 : Record 112;VAR VATAmount@1001 : Decimal;SalesInvoiceLine@1002 : Record 113);
    BEGIN
      IF SalesInvoiceHeader.GET(SalesInvoiceLine."Document No.") THEN BEGIN
        SalesInvoiceHeader.CALCFIELDS(Amount,"Amount Including VAT","Invoice Discount Amount");
        VATAmount := SalesInvoiceHeader."Amount Including VAT" - SalesInvoiceHeader.Amount;
      END;
    END;

    [External]
    PROCEDURE CalculatePostedSalesCreditMemoTotals@2(VAR SalesCrMemoHeader@1000 : Record 114;VAR VATAmount@1001 : Decimal;SalesCrMemoLine@1002 : Record 115);
    BEGIN
      IF SalesCrMemoHeader.GET(SalesCrMemoLine."Document No.") THEN BEGIN
        SalesCrMemoHeader.CALCFIELDS(Amount,"Amount Including VAT","Invoice Discount Amount");
        VATAmount := SalesCrMemoHeader."Amount Including VAT" - SalesCrMemoHeader.Amount;
      END;
    END;

    [External]
    PROCEDURE CalcTotalPurchAmountOnlyDiscountAllowed@33(PurchLine@1000 : Record 39) : Decimal;
    VAR
      TotalPurchLine@1001 : Record 39;
    BEGIN
      WITH TotalPurchLine DO BEGIN
        SETRANGE("Document Type",PurchLine."Document Type");
        SETRANGE("Document No.",PurchLine."Document No.");
        SETRANGE("Allow Invoice Disc.",TRUE);
        CALCSUMS("Line Amount");
        EXIT("Line Amount");
      END;
    END;

    [External]
    PROCEDURE CalcTotalSalesAmountOnlyDiscountAllowed@30(SalesLine@1000 : Record 37) : Decimal;
    VAR
      TotalSalesLine@1001 : Record 37;
    BEGIN
      WITH TotalSalesLine DO BEGIN
        SETRANGE("Document Type",SalesLine."Document Type");
        SETRANGE("Document No.",SalesLine."Document No.");
        SETRANGE("Allow Invoice Disc.",TRUE);
        CALCSUMS("Line Amount");
        EXIT("Line Amount");
      END;
    END;

    LOCAL PROCEDURE CalcTotalPurchVATDifference@21(PurchHeader@1000 : Record 38) : Decimal;
    VAR
      PurchLine@1001 : Record 39;
    BEGIN
      WITH PurchLine DO BEGIN
        SETRANGE("Document Type",PurchHeader."Document Type");
        SETRANGE("Document No.",PurchHeader."No.");
        CALCSUMS("VAT Difference");
        EXIT("VAT Difference");
      END;
    END;

    LOCAL PROCEDURE CalcTotalSalesVATDifference@3(SalesHeader@1000 : Record 36) : Decimal;
    VAR
      SalesLine@1001 : Record 37;
    BEGIN
      WITH SalesLine DO BEGIN
        SETRANGE("Document Type",SalesHeader."Document Type");
        SETRANGE("Document No.",SalesHeader."No.");
        CALCSUMS("VAT Difference");
        EXIT("VAT Difference");
      END;
    END;

    LOCAL PROCEDURE CalculateTotalSalesLineAndVATAmount@36(SalesHeader@1001 : Record 36;VAR VATAmount@1000 : Decimal;VAR TempTotalSalesLine@1007 : TEMPORARY Record 37);
    VAR
      TempSalesLine@1009 : TEMPORARY Record 37;
      TempTotalSalesLineLCY@1008 : TEMPORARY Record 37;
      SalesPost@1006 : Codeunit 80;
      VATAmountText@1005 : Text[30];
      ProfitLCY@1004 : Decimal;
      ProfitPct@1003 : Decimal;
      TotalAdjCostLCY@1002 : Decimal;
    BEGIN
      SalesPost.GetSalesLines(SalesHeader,TempSalesLine,0);
      CLEAR(SalesPost);
      SalesPost.SumSalesLinesTemp(
        SalesHeader,TempSalesLine,0,TempTotalSalesLine,TempTotalSalesLineLCY,
        VATAmount,VATAmountText,ProfitLCY,ProfitPct,TotalAdjCostLCY);
    END;

    LOCAL PROCEDURE CalculateTotalPurchaseLineAndVATAmount@34(PurchaseHeader@1000 : Record 38;VAR VATAmount@1003 : Decimal;VAR TempTotalPurchaseLine@1006 : TEMPORARY Record 39);
    VAR
      TempTotalPurchaseLineLCY@1004 : TEMPORARY Record 39;
      TempPurchaseLine@1005 : TEMPORARY Record 39;
      PurchPost@1002 : Codeunit 90;
      VATAmountText@1001 : Text[30];
    BEGIN
      PurchPost.GetPurchLines(PurchaseHeader,TempPurchaseLine,0);
      CLEAR(PurchPost);

      PurchPost.SumPurchLinesTemp(
        PurchaseHeader,TempPurchaseLine,0,TempTotalPurchaseLine,TempTotalPurchaseLineLCY,VATAmount,VATAmountText);
    END;

    [External]
    PROCEDURE SalesUpdateTotalsControls@12(CurrentSalesLine@1007 : Record 37;VAR TotalSalesHeader@1009 : Record 36;VAR TotalsSalesLine@1003 : Record 37;VAR RefreshMessageEnabled@1000 : Boolean;VAR ControlStyle@1001 : Text;VAR RefreshMessageText@1002 : Text;VAR InvDiscAmountEditable@1005 : Boolean;CurrPageEditable@1004 : Boolean;VAR VATAmount@1008 : Decimal);
    VAR
      SalesLine@1010 : Record 37;
      SalesCalcDiscountByType@1006 : Codeunit 56;
    BEGIN
      IF CurrentSalesLine."Document No." = '' THEN
        EXIT;

      TotalSalesHeader.GET(CurrentSalesLine."Document Type",CurrentSalesLine."Document No.");
      RefreshMessageEnabled := SalesCalcDiscountByType.ShouldRedistributeInvoiceDiscountAmount(TotalSalesHeader);

      IF NOT RefreshMessageEnabled THEN
        RefreshMessageEnabled := NOT SalesUpdateTotals(TotalSalesHeader,CurrentSalesLine,TotalsSalesLine,VATAmount);

      SalesLine.SETRANGE("Document Type",CurrentSalesLine."Document Type");
      SalesLine.SETRANGE("Document No.",CurrentSalesLine."Document No.");
      InvDiscAmountEditable := SalesLine.FINDFIRST AND
        SalesCalcDiscountByType.InvoiceDiscIsAllowed(TotalSalesHeader."Invoice Disc. Code") AND
        (NOT RefreshMessageEnabled) AND CurrPageEditable;

      TotalControlsUpdateStyle(RefreshMessageEnabled,ControlStyle,RefreshMessageText);

      IF RefreshMessageEnabled THEN
        ClearSalesAmounts(TotalsSalesLine,VATAmount);
    END;

    LOCAL PROCEDURE SalesUpdateTotals@31(VAR SalesHeader@1000 : Record 36;CurrentSalesLine@1005 : Record 37;VAR TotalsSalesLine@1004 : Record 37;VAR VATAmount@1006 : Decimal) : Boolean;
    BEGIN
      SalesHeader.CALCFIELDS(Amount,"Amount Including VAT","Invoice Discount Amount");

      IF SalesHeader."No." <> PreviousTotalSalesHeader."No." THEN
        ForceTotalsRecalculation := TRUE;

      IF (NOT ForceTotalsRecalculation) AND
         (PreviousTotalSalesHeader.Amount = SalesHeader.Amount) AND
         (PreviousTotalSalesHeader."Amount Including VAT" = SalesHeader."Amount Including VAT") AND
         (PreviousTotalSalesVATDifference = CalcTotalSalesVATDifference(SalesHeader))
      THEN
        EXIT(TRUE);

      ForceTotalsRecalculation := FALSE;

      IF NOT SalesCheckNumberOfLinesLimit(SalesHeader) THEN
        EXIT(FALSE);

      SalesCalculateTotalsWithInvoiceRounding(CurrentSalesLine,VATAmount,TotalsSalesLine);
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE SalesCalculateTotalsWithInvoiceRounding@16(VAR TempCurrentSalesLine@1000 : TEMPORARY Record 37;VAR VATAmount@1001 : Decimal;VAR TempTotalSalesLine@1002 : TEMPORARY Record 37);
    VAR
      SalesHeader@1010 : Record 36;
    BEGIN
      CLEAR(TempTotalSalesLine);
      IF SalesHeader.GET(TempCurrentSalesLine."Document Type",TempCurrentSalesLine."Document No.") THEN BEGIN
        CalculateTotalSalesLineAndVATAmount(SalesHeader,VATAmount,TempTotalSalesLine);

        IF PreviousTotalSalesHeader."No." <> TempCurrentSalesLine."Document No." THEN BEGIN
          PreviousTotalSalesHeader.GET(TempCurrentSalesLine."Document Type",TempCurrentSalesLine."Document No.");
          ForceTotalsRecalculation := TRUE;
        END;
        PreviousTotalSalesHeader.CALCFIELDS(Amount,"Amount Including VAT");
        PreviousTotalSalesVATDifference := CalcTotalSalesVATDifference(PreviousTotalSalesHeader);
      END;
    END;

    [External]
    PROCEDURE SalesRedistributeInvoiceDiscountAmounts@4(VAR TempSalesLine@1003 : TEMPORARY Record 37;VAR VATAmount@1002 : Decimal;VAR TempTotalSalesLine@1001 : TEMPORARY Record 37);
    VAR
      SalesHeader@1000 : Record 36;
    BEGIN
      WITH SalesHeader DO
        IF GET(TempSalesLine."Document Type",TempSalesLine."Document No.") THEN BEGIN
          TESTFIELD(Status,Status::Open);
          CALCFIELDS("Recalculate Invoice Disc.");
          IF "Recalculate Invoice Disc." THEN
            CODEUNIT.RUN(CODEUNIT::"Sales - Calc Discount By Type",TempSalesLine);

          SalesCalculateTotalsWithInvoiceRounding(TempSalesLine,VATAmount,TempTotalSalesLine);
        END;
    END;

    [Internal]
    PROCEDURE PurchaseUpdateTotalsControls@25(CurrentPurchaseLine@1007 : Record 39;VAR TotalPurchaseHeader@1009 : Record 38;VAR TotalsPurchaseLine@1003 : Record 39;VAR RefreshMessageEnabled@1000 : Boolean;VAR ControlStyle@1001 : Text;VAR RefreshMessageText@1002 : Text;VAR InvDiscAmountEditable@1005 : Boolean;VAR VATAmount@1008 : Decimal);
    VAR
      PurchCalcDiscByType@1006 : Codeunit 66;
    BEGIN
      ClearPurchaseAmounts(TotalsPurchaseLine,VATAmount);

      IF CurrentPurchaseLine."Document No." = '' THEN
        EXIT;

      TotalPurchaseHeader.GET(CurrentPurchaseLine."Document Type",CurrentPurchaseLine."Document No.");
      RefreshMessageEnabled := PurchCalcDiscByType.ShouldRedistributeInvoiceDiscountAmount(TotalPurchaseHeader);

      IF NOT RefreshMessageEnabled THEN
        RefreshMessageEnabled := NOT PurchaseUpdateTotals(TotalPurchaseHeader,CurrentPurchaseLine,TotalsPurchaseLine,VATAmount);

      InvDiscAmountEditable := PurchCalcDiscByType.InvoiceDiscIsAllowed(TotalPurchaseHeader."Invoice Disc. Code") AND
        (NOT RefreshMessageEnabled);
      TotalControlsUpdateStyle(RefreshMessageEnabled,ControlStyle,RefreshMessageText);

      IF RefreshMessageEnabled THEN
        ClearPurchaseAmounts(TotalsPurchaseLine,VATAmount);
    END;

    LOCAL PROCEDURE PurchaseUpdateTotals@24(VAR PurchaseHeader@1000 : Record 38;CurrentPurchaseLine@1005 : Record 39;VAR TotalsPurchaseLine@1004 : Record 39;VAR VATAmount@1006 : Decimal) : Boolean;
    BEGIN
      PurchaseHeader.CALCFIELDS(Amount,"Amount Including VAT","Invoice Discount Amount");

      IF (PreviousTotalPurchaseHeader.Amount = PurchaseHeader.Amount) AND
         (PreviousTotalPurchaseHeader."Amount Including VAT" = PurchaseHeader."Amount Including VAT") AND
         (PreviousTotalPurchVATDifference = CalcTotalPurchVATDifference(PurchaseHeader))
      THEN
        EXIT(TRUE);

      IF NOT PurchaseCheckNumberOfLinesLimit(PurchaseHeader) THEN
        EXIT(FALSE);

      PurchaseCalculateTotalsWithInvoiceRounding(CurrentPurchaseLine,VATAmount,TotalsPurchaseLine);
      EXIT(TRUE);
    END;

    [Internal]
    PROCEDURE PurchaseCalculateTotalsWithInvoiceRounding@23(VAR TempCurrentPurchaseLine@1000 : TEMPORARY Record 39;VAR VATAmount@1001 : Decimal;VAR TempTotalPurchaseLine@1002 : TEMPORARY Record 39);
    VAR
      PurchaseHeader@1010 : Record 38;
    BEGIN
      CLEAR(TempTotalPurchaseLine);

      IF PurchaseHeader.GET(TempCurrentPurchaseLine."Document Type",TempCurrentPurchaseLine."Document No.") THEN BEGIN
        CalculateTotalPurchaseLineAndVATAmount(PurchaseHeader,VATAmount,TempTotalPurchaseLine);

        IF PreviousTotalPurchaseHeader."No." <> TempCurrentPurchaseLine."Document No." THEN
          PreviousTotalPurchaseHeader.GET(TempCurrentPurchaseLine."Document Type",TempCurrentPurchaseLine."Document No.");
        PreviousTotalPurchaseHeader.CALCFIELDS(Amount,"Amount Including VAT");
        PreviousTotalPurchVATDifference := CalcTotalPurchVATDifference(PreviousTotalPurchaseHeader);

        // calculate correct amount including vat if the VAT Calc type is Sales Tax
        IF TempCurrentPurchaseLine."VAT Calculation Type" = TempCurrentPurchaseLine."VAT Calculation Type"::"Sales Tax" THEN
          CalculateSalesTaxForTempTotalPurchaseLine(PurchaseHeader,TempCurrentPurchaseLine,TempTotalPurchaseLine);
      END;
    END;

    [Internal]
    PROCEDURE PurchaseRedistributeInvoiceDiscountAmounts@22(VAR TempPurchaseLine@1003 : TEMPORARY Record 39;VAR VATAmount@1002 : Decimal;VAR TempTotalPurchaseLine@1001 : TEMPORARY Record 39);
    VAR
      PurchaseHeader@1000 : Record 38;
    BEGIN
      WITH PurchaseHeader DO
        IF GET(TempPurchaseLine."Document Type",TempPurchaseLine."Document No.") THEN BEGIN
          CALCFIELDS("Recalculate Invoice Disc.");
          IF "Recalculate Invoice Disc." THEN
            CODEUNIT.RUN(CODEUNIT::"Purch - Calc Disc. By Type",TempPurchaseLine);

          PurchaseCalculateTotalsWithInvoiceRounding(TempPurchaseLine,VATAmount,TempTotalPurchaseLine);
        END;
    END;

    [External]
    PROCEDURE CalculatePurchasePageTotals@52(VAR TotalPurchaseLine@1000 : Record 39;VAR VATAmount@1001 : Decimal;VAR PurchaseLine@1002 : Record 39);
    VAR
      PurchaseHeader@1003 : Record 38;
    BEGIN
      IF PurchaseHeader.GET(PurchaseLine."Document Type",PurchaseLine."Document No.") THEN
        CalculateTotalPurchaseLineAndVATAmount(PurchaseHeader,VATAmount,TotalPurchaseLine);
    END;

    [External]
    PROCEDURE CalculatePurchaseTotals@27(VAR TotalPurchaseLine@1000 : Record 39;VAR VATAmount@1001 : Decimal;VAR PurchaseLine@1002 : Record 39);
    BEGIN
      CalculatePurchasePageTotals(TotalPurchaseLine,VATAmount,PurchaseLine);
    END;

    [External]
    PROCEDURE CalculatePostedPurchInvoiceTotals@5(VAR PurchInvHeader@1000 : Record 122;VAR VATAmount@1001 : Decimal;PurchInvLine@1002 : Record 123);
    BEGIN
      IF PurchInvHeader.GET(PurchInvLine."Document No.") THEN BEGIN
        PurchInvHeader.CALCFIELDS(Amount,"Amount Including VAT","Invoice Discount Amount");
        VATAmount := PurchInvHeader."Amount Including VAT" - PurchInvHeader.Amount;
      END;
    END;

    [External]
    PROCEDURE CalculatePostedPurchCreditMemoTotals@7(VAR PurchCrMemoHdr@1000 : Record 124;VAR VATAmount@1001 : Decimal;PurchCrMemoLine@1002 : Record 125);
    BEGIN
      IF PurchCrMemoHdr.GET(PurchCrMemoLine."Document No.") THEN BEGIN
        PurchCrMemoHdr.CALCFIELDS(Amount,"Amount Including VAT","Invoice Discount Amount");
        VATAmount := PurchCrMemoHdr."Amount Including VAT" - PurchCrMemoHdr.Amount;
      END;
    END;

    LOCAL PROCEDURE ClearSalesAmounts@19(VAR TotalsSalesLine@1000 : Record 37;VAR VATAmount@1001 : Decimal);
    BEGIN
      TotalsSalesLine.Amount := 0;
      TotalsSalesLine."Amount Including VAT" := 0;
      VATAmount := 0;
      CLEAR(PreviousTotalSalesHeader);
    END;

    LOCAL PROCEDURE ClearPurchaseAmounts@29(VAR TotalsPurchaseLine@1000 : Record 39;VAR VATAmount@1001 : Decimal);
    BEGIN
      TotalsPurchaseLine.Amount := 0;
      TotalsPurchaseLine."Amount Including VAT" := 0;
      VATAmount := 0;
      CLEAR(PreviousTotalPurchaseHeader);
    END;

    LOCAL PROCEDURE TotalControlsUpdateStyle@20(RefreshMessageEnabled@1000 : Boolean;VAR ControlStyle@1001 : Text;VAR RefreshMessageText@1002 : Text);
    BEGIN
      IF RefreshMessageEnabled THEN BEGIN
        ControlStyle := 'Subordinate';
        RefreshMessageText := RefreshMsgTxt;
      END ELSE BEGIN
        ControlStyle := 'Strong';
        RefreshMessageText := '';
      END;
    END;

    [External]
    PROCEDURE GetTotalVATCaption@10(CurrencyCode@1000 : Code[10]) : Text;
    BEGIN
      EXIT(GetCaptionClassWithCurrencyCode(TotalVATLbl,CurrencyCode));
    END;

    [External]
    PROCEDURE GetTotalInclVATCaption@13(CurrencyCode@1000 : Code[10]) : Text;
    BEGIN
      EXIT(GetCaptionClassWithCurrencyCode(TotalAmountInclVatLbl,CurrencyCode));
    END;

    [External]
    PROCEDURE GetTotalExclVATCaption@14(CurrencyCode@1000 : Code[10]) : Text;
    BEGIN
      EXIT(GetCaptionClassWithCurrencyCode(TotalAmountExclVATLbl,CurrencyCode));
    END;

    LOCAL PROCEDURE GetCaptionClassWithCurrencyCode@15(CaptionWithoutCurrencyCode@1001 : Text;CurrencyCode@1002 : Code[10]) : Text;
    BEGIN
      EXIT('3,' + GetCaptionWithCurrencyCode(CaptionWithoutCurrencyCode,CurrencyCode));
    END;

    LOCAL PROCEDURE GetCaptionWithCurrencyCode@28(CaptionWithoutCurrencyCode@1001 : Text;CurrencyCode@1002 : Code[10]) : Text;
    VAR
      GLSetup@1000 : Record 98;
    BEGIN
      IF CurrencyCode = '' THEN BEGIN
        GLSetup.GET;
        CurrencyCode := GLSetup.GetCurrencyCode(CurrencyCode);
      END;

      IF CurrencyCode <> '' THEN
        EXIT(CaptionWithoutCurrencyCode + STRSUBSTNO(' (%1)',CurrencyCode));

      EXIT(CaptionWithoutCurrencyCode);
    END;

    LOCAL PROCEDURE GetCaptionWithVATInfo@6(CaptionWithoutVATInfo@1001 : Text;IncludesVAT@1000 : Boolean) : Text;
    BEGIN
      IF IncludesVAT THEN
        EXIT('2,1,' + CaptionWithoutVATInfo);

      EXIT('2,0,' + CaptionWithoutVATInfo);
    END;

    [External]
    PROCEDURE GetInvoiceDiscAmountWithVATCaption@8(IncludesVAT@1000 : Boolean) : Text;
    BEGIN
      EXIT(GetCaptionWithVATInfo(InvoiceDiscountAmountLbl,IncludesVAT));
    END;

    [External]
    PROCEDURE GetInvoiceDiscAmountWithVATAndCurrencyCaption@18(InvDiscAmountCaptionClassWithVAT@1000 : Text;CurrencyCode@1001 : Code[10]) : Text;
    BEGIN
      EXIT(GetCaptionWithCurrencyCode(InvDiscAmountCaptionClassWithVAT,CurrencyCode));
    END;

    [External]
    PROCEDURE GetTotalLineAmountWithVATAndCurrencyCaption@32(CurrencyCode@1001 : Code[10];IncludesVAT@1000 : Boolean) : Text;
    BEGIN
      EXIT(GetCaptionWithCurrencyCode(CAPTIONCLASSTRANSLATE(GetCaptionWithVATInfo(TotalLineAmountLbl,IncludesVAT)),CurrencyCode));
    END;

    [External]
    PROCEDURE SalesCheckNumberOfLinesLimit@17(SalesHeader@1001 : Record 36) : Boolean;
    VAR
      SalesLine@1000 : Record 37;
    BEGIN
      SalesLine.SETRANGE("Document No.",SalesHeader."No.");
      SalesLine.SETRANGE("Document Type",SalesHeader."Document Type");
      SalesLine.SETFILTER(Type,'<>%1',SalesLine.Type::" ");
      SalesLine.SETFILTER("No.",'<>%1','');

      EXIT(SalesLine.COUNT <= 100);
    END;

    [External]
    PROCEDURE PurchaseCheckNumberOfLinesLimit@9(PurchaseHeader@1001 : Record 38) : Boolean;
    VAR
      PurchaseLine@1000 : Record 39;
    BEGIN
      PurchaseLine.SETRANGE("Document No.",PurchaseHeader."No.");
      PurchaseLine.SETRANGE("Document Type",PurchaseHeader."Document Type");
      PurchaseLine.SETFILTER(Type,'<>%1',PurchaseLine.Type::" ");
      PurchaseLine.SETFILTER("No.",'<>%1','');

      EXIT(PurchaseLine.COUNT <= 100);
    END;

    LOCAL PROCEDURE CalculateSalesTaxForTempTotalPurchaseLine@26(PurchaseHeader@1000 : Record 38;CurrentPurchaseLine@1001 : Record 39;VAR TempTotalPurchaseLine@1002 : TEMPORARY Record 39);
    VAR
      Currency@1003 : Record 4;
      SalesTaxCalculate@1004 : Codeunit 398;
      TotalVATAmount@1005 : Decimal;
    BEGIN
      IF PurchaseHeader."Currency Code" = '' THEN
        Currency.InitRoundingPrecision
      ELSE
        Currency.GET(PurchaseHeader."Currency Code");

      CurrentPurchaseLine.SETRANGE("Document No.",CurrentPurchaseLine."Document No.");
      CurrentPurchaseLine.SETRANGE("Document Type",CurrentPurchaseLine."Document Type");
      CurrentPurchaseLine.FINDSET;
      TotalVATAmount := 0;

      // Loop through all purchase lines and calculate correct sales tax.
      REPEAT
        TotalVATAmount := TotalVATAmount + ROUND(
            SalesTaxCalculate.CalculateTax(
              CurrentPurchaseLine."Tax Area Code",CurrentPurchaseLine."Tax Group Code",CurrentPurchaseLine."Tax Liable",
              PurchaseHeader."Posting Date",
              CurrentPurchaseLine."Line Amount" - CurrentPurchaseLine."Inv. Discount Amount",
              CurrentPurchaseLine."Quantity (Base)",PurchaseHeader."Currency Factor"),
            Currency."Amount Rounding Precision");
      UNTIL CurrentPurchaseLine.NEXT = 0;

      TempTotalPurchaseLine."Amount Including VAT" := TempTotalPurchaseLine."Line Amount" -
        TempTotalPurchaseLine."Inv. Discount Amount" + TotalVATAmount;
    END;

    BEGIN
    END.
  }
}

