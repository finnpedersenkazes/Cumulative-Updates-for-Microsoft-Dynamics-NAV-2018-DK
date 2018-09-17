OBJECT Table 334 Column Layout
{
  OBJECT-PROPERTIES
  {
    Date=06-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21441;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Kolonneformat;
               ENU=Column Layout];
  }
  FIELDS
  {
    { 1   ;   ;Column Layout Name  ;Code10        ;TableRelation="Column Layout Name";
                                                   CaptionML=[DAN=Kolonneformatnavn;
                                                              ENU=Column Layout Name] }
    { 2   ;   ;Line No.            ;Integer       ;CaptionML=[DAN=Linjenr.;
                                                              ENU=Line No.] }
    { 3   ;   ;Column No.          ;Code10        ;CaptionML=[DAN=Kolonnenr.;
                                                              ENU=Column No.] }
    { 4   ;   ;Column Header       ;Text30        ;CaptionML=[DAN=Kolonnehoved;
                                                              ENU=Column Header] }
    { 5   ;   ;Column Type         ;Option        ;InitValue=Net Change;
                                                   CaptionML=[DAN=Kolonnetype;
                                                              ENU=Column Type];
                                                   OptionCaptionML=[DAN=Formel,Bev�gelse,Saldo til dato,Startsaldo,Regnskabs�r-til-dato,Rest. regnskabs�r,Hele regnskabs�ret;
                                                                    ENU=Formula,Net Change,Balance at Date,Beginning Balance,Year to Date,Rest of Fiscal Year,Entire Fiscal Year];
                                                   OptionString=Formula,Net Change,Balance at Date,Beginning Balance,Year to Date,Rest of Fiscal Year,Entire Fiscal Year }
    { 6   ;   ;Ledger Entry Type   ;Option        ;CaptionML=[DAN=Posteringstype;
                                                              ENU=Ledger Entry Type];
                                                   OptionCaptionML=[DAN=Poster,Budgetposter;
                                                                    ENU=Entries,Budget Entries];
                                                   OptionString=Entries,Budget Entries }
    { 7   ;   ;Amount Type         ;Option        ;CaptionML=[DAN=Bel�bstype;
                                                              ENU=Amount Type];
                                                   OptionCaptionML=[DAN=Nettobel�b,Debetbel�b,Kreditbel�b;
                                                                    ENU=Net Amount,Debit Amount,Credit Amount];
                                                   OptionString=Net Amount,Debit Amount,Credit Amount }
    { 8   ;   ;Formula             ;Code80        ;OnValidate=VAR
                                                                TempAccSchedLine@1000 : TEMPORARY Record 85;
                                                              BEGIN
                                                                TempAccSchedLine.CheckFormula(Formula);
                                                              END;

                                                   CaptionML=[DAN=Formel;
                                                              ENU=Formula] }
    { 9   ;   ;Comparison Date Formula;DateFormula;OnValidate=BEGIN
                                                                IF FORMAT("Comparison Date Formula") <> '' THEN
                                                                  VALIDATE("Comparison Period Formula",'');
                                                              END;

                                                   CaptionML=[DAN=Sammenligningsdatoformel;
                                                              ENU=Comparison Date Formula] }
    { 10  ;   ;Show Opposite Sign  ;Boolean       ;CaptionML=[DAN=Vis modsat fortegn;
                                                              ENU=Show Opposite Sign] }
    { 11  ;   ;Show                ;Option        ;InitValue=Always;
                                                   CaptionML=[DAN=Vis;
                                                              ENU=Show];
                                                   OptionCaptionML=[DAN=Altid,Aldrig,Hvis positiv,Hvis negativ;
                                                                    ENU=Always,Never,When Positive,When Negative];
                                                   OptionString=Always,Never,When Positive,When Negative;
                                                   NotBlank=Yes }
    { 12  ;   ;Rounding Factor     ;Option        ;CaptionML=[DAN=Afrundingsfaktor;
                                                              ENU=Rounding Factor];
                                                   OptionCaptionML=[DAN=Ingen,1,1000,1000000;
                                                                    ENU=None,1,1000,1000000];
                                                   OptionString=None,1,1000,1000000 }
    { 13  ;   ;Show Indented Lines ;Option        ;CaptionML=[DAN=Vis indrykkede linjer;
                                                              ENU=Show Indented Lines];
                                                   OptionCaptionML=[DAN=Alle,Kun indrykkede,Kun ikke-indrykkede;
                                                                    ENU=All,Indented Only,Non-Indented Only];
                                                   OptionString=All,Indented Only,Non-Indented Only }
    { 14  ;   ;Comparison Period Formula;Code20   ;OnValidate=VAR
                                                                Steps@1000 : Integer;
                                                                RangeFromInt@1002 : Integer;
                                                                RangeToInt@1003 : Integer;
                                                                Type@1004 : ' ,Period,Fiscal year,Fiscal Halfyear,Fiscal Quarter';
                                                                RangeFromType@1006 : 'Int,CP,LP';
                                                                RangeToType@1007 : 'Int,CP,LP';
                                                              BEGIN
                                                                "Comparison Period Formula LCID" := GLOBALLANGUAGE;
                                                                ParsePeriodFormula(
                                                                  "Comparison Period Formula",
                                                                  Steps,Type,RangeFromType,RangeToType,RangeFromInt,RangeToInt);
                                                                IF "Comparison Period Formula" <> '' THEN
                                                                  CLEAR("Comparison Date Formula");
                                                              END;

                                                   CaptionML=[DAN=Sammenligningsperiodeformel;
                                                              ENU=Comparison Period Formula] }
    { 15  ;   ;Business Unit Totaling;Text80      ;TableRelation="Business Unit";
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Samment�lling for koncernvirksomhed;
                                                              ENU=Business Unit Totaling] }
    { 16  ;   ;Dimension 1 Totaling;Text80        ;ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   AccessByPermission=TableData 348=R;
                                                   CaptionML=[DAN=Dimension 1 - samment�lling;
                                                              ENU=Dimension 1 Totaling];
                                                   CaptionClass=GetCaptionClass(5) }
    { 17  ;   ;Dimension 2 Totaling;Text80        ;ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   AccessByPermission=TableData 348=R;
                                                   CaptionML=[DAN=Dimension 2 - samment�lling;
                                                              ENU=Dimension 2 Totaling];
                                                   CaptionClass=GetCaptionClass(6) }
    { 18  ;   ;Dimension 3 Totaling;Text80        ;ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   AccessByPermission=TableData 350=R;
                                                   CaptionML=[DAN=Dimension 3 - samment�lling;
                                                              ENU=Dimension 3 Totaling];
                                                   CaptionClass=GetCaptionClass(7) }
    { 19  ;   ;Dimension 4 Totaling;Text80        ;ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   AccessByPermission=TableData 350=R;
                                                   CaptionML=[DAN=Dimension 4 - samment�lling;
                                                              ENU=Dimension 4 Totaling];
                                                   CaptionClass=GetCaptionClass(8) }
    { 20  ;   ;Cost Center Totaling;Text80        ;CaptionML=[DAN=Omkostningsstedssamment�lling;
                                                              ENU=Cost Center Totaling] }
    { 21  ;   ;Cost Object Totaling;Text80        ;CaptionML=[DAN=Omkostningsemnesamment�lling;
                                                              ENU=Cost Object Totaling] }
    { 30  ;   ;Comparison Period Formula LCID;Integer;
                                                   CaptionML=[DAN=LCID-sammenligningsperiodeformel;
                                                              ENU=Comparison Period Formula LCID] }
  }
  KEYS
  {
    {    ;Column Layout Name,Line No.             ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      PeriodFormulaErr@1003 : TextConst '@@@=%1 - value of Comparison Period Formula field;DAN=%1 er ikke en gyldig periodeformel.;ENU=%1 is not a valid Period Formula.';
      Text002@1002 : TextConst '@@@=Period;DAN=P;ENU=P';
      Text003@1001 : TextConst '@@@=Fiscal year;DAN=R�;ENU=FY';
      Text004@1005 : TextConst '@@@=Current Period;DAN=NP;ENU=CP';
      Text005@1004 : TextConst '@@@=Last period;DAN=FP;ENU=LP';
      Text006@1014 : TextConst 'DAN=1,6,,Dimension 1-filter;ENU=1,6,,Dimension 1 Filter';
      Text007@1013 : TextConst 'DAN=1,6,,Dimension 2-filter;ENU=1,6,,Dimension 2 Filter';
      Text008@1012 : TextConst 'DAN=1,6,,Dimension 3-filter;ENU=1,6,,Dimension 3 Filter';
      Text009@1011 : TextConst 'DAN=1,6,,Dimension 4-filter;ENU=1,6,,Dimension 4 Filter';
      Text010@1010 : TextConst 'DAN=,, Samment�lling;ENU=,, Totaling';
      Text011@1009 : TextConst 'DAN=1,5,,Dimension 1-samment�lling;ENU=1,5,,Dimension 1 Totaling';
      Text012@1008 : TextConst 'DAN=1,5,,Dimension 2-samment�lling;ENU=1,5,,Dimension 2 Totaling';
      Text013@1007 : TextConst 'DAN=1,5,,Dimension 3-samment�lling;ENU=1,5,,Dimension 3 Totaling';
      Text014@1006 : TextConst 'DAN=1,5,,Dimension 4-samment�lling;ENU=1,5,,Dimension 4 Totaling';
      Text015@1015 : TextConst 'DAN=%1 refererer til %2 %3, som ikke findes. Feltet %4 i tabellen %5 er blevet slettet.;ENU=The %1 refers to %2 %3, which does not exist. The field %4 on table %5 has now been deleted.';
      ColumnLayoutName@1016 : Record 333;
      AnalysisView@1017 : Record 363;
      GLSetup@1018 : Record 98;
      HasGLSetup@1019 : Boolean;

    [External]
    PROCEDURE ParsePeriodFormula@26(FormulaExpression@1002 : Code[20];VAR Steps@1001 : Integer;VAR Type@1006 : ' ,Period,Fiscal Year';VAR RangeFromType@1009 : 'Int,CP,LP';VAR RangeToType@1008 : 'Int,CP,LP';VAR RangeFromInt@1003 : Integer;VAR RangeToInt@1000 : Integer);
    VAR
      OldLanguageID@1004 : Integer;
      FormulaParsed@1005 : Boolean;
    BEGIN
      IF "Comparison Period Formula LCID" = 0 THEN
        "Comparison Period Formula LCID" := GLOBALLANGUAGE;

      OldLanguageID := GLOBALLANGUAGE;
      GLOBALLANGUAGE("Comparison Period Formula LCID");
      FormulaParsed := TryParsePeriodFormula(FormulaExpression,Steps,Type,RangeFromType,RangeToType,RangeFromInt,RangeToInt);
      GLOBALLANGUAGE(OldLanguageID);

      IF NOT FormulaParsed THEN
        ERROR(GETLASTERRORTEXT);
    END;

    [TryFunction]
    LOCAL PROCEDURE TryParsePeriodFormula@12(FormulaExpression@1002 : Code[20];VAR Steps@1001 : Integer;VAR Type@1006 : ' ,Period,Fiscal Year';VAR RangeFromType@1009 : 'Int,CP,LP';VAR RangeToType@1008 : 'Int,CP,LP';VAR RangeFromInt@1003 : Integer;VAR RangeToInt@1000 : Integer);
    VAR
      OriginalFormula@1004 : Code[20];
    BEGIN
      // <PeriodFormula> ::= <signed integer> <formula> | blank
      // <signed integer> ::= <sign> <positive integer> | blank
      // <sign> ::= + | - | blank
      // <positive integer> ::= <digit 1-9> <digits>
      // <digit 1-9> ::= 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9
      // <digits> ::= 0 <digits> | <digit 1-9> <digits> | blank
      // <formula> ::= P | FY <range> | FH <range> | FQ <range>
      // <range> ::= blank | [<range2>]
      // <range2> ::= <index> .. <index> | <index>
      // <index> ::= <positive integer> | CP | LP

      OriginalFormula := FormulaExpression;
      FormulaExpression := DELCHR(FormulaExpression);

      IF NOT ParseFormula(FormulaExpression,Steps,Type) THEN
        ERROR(PeriodFormulaErr,OriginalFormula);

      IF Type = Type::"Fiscal Year" THEN
        IF NOT ParseRange(FormulaExpression,RangeFromType,RangeFromInt,RangeToType,RangeToInt) THEN
          ERROR(PeriodFormulaErr,OriginalFormula);

      IF FormulaExpression <> '' THEN
        ERROR(PeriodFormulaErr,OriginalFormula);
    END;

    LOCAL PROCEDURE ParseFormula@5(VAR FormulaExpression@1002 : Code[20];VAR Steps@1001 : Integer;VAR Type@1006 : ' ,Period,Fiscal Year') : Boolean;
    BEGIN
      Steps := 0;
      Type := Type::" ";

      IF FormulaExpression = '' THEN
        EXIT(TRUE);

      IF NOT ParseSignedInteger(FormulaExpression,Steps) THEN
        EXIT(FALSE);

      IF FormulaExpression = '' THEN
        EXIT(FALSE);

      IF NOT ParseType(FormulaExpression,Type) THEN
        EXIT(FALSE);

      EXIT(TRUE);
    END;

    LOCAL PROCEDURE ParseSignedInteger@1(VAR FormulaExpression@1000 : Code[20];VAR Int@1001 : Integer) : Boolean;
    BEGIN
      Int := 0;

      CASE COPYSTR(FormulaExpression,1,1) OF
        '-':
          BEGIN
            FormulaExpression := COPYSTR(FormulaExpression,2);
            IF NOT ParseInt(FormulaExpression,Int,FALSE) THEN
              EXIT(FALSE);
            Int := -Int;
          END;
        '+':
          BEGIN
            FormulaExpression := COPYSTR(FormulaExpression,2);
            IF NOT ParseInt(FormulaExpression,Int,FALSE) THEN
              EXIT(FALSE);
          END;
        ELSE BEGIN
          IF NOT ParseInt(FormulaExpression,Int,TRUE) THEN
            EXIT(FALSE);
        END;
      END;
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE ParseInt@2(VAR FormulaExpression@1001 : Code[20];VAR Int@1000 : Integer;AllowNotInt@1003 : Boolean) : Boolean;
    VAR
      IntegerStr@1002 : Code[20];
    BEGIN
      IF COPYSTR(FormulaExpression,1,1) IN ['1'..'9'] THEN
        REPEAT
          IntegerStr := IntegerStr + COPYSTR(FormulaExpression,1,1);
          FormulaExpression := COPYSTR(FormulaExpression,2);
          IF FormulaExpression = '' THEN
            EXIT(FALSE);
        UNTIL NOT (COPYSTR(FormulaExpression,1,1) IN ['0'..'9'])
      ELSE
        EXIT(AllowNotInt);
      EVALUATE(Int,IntegerStr);
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE ParseType@3(VAR FormulaExpression@1001 : Code[20];VAR Type@1000 : ' ,Period,Fiscal Year') : Boolean;
    BEGIN
      CASE ReadToken(FormulaExpression) OF
        Text002:
          Type := Type::Period;
        Text003:
          Type := Type::"Fiscal Year";
        ELSE
          EXIT(FALSE);
      END;
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE ParseRange@6(VAR FormulaExpression@1002 : Code[20];VAR FromType@1001 : 'Int,CP,LP';VAR FromInt@1004 : Integer;VAR ToType@1006 : 'Int,CP,LP';VAR ToInt@1005 : Integer) : Boolean;
    BEGIN
      FromType := FromType::CP;
      ToType := ToType::CP;

      IF FormulaExpression = '' THEN
        EXIT(TRUE);

      IF NOT ParseToken(FormulaExpression,'[') THEN
        EXIT(FALSE);

      IF NOT ParseIndex(FormulaExpression,FromType,FromInt) THEN
        EXIT(FALSE);
      IF FormulaExpression = '' THEN
        EXIT(FALSE);

      IF COPYSTR(FormulaExpression,1,1) = '.' THEN BEGIN
        IF NOT ParseToken(FormulaExpression,'..') THEN
          EXIT(FALSE);
        IF NOT ParseIndex(FormulaExpression,ToType,ToInt) THEN
          EXIT(FALSE);
      END ELSE BEGIN
        ToType := FromType;
        ToInt := FromInt;
      END;

      IF NOT ParseToken(FormulaExpression,']') THEN
        EXIT(FALSE);

      EXIT(TRUE);
    END;

    LOCAL PROCEDURE ParseIndex@11(VAR FormulaExpression@1002 : Code[20];VAR IndexType@1001 : 'Int,CP,LP';VAR Index@1004 : Integer) : Boolean;
    BEGIN
      IF FormulaExpression = '' THEN
        EXIT(FALSE);

      IF ParseInt(FormulaExpression,Index,FALSE) THEN
        IndexType := IndexType::Int
      ELSE
        CASE ReadToken(FormulaExpression) OF
          Text004:
            IndexType := IndexType::CP;
          Text005:
            IndexType := IndexType::LP;
          ELSE
            EXIT(FALSE);
        END;

      EXIT(TRUE);
    END;

    LOCAL PROCEDURE ParseToken@13(VAR FormulaExpression@1000 : Code[20];Token@1001 : Code[20]) : Boolean;
    BEGIN
      IF COPYSTR(FormulaExpression,1,STRLEN(Token)) <> Token THEN
        EXIT(FALSE);
      FormulaExpression := COPYSTR(FormulaExpression,STRLEN(Token) + 1);
      EXIT(TRUE)
    END;

    LOCAL PROCEDURE ReadToken@7(VAR FormulaExpression@1000 : Code[20]) : Code[20];
    VAR
      Token@1001 : Code[20];
      p@1002 : Integer;
    BEGIN
      FOR p := 1 TO STRLEN(FormulaExpression) DO BEGIN
        IF COPYSTR(FormulaExpression,p,1) IN ['[',']','.'] THEN BEGIN
          FormulaExpression := COPYSTR(FormulaExpression,STRLEN(Token) + 1);
          EXIT(Token);
        END;
        Token := Token + COPYSTR(FormulaExpression,p,1);
      END;

      FormulaExpression := '';
      EXIT(Token);
    END;

    [Internal]
    PROCEDURE LookUpDimFilter@57(DimNo@1000 : Integer;VAR Text@1001 : Text[250]) : Boolean;
    VAR
      DimVal@1002 : Record 349;
      CostAccSetup@1004 : Record 1108;
      DimValList@1003 : Page 560;
    BEGIN
      GetColLayoutSetup;
      IF CostAccSetup.GET THEN;
      CASE DimNo OF
        1:
          DimVal.SETRANGE("Dimension Code",AnalysisView."Dimension 1 Code");
        2:
          DimVal.SETRANGE("Dimension Code",AnalysisView."Dimension 2 Code");
        3:
          DimVal.SETRANGE("Dimension Code",AnalysisView."Dimension 3 Code");
        4:
          DimVal.SETRANGE("Dimension Code",AnalysisView."Dimension 4 Code");
        5:
          DimVal.SETRANGE("Dimension Code",CostAccSetup."Cost Center Dimension");
        6:
          DimVal.SETRANGE("Dimension Code",CostAccSetup."Cost Object Dimension");
      END;
      DimValList.LOOKUPMODE(TRUE);
      DimValList.SETTABLEVIEW(DimVal);
      IF DimValList.RUNMODAL = ACTION::LookupOK THEN BEGIN
        DimValList.GETRECORD(DimVal);
        Text := DimValList.GetSelectionFilter;
        EXIT(TRUE);
      END;
      EXIT(FALSE)
    END;

    LOCAL PROCEDURE GetCaptionClass@4(AnalysisViewDimType@1000 : Integer) : Text[250];
    BEGIN
      GetColLayoutSetup;
      CASE AnalysisViewDimType OF
        1:
          BEGIN
            IF AnalysisView."Dimension 1 Code" <> '' THEN
              EXIT('1,6,' + AnalysisView."Dimension 1 Code");

            EXIT(Text006);
          END;
        2:
          BEGIN
            IF AnalysisView."Dimension 2 Code" <> '' THEN
              EXIT('1,6,' + AnalysisView."Dimension 2 Code");

            EXIT(Text007);
          END;
        3:
          BEGIN
            IF AnalysisView."Dimension 3 Code" <> '' THEN
              EXIT('1,6,' + AnalysisView."Dimension 3 Code");

            EXIT(Text008);
          END;
        4:
          BEGIN
            IF AnalysisView."Dimension 4 Code" <> '' THEN
              EXIT('1,6,' + AnalysisView."Dimension 4 Code");

            EXIT(Text009);
          END;
        5:
          BEGIN
            IF AnalysisView."Dimension 1 Code" <> '' THEN
              EXIT('1,5,' + AnalysisView."Dimension 1 Code" + Text010);

            EXIT(Text011);
          END;
        6:
          BEGIN
            IF AnalysisView."Dimension 2 Code" <> '' THEN
              EXIT('1,5,' + AnalysisView."Dimension 2 Code" + Text010);

            EXIT(Text012);
          END;
        7:
          BEGIN
            IF AnalysisView."Dimension 3 Code" <> '' THEN
              EXIT('1,5,' + AnalysisView."Dimension 3 Code" + Text010);

            EXIT(Text013);
          END;
        8:
          BEGIN
            IF AnalysisView."Dimension 4 Code" <> '' THEN
              EXIT('1,5,' + AnalysisView."Dimension 4 Code" + Text010);

            EXIT(Text014);
          END;
      END;
    END;

    LOCAL PROCEDURE GetColLayoutSetup@8();
    BEGIN
      IF "Column Layout Name" <> ColumnLayoutName.Name THEN
        ColumnLayoutName.GET("Column Layout Name");
      IF ColumnLayoutName."Analysis View Name" <> '' THEN
        IF ColumnLayoutName."Analysis View Name" <> AnalysisView.Code THEN
          IF NOT AnalysisView.GET(ColumnLayoutName."Analysis View Name") THEN BEGIN
            MESSAGE(
              Text015,
              ColumnLayoutName.TABLECAPTION,AnalysisView.TABLECAPTION,ColumnLayoutName."Analysis View Name",
              ColumnLayoutName.FIELDCAPTION("Analysis View Name"),ColumnLayoutName.TABLECAPTION);
            ColumnLayoutName."Analysis View Name" := '';
            ColumnLayoutName.MODIFY;
          END;

      IF ColumnLayoutName."Analysis View Name" = '' THEN BEGIN
        IF NOT HasGLSetup THEN BEGIN
          GLSetup.GET;
          HasGLSetup := TRUE;
        END;
        CLEAR(AnalysisView);
        AnalysisView."Dimension 1 Code" := GLSetup."Global Dimension 1 Code";
        AnalysisView."Dimension 2 Code" := GLSetup."Global Dimension 2 Code";
      END;
    END;

    [External]
    PROCEDURE GetPeriodName@9() : Code[10];
    BEGIN
      EXIT(Text002);
    END;

    BEGIN
    END.
  }
}

