OBJECT XMLport 1601 Sales Credit Memo - PEPPOL 2.1
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Salgskreditnota - PEPPOL 2.1;
               ENU=Sales Credit Memo - PEPPOL 2.1];
    Direction=Export;
    Encoding=UTF-8;
    Namespaces=[=urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2;
                cac=urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2;
                cbc=urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2;
                ccts=urn:un:unece:uncefact:documentation:2;
                qdt=urn:oasis:names:specification:ubl:schema:xsd:QualifiedDatatypes-2;
                udt=urn:un:unece:uncefact:data:specification:UnqualifiedDataTypesSchemaModule:2];
    OnPreXMLport=BEGIN
                   GLSetup.GET;
                   GLSetup.TESTFIELD("LCY Code");
                 END;

  }
  ELEMENTS
  {
    { [{F76F4B37-89D5-4ED8-86C2-1317CF089B42}];  ;CreditNote          ;Element ;Table   ;
                                                  VariableName=CrMemoHeaderLoop;
                                                  SourceTable=Table2000000026;
                                                  SourceTableView=SORTING(Field1)
                                                                  WHERE(Field1=FILTER(1..));
                                                  MaxOccurs=Once;
                                                  Export::OnAfterGetRecord=BEGIN
                                                                             IF NOT FindNextCreditMemoRec(CrMemoHeaderLoop.Number) THEN
                                                                               currXMLport.BREAK;

                                                                             GetTotals;

                                                                             PEPPOLMgt.GetGeneralInfo(
                                                                               SalesHeader,
                                                                               ID,
                                                                               IssueDate,
                                                                               DummyVar,
                                                                               DummyVar,
                                                                               Note,
                                                                               TaxPointDate,
                                                                               DocumentCurrencyCode,
                                                                               DocumentCurrencyCodeListID,
                                                                               TaxCurrencyCode,
                                                                               TaxCurrencyCodeListID,
                                                                               AccountingCost);

                                                                             UBLVersionID := GetUBLVersionID;
                                                                             CustomizationID := GetCustomizationID;
                                                                             ProfileID := GetProfileID;
                                                                           END;
                                                                            }

    { [{7E209EA0-553C-4221-B9A6-C63C9963F39B}];1 ;UBLVersionID        ;Element ;Text    ;
                                                  NamespacePrefix=cbc }

    { [{50853779-9C19-47A1-9ECE-A93DBA66467C}];1 ;CustomizationID     ;Element ;Text    ;
                                                  NamespacePrefix=cbc }

    { [{24F0B47C-97FB-430F-8DC3-B12D87F34A0B}];1 ;ProfileID           ;Element ;Text    ;
                                                  NamespacePrefix=cbc }

    { [{F693DE36-896D-415A-9A7B-9E692702933F}];1 ;ID                  ;Element ;Text    ;
                                                  NamespacePrefix=cbc }

    { [{A3FF244F-883D-43BF-8E8D-03B5ED0A1867}];1 ;IssueDate           ;Element ;Text    ;
                                                  NamespacePrefix=cbc }

    { [{412EE434-539B-46FA-AFE1-ED2C5EBB2E35}];1 ;Note                ;Element ;Text    ;
                                                  NamespacePrefix=cbc;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 IF Note = '' THEN
                                                                                   currXMLport.SKIP;
                                                                               END;
                                                                                }

    { [{F0CFB3A7-B67A-4AFA-867A-C24C964C2597}];1 ;TaxPointDate        ;Element ;Text    ;
                                                  NamespacePrefix=cbc;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 IF TaxPointDate = '' THEN
                                                                                   currXMLport.SKIP;
                                                                               END;
                                                                                }

    { [{7426035F-C685-4AB0-B931-6865B73F5853}];1 ;DocumentCurrencyCode;Element ;Text    ;
                                                  NamespacePrefix=cbc }

    { [{93CCF3B8-F15B-40B4-8D5D-7F241D1604A6}];2 ;listID              ;Attribute;Text   ;
                                                  VariableName=DocumentCurrencyCodeListID }

    { [{1B989853-BE95-40F7-9ABF-5390E3C84071}];1 ;TaxCurrencyCode     ;Element ;Text    ;
                                                  NamespacePrefix=cbc }

    { [{F5122FBD-9907-4511-82BE-D3179BF07F70}];2 ;listID              ;Attribute;Text   ;
                                                  VariableName=TaxCurrencyCodeListID }

    { [{8ABC6136-1A86-4F83-87B6-63BB44468A3E}];1 ;AccountingCost      ;Element ;Text    ;
                                                  NamespacePrefix=cbc;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 IF AccountingCost = '' THEN
                                                                                   currXMLport.SKIP;
                                                                               END;
                                                                                }

    { [{E4EE7147-9A12-4ADF-8213-CB68CDA9691E}];1 ;InvoicePeriod       ;Element ;Text    ;
                                                  NamespacePrefix=cac;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 PEPPOLMgt.GetInvoicePeriodInfo(
                                                                                   StartDate,
                                                                                   EndDate);

                                                                                 IF (StartDate = '') AND (EndDate = '') THEN
                                                                                   currXMLport.SKIP;
                                                                               END;
                                                                                }

    { [{4526F1F6-2FC6-4B61-903E-20C91592A5B0}];2 ;StartDate           ;Element ;Text    ;
                                                  NamespacePrefix=cbc }

    { [{8426C162-FDC7-4D6D-BBEA-B5A8DFDBBB86}];2 ;EndDate             ;Element ;Text    ;
                                                  NamespacePrefix=cbc }

    { [{0B22B5D2-A63B-4119-A2B4-A1E3ACE1594F}];1 ;OrderReference      ;Element ;Text    ;
                                                  NamespacePrefix=cac;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 PEPPOLMgt.GetOrderReferenceInfo(
                                                                                   SalesHeader,
                                                                                   OrderReferenceID);

                                                                                 IF OrderReferenceID = '' THEN
                                                                                   currXMLport.SKIP;
                                                                               END;
                                                                                }

    { [{BEFEB6A5-D382-430E-A70F-082CA0D7FA86}];2 ;ID                  ;Element ;Text    ;
                                                  VariableName=OrderReferenceID;
                                                  NamespacePrefix=cbc }

    { [{9EB375A2-2D60-4B30-BBF7-7DB74028A81F}];1 ;BillingReference    ;Element ;Text    ;
                                                  NamespacePrefix=cac;
                                                  MinOccurs=Zero;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 PEPPOLMgt.GetCrMemoBillingReferenceInfo(
                                                                                   SalesCrMemoHeader,
                                                                                   InvoiceDocRefID,
                                                                                   InvoiceDocRefIssueDate);
                                                                               END;
                                                                                }

    { [{AAD93B77-5991-472C-936D-AC7DC59A10B5}];2 ;InvoiceDocumentReference;Element;Text ;
                                                  NamespacePrefix=cac;
                                                  MinOccurs=Zero;
                                                  MaxOccurs=Once;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 IF InvoiceDocRefID = '' THEN
                                                                                   currXMLport.SKIP;
                                                                               END;
                                                                                }

    { [{7839501F-3778-410C-8EDF-030693F395ED}];3 ;ID                  ;Element ;Text    ;
                                                  VariableName=InvoiceDocRefID;
                                                  NamespacePrefix=cbc;
                                                  MaxOccurs=Once }

    { [{9301D6D6-AD67-4E66-B8B9-9739AF286466}];3 ;IssueDate           ;Element ;Text    ;
                                                  VariableName=InvoiceDocRefIssueDate;
                                                  NamespacePrefix=cbc;
                                                  MinOccurs=Zero;
                                                  MaxOccurs=Once }

    { [{BB7BF69E-D2C0-4D5B-BCA3-B27415BD292D}];1 ;ContractDocumentReference;Element;Text;
                                                  NamespacePrefix=cac;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 PEPPOLMgt.GetContractDocRefInfo(
                                                                                   SalesHeader,
                                                                                   ContractDocumentReferenceID,
                                                                                   DocumentTypeCode,
                                                                                   ContractRefDocTypeCodeListID,
                                                                                   DocumentType);

                                                                                 IF ContractDocumentReferenceID = '' THEN
                                                                                   currXMLport.SKIP;
                                                                               END;
                                                                                }

    { [{214821C6-27C5-4709-B5EE-157B508FFAC5}];2 ;ID                  ;Element ;Text    ;
                                                  VariableName=ContractDocumentReferenceID;
                                                  NamespacePrefix=cbc }

    { [{AF2D961B-9717-40E9-9E53-D3948B592877}];2 ;DocumentTypeCode    ;Element ;Text    ;
                                                  NamespacePrefix=cbc }

    { [{19C8B937-BD6E-4B3F-B352-1CC42DA433BE}];3 ;listID              ;Attribute;Text   ;
                                                  VariableName=ContractRefDocTypeCodeListID }

    { [{746B2D5F-0F2F-4F3E-AD77-703E8C43644D}];2 ;DocumentType        ;Element ;Text    ;
                                                  NamespacePrefix=cbc }

    { [{A399C996-122E-4FB1-BCE0-A39F6C7D3C05}];1 ;AdditionalDocumentReference;Element;Table;
                                                  VariableName=AdditionalDocRefLoop;
                                                  SourceTable=Table2000000026;
                                                  SourceTableView=SORTING(Field1)
                                                                  WHERE(Field1=FILTER(1..));
                                                  NamespacePrefix=cac;
                                                  Export::OnPreXMLItem=BEGIN
                                                                         AdditionalDocRefLoop.SETRANGE(Number,1,1);
                                                                       END;

                                                  Export::OnAfterGetRecord=BEGIN
                                                                             PEPPOLMgt.GetAdditionalDocRefInfo(
                                                                               AdditionalDocumentReferenceID,
                                                                               AdditionalDocRefDocumentType,
                                                                               URI,
                                                                               mimeCode,
                                                                               EmbeddedDocumentBinaryObject);

                                                                             IF AdditionalDocumentReferenceID = '' THEN
                                                                               currXMLport.SKIP;
                                                                           END;
                                                                            }

    { [{2B19AB3A-36FF-4758-8A4E-051E6E31F634}];2 ;ID                  ;Element ;Text    ;
                                                  VariableName=AdditionalDocumentReferenceID;
                                                  NamespacePrefix=cbc }

    { [{2A7285B8-4234-48C9-AEC1-617467C6352B}];2 ;DocumentType        ;Element ;Text    ;
                                                  VariableName=AdditionalDocRefDocumentType;
                                                  NamespacePrefix=cbc }

    { [{4CECAF0F-98F8-4531-868C-D554AC5CDD48}];2 ;Attachment          ;Element ;Text    ;
                                                  NamespacePrefix=cac }

    { [{A1D9CBC3-5F22-43D3-98C9-B0DAE275B2B4}];3 ;EmbeddedDocumentBinaryObject;Element;Text;
                                                  NamespacePrefix=cbc;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 IF EmbeddedDocumentBinaryObject = '' THEN
                                                                                   currXMLport.SKIP;
                                                                               END;
                                                                                }

    { [{4F771851-0388-4768-9115-21880DF9F1F3}];4 ;mimeCode            ;Attribute;Text   ;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 IF mimeCode = '' THEN
                                                                                   currXMLport.SKIP;
                                                                               END;
                                                                                }

    { [{300F5751-BDF4-4B02-A8DB-DD502949FB89}];3 ;ExternalReference   ;Element ;Text    ;
                                                  NamespacePrefix=cac }

    { [{A42E44EF-9CA3-4ACE-9C4D-D435DAA66A71}];4 ;URI                 ;Element ;Text    ;
                                                  NamespacePrefix=cbc }

    { [{7AF943D3-36F7-4E93-9615-6769DA037FC4}];1 ;AccountingSupplierParty;Element;Text  ;
                                                  NamespacePrefix=cac;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 PEPPOLMgt.GetAccountingSupplierPartyInfo(
                                                                                   SupplierEndpointID,
                                                                                   SupplierSchemeID,
                                                                                   SupplierName);

                                                                                 PEPPOLMgt.GetAccountingSupplierPartyPostalAddr(
                                                                                   SalesHeader,
                                                                                   StreetName,
                                                                                   SupplierAdditionalStreetName,
                                                                                   CityName,
                                                                                   PostalZone,
                                                                                   CountrySubentity,
                                                                                   IdentificationCode,
                                                                                   listID);

                                                                                 PEPPOLMgt.GetAccountingSupplierPartyTaxScheme(
                                                                                   CompanyID,
                                                                                   CompanyIDSchemeID,
                                                                                   TaxSchemeID);

                                                                                 PEPPOLMgt.GetAccountingSupplierPartyLegalEntity(
                                                                                   PartyLegalEntityRegName,
                                                                                   PartyLegalEntityCompanyID,
                                                                                   PartyLegalEntitySchemeID,
                                                                                   SupplierRegAddrCityName,
                                                                                   SupplierRegAddrCountryIdCode,
                                                                                   SupplRegAddrCountryIdListId);

                                                                                 PEPPOLMgt.GetAccountingSupplierPartyContact(
                                                                                   SalesHeader,
                                                                                   ContactID,
                                                                                   ContactName,
                                                                                   Telephone,
                                                                                   Telefax,
                                                                                   ElectronicMail);
                                                                               END;
                                                                                }

    { [{85D08ADB-1985-4CF4-A47D-B57057B165AB}];2 ;Party               ;Element ;Text    ;
                                                  VariableName=SupplierParty;
                                                  NamespacePrefix=cac }

    { [{40765462-8307-4BCB-9520-7EBD1F1D0510}];3 ;EndpointID          ;Element ;Text    ;
                                                  VariableName=SupplierEndpointID;
                                                  NamespacePrefix=cbc;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 IF SupplierEndpointID = '' THEN
                                                                                   currXMLport.SKIP;
                                                                               END;
                                                                                }

    { [{EF76A19C-AA91-4857-9FA5-503E76321A44}];4 ;schemeID            ;Attribute;Text   ;
                                                  VariableName=SupplierSchemeID }

    { [{9FF1B643-F06E-45FB-AF2F-7707DD04CDCC}];3 ;PartyIdentification ;Element ;Text    ;
                                                  NamespacePrefix=cac;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 IF PartyIdentificationID = '' THEN
                                                                                   currXMLport.SKIP;
                                                                               END;
                                                                                }

    { [{06BBC58B-4A94-40E8-8B75-537366675D54}];4 ;ID                  ;Element ;Text    ;
                                                  VariableName=PartyIdentificationID;
                                                  NamespacePrefix=cbc }

    { [{63ABAFBC-CB34-45E7-B3E9-E19D2BC9BE9E}];5 ;schemeID            ;Attribute;Text   ;
                                                  VariableName=SupplierPartyIDSchemeID }

    { [{856DD935-77C5-4CE6-9A39-0F21734E55EE}];3 ;PartyName           ;Element ;Text    ;
                                                  VariableName=SupplierPartyName;
                                                  NamespacePrefix=cac }

    { [{8D6F4083-3D85-4727-A0BA-608357F17E8E}];4 ;Name                ;Element ;Text    ;
                                                  VariableName=SupplierName;
                                                  NamespacePrefix=cbc }

    { [{679D18F5-3F0A-4DB7-9CAD-DF303A6A905A}];3 ;PostalAddress       ;Element ;Text    ;
                                                  VariableName=SupplierPostalAddress;
                                                  NamespacePrefix=cac }

    { [{2FCE7960-9C8B-42D1-AFB9-2EFDF6F726AB}];4 ;StreetName          ;Element ;Text    ;
                                                  NamespacePrefix=cbc }

    { [{BD2E72DB-D13A-48C3-A960-6A2C258777AA}];4 ;AdditionalStreetName;Element ;Text    ;
                                                  VariableName=SupplierAdditionalStreetName;
                                                  NamespacePrefix=cbc }

    { [{17E12B42-5BC4-446D-930B-B553CEB36053}];4 ;CityName            ;Element ;Text    ;
                                                  NamespacePrefix=cbc }

    { [{5F08D7D9-DA7E-4566-99BF-649310D55E01}];4 ;PostalZone          ;Element ;Text    ;
                                                  NamespacePrefix=cbc }

    { [{A5E455EA-E20D-42B8-BCC9-C6A6D2AAB1E2}];4 ;CountrySubentity    ;Element ;Text    ;
                                                  NamespacePrefix=cbc;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 IF CountrySubentity = '' THEN
                                                                                   currXMLport.SKIP;
                                                                               END;
                                                                                }

    { [{B3600946-84BB-4939-B3C4-19D5603FBE27}];4 ;Country             ;Element ;Text    ;
                                                  NamespacePrefix=cac }

    { [{77524987-FA6D-46DA-9094-87A44D175B0B}];5 ;IdentificationCode  ;Element ;Text    ;
                                                  NamespacePrefix=cbc }

    { [{EAD5EFE4-A23D-4AAB-8354-DB71048C47A9}];6 ;listID              ;Attribute;Text    }

    { [{CEECDC24-CE2F-4623-925D-6F5B47E65C3B}];3 ;PartyTaxScheme      ;Element ;Text    ;
                                                  NamespacePrefix=cac }

    { [{EB258780-4FD3-478B-99ED-F3B3950195FD}];4 ;CompanyID           ;Element ;Text    ;
                                                  NamespacePrefix=cbc;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 IF CompanyID = '' THEN
                                                                                   currXMLport.SKIP;
                                                                               END;
                                                                                }

    { [{D1A40046-D0A4-40AB-B932-490EE96506A6}];5 ;schemeID            ;Attribute;Text   ;
                                                  VariableName=CompanyIDSchemeID }

    { [{CF630E23-C015-4DB3-A6ED-CB3D0F5E7009}];4 ;ExemptionReason     ;Element ;Text    ;
                                                  NamespacePrefix=cbc;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 IF ExemptionReason = '' THEN
                                                                                   currXMLport.SKIP;
                                                                               END;
                                                                                }

    { [{C466AD17-F56D-445A-93A8-1D83EA4D8EC2}];4 ;TaxScheme           ;Element ;Text    ;
                                                  VariableName=SupplierTaxScheme;
                                                  NamespacePrefix=cac }

    { [{1371ACB1-7757-4B85-A0AB-0CC56FCC744D}];5 ;ID                  ;Element ;Text    ;
                                                  VariableName=TaxSchemeID;
                                                  NamespacePrefix=cbc }

    { [{E131830A-2366-4F79-A75C-58767EC4924D}];3 ;PartyLegalEntity    ;Element ;Text    ;
                                                  NamespacePrefix=cac }

    { [{5DF92863-0F08-4829-9129-302A1D40EAF7}];4 ;RegistrationName    ;Element ;Text    ;
                                                  VariableName=PartyLegalEntityRegName;
                                                  NamespacePrefix=cbc;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 IF PartyLegalEntityRegName = '' THEN
                                                                                   currXMLport.SKIP;
                                                                               END;
                                                                                }

    { [{5CB26EE6-285B-40B9-AB4F-12301B54DEF2}];4 ;CompanyID           ;Element ;Text    ;
                                                  VariableName=PartyLegalEntityCompanyID;
                                                  NamespacePrefix=cbc;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 IF PartyLegalEntityCompanyID = '' THEN
                                                                                   currXMLport.SKIP;
                                                                               END;
                                                                                }

    { [{7574DA7D-C148-4C28-9425-AA6CF8FA158B}];5 ;schemeID            ;Attribute;Text   ;
                                                  VariableName=PartyLegalEntitySchemeID }

    { [{42708492-F137-41A0-A071-9E37B54CB816}];4 ;RegistrationAddress ;Element ;Text    ;
                                                  NamespacePrefix=cac;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 IF (SupplierRegAddrCityName = '') AND (SupplierRegAddrCountry = '') THEN
                                                                                   currXMLport.SKIP;
                                                                               END;
                                                                                }

    { [{25447041-FB6E-422D-8EE6-3E9261FFE370}];5 ;CityName            ;Element ;Text    ;
                                                  VariableName=SupplierRegAddrCityName;
                                                  NamespacePrefix=cbc }

    { [{DF52CDC5-852E-4FAD-951C-AE883E114026}];5 ;Country             ;Element ;Text    ;
                                                  VariableName=SupplierRegAddrCountry;
                                                  NamespacePrefix=cac }

    { [{86A0021D-58DC-4C53-A132-46426359A2B4}];6 ;IdentificationCode  ;Element ;Text    ;
                                                  VariableName=SupplierRegAddrCountryIdCode;
                                                  NamespacePrefix=cbc }

    { [{5A04635E-5EAE-4763-9E0B-B0B60972A47A}];7 ;listID              ;Attribute;Text   ;
                                                  VariableName=SupplRegAddrCountryIdListId }

    { [{7286E782-8E80-4641-8EF4-FD3D6F13A54D}];3 ;Contact             ;Element ;Text    ;
                                                  NamespacePrefix=cac }

    { [{B3A7E20A-08F8-40F8-A37C-BA6BCDE0F7F4}];4 ;ID                  ;Element ;Text    ;
                                                  VariableName=ContactID;
                                                  NamespacePrefix=cbc }

    { [{2E50DD5B-33BD-4DCE-9BC1-FAD7213E25B6}];4 ;Name                ;Element ;Text    ;
                                                  VariableName=ContactName;
                                                  NamespacePrefix=cbc }

    { [{E0C6F36E-4DBD-477B-893C-2C18AB06ABA9}];4 ;Telephone           ;Element ;Text    ;
                                                  NamespacePrefix=cbc }

    { [{8CE91BE8-F330-475D-8F5A-D1FE5C86A530}];4 ;Telefax             ;Element ;Text    ;
                                                  NamespacePrefix=cbc }

    { [{B963B219-6F2D-4868-B3A5-6554596ADAFD}];4 ;ElectronicMail      ;Element ;Text    ;
                                                  NamespacePrefix=cbc }

    { [{D350A86E-0647-4AD9-A70A-D71AA57D807B}];1 ;AccountingCustomerParty;Element;Text  ;
                                                  NamespacePrefix=cac;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 PEPPOLMgt.GetAccountingCustomerPartyInfo(
                                                                                   SalesHeader,
                                                                                   CustomerEndpointID,
                                                                                   CustomerSchemeID,
                                                                                   CustomerPartyIdentificationID,
                                                                                   CustomerPartyIDSchemeID ,
                                                                                   CustomerName);

                                                                                 PEPPOLMgt.GetAccountingCustomerPartyPostalAddr(
                                                                                   SalesHeader,
                                                                                   CustomerStreetName,
                                                                                   CustomerAdditionalStreetName,
                                                                                   CustomerCityName,
                                                                                   CustomerPostalZone,
                                                                                   CustomerCountrySubentity,
                                                                                   CustomerIdentificationCode,
                                                                                   CustomerListID);

                                                                                 PEPPOLMgt.GetAccountingCustomerPartyTaxScheme(
                                                                                   SalesHeader,
                                                                                   CustPartyTaxSchemeCompanyID,
                                                                                   CustPartyTaxSchemeCompIDSchID,
                                                                                   CustTaxSchemeID);

                                                                                 PEPPOLMgt.GetAccountingCustomerPartyLegalEntity(
                                                                                   SalesHeader,
                                                                                   CustPartyLegalEntityRegName,
                                                                                   CustPartyLegalEntityCompanyID,
                                                                                   CustPartyLegalEntityIDSchemeID);

                                                                                 PEPPOLMgt.GetAccountingCustomerPartyContact(
                                                                                   SalesHeader,
                                                                                   CustContactID,
                                                                                   CustContactName,
                                                                                   CustContactTelephone,
                                                                                   CustContactTelefax,
                                                                                   CustContactElectronicMail);
                                                                               END;
                                                                                }

    { [{F1474403-75BE-448B-96C6-FF36B4DA4AFF}];2 ;Party               ;Element ;Text    ;
                                                  VariableName=CustomerParty;
                                                  NamespacePrefix=cac }

    { [{1E13BBF0-468F-445D-ABB7-482FFF9A33F0}];3 ;EndpointID          ;Element ;Text    ;
                                                  VariableName=CustomerEndpointID;
                                                  NamespacePrefix=cbc;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 IF CustomerEndpointID = '' THEN
                                                                                   currXMLport.SKIP;
                                                                               END;
                                                                                }

    { [{983A6954-F090-46DA-A971-1407CE13F5FE}];4 ;schemeID            ;Attribute;Text   ;
                                                  VariableName=CustomerSchemeID }

    { [{EDC79C50-9FE6-49F4-96F9-8195193C1867}];3 ;PartyIdentification ;Element ;Text    ;
                                                  VariableName=CustomerPartyIdentification;
                                                  NamespacePrefix=cac;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 IF CustomerPartyIdentificationID = '' THEN
                                                                                   currXMLport.SKIP;
                                                                               END;
                                                                                }

    { [{03611E11-6D52-4F3E-B82B-BB9066D856F8}];4 ;ID                  ;Element ;Text    ;
                                                  VariableName=CustomerPartyIdentificationID;
                                                  NamespacePrefix=cbc }

    { [{643304B9-C69C-4923-9918-79D2C73B5AAF}];5 ;schemeID            ;Attribute;Text   ;
                                                  VariableName=CustomerPartyIDSchemeID }

    { [{29179A51-CD41-473C-BF5C-3C50C21CA5F4}];3 ;PartyName           ;Element ;Text    ;
                                                  VariableName=CustoemerPartyName;
                                                  NamespacePrefix=cac }

    { [{7F5EF9BA-AE48-408F-ADB9-7BB323BA6B11}];4 ;Name                ;Element ;Text    ;
                                                  VariableName=CustomerName;
                                                  NamespacePrefix=cbc }

    { [{85DB5C29-6171-4D68-899C-A7E86FCA08EF}];3 ;PostalAddress       ;Element ;Text    ;
                                                  VariableName=CustomerPostalAddress;
                                                  NamespacePrefix=cac }

    { [{1607BDCF-AA24-433F-8AF0-39743B6DC8C2}];4 ;StreetName          ;Element ;Text    ;
                                                  VariableName=CustomerStreetName;
                                                  NamespacePrefix=cbc }

    { [{C9EC312E-FBD4-4949-9DA7-8914CAB6E8C2}];4 ;AdditionalStreetName;Element ;Text    ;
                                                  VariableName=CustomerAdditionalStreetName;
                                                  NamespacePrefix=cbc }

    { [{0498651A-0990-476C-980D-B1DA0CA1A64D}];4 ;CityName            ;Element ;Text    ;
                                                  VariableName=CustomerCityName;
                                                  NamespacePrefix=cbc }

    { [{994BBFC2-139E-4F9D-B9F7-6D376CE67B47}];4 ;PostalZone          ;Element ;Text    ;
                                                  VariableName=CustomerPostalZone;
                                                  NamespacePrefix=cbc }

    { [{D1AE50E6-C04F-4F16-8DED-63D66F272DC6}];4 ;CountrySubentity    ;Element ;Text    ;
                                                  VariableName=CustomerCountrySubentity;
                                                  NamespacePrefix=cbc;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 IF CustomerCountrySubentity = '' THEN
                                                                                   currXMLport.SKIP;
                                                                               END;
                                                                                }

    { [{3A21FEAD-186D-4664-B3CB-81C54DB2A315}];4 ;Country             ;Element ;Text    ;
                                                  VariableName=CustomerCountry;
                                                  NamespacePrefix=cac }

    { [{592406BB-A796-4ACF-BF0E-C56079848A77}];5 ;IdentificationCode  ;Element ;Text    ;
                                                  VariableName=CustomerIdentificationCode;
                                                  NamespacePrefix=cbc }

    { [{E2958020-C212-48D5-9C3E-7672EDFE5680}];6 ;listID              ;Attribute;Text   ;
                                                  VariableName=CustomerListID }

    { [{00EE7729-D188-4951-94FD-304968003C1D}];3 ;PartyTaxScheme      ;Element ;Text    ;
                                                  VariableName=CustomerPartyTaxScheme;
                                                  NamespacePrefix=cac;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 IF CustTaxSchemeID = '' THEN
                                                                                   currXMLport.SKIP;
                                                                               END;
                                                                                }

    { [{F99242FC-928F-4F4D-9095-F762B6B3DD4D}];4 ;CompanyID           ;Element ;Text    ;
                                                  VariableName=CustPartyTaxSchemeCompanyID;
                                                  NamespacePrefix=cbc;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 IF CustPartyTaxSchemeCompanyID = '' THEN
                                                                                   currXMLport.SKIP;
                                                                               END;
                                                                                }

    { [{2C2F7401-FDE0-4C04-8E4C-3774C0E62100}];5 ;schemeID            ;Attribute;Text   ;
                                                  VariableName=CustPartyTaxSchemeCompIDSchID }

    { [{2FCFA19A-37A1-44E3-A3DE-72E9C4ED1567}];4 ;TaxScheme           ;Element ;Text    ;
                                                  VariableName=CustTaxScheme;
                                                  NamespacePrefix=cac }

    { [{F1C788E1-802F-4104-8D15-57606A16E3E8}];5 ;ID                  ;Element ;Text    ;
                                                  VariableName=CustTaxSchemeID;
                                                  NamespacePrefix=cbc }

    { [{EA421A36-C438-405C-B4EF-5CBA2ED46E72}];3 ;PartyLegalEntity    ;Element ;Text    ;
                                                  VariableName=CustPartyLegalEntity;
                                                  NamespacePrefix=cac }

    { [{1A2E2092-AEA9-4645-AB4B-24F91014BD1F}];4 ;RegistrationName    ;Element ;Text    ;
                                                  VariableName=CustPartyLegalEntityRegName;
                                                  NamespacePrefix=cbc;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 IF CustPartyLegalEntityRegName = '' THEN
                                                                                   currXMLport.SKIP;
                                                                               END;
                                                                                }

    { [{211DEDC2-E3DC-48E7-9468-DF59DC57F157}];4 ;CompanyID           ;Element ;Text    ;
                                                  VariableName=CustPartyLegalEntityCompanyID;
                                                  NamespacePrefix=cbc;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 IF CustPartyLegalEntityCompanyID = '' THEN
                                                                                   currXMLport.SKIP;
                                                                               END;
                                                                                }

    { [{F203898C-9951-43D7-B069-3228B86A4110}];5 ;schemeID            ;Attribute;Text   ;
                                                  VariableName=CustPartyLegalEntityIDSchemeID }

    { [{B01C6B3D-7BD2-4DBA-8A12-837D42C87797}];3 ;Contact             ;Element ;Text    ;
                                                  VariableName=CustContact;
                                                  NamespacePrefix=cac }

    { [{EE9327F5-7649-4612-B1B7-BD72D98ACFA6}];4 ;ID                  ;Element ;Text    ;
                                                  VariableName=CustContactID;
                                                  NamespacePrefix=cbc }

    { [{71860AA3-8754-478B-8FAA-D7481CF0DE65}];4 ;Name                ;Element ;Text    ;
                                                  VariableName=CustContactName;
                                                  NamespacePrefix=cbc }

    { [{C2422717-6F6D-49DF-B4D1-7F2367FE2BFC}];4 ;Telephone           ;Element ;Text    ;
                                                  VariableName=CustContactTelephone;
                                                  NamespacePrefix=cbc }

    { [{E4897FCA-72A1-40BB-A870-0B7787530D1D}];4 ;Telefax             ;Element ;Text    ;
                                                  VariableName=CustContactTelefax;
                                                  NamespacePrefix=cbc }

    { [{174EBF6A-AE07-4E9D-B64D-A684F9023A96}];4 ;ElectronicMail      ;Element ;Text    ;
                                                  VariableName=CustContactElectronicMail;
                                                  NamespacePrefix=cbc }

    { [{FD8EDAEF-4839-418E-B22E-0526F4644FED}];1 ;PayeeParty          ;Element ;Text    ;
                                                  NamespacePrefix=cac;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 PEPPOLMgt.GetPayeePartyInfo(
                                                                                   PayeePartyID,
                                                                                   PayeePartyIDSchemeID,
                                                                                   PayeePartyNameName,
                                                                                   PayeePartyLegalEntityCompanyID,
                                                                                   PayeePartyLegalCompIDSchemeID)
                                                                               END;
                                                                                }

    { [{0D894A62-851E-402D-AA4B-C06CA1593275}];2 ;PartyIdentification ;Element ;Text    ;
                                                  VariableName=PayeePartyIdentification;
                                                  NamespacePrefix=cac;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 IF PayeePartyID = '' THEN
                                                                                   currXMLport.SKIP;
                                                                               END;
                                                                                }

    { [{F5679882-8719-4121-9591-161BAF2ACBDC}];3 ;ID                  ;Element ;Text    ;
                                                  VariableName=PayeePartyID;
                                                  NamespacePrefix=cbc }

    { [{9CFE1D3A-286C-4070-A7B3-C389FB6AF7DC}];4 ;schemeID            ;Attribute;Text   ;
                                                  VariableName=PayeePartyIDSchemeID }

    { [{AC0491AC-04F0-4D05-99A1-3BC2C531FE4B}];2 ;PartyName           ;Element ;Text    ;
                                                  VariableName=PayeePartyName;
                                                  NamespacePrefix=cac;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 IF PayeePartyNameName = '' THEN
                                                                                   currXMLport.SKIP;
                                                                               END;
                                                                                }

    { [{E70F2186-D060-4D1E-A1CA-021AE72E0903}];3 ;Name                ;Element ;Text    ;
                                                  VariableName=PayeePartyNameName;
                                                  NamespacePrefix=cbc }

    { [{CE7C8B43-8248-46BA-8758-C06E728402FA}];2 ;PartyLegalEntity    ;Element ;Text    ;
                                                  VariableName=PayeePartyLegalEntity;
                                                  NamespacePrefix=cac;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 IF PayeePartyLegalEntityCompanyID = '' THEN
                                                                                   currXMLport.SKIP;
                                                                               END;
                                                                                }

    { [{86FA9A2F-A907-4E54-BBEF-6719CF1F859E}];3 ;CompanyID           ;Element ;Text    ;
                                                  VariableName=PayeePartyLegalEntityCompanyID;
                                                  NamespacePrefix=cbc }

    { [{441B19D6-D7EB-4D55-9FEF-D432E1508FCC}];4 ;schemeID            ;Attribute;Text   ;
                                                  VariableName=PayeePartyLegalCompIDSchemeID }

    { [{CD29B6EA-EE9A-45C4-A4FE-339157229F08}];1 ;TaxRepresentativeParty;Element;Text   ;
                                                  NamespacePrefix=cac;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 PEPPOLMgt.GetTaxRepresentativePartyInfo(
                                                                                   TaxRepPartyNameName,
                                                                                   PayeePartyTaxSchemeCompanyID,
                                                                                   PayeePartyTaxSchCompIDSchemeID,
                                                                                   PayeePartyTaxSchemeTaxSchemeID);

                                                                                 IF TaxRepPartyPartyName = '' THEN
                                                                                   currXMLport.SKIP;
                                                                               END;
                                                                                }

    { [{7740051F-C876-47C0-8C74-B134D949D1AB}];2 ;PartyName           ;Element ;Text    ;
                                                  VariableName=TaxRepPartyPartyName;
                                                  NamespacePrefix=cac }

    { [{1E425787-4294-4C3C-8F98-28580E562D3B}];3 ;Name                ;Element ;Text    ;
                                                  VariableName=TaxRepPartyNameName;
                                                  NamespacePrefix=cbc }

    { [{9E6B1A26-3250-4D1F-88A9-47514C805A7E}];2 ;PartyTaxScheme      ;Element ;Text    ;
                                                  VariableName=PayeePartyTaxScheme;
                                                  NamespacePrefix=cac;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 IF PayeePartyTaxScheme = '' THEN
                                                                                   currXMLport.SKIP;
                                                                               END;
                                                                                }

    { [{722105F8-68C6-4974-97D7-B3DD79B9465D}];3 ;CompanyID           ;Element ;Text    ;
                                                  VariableName=PayeePartyTaxSchemeCompanyID;
                                                  NamespacePrefix=cbc }

    { [{543E334A-F931-4D4B-8319-0C3A9EF1C500}];4 ;schemeID            ;Attribute;Text   ;
                                                  VariableName=PayeePartyTaxSchCompIDSchemeID }

    { [{6525CBA2-0C4E-4FF7-B6EA-05AE82C8BEBC}];3 ;TaxScheme           ;Element ;Text    ;
                                                  VariableName=PayeePartyTaxSchemeTaxScheme;
                                                  NamespacePrefix=cac }

    { [{5A186B0D-8E26-42C7-952E-ECE274E04894}];4 ;ID                  ;Element ;Text    ;
                                                  VariableName=PayeePartyTaxSchemeTaxSchemeID;
                                                  NamespacePrefix=cbc }

    { [{B1388E21-3A56-4EA1-8E6C-ACF61935994B}];1 ;Delivery            ;Element ;Text    ;
                                                  NamespacePrefix=cac;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 PEPPOLMgt.GetGLNDeliveryInfo(
                                                                                   SalesHeader,
                                                                                   ActualDeliveryDate,
                                                                                   DeliveryID,
                                                                                   DeliveryIDSchemeID);

                                                                                 PEPPOLMgt.GetDeliveryAddress(
                                                                                   SalesHeader,
                                                                                   DeliveryStreetName,
                                                                                   DeliveryAdditionalStreetName,
                                                                                   DeliveryCityName,
                                                                                   DeliveryPostalZone,
                                                                                   DeliveryCountrySubentity,
                                                                                   DeliveryCountryIdCode,
                                                                                   DeliveryCountryListID);
                                                                               END;
                                                                                }

    { [{BD5A8268-9883-48D8-8E3D-FF653F26465C}];2 ;ActualDeliveryDate  ;Element ;Text    ;
                                                  NamespacePrefix=cbc;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 IF ActualDeliveryDate = '' THEN
                                                                                   currXMLport.SKIP;
                                                                               END;
                                                                                }

    { [{1040929C-31E3-4C81-9119-0CB69950CBC4}];2 ;DeliveryLocation    ;Element ;Text    ;
                                                  NamespacePrefix=cac }

    { [{E6CD7111-10C2-4F90-B36D-EF1AA2CD622F}];3 ;ID                  ;Element ;Text    ;
                                                  VariableName=DeliveryID;
                                                  NamespacePrefix=cbc;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 IF DeliveryID = '' THEN
                                                                                   currXMLport.SKIP;
                                                                               END;
                                                                                }

    { [{D0F9419E-3A0C-41CD-B6D1-9BA2299A87DC}];4 ;schemeID            ;Attribute;Text   ;
                                                  VariableName=DeliveryIDSchemeID }

    { [{9EC0467C-F677-4A60-A0C6-9D05CCA5C3FD}];3 ;Address             ;Element ;Text    ;
                                                  VariableName=DeliveryAddress;
                                                  NamespacePrefix=cac }

    { [{B2F73A73-13E0-4B32-BB8D-85C8683554C5}];4 ;StreetName          ;Element ;Text    ;
                                                  VariableName=DeliveryStreetName;
                                                  NamespacePrefix=cbc }

    { [{9857A2B1-E307-41EF-AC1F-CC4FEE3F2B57}];4 ;AdditionalStreetName;Element ;Text    ;
                                                  VariableName=DeliveryAdditionalStreetName;
                                                  NamespacePrefix=cbc }

    { [{B3341B96-6568-4B1D-BC8E-85BAB90429A4}];4 ;CityName            ;Element ;Text    ;
                                                  VariableName=DeliveryCityName;
                                                  NamespacePrefix=cbc }

    { [{573CC63D-7C12-4344-BC84-5A0082FDFBB7}];4 ;PostalZone          ;Element ;Text    ;
                                                  VariableName=DeliveryPostalZone;
                                                  NamespacePrefix=cbc }

    { [{F6C08C58-50CB-4873-A577-5E9EB283D55C}];4 ;CountrySubentity    ;Element ;Text    ;
                                                  VariableName=DeliveryCountrySubentity;
                                                  NamespacePrefix=cbc }

    { [{B6A1CA89-27DA-4FFE-B1AA-F663E7495ED2}];4 ;Country             ;Element ;Text    ;
                                                  VariableName=DeliveryCountry;
                                                  NamespacePrefix=cac }

    { [{B0D1B308-21F2-4D55-A436-44B902038CE7}];5 ;IdentificationCode  ;Element ;Text    ;
                                                  VariableName=DeliveryCountryIdCode;
                                                  NamespacePrefix=cbc }

    { [{5E07FF10-243F-4BCC-80D8-C0249C9E682F}];6 ;listID              ;Attribute;Text   ;
                                                  VariableName=DeliveryCountryListID }

    { [{64F52FD5-6B84-4CE2-82AB-AB5686A59F49}];1 ;PaymentMeans        ;Element ;Text    ;
                                                  NamespacePrefix=cac;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 PEPPOLMgt.GetPaymentMeansInfo(
                                                                                   SalesHeader,
                                                                                   PaymentMeansCode,
                                                                                   PaymentMeansListID,
                                                                                   PaymentDueDate,
                                                                                   PaymentChannelCode,
                                                                                   PaymentID,
                                                                                   PrimaryAccountNumberID,
                                                                                   NetworkID);

                                                                                 PEPPOLMgt.GetPaymentMeansPayeeFinancialAcc(
                                                                                   PayeeFinancialAccountID,
                                                                                   PaymentMeansSchemeID,
                                                                                   FinancialInstitutionBranchID,
                                                                                   FinancialInstitutionID,
                                                                                   FinancialInstitutionSchemeID,
                                                                                   FinancialInstitutionName);

                                                                                 PEPPOLMgt.GetPaymentMeansFinancialInstitutionAddr(
                                                                                   FinancialInstitutionStreetName,
                                                                                   AdditionalStreetName,
                                                                                   FinancialInstitutionCityName,
                                                                                   FinancialInstitutionPostalZone,
                                                                                   FinancialInstCountrySubentity,
                                                                                   FinancialInstCountryIdCode,
                                                                                   FinancialInstCountryListID);
                                                                               END;
                                                                                }

    { [{29E815C2-6699-4FAB-B9E2-8084CA802EF6}];2 ;PaymentMeansCode    ;Element ;Text    ;
                                                  NamespacePrefix=cbc }

    { [{567E7D3D-090F-4ABB-A940-5B88F9D8AA32}];3 ;listID              ;Attribute;Text   ;
                                                  VariableName=PaymentMeansListID }

    { [{75C89448-1A40-4E98-B26F-441078335C33}];2 ;PaymentDueDate      ;Element ;Text    ;
                                                  NamespacePrefix=cbc }

    { [{02A8E2F1-BBCE-455A-A5BE-CDE12C719D54}];2 ;PaymentChannelCode  ;Element ;Text    ;
                                                  NamespacePrefix=cbc }

    { [{1A80C21F-C89C-474A-8486-9F231B08A333}];2 ;PaymentID           ;Element ;Text    ;
                                                  NamespacePrefix=cbc }

    { [{F21767E9-BFF8-41E4-B7FA-30FF9B010380}];2 ;CardAccount         ;Element ;Text    ;
                                                  NamespacePrefix=cac;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 IF PrimaryAccountNumberID = '' THEN
                                                                                   currXMLport.SKIP;
                                                                               END;
                                                                                }

    { [{3D3A08FD-61ED-451A-8011-DF698E8845F9}];3 ;PrimaryAccountNumberID;Element;Text   ;
                                                  NamespacePrefix=cbc }

    { [{98E7732A-C0A1-4123-9F80-2277D1FA725B}];3 ;NetworkID           ;Element ;Text    ;
                                                  NamespacePrefix=cbc }

    { [{51941FD6-0C4B-46F5-80CC-51D3615DC244}];2 ;PayeeFinancialAccount;Element;Text    ;
                                                  NamespacePrefix=cac }

    { [{24F87733-415D-4FE7-9700-1B1C7FF93835}];3 ;ID                  ;Element ;Text    ;
                                                  VariableName=PayeeFinancialAccountID;
                                                  NamespacePrefix=cbc }

    { [{BE2146B5-4298-4C6E-AF15-780698011C51}];4 ;schemeID            ;Attribute;Text   ;
                                                  VariableName=PaymentMeansSchemeID }

    { [{E4EEE5F6-8589-46E7-A062-B0C35BA4F118}];3 ;FinancialInstitutionBranch;Element;Text;
                                                  NamespacePrefix=cac }

    { [{07F16E1B-8D50-4729-BBD3-5C19CD23B12B}];4 ;ID                  ;Element ;Text    ;
                                                  VariableName=FinancialInstitutionBranchID;
                                                  NamespacePrefix=cbc }

    { [{E880ABAC-47CF-494E-AD0B-28B92C5A8B0D}];4 ;FinancialInstitution;Element ;Text    ;
                                                  NamespacePrefix=cac }

    { [{3243C11B-1256-4D55-9B11-74F8404BB043}];5 ;ID                  ;Element ;Text    ;
                                                  VariableName=FinancialInstitutionID;
                                                  NamespacePrefix=cbc }

    { [{4C3982CB-1052-4201-8266-060A12A882B3}];6 ;schemeID            ;Attribute;Text   ;
                                                  VariableName=FinancialInstitutionSchemeID }

    { [{6664D5B2-6078-432C-A3C5-9485B6C583B7}];5 ;Name                ;Element ;Text    ;
                                                  VariableName=FinancialInstitutionName;
                                                  NamespacePrefix=cbc }

    { [{5A32AAE6-8873-42CF-8557-B87145EE0344}];5 ;Address             ;Element ;Text    ;
                                                  NamespacePrefix=cac;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 IF FinancialInstCountryIdCode = '' THEN
                                                                                   currXMLport.SKIP;
                                                                               END;
                                                                                }

    { [{FA1D33F3-410B-47A2-8C40-7C556753297E}];6 ;StreetName          ;Element ;Text    ;
                                                  VariableName=FinancialInstitutionStreetName;
                                                  NamespacePrefix=cbc }

    { [{8ED4FF64-4069-437A-86C9-6A6BDE99D117}];6 ;AdditionalStreetName;Element ;Text    ;
                                                  NamespacePrefix=cbc }

    { [{C52DD2C3-D536-43B6-8C0C-E5ED5DEA0668}];6 ;CityName            ;Element ;Text    ;
                                                  VariableName=FinancialInstitutionCityName;
                                                  NamespacePrefix=cbc }

    { [{586219E7-1781-4D17-AA57-E58FA47B2A6A}];6 ;PostalZone          ;Element ;Text    ;
                                                  VariableName=FinancialInstitutionPostalZone;
                                                  NamespacePrefix=cbc }

    { [{19F66A9C-F624-4A8E-9302-2CB0B0FDD8DE}];6 ;CountrySubentity    ;Element ;Text    ;
                                                  VariableName=FinancialInstCountrySubentity;
                                                  NamespacePrefix=cbc }

    { [{6E52602C-36E3-493F-8C59-D2F5E87F6806}];6 ;Country             ;Element ;Text    ;
                                                  VariableName=FinancialInstitutionCountry;
                                                  NamespacePrefix=cac }

    { [{413B9C4B-B995-4CF4-9192-7635EF2D899B}];7 ;IdentificationCode  ;Element ;Text    ;
                                                  VariableName=FinancialInstCountryIdCode;
                                                  NamespacePrefix=cbc }

    { [{B2215343-FB26-45F7-AB94-D009F7047C6C}];8 ;listID              ;Attribute;Text   ;
                                                  VariableName=FinancialInstCountryListID }

    { [{169F5A1C-7D75-41D6-A487-B8AB19AC25FE}];1 ;PaymentTerms        ;Element ;Table   ;
                                                  VariableName=PmtTermsLoop;
                                                  SourceTable=Table2000000026;
                                                  SourceTableView=SORTING(Field1)
                                                                  WHERE(Field1=FILTER(1..));
                                                  NamespacePrefix=cac;
                                                  Export::OnPreXMLItem=BEGIN
                                                                         PmtTermsLoop.SETRANGE(Number,1,1);
                                                                       END;

                                                  Export::OnAfterGetRecord=BEGIN
                                                                             PEPPOLMgt.GetPaymentTermsInfo(
                                                                               SalesHeader,
                                                                               PaymentTermsNote);
                                                                           END;
                                                                            }

    { [{8C015736-B351-4450-8B3C-B402A037CC03}];2 ;Note                ;Element ;Text    ;
                                                  VariableName=PaymentTermsNote;
                                                  NamespacePrefix=cbc }

    { [{5A92E704-6F37-41EC-9BB8-C97F233263FC}];1 ;AllowanceCharge     ;Element ;Table   ;
                                                  VariableName=AllowanceChargeLoop;
                                                  SourceTable=Table2000000026;
                                                  SourceTableView=SORTING(Field1)
                                                                  WHERE(Field1=FILTER(1..));
                                                  NamespacePrefix=cac;
                                                  Export::OnAfterGetRecord=BEGIN
                                                                             IF NOT FindNextVATAmtRec(TempVATAmtLine,AllowanceChargeLoop.Number) THEN
                                                                               currXMLport.BREAK;

                                                                             PEPPOLMgt.GetAllowanceChargeInfo(
                                                                               TempVATAmtLine,
                                                                               SalesHeader,
                                                                               ChargeIndicator,
                                                                               AllowanceChargeReasonCode,
                                                                               AllowanceChargeListID,
                                                                               AllowanceChargeReason,
                                                                               Amount,
                                                                               AllowanceChargeCurrencyID,
                                                                               TaxCategoryID,
                                                                               TaxCategorySchemeID,
                                                                               Percent,
                                                                               AllowanceChargeTaxSchemeID);

                                                                             IF ChargeIndicator = '' THEN
                                                                               currXMLport.SKIP;
                                                                           END;
                                                                            }

    { [{F8D7B0C6-45BE-43D4-B7EC-59289CD8B89C}];2 ;ChargeIndicator     ;Element ;Text    ;
                                                  NamespacePrefix=cbc }

    { [{D524FBF6-CD3B-45C0-BDCE-3CF204D25C9E}];2 ;AllowanceChargeReasonCode;Element;Text;
                                                  NamespacePrefix=cbc }

    { [{681AF432-0FAE-4EF7-880F-C4D02B056052}];3 ;listID              ;Attribute;Text   ;
                                                  VariableName=AllowanceChargeListID }

    { [{F5FB4080-CE66-43F7-BB43-C250E7BE0703}];2 ;AllowanceChargeReason;Element;Text    ;
                                                  NamespacePrefix=cbc }

    { [{129763CC-48AB-4EEE-8847-905E73A490F1}];2 ;Amount              ;Element ;Text    ;
                                                  NamespacePrefix=cbc }

    { [{F671FAFF-FBB8-40DE-BA71-35FFF8FA800C}];3 ;currencyID          ;Attribute;Text   ;
                                                  VariableName=AllowanceChargeCurrencyID }

    { [{6EA18A4D-1EC7-4B85-9159-53AEE9A2B8DF}];2 ;TaxCategory         ;Element ;Text    ;
                                                  NamespacePrefix=cac }

    { [{8151641A-9D99-46C4-BA54-59A25E9A715E}];3 ;ID                  ;Element ;Text    ;
                                                  VariableName=TaxCategoryID;
                                                  NamespacePrefix=cbc }

    { [{343F27AC-0B2A-472A-AD3F-E734E732F2F3}];4 ;schemeID            ;Attribute;Text   ;
                                                  VariableName=TaxCategorySchemeID }

    { [{919EF25C-40A0-4ECE-BE02-23FC0FD7B146}];3 ;Percent             ;Element ;Text    ;
                                                  NamespacePrefix=cbc }

    { [{718C1EDF-107B-4F47-83AF-8E054FFF45FC}];3 ;TaxScheme           ;Element ;Text    ;
                                                  NamespacePrefix=cac }

    { [{393B3495-3003-4BBF-A1A4-4F86FC327FB3}];4 ;ID                  ;Element ;Text    ;
                                                  VariableName=AllowanceChargeTaxSchemeID;
                                                  NamespacePrefix=cbc }

    { [{F8FCB031-9272-4DA0-83AC-F569F1747A38}];1 ;TaxExchangeRate     ;Element ;Text    ;
                                                  NamespacePrefix=cac;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 PEPPOLMgt.GetTaxExchangeRateInfo(
                                                                                   SalesHeader,
                                                                                   SourceCurrencyCode,
                                                                                   SourceCurrencyCodeListID,
                                                                                   TargetCurrencyCode,
                                                                                   TargetCurrencyCodeListID,
                                                                                   CalculationRate,
                                                                                   MathematicOperatorCode,
                                                                                   Date);

                                                                                 IF (SourceCurrencyCode = '') AND (TargetCurrencyCode = '') THEN
                                                                                   currXMLport.SKIP;
                                                                               END;
                                                                                }

    { [{1643DD66-9AD5-4425-B188-9F6065D4CC9A}];2 ;SourceCurrencyCode  ;Element ;Text    ;
                                                  NamespacePrefix=cbc }

    { [{7CC9F4A0-6FBF-4673-8868-7B54FE27D691}];3 ;listID              ;Attribute;Text   ;
                                                  VariableName=SourceCurrencyCodeListID }

    { [{083856AB-65CC-49B8-8934-455EE9417F63}];2 ;TargetCurrencyCode  ;Element ;Text    ;
                                                  NamespacePrefix=cbc }

    { [{4DC3763D-EDA5-4267-941A-1783D99121E6}];3 ;listID              ;Attribute;Text   ;
                                                  VariableName=TargetCurrencyCodeListID }

    { [{6F001829-4DED-41FA-9467-110C5C958DAD}];2 ;CalculationRate     ;Element ;Text    ;
                                                  NamespacePrefix=cbc }

    { [{98FC3807-B55C-4AC4-B139-C2CA520541FA}];2 ;MathematicOperatorCode;Element;Text   ;
                                                  NamespacePrefix=cbc }

    { [{806BCFA7-EF66-4836-AA3B-AF274A96F893}];2 ;Date                ;Element ;Text    ;
                                                  NamespacePrefix=cbc }

    { [{3E76891C-4186-4F6A-BB58-7E104A56C9C3}];1 ;TaxTotal            ;Element ;Text    ;
                                                  NamespacePrefix=cac;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 PEPPOLMgt.GetTaxTotalInfo(
                                                                                   SalesHeader,
                                                                                   TempVATAmtLine,
                                                                                   TaxAmount,
                                                                                   TaxTotalCurrencyID);
                                                                               END;
                                                                                }

    { [{5108EAC1-9331-4A66-B6B8-4114BE1F5FA3}];2 ;TaxAmount           ;Element ;Text    ;
                                                  NamespacePrefix=cbc }

    { [{CD91DEA8-1B6F-4085-A441-9854D979EBCC}];3 ;currencyID          ;Attribute;Text   ;
                                                  VariableName=TaxTotalCurrencyID }

    { [{AB32689B-E5E7-49F8-BE1E-EBEE6636CCE4}];2 ;TaxSubtotal         ;Element ;Table   ;
                                                  VariableName=TaxSubtotalLoop;
                                                  SourceTable=Table2000000026;
                                                  SourceTableView=SORTING(Field1)
                                                                  WHERE(Field1=FILTER(1..));
                                                  NamespacePrefix=cac;
                                                  Export::OnAfterGetRecord=BEGIN
                                                                             IF NOT FindNextVATAmtRec(TempVATAmtLine,TaxSubtotalLoop.Number) THEN
                                                                               currXMLport.BREAK;

                                                                             PEPPOLMgt.GetTaxSubtotalInfo(
                                                                               TempVATAmtLine,
                                                                               SalesHeader,
                                                                               TaxableAmount,
                                                                               TaxAmountCurrencyID,
                                                                               SubtotalTaxAmount,
                                                                               TaxSubtotalCurrencyID,
                                                                               TransactionCurrencyTaxAmount,
                                                                               TransCurrTaxAmtCurrencyID,
                                                                               TaxTotalTaxCategoryID,
                                                                               schemeID,
                                                                               TaxCategoryPercent,
                                                                               TaxTotalTaxSchemeID);
                                                                           END;
                                                                            }

    { [{3B765018-838A-4471-A85A-2E4982E0E60F}];3 ;TaxableAmount       ;Element ;Text    ;
                                                  NamespacePrefix=cbc }

    { [{01E7014C-121A-4B86-84D1-B8B42380A30E}];4 ;currencyID          ;Attribute;Text   ;
                                                  VariableName=TaxSubtotalCurrencyID }

    { [{AEBF8269-04BF-4B48-B216-FBB73D887EF9}];3 ;TaxAmount           ;Element ;Text    ;
                                                  VariableName=SubtotalTaxAmount;
                                                  NamespacePrefix=cbc }

    { [{A30EA443-5FBA-4ED9-B764-2675A842210F}];4 ;currencyID          ;Attribute;Text   ;
                                                  VariableName=TaxAmountCurrencyID }

    { [{6E9AA8CC-BFD3-4EC6-9502-875CBA544EDF}];3 ;TransactionCurrencyTaxAmount;Element;Text;
                                                  NamespacePrefix=cbc;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 IF TransactionCurrencyTaxAmount = '' THEN
                                                                                   currXMLport.SKIP;
                                                                               END;
                                                                                }

    { [{58849FA5-FD90-4387-B847-079936CA258C}];4 ;currencyID          ;Attribute;Text   ;
                                                  VariableName=TransCurrTaxAmtCurrencyID }

    { [{9F5D8E7E-D9C6-44AF-8DF9-6700E6646953}];3 ;TaxCategory         ;Element ;Text    ;
                                                  VariableName=SubTotalTaxCategory;
                                                  NamespacePrefix=cac }

    { [{CA773FEA-B7BF-4E29-9B42-E3E54D8A2CBC}];4 ;ID                  ;Element ;Text    ;
                                                  VariableName=TaxTotalTaxCategoryID;
                                                  NamespacePrefix=cbc }

    { [{9C3C1A5C-88F7-460A-B6F8-891CBC95E69D}];5 ;schemeID            ;Attribute;Text    }

    { [{73F648A4-70AC-466C-8A5A-05660033FA25}];4 ;Percent             ;Element ;Text    ;
                                                  VariableName=TaxCategoryPercent;
                                                  NamespacePrefix=cbc }

    { [{1FD61CC9-1191-4ED0-9DD1-847D0734BC27}];4 ;TaxExemptionReason  ;Element ;Text    ;
                                                  NamespacePrefix=cbc }

    { [{E35C87A6-AB29-40D1-8D52-D612ABEC0ECD}];4 ;TaxScheme           ;Element ;Text    ;
                                                  VariableName=TaxSubTotalTaxScheme;
                                                  NamespacePrefix=cac }

    { [{D30661A3-802C-4330-A48F-F1812F8B845C}];5 ;ID                  ;Element ;Text    ;
                                                  VariableName=TaxTotalTaxSchemeID;
                                                  NamespacePrefix=cbc }

    { [{3C2286DC-90D3-40DB-90A0-1EDA50096BDF}];1 ;LegalMonetaryTotal  ;Element ;Text    ;
                                                  NamespacePrefix=cac;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 PEPPOLMgt.GetLegalMonetaryInfo(
                                                                                   SalesHeader,
                                                                                   TempVATAmtLine,
                                                                                   LineExtensionAmount,
                                                                                   LegalMonetaryTotalCurrencyID,
                                                                                   TaxExclusiveAmount,
                                                                                   TaxExclusiveAmountCurrencyID,
                                                                                   TaxInclusiveAmount,
                                                                                   TaxInclusiveAmountCurrencyID,
                                                                                   AllowanceTotalAmount,
                                                                                   AllowanceTotalAmountCurrencyID,
                                                                                   ChargeTotalAmount,
                                                                                   ChargeTotalAmountCurrencyID,
                                                                                   PrepaidAmount,
                                                                                   PrepaidCurrencyID,
                                                                                   PayableRoundingAmount,
                                                                                   PayableRndingAmountCurrencyID,
                                                                                   PayableAmount,
                                                                                   PayableAmountCurrencyID);
                                                                               END;
                                                                                }

    { [{F87A4A36-9703-48DD-8D9F-CDF52CCDC553}];2 ;LineExtensionAmount ;Element ;Text    ;
                                                  NamespacePrefix=cbc }

    { [{AEA77EFE-3FD7-428E-9354-EFF7C55C398A}];3 ;currencyID          ;Attribute;Text   ;
                                                  VariableName=LegalMonetaryTotalCurrencyID }

    { [{85030BB0-7D31-4944-84BC-0F45A82AC90D}];2 ;TaxExclusiveAmount  ;Element ;Text    ;
                                                  NamespacePrefix=cbc }

    { [{B446CFC9-3217-4611-BDE0-D67BB86B9006}];3 ;currencyID          ;Attribute;Text   ;
                                                  VariableName=TaxExclusiveAmountCurrencyID }

    { [{ABEA8339-8DCE-49EF-9070-0A086BF65AEC}];2 ;TaxInclusiveAmount  ;Element ;Text    ;
                                                  NamespacePrefix=cbc }

    { [{F6FEF742-C28F-4C46-B34D-78D017D7BD1E}];3 ;currencyID          ;Attribute;Text   ;
                                                  VariableName=TaxInclusiveAmountCurrencyID }

    { [{6C01B4C4-8840-4DFF-889A-B81C70E38B18}];2 ;AllowanceTotalAmount;Element ;Text    ;
                                                  NamespacePrefix=cbc;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 IF AllowanceTotalAmount = '' THEN
                                                                                   currXMLport.SKIP;
                                                                               END;
                                                                                }

    { [{E7741AFC-CAD8-46A3-AE2B-F106B2140787}];3 ;currencyID          ;Attribute;Text   ;
                                                  VariableName=AllowanceTotalAmountCurrencyID }

    { [{FE4CC48E-6072-417C-937C-E652E2EF060A}];2 ;ChargeTotalAmount   ;Element ;Text    ;
                                                  NamespacePrefix=cbc;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 IF ChargeTotalAmount = '' THEN
                                                                                   currXMLport.SKIP;
                                                                               END;
                                                                                }

    { [{9333C705-E79E-4268-9650-F80DF7E6FBEB}];3 ;currencyID          ;Attribute;Text   ;
                                                  VariableName=ChargeTotalAmountCurrencyID }

    { [{AA3FAE5A-FBAC-42A9-8459-29221ABF0C2A}];2 ;PrepaidAmount       ;Element ;Text    ;
                                                  NamespacePrefix=cbc }

    { [{BE1475A3-C988-45B7-8A45-7D535CA645D9}];3 ;currencyID          ;Attribute;Text   ;
                                                  VariableName=PrepaidCurrencyID }

    { [{35E18111-EC51-4429-8267-408B271BBC6B}];2 ;PayableRoundingAmount;Element;Text    ;
                                                  NamespacePrefix=cbc;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 IF PayableRoundingAmount = '' THEN
                                                                                   currXMLport.SKIP;
                                                                               END;
                                                                                }

    { [{8889DF71-47F1-4322-ADCF-3C9D97B6CEB3}];3 ;currencyID          ;Attribute;Text   ;
                                                  VariableName=PayableRndingAmountCurrencyID }

    { [{642438D9-FF5D-4C73-B82B-CFF42DB2F271}];2 ;PayableAmount       ;Element ;Text    ;
                                                  NamespacePrefix=cbc }

    { [{BE260480-E15D-4DD5-8D9F-16395B4F1593}];3 ;currencyID          ;Attribute;Text   ;
                                                  VariableName=PayableAmountCurrencyID }

    { [{9989D34D-B9BF-4AE5-B733-F1D5F0DFD2BC}];1 ;CreditNoteLine      ;Element ;Table   ;
                                                  VariableName=CreditMemoLineLoop;
                                                  SourceTable=Table2000000026;
                                                  SourceTableView=SORTING(Field1)
                                                                  WHERE(Field1=FILTER(1..));
                                                  NamespacePrefix=cac;
                                                  Export::OnAfterGetRecord=BEGIN
                                                                             IF NOT FindNextCreditMemoLineRec(CreditMemoLineLoop.Number) THEN
                                                                               currXMLport.BREAK;

                                                                             PEPPOLMgt.GetLineGeneralInfo(
                                                                               SalesLine,
                                                                               SalesHeader,
                                                                               SalesCrMemoLineID,
                                                                               SalesCrMemoLineNote,
                                                                               CreditedQuantity,
                                                                               SalesCrMemoLineExtensionAmount,
                                                                               LineExtensionAmountCurrencyID,
                                                                               SalesCrMemoLineAccountingCost);
                                                                             PEPPOLMgt.GetLineUnitCodeInfo(SalesLine,unitCode,unitCodeListID);
                                                                           END;
                                                                            }

    { [{B4A6AF9E-265B-40EB-81F7-BB2BBB1BB8DC}];2 ;ID                  ;Element ;Text    ;
                                                  VariableName=SalesCrMemoLineID;
                                                  NamespacePrefix=cbc }

    { [{7552997B-8516-414B-B004-CB1864A11E5B}];2 ;Note                ;Element ;Text    ;
                                                  VariableName=SalesCrMemoLineNote;
                                                  NamespacePrefix=cbc;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 IF SalesCrMemoLineNote = '' THEN
                                                                                   currXMLport.SKIP;
                                                                               END;
                                                                                }

    { [{07B507A9-A5FB-4F95-9648-D6DE32ECA4A6}];2 ;CreditedQuantity    ;Element ;Text    ;
                                                  NamespacePrefix=cbc }

    { [{9E7DEA3F-079B-472D-8E3C-0366493AC3C1}];3 ;unitCode            ;Attribute;Text    }

    { [{D2E418ED-38F8-457A-80DD-78DB08B627CA}];3 ;unitCodeListID      ;Attribute;Text   ;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 currXMLport.SKIP;
                                                                               END;
                                                                                }

    { [{F226C977-3523-4015-BE61-ABB366F61F10}];2 ;LineExtensionAmount ;Element ;Text    ;
                                                  VariableName=SalesCrMemoLineExtensionAmount;
                                                  NamespacePrefix=cbc }

    { [{36F49235-E300-4CA5-A3AC-457287B22839}];3 ;currencyID          ;Attribute;Text   ;
                                                  VariableName=LineExtensionAmountCurrencyID }

    { [{C94B92A2-8B3F-435A-8687-BDD3876661A0}];2 ;AccountingCost      ;Element ;Text    ;
                                                  VariableName=SalesCrMemoLineAccountingCost;
                                                  NamespacePrefix=cbc }

    { [{F04FA211-6719-4B9B-A39B-66EBCB237B03}];2 ;InvoicePeriod       ;Element ;Text    ;
                                                  VariableName=SalesCrMemoLineInvoicePeriod;
                                                  NamespacePrefix=cac;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 PEPPOLMgt.GetLineInvoicePeriodInfo(
                                                                                   InvLineInvoicePeriodStartDate,
                                                                                   InvLineInvoicePeriodEndDate);

                                                                                 IF (InvLineInvoicePeriodStartDate = '') AND (InvLineInvoicePeriodEndDate = '') THEN
                                                                                   currXMLport.SKIP;
                                                                               END;
                                                                                }

    { [{A46AE741-2E17-41C6-BD37-DE513B400F20}];3 ;StartDate           ;Element ;Text    ;
                                                  VariableName=InvLineInvoicePeriodStartDate;
                                                  NamespacePrefix=cbc }

    { [{5062A33D-8265-4C90-8545-D1D8715DDC3A}];3 ;EndDate             ;Element ;Text    ;
                                                  VariableName=InvLineInvoicePeriodEndDate;
                                                  NamespacePrefix=cbc }

    { [{C1E4B4EC-CA35-4BD5-B108-25D26797FC83}];2 ;OrderLineReference  ;Element ;Text    ;
                                                  NamespacePrefix=cac }

    { [{488E88B6-C62D-4819-BD07-704B7D12C5A1}];3 ;LineID              ;Element ;Text    ;
                                                  VariableName=OrderLineReferenceLineID;
                                                  NamespacePrefix=cbc }

    { [{FB89EA3F-A77F-4F7E-979A-3B5888164341}];2 ;BillingReference    ;Element ;Text    ;
                                                  VariableName=SalesCrMemoLnBillingReference;
                                                  NamespacePrefix=cac }

    { [{86FCD21D-1ED3-46A4-AFEE-225D06625B93}];3 ;InvoiceDocumentReference;Element;Text ;
                                                  VariableName=CrMeLnInvoiceDocumentReference;
                                                  NamespacePrefix=cac }

    { [{420B6F39-AC46-4B7F-AEB8-A342D40E3C95}];4 ;ID                  ;Element ;Text    ;
                                                  VariableName=CrMemoLnInvDocRefID;
                                                  NamespacePrefix=cbc }

    { [{7AB9F7F8-AF07-4DB7-BD96-E3F5C591249E}];3 ;CreditNoteDocumentReference;Element;Text;
                                                  VariableName=CrCreditNoteDocumentReference;
                                                  NamespacePrefix=cac }

    { [{C0981937-764F-459F-9B04-4DCBA42355F5}];4 ;ID                  ;Element ;Text    ;
                                                  VariableName=CrMemoLnCreditNoteDocRefID;
                                                  NamespacePrefix=cbc }

    { [{2BEAB190-BDF0-4000-8584-1EA535326FF7}];3 ;BillingReferenceLine;Element ;Text    ;
                                                  VariableName=CrMemoLnBillingReferenceLine>;
                                                  NamespacePrefix=cac }

    { [{85ACA34C-1C53-4883-8BB6-CBC884BDBEC1}];4 ;ID                  ;Element ;Text    ;
                                                  VariableName=SalesCrMemoLnBillingRefLineID;
                                                  NamespacePrefix=cbc }

    { [{FC51F12D-6D45-401F-A2FC-CCAE91B19033}];2 ;Delivery            ;Element ;Text    ;
                                                  VariableName=SalesCrMemoLineDelivery;
                                                  NamespacePrefix=cac;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 PEPPOLMgt.GetLineDeliveryInfo(
                                                                                   CrMemoLineActualDeliveryDate,
                                                                                   SalesCrMemoLineDeliveryID,
                                                                                   CrMemoLineDeliveryIDSchemeID);

                                                                                 PEPPOLMgt.GetLineDeliveryPostalAddr(
                                                                                   CrMemoLineDeliveryStreetName,
                                                                                   CrMemLineDeliveryAddStreetName,
                                                                                   CrMemoLineDeliveryCityName,
                                                                                   CrMemoLineDeliveryPostalZone,
                                                                                   CrMeLnDeliveryCountrySubentity,
                                                                                   CreditMemoLineDeliveryCountry,
                                                                                   CrMemLnDeliveryCountryIdCode);

                                                                                 IF (SalesCrMemoLineDeliveryID = '') AND
                                                                                    (CrMemoLineDeliveryStreetName = '') AND
                                                                                    (CrMemoLineActualDeliveryDate = '')
                                                                                 THEN
                                                                                   currXMLport.SKIP;
                                                                               END;
                                                                                }

    { [{028096C7-7B3C-4321-B301-16C8406349E4}];3 ;ActualDeliveryDate  ;Element ;Text    ;
                                                  VariableName=CrMemoLineActualDeliveryDate;
                                                  NamespacePrefix=cbc }

    { [{D9DA744A-9B1F-4828-B08A-E93610257D34}];3 ;DeliveryLocation    ;Element ;Text    ;
                                                  VariableName=CrMemoLineDeliveryLocation;
                                                  NamespacePrefix=cac }

    { [{C05964E3-0240-419E-82BF-6CFF2B84AD34}];4 ;ID                  ;Element ;Text    ;
                                                  VariableName=SalesCrMemoLineDeliveryID;
                                                  NamespacePrefix=cbc }

    { [{5F0AEB64-D78B-4908-85C1-E5362BB56A93}];5 ;schemeID            ;Attribute;Text   ;
                                                  VariableName=CrMemoLineDeliveryIDSchemeID }

    { [{F6C1DB00-C44D-4BF4-8B49-D62291EA036C}];4 ;Address             ;Element ;Text    ;
                                                  VariableName=CrMemoLineDeliveryAddress;
                                                  NamespacePrefix=cac }

    { [{0778DB2F-B252-4B3C-94BE-1BD2376A1540}];5 ;StreetName          ;Element ;Text    ;
                                                  VariableName=CrMemoLineDeliveryStreetName;
                                                  NamespacePrefix=cbc }

    { [{716471FC-6523-43AB-B85B-735BF5830D00}];5 ;AdditionalStreetName;Element ;Text    ;
                                                  VariableName=CrMemLineDeliveryAddStreetName;
                                                  NamespacePrefix=cbc }

    { [{25C199F4-3487-47F1-81A6-D8C52AF821AC}];5 ;CityName            ;Element ;Text    ;
                                                  VariableName=CrMemoLineDeliveryCityName;
                                                  NamespacePrefix=cbc }

    { [{038FB9FE-5834-4181-8F9E-6C13477C5539}];5 ;PostalZone          ;Element ;Text    ;
                                                  VariableName=CrMemoLineDeliveryPostalZone;
                                                  NamespacePrefix=cbc }

    { [{B2A5F52F-0DF1-4701-8344-6572BAD8A1ED}];5 ;CountrySubentity    ;Element ;Text    ;
                                                  VariableName=CrMeLnDeliveryCountrySubentity;
                                                  NamespacePrefix=cbc }

    { [{CF1B6BAC-BCA7-4A91-9DE6-688F9055ADD3}];5 ;Country             ;Element ;Text    ;
                                                  VariableName=CreditMemoLineDeliveryCountry;
                                                  NamespacePrefix=cac }

    { [{9153B742-7402-46BE-8071-DEFB8DAB5B43}];6 ;IdentificationCode  ;Element ;Text    ;
                                                  VariableName=CrMemLnDeliveryCountryIdCode;
                                                  NamespacePrefix=cbc }

    { [{EFD695F0-7529-46E2-BEDB-E7D23E166FFA}];7 ;listID              ;Attribute;Text   ;
                                                  VariableName=CrMemLineDeliveryCountryListID }

    { [{CD7ECE48-A0A4-43AD-9DDC-398EDBB699F4}];2 ;TaxTotal            ;Element ;Text    ;
                                                  VariableName=SalesCreditMemoLineTaxTotal;
                                                  NamespacePrefix=cac;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 PEPPOLMgt.GetLineTaxTotal(
                                                                                   SalesLine,
                                                                                   SalesHeader,
                                                                                   SalesCreditMemoLineTaxAmount,
                                                                                   currencyID);
                                                                               END;
                                                                                }

    { [{D76CBCE7-7019-44A0-8469-DA96C519D4A9}];3 ;TaxAmount           ;Element ;Text    ;
                                                  VariableName=SalesCreditMemoLineTaxAmount;
                                                  NamespacePrefix=cbc }

    { [{D136B3C8-FE34-4F91-9BEB-C6E82C08A6E3}];4 ;currencyID          ;Attribute;Text    }

    { [{18BA0953-7936-4152-9D6D-5DC61792D5F1}];2 ;AllowanceCharge     ;Element ;Table   ;
                                                  VariableName=CrMemLnAllowanceChargeLoop;
                                                  SourceTable=Table2000000026;
                                                  SourceTableView=SORTING(Field1)
                                                                  WHERE(Field1=FILTER(1..));
                                                  NamespacePrefix=cac;
                                                  Export::OnPreXMLItem=BEGIN
                                                                         CrMemLnAllowanceChargeLoop.SETRANGE(Number,1,1);
                                                                       END;

                                                  Export::OnAfterGetRecord=BEGIN
                                                                             PEPPOLMgt.GetLineAllowanceChargeInfo(
                                                                               SalesLine,
                                                                               SalesHeader,
                                                                               CrMeLnAllowanceChargeIndicator,
                                                                               CrMemLnAllowanceChargeReason,
                                                                               CrMemLnAllowanceChargeAmount,
                                                                               CrMeLnAllowanceChargeAmtCurrID);

                                                                             IF CrMeLnAllowanceChargeIndicator = '' THEN
                                                                               currXMLport.SKIP;
                                                                           END;
                                                                            }

    { [{3E7C0013-CCA8-4E46-BCBC-E7627C254860}];3 ;ChargeIndicator     ;Element ;Text    ;
                                                  VariableName=CrMeLnAllowanceChargeIndicator;
                                                  NamespacePrefix=cbc }

    { [{CEB0CD22-AC2C-47F8-9E28-DEA9D590882D}];3 ;AllowanceChargeReason;Element;Text    ;
                                                  VariableName=CrMemLnAllowanceChargeReason;
                                                  NamespacePrefix=cbc }

    { [{4C3E9FAA-465F-4A3F-B2F2-BBEA5B739123}];3 ;Amount              ;Element ;Text    ;
                                                  VariableName=CrMemLnAllowanceChargeAmount;
                                                  NamespacePrefix=cbc }

    { [{83958EAB-563D-454F-B3BD-1D560E05B706}];4 ;currencyID          ;Attribute;Text   ;
                                                  VariableName=CrMeLnAllowanceChargeAmtCurrID }

    { [{ACA7296D-E51D-4A71-8F05-78C37B74F90F}];2 ;Item                ;Element ;Text    ;
                                                  NamespacePrefix=cac;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 PEPPOLMgt.GetLineItemInfo(
                                                                                   SalesLine,
                                                                                   Description,
                                                                                   Name,
                                                                                   SellersItemIdentificationID,
                                                                                   StandardItemIdentificationID,
                                                                                   StdItemIdIDSchemeID,
                                                                                   OriginCountryIdCode,
                                                                                   OriginCountryIdCodeListID);
                                                                               END;
                                                                                }

    { [{2E2F5668-50F8-4607-B140-BF5C20805EB2}];3 ;Description         ;Element ;Text    ;
                                                  NamespacePrefix=cbc;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 IF Description = '' THEN
                                                                                   currXMLport.SKIP;
                                                                               END;
                                                                                }

    { [{D3ACD46B-4255-49A1-8067-4CA55CA13CEE}];3 ;Name                ;Element ;Text    ;
                                                  NamespacePrefix=cbc }

    { [{B1F2487F-AD60-45CE-8818-2D589D17F8EF}];3 ;SellersItemIdentification;Element;Text;
                                                  NamespacePrefix=cac;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 IF SellersItemIdentificationID = '' THEN
                                                                                   currXMLport.SKIP;
                                                                               END;
                                                                                }

    { [{5D8DC44E-8467-4A04-B0D9-A0C1A28FE491}];4 ;ID                  ;Element ;Text    ;
                                                  VariableName=SellersItemIdentificationID;
                                                  NamespacePrefix=cbc }

    { [{8F9A8C0A-A213-4B9D-84DA-64C0B6EDC94C}];3 ;StandardItemIdentification;Element;Text;
                                                  NamespacePrefix=cac;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 IF StandardItemIdentificationID = '' THEN
                                                                                   currXMLport.SKIP;
                                                                               END;
                                                                                }

    { [{EBE2D393-ABC7-4B6F-AB26-90603B558A36}];4 ;ID                  ;Element ;Text    ;
                                                  VariableName=StandardItemIdentificationID;
                                                  NamespacePrefix=cbc }

    { [{0284FCF9-7668-41D7-A3EF-100DF78BABEF}];5 ;schemeID            ;Attribute;Text   ;
                                                  VariableName=StdItemIdIDSchemeID }

    { [{0AE49AA6-E9D4-4C43-936D-CADE715B2CB6}];3 ;OriginCountry       ;Element ;Text    ;
                                                  NamespacePrefix=cac;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 IF OriginCountryIdCode = '' THEN
                                                                                   currXMLport.SKIP;
                                                                               END;
                                                                                }

    { [{D4352CEA-6EFD-42E1-8E40-478989FC9D77}];4 ;IdentificationCode  ;Element ;Text    ;
                                                  VariableName=OriginCountryIdCode;
                                                  NamespacePrefix=cbc }

    { [{8CE88311-B5FA-4879-9888-5E5D1D897E50}];5 ;listID              ;Attribute;Text   ;
                                                  VariableName=OriginCountryIdCodeListID }

    { [{B15F7E02-C11D-480C-866C-B8D47A5FDBD8}];3 ;CommodityClassification;Element;Table ;
                                                  VariableName=CommodityClassificationLoop;
                                                  SourceTable=Table2000000026;
                                                  SourceTableView=SORTING(Field1)
                                                                  WHERE(Field1=FILTER(1..));
                                                  NamespacePrefix=cac;
                                                  Export::OnPreXMLItem=BEGIN
                                                                         CommodityClassificationLoop.SETRANGE(Number,1,1);
                                                                       END;

                                                  Export::OnAfterGetRecord=BEGIN
                                                                             PEPPOLMgt.GetLineItemCommodityClassficationInfo(
                                                                               CommodityCode,
                                                                               CommodityCodeListID,
                                                                               ItemClassificationCode,
                                                                               ItemClassificationCodeListID);

                                                                             IF (CommodityCode = '') AND (ItemClassificationCode = '') THEN
                                                                               currXMLport.SKIP;
                                                                           END;
                                                                            }

    { [{46E02559-3D5D-4D43-AAEA-CD2CAF842816}];4 ;CommodityCode       ;Element ;Text    ;
                                                  NamespacePrefix=cbc;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 IF CommodityCode = '' THEN
                                                                                   currXMLport.SKIP;
                                                                               END;
                                                                                }

    { [{23A42FB8-BD18-4485-B5C7-9E9659CFF089}];5 ;listID              ;Attribute;Text   ;
                                                  VariableName=CommodityCodeListID }

    { [{C089B074-19C8-45B4-8D35-87257D37087D}];4 ;ItemClassificationCode;Element;Text   ;
                                                  NamespacePrefix=cbc;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 IF ItemClassificationCode = '' THEN
                                                                                   currXMLport.SKIP;
                                                                               END;
                                                                                }

    { [{4EBF4F70-428B-441E-A195-B96F9133CBFC}];5 ;listID              ;Attribute;Text   ;
                                                  VariableName=ItemClassificationCodeListID }

    { [{0B374529-2A4D-49E1-B98C-5526BF9D9C32}];3 ;ClassifiedTaxCategory;Element;Text    ;
                                                  NamespacePrefix=cac;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 PEPPOLMgt.GetLineItemClassfiedTaxCategory(
                                                                                   SalesLine,
                                                                                   ClassifiedTaxCategoryID,
                                                                                   ItemSchemeID,
                                                                                   SalesCreditMemoLineTaxPercent,
                                                                                   ClassifiedTaxCategorySchemeID);
                                                                               END;
                                                                                }

    { [{76D7FA34-CC1B-4387-973D-EC8B0F602184}];4 ;ID                  ;Element ;Text    ;
                                                  VariableName=ClassifiedTaxCategoryID;
                                                  NamespacePrefix=cbc }

    { [{EB9A6A7B-6A41-474C-8BBE-79E118358EC0}];5 ;schemeID            ;Attribute;Text   ;
                                                  VariableName=ItemSchemeID }

    { [{2E586EB8-67A3-4D22-8E19-BA5B1C567584}];4 ;Percent             ;Element ;Text    ;
                                                  VariableName=SalesCreditMemoLineTaxPercent;
                                                  NamespacePrefix=cbc }

    { [{98AE7FD9-ED6D-4BCC-866E-F6B5D2B4D522}];4 ;TaxScheme           ;Element ;Text    ;
                                                  VariableName=ClassifiedTaxCategoryTaxScheme;
                                                  NamespacePrefix=cac }

    { [{7493DA79-6AFC-41F8-A486-174426FF2EED}];5 ;ID                  ;Element ;Text    ;
                                                  VariableName=ClassifiedTaxCategorySchemeID;
                                                  NamespacePrefix=cbc }

    { [{AA0FC164-641A-4FEA-9A99-51C4B840CE74}];3 ;AdditionalItemProperty;Element;Table  ;
                                                  VariableName=AdditionalItemPropertyLoop;
                                                  SourceTable=Table2000000026;
                                                  SourceTableView=SORTING(Field1)
                                                                  WHERE(Field1=FILTER(1..));
                                                  NamespacePrefix=cac;
                                                  Export::OnPreXMLItem=BEGIN
                                                                         AdditionalItemPropertyLoop.SETRANGE(Number,1,1);
                                                                       END;

                                                  Export::OnAfterGetRecord=BEGIN
                                                                             PEPPOLMgt.GetLineAdditionalItemPropertyInfo(
                                                                               SalesLine,
                                                                               AdditionalItemPropertyName,
                                                                               AdditionalItemPropertyValue);

                                                                             IF AdditionalItemPropertyName = '' THEN
                                                                               currXMLport.SKIP;
                                                                           END;
                                                                            }

    { [{2FD7CDA0-2AA4-4ED0-977E-527F857AAFB5}];4 ;Name                ;Element ;Text    ;
                                                  VariableName=AdditionalItemPropertyName;
                                                  NamespacePrefix=cbc }

    { [{64759488-6947-43FE-9677-13CDD538F599}];4 ;Value               ;Element ;Text    ;
                                                  VariableName=AdditionalItemPropertyValue;
                                                  NamespacePrefix=cbc }

    { [{2433D6B5-8FC5-4FE3-BA31-BAE9C9045395}];2 ;Price               ;Element ;Text    ;
                                                  VariableName=SalesCreditMemoLinePrice;
                                                  NamespacePrefix=cac;
                                                  Export::OnBeforePassVariable=BEGIN
                                                                                 PEPPOLMgt.GetLinePriceInfo(
                                                                                   SalesLine,
                                                                                   SalesHeader,
                                                                                   SalesCreditMemoLinePriceAmount,
                                                                                   CrMemLinePriceAmountCurrencyID,
                                                                                   BaseQuantity,
                                                                                   UnitCodeBaseQty);
                                                                               END;
                                                                                }

    { [{9F8E303C-D885-4800-8127-4E1D79A1DF3C}];3 ;PriceAmount         ;Element ;Text    ;
                                                  VariableName=SalesCreditMemoLinePriceAmount;
                                                  NamespacePrefix=cbc }

    { [{58D2614F-230C-45B4-964A-68BC63710A49}];4 ;currencyID          ;Attribute;Text   ;
                                                  VariableName=CrMemLinePriceAmountCurrencyID }

    { [{6C453197-C3CD-428B-89D0-70F1684156DA}];3 ;BaseQuantity        ;Element ;Text    ;
                                                  NamespacePrefix=cbc }

    { [{0C6C3330-E263-4C94-872C-49C51F6766A7}];4 ;unitCode            ;Attribute;Text   ;
                                                  VariableName=UnitCodeBaseQty }

    { [{6CE41BEB-8BE1-42D9-9D3D-A11DDB16FD29}];3 ;AllowanceCharge     ;Element ;Table   ;
                                                  VariableName=PriceAllowanceChargeLoop;
                                                  SourceTable=Table2000000026;
                                                  SourceTableView=SORTING(Field1)
                                                                  WHERE(Field1=FILTER(1..));
                                                  NamespacePrefix=cac;
                                                  Export::OnPreXMLItem=BEGIN
                                                                         PriceAllowanceChargeLoop.SETRANGE(Number,1,1);
                                                                       END;

                                                  Export::OnAfterGetRecord=BEGIN
                                                                             PEPPOLMgt.GetLinePriceAllowanceChargeInfo(
                                                                               PriceChargeIndicator,
                                                                               PriceAllowanceChargeAmount,
                                                                               PriceAllowanceAmountCurrencyID,
                                                                               PriceAllowanceChargeBaseAmount,
                                                                               PriceAllowChargeBaseAmtCurrID);

                                                                             IF PriceChargeIndicator = '' THEN
                                                                               currXMLport.SKIP;
                                                                           END;
                                                                            }

    { [{C6D66E8D-358F-4BF3-A5A8-2637F51FAD1C}];4 ;ChargeIndicator     ;Element ;Text    ;
                                                  VariableName=PriceChargeIndicator;
                                                  NamespacePrefix=cbc }

    { [{C0E743D0-671B-44EF-A6EF-670B0067528F}];4 ;Amount              ;Element ;Text    ;
                                                  VariableName=PriceAllowanceChargeAmount;
                                                  NamespacePrefix=cbc }

    { [{39930BDD-49E2-4007-93C5-23E3D895036A}];5 ;currencyID          ;Attribute;Text   ;
                                                  VariableName=PriceAllowanceAmountCurrencyID }

    { [{48068C24-F364-4F99-A685-2A1DD6277081}];4 ;BaseAmount          ;Element ;Text    ;
                                                  VariableName=PriceAllowanceChargeBaseAmount;
                                                  NamespacePrefix=cbc }

    { [{EBAD0E2F-B6D5-45F7-A205-999CD65300A5}];5 ;currencyID          ;Attribute;Text   ;
                                                  VariableName=PriceAllowChargeBaseAmtCurrID }

  }
  EVENTS
  {
  }
  REQUESTPAGE
  {
    PROPERTIES
    {
    }
    CONTROLS
    {
      { 1   ;    ;Container ;
                  ContainerType=ContentArea }

      { 2   ;1   ;Group     ;
                  GroupType=Group }

      { 3   ;2   ;Field     ;
                  CaptionML=[DAN=Salgskreditnotanr.;
                             ENU=Sales Credit Memo No.];
                  SourceExpr=SalesCrMemoHeader."No.";
                  TableRelation="Sales Cr.Memo Header" }

    }
  }
  CODE
  {
    VAR
      GLSetup@1006 : Record 98;
      TempVATAmtLine@1002 : TEMPORARY Record 290;
      ServiceCrMemoHeader@1000 : Record 5994;
      ServiceCrMemoLine@1001 : Record 5995;
      SalesCrMemoHeader@1004 : Record 114;
      SalesCrMemoLine@1005 : Record 115;
      SalesHeader@1022 : Record 36;
      SalesLine@1021 : Record 37;
      PEPPOLMgt@1020 : Codeunit 1605;
      DummyVar@1023 : Text;
      SpecifyASalesCreditMemoNoErr@1014 : TextConst 'DAN=Du skal angive et salgskreditnotanummer.;ENU=You must specify a sales credit memo number.';
      SpecifyAServCreditMemoNoErr@1010 : TextConst 'DAN=Du skal angive et servicefakturanummer.;ENU=You must specify a service invoice number.';
      UnSupportedTableTypeErr@1009 : TextConst '@@@=%1 is the table.;DAN=Tabellen %1 underst�ttes ikke.;ENU=The %1 table is not supported.';
      ProcessedDocType@1008 : 'Sale,Service';

    [External]
    PROCEDURE GetTotals@39();
    BEGIN
      CASE ProcessedDocType OF
        ProcessedDocType::Sale:
          WITH SalesCrMemoLine DO BEGIN
            SETRANGE("Document No.",SalesCrMemoHeader."No.");
            IF FINDSET THEN
              REPEAT
                SalesLine.TRANSFERFIELDS(SalesCrMemoLine);
                PEPPOLMgt.GetTotals(SalesLine,TempVATAmtLine);
              UNTIL NEXT = 0;
          END;
        ProcessedDocType::Service:
          WITH ServiceCrMemoLine DO BEGIN
            SETRANGE("Document No.",ServiceCrMemoHeader."No.");
            IF FINDSET THEN
              REPEAT
                PEPPOLMgt.TransferLineToSalesLine(ServiceCrMemoLine,SalesLine);
                SalesLine.Type := PEPPOLMgt.MapServiceLineTypeToSalesLineType(Type);
                PEPPOLMgt.GetTotals(SalesLine,TempVATAmtLine);
              UNTIL NEXT = 0;
          END;
      END;
    END;

    LOCAL PROCEDURE FindNextCreditMemoRec@80(Position@1000 : Integer) : Boolean;
    VAR
      PEPPOLValidation@1002 : Codeunit 1620;
      Found@1001 : Boolean;
    BEGIN
      CASE ProcessedDocType OF
        ProcessedDocType::Sale:
          BEGIN
            IF Position = 1 THEN
              Found := SalesCrMemoHeader.FIND('-')
            ELSE
              Found := SalesCrMemoHeader.NEXT <> 0;
            IF Found THEN BEGIN
              SalesHeader.TRANSFERFIELDS(SalesCrMemoHeader);
              PEPPOLValidation.CheckSalesCreditMemo(SalesCrMemoHeader);
            END;
          END;
        ProcessedDocType::Service:
          BEGIN
            IF Position = 1 THEN
              Found := ServiceCrMemoHeader.FIND('-')
            ELSE
              Found := ServiceCrMemoHeader.NEXT <> 0;
            IF Found THEN BEGIN
              PEPPOLMgt.TransferHeaderToSalesHeader(ServiceCrMemoHeader,SalesHeader);
              PEPPOLValidation.CheckServiceCreditMemo(ServiceCrMemoHeader);
            END;
          END;
      END;

      SalesHeader."Document Type" := SalesHeader."Document Type"::"Credit Memo";

      EXIT(Found);
    END;

    LOCAL PROCEDURE FindNextCreditMemoLineRec@84(Position@1000 : Integer) : Boolean;
    VAR
      Found@1001 : Boolean;
    BEGIN
      CASE ProcessedDocType OF
        ProcessedDocType::Sale:
          BEGIN
            IF Position = 1 THEN
              Found := SalesCrMemoLine.FIND('-')
            ELSE
              Found := SalesCrMemoLine.NEXT <> 0;
            IF Found THEN
              SalesLine.TRANSFERFIELDS(SalesCrMemoLine);
          END;
        ProcessedDocType::Service:
          BEGIN
            IF Position = 1 THEN
              Found := ServiceCrMemoLine.FIND('-')
            ELSE
              Found := ServiceCrMemoLine.NEXT <> 0;
            IF Found THEN BEGIN
              PEPPOLMgt.TransferLineToSalesLine(ServiceCrMemoLine,SalesLine);
              SalesLine.Type := PEPPOLMgt.MapServiceLineTypeToSalesLineType(ServiceCrMemoLine.Type);
            END;
          END;
      END;

      EXIT(Found);
    END;

    LOCAL PROCEDURE FindNextVATAmtRec@108(VAR VATAmtLine@1001 : Record 290;Position@1000 : Integer) : Boolean;
    BEGIN
      IF Position = 1 THEN
        EXIT(VATAmtLine.FIND('-'));
      EXIT(VATAmtLine.NEXT <> 0);
    END;

    [External]
    PROCEDURE Initialize@1(DocVariant@1000 : Variant);
    VAR
      RecRef@1001 : RecordRef;
    BEGIN
      RecRef.GETTABLE(DocVariant);
      CASE RecRef.NUMBER OF
        DATABASE::"Sales Cr.Memo Header":
          BEGIN
            RecRef.SETTABLE(SalesCrMemoHeader);
            IF SalesCrMemoHeader."No." = '' THEN
              ERROR(SpecifyASalesCreditMemoNoErr);
            SalesCrMemoHeader.SETRECFILTER;
            SalesCrMemoLine.SETRANGE("Document No.",SalesCrMemoHeader."No.");

            ProcessedDocType := ProcessedDocType::Sale;
          END;
        DATABASE::"Service Cr.Memo Header":
          BEGIN
            RecRef.SETTABLE(ServiceCrMemoHeader);
            IF ServiceCrMemoHeader."No." = '' THEN
              ERROR(SpecifyAServCreditMemoNoErr);
            ServiceCrMemoHeader.SETRECFILTER;
            ServiceCrMemoLine.SETRANGE("Document No.",ServiceCrMemoHeader."No.");

            ProcessedDocType := ProcessedDocType::Service;
          END;
        ELSE
          ERROR(UnSupportedTableTypeErr,RecRef.NUMBER);
      END;
    END;

    LOCAL PROCEDURE GetUBLVersionID@93() : Text;
    BEGIN
      EXIT('2.1')
    END;

    LOCAL PROCEDURE GetCustomizationID@9() : Text;
    BEGIN
      EXIT('urn:www.cenbii.eu:transaction:biitrns014:ver2.0:extended:urn:www.peppol.eu:bis:peppol5a:ver2.0');
    END;

    LOCAL PROCEDURE GetProfileID@10() : Text;
    BEGIN
      EXIT('urn:www.cenbii.eu:profile:bii05:ver2.0');
    END;

    BEGIN
    END.
  }
}

