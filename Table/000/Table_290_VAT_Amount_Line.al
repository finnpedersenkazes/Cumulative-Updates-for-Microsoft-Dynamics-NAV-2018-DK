OBJECT Table 290 VAT Amount Line
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Momsbel›blinje;
               ENU=VAT Amount Line];
  }
  FIELDS
  {
    { 1   ;   ;VAT %               ;Decimal       ;CaptionML=[DAN=Momspct.;
                                                              ENU=VAT %];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 2   ;   ;VAT Base            ;Decimal       ;CaptionML=[DAN=Momsgrundlag;
                                                              ENU=VAT Base];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 3   ;   ;VAT Amount          ;Decimal       ;OnValidate=BEGIN
                                                                TESTFIELD("VAT %");
                                                                TESTFIELD("VAT Base");
                                                                IF "VAT Amount" / "VAT Base" < 0 THEN
                                                                  ERROR(Text002,FIELDCAPTION("VAT Amount"));
                                                                "VAT Difference" := "VAT Amount" - "Calculated VAT Amount";
                                                              END;

                                                   CaptionML=[DAN=Momsbel›b;
                                                              ENU=VAT Amount];
                                                   AutoFormatType=1 }
    { 4   ;   ;Amount Including VAT;Decimal       ;CaptionML=[DAN=Bel›b inkl. moms;
                                                              ENU=Amount Including VAT];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 5   ;   ;VAT Identifier      ;Code20        ;CaptionML=[DAN=Moms-id;
                                                              ENU=VAT Identifier];
                                                   Editable=No }
    { 6   ;   ;Line Amount         ;Decimal       ;CaptionML=[DAN=Linjebel›b;
                                                              ENU=Line Amount];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 7   ;   ;Inv. Disc. Base Amount;Decimal     ;CaptionML=[DAN=Fakturarabatgrundlag - bel›b;
                                                              ENU=Inv. Disc. Base Amount];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 8   ;   ;Invoice Discount Amount;Decimal    ;OnValidate=BEGIN
                                                                TESTFIELD("Inv. Disc. Base Amount");
                                                                IF "Invoice Discount Amount" / "Inv. Disc. Base Amount" > 1 THEN
                                                                  ERROR(
                                                                    InvoiceDiscAmtIsGreaterThanBaseAmtErr,
                                                                    FIELDCAPTION("Invoice Discount Amount"),"Inv. Disc. Base Amount");
                                                                "VAT Base" := "Line Amount" - "Invoice Discount Amount";
                                                              END;

                                                   CaptionML=[DAN=Fakturarabatbel›b;
                                                              ENU=Invoice Discount Amount];
                                                   AutoFormatType=1 }
    { 9   ;   ;VAT Calculation Type;Option        ;CaptionML=[DAN=Momsberegningstype;
                                                              ENU=VAT Calculation Type];
                                                   OptionCaptionML=[DAN=Normal moms,Modtagermoms,Momskorrektion,Sales tax;
                                                                    ENU=Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax];
                                                   OptionString=Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax;
                                                   Editable=No }
    { 10  ;   ;Tax Group Code      ;Code20        ;TableRelation="Tax Group";
                                                   CaptionML=[DAN=Skattegruppekode;
                                                              ENU=Tax Group Code];
                                                   Editable=No }
    { 11  ;   ;Quantity            ;Decimal       ;CaptionML=[DAN=Antal;
                                                              ENU=Quantity];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 12  ;   ;Modified            ;Boolean       ;CaptionML=[DAN=Rettet;
                                                              ENU=Modified] }
    { 13  ;   ;Use Tax             ;Boolean       ;CaptionML=[DAN=Use Tax;
                                                              ENU=Use Tax] }
    { 14  ;   ;Calculated VAT Amount;Decimal      ;CaptionML=[DAN=Beregnet momsbel›b;
                                                              ENU=Calculated VAT Amount];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 15  ;   ;VAT Difference      ;Decimal       ;CaptionML=[DAN=Momsdifference;
                                                              ENU=VAT Difference];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 16  ;   ;Positive            ;Boolean       ;CaptionML=[DAN=Positiv;
                                                              ENU=Positive] }
    { 17  ;   ;Includes Prepayment ;Boolean       ;CaptionML=[DAN=Omfatter forudbetaling;
                                                              ENU=Includes Prepayment] }
    { 18  ;   ;VAT Clause Code     ;Code20        ;TableRelation="VAT Clause";
                                                   CaptionML=[DAN=Momsklausulkode;
                                                              ENU=VAT Clause Code] }
    { 19  ;   ;Tax Category        ;Code10        ;CaptionML=[DAN=Momskategori;
                                                              ENU=Tax Category] }
  }
  KEYS
  {
    {    ;VAT Identifier,VAT Calculation Type,Tax Group Code,Use Tax,Positive;
                                                   Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=%1% moms;ENU=%1% VAT';
      Text001@1001 : TextConst 'DAN=Momsbel›b;ENU=VAT Amount';
      Text002@1002 : TextConst 'DAN=%1 kan ikke v‘re negativ.;ENU=%1 must not be negative.';
      InvoiceDiscAmtIsGreaterThanBaseAmtErr@1003 : TextConst '@@@=1 Invoice Discount Amount that should be set 2 Maximum Amount that you can assign;DAN=Det maksimale %1, som du kan anvende, er %2.;ENU=The maximum %1 that you can apply is %2.';
      Text004@1004 : TextConst 'DAN="%1 for %2 m† ikke overstige %3 = %4.";ENU="%1 for %2 must not exceed %3 = %4."';
      Currency@1005 : Record 4;
      AllowVATDifference@1006 : Boolean;
      GlobalsInitialized@1008 : Boolean;
      Text005@1009 : TextConst 'DAN="%1 m† ikke overskride %2 = %3.";ENU="%1 must not exceed %2 = %3."';

    [External]
    PROCEDURE CheckVATDifference@11(NewCurrencyCode@1000 : Code[10];NewAllowVATDifference@1001 : Boolean);
    VAR
      GLSetup@1003 : Record 98;
    BEGIN
      InitGlobals(NewCurrencyCode,NewAllowVATDifference);
      IF NOT AllowVATDifference THEN
        TESTFIELD("VAT Difference",0);
      IF ABS("VAT Difference") > Currency."Max. VAT Difference Allowed" THEN
        IF NewCurrencyCode <> '' THEN
          ERROR(
            Text004,FIELDCAPTION("VAT Difference"),Currency.Code,
            Currency.FIELDCAPTION("Max. VAT Difference Allowed"),Currency."Max. VAT Difference Allowed")
        ELSE BEGIN
          IF GLSetup.GET THEN;
          IF ABS("VAT Difference") > GLSetup."Max. VAT Difference Allowed" THEN
            ERROR(
              Text005,FIELDCAPTION("VAT Difference"),
              GLSetup.FIELDCAPTION("Max. VAT Difference Allowed"),GLSetup."Max. VAT Difference Allowed");
        END;
    END;

    LOCAL PROCEDURE InitGlobals@4(NewCurrencyCode@1000 : Code[10];NewAllowVATDifference@1001 : Boolean);
    BEGIN
      IF GlobalsInitialized THEN
        EXIT;

      Currency.Initialize(NewCurrencyCode);
      AllowVATDifference := NewAllowVATDifference;
      GlobalsInitialized := TRUE;
    END;

    [External]
    PROCEDURE InsertLine@1();
    VAR
      VATAmountLine@1000 : Record 290;
    BEGIN
      IF ("VAT Base" <> 0) OR ("Amount Including VAT" <> 0) THEN BEGIN
        Positive := "Line Amount" >= 0;
        VATAmountLine := Rec;
        IF FIND THEN BEGIN
          "Line Amount" := "Line Amount" + VATAmountLine."Line Amount";
          "Inv. Disc. Base Amount" := "Inv. Disc. Base Amount" + VATAmountLine."Inv. Disc. Base Amount";
          "Invoice Discount Amount" := "Invoice Discount Amount" + VATAmountLine."Invoice Discount Amount";
          Quantity := Quantity + VATAmountLine.Quantity;
          "VAT Base" := "VAT Base" + VATAmountLine."VAT Base";
          "Amount Including VAT" := "Amount Including VAT" + VATAmountLine."Amount Including VAT";
          "VAT Difference" := "VAT Difference" + VATAmountLine."VAT Difference";
          "VAT Amount" := "Amount Including VAT" - "VAT Base";
          "Calculated VAT Amount" := "Calculated VAT Amount" + VATAmountLine."Calculated VAT Amount";
          MODIFY;
        END ELSE BEGIN
          "VAT Amount" := "Amount Including VAT" - "VAT Base";
          INSERT;
        END;
      END;
    END;

    [External]
    PROCEDURE InsertNewLine@24(VATIdentifier@1000 : Code[20];VATCalcType@1001 : Option;TaxGroupCode@1002 : Code[20];UseTax@1005 : Boolean;TaxRate@1003 : Decimal;IsPositive@1004 : Boolean;IsPrepayment@1006 : Boolean);
    BEGIN
      INIT;
      "VAT Identifier" := VATIdentifier;
      "VAT Calculation Type" := VATCalcType;
      "Tax Group Code" := TaxGroupCode;
      "Use Tax" := UseTax;
      "VAT %" := TaxRate;
      Modified := TRUE;
      Positive := IsPositive;
      "Includes Prepayment" := IsPrepayment;
      INSERT;
    END;

    [External]
    PROCEDURE GetLine@2(Number@1000 : Integer);
    BEGIN
      IF Number = 1 THEN
        FIND('-')
      ELSE
        NEXT;
    END;

    [External]
    PROCEDURE VATAmountText@3() : Text[30];
    BEGIN
      IF COUNT = 1 THEN BEGIN
        FINDFIRST;
        IF "VAT %" <> 0 THEN
          EXIT(STRSUBSTNO(Text000,"VAT %"));
      END;
      EXIT(Text001);
    END;

    [External]
    PROCEDURE GetTotalLineAmount@10(SubtractVAT@1000 : Boolean;CurrencyCode@1001 : Code[10]) : Decimal;
    VAR
      LineAmount@1002 : Decimal;
    BEGIN
      IF SubtractVAT THEN
        Currency.Initialize(CurrencyCode);

      LineAmount := 0;

      IF FIND('-') THEN
        REPEAT
          IF SubtractVAT THEN
            LineAmount :=
              LineAmount + ROUND("Line Amount" / (1 + "VAT %" / 100),Currency."Amount Rounding Precision")
          ELSE
            LineAmount := LineAmount + "Line Amount";
        UNTIL NEXT = 0;

      EXIT(LineAmount);
    END;

    [External]
    PROCEDURE GetTotalVATAmount@5() : Decimal;
    BEGIN
      CALCSUMS("VAT Amount");
      EXIT("VAT Amount");
    END;

    [External]
    PROCEDURE GetTotalInvDiscAmount@9() : Decimal;
    BEGIN
      CALCSUMS("Invoice Discount Amount");
      EXIT("Invoice Discount Amount");
    END;

    [External]
    PROCEDURE GetTotalInvDiscBaseAmount@6(SubtractVAT@1000 : Boolean;CurrencyCode@1001 : Code[10]) : Decimal;
    VAR
      InvDiscBaseAmount@1002 : Decimal;
    BEGIN
      IF SubtractVAT THEN
        Currency.Initialize(CurrencyCode);

      InvDiscBaseAmount := 0;

      IF FIND('-') THEN
        REPEAT
          IF SubtractVAT THEN
            InvDiscBaseAmount :=
              InvDiscBaseAmount +
              ROUND("Inv. Disc. Base Amount" / (1 + "VAT %" / 100),Currency."Amount Rounding Precision")
          ELSE
            InvDiscBaseAmount := InvDiscBaseAmount + "Inv. Disc. Base Amount";
        UNTIL NEXT = 0;
      EXIT(InvDiscBaseAmount);
    END;

    [External]
    PROCEDURE GetTotalVATBase@14() : Decimal;
    BEGIN
      CALCSUMS("VAT Base");
      EXIT("VAT Base");
    END;

    [External]
    PROCEDURE GetTotalAmountInclVAT@17() : Decimal;
    BEGIN
      CALCSUMS("Amount Including VAT");
      EXIT("Amount Including VAT");
    END;

    [External]
    PROCEDURE GetTotalVATDiscount@19(CurrencyCode@1001 : Code[10];NewPricesIncludingVAT@1000 : Boolean) : Decimal;
    VAR
      VATDiscount@1002 : Decimal;
      VATBase@1003 : Decimal;
    BEGIN
      Currency.Initialize(CurrencyCode);

      VATDiscount := 0;

      IF FIND('-') THEN
        REPEAT
          IF NewPricesIncludingVAT THEN
            VATBase += ("Line Amount" - "Invoice Discount Amount") * "VAT %" / (100 + "VAT %")
          ELSE
            VATBase += "VAT Base" * "VAT %" / 100;
          VATDiscount :=
            VATDiscount +
            ROUND(
              VATBase,
              Currency."Amount Rounding Precision",Currency.VATRoundingDirection) -
            "VAT Amount" + "VAT Difference";
          VATBase := VATBase - ROUND(VATBase,Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
        UNTIL NEXT = 0;
      EXIT(VATDiscount);
    END;

    [External]
    PROCEDURE GetAnyLineModified@7() : Boolean;
    BEGIN
      IF FIND('-') THEN
        REPEAT
          IF Modified THEN
            EXIT(TRUE);
        UNTIL NEXT = 0;
      EXIT(FALSE);
    END;

    [External]
    PROCEDURE SetInvoiceDiscountAmount@13(NewInvoiceDiscount@1000 : Decimal;NewCurrencyCode@1001 : Code[10];NewPricesIncludingVAT@1002 : Boolean;NewVATBaseDiscPct@1005 : Decimal);
    VAR
      TotalInvDiscBaseAmount@1003 : Decimal;
      NewRemainder@1004 : Decimal;
    BEGIN
      InitGlobals(NewCurrencyCode,FALSE);
      TotalInvDiscBaseAmount := GetTotalInvDiscBaseAmount(FALSE,Currency.Code);
      IF TotalInvDiscBaseAmount = 0 THEN
        EXIT;
      FIND('-');
      REPEAT
        IF "Inv. Disc. Base Amount" <> 0 THEN BEGIN
          IF TotalInvDiscBaseAmount = 0 THEN
            NewRemainder := 0
          ELSE
            NewRemainder :=
              NewRemainder + NewInvoiceDiscount * "Inv. Disc. Base Amount" / TotalInvDiscBaseAmount;
          IF "Invoice Discount Amount" <> ROUND(NewRemainder,Currency."Amount Rounding Precision") THEN BEGIN
            VALIDATE(
              "Invoice Discount Amount",ROUND(NewRemainder,Currency."Amount Rounding Precision"));
            CalcVATFields(NewCurrencyCode,NewPricesIncludingVAT,NewVATBaseDiscPct);
            Modified := TRUE;
            MODIFY;
          END;
          NewRemainder := NewRemainder - "Invoice Discount Amount";
        END;
      UNTIL NEXT = 0;
    END;

    [External]
    PROCEDURE SetInvoiceDiscountPercent@16(NewInvoiceDiscountPct@1000 : Decimal;NewCurrencyCode@1001 : Code[10];NewPricesIncludingVAT@1002 : Boolean;CalcInvDiscPerVATID@1003 : Boolean;NewVATBaseDiscPct@1005 : Decimal);
    VAR
      NewRemainder@1004 : Decimal;
    BEGIN
      InitGlobals(NewCurrencyCode,FALSE);
      IF FIND('-') THEN
        REPEAT
          IF "Inv. Disc. Base Amount" <> 0 THEN BEGIN
            NewRemainder :=
              NewRemainder + NewInvoiceDiscountPct * "Inv. Disc. Base Amount" / 100;
            IF "Invoice Discount Amount" <> ROUND(NewRemainder,Currency."Amount Rounding Precision") THEN BEGIN
              VALIDATE(
                "Invoice Discount Amount",ROUND(NewRemainder,Currency."Amount Rounding Precision"));
              CalcVATFields(NewCurrencyCode,NewPricesIncludingVAT,NewVATBaseDiscPct);
              "VAT Difference" := 0;
              Modified := TRUE;
              MODIFY;
            END;
            IF CalcInvDiscPerVATID THEN
              NewRemainder := 0
            ELSE
              NewRemainder := NewRemainder - "Invoice Discount Amount";
          END;
        UNTIL NEXT = 0;
    END;

    LOCAL PROCEDURE GetCalculatedVAT@12(NewCurrencyCode@1000 : Code[10];NewPricesIncludingVAT@1001 : Boolean;NewVATBaseDiscPct@1002 : Decimal) : Decimal;
    BEGIN
      InitGlobals(NewCurrencyCode,FALSE);

      IF NewPricesIncludingVAT THEN
        EXIT(
          ROUND(
            ("Line Amount" - "Invoice Discount Amount") * "VAT %" / (100 + "VAT %") * (1 - NewVATBaseDiscPct / 100),
            Currency."Amount Rounding Precision",Currency.VATRoundingDirection));

      EXIT(
        ROUND(
          ("Line Amount" - "Invoice Discount Amount") * "VAT %" / 100 * (1 - NewVATBaseDiscPct / 100),
          Currency."Amount Rounding Precision",Currency.VATRoundingDirection));
    END;

    [External]
    PROCEDURE CalcVATFields@23(NewCurrencyCode@1000 : Code[10];NewPricesIncludingVAT@1001 : Boolean;NewVATBaseDiscPct@1002 : Decimal);
    BEGIN
      InitGlobals(NewCurrencyCode,FALSE);

      "VAT Amount" := GetCalculatedVAT(NewCurrencyCode,NewPricesIncludingVAT,NewVATBaseDiscPct);

      IF NewPricesIncludingVAT THEN BEGIN
        IF NewVATBaseDiscPct = 0 THEN BEGIN
          "Amount Including VAT" := "Line Amount" - "Invoice Discount Amount";
          "VAT Base" := "Amount Including VAT" - "VAT Amount";
        END ELSE BEGIN
          "VAT Base" :=
            ROUND(
              ("Line Amount" - "Invoice Discount Amount") / (1 + "VAT %" / 100),
              Currency."Amount Rounding Precision");
          "Amount Including VAT" := "VAT Base" + "VAT Amount";
        END;
      END ELSE BEGIN
        "VAT Base" := "Line Amount" - "Invoice Discount Amount";
        "Amount Including VAT" := "VAT Base" + "VAT Amount";
      END;
      "Calculated VAT Amount" := "VAT Amount";
      "VAT Difference" := 0;
      Modified := TRUE;
    END;

    LOCAL PROCEDURE CalcValueLCY@18(Value@1003 : Decimal;PostingDate@1006 : Date;CurrencyCode@1005 : Code[10];CurrencyFactor@1004 : Decimal) : Decimal;
    VAR
      CurrencyExchangeRate@1000 : Record 330;
    BEGIN
      EXIT(CurrencyExchangeRate.ExchangeAmtFCYToLCY(PostingDate,CurrencyCode,Value,CurrencyFactor));
    END;

    [External]
    PROCEDURE GetBaseLCY@20(PostingDate@1003 : Date;CurrencyCode@1002 : Code[10];CurrencyFactor@1001 : Decimal) : Decimal;
    BEGIN
      EXIT(ROUND(CalcValueLCY("VAT Base",PostingDate,CurrencyCode,CurrencyFactor)));
    END;

    [External]
    PROCEDURE GetAmountLCY@21(PostingDate@1000 : Date;CurrencyCode@1001 : Code[10];CurrencyFactor@1002 : Decimal) : Decimal;
    BEGIN
      EXIT(
        ROUND(CalcValueLCY("Amount Including VAT",PostingDate,CurrencyCode,CurrencyFactor)) -
        ROUND(CalcValueLCY("VAT Base",PostingDate,CurrencyCode,CurrencyFactor)));
    END;

    [External]
    PROCEDURE DeductVATAmountLine@22(VAR VATAmountLineDeduct@1001 : Record 290);
    BEGIN
      IF FINDSET THEN
        REPEAT
          VATAmountLineDeduct := Rec;
          IF VATAmountLineDeduct.FIND THEN BEGIN
            "VAT Base" -= VATAmountLineDeduct."VAT Base";
            "VAT Amount" -= VATAmountLineDeduct."VAT Amount";
            "Amount Including VAT" -= VATAmountLineDeduct."Amount Including VAT";
            "Line Amount" -= VATAmountLineDeduct."Line Amount";
            "Inv. Disc. Base Amount" -= VATAmountLineDeduct."Inv. Disc. Base Amount";
            "Invoice Discount Amount" -= VATAmountLineDeduct."Invoice Discount Amount";
            "Calculated VAT Amount" -= VATAmountLineDeduct."Calculated VAT Amount";
            "VAT Difference" -= VATAmountLineDeduct."VAT Difference";
            MODIFY;
          END;
        UNTIL NEXT = 0;
    END;

    [External]
    PROCEDURE SumLine@25(LineAmount@1001 : Decimal;InvDiscAmount@1002 : Decimal;VATDifference@1004 : Decimal;AllowInvDisc@1003 : Boolean;Prepayment@1005 : Boolean);
    BEGIN
      "Line Amount" += LineAmount;
      IF AllowInvDisc THEN
        "Inv. Disc. Base Amount" += LineAmount;
      "Invoice Discount Amount" += InvDiscAmount;
      "VAT Difference" += VATDifference;
      IF Prepayment THEN
        "Includes Prepayment" := TRUE;
      MODIFY;
    END;

    [External]
    PROCEDURE UpdateLines@100(VAR TotalVATAmount@1010 : Decimal;Currency@1012 : Record 4;CurrencyFactor@1003 : Decimal;PricesIncludingVAT@1009 : Boolean;VATBaseDiscountPerc@1008 : Decimal;TaxAreaCode@1007 : Code[20];TaxLiable@1005 : Boolean;PostingDate@1004 : Date);
    VAR
      PrevVATAmountLine@1001 : Record 290;
      SalesTaxCalculate@1006 : Codeunit 398;
    BEGIN
      IF FINDSET THEN
        REPEAT
          IF (PrevVATAmountLine."VAT Identifier" <> "VAT Identifier") OR
             (PrevVATAmountLine."VAT Calculation Type" <> "VAT Calculation Type") OR
             (PrevVATAmountLine."Tax Group Code" <> "Tax Group Code") OR
             (PrevVATAmountLine."Use Tax" <> "Use Tax")
          THEN
            PrevVATAmountLine.INIT;
          IF PricesIncludingVAT THEN
            CASE "VAT Calculation Type" OF
              "VAT Calculation Type"::"Normal VAT",
              "VAT Calculation Type"::"Reverse Charge VAT":
                BEGIN
                  "VAT Base" :=
                    ROUND(
                      ("Line Amount" - "Invoice Discount Amount") / (1 + "VAT %" / 100),
                      Currency."Amount Rounding Precision") - "VAT Difference";
                  "VAT Amount" :=
                    "VAT Difference" +
                    ROUND(
                      PrevVATAmountLine."VAT Amount" +
                      ("Line Amount" - "Invoice Discount Amount" - "VAT Base" - "VAT Difference") *
                      (1 - VATBaseDiscountPerc / 100),
                      Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
                  "Amount Including VAT" := "VAT Base" + "VAT Amount";
                  IF Positive THEN
                    PrevVATAmountLine.INIT
                  ELSE BEGIN
                    PrevVATAmountLine := Rec;
                    PrevVATAmountLine."VAT Amount" :=
                      ("Line Amount" - "Invoice Discount Amount" - "VAT Base" - "VAT Difference") *
                      (1 - VATBaseDiscountPerc / 100);
                    PrevVATAmountLine."VAT Amount" :=
                      PrevVATAmountLine."VAT Amount" -
                      ROUND(PrevVATAmountLine."VAT Amount",Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
                  END;
                END;
              "VAT Calculation Type"::"Full VAT":
                BEGIN
                  "VAT Base" := 0;
                  "VAT Amount" := "VAT Difference" + "Line Amount" - "Invoice Discount Amount";
                  "Amount Including VAT" := "VAT Amount";
                END;
              "VAT Calculation Type"::"Sales Tax":
                BEGIN
                  "Amount Including VAT" := "Line Amount" - "Invoice Discount Amount";
                  IF "Use Tax" THEN
                    "VAT Base" := "Amount Including VAT"
                  ELSE
                    "VAT Base" :=
                      ROUND(
                        SalesTaxCalculate.ReverseCalculateTax(
                          TaxAreaCode,"Tax Group Code",TaxLiable,PostingDate,"Amount Including VAT",Quantity,CurrencyFactor),
                        Currency."Amount Rounding Precision");
                  "VAT Amount" := "VAT Difference" + "Amount Including VAT" - "VAT Base";
                  IF "VAT Base" = 0 THEN
                    "VAT %" := 0
                  ELSE
                    "VAT %" := ROUND(100 * "VAT Amount" / "VAT Base",0.00001);
                END;
            END
          ELSE
            CASE "VAT Calculation Type" OF
              "VAT Calculation Type"::"Normal VAT",
              "VAT Calculation Type"::"Reverse Charge VAT":
                BEGIN
                  "VAT Base" := "Line Amount" - "Invoice Discount Amount";
                  "VAT Amount" :=
                    "VAT Difference" +
                    ROUND(
                      PrevVATAmountLine."VAT Amount" +
                      "VAT Base" * "VAT %" / 100 * (1 - VATBaseDiscountPerc / 100),
                      Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
                  "Amount Including VAT" := "Line Amount" - "Invoice Discount Amount" + "VAT Amount";
                  IF Positive THEN
                    PrevVATAmountLine.INIT
                  ELSE
                    IF NOT "Includes Prepayment" THEN BEGIN
                      PrevVATAmountLine := Rec;
                      PrevVATAmountLine."VAT Amount" :=
                        "VAT Base" * "VAT %" / 100 * (1 - VATBaseDiscountPerc / 100);
                      PrevVATAmountLine."VAT Amount" :=
                        PrevVATAmountLine."VAT Amount" -
                        ROUND(PrevVATAmountLine."VAT Amount",Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
                    END;
                END;
              "VAT Calculation Type"::"Full VAT":
                BEGIN
                  "VAT Base" := 0;
                  "VAT Amount" := "VAT Difference" + "Line Amount" - "Invoice Discount Amount";
                  "Amount Including VAT" := "VAT Amount";
                END;
              "VAT Calculation Type"::"Sales Tax":
                BEGIN
                  "VAT Base" := "Line Amount" - "Invoice Discount Amount";
                  IF "Use Tax" THEN
                    "VAT Amount" := 0
                  ELSE
                    "VAT Amount" :=
                      SalesTaxCalculate.CalculateTax(
                        TaxAreaCode,"Tax Group Code",TaxLiable,PostingDate,"VAT Base",Quantity,CurrencyFactor);
                  IF "VAT Base" = 0 THEN
                    "VAT %" := 0
                  ELSE
                    "VAT %" := ROUND(100 * "VAT Amount" / "VAT Base",0.00001);
                  "VAT Amount" :=
                    "VAT Difference" +
                    ROUND("VAT Amount",Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
                  "Amount Including VAT" := "VAT Base" + "VAT Amount";
                END;
            END;

          TotalVATAmount -= "VAT Amount";
          "Calculated VAT Amount" := "VAT Amount" - "VAT Difference";
          MODIFY;
        UNTIL NEXT = 0;
    END;

    [External]
    PROCEDURE CopyFromPurchInvLine@8(PurchInvLine@1000 : Record 123);
    BEGIN
      "VAT Identifier" := PurchInvLine."VAT Identifier";
      "VAT Calculation Type" := PurchInvLine."VAT Calculation Type";
      "Tax Group Code" := PurchInvLine."Tax Group Code";
      "Use Tax" := PurchInvLine."Use Tax";
      "VAT %" := PurchInvLine."VAT %";
      "VAT Base" := PurchInvLine.Amount;
      "VAT Amount" := PurchInvLine."Amount Including VAT" - PurchInvLine.Amount;
      "Amount Including VAT" := PurchInvLine."Amount Including VAT";
      "Line Amount" := PurchInvLine."Line Amount";
      IF PurchInvLine."Allow Invoice Disc." THEN
        "Inv. Disc. Base Amount" := PurchInvLine."Line Amount";
      "Invoice Discount Amount" := PurchInvLine."Inv. Discount Amount";
      Quantity := PurchInvLine."Quantity (Base)";
      "Calculated VAT Amount" :=
        PurchInvLine."Amount Including VAT" - PurchInvLine.Amount - PurchInvLine."VAT Difference";
      "VAT Difference" := PurchInvLine."VAT Difference";
    END;

    [External]
    PROCEDURE CopyFromPurchCrMemoLine@26(PurchCrMemoLine@1000 : Record 125);
    BEGIN
      "VAT Identifier" := PurchCrMemoLine."VAT Identifier";
      "VAT Calculation Type" := PurchCrMemoLine."VAT Calculation Type";
      "Tax Group Code" := PurchCrMemoLine."Tax Group Code";
      "Use Tax" := PurchCrMemoLine."Use Tax";
      "VAT %" := PurchCrMemoLine."VAT %";
      "VAT Base" := PurchCrMemoLine.Amount;
      "VAT Amount" := PurchCrMemoLine."Amount Including VAT" - PurchCrMemoLine.Amount;
      "Amount Including VAT" := PurchCrMemoLine."Amount Including VAT";
      "Line Amount" := PurchCrMemoLine."Line Amount";
      IF PurchCrMemoLine."Allow Invoice Disc." THEN
        "Inv. Disc. Base Amount" := PurchCrMemoLine."Line Amount";
      "Invoice Discount Amount" := PurchCrMemoLine."Inv. Discount Amount";
      Quantity := PurchCrMemoLine."Quantity (Base)";
      "Calculated VAT Amount" :=
        PurchCrMemoLine."Amount Including VAT" - PurchCrMemoLine.Amount - PurchCrMemoLine."VAT Difference";
      "VAT Difference" := PurchCrMemoLine."VAT Difference";
    END;

    [External]
    PROCEDURE CopyFromSalesInvLine@28(SalesInvLine@1000 : Record 113);
    BEGIN
      "VAT Identifier" := SalesInvLine."VAT Identifier";
      "VAT Calculation Type" := SalesInvLine."VAT Calculation Type";
      "Tax Group Code" := SalesInvLine."Tax Group Code";
      "VAT %" := SalesInvLine."VAT %";
      "VAT Base" := SalesInvLine.Amount;
      "VAT Amount" := SalesInvLine."Amount Including VAT" - SalesInvLine.Amount;
      "Amount Including VAT" := SalesInvLine."Amount Including VAT";
      "Line Amount" := SalesInvLine."Line Amount";
      IF SalesInvLine."Allow Invoice Disc." THEN
        "Inv. Disc. Base Amount" := SalesInvLine."Line Amount";
      "Invoice Discount Amount" := SalesInvLine."Inv. Discount Amount";
      Quantity := SalesInvLine."Quantity (Base)";
      "Calculated VAT Amount" :=
        SalesInvLine."Amount Including VAT" - SalesInvLine.Amount - SalesInvLine."VAT Difference";
      "VAT Difference" := SalesInvLine."VAT Difference";
    END;

    [External]
    PROCEDURE CopyFromSalesCrMemoLine@27(SalesCrMemoLine@1000 : Record 115);
    BEGIN
      "VAT Identifier" := SalesCrMemoLine."VAT Identifier";
      "VAT Calculation Type" := SalesCrMemoLine."VAT Calculation Type";
      "Tax Group Code" := SalesCrMemoLine."Tax Group Code";
      "VAT %" := SalesCrMemoLine."VAT %";
      "VAT Base" := SalesCrMemoLine.Amount;
      "VAT Amount" := SalesCrMemoLine."Amount Including VAT" - SalesCrMemoLine.Amount;
      "Amount Including VAT" := SalesCrMemoLine."Amount Including VAT";
      "Line Amount" := SalesCrMemoLine."Line Amount";
      IF SalesCrMemoLine."Allow Invoice Disc." THEN
        "Inv. Disc. Base Amount" := SalesCrMemoLine."Line Amount";
      "Invoice Discount Amount" := SalesCrMemoLine."Inv. Discount Amount";
      Quantity := SalesCrMemoLine."Quantity (Base)";
      "Calculated VAT Amount" := SalesCrMemoLine."Amount Including VAT" - SalesCrMemoLine.Amount - SalesCrMemoLine."VAT Difference";
      "VAT Difference" := SalesCrMemoLine."VAT Difference";
    END;

    [External]
    PROCEDURE CopyFromServInvLine@29(ServInvLine@1000 : Record 5993);
    BEGIN
      "VAT Identifier" := ServInvLine."VAT Identifier";
      "VAT Calculation Type" := ServInvLine."VAT Calculation Type";
      "Tax Group Code" := ServInvLine."Tax Group Code";
      "VAT %" := ServInvLine."VAT %";
      "VAT Base" := ServInvLine.Amount;
      "VAT Amount" := ServInvLine."Amount Including VAT" - ServInvLine.Amount;
      "Amount Including VAT" := ServInvLine."Amount Including VAT";
      "Line Amount" := ServInvLine."Line Amount";
      IF ServInvLine."Allow Invoice Disc." THEN
        "Inv. Disc. Base Amount" := ServInvLine."Line Amount";
      "Invoice Discount Amount" := ServInvLine."Inv. Discount Amount";
      Quantity := ServInvLine."Quantity (Base)";
      "Calculated VAT Amount" :=
        ServInvLine."Amount Including VAT" - ServInvLine.Amount - ServInvLine."VAT Difference";
      "VAT Difference" := ServInvLine."VAT Difference";
    END;

    [External]
    PROCEDURE CopyFromServCrMemoLine@30(ServCrMemoLine@1000 : Record 5995);
    BEGIN
      "VAT Identifier" := ServCrMemoLine."VAT Identifier";
      "VAT Calculation Type" := ServCrMemoLine."VAT Calculation Type";
      "Tax Group Code" := ServCrMemoLine."Tax Group Code";
      "VAT %" := ServCrMemoLine."VAT %";
      "VAT Base" := ServCrMemoLine.Amount;
      "VAT Amount" := ServCrMemoLine."Amount Including VAT" - ServCrMemoLine.Amount;
      "Amount Including VAT" := ServCrMemoLine."Amount Including VAT";
      "Line Amount" := ServCrMemoLine."Line Amount";
      IF ServCrMemoLine."Allow Invoice Disc." THEN
        "Inv. Disc. Base Amount" := ServCrMemoLine."Line Amount";
      "Invoice Discount Amount" := ServCrMemoLine."Inv. Discount Amount";
      Quantity := ServCrMemoLine."Quantity (Base)";
      "Calculated VAT Amount" :=
        ServCrMemoLine."Amount Including VAT" - ServCrMemoLine.Amount - ServCrMemoLine."VAT Difference";
      "VAT Difference" := ServCrMemoLine."VAT Difference";
    END;

    BEGIN
    END.
  }
}

