OBJECT Table 6529 Record Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Recordbuffer;
               ENU=Record Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=L›benr.;
                                                              ENU=Entry No.] }
    { 3   ;   ;Table No.           ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Tabelnr.;
                                                              ENU=Table No.] }
    { 4   ;   ;Table Name          ;Text250       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Tabelnavn;
                                                              ENU=Table Name];
                                                   Editable=No }
    { 5   ;   ;Record Identifier   ;RecordID      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Record-id;
                                                              ENU=Record Identifier];
                                                   Editable=No }
    { 6   ;   ;Search Record ID    ;Code100       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=S›gerecord-id;
                                                              ENU=Search Record ID];
                                                   Editable=No }
    { 7   ;   ;Primary Key         ;Text250       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Prim‘rn›gle;
                                                              ENU=Primary Key];
                                                   Editable=No }
    { 8   ;   ;Primary Key Field 1 No.;Integer    ;TableRelation=Field.No. WHERE (TableNo=FIELD(Table No.));
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Nr. p† prim‘rn›glefelt 1;
                                                              ENU=Primary Key Field 1 No.] }
    { 9   ;   ;Primary Key Field 1 Name;Text80    ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Field."Field Caption" WHERE (TableNo=FIELD(Table No.),
                                                                                                   No.=FIELD(Primary Key Field 1 No.)));
                                                   CaptionML=[DAN=Navn p† prim‘rn›glefelt 1;
                                                              ENU=Primary Key Field 1 Name] }
    { 10  ;   ;Primary Key Field 1 Value;Text50   ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=V‘rdi for prim‘rn›glefelt 1;
                                                              ENU=Primary Key Field 1 Value] }
    { 11  ;   ;Primary Key Field 2 No.;Integer    ;TableRelation=Field.No. WHERE (TableNo=FIELD(Table No.));
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Nr. p† prim‘rn›glefelt 2;
                                                              ENU=Primary Key Field 2 No.] }
    { 12  ;   ;Primary Key Field 2 Name;Text80    ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Field."Field Caption" WHERE (TableNo=FIELD(Table No.),
                                                                                                   No.=FIELD(Primary Key Field 2 No.)));
                                                   CaptionML=[DAN=Navn p† prim‘rn›glefelt 2;
                                                              ENU=Primary Key Field 2 Name] }
    { 13  ;   ;Primary Key Field 2 Value;Text50   ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=V‘rdi for prim‘rn›glefelt 2;
                                                              ENU=Primary Key Field 2 Value] }
    { 14  ;   ;Primary Key Field 3 No.;Integer    ;TableRelation=Field.No. WHERE (TableNo=FIELD(Table No.));
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Nr. p† prim‘rn›glefelt 3;
                                                              ENU=Primary Key Field 3 No.] }
    { 15  ;   ;Primary Key Field 3 Name;Text80    ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Field."Field Caption" WHERE (TableNo=FIELD(Table No.),
                                                                                                   No.=FIELD(Primary Key Field 3 No.)));
                                                   CaptionML=[DAN=Navn p† prim‘rn›glefelt 3;
                                                              ENU=Primary Key Field 3 Name] }
    { 16  ;   ;Primary Key Field 3 Value;Text50   ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=V‘rdi for prim‘rn›glefelt 3;
                                                              ENU=Primary Key Field 3 Value] }
    { 17  ;   ;Level               ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Niveau;
                                                              ENU=Level] }
    { 20  ;   ;Serial No.          ;Code20        ;OnLookup=BEGIN
                                                              ItemTrackingMgt.LookupLotSerialNoInfo("Item No.","Variant Code",0,"Serial No.");
                                                            END;

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Serienr.;
                                                              ENU=Serial No.] }
    { 21  ;   ;Lot No.             ;Code20        ;OnLookup=BEGIN
                                                              ItemTrackingMgt.LookupLotSerialNoInfo("Item No.","Variant Code",1,"Lot No.");
                                                            END;

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Lotnr.;
                                                              ENU=Lot No.] }
    { 22  ;   ;Item No.            ;Code20        ;TableRelation=Item;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Varenr.;
                                                              ENU=Item No.] }
    { 23  ;   ;Variant Code        ;Code10        ;TableRelation="Item Variant".Code WHERE (Item No.=FIELD(Item No.));
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Variantkode;
                                                              ENU=Variant Code] }
  }
  KEYS
  {
    {    ;Entry No.                               ;Clustered=Yes }
    {    ;Table No.,Search Record ID               }
    {    ;Search Record ID                         }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      ItemTrackingMgt@1000000000 : Codeunit 6500;

    BEGIN
    END.
  }
}

