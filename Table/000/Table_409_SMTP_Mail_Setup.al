OBJECT Table 409 SMTP Mail Setup
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    Permissions=TableData 1261=rimd;
    CaptionML=[DAN=Ops‘tning af SMTP-mail;
               ENU=SMTP Mail Setup];
  }
  FIELDS
  {
    { 1   ;   ;Primary Key         ;Code10        ;CaptionML=[DAN=Prim‘rn›gle;
                                                              ENU=Primary Key] }
    { 2   ;   ;SMTP Server         ;Text250       ;CaptionML=[DAN=SMTP-server;
                                                              ENU=SMTP Server] }
    { 3   ;   ;Authentication      ;Option        ;OnValidate=BEGIN
                                                                IF Authentication <> Authentication::Basic THEN BEGIN
                                                                  "User ID" := '';
                                                                  SetPassword('');
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Godkendelse;
                                                              ENU=Authentication];
                                                   OptionCaptionML=[DAN=Anonymt,NTLM,Grundl‘ggende;
                                                                    ENU=Anonymous,NTLM,Basic];
                                                   OptionString=Anonymous,NTLM,Basic }
    { 4   ;   ;User ID             ;Text250       ;OnValidate=BEGIN
                                                                "User ID" := DELCHR("User ID",'<>',' ');
                                                                TESTFIELD(Authentication,Authentication::Basic);
                                                              END;

                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 6   ;   ;SMTP Server Port    ;Integer       ;InitValue=25;
                                                   CaptionML=[DAN=SMTP-serverport;
                                                              ENU=SMTP Server Port] }
    { 7   ;   ;Secure Connection   ;Boolean       ;InitValue=No;
                                                   CaptionML=[DAN=Sikker forbindelse;
                                                              ENU=Secure Connection] }
    { 8   ;   ;Password Key        ;GUID          ;CaptionML=[DAN=Adgangskoden›gle;
                                                              ENU=Password Key] }
  }
  KEYS
  {
    {    ;Primary Key                             ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    [External]
    PROCEDURE SetPassword@1(NewPassword@1000 : Text[250]);
    VAR
      ServicePassword@1001 : Record 1261;
    BEGIN
      IF ISNULLGUID("Password Key") OR NOT ServicePassword.GET("Password Key") THEN BEGIN
        ServicePassword.SavePassword(NewPassword);
        ServicePassword.INSERT(TRUE);
        "Password Key" := ServicePassword.Key;
      END ELSE BEGIN
        ServicePassword.SavePassword(NewPassword);
        ServicePassword.MODIFY;
      END;
    END;

    [External]
    PROCEDURE GetPassword@3() : Text[250];
    VAR
      ServicePassword@1000 : Record 1261;
    BEGIN
      IF NOT ISNULLGUID("Password Key") THEN
        IF ServicePassword.GET("Password Key") THEN
          EXIT(ServicePassword.GetPassword);
      EXIT('');
    END;

    [External]
    PROCEDURE HasPassword@2() : Boolean;
    BEGIN
      EXIT(GetPassword <> '');
    END;

    PROCEDURE RemovePassword@4();
    VAR
      ServicePassword@1020 : Record 1261;
    BEGIN
      IF NOT ISNULLGUID("Password Key") THEN BEGIN
        IF ServicePassword.GET("Password Key") THEN
          ServicePassword.DELETE(TRUE);

        CLEAR("Password Key");
      END;
    END;

    BEGIN
    END.
  }
}

