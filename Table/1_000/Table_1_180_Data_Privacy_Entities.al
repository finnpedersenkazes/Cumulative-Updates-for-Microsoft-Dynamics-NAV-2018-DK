OBJECT Table 1180 Data Privacy Entities
{
  OBJECT-PROPERTIES
  {
    Date=25-05-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.22292;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Dataemner;
               ENU=Data Subjects];
  }
  FIELDS
  {
    { 1   ;   ;Table No.           ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Tabelnr.;
                                                              ENU=Table No.] }
    { 2   ;   ;Table Caption       ;Text80        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(AllObjWithCaption."Object Caption" WHERE (Object Type=CONST(Table),
                                                                                                                Object ID=FIELD(Table No.)));
                                                   CaptionML=[DAN=Tabeltitel;
                                                              ENU=Table Caption] }
    { 3   ;   ;Key Field No.       ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=N›glefeltnr.;
                                                              ENU=Key Field No.] }
    { 4   ;   ;Key Field Name      ;Text30        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Field.FieldName WHERE (TableNo=FIELD(Table No.),
                                                                                             No.=FIELD(Key Field No.)));
                                                   CaptionML=[DAN=Navn p† n›glefelt;
                                                              ENU=Key Field Name] }
    { 5   ;   ;Entity Filter       ;BLOB          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Enhedsfilter;
                                                              ENU=Entity Filter] }
    { 6   ;   ;Include             ;Boolean       ;CaptionML=[DAN=Inkluder;
                                                              ENU=Include] }
    { 7   ;   ;Fields              ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count(Field WHERE (TableNo=FIELD(Table No.),
                                                                                  Enabled=CONST(Yes),
                                                                                  Class=CONST(Normal)));
                                                   CaptionML=[DAN=Felter;
                                                              ENU=Fields] }
    { 8   ;   ;Status              ;Option        ;CaptionML=[DAN=Status;
                                                              ENU=Status];
                                                   OptionCaptionML=[DAN=Gennemgang n›dvendig,Gennemset;
                                                                    ENU=Review Needed,Reviewed];
                                                   OptionString=Review Needed,Reviewed }
    { 9   ;   ;Reviewed            ;Boolean       ;CaptionML=[DAN=Gennemset;
                                                              ENU=Reviewed] }
    { 10  ;   ;Status 2            ;Option        ;CaptionML=[DAN=Status 2;
                                                              ENU=Status 2];
                                                   OptionCaptionML=[DAN=Gennemgang n›dvendig,Gennemset;
                                                                    ENU=Review Needed,Reviewed];
                                                   OptionString=Review Needed,Reviewed }
    { 11  ;   ;Page No.            ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Sidenummer;
                                                              ENU=Page No.] }
    { 12  ;   ;Similar Fields Reviewed;Boolean    ;CaptionML=[DAN=Lignende felter gennemset;
                                                              ENU=Similar Fields Reviewed] }
    { 13  ;   ;Similar Fields Label;Text120       ;CaptionML=[DAN=Etiket for lignende felter;
                                                              ENU=Similar Fields Label] }
    { 14  ;   ;Default Data Sensitivity;Option    ;CaptionML=[DAN=Standarddataf›lsomhed;
                                                              ENU=Default Data Sensitivity];
                                                   OptionCaptionML=[DAN=Ikke klassificerede,F›lsomme,Personlige,Virksomhedens fortrolige,Normal;
                                                                    ENU=Unclassified,Sensitive,Personal,Company Confidential,Normal];
                                                   OptionString=Unclassified,Sensitive,Personal,Company Confidential,Normal }
  }
  KEYS
  {
    {    ;Table No.                               ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      SimilarFieldsLbl@1000 : TextConst '@@@="%1=Table Caption";DAN=Klassificer lignende felter for %1;ENU=Classify Similar Fields for %1';

    [External]
    PROCEDURE InsertRow@1(TableNo@1000 : Integer;PageNo@1004 : Integer;KeyFieldNo@1001 : Integer;EntityFilter@1002 : Text);
    VAR
      OutStream@1003 : OutStream;
    BEGIN
      IF GET(TableNo) THEN
        EXIT;

      INIT;
      Include := TRUE;
      "Table No." := TableNo;
      "Key Field No." := KeyFieldNo;

      IF EntityFilter <> '' THEN BEGIN
        "Entity Filter".CREATEOUTSTREAM(OutStream);
        OutStream.WRITETEXT(EntityFilter);
      END;

      "Default Data Sensitivity" := "Default Data Sensitivity"::Personal;
      CALCFIELDS("Table Caption");
      "Similar Fields Label" := STRSUBSTNO(SimilarFieldsLbl,"Table Caption");
      "Page No." := PageNo;

      INSERT;
    END;

    BEGIN
    END.
  }
}

