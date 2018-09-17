OBJECT Table 7710 ADCS User
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
               TESTFIELD(Password);
             END;

    OnModify=BEGIN
               TESTFIELD(Password);
             END;

    OnRename=BEGIN
               ERROR(RenameIsNotAllowed);
             END;

    CaptionML=[DAN=ADCS-bruger;
               ENU=ADCS User];
  }
  FIELDS
  {
    { 1   ;   ;Name                ;Code50        ;DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Navn;
                                                              ENU=Name];
                                                   NotBlank=Yes }
    { 2   ;   ;Password            ;Text250       ;OnValidate=BEGIN
                                                                TESTFIELD(Password);
                                                                Password := CalculatePassword(COPYSTR(Password,1,30));
                                                              END;

                                                   CaptionML=[DAN=Adgangskode;
                                                              ENU=Password];
                                                   NotBlank=Yes }
  }
  KEYS
  {
    {    ;Name                                    ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      RenameIsNotAllowed@1000 : TextConst 'DAN=Du kan ikke omd›be recorden.;ENU=You cannot rename the record.';

    [Internal]
    PROCEDURE CalculatePassword@1(Input@1000 : Text[30]) HashedValue : Text[250];
    VAR
      Convert@1002 : DotNet "'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Convert";
      CryptoProvider@1003 : DotNet "'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Security.Cryptography.SHA512Managed";
      Encoding@1004 : DotNet "'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Text.Encoding";
    BEGIN
      CryptoProvider := CryptoProvider.SHA512Managed;
      HashedValue := Convert.ToBase64String(CryptoProvider.ComputeHash(Encoding.Unicode.GetBytes(Input + Name)));
      CryptoProvider.Clear;
      CryptoProvider.Dispose;
    END;

    BEGIN
    END.
  }
}

