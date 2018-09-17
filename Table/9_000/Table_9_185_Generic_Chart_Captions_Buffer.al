OBJECT Table 9185 Generic Chart Captions Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Buffer for generiske diagramtitler;
               ENU=Generic Chart Captions Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code10        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kode;
                                                              ENU=Code];
                                                   NotBlank=Yes }
    { 2   ;   ;Language Code       ;Code10        ;TableRelation=Language.Code;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Sprogkode;
                                                              ENU=Language Code];
                                                   NotBlank=Yes }
    { 3   ;   ;Caption             ;Text250       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Titel;
                                                              ENU=Caption] }
    { 4   ;   ;Language Name       ;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Language.Name WHERE (Code=FIELD(Language Code)));
                                                   CaptionML=[DAN=Sprognavn;
                                                              ENU=Language Name] }
  }
  KEYS
  {
    {    ;Code,Language Code                      ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    [External]
    PROCEDURE GetCaption@2(CodeIn@1002 : Code[10];LanguageCode@1000 : Code[10]) : Text[250];
    BEGIN
      IF GET(CodeIn,LanguageCode) THEN
        EXIT(Caption)
    END;

    [External]
    PROCEDURE SetCaption@3(CodeIn@1003 : Code[10];LanguageCode@1000 : Code[10];CaptionIn@1001 : Text[250]);
    BEGIN
      IF GET(CodeIn,LanguageCode) THEN BEGIN
        Caption := CaptionIn;
        MODIFY
      END ELSE BEGIN
        Code := CodeIn;
        "Language Code" := LanguageCode;
        Caption := CaptionIn;
        INSERT
      END
    END;

    BEGIN
    END.
  }
}

