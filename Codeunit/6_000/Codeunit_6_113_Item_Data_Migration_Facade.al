OBJECT Codeunit 6113 Item Data Migration Facade
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    TableNo=1798;
    OnRun=VAR
            DataMigrationStatusFacade@1001 : Codeunit 6101;
            ChartOfAccountsMigrated@1000 : Boolean;
          BEGIN
            FINDSET;
            ChartOfAccountsMigrated := DataMigrationStatusFacade.HasMigratedChartOfAccounts(Rec);
            REPEAT
              OnMigrateItem("Staging Table RecId To Process");
              OnMigrateItemTrackingCode("Staging Table RecId To Process");
              OnMigrateCostingMethod("Staging Table RecId To Process"); // needs to be set after item tracking code because of onvalidate trigger check
              OnMigrateItemUnitOfMeasure("Staging Table RecId To Process");
              OnMigrateItemDiscountGroup("Staging Table RecId To Process");
              OnMigrateItemSalesLineDiscount("Staging Table RecId To Process");
              OnMigrateItemPrice("Staging Table RecId To Process");
              OnMigrateItemTariffNo("Staging Table RecId To Process");
              OnMigrateItemDimensions("Staging Table RecId To Process");

              // migrate transactions for this item as long as it is an inventory item
              IF GlobalItem.Type = GlobalItem.Type::Inventory THEN BEGIN
                OnMigrateItemPostingGroups("Staging Table RecId To Process",ChartOfAccountsMigrated);
                OnMigrateInventoryTransactions("Staging Table RecId To Process",ChartOfAccountsMigrated);
                ItemJournalLineIsSet := FALSE;
              END;
              ItemIsSet := FALSE;
            UNTIL NEXT = 0;
          END;

  }
  CODE
  {
    VAR
      GlobalItem@1000 : Record 27;
      GlobalItemJournalLine@1004 : Record 83;
      DataMigrationFacadeHelper@1003 : Codeunit 1797;
      ItemIsSet@1001 : Boolean;
      InternalItemNotSetErr@1002 : TextConst 'DAN=Intern vare er ikke angivet. Opret den f�rst.;ENU=Internal item is not set. Create it first.';
      ItemJournalLineIsSet@1005 : Boolean;
      InternalItemJnlLIneNotSetErr@1006 : TextConst 'DAN=Intern varekladdelinje er ikke angivet. Opret den f�rst.;ENU=Internal item journal line is not set. Create it first.';

    [External]
    PROCEDURE CreateItemIfNeeded@24(ItemNoToSet@1001 : Code[20];ItemDescriptionToSet@1002 : Text[50];ItemDescription2ToSet@1003 : Text[50];ItemTypeToSet@1004 : 'Inventory,Service') : Boolean;
    VAR
      Item@1000 : Record 27;
    BEGIN
      IF Item.GET(ItemNoToSet) THEN BEGIN
        GlobalItem := Item;
        ItemIsSet := TRUE;
        EXIT(FALSE);
      END;

      Item.INIT;

      Item.VALIDATE("No.",ItemNoToSet);
      Item.VALIDATE(Description,ItemDescriptionToSet);
      Item.VALIDATE("Description 2",ItemDescription2ToSet);
      Item.VALIDATE(Type,ItemTypeToSet);
      Item.INSERT(TRUE);

      GlobalItem := Item;
      ItemIsSet := TRUE;
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE CreateLocationIfNeeded@57(LocationCode@1001 : Code[10];LocationName@1002 : Text[50]) : Boolean;
    VAR
      Location@1000 : Record 14;
    BEGIN
      IF Location.GET(LocationCode) THEN
        EXIT(FALSE);

      Location.INIT;
      Location.VALIDATE(Code,LocationCode);
      Location.VALIDATE(Name,LocationName);
      Location.INSERT(TRUE);

      EXIT(TRUE);
    END;

    [External]
    PROCEDURE DoesItemExist@52(ItemNo@1000 : Code[20]) : Boolean;
    VAR
      Item@1001 : Record 27;
    BEGIN
      EXIT(Item.GET(ItemNo));
    END;

    [External]
    PROCEDURE SetGlobalItem@40(ItemNo@1000 : Code[20]) : Boolean;
    BEGIN
      ItemIsSet := GlobalItem.GET(ItemNo);
      EXIT(ItemIsSet);
    END;

    [External]
    PROCEDURE ModifyItem@37(RunTrigger@1000 : Boolean);
    BEGIN
      IF NOT ItemIsSet THEN
        ERROR(InternalItemNotSetErr);

      GlobalItem.MODIFY(RunTrigger);
    END;

    [External]
    PROCEDURE CreateSalesLineDiscountIfNeeded@9(SalesTypeToSet@1001 : 'Customer,Customer Disc. Group,All Customers,Campaign';SalesCodeToSet@1002 : Code[10];TypeToSet@1003 : 'Item,Item Disc. Group';CodeToSet@1004 : Code[10];LineDiscountPercentToSet@1005 : Decimal) : Boolean;
    VAR
      SalesLineDiscount@1000 : Record 7004;
    BEGIN
      SalesLineDiscount.SETRANGE("Sales Type",SalesTypeToSet);
      SalesLineDiscount.SETRANGE("Sales Code",SalesCodeToSet);
      SalesLineDiscount.SETRANGE(Type,TypeToSet);
      SalesLineDiscount.SETRANGE(Code,CodeToSet);
      SalesLineDiscount.SETRANGE("Line Discount %",LineDiscountPercentToSet);

      IF SalesLineDiscount.FINDFIRST THEN
        EXIT(FALSE);

      SalesLineDiscount.INIT;
      SalesLineDiscount.VALIDATE("Sales Type",SalesTypeToSet);
      SalesLineDiscount.VALIDATE("Sales Code",SalesCodeToSet);
      SalesLineDiscount.VALIDATE(Type,TypeToSet);
      SalesLineDiscount.VALIDATE(Code,CodeToSet);
      SalesLineDiscount.VALIDATE("Line Discount %",LineDiscountPercentToSet);
      SalesLineDiscount.INSERT(TRUE);
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE CreateCustDiscGroupIfNeeded@23(CustDiscGroupCodeToSet@1000 : Code[20];DescriptionToSet@1002 : Text[50]) : Boolean;
    VAR
      CustomerDiscountGroup@1001 : Record 340;
    BEGIN
      IF CustomerDiscountGroup.GET(CustDiscGroupCodeToSet) THEN
        EXIT(FALSE);

      CustomerDiscountGroup.INIT;
      CustomerDiscountGroup.VALIDATE(Code,CustDiscGroupCodeToSet);
      CustomerDiscountGroup.VALIDATE(Description,DescriptionToSet);
      CustomerDiscountGroup.INSERT(TRUE);
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE CreateItemDiscGroupIfNeeded@27(DiscGroupCodeToSet@1001 : Code[20];DescriptionToSet@1002 : Text[50]) : Boolean;
    VAR
      ItemDiscountGroup@1000 : Record 341;
    BEGIN
      IF ItemDiscountGroup.GET(DiscGroupCodeToSet) THEN
        EXIT(FALSE);

      ItemDiscountGroup.INIT;
      ItemDiscountGroup.VALIDATE(Code,DiscGroupCodeToSet);
      ItemDiscountGroup.VALIDATE(Description,DescriptionToSet);
      ItemDiscountGroup.INSERT(TRUE);
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE CreateSalesPriceIfNeeded@10(SalesTypeToSet@1002 : 'Customer,Customer Price Group,All Customers,Campaign';SalesCodeToSet@1001 : Code[20];ItemNoToSet@1003 : Code[20];UnitPriceToSet@1004 : Decimal;CurrencyCodeToSet@1005 : Code[10];StartingDateToSet@1006 : Date;UnitOfMeasureToSet@1008 : Code[10];MinimumQuantityToSet@1007 : Decimal;VariantCodeToSet@1009 : Code[10]) : Boolean;
    VAR
      SalesPrice@1000 : Record 7002;
    BEGIN
      IF SalesPrice.GET(ItemNoToSet,SalesTypeToSet,SalesCodeToSet,StartingDateToSet,CurrencyCodeToSet,
           VariantCodeToSet,UnitOfMeasureToSet,MinimumQuantityToSet)
      THEN
        EXIT(FALSE);
      SalesPrice.INIT;

      SalesPrice.VALIDATE("Sales Type",SalesTypeToSet);
      SalesPrice.VALIDATE("Sales Code",SalesCodeToSet);
      SalesPrice.VALIDATE("Item No.",ItemNoToSet);
      SalesPrice.VALIDATE("Starting Date",StartingDateToSet);
      SalesPrice.VALIDATE("Currency Code",DataMigrationFacadeHelper.FixIfLcyCode(CurrencyCodeToSet));
      SalesPrice.VALIDATE("Variant Code",VariantCodeToSet);
      SalesPrice.VALIDATE("Unit of Measure Code",UnitOfMeasureToSet);
      SalesPrice.VALIDATE("Minimum Quantity",MinimumQuantityToSet);
      SalesPrice.VALIDATE("Unit Price",UnitPriceToSet);

      SalesPrice.INSERT(TRUE);
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE CreateTariffNumberIfNeeded@16(NoToSet@1002 : Code[20];DescriptionToSet@1001 : Text[50];SupplementaryUnitToSet@1003 : Boolean) : Boolean;
    VAR
      TariffNumber@1000 : Record 260;
    BEGIN
      IF TariffNumber.GET(NoToSet) THEN
        EXIT(FALSE);

      TariffNumber.INIT;
      TariffNumber.VALIDATE("No.",NoToSet);
      TariffNumber.VALIDATE(Description,DescriptionToSet);
      TariffNumber.VALIDATE("Supplementary Units",SupplementaryUnitToSet);
      TariffNumber.INSERT(TRUE);
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE CreateUnitOfMeasureIfNeeded@19(CodeToSet@1002 : Code[10];DescriptionToSet@1001 : Text[10]) : Boolean;
    VAR
      UnitOfMeasure@1000 : Record 204;
    BEGIN
      IF UnitOfMeasure.GET(CodeToSet) THEN
        EXIT(FALSE);

      UnitOfMeasure.INIT;
      UnitOfMeasure.VALIDATE(Code,CodeToSet);
      UnitOfMeasure.VALIDATE(Description,DescriptionToSet);
      UnitOfMeasure.INSERT(TRUE);
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE CreateItemTrackingCodeIfNeeded@12(CodeToSet@1002 : Code[10];DescriptionToSet@1001 : Text[50];LotSpecificTrackingToSet@1003 : Boolean;SNSpecificTrackingToSet@1004 : Boolean) : Boolean;
    VAR
      ItemTrackingCode@1005 : Record 6502;
    BEGIN
      IF ItemTrackingCode.GET(CodeToSet) THEN
        EXIT(FALSE);

      ItemTrackingCode.INIT;
      ItemTrackingCode.VALIDATE(Code,CodeToSet);
      ItemTrackingCode.VALIDATE(Description,DescriptionToSet);
      ItemTrackingCode.VALIDATE("Lot Specific Tracking",LotSpecificTrackingToSet);
      ItemTrackingCode.VALIDATE("SN Specific Tracking",SNSpecificTrackingToSet);
      ItemTrackingCode.INSERT(TRUE);
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE CreateInventoryPostingSetupIfNeeded@45(InventoryPostingGroupCode@1000 : Code[20];InventoryPostingGroupDescription@1003 : Text[50];LocationCode@1004 : Code[10]) Created : Boolean;
    VAR
      InventoryPostingGroup@1001 : Record 94;
      InventoryPostingSetup@1002 : Record 5813;
    BEGIN
      IF NOT InventoryPostingGroup.GET(InventoryPostingGroupCode) THEN BEGIN
        InventoryPostingGroup.INIT;
        InventoryPostingGroup.VALIDATE(Code,InventoryPostingGroupCode);
        InventoryPostingGroup.VALIDATE(Description,InventoryPostingGroupDescription);
        InventoryPostingGroup.INSERT(TRUE);
        Created := TRUE;
      END;

      IF NOT InventoryPostingSetup.GET(LocationCode,InventoryPostingGroupCode) THEN BEGIN
        InventoryPostingSetup.INIT;
        InventoryPostingSetup.VALIDATE("Location Code",LocationCode);
        InventoryPostingSetup.VALIDATE("Invt. Posting Group Code",InventoryPostingGroup.Code);
        InventoryPostingSetup.INSERT(TRUE);
        Created := TRUE;
      END;
    END;

    [External]
    PROCEDURE CreateGeneralProductPostingSetupIfNeeded@49(GeneralProdPostingGroupCode@1000 : Code[20];GeneralProdPostingGroupDescription@1003 : Text[50];GeneralBusPostingGroupCode@1004 : Code[20]) Created : Boolean;
    VAR
      GenProductPostingGroup@1001 : Record 251;
      GeneralPostingSetup@1002 : Record 252;
    BEGIN
      IF NOT GenProductPostingGroup.GET(GeneralProdPostingGroupCode) THEN BEGIN
        GenProductPostingGroup.INIT;
        GenProductPostingGroup.VALIDATE(Code,GeneralProdPostingGroupCode);
        GenProductPostingGroup.VALIDATE(Description,GeneralProdPostingGroupDescription);
        GenProductPostingGroup.INSERT(TRUE);
        Created := TRUE;
      END;

      IF NOT GeneralPostingSetup.GET(GeneralBusPostingGroupCode,GeneralProdPostingGroupCode) THEN BEGIN
        GeneralPostingSetup.INIT;
        GeneralPostingSetup.VALIDATE("Gen. Bus. Posting Group",GeneralBusPostingGroupCode);
        GeneralPostingSetup.VALIDATE("Gen. Prod. Posting Group",GenProductPostingGroup.Code);
        GeneralPostingSetup.INSERT(TRUE);
        Created := TRUE;
      END;
    END;

    [External]
    PROCEDURE CreateItemJournalBatchIfNeeded@50(ItemJournalBatchCode@1000 : Code[10];NoSeriesCode@1003 : Code[20];PostingNoSeriesCode@1004 : Code[20]);
    VAR
      ItemJournalBatch@1002 : Record 233;
      TemplateName@1001 : Code[10];
    BEGIN
      TemplateName := CreateItemJournalTemplateIfNeeded(ItemJournalBatchCode);
      ItemJournalBatch.SETRANGE("Journal Template Name",TemplateName);
      ItemJournalBatch.SETRANGE(Name,ItemJournalBatchCode);
      ItemJournalBatch.SETRANGE("No. Series",NoSeriesCode);
      ItemJournalBatch.SETRANGE("Posting No. Series",PostingNoSeriesCode);
      IF NOT ItemJournalBatch.FINDFIRST THEN BEGIN
        ItemJournalBatch.INIT;
        ItemJournalBatch.VALIDATE("Journal Template Name",TemplateName);
        ItemJournalBatch.SetupNewBatch;
        ItemJournalBatch.VALIDATE(Name,ItemJournalBatchCode);
        ItemJournalBatch.VALIDATE(Description,ItemJournalBatchCode);
        ItemJournalBatch."No. Series" := NoSeriesCode;
        ItemJournalBatch."Posting No. Series" := PostingNoSeriesCode;
        ItemJournalBatch.INSERT(TRUE);
      END;
    END;

    LOCAL PROCEDURE CreateItemJournalTemplateIfNeeded@55(ItemJournalBatchCode@1001 : Code[10]) : Code[10];
    VAR
      ItemJournalTemplate@1000 : Record 82;
    BEGIN
      ItemJournalTemplate.SETRANGE(Type,ItemJournalTemplate.Type::Item);
      ItemJournalTemplate.SETRANGE(Recurring,FALSE);
      IF NOT ItemJournalTemplate.FINDFIRST THEN BEGIN
        ItemJournalTemplate.INIT;
        ItemJournalTemplate.VALIDATE(Name,ItemJournalBatchCode);
        ItemJournalTemplate.VALIDATE(Type,ItemJournalTemplate.Type::Item);
        ItemJournalTemplate.VALIDATE(Recurring,FALSE);
        ItemJournalTemplate.INSERT(TRUE);
      END;
      EXIT(ItemJournalTemplate.Name);
    END;

    [External]
    PROCEDURE CreateItemJournalLine@53(ItemJournalBatchCode@1006 : Code[10];DocumentNo@1004 : Code[20];Description@1003 : Text[50];PostingDate@1000 : Date;Qty@1001 : Decimal;Amount@1002 : Decimal;LocationCode@1012 : Code[10];GenProdPostingGroupGode@1010 : Code[20]);
    VAR
      ItemJournalLineCurrent@1008 : Record 83;
      ItemJournalLine@1005 : Record 83;
      ItemJournalBatch@1007 : Record 233;
      LineNum@1009 : Integer;
    BEGIN
      ItemJournalBatch.GET(CreateItemJournalTemplateIfNeeded(ItemJournalBatchCode),ItemJournalBatchCode);

      ItemJournalLineCurrent.SETRANGE("Journal Template Name",ItemJournalBatch."Journal Template Name");
      ItemJournalLineCurrent.SETRANGE("Journal Batch Name",ItemJournalBatch.Name);
      IF ItemJournalLineCurrent.FINDLAST THEN
        LineNum := ItemJournalLineCurrent."Line No." + 10000
      ELSE
        LineNum := 10000;

      ItemJournalLine.INIT;

      ItemJournalLine.VALIDATE("Journal Template Name",ItemJournalBatch."Journal Template Name");
      ItemJournalLine.VALIDATE("Journal Batch Name",ItemJournalBatch.Name);
      ItemJournalLine.VALIDATE("Line No.",LineNum);
      ItemJournalLine.VALIDATE("Entry Type",ItemJournalLine."Entry Type"::"Positive Adjmt.");
      ItemJournalLine.VALIDATE("Document No.",DocumentNo);
      ItemJournalLine.VALIDATE("Item No.",GlobalItem."No.");
      ItemJournalLine.VALIDATE("Location Code",LocationCode);
      ItemJournalLine.VALIDATE(Description,Description);
      ItemJournalLine.VALIDATE("Document Date",PostingDate);
      ItemJournalLine.VALIDATE("Posting Date",PostingDate);
      ItemJournalLine.VALIDATE(Quantity,Qty);
      ItemJournalLine.VALIDATE(Amount,Amount);
      ItemJournalLine.VALIDATE("Gen. Bus. Posting Group",'');
      ItemJournalLine.VALIDATE("Gen. Prod. Posting Group",GenProdPostingGroupGode);
      ItemJournalLine.INSERT(TRUE);

      GlobalItemJournalLine := ItemJournalLine;
      ItemJournalLineIsSet := TRUE;
    END;

    [External]
    PROCEDURE SetItemJournalLineItemTracking@56(SerialNumber@1001 : Code[20];LotNumber@1000 : Code[20]);
    BEGIN
      IF NOT ItemJournalLineIsSet THEN
        ERROR(InternalItemJnlLIneNotSetErr);

      IF (SerialNumber <> '') OR (LotNumber <> '') THEN
        CreateItemTracking(GlobalItemJournalLine,SerialNumber,LotNumber);
    END;

    LOCAL PROCEDURE CreateItemTracking@54(ItemJournalLine@1001 : Record 83;SerialNumber@1003 : Code[20];LotNumber@1004 : Code[20]);
    VAR
      ReservationEntry@1002 : Record 337;
      CreateReservEntry@1000 : Codeunit 99000830;
    BEGIN
      CreateReservEntry.CreateReservEntryFor(
        DATABASE::"Item Journal Line",
        ItemJournalLine."Entry Type",
        ItemJournalLine."Journal Template Name",
        ItemJournalLine."Journal Batch Name",
        0,
        ItemJournalLine."Line No.",
        ItemJournalLine."Qty. per Unit of Measure",
        ABS(ItemJournalLine.Quantity),
        ABS(ItemJournalLine."Quantity (Base)"),
        SerialNumber,LotNumber);
      CreateReservEntry.CreateEntry(
        ItemJournalLine."Item No.",
        ItemJournalLine."Variant Code",
        ItemJournalLine."Location Code",
        '',
        0D,
        0D,
        0,
        ReservationEntry."Reservation Status"::Prospect);
    END;

    [External]
    PROCEDURE SetItemJournalLineDimension@60(DimensionCode@1001 : Code[20];DimensionDescription@1005 : Text[50];DimensionValueCode@1002 : Code[20];DimensionValueName@1006 : Text[50]);
    VAR
      DataMigrationFacadeHelper@1000 : Codeunit 1797;
    BEGIN
      IF NOT ItemJournalLineIsSet THEN
        ERROR(InternalItemJnlLIneNotSetErr);

      GlobalItemJournalLine.VALIDATE("Dimension Set ID",
        DataMigrationFacadeHelper.CreateDimensionSetId(GlobalItemJournalLine."Dimension Set ID",
          DimensionCode,DimensionDescription,
          DimensionValueCode,DimensionValueName));
      GlobalItemJournalLine.MODIFY(TRUE);
    END;

    [External]
    PROCEDURE CreateDefaultDimensionAndRequirementsIfNeeded@18(DimensionCode@1003 : Text[20];DimensionDescription@1004 : Text[50];DimensionValueCode@1005 : Code[20];DimensionValueName@1006 : Text[30]);
    VAR
      Dimension@1000 : Record 348;
      DimensionValue@1001 : Record 349;
    BEGIN
      IF NOT ItemIsSet THEN
        ERROR(InternalItemNotSetErr);

      DataMigrationFacadeHelper.GetOrCreateDimension(DimensionCode,DimensionDescription,Dimension);
      DataMigrationFacadeHelper.GetOrCreateDimensionValue(Dimension.Code,DimensionValueCode,DimensionValueName,DimensionValue);
      DataMigrationFacadeHelper.CreateOnlyDefaultDimensionIfNeeded(Dimension.Code,DimensionValue.Code,DATABASE::Item,GlobalItem."No.");
    END;

    [External]
    PROCEDURE SetItemTrackingCode@13(TrackingCodeToSet@1002 : Code[10]);
    BEGIN
      IF NOT ItemIsSet THEN
        ERROR(InternalItemNotSetErr);

      GlobalItem.VALIDATE("Item Tracking Code",TrackingCodeToSet);
    END;

    [External]
    PROCEDURE SetBaseUnitOfMeasure@31(BaseUnitOfMeasureToSet@1002 : Code[10]);
    BEGIN
      IF NOT ItemIsSet THEN
        ERROR(InternalItemNotSetErr);

      GlobalItem.VALIDATE("Base Unit of Measure",BaseUnitOfMeasureToSet);
    END;

    [External]
    PROCEDURE SetItemDiscGroup@35(ItemDiscGroupToSet@1002 : Code[20]);
    BEGIN
      IF NOT ItemIsSet THEN
        ERROR(InternalItemNotSetErr);

      GlobalItem.VALIDATE("Item Disc. Group",ItemDiscGroupToSet);
    END;

    [External]
    PROCEDURE SetTariffNo@36(TariffNoToSet@1002 : Code[20]);
    BEGIN
      IF NOT ItemIsSet THEN
        ERROR(InternalItemNotSetErr);

      GlobalItem.VALIDATE("Tariff No.",TariffNoToSet);
    END;

    [External]
    PROCEDURE SetCostingMethod@47(CostingMethodToSet@1002 : 'FIFO,LIFO,Specific,Average,Standard');
    BEGIN
      IF NOT ItemIsSet THEN
        ERROR(InternalItemNotSetErr);

      GlobalItem.VALIDATE("Costing Method",CostingMethodToSet);
    END;

    [External]
    PROCEDURE SetUnitCost@14(UnitCostToSet@1002 : Decimal);
    BEGIN
      IF NOT ItemIsSet THEN
        ERROR(InternalItemNotSetErr);

      GlobalItem.VALIDATE("Unit Cost",UnitCostToSet);
    END;

    [External]
    PROCEDURE SetStandardCost@34(StandardCostToSet@1000 : Decimal);
    BEGIN
      IF NOT ItemIsSet THEN
        ERROR(InternalItemNotSetErr);

      GlobalItem.VALIDATE("Standard Cost",StandardCostToSet);
    END;

    [External]
    PROCEDURE SetVendorItemNo@33(VendorItemNoToSet@1002 : Text[20]);
    BEGIN
      IF NOT ItemIsSet THEN
        ERROR(InternalItemNotSetErr);

      GlobalItem.VALIDATE("Vendor Item No.",VendorItemNoToSet);
    END;

    [External]
    PROCEDURE SetNetWeight@32(NetWeightToSet@1002 : Decimal);
    BEGIN
      IF NOT ItemIsSet THEN
        ERROR(InternalItemNotSetErr);

      GlobalItem.VALIDATE("Net Weight",NetWeightToSet);
    END;

    [External]
    PROCEDURE SetUnitVolume@30(UnitVolumeToSet@1002 : Decimal);
    BEGIN
      IF NOT ItemIsSet THEN
        ERROR(InternalItemNotSetErr);

      GlobalItem.VALIDATE("Unit Volume",UnitVolumeToSet);
    END;

    [External]
    PROCEDURE SetBlocked@29(BlockedToSet@1002 : Boolean);
    BEGIN
      IF NOT ItemIsSet THEN
        ERROR(InternalItemNotSetErr);

      GlobalItem.VALIDATE(Blocked,BlockedToSet);
    END;

    [External]
    PROCEDURE SetStockoutWarning@28(IsStockoutWarning@1002 : Boolean);
    BEGIN
      IF NOT ItemIsSet THEN
        ERROR(InternalItemNotSetErr);

      IF IsStockoutWarning THEN
        GlobalItem.VALIDATE("Stockout Warning",GlobalItem."Stockout Warning"::Yes)
      ELSE
        GlobalItem.VALIDATE("Stockout Warning",GlobalItem."Stockout Warning"::No);
    END;

    [External]
    PROCEDURE SetPreventNegativeInventory@26(IsPreventNegativeInventory@1002 : Boolean);
    BEGIN
      IF NOT ItemIsSet THEN
        ERROR(InternalItemNotSetErr);

      IF IsPreventNegativeInventory THEN
        GlobalItem.VALIDATE("Prevent Negative Inventory",GlobalItem."Prevent Negative Inventory"::Yes)
      ELSE
        GlobalItem.VALIDATE("Prevent Negative Inventory",GlobalItem."Prevent Negative Inventory"::No);
    END;

    [External]
    PROCEDURE SetReorderQuantity@25(ReorderQuantityToSet@1002 : Decimal);
    BEGIN
      IF NOT ItemIsSet THEN
        ERROR(InternalItemNotSetErr);

      GlobalItem.VALIDATE("Reorder Quantity",ReorderQuantityToSet);
    END;

    [External]
    PROCEDURE SetAlternativeItemNo@17(AlternativeItemNoToSet@1002 : Code[20]);
    BEGIN
      IF NOT ItemIsSet THEN
        ERROR(InternalItemNotSetErr);

      GlobalItem.VALIDATE("Alternative Item No.",AlternativeItemNoToSet);
    END;

    [External]
    PROCEDURE SetVendorNo@15(VendorNoToSet@1002 : Code[20]) : Boolean;
    VAR
      Vendor@1000 : Record 23;
    BEGIN
      IF NOT ItemIsSet THEN
        ERROR(InternalItemNotSetErr);

      IF NOT Vendor.GET(VendorNoToSet) THEN
        EXIT;

      GlobalItem.VALIDATE("Vendor No.",VendorNoToSet);

      EXIT(TRUE);
    END;

    [External]
    PROCEDURE SetLastDateModified@42(LastDateModifiedToSet@1000 : Date);
    BEGIN
      IF NOT ItemIsSet THEN
        ERROR(InternalItemNotSetErr);

      GlobalItem.VALIDATE("Last Date Modified",LastDateModifiedToSet);
    END;

    [External]
    PROCEDURE SetLastModifiedDateTime@41(LastModifiedDateTimeToSet@1000 : DateTime);
    BEGIN
      IF NOT ItemIsSet THEN
        ERROR(InternalItemNotSetErr);

      GlobalItem.VALIDATE("Last DateTime Modified",LastModifiedDateTimeToSet);
    END;

    [External]
    PROCEDURE CreateCustomerPriceGroupIfNeeded@44(CodeToSet@1000 : Code[10];DescriptionToSet@1001 : Text[50];PriceIncludesVatToSet@1002 : Boolean) : Code[10];
    BEGIN
      EXIT(DataMigrationFacadeHelper.CreateCustomerPriceGroupIfNeeded(CodeToSet,DescriptionToSet,PriceIncludesVatToSet));
    END;

    [External]
    PROCEDURE SetInventoryPostingSetupInventoryAccount@46(InventoryPostingGroupCode@1001 : Code[20];LocationCode@1000 : Code[10];InventoryAccountCode@1003 : Code[20]);
    VAR
      InventoryPostingSetup@1002 : Record 5813;
    BEGIN
      InventoryPostingSetup.GET(LocationCode,InventoryPostingGroupCode);
      InventoryPostingSetup.VALIDATE("Inventory Account",InventoryAccountCode);
      InventoryPostingSetup.MODIFY(TRUE);
    END;

    [External]
    PROCEDURE SetGeneralPostingSetupInventoryAdjmntAccount@51(GeneralProdPostingGroupCode@1001 : Code[20];GeneralBusPostingGroupCode@1000 : Code[10];InventoryAdjmntAccountCode@1003 : Code[20]);
    VAR
      GeneralPostingSetup@1002 : Record 252;
    BEGIN
      GeneralPostingSetup.GET(GeneralBusPostingGroupCode,GeneralProdPostingGroupCode);
      GeneralPostingSetup.VALIDATE("Inventory Adjmt. Account",InventoryAdjmntAccountCode);
      GeneralPostingSetup.MODIFY(TRUE);
    END;

    [External]
    PROCEDURE SetInventoryPostingGroup@39(InventoryPostingGroupCode@1002 : Code[20]) : Boolean;
    VAR
      InventoryPostingGroup@1000 : Record 94;
    BEGIN
      IF NOT ItemIsSet THEN
        ERROR(InternalItemNotSetErr);

      IF NOT InventoryPostingGroup.GET(InventoryPostingGroupCode) THEN
        EXIT;

      GlobalItem.VALIDATE("Inventory Posting Group",InventoryPostingGroupCode);

      EXIT(TRUE);
    END;

    [External]
    PROCEDURE SetGeneralProductPostingGroup@48(GenProductPostingGroupCode@1002 : Code[20]) : Boolean;
    VAR
      GenProductPostingGroup@1000 : Record 251;
    BEGIN
      IF NOT ItemIsSet THEN
        ERROR(InternalItemNotSetErr);

      IF NOT GenProductPostingGroup.GET(GenProductPostingGroupCode) THEN
        EXIT;

      GlobalItem.VALIDATE("Gen. Prod. Posting Group",GenProductPostingGroupCode);

      EXIT(TRUE);
    END;

    [Integration(TRUE)]
    LOCAL PROCEDURE OnMigrateItem@1(RecordIdToMigrate@1001 : RecordID);
    BEGIN
    END;

    [Integration(TRUE)]
    LOCAL PROCEDURE OnMigrateItemPrice@5(RecordIdToMigrate@1001 : RecordID);
    BEGIN
    END;

    [Integration(TRUE)]
    LOCAL PROCEDURE OnMigrateItemSalesLineDiscount@6(RecordIdToMigrate@1001 : RecordID);
    BEGIN
    END;

    [Integration(TRUE)]
    LOCAL PROCEDURE OnMigrateItemTrackingCode@2(RecordIdToMigrate@1001 : RecordID);
    BEGIN
    END;

    [Integration(TRUE)]
    LOCAL PROCEDURE OnMigrateCostingMethod@11(RecordIdToMigrate@1001 : RecordID);
    BEGIN
    END;

    [Integration(TRUE)]
    LOCAL PROCEDURE OnMigrateItemUnitOfMeasure@3(RecordIdToMigrate@1001 : RecordID);
    BEGIN
    END;

    [Integration(TRUE)]
    LOCAL PROCEDURE OnMigrateItemDiscountGroup@4(RecordIdToMigrate@1001 : RecordID);
    BEGIN
    END;

    [Integration(TRUE)]
    LOCAL PROCEDURE OnMigrateItemTariffNo@7(RecordIdToMigrate@1001 : RecordID);
    BEGIN
    END;

    [Integration(TRUE)]
    LOCAL PROCEDURE OnMigrateItemDimensions@8(RecordIdToMigrate@1001 : RecordID);
    BEGIN
    END;

    [Integration(TRUE)]
    LOCAL PROCEDURE OnMigrateItemPostingGroups@38(RecordIdToMigrate@1000 : RecordID;ChartOfAccountsMigrated@1001 : Boolean);
    BEGIN
    END;

    [Integration(TRUE)]
    LOCAL PROCEDURE OnMigrateInventoryTransactions@43(RecordIdToMigrate@1000 : RecordID;ChartOfAccountsMigrated@1001 : Boolean);
    BEGIN
    END;

    BEGIN
    END.
  }
}

