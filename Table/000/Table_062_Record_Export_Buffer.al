OBJECT Table 62 Record Export Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Recordeksportbuffer;
               ENU=Record Export Buffer];
  }
  FIELDS
  {
    { 1   ;   ;ID                  ;Integer       ;AutoIncrement=Yes;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Id;
                                                              ENU=ID] }
    { 2   ;   ;RecordID            ;RecordID      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=RecordID;
                                                              ENU=RecordID] }
    { 3   ;   ;ServerFilePath      ;Text250       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=ServerFilePath;
                                                              ENU=ServerFilePath] }
    { 4   ;   ;ClientFileName      ;Text250       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=ClientFileName;
                                                              ENU=ClientFileName] }
    { 5   ;   ;ZipFileName         ;Text250       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=ZipFileName;
                                                              ENU=ZipFileName] }
  }
  KEYS
  {
    {    ;ID                                      ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    BEGIN
    END.
  }
}

