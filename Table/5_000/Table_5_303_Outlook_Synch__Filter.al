OBJECT Table 5303 Outlook Synch. Filter
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    DataCaptionFields=Filter Type;
    OnInsert=BEGIN
               TESTFIELD("Field No.");
               VALIDATE(Value);
               UpdateFilterExpression;
             END;

    OnModify=BEGIN
               VALIDATE(Value);
               UpdateFilterExpression;
             END;

    CaptionML=[DAN=Outlook-synkroniseringsfilter;
               ENU=Outlook Synch. Filter];
    PasteIsValid=No;
  }
  FIELDS
  {
    { 1   ;   ;Record GUID         ;GUID          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Record-GUID;
                                                              ENU=Record GUID];
                                                   NotBlank=Yes;
                                                   Editable=No }
    { 2   ;   ;Filter Type         ;Option        ;CaptionML=[DAN=Filtertype;
                                                              ENU=Filter Type];
                                                   OptionCaptionML=[DAN=Betingelse,Tabelrelation;
                                                                    ENU=Condition,Table Relation];
                                                   OptionString=Condition,Table Relation }
    { 3   ;   ;Line No.            ;Integer       ;CaptionML=[DAN=Linjenr.;
                                                              ENU=Line No.] }
    { 4   ;   ;Table No.           ;Integer       ;TableRelation=AllObjWithCaption."Object ID" WHERE (Object Type=CONST(Table));
                                                   CaptionML=[DAN=Tabelnr.;
                                                              ENU=Table No.] }
    { 5   ;   ;Field No.           ;Integer       ;TableRelation=Field.No. WHERE (TableNo=FIELD(Table No.));
                                                   OnValidate=VAR
                                                                RecRef@1000 : RecordRef;
                                                              BEGIN
                                                                IF "Field No." = 0 THEN BEGIN
                                                                  CLEAR(RecRef);
                                                                  RecRef.OPEN("Table No.",TRUE);
                                                                  ERROR(Text005,RecRef.CAPTION);
                                                                END;

                                                                IF "Field No." <> xRec."Field No." THEN
                                                                  IF Type <> Type::FIELD THEN
                                                                    Value := '';
                                                              END;

                                                   OnLookup=VAR
                                                              FieldNo@1000 : Integer;
                                                            BEGIN
                                                              IF "Table No." <> 0 THEN
                                                                FieldNo := OSynchSetupMgt.ShowTableFieldsList("Table No.")
                                                              ELSE
                                                                FieldNo := OSynchSetupMgt.ShowTableFieldsList("Master Table No.");

                                                              IF FieldNo > 0 THEN
                                                                VALIDATE("Field No.",FieldNo);
                                                            END;

                                                   CaptionML=[DAN=Feltnr.;
                                                              ENU=Field No.] }
    { 7   ;   ;Type                ;Option        ;OnValidate=BEGIN
                                                                IF ("Filter Type" = "Filter Type"::Condition) AND (Type = Type::FIELD) THEN
                                                                  ERROR(Text001,FORMAT(Type),FIELDCAPTION("Filter Type"),FORMAT("Filter Type"));

                                                                IF Type <> xRec.Type THEN
                                                                  Value := '';
                                                              END;

                                                   CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=CONST,FILTER,FIELD;
                                                                    ENU=CONST,FILTER,FIELD];
                                                   OptionString=CONST,FILTER,FIELD }
    { 8   ;   ;Value               ;Text250       ;OnValidate=BEGIN
                                                                ValidateFieldValuePair;
                                                              END;

                                                   OnLookup=VAR
                                                              OSynchTypeConversion@1003 : Codeunit 5302;
                                                              RecRef@1002 : RecordRef;
                                                              FldRef@1001 : FieldRef;
                                                              MasterTableFieldNo@1000 : Integer;
                                                            BEGIN
                                                              IF Type <> Type::FIELD THEN BEGIN
                                                                RecRef.GETTABLE(Rec);
                                                                FldRef := RecRef.FIELD(FIELDNO(Type));
                                                                ERROR(Text003,FIELDCAPTION(Type),OSynchTypeConversion.GetSubStrByNo(Type::FIELD + 1,FldRef.OPTIONCAPTION));
                                                              END;

                                                              MasterTableFieldNo := OSynchSetupMgt.ShowTableFieldsList("Master Table No.");

                                                              IF MasterTableFieldNo <> 0 THEN
                                                                VALIDATE("Master Table Field No.",MasterTableFieldNo);
                                                            END;

                                                   CaptionML=[DAN=V�rdi;
                                                              ENU=Value] }
    { 9   ;   ;Master Table No.    ;Integer       ;TableRelation=AllObjWithCaption."Object ID" WHERE (Object Type=CONST(Table));
                                                   CaptionML=[DAN=Overordnet tabelnr.;
                                                              ENU=Master Table No.] }
    { 10  ;   ;Master Table Field No.;Integer     ;TableRelation=Field.No. WHERE (TableNo=FIELD(Master Table No.));
                                                   OnValidate=BEGIN
                                                                IF Field.GET("Master Table No.","Master Table Field No.") THEN
                                                                  VALIDATE(Value,Field."Field Caption");
                                                              END;

                                                   CaptionML=[DAN=Feltnr. til overordnet tabel;
                                                              ENU=Master Table Field No.] }
    { 99  ;   ;FilterExpression    ;Text250       ;CaptionML=[DAN=FilterExpression;
                                                              ENU=FilterExpression] }
  }
  KEYS
  {
    {    ;Record GUID,Filter Type,Line No.        ;Clustered=Yes }
    {    ;Table No.,Field No.                      }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Field@1004 : Record 2000000041;
      OSynchSetupMgt@1005 : Codeunit 5300;
      OSynchTypeConversion@1006 : Codeunit 5302;
      Text001@1008 : TextConst 'DAN=Indstillingen %1 kan ikke v�lges, n�r %2 er %3.;ENU=You cannot select the %1 option when %2 is %3.';
      Text002@1007 : TextConst 'DAN=Denne v�rdi kan ikke konverteres til den valgte feltdatatype.;ENU=This value cannot be converted to the selected field datatype.';
      Text003@1003 : TextConst 'DAN=Du kan kun �bne en opslagstabel, n�r feltet %1 indeholder v�rdien %2.;ENU=You can only open a lookup table when the %1 field contains the %2 value.';
      Text004@1002 : TextConst 'DAN=Dette er ikke en gyldig indstilling for feltet %1. De mulige indstillinger er: ''%2''.;ENU=This is not a valid option for the %1 field. The possible options are: ''%2''.';
      Text005@1001 : TextConst 'DAN=V�lg et gyldigt felt i tabellen %1.;ENU=Choose a valid field in the %1 table.';
      Text006@1009 : TextConst 'DAN=V�rdien i dette felt m� ikke v�re l�ngere end %1.;ENU=The value in this field cannot be longer than %1.';

    [External]
    PROCEDURE SetTablesNo@1(TableLeftNo@1000 : Integer;TableRightNo@1001 : Integer);
    BEGIN
      "Table No." := TableLeftNo;
      "Master Table No." := TableRightNo;
    END;

    [Internal]
    PROCEDURE ValidateFieldValuePair@2();
    VAR
      RecRef@1000 : RecordRef;
      FldRef@1001 : FieldRef;
      NameString@1004 : Text[250];
      TempBool@1003 : Boolean;
    BEGIN
      TESTFIELD("Table No.");

      CLEAR(RecRef);
      CLEAR(FldRef);
      RecRef.OPEN("Table No.",TRUE);

      IF "Field No." = 0 THEN
        ERROR(Text005,RecRef.CAPTION);

      Field.GET("Table No.","Field No.");
      FldRef := RecRef.FIELD("Field No.");

      CASE Type OF
        Type::CONST:
          CASE Field.Type OF
            Field.Type::Option:
              IF NOT OSynchTypeConversion.EvaluateOptionField(FldRef,Value) THEN
                ERROR(Text004,Field."Field Caption",FldRef.OPTIONSTRING);
            Field.Type::Code,Field.Type::Text:
              BEGIN
                IF STRLEN(Value) > Field.Len THEN
                  ERROR(Text006,Field.Len);
                IF NOT EVALUATE(FldRef,Value) THEN
                  ERROR(Text002);
              END;
            Field.Type::Boolean:
              BEGIN
                IF NOT EVALUATE(TempBool,Value) THEN
                  ERROR(Text002);
                Value := FORMAT(TempBool);
              END;
            ELSE
              IF NOT EVALUATE(FldRef,Value) THEN
                ERROR(Text002);
          END;
        Type::FILTER:
          BEGIN
            IF Field.Type = Field.Type::Option THEN BEGIN
              IF NOT OSynchTypeConversion.EvaluateFilterOptionField(FldRef,Value,FALSE) THEN
                ERROR(Text004,Field."Field Caption",FldRef.OPTIONSTRING);
            END;
            FldRef.SETFILTER(Value);
          END;
        Type::FIELD:
          BEGIN
            NameString := Value;
            IF NOT OSynchSetupMgt.ValidateFieldName(NameString,"Master Table No.") THEN BEGIN
              RecRef.CLOSE;
              RecRef.OPEN("Master Table No.",TRUE);
              ERROR(Text005,RecRef.CAPTION);
            END;

            Value := NameString;
          END;
      END;
      RecRef.CLOSE;
    END;

    [External]
    PROCEDURE RecomposeFilterExpression@3() FilterExpression : Text[250];
    BEGIN
      FilterExpression := OSynchSetupMgt.ComposeFilterExpression("Record GUID","Filter Type");
    END;

    [External]
    PROCEDURE GetFieldCaption@5() : Text;
    BEGIN
      IF Field.GET("Table No.","Field No.") THEN
        EXIT(Field."Field Caption");
      EXIT('');
    END;

    [External]
    PROCEDURE GetFilterExpressionValue@4() : Text[250];
    VAR
      ValueStartIndex@1000 : Integer;
    BEGIN
      ValueStartIndex := STRPOS(FilterExpression,'(');
      EXIT(COPYSTR(FilterExpression,ValueStartIndex + 1,STRLEN(FilterExpression) - ValueStartIndex - 1));
    END;

    [Internal]
    PROCEDURE UpdateFilterExpression@6();
    VAR
      TempRecordRef@1000 : RecordRef;
      ViewExpression@1001 : Text;
      WhereIndex@1002 : Integer;
      TempBoolean@1003 : Boolean;
    BEGIN
      FilterExpression := '';
      IF Type <> Type::FIELD THEN
        IF "Table No." <> 0 THEN BEGIN
          TempRecordRef.OPEN("Table No.");

          ViewExpression := GetFieldCaption + STRSUBSTNO('=FILTER(%1)',Value);

          ViewExpression := STRSUBSTNO('WHERE(%1)',ViewExpression);
          TempRecordRef.SETVIEW(ViewExpression);

          ViewExpression := TempRecordRef.GETVIEW(FALSE);
          WhereIndex := STRPOS(ViewExpression,'WHERE(') + 6;
          FilterExpression := COPYSTR(ViewExpression,WhereIndex,STRLEN(ViewExpression) - WhereIndex);

          IF Field.GET("Table No.","Field No.") THEN
            IF Field.Type = Field.Type::Boolean THEN BEGIN
              EVALUATE(TempBoolean,Value);
              IF TempBoolean THEN
                FilterExpression := COPYSTR(StringReplace(FilterExpression,Value,'1'),1,250)
              ELSE
                FilterExpression := COPYSTR(StringReplace(FilterExpression,Value,'0'),1,250);
            END;
        END;
    END;

    LOCAL PROCEDURE StringReplace@8(Input@1000 : Text;Find@1001 : Text;Replace@1002 : Text) : Text;
    VAR
      Pos@1003 : Integer;
    BEGIN
      Pos := STRPOS(Input,Find);
      WHILE Pos <> 0 DO BEGIN
        Input := DELSTR(Input,Pos,STRLEN(Find));
        Input := INSSTR(Input,Replace,Pos);
        Pos := STRPOS(Input,Find);
      END;
      EXIT(Input);
    END;

    BEGIN
    END.
  }
}

