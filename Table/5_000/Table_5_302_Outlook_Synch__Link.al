OBJECT Table 5302 Outlook Synch. Link
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
               "Search Record ID" := FORMAT("Record ID");
             END;

    OnRename=BEGIN
               IF FORMAT("Record ID") <> FORMAT(xRec."Record ID") THEN
                 "Search Record ID" := FORMAT("Record ID");
             END;

    CaptionML=[DAN=Outlook-synkroniseringslink;
               ENU=Outlook Synch. Link];
  }
  FIELDS
  {
    { 1   ;   ;User ID             ;Code50        ;DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID];
                                                   NotBlank=Yes }
    { 2   ;   ;Record ID           ;RecordID      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Record-id;
                                                              ENU=Record ID] }
    { 3   ;   ;Outlook Entry ID    ;BLOB          ;CaptionML=[DAN=Outlook-post-id;
                                                              ENU=Outlook Entry ID] }
    { 4   ;   ;Outlook Entry ID Hash;Text32       ;CaptionML=[DAN=Outlook-post-id-hash;
                                                              ENU=Outlook Entry ID Hash] }
    { 5   ;   ;Search Record ID    ;Code250       ;CaptionML=[DAN=S›gerecord-id;
                                                              ENU=Search Record ID] }
    { 6   ;   ;Synchronization Date;DateTime      ;CaptionML=[DAN=Synkroniseringsdato;
                                                              ENU=Synchronization Date] }
  }
  KEYS
  {
    {    ;User ID,Record ID                       ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    [External]
    PROCEDURE GetEntryID@2(VAR EntryID@1001 : Text) : Boolean;
    VAR
      InStrm@1000 : InStream;
    BEGIN
      CALCFIELDS("Outlook Entry ID");
      "Outlook Entry ID".CREATEINSTREAM(InStrm);

      InStrm.READTEXT(EntryID);

      EXIT("Outlook Entry ID".HASVALUE);
    END;

    [Internal]
    PROCEDURE PutEntryID@7(EntryID@1000 : Text;OEntryIDHash@1002 : Text[32]) : Boolean;
    BEGIN
      "Outlook Entry ID Hash" := OEntryIDHash;
      FillEntryID(Rec,EntryID);
      MODIFY;
      EXIT("Outlook Entry ID".HASVALUE);
    END;

    [Internal]
    PROCEDURE InsertOSynchLink@12(UserID@1005 : Code[50];EntryID@1000 : Text;RecRef@1001 : RecordRef;OEntryIDHash@1006 : Text[32]);
    VAR
      RecID@1004 : RecordID;
    BEGIN
      EVALUATE(RecID,FORMAT(RecRef.RECORDID));
      IF GET(UserID,RecID) THEN
        EXIT;

      INIT;
      "User ID" := UserID;
      "Record ID" := RecID;
      "Search Record ID" := FORMAT(RecID);
      "Outlook Entry ID Hash" := OEntryIDHash;
      FillEntryID(Rec,EntryID);
      INSERT;
    END;

    LOCAL PROCEDURE FillEntryID@3(VAR OSynchLink@1001 : Record 5302;EntryID@1000 : Text);
    VAR
      OutStrm@1004 : OutStream;
    BEGIN
      OSynchLink."Outlook Entry ID".CREATEOUTSTREAM(OutStrm);
      OutStrm.WRITETEXT(EntryID);
    END;

    BEGIN
    END.
  }
}

