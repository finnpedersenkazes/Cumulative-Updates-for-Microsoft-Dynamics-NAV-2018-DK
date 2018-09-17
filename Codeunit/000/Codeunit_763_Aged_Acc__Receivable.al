OBJECT Codeunit 763 Aged Acc. Receivable
{
  OBJECT-PROPERTIES
  {
    Date=26-01-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20348;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      OverdueTxt@1001 : TextConst 'DAN=Forfald;ENU=Overdue';
      AmountTxt@1000 : TextConst 'DAN=Bel�b;ENU=Amount';
      NotDueTxt@1002 : TextConst 'DAN=Ikke forfaldet;ENU=Not Overdue';
      OlderTxt@1003 : TextConst 'DAN=�ldre;ENU=Older';
      GeneralLedgerSetup@1004 : Record 98;
      GLSetupLoaded@1005 : Boolean;
      StatusNonPeriodicTxt@1013 : TextConst 'DAN=Alle tilgodehavender, ikke-forfaldne og forfaldne;ENU=All receivables, not overdue and overdue';
      StatusPeriodLengthTxt@1012 : TextConst 'DAN="Periodel�ngde: ";ENU="Period Length: "';
      Status2WeekOverdueTxt@1011 : TextConst 'DAN=To uger overskredet;ENU=2 weeks overdue';
      Status3MonthsOverdueTxt@1010 : TextConst 'DAN=Tre m�neder overskredet;ENU=3 months overdue';
      Status1YearOverdueTxt@1009 : TextConst 'DAN=Et �r overskredet;ENU=1 year overdue';
      Status3YearsOverdueTxt@1008 : TextConst 'DAN=Tre �r overskredet;ENU=3 years overdue';
      Status5YearsOverdueTxt@1007 : TextConst 'DAN=Fem �r overskredet;ENU=5 years overdue';
      ChartDescriptionMsg@1006 : TextConst 'DAN=Viser debitorers ventende betalingsbel�b opsummeret for en periode, du v�lger.\\Den f�rste kolonne viser bel�bet for ventende betalinger, hvor forfaldsdatoen ikke er overskredet. Den eller de f�lgende kolonner viser de forfaldne bel�b i den valgte periode fra betalingsforfaldsdatoen. Diagrammet viser forfaldne betalingsbel�b op til fem �r tilbage fra dags dato afh�ngigt af den valgte periode.;ENU=Shows customers'' pending payment amounts summed for a period that you select.\\The first column shows the amount on pending payments that are not past the due date. The following column or columns show overdue amounts within the selected period from the payment due date. The chart shows overdue payment amounts going back up to five years from today''s date depending on the period that you select.';
      ChartPerCustomerDescriptionMsg@1014 : TextConst 'DAN=Viser debitorernes ventende betalingsbel�b opsummeret for en periode, du v�lger.\\Den f�rste kolonne viser bel�bet for ventende betalinger, hvor forfaldsdatoen ikke er overskredet. Den eller de f�lgende kolonner viser de forfaldne bel�b i den valgte periode fra betalingsforfaldsdatoen. Diagrammet viser forfaldne betalingsbel�b op til fem �r tilbage fra dags dato afh�ngigt af den valgte periode.;ENU=Shows the customer''s pending payment amount summed for a period that you select.\\The first column shows the amount on pending payments that are not past the due date. The following column or columns show overdue amounts within the selected period from the payment due date. The chart shows overdue payment amounts going back up to five years from today''s date depending on the period that you select.';
      Status1MonthOverdueTxt@1015 : TextConst 'DAN=1 m�ned overskredet;ENU=1 month overdue';
      Status1QuarterOverdueTxt@1016 : TextConst 'DAN=Et kvartal overskredet;ENU=1 quarter overdue';

    [Internal]
    PROCEDURE UpdateDataPerCustomer@7(VAR BusChartBuf@1000 : Record 485;CustomerNo@1007 : Code[20];VAR TempEntryNoAmountBuf@1002 : TEMPORARY Record 386);
    VAR
      PeriodIndex@1006 : Integer;
      PeriodLength@1001 : Text[1];
      NoOfPeriods@1004 : Integer;
    BEGIN
      WITH BusChartBuf DO BEGIN
        Initialize;
        SetXAxis(OverDueText,"Data Type"::String);
        AddMeasure(AmountText,1,"Data Type"::Decimal,"Chart Type"::Column);

        InitParameters(BusChartBuf,PeriodLength,NoOfPeriods,TempEntryNoAmountBuf);
        CalculateAgedAccReceivable(
          CustomerNo,'',"Period Filter Start Date",PeriodLength,NoOfPeriods,
          TempEntryNoAmountBuf);

        IF TempEntryNoAmountBuf.FINDSET THEN
          REPEAT
            PeriodIndex := TempEntryNoAmountBuf."Entry No.";
            AddColumn(FormatColumnName(PeriodIndex,PeriodLength,NoOfPeriods,"Period Length"));
            SetValueByIndex(0,PeriodIndex,RoundAmount(TempEntryNoAmountBuf.Amount));
          UNTIL TempEntryNoAmountBuf.NEXT = 0
      END;
    END;

    [Internal]
    PROCEDURE UpdateDataPerGroup@15(VAR BusChartBuf@1000 : Record 485;VAR TempEntryNoAmountBuf@1002 : TEMPORARY Record 386);
    VAR
      CustPostingGroup@1005 : Record 92;
      PeriodIndex@1006 : Integer;
      GroupIndex@1010 : Integer;
      PeriodLength@1001 : Text[1];
      NoOfPeriods@1004 : Integer;
    BEGIN
      WITH BusChartBuf DO BEGIN
        Initialize;
        SetXAxis(OverdueTxt,"Data Type"::String);

        InitParameters(BusChartBuf,PeriodLength,NoOfPeriods,TempEntryNoAmountBuf);
        CalculateAgedAccReceivablePerGroup(
          "Period Filter Start Date",PeriodLength,NoOfPeriods,
          TempEntryNoAmountBuf);

        IF CustPostingGroup.FINDSET THEN
          REPEAT
            AddMeasure(CustPostingGroup.Code,GroupIndex,"Data Type"::Decimal,"Chart Type"::StackedColumn);

            TempEntryNoAmountBuf.RESET;
            TempEntryNoAmountBuf.SETRANGE("Business Unit Code",CustPostingGroup.Code);
            IF TempEntryNoAmountBuf.FINDSET THEN
              REPEAT
                PeriodIndex := TempEntryNoAmountBuf."Entry No.";
                IF GroupIndex = 0 THEN
                  AddColumn(FormatColumnName(PeriodIndex,PeriodLength,NoOfPeriods,"Period Length"));
                SetValueByIndex(GroupIndex,PeriodIndex,RoundAmount(TempEntryNoAmountBuf.Amount));
              UNTIL TempEntryNoAmountBuf.NEXT = 0;
            GroupIndex += 1;
          UNTIL CustPostingGroup.NEXT = 0;
        TempEntryNoAmountBuf.RESET;
      END;
    END;

    LOCAL PROCEDURE CalculateAgedAccReceivable@1(CustomerNo@1000 : Code[20];CustomerGroupCode@1009 : Code[20];StartDate@1001 : Date;PeriodLength@1002 : Text[1];NoOfPeriods@1003 : Integer;VAR TempEntryNoAmountBuffer@1004 : TEMPORARY Record 386);
    VAR
      CustLedgEntryRemainAmt@1006 : Query 21;
      RemainingAmountLCY@1008 : Decimal;
      EndDate@1007 : Date;
      Index@1005 : Integer;
    BEGIN
      IF CustomerNo <> '' THEN
        CustLedgEntryRemainAmt.SETRANGE(Customer_No,CustomerNo);
      IF CustomerGroupCode <> '' THEN
        CustLedgEntryRemainAmt.SETRANGE(Customer_Posting_Group,CustomerGroupCode);
      CustLedgEntryRemainAmt.SETRANGE(IsOpen,TRUE);

      FOR Index := 0 TO NoOfPeriods - 1 DO BEGIN
        RemainingAmountLCY := 0;
        CustLedgEntryRemainAmt.SETFILTER(
          Due_Date,
          DateFilterByAge(Index,StartDate,PeriodLength,NoOfPeriods,EndDate));
        CustLedgEntryRemainAmt.OPEN;
        IF CustLedgEntryRemainAmt.READ THEN
          RemainingAmountLCY := CustLedgEntryRemainAmt.Sum_Remaining_Amt_LCY;

        InsertAmountBuffer(Index,CustomerGroupCode,RemainingAmountLCY,StartDate,EndDate,TempEntryNoAmountBuffer)
      END;
    END;

    LOCAL PROCEDURE CalculateAgedAccReceivablePerGroup@12(StartDate@1001 : Date;PeriodLength@1000 : Text[1];NoOfPeriods@1003 : Integer;VAR TempEntryNoAmountBuffer@1004 : TEMPORARY Record 386);
    VAR
      CustPostingGroup@1009 : Record 92;
    BEGIN
      IF CustPostingGroup.FINDSET THEN
        REPEAT
          CalculateAgedAccReceivable(
            '',CustPostingGroup.Code,StartDate,PeriodLength,NoOfPeriods,
            TempEntryNoAmountBuffer);
        UNTIL CustPostingGroup.NEXT = 0;
    END;

    [External]
    PROCEDURE DateFilterByAge@14(Index@1000 : Integer;VAR StartDate@1007 : Date;PeriodLength@1006 : Text[1];NoOfPeriods@1005 : Integer;VAR EndDate@1002 : Date) : Text;
    BEGIN
      IF Index = 0 THEN // First period - Not due remaining amounts
        EXIT(STRSUBSTNO('>=%1',StartDate));

      EndDate := CALCDATE('<-1D>',StartDate);
      IF Index = NoOfPeriods - 1 THEN // Last period - Older remaining amounts
        StartDate := 0D
      ELSE
        StartDate := CALCDATE(STRSUBSTNO('<-1%1>',PeriodLength),StartDate);

      EXIT(STRSUBSTNO('%1..%2',StartDate,EndDate));
    END;

    [External]
    PROCEDURE InsertAmountBuffer@3(Index@1000 : Integer;BussUnitCode@1005 : Code[20];AmountLCY@1001 : Decimal;StartDate@1003 : Date;EndDate@1004 : Date;VAR TempEntryNoAmountBuffer@1002 : TEMPORARY Record 386);
    BEGIN
      WITH TempEntryNoAmountBuffer DO BEGIN
        INIT;
        "Entry No." := Index;
        "Business Unit Code" := BussUnitCode;
        Amount := AmountLCY;
        "Start Date" := StartDate;
        "End Date" := EndDate;
        INSERT;
      END;
    END;

    [External]
    PROCEDURE InitParameters@13(BusChartBuf@1000 : Record 485;VAR PeriodLength@1001 : Text[1];VAR NoOfPeriods@1002 : Integer;VAR TempEntryNoAmountBuf@1004 : TEMPORARY Record 386);
    BEGIN
      TempEntryNoAmountBuf.DELETEALL;
      PeriodLength := GetPeriod(BusChartBuf);
      NoOfPeriods := GetNoOfPeriods(BusChartBuf);
    END;

    LOCAL PROCEDURE GetPeriod@19(BusChartBuf@1000 : Record 485) : Text[1];
    BEGIN
      IF BusChartBuf."Period Length" = BusChartBuf."Period Length"::None THEN
        EXIT('W');
      EXIT(BusChartBuf.GetPeriodLength);
    END;

    LOCAL PROCEDURE GetNoOfPeriods@20(BusChartBuf@1000 : Record 485) : Integer;
    VAR
      OfficeMgt@1001 : Codeunit 1630;
      NoOfPeriods@1002 : Integer;
    BEGIN
      NoOfPeriods := 14;
      CASE BusChartBuf."Period Length" OF
        BusChartBuf."Period Length"::Day:
          NoOfPeriods := 16;
        BusChartBuf."Period Length"::Week,
        BusChartBuf."Period Length"::Quarter:
          IF OfficeMgt.IsAvailable THEN
            NoOfPeriods := 6
          ELSE
            NoOfPeriods := 14;
        BusChartBuf."Period Length"::Month:
          IF OfficeMgt.IsAvailable THEN
            NoOfPeriods := 5
          ELSE
            NoOfPeriods := 14;
        BusChartBuf."Period Length"::Year:
          IF OfficeMgt.IsAvailable THEN
            NoOfPeriods := 5
          ELSE
            NoOfPeriods := 7;
        BusChartBuf."Period Length"::None:
          NoOfPeriods := 2;
      END;
      EXIT(NoOfPeriods);
    END;

    [External]
    PROCEDURE FormatColumnName@6(Index@1000 : Integer;PeriodLength@1001 : Text[1];NoOfColumns@1003 : Integer;Period@1004 : Option) : Text;
    VAR
      BusChartBuf@1005 : Record 485;
      PeriodDateFormula@1002 : DateFormula;
    BEGIN
      IF Index = 0 THEN
        EXIT(NotDueTxt);

      IF Index = NoOfColumns - 1 THEN BEGIN
        IF Period = BusChartBuf."Period Length"::None THEN
          EXIT(OverdueTxt);
        EXIT(OlderTxt);
      END;

      // Period length text localized by date formula
      EVALUATE(PeriodDateFormula,STRSUBSTNO('<1%1>',PeriodLength));
      EXIT(STRSUBSTNO('%1%2',Index,DELCHR(FORMAT(PeriodDateFormula),'=','1')));
    END;

    [External]
    PROCEDURE DrillDown@18(VAR BusChartBuf@1000 : Record 485;CustomerNo@1001 : Code[20];VAR TempEntryNoAmountBuf@1003 : TEMPORARY Record 386);
    VAR
      MeasureName@1002 : Text;
      CustomerGroupCode@1005 : Code[20];
    BEGIN
      WITH TempEntryNoAmountBuf DO BEGIN
        IF CustomerNo <> '' THEN
          CustomerGroupCode := ''
        ELSE BEGIN
          MeasureName := BusChartBuf.GetMeasureName(BusChartBuf."Drill-Down Measure Index");
          CustomerGroupCode := COPYSTR(MeasureName,1,MAXSTRLEN(CustomerGroupCode));
        END;
        IF GET(CustomerGroupCode,BusChartBuf."Drill-Down X Index") THEN
          DrillDownCustLedgEntries(CustomerNo,CustomerGroupCode,"Start Date","End Date");
      END;
    END;

    [External]
    PROCEDURE DrillDownByGroup@35(VAR BusChartBuf@1000 : Record 485;VAR TempEntryNoAmountBuf@1003 : TEMPORARY Record 386);
    BEGIN
      DrillDown(BusChartBuf,'',TempEntryNoAmountBuf);
    END;

    [External]
    PROCEDURE DrillDownCustLedgEntries@2(CustomerNo@1000 : Code[20];CustomerGroupCode@1003 : Code[20];StartDate@1001 : Date;EndDate@1002 : Date);
    VAR
      CustLedgEntry@1004 : Record 21;
    BEGIN
      CustLedgEntry.SETCURRENTKEY("Customer No.",Open,Positive,"Due Date");
      IF CustomerNo <> '' THEN
        CustLedgEntry.SETRANGE("Customer No.",CustomerNo);
      IF EndDate = 0D THEN
        CustLedgEntry.SETFILTER("Due Date",'>=%1',StartDate)
      ELSE
        CustLedgEntry.SETRANGE("Due Date",StartDate,EndDate);
      CustLedgEntry.SETRANGE(Open,TRUE);
      IF CustomerGroupCode <> '' THEN
        CustLedgEntry.SETRANGE("Customer Posting Group",CustomerGroupCode);
      IF CustLedgEntry.ISEMPTY THEN
        EXIT;
      PAGE.RUN(PAGE::"Customer Ledger Entries",CustLedgEntry);
    END;

    [External]
    PROCEDURE Description@10(PerCustomer@1000 : Boolean) : Text;
    BEGIN
      IF PerCustomer THEN
        EXIT(ChartPerCustomerDescriptionMsg);
      EXIT(ChartDescriptionMsg);
    END;

    [External]
    PROCEDURE UpdateStatusText@11(BusChartBuf@1000 : Record 485) : Text;
    VAR
      OfficeMgt@1001 : Codeunit 1630;
      StatusText@1002 : Text;
    BEGIN
      StatusText := StatusPeriodLengthTxt + FORMAT(BusChartBuf."Period Length");

      CASE BusChartBuf."Period Length" OF
        BusChartBuf."Period Length"::Day:
          StatusText := StatusText + ' | ' + Status2WeekOverdueTxt;
        BusChartBuf."Period Length"::Week:
          IF OfficeMgt.IsAvailable THEN
            StatusText := StatusText + ' | ' + Status1MonthOverdueTxt
          ELSE
            StatusText := StatusText + ' | ' + Status3MonthsOverdueTxt;
        BusChartBuf."Period Length"::Month:
          IF OfficeMgt.IsAvailable THEN
            StatusText := StatusText + ' | ' + Status1QuarterOverdueTxt
          ELSE
            StatusText := StatusText + ' | ' + Status1YearOverdueTxt;
        BusChartBuf."Period Length"::Quarter:
          IF OfficeMgt.IsAvailable THEN
            StatusText := StatusText + ' | ' + Status1YearOverdueTxt
          ELSE
            StatusText := StatusText + ' | ' + Status3YearsOverdueTxt;
        BusChartBuf."Period Length"::Year:
          IF OfficeMgt.IsAvailable THEN
            StatusText := StatusText + ' | ' + Status3YearsOverdueTxt
          ELSE
            StatusText := StatusText + ' | ' + Status5YearsOverdueTxt;
        BusChartBuf."Period Length"::None:
          StatusText := StatusNonPeriodicTxt;
      END;

      EXIT(StatusText);
    END;

    [External]
    PROCEDURE SaveSettings@8(BusChartBuf@1001 : Record 485);
    VAR
      BusChartUserSetup@1000 : Record 487;
    BEGIN
      BusChartUserSetup."Period Length" := BusChartBuf."Period Length";
      BusChartUserSetup.SaveSetupCU(BusChartUserSetup,CODEUNIT::"Aged Acc. Receivable");
    END;

    [External]
    PROCEDURE InvoicePaymentDaysAverage@4(CustomerNo@1000 : Code[20]) : Decimal;
    BEGIN
      EXIT(ROUND(CalcInvPmtDaysAverage(CustomerNo),1));
    END;

    LOCAL PROCEDURE CalcInvPmtDaysAverage@9(CustomerNo@1000 : Code[20]) : Decimal;
    VAR
      CustLedgEntry@1001 : Record 21;
      DetailedCustLedgEntry@1002 : Record 379;
      PaymentDays@1004 : Integer;
      InvoiceCount@1003 : Integer;
    BEGIN
      CustLedgEntry.SETCURRENTKEY("Document Type","Customer No.",Open);
      IF CustomerNo <> '' THEN
        CustLedgEntry.SETRANGE("Customer No.",CustomerNo);
      CustLedgEntry.SETRANGE("Document Type",CustLedgEntry."Document Type"::Invoice);
      CustLedgEntry.SETRANGE(Open,FALSE);
      CustLedgEntry.SETFILTER("Due Date",'<>%1',0D);
      IF NOT CustLedgEntry.FINDSET THEN
        EXIT(0);

      REPEAT
        DetailedCustLedgEntry.SETCURRENTKEY("Cust. Ledger Entry No.");
        DetailedCustLedgEntry.SETRANGE("Cust. Ledger Entry No.",CustLedgEntry."Entry No.");
        DetailedCustLedgEntry.SETRANGE("Document Type",DetailedCustLedgEntry."Document Type"::Payment);
        IF DetailedCustLedgEntry.FINDLAST THEN BEGIN
          PaymentDays += DetailedCustLedgEntry."Posting Date" - CustLedgEntry."Due Date";
          InvoiceCount += 1;
        END;
      UNTIL CustLedgEntry.NEXT = 0;

      IF InvoiceCount = 0 THEN
        EXIT(0);

      EXIT(PaymentDays / InvoiceCount);
    END;

    [External]
    PROCEDURE RoundAmount@5(Amount@1000 : Decimal) : Decimal;
    BEGIN
      IF NOT GLSetupLoaded THEN BEGIN
        GeneralLedgerSetup.GET;
        GLSetupLoaded := TRUE;
      END;

      EXIT(ROUND(Amount,GeneralLedgerSetup."Amount Rounding Precision"));
    END;

    [External]
    PROCEDURE OverDueText@16() : Text;
    BEGIN
      EXIT(OverdueTxt);
    END;

    [External]
    PROCEDURE AmountText@17() : Text;
    BEGIN
      EXIT(AmountTxt);
    END;

    BEGIN
    END.
  }
}

