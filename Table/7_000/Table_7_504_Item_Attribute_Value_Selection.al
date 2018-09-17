OBJECT Table 7504 Item Attribute Value Selection
{
  OBJECT-PROPERTIES
  {
    Date=26-01-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20348;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Valg af vareattributv‘rdi;
               ENU=Item Attribute Value Selection];
  }
  FIELDS
  {
    { 1   ;   ;Attribute Name      ;Text250       ;OnValidate=VAR
                                                                ItemAttribute@1000 : Record 7500;
                                                              BEGIN
                                                                FindItemAttributeCaseInsensitive(ItemAttribute);
                                                                CheckForDuplicate;
                                                                CheckIfBlocked(ItemAttribute);
                                                                AdjustAttributeName(ItemAttribute);
                                                                ValidateChangedAttribute(ItemAttribute);
                                                              END;

                                                   CaptionML=[DAN=Attributnavn;
                                                              ENU=Attribute Name];
                                                   NotBlank=Yes }
    { 2   ;   ;Value               ;Text250       ;OnValidate=VAR
                                                                ItemAttributeValue@1000 : Record 7501;
                                                                ItemAttribute@1001 : Record 7500;
                                                                DecimalValue@1002 : Decimal;
                                                                IntegerValue@1005 : Integer;
                                                              BEGIN
                                                                IF Value = '' THEN
                                                                  EXIT;

                                                                ItemAttribute.GET("Attribute ID");
                                                                IF FindItemAttributeValueCaseSensitive(ItemAttributeValue) THEN
                                                                  CheckIfValueBlocked(ItemAttributeValue);

                                                                CASE "Attribute Type" OF
                                                                  "Attribute Type"::Option:
                                                                    BEGIN
                                                                      IF ItemAttributeValue.Value = '' THEN BEGIN
                                                                        IF NOT FindItemAttributeValueCaseInsensitive(ItemAttributeValue) THEN
                                                                          ERROR(AttributeValueDoesntExistErr,Value);
                                                                        CheckIfValueBlocked(ItemAttributeValue);
                                                                      END;
                                                                      AdjustAttributeValue(ItemAttributeValue);
                                                                    END;
                                                                  "Attribute Type"::Decimal:
                                                                    ValidateType(DecimalValue,Value,ItemAttribute);
                                                                  "Attribute Type"::Integer:
                                                                    ValidateType(IntegerValue,Value,ItemAttribute);
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=V‘rdi;
                                                              ENU=Value] }
    { 3   ;   ;Attribute ID        ;Integer       ;CaptionML=[DAN=Attribut-id;
                                                              ENU=Attribute ID] }
    { 4   ;   ;Unit of Measure     ;Text30        ;CaptionML=[DAN=Enhed;
                                                              ENU=Unit of Measure];
                                                   Editable=No }
    { 6   ;   ;Blocked             ;Boolean       ;CaptionML=[DAN=Sp‘rret;
                                                              ENU=Blocked] }
    { 7   ;   ;Attribute Type      ;Option        ;CaptionML=[DAN=Attributtype;
                                                              ENU=Attribute Type];
                                                   OptionCaptionML=[DAN=Indstilling,Tekst,Heltal,Decimal;
                                                                    ENU=Option,Text,Integer,Decimal];
                                                   OptionString=Option,Text,Integer,Decimal }
    { 8   ;   ;Inherited-From Table ID;Integer    ;CaptionML=[DAN=Overf›rt fra tabel-id;
                                                              ENU=Inherited-From Table ID] }
    { 9   ;   ;Inherited-From Key Value;Code20    ;CaptionML=[DAN=Overf›rt fra n›glev‘rdi;
                                                              ENU=Inherited-From Key Value] }
    { 10  ;   ;Inheritance Level   ;Integer       ;CaptionML=[DAN=Niveau for overf›rte oplysninger;
                                                              ENU=Inheritance Level] }
  }
  KEYS
  {
    {    ;Attribute Name                          ;Clustered=Yes }
    {    ;Inheritance Level,Attribute Name         }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;Attribute ID                             }
    { 2   ;Brick               ;Attribute Name,Value,Unit of Measure     }
  }
  CODE
  {
    VAR
      AttributeDoesntExistErr@1005 : TextConst '@@@=%1 - arbitrary name;DAN=Vareattributten ''%1'' findes ikke.;ENU=The item attribute ''%1'' doesn''t exist.';
      AttributeBlockedErr@1001 : TextConst '@@@=%1 - arbitrary name;DAN=Vareattributten ''%1'' er blokeret.;ENU=The item attribute ''%1'' is blocked.';
      AttributeValueBlockedErr@1002 : TextConst '@@@=%1 - arbitrary name;DAN=Vareattributv‘rdien ''%1'' er blokeret.;ENU=The item attribute value ''%1'' is blocked.';
      AttributeValueDoesntExistErr@1003 : TextConst '@@@=%1 - arbitrary name;DAN=Vareattributv‘rdien ''%1'' findes ikke.;ENU=The item attribute value ''%1'' doesn''t exist.';
      AttributeValueAlreadySpecifiedErr@1004 : TextConst '@@@=%1 - attribute name;DAN=Du har allerede angivet en v‘rdi for vareattributten ''%1''.;ENU=You have already specified a value for item attribute ''%1''.';
      AttributeValueTypeMismatchErr@1000 : TextConst '@@@=" %1 is arbitrary string, %2 is type name";DAN=V‘rdien ''%1'' stemmer ikke overens med attributtypen %2.;ENU=The value ''%1'' does not match the item attribute of type %2.';

    [External]
    PROCEDURE PopulateItemAttributeValueSelection@16(VAR TempItemAttributeValue@1001 : TEMPORARY Record 7501);
    BEGIN
      IF TempItemAttributeValue.FINDSET THEN
        REPEAT
          InsertRecord(TempItemAttributeValue,0,'');
        UNTIL TempItemAttributeValue.NEXT = 0;
    END;

    [External]
    PROCEDURE PopulateItemAttributeValue@43(VAR TempNewItemAttributeValue@1001 : TEMPORARY Record 7501);
    VAR
      ItemAttributeValue@1003 : Record 7501;
      ValDecimal@1002 : Decimal;
    BEGIN
      IF FINDSET THEN
        REPEAT
          CLEAR(TempNewItemAttributeValue);
          TempNewItemAttributeValue.INIT;
          TempNewItemAttributeValue."Attribute ID" := "Attribute ID";
          TempNewItemAttributeValue.Blocked := Blocked;
          ItemAttributeValue.RESET;
          ItemAttributeValue.SETRANGE("Attribute ID","Attribute ID");
          CASE "Attribute Type" OF
            "Attribute Type"::Option,
            "Attribute Type"::Text,
            "Attribute Type"::Integer:
              BEGIN
                TempNewItemAttributeValue.Value := Value;
                ItemAttributeValue.SETRANGE(Value,Value);
              END;
            "Attribute Type"::Decimal:
              BEGIN
                IF Value <> '' THEN BEGIN
                  EVALUATE(ValDecimal,Value);
                  ItemAttributeValue.SETRANGE(Value,FORMAT(ValDecimal,0,9));
                  IF ItemAttributeValue.ISEMPTY THEN BEGIN
                    ItemAttributeValue.SETRANGE(Value,FORMAT(ValDecimal));
                    IF ItemAttributeValue.ISEMPTY THEN
                      ItemAttributeValue.SETRANGE(Value,Value);
                  END;
                END;
                TempNewItemAttributeValue.Value := FORMAT(ValDecimal);
              END;
          END;
          IF NOT ItemAttributeValue.FINDFIRST THEN
            InsertItemAttributeValue(ItemAttributeValue,Rec);
          TempNewItemAttributeValue.ID := ItemAttributeValue.ID;
          TempNewItemAttributeValue.INSERT;
        UNTIL NEXT = 0;
    END;

    [External]
    PROCEDURE InsertItemAttributeValue@4(VAR ItemAttributeValue@1000 : Record 7501;TempItemAttributeValueSelection@1001 : TEMPORARY Record 7504);
    VAR
      ValDecimal@1003 : Decimal;
    BEGIN
      CLEAR(ItemAttributeValue);
      ItemAttributeValue."Attribute ID" := TempItemAttributeValueSelection."Attribute ID";
      ItemAttributeValue.Blocked := TempItemAttributeValueSelection.Blocked;
      CASE TempItemAttributeValueSelection."Attribute Type" OF
        TempItemAttributeValueSelection."Attribute Type"::Option,
        TempItemAttributeValueSelection."Attribute Type"::Text:
          ItemAttributeValue.Value := TempItemAttributeValueSelection.Value;
        TempItemAttributeValueSelection."Attribute Type"::Integer:
          ItemAttributeValue.VALIDATE(Value,TempItemAttributeValueSelection.Value);
        TempItemAttributeValueSelection."Attribute Type"::Decimal:
          IF TempItemAttributeValueSelection.Value <> '' THEN BEGIN
            EVALUATE(ValDecimal,TempItemAttributeValueSelection.Value);
            ItemAttributeValue.VALIDATE(Value,FORMAT(ValDecimal));
          END;
      END;
      ItemAttributeValue.INSERT;
    END;

    [External]
    PROCEDURE InsertRecord@2(VAR TempItemAttributeValue@1000 : TEMPORARY Record 7501;DefinedOnTableID@1003 : Integer;DefinedOnKeyValue@1004 : Code[20]);
    VAR
      ItemAttribute@1002 : Record 7500;
      ValueDecimal@1001 : Decimal;
    BEGIN
      "Attribute ID" := TempItemAttributeValue."Attribute ID";
      ItemAttribute.GET(TempItemAttributeValue."Attribute ID");
      "Attribute Name" := ItemAttribute.Name;
      "Attribute Type" := ItemAttribute.Type;
      IF IsNotBlankDecimal(TempItemAttributeValue.Value) THEN BEGIN
        IF NOT EVALUATE(ValueDecimal,TempItemAttributeValue.Value,9) THEN
          EVALUATE(ValueDecimal,TempItemAttributeValue.Value);
        Value := FORMAT(ValueDecimal);
      END ELSE
        Value := FORMAT(TempItemAttributeValue.Value);

      Blocked := TempItemAttributeValue.Blocked;
      "Unit of Measure" := ItemAttribute."Unit of Measure";
      "Inherited-From Table ID" := DefinedOnTableID;
      "Inherited-From Key Value" := DefinedOnKeyValue;
      INSERT;
    END;

    LOCAL PROCEDURE ValidateType@1(Variant@1000 : Variant;ValueToValidate@1001 : Text;ItemAttribute@1002 : Record 7500);
    VAR
      TypeHelper@1003 : Codeunit 10;
      CultureInfo@1004 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Globalization.CultureInfo";
    BEGIN
      IF (ValueToValidate <> '') AND NOT TypeHelper.Evaluate(Variant,ValueToValidate,'',CultureInfo.CurrentCulture.Name) THEN
        ERROR(AttributeValueTypeMismatchErr,ValueToValidate,ItemAttribute.Type);
    END;

    LOCAL PROCEDURE FindItemAttributeCaseInsensitive@6(VAR ItemAttribute@1000 : Record 7500);
    VAR
      AttributeName@1001 : Text[250];
    BEGIN
      ItemAttribute.SETRANGE(Name,"Attribute Name");
      IF ItemAttribute.FINDFIRST THEN
        EXIT;

      AttributeName := LOWERCASE("Attribute Name");
      ItemAttribute.SETRANGE(Name);
      IF ItemAttribute.FINDSET THEN
        REPEAT
          IF LOWERCASE(ItemAttribute.Name) = AttributeName THEN
            EXIT;
        UNTIL ItemAttribute.NEXT = 0;

      ERROR(AttributeDoesntExistErr,"Attribute Name");
    END;

    LOCAL PROCEDURE FindItemAttributeValueCaseSensitive@22(VAR ItemAttributeValue@1000 : Record 7501) : Boolean;
    BEGIN
      ItemAttributeValue.SETRANGE("Attribute ID","Attribute ID");
      ItemAttributeValue.SETRANGE(Value,Value);
      EXIT(ItemAttributeValue.FINDFIRST);
    END;

    LOCAL PROCEDURE FindItemAttributeValueCaseInsensitive@46(VAR ItemAttributeValue@1000 : Record 7501) : Boolean;
    VAR
      AttributeValue@1002 : Text[250];
    BEGIN
      ItemAttributeValue.SETRANGE("Attribute ID","Attribute ID");
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
      TempItemAttributeValueSelection@1001 : TEMPORARY Record 7504;
      AttributeName@1003 : Text[250];
    BEGIN
      IF ISEMPTY THEN
        EXIT;
      AttributeName := LOWERCASE("Attribute Name");
      TempItemAttributeValueSelection.COPY(Rec,TRUE);
      IF TempItemAttributeValueSelection.FINDSET THEN
        REPEAT
          IF TempItemAttributeValueSelection."Attribute ID" <> "Attribute ID" THEN
            IF LOWERCASE(TempItemAttributeValueSelection."Attribute Name") = AttributeName THEN
              ERROR(AttributeValueAlreadySpecifiedErr,"Attribute Name");
        UNTIL TempItemAttributeValueSelection.NEXT = 0;
    END;

    LOCAL PROCEDURE CheckIfBlocked@13(VAR ItemAttribute@1000 : Record 7500);
    BEGIN
      IF ItemAttribute.Blocked THEN
        ERROR(AttributeBlockedErr,ItemAttribute.Name);
    END;

    LOCAL PROCEDURE CheckIfValueBlocked@10(ItemAttributeValue@1000 : Record 7501);
    BEGIN
      IF ItemAttributeValue.Blocked THEN
        ERROR(AttributeValueBlockedErr,ItemAttributeValue.Value);
    END;

    LOCAL PROCEDURE AdjustAttributeName@7(VAR ItemAttribute@1000 : Record 7500);
    BEGIN
      IF "Attribute Name" <> ItemAttribute.Name THEN
        "Attribute Name" := ItemAttribute.Name;
    END;

    LOCAL PROCEDURE AdjustAttributeValue@12(VAR ItemAttributeValue@1000 : Record 7501);
    BEGIN
      IF Value <> ItemAttributeValue.Value THEN
        Value := ItemAttributeValue.Value;
    END;

    LOCAL PROCEDURE ValidateChangedAttribute@5(VAR ItemAttribute@1002 : Record 7500);
    BEGIN
      IF "Attribute ID" <> ItemAttribute.ID THEN BEGIN
        VALIDATE("Attribute ID",ItemAttribute.ID);
        VALIDATE("Attribute Type",ItemAttribute.Type);
        VALIDATE("Unit of Measure",ItemAttribute."Unit of Measure");
        VALIDATE(Value,'');
      END;
    END;

    PROCEDURE FindAttributeValue@3(VAR ItemAttributeValue@1000 : Record 7501) : Boolean;
    BEGIN
      EXIT(FindAttributeValueFromRecord(ItemAttributeValue,Rec));
    END;

    PROCEDURE FindAttributeValueFromRecord@9(VAR ItemAttributeValue@1000 : Record 7501;ItemAttributeValueSelection@1002 : Record 7504) : Boolean;
    VAR
      ValDecimal@1001 : Decimal;
    BEGIN
      ItemAttributeValue.RESET;
      ItemAttributeValue.SETRANGE("Attribute ID",ItemAttributeValueSelection."Attribute ID");
      IF IsNotBlankDecimal(ItemAttributeValueSelection.Value) THEN BEGIN
        EVALUATE(ValDecimal,ItemAttributeValueSelection.Value);
        ItemAttributeValue.SETRANGE("Numeric Value",ValDecimal);
      END ELSE
        ItemAttributeValue.SETRANGE(Value,ItemAttributeValueSelection.Value);
      EXIT(ItemAttributeValue.FINDFIRST);
    END;

    PROCEDURE GetAttributeValueID@8(VAR TempItemAttributeValueToInsert@1000 : TEMPORARY Record 7501) : Integer;
    VAR
      ItemAttributeValue@1001 : Record 7501;
      ValDecimal@1003 : Decimal;
    BEGIN
      IF NOT FindAttributeValue(ItemAttributeValue) THEN BEGIN
        ItemAttributeValue."Attribute ID" := "Attribute ID";
        IF IsNotBlankDecimal(Value) THEN BEGIN
          EVALUATE(ValDecimal,Value);
          ItemAttributeValue.VALIDATE(Value,FORMAT(ValDecimal));
        END ELSE
          ItemAttributeValue.Value := Value;
        ItemAttributeValue.INSERT;
      END;
      TempItemAttributeValueToInsert.TRANSFERFIELDS(ItemAttributeValue);
      TempItemAttributeValueToInsert.INSERT;
      EXIT(ItemAttributeValue.ID);
    END;

    PROCEDURE IsNotBlankDecimal@14(TextValue@1001 : Text[250]) : Boolean;
    VAR
      ItemAttribute@1000 : Record 7500;
    BEGIN
      IF TextValue = '' THEN
        EXIT(FALSE);
      ItemAttribute.GET("Attribute ID");
      EXIT(ItemAttribute.Type = ItemAttribute.Type::Decimal);
    END;

    BEGIN
    END.
  }
}

