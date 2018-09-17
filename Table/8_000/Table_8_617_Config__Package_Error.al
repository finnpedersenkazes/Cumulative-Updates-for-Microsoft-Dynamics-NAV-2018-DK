OBJECT Table 8617 Config. Package Error
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Konfig.pakkefejl;
               ENU=Config. Package Error];
    LookupPageID=Page8616;
    DrillDownPageID=Page8616;
  }
  FIELDS
  {
    { 1   ;   ;Package Code        ;Code20        ;TableRelation="Config. Package";
                                                   CaptionML=[DAN=Pakkekode;
                                                              ENU=Package Code];
                                                   NotBlank=Yes }
    { 2   ;   ;Table ID            ;Integer       ;TableRelation=AllObjWithCaption."Object ID" WHERE (Object Type=CONST(Table));
                                                   CaptionML=[DAN=Tabel-id;
                                                              ENU=Table ID];
                                                   NotBlank=Yes;
                                                   Editable=No }
    { 3   ;   ;Record No.          ;Integer       ;TableRelation="Config. Package Record".No. WHERE (Table ID=FIELD(Table ID));
                                                   CaptionML=[DAN=Recordnr.;
                                                              ENU=Record No.];
                                                   NotBlank=Yes;
                                                   Editable=No }
    { 4   ;   ;Field ID            ;Integer       ;CaptionML=[DAN=Felt-id;
                                                              ENU=Field ID];
                                                   NotBlank=Yes;
                                                   Editable=No }
    { 5   ;   ;Field Name          ;Text30        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Field.FieldName WHERE (TableNo=FIELD(Table ID),
                                                                                             No.=FIELD(Field ID)));
                                                   CaptionML=[DAN=Feltnavn;
                                                              ENU=Field Name];
                                                   Editable=No }
    { 6   ;   ;Error Text          ;Text250       ;CaptionML=[DAN=Fejltekst;
                                                              ENU=Error Text];
                                                   Editable=No }
    { 7   ;   ;Field Caption       ;Text250       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Field."Field Caption" WHERE (TableNo=FIELD(Table ID),
                                                                                                   No.=FIELD(Field ID)));
                                                   CaptionML=[DAN=Felttitel;
                                                              ENU=Field Caption];
                                                   Editable=No }
    { 8   ;   ;Error Type          ;Option        ;CaptionML=[DAN=Fejltype;
                                                              ENU=Error Type];
                                                   OptionCaptionML=[DAN=,TableRelation;
                                                                    ENU=,TableRelation];
                                                   OptionString=,TableRelation }
    { 9   ;   ;Record ID           ;RecordID      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Record-id;
                                                              ENU=Record ID] }
  }
  KEYS
  {
    {    ;Package Code,Table ID,Record No.,Field ID;
                                                   Clustered=Yes }
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

