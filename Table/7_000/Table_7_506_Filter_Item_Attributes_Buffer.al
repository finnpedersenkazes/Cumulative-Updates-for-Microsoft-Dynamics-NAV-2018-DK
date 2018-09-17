OBJECT Table 7506 Filter Item Attributes Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               IF ISNULLGUID(ID) THEN
                 ID := CREATEGUID;
             END;

    CaptionML=[DAN=Buffer for filtrering af vareattributter;
               ENU=Filter Item Attributes Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Attribute           ;Text250       ;OnValidate=VAR
                                                                ItemAttribute@1001 : Record 7500;
                                                              BEGIN
                                                                IF NOT FindItemAttributeCaseInsensitive(ItemAttribute) THEN
                                                                  ERROR(AttributeDoesntExistErr,Attribute);
                                                                CheckForDuplicate;
                                                                AdjustAttributeName(ItemAttribute);
                                                              END;

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Attribut;
                                                              ENU=Attribute] }
    { 2   ;   ;Value               ;Text250       ;OnValidate=VAR
                                                                ItemAttributeValue@1003 : Record 7501;
                                                                ItemAttribute@1002 : Record 7500;
                                                              BEGIN
                                                                IF Value <> '' THEN
                                                                  IF FindItemAttributeCaseSensitive(ItemAttribute) THEN
                                                                    IF ItemAttribute.Type = ItemAttribute.Type::Option THEN
                                                                      IF FindItemAttributeValueCaseInsensitive(ItemAttribute,ItemAttributeValue) THEN
                                                                        AdjustAttributeValue(ItemAttributeValue);
                                                              END;

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=V�rdi;
                                                              ENU=Value] }
    { 3   ;   ;ID                  ;GUID          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Id;
                                                              ENU=ID] }
  }
  KEYS
  {
    {    ;Attribute                               ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      AttributeDoesntExistErr@1005 : TextConst '@@@=%1 - arbitrary name;DAN=Vareattributten ''%1'' findes ikke.;ENU=The item attribute ''%1'' doesn''t exist.';
      AttributeValueAlreadySpecifiedErr@1001 : TextConst '@@@=%1 - attribute name;DAN=Du har allerede angivet en v�rdi for vareattributten ''%1''.;ENU=You have already specified a value for item attribute ''%1''.';

    [External]
    PROCEDURE ValueAssistEdit@1();
    VAR
      ItemAttribute@1000 : Record 7500;
      FilterItemsAssistEdit@1001 : Page 7507;
    BEGIN
      IF FindItemAttributeCaseSensitive(ItemAttribute) THEN
        IF ItemAttribute.Type = ItemAttribute.Type::Option THEN BEGIN
          FilterItemsAssistEdit.SETRECORD(ItemAttribute);
          Value := COPYSTR(FilterItemsAssistEdit.LookupOptionValue(Value),1,MAXSTRLEN(Value));
          EXIT;
        END;

      FilterItemsAssistEdit.SETTABLEVIEW(ItemAttribute);
      FilterItemsAssistEdit.LOOKUPMODE(TRUE);
      IF FilterItemsAssistEdit.RUNMODAL = ACTION::LookupOK THEN
        Value := COPYSTR(FilterItemsAssistEdit.GenerateFilter,1,MAXSTRLEN(Value));
    END;

    LOCAL PROCEDURE FindItemAttributeCaseSensitive@2(VAR ItemAttribute@1000 : Record 7500) : Boolean;
    BEGIN
      ItemAttribute.SETRANGE(Name,Attribute);
      EXIT(ItemAttribute.FINDFIRST);
    END;

    LOCAL PROCEDURE FindItemAttributeCaseInsensitive@6(VAR ItemAttribute@1000 : Record 7500) : Boolean;
    VAR
      AttributeName@1001 : Text[250];
    BEGIN
      IF FindItemAttributeCaseSensitive(ItemAttribute) THEN
        EXIT(TRUE);

      AttributeName := LOWERCASE(Attribute);
      ItemAttribute.SETRANGE(Name);
      IF ItemAttribute.FINDSET THEN
        REPEAT
          IF LOWERCASE(ItemAttribute.Name) = AttributeName THEN
            EXIT(TRUE);
        UNTIL ItemAttribute.NEXT = 0;

      EXIT(FALSE);
    END;

    LOCAL PROCEDURE FindItemAttributeValueCaseInsensitive@3(VAR ItemAttribute@1000 : Record 7500;VAR ItemAttributeValue@1002 : Record 7501) : Boolean;
    VAR
      AttributeValue@1001 : Text[250];
    BEGIN
      ItemAttributeValue.SETRANGE("Attribute ID",ItemAttribute.ID);
      ItemAttributeValue.SETRANGE(Value,Value);
      IF ItemAttributeValue.FINDFIRST THEN
        EXIT(TRUE);

      ItemAttributeValue.SETRANGE(Value);
      IF ItemAttributeValue.FINDSET THEN BEGIN
        AttributeValue := LOWERCASE(Value);
        REPEAT
          IF LOWERCASE(ItemAttributeValue.Value) = AttributeValue THEN
            EXIT(TRUE);
        UNTIL ItemAttributeValue.NEXT = 0;
      END;
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE CheckForDuplicate@34();
    VAR
      TempFilterItemAttributesBuffer@1001 : TEMPORARY Record 7506;
      AttributeName@1003 : Text[250];
    BEGIN
      IF ISEMPTY THEN
        EXIT;
      AttributeName := LOWERCASE(Attribute);
      TempFilterItemAttributesBuffer.COPY(Rec,TRUE);
      IF TempFilterItemAttributesBuffer.FINDSET THEN
        REPEAT
          IF TempFilterItemAttributesBuffer.ID <> ID THEN
            IF LOWERCASE(TempFilterItemAttributesBuffer.Attribute) = AttributeName THEN
              ERROR(AttributeValueAlreadySpecifiedErr,Attribute);
        UNTIL TempFilterItemAttributesBuffer.NEXT = 0;
    END;

    LOCAL PROCEDURE AdjustAttributeName@5(VAR ItemAttribute@1000 : Record 7500);
    BEGIN
      IF Attribute <> ItemAttribute.Name THEN
        Attribute := ItemAttribute.Name;
    END;

    LOCAL PROCEDURE AdjustAttributeValue@12(VAR ItemAttributeValue@1000 : Record 7501);
    BEGIN
      IF Value <> ItemAttributeValue.Value THEN
        Value := ItemAttributeValue.Value;
    END;

    BEGIN
    END.
  }
}

