OBJECT Codeunit 7500 Item Attribute Management
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      DeleteAttributesInheritedFromOldCategoryQst@1000 : TextConst '@@@=%1 - item category code;DAN=Vil du slette de attributter, der er nedarvet fra varekategorien ''%1''?;ENU=Do you want to delete the attributes that are inherited from item category ''%1''?';
      DeleteItemInheritedParentCategoryAttributesQst@1001 : TextConst '@@@=%1 - item category code,%2 - item category code;DAN=En eller flere varer tilh�rer varekategorien ''''%1'''', der er underordnet varekategorien''''%2''''.\\Vil du slette de nedarvede vareattributter for de p�g�ldende varer?;ENU=One or more items belong to item category ''''%1'''', which is a child of item category ''''%2''''.\\Do you want to delete the inherited item attributes for the items in question?';

    [Internal]
    PROCEDURE FindItemsByAttribute@1(VAR FilterItemAttributesBuffer@1001 : Record 7506) ItemFilter : Text;
    VAR
      ItemAttributeValueMapping@1003 : Record 7505;
      ItemAttribute@1000 : Record 7500;
      AttributeValueIDFilter@1005 : Text;
      CurrentItemFilter@1002 : Text;
    BEGIN
      IF NOT FilterItemAttributesBuffer.FINDSET THEN
        EXIT;

      ItemFilter := '<>*';

      ItemAttributeValueMapping.SETRANGE("Table ID",DATABASE::Item);
      CurrentItemFilter := '*';

      REPEAT
        ItemAttribute.SETRANGE(Name,FilterItemAttributesBuffer.Attribute);
        IF ItemAttribute.FINDFIRST THEN BEGIN
          ItemAttributeValueMapping.SETRANGE("Item Attribute ID",ItemAttribute.ID);
          AttributeValueIDFilter := GetItemAttributeValueFilter(FilterItemAttributesBuffer,ItemAttribute);
          IF AttributeValueIDFilter = '' THEN
            EXIT;

          CurrentItemFilter := GetItemNoFilter(ItemAttributeValueMapping,CurrentItemFilter,AttributeValueIDFilter);
          IF CurrentItemFilter = '' THEN
            EXIT;
        END;
      UNTIL FilterItemAttributesBuffer.NEXT = 0;

      ItemFilter := CurrentItemFilter;
    END;

    [External]
    PROCEDURE FindItemsByAttributes@50(VAR FilterItemAttributesBuffer@1001 : Record 7506;VAR TempFilteredItem@1004 : TEMPORARY Record 27);
    VAR
      ItemAttributeValueMapping@1003 : Record 7505;
      ItemAttribute@1000 : Record 7500;
      AttributeValueIDFilter@1005 : Text;
    BEGIN
      IF NOT FilterItemAttributesBuffer.FINDSET THEN
        EXIT;

      ItemAttributeValueMapping.SETRANGE("Table ID",DATABASE::Item);

      REPEAT
        ItemAttribute.SETRANGE(Name,FilterItemAttributesBuffer.Attribute);
        IF ItemAttribute.FINDFIRST THEN BEGIN
          ItemAttributeValueMapping.SETRANGE("Item Attribute ID",ItemAttribute.ID);
          AttributeValueIDFilter := GetItemAttributeValueFilter(FilterItemAttributesBuffer,ItemAttribute);
          IF AttributeValueIDFilter = '' THEN BEGIN
            TempFilteredItem.DELETEALL;
            EXIT;
          END;

          GetFilteredItems(ItemAttributeValueMapping,TempFilteredItem,AttributeValueIDFilter);
          IF TempFilteredItem.ISEMPTY THEN
            EXIT;
        END;
      UNTIL FilterItemAttributesBuffer.NEXT = 0;
    END;

    LOCAL PROCEDURE GetItemAttributeValueFilter@9(VAR FilterItemAttributesBuffer@1000 : Record 7506;VAR ItemAttribute@1003 : Record 7500) AttributeFilter : Text;
    VAR
      ItemAttributeValue@1001 : Record 7501;
    BEGIN
      ItemAttributeValue.SETRANGE("Attribute ID",ItemAttribute.ID);
      ItemAttributeValue.SetValueFilter(ItemAttribute,FilterItemAttributesBuffer.Value);

      IF NOT ItemAttributeValue.FINDSET THEN
        EXIT;

      REPEAT
        AttributeFilter += STRSUBSTNO('%1|',ItemAttributeValue.ID);
      UNTIL ItemAttributeValue.NEXT = 0;

      EXIT(COPYSTR(AttributeFilter,1,STRLEN(AttributeFilter) - 1));
    END;

    LOCAL PROCEDURE GetItemNoFilter@24(VAR ItemAttributeValueMapping@1001 : Record 7505;PreviousItemNoFilter@1000 : Text;AttributeValueIDFilter@1002 : Text) ItemNoFilter : Text;
    BEGIN
      ItemAttributeValueMapping.SETFILTER("No.",PreviousItemNoFilter);
      ItemAttributeValueMapping.SETFILTER("Item Attribute Value ID",AttributeValueIDFilter);

      IF NOT ItemAttributeValueMapping.FINDSET THEN
        EXIT;

      REPEAT
        ItemNoFilter += STRSUBSTNO('%1|',ItemAttributeValueMapping."No.");
      UNTIL ItemAttributeValueMapping.NEXT = 0;

      EXIT(COPYSTR(ItemNoFilter,1,STRLEN(ItemNoFilter) - 1));
    END;

    LOCAL PROCEDURE GetFilteredItems@51(VAR ItemAttributeValueMapping@1001 : Record 7505;VAR TempFilteredItem@1000 : TEMPORARY Record 27;AttributeValueIDFilter@1002 : Text);
    VAR
      Item@1003 : Record 27;
    BEGIN
      ItemAttributeValueMapping.SETFILTER("Item Attribute Value ID",AttributeValueIDFilter);

      IF ItemAttributeValueMapping.ISEMPTY THEN BEGIN
        TempFilteredItem.RESET;
        TempFilteredItem.DELETEALL;
        EXIT;
      END;

      IF NOT TempFilteredItem.FINDSET THEN BEGIN
        IF ItemAttributeValueMapping.FINDSET THEN
          REPEAT
            Item.GET(ItemAttributeValueMapping."No.");
            TempFilteredItem.TRANSFERFIELDS(Item);
            TempFilteredItem.INSERT;
          UNTIL ItemAttributeValueMapping.NEXT = 0;
        EXIT;
      END;

      REPEAT
        ItemAttributeValueMapping.SETRANGE("No.",TempFilteredItem."No.");
        IF ItemAttributeValueMapping.ISEMPTY THEN
          TempFilteredItem.DELETE;
      UNTIL TempFilteredItem.NEXT = 0;
      ItemAttributeValueMapping.SETRANGE("No.");
    END;

    [External]
    PROCEDURE GetItemNoFilterText@12(VAR TempFilteredItem@1000 : TEMPORARY Record 27;VAR ParameterCount@1004 : Integer) FilterText : Text;
    VAR
      NextItem@1002 : Record 27;
      PreviousNo@1001 : Code[20];
      FilterRangeStarted@1003 : Boolean;
    BEGIN
      IF NOT TempFilteredItem.FINDSET THEN BEGIN
        FilterText := '<>*';
        EXIT;
      END;

      REPEAT
        IF FilterText = '' THEN BEGIN
          FilterText := TempFilteredItem."No.";
          NextItem."No." := TempFilteredItem."No.";
          ParameterCount += 1;
        END ELSE BEGIN
          IF NextItem.NEXT = 0 THEN
            NextItem."No." := '';
          IF TempFilteredItem."No." = NextItem."No." THEN BEGIN
            IF NOT FilterRangeStarted THEN
              FilterText += '..';
            FilterRangeStarted := TRUE;
          END ELSE BEGIN
            IF NOT FilterRangeStarted THEN BEGIN
              FilterText += STRSUBSTNO('|%1',TempFilteredItem."No.");
              ParameterCount += 1;
            END ELSE BEGIN
              FilterText += STRSUBSTNO('%1|%2',PreviousNo,TempFilteredItem."No.");
              FilterRangeStarted := FALSE;
              ParameterCount += 2;
            END;
            NextItem := TempFilteredItem;
          END;
        END;
        PreviousNo := TempFilteredItem."No.";
      UNTIL TempFilteredItem.NEXT = 0;

      // close range if needed
      IF FilterRangeStarted THEN BEGIN
        FilterText += STRSUBSTNO('%1',PreviousNo);
        ParameterCount += 1;
      END;
    END;

    [External]
    PROCEDURE InheritAttributesFromItemCategory@13(Item@1007 : Record 27;NewItemCategoryCode@1002 : Code[20];OldItemCategoryCode@1003 : Code[20]);
    VAR
      TempItemAttributeValueToInsert@1005 : TEMPORARY Record 7501;
      TempItemAttributeValueToDelete@1004 : TEMPORARY Record 7501;
    BEGIN
      GenerateAttributesToInsertAndToDelete(
        TempItemAttributeValueToInsert,TempItemAttributeValueToDelete,NewItemCategoryCode,OldItemCategoryCode);

      IF NOT TempItemAttributeValueToDelete.ISEMPTY THEN
        IF NOT GUIALLOWED THEN
          DeleteItemAttributeValueMapping(Item,TempItemAttributeValueToDelete)
        ELSE
          IF CONFIRM(STRSUBSTNO(DeleteAttributesInheritedFromOldCategoryQst,OldItemCategoryCode)) THEN
            DeleteItemAttributeValueMapping(Item,TempItemAttributeValueToDelete);

      IF NOT TempItemAttributeValueToInsert.ISEMPTY THEN
        InsertItemAttributeValueMapping(Item,TempItemAttributeValueToInsert);
    END;

    [External]
    PROCEDURE UpdateCategoryAttributesAfterChangingParentCategory@2(ItemCategoryCode@1000 : Code[20];NewParentItemCategory@1001 : Code[20];OldParentItemCategory@1002 : Code[20]);
    VAR
      TempNewParentItemAttributeValue@1007 : TEMPORARY Record 7501;
      TempOldParentItemAttributeValue@1006 : TEMPORARY Record 7501;
    BEGIN
      TempNewParentItemAttributeValue.LoadCategoryAttributesFactBoxData(NewParentItemCategory);
      TempOldParentItemAttributeValue.LoadCategoryAttributesFactBoxData(OldParentItemCategory);
      UpdateCategoryItemsAttributeValueMapping(
        TempNewParentItemAttributeValue,TempOldParentItemAttributeValue,ItemCategoryCode,OldParentItemCategory);
    END;

    LOCAL PROCEDURE GenerateAttributesToInsertAndToDelete@6(VAR TempItemAttributeValueToInsert@1003 : TEMPORARY Record 7501;VAR TempItemAttributeValueToDelete@1002 : TEMPORARY Record 7501;NewItemCategoryCode@1001 : Code[20];OldItemCategoryCode@1000 : Code[20]);
    VAR
      TempNewCategItemAttributeValue@1005 : TEMPORARY Record 7501;
      TempOldCategItemAttributeValue@1004 : TEMPORARY Record 7501;
    BEGIN
      TempNewCategItemAttributeValue.LoadCategoryAttributesFactBoxData(NewItemCategoryCode);
      TempOldCategItemAttributeValue.LoadCategoryAttributesFactBoxData(OldItemCategoryCode);
      GenerateAttributeDifference(TempNewCategItemAttributeValue,TempOldCategItemAttributeValue,TempItemAttributeValueToInsert);
      GenerateAttributeDifference(TempOldCategItemAttributeValue,TempNewCategItemAttributeValue,TempItemAttributeValueToDelete);
    END;

    LOCAL PROCEDURE GenerateAttributeDifference@16(VAR TempFirstItemAttributeValue@1002 : TEMPORARY Record 7501;VAR TempSecondItemAttributeValue@1001 : TEMPORARY Record 7501;VAR TempResultingItemAttributeValue@1000 : TEMPORARY Record 7501);
    BEGIN
      IF TempFirstItemAttributeValue.FINDFIRST THEN
        REPEAT
          TempSecondItemAttributeValue.SETRANGE("Attribute ID",TempFirstItemAttributeValue."Attribute ID");
          IF TempSecondItemAttributeValue.ISEMPTY THEN BEGIN
            TempResultingItemAttributeValue.TRANSFERFIELDS(TempFirstItemAttributeValue);
            TempResultingItemAttributeValue.INSERT;
          END;
          TempSecondItemAttributeValue.RESET;
        UNTIL TempFirstItemAttributeValue.NEXT = 0;
    END;

    [External]
    PROCEDURE DeleteItemAttributeValueMapping@29(Item@1002 : Record 27;VAR TempItemAttributeValueToRemove@1000 : TEMPORARY Record 7501);
    BEGIN
      DeleteItemAttributeValueMappingWithTriggerOption(Item,TempItemAttributeValueToRemove,TRUE);
    END;

    LOCAL PROCEDURE DeleteItemAttributeValueMappingWithTriggerOption@18(Item@1002 : Record 27;VAR TempItemAttributeValueToRemove@1000 : TEMPORARY Record 7501;RunTrigger@1004 : Boolean);
    VAR
      ItemAttributeValueMapping@1001 : Record 7505;
      ItemAttributeValuesToRemoveTxt@1003 : Text;
    BEGIN
      ItemAttributeValueMapping.SETRANGE("Table ID",DATABASE::Item);
      ItemAttributeValueMapping.SETRANGE("No.",Item."No.");
      IF TempItemAttributeValueToRemove.FINDFIRST THEN BEGIN
        REPEAT
          IF ItemAttributeValuesToRemoveTxt <> '' THEN
            ItemAttributeValuesToRemoveTxt += STRSUBSTNO('|%1',TempItemAttributeValueToRemove."Attribute ID")
          ELSE
            ItemAttributeValuesToRemoveTxt := FORMAT(TempItemAttributeValueToRemove."Attribute ID");
        UNTIL TempItemAttributeValueToRemove.NEXT = 0;
        ItemAttributeValueMapping.SETFILTER("Item Attribute ID",ItemAttributeValuesToRemoveTxt);
        ItemAttributeValueMapping.DELETEALL(RunTrigger);
      END;
    END;

    LOCAL PROCEDURE InsertItemAttributeValueMapping@43(Item@1002 : Record 27;VAR TempItemAttributeValueToInsert@1000 : TEMPORARY Record 7501);
    VAR
      ItemAttributeValueMapping@1001 : Record 7505;
    BEGIN
      IF TempItemAttributeValueToInsert.FINDFIRST THEN
        REPEAT
          ItemAttributeValueMapping."Table ID" := DATABASE::Item;
          ItemAttributeValueMapping."No." := Item."No.";
          ItemAttributeValueMapping."Item Attribute ID" := TempItemAttributeValueToInsert."Attribute ID";
          ItemAttributeValueMapping."Item Attribute Value ID" := TempItemAttributeValueToInsert.ID;
          IF ItemAttributeValueMapping.INSERT(TRUE) THEN;
        UNTIL TempItemAttributeValueToInsert.NEXT = 0;
    END;

    [External]
    PROCEDURE UpdateCategoryItemsAttributeValueMapping@4(VAR TempNewItemAttributeValue@1003 : TEMPORARY Record 7501;VAR TempOldItemAttributeValue@1002 : TEMPORARY Record 7501;ItemCategoryCode@1004 : Code[20];OldItemCategoryCode@1005 : Code[20]);
    VAR
      TempItemAttributeValueToInsert@1001 : TEMPORARY Record 7501;
      TempItemAttributeValueToDelete@1000 : TEMPORARY Record 7501;
    BEGIN
      GenerateAttributeDifference(TempNewItemAttributeValue,TempOldItemAttributeValue,TempItemAttributeValueToInsert);
      GenerateAttributeDifference(TempOldItemAttributeValue,TempNewItemAttributeValue,TempItemAttributeValueToDelete);

      IF NOT TempItemAttributeValueToDelete.ISEMPTY THEN
        IF NOT GUIALLOWED THEN
          DeleteCategoryItemsAttributeValueMapping(TempItemAttributeValueToDelete,ItemCategoryCode)
        ELSE
          IF CONFIRM(STRSUBSTNO(DeleteItemInheritedParentCategoryAttributesQst,ItemCategoryCode,OldItemCategoryCode)) THEN
            DeleteCategoryItemsAttributeValueMapping(TempItemAttributeValueToDelete,ItemCategoryCode);

      IF NOT TempItemAttributeValueToInsert.ISEMPTY THEN
        InsertCategoryItemsAttributeValueMapping(TempItemAttributeValueToInsert,ItemCategoryCode);
    END;

    [External]
    PROCEDURE DeleteCategoryItemsAttributeValueMapping@8(VAR TempItemAttributeValueToRemove@1000 : TEMPORARY Record 7501;CategoryCode@1002 : Code[20]);
    VAR
      Item@1003 : Record 27;
      ItemCategory@1004 : Record 5722;
      ItemAttributeValueMapping@1001 : Record 7505;
      ItemAttributeValue@1005 : Record 7501;
    BEGIN
      Item.SETRANGE("Item Category Code",CategoryCode);
      IF Item.FINDSET THEN
        REPEAT
          DeleteItemAttributeValueMappingWithTriggerOption(Item,TempItemAttributeValueToRemove,FALSE);
        UNTIL Item.NEXT = 0;

      ItemCategory.SETRANGE("Parent Category",CategoryCode);
      IF ItemCategory.FINDSET THEN
        REPEAT
          DeleteCategoryItemsAttributeValueMapping(TempItemAttributeValueToRemove,ItemCategory.Code);
        UNTIL ItemCategory.NEXT = 0;

      IF TempItemAttributeValueToRemove.FINDSET THEN
        REPEAT
          ItemAttributeValueMapping.SETRANGE("Item Attribute ID",TempItemAttributeValueToRemove."Attribute ID");
          ItemAttributeValueMapping.SETRANGE("Item Attribute Value ID",TempItemAttributeValueToRemove.ID);
          IF ItemAttributeValueMapping.ISEMPTY THEN
            IF ItemAttributeValue.GET(TempItemAttributeValueToRemove."Attribute ID",TempItemAttributeValueToRemove.ID) THEN
              ItemAttributeValue.DELETE;
        UNTIL TempItemAttributeValueToRemove.NEXT = 0;
    END;

    [External]
    PROCEDURE InsertCategoryItemsAttributeValueMapping@7(VAR TempItemAttributeValueToInsert@1000 : TEMPORARY Record 7501;CategoryCode@1002 : Code[20]);
    VAR
      Item@1003 : Record 27;
      ItemCategory@1001 : Record 5722;
    BEGIN
      Item.SETRANGE("Item Category Code",CategoryCode);
      IF Item.FINDSET THEN
        REPEAT
          InsertItemAttributeValueMapping(Item,TempItemAttributeValueToInsert);
        UNTIL Item.NEXT = 0;

      ItemCategory.SETRANGE("Parent Category",CategoryCode);
      IF ItemCategory.FINDSET THEN
        REPEAT
          InsertCategoryItemsAttributeValueMapping(TempItemAttributeValueToInsert,ItemCategory.Code);
        UNTIL ItemCategory.NEXT = 0;
    END;

    [External]
    PROCEDURE InsertCategoryItemsBufferedAttributeValueMapping@10(VAR TempItemAttributeValueToInsert@1000 : TEMPORARY Record 7501;VAR TempInsertedItemAttributeValueMapping@1004 : TEMPORARY Record 7505;CategoryCode@1002 : Code[20]);
    VAR
      Item@1003 : Record 27;
      ItemCategory@1001 : Record 5722;
    BEGIN
      Item.SETRANGE("Item Category Code",CategoryCode);
      IF Item.FINDSET THEN
        REPEAT
          InsertBufferedItemAttributeValueMapping(Item,TempItemAttributeValueToInsert,TempInsertedItemAttributeValueMapping);
        UNTIL Item.NEXT = 0;

      ItemCategory.SETRANGE("Parent Category",CategoryCode);
      IF ItemCategory.FINDSET THEN
        REPEAT
          InsertCategoryItemsBufferedAttributeValueMapping(
            TempItemAttributeValueToInsert,TempInsertedItemAttributeValueMapping,ItemCategory.Code);
        UNTIL ItemCategory.NEXT = 0;
    END;

    LOCAL PROCEDURE InsertBufferedItemAttributeValueMapping@11(Item@1002 : Record 27;VAR TempItemAttributeValueToInsert@1000 : TEMPORARY Record 7501;VAR TempInsertedItemAttributeValueMapping@1003 : TEMPORARY Record 7505);
    VAR
      ItemAttributeValueMapping@1001 : Record 7505;
    BEGIN
      IF TempItemAttributeValueToInsert.FINDFIRST THEN
        REPEAT
          ItemAttributeValueMapping."Table ID" := DATABASE::Item;
          ItemAttributeValueMapping."No." := Item."No.";
          ItemAttributeValueMapping."Item Attribute ID" := TempItemAttributeValueToInsert."Attribute ID";
          ItemAttributeValueMapping."Item Attribute Value ID" := TempItemAttributeValueToInsert.ID;
          IF ItemAttributeValueMapping.INSERT(TRUE) THEN BEGIN
            TempInsertedItemAttributeValueMapping.TRANSFERFIELDS(ItemAttributeValueMapping);
            TempInsertedItemAttributeValueMapping.INSERT;
          END;
        UNTIL TempItemAttributeValueToInsert.NEXT = 0;
    END;

    [External]
    PROCEDURE SearchCategoryItemsForAttribute@3(CategoryCode@1002 : Code[20];AttributeID@1003 : Integer) : Boolean;
    VAR
      Item@1001 : Record 27;
      ItemCategory@1000 : Record 5722;
      ItemAttributeValueMapping@1004 : Record 7505;
    BEGIN
      Item.SETRANGE("Item Category Code",CategoryCode);
      IF Item.FINDSET THEN
        REPEAT
          ItemAttributeValueMapping.SETRANGE("Table ID",DATABASE::Item);
          ItemAttributeValueMapping.SETRANGE("No.",Item."No.");
          ItemAttributeValueMapping.SETRANGE("Item Attribute ID",AttributeID);
          IF ItemAttributeValueMapping.FINDFIRST THEN
            EXIT(TRUE);
        UNTIL Item.NEXT = 0;

      ItemCategory.SETRANGE("Parent Category",CategoryCode);
      IF ItemCategory.FINDSET THEN
        REPEAT
          IF SearchCategoryItemsForAttribute(ItemCategory.Code,AttributeID) THEN
            EXIT(TRUE);
        UNTIL ItemCategory.NEXT = 0;
    END;

    [External]
    PROCEDURE DoesValueExistInItemAttributeValues@14(Text@1001 : Text[250];VAR ItemAttributeValue@1000 : Record 7501) : Boolean;
    BEGIN
      ItemAttributeValue.RESET;
      ItemAttributeValue.SETFILTER(Value,'@' + Text);
      EXIT(ItemAttributeValue.FINDSET);
    END;

    BEGIN
    END.
  }
}

