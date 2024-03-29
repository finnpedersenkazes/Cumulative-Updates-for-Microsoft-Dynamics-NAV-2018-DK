OBJECT Codeunit 10 Type Helper
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      UnsupportedTypeErr@1000 : TextConst 'DAN=Typen underst�ttes ikke af funktionen Evaluer.;ENU=The Type is not supported by the Evaluate function.';
      KeyDoesNotExistErr@1001 : TextConst 'DAN=Den kr�vede n�gle findes ikke.;ENU=The requested key does not exist.';
      InvalidMonthErr@1002 : TextConst 'DAN=Der er angivet en ugyldig m�ned.;ENU=An invalid month was specified.';
      StringTooLongErr@1003 : TextConst '@@@="%1=a number, e.g. 1024";DAN=Denne funktion tillader kun strenge med en l�ngde op til %1.;ENU=This function only allows strings of length up to %1.';
      UnsupportedNegativesErr@1004 : TextConst '@@@="%1=function name";DAN=Negative parametre underst�ttes ikke af den bitvise funktion %1.;ENU=Negative parameters are not supported by bitwise function %1.';
      BitwiseAndTxt@1005 : TextConst '@@@={Locked};DAN=BitwiseAnd;ENU=BitwiseAnd';
      BitwiseOrTxt@1006 : TextConst '@@@={Locked};DAN=BitwiseOr;ENU=BitwiseOr';
      BitwiseXorTxt@1007 : TextConst '@@@={Locked};DAN=BitwiseXor;ENU=BitwiseXor';
      ObsoleteFieldErr@1008 : TextConst '@@@=%1 - field name, %2 - table name;DAN=Feltet %1 i tabellen %2 er for�ldet og kan ikke bruges.;ENU=The field %1 of %2 table is obsolete and cannot be used.';

    [External]
    PROCEDURE Evaluate@3(VAR Variable@1000 : Variant;String@1001 : Text;Format@1002 : Text;CultureName@1003 : Text) : Boolean;
    BEGIN
      // Variable is return type containing the string value
      // String is input to evaluate
      // Format is in format "MM/dd/yyyy" only supported on date, search MSDN for more details ("CultureInfo.Name Property")
      // CultureName is in format "en-US", search MSDN for more details ("Custom Date and Time Format Strings")
      CASE TRUE OF
        Variable.ISDATE:
          EXIT(TryEvaluateDate(String,Format,CultureName,Variable));
        Variable.ISDATETIME:
          EXIT(TryEvaluateDateTime(String,Format,CultureName,Variable));
        Variable.ISDECIMAL:
          EXIT(TryEvaluateDecimal(String,CultureName,Variable));
        Variable.ISINTEGER:
          EXIT(TryEvaluateInteger(String,CultureName,Variable));
        ELSE
          ERROR(UnsupportedTypeErr);
      END;
    END;

    LOCAL PROCEDURE TryEvaluateDate@12(DateText@1000 : Text;Format@1001 : Text;CultureName@1004 : Text;VAR EvaluatedDate@1006 : Date) : Boolean;
    VAR
      CultureInfo@1003 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Globalization.CultureInfo";
      DotNetDateTime@1002 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.DateTime";
      DateTimeStyles@1005 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Globalization.DateTimeStyles";
      XMLConvert@1007 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlConvert";
    BEGIN
      IF (Format = '') AND (CultureName = '') THEN
        DotNetDateTime := XMLConvert.ToDateTimeOffset(DateText).DateTime
      ELSE BEGIN
        DotNetDateTime := DotNetDateTime.DateTime(0);
        CultureInfo := CultureInfo.GetCultureInfo(CultureName);
        CASE Format OF
          '':
            IF NOT DotNetDateTime.TryParse(DateText,CultureInfo,DateTimeStyles.None,DotNetDateTime) THEN
              EXIT(FALSE);
          ELSE
            IF NOT DotNetDateTime.TryParseExact(DateText,Format,CultureInfo,DateTimeStyles.None,DotNetDateTime) THEN
              EXIT(FALSE);
        END;
      END;

      EvaluatedDate := DMY2DATE(DotNetDateTime.Day,DotNetDateTime.Month,DotNetDateTime.Year);
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE TryEvaluateDateTime@41(DateTimeText@1000 : Text;Format@1001 : Text;CultureName@1004 : Text;VAR EvaluatedDateTime@1006 : DateTime) : Boolean;
    VAR
      CultureInfo@1003 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Globalization.CultureInfo";
      DotNetDateTime@1002 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.DateTime";
      DateTimeStyles@1005 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Globalization.DateTimeStyles";
      EvaluatedTime@1008 : Time;
    BEGIN
      DotNetDateTime := DotNetDateTime.DateTime(0);
      IF CultureName = '' THEN
        CultureInfo := CultureInfo.InvariantCulture
      ELSE
        CultureInfo := CultureInfo.GetCultureInfo(CultureName);
      CASE Format OF
        '':
          IF NOT DotNetDateTime.TryParse(DateTimeText,CultureInfo,DateTimeStyles.None,DotNetDateTime) THEN
            EXIT(FALSE);
        ELSE
          IF NOT DotNetDateTime.TryParseExact(DateTimeText,Format,CultureInfo,DateTimeStyles.None,DotNetDateTime) THEN
            EXIT(FALSE);
      END;

      IF NOT EVALUATE(
           EvaluatedTime,
           STRSUBSTNO(
             '%1:%2:%3.%4',
             DotNetDateTime.Hour,
             DotNetDateTime.Minute,
             DotNetDateTime.Second,
             DotNetDateTime.Millisecond))
      THEN
        EXIT(FALSE);
      EvaluatedDateTime :=
        CREATEDATETIME(
          DMY2DATE(DotNetDateTime.Day,DotNetDateTime.Month,DotNetDateTime.Year),EvaluatedTime);
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE TryEvaluateDecimal@13(DecimalText@1000 : Text;CultureName@1001 : Text;VAR EvaluatedDecimal@1006 : Decimal) : Boolean;
    VAR
      CultureInfo@1003 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Globalization.CultureInfo";
      DotNetDecimal@1002 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Decimal";
      NumberStyles@1004 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Globalization.NumberStyles";
    BEGIN
      EvaluatedDecimal := 0;
      IF DotNetDecimal.TryParse(DecimalText,NumberStyles.Number,CultureInfo.GetCultureInfo(CultureName),EvaluatedDecimal) THEN
        EXIT(TRUE);
      EXIT(FALSE)
    END;

    LOCAL PROCEDURE TryEvaluateInteger@21(IntegerText@1000 : Text;CultureName@1001 : Text;VAR EvaluatedInteger@1006 : Integer) : Boolean;
    VAR
      CultureInfo@1003 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Globalization.CultureInfo";
      DotNetInteger@1002 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Int32";
      NumberStyles@1004 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Globalization.NumberStyles";
    BEGIN
      EvaluatedInteger := 0;
      IF DotNetInteger.TryParse(IntegerText,NumberStyles.Number,CultureInfo.GetCultureInfo(CultureName),EvaluatedInteger) THEN
        EXIT(TRUE);
      EXIT(FALSE)
    END;

    [External]
    PROCEDURE GetLocalizedMonthToInt@22(Month@1000 : Text) : Integer;
    VAR
      TestMonth@1002 : Text;
      Result@1001 : Integer;
    BEGIN
      Month := LOWERCASE(Month);

      FOR Result := 1 TO 12 DO BEGIN
        TestMonth := LOWERCASE(FORMAT(CALCDATE(STRSUBSTNO('<CY+%1M>',Result)),0,'<Month Text>'));
        IF Month = TestMonth THEN
          EXIT(Result);
      END;

      ERROR(InvalidMonthErr);
    END;

    [External]
    PROCEDURE CompareDateTime@37(DateTimeA@1000 : DateTime;DateTimeB@1001 : DateTime) : Integer;
    BEGIN
      // Compares the specified DateTime values for equality within a small threshold.
      // Returns 1 if DateTimeA > DateTimeB, -1 if DateTimeB > DateTimeA, and 0 if they
      // are equal.

      // The threshold must be used to compensate for the varying levels of precision
      // when storing DateTime values. An example of this is the T-SQL datetime type,
      // which has a precision that goes down to the nearest 0, 3, or 7 milliseconds.

      CASE TRUE OF
        DateTimeA = DateTimeB:
          EXIT(0);
        DateTimeA = 0DT:
          EXIT(-1);
        DateTimeB = 0DT:
          EXIT(1);
        ABS(DateTimeA - DateTimeB) < 10:
          EXIT(0);
        DateTimeA > DateTimeB:
          EXIT(1);
        ELSE
          EXIT(-1);
      END;
    END;

    [External]
    PROCEDURE FormatDate@25(DateToFormat@1000 : Date;LanguageId@1003 : Integer) : Text;
    VAR
      CultureInfo@1004 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Globalization.CultureInfo";
      DateTimeFormatInfo@1007 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Globalization.DateTimeFormatInfo";
      DotNetDateTime@1001 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.DateTime";
    BEGIN
      CultureInfo := CultureInfo.GetCultureInfo(LanguageId);
      DateTimeFormatInfo := CultureInfo.DateTimeFormat;
      DotNetDateTime := DotNetDateTime.DateTime(DATE2DMY(DateToFormat,3),DATE2DMY(DateToFormat,2),DATE2DMY(DateToFormat,1));
      EXIT(DotNetDateTime.ToString('d',DateTimeFormatInfo));
    END;

    [External]
    PROCEDURE IsLeapYear@46(Date@1001 : Date) : Boolean;
    VAR
      DateTime@1000 : DotNet "'mscorlib'.System.DateTime";
    BEGIN
      EXIT(DateTime.IsLeapYear(DATE2DMY(Date,3)));
    END;

    [External]
    PROCEDURE LanguageIDToCultureName@4(LanguageID@1001 : Integer) : Text;
    VAR
      CultureInfo@1000 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Globalization.CultureInfo";
    BEGIN
      CultureInfo := CultureInfo.GetCultureInfo(LanguageID);
      EXIT(CultureInfo.Name);
    END;

    [External]
    PROCEDURE GetOptionNo@20(Value@1007 : Text;OptionString@1006 : Text) : Integer;
    VAR
      OptionNo@1001 : Integer;
      OptionsQty@1000 : Integer;
    BEGIN
      Value := UPPERCASE(Value);
      OptionString := UPPERCASE(OptionString);

      IF (Value = '') AND (STRPOS(OptionString,' ') = 1) THEN
        EXIT(0);
      IF (Value <> '') AND (STRPOS(OptionString,Value) = 0) THEN
        EXIT(-1);

      OptionsQty := GetNumberOfOptions(OptionString);
      IF OptionsQty > 0 THEN BEGIN
        FOR OptionNo := 0 TO OptionsQty - 1 DO BEGIN
          IF OptionsAreEqual(Value,COPYSTR(OptionString,1,STRPOS(OptionString,',') - 1)) THEN
            EXIT(OptionNo);
          OptionString := DELSTR(OptionString,1,STRPOS(OptionString,','));
        END;
        OptionNo += 1;
      END;

      IF OptionsAreEqual(Value,OptionString) THEN
        EXIT(OptionNo);

      EXIT(-1);
    END;

    [External]
    PROCEDURE GetNumberOfOptions@11(OptionString@1000 : Text) : Integer;
    BEGIN
      EXIT(STRLEN(OptionString) - STRLEN(DELCHR(OptionString,'=',',')));
    END;

    LOCAL PROCEDURE OptionsAreEqual@18(Value@1000 : Text;CurrentOption@1001 : Text) : Boolean;
    BEGIN
      EXIT(((Value <> '') AND (Value = CurrentOption)) OR ((Value = '') AND (CurrentOption = ' ')));
    END;

    [External]
    PROCEDURE IsNumeric@47(Text@1000 : Text) : Boolean;
    VAR
      Decimal@1001 : Decimal;
    BEGIN
      EXIT(EVALUATE(Decimal,Text));
    END;

    [External]
    PROCEDURE FindFields@64(TableNo@1001 : Integer;VAR Field@1000 : Record 2000000041) : Boolean;
    BEGIN
      Field.SETRANGE(TableNo,TableNo);
      Field.SETFILTER(ObsoleteState,'<>%1',Field.ObsoleteState::Removed);
      EXIT(Field.FINDSET);
    END;

    [External]
    PROCEDURE GetField@63(TableNo@1000 : Integer;FieldNo@1001 : Integer;VAR Field@1002 : Record 2000000041) : Boolean;
    BEGIN
      EXIT(Field.GET(TableNo,FieldNo) AND (Field.ObsoleteState <> Field.ObsoleteState::Removed));
    END;

    [External]
    PROCEDURE GetFieldLength@1(TableNo@1000 : Integer;FieldNo@1001 : Integer) : Integer;
    VAR
      Field@1002 : Record 2000000041;
    BEGIN
      IF GetField(TableNo,FieldNo,Field) THEN
        EXIT(Field.Len);

      EXIT(0);
    END;

    [External]
    PROCEDURE TestFieldIsNotObsolete@66(Field@1000 : Record 2000000041);
    BEGIN
      IF Field.ObsoleteState = Field.ObsoleteState::Removed THEN
        ERROR(ObsoleteFieldErr);
    END;

    [External]
    PROCEDURE Equals@2(ThisRecRef@1000 : RecordRef;OtherRecRef@1003 : RecordRef;SkipBlob@1006 : Boolean) : Boolean;
    VAR
      Field@1004 : Record 2000000041;
      Key@1005 : Record 2000000063;
      OtherFieldRef@1002 : FieldRef;
      ThisFieldRef@1001 : FieldRef;
    BEGIN
      IF ThisRecRef.NUMBER <> OtherRecRef.NUMBER THEN
        EXIT(FALSE);

      IF ThisRecRef.KEYCOUNT = ThisRecRef.FIELDCOUNT THEN
        EXIT(FALSE);

      FindFields(ThisRecRef.NUMBER,Field);
      REPEAT
        IF NOT Key.GET(ThisRecRef.NUMBER,Field."No.") THEN BEGIN
          ThisFieldRef := ThisRecRef.FIELD(Field."No.");
          OtherFieldRef := OtherRecRef.FIELD(Field."No.");

          CASE Field.Type OF
            Field.Type::BLOB,Field.Type::Binary:
              IF NOT SkipBlob THEN
                IF ReadBlob(ThisFieldRef) <> ReadBlob(OtherFieldRef) THEN
                  EXIT(FALSE);
            ELSE
              IF ThisFieldRef.VALUE <> OtherFieldRef.VALUE THEN
                EXIT(FALSE);
          END;
        END;
      UNTIL Field.NEXT = 0;

      EXIT(TRUE);
    END;

    [External]
    PROCEDURE GetBlobString@33(RecordVariant@1000 : Variant;FieldNo@1001 : Integer) : Text;
    VAR
      RecordRef@1002 : RecordRef;
      FieldRef@1003 : FieldRef;
    BEGIN
      RecordRef.GETTABLE(RecordVariant);
      FieldRef := RecordRef.FIELD(FieldNo);
      EXIT(ReadBlob(FieldRef));
    END;

    [External]
    PROCEDURE SetBlobString@35(RecordRef@1000 : RecordRef;FieldNo@1001 : Integer;Value@1004 : Text);
    VAR
      FieldRef@1003 : FieldRef;
    BEGIN
      FieldRef := RecordRef.FIELD(FieldNo);
      WriteBlob(FieldRef,Value);
    END;

    [External]
    PROCEDURE ReadBlob@7(VAR BlobFieldRef@1000 : FieldRef) Content : Text;
    VAR
      TempBlob@1001 : Record 99008535;
      InStream@1002 : InStream;
    BEGIN
      TempBlob.Blob := BlobFieldRef.VALUE;
      IF NOT TempBlob.Blob.HASVALUE THEN BEGIN
        BlobFieldRef.CALCFIELD;
        TempBlob.Blob := BlobFieldRef.VALUE;
      END;
      TempBlob.Blob.CREATEINSTREAM(InStream,TEXTENCODING::UTF8);
      InStream.READ(Content);

      BlobFieldRef.VALUE := TempBlob.Blob;
    END;

    [External]
    PROCEDURE ReadTextBlob@14(VAR BlobFieldRef@1000 : FieldRef;LineSeparator@1002 : Text) : Text;
    BEGIN
      EXIT(ReadTextBlobWithEncoding(BlobFieldRef,LineSeparator,TEXTENCODING::MSDos));
    END;

    [External]
    PROCEDURE WriteBlobWithEncoding@38(VAR BlobFieldRef@1004 : FieldRef;NewContent@1003 : Text;TextEncoding@1000 : TextEncoding) : Boolean;
    VAR
      TempBlob@1001 : Record 99008535;
      OutStream@1002 : OutStream;
    BEGIN
      BlobFieldRef.CALCFIELD;
      TempBlob.Blob.CREATEOUTSTREAM(OutStream,TextEncoding);
      OutStream.WRITE(NewContent);
      BlobFieldRef.VALUE := TempBlob.Blob;

      EXIT(TRUE);
    END;

    [External]
    PROCEDURE WriteBlob@24(VAR BlobFieldRef@1004 : FieldRef;NewContent@1003 : Text) : Boolean;
    VAR
      TempBlob@1001 : Record 99008535;
      OutStream@1002 : OutStream;
    BEGIN
      BlobFieldRef.CALCFIELD;
      TempBlob.Blob.CREATEOUTSTREAM(OutStream,TEXTENCODING::UTF8);
      OutStream.WRITE(NewContent);
      BlobFieldRef.VALUE := TempBlob.Blob;

      EXIT(TRUE);
    END;

    [External]
    PROCEDURE WriteTextToBlobIfChanged@15(VAR BlobFieldRef@1000 : FieldRef;NewContent@1003 : Text;Encoding@1007 : TextEncoding) : Boolean;
    VAR
      TempBlob@1004 : TEMPORARY Record 99008535;
      OutStream@1002 : OutStream;
      OldContent@1005 : Text;
    BEGIN
      // Returns TRUE if the value was changed, FALSE if the old value was identical and no change was needed
      OldContent := ReadTextBlobWithTextEncoding(BlobFieldRef,Encoding);
      IF NewContent = OldContent THEN
        EXIT(FALSE);

      TempBlob.INIT;
      TempBlob.Blob.CREATEOUTSTREAM(OutStream,Encoding);
      OutStream.WRITETEXT(NewContent);
      TempBlob.INSERT;

      BlobFieldRef.VALUE := TempBlob.Blob;
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE ReadTextBlobWithEncoding@8(VAR BlobFieldRef@1000 : FieldRef;LineSeparator@1003 : Text;Encoding@1002 : TextEncoding) : Text;
    VAR
      TempBlob@1001 : Record 99008535;
    BEGIN
      BlobFieldRef.CALCFIELD;

      TempBlob.INIT;
      TempBlob.Blob := BlobFieldRef.VALUE;

      EXIT(TempBlob.ReadAsText(LineSeparator,Encoding));
    END;

    [External]
    PROCEDURE IsMatch@6(Input@1000 : Text;RegExExpression@1003 : Text) : Boolean;
    VAR
      Regex@1002 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Text.RegularExpressions.Regex";
      AlphanumericRegEx@1001 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Text.RegularExpressions.Regex";
    BEGIN
      AlphanumericRegEx := Regex.Regex(RegExExpression);
      EXIT(AlphanumericRegEx.IsMatch(Input));
    END;

    [External]
    PROCEDURE IsAlphanumeric@9(Input@1000 : Text) : Boolean;
    BEGIN
      EXIT(IsMatch(Input,'^[a-zA-Z0-9]*$'));
    END;

    [External]
    PROCEDURE IsPhoneNumber@29(Input@1000 : Text) : Boolean;
    BEGIN
      EXIT(IsMatch(Input,'^[\(\)\-\+0-9 ]*$'));
    END;

    [External]
    PROCEDURE ReadTextBlobWithTextEncoding@17(VAR BlobFieldRef@1002 : FieldRef;Encoding@1000 : TextEncoding) BlobContent : Text;
    VAR
      TempBlob@1001 : Record 99008535;
      InStream@1003 : InStream;
    BEGIN
      TempBlob.INIT;
      BlobFieldRef.CALCFIELD;
      TempBlob.Blob := BlobFieldRef.VALUE;
      TempBlob.Blob.CREATEINSTREAM(InStream,Encoding);
      IF InStream.READ(BlobContent) = 0 THEN;
    END;

    [TryFunction]
    [External]
    PROCEDURE GetUserTimezoneOffset@5(VAR Duration@1001 : Duration);
    VAR
      UserPersonalization@1004 : Record 2000000073;
      TimeZoneInfo@1003 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.TimeZoneInfo";
      TimeZone@1000 : Text;
    BEGIN
      UserPersonalization.GET(USERSECURITYID);
      TimeZone := UserPersonalization."Time Zone";
      TimeZoneInfo := TimeZoneInfo.FindSystemTimeZoneById(TimeZone);

      Duration := TimeZoneInfo.BaseUtcOffset;
    END;

    [External]
    PROCEDURE EvaluateUnixTimestamp@19(Timestamp@1002 : BigInteger) : DateTime;
    VAR
      ResultDateTime@1000 : DateTime;
      EpochDateTime@1001 : DateTime;
      TimezoneOffset@1003 : Duration;
      TimestampInMilliseconds@1004 : BigInteger;
    BEGIN
      IF NOT GetUserTimezoneOffset(TimezoneOffset) THEN
        TimezoneOffset := 0;

      EpochDateTime := CREATEDATETIME(DMY2DATE(1,1,1970),0T);

      TimestampInMilliseconds := Timestamp * 1000;

      ResultDateTime := EpochDateTime + TimestampInMilliseconds + TimezoneOffset;

      EXIT(ResultDateTime);
    END;

    [External]
    PROCEDURE EvaluateUTCDateTime@42(DateTimeText@1000 : Text) EvaluatedDateTime : DateTime;
    VAR
      TypeHelper@1003 : Codeunit 10;
      Value@1001 : Variant;
    BEGIN
      Value := EvaluatedDateTime;
      IF TypeHelper.Evaluate(Value,DateTimeText,'R','') THEN
        EvaluatedDateTime := Value;
    END;

    [External]
    PROCEDURE FormatDateTime@44(FormattingDateTime@1001 : DateTime;Format@1000 : Text;CultureName@1004 : Text) : Text;
    VAR
      CultureInfo@1002 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Globalization.CultureInfo";
      DateTimeOffset@1010 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.DateTimeOffset";
    BEGIN
      IF CultureName = '' THEN
        CultureInfo := CultureInfo.InvariantCulture
      ELSE
        CultureInfo := CultureInfo.GetCultureInfo(CultureName);

      DateTimeOffset := DateTimeOffset.DateTimeOffset(FormattingDateTime);
      DateTimeOffset := DateTimeOffset.ToLocalTime;

      EXIT(DateTimeOffset.ToString(Format,CultureInfo));
    END;

    [External]
    PROCEDURE GetCurrUTCDateTime@50() : DateTime;
    VAR
      DotNetDateTime@1000 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.DateTime";
    BEGIN
      DotNetDateTime := DotNetDateTime.UtcNow;
      EXIT(DotNetDateTime)
    END;

    [External]
    PROCEDURE GetCurrUTCDateTimeAsText@49() : Text;
    BEGIN
      EXIT(FormatDateTime(GetCurrUTCDateTime,'R',''));
    END;

    [External]
    PROCEDURE UrlEncode@10(VAR Value@1000 : Text) : Text;
    VAR
      HttpUtility@1001 : DotNet "'System.Web, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'.System.Web.HttpUtility";
    BEGIN
      Value := HttpUtility.UrlEncode(Value);
      EXIT(Value);
    END;

    [External]
    PROCEDURE HtmlEncode@32(VAR Value@1000 : Text) : Text;
    VAR
      HttpUtility@1001 : DotNet "'System.Web, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'.System.Web.HttpUtility";
    BEGIN
      Value := HttpUtility.HtmlEncode(Value);
      EXIT(Value);
    END;

    [External]
    PROCEDURE GetKeyAsString@16(RecordVariant@1000 : Variant;KeyIndex@1001 : Integer) : Text;
    VAR
      DataTypeManagement@1008 : Codeunit 701;
      RecRef@1007 : RecordRef;
      SelectedKeyRef@1006 : KeyRef;
      KeyFieldRef@1005 : FieldRef;
      I@1004 : Integer;
      KeyString@1003 : Text;
      Separator@1002 : Text;
    BEGIN
      DataTypeManagement.GetRecordRef(RecordVariant,RecRef);

      IF RecRef.KEYCOUNT < KeyIndex THEN
        ERROR(KeyDoesNotExistErr);

      SelectedKeyRef := RecRef.KEYINDEX(KeyIndex);

      FOR I := 1 TO SelectedKeyRef.FIELDCOUNT DO BEGIN
        KeyFieldRef := SelectedKeyRef.FIELDINDEX(I);
        KeyString += Separator + KeyFieldRef.NAME;
        Separator := ',';
      END;

      EXIT(KeyString);
    END;

    [External]
    PROCEDURE ConvertValueFromBase64@61(base64Value@1001 : Text) stringValue : Text;
    VAR
      Convert@1002 : DotNet "'mscorlib'.System.Convert";
      Encoding@1000 : DotNet "'mscorlib'.System.Text.Encoding";
    BEGIN
      IF base64Value = '' THEN
        EXIT('');

      stringValue := Encoding.UTF8.GetString(Convert.FromBase64String(base64Value));
      EXIT(stringValue);
    END;

    [External]
    PROCEDURE ConvertValueToBase64@60(stringValue@1001 : Text) base64Value : Text;
    VAR
      Convert@1002 : DotNet "'mscorlib'.System.Convert";
      Encoding@1000 : DotNet "'mscorlib'.System.Text.Encoding";
    BEGIN
      IF stringValue = '' THEN
        EXIT('');

      base64Value := Convert.ToBase64String(Encoding.UTF8.GetBytes(stringValue));
      EXIT(base64Value);
    END;

    [External]
    PROCEDURE SortRecordRef@28(VAR RecRef@1000 : RecordRef;CommaSeparatedFieldsToSort@1001 : Text;Ascending@1002 : Boolean);
    VAR
      OrderString@1003 : Text;
    BEGIN
      IF Ascending THEN
        OrderString := 'ORDER(Ascending)'
      ELSE
        OrderString := 'ORDER(Descending)';

      RecRef.SETVIEW(STRSUBSTNO('SORTING(%1) %2',CommaSeparatedFieldsToSort,OrderString));
      IF RecRef.FINDSET THEN ;
    END;

    [External]
    PROCEDURE TextDistance@23(Text1@1000 : Text;Text2@1001 : Text) : Integer;
    VAR
      Array1@1002 : ARRAY [1026] OF Integer;
      Array2@1003 : ARRAY [1026] OF Integer;
      i@1004 : Integer;
      j@1005 : Integer;
      Cost@1006 : Integer;
      MaxLen@1007 : Integer;
    BEGIN
      // Returns the number of edits to get from Text1 to Text2
      // Reference: https://en.wikipedia.org/wiki/Levenshtein_distance
      IF (STRLEN(Text1) + 2 > ARRAYLEN(Array1)) OR (STRLEN(Text2) + 2 > ARRAYLEN(Array1)) THEN
        ERROR(StringTooLongErr,ARRAYLEN(Array1) - 2);
      IF Text1 = Text2 THEN
        EXIT(0);
      IF Text1 = '' THEN
        EXIT(STRLEN(Text2));
      IF Text2 = '' THEN
        EXIT(STRLEN(Text1));

      IF STRLEN(Text1) >= STRLEN(Text2) THEN
        MaxLen := STRLEN(Text1)
      ELSE
        MaxLen := STRLEN(Text2);

      FOR i := 0 TO MaxLen + 1 DO
        Array1[i + 1] := i;

      FOR i := 0 TO STRLEN(Text1) - 1 DO BEGIN
        Array2[1] := i + 1;
        FOR j := 0 TO STRLEN(Text2) - 1 DO BEGIN
          IF Text1[i + 1] = Text2[j + 1] THEN
            Cost := 0
          ELSE
            Cost := 1;
          Array2[j + 2] := MinimumInt3(Array2[j + 1] + 1,Array1[j + 2] + 1,Array1[j + 1] + Cost);
        END;
        FOR j := 1 TO MaxLen + 2 DO
          Array1[j] := Array2[j];
      END;
      EXIT(Array2[STRLEN(Text2) + 1]);
    END;

    [External]
    PROCEDURE NewLine@48() : Text;
    VAR
      Environment@1000 : DotNet "'mscorlib'.System.Environment";
    BEGIN
      EXIT(Environment.NewLine);
    END;

    LOCAL PROCEDURE MinimumInt3@26(i1@1000 : Integer;i2@1001 : Integer;i3@1002 : Integer) : Integer;
    BEGIN
      IF (i1 <= i2) AND (i1 <= i3) THEN
        EXIT(i1);
      IF (i2 <= i1) AND (i2 <= i3) THEN
        EXIT(i2);
      EXIT(i3);
    END;

    [External]
    PROCEDURE GetGuidAsString@27(GuidValue@1000 : GUID) : Text[36];
    BEGIN
      // Converts guid to string
      // Example: Converts {21EC2020-3AEA-4069-A2DD-08002B30309D} to 21ec2020-3aea-4069-a2dd-08002b30309d
      EXIT(LOWERCASE(COPYSTR(FORMAT(GuidValue),2,36)));
    END;

    [External]
    PROCEDURE WriteRecordLinkNote@30(VAR RecordLink@1000 : Record 2000000068;Note@1001 : Text);
    VAR
      BinWriter@1003 : DotNet "'mscorlib'.System.IO.BinaryWriter";
      OStr@1002 : OutStream;
    BEGIN
      // Writes the Note BLOB into the format the client code expects
      RecordLink.Note.CREATEOUTSTREAM(OStr,TEXTENCODING::UTF8);
      BinWriter := BinWriter.BinaryWriter(OStr);
      BinWriter.Write(Note);
    END;

    [External]
    PROCEDURE ReadRecordLinkNote@45(RecordLink@1000 : Record 2000000068) Note : Text;
    VAR
      BinReader@1003 : DotNet "'mscorlib'.System.IO.BinaryReader";
      IStr@1002 : InStream;
    BEGIN
      // Read the Note BLOB
      RecordLink.Note.CREATEINSTREAM(IStr,TEXTENCODING::UTF8);
      BinReader := BinReader.BinaryReader(IStr);
      // Peek if stream is empty
      IF BinReader.BaseStream.Position = BinReader.BaseStream.Length THEN
        EXIT;
      Note := BinReader.ReadString;
    END;

    [External]
    PROCEDURE GetMaxNumberOfParametersInSQLQuery@31() : Integer;
    BEGIN
      EXIT(2100);
    END;

    [External]
    PROCEDURE BitwiseAnd@40(A@1000 : Integer;B@1001 : Integer) : Integer;
    VAR
      Result@1002 : Integer;
      BitMask@1003 : Integer;
      BitIndex@1004 : Integer;
      MaxBitIndex@1005 : Integer;
    BEGIN
      IF (A < 0) OR (B < 0) THEN
        ERROR(UnsupportedNegativesErr,BitwiseAndTxt);
      BitMask := 1;
      Result := 0;
      MaxBitIndex := 31; // 1st bit is ignored as it is always equals to 0 for positive Int32 numbers
      FOR BitIndex := 1 TO MaxBitIndex DO BEGIN
        IF ((A MOD 2) = 1) AND ((B MOD 2) = 1) THEN
          Result += BitMask;
        A := A DIV 2;
        B := B DIV 2;
        IF BitIndex < MaxBitIndex THEN
          BitMask += BitMask;
      END;
      EXIT(Result);
    END;

    [External]
    PROCEDURE BitwiseOr@43(A@1000 : Integer;B@1001 : Integer) : Integer;
    VAR
      Result@1002 : Integer;
      BitMask@1003 : Integer;
      BitIndex@1004 : Integer;
      MaxBitIndex@1005 : Integer;
    BEGIN
      IF (A < 0) OR (B < 0) THEN
        ERROR(UnsupportedNegativesErr,BitwiseOrTxt);
      BitMask := 1;
      Result := 0;
      MaxBitIndex := 31; // 1st bit is ignored as it is always equals to 0 for positive Int32 numbers
      FOR BitIndex := 1 TO MaxBitIndex DO BEGIN
        IF ((A MOD 2) = 1) OR ((B MOD 2) = 1) THEN
          Result += BitMask;
        A := A DIV 2;
        B := B DIV 2;
        IF BitIndex < MaxBitIndex THEN
          BitMask += BitMask;
      END;
      EXIT(Result);
    END;

    [External]
    PROCEDURE BitwiseXor@51(A@1000 : Integer;B@1001 : Integer) : Integer;
    VAR
      Result@1002 : Integer;
      BitMask@1003 : Integer;
      BitIndex@1004 : Integer;
      MaxBitIndex@1005 : Integer;
    BEGIN
      IF (A < 0) OR (B < 0) THEN
        ERROR(UnsupportedNegativesErr,BitwiseXorTxt);
      BitMask := 1;
      Result := 0;
      MaxBitIndex := 31; // 1st bit is ignored as it is always equals to 0 for positive Int32 numbers
      FOR BitIndex := 1 TO MaxBitIndex DO BEGIN
        IF (A MOD 2) <> (B MOD 2) THEN
          Result += BitMask;
        A := A DIV 2;
        B := B DIV 2;
        IF BitIndex < MaxBitIndex THEN
          BitMask += BitMask;
      END;
      EXIT(Result);
    END;

    [External]
    PROCEDURE GetFormattedCurrentDateTimeInUserTimeZone@34(StringFormat@1000 : Text) : Text;
    VAR
      DateTime@1002 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.DateTime";
      TimezoneOffset@1001 : Duration;
    BEGIN
      IF NOT GetUserTimezoneOffset(TimezoneOffset) THEN
        TimezoneOffset := 0;
      DateTime := DateTime.Now;
      DateTime := DateTime.ToUniversalTime + TimezoneOffset;
      EXIT(DateTime.ToString(StringFormat));
    END;

    [External]
    PROCEDURE IntToHex@36(IntValue@1000 : Integer) : Text;
    VAR
      DotNetIntPtr@1002 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IntPtr";
    BEGIN
      DotNetIntPtr := DotNetIntPtr.IntPtr(IntValue);
      EXIT(DotNetIntPtr.ToString('X'));
    END;

    PROCEDURE TransferFieldsWithValidate@39(VAR TempFieldBuffer@1000 : TEMPORARY Record 8450;RecordVariant@1001 : Variant;VAR TargetTableRecRef@1002 : RecordRef);
    VAR
      DataTypeManagement@1006 : Codeunit 701;
      SourceRecRef@1004 : RecordRef;
      TargetFieldRef@1005 : FieldRef;
      SourceFieldRef@1003 : FieldRef;
    BEGIN
      DataTypeManagement.GetRecordRef(RecordVariant,SourceRecRef);

      TempFieldBuffer.RESET;
      IF NOT TempFieldBuffer.FINDFIRST THEN
        EXIT;

      REPEAT
        IF TargetTableRecRef.FIELDEXIST(TempFieldBuffer."Field ID") THEN BEGIN
          SourceFieldRef := SourceRecRef.FIELD(TempFieldBuffer."Field ID");
          TargetFieldRef := TargetTableRecRef.FIELD(TempFieldBuffer."Field ID");
          IF FORMAT(TargetFieldRef.CLASS) = 'Normal' THEN
            IF TargetFieldRef.VALUE <> SourceFieldRef.VALUE THEN
              TargetFieldRef.VALIDATE(SourceFieldRef.VALUE);
        END;
      UNTIL TempFieldBuffer.NEXT = 0;
    END;

    [External]
    PROCEDURE AddMinutesToDateTime@53(SourceDateTime@1000 : DateTime;NoOfMinutes@1001 : Integer) : DateTime;
    VAR
      NewDateTime@1002 : DateTime;
      i@1003 : Integer;
      Sign@1004 : Boolean;
    BEGIN
      IF (NoOfMinutes < 1000) AND (NoOfMinutes > -1000) THEN
        NewDateTime := SourceDateTime + 60000 * NoOfMinutes
      ELSE BEGIN
        NewDateTime := SourceDateTime;
        Sign := NoOfMinutes > 0;
        FOR i := 1 TO ABS(ROUND(NoOfMinutes / 1000,1,'<')) DO BEGIN
          IF Sign THEN
            NewDateTime += 60000 * 1000
          ELSE
            NewDateTime += 60000 * -1000
        END;
        NewDateTime += 60000 * (NoOfMinutes MOD 1000)
      END;
      EXIT(NewDateTime);
    END;

    BEGIN
    END.
  }
}

