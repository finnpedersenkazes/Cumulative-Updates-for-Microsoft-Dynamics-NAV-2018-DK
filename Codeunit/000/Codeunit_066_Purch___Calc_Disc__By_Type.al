OBJECT Codeunit 66 Purch - Calc Disc. By Type
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    TableNo=39;
    OnRun=VAR
            PurchHeader@1000 : Record 38;
            PurchLine@1001 : Record 39;
          BEGIN
            PurchLine.COPY(Rec);

            IF PurchHeader.GET("Document Type","Document No.") THEN BEGIN
              ApplyDefaultInvoiceDiscount(0,PurchHeader);
              // on new order might be no line
              IF GET(PurchLine."Document Type",PurchLine."Document No.",PurchLine."Line No.") THEN;
            END;
          END;

  }
  CODE
  {
    VAR
      InvDiscBaseAmountIsZeroErr@1000 : TextConst 'DAN=Der er intet bel�b, hvor du kan anvende en fakturarabat.;ENU=There is no amount that you can apply an invoice discount to.';
      InvDiscSetToZeroMsg@1001 : TextConst '@@@=%1 - Invoice discount amount, %2 Previous value of Invoice discount amount;DAN=Det aktuelle %1 er %2.\\V�rdien angives til nul, fordi totalen er �ndret. Gennemse den nye total, og angiv derefter %1 igen.;ENU=The current %1 is %2.\\The value will be set to zero because the total has changed. Review the new total and then re-enter the %1.';
      AmountInvDiscErr@1002 : TextConst 'DAN=Manuelt %1 er ikke tilladt.;ENU=Manual %1 is not allowed.';

    [External]
    PROCEDURE ApplyDefaultInvoiceDiscount@5(InvoiceDiscountAmount@1000 : Decimal;VAR PurchHeader@1001 : Record 38);
    VAR
      AutoFormatManagement@1004 : Codeunit 45;
      PreviousInvoiceDiscountAmount@1003 : Decimal;
      ShowSetToZeroMessage@1002 : Boolean;
    BEGIN
      IF NOT ShouldRedistributeInvoiceDiscountAmount(PurchHeader) THEN
        EXIT;

      IF PurchHeader."Invoice Discount Calculation" = PurchHeader."Invoice Discount Calculation"::Amount THEN BEGIN
        PreviousInvoiceDiscountAmount := PurchHeader."Invoice Discount Value";
        ShowSetToZeroMessage := (InvoiceDiscountAmount = 0) AND (PurchHeader."Invoice Discount Value" <> 0);
        ApplyInvDiscBasedOnAmt(InvoiceDiscountAmount,PurchHeader);
        IF ShowSetToZeroMessage THEN
          MESSAGE(
            STRSUBSTNO(
              InvDiscSetToZeroMsg,
              PurchHeader.FIELDCAPTION("Invoice Discount Amount"),
              FORMAT(PreviousInvoiceDiscountAmount,0,AutoFormatManagement.AutoFormatTranslate(1,PurchHeader."Currency Code"))));
      END ELSE
        ApplyInvDiscBasedOnPct(PurchHeader);

      ResetRecalculateInvoiceDisc(PurchHeader);
    END;

    [External]
    PROCEDURE ApplyInvDiscBasedOnAmt@1(InvoiceDiscountAmount@1000 : Decimal;VAR PurchHeader@1004 : Record 38);
    VAR
      TempVATAmountLine@1001 : TEMPORARY Record 290;
      PurchLine@1002 : Record 39;
      InvDiscBaseAmount@1003 : Decimal;
    BEGIN
      WITH PurchHeader DO BEGIN
        IF NOT InvoiceDiscIsAllowed("Invoice Disc. Code") THEN
          ERROR(STRSUBSTNO(AmountInvDiscErr,FIELDCAPTION("Invoice Discount Amount")));

        PurchLine.SETRANGE("Document No.","No.");
        PurchLine.SETRANGE("Document Type","Document Type");

        PurchLine.CalcVATAmountLines(0,PurchHeader,PurchLine,TempVATAmountLine);

        InvDiscBaseAmount := TempVATAmountLine.GetTotalInvDiscBaseAmount(FALSE,"Currency Code");

        IF (InvDiscBaseAmount = 0) AND (InvoiceDiscountAmount > 0) THEN
          ERROR(InvDiscBaseAmountIsZeroErr);

        TempVATAmountLine.SetInvoiceDiscountAmount(InvoiceDiscountAmount,"Currency Code",
          "Prices Including VAT","VAT Base Discount %");

        PurchLine.UpdateVATOnLines(0,PurchHeader,PurchLine,TempVATAmountLine);

        "Invoice Discount Calculation" := "Invoice Discount Calculation"::Amount;
        "Invoice Discount Value" := InvoiceDiscountAmount;

        MODIFY;

        ResetRecalculateInvoiceDisc(PurchHeader);
      END;
    END;

    LOCAL PROCEDURE ApplyInvDiscBasedOnPct@6(VAR PurchHeader@1002 : Record 38);
    VAR
      PurchLine@1000 : Record 39;
    BEGIN
      WITH PurchHeader DO BEGIN
        PurchLine.SETRANGE("Document No.","No.");
        PurchLine.SETRANGE("Document Type","Document Type");
        IF PurchLine.FINDFIRST THEN BEGIN
          CODEUNIT.RUN(CODEUNIT::"Purch.-Calc.Discount",PurchLine);
          GET("Document Type","No.");
        END;
      END;
    END;

    [External]
    PROCEDURE GetVendInvoiceDiscountPct@7(PurchLine@1001 : Record 39) : Decimal;
    VAR
      PurchHeader@1000 : Record 38;
      InvoiceDiscountValue@1002 : Decimal;
      AmountIncludingVATDiscountAllowed@1004 : Decimal;
      AmountDiscountAllowed@1003 : Decimal;
    BEGIN
      WITH PurchHeader DO BEGIN
        IF NOT GET(PurchLine."Document Type",PurchLine."Document No.") THEN
          EXIT(0);

        CALCFIELDS("Invoice Discount Amount");
        IF "Invoice Discount Amount" = 0 THEN
          EXIT(0);

        CASE "Invoice Discount Calculation" OF
          "Invoice Discount Calculation"::"%":
            BEGIN
              // Only if VendorInvDisc table is empty header is not updated
              IF NOT VendorInvDiscRecExists("Invoice Disc. Code") THEN
                EXIT(0);

              EXIT("Invoice Discount Value");
            END;
          "Invoice Discount Calculation"::None,
          "Invoice Discount Calculation"::Amount:
            BEGIN
              CalcAmountWithDiscountAllowed(PurchHeader,AmountIncludingVATDiscountAllowed,AmountDiscountAllowed);
              IF AmountDiscountAllowed + InvoiceDiscountValue = 0 THEN
                EXIT(0);

              IF "Invoice Discount Calculation" = "Invoice Discount Calculation"::None THEN
                InvoiceDiscountValue := "Invoice Discount Amount"
              ELSE
                InvoiceDiscountValue := "Invoice Discount Value";

              IF "Prices Including VAT" THEN
                EXIT(ROUND(InvoiceDiscountValue / (AmountIncludingVATDiscountAllowed + InvoiceDiscountValue) * 100,0.01));

              EXIT(ROUND(InvoiceDiscountValue / (AmountDiscountAllowed + InvoiceDiscountValue) * 100,0.01));
            END;
        END;
      END;

      EXIT(0);
    END;

    [External]
    PROCEDURE ShouldRedistributeInvoiceDiscountAmount@101(PurchHeader@1001 : Record 38) : Boolean;
    VAR
      PurchPayablesSetup@1000 : Record 312;
      DummyApplicationAreaSetup@1002 : Record 9178;
    BEGIN
      PurchHeader.CALCFIELDS("Recalculate Invoice Disc.");

      IF NOT PurchHeader."Recalculate Invoice Disc." THEN
        EXIT(FALSE);

      IF (PurchHeader."Invoice Discount Calculation" = PurchHeader."Invoice Discount Calculation"::Amount) AND
         (PurchHeader."Invoice Discount Value" = 0)
      THEN
        EXIT(FALSE);

      PurchPayablesSetup.GET;
      IF (NOT DummyApplicationAreaSetup.IsFoundationEnabled AND
          (NOT PurchPayablesSetup."Calc. Inv. Discount" AND
           (PurchHeader."Invoice Discount Calculation" = PurchHeader."Invoice Discount Calculation"::None)))
      THEN
        EXIT(FALSE);

      EXIT(TRUE);
    END;

    [External]
    PROCEDURE ResetRecalculateInvoiceDisc@8(PurchHeader@1000 : Record 38);
    VAR
      PurchLine@1001 : Record 39;
    BEGIN
      PurchLine.SETRANGE("Document Type",PurchHeader."Document Type");
      PurchLine.SETRANGE("Document No.",PurchHeader."No.");
      PurchLine.MODIFYALL("Recalculate Invoice Disc.",FALSE);

      OnAfterResetRecalculateInvoiceDisc(PurchHeader);
    END;

    LOCAL PROCEDURE VendorInvDiscRecExists@4(InvDiscCode@1000 : Code[20]) : Boolean;
    VAR
      VendorInvoiceDisc@1001 : Record 24;
    BEGIN
      VendorInvoiceDisc.SETRANGE(Code,InvDiscCode);
      EXIT(NOT VendorInvoiceDisc.ISEMPTY);
    END;

    [External]
    PROCEDURE InvoiceDiscIsAllowed@2(InvDiscCode@1001 : Code[20]) : Boolean;
    VAR
      PurchasesPayablesSetup@1000 : Record 312;
      DummyApplicationAreaSetup@1002 : Record 9178;
    BEGIN
      PurchasesPayablesSetup.GET;
      EXIT((DummyApplicationAreaSetup.IsFoundationEnabled OR NOT
            (PurchasesPayablesSetup."Calc. Inv. Discount" AND VendorInvDiscRecExists(InvDiscCode))));
    END;

    LOCAL PROCEDURE CalcAmountWithDiscountAllowed@9(PurchHeader@1003 : Record 38;VAR AmountIncludingVATDiscountAllowed@1000 : Decimal;VAR AmountDiscountAllowed@1001 : Decimal);
    VAR
      PurchLine@1002 : Record 39;
    BEGIN
      WITH PurchLine DO BEGIN
        SETRANGE("Document Type",PurchHeader."Document Type");
        SETRANGE("Document No.",PurchHeader."No.");
        SETRANGE("Allow Invoice Disc.",TRUE);
        CALCSUMS(Amount,"Amount Including VAT");
        AmountIncludingVATDiscountAllowed := "Amount Including VAT";
        AmountDiscountAllowed := Amount;
      END;
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterResetRecalculateInvoiceDisc@3(VAR PurchaseHeader@1000 : Record 38);
    BEGIN
    END;

    BEGIN
    END.
  }
}

