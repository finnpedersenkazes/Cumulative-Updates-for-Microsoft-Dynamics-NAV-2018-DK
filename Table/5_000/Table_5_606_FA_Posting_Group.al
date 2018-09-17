OBJECT Table 5606 FA Posting Group
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    OnDelete=BEGIN
               FAAlloc.SETRANGE(Code,Code);
               FAAlloc.DELETEALL(TRUE);
             END;

    CaptionML=[DAN=Anl‘gsbogf›ringsgruppe;
               ENU=FA Posting Group];
    LookupPageID=Page5613;
    DrillDownPageID=Page5613;
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code20        ;CaptionML=[DAN=Kode;
                                                              ENU=Code];
                                                   NotBlank=Yes }
    { 2   ;   ;Acquisition Cost Account;Code20    ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Acquisition Cost Account",FALSE);
                                                              END;

                                                   CaptionML=[DAN=Anskaffelseskonto;
                                                              ENU=Acquisition Cost Account] }
    { 3   ;   ;Accum. Depreciation Account;Code20 ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Accum. Depreciation Account",FALSE);
                                                              END;

                                                   CaptionML=[DAN=Afskrivningskonto;
                                                              ENU=Accum. Depreciation Account] }
    { 4   ;   ;Write-Down Account  ;Code20        ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Write-Down Account",FALSE);
                                                              END;

                                                   CaptionML=[DAN=Nedskrivningskonto;
                                                              ENU=Write-Down Account] }
    { 5   ;   ;Appreciation Account;Code20        ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Appreciation Account",FALSE);
                                                              END;

                                                   CaptionML=[DAN=Opskrivningskonto;
                                                              ENU=Appreciation Account] }
    { 6   ;   ;Custom 1 Account    ;Code20        ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Custom 1 Account",FALSE);
                                                              END;

                                                   CaptionML=[DAN=Bruger 1 konto;
                                                              ENU=Custom 1 Account] }
    { 7   ;   ;Custom 2 Account    ;Code20        ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Custom 2 Account",FALSE);
                                                              END;

                                                   CaptionML=[DAN=Bruger 2 konto;
                                                              ENU=Custom 2 Account] }
    { 8   ;   ;Acq. Cost Acc. on Disposal;Code20  ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Acq. Cost Acc. on Disposal",FALSE);
                                                              END;

                                                   CaptionML=[DAN=Anskaffelseskonto (afgang);
                                                              ENU=Acq. Cost Acc. on Disposal] }
    { 9   ;   ;Accum. Depr. Acc. on Disposal;Code20;
                                                   TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Accum. Depr. Acc. on Disposal",FALSE);
                                                              END;

                                                   CaptionML=[DAN=Afskrivningskonto (afgang);
                                                              ENU=Accum. Depr. Acc. on Disposal] }
    { 10  ;   ;Write-Down Acc. on Disposal;Code20 ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Write-Down Acc. on Disposal",FALSE);
                                                              END;

                                                   CaptionML=[DAN=Nedskrivningskonto (afgang);
                                                              ENU=Write-Down Acc. on Disposal] }
    { 11  ;   ;Appreciation Acc. on Disposal;Code20;
                                                   TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Appreciation Acc. on Disposal",FALSE);
                                                              END;

                                                   CaptionML=[DAN=Opskrivningskonto (afgang);
                                                              ENU=Appreciation Acc. on Disposal] }
    { 12  ;   ;Custom 1 Account on Disposal;Code20;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Custom 1 Account on Disposal",FALSE);
                                                              END;

                                                   CaptionML=[DAN=Bruger 1 konto (afgang);
                                                              ENU=Custom 1 Account on Disposal] }
    { 13  ;   ;Custom 2 Account on Disposal;Code20;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Custom 2 Account on Disposal",FALSE);
                                                              END;

                                                   CaptionML=[DAN=Bruger 2 konto (afgang);
                                                              ENU=Custom 2 Account on Disposal] }
    { 14  ;   ;Gains Acc. on Disposal;Code20      ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Gains Acc. on Disposal",FALSE);
                                                              END;

                                                   CaptionML=[DAN=Gevinstkonto (afgang);
                                                              ENU=Gains Acc. on Disposal] }
    { 15  ;   ;Losses Acc. on Disposal;Code20     ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Losses Acc. on Disposal",FALSE);
                                                              END;

                                                   CaptionML=[DAN=Tabskonto (afgang);
                                                              ENU=Losses Acc. on Disposal] }
    { 16  ;   ;Book Val. Acc. on Disp. (Gain);Code20;
                                                   TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Book Val. Acc. on Disp. (Gain)",FALSE);
                                                              END;

                                                   CaptionML=[DAN=Bogf. v‘rdikonto (afgang);
                                                              ENU=Book Val. Acc. on Disp. (Gain)] }
    { 17  ;   ;Sales Acc. on Disp. (Gain);Code20  ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Sales Acc. on Disp. (Gain)",FALSE);
                                                              END;

                                                   CaptionML=[DAN=Salgskonto (afgang);
                                                              ENU=Sales Acc. on Disp. (Gain)] }
    { 18  ;   ;Write-Down Bal. Acc. on Disp.;Code20;
                                                   TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Write-Down Bal. Acc. on Disp.",FALSE);
                                                              END;

                                                   CaptionML=[DAN=Nedskr.modkonto (afgang);
                                                              ENU=Write-Down Bal. Acc. on Disp.] }
    { 19  ;   ;Apprec. Bal. Acc. on Disp.;Code20  ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Apprec. Bal. Acc. on Disp.",FALSE);
                                                              END;

                                                   CaptionML=[DAN=Opskr.modkonto (afgang);
                                                              ENU=Apprec. Bal. Acc. on Disp.] }
    { 20  ;   ;Custom 1 Bal. Acc. on Disposal;Code20;
                                                   TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Custom 1 Bal. Acc. on Disposal",FALSE);
                                                              END;

                                                   CaptionML=[DAN=Bruger 1 modkonto (afgang);
                                                              ENU=Custom 1 Bal. Acc. on Disposal] }
    { 21  ;   ;Custom 2 Bal. Acc. on Disposal;Code20;
                                                   TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Custom 2 Bal. Acc. on Disposal",FALSE);
                                                              END;

                                                   CaptionML=[DAN=Bruger 2 modkonto (afgang);
                                                              ENU=Custom 2 Bal. Acc. on Disposal] }
    { 22  ;   ;Maintenance Expense Account;Code20 ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Maintenance Expense Account",FALSE);
                                                              END;

                                                   CaptionML=[DAN=Reparationskonto;
                                                              ENU=Maintenance Expense Account] }
    { 23  ;   ;Maintenance Bal. Acc.;Code20       ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Maintenance Bal. Acc.",TRUE);
                                                              END;

                                                   CaptionML=[DAN=Reparationsmodkonto;
                                                              ENU=Maintenance Bal. Acc.] }
    { 24  ;   ;Acquisition Cost Bal. Acc.;Code20  ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Acquisition Cost Bal. Acc.",TRUE);
                                                              END;

                                                   CaptionML=[DAN=Anskaffelsesmodkonto;
                                                              ENU=Acquisition Cost Bal. Acc.] }
    { 25  ;   ;Depreciation Expense Acc.;Code20   ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Depreciation Expense Acc.",TRUE);
                                                              END;

                                                   CaptionML=[DAN=Afskrivning - driftskonto;
                                                              ENU=Depreciation Expense Acc.] }
    { 26  ;   ;Write-Down Expense Acc.;Code20     ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Write-Down Expense Acc.",TRUE);
                                                              END;

                                                   CaptionML=[DAN=Nedskrivning - driftskonto;
                                                              ENU=Write-Down Expense Acc.] }
    { 27  ;   ;Appreciation Bal. Account;Code20   ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Appreciation Bal. Account",TRUE);
                                                              END;

                                                   CaptionML=[DAN=Opskrivningsmodkonto;
                                                              ENU=Appreciation Bal. Account] }
    { 28  ;   ;Custom 1 Expense Acc.;Code20       ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Custom 1 Expense Acc.",TRUE);
                                                              END;

                                                   CaptionML=[DAN=Bruger 1 modkonto;
                                                              ENU=Custom 1 Expense Acc.] }
    { 29  ;   ;Custom 2 Expense Acc.;Code20       ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Custom 2 Expense Acc.",TRUE);
                                                              END;

                                                   CaptionML=[DAN=Bruger 2 modkonto;
                                                              ENU=Custom 2 Expense Acc.] }
    { 30  ;   ;Sales Bal. Acc.     ;Code20        ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Sales Bal. Acc.",TRUE);
                                                              END;

                                                   CaptionML=[DAN=Salg - modkonto;
                                                              ENU=Sales Bal. Acc.] }
    { 31  ;   ;Allocated Acquisition Cost %;Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("FA Allocation"."Allocation %" WHERE (Code=FIELD(Code),
                                                                                                         Allocation Type=CONST(Acquisition)));
                                                   CaptionML=[DAN=Anskaffelse - fordelt i pct.;
                                                              ENU=Allocated Acquisition Cost %];
                                                   DecimalPlaces=1:1;
                                                   Editable=No }
    { 32  ;   ;Allocated Depreciation %;Decimal   ;FieldClass=FlowField;
                                                   CalcFormula=Sum("FA Allocation"."Allocation %" WHERE (Code=FIELD(Code),
                                                                                                         Allocation Type=CONST(Depreciation)));
                                                   CaptionML=[DAN=Afskrivning - fordelt i pct.;
                                                              ENU=Allocated Depreciation %];
                                                   DecimalPlaces=1:1;
                                                   Editable=No }
    { 33  ;   ;Allocated Write-Down %;Decimal     ;FieldClass=FlowField;
                                                   CalcFormula=Sum("FA Allocation"."Allocation %" WHERE (Code=FIELD(Code),
                                                                                                         Allocation Type=CONST(Write-Down)));
                                                   CaptionML=[DAN=Nedskrivning - fordelt i pct.;
                                                              ENU=Allocated Write-Down %];
                                                   DecimalPlaces=1:1;
                                                   Editable=No }
    { 34  ;   ;Allocated Appreciation %;Decimal   ;FieldClass=FlowField;
                                                   CalcFormula=Sum("FA Allocation"."Allocation %" WHERE (Code=FIELD(Code),
                                                                                                         Allocation Type=CONST(Appreciation)));
                                                   CaptionML=[DAN=Opskrivning - fordelt i pct.;
                                                              ENU=Allocated Appreciation %];
                                                   DecimalPlaces=1:1;
                                                   Editable=No }
    { 35  ;   ;Allocated Custom 1 %;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("FA Allocation"."Allocation %" WHERE (Code=FIELD(Code),
                                                                                                         Allocation Type=CONST(Custom 1)));
                                                   CaptionML=[DAN=Bruger 1 - fordelt i pct.;
                                                              ENU=Allocated Custom 1 %];
                                                   DecimalPlaces=1:1;
                                                   Editable=No }
    { 36  ;   ;Allocated Custom 2 %;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("FA Allocation"."Allocation %" WHERE (Code=FIELD(Code),
                                                                                                         Allocation Type=CONST(Custom 2)));
                                                   CaptionML=[DAN=Bruger 2 - fordelt i pct.;
                                                              ENU=Allocated Custom 2 %];
                                                   DecimalPlaces=1:1;
                                                   Editable=No }
    { 37  ;   ;Allocated Sales Price %;Decimal    ;FieldClass=FlowField;
                                                   CalcFormula=Sum("FA Allocation"."Allocation %" WHERE (Code=FIELD(Code),
                                                                                                         Allocation Type=CONST(Disposal)));
                                                   CaptionML=[DAN=Salgspris - fordelt i pct.;
                                                              ENU=Allocated Sales Price %];
                                                   DecimalPlaces=1:1;
                                                   Editable=No }
    { 38  ;   ;Allocated Maintenance %;Decimal    ;FieldClass=FlowField;
                                                   CalcFormula=Sum("FA Allocation"."Allocation %" WHERE (Code=FIELD(Code),
                                                                                                         Allocation Type=CONST(Maintenance)));
                                                   CaptionML=[DAN=Reparation - fordelt i pct.;
                                                              ENU=Allocated Maintenance %];
                                                   DecimalPlaces=1:1;
                                                   Editable=No }
    { 39  ;   ;Allocated Gain %    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("FA Allocation"."Allocation %" WHERE (Code=FIELD(Code),
                                                                                                         Allocation Type=CONST(Gain)));
                                                   CaptionML=[DAN=Gevinst - fordelt i pct.;
                                                              ENU=Allocated Gain %];
                                                   DecimalPlaces=1:1;
                                                   Editable=No }
    { 40  ;   ;Allocated Loss %    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("FA Allocation"."Allocation %" WHERE (Code=FIELD(Code),
                                                                                                         Allocation Type=CONST(Loss)));
                                                   CaptionML=[DAN=Tab - fordelt i pct.;
                                                              ENU=Allocated Loss %];
                                                   DecimalPlaces=1:1;
                                                   Editable=No }
    { 41  ;   ;Allocated Book Value % (Gain);Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("FA Allocation"."Allocation %" WHERE (Code=FIELD(Code),
                                                                                                         Allocation Type=CONST("Book Value (Gain)")));
                                                   CaptionML=[DAN=Bogf›rt v‘rdi i pct. (gevinst);
                                                              ENU=Allocated Book Value % (Gain)];
                                                   DecimalPlaces=1:1;
                                                   Editable=No }
    { 42  ;   ;Allocated Book Value % (Loss);Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("FA Allocation"."Allocation %" WHERE (Code=FIELD(Code),
                                                                                                         Allocation Type=CONST("Book Value (Loss)")));
                                                   CaptionML=[DAN=Bogf›rt v‘rdi i pct. (tab);
                                                              ENU=Allocated Book Value % (Loss)];
                                                   DecimalPlaces=1:1;
                                                   Editable=No }
    { 43  ;   ;Sales Acc. on Disp. (Loss);Code20  ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Sales Acc. on Disp. (Loss)",FALSE);
                                                              END;

                                                   CaptionML=[DAN=Salgskonto/vinding (afg.);
                                                              ENU=Sales Acc. on Disp. (Loss)] }
    { 44  ;   ;Book Val. Acc. on Disp. (Loss);Code20;
                                                   TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAcc("Book Val. Acc. on Disp. (Loss)",FALSE);
                                                              END;

                                                   CaptionML=[DAN=Bogf. v‘rdikonto (afgang.);
                                                              ENU=Book Val. Acc. on Disp. (Loss)] }
  }
  KEYS
  {
    {    ;Code                                    ;Clustered=Yes }
  }
  FIELDGROUPS
  {
    { 1   ;Brick               ;Code                                     }
  }
  CODE
  {
    VAR
      FAAlloc@1000 : Record 5615;
      GLAcc@1001 : Record 15;

    LOCAL PROCEDURE CheckGLAcc@1(AccNo@1000 : Code[20];DirectPosting@1001 : Boolean);
    BEGIN
      IF AccNo = '' THEN
        EXIT;
      GLAcc.GET(AccNo);
      GLAcc.CheckGLAcc;
      IF DirectPosting THEN
        GLAcc.TESTFIELD("Direct Posting");
    END;

    [External]
    PROCEDURE IsReadyForAcqusition@2() : Boolean;
    BEGIN
      EXIT("Acquisition Cost Account" <> '');
    END;

    [External]
    PROCEDURE GetAcquisitionCostAccount@3() : Code[20];
    BEGIN
      TESTFIELD("Acquisition Cost Account");
      EXIT("Acquisition Cost Account");
    END;

    [External]
    PROCEDURE GetAcquisitionCostAccountOnDisposal@9() : Code[20];
    BEGIN
      TESTFIELD("Acq. Cost Acc. on Disposal");
      EXIT("Acq. Cost Acc. on Disposal");
    END;

    [External]
    PROCEDURE GetAcquisitionCostBalanceAccount@25() : Code[20];
    BEGIN
      TESTFIELD("Acquisition Cost Bal. Acc.");
      EXIT("Acquisition Cost Bal. Acc.");
    END;

    [External]
    PROCEDURE GetAccumDepreciationAccount@4() : Code[20];
    BEGIN
      TESTFIELD("Accum. Depreciation Account");
      EXIT("Accum. Depreciation Account");
    END;

    [External]
    PROCEDURE GetAccumDepreciationAccountOnDisposal@10() : Code[20];
    BEGIN
      TESTFIELD("Accum. Depr. Acc. on Disposal");
      EXIT("Accum. Depr. Acc. on Disposal");
    END;

    [External]
    PROCEDURE GetAppreciationAccount@6() : Code[20];
    BEGIN
      TESTFIELD("Appreciation Account");
      EXIT("Appreciation Account");
    END;

    [External]
    PROCEDURE GetAppreciationAccountOnDisposal@12() : Code[20];
    BEGIN
      TESTFIELD("Appreciation Acc. on Disposal");
      EXIT("Appreciation Acc. on Disposal");
    END;

    [External]
    PROCEDURE GetAppreciationBalanceAccount@28() : Code[20];
    BEGIN
      TESTFIELD("Appreciation Bal. Account");
      EXIT("Appreciation Bal. Account");
    END;

    [External]
    PROCEDURE GetAppreciationBalAccountOnDisposal@20() : Code[20];
    BEGIN
      TESTFIELD("Apprec. Bal. Acc. on Disp.");
      EXIT("Apprec. Bal. Acc. on Disp.");
    END;

    [External]
    PROCEDURE GetBookValueAccountOnDisposalGain@17() : Code[20];
    BEGIN
      TESTFIELD("Book Val. Acc. on Disp. (Gain)");
      EXIT("Book Val. Acc. on Disp. (Gain)");
    END;

    [External]
    PROCEDURE GetBookValueAccountOnDisposalLoss@33() : Code[20];
    BEGIN
      TESTFIELD("Book Val. Acc. on Disp. (Loss)");
      EXIT("Book Val. Acc. on Disp. (Loss)");
    END;

    [External]
    PROCEDURE GetCustom1Account@7() : Code[20];
    BEGIN
      TESTFIELD("Custom 1 Account");
      EXIT("Custom 1 Account");
    END;

    [External]
    PROCEDURE GetCustom2Account@8() : Code[20];
    BEGIN
      TESTFIELD("Custom 2 Account");
      EXIT("Custom 2 Account");
    END;

    [External]
    PROCEDURE GetCustom1AccountOnDisposal@13() : Code[20];
    BEGIN
      TESTFIELD("Custom 1 Account on Disposal");
      EXIT("Custom 1 Account on Disposal");
    END;

    [External]
    PROCEDURE GetCustom2AccountOnDisposal@14() : Code[20];
    BEGIN
      TESTFIELD("Custom 2 Account on Disposal");
      EXIT("Custom 2 Account on Disposal");
    END;

    [External]
    PROCEDURE GetCustom1BalAccountOnDisposal@21() : Code[20];
    BEGIN
      TESTFIELD("Custom 1 Bal. Acc. on Disposal");
      EXIT("Custom 1 Bal. Acc. on Disposal");
    END;

    [External]
    PROCEDURE GetCustom2BalAccountOnDisposal@22() : Code[20];
    BEGIN
      TESTFIELD("Custom 2 Bal. Acc. on Disposal");
      EXIT("Custom 2 Bal. Acc. on Disposal");
    END;

    [External]
    PROCEDURE GetCustom1ExpenseAccount@29() : Code[20];
    BEGIN
      TESTFIELD("Custom 1 Expense Acc.");
      EXIT("Custom 1 Expense Acc.");
    END;

    [External]
    PROCEDURE GetCustom2ExpenseAccount@30() : Code[20];
    BEGIN
      TESTFIELD("Custom 2 Expense Acc.");
      EXIT("Custom 2 Expense Acc.");
    END;

    [External]
    PROCEDURE GetDepreciationExpenseAccount@26() : Code[20];
    BEGIN
      TESTFIELD("Depreciation Expense Acc.");
      EXIT("Depreciation Expense Acc.");
    END;

    [External]
    PROCEDURE GetGainsAccountOnDisposal@15() : Code[20];
    BEGIN
      TESTFIELD("Gains Acc. on Disposal");
      EXIT("Gains Acc. on Disposal");
    END;

    [External]
    PROCEDURE GetLossesAccountOnDisposal@16() : Code[20];
    BEGIN
      TESTFIELD("Losses Acc. on Disposal");
      EXIT("Losses Acc. on Disposal");
    END;

    [External]
    PROCEDURE GetMaintenanceExpenseAccount@23() : Code[20];
    BEGIN
      TESTFIELD("Maintenance Expense Account");
      EXIT("Maintenance Expense Account");
    END;

    [External]
    PROCEDURE GetMaintenanceBalanceAccount@24() : Code[20];
    BEGIN
      TESTFIELD("Maintenance Bal. Acc.");
      EXIT("Maintenance Bal. Acc.");
    END;

    [External]
    PROCEDURE GetSalesBalanceAccount@31() : Code[20];
    BEGIN
      TESTFIELD("Sales Bal. Acc.");
      EXIT("Sales Bal. Acc.");
    END;

    [External]
    PROCEDURE GetSalesAccountOnDisposalGain@18() : Code[20];
    BEGIN
      TESTFIELD("Sales Acc. on Disp. (Gain)");
      EXIT("Sales Acc. on Disp. (Gain)");
    END;

    [External]
    PROCEDURE GetSalesAccountOnDisposalLoss@32() : Code[20];
    BEGIN
      TESTFIELD("Sales Acc. on Disp. (Loss)");
      EXIT("Sales Acc. on Disp. (Loss)");
    END;

    [External]
    PROCEDURE GetWriteDownAccount@5() : Code[20];
    BEGIN
      TESTFIELD("Acq. Cost Acc. on Disposal");
      EXIT("Acq. Cost Acc. on Disposal");
    END;

    [External]
    PROCEDURE GetWriteDownAccountOnDisposal@36() : Code[20];
    BEGIN
      TESTFIELD("Write-Down Acc. on Disposal");
      EXIT("Write-Down Acc. on Disposal");
    END;

    [External]
    PROCEDURE GetWriteDownBalAccountOnDisposal@19() : Code[20];
    BEGIN
      TESTFIELD("Write-Down Bal. Acc. on Disp.");
      EXIT("Write-Down Bal. Acc. on Disp.");
    END;

    [External]
    PROCEDURE GetWriteDownExpenseAccount@27() : Code[20];
    BEGIN
      TESTFIELD("Write-Down Expense Acc.");
      EXIT("Write-Down Expense Acc.");
    END;

    BEGIN
    END.
  }
}

