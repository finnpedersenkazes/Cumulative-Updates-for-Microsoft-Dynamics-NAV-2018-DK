OBJECT Codeunit 99000817 Manu. Print Report
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
      ReportSelection@1000 : Record 77;
      ProductionOrder@1001 : Record 5405;

    [External]
    PROCEDURE PrintProductionOrder@17(NewProductionOrder@1000 : Record 5405;Usage@1001 : Option);
    BEGIN
      ProductionOrder := NewProductionOrder;
      ProductionOrder.SETRECFILTER;

      ReportSelection.PrintWithCheck(ConvertUsage(Usage),ProductionOrder,0);
    END;

    LOCAL PROCEDURE ConvertUsage@1(Usage@1000 : 'M1,M2,M3,M4') : Integer;
    BEGIN
      CASE Usage OF
        Usage::M1:
          EXIT(ReportSelection.Usage::M1);
        Usage::M2:
          EXIT(ReportSelection.Usage::M2);
        Usage::M3:
          EXIT(ReportSelection.Usage::M3);
        Usage::M4:
          EXIT(ReportSelection.Usage::M4);
      END;
    END;

    BEGIN
    END.
  }
}

