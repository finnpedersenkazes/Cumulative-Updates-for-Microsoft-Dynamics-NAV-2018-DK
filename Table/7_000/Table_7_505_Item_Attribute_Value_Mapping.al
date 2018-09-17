OBJECT Table 7505 Item Attribute Value Mapping
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    OnDelete=VAR
               ItemAttribute@1002 : Record 7500;
               ItemAttributeValue@1000 : Record 7501;
               ItemAttributeValueMapping@1001 : Record 7505;
             BEGIN
               ItemAttribute.GET("Item Attribute ID");
               IF ItemAttribute.Type = ItemAttribute.Type::Option THEN
                 EXIT;

               IF NOT ItemAttributeValue.GET("Item Attribute ID","Item Attribute Value ID") THEN
                 EXIT;

               ItemAttributeValueMapping.SETRANGE("Item Attribute ID","Item Attribute ID");
               ItemAttributeValueMapping.SETRANGE("Item Attribute Value ID","Item Attribute Value ID");
               IF ItemAttributeValueMapping.COUNT <> 1 THEN
                 EXIT;

               ItemAttributeValueMapping := Rec;
               IF ItemAttributeValueMapping.FIND THEN
                 ItemAttributeValue.DELETE;
             END;

    CaptionML=[DAN=Kobling af vareattributv�rdi;
               ENU=Item Attribute Value Mapping];
  }
  FIELDS
  {
    { 1   ;   ;Table ID            ;Integer       ;CaptionML=[DAN=Tabel-id;
                                                              ENU=Table ID] }
    { 2   ;   ;No.                 ;Code20        ;CaptionML=[DAN=Nr.;
                                                              ENU=No.] }
    { 3   ;   ;Item Attribute ID   ;Integer       ;TableRelation="Item Attribute";
                                                   CaptionML=[DAN=Vareattribut-id;
                                                              ENU=Item Attribute ID] }
    { 4   ;   ;Item Attribute Value ID;Integer    ;TableRelation="Item Attribute Value".ID;
                                                   CaptionML=[DAN=Vareattributv�rdi-id;
                                                              ENU=Item Attribute Value ID] }
  }
  KEYS
  {
    {    ;Table ID,No.,Item Attribute ID          ;Clustered=Yes }
    {    ;Item Attribute ID,Item Attribute Value ID }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    PROCEDURE RenameItemAttributeValueMapping@1(PrevNo@1000 : Code[20];NewNo@1001 : Code[20]);
    VAR
      ItemAttributeValueMapping@1003 : Record 7505;
    BEGIN
      SETRANGE("Table ID",DATABASE::Item);
      SETRANGE("No.",PrevNo);
      IF FINDSET THEN
        REPEAT
          ItemAttributeValueMapping := Rec;
          ItemAttributeValueMapping.RENAME("Table ID",NewNo,"Item Attribute ID");
        UNTIL NEXT = 0;
    END;

    BEGIN
    END.
  }
}

