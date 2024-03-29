OBJECT Table 1304 Sales Price and Line Disc Buff
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
               IF "Sales Type" = "Sales Type"::"All Customers" THEN
                 "Sales Code" := ''
               ELSE
                 TESTFIELD("Sales Code");
               TESTFIELD(Code);

               InsertNewRecordVersion;
             END;

    OnModify=BEGIN
               DeleteOldRecordVersion;
               InsertNewRecordVersion;
             END;

    OnDelete=BEGIN
               DeleteOldRecordVersion;
             END;

    OnRename=BEGIN
               IF "Sales Type" <> "Sales Type"::"All Customers" THEN
                 TESTFIELD("Sales Code");

               TESTFIELD(Code);

               DeleteOldRecordVersion;
               InsertNewRecordVersion;
             END;

    CaptionML=[DAN=Salgspris og linjerabatbuffer;
               ENU=Sales Price and Line Disc Buff];
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code20        ;TableRelation=IF (Type=CONST(Item)) Item
                                                                 ELSE IF (Type=CONST(Item Disc. Group)) "Item Discount Group";
                                                   OnValidate=VAR
                                                                Item@1000 : Record 27;
                                                                CustPriceGr@1001 : Record 6;
                                                              BEGIN
                                                                "Unit of Measure Code" := '';
                                                                "Variant Code" := '';

                                                                IF Type = Type::Item THEN
                                                                  IF Item.GET(Code) THEN
                                                                    "Unit of Measure Code" := Item."Sales Unit of Measure";

                                                                IF "Line Type" = "Line Type"::"Sales Price" THEN BEGIN
                                                                  IF "Sales Type" = "Sales Type"::"Customer Price/Disc. Group" THEN
                                                                    IF CustPriceGr.GET("Sales Code") AND
                                                                       (CustPriceGr."Allow Invoice Disc." = "Allow Invoice Disc.")
                                                                    THEN
                                                                      EXIT;

                                                                  UpdateValuesFromItem;
                                                                END;
                                                              END;

                                                   OnLookup=VAR
                                                              Item@1000 : Record 27;
                                                              ItemDiscountGroup@1001 : Record 341;
                                                            BEGIN
                                                              CASE Type OF
                                                                Type::Item:
                                                                  IF PAGE.RUNMODAL(PAGE::"Item List",Item) = ACTION::LookupOK THEN
                                                                    VALIDATE(Code,Item."No.");
                                                                Type::"Item Disc. Group":
                                                                  IF PAGE.RUNMODAL(PAGE::"Item Disc. Groups",ItemDiscountGroup) = ACTION::LookupOK THEN
                                                                    VALIDATE(Code,ItemDiscountGroup.Code);
                                                              END;
                                                            END;

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kode;
                                                              ENU=Code];
                                                   NotBlank=Yes }
    { 2   ;   ;Sales Code          ;Code20        ;TableRelation=IF (Sales Type=CONST(Customer Price/Disc. Group),
                                                                     Line Type=CONST(Sales Line Discount)) "Customer Discount Group"
                                                                     ELSE IF (Sales Type=CONST(Customer Price/Disc. Group),
                                                                              Line Type=CONST(Sales Price)) "Customer Price Group"
                                                                              ELSE IF (Sales Type=CONST(Customer)) Customer;
                                                   OnValidate=VAR
                                                                CustPriceGr@1000 : Record 6;
                                                                Cust@1001 : Record 18;
                                                              BEGIN
                                                                IF "Sales Code" <> '' THEN
                                                                  CASE "Sales Type" OF
                                                                    "Sales Type"::"All Customers":
                                                                      ERROR(MustBeBlankErr,FIELDCAPTION("Sales Code"));
                                                                    "Sales Type"::"Customer Price/Disc. Group":
                                                                      IF "Line Type" = "Line Type"::"Sales Price" THEN BEGIN
                                                                        CustPriceGr.GET("Sales Code");
                                                                        "Price Includes VAT" := CustPriceGr."Price Includes VAT";
                                                                        "VAT Bus. Posting Gr. (Price)" := CustPriceGr."VAT Bus. Posting Gr. (Price)";
                                                                        "Allow Line Disc." := CustPriceGr."Allow Line Disc.";
                                                                        "Allow Invoice Disc." := CustPriceGr."Allow Invoice Disc.";
                                                                      END;
                                                                    "Sales Type"::Customer:
                                                                      BEGIN
                                                                        Cust.GET("Sales Code");
                                                                        "Currency Code" := Cust."Currency Code";
                                                                        IF "Line Type" = "Line Type"::"Sales Price" THEN BEGIN
                                                                          "Price Includes VAT" := Cust."Prices Including VAT";
                                                                          "VAT Bus. Posting Gr. (Price)" := Cust."VAT Bus. Posting Group";
                                                                          "Allow Line Disc." := Cust."Allow Line Disc.";
                                                                        END;
                                                                      END;
                                                                  END;
                                                              END;

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Salgskode;
                                                              ENU=Sales Code] }
    { 3   ;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Valutakode;
                                                              ENU=Currency Code] }
    { 4   ;   ;Starting Date       ;Date          ;OnValidate=BEGIN
                                                                IF ("Starting Date" > "Ending Date") AND ("Ending Date" <> 0D) THEN
                                                                  ERROR(EndDateErr,FIELDCAPTION("Starting Date"),FIELDCAPTION("Ending Date"));
                                                              END;

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Startdato;
                                                              ENU=Starting Date] }
    { 5   ;   ;Line Discount %     ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Linjerabatpct.;
                                                              ENU=Line Discount %];
                                                   MinValue=0;
                                                   MaxValue=100;
                                                   AutoFormatType=2 }
    { 6   ;   ;Unit Price          ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Enhedspris;
                                                              ENU=Unit Price];
                                                   MinValue=0;
                                                   AutoFormatType=2;
                                                   AutoFormatExpr="Currency Code" }
    { 7   ;   ;Price Includes VAT  ;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Salgspris inkl. moms;
                                                              ENU=Price Includes VAT] }
    { 10  ;   ;Allow Invoice Disc. ;Boolean       ;InitValue=Yes;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Tillad fakturarabat;
                                                              ENU=Allow Invoice Disc.] }
    { 11  ;   ;VAT Bus. Posting Gr. (Price);Code20;TableRelation="VAT Business Posting Group";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Momsvirks.bogf.gruppe (pris);
                                                              ENU=VAT Bus. Posting Gr. (Price)] }
    { 13  ;   ;Sales Type          ;Option        ;OnValidate=BEGIN
                                                                CASE "Sales Type" OF
                                                                  "Sales Type"::Customer:
                                                                    VALIDATE("Sales Code","Loaded Customer No.");
                                                                  "Sales Type"::"All Customers":
                                                                    VALIDATE("Sales Code",'');
                                                                  "Sales Type"::"Customer Price/Disc. Group":
                                                                    IF "Loaded Customer No." = '' THEN
                                                                      VALIDATE("Sales Code",'')
                                                                    ELSE BEGIN
                                                                      IF "Line Type" = "Line Type"::"Sales Price" THEN BEGIN
                                                                        IF "Loaded Price Group" = '' THEN
                                                                          ERROR(CustNotInPriceGrErr);
                                                                        VALIDATE("Sales Code","Loaded Price Group");
                                                                      END;

                                                                      IF "Line Type" = "Line Type"::"Sales Line Discount" THEN BEGIN
                                                                        IF "Loaded Disc. Group" = '' THEN
                                                                          ERROR(CustNotInDiscGrErr);
                                                                        VALIDATE("Sales Code","Loaded Disc. Group");
                                                                      END;
                                                                    END;
                                                                END;

                                                                UpdateValuesFromItem;
                                                              END;

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Salgstype;
                                                              ENU=Sales Type];
                                                   OptionCaptionML=[DAN=Debitor,Debitorprisgruppe/Rabatgruppe,Alle debitorer,Kampagne;
                                                                    ENU=Customer,Customer Price/Disc. Group,All Customers,Campaign];
                                                   OptionString=Customer,Customer Price/Disc. Group,All Customers,Campaign }
    { 14  ;   ;Minimum Quantity    ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Min. antal;
                                                              ENU=Minimum Quantity];
                                                   MinValue=0 }
    { 15  ;   ;Ending Date         ;Date          ;OnValidate=BEGIN
                                                                VALIDATE("Starting Date");
                                                              END;

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Slutdato;
                                                              ENU=Ending Date] }
    { 21  ;   ;Type                ;Option        ;OnValidate=BEGIN
                                                                CASE Type OF
                                                                  Type::Item:
                                                                    VALIDATE(Code,"Loaded Item No.");
                                                                  Type::"Item Disc. Group":
                                                                    BEGIN
                                                                      VALIDATE(Code,'');
                                                                      IF "Loaded Item No." <> '' THEN BEGIN
                                                                        IF "Loaded Disc. Group" = '' THEN
                                                                          ERROR(ItemNotInDiscGrErr);

                                                                        TESTFIELD("Line Type","Line Type"::"Sales Line Discount");
                                                                        VALIDATE(Code,"Loaded Disc. Group");
                                                                      END;
                                                                    END;
                                                                END;
                                                              END;

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=Vare,Varerabatgruppe;
                                                                    ENU=Item,Item Disc. Group];
                                                   OptionString=Item,Item Disc. Group }
    { 1300;   ;Line Type           ;Option        ;OnValidate=BEGIN
                                                                TESTFIELD("Line Type");
                                                                CASE "Line Type" OF
                                                                  "Line Type"::"Sales Price":
                                                                    BEGIN
                                                                      TESTFIELD(Type,Type::Item);
                                                                      "Line Discount %" := 0;
                                                                    END;
                                                                  "Line Type"::"Sales Line Discount":
                                                                    "Unit Price" := 0;
                                                                END;
                                                                VALIDATE("Sales Type","Sales Type");
                                                                VALIDATE(Type,Type);
                                                              END;

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Linjetype;
                                                              ENU=Line Type];
                                                   OptionCaptionML=[DAN=" ,Salgslinjerabat,Salgspris";
                                                                    ENU=" ,Sales Line Discount,Sales Price"];
                                                   OptionString=[ ,Sales Line Discount,Sales Price] }
    { 1301;   ;Loaded Item No.     ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Indl�st varenummer;
                                                              ENU=Loaded Item No.];
                                                   Editable=No }
    { 1302;   ;Loaded Disc. Group  ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Indl�st rabatgruppe;
                                                              ENU=Loaded Disc. Group];
                                                   Editable=No }
    { 1303;   ;Loaded Customer No. ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Indl�st debitornummer;
                                                              ENU=Loaded Customer No.];
                                                   Editable=No }
    { 1304;   ;Loaded Price Group  ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Indl�st prisgruppe;
                                                              ENU=Loaded Price Group];
                                                   Editable=No }
    { 5400;   ;Unit of Measure Code;Code10        ;TableRelation=IF (Type=CONST(Item)) "Item Unit of Measure".Code WHERE (Item No.=FIELD(Code));
                                                   OnValidate=BEGIN
                                                                TESTFIELD(Type,Type::Item);
                                                              END;

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Enhedskode;
                                                              ENU=Unit of Measure Code] }
    { 5700;   ;Variant Code        ;Code10        ;TableRelation=IF (Type=CONST(Item)) "Item Variant".Code WHERE (Item No.=FIELD(Code));
                                                   OnValidate=BEGIN
                                                                TESTFIELD(Type,Type::Item);
                                                              END;

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Variantkode;
                                                              ENU=Variant Code] }
    { 7001;   ;Allow Line Disc.    ;Boolean       ;InitValue=Yes;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Tillad linjerabat;
                                                              ENU=Allow Line Disc.] }
  }
  KEYS
  {
    {    ;Line Type,Type,Code,Sales Type,Sales Code,Starting Date,Currency Code,Variant Code,Unit of Measure Code,Minimum Quantity,Loaded Item No.,Loaded Disc. Group,Loaded Customer No.,Loaded Price Group;
                                                   Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      EndDateErr@1000 : TextConst 'DAN=%1 m� ikke v�re efter %2.;ENU=%1 cannot be after %2.';
      MustBeBlankErr@1003 : TextConst 'DAN=%1 skal v�re tom.;ENU=%1 must be blank.';
      CustNotInPriceGrErr@1004 : TextConst 'DAN=Da denne debitor ikke er tildelt nogen prisgruppe, kan en prisgruppe ikke bruges i forbindelse med denne debitor.;ENU=This customer is not assigned to any price group, therefore a price group could not be used in context of this customer.';
      CustNotInDiscGrErr@1001 : TextConst 'DAN=Da denne debitor ikke er tildelt nogen rabatgruppe, kan en rabatgruppe ikke bruges i forbindelse med denne debitor.;ENU=This customer is not assigned to any discount group, therefore a discount group could not be used in context of this customer.';
      ItemNotInDiscGrErr@1002 : TextConst 'DAN=Da denne vare er ikke tildelt nogen rabatgruppe, kan en rabatgruppe ikke bruges i forbindelse med denne vare.;ENU=This item is not assigned to any discount group, therefore a discount group could not be used in context of this item.';
      IncludeVATQst@1006 : TextConst 'DAN=En eller flere af salgspriserne er uden moms.\Vil du opdatere alle salgspriser, s� de er med moms?;ENU=One or more of the sales prices do not include VAT.\Do you want to update all sales prices to include VAT?';
      ExcludeVATQst@1007 : TextConst 'DAN=En eller flere af salgspriserne er med moms.\Vil du opdatere alle salgspriser, s� de er uden moms?;ENU=One or more of the sales prices include VAT.\Do you want to update all sales prices to exclude VAT?';

    LOCAL PROCEDURE UpdateValuesFromItem@1();
    VAR
      Item@1000 : Record 27;
    BEGIN
      IF "Line Type" <> "Line Type"::"Sales Price" THEN
        EXIT;

      IF Item.GET(Code) THEN BEGIN
        "Allow Invoice Disc." := Item."Allow Invoice Disc.";
        IF "Sales Type" = "Sales Type"::"All Customers" THEN BEGIN
          "Price Includes VAT" := Item."Price Includes VAT";
          "VAT Bus. Posting Gr. (Price)" := Item."VAT Bus. Posting Gr. (Price)";
        END;
      END;
    END;

    [External]
    PROCEDURE LoadDataForItem@7(Item@1000 : Record 27);
    VAR
      SalesPrice@1002 : Record 7002;
      SalesLineDiscountItem@1001 : Record 7004;
      SalesLineDiscountItemGroup@1003 : Record 7004;
    BEGIN
      RESET;
      DELETEALL;

      "Loaded Item No." := Item."No.";
      "Loaded Disc. Group" := Item."Item Disc. Group";

      SetFiltersOnSalesPrice(SalesPrice);
      LoadSalesPrice(SalesPrice);

      SetFiltersOnSalesLineDiscountItem(SalesLineDiscountItem);
      LoadSalesLineDiscount(SalesLineDiscountItem);

      SetFiltersOnSalesLineDiscountItemGroup(SalesLineDiscountItemGroup);
      LoadSalesLineDiscount(SalesLineDiscountItemGroup);

      IF FINDFIRST THEN;
    END;

    [External]
    PROCEDURE LoadDataForCustomer@2(Customer@1000 : Record 18);
    BEGIN
      RESET;
      DELETEALL;

      "Loaded Customer No." := Customer."No.";
      "Loaded Disc. Group" := Customer."Customer Disc. Group";
      "Loaded Price Group" := Customer."Customer Price Group";

      LoadSalesPriceForCustomer;
      LoadSalesPriceForAllCustomers;
      LoadSalesPriceForCustPriceGr;

      LoadSalesLineDiscForCustomer;
      LoadSalesLineDiscForAllCustomers;
      LoadSalesLineDiscForCustDiscGr;

      GetCustomerCampaignSalesPrice;
    END;

    LOCAL PROCEDURE LoadSalesLineDiscForCustomer@20();
    VAR
      SalesLineDiscount@1000 : Record 7004;
    BEGIN
      SetFiltersForSalesLineDiscForCustomer(SalesLineDiscount);
      LoadSalesLineDiscount(SalesLineDiscount);
    END;

    LOCAL PROCEDURE LoadSalesLineDiscForAllCustomers@17();
    VAR
      SalesLineDiscount@1000 : Record 7004;
    BEGIN
      SetFiltersForSalesLineDiscForAllCustomers(SalesLineDiscount);
      LoadSalesLineDiscount(SalesLineDiscount);
    END;

    LOCAL PROCEDURE LoadSalesLineDiscForCustDiscGr@15();
    VAR
      SalesLineDiscount@1000 : Record 7004;
    BEGIN
      SetFiltersForSalesLineDiscForCustDiscGr(SalesLineDiscount);
      LoadSalesLineDiscount(SalesLineDiscount);
    END;

    LOCAL PROCEDURE LoadSalesPriceForCustomer@21();
    VAR
      SalesPrice@1000 : Record 7002;
    BEGIN
      SetFiltersForSalesPriceForCustomer(SalesPrice);
      LoadSalesPrice(SalesPrice);
    END;

    LOCAL PROCEDURE LoadSalesPriceForAllCustomers@23();
    VAR
      SalesPrice@1000 : Record 7002;
    BEGIN
      SetFiltersForSalesPriceForAllCustomers(SalesPrice);
      LoadSalesPrice(SalesPrice);
    END;

    LOCAL PROCEDURE LoadSalesPriceForCustPriceGr@24();
    VAR
      SalesPrice@1000 : Record 7002;
    BEGIN
      SetFiltersForSalesPriceForCustPriceGr(SalesPrice);
      LoadSalesPrice(SalesPrice);
    END;

    LOCAL PROCEDURE SetFiltersForSalesLineDiscForCustomer@34(VAR SalesLineDiscount@1000 : Record 7004);
    BEGIN
      SalesLineDiscount.SETRANGE("Sales Type","Sales Type"::Customer);
      SalesLineDiscount.SETRANGE("Sales Code","Loaded Customer No.");
    END;

    LOCAL PROCEDURE SetFiltersForSalesLineDiscForAllCustomers@33(VAR SalesLineDiscount@1000 : Record 7004);
    BEGIN
      SalesLineDiscount.SETRANGE("Sales Type","Sales Type"::"All Customers");
    END;

    LOCAL PROCEDURE SetFiltersForSalesLineDiscForCustDiscGr@32(VAR SalesLineDiscount@1001 : Record 7004);
    BEGIN
      SalesLineDiscount.SETRANGE("Sales Code","Loaded Disc. Group");
      SalesLineDiscount.SETRANGE("Sales Type","Sales Type"::"Customer Price/Disc. Group");
    END;

    LOCAL PROCEDURE SetFiltersForSalesPriceForCustomer@31(VAR SalesPrice@1000 : Record 7002);
    BEGIN
      SalesPrice.SETRANGE("Sales Type","Sales Type"::Customer);
      SalesPrice.SETRANGE("Sales Code","Loaded Customer No.");
    END;

    LOCAL PROCEDURE SetFiltersForSalesPriceForAllCustomers@30(VAR SalesPrice@1001 : Record 7002);
    BEGIN
      SalesPrice.SETRANGE("Sales Type","Sales Type"::"All Customers");
    END;

    LOCAL PROCEDURE SetFiltersForSalesPriceForCustPriceGr@29(VAR SalesPrice@1001 : Record 7002);
    BEGIN
      SalesPrice.SETRANGE("Sales Code","Loaded Price Group");
      SalesPrice.SETRANGE("Sales Type","Sales Type"::"Customer Price/Disc. Group");
    END;

    LOCAL PROCEDURE LoadSalesLineDiscount@4(VAR SalesLineDiscount@1000 : Record 7004);
    BEGIN
      IF SalesLineDiscount.FINDSET THEN
        REPEAT
          INIT;
          "Line Type" := "Line Type"::"Sales Line Discount";

          Code := SalesLineDiscount.Code;
          Type := SalesLineDiscount.Type;
          "Sales Code" := SalesLineDiscount."Sales Code";
          "Sales Type" := SalesLineDiscount."Sales Type";

          "Starting Date" := SalesLineDiscount."Starting Date";
          "Minimum Quantity" := SalesLineDiscount."Minimum Quantity";
          "Unit of Measure Code" := SalesLineDiscount."Unit of Measure Code";

          "Line Discount %" := SalesLineDiscount."Line Discount %";
          "Currency Code" := SalesLineDiscount."Currency Code";
          "Ending Date" := SalesLineDiscount."Ending Date";
          "Variant Code" := SalesLineDiscount."Variant Code";

          INSERT;
        UNTIL SalesLineDiscount.NEXT = 0;
    END;

    LOCAL PROCEDURE LoadSalesPrice@5(VAR SalesPrice@1000 : Record 7002);
    BEGIN
      IF SalesPrice.FINDSET THEN
        REPEAT
          INIT;
          "Line Type" := "Line Type"::"Sales Price";

          Code := SalesPrice."Item No.";
          Type := Type::Item;
          "Sales Code" := SalesPrice."Sales Code";
          "Sales Type" := SalesPrice."Sales Type";

          "Starting Date" := SalesPrice."Starting Date";
          "Minimum Quantity" := SalesPrice."Minimum Quantity";
          "Unit of Measure Code" := SalesPrice."Unit of Measure Code";
          "Unit Price" := SalesPrice."Unit Price";
          "Currency Code" := SalesPrice."Currency Code";
          "Ending Date" := SalesPrice."Ending Date";
          "Variant Code" := SalesPrice."Variant Code";

          "Price Includes VAT" := SalesPrice."Price Includes VAT";
          "VAT Bus. Posting Gr. (Price)" := SalesPrice."VAT Bus. Posting Gr. (Price)";

          "Allow Invoice Disc." := SalesPrice."Allow Invoice Disc.";
          "Allow Line Disc." := SalesPrice."Allow Line Disc.";
          INSERT;
        UNTIL SalesPrice.NEXT = 0;
    END;

    LOCAL PROCEDURE InsertNewPriceLine@14();
    VAR
      SalesPrice@1001 : Record 7002;
    BEGIN
      SalesPrice.INIT;

      SalesPrice."Item No." := Code;
      SalesPrice."Sales Code" := "Sales Code";
      SalesPrice."Sales Type" := "Sales Type";
      SalesPrice."Starting Date" := "Starting Date";
      SalesPrice."Minimum Quantity" := "Minimum Quantity";
      SalesPrice."Unit of Measure Code" := "Unit of Measure Code";
      SalesPrice."Unit Price" := "Unit Price";
      SalesPrice."Currency Code" := "Currency Code";
      SalesPrice."Ending Date" := "Ending Date";
      SalesPrice."Variant Code" := "Variant Code";

      SalesPrice."Allow Invoice Disc." := "Allow Invoice Disc.";
      SalesPrice."Allow Line Disc." := "Allow Line Disc.";
      SalesPrice."VAT Bus. Posting Gr. (Price)" := "VAT Bus. Posting Gr. (Price)";
      SalesPrice."Price Includes VAT" := "Price Includes VAT";

      SalesPrice.INSERT(TRUE);
    END;

    LOCAL PROCEDURE InsertNewDiscountLine@13();
    VAR
      SalesLineDiscount@1000 : Record 7004;
    BEGIN
      SalesLineDiscount.INIT;

      SalesLineDiscount.Code := Code;
      SalesLineDiscount.Type := Type;
      SalesLineDiscount."Sales Code" := "Sales Code";
      SalesLineDiscount."Sales Type" := "Sales Type";
      SalesLineDiscount."Starting Date" := "Starting Date";
      SalesLineDiscount."Minimum Quantity" := "Minimum Quantity";
      SalesLineDiscount."Unit of Measure Code" := "Unit of Measure Code";
      SalesLineDiscount."Line Discount %" := "Line Discount %";
      SalesLineDiscount."Currency Code" := "Currency Code";
      SalesLineDiscount."Ending Date" := "Ending Date";
      SalesLineDiscount."Variant Code" := "Variant Code";
      SalesLineDiscount.INSERT(TRUE);
    END;

    LOCAL PROCEDURE SetFiltersOnSalesPrice@8(VAR SalesPrice@1000 : Record 7002);
    BEGIN
      SalesPrice.SETRANGE("Item No.","Loaded Item No.");
      SalesPrice.SETFILTER("Sales Type",'<> %1',SalesPrice."Sales Type"::Campaign);
    END;

    LOCAL PROCEDURE SetFiltersOnSalesLineDiscountItem@9(VAR SalesLineDiscount@1000 : Record 7004);
    BEGIN
      SalesLineDiscount.SETRANGE(Type,SalesLineDiscount.Type::Item);
      SalesLineDiscount.SETRANGE(Code,"Loaded Item No.");
      SalesLineDiscount.SETFILTER("Sales Type",'<> %1',SalesLineDiscount."Sales Type"::Campaign);
    END;

    LOCAL PROCEDURE SetFiltersOnSalesLineDiscountItemGroup@11(VAR SalesLineDiscount@1000 : Record 7004);
    BEGIN
      SalesLineDiscount.SETRANGE(Type,SalesLineDiscount.Type::"Item Disc. Group");
      SalesLineDiscount.SETRANGE(Code,"Loaded Disc. Group");
      SalesLineDiscount.SETFILTER("Sales Type",'<> %1',SalesLineDiscount."Sales Type"::Campaign);
    END;

    [External]
    PROCEDURE FilterToActualRecords@10();
    BEGIN
      SETFILTER("Ending Date",'%1|%2..',0D,TODAY)
    END;

    LOCAL PROCEDURE DeleteOldRecordVersion@12();
    BEGIN
      TESTFIELD("Line Type");
      IF xRec."Line Type" = xRec."Line Type"::"Sales Line Discount" THEN
        DeleteOldRecordVersionFromDiscounts
      ELSE
        DeleteOldRecordVersionFromPrices;
    END;

    LOCAL PROCEDURE DeleteOldRecordVersionFromDiscounts@18();
    VAR
      SalesLineDiscount@1000 : Record 7004;
    BEGIN
      SalesLineDiscount.GET(
        xRec.Type,
        xRec.Code,
        xRec."Sales Type",
        xRec."Sales Code",
        xRec."Starting Date",
        xRec."Currency Code",
        xRec."Variant Code",
        xRec."Unit of Measure Code",
        xRec."Minimum Quantity");

      SalesLineDiscount.DELETE(TRUE);
    END;

    LOCAL PROCEDURE DeleteOldRecordVersionFromPrices@19();
    VAR
      SalesPrice@1000 : Record 7002;
    BEGIN
      SalesPrice.GET(
        xRec.Code,
        xRec."Sales Type",
        xRec."Sales Code",
        xRec."Starting Date",
        xRec."Currency Code",
        xRec."Variant Code",
        xRec."Unit of Measure Code",
        xRec."Minimum Quantity");

      SalesPrice.DELETE(TRUE);
    END;

    LOCAL PROCEDURE InsertNewRecordVersion@16();
    BEGIN
      TESTFIELD("Line Type");
      IF "Line Type" = "Line Type"::"Sales Line Discount" THEN
        InsertNewDiscountLine
      ELSE
        InsertNewPriceLine
    END;

    [External]
    PROCEDURE CustHasLines@25(Cust@1000 : Record 18) : Boolean;
    VAR
      SalesLineDiscount@1001 : Record 7004;
      SalesPrice@1002 : Record 7002;
    BEGIN
      RESET;

      "Loaded Customer No." := Cust."No.";
      "Loaded Disc. Group" := Cust."Customer Disc. Group";
      "Loaded Price Group" := Cust."Customer Price Group";

      SetFiltersForSalesLineDiscForAllCustomers(SalesLineDiscount);
      IF SalesLineDiscount.COUNT > 0 THEN
        EXIT(TRUE);
      CLEAR(SalesLineDiscount);

      SetFiltersForSalesPriceForAllCustomers(SalesPrice);
      IF SalesPrice.COUNT > 0 THEN
        EXIT(TRUE);
      CLEAR(SalesPrice);

      SetFiltersForSalesLineDiscForCustDiscGr(SalesLineDiscount);
      IF SalesLineDiscount.COUNT > 0 THEN
        EXIT(TRUE);
      CLEAR(SalesLineDiscount);

      SetFiltersForSalesPriceForCustPriceGr(SalesPrice);
      IF SalesPrice.COUNT > 0 THEN
        EXIT(TRUE);
      CLEAR(SalesPrice);

      SetFiltersForSalesLineDiscForCustomer(SalesLineDiscount);
      IF SalesLineDiscount.COUNT > 0 THEN
        EXIT(TRUE);
      CLEAR(SalesLineDiscount);

      SetFiltersForSalesPriceForCustomer(SalesPrice);
      IF SalesPrice.COUNT > 0 THEN
        EXIT(TRUE);

      EXIT(FALSE);
    END;

    [External]
    PROCEDURE ItemHasLines@26(Item@1000 : Record 27) : Boolean;
    VAR
      SalesLineDiscount@1001 : Record 7004;
      SalesPrice@1002 : Record 7002;
    BEGIN
      RESET;

      "Loaded Item No." := Item."No.";
      "Loaded Disc. Group" := Item."Item Disc. Group";

      SetFiltersOnSalesPrice(SalesPrice);
      IF NOT SalesPrice.ISEMPTY THEN
        EXIT(TRUE);

      SetFiltersOnSalesLineDiscountItem(SalesLineDiscount);
      IF NOT SalesLineDiscount.ISEMPTY THEN
        EXIT(TRUE);
      CLEAR(SalesLineDiscount);

      SetFiltersOnSalesLineDiscountItemGroup(SalesLineDiscount);
      IF NOT SalesLineDiscount.ISEMPTY THEN
        EXIT(TRUE);

      EXIT(FALSE);
    END;

    [External]
    PROCEDURE UpdatePriceIncludesVatAndPrices@6(Item@1002 : Record 27;IncludesVat@1000 : Boolean);
    VAR
      VATPostingSetup@1001 : Record 325;
      MsgQst@1003 : Text;
    BEGIN
      SETRANGE("Price Includes VAT",NOT IncludesVat);
      SETRANGE("Line Type","Line Type"::"Sales Price");
      SETRANGE(Type,Type::Item);
      SETFILTER("Unit Price",'>0');

      IF NOT FINDSET THEN
        EXIT;

      IF IncludesVat THEN
        MsgQst := IncludeVATQst
      ELSE
        MsgQst := ExcludeVATQst;

      IF NOT CONFIRM(MsgQst,FALSE) THEN
        EXIT;

      REPEAT
        VATPostingSetup.GET("VAT Bus. Posting Gr. (Price)",Item."VAT Prod. Posting Group");

        "Price Includes VAT" := IncludesVat;

        IF IncludesVat THEN
          "Unit Price" := "Unit Price" * (100 + VATPostingSetup."VAT %") / 100
        ELSE
          "Unit Price" := "Unit Price" * 100 / (100 + VATPostingSetup."VAT %");

        MODIFY(TRUE);
      UNTIL NEXT = 0;
    END;

    LOCAL PROCEDURE GetCustomerCampaignSalesPrice@3();
    VAR
      ContactBusinessRelation@1000 : Record 5054;
      SalesPrice@1003 : Record 7002;
      TempCampaign@1002 : TEMPORARY Record 5071;
    BEGIN
      ContactBusinessRelation.FindByRelation(ContactBusinessRelation."Link to Table"::Customer,"Loaded Customer No.");
      GetContactCampaigns(TempCampaign,ContactBusinessRelation."Contact No.");

      TempCampaign.SETAUTOCALCFIELDS(Activated);
      IF TempCampaign.FINDSET THEN
        REPEAT
          IF TempCampaign.Activated THEN BEGIN
            SalesPrice.SETRANGE("Sales Type",SalesPrice."Sales Type"::Campaign);
            SalesPrice.SETRANGE("Sales Code",TempCampaign."No.");
            LoadSalesPrice(SalesPrice);
          END;
        UNTIL TempCampaign.NEXT = 0;
    END;

    LOCAL PROCEDURE GetContactCampaigns@27(VAR TempCampaign@1001 : TEMPORARY Record 5071;CompanyContactNo@1000 : Code[20]);
    VAR
      Contact@1002 : Record 5050;
      SegmentLine@1003 : Record 5077;
    BEGIN
      Contact.SETRANGE("Company No.",CompanyContactNo);
      IF Contact.FINDSET THEN BEGIN
        SegmentLine.SETFILTER("Campaign No.",'<>%1','');
        SegmentLine.SETRANGE("Campaign Target",TRUE);
        REPEAT
          SegmentLine.SETRANGE("Contact No.",Contact."No.");
          InsertTempCampaignFromSegmentLines(TempCampaign,SegmentLine);
        UNTIL Contact.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE InsertTempCampaignFromSegmentLines@48(VAR TempCampaign@1000 : TEMPORARY Record 5071;SegmentLine@1001 : Record 5077);
    BEGIN
      IF SegmentLine.FINDSET THEN
        REPEAT
          TempCampaign.INIT;
          TempCampaign."No." := SegmentLine."Campaign No.";
          IF TempCampaign.INSERT THEN;
        UNTIL SegmentLine.NEXT = 0;
    END;

    BEGIN
    END.
  }
}

