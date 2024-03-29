OBJECT Codeunit 5334 CRM Setup Defaults
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      JobQueueEntryNameTok@1002 : TextConst '@@@="%1 = The Integration Table Name to synchronized (ex. CUSTOMER), %2 = CRM product name";DAN=Synkroniseringsjob for %1 - %2.;ENU=" %1 - %2 synchronization job."';
      IntegrationTablePrefixTok@1003 : TextConst '@@@={Locked} Product name;DAN=Dynamics CRM;ENU=Dynamics CRM';
      CustomStatisticsSynchJobDescTxt@1006 : TextConst '@@@="%1 = CRM product name";DAN=Debitorstatistik - %1-synkroniseringsjob.;ENU=Customer Statistics - %1 synchronization job.';
      CRMAccountConfigTemplateCodeTok@1007 : TextConst '@@@=Config. Template code for CRM Accounts created from Customers. Max length 10.;DAN=CRMACCOUNT;ENU=CRMACCOUNT';
      CRMAccountConfigTemplateDescTxt@1009 : TextConst '@@@=Max. length 50.;DAN=Nye CRM-kontorecords opretter under synkr.;ENU=New CRM Account records created during synch.';
      CustomerConfigTemplateCodeTok@1008 : TextConst '@@@=Customer template code for new customers created from CRM data. Max length 10.;DAN=CRMCUST;ENU=CRMCUST';
      CustomerConfigTemplateDescTxt@1010 : TextConst '@@@=Max. length 50.;DAN=Nye debitorrecords oprettet under synkr.;ENU=New Customer records created during synch.';
      CRMProductName@1000 : Codeunit 5344;
      AutoCreateSalesOrdersTxt@1001 : TextConst '@@@="%1 = CRM product name";DAN=Opret salgsordrer automatisk fra salgsordrer, der sendes i %1.;ENU=Automatically create sales orders from sales orders that are submitted in %1.';

    [Internal]
    PROCEDURE ResetConfiguration@9(CRMConnectionSetup@1000 : Record 5330);
    VAR
      TempCRMConnectionSetup@1004 : TEMPORARY Record 5330;
      CRMIntegrationManagement@1001 : Codeunit 5330;
      ConnectionName@1003 : Text;
      EnqueueJobQueEntries@1005 : Boolean;
    BEGIN
      EnqueueJobQueEntries := CRMConnectionSetup.DoReadCRMData;
      ConnectionName := RegisterTempConnectionIfNeeded(CRMConnectionSetup,TempCRMConnectionSetup);
      IF ConnectionName <> '' THEN
        SETDEFAULTTABLECONNECTION(TABLECONNECTIONTYPE::CRM,ConnectionName,TRUE);

      ResetSalesPeopleSystemUserMapping('SALESPEOPLE',EnqueueJobQueEntries);
      ResetCustomerAccountMapping('CUSTOMER',EnqueueJobQueEntries);
      ResetContactContactMapping('CONTACT',EnqueueJobQueEntries);
      ResetCurrencyTransactionCurrencyMapping('CURRENCY',EnqueueJobQueEntries);
      ResetUnitOfMeasureUoMScheduleMapping('UNIT OF MEASURE',EnqueueJobQueEntries);
      ResetItemProductMapping('ITEM-PRODUCT',EnqueueJobQueEntries);
      ResetResourceProductMapping('RESOURCE-PRODUCT',EnqueueJobQueEntries);
      ResetCustomerPriceGroupPricelevelMapping('CUSTPRCGRP-PRICE',EnqueueJobQueEntries);
      ResetSalesPriceProductPricelevelMapping('SALESPRC-PRODPRICE',EnqueueJobQueEntries);
      ResetSalesInvoiceHeaderInvoiceMapping('POSTEDSALESINV-INV',EnqueueJobQueEntries);
      ResetSalesInvoiceLineInvoiceMapping('POSTEDSALESLINE-INV');
      ResetShippingAgentMapping('SHIPPING AGENT');
      ResetShipmentMethodMapping('SHIPMENT METHOD');
      ResetPaymentTermsMapping('PAYMENT TERMS');
      ResetOpportunityMapping('OPPORTUNITY');

      RecreateStatisticsJobQueueEntry(EnqueueJobQueEntries);
      IF CRMConnectionSetup."Auto Create Sales Orders" THEN
        RecreateAutoCreateSalesOrdersJobQueueEntry(EnqueueJobQueEntries);

      IF CRMIntegrationManagement.IsCRMSolutionInstalled THEN
        ResetCRMNAVConnectionData;

      ResetDefaultCRMPricelevel(CRMConnectionSetup);

      IF ConnectionName <> '' THEN
        TempCRMConnectionSetup.UnregisterConnectionWithName(ConnectionName);
    END;

    LOCAL PROCEDURE ResetSalesPeopleSystemUserMapping@7(IntegrationTableMappingName@1000 : Code[20];ShouldRecreateJobQueueEntry@1003 : Boolean);
    VAR
      IntegrationTableMapping@1005 : Record 5335;
      IntegrationFieldMapping@1004 : Record 5336;
      SalespersonPurchaser@1001 : Record 13;
      CRMSystemuser@1002 : Record 5340;
    BEGIN
      InsertIntegrationTableMapping(
        IntegrationTableMapping,IntegrationTableMappingName,
        DATABASE::"Salesperson/Purchaser",DATABASE::"CRM Systemuser",
        CRMSystemuser.FIELDNO(SystemUserId),CRMSystemuser.FIELDNO(ModifiedOn),
        '','',TRUE);

      CRMSystemuser.RESET;
      CRMSystemuser.SETRANGE(IsDisabled,FALSE);
      CRMSystemuser.SETRANGE(IsLicensed,TRUE);
      CRMSystemuser.SETRANGE(IsIntegrationUser,FALSE);
      IntegrationTableMapping.SetIntegrationTableFilter(
        GetTableFilterFromView(DATABASE::"CRM Systemuser",CRMSystemuser.TABLECAPTION,CRMSystemuser.GETVIEW));
      IntegrationTableMapping.MODIFY;

      // Email > InternalEMailAddress
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        SalespersonPurchaser.FIELDNO("E-Mail"),
        CRMSystemuser.FIELDNO(InternalEMailAddress),
        IntegrationFieldMapping.Direction::FromIntegrationTable,
        '',TRUE,FALSE);

      // Name > FullName
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        SalespersonPurchaser.FIELDNO(Name),
        CRMSystemuser.FIELDNO(FullName),
        IntegrationFieldMapping.Direction::FromIntegrationTable,
        '',TRUE,FALSE);

      // Phone No. > MobilePhone
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        SalespersonPurchaser.FIELDNO("Phone No."),
        CRMSystemuser.FIELDNO(MobilePhone),
        IntegrationFieldMapping.Direction::FromIntegrationTable,
        '',TRUE,FALSE);

      RecreateJobQueueEntryFromIntTableMapping(IntegrationTableMapping,30,ShouldRecreateJobQueueEntry,1440);
    END;

    LOCAL PROCEDURE ResetCustomerAccountMapping@2(IntegrationTableMappingName@1004 : Code[20];ShouldRecreateJobQueueEntry@1003 : Boolean);
    VAR
      IntegrationTableMapping@1005 : Record 5335;
      IntegrationFieldMapping@1000 : Record 5336;
      CRMAccount@1001 : Record 5341;
      Customer@1002 : Record 18;
    BEGIN
      InsertIntegrationTableMapping(
        IntegrationTableMapping,IntegrationTableMappingName,
        DATABASE::Customer,DATABASE::"CRM Account",
        CRMAccount.FIELDNO(AccountId),CRMAccount.FIELDNO(ModifiedOn),
        ResetCustomerConfigTemplate,ResetAccountConfigTemplate,TRUE);

      CRMAccount.SETRANGE(StateCode,CRMAccount.StateCode::Active);
      CRMAccount.SETRANGE(CustomerTypeCode,CRMAccount.CustomerTypeCode::Customer);
      IntegrationTableMapping.SetIntegrationTableFilter(
        GetTableFilterFromView(DATABASE::"CRM Account",CRMAccount.TABLECAPTION,CRMAccount.GETVIEW));
      IntegrationTableMapping."Dependency Filter" := 'SALESPEOPLE|CURRENCY';
      IntegrationTableMapping.MODIFY;

      // Name > Name
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Customer.FIELDNO(Name),
        CRMAccount.FIELDNO(Name),
        IntegrationFieldMapping.Direction::Bidirectional,
        '',TRUE,FALSE);

      // Contact > Address1_PrimaryContactName
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Customer.FIELDNO(Contact),
        CRMAccount.FIELDNO(Address1_PrimaryContactName),
        IntegrationFieldMapping.Direction::FromIntegrationTable,
        '',FALSE,FALSE); // We do not validate contact name.

      // Address > Address1_Line1
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Customer.FIELDNO(Address),
        CRMAccount.FIELDNO(Address1_Line1),
        IntegrationFieldMapping.Direction::Bidirectional,
        '',TRUE,FALSE);

      // Address 2 > Address1_Line2
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Customer.FIELDNO("Address 2"),
        CRMAccount.FIELDNO(Address1_Line2),
        IntegrationFieldMapping.Direction::Bidirectional,
        '',TRUE,FALSE);

      // Post Code > Address1_PostalCode
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Customer.FIELDNO("Post Code"),
        CRMAccount.FIELDNO(Address1_PostalCode),
        IntegrationFieldMapping.Direction::Bidirectional,
        '',TRUE,FALSE);

      // City > Address1_City
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Customer.FIELDNO(City),
        CRMAccount.FIELDNO(Address1_City),
        IntegrationFieldMapping.Direction::Bidirectional,
        '',TRUE,FALSE);

      // Country > Address1_Country
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Customer.FIELDNO("Country/Region Code"),
        CRMAccount.FIELDNO(Address1_Country),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // County > Address1_StateOrProvince
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Customer.FIELDNO(County),
        CRMAccount.FIELDNO(Address1_StateOrProvince),
        IntegrationFieldMapping.Direction::Bidirectional,
        '',TRUE,FALSE);

      // Email > EmailAddress1
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Customer.FIELDNO("E-Mail"),
        CRMAccount.FIELDNO(EMailAddress1),
        IntegrationFieldMapping.Direction::Bidirectional,
        '',TRUE,FALSE);

      // Fax No > Fax
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Customer.FIELDNO("Fax No."),
        CRMAccount.FIELDNO(Fax),
        IntegrationFieldMapping.Direction::Bidirectional,
        '',TRUE,FALSE);

      // Home Page > WebSiteUrl
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Customer.FIELDNO("Home Page"),
        CRMAccount.FIELDNO(WebSiteURL),
        IntegrationFieldMapping.Direction::Bidirectional,
        '',TRUE,FALSE);

      // Phone No. > Telephone1
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Customer.FIELDNO("Phone No."),
        CRMAccount.FIELDNO(Telephone1),
        IntegrationFieldMapping.Direction::Bidirectional,
        '',TRUE,FALSE);

      // Shipment Method Code > address1_freighttermscode
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Customer.FIELDNO("Shipment Method Code"),
        CRMAccount.FIELDNO(Address1_FreightTermsCode),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // Shipping Agent Code > address1_shippingmethodcode
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Customer.FIELDNO("Shipping Agent Code"),
        CRMAccount.FIELDNO(Address1_ShippingMethodCode),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // Payment Terms Code > paymenttermscode
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Customer.FIELDNO("Payment Terms Code"),
        CRMAccount.FIELDNO(PaymentTermsCode),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // Credit Limit (LCY) > creditlimit
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Customer.FIELDNO("Credit Limit (LCY)"),
        CRMAccount.FIELDNO(CreditLimit),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // "Primary Contact No." > PrimaryContactId
      InsertIntegrationFieldMappingWithClearOnFail(
        IntegrationTableMappingName,
        Customer.FIELDNO("Primary Contact No."),
        CRMAccount.FIELDNO(PrimaryContactId),
        IntegrationFieldMapping.Direction::Bidirectional,
        '',TRUE,FALSE);

      RecreateJobQueueEntryFromIntTableMapping(IntegrationTableMapping,2,ShouldRecreateJobQueueEntry,720);
    END;

    LOCAL PROCEDURE ResetContactContactMapping@3(IntegrationTableMappingName@1005 : Code[20];EnqueueJobQueEntry@1003 : Boolean);
    VAR
      IntegrationTableMapping@1006 : Record 5335;
      IntegrationFieldMapping@1000 : Record 5336;
      CRMContact@1001 : Record 5342;
      Contact@1002 : Record 5050;
      EmptyGuid@1004 : GUID;
    BEGIN
      InsertIntegrationTableMapping(
        IntegrationTableMapping,IntegrationTableMappingName,
        DATABASE::Contact,DATABASE::"CRM Contact",
        CRMContact.FIELDNO(ContactId),CRMContact.FIELDNO(ModifiedOn),
        '','',TRUE);

      Contact.RESET;
      Contact.SETRANGE(Type,Contact.Type::Person);
      Contact.SETFILTER("Company No.",'<>''''');
      IntegrationTableMapping.SetTableFilter(GetTableFilterFromView(DATABASE::Contact,Contact.TABLECAPTION,Contact.GETVIEW));

      CRMContact.RESET;
      CRMContact.SETFILTER(ParentCustomerId,'<>''%1''',EmptyGuid);
      CRMContact.SETRANGE(ParentCustomerIdType,CRMContact.ParentCustomerIdType::account);
      IntegrationTableMapping.SetIntegrationTableFilter(
        GetTableFilterFromView(DATABASE::"CRM Contact",CRMContact.TABLECAPTION,CRMContact.GETVIEW));
      IntegrationTableMapping."Dependency Filter" := 'CUSTOMER';
      IntegrationTableMapping.MODIFY;

      // "Currency Code" > TransactionCurrencyId
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Contact.FIELDNO("Currency Code"),
        CRMContact.FIELDNO(TransactionCurrencyId),
        IntegrationFieldMapping.Direction::Bidirectional,
        '',TRUE,FALSE);

      // Address > Address1_Line1
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Contact.FIELDNO(Address),
        CRMContact.FIELDNO(Address1_Line1),
        IntegrationFieldMapping.Direction::Bidirectional,
        '',TRUE,FALSE);

      // Address 2 > Address1_Line2
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Contact.FIELDNO("Address 2"),
        CRMContact.FIELDNO(Address1_Line2),
        IntegrationFieldMapping.Direction::Bidirectional,
        '',TRUE,FALSE);

      // Post Code > Address1_PostalCode
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Contact.FIELDNO("Post Code"),
        CRMContact.FIELDNO(Address1_PostalCode),
        IntegrationFieldMapping.Direction::Bidirectional,
        '',TRUE,FALSE);

      // City > Address1_City
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Contact.FIELDNO(City),
        CRMContact.FIELDNO(Address1_City),
        IntegrationFieldMapping.Direction::Bidirectional,
        '',TRUE,FALSE);

      // Country/Region Code > Address1_Country
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Contact.FIELDNO("Country/Region Code"),
        CRMContact.FIELDNO(Address1_Country),
        IntegrationFieldMapping.Direction::Bidirectional,
        '',TRUE,FALSE);

      // County > Address1_StateOrProvince
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Contact.FIELDNO(County),
        CRMContact.FIELDNO(Address1_StateOrProvince),
        IntegrationFieldMapping.Direction::Bidirectional,
        '',TRUE,FALSE);

      // Email > EmailAddress1
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Contact.FIELDNO("E-Mail"),
        CRMContact.FIELDNO(EMailAddress1),
        IntegrationFieldMapping.Direction::Bidirectional,
        '',TRUE,FALSE);

      // Fax No. > Fax
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Contact.FIELDNO("Fax No."),
        CRMContact.FIELDNO(Fax),
        IntegrationFieldMapping.Direction::Bidirectional,
        '',TRUE,FALSE);

      // First Name > FirstName
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Contact.FIELDNO("First Name"),
        CRMContact.FIELDNO(FirstName),
        IntegrationFieldMapping.Direction::Bidirectional,
        '',TRUE,FALSE);

      // Middle Name > MiddleName
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Contact.FIELDNO("Middle Name"),
        CRMContact.FIELDNO(MiddleName),
        IntegrationFieldMapping.Direction::Bidirectional,
        '',TRUE,FALSE);

      // Surname > LastName
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Contact.FIELDNO(Surname),
        CRMContact.FIELDNO(LastName),
        IntegrationFieldMapping.Direction::Bidirectional,
        '',TRUE,FALSE);

      // Home Page > WebSiteUrl
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Contact.FIELDNO("Home Page"),
        CRMContact.FIELDNO(WebSiteUrl),
        IntegrationFieldMapping.Direction::Bidirectional,
        '',TRUE,FALSE);

      // Mobile Phone No. > MobilePhone
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Contact.FIELDNO("Mobile Phone No."),
        CRMContact.FIELDNO(MobilePhone),
        IntegrationFieldMapping.Direction::Bidirectional,
        '',TRUE,FALSE);

      // Pager > Pager
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Contact.FIELDNO(Pager),
        CRMContact.FIELDNO(Pager),
        IntegrationFieldMapping.Direction::Bidirectional,
        '',TRUE,FALSE);

      // Phone No. > Telephone1
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Contact.FIELDNO("Phone No."),
        CRMContact.FIELDNO(Telephone1),
        IntegrationFieldMapping.Direction::Bidirectional,
        '',TRUE,FALSE);

      // Type
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Contact.FIELDNO(Type),0,
        IntegrationFieldMapping.Direction::FromIntegrationTable,
        FORMAT(Contact.Type::Person),TRUE,FALSE);

      // CRMContact.ParentCustomerIdType::account
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        0,CRMContact.FIELDNO(ParentCustomerIdType),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        FORMAT(CRMContact.ParentCustomerIdType::account),FALSE,FALSE);

      RecreateJobQueueEntryFromIntTableMapping(IntegrationTableMapping,2,EnqueueJobQueEntry,720);
    END;

    LOCAL PROCEDURE ResetCurrencyTransactionCurrencyMapping@10(IntegrationTableMappingName@1002 : Code[20];EnqueueJobQueEntry@1001 : Boolean);
    VAR
      IntegrationTableMapping@1005 : Record 5335;
      IntegrationFieldMapping@1000 : Record 5336;
      Currency@1003 : Record 4;
      CRMTransactioncurrency@1004 : Record 5345;
    BEGIN
      InsertIntegrationTableMapping(
        IntegrationTableMapping,IntegrationTableMappingName,
        DATABASE::Currency,DATABASE::"CRM Transactioncurrency",
        CRMTransactioncurrency.FIELDNO(TransactionCurrencyId),
        CRMTransactioncurrency.FIELDNO(ModifiedOn),
        '',
        '',
        TRUE);

      // Code > ISOCurrencyCode
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Currency.FIELDNO(Code),
        CRMTransactioncurrency.FIELDNO(ISOCurrencyCode),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // Code > CurrencySymbol
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Currency.FIELDNO(Code),
        CRMTransactioncurrency.FIELDNO(CurrencySymbol),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // Description > CurrencyName
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Currency.FIELDNO(Description),
        CRMTransactioncurrency.FIELDNO(CurrencyName),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      RecreateJobQueueEntryFromIntTableMapping(IntegrationTableMapping,2,EnqueueJobQueEntry,720);
    END;

    LOCAL PROCEDURE ResetItemProductMapping@12(IntegrationTableMappingName@1002 : Code[20];EnqueueJobQueEntry@1001 : Boolean);
    VAR
      IntegrationTableMapping@1005 : Record 5335;
      IntegrationFieldMapping@1000 : Record 5336;
      Item@1003 : Record 27;
      CRMProduct@1004 : Record 5348;
    BEGIN
      InsertIntegrationTableMapping(
        IntegrationTableMapping,IntegrationTableMappingName,
        DATABASE::Item,DATABASE::"CRM Product",
        CRMProduct.FIELDNO(ProductId),CRMProduct.FIELDNO(ModifiedOn),
        '','',TRUE);

      IntegrationTableMapping."Dependency Filter" := 'UNIT OF MEASURE';
      SetIntegrationTableFilterForCRMProduct(IntegrationTableMapping,CRMProduct,CRMProduct.ProductTypeCode::SalesInventory);

      // "No." > ProductNumber
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Item.FIELDNO("No."),
        CRMProduct.FIELDNO(ProductNumber),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // Description > Name
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Item.FIELDNO(Description),
        CRMProduct.FIELDNO(Name),
        IntegrationFieldMapping.Direction::Bidirectional,
        '',TRUE,FALSE);

      // Unit Price > Price
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Item.FIELDNO("Unit Price"),
        CRMProduct.FIELDNO(Price),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // Unit Cost > Standard Cost
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Item.FIELDNO("Unit Cost"),
        CRMProduct.FIELDNO(StandardCost),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // Unit Cost > Current Cost
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Item.FIELDNO("Unit Cost"),
        CRMProduct.FIELDNO(CurrentCost),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // Unit Volume > Stock Volume
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Item.FIELDNO("Unit Volume"),
        CRMProduct.FIELDNO(StockVolume),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // Gross Weight > Stock Weight
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Item.FIELDNO("Gross Weight"),
        CRMProduct.FIELDNO(StockWeight),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // Vendor No. > Vendor ID
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Item.FIELDNO("Vendor No."),
        CRMProduct.FIELDNO(VendorID),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // Vendor Item No. > Vendor part number
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Item.FIELDNO("Vendor Item No."),
        CRMProduct.FIELDNO(VendorPartNumber),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // Inventory > Quantity on Hand. If less then zero, it will later be set to zero
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Item.FIELDNO(Inventory),
        CRMProduct.FIELDNO(QuantityOnHand),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // Base Unit of Measure > DefaultUoMScheduleId
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Item.FIELDNO("Base Unit of Measure"),
        CRMProduct.FIELDNO(DefaultUoMScheduleId),
        IntegrationFieldMapping.Direction::Bidirectional,
        '',TRUE,FALSE);

      RecreateJobQueueEntryFromIntTableMapping(IntegrationTableMapping,30,EnqueueJobQueEntry,1440);
    END;

    LOCAL PROCEDURE ResetResourceProductMapping@13(IntegrationTableMappingName@1002 : Code[20];EnqueueJobQueEntry@1001 : Boolean);
    VAR
      IntegrationTableMapping@1005 : Record 5335;
      IntegrationFieldMapping@1000 : Record 5336;
      Resource@1003 : Record 156;
      CRMProduct@1004 : Record 5348;
    BEGIN
      InsertIntegrationTableMapping(
        IntegrationTableMapping,IntegrationTableMappingName,
        DATABASE::Resource,DATABASE::"CRM Product",
        CRMProduct.FIELDNO(ProductId),CRMProduct.FIELDNO(ModifiedOn),
        '','',TRUE);

      IntegrationTableMapping."Dependency Filter" := 'UNIT OF MEASURE';
      SetIntegrationTableFilterForCRMProduct(IntegrationTableMapping,CRMProduct,CRMProduct.ProductTypeCode::Services);

      // "No." > ProductNumber
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Resource.FIELDNO("No."),
        CRMProduct.FIELDNO(ProductNumber),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // Name > Name
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Resource.FIELDNO(Name),
        CRMProduct.FIELDNO(Name),
        IntegrationFieldMapping.Direction::Bidirectional,
        '',TRUE,FALSE);

      // Unit Price > Price
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Resource.FIELDNO("Unit Price"),
        CRMProduct.FIELDNO(Price),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // Unit Cost > Standard Cost
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Resource.FIELDNO("Unit Cost"),
        CRMProduct.FIELDNO(StandardCost),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // Unit Cost > Current Cost
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Resource.FIELDNO("Unit Cost"),
        CRMProduct.FIELDNO(CurrentCost),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // Vendor No. > Vendor ID
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Resource.FIELDNO("Vendor No."),
        CRMProduct.FIELDNO(VendorID),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // Capacity > Quantity on Hand. If less then zero, it will later be set to zero
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Resource.FIELDNO(Capacity),
        CRMProduct.FIELDNO(QuantityOnHand),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      RecreateJobQueueEntryFromIntTableMapping(IntegrationTableMapping,2,EnqueueJobQueEntry,720);
    END;

    LOCAL PROCEDURE ResetSalesInvoiceHeaderInvoiceMapping@23(IntegrationTableMappingName@1002 : Code[20];EnqueueJobQueEntry@1001 : Boolean);
    VAR
      IntegrationTableMapping@1005 : Record 5335;
      IntegrationFieldMapping@1000 : Record 5336;
      SalesInvoiceHeader@1003 : Record 112;
      CRMInvoice@1004 : Record 5355;
    BEGIN
      InsertIntegrationTableMapping(
        IntegrationTableMapping,IntegrationTableMappingName,
        DATABASE::"Sales Invoice Header",DATABASE::"CRM Invoice",
        CRMInvoice.FIELDNO(InvoiceId),CRMInvoice.FIELDNO(ModifiedOn),
        '','',TRUE);
      IntegrationTableMapping."Dependency Filter" := 'OPPORTUNITY';
      IntegrationTableMapping.MODIFY;

      // "No." > InvoiceNumber
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        SalesInvoiceHeader.FIELDNO("No."),
        CRMInvoice.FIELDNO(InvoiceNumber),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // "Currency Code" > TransactionCurrencyId
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        SalesInvoiceHeader.FIELDNO("Currency Code"),
        CRMInvoice.FIELDNO(TransactionCurrencyId),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // "Due Date" > DueDate
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        SalesInvoiceHeader.FIELDNO("Due Date"),
        CRMInvoice.FIELDNO(DueDate),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // Ship-to Name
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        SalesInvoiceHeader.FIELDNO("Ship-to Name"),
        CRMInvoice.FIELDNO(ShipTo_Name),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // Ship-to Address
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        SalesInvoiceHeader.FIELDNO("Ship-to Address"),
        CRMInvoice.FIELDNO(ShipTo_Line1),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // Ship-to Address 2
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        SalesInvoiceHeader.FIELDNO("Ship-to Address 2"),
        CRMInvoice.FIELDNO(ShipTo_Line2),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // Ship-to City
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        SalesInvoiceHeader.FIELDNO("Ship-to City"),
        CRMInvoice.FIELDNO(ShipTo_City),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // "Ship-to Country/Region Code"
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        SalesInvoiceHeader.FIELDNO("Ship-to Country/Region Code"),
        CRMInvoice.FIELDNO(ShipTo_Country),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // "Ship-to Post Code"
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        SalesInvoiceHeader.FIELDNO("Ship-to Post Code"),
        CRMInvoice.FIELDNO(ShipTo_PostalCode),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // "Ship-to County"
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        SalesInvoiceHeader.FIELDNO("Ship-to County"),
        CRMInvoice.FIELDNO(ShipTo_StateOrProvince),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // "Shipment Date"
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        SalesInvoiceHeader.FIELDNO("Shipment Date"),
        CRMInvoice.FIELDNO(DateDelivered),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // Bill-to Name
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        SalesInvoiceHeader.FIELDNO("Bill-to Name"),
        CRMInvoice.FIELDNO(BillTo_Name),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // Bill-to Address
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        SalesInvoiceHeader.FIELDNO("Bill-to Address"),
        CRMInvoice.FIELDNO(BillTo_Line1),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // Bill-to Address 2
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        SalesInvoiceHeader.FIELDNO("Bill-to Address 2"),
        CRMInvoice.FIELDNO(BillTo_Line2),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // Bill-to City
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        SalesInvoiceHeader.FIELDNO("Bill-to City"),
        CRMInvoice.FIELDNO(BillTo_City),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // Bill-to Country/Region Code
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        SalesInvoiceHeader.FIELDNO("Bill-to Country/Region Code"),
        CRMInvoice.FIELDNO(BillTo_Country),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // "Bill-to Post Code"
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        SalesInvoiceHeader.FIELDNO("Bill-to Post Code"),
        CRMInvoice.FIELDNO(BillTo_PostalCode),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // "Bill-to County"
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        SalesInvoiceHeader.FIELDNO("Bill-to County"),
        CRMInvoice.FIELDNO(BillTo_StateOrProvince),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // Amount > TotalAmountLessFreight
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        SalesInvoiceHeader.FIELDNO(Amount),
        CRMInvoice.FIELDNO(TotalAmountLessFreight),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // "Amount Including VAT" > TotalAmount
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        SalesInvoiceHeader.FIELDNO("Amount Including VAT"),
        CRMInvoice.FIELDNO(TotalAmount),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // "Invoice Discount Amount" > DiscountAmount
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        SalesInvoiceHeader.FIELDNO("Invoice Discount Amount"),
        CRMInvoice.FIELDNO(DiscountAmount),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // Shipping Agent Code > address1_shippingmethodcode
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        SalesInvoiceHeader.FIELDNO("Shipping Agent Code"),
        CRMInvoice.FIELDNO(ShippingMethodCode),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // Payment Terms Code > paymenttermscode
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        SalesInvoiceHeader.FIELDNO("Payment Terms Code"),
        CRMInvoice.FIELDNO(PaymentTermsCode),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      RecreateJobQueueEntryFromIntTableMapping(IntegrationTableMapping,30,EnqueueJobQueEntry,1440);
    END;

    LOCAL PROCEDURE ResetSalesInvoiceLineInvoiceMapping@25(IntegrationTableMappingName@1001 : Code[20]);
    VAR
      IntegrationTableMapping@1002 : Record 5335;
      IntegrationFieldMapping@1000 : Record 5336;
      SalesInvoiceLine@1003 : Record 113;
      CRMInvoicedetail@1004 : Record 5356;
    BEGIN
      InsertIntegrationTableMapping(
        IntegrationTableMapping,IntegrationTableMappingName,
        DATABASE::"Sales Invoice Line",DATABASE::"CRM Invoicedetail",
        CRMInvoicedetail.FIELDNO(InvoiceDetailId),CRMInvoicedetail.FIELDNO(ModifiedOn),
        '','',FALSE);
      IntegrationTableMapping."Dependency Filter" := 'POSTEDSALESINV-INV';
      IntegrationTableMapping.MODIFY;

      // Quantity -> Quantity
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        SalesInvoiceLine.FIELDNO(Quantity),
        CRMInvoicedetail.FIELDNO(Quantity),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // "Line Discount Amount" -> "Manual Discount Amount"
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        SalesInvoiceLine.FIELDNO("Line Discount Amount"),
        CRMInvoicedetail.FIELDNO(ManualDiscountAmount),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // "Unit Price" > PricePerUnit
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        SalesInvoiceLine.FIELDNO("Unit Price"),
        CRMInvoicedetail.FIELDNO(PricePerUnit),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // TRUE > IsPriceOverridden
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        0,
        CRMInvoicedetail.FIELDNO(IsPriceOverridden),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '1',TRUE,FALSE);

      // Amount -> BaseAmount
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        SalesInvoiceLine.FIELDNO(Amount),
        CRMInvoicedetail.FIELDNO(BaseAmount),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // "Amount Including VAT" -> ExtendedAmount
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        SalesInvoiceLine.FIELDNO("Amount Including VAT"),
        CRMInvoicedetail.FIELDNO(ExtendedAmount),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);
    END;

    LOCAL PROCEDURE ResetCustomerPriceGroupPricelevelMapping@28(IntegrationTableMappingName@1002 : Code[20];EnqueueJobQueEntry@1001 : Boolean);
    VAR
      IntegrationTableMapping@1005 : Record 5335;
      IntegrationFieldMapping@1000 : Record 5336;
      CustomerPriceGroup@1003 : Record 6;
      CRMPricelevel@1004 : Record 5346;
    BEGIN
      InsertIntegrationTableMapping(
        IntegrationTableMapping,IntegrationTableMappingName,
        DATABASE::"Customer Price Group",DATABASE::"CRM Pricelevel",
        CRMPricelevel.FIELDNO(PriceLevelId),CRMPricelevel.FIELDNO(ModifiedOn),
        '','',TRUE);
      IntegrationTableMapping."Dependency Filter" := 'CURRENCY';
      IntegrationTableMapping.MODIFY;

      // Code > Name
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        CustomerPriceGroup.FIELDNO(Code),
        CRMPricelevel.FIELDNO(Name),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      RecreateJobQueueEntryFromIntTableMapping(IntegrationTableMapping,30,EnqueueJobQueEntry,1440);
    END;

    LOCAL PROCEDURE ResetSalesPriceProductPricelevelMapping@27(IntegrationTableMappingName@1001 : Code[20];EnqueueJobQueEntry@1005 : Boolean);
    VAR
      IntegrationTableMapping@1002 : Record 5335;
      IntegrationFieldMapping@1000 : Record 5336;
      SalesPrice@1003 : Record 7002;
      CRMProductpricelevel@1004 : Record 5347;
    BEGIN
      InsertIntegrationTableMapping(
        IntegrationTableMapping,IntegrationTableMappingName,
        DATABASE::"Sales Price",DATABASE::"CRM Productpricelevel",
        CRMProductpricelevel.FIELDNO(ProductPriceLevelId),CRMProductpricelevel.FIELDNO(ModifiedOn),
        '','',FALSE);

      SalesPrice.RESET;
      SalesPrice.SETRANGE("Sales Type",SalesPrice."Sales Type"::"Customer Price Group");
      SalesPrice.SETFILTER("Sales Code",'<>''''');
      IntegrationTableMapping.SetTableFilter(
        GetTableFilterFromView(DATABASE::"Sales Price",SalesPrice.TABLECAPTION,SalesPrice.GETVIEW));

      IntegrationTableMapping."Dependency Filter" := 'CUSTPRCGRP-PRICE|ITEM-PRODUCT';
      IntegrationTableMapping.MODIFY;

      // "Sales Code" > PriceLevelId
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        SalesPrice.FIELDNO("Sales Code"),
        CRMProductpricelevel.FIELDNO(PriceLevelId),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // "Item No." > ProductId
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        SalesPrice.FIELDNO("Item No."),
        CRMProductpricelevel.FIELDNO(ProductId),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // "Item No." > ProductNumber
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        SalesPrice.FIELDNO("Item No."),
        CRMProductpricelevel.FIELDNO(ProductNumber),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // "Currency Code" > TransactionCurrencyId
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        SalesPrice.FIELDNO("Currency Code"),
        CRMProductpricelevel.FIELDNO(TransactionCurrencyId),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // >> PricingMethodCode = CurrencyAmount
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        0,CRMProductpricelevel.FIELDNO(PricingMethodCode),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        FORMAT(CRMProductpricelevel.PricingMethodCode::CurrencyAmount),FALSE,FALSE);

      // "Unit Price" > Amount
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        SalesPrice.FIELDNO("Unit Price"),
        CRMProductpricelevel.FIELDNO(Amount),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      RecreateJobQueueEntryFromIntTableMapping(IntegrationTableMapping,30,EnqueueJobQueEntry,1440);
    END;

    LOCAL PROCEDURE ResetUnitOfMeasureUoMScheduleMapping@11(IntegrationTableMappingName@1002 : Code[20];EnqueueJobQueEntry@1001 : Boolean);
    VAR
      IntegrationTableMapping@1005 : Record 5335;
      IntegrationFieldMapping@1000 : Record 5336;
      UnitOfMeasure@1003 : Record 204;
      CRMUomschedule@1004 : Record 5362;
    BEGIN
      InsertIntegrationTableMapping(
        IntegrationTableMapping,IntegrationTableMappingName,
        DATABASE::"Unit of Measure",DATABASE::"CRM Uomschedule",
        CRMUomschedule.FIELDNO(UoMScheduleId),CRMUomschedule.FIELDNO(ModifiedOn),
        '','',TRUE);

      // Code > BaseUoM Name
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        UnitOfMeasure.FIELDNO(Code),
        CRMUomschedule.FIELDNO(BaseUoMName),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      RecreateJobQueueEntryFromIntTableMapping(IntegrationTableMapping,2,EnqueueJobQueEntry,720);
    END;

    LOCAL PROCEDURE ResetShippingAgentMapping@35(IntegrationTableMappingName@1003 : Code[20]);
    VAR
      IntegrationTableMapping@1004 : Record 5335;
      IntegrationFieldMapping@1002 : Record 5336;
      ShippingAgent@1000 : Record 291;
      CRMAccount@1001 : Record 5341;
      CRMIntegrationTableSynch@1005 : Codeunit 5340;
    BEGIN
      InsertIntegrationTableMapping(
        IntegrationTableMapping,IntegrationTableMappingName,
        DATABASE::"Shipping Agent",DATABASE::"CRM Account",
        CRMAccount.FIELDNO(Address1_ShippingMethodCode),0,
        '','',FALSE);

      // Code > "CRM Account".Address1_ShippingMethodCode
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        ShippingAgent.FIELDNO(Code),
        CRMAccount.FIELDNO(Address1_ShippingMethodCode),
        IntegrationFieldMapping.Direction::FromIntegrationTable,
        '',TRUE,FALSE);

      CRMIntegrationTableSynch.SynchOption(IntegrationTableMapping);
    END;

    LOCAL PROCEDURE ResetShipmentMethodMapping@38(IntegrationTableMappingName@1003 : Code[20]);
    VAR
      IntegrationTableMapping@1004 : Record 5335;
      IntegrationFieldMapping@1002 : Record 5336;
      ShipmentMethod@1000 : Record 10;
      CRMAccount@1001 : Record 5341;
      CRMIntegrationTableSynch@1005 : Codeunit 5340;
    BEGIN
      InsertIntegrationTableMapping(
        IntegrationTableMapping,IntegrationTableMappingName,
        DATABASE::"Shipment Method",DATABASE::"CRM Account",
        CRMAccount.FIELDNO(Address1_FreightTermsCode),0,
        '','',FALSE);

      // Code > "CRM Account".Address1_FreightTermsCode
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        ShipmentMethod.FIELDNO(Code),
        CRMAccount.FIELDNO(Address1_FreightTermsCode),
        IntegrationFieldMapping.Direction::FromIntegrationTable,
        '',TRUE,FALSE);

      CRMIntegrationTableSynch.SynchOption(IntegrationTableMapping);
    END;

    LOCAL PROCEDURE ResetPaymentTermsMapping@39(IntegrationTableMappingName@1003 : Code[20]);
    VAR
      IntegrationTableMapping@1004 : Record 5335;
      IntegrationFieldMapping@1002 : Record 5336;
      PaymentTerms@1000 : Record 3;
      CRMAccount@1001 : Record 5341;
      CRMIntegrationTableSynch@1005 : Codeunit 5340;
    BEGIN
      InsertIntegrationTableMapping(
        IntegrationTableMapping,IntegrationTableMappingName,
        DATABASE::"Payment Terms",DATABASE::"CRM Account",
        CRMAccount.FIELDNO(PaymentTermsCode),0,
        '','',FALSE);

      // Code > "CRM Account".PaymentTermsCode
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        PaymentTerms.FIELDNO(Code),
        CRMAccount.FIELDNO(PaymentTermsCode),
        IntegrationFieldMapping.Direction::FromIntegrationTable,
        '',TRUE,FALSE);

      CRMIntegrationTableSynch.SynchOption(IntegrationTableMapping);
    END;

    LOCAL PROCEDURE ResetOpportunityMapping@37(IntegrationTableMappingName@1003 : Code[20]);
    VAR
      IntegrationTableMapping@1004 : Record 5335;
      IntegrationFieldMapping@1002 : Record 5336;
      Opportunity@1000 : Record 5092;
      CRMOpportunity@1001 : Record 5343;
      CRMIntegrationTableSynch@1005 : Codeunit 5340;
    BEGIN
      InsertIntegrationTableMapping(
        IntegrationTableMapping,IntegrationTableMappingName,
        DATABASE::Opportunity,DATABASE::"CRM Opportunity",
        CRMOpportunity.FIELDNO(OpportunityId),CRMOpportunity.FIELDNO(ModifiedOn),
        '','',FALSE);
      IntegrationTableMapping."Dependency Filter" := 'CONTACT';
      IntegrationTableMapping.MODIFY;

      // Description > Name
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Opportunity.FIELDNO(Description),
        CRMOpportunity.FIELDNO(Name),
        IntegrationFieldMapping.Direction::Bidirectional,
        '',TRUE,FALSE);

      // "Contact No." > ParentContactId
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Opportunity.FIELDNO("Contact No."),
        CRMOpportunity.FIELDNO(ParentContactId),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // OwnerId = systemuser
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        0,CRMOpportunity.FIELDNO(OwnerIdType),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        FORMAT(CRMOpportunity.OwnerIdType::systemuser),FALSE,FALSE);

      // "Salesperson Code" > OwnerId
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Opportunity.FIELDNO("Salesperson Code"),
        CRMOpportunity.FIELDNO(OwnerId),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // "Estimated Value (LCY)" > EstimatedValue
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Opportunity.FIELDNO("Estimated Value (LCY)"),
        CRMOpportunity.FIELDNO(EstimatedValue),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      // "Estimated Closing Date" > EstimatedCloseDate
      InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Opportunity.FIELDNO("Estimated Closing Date"),
        CRMOpportunity.FIELDNO(EstimatedCloseDate),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '',TRUE,FALSE);

      CRMIntegrationTableSynch.SynchOption(IntegrationTableMapping);
    END;

    LOCAL PROCEDURE InsertIntegrationTableMapping@5(VAR IntegrationTableMapping@1008 : Record 5335;MappingName@1000 : Code[20];TableNo@1001 : Integer;IntegrationTableNo@1002 : Integer;IntegrationTableUIDFieldNo@1005 : Integer;IntegrationTableModifiedFieldNo@1006 : Integer;TableConfigTemplateCode@1003 : Code[10];IntegrationTableConfigTemplateCode@1007 : Code[10];SynchOnlyCoupledRecords@1009 : Boolean);
    BEGIN
      IntegrationTableMapping.CreateRecord(MappingName,TableNo,IntegrationTableNo,IntegrationTableUIDFieldNo,
        IntegrationTableModifiedFieldNo,TableConfigTemplateCode,IntegrationTableConfigTemplateCode,
        SynchOnlyCoupledRecords,GetDefaultDirection(TableNo),IntegrationTablePrefixTok);
    END;

    LOCAL PROCEDURE InsertIntegrationFieldMapping@1(IntegrationTableMappingName@1000 : Code[20];TableFieldNo@1001 : Integer;IntegrationTableFieldNo@1002 : Integer;SynchDirection@1004 : Option;ConstValue@1005 : Text;ValidateField@1003 : Boolean;ValidateIntegrationTableField@1006 : Boolean);
    VAR
      IntegrationFieldMapping@1007 : Record 5336;
    BEGIN
      IntegrationFieldMapping.CreateRecord(IntegrationTableMappingName,TableFieldNo,IntegrationTableFieldNo,SynchDirection,
        ConstValue,ValidateField,ValidateIntegrationTableField);
    END;

    LOCAL PROCEDURE InsertIntegrationFieldMappingWithClearOnFail@45(IntegrationTableMappingName@1000 : Code[20];TableFieldNo@1001 : Integer;IntegrationTableFieldNo@1002 : Integer;SynchDirection@1004 : Option;ConstValue@1005 : Text;ValidateField@1003 : Boolean;ValidateIntegrationTableField@1006 : Boolean);
    VAR
      IntegrationFieldMapping@1007 : Record 5336;
    BEGIN
      IntegrationFieldMapping.CreateRecord(IntegrationTableMappingName,TableFieldNo,IntegrationTableFieldNo,SynchDirection,
        ConstValue,ValidateField,ValidateIntegrationTableField);
      IntegrationFieldMapping."Clear Value on Failed Sync" := TRUE;
      IntegrationFieldMapping.MODIFY;
    END;

    [External]
    PROCEDURE CreateJobQueueEntry@36(IntegrationTableMapping@1003 : Record 5335) : Boolean;
    VAR
      JobQueueEntry@1001 : Record 472;
    BEGIN
      WITH JobQueueEntry DO BEGIN
        INIT;
        CLEAR(ID); // "Job Queue - Enqueue" is to define new ID
        "Earliest Start Date/Time" := CURRENTDATETIME + 1000;
        "Object Type to Run" := "Object Type to Run"::Codeunit;
        "Object ID to Run" := CODEUNIT::"Integration Synch. Job Runner";
        "Record ID to Process" := IntegrationTableMapping.RECORDID;
        "Run in User Session" := FALSE;
        "Notify On Success" := FALSE;
        "Maximum No. of Attempts to Run" := 2;
        Status := Status::Ready;
        "Rerun Delay (sec.)" := 30;
        Description :=
          COPYSTR(
            STRSUBSTNO(
              JobQueueEntryNameTok,IntegrationTableMapping.GetTempDescription,CRMProductName.SHORT),1,MAXSTRLEN(Description));
        EXIT(CODEUNIT.RUN(CODEUNIT::"Job Queue - Enqueue",JobQueueEntry))
      END;
    END;

    LOCAL PROCEDURE RecreateStatisticsJobQueueEntry@14(EnqueueJobQueEntry@1001 : Boolean);
    BEGIN
      RecreateJobQueueEntry(
        EnqueueJobQueEntry,
        CODEUNIT::"CRM Statistics Job",
        30,
        STRSUBSTNO(CustomStatisticsSynchJobDescTxt,CRMProductName.SHORT),
        FALSE);
    END;

    LOCAL PROCEDURE RecreateJobQueueEntryFromIntTableMapping@8(IntegrationTableMapping@1003 : Record 5335;IntervalInMinutes@1002 : Integer;ShouldRecreateJobQueueEntry@1000 : Boolean;InactivityTimeoutPeriod@1004 : Integer);
    VAR
      JobQueueEntry@1001 : Record 472;
    BEGIN
      WITH JobQueueEntry DO BEGIN
        SETRANGE("Object Type to Run","Object Type to Run"::Codeunit);
        SETRANGE("Object ID to Run",CODEUNIT::"Integration Synch. Job Runner");
        SETRANGE("Record ID to Process",IntegrationTableMapping.RECORDID);
        DeleteTasks;

        InitRecurringJob(IntervalInMinutes);
        "Object Type to Run" := "Object Type to Run"::Codeunit;
        "Object ID to Run" := CODEUNIT::"Integration Synch. Job Runner";
        "Record ID to Process" := IntegrationTableMapping.RECORDID;
        "Run in User Session" := FALSE;
        Priority := 1000;
        Description :=
          COPYSTR(STRSUBSTNO(JobQueueEntryNameTok,IntegrationTableMapping.Name,CRMProductName.SHORT),1,MAXSTRLEN(Description));
        "Maximum No. of Attempts to Run" := 10;
        Status := Status::Ready;
        "Rerun Delay (sec.)" := 30;
        "Inactivity Timeout Period" := InactivityTimeoutPeriod;
        IF ShouldRecreateJobQueueEntry THEN
          CODEUNIT.RUN(CODEUNIT::"Job Queue - Enqueue",JobQueueEntry)
        ELSE
          INSERT(TRUE);
      END;
    END;

    [Internal]
    PROCEDURE ResetCRMNAVConnectionData@19();
    VAR
      CRMIntegrationManagement@1000 : Codeunit 5330;
    BEGIN
      CRMIntegrationManagement.SetCRMNAVConnectionUrl(GETURL(CLIENTTYPE::Web));
      CRMIntegrationManagement.SetCRMNAVODataUrlCredentials(
        CRMIntegrationManagement.GetItemAvailabilityWebServiceURL,'','');
    END;

    PROCEDURE RecreateAutoCreateSalesOrdersJobQueueEntry@42(EnqueueJobQueEntry@1001 : Boolean);
    BEGIN
      RecreateJobQueueEntry(
        EnqueueJobQueEntry,
        CODEUNIT::"Auto Create Sales Orders",
        2,
        STRSUBSTNO(AutoCreateSalesOrdersTxt,CRMProductName.SHORT),
        FALSE);
    END;

    LOCAL PROCEDURE RecreateJobQueueEntry@40(EnqueueJobQueEntry@1001 : Boolean;CodeunitId@1005 : Integer;MinutesBetweenRun@1002 : Integer;EntryDescription@1003 : Text;StatusReady@1004 : Boolean);
    VAR
      JobQueueEntry@1000 : Record 472;
    BEGIN
      WITH JobQueueEntry DO BEGIN
        SETRANGE("Object Type to Run","Object Type to Run"::Codeunit);
        SETRANGE("Object ID to Run",CodeunitId);
        DeleteTasks;

        InitRecurringJob(MinutesBetweenRun);
        "Object Type to Run" := "Object Type to Run"::Codeunit;
        "Object ID to Run" := CodeunitId;
        Priority := 1000;
        Description := COPYSTR(EntryDescription,1,MAXSTRLEN(Description));
        "Maximum No. of Attempts to Run" := 2;
        IF StatusReady THEN
          Status := Status::Ready
        ELSE
          Status := Status::"On Hold";
        "Rerun Delay (sec.)" := 30;
        IF EnqueueJobQueEntry THEN
          CODEUNIT.RUN(CODEUNIT::"Job Queue - Enqueue",JobQueueEntry)
        ELSE
          INSERT(TRUE);
      END;
    END;

    PROCEDURE DeleteAutoCreateSalesOrdersJobQueueEntry@41();
    VAR
      JobQueueEntry@1000 : Record 472;
    BEGIN
      WITH JobQueueEntry DO BEGIN
        SETRANGE("Object Type to Run","Object Type to Run"::Codeunit);
        SETRANGE("Object ID to Run",CODEUNIT::"Auto Create Sales Orders");
        DeleteTasks;
      END;
    END;

    [External]
    PROCEDURE GetAddPostedSalesDocumentToCRMAccountWallConfig@4() : Boolean;
    BEGIN
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE GetAllowNonSecureConnections@20() : Boolean;
    BEGIN
      // Most OnPrem solutions uses http if running in a private domain. CRM Server only demands https if the system has been
      // configured with internet connectivity, which is not the default. NAV Should not contrain the connection to CRM if the system
      // admin has configured the CRM service to be on a private domain only.
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE GetCRMTableNo@32(NAVTableID@1000 : Integer) : Integer;
    BEGIN
      CASE NAVTableID OF
        DATABASE::Contact:
          EXIT(DATABASE::"CRM Contact");
        DATABASE::Currency:
          EXIT(DATABASE::"CRM Transactioncurrency");
        DATABASE::Customer:
          EXIT(DATABASE::"CRM Account");
        DATABASE::"Customer Price Group":
          EXIT(DATABASE::"CRM Pricelevel");
        DATABASE::Item,
        DATABASE::Resource:
          EXIT(DATABASE::"CRM Product");
        DATABASE::"Sales Invoice Header":
          EXIT(DATABASE::"CRM Invoice");
        DATABASE::"Sales Invoice Line":
          EXIT(DATABASE::"CRM Invoicedetail");
        DATABASE::"Sales Price":
          EXIT(DATABASE::"CRM Productpricelevel");
        DATABASE::"Salesperson/Purchaser":
          EXIT(DATABASE::"CRM Systemuser");
        DATABASE::"Unit of Measure":
          EXIT(DATABASE::"CRM Uomschedule");
        DATABASE::Opportunity:
          EXIT(DATABASE::"CRM Opportunity");
      END;
    END;

    [External]
    PROCEDURE GetDefaultDirection@33(NAVTableID@1000 : Integer) : Integer;
    VAR
      IntegrationTableMapping@1001 : Record 5335;
    BEGIN
      CASE NAVTableID OF
        DATABASE::Contact,
        DATABASE::Customer,
        DATABASE::Item,
        DATABASE::Resource,
        DATABASE::Opportunity:
          EXIT(IntegrationTableMapping.Direction::Bidirectional);
        DATABASE::Currency,
        DATABASE::"Customer Price Group",
        DATABASE::"Sales Invoice Header",
        DATABASE::"Sales Invoice Line",
        DATABASE::"Sales Price",
        DATABASE::"Unit of Measure":
          EXIT(IntegrationTableMapping.Direction::ToIntegrationTable);
        DATABASE::"Payment Terms",
        DATABASE::"Shipment Method",
        DATABASE::"Shipping Agent",
        DATABASE::"Salesperson/Purchaser":
          EXIT(IntegrationTableMapping.Direction::FromIntegrationTable);
      END;
    END;

    [External]
    PROCEDURE GetProductQuantityPrecision@16() : Integer;
    BEGIN
      EXIT(2);
    END;

    [External]
    PROCEDURE GetNameFieldNo@34(TableID@1000 : Integer) : Integer;
    VAR
      Contact@1001 : Record 5050;
      CRMContact@1002 : Record 5342;
      Currency@1003 : Record 4;
      CRMTransactioncurrency@1004 : Record 5345;
      Customer@1005 : Record 18;
      CRMAccount@1006 : Record 5341;
      CustomerPriceGroup@1007 : Record 6;
      CRMPricelevel@1008 : Record 5346;
      Item@1009 : Record 27;
      Resource@1010 : Record 156;
      CRMProduct@1011 : Record 5348;
      SalespersonPurchaser@1018 : Record 13;
      CRMSystemuser@1019 : Record 5340;
      UnitOfMeasure@1020 : Record 204;
      CRMUomschedule@1021 : Record 5362;
      Opportunity@1012 : Record 5092;
      CRMOpportunity@1013 : Record 5343;
    BEGIN
      CASE TableID OF
        DATABASE::Contact:
          EXIT(Contact.FIELDNO(Name));
        DATABASE::"CRM Contact":
          EXIT(CRMContact.FIELDNO(FullName));
        DATABASE::Currency:
          EXIT(Currency.FIELDNO(Code));
        DATABASE::"CRM Transactioncurrency":
          EXIT(CRMTransactioncurrency.FIELDNO(ISOCurrencyCode));
        DATABASE::Customer:
          EXIT(Customer.FIELDNO(Name));
        DATABASE::"CRM Account":
          EXIT(CRMAccount.FIELDNO(Name));
        DATABASE::"Customer Price Group":
          EXIT(CustomerPriceGroup.FIELDNO(Code));
        DATABASE::"CRM Pricelevel":
          EXIT(CRMPricelevel.FIELDNO(Name));
        DATABASE::Item:
          EXIT(Item.FIELDNO("No."));
        DATABASE::Resource:
          EXIT(Resource.FIELDNO("No."));
        DATABASE::"CRM Product":
          EXIT(CRMProduct.FIELDNO(ProductNumber));
        DATABASE::"Salesperson/Purchaser":
          EXIT(SalespersonPurchaser.FIELDNO(Name));
        DATABASE::"CRM Systemuser":
          EXIT(CRMSystemuser.FIELDNO(FullName));
        DATABASE::"Unit of Measure":
          EXIT(UnitOfMeasure.FIELDNO(Code));
        DATABASE::"CRM Uomschedule":
          EXIT(CRMUomschedule.FIELDNO(Name));
        DATABASE::Opportunity:
          EXIT(Opportunity.FIELDNO(Description));
        DATABASE::"CRM Opportunity":
          EXIT(CRMOpportunity.FIELDNO(Name));
      END;
    END;

    LOCAL PROCEDURE GetTableFilterFromView@18(TableID@1000 : Integer;Caption@1001 : Text;View@1002 : Text) : Text;
    VAR
      FilterBuilder@1003 : FilterPageBuilder;
    BEGIN
      FilterBuilder.ADDTABLE(Caption,TableID);
      FilterBuilder.SETVIEW(Caption,View);
      EXIT(FilterBuilder.GETVIEW(Caption,TRUE));
    END;

    [External]
    PROCEDURE GetPrioritizedMappingList@21(VAR NameValueBuffer@1000 : Record 823);
    VAR
      Field@1003 : Record 2000000041;
      IntegrationTableMapping@1001 : Record 5335;
      NextPriority@1002 : Integer;
    BEGIN
      NextPriority := 1;

      // 1) From CRM Systemusers
      AddPrioritizedMappingsToList(NameValueBuffer,NextPriority,0,DATABASE::"CRM Systemuser");
      // 2) From Currency
      AddPrioritizedMappingsToList(NameValueBuffer,NextPriority,DATABASE::Currency,0);
      // 3) From Unit of measure
      AddPrioritizedMappingsToList(NameValueBuffer,NextPriority,DATABASE::"Unit of Measure",0);
      // 4) To/From Customers/CRM Accounts
      AddPrioritizedMappingsToList(NameValueBuffer,NextPriority,DATABASE::Customer,DATABASE::"CRM Account");
      // 5) To/From Contacts/CRM Contacts
      AddPrioritizedMappingsToList(NameValueBuffer,NextPriority,DATABASE::Contact,DATABASE::"CRM Contact");
      // 6) From Items to CRM Products
      AddPrioritizedMappingsToList(NameValueBuffer,NextPriority,DATABASE::Item,DATABASE::"CRM Product");
      // 7) From Resources to CRM Products
      AddPrioritizedMappingsToList(NameValueBuffer,NextPriority,DATABASE::Resource,DATABASE::"CRM Product");

      IntegrationTableMapping.RESET;
      IntegrationTableMapping.SETFILTER("Parent Name",'=''''');
      IntegrationTableMapping.SETRANGE("Int. Table UID Field Type",Field.Type::GUID);
      IF IntegrationTableMapping.FINDSET THEN
        REPEAT
          AddPrioritizedMappingToList(NameValueBuffer,NextPriority,IntegrationTableMapping.Name);
        UNTIL IntegrationTableMapping.NEXT = 0;
    END;

    LOCAL PROCEDURE AddPrioritizedMappingsToList@30(VAR NameValueBuffer@1002 : Record 823;VAR Priority@1001 : Integer;TableID@1000 : Integer;IntegrationTableID@1003 : Integer);
    VAR
      Field@1005 : Record 2000000041;
      IntegrationTableMapping@1004 : Record 5335;
    BEGIN
      WITH IntegrationTableMapping DO BEGIN
        RESET;
        SETRANGE("Delete After Synchronization",FALSE);
        IF TableID > 0 THEN
          SETRANGE("Table ID",TableID);
        IF IntegrationTableID > 0 THEN
          SETRANGE("Integration Table ID",IntegrationTableID);
        SETRANGE("Int. Table UID Field Type",Field.Type::GUID);
        IF FINDSET THEN
          REPEAT
            AddPrioritizedMappingToList(NameValueBuffer,Priority,Name);
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE AddPrioritizedMappingToList@24(VAR NameValueBuffer@1002 : Record 823;VAR Priority@1000 : Integer;MappingName@1001 : Code[20]);
    BEGIN
      WITH NameValueBuffer DO BEGIN
        SETRANGE(Value,MappingName);

        IF NOT FINDFIRST THEN BEGIN
          INIT;
          ID := Priority;
          Name := FORMAT(Priority);
          Value := MappingName;
          INSERT;
          Priority := Priority + 1;
        END;

        RESET;
      END;
    END;

    [External]
    PROCEDURE GetTableIDCRMEntityNameMapping@22(VAR TempNameValueBuffer@1000 : TEMPORARY Record 823);
    BEGIN
      TempNameValueBuffer.RESET;
      TempNameValueBuffer.DELETEALL;

      AddEntityTableMapping('systemuser',DATABASE::"Salesperson/Purchaser",TempNameValueBuffer);
      AddEntityTableMapping('systemuser',DATABASE::"CRM Systemuser",TempNameValueBuffer);

      AddEntityTableMapping('account',DATABASE::Customer,TempNameValueBuffer);
      AddEntityTableMapping('account',DATABASE::"CRM Account",TempNameValueBuffer);

      AddEntityTableMapping('contact',DATABASE::Contact,TempNameValueBuffer);
      AddEntityTableMapping('contact',DATABASE::"CRM Contact",TempNameValueBuffer);

      AddEntityTableMapping('product',DATABASE::Item,TempNameValueBuffer);
      AddEntityTableMapping('product',DATABASE::Resource,TempNameValueBuffer);
      AddEntityTableMapping('product',DATABASE::"CRM Product",TempNameValueBuffer);

      AddEntityTableMapping('salesorder',DATABASE::"Sales Header",TempNameValueBuffer);
      AddEntityTableMapping('salesorder',DATABASE::"CRM Salesorder",TempNameValueBuffer);

      AddEntityTableMapping('invoice',DATABASE::"Sales Invoice Header",TempNameValueBuffer);
      AddEntityTableMapping('invoice',DATABASE::"CRM Invoice",TempNameValueBuffer);

      AddEntityTableMapping('opportunity',DATABASE::Opportunity,TempNameValueBuffer);
      AddEntityTableMapping('opportunity',DATABASE::"CRM Opportunity",TempNameValueBuffer);

      // Only NAV
      AddEntityTableMapping('pricelevel',DATABASE::"Customer Price Group",TempNameValueBuffer);
      AddEntityTableMapping('transactioncurrency',DATABASE::Currency,TempNameValueBuffer);
      AddEntityTableMapping('uomschedule',DATABASE::"Unit of Measure",TempNameValueBuffer);

      // Only CRM
      AddEntityTableMapping('incident',DATABASE::"CRM Incident",TempNameValueBuffer);
      AddEntityTableMapping('quote',DATABASE::"CRM Quote",TempNameValueBuffer);
    END;

    LOCAL PROCEDURE AddEntityTableMapping@26(CRMEntityTypeName@1000 : Text;TableID@1001 : Integer;VAR TempNameValueBuffer@1002 : TEMPORARY Record 823);
    BEGIN
      WITH TempNameValueBuffer DO BEGIN
        INIT;
        ID := COUNT + 1;
        Name := COPYSTR(CRMEntityTypeName,1,MAXSTRLEN(Name));
        Value := FORMAT(TableID);
        INSERT;
      END;
    END;

    LOCAL PROCEDURE ResetAccountConfigTemplate@29() : Code[10];
    VAR
      AccountConfigTemplateHeader@1001 : Record 8618;
      ConfigTemplateLine@1000 : Record 8619;
      CRMAccount@1002 : Record 5341;
    BEGIN
      ConfigTemplateLine.SETRANGE(
        "Data Template Code",COPYSTR(CRMAccountConfigTemplateCodeTok,1,MAXSTRLEN(AccountConfigTemplateHeader.Code)));
      ConfigTemplateLine.DELETEALL;
      AccountConfigTemplateHeader.SETRANGE(
        Code,COPYSTR(CRMAccountConfigTemplateCodeTok,1,MAXSTRLEN(AccountConfigTemplateHeader.Code)));
      AccountConfigTemplateHeader.DELETEALL;

      AccountConfigTemplateHeader.INIT;
      AccountConfigTemplateHeader.Code := COPYSTR(CRMAccountConfigTemplateCodeTok,1,MAXSTRLEN(AccountConfigTemplateHeader.Code));
      AccountConfigTemplateHeader.Description :=
        COPYSTR(CRMAccountConfigTemplateDescTxt,1,MAXSTRLEN(AccountConfigTemplateHeader.Description));
      AccountConfigTemplateHeader."Table ID" := DATABASE::"CRM Account";
      AccountConfigTemplateHeader.INSERT;
      ConfigTemplateLine.INIT;
      ConfigTemplateLine."Data Template Code" := AccountConfigTemplateHeader.Code;
      ConfigTemplateLine."Line No." := 1;
      ConfigTemplateLine.Type := ConfigTemplateLine.Type::Field;
      ConfigTemplateLine."Table ID" := DATABASE::"CRM Account";
      ConfigTemplateLine."Field ID" := CRMAccount.FIELDNO(CustomerTypeCode);
      ConfigTemplateLine."Field Name" := CRMAccount.FIELDNAME(CustomerTypeCode);
      ConfigTemplateLine."Default Value" := FORMAT(CRMAccount.CustomerTypeCode::Customer);
      ConfigTemplateLine.INSERT;

      EXIT(CRMAccountConfigTemplateCodeTok);
    END;

    LOCAL PROCEDURE ResetCustomerConfigTemplate@31() : Code[10];
    VAR
      ConfigTemplateHeader@1000 : Record 8618;
      CustomerConfigTemplateHeader@1005 : Record 8618;
      ConfigTemplateLine@1001 : Record 8619;
      CustomerConfigTemplateLine@1006 : Record 8619;
      Customer@1002 : Record 18;
      FoundTemplateCode@1003 : Code[10];
    BEGIN
      CustomerConfigTemplateLine.SETRANGE(
        "Data Template Code",COPYSTR(CustomerConfigTemplateCodeTok,1,MAXSTRLEN(CustomerConfigTemplateLine."Data Template Code")));
      CustomerConfigTemplateLine.DELETEALL;
      CustomerConfigTemplateHeader.SETRANGE(
        Code,COPYSTR(CustomerConfigTemplateCodeTok,1,MAXSTRLEN(CustomerConfigTemplateHeader.Code)));
      CustomerConfigTemplateHeader.DELETEALL;

      // Base the customer config template off the first customer template with currency code '' (LCY);
      ConfigTemplateHeader.SETRANGE("Table ID",DATABASE::Customer);
      IF ConfigTemplateHeader.FINDSET THEN
        REPEAT
          ConfigTemplateLine.SETRANGE("Data Template Code",ConfigTemplateHeader.Code);
          ConfigTemplateLine.SETRANGE("Field ID",Customer.FIELDNO("Currency Code"));
          ConfigTemplateLine.SETFILTER("Default Value",'');
          IF ConfigTemplateLine.FINDFIRST THEN BEGIN
            FoundTemplateCode := ConfigTemplateHeader.Code;
            BREAK;
          END;
        UNTIL ConfigTemplateHeader.NEXT = 0;

      IF FoundTemplateCode = '' THEN
        EXIT('');

      CustomerConfigTemplateHeader.INIT;
      CustomerConfigTemplateHeader.TRANSFERFIELDS(ConfigTemplateHeader,FALSE);
      CustomerConfigTemplateHeader.Code := COPYSTR(CustomerConfigTemplateCodeTok,1,MAXSTRLEN(CustomerConfigTemplateHeader.Code));
      CustomerConfigTemplateHeader.Description :=
        COPYSTR(CustomerConfigTemplateDescTxt,1,MAXSTRLEN(CustomerConfigTemplateHeader.Description));
      CustomerConfigTemplateHeader.INSERT;

      ConfigTemplateLine.RESET;
      ConfigTemplateLine.SETRANGE("Data Template Code",ConfigTemplateHeader.Code);
      ConfigTemplateLine.FINDSET;
      REPEAT
        CustomerConfigTemplateLine.INIT;
        CustomerConfigTemplateLine.TRANSFERFIELDS(ConfigTemplateLine,TRUE);
        CustomerConfigTemplateLine."Data Template Code" := CustomerConfigTemplateHeader.Code;
        CustomerConfigTemplateLine.INSERT;
      UNTIL ConfigTemplateLine.NEXT = 0;

      EXIT(CustomerConfigTemplateCodeTok);
    END;

    LOCAL PROCEDURE RegisterTempConnectionIfNeeded@15(CRMConnectionSetup@1000 : Record 5330;VAR TempCRMConnectionSetup@1001 : TEMPORARY Record 5330) ConnectionName : Text;
    BEGIN
      IF CRMConnectionSetup."Is User Mapping Required" THEN BEGIN
        ConnectionName := FORMAT(CREATEGUID);
        TempCRMConnectionSetup.TRANSFERFIELDS(CRMConnectionSetup);
        TempCRMConnectionSetup."Is User Mapping Required" := FALSE;
        TempCRMConnectionSetup.RegisterConnectionWithName(ConnectionName);
      END;
    END;

    LOCAL PROCEDURE ResetDefaultCRMPricelevel@6(CRMConnectionSetup@1000 : Record 5330);
    BEGIN
      CRMConnectionSetup.FIND;
      CLEAR(CRMConnectionSetup."Default CRM Price List ID");
      CRMConnectionSetup.MODIFY;
    END;

    LOCAL PROCEDURE SetIntegrationTableFilterForCRMProduct@17(VAR IntegrationTableMapping@1001 : Record 5335;CRMProduct@1000 : Record 5348;ProductTypeCode@1002 : Option);
    BEGIN
      CRMProduct.SETRANGE(ProductTypeCode,ProductTypeCode);
      IntegrationTableMapping.SetIntegrationTableFilter(
        GetTableFilterFromView(DATABASE::"CRM Product",CRMProduct.TABLECAPTION,CRMProduct.GETVIEW));
      IntegrationTableMapping.MODIFY;
    END;

    BEGIN
    END.
  }
}

