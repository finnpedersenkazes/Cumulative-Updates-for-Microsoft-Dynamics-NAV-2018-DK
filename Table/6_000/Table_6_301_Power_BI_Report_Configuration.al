OBJECT Table 6301 Power BI Report Configuration
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Power BI-rapportkonfiguration;
               ENU=Power BI Report Configuration];
  }
  FIELDS
  {
    { 1   ;   ;User Security ID    ;GUID          ;DataClassification=EndUserPseudonymousIdentifiers;
                                                   CaptionML=[DAN=Brugersikkerheds-id;
                                                              ENU=User Security ID] }
    { 2   ;   ;Report ID           ;GUID          ;CaptionML=[DAN=Rapport-id;
                                                              ENU=Report ID] }
    { 3   ;   ;Context             ;Text30        ;CaptionML=[DAN=Kontekst;
                                                              ENU=Context];
                                                   Description=Identifies the page, role center, or other host container the report is selected for. }
  }
  KEYS
  {
    {    ;User Security ID,Report ID,Context      ;Clustered=Yes }
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

