OBJECT Table 1260 Bank Data Conv. Service Setup
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
    OnInsert=VAR
               BankDataConvServMgt@1000 : Codeunit 1265;
             BEGIN
               IF "User Name" = '' THEN
                 BankDataConvServMgt.InitDefaultURLs(Rec);
             END;

    OnDelete=BEGIN
               DeletePassword;
             END;

    CaptionML=[DAN=Ops‘tning af tjeneste til konvertering af bankdata;
               ENU=Bank Data Conv. Service Setup];
  }
  FIELDS
  {
    { 1   ;   ;Primary Key         ;Code10        ;CaptionML=[DAN=Prim‘rn›gle;
                                                              ENU=Primary Key] }
    { 2   ;   ;User Name           ;Text50        ;DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Brugernavn;
                                                              ENU=User Name];
                                                   Editable=Yes }
    { 3   ;   ;Password Key        ;GUID          ;TableRelation="Service Password".Key;
                                                   CaptionML=[DAN=Adgangskoden›gle;
                                                              ENU=Password Key] }
    { 4   ;   ;Sign-up URL         ;Text250       ;ExtendedDatatype=URL;
                                                   CaptionML=[DAN=URL-adresse til tilmelding;
                                                              ENU=Sign-up URL] }
    { 5   ;   ;Service URL         ;Text250       ;OnValidate=VAR
                                                                WebRequestHelper@1000 : Codeunit 1299;
                                                              BEGIN
                                                                IF "Service URL" <> '' THEN
                                                                  WebRequestHelper.IsSecureHttpUrl("Service URL");
                                                              END;

                                                   CaptionML=[DAN=URL-adresse til tjeneste;
                                                              ENU=Service URL] }
    { 6   ;   ;Support URL         ;Text250       ;ExtendedDatatype=URL;
                                                   CaptionML=[DAN=URL-adresse til support;
                                                              ENU=Support URL] }
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
    VAR
      AzureKeyVaultManagement@1000 : Codeunit 2200;
      PermissionManager@1001 : Codeunit 9002;
      UserNameSecretTxt@1002 : TextConst '@@@={Locked};DAN=amcname;ENU=amcname';
      PasswordSecretTxt@1003 : TextConst '@@@={Locked};DAN=amcpassword;ENU=amcpassword';
      CompanyInformationMgt@1004 : Codeunit 1306;

    [External]
    PROCEDURE SavePassword@1(PasswordText@1000 : Text);
    VAR
      ServicePassword@1002 : Record 1261;
    BEGIN
      IF ISNULLGUID("Password Key") OR NOT ServicePassword.GET("Password Key") THEN BEGIN
        ServicePassword.SavePassword(PasswordText);
        ServicePassword.INSERT(TRUE);
        "Password Key" := ServicePassword.Key;
      END ELSE BEGIN
        ServicePassword.SavePassword(PasswordText);
        ServicePassword.MODIFY;
      END;
    END;

    [External]
    PROCEDURE GetUserName@20() : Text[50];
    BEGIN
      IF DemoSaaSCompany AND ("User Name" = '') THEN
        EXIT(RetrieveSaaSUserName);

      EXIT("User Name");
    END;

    [External]
    PROCEDURE GetPassword@2() : Text;
    VAR
      ServicePassword@1000 : Record 1261;
    BEGIN
      // if Demo Company and empty User Name retrieve from Azure Key Vault
      IF DemoSaaSCompany AND ("User Name" = '') THEN
        EXIT(RetrieveSaaSPass);

      ServicePassword.GET("Password Key");
      EXIT(ServicePassword.GetPassword);
    END;

    LOCAL PROCEDURE DeletePassword@4();
    VAR
      ServicePassword@1001 : Record 1261;
    BEGIN
      IF ServicePassword.GET("Password Key") THEN
        ServicePassword.DELETE;
    END;

    [External]
    PROCEDURE HasUserName@22() : Boolean;
    BEGIN
      // if Demo Company try to retrieve from Azure Key Vault
      IF DemoSaaSCompany THEN
        EXIT(TRUE);

      EXIT("User Name" <> '');
    END;

    [External]
    PROCEDURE HasPassword@3() : Boolean;
    VAR
      ServicePassword@1000 : Record 1261;
    BEGIN
      IF PermissionManager.SoftwareAsAService AND ("User Name" = '') THEN
        EXIT(TRUE);

      EXIT(ServicePassword.GET("Password Key"));
    END;

    [External]
    PROCEDURE SetURLsToDefault@5();
    VAR
      BankDataConvServMgt@1000 : Codeunit 1265;
    BEGIN
      BankDataConvServMgt.SetURLsToDefault(Rec);
    END;

    LOCAL PROCEDURE RetrieveSaaSUserName@11() : Text[50];
    VAR
      UserNameValue@1000 : Text[50];
    BEGIN
      IF AzureKeyVaultManagement.GetAzureKeyVaultSecret(UserNameValue,UserNameSecretTxt) THEN
        EXIT(UserNameValue);
    END;

    LOCAL PROCEDURE RetrieveSaaSPass@9() : Text;
    VAR
      PasswordValue@1000 : Text;
    BEGIN
      IF AzureKeyVaultManagement.GetAzureKeyVaultSecret(PasswordValue,PasswordSecretTxt) THEN
        EXIT(PasswordValue);
    END;

    LOCAL PROCEDURE DemoSaaSCompany@10() : Boolean;
    BEGIN
      EXIT(PermissionManager.SoftwareAsAService AND CompanyInformationMgt.IsDemoCompany);
    END;

    BEGIN
    END.
  }
}

