OBJECT Table 1306 User Preference
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Brugerpr‘ference;
               ENU=User Preference];
  }
  FIELDS
  {
    { 1   ;   ;User ID             ;Text132       ;DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID];
                                                   Editable=No }
    { 2   ;   ;Instruction Code    ;Code50        ;CaptionML=[DAN=Instruktionskode;
                                                              ENU=Instruction Code] }
    { 3   ;   ;User Selection      ;BLOB          ;CaptionML=[DAN=Brugervalg;
                                                              ENU=User Selection] }
  }
  KEYS
  {
    {    ;User ID,Instruction Code                ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    [External]
    PROCEDURE DisableInstruction@1(InstrCode@1000 : Code[50]);
    VAR
      UserPreference@1001 : Record 1306;
    BEGIN
      IF NOT UserPreference.GET(USERID,InstrCode) THEN BEGIN
        UserPreference.INIT;
        UserPreference."User ID" := USERID;
        UserPreference."Instruction Code" := InstrCode;
        UserPreference.INSERT;
      END;
    END;

    [External]
    PROCEDURE EnableInstruction@2(InstrCode@1000 : Code[50]);
    VAR
      UserPreference@1001 : Record 1306;
    BEGIN
      IF UserPreference.GET(USERID,InstrCode) THEN
        UserPreference.DELETE;
    END;

    [External]
    PROCEDURE GetUserSelectionAsText@4() ReturnValue : Text;
    VAR
      Instream@1000 : InStream;
    BEGIN
      "User Selection".CREATEINSTREAM(Instream);
      Instream.READTEXT(ReturnValue);
    END;

    [External]
    PROCEDURE SetUserSelection@6(Variant@1000 : Variant);
    VAR
      OutStream@1001 : OutStream;
    BEGIN
      "User Selection".CREATEOUTSTREAM(OutStream);
      OutStream.WRITETEXT(FORMAT(Variant));
    END;

    BEGIN
    END.
  }
}

