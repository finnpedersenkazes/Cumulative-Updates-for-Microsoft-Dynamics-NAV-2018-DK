OBJECT Table 1798 Data Migration Parameters
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Dataoverf›rselsparametre;
               ENU=Data Migration Parameters];
  }
  FIELDS
  {
    { 1   ;   ;Key                 ;Integer       ;AutoIncrement=Yes;
                                                   CaptionML=[DAN=N›gle;
                                                              ENU=Key] }
    { 2   ;   ;Migration Type      ;Text250       ;CaptionML=[DAN=Overf›rselstype;
                                                              ENU=Migration Type] }
    { 3   ;   ;Staging Table Migr. Codeunit;Integer;
                                                   CaptionML=[DAN=Overf›rsels-codeunit for stadieinddelingstabel;
                                                              ENU=Staging Table Migr. Codeunit] }
    { 4   ;   ;Staging Table RecId To Process;RecordID;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Record-id for stadieinddelingstabel til behandling;
                                                              ENU=Staging Table RecId To Process] }
  }
  KEYS
  {
    {    ;Key                                     ;Clustered=Yes }
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

