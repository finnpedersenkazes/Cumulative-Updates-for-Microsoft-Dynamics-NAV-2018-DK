OBJECT Table 360 Dimension Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Dimensionsbuffer;
               ENU=Dimension Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Table ID            ;Integer       ;TableRelation=AllObjWithCaption."Object ID" WHERE (Object Type=CONST(Table));
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Tabel-id;
                                                              ENU=Table ID] }
    { 2   ;   ;Entry No.           ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=L›benr.;
                                                              ENU=Entry No.] }
    { 3   ;   ;Dimension Code      ;Code20        ;TableRelation=Dimension;
                                                   OnValidate=BEGIN
                                                                IF NOT DimMgt.CheckDim("Dimension Code") THEN
                                                                  ERROR(DimMgt.GetDimErr);
                                                              END;

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dimensionskode;
                                                              ENU=Dimension Code];
                                                   NotBlank=Yes }
    { 4   ;   ;Dimension Value Code;Code20        ;TableRelation="Dimension Value".Code WHERE (Dimension Code=FIELD(Dimension Code));
                                                   OnValidate=BEGIN
                                                                IF NOT DimMgt.CheckDimValue("Dimension Code","Dimension Value Code") THEN
                                                                  ERROR(DimMgt.GetDimErr);
                                                              END;

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dimensionsv‘rdikode;
                                                              ENU=Dimension Value Code];
                                                   NotBlank=Yes }
    { 5   ;   ;New Dimension Value Code;Code20    ;TableRelation="Dimension Value".Code WHERE (Dimension Code=FIELD(Dimension Code));
                                                   OnValidate=BEGIN
                                                                IF NOT DimMgt.CheckDimValue("Dimension Code","New Dimension Value Code") THEN
                                                                  ERROR(DimMgt.GetDimErr);
                                                              END;

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Ny dimensionsv‘rdikode;
                                                              ENU=New Dimension Value Code] }
    { 6   ;   ;Line No.            ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Linjenr.;
                                                              ENU=Line No.] }
    { 7   ;   ;No. Of Dimensions   ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Antal dimensioner;
                                                              ENU=No. Of Dimensions] }
  }
  KEYS
  {
    {    ;Table ID,Entry No.,Dimension Code       ;Clustered=Yes }
    {    ;No. Of Dimensions                        }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      DimMgt@1000 : Codeunit 408;

    BEGIN
    END.
  }
}

