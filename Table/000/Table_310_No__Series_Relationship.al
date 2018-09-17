OBJECT Table 310 No. Series Relationship
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Nummerserie-relation;
               ENU=No. Series Relationship];
    LookupPageID=Page458;
    DrillDownPageID=Page458;
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code20        ;TableRelation="No. Series";
                                                   OnValidate=BEGIN
                                                                CALCFIELDS(Description);
                                                              END;

                                                   CaptionML=[DAN=Kode;
                                                              ENU=Code];
                                                   NotBlank=Yes }
    { 2   ;   ;Series Code         ;Code20        ;TableRelation="No. Series";
                                                   OnValidate=BEGIN
                                                                CALCFIELDS("Series Description");
                                                              END;

                                                   CaptionML=[DAN=Seriekode;
                                                              ENU=Series Code];
                                                   NotBlank=Yes }
    { 3   ;   ;Description         ;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("No. Series".Description WHERE (Code=FIELD(Code)));
                                                   CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description];
                                                   Editable=No }
    { 4   ;   ;Series Description  ;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("No. Series".Description WHERE (Code=FIELD(Series Code)));
                                                   CaptionML=[DAN=Seriebeskrivelse;
                                                              ENU=Series Description];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Code,Series Code                        ;Clustered=Yes }
    {    ;Series Code,Code                         }
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

