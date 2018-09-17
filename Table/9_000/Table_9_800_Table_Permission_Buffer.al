OBJECT Table 9800 Table Permission Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Tabelrettighedsbuffer;
               ENU=Table Permission Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Session ID          ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Sessions-id;
                                                              ENU=Session ID] }
    { 3   ;   ;Object Type         ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Objekttype;
                                                              ENU=Object Type];
                                                   OptionCaptionML=[DAN=Tabeldata,Tabel,,Rapport,,Codeunit,XMLport,MenuSuite,Side,Foresp›rgsel,System;
                                                                    ENU=Table Data,Table,,Report,,Codeunit,XMLport,MenuSuite,Page,Query,System];
                                                   OptionString=Table Data,Table,,Report,,Codeunit,XMLport,MenuSuite,Page,Query,System }
    { 4   ;   ;Object ID           ;Integer       ;TableRelation=IF (Object Type=CONST(Table Data)) AllObj."Object ID" WHERE (Object Type=CONST(Table))
                                                                 ELSE IF (Object Type=CONST(Table)) AllObj."Object ID" WHERE (Object Type=CONST(Table))
                                                                 ELSE IF (Object Type=CONST(Report)) AllObj."Object ID" WHERE (Object Type=CONST(Report))
                                                                 ELSE IF (Object Type=CONST(Codeunit)) AllObj."Object ID" WHERE (Object Type=CONST(Codeunit))
                                                                 ELSE IF (Object Type=CONST(XMLport)) AllObj."Object ID" WHERE (Object Type=CONST(XMLport))
                                                                 ELSE IF (Object Type=CONST(MenuSuite)) AllObj."Object ID" WHERE (Object Type=CONST(MenuSuite))
                                                                 ELSE IF (Object Type=CONST(Page)) AllObj."Object ID" WHERE (Object Type=CONST(Page))
                                                                 ELSE IF (Object Type=CONST(Query)) AllObj."Object ID" WHERE (Object Type=CONST(Query))
                                                                 ELSE IF (Object Type=CONST(System)) AllObj."Object ID" WHERE (Object Type=CONST(System));
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Objekt-id;
                                                              ENU=Object ID] }
    { 5   ;   ;Object Name         ;Text249       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(AllObjWithCaption."Object Caption" WHERE (Object Type=FIELD(Object Type),
                                                                                                                Object ID=FIELD(Object ID)));
                                                   CaptionML=[DAN=Objektnavn;
                                                              ENU=Object Name] }
    { 6   ;   ;Read Permission     ;Option        ;InitValue=Yes;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=L‘serettighed;
                                                              ENU=Read Permission];
                                                   OptionCaptionML=[DAN=" ,Ja,Indirekte";
                                                                    ENU=" ,Yes,Indirect"];
                                                   OptionString=[ ,Yes,Indirect] }
    { 7   ;   ;Insert Permission   ;Option        ;InitValue=Yes;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Rettighed til inds‘ttelse;
                                                              ENU=Insert Permission];
                                                   OptionCaptionML=[DAN=" ,Ja,Indirekte";
                                                                    ENU=" ,Yes,Indirect"];
                                                   OptionString=[ ,Yes,Indirect] }
    { 8   ;   ;Modify Permission   ;Option        ;InitValue=Yes;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Redigeringsrettighed;
                                                              ENU=Modify Permission];
                                                   OptionCaptionML=[DAN=" ,Ja,Indirekte";
                                                                    ENU=" ,Yes,Indirect"];
                                                   OptionString=[ ,Yes,Indirect] }
    { 9   ;   ;Delete Permission   ;Option        ;InitValue=Yes;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Sletterettighed;
                                                              ENU=Delete Permission];
                                                   OptionCaptionML=[DAN=" ,Ja,Indirekte";
                                                                    ENU=" ,Yes,Indirect"];
                                                   OptionString=[ ,Yes,Indirect] }
    { 10  ;   ;Execute Permission  ;Option        ;InitValue=Yes;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Udf›relsesrettighed;
                                                              ENU=Execute Permission];
                                                   OptionCaptionML=[DAN=" ,Ja,Indirekte";
                                                                    ENU=" ,Yes,Indirect"];
                                                   OptionString=[ ,Yes,Indirect] }
  }
  KEYS
  {
    {    ;Session ID,Object Type,Object ID        ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    BEGIN
    END.
  }
}

