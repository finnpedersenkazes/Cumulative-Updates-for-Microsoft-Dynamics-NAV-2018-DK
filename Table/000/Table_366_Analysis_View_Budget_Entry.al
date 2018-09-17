OBJECT Table 366 Analysis View Budget Entry
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Analysevisningsbudgetpost;
               ENU=Analysis View Budget Entry];
    LookupPageID=Page559;
    DrillDownPageID=Page559;
  }
  FIELDS
  {
    { 1   ;   ;Analysis View Code  ;Code10        ;TableRelation="Analysis View";
                                                   CaptionML=[DAN=Analysevisningskode;
                                                              ENU=Analysis View Code];
                                                   NotBlank=Yes }
    { 2   ;   ;Budget Name         ;Code10        ;TableRelation="G/L Budget Name";
                                                   CaptionML=[DAN=Budgetnavn;
                                                              ENU=Budget Name] }
    { 3   ;   ;Business Unit Code  ;Code20        ;TableRelation="Business Unit";
                                                   CaptionML=[DAN=Konc.virksomhedskode;
                                                              ENU=Business Unit Code] }
    { 4   ;   ;G/L Account No.     ;Code20        ;TableRelation="G/L Account";
                                                   CaptionML=[DAN=Finanskontonr.;
                                                              ENU=G/L Account No.] }
    { 5   ;   ;Dimension 1 Value Code;Code20      ;AccessByPermission=TableData 348=R;
                                                   CaptionML=[DAN=Dimension 1-v‘rdikode;
                                                              ENU=Dimension 1 Value Code];
                                                   CaptionClass=GetCaptionClass(1) }
    { 6   ;   ;Dimension 2 Value Code;Code20      ;AccessByPermission=TableData 348=R;
                                                   CaptionML=[DAN=Dimension 2-v‘rdikode;
                                                              ENU=Dimension 2 Value Code];
                                                   CaptionClass=GetCaptionClass(2) }
    { 7   ;   ;Dimension 3 Value Code;Code20      ;AccessByPermission=TableData 350=R;
                                                   CaptionML=[DAN=Dimension 3-v‘rdikode;
                                                              ENU=Dimension 3 Value Code];
                                                   CaptionClass=GetCaptionClass(3) }
    { 8   ;   ;Dimension 4 Value Code;Code20      ;AccessByPermission=TableData 350=R;
                                                   CaptionML=[DAN=Dimension 4-v‘rdikode;
                                                              ENU=Dimension 4 Value Code];
                                                   CaptionClass=GetCaptionClass(4) }
    { 9   ;   ;Posting Date        ;Date          ;CaptionML=[DAN=Bogf›ringsdato;
                                                              ENU=Posting Date] }
    { 10  ;   ;Entry No.           ;Integer       ;CaptionML=[DAN=L›benr.;
                                                              ENU=Entry No.] }
    { 11  ;   ;Amount              ;Decimal       ;CaptionML=[DAN=Bel›b;
                                                              ENU=Amount];
                                                   AutoFormatType=1 }
  }
  KEYS
  {
    {    ;Analysis View Code,Budget Name,G/L Account No.,Dimension 1 Value Code,Dimension 2 Value Code,Dimension 3 Value Code,Dimension 4 Value Code,Business Unit Code,Posting Date,Entry No.;
                                                   SumIndexFields=Amount;
                                                   Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    LOCAL PROCEDURE GetCaptionClass@7(AnalysisViewDimType@1000 : Integer) : Text[250];
    VAR
      AnalysisViewEntry@1001 : Record 365;
    BEGIN
      AnalysisViewEntry.INIT;
      AnalysisViewEntry."Analysis View Code" := "Analysis View Code";
      EXIT(AnalysisViewEntry.GetCaptionClass(AnalysisViewDimType));
    END;

    [External]
    PROCEDURE CopyDimFilters@2(VAR AccSchedLine@1000 : Record 85);
    BEGIN
      AccSchedLine.COPYFILTER("Dimension 1 Filter","Dimension 1 Value Code");
      AccSchedLine.COPYFILTER("Dimension 2 Filter","Dimension 2 Value Code");
      AccSchedLine.COPYFILTER("Dimension 3 Filter","Dimension 3 Value Code");
      AccSchedLine.COPYFILTER("Dimension 4 Filter","Dimension 4 Value Code");
    END;

    [External]
    PROCEDURE SetDimFilters@3(DimFilter1@1000 : Text;DimFilter2@1001 : Text;DimFilter3@1002 : Text;DimFilter4@1003 : Text);
    BEGIN
      SETFILTER("Dimension 1 Value Code",DimFilter1);
      SETFILTER("Dimension 2 Value Code",DimFilter2);
      SETFILTER("Dimension 3 Value Code",DimFilter3);
      SETFILTER("Dimension 4 Value Code",DimFilter4);
    END;

    BEGIN
    END.
  }
}

