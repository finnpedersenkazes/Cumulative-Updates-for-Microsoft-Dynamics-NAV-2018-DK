OBJECT Codeunit 70 Purch.-Calc.Discount
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    TableNo=39;
    OnRun=VAR
            TempPurchHeader@1000 : Record 38;
            TempPurchLine@1001 : Record 39;
          BEGIN
            PurchLine.COPY(Rec);

            TempPurchHeader.GET("Document Type","Document No.");
            UpdateHeader := TRUE;
            CalculateInvoiceDiscount(TempPurchHeader,TempPurchLine);

            IF GET(PurchLine."Document Type",PurchLine."Document No.",PurchLine."Line No.") THEN;
          END;

  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Gebyr;ENU=Service Charge';
      PurchLine@1001 : Record 39;
      VendInvDisc@1002 : Record 24;
      VendPostingGr@1003 : Record 93;
      Currency@1004 : Record 4;
      InvDiscBase@1006 : Decimal;
      ChargeBase@1007 : Decimal;
      CurrencyDate@1009 : Date;
      UpdateHeader@1010 : Boolean;

    [Internal]
    PROCEDURE CalculateInvoiceDiscount@1(VAR PurchHeader@1000 : Record 38;VAR PurchLine2@1001 : Record 39);
    VAR
      TempVATAmountLine@1002 : TEMPORARY Record 290;
      PurchSetup@1003 : Record 312;
      TempServiceChargeLine@1005 : TEMPORARY Record 39;
      PurchCalcDiscByType@1004 : Codeunit 66;
    BEGIN
      PurchSetup.GET;

      OnBeforeCalcPurchaseDiscount(PurchHeader);

      WITH PurchLine DO BEGIN
        LOCKTABLE;
        PurchHeader.TESTFIELD("Vendor Posting Group");
        VendPostingGr.GET(PurchHeader."Vendor Posting Group");

        PurchLine2.RESET;
        PurchLine2.SETRANGE("Document Type","Document Type");
        PurchLine2.SETRANGE("Document No.","Document No.");
        PurchLine2.SETFILTER(Type,'<>0');
        PurchLine2.SETRANGE("System-Created Entry",TRUE);
        PurchLine2.SETRANGE(Type,PurchLine2.Type::"G/L Account");
        PurchLine2.SETRANGE("No.",VendPostingGr."Service Charge Acc.");
        IF PurchLine2.FINDSET(TRUE,FALSE) THEN
          REPEAT
            PurchLine2.VALIDATE("Direct Unit Cost",0);
            PurchLine2.MODIFY;
            TempServiceChargeLine := PurchLine2;
            TempServiceChargeLine.INSERT;
          UNTIL PurchLine2.NEXT = 0;

        PurchLine2.RESET;
        PurchLine2.SETRANGE("Document Type","Document Type");
        PurchLine2.SETRANGE("Document No.","Document No.");
        PurchLine2.SETFILTER(Type,'<>0');
        IF PurchLine2.FIND('-') THEN;
        PurchLine2.CalcVATAmountLines(0,PurchHeader,PurchLine2,TempVATAmountLine);
        InvDiscBase :=
          TempVATAmountLine.GetTotalInvDiscBaseAmount(
            PurchHeader."Prices Including VAT",PurchHeader."Currency Code");
        ChargeBase :=
          TempVATAmountLine.GetTotalLineAmount(
            PurchHeader."Prices Including VAT",PurchHeader."Currency Code");

        IF UpdateHeader THEN
          PurchHeader.MODIFY;

        IF PurchHeader."Posting Date" = 0D THEN
          CurrencyDate := WORKDATE
        ELSE
          CurrencyDate := PurchHeader."Posting Date";

        VendInvDisc.GetRec(
          PurchHeader."Invoice Disc. Code",PurchHeader."Currency Code",CurrencyDate,ChargeBase);

        IF VendInvDisc."Service Charge" <> 0 THEN BEGIN
          Currency.Initialize(PurchHeader."Currency Code");
          IF NOT UpdateHeader THEN
            PurchLine2.SetPurchHeader(PurchHeader);
          IF NOT TempServiceChargeLine.ISEMPTY THEN BEGIN
            TempServiceChargeLine.FINDLAST;
            PurchLine2.GET("Document Type","Document No.",TempServiceChargeLine."Line No.");
            IF PurchHeader."Prices Including VAT" THEN
              PurchLine2.VALIDATE(
                "Direct Unit Cost",
                ROUND(
                  (1 + PurchLine2."VAT %" / 100) * VendInvDisc."Service Charge",
                  Currency."Unit-Amount Rounding Precision"))
            ELSE
              PurchLine2.VALIDATE("Direct Unit Cost",VendInvDisc."Service Charge");
            PurchLine2.MODIFY;
          END ELSE BEGIN
            PurchLine2.RESET;
            PurchLine2.SETRANGE("Document Type","Document Type");
            PurchLine2.SETRANGE("Document No.","Document No.");
            PurchLine2.FIND('+');
            PurchLine2.INIT;
            IF NOT UpdateHeader THEN
              PurchLine2.SetPurchHeader(PurchHeader);
            PurchLine2."Line No." := PurchLine2."Line No." + 10000;
            PurchLine2.Type := PurchLine2.Type::"G/L Account";
            PurchLine2.VALIDATE("No.",VendPostingGr.GetServiceChargeAccount);
            PurchLine2.Description := Text000;
            PurchLine2.VALIDATE(Quantity,1);
            IF PurchLine2."Document Type" IN
               [PurchLine2."Document Type"::"Return Order",PurchLine2."Document Type"::"Credit Memo"]
            THEN
              PurchLine2.VALIDATE("Return Qty. to Ship",PurchLine2.Quantity)
            ELSE
              PurchLine2.VALIDATE("Qty. to Receive",PurchLine2.Quantity);
            IF PurchHeader."Prices Including VAT" THEN
              PurchLine2.VALIDATE(
                "Direct Unit Cost",
                ROUND(
                  (1 + PurchLine2."VAT %" / 100) * VendInvDisc."Service Charge",
                  Currency."Unit-Amount Rounding Precision"))
            ELSE
              PurchLine2.VALIDATE("Direct Unit Cost",VendInvDisc."Service Charge");
            PurchLine2."System-Created Entry" := TRUE;
            PurchLine2.INSERT;
          END;
          PurchLine2.CalcVATAmountLines(0,PurchHeader,PurchLine2,TempVATAmountLine);
        END ELSE
          IF TempServiceChargeLine.FINDSET(FALSE,FALSE) THEN
            REPEAT
              IF (TempServiceChargeLine."Receipt No." = '') AND (TempServiceChargeLine."Qty. Rcd. Not Invoiced (Base)" = 0) THEN BEGIN
                PurchLine2 := TempServiceChargeLine;
                PurchLine2.DELETE(TRUE);
              END;
            UNTIL TempServiceChargeLine.NEXT = 0;

        IF VendInvDiscRecExists(PurchHeader."Invoice Disc. Code") THEN BEGIN
          IF InvDiscBase <> ChargeBase THEN
            VendInvDisc.GetRec(
              PurchHeader."Invoice Disc. Code",PurchHeader."Currency Code",CurrencyDate,InvDiscBase);

          PurchHeader."Invoice Discount Calculation" := PurchHeader."Invoice Discount Calculation"::"%";
          PurchHeader."Invoice Discount Value" := VendInvDisc."Discount %";
          IF UpdateHeader THEN
            PurchHeader.MODIFY;

          TempVATAmountLine.SetInvoiceDiscountPercent(
            VendInvDisc."Discount %",PurchHeader."Currency Code",
            PurchHeader."Prices Including VAT",PurchSetup."Calc. Inv. Disc. per VAT ID",
            PurchHeader."VAT Base Discount %");

          PurchLine2.UpdateVATOnLines(0,PurchHeader,PurchLine2,TempVATAmountLine);
          UpdatePrepmtLineAmount(PurchHeader);
        END;
      END;

      PurchCalcDiscByType.ResetRecalculateInvoiceDisc(PurchHeader);
      OnAfterCalcPurchaseDiscount(PurchHeader);
    END;

    LOCAL PROCEDURE VendInvDiscRecExists@3(InvDiscCode@1000 : Code[20]) : Boolean;
    VAR
      VendInvDisc@1001 : Record 24;
    BEGIN
      VendInvDisc.SETRANGE(Code,InvDiscCode);
      EXIT(VendInvDisc.FINDFIRST);
    END;

    [Internal]
    PROCEDURE CalculateIncDiscForHeader@2(VAR PurchHeader@1002 : Record 38);
    VAR
      PurchSetup@1000 : Record 312;
    BEGIN
      PurchSetup.GET;
      IF NOT PurchSetup."Calc. Inv. Discount" THEN
        EXIT;
      WITH PurchHeader DO BEGIN
        PurchLine."Document Type" := "Document Type";
        PurchLine."Document No." := "No.";
        UpdateHeader := TRUE;
        CalculateInvoiceDiscount(PurchHeader,PurchLine);
      END;
    END;

    [Internal]
    PROCEDURE CalculateInvoiceDiscountOnLine@24(VAR PurchLineToUpdate@1001 : Record 39);
    VAR
      PurchHeaderTemp@1003 : Record 38;
    BEGIN
      PurchLine.COPY(PurchLineToUpdate);

      PurchHeaderTemp.GET(PurchLine."Document Type",PurchLine."Document No.");
      UpdateHeader := FALSE;
      CalculateInvoiceDiscount(PurchHeaderTemp,PurchLine);

      IF PurchLineToUpdate.GET(PurchLineToUpdate."Document Type",PurchLineToUpdate."Document No.",PurchLineToUpdate."Line No.") THEN;
    END;

    LOCAL PROCEDURE UpdatePrepmtLineAmount@7(PurchaseHeader@1000 : Record 38);
    VAR
      PurchaseLine@1001 : Record 39;
    BEGIN
      IF (PurchaseHeader."Invoice Discount Calculation" = PurchaseHeader."Invoice Discount Calculation"::"%") AND
         (PurchaseHeader."Prepayment %" > 0) AND (PurchaseHeader."Invoice Discount Value" > 0) AND
         (PurchaseHeader."Invoice Discount Value" + PurchaseHeader."Prepayment %" >= 100)
      THEN
        WITH PurchaseLine DO BEGIN
          SETRANGE("Document Type",PurchaseHeader."Document Type");
          SETRANGE("Document No.",PurchaseHeader."No.");
          IF FINDSET(TRUE) THEN
            REPEAT
              IF NOT ZeroAmountLine(0) AND ("Prepayment %" = PurchaseHeader."Prepayment %") THEN BEGIN
                "Prepmt. Line Amount" := Amount;
                MODIFY;
              END;
            UNTIL NEXT = 0;
        END;
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnBeforeCalcPurchaseDiscount@4(VAR PurchaseHeader@1000 : Record 38);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnAfterCalcPurchaseDiscount@5(VAR PurchaseHeader@1000 : Record 38);
    BEGIN
    END;

    BEGIN
    END.
  }
}

