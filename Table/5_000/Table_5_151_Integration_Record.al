OBJECT Table 5151 Integration Record
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               IF ISNULLGUID("Integration ID") THEN
                 "Integration ID" := CREATEGUID;

               "Modified On" := CURRENTDATETIME;
             END;

    OnModify=BEGIN
               "Modified On" := CURRENTDATETIME;
             END;

    CaptionML=[DAN=Integrationsrecord;
               ENU=Integration Record];
  }
  FIELDS
  {
    { 1   ;   ;Table ID            ;Integer       ;CaptionML=[DAN=Tabel-id;
                                                              ENU=Table ID] }
    { 2   ;   ;Page ID             ;Integer       ;CaptionML=[DAN=Side-id;
                                                              ENU=Page ID] }
    { 3   ;   ;Record ID           ;RecordID      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Record-id;
                                                              ENU=Record ID] }
    { 5150;   ;Integration ID      ;GUID          ;CaptionML=[DAN=Integrations-id;
                                                              ENU=Integration ID] }
    { 5151;   ;Deleted On          ;DateTime      ;CaptionML=[DAN=Slettet d.;
                                                              ENU=Deleted On] }
    { 5152;   ;Modified On         ;DateTime      ;CaptionML=[DAN=Rettet den;
                                                              ENU=Modified On] }
  }
  KEYS
  {
    {    ;Integration ID                          ;Clustered=Yes }
    {    ;Record ID                                }
    {    ;Page ID,Deleted On                       }
    {    ;Page ID,Modified On                      }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    [External]
    PROCEDURE FindByIntegrationId@11(IntegrationId@1000 : GUID) : Boolean;
    BEGIN
      IF ISNULLGUID(IntegrationId) THEN
        EXIT(FALSE);

      RESET;
      SETRANGE("Integration ID",IntegrationId);
      EXIT(FINDFIRST);
    END;

    [External]
    PROCEDURE FindByRecordId@13(FindRecordId@1000 : RecordID) : Boolean;
    BEGIN
      IF FindRecordId.TABLENO = 0 THEN
        EXIT(FALSE);

      RESET;
      SETRANGE("Record ID",FindRecordId);
      EXIT(FINDFIRST);
    END;

    BEGIN
    END.
  }
}

