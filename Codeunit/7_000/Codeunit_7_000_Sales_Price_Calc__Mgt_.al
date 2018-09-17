OBJECT Codeunit 7000 Sales Price Calc. Mgt.
{
  OBJECT-PROPERTIES
  {
    Date=28-06-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23019;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      GLSetup@1017 : Record 98;
      Item@1000 : Record 27;
      ResPrice@1009 : Record 201;
      Res@1026 : Record 156;
      Currency@1007 : Record 4;
      Text000@1023 : TextConst 'DAN=%1 er mindre end %2 i %3.;ENU=%1 is less than %2 in the %3.';
      Text010@1006 : TextConst 'DAN=Priser inkl. moms kan ikke beregnes, n�r %1 er %2.;ENU=Prices including VAT cannot be calculated when %1 is %2.';
      TempSalesPrice@1002 : TEMPORARY Record 7002;
      TempSalesLineDisc@1015 : TEMPORARY Record 7004;
      LineDiscPerCent@1022 : Decimal;
      Qty@1021 : Decimal;
      AllowLineDisc@1019 : Boolean;
      AllowInvDisc@1020 : Boolean;
      VATPerCent@1012 : Decimal;
      PricesInclVAT@1008 : Boolean;
      VATCalcType@1004 : 'Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax';
      VATBusPostingGr@1003 : Code[20];
      QtyPerUOM@1016 : Decimal;
      PricesInCurrency@1014 : Boolean;
      CurrencyFactor@1013 : Decimal;
      ExchRateDate@1011 : Date;
      Text018@1018 : TextConst 'DAN=%1 %2 er st�rre end %3 og blev rettet til %4.;ENU=%1 %2 is greater than %3 and was adjusted to %4.';
      FoundSalesPrice@1024 : Boolean;
      Text001@1025 : TextConst 'DAN=%1 i %2 skal v�re identisk med %3.;ENU=The %1 in the %2 must be same as in the %3.';
      HideResUnitPriceMessage@1005 : Boolean;
      DateCaption@1001 : Text[30];

    [External]
    PROCEDURE FindSalesLinePrice@2(SalesHeader@1001 : Record 36;VAR SalesLine@1000 : Record 37;CalledByFieldNo@1002 : Integer);
    BEGIN
      WITH SalesLine DO BEGIN
        SetCurrency(
          SalesHeader."Currency Code",SalesHeader."Currency Factor",SalesHeaderExchDate(SalesHeader));
        SetVAT(SalesHeader."Prices Including VAT","VAT %","VAT Calculation Type","VAT Bus. Posting Group");
        SetUoM(ABS(Quantity),"Qty. per Unit of Measure");
        SetLineDisc("Line Discount %","Allow Line Disc.","Allow Invoice Disc.");

        TESTFIELD("Qty. per Unit of Measure");
        IF PricesInCurrency THEN
          SalesHeader.TESTFIELD("Currency Factor");

        CASE Type OF
          Type::Item:
            BEGIN
              Item.GET("No.");
              SalesLinePriceExists(SalesHeader,SalesLine,FALSE);
              CalcBestUnitPrice(TempSalesPrice);

              IF FoundSalesPrice OR
                 NOT ((CalledByFieldNo = FIELDNO(Quantity)) OR
                      (CalledByFieldNo = FIELDNO("Variant Code")))
              THEN BEGIN
                "Allow Line Disc." := TempSalesPrice."Allow Line Disc.";
                "Allow Invoice Disc." := TempSalesPrice."Allow Invoice Disc.";
                "Unit Price" := TempSalesPrice."Unit Price";
              END;
              IF NOT "Allow Line Disc." THEN
                "Line Discount %" := 0;
            END;
          Type::Resource:
            BEGIN
              SetResPrice("No.","Work Type Code","Currency Code");
              CODEUNIT.RUN(CODEUNIT::"Resource-Find Price",ResPrice);

              ConvertPriceToVAT(FALSE,'','',ResPrice."Unit Price");
              ConvertPriceLCYToFCY(ResPrice."Currency Code",ResPrice."Unit Price");
              "Unit Price" := ResPrice."Unit Price" * "Qty. per Unit of Measure";
            END;
        END;
        OnAfterFindSalesLinePrice(SalesLine,SalesHeader,TempSalesPrice,ResPrice,CalledByFieldNo);
      END;
    END;

    [External]
    PROCEDURE FindItemJnlLinePrice@3(VAR ItemJnlLine@1000 : Record 83;CalledByFieldNo@1001 : Integer);
    BEGIN
      WITH ItemJnlLine DO BEGIN
        SetCurrency('',0,0D);
        SetVAT(FALSE,0,0,'');
        SetUoM(ABS(Quantity),"Qty. per Unit of Measure");
        TESTFIELD("Qty. per Unit of Measure");
        Item.GET("Item No.");

        FindSalesPrice(
          TempSalesPrice,'','','','',"Item No.","Variant Code",
          "Unit of Measure Code",'',"Posting Date",FALSE);
        CalcBestUnitPrice(TempSalesPrice);
        IF FoundSalesPrice OR
           NOT ((CalledByFieldNo = FIELDNO(Quantity)) OR
                (CalledByFieldNo = FIELDNO("Variant Code")))
        THEN
          VALIDATE("Unit Amount",TempSalesPrice."Unit Price");
        OnAfterFindItemJnlLinePrice(ItemJnlLine,TempSalesPrice,CalledByFieldNo);
      END;
    END;

    [External]
    PROCEDURE FindServLinePrice@10(ServHeader@1004 : Record 5900;VAR ServLine@1000 : Record 5902;CalledByFieldNo@1001 : Integer);
    VAR
      ServCost@1002 : Record 5905;
      Res@1003 : Record 156;
    BEGIN
      WITH ServLine DO BEGIN
        ServHeader.GET("Document Type","Document No.");
        IF Type <> Type::" " THEN BEGIN
          SetCurrency(
            ServHeader."Currency Code",ServHeader."Currency Factor",ServHeaderExchDate(ServHeader));
          SetVAT(ServHeader."Prices Including VAT","VAT %","VAT Calculation Type","VAT Bus. Posting Group");
          SetUoM(ABS(Quantity),"Qty. per Unit of Measure");
          SetLineDisc("Line Discount %","Allow Line Disc.",FALSE);

          TESTFIELD("Qty. per Unit of Measure");
          IF PricesInCurrency THEN
            ServHeader.TESTFIELD("Currency Factor");
        END;

        CASE Type OF
          Type::Item:
            BEGIN
              ServLinePriceExists(ServHeader,ServLine,FALSE);
              CalcBestUnitPrice(TempSalesPrice);
              IF FoundSalesPrice OR
                 NOT ((CalledByFieldNo = FIELDNO(Quantity)) OR
                      (CalledByFieldNo = FIELDNO("Variant Code")))
              THEN BEGIN
                IF "Line Discount Type" = "Line Discount Type"::"Line Disc." THEN
                  "Allow Line Disc." := TempSalesPrice."Allow Line Disc.";
                "Unit Price" := TempSalesPrice."Unit Price";
              END;
              IF NOT "Allow Line Disc." AND ("Line Discount Type" = "Line Discount Type"::"Line Disc.") THEN
                "Line Discount %" := 0;
            END;
          Type::Resource:
            BEGIN
              SetResPrice("No.","Work Type Code","Currency Code");
              CODEUNIT.RUN(CODEUNIT::"Resource-Find Price",ResPrice);

              ConvertPriceToVAT(FALSE,'','',ResPrice."Unit Price");
              ResPrice."Unit Price" := ResPrice."Unit Price" * "Qty. per Unit of Measure";
              ConvertPriceLCYToFCY(ResPrice."Currency Code",ResPrice."Unit Price");
              IF (ResPrice."Unit Price" > ServHeader."Max. Labor Unit Price") AND
                 (ServHeader."Max. Labor Unit Price" <> 0)
              THEN BEGIN
                Res.GET("No.");
                "Unit Price" := ServHeader."Max. Labor Unit Price";
                IF (HideResUnitPriceMessage = FALSE) AND
                   (CalledByFieldNo <> FIELDNO(Quantity))
                THEN
                  MESSAGE(
                    STRSUBSTNO(
                      Text018,
                      Res.TABLECAPTION,FIELDCAPTION("Unit Price"),
                      ServHeader.FIELDCAPTION("Max. Labor Unit Price"),
                      ServHeader."Max. Labor Unit Price"));
                HideResUnitPriceMessage := TRUE;
              END ELSE
                "Unit Price" := ResPrice."Unit Price";
            END;
          Type::Cost:
            BEGIN
              ServCost.GET("No.");

              ConvertPriceToVAT(FALSE,'','',ServCost."Default Unit Price");
              ConvertPriceLCYToFCY('',ServCost."Default Unit Price");
              "Unit Price" := ServCost."Default Unit Price";
            END;
        END;
        OnAfterFindServLinePrice(ServLine,ServHeader,TempSalesPrice,ResPrice,ServCost,CalledByFieldNo);
      END;
    END;

    [External]
    PROCEDURE FindSalesLineLineDisc@14(SalesHeader@1001 : Record 36;VAR SalesLine@1000 : Record 37);
    BEGIN
      WITH SalesLine DO BEGIN
        SetCurrency(SalesHeader."Currency Code",0,0D);
        SetUoM(ABS(Quantity),"Qty. per Unit of Measure");

        TESTFIELD("Qty. per Unit of Measure");

        IF Type = Type::Item THEN BEGIN
          SalesLineLineDiscExists(SalesHeader,SalesLine,FALSE);
          CalcBestLineDisc(TempSalesLineDisc);

          "Line Discount %" := TempSalesLineDisc."Line Discount %";
        END;
        OnAfterFindSalesLineLineDisc(SalesLine,SalesHeader,TempSalesLineDisc);
      END;
    END;

    [External]
    PROCEDURE FindServLineDisc@24(ServHeader@1001 : Record 5900;VAR ServLine@1000 : Record 5902);
    BEGIN
      WITH ServLine DO BEGIN
        SetCurrency(ServHeader."Currency Code",0,0D);
        SetUoM(ABS(Quantity),"Qty. per Unit of Measure");

        TESTFIELD("Qty. per Unit of Measure");

        IF Type = Type::Item THEN BEGIN
          Item.GET("No.");
          FindSalesLineDisc(
            TempSalesLineDisc,"Bill-to Customer No.",ServHeader."Contact No.",
            "Customer Disc. Group",'',"No.",Item."Item Disc. Group","Variant Code",
            "Unit of Measure Code",ServHeader."Currency Code",ServHeader."Order Date",FALSE);
          CalcBestLineDisc(TempSalesLineDisc);
          "Line Discount %" := TempSalesLineDisc."Line Discount %";
        END;
        IF Type IN [Type::Resource,Type::Cost,Type::"G/L Account"] THEN BEGIN
          "Line Discount %" := 0;
          "Line Discount Amount" :=
            ROUND(
              ROUND(CalcChargeableQty * "Unit Price",Currency."Amount Rounding Precision") *
              "Line Discount %" / 100,Currency."Amount Rounding Precision");
          "Inv. Discount Amount" := 0;
          "Inv. Disc. Amount to Invoice" := 0;
        END;
        OnAfterFindServLineDisc(ServLine,ServHeader,TempSalesLineDisc);
      END;
    END;

    [External]
    PROCEDURE FindStdItemJnlLinePrice@36(VAR StdItemJnlLine@1000 : Record 753;CalledByFieldNo@1001 : Integer);
    BEGIN
      WITH StdItemJnlLine DO BEGIN
        SetCurrency('',0,0D);
        SetVAT(FALSE,0,0,'');
        SetUoM(ABS(Quantity),"Qty. per Unit of Measure");
        TESTFIELD("Qty. per Unit of Measure");
        Item.GET("Item No.");

        FindSalesPrice(
          TempSalesPrice,'','','','',"Item No.","Variant Code",
          "Unit of Measure Code",'',WORKDATE,FALSE);
        CalcBestUnitPrice(TempSalesPrice);
        IF FoundSalesPrice OR
           NOT ((CalledByFieldNo = FIELDNO(Quantity)) OR
                (CalledByFieldNo = FIELDNO("Variant Code")))
        THEN
          VALIDATE("Unit Amount",TempSalesPrice."Unit Price");
        OnAfterFindStdItemJnlLinePrice(StdItemJnlLine,TempSalesPrice,CalledByFieldNo);
      END;
    END;

    [External]
    PROCEDURE FindAnalysisReportPrice@30(ItemNo@1000 : Code[20];Date@1001 : Date) : Decimal;
    BEGIN
      SetCurrency('',0,0D);
      SetVAT(FALSE,0,0,'');
      SetUoM(0,1);
      Item.GET(ItemNo);

      FindSalesPrice(TempSalesPrice,'','','','',ItemNo,'','','',Date,FALSE);
      CalcBestUnitPrice(TempSalesPrice);
      IF FoundSalesPrice THEN
        EXIT(TempSalesPrice."Unit Price");
      EXIT(Item."Unit Price");
    END;

    LOCAL PROCEDURE CalcBestUnitPrice@1(VAR SalesPrice@1000 : Record 7002);
    VAR
      BestSalesPrice@1002 : Record 7002;
      BestSalesPriceFound@1001 : Boolean;
    BEGIN
      WITH SalesPrice DO BEGIN
        FoundSalesPrice := FINDSET;
        IF FoundSalesPrice THEN
          REPEAT
            IF IsInMinQty("Unit of Measure Code","Minimum Quantity") THEN BEGIN
              ConvertPriceToVAT(
                "Price Includes VAT",Item."VAT Prod. Posting Group",
                "VAT Bus. Posting Gr. (Price)","Unit Price");
              ConvertPriceToUoM("Unit of Measure Code","Unit Price");
              ConvertPriceLCYToFCY("Currency Code","Unit Price");

              CASE TRUE OF
                ((BestSalesPrice."Currency Code" = '') AND ("Currency Code" <> '')) OR
                ((BestSalesPrice."Variant Code" = '') AND ("Variant Code" <> '')):
                  BEGIN
                    BestSalesPrice := SalesPrice;
                    BestSalesPriceFound := TRUE;
                  END;
                ((BestSalesPrice."Currency Code" = '') OR ("Currency Code" <> '')) AND
                ((BestSalesPrice."Variant Code" = '') OR ("Variant Code" <> '')):
                  IF (BestSalesPrice."Unit Price" = 0) OR
                     (CalcLineAmount(BestSalesPrice) > CalcLineAmount(SalesPrice))
                  THEN BEGIN
                    BestSalesPrice := SalesPrice;
                    BestSalesPriceFound := TRUE;
                  END;
              END;
            END;
          UNTIL NEXT = 0;
      END;

      // No price found in agreement
      IF NOT BestSalesPriceFound THEN BEGIN
        ConvertPriceToVAT(
          Item."Price Includes VAT",Item."VAT Prod. Posting Group",
          Item."VAT Bus. Posting Gr. (Price)",Item."Unit Price");
        ConvertPriceToUoM('',Item."Unit Price");
        ConvertPriceLCYToFCY('',Item."Unit Price");

        CLEAR(BestSalesPrice);
        BestSalesPrice."Unit Price" := Item."Unit Price";
        BestSalesPrice."Allow Line Disc." := AllowLineDisc;
        BestSalesPrice."Allow Invoice Disc." := AllowInvDisc;
      END;
      SalesPrice := BestSalesPrice;
    END;

    LOCAL PROCEDURE CalcBestLineDisc@11(VAR SalesLineDisc@1000 : Record 7004);
    VAR
      BestSalesLineDisc@1002 : Record 7004;
    BEGIN
      WITH SalesLineDisc DO BEGIN
        IF FINDSET THEN
          REPEAT
            IF IsInMinQty("Unit of Measure Code","Minimum Quantity") THEN
              CASE TRUE OF
                ((BestSalesLineDisc."Currency Code" = '') AND ("Currency Code" <> '')) OR
                ((BestSalesLineDisc."Variant Code" = '') AND ("Variant Code" <> '')):
                  BestSalesLineDisc := SalesLineDisc;
                ((BestSalesLineDisc."Currency Code" = '') OR ("Currency Code" <> '')) AND
                ((BestSalesLineDisc."Variant Code" = '') OR ("Variant Code" <> '')):
                  IF BestSalesLineDisc."Line Discount %" < "Line Discount %" THEN
                    BestSalesLineDisc := SalesLineDisc;
              END;
          UNTIL NEXT = 0;
      END;

      SalesLineDisc := BestSalesLineDisc;
    END;

    [External]
    PROCEDURE FindSalesPrice@16(VAR ToSalesPrice@1003 : Record 7002;CustNo@1000 : Code[20];ContNo@1006 : Code[20];CustPriceGrCode@1001 : Code[10];CampaignNo@1007 : Code[20];ItemNo@1012 : Code[20];VariantCode@1011 : Code[10];UOM@1010 : Code[10];CurrencyCode@1009 : Code[10];StartingDate@1008 : Date;ShowAll@1004 : Boolean);
    VAR
      FromSalesPrice@1002 : Record 7002;
      TempTargetCampaignGr@1005 : TEMPORARY Record 7030;
    BEGIN
      WITH FromSalesPrice DO BEGIN
        SETRANGE("Item No.",ItemNo);
        SETFILTER("Variant Code",'%1|%2',VariantCode,'');
        SETFILTER("Ending Date",'%1|>=%2',0D,StartingDate);
        IF NOT ShowAll THEN BEGIN
          SETFILTER("Currency Code",'%1|%2',CurrencyCode,'');
          IF UOM <> '' THEN
            SETFILTER("Unit of Measure Code",'%1|%2',UOM,'');
          SETRANGE("Starting Date",0D,StartingDate);
        END;

        ToSalesPrice.RESET;
        ToSalesPrice.DELETEALL;

        SETRANGE("Sales Type","Sales Type"::"All Customers");
        SETRANGE("Sales Code");
        CopySalesPriceToSalesPrice(FromSalesPrice,ToSalesPrice);

        IF CustNo <> '' THEN BEGIN
          SETRANGE("Sales Type","Sales Type"::Customer);
          SETRANGE("Sales Code",CustNo);
          CopySalesPriceToSalesPrice(FromSalesPrice,ToSalesPrice);
        END;

        IF CustPriceGrCode <> '' THEN BEGIN
          SETRANGE("Sales Type","Sales Type"::"Customer Price Group");
          SETRANGE("Sales Code",CustPriceGrCode);
          CopySalesPriceToSalesPrice(FromSalesPrice,ToSalesPrice);
        END;

        IF NOT ((CustNo = '') AND (ContNo = '') AND (CampaignNo = '')) THEN BEGIN
          SETRANGE("Sales Type","Sales Type"::Campaign);
          IF ActivatedCampaignExists(TempTargetCampaignGr,CustNo,ContNo,CampaignNo) THEN
            REPEAT
              SETRANGE("Sales Code",TempTargetCampaignGr."Campaign No.");
              CopySalesPriceToSalesPrice(FromSalesPrice,ToSalesPrice);
            UNTIL TempTargetCampaignGr.NEXT = 0;
        END;
      END;
    END;

    [External]
    PROCEDURE FindSalesLineDisc@12(VAR ToSalesLineDisc@1006 : Record 7004;CustNo@1003 : Code[20];ContNo@1001 : Code[20];CustDiscGrCode@1002 : Code[20];CampaignNo@1010 : Code[20];ItemNo@1004 : Code[20];ItemDiscGrCode@1005 : Code[20];VariantCode@1014 : Code[10];UOM@1013 : Code[10];CurrencyCode@1012 : Code[10];StartingDate@1011 : Date;ShowAll@1000 : Boolean);
    VAR
      FromSalesLineDisc@1007 : Record 7004;
      TempCampaignTargetGr@1009 : TEMPORARY Record 7030;
      InclCampaigns@1008 : Boolean;
    BEGIN
      WITH FromSalesLineDisc DO BEGIN
        SETFILTER("Ending Date",'%1|>=%2',0D,StartingDate);
        SETFILTER("Variant Code",'%1|%2',VariantCode,'');
        IF NOT ShowAll THEN BEGIN
          SETRANGE("Starting Date",0D,StartingDate);
          SETFILTER("Currency Code",'%1|%2',CurrencyCode,'');
          IF UOM <> '' THEN
            SETFILTER("Unit of Measure Code",'%1|%2',UOM,'');
        END;

        ToSalesLineDisc.RESET;
        ToSalesLineDisc.DELETEALL;
        FOR "Sales Type" := "Sales Type"::Customer TO "Sales Type"::Campaign DO
          IF ("Sales Type" = "Sales Type"::"All Customers") OR
             (("Sales Type" = "Sales Type"::Customer) AND (CustNo <> '')) OR
             (("Sales Type" = "Sales Type"::"Customer Disc. Group") AND (CustDiscGrCode <> '')) OR
             (("Sales Type" = "Sales Type"::Campaign) AND
              NOT ((CustNo = '') AND (ContNo = '') AND (CampaignNo = '')))
          THEN BEGIN
            InclCampaigns := FALSE;

            SETRANGE("Sales Type","Sales Type");
            CASE "Sales Type" OF
              "Sales Type"::"All Customers":
                SETRANGE("Sales Code");
              "Sales Type"::Customer:
                SETRANGE("Sales Code",CustNo);
              "Sales Type"::"Customer Disc. Group":
                SETRANGE("Sales Code",CustDiscGrCode);
              "Sales Type"::Campaign:
                BEGIN
                  InclCampaigns := ActivatedCampaignExists(TempCampaignTargetGr,CustNo,ContNo,CampaignNo);
                  SETRANGE("Sales Code",TempCampaignTargetGr."Campaign No.");
                END;
            END;

            REPEAT
              SETRANGE(Type,Type::Item);
              SETRANGE(Code,ItemNo);
              CopySalesDiscToSalesDisc(FromSalesLineDisc,ToSalesLineDisc);

              IF ItemDiscGrCode <> '' THEN BEGIN
                SETRANGE(Type,Type::"Item Disc. Group");
                SETRANGE(Code,ItemDiscGrCode);
                CopySalesDiscToSalesDisc(FromSalesLineDisc,ToSalesLineDisc);
              END;

              IF InclCampaigns THEN BEGIN
                InclCampaigns := TempCampaignTargetGr.NEXT <> 0;
                SETRANGE("Sales Code",TempCampaignTargetGr."Campaign No.");
              END;
            UNTIL NOT InclCampaigns;
          END;
      END;
    END;

    [External]
    PROCEDURE CopySalesPrice@32(VAR SalesPrice@1000 : Record 7002);
    BEGIN
      SalesPrice.DELETEALL;
      CopySalesPriceToSalesPrice(TempSalesPrice,SalesPrice);
    END;

    LOCAL PROCEDURE CopySalesPriceToSalesPrice@13(VAR FromSalesPrice@1000 : Record 7002;VAR ToSalesPrice@1001 : Record 7002);
    BEGIN
      WITH ToSalesPrice DO BEGIN
        IF FromSalesPrice.FINDSET THEN
          REPEAT
            ToSalesPrice := FromSalesPrice;
            INSERT;
          UNTIL FromSalesPrice.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE CopySalesDiscToSalesDisc@17(VAR FromSalesLineDisc@1000 : Record 7004;VAR ToSalesLineDisc@1001 : Record 7004);
    BEGIN
      WITH ToSalesLineDisc DO BEGIN
        IF FromSalesLineDisc.FINDSET THEN
          REPEAT
            ToSalesLineDisc := FromSalesLineDisc;
            INSERT;
          UNTIL FromSalesLineDisc.NEXT = 0;
      END;
    END;

    [External]
    PROCEDURE SetResPrice@28(Code2@1006 : Code[20];WorkTypeCode@1005 : Code[10];CurrencyCode@1003 : Code[10]);
    BEGIN
      WITH ResPrice DO BEGIN
        INIT;
        Code := Code2;
        "Work Type Code" := WorkTypeCode;
        "Currency Code" := CurrencyCode;
      END;
    END;

    LOCAL PROCEDURE SetCurrency@18(CurrencyCode2@1003 : Code[10];CurrencyFactor2@1001 : Decimal;ExchRateDate2@1002 : Date);
    BEGIN
      PricesInCurrency := CurrencyCode2 <> '';
      IF PricesInCurrency THEN BEGIN
        Currency.GET(CurrencyCode2);
        Currency.TESTFIELD("Unit-Amount Rounding Precision");
        CurrencyFactor := CurrencyFactor2;
        ExchRateDate := ExchRateDate2;
      END ELSE
        GLSetup.GET;
    END;

    LOCAL PROCEDURE SetVAT@22(PriceInclVAT2@1003 : Boolean;VATPerCent2@1002 : Decimal;VATCalcType2@1001 : Option;VATBusPostingGr2@1000 : Code[20]);
    BEGIN
      PricesInclVAT := PriceInclVAT2;
      VATPerCent := VATPerCent2;
      VATCalcType := VATCalcType2;
      VATBusPostingGr := VATBusPostingGr2;
    END;

    LOCAL PROCEDURE SetUoM@23(Qty2@1000 : Decimal;QtyPerUoM2@1001 : Decimal);
    BEGIN
      Qty := Qty2;
      QtyPerUOM := QtyPerUoM2;
    END;

    LOCAL PROCEDURE SetLineDisc@29(LineDiscPerCent2@1000 : Decimal;AllowLineDisc2@1001 : Boolean;AllowInvDisc2@1002 : Boolean);
    BEGIN
      LineDiscPerCent := LineDiscPerCent2;
      AllowLineDisc := AllowLineDisc2;
      AllowInvDisc := AllowInvDisc2;
    END;

    LOCAL PROCEDURE IsInMinQty@7(UnitofMeasureCode@1003 : Code[10];MinQty@1000 : Decimal) : Boolean;
    BEGIN
      IF UnitofMeasureCode = '' THEN
        EXIT(MinQty <= QtyPerUOM * Qty);
      EXIT(MinQty <= Qty);
    END;

    LOCAL PROCEDURE ConvertPriceToVAT@4(FromPricesInclVAT@1006 : Boolean;FromVATProdPostingGr@1000 : Code[20];FromVATBusPostingGr@1002 : Code[20];VAR UnitPrice@1004 : Decimal);
    VAR
      VATPostingSetup@1007 : Record 325;
    BEGIN
      IF FromPricesInclVAT THEN BEGIN
        VATPostingSetup.GET(FromVATBusPostingGr,FromVATProdPostingGr);

        CASE VATPostingSetup."VAT Calculation Type" OF
          VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT":
            VATPostingSetup."VAT %" := 0;
          VATPostingSetup."VAT Calculation Type"::"Sales Tax":
            ERROR(
              Text010,
              VATPostingSetup.FIELDCAPTION("VAT Calculation Type"),
              VATPostingSetup."VAT Calculation Type");
        END;

        CASE VATCalcType OF
          VATCalcType::"Normal VAT",
          VATCalcType::"Full VAT",
          VATCalcType::"Sales Tax":
            BEGIN
              IF PricesInclVAT THEN BEGIN
                IF VATBusPostingGr <> FromVATBusPostingGr THEN
                  UnitPrice := UnitPrice * (100 + VATPerCent) / (100 + VATPostingSetup."VAT %");
              END ELSE
                UnitPrice := UnitPrice / (1 + VATPostingSetup."VAT %" / 100);
            END;
          VATCalcType::"Reverse Charge VAT":
            UnitPrice := UnitPrice / (1 + VATPostingSetup."VAT %" / 100);
        END;
      END ELSE
        IF PricesInclVAT THEN
          UnitPrice := UnitPrice * (1 + VATPerCent / 100);
    END;

    LOCAL PROCEDURE ConvertPriceToUoM@5(UnitOfMeasureCode@1002 : Code[10];VAR UnitPrice@1001 : Decimal);
    BEGIN
      IF UnitOfMeasureCode = '' THEN
        UnitPrice := UnitPrice * QtyPerUOM;
    END;

    LOCAL PROCEDURE ConvertPriceLCYToFCY@6(CurrencyCode@1005 : Code[10];VAR UnitPrice@1001 : Decimal);
    VAR
      CurrExchRate@1000 : Record 330;
    BEGIN
      IF PricesInCurrency THEN BEGIN
        IF CurrencyCode = '' THEN
          UnitPrice :=
            CurrExchRate.ExchangeAmtLCYToFCY(ExchRateDate,Currency.Code,UnitPrice,CurrencyFactor);
        UnitPrice := ROUND(UnitPrice,Currency."Unit-Amount Rounding Precision");
      END ELSE
        UnitPrice := ROUND(UnitPrice,GLSetup."Unit-Amount Rounding Precision");
    END;

    LOCAL PROCEDURE CalcLineAmount@15(SalesPrice@1000 : Record 7002) : Decimal;
    BEGIN
      WITH SalesPrice DO BEGIN
        IF "Allow Line Disc." THEN
          EXIT("Unit Price" * (1 - LineDiscPerCent / 100));
        EXIT("Unit Price");
      END;
    END;

    [External]
    PROCEDURE GetSalesLinePrice@19(SalesHeader@1000 : Record 36;VAR SalesLine@1001 : Record 37);
    BEGIN
      SalesLinePriceExists(SalesHeader,SalesLine,TRUE);

      WITH SalesLine DO
        IF PAGE.RUNMODAL(PAGE::"Get Sales Price",TempSalesPrice) = ACTION::LookupOK THEN BEGIN
          SetVAT(
            SalesHeader."Prices Including VAT","VAT %","VAT Calculation Type","VAT Bus. Posting Group");
          SetUoM(ABS(Quantity),"Qty. per Unit of Measure");
          SetCurrency(
            SalesHeader."Currency Code",SalesHeader."Currency Factor",SalesHeaderExchDate(SalesHeader));

          IF NOT IsInMinQty(TempSalesPrice."Unit of Measure Code",TempSalesPrice."Minimum Quantity") THEN
            ERROR(
              Text000,
              FIELDCAPTION(Quantity),
              TempSalesPrice.FIELDCAPTION("Minimum Quantity"),
              TempSalesPrice.TABLECAPTION);
          IF NOT (TempSalesPrice."Currency Code" IN ["Currency Code",'']) THEN
            ERROR(
              Text001,
              FIELDCAPTION("Currency Code"),
              TABLECAPTION,
              TempSalesPrice.TABLECAPTION);
          IF NOT (TempSalesPrice."Unit of Measure Code" IN ["Unit of Measure Code",'']) THEN
            ERROR(
              Text001,
              FIELDCAPTION("Unit of Measure Code"),
              TABLECAPTION,
              TempSalesPrice.TABLECAPTION);
          IF TempSalesPrice."Starting Date" > SalesHeaderStartDate(SalesHeader,DateCaption) THEN
            ERROR(
              Text000,
              DateCaption,
              TempSalesPrice.FIELDCAPTION("Starting Date"),
              TempSalesPrice.TABLECAPTION);

          ConvertPriceToVAT(
            TempSalesPrice."Price Includes VAT",Item."VAT Prod. Posting Group",
            TempSalesPrice."VAT Bus. Posting Gr. (Price)",TempSalesPrice."Unit Price");
          ConvertPriceToUoM(TempSalesPrice."Unit of Measure Code",TempSalesPrice."Unit Price");
          ConvertPriceLCYToFCY(TempSalesPrice."Currency Code",TempSalesPrice."Unit Price");

          "Allow Invoice Disc." := TempSalesPrice."Allow Invoice Disc.";
          "Allow Line Disc." := TempSalesPrice."Allow Line Disc.";
          IF NOT "Allow Line Disc." THEN
            "Line Discount %" := 0;

          VALIDATE("Unit Price",TempSalesPrice."Unit Price");
        END;
    END;

    [External]
    PROCEDURE GetSalesLineLineDisc@20(SalesHeader@1000 : Record 36;VAR SalesLine@1001 : Record 37);
    BEGIN
      SalesLineLineDiscExists(SalesHeader,SalesLine,TRUE);

      WITH SalesLine DO
        IF PAGE.RUNMODAL(PAGE::"Get Sales Line Disc.",TempSalesLineDisc) = ACTION::LookupOK THEN
          BEGIN
          SetCurrency(SalesHeader."Currency Code",0,0D);
          SetUoM(ABS(Quantity),"Qty. per Unit of Measure");

          IF NOT IsInMinQty(TempSalesLineDisc."Unit of Measure Code",TempSalesLineDisc."Minimum Quantity")
          THEN
            ERROR(
              Text000,FIELDCAPTION(Quantity),
              TempSalesLineDisc.FIELDCAPTION("Minimum Quantity"),
              TempSalesLineDisc.TABLECAPTION);
          IF NOT (TempSalesLineDisc."Currency Code" IN ["Currency Code",'']) THEN
            ERROR(
              Text001,
              FIELDCAPTION("Currency Code"),
              TABLECAPTION,
              TempSalesLineDisc.TABLECAPTION);
          IF NOT (TempSalesLineDisc."Unit of Measure Code" IN ["Unit of Measure Code",'']) THEN
            ERROR(
              Text001,
              FIELDCAPTION("Unit of Measure Code"),
              TABLECAPTION,
              TempSalesLineDisc.TABLECAPTION);
          IF TempSalesLineDisc."Starting Date" > SalesHeaderStartDate(SalesHeader,DateCaption) THEN
            ERROR(
              Text000,
              DateCaption,
              TempSalesLineDisc.FIELDCAPTION("Starting Date"),
              TempSalesLineDisc.TABLECAPTION);

          TESTFIELD("Allow Line Disc.");
          VALIDATE("Line Discount %",TempSalesLineDisc."Line Discount %");
        END;
    END;

    [External]
    PROCEDURE SalesLinePriceExists@45(SalesHeader@1001 : Record 36;VAR SalesLine@1000 : Record 37;ShowAll@1002 : Boolean) : Boolean;
    BEGIN
      WITH SalesLine DO
        IF (Type = Type::Item) AND Item.GET("No.") THEN BEGIN
          FindSalesPrice(
            TempSalesPrice,GetCustNoForSalesHeader(SalesHeader),SalesHeader."Bill-to Contact No.",
            "Customer Price Group",'',"No.","Variant Code","Unit of Measure Code",
            SalesHeader."Currency Code",SalesHeaderStartDate(SalesHeader,DateCaption),ShowAll);
          EXIT(TempSalesPrice.FINDFIRST);
        END;
      EXIT(FALSE);
    END;

    [External]
    PROCEDURE SalesLineLineDiscExists@44(SalesHeader@1001 : Record 36;VAR SalesLine@1000 : Record 37;ShowAll@1002 : Boolean) : Boolean;
    BEGIN
      WITH SalesLine DO
        IF (Type = Type::Item) AND Item.GET("No.") THEN BEGIN
          FindSalesLineDisc(
            TempSalesLineDisc,GetCustNoForSalesHeader(SalesHeader),SalesHeader."Bill-to Contact No.",
            "Customer Disc. Group",'',"No.",Item."Item Disc. Group","Variant Code","Unit of Measure Code",
            SalesHeader."Currency Code",SalesHeaderStartDate(SalesHeader,DateCaption),ShowAll);
          EXIT(TempSalesLineDisc.FINDFIRST);
        END;
      EXIT(FALSE);
    END;

    [External]
    PROCEDURE GetServLinePrice@34(ServHeader@1000 : Record 5900;VAR ServLine@1001 : Record 5902);
    BEGIN
      ServLinePriceExists(ServHeader,ServLine,TRUE);

      WITH ServLine DO
        IF PAGE.RUNMODAL(PAGE::"Get Sales Price",TempSalesPrice) = ACTION::LookupOK THEN BEGIN
          SetVAT(
            ServHeader."Prices Including VAT","VAT %","VAT Calculation Type","VAT Bus. Posting Group");
          SetUoM(ABS(Quantity),"Qty. per Unit of Measure");
          SetCurrency(
            ServHeader."Currency Code",ServHeader."Currency Factor",ServHeaderExchDate(ServHeader));

          IF NOT IsInMinQty(TempSalesPrice."Unit of Measure Code",TempSalesPrice."Minimum Quantity") THEN
            ERROR(
              Text000,
              FIELDCAPTION(Quantity),
              TempSalesPrice.FIELDCAPTION("Minimum Quantity"),
              TempSalesPrice.TABLECAPTION);
          IF NOT (TempSalesPrice."Currency Code" IN ["Currency Code",'']) THEN
            ERROR(
              Text001,
              FIELDCAPTION("Currency Code"),
              TABLECAPTION,
              TempSalesPrice.TABLECAPTION);
          IF NOT (TempSalesPrice."Unit of Measure Code" IN ["Unit of Measure Code",'']) THEN
            ERROR(
              Text001,
              FIELDCAPTION("Unit of Measure Code"),
              TABLECAPTION,
              TempSalesPrice.TABLECAPTION);
          IF TempSalesPrice."Starting Date" > ServHeaderStartDate(ServHeader,DateCaption) THEN
            ERROR(
              Text000,
              DateCaption,
              TempSalesPrice.FIELDCAPTION("Starting Date"),
              TempSalesPrice.TABLECAPTION);

          ConvertPriceToVAT(
            TempSalesPrice."Price Includes VAT",Item."VAT Prod. Posting Group",
            TempSalesPrice."VAT Bus. Posting Gr. (Price)",TempSalesPrice."Unit Price");
          ConvertPriceToUoM(TempSalesPrice."Unit of Measure Code",TempSalesPrice."Unit Price");
          ConvertPriceLCYToFCY(TempSalesPrice."Currency Code",TempSalesPrice."Unit Price");

          "Allow Invoice Disc." := TempSalesPrice."Allow Invoice Disc.";
          "Allow Line Disc." := TempSalesPrice."Allow Line Disc.";
          IF NOT "Allow Line Disc." THEN
            "Line Discount %" := 0;

          VALIDATE("Unit Price",TempSalesPrice."Unit Price");
          ConfirmAdjPriceLineChange;
        END;
    END;

    [External]
    PROCEDURE GetServLineLineDisc@33(ServHeader@1000 : Record 5900;VAR ServLine@1001 : Record 5902);
    BEGIN
      ServLineLineDiscExists(ServHeader,ServLine,TRUE);

      WITH ServLine DO
        IF PAGE.RUNMODAL(PAGE::"Get Sales Line Disc.",TempSalesLineDisc) = ACTION::LookupOK THEN BEGIN
          SetCurrency(ServHeader."Currency Code",0,0D);
          SetUoM(ABS(Quantity),"Qty. per Unit of Measure");

          IF NOT IsInMinQty(TempSalesLineDisc."Unit of Measure Code",TempSalesLineDisc."Minimum Quantity")
          THEN
            ERROR(
              Text000,FIELDCAPTION(Quantity),
              TempSalesLineDisc.FIELDCAPTION("Minimum Quantity"),
              TempSalesLineDisc.TABLECAPTION);
          IF NOT (TempSalesLineDisc."Currency Code" IN ["Currency Code",'']) THEN
            ERROR(
              Text001,
              FIELDCAPTION("Currency Code"),
              TABLECAPTION,
              TempSalesLineDisc.TABLECAPTION);
          IF NOT (TempSalesLineDisc."Unit of Measure Code" IN ["Unit of Measure Code",'']) THEN
            ERROR(
              Text001,
              FIELDCAPTION("Unit of Measure Code"),
              TABLECAPTION,
              TempSalesLineDisc.TABLECAPTION);
          IF TempSalesLineDisc."Starting Date" > ServHeaderStartDate(ServHeader,DateCaption) THEN
            ERROR(
              Text000,
              DateCaption,
              TempSalesLineDisc.FIELDCAPTION("Starting Date"),
              TempSalesLineDisc.TABLECAPTION);

          TESTFIELD("Allow Line Disc.");
          CheckLineDiscount(TempSalesLineDisc."Line Discount %");
          VALIDATE("Line Discount %",TempSalesLineDisc."Line Discount %");
          ConfirmAdjPriceLineChange;
        END;
    END;

    LOCAL PROCEDURE GetCustNoForSalesHeader@52(SalesHeader@1000 : Record 36) : Code[20];
    VAR
      CustNo@1001 : Code[20];
    BEGIN
      CustNo := SalesHeader."Sell-to Customer No.";
      OnGetCustNoForSalesHeader(SalesHeader,CustNo);
      EXIT(CustNo);
    END;

    LOCAL PROCEDURE ServLinePriceExists@37(ServHeader@1001 : Record 5900;VAR ServLine@1000 : Record 5902;ShowAll@1002 : Boolean) : Boolean;
    BEGIN
      WITH ServLine DO
        IF (Type = Type::Item) AND Item.GET("No.") THEN BEGIN
          FindSalesPrice(
            TempSalesPrice,"Bill-to Customer No.",ServHeader."Bill-to Contact No.",
            "Customer Price Group",'',"No.","Variant Code","Unit of Measure Code",
            ServHeader."Currency Code",ServHeaderStartDate(ServHeader,DateCaption),ShowAll);
          EXIT(TempSalesPrice.FIND('-'));
        END;
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE ServLineLineDiscExists@35(ServHeader@1001 : Record 5900;VAR ServLine@1000 : Record 5902;ShowAll@1002 : Boolean) : Boolean;
    BEGIN
      WITH ServLine DO
        IF (Type = Type::Item) AND Item.GET("No.") THEN BEGIN
          FindSalesLineDisc(
            TempSalesLineDisc,"Bill-to Customer No.",ServHeader."Bill-to Contact No.",
            "Customer Disc. Group",'',"No.",Item."Item Disc. Group","Variant Code","Unit of Measure Code",
            ServHeader."Currency Code",ServHeaderStartDate(ServHeader,DateCaption),ShowAll);
          EXIT(TempSalesLineDisc.FIND('-'));
        END;
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE ActivatedCampaignExists@21(VAR ToCampaignTargetGr@1001 : Record 7030;CustNo@1000 : Code[20];ContNo@1002 : Code[20];CampaignNo@1004 : Code[20]) : Boolean;
    VAR
      FromCampaignTargetGr@1003 : Record 7030;
      Cont@1005 : Record 5050;
    BEGIN
      WITH FromCampaignTargetGr DO BEGIN
        ToCampaignTargetGr.RESET;
        ToCampaignTargetGr.DELETEALL;

        IF CampaignNo <> '' THEN BEGIN
          ToCampaignTargetGr."Campaign No." := CampaignNo;
          ToCampaignTargetGr.INSERT;
        END ELSE BEGIN
          SETRANGE(Type,Type::Customer);
          SETRANGE("No.",CustNo);
          IF FINDSET THEN
            REPEAT
              ToCampaignTargetGr := FromCampaignTargetGr;
              ToCampaignTargetGr.INSERT;
            UNTIL NEXT = 0
          ELSE BEGIN
            IF Cont.GET(ContNo) THEN BEGIN
              SETRANGE(Type,Type::Contact);
              SETRANGE("No.",Cont."Company No.");
              IF FINDSET THEN
                REPEAT
                  ToCampaignTargetGr := FromCampaignTargetGr;
                  ToCampaignTargetGr.INSERT;
                UNTIL NEXT = 0;
            END;
          END;
        END;
        EXIT(ToCampaignTargetGr.FINDFIRST);
      END;
    END;

    LOCAL PROCEDURE SalesHeaderExchDate@25(SalesHeader@1000 : Record 36) : Date;
    BEGIN
      WITH SalesHeader DO BEGIN
        IF "Posting Date" <> 0D THEN
          EXIT("Posting Date");
        EXIT(WORKDATE);
      END;
    END;

    LOCAL PROCEDURE SalesHeaderStartDate@31(SalesHeader@1000 : Record 36;VAR DateCaption@1001 : Text[30]) : Date;
    BEGIN
      WITH SalesHeader DO
        IF "Document Type" IN ["Document Type"::Invoice,"Document Type"::"Credit Memo"] THEN BEGIN
          DateCaption := FIELDCAPTION("Posting Date");
          EXIT("Posting Date")
        END ELSE BEGIN
          DateCaption := FIELDCAPTION("Order Date");
          EXIT("Order Date");
        END;
    END;

    LOCAL PROCEDURE ServHeaderExchDate@65(ServHeader@1000 : Record 5900) : Date;
    BEGIN
      WITH ServHeader DO BEGIN
        IF ("Document Type" = "Document Type"::Quote) AND
           ("Posting Date" = 0D)
        THEN
          EXIT(WORKDATE);
        EXIT("Posting Date");
      END;
    END;

    LOCAL PROCEDURE ServHeaderStartDate@66(ServHeader@1000 : Record 5900;VAR DateCaption@1001 : Text[30]) : Date;
    BEGIN
      WITH ServHeader DO
        IF "Document Type" IN ["Document Type"::Invoice,"Document Type"::"Credit Memo"] THEN BEGIN
          DateCaption := FIELDCAPTION("Posting Date");
          EXIT("Posting Date")
        END ELSE BEGIN
          DateCaption := FIELDCAPTION("Order Date");
          EXIT("Order Date");
        END;
    END;

    [External]
    PROCEDURE NoOfSalesLinePrice@27(SalesHeader@1001 : Record 36;VAR SalesLine@1000 : Record 37;ShowAll@1002 : Boolean) : Integer;
    BEGIN
      IF SalesLinePriceExists(SalesHeader,SalesLine,ShowAll) THEN
        EXIT(TempSalesPrice.COUNT);
    END;

    [External]
    PROCEDURE NoOfSalesLineLineDisc@26(SalesHeader@1001 : Record 36;VAR SalesLine@1000 : Record 37;ShowAll@1002 : Boolean) : Integer;
    BEGIN
      IF SalesLineLineDiscExists(SalesHeader,SalesLine,ShowAll) THEN
        EXIT(TempSalesLineDisc.COUNT);
    END;

    [External]
    PROCEDURE NoOfServLinePrice@41(ServHeader@1001 : Record 5900;VAR ServLine@1000 : Record 5902;ShowAll@1002 : Boolean) : Integer;
    BEGIN
      IF ServLinePriceExists(ServHeader,ServLine,ShowAll) THEN
        EXIT(TempSalesPrice.COUNT);
    END;

    [External]
    PROCEDURE NoOfServLineLineDisc@40(ServHeader@1001 : Record 5900;VAR ServLine@1000 : Record 5902;ShowAll@1002 : Boolean) : Integer;
    BEGIN
      IF ServLineLineDiscExists(ServHeader,ServLine,ShowAll) THEN
        EXIT(TempSalesLineDisc.COUNT);
    END;

    [External]
    PROCEDURE FindJobPlanningLinePrice@61(VAR JobPlanningLine@1000 : Record 1003;CalledByFieldNo@1001 : Integer);
    VAR
      Job@1002 : Record 167;
    BEGIN
      WITH JobPlanningLine DO BEGIN
        SetCurrency("Currency Code","Currency Factor","Planning Date");
        SetVAT(FALSE,0,0,'');
        SetUoM(ABS(Quantity),"Qty. per Unit of Measure");
        SetLineDisc(0,TRUE,TRUE);

        CASE Type OF
          Type::Item:
            BEGIN
              Job.GET("Job No.");
              Item.GET("No.");
              TESTFIELD("Qty. per Unit of Measure");
              FindSalesPrice(
                TempSalesPrice,Job."Bill-to Customer No.",Job."Bill-to Contact No.",
                Job."Customer Price Group",'',"No.","Variant Code","Unit of Measure Code",
                Job."Currency Code","Planning Date",FALSE);
              CalcBestUnitPrice(TempSalesPrice);
              IF FoundSalesPrice OR
                 NOT ((CalledByFieldNo = FIELDNO(Quantity)) OR
                      (CalledByFieldNo = FIELDNO("Location Code")) OR
                      (CalledByFieldNo = FIELDNO("Variant Code")))
              THEN BEGIN
                "Unit Price" := TempSalesPrice."Unit Price";
                AllowLineDisc := TempSalesPrice."Allow Line Disc.";
              END;
            END;
          Type::Resource:
            BEGIN
              Job.GET("Job No.");
              SetResPrice("No.","Work Type Code","Currency Code");
              CODEUNIT.RUN(CODEUNIT::"Resource-Find Price",ResPrice);
              ConvertPriceLCYToFCY(ResPrice."Currency Code",ResPrice."Unit Price");
              "Unit Price" := ResPrice."Unit Price" * "Qty. per Unit of Measure";
            END;
        END;
      END;
      JobPlanningLineFindJTPrice(JobPlanningLine);
    END;

    [External]
    PROCEDURE JobPlanningLineFindJTPrice@64(VAR JobPlanningLine@1000 : Record 1003);
    VAR
      JobItemPrice@1001 : Record 1013;
      JobResPrice@1002 : Record 1012;
      JobGLAccPrice@1003 : Record 1014;
    BEGIN
      WITH JobPlanningLine DO
        CASE Type OF
          Type::Item:
            BEGIN
              JobItemPrice.SETRANGE("Job No.","Job No.");
              JobItemPrice.SETRANGE("Item No.","No.");
              JobItemPrice.SETRANGE("Variant Code","Variant Code");
              JobItemPrice.SETRANGE("Unit of Measure Code","Unit of Measure Code");
              JobItemPrice.SETRANGE("Currency Code","Currency Code");
              JobItemPrice.SETRANGE("Job Task No.","Job Task No.");
              IF JobItemPrice.FINDFIRST THEN
                CopyJobItemPriceToJobPlanLine(JobPlanningLine,JobItemPrice)
              ELSE BEGIN
                JobItemPrice.SETRANGE("Job Task No.",' ');
                IF JobItemPrice.FINDFIRST THEN
                  CopyJobItemPriceToJobPlanLine(JobPlanningLine,JobItemPrice);
              END;

              IF JobItemPrice.ISEMPTY OR (NOT JobItemPrice."Apply Job Discount") THEN
                FindJobPlanningLineLineDisc(JobPlanningLine);
            END;
          Type::Resource:
            BEGIN
              Res.GET("No.");
              JobResPrice.SETRANGE("Job No.","Job No.");
              JobResPrice.SETRANGE("Currency Code","Currency Code");
              JobResPrice.SETRANGE("Job Task No.","Job Task No.");
              CASE TRUE OF
                JobPlanningLineFindJobResPrice(JobPlanningLine,JobResPrice,JobResPrice.Type::Resource):
                  CopyJobResPriceToJobPlanLine(JobPlanningLine,JobResPrice);
                JobPlanningLineFindJobResPrice(JobPlanningLine,JobResPrice,JobResPrice.Type::"Group(Resource)"):
                  CopyJobResPriceToJobPlanLine(JobPlanningLine,JobResPrice);
                JobPlanningLineFindJobResPrice(JobPlanningLine,JobResPrice,JobResPrice.Type::All):
                  CopyJobResPriceToJobPlanLine(JobPlanningLine,JobResPrice);
                ELSE
                  BEGIN
                  JobResPrice.SETRANGE("Job Task No.",'');
                  CASE TRUE OF
                    JobPlanningLineFindJobResPrice(JobPlanningLine,JobResPrice,JobResPrice.Type::Resource):
                      CopyJobResPriceToJobPlanLine(JobPlanningLine,JobResPrice);
                    JobPlanningLineFindJobResPrice(JobPlanningLine,JobResPrice,JobResPrice.Type::"Group(Resource)"):
                      CopyJobResPriceToJobPlanLine(JobPlanningLine,JobResPrice);
                    JobPlanningLineFindJobResPrice(JobPlanningLine,JobResPrice,JobResPrice.Type::All):
                      CopyJobResPriceToJobPlanLine(JobPlanningLine,JobResPrice);
                  END;
                END;
              END;
            END;
          Type::"G/L Account":
            BEGIN
              JobGLAccPrice.SETRANGE("Job No.","Job No.");
              JobGLAccPrice.SETRANGE("G/L Account No.","No.");
              JobGLAccPrice.SETRANGE("Currency Code","Currency Code");
              JobGLAccPrice.SETRANGE("Job Task No.","Job Task No.");
              IF JobGLAccPrice.FINDFIRST THEN
                CopyJobGLAccPriceToJobPlanLine(JobPlanningLine,JobGLAccPrice)
              ELSE BEGIN
                JobGLAccPrice.SETRANGE("Job Task No.",'');
                IF JobGLAccPrice.FINDFIRST THEN;
                CopyJobGLAccPriceToJobPlanLine(JobPlanningLine,JobGLAccPrice);
              END;
            END;
        END;
    END;

    LOCAL PROCEDURE CopyJobItemPriceToJobPlanLine@63(VAR JobPlanningLine@1000 : Record 1003;JobItemPrice@1001 : Record 1013);
    BEGIN
      WITH JobPlanningLine DO BEGIN
        IF JobItemPrice."Apply Job Price" THEN BEGIN
          "Unit Price" := JobItemPrice."Unit Price";
          "Cost Factor" := JobItemPrice."Unit Cost Factor";
        END;
        IF JobItemPrice."Apply Job Discount" THEN
          "Line Discount %" := JobItemPrice."Line Discount %";
      END;
    END;

    LOCAL PROCEDURE CopyJobResPriceToJobPlanLine@62(VAR JobPlanningLine@1000 : Record 1003;JobResPrice@1001 : Record 1012);
    BEGIN
      WITH JobPlanningLine DO BEGIN
        IF JobResPrice."Apply Job Price" THEN BEGIN
          "Unit Price" := JobResPrice."Unit Price" * "Qty. per Unit of Measure";
          "Cost Factor" := JobResPrice."Unit Cost Factor";
        END;
        IF JobResPrice."Apply Job Discount" THEN
          "Line Discount %" := JobResPrice."Line Discount %";
      END;
    END;

    LOCAL PROCEDURE JobPlanningLineFindJobResPrice@67(VAR JobPlanningLine@1002 : Record 1003;VAR JobResPrice@1000 : Record 1012;PriceType@1001 : 'Resource,Group(Resource),All') : Boolean;
    BEGIN
      CASE PriceType OF
        PriceType::Resource:
          BEGIN
            JobResPrice.SETRANGE(Type,JobResPrice.Type::Resource);
            JobResPrice.SETRANGE("Work Type Code",JobPlanningLine."Work Type Code");
            JobResPrice.SETRANGE(Code,JobPlanningLine."No.");
            EXIT(JobResPrice.FIND('-'));
          END;
        PriceType::"Group(Resource)":
          BEGIN
            JobResPrice.SETRANGE(Type,JobResPrice.Type::"Group(Resource)");
            JobResPrice.SETRANGE(Code,Res."Resource Group No.");
            EXIT(FindJobResPrice(JobResPrice,JobPlanningLine."Work Type Code"));
          END;
        PriceType::All:
          BEGIN
            JobResPrice.SETRANGE(Type,JobResPrice.Type::All);
            JobResPrice.SETRANGE(Code);
            EXIT(FindJobResPrice(JobResPrice,JobPlanningLine."Work Type Code"));
          END;
      END;
    END;

    LOCAL PROCEDURE CopyJobGLAccPriceToJobPlanLine@38(VAR JobPlanningLine@1001 : Record 1003;JobGLAccPrice@1000 : Record 1014);
    BEGIN
      WITH JobPlanningLine DO BEGIN
        "Unit Cost" := JobGLAccPrice."Unit Cost";
        "Unit Price" := JobGLAccPrice."Unit Price" * "Qty. per Unit of Measure";
        "Cost Factor" := JobGLAccPrice."Unit Cost Factor";
        "Line Discount %" := JobGLAccPrice."Line Discount %";
      END;
    END;

    [External]
    PROCEDURE FindJobJnlLinePrice@60(VAR JobJnlLine@1000 : Record 210;CalledByFieldNo@1001 : Integer);
    VAR
      Job@1002 : Record 167;
    BEGIN
      WITH JobJnlLine DO BEGIN
        SetCurrency("Currency Code","Currency Factor","Posting Date");
        SetVAT(FALSE,0,0,'');
        SetUoM(ABS(Quantity),"Qty. per Unit of Measure");

        CASE Type OF
          Type::Item:
            BEGIN
              Item.GET("No.");
              TESTFIELD("Qty. per Unit of Measure");
              Job.GET("Job No.");

              FindSalesPrice(
                TempSalesPrice,Job."Bill-to Customer No.",Job."Bill-to Contact No.",
                "Customer Price Group",'',"No.","Variant Code","Unit of Measure Code",
                "Currency Code","Posting Date",FALSE);
              CalcBestUnitPrice(TempSalesPrice);
              IF FoundSalesPrice OR
                 NOT ((CalledByFieldNo = FIELDNO(Quantity)) OR
                      (CalledByFieldNo = FIELDNO("Variant Code")))
              THEN
                "Unit Price" := TempSalesPrice."Unit Price";
            END;
          Type::Resource:
            BEGIN
              Job.GET("Job No.");
              SetResPrice("No.","Work Type Code","Currency Code");
              CODEUNIT.RUN(CODEUNIT::"Resource-Find Price",ResPrice);
              ConvertPriceLCYToFCY(ResPrice."Currency Code",ResPrice."Unit Price");
              "Unit Price" := ResPrice."Unit Price" * "Qty. per Unit of Measure";
            END;
        END;
      END;
      JobJnlLineFindJTPrice(JobJnlLine);
    END;

    LOCAL PROCEDURE JobJnlLineFindJobResPrice@46(VAR JobJnlLine@1008 : Record 210;VAR JobResPrice@1007 : Record 1012;PriceType@1006 : 'Resource,Group(Resource),All') : Boolean;
    BEGIN
      CASE PriceType OF
        PriceType::Resource:
          BEGIN
            JobResPrice.SETRANGE(Type,JobResPrice.Type::Resource);
            JobResPrice.SETRANGE("Work Type Code",JobJnlLine."Work Type Code");
            JobResPrice.SETRANGE(Code,JobJnlLine."No.");
            EXIT(JobResPrice.FIND('-'));
          END;
        PriceType::"Group(Resource)":
          BEGIN
            JobResPrice.SETRANGE(Type,JobResPrice.Type::"Group(Resource)");
            JobResPrice.SETRANGE(Code,Res."Resource Group No.");
            EXIT(FindJobResPrice(JobResPrice,JobJnlLine."Work Type Code"));
          END;
        PriceType::All:
          BEGIN
            JobResPrice.SETRANGE(Type,JobResPrice.Type::All);
            JobResPrice.SETRANGE(Code);
            EXIT(FindJobResPrice(JobResPrice,JobJnlLine."Work Type Code"));
          END;
      END;
    END;

    LOCAL PROCEDURE CopyJobResPriceToJobJnlLine@47(VAR JobJnlLine@1000 : Record 210;JobResPrice@1001 : Record 1012);
    BEGIN
      WITH JobJnlLine DO BEGIN
        IF JobResPrice."Apply Job Price" THEN BEGIN
          "Unit Price" := JobResPrice."Unit Price" * "Qty. per Unit of Measure";
          "Cost Factor" := JobResPrice."Unit Cost Factor";
        END;
        IF JobResPrice."Apply Job Discount" THEN
          "Line Discount %" := JobResPrice."Line Discount %";
      END;
    END;

    LOCAL PROCEDURE CopyJobGLAccPriceToJobJnlLine@48(VAR JobJnlLine@1001 : Record 210;JobGLAccPrice@1000 : Record 1014);
    BEGIN
      WITH JobJnlLine DO BEGIN
        "Unit Cost" := JobGLAccPrice."Unit Cost";
        "Unit Price" := JobGLAccPrice."Unit Price" * "Qty. per Unit of Measure";
        "Cost Factor" := JobGLAccPrice."Unit Cost Factor";
        "Line Discount %" := JobGLAccPrice."Line Discount %";
      END;
    END;

    LOCAL PROCEDURE JobJnlLineFindJTPrice@42(VAR JobJnlLine@1000 : Record 210);
    VAR
      JobItemPrice@1003 : Record 1013;
      JobResPrice@1002 : Record 1012;
      JobGLAccPrice@1001 : Record 1014;
    BEGIN
      WITH JobJnlLine DO
        CASE Type OF
          Type::Item:
            BEGIN
              JobItemPrice.SETRANGE("Job No.","Job No.");
              JobItemPrice.SETRANGE("Item No.","No.");
              JobItemPrice.SETRANGE("Variant Code","Variant Code");
              JobItemPrice.SETRANGE("Unit of Measure Code","Unit of Measure Code");
              JobItemPrice.SETRANGE("Currency Code","Currency Code");
              JobItemPrice.SETRANGE("Job Task No.","Job Task No.");
              IF JobItemPrice.FINDFIRST THEN
                CopyJobItemPriceToJobJnlLine(JobJnlLine,JobItemPrice)
              ELSE BEGIN
                JobItemPrice.SETRANGE("Job Task No.",' ');
                IF JobItemPrice.FINDFIRST THEN
                  CopyJobItemPriceToJobJnlLine(JobJnlLine,JobItemPrice);
              END;

              IF JobItemPrice.ISEMPTY OR (NOT JobItemPrice."Apply Job Discount") THEN
                FindJobJnlLineLineDisc(JobJnlLine);
            END;
          Type::Resource:
            BEGIN
              Res.GET("No.");
              JobResPrice.SETRANGE("Job No.","Job No.");
              JobResPrice.SETRANGE("Currency Code","Currency Code");
              JobResPrice.SETRANGE("Job Task No.","Job Task No.");
              CASE TRUE OF
                JobJnlLineFindJobResPrice(JobJnlLine,JobResPrice,JobResPrice.Type::Resource):
                  CopyJobResPriceToJobJnlLine(JobJnlLine,JobResPrice);
                JobJnlLineFindJobResPrice(JobJnlLine,JobResPrice,JobResPrice.Type::"Group(Resource)"):
                  CopyJobResPriceToJobJnlLine(JobJnlLine,JobResPrice);
                JobJnlLineFindJobResPrice(JobJnlLine,JobResPrice,JobResPrice.Type::All):
                  CopyJobResPriceToJobJnlLine(JobJnlLine,JobResPrice);
                ELSE
                  BEGIN
                  JobResPrice.SETRANGE("Job Task No.",'');
                  CASE TRUE OF
                    JobJnlLineFindJobResPrice(JobJnlLine,JobResPrice,JobResPrice.Type::Resource):
                      CopyJobResPriceToJobJnlLine(JobJnlLine,JobResPrice);
                    JobJnlLineFindJobResPrice(JobJnlLine,JobResPrice,JobResPrice.Type::"Group(Resource)"):
                      CopyJobResPriceToJobJnlLine(JobJnlLine,JobResPrice);
                    JobJnlLineFindJobResPrice(JobJnlLine,JobResPrice,JobResPrice.Type::All):
                      CopyJobResPriceToJobJnlLine(JobJnlLine,JobResPrice);
                  END;
                END;
              END;
            END;
          Type::"G/L Account":
            BEGIN
              JobGLAccPrice.SETRANGE("Job No.","Job No.");
              JobGLAccPrice.SETRANGE("G/L Account No.","No.");
              JobGLAccPrice.SETRANGE("Currency Code","Currency Code");
              JobGLAccPrice.SETRANGE("Job Task No.","Job Task No.");
              IF JobGLAccPrice.FINDFIRST THEN
                CopyJobGLAccPriceToJobJnlLine(JobJnlLine,JobGLAccPrice)
              ELSE BEGIN
                JobGLAccPrice.SETRANGE("Job Task No.",'');
                IF JobGLAccPrice.FINDFIRST THEN;
                CopyJobGLAccPriceToJobJnlLine(JobJnlLine,JobGLAccPrice);
              END;
            END;
        END;
    END;

    LOCAL PROCEDURE CopyJobItemPriceToJobJnlLine@43(VAR JobJnlLine@1001 : Record 210;JobItemPrice@1000 : Record 1013);
    BEGIN
      WITH JobJnlLine DO BEGIN
        IF JobItemPrice."Apply Job Price" THEN BEGIN
          "Unit Price" := JobItemPrice."Unit Price";
          "Cost Factor" := JobItemPrice."Unit Cost Factor";
        END;
        IF JobItemPrice."Apply Job Discount" THEN
          "Line Discount %" := JobItemPrice."Line Discount %";
      END;
    END;

    LOCAL PROCEDURE FindJobPlanningLineLineDisc@39(VAR JobPlanningLine@1000 : Record 1003);
    BEGIN
      WITH JobPlanningLine DO BEGIN
        SetCurrency("Currency Code","Currency Factor","Planning Date");
        SetUoM(ABS(Quantity),"Qty. per Unit of Measure");
        TESTFIELD("Qty. per Unit of Measure");
        IF Type = Type::Item THEN BEGIN
          JobPlanningLineLineDiscExists(JobPlanningLine,FALSE);
          CalcBestLineDisc(TempSalesLineDisc);
          IF AllowLineDisc THEN
            "Line Discount %" := TempSalesLineDisc."Line Discount %"
          ELSE
            "Line Discount %" := 0;
        END;
      END;
    END;

    LOCAL PROCEDURE JobPlanningLineLineDiscExists@49(VAR JobPlanningLine@1000 : Record 1003;ShowAll@1002 : Boolean) : Boolean;
    VAR
      Job@1001 : Record 167;
    BEGIN
      WITH JobPlanningLine DO
        IF (Type = Type::Item) AND Item.GET("No.") THEN BEGIN
          Job.GET("Job No.");
          FindSalesLineDisc(
            TempSalesLineDisc,Job."Bill-to Customer No.",Job."Bill-to Contact No.",
            Job."Customer Disc. Group",'',"No.",Item."Item Disc. Group","Variant Code","Unit of Measure Code",
            "Currency Code",JobPlanningLineStartDate(JobPlanningLine,DateCaption),ShowAll);
          EXIT(TempSalesLineDisc.FIND('-'));
        END;
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE JobPlanningLineStartDate@51(JobPlanningLine@1000 : Record 1003;VAR DateCaption@1001 : Text[30]) : Date;
    BEGIN
      DateCaption := JobPlanningLine.FIELDCAPTION("Planning Date");
      EXIT(JobPlanningLine."Planning Date");
    END;

    LOCAL PROCEDURE FindJobJnlLineLineDisc@58(VAR JobJnlLine@1000 : Record 210);
    BEGIN
      WITH JobJnlLine DO BEGIN
        SetCurrency("Currency Code","Currency Factor","Posting Date");
        SetUoM(ABS(Quantity),"Qty. per Unit of Measure");
        TESTFIELD("Qty. per Unit of Measure");
        IF Type = Type::Item THEN BEGIN
          JobJnlLineLineDiscExists(JobJnlLine,FALSE);
          CalcBestLineDisc(TempSalesLineDisc);
          "Line Discount %" := TempSalesLineDisc."Line Discount %";
        END;
      END;
    END;

    LOCAL PROCEDURE JobJnlLineLineDiscExists@57(VAR JobJnlLine@1000 : Record 210;ShowAll@1002 : Boolean) : Boolean;
    VAR
      Job@1001 : Record 167;
    BEGIN
      WITH JobJnlLine DO
        IF (Type = Type::Item) AND Item.GET("No.") THEN BEGIN
          Job.GET("Job No.");
          FindSalesLineDisc(
            TempSalesLineDisc,Job."Bill-to Customer No.",Job."Bill-to Contact No.",
            Job."Customer Disc. Group",'',"No.",Item."Item Disc. Group","Variant Code","Unit of Measure Code",
            "Currency Code",JobJnlLineStartDate(JobJnlLine,DateCaption),ShowAll);
          EXIT(TempSalesLineDisc.FIND('-'));
        END;
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE JobJnlLineStartDate@55(JobJnlLine@1000 : Record 210;VAR DateCaption@1001 : Text[30]) : Date;
    BEGIN
      DateCaption := JobJnlLine.FIELDCAPTION("Posting Date");
      EXIT(JobJnlLine."Posting Date");
    END;

    LOCAL PROCEDURE FindJobResPrice@70(VAR JobResPrice@1000 : Record 1012;WorkTypeCode@1001 : Code[10]) : Boolean;
    BEGIN
      JobResPrice.SETRANGE("Work Type Code",WorkTypeCode);
      IF JobResPrice.FINDFIRST THEN
        EXIT(TRUE);
      JobResPrice.SETRANGE("Work Type Code",'');
      EXIT(JobResPrice.FINDFIRST);
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterFindItemJnlLinePrice@54(VAR ItemJournalLine@1000 : Record 83;SalesPrice@1001 : Record 7002;CalledByFieldNo@1002 : Integer);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterFindStdItemJnlLinePrice@69(VAR StdItemJnlLine@1001 : Record 753;SalesPrice@1002 : Record 7002;CalledByFieldNo@1000 : Integer);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterFindSalesLinePrice@8(VAR SalesLine@1001 : Record 37;SalesHeader@1002 : Record 36;SalesPrice@1003 : Record 7002;ResourcePrice@1004 : Record 201;CalledByFieldNo@1000 : Integer);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterFindSalesLineLineDisc@9(VAR SalesLine@1001 : Record 37;SalesHeader@1000 : Record 36;SalesLineDiscount@1002 : Record 7004);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterFindServLinePrice@50(VAR ServiceLine@1000 : Record 5902;ServiceHeader@1001 : Record 5900;SalesPrice@1002 : Record 7002;ResourcePrice@1003 : Record 201;ServiceCost@1004 : Record 5905;CalledByFieldNo@1005 : Integer);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterFindServLineDisc@59(VAR ServiceLine@1001 : Record 5902;ServiceHeader@1000 : Record 5900;SalesLineDiscount@1002 : Record 7004);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnGetCustNoForSalesHeader@53(SalesHeader@1000 : Record 36;VAR CustomerNo@1001 : Code[20]);
    BEGIN
    END;

    BEGIN
    END.
  }
}

