OBJECT Codeunit 6112 Customer Data Migration Facade
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
              OnMigrateCustomer("Staging Table RecId To Process");
              OnMigrateCustomerDimensions("Staging Table RecId To Process");

              // migrate transactions for this customer
              OnMigrateCustomerPostingGroups("Staging Table RecId To Process",ChartOfAccountsMigrated);
              OnMigrateCustomerTransactions("Staging Table RecId To Process",ChartOfAccountsMigrated);
              GenJournalLineIsSet := FALSE;
              CustomerIsSet := FALSE;
            UNTIL NEXT = 0;
          END;

  }
  CODE
  {
    VAR
      InternalCustomerNotSetErr@1000 : TextConst 'DAN=Intern debitor er ikke angivet. Opret den f›rst.;ENU=Internal Customer is not set. Create it first.';
      GlobalCustomer@1002 : Record 18;
      GlobalGenJournalLine@1004 : Record 81;
      DataMigrationFacadeHelper@1003 : Codeunit 1797;
      CustomerIsSet@1001 : Boolean;
      GenJournalLineIsSet@1005 : Boolean;
      InternalGenJournalLineNotSetErr@1006 : TextConst 'DAN=Intern finanskladdelinje er ikke angivet. Opret den f›rst.;ENU=Internal Gen. Journal Line is not set. Create it first.';

    [Integration(TRUE)]
    LOCAL PROCEDURE OnMigrateCustomer@1(RecordIdToMigrate@1000 : RecordID);
    BEGIN
    END;

    [Integration(TRUE)]
    LOCAL PROCEDURE OnMigrateCustomerDimensions@23(RecordIdToMigrate@1000 : RecordID);
    BEGIN
    END;

    [External]
    PROCEDURE CreateCustomerIfNeeded@13(CustomerNoToSet@1000 : Code[20];CustomerNameToSet@1003 : Text[50]) : Boolean;
    VAR
      Customer@1001 : Record 18;
    BEGIN
      IF Customer.GET(CustomerNoToSet) THEN BEGIN
        GlobalCustomer := Customer;
        CustomerIsSet := TRUE;
        EXIT;
      END;

      Customer.INIT;

      Customer.VALIDATE("No.",CustomerNoToSet);
      Customer.VALIDATE(Name,CustomerNameToSet);

      Customer.INSERT(TRUE);

      GlobalCustomer := Customer;
      CustomerIsSet := TRUE;
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE CreatePostingSetupIfNeeded@90(CustomerPostingGroupCode@1000 : Code[20];CustomerPostingGroupDescription@1001 : Text[50];ReceivablesAccount@1003 : Code[20]);
    VAR
      CustomerPostingGroup@1002 : Record 92;
    BEGIN
      IF NOT CustomerPostingGroup.GET(CustomerPostingGroupCode) THEN BEGIN
        CustomerPostingGroup.INIT;
        CustomerPostingGroup.VALIDATE(Code,CustomerPostingGroupCode);
        CustomerPostingGroup.VALIDATE(Description,CustomerPostingGroupDescription);
        CustomerPostingGroup.VALIDATE("Receivables Account",ReceivablesAccount);
        CustomerPostingGroup.INSERT(TRUE);
      END ELSE
        IF CustomerPostingGroup."Receivables Account" <> ReceivablesAccount THEN BEGIN
          CustomerPostingGroup.VALIDATE("Receivables Account",ReceivablesAccount);
          CustomerPostingGroup.MODIFY(TRUE);
        END;
    END;

    [External]
    PROCEDURE CreateGeneralJournalBatchIfNeeded@89(GeneralJournalBatchCode@1000 : Code[10];NoSeriesCode@1002 : Code[20];PostingNoSeriesCode@1001 : Code[20]);
    BEGIN
      DataMigrationFacadeHelper.CreateGeneralJournalBatchIfNeeded(GeneralJournalBatchCode,NoSeriesCode,PostingNoSeriesCode);
    END;

    [External]
    PROCEDURE CreateGeneralJournalLine@88(GeneralJournalBatchCode@1000 : Code[10];DocumentNo@1001 : Code[20];Description@1002 : Text[50];PostingDate@1003 : Date;DueDate@1005 : Date;Amount@1004 : Decimal;AmountLCY@1006 : Decimal;Currency@1007 : Code[10];BalancingAccount@1008 : Code[20]);
    BEGIN
      DataMigrationFacadeHelper.CreateGeneralJournalLine(GlobalGenJournalLine,
        GeneralJournalBatchCode,
        DocumentNo,
        Description,
        GlobalGenJournalLine."Account Type"::Customer,
        GlobalCustomer."No.",
        PostingDate,
        DueDate,
        Amount,
        AmountLCY,
        Currency,
        BalancingAccount);
      GenJournalLineIsSet := TRUE;
    END;

    [External]
    PROCEDURE SetGeneralJournalLineDimension@60(DimensionCode@1001 : Code[20];DimensionDescription@1003 : Text[50];DimensionValueCode@1002 : Code[20];DimensionValueName@1004 : Text[50]);
    VAR
      DataMigrationFacadeHelper@1000 : Codeunit 1797;
    BEGIN
      IF NOT GenJournalLineIsSet THEN
        ERROR(InternalGenJournalLineNotSetErr);

      GlobalGenJournalLine.VALIDATE("Dimension Set ID",
        DataMigrationFacadeHelper.CreateDimensionSetId(GlobalGenJournalLine."Dimension Set ID",
          DimensionCode,DimensionDescription,
          DimensionValueCode,DimensionValueName));
      GlobalGenJournalLine.MODIFY(TRUE);
    END;

    [External]
    PROCEDURE SetGlobalCustomer@40(CustomerNo@1000 : Code[20]) : Boolean;
    BEGIN
      CustomerIsSet := GlobalCustomer.GET(CustomerNo);
      EXIT(CustomerIsSet);
    END;

    [External]
    PROCEDURE ModifyCustomer@2(RunTrigger@1000 : Boolean);
    BEGIN
      IF NOT CustomerIsSet THEN
        ERROR(InternalCustomerNotSetErr);

      GlobalCustomer.MODIFY(RunTrigger);
    END;

    [External]
    PROCEDURE SetSearchName@18(SearchNameToSet@1000 : Code[50]);
    BEGIN
      IF NOT CustomerIsSet THEN
        ERROR(InternalCustomerNotSetErr);

      GlobalCustomer.VALIDATE("Search Name",SearchNameToSet);
    END;

    [External]
    PROCEDURE DoesCustomerExist@52(CustomerNo@1000 : Code[20]) : Boolean;
    VAR
      Customer@1001 : Record 18;
    BEGIN
      EXIT(Customer.GET(CustomerNo));
    END;

    [External]
    PROCEDURE SetAddress@3(AdressToSet@1000 : Text[50];Adress2ToSet@1001 : Text[50];CountryRegionCodeToSet@1003 : Code[10];PostCodeToSet@1002 : Code[20];CityToSet@1004 : Text[30]);
    BEGIN
      IF NOT CustomerIsSet THEN
        ERROR(InternalCustomerNotSetErr);

      GlobalCustomer.VALIDATE(Address,AdressToSet);
      GlobalCustomer.VALIDATE("Address 2",Adress2ToSet);
      GlobalCustomer.VALIDATE("Country/Region Code",CountryRegionCodeToSet);
      GlobalCustomer.VALIDATE("Post Code",PostCodeToSet);
      GlobalCustomer.VALIDATE(City,CityToSet);
    END;

    [External]
    PROCEDURE SetPhoneNo@4(PhoneNoToSet@1000 : Text[30]);
    BEGIN
      IF NOT CustomerIsSet THEN
        ERROR(InternalCustomerNotSetErr);

      GlobalCustomer.VALIDATE("Phone No.",PhoneNoToSet);
    END;

    [External]
    PROCEDURE SetTelexNo@5(TelexNoToSet@1000 : Text[20]);
    BEGIN
      IF NOT CustomerIsSet THEN
        ERROR(InternalCustomerNotSetErr);

      GlobalCustomer.VALIDATE("Telex No.",TelexNoToSet);
    END;

    [External]
    PROCEDURE SetCreditLimitLCY@27(CreditLimitToSet@1000 : Decimal);
    BEGIN
      IF NOT CustomerIsSet THEN
        ERROR(InternalCustomerNotSetErr);

      GlobalCustomer.VALIDATE("Credit Limit (LCY)",CreditLimitToSet);
    END;

    [External]
    PROCEDURE SetCurrencyCode@7(CurrencyCodeToSet@1000 : Code[10]);
    BEGIN
      IF NOT CustomerIsSet THEN
        ERROR(InternalCustomerNotSetErr);

      GlobalCustomer.VALIDATE("Currency Code",DataMigrationFacadeHelper.FixIfLcyCode(CurrencyCodeToSet));
    END;

    [External]
    PROCEDURE SetCustomerPriceGroup@29(CustomerPriceGroupToSet@1000 : Code[10]);
    BEGIN
      IF NOT CustomerIsSet THEN
        ERROR(InternalCustomerNotSetErr);

      GlobalCustomer.VALIDATE("Customer Price Group",CustomerPriceGroupToSet);
    END;

    [External]
    PROCEDURE SetLanguageCode@8(LanguageCodeToSet@1000 : Code[10]);
    BEGIN
      IF NOT CustomerIsSet THEN
        ERROR(InternalCustomerNotSetErr);

      GlobalCustomer.VALIDATE("Language Code",LanguageCodeToSet);
    END;

    [External]
    PROCEDURE SetShipmentMethodCode@11(ShipmentMethodCodeToSet@1000 : Code[10]);
    BEGIN
      IF NOT CustomerIsSet THEN
        ERROR(InternalCustomerNotSetErr);

      GlobalCustomer.VALIDATE("Shipment Method Code",ShipmentMethodCodeToSet);
    END;

    [External]
    PROCEDURE SetPaymentTermsCode@9(PaymentTermsCodeToSet@1000 : Code[10]);
    BEGIN
      IF NOT CustomerIsSet THEN
        ERROR(InternalCustomerNotSetErr);

      GlobalCustomer.VALIDATE("Payment Terms Code",PaymentTermsCodeToSet);
    END;

    [External]
    PROCEDURE SetSalesPersonCode@10(SalespersonCodeToSet@1000 : Code[20]);
    BEGIN
      IF NOT CustomerIsSet THEN
        ERROR(InternalCustomerNotSetErr);

      GlobalCustomer.VALIDATE("Salesperson Code",SalespersonCodeToSet);
    END;

    [External]
    PROCEDURE SetInvoiceDiscCode@12(InvoiceDiscCodeToSet@1000 : Code[20]);
    BEGIN
      IF NOT CustomerIsSet THEN
        ERROR(InternalCustomerNotSetErr);

      GlobalCustomer.VALIDATE("Invoice Disc. Code",InvoiceDiscCodeToSet);
    END;

    [External]
    PROCEDURE SetBlockedType@14(BlockedTypeToSet@1000 : ' ,Ship,Invoice,All');
    BEGIN
      IF NOT CustomerIsSet THEN
        ERROR(InternalCustomerNotSetErr);

      GlobalCustomer.VALIDATE(Blocked,BlockedTypeToSet);
    END;

    [External]
    PROCEDURE SetFaxNo@15(FaxNoToSet@1000 : Text[30]);
    BEGIN
      IF NOT CustomerIsSet THEN
        ERROR(InternalCustomerNotSetErr);

      GlobalCustomer.VALIDATE("Fax No.",FaxNoToSet);
    END;

    [External]
    PROCEDURE SetVATRegistrationNo@16(VatRegistrationNoToSet@1000 : Text[20]);
    BEGIN
      IF NOT CustomerIsSet THEN
        ERROR(InternalCustomerNotSetErr);

      GlobalCustomer.VALIDATE("VAT Registration No.",VatRegistrationNoToSet);
    END;

    [External]
    PROCEDURE SetHomePage@17(HomePageToSet@1000 : Text[80]);
    BEGIN
      IF NOT CustomerIsSet THEN
        ERROR(InternalCustomerNotSetErr);

      GlobalCustomer.VALIDATE("Home Page",HomePageToSet);
    END;

    [External]
    PROCEDURE SetBillToCustomerNo@25(BillToCustomerToSet@1000 : Code[20]);
    BEGIN
      IF NOT CustomerIsSet THEN
        ERROR(InternalCustomerNotSetErr);

      GlobalCustomer.VALIDATE("Bill-to Customer No.",BillToCustomerToSet);
    END;

    [External]
    PROCEDURE SetPaymentMethodCode@19(PaymentMethodCodeToSet@1000 : Code[10]);
    BEGIN
      IF NOT CustomerIsSet THEN
        ERROR(InternalCustomerNotSetErr);

      GlobalCustomer.VALIDATE("Payment Method Code",PaymentMethodCodeToSet);
    END;

    [External]
    PROCEDURE SetContact@20(ContactToSet@1000 : Text[50]);
    BEGIN
      IF NOT CustomerIsSet THEN
        ERROR(InternalCustomerNotSetErr);

      GlobalCustomer.VALIDATE(Contact,ContactToSet);
    END;

    [External]
    PROCEDURE SetLastDateModified@21(LastDateModifiedToSet@1000 : Date);
    BEGIN
      IF NOT CustomerIsSet THEN
        ERROR(InternalCustomerNotSetErr);

      GlobalCustomer.VALIDATE("Last Date Modified",LastDateModifiedToSet);
    END;

    [External]
    PROCEDURE SetLastModifiedDateTime@22(LastModifiedDateTimeToSet@1000 : DateTime);
    BEGIN
      IF NOT CustomerIsSet THEN
        ERROR(InternalCustomerNotSetErr);

      GlobalCustomer.VALIDATE("Last Modified Date Time",LastModifiedDateTimeToSet);
    END;

    [External]
    PROCEDURE CreateDefaultDimensionAndRequirementsIfNeeded@26(DimensionCode@1003 : Text[20];DimensionDescription@1004 : Text[50];DimensionValueCode@1005 : Code[20];DimensionValueName@1006 : Text[30]);
    VAR
      Dimension@1000 : Record 348;
      DimensionValue@1001 : Record 349;
    BEGIN
      IF NOT CustomerIsSet THEN
        ERROR(InternalCustomerNotSetErr);

      DataMigrationFacadeHelper.GetOrCreateDimension(DimensionCode,DimensionDescription,Dimension);
      DataMigrationFacadeHelper.GetOrCreateDimensionValue(Dimension.Code,DimensionValueCode,DimensionValueName,
        DimensionValue);
      DataMigrationFacadeHelper.CreateOnlyDefaultDimensionIfNeeded(Dimension.Code,DimensionValue.Code,
        DATABASE::Customer,GlobalCustomer."No.");
    END;

    [External]
    PROCEDURE CreateCustomerDiscountGroupIfNeeded@6(CodeToSet@1000 : Code[20];DescriptionToSet@1001 : Text[50]) : Code[20];
    VAR
      CustomerDiscountGroup@1002 : Record 340;
    BEGIN
      IF CustomerDiscountGroup.GET(CodeToSet) THEN
        EXIT(CodeToSet);

      CustomerDiscountGroup.INIT;
      CustomerDiscountGroup.VALIDATE(Code,CodeToSet);
      CustomerDiscountGroup.VALIDATE(Description,DescriptionToSet);
      CustomerDiscountGroup.INSERT(TRUE);
      EXIT(CustomerDiscountGroup.Code);
    END;

    [External]
    PROCEDURE CreateShipmentMethodIfNeeded@28(CodeToSet@1000 : Code[10];DescriptionToSet@1001 : Text[50]) : Code[10];
    BEGIN
      EXIT(DataMigrationFacadeHelper.CreateShipmentMethodIfNeeded(CodeToSet,DescriptionToSet));
    END;

    [External]
    PROCEDURE CreateSalespersonPurchaserIfNeeded@87(CodeToSet@1000 : Code[20];NameToSet@1001 : Text[50];PhoneNoToSet@1002 : Text[30];EmailToSet@1003 : Text[80]) : Code[20];
    BEGIN
      EXIT(DataMigrationFacadeHelper.CreateSalespersonPurchaserIfNeeded(CodeToSet,NameToSet,PhoneNoToSet,EmailToSet));
    END;

    [External]
    PROCEDURE CreateCustomerPriceGroupIfNeeded@34(CodeToSet@1002 : Code[10];DescriptionToSet@1001 : Text[50];PriceIncludesVatToSet@1000 : Boolean) : Code[10];
    BEGIN
      EXIT(DataMigrationFacadeHelper.CreateCustomerPriceGroupIfNeeded(CodeToSet,DescriptionToSet,PriceIncludesVatToSet));
    END;

    [External]
    PROCEDURE CreatePaymentTermsIfNeeded@38(CodeToSet@1000 : Code[10];DescriptionToSet@1001 : Text[50];DueDateCalculationToSet@1002 : DateFormula) : Code[10];
    BEGIN
      EXIT(DataMigrationFacadeHelper.CreatePaymentTermsIfNeeded(CodeToSet,DescriptionToSet,DueDateCalculationToSet));
    END;

    [External]
    PROCEDURE CreatePaymentMethodIfNeeded@41(CodeToSet@1000 : Code[10];DescriptionToSet@1001 : Text[50]) : Code[10];
    BEGIN
      EXIT(DataMigrationFacadeHelper.CreatePaymentMethodIfNeeded(CodeToSet,DescriptionToSet));
    END;

    [External]
    PROCEDURE DoesPostCodeExist@32(CodeToSearch@1002 : Code[20];CityToSearch@1001 : Text[30]) : Boolean;
    BEGIN
      EXIT(DataMigrationFacadeHelper.DoesPostCodeExist(CodeToSearch,CityToSearch));
    END;

    [External]
    PROCEDURE CreatePostCodeIfNeeded@30(CodeToSet@1002 : Code[20];CityToSet@1001 : Text[30];CountyToSet@1003 : Text[30];CountryRegionCodeToSet@1004 : Code[10]) : Boolean;
    BEGIN
      EXIT(DataMigrationFacadeHelper.CreatePostCodeIfNeeded(CodeToSet,CityToSet,CountyToSet,CountryRegionCodeToSet));
    END;

    [External]
    PROCEDURE CreateCountryIfNeeded@24(CodeToSet@1002 : Code[10];NameToSet@1001 : Text[50];AddressFormatToSet@1005 : 'Post Code+City,City+Post Code,City+County+Post Code,Blank Line+Post Code+City';ContactAddressFormatToSet@1006 : 'First,After Company Name,Last') : Code[10];
    BEGIN
      EXIT(DataMigrationFacadeHelper.CreateCountryIfNeeded(CodeToSet,NameToSet,AddressFormatToSet,ContactAddressFormatToSet));
    END;

    [External]
    PROCEDURE SearchCountry@33(CodeToSearch@1001 : Code[10];NameToSearch@1003 : Text[50];EUCountryRegionCodeToSearch@1004 : Code[10];IntrastatCodeToSet@1005 : Code[10];VAR CodeToGet@1002 : Code[10]) : Boolean;
    BEGIN
      EXIT(
        DataMigrationFacadeHelper.SearchCountry(CodeToSearch,NameToSearch,EUCountryRegionCodeToSearch,IntrastatCodeToSet,CodeToGet));
    END;

    [External]
    PROCEDURE SearchLanguage@35(AbbreviatedNameToSearch@1000 : Code[3];VAR CodeToGet@1003 : Code[10]) : Boolean;
    BEGIN
      EXIT(DataMigrationFacadeHelper.SearchLanguage(AbbreviatedNameToSearch,CodeToGet));
    END;

    [External]
    PROCEDURE SetCustomerPostingGroup@43(CustomerPostingGroupCode@1000 : Code[20]) : Boolean;
    VAR
      CustomerPostingGroup@1001 : Record 92;
    BEGIN
      IF NOT CustomerIsSet THEN
        ERROR(InternalCustomerNotSetErr);

      IF NOT CustomerPostingGroup.GET(CustomerPostingGroupCode) THEN
        EXIT;

      GlobalCustomer.VALIDATE("Customer Posting Group",CustomerPostingGroupCode);

      EXIT(TRUE);
    END;

    [Integration(TRUE)]
    LOCAL PROCEDURE OnMigrateCustomerPostingGroups@98(RecordIdToMigrate@1001 : RecordID;ChartOfAccountsMigrated@1000 : Boolean);
    BEGIN
    END;

    [Integration(TRUE)]
    LOCAL PROCEDURE OnMigrateCustomerTransactions@99(RecordIdToMigrate@1001 : RecordID;ChartOfAccountsMigrated@1000 : Boolean);
    BEGIN
    END;

    BEGIN
    END.
  }
}

