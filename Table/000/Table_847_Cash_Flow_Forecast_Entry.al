OBJECT Table 847 Cash Flow Forecast Entry
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Pengestr›msprognosepost;
               ENU=Cash Flow Forecast Entry];
    LookupPageID=Page850;
    DrillDownPageID=Page850;
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;CaptionML=[DAN=L›benr.;
                                                              ENU=Entry No.] }
    { 2   ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   OnValidate=VAR
                                                                UserMgt@1000 : Codeunit 418;
                                                              BEGIN
                                                                UserMgt.ValidateUserID("User ID");
                                                              END;

                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("User ID");
                                                            END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 10  ;   ;Cash Flow Forecast No.;Code20      ;TableRelation="Cash Flow Forecast";
                                                   CaptionML=[DAN=Pengestr›msprognosenr.;
                                                              ENU=Cash Flow Forecast No.] }
    { 11  ;   ;Cash Flow Date      ;Date          ;CaptionML=[DAN=Pengestr›msdato;
                                                              ENU=Cash Flow Date] }
    { 12  ;   ;Document No.        ;Code20        ;CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.] }
    { 13  ;   ;Cash Flow Account No.;Code20       ;TableRelation="Cash Flow Account";
                                                   CaptionML=[DAN=Pengestr›mskontonr.;
                                                              ENU=Cash Flow Account No.] }
    { 14  ;   ;Source Type         ;Option        ;CaptionML=[DAN=Kildetype;
                                                              ENU=Source Type];
                                                   OptionCaptionML=[DAN=" ,Tilgodehavender,G‘ld,Likvide midler,Manuel pengestr›msudgift,Manuel pengestr›msindt‘gt,Salgsordre,K›bsordre,Anl‘gsbudget,Afh‘ndelse af faste anl‘gsaktiver,Serviceordrer,Finansbudget,,,Sag,Skat,Cortana Intelligence";
                                                                    ENU=" ,Receivables,Payables,Liquid Funds,Cash Flow Manual Expense,Cash Flow Manual Revenue,Sales Order,Purchase Order,Fixed Assets Budget,Fixed Assets Disposal,Service Orders,G/L Budget,,,Job,Tax,Cortana Intelligence"];
                                                   OptionString=[ ,Receivables,Payables,Liquid Funds,Cash Flow Manual Expense,Cash Flow Manual Revenue,Sales Order,Purchase Order,Fixed Assets Budget,Fixed Assets Disposal,Service Orders,G/L Budget,,,Job,Tax,Cortana Intelligence];
                                                   Editable=No }
    { 15  ;   ;Description         ;Text250       ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 16  ;   ;Overdue             ;Boolean       ;CaptionML=[DAN=Forfalden;
                                                              ENU=Overdue];
                                                   Editable=No }
    { 17  ;   ;Document Date       ;Date          ;CaptionML=[DAN=Bilagsdato;
                                                              ENU=Document Date] }
    { 21  ;   ;Payment Discount    ;Decimal       ;CaptionML=[DAN=Kontantrabat;
                                                              ENU=Payment Discount] }
    { 22  ;   ;Associated Entry No.;Integer       ;CaptionML=[DAN=Tilh›rende l›benr.;
                                                              ENU=Associated Entry No.] }
    { 23  ;   ;Associated Document No.;Code20     ;CaptionML=[DAN=Tilh›rende bilagsnr.;
                                                              ENU=Associated Document No.] }
    { 24  ;   ;Global Dimension 2 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   CaptionML=[DAN=Global dimension 2-kode;
                                                              ENU=Global Dimension 2 Code];
                                                   CaptionClass='1,1,2' }
    { 25  ;   ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   CaptionML=[DAN=Global dimension 1-kode;
                                                              ENU=Global Dimension 1 Code];
                                                   CaptionClass='1,1,1' }
    { 26  ;   ;Recurring Method    ;Option        ;CaptionML=[DAN=Gentagelsesprincip;
                                                              ENU=Recurring Method];
                                                   OptionCaptionML=[DAN=,Fast,Variabel;
                                                                    ENU=,Fixed,Variable];
                                                   OptionString=,Fixed,Variable;
                                                   BlankZero=Yes }
    { 29  ;   ;Amount (LCY)        ;Decimal       ;OnValidate=BEGIN
                                                                Positive := "Amount (LCY)" > 0;
                                                              END;

                                                   CaptionML=[DAN=Bel›b (RV);
                                                              ENU=Amount (LCY)] }
    { 30  ;   ;Positive            ;Boolean       ;CaptionML=[DAN=Positiv;
                                                              ENU=Positive];
                                                   Editable=No }
    { 33  ;   ;Source No.          ;Code20        ;TableRelation=IF (Source Type=CONST(Liquid Funds)) "G/L Account"
                                                                 ELSE IF (Source Type=CONST(Receivables)) "Cust. Ledger Entry"."Document No."
                                                                 ELSE IF (Source Type=CONST(Payables)) "Vendor Ledger Entry"."Document No."
                                                                 ELSE IF (Source Type=CONST(Fixed Assets Budget)) "Fixed Asset"
                                                                 ELSE IF (Source Type=CONST(Fixed Assets Disposal)) "Fixed Asset"
                                                                 ELSE IF (Source Type=CONST(Sales Order)) "Sales Header".No. WHERE (Document Type=CONST(Order))
                                                                 ELSE IF (Source Type=CONST(Purchase Order)) "Purchase Header".No. WHERE (Document Type=CONST(Order))
                                                                 ELSE IF (Source Type=CONST(Service Orders)) "Service Header".No. WHERE (Document Type=CONST(Order))
                                                                 ELSE IF (Source Type=CONST(Cash Flow Manual Expense)) "Cash Flow Manual Expense"
                                                                 ELSE IF (Source Type=CONST(Cash Flow Manual Revenue)) "Cash Flow Manual Revenue"
                                                                 ELSE IF (Source Type=CONST(G/L Budget)) "G/L Account"
                                                                 ELSE IF (Source Type=CONST(Job)) Job.No.;
                                                   CaptionML=[DAN=Kildenr.;
                                                              ENU=Source No.] }
    { 35  ;   ;G/L Budget Name     ;Code10        ;TableRelation="G/L Budget Name";
                                                   CaptionML=[DAN=Finansbudgetnavn;
                                                              ENU=G/L Budget Name] }
    { 480 ;   ;Dimension Set ID    ;Integer       ;TableRelation="Dimension Set Entry";
                                                   OnLookup=BEGIN
                                                              ShowDimensions;
                                                            END;

                                                   CaptionML=[DAN=Dimensionsgruppe-id;
                                                              ENU=Dimension Set ID];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Entry No.                               ;Clustered=Yes }
    {    ;Cash Flow Account No.,Cash Flow Date,Cash Flow Forecast No.;
                                                   SumIndexFields=Amount (LCY) }
    {    ;Cash Flow Forecast No.,Cash Flow Account No.,Source Type,Cash Flow Date,Positive;
                                                   SumIndexFields=Amount (LCY),Payment Discount }
    {    ;Cash Flow Account No.,Cash Flow Forecast No.,Global Dimension 1 Code,Global Dimension 2 Code,Cash Flow Date;
                                                   SumIndexFields=Amount (LCY),Payment Discount }
    {    ;Cash Flow Forecast No.,Cash Flow Date    }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;Entry No.,Description,Cash Flow Account No.,Cash Flow Date,Source Type }
  }
  CODE
  {

    [External]
    PROCEDURE ShowDimensions@1001();
    VAR
      DimMgt@1000 : Codeunit 408;
    BEGIN
      DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2',TABLECAPTION,"Entry No."));
    END;

    [External]
    PROCEDURE DrillDownOnEntries@5(VAR CashFlowForecast@1000 : Record 840);
    VAR
      CFForecastEntry@1002 : Record 847;
    BEGIN
      CFForecastEntry.SETRANGE("Cash Flow Forecast No.",CashFlowForecast."No.");
      CashFlowForecast.COPYFILTER("Cash Flow Date Filter",CFForecastEntry."Cash Flow Date");
      CashFlowForecast.COPYFILTER("Source Type Filter",CFForecastEntry."Source Type");
      CashFlowForecast.COPYFILTER("Account No. Filter",CFForecastEntry."Cash Flow Account No.");
      CashFlowForecast.COPYFILTER("Positive Filter",CFForecastEntry.Positive);
      PAGE.RUN(0,CFForecastEntry);
    END;

    [Internal]
    PROCEDURE ShowSource@3(ShowDocument@1001 : Boolean);
    VAR
      CFManagement@1000 : Codeunit 841;
    BEGIN
      IF ShowDocument THEN
        CFManagement.ShowSourceDocument(Rec)
      ELSE
        CFManagement.ShowSource(Rec);
    END;

    BEGIN
    END.
  }
}

