OBJECT Table 1270 OCR Service Setup
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
    OnInsert=BEGIN
               TESTFIELD("Primary Key",'');
               SetURLsToDefault;
             END;

    OnDelete=VAR
               OCRServiceDocTemplate@1000 : Record 1271;
             BEGIN
               DeletePassword("Password Key");
               DeletePassword("Authorization Key");
               OCRServiceDocTemplate.DELETEALL(TRUE)
             END;

    CaptionML=[DAN=Ops�tning af OCR-tjeneste;
               ENU=OCR Service Setup];
  }
  FIELDS
  {
    { 1   ;   ;Primary Key         ;Code10        ;CaptionML=[DAN=Prim�rn�gle;
                                                              ENU=Primary Key] }
    { 2   ;   ;User Name           ;Text50        ;DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Brugernavn;
                                                              ENU=User Name] }
    { 3   ;   ;Password Key        ;GUID          ;TableRelation="Service Password".Key;
                                                   CaptionML=[DAN=Adgangskoden�gle;
                                                              ENU=Password Key] }
    { 4   ;   ;Sign-up URL         ;Text250       ;ExtendedDatatype=URL;
                                                   CaptionML=[DAN=URL-adresse til tilmelding;
                                                              ENU=Sign-up URL] }
    { 5   ;   ;Service URL         ;Text250       ;OnValidate=VAR
                                                                HttpWebRequestMgt@1000 : Codeunit 1297;
                                                              BEGIN
                                                                IF "Service URL" = '' THEN
                                                                  EXIT;
                                                                HttpWebRequestMgt.CheckUrl("Service URL");
                                                                WHILE (STRLEN("Service URL") > 8) AND ("Service URL"[STRLEN("Service URL")] = '/') DO
                                                                  "Service URL" := COPYSTR("Service URL",1,STRLEN("Service URL") - 1);
                                                              END;

                                                   ExtendedDatatype=URL;
                                                   CaptionML=[DAN=URL-adresse til tjeneste;
                                                              ENU=Service URL] }
    { 6   ;   ;Sign-in URL         ;Text250       ;ExtendedDatatype=URL;
                                                   CaptionML=[DAN=URL-adresse til p�logning;
                                                              ENU=Sign-in URL] }
    { 7   ;   ;Authorization Key   ;GUID          ;TableRelation="Service Password".Key;
                                                   CaptionML=[DAN=Autorisationsn�gle;
                                                              ENU=Authorization Key] }
    { 8   ;   ;Customer Name       ;Text80        ;CaptionML=[DAN=Debitornavn;
                                                              ENU=Customer Name];
                                                   Editable=No }
    { 9   ;   ;Customer ID         ;Text50        ;CaptionML=[DAN=Debitor-id;
                                                              ENU=Customer ID];
                                                   Editable=No }
    { 10  ;   ;Customer Status     ;Text30        ;CaptionML=[DAN=Debitorstatus;
                                                              ENU=Customer Status];
                                                   Editable=No }
    { 11  ;   ;Organization ID     ;Text50        ;CaptionML=[DAN=Organisations-id;
                                                              ENU=Organization ID];
                                                   Editable=No }
    { 12  ;   ;Default OCR Doc. Template;Code20   ;TableRelation="OCR Service Document Template";
                                                   OnValidate=VAR
                                                                IncomingDocument@1000 : Record 130;
                                                              BEGIN
                                                                IF xRec."Default OCR Doc. Template" <> '' THEN
                                                                  EXIT;
                                                                IncomingDocument.SETRANGE("OCR Service Doc. Template Code",'');
                                                                IncomingDocument.MODIFYALL("OCR Service Doc. Template Code","Default OCR Doc. Template");
                                                              END;

                                                   OnLookup=VAR
                                                              OCRServiceDocumentTemplate@1000 : Record 1271;
                                                              OCRServiceMgt@1001 : Codeunit 1294;
                                                            BEGIN
                                                              IF OCRServiceDocumentTemplate.ISEMPTY THEN BEGIN
                                                                OCRServiceMgt.SetupConnection(Rec);
                                                                COMMIT;
                                                              END;

                                                              IF PAGE.RUNMODAL(PAGE::"OCR Service Document Templates",OCRServiceDocumentTemplate) = ACTION::LookupOK THEN
                                                                "Default OCR Doc. Template" := OCRServiceDocumentTemplate.Code;
                                                            END;

                                                   CaptionML=[DAN=Standard-OCR-dokumentskabelon;
                                                              ENU=Default OCR Doc. Template] }
    { 13  ;   ;Enabled             ;Boolean       ;OnValidate=VAR
                                                                CompanyInformation@1001 : Record 79;
                                                                OCRServiceMgt@1002 : Codeunit 1294;
                                                                OCRMasterDataMgt@1000 : Codeunit 883;
                                                              BEGIN
                                                                IF Enabled THEN BEGIN
                                                                  OCRServiceMgt.SetupConnection(Rec);
                                                                  IF "Default OCR Doc. Template" = '' THEN
                                                                    IF CompanyInformation.GET THEN
                                                                      CASE CompanyInformation."Country/Region Code" OF
                                                                        'US','USA':
                                                                          VALIDATE("Default OCR Doc. Template",'USA_PO');
                                                                        'CA':
                                                                          VALIDATE("Default OCR Doc. Template",'CAN_PO');
                                                                      END;
                                                                  MODIFY;
                                                                  TESTFIELD("Default OCR Doc. Template");
                                                                  IF "Master Data Sync Enabled" THEN
                                                                    OCRMasterDataMgt.UpdateIntegrationRecords(TRUE);
                                                                  ScheduleJobQueueEntries;
                                                                  IF CONFIRM(JobQEntriesCreatedQst) THEN
                                                                    ShowJobQueueEntry;
                                                                END ELSE
                                                                  CancelJobQueueEntries;
                                                              END;

                                                   CaptionML=[DAN=Aktiveret;
                                                              ENU=Enabled] }
    { 14  ;   ;Master Data Sync Enabled;Boolean   ;OnValidate=VAR
                                                                OCRMasterDataMgt@1001 : Codeunit 883;
                                                              BEGIN
                                                                IF "Master Data Sync Enabled" AND Enabled THEN BEGIN
                                                                  MODIFY;
                                                                  OCRMasterDataMgt.UpdateIntegrationRecords(TRUE);
                                                                  ScheduleJobQueueSync;
                                                                END ELSE
                                                                  CancelJobQueueSync;
                                                              END;

                                                   CaptionML=[DAN=Synkronisering af stamdata aktiveret;
                                                              ENU=Master Data Sync Enabled] }
    { 15  ;   ;Master Data Last Sync;DateTime     ;CaptionML=[DAN=Seneste synkronisering af stamdata;
                                                              ENU=Master Data Last Sync] }
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
      MustBeEnabledErr@1001 : TextConst '@@@="OCR = Optical Character Recognition";DAN=OCR-tjenesten er ikke aktiveret.\\Mark�r afkrydsningsfeltet Aktiveret i vinduet Ops�tning af OCR-tjeneste.;ENU=The OCR service is not enabled.\\In the OCR Service Setup window, select the Enabled check box.';
      JobQEntriesCreatedQst@1002 : TextConst 'DAN=Der er oprettet opgavek�poster til afsendelse og modtagelse af elektroniske dokumenter.\\Vil du �bne vinduet Opgavek�poster?;ENU=Job queue entries for sending and receiving electronic documents have been created.\\Do you want to open the Job Queue Entries window?';

    [External]
    PROCEDURE SavePassword@1(VAR PasswordKey@1001 : GUID;PasswordText@1000 : Text);
    VAR
      ServicePassword@1002 : Record 1261;
    BEGIN
      IF ISNULLGUID(PasswordKey) OR NOT ServicePassword.GET(PasswordKey) THEN BEGIN
        ServicePassword.SavePassword(PasswordText);
        ServicePassword.INSERT(TRUE);
        PasswordKey := ServicePassword.Key;
        MODIFY;
      END ELSE BEGIN
        ServicePassword.SavePassword(PasswordText);
        ServicePassword.MODIFY;
      END;
      COMMIT;
    END;

    [External]
    PROCEDURE GetPassword@2(PasswordKey@1001 : GUID) : Text;
    VAR
      ServicePassword@1000 : Record 1261;
    BEGIN
      ServicePassword.GET(PasswordKey);
      EXIT(ServicePassword.GetPassword);
    END;

    LOCAL PROCEDURE DeletePassword@4(PasswordKey@1000 : GUID);
    VAR
      ServicePassword@1001 : Record 1261;
    BEGIN
      IF ServicePassword.GET(PasswordKey) THEN
        ServicePassword.DELETE;
    END;

    [External]
    PROCEDURE HasPassword@3(PasswordKey@1001 : GUID) : Boolean;
    VAR
      ServicePassword@1000 : Record 1261;
    BEGIN
      IF NOT ServicePassword.GET(PasswordKey) THEN
        EXIT(FALSE);
      EXIT(ServicePassword.GetPassword <> '');
    END;

    [External]
    PROCEDURE SetURLsToDefault@5();
    VAR
      OCRServiceMgt@1000 : Codeunit 1294;
    BEGIN
      OCRServiceMgt.SetURLsToDefaultRSO(Rec);
    END;

    [External]
    PROCEDURE CheckEnabled@7();
    BEGIN
      IF NOT Enabled THEN
        ERROR(MustBeEnabledErr);
    END;

    LOCAL PROCEDURE ScheduleJobQueueEntries@10();
    BEGIN
      ScheduleJobQueueReceive;
      ScheduleJobQueueSend;
      ScheduleJobQueueSync;
    END;

    [External]
    PROCEDURE ScheduleJobQueueSend@13();
    VAR
      JobQueueEntry@1000 : Record 472;
      DummyRecId@1001 : RecordID;
    BEGIN
      CancelJobQueueSend;
      JobQueueEntry.ScheduleRecurrentJobQueueEntry(JobQueueEntry."Object Type to Run"::Codeunit,
        CODEUNIT::"OCR - Send to Service",DummyRecId);
    END;

    [External]
    PROCEDURE ScheduleJobQueueReceive@14();
    VAR
      JobQueueEntry@1000 : Record 472;
      DummyRecId@1001 : RecordID;
    BEGIN
      CancelJobQueueReceive;
      JobQueueEntry.ScheduleRecurrentJobQueueEntry(JobQueueEntry."Object Type to Run"::Codeunit,
        CODEUNIT::"OCR - Receive from Service",DummyRecId);
    END;

    [External]
    PROCEDURE ScheduleJobQueueSync@6();
    VAR
      OCRSyncMasterData@1001 : Codeunit 882;
    BEGIN
      OCRSyncMasterData.ScheduleJob;
    END;

    LOCAL PROCEDURE CancelJobQueueEntries@11();
    BEGIN
      CancelJobQueueReceive;
      CancelJobQueueSend;
      CancelJobQueueSync;
    END;

    LOCAL PROCEDURE CancelJobQueueEntry@16(ObjType@1001 : Option;ObjID@1002 : Integer);
    VAR
      JobQueueEntry@1000 : Record 472;
    BEGIN
      IF JobQueueEntry.FindJobQueueEntry(ObjType,ObjID) THEN
        JobQueueEntry.Cancel;
    END;

    [External]
    PROCEDURE CancelJobQueueSend@9();
    VAR
      JobQueueEntry@1000 : Record 472;
    BEGIN
      CancelJobQueueEntry(JobQueueEntry."Object Type to Run"::Codeunit,
        CODEUNIT::"OCR - Send to Service");
    END;

    [External]
    PROCEDURE CancelJobQueueReceive@12();
    VAR
      JobQueueEntry@1000 : Record 472;
    BEGIN
      CancelJobQueueEntry(JobQueueEntry."Object Type to Run"::Codeunit,
        CODEUNIT::"OCR - Receive from Service");
    END;

    [External]
    PROCEDURE CancelJobQueueSync@15();
    VAR
      OCRSyncMasterData@1000 : Codeunit 882;
    BEGIN
      OCRSyncMasterData.CancelJob;
    END;

    [External]
    PROCEDURE ShowJobQueueEntry@8();
    VAR
      JobQueueEntry@1000 : Record 472;
    BEGIN
      JobQueueEntry.SETRANGE("Object Type to Run",JobQueueEntry."Object Type to Run"::Codeunit);
      JobQueueEntry.SETFILTER("Object ID to Run",'%1|%2|%3',
        CODEUNIT::"OCR - Send to Service",
        CODEUNIT::"OCR - Receive from Service",
        CODEUNIT::"OCR - Sync Master Data");
      IF JobQueueEntry.FINDFIRST THEN
        PAGE.RUN(PAGE::"Job Queue Entries",JobQueueEntry);
    END;

    BEGIN
    END.
  }
}

