OBJECT Table 197 Acc. Sched. KPI Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Kontoskema for n›gletalsbuffer;
               ENU=Acc. Sched. KPI Buffer];
  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Nr.;
                                                              ENU=No.] }
    { 2   ;   ;Date                ;Date          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dato;
                                                              ENU=Date] }
    { 3   ;   ;Closed Period       ;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Lukket periode;
                                                              ENU=Closed Period] }
    { 4   ;   ;Account Schedule Name;Code10       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kontoskemanavn;
                                                              ENU=Account Schedule Name] }
    { 5   ;   ;KPI Code            ;Code10        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=N›gletalskode;
                                                              ENU=KPI Code] }
    { 6   ;   ;KPI Name            ;Text50        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=N›gletalsnavn;
                                                              ENU=KPI Name] }
    { 7   ;   ;Net Change Actual   ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Faktisk bev‘gelse;
                                                              ENU=Net Change Actual] }
    { 8   ;   ;Balance at Date Actual;Decimal     ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Faktisk saldo til dato;
                                                              ENU=Balance at Date Actual] }
    { 9   ;   ;Net Change Budget   ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Budgetbev‘gelse;
                                                              ENU=Net Change Budget] }
    { 10  ;   ;Balance at Date Budget;Decimal     ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Budgetsaldo til dato;
                                                              ENU=Balance at Date Budget] }
    { 11  ;   ;Net Change Actual Last Year;Decimal;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Faktisk bev‘gelse sidste †r;
                                                              ENU=Net Change Actual Last Year] }
    { 12  ;   ;Balance at Date Act. Last Year;Decimal;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Faktisk saldo til dato sidste †r;
                                                              ENU=Balance at Date Act. Last Year] }
    { 13  ;   ;Net Change Budget Last Year;Decimal;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Budgetbev‘gelse sidste †r;
                                                              ENU=Net Change Budget Last Year] }
    { 14  ;   ;Balance at Date Bud. Last Year;Decimal;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Budgetsaldo til dato sidste †r;
                                                              ENU=Balance at Date Bud. Last Year] }
    { 15  ;   ;Net Change Forecast ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Prognosebev‘gelse;
                                                              ENU=Net Change Forecast] }
    { 16  ;   ;Balance at Date Forecast;Decimal   ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Prognosesaldo til dato;
                                                              ENU=Balance at Date Forecast] }
    { 17  ;   ;Dimension Set ID    ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dimensionsgruppe-id;
                                                              ENU=Dimension Set ID] }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
    {    ;Account Schedule Name,KPI Code,Dimension Set ID }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    [External]
    PROCEDURE AddColumnValue@1(ColumnLayout@1000 : Record 334;Value@1001 : Decimal);
    BEGIN
      IF ColumnLayout."Column Type" = ColumnLayout."Column Type"::"Net Change" THEN
        IF ColumnLayout."Ledger Entry Type" = ColumnLayout."Ledger Entry Type"::Entries THEN
          IF FORMAT(ColumnLayout."Comparison Date Formula") = '-1Y' THEN
            "Net Change Actual Last Year" += Value
          ELSE
            "Net Change Actual" += Value
        ELSE
          IF FORMAT(ColumnLayout."Comparison Date Formula") = '-1Y' THEN
            "Net Change Budget Last Year" += Value
          ELSE
            "Net Change Budget" += Value
      ELSE
        IF ColumnLayout."Ledger Entry Type" = ColumnLayout."Ledger Entry Type"::Entries THEN
          IF FORMAT(ColumnLayout."Comparison Date Formula") = '-1Y' THEN
            "Balance at Date Act. Last Year" += Value
          ELSE
            "Balance at Date Actual" += Value
        ELSE
          IF FORMAT(ColumnLayout."Comparison Date Formula") = '-1Y' THEN
            "Balance at Date Bud. Last Year" += Value
          ELSE
            "Balance at Date Budget" += Value;
    END;

    [External]
    PROCEDURE GetColumnValue@2(ColumnLayout@1000 : Record 334) Result : Decimal;
    BEGIN
      IF ColumnLayout."Column Type" = ColumnLayout."Column Type"::"Net Change" THEN
        IF ColumnLayout."Ledger Entry Type" = ColumnLayout."Ledger Entry Type"::Entries THEN
          IF FORMAT(ColumnLayout."Comparison Date Formula") = '-1Y' THEN
            Result := "Net Change Actual Last Year"
          ELSE
            Result := "Net Change Actual"
        ELSE
          IF FORMAT(ColumnLayout."Comparison Date Formula") = '-1Y' THEN
            Result := "Net Change Budget Last Year"
          ELSE
            Result := "Net Change Budget"
      ELSE
        IF ColumnLayout."Ledger Entry Type" = ColumnLayout."Ledger Entry Type"::Entries THEN
          IF FORMAT(ColumnLayout."Comparison Date Formula") = '-1Y' THEN
            Result := "Balance at Date Act. Last Year"
          ELSE
            Result := "Balance at Date Actual"
        ELSE
          IF FORMAT(ColumnLayout."Comparison Date Formula") = '-1Y' THEN
            Result := "Balance at Date Bud. Last Year"
          ELSE
            Result := "Balance at Date Budget";
      EXIT(Result)
    END;

    BEGIN
    END.
  }
}

