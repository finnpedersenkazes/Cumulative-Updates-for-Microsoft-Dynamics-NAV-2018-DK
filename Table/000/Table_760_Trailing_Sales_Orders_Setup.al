OBJECT Table 760 Trailing Sales Orders Setup
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Konfiguration af efterfõlgende salgsordrer;
               ENU=Trailing Sales Orders Setup];
  }
  FIELDS
  {
    { 1   ;   ;User ID             ;Text132       ;DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 2   ;   ;Period Length       ;Option        ;CaptionML=[DAN=Periodelëngde;
                                                              ENU=Period Length];
                                                   OptionCaptionML=[DAN=Dag,Uge,MÜned,Kvartal,èr;
                                                                    ENU=Day,Week,Month,Quarter,Year];
                                                   OptionString=Day,Week,Month,Quarter,Year }
    { 3   ;   ;Show Orders         ;Option        ;CaptionML=[DAN=Vis ordrer;
                                                              ENU=Show Orders];
                                                   OptionCaptionML=[DAN=Alle ordrer,Ordrer indtil i dag,Forsinkede ordrer;
                                                                    ENU=All Orders,Orders Until Today,Delayed Orders];
                                                   OptionString=All Orders,Orders Until Today,Delayed Orders }
    { 4   ;   ;Use Work Date as Base;Boolean      ;CaptionML=[DAN=Brug arbejdsdato som basis;
                                                              ENU=Use Work Date as Base] }
    { 5   ;   ;Value to Calculate  ;Option        ;CaptionML=[DAN=Vërdi til beregning;
                                                              ENU=Value to Calculate];
                                                   OptionCaptionML=[DAN=Belõb ekskl. moms,Antal ordrer;
                                                                    ENU=Amount Excl. VAT,No. of Orders];
                                                   OptionString=Amount Excl. VAT,No. of Orders }
    { 6   ;   ;Chart Type          ;Option        ;CaptionML=[DAN=Diagramtype;
                                                              ENU=Chart Type];
                                                   OptionCaptionML=[DAN=Stablet omrÜdediagram,Stablet omrÜdediagram (%),Stablet sõjlediagram,Stablet sõjlediagram (%);
                                                                    ENU=Stacked Area,Stacked Area (%),Stacked Column,Stacked Column (%)];
                                                   OptionString=Stacked Area,Stacked Area (%),Stacked Column,Stacked Column (%) }
    { 7   ;   ;Latest Order Document Date;Date    ;FieldClass=FlowField;
                                                   CalcFormula=Max("Sales Header"."Document Date" WHERE (Document Type=CONST(Order)));
                                                   AccessByPermission=TableData 110=R;
                                                   CaptionML=[DAN=Seneste ordredokumentdato;
                                                              ENU=Latest Order Document Date] }
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
      Text001@1000 : TextConst 'DAN=Opdateret den %1.;ENU=Updated at %1.';

    [External]
    PROCEDURE GetCurrentSelectionText@3() : Text[100];
    BEGIN
      EXIT(FORMAT("Show Orders") + '|' +
        FORMAT("Period Length") + '|' +
        FORMAT("Value to Calculate") + '|. (' +
        STRSUBSTNO(Text001,TIME) + ')');
    END;

    [External]
    PROCEDURE GetStartDate@2() : Date;
    VAR
      StartDate@1000 : Date;
    BEGIN
      IF "Use Work Date as Base" THEN
        StartDate := WORKDATE
      ELSE
        StartDate := TODAY;
      IF "Show Orders" = "Show Orders"::"All Orders" THEN BEGIN
        CALCFIELDS("Latest Order Document Date");
        StartDate := "Latest Order Document Date";
      END;

      EXIT(StartDate);
    END;

    [External]
    PROCEDURE GetChartType@1() : Integer;
    VAR
      BusinessChartBuf@1000 : Record 485;
    BEGIN
      CASE "Chart Type" OF
        "Chart Type"::"Stacked Area":
          EXIT(BusinessChartBuf."Chart Type"::StackedArea);
        "Chart Type"::"Stacked Area (%)":
          EXIT(BusinessChartBuf."Chart Type"::StackedArea100);
        "Chart Type"::"Stacked Column":
          EXIT(BusinessChartBuf."Chart Type"::StackedColumn);
        "Chart Type"::"Stacked Column (%)":
          EXIT(BusinessChartBuf."Chart Type"::StackedColumn100);
      END;
    END;

    [External]
    PROCEDURE SetPeriodLength@7(PeriodLength@1000 : Option);
    BEGIN
      "Period Length" := PeriodLength;
      MODIFY;
    END;

    [External]
    PROCEDURE SetShowOrders@6(ShowOrders@1000 : Integer);
    BEGIN
      "Show Orders" := ShowOrders;
      MODIFY;
    END;

    [External]
    PROCEDURE SetValueToCalcuate@8(ValueToCalc@1000 : Integer);
    BEGIN
      "Value to Calculate" := ValueToCalc;
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

