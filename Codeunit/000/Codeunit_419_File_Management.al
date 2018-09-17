OBJECT Codeunit 419 File Management
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      Text001@1004 : TextConst 'DAN=Standard;ENU=Default';
      Text002@1001 : TextConst 'DAN=Du skal angive en filsti.;ENU=You must enter a file path.';
      Text003@1005 : TextConst 'DAN=Du skal angive et filnavn.;ENU=You must enter a file name.';
      FileDoesNotExistErr@1007 : TextConst '@@@=%1 File Path;DAN=Filen %1 findes ikke.;ENU=The file %1 does not exist.';
      Text006@1003 : TextConst 'DAN=Eksport�r;ENU=Export';
      Text007@1002 : TextConst 'DAN=Indl�s;ENU=Import';
      PathHelper@1011 : DotNet "'mscorlib'.System.IO.Path";
      DirectoryHelper@1013 : DotNet "'mscorlib'.System.IO.Directory" RUNONCLIENT;
      ClientFileHelper@1012 : DotNet "'mscorlib'.System.IO.File" RUNONCLIENT;
      ServerFileHelper@1015 : DotNet "'mscorlib'.System.IO.File";
      ServerDirectoryHelper@1030 : DotNet "'mscorlib'.System.IO.Directory";
      Text010@1008 : TextConst 'DAN=Filen %1 er ikke blevet overf�rt.;ENU=The file %1 has not been uploaded.';
      Text011@1009 : TextConst 'DAN=Du skal angive et kildefilnavn.;ENU=You must specify a source file name.';
      Text012@1010 : TextConst 'DAN=Du skal angive et m�lfilnavn.;ENU=You must specify a target file name.';
      Text013@1014 : TextConst 'DAN=Filnavnet %1 findes allerede.;ENU=The file name %1 already exists.';
      DirectoryDoesNotExistErr@1032 : TextConst '@@@="%1=Directory user is trying to upload does not exist";DAN=Mappen %1 findes ikke.;ENU=Directory %1 does not exist.';
      CreatePathQst@1028 : TextConst 'DAN=Stien %1 findes ikke. Vil du tilf�je den nu?;ENU=The path %1 does not exist. Do you want to add it now?';
      AllFilesFilterTxt@1000 : TextConst '@@@={Locked};DAN=*.*;ENU=*.*';
      AllFilesDescriptionTxt@1024 : TextConst '@@@="{Split=r''\|''}{Locked=s''1''}";DAN=Alle filer (*.*)|*.*;ENU=All Files (*.*)|*.*';
      XMLFileType@1006 : TextConst '@@@="{Split=r''\|''}{Locked=s''1''}";DAN=XML-filer (*.xml)|*.xml;ENU=XML Files (*.xml)|*.xml';
      WordFileType@1016 : TextConst '@@@="{Split=r''\|''}{Locked=s''1''}";DAN=Word-filer (*.doc)|*.doc;ENU=Word Files (*.doc)|*.doc';
      Word2007FileType@1017 : TextConst '@@@="{Split=r''\|''}{Locked=s''1''}";DAN="Word-filer (*.docx;*.doc)|*.docx;*.doc";ENU="Word Files (*.docx;*.doc)|*.docx;*.doc"';
      ExcelFileType@1018 : TextConst '@@@="{Split=r''\|''}{Locked=s''1''}";DAN=Excel-filer (*.xls)|*.xls;ENU=Excel Files (*.xls)|*.xls';
      Excel2007FileType@1019 : TextConst '@@@="{Split=r''\|''}{Locked=s''1''}";DAN="Excel-filer (*.xlsx;*.xls)|*.xlsx;*.xls";ENU="Excel Files (*.xlsx;*.xls)|*.xlsx;*.xls"';
      XSDFileType@1020 : TextConst '@@@="{Split=r''\|''}{Locked=s''1''}";DAN=XSD-filer (*.xsd)|*.xsd;ENU=XSD Files (*.xsd)|*.xsd';
      HTMFileType@1021 : TextConst '@@@="{Split=r''\|''}{Locked=s''1''}";DAN=HTM-filer (*.htm)|*.htm;ENU=HTM Files (*.htm)|*.htm';
      XSLTFileType@1022 : TextConst '@@@="{Split=r''\|''}{Locked=s''1''}";DAN=XSLT-filer (*.xslt)|*.xslt;ENU=XSLT Files (*.xslt)|*.xslt';
      TXTFileType@1023 : TextConst '@@@="{Split=r''\|''}{Locked=s''1''}";DAN=Tekstfiler (*.txt)|*.txt;ENU=Text Files (*.txt)|*.txt';
      RDLFileTypeTok@1031 : TextConst '@@@="{Split=r''\|''}{Locked=s''1''}";DAN="SQL Report Builder (*.rdl;*.rdlc)|*.rdl;*.rdlc";ENU="SQL Report Builder (*.rdl;*.rdlc)|*.rdl;*.rdlc"';
      UnsupportedFileExtErr@1025 : TextConst 'DAN=Ikke-underst�ttet filtypenavn (.%1). De underst�ttede filtypenavne er (%2).;ENU=Unsupported file extension (.%1). The supported file extensions are (%2).';
      SingleFilterErr@1026 : TextConst 'DAN=Angiv et filfilter og et filter for filtypenavn, n�r du bruger denne funktion.;ENU=Specify a file filter and an extension filter when using this function.';
      InvalidWindowsChrStringTxt@1027 : TextConst '@@@={Locked};DAN="""#%&*:<>?\/{|}~";ENU="""#%&*:<>?\/{|}~"';
      ZipArchive@1029 : DotNet "'System.IO.Compression, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.Compression.ZipArchive";
      ZipArchiveMode@1033 : DotNet "'System.IO.Compression, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.Compression.ZipArchiveMode";

    [Internal]
    PROCEDURE BLOBImport@3(VAR BLOBRef@1000 : TEMPORARY Record 99008535;Name@1002 : Text) : Text;
    BEGIN
      EXIT(BLOBImportWithFilter(BLOBRef,Text007,Name,AllFilesDescriptionTxt,AllFilesFilterTxt));
    END;

    [Internal]
    PROCEDURE BLOBImportWithFilter@27(VAR TempBlob@1000 : Record 99008535;DialogCaption@1005 : Text;Name@1002 : Text;FileFilter@1003 : Text;ExtFilter@1008 : Text) : Text;
    VAR
      NVInStream@1001 : InStream;
      NVOutStream@1004 : OutStream;
      UploadResult@1006 : Boolean;
      ErrorMessage@1007 : Text;
    BEGIN
      // ExtFilter examples: 'csv,txt' if you only accept *.csv and *.txt or '*.*' if you accept any extensions
      CLEARLASTERROR;

      IF (FileFilter = '') XOR (ExtFilter = '') THEN
        ERROR(SingleFilterErr);

      // There is no way to check if NVInStream is null before using it after calling the
      // UPLOADINTOSTREAM therefore if result is false this is the only way we can throw the error.
      UploadResult := UPLOADINTOSTREAM(DialogCaption,'',FileFilter,Name,NVInStream);
      IF UploadResult THEN
        ValidateFileExtension(Name,ExtFilter);
      IF UploadResult THEN BEGIN
        TempBlob.Blob.CREATEOUTSTREAM(NVOutStream);
        COPYSTREAM(NVOutStream,NVInStream);
        EXIT(Name);
      END;
      ErrorMessage := GETLASTERRORTEXT;
      IF ErrorMessage <> '' THEN
        ERROR(ErrorMessage);

      EXIT('');
    END;

    LOCAL PROCEDURE BLOBExportLocal@68(VAR InStream@1000 : InStream;Name@1001 : Text;IsCommonDialog@1002 : Boolean) : Text;
    VAR
      ToFile@1004 : Text;
      Path@1006 : Text;
      IsDownloaded@1007 : Boolean;
    BEGIN
      IF IsCommonDialog THEN BEGIN
        IF STRPOS(Name,'*') = 0 THEN
          ToFile := Name
        ELSE
          ToFile := DELCHR(INSSTR(Name,Text001,1),'=','*');
        Path := PathHelper.GetDirectoryName(ToFile);
        ToFile := GetFileName(ToFile);
      END ELSE BEGIN
        ToFile := ClientTempFileName(GetExtension(Name));
        Path := Magicpath;
      END;
      IsDownloaded := DOWNLOADFROMSTREAM(InStream,Text006,Path,GetToFilterText('',Name),ToFile);
      IF IsDownloaded THEN
        EXIT(ToFile);
      EXIT('');
    END;

    [Internal]
    PROCEDURE BLOBExportWithEncoding@67(VAR TempBlob@1002 : TEMPORARY Record 99008535;Name@1001 : Text;CommonDialog@1000 : Boolean;Encoding@1004 : TextEncoding) : Text;
    VAR
      NVInStream@1003 : InStream;
    BEGIN
      TempBlob.Blob.CREATEINSTREAM(NVInStream,Encoding);
      EXIT(BLOBExportLocal(NVInStream,Name,CommonDialog));
    END;

    [Internal]
    PROCEDURE BLOBExport@4(VAR TempBlob@1002 : TEMPORARY Record 99008535;Name@1001 : Text;CommonDialog@1000 : Boolean) : Text;
    VAR
      NVInStream@1003 : InStream;
    BEGIN
      TempBlob.Blob.CREATEINSTREAM(NVInStream);
      EXIT(BLOBExportLocal(NVInStream,Name,CommonDialog));
    END;

    [Internal]
    PROCEDURE ServerTempFileName@5(FileExtension@1002 : Text) FileName : Text;
    VAR
      TempFile@1000 : File;
    BEGIN
      TempFile.CREATETEMPFILE;
      FileName := CreateFileNameWithExtension(TempFile.NAME,FileExtension);
      TempFile.CLOSE;
    END;

    [Internal]
    PROCEDURE ClientTempFileName@6(FileExtension@1002 : Text) ClientFileName : Text;
    VAR
      TempFile@1004 : File;
      ClientTempPath@1000 : Text;
    BEGIN
      // Returns the pseudo uniquely generated name of a non existing file in the client temp directory
      TempFile.CREATETEMPFILE;
      ClientFileName := CreateFileNameWithExtension(TempFile.NAME,FileExtension);
      TempFile.CLOSE;
      TempFile.CREATE(ClientFileName);
      TempFile.CLOSE;
      ClientTempPath := GetDirectoryName(DownloadTempFile(ClientFileName));
      IF ERASE(ClientFileName) THEN;
      ClientFileHelper.Delete(ClientTempPath + '\' + PathHelper.GetFileName(ClientFileName));
      ClientFileName := CreateFileNameWithExtension(ClientTempPath + '\' + FORMAT(CREATEGUID),FileExtension);
    END;

    [Internal]
    PROCEDURE CreateClientTempSubDirectory@54() ClientDirectory : Text;
    VAR
      ServerFile@1000 : File;
      ServerFileName@1001 : Text;
    BEGIN
      // Creates a new subdirectory in the client's TEMP folder
      ServerFile.CREATE(CREATEGUID);
      ServerFileName := ServerFile.NAME;
      ServerFile.CLOSE;
      ClientDirectory := GetDirectoryName(DownloadTempFile(ServerFileName));
      IF ERASE(ServerFileName) THEN;
      DeleteClientFile(CombinePath(ClientDirectory,GetFileName(ServerFileName)));
      ClientDirectory := CombinePath(ClientDirectory,CREATEGUID);
      CreateClientDirectory(ClientDirectory);
    END;

    [External]
    PROCEDURE DownloadTempFile@7(ServerFileName@1001 : Text) : Text;
    VAR
      FileName@1102601003 : Text;
      Path@1102601004 : Text;
    BEGIN
      FileName := ServerFileName;
      Path := Magicpath;
      DOWNLOAD(ServerFileName,'',Path,AllFilesDescriptionTxt,FileName);
      EXIT(FileName);
    END;

    [External]
    PROCEDURE UploadFileSilent@10(ClientFilePath@1001 : Text) : Text;
    BEGIN
      EXIT(
        UploadFileSilentToServerPath(ClientFilePath,''));
    END;

    [Internal]
    PROCEDURE UploadFileSilentToServerPath@73(ClientFilePath@1001 : Text;ServerFilePath@1005 : Text) : Text;
    VAR
      ClientFileAttributes@1004 : DotNet "'mscorlib'.System.IO.FileAttributes";
      ServerFileName@1006 : Text;
      TempClientFile@1000 : Text;
      FileName@1002 : Text;
      FileExtension@1003 : Text;
    BEGIN
      IF NOT ClientFileHelper.Exists(ClientFilePath) THEN
        ERROR(FileDoesNotExistErr,ClientFilePath);
      FileName := GetFileName(ClientFilePath);
      FileExtension := GetExtension(FileName);

      TempClientFile := ClientTempFileName(FileExtension);
      ClientFileHelper.Copy(ClientFilePath,TempClientFile,TRUE);

      IF ServerFilePath <> '' THEN
        ServerFileName := ServerFilePath
      ELSE
        ServerFileName := ServerTempFileName(FileExtension);

      IF NOT UPLOAD('',Magicpath,AllFilesDescriptionTxt,GetFileName(TempClientFile),ServerFileName) THEN
        ERROR(Text010,ClientFilePath);

      ClientFileHelper.SetAttributes(TempClientFile,ClientFileAttributes.Normal);
      ClientFileHelper.Delete(TempClientFile);
      EXIT(ServerFileName);
    END;

    [Internal]
    PROCEDURE UploadFile@21(WindowTitle@1003 : Text[50];ClientFileName@1001 : Text) ServerFileName : Text;
    VAR
      Filter@1005 : Text;
    BEGIN
      Filter := GetToFilterText('',ClientFileName);

      IF PathHelper.GetFileNameWithoutExtension(ClientFileName) = '' THEN
        ClientFileName := '';

      ServerFileName := UploadFileWithFilter(WindowTitle,ClientFileName,Filter,AllFilesFilterTxt);
    END;

    [Internal]
    PROCEDURE UploadFileWithFilter@25(WindowTitle@1003 : Text[50];ClientFileName@1001 : Text;FileFilter@1000 : Text;ExtFilter@1004 : Text) ServerFileName : Text;
    VAR
      Uploaded@1002 : Boolean;
    BEGIN
      CLEARLASTERROR;

      IF (FileFilter = '') XOR (ExtFilter = '') THEN
        ERROR(SingleFilterErr);

      Uploaded := UPLOAD(WindowTitle,'',FileFilter,ClientFileName,ServerFileName);
      IF Uploaded THEN
        ValidateFileExtension(ClientFileName,ExtFilter);
      IF Uploaded THEN
        EXIT(ServerFileName);

      IF GETLASTERRORTEXT <> '' THEN
        ERROR('%1',GETLASTERRORTEXT);

      EXIT('');
    END;

    [External]
    PROCEDURE Magicpath@9() : Text;
    BEGIN
      EXIT('<TEMP>');   // MAGIC PATH makes sure we don't get a prompt
    END;

    [Internal]
    PROCEDURE DownloadHandler@2(FromFile@1000 : Text;DialogTitle@1001 : Text;ToFolder@1002 : Text;ToFilter@1003 : Text;ToFile@1004 : Text) : Boolean;
    VAR
      Downloaded@1005 : Boolean;
    BEGIN
      CLEARLASTERROR;
      Downloaded := DOWNLOAD(FromFile,DialogTitle,ToFolder,ToFilter,ToFile);
      IF NOT Downloaded THEN
        IF GETLASTERRORTEXT <> '' THEN
          ERROR('%1',GETLASTERRORTEXT);
      EXIT(Downloaded);
    END;

    [Internal]
    PROCEDURE DownloadToFile@13(ServerFileName@1002 : Text;ClientFileName@1000 : Text);
    VAR
      TempClientFileName@1001 : Text;
    BEGIN
      ValidateFileNames(ServerFileName,ClientFileName);
      TempClientFileName := DownloadTempFile(ServerFileName);
      MoveFile(TempClientFileName,ClientFileName);
    END;

    [Internal]
    PROCEDURE AppendAllTextToClientFile@44(ServerFileName@1001 : Text;ClientFileName@1000 : Text);
    BEGIN
      ValidateFileNames(ServerFileName,ClientFileName);
      ClientFileHelper.AppendAllText(ClientFileName,ServerFileHelper.ReadAllText(ServerFileName));
    END;

    [Internal]
    PROCEDURE MoveAndRenameClientFile@11(OldFilePath@1001 : Text;NewFileName@1004 : Text;NewSubDirectoryName@1002 : Text) NewFilePath : Text;
    VAR
      directory@1003 : Text;
    BEGIN
      IF OldFilePath = '' THEN
        ERROR(Text002);

      IF NewFileName = '' THEN
        ERROR(Text003);

      IF NOT ClientFileHelper.Exists(OldFilePath) THEN
        ERROR(FileDoesNotExistErr,OldFilePath);

      // Get the directory from the OldFilePath, if directory is empty it will just use the current location.
      directory := GetDirectoryName(OldFilePath);

      // create the sub directory name is name is given
      IF NewSubDirectoryName <> '' THEN BEGIN
        directory := PathHelper.Combine(directory,NewSubDirectoryName);
        DirectoryHelper.CreateDirectory(directory);
      END;

      NewFilePath := PathHelper.Combine(directory,NewFileName);
      MoveFile(OldFilePath,NewFilePath);

      EXIT(NewFilePath);
    END;

    [Internal]
    PROCEDURE CreateClientFile@81(FilePathName@1000 : Text);
    VAR
      StreamWriter@1001 : DotNet "'mscorlib'.System.IO.StreamWriter" RUNONCLIENT;
    BEGIN
      IF NOT ClientFileHelper.Exists(FilePathName) THEN BEGIN
        StreamWriter := ClientFileHelper.CreateText(FilePathName);
        StreamWriter.Close;
      END;
    END;

    [Internal]
    PROCEDURE DeleteClientFile@12(FilePath@1001 : Text) : Boolean;
    BEGIN
      IF NOT ClientFileHelper.Exists(FilePath) THEN
        EXIT(FALSE);

      ClientFileHelper.Delete(FilePath);
      EXIT(TRUE);
    END;

    [Internal]
    PROCEDURE CopyClientFile@43(SourceFileName@1000 : Text;DestFileName@1001 : Text;OverWrite@1002 : Boolean);
    BEGIN
      ClientFileHelper.Copy(SourceFileName,DestFileName,OverWrite);
    END;

    [External]
    PROCEDURE ClientFileExists@14(FilePath@1001 : Text) : Boolean;
    BEGIN
      IF NOT CanRunDotNetOnClient THEN
        EXIT(FALSE);
      EXIT(ClientFileHelper.Exists(FilePath));
    END;

    [External]
    PROCEDURE ClientDirectoryExists@42(DirectoryPath@1001 : Text) : Boolean;
    BEGIN
      IF NOT CanRunDotNetOnClient THEN
        EXIT(FALSE);
      EXIT(DirectoryHelper.Exists(DirectoryPath));
    END;

    [Internal]
    PROCEDURE CreateClientDirectory@49(DirectoryPath@1000 : Text);
    BEGIN
      IF NOT ClientDirectoryExists(DirectoryPath) THEN
        DirectoryHelper.CreateDirectory(DirectoryPath);
    END;

    [Internal]
    PROCEDURE DeleteClientDirectory@82(DirectoryPath@1000 : Text);
    BEGIN
      IF ClientDirectoryExists(DirectoryPath) THEN
        DirectoryHelper.Delete(DirectoryPath,TRUE);
    END;

    [Internal]
    PROCEDURE UploadClientDirectorySilent@57(DirectoryPath@1000 : Text;FileExtensionFilter@1002 : Text;IncludeSubDirectories@1003 : Boolean) ServerDirectoryPath : Text;
    VAR
      SearchOption@1004 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.SearchOption" RUNONCLIENT;
      ArrayHelper@1005 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Array" RUNONCLIENT;
      ClientFilePath@1008 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.String" RUNONCLIENT;
      ServerFilePath@1001 : Text;
      RelativeServerPath@1010 : Text;
      i@1006 : Integer;
      ArrayLength@1007 : Integer;
    BEGIN
      IF NOT ClientDirectoryExists(DirectoryPath) THEN
        ERROR(DirectoryDoesNotExistErr,DirectoryPath);

      IF IncludeSubDirectories THEN
        ArrayHelper := DirectoryHelper.GetFiles(DirectoryPath,FileExtensionFilter,SearchOption.AllDirectories)
      ELSE
        ArrayHelper := DirectoryHelper.GetFiles(DirectoryPath,FileExtensionFilter,SearchOption.TopDirectoryOnly);

      ArrayLength := ArrayHelper.GetLength(0);

      IF ArrayLength = 0 THEN
        EXIT;

      ServerDirectoryPath := ServerCreateTempSubDirectory;

      FOR i := 1 TO ArrayLength DO BEGIN
        ClientFilePath := ArrayHelper.GetValue(i - 1);
        RelativeServerPath := ClientFilePath.Replace(DirectoryPath,'');
        IF PathHelper.IsPathRooted(RelativeServerPath) THEN
          RelativeServerPath := DELCHR(RelativeServerPath,'<','\');
        ServerFilePath := CombinePath(ServerDirectoryPath,RelativeServerPath);
        ServerCreateDirectory(GetDirectoryName(ServerFilePath));
        UploadFileSilentToServerPath(ClientFilePath,ServerFilePath);
      END;
    END;

    [Internal]
    PROCEDURE MoveFile@15(SourceFileName@1001 : Text;TargetFileName@1002 : Text);
    BEGIN
      // System.IO.File.Move is not used due to a known issue in KB310316
      IF NOT ClientFileHelper.Exists(SourceFileName) THEN
        ERROR(FileDoesNotExistErr,SourceFileName);

      IF UPPERCASE(SourceFileName) = UPPERCASE(TargetFileName) THEN
        EXIT;

      ValidateClientPath(GetDirectoryName(TargetFileName));

      DeleteClientFile(TargetFileName);
      ClientFileHelper.Copy(SourceFileName,TargetFileName);
      ClientFileHelper.Delete(SourceFileName);
    END;

    [Internal]
    PROCEDURE CopyServerFile@32(SourceFileName@1001 : Text;TargetFileName@1002 : Text;Overwrite@1000 : Boolean);
    BEGIN
      ServerFileHelper.Copy(SourceFileName,TargetFileName,Overwrite);
    END;

    [External]
    PROCEDURE ServerFileExists@33(FilePath@1001 : Text) : Boolean;
    BEGIN
      EXIT(EXISTS(FilePath));
    END;

    [Internal]
    PROCEDURE DeleteServerFile@34(FilePath@1001 : Text) : Boolean;
    BEGIN
      IF NOT EXISTS(FilePath) THEN
        EXIT(FALSE);

      ServerFileHelper.Delete(FilePath);
      EXIT(TRUE);
    END;

    [Internal]
    PROCEDURE ServerDirectoryExists@48(DirectoryPath@1000 : Text) : Boolean;
    BEGIN
      EXIT(ServerDirectoryHelper.Exists(DirectoryPath));
    END;

    [Internal]
    PROCEDURE ServerCreateDirectory@47(DirectoryPath@1000 : Text);
    BEGIN
      IF NOT ServerDirectoryExists(DirectoryPath) THEN
        ServerDirectoryHelper.CreateDirectory(DirectoryPath);
    END;

    [Internal]
    PROCEDURE ServerCreateTempSubDirectory@59() DirectoryPath : Text;
    VAR
      ServerTempFile@1001 : Text;
    BEGIN
      ServerTempFile := ServerTempFileName('tmp');
      DirectoryPath := CombinePath(GetDirectoryName(ServerTempFile),FORMAT(CREATEGUID));
      ServerCreateDirectory(DirectoryPath);
      DeleteServerFile(ServerTempFile);
    END;

    [Internal]
    PROCEDURE ServerRemoveDirectory@55(DirectoryPath@1000 : Text;Recursive@1001 : Boolean);
    BEGIN
      IF ServerDirectoryExists(DirectoryPath) THEN
        ServerDirectoryHelper.Delete(DirectoryPath,Recursive);
    END;

    [External]
    PROCEDURE GetFileName@16(FilePath@1001 : Text) : Text;
    BEGIN
      EXIT(PathHelper.GetFileName(FilePath));
    END;

    [External]
    PROCEDURE GetSafeFileName@69(FileName@1000 : Text) : Text;
    VAR
      DotNetString@1001 : DotNet "'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.String";
      Result@1005 : Text;
      Str@1006 : Text;
    BEGIN
      DotNetString := FileName;
      FOREACH Str IN DotNetString.Split(PathHelper.GetInvalidFileNameChars) DO
        Result += Str;
      EXIT(Result);
    END;

    [Internal]
    PROCEDURE GetFileNameWithoutExtension@35(FilePath@1000 : Text) : Text;
    BEGIN
      EXIT(PathHelper.GetFileNameWithoutExtension(FilePath));
    END;

    [Internal]
    PROCEDURE GetDirectoryName@8(FileName@1001 : Text) : Text;
    BEGIN
      IF FileName = '' THEN
        EXIT(FileName);

      FileName := DELCHR(FileName,'<');
      EXIT(PathHelper.GetDirectoryName(FileName));
    END;

    [Internal]
    PROCEDURE GetClientDirectoryFilesList@51(VAR NameValueBuffer@1002 : Record 823;DirectoryPath@1000 : Text);
    VAR
      ArrayHelper@1001 : DotNet "'mscorlib'.System.Array" RUNONCLIENT;
      i@1003 : Integer;
    BEGIN
      NameValueBuffer.RESET;
      NameValueBuffer.DELETEALL;

      ArrayHelper := DirectoryHelper.GetFiles(DirectoryPath);
      FOR i := 1 TO ArrayHelper.GetLength(0) DO BEGIN
        NameValueBuffer.ID := i;
        EVALUATE(NameValueBuffer.Name,ArrayHelper.GetValue(i - 1));
        NameValueBuffer.INSERT;
      END;
    END;

    [Internal]
    PROCEDURE GetServerDirectoryFilesList@64(VAR NameValueBuffer@1000 : Record 823;DirectoryPath@1001 : Text);
    VAR
      ArrayHelper@1002 : DotNet "'mscorlib'.System.Array";
      i@1003 : Integer;
    BEGIN
      NameValueBuffer.RESET;
      NameValueBuffer.DELETEALL;

      ArrayHelper := ServerDirectoryHelper.GetFiles(DirectoryPath);
      FOR i := 1 TO ArrayHelper.GetLength(0) DO BEGIN
        NameValueBuffer.ID := i;
        EVALUATE(NameValueBuffer.Name,ArrayHelper.GetValue(i - 1));
        NameValueBuffer.Value := COPYSTR(GetFileNameWithoutExtension(NameValueBuffer.Name),1,250);
        NameValueBuffer.INSERT;
      END;
    END;

    [Internal]
    PROCEDURE GetServerDirectoryFilesListInclSubDirs@72(VAR TempNameValueBuffer@1000 : TEMPORARY Record 823;DirectoryPath@1001 : Text);
    BEGIN
      TempNameValueBuffer.RESET;
      TempNameValueBuffer.DELETEALL;

      GetServerDirectoryFilesListInclSubDirsInner(TempNameValueBuffer,DirectoryPath);
    END;

    LOCAL PROCEDURE GetServerDirectoryFilesListInclSubDirsInner@80(VAR NameValueBuffer@1000 : Record 823;DirectoryPath@1001 : Text);
    VAR
      ArrayHelper@1002 : DotNet "'mscorlib'.System.Array";
      FileSystemEntry@1004 : Text;
      Index@1003 : Integer;
      LastId@1005 : Integer;
    BEGIN
      ArrayHelper := ServerDirectoryHelper.GetFileSystemEntries(DirectoryPath);
      FOR Index := 1 TO ArrayHelper.GetLength(0) DO BEGIN
        IF NameValueBuffer.FINDLAST THEN
          LastId := NameValueBuffer.ID;
        EVALUATE(FileSystemEntry,ArrayHelper.GetValue(Index - 1));
        IF ServerDirectoryExists(FileSystemEntry) THEN
          GetServerDirectoryFilesListInclSubDirsInner(NameValueBuffer,FileSystemEntry)
        ELSE BEGIN
          NameValueBuffer.ID := LastId + 1;
          NameValueBuffer.Name := COPYSTR(FileSystemEntry,1,250);
          NameValueBuffer.Value := COPYSTR(GetFileNameWithoutExtension(NameValueBuffer.Name),1,250);
          NameValueBuffer.INSERT;
        END;
      END;
    END;

    [Internal]
    PROCEDURE GetClientFileProperties@53(FullFileName@1000 : Text;VAR ModifyDate@1001 : Date;VAR ModifyTime@1002 : Time;VAR Size@1003 : Integer);
    VAR
      FileInfo@1004 : DotNet "'mscorlib'.System.IO.FileInfo" RUNONCLIENT;
      ModifyDateTime@1005 : DateTime;
    BEGIN
      ModifyDateTime := ClientFileHelper.GetLastWriteTime(FullFileName);
      ModifyDate := DT2DATE(ModifyDateTime);
      ModifyTime := DT2TIME(ModifyDateTime);
      Size := FileInfo.FileInfo(FullFileName).Length;
    END;

    [Internal]
    PROCEDURE CombinePath@50(BasePath@1000 : Text;Suffix@1001 : Text) : Text;
    BEGIN
      EXIT(PathHelper.Combine(BasePath,Suffix));
    END;

    [Internal]
    PROCEDURE BLOBImportFromServerFile@17(VAR TempBlob@1001 : Record 99008535;FilePath@1000 : Text);
    VAR
      OutStream@1004 : OutStream;
      InStream@1003 : InStream;
      InputFile@1002 : File;
    BEGIN
      IF NOT FILE.EXISTS(FilePath) THEN
        ERROR(FileDoesNotExistErr,FilePath);

      InputFile.OPEN(FilePath);
      InputFile.CREATEINSTREAM(InStream);
      TempBlob.Blob.CREATEOUTSTREAM(OutStream);
      COPYSTREAM(OutStream,InStream);
      InputFile.CLOSE;
    END;

    [Internal]
    PROCEDURE BLOBExportToServerFile@18(VAR TempBlob@1001 : Record 99008535;FilePath@1000 : Text);
    VAR
      OutStream@1004 : OutStream;
      InStream@1003 : InStream;
      OutputFile@1002 : File;
    BEGIN
      IF FILE.EXISTS(FilePath) THEN
        ERROR(Text013,FilePath);

      OutputFile.WRITEMODE(TRUE);
      OutputFile.CREATE(FilePath);
      OutputFile.CREATEOUTSTREAM(OutStream);
      TempBlob.Blob.CREATEINSTREAM(InStream);
      COPYSTREAM(OutStream,InStream);
      OutputFile.CLOSE;
    END;

    [Internal]
    PROCEDURE GetToFilterText@19(FilterString@1002 : Text;FileName@1000 : Text) : Text;
    VAR
      OutExt@1001 : Text;
    BEGIN
      IF FilterString <> '' THEN
        EXIT(FilterString);

      CASE UPPERCASE(GetExtension(FileName)) OF
        'DOC':
          OutExt := WordFileType;
        'DOCX':
          OutExt := Word2007FileType;
        'XLS':
          OutExt := ExcelFileType;
        'XLSX':
          OutExt := Excel2007FileType;
        'XSLT':
          OutExt := XSLTFileType;
        'XML':
          OutExt := XMLFileType;
        'XSD':
          OutExt := XSDFileType;
        'HTM':
          OutExt := HTMFileType;
        'TXT':
          OutExt := TXTFileType;
        'RDL':
          OutExt := RDLFileTypeTok;
        'RDLC':
          OutExt := RDLFileTypeTok;
      END;
      IF OutExt = '' THEN
        EXIT(AllFilesDescriptionTxt);
      EXIT(OutExt + '|' + AllFilesDescriptionTxt);  // Also give the option of the general selection
    END;

    [External]
    PROCEDURE GetExtension@20(Name@1000 : Text) : Text;
    VAR
      FileExtension@1002 : Text;
    BEGIN
      FileExtension := PathHelper.GetExtension(Name);

      IF FileExtension <> '' THEN
        FileExtension := DELCHR(FileExtension,'<','.');

      EXIT(FileExtension);
    END;

    [External]
    PROCEDURE OpenFileDialog@1(WindowTitle@1000 : Text[50];DefaultFileName@1001 : Text;FilterString@1002 : Text) : Text;
    VAR
      OpenFileDialog@1006 : DotNet "'System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Windows.Forms.OpenFileDialog" RUNONCLIENT;
      DialagResult@1003 : DotNet "'System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Windows.Forms.DialogResult" RUNONCLIENT;
    BEGIN
      OpenFileDialog := OpenFileDialog.OpenFileDialog;
      OpenFileDialog.ShowReadOnly := FALSE;
      OpenFileDialog.FileName := GetFileName(DefaultFileName);
      OpenFileDialog.Title := WindowTitle;
      OpenFileDialog.Filter := GetToFilterText(FilterString,DefaultFileName);
      OpenFileDialog.InitialDirectory := GetDirectoryName(DefaultFileName);

      DialagResult := OpenFileDialog.ShowDialog;
      IF DialagResult.CompareTo(DialagResult.OK) = 0 THEN
        EXIT(OpenFileDialog.FileName);
      EXIT('');
    END;

    PROCEDURE SaveFileDialog@23(WindowTitle@1000 : Text[50];DefaultFileName@1001 : Text;FilterString@1002 : Text) : Text;
    VAR
      SaveFileDialog@1008 : DotNet "'System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Windows.Forms.SaveFileDialog" RUNONCLIENT;
      DialagResult@1003 : DotNet "'System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Windows.Forms.DialogResult" RUNONCLIENT;
    BEGIN
      SaveFileDialog := SaveFileDialog.SaveFileDialog;
      SaveFileDialog.CheckPathExists := TRUE;
      SaveFileDialog.OverwritePrompt := TRUE;
      SaveFileDialog.FileName := GetFileName(DefaultFileName);
      SaveFileDialog.Title := WindowTitle;
      SaveFileDialog.Filter := GetToFilterText(FilterString,DefaultFileName);
      SaveFileDialog.InitialDirectory := GetDirectoryName(DefaultFileName);

      DialagResult := SaveFileDialog.ShowDialog;
      IF DialagResult.CompareTo(DialagResult.OK) = 0 THEN
        EXIT(SaveFileDialog.FileName);
      EXIT('');
    END;

    [External]
    PROCEDURE SelectFolderDialog@52(WindowTitle@1001 : Text;VAR SelectedFolder@1003 : Text) : Boolean;
    VAR
      FolderBrowser@1000 : DotNet "'System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Windows.Forms.FolderBrowserDialog" RUNONCLIENT;
      DialogResult@1002 : DotNet "'System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Windows.Forms.DialogResult" RUNONCLIENT;
    BEGIN
      FolderBrowser := FolderBrowser.FolderBrowserDialog;
      FolderBrowser.ShowNewFolderButton := TRUE;
      FolderBrowser.Description := WindowTitle;

      DialogResult := FolderBrowser.ShowDialog;
      IF DialogResult = 1 THEN BEGIN
        SelectedFolder := FolderBrowser.SelectedPath;
        EXIT(TRUE);
      END;
    END;

    [External]
    PROCEDURE CanRunDotNetOnClient@41() : Boolean;
    VAR
      ClientTypeManagement@1001 : Codeunit 4;
    BEGIN
      EXIT(ClientTypeManagement.IsWindowsClientType);
    END;

    [External]
    PROCEDURE IsWebClient@46() : Boolean;
    VAR
      ClientTypeManagement@1001 : Codeunit 4;
    BEGIN
      EXIT(ClientTypeManagement.IsCommonWebClientType);
    END;

    [External]
    PROCEDURE IsWindowsClient@39() : Boolean;
    VAR
      ClientTypeManagement@1000 : Codeunit 4;
    BEGIN
      EXIT(ClientTypeManagement.IsWindowsClientType);
    END;

    [Internal]
    PROCEDURE IsValidFileName@22(FileName@1000 : Text) : Boolean;
    VAR
      String@1001 : DotNet "'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.String";
    BEGIN
      IF FileName = '' THEN
        EXIT(FALSE);

      String := GetFileName(FileName);
      IF String.IndexOfAny(PathHelper.GetInvalidFileNameChars) <> -1 THEN
        EXIT(FALSE);

      String := GetDirectoryName(FileName);
      IF String.IndexOfAny(PathHelper.GetInvalidPathChars) <> -1 THEN
        EXIT(FALSE);

      EXIT(TRUE);
    END;

    LOCAL PROCEDURE ValidateFileNames@24(ServerFileName@1000 : Text;ClientFileName@1001 : Text);
    BEGIN
      IF NOT IsValidFileName(ServerFileName) THEN
        ERROR(Text011);

      IF NOT IsValidFileName(ClientFileName) THEN
        ERROR(Text012);
    END;

    [Internal]
    PROCEDURE ValidateFileExtension@26(FilePath@1000 : Text;ValidExtensions@1001 : Text);
    VAR
      FileExt@1003 : Text;
      LowerValidExts@1004 : Text;
    BEGIN
      IF STRPOS(ValidExtensions,AllFilesFilterTxt) <> 0 THEN
        EXIT;

      FileExt := LOWERCASE(GetExtension(GetFileName(FilePath)));
      LowerValidExts := LOWERCASE(ValidExtensions);

      IF STRPOS(LowerValidExts,FileExt) = 0 THEN
        ERROR(STRSUBSTNO(UnsupportedFileExtErr,FileExt,LowerValidExts));
    END;

    LOCAL PROCEDURE ValidateClientPath@45(FilePath@1000 : Text);
    BEGIN
      IF FilePath = '' THEN
        EXIT;
      IF DirectoryHelper.Exists(FilePath) THEN
        EXIT;

      IF CONFIRM(CreatePathQst,TRUE,FilePath) THEN
        DirectoryHelper.CreateDirectory(FilePath)
      ELSE
        ERROR('');
    END;

    LOCAL PROCEDURE CreateFileNameWithExtension@58(FileNameWithoutExtension@1000 : Text;Extension@1001 : Text) FileName : Text;
    BEGIN
      FileName := FileNameWithoutExtension;
      IF Extension <> '' THEN BEGIN
        IF Extension[1] <> '.' THEN
          FileName := FileName + '.';
        FileName := FileName + Extension;
      END
    END;

    [Internal]
    PROCEDURE Ansi2SystemEncoding@28(Destination@1000 : OutStream;Source@1001 : InStream);
    VAR
      StreamReader@1004 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.StreamReader";
      Encoding@1003 : DotNet "'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Text.Encoding";
      EncodedTxt@1002 : Text;
    BEGIN
      StreamReader := StreamReader.StreamReader(Source,Encoding.Default,TRUE);
      EncodedTxt := StreamReader.ReadToEnd;
      Destination.WRITETEXT(EncodedTxt);
    END;

    [Internal]
    PROCEDURE Ansi2SystemEncodingTxt@29(Destination@1001 : OutStream;Source@1000 : Text);
    VAR
      StreamWriter@1004 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.StreamWriter";
      Encoding@1003 : DotNet "'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Text.Encoding";
    BEGIN
      StreamWriter := StreamWriter.StreamWriter(Destination,Encoding.Default);
      StreamWriter.Write(Source);
      StreamWriter.Close;
    END;

    [External]
    PROCEDURE BrowseForFolderDialog@30(WindowTitle@1000 : Text[50];DefaultFolderName@1001 : Text;ShowNewFolderButton@1002 : Boolean) : Text;
    VAR
      FolderBrowserDialog@1006 : DotNet "'System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Windows.Forms.FolderBrowserDialog" RUNONCLIENT;
      DialagResult@1003 : DotNet "'System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Windows.Forms.DialogResult" RUNONCLIENT;
    BEGIN
      FolderBrowserDialog := FolderBrowserDialog.FolderBrowserDialog;
      FolderBrowserDialog.Description := WindowTitle;
      FolderBrowserDialog.SelectedPath := DefaultFolderName;
      FolderBrowserDialog.ShowNewFolderButton := ShowNewFolderButton;

      DialagResult := FolderBrowserDialog.ShowDialog;
      IF DialagResult.CompareTo(DialagResult.OK) = 0 THEN
        EXIT(FolderBrowserDialog.SelectedPath);
      EXIT(DefaultFolderName);
    END;

    [External]
    PROCEDURE StripNotsupportChrInFileName@31(InText@1000 : Text) : Text;
    BEGIN
      EXIT(DELCHR(InText,'=',InvalidWindowsChrStringTxt));
    END;

    [Internal]
    PROCEDURE CreateZipArchiveObject@36() FilePath : Text;
    BEGIN
      FilePath := ServerTempFileName('zip');
      OpenZipFile(FilePath);
    END;

    [Internal]
    PROCEDURE OpenZipFile@62(ServerZipFilePath@1035 : Text);
    VAR
      Zipfile@1001 : DotNet "'System.IO.Compression.FileSystem, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.Compression.ZipFile";
      ZipAchiveMode@1000 : DotNet "'System.IO.Compression, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.Compression.ZipArchiveMode";
    BEGIN
      ZipArchive := Zipfile.Open(ServerZipFilePath,ZipAchiveMode.Create);
    END;

    [Internal]
    PROCEDURE AddFileToZipArchive@37(SourceFileFullPath@1000 : Text;PathInZipFile@1001 : Text);
    VAR
      Zip@1002 : DotNet "'System.IO.Compression.FileSystem, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.Compression.ZipFileExtensions";
    BEGIN
      Zip.CreateEntryFromFile(ZipArchive,SourceFileFullPath,PathInZipFile);
    END;

    [Internal]
    PROCEDURE CloseZipArchive@38();
    BEGIN
      IF NOT ISNULL(ZipArchive) THEN
        ZipArchive.Dispose;
    END;

    [Internal]
    PROCEDURE IsGZip@40(ServerSideFileName@1000 : Text) : Boolean;
    VAR
      FileStream@1005 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.FileStream";
      FileMode@1006 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.FileMode";
      ID@1007 : ARRAY [2] OF Integer;
    BEGIN
      FileStream := FileStream.FileStream(ServerSideFileName,FileMode.Open);
      ID[1] := FileStream.ReadByte;
      ID[2] := FileStream.ReadByte;
      FileStream.Close;

      // from GZIP file format specification version 4.3
      // Member header and trailer
      // ID1 (IDentification 1)
      // ID2 (IDentification 2)
      // These have the fixed values ID1 = 31 (0x1f, \037), ID2 = 139 (0x8b, \213), to identify the file as being in gzip format.

      EXIT((ID[1] = 31) AND (ID[2] = 139));
    END;

    [TryFunction]
    [Internal]
    PROCEDURE ExtractZipFile@56(ZipFilePath@1001 : Text;DestinationFolder@1006 : Text);
    VAR
      Zip@1004 : DotNet "'System.IO.Compression.FileSystem, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.Compression.ZipFileExtensions";
      ZipFile@1000 : DotNet "'System.IO.Compression.FileSystem, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.Compression.ZipFile";
    BEGIN
      IF NOT ServerFileHelper.Exists(ZipFilePath) THEN
        ERROR(FileDoesNotExistErr,ZipFilePath);

      // Create directory if it doesn't exist
      ServerCreateDirectory(DestinationFolder);

      ZipArchive := ZipFile.Open(ZipFilePath,ZipArchiveMode.Read);
      Zip.ExtractToDirectory(ZipArchive,DestinationFolder);
      CloseZipArchive;
    END;

    [Internal]
    PROCEDURE ExtractZipFileAndGetFileList@63(ServerZipFilePath@1000 : Text;VAR NameValueBuffer@1001 : Record 823);
    VAR
      ServerDestinationFolder@1002 : Text;
    BEGIN
      ServerDestinationFolder := ServerCreateTempSubDirectory;
      ExtractZipFile(ServerZipFilePath,ServerDestinationFolder);
      GetServerDirectoryFilesList(NameValueBuffer,ServerDestinationFolder);
    END;

    [Internal]
    PROCEDURE IsClientDirectoryEmpty@60(Path@1000 : Text) : Boolean;
    BEGIN
      IF DirectoryHelper.Exists(Path) THEN
        EXIT(DirectoryHelper.GetFiles(Path).Length = 0);
      EXIT(FALSE);
    END;

    [Internal]
    PROCEDURE IsServerDirectoryEmpty@61(Path@1000 : Text) : Boolean;
    BEGIN
      IF ServerDirectoryHelper.Exists(Path) THEN
        EXIT(ServerDirectoryHelper.GetFiles(Path).Length = 0);
      EXIT(FALSE);
    END;

    [External]
    PROCEDURE IsWebOrDeviceClient@65() : Boolean;
    VAR
      ActiveSession@1000 : Record 2000000110;
    BEGIN
      IF ActiveSession.GET(SERVICEINSTANCEID,SESSIONID) THEN
        EXIT(ActiveSession."Client Type" IN [ActiveSession."Client Type"::"Web Client",
                                             ActiveSession."Client Type"::Phone,
                                             ActiveSession."Client Type"::Tablet]);

      EXIT(FALSE);
    END;

    [Internal]
    PROCEDURE GetFileContent@66(FilePath@1000 : Text) Result : Text;
    VAR
      FileHandle@1001 : File;
      InStr@1002 : InStream;
    BEGIN
      IF NOT FILE.EXISTS(FilePath) THEN
        EXIT;

      FileHandle.OPEN(FilePath,TEXTENCODING::UTF8);
      FileHandle.CREATEINSTREAM(InStr);

      InStr.READTEXT(Result);
    END;

    BEGIN
    END.
  }
}

