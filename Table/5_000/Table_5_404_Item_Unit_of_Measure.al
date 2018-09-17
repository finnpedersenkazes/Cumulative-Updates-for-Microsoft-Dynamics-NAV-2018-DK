OBJECT Table 5404 Item Unit of Measure
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    OnDelete=BEGIN
               TestItemUOM;
               CheckNoEntriesWithUoM;
             END;

    OnRename=BEGIN
               TestItemUOM;
             END;

    CaptionML=[DAN=Vareenhed;
               ENU=Item Unit of Measure];
    LookupPageID=Page5404;
  }
  FIELDS
  {
    { 1   ;   ;Item No.            ;Code20        ;TableRelation=Item;
                                                   OnValidate=BEGIN
                                                                CalcWeight;
                                                              END;

                                                   CaptionML=[DAN=Varenr.;
                                                              ENU=Item No.];
                                                   NotBlank=Yes }
    { 2   ;   ;Code                ;Code10        ;TableRelation="Unit of Measure";
                                                   CaptionML=[DAN=Kode;
                                                              ENU=Code];
                                                   NotBlank=Yes }
    { 3   ;   ;Qty. per Unit of Measure;Decimal   ;InitValue=1;
                                                   OnValidate=BEGIN
                                                                IF "Qty. per Unit of Measure" <= 0 THEN
                                                                  FIELDERROR("Qty. per Unit of Measure",Text000);
                                                                IF xRec."Qty. per Unit of Measure" <> "Qty. per Unit of Measure" THEN
                                                                  CheckNoEntriesWithUoM;
                                                                Item.GET("Item No.");
                                                                IF Item."Base Unit of Measure" = Code THEN
                                                                  TESTFIELD("Qty. per Unit of Measure",1);
                                                                CalcWeight;
                                                              END;

                                                   CaptionML=[DAN=Antal pr. enhed;
                                                              ENU=Qty. per Unit of Measure];
                                                   DecimalPlaces=0:5 }
    { 7300;   ;Length              ;Decimal       ;OnValidate=BEGIN
                                                                CalcCubage;
                                                              END;

                                                   CaptionML=[DAN=L�ngde;
                                                              ENU=Length];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 7301;   ;Width               ;Decimal       ;OnValidate=BEGIN
                                                                CalcCubage;
                                                              END;

                                                   CaptionML=[DAN=Bredde;
                                                              ENU=Width];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 7302;   ;Height              ;Decimal       ;OnValidate=BEGIN
                                                                CalcCubage;
                                                              END;

                                                   CaptionML=[DAN=H�jde;
                                                              ENU=Height];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 7303;   ;Cubage              ;Decimal       ;CaptionML=[DAN=Rumm�l;
                                                              ENU=Cubage];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 7304;   ;Weight              ;Decimal       ;CaptionML=[DAN=V�gt;
                                                              ENU=Weight];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
  }
  KEYS
  {
    {    ;Item No.,Code                           ;Clustered=Yes }
    {    ;Item No.,Qty. per Unit of Measure        }
    {    ;Code                                     }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;Code,Qty. per Unit of Measure            }
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=skal v�re st�rre end 0;ENU=must be greater than 0';
      Item@1001 : Record 27;
      Text001@1004 : TextConst 'DAN=Du kan ikke omd�be %1 %2 for varen %3, fordi det er varens %4, og fordi der findes en eller flere �bne poster for varen.;ENU=You cannot rename %1 %2 for item %3 because it is the item''s %4 and there are one or more open ledger entries for the item.';
      CannotModifyBaseUnitOfMeasureErr@1005 : TextConst '@@@=%1 Value of Measure (KG, PCS...), %2 Item ID;DAN=Du kan ikke �ndre vareenhed %1 for varen %2, fordi den er varens basisenhed.;ENU=You cannot modify item unit of measure %1 for item %2 because it is the item''s base unit of measure.';
      CannotModifySalesUnitOfMeasureErr@1008 : TextConst '@@@=%1 Value of Measure (KG, PCS...), %2 Item ID;DAN=Du kan ikke �ndre vareenhed %1 for varen %2, fordi den er varens salgsenhed.;ENU=You cannot modify item unit of measure %1 for item %2 because it is the item''s sales unit of measure.';
      CannotModifyPurchUnitOfMeasureErr@1007 : TextConst '@@@=%1 Value of Measure (KG, PCS...), %2 Item ID;DAN=Du kan ikke �ndre vareenhed %1 for varen %2, fordi den er varens k�bsenhed.;ENU=You cannot modify item unit of measure %1 for item %2 because it is the item''s purchase unit of measure.';
      CannotModifyPutAwayUnitOfMeasureErr@1006 : TextConst '@@@=%1 Value of Measure (KG, PCS...), %2 Item ID;DAN=Du kan ikke �ndre vareenhed %1 for varen %2, fordi den er varens l�g-p�-lager-enhed.;ENU=You cannot modify item unit of measure %1 for item %2 because it is the item''s put-away unit of measure.';
      CannotModifyUnitOfMeasureErr@1002 : TextConst '@@@=%1 Table name (Item Unit of measure), %2 Value of Measure (KG, PCS...), %3 Item ID, %4 Entry Table Name, %5 Field Caption;DAN=Du kan ikke �ndre %1 %2 for varen %3, fordi ikke-nul-%5 med %2 findes i %4.;ENU=You cannot modify %1 %2 for item %3 because non-zero %5 with %2 exists in %4.';
      CannotModifyUOMWithWhseEntriesErr@1003 : TextConst '@@@="%1 = Item Unit of Measure %2 = Code %3 = Item No.";DAN=Du kan ikke �ndre %1 %2 for vare %3, fordi der er en eller flere lagerreguleringersposter for varen.;ENU=You cannot modify %1 %2 for item %3 because there are one or more warehouse adjustment entries for the item.';

    LOCAL PROCEDURE CalcCubage@7300();
    BEGIN
      Cubage := Length * Width * Height;
    END;

    [External]
    PROCEDURE CalcWeight@7301();
    BEGIN
      IF Item."No." <> "Item No." THEN
        Item.GET("Item No.");
      Weight := "Qty. per Unit of Measure" * Item."Net Weight";
    END;

    LOCAL PROCEDURE TestNoOpenEntriesExist@1();
    VAR
      Item@1000 : Record 27;
      ItemLedgEntry@1001 : Record 32;
    BEGIN
      IF Item.GET("Item No.") THEN
        IF Item."Base Unit of Measure" = xRec.Code THEN BEGIN
          ItemLedgEntry.SETCURRENTKEY("Item No.",Open);
          ItemLedgEntry.SETRANGE("Item No.","Item No.");
          ItemLedgEntry.SETRANGE(Open,TRUE);
          IF NOT ItemLedgEntry.ISEMPTY THEN
            ERROR(Text001,TABLECAPTION,xRec.Code,"Item No.",Item.FIELDCAPTION("Base Unit of Measure"));
        END;
    END;

    LOCAL PROCEDURE TestNoWhseAdjmtEntriesExist@7();
    VAR
      WhseEntry@1001 : Record 7312;
      Location@1002 : Record 14;
      Bin@1003 : Record 7354;
    BEGIN
      WhseEntry.SETRANGE("Item No.","Item No.");
      WhseEntry.SETRANGE("Unit of Measure Code",xRec.Code);
      IF Location.FINDSET THEN
        REPEAT
          IF Bin.GET(Location.Code,Location."Adjustment Bin Code") THEN BEGIN
            WhseEntry.SETRANGE("Zone Code",Bin."Zone Code");
            IF NOT WhseEntry.ISEMPTY THEN
              ERROR(CannotModifyUOMWithWhseEntriesErr,TABLECAPTION,xRec.Code,"Item No.");
          END;
        UNTIL Location.NEXT = 0;
    END;

    [External]
    PROCEDURE TestItemSetup@2();
    BEGIN
      IF Item.GET("Item No.") THEN BEGIN
        IF Item."Base Unit of Measure" = xRec.Code THEN
          ERROR(CannotModifyBaseUnitOfMeasureErr,xRec.Code,"Item No.");
        IF Item."Sales Unit of Measure" = xRec.Code THEN
          ERROR(CannotModifySalesUnitOfMeasureErr,xRec.Code,"Item No.");
        IF Item."Purch. Unit of Measure" = xRec.Code THEN
          ERROR(CannotModifyPurchUnitOfMeasureErr,xRec.Code,"Item No.");
        IF Item."Put-away Unit of Measure Code" = xRec.Code THEN
          ERROR(CannotModifyPutAwayUnitOfMeasureErr,xRec.Code,"Item No.");
      END;
    END;

    LOCAL PROCEDURE TestItemUOM@17();
    BEGIN
      TestItemSetup;
      TestNoOpenEntriesExist;
      TestNoWhseAdjmtEntriesExist;
    END;

    [External]
    PROCEDURE CheckNoEntriesWithUoM@3();
    VAR
      WarehouseEntry@1001 : Record 7312;
    BEGIN
      WarehouseEntry.SETRANGE("Item No.","Item No.");
      WarehouseEntry.SETRANGE("Unit of Measure Code",Code);
      WarehouseEntry.CALCSUMS("Qty. (Base)",Quantity);
      IF (WarehouseEntry."Qty. (Base)" <> 0) OR (WarehouseEntry.Quantity <> 0) THEN
        ERROR(
          CannotModifyUnitOfMeasureErr,TABLECAPTION,xRec.Code,"Item No.",WarehouseEntry.TABLECAPTION,
          WarehouseEntry.FIELDCAPTION(Quantity));

      CheckNoOutstandingQty;
    END;

    LOCAL PROCEDURE CheckNoOutstandingQty@5();
    BEGIN
      CheckNoOutstandingQtyPurchLine;
      CheckNoOutstandingQtySalesLine;
      CheckNoOutstandingQtyTransferLine;
      CheckNoRemQtyProdOrderLine;
      CheckNoRemQtyProdOrderComponent;
      CheckNoOutstandingQtyServiceLine;
      CheckNoRemQtyAssemblyHeader;
      CheckNoRemQtyAssemblyLine;
    END;

    LOCAL PROCEDURE CheckNoOutstandingQtyPurchLine@9();
    VAR
      PurchLine@1000 : Record 39;
    BEGIN
      PurchLine.SETRANGE(Type,PurchLine.Type::Item);
      PurchLine.SETRANGE("No.","Item No.");
      PurchLine.SETRANGE("Unit of Measure Code",Code);
      PurchLine.SETFILTER("Outstanding Quantity",'<>%1',0);
      IF NOT PurchLine.ISEMPTY THEN
        ERROR(
          CannotModifyUnitOfMeasureErr,TABLECAPTION,xRec.Code,"Item No.",
          PurchLine.TABLECAPTION,PurchLine.FIELDCAPTION("Qty. to Receive"));
    END;

    LOCAL PROCEDURE CheckNoOutstandingQtySalesLine@10();
    VAR
      SalesLine@1000 : Record 37;
    BEGIN
      SalesLine.SETRANGE(Type,SalesLine.Type::Item);
      SalesLine.SETRANGE("No.","Item No.");
      SalesLine.SETRANGE("Unit of Measure Code",Code);
      SalesLine.SETFILTER("Outstanding Quantity",'<>%1',0);
      IF NOT SalesLine.ISEMPTY THEN
        ERROR(
          CannotModifyUnitOfMeasureErr,TABLECAPTION,xRec.Code,"Item No.",
          SalesLine.TABLECAPTION,SalesLine.FIELDCAPTION("Qty. to Ship"));
    END;

    LOCAL PROCEDURE CheckNoOutstandingQtyTransferLine@11();
    VAR
      TransferLine@1000 : Record 5741;
    BEGIN
      TransferLine.SETRANGE("Item No.","Item No.");
      TransferLine.SETRANGE("Unit of Measure Code",Code);
      TransferLine.SETFILTER("Outstanding Quantity",'<>%1',0);
      IF NOT TransferLine.ISEMPTY THEN
        ERROR(
          CannotModifyUnitOfMeasureErr,TABLECAPTION,xRec.Code,"Item No.",
          TransferLine.TABLECAPTION,TransferLine.FIELDCAPTION("Qty. to Ship"));
    END;

    LOCAL PROCEDURE CheckNoRemQtyProdOrderLine@12();
    VAR
      ProdOrderLine@1000 : Record 5406;
    BEGIN
      ProdOrderLine.SETRANGE("Item No.","Item No.");
      ProdOrderLine.SETRANGE("Unit of Measure Code",Code);
      ProdOrderLine.SETFILTER("Remaining Quantity",'<>%1',0);
      ProdOrderLine.SETFILTER(Status,'<>%1',ProdOrderLine.Status::Finished);
      IF NOT ProdOrderLine.ISEMPTY THEN
        ERROR(
          CannotModifyUnitOfMeasureErr,TABLECAPTION,xRec.Code,"Item No.",
          ProdOrderLine.TABLECAPTION,ProdOrderLine.FIELDCAPTION("Remaining Quantity"));
    END;

    LOCAL PROCEDURE CheckNoRemQtyProdOrderComponent@13();
    VAR
      ProdOrderComponent@1000 : Record 5407;
    BEGIN
      ProdOrderComponent.SETRANGE("Item No.","Item No.");
      ProdOrderComponent.SETRANGE("Unit of Measure Code",Code);
      ProdOrderComponent.SETFILTER("Remaining Quantity",'<>%1',0);
      ProdOrderComponent.SETFILTER(Status,'<>%1',ProdOrderComponent.Status::Finished);
      IF NOT ProdOrderComponent.ISEMPTY THEN
        ERROR(
          CannotModifyUnitOfMeasureErr,TABLECAPTION,xRec.Code,"Item No.",
          ProdOrderComponent.TABLECAPTION,ProdOrderComponent.FIELDCAPTION("Remaining Quantity"));
    END;

    LOCAL PROCEDURE CheckNoOutstandingQtyServiceLine@14();
    VAR
      ServiceLine@1000 : Record 5902;
    BEGIN
      ServiceLine.SETRANGE(Type,ServiceLine.Type::Item);
      ServiceLine.SETRANGE("No.","Item No.");
      ServiceLine.SETRANGE("Unit of Measure Code",Code);
      ServiceLine.SETFILTER("Outstanding Quantity",'<>%1',0);
      IF NOT ServiceLine.ISEMPTY THEN
        ERROR(
          CannotModifyUnitOfMeasureErr,TABLECAPTION,xRec.Code,"Item No.",
          ServiceLine.TABLECAPTION,ServiceLine.FIELDCAPTION("Qty. to Ship"));
    END;

    LOCAL PROCEDURE CheckNoRemQtyAssemblyHeader@6();
    VAR
      AssemblyHeader@1000 : Record 900;
    BEGIN
      AssemblyHeader.SETRANGE("Item No.","Item No.");
      AssemblyHeader.SETRANGE("Unit of Measure Code",Code);
      AssemblyHeader.SETFILTER("Remaining Quantity",'<>%1',0);
      IF NOT AssemblyHeader.ISEMPTY THEN
        ERROR(
          CannotModifyUnitOfMeasureErr,TABLECAPTION,xRec.Code,"Item No.",
          AssemblyHeader.TABLECAPTION,AssemblyHeader.FIELDCAPTION("Remaining Quantity"));
    END;

    LOCAL PROCEDURE CheckNoRemQtyAssemblyLine@4();
    VAR
      AssemblyLine@1000 : Record 901;
    BEGIN
      AssemblyLine.SETRANGE(Type,AssemblyLine.Type::Item);
      AssemblyLine.SETRANGE("No.","Item No.");
      AssemblyLine.SETRANGE("Unit of Measure Code",Code);
      AssemblyLine.SETFILTER("Remaining Quantity",'<>%1',0);
      IF NOT AssemblyLine.ISEMPTY THEN
        ERROR(
          CannotModifyUnitOfMeasureErr,TABLECAPTION,xRec.Code,"Item No.",
          AssemblyLine.TABLECAPTION,AssemblyLine.FIELDCAPTION("Remaining Quantity"));
    END;

    BEGIN
    END.
  }
}

