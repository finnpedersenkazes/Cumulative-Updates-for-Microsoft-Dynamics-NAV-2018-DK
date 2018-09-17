OBJECT Table 8626 Config. Package Filter
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Konfig.pakkefilter;
               ENU=Config. Package Filter];
  }
  FIELDS
  {
    { 1   ;   ;Package Code        ;Code20        ;TableRelation="Config. Package";
                                                   CaptionML=[DAN=Pakkekode;
                                                              ENU=Package Code] }
    { 2   ;   ;Table ID            ;Integer       ;CaptionML=[DAN=Tabel-id;
                                                              ENU=Table ID] }
    { 3   ;   ;Processing Rule No. ;Integer       ;CaptionML=[DAN=Behandlingsregelnr.;
                                                              ENU=Processing Rule No.] }
    { 5   ;   ;Field ID            ;Integer       ;OnValidate=VAR
                                                                Field@1000 : Record 2000000041;
                                                                TypeHelper@1001 : Codeunit 10;
                                                              BEGIN
                                                                Field.GET("Table ID","Field ID");
                                                                TypeHelper.TestFieldIsNotObsolete(Field);
                                                                CALCFIELDS("Field Name","Field Caption");
                                                              END;

                                                   CaptionML=[DAN=Felt-id;
                                                              ENU=Field ID] }
    { 6   ;   ;Field Name          ;Text30        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Field.FieldName WHERE (TableNo=FIELD(Table ID),
                                                                                             No.=FIELD(Field ID)));
                                                   CaptionML=[DAN=Feltnavn;
                                                              ENU=Field Name];
                                                   Editable=No }
    { 7   ;   ;Field Caption       ;Text250       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Field."Field Caption" WHERE (TableNo=FIELD(Table ID),
                                                                                                   No.=FIELD(Field ID)));
                                                   CaptionML=[DAN=Felttitel;
                                                              ENU=Field Caption];
                                                   Editable=No }
    { 8   ;   ;Field Filter        ;Text250       ;OnValidate=BEGIN
                                                                ValidateFieldFilter;
                                                              END;

                                                   CaptionML=[DAN=Feltfilter;
                                                              ENU=Field Filter] }
  }
  KEYS
  {
    {    ;Package Code,Table ID,Processing Rule No.,Field ID;
                                                   Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    LOCAL PROCEDURE ValidateFieldFilter@1();
    VAR
      RecRef@1000 : RecordRef;
      FieldRef@1001 : FieldRef;
    BEGIN
      RecRef.OPEN("Table ID");
      IF "Field Filter" <> '' THEN BEGIN
        FieldRef := RecRef.FIELD("Field ID");
        FieldRef.SETFILTER("Field Filter");
      END;
    END;

    BEGIN
    END.
  }
}

