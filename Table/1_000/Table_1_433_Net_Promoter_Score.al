OBJECT Table 1433 Net Promoter Score
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    DataPerCompany=No;
    CaptionML=[DAN=Net Promoter Score;
               ENU=Net Promoter Score];
  }
  FIELDS
  {
    { 1   ;   ;User SID            ;GUID          ;DataClassification=EndUserPseudonymousIdentifiers;
                                                   CaptionML=[DAN=Bruger-SID;
                                                              ENU=User SID] }
    { 4   ;   ;Last Request Time   ;DateTime      ;CaptionML=[DAN=Kl. for seneste anmodning;
                                                              ENU=Last Request Time] }
    { 5   ;   ;Send Request        ;Boolean       ;CaptionML=[DAN=Send anmodning;
                                                              ENU=Send Request] }
  }
  KEYS
  {
    {    ;User SID                                ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    [External]
    PROCEDURE UpdateRequestSendingStatus@1();
    VAR
      NetPromoterScoreMgt@1003 : Codeunit 1432;
    BEGIN
      IF NOT NetPromoterScoreMgt.IsNpsSupported THEN
        EXIT;

      IF NOT GET(USERSECURITYID) THEN BEGIN
        INIT;
        "User SID" := USERSECURITYID;
        "Last Request Time" := CURRENTDATETIME;
        "Send Request" := TRUE;
        INSERT;
      END ELSE BEGIN
        "Last Request Time" := CURRENTDATETIME;
        "Send Request" := TRUE;
        MODIFY;
      END;
    END;

    [External]
    PROCEDURE DisableRequestSending@2();
    VAR
      NetPromoterScoreMgt@1000 : Codeunit 1432;
    BEGIN
      IF NOT NetPromoterScoreMgt.IsNpsSupported THEN
        EXIT;

      IF NOT GET(USERSECURITYID) THEN
        EXIT;

      "Send Request" := FALSE;
      MODIFY;
    END;

    [External]
    PROCEDURE ShouldSendRequest@3() : Boolean;
    BEGIN
      IF NOT GET(USERSECURITYID) THEN
        EXIT(TRUE);

      EXIT("Send Request");
    END;

    BEGIN
    END.
  }
}

