OBJECT Codeunit 5470 Graph Collection Mgt - Item
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      ItemUOMDescriptionTxt@1000 : TextConst '@@@={Locked};DAN=Graph CDM - Unit of Measure complex type on Item Entity page;ENU=Graph CDM - Unit of Measure complex type on Item Entity page';
      ItemUOMConversionsDescriptionTxt@1002 : TextConst '@@@={Locked};DAN=Graph CDM - Unit of Measure Conversions complex type on Item Entity page;ENU=Graph CDM - Unit of Measure Conversions complex type on Item Entity page';
      ItemCategoryDescriptionTxt@1006 : TextConst '@@@={Locked};DAN=Graph CDM - Item Category complex type on Item Enity page;ENU=Graph CDM - Item Category complex type on Item Enity page';
      ValueMustBeEqualErr@1003 : TextConst '@@@={Locked};DAN=Conversions must be specified with %1 with value %2.;ENU=Conversions must be specified with %1 with value %2.';
      BaseUnitOfMeasureCannotHaveConversionsErr@1008 : TextConst '@@@={Locked};DAN=Base Unit Of Measure must be specified on the item first.;ENU=Base Unit Of Measure must be specified on the item first.';
      TypeHelper@1001 : Codeunit 10;

    PROCEDURE InsertItemFromSalesDocument@16(VAR Item@1000 : Record 27;VAR TempFieldSet@1004 : TEMPORARY Record 2000000041;UnitOfMeasureJSON@1001 : Text);
    VAR
      GraphMgtGeneralTools@1005 : Codeunit 5465;
      RecRef@1002 : RecordRef;
      ItemModified@1006 : Boolean;
    BEGIN
      Item.INSERT(TRUE);

      UpdateOrCreateItemUnitOfMeasureFromSalesDocument(UnitOfMeasureJSON,Item,TempFieldSet,ItemModified);

      RecRef.GETTABLE(Item);
      GraphMgtGeneralTools.ProcessNewRecordFromAPI(RecRef,TempFieldSet,Item."Last DateTime Modified");
      RecRef.SETTABLE(Item);

      Item.MODIFY(TRUE);
    END;

    PROCEDURE InsertItem@10(VAR Item@1000 : Record 27;VAR TempFieldSet@1004 : TEMPORARY Record 2000000041;BaseUnitOfMeasureJSON@1001 : Text;ItemCategoryJSON@1002 : Text);
    VAR
      GraphMgtGeneralTools@1005 : Codeunit 5465;
      RecRef@1003 : RecordRef;
    BEGIN
      Item.INSERT(TRUE);

      ProcessComplexTypes(
        Item,
        BaseUnitOfMeasureJSON,
        ItemCategoryJSON
        );

      RecRef.GETTABLE(Item);
      GraphMgtGeneralTools.ProcessNewRecordFromAPI(RecRef,TempFieldSet,Item."Last DateTime Modified");
      RecRef.SETTABLE(Item);

      Item.MODIFY(TRUE);
    END;

    PROCEDURE ProcessComplexTypes@8(VAR Item@1000 : Record 27;BaseUOMJSON@1003 : Text;ItemCategoryJSON@1005 : Text);
    BEGIN
      UpdateUnitOfMeasure(BaseUOMJSON,Item.FIELDNO("Base Unit of Measure"),Item);
      UpdateItemCategory(ItemCategoryJSON,Item);
    END;

    [External]
    PROCEDURE ItemCategoryToJSON@1(ItemCategoryCode@1000 : Code[20]) : Text;
    VAR
      ItemCategory@1001 : Record 5722;
      JSONManagement@1002 : Codeunit 5459;
      JsonObject@1003 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JObject";
    BEGIN
      IF ItemCategoryCode = '' THEN
        EXIT('');

      IF NOT ItemCategory.GET(ItemCategoryCode) THEN
        EXIT('');

      JSONManagement.InitializeEmptyObject;
      JSONManagement.GetJSONObject(JsonObject);
      JSONManagement.AddJPropertyToJObject(JsonObject,ItemCategoryComplexTypeCategoryId,ItemCategory.Code);
      JSONManagement.AddJPropertyToJObject(JsonObject,ItemCategoryComplexTypeDescription,ItemCategory.Description);

      EXIT(JSONManagement.WriteObjectToString);
    END;

    PROCEDURE ItemUnitOfMeasureToJSON@7(VAR Item@1000 : Record 27;UnitOfMeasureCode@1001 : Code[10]) : Text;
    VAR
      ItemUnitOfMeasure@1004 : Record 5404;
      GraphMgtComplexTypes@1007 : Codeunit 5468;
      JSONManagement@1003 : Codeunit 5459;
      JsonObject@1002 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JObject";
      ItemUOMConversionJObject@1005 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JObject";
      UnitOfMeasureJSON@1008 : Text;
    BEGIN
      UnitOfMeasureJSON := GraphMgtComplexTypes.GetUnitOfMeasureJSON(UnitOfMeasureCode);

      IF UnitOfMeasureCode = Item."Base Unit of Measure" THEN
        EXIT(UnitOfMeasureJSON);

      IF NOT ItemUnitOfMeasure.GET(Item."No.",UnitOfMeasureCode) THEN
        EXIT(UnitOfMeasureJSON);

      JSONManagement.InitializeObject(UnitOfMeasureJSON);
      JSONManagement.GetJSONObject(JsonObject);

      ItemUOMConversionJObject := ItemUOMConversionJObject.JObject;
      JSONManagement.AddJPropertyToJObject(
        ItemUOMConversionJObject,UOMConversionComplexTypeToUnitOfMeasure,Item."Base Unit of Measure");
      JSONManagement.AddJPropertyToJObject(
        ItemUOMConversionJObject,UOMConversionComplexTypeFromToConversionRate,ItemUnitOfMeasure."Qty. per Unit of Measure");
      JSONManagement.AddJObjectToJObject(JsonObject,UOMConversionComplexTypeName,ItemUOMConversionJObject);
      EXIT(JSONManagement.WriteObjectToString);
    END;

    PROCEDURE UpdateIntegrationRecords@11(OnlyItemsWithoutId@1000 : Boolean);
    VAR
      Item@1002 : Record 27;
      GraphMgtGeneralTools@1001 : Codeunit 5465;
      ItemRecordRef@1019 : RecordRef;
    BEGIN
      ItemRecordRef.OPEN(DATABASE::Item);
      GraphMgtGeneralTools.UpdateIntegrationRecords(ItemRecordRef,Item.FIELDNO(Id),OnlyItemsWithoutId);
    END;

    PROCEDURE UpdateOrCreateItemUnitOfMeasureFromSalesDocument@6(UnitOfMeasureJSONString@1000 : Text;VAR Item@1004 : Record 27;VAR TempFieldSet@1002 : TEMPORARY Record 2000000041;VAR ItemModified@1007 : Boolean);
    VAR
      UnitOfMeasure@1005 : Record 204;
      TempUnitOfMeasure@1022 : TEMPORARY Record 204;
      ItemUnitOfMeasure@1006 : Record 5404;
      TempItemUnitOfMeasure@1023 : TEMPORARY Record 5404;
      ExpectedBaseUOMCode@1001 : Code[10];
      HasUOMConversions@1024 : Boolean;
    BEGIN
      IF UnitOfMeasureJSONString = '' THEN
        EXIT;

      ParseJSONToUnitOfMeasure(UnitOfMeasureJSONString,TempUnitOfMeasure);
      HasUOMConversions :=
        ParseJSONToItemUnitOfMeasure(UnitOfMeasureJSONString,Item,TempItemUnitOfMeasure,TempUnitOfMeasure,ExpectedBaseUOMCode);

      IF HasUOMConversions THEN BEGIN
        VerifyBaseUOMIsSet(Item,ExpectedBaseUOMCode);
        IF NOT UnitOfMeasure.GET(ExpectedBaseUOMCode) THEN BEGIN
          UnitOfMeasure.Code := ExpectedBaseUOMCode;
          UnitOfMeasure.INSERT;
        END;

        IF Item."Base Unit of Measure" = '' THEN BEGIN
          Item.VALIDATE("Base Unit of Measure",UnitOfMeasure.Code);
          RegisterFieldSet(TempFieldSet,Item.FIELDNO("Unit of Measure Id"));
          RegisterFieldSet(TempFieldSet,Item.FIELDNO("Base Unit of Measure"));
          ItemModified := TRUE;
        END;

        InsertOrUpdateItemUnitOfMeasureRecord(ItemUnitOfMeasure,TempItemUnitOfMeasure);
      END ELSE BEGIN
        InsertOrUpdateUnitOfMeasureRecord(UnitOfMeasure,TempUnitOfMeasure);

        IF Item."Base Unit of Measure" = '' THEN BEGIN
          Item.VALIDATE("Base Unit of Measure",UnitOfMeasure.Code);
          RegisterFieldSet(TempFieldSet,Item.FIELDNO("Unit of Measure Id"));
          RegisterFieldSet(TempFieldSet,Item.FIELDNO("Base Unit of Measure"));
          ItemModified := TRUE;
        END ELSE BEGIN
          // Create on the fly if it does not exist
          IF ItemUnitOfMeasure.GET(Item."No.",UnitOfMeasure.Code) THEN
            EXIT;

          ItemUnitOfMeasure."Item No." := Item."No.";
          ItemUnitOfMeasure.Code := UnitOfMeasure.Code;
          ItemUnitOfMeasure."Qty. per Unit of Measure" := 1;
          ItemUnitOfMeasure.INSERT(TRUE);
        END;
      END;
    END;

    PROCEDURE UpdateUnitOfMeasure@23(UnitOfMeasureJSONString@1000 : Text;UnitOfMeasureFieldNo@1018 : Integer;VAR Item@1004 : Record 27);
    VAR
      UnitOfMeasure@1005 : Record 204;
      TempUnitOfMeasure@1022 : TEMPORARY Record 204;
      ItemUnitOfMeasure@1006 : Record 5404;
      TempItemUnitOfMeasure@1023 : TEMPORARY Record 5404;
      ItemRecordRef@1019 : RecordRef;
      UnitOfMeasureFieldRef@1020 : FieldRef;
      PreviousUnitOfMeasureJSONString@1013 : Text;
      PreviousUOMCode@1021 : Code[10];
      HasUOMConversions@1024 : Boolean;
      BaseUnitOfMeasureCode@1001 : Code[20];
    BEGIN
      IF UnitOfMeasureJSONString = '' THEN
        EXIT;

      ItemRecordRef.GETTABLE(Item);
      UnitOfMeasureFieldRef := ItemRecordRef.FIELD(UnitOfMeasureFieldNo);

      IF UnitOfMeasureJSONString = 'null' THEN BEGIN
        UnitOfMeasureFieldRef.VALIDATE('');
        ItemRecordRef.SETTABLE(Item);
        EXIT;
      END;

      PreviousUOMCode := UnitOfMeasureFieldRef.VALUE;
      PreviousUnitOfMeasureJSONString := ItemUnitOfMeasureToJSON(Item,PreviousUOMCode);

      IF UnitOfMeasureJSONString = PreviousUnitOfMeasureJSONString THEN
        EXIT;

      ParseJSONToUnitOfMeasure(UnitOfMeasureJSONString,TempUnitOfMeasure);
      HasUOMConversions :=
        ParseJSONToItemUnitOfMeasure(UnitOfMeasureJSONString,Item,TempItemUnitOfMeasure,TempUnitOfMeasure,BaseUnitOfMeasureCode);
      IF HasUOMConversions AND (UnitOfMeasureFieldNo = Item.FIELDNO("Base Unit of Measure")) THEN
        ERROR(BaseUnitOfMeasureCannotHaveConversionsErr);

      InsertOrUpdateUnitOfMeasureRecord(UnitOfMeasure,TempUnitOfMeasure);

      IF HasUOMConversions THEN
        InsertOrUpdateItemUnitOfMeasureRecord(ItemUnitOfMeasure,TempItemUnitOfMeasure);

      IF PreviousUOMCode <> UnitOfMeasure.Code THEN
        UnitOfMeasureFieldRef.VALIDATE(UnitOfMeasure.Code);

      ItemRecordRef.SETTABLE(Item);
    END;

    LOCAL PROCEDURE InsertOrUpdateUnitOfMeasureRecord@22(VAR UnitOfMeasure@1003 : Record 204;VAR TempUnitOfMeasure@1002 : TEMPORARY Record 204);
    VAR
      Modify@1000 : Boolean;
    BEGIN
      IF TempUnitOfMeasure.Code = '' THEN
        EXIT;

      IF NOT UnitOfMeasure.GET(TempUnitOfMeasure.Code) THEN BEGIN
        UnitOfMeasure.TRANSFERFIELDS(TempUnitOfMeasure,TRUE);
        UnitOfMeasure.INSERT(TRUE);
        EXIT;
      END;

      IF NOT (TempUnitOfMeasure.Description IN [UnitOfMeasure.Description,'']) THEN BEGIN
        UnitOfMeasure.VALIDATE(Description,TempUnitOfMeasure.Description);
        Modify := TRUE;
      END;

      IF NOT (TempUnitOfMeasure.Symbol IN [UnitOfMeasure.Symbol,'']) THEN BEGIN
        UnitOfMeasure.VALIDATE(Symbol,TempUnitOfMeasure.Symbol);
        Modify := TRUE;
      END;

      IF Modify THEN
        UnitOfMeasure.MODIFY(TRUE);
    END;

    LOCAL PROCEDURE InsertOrUpdateItemUnitOfMeasureRecord@28(VAR ItemUnitOfMeasure@1003 : Record 5404;VAR TempItemUnitOfMeasure@1002 : TEMPORARY Record 5404);
    BEGIN
      IF NOT ItemUnitOfMeasure.GET(TempItemUnitOfMeasure."Item No.",TempItemUnitOfMeasure.Code) THEN BEGIN
        ItemUnitOfMeasure.TRANSFERFIELDS(TempItemUnitOfMeasure,TRUE);
        ItemUnitOfMeasure.INSERT(TRUE);
      END ELSE BEGIN
        IF TempItemUnitOfMeasure."Qty. per Unit of Measure" = ItemUnitOfMeasure."Qty. per Unit of Measure" THEN
          EXIT;

        ItemUnitOfMeasure.VALIDATE("Qty. per Unit of Measure",TempItemUnitOfMeasure."Qty. per Unit of Measure");
        ItemUnitOfMeasure.MODIFY(TRUE);
      END;
    END;

    PROCEDURE ParseJSONToUnitOfMeasure@5(UnitOfMeasureJSONString@1000 : Text;VAR UnitOfMeasure@1005 : Record 204);
    VAR
      GraphMgtGeneralTools@1001 : Codeunit 5465;
      JSONManagement@1010 : Codeunit 5459;
      JsonObject@1009 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JObject";
      UnitCode@1003 : Text;
    BEGIN
      JSONManagement.InitializeObject(UnitOfMeasureJSONString);
      JSONManagement.GetJSONObject(JsonObject);

      GraphMgtGeneralTools.GetMandatoryStringPropertyFromJObject(JsonObject,UOMComplexTypeUnitCode,UnitCode);
      UnitOfMeasure.Code := COPYSTR(UnitCode,1,MAXSTRLEN(UnitOfMeasure.Code));
      JSONManagement.GetStringPropertyValueFromJObjectByName(JsonObject,UOMComplexTypeUnitName,UnitOfMeasure.Description);
      JSONManagement.GetStringPropertyValueFromJObjectByName(JsonObject,UOMComplexTypeSymbol,UnitOfMeasure.Symbol);
    END;

    LOCAL PROCEDURE ParseJSONToItemUnitOfMeasure@9(UnitOfMeasureJSONString@1000 : Text;VAR Item@1006 : Record 27;VAR TempItemUnitOfMeasure@1004 : TEMPORARY Record 5404;VAR UnitOfMeasure@1018 : Record 204;VAR BaseUnitOfMeasureCode@1002 : Code[20]) : Boolean;
    VAR
      GraphMgtGeneralTools@1001 : Codeunit 5465;
      JSONManagement@1010 : Codeunit 5459;
      JsonObject@1009 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JObject";
      ConversionsTxt@1016 : Text;
      FromToConversionRateTxt@1008 : Text;
      BaseUnitOfMeasureTxt@1003 : Text;
    BEGIN
      JSONManagement.InitializeObject(UnitOfMeasureJSONString);
      JSONManagement.GetJSONObject(JsonObject);

      IF NOT JSONManagement.GetStringPropertyValueFromJObjectByName(JsonObject,UOMConversionComplexTypeName,ConversionsTxt) THEN
        EXIT(FALSE);

      IF ConversionsTxt = '' THEN
        EXIT(FALSE);

      IF ConversionsTxt = 'null' THEN
        EXIT(FALSE);

      JSONManagement.InitializeObject(ConversionsTxt);
      JSONManagement.GetJSONObject(JsonObject);

      GraphMgtGeneralTools.GetMandatoryStringPropertyFromJObject(
        JsonObject,UOMConversionComplexTypeToUnitOfMeasure,BaseUnitOfMeasureTxt);
      BaseUnitOfMeasureCode := COPYSTR(BaseUnitOfMeasureTxt,1,20);

      GraphMgtGeneralTools.GetMandatoryStringPropertyFromJObject(
        JsonObject,UOMConversionComplexTypeFromToConversionRate,FromToConversionRateTxt);
      EVALUATE(TempItemUnitOfMeasure."Qty. per Unit of Measure",FromToConversionRateTxt);
      TempItemUnitOfMeasure."Item No." := Item."No.";
      TempItemUnitOfMeasure.Code := UnitOfMeasure.Code;
      TempItemUnitOfMeasure.INSERT;

      EXIT(TRUE);
    END;

    LOCAL PROCEDURE UpdateItemCategory@29(ItemCategoryJSONString@1001 : Text;VAR Item@1002 : Record 27);
    VAR
      ItemCategory@1008 : Record 5722;
      PreviousItemCategoryJSONString@1000 : Text;
    BEGIN
      IF ItemCategoryJSONString = '' THEN
        EXIT;

      IF ItemCategoryJSONString = 'null' THEN BEGIN
        Item.VALIDATE("Item Category Code",'');
        EXIT;
      END;

      PreviousItemCategoryJSONString := ItemCategoryToJSON(Item."Item Category Code");
      IF ItemCategoryJSONString = PreviousItemCategoryJSONString THEN
        EXIT;

      UpdateOrCreateItemCategory(ItemCategoryJSONString,ItemCategory);

      IF Item."Item Category Code" <> ItemCategory.Code THEN
        Item.VALIDATE("Item Category Code",ItemCategory.Code);
    END;

    LOCAL PROCEDURE UpdateOrCreateItemCategory@31(ItemCategoryJSONString@1001 : Text;VAR ItemCategory@1002 : Record 5722);
    VAR
      TempItemCategory@1009 : TEMPORARY Record 5722;
    BEGIN
      ParseJSONToItemCategory(ItemCategoryJSONString,TempItemCategory);

      IF TempItemCategory.Code = '' THEN
        EXIT;

      IF NOT ItemCategory.GET(TempItemCategory.Code) THEN BEGIN
        ItemCategory.TRANSFERFIELDS(TempItemCategory,TRUE);
        ItemCategory.INSERT(TRUE);
        EXIT;
      END;

      IF ItemCategory.Description = TempItemCategory.Description THEN
        EXIT;

      ItemCategory.VALIDATE(Description,TempItemCategory.Description);
      ItemCategory.MODIFY(TRUE);
    END;

    LOCAL PROCEDURE ParseJSONToItemCategory@44(ItemCategoryJSONString@1006 : Text;VAR TempItemCategory@1005 : TEMPORARY Record 5722);
    VAR
      GraphMgtGeneralTools@1000 : Codeunit 5465;
      JSONManagement@1004 : Codeunit 5459;
      JsonObject@1003 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JObject";
      CategoryCode@1002 : Text;
    BEGIN
      JSONManagement.InitializeObject(ItemCategoryJSONString);
      JSONManagement.GetJSONObject(JsonObject);
      TempItemCategory.INIT;
      GraphMgtGeneralTools.GetMandatoryStringPropertyFromJObject(JsonObject,ItemCategoryComplexTypeCategoryId,CategoryCode);
      TempItemCategory.Code := COPYSTR(CategoryCode,1,MAXSTRLEN(TempItemCategory.Code));
      JSONManagement.GetStringPropertyValueFromJObjectByName(
        JsonObject,ItemCategoryComplexTypeDescription,TempItemCategory.Description);
    END;

    [Internal]
    PROCEDURE WriteItemEDMComplexTypes@3();
    VAR
      GraphMgtGeneralTools@1000 : Codeunit 5465;
    BEGIN
      GraphMgtGeneralTools.InsertOrUpdateODataType('ITEM-UOM',ItemUOMDescriptionTxt,GetItemUOMEDM('ITEM-UOM-CONVERSION'));
      GraphMgtGeneralTools.InsertOrUpdateODataType('ITEM-UOM-CONVERSION',ItemUOMConversionsDescriptionTxt,GetItemUOMConversionEDM);
      GraphMgtGeneralTools.InsertOrUpdateODataType('ITEM-CATEGORY',ItemCategoryDescriptionTxt,GetItemCategoryEDM);
    END;

    LOCAL PROCEDURE GetItemUOMEDM@4(UOMConversionDefinitionCode@1000 : Code[50]) : Text;
    VAR
      DummyUnitOfMeasure@1001 : Record 204;
    BEGIN
      EXIT(
        '<ComplexType Name="UnitOfMeasure">' +
        STRSUBSTNO('<Property Name="%1" Type="Edm.String" Nullable="true" MaxLength="%2" />',
          UOMComplexTypeUnitCode,MAXSTRLEN(DummyUnitOfMeasure.Code)) +
        STRSUBSTNO('<Property Name="%1" Type="Edm.String" Nullable="true" MaxLength="%2" />',
          UOMComplexTypeUnitName,MAXSTRLEN(DummyUnitOfMeasure.Description)) +
        STRSUBSTNO('<Property Name="%1" Type="Edm.String" Nullable="true" MaxLength="%2" />',
          UOMComplexTypeSymbol,MAXSTRLEN(DummyUnitOfMeasure.Symbol)) +
        STRSUBSTNO('<Property Name="%1" Type="%2" Nullable="true" />',
          UOMConversionComplexTypeName,UOMConversionDefinitionCode) +
        '</ComplexType>');
    END;

    LOCAL PROCEDURE GetItemUOMConversionEDM@13() : Text;
    VAR
      DummyItem@1000 : Record 27;
    BEGIN
      EXIT(
        '<ComplexType Name="ItemUnitOfMeasureConversion">' +
        STRSUBSTNO('<Property Name="%1" Type="Edm.String" Nullable="true" MaxLength="%2" />',
          UOMConversionComplexTypeToUnitOfMeasure,MAXSTRLEN(DummyItem."Base Unit of Measure")) +
        STRSUBSTNO('<Property Name="%1" Type="Edm.Decimal" Nullable="true" />',
          UOMConversionComplexTypeFromToConversionRate) +
        '</ComplexType>');
    END;

    LOCAL PROCEDURE GetItemCategoryEDM@20() : Text;
    VAR
      DummyItemCategory@1000 : Record 5722;
    BEGIN
      EXIT(
        '<ComplexType Name="ItemCategory">' +
        STRSUBSTNO('<Property Name="%1" Type="Edm.String" Nullable="true" MaxLength="%2" />',
          ItemCategoryComplexTypeCategoryId,MAXSTRLEN(DummyItemCategory.Code)) +
        STRSUBSTNO('<Property Name="%1" Type="Edm.String" Nullable="true" MaxLength="%2" />',
          ItemCategoryComplexTypeDescription,MAXSTRLEN(DummyItemCategory.Description)) +
        '</ComplexType>'
        );
    END;

    LOCAL PROCEDURE EnableItemODataWebService@34();
    BEGIN
      WriteItemEDMComplexTypes;
      UpdateIntegrationRecords(FALSE);
    END;

    PROCEDURE SetLastDateTimeModified@37();
    VAR
      Item@1001 : Record 27;
      DateFilterCalc@1000 : Codeunit 358;
      CombinedDateTime@1002 : DateTime;
    BEGIN
      Item.SETRANGE("Last DateTime Modified",0DT);
      IF NOT Item.FINDSET THEN
        EXIT;

      REPEAT
        CombinedDateTime := CREATEDATETIME(Item."Last Date Modified",Item."Last Time Modified");
        Item."Last DateTime Modified" := DateFilterCalc.ConvertToUtcDateTime(CombinedDateTime);
        Item.MODIFY;
      UNTIL Item.NEXT = 0;
    END;

    PROCEDURE ItemCategoryComplexTypeCategoryId@39() : Text;
    BEGIN
      EXIT('categoryId');
    END;

    [External]
    PROCEDURE ItemCategoryComplexTypeDescription@40() : Text;
    BEGIN
      EXIT('description');
    END;

    LOCAL PROCEDURE RegisterFieldSet@12(VAR TempFieldSet@1001 : TEMPORARY Record 2000000041;FieldNo@1000 : Integer);
    BEGIN
      IF TypeHelper.GetField(DATABASE::Item,FieldNo,TempFieldSet) THEN
        EXIT;

      TempFieldSet.INIT;
      TempFieldSet.TableNo := DATABASE::Item;
      TempFieldSet.VALIDATE("No.",FieldNo);
      TempFieldSet.INSERT(TRUE);
    END;

    PROCEDURE UOMComplexTypeUnitCode@27() : Text;
    BEGIN
      EXIT('code');
    END;

    [External]
    PROCEDURE UOMComplexTypeUnitName@30() : Text;
    BEGIN
      EXIT('displayName');
    END;

    PROCEDURE UOMComplexTypeSymbol@32() : Text;
    BEGIN
      EXIT('symbol');
    END;

    [External]
    PROCEDURE UOMConversionComplexTypeName@15() : Text;
    BEGIN
      EXIT('unitConversion');
    END;

    [External]
    PROCEDURE UOMConversionComplexTypeToUnitOfMeasure@42() : Text;
    BEGIN
      EXIT('toUnitOfMeasure');
    END;

    PROCEDURE UOMConversionComplexTypeFromToConversionRate@43() : Text;
    BEGIN
      EXIT('fromToConversionRate');
    END;

    LOCAL PROCEDURE VerifyBaseUOMIsSet@14(VAR Item@1000 : Record 27;BaseUnitOfMeasure@1001 : Code[20]);
    BEGIN
      IF Item."Base Unit of Measure" = '' THEN
        EXIT;

      IF Item."Base Unit of Measure" <> UPPERCASE(BaseUnitOfMeasure) THEN
        ERROR(ValueMustBeEqualErr,UOMConversionComplexTypeToUnitOfMeasure,Item."Base Unit of Measure");
    END;

    [EventSubscriber(Codeunit,5150,OnUpdateReferencedIdField)]
    LOCAL PROCEDURE HandleUpdateReferencedIdFieldOnItem@19(VAR RecRef@1000 : RecordRef;NewId@1001 : GUID;VAR Handled@1002 : Boolean);
    VAR
      DummyItem@1004 : Record 27;
      GraphMgtGeneralTools@1006 : Codeunit 5465;
    BEGIN
      GraphMgtGeneralTools.HandleUpdateReferencedIdFieldOnItem(RecRef,NewId,Handled,DATABASE::Item,DummyItem.FIELDNO(Id));
    END;

    [EventSubscriber(Codeunit,5150,OnGetPredefinedIdValue)]
    LOCAL PROCEDURE HandleGetPredefinedIdValue@21(VAR Id@1000 : GUID;VAR RecRef@1001 : RecordRef;VAR Handled@1002 : Boolean);
    VAR
      DummyItem@1004 : Record 27;
      GraphMgtGeneralTools@1007 : Codeunit 5465;
    BEGIN
      GraphMgtGeneralTools.HandleGetPredefinedIdValue(Id,RecRef,Handled,DATABASE::Item,DummyItem.FIELDNO(Id));
    END;

    [EventSubscriber(Codeunit,5465,ApiSetup)]
    LOCAL PROCEDURE HandleApiSetup@2();
    BEGIN
      EnableItemODataWebService;
      UpdateIntegrationRecords(FALSE);
      UpdateIds;
    END;

    PROCEDURE UpdateIds@24();
    VAR
      Item@1000 : Record 27;
    BEGIN
      WITH Item DO BEGIN
        IF FINDSET THEN
          REPEAT
            UpdateUnitOfMeasureId;
            UpdateTaxGroupId;
            MODIFY(FALSE);
          UNTIL NEXT = 0;
      END;
    END;

    BEGIN
    END.
  }
}

