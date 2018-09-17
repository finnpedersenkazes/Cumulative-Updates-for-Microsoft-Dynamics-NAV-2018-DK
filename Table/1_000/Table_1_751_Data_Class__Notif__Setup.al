OBJECT Table 1751 Data Class. Notif. Setup
{
  OBJECT-PROPERTIES
  {
    Date=06-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21441;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Konfiguration af notifikation om dataklasse;
               ENU=Data Class. Notif. Setup];
  }
  FIELDS
  {
    { 1   ;   ;USER ID             ;GUID          ;DataClassification=EndUserPseudonymousIdentifiers;
                                                   CaptionML=[DAN=BRUGER-ID;
                                                              ENU=USER ID] }
    { 2   ;   ;Show Notifications  ;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Vis notifikationer;
                                                              ENU=Show Notifications] }
  }
  KEYS
  {
    {    ;USER ID                                 ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    PROCEDURE ShowNotifications@1() : Boolean;
    BEGIN
      IF NOT GET(USERSECURITYID) THEN
        EXIT(TRUE);

      EXIT("Show Notifications");
    END;

    PROCEDURE DisableNotifications@2();
    BEGIN
      IF GET(USERSECURITYID) THEN BEGIN
        "Show Notifications" := FALSE;
        MODIFY;
      END ELSE BEGIN
        "USER ID" := USERSECURITYID;
        "Show Notifications" := FALSE;
        INSERT;
      END;
    END;

    BEGIN
    END.
  }
}

