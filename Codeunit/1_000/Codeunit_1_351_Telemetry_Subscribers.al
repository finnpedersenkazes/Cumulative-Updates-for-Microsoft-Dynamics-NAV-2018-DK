OBJECT Codeunit 1351 Telemetry Subscribers
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      GLPostInconsistentTelem@1000 : Codeunit 1355;

    [EventSubscriber(Codeunit,1,OnAfterCompanyOpen,"",Skip,Skip)]
    LOCAL PROCEDURE ScheduleMasterdataTelemetryAfterCompanyOpen@1();
    VAR
      CodeUnitMetadata@1001 : Record 2000000137;
      TelemetryManagement@1000 : Codeunit 1350;
    BEGIN
      IF NOT IsSaaS THEN
        EXIT;

      CodeUnitMetadata.ID := CODEUNIT::"Generate Master Data Telemetry";
      TelemetryManagement.ScheduleCalEventsForTelemetryAsync(CodeUnitMetadata.RECORDID,CODEUNIT::"Create Telemetry Cal. Events",20);
    END;

    [EventSubscriber(Codeunit,1,OnAfterCompanyOpen,"",Skip,Skip)]
    LOCAL PROCEDURE ScheduleActivityTelemetryAfterCompanyOpen@2();
    VAR
      CodeUnitMetadata@1001 : Record 2000000137;
      TelemetryManagement@1000 : Codeunit 1350;
    BEGIN
      IF NOT IsSaaS THEN
        EXIT;

      CodeUnitMetadata.ID := CODEUNIT::"Generate Activity Telemetry";
      TelemetryManagement.ScheduleCalEventsForTelemetryAsync(CodeUnitMetadata.RECORDID,CODEUNIT::"Create Telemetry Cal. Events",21);
    END;

    [EventSubscriber(Codeunit,80,OnBeforePostCustomerEntry,"",Skip,Skip)]
    LOCAL PROCEDURE EnableTelemetryInconsistentPostingOnBeforePostCustomerEntry@4(VAR GenJnlLine@1000 : Record 81;VAR SalesHeader@1001 : Record 36;VAR TotalSalesLine@1002 : Record 37;VAR TotalSalesLineLCY@1003 : Record 37);
    BEGIN
      IF NOT IsSaaS THEN
        EXIT;

      BINDSUBSCRIPTION(GLPostInconsistentTelem);
    END;

    LOCAL PROCEDURE IsSaaS@28() : Boolean;
    VAR
      PermissionManager@1000 : Codeunit 9002;
    BEGIN
      EXIT(PermissionManager.SoftwareAsAService);
    END;

    BEGIN
    END.
  }
}

