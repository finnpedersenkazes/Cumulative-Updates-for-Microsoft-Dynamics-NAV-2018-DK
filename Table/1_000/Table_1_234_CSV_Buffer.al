OBJECT Table 1234 CSV Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=CSV-buffer;
               ENU=CSV Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Line No.            ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Linjenr.;
                                                              ENU=Line No.] }
    { 2   ;   ;Field No.           ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Feltnr.;
                                                              ENU=Field No.] }
    { 3   ;   ;Value               ;Text250       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=V‘rdi;
                                                              ENU=Value] }
  }
  KEYS
  {
    {    ;Line No.,Field No.                      ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      IndexDoesNotExistErr@1000 : TextConst '@@@="%1 = line no, %2 = index of the field";DAN=Feltet i linje %1 med indeks %2 findes ikke. Dataene kunne ikke hentes.;ENU=The field in line %1 with index %2 does not exist. The data could not be retrieved.';
      CSVFile@1002 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.File";
      StreamReader@1003 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.StreamReader";
      Separator@1004 : Text[1];

    [External]
    PROCEDURE InsertEntry@12(LineNo@1001 : Integer;FieldNo@1002 : Integer;FieldValue@1003 : Text[250]);
    BEGIN
      INIT;
      "Line No." := LineNo;
      "Field No." := FieldNo;
      Value := FieldValue;
      INSERT;
    END;

    [Internal]
    PROCEDURE LoadData@1(CSVFileName@1000 : Text;CSVFieldSeparator@1001 : Text[1]);
    BEGIN
      InitializeReader(CSVFileName,CSVFieldSeparator);
      ReadLines(0);
      StreamReader.Close;
    END;

    [Internal]
    PROCEDURE SaveData@10(CSVFileName@1000 : Text;CSVFieldSeparator@1001 : Text[1]);
    VAR
      FileMode@1002 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.FileMode";
      StreamWriter@1004 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.StreamWriter";
      NumberOfColumns@1003 : Integer;
    BEGIN
      StreamWriter := StreamWriter.StreamWriter(CSVFile.Open(CSVFileName,FileMode.Create));
      NumberOfColumns := GetNumberOfColumns;
      IF FINDSET THEN
        REPEAT
          StreamWriter.Write(Value);
          IF "Field No." < NumberOfColumns THEN
            StreamWriter.Write(CSVFieldSeparator)
          ELSE
            StreamWriter.WriteLine;
        UNTIL NEXT = 0;
      StreamWriter.Close;
    END;

    [Internal]
    PROCEDURE InitializeReader@2(CSVFileName@1000 : Text;CSVFieldSeparator@1001 : Text[1]);
    VAR
      Encoding@1003 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Text.Encoding";
    BEGIN
      StreamReader := StreamReader.StreamReader(CSVFile.OpenRead(CSVFileName),Encoding.Default);
      Separator := CSVFieldSeparator;
    END;

    [Internal]
    PROCEDURE ReadLines@3(NumberOfLines@1000 : Integer) : Boolean;
    VAR
      String@1004 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.String";
      CurrentLineNo@1002 : Integer;
      CurrentFieldNo@1003 : Integer;
      CurrentIndex@1005 : Integer;
      NextIndex@1006 : Integer;
      Length@1007 : Integer;
    BEGIN
      IF StreamReader.EndOfStream THEN
        EXIT(FALSE);
      REPEAT
        String := StreamReader.ReadLine;
        CurrentLineNo += 1;
        CurrentIndex := 0;
        REPEAT
          CurrentFieldNo += 1;
          INIT;
          "Line No." := CurrentLineNo;
          "Field No." := CurrentFieldNo;
          NextIndex := String.IndexOf(Separator,CurrentIndex);
          IF NextIndex = -1 THEN
            Length := String.Length - CurrentIndex
          ELSE
            Length := NextIndex - CurrentIndex;
          IF Length > 250 THEN
            Length := 250;
          Value := String.Substring(CurrentIndex,Length);
          CurrentIndex := NextIndex + 1;
          INSERT;
        UNTIL NextIndex = -1;
        CurrentFieldNo := 0;
      UNTIL StreamReader.EndOfStream OR (CurrentLineNo = NumberOfLines);
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE ResetFilters@5();
    BEGIN
      SETRANGE("Line No.");
      SETRANGE("Field No.");
      SETRANGE(Value);
    END;

    [External]
    PROCEDURE GetValue@6(LineNo@1000 : Integer;FieldNo@1001 : Integer) : Text[250];
    VAR
      TempCSVBuffer@1002 : TEMPORARY Record 1234;
    BEGIN
      TempCSVBuffer.COPY(Rec,TRUE);
      IF NOT TempCSVBuffer.GET(LineNo,FieldNo) THEN
        ERROR(IndexDoesNotExistErr,LineNo,FieldNo);
      EXIT(TempCSVBuffer.Value);
    END;

    [External]
    PROCEDURE GetCSVLinesWhere@7(FilterFieldNo@1000 : Integer;FilterValue@1001 : Text;VAR TempResultCSVBuffer@1002 : TEMPORARY Record 1234);
    VAR
      TempCSVBuffer@1004 : TEMPORARY Record 1234;
    BEGIN
      TempResultCSVBuffer.RESET;
      TempResultCSVBuffer.DELETEALL;
      TempCSVBuffer.COPY(Rec,TRUE);
      SETRANGE("Field No.",FilterFieldNo);
      SETRANGE(Value,FilterValue);
      IF FINDSET THEN
        REPEAT
          TempCSVBuffer.SETRANGE("Line No.","Line No.");
          TempCSVBuffer.FINDSET;
          REPEAT
            TempResultCSVBuffer := TempCSVBuffer;
            TempResultCSVBuffer.INSERT;
          UNTIL TempCSVBuffer.NEXT = 0;
        UNTIL NEXT = 0;
      TempResultCSVBuffer.SETRANGE("Field No.",1);
    END;

    [External]
    PROCEDURE GetValueOfLineAt@8(FieldNo@1000 : Integer) : Text[250];
    VAR
      TempCSVBuffer@1001 : TEMPORARY Record 1234;
    BEGIN
      TempCSVBuffer.COPY(Rec,TRUE);
      IF NOT TempCSVBuffer.GET("Line No.",FieldNo) THEN
        ERROR(IndexDoesNotExistErr,"Line No.",FieldNo);
      EXIT(TempCSVBuffer.Value);
    END;

    [External]
    PROCEDURE GetNumberOfColumns@4() : Integer;
    VAR
      TempCSVBuffer@1000 : TEMPORARY Record 1234;
    BEGIN
      TempCSVBuffer.COPY(Rec,TRUE);
      TempCSVBuffer.ResetFilters;
      TempCSVBuffer.SETRANGE("Line No.","Line No.");
      IF TempCSVBuffer.FINDLAST THEN
        EXIT(TempCSVBuffer."Field No.");

      EXIT(0);
    END;

    [External]
    PROCEDURE GetNumberOfLines@9() : Integer;
    BEGIN
      IF FINDLAST THEN
        EXIT("Line No.");

      EXIT(0);
    END;

    BEGIN
    END.
  }
}

