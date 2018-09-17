OBJECT Table 1275 Doc. Exch. Service Setup
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
             END;

    OnDelete=BEGIN
               DeletePassword("Consumer Secret");
               DeletePassword("Consumer Key");
               DeletePassword(Token);
               DeletePassword("Token Secret");
               DeletePassword("Doc. Exch. Tenant ID");
             END;

    CaptionML=[DAN=Ops‘tning af dok.udv.tjen.;
               ENU=Doc. Exch. Service Setup];
  }
  FIELDS
  {
    { 1   ;   ;Primary Key         ;Code10        ;CaptionML=[DAN=Prim‘rn›gle;
                                                              ENU=Primary Key] }
    { 4   ;   ;Sign-up URL         ;Text250       ;ExtendedDatatype=URL;
                                                   CaptionML=[DAN=URL-adresse til tilmelding;
                                                              ENU=Sign-up URL] }
    { 5   ;   ;Service URL         ;Text250       ;OnValidate=VAR
                                                                WebRequestHelper@1000 : Codeunit 1299;
                                                              BEGIN
                                                                IF "Service URL" <> '' THEN
                                                                  WebRequestHelper.IsSecureHttpUrl("Service URL");
                                                              END;

                                                   ExtendedDatatype=URL;
                                                   CaptionML=[DAN=URL-adresse til tjeneste;
                                                              ENU=Service URL] }
    { 6   ;   ;Sign-in URL         ;Text250       ;ExtendedDatatype=URL;
                                                   CaptionML=[DAN=URL-adresse til p†logning;
                                                              ENU=Sign-in URL] }
    { 7   ;   ;Consumer Key        ;GUID          ;TableRelation="Service Password".Key;
                                                   CaptionML=[DAN=Forbrugern›gle;
                                                              ENU=Consumer Key] }
    { 8   ;   ;Consumer Secret     ;GUID          ;CaptionML=[DAN=Forbrugerhemmelighed;
                                                              ENU=Consumer Secret];
                                                   Editable=No }
    { 9   ;   ;Token               ;GUID          ;CaptionML=[DAN=Token;
                                                              ENU=Token];
                                                   Editable=No }
    { 10  ;   ;Token Secret        ;GUID          ;CaptionML=[DAN=Tokenhemmelighed;
                                                              ENU=Token Secret];
                                                   Editable=No }
    { 11  ;   ;Doc. Exch. Tenant ID;GUID          ;DataClassification=OrganizationIdentifiableInformation;
                                                   CaptionML=[DAN=Lejer-id for dok.udv.;
                                                              ENU=Doc. Exch. Tenant ID];
                                                   Editable=No }
    { 12  ;   ;User Agent          ;Text30        ;DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Brugeragent;
                                                              ENU=User Agent];
                                                   NotBlank=Yes }
    { 20  ;   ;Enabled             ;Boolean       ;OnValidate=BEGIN
                                                                IF Enabled THEN BEGIN
                                                                  CheckConnection;
                                                                  ScheduleJobQueueEntries;
                                                                  IF CONFIRM(JobQEntriesCreatedQst) THEN
                                                                    ShowJobQueueEntry;
                                                                END ELSE
                                                                  CancelJobQueueEntries;
                                                              END;

                                                   CaptionML=[DAN=Aktiveret;
                                                              ENU=Enabled] }
    { 21  ;   ;Log Web Requests    ;Boolean       ;CaptionML=[DAN=Logf›r webanmodninger;
                                                              ENU=Log Web Requests] }
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
      JobQEntriesCreatedQst@1003 : TextConst 'DAN=Der er oprettet en opgavek›post til udveksling af dokumenter.\\Vil du †bne vinduet Opgavek›poster?;ENU=A job queue entry for exchanging documents has been created.\\Do you want to open the Job Queue Entries window?';
      DocExchServiceMgt@1002 : Codeunit 1410;

    [External]
    PROCEDURE SavePassword@1(VAR PasswordKey@1001 : GUID;PasswordText@1000 : Text);
    VAR
      ServicePassword@1002 : Record 1261;
    BEGIN
      PasswordText := DELCHR(PasswordText,'=',' ');

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
    BEGIN
      DocExchServiceMgt.SetURLsToDefault(Rec);
    END;

    [Internal]
    PROCEDURE CheckConnection@7();
    BEGIN
      DocExchServiceMgt.CheckConnection;
    END;

    LOCAL PROCEDURE ScheduleJobQueueEntries@10();
    VAR
      JobQueueEntry@1000 : Record 472;
      DummyRecId@1001 : RecordID;
    BEGIN
      JobQueueEntry.ScheduleRecurrentJobQueueEntry(JobQueueEntry."Object Type to Run"::Codeunit,
        CODEUNIT::"Doc. Exch. Serv.- Doc. Status",DummyRecId);
      JobQueueEntry.ScheduleRecurrentJobQueueEntry(JobQueueEntry."Object Type to Run"::Codeunit,
        CODEUNIT::"Doc. Exch. Serv. - Recv. Docs.",DummyRecId);
    END;

    LOCAL PROCEDURE CancelJobQueueEntries@11();
    VAR
      JobQueueEntry@1000 : Record 472;
    BEGIN
      CancelJobQueueEntry(JobQueueEntry."Object Type to Run"::Codeunit,
        CODEUNIT::"Doc. Exch. Serv.- Doc. Status");
      CancelJobQueueEntry(JobQueueEntry."Object Type to Run"::Codeunit,
        CODEUNIT::"Doc. Exch. Serv. - Recv. Docs.");
    END;

    LOCAL PROCEDURE CancelJobQueueEntry@16(ObjType@1001 : Option;ObjID@1002 : Integer);
    VAR
      JobQueueEntry@1000 : Record 472;
    BEGIN
      IF JobQueueEntry.FindJobQueueEntry(ObjType,ObjID) THEN
        JobQueueEntry.Cancel;
    END;

    [External]
    PROCEDURE ShowJobQueueEntry@8();
    VAR
      JobQueueEntry@1000 : Record 472;
    BEGIN
      JobQueueEntry.SETRANGE("Object Type to Run",JobQueueEntry."Object Type to Run"::Codeunit);
      JobQueueEntry.SETFILTER("Object ID to Run",'%1|%2',
        CODEUNIT::"Doc. Exch. Serv.- Doc. Status",
        CODEUNIT::"Doc. Exch. Serv. - Recv. Docs.");
      IF JobQueueEntry.FINDFIRST THEN
        PAGE.RUN(PAGE::"Job Queue Entries",JobQueueEntry);
    END;

    BEGIN
    END.
  }
}

