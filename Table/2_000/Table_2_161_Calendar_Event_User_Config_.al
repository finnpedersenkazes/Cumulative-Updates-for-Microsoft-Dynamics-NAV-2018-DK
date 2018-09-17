OBJECT Table 2161 Calendar Event User Config.
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Brugerkonfig. for kalenderh‘ndelse;
               ENU=Calendar Event User Config.];
  }
  FIELDS
  {
    { 1   ;   ;User                ;Code50        ;DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger;
                                                              ENU=User] }
    { 2   ;   ;Default Execute Time;Time          ;InitValue=00:00:00;
                                                   OnValidate=BEGIN
                                                                IF "Default Execute Time" = 0T THEN
                                                                  "Default Execute Time" := 000000T
                                                              END;

                                                   CaptionML=[DAN=Standardudf›relsestidspunkt;
                                                              ENU=Default Execute Time] }
    { 3   ;   ;Current Job Queue Entry;GUID       ;CaptionML=[DAN=Aktuel post i opgavek›;
                                                              ENU=Current Job Queue Entry] }
  }
  KEYS
  {
    {    ;User                                    ;Clustered=Yes }
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

