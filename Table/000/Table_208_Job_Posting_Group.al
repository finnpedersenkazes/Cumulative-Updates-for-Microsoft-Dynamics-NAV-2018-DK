OBJECT Table 208 Job Posting Group
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
               CheckGroupUsage;
             END;

    CaptionML=[DAN=Sagsbogf�ringsgruppe;
               ENU=Job Posting Group];
    LookupPageID=Page211;
    DrillDownPageID=Page211;
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code20        ;CaptionML=[DAN=Kode;
                                                              ENU=Code];
                                                   NotBlank=Yes }
    { 2   ;   ;WIP Costs Account   ;Code20        ;TableRelation="G/L Account";
                                                   CaptionML=[DAN=Konto til VIA-omkostning;
                                                              ENU=WIP Costs Account] }
    { 3   ;   ;WIP Accrued Costs Account;Code20   ;TableRelation="G/L Account";
                                                   CaptionML=[DAN=Konto til periodiske VIA-omkostning;
                                                              ENU=WIP Accrued Costs Account] }
    { 4   ;   ;Job Costs Applied Account;Code20   ;TableRelation="G/L Account";
                                                   CaptionML=[DAN=Konto til anvendte sagsomkostning;
                                                              ENU=Job Costs Applied Account] }
    { 5   ;   ;Job Costs Adjustment Account;Code20;TableRelation="G/L Account";
                                                   CaptionML=[DAN=Konto til justering af sagsomkostning;
                                                              ENU=Job Costs Adjustment Account] }
    { 6   ;   ;G/L Expense Acc. (Contract);Code20 ;TableRelation="G/L Account";
                                                   CaptionML=[DAN=Driftskonto (kontrakt);
                                                              ENU=G/L Expense Acc. (Contract)] }
    { 7   ;   ;Job Sales Adjustment Account;Code20;TableRelation="G/L Account";
                                                   CaptionML=[DAN=Konto til justering af sagssalg;
                                                              ENU=Job Sales Adjustment Account] }
    { 8   ;   ;WIP Accrued Sales Account;Code20   ;TableRelation="G/L Account";
                                                   CaptionML=[DAN=Konto til periodisk VIA-salg;
                                                              ENU=WIP Accrued Sales Account] }
    { 9   ;   ;WIP Invoiced Sales Account;Code20  ;TableRelation="G/L Account";
                                                   CaptionML=[DAN=Konto til faktureret VIA-salg;
                                                              ENU=WIP Invoiced Sales Account] }
    { 10  ;   ;Job Sales Applied Account;Code20   ;TableRelation="G/L Account";
                                                   CaptionML=[DAN=Konto til anvendt sagssalg;
                                                              ENU=Job Sales Applied Account] }
    { 11  ;   ;Recognized Costs Account;Code20    ;TableRelation="G/L Account";
                                                   CaptionML=[DAN=Konto til realiserede omkostninger;
                                                              ENU=Recognized Costs Account] }
    { 12  ;   ;Recognized Sales Account;Code20    ;TableRelation="G/L Account";
                                                   CaptionML=[DAN=Konto til realiseret salg;
                                                              ENU=Recognized Sales Account] }
    { 13  ;   ;Item Costs Applied Account;Code20  ;TableRelation="G/L Account";
                                                   CaptionML=[DAN=Konto til anvendte vareomkostninger;
                                                              ENU=Item Costs Applied Account] }
    { 14  ;   ;Resource Costs Applied Account;Code20;
                                                   TableRelation="G/L Account";
                                                   CaptionML=[DAN=Konto til anvendte ressourceomkostninger;
                                                              ENU=Resource Costs Applied Account] }
    { 15  ;   ;G/L Costs Applied Account;Code20   ;TableRelation="G/L Account";
                                                   CaptionML=[DAN=Konto til anvendte finansomkostninger;
                                                              ENU=G/L Costs Applied Account] }
    { 20  ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
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
      YouCannotDeleteErr@1000 : TextConst '@@@="%1 = Code";DAN=Du kan ikke slette %1.;ENU=You cannot delete %1.';

    LOCAL PROCEDURE CheckGroupUsage@15();
    VAR
      Job@1000 : Record 167;
      JobLedgerEntry@1001 : Record 169;
    BEGIN
      Job.SETRANGE("Job Posting Group",Code);
      IF NOT Job.ISEMPTY THEN
        ERROR(YouCannotDeleteErr,Code);

      JobLedgerEntry.SETRANGE("Job Posting Group",Code);
      IF NOT JobLedgerEntry.ISEMPTY THEN
        ERROR(YouCannotDeleteErr,Code);
    END;

    [External]
    PROCEDURE GetWIPCostsAccount@1() : Code[20];
    BEGIN
      TESTFIELD("WIP Costs Account");
      EXIT("WIP Costs Account");
    END;

    [External]
    PROCEDURE GetWIPAccruedCostsAccount@2() : Code[20];
    BEGIN
      TESTFIELD("WIP Accrued Costs Account");
      EXIT("WIP Accrued Costs Account");
    END;

    [External]
    PROCEDURE GetWIPAccruedSalesAccount@7() : Code[20];
    BEGIN
      TESTFIELD("WIP Accrued Sales Account");
      EXIT("WIP Accrued Sales Account");
    END;

    [External]
    PROCEDURE GetWIPInvoicedSalesAccount@8() : Code[20];
    BEGIN
      TESTFIELD("WIP Invoiced Sales Account");
      EXIT("WIP Invoiced Sales Account");
    END;

    [External]
    PROCEDURE GetJobCostsAppliedAccount@3() : Code[20];
    BEGIN
      TESTFIELD("Job Costs Applied Account");
      EXIT("Job Costs Applied Account");
    END;

    [External]
    PROCEDURE GetJobCostsAdjustmentAccount@4() : Code[20];
    BEGIN
      TESTFIELD("Job Costs Adjustment Account");
      EXIT("Job Costs Adjustment Account");
    END;

    [External]
    PROCEDURE GetGLExpenseAccountContract@5() : Code[20];
    BEGIN
      TESTFIELD("G/L Expense Acc. (Contract)");
      EXIT("G/L Expense Acc. (Contract)");
    END;

    [External]
    PROCEDURE GetJobSalesAdjustmentAccount@6() : Code[20];
    BEGIN
      TESTFIELD("Job Sales Adjustment Account");
      EXIT("Job Sales Adjustment Account");
    END;

    [External]
    PROCEDURE GetJobSalesAppliedAccount@9() : Code[20];
    BEGIN
      TESTFIELD("Job Sales Applied Account");
      EXIT("Job Sales Applied Account");
    END;

    [External]
    PROCEDURE GetRecognizedCostsAccount@10() : Code[20];
    BEGIN
      TESTFIELD("Recognized Costs Account");
      EXIT("Recognized Costs Account");
    END;

    [External]
    PROCEDURE GetRecognizedSalesAccount@11() : Code[20];
    BEGIN
      TESTFIELD("Recognized Sales Account");
      EXIT("Recognized Sales Account");
    END;

    [External]
    PROCEDURE GetItemCostsAppliedAccount@12() : Code[20];
    BEGIN
      TESTFIELD("Item Costs Applied Account");
      EXIT("Item Costs Applied Account");
    END;

    [External]
    PROCEDURE GetResourceCostsAppliedAccount@13() : Code[20];
    BEGIN
      TESTFIELD("Resource Costs Applied Account");
      EXIT("Resource Costs Applied Account");
    END;

    [External]
    PROCEDURE GetGLCostsAppliedAccount@14() : Code[20];
    BEGIN
      TESTFIELD("G/L Costs Applied Account");
      EXIT("G/L Costs Applied Account");
    END;

    BEGIN
    END.
  }
}

