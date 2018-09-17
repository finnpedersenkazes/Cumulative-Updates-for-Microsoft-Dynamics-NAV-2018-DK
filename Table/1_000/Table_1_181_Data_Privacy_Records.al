OBJECT Table 1181 Data Privacy Records
{
  OBJECT-PROPERTIES
  {
    Date=25-05-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.22292;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Records om beskyttelse af data;
               ENU=Data Privacy Records];
  }
  FIELDS
  {
    { 1   ;   ;ID                  ;Integer       ;AutoIncrement=Yes;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Id;
                                                              ENU=ID] }
    { 2   ;   ;Table No.           ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Tabelnr.;
                                                              ENU=Table No.] }
    { 3   ;   ;Table Name          ;Text30        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Field.TableName WHERE (TableNo=FIELD(Table No.),
                                                                                             No.=FIELD(Field No.)));
                                                   CaptionML=[DAN=Tabelnavn;
                                                              ENU=Table Name] }
    { 4   ;   ;Field No.           ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Feltnr.;
                                                              ENU=Field No.] }
    { 5   ;   ;Field Name          ;Text30        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Field.FieldName WHERE (TableNo=FIELD(Table No.),
                                                                                             No.=FIELD(Field No.)));
                                                   CaptionML=[DAN=Feltnavn;
                                                              ENU=Field Name] }
    { 6   ;   ;Field DataType      ;Text20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Feltdatatype;
                                                              ENU=Field DataType] }
    { 7   ;   ;Field Value         ;Text250       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Feltv‘rdi;
                                                              ENU=Field Value] }
  }
  KEYS
  {
    {    ;ID                                      ;Clustered=Yes }
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

