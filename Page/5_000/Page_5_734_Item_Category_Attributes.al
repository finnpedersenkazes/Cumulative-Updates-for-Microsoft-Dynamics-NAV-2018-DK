OBJECT Page 5734 Item Category Attributes
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Varekategoriattributter;
               ENU=Item Category Attributes];
    LinksAllowed=No;
    SourceTable=Table7504;
    SourceTableView=SORTING(Inheritance Level,Attribute Name)
                    ORDER(Ascending);
    PageType=ListPart;
    SourceTableTemporary=Yes;
    RefreshOnActivate=Yes;
    OnClosePage=BEGIN
                  TempRecentlyItemAttributeValueMapping.DELETEALL;
                END;

    OnAfterGetRecord=BEGIN
                       UpdateProperties;
                     END;

    OnInsertRecord=VAR
                     TempItemAttributeValueToInsert@1000 : TEMPORARY Record 7501;
                     ItemAttributeValueMapping@1002 : Record 7505;
                     ItemAttributeManagement@1001 : Codeunit 7500;
                   BEGIN
                     IF ItemCategoryCode <> '' THEN BEGIN
                       ItemAttributeValueMapping."Table ID" := DATABASE::"Item Category";
                       ItemAttributeValueMapping."No." := ItemCategoryCode;
                       ItemAttributeValueMapping."Item Attribute ID" := "Attribute ID";
                       ItemAttributeValueMapping."Item Attribute Value ID" := GetAttributeValueID(TempItemAttributeValueToInsert);
                       ItemAttributeValueMapping.INSERT;
                       ItemAttributeManagement.InsertCategoryItemsBufferedAttributeValueMapping(
                         TempItemAttributeValueToInsert,TempRecentlyItemAttributeValueMapping,ItemCategoryCode);
                       InsertRecentlyAddedCategoryAttribute(ItemAttributeValueMapping);
                     END;
                   END;

    OnDeleteRecord=VAR
                     TempItemAttributeValueToDelete@1000 : TEMPORARY Record 7501;
                     ItemAttributeValue@1001 : Record 7501;
                     ItemAttributeValueMapping@1003 : Record 7505;
                     ItemAttributeManagement@1002 : Codeunit 7500;
                   BEGIN
                     IF "Inherited-From Key Value" <> '' THEN
                       ERROR(DeleteInheritedAttribErr);

                     ItemAttributeValueMapping.SETRANGE("Table ID",DATABASE::"Item Category");
                     ItemAttributeValueMapping.SETRANGE("No.",ItemCategoryCode);
                     ItemAttributeValueMapping.SETRANGE("Item Attribute ID","Attribute ID");
                     ItemAttributeValueMapping.FINDFIRST;
                     IF ItemAttributeManagement.SearchCategoryItemsForAttribute(ItemCategoryCode,"Attribute ID") THEN
                       IF CONFIRM(STRSUBSTNO(DeleteItemInheritedParentCategoryAttributesQst,ItemCategoryCode,ItemCategoryCode)) THEN BEGIN
                         ItemAttributeValue.SETRANGE("Attribute ID","Attribute ID");
                         ItemAttributeValue.SETRANGE(ID,ItemAttributeValueMapping."Item Attribute Value ID");
                         ItemAttributeValue.FINDFIRST;
                         TempItemAttributeValueToDelete.TRANSFERFIELDS(ItemAttributeValue);
                         TempItemAttributeValueToDelete.INSERT;
                         DeleteRecentlyItemAttributeValueMapping("Attribute ID");
                         ItemAttributeManagement.DeleteCategoryItemsAttributeValueMapping(TempItemAttributeValueToDelete,ItemCategoryCode);
                       END;
                     ItemAttributeValueMapping.DELETE;
                   END;

    OnAfterGetCurrRecord=BEGIN
                           UpdateProperties;
                         END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                Enabled=RowEditable;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                AssistEdit=No;
                CaptionML=[DAN=Attribut;
                           ENU=Attribute];
                ToolTipML=[DAN=Angiver vareattributten.;
                           ENU=Specifies the item attribute.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Attribute Name";
                TableRelation="Item Attribute".Name WHERE (Blocked=CONST(No));
                StyleExpr=StyleTxt;
                OnValidate=BEGIN
                             PersistInheritanceData;
                           END;
                            }

    { 4   ;2   ;Field     ;
                Name=Value;
                CaptionML=[DAN=Standardv�rdi;
                           ENU=Default Value];
                ToolTipML=[DAN=Angiver v�rdien for vareattributten.;
                           ENU=Specifies the value of the item attribute.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Value;
                TableRelation=IF (Attribute Type=CONST(Option)) "Item Attribute Value".Value WHERE (Attribute ID=FIELD(Attribute ID),
                                                                                                    Blocked=CONST(No));
                StyleExpr=StyleTxt;
                OnValidate=BEGIN
                             PersistInheritanceData;
                             ChangeDefaultValue;
                           END;
                            }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� varens eller ressourcens enhed, f.eks. styk eller time.;
                           ENU=Specifies the name of the item or resource's unit of measure, such as piece or hour.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Unit of Measure";
                StyleExpr=StyleTxt }

    { 5   ;2   ;Field     ;
                CaptionML=[DAN=Overf�rt fra;
                           ENU=Inherited From];
                ToolTipML=[DAN=Angiver den overordnede varekategori, som varens attributter er nedarvet fra.;
                           ENU=Specifies the parent item category that the item attributes are inherited from.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Inherited-From Key Value";
                Editable=FALSE;
                StyleExpr=StyleTxt }

  }
  CODE
  {
    VAR
      TempRecentlyItemAttributeValueMapping@1006 : TEMPORARY Record 7505;
      ItemCategoryCode@1000 : Code[20];
      DeleteInheritedAttribErr@1002 : TextConst 'DAN=Du kan ikke slette attributter, der er nedarvet fra en overordnet varekategori.;ENU=You cannot delete attributes that are inherited from a parent item category.';
      RowEditable@1001 : Boolean;
      StyleTxt@1003 : Text;
      ChangingDefaultValueMsg@1005 : TextConst '@@@=%1 - item category code;DAN=Den nye standardv�rdi g�lder ikke for varer, der bruger den nuv�rende varekategori, ''''%1''''. Den g�lder kun for nye varer.;ENU=The new default value will not apply to items that use the current item category, ''''%1''''. It will only apply to new items.';
      DeleteItemInheritedParentCategoryAttributesQst@1004 : TextConst '@@@=%1 - item category code,%2 - item category code;DAN=En eller flere varer tilh�rer varekategorien ''''%1''''.\\Vil du slette de nedarvede vareattributter for de p�g�ldende varer?;ENU=One or more items belong to item category ''''%1''''.\\Do you want to delete the inherited item attributes for the items in question?';

    [External]
    PROCEDURE LoadAttributes@29(CategoryCode@1004 : Code[20]);
    VAR
      TempItemAttributeValue@1000 : TEMPORARY Record 7501;
      ItemAttributeValue@1002 : Record 7501;
      ItemAttributeValueMapping@1001 : Record 7505;
      ItemCategory@1007 : Record 5722;
      CurrentCategoryCode@1005 : Code[20];
    BEGIN
      RESET;
      DELETEALL;
      IF CategoryCode = '' THEN
        EXIT;
      SortByInheritance;
      ItemAttributeValueMapping.SETRANGE("Table ID",DATABASE::"Item Category");
      SetItemCategoryCode(CategoryCode);
      CurrentCategoryCode := CategoryCode;
      REPEAT
        IF ItemCategory.GET(CurrentCategoryCode) THEN BEGIN
          ItemAttributeValueMapping.SETRANGE("No.",CurrentCategoryCode);
          IF ItemAttributeValueMapping.FINDSET THEN
            REPEAT
              IF ItemAttributeValue.GET(
                   ItemAttributeValueMapping."Item Attribute ID",ItemAttributeValueMapping."Item Attribute Value ID")
              THEN BEGIN
                TempItemAttributeValue.TRANSFERFIELDS(ItemAttributeValue);
                IF TempItemAttributeValue.INSERT THEN
                  IF NOT AttributeExists(TempItemAttributeValue."Attribute ID") THEN BEGIN
                    IF CurrentCategoryCode = ItemCategoryCode THEN
                      InsertRecord(TempItemAttributeValue,DATABASE::"Item Category",'')
                    ELSE
                      InsertRecord(TempItemAttributeValue,DATABASE::"Item Category",CurrentCategoryCode);
                    "Inheritance Level" := ItemCategory.Indentation;
                    MODIFY;
                  END;
              END
            UNTIL ItemAttributeValueMapping.NEXT = 0;
          CurrentCategoryCode := ItemCategory."Parent Category";
        END ELSE
          CurrentCategoryCode := '';
      UNTIL CurrentCategoryCode = '';
      RESET;
      CurrPage.UPDATE(FALSE);
      SortByInheritance;
    END;

    [External]
    PROCEDURE SaveAttributes@2(CategoryCode@1003 : Code[20]);
    VAR
      TempNewItemAttributeValue@1000 : TEMPORARY Record 7501;
      ItemAttributeValueMapping@1001 : Record 7505;
      ItemAttribute@1002 : Record 7500;
      TempNewCategItemAttributeValue@1008 : TEMPORARY Record 7501;
      TempOldCategItemAttributeValue@1007 : TEMPORARY Record 7501;
      ItemAttributeManagement@1004 : Codeunit 7500;
    BEGIN
      IF CategoryCode = '' THEN
        EXIT;
      TempOldCategItemAttributeValue.LoadCategoryAttributesFactBoxData(CategoryCode);

      SETRANGE("Inherited-From Table ID",DATABASE::"Item Category");
      SETRANGE("Inherited-From Key Value",'');
      PopulateItemAttributeValue(TempNewItemAttributeValue);
      ItemAttributeValueMapping.SETRANGE("Table ID",DATABASE::"Item Category");
      ItemAttributeValueMapping.SETRANGE("No.",CategoryCode);
      ItemAttributeValueMapping.DELETEALL;

      IF TempNewItemAttributeValue.FINDSET THEN
        REPEAT
          ItemAttributeValueMapping."Table ID" := DATABASE::"Item Category";
          ItemAttributeValueMapping."No." := CategoryCode;
          ItemAttributeValueMapping."Item Attribute ID" := TempNewItemAttributeValue."Attribute ID";
          ItemAttributeValueMapping."Item Attribute Value ID" := TempNewItemAttributeValue.ID;
          ItemAttributeValueMapping.INSERT;
          ItemAttribute.GET(ItemAttributeValueMapping."Item Attribute ID");
          ItemAttribute.RemoveUnusedArbitraryValues;
        UNTIL TempNewItemAttributeValue.NEXT = 0;

      TempNewCategItemAttributeValue.LoadCategoryAttributesFactBoxData(CategoryCode);
      ItemAttributeManagement.UpdateCategoryItemsAttributeValueMapping(
        TempNewCategItemAttributeValue,TempOldCategItemAttributeValue,ItemCategoryCode,ItemCategoryCode);
    END;

    LOCAL PROCEDURE PersistInheritanceData@1();
    BEGIN
      "Inherited-From Table ID" := DATABASE::"Item Category";
      CurrPage.SAVERECORD;
    END;

    [External]
    PROCEDURE SetItemCategoryCode@3(CategoryCode@1000 : Code[20]);
    BEGIN
      IF ItemCategoryCode <> CategoryCode THEN BEGIN
        ItemCategoryCode := CategoryCode;
        TempRecentlyItemAttributeValueMapping.DELETEALL;
      END;
    END;

    [External]
    PROCEDURE SortByInheritance@4();
    BEGIN
      SETCURRENTKEY("Inheritance Level","Attribute Name");
    END;

    LOCAL PROCEDURE UpdateProperties@6();
    BEGIN
      RowEditable := "Inherited-From Key Value" = '';
      IF RowEditable THEN
        StyleTxt := 'Standard'
      ELSE
        StyleTxt := 'Strong';
    END;

    LOCAL PROCEDURE AttributeExists@9(AttributeID@1001 : Integer) AttribExist : Boolean;
    BEGIN
      SETRANGE("Attribute ID",AttributeID);
      AttribExist := NOT ISEMPTY;
      RESET;
    END;

    LOCAL PROCEDURE ChangeDefaultValue@5();
    VAR
      ItemAttributeValueMapping@1001 : Record 7505;
      TempItemAttributeValueToInsert@1002 : TEMPORARY Record 7501;
      ItemAttributeManagement@1000 : Codeunit 7500;
    BEGIN
      ItemAttributeValueMapping.SETRANGE("Table ID",DATABASE::"Item Category");
      ItemAttributeValueMapping.SETRANGE("No.",ItemCategoryCode);
      ItemAttributeValueMapping.SETRANGE("Item Attribute ID","Attribute ID");
      IF ItemAttributeValueMapping.FINDFIRST THEN BEGIN
        ItemAttributeValueMapping."Item Attribute Value ID" := GetAttributeValueID(TempItemAttributeValueToInsert);
        ItemAttributeValueMapping.MODIFY;
      END;

      IF IsRecentlyAddedCategoryAttribute("Attribute ID") THEN
        UpdateRecentlyItemAttributeValueMapping(TempItemAttributeValueToInsert)
      ELSE
        IF ItemAttributeManagement.SearchCategoryItemsForAttribute(ItemCategoryCode,"Attribute ID") THEN
          MESSAGE(STRSUBSTNO(ChangingDefaultValueMsg,ItemCategoryCode));
    END;

    LOCAL PROCEDURE InsertRecentlyAddedCategoryAttribute@24(ItemAttributeValueMapping@1000 : Record 7505);
    BEGIN
      TempRecentlyItemAttributeValueMapping.TRANSFERFIELDS(ItemAttributeValueMapping);
      IF TempRecentlyItemAttributeValueMapping.INSERT THEN;
    END;

    LOCAL PROCEDURE IsRecentlyAddedCategoryAttribute@7(AttributeID@1001 : Integer) : Boolean;
    BEGIN
      TempRecentlyItemAttributeValueMapping.SETRANGE("Item Attribute ID",AttributeID);
      EXIT(NOT TempRecentlyItemAttributeValueMapping.ISEMPTY)
    END;

    LOCAL PROCEDURE UpdateRecentlyItemAttributeValueMapping@10(VAR TempItemAttributeValueToInsert@1000 : TEMPORARY Record 7501);
    VAR
      ItemAttributeValueMapping@1001 : Record 7505;
    BEGIN
      TempRecentlyItemAttributeValueMapping.SETRANGE("Item Attribute ID",TempItemAttributeValueToInsert."Attribute ID");
      IF TempRecentlyItemAttributeValueMapping.FINDSET THEN
        REPEAT
          ItemAttributeValueMapping.SETRANGE("Table ID",TempRecentlyItemAttributeValueMapping."Table ID");
          ItemAttributeValueMapping.SETRANGE("No.",TempRecentlyItemAttributeValueMapping."No.");
          ItemAttributeValueMapping.SETRANGE("Item Attribute ID",TempRecentlyItemAttributeValueMapping."Item Attribute ID");
          ItemAttributeValueMapping.FINDFIRST;
          ItemAttributeValueMapping.VALIDATE("Item Attribute Value ID",TempItemAttributeValueToInsert.ID);
          ItemAttributeValueMapping.MODIFY;
        UNTIL TempRecentlyItemAttributeValueMapping.NEXT = 0;
    END;

    LOCAL PROCEDURE DeleteRecentlyItemAttributeValueMapping@12(AttributeID@1000 : Integer);
    BEGIN
      TempRecentlyItemAttributeValueMapping.SETRANGE("Item Attribute ID",AttributeID);
      TempRecentlyItemAttributeValueMapping.DELETEALL;
    END;

    BEGIN
    END.
  }
}

