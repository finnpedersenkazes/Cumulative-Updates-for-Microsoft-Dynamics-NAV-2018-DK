OBJECT Table 374 G/L Acc. Budget Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    DataCaptionFields=Code;
    CaptionML=[DAN=Finansbudgetbuffer;
               ENU=G/L Acc. Budget Buffer];
    LookupPageID=Page18;
    DrillDownPageID=Page16;
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kode;
                                                              ENU=Code];
                                                   NotBlank=Yes }
    { 3   ;   ;Budget Filter       ;Code10        ;FieldClass=FlowFilter;
                                                   TableRelation="G/L Budget Name";
                                                   CaptionML=[DAN=Budgetfilter;
                                                              ENU=Budget Filter] }
    { 4   ;   ;G/L Account Filter  ;Code20        ;FieldClass=FlowFilter;
                                                   TableRelation="G/L Account";
                                                   ValidateTableRelation=No;
                                                   CaptionML=[DAN=Finanskontofilter;
                                                              ENU=G/L Account Filter] }
    { 5   ;   ;Business Unit Filter;Code20        ;FieldClass=FlowFilter;
                                                   TableRelation="Business Unit";
                                                   CaptionML=[DAN=Koncernvirk.filter;
                                                              ENU=Business Unit Filter] }
    { 6   ;   ;Global Dimension 1 Filter;Code20   ;FieldClass=FlowFilter;
                                                   TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   CaptionML=[DAN=Global dimension 1-filter;
                                                              ENU=Global Dimension 1 Filter];
                                                   CaptionClass='1,3,1' }
    { 7   ;   ;Global Dimension 2 Filter;Code20   ;FieldClass=FlowFilter;
                                                   TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   CaptionML=[DAN=Global dimension 2-filter;
                                                              ENU=Global Dimension 2 Filter];
                                                   CaptionClass='1,3,2' }
    { 8   ;   ;Budget Dimension 1 Filter;Code20   ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Budgetdimension 1-filter;
                                                              ENU=Budget Dimension 1 Filter];
                                                   CaptionClass=GetCaptionClass(1) }
    { 9   ;   ;Budget Dimension 2 Filter;Code20   ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Budgetdimension 2-filter;
                                                              ENU=Budget Dimension 2 Filter];
                                                   CaptionClass=GetCaptionClass(2) }
    { 10  ;   ;Budget Dimension 3 Filter;Code20   ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Budgetdimension 3-filter;
                                                              ENU=Budget Dimension 3 Filter];
                                                   CaptionClass=GetCaptionClass(3) }
    { 11  ;   ;Budget Dimension 4 Filter;Code20   ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Budgetdimension 4-filter;
                                                              ENU=Budget Dimension 4 Filter];
                                                   CaptionClass=GetCaptionClass(4) }
    { 12  ;   ;Date Filter         ;Date          ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Datofilter;
                                                              ENU=Date Filter];
                                                   ClosingDates=Yes }
    { 13  ;   ;Budgeted Amount     ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("G/L Budget Entry".Amount WHERE (Budget Name=FIELD(Budget Filter),
                                                                                                    G/L Account No.=FIELD(G/L Account Filter),
                                                                                                    Business Unit Code=FIELD(Business Unit Filter),
                                                                                                    Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                    Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                    Budget Dimension 1 Code=FIELD(Budget Dimension 1 Filter),
                                                                                                    Budget Dimension 2 Code=FIELD(Budget Dimension 2 Filter),
                                                                                                    Budget Dimension 3 Code=FIELD(Budget Dimension 3 Filter),
                                                                                                    Budget Dimension 4 Code=FIELD(Budget Dimension 4 Filter),
                                                                                                    Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Budgetteret bel›b;
                                                              ENU=Budgeted Amount];
                                                   AutoFormatType=1 }
    { 14  ;   ;Income/Balance      ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Indt‘gter/saldo;
                                                              ENU=Income/Balance];
                                                   OptionCaptionML=[DAN=" ,Resultatopg›relse,Balance";
                                                                    ENU=" ,Income Statement,Balance Sheet"];
                                                   OptionString=[ ,Income Statement,Balance Sheet] }
    { 15  ;   ;Account Category    ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kontokategori;
                                                              ENU=Account Category];
                                                   OptionCaptionML=[DAN=" ,Aktiver,G‘ld,Egenkapital,Indt‘gter,Vareforbrug,Udgifter";
                                                                    ENU=" ,Assets,Liabilities,Equity,Income,Cost of Goods Sold,Expense"];
                                                   OptionString=[ ,Assets,Liabilities,Equity,Income,Cost of Goods Sold,Expense] }
  }
  KEYS
  {
    {    ;Code                                    ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=1,6,,Budgetdimension 1-filter;ENU=1,6,,Budget Dimension 1 Filter';
      Text001@1001 : TextConst 'DAN=1,6,,Budgetdimension 2-filter;ENU=1,6,,Budget Dimension 2 Filter';
      Text002@1002 : TextConst 'DAN=1,6,,Budgetdimension 3-filter;ENU=1,6,,Budget Dimension 3 Filter';
      Text003@1003 : TextConst 'DAN=1,6,,Budgetdimension 4-filter;ENU=1,6,,Budget Dimension 4 Filter';
      GLBudgetName@1004 : Record 95;

    LOCAL PROCEDURE GetCaptionClass@7(BudgetDimType@1000 : Integer) : Text[250];
    BEGIN
      IF GLBudgetName.Name <> GETFILTER("Budget Filter") THEN
        GLBudgetName.GET(GETFILTER("Budget Filter"));
      CASE BudgetDimType OF
        1:
          BEGIN
            IF GLBudgetName."Budget Dimension 1 Code" <> '' THEN
              EXIT('1,6,' + GLBudgetName."Budget Dimension 1 Code");

            EXIT(Text000);
          END;
        2:
          BEGIN
            IF GLBudgetName."Budget Dimension 2 Code" <> '' THEN
              EXIT('1,6,' + GLBudgetName."Budget Dimension 2 Code");

            EXIT(Text001);
          END;
        3:
          BEGIN
            IF GLBudgetName."Budget Dimension 3 Code" <> '' THEN
              EXIT('1,6,' + GLBudgetName."Budget Dimension 3 Code");

            EXIT(Text002);
          END;
        4:
          BEGIN
            IF GLBudgetName."Budget Dimension 4 Code" <> '' THEN
              EXIT('1,6,' + GLBudgetName."Budget Dimension 4 Code");

            EXIT(Text003);
          END;
      END;
    END;

    BEGIN
    END.
  }
}

