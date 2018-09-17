OBJECT Table 6304 Power BI User Configuration
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Power BI-brugerkonfiguration;
               ENU=Power BI User Configuration];
  }
  FIELDS
  {
    { 1   ;   ;Page ID             ;Text50        ;CaptionML=[DAN=Side-id;
                                                              ENU=Page ID] }
    { 2   ;   ;User Security ID    ;GUID          ;DataClassification=EndUserPseudonymousIdentifiers;
                                                   CaptionML=[DAN=Brugersikkerheds-id;
                                                              ENU=User Security ID] }
    { 3   ;   ;Profile ID          ;Code30        ;CaptionML=[DAN=Profil-id;
                                                              ENU=Profile ID] }
    { 4   ;   ;Report Visibility   ;Boolean       ;CaptionML=[DAN=Rapportsynlighed;
                                                              ENU=Report Visibility] }
    { 5   ;   ;Selected Report ID  ;GUID          ;CaptionML=[DAN=Udvalgt rapport-id;
                                                              ENU=Selected Report ID] }
  }
  KEYS
  {
    {    ;Page ID,User Security ID,Profile ID     ;Clustered=Yes }
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

