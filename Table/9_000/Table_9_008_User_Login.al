OBJECT Table 9008 User Login
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Brugerlogon;
               ENU=User Login];
  }
  FIELDS
  {
    { 1   ;   ;User SID            ;GUID          ;DataClassification=EndUserPseudonymousIdentifiers;
                                                   CaptionML=[DAN=Bruger-SID;
                                                              ENU=User SID] }
    { 2   ;   ;First Login Date    ;Date          ;CaptionML=[DAN=Dato for f›rste logon;
                                                              ENU=First Login Date] }
  }
  KEYS
  {
    {    ;User SID                                ;Clustered=Yes }
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

