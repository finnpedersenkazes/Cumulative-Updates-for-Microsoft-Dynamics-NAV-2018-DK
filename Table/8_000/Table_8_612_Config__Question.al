OBJECT Table 8612 Config. Question
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Konfig.sp�rgsm�l;
               ENU=Config. Question];
  }
  FIELDS
  {
    { 1   ;   ;Questionnaire Code  ;Code10        ;TableRelation="Config. Questionnaire".Code;
                                                   CaptionML=[DAN=Sp�rgeskemakode;
                                                              ENU=Questionnaire Code];
                                                   Editable=No }
    { 2   ;   ;Question Area Code  ;Code10        ;TableRelation="Config. Question Area".Code WHERE (Questionnaire Code=FIELD(Questionnaire Code));
                                                   CaptionML=[DAN=Sp�rgsm�lsomr�dekode;
                                                              ENU=Question Area Code];
                                                   Editable=No }
    { 3   ;   ;No.                 ;Integer       ;CaptionML=[DAN=Nummer;
                                                              ENU=No.];
                                                   MinValue=1 }
    { 4   ;   ;Question            ;Text250       ;CaptionML=[DAN=Sp�rgsm�l;
                                                              ENU=Question] }
    { 5   ;   ;Answer Option       ;Text250       ;CaptionML=[DAN=Svarmulighed;
                                                              ENU=Answer Option];
                                                   Editable=No }
    { 6   ;   ;Answer              ;Text250       ;OnValidate=VAR
                                                                TempConfigPackageField@1005 : TEMPORARY Record 8616;
                                                                ConfigValidateMgt@1001 : Codeunit 8617;
                                                                ConfigPackageManagement@1004 : Codeunit 8611;
                                                                RecRef@1003 : RecordRef;
                                                                FieldRef@1002 : FieldRef;
                                                                ValidationError@1000 : Text[250];
                                                              BEGIN
                                                                IF ("Field ID" <> 0) AND (Answer <> '') THEN BEGIN
                                                                  RecRef.OPEN("Table ID",TRUE);
                                                                  FieldRef := RecRef.FIELD("Field ID");
                                                                  ValidationError := ConfigValidateMgt.EvaluateValue(FieldRef,Answer,FALSE);
                                                                  IF ValidationError <> '' THEN
                                                                    ERROR(ValidationError);

                                                                  Answer := FORMAT(FieldRef.VALUE);

                                                                  ConfigPackageManagement.GetFieldsOrder(RecRef,'',TempConfigPackageField);
                                                                  ValidationError := ConfigValidateMgt.ValidateFieldRefRelationAgainstCompanyData(FieldRef,TempConfigPackageField);
                                                                  IF ValidationError <> '' THEN
                                                                    ERROR(ValidationError);
                                                                END;
                                                              END;

                                                   OnLookup=BEGIN
                                                              AnswerLookup;
                                                            END;

                                                   CaptionML=[DAN=Svar;
                                                              ENU=Answer] }
    { 7   ;   ;Table ID            ;Integer       ;CaptionML=[DAN=Tabel-id;
                                                              ENU=Table ID] }
    { 8   ;   ;Field ID            ;Integer       ;OnLookup=BEGIN
                                                              FieldLookup;
                                                            END;

                                                   CaptionML=[DAN=Felt-id;
                                                              ENU=Field ID] }
    { 9   ;   ;Reference           ;Text250       ;ExtendedDatatype=URL;
                                                   CaptionML=[DAN=Reference;
                                                              ENU=Reference] }
    { 10  ;   ;Question Origin     ;Text30        ;CaptionML=[DAN=Sp�rgsm�lets oprindelse;
                                                              ENU=Question Origin] }
    { 11  ;   ;Field Name          ;Text30        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Field.FieldName WHERE (TableNo=FIELD(Table ID),
                                                                                             No.=FIELD(Field ID)));
                                                   OnLookup=BEGIN
                                                              FieldLookup;
                                                            END;

                                                   CaptionML=[DAN=Feltnavn;
                                                              ENU=Field Name];
                                                   Editable=No }
    { 12  ;   ;Field Caption       ;Text250       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Field."Field Caption" WHERE (TableNo=FIELD(Table ID),
                                                                                                   No.=FIELD(Field ID)));
                                                   OnLookup=BEGIN
                                                              FieldLookup;
                                                            END;

                                                   CaptionML=[DAN=Felttitel;
                                                              ENU=Field Caption];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Questionnaire Code,Question Area Code,No.;
                                                   Clustered=Yes }
    {    ;Questionnaire Code,Question Area Code,Field ID }
    {    ;Table ID,Field ID                        }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text002@1001 : TextConst 'DAN=Sp�rgsm�l nr. %1 findes allerede for feltet %2.;ENU=Question no. %1 already exists for the field %2.';

    [Internal]
    PROCEDURE FieldLookup@1();
    VAR
      ConfigQuestion1@1004 : Record 8612;
      ConfigQuestionArea@1003 : Record 8611;
      Field@1002 : Record 2000000041;
      ConfigQuestionnaireMgt@1000 : Codeunit 8610;
      ConfigPackageMgt@1005 : Codeunit 8611;
      Fields@1001 : Page 6218;
    BEGIN
      ConfigQuestionArea.GET("Questionnaire Code","Question Area Code");

      IF ConfigQuestionArea."Table ID" = 0 THEN
        EXIT;

      ConfigPackageMgt.SetFieldFilter(Field,ConfigQuestionArea."Table ID",0);
      Fields.SETTABLEVIEW(Field);
      Fields.LOOKUPMODE := TRUE;
      Fields.EDITABLE := FALSE;
      IF Fields.RUNMODAL = ACTION::LookupOK THEN BEGIN
        Fields.GETRECORD(Field);
        "Table ID" := Field.TableNo;
        "Field ID" := Field."No.";

        ConfigQuestion1.SETRANGE("Questionnaire Code","Questionnaire Code");
        ConfigQuestion1.SETRANGE("Question Area Code","Question Area Code");
        ConfigQuestion1.SETRANGE("Table ID","Table ID");
        ConfigQuestion1.SETRANGE("Field ID","Field ID");
        IF ConfigQuestion1.FINDFIRST THEN BEGIN
          "Field ID" := 0;
          ConfigQuestion1.CALCFIELDS("Field Caption");
          ERROR(Text002,ConfigQuestion1."No.",ConfigQuestion1."Field Caption");
        END;

        IF Question = '' THEN
          Question := Field."Field Caption" + '?';
        "Answer Option" := ConfigQuestionnaireMgt.BuildAnswerOption("Table ID","Field ID");
        CALCFIELDS("Field Name","Field Caption");
      END;
    END;

    LOCAL PROCEDURE AnswerLookup@2();
    VAR
      ConfigPackageData@1001 : Record 8615;
      ConfigValidateMgt@1002 : Codeunit 8617;
      ConfigPackageDataPage@1000 : Page 8627;
      RelatedTableID@1003 : Integer;
      RelatedFieldID@1004 : Integer;
    BEGIN
      ConfigValidateMgt.GetRelationInfoByIDs("Table ID","Field ID",RelatedTableID,RelatedFieldID);
      IF RelatedTableID <> 0 THEN BEGIN
        ConfigPackageData.SETRANGE("Table ID",RelatedTableID);
        ConfigPackageData.SETRANGE("Field ID",RelatedFieldID);

        CLEAR(ConfigPackageDataPage);
        ConfigPackageDataPage.SETTABLEVIEW(ConfigPackageData);
        ConfigPackageDataPage.LOOKUPMODE := TRUE;
        IF ConfigPackageDataPage.RUNMODAL = ACTION::LookupOK THEN BEGIN
          ConfigPackageDataPage.GETRECORD(ConfigPackageData);
          Answer := ConfigPackageData.Value;
        END;
      END;
    END;

    [Internal]
    PROCEDURE LookupValue@3() : Text;
    VAR
      RecRef@1000 : RecordRef;
      FieldRef@1001 : FieldRef;
    BEGIN
      IF "Table ID" > 0 THEN BEGIN
        RecRef.OPEN("Table ID");
        RecRef.FINDFIRST;
        FieldRef := RecRef.FIELD("Field ID");
        EXIT(FORMAT(FieldRef.VALUE));
      END;
    END;

    BEGIN
    END.
  }
}

