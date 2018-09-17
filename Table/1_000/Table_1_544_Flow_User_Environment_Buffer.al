OBJECT Table 1544 Flow User Environment Buffer
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
    CaptionML=[DAN=Flow-buffer for brugermilj›;
               ENU=Flow User Environment Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Environment ID      ;Text50        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Milj›-id;
                                                              ENU=Environment ID] }
    { 2   ;   ;Environment Display Name;Text100   ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Visningsnavn for milj›;
                                                              ENU=Environment Display Name] }
    { 3   ;   ;Default             ;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Standard;
                                                              ENU=Default] }
    { 4   ;   ;Enabled             ;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Aktiveret;
                                                              ENU=Enabled] }
  }
  KEYS
  {
    {    ;Environment ID                          ;Clustered=Yes }
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

