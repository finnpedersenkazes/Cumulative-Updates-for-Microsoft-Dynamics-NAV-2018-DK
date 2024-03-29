OBJECT Codeunit 5342 CRM Synch. Helper
{
  OBJECT-PROPERTIES
  {
    Date=28-06-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23019;
  }
  PROPERTIES
  {
    Permissions=TableData 112=m;
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      CRMBaseCurrencyNotFoundInNAVErr@1008 : TextConst '@@@="%1,%2,%3=the ISO code of a currency (example: DKK);";DAN=Valutaen med ISO-koden ''%1'' blev ikke fundet. Derfor kan valutakursen mellem ''%2'' og ''%3'' ikke beregnes.;ENU=The currency with the ISO code ''%1'' cannot be found. Therefore, the exchange rate between ''%2'' and ''%3'' cannot be calculated.';
      DynamicsCRMTransactionCurrencyRecordNotFoundErr@1004 : TextConst '@@@="%1=the currency code, %2 = CRM product name";DAN=Vautaen med v�rdien ''%1'' blev ikke fundet i %2.;ENU=Cannot find the currency with the value ''%1'' in %2.';
      DynamicsCRMUoMNotFoundInGroupErr@1011 : TextConst '@@@="%1=Unit Group Name, %2 = CRM product name";DAN=Der blev ikke fundet nogen enhed i enhedsgruppen ''%1'' i %2.;ENU=Cannot find any unit of measure inside the unit group ''%1'' in %2.';
      DynamicsCRMUoMFoundMultipleInGroupErr@1012 : TextConst '@@@="%1=Unit Group Name, %2 = CRM product name";DAN=Flere enheder blev fundet i enhedsgruppen ''%1 i %2.;ENU=Multiple units of measure were found in the unit group ''%1'' in %2.';
      IncorrectCRMUoMNameErr@1013 : TextConst '@@@="%1=Unit Group name (ex: NAV PIECE), %2=Expected name (ex: PIECE), %3=Actual name (ex: BOX)";DAN=Enheden i enhedsgruppen ''%1'' har et forkert navn: forventet navn ''%2'', fundet navn ''%3''.;ENU=The unit of measure in the unit group ''%1'' has an incorrect name: expected name ''%2'', found name ''%3''.';
      IncorrectCRMUoMQuantityErr@1015 : TextConst '@@@="%1=unit of measure name (ex: PIECE).";DAN=M�ngden af enheder ''%1'' skal v�re 1.;ENU=The quantity on the unit of measure ''%1'' should be 1.';
      DynamicsCRMUomscheduleNotFoundErr@1000 : TextConst '@@@="%1 = unit group name, %2 = CRM product name";DAN=Enhedsgruppen ''%1'' blev ikke fundet i %2.;ENU=Cannot find the unit group ''%1'' in %2.';
      IncorrectCRMUoMStatusErr@1014 : TextConst '@@@="%1=value of the unit of measure, %2=value of the unit group";DAN=Enheden ''%1'' i er ikke basisenheden for enhedsgruppen ''%2''.;ENU=The unit of measure ''%1'' is not the base unit of measure of the unit group ''%2''.';
      InvalidDestinationRecordNoErr@1010 : TextConst 'DAN=Ugyldigt nummer p� destinationsrecord.;ENU=Invalid destination record number.';
      NavTxt@1005 : TextConst '@@@={Locked};DAN=NAV;ENU=NAV';
      RecordMustBeCoupledErr@1007 : TextConst '@@@="%1 = table caption, %2 = primary key value, %3 = CRM Table caption";DAN=%1 %2 skal v�re sammenk�det med en %3-record.;ENU=%1 %2 must be coupled to a %3 record.';
      RecordNotFoundErr@1001 : TextConst '@@@="%1=value;%2=table name in which the value was searched";DAN=%1 blev ikke fundet i %2.;ENU=%1 could not be found in %2.';
      CanOnlyUseSystemUserOwnerTypeErr@1002 : TextConst '@@@="Dynamics CRM entity owner property can be of type team or systemuser. Only the type systemuser is supported. %1 = CRM product name";DAN=Det er kun %1-ejeren af Type SystemUser, der kan kobles til S�lgere.;ENU=Only %1 Owner of Type SystemUser can be mapped to Salespeople.';
      DefaultNAVPriceListNameTxt@1016 : TextConst '@@@=%1 - product name;DAN=%1-standardprisliste;ENU=%1 Default Price List';
      TempCRMPricelevel@1018 : TEMPORARY Record 5346;
      TempCRMTransactioncurrency@1017 : TEMPORARY Record 5345;
      TempCRMUom@1009 : TEMPORARY Record 5361;
      TempCRMUomschedule@1003 : TEMPORARY Record 5362;
      BaseCurrencyIsNullErr@1006 : TextConst 'DAN=Basisvaluta er ikke defineret. Deaktiver og aktiv�r CRM-forbindelsen for at initialisere ops�tningen korrekt.;ENU=The base currency is not defined. Disable and enable CRM connection to initialize setup properly.';
      CRMProductName@1019 : Codeunit 5344;
      CurrencyPriceListNameTxt@1020 : TextConst '@@@=%1 - currency code;DAN=Prisliste i %1;ENU=Price List in %1';

    [External]
    PROCEDURE ClearCache@36();
    BEGIN
      TempCRMPricelevel.RESET;
      TempCRMPricelevel.DELETEALL;
      CLEAR(TempCRMPricelevel);

      TempCRMTransactioncurrency.RESET;
      TempCRMTransactioncurrency.DELETEALL;
      CLEAR(TempCRMTransactioncurrency);

      TempCRMUom.RESET;
      TempCRMUom.DELETEALL;
      CLEAR(TempCRMUom);

      TempCRMUomschedule.RESET;
      TempCRMUomschedule.DELETEALL;
      CLEAR(TempCRMUomschedule);
    END;

    LOCAL PROCEDURE GetDefaultNAVPriceListName@28() : Text[50];
    BEGIN
      EXIT(STRSUBSTNO(DefaultNAVPriceListNameTxt,PRODUCTNAME.SHORT));
    END;

    LOCAL PROCEDURE CreateCRMDefaultPriceList@57(VAR CRMPricelevel@1000 : Record 5346);
    VAR
      CRMTransactioncurrency@1001 : Record 5345;
    BEGIN
      WITH CRMPricelevel DO BEGIN
        RESET;
        SETRANGE(Name,GetDefaultNAVPriceListName);
        IF NOT FINDFIRST THEN BEGIN
          INIT;
          Name := GetDefaultNAVPriceListName;
          FindNAVLocalCurrencyInCRM(CRMTransactioncurrency);
          TransactionCurrencyId := CRMTransactioncurrency.TransactionCurrencyId;
          TransactionCurrencyIdName := CRMTransactioncurrency.CurrencyName;
          INSERT;

          AddToCacheCRMPriceLevel(CRMPricelevel);
        END;
      END;
    END;

    PROCEDURE CreateCRMPricelevelInCurrency@61(VAR CRMPricelevel@1001 : Record 5346;CurrencyCode@1000 : Code[10];NewExchangeRate@1005 : Decimal);
    VAR
      CRMOrganization@1002 : Record 5363;
      CRMIntegrationRecord@1004 : Record 5331;
    BEGIN
      CRMOrganization.FINDFIRST;
      FindCurrencyCRMIntegrationRecord(CRMIntegrationRecord,CurrencyCode);

      WITH CRMPricelevel DO BEGIN
        INIT;
        PriceLevelId := FORMAT(CREATEGUID);
        OrganizationId := CRMOrganization.OrganizationId;
        Name :=
          COPYSTR(STRSUBSTNO(CurrencyPriceListNameTxt,CurrencyCode),1,MAXSTRLEN(Name));
        TransactionCurrencyId := CRMIntegrationRecord."CRM ID";
        ExchangeRate := NewExchangeRate;
        INSERT;
      END;
    END;

    LOCAL PROCEDURE CreateCRMProductpricelevelForProduct@16(CRMProduct@1000 : Record 5348;NewPriceLevelId@1002 : GUID);
    VAR
      CRMProductpricelevel@1001 : Record 5347;
    BEGIN
      WITH CRMProductpricelevel DO BEGIN
        INIT;
        PriceLevelId := NewPriceLevelId;
        UoMId := CRMProduct.DefaultUoMId;
        UoMScheduleId := CRMProduct.DefaultUoMScheduleId;
        ProductId := CRMProduct.ProductId;
        Amount := CRMProduct.Price;
        TransactionCurrencyId := CRMProduct.TransactionCurrencyId;
        ProductNumber := CRMProduct.ProductNumber;
        INSERT;
      END;
    END;

    PROCEDURE CreateCRMProductpriceIfAbsent@66(CRMInvoicedetail@1000 : Record 5356);
    BEGIN
      IF NOT ISNULLGUID(CRMInvoicedetail.ProductId) THEN
        IF NOT FindCRMProductPriceFromCRMInvoicedetail(CRMInvoicedetail) THEN
          CreateCRMProductpriceFromCRMInvoiceDetail(CRMInvoicedetail);
    END;

    LOCAL PROCEDURE CreateCRMProductpriceFromCRMInvoiceDetail@64(CRMInvoicedetail@1000 : Record 5356);
    VAR
      CRMInvoice@1001 : Record 5355;
      CRMProductpricelevel@1002 : Record 5347;
      CRMUom@1003 : Record 5361;
    BEGIN
      CRMInvoice.GET(CRMInvoicedetail.InvoiceId);
      CRMUom.GET(CRMInvoicedetail.UoMId);
      WITH CRMProductpricelevel DO BEGIN
        INIT;
        PriceLevelId := CRMInvoice.PriceLevelId;
        ProductId := CRMInvoicedetail.ProductId;
        UoMId := CRMInvoicedetail.UoMId;
        UoMScheduleId := CRMUom.UoMScheduleId;
        Amount := CRMInvoicedetail.PricePerUnit;
        INSERT;
      END;
    END;

    LOCAL PROCEDURE CreateCRMTransactioncurrency@18(VAR CRMTransactioncurrency@1000 : Record 5345;CurrencyCode@1001 : Code[10]);
    BEGIN
      WITH CRMTransactioncurrency DO BEGIN
        INIT;
        ISOCurrencyCode := COPYSTR(CurrencyCode,1,MAXSTRLEN(ISOCurrencyCode));
        CurrencyName := ISOCurrencyCode;
        CurrencySymbol := ISOCurrencyCode;
        CurrencyPrecision := GetCRMCurrencyDefaultPrecision;
        ExchangeRate := GetCRMLCYToFCYExchangeRate(ISOCurrencyCode);
        INSERT;
      END;
    END;

    [Internal]
    PROCEDURE FindCRMDefaultPriceList@26(VAR CRMPricelevel@1000 : Record 5346);
    VAR
      CRMConnectionSetup@1003 : Record 5330;
    BEGIN
      WITH CRMConnectionSetup DO BEGIN
        GET;
        IF NOT FindCRMPriceList(CRMPricelevel,"Default CRM Price List ID") THEN BEGIN
          CreateCRMDefaultPriceList(CRMPricelevel);
          VALIDATE("Default CRM Price List ID",CRMPricelevel.PriceLevelId);
          MODIFY;
        END;
      END;
    END;

    LOCAL PROCEDURE FindCRMPriceList@56(VAR CRMPricelevel@1000 : Record 5346;PriceListId@1001 : GUID) : Boolean;
    BEGIN
      IF NOT ISNULLGUID(PriceListId) THEN BEGIN
        CRMPricelevel.RESET;
        CRMPricelevel.SETRANGE(PriceLevelId,PriceListId);
        EXIT(FindCachedCRMPriceLevel(CRMPricelevel));
      END;
    END;

    PROCEDURE FindCRMPriceListByCurrencyCode@81(VAR CRMPricelevel@1000 : Record 5346;CurrencyCode@1001 : Code[10]) : Boolean;
    VAR
      CRMIntegrationRecord@1002 : Record 5331;
    BEGIN
      IF CurrencyCode = '' THEN BEGIN
        FindCRMDefaultPriceList(CRMPricelevel);
        EXIT(TRUE);
      END;

      FindCurrencyCRMIntegrationRecord(CRMIntegrationRecord,CurrencyCode);
      CRMPricelevel.RESET;
      CRMPricelevel.SETRANGE(TransactionCurrencyId,CRMIntegrationRecord."CRM ID");
      EXIT(FindCachedCRMPriceLevel(CRMPricelevel));
    END;

    PROCEDURE FindCRMProductPriceFromCRMInvoicedetail@62(CRMInvoicedetail@1000 : Record 5356) : Boolean;
    VAR
      CRMInvoice@1002 : Record 5355;
      CRMProductpricelevel@1001 : Record 5347;
    BEGIN
      CRMInvoice.GET(CRMInvoicedetail.InvoiceId);
      CRMProductpricelevel.SETRANGE(PriceLevelId,CRMInvoice.PriceLevelId);
      CRMProductpricelevel.SETRANGE(ProductId,CRMInvoicedetail.ProductId);
      CRMProductpricelevel.SETRANGE(UoMId,CRMInvoicedetail.UoMId);
      EXIT(NOT CRMProductpricelevel.ISEMPTY);
    END;

    LOCAL PROCEDURE FindCurrencyCRMIntegrationRecord@82(VAR CRMIntegrationRecord@1000 : Record 5331;CurrencyCode@1001 : Code[10]);
    VAR
      Currency@1002 : Record 4;
      CRMTransactioncurrency@1003 : Record 5345;
    BEGIN
      Currency.GET(CurrencyCode);
      IF NOT CRMIntegrationRecord.FindByRecordID(Currency.RECORDID) THEN
        ERROR(RecordMustBeCoupledErr,Currency.TABLECAPTION,CurrencyCode,CRMTransactioncurrency.TABLECAPTION);
    END;

    LOCAL PROCEDURE FindCustomersContactByAccountId@58(VAR Contact@1004 : Record 5050;AccountId@1000 : GUID) : Boolean;
    VAR
      ContactBusinessRelation@1007 : Record 5054;
      CRMIntegrationRecord@1003 : Record 5331;
      Customer@1002 : Record 18;
      CustomerRecordID@1001 : RecordID;
    BEGIN
      IF ISNULLGUID(AccountId) THEN
        EXIT(FALSE);

      IF NOT CRMIntegrationRecord.FindRecordIDFromID(AccountId,DATABASE::Customer,CustomerRecordID) THEN
        IF SynchRecordIfMappingExists(DATABASE::"CRM Account",AccountId) THEN
          IF NOT CRMIntegrationRecord.FindRecordIDFromID(AccountId,DATABASE::Customer,CustomerRecordID) THEN
            EXIT(FALSE);

      IF Customer.GET(CustomerRecordID) THEN BEGIN
        ContactBusinessRelation.SETCURRENTKEY("Link to Table","No.");
        ContactBusinessRelation.SETRANGE("Link to Table",ContactBusinessRelation."Link to Table"::Customer);
        ContactBusinessRelation.SETRANGE("No.",Customer."No.");
        IF ContactBusinessRelation.FINDFIRST THEN
          EXIT(Contact.GET(ContactBusinessRelation."Contact No."));
      END;
    END;

    [Internal]
    PROCEDURE FindNAVLocalCurrencyInCRM@20(VAR CRMTransactioncurrency@1000 : Record 5345) : GUID;
    VAR
      NAVLCYCode@1001 : Code[10];
    BEGIN
      NAVLCYCode := GetNavLCYCode;
      CRMTransactioncurrency.SETRANGE(ISOCurrencyCode,NAVLCYCode);
      IF NOT FindCachedCRMTransactionCurrency(CRMTransactioncurrency) THEN BEGIN
        CreateCRMTransactioncurrency(CRMTransactioncurrency,NAVLCYCode);
        AddToCacheCRMTransactionCurrency(CRMTransactioncurrency);
      END;
      EXIT(CRMTransactioncurrency.TransactionCurrencyId);
    END;

    PROCEDURE GetBaseCurrencyPrecision@32() DecimalPrecision : Decimal;
    VAR
      CRMConnectionSetup@1000 : Record 5330;
    BEGIN
      DecimalPrecision := 1;
      CRMConnectionSetup.GET;
      IF CRMConnectionSetup.BaseCurrencyPrecision > 0 THEN
        DecimalPrecision := POWER(10,-CRMConnectionSetup.BaseCurrencyPrecision);
    END;

    [External]
    PROCEDURE GetCRMCurrencyDefaultPrecision@24() : Integer;
    VAR
      CRMConnectionSetup@1000 : Record 5330;
    BEGIN
      CRMConnectionSetup.GET;
      EXIT(CRMConnectionSetup.CurrencyDecimalPrecision);
    END;

    LOCAL PROCEDURE GetCRMExchangeRateRoundingPrecision@23() : Decimal;
    BEGIN
      EXIT(0.0000000001);
    END;

    [Internal]
    PROCEDURE GetCRMLCYToFCYExchangeRate@12(ToCurrencyISOCode@1002 : Text[10]) : Decimal;
    VAR
      CRMConnectionSetup@1000 : Record 5330;
      CRMTransactioncurrency@1001 : Record 5345;
    BEGIN
      CRMConnectionSetup.GET;
      IF ISNULLGUID(CRMConnectionSetup.BaseCurrencyId) THEN
        ERROR(BaseCurrencyIsNullErr);
      IF ToCurrencyISOCode = DELCHR(CRMConnectionSetup.BaseCurrencySymbol) THEN
        EXIT(1.0);

      CRMTransactioncurrency.SETRANGE(TransactionCurrencyId,CRMConnectionSetup.BaseCurrencyId);
      IF NOT FindCachedCRMTransactionCurrency(CRMTransactioncurrency) THEN
        ERROR(DynamicsCRMTransactionCurrencyRecordNotFoundErr,CRMConnectionSetup.BaseCurrencySymbol,CRMProductName.SHORT);
      EXIT(GetFCYtoFCYExchangeRate(CRMTransactioncurrency.ISOCurrencyCode,ToCurrencyISOCode));
    END;

    [Internal]
    PROCEDURE GetFCYtoFCYExchangeRate@27(FromFCY@1002 : Code[10];ToFCY@1005 : Code[10]) : Decimal;
    VAR
      Currency@1003 : Record 4;
      CurrencyExchangeRate@1004 : Record 330;
      CalculatedExchangeRate@1000 : Decimal;
      NavLCYCode@1001 : Code[10];
    BEGIN
      FromFCY := DELCHR(FromFCY);
      ToFCY := DELCHR(ToFCY);
      IF (FromFCY = '') OR (ToFCY = '') THEN
        ERROR(CRMBaseCurrencyNotFoundInNAVErr,'',ToFCY,FromFCY);

      IF ToFCY = FromFCY THEN
        EXIT(1.0);

      NavLCYCode := GetNavLCYCode;
      IF ToFCY = NavLCYCode THEN
        ToFCY := '';

      IF FromFCY = NavLCYCode THEN
        EXIT(CurrencyExchangeRate.GetCurrentCurrencyFactor(ToFCY));

      IF NOT Currency.GET(FromFCY) THEN
        ERROR(CRMBaseCurrencyNotFoundInNAVErr,FromFCY,ToFCY,FromFCY);

      // In CRM exchange rate is inverted, so ExchangeAmtFCYToFCY takes (ToFCY,FromFCY) instead of (FromFCY,ToFCY)
      CalculatedExchangeRate := CurrencyExchangeRate.ExchangeAmtFCYToFCY(WORKDATE,ToFCY,FromFCY,1);
      CalculatedExchangeRate := ROUND(CalculatedExchangeRate,GetCRMExchangeRateRoundingPrecision,'=');
      EXIT(CalculatedExchangeRate);
    END;

    LOCAL PROCEDURE GetNavLCYCode@29() : Code[10];
    VAR
      GeneralLedgerSetup@1000 : Record 98;
    BEGIN
      GeneralLedgerSetup.GET;
      GeneralLedgerSetup.TESTFIELD("LCY Code");
      EXIT(GeneralLedgerSetup."LCY Code");
    END;

    [External]
    PROCEDURE GetUnitGroupName@11(UnitOfMeasureCode@1000 : Text) : Text[200];
    BEGIN
      EXIT(STRSUBSTNO('%1 %2',NavTxt,UnitOfMeasureCode));
    END;

    [External]
    PROCEDURE GetUnitOfMeasureName@37(UnitOfMeasureRecordRef@1002 : RecordRef) : Text[100];
    VAR
      UnitOfMeasure@1004 : Record 204;
      UnitOfMeasureCodeFieldRef@1003 : FieldRef;
    BEGIN
      UnitOfMeasureCodeFieldRef := UnitOfMeasureRecordRef.FIELD(UnitOfMeasure.FIELDNO(Code));
      EXIT(FORMAT(UnitOfMeasureCodeFieldRef.VALUE));
    END;

    [External]
    PROCEDURE SetCRMDecimalsSupportedValue@7(VAR CRMProduct@1003 : Record 5348);
    VAR
      CRMSetupDefaults@1002 : Codeunit 5334;
    BEGIN
      CRMProduct.QuantityDecimal := CRMSetupDefaults.GetProductQuantityPrecision;
    END;

    [Internal]
    PROCEDURE SetCRMDefaultPriceListOnProduct@22(VAR CRMProduct@1000 : Record 5348) AdditionalFieldsWereModified : Boolean;
    VAR
      CRMPricelevel@1001 : Record 5346;
    BEGIN
      FindCRMDefaultPriceList(CRMPricelevel);

      IF CRMProduct.PriceLevelId <> CRMPricelevel.PriceLevelId THEN BEGIN
        CRMProduct.PriceLevelId := CRMPricelevel.PriceLevelId;
        AdditionalFieldsWereModified := TRUE;
      END;
    END;

    [External]
    PROCEDURE SetCRMProductStateToActive@13(VAR CRMProduct@1000 : Record 5348);
    BEGIN
      CRMProduct.StateCode := CRMProduct.StateCode::Active;
      CRMProduct.StatusCode := CRMProduct.StatusCode::Active;
    END;

    [External]
    PROCEDURE SetCRMProductStateToRetired@48(VAR CRMProduct@1000 : Record 5348);
    BEGIN
      CRMProduct.StateCode := CRMProduct.StateCode::Retired;
      CRMProduct.StatusCode := CRMProduct.StatusCode::Retired;
    END;

    [Internal]
    PROCEDURE SetContactParentCompany@2(AccountID@1003 : GUID;DestinationContactRecordRef@1007 : RecordRef) : Boolean;
    VAR
      CompanyContact@1000 : Record 5050;
      DestinationFieldRef@1006 : FieldRef;
    BEGIN
      IF DestinationContactRecordRef.NUMBER <> DATABASE::Contact THEN
        ERROR(InvalidDestinationRecordNoErr);

      IF FindCustomersContactByAccountId(CompanyContact,AccountID) THEN BEGIN
        DestinationFieldRef := DestinationContactRecordRef.FIELD(CompanyContact.FIELDNO("Company No."));
        DestinationFieldRef.VALUE := CompanyContact."No.";
        DestinationFieldRef := DestinationContactRecordRef.FIELD(CompanyContact.FIELDNO("Company Name"));
        DestinationFieldRef.VALUE := CompanyContact.Name;
        EXIT(TRUE);
      END;
    END;

    [Internal]
    PROCEDURE SynchRecordIfMappingExists@8(TableNo@1000 : Integer;PrimaryKey@1001 : Variant) : Boolean;
    VAR
      IntegrationTableMapping@1002 : Record 5335;
      IntegrationSynchJob@1005 : Record 5338;
      CRMIntegrationTableSynch@1003 : Codeunit 5340;
      NewJobEntryId@1004 : GUID;
    BEGIN
      IF IntegrationTableMapping.FindMapping(TableNo,PrimaryKey) THEN
        NewJobEntryId := CRMIntegrationTableSynch.SynchRecord(IntegrationTableMapping,PrimaryKey,TRUE,FALSE);

      IF ISNULLGUID(NewJobEntryId) THEN
        EXIT(FALSE);
      IF IntegrationSynchJob.GET(NewJobEntryId) THEN
        EXIT(
          (IntegrationSynchJob.Inserted > 0) OR
          (IntegrationSynchJob.Modified > 0) OR
          (IntegrationSynchJob.Unchanged > 0));
    END;

    [Internal]
    PROCEDURE UpdateCRMCurrencyIdIfChanged@9(CurrencyCode@1000 : Text;VAR DestinationCurrencyIDFieldRef@1001 : FieldRef) : Boolean;
    BEGIN
      // Given a source NAV currency code, find a currency with the same ISO code in CRM and update the target CRM currency value if needed
      EXIT(UpdateFieldRefValueIfChanged(DestinationCurrencyIDFieldRef,GetCRMTransactioncurrency(CurrencyCode)));
    END;

    [External]
    PROCEDURE UpdateCRMInvoiceStatus@17(VAR CRMInvoice@1001 : Record 5355;SalesInvoiceHeader@1000 : Record 112);
    VAR
      CustLedgerEntry@1002 : Record 21;
    BEGIN
      CustLedgerEntry.SETRANGE("Document No.",SalesInvoiceHeader."No.");
      CustLedgerEntry.SETRANGE("Document Type",CustLedgerEntry."Document Type"::Invoice);
      IF CustLedgerEntry.FINDFIRST THEN
        UpdateCRMInvoiceStatusFromEntry(CRMInvoice,CustLedgerEntry);
    END;

    [External]
    PROCEDURE UpdateCRMInvoiceStatusFromEntry@15(VAR CRMInvoice@1001 : Record 5355;CustLedgerEntry@1000 : Record 21) : Integer;
    VAR
      NewCRMInvoice@1002 : Record 5355;
    BEGIN
      WITH CRMInvoice DO BEGIN
        CalculateActualStatusCode(CustLedgerEntry,NewCRMInvoice);
        IF (NewCRMInvoice.StateCode <> StateCode) OR (NewCRMInvoice.StatusCode <> StatusCode) THEN BEGIN
          ActivateInvoiceForFurtherUpdate(CRMInvoice);
          StateCode := NewCRMInvoice.StateCode;
          StatusCode := NewCRMInvoice.StatusCode;
          MODIFY;
          EXIT(1);
        END;
      END;
    END;

    LOCAL PROCEDURE CalculateActualStatusCode@59(CustLedgerEntry@1001 : Record 21;VAR CRMInvoice@1000 : Record 5355);
    BEGIN
      WITH CRMInvoice DO BEGIN
        CustLedgerEntry.CALCFIELDS("Remaining Amount",Amount);
        IF CustLedgerEntry."Remaining Amount" = 0 THEN BEGIN
          StateCode := StateCode::Paid;
          StatusCode := StatusCode::Complete;
        END ELSE
          IF CustLedgerEntry."Remaining Amount" <> CustLedgerEntry.Amount THEN BEGIN
            StateCode := StateCode::Paid;
            StatusCode := StatusCode::Partial;
          END ELSE BEGIN
            StateCode := StateCode::Active;
            StatusCode := StatusCode::Billed;
          END;
      END;
    END;

    LOCAL PROCEDURE ActivateInvoiceForFurtherUpdate@60(VAR CRMInvoice@1000 : Record 5355);
    BEGIN
      WITH CRMInvoice DO
        IF StateCode <> StateCode::Active THEN BEGIN
          StateCode := StateCode::Active;
          StatusCode := StatusCode::Billed;
          MODIFY;
        END;
    END;

    [Internal]
    PROCEDURE UpdateCRMPriceListItem@1(VAR CRMProduct@1000 : Record 5348) AdditionalFieldsWereModified : Boolean;
    VAR
      CRMProductpricelevel@1001 : Record 5347;
    BEGIN
      IF ISNULLGUID(CRMProduct.ProductId) THEN
        EXIT(FALSE);

      AdditionalFieldsWereModified := SetCRMDefaultPriceListOnProduct(CRMProduct);
      CRMProductpricelevel.SETRANGE(ProductId,CRMProduct.ProductId);
      CRMProductpricelevel.SETRANGE(PriceLevelId,CRMProduct.PriceLevelId);
      IF CRMProductpricelevel.FINDFIRST THEN
        EXIT(UpdateCRMProductpricelevel(CRMProductpricelevel,CRMProduct) OR AdditionalFieldsWereModified);

      CreateCRMProductpricelevelForProduct(CRMProduct,CRMProduct.PriceLevelId);
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE UpdateCRMProductPriceIfNegative@6(VAR CRMProduct@1001 : Record 5348) : Boolean;
    BEGIN
      // CRM doesn't allow negative prices. Update the price to zero, if negative (this preserves the behavior of the old CRM Connector)
      IF CRMProduct.Price < 0 THEN BEGIN
        CRMProduct.Price := 0;
        EXIT(TRUE);
      END;

      EXIT(FALSE);
    END;

    [External]
    PROCEDURE UpdateCRMProductQuantityOnHandIfNegative@10(VAR CRMProduct@1001 : Record 5348) : Boolean;
    BEGIN
      // Update to zero, if negative (this preserves the behavior of the old CRM Connector)
      IF CRMProduct.QuantityOnHand < 0 THEN BEGIN
        CRMProduct.QuantityOnHand := 0;
        EXIT(TRUE);
      END;

      EXIT(FALSE);
    END;

    LOCAL PROCEDURE UpdateCRMProductpricelevel@52(VAR CRMProductpricelevel@1000 : Record 5347;CRMProduct@1001 : Record 5348) AdditionalFieldsWereModified : Boolean;
    BEGIN
      WITH CRMProductpricelevel DO BEGIN
        IF PriceLevelId <> CRMProduct.PriceLevelId THEN BEGIN
          PriceLevelId := CRMProduct.PriceLevelId;
          AdditionalFieldsWereModified := TRUE;
        END;

        IF UoMId <> CRMProduct.DefaultUoMId THEN BEGIN
          UoMId := CRMProduct.DefaultUoMId;
          AdditionalFieldsWereModified := TRUE;
        END;

        IF UoMScheduleId <> CRMProduct.DefaultUoMScheduleId THEN BEGIN
          UoMScheduleId := CRMProduct.DefaultUoMScheduleId;
          AdditionalFieldsWereModified := TRUE;
        END;

        IF Amount <> CRMProduct.Price THEN BEGIN
          Amount := CRMProduct.Price;
          AdditionalFieldsWereModified := TRUE;
        END;

        IF TransactionCurrencyId <> CRMProduct.TransactionCurrencyId THEN BEGIN
          TransactionCurrencyId := CRMProduct.TransactionCurrencyId;
          AdditionalFieldsWereModified := TRUE;
        END;

        IF ProductNumber <> CRMProduct.ProductNumber THEN BEGIN
          ProductNumber := CRMProduct.ProductNumber;
          AdditionalFieldsWereModified := TRUE;
        END;

        IF AdditionalFieldsWereModified THEN
          MODIFY;
      END;
    END;

    [External]
    PROCEDURE UpdateCRMProductTypeCodeIfChanged@19(VAR CRMProduct@1000 : Record 5348;NewProductTypeCode@1009 : Integer) : Boolean;
    BEGIN
      // We use ProductTypeCode::SalesInventory and ProductTypeCode::Services to trace back later,
      // where this CRM product originated from: a NAV Item, or a NAV Resource
      IF CRMProduct.ProductTypeCode <> NewProductTypeCode THEN BEGIN
        CRMProduct.ProductTypeCode := NewProductTypeCode;
        EXIT(TRUE);
      END;

      EXIT(FALSE);
    END;

    [External]
    PROCEDURE UpdateCRMProductStateCodeIfChanged@49(VAR CRMProduct@1000 : Record 5348;NewBlocked@1009 : Boolean) : Boolean;
    VAR
      NewStateCode@1001 : Option;
    BEGIN
      IF NewBlocked THEN
        NewStateCode := CRMProduct.StateCode::Retired
      ELSE
        NewStateCode := CRMProduct.StateCode::Active;

      IF NewStateCode <> CRMProduct.StateCode THEN BEGIN
        IF NewBlocked THEN
          SetCRMProductStateToRetired(CRMProduct)
        ELSE
          SetCRMProductStateToActive(CRMProduct);
        EXIT(TRUE);
      END;

      EXIT(FALSE);
    END;

    [External]
    PROCEDURE UpdateItemBlockedIfChanged@50(VAR Item@1000 : Record 27;NewBlocked@1009 : Boolean) : Boolean;
    BEGIN
      IF Item.Blocked <> NewBlocked THEN BEGIN
        Item.Blocked := NewBlocked;
        EXIT(TRUE);
      END;
    END;

    [External]
    PROCEDURE UpdateResourceBlockedIfChanged@39(VAR Resource@1000 : Record 156;NewBlocked@1009 : Boolean) : Boolean;
    BEGIN
      IF Resource.Blocked <> NewBlocked THEN BEGIN
        Resource.Blocked := NewBlocked;
        EXIT(TRUE);
      END;
    END;

    [External]
    PROCEDURE UpdateCRMProductUoMFieldsIfChanged@5(VAR CRMProduct@1000 : Record 5348;UnitOfMeasureCode@1009 : Code[10]) : Boolean;
    VAR
      CRMUom@1005 : Record 5361;
      CRMUomschedule@1008 : Record 5362;
      AdditionalFieldsWereModified@1011 : Boolean;
    BEGIN
      // Get the unit of measure ID used in this product
      // On that unit of measure ID, get the UoMName, UomscheduleID, UomscheduleName and update them in the product if needed

      GetValidCRMUnitOfMeasureRecords(CRMUom,CRMUomschedule,UnitOfMeasureCode);

      // Update UoM ID if changed
      IF CRMProduct.DefaultUoMId <> CRMUom.UoMId THEN BEGIN
        CRMProduct.DefaultUoMId := CRMUom.UoMId;
        AdditionalFieldsWereModified := TRUE;
      END;

      // Update the Uomschedule ID if changed
      IF CRMProduct.DefaultUoMScheduleId <> CRMUomschedule.UoMScheduleId THEN BEGIN
        CRMProduct.DefaultUoMScheduleId := CRMUomschedule.UoMScheduleId;
        AdditionalFieldsWereModified := TRUE;
      END;

      EXIT(AdditionalFieldsWereModified);
    END;

    [External]
    PROCEDURE UpdateCRMProductVendorNameIfChanged@14(VAR CRMProduct@1001 : Record 5348) : Boolean;
    VAR
      Vendor@1000 : Record 23;
    BEGIN
      IF NOT Vendor.GET(CRMProduct.VendorPartNumber) THEN
        EXIT(FALSE);

      IF CRMProduct.VendorName <> Vendor.Name THEN BEGIN
        CRMProduct.VendorName := Vendor.Name;
        EXIT(TRUE);
      END;

      EXIT(FALSE);
    END;

    [External]
    PROCEDURE UpdateOwnerIfChanged@3(SourceRecordRef@1000 : RecordRef;DestinationRecordRef@1001 : RecordRef;SourceSalespersonCodeFieldNo@1002 : Integer;DestinationOwnerFieldNo@1003 : Integer;DestinationOwnerTypeFieldNo@1006 : Integer;DestinationOwnerTypeValue@1012 : Option) : Boolean;
    VAR
      SalespersonPurchaser@1009 : Record 13;
      CRMIntegrationRecord@1010 : Record 5331;
      IntegrationTableMapping@1011 : Record 5335;
      SalespersonCodeFieldRef@1008 : FieldRef;
      OwnerFieldRef@1007 : FieldRef;
      OwnerTypeFieldRef@1013 : FieldRef;
      OwnerGuid@1005 : GUID;
      CurrentOwnerGuid@1004 : GUID;
    BEGIN
      IntegrationTableMapping.SETRANGE("Table ID",DATABASE::"Salesperson/Purchaser");
      IntegrationTableMapping.SETRANGE("Integration Table ID",DATABASE::"CRM Systemuser");
      IF NOT IntegrationTableMapping.FINDFIRST THEN
        EXIT(FALSE); // There are no mapping for salepeople to SystemUsers

      SalespersonCodeFieldRef := SourceRecordRef.FIELD(SourceSalespersonCodeFieldNo);

      // Ignore empty salesperson code.
      IF FORMAT(SalespersonCodeFieldRef.VALUE) = '' THEN
        EXIT(FALSE);

      SalespersonPurchaser.SETFILTER(Code,FORMAT(SalespersonCodeFieldRef.VALUE));
      IF NOT SalespersonPurchaser.FINDFIRST THEN
        ERROR(RecordNotFoundErr,SalespersonCodeFieldRef.VALUE,SalespersonPurchaser.TABLECAPTION);

      IF NOT CRMIntegrationRecord.FindIDFromRecordID(SalespersonPurchaser.RECORDID,OwnerGuid) THEN
        ERROR(
          RecordMustBeCoupledErr,SalespersonPurchaser.TABLECAPTION,SalespersonCodeFieldRef.VALUE,
          IntegrationTableMapping.GetExtendedIntegrationTableCaption);

      OwnerFieldRef := DestinationRecordRef.FIELD(DestinationOwnerFieldNo);
      CurrentOwnerGuid := OwnerFieldRef.VALUE;
      IF CurrentOwnerGuid <> OwnerGuid THEN BEGIN
        OwnerFieldRef.VALUE := OwnerGuid;
        OwnerTypeFieldRef := DestinationRecordRef.FIELD(DestinationOwnerTypeFieldNo);
        OwnerTypeFieldRef.VALUE := DestinationOwnerTypeValue;
        EXIT(TRUE);
      END;

      EXIT(FALSE);
    END;

    [External]
    PROCEDURE UpdateContactOnModifyCustomer@35(RecRef@1000 : RecordRef);
    VAR
      Customer@1002 : Record 18;
      CustContUpdate@1001 : Codeunit 5056;
    BEGIN
      IF RecRef.NUMBER = DATABASE::Customer THEN BEGIN
        RecRef.SETTABLE(Customer);
        CustContUpdate.OnModify(Customer);
      END;
    END;

    [Internal]
    PROCEDURE UpdateSalesPersonCodeIfChanged@4(SourceRecordRef@1008 : RecordRef;VAR DestinationRecordRef@1009 : RecordRef;SourceOwnerIDFieldNo@1004 : Integer;SourceOwnerTypeFieldNo@1010 : Integer;AllowedOwnerTypeValue@1011 : Option;DestinationSalesPersonCodeFieldNo@1005 : Integer) : Boolean;
    VAR
      CRMIntegrationRecord@1003 : Record 5331;
      SalespersonPurchaser@1000 : Record 13;
      IntegrationTableMapping@1014 : Record 5335;
      OutlookSynchTypeConv@1013 : Codeunit 5302;
      SalesPersonRecordID@1002 : RecordID;
      SourceFieldRef@1007 : FieldRef;
      DestinationFieldRef@1006 : FieldRef;
      CRMSystemUserID@1001 : GUID;
      CurrentOptionValue@1012 : Integer;
    BEGIN
      IntegrationTableMapping.SETRANGE("Table ID",DATABASE::"Salesperson/Purchaser");
      IntegrationTableMapping.SETRANGE("Integration Table ID",DATABASE::"CRM Systemuser");
      IF IntegrationTableMapping.ISEMPTY THEN
        EXIT(FALSE); // There are no mapping for salepeople to SystemUsers

      SourceFieldRef := SourceRecordRef.FIELD(SourceOwnerTypeFieldNo);
      CurrentOptionValue := OutlookSynchTypeConv.TextToOptionValue(FORMAT(SourceFieldRef.VALUE),SourceFieldRef.OPTIONSTRING);
      // Allow 0 as it is the default value for CRM options.
      IF (CurrentOptionValue <> 0) AND (CurrentOptionValue <> AllowedOwnerTypeValue) THEN
        ERROR(STRSUBSTNO(CanOnlyUseSystemUserOwnerTypeErr,CRMProductName.SHORT));

      SourceFieldRef := SourceRecordRef.FIELD(SourceOwnerIDFieldNo);
      CRMSystemUserID := SourceFieldRef.VALUE;

      IF ISNULLGUID(CRMSystemUserID) THEN
        EXIT(FALSE);

      DestinationFieldRef := DestinationRecordRef.FIELD(DestinationSalesPersonCodeFieldNo);

      IF NOT CRMIntegrationRecord.FindRecordIDFromID(CRMSystemUserID,DATABASE::"Salesperson/Purchaser",SalesPersonRecordID) THEN BEGIN
        IF NOT SynchRecordIfMappingExists(DATABASE::"CRM Systemuser",CRMSystemUserID) THEN
          EXIT(FALSE);
        IF NOT CRMIntegrationRecord.FindRecordIDFromID(CRMSystemUserID,DATABASE::"Salesperson/Purchaser",SalesPersonRecordID) THEN
          EXIT(FALSE);
      END;

      IF NOT SalespersonPurchaser.GET(SalesPersonRecordID) THEN
        EXIT(FALSE);

      EXIT(UpdateFieldRefValueIfChanged(DestinationFieldRef,SalespersonPurchaser.Code));
    END;

    [External]
    PROCEDURE UpdateFieldRefValueIfChanged@21(VAR DestinationFieldRef@1000 : FieldRef;NewFieldValue@1001 : Text) : Boolean;
    BEGIN
      // Compare and updates the fieldref value, if different
      IF FORMAT(DestinationFieldRef.VALUE) = NewFieldValue THEN
        EXIT(FALSE);

      // Return TRUE if the value was changed
      DestinationFieldRef.VALUE := NewFieldValue;
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE GetValidCRMUnitOfMeasureRecords@46(VAR CRMUom@1007 : Record 5361;VAR CRMUomschedule@1001 : Record 5362;UnitOfMeasureCode@1002 : Code[10]);
    VAR
      CRMUnitGroupName@1003 : Text;
    BEGIN
      // This function checks that the CRM Unit of Measure and its parent group exist in CRM, and that the user didn't change their properties from
      // the expected ones

      // Attempt to get the Uomschedule with the expected name = 'NAV ' + UnitOfMeasureCode
      CRMUnitGroupName := GetUnitGroupName(UnitOfMeasureCode);
      CRMUomschedule.SETRANGE(Name,CRMUnitGroupName);

      // CRM Unit Group - Not found
      IF NOT FindCachedCRMUomschedule(CRMUomschedule) THEN
        ERROR(DynamicsCRMUomscheduleNotFoundErr,CRMUnitGroupName,CRMProductName.SHORT);

      // CRM Unit Group  - Multiple found
      IF CountCRMUomschedule(CRMUomschedule) > 1 THEN
        ERROR(DynamicsCRMUoMFoundMultipleInGroupErr,CRMUnitGroupName,CRMProductName.SHORT);

      // CRM Unit Group - One found - check its child unit of measure, should be just one
      CRMUom.SETRANGE(UoMScheduleId,CRMUomschedule.UoMScheduleId);

      // CRM Unit of Measure - not found
      IF NOT FindCachedCRMUom(CRMUom) THEN
        ERROR(DynamicsCRMUoMNotFoundInGroupErr,CRMUomschedule.Name,CRMProductName.SHORT);

      // CRM Unit of Measure - multiple found
      IF CountCRMUom(CRMUom) > 1 THEN
        ERROR(DynamicsCRMUoMFoundMultipleInGroupErr,CRMUomschedule.Name);

      // CRM Unit of Measure - one found, does it have the correct name?
      IF CRMUom.Name <> UnitOfMeasureCode THEN
        ERROR(IncorrectCRMUoMNameErr,CRMUomschedule.Name,UnitOfMeasureCode,CRMUom.Name);

      // CRM Unit of Measure should be the base
      IF NOT CRMUom.IsScheduleBaseUoM THEN
        ERROR(IncorrectCRMUoMStatusErr,CRMUom.Name,CRMUomschedule.Name);

      // CRM Unit of Measure should have the conversion rate of 1
      IF CRMUom.Quantity <> 1 THEN
        ERROR(IncorrectCRMUoMQuantityErr,CRMUom.Name);

      // All checks passed. We're good to go
    END;

    [External]
    PROCEDURE GetNavCurrencyCode@25(TransactionCurrencyId@1000 : GUID) : Code[10];
    VAR
      CRMTransactioncurrency@1001 : Record 5345;
      Currency@1003 : Record 4;
      NAVLCYCode@1004 : Code[10];
      CRMCurrencyCode@1002 : Code[10];
    BEGIN
      IF ISNULLGUID(TransactionCurrencyId) THEN
        EXIT('');
      NAVLCYCode := GetNavLCYCode;
      CRMTransactioncurrency.SETRANGE(TransactionCurrencyId,TransactionCurrencyId);
      IF NOT FindCachedCRMTransactionCurrency(CRMTransactioncurrency) THEN
        ERROR(DynamicsCRMTransactionCurrencyRecordNotFoundErr,TransactionCurrencyId,CRMProductName.SHORT);
      CRMCurrencyCode := DELCHR(CRMTransactioncurrency.ISOCurrencyCode);
      IF CRMCurrencyCode = NAVLCYCode THEN
        EXIT('');

      Currency.GET(CRMCurrencyCode);
      EXIT(Currency.Code);
    END;

    [Internal]
    PROCEDURE GetCRMTransactioncurrency@30(CurrencyCode@1001 : Text) : GUID;
    VAR
      CRMTransactioncurrency@1000 : Record 5345;
      NAVLCYCode@1002 : Code[10];
    BEGIN
      // In NAV, an empty currency means local currency (LCY)
      NAVLCYCode := GetNavLCYCode;
      IF DELCHR(CurrencyCode) = '' THEN
        CurrencyCode := NAVLCYCode;

      IF CurrencyCode = NAVLCYCode THEN
        FindNAVLocalCurrencyInCRM(CRMTransactioncurrency)
      ELSE BEGIN
        CRMTransactioncurrency.SETRANGE(ISOCurrencyCode,CurrencyCode);
        IF NOT FindCachedCRMTransactionCurrency(CRMTransactioncurrency) THEN
          ERROR(DynamicsCRMTransactionCurrencyRecordNotFoundErr,CurrencyCode,CRMProductName.SHORT);
      END;
      EXIT(CRMTransactioncurrency.TransactionCurrencyId)
    END;

    LOCAL PROCEDURE AddToCacheCRMPriceLevel@47(CRMPricelevel@1000 : Record 5346);
    BEGIN
      TempCRMPricelevel := CRMPricelevel;
      TempCRMPricelevel.INSERT;
    END;

    LOCAL PROCEDURE CacheCRMPriceLevel@42() : Boolean;
    VAR
      CRMPricelevel@1000 : Record 5346;
    BEGIN
      TempCRMPricelevel.RESET;
      IF TempCRMPricelevel.ISEMPTY THEN
        IF CRMPricelevel.FINDSET THEN
          REPEAT
            AddToCacheCRMPriceLevel(CRMPricelevel)
          UNTIL CRMPricelevel.NEXT = 0;
      EXIT(NOT TempCRMPricelevel.ISEMPTY);
    END;

    LOCAL PROCEDURE FindCachedCRMPriceLevel@41(VAR CRMPricelevel@1001 : Record 5346) : Boolean;
    BEGIN
      IF NOT CacheCRMPriceLevel THEN
        EXIT(FALSE);
      TempCRMPricelevel.COPY(CRMPricelevel);
      IF TempCRMPricelevel.FINDFIRST THEN BEGIN
        CRMPricelevel.COPY(TempCRMPricelevel);
        EXIT(TRUE);
      END;
    END;

    LOCAL PROCEDURE AddToCacheCRMTransactionCurrency@38(CRMTransactioncurrency@1000 : Record 5345);
    BEGIN
      TempCRMTransactioncurrency := CRMTransactioncurrency;
      TempCRMTransactioncurrency.INSERT;
    END;

    LOCAL PROCEDURE CacheCRMTransactionCurrency@31() : Boolean;
    VAR
      CRMTransactioncurrency@1001 : Record 5345;
    BEGIN
      TempCRMTransactioncurrency.RESET;
      IF TempCRMTransactioncurrency.ISEMPTY THEN
        IF CRMTransactioncurrency.FINDSET THEN
          REPEAT
            AddToCacheCRMTransactionCurrency(CRMTransactioncurrency)
          UNTIL CRMTransactioncurrency.NEXT = 0;
      EXIT(NOT TempCRMTransactioncurrency.ISEMPTY);
    END;

    LOCAL PROCEDURE FindCachedCRMTransactionCurrency@33(VAR CRMTransactioncurrency@1000 : Record 5345) : Boolean;
    BEGIN
      IF NOT CacheCRMTransactionCurrency THEN
        EXIT(FALSE);
      TempCRMTransactioncurrency.COPY(CRMTransactioncurrency);
      IF TempCRMTransactioncurrency.FINDFIRST THEN BEGIN
        CRMTransactioncurrency.COPY(TempCRMTransactioncurrency);
        EXIT(TRUE);
      END;
    END;

    LOCAL PROCEDURE AddToCacheCRMUom@45(CRMUom@1000 : Record 5361);
    BEGIN
      TempCRMUom := CRMUom;
      TempCRMUom.INSERT;
    END;

    LOCAL PROCEDURE CacheCRMUom@44() : Boolean;
    VAR
      CRMUom@1001 : Record 5361;
    BEGIN
      TempCRMUom.RESET;
      IF TempCRMUom.ISEMPTY THEN
        IF CRMUom.FINDSET THEN
          REPEAT
            AddToCacheCRMUom(CRMUom)
          UNTIL CRMUom.NEXT = 0;
      EXIT(NOT TempCRMUom.ISEMPTY);
    END;

    LOCAL PROCEDURE CountCRMUom@40(VAR CRMUom@1000 : Record 5361) : Integer;
    BEGIN
      TempCRMUom.COPY(CRMUom);
      EXIT(TempCRMUom.COUNT);
    END;

    LOCAL PROCEDURE FindCachedCRMUom@43(VAR CRMUom@1000 : Record 5361) : Boolean;
    BEGIN
      IF NOT CacheCRMUom THEN
        EXIT(FALSE);
      TempCRMUom.COPY(CRMUom);
      IF TempCRMUom.FINDFIRST THEN BEGIN
        CRMUom.COPY(TempCRMUom);
        EXIT(TRUE);
      END;
    END;

    LOCAL PROCEDURE AddToCacheCRMUomschedule@55(CRMUomschedule@1000 : Record 5362);
    BEGIN
      TempCRMUomschedule := CRMUomschedule;
      TempCRMUomschedule.INSERT;
    END;

    LOCAL PROCEDURE CacheCRMUomschedule@54() : Boolean;
    VAR
      CRMUomschedule@1001 : Record 5362;
    BEGIN
      TempCRMUomschedule.RESET;
      IF TempCRMUomschedule.ISEMPTY THEN
        IF CRMUomschedule.FINDSET THEN
          REPEAT
            AddToCacheCRMUomschedule(CRMUomschedule)
          UNTIL CRMUomschedule.NEXT = 0;
      EXIT(NOT TempCRMUomschedule.ISEMPTY);
    END;

    LOCAL PROCEDURE CountCRMUomschedule@34(VAR CRMUomschedule@1000 : Record 5362) : Integer;
    BEGIN
      TempCRMUomschedule.COPY(CRMUomschedule);
      EXIT(TempCRMUomschedule.COUNT);
    END;

    LOCAL PROCEDURE FindCachedCRMUomschedule@53(VAR CRMUomschedule@1000 : Record 5362) : Boolean;
    BEGIN
      IF NOT CacheCRMUomschedule THEN
        EXIT(FALSE);
      TempCRMUomschedule.COPY(CRMUomschedule);
      IF TempCRMUomschedule.FINDFIRST THEN BEGIN
        CRMUomschedule.COPY(TempCRMUomschedule);
        EXIT(TRUE);
      END;
    END;

    [External]
    PROCEDURE SetSalesInvoiceHeaderCoupledToCRM@51(SalesInvoiceHeader@1000 : Record 112);
    BEGIN
      SalesInvoiceHeader."Coupled to CRM" := TRUE;
      SalesInvoiceHeader.MODIFY;
    END;

    BEGIN
    END.
  }
}

