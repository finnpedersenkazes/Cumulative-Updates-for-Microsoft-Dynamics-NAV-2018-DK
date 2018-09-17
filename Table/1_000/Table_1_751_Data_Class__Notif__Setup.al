OBJECT Table 1751 Data Class. Notif. Setup
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    ObsoleteState=Pending;
    ObsoleteReason=Functionality moved on My Notifications.;
    CaptionML=[DAN=Konfiguration af notifikation om dataklasse;
               ENU=Data Class. Notif. Setup];
  }
  FIELDS
  {
    { 1   ;   ;USER ID             ;GUID          ;ObsoleteState=Pending;
                                                   ObsoleteReason=Functionality moved on My Notifications.;
                                                   DataClassification=EndUserPseudonymousIdentifiers;
                                                   CaptionML=[DAN=BRUGER-ID;
                                                              ENU=USER ID] }
    { 2   ;   ;Show Notifications  ;Boolean       ;ObsoleteState=Pending;
                                                   ObsoleteReason=Functionality moved on My Notifications.;
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

    BEGIN
    END.
  }
}

