OBJECT Table 840 Cash Flow Forecast
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    Permissions=TableData 842=rimd,
                TableData 847=rimd;
    OnInsert=BEGIN
               IF "No." = '' THEN BEGIN
                 CFSetup.GET;
                 CFSetup.TESTFIELD("Cash Flow Forecast No. Series");
                 NoSeriesMgt.InitSeries(CFSetup."Cash Flow Forecast No. Series",xRec."No. Series",0D,"No.","No. Series");
               END;

               "Creation Date" := WORKDATE;
               "Created By" := USERID;
               "Manual Payments From" := WORKDATE;
               "G/L Budget From" := WORKDATE;
             END;

    OnDelete=BEGIN
               IF GetShowInChart THEN
                 CFSetup.SetChartRoleCenterCFNo('');

               CFAccountComment.RESET;
               CFAccountComment.SETRANGE("Table Name",CFAccountComment."Table Name"::"Cash Flow Forecast");
               CFAccountComment.SETRANGE("No.","No.");
               CFAccountComment.DELETEALL;

               CFForecastEntry.RESET;
               CFForecastEntry.SETCURRENTKEY("Cash Flow Forecast No.");
               CFForecastEntry.SETRANGE("Cash Flow Forecast No.","No.");
               CFForecastEntry.DELETEALL;
             END;

    CaptionML=[DAN=Pengestr�msprognose;
               ENU=Cash Flow Forecast];
    LookupPageID=Page849;
    DrillDownPageID=Page849;
  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Code20        ;AltSearchField=Search Name;
                                                   CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 2   ;   ;Search Name         ;Code50        ;CaptionML=[DAN=S�genavn;
                                                              ENU=Search Name] }
    { 3   ;   ;Description         ;Text50        ;OnValidate=BEGIN
                                                                IF ("Search Name" = UPPERCASE(xRec.Description)) OR ("Search Name" = '') THEN
                                                                  "Search Name" := Description;
                                                              END;

                                                   CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 4   ;   ;Description 2       ;Text50        ;CaptionML=[DAN=Beskrivelse 2;
                                                              ENU=Description 2] }
    { 5   ;   ;Consider Discount   ;Boolean       ;OnValidate=BEGIN
                                                                IF NOT "Consider Discount" THEN
                                                                  "Consider Pmt. Disc. Tol. Date" := FALSE;
                                                              END;

                                                   CaptionML=[DAN=Regn med kontant rabat;
                                                              ENU=Consider Discount] }
    { 6   ;   ;Creation Date       ;Date          ;CaptionML=[DAN=Oprettelsesdato;
                                                              ENU=Creation Date] }
    { 7   ;   ;Created By          ;Code50        ;DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Oprettet af;
                                                              ENU=Created By] }
    { 8   ;   ;Manual Payments To  ;Date          ;CaptionML=[DAN=Manuelle betalinger til;
                                                              ENU=Manual Payments To] }
    { 9   ;   ;Comment             ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Cash Flow Account Comment" WHERE (Table Name=CONST(Cash Flow Forecast),
                                                                                                        No.=FIELD(No.)));
                                                   CaptionML=[DAN=Bem�rkning;
                                                              ENU=Comment] }
    { 10  ;   ;No. Series          ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Nummerserie;
                                                              ENU=No. Series];
                                                   Editable=No }
    { 11  ;   ;Manual Payments From;Date          ;CaptionML=[DAN=Manuelle betalinger fra;
                                                              ENU=Manual Payments From] }
    { 12  ;   ;G/L Budget From     ;Date          ;AccessByPermission=TableData 95=R;
                                                   CaptionML=[DAN=Finansbudget fra;
                                                              ENU=G/L Budget From] }
    { 13  ;   ;G/L Budget To       ;Date          ;AccessByPermission=TableData 95=R;
                                                   CaptionML=[DAN=Finansbudget til;
                                                              ENU=G/L Budget To] }
    { 14  ;   ;Consider CF Payment Terms;Boolean  ;CaptionML=[DAN=Regn med PS-betalingsbetingelser;
                                                              ENU=Consider CF Payment Terms] }
    { 15  ;   ;Consider Pmt. Disc. Tol. Date;Boolean;
                                                   CaptionML=[DAN=Regn med kontant rabatdato;
                                                              ENU=Consider Pmt. Disc. Tol. Date] }
    { 16  ;   ;Consider Pmt. Tol. Amount;Boolean  ;CaptionML=[DAN=Regn med betalingstolerance;
                                                              ENU=Consider Pmt. Tol. Amount] }
    { 17  ;   ;Account No. Filter  ;Code20        ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Kontonr.filter;
                                                              ENU=Account No. Filter] }
    { 18  ;   ;Source Type Filter  ;Option        ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Kildetypefilter;
                                                              ENU=Source Type Filter];
                                                   OptionCaptionML=[DAN=" ,Tilgodehavender,G�ld,Likvide midler,Manuel pengestr�msudgift,Manuel pengestr�msindt�gt,Salgsordre,K�bsordre,Anl�gsbudget,Afh�ndelse af faste anl�gsaktiver,Serviceordrer,Finansbudget,,,Sag,Skat,Cortana Intelligence";
                                                                    ENU=" ,Receivables,Payables,Liquid Funds,Cash Flow Manual Expense,Cash Flow Manual Revenue,Sales Order,Purchase Order,Fixed Assets Budget,Fixed Assets Disposal,Service Orders,G/L Budget,,,Job,Tax,Cortana Intelligence"];
                                                   OptionString=[ ,Receivables,Payables,Liquid Funds,Cash Flow Manual Expense,Cash Flow Manual Revenue,Sales Order,Purchase Order,Fixed Assets Budget,Fixed Assets Disposal,Service Orders,G/L Budget,,,Job,Tax,Cortana Intelligence] }
    { 19  ;   ;Cash Flow Date Filter;Date         ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Pengestr�msdatofilter;
                                                              ENU=Cash Flow Date Filter] }
    { 20  ;   ;Amount (LCY)        ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Cash Flow Forecast Entry"."Amount (LCY)" WHERE (Cash Flow Forecast No.=FIELD(No.),
                                                                                                                    Cash Flow Date=FIELD(Cash Flow Date Filter),
                                                                                                                    Source Type=FIELD(Source Type Filter),
                                                                                                                    Cash Flow Account No.=FIELD(Account No. Filter),
                                                                                                                    Positive=FIELD(Positive Filter)));
                                                   CaptionML=[DAN=Bel�b (RV);
                                                              ENU=Amount (LCY)] }
    { 21  ;   ;Positive Filter     ;Boolean       ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Positivt filter;
                                                              ENU=Positive Filter] }
    { 22  ;   ;Overdue CF Dates to Work Date;Boolean;
                                                   CaptionML=[DAN=Forfaldne PS-datoer til arbejdsdato;
                                                              ENU=Overdue CF Dates to Work Date] }
    { 23  ;   ;Default G/L Budget Name;Code10     ;TableRelation="G/L Budget Name";
                                                   CaptionML=[DAN=Standardfinansbudgetnavn;
                                                              ENU=Default G/L Budget Name] }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;No.,Description,Description 2,Creation Date }
  }
  CODE
  {
    VAR
      CFSetup@1000 : Record 843;
      CashFlowForecast@1001 : Record 840;
      CFAccountComment@1002 : Record 842;
      CFForecastEntry@1003 : Record 847;
      NoSeriesMgt@1005 : Codeunit 396;

    [External]
    PROCEDURE AssistEdit@2(OldCashFlowForecast@1000 : Record 840) : Boolean;
    BEGIN
      WITH CashFlowForecast DO BEGIN
        CashFlowForecast := Rec;
        CFSetup.GET;
        CFSetup.TESTFIELD("Cash Flow Forecast No. Series");
        IF NoSeriesMgt.SelectSeries(CFSetup."Cash Flow Forecast No. Series",OldCashFlowForecast."No. Series","No. Series") THEN BEGIN
          CFSetup.GET;
          CFSetup.TESTFIELD("Cash Flow Forecast No. Series");
          NoSeriesMgt.SetSeries("No.");
          Rec := CashFlowForecast;
          EXIT(TRUE);
        END;
      END;
    END;

    [External]
    PROCEDURE DrillDown@17();
    VAR
      CFForecastEntry@1000 : Record 847;
    BEGIN
      CFForecastEntry.DrillDownOnEntries(Rec);
    END;

    [External]
    PROCEDURE CalcAmountForPosNeg@18(PositiveAmount@1000 : Boolean) : Decimal;
    BEGIN
      SETRANGE("Positive Filter",PositiveAmount);
      EXIT(CalcAmount);
    END;

    [External]
    PROCEDURE DrillDownPosNegEntries@16(PositiveAmount@1000 : Boolean);
    BEGIN
      SETRANGE("Positive Filter",PositiveAmount);
      DrillDown;
    END;

    [External]
    PROCEDURE CalcAmountForAccountNo@12(AccountNo@1000 : Code[20]) : Decimal;
    BEGIN
      SetAccountNoFilter(AccountNo);
      EXIT(CalcAmount);
    END;

    [External]
    PROCEDURE SetAccountNoFilter@13(AccountNo@1000 : Code[20]);
    BEGIN
      IF AccountNo = '' THEN
        SETRANGE("Account No. Filter")
      ELSE
        SETRANGE("Account No. Filter",AccountNo);
    END;

    [External]
    PROCEDURE DrillDownEntriesForAccNo@15(AccountNo@1000 : Code[20]);
    BEGIN
      SetAccountNoFilter(AccountNo);
      DrillDown;
    END;

    [External]
    PROCEDURE CalcAmountFromSource@4(SourceType@1001 : Option) : Decimal;
    BEGIN
      SetSourceTypeFilter(SourceType);
      EXIT(CalcAmount);
    END;

    [External]
    PROCEDURE SetSourceTypeFilter@7(SourceType@1000 : Option);
    BEGIN
      IF SourceType = 0 THEN
        SETRANGE("Source Type Filter")
      ELSE
        SETRANGE("Source Type Filter",SourceType);
    END;

    [External]
    PROCEDURE DrillDownEntriesFromSource@5(SourceType@1000 : Option);
    BEGIN
      SetSourceTypeFilter(SourceType);
      DrillDown;
    END;

    [External]
    PROCEDURE CalcAmount@14() : Decimal;
    BEGIN
      CALCFIELDS("Amount (LCY)");
      EXIT("Amount (LCY)");
    END;

    [External]
    PROCEDURE SetCashFlowDateFilter@6(FromDate@1000 : Date;ToDate@1001 : Date);
    BEGIN
      IF (FromDate = 0D) AND (ToDate = 0D) THEN
        SETRANGE("Cash Flow Date Filter")
      ELSE
        IF ToDate = 0D THEN
          SETFILTER("Cash Flow Date Filter",'%1..',FromDate)
        ELSE
          SETRANGE("Cash Flow Date Filter",FromDate,ToDate);
    END;

    [External]
    PROCEDURE PrintRecords@1();
    VAR
      CashFlowForecast@1001 : Record 840;
      CFReportSelection@1002 : Record 856;
    BEGIN
      WITH CashFlowForecast DO BEGIN
        COPY(Rec);
        CFReportSelection.SETFILTER("Report ID",'<>0');
        IF CFReportSelection.FINDSET THEN
          REPEAT
            REPORT.RUNMODAL(CFReportSelection."Report ID",TRUE,FALSE,CashFlowForecast);
          UNTIL CFReportSelection.NEXT = 0;
      END;
    END;

    [External]
    PROCEDURE LookupCashFlowFilter@9(VAR Text@1000 : Text) : Boolean;
    VAR
      CashFlowForecastList@1002 : Page 849;
    BEGIN
      CashFlowForecastList.LOOKUPMODE(TRUE);
      IF CashFlowForecastList.RUNMODAL = ACTION::LookupOK THEN BEGIN
        Text := CashFlowForecastList.GetSelectionFilter;
        EXIT(TRUE);
      END;
      EXIT(FALSE)
    END;

    [External]
    PROCEDURE CalculateAllAmounts@3(FromDate@1003 : Date;ToDate@1002 : Date;VAR Amounts@1010 : ARRAY [14] OF Decimal;VAR TotalAmount@1001 : Decimal);
    VAR
      SourceType@1000 : Option;
    BEGIN
      CLEAR(Amounts);
      SetCashFlowDateFilter(FromDate,ToDate);
      FOR SourceType := 1 TO ARRAYLEN(Amounts) DO
        Amounts[SourceType] := CalcAmountFromSource(SourceType);
      TotalAmount := CalcAmountFromSource(0);
    END;

    [External]
    PROCEDURE ValidateShowInChart@8(ShowInChart@1000 : Boolean) : Boolean;
    VAR
      NewCashFlowNo@1003 : Code[20];
    BEGIN
      IF ShowInChart THEN
        NewCashFlowNo := "No."
      ELSE
        NewCashFlowNo := '';

      CFSetup.GET;
      CFSetup.VALIDATE("CF No. on Chart in Role Center",NewCashFlowNo);
      CFSetup.MODIFY;
      EXIT(GetShowInChart);
    END;

    [External]
    PROCEDURE GetShowInChart@10() : Boolean;
    VAR
      ChartRoleCenterCFNo@1000 : Code[20];
    BEGIN
      ChartRoleCenterCFNo := CFSetup.GetChartRoleCenterCFNo;
      IF ChartRoleCenterCFNo = '' THEN
        EXIT(FALSE);

      EXIT("No." = ChartRoleCenterCFNo);
    END;

    [External]
    PROCEDURE GetEntryDate@11(Which@1001 : 'First,Last') : Date;
    VAR
      CFForecastEntry@1000 : Record 847;
    BEGIN
      CFForecastEntry.SETCURRENTKEY("Cash Flow Forecast No.","Cash Flow Date");
      CFForecastEntry.SETRANGE("Cash Flow Forecast No.","No.");
      CASE Which OF
        Which::First:
          IF NOT CFForecastEntry.FINDFIRST THEN
            EXIT(0D);
        Which::Last:
          IF NOT CFForecastEntry.FINDLAST THEN
            EXIT(0D);
      END;
      EXIT(CFForecastEntry."Cash Flow Date");
    END;

    BEGIN
    END.
  }
}

