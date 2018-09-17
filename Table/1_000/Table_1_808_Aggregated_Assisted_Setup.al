OBJECT Table 1808 Aggregated Assisted Setup
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Aggregeret assisteret ops�tning;
               ENU=Aggregated Assisted Setup];
  }
  FIELDS
  {
    { 1   ;   ;Page ID             ;Integer       ;CaptionML=[DAN=Side-id;
                                                              ENU=Page ID] }
    { 2   ;   ;Name                ;Text250       ;CaptionML=[DAN=Navn;
                                                              ENU=Name] }
    { 3   ;   ;Order               ;Integer       ;CaptionML=[DAN=R�kkef�lge;
                                                              ENU=Order] }
    { 4   ;   ;Status              ;Option        ;CaptionML=[DAN=Status;
                                                              ENU=Status];
                                                   OptionCaptionML=[DAN="Ikke afsluttet,Afsluttet,Ikke startet,Set,Overv�get,L�st, ";
                                                                    ENU="Not Completed,Completed,Not Started,Seen,Watched,Read, "];
                                                   OptionString=[Not Completed,Completed,Not Started,Seen,Watched,Read, ] }
    { 5   ;   ;Visible             ;Boolean       ;CaptionML=[DAN=Synlig;
                                                              ENU=Visible] }
    { 8   ;   ;Icon                ;Media         ;CaptionML=[DAN=Ikon;
                                                              ENU=Icon] }
    { 9   ;   ;Item Type           ;Option        ;InitValue=Setup and Help;
                                                   CaptionML=[DAN=Elementtype;
                                                              ENU=Item Type];
                                                   OptionCaptionML=[DAN=" ,Gruppe,Ops�tning og Hj�lp";
                                                                    ENU=" ,Group,Setup and Help"];
                                                   OptionString=[ ,Group,Setup and Help] }
    { 12  ;   ;Assisted Setup Page ID;Integer     ;CaptionML=[DAN=Id for side til assisteret ops�tning;
                                                              ENU=Assisted Setup Page ID] }
    { 17  ;   ;External Assisted Setup;Boolean    ;CaptionML=[DAN=Eksternt assisteret ops�tning;
                                                              ENU=External Assisted Setup] }
    { 18  ;   ;Record ID           ;RecordID      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Record-id;
                                                              ENU=Record ID] }
  }
  KEYS
  {
    {    ;Page ID                                 ;Clustered=Yes }
    {    ;External Assisted Setup,Order,Visible    }
  }
  FIELDGROUPS
  {
    { 1   ;Brick               ;Name,Status,Icon                         }
  }
  CODE
  {
    VAR
      RunSetupAgainQst@1001 : TextConst '@@@="%1 = Assisted Setup Name";DAN=Du har allerede fuldf�rt den assisterende ops�tningsvejledning for %1. Vil du k�re den igen?;ENU=You have already completed the %1 assisted setup guide. Do you want to run it again?';

    [External]
    PROCEDURE RunAssistedSetup@4();
    VAR
      AssistedSetup@1000 : Record 1803;
    BEGIN
      IF "Item Type" <> "Item Type"::"Setup and Help" THEN
        EXIT;

      IF Status = Status::Completed THEN
        CASE "Page ID" OF
          PAGE::"Assisted Company Setup Wizard":
            AssistedSetup.HandleOpenCompletedAssistedCompanySetupWizard;
          ELSE
            IF NOT CONFIRM(RunSetupAgainQst,FALSE,Name) THEN
              EXIT;
        END;

      PAGE.RUNMODAL("Assisted Setup Page ID");
      OnUpdateAssistedSetupStatus(Rec);
    END;

    [External]
    PROCEDURE AddExtensionAssistedSetup@24(PageID@1007 : Integer;AssistantName@1006 : Text[250];AssistantVisible@1004 : Boolean;AssistedSetupRecordID@1001 : RecordID;AssistedSetupStatus@1000 : Option;AssistedSetupIconCode@1002 : Code[50]);
    VAR
      AssistedSetupIcons@1003 : Record 1810;
    BEGIN
      IF NOT GET(PageID) THEN BEGIN
        CLEAR(Rec);
        "Page ID" := PageID;
        Visible := AssistantVisible;
        INSERT(TRUE);
      END;

      "Page ID" := PageID;
      Name := AssistantName;
      Order := GetNextSortingOrder;
      "Item Type" := "Item Type"::"Setup and Help";

      "Assisted Setup Page ID" := PageID;
      "External Assisted Setup" := TRUE;
      "Record ID" := AssistedSetupRecordID;
      Status := AssistedSetupStatus;

      IF AssistedSetupIcons.GET(AssistedSetupIconCode) THEN
        Icon := AssistedSetupIcons.Image;

      MODIFY(TRUE);
    END;

    [External]
    PROCEDURE InsertAssistedSetupIcon@5(AssistedSetupIconCode@1003 : Code[50];IconInStream@1000 : InStream);
    VAR
      AssistedSetupIcons@1002 : Record 1810;
    BEGIN
      IF NOT AssistedSetupIcons.GET(AssistedSetupIconCode) THEN BEGIN
        AssistedSetupIcons.INIT;
        AssistedSetupIcons."No." := AssistedSetupIconCode;
        AssistedSetupIcons.Image.IMPORTSTREAM(IconInStream,AssistedSetupIconCode);
        AssistedSetupIcons.INSERT(TRUE);
      END ELSE BEGIN
        AssistedSetupIcons.Image.IMPORTSTREAM(IconInStream,AssistedSetupIconCode);
        AssistedSetupIcons.MODIFY(TRUE);
      END;
    END;

    [Integration]
    [External]
    PROCEDURE OnRegisterAssistedSetup@13(VAR TempAggregatedAssistedSetup@1000 : TEMPORARY Record 1808);
    BEGIN
    END;

    [Integration]
    [External]
    PROCEDURE OnUpdateAssistedSetupStatus@8(VAR TempAggregatedAssistedSetup@1000 : TEMPORARY Record 1808);
    BEGIN
    END;

    LOCAL PROCEDURE GetNextSortingOrder@35() SortingOrder : Integer;
    VAR
      AssistedSetup@1000 : Record 1803;
    BEGIN
      SortingOrder := 1;

      AssistedSetup.SETCURRENTKEY(Order);
      IF AssistedSetup.FINDLAST THEN
        SortingOrder := AssistedSetup.Order + 1;
    END;

    [External]
    PROCEDURE SetStatus@3(VAR TempAggregatedAssistedSetup@1002 : TEMPORARY Record 1808;EntryId@1000 : Integer;ItemStatus@1001 : Option);
    BEGIN
      TempAggregatedAssistedSetup.GET(EntryId);
      TempAggregatedAssistedSetup.Status := ItemStatus;
      TempAggregatedAssistedSetup.MODIFY;
    END;

    BEGIN
    END.
  }
}

