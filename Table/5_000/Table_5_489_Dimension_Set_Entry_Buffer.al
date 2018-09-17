OBJECT Table 5489 Dimension Set Entry Buffer
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
               UpdateIntegrationIds;
             END;

    OnModify=BEGIN
               UpdateIntegrationIds;
             END;

    OnDelete=BEGIN
               UpdateIntegrationIds;
             END;

    OnRename=BEGIN
               UpdateIntegrationIds;
             END;

    CaptionML=[DAN=Dimensionsgruppeposts buffer;
               ENU=Dimension Set Entry Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Dimension Set ID    ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dimensionsgruppe-id;
                                                              ENU=Dimension Set ID] }
    { 2   ;   ;Dimension Code      ;Code20        ;TableRelation=Dimension;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dimensionskode;
                                                              ENU=Dimension Code];
                                                   NotBlank=Yes }
    { 3   ;   ;Dimension Value Code;Code20        ;TableRelation="Dimension Value".Code WHERE (Dimension Code=FIELD(Dimension Code));
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dimensionsv�rdikode;
                                                              ENU=Dimension Value Code];
                                                   NotBlank=Yes }
    { 4   ;   ;Dimension Value ID  ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dimensionsv�rdi-id;
                                                              ENU=Dimension Value ID] }
    { 5   ;   ;Dimension Name      ;Text30        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Dimension.Name WHERE (Code=FIELD(Dimension Code)));
                                                   CaptionML=[DAN=Dimensionsnavn;
                                                              ENU=Dimension Name];
                                                   Editable=No }
    { 6   ;   ;Dimension Value Name;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Dimension Value".Name WHERE (Dimension Code=FIELD(Dimension Code),
                                                                                                    Code=FIELD(Dimension Value Code)));
                                                   CaptionML=[DAN=Dimensionsv�rdinavn;
                                                              ENU=Dimension Value Name];
                                                   Editable=No }
    { 8000;   ;Dimension Id        ;GUID          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dimensions-id;
                                                              ENU=Dimension Id] }
    { 8001;   ;Value Id            ;GUID          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=V�rdi-id;
                                                              ENU=Value Id] }
    { 8002;   ;Parent Id           ;GUID          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Id for overordnet;
                                                              ENU=Parent Id] }
  }
  KEYS
  {
    {    ;Parent Id,Dimension Id                  ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      IdOrCodeShouldBeFilledErr@1001 : TextConst '@@@={Locked};DAN=The ID or Code field must be filled in.;ENU=The ID or Code field must be filled in.';
      ValueIdOrValueCodeShouldBeFilledErr@1000 : TextConst '@@@={Locked};DAN=The valueID or valueCode field must be filled in.;ENU=The valueID or valueCode field must be filled in.';

    LOCAL PROCEDURE UpdateIntegrationIds@1();
    VAR
      Dimension@1000 : Record 348;
      DimensionValue@1001 : Record 349;
    BEGIN
      IF ISNULLGUID("Dimension Id") THEN BEGIN
        IF "Dimension Code" = '' THEN
          ERROR(IdOrCodeShouldBeFilledErr);
        Dimension.GET("Dimension Code");
        "Dimension Id" := Dimension.Id;
      END;

      IF ISNULLGUID("Value Id") THEN BEGIN
        IF "Dimension Value Code" = '' THEN
          ERROR(ValueIdOrValueCodeShouldBeFilledErr);
        DimensionValue.GET("Dimension Code","Dimension Value Code");
        "Value Id" := DimensionValue.Id;
      END;
    END;

    BEGIN
    END.
  }
}

