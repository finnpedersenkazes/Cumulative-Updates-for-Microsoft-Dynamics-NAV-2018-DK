OBJECT Table 5509 Attachment Entity Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    OnRename=BEGIN
               IF xRec.Id <> Id THEN
                 ERROR(CannotChangeIDErr);
             END;

    CaptionML=[DAN=Buffer for enhed til vedh‘ftet fil;
               ENU=Attachment Entity Buffer];
  }
  FIELDS
  {
    { 3   ;   ;Created Date-Time   ;DateTime      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Oprettet dato/klokkesl‘t;
                                                              ENU=Created Date-Time] }
    { 5   ;   ;File Name           ;Text250       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Filnavn;
                                                              ENU=File Name] }
    { 6   ;   ;Type                ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=" ,Billede,PDF,Word,Excel,PowerPoint,Mail,XML,Andet";
                                                                    ENU=" ,Image,PDF,Word,Excel,PowerPoint,Email,XML,Other"];
                                                   OptionString=[ ,Image,PDF,Word,Excel,PowerPoint,Email,XML,Other] }
    { 8   ;   ;Content             ;BLOB          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Indhold;
                                                              ENU=Content];
                                                   SubType=Bitmap }
    { 8000;   ;Id                  ;GUID          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Id;
                                                              ENU=Id] }
    { 8001;   ;Document Id         ;GUID          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bilags-id;
                                                              ENU=Document Id] }
    { 8002;   ;Byte Size           ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bytest›rrelse;
                                                              ENU=Byte Size] }
  }
  KEYS
  {
    {    ;Id                                      ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      CannotChangeIDErr@1000 : TextConst '@@@={Locked};DAN=The id cannot be changed.;ENU=The id cannot be changed.';

    PROCEDURE SetBinaryContent@17(BinaryContent@1002 : Text);
    VAR
      OutStream@1001 : OutStream;
    BEGIN
      Content.CREATEOUTSTREAM(OutStream);
      OutStream.WRITE(BinaryContent,STRLEN(BinaryContent));
    END;

    PROCEDURE SetTextContent@1(TextContent@1002 : Text);
    VAR
      OutStream@1001 : OutStream;
    BEGIN
      Content.CREATEOUTSTREAM(OutStream,TEXTENCODING::UTF8);
      OutStream.WRITE(TextContent,STRLEN(TextContent));
    END;

    BEGIN
    END.
  }
}

