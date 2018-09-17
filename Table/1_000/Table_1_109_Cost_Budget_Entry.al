OBJECT Table 1109 Cost Budget Entry
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               IF "Entry No." = 0 THEN
                 "Entry No." := GetNextEntryNo;
               CheckEntries;
               "Last Modified By User" := USERID;

               HandleCostBudgetRegister;
             END;

    OnModify=VAR
               CostBudgetEntry@1000 : Record 1109;
             BEGIN
               CheckEntries;
               CostBudgetEntry.GET("Entry No.");
               IF Amount <> CostBudgetEntry.Amount THEN
                 CostAccMgt.UpdateCostBudgetRegister(CurrRegNo,"Entry No.",Amount - CostBudgetEntry.Amount);
               Modified;
             END;

    CaptionML=[DAN=Omkostningsbudgetpost;
               ENU=Cost Budget Entry];
    LookupPageID=Page1115;
    DrillDownPageID=Page1115;
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;CaptionML=[DAN=L›benr.;
                                                              ENU=Entry No.];
                                                   Editable=No }
    { 2   ;   ;Budget Name         ;Code10        ;TableRelation="Cost Budget Name";
                                                   CaptionML=[DAN=Budgetnavn;
                                                              ENU=Budget Name] }
    { 3   ;   ;Cost Type No.       ;Code20        ;TableRelation="Cost Type";
                                                   CaptionML=[DAN=Omkostningstypenr.;
                                                              ENU=Cost Type No.] }
    { 4   ;   ;Date                ;Date          ;CaptionML=[DAN=Dato;
                                                              ENU=Date];
                                                   ClosingDates=Yes }
    { 5   ;   ;Cost Center Code    ;Code20        ;TableRelation="Cost Center";
                                                   CaptionML=[DAN=Omkostningsstedskode;
                                                              ENU=Cost Center Code] }
    { 6   ;   ;Cost Object Code    ;Code20        ;TableRelation="Cost Object";
                                                   CaptionML=[DAN=Omkostningsemnekode;
                                                              ENU=Cost Object Code] }
    { 7   ;   ;Amount              ;Decimal       ;CaptionML=[DAN=Bel›b;
                                                              ENU=Amount] }
    { 9   ;   ;Description         ;Text80        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 20  ;   ;Document No.        ;Code20        ;CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.] }
    { 30  ;   ;Source Code         ;Code10        ;TableRelation="Source Code";
                                                   CaptionML=[DAN=Kildespor;
                                                              ENU=Source Code] }
    { 31  ;   ;System-Created Entry;Boolean       ;CaptionML=[DAN=Automatisk oprettet;
                                                              ENU=System-Created Entry];
                                                   Editable=No }
    { 32  ;   ;Allocated           ;Boolean       ;CaptionML=[DAN=Fordelt;
                                                              ENU=Allocated] }
    { 33  ;   ;Allocated with Journal No.;Integer ;CaptionML=[DAN=Fordelt med kladdenr.;
                                                              ENU=Allocated with Journal No.] }
    { 40  ;   ;Last Modified By User;Code50       ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("Last Modified By User");
                                                            END;

                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Sidst ‘ndret af bruger;
                                                              ENU=Last Modified By User];
                                                   Editable=No }
    { 42  ;   ;Last Date Modified  ;Date          ;CaptionML=[DAN=Rettet den;
                                                              ENU=Last Date Modified];
                                                   Editable=No }
    { 50  ;   ;Allocation Description;Text80      ;CaptionML=[DAN=Fordelingsbeskrivelse;
                                                              ENU=Allocation Description] }
    { 51  ;   ;Allocation ID       ;Code10        ;TableRelation="Cost Allocation Source";
                                                   CaptionML=[DAN=Fordelings-id;
                                                              ENU=Allocation ID] }
  }
  KEYS
  {
    {    ;Entry No.                               ;Clustered=Yes }
    {    ;Budget Name,Cost Type No.,Date          ;SumIndexFields=Amount }
    {    ;Budget Name,Cost Type No.,Cost Center Code,Cost Object Code,Date;
                                                   SumIndexFields=Amount }
    {    ;Budget Name,Cost Center Code,Cost Type No.,Allocated,Date;
                                                   SumIndexFields=Amount }
    {    ;Budget Name,Cost Object Code,Cost Type No.,Allocated,Date;
                                                   SumIndexFields=Amount }
    {    ;Budget Name,Allocation ID,Date           }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      CostAccMgt@1000 : Codeunit 1100;
      CurrRegNo@1001 : Integer;
      Text000@1002 : TextConst 'DAN=Denne funktion skal startes med et budgetnavn.;ENU=This function must be started with a budget name.';
      Text001@1003 : TextConst 'DAN=Posterne i budgettet %1 komprimeres. Poster med identisk omkostningstype, omkostningssted, omkostningsemne og dato samles.\\Den f›rste post i hver gruppe forbliver u‘ndret. Bel›bene fra alle efterf›lgende poster f›jes til den f›rste post.\\Yderligere oplysninger, f.eks. tekst og allokering til andre poster, slettes.\\Er du sikker p†, at du vil forts‘tte?;ENU=The entries in budget %1 will be compressed. Entries with identical cost type, cost center, cost object, and date will be combined.\\The first entry of each group remains unchanged. The amounts from all subsequent entries will be added to the first entry.\\Additional information such as text and allocation on other entries will be deleted.\\Are you sure that you want to continue?';
      Text002@1004 : TextConst 'DAN=Komprimer budgetposter\Post       #1#######\Behandlet   #2#######\Komprimeret  #3#######;ENU=Compress budget entries\Entry       #1#######\Processed   #2#######\Compressed  #3#######';
      Text003@1005 : TextConst 'DAN=%1 poster i budget %2 behandlet. %3 poster komprimeret.;ENU=%1 entries in budget %2 processed. %3 entries compressed.';
      Text004@1006 : TextConst 'DAN=Omkostningsstedet eller omkostningsemnet mangler. Definer et tilsvarende filter i budgetvinduet.;ENU=A cost center or cost object is missing. Define a corresponding filter in the Budget window.';
      Text005@1007 : TextConst 'DAN=Du kan ikke b†de definere et omkostningssted og et omkostningsemne.;ENU=You cannot define both cost center and cost object.';

    [External]
    PROCEDURE CompressBudgetEntries@1(BudName@1000 : Code[20]);
    VAR
      CostBudgetEntrySource@1001 : Record 1109;
      CostBudgetEntryTarget@1002 : Record 1109;
      Window@1003 : Dialog;
      NoProcessed@1004 : Integer;
      QtyPerGrp@1005 : Integer;
      NoCompressed@1006 : Integer;
    BEGIN
      IF BudName = '' THEN
        ERROR(Text000);

      IF NOT CONFIRM(Text001,TRUE,BudName) THEN
        ERROR('');

      CostBudgetEntrySource.SETCURRENTKEY("Budget Name","Cost Type No.","Cost Center Code","Cost Object Code",Date);
      CostBudgetEntrySource.SETRANGE("Budget Name",BudName);

      Window.OPEN(Text002);

      Window.UPDATE(1,COUNT);

      IF CostBudgetEntrySource.FIND('-') THEN
        REPEAT
          IF (CostBudgetEntrySource."Cost Type No." = CostBudgetEntryTarget."Cost Type No.") AND
             (CostBudgetEntrySource."Cost Center Code" = CostBudgetEntryTarget."Cost Center Code") AND
             (CostBudgetEntrySource."Cost Object Code" = CostBudgetEntryTarget."Cost Object Code") AND
             (CostBudgetEntrySource.Date = CostBudgetEntryTarget.Date)
          THEN BEGIN
            CostBudgetEntryTarget.Amount := CostBudgetEntryTarget.Amount + CostBudgetEntrySource.Amount;
            CostBudgetEntrySource.DELETE;
            NoCompressed := NoCompressed + 1;
            QtyPerGrp := QtyPerGrp + 1;
          END ELSE BEGIN
            // Write total
            IF QtyPerGrp > 1 THEN BEGIN
              IF CostBudgetEntryTarget.Amount = 0 THEN
                CostBudgetEntryTarget.DELETE
              ELSE
                CostBudgetEntryTarget.MODIFY;
              QtyPerGrp := 0;
            END;

            // Save new rec.
            CostBudgetEntryTarget := CostBudgetEntrySource;
            QtyPerGrp := QtyPerGrp + 1;
          END;

          NoProcessed := NoProcessed + 1;
          IF (NoProcessed < 50) OR ((NoProcessed MOD 100) = 0) THEN BEGIN
            Window.UPDATE(2,NoProcessed);
            Window.UPDATE(3,NoCompressed);
          END;

        UNTIL CostBudgetEntrySource.NEXT = 0;

      IF CostBudgetEntryTarget.Amount <> 0 THEN
        CostBudgetEntryTarget.MODIFY;

      Window.CLOSE;
      MESSAGE(Text003,NoProcessed,BudName,NoCompressed);
    END;

    [External]
    PROCEDURE CheckEntries@2();
    BEGIN
      TESTFIELD(Date);
      TESTFIELD("Budget Name");
      TESTFIELD("Cost Type No.");

      IF ("Cost Center Code" = '') AND ("Cost Object Code" = '') THEN
        ERROR(Text004);

      IF ("Cost Center Code" <> '') AND ("Cost Object Code" <> '') THEN
        ERROR(Text005);
    END;

    LOCAL PROCEDURE GetNextEntryNo@3() : Integer;
    VAR
      CostBudgetEntry@1000 : Record 1109;
    BEGIN
      CostBudgetEntry.SETCURRENTKEY("Entry No.");
      IF CostBudgetEntry.FINDLAST THEN
        EXIT(CostBudgetEntry."Entry No." + 1);
      EXIT(1);
    END;

    LOCAL PROCEDURE Modified@4();
    BEGIN
      "Last Modified By User" := USERID;
      "Last Date Modified" := TODAY;
    END;

    LOCAL PROCEDURE HandleCostBudgetRegister@5();
    VAR
      CostBudgetReg@1000 : Record 1111;
    BEGIN
      IF CostBudgetReg.GET(CurrRegNo) THEN;
      IF (CurrRegNo = 0) OR (CostBudgetReg."To Cost Budget Entry No." <> "Entry No." - 1) THEN
        CurrRegNo := CostAccMgt.InsertCostBudgetRegister("Entry No.","Budget Name",Amount)
      ELSE
        CostAccMgt.UpdateCostBudgetRegister(CurrRegNo,"Entry No.",Amount);
    END;

    [External]
    PROCEDURE SetCostBudgetRegNo@7(RegNo@1000 : Integer);
    BEGIN
      CurrRegNo := RegNo;
    END;

    [External]
    PROCEDURE GetCostBudgetRegNo@6() : Integer;
    BEGIN
      EXIT(CurrRegNo);
    END;

    [External]
    PROCEDURE GetFirstCostType@11(CostTypeFilter@1000 : Text[250]) : Text[20];
    VAR
      CostType@1001 : Record 1103;
    BEGIN
      CostType.SETFILTER("No.",CostTypeFilter);
      IF CostType.FINDFIRST THEN
        EXIT(CostType."No.");
      EXIT('')
    END;

    [External]
    PROCEDURE GetFirstDate@10(DateFilter@1000 : Text) : Date;
    VAR
      Period@1001 : Record 2000000007;
      HiddenDate@1002 : Date;
    BEGIN
      FILTERGROUP := 26;
      IF GETFILTER(Date) <> '' THEN BEGIN
        DateFilter := GETFILTER(Date);
        FILTERGROUP := 0;
        EVALUATE(HiddenDate,COPYSTR(DateFilter,STRPOS(DateFilter,'..') + 2,STRPOS(DateFilter,'|') - (STRPOS(DateFilter,'..') + 2)));
        EXIT(HiddenDate);
      END;
      FILTERGROUP := 0;
      IF DateFilter = '' THEN
        EXIT(WORKDATE);

      Period.SETRANGE("Period Type",Period."Period Type"::Date);
      Period.SETFILTER("Period Start",DateFilter);
      IF Period.FINDFIRST THEN
        EXIT(Period."Period Start");
      EXIT(0D)
    END;

    [External]
    PROCEDURE GetFirstCostCenter@9(CostCenterFilter@1000 : Text[250]) : Code[20];
    VAR
      CostCenter@1001 : Record 1112;
    BEGIN
      CostCenter.SETFILTER(Code,CostCenterFilter);
      IF CostCenter.FINDFIRST THEN
        EXIT(CostCenter.Code);
      EXIT('')
    END;

    [External]
    PROCEDURE GetFirstCostObject@8(CostObjectFilter@1000 : Text[250]) : Code[20];
    VAR
      CostObject@1001 : Record 1113;
    BEGIN
      CostObject.SETFILTER(Code,CostObjectFilter);
      IF CostObject.FINDFIRST THEN
        EXIT(CostObject.Code);
      EXIT('')
    END;

    BEGIN
    END.
  }
}

