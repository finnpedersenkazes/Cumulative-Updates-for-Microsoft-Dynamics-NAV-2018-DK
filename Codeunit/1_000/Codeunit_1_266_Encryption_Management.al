OBJECT Codeunit 1266 Encryption Management
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    Permissions=TableData 1261=rm;
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      ExportEncryptionKeyFileDialogTxt@1000 : TextConst 'DAN=V�lg den placering, hvor du vil gemme krypteringsn�glen.;ENU=Choose the location where you want to save the encryption key.';
      ExportEncryptionKeyConfirmQst@1006 : TextConst 'DAN=Filen med krypteringsn�glen skal v�re beskyttet med en adgangskode og gemmes p� en sikker placering.\\Vil du gemme krypteringsn�glen?;ENU=The encryption key file must be protected by a password and stored in a safe location.\\Do you want to save the encryption key?';
      FileImportCaptionMsg@1008 : TextConst 'DAN=V�lg en n�glefil, der skal importeres.;ENU=Select a key file to import.';
      DefaultEncryptionKeyFileNameTxt@1009 : TextConst 'DAN=EncryptionKey.key;ENU=EncryptionKey.key';
      EncryptionKeyFilExtnTxt@1010 : TextConst 'DAN=.key;ENU=.key';
      KeyFileFilterTxt@1012 : TextConst 'DAN=N�glefil(*.key)|*.key;ENU=Key File(*.key)|*.key';
      ReencryptConfirmQst@1013 : TextConst 'DAN=Krypteringen er allerede aktiveret. Hvis du forts�tter, bliver de krypterede data dekrypteret og krypteret igen med den nye n�gle.\\Vil du forts�tte?;ENU=The encryption is already enabled. Continuing will decrypt the encrypted data and encrypt it again with the new key.\\Do you want to continue?';
      EncryptionKeyImportedMsg@1014 : TextConst 'DAN=N�glen er blevet importeret.;ENU=The key was imported successfully.';
      EnableEncryptionConfirmTxt@1015 : TextConst 'DAN=Hvis du aktiverer kryptering, genereres der en krypteringsn�gle p� serveren.\Det anbefales, at du gemmer en kopi af krypteringsn�glen p� en sikker placering.\\Vil du forts�tte?;ENU=Enabling encryption will generate an encryption key on the server.\It is recommended that you save a copy of the encryption key in a safe location.\\Do you want to continue?';
      DisableEncryptionConfirmQst@1016 : TextConst 'DAN=Hvis du deaktiverer kryptering, bliver de krypterede data dekrypteret og gemt i databasen p� en m�de, der ikke er sikker.\\Vil du forts�tte?;ENU=Disabling encryption will decrypt the encrypted data and store it in the database in an unsecure way.\\Do you want to continue?';
      EncryptionCheckFailErr@1017 : TextConst 'DAN=Kryptering er enten ikke aktiveret, eller krypteringsn�glen blev ikke fundet.;ENU=Encryption is either not enabled or the encryption key cannot be found.';
      GlblSilentFileUploadDownload@1011 : Boolean;
      GlblTempClientFileName@1018 : Text;
      FileNameNotSetForSilentUploadErr@1019 : TextConst 'DAN=Der er ikke angivet et filnavn til uoverv�get upload.;ENU=A file name was not specified for silent upload.';
      DeleteEncryptedDataConfirmQst@1002 : TextConst 'DAN=Hvis du forts�tter med denne handling, bliver alle de data, der er krypteret, slettet og g�r tabt.\Er du sikker p�, at du vil slette alle krypterede data?;ENU=If you continue with this action all data that is encrypted will be deleted and lost.\Are you sure you want to delete all encrypted data?';
      EncryptionIsNotActivatedQst@1001 : TextConst 'DAN=Datakryptering er ikke aktiveret. Det anbefales, at du krypterer data. \Vil du �bne vinduet Administration af datakryptering?;ENU=Data encryption is not activated. It is recommended that you encrypt data. \Do you want to open the Data Encryption Management window?';

    [External]
    PROCEDURE Encrypt@1(Text@1000 : Text) : Text;
    BEGIN
      AssertEncryptionPossible;
      IF Text = '' THEN
        EXIT('');
      EXIT(ENCRYPT(Text));
    END;

    [External]
    PROCEDURE Decrypt@5(Text@1000 : Text) : Text;
    BEGIN
      AssertEncryptionPossible;
      IF Text = '' THEN
        EXIT('');
      EXIT(DECRYPT(Text))
    END;

    [Internal]
    PROCEDURE ExportKey@4();
    VAR
      StdPasswordDialog@1000 : Page 9815;
      ServerFilename@1001 : Text;
    BEGIN
      AssertEncryptionPossible;
      IF CONFIRM(ExportEncryptionKeyConfirmQst,TRUE) THEN BEGIN
        StdPasswordDialog.EnableBlankPassword(FALSE);
        IF StdPasswordDialog.RUNMODAL <> ACTION::OK THEN
          EXIT;
        ServerFilename := EXPORTENCRYPTIONKEY(StdPasswordDialog.GetPasswordValue);
        DownloadFile(ServerFilename);
      END;
    END;

    [Internal]
    PROCEDURE ImportKey@3();
    VAR
      FileManagement@1003 : Codeunit 419;
      StdPasswordDialog@1002 : Page 9815;
      TempKeyFilePath@1000 : Text;
    BEGIN
      TempKeyFilePath := UploadFile;

      // TempKeyFilePath is '' if the used cancelled the Upload file dialog.
      IF TempKeyFilePath = '' THEN
        EXIT;

      StdPasswordDialog.EnableGetPasswordMode(FALSE);
      StdPasswordDialog.DisablePasswordConfirmation;
      IF StdPasswordDialog.RUNMODAL = ACTION::OK THEN BEGIN
        IF ENCRYPTIONENABLED THEN
          // Encryption is already enabled so we're just importing the key. If the imported
          // key does not match the already enabled encryption key the process will fail.
          ImportKeyWithoutEncryptingData(TempKeyFilePath,StdPasswordDialog.GetPasswordValue)
        ELSE
          ImportKeyAndEncryptData(TempKeyFilePath,StdPasswordDialog.GetPasswordValue);
      END;

      FileManagement.DeleteServerFile(TempKeyFilePath);
    END;

    [Internal]
    PROCEDURE ChangeKey@15();
    VAR
      FileManagement@1000 : Codeunit 419;
      StdPasswordDialog@1001 : Page 9815;
      TempKeyFilePath@1002 : Text;
    BEGIN
      TempKeyFilePath := UploadFile;

      // TempKeyFilePath is '' if the used cancelled the Upload file dialog.
      IF TempKeyFilePath = '' THEN
        EXIT;

      StdPasswordDialog.EnableGetPasswordMode(FALSE);
      StdPasswordDialog.DisablePasswordConfirmation;
      IF StdPasswordDialog.RUNMODAL = ACTION::OK THEN BEGIN
        IF IsEncryptionEnabled THEN BEGIN
          IF NOT CONFIRM(ReencryptConfirmQst,TRUE) THEN
            EXIT;
          DisableEncryption(TRUE);
        END;

        ImportKeyAndEncryptData(TempKeyFilePath,StdPasswordDialog.GetPasswordValue);
      END;

      FileManagement.DeleteServerFile(TempKeyFilePath);
    END;

    [Internal]
    PROCEDURE EnableEncryption@2();
    BEGIN
      IF CONFIRM(EnableEncryptionConfirmTxt,TRUE) THEN
        EnableEncryptionSilently;
    END;

    [Internal]
    PROCEDURE EnableEncryptionSilently@28();
    BEGIN
      // no user interaction on webservices
      CREATEENCRYPTIONKEY;
      ExportKey;
      EncryptDataInAllCompanies;
    END;

    [Internal]
    PROCEDURE DisableEncryption@7(Silent@1000 : Boolean);
    BEGIN
      // Silent is FALSE when we want the user to take action on if the encryption should be disabled or not. In cases like import key
      // Silent should be TRUE as disabling encryption is a must before importing a new key, else data will be lost.
      IF NOT Silent THEN
        IF NOT CONFIRM(DisableEncryptionConfirmQst,TRUE) THEN
          EXIT;

      DecryptDataInAllCompanies;
      DELETEENCRYPTIONKEY;
    END;

    [External]
    PROCEDURE DeleteEncryptedDataInAllCompanies@14();
    VAR
      Company@1000 : Record 2000000006;
    BEGIN
      IF CONFIRM(DeleteEncryptedDataConfirmQst) THEN BEGIN
        Company.FINDSET;
        REPEAT
          DeleteServicePasswordData(Company.Name);
          DeleteKeyValueData(Company.Name);
        UNTIL Company.NEXT = 0;
        DELETEENCRYPTIONKEY;
      END;
    END;

    [External]
    PROCEDURE IsEncryptionEnabled@20() : Boolean;
    BEGIN
      EXIT(ENCRYPTIONENABLED);
    END;

    [External]
    PROCEDURE IsEncryptionPossible@27() : Boolean;
    BEGIN
      // ENCRYPTIONKEYEXISTS checks if the correct key is present, which only works if encryption is enabled
      EXIT(ENCRYPTIONKEYEXISTS);
    END;

    LOCAL PROCEDURE AssertEncryptionPossible@6();
    BEGIN
      IF IsEncryptionEnabled THEN
        IF IsEncryptionPossible THEN
          EXIT;

      ERROR(EncryptionCheckFailErr);
    END;

    [Internal]
    PROCEDURE EncryptDataInAllCompanies@11();
    VAR
      Company@1000 : Record 2000000006;
    BEGIN
      Company.FINDSET;
      REPEAT
        EncryptServicePasswordData(Company.Name);
        EncryptKeyValueData(Company.Name);
      UNTIL Company.NEXT = 0;
    END;

    LOCAL PROCEDURE DecryptDataInAllCompanies@12();
    VAR
      Company@1000 : Record 2000000006;
    BEGIN
      Company.FINDSET;
      REPEAT
        DecryptServicePasswordData(Company.Name);
        DecryptKeyValueData(Company.Name);
      UNTIL Company.NEXT = 0;
    END;

    LOCAL PROCEDURE EncryptServicePasswordData@8(CompanyName@1001 : Text[30]);
    VAR
      ServicePassword@1000 : Record 1261;
      InStream@1004 : InStream;
      UnencryptedText@1006 : Text;
    BEGIN
      ServicePassword.CHANGECOMPANY(CompanyName);
      IF ServicePassword.FINDSET THEN
        REPEAT
          ServicePassword.CALCFIELDS(Value);
          ServicePassword.Value.CREATEINSTREAM(InStream);
          InStream.READTEXT(UnencryptedText);

          CLEAR(ServicePassword.Value);
          ServicePassword.SavePassword(UnencryptedText);
          ServicePassword.MODIFY;
        UNTIL ServicePassword.NEXT = 0;
    END;

    LOCAL PROCEDURE DecryptServicePasswordData@9(CompanyName@1001 : Text[30]);
    VAR
      ServicePassword@1000 : Record 1261;
      OutStream@1005 : OutStream;
      EncryptedText@1006 : Text;
    BEGIN
      ServicePassword.CHANGECOMPANY(CompanyName);
      IF ServicePassword.FINDSET THEN
        REPEAT
          EncryptedText := ServicePassword.GetPassword;

          CLEAR(ServicePassword.Value);
          ServicePassword.Value.CREATEOUTSTREAM(OutStream);
          OutStream.WRITETEXT(EncryptedText);
          ServicePassword.MODIFY;
        UNTIL ServicePassword.NEXT = 0;
    END;

    [External]
    PROCEDURE DeleteServicePasswordData@16(CompanyName@1001 : Text[30]);
    VAR
      ServicePassword@1000 : Record 1261;
    BEGIN
      ServicePassword.CHANGECOMPANY(CompanyName);
      IF ServicePassword.FINDSET THEN
        REPEAT
          CLEAR(ServicePassword.Value);
          ServicePassword.MODIFY;
        UNTIL ServicePassword.NEXT = 0;
    END;

    LOCAL PROCEDURE EncryptKeyValueData@23(CompanyName@1001 : Text[30]);
    VAR
      EncryptedKeyValue@1000 : Record 1805;
      InStream@1004 : InStream;
      UnencryptedText@1006 : Text;
    BEGIN
      EncryptedKeyValue.CHANGECOMPANY(CompanyName);
      IF EncryptedKeyValue.FINDSET THEN
        REPEAT
          EncryptedKeyValue.CALCFIELDS(Value);
          EncryptedKeyValue.Value.CREATEINSTREAM(InStream);
          InStream.READTEXT(UnencryptedText);

          CLEAR(EncryptedKeyValue.Value);
          EncryptedKeyValue.InsertValue(UnencryptedText);
          EncryptedKeyValue.MODIFY;
        UNTIL EncryptedKeyValue.NEXT = 0;
    END;

    LOCAL PROCEDURE DecryptKeyValueData@22(CompanyName@1001 : Text[30]);
    VAR
      EncryptedKeyValue@1000 : Record 1805;
      OutStream@1005 : OutStream;
      EncryptedText@1006 : Text;
    BEGIN
      EncryptedKeyValue.CHANGECOMPANY(CompanyName);
      IF EncryptedKeyValue.FINDSET THEN
        REPEAT
          EncryptedText := EncryptedKeyValue.GetValue;

          CLEAR(EncryptedKeyValue.Value);
          EncryptedKeyValue.Value.CREATEOUTSTREAM(OutStream);
          OutStream.WRITETEXT(EncryptedText);
          EncryptedKeyValue.MODIFY;
        UNTIL EncryptedKeyValue.NEXT = 0;
    END;

    LOCAL PROCEDURE DeleteKeyValueData@19(CompanyName@1001 : Text[30]);
    VAR
      EncryptedKeyValue@1000 : Record 1805;
    BEGIN
      EncryptedKeyValue.CHANGECOMPANY(CompanyName);
      IF EncryptedKeyValue.FINDSET THEN
        REPEAT
          CLEAR(EncryptedKeyValue.Value);
          EncryptedKeyValue.MODIFY;
        UNTIL EncryptedKeyValue.NEXT = 0;
    END;

    LOCAL PROCEDURE UploadFile@17() : Text;
    VAR
      FileManagement@1000 : Codeunit 419;
    BEGIN
      IF GlblSilentFileUploadDownload THEN BEGIN
        IF GlblTempClientFileName = '' THEN
          ERROR(FileNameNotSetForSilentUploadErr);
        EXIT(FileManagement.UploadFileSilent(GlblTempClientFileName));
      END;

      EXIT(FileManagement.UploadFileWithFilter(FileImportCaptionMsg,
          DefaultEncryptionKeyFileNameTxt,KeyFileFilterTxt,EncryptionKeyFilExtnTxt));
    END;

    LOCAL PROCEDURE DownloadFile@18(ServerFileName@1001 : Text);
    VAR
      FileManagement@1000 : Codeunit 419;
    BEGIN
      IF GlblSilentFileUploadDownload THEN
        GlblTempClientFileName := FileManagement.DownloadTempFile(ServerFileName)
      ELSE
        FileManagement.DownloadHandler(ServerFileName,ExportEncryptionKeyFileDialogTxt,
          '',KeyFileFilterTxt,DefaultEncryptionKeyFileNameTxt);
    END;

    [External]
    PROCEDURE SetSilentFileUploadDownload@10(IsSilent@1000 : Boolean;SilentFileUploadName@1001 : Text);
    BEGIN
      GlblSilentFileUploadDownload := IsSilent;
      GlblTempClientFileName := SilentFileUploadName;
    END;

    [External]
    PROCEDURE GetGlblTempClientFileName@13() : Text;
    BEGIN
      EXIT(GlblTempClientFileName);
    END;

    LOCAL PROCEDURE ImportKeyAndEncryptData@21(KeyFilePath@1000 : Text;Password@1002 : Text);
    BEGIN
      IMPORTENCRYPTIONKEY(KeyFilePath,Password);
      EncryptDataInAllCompanies;
      MESSAGE(EncryptionKeyImportedMsg);
    END;

    LOCAL PROCEDURE ImportKeyWithoutEncryptingData@25(KeyFilePath@1001 : Text;Password@1000 : Text);
    BEGIN
      IMPORTENCRYPTIONKEY(KeyFilePath,Password);
      MESSAGE(EncryptionKeyImportedMsg);
    END;

    PROCEDURE GetEncryptionIsNotActivatedQst@24() : Text;
    BEGIN
      EXIT(EncryptionIsNotActivatedQst);
    END;

    [External]
    PROCEDURE GenerateHash@39(InputString@1000 : Text;HashAlgorithmType@1001 : 'MD5,SHA1,SHA256,SHA384,SHA512') : Text;
    VAR
      HashBytes@1004 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Array";
    BEGIN
      IF NOT GenerateHashBytes(HashBytes,InputString,HashAlgorithmType) THEN
        EXIT('');
      EXIT(ConvertByteHashToString(HashBytes));
    END;

    [External]
    PROCEDURE GenerateHashAsBase64String@32(InputString@1000 : Text;HashAlgorithmType@1001 : 'MD5,SHA1,SHA256,SHA384,SHA512') : Text;
    VAR
      HashBytes@1004 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Array";
    BEGIN
      IF NOT GenerateHashBytes(HashBytes,InputString,HashAlgorithmType) THEN
        EXIT('');
      EXIT(ConvertByteHashToBase64String(HashBytes));
    END;

    LOCAL PROCEDURE GenerateHashBytes@34(VAR HashBytes@1003 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Array";InputString@1000 : Text;HashAlgorithmType@1001 : 'MD5,SHA1,SHA256,SHA384,SHA512') : Boolean;
    VAR
      Encoding@1002 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Text.Encoding";
    BEGIN
      IF InputString = '' THEN
        EXIT(FALSE);
      IF NOT TryGenerateHash(HashBytes,Encoding.UTF8.GetBytes(InputString),FORMAT(HashAlgorithmType)) THEN
        ERROR(GETLASTERRORTEXT);
      EXIT(TRUE);
    END;

    [TryFunction]
    LOCAL PROCEDURE TryGenerateHash@26(VAR HashBytes@1000 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Array";Bytes@1001 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Array";Algorithm@1002 : Text);
    VAR
      HashAlgorithm@1003 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Security.Cryptography.HashAlgorithm";
    BEGIN
      HashAlgorithm := HashAlgorithm.Create(Algorithm);
      HashBytes := HashAlgorithm.ComputeHash(Bytes);
      HashAlgorithm.Dispose;
    END;

    [External]
    PROCEDURE GenerateKeyedHash@30(InputString@1000 : Text;Key@1005 : Text;HashAlgorithmType@1001 : 'HMACMD5,HMACSHA1,HMACSHA256,HMACSHA384,HMACSHA512') : Text;
    VAR
      HashBytes@1004 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Array";
    BEGIN
      IF NOT GenerateKeyedHashBytes(HashBytes,InputString,Key,HashAlgorithmType) THEN
        EXIT('');
      EXIT(ConvertByteHashToString(HashBytes));
    END;

    [External]
    PROCEDURE GenerateKeyedHashAsBase64String@43(InputString@1000 : Text;Key@1005 : Text;HashAlgorithmType@1001 : 'HMACMD5,HMACSHA1,HMACSHA256,HMACSHA384,HMACSHA512') : Text;
    VAR
      HashBytes@1004 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Array";
    BEGIN
      IF NOT GenerateKeyedHashBytes(HashBytes,InputString,Key,HashAlgorithmType) THEN
        EXIT('');
      EXIT(ConvertByteHashToBase64String(HashBytes));
    END;

    LOCAL PROCEDURE GenerateKeyedHashBytes@44(VAR HashBytes@1002 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Array";InputString@1000 : Text;Key@1005 : Text;HashAlgorithmType@1001 : 'HMACMD5,HMACSHA1,HMACSHA256,HMACSHA384,HMACSHA512') : Boolean;
    BEGIN
      IF (InputString = '') OR (Key = '') THEN
        EXIT(FALSE);
      IF NOT TryGenerateKeyedHash(HashBytes,InputString,Key,FORMAT(HashAlgorithmType)) THEN
        ERROR(GETLASTERRORTEXT);
      EXIT(TRUE);
    END;

    [TryFunction]
    LOCAL PROCEDURE TryGenerateKeyedHash@35(VAR HashBytes@1000 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Array";InputString@1001 : Text;Key@1005 : Text;Algorithm@1002 : Text);
    VAR
      KeyedHashAlgorithm@1006 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Security.Cryptography.KeyedHashAlgorithm";
      Encoding@1004 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Text.Encoding";
    BEGIN
      KeyedHashAlgorithm := KeyedHashAlgorithm.Create(Algorithm);
      KeyedHashAlgorithm.Key(Encoding.UTF8.GetBytes(Key));
      HashBytes := KeyedHashAlgorithm.ComputeHash(Encoding.UTF8.GetBytes(InputString));
      KeyedHashAlgorithm.Dispose;
    END;

    LOCAL PROCEDURE ConvertByteHashToString@29(HashBytes@1000 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Array") : Text;
    VAR
      Byte@1002 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Byte";
      StringBuilder@1001 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Text.StringBuilder";
      I@1003 : Integer;
    BEGIN
      StringBuilder := StringBuilder.StringBuilder;
      FOR I := 0 TO HashBytes.Length - 1 DO BEGIN
        Byte := HashBytes.GetValue(I);
        StringBuilder.Append(Byte.ToString('X2'));
      END;
      EXIT(StringBuilder.ToString);
    END;

    LOCAL PROCEDURE ConvertByteHashToBase64String@31(HashBytes@1000 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Array") : Text;
    VAR
      Convert@1001 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Convert";
    BEGIN
      EXIT(Convert.ToBase64String(HashBytes));
    END;

    BEGIN
    END.
  }
}

