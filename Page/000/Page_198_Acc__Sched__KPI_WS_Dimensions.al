OBJECT Page 198 Acc. Sched. KPI WS Dimensions
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Dimensioner for webtjenesten Kontoskema, n�gletal;
               ENU=Account Schedule KPI WS Dimensions];
    SourceTable=Table197;
    PageType=List;
    SourceTableTemporary=Yes;
    OnOpenPage=BEGIN
                 Initialize;
                 PrecalculateData;
               END;

    OnAfterGetRecord=BEGIN
                       Number := "No.";
                     END;

  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 20  ;2   ;Field     ;
                Name=Number;
                ToolTipML=[DAN=Angiver nummeret p� dimensionen.;
                           ENU=Specifies the number of the dimension.];
                ApplicationArea=#Advanced;
                SourceExpr=Number;
                Visible=FALSE }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Advanced;
                SourceExpr="No.";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor KPI-tallene beregnes.;
                           ENU=Specifies the date on which the KPI figures are calculated.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Date }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om regnskabsperioden er lukket eller l�st. KPI-data for perioder, der ikke er lukket eller l�st, vil blive prognosticerede v�rdier fra finansbudgettet.;
                           ENU=Specifies if the accounting period is closed or locked. KPI data for periods that are not closed or locked will be forecasted values from the general ledger budget.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Closed Period" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� det kontoskema, som KPI-webtjenesten er baseret p�.;
                           ENU=Specifies the name of the account schedule that the KPI web service is based on.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Account Schedule Name" }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for kontoskema-KPI-webtjenesten.;
                           ENU=Specifies a code for the account-schedule KPI web service.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="KPI Code" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et navn p� kontoskema-KPI-webtjenesten.;
                           ENU=Specifies a name of the account-schedule KPI web service.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="KPI Name" }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver �ndringer i det faktiske finansregnskab for lukkede regnskabsperioder indtil datoen i feltet Dato.;
                           ENU=Specifies changes in the actual general ledger amount, for closed accounting periods, up until the date in the Date field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Net Change Actual" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den faktiske finanssaldo, baseret p� lukkede regnskabsperioder, p� datoen i feltet Dato.;
                           ENU=Specifies the actual general ledger balance, based on closed accounting periods, on the date in the Date field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Balance at Date Actual" }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver �ndringer i det budgetterede finansregnskab baseret p� finansbudgetposter indtil datoen i feltet Dato.;
                           ENU=Specifies changes in the budgeted general ledger amount, based on the general ledger budget, up until the date in the Date field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Net Change Budget" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den budgetterede finansregnskabssaldo baseret p� finansbudget indtil datoen i feltet Dato.;
                           ENU=Specifies the budgeted general ledger balance, based on the general ledger budget, on the date in the Date field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Balance at Date Budget" }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver de faktiske �ndringer i finansbel�bet, baseret p� lukkede regnskabsperioder, indtil datoen i feltet Dato i det forrige regnskabs�r.;
                           ENU=Specifies actual changes in the general ledger amount, based on closed accounting periods, up until the date in the Date field in the previous accounting year.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Net Change Actual Last Year" }

    { 14  ;2   ;Field     ;
                Name=Balance at Date Actual Last Year;
                ToolTipML=[DAN=Angiver den faktiske finanssaldo, baseret p� lukkede regnskabsperioder, p� datoen i feltet Dato i det forrige regnskabs�r.;
                           ENU=Specifies the actual general ledger balance, based on closed accounting periods, on the date in the Date field in the previous accounting year.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Balance at Date Act. Last Year" }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver budgetterede �ndringer i det budgetterede finansregnskab baseret p� finansbudgetposter indtil datoen i feltet Dato i det forrige �r.;
                           ENU=Specifies budgeted changes in the general ledger amount, based on the general ledger budget, up until the date in the Date field in the previous year.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Net Change Budget Last Year" }

    { 16  ;2   ;Field     ;
                Name=Balance at Date Budget Last Year;
                ToolTipML=[DAN=Angiver den budgetterede finansregnskabssaldo baseret p� finansbudget indtil datoen i feltet Dato i det forrige regnskabs�r.;
                           ENU=Specifies the budgeted general ledger balance, based on the general ledger budget, on the date in the Date field in the previous accounting year.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Balance at Date Bud. Last Year" }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver forventede �ndringer i det faktiske finansregnskab baseret p� �bne regnskabsperioder indtil datoen i feltet Dato.;
                           ENU=Specifies forecasted changes in the general ledger amount, based on open accounting periods, up until the date in the Date field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Net Change Forecast" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den forventede finanssaldo, baseret p� �bne regnskabsperioder, p� datoen i feltet Dato.;
                           ENU=Specifies the forecasted general ledger balance, based on open accounting periods, on the date in the Date field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Balance at Date Forecast" }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver a reference til en kombination af dimensionsv�rdier. De faktiske v�rdier gemmes i tabellen Dimensionsgruppepost.;
                           ENU=Specifies a reference to a combination of dimension values. The actual values are stored in the Dimension Set Entry table.];
                ApplicationArea=#Suite;
                SourceExpr="Dimension Set ID" }

  }
  CODE
  {
    VAR
      AccSchedKPIWebSrvSetup@1002 : Record 135;
      TempAccScheduleLine@1000 : TEMPORARY Record 85;
      AccSchedKPIDimensions@1014 : Codeunit 9;
      Number@1001 : Integer;

    LOCAL PROCEDURE Initialize@1();
    VAR
      LogInManagement@1002 : Codeunit 40;
    BEGIN
      IF NOT GUIALLOWED THEN
        WORKDATE := LogInManagement.GetDefaultWorkDate;

      SetupActiveAccSchedLines;
    END;

    LOCAL PROCEDURE SetupColumnLayout@11(VAR TempColumnLayout@1000 : TEMPORARY Record 334);
    BEGIN
      WITH TempColumnLayout DO BEGIN
        InsertTempColumn(TempColumnLayout,"Column Type"::"Net Change","Ledger Entry Type"::Entries,FALSE);
        InsertTempColumn(TempColumnLayout,"Column Type"::"Balance at Date","Ledger Entry Type"::Entries,FALSE);
        InsertTempColumn(TempColumnLayout,"Column Type"::"Net Change","Ledger Entry Type"::"Budget Entries",FALSE);
        InsertTempColumn(TempColumnLayout,"Column Type"::"Balance at Date","Ledger Entry Type"::"Budget Entries",FALSE);
        InsertTempColumn(TempColumnLayout,"Column Type"::"Net Change","Ledger Entry Type"::Entries,TRUE);
        InsertTempColumn(TempColumnLayout,"Column Type"::"Balance at Date","Ledger Entry Type"::Entries,TRUE);
        InsertTempColumn(TempColumnLayout,"Column Type"::"Net Change","Ledger Entry Type"::"Budget Entries",TRUE);
        InsertTempColumn(TempColumnLayout,"Column Type"::"Balance at Date","Ledger Entry Type"::"Budget Entries",TRUE);
      END;
    END;

    LOCAL PROCEDURE SetupActiveAccSchedLines@17();
    VAR
      AccScheduleLine@1000 : Record 85;
      AccSchedKPIWebSrvLine@1002 : Record 136;
      LineNo@1003 : Integer;
    BEGIN
      AccSchedKPIWebSrvSetup.GET;
      AccSchedKPIWebSrvLine.FINDSET;
      AccScheduleLine.SETRANGE(Show,AccScheduleLine.Show::Yes);
      AccScheduleLine.SETFILTER(Totaling,'<>%1','');
      REPEAT
        AccScheduleLine.SETRANGE("Schedule Name",AccSchedKPIWebSrvLine."Acc. Schedule Name");
        AccScheduleLine.FINDSET;
        REPEAT
          LineNo += 1;
          TempAccScheduleLine := AccScheduleLine;
          TempAccScheduleLine."Line No." := LineNo;
          TempAccScheduleLine.INSERT;
        UNTIL AccScheduleLine.NEXT = 0;
      UNTIL AccSchedKPIWebSrvLine.NEXT = 0;
    END;

    LOCAL PROCEDURE InsertTempColumn@9(VAR TempColumnLayout@1003 : TEMPORARY Record 334;ColumnType@1000 : Option;EntryType@1001 : Option;LastYear@1002 : Boolean);
    BEGIN
      WITH TempColumnLayout DO BEGIN
        IF FINDLAST THEN;
        INIT;
        "Line No." += 10000;
        "Column Type" := ColumnType;
        "Ledger Entry Type" := EntryType;
        IF LastYear THEN
          EVALUATE("Comparison Date Formula",'<-1Y>');
        INSERT;
      END;
    END;

    LOCAL PROCEDURE PrecalculateData@21();
    VAR
      TempAccSchedKPIBuffer@1003 : TEMPORARY Record 197;
      TempColumnLayout@1005 : TEMPORARY Record 334;
      StartDate@1008 : Date;
      EndDate@1007 : Date;
      FromDate@1000 : Date;
      ToDate@1001 : Date;
      LastClosedDate@1010 : Date;
      C@1002 : Integer;
      NoOfPeriods@1009 : Integer;
      ForecastFromBudget@1004 : Boolean;
    BEGIN
      SetupColumnLayout(TempColumnLayout);

      AccSchedKPIWebSrvSetup.GetPeriodLength(NoOfPeriods,StartDate,EndDate);
      LastClosedDate := AccSchedKPIWebSrvSetup.GetLastClosedAccDate;

      FOR C := 1 TO NoOfPeriods DO BEGIN
        FromDate := AccSchedKPIWebSrvSetup.CalcNextStartDate(StartDate,C - 1);
        ToDate := AccSchedKPIWebSrvSetup.CalcNextStartDate(FromDate,1) - 1;
        WITH TempAccSchedKPIBuffer DO BEGIN
          INIT;
          Date := FromDate;
          "Closed Period" := (FromDate <= LastClosedDate);
          ForecastFromBudget :=
            ((AccSchedKPIWebSrvSetup."Forecasted Values Start" =
              AccSchedKPIWebSrvSetup."Forecasted Values Start"::"After Latest Closed Period") AND
             NOT "Closed Period") OR
            ((AccSchedKPIWebSrvSetup."Forecasted Values Start" =
              AccSchedKPIWebSrvSetup."Forecasted Values Start"::"After Current Date") AND
             (Date > WORKDATE));
        END;

        WITH TempAccScheduleLine DO BEGIN
          FINDSET;
          REPEAT
            IF TempAccSchedKPIBuffer."Account Schedule Name" <> "Schedule Name" THEN BEGIN
              InsertAccSchedulePeriod(TempAccSchedKPIBuffer,ForecastFromBudget);
              TempAccSchedKPIBuffer."Account Schedule Name" := "Schedule Name";
            END;
            TempAccSchedKPIBuffer."KPI Code" := "Row No.";
            TempAccSchedKPIBuffer."KPI Name" :=
              COPYSTR(Description,1,MAXSTRLEN(TempAccSchedKPIBuffer."KPI Name"));
            SETRANGE("Date Filter",FromDate,ToDate);
            SETRANGE("G/L Budget Filter",AccSchedKPIWebSrvSetup."G/L Budget Name");
            AccSchedKPIDimensions.GetCellDataWithDimensions(TempAccScheduleLine,TempColumnLayout,TempAccSchedKPIBuffer);
          UNTIL NEXT = 0;
        END;
        InsertAccSchedulePeriod(TempAccSchedKPIBuffer,ForecastFromBudget);
      END;
      RESET;
      FINDFIRST;
    END;

    LOCAL PROCEDURE InsertAccSchedulePeriod@14(VAR TempAccSchedKPIBuffer@1000 : TEMPORARY Record 197;ForecastFromBudget@1001 : Boolean);
    BEGIN
      WITH TempAccSchedKPIBuffer DO BEGIN
        RESET;
        IF FINDSET THEN
          REPEAT
            InsertData(TempAccSchedKPIBuffer,ForecastFromBudget);
          UNTIL NEXT = 0;
        DELETEALL;
      END;
    END;

    LOCAL PROCEDURE InsertData@3(AccSchedKPIBuffer@1000 : Record 197;ForecastFromBudget@1001 : Boolean);
    VAR
      TempAccScheduleLine2@1002 : TEMPORARY Record 85;
    BEGIN
      INIT;
      "No." += 1;
      TRANSFERFIELDS(AccSchedKPIBuffer,FALSE);

      WITH TempAccScheduleLine2 DO BEGIN
        COPY(TempAccScheduleLine,TRUE);
        SETRANGE("Schedule Name",AccSchedKPIBuffer."Account Schedule Name");
        SETRANGE("Row No.",AccSchedKPIBuffer."KPI Code");
        FINDFIRST;
      END;

      "Net Change Actual" :=
        AccSchedKPIDimensions.PostProcessAmount(TempAccScheduleLine2,"Net Change Actual");
      "Balance at Date Actual" :=
        AccSchedKPIDimensions.PostProcessAmount(TempAccScheduleLine2,"Balance at Date Actual");
      "Net Change Budget" :=
        AccSchedKPIDimensions.PostProcessAmount(TempAccScheduleLine2,"Net Change Budget");
      "Balance at Date Budget" :=
        AccSchedKPIDimensions.PostProcessAmount(TempAccScheduleLine2,"Balance at Date Budget");
      "Net Change Actual Last Year" :=
        AccSchedKPIDimensions.PostProcessAmount(TempAccScheduleLine2,"Net Change Actual Last Year");
      "Balance at Date Act. Last Year" :=
        AccSchedKPIDimensions.PostProcessAmount(TempAccScheduleLine2,"Balance at Date Act. Last Year");
      "Net Change Budget Last Year" :=
        AccSchedKPIDimensions.PostProcessAmount(TempAccScheduleLine2,"Net Change Budget Last Year");
      "Balance at Date Bud. Last Year" :=
        AccSchedKPIDimensions.PostProcessAmount(TempAccScheduleLine2,"Balance at Date Bud. Last Year");

      IF ForecastFromBudget THEN BEGIN
        "Net Change Forecast" := "Net Change Budget";
        "Balance at Date Forecast" := "Balance at Date Budget";
      END ELSE BEGIN
        "Net Change Forecast" := "Net Change Actual";
        "Balance at Date Forecast" := "Balance at Date Actual";
      END;
      INSERT;
    END;

    BEGIN
    END.
  }
}

