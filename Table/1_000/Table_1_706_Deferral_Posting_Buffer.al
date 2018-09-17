OBJECT Table 1706 Deferral Posting Buffer
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Periodiseringsbogf�ringsbuffer;
               ENU=Deferral Posting Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=L�benummer;
                                                              ENU=Entry No.] }
    { 2   ;   ;Type                ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=Forudb. val.kursdiff.,Finanskonto,Vare,Ressource,Anl�g;
                                                                    ENU=Prepmt. Exch. Rate Difference,G/L Account,Item,Resource,Fixed Asset];
                                                   OptionString=Prepmt. Exch. Rate Difference,G/L Account,Item,Resource,Fixed Asset }
    { 3   ;   ;G/L Account         ;Code20        ;TableRelation="G/L Account" WHERE (Account Type=CONST(Posting),
                                                                                      Blocked=CONST(No));
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Finanskonto;
                                                              ENU=G/L Account];
                                                   NotBlank=Yes }
    { 4   ;   ;Gen. Bus. Posting Group;Code20     ;TableRelation="Gen. Business Posting Group";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Virksomhedsbogf�ringsgruppe;
                                                              ENU=Gen. Bus. Posting Group] }
    { 5   ;   ;Gen. Prod. Posting Group;Code20    ;TableRelation="Gen. Product Posting Group";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Produktbogf�ringsgruppe;
                                                              ENU=Gen. Prod. Posting Group] }
    { 6   ;   ;VAT Bus. Posting Group;Code20      ;TableRelation="VAT Business Posting Group";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Momsvirksomhedsbogf.gruppe;
                                                              ENU=VAT Bus. Posting Group] }
    { 7   ;   ;VAT Prod. Posting Group;Code20     ;TableRelation="VAT Product Posting Group";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Momsproduktbogf.gruppe;
                                                              ENU=VAT Prod. Posting Group] }
    { 8   ;   ;Tax Area Code       ;Code20        ;TableRelation="Tax Area";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Skatteomr�dekode;
                                                              ENU=Tax Area Code] }
    { 9   ;   ;Tax Group Code      ;Code20        ;TableRelation="Tax Group";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Skattegruppekode;
                                                              ENU=Tax Group Code] }
    { 10  ;   ;Tax Liable          ;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Skattepligtig;
                                                              ENU=Tax Liable] }
    { 11  ;   ;Use Tax             ;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Use tax;
                                                              ENU=Use Tax] }
    { 12  ;   ;Job No.             ;Code20        ;TableRelation=Job;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Sagsnr.;
                                                              ENU=Job No.] }
    { 13  ;   ;Posting Date        ;Date          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bogf�ringsdato;
                                                              ENU=Posting Date] }
    { 14  ;   ;Amount              ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bel�b;
                                                              ENU=Amount] }
    { 15  ;   ;Amount (LCY)        ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bel�b (RV);
                                                              ENU=Amount (LCY)] }
    { 16  ;   ;System-Created Entry;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Automatisk oprettet;
                                                              ENU=System-Created Entry] }
    { 17  ;   ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Global dimension 1-kode;
                                                              ENU=Global Dimension 1 Code];
                                                   CaptionClass='1,1,1' }
    { 18  ;   ;Global Dimension 2 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Global dimension 2-kode;
                                                              ENU=Global Dimension 2 Code];
                                                   CaptionClass='1,1,2' }
    { 19  ;   ;Description         ;Text50        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 20  ;   ;Deferral Account    ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Periodiseringskonto;
                                                              ENU=Deferral Account] }
    { 21  ;   ;Period Description  ;Text50        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Periodebeskrivelse;
                                                              ENU=Period Description] }
    { 22  ;   ;Deferral Doc. Type  ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Periodiseringsdok.type;
                                                              ENU=Deferral Doc. Type];
                                                   OptionCaptionML=[DAN=K�b,Salg,Finans;
                                                                    ENU=Purchase,Sales,G/L];
                                                   OptionString=Purchase,Sales,G/L }
    { 23  ;   ;Document No.        ;Code20        ;DataClassification=SystemMetadata;
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
    {    ;Entry No.                               ;Clustered=Yes }
    {    ;Type,G/L Account,Gen. Bus. Posting Group,Gen. Prod. Posting Group,VAT Bus. Posting Group,VAT Prod. Posting Group,Tax Area Code,Tax Group Code,Tax Liable,Use Tax,Dimension Set ID,Job No.,Deferral Code,Posting Date,Partial Deferral }
    {    ;Deferral Doc. Type,Document No.,Deferral Line No. }
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
    PROCEDURE PrepareRemainderSales@9(SalesLine@1004 : Record 37;NewAmountLCY@1001 : Decimal;NewAmount@1000 : Decimal;GLAccount@1002 : Code[20];DeferralAccount@1003 : Code[20];DeferralLineNo@1005 : Integer);
    BEGIN
      PrepareRemainderAmounts(NewAmountLCY,NewAmount,GLAccount,DeferralAccount);
      "Gen. Bus. Posting Group" := SalesLine."Gen. Bus. Posting Group";
      "Gen. Prod. Posting Group" := SalesLine."Gen. Prod. Posting Group";
      "VAT Bus. Posting Group" := SalesLine."VAT Bus. Posting Group";
      "VAT Prod. Posting Group" := SalesLine."VAT Prod. Posting Group";
      "Gen. Posting Type" := "Gen. Posting Type"::Sale;
      "Deferral Line No." := DeferralLineNo;
    END;

    [External]
    PROCEDURE PrepareRemainderPurchase@8(PurchaseLine@1004 : Record 39;NewAmountLCY@1001 : Decimal;NewAmount@1000 : Decimal;GLAccount@1002 : Code[20];DeferralAccount@1003 : Code[20];DeferralLineNo@1005 : Integer);
    BEGIN
      PrepareRemainderAmounts(NewAmountLCY,NewAmount,GLAccount,DeferralAccount);
      "Gen. Bus. Posting Group" := PurchaseLine."Gen. Bus. Posting Group";
      "Gen. Prod. Posting Group" := PurchaseLine."Gen. Prod. Posting Group";
      "VAT Bus. Posting Group" := PurchaseLine."VAT Bus. Posting Group";
      "VAT Prod. Posting Group" := PurchaseLine."VAT Prod. Posting Group";
      "Gen. Posting Type" := "Gen. Posting Type"::Purchase;
      "Deferral Line No." := DeferralLineNo;
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

    PROCEDURE InitFromDeferralLine@6(DeferralLine@1000 : Record 1702);
    BEGIN
      "Amount (LCY)" := DeferralLine."Amount (LCY)";
      Amount := DeferralLine.Amount;
      "Sales/Purch Amount (LCY)" := DeferralLine."Amount (LCY)";
      "Sales/Purch Amount" := DeferralLine.Amount;
      "Posting Date" := DeferralLine."Posting Date";
      Description := DeferralLine.Description;
    END;

    PROCEDURE Update@124(DeferralPostBuffer@1001 : Record 1706;InvoicePostBuffer@1000 : Record 49);
    BEGIN
      Rec := DeferralPostBuffer;
      SETCURRENTKEY(
        Type,"G/L Account","Gen. Bus. Posting Group","Gen. Prod. Posting Group",
        "VAT Bus. Posting Group","VAT Prod. Posting Group",
        "Tax Area Code","Tax Group Code","Tax Liable","Use Tax",
        "Dimension Set ID","Job No.","Deferral Code","Posting Date","Partial Deferral");
      SETRANGE(Type,DeferralPostBuffer.Type);
      SETRANGE("G/L Account",DeferralPostBuffer."G/L Account");
      SETRANGE("Gen. Bus. Posting Group",DeferralPostBuffer."Gen. Bus. Posting Group");
      SETRANGE("Gen. Prod. Posting Group",DeferralPostBuffer."Gen. Prod. Posting Group");
      SETRANGE("VAT Bus. Posting Group",DeferralPostBuffer."VAT Bus. Posting Group");
      SETRANGE("VAT Prod. Posting Group",DeferralPostBuffer."VAT Prod. Posting Group");
      SETRANGE("Tax Area Code",DeferralPostBuffer."Tax Area Code");
      SETRANGE("Tax Group Code",DeferralPostBuffer."Tax Group Code");
      SETRANGE("Tax Liable",DeferralPostBuffer."Tax Liable");
      SETRANGE("Use Tax",DeferralPostBuffer."Use Tax");
      SETRANGE("Dimension Set ID",DeferralPostBuffer."Dimension Set ID");
      SETRANGE("Job No.",DeferralPostBuffer."Job No.");
      SETRANGE("Deferral Code",DeferralPostBuffer."Deferral Code");
      SETRANGE("Posting Date",DeferralPostBuffer."Posting Date");
      SETRANGE("Partial Deferral",DeferralPostBuffer."Partial Deferral");
      SETRANGE("Deferral Line No.",DeferralPostBuffer."Deferral Line No.");

      IF FINDFIRST THEN BEGIN
        Amount += DeferralPostBuffer.Amount;
        "Amount (LCY)" += DeferralPostBuffer."Amount (LCY)";
        "Sales/Purch Amount" += DeferralPostBuffer."Sales/Purch Amount";
        "Sales/Purch Amount (LCY)" += DeferralPostBuffer."Sales/Purch Amount (LCY)";
        IF NOT DeferralPostBuffer."System-Created Entry" THEN
          "System-Created Entry" := FALSE;
        IF IsCombinedDeferralZero THEN
          DELETE
        ELSE
          MODIFY;
      END ELSE BEGIN
        "Entry No." := GetLastEntryNo + 1;
        "Dimension Set ID" := InvoicePostBuffer."Dimension Set ID";
        "Global Dimension 1 Code" := InvoicePostBuffer."Global Dimension 1 Code";
        "Global Dimension 2 Code" := InvoicePostBuffer."Global Dimension 2 Code";
        INSERT;
      END;
    END;

    LOCAL PROCEDURE IsCombinedDeferralZero@130() : Boolean;
    BEGIN
      IF (Amount = 0) AND ("Amount (LCY)" = 0) AND
         ("Sales/Purch Amount" = 0) AND ("Sales/Purch Amount (LCY)" = 0)
      THEN
        EXIT(TRUE);

      EXIT(FALSE);
    END;

    LOCAL PROCEDURE GetLastEntryNo@7() : Integer;
    VAR
      DeferralPostingBuffer@1000 : Record 1706;
    BEGIN
      IF DeferralPostingBuffer.FINDLAST THEN
        EXIT(DeferralPostingBuffer."Entry No.");
      EXIT(0);
    END;

    BEGIN
    END.
  }
}

