OBJECT Table 8619 Config. Template Line
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    OnInsert=VAR
               ConfigTemplateHeader@1000 : Record 8618;
             BEGIN
               IF ConfigTemplateHeader.GET("Data Template Code") THEN BEGIN
                 "Table ID" := ConfigTemplateHeader."Table ID";
                 IF "Language ID" = 0 THEN
                   "Language ID" := GLOBALLANGUAGE;
               END;
             END;

    CaptionML=[DAN=Konfig.skabelonlinje;
               ENU=Config. Template Line];
  }
  FIELDS
  {
    { 1   ;   ;Data Template Code  ;Code10        ;TableRelation="Config. Template Header";
                                                   CaptionML=[DAN=Dataskabelonskode;
                                                              ENU=Data Template Code];
                                                   Editable=No }
    { 2   ;   ;Line No.            ;Integer       ;CaptionML=[DAN=Linjenr.;
                                                              ENU=Line No.];
                                                   Editable=No }
    { 3   ;   ;Type                ;Option        ;InitValue=Field;
                                                   OnValidate=BEGIN
                                                                CASE Type OF
                                                                  Type::Field:
                                                                    CLEAR("Template Code");
                                                                  Type::Template:
                                                                    BEGIN
                                                                      CLEAR("Field Name");
                                                                      CLEAR("Field ID");
                                                                    END;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Enhedstype;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=Felt,Skabelon,Relateret skabelon;
                                                                    ENU=Field,Template,Related Template];
                                                   OptionString=Field,Template,Related Template }
    { 4   ;   ;Field ID            ;Integer       ;TableRelation=IF (Type=CONST(Field)) Field.No. WHERE (TableNo=FIELD(Table ID),
                                                                                                         Class=CONST(Normal));
                                                   CaptionML=[DAN=Felt-id;
                                                              ENU=Field ID] }
    { 5   ;   ;Field Name          ;Text30        ;FieldClass=Normal;
                                                   OnValidate=VAR
                                                                ConfigTemplateLine@1000 : Record 8619;
                                                                ConfigTemplateMgt@1001 : Codeunit 8612;
                                                              BEGIN
                                                                ConfigTemplateLine.SETRANGE("Data Template Code","Data Template Code");
                                                                ConfigTemplateLine.SETRANGE("Field Name","Field Name");
                                                                IF NOT ConfigTemplateLine.ISEMPTY THEN
                                                                  ERROR(STRSUBSTNO(Text004,"Field Name"));

                                                                ConfigTemplateMgt.TestHierarchy(Rec);
                                                              END;

                                                   OnLookup=BEGIN
                                                              SelectFieldName;
                                                            END;

                                                   CaptionML=[DAN=Feltnavn;
                                                              ENU=Field Name];
                                                   Editable=No }
    { 6   ;   ;Table ID            ;Integer       ;CaptionML=[DAN=Tabel-id;
                                                              ENU=Table ID] }
    { 7   ;   ;Table Name          ;Text250       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(AllObjWithCaption."Object Name" WHERE (Object Type=FILTER(Table),
                                                                                                             Object ID=FIELD(Table ID)));
                                                   CaptionML=[DAN=Tabelnavn;
                                                              ENU=Table Name];
                                                   Editable=No }
    { 8   ;   ;Template Code       ;Code10        ;TableRelation="Config. Template Header";
                                                   OnValidate=VAR
                                                                ConfigTemplateHeader@1000 : Record 8618;
                                                                ConfigTemplateHeader2@1001 : Record 8618;
                                                                ConfigTemplateLine@1003 : Record 8619;
                                                                ConfigTemplateMgt@1002 : Codeunit 8612;
                                                              BEGIN
                                                                IF Type = Type::Field THEN
                                                                  ERROR(Text005);

                                                                IF "Template Code" = "Data Template Code" THEN
                                                                  ERROR(Text000);

                                                                IF ConfigTemplateHeader.GET("Template Code") THEN
                                                                  IF ConfigTemplateHeader2.GET("Data Template Code") THEN
                                                                    IF ConfigTemplateHeader."Table ID" <> ConfigTemplateHeader2."Table ID" THEN
                                                                      ERROR(STRSUBSTNO(Text002,ConfigTemplateHeader.Code,ConfigTemplateHeader2."Table ID"));

                                                                ConfigTemplateMgt.TestHierarchy(Rec);

                                                                ConfigTemplateLine.SETRANGE("Data Template Code","Data Template Code");
                                                                ConfigTemplateLine.SETRANGE("Template Code","Template Code");
                                                                IF NOT ConfigTemplateLine.ISEMPTY THEN
                                                                  ERROR(STRSUBSTNO(Text003,"Template Code"));
                                                              END;

                                                   OnLookup=VAR
                                                              ConfigTemplateHeader@1002 : Record 8618;
                                                              ConfigTemplateList@1000 : Page 8620;
                                                            BEGIN
                                                              IF Type = Type::Field THEN
                                                                EXIT;

                                                              ConfigTemplateHeader.GET("Data Template Code");
                                                              IF ConfigTemplateHeader."Table ID" = 0 THEN
                                                                EXIT;

                                                              ConfigTemplateHeader.SETRANGE("Table ID",ConfigTemplateHeader."Table ID");
                                                              ConfigTemplateList.SETTABLEVIEW(ConfigTemplateHeader);
                                                              ConfigTemplateList.LOOKUPMODE := TRUE;
                                                              ConfigTemplateList.EDITABLE := FALSE;
                                                              IF ConfigTemplateList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                                                ConfigTemplateList.GETRECORD(ConfigTemplateHeader);
                                                                IF ConfigTemplateHeader.Code = "Data Template Code" THEN
                                                                  ERROR(Text000);
                                                                CALCFIELDS("Template Description");
                                                                VALIDATE("Template Code",ConfigTemplateHeader.Code);
                                                              END;
                                                            END;

                                                   CaptionML=[DAN=Skabelonkode;
                                                              ENU=Template Code] }
    { 9   ;   ;Template Description;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Config. Template Header".Description WHERE (Code=FIELD(Data Template Code)));
                                                   CaptionML=[DAN=Beskrivelse af skabelon;
                                                              ENU=Template Description];
                                                   Editable=No }
    { 10  ;   ;Mandatory           ;Boolean       ;CaptionML=[DAN=Obligatorisk;
                                                              ENU=Mandatory] }
    { 11  ;   ;Reference           ;Text250       ;ExtendedDatatype=URL;
                                                   CaptionML=[DAN=Reference;
                                                              ENU=Reference] }
    { 12  ;   ;Default Value       ;Text250       ;OnValidate=VAR
                                                                TempConfigPackageField@1005 : TEMPORARY Record 8616;
                                                                ConfigPackageManagement@1004 : Codeunit 8611;
                                                                ConfigValidateMgt@1003 : Codeunit 8617;
                                                                RecRef@1002 : RecordRef;
                                                                FieldRef@1001 : FieldRef;
                                                                ValidationError@1000 : Text[250];
                                                              BEGIN
                                                                IF ("Field ID" <> 0) AND ("Default Value" <> '') THEN BEGIN
                                                                  RecRef.OPEN("Table ID",TRUE);
                                                                  FieldRef := RecRef.FIELD("Field ID");
                                                                  ValidationError := ConfigValidateMgt.EvaluateValue(FieldRef,"Default Value",FALSE);
                                                                  IF ValidationError <> '' THEN
                                                                    ERROR(ValidationError);

                                                                  "Default Value" := FORMAT(FieldRef.VALUE);

                                                                  IF NOT "Skip Relation Check" THEN BEGIN
                                                                    ConfigPackageManagement.GetFieldsOrder(RecRef,'',TempConfigPackageField);
                                                                    ConfigValidateMgt.TransferRecordDefaultValues("Data Template Code",RecRef,"Field ID","Default Value");
                                                                    ValidationError := ConfigValidateMgt.ValidateFieldRefRelationAgainstCompanyData(FieldRef,TempConfigPackageField);

                                                                    IF ValidationError <> '' THEN
                                                                      ERROR(ValidationError);
                                                                  END;

                                                                  IF GLOBALLANGUAGE <> "Language ID" THEN
                                                                    VALIDATE("Language ID",GLOBALLANGUAGE);
                                                                END
                                                              END;

                                                   CaptionML=[DAN=Standardv�rdi;
                                                              ENU=Default Value] }
    { 13  ;   ;Table Caption       ;Text250       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(AllObjWithCaption."Object Caption" WHERE (Object Type=FILTER(Table),
                                                                                                                Object ID=FIELD(Table ID)));
                                                   CaptionML=[DAN=Tabeltitel;
                                                              ENU=Table Caption];
                                                   Editable=No }
    { 14  ;   ;Field Caption       ;Text250       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Field."Field Caption" WHERE (TableNo=FIELD(Table ID),
                                                                                                   No.=FIELD(Field ID)));
                                                   CaptionML=[DAN=Felttitel;
                                                              ENU=Field Caption];
                                                   Editable=No }
    { 15  ;   ;Skip Relation Check ;Boolean       ;CaptionML=[DAN=Spring relationskontrol over;
                                                              ENU=Skip Relation Check] }
    { 16  ;   ;Language ID         ;Integer       ;InitValue=0;
                                                   CaptionML=[DAN=Sprog-id;
                                                              ENU=Language ID] }
  }
  KEYS
  {
    {    ;Data Template Code,Line No.             ;Clustered=Yes }
    {    ;Data Template Code,Type                  }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=En skabelon kan ikke knyttes til sig selv. Angiv en anden skabelon.;ENU=A template cannot relate to itself. Specify a different template.';
      Text002@1002 : TextConst 'DAN=Skabelonen %1 er ikke knyttet til tabellen %2.;ENU=The template %1 does not relate to table %2.';
      Text003@1003 : TextConst 'DAN=Skabelonen %1 findes allerede i dette hierarki.;ENU=The template %1 is already in this hierarchy.';
      Text004@1004 : TextConst 'DAN=Feltet %1 findes allerede i skabelonen.;ENU=Field %1 is already in the template.';
      Text005@1005 : TextConst 'DAN=Skabelonen kan ikke redigeres, hvis typen er Felt.;ENU=The template line cannot be edited if type is Field.';

    PROCEDURE SelectFieldName@2();
    VAR
      ConfigTemplateHeader@1003 : Record 8618;
      Field@1002 : Record 2000000041;
      ConfigPackageMgt@1000 : Codeunit 8611;
      FieldList@1001 : Page 6218;
    BEGIN
      IF Type = Type::Template THEN
        EXIT;

      ConfigTemplateHeader.GET("Data Template Code");

      IF ConfigTemplateHeader."Table ID" = 0 THEN
        EXIT;

      CLEAR(FieldList);
      ConfigPackageMgt.SetFieldFilter(Field,ConfigTemplateHeader."Table ID",0);
      FieldList.SETTABLEVIEW(Field);
      FieldList.LOOKUPMODE := TRUE;
      IF FieldList.RUNMODAL = ACTION::LookupOK THEN BEGIN
        FieldList.GETRECORD(Field);
        "Table ID" := Field.TableNo;
        VALIDATE("Field ID",Field."No.");
        VALIDATE("Field Name",Field.FieldName);
      END;
    END;

    PROCEDURE GetLine@1(VAR ConfigTemplateLine@1000 : Record 8619;DataTemplateCode@1001 : Code[10];FieldID@1002 : Integer) : Boolean;
    BEGIN
      ConfigTemplateLine.SETRANGE("Data Template Code",DataTemplateCode);
      ConfigTemplateLine.SETRANGE("Field ID",FieldID);
      IF NOT ConfigTemplateLine.FINDFIRST THEN
        EXIT(FALSE);
      EXIT(TRUE)
    END;

    BEGIN
    END.
  }
}
