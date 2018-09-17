OBJECT Table 1314 User Tours
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
    CaptionML=[DAN=Brugerguider;
               ENU=User Tours];
  }
  FIELDS
  {
    { 1   ;   ;User ID             ;Text132       ;DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID];
                                                   Editable=No }
    { 3   ;   ;Tour ID             ;Integer       ;CaptionML=[DAN=Guide-id;
                                                              ENU=Tour ID] }
    { 4   ;   ;Status              ;Option        ;CaptionML=[DAN=Status;
                                                              ENU=Status];
                                                   OptionCaptionML=[DAN=Ingen,Startet,Fuldf›rt,Udl›bet;
                                                                    ENU=None,Started,Completed,Expired];
                                                   OptionString=None,Started,Completed,Expired }
    { 5   ;   ;Version             ;Text163       ;CaptionML=[DAN=Version;
                                                              ENU=Version] }
  }
  KEYS
  {
    {    ;User ID,Tour ID                         ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    LOCAL PROCEDURE GetStatus@3(TourID@1000 : Integer) : Integer;
    BEGIN
      IF NOT GET(USERID,TourID) THEN
        EXIT(Status::None);

      IF Version = GetVersion THEN
        EXIT(Status);

      EXIT(Status::Expired);
    END;

    LOCAL PROCEDURE SetStatus@8(TourID@1000 : Integer;NewStatus@1001 : Option);
    BEGIN
      IF NOT GET(USERID,TourID) THEN BEGIN
        INIT;
        "User ID" := USERID;
        "Tour ID" := TourID;
        INSERT;
      END;

      Status := NewStatus;
      Version := COPYSTR(GetVersion,1,MAXSTRLEN(Version));
      MODIFY;
    END;

    [External]
    PROCEDURE AlreadyCompleted@6(TourID@1000 : Integer) : Boolean;
    BEGIN
      EXIT(GetStatus(TourID) = Status::Completed);
    END;

    [External]
    PROCEDURE MarkAsCompleted@5(TourID@1000 : Integer);
    BEGIN
      SetStatus(TourID,Status::Completed);
    END;

    LOCAL PROCEDURE GetVersion@2() : Text;
    VAR
      ApplicationManagement@1000 : Codeunit 1;
    BEGIN
      EXIT(STRSUBSTNO('%1 (%2)',ApplicationManagement.ApplicationVersion,ApplicationManagement.ApplicationBuild));
    END;

    BEGIN
    END.
  }
}

