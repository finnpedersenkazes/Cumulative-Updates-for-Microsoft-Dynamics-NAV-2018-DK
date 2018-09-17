OBJECT Table 5356 CRM Invoicedetail
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    TableType=CRM;
    ExternalName=invoicedetail;
    CaptionML=[DAN=CRM Invoicedetail;
               ENU=CRM Invoicedetail];
    Description=Line item in an invoice containing detailed billing information for a product.;
  }
  FIELDS
  {
    { 1   ;   ;InvoiceDetailId     ;GUID          ;ExternalName=invoicedetailid;
                                                   ExternalType=Uniqueidentifier;
                                                   ExternalAccess=Insert;
                                                   CaptionML=[DAN=Invoice Product;
                                                              ENU=Invoice Product];
                                                   Description=Unique identifier of the invoice product line item. }
    { 2   ;   ;SalesRepId          ;GUID          ;TableRelation="CRM Systemuser".SystemUserId;
                                                   ExternalName=salesrepid;
                                                   ExternalType=Lookup;
                                                   CaptionML=[DAN=Salesperson;
                                                              ENU=Salesperson];
                                                   Description=Choose the user responsible for the sale of the invoice product. }
    { 3   ;   ;IsProductOverridden ;Boolean       ;ExternalName=isproductoverridden;
                                                   ExternalType=Boolean;
                                                   ExternalAccess=Insert;
                                                   CaptionML=[DAN=Select Product;
                                                              ENU=Select Product];
                                                   Description=Select whether the product exists in the Microsoft Dynamics CRM product catalog or is a write-in product specific to the parent invoice. }
    { 4   ;   ;LineItemNumber      ;Integer       ;ExternalName=lineitemnumber;
                                                   ExternalType=Integer;
                                                   CaptionML=[DAN=Line Item Number;
                                                              ENU=Line Item Number];
                                                   MinValue=0;
                                                   MaxValue=1000000000;
                                                   Description=Type the line item number for the invoice product to easily identify the product in the invoice and make sure it's listed in the correct order. }
    { 5   ;   ;IsCopied            ;Boolean       ;ExternalName=iscopied;
                                                   ExternalType=Boolean;
                                                   CaptionML=[DAN=Copied;
                                                              ENU=Copied];
                                                   Description=Select whether the invoice product is copied from another item or data source. }
    { 6   ;   ;InvoiceId           ;GUID          ;TableRelation="CRM Invoice".InvoiceId;
                                                   ExternalName=invoiceid;
                                                   ExternalType=Lookup;
                                                   CaptionML=[DAN=Invoice ID;
                                                              ENU=Invoice ID];
                                                   Description=Unique identifier of the invoice associated with the invoice product line item. }
    { 7   ;   ;QuantityBackordered ;Decimal       ;ExternalName=quantitybackordered;
                                                   ExternalType=Decimal;
                                                   CaptionML=[DAN=Quantity Back Ordered;
                                                              ENU=Quantity Back Ordered];
                                                   Description=Type the amount or quantity of the product that is back ordered for the invoice. }
    { 8   ;   ;UoMId               ;GUID          ;TableRelation="CRM Uom".UoMId;
                                                   ExternalName=uomid;
                                                   ExternalType=Lookup;
                                                   CaptionML=[DAN=Unit;
                                                              ENU=Unit];
                                                   Description=Choose the unit of measurement for the base unit quantity for this purchase, such as each or dozen. }
    { 9   ;   ;ProductId           ;GUID          ;TableRelation="CRM Product".ProductId;
                                                   ExternalName=productid;
                                                   ExternalType=Lookup;
                                                   CaptionML=[DAN=Existing Product;
                                                              ENU=Existing Product];
                                                   Description=Choose the product to include on the invoice. }
    { 10  ;   ;ActualDeliveryOn    ;Date          ;ExternalName=actualdeliveryon;
                                                   ExternalType=DateTime;
                                                   CaptionML=[DAN=Delivered On;
                                                              ENU=Delivered On];
                                                   Description=Enter the date when the invoiced product was delivered to the customer. }
    { 11  ;   ;Quantity            ;Decimal       ;ExternalName=quantity;
                                                   ExternalType=Decimal;
                                                   CaptionML=[DAN=Quantity;
                                                              ENU=Quantity];
                                                   Description=Type the amount or quantity of the product included in the invoice's total amount due. }
    { 12  ;   ;ManualDiscountAmount;Decimal       ;ExternalName=manualdiscountamount;
                                                   ExternalType=Money;
                                                   CaptionML=[DAN=Manual Discount;
                                                              ENU=Manual Discount];
                                                   Description=Type the manual discount amount for the invoice product to deduct any negotiated or other savings from the product total. }
    { 13  ;   ;ProductDescription  ;Text250       ;ExternalName=productdescription;
                                                   ExternalType=String;
                                                   CaptionML=[DAN=Write-In Product;
                                                              ENU=Write-In Product];
                                                   Description=Type a name or description to identify the type of write-in product included in the invoice. }
    { 14  ;   ;VolumeDiscountAmount;Decimal       ;ExternalName=volumediscountamount;
                                                   ExternalType=Money;
                                                   ExternalAccess=Read;
                                                   CaptionML=[DAN=Volume Discount;
                                                              ENU=Volume Discount];
                                                   Description=Shows the discount amount per unit if a specified volume is purchased. Configure volume discounts in the Product Catalog in the Settings area. }
    { 15  ;   ;PricePerUnit        ;Decimal       ;ExternalName=priceperunit;
                                                   ExternalType=Money;
                                                   CaptionML=[DAN=Price Per Unit;
                                                              ENU=Price Per Unit];
                                                   Description=Type the price per unit of the invoice product. The default is the value in the price list specified on the parent invoice for existing products. }
    { 16  ;   ;BaseAmount          ;Decimal       ;ExternalName=baseamount;
                                                   ExternalType=Money;
                                                   ExternalAccess=Modify;
                                                   CaptionML=[DAN=Amount;
                                                              ENU=Amount];
                                                   Description=Shows the total price of the invoice product, based on the price per unit, volume discount, and quantity. }
    { 17  ;   ;QuantityCancelled   ;Decimal       ;ExternalName=quantitycancelled;
                                                   ExternalType=Decimal;
                                                   CaptionML=[DAN=Quantity Canceled;
                                                              ENU=Quantity Canceled];
                                                   Description=Type the amount or quantity of the product that was canceled for the invoice line item. }
    { 18  ;   ;ShippingTrackingNumber;Text100     ;ExternalName=shippingtrackingnumber;
                                                   ExternalType=String;
                                                   CaptionML=[DAN=Shipment Tracking Number;
                                                              ENU=Shipment Tracking Number];
                                                   Description=Type a tracking number for shipment of the invoiced product. }
    { 19  ;   ;ExtendedAmount      ;Decimal       ;ExternalName=extendedamount;
                                                   ExternalType=Money;
                                                   ExternalAccess=Modify;
                                                   CaptionML=[DAN=Extended Amount;
                                                              ENU=Extended Amount];
                                                   Description=Shows the total amount due for the invoice product, based on the sum of the unit price, quantity, discounts, and tax. }
    { 20  ;   ;Description         ;BLOB          ;ExternalName=description;
                                                   ExternalType=Memo;
                                                   CaptionML=[DAN=Description;
                                                              ENU=Description];
                                                   Description=Type additional information to describe the product line item of the invoice.;
                                                   SubType=Memo }
    { 21  ;   ;IsPriceOverridden   ;Boolean       ;ExternalName=ispriceoverridden;
                                                   ExternalType=Boolean;
                                                   CaptionML=[DAN=Pricing;
                                                              ENU=Pricing];
                                                   Description=Select whether the price per unit is fixed at the value in the specified price list or can be overridden by users who have edit rights to the invoice product. }
    { 22  ;   ;ShipTo_Name         ;Text200       ;ExternalName=shipto_name;
                                                   ExternalType=String;
                                                   CaptionML=[DAN=Ship To Name;
                                                              ENU=Ship To Name];
                                                   Description=Type a name for the customer's shipping address, such as "Headquarters" or "Field office", to identify the address. }
    { 23  ;   ;PricingErrorCode    ;Option        ;InitValue=None;
                                                   ExternalName=pricingerrorcode;
                                                   ExternalType=Picklist;
                                                   OptionOrdinalValues=[0;1;2;3;4;5;6;7;8;9;10;11;12;13;14;15;16;17;18;19;20;21;22;23;24;25;26;27;28;29;30;31;32;33;34;35;36;37];
                                                   CaptionML=[DAN="Pricing Error ";
                                                              ENU="Pricing Error "];
                                                   OptionCaptionML=[DAN=None,Detail Error,Missing Price Level,Inactive Price Level,Missing Quantity,Missing Unit Price,Missing Product,Invalid Product,Missing Pricing Code,Invalid Pricing Code,Missing UOM,Product Not In Price Level,Missing Price Level Amount,Missing Price Level Percentage,Missing Price,Missing Current Cost,Missing Standard Cost,Invalid Price Level Amount,Invalid Price Level Percentage,Invalid Price,Invalid Current Cost,Invalid Standard Cost,Invalid Rounding Policy,Invalid Rounding Option,Invalid Rounding Amount,Price Calculation Error,Invalid Discount Type,Discount Type Invalid State,Invalid Discount,Invalid Quantity,Invalid Pricing Precision,Missing Product Default UOM,Missing Product UOM Schedule ,Inactive Discount Type,Invalid Price Level Currency,Price Attribute Out Of Range,Base Currency Attribute Overflow,Base Currency Attribute Underflow;
                                                                    ENU=None,Detail Error,Missing Price Level,Inactive Price Level,Missing Quantity,Missing Unit Price,Missing Product,Invalid Product,Missing Pricing Code,Invalid Pricing Code,Missing UOM,Product Not In Price Level,Missing Price Level Amount,Missing Price Level Percentage,Missing Price,Missing Current Cost,Missing Standard Cost,Invalid Price Level Amount,Invalid Price Level Percentage,Invalid Price,Invalid Current Cost,Invalid Standard Cost,Invalid Rounding Policy,Invalid Rounding Option,Invalid Rounding Amount,Price Calculation Error,Invalid Discount Type,Discount Type Invalid State,Invalid Discount,Invalid Quantity,Invalid Pricing Precision,Missing Product Default UOM,Missing Product UOM Schedule ,Inactive Discount Type,Invalid Price Level Currency,Price Attribute Out Of Range,Base Currency Attribute Overflow,Base Currency Attribute Underflow];
                                                   OptionString=None,DetailError,MissingPriceLevel,InactivePriceLevel,MissingQuantity,MissingUnitPrice,MissingProduct,InvalidProduct,MissingPricingCode,InvalidPricingCode,MissingUOM,ProductNotInPriceLevel,MissingPriceLevelAmount,MissingPriceLevelPercentage,MissingPrice,MissingCurrentCost,MissingStandardCost,InvalidPriceLevelAmount,InvalidPriceLevelPercentage,InvalidPrice,InvalidCurrentCost,InvalidStandardCost,InvalidRoundingPolicy,InvalidRoundingOption,InvalidRoundingAmount,PriceCalculationError,InvalidDiscountType,DiscountTypeInvalidState,InvalidDiscount,InvalidQuantity,InvalidPricingPrecision,MissingProductDefaultUOM,MissingProductUOMSchedule,InactiveDiscountType,InvalidPriceLevelCurrency,PriceAttributeOutOfRange,BaseCurrencyAttributeOverflow,BaseCurrencyAttributeUnderflow;
                                                   Description=Pricing error for the invoice product line item. }
    { 24  ;   ;Tax                 ;Decimal       ;ExternalName=tax;
                                                   ExternalType=Money;
                                                   CaptionML=[DAN=Tax;
                                                              ENU=Tax];
                                                   Description=Type the tax amount for the invoice product. }
    { 25  ;   ;CreatedOn           ;DateTime      ;ExternalName=createdon;
                                                   ExternalType=DateTime;
                                                   ExternalAccess=Read;
                                                   CaptionML=[DAN=Created On;
                                                              ENU=Created On];
                                                   Description=Shows the date and time when the record was created. The date and time are displayed in the time zone selected in Microsoft Dynamics CRM options. }
    { 26  ;   ;ShipTo_Line1        ;Text250       ;ExternalName=shipto_line1;
                                                   ExternalType=String;
                                                   CaptionML=[DAN=Ship To Street 1;
                                                              ENU=Ship To Street 1];
                                                   Description=Type the first line of the customer's shipping address. }
    { 27  ;   ;CreatedBy           ;GUID          ;TableRelation="CRM Systemuser".SystemUserId;
                                                   ExternalName=createdby;
                                                   ExternalType=Lookup;
                                                   ExternalAccess=Read;
                                                   CaptionML=[DAN=Created By;
                                                              ENU=Created By];
                                                   Description=Shows who created the record. }
    { 28  ;   ;ModifiedBy          ;GUID          ;TableRelation="CRM Systemuser".SystemUserId;
                                                   ExternalName=modifiedby;
                                                   ExternalType=Lookup;
                                                   ExternalAccess=Read;
                                                   CaptionML=[DAN=Modified By;
                                                              ENU=Modified By];
                                                   Description=Shows who last updated the record. }
    { 29  ;   ;ShipTo_Line2        ;Text250       ;ExternalName=shipto_line2;
                                                   ExternalType=String;
                                                   CaptionML=[DAN=Ship To Street 2;
                                                              ENU=Ship To Street 2];
                                                   Description=Type the second line of the customer's shipping address. }
    { 30  ;   ;ShipTo_Line3        ;Text250       ;ExternalName=shipto_line3;
                                                   ExternalType=String;
                                                   CaptionML=[DAN=Ship To Street 3;
                                                              ENU=Ship To Street 3];
                                                   Description=Type the third line of the shipping address. }
    { 31  ;   ;ModifiedOn          ;DateTime      ;ExternalName=modifiedon;
                                                   ExternalType=DateTime;
                                                   ExternalAccess=Read;
                                                   CaptionML=[DAN=Modified On;
                                                              ENU=Modified On];
                                                   Description=Shows the date and time when the record was last updated. The date and time are displayed in the time zone selected in Microsoft Dynamics CRM options. }
    { 32  ;   ;ShipTo_City         ;Text80        ;ExternalName=shipto_city;
                                                   ExternalType=String;
                                                   CaptionML=[DAN=Ship To City;
                                                              ENU=Ship To City];
                                                   Description=Type the city for the customer's shipping address. }
    { 33  ;   ;ShipTo_StateOrProvince;Text50      ;ExternalName=shipto_stateorprovince;
                                                   ExternalType=String;
                                                   CaptionML=[DAN=Ship To State/Province;
                                                              ENU=Ship To State/Province];
                                                   Description=Type the state or province for the shipping address. }
    { 34  ;   ;ShipTo_Country      ;Text80        ;ExternalName=shipto_country;
                                                   ExternalType=String;
                                                   CaptionML=[DAN=Ship To Country/Region;
                                                              ENU=Ship To Country/Region];
                                                   Description=Type the country or region for the customer's shipping address. }
    { 35  ;   ;ShipTo_PostalCode   ;Text20        ;ExternalName=shipto_postalcode;
                                                   ExternalType=String;
                                                   CaptionML=[DAN=Ship To ZIP/Postal Code;
                                                              ENU=Ship To ZIP/Postal Code];
                                                   Description=Type the ZIP Code or postal code for the shipping address. }
    { 36  ;   ;WillCall            ;Boolean       ;ExternalName=willcall;
                                                   ExternalType=Boolean;
                                                   CaptionML=[DAN=Ship To;
                                                              ENU=Ship To];
                                                   Description=Select whether the invoice product should be shipped to the specified address or held until the customer calls with further pick up or delivery instructions. }
    { 37  ;   ;ShipTo_Telephone    ;Text50        ;ExternalName=shipto_telephone;
                                                   ExternalType=String;
                                                   CaptionML=[DAN=Ship To Phone;
                                                              ENU=Ship To Phone];
                                                   Description=Type the phone number for the customer's shipping address. }
    { 38  ;   ;ShipTo_Fax          ;Text50        ;ExternalName=shipto_fax;
                                                   ExternalType=String;
                                                   CaptionML=[DAN=Ship To Fax;
                                                              ENU=Ship To Fax];
                                                   Description=Type the fax number for the customer's shipping address. }
    { 39  ;   ;ShipTo_FreightTermsCode;Option     ;InitValue=[ ];
                                                   ExternalName=shipto_freighttermscode;
                                                   ExternalType=Picklist;
                                                   OptionOrdinalValues=[-1;1;2];
                                                   CaptionML=[DAN=Freight Terms;
                                                              ENU=Freight Terms];
                                                   OptionCaptionML=[DAN=" ,FOB,No Charge";
                                                                    ENU=" ,FOB,No Charge"];
                                                   OptionString=[ ,FOB,NoCharge];
                                                   Description=Select the freight terms to make sure shipping orders are processed correctly. }
    { 40  ;   ;QuantityShipped     ;Decimal       ;ExternalName=quantityshipped;
                                                   ExternalType=Decimal;
                                                   CaptionML=[DAN=Quantity Shipped;
                                                              ENU=Quantity Shipped];
                                                   Description=Type the amount or quantity of the product that was shipped. }
    { 41  ;   ;ProductIdName       ;Text100       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("CRM Product".Name WHERE (ProductId=FIELD(ProductId)));
                                                   ExternalName=productidname;
                                                   ExternalType=String;
                                                   ExternalAccess=Read;
                                                   CaptionML=[DAN=ProductIdName;
                                                              ENU=ProductIdName] }
    { 42  ;   ;UoMIdName           ;Text100       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("CRM Uom".Name WHERE (UoMId=FIELD(UoMId)));
                                                   ExternalName=uomidname;
                                                   ExternalType=String;
                                                   ExternalAccess=Read;
                                                   CaptionML=[DAN=UoMIdName;
                                                              ENU=UoMIdName] }
    { 43  ;   ;SalesRepIdName      ;Text200       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("CRM Systemuser".FullName WHERE (SystemUserId=FIELD(SalesRepId)));
                                                   ExternalName=salesrepidname;
                                                   ExternalType=String;
                                                   ExternalAccess=Read;
                                                   CaptionML=[DAN=SalesRepIdName;
                                                              ENU=SalesRepIdName] }
    { 44  ;   ;InvoiceStateCode    ;Option        ;InitValue=[ ];
                                                   ExternalName=invoicestatecode;
                                                   ExternalType=Picklist;
                                                   ExternalAccess=Read;
                                                   OptionOrdinalValues=-1;
                                                   CaptionML=[DAN=Invoice Status;
                                                              ENU=Invoice Status];
                                                   OptionCaptionML=[DAN=" ";
                                                                    ENU=" "];
                                                   OptionString=[ ];
                                                   Description=Status of the invoice product. }
    { 45  ;   ;CreatedByName       ;Text200       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("CRM Systemuser".FullName WHERE (SystemUserId=FIELD(CreatedBy)));
                                                   ExternalName=createdbyname;
                                                   ExternalType=String;
                                                   ExternalAccess=Read;
                                                   CaptionML=[DAN=CreatedByName;
                                                              ENU=CreatedByName] }
    { 46  ;   ;ModifiedByName      ;Text200       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("CRM Systemuser".FullName WHERE (SystemUserId=FIELD(ModifiedBy)));
                                                   ExternalName=modifiedbyname;
                                                   ExternalType=String;
                                                   ExternalAccess=Read;
                                                   CaptionML=[DAN=ModifiedByName;
                                                              ENU=ModifiedByName] }
    { 47  ;   ;VersionNumber       ;BigInteger    ;ExternalName=versionnumber;
                                                   ExternalType=BigInt;
                                                   ExternalAccess=Read;
                                                   CaptionML=[DAN=Version Number;
                                                              ENU=Version Number];
                                                   Description=Version number of the invoice product line item. }
    { 49  ;   ;InvoiceIsPriceLocked;Boolean       ;ExternalName=invoiceispricelocked;
                                                   ExternalType=Boolean;
                                                   ExternalAccess=Read;
                                                   CaptionML=[DAN=Invoice Is Price Locked;
                                                              ENU=Invoice Is Price Locked];
                                                   Description=Information about whether invoice product pricing is locked. }
    { 51  ;   ;ExchangeRate        ;Decimal       ;ExternalName=exchangerate;
                                                   ExternalType=Decimal;
                                                   ExternalAccess=Read;
                                                   CaptionML=[DAN=Exchange Rate;
                                                              ENU=Exchange Rate];
                                                   Description=Shows the conversion rate of the record's currency. The exchange rate is used to convert all money fields in the record from the local currency to the system's default currency. }
    { 52  ;   ;TransactionCurrencyId;GUID         ;TableRelation="CRM Transactioncurrency".TransactionCurrencyId;
                                                   ExternalName=transactioncurrencyid;
                                                   ExternalType=Lookup;
                                                   ExternalAccess=Read;
                                                   CaptionML=[DAN=Currency;
                                                              ENU=Currency];
                                                   Description=Choose the local currency for the record to make sure budgets are reported in the correct currency. }
    { 53  ;   ;UTCConversionTimeZoneCode;Integer  ;ExternalName=utcconversiontimezonecode;
                                                   ExternalType=Integer;
                                                   CaptionML=[DAN=UTC Conversion Time Zone Code;
                                                              ENU=UTC Conversion Time Zone Code];
                                                   MinValue=-1;
                                                   Description=Time zone code that was in use when the record was created. }
    { 54  ;   ;TimeZoneRuleVersionNumber;Integer  ;ExternalName=timezoneruleversionnumber;
                                                   ExternalType=Integer;
                                                   CaptionML=[DAN=Time Zone Rule Version Number;
                                                              ENU=Time Zone Rule Version Number];
                                                   MinValue=-1;
                                                   Description=For internal use only. }
    { 55  ;   ;ImportSequenceNumber;Integer       ;ExternalName=importsequencenumber;
                                                   ExternalType=Integer;
                                                   ExternalAccess=Insert;
                                                   CaptionML=[DAN=Import Sequence Number;
                                                              ENU=Import Sequence Number];
                                                   Description=Unique identifier of the data import or data migration that created this record. }
    { 56  ;   ;OverriddenCreatedOn ;Date          ;ExternalName=overriddencreatedon;
                                                   ExternalType=DateTime;
                                                   ExternalAccess=Insert;
                                                   CaptionML=[DAN=Record Created On;
                                                              ENU=Record Created On];
                                                   Description=Date and time that the record was migrated. }
    { 57  ;   ;VolumeDiscountAmount_Base;Decimal  ;ExternalName=volumediscountamount_base;
                                                   ExternalType=Money;
                                                   ExternalAccess=Read;
                                                   CaptionML=[DAN=Volume Discount (Base);
                                                              ENU=Volume Discount (Base)];
                                                   Description=Shows the Volume Discount field converted to the system's default base currency for reporting purposes. The calculation uses the exchange rate specified in the Currencies area. }
    { 58  ;   ;BaseAmount_Base     ;Decimal       ;ExternalName=baseamount_base;
                                                   ExternalType=Money;
                                                   ExternalAccess=Read;
                                                   CaptionML=[DAN=Amount (Base);
                                                              ENU=Amount (Base)];
                                                   Description=Shows the Amount field converted to the system's default base currency. The calculation uses the exchange rate specified in the Currencies area. }
    { 59  ;   ;PricePerUnit_Base   ;Decimal       ;ExternalName=priceperunit_base;
                                                   ExternalType=Money;
                                                   ExternalAccess=Read;
                                                   CaptionML=[DAN=Price Per Unit (Base);
                                                              ENU=Price Per Unit (Base)];
                                                   Description=Shows the Price Per Unit field converted to the system's default base currency for reporting purposes. The calculation uses the exchange rate specified in the Currencies area. }
    { 60  ;   ;TransactionCurrencyIdName;Text100  ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("CRM Transactioncurrency".CurrencyName WHERE (TransactionCurrencyId=FIELD(TransactionCurrencyId)));
                                                   ExternalName=transactioncurrencyidname;
                                                   ExternalType=String;
                                                   ExternalAccess=Read;
                                                   CaptionML=[DAN=TransactionCurrencyIdName;
                                                              ENU=TransactionCurrencyIdName] }
    { 61  ;   ;Tax_Base            ;Decimal       ;ExternalName=tax_base;
                                                   ExternalType=Money;
                                                   ExternalAccess=Read;
                                                   CaptionML=[DAN=Tax (Base);
                                                              ENU=Tax (Base)];
                                                   Description=Shows the Tax field converted to the system's default base currency for reporting purposes. The calculation uses the exchange rate specified in the Currencies area. }
    { 62  ;   ;ExtendedAmount_Base ;Decimal       ;ExternalName=extendedamount_base;
                                                   ExternalType=Money;
                                                   ExternalAccess=Read;
                                                   CaptionML=[DAN=Extended Amount (Base);
                                                              ENU=Extended Amount (Base)];
                                                   Description=Shows the Extended Amount field converted to the system's default base currency. The calculation uses the exchange rate specified in the Currencies area. }
    { 63  ;   ;ManualDiscountAmount_Base;Decimal  ;ExternalName=manualdiscountamount_base;
                                                   ExternalType=Money;
                                                   ExternalAccess=Read;
                                                   CaptionML=[DAN=Manual Discount (Base);
                                                              ENU=Manual Discount (Base)];
                                                   Description=Shows the Manual Discount field converted to the system's default base currency for reporting purposes. The calculation uses the exchange rate specified in the Currencies area. }
    { 64  ;   ;OwnerId             ;GUID          ;TableRelation=IF (OwnerIdType=CONST(systemuser)) "CRM Systemuser".SystemUserId
                                                                 ELSE IF (OwnerIdType=CONST(team)) "CRM Team".TeamId;
                                                   ExternalName=ownerid;
                                                   ExternalType=Owner;
                                                   ExternalAccess=Read;
                                                   CaptionML=[DAN=Owner;
                                                              ENU=Owner];
                                                   Description=Unique identifier of the user or team who owns the invoice detail. }
    { 65  ;   ;OwnerIdType         ;Option        ;ExternalName=owneridtype;
                                                   ExternalType=EntityName;
                                                   ExternalAccess=Read;
                                                   CaptionML=[DAN=Owner;
                                                              ENU=Owner];
                                                   OptionCaptionML=[DAN=" ,systemuser,team";
                                                                    ENU=" ,systemuser,team"];
                                                   OptionString=[ ,systemuser,team];
                                                   Description=Unique identifier of the user or team who owns the invoice detail. }
    { 66  ;   ;CreatedOnBehalfBy   ;GUID          ;TableRelation="CRM Systemuser".SystemUserId;
                                                   ExternalName=createdonbehalfby;
                                                   ExternalType=Lookup;
                                                   ExternalAccess=Read;
                                                   CaptionML=[DAN=Created By (Delegate);
                                                              ENU=Created By (Delegate)];
                                                   Description=Shows who created the record on behalf of another user. }
    { 67  ;   ;CreatedOnBehalfByName;Text200      ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("CRM Systemuser".FullName WHERE (SystemUserId=FIELD(CreatedOnBehalfBy)));
                                                   ExternalName=createdonbehalfbyname;
                                                   ExternalType=String;
                                                   ExternalAccess=Read;
                                                   CaptionML=[DAN=CreatedOnBehalfByName;
                                                              ENU=CreatedOnBehalfByName] }
    { 68  ;   ;ModifiedOnBehalfBy  ;GUID          ;TableRelation="CRM Systemuser".SystemUserId;
                                                   ExternalName=modifiedonbehalfby;
                                                   ExternalType=Lookup;
                                                   ExternalAccess=Read;
                                                   CaptionML=[DAN=Modified By (Delegate);
                                                              ENU=Modified By (Delegate)];
                                                   Description=Shows who last updated the record on behalf of another user. }
    { 69  ;   ;ModifiedOnBehalfByName;Text200     ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("CRM Systemuser".FullName WHERE (SystemUserId=FIELD(ModifiedOnBehalfBy)));
                                                   ExternalName=modifiedonbehalfbyname;
                                                   ExternalType=String;
                                                   ExternalAccess=Read;
                                                   CaptionML=[DAN=ModifiedOnBehalfByName;
                                                              ENU=ModifiedOnBehalfByName] }
    { 70  ;   ;SequenceNumber      ;Integer       ;ExternalName=sequencenumber;
                                                   ExternalType=Integer;
                                                   CaptionML=[DAN=Sequence Number;
                                                              ENU=Sequence Number];
                                                   Description=Shows the ID of the data that maintains the sequence. }
    { 71  ;   ;ParentBundleId      ;GUID          ;ExternalName=parentbundleid;
                                                   ExternalType=Uniqueidentifier;
                                                   ExternalAccess=Insert;
                                                   CaptionML=[DAN=Parent Bundle;
                                                              ENU=Parent Bundle];
                                                   Description=Choose the parent bundle associated with this product }
    { 72  ;   ;ProductTypeCode     ;Option        ;InitValue=Product;
                                                   ExternalName=producttypecode;
                                                   ExternalType=Picklist;
                                                   ExternalAccess=Insert;
                                                   OptionOrdinalValues=[1;2;3;4];
                                                   CaptionML=[DAN=Product type;
                                                              ENU=Product type];
                                                   OptionCaptionML=[DAN=Product,Bundle,Required Bundle Product,Optional Bundle Product;
                                                                    ENU=Product,Bundle,Required Bundle Product,Optional Bundle Product];
                                                   OptionString=Product,Bundle,RequiredBundleProduct,OptionalBundleProduct;
                                                   Description=Product Type }
    { 73  ;   ;PropertyConfigurationStatus;Option ;InitValue=NotConfigured;
                                                   ExternalName=propertyconfigurationstatus;
                                                   ExternalType=Picklist;
                                                   OptionOrdinalValues=[0;1;2];
                                                   CaptionML=[DAN=Property Configuration;
                                                              ENU=Property Configuration];
                                                   OptionCaptionML=[DAN=Edit,Rectify,NotConfigured;
                                                                    ENU=Edit,Rectify,NotConfigured];
                                                   OptionString=Edit,Rectify,NotConfigured;
                                                   Description=Status of the property configuration. }
    { 74  ;   ;ProductAssociationId;GUID          ;ExternalName=productassociationid;
                                                   ExternalType=Uniqueidentifier;
                                                   ExternalAccess=Insert;
                                                   CaptionML=[DAN=Bundle Item Association;
                                                              ENU=Bundle Item Association];
                                                   Description=Unique identifier of the product line item association with bundle in the invoice }
  }
  KEYS
  {
    {    ;InvoiceDetailId                         ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    BEGIN
    {
      Dynamics CRM Version: 7.1.0.2040
    }
    END.
  }
}

