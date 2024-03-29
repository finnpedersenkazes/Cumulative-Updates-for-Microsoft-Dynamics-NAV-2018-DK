OBJECT Codeunit 56 Sales - Calc Discount By Type
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    TableNo=37;
    OnRun=VAR
            SalesLine@1000 : Record 37;
            SalesHeader@1001 : Record 36;
          BEGIN
            SalesLine.COPY(Rec);

            IF SalesHeader.GET("Document Type","Document No.") THEN BEGIN
              ApplyDefaultInvoiceDiscount(SalesHeader."Invoice Discount Value",SalesHeader);
              // on new order might be no line
              IF GET(SalesLine."Document Type",SalesLine."Document No.",SalesLine."Line No.") THEN;
            END;
          END;

  }
  CODE
  {
    VAR
      InvDiscBaseAmountIsZeroErr@1000 : TextConst 'DAN=Der er intet bel�b, hvor du kan anvende en fakturarabat.;ENU=There is no amount that you can apply an invoice discount to.';
      AmountInvDiscErr@1002 : TextConst '@@@=%1 will be "Invoice Discount Amount";DAN=Manuelt %1 er ikke tilladt.;ENU=Manual %1 is not allowed.';
      CalcInvoiceDiscountOnSalesLine@1001 : Boolean;

    [External]
    PROCEDURE ApplyDefaultInvoiceDiscount@70(InvoiceDiscountAmount@1000 : Decimal;VAR SalesHeader@1001 : Record 36);
    BEGIN
      IF NOT ShouldRedistributeInvoiceDiscountAmount(SalesHeader) THEN
        EXIT;

      IF SalesHeader."Invoice Discount Calculation" = SalesHeader."Invoice Discount Calculation"::Amount THEN
        ApplyInvDiscBasedOnAmt(InvoiceDiscountAmount,SalesHeader)
      ELSE
        ApplyInvDiscBasedOnPct(SalesHeader);

      ResetRecalculateInvoiceDisc(SalesHeader);
    END;

    [External]
    PROCEDURE ApplyInvDiscBasedOnAmt@60(InvoiceDiscountAmount@1000 : Decimal;VAR SalesHeader@1005 : Record 36);
    VAR
      TempVATAmountLine@1001 : TEMPORARY Record 290;
      SalesLine@1002 : Record 37;
      InvDiscBaseAmount@1003 : Decimal;
    BEGIN
      WITH SalesHeader DO BEGIN
        IF NOT InvoiceDiscIsAllowed("Invoice Disc. Code") THEN
          ERROR(STRSUBSTNO(AmountInvDiscErr,FIELDCAPTION("Invoice Discount Amount")));

        SalesLine.SETRANGE("Document No.","No.");
        SalesLine.SETRANGE("Document Type","Document Type");

        SalesLine.CalcVATAmountLines(0,SalesHeader,SalesLine,TempVATAmountLine);

        InvDiscBaseAmount := TempVATAmountLine.GetTotalInvDiscBaseAmount(FALSE,"Currency Code");

        IF (InvDiscBaseAmount = 0) AND (InvoiceDiscountAmount > 0) THEN
          ERROR(InvDiscBaseAmountIsZeroErr);

        TempVATAmountLine.SetInvoiceDiscountAmount(InvoiceDiscountAmount,"Currency Code",
          "Prices Including VAT","VAT Base Discount %");

        SalesLine.UpdateVATOnLines(0,SalesHeader,SalesLine,TempVATAmountLine);

        "Invoice Discount Calculation" := "Invoice Discount Calculation"::Amount;
        "Invoice Discount Value" := InvoiceDiscountAmount;

        ResetRecalculateInvoiceDisc(SalesHeader);

        MODIFY;
      END;
    END;

    LOCAL PROCEDURE ApplyInvDiscBasedOnPct@73(VAR SalesHeader@1001 : Record 36);
    VAR
      SalesLine@1000 : Record 37;
      SalesCalcDiscount@1002 : Codeunit 60;
    BEGIN
      WITH SalesHeader DO BEGIN
        SalesLine.SETRANGE("Document No.","No.");
        SalesLine.SETRANGE("Document Type","Document Type");
        IF SalesLine.FINDFIRST THEN BEGIN
          IF CalcInvoiceDiscountOnSalesLine THEN
            SalesCalcDiscount.CalculateInvoiceDiscountOnLine(SalesLine)
          ELSE
            CODEUNIT.RUN(CODEUNIT::"Sales-Calc. Discount",SalesLine);
          GET("Document Type","No.");
        END;
      END;
    END;

    [External]
    PROCEDURE GetCustInvoiceDiscountPct@64(SalesLine@1001 : Record 37) : Decimal;
    VAR
      SalesHeader@1000 : Record 36;
      InvoiceDiscountValue@1002 : Decimal;
      AmountIncludingVATDiscountAllowed@1004 : Decimal;
      AmountDiscountAllowed@1003 : Decimal;
    BEGIN
      WITH SalesHeader DO BEGIN
        IF NOT GET(SalesLine."Document Type",SalesLine."Document No.") THEN
          EXIT(0);

        CALCFIELDS("Invoice Discount Amount");
        IF "Invoice Discount Amount" = 0 THEN
          EXIT(0);

        CASE "Invoice Discount Calculation" OF
          "Invoice Discount Calculation"::"%":
            BEGIN
              // Only if CustInvDisc table is empty header is not updated
              IF NOT CustInvDiscRecExists("Invoice Disc. Code") THEN
                EXIT(0);

              EXIT("Invoice Discount Value");
            END;
          "Invoice Discount Calculation"::None,
          "Invoice Discount Calculation"::Amount:
            BEGIN
              IF "Invoice Discount Calculation" = "Invoice Discount Calculation"::None THEN
                InvoiceDiscountValue := "Invoice Discount Amount"
              ELSE
                InvoiceDiscountValue := "Invoice Discount Value";

              CalcAmountWithDiscountAllowed(SalesHeader,AmountIncludingVATDiscountAllowed,AmountDiscountAllowed);
              IF AmountDiscountAllowed + InvoiceDiscountValue = 0 THEN
                EXIT(0);

              IF "Prices Including VAT" THEN
                EXIT(ROUND(InvoiceDiscountValue / (AmountIncludingVATDiscountAllowed + InvoiceDiscountValue) * 100,0.01));

              EXIT(ROUND(InvoiceDiscountValue / (AmountDiscountAllowed + InvoiceDiscountValue) * 100,0.01));
            END;
        END;
      END;

      EXIT(0);
    END;

    [External]
    PROCEDURE ShouldRedistributeInvoiceDiscountAmount@101(VAR SalesHeader@1001 : Record 36) : Boolean;
    VAR
      DummyApplicationAreaSetup@1002 : Record 9178;
    BEGIN
      SalesHeader.CALCFIELDS("Recalculate Invoice Disc.");

      IF NOT SalesHeader."Recalculate Invoice Disc." THEN
        EXIT(FALSE);

      CASE SalesHeader."Invoice Discount Calculation" OF
        SalesHeader."Invoice Discount Calculation"::Amount:
          EXIT(SalesHeader."Invoice Discount Value" <> 0);
        SalesHeader."Invoice Discount Calculation"::"%":
          EXIT(TRUE);
        SalesHeader."Invoice Discount Calculation"::None:
          BEGIN
            IF DummyApplicationAreaSetup.IsFoundationEnabled THEN
              EXIT(TRUE);

            EXIT(NOT InvoiceDiscIsAllowed(SalesHeader."Invoice Disc. Code"));
          END;
        ELSE
          EXIT(TRUE);
      END;
    END;

    [External]
    PROCEDURE ResetRecalculateInvoiceDisc@1(SalesHeader@1000 : Record 36);
    VAR
      SalesLine@1001 : Record 37;
    BEGIN
      SalesLine.SETRANGE("Document Type",SalesHeader."Document Type");
      SalesLine.SETRANGE("Document No.",SalesHeader."No.");
      SalesLine.SETRANGE("Recalculate Invoice Disc.",TRUE);
      SalesLine.MODIFYALL("Recalculate Invoice Disc.",FALSE);

      OnAfterResetRecalculateInvoiceDisc(SalesHeader);
    END;

    LOCAL PROCEDURE CustInvDiscRecExists@4(InvDiscCode@1000 : Code[20]) : Boolean;
    VAR
      CustInvDisc@1001 : Record 19;
    BEGIN
      CustInvDisc.SETRANGE(Code,InvDiscCode);
      EXIT(NOT CustInvDisc.ISEMPTY);
    END;

    [External]
    PROCEDURE InvoiceDiscIsAllowed@2(InvDiscCode@1001 : Code[20]) : Boolean;
    VAR
      SalesReceivablesSetup@1000 : Record 311;
    BEGIN
      SalesReceivablesSetup.GET;
      IF NOT SalesReceivablesSetup."Calc. Inv. Discount" THEN
        EXIT(TRUE);

      EXIT(NOT CustInvDiscRecExists(InvDiscCode));
    END;

    LOCAL PROCEDURE CalcAmountWithDiscountAllowed@5(SalesHeader@1003 : Record 36;VAR AmountIncludingVATDiscountAllowed@1000 : Decimal;VAR AmountDiscountAllowed@1001 : Decimal);
    VAR
      SalesLine@1002 : Record 37;
    BEGIN
      WITH SalesLine DO BEGIN
        SETRANGE("Document Type",SalesHeader."Document Type");
        SETRANGE("Document No.",SalesHeader."No.");
        SETRANGE("Allow Invoice Disc.",TRUE);
        CALCSUMS(Amount,"Amount Including VAT");
        AmountIncludingVATDiscountAllowed := "Amount Including VAT";
        AmountDiscountAllowed := Amount;
      END;
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterResetRecalculateInvoiceDisc@3(VAR SalesHeader@1000 : Record 36);
    BEGIN
    END;

    PROCEDURE CalcInvoiceDiscOnLine@10(CalcInvoiceDiscountOnLine@1000 : Boolean);
    BEGIN
      CalcInvoiceDiscountOnSalesLine := CalcInvoiceDiscountOnLine;
    END;

    BEGIN
    END.
  }
}

