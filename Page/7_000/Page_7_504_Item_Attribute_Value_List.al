OBJECT Page 7504 Item Attribute Value List
{
  OBJECT-PROPERTIES
  {
    Date=26-01-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20348;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Vareattributv‘rdier;
               ENU=Item Attribute Values];
    LinksAllowed=No;
    SourceTable=Table7504;
    DelayedInsert=Yes;
    PageType=ListPart;
    SourceTableTemporary=Yes;
    OnOpenPage=BEGIN
                 CurrPage.EDITABLE(TRUE);
               END;

    OnDeleteRecord=BEGIN
                     DeleteItemAttributeValueMapping("Attribute ID");
                   END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
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
                OnValidate=VAR
                             ItemAttributeValue@1003 : Record 7501;
                             ItemAttributeValueMapping@1001 : Record 7505;
                           BEGIN
                             IF xRec."Attribute Name" <> '' THEN
                               DeleteItemAttributeValueMapping(xRec."Attribute ID");

                             IF NOT FindAttributeValue(ItemAttributeValue) THEN
                               InsertItemAttributeValue(ItemAttributeValue,Rec);

                             IF ItemAttributeValue.GET(ItemAttributeValue."Attribute ID",ItemAttributeValue.ID) THEN BEGIN
                               ItemAttributeValueMapping.RESET;
                               ItemAttributeValueMapping.INIT;
                               ItemAttributeValueMapping."Table ID" := DATABASE::Item;
                               ItemAttributeValueMapping."No." := RelatedRecordCode;
                               ItemAttributeValueMapping."Item Attribute ID" := ItemAttributeValue."Attribute ID";
                               ItemAttributeValueMapping."Item Attribute Value ID" := ItemAttributeValue.ID;
                               ItemAttributeValueMapping.INSERT;
                             END;
                           END;
                            }

    { 4   ;2   ;Field     ;
                Name=Value;
                CaptionML=[DAN=V‘rdi;
                           ENU=Value];
                ToolTipML=[DAN=Angiver v‘rdien for vareattributten.;
                           ENU=Specifies the value of the item attribute.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Value;
                TableRelation=IF (Attribute Type=CONST(Option)) "Item Attribute Value".Value WHERE (Attribute ID=FIELD(Attribute ID),
                                                                                                    Blocked=CONST(No));
                OnValidate=VAR
                             ItemAttributeValue@1003 : Record 7501;
                             ItemAttributeValueMapping@1002 : Record 7505;
                           BEGIN
                             IF NOT FindAttributeValue(ItemAttributeValue) THEN
                               InsertItemAttributeValue(ItemAttributeValue,Rec);

                             ItemAttributeValueMapping.SETRANGE("Table ID",DATABASE::Item);
                             ItemAttributeValueMapping.SETRANGE("No.",RelatedRecordCode);
                             ItemAttributeValueMapping.SETRANGE("Item Attribute ID",ItemAttributeValue."Attribute ID");

                             IF ItemAttributeValueMapping.FINDFIRST THEN BEGIN
                               ItemAttributeValueMapping."Item Attribute Value ID" := ItemAttributeValue.ID;
                               ItemAttributeValueMapping.MODIFY;
                             END;

                             IF FindAttributeValueFromRecord(ItemAttributeValue,xRec) THEN
                               IF NOT ItemAttributeValue.HasBeenUsed THEN
                                 ItemAttributeValue.DELETE;
                           END;
                            }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† varens eller ressourcens enhed, f.eks. styk eller time.;
                           ENU=Specifies the name of the item or resource's unit of measure, such as piece or hour.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Unit of Measure" }

  }
  CODE
  {
    VAR
      RelatedRecordCode@1000 : Code[20];

    [External]
    PROCEDURE LoadAttributes@1(ItemNo@1006 : Code[20]);
    VAR
      ItemAttributeValueMapping@1005 : Record 7505;
      TempItemAttributeValue@1004 : TEMPORARY Record 7501;
      ItemAttributeValue@1001 : Record 7501;
    BEGIN
      RelatedRecordCode := ItemNo;
      ItemAttributeValueMapping.SETRANGE("Table ID",DATABASE::Item);
      ItemAttributeValueMapping.SETRANGE("No.",ItemNo);
      IF ItemAttributeValueMapping.FINDSET THEN
        REPEAT
          ItemAttributeValue.GET(ItemAttributeValueMapping."Item Attribute ID",ItemAttributeValueMapping."Item Attribute Value ID");
          TempItemAttributeValue.TRANSFERFIELDS(ItemAttributeValue);
          TempItemAttributeValue.INSERT;
        UNTIL ItemAttributeValueMapping.NEXT = 0;

      PopulateItemAttributeValueSelection(TempItemAttributeValue);
    END;

    LOCAL PROCEDURE DeleteItemAttributeValueMapping@2(AttributeToDeleteID@1002 : Integer);
    VAR
      ItemAttributeValueMapping@1001 : Record 7505;
      ItemAttribute@1000 : Record 7500;
    BEGIN
      ItemAttributeValueMapping.SETRANGE("Table ID",DATABASE::Item);
      ItemAttributeValueMapping.SETRANGE("No.",RelatedRecordCode);
      ItemAttributeValueMapping.SETRANGE("Item Attribute ID",AttributeToDeleteID);
      IF ItemAttributeValueMapping.FINDFIRST THEN
        ItemAttributeValueMapping.DELETE;

      ItemAttribute.GET(AttributeToDeleteID);
      ItemAttribute.RemoveUnusedArbitraryValues;
    END;

    BEGIN
    END.
  }
}

