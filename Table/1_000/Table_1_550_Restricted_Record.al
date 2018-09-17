OBJECT Table 1550 Restricted Record
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Begr‘nset record;
               ENU=Restricted Record];
  }
  FIELDS
  {
    { 1   ;   ;ID                  ;BigInteger    ;AutoIncrement=Yes;
                                                   CaptionML=[DAN=Id;
                                                              ENU=ID] }
    { 2   ;   ;Record ID           ;RecordID      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Record-id;
                                                              ENU=Record ID] }
    { 3   ;   ;Details             ;Text250       ;CaptionML=[DAN=Detaljer;
                                                              ENU=Details] }
  }
  KEYS
  {
    {    ;ID                                      ;Clustered=Yes }
    {    ;Record ID                                }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    [Internal]
    PROCEDURE ShowRecord@1();
    VAR
      PageManagement@1001 : Codeunit 700;
      RecRef@1000 : RecordRef;
    BEGIN
      IF NOT RecRef.GET("Record ID") THEN
        EXIT;
      PageManagement.PageRun(RecRef);
    END;

    BEGIN
    END.
  }
}

