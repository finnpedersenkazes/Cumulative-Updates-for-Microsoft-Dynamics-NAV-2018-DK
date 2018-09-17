OBJECT Codeunit 358 DateFilter-Calc
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Regnskabs�r %1;ENU=Fiscal Year %1';
      AccountingPeriod@1001 : Record 50;
      StartDate@1002 : Date;

    [External]
    PROCEDURE CreateFiscalYearFilter@3(VAR Filter@1000 : Text[30];VAR Name@1001 : Text[30];Date@1002 : Date;NextStep@1003 : Integer);
    BEGIN
      CreateAccountingDateFilter(Filter,Name,TRUE,Date,NextStep);
    END;

    [External]
    PROCEDURE CreateAccountingPeriodFilter@2(VAR Filter@1000 : Text[30];VAR Name@1001 : Text[30];Date@1002 : Date;NextStep@1003 : Integer);
    BEGIN
      CreateAccountingDateFilter(Filter,Name,FALSE,Date,NextStep);
    END;

    [External]
    PROCEDURE ConvertToUtcDateTime@5(LocalDateTime@1000 : DateTime) : DateTime;
    VAR
      DotNetDateTimeOffset@1002 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.DateTimeOffset";
      DotNetDateTimeOffsetNow@1001 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.DateTimeOffset";
    BEGIN
      IF LocalDateTime = CREATEDATETIME(0D,0T) THEN
        EXIT(CREATEDATETIME(0D,0T));

      DotNetDateTimeOffset := DotNetDateTimeOffset.DateTimeOffset(LocalDateTime);
      DotNetDateTimeOffsetNow := DotNetDateTimeOffset.Now;
      EXIT(DotNetDateTimeOffset.LocalDateTime - DotNetDateTimeOffsetNow.Offset);
    END;

    LOCAL PROCEDURE CreateAccountingDateFilter@1(VAR Filter@1000 : Text[30];VAR Name@1001 : Text[30];FiscalYear@1002 : Boolean;Date@1003 : Date;NextStep@1004 : Integer);
    BEGIN
      AccountingPeriod.RESET;
      IF FiscalYear THEN
        AccountingPeriod.SETRANGE("New Fiscal Year",TRUE);
      AccountingPeriod."Starting Date" := Date;
      IF NOT AccountingPeriod.FIND('=<>') THEN
        EXIT;
      IF AccountingPeriod."Starting Date" > Date THEN
        NextStep := NextStep - 1;
      IF NextStep <> 0 THEN
        IF AccountingPeriod.NEXT(NextStep) <> NextStep THEN BEGIN
          IF NextStep < 0 THEN
            Filter := '..' + FORMAT(AccountingPeriod."Starting Date" - 1)
          ELSE
            Filter := FORMAT(AccountingPeriod."Starting Date") + '..' + FORMAT(DMY2DATE(31,12,9999));
          Name := '...';
          EXIT;
        END;
      StartDate := AccountingPeriod."Starting Date";
      IF FiscalYear THEN
        Name := STRSUBSTNO(Text000,FORMAT(DATE2DMY(StartDate,3)))
      ELSE
        Name := AccountingPeriod.Name;
      IF AccountingPeriod.NEXT <> 0 THEN
        Filter := FORMAT(StartDate) + '..' + FORMAT(AccountingPeriod."Starting Date" - 1)
      ELSE BEGIN
        Filter := FORMAT(StartDate) + '..' + FORMAT(DMY2DATE(31,12,9999));
        Name := Name + '...';
      END;
    END;

    BEGIN
    END.
  }
}

