OBJECT Table 1703 Deferral Post. Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Periodiseringsbogf.buffer;
               ENU=Deferral Post. Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Type                ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=Forudb. val.kursdiff.,Finanskonto,Vare,Ressource,Anl�g;
                                                                    ENU=Prepmt. Exch. Rate Difference,G/L Account,Item,Resource,Fixed Asset];
                                                   OptionString=Prepmt. Exch. Rate Difference,G/L Account,Item,Resource,Fixed Asset }
    { 2   ;   ;G/L Account         ;Code20        ;TableRelation="G/L Account" WHERE (Account Type=CONST(Posting),
                                                                                      Blocked=CONST(No));
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Finanskonto;
                                                              ENU=G/L Account];
                                                   NotBlank=Yes }
    { 3   ;   ;Gen. Bus. Posting Group;Code20     ;TableRelation="Gen. Business Posting Group";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Virksomhedsbogf�ringsgruppe;
                                                              ENU=Gen. Bus. Posting Group] }
    { 4   ;   ;Gen. Prod. Posting Group;Code20    ;TableRelation="Gen. Product Posting Group";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Produktbogf�ringsgruppe;
                                                              ENU=Gen. Prod. Posting Group] }
    { 5   ;   ;VAT Bus. Posting Group;Code20      ;TableRelation="VAT Business Posting Group";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Momsvirksomhedsbogf.gruppe;
                                                              ENU=VAT Bus. Posting Group] }
    { 6   ;   ;VAT Prod. Posting Group;Code20     ;TableRelation="VAT Product Posting Group";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Momsproduktbogf.gruppe;
                                                              ENU=VAT Prod. Posting Group] }
    { 7   ;   ;Tax Area Code       ;Code20        ;TableRelation="Tax Area";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Skatteomr�dekode;
                                                              ENU=Tax Area Code] }
    { 8   ;   ;Tax Group Code      ;Code20        ;TableRelation="Tax Group";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Skattegruppekode;
                                                              ENU=Tax Group Code] }
    { 9   ;   ;Tax Liable          ;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Skattepligtig;
                                                              ENU=Tax Liable] }
    { 10  ;   ;Use Tax             ;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Use tax;
                                                              ENU=Use Tax] }
    { 11  ;   ;Job No.             ;Code20        ;TableRelation=Job;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Sagsnr.;
                                                              ENU=Job No.] }
    { 12  ;   ;Posting Date        ;Date          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bogf�ringsdato;
                                                              ENU=Posting Date] }
    { 13  ;   ;Amount              ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bel�b;
                                                              ENU=Amount] }
    { 14  ;   ;Amount (LCY)        ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bel�b (RV);
                                                              ENU=Amount (LCY)] }
    { 15  ;   ;System-Created Entry;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Automatisk oprettet;
                                                              ENU=System-Created Entry] }
    { 16  ;   ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Global dimension 1-kode;
                                                              ENU=Global Dimension 1 Code];
                                                   CaptionClass='1,1,1' }
    { 17  ;   ;Global Dimension 2 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Global dimension 2-kode;
                                                              ENU=Global Dimension 2 Code];
                                                   CaptionClass='1,1,2' }
    { 18  ;   ;Description         ;Text50        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 19  ;   ;Deferral Account    ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Periodiseringskonto;
                                                              ENU=Deferral Account] }
    { 20  ;   ;Period Description  ;Text50        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Periodebeskrivelse;
                                                              ENU=Period Description] }
    { 21  ;   ;Deferral Doc. Type  ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Periodiseringsdok.type;
                                                              ENU=Deferral Doc. Type];
                                                   OptionCaptionML=[DAN=K�b,Salg,Finans;
                                                                    ENU=Purchase,Sales,G/L];
                                                   OptionString=Purchase,Sales,G/L }
    { 22  ;   ;Document No.        ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.] }
    { 24  ;   ;Sales/Purch Amount  ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Salgs/K�bsbel�b;
                                                              ENU=Sales/Purch Amount] }
    { 25  ;   ;Sales/Purch Amount (LCY);Decimal   ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Salgs/K�bsbel�b (RV);
                                                              ENU=Sales/Purch Amount (LCY)] }
    { 26  ;   ;Gen. Posting Type   ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bogf�ringstype;
                                                              ENU=Gen. Posting Type];
                                                   OptionCaptionML=[DAN=" ,K�b,Salg,Afregning";
                                                                    ENU=" ,Purchase,Sale,Settlement"];
                                                   OptionString=[ ,Purchase,Sale,Settlement] }
    { 27  ;   ;Partial Deferral    ;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Delvis periodisering;
                                                              ENU=Partial Deferral] }
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
  }
  KEYS
  {
    {    ;Type,G/L Account,Gen. Bus. Posting Group,Gen. Prod. Posting Group,VAT Bus. Posting Group,VAT Prod. Posting Group,Tax Area Code,Tax Group Code,Tax Liable,Use Tax,Dimension Set ID,Job No.,Deferral Code,Posting Date,Partial Deferral;
                                                   Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    [External]
    PROCEDURE PrepareSales@1(SalesLine@1000 : Record 37;DocumentNo@1001 : Code[20]);
    VAR
      DeferralUtilities@1002 : Codeunit 1720;
    BEGIN
      CLEAR(Rec);
      Type := SalesLine.Type;
      "System-Created Entry" := TRUE;
      "Global Dimension 1 Code" := SalesLine."Shortcut Dimension 1 Code";
      "Global Dimension 2 Code" := SalesLine."Shortcut Dimension 2 Code";
      "Dimension Set ID" := SalesLine."Dimension Set ID";
      "Job No." := SalesLine."Job No.";

      IF SalesLine."VAT Calculation Type" = SalesLine."VAT Calculation Type"::"Sales Tax" THEN BEGIN
        "Tax Area Code" := SalesLine."Tax Area Code";
        "Tax Group Code" := SalesLine."Tax Group Code";
        "Tax Liable" := SalesLine."Tax Liable";
        "Use Tax" := FALSE;
      END;
      "Deferral Code" := SalesLine."Deferral Code";
      "Deferral Doc. Type" := DeferralUtilities.GetSalesDeferralDocType;
      "Document No." := DocumentNo;
    END;

    [External]
    PROCEDURE ReverseAmounts@2();
    BEGIN
      Amount := -Amount;
      "Amount (LCY)" := -"Amount (LCY)";
      "Sales/Purch Amount" := -"Sales/Purch Amount";
      "Sales/Purch Amount (LCY)" := -"Sales/Purch Amount (LCY)";
    END;

    [External]
    PROCEDURE PreparePurch@3(PurchLine@1000 : Record 39;DocumentNo@1001 : Code[20]);
    VAR
      DeferralUtilities@1002 : Codeunit 1720;
    BEGIN
      CLEAR(Rec);
      Type := PurchLine.Type;
      "System-Created Entry" := TRUE;
      "Global Dimension 1 Code" := PurchLine."Shortcut Dimension 1 Code";
      "Global Dimension 2 Code" := PurchLine."Shortcut Dimension 2 Code";
      "Dimension Set ID" := PurchLine."Dimension Set ID";
      "Job No." := PurchLine."Job No.";

      IF PurchLine."VAT Calculation Type" = PurchLine."VAT Calculation Type"::"Sales Tax" THEN BEGIN
        "Tax Area Code" := PurchLine."Tax Area Code";
        "Tax Group Code" := PurchLine."Tax Group Code";
        "Tax Liable" := PurchLine."Tax Liable";
        "Use Tax" := FALSE;
      END;
      "Deferral Code" := PurchLine."Deferral Code";
      "Deferral Doc. Type" := DeferralUtilities.GetPurchDeferralDocType;
      "Document No." := DocumentNo;
    END;

    LOCAL PROCEDURE PrepareRemainderAmounts@4(NewAmountLCY@1001 : Decimal;NewAmount@1000 : Decimal;GLAccount@1002 : Code[20];DeferralAccount@1003 : Code[20]);
    BEGIN
      "Amount (LCY)" := 0;
      Amount := 0;
      "Sales/Purch Amount (LCY)" := NewAmountLCY;
      "Sales/Purch Amount" := NewAmount;
      "G/L Account" := GLAccount;
      "Deferral Account" := DeferralAccount;
      "Partial Deferral" := TRUE;
    END;

    [External]
    PROCEDURE PrepareRemainderSales@9(SalesLine@1004 : Record 37;NewAmountLCY@1001 : Decimal;NewAmount@1000 : Decimal;GLAccount@1002 : Code[20];DeferralAccount@1003 : Code[20]);
    BEGIN
      PrepareRemainderAmounts(NewAmountLCY,NewAmount,GLAccount,DeferralAccount);
      "Gen. Bus. Posting Group" := SalesLine."Gen. Bus. Posting Group";
      "Gen. Prod. Posting Group" := SalesLine."Gen. Prod. Posting Group";
      "VAT Bus. Posting Group" := SalesLine."VAT Bus. Posting Group";
      "VAT Prod. Posting Group" := SalesLine."VAT Prod. Posting Group";
      "Gen. Posting Type" := "Gen. Posting Type"::Sale;
    END;

    [External]
    PROCEDURE PrepareRemainderPurchase@8(PurchaseLine@1004 : Record 39;NewAmountLCY@1001 : Decimal;NewAmount@1000 : Decimal;GLAccount@1002 : Code[20];DeferralAccount@1003 : Code[20]);
    BEGIN
      PrepareRemainderAmounts(NewAmountLCY,NewAmount,GLAccount,DeferralAccount);
      "Gen. Bus. Posting Group" := PurchaseLine."Gen. Bus. Posting Group";
      "Gen. Prod. Posting Group" := PurchaseLine."Gen. Prod. Posting Group";
      "VAT Bus. Posting Group" := PurchaseLine."VAT Bus. Posting Group";
      "VAT Prod. Posting Group" := PurchaseLine."VAT Prod. Posting Group";
      "Gen. Posting Type" := "Gen. Posting Type"::Purchase;
    END;

    [External]
    PROCEDURE PrepareInitialPair@5(InvoicePostBuffer@1004 : Record 49;RemainAmtToDefer@1001 : Decimal;RemainAmtToDeferACY@1000 : Decimal;GLAccount@1003 : Code[20];DeferralAccount@1002 : Code[20]);
    VAR
      NewAmountLCY@1006 : Decimal;
      NewAmount@1005 : Decimal;
    BEGIN
      IF (RemainAmtToDefer <> 0) OR (RemainAmtToDeferACY <> 0) THEN BEGIN
        NewAmountLCY := RemainAmtToDefer;
        NewAmount := RemainAmtToDeferACY;
      END ELSE BEGIN
        NewAmountLCY := InvoicePostBuffer.Amount;
        NewAmount := InvoicePostBuffer."Amount (ACY)";
      END;
      PrepareRemainderAmounts(NewAmountLCY,NewAmount,DeferralAccount,GLAccount);
      "Amount (LCY)" := NewAmountLCY;
      Amount := NewAmount;
    END;

    BEGIN
    END.
  }
}

