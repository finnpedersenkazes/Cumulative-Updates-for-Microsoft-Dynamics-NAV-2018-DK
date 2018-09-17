OBJECT Table 1205 Credit Transfer Register
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    DataCaptionFields=Identifier,Created Date-Time;
    CaptionML=[DAN=Kreditoverf�rselsjournal;
               ENU=Credit Transfer Register];
    LookupPageID=Page1205;
    DrillDownPageID=Page1205;
  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Integer       ;CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 2   ;   ;Identifier          ;Code20        ;CaptionML=[DAN=Id;
                                                              ENU=Identifier] }
    { 3   ;   ;Created Date-Time   ;DateTime      ;CaptionML=[DAN=Oprettet dato/klokkesl�t;
                                                              ENU=Created Date-Time] }
    { 4   ;   ;Created by User     ;Code50        ;TableRelation=User."User Name";
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Oprettet af bruger;
                                                              ENU=Created by User] }
    { 5   ;   ;Status              ;Option        ;CaptionML=[DAN=Status;
                                                              ENU=Status];
                                                   OptionCaptionML=[DAN=Annulleret,Fil oprettet,Fil reeksporteret;
                                                                    ENU=Canceled,File Created,File Re-exported];
                                                   OptionString=Canceled,File Created,File Re-exported;
                                                   Editable=No }
    { 6   ;   ;No. of Transfers    ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Credit Transfer Entry" WHERE (Credit Transfer Register No.=FIELD(No.)));
                                                   CaptionML=[DAN=Antal overflytninger;
                                                              ENU=No. of Transfers] }
    { 7   ;   ;From Bank Account No.;Code20       ;TableRelation="Bank Account";
                                                   CaptionML=[DAN=Fra bankkontonr.;
                                                              ENU=From Bank Account No.] }
    { 8   ;   ;From Bank Account Name;Text50      ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Bank Account".Name WHERE (No.=FIELD(From Bank Account No.)));
                                                   CaptionML=[DAN=Fra bankkontonavn;
                                                              ENU=From Bank Account Name] }
    { 9   ;   ;Exported File       ;BLOB          ;CaptionML=[DAN=Eksporteret fil;
                                                              ENU=Exported File] }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      PaymentsFileNotFoundErr@1000 : TextConst 'DAN=Den oprindelige betalingsfil blev ikke fundet.\Eksport�r en ny fil fra vinduet Udbetalingskladde.;ENU=The original payment file was not found.\Export a new file from the Payment Journal window.';
      ExportToServerFile@1001 : Boolean;

    [External]
    PROCEDURE CreateNew@1(NewIdentifier@1000 : Code[20];NewBankAccountNo@1001 : Code[20]);
    BEGIN
      RESET;
      LOCKTABLE;
      IF FINDLAST THEN;
      INIT;
      "No." += 1;
      Identifier := NewIdentifier;
      "Created Date-Time" := CURRENTDATETIME;
      "Created by User" := USERID;
      "From Bank Account No." := NewBankAccountNo;
      INSERT;
    END;

    [External]
    PROCEDURE SetStatus@3(NewStatus@1000 : Option);
    BEGIN
      LOCKTABLE;
      FIND;
      Status := NewStatus;
      MODIFY;
    END;

    [Internal]
    PROCEDURE Reexport@2();
    VAR
      CreditTransReExportHistory@1000 : Record 1209;
      TempPaymentFileTempBlob@1003 : TEMPORARY Record 99008535;
      FileMgt@1002 : Codeunit 419;
    BEGIN
      CALCFIELDS("Exported File");
      TempPaymentFileTempBlob.INIT;
      TempPaymentFileTempBlob.Blob := "Exported File";

      IF NOT TempPaymentFileTempBlob.Blob.HASVALUE THEN
        ERROR(PaymentsFileNotFoundErr);

      CreditTransReExportHistory.INIT;
      CreditTransReExportHistory."Credit Transfer Register No." := "No.";
      CreditTransReExportHistory.INSERT(TRUE);

      IF FileMgt.BLOBExport(TempPaymentFileTempBlob,STRSUBSTNO('%1.XML',Identifier),NOT ExportToServerFile) <> '' THEN BEGIN
        Status := Status::"File Re-exported";
        MODIFY;
      END;
    END;

    [External]
    PROCEDURE SetFileContent@4(VAR DataExch@1000 : Record 1220);
    BEGIN
      LOCKTABLE;
      FIND;
      DataExch.CALCFIELDS("File Content");
      "Exported File" := DataExch."File Content";
      MODIFY;
    END;

    [External]
    PROCEDURE EnableExportToServerFile@5();
    BEGIN
      ExportToServerFile := TRUE;
    END;

    BEGIN
    END.
  }
}

