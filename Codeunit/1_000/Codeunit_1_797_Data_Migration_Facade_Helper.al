OBJECT Codeunit 1797 Data Migration Facade Helper
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    SingleInstance=Yes;
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      DataMigrationFacadeHelper@1000 : Codeunit 1797;

    PROCEDURE CreateShipmentMethodIfNeeded@2(CodeToSet@1001 : Code[10];DescriptionToSet@1002 : Text[50]) : Code[10];
    VAR
      ShipmentMethod@1000 : Record 10;
    BEGIN
      IF ShipmentMethod.GET(CodeToSet) THEN
        EXIT(CodeToSet);

      ShipmentMethod.VALIDATE(Code,CodeToSet);
      ShipmentMethod.VALIDATE(Description,DescriptionToSet);
      ShipmentMethod.INSERT(TRUE);
      EXIT(ShipmentMethod.Code);
    END;

    PROCEDURE CreateSalespersonPurchaserIfNeeded@3(CodeToSet@1001 : Code[20];NameToSet@1002 : Text[50];PhoneNoToSet@1003 : Text[30];EmailToSet@1004 : Text[80]) : Code[20];
    VAR
      SalespersonPurchaser@1000 : Record 13;
    BEGIN
      IF SalespersonPurchaser.GET(CodeToSet) THEN
        EXIT(CodeToSet);

      SalespersonPurchaser.INIT;
      SalespersonPurchaser.VALIDATE(Code,CodeToSet);
      SalespersonPurchaser.VALIDATE(Name,NameToSet);
      SalespersonPurchaser.VALIDATE("Phone No.",PhoneNoToSet);
      SalespersonPurchaser.VALIDATE("E-Mail",EmailToSet);
      SalespersonPurchaser.VALIDATE("Search E-Mail",EmailToSet);
      SalespersonPurchaser.INSERT(TRUE);
      EXIT(SalespersonPurchaser.Code);
    END;

    PROCEDURE CreateCustomerPriceGroupIfNeeded@4(CodeToSet@1001 : Code[10];DescriptionToSet@1002 : Text[50];PriceIncludesVatToSet@1003 : Boolean) : Code[10];
    VAR
      CustomerPriceGroup@1000 : Record 6;
    BEGIN
      IF CustomerPriceGroup.GET(CodeToSet) THEN
        EXIT(CodeToSet);

      CustomerPriceGroup.INIT;
      CustomerPriceGroup.VALIDATE(Code,CodeToSet);
      CustomerPriceGroup.VALIDATE(Description,DescriptionToSet);
      CustomerPriceGroup.VALIDATE("Price Includes VAT",PriceIncludesVatToSet);
      CustomerPriceGroup.INSERT(TRUE);
      EXIT(CustomerPriceGroup.Code);
    END;

    PROCEDURE CreatePaymentTermsIfNeeded@5(CodeToSet@1001 : Code[10];DescriptionToSet@1002 : Text[50];DueDateCalculationToSet@1003 : DateFormula) : Code[10];
    VAR
      PaymentTerms@1000 : Record 3;
    BEGIN
      IF PaymentTerms.GET(CodeToSet) THEN
        EXIT(CodeToSet);

      PaymentTerms.INIT;
      PaymentTerms.VALIDATE(Code,CodeToSet);
      PaymentTerms.VALIDATE(Description,DescriptionToSet);
      PaymentTerms.VALIDATE("Due Date Calculation",DueDateCalculationToSet);
      PaymentTerms.INSERT(TRUE);
      EXIT(PaymentTerms.Code);
    END;

    PROCEDURE CreatePaymentMethodIfNeeded@6(CodeToSet@1002 : Code[10];DescriptionToSet@1001 : Text[50]) : Code[10];
    VAR
      PaymentMethod@1000 : Record 289;
    BEGIN
      IF PaymentMethod.GET(CodeToSet) THEN
        EXIT(CodeToSet);

      PaymentMethod.INIT;
      PaymentMethod.VALIDATE(Code,CodeToSet);
      PaymentMethod.VALIDATE(Description,DescriptionToSet);
      PaymentMethod.INSERT(TRUE);
      EXIT(PaymentMethod.Code);
    END;

    PROCEDURE DoesPostCodeExist@1(CodeToSearch@1002 : Code[20];CityToSearch@1001 : Text[30]) : Boolean;
    VAR
      PostCode@1000 : Record 225;
    BEGIN
      EXIT(PostCode.GET(CodeToSearch,CityToSearch));
    END;

    PROCEDURE CreatePostCodeIfNeeded@8(CodeToSet@1002 : Code[20];CityToSet@1001 : Text[30];CountyToSet@1003 : Text[30];CountryRegionCodeToSet@1004 : Code[10]) : Boolean;
    VAR
      PostCode@1000 : Record 225;
    BEGIN
      PostCode.SETRANGE(Code,CodeToSet);
      PostCode.SETRANGE("Search City",UPPERCASE(CityToSet));
      IF PostCode.FINDFIRST THEN
        EXIT(FALSE);

      PostCode.INIT;
      PostCode.VALIDATE(Code,CodeToSet);
      PostCode.VALIDATE(City,CityToSet);
      PostCode.VALIDATE(County,CountyToSet);
      PostCode.VALIDATE("Country/Region Code",CountryRegionCodeToSet);
      PostCode.INSERT(TRUE);
      EXIT(TRUE);
    END;

    PROCEDURE CreateCountryIfNeeded@12(CodeToSet@1002 : Code[10];NameToSet@1001 : Text[50];AddressFormatToSet@1005 : 'Post Code+City,City+Post Code,City+County+Post Code,Blank Line+Post Code+City';ContactAddressFormatToSet@1006 : 'First,After Company Name,Last') : Code[10];
    VAR
      CountryRegion@1000 : Record 9;
    BEGIN
      IF CountryRegion.GET(CodeToSet) THEN
        EXIT(CountryRegion.Code);

      CountryRegion.INIT;
      CountryRegion.VALIDATE(Code,CodeToSet);
      CountryRegion.VALIDATE(Name,NameToSet);
      CountryRegion.VALIDATE("Address Format",AddressFormatToSet);
      CountryRegion.VALIDATE("Contact Address Format",ContactAddressFormatToSet);
      CountryRegion.INSERT(TRUE);

      EXIT(CountryRegion.Code);
    END;

    PROCEDURE SearchCountry@14(CodeToSearch@1001 : Code[10];NameToSearch@1003 : Text[50];EUCountryRegionCodeToSearch@1004 : Code[10];IntrastatCodeToSet@1005 : Code[10];VAR CodeToGet@1002 : Code[10]) : Boolean;
    VAR
      CountryRegion@1000 : Record 9;
    BEGIN
      IF CodeToSearch <> '' THEN
        CountryRegion.SETRANGE(Code,CodeToSearch);

      IF NameToSearch <> '' THEN
        CountryRegion.SETRANGE(Name,NameToSearch);

      IF EUCountryRegionCodeToSearch <> '' THEN
        CountryRegion.SETRANGE("EU Country/Region Code",EUCountryRegionCodeToSearch);

      IF IntrastatCodeToSet <> '' THEN
        CountryRegion.SETRANGE("Intrastat Code",IntrastatCodeToSet);

      IF CountryRegion.FINDFIRST THEN BEGIN
        CodeToGet := CountryRegion.Code;
        EXIT(TRUE);
      END;
    END;

    PROCEDURE SearchLanguage@7(AbbreviatedNameToSearch@1000 : Code[3];VAR CodeToGet@1003 : Code[10]) : Boolean;
    VAR
      WindowsLanguageSearch@1002 : Record 2000000045;
      Language@1001 : Record 8;
    BEGIN
      WindowsLanguageSearch.SETRANGE("Abbreviated Name",AbbreviatedNameToSearch);
      IF WindowsLanguageSearch.FINDFIRST THEN BEGIN
        Language.SETRANGE("Windows Language ID",WindowsLanguageSearch."Language ID");
        IF Language.FINDFIRST THEN BEGIN
          CodeToGet := Language.Code;
          EXIT(TRUE);
        END;
      END;
    END;

    PROCEDURE FixIfLcyCode@9(CurrencyCode@1000 : Code[10]) : Code[10];
    VAR
      GeneralLedgerSetup@1001 : Record 98;
    BEGIN
      GeneralLedgerSetup.FINDFIRST;

      IF CurrencyCode = GeneralLedgerSetup."LCY Code" THEN
        EXIT('');
      EXIT(CurrencyCode);
    END;

    PROCEDURE CreateGeneralJournalBatchIfNeeded@97(GeneralJournalBatchCode@1000 : Code[10];NoSeriesCode@1004 : Code[20];PostingNoSeriesCode@1003 : Code[20]);
    VAR
      GenJournalBatch@1002 : Record 232;
      TemplateName@1001 : Code[10];
    BEGIN
      TemplateName := CreateGeneralJournalTemplateIfNeeded(GeneralJournalBatchCode);
      GenJournalBatch.SETRANGE("Journal Template Name",TemplateName);
      GenJournalBatch.SETRANGE(Name,GeneralJournalBatchCode);
      GenJournalBatch.SETRANGE("No. Series",NoSeriesCode);
      GenJournalBatch.SETRANGE("Posting No. Series",PostingNoSeriesCode);
      IF NOT GenJournalBatch.FINDFIRST THEN BEGIN
        GenJournalBatch.INIT;
        GenJournalBatch.VALIDATE("Journal Template Name",TemplateName);
        GenJournalBatch.SetupNewBatch;
        GenJournalBatch.VALIDATE(Name,GeneralJournalBatchCode);
        GenJournalBatch.VALIDATE(Description,GeneralJournalBatchCode);
        GenJournalBatch."No. Series" := NoSeriesCode;
        GenJournalBatch."Posting No. Series" := PostingNoSeriesCode;
        GenJournalBatch.INSERT(TRUE);
      END;
    END;

    LOCAL PROCEDURE CreateGeneralJournalTemplateIfNeeded@98(GeneralJournalBatchCode@1000 : Code[10]) : Code[10];
    VAR
      GenJournalTemplate@1001 : Record 80;
    BEGIN
      GenJournalTemplate.SETRANGE(Type,GenJournalTemplate.Type::General);
      GenJournalTemplate.SETRANGE(Recurring,FALSE);
      IF NOT GenJournalTemplate.FINDFIRST THEN BEGIN
        GenJournalTemplate.INIT;
        GenJournalTemplate.VALIDATE(Name,GeneralJournalBatchCode);
        GenJournalTemplate.VALIDATE(Type,GenJournalTemplate.Type::General);
        GenJournalTemplate.VALIDATE(Recurring,FALSE);
        GenJournalTemplate.INSERT(TRUE);
      END;
      EXIT(GenJournalTemplate.Name);
    END;

    PROCEDURE CreateGeneralJournalLine@99(VAR GenJournalLine@1006 : Record 81;GeneralJournalBatchCode@1000 : Code[10];DocumentNo@1001 : Code[20];Description@1002 : Text[50];AccountType@1009 : Option;AccountNo@1010 : Code[20];PostingDate@1003 : Date;DueDate@1011 : Date;Amount@1004 : Decimal;AmountLCY@1013 : Decimal;Currency@1012 : Code[10];BalancingAccount@1014 : Code[20]);
    VAR
      GenJournalBatch@1005 : Record 232;
      GenJournalLineCurrent@1007 : Record 81;
      GenJournalTemplate@1015 : Record 80;
      LineNum@1008 : Integer;
    BEGIN
      GenJournalBatch.GET(CreateGeneralJournalTemplateIfNeeded(GeneralJournalBatchCode),GeneralJournalBatchCode);

      GenJournalLineCurrent.SETRANGE("Journal Template Name",GenJournalBatch."Journal Template Name");
      GenJournalLineCurrent.SETRANGE("Journal Batch Name",GenJournalBatch.Name);
      IF GenJournalLineCurrent.FINDLAST THEN
        LineNum := GenJournalLineCurrent."Line No." + 10000
      ELSE
        LineNum := 10000;

      GenJournalTemplate.GET(GenJournalBatch."Journal Template Name");

      GenJournalLine.INIT;
      GenJournalLine.SetHideValidation(TRUE);
      GenJournalLine.VALIDATE("Source Code",GenJournalTemplate."Source Code");
      GenJournalLine.VALIDATE("Journal Template Name",GenJournalBatch."Journal Template Name");
      GenJournalLine.VALIDATE("Journal Batch Name",GenJournalBatch.Name);
      GenJournalLine.VALIDATE("Line No.",LineNum);
      GenJournalLine.VALIDATE("Account Type",AccountType);
      GenJournalLine.VALIDATE("Document No.",DocumentNo);
      GenJournalLine.VALIDATE("Account No.",AccountNo);
      GenJournalLine.VALIDATE(Description,Description);
      GenJournalLine.VALIDATE("Document Date",PostingDate);
      GenJournalLine.VALIDATE("Posting Date",PostingDate);
      GenJournalLine.VALIDATE("Due Date",DueDate);
      GenJournalLine.VALIDATE(Amount,Amount);
      GenJournalLine.VALIDATE("Amount (LCY)",AmountLCY);
      GenJournalLine.VALIDATE("Currency Code",DataMigrationFacadeHelper.FixIfLcyCode(Currency));
      GenJournalLine.VALIDATE("Bal. Account Type",GenJournalLine."Bal. Account Type"::"G/L Account");
      GenJournalLine.VALIDATE("Bal. Account No.",BalancingAccount);
      GenJournalLine.VALIDATE("Bal. Gen. Posting Type",GenJournalLine."Bal. Gen. Posting Type"::" ");
      GenJournalLine.VALIDATE("Bal. Gen. Bus. Posting Group",'');
      GenJournalLine.VALIDATE("Bal. Gen. Prod. Posting Group",'');
      GenJournalLine.VALIDATE("Bal. VAT Prod. Posting Group",'');
      GenJournalLine.VALIDATE("Bal. VAT Bus. Posting Group",'');
      GenJournalLine.INSERT(TRUE);
    END;

    PROCEDURE GetOrCreateDimension@22(DimensionCode@1000 : Code[20];DimensionDescription@1001 : Text[50];VAR Dimension@1002 : Record 348);
    BEGIN
      IF Dimension.GET(DimensionCode) THEN
        EXIT;

      Dimension.INIT;
      Dimension.VALIDATE(Code,DimensionCode);
      Dimension.VALIDATE(Description,DimensionDescription);
      Dimension.INSERT(TRUE);
    END;

    PROCEDURE GetOrCreateDimensionValue@21(DimensionCode@1000 : Code[20];DimensionValueCode@1001 : Code[20];DimensionValueName@1002 : Text[50];VAR DimensionValue@1003 : Record 349);
    BEGIN
      IF DimensionValue.GET(DimensionCode,DimensionValueCode) THEN
        EXIT;

      DimensionValue.INIT;
      DimensionValue.VALIDATE("Dimension Code",DimensionCode);
      DimensionValue.VALIDATE(Code,DimensionValueCode);
      DimensionValue.VALIDATE(Name,DimensionValueName);
      DimensionValue.INSERT(TRUE);
    END;

    PROCEDURE CreateOnlyDefaultDimensionIfNeeded@20(DimensionCode@1001 : Code[20];DimensionValueCode@1002 : Code[20];TableId@1003 : Integer;EntityNo@1004 : Code[20]);
    VAR
      DefaultDimension@1000 : Record 352;
    BEGIN
      IF DefaultDimension.GET(TableId,EntityNo,DimensionCode) THEN
        EXIT;

      DefaultDimension.INIT;
      DefaultDimension.VALIDATE("Dimension Code",DimensionCode);
      DefaultDimension.VALIDATE("Dimension Value Code",DimensionValueCode);
      DefaultDimension.VALIDATE("Table ID",TableId);
      DefaultDimension.VALIDATE("No.",EntityNo);
      DefaultDimension.INSERT(TRUE);
    END;

    PROCEDURE CreateDimensionSetId@10(OldDimensionSetId@1004 : Integer;DimensionCode@1001 : Code[20];DimensionDescription@1006 : Text[50];DimensionValueCode@1000 : Code[20];DimensionValueName@1007 : Text[50]) : Integer;
    VAR
      Dimension@1008 : Record 348;
      DimensionValue@1009 : Record 349;
      DimensionSetEntry@1005 : Record 480;
      TempDimensionSetEntry@1003 : TEMPORARY Record 480;
      DimensionManagement@1002 : Codeunit 408;
    BEGIN
      IF (DimensionCode = '') OR (DimensionValueCode = '') THEN
        EXIT(OldDimensionSetId);

      GetOrCreateDimension(DimensionCode,DimensionDescription,Dimension);
      GetOrCreateDimensionValue(DimensionCode,DimensionValueCode,DimensionValueName,DimensionValue);

      DimensionSetEntry.SETRANGE("Dimension Set ID",OldDimensionSetId);
      DimensionSetEntry.SETFILTER("Dimension Code",'<>%1',DimensionCode);
      IF DimensionSetEntry.FINDSET THEN
        REPEAT
          TempDimensionSetEntry.TRANSFERFIELDS(DimensionSetEntry);
          TempDimensionSetEntry.INSERT(TRUE);
        UNTIL DimensionSetEntry.NEXT = 0;

      TempDimensionSetEntry.INIT;
      TempDimensionSetEntry.VALIDATE("Dimension Set ID",OldDimensionSetId);
      TempDimensionSetEntry.VALIDATE("Dimension Code",DimensionCode);
      TempDimensionSetEntry.VALIDATE("Dimension Value Code",DimensionValueCode);
      TempDimensionSetEntry.INSERT(TRUE);
      EXIT(DimensionManagement.GetDimensionSetID(TempDimensionSetEntry));
    END;

    BEGIN
    END.
  }
}

