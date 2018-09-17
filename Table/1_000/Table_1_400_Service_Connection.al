OBJECT Table 1400 Service Connection
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Serviceforbindelse;
               ENU=Service Connection];
  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Text250       ;CaptionML=[DAN=Nr.;
                                                              ENU=No.] }
    { 2   ;   ;Record ID           ;RecordID      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Record-id;
                                                              ENU=Record ID] }
    { 3   ;   ;Name                ;Text250       ;CaptionML=[DAN=Navn;
                                                              ENU=Name] }
    { 4   ;   ;Host Name           ;Text250       ;CaptionML=[DAN=V�rtsnavn;
                                                              ENU=Host Name] }
    { 8   ;   ;Status              ;Option        ;CaptionML=[DAN=Status;
                                                              ENU=Status];
                                                   OptionCaptionML=[DAN=" ,Aktiveret,Deaktiveret,Forbindelse,Fejl";
                                                                    ENU=" ,Enabled,Disabled,Connected,Error"];
                                                   OptionString=[ ,Enabled,Disabled,Connected,Error] }
    { 10  ;   ;Page ID             ;Integer       ;CaptionML=[DAN=Side-id;
                                                              ENU=Page ID] }
    { 11  ;   ;Assisted Setup Page ID;Integer     ;CaptionML=[DAN=Id for side til assisteret ops�tning;
                                                              ENU=Assisted Setup Page ID] }
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

    [Integration]
    [External]
    PROCEDURE OnRegisterServiceConnection@1(VAR ServiceConnection@1000 : Record 1400);
    BEGIN
    END;

    [External]
    PROCEDURE InsertServiceConnection@4(VAR ServiceConnection@1003 : Record 1400;RecordID@1000 : RecordID;ServiceName@1001 : Text;HostName@1006 : Text;PageID@1004 : Integer);
    BEGIN
      InsertServiceConnectionExtended(ServiceConnection,RecordID,ServiceName,HostName,PageID,0);
    END;

    [External]
    PROCEDURE InsertServiceConnectionExtended@2(VAR ServiceConnection@1003 : Record 1400;RecordID@1000 : RecordID;ServiceName@1001 : Text;HostName@1006 : Text;PageID@1004 : Integer;AssistedSetupPageId@1002 : Integer);
    VAR
      ServiceConnectionOld@1005 : Record 1400;
    BEGIN
      ServiceConnection."Record ID" := RecordID;
      ServiceConnection."No." := FORMAT(RecordID);
      ServiceConnection.Name := COPYSTR(ServiceName,1,MAXSTRLEN(ServiceConnection.Name));
      ServiceConnection."Host Name" := COPYSTR(HostName,1,MAXSTRLEN(ServiceConnection."Host Name"));
      ServiceConnection."Page ID" := PageID;
      ServiceConnection."Assisted Setup Page ID" := AssistedSetupPageId;
      ServiceConnectionOld := ServiceConnection;
      IF NOT ServiceConnection.GET(ServiceConnection."No.") THEN BEGIN
        ServiceConnection := ServiceConnectionOld;
        ServiceConnection.INSERT(TRUE)
      END;
    END;

    BEGIN
    END.
  }
}

