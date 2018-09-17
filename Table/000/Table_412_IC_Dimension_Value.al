OBJECT Table 412 IC Dimension Value
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               ICDimension.GET("Dimension Code");
               "Map-to Dimension Code" := ICDimension."Map-to Dimension Code";
             END;

    CaptionML=[DAN=IC-dimensionsv‘rdi;
               ENU=IC Dimension Value];
    LookupPageID=Page603;
  }
  FIELDS
  {
    { 1   ;   ;Dimension Code      ;Code20        ;TableRelation="IC Dimension";
                                                   OnValidate=BEGIN
                                                                UpdateMapToDimensionCode;
                                                              END;

                                                   CaptionML=[DAN=Dimensionskode;
                                                              ENU=Dimension Code];
                                                   NotBlank=Yes }
    { 2   ;   ;Code                ;Code20        ;CaptionML=[DAN=Kode;
                                                              ENU=Code];
                                                   NotBlank=Yes }
    { 3   ;   ;Name                ;Text50        ;CaptionML=[DAN=Navn;
                                                              ENU=Name] }
    { 4   ;   ;Dimension Value Type;Option        ;AccessByPermission=TableData 348=R;
                                                   CaptionML=[DAN=Dimensionsv‘rditype;
                                                              ENU=Dimension Value Type];
                                                   OptionCaptionML=[DAN=Standard,Overskrift,Sum,Fra-sum,Til-sum;
                                                                    ENU=Standard,Heading,Total,Begin-Total,End-Total];
                                                   OptionString=Standard,Heading,Total,Begin-Total,End-Total }
    { 5   ;   ;Blocked             ;Boolean       ;CaptionML=[DAN=Sp‘rret;
                                                              ENU=Blocked] }
    { 6   ;   ;Map-to Dimension Code;Code20       ;TableRelation=Dimension.Code;
                                                   OnValidate=BEGIN
                                                                IF "Map-to Dimension Code" <> xRec."Map-to Dimension Code" THEN
                                                                  VALIDATE("Map-to Dimension Value Code",'');
                                                              END;

                                                   CaptionML=[DAN=Dim.kode for tilknytning;
                                                              ENU=Map-to Dimension Code] }
    { 7   ;   ;Map-to Dimension Value Code;Code20 ;TableRelation="Dimension Value".Code WHERE (Dimension Code=FIELD(Map-to Dimension Code));
                                                   CaptionML=[DAN=Dim.v‘rdikode for tilknytning;
                                                              ENU=Map-to Dimension Value Code] }
    { 8   ;   ;Indentation         ;Integer       ;CaptionML=[DAN=Indrykning;
                                                              ENU=Indentation] }
  }
  KEYS
  {
    {    ;Dimension Code,Code                     ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      ICDimension@1000 : Record 411;

    LOCAL PROCEDURE UpdateMapToDimensionCode@1();
    VAR
      ICDimension@1000 : Record 411;
    BEGIN
      ICDimension.GET("Dimension Code");
      VALIDATE("Map-to Dimension Code",ICDimension."Map-to Dimension Code");
    END;

    BEGIN
    END.
  }
}

