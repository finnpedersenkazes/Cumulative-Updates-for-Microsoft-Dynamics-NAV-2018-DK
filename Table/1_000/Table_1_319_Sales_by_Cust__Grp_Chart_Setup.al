OBJECT Table 1319 Sales by Cust. Grp.Chart Setup
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Konfiguration af gruppediagram over salg efter debitor;
               ENU=Sales by Cust. Grp.Chart Setup];
    LookupPageID=Page767;
  }
  FIELDS
  {
    { 1   ;   ;User ID             ;Text132       ;DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID];
                                                   Editable=No }
    { 31  ;   ;Start Date          ;Date          ;OnValidate=BEGIN
                                                                TESTFIELD("Start Date");
                                                              END;

                                                   CaptionML=[DAN=Startdato;
                                                              ENU=Start Date] }
    { 41  ;   ;Period Length       ;Option        ;CaptionML=[DAN=Periodelëngde;
                                                              ENU=Period Length];
                                                   OptionCaptionML=[DAN=Dag,Uge,MÜned,Kvartal,èr;
                                                                    ENU=Day,Week,Month,Quarter,Year];
                                                   OptionString=Day,Week,Month,Quarter,Year }
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

    [External]
    PROCEDURE SetPeriod@1(Which@1000 : ' ,Next,Previous');
    VAR
      BusinessChartBuffer@1001 : Record 485;
    BEGIN
      IF Which = Which::" " THEN
        EXIT;

      GET(USERID);
      BusinessChartBuffer."Period Length" := "Period Length";
      CASE Which OF
        Which::Previous:
          "Start Date" := CALCDATE('<-1D>',BusinessChartBuffer.CalcFromDate("Start Date"));
        Which::Next:
          "Start Date" := CALCDATE('<1D>',BusinessChartBuffer.CalcToDate("Start Date"));
      END;
      MODIFY;
    END;

    [External]
    PROCEDURE SetPeriodLength@7(PeriodLength@1000 : Option);
    BEGIN
      GET(USERID);
      "Period Length" := PeriodLength;
      MODIFY(TRUE);
    END;

    BEGIN
    END.
  }
}

