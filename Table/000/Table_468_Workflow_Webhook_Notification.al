OBJECT Table 468 Workflow Webhook Notification
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
               "Date-Time Created" := CREATEDATETIME(TODAY,TIME);
               "Created By User ID" := USERID;
             END;

    CaptionML=[DAN=Notifikation om webhook-workflow;
               ENU=Workflow Webhook Notification];
  }
  FIELDS
  {
    { 1   ;   ;Notification No.    ;Integer       ;AutoIncrement=Yes;
                                                   CaptionML=[DAN=Notifikationsnr.;
                                                              ENU=Notification No.] }
    { 2   ;   ;Workflow Step Instance ID;GUID     ;CaptionML=[DAN=Id for workflowtrininstans;
                                                              ENU=Workflow Step Instance ID] }
    { 3   ;   ;Date-Time Created   ;DateTime      ;CaptionML=[DAN=Oprettet dato/klokkesl‘t;
                                                              ENU=Date-Time Created] }
    { 4   ;   ;Created By User ID  ;Code50        ;DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Oprettet af bruger-id;
                                                              ENU=Created By User ID] }
    { 5   ;   ;Status              ;Option        ;CaptionML=[DAN=Status;
                                                              ENU=Status];
                                                   OptionCaptionML=[DAN=Ventende,Sendt,Mislykkedes;
                                                                    ENU=Pending,Sent,Failed];
                                                   OptionString=Pending,Sent,Failed }
    { 6   ;   ;Error Message       ;Text250       ;CaptionML=[DAN=Fejlmeddelelse;
                                                              ENU=Error Message] }
    { 7   ;   ;Error Details       ;BLOB          ;CaptionML=[DAN=Fejldetaljer;
                                                              ENU=Error Details] }
  }
  KEYS
  {
    {    ;Notification No.                        ;Clustered=Yes }
    {    ;Workflow Step Instance ID                }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    PROCEDURE GetErrorDetails@6() : Text;
    VAR
      ReadStream@1000 : InStream;
      ReturnText@1002 : Text;
    BEGIN
      CALCFIELDS("Error Details");
      "Error Details".CREATEINSTREAM(ReadStream);
      ReadStream.READTEXT(ReturnText);
      EXIT(ReturnText);
    END;

    PROCEDURE SetErrorDetails@7(ErrorDetails@1000 : Text);
    VAR
      OutStream@1001 : OutStream;
    BEGIN
      "Error Details".CREATEOUTSTREAM(OutStream);
      OutStream.WRITE(ErrorDetails);
    END;

    PROCEDURE SetErrorMessage@5(ErrorMessage@1000 : Text);
    BEGIN
      IF STRLEN(ErrorMessage) > 250 THEN
        "Error Message" := PADSTR(ErrorMessage,250)
      ELSE
        "Error Message" := COPYSTR(ErrorMessage,1,STRLEN(ErrorMessage));
    END;

    BEGIN
    END.
  }
}

