OBJECT Codeunit 6111 Vendor Data Migration Facade
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
              OnMigrateVendor("Staging Table RecId To Process");
              OnMigrateVendorDimensions("Staging Table RecId To Process");

              // migrate transactions for this vendor
              OnMigrateVendorPostingGroups("Staging Table RecId To Process",ChartOfAccountsMigrated);
              OnMigrateVendorTransactions("Staging Table RecId To Process",ChartOfAccountsMigrated);
              GenJournalLineIsSet := FALSE;
              VendorIsSet := FALSE;
            UNTIL NEXT = 0;
          END;

  }
  CODE
  {
    VAR
      GlobalVendor@1000 : Record 23;
      GlobalGenJournalLine@1004 : Record 81;
      DataMigrationFacadeHelper@1003 : Codeunit 1797;
      VendorIsSet@1001 : Boolean;
      InternalVendorNotSetErr@1002 : TextConst 'DAN=Intern kreditor er ikke angivet. Opret den f›rst.;ENU=Internal Vendor is not set. Create it first.';
      GenJournalLineIsSet@1005 : Boolean;
      InternalGenJournalLineNotSetErr@1006 : TextConst 'DAN=Intern finanskladdelinje er ikke angivet. Opret den f›rst.;ENU=Internal Gen. Journal Line is not set. Create it first.';

    [Integration(TRUE)]
    LOCAL PROCEDURE OnMigrateVendor@1(RecordIdToMigrate@1000 : RecordID);
    BEGIN
    END;

    [Integration(TRUE)]
    LOCAL PROCEDURE OnMigrateVendorDimensions@23(RecordIdToMigrate@1000 : RecordID);
    BEGIN
    END;

    [External]
    PROCEDURE CreateVendorIfNeeded@13(VendorNoToSet@1000 : Code[20];VendorNameToSet@1003 : Text[50]) : Boolean;
    VAR
      Vendor@1001 : Record 23;
    BEGIN
      IF Vendor.GET(VendorNoToSet) THEN BEGIN
        GlobalVendor := Vendor;
        VendorIsSet := TRUE;
        EXIT;
      END;
      Vendor.INIT;

      Vendor.VALIDATE("No.",VendorNoToSet);
      Vendor.VALIDATE(Name,VendorNameToSet);

      Vendor.INSERT(TRUE);

      GlobalVendor := Vendor;
      VendorIsSet := TRUE;
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE CreatePostingSetupIfNeeded@97(VendorPostingGroupCode@1000 : Code[20];VendorPostingGroupDescription@1001 : Text[50];PayablesAccount@1003 : Code[20]);
    VAR
      VendorPostingGroup@1002 : Record 93;
    BEGIN
      IF NOT VendorPostingGroup.GET(VendorPostingGroupCode) THEN BEGIN
        VendorPostingGroup.INIT;
        VendorPostingGroup.VALIDATE(Code,VendorPostingGroupCode);
        VendorPostingGroup.VALIDATE(Description,VendorPostingGroupDescription);
        VendorPostingGroup.VALIDATE("Payables Account",PayablesAccount);
        VendorPostingGroup.INSERT(TRUE);
      END ELSE
        IF VendorPostingGroup."Payables Account" <> PayablesAccount THEN BEGIN
          VendorPostingGroup.VALIDATE("Payables Account",PayablesAccount);
          VendorPostingGroup.MODIFY(TRUE);
        END;
    END;

    [External]
    PROCEDURE CreateGeneralJournalBatchIfNeeded@35(GeneralJournalBatchCode@1000 : Code[10];NoSeriesCode@1002 : Code[20];PostingNoSeriesCode@1001 : Code[20]);
    BEGIN
      DataMigrationFacadeHelper.CreateGeneralJournalBatchIfNeeded(GeneralJournalBatchCode,NoSeriesCode,PostingNoSeriesCode);
    END;

    [External]
    PROCEDURE CreateGeneralJournalLine@36(GeneralJournalBatchCode@1000 : Code[10];DocumentNo@1001 : Code[20];Description@1002 : Text[50];PostingDate@1003 : Date;DueDate@1005 : Date;Amount@1004 : Decimal;AmountLCY@1006 : Decimal;Currency@1007 : Code[10];BalancingAccount@1008 : Code[20]);
    BEGIN
      DataMigrationFacadeHelper.CreateGeneralJournalLine(GlobalGenJournalLine,
        GeneralJournalBatchCode,
        DocumentNo,
        Description,
        GlobalGenJournalLine."Account Type"::Vendor,
        GlobalVendor."No.",
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
    PROCEDURE SetGlobalVendor@40(VendorNo@1000 : Code[20]) : Boolean;
    BEGIN
      VendorIsSet := GlobalVendor.GET(VendorNo);
      EXIT(VendorIsSet);
    END;

    [External]
    PROCEDURE ModifyVendor@2(RunTrigger@1000 : Boolean);
    BEGIN
      IF NOT VendorIsSet THEN
        ERROR(InternalVendorNotSetErr);

      GlobalVendor.MODIFY(RunTrigger);
    END;

    [External]
    PROCEDURE SetSearchName@18(SearchNameToSet@1000 : Code[50]);
    BEGIN
      IF NOT VendorIsSet THEN
        ERROR(InternalVendorNotSetErr);

      GlobalVendor.VALIDATE("Search Name",SearchNameToSet);
    END;

    [External]
    PROCEDURE SetAddress@3(AdressToSet@1000 : Text[50];Adress2ToSet@1001 : Text[50];CountryRegionCodeToSet@1003 : Code[10];PostCodeToSet@1002 : Code[20];CityToSet@1004 : Text[30]);
    BEGIN
      IF NOT VendorIsSet THEN
        ERROR(InternalVendorNotSetErr);

      GlobalVendor.VALIDATE(Address,AdressToSet);
      GlobalVendor.VALIDATE("Address 2",Adress2ToSet);
      GlobalVendor.VALIDATE("Country/Region Code",CountryRegionCodeToSet);
      GlobalVendor.VALIDATE("Post Code",PostCodeToSet);
      GlobalVendor.VALIDATE(City,CityToSet);
    END;

    [External]
    PROCEDURE SetPhoneNo@4(PhoneNoToSet@1000 : Text[30]);
    BEGIN
      IF NOT VendorIsSet THEN
        ERROR(InternalVendorNotSetErr);

      GlobalVendor.VALIDATE("Phone No.",PhoneNoToSet);
    END;

    [External]
    PROCEDURE SetTelexNo@5(TelexNoToSet@1000 : Text[20]);
    BEGIN
      IF NOT VendorIsSet THEN
        ERROR(InternalVendorNotSetErr);

      GlobalVendor.VALIDATE("Telex No.",TelexNoToSet);
    END;

    [External]
    PROCEDURE SetOurAccountNo@6(OurAccountNoToSet@1000 : Text[20]);
    BEGIN
      IF NOT VendorIsSet THEN
        ERROR(InternalVendorNotSetErr);

      GlobalVendor.VALIDATE("Our Account No.",OurAccountNoToSet);
    END;

    [External]
    PROCEDURE SetCurrencyCode@7(CurrencyCodeToSet@1000 : Code[10]);
    BEGIN
      IF NOT VendorIsSet THEN
        ERROR(InternalVendorNotSetErr);

      GlobalVendor.VALIDATE("Currency Code",DataMigrationFacadeHelper.FixIfLcyCode(CurrencyCodeToSet));
    END;

    [External]
    PROCEDURE SetLanguageCode@8(LanguageCodeToSet@1000 : Code[10]);
    BEGIN
      IF NOT VendorIsSet THEN
        ERROR(InternalVendorNotSetErr);

      GlobalVendor.VALIDATE("Language Code",LanguageCodeToSet);
    END;

    [External]
    PROCEDURE SetPaymentTermsCode@9(PaymentTermsCodeToSet@1000 : Code[10]);
    BEGIN
      IF NOT VendorIsSet THEN
        ERROR(InternalVendorNotSetErr);

      GlobalVendor.VALIDATE("Payment Terms Code",PaymentTermsCodeToSet);
    END;

    [External]
    PROCEDURE SetPaymentMethod@26(PaymentMethodCodeToSet@1000 : Code[10]);
    BEGIN
      IF NOT VendorIsSet THEN
        ERROR(InternalVendorNotSetErr);

      GlobalVendor.VALIDATE("Payment Method Code",PaymentMethodCodeToSet);
    END;

    [External]
    PROCEDURE SetPurchaserCode@10(PurchaserCodeToSet@1000 : Code[20]);
    BEGIN
      IF NOT VendorIsSet THEN
        ERROR(InternalVendorNotSetErr);

      GlobalVendor.VALIDATE("Purchaser Code",PurchaserCodeToSet);
    END;

    [External]
    PROCEDURE SetShipmentMethodCode@11(ShipmentMethodCodeToSet@1000 : Code[10]);
    BEGIN
      IF NOT VendorIsSet THEN
        ERROR(InternalVendorNotSetErr);

      GlobalVendor.VALIDATE("Shipment Method Code",ShipmentMethodCodeToSet);
    END;

    [External]
    PROCEDURE SetInvoiceDiscCode@12(InvoiceDiscCodeToSet@1000 : Code[20]);
    BEGIN
      IF NOT VendorIsSet THEN
        ERROR(InternalVendorNotSetErr);

      GlobalVendor.VALIDATE("Invoice Disc. Code",InvoiceDiscCodeToSet);
    END;

    [External]
    PROCEDURE SetBlockedType@14(BlockedTypeToSet@1000 : ' ,Payment,All');
    BEGIN
      IF NOT VendorIsSet THEN
        ERROR(InternalVendorNotSetErr);

      GlobalVendor.VALIDATE(Blocked,BlockedTypeToSet);
    END;

    [External]
    PROCEDURE SetFaxNo@15(FaxNoToSet@1000 : Text[30]);
    BEGIN
      IF NOT VendorIsSet THEN
        ERROR(InternalVendorNotSetErr);

      GlobalVendor.VALIDATE("Fax No.",FaxNoToSet);
    END;

    [External]
    PROCEDURE SetVATRegistrationNo@16(VatRegistrationNoToSet@1000 : Text[20]);
    BEGIN
      IF NOT VendorIsSet THEN
        ERROR(InternalVendorNotSetErr);

      GlobalVendor.VALIDATE("VAT Registration No.",VatRegistrationNoToSet);
    END;

    [External]
    PROCEDURE SetHomePage@17(HomePageToSet@1000 : Text[80]);
    BEGIN
      IF NOT VendorIsSet THEN
        ERROR(InternalVendorNotSetErr);

      GlobalVendor.VALIDATE("Home Page",HomePageToSet);
    END;

    [External]
    PROCEDURE SetPayToVendorNo@19(PayToVendorToSet@1000 : Code[20]);
    BEGIN
      IF NOT VendorIsSet THEN
        ERROR(InternalVendorNotSetErr);

      GlobalVendor.VALIDATE("Pay-to Vendor No.",PayToVendorToSet);
    END;

    [External]
    PROCEDURE SetContact@20(ContactToSet@1000 : Text[50]);
    BEGIN
      IF NOT VendorIsSet THEN
        ERROR(InternalVendorNotSetErr);

      GlobalVendor.VALIDATE(Contact,ContactToSet);
    END;

    [External]
    PROCEDURE SetLastDateModified@21(LastDateModifiedToSet@1000 : Date);
    BEGIN
      IF NOT VendorIsSet THEN
        ERROR(InternalVendorNotSetErr);

      GlobalVendor.VALIDATE("Last Date Modified",LastDateModifiedToSet);
    END;

    [External]
    PROCEDURE SetLastModifiedDateTime@22(LastModifiedDateTimeToSet@1000 : DateTime);
    BEGIN
      IF NOT VendorIsSet THEN
        ERROR(InternalVendorNotSetErr);

      GlobalVendor.VALIDATE("Last Modified Date Time",LastModifiedDateTimeToSet);
    END;

    [External]
    PROCEDURE SetVendorPostingGroup@43(VendorPostingGroupCode@1000 : Code[20]) : Boolean;
    VAR
      VendorPostingGroup@1001 : Record 93;
    BEGIN
      IF NOT VendorIsSet THEN
        ERROR(InternalVendorNotSetErr);

      IF NOT VendorPostingGroup.GET(VendorPostingGroupCode) THEN
        EXIT;

      GlobalVendor.VALIDATE("Vendor Posting Group",VendorPostingGroupCode);

      EXIT(TRUE);
    END;

    [External]
    PROCEDURE DoesVendorExist@52(VendorNo@1000 : Code[20]) : Boolean;
    VAR
      Vendor@1001 : Record 23;
    BEGIN
      EXIT(Vendor.GET(VendorNo));
    END;

    [External]
    PROCEDURE CreateDefaultDimensionAndRequirementsIfNeeded@25(DimensionCode@1003 : Text[20];DimensionDescription@1004 : Text[50];DimensionValueCode@1005 : Code[20];DimensionValueName@1006 : Text[30]);
    VAR
      Dimension@1000 : Record 348;
      DimensionValue@1001 : Record 349;
    BEGIN
      IF NOT VendorIsSet THEN
        ERROR(InternalVendorNotSetErr);

      DataMigrationFacadeHelper.GetOrCreateDimension(DimensionCode,DimensionDescription,Dimension);
      DataMigrationFacadeHelper.GetOrCreateDimensionValue(Dimension.Code,DimensionValueCode,DimensionValueName,
        DimensionValue);
      DataMigrationFacadeHelper.CreateOnlyDefaultDimensionIfNeeded(Dimension.Code,DimensionValue.Code,
        DATABASE::Vendor,GlobalVendor."No.");
    END;

    [External]
    PROCEDURE CreateShipmentMethodIfNeeded@90(CodeToSet@1000 : Code[10];DescriptionToSet@1001 : Text[50]) : Code[10];
    BEGIN
      EXIT(DataMigrationFacadeHelper.CreateShipmentMethodIfNeeded(CodeToSet,DescriptionToSet));
    END;

    [External]
    PROCEDURE CreateSalespersonPurchaserIfNeeded@28(CodeToSet@1001 : Code[10];NameToSet@1000 : Text[50];PhoneNoToSet@1002 : Text[30];EmailToSet@1003 : Text[80]) : Code[20];
    BEGIN
      EXIT(DataMigrationFacadeHelper.CreateSalespersonPurchaserIfNeeded(CodeToSet,NameToSet,PhoneNoToSet,EmailToSet));
    END;

    [External]
    PROCEDURE CreatePaymentTermsIfNeeded@89(CodeToSet@1000 : Code[10];DescriptionToSet@1001 : Text[50];DueDateCalculationToSet@1002 : DateFormula) : Code[10];
    BEGIN
      EXIT(DataMigrationFacadeHelper.CreatePaymentTermsIfNeeded(CodeToSet,DescriptionToSet,DueDateCalculationToSet));
    END;

    [External]
    PROCEDURE CreatePaymentMethodIfNeeded@33(CodeToSet@1000 : Code[10];DescriptionToSet@1001 : Text[50]) : Code[10];
    BEGIN
      EXIT(DataMigrationFacadeHelper.CreatePaymentMethodIfNeeded(CodeToSet,DescriptionToSet));
    END;

    [External]
    PROCEDURE CreateVendorInvoiceDiscountIfNeeded@37(CodeToSet@1000 : Code[20];CurencyCodeToSet@1001 : Code[10];MinimumAmountToSet@1002 : Decimal;DiscountPercentToSet@1003 : Decimal) : Boolean;
    VAR
      VendorInvoiceDisc@1004 : Record 24;
    BEGIN
      IF VendorInvoiceDisc.GET(CodeToSet,CurencyCodeToSet,MinimumAmountToSet) THEN
        EXIT(FALSE);

      VendorInvoiceDisc.INIT;
      VendorInvoiceDisc.VALIDATE(Code,CodeToSet);
      VendorInvoiceDisc.VALIDATE("Currency Code",CurencyCodeToSet);
      VendorInvoiceDisc.VALIDATE("Minimum Amount",MinimumAmountToSet);
      VendorInvoiceDisc.VALIDATE("Discount %",DiscountPercentToSet);
      VendorInvoiceDisc.INSERT(TRUE);
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE DoesPostCodeExist@30(CodeToSearch@1002 : Code[20];CityToSearch@1001 : Text[30]) : Boolean;
    BEGIN
      EXIT(DataMigrationFacadeHelper.DoesPostCodeExist(CodeToSearch,CityToSearch));
    END;

    [External]
    PROCEDURE CreatePostCodeIfNeeded@27(CodeToSet@1002 : Code[20];CityToSet@1001 : Text[30];CountyToSet@1003 : Text[30];CountryRegionCodeToSet@1004 : Code[10]) : Boolean;
    BEGIN
      EXIT(DataMigrationFacadeHelper.CreatePostCodeIfNeeded(CodeToSet,CityToSet,CountyToSet,CountryRegionCodeToSet));
    END;

    [External]
    PROCEDURE CreateCountryIfNeeded@24(CodeToSet@1002 : Code[10];NameToSet@1001 : Text[50];AddressFormatToSet@1005 : 'Post Code+City,City+Post Code,City+County+Post Code,Blank Line+Post Code+City';ContactAddressFormatToSet@1006 : 'First,After Company Name,Last') : Code[10];
    BEGIN
      EXIT(DataMigrationFacadeHelper.CreateCountryIfNeeded(CodeToSet,NameToSet,AddressFormatToSet,ContactAddressFormatToSet));
    END;

    [External]
    PROCEDURE SearchCountry@31(CodeToSearch@1001 : Code[10];NameToSearch@1003 : Text[50];EUCountryRegionCodeToSearch@1004 : Code[10];IntrastatCodeToSet@1005 : Code[10];VAR CodeToGet@1002 : Code[10]) : Boolean;
    BEGIN
      EXIT(DataMigrationFacadeHelper.SearchCountry(CodeToSearch,NameToSearch,
          EUCountryRegionCodeToSearch,IntrastatCodeToSet,CodeToGet));
    END;

    [External]
    PROCEDURE SearchLanguage@32(AbbreviatedNameToSearch@1000 : Code[3];VAR CodeToGet@1003 : Code[10]) : Boolean;
    BEGIN
      EXIT(DataMigrationFacadeHelper.SearchLanguage(AbbreviatedNameToSearch,CodeToGet));
    END;

    [Integration(TRUE)]
    LOCAL PROCEDURE OnMigrateVendorPostingGroups@98(RecordIdToMigrate@1001 : RecordID;ChartOfAccountsMigrated@1000 : Boolean);
    BEGIN
    END;

    [Integration(TRUE)]
    LOCAL PROCEDURE OnMigrateVendorTransactions@99(RecordIdToMigrate@1001 : RecordID;ChartOfAccountsMigrated@1000 : Boolean);
    BEGIN
    END;

    BEGIN
    END.
  }
}

