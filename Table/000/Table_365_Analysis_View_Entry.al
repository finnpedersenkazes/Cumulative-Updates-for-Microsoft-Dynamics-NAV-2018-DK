OBJECT Table 365 Analysis View Entry
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Analysevisningspost;
               ENU=Analysis View Entry];
    LookupPageID=Page558;
    DrillDownPageID=Page558;
  }
  FIELDS
  {
    { 1   ;   ;Analysis View Code  ;Code10        ;TableRelation="Analysis View" WHERE (Account Source=FIELD(Account Source));
                                                   CaptionML=[DAN=Analysevisningskode;
                                                              ENU=Analysis View Code];
                                                   NotBlank=Yes }
    { 2   ;   ;Business Unit Code  ;Code20        ;TableRelation="Business Unit";
                                                   CaptionML=[DAN=Konc.virksomhedskode;
                                                              ENU=Business Unit Code] }
    { 3   ;   ;Account No.         ;Code20        ;TableRelation=IF (Account Source=CONST(G/L Account)) "G/L Account"
                                                                 ELSE IF (Account Source=CONST(Cash Flow Account)) "Cash Flow Account";
                                                   CaptionML=[DAN=Kontonr.;
                                                              ENU=Account No.] }
    { 4   ;   ;Dimension 1 Value Code;Code20      ;AccessByPermission=TableData 348=R;
                                                   CaptionML=[DAN=Dimension 1-v�rdikode;
                                                              ENU=Dimension 1 Value Code];
                                                   CaptionClass=GetCaptionClass(1) }
    { 5   ;   ;Dimension 2 Value Code;Code20      ;AccessByPermission=TableData 348=R;
                                                   CaptionML=[DAN=Dimension 2-v�rdikode;
                                                              ENU=Dimension 2 Value Code];
                                                   CaptionClass=GetCaptionClass(2) }
    { 6   ;   ;Dimension 3 Value Code;Code20      ;AccessByPermission=TableData 350=R;
                                                   CaptionML=[DAN=Dimension 3-v�rdikode;
                                                              ENU=Dimension 3 Value Code];
                                                   CaptionClass=GetCaptionClass(3) }
    { 7   ;   ;Dimension 4 Value Code;Code20      ;AccessByPermission=TableData 350=R;
                                                   CaptionML=[DAN=Dimension 4-v�rdikode;
                                                              ENU=Dimension 4 Value Code];
                                                   CaptionClass=GetCaptionClass(4) }
    { 8   ;   ;Posting Date        ;Date          ;CaptionML=[DAN=Bogf�ringsdato;
                                                              ENU=Posting Date] }
    { 9   ;   ;Entry No.           ;Integer       ;CaptionML=[DAN=L�benr.;
                                                              ENU=Entry No.] }
    { 10  ;   ;Amount              ;Decimal       ;OnLookup=BEGIN
                                                              DrillDown;
                                                            END;

                                                   CaptionML=[DAN=Bel�b;
                                                              ENU=Amount];
                                                   AutoFormatType=1 }
    { 11  ;   ;Debit Amount        ;Decimal       ;CaptionML=[DAN=Debetbel�b;
                                                              ENU=Debit Amount];
                                                   AutoFormatType=1 }
    { 12  ;   ;Credit Amount       ;Decimal       ;CaptionML=[DAN=Kreditbel�b;
                                                              ENU=Credit Amount];
                                                   AutoFormatType=1 }
    { 13  ;   ;Add.-Curr. Amount   ;Decimal       ;AccessByPermission=TableData 4=R;
                                                   CaptionML=[DAN=Bel�b i ekstra valuta;
                                                              ENU=Add.-Curr. Amount];
                                                   AutoFormatType=1 }
    { 14  ;   ;Add.-Curr. Debit Amount;Decimal    ;AccessByPermission=TableData 4=R;
                                                   CaptionML=[DAN=Debetbel�b i ekstra valuta;
                                                              ENU=Add.-Curr. Debit Amount];
                                                   AutoFormatType=1 }
    { 15  ;   ;Add.-Curr. Credit Amount;Decimal   ;AccessByPermission=TableData 4=R;
                                                   CaptionML=[DAN=Kreditbel�b i ekstra valuta;
                                                              ENU=Add.-Curr. Credit Amount];
                                                   AutoFormatType=1 }
    { 16  ;   ;Account Source      ;Option        ;CaptionML=[DAN=Kontokilde;
                                                              ENU=Account Source];
                                                   OptionCaptionML=[DAN=Finanskonto,Pengestr�mskonto;
                                                                    ENU=G/L Account,Cash Flow Account];
                                                   OptionString=G/L Account,Cash Flow Account }
    { 17  ;   ;Cash Flow Forecast No.;Code20      ;TableRelation="Cash Flow Forecast";
                                                   CaptionML=[DAN=Pengestr�msprognosenr.;
                                                              ENU=Cash Flow Forecast No.] }
  }
  KEYS
  {
    {    ;Analysis View Code,Account No.,Account Source,Dimension 1 Value Code,Dimension 2 Value Code,Dimension 3 Value Code,Dimension 4 Value Code,Business Unit Code,Posting Date,Entry No.,Cash Flow Forecast No.;
                                                   SumIndexFields=Amount,Debit Amount,Credit Amount,Add.-Curr. Amount,Add.-Curr. Debit Amount,Add.-Curr. Credit Amount;
                                                   Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=1,5,,Dimension 1-v�rdikode;ENU=1,5,,Dimension 1 Value Code';
      Text001@1001 : TextConst 'DAN=1,5,,Dimension 2-v�rdikode;ENU=1,5,,Dimension 2 Value Code';
      Text002@1002 : TextConst 'DAN=1,5,,Dimension 3-v�rdikode;ENU=1,5,,Dimension 3 Value Code';
      Text003@1003 : TextConst 'DAN=1,5,,Dimension 4-v�rdikode;ENU=1,5,,Dimension 4 Value Code';
      AnalysisView@1004 : Record 363;

    [External]
    PROCEDURE GetCaptionClass@7(AnalysisViewDimType@1000 : Integer) : Text[250];
    BEGIN
      IF AnalysisView.Code <> "Analysis View Code" THEN
        AnalysisView.GET("Analysis View Code");
      CASE AnalysisViewDimType OF
        1:
          BEGIN
            IF AnalysisView."Dimension 1 Code" <> '' THEN
              EXIT('1,5,' + AnalysisView."Dimension 1 Code");

            EXIT(Text000);
          END;
        2:
          BEGIN
            IF AnalysisView."Dimension 2 Code" <> '' THEN
              EXIT('1,5,' + AnalysisView."Dimension 2 Code");

            EXIT(Text001);
          END;
        3:
          BEGIN
            IF AnalysisView."Dimension 3 Code" <> '' THEN
              EXIT('1,5,' + AnalysisView."Dimension 3 Code");

            EXIT(Text002);
          END;
        4:
          BEGIN
            IF AnalysisView."Dimension 4 Code" <> '' THEN
              EXIT('1,5,' + AnalysisView."Dimension 4 Code");

            EXIT(Text003);
          END;
      END;
    END;

    LOCAL PROCEDURE DrillDown@1();
    VAR
      TempGLEntry@1000 : TEMPORARY Record 17;
      TempCFForecastEntry@1002 : TEMPORARY Record 847;
      AnalysisViewEntryToGLEntries@1001 : Codeunit 413;
    BEGIN
      IF "Account Source" = "Account Source"::"G/L Account" THEN BEGIN
        TempGLEntry.RESET;
        TempGLEntry.DELETEALL;
        AnalysisViewEntryToGLEntries.GetGLEntries(Rec,TempGLEntry);
        PAGE.RUNMODAL(PAGE::"General Ledger Entries",TempGLEntry);
      END ELSE BEGIN
        TempCFForecastEntry.RESET;
        TempCFForecastEntry.DELETEALL;
        AnalysisViewEntryToGLEntries.GetCFLedgEntries(Rec,TempCFForecastEntry);
        PAGE.RUNMODAL(PAGE::"Cash Flow Forecast Entries",TempCFForecastEntry);
      END;
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

