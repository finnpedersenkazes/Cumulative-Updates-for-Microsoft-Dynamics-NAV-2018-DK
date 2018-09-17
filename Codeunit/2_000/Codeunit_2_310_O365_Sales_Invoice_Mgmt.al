OBJECT Codeunit 2310 O365 Sales Invoice Mgmt
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      ProcessDraftInvoiceInstructionTxt@1000 : TextConst 'DAN=ùnsker du at bevare den nye faktura?;ENU=Do you want to keep the new invoice?';
      ProcessDraftEstimateInstructionTxt@1010 : TextConst 'DAN=ùnsker du at bevare det nye estimat?;ENU=Do you want to keep the new estimate?';
      AddDiscountTxt@1003 : TextConst 'DAN=Tilfõj rabat;ENU=Add discount';
      ChangeDiscountTxt@1002 : TextConst 'DAN=Rediger rabat;ENU=Change discount';
      AddAttachmentTxt@1005 : TextConst 'DAN=Tilfõj vedhëftet fil;ENU=Add attachment';
      NoOfAttachmentsTxt@1004 : TextConst '@@@="%1=an integer number, starting at 0";DAN=Vedhëftede filer (%1);ENU=Attachments (%1)';
      InvoiceDiscountChangedMsg@1007 : TextConst 'DAN=índring af antallet har ryddet linjerabatten.;ENU=Changing the quantity has cleared the line discount.';
      AmountOutsideRangeMsg@1008 : TextConst 'DAN=Vi har justeret rabatten, sÜ den ikke overstiger linjebelõbet.;ENU=We adjusted the discount to not exceed the line amount.';
      ConfigValidateManagement@1015 : Codeunit 8617;
      CouponsManagement@1014 : Codeunit 2116;
      NotificationLifecycleMgt@1065 : Codeunit 1511;
      CouponsHasBeenCheckedForCustomer@1009 : Boolean;
      HasWarnedAboutExpiredOrClaimedCoupons@1006 : Boolean;
      CustomerCreatedMsg@1020 : TextConst 'DAN=Vi har fõjet denne nye debitor til listen.;ENU=We added this new customer to your list.';
      InvoiceDiscountLbl@1011 : TextConst 'DAN=Fakturarabat;ENU=Invoice Discount';
      UndoTxt@1013 : TextConst 'DAN=Fortryd;ENU=Undo';
      CustomerBlockedErr@1012 : TextConst 'DAN=Denne debitor er blokeret og kan ikke faktureres.;ENU=This customer has been blocked and cannot be invoiced.';
      NotificationShownForCustomer@1001 : Boolean;

    [External]
    PROCEDURE GetCustomerEmail@2(CustomerNo@1001 : Code[20]) : Text[80];
    VAR
      Customer@1000 : Record 18;
    BEGIN
      IF CustomerNo <> '' THEN
        IF Customer.GET(CustomerNo) THEN
          EXIT(Customer."E-Mail");
      EXIT('');
    END;

    [External]
    PROCEDURE ProcessDraftInvoiceOnCreate@3(VAR SalesHeader@1001 : Record 36) : Boolean;
    VAR
      InstructionsWithDocumentTypeTxt@1003 : Text;
    BEGIN
      IF SalesHeader."Document Type" = SalesHeader."Document Type"::Quote THEN
        InstructionsWithDocumentTypeTxt := ProcessDraftEstimateInstructionTxt
      ELSE
        InstructionsWithDocumentTypeTxt := ProcessDraftInvoiceInstructionTxt;

      IF CONFIRM(InstructionsWithDocumentTypeTxt,TRUE) THEN
        EXIT(TRUE);

      EXIT(SalesHeader.DELETE(TRUE)); // Delete all invoice lines and invoice header
    END;

    [External]
    PROCEDURE IsCustomerCompanyContact@89(CustomerNo@1001 : Code[20]) : Boolean;
    VAR
      Customer@1000 : Record 18;
    BEGIN
      IF CustomerNo <> '' THEN
        IF Customer.GET(CustomerNo) THEN
          EXIT(Customer."Contact Type" = Customer."Contact Type"::Company);
      EXIT(FALSE);
    END;

    [External]
    PROCEDURE UpdateCouponCodes@6(SalesHeader@1002 : Record 36;VAR CouponCodes@1000 : Text);
    VAR
      O365CouponClaim@1001 : Record 2115;
    BEGIN
      CouponCodes := O365CouponClaim.GetAppliedClaimsForSalesDocument(SalesHeader);
    END;

    [External]
    PROCEDURE UpdateAddress@4(VAR SalesHeader@1001 : Record 36;VAR FullAddress@1002 : Text);
    VAR
      TempStandardAddress@1000 : TEMPORARY Record 730;
    BEGIN
      TempStandardAddress.CopyFromSalesHeaderSellTo(SalesHeader);
      FullAddress := TempStandardAddress.ToString;
      SalesHeader."Bill-to Address" := SalesHeader."Sell-to Address";
      SalesHeader."Bill-to Address 2" := SalesHeader."Sell-to Address 2";
      SalesHeader."Bill-to Post Code" := SalesHeader."Sell-to Post Code";
      SalesHeader."Bill-to City" := SalesHeader."Sell-to City";
      SalesHeader."Bill-to Country/Region Code" := SalesHeader."Sell-to Country/Region Code";
      SalesHeader."Bill-to County" := SalesHeader."Sell-to County";
    END;

    [External]
    PROCEDURE CalcInvoiceDiscountAmount@8(VAR SalesHeader@1001 : Record 36;VAR SubTotalAmount@1003 : Decimal;VAR DiscountTxt@1002 : Text;VAR InvoiceDiscountAmount@1005 : Decimal;VAR InvDiscAmountVisible@1006 : Boolean);
    VAR
      SalesLine@1000 : Record 37;
    BEGIN
      SalesLine.SETRANGE("Document Type",SalesHeader."Document Type");
      SalesLine.SETRANGE("Document No.",SalesHeader."No.");
      SalesLine.CALCSUMS("Inv. Discount Amount","Line Amount");
      SubTotalAmount := SalesLine."Line Amount";
      InvoiceDiscountAmount := SalesLine."Inv. Discount Amount";
      IF SalesHeader."Invoice Discount Value" <> 0 THEN
        DiscountTxt := ChangeDiscountTxt
      ELSE
        DiscountTxt := AddDiscountTxt;

      InvDiscAmountVisible := SalesHeader."Invoice Discount Value" <> 0;
    END;

    [External]
    PROCEDURE UpdateNoOfAttachmentsLabel@7(NoOfAttachments@1000 : Integer;VAR NoOfAttachmentsValueTxt@1003 : Text);
    BEGIN
      IF NoOfAttachments = 0 THEN
        NoOfAttachmentsValueTxt := AddAttachmentTxt
      ELSE
        NoOfAttachmentsValueTxt := STRSUBSTNO(NoOfAttachmentsTxt,NoOfAttachments);
    END;

    [External]
    PROCEDURE OnAfterGetSalesHeaderRecord@1(VAR SalesHeader@1000 : Record 36;VAR CurrencyFormat@1005 : Text;VAR TaxAreaDescription@1007 : Text[50]);
    VAR
      Currency@1004 : Record 4;
      GLSetup@1003 : Record 98;
      TaxArea@1002 : Record 318;
      CurrencySymbol@1001 : Text[10];
    BEGIN
      SalesHeader.SetDefaultPaymentServices;
      IF SalesHeader."Currency Code" = '' THEN BEGIN
        GLSetup.GET;
        CurrencySymbol := GLSetup.GetCurrencySymbol;
      END ELSE BEGIN
        IF Currency.GET(SalesHeader."Currency Code") THEN;
        CurrencySymbol := Currency.GetCurrencySymbol;
      END;
      CurrencyFormat := STRSUBSTNO('%1<precision, 2:2><standard format, 0>',CurrencySymbol);

      TaxAreaDescription := '';
      IF SalesHeader."Tax Area Code" <> '' THEN
        IF TaxArea.GET(SalesHeader."Tax Area Code") THEN
          TaxAreaDescription := TaxArea.GetDescriptionInCurrentLanguage;
    END;

    [External]
    PROCEDURE LookupCustomerName@5(VAR SalesHeader@1003 : Record 36;Text@1000 : Text;VAR CustomerName@1005 : Text[50];VAR CustomerEmail@1004 : Text[80]) : Boolean;
    VAR
      Customer@1002 : Record 18;
      BCO365CustomerList@1001 : Page 2316;
    BEGIN
      IF Text <> '' THEN BEGIN
        Customer.SETRANGE(Name,Text);
        IF Customer.FINDFIRST THEN;
        Customer.SETRANGE(Name);
      END;

      BCO365CustomerList.LOOKUPMODE(TRUE);
      BCO365CustomerList.SETRECORD(Customer);

      IF BCO365CustomerList.RUNMODAL = ACTION::LookupOK THEN BEGIN
        BCO365CustomerList.GETRECORD(Customer);
        SalesHeader.SetHideValidationDialog(TRUE);
        CustomerName := Customer.Name;
        SalesHeader.VALIDATE("Sell-to Customer No.",Customer."No.");
        CustomerEmail := GetCustomerEmail(SalesHeader."Sell-to Customer No.");
        EXIT(TRUE);
      END;

      EXIT(FALSE);
    END;

    [External]
    PROCEDURE NotifyOrWarnAboutCoupons@9(VAR SalesHeader@1003 : Record 36);
    BEGIN
      IF NOT HasWarnedAboutExpiredOrClaimedCoupons THEN
        HasWarnedAboutExpiredOrClaimedCoupons :=
          CouponsManagement.WarnIfExpiredOrClaimedCoupons(SalesHeader."Document Type",SalesHeader."No.");
      IF (SalesHeader."Sell-to Customer No." <> '') AND
         (NOT CouponsHasBeenCheckedForCustomer) AND (NOT HasWarnedAboutExpiredOrClaimedCoupons)
      THEN BEGIN
        COMMIT;
        IF CODEUNIT.RUN(CODEUNIT::"Coupons Sync",SalesHeader) THEN;
        NotificationShownForCustomer := CouponsManagement.ShowNotificationIfAnyNotApplied(SalesHeader);
        CouponsHasBeenCheckedForCustomer := TRUE;
      END;
    END;

    [External]
    PROCEDURE InvoiceDateChanged@26(VAR SalesHeader@1003 : Record 36);
    BEGIN
      IF NOT NotificationShownForCustomer THEN
        NotificationShownForCustomer := CouponsManagement.ShowNotificationIfAnyNotApplied(SalesHeader);
    END;

    [External]
    PROCEDURE GetCouponCodesAndCouponsExists@10(VAR SalesHeader@1001 : Record 36;VAR CouponCodes@1000 : Text;VAR CouponsExistsForCustomer@1002 : Boolean);
    VAR
      O365CouponClaim@1003 : Record 2115;
    BEGIN
      UpdateCouponCodes(SalesHeader,CouponCodes);
      CouponsExistsForCustomer := O365CouponClaim.CouponsExistForCustomer(SalesHeader."Sell-to Customer No.");
    END;

    PROCEDURE CustomerChanged@15();
    BEGIN
      CouponsManagement.RecallNotifications(NotificationShownForCustomer,HasWarnedAboutExpiredOrClaimedCoupons);
      HasWarnedAboutExpiredOrClaimedCoupons := FALSE;
      CouponsHasBeenCheckedForCustomer := FALSE;
      NotificationShownForCustomer := FALSE;
    END;

    [External]
    PROCEDURE UpdateCustomerFields@11(VAR SalesHeader@1000 : Record 36;VAR CustomerName@1002 : Text[50];VAR CustomerEmail@1001 : Text[80]);
    BEGIN
      CustomerName := SalesHeader."Sell-to Customer Name";
      CustomerEmail := GetCustomerEmail(SalesHeader."Sell-to Customer No.");
    END;

    [External]
    PROCEDURE ValidateCustomerName@12(VAR SalesHeader@1001 : Record 36;VAR CustomerName@1003 : Text[50];VAR CustomerEmail@1002 : Text[80]);
    VAR
      Customer@1000 : Record 18;
      Contact@1004 : Record 5050;
    BEGIN
      IF SalesHeader."Sell-to Customer Name" = '' THEN
        EXIT;

      // Lookup by contact number
      IF STRLEN(SalesHeader."Sell-to Customer Name") <= MAXSTRLEN(Contact."No.") THEN
        IF Contact.GET(COPYSTR(SalesHeader."Sell-to Customer Name",1,MAXSTRLEN(Contact."No."))) THEN
          IF NOT FindCustomerByContactNo(Contact."No.",Customer) THEN
            Customer.GET(CreateCustomerFromContact(Contact));

      // Lookup by customer number/name
      IF Customer."No." = '' THEN
        IF NOT Customer.GET(Customer.GetCustNoOpenCard(SalesHeader."Sell-to Customer Name",FALSE,FALSE)) THEN
          // Lookup by contact name
          IF Contact.GET(Contact.GetContNo(SalesHeader."Sell-to Customer Name")) THEN BEGIN
            IF FindCustomerByContactNo(Contact."No.",Customer) THEN BEGIN
              IF (Customer.Blocked <> Customer.Blocked::" ") OR Customer."Privacy Blocked" THEN
                ERROR(CustomerBlockedErr);
            END ELSE
              Customer.GET(CreateCustomerFromContact(Contact));
          END;

      // A customer is found, but it is blocked: silently undo the lookup.
      // (e.g. a new customer is created from lookup and immediately deleted from customer card)
      IF (Customer."No." <> '') AND ((Customer.Blocked <> Customer.Blocked::" ") OR Customer."Privacy Blocked") THEN
        ERROR('');

      // When no customer or contact is found, create a new and notify the user
      IF Customer."No." = '' THEN BEGIN
        IF SalesHeader."No." = '' THEN
          SalesHeader.INSERT(TRUE);

        Customer.GET(Customer.CreateNewCustomer(COPYSTR(SalesHeader."Sell-to Customer Name",1,MAXSTRLEN(Customer.Name)),FALSE));
        SendCustomerCreatedNotification(Customer,SalesHeader);
      END;

      EnforceCustomerTemplateIntegrity(Customer);

      SalesHeader.VALIDATE("Sell-to Customer No.",Customer."No.");
      CustomerName := Customer.Name;
      CustomerEmail := GetCustomerEmail(SalesHeader."Sell-to Customer No.");
    END;

    [External]
    PROCEDURE ValidateCustomerEmail@13(VAR SalesHeader@1002 : Record 36;CustomerEmail@1000 : Text[80]);
    VAR
      Customer@1003 : Record 18;
      MailManagement@1001 : Codeunit 9520;
    BEGIN
      IF CustomerEmail <> '' THEN BEGIN
        MailManagement.CheckValidEmailAddress(CustomerEmail);

        Customer.LOCKTABLE;
        IF (SalesHeader."Sell-to Customer No." <> '') AND Customer.WRITEPERMISSION THEN
          IF Customer.GET(SalesHeader."Sell-to Customer No.") THEN
            IF CustomerEmail <> Customer."E-Mail" THEN BEGIN
              Customer."E-Mail" := CustomerEmail;
              Customer.MODIFY(TRUE);
            END;
      END;
    END;

    PROCEDURE ValidateCustomerAddress@20(Address@1000 : Text[50];CustomerNo@1002 : Code[20]);
    VAR
      Customer@1003 : Record 18;
    BEGIN
      IF (Address <> '') AND (CustomerNo <> '') THEN BEGIN
        Customer.LOCKTABLE;
        IF Customer.WRITEPERMISSION AND Customer.GET(CustomerNo) THEN
          IF Address <> Customer.Address THEN BEGIN
            Customer.Address := Address;
            Customer.MODIFY(TRUE);
          END;
      END;
    END;

    PROCEDURE ValidateCustomerAddress2@21(Address@1000 : Text[50];CustomerNo@1002 : Code[20]);
    VAR
      Customer@1003 : Record 18;
    BEGIN
      IF (Address <> '') AND (CustomerNo <> '') THEN BEGIN
        Customer.LOCKTABLE;
        IF Customer.WRITEPERMISSION AND Customer.GET(CustomerNo) THEN
          IF Address <> Customer."Address 2" THEN BEGIN
            Customer."Address 2" := Address;
            Customer.MODIFY(TRUE);
          END;
      END;
    END;

    PROCEDURE ValidateCustomerCity@24(City@1000 : Text[30];CustomerNo@1002 : Code[20]);
    VAR
      Customer@1003 : Record 18;
    BEGIN
      IF (City <> '') AND (CustomerNo <> '') THEN BEGIN
        Customer.LOCKTABLE;
        IF Customer.WRITEPERMISSION AND Customer.GET(CustomerNo) THEN
          IF City <> Customer.City THEN BEGIN
            Customer.City := City;
            Customer.MODIFY(TRUE);
          END;
      END;
    END;

    PROCEDURE ValidateCustomerPostCode@23(PostCode@1000 : Code[20];CustomerNo@1002 : Code[20]);
    VAR
      Customer@1003 : Record 18;
    BEGIN
      IF (PostCode <> '') AND (CustomerNo <> '') THEN BEGIN
        Customer.LOCKTABLE;
        IF Customer.WRITEPERMISSION AND Customer.GET(CustomerNo) THEN
          IF PostCode <> Customer."Post Code" THEN BEGIN
            Customer."Post Code" := PostCode;
            Customer.MODIFY(TRUE);
          END;
      END;
    END;

    PROCEDURE ValidateCustomerCounty@22(County@1000 : Text[30];CustomerNo@1002 : Code[20]);
    VAR
      Customer@1003 : Record 18;
    BEGIN
      IF (County <> '') AND (CustomerNo <> '') THEN BEGIN
        Customer.LOCKTABLE;
        IF Customer.WRITEPERMISSION AND Customer.GET(CustomerNo) THEN
          IF County <> Customer.County THEN BEGIN
            Customer.County := County;
            Customer.MODIFY(TRUE);
          END;
      END;
    END;

    PROCEDURE ValidateCustomerCountryRegion@25(CountryCode@1000 : Code[10];CustomerNo@1002 : Code[20]);
    VAR
      Customer@1003 : Record 18;
    BEGIN
      IF (CountryCode <> '') AND (CustomerNo <> '') THEN BEGIN
        Customer.LOCKTABLE;
        IF Customer.WRITEPERMISSION AND Customer.GET(CustomerNo) THEN
          IF CountryCode <> Customer."Country/Region Code" THEN BEGIN
            Customer."Country/Region Code" := CountryCode;
            Customer.MODIFY(TRUE);
          END;
      END;
    END;

    [External]
    PROCEDURE OnQueryCloseForSalesHeader@14(VAR SalesHeader@1001 : Record 36;ForceExit@1000 : Boolean;CustomerName@1002 : Text[50]) : Boolean;
    BEGIN
      IF ForceExit THEN
        EXIT(TRUE);

      IF SalesHeader."No." = '' THEN
        EXIT(TRUE);

      IF CustomerName = '' THEN BEGIN
        SalesHeader.DELETE(TRUE);
        EXIT(TRUE);
      END;

      IF SalesHeader.SalesLinesExist THEN
        EXIT(TRUE);

      IF GUIALLOWED THEN
        EXIT(ProcessDraftInvoiceOnCreate(SalesHeader));
    END;

    [External]
    PROCEDURE ShowInvoiceDiscountNotification@18(VAR InvoiceDiscountNotification@1000 : Notification;DocumentRecordId@1002 : RecordID);
    BEGIN
      InvoiceDiscountNotification.ID := CREATEGUID;
      InvoiceDiscountNotification.MESSAGE := InvoiceDiscountChangedMsg;
      InvoiceDiscountNotification.SCOPE := NOTIFICATIONSCOPE::LocalScope;
      NotificationLifecycleMgt.SendNotification(InvoiceDiscountNotification,DocumentRecordId);
    END;

    [External]
    PROCEDURE LookupDescription@17(VAR SalesLine@1003 : Record 37;Text@1000 : Text;VAR DescriptionSelected@1004 : Boolean) : Boolean;
    VAR
      Item@1002 : Record 27;
      BCO365ItemList@1001 : Page 2314;
    BEGIN
      IF Text <> '' THEN BEGIN
        Item.SETRANGE(Description,Text);
        IF Item.FINDFIRST THEN;
        Item.SETRANGE(Description);
      END;

      BCO365ItemList.LOOKUPMODE(TRUE);
      BCO365ItemList.SETRECORD(Item);

      IF BCO365ItemList.RUNMODAL = ACTION::LookupOK THEN BEGIN
        BCO365ItemList.GETRECORD(Item);
        SalesLine.SetHideValidationDialog(TRUE);
        SalesLine.VALIDATE("No.",Item."No.");
        DescriptionSelected := SalesLine.Description <> '';
        EXIT(TRUE);
      END;

      EXIT(FALSE);
    END;

    [External]
    PROCEDURE ConstructCurrencyFormatString@16(VAR SalesLine@1004 : Record 37;VAR CurrencyFormat@1003 : Text);
    VAR
      Currency@1002 : Record 4;
      GLSetup@1001 : Record 98;
      CurrencySymbol@1000 : Text[10];
    BEGIN
      IF SalesLine."Currency Code" = '' THEN BEGIN
        GLSetup.GET;
        CurrencySymbol := GLSetup.GetCurrencySymbol;
      END ELSE BEGIN
        IF Currency.GET(SalesLine."Currency Code") THEN;
        CurrencySymbol := Currency.GetCurrencySymbol;
      END;
      CurrencyFormat := STRSUBSTNO('%1<precision, 2:2><standard format, 0>',CurrencySymbol);
    END;

    [External]
    PROCEDURE GetValueWithinBounds@1027(Value@1000 : Decimal;MinValue@1001 : Decimal;MaxValue@1002 : Decimal;VAR AmountOutsideOfBoundsNotificationSend@1003 : Boolean;DocumentRecordId@1004 : RecordID) : Decimal;
    BEGIN
      IF Value < MinValue THEN BEGIN
        SendOutsideRangeNotification(AmountOutsideOfBoundsNotificationSend,DocumentRecordId);
        EXIT(MinValue);
      END;
      IF Value > MaxValue THEN BEGIN
        SendOutsideRangeNotification(AmountOutsideOfBoundsNotificationSend,DocumentRecordId);
        EXIT(MaxValue);
      END;
      EXIT(Value);
    END;

    [External]
    PROCEDURE SendOutsideRangeNotification@1028(VAR AmountOutsideOfBoundsNotificationSend@1001 : Boolean;DocumentRecordId@1003 : RecordID);
    VAR
      AmountOutOfBoundsNotification@1000 : Notification;
    BEGIN
      IF AmountOutsideOfBoundsNotificationSend THEN
        EXIT;

      AmountOutOfBoundsNotification.ID := CREATEGUID;
      AmountOutOfBoundsNotification.MESSAGE := AmountOutsideRangeMsg;
      AmountOutOfBoundsNotification.SCOPE := NOTIFICATIONSCOPE::LocalScope;
      NotificationLifecycleMgt.SendNotification(AmountOutOfBoundsNotification,DocumentRecordId);
      AmountOutsideOfBoundsNotificationSend := TRUE;
    END;

    PROCEDURE LookupContactFromSalesHeader@143(VAR SalesHeader@1004 : Record 36) : Boolean;
    VAR
      Customer@1002 : Record 18;
      Contact@1000 : Record 5050;
      O365ContactLookup@1001 : Page 2179;
    BEGIN
      IF SalesHeader."Sell-to Contact No." <> '' THEN BEGIN
        Contact.GET(SalesHeader."Sell-to Contact No.");
        O365ContactLookup.SETRECORD(Contact);
      END;
      O365ContactLookup.LOOKUPMODE(TRUE);
      IF O365ContactLookup.RUNMODAL = ACTION::LookupOK THEN BEGIN
        O365ContactLookup.GETRECORD(Contact);
        IF SalesHeader."Sell-to Contact No." <> Contact."No." THEN BEGIN
          IF NOT FindCustomerByContactNo(Contact."No.",Customer) THEN
            Customer.GET(CreateCustomerFromContact(Contact));
          EnforceCustomerTemplateIntegrity(Customer);
          SalesHeader.VALIDATE("Sell-to Customer No.",Customer."No.");
        END;
        EXIT(TRUE);
      END;
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE FindCustomerByContactNo@144(ContactNo@1001 : Code[20];VAR Customer@1002 : Record 18) : Boolean;
    VAR
      ContBusRel@1000 : Record 5054;
    BEGIN
      IF NOT ContBusRel.FindByContact(ContBusRel."Link to Table"::Customer,ContactNo) THEN
        EXIT(FALSE);

      Customer.GET(ContBusRel."No.");
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE CreateCustomerFromContact@146(Contact@1000 : Record 5050) : Code[20];
    VAR
      MarketingSetup@1003 : Record 5079;
      Customer@1001 : Record 18;
    BEGIN
      MarketingSetup.GET;
      Contact.SetHideValidationDialog(TRUE);
      CASE Contact.Type OF
        Contact.Type::Company:
          BEGIN
            MarketingSetup.TESTFIELD("Cust. Template Company Code");
            Contact.CreateCustomer(MarketingSetup."Cust. Template Company Code");
          END;
        Contact.Type::Person:
          BEGIN
            MarketingSetup.TESTFIELD("Cust. Template Person Code");
            Contact.CreateCustomer(MarketingSetup."Cust. Template Person Code");
          END;
      END;

      FindCustomerByContactNo(Contact."No.",Customer);
      EXIT(Customer."No.");
    END;

    LOCAL PROCEDURE SendCustomerCreatedNotification@29(Customer@1000 : Record 18;SalesHeader@1001 : Record 36);
    VAR
      CustomerCreatedNotification@1002 : Notification;
      Type@1003 : Integer;
    BEGIN
      CustomerCreatedNotification.ID := CREATEGUID;
      CustomerCreatedNotification.MESSAGE(CustomerCreatedMsg);
      CustomerCreatedNotification.SCOPE(NOTIFICATIONSCOPE::LocalScope);
      CustomerCreatedNotification.ADDACTION(UndoTxt,CODEUNIT::"O365 Sales Invoice Mgmt",'UndoCustomerCreation');
      CustomerCreatedNotification.SETDATA('CustomerNo',Customer."No.");
      CustomerCreatedNotification.SETDATA('SalesHeaderNo',SalesHeader."No.");

      Type := SalesHeader."Document Type";
      CustomerCreatedNotification.SETDATA('SalesHeaderType',FORMAT(Type));
      NotificationLifecycleMgt.SendNotification(CustomerCreatedNotification,SalesHeader.RECORDID);
    END;

    PROCEDURE UndoCustomerCreation@31(VAR CreateCustomerNotification@1000 : Notification);
    VAR
      Customer@1002 : Record 18;
      SalesHeader@1003 : Record 36;
      CustContUpdate@1005 : Codeunit 5056;
      DocumentType@1001 : Option;
    BEGIN
      EVALUATE(DocumentType,CreateCustomerNotification.GETDATA('SalesHeaderType'));

      IF SalesHeader.GET(DocumentType,CreateCustomerNotification.GETDATA('SalesHeaderNo')) THEN BEGIN
        SalesHeader.INIT;
        SalesHeader.MODIFY;
      END;

      IF Customer.GET(CreateCustomerNotification.GETDATA('CustomerNo')) THEN BEGIN
        CustContUpdate.DeleteCustomerContacts(Customer);
        Customer.DELETE(TRUE);
      END;
    END;

    PROCEDURE GetInvoiceDiscountCaption@19(InvoiceDiscountValue@1000 : Decimal) : Text;
    BEGIN
      IF InvoiceDiscountValue = 0 THEN
        EXIT(InvoiceDiscountLbl);
      EXIT(STRSUBSTNO('%1 (%2%)',InvoiceDiscountLbl,ROUND(InvoiceDiscountValue,0.1)));
    END;

    PROCEDURE EnforceCustomerTemplateIntegrity@33(VAR Customer@1000 : Record 18);
    VAR
      ConfigTemplateLine@1002 : Record 8619;
      O365SalesInitialSetup@1003 : Record 2110;
      IdentityManagement@1001 : Codeunit 9801;
      CustomerRecRef@1005 : RecordRef;
      CustomerFieldRef@1006 : FieldRef;
      CustomerFixed@1004 : Boolean;
      OriginalLanguageID@1007 : Integer;
    BEGIN
      IF NOT IdentityManagement.IsInvAppId THEN
        EXIT;

      IF NOT O365SalesInitialSetup.GET THEN
        EXIT;

      ConfigTemplateLine.SETRANGE("Data Template Code",O365SalesInitialSetup."Default Customer Template");
      ConfigTemplateLine.SETRANGE("Table ID",DATABASE::Customer);
      // 88 = Gen. Bus. Posting Group
      // 21 = Customer Posting Group
      // 80 = Application Method
      // 104 = Reminder Terms Code
      // 28 = Fin. Charge Terms Code
      ConfigTemplateLine.SETFILTER("Field ID",'88|21|80|104|28');
      IF NOT ConfigTemplateLine.FINDSET THEN
        EXIT;

      OriginalLanguageID := GLOBALLANGUAGE;
      CustomerRecRef.GETTABLE(Customer);
      REPEAT
        IF CustomerRecRef.FIELDEXIST(ConfigTemplateLine."Field ID") THEN BEGIN
          IF ConfigTemplateLine."Language ID" <> 0 THEN
            GLOBALLANGUAGE := ConfigTemplateLine."Language ID"; // When formatting the value, make sure we are using the correct language
          CustomerFieldRef := CustomerRecRef.FIELD(ConfigTemplateLine."Field ID");
          IF FORMAT(CustomerFieldRef.VALUE) <> ConfigTemplateLine."Default Value" THEN BEGIN
            CustomerFieldRef.VALIDATE(ConfigTemplateLine."Default Value");
            ConfigValidateManagement.ValidateFieldValue(
              CustomerRecRef,CustomerFieldRef,ConfigTemplateLine."Default Value",FALSE,ConfigTemplateLine."Language ID");
            CustomerFixed := TRUE;
          END;
          GLOBALLANGUAGE := OriginalLanguageID;
        END;
      UNTIL ConfigTemplateLine.NEXT = 0;

      IF CustomerFixed THEN
        IF CustomerRecRef.MODIFY(TRUE) THEN
          Customer.GET(Customer."No.");
    END;

    BEGIN
    END.
  }
}

