OBJECT Table 7828 MS-QBO Sync Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=MS QBO-synk.buffer;
               ENU=MS-QBO Sync Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Id                  ;BigInteger    ;AutoIncrement=Yes;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Id;
                                                              ENU=Id] }
    { 2   ;   ;Record Id           ;RecordID      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Record-id;
                                                              ENU=Record Id] }
  }
  KEYS
  {
    {    ;Id                                      ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    PROCEDURE InsertNew@1(RecordId@1000 : RecordID);
    BEGIN
      RESET;
      IF Exists(RecordId) THEN
        EXIT;
      INIT;
      "Record Id" := RecordId;
      INSERT;
    END;

    PROCEDURE Exists@2(RecordIdToFind@1000 : RecordID) : Boolean;
    BEGIN
      SETRANGE("Record Id",RecordIdToFind);
      EXIT(FINDFIRST);
    END;

    BEGIN
    END.
  }
}

