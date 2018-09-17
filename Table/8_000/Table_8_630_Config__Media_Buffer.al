OBJECT Table 8630 Config. Media Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Ops‘tning af mediebuffer;
               ENU=Config. Media Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Package Code        ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Pakkekode;
                                                              ENU=Package Code] }
    { 2   ;   ;Media Set ID        ;GUID          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Medies‘t-id;
                                                              ENU=Media Set ID] }
    { 3   ;   ;Media ID            ;GUID          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Medie-id;
                                                              ENU=Media ID] }
    { 4   ;   ;No.                 ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Nr.;
                                                              ENU=No.] }
    { 10  ;   ;Media Blob          ;BLOB          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Medieblob;
                                                              ENU=Media Blob] }
    { 11  ;   ;Media Set           ;MediaSet      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Medies‘t;
                                                              ENU=Media Set] }
    { 12  ;   ;Media               ;Media         ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Medier;
                                                              ENU=Media] }
  }
  KEYS
  {
    {    ;Package Code,Media Set ID,Media ID,No.  ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    [External]
    PROCEDURE GetNextNo@1() : Integer;
    VAR
      ConfigMediaBuffer@1003 : Record 8630;
    BEGIN
      ConfigMediaBuffer.SETRANGE("Package Code","Package Code");
      ConfigMediaBuffer.SETRANGE("Media Set ID","Media Set ID");
      ConfigMediaBuffer.SETRANGE("Media ID","Media ID");

      IF ConfigMediaBuffer.FINDLAST THEN
        EXIT(ConfigMediaBuffer."No." + 1);

      EXIT(1);
    END;

    BEGIN
    END.
  }
}

