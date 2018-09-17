OBJECT Table 461 Prepayment Inv. Line Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Buffer for forudbetalingsfakturalinje;
               ENU=Prepayment Inv. Line Buffer];
  }
  FIELDS
  {
    { 1   ;   ;G/L Account No.     ;Code20        ;TableRelation="G/L Account";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Finanskontonr.;
                                                              ENU=G/L Account No.] }
    { 2   ;   ;Line No.            ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Linjenr.;
                                                              ENU=Line No.] }
    { 3   ;   ;Amount              ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bel�b;
                                                              ENU=Amount];
                                                   AutoFormatType=2 }
    { 4   ;   ;Description         ;Text50        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 5   ;   ;Gen. Bus. Posting Group;Code20     ;TableRelation="Gen. Business Posting Group";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Virksomhedsbogf�ringsgruppe;
                                                              ENU=Gen. Bus. Posting Group] }
    { 6   ;   ;Gen. Prod. Posting Group;Code20    ;TableRelation="Gen. Product Posting Group";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Produktbogf�ringsgruppe;
                                                              ENU=Gen. Prod. Posting Group] }
    { 7   ;   ;VAT Bus. Posting Group;Code20      ;TableRelation="VAT Business Posting Group";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Momsvirksomhedsbogf.gruppe;
                                                              ENU=VAT Bus. Posting Group] }
    { 8   ;   ;VAT Prod. Posting Group;Code20     ;TableRelation="VAT Product Posting Group";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Momsproduktbogf.gruppe;
                                                              ENU=VAT Prod. Posting Group] }
    { 9   ;   ;VAT Amount          ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Momsbel�b;
                                                              ENU=VAT Amount];
                                                   AutoFormatType=1 }
    { 10  ;   ;VAT Calculation Type;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Momsberegningstype;
                                                              ENU=VAT Calculation Type];
                                                   OptionCaptionML=[DAN=Normal moms,Modtagermoms,Momskorrektion,Sales tax;
                                                                    ENU=Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax];
                                                   OptionString=Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax }
    { 11  ;   ;VAT Base Amount     ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Momsgrundlag (bel�b);
                                                              ENU=VAT Base Amount];
                                                   AutoFormatType=1 }
    { 12  ;   ;Amount (ACY)        ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bel�b (EV);
                                                              ENU=Amount (ACY)];
                                                   AutoFormatType=1 }
    { 13  ;   ;VAT Amount (ACY)    ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Momsbel�b (EV);
                                                              ENU=VAT Amount (ACY)];
                                                   AutoFormatType=1 }
    { 14  ;   ;VAT Base Amount (ACY);Decimal      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Momsgrundl.bel�b (EV);
                                                              ENU=VAT Base Amount (ACY)];
                                                   AutoFormatType=1 }
    { 15  ;   ;VAT Difference      ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Momsdifference;
                                                              ENU=VAT Difference];
                                                   AutoFormatType=1 }
    { 16  ;   ;VAT %               ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Momspct.;
                                                              ENU=VAT %];
                                                   DecimalPlaces=1:1 }
    { 17  ;   ;VAT Identifier      ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Moms-id;
                                                              ENU=VAT Identifier];
                                                   Editable=No }
    { 19  ;   ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Global dimension 1-kode;
                                                              ENU=Global Dimension 1 Code];
                                                   CaptionClass='1,1,1' }
    { 20  ;   ;Global Dimension 2 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Global dimension 2-kode;
                                                              ENU=Global Dimension 2 Code];
                                                   CaptionClass='1,1,2' }
    { 21  ;   ;Job No.             ;Code20        ;TableRelation=Job;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Sagsnr.;
                                                              ENU=Job No.] }
    { 22  ;   ;Amount Incl. VAT    ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bel�b inkl. moms;
                                                              ENU=Amount Incl. VAT];
                                                   AutoFormatType=1 }
    { 24  ;   ;Tax Area Code       ;Code20        ;TableRelation="Tax Area";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Skatteomr�dekode;
                                                              ENU=Tax Area Code] }
    { 25  ;   ;Tax Liable          ;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Skattepligtig;
                                                              ENU=Tax Liable] }
    { 26  ;   ;Tax Group Code      ;Code20        ;TableRelation="Tax Group";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Skattegruppekode;
                                                              ENU=Tax Group Code] }
    { 27  ;   ;Invoice Rounding    ;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Fakturaafrunding;
                                                              ENU=Invoice Rounding] }
    { 28  ;   ;Adjustment          ;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Regulering;
                                                              ENU=Adjustment] }
    { 480 ;   ;Dimension Set ID    ;Integer       ;TableRelation="Dimension Set Entry";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dimensionsgruppe-id;
                                                              ENU=Dimension Set ID];
                                                   Editable=No }
    { 1001;   ;Job Task No.        ;Code20        ;TableRelation="Job Task";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Sagsopgavenr.;
                                                              ENU=Job Task No.] }
  }
  KEYS
  {
    {    ;G/L Account No.,Job No.,Tax Area Code,Tax Liable,Tax Group Code,Invoice Rounding,Adjustment,Line No.,Dimension Set ID;
                                                   SumIndexFields=Amount,Amount Incl. VAT;
                                                   Clustered=Yes }
    {    ;Adjustment                               }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    [External]
    PROCEDURE IncrAmounts@1(PrepmtInvLineBuf@1001 : Record 461);
    BEGIN
      Amount := Amount + PrepmtInvLineBuf.Amount;
      "Amount Incl. VAT" := "Amount Incl. VAT" + PrepmtInvLineBuf."Amount Incl. VAT";
      "VAT Amount" := "VAT Amount" + PrepmtInvLineBuf."VAT Amount";
      "VAT Base Amount" := "VAT Base Amount" + PrepmtInvLineBuf."VAT Base Amount";
      "Amount (ACY)" := "Amount (ACY)" + PrepmtInvLineBuf."Amount (ACY)";
      "VAT Amount (ACY)" := "VAT Amount (ACY)" + PrepmtInvLineBuf."VAT Amount (ACY)";
      "VAT Base Amount (ACY)" := "VAT Base Amount (ACY)" + PrepmtInvLineBuf."VAT Base Amount (ACY)";
      "VAT Difference" := "VAT Difference" + PrepmtInvLineBuf."VAT Difference";
    END;

    [External]
    PROCEDURE ReverseAmounts@2();
    BEGIN
      Amount := -Amount;
      "Amount Incl. VAT" := -"Amount Incl. VAT";
      "VAT Amount" := -"VAT Amount";
      "VAT Base Amount" := -"VAT Base Amount";
      "Amount (ACY)" := -"Amount (ACY)";
      "VAT Amount (ACY)" := -"VAT Amount (ACY)";
      "VAT Base Amount (ACY)" := -"VAT Base Amount (ACY)";
      "VAT Difference" := -"VAT Difference";
    END;

    [External]
    PROCEDURE SetAmounts@12(AmountLCY@1000 : Decimal;AmountInclVAT@1001 : Decimal;VATBaseAmount@1002 : Decimal;AmountACY@1003 : Decimal;VATBaseAmountACY@1004 : Decimal;VATDifference@1005 : Decimal);
    BEGIN
      Amount := AmountLCY;
      "Amount Incl. VAT" := AmountInclVAT;
      "VAT Base Amount" := VATBaseAmount;
      "Amount (ACY)" := AmountACY;
      "VAT Base Amount (ACY)" := VATBaseAmountACY;
      "VAT Difference" := VATDifference;
    END;

    [External]
    PROCEDURE InsertInvLineBuffer@3(PrepmtInvLineBuf2@1000 : Record 461);
    BEGIN
      Rec := PrepmtInvLineBuf2;
      IF FIND THEN BEGIN
        IncrAmounts(PrepmtInvLineBuf2);
        MODIFY;
      END ELSE
        INSERT;
    END;

    [External]
    PROCEDURE CopyWithLineNo@4(PrepmtInvLineBuf@1001 : Record 461;LineNo@1002 : Integer);
    BEGIN
      Rec := PrepmtInvLineBuf;
      "Line No." := LineNo;
      INSERT;
    END;

    [External]
    PROCEDURE CopyFromPurchLine@11(PurchLine@1000 : Record 39);
    BEGIN
      "Gen. Prod. Posting Group" := PurchLine."Gen. Prod. Posting Group";
      "VAT Prod. Posting Group" := PurchLine."VAT Prod. Posting Group";
      "Gen. Bus. Posting Group" := PurchLine."Gen. Bus. Posting Group";
      "VAT Bus. Posting Group" := PurchLine."VAT Bus. Posting Group";
      "VAT Calculation Type" := PurchLine."Prepmt. VAT Calc. Type";
      "VAT Identifier" := PurchLine."Prepayment VAT Identifier";
      "VAT %" := PurchLine."VAT %";
      "Global Dimension 1 Code" := PurchLine."Shortcut Dimension 1 Code";
      "Global Dimension 2 Code" := PurchLine."Shortcut Dimension 2 Code";
      "Dimension Set ID" := PurchLine."Dimension Set ID";
      "Job No." := PurchLine."Job No.";
      "Job Task No." := PurchLine."Job Task No.";
      "Tax Area Code" := PurchLine."Tax Area Code";
      "Tax Liable" := PurchLine."Tax Liable";
      "Tax Group Code" := PurchLine."Tax Group Code";
    END;

    [External]
    PROCEDURE CopyFromSalesLine@13(SalesLine@1000 : Record 37);
    BEGIN
      "Gen. Prod. Posting Group" := SalesLine."Gen. Prod. Posting Group";
      "VAT Prod. Posting Group" := SalesLine."VAT Prod. Posting Group";
      "Gen. Bus. Posting Group" := SalesLine."Gen. Bus. Posting Group";
      "VAT Bus. Posting Group" := SalesLine."VAT Bus. Posting Group";
      "VAT Calculation Type" := SalesLine."Prepmt. VAT Calc. Type";
      "VAT Identifier" := SalesLine."Prepayment VAT Identifier";
      "VAT %" := SalesLine."VAT %";
      "Global Dimension 1 Code" := SalesLine."Shortcut Dimension 1 Code";
      "Global Dimension 2 Code" := SalesLine."Shortcut Dimension 2 Code";
      "Dimension Set ID" := SalesLine."Dimension Set ID";
      "Job No." := SalesLine."Job No.";
      "Job Task No." := SalesLine."Job Task No.";
      "Tax Area Code" := SalesLine."Tax Area Code";
      "Tax Liable" := SalesLine."Tax Liable";
      "Tax Group Code" := SalesLine."Tax Group Code";
    END;

    [External]
    PROCEDURE SetFilterOnPKey@5(PrepmtInvLineBuf@1001 : Record 461);
    BEGIN
      RESET;
      SETRANGE("G/L Account No.",PrepmtInvLineBuf."G/L Account No.");
      SETRANGE("Dimension Set ID",PrepmtInvLineBuf."Dimension Set ID");
      SETRANGE("Job No.",PrepmtInvLineBuf."Job No.");
      SETRANGE("Tax Area Code",PrepmtInvLineBuf."Tax Area Code");
      SETRANGE("Tax Liable",PrepmtInvLineBuf."Tax Liable");
      SETRANGE("Tax Group Code",PrepmtInvLineBuf."Tax Group Code");
      SETRANGE("Invoice Rounding",PrepmtInvLineBuf."Invoice Rounding");
      SETRANGE(Adjustment,PrepmtInvLineBuf.Adjustment);
      IF PrepmtInvLineBuf."Line No." <> 0 THEN
        SETRANGE("Line No.",PrepmtInvLineBuf."Line No.");
    END;

    [External]
    PROCEDURE FillAdjInvLineBuffer@6(PrepmtInvLineBuf@1000 : Record 461;GLAccountNo@1003 : Code[20];CorrAmount@1002 : Decimal;CorrAmountACY@1001 : Decimal);
    BEGIN
      INIT;
      Adjustment := TRUE;
      "G/L Account No." := GLAccountNo;
      Amount := CorrAmount;
      "Amount Incl. VAT" := CorrAmount;
      "Amount (ACY)" := CorrAmountACY;
      "Line No." := PrepmtInvLineBuf."Line No.";
      "Global Dimension 1 Code" := PrepmtInvLineBuf."Global Dimension 1 Code";
      "Global Dimension 2 Code" := PrepmtInvLineBuf."Global Dimension 2 Code";
      "Dimension Set ID" := PrepmtInvLineBuf."Dimension Set ID";
      Description := PrepmtInvLineBuf.Description;
    END;

    [External]
    PROCEDURE FillFromGLAcc@7(CompressPrepayment@1002 : Boolean);
    VAR
      GLAcc@1001 : Record 15;
    BEGIN
      GLAcc.GET("G/L Account No.");
      "Gen. Prod. Posting Group" := GLAcc."Gen. Prod. Posting Group";
      "VAT Prod. Posting Group" := GLAcc."VAT Prod. Posting Group";
      IF CompressPrepayment THEN
        Description := GLAcc.Name;
    END;

    [External]
    PROCEDURE AdjustVATBase@8(VATAdjustment@1002 : ARRAY [2] OF Decimal);
    BEGIN
      IF Amount <> "Amount Incl. VAT" THEN BEGIN
        Amount := Amount + VATAdjustment[1];
        "VAT Base Amount" := Amount;
        "VAT Amount" := "VAT Amount" + VATAdjustment[2];
        "Amount Incl. VAT" := Amount + "VAT Amount";
      END;
    END;

    [External]
    PROCEDURE AmountsToArray@9(VAR VATAmount@1001 : ARRAY [2] OF Decimal);
    BEGIN
      VATAmount[1] := Amount;
      VATAmount[2] := "Amount Incl. VAT" - Amount;
    END;

    [External]
    PROCEDURE CompressBuffer@10();
    VAR
      TempPrepmtInvLineBuffer2@1000 : TEMPORARY Record 461;
    BEGIN
      FIND('-');
      REPEAT
        TempPrepmtInvLineBuffer2 := Rec;
        TempPrepmtInvLineBuffer2."Line No." := 0;
        IF TempPrepmtInvLineBuffer2.FIND THEN BEGIN
          TempPrepmtInvLineBuffer2.IncrAmounts(Rec);
          TempPrepmtInvLineBuffer2.MODIFY;
        END ELSE
          TempPrepmtInvLineBuffer2.INSERT;
      UNTIL NEXT = 0;

      DELETEALL;

      TempPrepmtInvLineBuffer2.FIND('-');
      REPEAT
        Rec := TempPrepmtInvLineBuffer2;
        INSERT;
      UNTIL TempPrepmtInvLineBuffer2.NEXT = 0;
    END;

    [External]
    PROCEDURE UpdateVATAmounts@14();
    VAR
      GLSetup@1000 : Record 98;
      Currency@1002 : Record 4;
      VATPostingSetup@1001 : Record 325;
    BEGIN
      GLSetup.GET;
      Currency.Initialize(GLSetup."Additional Reporting Currency");
      VATPostingSetup.GET("VAT Bus. Posting Group","VAT Prod. Posting Group");
      "VAT Amount" := ROUND(Amount * VATPostingSetup."VAT %" / 100);
      "VAT Amount (ACY)" := ROUND("Amount (ACY)" * VATPostingSetup."VAT %" / 100,Currency."Amount Rounding Precision");
    END;

    BEGIN
    END.
  }
}

