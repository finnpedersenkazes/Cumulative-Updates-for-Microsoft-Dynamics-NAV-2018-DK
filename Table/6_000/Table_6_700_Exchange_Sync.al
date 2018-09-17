OBJECT Table 6700 Exchange Sync
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    Permissions=TableData 1261=rimd;
    OnDelete=BEGIN
               DeletePassword("Exchange Account Password Key");
             END;

    CaptionML=[DAN=Exchange-synkronisering;
               ENU=Exchange Sync];
  }
  FIELDS
  {
    { 1   ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID];
                                                   NotBlank=Yes }
    { 2   ;   ;Enabled             ;Boolean       ;CaptionML=[DAN=Aktiveret;
                                                              ENU=Enabled] }
    { 3   ;   ;Exchange Service URI;Text250       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Exchange Service URI;
                                                              ENU=Exchange Service URI] }
    { 4   ;   ;Exchange Account Password Key;GUID ;TableRelation="Service Password".Key;
                                                   CaptionML=[DAN=Adgangskoden�gle til Exchange-konto;
                                                              ENU=Exchange Account Password Key] }
    { 5   ;   ;Last Sync Date Time ;DateTime      ;CaptionML=[DAN=Dato/klokkesl�t for seneste synkronisering;
                                                              ENU=Last Sync Date Time];
                                                   Editable=No }
    { 7   ;   ;Folder ID           ;Text30        ;CaptionML=[DAN=Mappe-id;
                                                              ENU=Folder ID] }
    { 9   ;   ;Filter              ;BLOB          ;CaptionML=[DAN=Filter;
                                                              ENU=Filter] }
  }
  KEYS
  {
    {    ;User ID                                 ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      EncryptionIsNotActivatedQst@1000 : TextConst 'DAN=Datakryptering er ikke aktiveret. Det anbefales, at du krypterer data. \Vil du �bne vinduet Administration af datakryptering?;ENU=Data encryption is not activated. It is recommended that you encrypt data. \Do you want to open the Data Encryption Management window?';

    [External]
    PROCEDURE SetExchangeAccountPassword@4(PasswordText@1001 : Text);
    VAR
      ServicePassword@1000 : Record 1261;
    BEGIN
      PasswordText := DELCHR(PasswordText,'=',' ');

      IF ISNULLGUID("Exchange Account Password Key") OR NOT ServicePassword.GET("Exchange Account Password Key") THEN BEGIN
        ServicePassword.SavePassword(PasswordText);
        ServicePassword.INSERT(TRUE);
        "Exchange Account Password Key" := ServicePassword.Key;
      END ELSE BEGIN
        ServicePassword.SavePassword(PasswordText);
        ServicePassword.MODIFY;
      END;

      IF PasswordText <> '' THEN
        CheckEncryption;
    END;

    PROCEDURE GetExchangeEndpoint@7() Endpoint : Text[250];
    VAR
      ExchangeWebServicesServer@1000 : Codeunit 5321;
    BEGIN
      Endpoint := "Exchange Service URI";
      IF Endpoint = '' THEN
        Endpoint := COPYSTR(ExchangeWebServicesServer.GetEndpoint,1,250);
    END;

    LOCAL PROCEDURE CheckEncryption@6();
    BEGIN
      IF NOT ENCRYPTIONENABLED THEN
        IF CONFIRM(EncryptionIsNotActivatedQst) THEN
          PAGE.RUN(PAGE::"Data Encryption Management");
    END;

    LOCAL PROCEDURE DeletePassword@1(PasswordKey@1000 : GUID);
    VAR
      ServicePassword@1001 : Record 1261;
    BEGIN
      IF ServicePassword.GET(PasswordKey) THEN
        ServicePassword.DELETE;
    END;

    [External]
    PROCEDURE SaveFilter@2(FilterText@1000 : Text);
    VAR
      WriteStream@1001 : OutStream;
    BEGIN
      CLEAR(Filter);
      Filter.CREATEOUTSTREAM(WriteStream);
      WriteStream.WRITETEXT(FilterText);
    END;

    [External]
    PROCEDURE GetSavedFilter@3() FilterText : Text;
    VAR
      ReadStream@1000 : InStream;
    BEGIN
      CALCFIELDS(Filter);
      Filter.CREATEINSTREAM(ReadStream);
      ReadStream.READTEXT(FilterText);
    END;

    [External]
    PROCEDURE DeleteActivityLog@5();
    VAR
      ActivityLog@1000 : Record 710;
    BEGIN
      ActivityLog.SETRANGE("Record ID",RECORDID);
      ActivityLog.DELETEALL;
    END;

    BEGIN
    END.
  }
}

