OBJECT Codeunit 60 Sales-Calc. Discount
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
    OnRun=BEGIN
            SalesLine.COPY(Rec);

            TempSalesHeader.GET("Document Type","Document No.");
            UpdateHeader := TRUE;
            CalculateInvoiceDiscount(TempSalesHeader,TempSalesLine);

            IF GET(SalesLine."Document Type",SalesLine."Document No.",SalesLine."Line No.") THEN;
          END;

  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Gebyr;ENU=Service Charge';
      TempSalesHeader@1001 : Record 36;
      SalesLine@1002 : Record 37;
      TempSalesLine@1003 : Record 37;
      CustInvDisc@1004 : Record 19;
      CustPostingGr@1005 : Record 92;
      Currency@1006 : Record 4;
      InvDiscBase@1008 : Decimal;
      ChargeBase@1009 : Decimal;
      CurrencyDate@1011 : Date;
      UpdateHeader@1012 : Boolean;

    LOCAL PROCEDURE CalculateInvoiceDiscount@1(VAR SalesHeader@1000 : Record 36;VAR SalesLine2@1001 : Record 37);
    VAR
      TempVATAmountLine@1002 : TEMPORARY Record 290;
      SalesSetup@1003 : Record 311;
      TempServiceChargeLine@1005 : TEMPORARY Record 37;
      SalesCalcDiscountByType@1004 : Codeunit 56;
    BEGIN
      SalesSetup.GET;
      IF UpdateHeader THEN
        SalesHeader.FIND; // To ensure we have the latest - otherwise update fails.
      OnBeforeCalcSalesDiscount(SalesHeader);

      WITH SalesLine DO BEGIN
        LOCKTABLE;
        SalesHeader.TESTFIELD("Customer Posting Group");
        CustPostingGr.GET(SalesHeader."Customer Posting Group");

        SalesLine2.RESET;
        SalesLine2.SETRANGE("Document Type","Document Type");
        SalesLine2.SETRANGE("Document No.","Document No.");
        SalesLine2.SETRANGE("System-Created Entry",TRUE);
        SalesLine2.SETRANGE(Type,SalesLine2.Type::"G/L Account");
        SalesLine2.SETRANGE("No.",CustPostingGr."Service Charge Acc.");
        IF SalesLine2.FINDSET(TRUE,FALSE) THEN
          REPEAT
            SalesLine2.VALIDATE("Unit Price",0);
            SalesLine2.MODIFY;
            TempServiceChargeLine := SalesLine2;
            TempServiceChargeLine.INSERT;
          UNTIL SalesLine2.NEXT = 0;

        SalesLine2.RESET;
        SalesLine2.SETRANGE("Document Type","Document Type");
        SalesLine2.SETRANGE("Document No.","Document No.");
        SalesLine2.SETFILTER(Type,'<>0');
        IF SalesLine2.FINDFIRST THEN;
        SalesLine2.CalcVATAmountLines(0,SalesHeader,SalesLine2,TempVATAmountLine);
        InvDiscBase :=
          TempVATAmountLine.GetTotalInvDiscBaseAmount(
            SalesHeader."Prices Including VAT",SalesHeader."Currency Code");
        ChargeBase :=
          TempVATAmountLine.GetTotalLineAmount(
            SalesHeader."Prices Including VAT",SalesHeader."Currency Code");

        IF UpdateHeader THEN
          SalesHeader.MODIFY;

        IF SalesHeader."Posting Date" = 0D THEN
          CurrencyDate := WORKDATE
        ELSE
          CurrencyDate := SalesHeader."Posting Date";

        CustInvDisc.GetRec(
          SalesHeader."Invoice Disc. Code",SalesHeader."Currency Code",CurrencyDate,ChargeBase);

        IF CustInvDisc."Service Charge" <> 0 THEN BEGIN
          Currency.Initialize(SalesHeader."Currency Code");
          IF NOT UpdateHeader THEN
            SalesLine2.SetSalesHeader(SalesHeader);
          IF NOT TempServiceChargeLine.ISEMPTY THEN BEGIN
            TempServiceChargeLine.FINDLAST;
            SalesLine2.GET("Document Type","Document No.",TempServiceChargeLine."Line No.");
            IF SalesHeader."Prices Including VAT" THEN
              SalesLine2.VALIDATE(
                "Unit Price",
                ROUND(
                  (1 + SalesLine2."VAT %" / 100) * CustInvDisc."Service Charge",
                  Currency."Unit-Amount Rounding Precision"))
            ELSE
              SalesLine2.VALIDATE("Unit Price",CustInvDisc."Service Charge");
            SalesLine2.MODIFY;
          END ELSE BEGIN
            SalesLine2.RESET;
            SalesLine2.SETRANGE("Document Type","Document Type");
            SalesLine2.SETRANGE("Document No.","Document No.");
            SalesLine2.FINDLAST;
            SalesLine2.INIT;
            IF NOT UpdateHeader THEN
              SalesLine2.SetSalesHeader(SalesHeader);
            SalesLine2."Line No." := SalesLine2."Line No." + 10000;
            SalesLine2."System-Created Entry" := TRUE;
            SalesLine2.Type := SalesLine2.Type::"G/L Account";
            SalesLine2.VALIDATE("No.",CustPostingGr.GetServiceChargeAccount);
            SalesLine2.Description := Text000;
            SalesLine2.VALIDATE(Quantity,1);
            IF SalesLine2."Document Type" IN
               [SalesLine2."Document Type"::"Return Order",SalesLine2."Document Type"::"Credit Memo"]
            THEN
              SalesLine2.VALIDATE("Return Qty. to Receive",SalesLine2.Quantity)
            ELSE
              SalesLine2.VALIDATE("Qty. to Ship",SalesLine2.Quantity);
            IF SalesHeader."Prices Including VAT" THEN
              SalesLine2.VALIDATE(
                "Unit Price",
                ROUND(
                  (1 + SalesLine2."VAT %" / 100) * CustInvDisc."Service Charge",
                  Currency."Unit-Amount Rounding Precision"))
            ELSE
              SalesLine2.VALIDATE("Unit Price",CustInvDisc."Service Charge");
            SalesLine2.INSERT;
          END;
          SalesLine2.CalcVATAmountLines(0,SalesHeader,SalesLine2,TempVATAmountLine);
        END ELSE
          IF TempServiceChargeLine.FINDSET(FALSE,FALSE) THEN
            REPEAT
              IF (TempServiceChargeLine."Shipment No." = '') AND (TempServiceChargeLine."Qty. Shipped Not Invoiced" = 0) THEN BEGIN
                SalesLine2 := TempServiceChargeLine;
                SalesLine2.DELETE(TRUE);
              END;
            UNTIL TempServiceChargeLine.NEXT = 0;

        IF CustInvDiscRecExists(SalesHeader."Invoice Disc. Code") THEN BEGIN
          IF InvDiscBase <> ChargeBase THEN
            CustInvDisc.GetRec(
              SalesHeader."Invoice Disc. Code",SalesHeader."Currency Code",CurrencyDate,InvDiscBase);

          SalesHeader."Invoice Discount Calculation" := SalesHeader."Invoice Discount Calculation"::"%";
          SalesHeader."Invoice Discount Value" := CustInvDisc."Discount %";
          IF UpdateHeader THEN
            SalesHeader.MODIFY;

          TempVATAmountLine.SetInvoiceDiscountPercent(
            CustInvDisc."Discount %",SalesHeader."Currency Code",
            SalesHeader."Prices Including VAT",SalesSetup."Calc. Inv. Disc. per VAT ID",
            SalesHeader."VAT Base Discount %");

          SalesLine2.SetSalesHeader(SalesHeader);
          SalesLine2.UpdateVATOnLines(0,SalesHeader,SalesLine2,TempVATAmountLine);
          UpdatePrepmtLineAmount(SalesHeader);
        END;
      END;

      SalesCalcDiscountByType.ResetRecalculateInvoiceDisc(SalesHeader);
      OnAfterCalcSalesDiscount(SalesHeader);
    END;

    LOCAL PROCEDURE CustInvDiscRecExists@2(InvDiscCode@1000 : Code[20]) : Boolean;
    VAR
      CustInvDisc@1001 : Record 19;
    BEGIN
      CustInvDisc.SETRANGE(Code,InvDiscCode);
      EXIT(CustInvDisc.FINDFIRST);
    END;

    [Internal]
    PROCEDURE CalculateWithSalesHeader@24(VAR TempSalesHeader@1000 : Record 36;VAR TempSalesLine@1001 : Record 37);
    VAR
      FilterSalesLine@1002 : Record 37;
    BEGIN
      FilterSalesLine.COPY(TempSalesLine);
      SalesLine := TempSalesLine;

      UpdateHeader := FALSE;
      CalculateInvoiceDiscount(TempSalesHeader,TempSalesLine);

      TempSalesLine.COPY(FilterSalesLine);
    END;

    [External]
    PROCEDURE CalculateInvoiceDiscountOnLine@5(VAR SalesLineToUpdate@1001 : Record 37);
    BEGIN
      SalesLine.COPY(SalesLineToUpdate);

      TempSalesHeader.GET(SalesLineToUpdate."Document Type",SalesLineToUpdate."Document No.");
      UpdateHeader := FALSE;
      CalculateInvoiceDiscount(TempSalesHeader,SalesLineToUpdate);

      SalesLineToUpdate.COPY(SalesLine);
    END;

    [External]
    PROCEDURE CalculateIncDiscForHeader@3(VAR TempSalesHeader@1000 : Record 36);
    VAR
      SalesSetup@1003 : Record 311;
    BEGIN
      SalesSetup.GET;
      IF NOT SalesSetup."Calc. Inv. Discount" THEN
        EXIT;
      WITH TempSalesHeader DO BEGIN
        SalesLine."Document Type" := "Document Type";
        SalesLine."Document No." := "No.";
        UpdateHeader := TRUE;
        CalculateInvoiceDiscount(TempSalesHeader,TempSalesLine);
      END;
    END;

    LOCAL PROCEDURE UpdatePrepmtLineAmount@8(SalesHeader@1000 : Record 36);
    VAR
      SalesLine@1001 : Record 37;
    BEGIN
      IF (SalesHeader."Invoice Discount Calculation" = SalesHeader."Invoice Discount Calculation"::"%") AND
         (SalesHeader."Prepayment %" > 0) AND (SalesHeader."Invoice Discount Value" > 0) AND
         (SalesHeader."Invoice Discount Value" + SalesHeader."Prepayment %" >= 100)
      THEN
        WITH SalesLine DO BEGIN
          SETRANGE("Document Type",SalesHeader."Document Type");
          SETRANGE("Document No.",SalesHeader."No.");
          IF FINDSET(TRUE) THEN
            REPEAT
              IF NOT ZeroAmountLine(0) AND ("Prepayment %" = SalesHeader."Prepayment %") THEN BEGIN
                "Prepmt. Line Amount" := Amount;
                MODIFY;
              END;
            UNTIL NEXT = 0;
        END;
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnBeforeCalcSalesDiscount@4(VAR SalesHeader@1000 : Record 36);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnAfterCalcSalesDiscount@6(VAR SalesHeader@1000 : Record 36);
    BEGIN
    END;

    BEGIN
    END.
  }
}

