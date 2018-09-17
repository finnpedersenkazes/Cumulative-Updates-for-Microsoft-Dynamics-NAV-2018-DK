OBJECT Table 747 VAT Report Archive
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    Permissions=TableData 747=rimd;
    CaptionML=[DAN=Momsrapportarkiv;
               ENU=VAT Report Archive];
  }
  FIELDS
  {
    { 1   ;   ;VAT Report Type     ;Option        ;CaptionML=[DAN=Momsrapporttype;
                                                              ENU=VAT Report Type];
                                                   OptionCaptionML=[DAN=Oversigt over EU-salg,Momsangivelse;
                                                                    ENU=EC Sales List,VAT Return];
                                                   OptionString=EC Sales List,VAT Return }
    { 2   ;   ;VAT Report No.      ;Code20        ;TableRelation="VAT Report Header".No.;
                                                   CaptionML=[DAN=Momsrapportnummer;
                                                              ENU=VAT Report No.] }
    { 4   ;   ;Submitted By        ;Code50        ;TableRelation=User."User Name";
                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Sendt af;
                                                              ENU=Submitted By] }
    { 5   ;   ;Submission Message BLOB;BLOB       ;CaptionML=[DAN=Meddelelsesblob ved levering;
                                                              ENU=Submission Message BLOB] }
    { 6   ;   ;Submittion Date     ;Date          ;CaptionML=[DAN=Leveringsdato;
                                                              ENU=Submittion Date] }
    { 7   ;   ;Response Message BLOB;BLOB         ;CaptionML=[DAN=Meddelelsesblob ved svar;
                                                              ENU=Response Message BLOB] }
    { 8   ;   ;Response Received Date;DateTime    ;CaptionML=[DAN=Dato for modtaget svar;
                                                              ENU=Response Received Date] }
  }
  KEYS
  {
    {    ;VAT Report Type,VAT Report No.          ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      FileManagement@1000 : Codeunit 419;
      NoSubmissionMessageAvailableErr@1001 : TextConst 'DAN=Rapportens afsendelsesmeddelelse er ikke tilg‘ngelig.;ENU=The submission message of the report is not available.';
      NoResponseMessageAvailableErr@1002 : TextConst 'DAN=Rapportens svarmeddelelse er ikke tilg‘ngelig.;ENU=The response message of the report is not available.';

    [External]
    PROCEDURE ArchiveSubmissionMessage@1000(VATReportTypeValue@1001 : Option;VATReportNoValue@1002 : Code[20];SubmissionMessageTempBlob@1003 : Record 99008535) : Boolean;
    VAR
      VATReportArchive@1000 : Record 747;
    BEGIN
      IF VATReportNoValue = '' THEN
        EXIT(FALSE);
      IF NOT SubmissionMessageTempBlob.Blob.HASVALUE THEN
        EXIT(FALSE);
      IF VATReportArchive.GET(VATReportTypeValue,VATReportNoValue) THEN
        EXIT(FALSE);

      VATReportArchive.INIT;
      VATReportArchive."VAT Report No." := VATReportNoValue;
      VATReportArchive."VAT Report Type" := VATReportTypeValue;
      VATReportArchive."Submitted By" := USERID;
      VATReportArchive."Submittion Date" := TODAY;
      VATReportArchive."Submission Message BLOB" := SubmissionMessageTempBlob.Blob;
      VATReportArchive.INSERT(TRUE);
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE ArchiveResponseMessage@1001(VATReportTypeValue@1010 : Option;VATReportNoValue@1011 : Code[20];ResponseMessageTempBlob@1000 : Record 99008535) : Boolean;
    VAR
      VATReportArchive@1001 : Record 747;
    BEGIN
      IF NOT VATReportArchive.GET(VATReportTypeValue,VATReportNoValue) THEN
        EXIT(FALSE);
      IF NOT ResponseMessageTempBlob.Blob.HASVALUE THEN
        EXIT(FALSE);

      VATReportArchive."Response Received Date" := CURRENTDATETIME;
      VATReportArchive."Response Message BLOB" := ResponseMessageTempBlob.Blob;
      VATReportArchive.MODIFY(TRUE);

      EXIT(TRUE);
    END;

    [External]
    PROCEDURE DownloadSubmissionMessage@3(VATReportTypeValue@1001 : Option;VATReportNoValue@1000 : Code[20]);
    VAR
      VATReportArchive@1004 : Record 747;
      TempBlob@1006 : Record 99008535;
      ServerFileName@1005 : Text;
      ZipFileName@1007 : Text[250];
    BEGIN
      IF NOT VATReportArchive.GET(VATReportTypeValue,VATReportNoValue) THEN
        ERROR(NoSubmissionMessageAvailableErr);

      IF NOT VATReportArchive."Submission Message BLOB".HASVALUE THEN
        ERROR(NoSubmissionMessageAvailableErr);

      VATReportArchive.CALCFIELDS("Submission Message BLOB");
      TempBlob.INIT;
      TempBlob.Blob := VATReportArchive."Submission Message BLOB";

      ServerFileName := FileManagement.ServerTempFileName('xml');
      FileManagement.BLOBExportToServerFile(TempBlob,ServerFileName);

      ZipFileName := VATReportNoValue + '_Submission.txt';
      DownloadZipFile(ZipFileName,ServerFileName);
      FileManagement.DeleteServerFile(ServerFileName);
    END;

    [External]
    PROCEDURE DownloadResponseMessage@2(VATReportTypeValue@1001 : Option;VATReportNoValue@1000 : Code[20]);
    VAR
      VATReportArchive@1008 : Record 747;
      TempBlob@1007 : Record 99008535;
      ServerFileName@1005 : Text;
      ZipFileName@1002 : Text[250];
    BEGIN
      IF NOT VATReportArchive.GET(VATReportTypeValue,VATReportNoValue) THEN
        ERROR(NoResponseMessageAvailableErr);

      IF NOT VATReportArchive."Response Message BLOB".HASVALUE THEN
        ERROR(NoResponseMessageAvailableErr);

      VATReportArchive.CALCFIELDS("Response Message BLOB");
      TempBlob.INIT;
      TempBlob.Blob := VATReportArchive."Response Message BLOB";

      ServerFileName := FileManagement.ServerTempFileName('xml');
      FileManagement.BLOBExportToServerFile(TempBlob,ServerFileName);

      ZipFileName := VATReportNoValue + '_Response.txt';
      DownloadZipFile(ZipFileName,ServerFileName);
      FileManagement.DeleteServerFile(ServerFileName);
    END;

    LOCAL PROCEDURE DownloadZipFile@4(ZipFileName@1000 : Text[250];ServerFileName@1002 : Text);
    VAR
      ZipArchiveName@1001 : Text;
    BEGIN
      ZipArchiveName := FileManagement.CreateZipArchiveObject;
      FileManagement.AddFileToZipArchive(ServerFileName,ZipFileName);

      FileManagement.CloseZipArchive;
      FileManagement.DownloadHandler(ZipArchiveName,'','','',ZipFileName + '.zip');
    END;

    BEGIN
    END.
  }
}

