OBJECT Codeunit 13611 OIOUBL Exp. Issued Fin. Chrg.
{
  OBJECT-PROPERTIES
  {
    Date=25-05-18;
    Time=12:00:00;
    Version List=NAVDK11.00.00.22292;
  }
  PROPERTIES
  {
    TableNo=304;
    Permissions=TableData 304=rm;
    OnRun=VAR
            IssuedFinChargeMemoLine2@1101100006 : Record 305;
            RBMgt@1060002 : Codeunit 419;
            XMLDOMManagement@1060013 : Codeunit 6224;
            PermissionManager@1060014 : Codeunit 9002;
            OIOUBLLibrary@1060015 : Codeunit 13619;
            XMLdocOut@1060000 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlDocument";
            XMLCurrNode@1101100001 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
            XMLNewChild@1101100000 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
            CurrencyCode@1060001 : Code[10];
            Prefix@1101100002 : Text[30];
            DocNameSpace@1101100003 : Text[100];
            FromFile@1060004 : Text[1024];
            DocNameSpace2@1060006 : Text[250];
            Prefix2@1060003 : Text[30];
            VATPercentage@1060007 : Decimal;
            TaxableAmount@1060010 : Decimal;
            TaxAmount@1060009 : Decimal;
            TotalAmount@1060008 : Decimal;
            DocumentType@1060011 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Finance Charge,Reminder';
          BEGIN
            CODEUNIT.RUN(CODEUNIT::"OIOUBL Check Issued Fin. Chrg.",Rec);
            ReadGLSetup;
            ReadCompanyInfo;

            IF "Currency Code" = '' THEN
              CurrencyCode := GLSetup."LCY Code"
            ELSE
              CurrencyCode := "Currency Code";

            IF NOT ContainsValidLine(IssuedFinChargeMemoLine,"No.") THEN
              EXIT;

            FromFile := RBMgt.ServerTempFileName('');

            // FinCharge
            Header :=
              '<?xml version="1.0" encoding="UTF-8" ?> ' +
              '<Reminder xmlns="urn:oasis:names:specification:ubl:schema:xsd:Reminder-2" ' +
              'xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" ' +
              'xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" ' +
              'xmlns:ccts="urn:oasis:names:specification:ubl:schema:xsd:CoreComponentParameters-2" ' +
              'xmlns:sdt="urn:oasis:names:specification:ubl:schema:xsd:SpecializedDatatypes-2" ' +
              'xmlns:udt="urn:un:unece:uncefact:data:specification:UnqualifiedDataTypesSchemaModule:2" ' +
              'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" ' +
              'xsi:schemaLocation="urn:oasis:names:specification:ubl:schema:xsd:Reminder-2 UBL-Reminder-2.0.xsd"/> ';

            XMLDOMManagement.LoadXMLDocumentFromText(Header,XMLdocOut);
            XMLCurrNode := XMLdocOut.DocumentElement;

            WITH OIOUBLDOMManagement DO BEGIN
              DocNameSpace := 'urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2';
              DocNameSpace2 := 'urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2';

              Prefix := 'cbc';
              Prefix2 := 'cac';

              AddElement(XMLCurrNode,'UBLVersionID','2.0',DocNameSpace,XMLNewChild,Prefix);
              AddElement(XMLCurrNode,'CustomizationID','OIOUBL-2.02',DocNameSpace,XMLNewChild,Prefix);

              AddElement(XMLCurrNode,'ProfileID','Procurement-BilSim-1.0',DocNameSpace,XMLNewChild,Prefix);
              XMLCurrNode := XMLNewChild;
              AddAttribute(XMLCurrNode,'schemeID','urn:oioubl:id:profileid-1.2');
              AddAttribute(XMLCurrNode,'schemeAgencyID','320');
              XMLCurrNode := XMLCurrNode.ParentNode;

              AddElement(XMLCurrNode,'ID',"No.",DocNameSpace,XMLNewChild,Prefix);
              AddElement(XMLCurrNode,'CopyIndicator',OIOUBLDocumentEncode.BooleanToText("Elec. Fin. Charge Memo Created"),
                DocNameSpace,XMLNewChild,Prefix);
              AddElement(XMLCurrNode,'IssueDate',OIOUBLDocumentEncode.DateToText("Posting Date"),DocNameSpace,XMLNewChild,Prefix);

              AddElement(XMLCurrNode,'ReminderTypeCode','Reminder',DocNameSpace,XMLNewChild,Prefix);
              XMLCurrNode := XMLNewChild;
              AddAttribute(XMLCurrNode,'listID','urn:oioubl.codelist:remindertypecode-1.1');
              AddAttribute(XMLCurrNode,'listAgencyID','320');
              XMLCurrNode := XMLCurrNode.ParentNode;

              AddElement(XMLCurrNode,'ReminderSequenceNumeric','1',DocNameSpace,XMLNewChild,Prefix);
              AddElement(XMLCurrNode,'DocumentCurrencyCode',CurrencyCode,DocNameSpace,XMLNewChild,Prefix);
              AddElement(XMLCurrNode,'AccountingCost',"Account Code",DocNameSpace,XMLNewChild,Prefix);

              // FinCharge->AccountingSupplierParty
              AddElement(XMLCurrNode,'AccountingSupplierParty','',DocNameSpace2,XMLNewChild,Prefix2);
              XMLCurrNode := XMLNewChild;

              AddElement(XMLCurrNode,'Party','',DocNameSpace2,XMLNewChild,Prefix2);

              XMLCurrNode := XMLNewChild;
              AddElement(XMLCurrNode,'WebsiteURI',CompanyInfo."Home Page",DocNameSpace,XMLNewChild,Prefix);
              AddElement(XMLCurrNode,'EndpointID',OIOUBLDocumentEncode.GetCompanyVATRegNo(CompanyInfo."VAT Registration No."),
                DocNameSpace,XMLNewChild,Prefix);
              XMLCurrNode := XMLNewChild;
              AddAttribute(XMLCurrNode,'schemeID','DK:CVR');
              XMLCurrNode := XMLCurrNode.ParentNode;

              // FinCharge->AccountingSupplierParty->PartyIdentification
              AddElement(XMLCurrNode,'PartyIdentification','',DocNameSpace2,XMLNewChild,Prefix2);

              XMLCurrNode := XMLNewChild;
              AddElement(XMLCurrNode,'ID',OIOUBLDocumentEncode.GetCompanyVATRegNo(CompanyInfo."VAT Registration No."),
                DocNameSpace,XMLNewChild,Prefix);
              XMLCurrNode := XMLNewChild;
              AddAttribute(XMLCurrNode,'schemeID','DK:CVR');
              XMLCurrNode := XMLCurrNode.ParentNode;

              // FinCharge->AccountingSupplierParty->PartyName
              XMLCurrNode := XMLCurrNode.ParentNode;
              AddElement(XMLCurrNode,'PartyName','',DocNameSpace2,XMLNewChild,Prefix2);

              XMLCurrNode := XMLNewChild;
              AddElement(XMLCurrNode,'Name',CompanyInfo.Name,DocNameSpace,XMLNewChild,Prefix);

              // FinCharge->AccountingSupplierParty->PostalAddress
              XMLCurrNode := XMLCurrNode.ParentNode;
              AddElement(XMLCurrNode,'PostalAddress','',DocNameSpace2,XMLNewChild,Prefix2);

              XMLCurrNode := XMLNewChild;
              AddElement(XMLCurrNode,'AddressFormatCode','StructuredLax',DocNameSpace,XMLNewChild,Prefix);
              XMLCurrNode := XMLNewChild;
              AddAttribute(XMLCurrNode,'listID','urn:oioubl:codelist:addressformatcode-1.1');
              AddAttribute(XMLCurrNode,'listAgencyID','320');
              XMLCurrNode := XMLCurrNode.ParentNode;

              AddElement(XMLCurrNode,'StreetName',CompanyInfo.Address,DocNameSpace,XMLNewChild,Prefix);
              AddElement(XMLCurrNode,'AdditionalStreetName',CompanyInfo."Address 2",DocNameSpace,XMLNewChild,Prefix);
              AddElement(XMLCurrNode,'InhouseMail',CompanyInfo."E-Mail",DocNameSpace,XMLNewChild,Prefix);
              AddElement(XMLCurrNode,'CityName',CompanyInfo.City,DocNameSpace,XMLNewChild,Prefix);
              AddElement(XMLCurrNode,'PostalZone',CompanyInfo."Post Code",DocNameSpace,XMLNewChild,Prefix);

              // FinCharge->AccountingSupplierParty->Address->Country
              AddElement(XMLCurrNode,'Country','',DocNameSpace2,XMLNewChild,Prefix2);

              XMLCurrNode := XMLNewChild;
              AddElement(XMLCurrNode,'IdentificationCode',CompanyInfo."Country/Region Code",DocNameSpace,XMLNewChild,Prefix);

              // FinCharge->AccountingSupplierParty->PartyTextScheme
              XMLCurrNode := XMLCurrNode.ParentNode;
              XMLCurrNode := XMLCurrNode.ParentNode;
              AddElement(XMLCurrNode,'PartyTaxScheme','',DocNameSpace2,XMLNewChild,Prefix2);

              XMLCurrNode := XMLNewChild;
              AddElement(XMLCurrNode,'CompanyID',OIOUBLDocumentEncode.GetCompanyVATRegNo(CompanyInfo."VAT Registration No."),
                DocNameSpace,XMLNewChild,Prefix);
              XMLCurrNode := XMLNewChild;
              AddAttribute(XMLCurrNode,'schemeID','DK:SE');
              XMLCurrNode := XMLCurrNode.ParentNode;

              AddElement(XMLCurrNode,'TaxScheme','',DocNameSpace2,XMLNewChild,Prefix2);

              XMLCurrNode := XMLNewChild;
              AddElement(XMLCurrNode,'ID','63',DocNameSpace,XMLNewChild,Prefix);
              XMLCurrNode := XMLNewChild;
              AddAttribute(XMLCurrNode,'schemeAgencyID','320');
              AddAttribute(XMLCurrNode,'schemeID','urn:oioubl:id:taxschemeid-1.1');
              XMLCurrNode := XMLCurrNode.ParentNode;
              AddElement(XMLCurrNode,'Name','Moms',DocNameSpace,XMLNewChild,Prefix);

              // FinCharge->AccountingSupplierParty->PartyLegalEntity
              XMLCurrNode := XMLCurrNode.ParentNode;
              XMLCurrNode := XMLCurrNode.ParentNode;
              AddElement(XMLCurrNode,'PartyLegalEntity','',DocNameSpace2,XMLNewChild,Prefix2);

              XMLCurrNode := XMLNewChild;
              AddElement(XMLCurrNode,'RegistrationName',CompanyInfo.Name,DocNameSpace,XMLNewChild,Prefix);
              AddElement(XMLCurrNode,'CompanyID',OIOUBLDocumentEncode.GetCompanyVATRegNo(CompanyInfo."VAT Registration No."),
                DocNameSpace,XMLNewChild,Prefix);
              XMLCurrNode := XMLNewChild;
              AddAttribute(XMLCurrNode,'schemeID','DK:CVR');
              XMLCurrNode := XMLCurrNode.ParentNode;

              XMLCurrNode := XMLCurrNode.ParentNode;
              XMLCurrNode := XMLCurrNode.ParentNode;
              XMLCurrNode := XMLCurrNode.ParentNode;

              // FinCharge->AccountingCustomerParty
              AddElement(XMLCurrNode,'AccountingCustomerParty','',DocNameSpace2,XMLNewChild,Prefix2);
              XMLCurrNode := XMLNewChild;

              AddElement(XMLCurrNode,'Party','',DocNameSpace2,XMLNewChild,Prefix2);

              XMLCurrNode := XMLNewChild;
              AddElement(XMLCurrNode,'EndpointID',"EAN No.",DocNameSpace,XMLNewChild,Prefix);
              XMLCurrNode := XMLNewChild;
              AddAttribute(XMLCurrNode,'schemeAgencyID','9');
              AddAttribute(XMLCurrNode,'schemeID','GLN');
              XMLCurrNode := XMLCurrNode.ParentNode;

              // FinCharge->AccountingCustomerParty->PartyIdentification
              AddElement(XMLCurrNode,'PartyIdentification','',DocNameSpace2,XMLNewChild,Prefix2);

              XMLCurrNode := XMLNewChild;
              AddElement(XMLCurrNode,'ID',OIOUBLDocumentEncode.GetCustomerVATRegNo("VAT Registration No."),
                DocNameSpace,XMLNewChild,Prefix);
              XMLCurrNode := XMLNewChild;
              AddAttribute(XMLCurrNode,'schemeID','DK:CVR');
              XMLCurrNode := XMLCurrNode.ParentNode;

              // FinCharge->AccountingCustomerParty->PartyName
              XMLCurrNode := XMLCurrNode.ParentNode;
              AddElement(XMLCurrNode,'PartyName','',DocNameSpace2,XMLNewChild,Prefix2);

              XMLCurrNode := XMLNewChild;
              AddElement(XMLCurrNode,'Name',Name,DocNameSpace,XMLNewChild,Prefix);

              // FinCharge->AccountingCustomerParty->PostalAddress
              XMLCurrNode := XMLCurrNode.ParentNode;
              AddElement(XMLCurrNode,'PostalAddress','',DocNameSpace2,XMLNewChild,Prefix2);

              XMLCurrNode := XMLNewChild;
              AddElement(XMLCurrNode,'AddressFormatCode','StructuredLax',DocNameSpace,XMLNewChild,Prefix);
              XMLCurrNode := XMLNewChild;
              AddAttribute(XMLCurrNode,'listID','urn:oioubl:codelist:addressformatcode-1.1');
              AddAttribute(XMLCurrNode,'listAgencyID','320');
              XMLCurrNode := XMLCurrNode.ParentNode;

              AddElement(XMLCurrNode,'StreetName',Address,DocNameSpace,XMLNewChild,Prefix);
              AddElement(XMLCurrNode,'AdditionalStreetName',"Address 2",DocNameSpace,XMLNewChild,Prefix);
              AddElement(XMLCurrNode,'CityName',City,DocNameSpace,XMLNewChild,Prefix);
              AddElement(XMLCurrNode,'PostalZone',"Post Code",DocNameSpace,XMLNewChild,Prefix);

              // FinCharge->AccountingCustomerParty->Address->Country
              AddElement(XMLCurrNode,'Country','',DocNameSpace2,XMLNewChild,Prefix2);

              XMLCurrNode := XMLNewChild;
              AddElement(XMLCurrNode,'IdentificationCode',OIOUBLDocumentEncode.GetOIOUBLCountryRegionCode("Country/Region Code"),
                DocNameSpace,XMLNewChild,Prefix);

              // FinCharge->AccountingCustomerParty->Contact
              XMLCurrNode := XMLCurrNode.ParentNode;
              XMLCurrNode := XMLCurrNode.ParentNode;
              AddElement(XMLCurrNode,'Contact','',DocNameSpace2,XMLNewChild,Prefix2);
              XMLCurrNode := XMLNewChild;
              AddElement(XMLCurrNode,'ID',Contact,DocNameSpace,XMLNewChild,Prefix);

              AddElement(XMLCurrNode,'Name',Contact,DocNameSpace,XMLNewChild,Prefix);
              AddElement(XMLCurrNode,'Telephone',"Contact Phone No.",DocNameSpace,XMLNewChild,Prefix);
              AddElement(XMLCurrNode,'Telefax',"Contact Fax No.",DocNameSpace,XMLNewChild,Prefix);
              AddElement(XMLCurrNode,'ElectronicMail',"Contact E-Mail",DocNameSpace,XMLNewChild,Prefix);

              XMLCurrNode := XMLCurrNode.ParentNode;
              XMLCurrNode := XMLCurrNode.ParentNode;
              XMLCurrNode := XMLCurrNode.ParentNode;

              // FinCharge->PaymentMeans
              AddElement(XMLCurrNode,'PaymentMeans','',DocNameSpace2,XMLNewChild,Prefix2);
              XMLCurrNode := XMLNewChild;

              AddElement(XMLCurrNode,'ID','1',DocNameSpace,XMLNewChild,Prefix);
              AddElement(XMLCurrNode,'PaymentMeansCode','42',DocNameSpace,XMLNewChild,Prefix);
              AddElement(XMLCurrNode,'PaymentDueDate',OIOUBLDocumentEncode.DateToText("Due Date"),DocNameSpace,XMLNewChild,Prefix);
              AddElement(XMLCurrNode,'PaymentChannelCode',GetPaymentChannelCode,DocNameSpace,XMLNewChild,Prefix);
              XMLCurrNode := XMLNewChild;
              AddAttribute(XMLCurrNode,'listAgencyID','320');
              AddAttribute(XMLCurrNode,'listID','urn:oioubl:codelist:paymentchannelcode-1.1');
              XMLCurrNode := XMLCurrNode.ParentNode;

              // FinCharge->PaymentMeans->PayeeFinancialAccount
              AddElement(XMLCurrNode,'PayeeFinancialAccount','',DocNameSpace2,XMLNewChild,Prefix2);
              XMLCurrNode := XMLNewChild;

              AddElement(XMLCurrNode,'ID',CompanyInfo."Bank Account No.",DocNameSpace,XMLNewChild,Prefix);

              // FinCharge->PaymentMeans->PayeeFinancialAccount->FinancialInstitutionBranch
              AddElement(XMLCurrNode,'FinancialInstitutionBranch','',DocNameSpace2,XMLNewChild,Prefix2);
              XMLCurrNode := XMLNewChild;

              AddElement(XMLCurrNode,'ID',CompanyInfo."Bank Branch No.",DocNameSpace,XMLNewChild,Prefix);

              // FinCharge->PaymentMeans->PayeeFinancialAccount->FinancialInstitutionBranch->FinancialInstitution
              AddElement(XMLCurrNode,'FinancialInstitution','',DocNameSpace2,XMLNewChild,Prefix2);
              XMLCurrNode := XMLNewChild;

              IF CompanyInfo."SWIFT Code" <> '' THEN
                AddElement(XMLCurrNode,'ID',CompanyInfo."SWIFT Code",DocNameSpace,XMLNewChild,Prefix)
              ELSE
                AddElement(XMLCurrNode,'ID','null',DocNameSpace,XMLNewChild,Prefix);
              AddElement(XMLCurrNode,'Name',CompanyInfo."Bank Name",DocNameSpace,XMLNewChild,Prefix);

              XMLCurrNode := XMLCurrNode.ParentNode;
              XMLCurrNode := XMLCurrNode.ParentNode;
              XMLCurrNode := XMLCurrNode.ParentNode;
              XMLCurrNode := XMLCurrNode.ParentNode;

              // FinCharge->PaymentTerms
              TotalAmount := 0;
              IssuedFinChargeMemoLine2.RESET;
              IssuedFinChargeMemoLine2.COPY(IssuedFinChargeMemoLine);
              IF IssuedFinChargeMemoLine2.FINDSET THEN
                REPEAT
                  TotalAmount := TotalAmount + IssuedFinChargeMemoLine2.Amount + IssuedFinChargeMemoLine2."VAT Amount";
                UNTIL IssuedFinChargeMemoLine2.NEXT = 0;

              AddElement(XMLCurrNode,'PaymentTerms','',DocNameSpace2,XMLNewChild,Prefix2);
              XMLCurrNode := XMLNewChild;

              AddElement(XMLCurrNode,'ID','1',DocNameSpace,XMLNewChild,Prefix);
              AddElement(XMLCurrNode,'PaymentMeansID','1',DocNameSpace,XMLNewChild,Prefix);
              AddElement(XMLCurrNode,'Amount',OIOUBLDocumentEncode.DecimalToText(TotalAmount),DocNameSpace,XMLNewChild,Prefix);
              XMLCurrNode := XMLNewChild;
              AddAttribute(XMLCurrNode,'currencyID',"Currency Code");
              XMLCurrNode := XMLCurrNode.ParentNode;

              AddElement(XMLCurrNode,'PenaltyPeriod','',DocNameSpace2,XMLNewChild,Prefix2);

              XMLCurrNode := XMLNewChild;
              AddElement(XMLCurrNode,'StartDate',OIOUBLDocumentEncode.DateToText("Due Date"),DocNameSpace,XMLNewChild,Prefix);

              XMLCurrNode := XMLCurrNode.ParentNode;
              XMLCurrNode := XMLCurrNode.ParentNode;

              // FinCharge->TaxTotal (for ("Normal VAT" AND "VAT %" <> 0) OR "Full VAT")
              IssuedFinChargeMemoLineFound := FALSE;
              VATPercentage := 0;
              IssuedFinChargeMemoLine2.RESET;
              IssuedFinChargeMemoLine2.COPY(IssuedFinChargeMemoLine);
              IssuedFinChargeMemoLine2.SETFILTER(
                "VAT Calculation Type",'%1|%2',IssuedFinChargeMemoLine2."VAT Calculation Type"::"Normal VAT",
                IssuedFinChargeMemoLine2."VAT Calculation Type"::"Full VAT");
              IF IssuedFinChargeMemoLine2.FINDFIRST THEN BEGIN
                TaxableAmount := 0;
                TaxAmount := 0;
                IF IssuedFinChargeMemoLine2."VAT Calculation Type" = IssuedFinChargeMemoLine2."VAT Calculation Type"::"Full VAT" THEN
                  VATPercentage := IssuedFinChargeMemoLine2."VAT %";
                REPEAT
                  CASE IssuedFinChargeMemoLine2."VAT Calculation Type" OF
                    IssuedFinChargeMemoLine2."VAT Calculation Type"::"Normal VAT":
                      IF IssuedFinChargeMemoLine2."VAT %" <> 0 THEN BEGIN
                        UpdateTaxAmtAndTaxableAmt(IssuedFinChargeMemoLine2.Amount,IssuedFinChargeMemoLine2."VAT Amount",
                          TaxableAmount,TaxAmount);
                        IF VATPercentage = 0 THEN
                          VATPercentage := IssuedFinChargeMemoLine2."VAT %";
                      END;
                    IssuedFinChargeMemoLine2."VAT Calculation Type"::"Full VAT":
                      UpdateTaxAmtAndTaxableAmt(
                        IssuedFinChargeMemoLine2.Amount,IssuedFinChargeMemoLine2."VAT Amount",TaxableAmount,TaxAmount);
                  END;
                UNTIL IssuedFinChargeMemoLine2.NEXT = 0;

                IF IssuedFinChargeMemoLineFound THEN BEGIN
                  AddElement(XMLCurrNode,'TaxTotal','',DocNameSpace2,XMLNewChild,Prefix2);
                  XMLCurrNode := XMLNewChild;

                  AddElement(XMLCurrNode,'TaxAmount',
                    OIOUBLDocumentEncode.DecimalToText(TaxAmount),DocNameSpace,XMLNewChild,Prefix);
                  XMLCurrNode := XMLNewChild;
                  AddAttribute(XMLCurrNode,'currencyID',"Currency Code");
                  XMLCurrNode := XMLCurrNode.ParentNode;

                  // FinCharge->TaxTotal->TaxSubtotal
                  AddElement(XMLCurrNode,'TaxSubtotal','',DocNameSpace2,XMLNewChild,Prefix2);
                  XMLCurrNode := XMLNewChild;

                  AddElement(XMLCurrNode,'TaxableAmount',
                    OIOUBLDocumentEncode.DecimalToText(TaxableAmount),DocNameSpace,XMLNewChild,Prefix);
                  XMLCurrNode := XMLNewChild;
                  AddAttribute(XMLCurrNode,'currencyID',"Currency Code");
                  XMLCurrNode := XMLCurrNode.ParentNode;

                  AddElement(XMLCurrNode,'TaxAmount',
                    OIOUBLDocumentEncode.DecimalToText(TaxAmount),DocNameSpace,XMLNewChild,Prefix);
                  XMLCurrNode := XMLNewChild;
                  AddAttribute(XMLCurrNode,'currencyID',"Currency Code");
                  XMLCurrNode := XMLCurrNode.ParentNode;

                  // FinCharge->TaxTotal->TaxSubtotal->TaxCategory
                  AddElement(XMLCurrNode,'TaxCategory','',DocNameSpace2,XMLNewChild,Prefix2);
                  XMLCurrNode := XMLNewChild;

                  AddElement(XMLCurrNode,'ID',GetTaxCategoryID(IssuedFinChargeMemoLine2."VAT Calculation Type",
                      VATPercentage),DocNameSpace,XMLNewChild,Prefix);
                  XMLCurrNode := XMLNewChild;
                  AddAttribute(XMLCurrNode,'schemeID','urn:oioubl:id:taxcategoryid-1.1');
                  AddAttribute(XMLCurrNode,'schemeAgencyID','320');
                  XMLCurrNode := XMLCurrNode.ParentNode;

                  AddElement(XMLCurrNode,'Percent',OIOUBLDocumentEncode.DecimalToText(VATPercentage),
                    DocNameSpace,XMLNewChild,Prefix);

                  // FinCharge->TaxTotal->TaxSubtotal->TaxCategory->TaxScheme
                  AddElement(XMLCurrNode,'TaxScheme','',DocNameSpace2,XMLNewChild,Prefix2);
                  XMLCurrNode := XMLNewChild;

                  AddElement(XMLCurrNode,'ID','63',DocNameSpace,XMLNewChild,Prefix);
                  XMLCurrNode := XMLNewChild;
                  AddAttribute(XMLCurrNode,'schemeID','urn:oioubl:id:taxschemeid-1.1');
                  XMLCurrNode := XMLCurrNode.ParentNode;
                  AddElement(XMLCurrNode,'Name','Moms',DocNameSpace,XMLNewChild,Prefix);

                  XMLCurrNode := XMLCurrNode.ParentNode;
                  XMLCurrNode := XMLCurrNode.ParentNode;
                  XMLCurrNode := XMLCurrNode.ParentNode;
                  XMLCurrNode := XMLCurrNode.ParentNode;
                END;
              END;

              // FinCharge->TaxTotal (for "Normal VAT" AND "VAT %" = 0)
              IssuedFinChargeMemoLineFound := FALSE;
              VATPercentage := 0;
              IssuedFinChargeMemoLine2.RESET;
              IssuedFinChargeMemoLine2.COPY(IssuedFinChargeMemoLine);
              IssuedFinChargeMemoLine2.SETFILTER("VAT Calculation Type",'%1',IssuedFinChargeMemoLine2."VAT Calculation Type"::"Normal VAT");
              IssuedFinChargeMemoLine2.SETFILTER("VAT %",'0');
              IF IssuedFinChargeMemoLine2.FINDFIRST THEN BEGIN
                TaxableAmount := 0;
                TaxAmount := 0;
                VATPercentage := IssuedFinChargeMemoLine2."VAT %";
                REPEAT
                  UpdateTaxAmtAndTaxableAmt(IssuedFinChargeMemoLine2.Amount,IssuedFinChargeMemoLine2."VAT Amount",
                    TaxableAmount,TaxAmount);
                UNTIL IssuedFinChargeMemoLine2.NEXT = 0;

                IF IssuedFinChargeMemoLineFound THEN BEGIN
                  AddElement(XMLCurrNode,'TaxTotal','',DocNameSpace2,XMLNewChild,Prefix2);
                  XMLCurrNode := XMLNewChild;

                  AddElement(XMLCurrNode,'TaxAmount',
                    OIOUBLDocumentEncode.DecimalToText(TaxAmount),DocNameSpace,XMLNewChild,Prefix);
                  XMLCurrNode := XMLNewChild;
                  AddAttribute(XMLCurrNode,'currencyID',"Currency Code");
                  XMLCurrNode := XMLCurrNode.ParentNode;

                  // FinCharge->TaxTotal->TaxSubtotal
                  AddElement(XMLCurrNode,'TaxSubtotal','',DocNameSpace2,XMLNewChild,Prefix2);
                  XMLCurrNode := XMLNewChild;
                  AddElement(XMLCurrNode,'TaxableAmount',
                    OIOUBLDocumentEncode.DecimalToText(TaxableAmount),DocNameSpace,XMLNewChild,Prefix);
                  XMLCurrNode := XMLNewChild;
                  AddAttribute(XMLCurrNode,'currencyID',"Currency Code");
                  XMLCurrNode := XMLCurrNode.ParentNode;

                  AddElement(XMLCurrNode,'TaxAmount',
                    OIOUBLDocumentEncode.DecimalToText(TaxAmount),DocNameSpace,XMLNewChild,Prefix);
                  XMLCurrNode := XMLNewChild;
                  AddAttribute(XMLCurrNode,'currencyID',"Currency Code");
                  XMLCurrNode := XMLCurrNode.ParentNode;

                  // FinCharge->TaxTotal->TaxSubtotal->TaxCategory
                  AddElement(XMLCurrNode,'TaxCategory','',DocNameSpace2,XMLNewChild,Prefix2);
                  XMLCurrNode := XMLNewChild;
                  AddElement(XMLCurrNode,'ID',GetTaxCategoryID(IssuedFinChargeMemoLine2."VAT Calculation Type",
                      VATPercentage),DocNameSpace,XMLNewChild,Prefix);
                  XMLCurrNode := XMLNewChild;
                  AddAttribute(XMLCurrNode,'schemeID','urn:oioubl:id:taxcategoryid-1.1');
                  AddAttribute(XMLCurrNode,'schemeAgencyID','320');
                  XMLCurrNode := XMLCurrNode.ParentNode;

                  AddElement(XMLCurrNode,'Percent',OIOUBLDocumentEncode.DecimalToText(VATPercentage),
                    DocNameSpace,XMLNewChild,Prefix);

                  // FinCharge->TaxTotal->TaxSubtotal->TaxCategory->TaxScheme
                  AddElement(XMLCurrNode,'TaxScheme','',DocNameSpace2,XMLNewChild,Prefix2);
                  XMLCurrNode := XMLNewChild;

                  AddElement(XMLCurrNode,'ID','63',DocNameSpace,XMLNewChild,Prefix);
                  XMLCurrNode := XMLNewChild;
                  AddAttribute(XMLCurrNode,'schemeID','urn:oioubl:id:taxschemeid-1.1');
                  XMLCurrNode := XMLCurrNode.ParentNode;
                  AddElement(XMLCurrNode,'Name','Moms',DocNameSpace,XMLNewChild,Prefix);

                  XMLCurrNode := XMLCurrNode.ParentNode;
                  XMLCurrNode := XMLCurrNode.ParentNode;
                  XMLCurrNode := XMLCurrNode.ParentNode;
                  XMLCurrNode := XMLCurrNode.ParentNode;
                END;
              END;

              // FinCharge->TaxTotal (for "Reverse Charge VAT")
              IssuedFinChargeMemoLineFound := FALSE;
              VATPercentage := 0;
              IssuedFinChargeMemoLine2.RESET;
              IssuedFinChargeMemoLine2.COPY(IssuedFinChargeMemoLine);
              IssuedFinChargeMemoLine2.SETFILTER("VAT Calculation Type",'%1',
                IssuedFinChargeMemoLine2."VAT Calculation Type"::"Reverse Charge VAT");
              IF IssuedFinChargeMemoLine2.FINDFIRST THEN BEGIN
                TaxableAmount := 0;
                TaxAmount := 0;
                VATPercentage := IssuedFinChargeMemoLine2."VAT %";
                REPEAT
                  UpdateTaxAmtAndTaxableAmt(IssuedFinChargeMemoLine2.Amount,IssuedFinChargeMemoLine2."VAT Amount",
                    TaxableAmount,TaxAmount);
                UNTIL IssuedFinChargeMemoLine2.NEXT = 0;

                IF IssuedFinChargeMemoLineFound THEN BEGIN
                  AddElement(XMLCurrNode,'TaxTotal','',DocNameSpace2,XMLNewChild,Prefix2);
                  XMLCurrNode := XMLNewChild;

                  AddElement(XMLCurrNode,'TaxAmount',
                    OIOUBLDocumentEncode.DecimalToText(TaxAmount),DocNameSpace,XMLNewChild,Prefix);
                  XMLCurrNode := XMLNewChild;
                  AddAttribute(XMLCurrNode,'currencyID',"Currency Code");
                  XMLCurrNode := XMLCurrNode.ParentNode;

                  // FinCharge->TaxTotal->TaxSubtotal
                  AddElement(XMLCurrNode,'TaxSubtotal','',DocNameSpace2,XMLNewChild,Prefix2);
                  XMLCurrNode := XMLNewChild;
                  AddElement(XMLCurrNode,'TaxableAmount',
                    OIOUBLDocumentEncode.DecimalToText(TaxableAmount),DocNameSpace,XMLNewChild,Prefix);
                  XMLCurrNode := XMLNewChild;
                  AddAttribute(XMLCurrNode,'currencyID',"Currency Code");
                  XMLCurrNode := XMLCurrNode.ParentNode;

                  AddElement(XMLCurrNode,'TaxAmount',
                    OIOUBLDocumentEncode.DecimalToText(TaxAmount),DocNameSpace,XMLNewChild,Prefix);
                  XMLCurrNode := XMLNewChild;
                  AddAttribute(XMLCurrNode,'currencyID',"Currency Code");
                  XMLCurrNode := XMLCurrNode.ParentNode;

                  // FinCharge->TaxTotal->TaxSubtotal->TaxCategory
                  AddElement(XMLCurrNode,'TaxCategory','',DocNameSpace2,XMLNewChild,Prefix2);
                  XMLCurrNode := XMLNewChild;

                  AddElement(XMLCurrNode,'ID',GetTaxCategoryID(IssuedFinChargeMemoLine2."VAT Calculation Type",
                      VATPercentage),DocNameSpace,XMLNewChild,Prefix);
                  XMLCurrNode := XMLNewChild;
                  AddAttribute(XMLCurrNode,'schemeID','urn:oioubl:id:taxcategoryid-1.1');
                  AddAttribute(XMLCurrNode,'schemeAgencyID','320');
                  XMLCurrNode := XMLCurrNode.ParentNode;

                  AddElement(XMLCurrNode,'Percent',OIOUBLDocumentEncode.DecimalToText(VATPercentage),
                    DocNameSpace,XMLNewChild,Prefix);

                  // FinCharge->TaxTotal->TaxSubtotal->TaxCategory->TaxScheme
                  AddElement(XMLCurrNode,'TaxScheme','',DocNameSpace2,XMLNewChild,Prefix2);
                  XMLCurrNode := XMLNewChild;

                  AddElement(XMLCurrNode,'ID','63',DocNameSpace,XMLNewChild,Prefix);
                  XMLCurrNode := XMLNewChild;
                  AddAttribute(XMLCurrNode,'schemeID','urn:oioubl:id:taxschemeid-1.1');
                  XMLCurrNode := XMLCurrNode.ParentNode;
                  AddElement(XMLCurrNode,'Name','Moms',DocNameSpace,XMLNewChild,Prefix);

                  XMLCurrNode := XMLCurrNode.ParentNode;
                  XMLCurrNode := XMLCurrNode.ParentNode;
                  XMLCurrNode := XMLCurrNode.ParentNode;
                  XMLCurrNode := XMLCurrNode.ParentNode;
                END;
              END;

              // FinCharge->LegalMonetaryTotal
              TaxableAmount := 0;
              TaxAmount := 0;

              IssuedFinChargeMemoLine2.RESET;
              IssuedFinChargeMemoLine2.COPY(IssuedFinChargeMemoLine);
              IssuedFinChargeMemoLineFound := FALSE;
              IF IssuedFinChargeMemoLine2.FINDSET THEN
                REPEAT
                  TaxableAmount := TaxableAmount + IssuedFinChargeMemoLine2.Amount;
                  TaxAmount := TaxAmount + IssuedFinChargeMemoLine2."VAT Amount";
                UNTIL IssuedFinChargeMemoLine2.NEXT = 0;

              AddElement(XMLCurrNode,'LegalMonetaryTotal','',
                DocNameSpace2,XMLNewChild,Prefix2);
              XMLCurrNode := XMLNewChild;

              AddElement(XMLCurrNode,'LineExtensionAmount',OIOUBLDocumentEncode.DecimalToText(TaxableAmount),
                DocNameSpace,XMLNewChild,Prefix);
              XMLCurrNode := XMLNewChild;
              AddAttribute(XMLCurrNode,'currencyID',CurrencyCode);
              XMLCurrNode := XMLCurrNode.ParentNode;

              AddElement(XMLCurrNode,'TaxExclusiveAmount',OIOUBLDocumentEncode.DecimalToText(TaxAmount),
                DocNameSpace,XMLNewChild,Prefix);
              XMLCurrNode := XMLNewChild;
              AddAttribute(XMLCurrNode,'currencyID',"Currency Code");
              XMLCurrNode := XMLCurrNode.ParentNode;

              AddElement(XMLCurrNode,'TaxInclusiveAmount',OIOUBLDocumentEncode.DecimalToText(TotalAmount),
                DocNameSpace,XMLNewChild,Prefix);
              XMLCurrNode := XMLNewChild;
              AddAttribute(XMLCurrNode,'currencyID',"Currency Code");
              XMLCurrNode := XMLCurrNode.ParentNode;

              AddElement(XMLCurrNode,'PayableAmount',OIOUBLDocumentEncode.DecimalToText(TotalAmount),
                DocNameSpace,XMLNewChild,Prefix);
              XMLCurrNode := XMLNewChild;
              AddAttribute(XMLCurrNode,'currencyID',"Currency Code");
              XMLCurrNode := XMLCurrNode.ParentNode;

              XMLCurrNode := XMLCurrNode.ParentNode;

              // FinCharge->ReminderLine
              REPEAT
                IF IssuedFinChargeMemoLine.Amount <> 0 THEN BEGIN
                  IssuedFinChargeMemoLine.TESTFIELD(Description);

                  AddElement(XMLCurrNode,'ReminderLine','',DocNameSpace2,XMLNewChild,Prefix2);
                  XMLCurrNode := XMLNewChild;

                  AddElement(XMLCurrNode,'ID',FORMAT(IssuedFinChargeMemoLine."Line No."),DocNameSpace,XMLNewChild,Prefix);
                  AddElement(XMLCurrNode,'Note',IssuedFinChargeMemoLine.Description,DocNameSpace,XMLNewChild,Prefix);

                  IF IssuedFinChargeMemoLine.Amount > 0 THEN BEGIN
                    AddElement(XMLCurrNode,'DebitLineAmount',OIOUBLDocumentEncode.DecimalToText(IssuedFinChargeMemoLine.Amount),
                      DocNameSpace,XMLNewChild,Prefix);
                    XMLCurrNode := XMLNewChild;
                    AddAttribute(XMLCurrNode,'currencyID',CurrencyCode);
                    XMLCurrNode := XMLCurrNode.ParentNode;
                  END;

                  IF IssuedFinChargeMemoLine.Amount < 0 THEN BEGIN
                    AddElement(XMLCurrNode,'CreditLineAmount',OIOUBLDocumentEncode.DecimalToText(IssuedFinChargeMemoLine.Amount),
                      DocNameSpace,XMLNewChild,Prefix);
                    XMLCurrNode := XMLNewChild;
                    AddAttribute(XMLCurrNode,'currencyID',CurrencyCode);
                    XMLCurrNode := XMLCurrNode.ParentNode;
                  END;
                  AddElement(XMLCurrNode,'AccountingCost',IssuedFinChargeMemoLine."Account Code",DocNameSpace,XMLNewChild,Prefix);

                  XMLCurrNode := XMLCurrNode.ParentNode;
                END;
              UNTIL IssuedFinChargeMemoLine.NEXT = 0;
            END;

            SalesSetup.GET;
            XMLdocOut.Save(FromFile);

            IF RBMgt.CanRunDotNetOnClient AND NOT PermissionManager.SoftwareAsAService THEN
              SalesSetup.VerifyAndSetOIOUBLPathSetup(DocumentType::"Finance Charge");

            OIOUBLLibrary.ExportXMLFile("No.",FromFile,SalesSetup."OIOUBL Fin. Chrg. Memo Path");

            IssuedFinChargeMemo.GET("No.");
            IssuedFinChargeMemo."Elec. Fin. Charge Memo Created" := TRUE;
            IssuedFinChargeMemo.MODIFY;
          END;

  }
  CODE
  {
    VAR
      GLSetup@1101100000 : Record 98;
      CompanyInfo@1101100004 : Record 79;
      IssuedFinChargeMemo@1101100015 : Record 304;
      IssuedFinChargeMemoLine@1101100006 : Record 305;
      SalesSetup@1101100014 : Record 311;
      OIOUBLDocumentEncode@1101100009 : Codeunit 13600;
      OIOUBLDOMManagement@1101100008 : Codeunit 13601;
      Header@1101100007 : Text[1000];
      GLSetupRead@1101100001 : Boolean;
      CompanyInfoRead@1101100003 : Boolean;
      IssuedFinChargeMemoLineFound@1060001 : Boolean;

    PROCEDURE ReadGLSetup@1101100011();
    BEGIN
      IF NOT GLSetupRead THEN BEGIN
        GLSetup.GET;
        GLSetupRead := TRUE;
      END;
    END;

    PROCEDURE ReadCompanyInfo@1101100000();
    BEGIN
      IF NOT CompanyInfoRead THEN BEGIN
        CompanyInfo.GET;
        CompanyInfoRead := TRUE;
      END;
    END;

    PROCEDURE GetPaymentChannelCode@1060014() : Text[7];
    BEGIN
      EXIT(CompanyInfo.GetPaymentChannelCode);
    END;

    PROCEDURE GetTaxCategoryID@1060038(Type@1060000 : 'Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax';VATPercent@1060001 : Decimal) : Text[15];
    BEGIN
      CASE Type OF
        Type::"Normal VAT":
          BEGIN
            IF VATPercent <> 0 THEN
              EXIT('StandardRated');
            EXIT('ZeroRated');
          END;
        Type::"Full VAT":
          EXIT('StandardRated');
        Type::"Reverse Charge VAT":
          EXIT('ReversedCharge');
        ELSE
          EXIT('ZeroRated');
      END;
    END;

    PROCEDURE UpdateTaxAmtAndTaxableAmt@1060001(Amount@1060005 : Decimal;VATAmount@1060004 : Decimal;VAR TaxableAmountParam@1060002 : Decimal;VAR TaxAmountParam@1060003 : Decimal);
    BEGIN
      IssuedFinChargeMemoLineFound := TRUE;
      TaxableAmountParam := TaxableAmountParam + Amount;
      TaxAmountParam := TaxAmountParam + VATAmount
    END;

    PROCEDURE ContainsValidLine@1060007(VAR IssuedFinChargeMemoLine@1060000 : Record 305;IssuedFinChargeMemoHeaderNo@1060002 : Code[20]) ReturnValue : Boolean;
    BEGIN
      ReturnValue := FALSE;
      WITH IssuedFinChargeMemoLine DO BEGIN
        SETRANGE("Finance Charge Memo No.",IssuedFinChargeMemoHeaderNo);
        SETFILTER(Type,'>%1',0);
        IF FINDSET THEN
          REPEAT
            ReturnValue := ((Type = Type::"Customer Ledger Entry") AND ("Document No." <> '')) OR
              ((Type = Type::"G/L Account") AND ("No." <> ''));
          UNTIL (NEXT = 0) OR ReturnValue;
      END;
      EXIT(ReturnValue)
    END;

    BEGIN
    END.
  }
}

