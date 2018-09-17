OBJECT Table 1430 Role Center Notifications
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
    CaptionML=[DAN=Notifikationer for rollecenter;
               ENU=Role Center Notifications];
  }
  FIELDS
  {
    { 1   ;   ;User SID            ;GUID          ;DataClassification=EndUserPseudonymousIdentifiers;
                                                   CaptionML=[DAN=Bruger-SID;
                                                              ENU=User SID] }
    { 2   ;   ;First Session ID    ;Integer       ;CaptionML=[DAN=F›rste sessions-id;
                                                              ENU=First Session ID] }
    { 3   ;   ;Last Session ID     ;Integer       ;CaptionML=[DAN=Sidste sessions-id;
                                                              ENU=Last Session ID] }
    { 4   ;   ;Evaluation Notification State;Option;
                                                   CaptionML=[DAN=Notifikationstilstand for vurdering;
                                                              ENU=Evaluation Notification State];
                                                   OptionCaptionML=[DAN=Deaktiveret,Aktiveret,Klikket;
                                                                    ENU=Disabled,Enabled,Clicked];
                                                   OptionString=Disabled,Enabled,Clicked }
    { 5   ;   ;Buy Notification State;Option      ;CaptionML=[DAN=K›bsnotifikationstilstand;
                                                              ENU=Buy Notification State];
                                                   OptionCaptionML=[DAN=Deaktiveret,Aktiveret,Klikket;
                                                                    ENU=Disabled,Enabled,Clicked];
                                                   OptionString=Disabled,Enabled,Clicked }
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
    PROCEDURE Initialize@1();
    BEGIN
      IF NOT GET(USERSECURITYID) THEN BEGIN
        INIT;
        "User SID" := USERSECURITYID;
        "First Session ID" := SESSIONID;
        "Last Session ID" := SESSIONID;
        "Evaluation Notification State" := "Evaluation Notification State"::Enabled;
        "Buy Notification State" := "Buy Notification State"::Disabled;
        INSERT;
      END ELSE
        IF SESSIONID <> "Last Session ID" THEN BEGIN
          "Last Session ID" := SESSIONID;
          "Evaluation Notification State" := "Evaluation Notification State"::Enabled;
          "Buy Notification State" := "Buy Notification State"::Enabled;
          MODIFY;
        END;
    END;

    [External]
    PROCEDURE IsFirstLogon@2() : Boolean;
    BEGIN
      Initialize;
      EXIT(SESSIONID = "First Session ID");
    END;

    [External]
    PROCEDURE GetEvaluationNotificationState@4() : Integer;
    BEGIN
      IF GET(USERSECURITYID) THEN
        EXIT("Evaluation Notification State");
      EXIT("Evaluation Notification State"::Disabled);
    END;

    [External]
    PROCEDURE SetEvaluationNotificationState@3(NewState@1000 : Option);
    BEGIN
      IF GET(USERSECURITYID) THEN BEGIN
        "Evaluation Notification State" := NewState;
        MODIFY;
      END;
    END;

    [External]
    PROCEDURE GetBuyNotificationState@7() : Integer;
    BEGIN
      IF GET(USERSECURITYID) THEN
        EXIT("Buy Notification State");
      EXIT("Buy Notification State"::Disabled);
    END;

    [External]
    PROCEDURE SetBuyNotificationState@6(NewState@1000 : Option);
    BEGIN
      IF GET(USERSECURITYID) THEN BEGIN
        "Buy Notification State" := NewState;
        MODIFY;
      END;
    END;

    BEGIN
    END.
  }
}

