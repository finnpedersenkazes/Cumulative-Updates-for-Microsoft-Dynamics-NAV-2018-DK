OBJECT Table 869 Cash Flow Chart Setup
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Konfiguration af pengestr�msdiagram;
               ENU=Cash Flow Chart Setup];
  }
  FIELDS
  {
    { 1   ;   ;User ID             ;Text132       ;DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 2   ;   ;Period Length       ;Option        ;CaptionML=[DAN=Periodel�ngde;
                                                              ENU=Period Length];
                                                   OptionCaptionML=[DAN=Dag,Uge,M�ned,Kvartal,�r;
                                                                    ENU=Day,Week,Month,Quarter,Year];
                                                   OptionString=Day,Week,Month,Quarter,Year }
    { 3   ;   ;Show                ;Option        ;CaptionML=[DAN=Vis;
                                                              ENU=Show];
                                                   OptionCaptionML=[DAN=Akkumuleret kontantbeholdning,�ndring i kontantbeholdning,Kombineret;
                                                                    ENU=Accumulated Cash,Change in Cash,Combined];
                                                   OptionString=Accumulated Cash,Change in Cash,Combined }
    { 4   ;   ;Start Date          ;Option        ;CaptionML=[DAN=Startdato;
                                                              ENU=Start Date];
                                                   OptionCaptionML=[DAN=F�rste postdato,Arbejdsdato;
                                                                    ENU=First Entry Date,Working Date];
                                                   OptionString=First Entry Date,Working Date }
    { 5   ;   ;Group By            ;Option        ;CaptionML=[DAN=Grupper efter;
                                                              ENU=Group By];
                                                   OptionCaptionML=[DAN=Positivt/negativt,Pengestr�mskontonr.,Kildetype;
                                                                    ENU=Positive/Negative,Account No.,Source Type];
                                                   OptionString=Positive/Negative,Account No.,Source Type }
    { 6   ;   ;Chart Type          ;Option        ;CaptionML=[DAN=Diagramtype;
                                                              ENU=Chart Type];
                                                   OptionCaptionML=[DAN=Trinlinje,Stablet omr�dediagram (%),Stablet s�jlediagram,Stablet s�jlediagram (%);
                                                                    ENU=Step Line,Stacked Area (%),Stacked Column,Stacked Column (%)];
                                                   OptionString=Step Line,Stacked Area (%),Stacked Column,Stacked Column (%) }
  }
  KEYS
  {
    {    ;User ID                                 ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      StatusTxt@1000 : TextConst '@@@=<"Cash Flow Forecast No."> | <Show> | <"Start Date"> | <"Period Length"> | <"Group By">.  (Updated: <Time>);DAN=%1 | %2 | %3 | %4 | %5 (Opdateret: %6);ENU=%1 | %2 | %3 | %4 | %5 (Updated: %6)';
      CFSetup@1001 : Record 843;

    [External]
    PROCEDURE GetCurrentSelectionText@3() : Text;
    BEGIN
      IF NOT CFSetup.GET THEN
        EXIT;
      EXIT(STRSUBSTNO(StatusTxt,CFSetup."CF No. on Chart in Role Center",Show,"Start Date","Period Length","Group By",TIME));
    END;

    [External]
    PROCEDURE GetStartDate@2() : Date;
    VAR
      CashFlowForecast@1001 : Record 840;
      Which@1002 : 'First,Last';
      StartDate@1000 : Date;
    BEGIN
      CASE "Start Date" OF
        "Start Date"::"Working Date":
          StartDate := WORKDATE;
        "Start Date"::"First Entry Date":
          BEGIN
            CFSetup.GET;
            CashFlowForecast.GET(CFSetup."CF No. on Chart in Role Center");
            StartDate := CashFlowForecast.GetEntryDate(Which::First);
          END;
      END;
      EXIT(StartDate);
    END;

    [External]
    PROCEDURE GetChartType@1() : Integer;
    VAR
      BusinessChartBuf@1000 : Record 485;
    BEGIN
      CASE "Chart Type" OF
        "Chart Type"::"Step Line":
          EXIT(BusinessChartBuf."Chart Type"::StepLine);
        "Chart Type"::"Stacked Column":
          EXIT(BusinessChartBuf."Chart Type"::StackedColumn);
      END;
    END;

    [External]
    PROCEDURE SetGroupBy@12(GroupBy@1000 : Option);
    BEGIN
      "Group By" := GroupBy;
      MODIFY;
    END;

    [External]
    PROCEDURE SetShow@8(NewShow@1000 : Option);
    BEGIN
      Show := NewShow;
      MODIFY;
    END;

    [External]
    PROCEDURE SetStartDate@6(StartDate@1000 : Option);
    BEGIN
      "Start Date" := StartDate;
      MODIFY;
    END;

    [External]
    PROCEDURE SetPeriodLength@7(PeriodLength@1000 : Option);
    BEGIN
      "Period Length" := PeriodLength;
      MODIFY;
    END;

    [External]
    PROCEDURE SetChartType@9(ChartType@1000 : Integer);
    BEGIN
      "Chart Type" := ChartType;
      MODIFY;
    END;

    BEGIN
    END.
  }
}

