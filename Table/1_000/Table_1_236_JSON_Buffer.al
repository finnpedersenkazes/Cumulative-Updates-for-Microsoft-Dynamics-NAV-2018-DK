OBJECT Table 1236 JSON Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=JSON-buffer;
               ENU=JSON Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=L�benummer;
                                                              ENU=Entry No.] }
    { 2   ;   ;Depth               ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dybde;
                                                              ENU=Depth] }
    { 3   ;   ;Token type          ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Tokentype;
                                                              ENU=Token type];
                                                   OptionCaptionML=[DAN=Ingen,Start objekt,Start matrix,Start konstrukt�r,Egenskabsnavn,Bem�rkning,R�,Heltal,Decimal,Streng,Boolesk,Null,Udefineret,Afslut objekt,Afslut matrix,Afslut konstrukt�r,Dato,Byte;
                                                                    ENU=None,Start Object,Start Array,Start Constructor,Property Name,Comment,Raw,Integer,Decimal,String,Boolean,Null,Undefined,End Object,End Array,End Constructor,Date,Bytes];
                                                   OptionString=None,Start Object,Start Array,Start Constructor,Property Name,Comment,Raw,Integer,Decimal,String,Boolean,Null,Undefined,End Object,End Array,End Constructor,Date,Bytes }
    { 4   ;   ;Value               ;Text250       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=V�rdi;
                                                              ENU=Value] }
    { 5   ;   ;Value Type          ;Text50        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=V�rditype;
                                                              ENU=Value Type] }
    { 6   ;   ;Path                ;Text250       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Sti;
                                                              ENU=Path] }
    { 7   ;   ;Value BLOB          ;BLOB          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=BLOB-v�rdi;
                                                              ENU=Value BLOB] }
  }
  KEYS
  {
    {    ;Entry No.                               ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      DevMsgNotTemporaryErr@1000 : TextConst 'DAN=Denne funktion kan kun bruges, n�r recorden er midlertidig.;ENU=This function can only be used when the record is temporary.';

    PROCEDURE ReadFromText@2(JSONText@1000 : Text);
    VAR
      JSONTextReader@1003 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.JsonTextReader";
      StringReader@1005 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.StringReader";
      TokenType@1007 : Integer;
    BEGIN
      IF NOT ISTEMPORARY THEN
        ERROR(DevMsgNotTemporaryErr);
      DELETEALL;
      JSONTextReader := JSONTextReader.JsonTextReader(StringReader.StringReader(JSONText));
      IF JSONTextReader.Read THEN
        REPEAT
          INIT;
          "Entry No." += 1;
          Depth := JSONTextReader.Depth;
          TokenType := JSONTextReader.TokenType;
          "Token type" := TokenType;
          IF ISNULL(JSONTextReader.Value) THEN
            Value := ''
          ELSE
            SetValueWithoutModifying(FORMAT(JSONTextReader.Value));
          IF ISNULL(JSONTextReader.ValueType) THEN
            "Value Type" := ''
          ELSE
            "Value Type" := FORMAT(JSONTextReader.ValueType);
          Path := JSONTextReader.Path;
          INSERT;
        UNTIL NOT JSONTextReader.Read;
    END;

    PROCEDURE FindArray@1(VAR TempJSONBuffer@1000 : TEMPORARY Record 1236;ArrayName@1001 : Text) : Boolean;
    BEGIN
      TempJSONBuffer.COPY(Rec,TRUE);
      TempJSONBuffer.RESET;

      TempJSONBuffer.SETRANGE(Path,AppendPathToCurrent(ArrayName));
      IF NOT TempJSONBuffer.FINDFIRST THEN
        EXIT(FALSE);
      TempJSONBuffer.SETFILTER(Path,AppendPathToCurrent(ArrayName) + '[*');
      TempJSONBuffer.SETRANGE(Depth,TempJSONBuffer.Depth + 1);
      TempJSONBuffer.SETFILTER("Token type",'<>%1',"Token type"::"End Object");
      EXIT(TempJSONBuffer.FINDSET);
    END;

    PROCEDURE GetPropertyValue@4(VAR PropertyValue@1002 : Text;PropertyName@1000 : Text) : Boolean;
    VAR
      TempJSONBuffer@1001 : TEMPORARY Record 1236;
    BEGIN
      TempJSONBuffer.COPY(Rec,TRUE);
      TempJSONBuffer.RESET;

      TempJSONBuffer.SETFILTER(Path,Path + '*');
      TempJSONBuffer.SETRANGE("Token type","Token type"::"Property Name");
      TempJSONBuffer.SETRANGE(Value,PropertyName);
      IF NOT TempJSONBuffer.FINDFIRST THEN
        EXIT;
      IF TempJSONBuffer.GET(TempJSONBuffer."Entry No." + 1) THEN BEGIN
        PropertyValue := TempJSONBuffer.GetValue;
        EXIT(TRUE);
      END;
    END;

    PROCEDURE GetBooleanPropertyValue@6(VAR BooleanValue@1002 : Boolean;PropertyName@1000 : Text) : Boolean;
    VAR
      PropertyValue@1003 : Text;
    BEGIN
      IF GetPropertyValue(PropertyValue,PropertyName) THEN
        EXIT(EVALUATE(BooleanValue,PropertyValue));
    END;

    PROCEDURE GetDatePropertyValue@7(VAR DateValue@1002 : Date;PropertyName@1000 : Text) : Boolean;
    VAR
      PropertyValue@1003 : Text;
    BEGIN
      IF GetPropertyValue(PropertyValue,PropertyName) THEN
        EXIT(EVALUATE(DateValue,PropertyValue));
    END;

    PROCEDURE GetDecimalPropertyValue@5(VAR DecimalValue@1002 : Decimal;PropertyName@1000 : Text) : Boolean;
    VAR
      PropertyValue@1003 : Text;
    BEGIN
      IF GetPropertyValue(PropertyValue,PropertyName) THEN
        EXIT(EVALUATE(DecimalValue,PropertyValue));
    END;

    LOCAL PROCEDURE AppendPathToCurrent@3(AppendPath@1000 : Text) : Text;
    BEGIN
      IF Path <> '' THEN
        EXIT(Path + '.' + AppendPath);
      EXIT(AppendPath)
    END;

    PROCEDURE GetValue@16() : Text;
    VAR
      TempBlob@1000 : Record 99008535;
      CR@1001 : Text[1];
    BEGIN
      CALCFIELDS("Value BLOB");
      IF NOT "Value BLOB".HASVALUE THEN
        EXIT(Value);
      CR[1] := 10;
      TempBlob.Blob := "Value BLOB";
      EXIT(TempBlob.ReadAsText(CR,TEXTENCODING::Windows));
    END;

    PROCEDURE SetValue@17(NewValue@1001 : Text);
    BEGIN
      SetValueWithoutModifying(NewValue);
      MODIFY;
    END;

    PROCEDURE SetValueWithoutModifying@12(NewValue@1001 : Text);
    VAR
      TempBlob@1000 : Record 99008535;
    BEGIN
      CLEAR("Value BLOB");
      Value := COPYSTR(NewValue,1,MAXSTRLEN(Value));
      IF STRLEN(NewValue) <= MAXSTRLEN(Value) THEN
        EXIT; // No need to store anything in the blob
      IF NewValue = '' THEN
        EXIT;
      TempBlob.WriteAsText(NewValue,TEXTENCODING::Windows);
      "Value BLOB" := TempBlob.Blob;
    END;

    BEGIN
    END.
  }
}

