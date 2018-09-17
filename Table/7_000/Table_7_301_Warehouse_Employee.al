OBJECT Table 7301 Warehouse Employee
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
               IF Default THEN
                 CheckDefault;
             END;

    OnModify=BEGIN
               IF Default THEN
                 CheckDefault;
             END;

    CaptionML=[DAN=Lagermedarbejder;
               ENU=Warehouse Employee];
    LookupPageID=Page7348;
  }
  FIELDS
  {
    { 1   ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   OnValidate=VAR
                                                                UserMgt@1000 : Codeunit 418;
                                                              BEGIN
                                                                UserMgt.ValidateUserID("User ID");
                                                              END;

                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("User ID");
                                                            END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 2   ;   ;Location Code       ;Code10        ;TableRelation=Location;
                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code] }
    { 4   ;   ;Default             ;Boolean       ;CaptionML=[DAN=Standard;
                                                              ENU=Default] }
    { 7710;   ;ADCS User           ;Code50        ;TableRelation="ADCS User".Name;
                                                   OnValidate=VAR
                                                                WarehouseEmployee@1000 : Record 7301;
                                                              BEGIN
                                                                IF ("ADCS User" <> xRec."ADCS User") AND ("ADCS User" <> '') THEN BEGIN
                                                                  WarehouseEmployee.SETRANGE("ADCS User","ADCS User");
                                                                  IF NOT WarehouseEmployee.ISEMPTY THEN
                                                                    ERROR(Text001);
                                                                END;
                                                              END;

                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=ADCS-bruger;
                                                              ENU=ADCS User] }
  }
  KEYS
  {
    {    ;User ID,Location Code                   ;Clustered=Yes }
    {    ;Default                                  }
    {    ;Location Code                            }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Der kan kun v‘re ‚n standardlokation for hvert bruger-id.;ENU=You can only have one default location per user ID.';
      Text001@1001 : TextConst 'DAN=Du kan kun tildele et ADCS-brugernavn ‚n gang.;ENU=You can only assign an ADCS user name once.';

    LOCAL PROCEDURE CheckDefault@1();
    VAR
      WhseEmployee@1000 : Record 7301;
    BEGIN
      WhseEmployee.SETRANGE(Default,TRUE);
      WhseEmployee.SETRANGE("User ID","User ID");
      WhseEmployee.SETFILTER("Location Code",'<>%1',"Location Code");
      IF NOT WhseEmployee.ISEMPTY THEN
        ERROR(Text000);
    END;

    BEGIN
    END.
  }
}

