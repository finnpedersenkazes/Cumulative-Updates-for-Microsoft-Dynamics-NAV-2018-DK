OBJECT Codeunit 5343 CRM Sales Order to Sales Order
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    TableNo=5353;
    OnRun=VAR
            SalesHeader@1000 : Record 36;
          BEGIN
            CreateInNAV(Rec,SalesHeader);
          END;

  }
  CODE
  {
    VAR
      CannotCreateSalesOrderInNAVTxt@1003 : TextConst 'DAN=Salgsordren kan ikke oprettes.;ENU=The sales order cannot be created.';
      CannotFindCRMAccountForOrderErr@1014 : TextConst '@@@="%1=Dynamics CRM Sales Order Name, %2 - Microsoft Dynamics CRM";DAN=%2-kontoen til %2-salgsordren %1 findes ikke.;ENU=The %2 account for %2 sales order %1 does not exist.';
      ItemDoesNotExistErr@1002 : TextConst '@@@="%1= the text: ""The sales order cannot be created."", %2=product name";DAN=%1 Varen %2 findes ikke.;ENU=%1 The item %2 does not exist.';
      NoCustomerErr@1005 : TextConst '@@@="%1= the text: ""The Dynamics CRM Sales Order cannot be created."", %2=sales order title, %3 - Microsoft Dynamics CRM";DAN=%1 Der er ingen mulig debitor defineret p� %3-salgsordren %2.;ENU=%1 There is no potential customer defined on the %3 sales order %2.';
      CRMSynchHelper@1017 : Codeunit 5342;
      CRMProductName@1001 : Codeunit 5344;
      LastSalesLineNo@1004 : Integer;
      NotCoupledCustomerErr@1012 : TextConst '@@@="%1= the text: ""The Dynamics CRM Sales Order cannot be created."", %2=account name, %3 - Microsoft Dynamics CRM";DAN=%1 Der er ingen debitor sammenk�det med %3-kontoen %2.;ENU=%1 There is no customer coupled to %3 account %2.';
      NotCoupledCRMProductErr@1006 : TextConst '@@@="%1= the text: ""The Dynamics CRM Sales Order cannot be created."", %2=product name, %3 - Microsoft Dynamics CRM";DAN=%1 %3-produktet %2 er ikke sammenk�det med en vare.;ENU=%1 The %3 product %2 is not coupled to an item.';
      NotCoupledCRMResourceErr@1007 : TextConst '@@@="%1= the text: ""The Dynamics CRM Sales Order cannot be created."", %2=resource name, %3 - Microsoft Dynamics CRM";DAN=%1 %3-ressourcen %2 er ikke sammenk�det med en ressource.;ENU=%1 The %3 resource %2 is not coupled to a resource.';
      NotCoupledCRMSalesOrderErr@1000 : TextConst '@@@="%1=sales order number, %2 - Microsoft Dynamics CRM";DAN=%2-salgsordren %1 er ikke sammenk�det.;ENU=The %2 sales order %1 is not coupled.';
      NotCoupledSalesHeaderErr@1015 : TextConst '@@@="%1=sales order number, %2 - Microsoft Dynamics CRM";DAN=Salgsordren %1 er ikke sammenk�det med %2.;ENU=The sales order %1 is not coupled to %2.';
      OverwriteCRMDiscountQst@1016 : TextConst '@@@=%1 - product name, %2 - Microsoft Dynamics CRM;DAN=Der er en rabat p� %2-salgsordren, der overskrives af %1-indstillingerne. Du f�r mulighed for at opdatere rabatterne direkte p� salgsordren, n�r den er oprettet. Vil du forts�tte?;ENU=There is a discount on the %2 sales order, which will be overwritten by %1 settings. You will have the possibility to update the discounts directly on the sales order, after it is created. Do you want to continue?';
      ResourceDoesNotExistErr@1009 : TextConst '@@@="%1= the text: ""The Dynamics CRM Sales Order cannot be created."", %2=product name";DAN=%1 Ressourcen %2 findes ikke.;ENU=%1 The resource %2 does not exist.';
      UnexpectedProductTypeErr@1011 : TextConst '@@@="%1= the text: ""The Dynamics CRM Sales Order cannot be created."", %2=product name";DAN=%1 Uventet v�rdi for produkttypekode for produkt %2. De underst�ttede v�rdier er: salg, lager, tjenester.;ENU=%1 Unexpected value of product type code for product %2. The supported values are: sales inventory, services.';
      ZombieCouplingErr@1013 : TextConst '@@@=%1 - product name, %2 - Microsoft Dynamics CRM;DAN=Selvom sammenk�dningen fra %2 findes, er salgsordren blevet slettet manuelt. Brug evt. menuen til at oprette den igen i %1.;ENU=Although the coupling from %2 exists, the sales order had been manually deleted. If needed, please use the menu to create it again in %1.';

    LOCAL PROCEDURE ApplySalesOrderDiscounts@22(CRMSalesorder@1001 : Record 5353;VAR SalesHeader@1000 : Record 36);
    VAR
      SalesCalcDiscountByType@1002 : Codeunit 56;
      CRMDiscountAmount@1003 : Decimal;
    BEGIN
      // No discounts to apply
      IF (CRMSalesorder.DiscountAmount = 0 ) AND (CRMSalesorder.DiscountPercentage = 0) THEN
        EXIT;

      // Attempt to set the discount, if NAV general and customer settings allow it
      // Using CRM discounts
      CRMDiscountAmount := CRMSalesorder.TotalLineItemAmount - CRMSalesorder.TotalAmountLessFreight;
      SalesCalcDiscountByType.ApplyInvDiscBasedOnAmt(CRMDiscountAmount,SalesHeader);

      // NAV settings (in G/L Setup as well as per-customer discounts) did not allow using the CRM discounts
      // Using NAV discounts
      // But the user will be able to manually update the discounts after the order is created in NAV
      IF NOT CONFIRM(STRSUBSTNO(OverwriteCRMDiscountQst,PRODUCTNAME.SHORT,CRMProductName.SHORT),TRUE) THEN
        ERROR('');
    END;

    LOCAL PROCEDURE CopyCRMOptionFields@3(CRMSalesorder@1001 : Record 5353;VAR SalesHeader@1000 : Record 36);
    VAR
      CRMAccount@1003 : Record 5341;
      CRMOptionMapping@1002 : Record 5334;
    BEGIN
      IF CRMOptionMapping.FindRecordID(
           DATABASE::"CRM Account",CRMAccount.FIELDNO(Address1_ShippingMethodCode),CRMSalesorder.ShippingMethodCode)
      THEN
        SalesHeader.VALIDATE(
          "Shipping Agent Code",
          COPYSTR(CRMOptionMapping.GetRecordKeyValue,1,MAXSTRLEN(SalesHeader."Shipping Agent Code")));

      IF CRMOptionMapping.FindRecordID(
           DATABASE::"CRM Account",CRMAccount.FIELDNO(PaymentTermsCode),CRMSalesorder.PaymentTermsCode)
      THEN
        SalesHeader.VALIDATE(
          "Payment Terms Code",
          COPYSTR(CRMOptionMapping.GetRecordKeyValue,1,MAXSTRLEN(SalesHeader."Payment Terms Code")));

      IF CRMOptionMapping.FindRecordID(
           DATABASE::"CRM Account",CRMAccount.FIELDNO(Address1_FreightTermsCode),CRMSalesorder.FreightTermsCode)
      THEN
        SalesHeader.VALIDATE(
          "Shipment Method Code",
          COPYSTR(CRMOptionMapping.GetRecordKeyValue,1,MAXSTRLEN(SalesHeader."Shipment Method Code")));
    END;

    LOCAL PROCEDURE CopyBillToInformationIfNotEmpty@7(CRMSalesorder@1001 : Record 5353;VAR SalesHeader@1000 : Record 36);
    BEGIN
      // If the Bill-To fields in CRM are all empty, then let NAV keep its standard behavior (takes Bill-To from the Customer information)
      IF ((CRMSalesorder.BillTo_Line1 = '') AND
          (CRMSalesorder.BillTo_Line2 = '') AND
          (CRMSalesorder.BillTo_City = '') AND
          (CRMSalesorder.BillTo_PostalCode = '') AND
          (CRMSalesorder.BillTo_Country = '') AND
          (CRMSalesorder.BillTo_StateOrProvince = ''))
      THEN
        EXIT;

      SalesHeader.VALIDATE("Bill-to Address",FORMAT(CRMSalesorder.BillTo_Line1,MAXSTRLEN(SalesHeader."Bill-to Address")));
      SalesHeader.VALIDATE("Bill-to Address 2",FORMAT(CRMSalesorder.BillTo_Line2,MAXSTRLEN(SalesHeader."Bill-to Address 2")));
      SalesHeader.VALIDATE("Bill-to City",FORMAT(CRMSalesorder.BillTo_City,MAXSTRLEN(SalesHeader."Bill-to City")));
      SalesHeader.VALIDATE("Bill-to Post Code",FORMAT(CRMSalesorder.BillTo_PostalCode,MAXSTRLEN(SalesHeader."Bill-to Post Code")));
      SalesHeader.VALIDATE(
        "Bill-to Country/Region Code",FORMAT(CRMSalesorder.BillTo_Country,MAXSTRLEN(SalesHeader."Bill-to Country/Region Code")));
      SalesHeader.VALIDATE("Bill-to County",FORMAT(CRMSalesorder.BillTo_StateOrProvince,MAXSTRLEN(SalesHeader."Bill-to County")));
    END;

    LOCAL PROCEDURE CopyShipToInformationIfNotEmpty@31(CRMSalesorder@1001 : Record 5353;VAR SalesHeader@1000 : Record 36);
    BEGIN
      // If the Ship-To fields in CRM are all empty, then let NAV keep its standard behavior (takes Bill-To from the Customer information)
      IF ((CRMSalesorder.ShipTo_Line1 = '') AND
          (CRMSalesorder.ShipTo_Line2 = '') AND
          (CRMSalesorder.ShipTo_City = '') AND
          (CRMSalesorder.ShipTo_PostalCode = '') AND
          (CRMSalesorder.ShipTo_Country = '') AND
          (CRMSalesorder.ShipTo_StateOrProvince = ''))
      THEN
        EXIT;

      SalesHeader.VALIDATE("Ship-to Address",FORMAT(CRMSalesorder.ShipTo_Line1,MAXSTRLEN(SalesHeader."Ship-to Address")));
      SalesHeader.VALIDATE("Ship-to Address 2",FORMAT(CRMSalesorder.ShipTo_Line2,MAXSTRLEN(SalesHeader."Ship-to Address 2")));
      SalesHeader.VALIDATE("Ship-to City",FORMAT(CRMSalesorder.ShipTo_City,MAXSTRLEN(SalesHeader."Ship-to City")));
      SalesHeader.VALIDATE("Ship-to Post Code",FORMAT(CRMSalesorder.ShipTo_PostalCode,MAXSTRLEN(SalesHeader."Ship-to Post Code")));
      SalesHeader.VALIDATE(
        "Ship-to Country/Region Code",FORMAT(CRMSalesorder.ShipTo_Country,MAXSTRLEN(SalesHeader."Ship-to Country/Region Code")));
      SalesHeader.VALIDATE("Ship-to County",FORMAT(CRMSalesorder.ShipTo_StateOrProvince,MAXSTRLEN(SalesHeader."Ship-to County")));
    END;

    LOCAL PROCEDURE CopyProductDescription@27(SalesHeader@1000 : Record 36;VAR SalesLine@1001 : Record 37;CRMSalesOrderProductDescription@1002 : Text);
    BEGIN
      IF STRLEN(CRMSalesOrderProductDescription) > MAXSTRLEN(SalesLine.Description) THEN BEGIN
        SalesLine.Description := COPYSTR(CRMSalesOrderProductDescription,1,MAXSTRLEN(SalesLine.Description));
        CreateExtendedDescriptionOrderLines(
          SalesHeader,
          COPYSTR(
            CRMSalesOrderProductDescription,
            MAXSTRLEN(SalesLine.Description) + 1));
      END;
    END;

    LOCAL PROCEDURE CoupledSalesHeaderExists@16(CRMSalesorder@1001 : Record 5353) : Boolean;
    VAR
      SalesHeader@1002 : Record 36;
      CRMIntegrationRecord@1003 : Record 5331;
      NAVSalesHeaderRecordId@1000 : RecordID;
    BEGIN
      IF NOT ISNULLGUID(CRMSalesorder.SalesOrderId) THEN
        IF CRMIntegrationRecord.FindRecordIDFromID(CRMSalesorder.SalesOrderId,DATABASE::"Sales Header",NAVSalesHeaderRecordId) THEN
          EXIT(SalesHeader.GET(NAVSalesHeaderRecordId));
    END;

    [External]
    PROCEDURE CreateInNAV@1(CRMSalesorder@1012 : Record 5353;VAR SalesHeader@1000 : Record 36) : Boolean;
    BEGIN
      CRMSalesorder.TESTFIELD(StateCode,CRMSalesorder.StateCode::Submitted);
      EXIT(CreateNAVSalesOrder(CRMSalesorder,SalesHeader));
    END;

    LOCAL PROCEDURE CreateNAVSalesOrder@15(CRMSalesorder@1001 : Record 5353;VAR SalesHeader@1000 : Record 36) : Boolean;
    VAR
      CRMIntegrationRecord@1003 : Record 5331;
    BEGIN
      IF ISNULLGUID(CRMSalesorder.SalesOrderId) THEN
        EXIT;

      CreateSalesOrderHeader(CRMSalesorder,SalesHeader);
      CreateSalesOrderLines(CRMSalesorder,SalesHeader);
      ApplySalesOrderDiscounts(CRMSalesorder,SalesHeader);
      CRMIntegrationRecord.CoupleRecordIdToCRMID(SalesHeader.RECORDID,CRMSalesorder.SalesOrderId);
      // Flag sales order has been submitted to NAV.
      SetLastBackOfficeSubmit(CRMSalesorder,TODAY);
      EXIT(TRUE);
    END;

    [EventSubscriber(Table,36,OnBeforeDeleteEvent)]
    [Internal]
    PROCEDURE ClearLastBackOfficeSubmitOnSalesHeaderDelete@14(VAR Rec@1000 : Record 36;RunTrigger@1004 : Boolean);
    VAR
      CRMSalesorder@1002 : Record 5353;
      CRMIntegrationRecord@1003 : Record 5331;
      CRMIntegrationManagement@1001 : Codeunit 5330;
    BEGIN
      IF CRMIntegrationManagement.IsCRMIntegrationEnabled THEN
        IF CRMIntegrationRecord.FindIDFromRecordID(Rec.RECORDID,CRMSalesorder.SalesOrderId) THEN BEGIN
          CRMSalesorder.FIND;
          SetLastBackOfficeSubmit(CRMSalesorder,0D);
        END;
    END;

    LOCAL PROCEDURE CreateSalesOrderHeader@10(CRMSalesorder@1001 : Record 5353;VAR SalesHeader@1000 : Record 36);
    VAR
      Customer@1010 : Record 18;
    BEGIN
      SalesHeader.INIT;
      SalesHeader.VALIDATE("Document Type",SalesHeader."Document Type"::Order);
      SalesHeader.VALIDATE(Status,SalesHeader.Status::Open);
      SalesHeader.InitInsert;
      GetCoupledCustomer(CRMSalesorder,Customer);
      SalesHeader.VALIDATE("Sell-to Customer No.",Customer."No.");
      SalesHeader.VALIDATE("Your Reference",COPYSTR(CRMSalesorder.OrderNumber,1,MAXSTRLEN(SalesHeader."Your Reference")));
      SalesHeader.VALIDATE("Currency Code",CRMSynchHelper.GetNavCurrencyCode(CRMSalesorder.TransactionCurrencyId));
      SalesHeader.VALIDATE("Requested Delivery Date",CRMSalesorder.RequestDeliveryBy);
      CopyBillToInformationIfNotEmpty(CRMSalesorder,SalesHeader);
      CopyShipToInformationIfNotEmpty(CRMSalesorder,SalesHeader);
      CopyCRMOptionFields(CRMSalesorder,SalesHeader);
      SalesHeader.VALIDATE("Payment Discount %",CRMSalesorder.DiscountPercentage);
      SalesHeader.VALIDATE("External Document No.",COPYSTR(CRMSalesorder.Name,1,MAXSTRLEN(SalesHeader."External Document No.")));
      SalesHeader.INSERT;
    END;

    LOCAL PROCEDURE CreateSalesOrderLines@13(CRMSalesorder@1001 : Record 5353;SalesHeader@1000 : Record 36);
    VAR
      CRMSalesorderdetail@1007 : Record 5354;
      SalesLine@1004 : Record 37;
    BEGIN
      // If any of the products on the lines are not found in NAV, err
      CRMSalesorderdetail.SETRANGE(SalesOrderId,CRMSalesorder.SalesOrderId); // Get all sales order lines

      IF CRMSalesorderdetail.FINDSET THEN BEGIN
        REPEAT
          InitializeSalesOrderLine(CRMSalesorderdetail,SalesHeader,SalesLine);
          SalesLine.INSERT;
          IF SalesLine."Qty. to Assemble to Order" <> 0 THEN
            SalesLine.VALIDATE("Qty. to Assemble to Order");
        UNTIL CRMSalesorderdetail.NEXT = 0;
      END ELSE BEGIN
        SalesLine.VALIDATE("Document Type",SalesHeader."Document Type");
        SalesLine.VALIDATE("Document No.",SalesHeader."No.");
      END;

      SalesLine.InsertFreightLine(CRMSalesorder.FreightAmount);
    END;

    PROCEDURE CreateExtendedDescriptionOrderLines@5(SalesHeader@1000 : Record 36;FullDescription@1001 : Text);
    VAR
      SalesLine@1002 : Record 37;
    BEGIN
      WHILE STRLEN(FullDescription) > 0 DO BEGIN
        InitNewSalesLine(SalesHeader,SalesLine);

        SalesLine.VALIDATE(Description,COPYSTR(FullDescription,1,MAXSTRLEN(SalesLine.Description)));
        SalesLine.INSERT;
        FullDescription := COPYSTR(FullDescription,MAXSTRLEN(SalesLine.Description) + 1);
      END;
    END;

    [Internal]
    PROCEDURE CRMIsCoupledToValidRecord@9(CRMSalesorder@1002 : Record 5353;NAVTableID@1001 : Integer) : Boolean;
    VAR
      CRMIntegrationManagement@1000 : Codeunit 5330;
      CRMCouplingManagement@1003 : Codeunit 5331;
    BEGIN
      EXIT(CRMIntegrationManagement.IsCRMIntegrationEnabled AND
        CRMCouplingManagement.IsRecordCoupledToNAV(CRMSalesorder.SalesOrderId,NAVTableID) AND
        CoupledSalesHeaderExists(CRMSalesorder));
    END;

    [External]
    PROCEDURE GetCRMSalesOrder@19(VAR CRMSalesorder@1001 : Record 5353;YourReference@1000 : Text[35]) : Boolean;
    BEGIN
      CRMSalesorder.SETRANGE(OrderNumber,YourReference);
      EXIT(CRMSalesorder.FINDFIRST)
    END;

    [External]
    PROCEDURE GetCoupledCRMSalesorder@21(SalesHeader@1000 : Record 36;VAR CRMSalesorder@1001 : Record 5353);
    VAR
      CRMIntegrationRecord@1002 : Record 5331;
      CoupledCRMId@1004 : GUID;
    BEGIN
      IF SalesHeader.ISEMPTY THEN
        ERROR(NotCoupledSalesHeaderErr,SalesHeader."No.",CRMProductName.SHORT);

      IF NOT CRMIntegrationRecord.FindIDFromRecordID(SalesHeader.RECORDID,CoupledCRMId) THEN
        ERROR(NotCoupledSalesHeaderErr,SalesHeader."No.",CRMProductName.SHORT);

      IF CRMSalesorder.GET(CoupledCRMId) THEN
        EXIT;

      // If we reached this point, a zombie coupling exists but the sales order most probably was deleted manually by the user.
      CRMIntegrationRecord.RemoveCouplingToCRMID(CoupledCRMId,DATABASE::"Sales Header");
      ERROR(ZombieCouplingErr,PRODUCTNAME.SHORT,CRMProductName.SHORT);
    END;

    [External]
    PROCEDURE GetCoupledCustomer@4(CRMSalesorder@1001 : Record 5353;VAR Customer@1000 : Record 18) : Boolean;
    VAR
      CRMAccount@1004 : Record 5341;
      CRMIntegrationRecord@1002 : Record 5331;
      NAVCustomerRecordId@1003 : RecordID;
      CRMAccountId@1005 : GUID;
    BEGIN
      IF ISNULLGUID(CRMSalesorder.CustomerId) THEN
        ERROR(NoCustomerErr,CannotCreateSalesOrderInNAVTxt,CRMSalesorder.Description,CRMProductName.SHORT);

      // Get the ID of the CRM Account associated to the sales order. Works for both CustomerType(s): account, contact
      IF NOT GetCRMAccountOfCRMSalesOrder(CRMSalesorder,CRMAccount) THEN
        ERROR(CannotFindCRMAccountForOrderErr,CRMSalesorder.Name,CRMProductName.SHORT);
      CRMAccountId := CRMAccount.AccountId;

      IF NOT CRMIntegrationRecord.FindRecordIDFromID(CRMAccountId,DATABASE::Customer,NAVCustomerRecordId) THEN
        ERROR(NotCoupledCustomerErr,CannotCreateSalesOrderInNAVTxt,CRMAccount.Name,CRMProductName.SHORT);

      EXIT(Customer.GET(NAVCustomerRecordId));
    END;

    [External]
    PROCEDURE GetCoupledSalesHeader@2(CRMSalesorder@1001 : Record 5353;VAR SalesHeader@1000 : Record 36) : Boolean;
    VAR
      CRMIntegrationRecord@1002 : Record 5331;
      NAVSalesHeaderRecordId@1003 : RecordID;
    BEGIN
      IF ISNULLGUID(CRMSalesorder.SalesOrderId) THEN
        ERROR(NotCoupledCRMSalesOrderErr,CRMSalesorder.OrderNumber,CRMProductName.SHORT);

      // Attempt to find the coupled sales header
      IF NOT CRMIntegrationRecord.FindRecordIDFromID(CRMSalesorder.SalesOrderId,DATABASE::"Sales Header",NAVSalesHeaderRecordId) THEN
        ERROR(NotCoupledCRMSalesOrderErr,CRMSalesorder.OrderNumber,CRMProductName.SHORT);

      IF SalesHeader.GET(NAVSalesHeaderRecordId) THEN
        EXIT(TRUE);

      // If we reached this point, a zombie coupling exists but the sales order most probably was deleted manually by the user.
      CRMIntegrationRecord.RemoveCouplingToCRMID(CRMSalesorder.SalesOrderId,DATABASE::"Sales Header");
      ERROR(ZombieCouplingErr,PRODUCTNAME.SHORT,CRMProductName.SHORT);
    END;

    [External]
    PROCEDURE GetCRMAccountOfCRMSalesOrder@11(CRMSalesorder@1002 : Record 5353;VAR CRMAccount@1000 : Record 5341) : Boolean;
    VAR
      CRMContact@1001 : Record 5342;
    BEGIN
      IF CRMSalesorder.CustomerIdType = CRMSalesorder.CustomerIdType::account THEN
        EXIT(CRMAccount.GET(CRMSalesorder.CustomerId));

      IF CRMSalesorder.CustomerIdType = CRMSalesorder.CustomerIdType::contact THEN
        IF CRMContact.GET(CRMSalesorder.CustomerId) THEN
          EXIT(CRMAccount.GET(CRMContact.ParentCustomerId));
      EXIT(FALSE);
    END;

    [External]
    PROCEDURE GetCRMContactOfCRMSalesOrder@17(CRMSalesorder@1002 : Record 5353;VAR CRMContact@1000 : Record 5342) : Boolean;
    BEGIN
      IF CRMSalesorder.CustomerIdType = CRMSalesorder.CustomerIdType::contact THEN
        EXIT(CRMContact.GET(CRMSalesorder.CustomerId));
    END;

    LOCAL PROCEDURE InitNewSalesLine@32(SalesHeader@1000 : Record 36;VAR SalesLine@1001 : Record 37);
    BEGIN
      SalesLine.INIT;
      SalesLine.VALIDATE("Document Type",SalesHeader."Document Type");
      SalesLine.VALIDATE("Document No.",SalesHeader."No.");
      LastSalesLineNo := LastSalesLineNo + 10000;
      SalesLine.VALIDATE("Line No.",LastSalesLineNo);
    END;

    LOCAL PROCEDURE InitializeSalesOrderLine@18(CRMSalesorderdetail@1003 : Record 5354;SalesHeader@1000 : Record 36;VAR SalesLine@1002 : Record 37);
    VAR
      CRMProduct@1004 : Record 5348;
    BEGIN
      InitNewSalesLine(SalesHeader,SalesLine);

      IF ISNULLGUID(CRMSalesorderdetail.ProductId) THEN
        InitializeWriteInOrderLine(SalesLine)
      ELSE BEGIN
        CRMProduct.GET(CRMSalesorderdetail.ProductId);
        CRMProduct.TESTFIELD(StateCode,CRMProduct.StateCode::Active);
        CASE CRMProduct.ProductTypeCode OF
          CRMProduct.ProductTypeCode::SalesInventory:
            InitializeSalesOrderLineFromItem(CRMProduct,SalesLine);
          CRMProduct.ProductTypeCode::Services:
            InitializeSalesOrderLineFromResource(CRMProduct,SalesLine);
          ELSE
            ERROR(UnexpectedProductTypeErr,CannotCreateSalesOrderInNAVTxt,CRMProduct.ProductNumber);
        END;
      END;

      CopyProductDescription(SalesHeader,SalesLine,CRMSalesorderdetail.ProductDescription);

      SalesLine.VALIDATE(Quantity,CRMSalesorderdetail.Quantity);
      SalesLine.VALIDATE("Unit Price",CRMSalesorderdetail.PricePerUnit);
      SalesLine.VALIDATE(Amount,CRMSalesorderdetail.BaseAmount);
      SalesLine.VALIDATE(
        "Line Discount Amount",
        CRMSalesorderdetail.Quantity * CRMSalesorderdetail.VolumeDiscountAmount +
        CRMSalesorderdetail.ManualDiscountAmount);
    END;

    LOCAL PROCEDURE InitializeSalesOrderLineFromItem@8(CRMProduct@1001 : Record 5348;VAR SalesLine@1002 : Record 37);
    VAR
      CRMIntegrationRecord@1003 : Record 5331;
      Item@1005 : Record 27;
      NAVItemRecordID@1000 : RecordID;
    BEGIN
      // Attempt to find the coupled item
      IF NOT CRMIntegrationRecord.FindRecordIDFromID(CRMProduct.ProductId,DATABASE::Item,NAVItemRecordID) THEN
        ERROR(NotCoupledCRMProductErr,CannotCreateSalesOrderInNAVTxt,CRMProduct.Name,CRMProductName.SHORT);

      IF NOT Item.GET(NAVItemRecordID) THEN
        ERROR(ItemDoesNotExistErr,CannotCreateSalesOrderInNAVTxt,CRMProduct.ProductNumber);
      SalesLine.VALIDATE(Type,SalesLine.Type::Item);
      SalesLine.VALIDATE("No.",Item."No.");
    END;

    LOCAL PROCEDURE InitializeSalesOrderLineFromResource@6(CRMProduct@1001 : Record 5348;VAR SalesLine@1002 : Record 37);
    VAR
      CRMIntegrationRecord@1003 : Record 5331;
      Resource@1005 : Record 156;
      NAVResourceRecordID@1000 : RecordID;
    BEGIN
      // Attempt to find the coupled resource
      IF NOT CRMIntegrationRecord.FindRecordIDFromID(CRMProduct.ProductId,DATABASE::Resource,NAVResourceRecordID) THEN
        ERROR(NotCoupledCRMResourceErr,CannotCreateSalesOrderInNAVTxt,CRMProduct.Name,CRMProductName.SHORT);

      IF NOT Resource.GET(NAVResourceRecordID) THEN
        ERROR(ResourceDoesNotExistErr,CannotCreateSalesOrderInNAVTxt,CRMProduct.ProductNumber);
      SalesLine.VALIDATE(Type,SalesLine.Type::Resource);
      SalesLine.VALIDATE("No.",Resource."No.");
    END;

    LOCAL PROCEDURE InitializeWriteInOrderLine@12(VAR SalesLine@1001 : Record 37);
    VAR
      SalesSetup@1000 : Record 311;
    BEGIN
      SalesSetup.GET;
      SalesSetup.TESTFIELD("Write-in Product No.");
      SalesSetup.VALIDATE("Write-in Product No.");
      CASE SalesSetup."Write-in Product Type" OF
        SalesSetup."Write-in Product Type"::Item:
          SalesLine.VALIDATE(Type,SalesLine.Type::Item);
        SalesSetup."Write-in Product Type"::Resource:
          SalesLine.VALIDATE(Type,SalesLine.Type::Resource);
      END;
      SalesLine.VALIDATE("No.",SalesSetup."Write-in Product No.");
    END;

    LOCAL PROCEDURE SetLastBackOfficeSubmit@20(VAR CRMSalesorder@1001 : Record 5353;NewDate@1000 : Date);
    BEGIN
      IF CRMSalesorder.LastBackofficeSubmit <> NewDate THEN BEGIN
        CRMSalesorder.StateCode := CRMSalesorder.StateCode::Active;
        CRMSalesorder.MODIFY(TRUE);
        CRMSalesorder.LastBackofficeSubmit := NewDate;
        CRMSalesorder.MODIFY(TRUE);
        CRMSalesorder.StateCode := CRMSalesorder.StateCode::Submitted;
        CRMSalesorder.MODIFY(TRUE);
      END;
    END;

    BEGIN
    END.
  }
}

