OBJECT Table 5334 CRM Option Mapping
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=CRM-felttilknytning;
               ENU=CRM Option Mapping];
  }
  FIELDS
  {
    { 1   ;   ;Record ID           ;RecordID      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Record-id;
                                                              ENU=Record ID] }
    { 2   ;   ;Option Value        ;Integer       ;CaptionML=[DAN=Indstillingsv‘rdi;
                                                              ENU=Option Value] }
    { 3   ;   ;Table ID            ;Integer       ;CaptionML=[DAN=Tabel-id;
                                                              ENU=Table ID] }
    { 4   ;   ;Integration Table ID;Integer       ;CaptionML=[DAN=Integrationstabel-id;
                                                              ENU=Integration Table ID] }
    { 5   ;   ;Integration Field ID;Integer       ;CaptionML=[DAN=Integrationsfelt-id;
                                                              ENU=Integration Field ID] }
    { 6   ;   ;Option Value Caption;Text250       ;CaptionML=[DAN=Indstillingsv‘rdititel;
                                                              ENU=Option Value Caption] }
  }
  KEYS
  {
    {    ;Record ID                               ;Clustered=Yes }
    {    ;Integration Table ID,Integration Field ID,Option Value }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    [External]
    PROCEDURE FindRecordID@1(IntegrationTableID@1001 : Integer;IntegrationFieldID@1002 : Integer;OptionValue@1003 : Integer) : Boolean;
    BEGIN
      RESET;
      SETRANGE("Integration Table ID",IntegrationTableID);
      SETRANGE("Integration Field ID",IntegrationFieldID);
      SETRANGE("Option Value",OptionValue);
      EXIT(FINDFIRST);
    END;

    [External]
    PROCEDURE GetRecordKeyValue@2() : Text;
    VAR
      FieldRef@1001 : FieldRef;
      KeyRef@1002 : KeyRef;
      RecordRef@1000 : RecordRef;
    BEGIN
      RecordRef.GET("Record ID");
      KeyRef := RecordRef.KEYINDEX(1);
      FieldRef := KeyRef.FIELDINDEX(1);
      EXIT(FORMAT(FieldRef.VALUE));
    END;

    BEGIN
    END.
  }
}

