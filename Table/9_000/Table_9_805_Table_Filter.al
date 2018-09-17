OBJECT Table 9805 Table Filter
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Tabelfilter;
               ENU=Table Filter];
  }
  FIELDS
  {
    { 1   ;   ;Table Number        ;Integer       ;CaptionML=[DAN=Tabelnummer;
                                                              ENU=Table Number] }
    { 2   ;   ;Line No.            ;Integer       ;CaptionML=[DAN=Linjenr.;
                                                              ENU=Line No.] }
    { 4   ;   ;Table Name          ;Text30        ;CaptionML=[DAN=Tabelnavn;
                                                              ENU=Table Name] }
    { 5   ;   ;Field Number        ;Integer       ;TableRelation=Field.No. WHERE (TableNo=FIELD(Table Number));
                                                   OnValidate=VAR
                                                                Field@1000 : Record 2000000041;
                                                                TypeHelper@1001 : Codeunit 10;
                                                              BEGIN
                                                                IF xRec."Field Number" = "Field Number" THEN
                                                                  EXIT;

                                                                Field.GET("Table Number","Field Number");
                                                                TypeHelper.TestFieldIsNotObsolete(Field);
                                                                CheckDuplicateField(Field);

                                                                "Field Caption" := Field."Field Caption";
                                                                "Field Filter" := '';
                                                              END;

                                                   CaptionML=[DAN=Feltnummer;
                                                              ENU=Field Number] }
    { 6   ;   ;Field Name          ;Text30        ;CaptionML=[DAN=Feltnavn;
                                                              ENU=Field Name] }
    { 7   ;   ;Field Caption       ;Text80        ;CaptionML=[DAN=Felttitel;
                                                              ENU=Field Caption] }
    { 8   ;   ;Field Filter        ;Text250       ;CaptionML=[DAN=Feltfilter;
                                                              ENU=Field Filter] }
  }
  KEYS
  {
    {    ;Table Number,Line No.                   ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text001@1000 : TextConst '@@@=The filter for the field <Field Number> <Field Name> already exists. Example: The filter for the field 15 Base Unit of Measure already exists.;DAN=Filteret for feltet %1 %2 findes allerede.;ENU=The filter for the field %1 %2 already exists.';

    [External]
    PROCEDURE CheckDuplicateField@1(Field@1000 : Record 2000000041);
    VAR
      TableFilter@1001 : Record 9805;
    BEGIN
      TableFilter.COPY(Rec);
      RESET;
      SETRANGE("Table Number",Field.TableNo);
      SETRANGE("Field Number",Field."No.");
      SETFILTER("Line No.",'<>%1',"Line No.");
      IF NOT ISEMPTY THEN
        ERROR(Text001,Field."No.",Field."Field Caption");
      COPY(TableFilter);
    END;

    BEGIN
    END.
  }
}

