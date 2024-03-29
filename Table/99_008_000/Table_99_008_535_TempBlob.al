OBJECT Table 99008535 TempBlob
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=TempBlob;
               ENU=TempBlob];
  }
  FIELDS
  {
    { 1   ;   ;Primary Key         ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Prim�rn�gle;
                                                              ENU=Primary Key] }
    { 2   ;   ;Blob                ;BLOB          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Blob;
                                                              ENU=Blob] }
  }
  KEYS
  {
    {    ;Primary Key                             ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      GlobalInStream@1000 : InStream;
      ReadLinesInitialized@1001 : Boolean;
      NoContentErr@1002 : TextConst 'DAN=Feltet BLOB er tomt.;ENU=The BLOB field is empty.';
      UnknownImageTypeErr@1003 : TextConst 'DAN=Ukendt billedtype.;ENU=Unknown image type.';
      XmlCannotBeLoadedErr@1004 : TextConst 'DAN=XML-filen kan ikke v�re indl�st.;ENU=The XML cannot be loaded.';

    [External]
    PROCEDURE WriteAsText@3(Content@1001 : Text;Encoding@1000 : TextEncoding);
    VAR
      OutStr@1002 : OutStream;
    BEGIN
      CLEAR(Blob);
      IF Content = '' THEN
        EXIT;
      Blob.CREATEOUTSTREAM(OutStr,Encoding);
      OutStr.WRITETEXT(Content);
    END;

    [External]
    PROCEDURE ReadAsText@5(LineSeparator@1001 : Text;Encoding@1000 : TextEncoding) Content : Text;
    VAR
      InStream@1002 : InStream;
      ContentLine@1003 : Text;
    BEGIN
      Blob.CREATEINSTREAM(InStream,Encoding);

      InStream.READTEXT(Content);
      WHILE NOT InStream.EOS DO BEGIN
        InStream.READTEXT(ContentLine);
        Content += LineSeparator + ContentLine;
      END;
    END;

    [External]
    PROCEDURE ReadAsTextWithCRLFLineSeparator@20() : Text;
    VAR
      CRLF@1000 : Text[2];
    BEGIN
      CRLF[1] := 13;
      CRLF[2] := 10;
      EXIT(ReadAsText(CRLF,TEXTENCODING::UTF8));
    END;

    [External]
    PROCEDURE StartReadingTextLines@8(Encoding@1000 : TextEncoding);
    BEGIN
      Blob.CREATEINSTREAM(GlobalInStream,Encoding);
      ReadLinesInitialized := TRUE;
    END;

    [External]
    PROCEDURE MoreTextLines@9() : Boolean;
    BEGIN
      IF NOT ReadLinesInitialized THEN
        StartReadingTextLines(TEXTENCODING::Windows);
      EXIT(NOT GlobalInStream.EOS);
    END;

    [External]
    PROCEDURE ReadTextLine@7() : Text;
    VAR
      ContentLine@1003 : Text;
    BEGIN
      IF NOT MoreTextLines THEN
        EXIT('');
      GlobalInStream.READTEXT(ContentLine);
      EXIT(ContentLine);
    END;

    [External]
    PROCEDURE ToBase64String@1() : Text;
    VAR
      IStream@1000 : InStream;
      Convert@1003 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Convert";
      MemoryStream@1002 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.MemoryStream";
      Base64String@1001 : Text;
    BEGIN
      IF NOT Blob.HASVALUE THEN
        EXIT('');
      Blob.CREATEINSTREAM(IStream);
      MemoryStream := MemoryStream.MemoryStream;
      COPYSTREAM(MemoryStream,IStream);
      Base64String := Convert.ToBase64String(MemoryStream.ToArray);
      MemoryStream.Close;
      EXIT(Base64String);
    END;

    [External]
    PROCEDURE FromBase64String@2(Base64String@1000 : Text);
    VAR
      OStream@1001 : OutStream;
      Convert@1003 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Convert";
      MemoryStream@1002 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.MemoryStream";
    BEGIN
      IF Base64String = '' THEN
        EXIT;
      MemoryStream := MemoryStream.MemoryStream(Convert.FromBase64String(Base64String));
      Blob.CREATEOUTSTREAM(OStream);
      MemoryStream.WriteTo(OStream);
      MemoryStream.Close;
    END;

    [External]
    PROCEDURE GetHTMLImgSrc@4() : Text;
    VAR
      ImageFormatAsTxt@1000 : Text;
    BEGIN
      IF NOT Blob.HASVALUE THEN
        EXIT('');
      IF NOT TryGetImageFormatAsTxt(ImageFormatAsTxt) THEN
        EXIT('');
      EXIT(STRSUBSTNO('data:image/%1;base64,%2',ImageFormatAsTxt,ToBase64String));
    END;

    [TryFunction]
    LOCAL PROCEDURE TryGetImageFormatAsTxt@17(VAR ImageFormatAsTxt@1000 : Text);
    VAR
      Image@1002 : DotNet "'System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'.System.Drawing.Image";
      ImageFormatConverter@1004 : DotNet "'System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'.System.Drawing.ImageFormatConverter";
      InStream@1001 : InStream;
    BEGIN
      Blob.CREATEINSTREAM(InStream);
      Image := Image.FromStream(InStream);
      ImageFormatConverter := ImageFormatConverter.ImageFormatConverter;
      ImageFormatAsTxt := ImageFormatConverter.ConvertToString(Image.RawFormat);
    END;

    [External]
    PROCEDURE GetImageType@11() : Text;
    VAR
      ImageFormatAsTxt@1000 : Text;
    BEGIN
      IF NOT Blob.HASVALUE THEN
        ERROR(NoContentErr);
      IF NOT TryGetImageFormatAsTxt(ImageFormatAsTxt) THEN
        ERROR(UnknownImageTypeErr);
      EXIT(ImageFormatAsTxt);
    END;

    [TryFunction]
    LOCAL PROCEDURE TryGetXMLAsText@6(VAR Xml@1000 : Text);
    VAR
      XmlDoc@1002 : DotNet "'System.Xml, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlDocument";
      InStr@1001 : InStream;
    BEGIN
      Blob.CREATEINSTREAM(InStr);
      XmlDoc := XmlDoc.XmlDocument;
      XmlDoc.PreserveWhitespace := FALSE;
      XmlDoc.Load(InStr);
      Xml := XmlDoc.OuterXml;
    END;

    [External]
    PROCEDURE GetXMLAsText@19() : Text;
    VAR
      Xml@1000 : Text;
    BEGIN
      IF NOT Blob.HASVALUE THEN
        ERROR(NoContentErr);
      IF NOT TryGetXMLAsText(Xml) THEN
        ERROR(XmlCannotBeLoadedErr);
      EXIT(Xml);
    END;

    BEGIN
    END.
  }
}

