OBJECT Page 2802 Native - Item Entity
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[@@@={Locked};
               DAN=invoicingItems;
               ENU=invoicingItems];
    SourceTable=Table27;
    DelayedInsert=Yes;
    PageType=List;
    OnOpenPage=BEGIN
                 BINDSUBSCRIPTION(NativeAPILanguageHandler);
               END;

    OnAfterGetRecord=BEGIN
                       SetCalculatedFields;
                     END;

    OnNewRecord=BEGIN
                  ClearCalculatedFields;
                END;

    OnInsertRecord=VAR
                     GraphCollectionMgtItem@1002 : Codeunit 5470;
                     BaseUnitOfMeasureJSONText@1003 : Text;
                   BEGIN
                     IF TempFieldSet.GET(DATABASE::Item,FIELDNO("Base Unit of Measure")) THEN
                       BaseUnitOfMeasureJSONText := GraphCollectionMgtItem.ItemUnitOfMeasureToJSON(Rec,BaseUnitOfMeasureCode);

                     GraphCollectionMgtItem.InsertItem(Rec,TempFieldSet,BaseUnitOfMeasureJSONText,'');
                     SetCalculatedFields;
                     EXIT(FALSE);
                   END;

    OnModifyRecord=VAR
                     Item@1001 : Record 27;
                   BEGIN
                     IF TempFieldSet.GET(DATABASE::Item,FIELDNO("Base Unit of Measure")) THEN
                       VALIDATE("Base Unit of Measure",BaseUnitOfMeasureCode);

                     Item.SETRANGE(Id,Id);
                     Item.FINDFIRST;

                     IF "No." = Item."No." THEN
                       MODIFY(TRUE)
                     ELSE BEGIN
                       Item.TRANSFERFIELDS(Rec,FALSE);
                       Item.RENAME("No.");
                       TRANSFERFIELDS(Item,TRUE);
                     END;

                     SetCalculatedFields;

                     EXIT(FALSE);
                   END;

    ODataKeyFields=Id;
  }
  CONTROLS
  {
    { 18  ;0   ;Container ;
                ContainerType=ContentArea }

    { 17  ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 16  ;2   ;Field     ;
                Name=id;
                CaptionML=[@@@={Locked};
                           DAN=Id;
                           ENU=Id];
                ApplicationArea=#All;
                SourceExpr=Id }

    { 15  ;2   ;Field     ;
                Name=number;
                CaptionML=[@@@={Locked};
                           DAN=Number;
                           ENU=Number];
                ApplicationArea=#All;
                SourceExpr="No." }

    { 14  ;2   ;Field     ;
                Name=displayName;
                CaptionML=[@@@={Locked};
                           DAN=DisplayName;
                           ENU=DisplayName];
                ToolTipML=[DAN=Angiver beskrivelsen af varen.;
                           ENU=Specifies the Description for the Item.];
                ApplicationArea=#All;
                SourceExpr=Description;
                OnValidate=BEGIN
                             RegisterFieldSet(FIELDNO(Description));
                           END;
                            }

    { 11  ;2   ;Field     ;
                Name=type;
                CaptionML=[@@@={Locked};
                           DAN=Type;
                           ENU=Type];
                ToolTipML=[DAN=Angiver varetypen. Mulige v‘rdier er Lagerbeholdning og Tjeneste.;
                           ENU=Specifies the Type for the Item. Possible values are Inventory and Service.];
                ApplicationArea=#All;
                SourceExpr=Type;
                OnValidate=BEGIN
                             RegisterFieldSet(FIELDNO(Type));
                           END;
                            }

    { 4   ;2   ;Field     ;
                Name=blocked;
                CaptionML=[@@@={Locked};
                           DAN=Blocked;
                           ENU=Blocked];
                ToolTipML=[DAN=Angiver, om varen er blokeret.;
                           ENU=Specifies whether the item is blocked.];
                ApplicationArea=#All;
                SourceExpr=Blocked;
                OnValidate=BEGIN
                             RegisterFieldSet(FIELDNO(Blocked));
                           END;
                            }

    { 9   ;2   ;Field     ;
                Name=baseUnitOfMeasureId;
                CaptionML=[DAN=BaseUnitOfMeasureId;
                           ENU=BaseUnitOfMeasureId];
                ToolTipML=[DAN=Angiver id'et for basisenheden.;
                           ENU=Specifies the ID of the base unit of measure.];
                ApplicationArea=#All;
                SourceExpr=BaseUnitOfMeasureId;
                OnValidate=BEGIN
                             ValidateUnitOfMeasure.SETRANGE(Id,BaseUnitOfMeasureId);
                             IF NOT ValidateUnitOfMeasure.FINDFIRST THEN
                               ERROR(BaseUnitOfMeasureIdDoesNotMatchAUnitOfMeasureErr);

                             BaseUnitOfMeasureCode := ValidateUnitOfMeasure.Code;

                             RegisterFieldSet(FIELDNO("Unit of Measure Id"));
                             RegisterFieldSet(FIELDNO("Base Unit of Measure"));
                           END;
                            }

    { 8   ;2   ;Field     ;
                Name=baseUnitOfMeasureIntStdCode;
                CaptionML=[DAN=BaseUnitOfMeasureInternationalStandardCode;
                           ENU=BaseUnitOfMeasureInternationalStandardCode];
                ToolTipML=[DAN=Angiver den internationale standardkode for basisenheden.;
                           ENU=Specifies the international standard code of the base unit of measure.];
                ApplicationArea=#All;
                SourceExpr=BaseUnitOfMeasureInternationalStandardCode;
                OnValidate=BEGIN
                             IF ValidateUnitOfMeasure."International Standard Code" <> '' THEN BEGIN
                               IF ValidateUnitOfMeasure."International Standard Code" <> BaseUnitOfMeasureInternationalStandardCode THEN
                                 ERROR(BaseUnitOfMeasureValuesDontMatchErr);
                               EXIT;
                             END;

                             ValidateUnitOfMeasure.SETRANGE("International Standard Code",BaseUnitOfMeasureInternationalStandardCode);
                             IF NOT ValidateUnitOfMeasure.FINDFIRST THEN
                               ERROR(BaseUnitOfMeasureIntStdCodeDoesNotMatchAUnitOfMeasureErr);
                             IF ValidateUnitOfMeasure.COUNT > 1 THEN
                               ERROR(BaseUnitOfMeasureIntStdCodeMatchesManyUnitsOfMeasureErr);

                             BaseUnitOfMeasureCode := ValidateUnitOfMeasure.Code;

                             RegisterFieldSet(FIELDNO("Unit of Measure Id"));
                             RegisterFieldSet(FIELDNO("Base Unit of Measure"));
                           END;
                            }

    { 6   ;2   ;Field     ;
                Name=gtin;
                CaptionML=[@@@={Locked};
                           DAN=GTIN;
                           ENU=GTIN];
                ApplicationArea=#All;
                SourceExpr=GTIN;
                OnValidate=BEGIN
                             RegisterFieldSet(FIELDNO(GTIN));
                           END;
                            }

    { 23  ;2   ;Field     ;
                Name=inventory;
                CaptionML=[@@@={Locked};
                           DAN=Inventory;
                           ENU=Inventory];
                ToolTipML=[DAN=Angiver lagerbeholdningen af varen.;
                           ENU=Specifies the inventory for the item.];
                ApplicationArea=#All;
                SourceExpr=InventoryValue;
                OnValidate=BEGIN
                             VALIDATE(Inventory,InventoryValue);
                             RegisterFieldSet(FIELDNO(Inventory));
                           END;
                            }

    { 10  ;2   ;Field     ;
                Name=unitPrice;
                CaptionML=[@@@={Locked};
                           DAN=UnitPrice;
                           ENU=UnitPrice];
                ApplicationArea=#All;
                SourceExpr="Unit Price";
                OnValidate=BEGIN
                             RegisterFieldSet(FIELDNO("Unit Price"));
                           END;
                            }

    { 24  ;2   ;Field     ;
                Name=priceIncludesTax;
                CaptionML=[@@@={Locked};
                           DAN=PriceIncludesTax;
                           ENU=PriceIncludesTax];
                ApplicationArea=#All;
                SourceExpr="Price Includes VAT";
                OnValidate=BEGIN
                             RegisterFieldSet(FIELDNO("Price Includes VAT"));
                           END;
                            }

    { 25  ;2   ;Field     ;
                Name=unitCost;
                CaptionML=[@@@={Locked};
                           DAN=UnitCost;
                           ENU=UnitCost];
                ApplicationArea=#All;
                SourceExpr="Unit Cost";
                OnValidate=BEGIN
                             RegisterFieldSet(FIELDNO("Unit Cost"));
                           END;
                            }

    { 7   ;2   ;Field     ;
                Name=taxGroupId;
                CaptionML=[@@@={Locked};
                           DAN=TaxGroupId;
                           ENU=TaxGroupId];
                ToolTipML=[DAN=Angiver id'et for skattegruppen eller momsgruppen.;
                           ENU=Specifies the ID of the tax group or VAT group.];
                ApplicationArea=#All;
                SourceExpr=TaxGroupId;
                OnValidate=VAR
                             ValidateVATProdPostingGroup@1002 : Record 324;
                             ValidateTaxGroup@1001 : Record 321;
                           BEGIN
                             IF TaxGroupId = BlankGUID THEN BEGIN
                               TaxGroupCode := '';
                               "Tax Group Code" := '';
                               "Tax Group Id" := BlankGUID;
                               "VAT Prod. Posting Group" := '';
                               EXIT;
                             END;

                             IF GeneralLedgerSetup.UseVat THEN BEGIN
                               ValidateVATProdPostingGroup.SETRANGE(Id,TaxGroupId);
                               IF NOT ValidateVATProdPostingGroup.FINDFIRST THEN
                                 ERROR(VATGroupIdDoesNotMatchAVATGroupErr);

                               TaxGroupCode := ValidateVATProdPostingGroup.Code;
                               "VAT Prod. Posting Group" := TaxGroupCode;
                               RegisterFieldSet(FIELDNO("VAT Prod. Posting Group"));
                             END ELSE BEGIN
                               ValidateTaxGroup.SETRANGE(Id,TaxGroupId);
                               IF NOT ValidateTaxGroup.FINDFIRST THEN
                                 ERROR(TaxGroupIdDoesNotMatchATaxGroupErr);

                               TaxGroupCode := ValidateTaxGroup.Code;
                               "Tax Group Code" := TaxGroupCode;
                               "Tax Group Id" := TaxGroupId;
                               RegisterFieldSet(FIELDNO("Tax Group Code"));
                               RegisterFieldSet(FIELDNO("Tax Group Id"));
                             END;
                           END;
                            }

    { 1   ;2   ;Field     ;
                Name=taxGroupCode;
                CaptionML=[@@@={Locked};
                           DAN=TaxGroupCode;
                           ENU=TaxGroupCode];
                ToolTipML=[DAN=Angiver koden for skattegruppen eller momsgruppen.;
                           ENU=Specifies the code of the tax group or VAT group.];
                ApplicationArea=#All;
                SourceExpr=TaxGroupCode;
                Editable=FALSE }

    { 5   ;2   ;Field     ;
                Name=taxable;
                CaptionML=[@@@={Locked};
                           DAN=Taxable;
                           ENU=Taxable];
                ToolTipML=[DAN=Angiver skattegruppekoden for indtastning af skatteoplysninger.;
                           ENU=Specifies the tax group code for the tax-detail entry.];
                ApplicationArea=#All;
                SourceExpr=Taxable;
                OnValidate=VAR
                             GeneralLedgerSetup@1001 : Record 98;
                             TaxGroup@1002 : Record 321;
                             NativeEDMTypes@1000 : Codeunit 2801;
                           BEGIN
                             IF GeneralLedgerSetup.UseVat THEN
                               EXIT;

                             IF NOT NativeEDMTypes.GetTaxGroupFromTaxable(Taxable,TaxGroup) THEN
                               EXIT;

                             VALIDATE("Tax Group Id",TaxGroup.Id);
                             RegisterFieldSet(FIELDNO("Tax Group Id"));
                             RegisterFieldSet(FIELDNO("Tax Group Code"));
                           END;
                            }

    { 19  ;2   ;Field     ;
                Name=lastModifiedDateTime;
                CaptionML=[@@@={Locked};
                           DAN=LastModifiedDateTime;
                           ENU=LastModifiedDateTime];
                ApplicationArea=#All;
                SourceExpr="Last DateTime Modified";
                Editable=FALSE }

  }
  CODE
  {
    VAR
      TempFieldSet@1011 : TEMPORARY Record 2000000041;
      GeneralLedgerSetup@1006 : Record 98;
      ValidateUnitOfMeasure@1007 : Record 204;
      NativeAPILanguageHandler@1002 : Codeunit 2850;
      BlankGUID@1001 : GUID;
      BaseUnitOfMeasureId@1008 : GUID;
      TaxGroupId@1017 : GUID;
      TaxGroupCode@1018 : Code[20];
      BaseUnitOfMeasureInternationalStandardCode@1005 : Code[10];
      BaseUnitOfMeasureCode@1009 : Code[10];
      InventoryValue@1000 : Decimal;
      Taxable@1004 : Boolean;
      BaseUnitOfMeasureValuesDontMatchErr@1015 : TextConst 'DAN=Basisenheden for m†lv‘rdier stemmer ikke overens med en bestemt m†leenhed.;ENU=The base unit of measure values do not match to a specific Unit of Measure.';
      BaseUnitOfMeasureIdDoesNotMatchAUnitOfMeasureErr@1014 : TextConst '@@@={Locked};DAN=The "baseUnitOfMeasureId" does not match to a Unit of Measure.;ENU=The "baseUnitOfMeasureId" does not match to a Unit of Measure.';
      BaseUnitOfMeasureIntStdCodeDoesNotMatchAUnitOfMeasureErr@1013 : TextConst '@@@={Locked};DAN=The "baseUnitOfMeasureIntStdCode" does not match to a Unit of Measure.;ENU=The "baseUnitOfMeasureIntStdCode" does not match to a Unit of Measure.';
      BaseUnitOfMeasureIntStdCodeMatchesManyUnitsOfMeasureErr@1016 : TextConst '@@@={Locked};DAN=The "baseUnitOfMeasureIntStdCode" matches to many Units of Measure.;ENU=The "baseUnitOfMeasureIntStdCode" matches to many Units of Measure.';
      TaxGroupIdDoesNotMatchATaxGroupErr@1010 : TextConst '@@@={Locked};DAN=The "taxGroupId" does not match a Tax Group.;ENU=The "taxGroupId" does not match a Tax Group.';
      VATGroupIdDoesNotMatchAVATGroupErr@1022 : TextConst '@@@={Locked};DAN=The "taxGroupId" does not match a VAT Product Posting Group.;ENU=The "taxGroupId" does not match a VAT Product Posting Group.';

    LOCAL PROCEDURE SetCalculatedFields@6();
    BEGIN
      SetCalculatedUnitsOfMeasureFields;
      SetCalculatedTaxGroupFields;
      CALCFIELDS(Inventory);
      InventoryValue := Inventory;
    END;

    LOCAL PROCEDURE ClearCalculatedFields@10();
    BEGIN
      CLEAR(Id);
      CLEAR(BaseUnitOfMeasureId);
      CLEAR(BaseUnitOfMeasureInternationalStandardCode);
      CLEAR(BaseUnitOfMeasureCode);
      CLEAR(Taxable);
      CLEAR(TaxGroupCode);
      CLEAR(TaxGroupId);
      CLEAR(InventoryValue);
      TempFieldSet.DELETEALL;
    END;

    LOCAL PROCEDURE SetCalculatedUnitsOfMeasureFields@9();
    VAR
      UnitOfMeasure@1002 : Record 204;
      EmptyGuid@1000 : GUID;
    BEGIN
      IF UnitOfMeasure.GET("Base Unit of Measure") THEN BEGIN
        BaseUnitOfMeasureId := UnitOfMeasure.Id;
        BaseUnitOfMeasureInternationalStandardCode := UnitOfMeasure."International Standard Code";
        BaseUnitOfMeasureCode := "Base Unit of Measure";
        EXIT;
      END;

      BaseUnitOfMeasureId := EmptyGuid;
      BaseUnitOfMeasureInternationalStandardCode := '';
      BaseUnitOfMeasureCode := '';
    END;

    LOCAL PROCEDURE SetCalculatedTaxGroupFields@12();
    VAR
      TaxGroup@1002 : Record 321;
      TaxSetup@1000 : Record 326;
      VATProductPostingGroup@1003 : Record 324;
      EmptyGuid@1001 : GUID;
    BEGIN
      IF GeneralLedgerSetup.UseVat AND VATProductPostingGroup.GET("VAT Prod. Posting Group") THEN BEGIN
        TaxGroupCode := VATProductPostingGroup.Code;
        TaxGroupId := VATProductPostingGroup.Id;
        Taxable := TRUE;
      END ELSE
        IF TaxGroup.GET("Tax Group Code") THEN BEGIN
          "Tax Group Id" := TaxGroup.Id;
          TaxGroupId := "Tax Group Id";
          TaxGroupCode := "Tax Group Code";
          IF TaxSetup.GET THEN
            Taxable := "Tax Group Code" <> TaxSetup."Non-Taxable Tax Group Code"
          ELSE
            Taxable := FALSE;
        END ELSE BEGIN
          TaxGroupId := EmptyGuid;
          TaxGroupCode := '';
          "Tax Group Id" := EmptyGuid;
          Taxable := FALSE;
        END;
    END;

    LOCAL PROCEDURE RegisterFieldSet@11(FieldNo@1000 : Integer);
    BEGIN
      IF TempFieldSet.GET(DATABASE::Item,FieldNo) THEN
        EXIT;

      TempFieldSet.INIT;
      TempFieldSet.TableNo := DATABASE::Item;
      TempFieldSet.VALIDATE("No.",FieldNo);
      TempFieldSet.INSERT(TRUE);
    END;

    BEGIN
    END.
  }
}

