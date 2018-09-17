OBJECT Codeunit 368 Format Document
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
      PurchaserTxt@1005 : TextConst 'DAN=Indk�ber;ENU=Purchaser';
      SalespersonTxt@1000 : TextConst 'DAN=S�lger;ENU=Salesperson';
      TotalTxt@1003 : TextConst '@@@="%1 = Currency Code";DAN=I alt %1;ENU=Total %1';
      TotalInclVATTxt@1002 : TextConst '@@@="%1 = Currency Code";DAN=I alt %1 inkl. moms;ENU=Total %1 Incl. VAT';
      TotalExclVATTxt@1001 : TextConst '@@@="%1 = Currency Code";DAN=I alt %1 ekskl. moms;ENU=Total %1 Excl. VAT';
      GLSetup@1004 : Record 98;
      COPYTxt@1006 : TextConst '@@@=COPY;DAN=KOPI;ENU=COPY';
      AutoFormatManagement@1007 : Codeunit 45;

    [External]
    PROCEDURE GetCOPYText@10() : Text[30];
    BEGIN
      EXIT(' ' + COPYTxt);
    END;

    [External]
    PROCEDURE ParseComment@11(Comment@1000 : Text[80];VAR Description@1001 : Text[50];VAR Description2@1002 : Text[50]);
    VAR
      SpacePointer@1003 : Integer;
    BEGIN
      IF STRLEN(Comment) <= MAXSTRLEN(Description) THEN BEGIN
        Description := COPYSTR(Comment,1,MAXSTRLEN(Description));
        Description2 := '';
      END ELSE BEGIN
        SpacePointer := MAXSTRLEN(Description) + 1;
        WHILE (SpacePointer > 1) AND (Comment[SpacePointer] <> ' ') DO
          SpacePointer := SpacePointer - 1;
        IF SpacePointer = 1 THEN
          SpacePointer := MAXSTRLEN(Description) + 1;
        Description := COPYSTR(Comment,1,SpacePointer - 1);
        Description2 := COPYSTR(COPYSTR(Comment,SpacePointer + 1),1,MAXSTRLEN(Description2));
      END;
    END;

    [External]
    PROCEDURE SetTotalLabels@8(CurrencyCode@1005 : Code[10];VAR TotalText@1002 : Text[50];VAR TotalInclVATText@1001 : Text[50];VAR TotalExclVATText@1000 : Text[50]);
    BEGIN
      IF CurrencyCode = '' THEN BEGIN
        GLSetup.GET;
        GLSetup.TESTFIELD("LCY Code");
        TotalText := STRSUBSTNO(TotalTxt,GLSetup."LCY Code");
        TotalInclVATText := STRSUBSTNO(TotalInclVATTxt,GLSetup."LCY Code");
        TotalExclVATText := STRSUBSTNO(TotalExclVATTxt,GLSetup."LCY Code");
      END ELSE BEGIN
        TotalText := STRSUBSTNO(TotalTxt,CurrencyCode);
        TotalInclVATText := STRSUBSTNO(TotalInclVATTxt,CurrencyCode);
        TotalExclVATText := STRSUBSTNO(TotalExclVATTxt,CurrencyCode);
      END;
    END;

    [External]
    PROCEDURE SetLogoPosition@1(LogoPosition@1000 : 'No Logo,Left,Center,Right';VAR CompanyInfo1@1001 : Record 79;VAR CompanyInfo2@1002 : Record 79;VAR CompanyInfo3@1003 : Record 79);
    BEGIN
      CASE LogoPosition OF
        LogoPosition::"No Logo":
          ;
        LogoPosition::Left:
          BEGIN
            CompanyInfo3.GET;
            CompanyInfo3.CALCFIELDS(Picture);
          END;
        LogoPosition::Center:
          BEGIN
            CompanyInfo1.GET;
            CompanyInfo1.CALCFIELDS(Picture);
          END;
        LogoPosition::Right:
          BEGIN
            CompanyInfo2.GET;
            CompanyInfo2.CALCFIELDS(Picture);
          END;
      END;
    END;

    [External]
    PROCEDURE SetPaymentMethod@6(VAR PaymentMethod@1000 : Record 289;Code@1001 : Code[10]);
    BEGIN
      IF Code = '' THEN
        PaymentMethod.INIT
      ELSE
        PaymentMethod.GET(Code);
    END;

    [External]
    PROCEDURE SetPaymentTerms@2(VAR PaymentTerms@1000 : Record 3;Code@1001 : Code[10];LanguageCode@1002 : Code[10]);
    BEGIN
      IF Code = '' THEN
        PaymentTerms.INIT
      ELSE BEGIN
        PaymentTerms.GET(Code);
        PaymentTerms.TranslateDescription(PaymentTerms,LanguageCode);
      END;
    END;

    [External]
    PROCEDURE SetPurchaser@7(VAR SalespersonPurchaser@1000 : Record 13;Code@1001 : Code[20];VAR PurchaserText@1002 : Text[50]);
    BEGIN
      IF Code = '' THEN BEGIN
        SalespersonPurchaser.INIT;
        PurchaserText := '';
      END ELSE BEGIN
        SalespersonPurchaser.GET(Code);
        PurchaserText := PurchaserTxt;
      END;
    END;

    [External]
    PROCEDURE SetShipmentMethod@3(VAR ShipmentMethod@1000 : Record 10;Code@1001 : Code[10];LanguageCode@1002 : Code[10]);
    BEGIN
      IF Code = '' THEN
        ShipmentMethod.INIT
      ELSE BEGIN
        ShipmentMethod.GET(Code);
        ShipmentMethod.TranslateDescription(ShipmentMethod,LanguageCode);
      END;
    END;

    [External]
    PROCEDURE SetSalesPerson@5(VAR SalespersonPurchaser@1000 : Record 13;Code@1001 : Code[20];VAR SalesPersonText@1002 : Text[50]);
    BEGIN
      IF Code = '' THEN BEGIN
        SalespersonPurchaser.INIT;
        SalesPersonText := '';
      END ELSE BEGIN
        SalespersonPurchaser.GET(Code);
        SalesPersonText := SalespersonTxt;
      END;
    END;

    [External]
    PROCEDURE SetText@4(Condition@1000 : Boolean;Caption@1002 : Text[80]) : Text[80];
    BEGIN
      IF Condition THEN
        EXIT(Caption);

      EXIT('');
    END;

    [External]
    PROCEDURE SetSalesInvoiceLine@17(VAR SalesInvoiceLine@1000 : Record 113;VAR FormattedQuantity@1004 : Text;VAR FormattedUnitPrice@1003 : Text;VAR FormattedVATPercentage@1001 : Text;VAR FormattedLineAmount@1002 : Text);
    BEGIN
      SetSalesPurchaseLine(SalesInvoiceLine.Type = SalesInvoiceLine.Type::" ",
        SalesInvoiceLine.Quantity,
        SalesInvoiceLine."Unit Price",
        SalesInvoiceLine."VAT %",
        SalesInvoiceLine."Line Amount",
        SalesInvoiceLine.GetCurrencyCode,
        FormattedQuantity,
        FormattedUnitPrice,
        FormattedVATPercentage,
        FormattedLineAmount);
    END;

    [External]
    PROCEDURE SetSalesLine@18(VAR SalesLine@1000 : Record 37;VAR FormattedQuantity@1004 : Text;VAR FormattedUnitPrice@1003 : Text;VAR FormattedVATPercentage@1001 : Text;VAR FormattedLineAmount@1002 : Text);
    BEGIN
      SetSalesPurchaseLine(SalesLine.Type = SalesLine.Type::" ",
        SalesLine.Quantity,
        SalesLine."Unit Price",
        SalesLine."VAT %",
        SalesLine."Line Amount",
        SalesLine."Currency Code",
        FormattedQuantity,
        FormattedUnitPrice,
        FormattedVATPercentage,
        FormattedLineAmount);
    END;

    [External]
    PROCEDURE SetSalesCrMemoLine@9(VAR SalesCrMemoLine@1000 : Record 115;VAR FormattedQuantity@1004 : Text;VAR FormattedUnitPrice@1003 : Text;VAR FormattedVATPercentage@1001 : Text;VAR FormattedLineAmount@1002 : Text);
    BEGIN
      SetSalesPurchaseLine(SalesCrMemoLine.Type = SalesCrMemoLine.Type::" ",
        SalesCrMemoLine.Quantity,
        SalesCrMemoLine."Unit Price",
        SalesCrMemoLine."VAT %",
        SalesCrMemoLine."Line Amount",
        SalesCrMemoLine.GetCurrencyCode,
        FormattedQuantity,
        FormattedUnitPrice,
        FormattedVATPercentage,
        FormattedLineAmount);
    END;

    [External]
    PROCEDURE SetPurchaseLine@19(VAR PurchaseLine@1000 : Record 39;VAR FormattedQuantity@1004 : Text;VAR FormattedDirectUnitCost@1003 : Text);
    VAR
      TempVatPct@1001 : Text;
      TempLineAmount@1005 : Text;
    BEGIN
      SetSalesPurchaseLine(PurchaseLine.Type = PurchaseLine.Type::" ",
        PurchaseLine.Quantity,
        PurchaseLine."Direct Unit Cost",
        PurchaseLine."VAT %",
        PurchaseLine."Line Amount",
        PurchaseLine."Currency Code",
        FormattedQuantity,
        FormattedDirectUnitCost,
        TempVatPct,
        TempLineAmount);
    END;

    LOCAL PROCEDURE SetSalesPurchaseLine@12(CommentLine@1006 : Boolean;Quantity@1005 : Decimal;UnitPrice@1004 : Decimal;VATPercentage@1003 : Decimal;LineAmount@1008 : Decimal;CurrencyCode@1007 : Code[10];VAR FormattedQuantity@1002 : Text;VAR FormattedUnitPrice@1001 : Text;VAR FormattedVATPercentage@1000 : Text;VAR FormattedLineAmount@1009 : Text);
    BEGIN
      IF CommentLine THEN BEGIN
        FormattedQuantity := '';
        FormattedUnitPrice := '';
        FormattedVATPercentage := '';
        FormattedLineAmount := '';
      END ELSE BEGIN
        FormattedQuantity := FORMAT(Quantity);
        FormattedUnitPrice := FORMAT(UnitPrice,0,AutoFormatManagement.AutoFormatTranslate(2,CurrencyCode));
        FormattedVATPercentage := FORMAT(VATPercentage);
        FormattedLineAmount := FORMAT(LineAmount);
      END;
    END;

    BEGIN
    END.
  }
}

