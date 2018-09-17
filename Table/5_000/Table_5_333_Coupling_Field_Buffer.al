OBJECT Table 5333 Coupling Field Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Sammenk‘dningsfeltbuffer;
               ENU=Coupling Field Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Field Name          ;Text50        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Feltnavn;
                                                              ENU=Field Name] }
    { 3   ;   ;Value               ;Text250       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=V‘rdi;
                                                              ENU=Value] }
    { 4   ;   ;Integration Value   ;Text250       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Integrationsv‘rdi;
                                                              ENU=Integration Value] }
    { 6   ;   ;Direction           ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Retning;
                                                              ENU=Direction];
                                                   OptionCaptionML=[DAN=Begge retninger,TilIntegrationstabel,FraIntegrationstabel;
                                                                    ENU=Bidirectional,ToIntegrationTable,FromIntegrationTable];
                                                   OptionString=Bidirectional,ToIntegrationTable,FromIntegrationTable }
    { 8   ;   ;Validate Field      ;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Valider felt;
                                                              ENU=Validate Field] }
  }
  KEYS
  {
    {    ;Field Name                              ;Clustered=Yes }
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

