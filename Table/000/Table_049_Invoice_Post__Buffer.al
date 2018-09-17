OBJECT Table 49 Invoice Post. Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Fakturabogf.buffer;
               ENU=Invoice Post. Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Type                ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=Forudb. val.kursdiff.,Finanskonto,Vare,Ressource,Anl‘g;
                                                                    ENU=Prepmt. Exch. Rate Difference,G/L Account,Item,Resource,Fixed Asset];
                                                   OptionString=Prepmt. Exch. Rate Difference,G/L Account,Item,Resource,Fixed Asset }
    { 2   ;   ;G/L Account         ;Code20        ;TableRelation="G/L Account";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Finanskonto;
                                                              ENU=G/L Account] }
    { 4   ;   ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Global dimension 1-kode;
                                                              ENU=Global Dimension 1 Code];
                                                   CaptionClass='1,1,1' }
    { 5   ;   ;Global Dimension 2 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Global dimension 2-kode;
                                                              ENU=Global Dimension 2 Code];
                                                   CaptionClass='1,1,2' }
    { 6   ;   ;Job No.             ;Code20        ;TableRelation=Job;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Sagsnr.;
                                                              ENU=Job No.] }
    { 7   ;   ;Amount              ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bel›b;
                                                              ENU=Amount];
                                                   AutoFormatType=1 }
    { 8   ;   ;VAT Amount          ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Momsbel›b;
                                                              ENU=VAT Amount];
                                                   AutoFormatType=1 }
    { 10  ;   ;Gen. Bus. Posting Group;Code20     ;TableRelation="Gen. Business Posting Group";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Virksomhedsbogf›ringsgruppe;
                                                              ENU=Gen. Bus. Posting Group] }
    { 11  ;   ;Gen. Prod. Posting Group;Code20    ;TableRelation="Gen. Product Posting Group";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Produktbogf›ringsgruppe;
                                                              ENU=Gen. Prod. Posting Group] }
    { 12  ;   ;VAT Calculation Type;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Momsberegningstype;
                                                              ENU=VAT Calculation Type];
                                                   OptionCaptionML=[DAN=Normal moms,Modtagermoms,Momskorrektion,Sales tax;
                                                                    ENU=Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax];
                                                   OptionString=Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax }
    { 14  ;   ;VAT Base Amount     ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Momsgrundlag (bel›b);
                                                              ENU=VAT Base Amount];
                                                   AutoFormatType=1 }
    { 17  ;   ;System-Created Entry;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Automatisk oprettet;
                                                              ENU=System-Created Entry] }
    { 18  ;   ;Tax Area Code       ;Code20        ;TableRelation="Tax Area";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Skatteomr†dekode;
                                                              ENU=Tax Area Code] }
    { 19  ;   ;Tax Liable          ;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Skattepligtig;
                                                              ENU=Tax Liable] }
    { 20  ;   ;Tax Group Code      ;Code20        ;TableRelation="Tax Group";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Skattegruppekode;
                                                              ENU=Tax Group Code] }
    { 21  ;   ;Quantity            ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Antal;
                                                              ENU=Quantity];
                                                   DecimalPlaces=1:5 }
    { 22  ;   ;Use Tax             ;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Use Tax;
                                                              ENU=Use Tax] }
    { 23  ;   ;VAT Bus. Posting Group;Code20      ;TableRelation="VAT Business Posting Group";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Momsvirksomhedsbogf.gruppe;
                                                              ENU=VAT Bus. Posting Group] }
    { 24  ;   ;VAT Prod. Posting Group;Code20     ;TableRelation="VAT Product Posting Group";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Momsproduktbogf.gruppe;
                                                              ENU=VAT Prod. Posting Group] }
    { 25  ;   ;Amount (ACY)        ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bel›b (EV);
                                                              ENU=Amount (ACY)];
                                                   AutoFormatType=1 }
    { 26  ;   ;VAT Amount (ACY)    ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Momsbel›b (EV);
                                                              ENU=VAT Amount (ACY)];
                                                   AutoFormatType=1 }
    { 29  ;   ;VAT Base Amount (ACY);Decimal      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Momsgrundl.bel›b (EV);
                                                              ENU=VAT Base Amount (ACY)];
                                                   AutoFormatType=1 }
    { 31  ;   ;VAT Difference      ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Momsdifference;
                                                              ENU=VAT Difference];
                                                   AutoFormatType=1 }
    { 32  ;   ;VAT %               ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Momspct.;
                                                              ENU=VAT %];
                                                   DecimalPlaces=1:1 }
    { 480 ;   ;Dimension Set ID    ;Integer       ;TableRelation="Dimension Set Entry";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dimensionsgruppe-id;
                                                              ENU=Dimension Set ID];
                                                   Editable=No }
    { 1700;   ;Deferral Code       ;Code10        ;TableRelation="Deferral Template"."Deferral Code";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Periodiseringskode;
                                                              ENU=Deferral Code] }
    { 1701;   ;Deferral Line No.   ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Periodiseringslinjenr.;
                                                              ENU=Deferral Line No.] }
    { 5600;   ;FA Posting Date     ;Date          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bogf›ringsdato for anl‘g;
                                                              ENU=FA Posting Date] }
    { 5601;   ;FA Posting Type     ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Anl‘gsbogf›ringstype;
                                                              ENU=FA Posting Type];
                                                   OptionCaptionML=[DAN=" ,Anskaffelse,Reparation";
                                                                    ENU=" ,Acquisition Cost,Maintenance"];
                                                   OptionString=[ ,Acquisition Cost,Maintenance] }
    { 5602;   ;Depreciation Book Code;Code10      ;TableRelation="Depreciation Book";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Afskrivningsprofilkode;
                                                              ENU=Depreciation Book Code] }
    { 5603;   ;Salvage Value       ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Skrapv‘rdi;
                                                              ENU=Salvage Value];
                                                   AutoFormatType=1 }
    { 5605;   ;Depr. until FA Posting Date;Boolean;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Afskriv til bogf›ringsdato for anl‘g;
                                                              ENU=Depr. until FA Posting Date] }
    { 5606;   ;Depr. Acquisition Cost;Boolean     ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Afskriv anskaffelse;
                                                              ENU=Depr. Acquisition Cost] }
    { 5609;   ;Maintenance Code    ;Code10        ;TableRelation=Maintenance;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Reparationskode;
                                                              ENU=Maintenance Code] }
    { 5610;   ;Insurance No.       ;Code20        ;TableRelation=Insurance;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Forsikringsnr.;
                                                              ENU=Insurance No.] }
    { 5611;   ;Budgeted FA No.     ;Code20        ;TableRelation="Fixed Asset";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Budgetanl‘gsnr.;
                                                              ENU=Budgeted FA No.] }
    { 5612;   ;Duplicate in Depreciation Book;Code10;
                                                   TableRelation="Depreciation Book";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kopier til afskr.profil;
                                                              ENU=Duplicate in Depreciation Book] }
    { 5613;   ;Use Duplication List;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Brug kopiliste;
                                                              ENU=Use Duplication List] }
    { 5614;   ;Fixed Asset Line No.;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Anl‘glinjenr.;
                                                              ENU=Fixed Asset Line No.] }
  }
  KEYS
  {
    {    ;Type,G/L Account,Gen. Bus. Posting Group,Gen. Prod. Posting Group,VAT Bus. Posting Group,VAT Prod. Posting Group,Tax Area Code,Tax Group Code,Tax Liable,Use Tax,Dimension Set ID,Job No.,Fixed Asset Line No.,Deferral Code;
                                                   Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      DimMgt@1000 : Codeunit 408;

    [External]
    PROCEDURE PrepareSales@1(VAR SalesLine@1000 : Record 37);
    BEGIN
      CLEAR(Rec);
      Type := SalesLine.Type;
      "System-Created Entry" := TRUE;
      "Gen. Bus. Posting Group" := SalesLine."Gen. Bus. Posting Group";
      "Gen. Prod. Posting Group" := SalesLine."Gen. Prod. Posting Group";
      "VAT Bus. Posting Group" := SalesLine."VAT Bus. Posting Group";
      "VAT Prod. Posting Group" := SalesLine."VAT Prod. Posting Group";
      "VAT Calculation Type" := SalesLine."VAT Calculation Type";
      "Global Dimension 1 Code" := SalesLine."Shortcut Dimension 1 Code";
      "Global Dimension 2 Code" := SalesLine."Shortcut Dimension 2 Code";
      "Dimension Set ID" := SalesLine."Dimension Set ID";
      "Job No." := SalesLine."Job No.";
      "VAT %" := SalesLine."VAT %";
      "VAT Difference" := SalesLine."VAT Difference";
      IF Type = Type::"Fixed Asset" THEN BEGIN
        "FA Posting Date" := SalesLine."FA Posting Date";
        "Depreciation Book Code" := SalesLine."Depreciation Book Code";
        "Depr. until FA Posting Date" := SalesLine."Depr. until FA Posting Date";
        "Duplicate in Depreciation Book" := SalesLine."Duplicate in Depreciation Book";
        "Use Duplication List" := SalesLine."Use Duplication List";
      END;

      IF "VAT Calculation Type" = "VAT Calculation Type"::"Sales Tax" THEN
        SetSalesTaxForSalesLine(SalesLine);

      DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Global Dimension 1 Code","Global Dimension 2 Code");

      IF SalesLine."Line Discount %" = 100 THEN BEGIN
        "VAT Base Amount" := 0;
        "VAT Base Amount (ACY)" := 0;
        "VAT Amount" := 0;
        "VAT Amount (ACY)" := 0;
      END;

      OnAfterInvPostBufferPrepareSales(SalesLine,Rec);
    END;

    [External]
    PROCEDURE CalcDiscount@2(PricesInclVAT@1000 : Boolean;DiscountAmount@1001 : Decimal;DiscountAmountACY@1002 : Decimal);
    VAR
      CurrencyLCY@1003 : Record 4;
      CurrencyACY@1004 : Record 4;
      GLSetup@1005 : Record 98;
    BEGIN
      CurrencyLCY.InitRoundingPrecision;
      GLSetup.GET;
      IF GLSetup."Additional Reporting Currency" <> '' THEN
        CurrencyACY.GET(GLSetup."Additional Reporting Currency")
      ELSE
        CurrencyACY := CurrencyLCY;
      "VAT Amount" := ROUND(
          CalcVATAmount(PricesInclVAT,DiscountAmount,"VAT %"),
          CurrencyLCY."Amount Rounding Precision",
          CurrencyLCY.VATRoundingDirection);
      "VAT Amount (ACY)" := ROUND(
          CalcVATAmount(PricesInclVAT,DiscountAmountACY,"VAT %"),
          CurrencyACY."Amount Rounding Precision",
          CurrencyACY.VATRoundingDirection);

      IF PricesInclVAT AND ("VAT %" <> 0) THEN BEGIN
        "VAT Base Amount" := DiscountAmount - "VAT Amount";
        "VAT Base Amount (ACY)" := DiscountAmountACY - "VAT Amount (ACY)";
      END ELSE BEGIN
        "VAT Base Amount" := DiscountAmount;
        "VAT Base Amount (ACY)" := DiscountAmountACY;
      END;
      Amount := "VAT Base Amount";
      "Amount (ACY)" := "VAT Base Amount (ACY)";
    END;

    LOCAL PROCEDURE CalcVATAmount@3(ValueInclVAT@1000 : Boolean;Value@1001 : Decimal;VATPercent@1002 : Decimal) : Decimal;
    BEGIN
      IF VATPercent = 0 THEN
        EXIT(0);
      IF ValueInclVAT THEN
        EXIT(Value / (1 + (VATPercent / 100)) * (VATPercent / 100));

      EXIT(Value * (VATPercent / 100));
    END;

    [External]
    PROCEDURE SetAccount@4(AccountNo@1000 : Code[20];VAR TotalVAT@1004 : Decimal;VAR TotalVATACY@1003 : Decimal;VAR TotalAmount@1002 : Decimal;VAR TotalAmountACY@1001 : Decimal);
    BEGIN
      TotalVAT := TotalVAT - "VAT Amount";
      TotalVATACY := TotalVATACY - "VAT Amount (ACY)";
      TotalAmount := TotalAmount - Amount;
      TotalAmountACY := TotalAmountACY - "Amount (ACY)";
      "G/L Account" := AccountNo;
    END;

    [External]
    PROCEDURE SetAmounts@5(TotalVAT@1003 : Decimal;TotalVATACY@1002 : Decimal;TotalAmount@1001 : Decimal;TotalAmountACY@1000 : Decimal;VATDifference@1004 : Decimal;TotalVATBase@1006 : Decimal;TotalVATBaseACY@1005 : Decimal);
    BEGIN
      Amount := TotalAmount;
      "VAT Base Amount" := TotalVATBase;
      "VAT Amount" := TotalVAT;
      "Amount (ACY)" := TotalAmountACY;
      "VAT Base Amount (ACY)" := TotalVATBaseACY;
      "VAT Amount (ACY)" := TotalVATACY;
      "VAT Difference" := VATDifference;
    END;

    [External]
    PROCEDURE PreparePurchase@6(VAR PurchLine@1000 : Record 39);
    BEGIN
      CLEAR(Rec);
      Type := PurchLine.Type;
      "System-Created Entry" := TRUE;
      "Gen. Bus. Posting Group" := PurchLine."Gen. Bus. Posting Group";
      "Gen. Prod. Posting Group" := PurchLine."Gen. Prod. Posting Group";
      "VAT Bus. Posting Group" := PurchLine."VAT Bus. Posting Group";
      "VAT Prod. Posting Group" := PurchLine."VAT Prod. Posting Group";
      "VAT Calculation Type" := PurchLine."VAT Calculation Type";
      "Global Dimension 1 Code" := PurchLine."Shortcut Dimension 1 Code";
      "Global Dimension 2 Code" := PurchLine."Shortcut Dimension 2 Code";
      "Dimension Set ID" := PurchLine."Dimension Set ID";
      "Job No." := PurchLine."Job No.";
      "VAT %" := PurchLine."VAT %";
      "VAT Difference" := PurchLine."VAT Difference";
      IF Type = Type::"Fixed Asset" THEN BEGIN
        "FA Posting Date" := PurchLine."FA Posting Date";
        "Depreciation Book Code" := PurchLine."Depreciation Book Code";
        "Depr. until FA Posting Date" := PurchLine."Depr. until FA Posting Date";
        "Duplicate in Depreciation Book" := PurchLine."Duplicate in Depreciation Book";
        "Use Duplication List" := PurchLine."Use Duplication List";
        "FA Posting Type" := PurchLine."FA Posting Type";
        "Depreciation Book Code" := PurchLine."Depreciation Book Code";
        "Salvage Value" := PurchLine."Salvage Value";
        "Depr. Acquisition Cost" := PurchLine."Depr. Acquisition Cost";
        "Maintenance Code" := PurchLine."Maintenance Code";
        "Insurance No." := PurchLine."Insurance No.";
        "Budgeted FA No." := PurchLine."Budgeted FA No.";
      END;

      IF "VAT Calculation Type" = "VAT Calculation Type"::"Sales Tax" THEN
        SetSalesTaxForPurchLine(PurchLine);

      DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Global Dimension 1 Code","Global Dimension 2 Code");

      IF PurchLine."Line Discount %" = 100 THEN BEGIN
        "VAT Base Amount" := 0;
        "VAT Base Amount (ACY)" := 0;
        "VAT Amount" := 0;
        "VAT Amount (ACY)" := 0;
      END;

      OnAfterInvPostBufferPreparePurchase(PurchLine,Rec);
    END;

    [External]
    PROCEDURE CalcDiscountNoVAT@7(DiscountAmount@1001 : Decimal;DiscountAmountACY@1002 : Decimal);
    BEGIN
      "VAT Base Amount" := DiscountAmount;
      "VAT Base Amount (ACY)" := DiscountAmountACY;
      Amount := "VAT Base Amount";
      "Amount (ACY)" := "VAT Base Amount (ACY)";
    END;

    [External]
    PROCEDURE SetSalesTaxForPurchLine@8(PurchaseLine@1000 : Record 39);
    BEGIN
      "Tax Area Code" := PurchaseLine."Tax Area Code";
      "Tax Liable" := PurchaseLine."Tax Liable";
      "Tax Group Code" := PurchaseLine."Tax Group Code";
      "Use Tax" := PurchaseLine."Use Tax";
      Quantity := PurchaseLine."Qty. to Invoice (Base)";
    END;

    [External]
    PROCEDURE SetSalesTaxForSalesLine@15(SalesLine@1000 : Record 37);
    BEGIN
      "Tax Area Code" := SalesLine."Tax Area Code";
      "Tax Liable" := SalesLine."Tax Liable";
      "Tax Group Code" := SalesLine."Tax Group Code";
      "Use Tax" := FALSE;
      Quantity := SalesLine."Qty. to Invoice (Base)";
    END;

    [External]
    PROCEDURE ReverseAmounts@9();
    BEGIN
      Amount := -Amount;
      "VAT Base Amount" := -"VAT Base Amount";
      "Amount (ACY)" := -"Amount (ACY)";
      "VAT Base Amount (ACY)" := -"VAT Base Amount (ACY)";
      "VAT Amount" := -"VAT Amount";
      "VAT Amount (ACY)" := -"VAT Amount (ACY)";
    END;

    [External]
    PROCEDURE SetAmountsNoVAT@10(TotalAmount@1001 : Decimal;TotalAmountACY@1000 : Decimal;VATDifference@1004 : Decimal);
    BEGIN
      Amount := TotalAmount;
      "VAT Base Amount" := TotalAmount;
      "VAT Amount" := 0;
      "Amount (ACY)" := TotalAmountACY;
      "VAT Base Amount (ACY)" := TotalAmountACY;
      "VAT Amount (ACY)" := 0;
      "VAT Difference" := VATDifference;
    END;

    [External]
    PROCEDURE PrepareService@11(VAR ServiceLine@1000 : Record 5902);
    BEGIN
      CLEAR(Rec);
      CASE ServiceLine.Type OF
        ServiceLine.Type::Item:
          Type := Type::Item;
        ServiceLine.Type::Resource:
          Type := Type::Resource;
        ServiceLine.Type::"G/L Account":
          Type := Type::"G/L Account";
      END;
      "System-Created Entry" := TRUE;
      "Gen. Bus. Posting Group" := ServiceLine."Gen. Bus. Posting Group";
      "Gen. Prod. Posting Group" := ServiceLine."Gen. Prod. Posting Group";
      "VAT Bus. Posting Group" := ServiceLine."VAT Bus. Posting Group";
      "VAT Prod. Posting Group" := ServiceLine."VAT Prod. Posting Group";
      "VAT Calculation Type" := ServiceLine."VAT Calculation Type";
      "Global Dimension 1 Code" := ServiceLine."Shortcut Dimension 1 Code";
      "Global Dimension 2 Code" := ServiceLine."Shortcut Dimension 2 Code";
      "Dimension Set ID" := ServiceLine."Dimension Set ID";
      "Job No." := ServiceLine."Job No.";
      "VAT %" := ServiceLine."VAT %";
      "VAT Difference" := ServiceLine."VAT Difference";
      IF "VAT Calculation Type" = "VAT Calculation Type"::"Sales Tax" THEN BEGIN
        "Tax Area Code" := ServiceLine."Tax Area Code";
        "Tax Group Code" := ServiceLine."Tax Group Code";
        "Tax Liable" := ServiceLine."Tax Liable";
        "Use Tax" := FALSE;
        Quantity := ServiceLine."Qty. to Invoice (Base)";
      END;

      OnAfterInvPostBufferPrepareService(ServiceLine,Rec);
    END;

    [External]
    PROCEDURE FillPrepmtAdjBuffer@81(VAR TempInvoicePostBuffer@1005 : TEMPORARY Record 49;InvoicePostBuffer@1006 : Record 49;GLAccountNo@1001 : Code[20];AdjAmount@1003 : Decimal;RoundingEntry@1004 : Boolean);
    VAR
      PrepmtAdjInvPostBuffer@1002 : Record 49;
    BEGIN
      WITH PrepmtAdjInvPostBuffer DO BEGIN
        INIT;
        Type := Type::"Prepmt. Exch. Rate Difference";
        "G/L Account" := GLAccountNo;
        Amount := AdjAmount;
        IF RoundingEntry THEN
          "Amount (ACY)" := AdjAmount
        ELSE
          "Amount (ACY)" := 0;
        "Dimension Set ID" := InvoicePostBuffer."Dimension Set ID";
        "Global Dimension 1 Code" := InvoicePostBuffer."Global Dimension 1 Code";
        "Global Dimension 2 Code" := InvoicePostBuffer."Global Dimension 2 Code";
        "System-Created Entry" := TRUE;
        InvoicePostBuffer := PrepmtAdjInvPostBuffer;

        TempInvoicePostBuffer := InvoicePostBuffer;
        IF TempInvoicePostBuffer.FIND THEN BEGIN
          TempInvoicePostBuffer.Amount += InvoicePostBuffer.Amount;
          TempInvoicePostBuffer."Amount (ACY)" += InvoicePostBuffer."Amount (ACY)";
          TempInvoicePostBuffer.MODIFY;
        END ELSE BEGIN
          TempInvoicePostBuffer := InvoicePostBuffer;
          TempInvoicePostBuffer.INSERT;
        END;
      END;
    END;

    [External]
    PROCEDURE Update@12(InvoicePostBuffer@1000 : Record 49;VAR InvDefLineNo@1001 : Integer;VAR DeferralLineNo@1002 : Integer);
    BEGIN
      Rec := InvoicePostBuffer;
      IF FIND THEN BEGIN
        Amount += InvoicePostBuffer.Amount;
        "VAT Amount" += InvoicePostBuffer."VAT Amount";
        "VAT Base Amount" += InvoicePostBuffer."VAT Base Amount";
        "Amount (ACY)" += InvoicePostBuffer."Amount (ACY)";
        "VAT Amount (ACY)" += InvoicePostBuffer."VAT Amount (ACY)";
        "VAT Difference" += InvoicePostBuffer."VAT Difference";
        "VAT Base Amount (ACY)" += InvoicePostBuffer."VAT Base Amount (ACY)";
        Quantity += InvoicePostBuffer.Quantity;
        IF NOT InvoicePostBuffer."System-Created Entry" THEN
          "System-Created Entry" := FALSE;
        MODIFY;
        InvDefLineNo := "Deferral Line No.";
      END ELSE BEGIN
        IF "Deferral Code" <> '' THEN BEGIN
          DeferralLineNo := DeferralLineNo + 1;
          "Deferral Line No." := DeferralLineNo;
          InvDefLineNo := "Deferral Line No.";
        END;
        INSERT;
      END;
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterInvPostBufferPrepareSales@13(VAR SalesLine@1000 : Record 37;VAR InvoicePostBuffer@1001 : Record 49);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterInvPostBufferPreparePurchase@14(VAR PurchaseLine@1000 : Record 39;VAR InvoicePostBuffer@1001 : Record 49);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterInvPostBufferPrepareService@16(VAR ServiceLine@1000 : Record 5902;VAR InvoicePostBuffer@1001 : Record 49);
    BEGIN
    END;

    BEGIN
    END.
  }
}

